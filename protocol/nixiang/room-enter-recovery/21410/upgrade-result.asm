; sha256=98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 0x85ff00
0085FF00 55                       push ebp
0085FF01 8bec                     mov ebp, esp
0085FF03 83ec08                   sub esp, 8
0085FF06 894df8                   mov dword ptr [ebp - 8], ecx
0085FF09 8b45f8                   mov eax, dword ptr [ebp - 8]
0085FF0C 8b88dc050000             mov ecx, dword ptr [eax + 0x5dc]
0085FF12 894dfc                   mov dword ptr [ebp - 4], ecx
0085FF15 6a04                     push 4
0085FF17 8d55fc                   lea edx, [ebp - 4]
0085FF1A 52                       push edx
0085FF1B 6a00                     push 0
0085FF1D 68a4530000               push 0x53a4
0085FF22 e829ca1d00               call 0xa3c950
0085FF27 83c410                   add esp, 0x10
0085FF2A 8be5                     mov esp, ebp
0085FF2C 5d                       pop ebp
0085FF2D c3                       ret
0085FF2E cc                       int3
; 0xaf4d0f
00AF4D0F c705a8d22f01a5530000     mov dword ptr [0x12fd2a8], 0x53a5
00AF4D19 c705acd22f0101000000     mov dword ptr [0x12fd2ac], 1
00AF4D23 c78520f6ffff008ea200     mov dword ptr [ebp - 0x9e0], 0xa28e00
00AF4D2D c78524f6ffff00000000     mov dword ptr [ebp - 0x9dc], 0
00AF4D37 c78528f6ffff00000000     mov dword ptr [ebp - 0x9d8], 0
; 0xa28e00
00A28E00 55                       push ebp
00A28E01 8bec                     mov ebp, esp
00A28E03 51                       push ecx
00A28E04 894dfc                   mov dword ptr [ebp - 4], ecx
00A28E07 837d0800                 cmp dword ptr [ebp + 8], 0
00A28E0B 7410                     je 0xa28e1d
00A28E0D 8b450c                   mov eax, dword ptr [ebp + 0xc]
00A28E10 33d2                     xor edx, edx
00A28E12 b916000000               mov ecx, 0x16
00A28E17 f7f1                     div ecx
00A28E19 85d2                     test edx, edx
00A28E1B 7402                     je 0xa28e1f
00A28E1D eb10                     jmp 0xa28e2f
00A28E1F 8b5508                   mov edx, dword ptr [ebp + 8]
00A28E22 52                       push edx
00A28E23 e8b887e3ff               call 0x8615e0
00A28E28 8bc8                     mov ecx, eax
00A28E2A e86183e3ff               call 0x861190
00A28E2F 8be5                     mov esp, ebp
00A28E31 5d                       pop ebp
; 0x861190
00861190 55                       push ebp
00861191 8bec                     mov ebp, esp
00861193 6aff                     push -1
00861195 683d74ab00               push 0xab743d
0086119A 64a100000000             mov eax, dword ptr fs:[0]
008611A0 50                       push eax
008611A1 81ec94000000             sub esp, 0x94
008611A7 56                       push esi
008611A8 57                       push edi
008611A9 a180b4c700               mov eax, dword ptr [0xc7b480]
008611AE 33c5                     xor eax, ebp
008611B0 50                       push eax
008611B1 8d45f4                   lea eax, [ebp - 0xc]
008611B4 64a300000000             mov dword ptr fs:[0], eax
008611BA 898d68ffffff             mov dword ptr [ebp - 0x98], ecx
008611C0 a16489b900               mov eax, dword ptr [0xb98964]
008611C5 50                       push eax
008611C6 8d4d88                   lea ecx, [ebp - 0x78]
008611C9 e88244baff               call 0x405650
008611CE c745fc00000000           mov dword ptr [ebp - 4], 0
008611D5 6a01                     push 1
008611D7 8d4d88                   lea ecx, [ebp - 0x78]
008611DA 51                       push ecx
008611DB 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
008611E1 e8daffefff               call 0x7611c0
008611E6 c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008611ED 8d4d88                   lea ecx, [ebp - 0x78]
008611F0 e8db44baff               call 0x4056d0
008611F5 8b156889b900             mov edx, dword ptr [0xb98968]
008611FB 52                       push edx
008611FC 8d8d6cffffff             lea ecx, [ebp - 0x94]
00861202 e84944baff               call 0x405650
00861207 c745fc01000000           mov dword ptr [ebp - 4], 1
0086120E 6a01                     push 1
00861210 8d856cffffff             lea eax, [ebp - 0x94]
00861216 50                       push eax
00861217 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
0086121D e89effefff               call 0x7611c0
00861222 c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861229 8d8d6cffffff             lea ecx, [ebp - 0x94]
0086122F e89c44baff               call 0x4056d0
00861234 c745f000000000           mov dword ptr [ebp - 0x10], 0
0086123B eb09                     jmp 0x861246
0086123D 8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00861240 83c101                   add ecx, 1
00861243 894df0                   mov dword ptr [ebp - 0x10], ecx
00861246 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
0086124C 81c180050000             add ecx, 0x580
00861252 e8795fcfff               call 0x5571d0
00861257 3945f0                   cmp dword ptr [ebp - 0x10], eax
0086125A 0f8394000000             jae 0x8612f4
00861260 8b55f0                   mov edx, dword ptr [ebp - 0x10]
00861263 52                       push edx
00861264 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
0086126A 81c180050000             add ecx, 0x580
00861270 e8bb7ecfff               call 0x559130
00861275 8b4d08                   mov ecx, dword ptr [ebp + 8]
00861278 8b5109                   mov edx, dword ptr [ecx + 9]
0086127B 3b10                     cmp edx, dword ptr [eax]
0086127D 7570                     jne 0x8612ef
0086127F 8b4508                   mov eax, dword ptr [ebp + 8]
00861282 8b4809                   mov ecx, dword ptr [eax + 9]
00861285 51                       push ecx
00861286 8b55f0                   mov edx, dword ptr [ebp - 0x10]
00861289 52                       push edx
0086128A 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
00861290 81c180050000             add ecx, 0x580
00861296 e8957ecfff               call 0x559130
0086129B 8b4005                   mov eax, dword ptr [eax + 5]
0086129E 50                       push eax
0086129F 8d4da4                   lea ecx, [ebp - 0x5c]
008612A2 51                       push ecx
008612A3 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
008612A9 e872eeffff               call 0x860120
008612AE 8b55f0                   mov edx, dword ptr [ebp - 0x10]
008612B1 52                       push edx
008612B2 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
008612B8 81c180050000             add ecx, 0x580
008612BE e86d7ecfff               call 0x559130
008612C3 b911000000               mov ecx, 0x11
008612C8 8d75a4                   lea esi, [ebp - 0x5c]
008612CB 8bf8                     mov edi, eax
008612CD f3a5                     rep movsd dword ptr es:[edi], dword ptr [esi]
008612CF 8b8568ffffff             mov eax, dword ptr [ebp - 0x98]
008612D5 8b4df0                   mov ecx, dword ptr [ebp - 0x10]
008612D8 8988d8050000             mov dword ptr [eax + 0x5d8], ecx
008612DE 8b9568ffffff             mov edx, dword ptr [ebp - 0x98]
008612E4 8b45a4                   mov eax, dword ptr [ebp - 0x5c]
008612E7 8982dc050000             mov dword ptr [edx + 0x5dc], eax
008612ED eb05                     jmp 0x8612f4
008612EF e949ffffff               jmp 0x86123d
008612F4 8b4d08                   mov ecx, dword ptr [ebp + 8]
008612F7 0fb611                   movzx edx, byte ptr [ecx]
008612FA 85d2                     test edx, edx
008612FC 0f8482000000             je 0x861384
00861302 8b8568ffffff             mov eax, dword ptr [ebp - 0x98]
00861308 c780e005000000000000     mov dword ptr [eax + 0x5e0], 0
00861312 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
00861318 c681e405000001           mov byte ptr [ecx + 0x5e4], 1
0086131F 83bd68ffffff00           cmp dword ptr [ebp - 0x98], 0
00861326 7414                     je 0x86133c
00861328 8b9568ffffff             mov edx, dword ptr [ebp - 0x98]
0086132E 81c2b8020000             add edx, 0x2b8
00861334 899564ffffff             mov dword ptr [ebp - 0x9c], edx
0086133A eb0a                     jmp 0x861346
0086133C c78564ffffff00000000     mov dword ptr [ebp - 0x9c], 0
00861346 8b8568ffffff             mov eax, dword ptr [ebp - 0x98]
0086134C 0578050000               add eax, 0x578
00861351 50                       push eax
00861352 6a00                     push 0
00861354 8b8d64ffffff             mov ecx, dword ptr [ebp - 0x9c]
0086135A 51                       push ecx
0086135B 6a00                     push 0
0086135D 68c8000000               push 0xc8
00861362 6a00                     push 0
00861364 6a00                     push 0
00861366 e8d514baff               call 0x402840
0086136B 8bc8                     mov ecx, eax
0086136D e81e3e0a00               call 0x905190
00861372 6a00                     push 0
00861374 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
0086137A e8a1efffff               call 0x860320
0086137F e987000000               jmp 0x86140b
00861384 8b5508                   mov edx, dword ptr [ebp + 8]
00861387 0fb602                   movzx eax, byte ptr [edx]
0086138A 85c0                     test eax, eax
0086138C 757d                     jne 0x86140b
0086138E 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
00861394 c781e005000000000000     mov dword ptr [ecx + 0x5e0], 0
0086139E 8b9568ffffff             mov edx, dword ptr [ebp - 0x98]
008613A4 c682e405000000           mov byte ptr [edx + 0x5e4], 0
008613AB 83bd68ffffff00           cmp dword ptr [ebp - 0x98], 0
008613B2 7413                     je 0x8613c7
008613B4 8b8568ffffff             mov eax, dword ptr [ebp - 0x98]
008613BA 05b8020000               add eax, 0x2b8
008613BF 898560ffffff             mov dword ptr [ebp - 0xa0], eax
008613C5 eb0a                     jmp 0x8613d1
008613C7 c78560ffffff00000000     mov dword ptr [ebp - 0xa0], 0
008613D1 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
008613D7 81c178050000             add ecx, 0x578
008613DD 51                       push ecx
008613DE 6a00                     push 0
008613E0 8b9560ffffff             mov edx, dword ptr [ebp - 0xa0]
008613E6 52                       push edx
008613E7 6a00                     push 0
008613E9 68c8000000               push 0xc8
008613EE 6a00                     push 0
008613F0 6a00                     push 0
008613F2 e84914baff               call 0x402840
008613F7 8bc8                     mov ecx, eax
008613F9 e8923d0a00               call 0x905190
008613FE 6a00                     push 0
00861400 8b8d68ffffff             mov ecx, dword ptr [ebp - 0x98]
00861406 e815efffff               call 0x860320
0086140B 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0086140E 64890d00000000           mov dword ptr fs:[0], ecx
00861415 59                       pop ecx
00861416 5f                       pop edi
00861417 5e                       pop esi
00861418 8be5                     mov esp, ebp
0086141A 5d                       pop ebp
