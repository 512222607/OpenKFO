SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

FUNCTION 0xaf1aa5
00AF1AA5 mov dword ptr [0x12fc750], 0x872
00AF1AAF mov dword ptr [0x12fc754], 1
00AF1AB9 mov dword ptr [ebp - 0x250], 0xa2c2c0
00AF1AC3 mov dword ptr [ebp - 0x24c], 0
00AF1ACD mov dword ptr [ebp - 0x248], 0

FUNCTION 0xb230aa
00B230AA mov dword ptr [0x12fde78], 0x848
00B230B4 mov dword ptr [0x12fde7c], 1
00B230BE mov dword ptr [ebp - 0x30], 0x8263a0
00B230C5 mov dword ptr [ebp - 0x2c], 0
00B230CC mov dword ptr [ebp - 0x28], 0
00B230D3 mov dword ptr [ebp - 0x24], 0
00B230DA mov edx, dword ptr [ebp - 0x30]

FUNCTION 0xb231a2
00B231A2 mov dword ptr [0x12fdec0], 0x849
00B231AC mov dword ptr [0x12fdec4], 1
00B231B6 mov dword ptr [ebp - 0x60], 0x8266e0
00B231BD mov dword ptr [ebp - 0x5c], 0
00B231C4 mov dword ptr [ebp - 0x58], 0
00B231CB mov dword ptr [ebp - 0x54], 0
00B231D2 mov edx, dword ptr [ebp - 0x60]

FUNCTION 0xa2c2c0
00A2C2C0 push ebp
00A2C2C1 mov ebp, esp
00A2C2C3 sub esp, 0x10
00A2C2C6 mov dword ptr [ebp - 8], ecx
00A2C2C9 cmp dword ptr [ebp + 8], 0
00A2C2CD je 0xa2c2d5
00A2C2CF cmp dword ptr [ebp + 0xc], 4
00A2C2D3 je 0xa2c2d7
00A2C2D5 jmp 0xa2c33d
00A2C2D7 mov eax, dword ptr [ebp + 8]
00A2C2DA mov dword ptr [ebp - 4], eax
00A2C2DD mov ecx, dword ptr [ebp - 4]
00A2C2E0 mov edx, dword ptr [ecx]
00A2C2E2 push edx
00A2C2E3 mov ecx, dword ptr [0x17c86fc]
00A2C2E9 call 0x9ce160
00A2C2EE call 0x41bd60
00A2C2F3 mov dword ptr [ebp - 0xc], eax
00A2C2F6 mov eax, dword ptr [ebp - 4]
00A2C2F9 mov ecx, dword ptr [eax]
00A2C2FB push ecx
00A2C2FC mov edx, dword ptr [ebp - 0xc]
00A2C2FF mov eax, dword ptr [edx]
00A2C301 mov ecx, dword ptr [ebp - 0xc]
00A2C304 mov edx, dword ptr [eax + 0x1c8]
00A2C30A call edx
00A2C30C call 0x41c9c0
00A2C311 mov ecx, eax
00A2C313 call 0x41bb50
00A2C318 movzx eax, al
00A2C31B test eax, eax
00A2C31D je 0xa2c33d
00A2C31F call 0x41c9c0
00A2C324 mov dword ptr [ebp - 0x10], eax
00A2C327 mov ecx, dword ptr [ebp - 4]
00A2C32A mov edx, dword ptr [ecx]
00A2C32C push edx
00A2C32D mov eax, dword ptr [ebp - 0x10]
00A2C330 mov edx, dword ptr [eax]
00A2C332 mov ecx, dword ptr [ebp - 0x10]
00A2C335 mov eax, dword ptr [edx + 0x1c8]
00A2C33B call eax
00A2C33D mov esp, ebp
00A2C33F pop ebp

