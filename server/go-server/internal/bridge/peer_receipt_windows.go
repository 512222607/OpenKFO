//go:build windows

package bridge

// No receipt is persisted to disk or shared by account: the native P2P object
// belongs to one process instance (PID plus creation time and image).
func (b *Bridge) peerReceiptFor(identity Identity) string {
	b.peerMutex.Lock()
	defer b.peerMutex.Unlock()
	return b.peerReceipts[identity]
}
func (b *Bridge) rememberPeerReceipt(identity Identity, receipt string) {
	if receipt == "" {
		return
	}
	b.peerMutex.Lock()
	defer b.peerMutex.Unlock()
	if b.peerReceipts == nil {
		b.peerReceipts = make(map[Identity]string)
	}
	for old := range b.peerReceipts {
		if old.PID == identity.PID && old != identity {
			delete(b.peerReceipts, old)
		}
	}
	b.peerReceipts[identity] = receipt
}
