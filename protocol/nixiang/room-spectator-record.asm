; Source SHA256: 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Record +76 is spectator membership, not an equipment-update flag.

; Block 0xb2642a
00B2642A mov dword ptr [0x12feb38], 0xc12
00B26434 mov dword ptr [0x12feb3c], 1
00B2643E mov dword ptr [ebp - 0x30], 0x81eea0
00B26445 mov dword ptr [ebp - 0x2c], 0

; Block 0x81eea0
0081EEA0 push ebp
0081EEA1 mov ebp, esp
0081EEA3 sub esp, 0x4e4
0081EEA9 mov dword ptr [ebp - 0x4e4], ecx
0081EEAF cmp dword ptr [ebp + 8], 0
0081EEB3 jne 0x81eeba
0081EEB5 jmp 0x81f015
0081EEBA mov eax, dword ptr [ebp + 8]
0081EEBD mov dword ptr [ebp - 0x4dc], eax
0081EEC3 mov ecx, dword ptr [ebp - 0x4dc]
0081EEC9 movzx edx, byte ptr [ecx + 0x90]
0081EED0 mov dword ptr [0x17c86d4], edx
0081EED6 mov dword ptr [ebp - 4], 0
0081EEDD mov eax, dword ptr [ebp - 0x4dc]
0081EEE3 add eax, 0x95
0081EEE8 mov dword ptr [ebp - 4], eax
0081EEEB lea ecx, [ebp - 0x4d8]
0081EEF1 call 0x561d00
0081EEF6 mov ecx, dword ptr [ebp - 0x4dc]
0081EEFC movzx edx, byte ptr [ecx + 0x38]
0081EF00 push edx
0081EF01 mov eax, dword ptr [ebp - 0x4dc]
0081EF07 movzx ecx, byte ptr [eax + 0x36]
0081EF0B push ecx
0081EF0C mov edx, dword ptr [ebp - 0x4dc]
0081EF12 movzx eax, byte ptr [edx + 0x40]
0081EF16 push eax
0081EF17 mov ecx, dword ptr [ebp - 4]
0081EF1A push ecx
0081EF1B lea edx, [ebp - 0x4d8]
0081EF21 push edx
0081EF22 call 0xa3ecc0
0081EF27 add esp, 0x14
0081EF2A mov eax, dword ptr [ebp - 0x4dc]
0081EF30 movzx ecx, byte ptr [eax + 0x4c]
0081EF34 test ecx, ecx
0081EF36 je 0x81ef67
0081EF38 push 1
0081EF3A push 1
0081EF3C lea edx, [ebp - 0x4d8]
0081EF42 push edx
0081EF43 mov eax, dword ptr [ebp - 0x4dc]
0081EF49 push eax
0081EF4A mov ecx, dword ptr [ebp - 0x4dc]
0081EF50 mov edx, dword ptr [ecx + 4]
0081EF53 push edx
0081EF54 mov eax, dword ptr [ecx]
0081EF56 push eax
0081EF57 mov ecx, dword ptr [0x17c8708]
0081EF5D call 0x81be60
0081EF62 jmp 0x81f015
0081EF67 push 1
0081EF69 lea ecx, [ebp - 0x4d8]
0081EF6F push ecx
0081EF70 mov edx, dword ptr [ebp - 0x4dc]
0081EF76 push edx
0081EF77 mov eax, dword ptr [ebp - 0x4dc]
0081EF7D mov ecx, dword ptr [eax + 4]
0081EF80 push ecx
0081EF81 mov edx, dword ptr [eax]
0081EF83 push edx
0081EF84 mov ecx, dword ptr [0x17c8708]
0081EF8A call 0x81cf10
0081EF8F mov dword ptr [ebp - 0x4e0], eax
0081EF95 mov eax, dword ptr [ebp - 0x4dc]
0081EF9B mov ecx, dword ptr [eax + 0x88]
0081EFA1 push ecx
0081EFA2 mov ecx, dword ptr [ebp - 0x4e0]
0081EFA8 call 0x54ab30
0081EFAD mov edx, dword ptr [ebp - 0x4dc]
0081EFB3 mov eax, dword ptr [edx + 0x91]
0081EFB9 push eax
0081EFBA mov ecx, dword ptr [ebp - 0x4e0]
0081EFC0 call 0x54ab50
0081EFC5 cmp dword ptr [0x17c86d4], 0
0081EFCC setne cl
0081EFCF movzx edx, cl
0081EFD2 push edx
0081EFD3 mov ecx, dword ptr [ebp - 0x4e0]
0081EFD9 call 0x5118e0
0081EFDE cmp dword ptr [ebp - 0x4e0], 0
0081EFE5 je 0x81f015
0081EFE7 push 1
0081EFE9 mov eax, dword ptr [ebp - 0x4e0]
0081EFEF push eax
0081EFF0 mov ecx, dword ptr [0x17c8708]
0081EFF6 call 0x819d70
0081EFFB mov ecx, dword ptr [ebp - 0x4e0]
0081F001 push ecx
0081F002 mov edx, dword ptr [ebp - 0x4e4]
0081F008 mov eax, dword ptr [edx]
0081F00A mov ecx, dword ptr [ebp - 0x4e4]
0081F010 mov edx, dword ptr [eax + 0x14]
0081F013 call edx
0081F015 mov esp, ebp
0081F017 pop ebp

