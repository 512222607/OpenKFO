package protocol

import "testing"

func TestStageWaveReportNativeLayout(t *testing.T) {
	p := make([]byte, 40)
	WriteUint64(p, 0, 0x8877665544332211)
	WriteUint32(p, 8, 0xffffffff)
	WriteUint32(p, 12, 1)
	p[39] = 0xa5
	r, err := ParseStageWaveReport(p)
	if err != nil || r.ContextValue != 0x8877665544332211 || r.Wave != -1 || r.ReportValue != 1 || r.Raw[39] != 0xa5 {
		t.Fatal(r, err)
	}
	p[39] = 0
	if r.Raw[39] != 0xa5 {
		t.Fatal("raw aliases input")
	}
	for _, n := range []int{0, 12, 39, 41} {
		if _, err := ParseStageWaveReport(make([]byte, n)); err == nil {
			t.Fatal("invalid length", n)
		}
	}
}

func TestStageWaveNativeLayouts(t *testing.T) {
	p := make([]byte, 40)
	for _, wave := range []uint32{0, 3, 0xffffffff} {
		WriteUint32(p, 8, wave)
		p[0], p[39] = 0xa1, 0xb2
		r, err := ParseStageWaveControl(p)
		if err != nil || r.Wave != int32(wave) || r.Raw[0] != 0xa1 || r.Raw[39] != 0xb2 {
			t.Fatal(r, err)
		}
	}
	for _, n := range []int{0, 39, 41} {
		if _, err := ParseStageWaveControl(make([]byte, n)); err == nil {
			t.Fatal("wrong control size", n)
		}
	}
	event := make([]byte, 47)
	WriteUint32(event, 0, BattleEventStageWaveEnd)
	WriteUint64(event, 4, 0x1122334455667788)
	WriteUint64(event, 39, 0x8877665544332211)
	event[38] = 0x5a
	r, err := ParseStageWaveEnd(event)
	if err != nil || r.Sender != 0x1122334455667788 || r.ContextValue != 0x8877665544332211 || r.Raw[38] != 0x5a {
		t.Fatal(r, err)
	}
	event[38] = 0
	if r.Raw[38] != 0x5a {
		t.Fatal("raw aliases caller")
	}
	for _, bad := range [][]byte{nil, event[:46], append(event, 0), make([]byte, 47)} {
		if _, err := ParseStageWaveEnd(bad); err == nil {
			t.Fatal("invalid event accepted")
		}
	}
}
