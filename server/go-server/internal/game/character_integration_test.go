package game

import (
	"bytes"
	"fmt"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestNativeCharacterCreationWithLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var db string
	if err := store.DB.QueryRow("SELECT DATABASE()").Scan(&db); err != nil || !strings.HasPrefix(db, "openkfo_debug_") {
		t.Fatal("not debug DB")
	}
	uid := uint64(time.Now().UnixMicro())
	a, err := persistence.NewAccount(uid, fmt.Sprintf("cw%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err := store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"character_creations", "inventory", "accounts"} {
			if _, err := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); err != nil {
				t.Error(err)
			}
		}
	}()
	var choices []persistence.CharacterChoice
	request := make([]byte, 68)
	copy(request, []byte(fmt.Sprintf("w%d", uid)))
	request[21] = 2
	request[22] = 13
	for i, id := range []uint32{152002, 132002, 122001, 172002, 162003, 142002, 253002} {
		c := uint32(900 + i)
		choices = append(choices, persistence.CharacterChoice{Gender: 2, Slot: uint32(i), Choice: c, Item: id})
		protocol.WriteUint32(request, 23+i*4, c)
	}
	hub := NewHub(store, Config{CharacterChoices: choices})
	s, err := hub.Attach(a, 18001)
	if err != nil {
		t.Fatal(err)
	}
	defer hub.Detach(s)
	ch := &Channel{ID: 1, Kind: "game", Phase: "bootstrap"}
	s.Channels[1] = ch
	s.BootstrapChannel = 1
	s.TablesReady = true
	if err := hub.profileReady(s); err != nil {
		t.Fatal(err)
	}
	options := roomOutputs(t, s, 1125)
	if len(options[0].Payload) != 112 || ch.Phase != "character_create" {
		t.Fatal("candidate stage")
	}
	invalid := bytes.Clone(request)
	protocol.WriteUint32(invalid, 23, 123456)
	if err := hub.route(s, ch, protocol.Message{ID: 1150, Payload: invalid}); err != nil {
		t.Fatal(err)
	}
	if ch.Phase != "character_create" {
		t.Fatal("invalid request advanced state")
	}
	roomOutputs(t, s, 1152)
	for i := 0; i < 2; i++ {
		if err := hub.route(s, ch, protocol.Message{ID: 1150, Payload: request}); err != nil {
			t.Fatal(err)
		}
		replies := roomOutputs(t, s, 1151)
		if len(replies[0].Payload) != 836 {
			t.Fatal("profile/equipment size")
		}
	}
	if err := hub.route(s, ch, protocol.Message{ID: 3320, Payload: []byte{0xed, 7, 4, 4}}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 3330, 1130)
	if ch.Phase != "profile_sent" {
		t.Fatal("did not reach character selection")
	}
	if err := hub.route(s, ch, protocol.Message{ID: 3320, Payload: protocol.Uint32Bytes(1)}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 3330, 1201)
	if ch.Phase != "handoff" {
		t.Fatal("no channel grant")
	}
}
