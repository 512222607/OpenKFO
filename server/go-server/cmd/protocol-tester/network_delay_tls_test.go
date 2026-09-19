package main

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

// Explicitly hold each reply to verify that neither player starts early.
func completeNetworkProbeTLS(t *testing.T, host, peer *client, drain func(*client) []protocol.Message) [2][]protocol.Message {
	t.Helper()
	host.manualNetworkProbe, peer.manualNetworkProbe = true, true
	defer func() { host.manualNetworkProbe, peer.manualNetworkProbe = false, false }()
	for _, c := range []*client{host, peer} {
		found := false
		for _, m := range drain(c) {
			if m.ID == protocol.MsgBattleLoading {
				t.Fatal("battle started before probe replies")
			}
			if m.ID == protocol.MsgNetworkDelayProbe {
				if len(m.Payload) != 0 {
					t.Fatal("probe must be empty")
				}
				found = true
			}
		}
		if !found {
			t.Fatal("missing network probe")
		}
	}
	if err := host.game(3, protocol.MsgNetworkDelayReply, nil); err != nil {
		t.Fatal(err)
	}
	for _, m := range drain(host) {
		if m.ID == protocol.MsgBattleLoading {
			t.Fatal("one reply bypassed barrier")
		}
	}
	if err := peer.game(3, protocol.MsgNetworkDelayReply, nil); err != nil {
		t.Fatal(err)
	}
	other := drain(peer)
	return [2][]protocol.Message{drain(host), other}
}
