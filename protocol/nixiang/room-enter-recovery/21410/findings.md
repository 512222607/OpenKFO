# 21410 and lobby-list mapping correction

Read-only IDA investigation, 2026-09-07. IDB: game-runtime.bin.i64, SHA-256 707450b209937b2d3e94a68ffe8f9841821ff048fd1cc0d8017d1fdddf493c3b.

## Address convention

The IDB contains a raw image at base 0. Embedded VA pointers and absolute data references retain the original +0x10000 image address. Subtract 0x10000 from table pointers to find raw code. Relative CALL targets are already correctly resolved. Example: raw table 0x12ED290 contains ID21411, kind1, VA0xA28E40; matching initializer at raw0xAE4CAB writes VA0x12FD290. Thus the handler is raw0xA18E40, not raw0xA28E40.

## E-21410: weapon upgrade configuration, not a demonstrated room-entry gate

- raw0x852A20 sends 21410/0 when its this+1432 vector has no entries. Otherwise it draws weapon level, score percent, and score progress UI.
- raw0x8F58C0 also sends 21410/0 before calling a UI virtual method.
- Correctly relocated constructor references at raw0xB88890 / 0xB88894 point to frmWeaponLevelUp / WeaponLevelUp.sui. Nearby UI strings: alWeaponList, proWeaponScore, txtScorePercent, txtWeaponLevel.
- The raw0x12ED290 entry maps 21411 to raw0xA18E40. The handler requires non-null payload, len >= 21, and len % 21 == 0; it calls raw0x8500C0 to replace the weapon-level vector at this+1432 with 21-byte records.
- No room-entry state change was found in this path. Record fields and actual game level table values are not fully reconstructed; do not invent a 21-byte all-zero record merely to satisfy length.
- 21430 is itself a client request from raw0x8DCB70, followed by request5272. It is not a justified response to21410.

## E-lobby: corrected response mappings

| Raw table | Message | Embedded VA | Raw handler | Proven constraints |
|---|---:|---|---|---|
| 0x12EE1C0 | 2270 | 0x8243D0 | 0x8143D0 | 8 + 68*n bytes; header+4 written to list count field; each68-byte record ingested |
| 0x12EEC40 | 2270 | 0x81EA80 | 0x80EA80 | Another UI/state handler, same8+68*n shape |
| 0x12EE1D8 | 2280 | 0x824280 | 0x814280 | 8 + 259*n bytes; two headerDWORDs written to controller+344/+348; each259-byte record ingested |
| 0x12EE070 | 2500 | 0x825250 | 0x815250 | Exactly259 bytes; payload byte4 must equal1 for accepted record/UI path |
| 0x12EE0B8 | 2580 | 0x825350 | 0x815350 | Does not read payload or length; UI notification/refresh |

2250 is sent with8-byte payload by raw0x91DBB0. 2260 is sent with3-byte payload by raw0x91DC40 / 0x91DCD0 / 0x91DD40. The first two change controller+248 to10/11 while waiting for pagination. 2280 calls raw0x91E5D0, which writes controller+248=12. The previous 2580/8 conclusion mixed up message-handler addresses.

## Implementation guidance and bounds

1. Do not add21410 replies as an alleged room-entry fix; it is weapon-level configuration.
2. Correct room pagination from2260->2580 to2260->2280 with existing8-byte header builder, after confirming current config and test names. For a fresh empty page, header bytes0000000001000000 fit the proven shape, but labels total_rooms/total_pages remain inferred; verify UI behavior.
3. 2250->2270 with8-byte empty header is a structurally valid empty-list candidate. Preserve uncertainty about the first header DWORD; do not claim full semantics without further evidence.
4. Never use2500/259 as a blind room-entry success: payload[4]==1 and its259-byte record require structure recovery.
5. An empty2280 while current page>1 makes client decrement page and send2260 again. Tests should cover convergence to the first page.
6. Byte-shape checks establish client parsing, not successful visible room entry. Let real loopback client traffic verify the revised chain.

No database edits, comments, target modifications, hooks, or service starts performed.
