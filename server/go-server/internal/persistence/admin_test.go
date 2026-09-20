package persistence

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"kungfu.local/server/internal/protocol"
)

func adminFixtureOffer(id uint32) AdminOffer {
	offer := AdminOffer{Offer: Offer{Key: 0x70000000 + id, Category: 10, Variant: 25, Record: make([]byte, 108), Grant: make([]byte, 68)}, Enabled: true}
	protocol.WriteUint32(offer.Record, 0, offer.Key)
	offer.Record[4] = 25
	protocol.WriteUint32(offer.Record, 5, id)
	protocol.WriteUint32(offer.Record, 9, offer.Key)
	protocol.WriteUint32(offer.Record, 38, 77)
	protocol.WriteUint32(offer.Record, 42, 77)
	offer.Record[83] = 1
	offer.Grant[4] = 25
	protocol.WriteUint32(offer.Grant, 5, id)
	protocol.WriteUint32(offer.Grant, 13, 8760)
	return offer
}

func TestAdminOfferRejectsMalformedRecords(t *testing.T) {
	valid := adminFixtureOffer(253013)
	if err := validateAdminOffer(valid); err != nil {
		t.Fatal(err)
	}
	for _, change := range []func(*AdminOffer){func(o *AdminOffer) { o.Record = o.Record[:20] }, func(o *AdminOffer) { o.Record[4] = 12 }, func(o *AdminOffer) { protocol.WriteUint32(o.Record, 30, 10) }, func(o *AdminOffer) { o.Record[83] = 0 }} {
		offer := adminFixtureOffer(253013)
		change(&offer)
		if validateAdminOffer(offer) == nil {
			t.Fatal("invalid offer admitted")
		}
	}
}

func TestDesktopAdminTransactions(t *testing.T) {
	dsn := os.Getenv("KK_TEST_MYSQL_DSN")
	if dsn == "" {
		t.Skip("isolated MySQL required")
	}
	store, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var database string
	if store.DB.QueryRow("SELECT DATABASE()").Scan(&database) != nil || database != "kungfu_game_test" {
		t.Fatal("isolated database required")
	}
	uid := uint64(time.Now().UnixMicro())
	account, err := NewAccountWithStarterCharacter(uid, fmt.Sprintf("adm%d", uid%10000000000000), "admin-test-only")
	if err != nil {
		t.Fatal(err)
	}
	if err = store.Create(account); err != nil {
		t.Fatal(err)
	}
	prefix := fmt.Sprintf("admin-%d", uid)
	offer := adminFixtureOffer(uint32(uid%100000000) + 20000000)
	recommended := true
	offer.Recommended = &recommended
	save := AdminRequest{Operation: "shop_save", ID: prefix + "-save", Offers: []AdminOffer{offer}}
	if _, err = store.Admin(save); err != nil {
		t.Fatal(err)
	}
	list, err := store.ShopManager().Offers(protocol.ShopCategoryRecommended, int(protocol.ItemWeapon))
	if err != nil {
		t.Fatal(err)
	}
	found := false
	for _, row := range list {
		if row.Key == offer.Key {
			found = true
			if !bytes.Equal(row.Record, offer.Record) {
				t.Fatal("recommendation changed purchase record")
			}
		}
	}
	if !found {
		t.Fatal("recommended weapon missing")
	}
	activatedSnapshot, err := store.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	for _, record := range activatedSnapshot.Inventory {
		if protocol.ReadUint16(record, 17) != 0 && (protocol.ReadUint32(record, 19) != inventoryActive || protocol.ReadUint32(record, 13) != permanentDisplayMinutes) {
			t.Fatal("legacy starter equipment not activated")
		}
	}
	request := AdminRequest{Operation: "shop_batch", ID: prefix + "-disable", Offers: []AdminOffer{offer}, Preserve: true, Enabled: false}
	if _, err = store.Admin(request); err != nil {
		t.Fatal(err)
	}
	var record []byte
	var enabled bool
	if err = store.DB.QueryRow(`SELECT record,enabled FROM offers WHERE catalog_key=?`, offer.Key).Scan(&record, &enabled); err != nil || enabled || !bytes.Equal(record, offer.Record) {
		t.Fatal("disable changed pricing", err)
	}
	request.ID = prefix + "-enable"
	request.Enabled = true
	request.Offers[0].Record = bytes.Clone(offer.Record)
	protocol.WriteUint32(request.Offers[0].Record, 38, 100)
	if _, err = store.Admin(request); err != nil {
		t.Fatal(err)
	}
	if err = store.DB.QueryRow(`SELECT record,enabled FROM offers WHERE catalog_key=?`, offer.Key).Scan(&record, &enabled); err != nil || !enabled || protocol.ReadUint32(record, 38) != 77 {
		t.Fatal("enable overwrote price", err)
	}
	consumable := make([]byte, 68)
	consumable[4] = 64
	protocol.WriteUint32(consumable, 5, 640001)
	protocol.WriteUint16(consumable, 23, 998)
	grant := AdminRequest{Operation: "grant", ID: prefix + "-grant", UID: uid, Records: [][]byte{offer.Grant, consumable}}
	if _, err = store.Admin(grant); err != nil {
		t.Fatal(err)
	}
	if _, err = store.Admin(grant); err != nil {
		t.Fatal("retry", err)
	}
	snapshot, err := store.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	before := len(snapshot.Inventory)
	bad := bytes.Clone(consumable)
	protocol.WriteUint16(bad, 23, 2)
	other := bytes.Clone(offer.Grant)
	protocol.WriteUint32(other, 5, 123456)
	if _, err = store.Admin(AdminRequest{Operation: "grant", ID: prefix + "-overflow", UID: uid, Records: [][]byte{other, bad}}); err == nil {
		t.Fatal("overflow admitted")
	}
	snapshot, err = store.RoleManager().Snapshot(uid)
	if err != nil || len(snapshot.Inventory) != before {
		t.Fatal("failed batch partially committed", err)
	}
	grant.Records = [][]byte{bad}
	if _, err = store.Admin(grant); err == nil {
		t.Fatal("conflicting retry admitted")
	}
	if _, err = store.Admin(AdminRequest{Operation: "shop_batch", ID: prefix + "-alloff", All: true}); err != nil {
		t.Fatal(err)
	}
	var active int
	if err = store.DB.QueryRow(`SELECT COUNT(*) FROM offers WHERE enabled=TRUE`).Scan(&active); err != nil || active != 0 {
		t.Fatal("all-off incomplete", err)
	}
}