; Block 0x824633
00824633 mov dword ptr [ebp - 0xa8], ecx
00824639 mov dword ptr [ebp - 0xa0], 0
00824643 mov edx, dword ptr [ebp - 0x10]
00824646 movzx eax, byte ptr [edx + 0xa]
0082464A cmp eax, 8
0082464D jne 0x82468d
0082464F mov ecx, dword ptr [ebp - 0xa8]
00824655 mov byte ptr [ecx + 0x4c], 1
00824659 push 1
0082465B push 1
0082465D mov ecx, dword ptr [0x17c86fc]
00824663 call 0x453bc0
00824668 push eax
00824669 mov edx, dword ptr [ebp - 0xa8]
0082466F push edx
00824670 mov ecx, dword ptr [0x17c86fc]
00824676 call 0x402aa0
0082467B push edx
0082467C push eax
0082467D mov ecx, dword ptr [0x17c8708]
00824683 call 0x81be60
00824688 jmp 0x824815
0082468D mov eax, dword ptr [ebp - 0xa8]
00824693 mov byte ptr [eax + 0x4c], 0

; Block 0x81cb00
0081CB00 push ebp
0081CB01 mov ebp, esp
0081CB03 push -1
0081CB05 push 0xadf557
0081CB0A mov eax, dword ptr fs:[0]
0081CB10 push eax
0081CB11 sub esp, 0x58
0081CB14 mov eax, dword ptr [0xc7b480]
0081CB19 xor eax, ebp
0081CB1B push eax
0081CB1C lea eax, [ebp - 0xc]
0081CB1F mov dword ptr fs:[0], eax
0081CB25 mov dword ptr [ebp - 0x4c], ecx
0081CB28 cmp dword ptr [ebp + 0x10], 0
0081CB2C jl 0x81cb40
0081CB2E cmp dword ptr [ebp + 0x10], 7
0081CB32 ja 0x81cb40
0081CB34 cmp dword ptr [ebp + 0x20], 0
0081CB38 je 0x81cb40
0081CB3A cmp dword ptr [ebp + 0x24], 0
0081CB3E jne 0x81cb47
0081CB40 xor eax, eax
0081CB42 jmp 0x81cefe
0081CB47 lea eax, [ebp + 0x10]
0081CB4A push eax
0081CB4B mov ecx, dword ptr [ebp - 0x4c]
0081CB4E add ecx, 0x2d8
0081CB54 call 0x4b6920
0081CB59 cmp dword ptr [eax], 0
0081CB5C je 0x81cb6a
0081CB5E mov ecx, dword ptr [ebp + 0x10]
0081CB61 push ecx
0081CB62 mov ecx, dword ptr [ebp - 0x4c]
0081CB65 call 0x81bc10

; Block 0x81be60
0081BE60 push ebp
0081BE61 mov ebp, esp
0081BE63 push -1
0081BE65 push 0xadb6c6
0081BE6A mov eax, dword ptr fs:[0]
0081BE70 push eax
0081BE71 sub esp, 0x5a0
0081BE77 mov eax, dword ptr [0xc7b480]
0081BE7C xor eax, ebp
0081BE7E mov dword ptr [ebp - 0x10], eax
0081BE81 push esi
0081BE82 push edi
0081BE83 push eax
0081BE84 lea eax, [ebp - 0xc]
0081BE87 mov dword ptr fs:[0], eax
0081BE8D mov dword ptr [ebp - 0x59c], ecx
0081BE93 lea ecx, [ebp - 0x57c]
0081BE99 call 0x511aa0
0081BE9E mov esi, dword ptr [ebp + 0x10]
0081BEA1 mov ecx, 0x25
0081BEA6 lea edi, [ebp - 0x57c]
0081BEAC rep movsd dword ptr es:[edi], dword ptr [esi]
0081BEAE movsb byte ptr es:[edi], byte ptr [esi]
0081BEAF mov esi, dword ptr [ebp + 0x14]
0081BEB2 mov ecx, 0x134
0081BEB7 lea edi, [ebp - 0x4e4]
0081BEBD rep movsd dword ptr es:[edi], dword ptr [esi]
0081BEBF lea eax, [ebp + 8]
0081BEC2 push eax
0081BEC3 mov ecx, dword ptr [ebp - 0x59c]
0081BEC9 add ecx, 0x98
0081BECF call 0x511c80
0081BED4 mov ecx, 0x15a
0081BED9 lea esi, [ebp - 0x57c]
0081BEDF mov edi, eax
0081BEE1 rep movsd dword ptr es:[edi], dword ptr [esi]
