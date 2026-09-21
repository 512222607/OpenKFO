; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Static evidence; addresses belong only to this verified client.
; RANGE 0x98aff0
0098AFF0 55                       push ebp
0098AFF1 8bec                     mov ebp, esp
0098AFF3 81ec90000000             sub esp, 0x90
0098AFF9 898d70ffffff             mov dword ptr [ebp - 0x90], ecx
0098AFFF 8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0098B005 e816e1e8ff               call 0x819120
0098B00A 85c0                     test eax, eax
0098B00C 0f84be020000             je 0x98b2d0
0098B012 8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0098B018 e803e1e8ff               call 0x819120
0098B01D 8bc8                     mov ecx, eax
0098B01F e8cc03acff               call 0x44b3f0
0098B024 85c0                     test eax, eax
0098B026 0f84a4020000             je 0x98b2d0
0098B02C 8b8570ffffff             mov eax, dword ptr [ebp - 0x90]
0098B032 83780400                 cmp dword ptr [eax + 4], 0
0098B036 0f8494020000             je 0x98b2d0
0098B03C c745fc00000000           mov dword ptr [ebp - 4], 0
0098B043 eb09                     jmp 0x98b04e
0098B045 8b4dfc                   mov ecx, dword ptr [ebp - 4]
0098B048 83c101                   add ecx, 1
0098B04B 894dfc                   mov dword ptr [ebp - 4], ecx
0098B04E 837dfc08                 cmp dword ptr [ebp - 4], 8
0098B052 0f8378020000             jae 0x98b2d0
0098B058 8b55fc                   mov edx, dword ptr [ebp - 4]
0098B05B 52                       push edx
0098B05C 8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0098B062 e8e9d3e8ff               call 0x818450
0098B067 8945f4                   mov dword ptr [ebp - 0xc], eax
0098B06A c7458400000000           mov dword ptr [ebp - 0x7c], 0
0098B071 c745f800000000           mov dword ptr [ebp - 8], 0
0098B078 837df400                 cmp dword ptr [ebp - 0xc], 0
0098B07C 0f8449020000             je 0x98b2cb
0098B082 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0098B085 e8869a0500               call 0x9e4b10
0098B08A 85c0                     test eax, eax
0098B08C 0f8539020000             jne 0x98b2cb
0098B092 8b8570ffffff             mov eax, dword ptr [ebp - 0x90]
0098B098 8b4804                   mov ecx, dword ptr [eax + 4]
0098B09B e8b09eb2ff               call 0x4b4f50
0098B0A0 85c0                     test eax, eax
0098B0A2 0f8405010000             je 0x98b1ad
0098B0A8 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0098B0AB 51                       push ecx
0098B0AC 8b9570ffffff             mov edx, dword ptr [ebp - 0x90]
0098B0B2 8b4a04                   mov ecx, dword ptr [edx + 4]
0098B0B5 e8969eb2ff               call 0x4b4f50
0098B0BA 8bc8                     mov ecx, eax
0098B0BC e82f140200               call 0x9ac4f0
0098B0C1 894584                   mov dword ptr [ebp - 0x7c], eax
0098B0C4 837d8400                 cmp dword ptr [ebp - 0x7c], 0
0098B0C8 0f84df000000             je 0x98b1ad
0098B0CE c78574ffffff00000000     mov dword ptr [ebp - 0x8c], 0
0098B0D8 8d8574ffffff             lea eax, [ebp - 0x8c]
0098B0DE 50                       push eax
0098B0DF 8b4d84                   mov ecx, dword ptr [ebp - 0x7c]
0098B0E2 51                       push ecx
0098B0E3 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0098B0E6 e815c50600               call 0x9f7600
0098B0EB 85c0                     test eax, eax
0098B0ED 0f84ba000000             je 0x98b1ad
0098B0F3 6a67                     push 0x67
0098B0F5 6a00                     push 0
0098B0F7 8d5588                   lea edx, [ebp - 0x78]
0098B0FA 52                       push edx
0098B0FB e860b8cdff               call 0x666960
0098B100 83c40c                   add esp, 0xc
0098B103 c745b70a000000           mov dword ptr [ebp - 0x49], 0xa
0098B10A c745bb03000000           mov dword ptr [ebp - 0x45], 3
0098B111 8b4d84                   mov ecx, dword ptr [ebp - 0x7c]
0098B114 e8b787b0ff               call 0x4938d0
0098B119 8bc8                     mov ecx, eax
0098B11B e8f08cb0ff               call 0x493e10
0098B120 8945c3                   mov dword ptr [ebp - 0x3d], eax
0098B123 8b4d84                   mov ecx, dword ptr [ebp - 0x7c]
0098B126 e85573adff               call 0x462480
0098B12B 8945bf                   mov dword ptr [ebp - 0x41], eax
0098B12E 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0098B131 e8ca5ea7ff               call 0x401000
0098B136 8945af                   mov dword ptr [ebp - 0x51], eax
0098B139 8955b3                   mov dword ptr [ebp - 0x4d], edx
0098B13C 8b8574ffffff             mov eax, dword ptr [ebp - 0x8c]
0098B142 8945d7                   mov dword ptr [ebp - 0x29], eax
0098B145 8b8d78ffffff             mov ecx, dword ptr [ebp - 0x88]
0098B14B 894ddb                   mov dword ptr [ebp - 0x25], ecx
0098B14E 8b957cffffff             mov edx, dword ptr [ebp - 0x84]
0098B154 8955df                   mov dword ptr [ebp - 0x21], edx
0098B157 d94580                   fld dword ptr [ebp - 0x80]
0098B15A d95de3                   fstp dword ptr [ebp - 0x1d]
0098B15D 8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0098B163 e8d872aaff               call 0x432440
0098B168 8b08                     mov ecx, dword ptr [eax]
0098B16A 8b5004                   mov edx, dword ptr [eax + 4]
0098B16D 894de7                   mov dword ptr [ebp - 0x19], ecx
0098B170 8955eb                   mov dword ptr [ebp - 0x15], edx
0098B173 6a00                     push 0
0098B175 6a00                     push 0
0098B177 6a67                     push 0x67
0098B179 8d4588                   lea eax, [ebp - 0x78]
0098B17C 50                       push eax
0098B17D 68cc1f0000               push 0x1fcc
0098B182 e8294a0b00               call 0xa3fbb0
0098B187 83c414                   add esp, 0x14
0098B18A e8317fa7ff               call 0x4030c0
0098B18F 8bc8                     mov ecx, eax
0098B191 e80a80a7ff               call 0x4031a0
0098B196 83f802                   cmp eax, 2
0098B199 7412                     je 0x98b1ad
0098B19B 6a67                     push 0x67
0098B19D 8d4d88                   lea ecx, [ebp - 0x78]
0098B1A0 51                       push ecx
0098B1A1 e81a7fa7ff               call 0x4030c0
0098B1A6 8bc8                     mov ecx, eax
0098B1A8 e8536efaff               call 0x932000
0098B1AD 8b9570ffffff             mov edx, dword ptr [ebp - 0x90]
0098B1B3 8b4a04                   mov ecx, dword ptr [edx + 4]
0098B1B6 e8c572adff               call 0x462480
0098B1BB 85c0                     test eax, eax
0098B1BD 0f8408010000             je 0x98b2cb
0098B1C3 8b45f4                   mov eax, dword ptr [ebp - 0xc]
0098B1C6 50                       push eax
0098B1C7 8b8d70ffffff             mov ecx, dword ptr [ebp - 0x90]
0098B1CD 8b4904                   mov ecx, dword ptr [ecx + 4]
0098B1D0 e8ab72adff               call 0x462480
0098B1D5 8bc8                     mov ecx, eax
0098B1D7 e8d4ee0100               call 0x9aa0b0
0098B1DC 8945f8                   mov dword ptr [ebp - 8], eax
0098B1DF 837df800                 cmp dword ptr [ebp - 8], 0
0098B1E3 0f84e2000000             je 0x98b2cb
0098B1E9 8b55f8                   mov edx, dword ptr [ebp - 8]
0098B1EC 52                       push edx
0098B1ED 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0098B1F0 e83b120600               call 0x9ec430
0098B1F5 85c0                     test eax, eax
0098B1F7 0f8499000000             je 0x98b296
0098B1FD 6a67                     push 0x67
0098B1FF 6a00                     push 0
0098B201 8d4588                   lea eax, [ebp - 0x78]
0098B204 50                       push eax
0098B205 e856b7cdff               call 0x666960
0098B20A 83c40c                   add esp, 0xc
0098B20D c745b70a000000           mov dword ptr [ebp - 0x49], 0xa
0098B214 c745bb04000000           mov dword ptr [ebp - 0x45], 4
0098B21B 8b4df8                   mov ecx, dword ptr [ebp - 8]
0098B21E e8ad86b0ff               call 0x4938d0
0098B223 8bc8                     mov ecx, eax
0098B225 e8e68bb0ff               call 0x493e10
0098B22A 8945c3                   mov dword ptr [ebp - 0x3d], eax
0098B22D 8b4df8                   mov ecx, dword ptr [ebp - 8]
0098B230 e84b72adff               call 0x462480
0098B235 8945bf                   mov dword ptr [ebp - 0x41], eax
0098B238 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0098B23B e8c05da7ff               call 0x401000
0098B240 8945af                   mov dword ptr [ebp - 0x51], eax
0098B243 8955b3                   mov dword ptr [ebp - 0x4d], edx
0098B246 8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0098B24C e8ef71aaff               call 0x432440
0098B251 8b08                     mov ecx, dword ptr [eax]
0098B253 8b5004                   mov edx, dword ptr [eax + 4]
0098B256 894de7                   mov dword ptr [ebp - 0x19], ecx
0098B259 8955eb                   mov dword ptr [ebp - 0x15], edx
0098B25C 6a00                     push 0
0098B25E 6a00                     push 0
0098B260 6a67                     push 0x67
0098B262 8d4588                   lea eax, [ebp - 0x78]
0098B265 50                       push eax
0098B266 68cc1f0000               push 0x1fcc
0098B26B e840490b00               call 0xa3fbb0
0098B270 83c414                   add esp, 0x14
0098B273 e8487ea7ff               call 0x4030c0
0098B278 8bc8                     mov ecx, eax
0098B27A e8217fa7ff               call 0x4031a0
0098B27F 83f802                   cmp eax, 2
0098B282 7412                     je 0x98b296
0098B284 6a67                     push 0x67
0098B286 8d4d88                   lea ecx, [ebp - 0x78]
0098B289 51                       push ecx
0098B28A e8317ea7ff               call 0x4030c0
0098B28F 8bc8                     mov ecx, eax
0098B291 e86a6dfaff               call 0x932000
0098B296 8b9570ffffff             mov edx, dword ptr [ebp - 0x90]
0098B29C 83baac00000000           cmp dword ptr [edx + 0xac], 0
0098B2A3 7426                     je 0x98b2cb
0098B2A5 8b45f4                   mov eax, dword ptr [ebp - 0xc]
0098B2A8 50                       push eax
0098B2A9 8b8d70ffffff             mov ecx, dword ptr [ebp - 0x90]
0098B2AF 8b91ac000000             mov edx, dword ptr [ecx + 0xac]
0098B2B5 8b8570ffffff             mov eax, dword ptr [ebp - 0x90]
0098B2BB 8b88ac000000             mov ecx, dword ptr [eax + 0xac]
0098B2C1 8b12                     mov edx, dword ptr [edx]
0098B2C3 8b82f0000000             mov eax, dword ptr [edx + 0xf0]
0098B2C9 ffd0                     call eax
0098B2CB e975fdffff               jmp 0x98b045
0098B2D0 8be5                     mov esp, ebp
0098B2D2 5d                       pop ebp
0098B2D3 c3                       ret
0098B2D4 cc                       int3
0098B2D5 cc                       int3
0098B2D6 cc                       int3
0098B2D7 cc                       int3
; RANGE 0x82bb10
0082BB10 55                       push ebp
0082BB11 8bec                     mov ebp, esp
0082BB13 83ec40                   sub esp, 0x40
0082BB16 894dc4                   mov dword ptr [ebp - 0x3c], ecx
0082BB19 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BB1F e82c94c8ff               call 0x4b4f50
0082BB24 85c0                     test eax, eax
0082BB26 7505                     jne 0x82bb2d
0082BB28 e90c040000               jmp 0x82bf39
0082BB2D 837d0800                 cmp dword ptr [ebp + 8], 0
0082BB31 7406                     je 0x82bb39
0082BB33 837d0c67                 cmp dword ptr [ebp + 0xc], 0x67
0082BB37 7305                     jae 0x82bb3e
0082BB39 e9fb030000               jmp 0x82bf39
0082BB3E 8b4508                   mov eax, dword ptr [ebp + 8]
0082BB41 8945e0                   mov dword ptr [ebp - 0x20], eax
0082BB44 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BB47 51                       push ecx
0082BB48 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BB4E e85da31500               call 0x985eb0
0082BB53 85c0                     test eax, eax
0082BB55 7505                     jne 0x82bb5c
0082BB57 e9dd030000               jmp 0x82bf39
0082BB5C 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BB5F 83c25f                   add edx, 0x5f
0082BB62 52                       push edx
0082BB63 8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082BB69 e852bffeff               call 0x817ac0
0082BB6E 85c0                     test eax, eax
0082BB70 7505                     jne 0x82bb77
0082BB72 e9c2030000               jmp 0x82bf39
0082BB77 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BB7A 8b482b                   mov ecx, dword ptr [eax + 0x2b]
0082BB7D 51                       push ecx
0082BB7E 8b5027                   mov edx, dword ptr [eax + 0x27]
0082BB81 52                       push edx
0082BB82 8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082BB88 e8e3d0feff               call 0x818c70
0082BB8D 8945e8                   mov dword ptr [ebp - 0x18], eax
0082BB90 c745e400000000           mov dword ptr [ebp - 0x1c], 0
0082BB97 c745dc00000000           mov dword ptr [ebp - 0x24], 0
0082BB9E c745d800000000           mov dword ptr [ebp - 0x28], 0
0082BBA5 c745ec00000000           mov dword ptr [ebp - 0x14], 0
0082BBAC c745f000000000           mov dword ptr [ebp - 0x10], 0
0082BBB3 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BBB6 d9403f                   fld dword ptr [eax + 0x3f]
0082BBB9 d95df4                   fstp dword ptr [ebp - 0xc]
0082BBBC 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BBBF d94143                   fld dword ptr [ecx + 0x43]
0082BBC2 d95df8                   fstp dword ptr [ebp - 8]
0082BBC5 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BBC8 d94247                   fld dword ptr [edx + 0x47]
0082BBCB d95dfc                   fstp dword ptr [ebp - 4]
0082BBCE 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BBD1 8b482f                   mov ecx, dword ptr [eax + 0x2f]
0082BBD4 894dc0                   mov dword ptr [ebp - 0x40], ecx
0082BBD7 8b55c0                   mov edx, dword ptr [ebp - 0x40]
0082BBDA 83ea0a                   sub edx, 0xa
0082BBDD 8955c0                   mov dword ptr [ebp - 0x40], edx
0082BBE0 837dc013                 cmp dword ptr [ebp - 0x40], 0x13
0082BBE4 0f874f030000             ja 0x82bf39
0082BBEA 8b45c0                   mov eax, dword ptr [ebp - 0x40]
0082BBED 0fb68860bf8200           movzx ecx, byte ptr [eax + 0x82bf60]
0082BBF4 ff248d40bf8200           jmp dword ptr [ecx*4 + 0x82bf40]
0082BBFB 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BBFE 837a3300                 cmp dword ptr [edx + 0x33], 0
0082BC02 7516                     jne 0x82bc1a
0082BC04 837de800                 cmp dword ptr [ebp - 0x18], 0
0082BC08 7410                     je 0x82bc1a
0082BC0A 8b4de8                   mov ecx, dword ptr [ebp - 0x18]
0082BC0D e80e761c00               call 0x9f3220
0082BC12 8b4de8                   mov ecx, dword ptr [ebp - 0x18]
0082BC15 e8e6f6c1ff               call 0x44b300
0082BC1A 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BC1D 83783303                 cmp dword ptr [eax + 0x33], 3
0082BC21 0f8586000000             jne 0x82bcad
0082BC27 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BC2A 8b5137                   mov edx, dword ptr [ecx + 0x37]
0082BC2D 52                       push edx
0082BC2E 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BC34 e81793c8ff               call 0x4b4f50
0082BC39 8bc8                     mov ecx, eax
0082BC3B e81093c8ff               call 0x4b4f50
0082BC40 8bc8                     mov ecx, eax
0082BC42 e8b9061800               call 0x9ac300
0082BC47 8945d8                   mov dword ptr [ebp - 0x28], eax
0082BC4A 837dd800                 cmp dword ptr [ebp - 0x28], 0
0082BC4E 745d                     je 0x82bcad
0082BC50 837de800                 cmp dword ptr [ebp - 0x18], 0
0082BC54 7457                     je 0x82bcad
0082BC56 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BC59 8b484f                   mov ecx, dword ptr [eax + 0x4f]
0082BC5C 894dc8                   mov dword ptr [ebp - 0x38], ecx
0082BC5F 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BC62 8b4253                   mov eax, dword ptr [edx + 0x53]
0082BC65 8945cc                   mov dword ptr [ebp - 0x34], eax
0082BC68 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BC6B 8b5157                   mov edx, dword ptr [ecx + 0x57]
0082BC6E 8955d0                   mov dword ptr [ebp - 0x30], edx
0082BC71 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BC74 d9405b                   fld dword ptr [eax + 0x5b]
0082BC77 d95dd4                   fstp dword ptr [ebp - 0x2c]
0082BC7A 8d4dc8                   lea ecx, [ebp - 0x38]
0082BC7D 51                       push ecx
0082BC7E 8b55d8                   mov edx, dword ptr [ebp - 0x28]
0082BC81 52                       push edx
0082BC82 8b4de8                   mov ecx, dword ptr [ebp - 0x18]
0082BC85 e876b91c00               call 0x9f7600
0082BC8A e83174bdff               call 0x4030c0
0082BC8F 8bc8                     mov ecx, eax
0082BC91 e80a75bdff               call 0x4031a0
0082BC96 83f802                   cmp eax, 2
0082BC99 7412                     je 0x82bcad
0082BC9B 6a67                     push 0x67
0082BC9D 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BCA0 50                       push eax
0082BCA1 e81a74bdff               call 0x4030c0
0082BCA6 8bc8                     mov ecx, eax
0082BCA8 e853631000               call 0x932000
0082BCAD 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BCB0 83793304                 cmp dword ptr [ecx + 0x33], 4
0082BCB4 755e                     jne 0x82bd14
0082BCB6 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BCB9 8b4237                   mov eax, dword ptr [edx + 0x37]
0082BCBC 50                       push eax
0082BCBD 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BCC3 e88892c8ff               call 0x4b4f50
0082BCC8 8bc8                     mov ecx, eax
0082BCCA e8b167c3ff               call 0x462480
0082BCCF 8bc8                     mov ecx, eax
0082BCD1 e8fae21700               call 0x9a9fd0
0082BCD6 8945f0                   mov dword ptr [ebp - 0x10], eax
0082BCD9 837df000                 cmp dword ptr [ebp - 0x10], 0
0082BCDD 7435                     je 0x82bd14
0082BCDF 837de800                 cmp dword ptr [ebp - 0x18], 0
0082BCE3 742f                     je 0x82bd14
0082BCE5 8b4df0                   mov ecx, dword ptr [ebp - 0x10]
0082BCE8 51                       push ecx
0082BCE9 8b4de8                   mov ecx, dword ptr [ebp - 0x18]
0082BCEC e83f071c00               call 0x9ec430
0082BCF1 e8ca73bdff               call 0x4030c0
0082BCF6 8bc8                     mov ecx, eax
0082BCF8 e8a374bdff               call 0x4031a0
0082BCFD 83f802                   cmp eax, 2
0082BD00 7412                     je 0x82bd14
0082BD02 6a67                     push 0x67
0082BD04 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BD07 52                       push edx
0082BD08 e8b373bdff               call 0x4030c0
0082BD0D 8bc8                     mov ecx, eax
0082BD0F e8ec621000               call 0x932000
0082BD14 e920020000               jmp 0x82bf39
0082BD19 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BD1F e82c92c8ff               call 0x4b4f50
0082BD24 8bc8                     mov ecx, eax
0082BD26 e855ccd1ff               call 0x548980
0082BD2B 85c0                     test eax, eax
0082BD2D 7505                     jne 0x82bd34
0082BD2F e905020000               jmp 0x82bf39
0082BD34 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BD37 8b4837                   mov ecx, dword ptr [eax + 0x37]
0082BD3A 51                       push ecx
0082BD3B 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BD41 e80a92c8ff               call 0x4b4f50
0082BD46 8bc8                     mov ecx, eax
0082BD48 e833ccd1ff               call 0x548980
0082BD4D 8bc8                     mov ecx, eax
0082BD4F e82c5e1800               call 0x9b1b80
0082BD54 8945dc                   mov dword ptr [ebp - 0x24], eax
0082BD57 837ddc00                 cmp dword ptr [ebp - 0x24], 0
0082BD5B 742a                     je 0x82bd87
0082BD5D 837de800                 cmp dword ptr [ebp - 0x18], 0
0082BD61 7424                     je 0x82bd87
0082BD63 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BD66 51                       push ecx
0082BD67 d9425b                   fld dword ptr [edx + 0x5b]
0082BD6A d91c24                   fstp dword ptr [esp]
0082BD6D 8b45dc                   mov eax, dword ptr [ebp - 0x24]
0082BD70 50                       push eax
0082BD71 8b4de8                   mov ecx, dword ptr [ebp - 0x18]
0082BD74 51                       push ecx
0082BD75 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BD7B e8d091c8ff               call 0x4b4f50
0082BD80 8bc8                     mov ecx, eax
0082BD82 e8b9f61e00               call 0xa1b440
0082BD87 e9ad010000               jmp 0x82bf39
0082BD8C 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BD8F 8b4237                   mov eax, dword ptr [edx + 0x37]
0082BD92 50                       push eax
0082BD93 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BD99 e8b291c8ff               call 0x4b4f50
0082BD9E 8bc8                     mov ecx, eax
0082BDA0 e8ab81c2ff               call 0x453f50
0082BDA5 8bc8                     mov ecx, eax
0082BDA7 e8f4dd1800               call 0x9b9ba0
0082BDAC 8945e4                   mov dword ptr [ebp - 0x1c], eax
0082BDAF 837de400                 cmp dword ptr [ebp - 0x1c], 0
0082BDB3 7434                     je 0x82bde9
0082BDB5 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BDB8 8b513b                   mov edx, dword ptr [ecx + 0x3b]
0082BDBB 52                       push edx
0082BDBC 83ec0c                   sub esp, 0xc
0082BDBF 8bc4                     mov eax, esp
0082BDC1 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0082BDC4 8908                     mov dword ptr [eax], ecx
0082BDC6 8b55f8                   mov edx, dword ptr [ebp - 8]
0082BDC9 895004                   mov dword ptr [eax + 4], edx
0082BDCC 8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082BDCF 894808                   mov dword ptr [eax + 8], ecx
0082BDD2 8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
0082BDD5 e8063f1900               call 0x9bfce0
0082BDDA 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BDDD 8b424b                   mov eax, dword ptr [edx + 0x4b]
0082BDE0 50                       push eax
0082BDE1 8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
0082BDE4 e877cbd1ff               call 0x548960
0082BDE9 e94b010000               jmp 0x82bf39
0082BDEE 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BDF1 83793300                 cmp dword ptr [ecx + 0x33], 0
0082BDF5 7532                     jne 0x82be29
0082BDF7 837de800                 cmp dword ptr [ebp - 0x18], 0
0082BDFB 742c                     je 0x82be29
0082BDFD 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BE00 8b423b                   mov eax, dword ptr [edx + 0x3b]
0082BE03 50                       push eax
0082BE04 83ec0c                   sub esp, 0xc
0082BE07 8bcc                     mov ecx, esp
0082BE09 8b55f4                   mov edx, dword ptr [ebp - 0xc]
0082BE0C 8911                     mov dword ptr [ecx], edx
0082BE0E 8b45f8                   mov eax, dword ptr [ebp - 8]
0082BE11 894104                   mov dword ptr [ecx + 4], eax
0082BE14 8b55fc                   mov edx, dword ptr [ebp - 4]
0082BE17 895108                   mov dword ptr [ecx + 8], edx
0082BE1A 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BE1D 8b4837                   mov ecx, dword ptr [eax + 0x37]
0082BE20 51                       push ecx
0082BE21 8b4de8                   mov ecx, dword ptr [ebp - 0x18]
0082BE24 e8674a1c00               call 0x9f0890
0082BE29 e90b010000               jmp 0x82bf39
0082BE2E 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BE31 837a3305                 cmp dword ptr [edx + 0x33], 5
0082BE35 7536                     jne 0x82be6d
0082BE37 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BE3A 8b4837                   mov ecx, dword ptr [eax + 0x37]
0082BE3D 51                       push ecx
0082BE3E 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BE44 e80791c8ff               call 0x4b4f50
0082BE49 8bc8                     mov ecx, eax
0082BE4B e8d0e91e00               call 0xa1a820
0082BE50 8945ec                   mov dword ptr [ebp - 0x14], eax
0082BE53 837dec00                 cmp dword ptr [ebp - 0x14], 0
0082BE57 7414                     je 0x82be6d
0082BE59 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BE5C 8b424f                   mov eax, dword ptr [edx + 0x4f]
0082BE5F 50                       push eax
0082BE60 8b4dec                   mov ecx, dword ptr [ebp - 0x14]
0082BE63 8b11                     mov edx, dword ptr [ecx]
0082BE65 8b4dec                   mov ecx, dword ptr [ebp - 0x14]
0082BE68 8b4204                   mov eax, dword ptr [edx + 4]
0082BE6B ffd0                     call eax
0082BE6D e9c7000000               jmp 0x82bf39
0082BE72 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BE75 83793301                 cmp dword ptr [ecx + 0x33], 1
0082BE79 755d                     jne 0x82bed8
0082BE7B 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BE81 e8ca90c8ff               call 0x4b4f50
0082BE86 85c0                     test eax, eax
0082BE88 744e                     je 0x82bed8
0082BE8A 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BE90 e8bb90c8ff               call 0x4b4f50
0082BE95 8bc8                     mov ecx, eax
0082BE97 e8e4cad1ff               call 0x548980
0082BE9C 85c0                     test eax, eax
0082BE9E 7438                     je 0x82bed8
0082BEA0 8b55e0                   mov edx, dword ptr [ebp - 0x20]
0082BEA3 8b4237                   mov eax, dword ptr [edx + 0x37]
0082BEA6 50                       push eax
0082BEA7 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BEAD e89e90c8ff               call 0x4b4f50
0082BEB2 8bc8                     mov ecx, eax
0082BEB4 e8c7cad1ff               call 0x548980
0082BEB9 8bc8                     mov ecx, eax
0082BEBB e8c05c1800               call 0x9b1b80
0082BEC0 8945dc                   mov dword ptr [ebp - 0x24], eax
0082BEC3 837ddc00                 cmp dword ptr [ebp - 0x24], 0
0082BEC7 740f                     je 0x82bed8
0082BEC9 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BECC 8b514b                   mov edx, dword ptr [ecx + 0x4b]
0082BECF 52                       push edx
0082BED0 8b4ddc                   mov ecx, dword ptr [ebp - 0x24]
0082BED3 e868751800               call 0x9b3440
0082BED8 eb5f                     jmp 0x82bf39
0082BEDA 8b45e0                   mov eax, dword ptr [ebp - 0x20]
0082BEDD 83783301                 cmp dword ptr [eax + 0x33], 1
0082BEE1 7556                     jne 0x82bf39
0082BEE3 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BEE9 e86290c8ff               call 0x4b4f50
0082BEEE 85c0                     test eax, eax
0082BEF0 7447                     je 0x82bf39
0082BEF2 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BEF8 e85390c8ff               call 0x4b4f50
0082BEFD 8bc8                     mov ecx, eax
0082BEFF e87ccad1ff               call 0x548980
0082BF04 85c0                     test eax, eax
0082BF06 7431                     je 0x82bf39
0082BF08 8b4de0                   mov ecx, dword ptr [ebp - 0x20]
0082BF0B 8b5137                   mov edx, dword ptr [ecx + 0x37]
0082BF0E 52                       push edx
0082BF0F 8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082BF15 e83690c8ff               call 0x4b4f50
0082BF1A 8bc8                     mov ecx, eax
0082BF1C e85fcad1ff               call 0x548980
0082BF21 8bc8                     mov ecx, eax
0082BF23 e8585c1800               call 0x9b1b80
0082BF28 8945dc                   mov dword ptr [ebp - 0x24], eax
0082BF2B 837ddc00                 cmp dword ptr [ebp - 0x24], 0
0082BF2F 7408                     je 0x82bf39
0082BF31 8b4ddc                   mov ecx, dword ptr [ebp - 0x24]
0082BF34 e887741800               call 0x9b33c0
0082BF39 8be5                     mov esp, ebp
0082BF3B 5d                       pop ebp
0082BF3C c20800                   ret 8
0082BF3F 90                       nop
; RANGE 0x8ac986
008AC986 8b8534ffffff             mov eax, dword ptr [ebp - 0xcc]
008AC98C 83c001                   add eax, 1
008AC98F 898534ffffff             mov dword ptr [ebp - 0xcc], eax
008AC995 8d8d38ffffff             lea ecx, [ebp - 0xc8]
008AC99B e830a8caff               call 0x5571d0
008AC9A0 398534ffffff             cmp dword ptr [ebp - 0xcc], eax
008AC9A6 0f8d62020000             jge 0x8acc0e
008AC9AC 8b8d34ffffff             mov ecx, dword ptr [ebp - 0xcc]
008AC9B2 51                       push ecx
008AC9B3 8d8d38ffffff             lea ecx, [ebp - 0xc8]
008AC9B9 e872c7caff               call 0x559130
008AC9BE 8985b0feffff             mov dword ptr [ebp - 0x150], eax
008AC9C4 8d8db4feffff             lea ecx, [ebp - 0x14c]
008AC9CA e8814fc6ff               call 0x511950
008AC9CF c645fc02                 mov byte ptr [ebp - 4], 2
008AC9D3 6880000000               push 0x80
008AC9D8 6a00                     push 0
008AC9DA 8d95b4feffff             lea edx, [ebp - 0x14c]
008AC9E0 52                       push edx
008AC9E1 e87a9fdbff               call 0x666960
008AC9E6 83c40c                   add esp, 0xc
008AC9E9 8b85b0feffff             mov eax, dword ptr [ebp - 0x150]
008AC9EF 0fb64804                 movzx ecx, byte ptr [eax + 4]
008AC9F3 8b9554feffff             mov edx, dword ptr [ebp - 0x1ac]
008AC9F9 398a2c060000             cmp dword ptr [edx + 0x62c], ecx
008AC9FF 7423                     je 0x8aca24
008ACA01 8b85b0feffff             mov eax, dword ptr [ebp - 0x150]
008ACA07 0fb64804                 movzx ecx, byte ptr [eax + 4]
008ACA0B 83f912                   cmp ecx, 0x12
008ACA0E 7414                     je 0x8aca24
008ACA10 c645fc01                 mov byte ptr [ebp - 4], 1
008ACA14 8d8db4feffff             lea ecx, [ebp - 0x14c]
008ACA1A e8614fc6ff               call 0x511980
008ACA1F e962ffffff               jmp 0x8ac986
008ACA24 8b95b0feffff             mov edx, dword ptr [ebp - 0x150]
008ACA2A 52                       push edx
008ACA2B 8b8d54feffff             mov ecx, dword ptr [ebp - 0x1ac]
008ACA31 e83a6effff               call 0x8a3870
008ACA36 85c0                     test eax, eax
008ACA38 0f85bc010000             jne 0x8acbfa
008ACA3E 8b85b0feffff             mov eax, dword ptr [ebp - 0x150]
008ACA44 837813ff                 cmp dword ptr [eax + 0x13], -1
008ACA48 0f84ac010000             je 0x8acbfa
008ACA4E 8d8db4feffff             lea ecx, [ebp - 0x14c]
008ACA54 51                       push ecx
008ACA55 8b95b0feffff             mov edx, dword ptr [ebp - 0x150]
008ACA5B 52                       push edx
008ACA5C 8b8d54feffff             mov ecx, dword ptr [ebp - 0x1ac]
008ACA62 e8f96cffff               call 0x8a3760
008ACA67 8b85b0feffff             mov eax, dword ptr [ebp - 0x150]
008ACA6D 8b4805                   mov ecx, dword ptr [eax + 5]
008ACA70 51                       push ecx
008ACA71 e8ba501700               call 0xa21b30
008ACA76 8bc8                     mov ecx, eax
008ACA78 e8e31a1700               call 0xa1e560
008ACA7D 8985acfeffff             mov dword ptr [ebp - 0x154], eax
008ACA83 83bdacfeffff00           cmp dword ptr [ebp - 0x154], 0
008ACA8A 7468                     je 0x8acaf4
008ACA8C 8b95b0feffff             mov edx, dword ptr [ebp - 0x150]
008ACA92 8b4205                   mov eax, dword ptr [edx + 5]
008ACA95 50                       push eax
008ACA96 68eceeba00               push 0xbaeeec
008ACA9B 6a20                     push 0x20
008ACA9D 8d8d88feffff             lea ecx, [ebp - 0x178]
008ACAA3 51                       push ecx
008ACAA4 e84271dbff               call 0x663beb
008ACAA9 83c410                   add esp, 0x10
008ACAAC 8d9588feffff             lea edx, [ebp - 0x178]
008ACAB2 52                       push edx
008ACAB3 8d8d10ffffff             lea ecx, [ebp - 0xf0]
008ACAB9 e8528cb5ff               call 0x405710
008ACABE 8b8dacfeffff             mov ecx, dword ptr [ebp - 0x154]
008ACAC4 83c10c                   add ecx, 0xc
008ACAC7 e88474baff               call 0x453f50
008ACACC 50                       push eax
008ACACD 8d8df4feffff             lea ecx, [ebp - 0x10c]
008ACAD3 e8388cb5ff               call 0x405710
008ACAD8 8b8dacfeffff             mov ecx, dword ptr [ebp - 0x154]
008ACADE 83c144                   add ecx, 0x44
008ACAE1 e86a74baff               call 0x453f50
008ACAE6 50                       push eax
008ACAE7 8d8dd8feffff             lea ecx, [ebp - 0x128]
008ACAED e81e8cb5ff               call 0x405710
008ACAF2 eb5d                     jmp 0x8acb51
008ACAF4 8b85b0feffff             mov eax, dword ptr [ebp - 0x150]
008ACAFA 50                       push eax
008ACAFB 8d8d58feffff             lea ecx, [ebp - 0x1a8]
008ACB01 51                       push ecx
008ACB02 e88951b6ff               call 0x411c90
008ACB07 83c408                   add esp, 8
008ACB0A 898550feffff             mov dword ptr [ebp - 0x1b0], eax
008ACB10 8b9550feffff             mov edx, dword ptr [ebp - 0x1b0]
008ACB16 89954cfeffff             mov dword ptr [ebp - 0x1b4], edx
008ACB1C c645fc03                 mov byte ptr [ebp - 4], 3
008ACB20 8b854cfeffff             mov eax, dword ptr [ebp - 0x1b4]
008ACB26 50                       push eax
008ACB27 8d8df4feffff             lea ecx, [ebp - 0x10c]
008ACB2D e8be8bb5ff               call 0x4056f0
008ACB32 c645fc02                 mov byte ptr [ebp - 4], 2
008ACB36 8d8d58feffff             lea ecx, [ebp - 0x1a8]
008ACB3C e88f8bb5ff               call 0x4056d0
008ACB41 689966b900               push 0xb96699
008ACB46 8d8d10ffffff             lea ecx, [ebp - 0xf0]
008ACB4C e8bf8bb5ff               call 0x405710
008ACB51 c785a8feffff00000000     mov dword ptr [ebp - 0x158], 0
008ACB5B 8b8dc0feffff             mov ecx, dword ptr [ebp - 0x140]
008ACB61 51                       push ecx
008ACB62 e8c94f1700               call 0xa21b30
008ACB67 8bc8                     mov ecx, eax
008ACB69 e8f2191700               call 0xa1e560
008ACB6E 8985a8feffff             mov dword ptr [ebp - 0x158], eax
008ACB74 83bda8feffff00           cmp dword ptr [ebp - 0x158], 0
008ACB7B 747d                     je 0x8acbfa
008ACB7D 8b95a8feffff             mov edx, dword ptr [ebp - 0x158]
008ACB83 8b4220                   mov eax, dword ptr [edx + 0x20]
008ACB86 50                       push eax
008ACB87 8b8d50ffffff             mov ecx, dword ptr [ebp - 0xb0]
008ACB8D 51                       push ecx
008ACB8E e89d4f1700               call 0xa21b30
008ACB93 8bc8                     mov ecx, eax
008ACB95 e8a6161700               call 0xa1e240
008ACB9A 85c0                     test eax, eax
008ACB9C 745c                     je 0x8acbfa
008ACB9E 8b9554feffff             mov edx, dword ptr [ebp - 0x1ac]
008ACBA4 8b85b4feffff             mov eax, dword ptr [ebp - 0x14c]
008ACBAA 3b822c060000             cmp eax, dword ptr [edx + 0x62c]
008ACBB0 7430                     je 0x8acbe2
008ACBB2 83bdb4feffff12           cmp dword ptr [ebp - 0x14c], 0x12
008ACBB9 753f                     jne 0x8acbfa
008ACBBB 8b8dc0feffff             mov ecx, dword ptr [ebp - 0x140]
008ACBC1 51                       push ecx
008ACBC2 8b9554feffff             mov edx, dword ptr [ebp - 0x1ac]
008ACBC8 8b8230060000             mov eax, dword ptr [edx + 0x630]
008ACBCE 50                       push eax
008ACBCF e82cf5b6ff               call 0x41c100
008ACBD4 8bc8                     mov ecx, eax
008ACBD6 e895eafaff               call 0x85b670
008ACBDB 0fb6c8                   movzx ecx, al
008ACBDE 85c9                     test ecx, ecx
008ACBE0 7418                     je 0x8acbfa
008ACBE2 8d95b4feffff             lea edx, [ebp - 0x14c]
008ACBE8 52                       push edx
008ACBE9 8b8d54feffff             mov ecx, dword ptr [ebp - 0x1ac]
008ACBEF 81c194050000             add ecx, 0x594
008ACBF5 e8b69cc5ff               call 0x5068b0
; RANGE 0x8a3870
008A3870 55                       push ebp
008A3871 8bec                     mov ebp, esp
008A3873 51                       push ecx
008A3874 894dfc                   mov dword ptr [ebp - 4], ecx
008A3877 8b4508                   mov eax, dword ptr [ebp + 8]
008A387A 0fb74811                 movzx ecx, word ptr [eax + 0x11]
008A387E 85c9                     test ecx, ecx
008A3880 7407                     je 0x8a3889
008A3882 b801000000               mov eax, 1
008A3887 eb02                     jmp 0x8a388b
008A3889 33c0                     xor eax, eax
008A388B 8be5                     mov esp, ebp
008A388D 5d                       pop ebp
