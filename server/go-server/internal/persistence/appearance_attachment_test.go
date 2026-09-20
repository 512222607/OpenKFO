package persistence

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestAppearanceAttachmentAcrossUnequipAndReequip(t *testing.T) {
	for _, kind := range []byte{protocol.ItemTop, protocol.ItemFace, protocol.ItemShoes, protocol.ItemHair, protocol.ItemPants, protocol.ItemGloves} {
		r := make([]byte, protocol.InventoryRecordSize)
		r[protocol.InventoryKindOffset] = kind
		protocol.WriteUint32(r, 0, 123)
		protocol.WriteUint32(r, 5, 121002)
		original := bytes.Clone(r)
		prepareAppearanceAttachment(r)
		if !bytes.Equal(r, original) {
			t.Fatal("unequipped inventory changed")
		}
		for _, marker := range []uint32{0, 12345} {
			protocol.WriteUint32(r, protocol.InventoryAppearanceMarkerOffset, marker)
			protocol.WriteUint16(r, protocol.InventorySlotOffset, defaultEquipmentSlot(kind))
			want := bytes.Clone(r)
			if marker == 0 {
				protocol.WriteUint32(want, protocol.InventoryAppearanceMarkerOffset, protocol.AppearanceAttachmentPresent)
			}
			prepareAppearanceAttachment(r)
			if !bytes.Equal(r, want) {
				t.Fatalf("kind %d altered unrelated fields or lost existing marker", kind)
			}
			protocol.WriteUint16(r, protocol.InventorySlotOffset, protocol.SlotUnequipped)
			prepareAppearanceAttachment(r)
			protocol.WriteUint16(r, protocol.InventorySlotOffset, defaultEquipmentSlot(kind))
			prepareAppearanceAttachment(r)
			if !bytes.Equal(r, want) {
				t.Fatalf("kind %d lost attachment on re-equip", kind)
			}
		}
	}
}

func TestAppearanceAttachmentDoesNotChangeOtherItemKinds(t *testing.T) {
	for kind := 0; kind <= 255; kind++ {
		if kind >= protocol.ItemTop && kind <= protocol.ItemGloves {
			continue
		}
		r := make([]byte, protocol.InventoryRecordSize)
		r[protocol.InventoryKindOffset] = byte(kind)
		protocol.WriteUint16(r, protocol.InventorySlotOffset, protocol.SlotPrimaryWeapon)
		want := bytes.Clone(r)
		prepareAppearanceAttachment(r)
		if !bytes.Equal(r, want) {
			t.Fatalf("unrelated item type %d changed", kind)
		}
	}
	for n := 0; n < protocol.InventoryRecordSize; n++ {
		prepareAppearanceAttachment(make([]byte, n))
	}
}
