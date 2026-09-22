package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"math"
	"testing"
)

func TestBuffOpaqueFieldsAndUnknownOperation(t *testing.T) {
	for _, cancel := range []bool{false, true} {
		h, a, b, _ := combatFixture()
		m := combatPacket(protocol.BattleEventBuff, 87, a.UID, b.UID, 79)
		protocol.WriteUint32(m.Payload, 55, 266) // Existing real-client compatibility; do not truncate to u8.
		protocol.WriteUint32(m.Payload, 67, 0x7fc00001)
		protocol.WriteUint32(m.Payload, 71, 0xffffffff)
		if !cancel {
			protocol.WriteUint64(m.Payload, 47, a.UID)
			protocol.WriteUint32(m.Payload, 75, 1)
		}
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(err)
		}
		got := roomOutputs(t, b, protocol.MsgBattleEvent)[0]
		if !bytes.Equal(got.Payload, m.Payload) {
			t.Fatal("opaque fields changed")
		}
		protocol.WriteUint32(m.Payload, 19, 2)
		protocol.WriteUint32(m.Payload, 75, 6)
		if err := h.battleMessage(a, a.game(), m); err == nil {
			t.Fatal("unknown operation forwarded")
		}
		roomOutputs(t, b)
	}
}
func TestUDPHealthObservationAndTCPShareDedup(t *testing.T) {
	h, a, b, _ := combatFixture()
	r := a.Room
	r.Request[46] = byte(protocol.FosterMode)
	r.PVEActors = map[uint64]pveActor{42: {active: true, maximumHP: 10, reportedHP: 10, sequence: 0}}
	m := combatPacket(protocol.BattleEventHealth, 94, a.UID, 42, 86)
	m.Payload[12], m.Payload[13] = 1, 1
	protocol.WriteUint64(m.Payload, 47, a.UID)
	protocol.WriteUint32(m.Payload, 67, math.Float32bits(2))
	raw, _ := protocol.Encode(m)
	h.observeRelayedBattle(a, raw, nil)
	if r.PVEActors[42].reportedHP != 10 {
		t.Fatal("undelivered event changed state")
	}
	h.observeRelayedBattle(a, raw, map[uint64]bool{b.UID: true})
	h.observeRelayedBattle(a, raw, map[uint64]bool{b.UID: true})
	if r.PVEActors[42].reportedHP != 8 {
		t.Fatal("UDP receipt missing or duplicated")
	}
	roomOutputs(t, b)
	if err := h.battleMessage(a, a.game(), m); err != nil {
		t.Fatal(err)
	}
	if r.PVEActors[42].reportedHP != 8 {
		t.Fatal("TCP replay applied health twice")
	}
	roomOutputs(t, b, protocol.MsgBattleEvent)
	protocol.WriteUint32(m.Payload, 90, 8)
	raw, _ = protocol.Encode(m)
	h.observeRelayedBattle(a, raw, map[uint64]bool{b.UID: true})
	if r.PVEActors[42].reportedHP != 8 {
		t.Fatal("stale battle applied")
	}
}
func seriesPacket(id uint32, s *Session, seq uint32) protocol.Message {
	size := 39
	if id == seriesInterval {
		size = 47
	}
	if id == seriesReady {
		size = 43
	}
	p := make([]byte, size)
	protocol.WriteUint32(p, 0, id)
	protocol.WriteUint64(p, 4, s.UID)
	p[12], p[13] = 1, 1
	protocol.WriteUint32(p, 19, seq)
	return protocol.Message{ID: protocol.MsgBattleEvent, Payload: p}
}
func TestTeamSeriesTransitionsAndNoAwardResult(t *testing.T) {
	h, a, b, _ := combatFixture()
	r := a.Room
	r.Request[46] = byte(protocol.TeamSurvival)
	r.Members[b.UID].Team = 1
	r.Series = newTeamSeries(3)
	// Non-host interval cannot move the round forward.
	m := seriesPacket(seriesInterval, b, 1)
	protocol.WriteUint32(m.Payload, 39, 1)
	if err := h.seriesEvent(b, m, nil); err != nil {
		t.Fatal(err)
	}
	if r.Series.phase != "playing" {
		t.Fatal("peer changed round")
	}
	m = seriesPacket(seriesInterval, a, 1)
	protocol.WriteUint32(m.Payload, 39, 1)
	if err := h.seriesEvent(a, m, nil); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, protocol.MsgBattleEvent)
	if err := h.seriesEvent(a, m, nil); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b)
	ready := seriesPacket(seriesReady, b, 2)
	h.seriesEvent(b, ready, map[uint64]bool{b.UID: true})
	if r.Series.ready[b.UID] {
		t.Fatal("ready never delivered to owner")
	}
	h.seriesEvent(b, ready, map[uint64]bool{a.UID: true})
	if !r.Series.ready[b.UID] {
		t.Fatal("UDP ready not observed")
	}
	roomOutputs(t, a)
	if err := h.seriesEvent(a, seriesPacket(seriesContinue, a, 2), nil); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a, protocol.MsgBattleClock)
	roomOutputs(t, b, protocol.MsgBattleClock, protocol.MsgBattleEvent)
	if err := h.seriesEvent(a, seriesPacket(seriesFinish, a, 3), nil); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, protocol.MsgBattleEvent)
	p := make([]byte, seriesReportSize)
	p[2] = 1
	protocol.WriteUint32(p, 3, 2)
	for i, s := range []*Session{a, b} {
		off := seriesRowsOffset + i*seriesRowSize
		protocol.WriteUint64(p, off, s.UID)
		copy(p[off+8:off+29], []byte("spoof"))
		protocol.WriteUint16(p, off+29, 999)
	}
	if err := h.seriesResult(b, p); err == nil {
		t.Fatal("peer reported final")
	}
	if err := h.seriesResult(a, p); err != nil {
		t.Fatal(err)
	}
	if r.Stage != "settlement" {
		t.Fatal("result barrier missing")
	}
	for _, s := range []*Session{a, b} {
		out := roomOutputs(t, s, seriesResultMessage)[0].Payload
		if len(out) != seriesReportSize || bytes.Contains(out, []byte("spoof")) || protocol.ReadUint16(out, seriesRowsOffset+29) != 0 {
			t.Fatal("untrusted names or awards copied")
		}
	}
	if err := h.seriesResult(a, p); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a)
	roomOutputs(t, b)
	roomRequest(t, h, a, 4115, make([]byte, 4))
	if r.Stage != "settlement" {
		t.Fatal("barrier released early")
	}
	roomRequest(t, h, b, 4115, make([]byte, 4))
	if r.Stage != "room" {
		t.Fatal("barrier retained")
	}
}
func TestSeriesOptInAndRosterLimit(t *testing.T) {
	for _, n := range []uint32{0, 1, 3, 5, 7} {
		if err := (Config{TeamSeriesRounds: n}).ValidateTeamSeries(); err != nil {
			t.Fatal(err)
		}
	}
	if err := (Config{TeamSeriesRounds: 2}).ValidateTeamSeries(); err == nil {
		t.Fatal("even rounds accepted")
	}
	_, a, b, _ := combatFixture()
	r := a.Room
	r.Series = newTeamSeries(3)
	if r.validateSeriesTeams() == nil {
		t.Fatal("one team accepted")
	}
	r.Members[b.UID].Team = 1
	if err := r.validateSeriesTeams(); err != nil {
		t.Fatal(err)
	}
	if protocol.ReadUint32(roomEntry(r, a.UID), 74) != 3 {
		t.Fatal("rounds missing from native entry")
	}
}

