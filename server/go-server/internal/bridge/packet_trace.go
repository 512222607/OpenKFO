package bridge

import (
	"encoding/hex"
	"encoding/json"
	"log"
	"time"

	"kungfu.local/server/internal/protocol"
)

// One instance per stream direction: only that stream's reader owns the decoder.
// Timestamp records socket read/write completion, not native handler execution.
type packetTrace struct {
	account string
	uid     uint64
	channel uint32
	decoder protocol.Decoder
}

func (t *packetTrace) decode(data []byte) []protocol.Message {
	if t == nil {
		return nil
	}
	messages, err := t.decoder.Feed(data)
	if err != nil {
		log.Printf("bridge_trace_decode_error account=%q uid=%d channel=%d bytes=%d error=%v", t.account, t.uid, t.channel, len(data), err)
		t.decoder.Buffer = nil
	}
	return messages
}

func (t *packetTrace) record(event string, at time.Time, messages []protocol.Message, writeErr error) {
	if t == nil {
		return
	}
	for _, message := range messages {
		entry := map[string]any{"time": at.Format(time.RFC3339Nano), "event": event, "account": t.account, "uid": t.uid, "channel": t.channel, "protocol": message.ID, "length": len(message.Payload), "hex": hex.EncodeToString(message.Payload)}
		if writeErr != nil {
			entry["error"] = writeErr.Error()
		}
		encoded, _ := json.Marshal(entry)
		log.Print(string(encoded))
	}
}
