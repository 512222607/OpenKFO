package main

import (
	"bytes"
	"fmt"
	"testing"

	"kungfu.local/server/internal/protocol"
)

// Runs within the existing independent-DB two-player TLS fixture, after the
// real authentication, P2P registration and battle-loading sequence.
func checkReliableTLS(t *testing.T, owner, actor *client, ownerUID, actorUID uint64, room, battle uint32, send func(*client, uint32, []byte), drain func(*client) []protocol.Message) {
	t.Helper()
	for _, family := range []uint32{9000, 9500} {
		t.Run(fmt.Sprintf("object-events-%d", family), func(t *testing.T) {
			packet := func(kind uint32, sender, entity uint64, key, flag, seq uint32) []byte {
				size := 55
				if family == 9000 {
					size = 63
				}
				p := make([]byte, size)
				protocol.WriteUint32(p, 0, kind)
				protocol.WriteUint64(p, 4, sender)
				p[12], p[13] = 1, 1
				protocol.WriteUint32(p, 19, seq)
				protocol.WriteUint64(p, 39, entity)
				protocol.WriteUint32(p, 47, key)
				protocol.WriteUint32(p, 51, flag)
				if family == 9000 {
					protocol.WriteUint32(p, 55, room)
					protocol.WriteUint32(p, 59, battle)
				}
				return p
			}
			exchange := func(from, to *client, p []byte, relay bool) {
				t.Helper()
				send(from, 8071, p)
				if got := drain(from); len(got) != 0 {
					t.Fatalf("unexpected sender reply: %v", got)
				}
				got := drain(to)
				if relay {
					if len(got) != 1 || got[0].ID != 8071 || !bytes.Equal(got[0].Payload, p) {
						t.Fatalf("relay mismatch: %v", got)
					}
				} else if len(got) != 0 {
					t.Fatalf("rejected event relayed: %v", got)
				}
			}
			request := packet(family, actorUID, actorUID, 42, 1, 1)
			exchange(actor, owner, request, true)
			exchange(actor, owner, request, false)
			exchange(actor, owner, packet(family+1, actorUID, actorUID, 42, 1, 1), false)
			exchange(owner, actor, packet(family+1, ownerUID, actorUID, 99, 1, 1), false)
			exchange(actor, owner, packet(family+2, actorUID, actorUID, 42, 1, 1), false)
			reply := packet(family+1, ownerUID, actorUID, 42, 1, 1)
			exchange(owner, actor, reply, true)
			exchange(owner, actor, reply, false)
			finish := packet(family+2, actorUID, actorUID, 42, 1, 1)
			exchange(actor, owner, finish, true)
			exchange(actor, owner, finish, false)
			exchange(actor, owner, packet(family, actorUID, actorUID, 43, 1, 2), true)
			exchange(actor, owner, packet(family, actorUID, actorUID, 43, 0, 3), true)
			exchange(owner, actor, packet(family+1, ownerUID, actorUID, 43, 1, 2), false)
			exchange(actor, owner, packet(family, actorUID, actorUID, 44, 1, 4), true)
			exchange(owner, actor, packet(family+1, ownerUID, actorUID, 44, 0, 3), true)
			exchange(actor, owner, packet(family+2, actorUID, actorUID, 44, 1, 2), false)
			// The controller may complete its own native locally queued action.
			exchange(owner, actor, packet(family+2, ownerUID, ownerUID, 45, 1, 1), true)
			if family == 9000 {
				stale := packet(family, actorUID, actorUID, 46, 1, 5)
				protocol.WriteUint32(stale, 59, battle+1)
				exchange(actor, owner, stale, false)
			}
		})
	}
}
