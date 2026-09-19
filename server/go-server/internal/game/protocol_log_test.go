package game

import (
	"bytes"
	"encoding/json"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"log"
	"strings"
	"testing"
)

func TestStageResultTraceUsesRoomMode(t *testing.T) {
	_, s, _, _ := combatFixture()
	var output bytes.Buffer
	s.Trace = log.New(&output, "", 0)
	p := make([]byte, 500)
	protocol.WriteUint64(p, 0, s.UID)
	protocol.WriteUint32(p, 92, 25)
	protocol.WriteUint32(p, 96, 125)
	for _, mode := range []protocol.RoomType{protocol.StageAssault, protocol.FreePractice} {
		s.Room.Request[46] = byte(mode)
		for _, direction := range []string{"S->C queued", "C->S"} {
			output.Reset()
			s.tracePacket(direction, 1, "game", 4120, p, false)
			var entry map[string]any
			if err := json.Unmarshal(output.Bytes(), &entry); err != nil {
				t.Fatal(err)
			}
			text, annotated := entry["content"].(string)
			if annotated != (mode == protocol.StageAssault && direction == "S->C queued") {
				t.Fatal("misclassified result", entry)
			}
			if annotated && (!strings.Contains(text, "波数=25") || !strings.Contains(text, "用时秒=125")) {
				t.Fatal(text)
			}
			if len(entry["hex"].(string)) != 1000 {
				t.Fatal("raw result lost")
			}
		}
	}
}

func TestStageWaveTraceDirectionAndRawPayload(t *testing.T) {
	_, s, _, _ := waitingRoomFixture()
	var output bytes.Buffer
	s.Trace = log.New(&output, "", 0)
	p := make([]byte, 40)
	protocol.WriteUint32(p, 8, 0xffffffff)
	for _, direction := range []string{"C->S", "S->C"} {
		output.Reset()
		s.tracePacket(direction, 1, "game", 20572, p, false)
		var entry map[string]any
		if err := json.Unmarshal(output.Bytes(), &entry); err != nil {
			t.Fatal(err)
		}
		_, annotated := entry["content"]
		if annotated != (direction == "S->C") || len(entry["hex"].(string)) != 80 {
			t.Fatal("direction or original payload lost", entry)
		}
	}
	for _, direction := range []string{"C->S", "S->C"} {
		output.Reset()
		s.tracePacket(direction, 1, "game", 20571, p, false)
		var entry map[string]any
		if err := json.Unmarshal(output.Bytes(), &entry); err != nil {
			t.Fatal(err)
		}
		_, annotated := entry["content"]
		if annotated != (direction == "C->S") || len(entry["hex"].(string)) != 80 {
			t.Fatal(entry)
		}
	}
}

func TestPVEActorTrace(t *testing.T) {
	_, s, _, _ := waitingRoomFixture()
	var output bytes.Buffer
	s.Trace = log.New(&output, "", 0)
	for _, tc := range []struct {
		id   uint32
		size int
	}{{20400, 67}, {20401, 47}} {
		p := make([]byte, tc.size)
		protocol.WriteUint32(p, 0, tc.id)
		protocol.WriteUint64(p, 4, 123)
		protocol.WriteUint64(p, 39, 456)
		output.Reset()
		s.tracePacket("C->S", 1, "game", 8071, p, false)
		var entry map[string]any
		if err := json.Unmarshal(output.Bytes(), &entry); err != nil {
			t.Fatal(err)
		}
		content, _ := entry["content"].(string)
		if !strings.Contains(content, "实体=456") || entry["subprotocol"] != float64(tc.id) || len(entry["hex"].(string)) != tc.size*2 {
			t.Fatal(entry)
		}
	}
}

