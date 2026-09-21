; gfld.dat sha256=98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Addresses are current PE virtual addresses, not raw historical IDB offsets.

; range 0x85ffcb..0x860078
0085FFCB  8d55f8                   lea edx, [ebp - 8]
0085FFCE  52                       push edx
0085FFCF  8b4d94                   mov ecx, dword ptr [ebp - 0x6c]
0085FFD2  81c198050000             add ecx, 0x598
0085FFD8  e87360c7ff               call 0x4d6050
0085FFDD  eb08                     jmp 0x85ffe7
0085FFDF  8d4df8                   lea ecx, [ebp - 8]
0085FFE2  e8b945cbff               call 0x5145a0
0085FFE7  8d45a0                   lea eax, [ebp - 0x60]
0085FFEA  50                       push eax
0085FFEB  8b4d94                   mov ecx, dword ptr [ebp - 0x6c]
0085FFEE  81c198050000             add ecx, 0x598
0085FFF4  e89725c9ff               call 0x4f2590
0085FFF9  50                       push eax
0085FFFA  8d4df8                   lea ecx, [ebp - 8]
0085FFFD  e8eeb8c4ff               call 0x4ab8f0
00860002  0fb6c8                   movzx ecx, al
00860005  85c9                     test ecx, ecx
00860007  7413                     je 0x86001c
00860009  8d4df8                   lea ecx, [ebp - 8]
0086000C  e82f2cc5ff               call 0x4b2c40
00860011  8b10                     mov edx, dword ptr [eax]
00860013  3b55ec                   cmp edx, dword ptr [ebp - 0x14]
00860016  7502                     jne 0x86001a
00860018  eb02                     jmp 0x86001c
0086001A  ebc3                     jmp 0x85ffdf
0086001C  8d4598                   lea eax, [ebp - 0x68]
0086001F  50                       push eax
00860020  8b4d94                   mov ecx, dword ptr [ebp - 0x6c]
00860023  81c198050000             add ecx, 0x598
00860029  e86225c9ff               call 0x4f2590
0086002E  50                       push eax
0086002F  8d4df8                   lea ecx, [ebp - 8]
00860032  e8e9b8c4ff               call 0x4ab920
00860037  0fb6c8                   movzx ecx, al
0086003A  85c9                     test ecx, ecx
0086003C  7404                     je 0x860042
0086003E  d9ee                     fldz
00860040  eb30                     jmp 0x860072
00860042  8d4df8                   lea ecx, [ebp - 8]
00860045  e8f62bc5ff               call 0x4b2c40
0086004A  8b5011                   mov edx, dword ptr [eax + 0x11]
0086004D  89957cffffff             mov dword ptr [ebp - 0x84], edx
00860053  c7458000000000           mov dword ptr [ebp - 0x80], 0
0086005A  dfad7cffffff             fild qword ptr [ebp - 0x84]
00860060  d95df0                   fstp dword ptr [ebp - 0x10]
00860063  d945f0                   fld dword ptr [ebp - 0x10]
00860066  dc356084be00             fdiv qword ptr [0xbe8460]
0086006C  d95df4                   fstp dword ptr [ebp - 0xc]
0086006F  d945f4                   fld dword ptr [ebp - 0xc]
00860072  5f                       pop edi
00860073  5e                       pop esi
00860074  8be5                     mov esp, ebp
00860076  5d                       pop ebp

; range 0x860297..0x860319
00860297  8b4dd3                   mov ecx, dword ptr [ebp - 0x2d]
0086029A  894df0                   mov dword ptr [ebp - 0x10], ecx
0086029D  8b55d7                   mov edx, dword ptr [ebp - 0x29]
008602A0  8955f4                   mov dword ptr [ebp - 0xc], edx
008602A3  8d45f8                   lea eax, [ebp - 8]
008602A6  50                       push eax
008602A7  8b8d58ffffff             mov ecx, dword ptr [ebp - 0xa8]
008602AD  81c198050000             add ecx, 0x598
008602B3  e8985dc7ff               call 0x4d6050
008602B8  eb08                     jmp 0x8602c2
008602BA  8d4df8                   lea ecx, [ebp - 8]
008602BD  e8de42cbff               call 0x5145a0
008602C2  8d8d5cffffff             lea ecx, [ebp - 0xa4]
008602C8  51                       push ecx
008602C9  8b8d58ffffff             mov ecx, dword ptr [ebp - 0xa8]
008602CF  81c198050000             add ecx, 0x598
008602D5  e8b622c9ff               call 0x4f2590
008602DA  50                       push eax
008602DB  8d4df8                   lea ecx, [ebp - 8]
008602DE  e80db6c4ff               call 0x4ab8f0
008602E3  0fb6d0                   movzx edx, al
008602E6  85d2                     test edx, edx
008602E8  7413                     je 0x8602fd
008602EA  8d4df8                   lea ecx, [ebp - 8]
008602ED  e84e29c5ff               call 0x4b2c40
008602F2  8b00                     mov eax, dword ptr [eax]
008602F4  3b45f0                   cmp eax, dword ptr [ebp - 0x10]
008602F7  7502                     jne 0x8602fb
008602F9  eb02                     jmp 0x8602fd
008602FB  ebbd                     jmp 0x8602ba
008602FD  8d4df8                   lea ecx, [ebp - 8]
00860300  e83b29c5ff               call 0x4b2c40
00860305  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
00860308  3b4804                   cmp ecx, dword ptr [eax + 4]
0086030B  7204                     jb 0x860311
0086030D  b001                     mov al, 1
0086030F  eb02                     jmp 0x860313
00860311  32c0                     xor al, al
00860313  5f                       pop edi
00860314  5e                       pop esi
00860315  8be5                     mov esp, ebp
00860317  5d                       pop ebp
00860318  c3                       ret

