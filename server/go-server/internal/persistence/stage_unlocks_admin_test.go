package persistence

import "testing"

func TestStageUnlockAdminRejectsMismatchedAccount(t *testing.T) {
	s := &Store{}
	for _, r := range []AdminRequest{{Operation: "stage_unlocks_save", UID: 1}, {Operation: "stage_unlocks_save", UID: 1, StageUnlocks: &StagePlayerUnlocks{UID: 2}}, {Operation: "stage_unlocks_save", StageUnlocks: &StagePlayerUnlocks{}}} {
		if _, err := s.Admin(r); err != ErrDenied {
			t.Fatal("invalid account binding accepted", err)
		}
	}
}