func TestCreateRoomTraceNamesPVEWithoutGrantingAccess(t *testing.T) {
	_, s, _, _ := waitingRoomFixture()
	var output bytes.Buffer
	s.Trace = log.New(&output, "", 0)
	p := make([]byte, protocol.RoomRequestSize)
	p[protocol.RoomTypeOffset], p[protocol.RoomCapacityOffset] = byte(protocol.StageAssault), 4
	protocol.WriteUint32(p, protocol.RoomMapOffset, 9170)
	s.tracePacket("C->S", 1, "game", protocol.MsgCreateRoom, p, false)
	var entry map[string]any
	if err := json.Unmarshal(output.Bytes(), &entry); err != nil {
		t.Fatal(err)
	}
	text, _ := entry["content"].(string)
	for _, want := range []string{"波次PVE", "尚未开放", "地图=9170", "容量=4", "不代表已获准"} {
		if !strings.Contains(text, want) {
			t.Fatal("missing room request diagnostic", text)
		}
	}
	if len(entry["hex"].(string)) != len(p)*2 {
		t.Fatal("lost raw request")
	}
}

func TestProtocolTraceReassemblesAndLogsEveryRecipient(t *testing.T) {
	hub, a, b, _ := waitingRoomFixture()
	var output bytes.Buffer
	logger := log.New(&output, "", 0)
	a.Trace = logger
	b.Trace = logger
	a.Account = "localtest1"
	b.Account = "localtest2"
	packet, _ := protocol.Encode(protocol.Message{ID: 99999, Payload: []byte{1, 2, 3}})
	if err := hub.Handle(a, tunnel.Frame{Op: "data", Channel: 1, Data: packet[:9]}); err != nil {
		t.Fatal(err)
	}
	if output.Len() != 0 {
		t.Fatal("partial packet logged as complete")
	}
	rest := append(bytes.Clone(packet[9:]), packet...)
	if err := hub.Handle(a, tunnel.Frame{Op: "data", Channel: 1, Data: rest}); err != nil {
		t.Fatal(err)
	}
	hub.broadcast(a.Room, protocol.Message{ID: 3250, Payload: []byte{4, 5, 6}}, 0)
	lines := strings.Split(strings.TrimSpace(output.String()), "\n")
	if len(lines) != 4 {
		t.Fatalf("expected 2 input packets and 2 recipient packets, got %d", len(lines))
	}
	seen := map[string]bool{}
	for i, line := range lines {
		var entry map[string]any
		if err := json.Unmarshal([]byte(line), &entry); err != nil {
			t.Fatal(err)
		}
		for _, key := range []string{"time", "direction", "account", "player", "uid", "protocol", "hex", "length"} {
			if _, ok := entry[key]; !ok {
				t.Fatal("missing", key)
			}
		}
		if i < 2 && (entry["hex"] != "010203" || entry["protocol"] != float64(99999)) {
			t.Fatal("payload changed")
		}
		if i >= 2 {
			seen[entry["account"].(string)] = true
		}
	}
	if !seen["localtest1"] || !seen["localtest2"] {
		t.Fatal("missing recipient identity")
	}
}

func TestProtocolTraceRedactsSDKAndKeepsFullUDP(t *testing.T) {
	var output bytes.Buffer
	s := &Session{Trace: log.New(&output, "", 0), Channels: map[uint32]*Channel{1: {Kind: "sdk"}}}
	s.tracePacket("C->S", 1, "sdk", 1001, []byte("secret-password"), true)
	s.traceFrame("S->C queued", tunnel.Frame{Op: "data", Channel: 1, Data: protocol.LoginEncode(protocol.Message{ID: 1002, Payload: []byte("secret-token")})})
	if strings.Contains(output.String(), "736563726574") || strings.Contains(output.String(), "secret-password") || strings.Contains(output.String(), "secret-token") {
		t.Fatal("credentials exposed")
	}
	output.Reset()
	payload := bytes.Repeat([]byte{0xAB}, 8192)
	protocol.WriteUint16(payload, 2, 1008)
	s.traceFrame("C->S", tunnel.Frame{Op: "udp", Data: payload})
	var entry map[string]any
	if err := json.Unmarshal(output.Bytes(), &entry); err != nil {
		t.Fatal(err)
	}
	if len(entry["hex"].(string)) != 2*len(payload) || entry["protocol"] != float64(1008) {
		t.Fatal("UDP truncated")
	}
}

