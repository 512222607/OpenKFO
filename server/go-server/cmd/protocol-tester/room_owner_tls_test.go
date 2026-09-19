package main

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

// Reuse the authenticated two-player room in TestStageGateTLS, restoring its
// original owner before the stage-policy checks continue.
func checkRoomOwnerTransferTLS(t *testing.T, host, peer *client, hostUID, peerUID uint64, room uint16, send func(*client, uint32, []byte), drain func(*client) []protocol.Message) {
	t.Helper()
	check := func(ms []protocol.Message, owner uint64, ack bool) {
		t.Helper()
		want := 1
		if ack {
			want = 2
		}
		if len(ms) != want || ms[0].ID != protocol.MsgRoomOwner || len(ms[0].Payload) != 8 || protocol.ReadUint64(ms[0].Payload, 0) != owner {
			t.Fatal("owner notification", ms)
		}
		if ack && (ms[1].ID != protocol.MsgChangeRoomOwnerResult || len(ms[1].Payload) != 2 || protocol.ReadUint16(ms[1].Payload, 0) != 0) {
			t.Fatal("owner transfer ack", ms)
		}
	}
	p := append(protocol.Uint32Bytes(uint32(room)), protocol.Uint64Bytes(peerUID)...)
	send(host, protocol.MsgChangeRoomOwner, p)
	check(drain(host), peerUID, true)
	check(drain(peer), peerUID, false)
	send(host, protocol.MsgChangeRoomOwner, p)
	if ms := drain(host); len(ms) != 1 || ms[0].ID != 20150 {
		t.Fatal("old owner authority retained", ms)
	}
	if ms := drain(peer); len(ms) != 0 {
		t.Fatal("rejected transfer broadcast", ms)
	}
	protocol.WriteUint64(p, 4, hostUID)
	send(peer, protocol.MsgChangeRoomOwner, p)
	check(drain(peer), hostUID, true)
	check(drain(host), hostUID, false)
}
