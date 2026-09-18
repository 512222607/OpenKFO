009C69C0  55                       push ebp
009C69C1  8bec                     mov ebp, esp
009C69C3  81ec88000000             sub esp, 0x88
009C69C9  56                       push esi
009C69CA  57                       push edi
009C69CB  894d90                   mov dword ptr [ebp - 0x70], ecx
009C69CE  8b4508                   mov eax, dword ptr [ebp + 8]
009C69D1  8b08                     mov ecx, dword ptr [eax]
009C69D3  51                       push ecx
009C69D4  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C69D7  e804e2ffff               call 0x9c4be0
009C69DC  85c0                     test eax, eax
009C69DE  7407                     je 0x9c69e7
009C69E0  33c0                     xor eax, eax
009C69E2  e98e020000               jmp 0x9c6c75
009C69E7  c745f000000000           mov dword ptr [ebp - 0x10], 0
009C69EE  8b7508                   mov esi, dword ptr [ebp + 8]
009C69F1  b908000000               mov ecx, 8
009C69F6  8d7dd0                   lea edi, [ebp - 0x30]
009C69F9  f3a5                     rep movsd dword ptr es:[edi], dword ptr [esi]
009C69FB  8d55d0                   lea edx, [ebp - 0x30]
009C69FE  52                       push edx
009C69FF  8d45f8                   lea eax, [ebp - 8]
009C6A02  50                       push eax
009C6A03  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6A06  83c104                   add ecx, 4
009C6A09  e8d20da7ff               call 0x4377e0
009C6A0E  8d4db0                   lea ecx, [ebp - 0x50]
009C6A11  51                       push ecx
009C6A12  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6A15  83c104                   add ecx, 4
009C6A18  e89341a9ff               call 0x45abb0
009C6A1D  50                       push eax
009C6A1E  8d4df8                   lea ecx, [ebp - 8]
009C6A21  e8fa4eaeff               call 0x4ab920
009C6A26  0fb6d0                   movzx edx, al
009C6A29  85d2                     test edx, edx
009C6A2B  7473                     je 0x9c6aa0
009C6A2D  8b45d0                   mov eax, dword ptr [ebp - 0x30]
009C6A30  50                       push eax
009C6A31  e82aa30a00               call 0xa70d60
009C6A36  8bc8                     mov ecx, eax
009C6A38  e8d3800a00               call 0xa6eb10
009C6A3D  8945cc                   mov dword ptr [ebp - 0x34], eax
009C6A40  837dcc00                 cmp dword ptr [ebp - 0x34], 0
009C6A44  7507                     jne 0x9c6a4d
009C6A46  33c0                     xor eax, eax
009C6A48  e928020000               jmp 0x9c6c75
009C6A4D  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009C6A50  51                       push ecx
009C6A51  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6A54  e8d7f2ffff               call 0x9c5d30
009C6A59  8945f0                   mov dword ptr [ebp - 0x10], eax
009C6A5C  837df000                 cmp dword ptr [ebp - 0x10], 0
009C6A60  7507                     jne 0x9c6a69
009C6A62  33c0                     xor eax, eax
009C6A64  e90c020000               jmp 0x9c6c75
009C6A69  8b55f0                   mov edx, dword ptr [ebp - 0x10]
009C6A6C  52                       push edx
009C6A6D  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
009C6A70  e80bbaa9ff               call 0x462480
009C6A75  50                       push eax
009C6A76  8d45a0                   lea eax, [ebp - 0x60]
009C6A79  50                       push eax
009C6A7A  e8f170b5ff               call 0x51db70
009C6A7F  83c40c                   add esp, 0xc
009C6A82  50                       push eax
009C6A83  8d4da8                   lea ecx, [ebp - 0x58]
009C6A86  e8559cafff               call 0x4c06e0
009C6A8B  8d4da8                   lea ecx, [ebp - 0x58]
009C6A8E  51                       push ecx
009C6A8F  8d5594                   lea edx, [ebp - 0x6c]
009C6A92  52                       push edx
009C6A93  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6A96  83c104                   add ecx, 4
009C6A99  e8720ba7ff               call 0x437610
009C6A9E  eb0e                     jmp 0x9c6aae
009C6AA0  8d4df8                   lea ecx, [ebp - 8]
009C6AA3  e8089ba6ff               call 0x4305b0
009C6AA8  8b4004                   mov eax, dword ptr [eax + 4]
009C6AAB  8945f0                   mov dword ptr [ebp - 0x10], eax
009C6AAE  837df000                 cmp dword ptr [ebp - 0x10], 0
009C6AB2  7507                     jne 0x9c6abb
009C6AB4  33c0                     xor eax, eax
009C6AB6  e9ba010000               jmp 0x9c6c75
009C6ABB  c745e801000000           mov dword ptr [ebp - 0x18], 1
009C6AC2  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6AC5  8b09                     mov ecx, dword ptr [ecx]
009C6AC7  e8a476a8ff               call 0x44e170
009C6ACC  dc1d6883be00             fcomp qword ptr [0xbe8368]
009C6AD2  dfe0                     fnstsw ax
009C6AD4  f6c444                   test ah, 0x44
009C6AD7  7b13                     jnp 0x9c6aec
009C6AD9  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
009C6ADC  e82fe7a9ff               call 0x465210
009C6AE1  85c0                     test eax, eax
009C6AE3  7507                     jne 0x9c6aec
009C6AE5  33c0                     xor eax, eax
009C6AE7  e989010000               jmp 0x9c6c75
009C6AEC  8b55d0                   mov edx, dword ptr [ebp - 0x30]
009C6AEF  52                       push edx
009C6AF0  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6AF3  e868e4ffff               call 0x9c4f60
009C6AF8  8945f4                   mov dword ptr [ebp - 0xc], eax
009C6AFB  837df400                 cmp dword ptr [ebp - 0xc], 0
009C6AFF  7456                     je 0x9c6b57
009C6B01  8b45f4                   mov eax, dword ptr [ebp - 0xc]
009C6B04  83780801                 cmp dword ptr [eax + 8], 1
009C6B08  754d                     jne 0x9c6b57
009C6B0A  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
009C6B0D  d94104                   fld dword ptr [ecx + 4]
009C6B10  dc1d6883be00             fcomp qword ptr [0xbe8368]
009C6B16  dfe0                     fnstsw ax
009C6B18  f6c444                   test ah, 0x44
009C6B1B  7b3a                     jnp 0x9c6b57
009C6B1D  8b55d8                   mov edx, dword ptr [ebp - 0x28]
009C6B20  895588                   mov dword ptr [ebp - 0x78], edx
009C6B23  c7458c00000000           mov dword ptr [ebp - 0x74], 0
009C6B2A  df6d88                   fild qword ptr [ebp - 0x78]
009C6B2D  8b45f4                   mov eax, dword ptr [ebp - 0xc]
009C6B30  d84804                   fmul dword ptr [eax + 4]
009C6B33  d97d86                   fnstcw word ptr [ebp - 0x7a]
009C6B36  0fb74586                 movzx eax, word ptr [ebp - 0x7a]
009C6B3A  0d000c0000               or eax, 0xc00
009C6B3F  894580                   mov dword ptr [ebp - 0x80], eax
009C6B42  d96d80                   fldcw word ptr [ebp - 0x80]
009C6B45  dfbd78ffffff             fistp qword ptr [ebp - 0x88]
009C6B4B  d96d86                   fldcw word ptr [ebp - 0x7a]
009C6B4E  8b8d78ffffff             mov ecx, dword ptr [ebp - 0x88]
009C6B54  894dd8                   mov dword ptr [ebp - 0x28], ecx
009C6B57  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
009C6B5A  e8f1d3a8ff               call 0x453f50
009C6B5F  85c0                     test eax, eax
009C6B61  7417                     je 0x9c6b7a
009C6B63  8d55d0                   lea edx, [ebp - 0x30]
009C6B66  52                       push edx
009C6B67  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
009C6B6A  e8c1560000               call 0x9cc230
009C6B6F  85c0                     test eax, eax
009C6B71  7507                     jne 0x9c6b7a
009C6B73  33c0                     xor eax, eax
009C6B75  e9fb000000               jmp 0x9c6c75
009C6B7A  8b0d10877c01             mov ecx, dword ptr [0x17c8710]
009C6B80  e84bf0fbff               call 0x985bd0
009C6B85  0345d8                   add eax, dword ptr [ebp - 0x28]
009C6B88  8945d8                   mov dword ptr [ebp - 0x28], eax
009C6B8B  8b450c                   mov eax, dword ptr [ebp + 0xc]
009C6B8E  50                       push eax
009C6B8F  8d4dd0                   lea ecx, [ebp - 0x30]
009C6B92  51                       push ecx
009C6B93  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
009C6B96  e835510000               call 0x9cbcd0
009C6B9B  85c0                     test eax, eax
009C6B9D  0f84d0000000             je 0x9c6c73
009C6BA3  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
009C6BA6  e8e5e5a9ff               call 0x465190
009C6BAB  8b10                     mov edx, dword ptr [eax]
009C6BAD  8955b8                   mov dword ptr [ebp - 0x48], edx
009C6BB0  8b4804                   mov ecx, dword ptr [eax + 4]
009C6BB3  894dbc                   mov dword ptr [ebp - 0x44], ecx
009C6BB6  8b5008                   mov edx, dword ptr [eax + 8]
009C6BB9  8955c0                   mov dword ptr [ebp - 0x40], edx
009C6BBC  8b480c                   mov ecx, dword ptr [eax + 0xc]
009C6BBF  894dc4                   mov dword ptr [ebp - 0x3c], ecx
009C6BC2  8b5010                   mov edx, dword ptr [eax + 0x10]
009C6BC5  8955c8                   mov dword ptr [ebp - 0x38], edx
009C6BC8  837db802                 cmp dword ptr [ebp - 0x48], 2
009C6BCC  746a                     je 0x9c6c38
009C6BCE  837db803                 cmp dword ptr [ebp - 0x48], 3
009C6BD2  0f858c000000             jne 0x9c6c64
009C6BD8  8b4590                   mov eax, dword ptr [ebp - 0x70]
009C6BDB  8b08                     mov ecx, dword ptr [eax]
009C6BDD  e85ea4a3ff               call 0x401040
009C6BE2  8bc8                     mov ecx, eax
009C6BE4  e88791b4ff               call 0x50fd70
009C6BE9  8bc8                     mov ecx, eax
009C6BEB  e840e3a5ff               call 0x424f30
009C6BF0  8138b80b0000             cmp dword ptr [eax], 0xbb8
009C6BF6  7e20                     jle 0x9c6c18
009C6BF8  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6BFB  8b09                     mov ecx, dword ptr [ecx]
009C6BFD  e83ea4a3ff               call 0x401040
009C6C02  8bc8                     mov ecx, eax
009C6C04  e86791b4ff               call 0x50fd70
009C6C09  8bc8                     mov ecx, eax
009C6C0B  e820e3a5ff               call 0x424f30
009C6C10  8138c80b0000             cmp dword ptr [eax], 0xbc8
009C6C16  7c4c                     jl 0x9c6c64
009C6C18  8b5590                   mov edx, dword ptr [ebp - 0x70]
009C6C1B  8b0a                     mov ecx, dword ptr [edx]
009C6C1D  e81ea4a3ff               call 0x401040
009C6C22  8bc8                     mov ecx, eax
009C6C24  e84791b4ff               call 0x50fd70
009C6C29  8bc8                     mov ecx, eax
009C6C2B  e800e3a5ff               call 0x424f30
009C6C30  8138a10f0000             cmp dword ptr [eax], 0xfa1
009C6C36  742c                     je 0x9c6c64
009C6C38  8b45c0                   mov eax, dword ptr [ebp - 0x40]
009C6C3B  50                       push eax
009C6C3C  68c70b0000               push 0xbc7
009C6C41  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6C44  8b11                     mov edx, dword ptr [ecx]
009C6C46  52                       push edx
009C6C47  8b4590                   mov eax, dword ptr [ebp - 0x70]
009C6C4A  8b08                     mov ecx, dword ptr [eax]
009C6C4C  e8efa3a3ff               call 0x401040
009C6C51  8bc8                     mov ecx, eax
009C6C53  e888700100               call 0x9ddce0
009C6C58  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6C5B  8b55c8                   mov edx, dword ptr [ebp - 0x38]
009C6C5E  899184000000             mov dword ptr [ecx + 0x84], edx
009C6C64  8b4d90                   mov ecx, dword ptr [ebp - 0x70]
009C6C67  e8e4eaffff               call 0x9c5750
009C6C6C  b801000000               mov eax, 1
009C6C71  eb02                     jmp 0x9c6c75
009C6C73  33c0                     xor eax, eax
009C6C75  5f                       pop edi
009C6C76  5e                       pop esi
009C6C77  8be5                     mov esp, ebp
009C6C79  5d                       pop ebp
009C6C7A  c20800                   ret 8
