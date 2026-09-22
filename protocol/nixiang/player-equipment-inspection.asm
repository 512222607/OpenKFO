; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; block 0x8055e0
008055E0 push ebp
008055E1 mov ebp, esp
008055E3 push -1
008055E5 push 0xadfc67
008055EA mov eax, dword ptr fs:[0]
008055F0 push eax
008055F1 sub esp, 0xa78
008055F7 mov eax, dword ptr [0xc7b480]
008055FC xor eax, ebp
008055FE mov dword ptr [ebp - 0x10], eax
00805601 push esi
00805602 push edi
00805603 push eax
00805604 lea eax, [ebp - 0xc]
00805607 mov dword ptr fs:[0], eax
0080560D mov dword ptr [ebp - 0xa64], ecx
00805613 mov eax, dword ptr [ebp - 0xa64]
00805619 mov dword ptr [ebp - 0xa68], eax
0080561F mov ecx, dword ptr [ebp - 0xa68]
00805625 mov edx, dword ptr [ebp - 0xa68]
0080562B mov eax, dword ptr [ecx + 0x5b0]
00805631 or eax, dword ptr [edx + 0x5b4]
00805637 jne 0x80563e
00805639 jmp 0x805830
0080563E mov ecx, dword ptr [0x17c86fc]
00805644 call 0x402aa0
00805649 mov ecx, dword ptr [ebp - 0xa64]
0080564F mov dword ptr [ebp - 0xa6c], ecx
00805655 mov dword ptr [ebp - 0xa74], eax
0080565B mov dword ptr [ebp - 0xa70], edx
00805661 mov edx, dword ptr [ebp - 0xa6c]
00805667 mov eax, dword ptr [edx + 0x5b0]
0080566D cmp eax, dword ptr [ebp - 0xa74]
00805673 jne 0x8056af
00805675 mov ecx, dword ptr [ebp - 0xa6c]
0080567B mov edx, dword ptr [ecx + 0x5b4]
00805681 cmp edx, dword ptr [ebp - 0xa70]
00805687 jne 0x8056af
00805689 call 0x41c9c0
0080568E mov dword ptr [ebp - 0xa78], eax
00805694 mov eax, dword ptr [ebp - 0xa78]
0080569A mov edx, dword ptr [eax]
0080569C mov ecx, dword ptr [ebp - 0xa78]
008056A2 mov eax, dword ptr [edx + 0x108]
008056A8 call eax
008056AA jmp 0x805830
008056AF push 8
008056B1 push 0
008056B3 lea ecx, [ebp - 0x584]
008056B9 push ecx
008056BA call 0x666960
008056BF add esp, 0xc
008056C2 mov edx, dword ptr [ebp - 0xa64]
008056C8 mov eax, dword ptr [edx + 0x5b0]
008056CE mov dword ptr [ebp - 0x584], eax
008056D4 mov ecx, dword ptr [edx + 0x5b4]
008056DA mov dword ptr [ebp - 0x580], ecx
008056E0 push 8
008056E2 lea edx, [ebp - 0x584]
008056E8 push edx
008056E9 push 0
008056EB push 0xa1e
008056F0 call 0xa3c950
008056F5 add esp, 0x10
008056F8 lea ecx, [ebp - 0xa5c]
; block 0x81e850
0081E850 push ebp
0081E851 mov ebp, esp
0081E853 push -1
0081E855 push 0xad77b9
0081E85A mov eax, dword ptr fs:[0]
0081E860 push eax
0081E861 sub esp, 0x28
0081E864 mov eax, dword ptr [0xc7b480]
0081E869 xor eax, ebp
0081E86B push eax
0081E86C lea eax, [ebp - 0xc]
0081E86F mov dword ptr fs:[0], eax
0081E875 mov dword ptr [ebp - 0x34], ecx
0081E878 mov eax, dword ptr [ebp + 0xc]
0081E87B xor edx, edx
0081E87D mov ecx, 0x44
0081E882 div ecx
0081E884 mov dword ptr [ebp - 0x10], eax
0081E887 mov edx, dword ptr [ebp + 8]
0081E88A mov dword ptr [ebp - 0x14], edx
0081E88D lea ecx, [ebp - 0x2c]
0081E890 call 0x45e410
0081E895 mov dword ptr [ebp - 4], 0
0081E89C mov dword ptr [ebp - 0x30], 0
0081E8A3 jmp 0x81e8b7
0081E8A5 mov eax, dword ptr [ebp - 0x30]
0081E8A8 add eax, 1
0081E8AB mov dword ptr [ebp - 0x30], eax
0081E8AE mov ecx, dword ptr [ebp - 0x14]
0081E8B1 add ecx, 0x44
0081E8B4 mov dword ptr [ebp - 0x14], ecx
0081E8B7 mov edx, dword ptr [ebp - 0x30]
0081E8BA cmp edx, dword ptr [ebp - 0x10]
0081E8BD jge 0x81e8cd
0081E8BF mov eax, dword ptr [ebp - 0x14]
0081E8C2 push eax
0081E8C3 lea ecx, [ebp - 0x2c]
0081E8C6 call 0x4b29e0
0081E8CB jmp 0x81e8a5
0081E8CD lea ecx, [ebp - 0x2c]
0081E8D0 push ecx
0081E8D1 call 0x5117c0
0081E8D6 mov ecx, eax
0081E8D8 call 0x872da0
0081E8DD mov dword ptr [ebp - 4], 0xffffffff
0081E8E4 lea ecx, [ebp - 0x2c]
0081E8E7 call 0x46ea80
0081E8EC mov ecx, dword ptr [ebp - 0xc]
0081E8EF mov dword ptr fs:[0], ecx
0081E8F6 pop ecx
0081E8F7 mov esp, ebp
0081E8F9 pop ebp
0081E8FA ret 8
0081E8FD int3
0081E8FE int3
0081E8FF int3
; block 0x872da0
00872DA0 push ebp
00872DA1 mov ebp, esp
00872DA3 sub esp, 0x34
00872DA6 mov dword ptr [ebp - 0x34], ecx
00872DA9 mov ecx, dword ptr [ebp - 0x34]
00872DAC add ecx, 0x5e8
00872DB2 call 0x45e780
00872DB7 lea eax, [ebp - 8]
00872DBA push eax
00872DBB mov ecx, dword ptr [ebp - 0x34]
00872DBE add ecx, 0x5e8
00872DC4 call 0x4d6050
00872DC9 mov ecx, dword ptr [eax + 4]
00872DCC push ecx
00872DCD mov edx, dword ptr [eax]
00872DCF push edx
00872DD0 mov eax, dword ptr [ebp - 0x34]
00872DD3 add eax, 0x5e8
00872DD8 push eax
00872DD9 lea ecx, [ebp - 0x14]
00872DDC push ecx
00872DDD call 0x419580
00872DE2 add esp, 4
00872DE5 mov edx, esp
00872DE7 mov ecx, dword ptr [eax]
00872DE9 mov dword ptr [edx], ecx
00872DEB mov ecx, dword ptr [eax + 4]
00872DEE mov dword ptr [edx + 4], ecx
00872DF1 mov eax, dword ptr [eax + 8]
00872DF4 mov dword ptr [edx + 8], eax
00872DF7 lea ecx, [ebp - 0x1c]
00872DFA push ecx
00872DFB mov ecx, dword ptr [ebp + 8]
00872DFE call 0x4330d0
00872E03 mov edx, dword ptr [eax + 4]
00872E06 push edx
00872E07 mov eax, dword ptr [eax]
00872E09 push eax
00872E0A lea ecx, [ebp - 0x24]
00872E0D push ecx
00872E0E mov ecx, dword ptr [ebp + 8]
00872E11 call 0x4f9410
00872E16 mov edx, dword ptr [eax + 4]
00872E19 push edx
00872E1A mov eax, dword ptr [eax]
00872E1C push eax
00872E1D lea ecx, [ebp - 0x30]
00872E20 push ecx
00872E21 call 0x513b70
00872E26 add esp, 0x20
00872E29 mov ecx, dword ptr [ebp - 0x34]
00872E2C call 0x872950
00872E31 mov ecx, dword ptr [ebp - 0x34]
00872E34 call 0x8716e0
00872E39 mov esp, ebp
00872E3B pop ebp
00872E3C ret 4
00872E3F int3
; block 0xb26905
00B26905 mov dword ptr [0x12fec70], 0xa1f
00B2690F mov dword ptr [0x12fec74], 1
00B26919 mov dword ptr [ebp - 0x100], 0x81e850
00B26923 mov dword ptr [ebp - 0xfc], 0
00B2692D mov dword ptr [ebp - 0xf8], 0
00B26937 mov dword ptr [ebp - 0xf4], 0
00B26941 mov eax, dword ptr [ebp - 0x100]
00B26947 mov dword ptr [0x12fec78], eax
00B2694C mov ecx, dword ptr [ebp - 0xfc]
00B26952 mov dword ptr [0x12fec7c], ecx
00B26958 mov edx, dword ptr [ebp - 0xf8]
00B2695E mov dword ptr [0x12fec80], edx
