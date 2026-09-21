package game

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"kungfu.local/server/internal/protocol"
	"log"
	"strings"
	"testing"
	"time"
)

func TestPeerProbeLogCapturedPair(t *testing.T) {
	var output bytes.Buffer
	h := NewHub(nil, Config{})
	h.Trace = log.New(&output, "", 0)
	r := &Room{ID: 1, Serial: 7}
	a := &Session{UID: 10001, Account: "a", Room: r}
	b := &Session{UID: 1004, Account: "b", Room: r}
	// Real native UDP inner frame, 10000 / 24 bytes, sequence 352.
	body, _ := hex.DecodeString("eeaaa08828000000b0084f616e31a6643230ee5486c0ff46aa12ac6b8fc0ff46aa12acc88fc0ff46a8124c617e316664")
	before := bytes.Clone(body)
	at := time.Unix(100, 0)
	h.observePeerProbe(a, b, body, at)
	h.observePeerProbe(a, b, body, at.Add(time.Millisecond)) // duplicate must not reset start
	h.observePeerProbe(b, a, body, at.Add(65*time.Millisecond))
	h.observePeerProbe(b, a, body, at.Add(70*time.Millisecond))
	lines := strings.Split(strings.TrimSpace(output.String()), "\n")
	if len(lines) != 2 {
		t.Fatalf("expected request/reply: %s", output.String())
	}
	var entry map[string]any
	if err := json.Unmarshal([]byte(lines[1]), &entry); err != nil {
		t.Fatal(err)
	}
	if entry["event"] != "peer_probe_reply" || entry["server_observed_ms"] != float64(65) || entry["client_rtt_available"] != false || entry["from_account"] != "b" {
		t.Fatal(entry)
	}
	if !bytes.Equal(body, before) {
		t.Fatal("modified relay payload")
	}
}
func TestPeerProbeLogRejectsUnmatchedAndStale(t *testing.T) {
	for _, variant := range []string{"wrong-identity", "wrong-sequence", "expired", "new-battle", "new-session", "truncated", "other-protocol"} {
		t.Run(variant, func(t *testing.T) {
			var output bytes.Buffer
			h := NewHub(nil, Config{})
			h.Trace = log.New(&output, "", 0)
			r := &Room{ID: 1, Serial: 1}
			a := &Session{UID: 1, Room: r}
			b := &Session{UID: 2, Room: r}
			payload := make([]byte, 24)
			protocol.WriteUint64(payload, 0, 1)
			protocol.WriteUint64(payload, 8, 2)
			frame, _ := protocol.Encode(protocol.Message{ID: peerLatencyProbeID, Payload: payload})
			at := time.Unix(100, 0)
			h.observePeerProbe(a, b, frame, at)
			output.Reset()
			end := at.Add(time.Millisecond)
			switch variant {
			case "wrong-identity":
				protocol.WriteUint64(payload, 0, 3)
				frame, _ = protocol.Encode(protocol.Message{ID: peerLatencyProbeID, Payload: payload})
			case "wrong-sequence":
				protocol.WriteUint64(payload, 16, 1)
				frame, _ = protocol.Encode(protocol.Message{ID: peerLatencyProbeID, Payload: payload})
			case "expired":
				end = at.Add(peerProbeMaxAge + time.Second)
			case "new-battle":
				r.Serial++
			case "new-session":
				b = &Session{UID: 2, Room: r}
			case "truncated":
				frame = frame[:47]
			case "other-protocol":
				frame, _ = protocol.Encode(protocol.Message{ID: 1, Payload: payload})
			}
			h.observePeerProbe(b, a, frame, end)
			if output.Len() != 0 {
				t.Fatal(output.String())
			}
		})
	}
}