; range 0x861c57..0x86265a
00861C57  c745d000000000           mov dword ptr [ebp - 0x30], 0
00861C5E  33c0                     xor eax, eax
00861C60  8945d4                   mov dword ptr [ebp - 0x2c], eax
00861C63  8945d8                   mov dword ptr [ebp - 0x28], eax
00861C66  8945dc                   mov dword ptr [ebp - 0x24], eax
00861C69  8945e0                   mov dword ptr [ebp - 0x20], eax
00861C6C  8845e4                   mov byte ptr [ebp - 0x1c], al
00861C6F  c78564ffffff00000000     mov dword ptr [ebp - 0x9c], 0
00861C79  33c9                     xor ecx, ecx
00861C7B  898d68ffffff             mov dword ptr [ebp - 0x98], ecx
00861C81  898d6cffffff             mov dword ptr [ebp - 0x94], ecx
00861C87  898d70ffffff             mov dword ptr [ebp - 0x90], ecx
00861C8D  898d74ffffff             mov dword ptr [ebp - 0x8c], ecx
00861C93  888d78ffffff             mov byte ptr [ebp - 0x88], cl
00861C99  8d55ec                   lea edx, [ebp - 0x14]
00861C9C  52                       push edx
00861C9D  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861CA3  81c198050000             add ecx, 0x598
00861CA9  e8a243c7ff               call 0x4d6050
00861CAE  eb08                     jmp 0x861cb8
00861CB0  8d4dec                   lea ecx, [ebp - 0x14]
00861CB3  e8e828cbff               call 0x5145a0
00861CB8  8d8504feffff             lea eax, [ebp - 0x1fc]
00861CBE  50                       push eax
00861CBF  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861CC5  81c198050000             add ecx, 0x598
00861CCB  e8c008c9ff               call 0x4f2590
00861CD0  50                       push eax
00861CD1  8d4dec                   lea ecx, [ebp - 0x14]
00861CD4  e8179cc4ff               call 0x4ab8f0
00861CD9  0fb6c8                   movzx ecx, al
00861CDC  85c9                     test ecx, ecx
00861CDE  0f84b1000000             je 0x861d95
00861CE4  8d4dec                   lea ecx, [ebp - 0x14]
00861CE7  e8540fc5ff               call 0x4b2c40
00861CEC  8b10                     mov edx, dword ptr [eax]
00861CEE  3b55af                   cmp edx, dword ptr [ebp - 0x51]
00861CF1  0f8599000000             jne 0x861d90
00861CF7  8d4dec                   lea ecx, [ebp - 0x14]
00861CFA  e8a1fcc7ff               call 0x4e19a0
00861CFF  8b08                     mov ecx, dword ptr [eax]
00861D01  894dd0                   mov dword ptr [ebp - 0x30], ecx
00861D04  8b5004                   mov edx, dword ptr [eax + 4]
00861D07  8955d4                   mov dword ptr [ebp - 0x2c], edx
00861D0A  8b4808                   mov ecx, dword ptr [eax + 8]
00861D0D  894dd8                   mov dword ptr [ebp - 0x28], ecx
00861D10  8b500c                   mov edx, dword ptr [eax + 0xc]
00861D13  8955dc                   mov dword ptr [ebp - 0x24], edx
00861D16  8b4810                   mov ecx, dword ptr [eax + 0x10]
00861D19  894de0                   mov dword ptr [ebp - 0x20], ecx
00861D1C  8a5014                   mov dl, byte ptr [eax + 0x14]
00861D1F  8855e4                   mov byte ptr [ebp - 0x1c], dl
00861D22  8d85fcfdffff             lea eax, [ebp - 0x204]
00861D28  50                       push eax
00861D29  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861D2F  81c198050000             add ecx, 0x598
00861D35  e85608c9ff               call 0x4f2590
00861D3A  50                       push eax
00861D3B  8d4dec                   lea ecx, [ebp - 0x14]
00861D3E  e85d28cbff               call 0x5145a0
00861D43  8bc8                     mov ecx, eax
00861D45  e8a69bc4ff               call 0x4ab8f0
00861D4A  0fb6c8                   movzx ecx, al
00861D4D  85c9                     test ecx, ecx
00861D4F  743d                     je 0x861d8e
00861D51  8d4dec                   lea ecx, [ebp - 0x14]
00861D54  e847fcc7ff               call 0x4e19a0
00861D59  8b10                     mov edx, dword ptr [eax]
00861D5B  899564ffffff             mov dword ptr [ebp - 0x9c], edx
00861D61  8b4804                   mov ecx, dword ptr [eax + 4]
00861D64  898d68ffffff             mov dword ptr [ebp - 0x98], ecx
00861D6A  8b5008                   mov edx, dword ptr [eax + 8]
00861D6D  89956cffffff             mov dword ptr [ebp - 0x94], edx
00861D73  8b480c                   mov ecx, dword ptr [eax + 0xc]
00861D76  898d70ffffff             mov dword ptr [ebp - 0x90], ecx
00861D7C  8b5010                   mov edx, dword ptr [eax + 0x10]
00861D7F  899574ffffff             mov dword ptr [ebp - 0x8c], edx
00861D85  8a4014                   mov al, byte ptr [eax + 0x14]
00861D88  888578ffffff             mov byte ptr [ebp - 0x88], al
00861D8E  eb05                     jmp 0x861d95
00861D90  e91bffffff               jmp 0x861cb0
00861D95  8d8df4fdffff             lea ecx, [ebp - 0x20c]
00861D9B  51                       push ecx
00861D9C  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861DA2  81c198050000             add ecx, 0x598
00861DA8  e8e307c9ff               call 0x4f2590
00861DAD  50                       push eax
00861DAE  8d4dec                   lea ecx, [ebp - 0x14]
00861DB1  e86a9bc4ff               call 0x4ab920
00861DB6  0fb6d0                   movzx edx, al
00861DB9  85d2                     test edx, edx
00861DBB  0f84e8010000             je 0x861fa9
00861DC1  a15489b900               mov eax, dword ptr [0xb98954]
00861DC6  50                       push eax
00861DC7  8d8dd8fdffff             lea ecx, [ebp - 0x228]
00861DCD  e87e38baff               call 0x405650
00861DD2  c745fc07000000           mov dword ptr [ebp - 4], 7
00861DD9  6a00                     push 0
00861DDB  8d8dd8fdffff             lea ecx, [ebp - 0x228]
00861DE1  51                       push ecx
00861DE2  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861DE8  e8d3f3efff               call 0x7611c0
00861DED  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861DF4  8d8dd8fdffff             lea ecx, [ebp - 0x228]
00861DFA  e8d138baff               call 0x4056d0
00861DFF  8b155889b900             mov edx, dword ptr [0xb98958]
00861E05  52                       push edx
00861E06  8d8dbcfdffff             lea ecx, [ebp - 0x244]
00861E0C  e83f38baff               call 0x405650
00861E11  c745fc08000000           mov dword ptr [ebp - 4], 8
00861E18  6a00                     push 0
00861E1A  8d85bcfdffff             lea eax, [ebp - 0x244]
00861E20  50                       push eax
00861E21  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861E27  e894f3efff               call 0x7611c0
00861E2C  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861E33  8d8dbcfdffff             lea ecx, [ebp - 0x244]
00861E39  e89238baff               call 0x4056d0
00861E3E  8b0da488b900             mov ecx, dword ptr [0xb988a4]
00861E44  51                       push ecx
00861E45  8d8da0fdffff             lea ecx, [ebp - 0x260]
00861E4B  e80038baff               call 0x405650
00861E50  c745fc09000000           mov dword ptr [ebp - 4], 9
00861E57  6a00                     push 0
00861E59  8d95a0fdffff             lea edx, [ebp - 0x260]
00861E5F  52                       push edx
00861E60  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861E66  e865e5efff               call 0x7603d0
00861E6B  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861E72  8d8da0fdffff             lea ecx, [ebp - 0x260]
00861E78  e85338baff               call 0x4056d0
00861E7D  a15c89b900               mov eax, dword ptr [0xb9895c]
00861E82  50                       push eax
00861E83  8d8d84fdffff             lea ecx, [ebp - 0x27c]
00861E89  e8c237baff               call 0x405650
00861E8E  c745fc0a000000           mov dword ptr [ebp - 4], 0xa
00861E95  8d8d84fdffff             lea ecx, [ebp - 0x27c]
00861E9B  51                       push ecx
00861E9C  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861EA2  e849ddefff               call 0x75fbf0
00861EA7  89855cffffff             mov dword ptr [ebp - 0xa4], eax
00861EAD  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861EB4  8d8d84fdffff             lea ecx, [ebp - 0x27c]
00861EBA  e81138baff               call 0x4056d0
00861EBF  83bd5cffffff00           cmp dword ptr [ebp - 0xa4], 0
00861EC6  7448                     je 0x861f10
00861EC8  68e85fbc00               push 0xbc5fe8
00861ECD  8d8d68fdffff             lea ecx, [ebp - 0x298]
00861ED3  e87837baff               call 0x405650
00861ED8  c745fc0b000000           mov dword ptr [ebp - 4], 0xb
00861EDF  6a01                     push 1
00861EE1  8d9568fdffff             lea edx, [ebp - 0x298]
00861EE7  52                       push edx
00861EE8  8b855cffffff             mov eax, dword ptr [ebp - 0xa4]
00861EEE  8b10                     mov edx, dword ptr [eax]
00861EF0  8b8d5cffffff             mov ecx, dword ptr [ebp - 0xa4]
00861EF6  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
00861EFC  ffd0                     call eax
00861EFE  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861F05  8d8d68fdffff             lea ecx, [ebp - 0x298]
00861F0B  e8c037baff               call 0x4056d0
00861F10  8b0d6089b900             mov ecx, dword ptr [0xb98960]
00861F16  51                       push ecx
00861F17  8d8d4cfdffff             lea ecx, [ebp - 0x2b4]
00861F1D  e82e37baff               call 0x405650
00861F22  c745fc0c000000           mov dword ptr [ebp - 4], 0xc
00861F29  8d954cfdffff             lea edx, [ebp - 0x2b4]
00861F2F  52                       push edx
00861F30  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861F36  e8b5dcefff               call 0x75fbf0
00861F3B  89855cffffff             mov dword ptr [ebp - 0xa4], eax
00861F41  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861F48  8d8d4cfdffff             lea ecx, [ebp - 0x2b4]
00861F4E  e87d37baff               call 0x4056d0
00861F53  83bd5cffffff00           cmp dword ptr [ebp - 0xa4], 0
00861F5A  7448                     je 0x861fa4
00861F5C  689966b900               push 0xb96699
00861F61  8d8d30fdffff             lea ecx, [ebp - 0x2d0]
00861F67  e8e436baff               call 0x405650
00861F6C  c745fc0d000000           mov dword ptr [ebp - 4], 0xd
00861F73  6a01                     push 1
00861F75  8d8530fdffff             lea eax, [ebp - 0x2d0]
00861F7B  50                       push eax
00861F7C  8b8d5cffffff             mov ecx, dword ptr [ebp - 0xa4]
00861F82  8b11                     mov edx, dword ptr [ecx]
00861F84  8b8d5cffffff             mov ecx, dword ptr [ebp - 0xa4]
00861F8A  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
00861F90  ffd0                     call eax
00861F92  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861F99  8d8d30fdffff             lea ecx, [ebp - 0x2d0]
00861F9F  e82c37baff               call 0x4056d0
00861FA4  e9b1060000               jmp 0x86265a
00861FA9  8b0d5489b900             mov ecx, dword ptr [0xb98954]
00861FAF  51                       push ecx
00861FB0  8d8d14fdffff             lea ecx, [ebp - 0x2ec]
00861FB6  e89536baff               call 0x405650
00861FBB  c745fc0e000000           mov dword ptr [ebp - 4], 0xe
00861FC2  6a01                     push 1
00861FC4  8d9514fdffff             lea edx, [ebp - 0x2ec]
00861FCA  52                       push edx
00861FCB  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00861FD1  e8eaf1efff               call 0x7611c0
00861FD6  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00861FDD  8d8d14fdffff             lea ecx, [ebp - 0x2ec]
00861FE3  e8e836baff               call 0x4056d0
00861FE8  a15889b900               mov eax, dword ptr [0xb98958]
00861FED  50                       push eax
00861FEE  8d8df8fcffff             lea ecx, [ebp - 0x308]
00861FF4  e85736baff               call 0x405650
00861FF9  c745fc0f000000           mov dword ptr [ebp - 4], 0xf
00862000  6a01                     push 1
00862002  8d8df8fcffff             lea ecx, [ebp - 0x308]
00862008  51                       push ecx
00862009  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
0086200F  e8acf1efff               call 0x7611c0
00862014  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086201B  8d8df8fcffff             lea ecx, [ebp - 0x308]
00862021  e8aa36baff               call 0x4056d0
00862026  8b15a488b900             mov edx, dword ptr [0xb988a4]
0086202C  52                       push edx
0086202D  8d8ddcfcffff             lea ecx, [ebp - 0x324]
00862033  e81836baff               call 0x405650
00862038  c745fc10000000           mov dword ptr [ebp - 4], 0x10
0086203F  6a01                     push 1
00862041  8d85dcfcffff             lea eax, [ebp - 0x324]
00862047  50                       push eax
00862048  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
0086204E  e87de3efff               call 0x7603d0
00862053  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086205A  8d8ddcfcffff             lea ecx, [ebp - 0x324]
00862060  e86b36baff               call 0x4056d0
00862065  8b0d5c89b900             mov ecx, dword ptr [0xb9895c]
0086206B  51                       push ecx
0086206C  8d8dc0fcffff             lea ecx, [ebp - 0x340]
00862072  e8d935baff               call 0x405650
00862077  c745fc11000000           mov dword ptr [ebp - 4], 0x11
0086207E  8d95c0fcffff             lea edx, [ebp - 0x340]
00862084  52                       push edx
00862085  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
0086208B  e860dbefff               call 0x75fbf0
00862090  898554ffffff             mov dword ptr [ebp - 0xac], eax
00862096  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086209D  8d8dc0fcffff             lea ecx, [ebp - 0x340]
008620A3  e82836baff               call 0x4056d0
008620A8  83bd54ffffff00           cmp dword ptr [ebp - 0xac], 0
008620AF  747a                     je 0x86212b
008620B1  8b0dfc867c01             mov ecx, dword ptr [0x17c86fc]
008620B7  e894b7caff               call 0x50d850
008620BC  3945d8                   cmp dword ptr [ebp - 0x28], eax
008620BF  7612                     jbe 0x8620d3
008620C1  680000ffff               push 0xffff0000
008620C6  8b8d54ffffff             mov ecx, dword ptr [ebp - 0xac]
008620CC  e87f02c5ff               call 0x4b2350
008620D1  eb0d                     jmp 0x8620e0
008620D3  6aff                     push -1
008620D5  8b8d54ffffff             mov ecx, dword ptr [ebp - 0xac]
008620DB  e87002c5ff               call 0x4b2350
008620E0  8d45d8                   lea eax, [ebp - 0x28]
008620E3  50                       push eax
008620E4  8d8d30ffffff             lea ecx, [ebp - 0xd0]
008620EA  51                       push ecx
008620EB  e8a0fbbaff               call 0x411c90
008620F0  83c408                   add esp, 8
008620F3  c745fc12000000           mov dword ptr [ebp - 4], 0x12
008620FA  6a01                     push 1
008620FC  8d9530ffffff             lea edx, [ebp - 0xd0]
00862102  52                       push edx
00862103  8b8554ffffff             mov eax, dword ptr [ebp - 0xac]
00862109  8b10                     mov edx, dword ptr [eax]
0086210B  8b8d54ffffff             mov ecx, dword ptr [ebp - 0xac]
00862111  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
00862117  ffd0                     call eax
00862119  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862120  8d8d30ffffff             lea ecx, [ebp - 0xd0]
00862126  e8a535baff               call 0x4056d0
0086212B  8b0d6089b900             mov ecx, dword ptr [0xb98960]
00862131  51                       push ecx
00862132  8d8da4fcffff             lea ecx, [ebp - 0x35c]
00862138  e81335baff               call 0x405650
0086213D  c745fc13000000           mov dword ptr [ebp - 4], 0x13
00862144  8d95a4fcffff             lea edx, [ebp - 0x35c]
0086214A  52                       push edx
0086214B  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00862151  e89adaefff               call 0x75fbf0
00862156  898554ffffff             mov dword ptr [ebp - 0xac], eax
0086215C  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862163  8d8da4fcffff             lea ecx, [ebp - 0x35c]
00862169  e86235baff               call 0x4056d0
0086216E  83bd54ffffff00           cmp dword ptr [ebp - 0xac], 0
00862175  0f8487000000             je 0x862202
0086217B  8d45dc                   lea eax, [ebp - 0x24]
0086217E  50                       push eax
0086217F  8d8d88fcffff             lea ecx, [ebp - 0x378]
00862185  51                       push ecx
00862186  e805fbbaff               call 0x411c90
0086218B  83c408                   add esp, 8
0086218E  8985bcf9ffff             mov dword ptr [ebp - 0x644], eax
00862194  8b95bcf9ffff             mov edx, dword ptr [ebp - 0x644]
0086219A  8995b8f9ffff             mov dword ptr [ebp - 0x648], edx
008621A0  c745fc14000000           mov dword ptr [ebp - 4], 0x14
008621A7  6868eabb00               push 0xbbea68
008621AC  8b85b8f9ffff             mov eax, dword ptr [ebp - 0x648]
008621B2  50                       push eax
008621B3  8d8d14ffffff             lea ecx, [ebp - 0xec]
008621B9  51                       push ecx
008621BA  e83173bbff               call 0x4194f0
008621BF  83c40c                   add esp, 0xc
008621C2  c645fc16                 mov byte ptr [ebp - 4], 0x16
008621C6  8d8d88fcffff             lea ecx, [ebp - 0x378]
008621CC  e8ff34baff               call 0x4056d0
008621D1  6a01                     push 1
008621D3  8d9514ffffff             lea edx, [ebp - 0xec]
008621D9  52                       push edx
008621DA  8b8554ffffff             mov eax, dword ptr [ebp - 0xac]
008621E0  8b10                     mov edx, dword ptr [eax]
008621E2  8b8d54ffffff             mov ecx, dword ptr [ebp - 0xac]
008621E8  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
008621EE  ffd0                     call eax
008621F0  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008621F7  8d8d14ffffff             lea ecx, [ebp - 0xec]
008621FD  e8ce34baff               call 0x4056d0
00862202  8b0d3489b900             mov ecx, dword ptr [0xb98934]
00862208  51                       push ecx
00862209  8d8d6cfcffff             lea ecx, [ebp - 0x394]
0086220F  e83c34baff               call 0x405650
00862214  c745fc17000000           mov dword ptr [ebp - 4], 0x17
0086221B  8d956cfcffff             lea edx, [ebp - 0x394]
00862221  52                       push edx
00862222  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00862228  e8c3d9efff               call 0x75fbf0
0086222D  898550ffffff             mov dword ptr [ebp - 0xb0], eax
00862233  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086223A  8d8d6cfcffff             lea ecx, [ebp - 0x394]
00862240  e88b34baff               call 0x4056d0
00862245  83bd50ffffff00           cmp dword ptr [ebp - 0xb0], 0
0086224C  0f84a0000000             je 0x8622f2
00862252  8d8564ffffff             lea eax, [ebp - 0x9c]
00862258  50                       push eax
00862259  8d8d50fcffff             lea ecx, [ebp - 0x3b0]
0086225F  51                       push ecx
00862260  e82bfabaff               call 0x411c90
00862265  83c408                   add esp, 8
00862268  8985b4f9ffff             mov dword ptr [ebp - 0x64c], eax
0086226E  8b95b4f9ffff             mov edx, dword ptr [ebp - 0x64c]
00862274  8995b0f9ffff             mov dword ptr [ebp - 0x650], edx
0086227A  c745fc18000000           mov dword ptr [ebp - 4], 0x18
00862281  8b85b0f9ffff             mov eax, dword ptr [ebp - 0x650]
00862287  50                       push eax
00862288  6820d5bb00               push 0xbbd520
0086228D  8d8d34fcffff             lea ecx, [ebp - 0x3cc]
00862293  51                       push ecx
00862294  e8d7fabaff               call 0x411d70
00862299  83c40c                   add esp, 0xc
0086229C  8985acf9ffff             mov dword ptr [ebp - 0x654], eax
008622A2  8b95acf9ffff             mov edx, dword ptr [ebp - 0x654]
008622A8  8995a8f9ffff             mov dword ptr [ebp - 0x658], edx
008622AE  c645fc19                 mov byte ptr [ebp - 4], 0x19
008622B2  6a01                     push 1
008622B4  8b85a8f9ffff             mov eax, dword ptr [ebp - 0x658]
008622BA  50                       push eax
008622BB  8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
008622C1  8b11                     mov edx, dword ptr [ecx]
008622C3  8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
008622C9  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
008622CF  ffd0                     call eax
008622D1  c645fc18                 mov byte ptr [ebp - 4], 0x18
008622D5  8d8d34fcffff             lea ecx, [ebp - 0x3cc]
008622DB  e8f033baff               call 0x4056d0
008622E0  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008622E7  8d8d50fcffff             lea ecx, [ebp - 0x3b0]
008622ED  e8de33baff               call 0x4056d0
008622F2  8b0d4489b900             mov ecx, dword ptr [0xb98944]
008622F8  51                       push ecx
008622F9  8d8d18fcffff             lea ecx, [ebp - 0x3e8]
008622FF  e84c33baff               call 0x405650
00862304  c745fc1a000000           mov dword ptr [ebp - 4], 0x1a
0086230B  8d9518fcffff             lea edx, [ebp - 0x3e8]
00862311  52                       push edx
00862312  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00862318  e8d3d8efff               call 0x75fbf0
0086231D  898550ffffff             mov dword ptr [ebp - 0xb0], eax
00862323  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086232A  8d8d18fcffff             lea ecx, [ebp - 0x3e8]
00862330  e89b33baff               call 0x4056d0
00862335  83bd50ffffff00           cmp dword ptr [ebp - 0xb0], 0
0086233C  0f8404010000             je 0x862446
00862342  8d8568ffffff             lea eax, [ebp - 0x98]
00862348  50                       push eax
00862349  8d8dfcfbffff             lea ecx, [ebp - 0x404]
0086234F  51                       push ecx
00862350  e83bf9baff               call 0x411c90
00862355  83c408                   add esp, 8
00862358  8985a4f9ffff             mov dword ptr [ebp - 0x65c], eax
0086235E  8b95a4f9ffff             mov edx, dword ptr [ebp - 0x65c]
00862364  8995a0f9ffff             mov dword ptr [ebp - 0x660], edx
0086236A  c745fc1b000000           mov dword ptr [ebp - 4], 0x1b
00862371  8d45b3                   lea eax, [ebp - 0x4d]
00862374  50                       push eax
00862375  8d8de0fbffff             lea ecx, [ebp - 0x420]
0086237B  51                       push ecx
0086237C  e80ff9baff               call 0x411c90
00862381  83c408                   add esp, 8
00862384  89859cf9ffff             mov dword ptr [ebp - 0x664], eax
0086238A  8b959cf9ffff             mov edx, dword ptr [ebp - 0x664]
00862390  899598f9ffff             mov dword ptr [ebp - 0x668], edx
00862396  c645fc1c                 mov byte ptr [ebp - 4], 0x1c
0086239A  68e0cbb900               push 0xb9cbe0
0086239F  8b8598f9ffff             mov eax, dword ptr [ebp - 0x668]
008623A5  50                       push eax
008623A6  8d8dc4fbffff             lea ecx, [ebp - 0x43c]
008623AC  51                       push ecx
008623AD  e83e71bbff               call 0x4194f0
008623B2  83c40c                   add esp, 0xc
008623B5  898594f9ffff             mov dword ptr [ebp - 0x66c], eax
008623BB  8b9594f9ffff             mov edx, dword ptr [ebp - 0x66c]
008623C1  899590f9ffff             mov dword ptr [ebp - 0x670], edx
008623C7  c645fc1d                 mov byte ptr [ebp - 4], 0x1d
008623CB  8b85a0f9ffff             mov eax, dword ptr [ebp - 0x660]
008623D1  50                       push eax
008623D2  8b8d90f9ffff             mov ecx, dword ptr [ebp - 0x670]
008623D8  51                       push ecx
008623D9  8d95f8feffff             lea edx, [ebp - 0x108]
008623DF  52                       push edx
008623E0  e81b90bbff               call 0x41b400
008623E5  83c40c                   add esp, 0xc
008623E8  c645fc1f                 mov byte ptr [ebp - 4], 0x1f
008623EC  8d8dc4fbffff             lea ecx, [ebp - 0x43c]
008623F2  e8d932baff               call 0x4056d0
008623F7  c645fc20                 mov byte ptr [ebp - 4], 0x20
008623FB  8d8de0fbffff             lea ecx, [ebp - 0x420]
00862401  e8ca32baff               call 0x4056d0
00862406  c645fc21                 mov byte ptr [ebp - 4], 0x21
0086240A  8d8dfcfbffff             lea ecx, [ebp - 0x404]
00862410  e8bb32baff               call 0x4056d0
00862415  6a01                     push 1
00862417  8d85f8feffff             lea eax, [ebp - 0x108]
0086241D  50                       push eax
0086241E  8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00862424  8b11                     mov edx, dword ptr [ecx]
00862426  8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
0086242C  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
00862432  ffd0                     call eax
00862434  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086243B  8d8df8feffff             lea ecx, [ebp - 0x108]
00862441  e88a32baff               call 0x4056d0
00862446  8b0d4c89b900             mov ecx, dword ptr [0xb9894c]
0086244C  51                       push ecx
0086244D  8d8da8fbffff             lea ecx, [ebp - 0x458]
00862453  e8f831baff               call 0x405650
00862458  c745fc22000000           mov dword ptr [ebp - 4], 0x22
0086245F  8d95a8fbffff             lea edx, [ebp - 0x458]
00862465  52                       push edx
00862466  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
0086246C  e87fd7efff               call 0x75fbf0
00862471  898550ffffff             mov dword ptr [ebp - 0xb0], eax
00862477  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086247E  8d8da8fbffff             lea ecx, [ebp - 0x458]
00862484  e84732baff               call 0x4056d0
00862489  83bd50ffffff00           cmp dword ptr [ebp - 0xb0], 0
00862490  745d                     je 0x8624ef
00862492  8d45e1                   lea eax, [ebp - 0x1f]
00862495  50                       push eax
00862496  8d8d8cfbffff             lea ecx, [ebp - 0x474]
0086249C  51                       push ecx
0086249D  e8eef7baff               call 0x411c90
008624A2  83c408                   add esp, 8
008624A5  89858cf9ffff             mov dword ptr [ebp - 0x674], eax
008624AB  8b958cf9ffff             mov edx, dword ptr [ebp - 0x674]
008624B1  899588f9ffff             mov dword ptr [ebp - 0x678], edx
008624B7  c745fc23000000           mov dword ptr [ebp - 4], 0x23
008624BE  6a01                     push 1
008624C0  8b8588f9ffff             mov eax, dword ptr [ebp - 0x678]
008624C6  50                       push eax
008624C7  8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
008624CD  8b11                     mov edx, dword ptr [ecx]
008624CF  8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
008624D5  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
008624DB  ffd0                     call eax
008624DD  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008624E4  8d8d8cfbffff             lea ecx, [ebp - 0x474]
008624EA  e8e131baff               call 0x4056d0
008624EF  8b0d5089b900             mov ecx, dword ptr [0xb98950]
008624F5  51                       push ecx
008624F6  8d8d70fbffff             lea ecx, [ebp - 0x490]
008624FC  e84f31baff               call 0x405650
00862501  c745fc24000000           mov dword ptr [ebp - 4], 0x24
00862508  8d9570fbffff             lea edx, [ebp - 0x490]
0086250E  52                       push edx
0086250F  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00862515  e8d6d6efff               call 0x75fbf0
0086251A  898550ffffff             mov dword ptr [ebp - 0xb0], eax
00862520  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862527  8d8d70fbffff             lea ecx, [ebp - 0x490]
0086252D  e89e31baff               call 0x4056d0
00862532  83bd50ffffff00           cmp dword ptr [ebp - 0xb0], 0
00862539  0f84af000000             je 0x8625ee
0086253F  8b8575ffffff             mov eax, dword ptr [ebp - 0x8b]
00862545  2b45e1                   sub eax, dword ptr [ebp - 0x1f]
00862548  89856cfbffff             mov dword ptr [ebp - 0x494], eax
0086254E  8d8d6cfbffff             lea ecx, [ebp - 0x494]
00862554  51                       push ecx
00862555  8d9550fbffff             lea edx, [ebp - 0x4b0]
0086255B  52                       push edx
0086255C  e82ff7baff               call 0x411c90
00862561  83c408                   add esp, 8
00862564  898584f9ffff             mov dword ptr [ebp - 0x67c], eax
0086256A  8b8584f9ffff             mov eax, dword ptr [ebp - 0x67c]
00862570  898580f9ffff             mov dword ptr [ebp - 0x680], eax
00862576  c745fc25000000           mov dword ptr [ebp - 4], 0x25
0086257D  8b8d80f9ffff             mov ecx, dword ptr [ebp - 0x680]
00862583  51                       push ecx
00862584  6880d5b900               push 0xb9d580
00862589  8d9534fbffff             lea edx, [ebp - 0x4cc]
0086258F  52                       push edx
00862590  e8dbf7baff               call 0x411d70
00862595  83c40c                   add esp, 0xc
00862598  89857cf9ffff             mov dword ptr [ebp - 0x684], eax
0086259E  8b857cf9ffff             mov eax, dword ptr [ebp - 0x684]
008625A4  898578f9ffff             mov dword ptr [ebp - 0x688], eax
008625AA  c645fc26                 mov byte ptr [ebp - 4], 0x26
008625AE  6a01                     push 1
008625B0  8b8d78f9ffff             mov ecx, dword ptr [ebp - 0x688]
008625B6  51                       push ecx
008625B7  8b9550ffffff             mov edx, dword ptr [ebp - 0xb0]
008625BD  8b02                     mov eax, dword ptr [edx]
008625BF  8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
008625C5  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
008625CB  ffd2                     call edx
008625CD  c645fc25                 mov byte ptr [ebp - 4], 0x25
008625D1  8d8d34fbffff             lea ecx, [ebp - 0x4cc]
008625D7  e8f430baff               call 0x4056d0
008625DC  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008625E3  8d8d50fbffff             lea ecx, [ebp - 0x4b0]
008625E9  e8e230baff               call 0x4056d0
008625EE  a13c89b900               mov eax, dword ptr [0xb9893c]
008625F3  50                       push eax
008625F4  8d8d18fbffff             lea ecx, [ebp - 0x4e8]
008625FA  e85130baff               call 0x405650
008625FF  c745fc27000000           mov dword ptr [ebp - 4], 0x27
00862606  8d8d18fbffff             lea ecx, [ebp - 0x4e8]
0086260C  51                       push ecx
0086260D  8b8de0f9ffff             mov ecx, dword ptr [ebp - 0x620]
00862613  e8d8d5efff               call 0x75fbf0
00862618  898558ffffff             mov dword ptr [ebp - 0xa8], eax
0086261E  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862625  8d8d18fbffff             lea ecx, [ebp - 0x4e8]
0086262B  e8a030baff               call 0x4056d0
00862630  83bd58ffffff00           cmp dword ptr [ebp - 0xa8], 0
00862637  7421                     je 0x86265a
00862639  8b9568ffffff             mov edx, dword ptr [ebp - 0x98]
0086263F  52                       push edx
00862640  8b8d58ffffff             mov ecx, dword ptr [ebp - 0xa8]
00862646  e825fdc4ff               call 0x4b2370
0086264B  8b45b3                   mov eax, dword ptr [ebp - 0x4d]
0086264E  50                       push eax
0086264F  8b8d58ffffff             mov ecx, dword ptr [ebp - 0xa8]
00862655  e876332200               call 0xa859d0

