; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 012FDDA0 static registry: 960500000100000000000000000000000000000000000000
 ; opcode 1430, kind 1; B22DD6 installs 826B30 into callback slot 012FDDA8.
; RANGE 00B22DD0-00B22E14
00B22DD0 push ebp
00B22DD1 mov ebp, esp
00B22DD3 sub esp, 0x70
00B22DD6 mov dword ptr [ebp - 0x10], 0x826b30
00B22DDD mov dword ptr [ebp - 0xc], 0
00B22DE4 mov dword ptr [ebp - 8], 0
00B22DEB mov dword ptr [ebp - 4], 0
00B22DF2 mov eax, dword ptr [ebp - 0x10]
00B22DF5 mov dword ptr [0x12fdda8], eax
00B22DFA mov ecx, dword ptr [ebp - 0xc]
00B22DFD mov dword ptr [0x12fddac], ecx
00B22E03 mov edx, dword ptr [ebp - 8]
00B22E06 mov dword ptr [0x12fddb0], edx
00B22E0C mov eax, dword ptr [ebp - 4]
00B22E0F mov dword ptr [0x12fddb4], eax
; RANGE 00826B30-00826C2D
00826B30 push ebp
00826B31 mov ebp, esp
00826B33 push -1
00826B35 push 0xadadb9
00826B3A mov eax, dword ptr fs:[0]
00826B40 push eax
00826B41 sub esp, 0x4c
00826B44 mov eax, dword ptr [0xc7b480]
00826B49 xor eax, ebp
00826B4B push eax
00826B4C lea eax, [ebp - 0xc]
00826B4F mov dword ptr fs:[0], eax
00826B55 mov dword ptr [ebp - 0x4c], ecx
00826B58 mov eax, dword ptr [ebp + 8]
00826B5B mov dword ptr [ebp - 0x10], eax
00826B5E mov ecx, dword ptr [ebp - 0x10]
00826B61 movzx edx, byte ptr [ecx]
00826B64 test edx, edx
00826B66 je 0x826bd7
00826B68 mov eax, dword ptr [ebp - 0x10]
00826B6B mov ecx, dword ptr [eax + 1]
00826B6E push ecx
00826B6F call 0x4e76b0
00826B74 mov ecx, eax
00826B76 call 0x8bc1a0
00826B7B push 0xbcadd4
00826B80 lea ecx, [ebp - 0x2c]
00826B83 call 0x405650
00826B88 mov dword ptr [ebp - 4], 0
00826B8F call 0x403820
00826B94 mov dword ptr [ebp - 0x50], eax
00826B97 push 0
00826B99 push 0
00826B9B push 0
00826B9D lea edx, [ebp - 0x2c]
00826BA0 push edx
00826BA1 mov eax, dword ptr [ebp - 0x50]
00826BA4 mov edx, dword ptr [eax]
00826BA6 mov ecx, dword ptr [ebp - 0x50]
00826BA9 mov eax, dword ptr [edx + 0x1c0]
00826BAF call eax
00826BB1 mov dword ptr [ebp - 4], 0xffffffff
00826BB8 lea ecx, [ebp - 0x2c]
00826BBB call 0x4056d0
00826BC0 call 0x41b980
00826BC5 mov dword ptr [ebp - 0x54], eax
00826BC8 mov ecx, dword ptr [ebp - 0x54]
00826BCB mov edx, dword ptr [ecx]
00826BCD mov ecx, dword ptr [ebp - 0x54]
00826BD0 mov eax, dword ptr [edx + 0x1c]
00826BD3 call eax
00826BD5 jmp 0x826c1c
00826BD7 push 0xbcade8
00826BDC lea ecx, [ebp - 0x48]
00826BDF call 0x405650
00826BE4 mov dword ptr [ebp - 4], 1
00826BEB call 0x403820
00826BF0 mov dword ptr [ebp - 0x58], eax
00826BF3 push 0
00826BF5 push 0
00826BF7 push 0
00826BF9 lea ecx, [ebp - 0x48]
00826BFC push ecx
00826BFD mov edx, dword ptr [ebp - 0x58]
00826C00 mov eax, dword ptr [edx]
00826C02 mov ecx, dword ptr [ebp - 0x58]
00826C05 mov edx, dword ptr [eax + 0x1c0]
00826C0B call edx
00826C0D mov dword ptr [ebp - 4], 0xffffffff
00826C14 lea ecx, [ebp - 0x48]
00826C17 call 0x4056d0
00826C1C mov ecx, dword ptr [ebp - 0xc]
00826C1F mov dword ptr fs:[0], ecx
00826C26 pop ecx
00826C27 mov esp, ebp
00826C29 pop ebp
00826C2A ret 8
; RANGE 00823FD0-00824149
00823FD0 push ebp
00823FD1 mov ebp, esp
00823FD3 push -1
00823FD5 push 0xadad08
00823FDA mov eax, dword ptr fs:[0]
00823FE0 push eax
00823FE1 sub esp, 0xac
00823FE7 mov eax, dword ptr [0xc7b480]
00823FEC xor eax, ebp
00823FEE mov dword ptr [ebp - 0x10], eax
00823FF1 push esi
00823FF2 push edi
00823FF3 push eax
00823FF4 lea eax, [ebp - 0xc]
00823FF7 mov dword ptr fs:[0], eax
00823FFD mov dword ptr [ebp - 0xb8], ecx
00824003 mov eax, dword ptr [ebp + 8]
00824006 mov dword ptr [ebp - 0x8c], eax
0082400C mov eax, dword ptr [ebp + 0xc]
0082400F xor edx, edx
00824011 mov ecx, 0x6c
00824016 div ecx
00824018 mov dword ptr [ebp - 0x88], eax
0082401E lea ecx, [ebp - 0xa8]
00824024 call 0x5016d0
00824029 mov dword ptr [ebp - 4], 0
00824030 push 0x6c
00824032 push 0
00824034 lea edx, [ebp - 0x84]
0082403A push edx
0082403B call 0x666960
00824040 add esp, 0xc
00824043 mov dword ptr [ebp - 0xac], 0
0082404D jmp 0x82406d
0082404F mov eax, dword ptr [ebp - 0xac]
00824055 add eax, 1
00824058 mov dword ptr [ebp - 0xac], eax
0082405E mov ecx, dword ptr [ebp - 0x8c]
00824064 add ecx, 0x6c
00824067 mov dword ptr [ebp - 0x8c], ecx
0082406D mov edx, dword ptr [ebp - 0xac]
00824073 cmp edx, dword ptr [ebp - 0x88]
00824079 jge 0x8240b6
0082407B mov eax, dword ptr [ebp - 0x8c]
00824081 push eax
00824082 lea ecx, [ebp - 0xa8]
00824088 call 0x524650
0082408D mov ecx, dword ptr [ebp - 0x8c]
00824093 movzx edx, byte ptr [ecx + 0x30]
00824097 test edx, edx
00824099 je 0x8240b4
0082409B cmp dword ptr [ebp - 0x7b], 0
0082409F jne 0x8240b4
008240A1 mov esi, dword ptr [ebp - 0x8c]
008240A7 mov ecx, 0x1b
008240AC lea edi, [ebp - 0x84]
008240B2 rep movsd dword ptr es:[edi], dword ptr [esi]
008240B4 jmp 0x82404f
008240B6 lea ecx, [ebp - 0xa8]
008240BC call 0x586880
008240C1 movzx eax, al
008240C4 test eax, eax
008240C6 jne 0x82411a
008240C8 lea ecx, [ebp - 0xa8]
008240CE push ecx
008240CF call 0x41bc70
008240D4 mov ecx, eax
008240D6 call 0x85c040
008240DB lea edx, [ebp - 0xb4]
008240E1 push edx
008240E2 lea ecx, [ebp - 0xa8]
008240E8 call 0x561740
008240ED mov ecx, eax
008240EF call 0x58a020
008240F4 push eax
008240F5 call 0x504b60
008240FA mov ecx, eax
008240FC call 0x8c2aa0
00824101 cmp dword ptr [ebp - 0x7b], 0
00824105 jbe 0x82411a
00824107 lea eax, [ebp - 0x84]
0082410D push eax
0082410E call 0x4fa880
00824113 mov ecx, eax
00824115 call 0x8402b0
0082411A mov dword ptr [ebp - 4], 0xffffffff
00824121 lea ecx, [ebp - 0xa8]
00824127 call 0x5327c0
0082412C mov ecx, dword ptr [ebp - 0xc]
0082412F mov dword ptr fs:[0], ecx
00824136 pop ecx
00824137 pop edi
00824138 pop esi
00824139 mov ecx, dword ptr [ebp - 0x10]
0082413C xor ecx, ebp
0082413E call 0x6634fb
00824143 mov esp, ebp
00824145 pop ebp
00824146 ret 8
; RANGE 008C2AA0-008C2AE9
008C2AA0 push ebp
008C2AA1 mov ebp, esp
008C2AA3 push -1
008C2AA5 push 0xad21e8
008C2AAA mov eax, dword ptr fs:[0]
008C2AB0 push eax
008C2AB1 sub esp, 0x50c
008C2AB7 mov eax, dword ptr [0xc7b480]
008C2ABC xor eax, ebp
008C2ABE mov dword ptr [ebp - 0x10], eax
008C2AC1 push esi
008C2AC2 push edi
008C2AC3 push eax
008C2AC4 lea eax, [ebp - 0xc]
008C2AC7 mov dword ptr fs:[0], eax
008C2ACD mov dword ptr [ebp - 0x4b8], ecx
008C2AD3 mov esi, dword ptr [ebp + 8]
008C2AD6 mov edi, dword ptr [ebp - 0x4b8]
008C2ADC add edi, 0x5f4
008C2AE2 mov ecx, 0x1b
008C2AE7 rep movsd dword ptr es:[edi], dword ptr [esi]
