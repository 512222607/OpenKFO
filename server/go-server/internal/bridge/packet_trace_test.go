package bridge

import (
	"bytes"
	"encoding/json"
	"io"
	"log"
	"strings"
	"testing"
	"time"

	"kungfu.local/server/internal/protocol"
)

func TestPacketTraceSplitCoalescedAndWriteOutcome(t *testing.T) {
	var output bytes.Buffer
	oldWriter, oldFlags := log.Writer(), log.Flags()
	log.SetOutput(&output)
	log.SetFlags(0)
	defer func() { log.SetOutput(oldWriter); log.SetFlags(oldFlags) }()
	trace := &packetTrace{account: "localtest2", uid: 10002, channel: 3}
	join, _ := protocol.Encode(protocol.Message{ID: 3070, Payload: make([]byte, 14)})
	refresh, _ := protocol.Encode(protocol.Message{ID: 2260, Payload: []byte{1, 1, 0x88}})
	if len(trace.decode(join[:7])) != 0 {
		t.Fatal("partial packet emitted")
	}
	packets := trace.decode(append(bytes.Clone(join[7:]), refresh...))
	at := time.Date(2026, 9, 18, 12, 0, 0, 123456000, time.FixedZone("CST", 8*3600))
	trace.record("native_read", at, packets, nil)
	trace.record("server_write_failed", at.Add(time.Millisecond), packets, io.ErrClosedPipe)
	lines := strings.Split(strings.TrimSpace(output.String()), "\n")
	if len(lines) != 4 {
		t.Fatalf("got %d records", len(lines))
	}
	for i, line := range lines {
		var r map[string]any
		if err := json.Unmarshal([]byte(line), &r); err != nil {
			t.Fatal(err)
		}
		if r["account"] != "localtest2" || r["uid"] != float64(10002) || r["channel"] != float64(3) {
			t.Fatal("identity lost")
		}
		if i == 1 && (r["hex"] != "010188" || r["protocol"] != float64(2260) || r["time"] != at.Format(time.RFC3339Nano)) {
			t.Fatal("payload or socket timestamp changed")
		}
		if i >= 2 && (r["event"] != "server_write_failed" || r["error"] == nil) {
			t.Fatal("failed write reported as complete")
		}
	}
	var disabled *packetTrace
	if disabled.decode(refresh) != nil {
		t.Fatal("disabled decoder returned data")
	}
	disabled.record("native_read", at, packets, nil)
}
