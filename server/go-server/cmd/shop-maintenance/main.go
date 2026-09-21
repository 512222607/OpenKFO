package main

import (
	"crypto/rand"
	"database/sql"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"math/big"
	"os"
	"path/filepath"
	"time"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
func run() error {
	mode := flag.String("mode", "verify", "")
	backup := flag.String("backup", "", "")
	flag.Parse()
	dsn := os.Getenv("KK_MYSQL_DSN")
	if *mode == "testdb" {
		c, e := mysql.ParseDSN(dsn)
		if e != nil {
			return e
		}
		c.DBName = ""
		db, e := sql.Open("mysql", c.FormatDSN())
		if e != nil {
			return e
		}
		defer db.Close()
		_, e = db.Exec("CREATE DATABASE IF NOT EXISTS kungfu_game_test CHARACTER SET utf8mb4")
		return e
	}
	s, e := persistence.Open(dsn)
	if e != nil {
		return e
	}
	defer s.DB.Close()
	if *mode == "apply" {
		if !filepath.IsAbs(*backup) {
			return fmt.Errorf("absolute backup required")
		}
		raw, e := s.Admin(persistence.AdminRequest{Operation: "shop_catalog"})
		if e != nil {
			return e
		}
		offers := raw.([]persistence.AdminOffer)
		type savedItem struct {
			UID      uint64
			Instance uint32
			Record   []byte
		}
		inventory := []savedItem{}
		uids := map[uint64]bool{}
		rows, e := s.DB.Query("SELECT uid,instance,record FROM inventory ORDER BY uid,instance")
		if e != nil {
			return e
		}
		for rows.Next() {
			var x savedItem
			if e = rows.Scan(&x.UID, &x.Instance, &x.Record); e != nil {
				rows.Close()
				return e
			}
			if len(x.Record) == protocol.InventoryRecordSize && protocol.ReadUint16(x.Record, protocol.InventorySlotOffset) != protocol.SlotUnequipped {
				inventory = append(inventory, x)
				uids[x.UID] = true
			}
		}
		e = rows.Err()
		rows.Close()
		if e != nil {
			return e
		}
		f, e := os.OpenFile(*backup, os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0600)
		if e != nil {
			return e
		}
		e = json.NewEncoder(f).Encode(map[string]any{"offers": offers, "equipped": inventory})
		closeErr := f.Close()
		if e != nil {
			return e
		}
		if closeErr != nil {
			return closeErr
		}
		selected := map[uint32]bool{253030: true, 253033: true, 253912: true}
		changes := []persistence.AdminOffer{}
		recommended := 0
		for _, o := range offers {
			if len(o.Grant) != protocol.InventoryRecordSize || o.Grant[4] != protocol.ItemWeapon {
				continue
			}
			feature := selected[protocol.ReadUint32(o.Grant, 5)]
			o.Recommended = &feature
			n, e := rand.Int(rand.Reader, big.NewInt(401))
			if e != nil {
				return e
			}
			price := uint32(n.Int64() + 100)
			if feature {
				price = 1
				o.Enabled = true
				recommended++
			}
			protocol.WriteUint32(o.Record, 30, 0)
			protocol.WriteUint32(o.Record, 34, 0)
			protocol.WriteUint32(o.Record, 38, price)
			protocol.WriteUint32(o.Record, 42, price)
			changes = append(changes, o)
		}
		if recommended != 3 {
			return fmt.Errorf("expected three known weapon offers, found %d; no mutation", recommended)
		}
		result, e := s.Admin(persistence.AdminRequest{Operation: "shop_batch", ID: fmt.Sprintf("weapon-prices-%d", time.Now().UnixNano()), Offers: changes})
		if e != nil {
			return e
		}
		for uid := range uids {
			if _, e = s.RoleManager().Snapshot(uid); e != nil {
				return e
			}
		}
		fmt.Printf("configuration=%v equipped_accounts=%d backup=%s\n", result, len(uids), *backup)
	}
	recommended, e := s.ShopManager().Offers(protocol.ShopCategoryRecommended, int(protocol.ItemWeapon))
	if e != nil {
		return e
	}
	bad := 0
	for _, o := range recommended {
		if protocol.ReadUint32(o.Record, 42) != 1 {
			bad++
		}
	}
	var inactive int
	e = s.DB.QueryRow("SELECT COUNT(*) FROM inventory WHERE LENGTH(record)=68 AND SUBSTRING(record,18,2)<>UNHEX('0000') AND SUBSTRING(record,20,4)=UNHEX('00000000')").Scan(&inactive)
	if e != nil {
		return e
	}
	fmt.Printf("recommended=%d non_one_ticket=%d equipped_unused=%d\n", len(recommended), bad, inactive)
	return nil
}
