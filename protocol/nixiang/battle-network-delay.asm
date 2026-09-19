; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 4080 +13: eight network delay values, not P2P identities.
; BDB340 ASCII GetNetDelay; BD6584 Lua error names GetNetDelay.

; Block 0x81e294
0081E294 mov edx, dword ptr [ebp - 0xc]
0081E297 mov eax, dword ptr [ebp - 4]
0081E29A mov ecx, dword ptr [eax + edx*4 + 0xd]
0081E29E push ecx
0081E29F mov ecx, dword ptr [ebp - 8]
0081E2A2 call 0x5495a0

; Block 0x5495a0
005495A0 push ebp
005495A1 mov ebp, esp
005495A3 push ecx
005495A4 mov dword ptr [ebp - 4], ecx
005495A7 mov eax, dword ptr [ebp - 4]
005495AA mov ecx, dword ptr [ebp + 8]
005495AD mov dword ptr [eax + 0x1b90], ecx
005495B3 mov esp, ebp
005495B5 pop ebp
005495B6 ret 4

; Block 0x5564a0
005564A0 push ebp
005564A1 mov ebp, esp
005564A3 push ecx
005564A4 mov dword ptr [ebp - 4], ecx
005564A7 mov eax, dword ptr [ebp - 4]
005564AA mov eax, dword ptr [eax + 0x1b90]
005564B0 mov esp, ebp
005564B2 pop ebp
005564B3 ret

; Block 0x7b760b
007B760B mov ecx, dword ptr [ebp - 0x10]
007B760E call 0x5564a0
007B7613 mov dword ptr [ebp - 0x14], eax
007B7616 mov eax, dword ptr [ebp - 0x14]
007B7619 mov dword ptr [ebp - 0x1c], eax
007B761C mov dword ptr [ebp - 0x18], 0
007B7623 fild qword ptr [ebp - 0x1c]
007B7626 sub esp, 8
007B7629 fstp qword ptr [esp]
007B762C mov ecx, dword ptr [ebp + 8]
007B762F push ecx
007B7630 call 0x6ac0d0
007B7635 add esp, 0xc

; Block 0x7c0c0a
007C0C0A push 0x7b75a0
007C0C0F push 0xbdb340
007C0C14 mov edx, dword ptr [ebp + 8]
007C0C17 push edx
007C0C18 call 0x6ad540
007C0C1D add esp, 0xc

; Block 0x7fc078
007FC078 mov ecx, dword ptr [ebp - 0x30]
007FC07B call 0x5564a0
007FC080 mov dword ptr [ebp - 0x5c], eax
007FC083 cmp dword ptr [ebp - 0x54], 0
007FC087 je 0x7fc234
007FC08D cmp dword ptr [ebp - 0x5c], 0
007FC091 jb 0x7fc0d6
007FC093 cmp dword ptr [ebp - 0x5c], 0x32
007FC097 ja 0x7fc0d6

; Block 0x7fc0d6
007FC0D6 cmp dword ptr [ebp - 0x5c], 0x32
007FC0DA jbe 0x7fc11f
007FC0DC cmp dword ptr [ebp - 0x5c], 0x64
007FC0E0 ja 0x7fc11f

; Block 0x7fc11f
007FC11F cmp dword ptr [ebp - 0x5c], 0x64
007FC123 jbe 0x7fc16b
007FC125 cmp dword ptr [ebp - 0x5c], 0x96
007FC12C ja 0x7fc16b

; Block 0x7fc16b
007FC16B cmp dword ptr [ebp - 0x5c], 0x96
007FC172 jbe 0x7fc1b7
007FC174 cmp dword ptr [ebp - 0x5c], 0xfa
007FC17B ja 0x7fc1b7

; Block 0x7fc1b7
007FC1B7 cmp dword ptr [ebp - 0x5c], 0xfa
007FC1BE jbe 0x7fc1f8

; Block 0x9e8a34
009E8A34 mov edx, dword ptr [ebp - 0x5c]
009E8A37 mov dword ptr [edx + 0x1b90], 0

; Block 0x81df00
0081DF00 push ebp
0081DF01 mov ebp, esp
0081DF03 push ecx
0081DF04 mov dword ptr [ebp - 4], ecx
0081DF07 cmp dword ptr [0x17c8714], 0
0081DF0E jne 0x81df12
0081DF10 jmp 0x81df2b
0081DF12 mov dword ptr [0x17c86d0], 1
0081DF1C push 0
0081DF1E push 0x102c
0081DF23 call 0xa3ca00
0081DF28 add esp, 8
0081DF2B mov esp, ebp
0081DF2D pop ebp
0081DF2E ret 8
