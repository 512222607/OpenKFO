package protocol

import (
	"encoding/hex"
	"fmt"
)

// LegacyLoginSuccess deliberately preserves the Python bridge's byte layout.
// The original dialog's JSON parser is opaque; standard JSON equivalence is
// insufficient evidence that it accepts reordered keys or compact separators.
func LegacyLoginSuccess(token string) ([]byte, error) {
	decoded, err := hex.DecodeString(token)
	if err != nil || len(decoded) != 16 {
		return nil, ErrFrame
	}
	return []byte(fmt.Sprintf(`{"code": 200, "token": "%s", "msg": "OK"}`, token)), nil
}