; range 0x862a20..0x863450
00862A20  55                       push ebp
00862A21  8bec                     mov ebp, esp
00862A23  6aff                     push -1
00862A25  684edfac00               push 0xacdf4e
00862A2A  64a100000000             mov eax, dword ptr fs:[0]
00862A30  50                       push eax
00862A31  81ec84030000             sub esp, 0x384
00862A37  a180b4c700               mov eax, dword ptr [0xc7b480]
00862A3C  33c5                     xor eax, ebp
00862A3E  8945c0                   mov dword ptr [ebp - 0x40], eax
00862A41  50                       push eax
00862A42  8d45f4                   lea eax, [ebp - 0xc]
00862A45  64a300000000             mov dword ptr fs:[0], eax
00862A4B  898d08fdffff             mov dword ptr [ebp - 0x2f8], ecx
00862A51  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00862A57  81c198050000             add ecx, 0x598
00862A5D  e84e4acbff               call 0x5174b0
00862A62  83f801                   cmp eax, 1
00862A65  7314                     jae 0x862a7b
00862A67  6a00                     push 0
00862A69  68a2530000               push 0x53a2
00862A6E  e88d9f1d00               call 0xa3ca00
00862A73  83c408                   add esp, 8
00862A76  e9b6090000               jmp 0x863431
00862A7B  68a888b900               push 0xb988a8
00862A80  8d8d5cffffff             lea ecx, [ebp - 0xa4]
00862A86  e8c52bbaff               call 0x405650
00862A8B  c745fc00000000           mov dword ptr [ebp - 4], 0
00862A92  6a00                     push 0
00862A94  68b4a32f01               push 0x12fa3b4
00862A99  6898882f01               push 0x12f8898
00862A9E  8d855cffffff             lea eax, [ebp - 0xa4]
00862AA4  50                       push eax
00862AA5  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00862AAB  e840d1efff               call 0x75fbf0
00862AB0  6a00                     push 0
00862AB2  50                       push eax
00862AB3  e856502300               call 0xa97b0e
00862AB8  83c414                   add esp, 0x14
00862ABB  8945f0                   mov dword ptr [ebp - 0x10], eax
00862ABE  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862AC5  8d8d5cffffff             lea ecx, [ebp - 0xa4]
00862ACB  e8002cbaff               call 0x4056d0
00862AD0  837df000                 cmp dword ptr [ebp - 0x10], 0
00862AD4  7505                     jne 0x862adb
00862AD6  e956090000               jmp 0x863431
00862ADB  6a18                     push 0x18
00862ADD  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00862AE0  e80bce2200               call 0xa8f8f0
00862AE5  c745ec00000000           mov dword ptr [ebp - 0x14], 0
00862AEC  eb09                     jmp 0x862af7
00862AEE  8b4dec                   mov ecx, dword ptr [ebp - 0x14]
00862AF1  83c101                   add ecx, 1
00862AF4  894dec                   mov dword ptr [ebp - 0x14], ecx
00862AF7  837dec18                 cmp dword ptr [ebp - 0x14], 0x18
00862AFB  0f8d30090000             jge 0x863431
00862B01  8b9508fdffff             mov edx, dword ptr [ebp - 0x2f8]
00862B07  8b82d0050000             mov eax, dword ptr [edx + 0x5d0]
00862B0D  6bc018                   imul eax, eax, 0x18
00862B10  0345ec                   add eax, dword ptr [ebp - 0x14]
00862B13  8945dc                   mov dword ptr [ebp - 0x24], eax
00862B16  8d4dec                   lea ecx, [ebp - 0x14]
00862B19  51                       push ecx
00862B1A  8d9540ffffff             lea edx, [ebp - 0xc0]
00862B20  52                       push edx
00862B21  e83a161e00               call 0xa44160
00862B26  83c408                   add esp, 8
00862B29  898504fdffff             mov dword ptr [ebp - 0x2fc], eax
00862B2F  8b8504fdffff             mov eax, dword ptr [ebp - 0x2fc]
00862B35  898500fdffff             mov dword ptr [ebp - 0x300], eax
00862B3B  c745fc01000000           mov dword ptr [ebp - 4], 1
00862B42  8b8d00fdffff             mov ecx, dword ptr [ebp - 0x300]
00862B48  51                       push ecx
00862B49  68b888b900               push 0xb988b8
00862B4E  8d9524ffffff             lea edx, [ebp - 0xdc]
00862B54  52                       push edx
00862B55  e816f2baff               call 0x411d70
00862B5A  83c40c                   add esp, 0xc
00862B5D  8985fcfcffff             mov dword ptr [ebp - 0x304], eax
00862B63  8b85fcfcffff             mov eax, dword ptr [ebp - 0x304]
00862B69  8985f8fcffff             mov dword ptr [ebp - 0x308], eax
00862B6F  c645fc02                 mov byte ptr [ebp - 4], 2
00862B73  6a00                     push 0
00862B75  68cc922f01               push 0x12f92cc
00862B7A  6898882f01               push 0x12f8898
00862B7F  6a00                     push 0
00862B81  8b8df8fcffff             mov ecx, dword ptr [ebp - 0x308]
00862B87  51                       push ecx
00862B88  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00862B8B  e87045efff               call 0x757100
00862B90  50                       push eax
00862B91  e8784f2300               call 0xa97b0e
00862B96  83c414                   add esp, 0x14
00862B99  8945e4                   mov dword ptr [ebp - 0x1c], eax
00862B9C  c645fc01                 mov byte ptr [ebp - 4], 1
00862BA0  8d8d24ffffff             lea ecx, [ebp - 0xdc]
00862BA6  e8252bbaff               call 0x4056d0
00862BAB  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862BB2  8d8d40ffffff             lea ecx, [ebp - 0xc0]
00862BB8  e8132bbaff               call 0x4056d0
00862BBD  8d55ec                   lea edx, [ebp - 0x14]
00862BC0  52                       push edx
00862BC1  8d8508ffffff             lea eax, [ebp - 0xf8]
00862BC7  50                       push eax
00862BC8  e893151e00               call 0xa44160
00862BCD  83c408                   add esp, 8
00862BD0  8985f4fcffff             mov dword ptr [ebp - 0x30c], eax
00862BD6  8b8df4fcffff             mov ecx, dword ptr [ebp - 0x30c]
00862BDC  898df0fcffff             mov dword ptr [ebp - 0x310], ecx
00862BE2  c745fc03000000           mov dword ptr [ebp - 4], 3
00862BE9  8b95f0fcffff             mov edx, dword ptr [ebp - 0x310]
00862BEF  52                       push edx
00862BF0  68c088b900               push 0xb988c0
00862BF5  8d85ecfeffff             lea eax, [ebp - 0x114]
00862BFB  50                       push eax
00862BFC  e86ff1baff               call 0x411d70
00862C01  83c40c                   add esp, 0xc
00862C04  8985ecfcffff             mov dword ptr [ebp - 0x314], eax
00862C0A  8b8decfcffff             mov ecx, dword ptr [ebp - 0x314]
00862C10  898de8fcffff             mov dword ptr [ebp - 0x318], ecx
00862C16  c645fc04                 mov byte ptr [ebp - 4], 4
00862C1A  8b95e8fcffff             mov edx, dword ptr [ebp - 0x318]
00862C20  52                       push edx
00862C21  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00862C24  e8d744efff               call 0x757100
00862C29  8945d0                   mov dword ptr [ebp - 0x30], eax
00862C2C  c645fc03                 mov byte ptr [ebp - 4], 3
00862C30  8d8decfeffff             lea ecx, [ebp - 0x114]
00862C36  e8952abaff               call 0x4056d0
00862C3B  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862C42  8d8d08ffffff             lea ecx, [ebp - 0xf8]
00862C48  e8832abaff               call 0x4056d0
00862C4D  8d45ec                   lea eax, [ebp - 0x14]
00862C50  50                       push eax
00862C51  8d8dd0feffff             lea ecx, [ebp - 0x130]
00862C57  51                       push ecx
00862C58  e803151e00               call 0xa44160
00862C5D  83c408                   add esp, 8
00862C60  8985e4fcffff             mov dword ptr [ebp - 0x31c], eax
00862C66  8b95e4fcffff             mov edx, dword ptr [ebp - 0x31c]
00862C6C  8995e0fcffff             mov dword ptr [ebp - 0x320], edx
00862C72  c745fc05000000           mov dword ptr [ebp - 4], 5
00862C79  8b85e0fcffff             mov eax, dword ptr [ebp - 0x320]
00862C7F  50                       push eax
00862C80  68d888b900               push 0xb988d8
00862C85  8d8db4feffff             lea ecx, [ebp - 0x14c]
00862C8B  51                       push ecx
00862C8C  e8dff0baff               call 0x411d70
00862C91  83c40c                   add esp, 0xc
00862C94  8985dcfcffff             mov dword ptr [ebp - 0x324], eax
00862C9A  8b95dcfcffff             mov edx, dword ptr [ebp - 0x324]
00862CA0  8995d8fcffff             mov dword ptr [ebp - 0x328], edx
00862CA6  c645fc06                 mov byte ptr [ebp - 4], 6
00862CAA  6a00                     push 0
00862CAC  68448a2f01               push 0x12f8a44
00862CB1  6898882f01               push 0x12f8898
00862CB6  6a00                     push 0
00862CB8  8b85d8fcffff             mov eax, dword ptr [ebp - 0x328]
00862CBE  50                       push eax
00862CBF  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00862CC2  e83944efff               call 0x757100
00862CC7  50                       push eax
00862CC8  e8414e2300               call 0xa97b0e
00862CCD  83c414                   add esp, 0x14
00862CD0  8945d4                   mov dword ptr [ebp - 0x2c], eax
00862CD3  c645fc05                 mov byte ptr [ebp - 4], 5
00862CD7  8d8db4feffff             lea ecx, [ebp - 0x14c]
00862CDD  e8ee29baff               call 0x4056d0
00862CE2  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862CE9  8d8dd0feffff             lea ecx, [ebp - 0x130]
00862CEF  e8dc29baff               call 0x4056d0
00862CF4  8d4dec                   lea ecx, [ebp - 0x14]
00862CF7  51                       push ecx
00862CF8  8d9598feffff             lea edx, [ebp - 0x168]
00862CFE  52                       push edx
00862CFF  e85c141e00               call 0xa44160
00862D04  83c408                   add esp, 8
00862D07  8985d4fcffff             mov dword ptr [ebp - 0x32c], eax
00862D0D  8b85d4fcffff             mov eax, dword ptr [ebp - 0x32c]
00862D13  8985d0fcffff             mov dword ptr [ebp - 0x330], eax
00862D19  c745fc07000000           mov dword ptr [ebp - 4], 7
00862D20  8b8dd0fcffff             mov ecx, dword ptr [ebp - 0x330]
00862D26  51                       push ecx
00862D27  68e488b900               push 0xb988e4
00862D2C  8d957cfeffff             lea edx, [ebp - 0x184]
00862D32  52                       push edx
00862D33  e838f0baff               call 0x411d70
00862D38  83c40c                   add esp, 0xc
00862D3B  8985ccfcffff             mov dword ptr [ebp - 0x334], eax
00862D41  8b85ccfcffff             mov eax, dword ptr [ebp - 0x334]
00862D47  8985c8fcffff             mov dword ptr [ebp - 0x338], eax
00862D4D  c645fc08                 mov byte ptr [ebp - 4], 8
00862D51  6a00                     push 0
00862D53  68648a2f01               push 0x12f8a64
00862D58  6898882f01               push 0x12f8898
00862D5D  6a00                     push 0
00862D5F  8b8dc8fcffff             mov ecx, dword ptr [ebp - 0x338]
00862D65  51                       push ecx
00862D66  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00862D69  e89243efff               call 0x757100
00862D6E  50                       push eax
00862D6F  e89a4d2300               call 0xa97b0e
00862D74  83c414                   add esp, 0x14
00862D77  8945d8                   mov dword ptr [ebp - 0x28], eax
00862D7A  c645fc07                 mov byte ptr [ebp - 4], 7
00862D7E  8d8d7cfeffff             lea ecx, [ebp - 0x184]
00862D84  e84729baff               call 0x4056d0
00862D89  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862D90  8d8d98feffff             lea ecx, [ebp - 0x168]
00862D96  e83529baff               call 0x4056d0
00862D9B  8d55ec                   lea edx, [ebp - 0x14]
00862D9E  52                       push edx
00862D9F  8d8560feffff             lea eax, [ebp - 0x1a0]
00862DA5  50                       push eax
00862DA6  e8b5131e00               call 0xa44160
00862DAB  83c408                   add esp, 8
00862DAE  8985c4fcffff             mov dword ptr [ebp - 0x33c], eax
00862DB4  8b8dc4fcffff             mov ecx, dword ptr [ebp - 0x33c]
00862DBA  898dc0fcffff             mov dword ptr [ebp - 0x340], ecx
00862DC0  c745fc09000000           mov dword ptr [ebp - 4], 9
00862DC7  8b95c0fcffff             mov edx, dword ptr [ebp - 0x340]
00862DCD  52                       push edx
00862DCE  68f488b900               push 0xb988f4
00862DD3  8d8544feffff             lea eax, [ebp - 0x1bc]
00862DD9  50                       push eax
00862DDA  e891efbaff               call 0x411d70
00862DDF  83c40c                   add esp, 0xc
00862DE2  8985bcfcffff             mov dword ptr [ebp - 0x344], eax
00862DE8  8b8dbcfcffff             mov ecx, dword ptr [ebp - 0x344]
00862DEE  898db8fcffff             mov dword ptr [ebp - 0x348], ecx
00862DF4  c645fc0a                 mov byte ptr [ebp - 4], 0xa
00862DF8  6a00                     push 0
00862DFA  68448a2f01               push 0x12f8a44
00862DFF  6898882f01               push 0x12f8898
00862E04  6a00                     push 0
00862E06  8b95b8fcffff             mov edx, dword ptr [ebp - 0x348]
00862E0C  52                       push edx
00862E0D  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00862E10  e8eb42efff               call 0x757100
00862E15  50                       push eax
00862E16  e8f34c2300               call 0xa97b0e
00862E1B  83c414                   add esp, 0x14
00862E1E  8945e0                   mov dword ptr [ebp - 0x20], eax
00862E21  c645fc09                 mov byte ptr [ebp - 4], 9
00862E25  8d8d44feffff             lea ecx, [ebp - 0x1bc]
00862E2B  e8a028baff               call 0x4056d0
00862E30  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862E37  8d8d60feffff             lea ecx, [ebp - 0x1a0]
00862E3D  e88e28baff               call 0x4056d0
00862E42  8d45ec                   lea eax, [ebp - 0x14]
00862E45  50                       push eax
00862E46  8d8d28feffff             lea ecx, [ebp - 0x1d8]
00862E4C  51                       push ecx
00862E4D  e80e131e00               call 0xa44160
00862E52  83c408                   add esp, 8
00862E55  8985b4fcffff             mov dword ptr [ebp - 0x34c], eax
00862E5B  8b95b4fcffff             mov edx, dword ptr [ebp - 0x34c]
00862E61  8995b0fcffff             mov dword ptr [ebp - 0x350], edx
00862E67  c745fc0b000000           mov dword ptr [ebp - 4], 0xb
00862E6E  8b85b0fcffff             mov eax, dword ptr [ebp - 0x350]
00862E74  50                       push eax
00862E75  680489b900               push 0xb98904
00862E7A  8d8d0cfeffff             lea ecx, [ebp - 0x1f4]
00862E80  51                       push ecx
00862E81  e8eaeebaff               call 0x411d70
00862E86  83c40c                   add esp, 0xc
00862E89  8985acfcffff             mov dword ptr [ebp - 0x354], eax
00862E8F  8b95acfcffff             mov edx, dword ptr [ebp - 0x354]
00862E95  8995a8fcffff             mov dword ptr [ebp - 0x358], edx
00862E9B  c645fc0c                 mov byte ptr [ebp - 4], 0xc
00862E9F  6a00                     push 0
00862EA1  68448a2f01               push 0x12f8a44
00862EA6  6898882f01               push 0x12f8898
00862EAB  6a00                     push 0
00862EAD  8b85a8fcffff             mov eax, dword ptr [ebp - 0x358]
00862EB3  50                       push eax
00862EB4  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
00862EB7  e84442efff               call 0x757100
00862EBC  50                       push eax
00862EBD  e84c4c2300               call 0xa97b0e
00862EC2  83c414                   add esp, 0x14
00862EC5  8945e8                   mov dword ptr [ebp - 0x18], eax
00862EC8  c645fc0b                 mov byte ptr [ebp - 4], 0xb
00862ECC  8d8d0cfeffff             lea ecx, [ebp - 0x1f4]
00862ED2  e8f927baff               call 0x4056d0
00862ED7  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862EDE  8d8d28feffff             lea ecx, [ebp - 0x1d8]
00862EE4  e8e727baff               call 0x4056d0
00862EE9  837de400                 cmp dword ptr [ebp - 0x1c], 0
00862EED  741e                     je 0x862f0d
00862EEF  837dd000                 cmp dword ptr [ebp - 0x30], 0
00862EF3  7418                     je 0x862f0d
00862EF5  837dd400                 cmp dword ptr [ebp - 0x2c], 0
00862EF9  7412                     je 0x862f0d
00862EFB  837dd800                 cmp dword ptr [ebp - 0x28], 0
00862EFF  740c                     je 0x862f0d
00862F01  837de000                 cmp dword ptr [ebp - 0x20], 0
00862F05  7406                     je 0x862f0d
00862F07  837de800                 cmp dword ptr [ebp - 0x18], 0
00862F0B  7505                     jne 0x862f12
00862F0D  e9dcfbffff               jmp 0x862aee
00862F12  6a00                     push 0
00862F14  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
00862F17  e8147befff               call 0x75aa30
00862F1C  689966b900               push 0xb96699
00862F21  8d8df0fdffff             lea ecx, [ebp - 0x210]
00862F27  e82427baff               call 0x405650
00862F2C  c745fc0d000000           mov dword ptr [ebp - 4], 0xd
00862F33  6a01                     push 1
00862F35  8d8df0fdffff             lea ecx, [ebp - 0x210]
00862F3B  51                       push ecx
00862F3C  8b55d4                   mov edx, dword ptr [ebp - 0x2c]
00862F3F  8b02                     mov eax, dword ptr [edx]
00862F41  8b4dd4                   mov ecx, dword ptr [ebp - 0x2c]
00862F44  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
00862F4A  ffd2                     call edx
00862F4C  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862F53  8d8df0fdffff             lea ecx, [ebp - 0x210]
00862F59  e87227baff               call 0x4056d0
00862F5E  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00862F64  81c180050000             add ecx, 0x580
00862F6A  e86142cfff               call 0x5571d0
00862F6F  3945dc                   cmp dword ptr [ebp - 0x24], eax
00862F72  0f83b4040000             jae 0x86342c
00862F78  8b45dc                   mov eax, dword ptr [ebp - 0x24]
00862F7B  50                       push eax
00862F7C  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00862F82  81c180050000             add ecx, 0x580
00862F88  e8a361cfff               call 0x559130
00862F8D  8b4805                   mov ecx, dword ptr [eax + 5]
00862F90  51                       push ecx
00862F91  e89aeb1b00               call 0xa21b30
00862F96  8bc8                     mov ecx, eax
00862F98  e8c3b51b00               call 0xa1e560
00862F9D  8945c8                   mov dword ptr [ebp - 0x38], eax
00862FA0  837dc800                 cmp dword ptr [ebp - 0x38], 0
00862FA4  7505                     jne 0x862fab
00862FA6  e943fbffff               jmp 0x862aee
00862FAB  6a01                     push 1
00862FAD  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
00862FB0  e87b7aefff               call 0x75aa30
00862FB5  8b4dc8                   mov ecx, dword ptr [ebp - 0x38]
00862FB8  83c144                   add ecx, 0x44
00862FBB  e85034baff               call 0x406410
00862FC0  50                       push eax
00862FC1  8d8dd4fdffff             lea ecx, [ebp - 0x22c]
00862FC7  e88426baff               call 0x405650
00862FCC  c745fc0e000000           mov dword ptr [ebp - 4], 0xe
00862FD3  8d95d4fdffff             lea edx, [ebp - 0x22c]
00862FD9  52                       push edx
00862FDA  8b45d0                   mov eax, dword ptr [ebp - 0x30]
00862FDD  8b10                     mov edx, dword ptr [eax]
00862FDF  8b4dd0                   mov ecx, dword ptr [ebp - 0x30]
00862FE2  8b4228                   mov eax, dword ptr [edx + 0x28]
00862FE5  ffd0                     call eax
00862FE7  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00862FEE  8d8dd4fdffff             lea ecx, [ebp - 0x22c]
00862FF4  e8d726baff               call 0x4056d0
00862FF9  8b4ddc                   mov ecx, dword ptr [ebp - 0x24]
00862FFC  51                       push ecx
00862FFD  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00863003  81c180050000             add ecx, 0x580
00863009  e82261cfff               call 0x559130
0086300E  83c005                   add eax, 5
00863011  50                       push eax
00863012  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00863018  81c1b0050000             add ecx, 0x5b0
0086301E  e85d45cbff               call 0x517580
00863023  8bc8                     mov ecx, eax
00863025  e8867fbbff               call 0x41afb0
0086302A  0fb6d0                   movzx edx, al
0086302D  85d2                     test edx, edx
0086302F  744b                     je 0x86307c
00863031  8b4dc8                   mov ecx, dword ptr [ebp - 0x38]
00863034  83c10c                   add ecx, 0xc
00863037  e8d433baff               call 0x406410
0086303C  50                       push eax
0086303D  8d8db8fdffff             lea ecx, [ebp - 0x248]
00863043  e80826baff               call 0x405650
00863048  c745fc0f000000           mov dword ptr [ebp - 4], 0xf
0086304F  6a01                     push 1
00863051  8d85b8fdffff             lea eax, [ebp - 0x248]
00863057  50                       push eax
00863058  8b4dd4                   mov ecx, dword ptr [ebp - 0x2c]
0086305B  8b11                     mov edx, dword ptr [ecx]
0086305D  8b4dd4                   mov ecx, dword ptr [ebp - 0x2c]
00863060  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
00863066  ffd0                     call eax
00863068  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
0086306F  8d8db8fdffff             lea ecx, [ebp - 0x248]
00863075  e85626baff               call 0x4056d0
0086307A  eb3d                     jmp 0x8630b9
0086307C  6a01                     push 1
0086307E  8b4ddc                   mov ecx, dword ptr [ebp - 0x24]
00863081  51                       push ecx
00863082  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00863088  81c180050000             add ecx, 0x580
0086308E  e89d60cfff               call 0x559130
00863093  83c005                   add eax, 5
00863096  50                       push eax
00863097  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
0086309D  81c1b0050000             add ecx, 0x5b0
008630A3  e8d844cbff               call 0x517580
008630A8  50                       push eax
008630A9  8b55d4                   mov edx, dword ptr [ebp - 0x2c]
008630AC  8b02                     mov eax, dword ptr [edx]
008630AE  8b4dd4                   mov ecx, dword ptr [ebp - 0x2c]
008630B1  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
008630B7  ffd2                     call edx
008630B9  8b45dc                   mov eax, dword ptr [ebp - 0x24]
008630BC  50                       push eax
008630BD  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
008630C3  81c180050000             add ecx, 0x580
008630C9  e86260cfff               call 0x559130
008630CE  8b482f                   mov ecx, dword ptr [eax + 0x2f]
008630D1  898da0fcffff             mov dword ptr [ebp - 0x360], ecx
008630D7  c785a4fcffff00000000     mov dword ptr [ebp - 0x35c], 0
008630E1  dfada0fcffff             fild qword ptr [ebp - 0x360]
008630E7  d95dcc                   fstp dword ptr [ebp - 0x34]
008630EA  8b55dc                   mov edx, dword ptr [ebp - 0x24]
008630ED  52                       push edx
008630EE  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
008630F4  81c180050000             add ecx, 0x580
008630FA  e83160cfff               call 0x559130
008630FF  8b402b                   mov eax, dword ptr [eax + 0x2b]
00863102  898578ffffff             mov dword ptr [ebp - 0x88], eax
00863108  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
0086310E  81c198050000             add ecx, 0x598
00863114  e89743cbff               call 0x5174b0
00863119  398578ffffff             cmp dword ptr [ebp - 0x88], eax
0086311F  0f83fa000000             jae 0x86321f
00863125  8d8d78ffffff             lea ecx, [ebp - 0x88]
0086312B  51                       push ecx
0086312C  8d959cfdffff             lea edx, [ebp - 0x264]
00863132  52                       push edx
00863133  e828101e00               call 0xa44160
00863138  83c408                   add esp, 8
0086313B  89859cfcffff             mov dword ptr [ebp - 0x364], eax
00863141  8b859cfcffff             mov eax, dword ptr [ebp - 0x364]
00863147  898598fcffff             mov dword ptr [ebp - 0x368], eax
0086314D  c745fc10000000           mov dword ptr [ebp - 4], 0x10
00863154  8b8d98fcffff             mov ecx, dword ptr [ebp - 0x368]
0086315A  51                       push ecx
0086315B  6820d5bb00               push 0xbbd520
00863160  8d9580fdffff             lea edx, [ebp - 0x280]
00863166  52                       push edx
00863167  e804ecbaff               call 0x411d70
0086316C  83c40c                   add esp, 0xc
0086316F  898594fcffff             mov dword ptr [ebp - 0x36c], eax
00863175  8b8594fcffff             mov eax, dword ptr [ebp - 0x36c]
0086317B  898590fcffff             mov dword ptr [ebp - 0x370], eax
00863181  c645fc11                 mov byte ptr [ebp - 4], 0x11
00863185  6a01                     push 1
00863187  8b8d90fcffff             mov ecx, dword ptr [ebp - 0x370]
0086318D  51                       push ecx
0086318E  8b55e8                   mov edx, dword ptr [ebp - 0x18]
00863191  8b02                     mov eax, dword ptr [edx]
00863193  8b4de8                   mov ecx, dword ptr [ebp - 0x18]
00863196  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
0086319C  ffd2                     call edx
0086319E  c645fc10                 mov byte ptr [ebp - 4], 0x10
008631A2  8d8d80fdffff             lea ecx, [ebp - 0x280]
008631A8  e82325baff               call 0x4056d0
008631AD  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008631B4  8d8d9cfdffff             lea ecx, [ebp - 0x264]
008631BA  e81125baff               call 0x4056d0
008631BF  8b8578ffffff             mov eax, dword ptr [ebp - 0x88]
008631C5  50                       push eax
008631C6  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
008631CC  81c198050000             add ecx, 0x598
008631D2  e8f942cbff               call 0x5174d0
008631D7  8b4804                   mov ecx, dword ptr [eax + 4]
008631DA  898d88fcffff             mov dword ptr [ebp - 0x378], ecx
008631E0  c7858cfcffff00000000     mov dword ptr [ebp - 0x374], 0
008631EA  dfad88fcffff             fild qword ptr [ebp - 0x378]
008631F0  d87dcc                   fdivr dword ptr [ebp - 0x34]
008631F3  d95dc4                   fstp dword ptr [ebp - 0x3c]
008631F6  8b9578ffffff             mov edx, dword ptr [ebp - 0x88]
008631FC  52                       push edx
008631FD  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00863203  81c198050000             add ecx, 0x598
00863209  e8c242cbff               call 0x5174d0
0086320E  8b4004                   mov eax, dword ptr [eax + 4]
00863211  50                       push eax
00863212  8b4dd8                   mov ecx, dword ptr [ebp - 0x28]
00863215  e856f1c4ff               call 0x4b2370
0086321A  e92b010000               jmp 0x86334a
0086321F  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00863225  81c198050000             add ecx, 0x598
0086322B  e88042cbff               call 0x5174b0
00863230  83e801                   sub eax, 1
00863233  89857cfdffff             mov dword ptr [ebp - 0x284], eax
00863239  8d8d7cfdffff             lea ecx, [ebp - 0x284]
0086323F  51                       push ecx
00863240  8d9560fdffff             lea edx, [ebp - 0x2a0]
00863246  52                       push edx
00863247  e8445fc5ff               call 0x4b9190
0086324C  83c408                   add esp, 8
0086324F  898584fcffff             mov dword ptr [ebp - 0x37c], eax
00863255  8b8584fcffff             mov eax, dword ptr [ebp - 0x37c]
0086325B  898580fcffff             mov dword ptr [ebp - 0x380], eax
00863261  c745fc12000000           mov dword ptr [ebp - 4], 0x12
00863268  8b8d80fcffff             mov ecx, dword ptr [ebp - 0x380]
0086326E  51                       push ecx
0086326F  6820d5bb00               push 0xbbd520
00863274  8d9544fdffff             lea edx, [ebp - 0x2bc]
0086327A  52                       push edx
0086327B  e8f0eabaff               call 0x411d70
00863280  83c40c                   add esp, 0xc
00863283  89857cfcffff             mov dword ptr [ebp - 0x384], eax
00863289  8b857cfcffff             mov eax, dword ptr [ebp - 0x384]
0086328F  898578fcffff             mov dword ptr [ebp - 0x388], eax
00863295  c645fc13                 mov byte ptr [ebp - 4], 0x13
00863299  6a01                     push 1
0086329B  8b8d78fcffff             mov ecx, dword ptr [ebp - 0x388]
008632A1  51                       push ecx
008632A2  8b55e8                   mov edx, dword ptr [ebp - 0x18]
008632A5  8b02                     mov eax, dword ptr [edx]
008632A7  8b4de8                   mov ecx, dword ptr [ebp - 0x18]
008632AA  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
008632B0  ffd2                     call edx
008632B2  c645fc12                 mov byte ptr [ebp - 4], 0x12
008632B6  8d8d44fdffff             lea ecx, [ebp - 0x2bc]
008632BC  e80f24baff               call 0x4056d0
008632C1  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008632C8  8d8d60fdffff             lea ecx, [ebp - 0x2a0]
008632CE  e8fd23baff               call 0x4056d0
008632D3  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
008632D9  81c198050000             add ecx, 0x598
008632DF  e8cc41cbff               call 0x5174b0
008632E4  83e801                   sub eax, 1
008632E7  50                       push eax
008632E8  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
008632EE  81c198050000             add ecx, 0x598
008632F4  e8d741cbff               call 0x5174d0
008632F9  8b4004                   mov eax, dword ptr [eax + 4]
008632FC  898570fcffff             mov dword ptr [ebp - 0x390], eax
00863302  c78574fcffff00000000     mov dword ptr [ebp - 0x38c], 0
0086330C  dfad70fcffff             fild qword ptr [ebp - 0x390]
00863312  d87dcc                   fdivr dword ptr [ebp - 0x34]
00863315  d95dc4                   fstp dword ptr [ebp - 0x3c]
00863318  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
0086331E  81c198050000             add ecx, 0x598
00863324  e88741cbff               call 0x5174b0
00863329  83e801                   sub eax, 1
0086332C  50                       push eax
0086332D  8b8d08fdffff             mov ecx, dword ptr [ebp - 0x2f8]
00863333  81c198050000             add ecx, 0x598
00863339  e89241cbff               call 0x5174d0
0086333E  8b4804                   mov ecx, dword ptr [eax + 4]
00863341  51                       push ecx
00863342  8b4dd8                   mov ecx, dword ptr [ebp - 0x28]
00863345  e826f0c4ff               call 0x4b2370
0086334A  d945c4                   fld dword ptr [ebp - 0x3c]
0086334D  dc0d6084be00             fmul qword ptr [0xbe8460]
00863353  83ec08                   sub esp, 8
00863356  dd1c24                   fstp qword ptr [esp]
00863359  68d85fbc00               push 0xbc5fd8
0086335E  6a40                     push 0x40
00863360  8d957cffffff             lea edx, [ebp - 0x84]
00863366  52                       push edx
00863367  e87f08e0ff               call 0x663beb
0086336C  83c414                   add esp, 0x14
0086336F  6868eabb00               push 0xbbea68
00863374  8d857cffffff             lea eax, [ebp - 0x84]
0086337A  50                       push eax
0086337B  e8d027e0ff               call 0x665b50
00863380  83c408                   add esp, 8
00863383  d945c4                   fld dword ptr [ebp - 0x3c]
00863386  dc1d5083be00             fcomp qword ptr [0xbe8350]
0086338C  dfe0                     fnstsw ax
0086338E  f6c401                   test ah, 1
00863391  7544                     jne 0x8633d7
00863393  68e05fbc00               push 0xbc5fe0
00863398  8d8d28fdffff             lea ecx, [ebp - 0x2d8]
0086339E  e8ad22baff               call 0x405650
008633A3  c745fc14000000           mov dword ptr [ebp - 4], 0x14
008633AA  6a01                     push 1
008633AC  8d8d28fdffff             lea ecx, [ebp - 0x2d8]
008633B2  51                       push ecx
008633B3  8b55e0                   mov edx, dword ptr [ebp - 0x20]
008633B6  8b02                     mov eax, dword ptr [edx]
008633B8  8b4de0                   mov ecx, dword ptr [ebp - 0x20]
008633BB  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
008633C1  ffd2                     call edx
008633C3  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
008633CA  8d8d28fdffff             lea ecx, [ebp - 0x2d8]
008633D0  e8fb22baff               call 0x4056d0
008633D5  eb44                     jmp 0x86341b
008633D7  8d857cffffff             lea eax, [ebp - 0x84]
008633DD  50                       push eax
008633DE  8d8d0cfdffff             lea ecx, [ebp - 0x2f4]
008633E4  e86722baff               call 0x405650
008633E9  c745fc15000000           mov dword ptr [ebp - 4], 0x15
008633F0  6a01                     push 1
008633F2  8d8d0cfdffff             lea ecx, [ebp - 0x2f4]
008633F8  51                       push ecx
008633F9  8b55e0                   mov edx, dword ptr [ebp - 0x20]
008633FC  8b02                     mov eax, dword ptr [edx]
008633FE  8b4de0                   mov ecx, dword ptr [ebp - 0x20]
00863401  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
00863407  ffd2                     call edx
00863409  c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00863410  8d8d0cfdffff             lea ecx, [ebp - 0x2f4]
00863416  e8b522baff               call 0x4056d0
0086341B  d945cc                   fld dword ptr [ebp - 0x34]
0086341E  e80db0e0ff               call 0x66e430
00863423  50                       push eax
00863424  8b4dd8                   mov ecx, dword ptr [ebp - 0x28]
00863427  e8a4252200               call 0xa859d0
0086342C  e9bdf6ffff               jmp 0x862aee
00863431  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
00863434  64890d00000000           mov dword ptr fs:[0], ecx
0086343B  59                       pop ecx
0086343C  8b4dc0                   mov ecx, dword ptr [ebp - 0x40]
0086343F  33cd                     xor ecx, ebp
00863441  e8b500e0ff               call 0x6634fb
00863446  8be5                     mov esp, ebp
00863448  5d                       pop ebp
00863449  c3                       ret
0086344A  cc                       int3
0086344B  cc                       int3
0086344C  cc                       int3
0086344D  cc                       int3
0086344E  cc                       int3
0086344F  cc                       int3

