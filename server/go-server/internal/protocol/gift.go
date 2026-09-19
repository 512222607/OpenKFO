package protocol

import (
	"bytes"
	"fmt"
	"golang.org/x/text/encoding/simplifiedchinese"
)

// GiftRequest is the 426-byte native 9090 request produced by 85C7E0.
// RecipientUID is an optional client-side directory hint, never authentication.
// Unknown bytes are not assigned business meanings here.
type GiftRequest struct {
	Currency       uint32
	RecipientUID   uint64
	RecipientName  string
	CatalogKey     uint32
	TicketPrice    uint32
	CatalogField77 uint32
	Flag169        byte
	Text           string
}

func ParseGiftRequest(p []byte) (GiftRequest, error) {
	var r GiftRequest
	if len(p) != 426 {
		return r, fmt.Errorf("9090 requires 426 bytes")
	}
	decode := func(b []byte) (string, error) {
		end := bytes.IndexByte(b, 0)
		if end < 0 {
			return "", ErrFrame
		}
		raw := b[:end]
		decoded, err := simplifiedchinese.GBK.NewDecoder().Bytes(raw)
		if err != nil {
			return "", ErrFrame
		}
		encoded, err := simplifiedchinese.GBK.NewEncoder().Bytes(decoded)
		if err != nil || !bytes.Equal(raw, encoded) {
			return "", ErrFrame
		}
		return string(decoded), nil
	}
	name, err := decode(p[83:104])
	if err != nil || name == "" {
		return r, ErrFrame
	}
	text, err := decode(p[170:426])
	if err != nil {
		return r, err
	}
	r = GiftRequest{ReadUint32(p, 0), ReadUint64(p, 54), name, ReadUint32(p, 145), ReadUint32(p, 157), ReadUint32(p, 165), p[169], text}
	return r, nil
}
