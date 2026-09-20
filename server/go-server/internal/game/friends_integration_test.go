package game

import (
	"encoding/binary"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestFriendsNativeFlowIndependentDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug database required")
	}
	c, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(c.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	h := NewHub(store, Config{})
	var accounts []persistence.Account
	defer func() {
		for _, a := range accounts {
			if _, err := store.DB.Exec("DELETE FROM accounts WHERE uid=?", a.UID); err != nil {
				t.Error(err)
			}
		}
	}()
	base := uint64(time.Now().UnixMicro())
	for i := 0; i < 2; i++ {
		a, err := persistence.NewAccountWithStarterCharacter(base+uint64(i), fmt.Sprintf("fr%d", base+uint64(i)), "test123456")
		if err != nil {
			t.Fatal(err)
		}
		a.Inventory = nil
		if err = store.Create(a); err != nil {
			t.Fatal(err)
		}
		accounts = append(accounts, a)
	}
	attach := func(a persistence.Account) *Session {
		s, err := h.Attach(a, 19091)
		if err != nil {
			t.Fatal(err)
		}
		s.GameChannel = 1
		s.Channels[1] = &Channel{ID: 1, Kind: "game", Phase: "room"}
		return s
	}
	s := attach(accounts[0])
	other := attach(accounts[1])
	defer h.Detach(other)
	send := func(op uint16, b []byte, ids ...uint16) []protocol.Message {
		s.LastFriendRequest = time.Time{}
		if err := h.route(s, s.game(), friendPacket(op, b)); err != nil {
			t.Fatal(err)
		}
		outer := make([]uint32, len(ids))
		for i := range outer {
			outer[i] = msgFriends
		}
		out := roomOutputs(t, s, outer...)
		for i, p := range out {
			if binary.LittleEndian.Uint16(p.Payload) != ids[i] {
				t.Fatalf("got %x", p.Payload)
			}
		}
		return out
	}
	name := accounts[1].Nickname
	for i := 0; i < 2; i++ {
		send(friendAdd, friendString(friendString(nil, name), ""), friendAdded, friendList)
	}
	roomOutputs(t, other) // directed list, never modifies or sends invitations to another owner
	h.Detach(s)
	s = attach(accounts[0])
	defer h.Detach(s)
	out := send(friendQuery, make([]byte, 4), friendList)
	if binary.BigEndian.Uint16(out[0].Payload[9:]) != 1 || out[0].Payload[12] != friendOnline {
		t.Fatal("relogin/presence")
	}
	h.Detach(other)
	out = send(friendQuery, make([]byte, 4), friendList)
	if out[0].Payload[12] != friendOffline {
		t.Fatal("offline presence")
	}
	send(friendRemove, friendString(nil, name), friendRemoved, friendList)
	out = send(friendQuery, make([]byte, 4), friendList)
	if binary.BigEndian.Uint16(out[0].Payload[9:]) != 0 {
		t.Fatal("delete snapshot")
	}
}
