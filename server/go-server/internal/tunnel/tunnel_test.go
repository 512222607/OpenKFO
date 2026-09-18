package tunnel

import (
	"bufio"
	"strings"
	"testing"
)

func TestFrameBoundaries(t *testing.T) {
	reader := bufio.NewReaderSize(strings.NewReader("{\"op\":\"ping\"}\n{\"op\":\"pong\"}\n"), 16)
	for _, expected := range []string{"{\"op\":\"ping\"}\n", "{\"op\":\"pong\"}\n"} {
		frame, err := ReadFrame(reader, 100)
		if err != nil || string(frame) != expected {
			t.Fatal("frame boundary changed")
		}
	}
	if _, err := ReadFrame(bufio.NewReaderSize(strings.NewReader(strings.Repeat("x", 1000)+"\n"), 16), 100); err == nil {
		t.Fatal("oversize frame accepted")
	}
}
