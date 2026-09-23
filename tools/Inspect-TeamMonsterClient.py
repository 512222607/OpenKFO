"""Read-only prerequisite check for the team-monster experiment.

Requires the already-used pefile and capstone analysis packages. This does not
patch, launch, attach to, or send packets to a game. Unknown builds are rejected.
"""
import argparse
import hashlib
from pathlib import Path
import struct

import capstone
import pefile


SUPPORTED = {
    "1b7c8676e778c7bd47f55184f927338da3cf70c6aa5f0beb59869ea0f0ac9d4e",
    "98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b",
}
# Preferred image virtual addresses, not process pointers. All reads go through
# PE RVA translation after the full-file hash check.
MODE_TABLE = 0x98C86C
MODES = ((1, 0xBA9144, "CLiveTeamMode"),
         (3, 0xBA87D4, "CDeathTeamMode"),
         (10, 0xBAD584, "CFosterMode"),
         (21, 0xBADD44, "CStageAssaultMode"))
RANGES = (
    ("create packet consumer", 0x827AD0, 0x827B4E),
    ("foster create or reuse", 0x941350, 0x9415C6),
    ("foster create submission", 0x941060, 0x94134B),
    ("loader queue submit", 0xA57DA0, 0xA57E43),
    ("foster loader result processing", 0x943960, 0x943D8C),
    ("foster update", 0x943D90, 0x943DAB),
)


def inspect(path):
    data = path.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest not in SUPPORTED:
        raise ValueError("Unknown client SHA256; no addresses applied: " + digest)
    pe = pefile.PE(data=data)
    base = pe.OPTIONAL_HEADER.ImageBase

    def read(address, size):
        result = pe.get_data(address - base, size)
        if len(result) != size:
            raise ValueError("Unmapped analysis address: " + hex(address))
        return result

    def word(address):
        return struct.unpack("<I", read(address, 4))[0]

    def type_name(descriptor):
        return read(descriptor + 8, 128).split(b"\0", 1)[0].decode("ascii")

    lines = ["; Read-only analysis; NOT a playable patch", "; SHA256 " + digest]
    for mode, vtable, expected in MODES:
        locator = word(vtable - 4)
        actual = type_name(word(locator + 12))
        if actual != ".?AV" + expected + "@@":
            raise ValueError("Unexpected native type: " + actual)
        hierarchy = word(locator + 16)
        count, array = word(hierarchy + 8), word(hierarchy + 12)
        if not 1 <= count <= 8:
            raise ValueError("Unexpected base class count")
        bases = [type_name(word(word(array + i * 4))) for i in range(count)]
        has_pve = ".?AVCPVEBaseMode@@" in bases
        if has_pve != (mode in (10, 21)):
            raise ValueError("Unexpected PVE inheritance")
        lines.append(f"; mode={mode} factory=0x{word(MODE_TABLE + mode * 4):08X} "
                     f"vtable=0x{vtable:08X} bases={','.join(bases)}")
    decoder = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    for name, start, end in RANGES:
        lines.append(f"\n; {name}: {start:08X}..{end:08X}")
        for instruction in decoder.disasm(read(start, end - start), start):
            lines.append(f"{instruction.address:08X} {instruction.mnemonic} {instruction.op_str}")
    pe.close()
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("client", type=Path)
    args = parser.parse_args()
    try:
        print(inspect(args.client), end="")
    except (ValueError, OSError, pefile.PEFormatError) as error:
        parser.exit(1, str(error) + "\n")