func TestUDPActorLifecycleObservationDoesNotBroadcast(t *testing.T) {
	h, a, b, _ := combatFixture()
	r := a.Room
	r.Request[46] = byte(protocol.StageAssault)
	create := combatPacket(protocol.BattleEventPVEActorCreate, 67, a.UID, 42, 0)
	create.Payload[12], create.Payload[13] = 1, 1
	raw, _ := protocol.Encode(create)
	h.observeRelayedBattle(a, raw[:len(raw)-1], map[uint64]bool{b.UID: true})
	if r.hasPVEActor(42) {
		t.Fatal("fragment changed state")
	}
	h.observeRelayedBattle(a, raw, map[uint64]bool{b.UID: true})
	if !r.hasPVEActor(42) {
		t.Fatal("delivered create ignored")
	}
	roomOutputs(t, b)
	remove := combatPacket(protocol.BattleEventPVEActorRemove, 47, a.UID, 42, 0)
	remove.Payload[12], remove.Payload[13] = 1, 1
	protocol.WriteUint32(remove.Payload, 19, 2)
	rawRemove, _ := protocol.Encode(remove)
	h.observeRelayedBattle(a, rawRemove, map[uint64]bool{b.UID: true})
	h.observeRelayedBattle(a, raw, map[uint64]bool{b.UID: true})
	if r.hasPVEActor(42) {
		t.Fatal("old create resurrected actor")
	}
	roomOutputs(t, b)
}
func TestProbeExcludesObserverPending(t *testing.T) {
	h, a, b, o := observerFixture(t)
	r := a.Room
	r.Members[a.UID].Ready = true
	r.Members[b.UID].Ready = true
	h.beginNetworkProbe(r)
	defer h.cancelNetworkProbe(r)
	if len(r.NetworkProbe.pending) != 2 || r.NetworkProbe.pending[o.UID] != nil {
		t.Fatal("observer blocks start")
	}
	roomOutputs(t, o)
	if err := h.networkDelayReply(o, nil); err != nil || len(r.NetworkProbe.pending) != 2 {
		t.Fatal("observer consumed fighter reply")
	}
}
func TestTeamSeriesRejectsMalformedFinalWithoutCommitting(t *testing.T) {
	h, a, b, _ := combatFixture()
	r := a.Room
	r.Request[46] = byte(protocol.TeamSurvival)
	r.Members[b.UID].Team = 1
	r.Series = newTeamSeries(1)
	r.Series.phase = "finishing"
	for _, size := range []int{0, 308, 310} {
		if h.seriesResult(a, make([]byte, size)) == nil {
			t.Fatal("invalid size accepted")
		}
	}
	p := make([]byte, seriesReportSize)
	p[2] = 1
	protocol.WriteUint32(p, 3, 1)
	for i := 0; i < 2; i++ {
		protocol.WriteUint64(p, seriesRowsOffset+i*seriesRowSize, a.UID)
	}
	if h.seriesResult(a, p) == nil || r.Series.report != nil || r.Stage != "battle" {
		t.Fatal("duplicate roster committed")
	}
	roomOutputs(t, a)
	roomOutputs(t, b)
}

