package persistence

import (
	"database/sql"
	"kungfu.local/server/internal/protocol"
)

type HonourStats struct{ Points, Games, Wins, Rank uint32 }

func addHonour(tx *sql.Tx, r BattleReward) error {
	if r.HonourPeriod == 0 {
		return nil
	}
	if r.Outcome != "win" && r.Outcome != "loss" && r.Outcome != "draw" {
		return ErrDenied
	}
	win := 0
	if r.Outcome == "win" {
		win = 1
	}
	_, err := tx.Exec(`INSERT INTO honour_stats(period,uid,points,games,wins) VALUES(?,?,LEAST(?,2147483647),1,?) ON DUPLICATE KEY UPDATE points=LEAST(points+VALUES(points),2147483647),games=LEAST(games+1,2147483647),wins=LEAST(wins+VALUES(wins),2147483647)`, r.HonourPeriod, r.UID, r.HonourPoints, win)
	return err
}

func (s *Store) Honour(uid uint64, period uint32) (HonourStats, error) {
	var r HonourStats
	err := s.DB.QueryRow(`SELECT h.points,h.games,h.wins,LEAST(1+(SELECT COUNT(*) FROM honour_stats other WHERE other.period=h.period AND other.points>h.points),2147483647) FROM honour_stats h JOIN accounts a ON a.uid=h.uid WHERE h.uid=? AND h.period=?`, uid, period).Scan(&r.Points, &r.Games, &r.Wins, &r.Rank)
	return r, err
}

// The recovered UI reads rank/points/level/games/wins at 16/20/24/28/32.
// The game layer fills level from its explicit grading policy; default is 0.
func (r HonourStats) Payload(description string) []byte {
	p := make([]byte, 36)
	protocol.WriteUint32(p, 0, 1)
	protocol.WriteUint32(p, 16, r.Rank)
	protocol.WriteUint32(p, 20, r.Points)
	protocol.WriteUint32(p, 28, r.Games)
	protocol.WriteUint32(p, 32, r.Wins)
	return append(append(p, GBK(description)...), 0)
}
