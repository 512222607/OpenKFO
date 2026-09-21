"""Derive the local weapon catalog solely from the preserved E-011 export."""
from pathlib import Path
import hashlib
import json
import struct
from collections import Counter

SOURCE = Path(r"C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\work\login-to-world\evidence\E-011-item-config-enumeration.json")
EXPECTED_SHA256 = "10f3170fd3d80eebe9c6f49c9912902e77c91bcc6420b668ceaa797e0edb1ebc"
OUT = Path(__file__).resolve().parent

def build():
    digest = hashlib.sha256(SOURCE.read_bytes()).hexdigest()
    assert digest == EXPECTED_SHA256
    payload = json.loads(SOURCE.read_text(encoding="utf-8"))["payload"]
    records = payload["records"]
    assert len(records) == payload["expectedCount"] == payload["visitedCount"] == 3511
    assert len({r["id"] for r in records}) == 3511
    assert all(r["lookupMatches"] and r["address"] == r["lookupAddress"] for r in records)
    weapons = []
    for r in records:
        raw = bytes.fromhex(r["recordHeadHex"])
        item_type, item_id = struct.unpack_from("<II", raw)
        assert (item_type, item_id) == (r["recordId"], r["id"])
        if item_type != 25:
            continue
        u32 = lambda offset: struct.unpack_from("<I", raw, offset)[0]
        mask = u32(32)
        inferred_gender = {0xAAAAAAAA: "male", 0x55555555: "female", 0xFFF00000: "common"}.get(mask, "unknown")
        weapons.append({
            "id": item_id,
            "name": bytes.fromhex(r["displayNameHex"]).decode("gbk"),
            "config_type": item_type,
            "weapon_subtype_raw": u32(20),
            "restriction_mask_raw": f"0x{mask:08X}",
            "gender_inferred_from_comparison": inferred_gender,
            "unknown_u32_at_0x10": u32(16),
            "unknown_u32_at_0x18": u32(24),
            "unknown_u32_at_0x1c": u32(28),
            "display_name_gbk_hex": r["displayNameHex"],
            "record_head_hex": r["recordHeadHex"],
        })
    weapons.sort(key=lambda w: w["id"])
    assert len(weapons) == 274
    assert all(w["name"] for w in weapons)
    catalog = {
        "source": str(SOURCE),
        "source_sha256": digest,
        "source_record_count": 3511,
        "selection": "Actual config type recordId == 25, cross-checked against LE DWORD at recordHeadHex +0; ID cross-checked against DWORD +4; lookupMatches must be true.",
        "count": len(weapons),
        "prefix_counts": dict(Counter(str(w["id"] // 1000) for w in weapons)),
        "gender_counts_inferred": dict(Counter(w["gender_inferred_from_comparison"] for w in weapons)),
        "weapon_subtype_counts_raw": dict(Counter(str(w["weapon_subtype_raw"]) for w in weapons)),
        "notes": [
            "Use displayNameHex decoded as GBK. The preserved displayName string is incorrectly decoded and includes adjacent memory residues.",
            "Do not filter solely by the 253xxx prefix: seven type-25 weapons have IDs 100000, 100001, 100003, 100004, 100005, 100006 and 100007. ID 100002 is a type-30 accessory and is excluded.",
            "IDs are sparse; enumerate the list instead of generating an inclusive numeric range.",
            "Gender labels are inference, not verified client logic: +0x20 mask 0xAAAAAAAA matches male apparel, 0x55555555 female apparel, and 0xFFF00000 the common weapon examples used for both genders in verified create-role options.",
            "Four likely sex-restricted weapons: 253069 and 253926 male; 253071 and 253927 female. Ownership need not exclude opposite-sex items; equipping may remain restricted.",
            "The export does not establish level, expiry, sale eligibility or other equip requirements. Unknown DWORD +0x10 is not gender (all male/female type-12 apparel have value 1).",
            "Type 26 has 102 projectiles/battle props including bombs and bullets and is outside the established type-25 equipped-weapon slot. Do not blindly grant it as ordinary equipment.",
        ],
        "ids": [w["id"] for w in weapons],
        "weapons": weapons,
    }
    (OUT / "weapons.json").write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (OUT / "weapon_ids.json").write_text(json.dumps(catalog["ids"], indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: v for k, v in catalog.items() if k not in ("ids", "weapons", "notes")}, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    build()
