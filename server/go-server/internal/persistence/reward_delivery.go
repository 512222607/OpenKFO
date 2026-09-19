package persistence

import (
	"kungfu.local/server/internal/protocol"
	"math"
)

// creditRewardProgress is shared by gameplay rewards. The caller owns the
// account lock, eligibility receipt and transaction; this function never commits.
// Mutation happens only after validation, preserving the input on failure.
func creditRewardProgress(profile []byte, balance uint64, experience, gold uint32, growth RewardRules) (uint32, error) {
	if len(profile) != 360 || balance > math.MaxUint32 || uint64(gold)+balance > math.MaxUint32 {
		return 0, ErrDenied
	}
	xp := uint64(protocol.ReadUint32(profile, ExperienceOffset)) + uint64(experience)
	level := ProfileLevel(profile)
	if growth.GrowthEnabled {
		var rest uint32
		level, rest = AdvanceLevel(level, xp, growth)
		xp = uint64(rest)
	}
	if xp > math.MaxInt32 {
		return 0, ErrDenied
	}
	total := uint64(protocol.ReadUint32(profile, ExperienceOffset+4)) + uint64(experience)
	if total > math.MaxInt32 {
		total = math.MaxInt32
	}
	if growth.GrowthEnabled {
		protocol.WriteUint16(profile, LevelOffset, level)
	}
	protocol.WriteUint32(profile, ExperienceOffset, uint32(xp))
	protocol.WriteUint32(profile, ExperienceOffset+4, uint32(total))
	return uint32(balance + uint64(gold)), nil
}