func TestKickTraceAndRejectionAreReadableWithoutLosingRawBytes(t *testing.T) {
	var output bytes.Buffer
	s := &Session{Trace: log.New(&output, "", 0)}
	p := append(protocol.Uint64Bytes(42), 1)
	s.tracePacket("C->S", 1, "game", protocol.MsgKickRoomPlayer, p, false)
	var row map[string]any
	if err := json.Unmarshal(output.Bytes(), &row); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(row["content"].(string), "UID=42") || row["hex"] != "2a0000000000000001" {
		t.Fatal(row)
	}
	output.Reset()
	m := notice("只有房主可以踢出玩家。")
	s.tracePacket("S->C queued", 1, "game", m.ID, m.Payload, false)
	if err := json.Unmarshal(output.Bytes(), &row); err != nil {
		t.Fatal(err)
	}
	if row["content"] != "只有房主可以踢出玩家。" || len(row["hex"].(string)) != 430 {
		t.Fatal(row)
	}
	output.Reset()
	m.Payload[12] = 255
	s.tracePacket("S->C", 1, "game", m.ID, m.Payload, false)
	row = map[string]any{}
	if err := json.Unmarshal(output.Bytes(), &row); err != nil {
		t.Fatal(err)
	}
	if _, exists := row["content"]; exists {
		t.Fatal("decoded malformed notice")
	}
}

func TestRenewalTraceIsDiagnosticAndPreservesRawPacket(t *testing.T) {
	p := make([]byte, 173)
	protocol.WriteUint32(p, 0, 42)
	protocol.WriteUint32(p, 4, 105)
	protocol.WriteUint32(p, 149, 253013)
	protocol.WriteUint32(p, 161, 1000)
	for _, tc := range []struct {
		direction, transport string
		payload              []byte
		want                 bool
	}{
		{"C->S", "game", p, true},
		{"S->C queued", "game", p, false},
		{"C->S", "sdk", p, false},
		{"C->S", "game", p[:172], false},
	} {
		var output bytes.Buffer
		s := &Session{Trace: log.New(&output, "", 0)}
		s.tracePacket(tc.direction, 1, tc.transport, protocol.MsgRenewItem, tc.payload, false)
		var row map[string]any
		if err := json.Unmarshal(output.Bytes(), &row); err != nil {
			t.Fatal(err)
		}
		content, ok := row["content"].(string)
		if ok != tc.want || len(row["hex"].(string)) != len(tc.payload)*2 {
			t.Fatal(row)
		}
		if tc.want && (!strings.Contains(content, "库存实例=42") || !strings.Contains(content, "申报金额=1000（不代表已扣款）")) {
			t.Fatal(content)
		}
	}
}

func TestWatchTracePreservesUnknownPayload(t *testing.T) {
	for _, tc := range []struct {
		id                   uint32
		direction, transport string
		want                 bool
	}{
		{protocol.MsgWatchGameRequest, "C->S", "game", true},
		{protocol.MsgWatchGameAck, "S->C queued", "game", true},
		{protocol.MsgWatchGameRequest, "S->C", "game", false},
		{protocol.MsgWatchGameAck, "C->S", "game", false},
		{protocol.MsgWatchGameRequest, "C->S", "sdk", false},
	} {
		var output bytes.Buffer
		s := &Session{Trace: log.New(&output, "", 0)}
		s.tracePacket(tc.direction, 1, tc.transport, tc.id, []byte{0, 255, 3}, false)
		var row map[string]any
		if err := json.Unmarshal(output.Bytes(), &row); err != nil {
			t.Fatal(err)
		}
		_, ok := row["content"]
		if ok != tc.want || row["hex"] != "00ff03" {
			t.Fatal(row)
		}
	}
}

