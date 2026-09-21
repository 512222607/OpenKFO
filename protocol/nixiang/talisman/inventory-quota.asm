; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
0099AA80 push ebp
0099AA81 mov ebp, esp
0099AA83 sub esp, 0x8c
0099AA89 mov eax, dword ptr [0xc7b480]
0099AA8E xor eax, ebp
0099AA90 mov dword ptr [ebp - 4], eax
0099AA93 mov dword ptr [ebp - 0x80], ecx
0099AA96 mov eax, dword ptr [ebp - 0x80]
0099AA99 mov ecx, dword ptr [ebp + 0xc]
0099AA9C mov dword ptr [eax + 0x16c], ecx
0099AAA2 mov edx, dword ptr [ebp + 8]
0099AAA5 mov eax, dword ptr [edx + 5]
0099AAA8 push eax
0099AAA9 call 0xa21b30
0099AAAE mov ecx, eax
0099AAB0 call 0xa1e560
0099AAB5 mov dword ptr [ebp - 0x7c], eax
0099AAB8 cmp dword ptr [ebp - 0x7c], 0
0099AABC jne 0x99aac5
0099AABE xor eax, eax
0099AAC0 jmp 0x99ab75
0099AAC5 mov ecx, dword ptr [ebp - 0x7c]
0099AAC8 push ecx
0099AAC9 mov ecx, dword ptr [ebp - 0x80]
0099AACC add ecx, 0x48
0099AACF call 0x4543c0
0099AAD4 mov edx, dword ptr [ebp - 0x80]
0099AAD7 mov eax, dword ptr [ebp + 8]
0099AADA mov ecx, dword ptr [eax]
0099AADC mov dword ptr [edx + 8], ecx
0099AADF mov edx, dword ptr [ebp - 0x80]
0099AAE2 mov eax, dword ptr [edx + 0x4c]
0099AAE5 push eax
0099AAE6 call 0xa208f0
0099AAEB mov ecx, eax
0099AAED call 0xa1e270
0099AAF2 mov ecx, dword ptr [ebp - 0x80]
0099AAF5 mov dword ptr [ecx + 0x168], eax
0099AAFB mov edx, dword ptr [ebp - 0x80]
0099AAFE cmp dword ptr [edx + 0x168], 0
0099AB05 jne 0x99ab0b
0099AB07 xor eax, eax
0099AB09 jmp 0x99ab75
0099AB0B mov eax, dword ptr [ebp + 8]
0099AB0E movzx ecx, word ptr [eax + 0x17]
0099AB12 mov dword ptr [ebp - 0x84], ecx
0099AB18 fild dword ptr [ebp - 0x84]
0099AB1E fdiv qword ptr [0xbe8460]
0099AB24 mov edx, dword ptr [ebp - 0x80]
0099AB27 fstp dword ptr [edx + 0x170]
0099AB2D lea eax, [ebp - 0x78]
0099AB30 push eax
0099AB31 mov ecx, dword ptr [ebp + 8]
0099AB34 mov edx, dword ptr [ecx + 9]
0099AB37 push edx
0099AB38 call 0x41bc70
0099AB3D mov ecx, eax
0099AB3F call 0x85ba40
0099AB44 test eax, eax
0099AB46 je 0x99ab70
0099AB48 mov eax, dword ptr [ebp - 0x5e]
0099AB4B mov dword ptr [ebp - 0x8c], eax
0099AB51 mov dword ptr [ebp - 0x88], 0
0099AB5B fild qword ptr [ebp - 0x8c]
0099AB61 fdiv qword ptr [0xbe8460]
0099AB67 mov ecx, dword ptr [ebp - 0x80]
0099AB6A fstp dword ptr [ecx + 0x174]
0099AB70 mov eax, 1
0099AB75 mov ecx, dword ptr [ebp - 4]
0099AB78 xor ecx, ebp
0099AB7A call 0x6634fb
0099AB7F mov esp, ebp
0099AB81 pop ebp
0099AB82 ret 8