FUNCTION 0x9ce160
009CE160 push ebp
009CE161 mov ebp, esp
009CE163 sub esp, 0x2c
009CE166 mov dword ptr [ebp - 0x2c], ecx
009CE169 lea ecx, [ebp - 8]
009CE16C call 0x471ae0
009CE171 lea eax, [ebp - 0x10]
009CE174 push eax
009CE175 mov ecx, dword ptr [ebp - 0x2c]
009CE178 add ecx, 0xec8
009CE17E call 0x4d6050
009CE183 mov ecx, dword ptr [eax]
009CE185 mov edx, dword ptr [eax + 4]
009CE188 mov dword ptr [ebp - 8], ecx
009CE18B mov dword ptr [ebp - 4], edx
009CE18E jmp 0x9ce198
009CE190 lea ecx, [ebp - 8]
009CE193 call 0x50b5e0
009CE198 lea eax, [ebp - 0x18]
009CE19B push eax
009CE19C mov ecx, dword ptr [ebp - 0x2c]
009CE19F add ecx, 0xec8
009CE1A5 call 0x4f2590
009CE1AA push eax
009CE1AB lea ecx, [ebp - 8]
009CE1AE call 0x4ab8f0
009CE1B3 movzx ecx, al
009CE1B6 test ecx, ecx
009CE1B8 je 0x9ce1f3
009CE1BA lea ecx, [ebp - 8]
009CE1BD call 0x4b2c40
009CE1C2 mov edx, dword ptr [ebp + 8]
009CE1C5 cmp edx, dword ptr [eax]
009CE1C7 jne 0x9ce1f1
009CE1C9 mov eax, dword ptr [ebp - 8]
009CE1CC mov dword ptr [ebp - 0x20], eax
009CE1CF mov ecx, dword ptr [ebp - 4]
009CE1D2 mov dword ptr [ebp - 0x1c], ecx
009CE1D5 mov edx, dword ptr [ebp - 0x1c]
009CE1D8 push edx
009CE1D9 mov eax, dword ptr [ebp - 0x20]
009CE1DC push eax
009CE1DD lea ecx, [ebp - 0x28]
009CE1E0 push ecx
009CE1E1 mov ecx, dword ptr [ebp - 0x2c]
009CE1E4 add ecx, 0xec8
009CE1EA call 0x45e710
009CE1EF jmp 0x9ce1f3
009CE1F1 jmp 0x9ce190
009CE1F3 mov esp, ebp
009CE1F5 pop ebp

FUNCTION 0x8263a0
008263A0 push ebp
008263A1 mov ebp, esp
008263A3 sub esp, 0x10
008263A6 mov dword ptr [ebp - 0x10], ecx
008263A9 mov eax, dword ptr [ebp + 8]
008263AC mov dword ptr [ebp - 4], eax
008263AF mov ecx, dword ptr [ebp + 8]
008263B2 add ecx, 4
008263B5 mov dword ptr [ebp - 8], ecx
008263B8 mov dword ptr [ebp - 0xc], 0
008263BF jmp 0x8263d3
008263C1 mov edx, dword ptr [ebp - 0xc]
008263C4 add edx, 1
008263C7 mov dword ptr [ebp - 0xc], edx
008263CA mov eax, dword ptr [ebp - 8]
008263CD add eax, 4
008263D0 mov dword ptr [ebp - 8], eax
008263D3 mov ecx, dword ptr [ebp - 4]
008263D6 mov edx, dword ptr [ebp - 0xc]
008263D9 cmp edx, dword ptr [ecx]
008263DB jge 0x8263f2
008263DD push 2
008263DF mov eax, dword ptr [ebp - 8]
008263E2 mov ecx, dword ptr [eax]
008263E4 push ecx
008263E5 mov ecx, dword ptr [0x17c86fc]
008263EB call 0x9cd7c0
008263F0 jmp 0x8263c1
008263F2 mov edx, dword ptr [ebp - 0x10]
008263F5 mov eax, dword ptr [edx]
008263F7 mov ecx, dword ptr [ebp - 0x10]
008263FA mov edx, dword ptr [eax + 0x14]
008263FD call edx
008263FF mov esp, ebp
00826401 pop ebp