func TestJoinTraceDistinguishesSpectatorFromPlayer(t *testing.T) {
	for _, tc := range []struct {
		mode byte
		want string
	}{{0, "参战"}, {1, "观战"}, {255, "未确认模式255"}} {
		p := make([]byte, 14)
		protocol.WriteUint16(p, 0, 42)
		p[2] = tc.mode
		var output bytes.Buffer
		s := &Session{Trace: log.New(&output, "", 0)}
		s.tracePacket("C->S", 1, "game", protocol.MsgJoinRoom, p, false)
		var row map[string]any
		if err := json.Unmarshal(output.Bytes(), &row); err != nil {
			t.Fatal(err)
		}
		content, _ := row["content"].(string)
		if !strings.Contains(content, tc.want) || !strings.Contains(content, "房间=42") || len(row["hex"].(string)) != 28 {
			t.Fatal(row)
		}
	}
}

func TestRoomMemberTraceDirectionAndRawBytes(t *testing.T) {
	p := make([]byte, 149)
	p[0] = 42
	p[8] = 8
	p[76] = 1
	for _, tc := range []struct {
		direction, transport string
		want                 bool
	}{{"S->C queued", "game", true}, {"C->S", "game", false}, {"S->C", "sdk", false}} {
		var output bytes.Buffer
		s := &Session{Trace: log.New(&output, "", 0)}
		s.tracePacket(tc.direction, 1, tc.transport, 3090, p, false)
		var row map[string]any
		if err := json.Unmarshal(output.Bytes(), &row); err != nil {
			t.Fatal(err)
		}
		content, ok := row["content"].(string)
		if ok != tc.want || len(row["hex"].(string)) != 298 || (tc.want && !strings.Contains(content, "UID=42 观战")) {
			t.Fatal(row)
		}
	}
}

func TestInputReadyTraceKeepsUntrustedClientValue(t *testing.T) {
	p := make([]byte, 14)
	protocol.WriteUint16(p, 0, 7)
	protocol.WriteUint64(p, 2, 42)
	protocol.WriteUint32(p, 10, 0xffffffff)
	var output bytes.Buffer
	s := &Session{Trace: log.New(&output, "", 0)}
	s.tracePacket("C->S", 1, "game", protocol.MsgBattleInputReady, p, false)
	var row map[string]any
	if err := json.Unmarshal(output.Bytes(), &row); err != nil {
		t.Fatal(err)
	}
	content, _ := row["content"].(string)
	if !strings.Contains(content, "房间=7，申报UID=42") || !strings.Contains(content, "4294967295") || len(row["hex"].(string)) != 28 {
		t.Fatal(row)
	}
}

func TestNetworkDelayTraceDirectionAndRawBytes(t *testing.T) {
	start := make([]byte, 53)
	protocol.WriteUint32(start, 0, 9)
	protocol.WriteUint16(start, 11, 2)
	protocol.WriteUint32(start, 13, 125)
	for _, tc := range []struct {
		id        uint32
		direction string
		payload   []byte
		want      string
	}{
		{4080, "S->C queued", start, "延迟(ms)=[125 0 0 0 0 0 0 0]"},
		{4080, "C->S", start, ""},
		{4080, "S->C", start[:52], ""},
		{4150, "S->C", nil, "等待本玩家"},
		{4150, "C->S", nil, ""},
		{4140, "C->S", nil, "不代表检测已通过"},
		{4140, "S->C", nil, ""},
		{4140, "C->S", []byte{1}, ""},
	} {
		var output bytes.Buffer
		s := &Session{Account: "tester", UID: 42, Trace: log.New(&output, "", 0)}
		s.tracePacket(tc.direction, 3, "game", tc.id, tc.payload, false)
		var row map[string]any
		if err := json.Unmarshal(output.Bytes(), &row); err != nil {
			t.Fatal(err)
		}
		content, ok := row["content"].(string)
		if ok != (tc.want != "") || (ok && !strings.Contains(content, tc.want)) || row["account"] != "tester" || len(row["hex"].(string)) != len(tc.payload)*2 {
			t.Fatal(row)
		}
	}
}
