package protocol

import (
	"bytes"
	"encoding/json"
	"os"
	"testing"
)

func TestBootstrapInitializesHonourHistory(t *testing.T) {
	messages := Bootstrap(nil, 19091, 0, 0)
	found := false
	for i, m := range messages {
		if m.ID != 1035 {
			continue
		}
		if found || len(m.Payload) != 57 || ReadUint32(m.Payload, 0) != 1 {
			t.Fatal("invalid history directory")
		}
		if i >= len(messages)-2 {
			t.Fatal("directory must precede channel catalog")
		}
		if !bytes.Equal(m.Payload[4:], make([]byte, 53)) {
			t.Fatal("unconfirmed directory data invented")
		}
		found = true
	}
	if !found {
		t.Fatal("missing honour history initialization")
	}
}

func TestPythonCompatibility(t *testing.T) {
	encoded, err := os.ReadFile("testdata/python-vectors.json")
	if err != nil {
		t.Fatal(err)
	}
	var fixture struct {
		Frames []struct {
			ID      uint32
			Payload []byte
			Key     int
			Frame   []byte
		}
		Packets []Message
	}
	if err = json.Unmarshal(encoded, &fixture); err != nil {
		t.Fatal(err)
	}
	for _, vector := range fixture.Frames {
		decoder := Decoder{}
		var messages []Message
		for _, value := range vector.Frame {
			decoded, err := decoder.Feed([]byte{value})
			if err != nil {
				t.Fatal(err)
			}
			messages = append(messages, decoded...)
		}
		if len(messages) != 1 || messages[0].ID != vector.ID || !bytes.Equal(messages[0].Payload, vector.Payload) {
			t.Fatalf("decode differs: key=%d size=%d", vector.Key, len(vector.Payload))
		}
		if vector.Key == 0 {
			frame, err := Encode(messages[0])
			if err != nil || !bytes.Equal(frame, vector.Frame) {
				t.Fatal("encoded frame differs from Python")
			}
		}
	}
	actual := []Message{LoginAck("localtest", 1003), LoginDirectory(18001)}
	actual = append(actual, Catalog(18001)...)
	actual = append(actual, Lobby(18001))
	for index, expected := range fixture.Packets {
		if actual[index].ID != expected.ID || !bytes.Equal(actual[index].Payload, expected.Payload) {
			t.Fatalf("packet %d differs", expected.ID)
		}
	}
}

func TestRejectMalformedFrames(t *testing.T) {
	valid, _ := Encode(Message{ID: 1232})
	for _, offset := range []int{0, 2, 4} {
		frame := bytes.Clone(valid)
		frame[offset] ^= 0xff
		decoder := Decoder{}
		if _, err := decoder.Feed(frame); err == nil {
			t.Fatalf("accepted corrupt header at %d", offset)
		}
	}
	frame, _ := Encode(Message{ID: 0, Payload: []byte{1}})
	decoder := Decoder{}
	if _, err := decoder.Feed(frame); err == nil {
		t.Fatal("accepted nonempty heartbeat")
	}
	decoder = Decoder{}
	if _, err := decoder.Feed(make([]byte, MaxFrame+65537)); err == nil {
		t.Fatal("accepted receive buffer overflow")
	}
	if _, err := Block(make([]byte, 8), 11, true); err == nil {
		t.Fatal("accepted unknown block key")
	}
}

func TestLegacyLoginMatchesPythonJSON(t *testing.T) {
	response, err := LegacyLoginSuccess("0123456789abcdef0123456789abcdef")
	if err != nil || string(response) != `{"code": 200, "token": "0123456789abcdef0123456789abcdef", "msg": "OK"}` {
		t.Fatal("legacy login response layout changed")
	}
	if _, err = LegacyLoginSuccess("invalid"); err == nil {
		t.Fatal("invalid token accepted")
	}
}