// Uses connection-local shadow tables, never live shop rows.
func TestSingleShopSaveThroughLocalTunnel(t *testing.T) {
	dsn := os.Getenv("KK_TEST_MYSQL_DSN")
	if dsn == "" {
		t.Skip("isolated database required")
	}
	store, err := OpenExisting(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	store.DB.SetMaxOpenConns(1)
	var name string
	if err = store.DB.QueryRow("SELECT DATABASE()").Scan(&name); err != nil || (name != "kungfu_game_test" && !strings.HasPrefix(name, "openkfo_debug_")) {
		t.Fatal("isolated database required")
	}
	for _, table := range []string{"offers", "counters", "desktop_admin_operations"} {
		var name, ddl string
		if err = store.DB.QueryRow("SHOW CREATE TABLE "+table).Scan(&name, &ddl); err != nil {
			t.Fatal(err)
		}
		if _, err = store.DB.Exec(strings.Replace(ddl, "CREATE TABLE", "CREATE TEMPORARY TABLE", 1)); err != nil {
			t.Fatal(err)
		}
	}

	request := AdminRequest{Operation: "shop_save", ID: "single-save-latency", Offers: []AdminOffer{adminFixtureOffer(253013)}, Enabled: true}
	start := time.Now()
	first, err := store.Admin(request)
	if err != nil {
		t.Fatal(err)
	}
	t.Logf("single shop transaction: %s", time.Since(start))
	second, err := store.Admin(request)
	if err != nil {
		t.Fatal(err)
	}
	a, _ := json.Marshal(first)
	b, _ := json.Marshal(second)
	if !bytes.Equal(a, b) {
		t.Fatal("retry changed result")
	}
	var count int
	if err = store.DB.QueryRow("SELECT COUNT(*) FROM offers").Scan(&count); err != nil || count != 1 {
		t.Fatal("single save affected unexpected rows", err, count)
	}
	secondOffer := adminFixtureOffer(253014)
	secondOffer.Enabled = false
	secondOffer.Record[48] = 7
	secondOffer.Record[70] = 9
	thirdOffer := adminFixtureOffer(253015)
	if _, err = store.Admin(AdminRequest{Operation: "shop_save", ID: "price-fixtures", Offers: []AdminOffer{secondOffer, thirdOffer}}); err != nil {
		t.Fatal(err)
	}
	original, err := store.adminOffers()
	if err != nil {
		t.Fatal(err)
	}
	priceRequest := AdminRequest{Operation: "shop_prices", ID: "batch-prices", Currency: "gold", Price: 88, Keys: []string{"25:253013", "25:253014", "25:999999"}}
	result, err := store.Admin(priceRequest)
	if err != nil {
		t.Fatal(err)
	}
	values := result.(map[string]any)
	if values["changed"] != 2 || values["skipped"] != 1 {
		t.Fatal(result)
	}
	updated, err := store.adminOffers()
	if err != nil {
		t.Fatal(err)
	}
	for i, old := range original {
		want := bytes.Clone(old.Record)
		if old.Key != thirdOffer.Key {
			protocol.WriteUint32(want, 30, 88)
			protocol.WriteUint32(want, 34, 88)
			protocol.WriteUint32(want, 38, 0)
			protocol.WriteUint32(want, 42, 0)
		}
		if !bytes.Equal(want, updated[i].Record) || !bytes.Equal(old.Grant, updated[i].Grant) || old.Enabled != updated[i].Enabled {
			t.Fatal("batch price changed unrelated fields")
		}
	}
	retry, err := store.Admin(priceRequest)
	if err != nil {
		t.Fatal(err)
	}
	expected, _ := json.Marshal(result)
	actual, _ := json.Marshal(retry)
	if !bytes.Equal(expected, actual) {
		t.Fatal("batch retry changed result")
	}
	priceRequest.ID = "invalid-price"
	priceRequest.Price = 0
	if _, err = store.Admin(priceRequest); err == nil {
		t.Fatal("zero price accepted")
	}

}
