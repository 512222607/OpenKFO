# Case Scope

## meta
- case_id: room-enter-recovery
- created: 2026-09-07T22:45:06.4935279+08:00
- operator: local
- project_root: C:\Users\24032\Documents\Codex\2026-09-07\c-users-24032-desktop-code-kungfu-4
- primary_skill: ida-reverse/SKILL.md
- primary_id: R6
- lead_role: lead
- specialist_roles: []
- hint: IDA local Client.exe reverse engineering room enter protocol
- preset: offline-sample

## auth
- status: granted
- basis: own_system
- evidence_of_auth: User explicitly requests reconstruction of their lost game server and repair of create-room/room-enter; offline local client and loopback lab only
- MUST NOT proceed if status != granted

## in_scope
- assets:
  - C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\spc32\work\game-runtime.bin
- surfaces: []
- activities: []

## out_of_scope
- assets: []
- activities: [dos, phishing_real_users, unrestricted_exfil]

## network_profile
- mode: lab_only
- notes: |
    User authorized offline analysis and loopback integration testing and server repair.
    Additional in-scope assets: the kungfu-mock-server project source and isolated local Client.exe;
    local loopback 127.0.0.1 ports 8094/8000/10035/5136 and ephemeral test ports.

## deliverables
- report: true
- field_journal: true
- diagrams: true
- timeline: true

## constraints
- timebox: {}
- stealth: low
- data_handling: anonymize

## signoff
- ready_for_act: true
- checklist:
  - [x] auth.status = granted
  - [x] in_scope.assets non-empty OR offline sample path set
  - [x] network_profile.mode chosen
  - [ ] out_of_scope reviewed
  - [ ] roles assigned (see skills/ops/role-map.md)

## ops_refs
- skills/ops/scope-contract.md
- skills/ops/evidence-finding-path.md
- skills/ops/role-map.md
- skills/ops/timeline-workitem.md
- skills/ops/IDENTITY.md
