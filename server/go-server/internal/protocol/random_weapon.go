package protocol

// Verified against gfld.dat A2DA70/8B44C0, A27180 and 823E30.
const (
	MsgRandomWeaponQuery          uint32 = 21421
	MsgRandomWeaponResult         uint32 = 21422
	MsgRandomWeaponSet            uint32 = 21423
	MsgRandomWeaponEquipmentQuery uint32 = 21424
	MsgRandomWeaponCancelled      uint32 = 21425
	MsgRandomWeaponCancelAck      uint32 = 21428
	MsgPlayerPreferences          uint32 = 1158
	RandomWeaponOff               uint32 = 0
	RandomWeaponAll               uint32 = 8
	InventoryItemIDOffset                = 5
	PlayerPreferencesSize                = 271
	PlayerPreferencesRandomOffset        = 267
	// 8B44C0 divides the appearance DWORD by 100 to recover the item ID.
	RandomWeaponAppearanceScale uint32 = 100
)

func RandomWeaponPreferences(uid uint64, mode uint32) Message {
	p := make([]byte, PlayerPreferencesSize)
	WriteUint64(p, 0, uid)
	WriteUint32(p, PlayerPreferencesRandomOffset, mode)
	// Empty preference text is a no-op in A3BB40 (early empty-string return).
	return Message{ID: MsgPlayerPreferences, Payload: p}
}

func RandomWeaponRecord(record []byte) []byte {
	p := make([]byte, InventoryRecordSize)
	if len(record) == InventoryRecordSize {
		copy(p, record)
		WriteUint32(p, InventoryAppearanceMarkerOffset, ReadUint32(p, InventoryItemIDOffset)*RandomWeaponAppearanceScale)
	}
	return p
}
