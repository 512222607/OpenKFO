package desktop

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
)

func (admin *Admin) local(request persistence.AdminRequest) (json.RawMessage, error) {
	path := admin.LocalSettings
	if path == "" {
		for _, candidate := range []string{
			filepath.Join(admin.Root, "dist", "local-server", "settings.private.json"),
			filepath.Join(admin.Root, "..", "OpenKFO", "dist", "local-server", "settings.private.json"),
		} {
			if _, err := os.Stat(candidate); err == nil {
				path = candidate
				break
			}
		}
	}
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("找不到本地测试服配置，请设置 --local-settings")
	}
	var config struct {
		DSN      string `json:"dsn"`
		Database string `json:"database"`
	}
	if json.Unmarshal(bytes.TrimPrefix(data, []byte{239, 187, 191}), &config) != nil {
		return nil, fmt.Errorf("本地配置无效")
	}
	dsn, err := mysql.ParseDSN(config.DSN)
	if err != nil {
		return nil, fmt.Errorf("本地数据库连接配置无效")
	}
	host, _, err := net.SplitHostPort(dsn.Addr)
	if err != nil || dsn.Net != "tcp" || (host != "127.0.0.1" && host != "localhost" && host != "::1") || dsn.DBName != config.Database || !strings.HasPrefix(dsn.DBName, "openkfo_debug_") {
		return nil, fmt.Errorf("本地环境只允许回环地址上的 openkfo_debug_ 独立测试库")
	}
	dsn.Timeout, dsn.ReadTimeout, dsn.WriteTimeout = 5*time.Second, 15*time.Second, 15*time.Second
	store, err := persistence.OpenExisting(dsn.FormatDSN())
	if err != nil {
		return nil, fmt.Errorf("本地测试库连接失败，请先启动本地后台；不会改用线上数据库")
	}
	defer store.DB.Close()
	result, err := store.Admin(request)
	if err != nil {
		return nil, err
	}
	return json.Marshal(result)
}
