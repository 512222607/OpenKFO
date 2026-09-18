package persistence

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"database/sql"
	"encoding/hex"
	"errors"
	_ "github.com/go-sql-driver/mysql"
	"golang.org/x/crypto/scrypt"
	"golang.org/x/text/encoding/simplifiedchinese"
	"kungfu.local/server/internal/protocol"
	"regexp"
	"strings"
	"time"
)

var ErrDenied = errors.New("request rejected")
var accountPattern = regexp.MustCompile(`^[a-zA-Z0-9]{3,20}$`)
var legacyPattern = regexp.MustCompile(`^[a-fA-F0-9]{64}$`)

type Store struct{ DB *sql.DB }
type Account struct {
	UID          uint64   `json:"uid"`
	Account      string   `json:"account"`
	Nickname     string   `json:"nickname"`
	Profile      []byte   `json:"profile"`
	Salt         []byte   `json:"salt,omitempty"`
	Digest       []byte   `json:"digest,omitempty"`
	LegacySalt   []byte   `json:"legacy_salt,omitempty"`
	LegacyDigest []byte   `json:"legacy_digest,omitempty"`
	Gold         uint32   `json:"gold"`
	Tickets      uint32   `json:"tickets"`
	Inventory    [][]byte `json:"inventory,omitempty"`
}
type Offer struct {
	Key      uint32 `json:"key"`
	Category byte   `json:"category"`
	Variant  byte   `json:"variant"`
	Record   []byte `json:"record"`
	Grant    []byte `json:"grant"`
}
type Export struct {
	Accounts []Account `json:"accounts"`
	Offers   []Offer   `json:"offers"`
}

var schema = []string{
	`CREATE TABLE IF NOT EXISTS battle_reward_rules(id TINYINT UNSIGNED PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS battle_settlements(serial INT UNSIGNED PRIMARY KEY,reports MEDIUMBLOB NOT NULL,result MEDIUMBLOB NOT NULL,created TIMESTAMP DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS accounts(
        uid BIGINT UNSIGNED PRIMARY KEY ,
        account VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL UNIQUE ,
        nickname VARCHAR(40) NOT NULL ,
        profile VARBINARY(360) NOT NULL ,
        salt VARBINARY(16) NOT NULL ,
        digest VARBINARY(32) NOT NULL ,
        legacy_salt VARBINARY(16) NOT NULL ,
        legacy_digest VARBINARY(32) NOT NULL ,
        gold BIGINT UNSIGNED NOT NULL DEFAULT 0 ,
        tickets BIGINT UNSIGNED NOT NULL DEFAULT 0
    ) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS inventory(
        uid BIGINT UNSIGNED NOT NULL ,
        instance INT UNSIGNED NOT NULL ,
        record VARBINARY(68) NOT NULL ,
        PRIMARY KEY(uid ,
        instance) ,
        FOREIGN KEY(uid) REFERENCES accounts(uid)
    ) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS offers(
        catalog_key INT UNSIGNED PRIMARY KEY ,
        category TINYINT UNSIGNED NOT NULL ,
        variant TINYINT UNSIGNED NOT NULL ,
        record VARBINARY(108) NOT NULL ,
        grant_record VARBINARY(68) NOT NULL ,
        enabled BOOLEAN NOT NULL DEFAULT TRUE
    ) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS purchases(
        uid BIGINT UNSIGNED NOT NULL ,
        operation_id VARCHAR(128) CHARACTER SET ascii NOT NULL ,
        request_hash BINARY(32) NOT NULL ,
        balance BIGINT UNSIGNED NOT NULL ,
        item_record VARBINARY(68) NOT NULL ,
        catalog_record VARBINARY(108) NOT NULL ,
        created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
        PRIMARY KEY(uid ,
        operation_id) ,
        FOREIGN KEY(uid) REFERENCES accounts(uid)
    ) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS wallet_operations(
        operation_id VARCHAR(128) CHARACTER SET ascii PRIMARY KEY ,
        uid BIGINT UNSIGNED NOT NULL ,
        mode VARCHAR(4) NOT NULL ,
        amount BIGINT UNSIGNED NOT NULL ,
        before_balance BIGINT UNSIGNED NOT NULL ,
        after_balance BIGINT UNSIGNED NOT NULL ,
        created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
        FOREIGN KEY(uid) REFERENCES accounts(uid)
    ) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS counters(
        name VARCHAR(32) PRIMARY KEY ,
        value BIGINT UNSIGNED NOT NULL
    ) ENGINE=InnoDB`,
	`INSERT IGNORE INTO counters(name,value) VALUES('battle',0)`,
	`CREATE TABLE IF NOT EXISTS training(
        uid BIGINT UNSIGNED PRIMARY KEY ,
        started BIGINT NULL ,
        FOREIGN KEY(uid) REFERENCES accounts(uid)
    ) ENGINE=InnoDB`,
	`CREATE TABLE IF NOT EXISTS consumption_events (
	    uid BIGINT UNSIGNED NOT NULL,
	    battle INT UNSIGNED NOT NULL,
	    sequence INT UNSIGNED NOT NULL,
	    instance INT UNSIGNED NOT NULL,
	    signature VARBINARY(40) NOT NULL,
	    PRIMARY KEY(uid,battle,sequence),
	    FOREIGN KEY(uid) REFERENCES accounts(uid)
	) ENGINE=InnoDB`,
}