; range 0x86e527..0x86e7a4
0086E527  c78530ffffff00000000     mov dword ptr [ebp - 0xd0], 0
0086E531  8d8dc8feffff             lea ecx, [ebp - 0x138]
0086E537  51                       push ecx
0086E538  e8a330ffff               call 0x8615e0
0086E53D  8bc8                     mov ecx, eax
0086E53F  e83c1bffff               call 0x860080
0086E544  c645fc0a                 mov byte ptr [ebp - 4], 0xa
0086E548  8d9534ffffff             lea edx, [ebp - 0xcc]
0086E54E  52                       push edx
0086E54F  8d8dc8feffff             lea ecx, [ebp - 0x138]
0086E555  e8f67ac6ff               call 0x4d6050
0086E55A  eb0b                     jmp 0x86e567
0086E55C  8d8d34ffffff             lea ecx, [ebp - 0xcc]
0086E562  e83960caff               call 0x5145a0
0086E567  8d8548fdffff             lea eax, [ebp - 0x2b8]
0086E56D  50                       push eax
0086E56E  8d8dc8feffff             lea ecx, [ebp - 0x138]
0086E574  e81740c8ff               call 0x4f2590
0086E579  50                       push eax
0086E57A  8d8d34ffffff             lea ecx, [ebp - 0xcc]
0086E580  e86bd3c3ff               call 0x4ab8f0
0086E585  0fb6c8                   movzx ecx, al
0086E588  85c9                     test ecx, ecx
0086E58A  0f8482000000             je 0x86e612
0086E590  8d8d34ffffff             lea ecx, [ebp - 0xcc]
0086E596  e8a546c4ff               call 0x4b2c40
0086E59B  8b9530ffffff             mov edx, dword ptr [ebp - 0xd0]
0086E5A1  3b10                     cmp edx, dword ptr [eax]
0086E5A3  7313                     jae 0x86e5b8
0086E5A5  8d8d34ffffff             lea ecx, [ebp - 0xcc]
0086E5AB  e89046c4ff               call 0x4b2c40
0086E5B0  8b00                     mov eax, dword ptr [eax]
0086E5B2  898530ffffff             mov dword ptr [ebp - 0xd0], eax
0086E5B8  8d8d34ffffff             lea ecx, [ebp - 0xcc]
0086E5BE  e87d46c4ff               call 0x4b2c40
0086E5C3  8b4d08                   mov ecx, dword ptr [ebp + 8]
0086E5C6  8b10                     mov edx, dword ptr [eax]
0086E5C8  3b512b                   cmp edx, dword ptr [ecx + 0x2b]
0086E5CB  7540                     jne 0x86e60d
0086E5CD  8d8d34ffffff             lea ecx, [ebp - 0xcc]
0086E5D3  e8c833c7ff               call 0x4e19a0
0086E5D8  8b08                     mov ecx, dword ptr [eax]
0086E5DA  898dfcfeffff             mov dword ptr [ebp - 0x104], ecx
0086E5E0  8b5004                   mov edx, dword ptr [eax + 4]
0086E5E3  899500ffffff             mov dword ptr [ebp - 0x100], edx
0086E5E9  8b4808                   mov ecx, dword ptr [eax + 8]
0086E5EC  898d04ffffff             mov dword ptr [ebp - 0xfc], ecx
0086E5F2  8b500c                   mov edx, dword ptr [eax + 0xc]
0086E5F5  899508ffffff             mov dword ptr [ebp - 0xf8], edx
0086E5FB  8b4810                   mov ecx, dword ptr [eax + 0x10]
0086E5FE  898d0cffffff             mov dword ptr [ebp - 0xf4], ecx
0086E604  8a5014                   mov dl, byte ptr [eax + 0x14]
0086E607  889510ffffff             mov byte ptr [ebp - 0xf0], dl
0086E60D  e94affffff               jmp 0x86e55c
0086E612  8b4508                   mov eax, dword ptr [ebp + 8]
0086E615  83c02b                   add eax, 0x2b
0086E618  50                       push eax
0086E619  8d8d2cfdffff             lea ecx, [ebp - 0x2d4]
0086E61F  51                       push ecx
0086E620  e86b36baff               call 0x411c90
0086E625  83c408                   add esp, 8
0086E628  898524fbffff             mov dword ptr [ebp - 0x4dc], eax
0086E62E  8b9524fbffff             mov edx, dword ptr [ebp - 0x4dc]
0086E634  899520fbffff             mov dword ptr [ebp - 0x4e0], edx
0086E63A  c645fc0b                 mov byte ptr [ebp - 4], 0xb
0086E63E  8b8520fbffff             mov eax, dword ptr [ebp - 0x4e0]
0086E644  50                       push eax
0086E645  6820d5bb00               push 0xbbd520
0086E64A  8d8de0feffff             lea ecx, [ebp - 0x120]
0086E650  51                       push ecx
0086E651  e81a37baff               call 0x411d70
0086E656  83c40c                   add esp, 0xc
0086E659  c645fc0d                 mov byte ptr [ebp - 4], 0xd
0086E65D  8d8d2cfdffff             lea ecx, [ebp - 0x2d4]
0086E663  e86870b9ff               call 0x4056d0
0086E668  8d950dffffff             lea edx, [ebp - 0xf3]
0086E66E  52                       push edx
0086E66F  8d8510fdffff             lea eax, [ebp - 0x2f0]
0086E675  50                       push eax
0086E676  e81536baff               call 0x411c90
0086E67B  83c408                   add esp, 8
0086E67E  89851cfbffff             mov dword ptr [ebp - 0x4e4], eax
0086E684  8b8d1cfbffff             mov ecx, dword ptr [ebp - 0x4e4]
0086E68A  898d18fbffff             mov dword ptr [ebp - 0x4e8], ecx
0086E690  c645fc0e                 mov byte ptr [ebp - 4], 0xe
0086E694  8b9518fbffff             mov edx, dword ptr [ebp - 0x4e8]
0086E69A  52                       push edx
0086E69B  682452bc00               push 0xbc5224
0086E6A0  8d85f4fcffff             lea eax, [ebp - 0x30c]
0086E6A6  50                       push eax
0086E6A7  e8c436baff               call 0x411d70
0086E6AC  83c40c                   add esp, 0xc
0086E6AF  898514fbffff             mov dword ptr [ebp - 0x4ec], eax
0086E6B5  8b8d14fbffff             mov ecx, dword ptr [ebp - 0x4ec]
0086E6BB  898d10fbffff             mov dword ptr [ebp - 0x4f0], ecx
0086E6C1  c645fc0f                 mov byte ptr [ebp - 4], 0xf
0086E6C5  681452bc00               push 0xbc5214
0086E6CA  8b9510fbffff             mov edx, dword ptr [ebp - 0x4f0]
0086E6D0  52                       push edx
0086E6D1  8d8514ffffff             lea eax, [ebp - 0xec]
0086E6D7  50                       push eax
0086E6D8  e813aebaff               call 0x4194f0
0086E6DD  83c40c                   add esp, 0xc
0086E6E0  c645fc11                 mov byte ptr [ebp - 4], 0x11
0086E6E4  8d8df4fcffff             lea ecx, [ebp - 0x30c]
0086E6EA  e8e16fb9ff               call 0x4056d0
0086E6EF  c645fc12                 mov byte ptr [ebp - 4], 0x12
0086E6F3  8d8d10fdffff             lea ecx, [ebp - 0x2f0]
0086E6F9  e8d26fb9ff               call 0x4056d0
0086E6FE  8b4d08                   mov ecx, dword ptr [ebp + 8]
0086E701  8b512b                   mov edx, dword ptr [ecx + 0x2b]
0086E704  3b9530ffffff             cmp edx, dword ptr [ebp - 0xd0]
0086E70A  7510                     jne 0x86e71c
0086E70C  6800ffffff               push 0xffffff00
0086E711  8b8d3cffffff             mov ecx, dword ptr [ebp - 0xc4]
0086E717  e8343cc4ff               call 0x4b2350
0086E71C  6a01                     push 1
0086E71E  8d85e0feffff             lea eax, [ebp - 0x120]
0086E724  50                       push eax
0086E725  8b8d3cffffff             mov ecx, dword ptr [ebp - 0xc4]
0086E72B  8b11                     mov edx, dword ptr [ecx]
0086E72D  8b8d3cffffff             mov ecx, dword ptr [ebp - 0xc4]
0086E733  8b82d4000000             mov eax, dword ptr [edx + 0xd4]
0086E739  ffd0                     call eax
0086E73B  6a01                     push 1
0086E73D  8b8d44ffffff             mov ecx, dword ptr [ebp - 0xbc]
0086E743  e8e8c2eeff               call 0x75aa30
0086E748  6800ff00ff               push 0xff00ff00
0086E74D  8b8d44ffffff             mov ecx, dword ptr [ebp - 0xbc]
0086E753  e8f83bc4ff               call 0x4b2350
0086E758  6a01                     push 1
0086E75A  8d8d14ffffff             lea ecx, [ebp - 0xec]
0086E760  51                       push ecx
0086E761  8b9544ffffff             mov edx, dword ptr [ebp - 0xbc]
0086E767  8b02                     mov eax, dword ptr [edx]
0086E769  8b8d44ffffff             mov ecx, dword ptr [ebp - 0xbc]
0086E76F  8b90d4000000             mov edx, dword ptr [eax + 0xd4]
0086E775  ffd2                     call edx
0086E777  c645fc0d                 mov byte ptr [ebp - 4], 0xd
0086E77B  8d8d14ffffff             lea ecx, [ebp - 0xec]
0086E781  e84a6fb9ff               call 0x4056d0
0086E786  c645fc0a                 mov byte ptr [ebp - 4], 0xa
0086E78A  8d8de0feffff             lea ecx, [ebp - 0x120]
0086E790  e83b6fb9ff               call 0x4056d0
0086E795  c645fc00                 mov byte ptr [ebp - 4], 0
0086E799  8d8dc8feffff             lea ecx, [ebp - 0x138]
0086E79F  e8dc5dcaff               call 0x514580