func TestFailedUDPQueueIsNotDelivery(t *testing.T) {
	_, a, _, _ := combatFixture()
	a.Close()
	if a.emit(tunnel.Frame{Op: "udp", Data: []byte{1}}) {
		t.Fatal("closed connection reported delivery")
	}
	if len(a.Output) != 0 {
		t.Fatal("closed connection queued data")
	}
}

func TestBuffAndSkillSameSequenceCannotReapplyChangedPayload(t *testing.T) {
	for _, id := range []uint32{protocol.BattleEventBuff, protocol.BattleEventSkillEffect} {
		h, a, b, _ := combatFixture()
		size, context := 87, 79
		if id == protocol.BattleEventSkillEffect {
			size, context = 71, 0
		}
		m := combatPacket(id, size, a.UID, b.UID, context)
		protocol.WriteUint64(m.Payload, 47, a.UID)
		if id == protocol.BattleEventBuff {
			protocol.WriteUint32(m.Payload, 55, 266)
			protocol.WriteUint32(m.Payload, 75, 1)
		} else {
			protocol.WriteUint64(m.Payload, 55, b.UID)
		}
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, b, protocol.MsgBattleEvent)
		protocol.WriteUint32(m.Payload, 63, 999)
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, b)
		protocol.WriteUint32(m.Payload, 19, 2)
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, b, protocol.MsgBattleEvent)
	}
}
