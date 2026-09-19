//go:build windows

package bridge

import "testing"

func TestPeerReceiptBelongsToNativeProcess(t *testing.T) {
	b := &Bridge{}
	first := Identity{PID: 1, Created: 10, Image: "game"}
	b.rememberPeerReceipt(first, "receipt")
	b.rememberPeerReceipt(first, "")
	if b.peerReceiptFor(first) != "receipt" {
		t.Fatal("receipt lost across login")
	}
	for _, other := range []Identity{{PID: 2, Created: 10, Image: "game"}, {PID: 1, Created: 20, Image: "game"}, {PID: 1, Created: 10, Image: "other"}} {
		if b.peerReceiptFor(other) != "" {
			t.Fatal("receipt leaked to another process")
		}
	}
	replacement := Identity{PID: 1, Created: 20, Image: "game"}
	b.rememberPeerReceipt(replacement, "new")
	if b.peerReceiptFor(first) != "" || b.peerReceiptFor(replacement) != "new" {
		t.Fatal("PID reuse retained old receipt")
	}
}