FUNCTION 0x8266e0
008266E0 push ebp
008266E1 mov ebp, esp
008266E3 push -1
008266E5 push 0xacc4bf
008266EA mov eax, dword ptr fs:[0]
008266F0 push eax
008266F1 sub esp, 0xc4
008266F7 push esi
008266F8 push edi
008266F9 mov eax, dword ptr [0xc7b480]
008266FE xor eax, ebp
00826700 push eax
00826701 lea eax, [ebp - 0xc]
00826704 mov dword ptr fs:[0], eax
0082670A mov dword ptr [ebp - 0xd0], ecx
00826710 mov eax, dword ptr [ebp + 8]
00826713 mov dword ptr [ebp - 0x18], eax
00826716 mov ecx, dword ptr [ebp + 8]
00826719 add ecx, 4
0082671C mov dword ptr [ebp - 0x14], ecx
0082671F mov dword ptr [ebp - 0x10], 0
00826726 mov dword ptr [ebp - 0x68], 0
0082672D jmp 0x826741
0082672F mov edx, dword ptr [ebp - 0x68]
00826732 add edx, 1
00826735 mov dword ptr [ebp - 0x68], edx
00826738 mov eax, dword ptr [ebp - 0x14]
0082673B add eax, 4
0082673E mov dword ptr [ebp - 0x14], eax
00826741 mov ecx, dword ptr [ebp - 0x18]
00826744 mov edx, dword ptr [ebp - 0x68]
00826747 cmp edx, dword ptr [ecx]
00826749 jge 0x826850
0082674F push 2
00826751 mov eax, dword ptr [ebp - 0x14]
00826754 mov ecx, dword ptr [eax]
00826756 push ecx
00826757 mov ecx, dword ptr [0x17c86fc]
0082675D call 0x9cd7c0
00826762 mov edx, dword ptr [ebp - 0x14]
00826765 mov eax, dword ptr [edx]
00826767 push eax
00826768 lea ecx, [ebp - 0xb0]
0082676E push ecx
0082676F mov ecx, dword ptr [0x17c86fc]
00826775 call 0x9cd840
0082677A mov ecx, 0x11
0082677F mov esi, eax
00826781 lea edi, [ebp - 0x64]
00826784 rep movsd dword ptr es:[edi], dword ptr [esi]
00826786 mov edx, dword ptr [ebp - 0x5f]
00826789 push edx
0082678A call 0xa21b30
0082678F mov ecx, eax
00826791 call 0xa1e560
00826796 mov dword ptr [ebp - 0x10], eax
00826799 cmp dword ptr [ebp - 0x10], 0
0082679D je 0x82684b
008267A3 lea ecx, [ebp - 0x6c]
008267A6 call 0x405f90
008267AB mov dword ptr [ebp - 4], 0
008267B2 mov eax, dword ptr [ebp - 0x10]
008267B5 cmp dword ptr [eax], 0x43
008267B8 jbe 0x8267dc
008267BA mov ecx, dword ptr [ebp - 0x10]
008267BD cmp dword ptr [ecx], 0x61
008267C0 jae 0x8267dc
008267C2 mov edx, dword ptr [ebp - 0x10]
008267C5 mov eax, dword ptr [edx + 0xc]
008267C8 push eax
008267C9 push 0xbcae38
008267CE lea ecx, [ebp - 0x6c]
008267D1 push ecx
008267D2 call 0x411c60
008267D7 add esp, 0xc
008267DA jmp 0x8267f4
008267DC mov edx, dword ptr [ebp - 0x10]
008267DF mov eax, dword ptr [edx + 0xc]
008267E2 push eax
008267E3 push 0xbcae94
008267E8 lea ecx, [ebp - 0x6c]
008267EB push ecx
008267EC call 0x411c60
008267F1 add esp, 0xc
008267F4 lea ecx, [ebp - 0x6c]
008267F7 call 0x406410
008267FC push eax
008267FD lea ecx, [ebp - 0xcc]
00826803 call 0x405650
00826808 mov byte ptr [ebp - 4], 1
0082680C mov edx, dword ptr [ebp - 0x10]
0082680F add edx, 0x44
00826812 push edx
00826813 lea eax, [ebp - 0xcc]
00826819 push eax
0082681A mov ecx, dword ptr [ebp - 0xd0]
00826820 mov edx, dword ptr [ecx]
00826822 mov ecx, dword ptr [ebp - 0xd0]
00826828 mov eax, dword ptr [edx + 0x1c]
0082682B call eax
0082682D mov byte ptr [ebp - 4], 0
00826831 lea ecx, [ebp - 0xcc]
00826837 call 0x4056d0
0082683C mov dword ptr [ebp - 4], 0xffffffff
00826843 lea ecx, [ebp - 0x6c]
00826846 call 0x406050
0082684B jmp 0x82672f
