; current PE VA; sha256=98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
00A2BA90 55                       push ebp
00A2BA91 8bec                     mov ebp, esp
00A2BA93 83ec08                   sub esp, 8
00A2BA96 894df8                   mov dword ptr [ebp - 8], ecx
00A2BA99 8b450c                   mov eax, dword ptr [ebp + 0xc]
00A2BA9C 33d2                     xor edx, edx
00A2BA9E b91a000000               mov ecx, 0x1a
00A2BAA3 f7f1                     div ecx
00A2BAA5 8945fc                   mov dword ptr [ebp - 4], eax
00A2BAA8 8b55fc                   mov edx, dword ptr [ebp - 4]
00A2BAAB 52                       push edx
00A2BAAC 8b4508                   mov eax, dword ptr [ebp + 8]
00A2BAAF 50                       push eax
00A2BAB0 e82baa9eff               call 0x4164e0
00A2BAB5 8bc8                     mov ecx, eax
00A2BAB7 e87446eeff               call 0x910130
00A2BABC 8be5                     mov esp, ebp
00A2BABE 5d                       pop ebp
00A2BABF c20800                   ret 8
00A2BAC2 cc                       int3
00A2BAC3 cc                       int3
00A2BAC4 cc                       int3
00A2BAC5 cc                       int3
00A2BAC6 cc                       int3
00A2BAC7 cc                       int3
00A2BAC8 cc                       int3
00A2BAC9 cc                       int3
00A2BACA cc                       int3
00A2BACB cc                       int3
00A2BACC cc                       int3
00A2BACD cc                       int3
00A2BACE cc                       int3
00A2BACF cc                       int3
00A2BAD0 55                       push ebp
00A2BAD1 8bec                     mov ebp, esp
00A2BAD3 6aff                     push -1
00A2BAD5 68a96fad00               push 0xad6fa9
00A2BADA 64a100000000             mov eax, dword ptr fs:[0]
00A2BAE0 50                       push eax
00A2BAE1 83ec2c                   sub esp, 0x2c
00A2BAE4 a180b4c700               mov eax, dword ptr [0xc7b480]
00A2BAE9 33c5                     xor eax, ebp
00A2BAEB 50                       push eax
00A2BAEC 8d45f4                   lea eax, [ebp - 0xc]
00A2BAEF 64a300000000             mov dword ptr fs:[0], eax
00A2BAF5 894dcc                   mov dword ptr [ebp - 0x34], ecx
00A2BAF8 8b450c                   mov eax, dword ptr [ebp + 0xc]
00A2BAFB 33d2                     xor edx, edx
00A2BAFD b92e000000               mov ecx, 0x2e
00A2BB02 f7f1                     div ecx
00A2BB04 8955ec                   mov dword ptr [ebp - 0x14], edx
00A2BB07 837dec00                 cmp dword ptr [ebp - 0x14], 0
00A2BB0B 7447                     je 0xa2bb54
00A2BB0D 6860ccb900               push 0xb9cc60
00A2BB12 8d4dd0                   lea ecx, [ebp - 0x30]
00A2BB15 e8369b9dff               call 0x405650
00A2BB1A c745fc00000000           mov dword ptr [ebp - 4], 0
00A2BB21 e8fa7c9dff               call 0x403820
00A2BB26 8945c8                   mov dword ptr [ebp - 0x38], eax
00A2BB29 6a00                     push 0
00A2BB2B 6a00                     push 0
00A2BB2D 6a00                     push 0
00A2BB2F 8d55d0                   lea edx, [ebp - 0x30]
00A2BB32 52                       push edx
00A2BB33 8b45c8                   mov eax, dword ptr [ebp - 0x38]
00A2BB36 8b10                     mov edx, dword ptr [eax]
00A2BB38 8b4dc8                   mov ecx, dword ptr [ebp - 0x38]
00A2BB3B 8b82c0010000             mov eax, dword ptr [edx + 0x1c0]
00A2BB41 ffd0                     call eax
00A2BB43 c745fcffffffff           mov dword ptr [ebp - 4], 0xffffffff
00A2BB4A 8d4dd0                   lea ecx, [ebp - 0x30]
00A2BB4D e87e9b9dff               call 0x4056d0
00A2BB52 eb23                     jmp 0xa2bb77
00A2BB54 8b450c                   mov eax, dword ptr [ebp + 0xc]
00A2BB57 33d2                     xor edx, edx
00A2BB59 b92e000000               mov ecx, 0x2e
00A2BB5E f7f1                     div ecx
00A2BB60 8945f0                   mov dword ptr [ebp - 0x10], eax
00A2BB63 8b55f0                   mov edx, dword ptr [ebp - 0x10]
00A2BB66 52                       push edx
00A2BB67 8b4508                   mov eax, dword ptr [ebp + 8]
00A2BB6A 50                       push eax
00A2BB6B e870a99eff               call 0x4164e0
00A2BB70 8bc8                     mov ecx, eax
00A2BB72 e8c944eeff               call 0x910040
00A2BB77 8b4df4                   mov ecx, dword ptr [ebp - 0xc]
00A2BB7A 64890d00000000           mov dword ptr fs:[0], ecx
00A2BB81 59                       pop ecx
00A2BB82 8be5                     mov esp, ebp
00A2BB84 5d                       pop ebp
