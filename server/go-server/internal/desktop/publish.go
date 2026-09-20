package desktop

import (
	"archive/zip"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"kungfu.local/server/internal/releases"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

type weaponRelease struct {
	Data  []byte
	Notes string
}

func (admin *Admin) publishWeapon(release weaponRelease) (any, error) {
	var buffer bytes.Buffer
	z := zip.NewWriter(&buffer)
	f, err := z.Create("Data/config.spf2")
	if err != nil {
		return nil, err
	}
	if _, err = f.Write(release.Data); err != nil {
		return nil, err
	}
	if err = z.Close(); err != nil {
		return nil, err
	}
	raw := buffer.Bytes()
	m := releases.Manifest{Kind: "weapons", Version: time.Now().UTC().Format("20060102T150405.000000000Z"), Notes: release.Notes, SHA256: releases.Hash(raw), Size: int64(len(raw)), ConfigHash: releases.Hash(release.Data)}
	m.Package = m.SHA256 + ".zip"
	return admin.Publish(m, raw)
}

// Publish is shared by the GM editor and the maintainer's GM release packager.
func (admin *Admin) Publish(m releases.Manifest, raw []byte) (any, error) {
	if err := releases.ValidatePackage(m, raw); err != nil {
		return nil, err
	}
	data, err := os.ReadFile(filepath.Join(admin.Root, "runtime-local", "online-admin.json"))
	if err != nil {
		return nil, err
	}
	var c connection
	if err = json.Unmarshal(bytes.TrimPrefix(data, []byte{239, 187, 191}), &c); err != nil {
		return nil, err
	}
	if c.Host == "" || c.User == "" || strings.HasPrefix(c.Host, "-") || strings.HasPrefix(c.User, "-") {
		return nil, fmt.Errorf("SSH 配置无效")
	}
	if c.Port == 0 {
		c.Port = 22
	}
	if c.Port < 1 || c.Port > 65535 {
		return nil, fmt.Errorf("SSH 端口无效")
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
	defer cancel()
	command := exec.CommandContext(ctx, "ssh", "-T", "-i", c.Key, "-o", "BatchMode=yes", "-o", "IdentitiesOnly=yes", "-o", "StrictHostKeyChecking=yes", "-o", "ConnectTimeout=10", "-o", "ServerAliveInterval=10", "-o", "ServerAliveCountMax=2", "-p", strconv.Itoa(c.Port), c.User+"@"+c.Host, "sudo -n /opt/kungfu-go/update-publish")
	hideWindow(command)
	var input bytes.Buffer
	json.NewEncoder(&input).Encode(m)
	input.Write(raw)
	command.Stdin = &input
	var stderr bytes.Buffer
	command.Stderr = &stderr
	output, err := command.Output()
	if err != nil {
		return nil, fmt.Errorf("发布未确认完成，请检查线上版本再重试：%w\n%s", err, stderr.String())
	}
	var response map[string]any
	if err = json.Unmarshal(output, &response); err != nil {
		return nil, err
	}
	return response, nil
}
