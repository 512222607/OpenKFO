; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 20403 create_block: 92B, +39 bool, +40 DWORD id, +44 four XYZ float vectors.
; 20404 destroy_block: 43B, +39 DWORD id. Both embedded through A3FBB0.
; function 0x941d30
00941D30 push ebp
00941D31 mov ebp, esp
00941D33 sub esp, 0xb4
00941D39 mov dword ptr [ebp - 0xa8], ecx
00941D3F mov eax, dword ptr [ebp + 8]
00941D42 push eax
00941D43 call 0x68bb90
00941D48 add esp, 4
00941D4B cmp eax, 0xe
00941D4E jne 0x941e69
00941D54 push 1
00941D56 mov ecx, dword ptr [ebp + 8]
00941D59 push ecx
00941D5A call 0x68c0c0
00941D5F add esp, 8
00941D62 test eax, eax
00941D64 je 0x941e69
00941D6A push 2
00941D6C mov edx, dword ptr [ebp + 8]
00941D6F push edx
00941D70 call 0x68c000
00941D75 add esp, 8
00941D78 cmp eax, 1
00941D7B jne 0x941e69
00941D81 push 3
00941D83 mov eax, dword ptr [ebp + 8]
00941D86 push eax
00941D87 call 0x68c0c0
00941D8C add esp, 8
00941D8F test eax, eax
00941D91 je 0x941e69
00941D97 push 4
00941D99 mov ecx, dword ptr [ebp + 8]
00941D9C push ecx
00941D9D call 0x68c0c0
00941DA2 add esp, 8
00941DA5 test eax, eax
00941DA7 je 0x941e69
00941DAD push 5
00941DAF mov edx, dword ptr [ebp + 8]
00941DB2 push edx
00941DB3 call 0x68c0c0
00941DB8 add esp, 8
00941DBB test eax, eax
00941DBD je 0x941e69
00941DC3 push 6
00941DC5 mov eax, dword ptr [ebp + 8]
00941DC8 push eax
00941DC9 call 0x68c0c0
00941DCE add esp, 8
00941DD1 test eax, eax
00941DD3 je 0x941e69
00941DD9 push 7
00941DDB mov ecx, dword ptr [ebp + 8]
00941DDE push ecx
00941DDF call 0x68c0c0
00941DE4 add esp, 8
00941DE7 test eax, eax
00941DE9 je 0x941e69
00941DEB push 8
00941DED mov edx, dword ptr [ebp + 8]
00941DF0 push edx
00941DF1 call 0x68c0c0
00941DF6 add esp, 8
00941DF9 test eax, eax
00941DFB je 0x941e69
00941DFD push 9
00941DFF mov eax, dword ptr [ebp + 8]
00941E02 push eax
00941E03 call 0x68c0c0
00941E08 add esp, 8
00941E0B test eax, eax
00941E0D je 0x941e69
00941E0F push 0xa
00941E11 mov ecx, dword ptr [ebp + 8]
00941E14 push ecx
00941E15 call 0x68c0c0
00941E1A add esp, 8
00941E1D test eax, eax
00941E1F je 0x941e69
00941E21 push 0xb
00941E23 mov edx, dword ptr [ebp + 8]
00941E26 push edx
00941E27 call 0x68c0c0
00941E2C add esp, 8
00941E2F test eax, eax
00941E31 je 0x941e69
00941E33 push 0xc
00941E35 mov eax, dword ptr [ebp + 8]
00941E38 push eax
00941E39 call 0x68c0c0
00941E3E add esp, 8
00941E41 test eax, eax
00941E43 je 0x941e69
00941E45 push 0xd
00941E47 mov ecx, dword ptr [ebp + 8]
00941E4A push ecx
00941E4B call 0x68c0c0
00941E50 add esp, 8
00941E53 test eax, eax
00941E55 je 0x941e69
00941E57 push 0xe
00941E59 mov edx, dword ptr [ebp + 8]
00941E5C push edx
00941E5D call 0x68c0c0
00941E62 add esp, 8
00941E65 test eax, eax
00941E67 jne 0x941e81
00941E69 push 0xbad388
00941E6E push 0
00941E70 mov eax, dword ptr [ebp + 8]
00941E73 push eax
00941E74 call 0x639f10
00941E79 add esp, 0xc
00941E7C jmp 0x942004
00941E81 push 1
00941E83 mov ecx, dword ptr [ebp + 8]
00941E86 push ecx
00941E87 call 0x68c370
00941E8C add esp, 8
00941E8F mov dword ptr [ebp - 4], eax
00941E92 push 2
00941E94 mov edx, dword ptr [ebp + 8]
00941E97 push edx
00941E98 call 0x68c3e0
00941E9D add esp, 8
00941EA0 test eax, eax
00941EA2 setne al
00941EA5 mov byte ptr [ebp - 0x69], al
00941EA8 mov dword ptr [ebp - 0xa0], 0
00941EB2 jmp 0x941ec3
00941EB4 mov ecx, dword ptr [ebp - 0xa0]
00941EBA add ecx, 1
00941EBD mov dword ptr [ebp - 0xa0], ecx
00941EC3 cmp dword ptr [ebp - 0xa0], 4
00941ECA jge 0x941f7a
00941ED0 mov edx, dword ptr [ebp - 0xa0]
00941ED6 imul edx, edx, 3
00941ED9 add edx, 3
00941EDC mov dword ptr [ebp - 0xa4], edx
00941EE2 mov eax, dword ptr [ebp - 0xa4]
00941EE8 push eax
00941EE9 mov ecx, dword ptr [ebp + 8]
00941EEC push ecx
00941EED call 0x68c320
00941EF2 add esp, 8
00941EF5 fstp dword ptr [ebp - 0xac]
00941EFB fld dword ptr [ebp - 0xac]
00941F01 mov edx, dword ptr [ebp - 0xa0]
00941F07 imul edx, edx, 0xc
00941F0A fstp dword ptr [ebp + edx - 0x9c]
00941F11 mov eax, dword ptr [ebp - 0xa4]
00941F17 add eax, 1
00941F1A push eax
00941F1B mov ecx, dword ptr [ebp + 8]
00941F1E push ecx
00941F1F call 0x68c320
00941F24 add esp, 8
00941F27 fstp dword ptr [ebp - 0xb0]
00941F2D fld dword ptr [ebp - 0xb0]
00941F33 mov edx, dword ptr [ebp - 0xa0]
00941F39 imul edx, edx, 0xc
00941F3C fstp dword ptr [ebp + edx - 0x98]
00941F43 mov eax, dword ptr [ebp - 0xa4]
00941F49 add eax, 2
00941F4C push eax
00941F4D mov ecx, dword ptr [ebp + 8]
00941F50 push ecx
00941F51 call 0x68c320
00941F56 add esp, 8
00941F59 fstp dword ptr [ebp - 0xb4]
00941F5F fld dword ptr [ebp - 0xb4]
00941F65 mov edx, dword ptr [ebp - 0xa0]
00941F6B imul edx, edx, 0xc
00941F6E fstp dword ptr [ebp + edx - 0x94]
00941F75 jmp 0x941eb4
00941F7A mov al, byte ptr [ebp - 0x69]
00941F7D mov byte ptr [ebp - 0x41], al
00941F80 mov ecx, dword ptr [ebp - 4]
00941F83 mov dword ptr [ebp - 0x40], ecx
00941F86 push 0x30
00941F88 lea edx, [ebp - 0x9c]
00941F8E push edx
00941F8F lea eax, [ebp - 0x3c]
00941F92 push eax
00941F93 call 0x6636a0
00941F98 add esp, 0xc
00941F9B push 0
00941F9D push 0
00941F9F push 0x5c
00941FA1 lea ecx, [ebp - 0x68]
00941FA4 push ecx
00941FA5 push 0x4fb3
00941FAA call 0xa3fbb0
00941FAF add esp, 0x14
00941FB2 movzx edx, byte ptr [ebp - 0x69]
00941FB6 push edx
00941FB7 lea eax, [ebp - 0x9c]
00941FBD push eax
00941FBE mov ecx, dword ptr [ebp - 4]
00941FC1 push ecx
00941FC2 mov edx, dword ptr [ebp - 0xa8]
00941FC8 mov eax, dword ptr [edx]
00941FCA mov ecx, dword ptr [ebp - 0xa8]
00941FD0 mov edx, dword ptr [eax + 0x114]
00941FD6 call edx
00941FD8 movzx eax, al
00941FDB test eax, eax
00941FDD jne 0x941ff4
00941FDF push 0xbad3a4
00941FE4 push 0
00941FE6 mov ecx, dword ptr [ebp + 8]
00941FE9 push ecx
00941FEA call 0x639f10
00941FEF add esp, 0xc
00941FF2 jmp 0x942004
00941FF4 push 0
00941FF6 push 1
00941FF8 mov edx, dword ptr [ebp + 8]
00941FFB push edx
00941FFC call 0x639f10
00942001 add esp, 0xc
00942004 mov esp, ebp
00942006 pop ebp
00942007 ret 4
; function 0x941c70
00941C70 push ebp
00941C71 mov ebp, esp
00941C73 sub esp, 0x34
00941C76 mov dword ptr [ebp - 0x34], ecx
00941C79 mov eax, dword ptr [ebp + 8]
00941C7C push eax
00941C7D call 0x68bb90
00941C82 add esp, 4
00941C85 cmp eax, 1
00941C88 jne 0x941c9c
00941C8A push 1
00941C8C mov ecx, dword ptr [ebp + 8]
00941C8F push ecx
00941C90 call 0x68c0c0
00941C95 add esp, 8
00941C98 test eax, eax
00941C9A jne 0x941cb1
00941C9C push 0xbad3cc
00941CA1 push 0
00941CA3 mov edx, dword ptr [ebp + 8]
00941CA6 push edx
00941CA7 call 0x639f10
00941CAC add esp, 0xc
00941CAF jmp 0x941d1f
00941CB1 push 1
00941CB3 mov eax, dword ptr [ebp + 8]
00941CB6 push eax
00941CB7 call 0x68c370
00941CBC add esp, 8
00941CBF mov dword ptr [ebp - 4], eax
00941CC2 mov ecx, dword ptr [ebp - 4]
00941CC5 mov dword ptr [ebp - 9], ecx
00941CC8 push 0
00941CCA push 0
00941CCC push 0x2b
00941CCE lea edx, [ebp - 0x30]
00941CD1 push edx
00941CD2 push 0x4fb4
00941CD7 call 0xa3fbb0
00941CDC add esp, 0x14
00941CDF mov eax, dword ptr [ebp - 4]
00941CE2 push eax
00941CE3 mov ecx, dword ptr [ebp - 0x34]
00941CE6 mov edx, dword ptr [ecx]
00941CE8 mov ecx, dword ptr [ebp - 0x34]
00941CEB mov eax, dword ptr [edx + 0x118]
00941CF1 call eax
00941CF3 movzx ecx, al
00941CF6 test ecx, ecx
00941CF8 jne 0x941d0f
00941CFA push 0xbad3e8
00941CFF push 0
00941D01 mov edx, dword ptr [ebp + 8]
00941D04 push edx
00941D05 call 0x639f10
00941D0A add esp, 0xc
00941D0D jmp 0x941d1f
00941D0F push 0
00941D11 push 1
00941D13 mov eax, dword ptr [ebp + 8]
00941D16 push eax
00941D17 call 0x639f10
00941D1C add esp, 0xc
00941D1F mov esp, ebp
00941D21 pop ebp
00941D22 ret 4
; function 0x827910
00827910 push ebp
00827911 mov ebp, esp
00827913 sub esp, 0xc
00827916 mov dword ptr [ebp - 0xc], ecx
00827919 cmp dword ptr [ebp + 8], 0
0082791D je 0x827925
0082791F cmp dword ptr [ebp + 0xc], 0x5c
00827923 je 0x827927
00827925 jmp 0x82797e
00827927 mov eax, dword ptr [ebp + 8]
0082792A mov dword ptr [ebp - 8], eax
0082792D push 0
0082792F push 0x12f8fe8
00827934 push 0x12f899c
00827939 mov ecx, dword ptr [0x17c8710]
0082793F call 0x453db0
00827944 push 0
00827946 push eax
00827947 call 0xa97b0e
0082794C add esp, 0x14
0082794F mov dword ptr [ebp - 4], eax
00827952 cmp dword ptr [ebp - 4], 0
00827956 je 0x82797e
00827958 mov ecx, dword ptr [ebp - 8]
0082795B movzx edx, byte ptr [ecx + 0x27]
0082795F push edx
00827960 mov eax, dword ptr [ebp - 8]
00827963 add eax, 0x2c
00827966 push eax
00827967 mov ecx, dword ptr [ebp - 8]
0082796A mov edx, dword ptr [ecx + 0x28]
0082796D push edx
0082796E mov eax, dword ptr [ebp - 4]
00827971 mov edx, dword ptr [eax]
00827973 mov ecx, dword ptr [ebp - 4]
00827976 mov eax, dword ptr [edx + 0x114]
0082797C call eax
0082797E mov esp, ebp
00827980 pop ebp
00827981 ret 8
; function 0x8278a0
008278A0 push ebp
008278A1 mov ebp, esp
008278A3 sub esp, 0xc
008278A6 mov dword ptr [ebp - 0xc], ecx
008278A9 cmp dword ptr [ebp + 8], 0
008278AD je 0x8278b5
008278AF cmp dword ptr [ebp + 0xc], 0x2b
008278B3 je 0x8278b7
008278B5 jmp 0x8278ff
008278B7 mov eax, dword ptr [ebp + 8]
008278BA mov dword ptr [ebp - 8], eax
008278BD push 0
008278BF push 0x12f8fe8
008278C4 push 0x12f899c
008278C9 mov ecx, dword ptr [0x17c8710]
008278CF call 0x453db0
008278D4 push 0
008278D6 push eax
008278D7 call 0xa97b0e
008278DC add esp, 0x14
008278DF mov dword ptr [ebp - 4], eax
008278E2 cmp dword ptr [ebp - 4], 0
008278E6 je 0x8278ff
008278E8 mov ecx, dword ptr [ebp - 8]
008278EB mov edx, dword ptr [ecx + 0x27]
008278EE push edx
008278EF mov eax, dword ptr [ebp - 4]
008278F2 mov edx, dword ptr [eax]
008278F4 mov ecx, dword ptr [ebp - 4]
008278F7 mov eax, dword ptr [edx + 0x118]
008278FD call eax
008278FF mov esp, ebp
00827901 pop ebp
00827902 ret 8
