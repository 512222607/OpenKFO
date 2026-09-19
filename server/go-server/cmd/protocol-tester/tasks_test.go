package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestExtendedTaskActionDiagnostic(t *testing.T) {
	p := make([]byte, 22)
	p[12], p[13] = 0xd1, 7
	if s := describe(protocol.Message{ID: 20530, Payload: p}); !strings.Contains(s, "2001") || !strings.Contains(s, "越界风险") {
		t.Fatal(s)
	}
	if s := describe(protocol.Message{ID: 20530, Payload: p[:21]}); !strings.Contains(s, "截断") {
		t.Fatal(s)
	}
	for id, state := range map[uint32]byte{6051: 2, 6052: 2, 6081: 1, 6082: 1, 6311: 3, 6312: 3} {
		p := make([]byte, 19)
		p[0], p[1], p[2] = 0xd1, 7, state
		if s := describe(protocol.Message{ID: id, Payload: p}); !strings.Contains(s, "配置键=2001") || !strings.Contains(s, "不可用于鉴权") {
			t.Fatal(s)
		}
		if s := describe(protocol.Message{ID: id, Payload: p[:18]}); !strings.Contains(s, "无效") {
			t.Fatal(s)
		}
	}
	for _, id := range []uint32{6031, 6032, 6061, 6062, 6091, 6092, 6301, 6302} {
		if s := describe(protocol.Message{ID: id, Payload: []byte{0xd1, 7, 3}}); !strings.Contains(s, "配置键=2001") {
			t.Fatal(s)
		}
	}
}

func TestTaskNotificationDiagnostic(t *testing.T) {
	for _, id := range []uint32{6030, 6040, 6060, 6090} {
		offset := 12
		if id == 6040 {
			offset = 4
		}
		p := make([]byte, offset+2)
		p[offset], p[offset+1] = 0xe9, 3
		s := describe(protocol.Message{ID: id, Payload: p})
		if !strings.Contains(s, "配置键=1001") || !strings.Contains(s, "任务通知") {
			t.Fatal(s)
		}
		if s = describe(protocol.Message{ID: id, Payload: p[:len(p)-1]}); !strings.Contains(s, "截断") {
			t.Fatal(s)
		}
	}
}

func TestTitleAwardDiagnostic(t *testing.T) {
	if s := describe(protocol.Message{ID: 4125, Payload: []byte{1}}); !strings.Contains(s, "截断") {
		t.Fatal(s)
	}
	p := make([]byte, 64)
	p[0] = 3
	if s := describe(protocol.Message{ID: 4125, Payload: p}); !strings.Contains(s, "等级=3") {
		t.Fatal(s)
	}
}

func TestTaskRecordNativeLayout(t *testing.T) {
	for id, label := range map[uint32]string{6041: "每日任务", 6042: "新手任务"} {
		if s := describe(protocol.Message{ID: id, Payload: make([]byte, 141)}); !strings.Contains(s, label) {
			t.Fatal("wrong task catalogue", s)
		}
	}
	for _, c := range []struct {
		id             uint32
		stride, offset int
	}{{6010, 7, 4}, {6020, 123, 4}, {6041, 141, 12}, {6042, 141, 12}} {
		p := make([]byte, c.stride*2)
		p[0], p[1] = 0xff, 0xee
		p[c.offset], p[c.offset+1] = 0x34, 0x12
		p[c.stride+c.offset], p[c.stride+c.offset+1] = 0xcd, 0xab
		r, err := protocol.ParseTaskRecords(c.id, p)
		if err != nil || len(r) != 2 || r[0].Key != 0x1234 || r[1].Key != 0xabcd {
			t.Fatal(c, r, err)
		}
		r[0].Raw[0] = 0
		if p[0] != 0xff {
			t.Fatal("parser aliases network input")
		}
		if text := describe(protocol.Message{ID: c.id, Payload: p}); !strings.Contains(text, "共2条") {
			t.Fatal(text)
		}
		for _, n := range []int{1, c.stride - 1, c.stride + 1, c.stride*2 - 1} {
			if _, err := protocol.ParseTaskRecords(c.id, make([]byte, n)); err == nil {
				t.Fatal("truncated accepted", n)
			}
		}
	}
	if r, e := protocol.ParseTaskRecords(6020, make([]byte, 7)); e != nil || len(r) != 0 {
		t.Fatal(r, e)
	}
	if _, e := protocol.ParseTaskRecords(6020, nil); e == nil {
		t.Fatal("empty6020 accepted")
	}
	if _, e := protocol.ParseTaskRecords(6041, nil); e != nil {
		t.Fatal(e)
	}
	if _, e := protocol.ParseTaskRecords(9999, nil); e == nil {
		t.Fatal("unknown opcode accepted")
	}
}

func TestTaskActionNativeSenders(t *testing.T) {
	// Arbitrary prefix is retained, not treated as a reliable identity.
	p := []byte{255, 238, 221, 204, 187, 170, 153, 136, 0x78, 0x56, 0x34, 0x12, 0xcd, 0xab}
	for _, id := range []uint32{6050, 6080} {
		r, err := protocol.ParseTaskAction(id, p)
		if err != nil || r.Context != 0x12345678 || r.Key != 0xabcd || r.Prefix[0] != 255 {
			t.Fatal(r, err)
		}
		if !strings.Contains(describe(protocol.Message{ID: id, Payload: p}), "不能作为玩家鉴权依据") {
			t.Fatal("missing identity warning")
		}
		for _, n := range []int{0, 6, 12, 13, 15} {
			if _, err := protocol.ParseTaskAction(id, make([]byte, n)); err == nil {
				t.Fatal("bad length accepted", n)
			}
		}
	}
	if _, err := protocol.ParseTaskAction(6060, p); err == nil {
		t.Fatal("response accepted as request")
	}
}

func TestTaskProgressSnapshotOffsets(t *testing.T) {
	p := make([]byte, 123)
	copy(p, []byte{0x44, 0x33, 0x22, 0x11, 0x34, 0x12, 2, 0x78, 0x56, 0x34, 0x12})
	copy(p[119:], []byte{0xef, 0xcd, 0xab, 0x89})
	r, e := protocol.ParseTaskProgress(p)
	if e != nil || r.Unknown0 != 0x11223344 || r.Key != 0x1234 || r.State != 2 || r.ProfileBaseline[0] != 0x12345678 || r.ProfileBaseline[28] != 0x89abcdef {
		t.Fatal(r, e)
	}
	for _, state := range []byte{1, 2, 3, 255} {
		p[6] = state
		r, e = protocol.ParseTaskProgress(p)
		if e != nil || r.State != state {
			t.Fatal("diagnostic must retain unknown state", r, e)
		}
	}
	for _, n := range []int{0, 7, 122, 124} {
		if _, e := protocol.ParseTaskProgress(make([]byte, n)); e == nil {
			t.Fatal("wrong size accepted", n)
		}
	}
}
