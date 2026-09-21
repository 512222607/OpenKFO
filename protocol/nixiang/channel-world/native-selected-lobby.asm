; Current PE VA; sha256=98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
00910510 55                       push ebp
00910511 8bec                     mov ebp, esp
00910513 6aff                     push -1
00910515 68d224ac00               push 0xac24d2
0091051A 64a100000000             mov eax, dword ptr fs:[0]
00910520 50                       push eax
00910521 81eca4000000             sub esp, 0xa4
00910527 a180b4c700               mov eax, dword ptr [0xc7b480]
0091052C 33c5                     xor eax, ebp
0091052E 8945f0                   mov dword ptr [ebp - 0x10], eax
00910531 50                       push eax
00910532 8d45f4                   lea eax, [ebp - 0xc]
00910535 64a300000000             mov dword ptr fs:[0], eax
0091053B 898d64ffffff             mov dword ptr [ebp - 0x9c], ecx
00910541 833d14877c0100           cmp dword ptr [0x17c8714], 0
00910548 7412                     je 0x91055c
0091054A a114877c01               mov eax, dword ptr [0x17c8714]
0091054F 50                       push eax
00910550 e8ebe2d2ff               call 0x63e840
00910555 8bc8                     mov ecx, eax
00910557 e824e2d2ff               call 0x63e780
0091055C 6a00                     push 0
0091055E 8b4d0c                   mov ecx, dword ptr [ebp + 0xc]
00910561 51                       push ecx
00910562 8b5508                   mov edx, dword ptr [ebp + 8]
00910565 52                       push edx
00910566 e815e1d2ff               call 0x63e680
0091056B 83c40c                   add esp, 0xc
0091056E a314877c01               mov dword ptr [0x17c8714], eax
00910573 833d14877c0100           cmp dword ptr [0x17c8714], 0
0091057A 7560                     jne 0x9105dc
0091057C 681020bb00               push 0xbb2010
00910581 8d8d70ffffff             lea ecx, [ebp - 0x90]
00910587 e8c450afff               call 0x405650
0091058C c745fc00000000           mov dword ptr [ebp - 4], 0
00910593 e88832afff               call 0x403820
00910598 898560ffffff             mov dword ptr [ebp - 0xa0], eax
0091059E 6a00                     push 0
009105A0 6a00                     push 0
009105A2 6a00                     push 0
009105A4 8d8570ffffff             lea eax, [ebp - 0x90]
009105AA 50                       push eax
009105AB 8b8d60ffffff             mov ecx, dword ptr [ebp - 0xa0]
009105B1 8b11                     mov edx, dword ptr [ecx]
009105B3 8b8d60ffffff             mov ecx, dword ptr [ebp - 0xa0]
009105B9 8b82c0010000             mov eax, dword ptr [edx + 0x1c0]
009105BF ffd0                     call eax
009105C1 c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
009105C8 8d8d70ffffff             lea ecx, [ebp - 0x90]
009105CE e8fd50afff               call 0x4056d0
009105D3 33c0                     xor eax, eax
009105D5 e992010000               jmp 0x91076c
009105DA eb0a                     jmp 0x9105e6
009105DC c705a4867c0100000000     mov dword ptr [0x17c86a4], 0
009105E6 8b0d14877c01             mov ecx, dword ptr [0x17c8714]
009105EC 51                       push ecx
009105ED e85ec41200               call 0xa3ca50
009105F2 83c404                   add esp, 4
009105F5 6a60                     push 0x60
009105F7 6a00                     push 0
009105F9 8d558c                   lea edx, [ebp - 0x74]
009105FC 52                       push edx
009105FD e85e63d5ff               call 0x666960
00910602 83c40c                   add esp, 0xc
00910605 8b0dfc867c01             mov ecx, dword ptr [0x17c86fc]
0091060B e89024afff               call 0x402aa0
00910610 89458c                   mov dword ptr [ebp - 0x74], eax
00910613 895590                   mov dword ptr [ebp - 0x70], edx
00910616 a118a77b01               mov eax, dword ptr [0x17ba718]
0091061B 894598                   mov dword ptr [ebp - 0x68], eax
0091061E 8b4d10                   mov ecx, dword ptr [ebp + 0x10]
00910621 894d94                   mov dword ptr [ebp - 0x6c], ecx
00910624 8d956cffffff             lea edx, [ebp - 0x94]
0091062A 52                       push edx
0091062B 8b0dfc867c01             mov ecx, dword ptr [0x17c86fc]
00910631 e80a5cb0ff               call 0x416240
00910636 89855cffffff             mov dword ptr [ebp - 0xa4], eax
0091063C 8b855cffffff             mov eax, dword ptr [ebp - 0xa4]
00910642 898558ffffff             mov dword ptr [ebp - 0xa8], eax
00910648 c745fc01000000           mov dword ptr [ebp - 4], 1
0091064F 6a14                     push 0x14
00910651 8b8d58ffffff             mov ecx, dword ptr [ebp - 0xa8]
00910657 e8b45dafff               call 0x406410
0091065C 50                       push eax
0091065D 6a15                     push 0x15
0091065F 8d4dd5                   lea ecx, [ebp - 0x2b]
00910662 51                       push ecx
00910663 e87ba3d5ff               call 0x66a9e3
00910668 83c410                   add esp, 0x10
0091066B c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00910672 8d8d6cffffff             lea ecx, [ebp - 0x94]
00910678 e8d359afff               call 0x406050
0091067D c645e900                 mov byte ptr [ebp - 0x17], 0
00910681 8b15f484b600             mov edx, dword ptr [0xb684f4]
00910687 8955bd                   mov dword ptr [ebp - 0x43], edx
0091068A 6a00                     push 0
0091068C 8d8568ffffff             lea eax, [ebp - 0x98]
00910692 50                       push eax
00910693 e818d31200               call 0xa3d9b0
00910698 83c408                   add esp, 8
0091069B 898554ffffff             mov dword ptr [ebp - 0xac], eax
009106A1 8b8d54ffffff             mov ecx, dword ptr [ebp - 0xac]
009106A7 898d50ffffff             mov dword ptr [ebp - 0xb0], ecx
009106AD c745fc02000000           mov dword ptr [ebp - 4], 2
009106B4 6a14                     push 0x14
009106B6 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
009106BC e84f5dafff               call 0x406410
009106C1 50                       push eax
009106C2 8d55c1                   lea edx, [ebp - 0x3f]
009106C5 52                       push edx
009106C6 e8d52fd5ff               call 0x6636a0
009106CB 83c40c                   add esp, 0xc
009106CE c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
009106D5 8d8d68ffffff             lea ecx, [ebp - 0x98]
009106DB e87059afff               call 0x406050
009106E0 6a20                     push 0x20
009106E2 8d459d                   lea eax, [ebp - 0x63]
009106E5 50                       push eax
009106E6 e8d52bafff               call 0x4032c0
009106EB 8bc8                     mov ecx, eax
009106ED e88e310000               call 0x913880
009106F2 88459c                   mov byte ptr [ebp - 0x64], al
009106F5 c645ea00                 mov byte ptr [ebp - 0x16], 0
009106F9 8b0df8867c01             mov ecx, dword ptr [0x17c86f8]
009106FF e85cd4bdff               call 0x4edb60
00910704 8845eb                   mov byte ptr [ebp - 0x15], al
00910707 837d1800                 cmp dword ptr [ebp + 0x18], 0
0091070B 7417                     je 0x910724
0091070D 6a60                     push 0x60
0091070F 8d4d8c                   lea ecx, [ebp - 0x74]
00910712 51                       push ecx
00910713 6a00                     push 0
00910715 68da070000               push 0x7da
0091071A e831c21200               call 0xa3c950
0091071F 83c410                   add esp, 0x10
00910722 eb15                     jmp 0x910739
00910724 6a60                     push 0x60
00910726 8d558c                   lea edx, [ebp - 0x74]
00910729 52                       push edx
0091072A 6a00                     push 0
0091072C 68f2030000               push 0x3f2
00910731 e81ac21200               call 0xa3c950
00910736 83c410                   add esp, 0x10
00910739 8b8564ffffff             mov eax, dword ptr [ebp - 0x9c]
0091073F c7807c01000000000000     mov dword ptr [eax + 0x17c], 0
00910749 8b8d64ffffff             mov ecx, dword ptr [ebp - 0x9c]
0091074F 8b5510                   mov edx, dword ptr [ebp + 0x10]
00910752 899130010000             mov dword ptr [ecx + 0x130], edx
00910758 8b8564ffffff             mov eax, dword ptr [ebp - 0x9c]
0091075E 8b4d14                   mov ecx, dword ptr [ebp + 0x14]
00910761 898804010000             mov dword ptr [eax + 0x104], ecx
00910767 b801000000               mov eax, 1
0091076C 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0091076F 64890d00000000           mov dword ptr fs:[0], ecx
00910776 59                       pop ecx
00910777 8b4df0                   mov ecx, dword ptr [ebp - 0x10]
0091077A 33cd                     xor ecx, ebp
0091077C e87a2dd5ff               call 0x6634fb
00910781 8be5                     mov esp, ebp
00910783 5d                       pop ebp
00910C00 55                       push ebp
00910C01 8bec                     mov ebp, esp
00910C03 6aff                     push -1
00910C05 688425ac00               push 0xac2584
00910C0A 64a100000000             mov eax, dword ptr fs:[0]
00910C10 50                       push eax
00910C11 81ecb4000000             sub esp, 0xb4
00910C17 a180b4c700               mov eax, dword ptr [0xc7b480]
00910C1C 33c5                     xor eax, ebp
00910C1E 50                       push eax
00910C1F 8d45f4                   lea eax, [ebp - 0xc]
00910C22 64a300000000             mov dword ptr fs:[0], eax
00910C28 898d50ffffff             mov dword ptr [ebp - 0xb0], ecx
00910C2E b924947c01               mov ecx, 0x17c9424
00910C33 e87840bbff               call 0x4c4cb0
00910C38 85c0                     test eax, eax
00910C3A 7553                     jne 0x910c8f
00910C3C 68c022bb00               push 0xbb22c0
00910C41 8d4dbc                   lea ecx, [ebp - 0x44]
00910C44 e8074aafff               call 0x405650
00910C49 c745fc00000000           mov dword ptr [ebp - 4], 0
00910C50 e8cb2bafff               call 0x403820
00910C55 89854cffffff             mov dword ptr [ebp - 0xb4], eax
00910C5B 6a00                     push 0
00910C5D 6a00                     push 0
00910C5F 6a00                     push 0
00910C61 8d45bc                   lea eax, [ebp - 0x44]
00910C64 50                       push eax
00910C65 8b8d4cffffff             mov ecx, dword ptr [ebp - 0xb4]
00910C6B 8b11                     mov edx, dword ptr [ecx]
00910C6D 8b8d4cffffff             mov ecx, dword ptr [ebp - 0xb4]
00910C73 8b82c0010000             mov eax, dword ptr [edx + 0x1c0]
00910C79 ffd0                     call eax
00910C7B c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00910C82 8d4dbc                   lea ecx, [ebp - 0x44]
00910C85 e8464aafff               call 0x4056d0
00910C8A e920030000               jmp 0x910faf
00910C8F 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910C95 8b550c                   mov edx, dword ptr [ebp + 0xc]
00910C98 8991c8010000             mov dword ptr [ecx + 0x1c8], edx
00910C9E 0fb64508                 movzx eax, byte ptr [ebp + 8]
00910CA2 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910CA8 89810c010000             mov dword ptr [ecx + 0x10c], eax
00910CAE c745e400000000           mov dword ptr [ebp - 0x1c], 0
00910CB5 837d0c00                 cmp dword ptr [ebp + 0xc], 0
00910CB9 7532                     jne 0x910ced
00910CBB 0fb65508                 movzx edx, byte ptr [ebp + 8]
00910CBF 85d2                     test edx, edx
00910CC1 7c1c                     jl 0x910cdf
00910CC3 0fb64508                 movzx eax, byte ptr [ebp + 8]
00910CC7 83f81e                   cmp eax, 0x1e
00910CCA 7d13                     jge 0x910cdf
00910CCC 0fb64d08                 movzx ecx, byte ptr [ebp + 8]
00910CD0 8b9550ffffff             mov edx, dword ptr [ebp - 0xb0]
00910CD6 8b448a14                 mov eax, dword ptr [edx + ecx*4 + 0x14]
00910CDA 8945e4                   mov dword ptr [ebp - 0x1c], eax
00910CDD eb0c                     jmp 0x910ceb
00910CDF 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910CE5 8b5114                   mov edx, dword ptr [ecx + 0x14]
00910CE8 8955e4                   mov dword ptr [ebp - 0x1c], edx
00910CEB eb3c                     jmp 0x910d29
00910CED 837d0c01                 cmp dword ptr [ebp + 0xc], 1
00910CF1 7536                     jne 0x910d29
00910CF3 0fb64508                 movzx eax, byte ptr [ebp + 8]
00910CF7 85c0                     test eax, eax
00910CF9 7c1f                     jl 0x910d1a
00910CFB 0fb64d08                 movzx ecx, byte ptr [ebp + 8]
00910CFF 83f91e                   cmp ecx, 0x1e
00910D02 7d16                     jge 0x910d1a
00910D04 0fb65508                 movzx edx, byte ptr [ebp + 8]
00910D08 8b8550ffffff             mov eax, dword ptr [ebp - 0xb0]
00910D0E 8b8c908c000000           mov ecx, dword ptr [eax + edx*4 + 0x8c]
00910D15 894de4                   mov dword ptr [ebp - 0x1c], ecx
00910D18 eb0f                     jmp 0x910d29
00910D1A 8b9550ffffff             mov edx, dword ptr [ebp - 0xb0]
00910D20 8b828c000000             mov eax, dword ptr [edx + 0x8c]
00910D26 8945e4                   mov dword ptr [ebp - 0x1c], eax
00910D29 837de400                 cmp dword ptr [ebp - 0x1c], 0
00910D2D 7553                     jne 0x910d82
00910D2F 68d822bb00               push 0xbb22d8
00910D34 8d4da0                   lea ecx, [ebp - 0x60]
00910D37 e81449afff               call 0x405650
00910D3C c745fc01000000           mov dword ptr [ebp - 4], 1
00910D43 e8d82aafff               call 0x403820
00910D48 898548ffffff             mov dword ptr [ebp - 0xb8], eax
00910D4E 6a00                     push 0
00910D50 6a00                     push 0
00910D52 6a00                     push 0
00910D54 8d4da0                   lea ecx, [ebp - 0x60]
00910D57 51                       push ecx
00910D58 8b9548ffffff             mov edx, dword ptr [ebp - 0xb8]
00910D5E 8b02                     mov eax, dword ptr [edx]
00910D60 8b8d48ffffff             mov ecx, dword ptr [ebp - 0xb8]
00910D66 8b90c0010000             mov edx, dword ptr [eax + 0x1c0]
00910D6C ffd2                     call edx
00910D6E c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00910D75 8d4da0                   lea ecx, [ebp - 0x60]
00910D78 e85349afff               call 0x4056d0
00910D7D e92d020000               jmp 0x910faf
00910D82 8d45e4                   lea eax, [ebp - 0x1c]
00910D85 50                       push eax
00910D86 8d4dec                   lea ecx, [ebp - 0x14]
00910D89 51                       push ecx
00910D8A b944947c01               mov ecx, 0x17c9444
00910D8F e83ccfbdff               call 0x4edcd0
00910D94 c745e800000000           mov dword ptr [ebp - 0x18], 0
00910D9B c745e000000000           mov dword ptr [ebp - 0x20], 0
00910DA2 8d5598                   lea edx, [ebp - 0x68]
00910DA5 52                       push edx
00910DA6 b944947c01               mov ecx, 0x17c9444
00910DAB e8009eb4ff               call 0x45abb0
00910DB0 50                       push eax
00910DB1 8d4dec                   lea ecx, [ebp - 0x14]
00910DB4 e837abb9ff               call 0x4ab8f0
00910DB9 0fb6c0                   movzx eax, al
00910DBC 85c0                     test eax, eax
00910DBE 0f8492000000             je 0x910e56
00910DC4 8d4dec                   lea ecx, [ebp - 0x14]
00910DC7 e8e4f7b1ff               call 0x4305b0
00910DCC 83c008                   add eax, 8
00910DCF 50                       push eax
00910DD0 8d4d94                   lea ecx, [ebp - 0x6c]
00910DD3 e8f851afff               call 0x405fd0
00910DD8 c745fc02000000           mov dword ptr [ebp - 4], 2
00910DDF 8d4d94                   lea ecx, [ebp - 0x6c]
00910DE2 51                       push ecx
00910DE3 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910DE9 e8d2f5ffff               call 0x9103c0
00910DEE c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00910DF5 8d4d94                   lea ecx, [ebp - 0x6c]
00910DF8 e85352afff               call 0x406050
00910DFD 8d4dec                   lea ecx, [ebp - 0x14]
00910E00 e8abf7b1ff               call 0x4305b0
00910E05 8b5004                   mov edx, dword ptr [eax + 4]
00910E08 8955e8                   mov dword ptr [ebp - 0x18], edx
00910E0B 8d4dec                   lea ecx, [ebp - 0x14]
00910E0E e89df7b1ff               call 0x4305b0
00910E13 8b4021                   mov eax, dword ptr [eax + 0x21]
00910E16 8945e0                   mov dword ptr [ebp - 0x20], eax
00910E19 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910E1F 83b90401000000           cmp dword ptr [ecx + 0x104], 0
00910E26 742c                     je 0x910e54
00910E28 8b9550ffffff             mov edx, dword ptr [ebp - 0xb0]
00910E2E 8b8204010000             mov eax, dword ptr [edx + 0x104]
00910E34 3b45e0                   cmp eax, dword ptr [ebp - 0x20]
00910E37 741b                     je 0x910e54
00910E39 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910E3F e84cf9ffff               call 0x910790
00910E44 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910E4A c7817801000001000000     mov dword ptr [ecx + 0x178], 1
00910E54 eb5c                     jmp 0x910eb2
00910E56 682423bb00               push 0xbb2324
00910E5B 8d8d78ffffff             lea ecx, [ebp - 0x88]
00910E61 e8ea47afff               call 0x405650
00910E66 c745fc03000000           mov dword ptr [ebp - 4], 3
00910E6D e8ae29afff               call 0x403820
00910E72 898544ffffff             mov dword ptr [ebp - 0xbc], eax
00910E78 6a00                     push 0
00910E7A 6a00                     push 0
00910E7C 6a00                     push 0
00910E7E 8d9578ffffff             lea edx, [ebp - 0x88]
00910E84 52                       push edx
00910E85 8b8544ffffff             mov eax, dword ptr [ebp - 0xbc]
00910E8B 8b10                     mov edx, dword ptr [eax]
00910E8D 8b8d44ffffff             mov ecx, dword ptr [ebp - 0xbc]
00910E93 8b82c0010000             mov eax, dword ptr [edx + 0x1c0]
00910E99 ffd0                     call eax
00910E9B c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00910EA2 8d8d78ffffff             lea ecx, [ebp - 0x88]
00910EA8 e82348afff               call 0x4056d0
00910EAD e9fd000000               jmp 0x910faf
00910EB2 8d4de0                   lea ecx, [ebp - 0x20]
00910EB5 51                       push ecx
00910EB6 8d55d8                   lea edx, [ebp - 0x28]
00910EB9 52                       push edx
00910EBA b924947c01               mov ecx, 0x17c9424
00910EBF e80ccfbdff               call 0x4eddd0
00910EC4 8d8570ffffff             lea eax, [ebp - 0x90]
00910ECA 50                       push eax
00910ECB b924947c01               mov ecx, 0x17c9424
00910ED0 e8db9cb4ff               call 0x45abb0
00910ED5 50                       push eax
00910ED6 8d4dd8                   lea ecx, [ebp - 0x28]
00910ED9 e842aab9ff               call 0x4ab920
00910EDE 0fb6c8                   movzx ecx, al
00910EE1 85c9                     test ecx, ecx
00910EE3 7459                     je 0x910f3e
00910EE5 682423bb00               push 0xbb2324
00910EEA 8d8d54ffffff             lea ecx, [ebp - 0xac]
00910EF0 e85b47afff               call 0x405650
00910EF5 c745fc04000000           mov dword ptr [ebp - 4], 4
00910EFC e81f29afff               call 0x403820
00910F01 898540ffffff             mov dword ptr [ebp - 0xc0], eax
00910F07 6a00                     push 0
00910F09 6a00                     push 0
00910F0B 6a00                     push 0
00910F0D 8d9554ffffff             lea edx, [ebp - 0xac]
00910F13 52                       push edx
00910F14 8b8540ffffff             mov eax, dword ptr [ebp - 0xc0]
00910F1A 8b10                     mov edx, dword ptr [eax]
00910F1C 8b8d40ffffff             mov ecx, dword ptr [ebp - 0xc0]
00910F22 8b82c0010000             mov eax, dword ptr [edx + 0x1c0]
00910F28 ffd0                     call eax
00910F2A c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00910F31 8d8d54ffffff             lea ecx, [ebp - 0xac]
00910F37 e89447afff               call 0x4056d0
00910F3C eb71                     jmp 0x910faf
00910F3E 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910F44 83b90401000000           cmp dword ptr [ecx + 0x104], 0
00910F4B 7434                     je 0x910f81
00910F4D 8b9550ffffff             mov edx, dword ptr [ebp - 0xb0]
00910F53 8b8204010000             mov eax, dword ptr [edx + 0x104]
00910F59 3b45e0                   cmp eax, dword ptr [ebp - 0x20]
00910F5C 7523                     jne 0x910f81
00910F5E 833d14877c0100           cmp dword ptr [0x17c8714], 0
00910F65 741a                     je 0x910f81
00910F67 8b0d14877c01             mov ecx, dword ptr [0x17c8714]
00910F6D 8b11                     mov edx, dword ptr [ecx]
00910F6F 8b0d14877c01             mov ecx, dword ptr [0x17c8714]
00910F75 8b420c                   mov eax, dword ptr [edx + 0xc]
00910F78 ffd0                     call eax
00910F7A 0fb6c8                   movzx ecx, al
00910F7D 85c9                     test ecx, ecx
00910F7F 742e                     je 0x910faf
00910F81 6a01                     push 1
00910F83 8b55e0                   mov edx, dword ptr [ebp - 0x20]
00910F86 52                       push edx
00910F87 8b45e8                   mov eax, dword ptr [ebp - 0x18]
00910F8A 50                       push eax
00910F8B 8d4dd8                   lea ecx, [ebp - 0x28]
00910F8E e81df6b1ff               call 0x4305b0
00910F93 0fb74808                 movzx ecx, word ptr [eax + 8]
00910F97 51                       push ecx
00910F98 8d4dd8                   lea ecx, [ebp - 0x28]
00910F9B e810f6b1ff               call 0x4305b0
00910FA0 83c00a                   add eax, 0xa
00910FA3 50                       push eax
00910FA4 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
00910FAA e861f5ffff               call 0x910510
