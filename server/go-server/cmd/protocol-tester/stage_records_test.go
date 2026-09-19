package main

import (
	"encoding/hex"
	"kungfu.local/server/internal/protocol"
	"reflect"
	"strings"
	"testing"
)

func TestStageRecordsNativeLayout(t *testing.T) {
	p, e := hex.DecodeString("010000000200000003000000040000000500000006000000")
	if e != nil {
		t.Fatal(e)
	}
	want := []protocol.StageRecord{{MapID: 1, Unknown: [4]uint32{2, 3, 4, 5}, RequiredMapID: 6}}
	r, e := protocol.ParseStageRecords(p)
	if e != nil || !reflect.DeepEqual(r, want) {
		t.Fatal(r, e)
	}
	b, e := protocol.EncodeStageRecords(want)
	if e != nil || !reflect.DeepEqual(b, p) {
		t.Fatal(b, e)
	}
	for _, bad := range [][]byte{p[:23], append(append([]byte{}, p...), 0)} {
		if _, e := protocol.ParseStageRecords(bad); e == nil {
			t.Fatal("partial record accepted")
		}
	}
	if _, e := protocol.EncodeStageRecords(append(want, want...)); e == nil {
		t.Fatal("duplicate server keys accepted")
	}
	text := describe(protocol.Message{ID: 21372, Payload: append(append([]byte{}, p...), p...)})
	for _, v := range []string{"记录数=2", "目标地图ID=1", "未解=[2 3 4 5]", "条件地图ID=6", "重复键"} {
		if !strings.Contains(text, v) {
			t.Fatal(text)
		}
	}
	if r, e := protocol.ParseStageRecords(nil); e != nil || len(r) != 0 {
		t.Fatal(r, e)
	}
}
