package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

func (c *client) udp(id uint16, body []byte) error {
	p := make([]byte, 24)
	protocol.WriteUint16(p, 0, 1)
	protocol.WriteUint16(p, 2, id)
	protocol.WriteUint32(p, 4, c.p2p)
	protocol.WriteUint32(p, 12, c.p2p)
	return c.send(tunnel.Frame{Op: "udp", Port: 18000, Data: append(p, body...)})
}
func (c *client) registerP2P() error {
	if err := c.udp(1001, make([]byte, 141)); err != nil {
		return err
	}
	for i := 0; i < 64; i++ {
		f, _, err := c.read()
		if err != nil {
			return err
		}
		if f.Op != "udp" || len(f.Data) < 42 || protocol.ReadUint16(f.Data, 2) != 1002 {
			continue
		}
		c.p2p = protocol.ReadUint32(f.Data, 4)
		if c.p2p == 0 {
			return fmt.Errorf("无效 P2P 身份")
		}
		p := append(protocol.Uint64Bytes(c.uid), protocol.Uint32Bytes(c.p2p)...)
		if err = c.game(3, 1156, p); err != nil {
			return err
		}
		emit(output{Kind: "state", Text: fmt.Sprintf("P2P 已绑定 %d；每15秒续期，可测试房间", c.p2p)})
		return nil
	}
	return fmt.Errorf("未收到 P2P 注册回执")
}
func (c *client) keepP2P() error { return c.udp(1013, make([]byte, 4)) }
