# E-avatar-3100: self record consumed by room entry

Date: 2026-09-07. Read-only static analysis, no IDB mutations.
Target/scope: the authorized local lab client and server recovery. See ../scope.md.
Import/survey evidence: ../21410/E-imports.json, read and reused for this already-open raw runtime IDB.

## Address basis
IDA input is game-runtime.bin.i64, raw image base 0.
Embedded absolute addresses/pointers still use runtime VA and require subtracting 0x10000 before looking up bytes/functions in this IDB.
The addresses below are IDB/raw addresses; relative-call decompilation addresses already resolve correctly.
In particular the 3100 handler table's VA 0x824490 corresponds to raw 0x814490.

## Essential result
The 245-byte 3100 response is a 96-byte room header followed by a 149-byte player metadata record.
For ordinary self entry (header byte +10 < 8), the client's model, equipment, UID and nickname are all reused from its previously loaded local character state.
There is NO need to convert the saved 836-byte role payload to appearance inside this 149-byte metadata record.

raw 0x814633 defines self_record = response + 96.
raw 0x814693 writes self_record[76] = 0 itself.
raw 0x814705 gets appearance through sub_443BC0(global_self): the getter returns global_self + 88.
raw 0x81472f obtains the already logged-in self UID (64 bits).
raw 0x814711 obtains the existing self nickname string.
raw 0x814741 calls sub_80CB00(uid_lo, uid_hi, header[10], header[11],
  special_mode ? header[66] : header[10], existing_name, appearance, self_record, 0).
sub_80CB00 requires slot < 8 and non-null appearance/self_record.
sub_9E3540 copies 1232 bytes (0x4D0) from existing appearance into the new actor and builds the model.

## Exact fields actually read from self_record by the non-spectator creation path
All offsets decimal; integers little endian. "Actor offset" is internal object byte offset.

| Record offset | Absolute 3100 offset | Width | Destination/use | Evidence instruction |
| --- | --- | --- | --- | --- |
| 76 | 172 | 1 | Client overwrites with 0 | 0x814693 |
| 78 | 174 | NUL string | Copies string into actor+3232, not the nickname | 0x80ce1f / 0x80ce32 |
| 120 | 216 | 4 | Direct assignment actor+3236 | 0x80ce50 / sub_53ABB0 |
| 124 | 220 | 4 | Direct assignment actor+16 | 0x80ce5f / sub_55D980 |
| 128 | 224 | 4 | Direct assignment actor+7132 | 0x80ce71 / sub_53AB70 |
| 136 | 232 | 4 | Direct assignment actor+7432 | 0x80ce83 / sub_53AB30 |
| 140 | 236 | 4 | Direct assignment actor+7444 | 0x80ce95 / sub_53AF40 |

These five numeric setters perform direct assignment and do not lookup assets or dereference the values.
The string routine is unbounded NUL string construction, so +78 must contain a NUL before the end of its field.
Safe first-test candidate: 149 zero bytes. This is supported by the read set but is NOT yet live-client acceptance proof.
The original actor constructor initializes actor+16, actor+7132, actor+7432 to 0 and actor+7444 to -1; creation always overrides the five listed fields from the record. Semantics of actor+7444 are not established; 0 is a conservative wire candidate, not claimed original-server behavior.

## Common player-record layout cross-check (peer path raw 0x80CF10)
The same 149-byte record is used when constructing a peer. These fields are useful for consistency but are not used to construct self on the normal 3100 branch.

| Offset | Width | Observed use | Proposed self value |
| --- | --- | --- | --- |
| 0 | 8 | UID passed to actor constructor | zero-extend validated saved role UID from saved[0:4] |
| 8 | 1 | slot; sub_80CB00 accepts < 8 | same as header[10], normally 0 |
| 9 | 1 | team passed to sub_443950 | same as header[11] |
| 10 | 1 | special-mode position/slot alternative | same as header[66] or slot |
| 11 | 21 inferred from next field | nickname C string | saved role bytes [4:25], GBK NUL terminated |
| 32 | string, next observed scalar +53 | logo/company-logo related string via sub_9D9680 | empty |
| 53 | 1 | if nonzero, call sub_4A1140(1) | 0; semantics unknown |
| 55 | 1 | actor+7052; self path sources existing role+123 | saved[123], currently 0 |
| 63 | 1 | sub_9D3FF0 only accepts values 0..3 | 0 |
| 65 | 2 | controller sub_5395A0 | 0 |
| 67 | 4 | actor+3224 and optional peer P2P setup identifier | 0 for self candidate |
| 71 | 4 | actor+7116 | 0 |
| 75 | 1 | alternate actor constructor when nonzero | 0 |
| 76 | 1 | spectator flag written by 3100 | 0 |
| 77 | 1 | actor+7412; self path computes using existing role+266 | 0 |
| 78 | string | actor+3232 | empty |
| 120 | 4 | actor+3236 | 0 |
| 124 | 4 | actor+16 (from shared constructor) | 0 |
| 128 | 4 | actor+7132 | 0 |
| 136 | 4 | actor+7432 | 0 |
| 140 | 4 | actor+7444 | 0 candidate |
| 144 | 1 | actor+7440 | 0 |
| 145 | 4 | actor+7436 | 0 |

Offsets not explicitly listed have not been assigned semantic names.
The boundary between +78 string and +120 scalar suggests at most 42 bytes, but field capacity 42 is inferred from adjacency, not independently proved.
The +11 nickname field boundary 21 bytes is corroborated by +32 start and the saved role nickname's known 21-byte width.

## What remains outside this subtask
- Room header construction/map selection and the handler's virtual room-UI callbacks.
- Actual live-client validation of zero metadata, successful model creation and room UI.
- Peer appearance serialization: peers receive a separate 1232-byte appearance object, not saved 836 bytes directly. The local self path reuses a client object already synthesized from 1130/1120.
- Guild/title/cosmetic semantics of metadata and spectator slot 8 behavior.
- Do not treat this as a reconstruction of all gameplay state or original server source.

## Files
- 0x814490.c: 3100 consumer.
- 80cb00.c: common actor creation and exact self record reads.
- 0x9E3540.c / 0x443BC0.c: existing 1232-byte appearance source and consumption.
- 0x80CF10.c: common 149-byte peer record read map.
- 0x80BE60.c: spectator path copies 149 bytes plus separate appearance; not used for initial non-spectator entry.
- 0x9D84B0.c: actor initialization and self UID comparison.
- setter decompilations and 80cb00-tail.asm.json: exact direct assignments verified against assembly.
