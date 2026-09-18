"""Read-only evidence extraction. Requires pefile and capstone; never attaches to a process."""
import argparse
import hashlib
import json
from pathlib import Path
import struct

import capstone
import pefile

parser = argparse.ArgumentParser()
parser.add_argument("binary", type=Path)
parser.add_argument("output", type=Path)
parser.add_argument("--log", type=Path)
parser.add_argument("--start", default="2026-09-18T15:28")
parser.add_argument("--end", default="2026-09-18T15:35")
args = parser.parse_args()
data = args.binary.read_bytes()
digest = hashlib.sha256(data).hexdigest()
if digest != "98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b":
    raise SystemExit("Binary differs from the verified build; do not reuse fixed addresses.")
pe = pefile.PE(data=data)
base = pe.OPTIONAL_HEADER.ImageBase
decoder = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
functions = {
    0x82C6E0: "8150_receive", 0x82B8D0: "8126_receive",
    0x9C69C0: "buff_admit_and_deadline", 0x9CBCD0: "buff_activate",
    0x9CBF50: "buff_update_and_expiry", 0x9CBE70: "buff_cleanup",
    0x9C64C0: "remove_by_type", 0x9C5540: "cleanup_notification_gate",
    0x985BD0: "battle_clock", 0x9854E0: "battle_clock_baseline",
    0x65FE70: "clock_constructor", 0x65FEB0: "clock_now",
    0x44B3F0: "expiry_entity_flag",
}
args.output.mkdir(parents=True, exist_ok=True)
clock_write = list(decoder.disasm(pe.get_data(0x7EA045 - base, 10), 0x7EA045))
(args.output / "007EA045-global-clock-write.asm").write_text(
    "\n".join(f"{i.address:08X} {i.bytes.hex()} {i.mnemonic} {i.op_str}" for i in clock_write) + "\n",
    encoding="utf-8")
for address, name in functions.items():
    lines = []
    for ins in decoder.disasm(pe.get_data(address - base, 4096), address):
        lines.append(f"{ins.address:08X}  {ins.bytes.hex():24} {ins.mnemonic} {ins.op_str}".rstrip())
        if ins.mnemonic == "ret":
            break
    if not lines or ins.mnemonic != "ret":
        raise SystemExit(f"No return found for {address:08X}; inspect boundaries manually.")
    (args.output / f"{address:08X}-{name}.asm").write_text("\n".join(lines) + "\n", encoding="utf-8")
imports = {f"0x{i.address:X}": i.name.decode() for dll in pe.DIRECTORY_ENTRY_IMPORT
           for i in dll.imports if i.address in (0xB330F4, 0xB330F8)}
metadata = {"sha256": digest, "image_base": hex(base), "imports": imports,
            "clock_frequency_divisor": struct.unpack("<d", pe.get_data(0xBE83D0-base, 8))[0],
            "method": "Static x86 disassembly at verified function entries; no live memory inspection."}
(args.output / "binary.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
if args.log:
    rows = []
    for line in args.log.read_text(encoding="utf-8-sig").splitlines():
        if not line.startswith("{"):
            continue
        try:
            row = json.loads(line)
            if row.get("protocol") != 8071 or not args.start <= row.get("time", "") < args.end:
                continue
            payload = bytes.fromhex(row["hex"])
            sub = struct.unpack_from("<I", payload)[0]
            if sub not in (8121, 8126, 8150):
                continue
            record = {key: row.get(key) for key in ("time", "direction", "uid", "hex")}
            record.update(subcommand=sub, length=len(payload), sequence=struct.unpack_from("<I", payload,19)[0],
                          clock_raw=payload[23:31].hex())
            if sub == 8150 and len(payload) >= 87:
                for key, offset, fmt in (("target",39,"Q"),("source",47,"Q"),("type",55,"I"),
                        ("level",59,"I"),("duration_raw",63,"I"),("operation",75,"I")):
                    record[key] = struct.unpack_from("<"+fmt,payload,offset)[0]
            rows.append(record)
        except (ValueError, KeyError, struct.error):
            continue
    (args.output / "battle-sample.json").write_text(json.dumps(rows, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Extracted {len(rows)} combat records; no account credentials or endpoint addresses exported.")
