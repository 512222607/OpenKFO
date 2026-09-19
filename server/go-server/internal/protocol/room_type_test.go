package protocol

import (
	"strings"
	"testing"
)

func TestNativePVERoomTypesDoNotEnableCompetitiveRules(t *testing.T) {
	for _, kind := range []RoomType{FosterMode, StageAssault} {
		p := make([]byte, RoomRequestSize)
		p[RoomTypeOffset] = byte(kind)
		if RoomTypeFromRequest(p) != kind || kind.IsCompetitive() || kind.IsTeam() || !strings.Contains(kind.String(), "尚未开放") {
			t.Fatal("PVE identity confused with supported combat", kind)
		}
	}
	if FosterMode != 10 || StageAssault != 21 || RoomTypeFromRequest(nil) != UnknownRoomType {
		t.Fatal("native mode values or malformed request changed")
	}
}
