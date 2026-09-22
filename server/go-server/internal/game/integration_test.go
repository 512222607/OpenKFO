package game

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"os"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

func TestMySQLTransactionsAndTwoPlayers(t *testing.T) {
	dsn := os.Getenv("KK_TEST_MYSQL_DSN")
	if dsn == "" {
		t.Skip("KK_TEST_MYSQL_DSN is required for isolated MySQL integration")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var databaseName string
	if err = store.DB.QueryRow("SELECT DATABASE()").Scan(&databaseName); err != nil || databaseName != "kungfu_game_test" {
		t.Fatal("integration requires kungfu_game_test")
	}
	uid := uint64(time.Now().UnixMilli())
	first, err := persistence.NewAccountWithStarterCharacter(uid, "test"+hex.EncodeToString(protocol.Uint64Bytes(uid))[:12], "testsecret123")
	if err != nil {
		t.Fatal(err)
	}
	second, err := persistence.NewAccountWithStarterCharacter(uid+1, "peer"+hex.EncodeToString(protocol.Uint64Bytes(uid))[:12], "testsecret456")
	if err != nil {
		t.Fatal(err)
	}
	first.Tickets = 100
	second.Tickets = 50
	for _, account := range []persistence.Account{first, second} {
		if err = store.Create(account); err != nil {
			t.Fatal(err)
		}
	}
	passwordHash := sha256.Sum256([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLvtestsecret123"))
	if _, err = store.Authenticate(first.Account, hex.EncodeToString(passwordHash[:])); err != nil {
		t.Fatal("legacy credentials incompatible", err)
	}
	if _, err = store.Authenticate(first.Account, string(bytes.Repeat([]byte{'0'}, 64))); err == nil {
		t.Fatal("wrong password admitted")
	}
	if _, err = store.EquipmentManager().Equip(second.UID, 1048577, 8); err == nil {
		t.Fatal("invalid equipment kind admitted")
	}
	catalog := make([]byte, 108)
	grant := make([]byte, 68)
	key := uint32(uid)
	catalog[4] = 25
	catalog[48] = 1
	catalog[83] = 1
	protocol.WriteUint32(catalog, 5, 253013)
	protocol.WriteUint32(catalog, 9, key)
	protocol.WriteUint32(catalog, 38, 10)
	protocol.WriteUint32(catalog, 42, 10)
	grant[4] = 25
	protocol.WriteUint32(grant, 5, 253013)
	protocol.WriteUint32(grant, 13, 8760)
	if _, err = store.DB.Exec("INSERT INTO offers VALUES(?,?,?,?,?,TRUE)", key, 25, 0, catalog, grant); err != nil {
		t.Fatal(err)
	}
	request := make([]byte, 169)
	protocol.WriteUint32(request, 0, 109)
	protocol.WriteUint64(request, 4, uid)
	protocol.WriteUint64(request, 54, uid)
	protocol.WriteUint32(request, 145, key)
	protocol.WriteUint32(request, 157, 10)
	forged := bytes.Clone(request)
	protocol.WriteUint32(forged, 157, 1)
	if _, _, _, err = store.ShopManager().Purchase(uid, "forged", forged); err == nil {
		t.Fatal("forged price admitted")
	}
	if _, _, _, err = store.ShopManager().Purchase(second.UID, "spoof", request); err == nil {
		t.Fatal("other account purchase admitted")
	}
	var accepted atomic.Int32
	var workers sync.WaitGroup
	for index := 0; index < 20; index++ {
		workers.Add(1)
		go func() {
			defer workers.Done()
			operation := hex.EncodeToString(protocol.Uint32Bytes(uint32(index)))
			if _, _, _, err := store.ShopManager().Purchase(uid, operation, request); err == nil {
				accepted.Add(1)
			}
		}()
	}
	workers.Wait()
	if accepted.Load() != 10 {
		t.Fatalf("expected exactly 10 debits, got %d", accepted.Load())
	}
	snapshot, err := store.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if snapshot.Tickets != 0 || len(snapshot.Inventory) != 17 {
		t.Fatal("debit and grant were not atomic")
	}
	peerSnapshot, _ := store.RoleManager().Snapshot(second.UID)
	if peerSnapshot.Tickets != 50 || len(peerSnapshot.Inventory) != 7 {
		t.Fatal("account isolation failed")
	}
	if _, _, err = store.WalletManager().AdjustTickets(uid, "gift", 30, "wallet-"+first.Account); err != nil {
		t.Fatal(err)
	}
	if _, after, err := store.WalletManager().AdjustTickets(uid, "gift", 30, "wallet-"+first.Account); err != nil || after != 30 {
		t.Fatal("wallet retry applied twice")
	}
	if _, _, err = store.WalletManager().AdjustTickets(uid, "gift", 31, "wallet-"+first.Account); err == nil {
		t.Fatal("conflicting wallet retry admitted")
	}
	consumable := make([]byte, 68)
	protocol.WriteUint32(consumable, 0, 2000000)
	consumable[4] = 64
	protocol.WriteUint16(consumable, 17, 27)
	protocol.WriteUint16(consumable, 23, 2)
	if _, err = store.DB.Exec("INSERT INTO inventory VALUES(?,?,?)", uid, 2000000, consumable); err != nil {
		t.Fatal(err)
	}
	signature := bytes.Repeat([]byte{1}, 40)
	if applied, consumeErr := store.InventoryManager().Consume(uid, 5, 1, 2000000, signature, true); consumeErr != nil || !applied {
		t.Fatal("first consumption not applied", consumeErr)
	}
	if applied, consumeErr := store.InventoryManager().Consume(uid, 5, 1, 2000000, signature, false); consumeErr != nil || applied {
		t.Fatal("consumption retry not idempotent", consumeErr)
	}
	if _, err = store.InventoryManager().Consume(uid, 5, 2, 2000000, signature, false); err == nil {
		t.Fatal("uncorrelated consumption admitted")
	}
	consumed, _ := store.RoleManager().Snapshot(uid)
	remaining, err := consumed.Consumable(2000000, 0)
	if err != nil || protocol.ReadUint16(remaining, 23) != 1 {
		t.Fatal("consumption billed more than once")
	}
	if _, err = store.EquipmentManager().Equip(uid, 2000000, 0); err != nil {
		t.Fatal(err)
	}
	if changed, err := store.EquipmentManager().Equip(uid, 2000000, 0); err != nil || changed != nil {
		t.Fatal("duplicate unequip must not repeat native teardown")
	}
	if _, err = store.RoleManager().Rename(uid, "TestRename"); err != nil {
		t.Fatal(err)
	}
	directory, own, err := store.Rankings(uid, 0)
	if err != nil || len(directory)%27 != 0 || len(own) != 5 {
		t.Fatal("ranking layout mismatch")
	}
	if _, err = store.RoleManager().Rename(uid, first.Nickname); err != nil {
		t.Fatal(err)
	}
	hub := NewHub(store, Config{Pools: map[string][]uint32{"0:2": {804}}})
	owner, err := hub.Attach(first, 18001)
	if err != nil {
		t.Fatal(err)
	}
	peer, err := hub.Attach(second, 18001)
	if err != nil {
		t.Fatal(err)
	}
	defer hub.Detach(owner)
	defer hub.Detach(peer)
	if _, err = hub.Attach(first, 18001); err == nil {
		t.Fatal("duplicate login admitted")
	}
	for index, session := range []*Session{owner, peer} {
		session.Channels[1] = &Channel{ID: 1, Kind: "game", Phase: "lobby"}
		session.GameChannel = 1
		session.Bound = true
		session.P2P = uint32(1001 + index)
		session.P2PUntil = time.Now().Add(time.Minute)
	}
	send := func(session *Session, id uint32, payload []byte) {
		t.Helper()
		encoded, _ := protocol.Encode(protocol.Message{ID: id, Payload: payload})
		if err := hub.Handle(session, tunnel.Frame{Op: "data", Channel: 1, Data: encoded}); err != nil {
			t.Fatalf("message %d: %v", id, err)
		}
	}
	roomRequest := make([]byte, 81)
	copy(roomRequest, "Integration room")
	roomRequest[37] = 2
	protocol.WriteUint32(roomRequest, 38, 804)
	protocol.WriteUint32(roomRequest, 42, 804)
	protocol.WriteUint16(roomRequest, 47, 180)
	send(owner, 3010, roomRequest)
	join := make([]byte, 14)
	protocol.WriteUint16(join, 0, owner.Room.ID)
	send(peer, 3070, join)
	if owner.Room != peer.Room || len(owner.Room.Members) != 2 {
		t.Fatal("players are not in one room")
	}
	send(owner, 4030, nil)
	if owner.Room.Stage != "room" {
		t.Fatal("host bypassed peer readiness")
	}
	send(peer, 4030, nil)
	send(owner, 4030, nil)
	send(owner, protocol.MsgNetworkDelayReply, nil)
	send(peer, protocol.MsgNetworkDelayReply, nil)
	if owner.Room.Stage != "loading" {
		t.Fatal("room did not start")
	}
	send(owner, 4160, nil)
	if owner.Room.Stage != "loading" {
		t.Fatal("load barrier bypassed")
	}
	send(peer, 4160, nil)
	for _, session := range []*Session{owner, peer} {
		ready := make([]byte, 14)
		protocol.WriteUint16(ready, 0, session.Room.ID)
		protocol.WriteUint64(ready, 2, session.UID)
		send(session, 8040, ready)
	}
	if owner.Room.Stage != "battle" {
		t.Fatal("battle readiness failed")
	}
	for len(owner.Output) > 0 {
		<-owner.Output
	}
	for len(peer.Output) > 0 {
		<-peer.Output
	}
	attack := make([]byte, 103)
	protocol.WriteUint32(attack, 0, 0x1fcc)
	protocol.WriteUint64(attack, 4, uid)
	protocol.WriteUint64(attack, 39, uid)
	protocol.WriteUint32(attack, 19, 1)
	protocol.WriteUint32(attack, 95, uint32(owner.Room.ID))
	protocol.WriteUint32(attack, 99, owner.Room.Serial)
	send(owner, 8071, attack)
	if len(owner.Output) != 0 || len(peer.Output) != 1 {
		t.Fatal("attack recipient selection failed")
	}
	<-peer.Output
	send(owner, 8071, attack)
	if len(peer.Output) != 0 {
		t.Fatal("replayed attack forwarded")
	}
	// A committed item use reaches the other native player once; a retry
	// updates the inventory receipt but must not repeat the remote effect.
	if _, err = store.EquipmentManager().Equip(uid, 2000000, 27); err != nil {
		t.Fatal(err)
	}
	send(owner, 4200, protocol.Uint32Bytes(2000000))
	use := make([]byte, 75)
	protocol.WriteUint32(use, 0, 8289)
	protocol.WriteUint64(use, 4, uid)
	use[12], use[13] = 1, 1
	protocol.WriteUint32(use, 19, 29)
	protocol.WriteUint32(use, 39, 27)
	protocol.WriteUint64(use, 59, uid)
	protocol.WriteUint32(use, 67, uint32(owner.Room.ID))
	protocol.WriteUint32(use, 71, owner.Room.Serial)
	send(owner, 8071, use)
	if len(peer.Output) != 1 || len(owner.Output) != 1 {
		t.Fatal("item effect or inventory receipt missing")
	}
	<-peer.Output
	<-owner.Output
	send(owner, 8071, use)
	if len(peer.Output) != 0 || len(owner.Output) != 1 {
		t.Fatal("item retry replayed remote effect")
	}
	<-owner.Output
	consumed, err = store.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	remaining, err = consumed.Consumable(2000000, 0)
	if err != nil || protocol.ReadUint16(remaining, 23) != 0 {
		t.Fatal("item effect did not debit exactly once")
	}
	protocol.WriteUint64(attack, 39, second.UID)
	encoded, _ := protocol.Encode(protocol.Message{ID: 8071, Payload: attack})
	if err := hub.Handle(owner, tunnel.Frame{Op: "data", Channel: 1, Data: encoded}); err != nil {
		t.Fatal("audit-only policy disconnected sender", err)
	}
	if len(peer.Output) != 0 {
		t.Fatal("spoofed actor forwarded")
	}
	hub.Detach(owner)
	if peer.Room == nil || peer.Room.Stage != "room" || peer.game().Phase != "room" || len(peer.Room.Members) != 1 {
		t.Fatal("survival departure did not recover remaining player to room")
	}
}
