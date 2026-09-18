# Multiplayer combat synchronization audit — 2026-09-17

The user reported different HP displays, but could no longer identify which
window was wrong. Neither direction is assumed. Native games were closed during
this investigation; protocol tests are not proof of the rendered HP bars.

## Confirmed defects and changes

- Outer message 8071 accepted only 8120/8140/8150. Damage/healing 8121 was silently
  discarded. Forward it to other authenticated members of the current battle,
  validating target, source, finite floats, length, room ID and battle serial.
  Either involved player can report it; the reporting client is not echoed.
- Effect 8150 identifies the affected actor at byte 39 and its source at 47.
  Requiring byte 39 to equal the reporting player incorrectly rejects effects
  applied to an opponent. Validate the pair and authenticated sender instead.
- Add verified 8122 state, 8126 skill effects, and 8440/8441/8450/8451 state
  apply/remove messages. 8122 is an integer state 0..7, **not absolute HP**.
- Replace a shared last-sequence gate with per-message-kind state, so movement
  does not suppress a different event kind; exact retries are suppressed and
  sequence comparison tolerates uint32 wraparound.
- In practice mode, local NPC events are ignored only after envelope/context
  validation. Multiplayer practice no longer kicks a player for an NPC UID.
  The previous solo-only blanket suppression of battle validation errors is gone.
- Consumption transactions now report whether a debit is new. New committed
  effects reach peers once; duplicate receipts do not repeat the effect.
- Invalid chat produces a notice rather than terminating the game connection.
  Public room scope and private recipient routing are tested with Chinese GBK.
  Control characters, recipient termination and padding are validated; rapid
  sends produce a notice instead of disappearing without explanation.
- Waiting-room owner departure transfers ownership and clears readiness.
  Departure during loading/battle still ends the whole match and returns peers
  to the lobby, now with a reason. Clear stale room members and item intents.

## Native evidence

Client: `runtime-local/client/gfld.dat`, SHA-256
`98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b`.
Addresses are virtual addresses in that exact x86 executable.

| Inner ID | Native handler | Layout / behavior used |
| --- | --- | --- |
| 8121 | 82A9D0 | 94 bytes; target UID39, source UID47; room/serial86/90; damage float67; additional floats72/76/80. Positive calls9F29F0; negative calls9E4740. |
| 8122 | 82A8B0 | 51 bytes; actor39, state47; 9F2DC0 accepts integer0..7. |
| 8126 | 82B8D0 | 71 bytes; source47, target55; skill effect list from63. |
| 8150 | 82C6E0 | 87 bytes; target39, source47, effect55, add/remove75; room/serial79/83. |
| 8440 / 8441 | 82A100 / 82A0B0 | 71 / 47 bytes; actor39; apply/clear actor status. |
| 8450 / 8451 | 829D80 / 829D30 | 59 / 47 bytes; actor39; 8450 context51/55. |

A3FB40/A3FBB0 bind sender UID4. 7D1730 writes sequence19 using the incrementing
7D0E20 counter and queues the event locally as well as sending8071. This is why
the relay excludes the reporting client. Unknown inner IDs remain unforwarded
and emit rate-limited `battle_unhandled` diagnostics, rather than being guessed.

## Verification and boundaries

Local `go test ./...` and `go vet ./...`; Linux compiled game tests also execute
against isolated `kungfu_game_test`, including purchases, wallet idempotency,
item consumption/relay, two-player room lifecycle and authenticated WSS/TLS.
No game account or game inventory needs resetting for this change.

This remains a client-simulated game with authenticated relay, not authoritative
server damage/physics or a full anti-cheat implementation. NPC state is local.
All possible weapon-specific native messages have not been decoded. Continuing
a match after one player leaves is not implemented. The Brazil network RTT
measured previously is independent of these missing-message fixes.

Required native acceptance: two different accounts in one room; alternate single
hits and compare both windows' victim HP, test a configured poison effect and
its expiration, send Chinese room chat both ways, then leave one window and
confirm the other returns to lobby with a notice. Inspect health/effect and
unknown-message logs alongside the visual result.