func Open(dsn string) (*Store, error) { return open(dsn, true) }

// A running local server already migrated its database. GM requests must not
// repeat every DDL statement across the SSH database tunnel.
func OpenExisting(dsn string) (*Store, error) { return open(dsn, false) }

func open(dsn string, initialize bool) (*Store, error) {
	database, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, err
	}
	database.SetMaxOpenConns(8)
	database.SetMaxIdleConns(4)
	database.SetConnMaxLifetime(3 * time.Minute)
	store := &Store{database}
	contextWithTimeout, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err = database.PingContext(contextWithTimeout); err == nil && initialize {
		for _, statement := range schema {
			if _, err = database.ExecContext(contextWithTimeout, statement); err != nil {
				break
			}
		}
	}
	if err != nil {
		database.Close()
		return nil, err
	}
	return store, nil
}
func (store *Store) Snapshot(uid uint64) (Account, error) {
	account := Account{UID: uid}
	err := store.DB.QueryRow(`SELECT account,nickname,profile,gold,tickets FROM accounts WHERE uid=?`, uid).Scan(&account.Account, &account.Nickname, &account.Profile, &account.Gold, &account.Tickets)
	if err != nil {
		return account, err
	}
	rows, err := store.DB.Query(`SELECT record FROM inventory WHERE uid=? ORDER BY instance`, uid)
	if err != nil {
		return account, err
	}
	defer rows.Close()
	for rows.Next() {
		var record []byte
		if err = rows.Scan(&record); err != nil {
			return account, err
		}
		if len(record) != 68 {
			return account, ErrDenied
		}
		account.Inventory = append(account.Inventory, record)
	}
	if len(account.Profile) != 360 {
		return account, ErrDenied
	}
	return account, rows.Err()
}
func (account Account) InventoryBytes() []byte { return bytes.Join(account.Inventory, nil) }
func (store *Store) Authenticate(account, legacy string) (Account, error) {
	if !accountPattern.MatchString(account) || !legacyPattern.MatchString(legacy) {
		return Account{}, ErrDenied
	}
	account = strings.ToLower(account)
	var uid uint64
	var salt, digest []byte
	lookupErr := store.DB.QueryRow(`SELECT uid,legacy_salt,legacy_digest FROM accounts WHERE account=?`, account).Scan(&uid, &salt, &digest)
	// Do comparable expensive work for an unknown account; never expose account existence.
	if lookupErr != nil {
		salt = make([]byte, 16)
		digest = make([]byte, 32)
	}
	actual, err := scrypt.Key([]byte(strings.ToLower(legacy)), salt, 32768, 8, 3, 32)
	if err != nil || lookupErr != nil || len(salt) != 16 || len(digest) != 32 || subtle.ConstantTimeCompare(actual, digest) != 1 {
		return Account{}, ErrDenied
	}
	return store.Snapshot(uid)
}
func NewAccount(uid uint64, name, password string) (Account, error) {
	if uid == 0 || !accountPattern.MatchString(name) || len(password) < 6 || len(password) > 128 {
		return Account{}, ErrDenied
	}
	account := Account{UID: uid, Account: strings.ToLower(name), Nickname: name, Profile: make([]byte, 360), Salt: make([]byte, 16), LegacySalt: make([]byte, 16)}
	if _, err := rand.Read(account.Salt); err != nil {
		return account, err
	}
	if _, err := rand.Read(account.LegacySalt); err != nil {
		return account, err
	}
	var err error
	account.Digest, err = scrypt.Key([]byte(password), account.Salt, 32768, 8, 3, 32)
	if err != nil {
		return account, err
	}
	passwordHash := sha256.Sum256(append([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLv"), []byte(password)...))
	account.LegacyDigest, err = scrypt.Key([]byte(hex.EncodeToString(passwordHash[:])), account.LegacySalt, 32768, 8, 3, 32)
	if err != nil {
		return account, err
	}
	protocol.WriteUint32(account.Profile, 0, 1)
	copy(account.Profile[4:25], name)
	account.Profile[122] = 1
	account.Profile[124] = 1
	for index, equipment := range [][3]uint32{{121005, 12, 4}, {131011, 13, 3}, {141005, 14, 7}, {151005, 15, 2}, {161005, 16, 6}, {171005, 17, 5}, {253030, 25, 8}} {
		record := make([]byte, 68)
		protocol.WriteUint32(record, 0, 0x100000+uint32(index))
		record[4] = byte(equipment[1])
		protocol.WriteUint32(record, 5, equipment[0])
		protocol.WriteUint32(record, 13, 8760)
		protocol.WriteUint16(record, 17, uint16(equipment[2]))
		account.Inventory = append(account.Inventory, record)
	}
	return account, nil
}
func insertAccount(transaction *sql.Tx, account Account) error {
	if len(account.Profile) != 360 || len(account.Salt) != 16 || len(account.Digest) != 32 || len(account.LegacySalt) != 16 || len(account.LegacyDigest) != 32 || account.UID == 0 || !accountPattern.MatchString(account.Account) {
		return ErrDenied
	}
	_, err := transaction.Exec(`INSERT INTO accounts VALUES(?,?,?,?,?,?,?,?,?,?)`, account.UID, strings.ToLower(account.Account), account.Nickname, account.Profile, account.Salt, account.Digest, account.LegacySalt, account.LegacyDigest, account.Gold, account.Tickets)
	if err != nil {
		return err
	}
	for _, record := range account.Inventory {
		if len(record) != 68 {
			return ErrDenied
		}
		if _, err = transaction.Exec(`INSERT INTO inventory VALUES(?,?,?)`, account.UID, protocol.ReadUint32(record, 0), record); err != nil {
			return err
		}
	}
	return nil
}
func (store *Store) Create(account Account) error {
	transaction, err := store.DB.Begin()
	if err != nil {
		return err
	}
	defer transaction.Rollback()
	if err = insertAccount(transaction, account); err != nil {
		return err
	}
	return transaction.Commit()
}

// ResetPassword changes only credentials, preserving character and inventory.
func (store *Store) ResetPassword(uid uint64, name, password string) error {
	credentials, err := NewAccount(uid, name, password)
	if err != nil {
		return err
	}
	result, err := store.DB.Exec(`UPDATE accounts SET salt=?,digest=?,legacy_salt=?,legacy_digest=? WHERE uid=? AND account=?`, credentials.Salt, credentials.Digest, credentials.LegacySalt, credentials.LegacyDigest, uid, credentials.Account)
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if count != 1 {
		return ErrDenied
	}
	return nil
}
func (store *Store) Import(export Export) error {
	transaction, err := store.DB.Begin()
	if err != nil {
		return err
	}
	defer transaction.Rollback()
	var count int
	if err = transaction.QueryRow(`SELECT COUNT(*) FROM accounts`).Scan(&count); err != nil {
		return err
	}
	if count != 0 {
		return errors.New("import requires empty game database")
	}
	for _, account := range export.Accounts {
		if err = insertAccount(transaction, account); err != nil {
			return err
		}
	}
	for _, offer := range export.Offers {
		if len(offer.Record) != 108 || len(offer.Grant) != 68 {
			return ErrDenied
		}
		if _, err = transaction.Exec(`INSERT INTO offers VALUES(?,?,?,?,?,TRUE)`, offer.Key, offer.Category, offer.Variant, offer.Record, offer.Grant); err != nil {
			return err
		}
	}
	return transaction.Commit()
}
func (store *Store) Offers(category, variant int) ([]Offer, error) {
	query := `SELECT catalog_key,category,variant,record,grant_record FROM offers WHERE enabled=TRUE`
	args := []any{}
	if category >= 0 {
		query += ` AND category=? AND variant=?`
		args = append(args, category, variant)
	}
	query += ` ORDER BY catalog_key LIMIT 4000`
	rows, err := store.DB.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var offers []Offer
	for rows.Next() {
		var offer Offer
		if err = rows.Scan(&offer.Key, &offer.Category, &offer.Variant, &offer.Record, &offer.Grant); err != nil {
			return nil, err
		}
		if len(offer.Record) != 108 || len(offer.Grant) != 68 {
			return nil, ErrDenied
		}
		offers = append(offers, offer)
	}
	return offers, rows.Err()
}

var Slots = map[byte][]uint16{12: {4}, 13: {3}, 14: {7}, 15: {2}, 16: {6}, 17: {5}, 18: {4}, 20: {10}, 21: {11}, 25: {8, 9}, 64: {27, 28}}

func (store *Store) Equip(uid uint64, instance uint32, slot uint16) ([]byte, error) {
	transaction, err := store.DB.Begin()
	if err != nil {
		return nil, err
	}
	defer transaction.Rollback()
	var owner uint64
	if err = transaction.QueryRow(`SELECT uid FROM accounts WHERE uid=? FOR UPDATE`, uid).Scan(&owner); err != nil {
		return nil, err
	}
	var record []byte
	if err = transaction.QueryRow(`SELECT record FROM inventory WHERE uid=? AND instance=?`, uid, instance).Scan(&record); err != nil || len(record) != 68 {
		return nil, ErrDenied
	}
	if slot == 0 && protocol.ReadUint16(record, 17) == 0 {
		return nil, nil
	}
	if slot != 0 {
		allowed := false
		for _, allowedSlot := range Slots[record[4]] {
			allowed = allowed || allowedSlot == slot
		}
		if !allowed {
			return nil, ErrDenied
		}
		rows, err := transaction.Query(`SELECT instance,record FROM inventory WHERE uid=?`, uid)
		if err != nil {
			return nil, err
		}
		type change struct {
			instance uint32
			record   []byte
		}
		var edits []change
		for rows.Next() {
			var change change
			if err = rows.Scan(&change.instance, &change.record); err != nil {
				rows.Close()
				return nil, err
			}
			if len(change.record) == 68 && protocol.ReadUint16(change.record, 17) == slot {
				protocol.WriteUint16(change.record, 17, 0)
				edits = append(edits, change)
			}
		}
		err = rows.Err()
		rows.Close()
		if err != nil {
			return nil, err
		}
		for _, change := range edits {
			if _, err = transaction.Exec(`UPDATE inventory SET record=? WHERE uid=? AND instance=?`, change.record, uid, change.instance); err != nil {
				return nil, err
			}
		}
	}
	protocol.WriteUint16(record, 17, slot)
	if _, err = transaction.Exec(`UPDATE inventory SET record=? WHERE uid=? AND instance=?`, record, uid, instance); err != nil {
		return nil, err
	}
	return record, transaction.Commit()
}
func (store *Store) Purchase(uid uint64, operationID string, request []byte) (uint32, []byte, []byte, error) {
	if len(request) != 169 || len(operationID) == 0 || len(operationID) > 128 {
		return 0, nil, nil, ErrDenied
	}
	transaction, err := store.DB.Begin()
	if err != nil {
		return 0, nil, nil, err
	}
	defer transaction.Rollback()
	var gold, tickets uint32
	if err = transaction.QueryRow(`SELECT gold,tickets FROM accounts WHERE uid=? FOR UPDATE`, uid).Scan(&gold, &tickets); err != nil {
		return 0, nil, nil, err
	}
	requestHash := sha256.Sum256(request)
	var previousHash, previousItem, previousCatalog []byte
	var previousBalance uint32
	err = transaction.QueryRow(`SELECT request_hash,balance,item_record,catalog_record FROM purchases WHERE uid=? AND operation_id=?`, uid, operationID).Scan(&previousHash, &previousBalance, &previousItem, &previousCatalog)
	if err == nil {
		if !bytes.Equal(previousHash, requestHash[:]) {
			return 0, nil, nil, ErrDenied
		}
		var currentItem []byte
		lookupErr := transaction.QueryRow(`SELECT record FROM inventory WHERE uid=? AND instance=?`, uid, protocol.ReadUint32(previousItem, 0)).Scan(&currentItem)
		if lookupErr != nil && lookupErr != sql.ErrNoRows {
			return 0, nil, nil, lookupErr
		}
		previousItem = currentItem
		if err = transaction.Commit(); err != nil {
			return 0, nil, nil, err
		}
		if protocol.ReadUint32(previousCatalog, 30) > 0 {
			previousBalance = gold
		} else {
			previousBalance = tickets
		}
		return previousBalance, previousItem, previousCatalog, nil
	}
	if err != sql.ErrNoRows {
		return 0, nil, nil, err
	}
	var catalog, item []byte
	err = transaction.QueryRow(`SELECT record,grant_record FROM offers WHERE catalog_key=? AND enabled=TRUE FOR UPDATE`, protocol.ReadUint32(request, 145)).Scan(&catalog, &item)
	if err != nil || len(catalog) != 108 || len(item) != 68 {
		return 0, nil, nil, ErrDenied
	}
	goldPrice, ticketPrice := protocol.ReadUint32(catalog, 30), protocol.ReadUint32(catalog, 38)
	if catalog[48] == 0 || catalog[46] != 0 || catalog[49] != 0 || catalog[13] != 0 || catalog[83] != 1 || protocol.ReadUint32(catalog, 88) != 0 || protocol.ReadUint32(catalog, 77) != 0 || (goldPrice == 0) == (ticketPrice == 0) || goldPrice > 2147483647 || ticketPrice > 2147483647 || protocol.ReadUint32(catalog, 34) != goldPrice || protocol.ReadUint32(catalog, 42) != ticketPrice {
		return 0, nil, nil, ErrDenied
	}
	currencyCode, balance, price := uint32(109), tickets, ticketPrice
	column := "tickets"
	if goldPrice > 0 {
		currencyCode, balance, price = 111, gold, goldPrice
		column = "gold"
	}
	if protocol.ReadUint32(request, 0) != currencyCode || protocol.ReadUint64(request, 4) != uid || protocol.ReadUint64(request, 54) != uid || protocol.ReadUint32(request, 149) != goldPrice || protocol.ReadUint32(request, 157) != ticketPrice || protocol.ReadUint32(request, 153) != 0 || protocol.ReadUint32(request, 161) != 0 || protocol.ReadUint32(request, 165) != 0 || balance < price {
		return 0, nil, nil, ErrDenied
	}
	var instance uint64
	if err = transaction.QueryRow(`SELECT COALESCE(MAX(instance),1048575)+1 FROM inventory WHERE uid=?`, uid).Scan(&instance); err != nil {
		return 0, nil, nil, err
	}
	if instance > 0xffffffff {
		return 0, nil, nil, ErrDenied
	}
	protocol.WriteUint32(item, 0, uint32(instance))
	balance -= price
	if _, err = transaction.Exec(`UPDATE accounts SET `+column+`=? WHERE uid=?`, balance, uid); err != nil {
		return 0, nil, nil, err
	}
	if _, err = transaction.Exec(`INSERT INTO inventory VALUES(?,?,?)`, uid, instance, item); err != nil {
		return 0, nil, nil, err
	}
	if _, err = transaction.Exec(`INSERT INTO purchases(uid,operation_id,request_hash,balance,item_record,catalog_record) VALUES(?,?,?,?,?,?)`, uid, operationID, requestHash[:], balance, item, catalog); err != nil {
		return 0, nil, nil, err
	}
	return balance, item, catalog, transaction.Commit()
}
func (store *Store) Wallet(uid uint64, mode string, amount uint32, operationID string) (uint32, uint32, error) {
	if (mode != "gift" && mode != "set") || amount > 2147483647 || len(operationID) < 1 || len(operationID) > 128 {
		return 0, 0, ErrDenied
	}
	transaction, err := store.DB.Begin()
	if err != nil {
		return 0, 0, err
	}
	defer transaction.Rollback()
	var before uint32
	if err = transaction.QueryRow(`SELECT tickets FROM accounts WHERE uid=? FOR UPDATE`, uid).Scan(&before); err != nil {
		return 0, 0, err
	}
	var oldUID uint64
	var oldMode string
	var oldAmount, oldBefore, oldAfter uint32
	err = transaction.QueryRow(`SELECT uid,mode,amount,before_balance,after_balance FROM wallet_operations WHERE operation_id=?`, operationID).Scan(&oldUID, &oldMode, &oldAmount, &oldBefore, &oldAfter)
	if err == nil {
		if oldUID != uid || mode != oldMode || amount != oldAmount {
			return 0, 0, ErrDenied
		}
		return oldBefore, oldAfter, transaction.Commit()
	}
	if err != sql.ErrNoRows {
		return 0, 0, err
	}
	after := uint64(amount)
	if mode == "gift" {
		after += uint64(before)
	}
	if after > 2147483647 {
		return 0, 0, ErrDenied
	}
	if _, err = transaction.Exec(`UPDATE accounts SET tickets=? WHERE uid=?`, after, uid); err != nil {
		return 0, 0, err
	}
	if _, err = transaction.Exec(`INSERT INTO wallet_operations(operation_id,uid,mode,amount,before_balance,after_balance) VALUES(?,?,?,?,?,?)`, operationID, uid, mode, amount, before, after); err != nil {
		return 0, 0, err
	}
	return before, uint32(after), transaction.Commit()
}
func (store *Store) NextBattle() (uint32, error) {
	transaction, err := store.DB.Begin()
	if err != nil {
		return 0, err
	}
	defer transaction.Rollback()
	var serial uint64
	if err = transaction.QueryRow(`SELECT value FROM counters WHERE name='battle' FOR UPDATE`).Scan(&serial); err != nil {
		return 0, err
	}
	if serial >= 0xffffffff {
		return 0, ErrDenied
	}
	serial++
	if _, err = transaction.Exec(`UPDATE counters SET value=? WHERE name='battle'`, serial); err != nil {
		return 0, err
	}
	return uint32(serial), transaction.Commit()
}
func (store *Store) Training(uid uint64, start bool) (uint32, bool, error) {
	if _, err := store.DB.Exec(`INSERT IGNORE INTO training(uid) VALUES(?)`, uid); err != nil {
		return 0, false, err
	}
	if start {
		if _, err := store.DB.Exec(`UPDATE training SET started=? WHERE uid=? AND started IS NULL`, time.Now().Unix(), uid); err != nil {
			return 0, false, err
		}
	}
	var started sql.NullInt64
	if err := store.DB.QueryRow(`SELECT started FROM training WHERE uid=?`, uid).Scan(&started); err != nil {
		return 0, false, err
	}
	if !started.Valid {
		return 0, false, nil
	}
	minutes := (time.Now().Unix() - started.Int64) / 60
	if minutes < 0 {
		minutes = 0
	}
	if minutes > 35791394 {
		minutes = 35791394
	}
	return uint32(minutes), true, nil
}
func GBK(text string) []byte {
	encoded, err := simplifiedchinese.GBK.NewEncoder().Bytes([]byte(text))
	if err != nil {
		return []byte("?")
	}
	return encoded
}
