package game

import (
	"bytes"
	"fmt"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"time"
)

// Reference team_series.py, native 985A10/8297D0. Opt-in, no economy awards.
const (
	seriesInterval      = 8294
	seriesContinue      = 8295
	seriesReady         = 8296
	seriesFinish        = 8297
	seriesReportMessage = 4111
	seriesResultMessage = 4112
	seriesReportSize    = 309
	seriesRowsOffset    = 61
	seriesRowSize       = 31
	seriesMaxFighters   = 6
)

type teamSeries struct {
	limit    uint32
	scores   [2]uint32
	phase    string
	versions map[uint64]uint32
	ready    map[uint64]bool
	report   []byte
}

func newTeamSeries(limit uint32) *teamSeries {
	return &teamSeries{limit: limit, phase: "playing", versions: map[uint64]uint32{}, ready: map[uint64]bool{}}
}
func (r *Room) validateSeriesTeams() error {
	if r.Series == nil {
		return nil
	}
	counts := map[byte]int{}
	for _, m := range r.Members {
		if !m.Spectator {
			counts[m.Team]++
		}
	}
	if len(counts) != 2 || r.fighterCount() > seriesMaxFighters {
		return fmt.Errorf("series requires two teams and at most six fighters")
	}
	for _, n := range counts {
		if n > 3 {
			return fmt.Errorf("series supports three fighters per side")
		}
	}
	return nil
}

// recipients nil denotes a TCP event. UDP observations never re-broadcast.
func (h *Hub) seriesEvent(s *Session, message protocol.Message, recipients map[uint64]bool) error {
	r, p := s.Room, message.Payload
	if r == nil || r.Series == nil || r.Stage != "battle" || r.isObserver(s) || s.game() == nil || s.game().Phase != "battle" {
		return nil
	}
	m := r.Members[s.UID]
	if m == nil || m.Session != s {
		return protocol.ErrFrame
	}
	if len(p) < 39 {
		return protocol.ErrFrame
	}
	id := protocol.ReadUint32(p, 0)
	length := 39
	if id == seriesInterval {
		length = 47
	} else if id == seriesReady {
		length = 43
	} else if id != seriesContinue && id != seriesFinish {
		return protocol.ErrFrame
	}
	if len(p) != length || protocol.ReadUint64(p, 4) != s.UID || p[12] != 1 || p[13] != 1 {
		return protocol.ErrFrame
	}
	series := r.Series
	seq := protocol.ReadUint32(p, 19)
	if old, ok := series.versions[s.UID]; ok && int32(seq-old) <= 0 {
		return nil
	}
	switch id {
	case seriesReady:
		if s.UID == r.Owner || series.phase != "interval" || series.ready[s.UID] || (recipients != nil && !recipients[r.Owner]) {
			return nil
		}
		series.ready[s.UID] = true
	case seriesInterval:
		if s.UID != r.Owner || series.phase != "playing" {
			return nil
		}
		next := [2]uint32{protocol.ReadUint32(p, 39), protocol.ReadUint32(p, 43)}
		a, b := series.scores[0], series.scores[1]
		if next != series.scores && next != [2]uint32{a + 1, b} && next != [2]uint32{a, b + 1} {
			return nil
		}
		if next[0] > series.limit/2 || next[1] > series.limit/2 {
			return nil
		}
		series.scores = next
		series.phase = "interval"
		series.ready = map[uint64]bool{r.Owner: true}
	case seriesContinue:
		if s.UID != r.Owner || series.phase != "interval" {
			return nil
		}
		series.phase = "playing"
		clear(series.ready)
		// Invalidate the previous timer identity before starting a new round clock.
		r.BattleStartedAt = time.Now()
		h.startBattleClock(r)
	case seriesFinish:
		if s.UID != r.Owner || series.phase != "playing" {
			return nil
		}
		series.phase = "finishing"
	}
	series.versions[s.UID] = seq
	if recipients == nil {
		if id == seriesReady {
			r.Members[r.Owner].Session.sendGame(message)
		} else {
			h.broadcast(r, message, s.UID)
		}
	}
	return nil
}
func (h *Hub) seriesResult(s *Session, p []byte) (err error) {
	defer func() {
		if err != nil {
			err = rejectBattle("series result: %v", err)
		}
	}()
	r := s.Room
	if r == nil || r.Series == nil || r.Type() != protocol.TeamSurvival {
		return nil
	}
	if r.Owner != s.UID || r.Members[s.UID] == nil || r.Members[s.UID].Session != s {
		return protocol.ErrFrame
	}
	series := r.Series
	if series.report != nil {
		if !bytes.Equal(series.report, p) {
			return protocol.ErrFrame
		}
		return nil
	}
	if r.Stage != "battle" || series.phase != "finishing" {
		return nil
	}
	if len(p) != seriesReportSize || p[2] > 1 {
		return protocol.ErrFrame
	}
	scores := [2]uint32{protocol.ReadUint32(p, 3), protocol.ReadUint32(p, 7)}
	a, b := series.scores[0], series.scores[1]
	win := series.limit/2 + 1
	if (scores != [2]uint32{a + 1, b} && scores != [2]uint32{a, b + 1}) || max(scores[0], scores[1]) != win || min(scores[0], scores[1]) >= win || (p[2] == 1) != (min(scores[0], scores[1]) == 0) {
		return protocol.ErrFrame
	}
	if err := r.validateSeriesTeams(); err != nil {
		return err
	}
	out := make([]byte, seriesReportSize)
	out[2] = p[2]
	copy(out[3:11], p[3:11])
	protocol.WriteUint16(out, 11, 65535)
	protocol.WriteUint16(out, 13, 65535)
	seen := map[uint64]bool{}
	for offset := seriesRowsOffset; offset < len(p); offset += seriesRowSize {
		row := p[offset : offset+seriesRowSize]
		uid := protocol.ReadUint64(row, 0)
		if uid == 0 {
			if !bytes.Equal(row, make([]byte, seriesRowSize)) {
				return protocol.ErrFrame
			}
			continue
		}
		member := r.Members[uid]
		if member == nil || member.Spectator || seen[uid] || bytes.IndexByte(row[8:29], 0) < 0 {
			return protocol.ErrFrame
		}
		name := persistence.GBK(member.Session.Nickname)
		if len(name) == 0 || len(name) > 20 || bytes.IndexByte(name, 0) >= 0 {
			return protocol.ErrFrame
		}
		seen[uid] = true
		protocol.WriteUint64(out, offset, uid)
		copy(out[offset+8:offset+29], name)
	}
	if len(seen) != r.fighterCount() {
		return protocol.ErrFrame
	}
	series.report = bytes.Clone(p)
	series.phase = "result"
	r.Stage = "settlement"
	for _, m := range r.Members {
		m.ResultAcknowledged = false
		m.Session.game().Phase = "settlement"
	}
	h.broadcast(r, protocol.Message{ID: seriesResultMessage, Payload: out}, 0)
	return nil
}

func (c Config) ValidateTeamSeries() error {
	switch c.TeamSeriesRounds {
	case 0, 1, 3, 5, 7:
		return nil
	default:
		return fmt.Errorf("team_series_rounds must be 0, 1, 3, 5 or 7")
	}
}
