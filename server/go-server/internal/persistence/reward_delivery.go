package persistence

import (
	"math"
)

// GrantProgress is shared by gameplay rewards. The caller owns the
// account lock, eligibility receipt and transaction; this function never commits.
// Mutation happens only after validation, preserving the input on failure.
func (m RewardManager) GrantProgress(profile []byte, balance uint64, experience, gold uint32, growth RewardRules) (uint32, error) {
	next, err := (WalletManager{}).CreditBalance(balance, gold)
	if err != nil {
		return 0, err
	}
	if _, err = (RoleManager{}).AddExp(profile, experience, growth); err != nil {
		return 0, err
	}
	return next, nil
}

// CreditBalance validates an addition; persistence belongs to the caller's transaction.
func (m WalletManager) CreditBalance(balance uint64, amount uint32) (uint32, error) {
	if balance > math.MaxUint32 || balance+uint64(amount) > math.MaxUint32 {
		return 0, ErrDenied
	}
	return uint32(balance + uint64(amount)), nil
}
