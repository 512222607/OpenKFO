package protocol

import (
	"bytes"
	"golang.org/x/text/encoding/simplifiedchinese"
	"strings"
)

// MailRecord is the native 339-byte 1310 record. Unknown ranges stay zero.
type MailRecord struct {
	ID                            uint32
	Title, Sender, Body           string
	RemainingRaw                  byte
	Read                          bool
	AttachmentKey, AttachmentKind uint32
}

func (m MailRecord) Encode() ([]byte, error) {
	if m.ID == 0 {
		return nil, ErrFrame
	}
	p := make([]byte, 339)
	// Title and sender intentionally use a conservative 20-byte server limit.
	// Native display consumes NUL strings at +4/+83; full title capacity is unknown.
	for _, f := range []struct {
		s             string
		offset, limit int
	}{{m.Title, 4, 20}, {m.Sender, 83, 20}, {m.Body, 126, 200}} {
		if strings.ContainsRune(f.s, 0) {
			return nil, ErrFrame
		}
		b, err := simplifiedchinese.GBK.NewEncoder().Bytes([]byte(f.s))
		if err != nil || len(b) > f.limit {
			return nil, ErrFrame
		}
		back, err := simplifiedchinese.GBK.NewDecoder().Bytes(b)
		if err != nil || !bytes.Equal(back, []byte(f.s)) {
			return nil, ErrFrame
		}
		copy(p[f.offset:], b)
	}
	WriteUint32(p, 0, m.ID)
	p[125] = m.RemainingRaw
	if m.Read {
		WriteUint32(p, 327, 1)
	}
	WriteUint32(p, 331, m.AttachmentKey)
	WriteUint32(p, 335, m.AttachmentKind)
	return p, nil
}

// MailDetail is 1330: a 28-byte header followed by a 108-byte catalog record.
// It previews an attachment; it must never itself grant inventory or currency.
type MailDetail struct {
	MailKey, State, AttachmentKey         uint32
	Gold, Tickets, Experience, Reputation uint32
	Catalog                               []byte
}

func (m MailDetail) Encode() ([]byte, error) {
	if m.MailKey == 0 || m.State > 1 || (len(m.Catalog) != 0 && len(m.Catalog) != 108) {
		return nil, ErrFrame
	}
	p := make([]byte, 136)
	for i, v := range []uint32{m.MailKey, m.State, m.AttachmentKey, m.Gold, m.Tickets, m.Experience, m.Reputation} {
		WriteUint32(p, i*4, v)
	}
	copy(p[28:], m.Catalog)
	return p, nil
}

// ParseMailAction binds both viewing/deletion and attachment claims to the
// authenticated account. The key's meaning still depends on the opcode.
func ParseMailAction(p []byte, uid uint64) (uint32, error) {
	if len(p) != 12 || uid == 0 || ReadUint64(p, 0) != uid || ReadUint32(p, 8) == 0 {
		return 0, ErrFrame
	}
	return ReadUint32(p, 8), nil
}
