package desktop

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"kungfu.local/server/internal/persistence"
)

type Request struct {
	Operation string   `json:"operation"`
	ID        string   `json:"id"`
	UID       uint64   `json:"uid"`
	Mode      string   `json:"mode"`
	Amount    uint32   `json:"amount"`
	Keys      []string `json:"keys"`
	Key       string   `json:"key"`
	Quantity  int      `json:"quantity"`
	Days      int      `json:"days"`
	Currency  string   `json:"currency"`
	Price     int64    `json:"price"`
	Enabled   *bool    `json:"enabled"`
	All       bool     `json:"all"`
	Weapon    int      `json:"weapon"`
	Revision  string   `json:"revision"`
	Rules     []Rule   `json:"rules"`
}
type Admin struct {
	Root   string
	Remote func(persistence.AdminRequest) (json.RawMessage, error)
}

func New(root string) *Admin { admin := &Admin{Root: root}; admin.Remote = admin.remote; return admin }

type connection struct {
	Host string `json:"host"`
	User string `json:"user"`
	Key  string `json:"key"`
	Port int    `json:"port"`
}

func (admin *Admin) remote(request persistence.AdminRequest) (json.RawMessage, error) {
	data, err := os.ReadFile(filepath.Join(admin.Root, "runtime-local", "online-admin.json"))
	if err != nil {
		return nil, err
	}
	var config connection
	if err = json.Unmarshal(bytes.TrimPrefix(data, []byte{239, 187, 191}), &config); err != nil {
		return nil, err
	}
	if config.Host == "" || config.User == "" || strings.HasPrefix(config.Host, "-") || strings.HasPrefix(config.User, "-") {
		return nil, fmt.Errorf("SSH 配置无效")
	}
	if config.Port == 0 {
		config.Port = 22
	}
	if config.Port < 1 || config.Port > 65535 {
		return nil, fmt.Errorf("SSH 端口无效")
	}
	if _, err = os.Stat(config.Key); err != nil {
		return nil, fmt.Errorf("找不到 SSH 密钥；未操作本地数据库")
	}
	input, err := json.Marshal(request)
	if err != nil {
		return nil, err
	}
	ctx, cancel := context.WithTimeout(context.Background(), 75*time.Second)
	defer cancel()
	command := exec.CommandContext(ctx, "ssh", "-T", "-i", config.Key, "-o", "BatchMode=yes", "-o", "IdentitiesOnly=yes", "-o", "StrictHostKeyChecking=yes", "-o", "ConnectTimeout=10", "-o", "ServerAliveInterval=10", "-o", "ServerAliveCountMax=2", "-p", strconv.Itoa(config.Port), config.User+"@"+config.Host, `sudo -n bash -c 'export "$(cat /etc/kungfu-go/game.env)"; exec /opt/kungfu-go/kungfu-admin'`)
	hideWindow(command)
	command.Stdin = bytes.NewReader(input)
	var stderr bytes.Buffer
	command.Stderr = &stderr
	output, err := command.Output()
	if ctx.Err() != nil {
		return nil, fmt.Errorf("线上请求超时；写入结果可能尚未收到，请保持原操作重试")
	}
	if err != nil {
		detail := stderr.String()
		if len(detail) > 1500 {
			detail = detail[len(detail)-1500:]
		}
		return nil, fmt.Errorf("线上管理连接失败；未回退本地数据库。\n%s", strings.TrimSpace(detail))
	}
	var response struct {
		OK     bool            `json:"ok"`
		Result json.RawMessage `json:"result"`
		Error  string          `json:"error"`
	}
	if err = json.Unmarshal(output, &response); err != nil {
		return nil, fmt.Errorf("线上管理返回无效响应，请检查管理程序是否已部署")
	}
	if !response.OK {
		return nil, fmt.Errorf("%s", response.Error)
	}
	return response.Result, nil
}
func template(item Item, quantity, days int) []byte {
	record := make([]byte, 68)
	record[4] = item.Kind
	little.PutUint32(record[5:], item.ID)
	if item.Stackable {
		little.PutUint16(record[23:], uint16(quantity))
	} else if item.Timed {
		little.PutUint32(record[13:], uint32(days*24))
	}
	return record
}
func offer(item Item, request Request) (persistence.AdminOffer, error) {
	var result persistence.AdminOffer
	if request.Enabled == nil || (request.Currency != "gold" && request.Currency != "ticket") || request.Price < 1 || request.Price > 2147483647 || request.Days < 1 || request.Days > 3650 || request.Quantity < 1 || request.Quantity > 999 || item.ID > 0x8fffffff {
		return result, fmt.Errorf("价格、期限、数量或上架状态无效")
	}
	key := 0x70000000 + item.ID
	record := make([]byte, 108)
	little.PutUint32(record, key)
	record[4] = item.Kind
	little.PutUint32(record[5:], item.ID)
	little.PutUint32(record[9:], key)
	if len(item.Fields) > 6 {
		mask, err := strconv.ParseUint(item.Fields[6], 10, 32)
		if err != nil {
			return result, err
		}
		little.PutUint32(record[14:], uint32(mask))
	}
	offset := 30
	if request.Currency == "ticket" {
		offset = 38
	}
	little.PutUint32(record[offset:], uint32(request.Price))
	little.PutUint32(record[offset+4:], uint32(request.Price))
	record[48] = 1
	record[83] = 1
	if item.Stackable {
		little.PutUint32(record[26:], uint32(request.Quantity))
	} else {
		little.PutUint32(record[22:], uint32(request.Days*24))
	}
	return persistence.AdminOffer{Offer: persistence.Offer{Key: key, Category: 10, Variant: item.Kind, Record: record, Grant: template(item, request.Quantity, request.Days)}, Enabled: *request.Enabled}, nil
}
func (admin *Admin) Call(request Request) (any, error) {
	remote := persistence.AdminRequest{Operation: request.Operation, ID: request.ID, UID: request.UID, Mode: request.Mode, Amount: request.Amount}
	switch request.Operation {
	case "accounts", "inventory", "wallet_accounts", "wallet_update":
		return admin.Remote(remote)
	}
	client := filepath.Join(admin.Root, "runtime-local", "client")
	items, err := Catalog(client)
	if err != nil {
		return nil, err
	}
	if strings.HasPrefix(request.Operation, "weapon_") {
		return weaponHandle(request, client, items, "")
	}
	if request.Operation == "catalog" {
		categories := map[byte]bool{}
		for _, item := range items {
			categories[item.Kind] = true
		}
		return map[string]any{"items": items, "root": admin.Root, "database": "线上 MySQL", "environment": "线上服务器", "categories": len(categories)}, nil
	}
	byKey := map[string]Item{}
	available := []Item{}
	for _, item := range items {
		byKey[item.Key] = item
		if item.Supported {
			available = append(available, item)
		}
	}
	if request.Operation == "shop_catalog" {
		encoded, err := admin.Remote(remote)
		if err != nil {
			return nil, err
		}
		var rows []persistence.AdminOffer
		if err = json.Unmarshal(encoded, &rows); err != nil {
			return nil, err
		}
		offers := map[string]any{}
		for _, row := range rows {
			if len(row.Record) != 108 || len(row.Grant) != 68 {
				return nil, fmt.Errorf("线上商品记录长度异常")
			}
			key := fmt.Sprintf("%d:%d", row.Grant[4], little.Uint32(row.Grant[5:]))
			price := little.Uint32(row.Record[38:])
			currency := "ticket"
			if price == 0 {
				currency = "gold"
				price = little.Uint32(row.Record[30:])
			}
			days := little.Uint32(row.Grant[13:]) / 24
			if days == 0 {
				days = 365
			}
			quantity := little.Uint16(row.Grant[23:])
			if quantity == 0 {
				quantity = 1
			}
			offers[key] = map[string]any{"currency": currency, "price": price, "days": days, "quantity": quantity, "enabled": row.Enabled}
		}
		return map[string]any{"items": available, "offers": offers, "environment": "线上 MySQL"}, nil
	}
	if request.Operation != "grant" && request.Operation != "shop_save" && request.Operation != "shop_batch" {
		return nil, fmt.Errorf("不支持的管理操作")
	}
	if len(request.ID) < 1 || len(request.ID) > 100 {
		return nil, fmt.Errorf("操作编号无效")
	}
	keys := request.Keys
	if request.Operation == "shop_save" {
		keys = []string{request.Key}
	}
	if request.All && request.Operation == "shop_batch" {
		keys = []string{}
		for _, item := range available {
			keys = append(keys, item.Key)
		}
	}
	if len(keys) < 1 || len(keys) > 4000 {
		return nil, fmt.Errorf("请选择 1–4000 件道具")
	}
	seen := map[string]bool{}
	for _, key := range keys {
		item, exists := byKey[key]
		if !exists || seen[key] || (request.Operation != "grant" && !item.Supported) {
			return nil, fmt.Errorf("道具无效或重复")
		}
		seen[key] = true
	}
	if request.Operation == "grant" {
		if request.Quantity < 1 || request.Quantity > 999 || request.Days < 1 || request.Days > 3650 {
			return nil, fmt.Errorf("数量或期限无效")
		}
		for _, key := range keys {
			remote.Records = append(remote.Records, template(byKey[key], request.Quantity, request.Days))
		}
	} else {
		if request.Enabled == nil {
			return nil, fmt.Errorf("上架状态无效")
		}
		remote.Enabled = *request.Enabled
		remote.All = request.All && request.Operation == "shop_batch"
		remote.Preserve = request.Operation == "shop_batch"
		if remote.Preserve {
			request.Currency = "ticket"
			request.Price = 100
			request.Days = 365
			request.Quantity = 1
		}
		for _, key := range keys {
			row, err := offer(byKey[key], request)
			if err != nil {
				return nil, err
			}
			remote.Offers = append(remote.Offers, row)
		}
	}
	return admin.Remote(remote)
}
