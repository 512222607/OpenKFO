; gfld.dat sha256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
00B23DED mov dword ptr [0x12fe1f0], 0x816
00B23DF7 mov dword ptr [0x12fe1f4], 1
00B23E01 mov dword ptr [ebp - 0x40], 0x824150
00B23E08 mov dword ptr [ebp - 0x3c], 0
00B23E0F mov dword ptr [ebp - 0x38], 0
00B23E16 mov dword ptr [ebp - 0x34], 0
00B23E1D mov eax, dword ptr [ebp - 0x40]
00B24D47 mov dword ptr [0x12fe598], 0x816
00B24D51 mov dword ptr [0x12fe59c], 1
00B24D5B mov dword ptr [ebp - 0x30], 0x822470
00B24D62 mov dword ptr [ebp - 0x2c], 0
00B24D69 mov dword ptr [ebp - 0x28], 0
00B24D70 mov dword ptr [ebp - 0x24], 0
00B24D77 mov edx, dword ptr [ebp - 0x30]
00824150 push ebp
00824151 mov ebp, esp
00824153 push -1
00824155 push 0xadad40
0082415A mov eax, dword ptr fs:[0]
00824160 push eax
00824161 sub esp, 0x28
00824164 mov eax, dword ptr [0xc7b480]
00824169 xor eax, ebp
0082416B push eax
0082416C lea eax, [ebp - 0xc]
0082416F mov dword ptr fs:[0], eax
00824175 mov dword ptr [ebp - 0x30], ecx
00824178 cmp dword ptr [0x17c8714], 0
0082417F je 0x82419d
00824181 mov eax, dword ptr [0x17c8714]
00824186 push eax
00824187 call 0x63e840
0082418C mov ecx, eax
0082418E call 0x63e780
00824193 mov dword ptr [0x17c8714], 0
0082419D mov ecx, dword ptr [0x17c870c]
008241A3 call 0x549640
008241A8 test eax, eax
008241AA jne 0x82425a
008241B0 call 0x404940
008241B5 mov dword ptr [ebp - 0x34], eax
008241B8 mov ecx, dword ptr [ebp - 0x34]
008241BB mov edx, dword ptr [ecx]
008241BD mov ecx, dword ptr [ebp - 0x34]
008241C0 mov eax, dword ptr [edx + 0x108]
008241C6 call eax
008241C8 mov ecx, dword ptr [0x17c870c]
008241CE cmp dword ptr [ecx + 0x78], 0
008241D2 je 0x82425a
008241D8 mov edx, dword ptr [0x17c870c]
008241DE mov dword ptr [edx + 0x78], 0
008241E5 lea ecx, [ebp - 0x10]
008241E8 call 0x405f90
008241ED mov dword ptr [ebp - 4], 0
008241F4 mov ecx, dword ptr [0x17c86fc]
008241FA call 0x9cd390
008241FF movzx eax, byte ptr [eax + 0x7b]
00824203 push eax
00824204 push 0xbcb148
00824209 lea ecx, [ebp - 0x10]
0082420C push ecx
0082420D call 0x411c60
00824212 add esp, 0xc
00824215 lea ecx, [ebp - 0x10]
00824218 call 0x406410
0082421D push eax
0082421E lea ecx, [ebp - 0x2c]
00824221 call 0x405650
00824226 mov byte ptr [ebp - 4], 1
0082422A lea edx, [ebp - 0x2c]
0082422D push edx
0082422E push 0x303
00824233 call 0x404940
00824238 mov ecx, eax
0082423A call 0x909fd0
0082423F mov byte ptr [ebp - 4], 0
00824243 lea ecx, [ebp - 0x2c]
00824246 call 0x4056d0
0082424B mov dword ptr [ebp - 4], 0xffffffff
00824252 lea ecx, [ebp - 0x10]
00824255 call 0x406050
0082425A push 5
0082425C call 0x990070
00824261 mov ecx, eax
00824263 call 0x98fde0
00824268 mov ecx, dword ptr [ebp - 0xc]
0082426B mov dword ptr fs:[0], ecx
00824272 pop ecx
00824273 mov esp, ebp
00824275 pop ebp
00822470 push ebp
00822471 mov ebp, esp
00822473 sub esp, 8
00822476 mov dword ptr [ebp - 4], ecx
00822479 cmp dword ptr [0x17c8714], 0
00822480 je 0x82249e
00822482 mov eax, dword ptr [0x17c8714]
00822487 push eax
00822488 call 0x63e840
0082248D mov ecx, eax
0082248F call 0x63e780
00822494 mov dword ptr [0x17c8714], 0
0082249E mov ecx, dword ptr [0x17c86fc]
008224A4 call 0x9cec00
008224A9 call 0xa629d0
008224AE mov ecx, eax
008224B0 call 0xa629b0
008224B5 call 0x404810
008224BA mov dword ptr [ebp - 8], eax
008224BD mov ecx, dword ptr [ebp - 8]
008224C0 mov edx, dword ptr [ecx]
008224C2 mov ecx, dword ptr [ebp - 8]
008224C5 mov eax, dword ptr [edx + 0x108]
008224CB call eax
008224CD mov esp, ebp
008224CF pop ebp
