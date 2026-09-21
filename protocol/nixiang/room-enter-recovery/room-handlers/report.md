# Room wire handlers — relocation correction

## Finding

The flat game-runtime.bin dump begins at original virtual address 0x10000 but is loaded at IDA base 0. Absolute pointers in code and tables still contain original VAs. A table pointer must therefore be translated as **file offset = pointer VA - 0x10000**. Direct relative calls already resolve to the correct file offset.

Evidence example: constructor at file 0xB13710 writes original VA 0x12FE030 with function pointer VA 0x8253A0. The initialized table is physically at file 0x12EE030. Correct function is file 0x8153A0, whose signature accepts (payload, length), enforces length 83, and sends known room protocol messages. File 0x8253A0 lies in unrelated code. This explains prior false 3020/4 and 3020/196 results.

## Verified mapping

| Message | Table file offset | Stored function VA | Correct file function | Payload |
|---|---|---|---|---|
| 3020 | 0x12EE028 | 0x8253A0 | 0x8153A0 | exactly 83 |
| 3030 | 0x12EE040 | 0x824FB0 | 0x814FB0 | exactly 2, error display |
| 3080 | 0x12EE058 | 0x824CB0 | 0x814CB0 | exactly 18, error display, error DWORD at 14 |
| 3100 | 0x12EE1A8 | 0x824490 | 0x814490 | exactly 245 |
| 3090 | 0x12EEB38 | 0x81EEA0 | 0x80EEA0 | peer player 149 + appearance |
| 3550 | 0x12EEC88 | 0x81EE50 | 0x80EE50 | 12, UID/status |
| 2500 | 0x12EE070 | 0x825250 | 0x815250 | exactly 259; byte4==1 |
| 2580 | 0x12EE0B8 | 0x825350 | 0x815350 | handler ignores length and transitions state6 |

## Correct create and enter sequence

1. Client 3010/81 stores packed create-room settings.
2. Server 3020/83 = little-endian WORD room handle + the original 81-byte create settings.
3. Handler copies settings, sets handle, initializes room mode and map, and sends 3550/12 (local UID + status0).
4. Normally handler then sends 3070/14: WORD room handle + zero bytes.
5. Server sends 3100/245: room header96 + player149.
6. 3100 handler creates self character using already logged-in local appearance, dispatches a room UI virtual callback, sets global state7, and sends 21428/0.

3030 and 3080 are failures; neither is a success payload. 20560 and 25xx seen after prior forced pushes were unrelated features, not evidence that create-room advanced.

## 3100 fields verified in handler

| Offset | Size | Meaning / source |
|---|---|---|
| 0 | 2 | room handle |
| 2 | 8 | owner UID candidate; header copy preserves it |
| 10 | 1 | local player slot; must be <8 for normal self path; 8=spectator |
| 11 | 1 | team / secondary slot |
| 12 | 4 | map field from request38 |
| 16 | 4 | map field from request42; abs() then mapmgr lookup |
| 24 | 21 | room name, request0 |
| 45 | 11 | password, request21 |
| 56 | 5 | flags, request32..36 |
| 61 | 1 | password flag |
| 62 | 1 | capacity, request37 |
| 65 | 1 | game mode, request46 |
| 66 | 1 | alternate slot/position |
| 67 | 2 | room parameter/time, request47 |
| 69 | 4 | secondary room state |
| 73 | 1 | request49 |
| 78 | 4 | request59 |
| 96 | 149 | player metadata |

The current code candidate in ../candidate/room_protocol.py was reviewed and matches these established offsets. The exact semantics of several copied flags remain unnamed; preserving request bytes avoids inventing them.

## Map validity

The map manager singleton at original VA0x17C8964 is initialized by file0xA45FB0 from original string VA0xBA4534 -> file0xB94534, which is \\data\\config\\mapmgr.xml; query root /MapInfo. The XML is packed in Data/config.spf2.

A read-only process probe (read_maps.py) verified current isolated Client.exe PID42172 and enumerated 97 map nodes. Process image path was checked before reading. No hooks or process writes were used. E-live-maps.json contains raw node bytes, keys and strings.

**Map key0 exists and is explicitly “随机地图”, resource names new/new.** It is therefore appropriate to preserve the current real request's two zero map fields. Nonzero examples include 83=电梯, 104=练功后院, 105=秘密修行室. Arbitrarily substituting 121000 is wrong: that ID was found in a character-item table under the previous pointer-offset confusion.

## Evidence

- 0x8153A0.json: create success handler
- 0x814490.json: room enter success handler
- 0x814FB0.json / 0x814CB0.json: failures
- 0x80CB00.json / 0x80CF10.json: self/peer character construction
- 0x80B010.json: first96 bytes copied into room manager
- E-live-maps.json / read_maps.py: valid maps read directly from isolated process
- E-imports.md: existing baseline and flat-dump limitation

Real fixture: project research/2026-09-06/work/login-to-world/evidence/lab-wire-v4.jsonl line94139, timestamp1788791947.3258736, 3010/81.

Static correction and candidate review are complete. Actual UI entry still requires fresh client verification of 3020/83 -> 3070/14 -> 3100/245 and visible room state.
