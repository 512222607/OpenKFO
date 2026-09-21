; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
00910790 push ebp
00910791 mov ebp, esp
00910793 push ecx
00910794 mov dword ptr [ebp - 4], ecx
00910797 push 0
00910799 push 0x80c
0091079E call 0xa3ca00
009107A3 add esp, 8
009107A6 mov dword ptr [0x17c86a4], 1
009107B0 push 0
009107B2 call 0x4e7600
009107B7 mov ecx, eax
009107B9 call 0x4e7690
009107BE mov eax, dword ptr [ebp - 4]
009107C1 mov dword ptr [eax + 0x104], 0
009107CB mov ecx, dword ptr [ebp - 4]
009107CE mov dword ptr [ecx + 0x17c], 1
009107D8 mov esp, ebp
009107DA pop ebp
009107DB ret
00910E19 mov ecx, dword ptr [ebp - 0xb0]
00910E1F cmp dword ptr [ecx + 0x104], 0
00910E26 je 0x910e54
00910E28 mov edx, dword ptr [ebp - 0xb0]
00910E2E mov eax, dword ptr [edx + 0x104]
00910E34 cmp eax, dword ptr [ebp - 0x20]
00910E37 je 0x910e54
00910E39 mov ecx, dword ptr [ebp - 0xb0]
00910E3F call 0x910790
00910E44 mov ecx, dword ptr [ebp - 0xb0]
00910E4A mov dword ptr [ecx + 0x178], 1
00910F3E mov ecx, dword ptr [ebp - 0xb0]
00910F44 cmp dword ptr [ecx + 0x104], 0
00910F4B je 0x910f81
00910F4D mov edx, dword ptr [ebp - 0xb0]
00910F53 mov eax, dword ptr [edx + 0x104]
00910F59 cmp eax, dword ptr [ebp - 0x20]
00910F5C jne 0x910f81
00910F5E cmp dword ptr [0x17c8714], 0
00910F65 je 0x910f81
00910F67 mov ecx, dword ptr [0x17c8714]
00910F6D mov edx, dword ptr [ecx]
00910F6F mov ecx, dword ptr [0x17c8714]
00910F75 mov eax, dword ptr [edx + 0xc]
00910F78 call eax
00910F7A movzx ecx, al
00910F7D test ecx, ecx
00910F7F je 0x910faf
00910F81 push 1
00910F83 mov edx, dword ptr [ebp - 0x20]
00910F86 push edx
00910F87 mov eax, dword ptr [ebp - 0x18]
00910F8A push eax
00910F8B lea ecx, [ebp - 0x28]
00910F8E call 0x4305b0
00910F93 movzx ecx, word ptr [eax + 8]
00910F97 push ecx
00910F98 lea ecx, [ebp - 0x28]
00910F9B call 0x4305b0
00910FA0 add eax, 0xa
00910FA3 push eax
00910FA4 mov ecx, dword ptr [ebp - 0xb0]
00910FAA call 0x910510
00910FAF mov ecx, dword ptr [ebp - 0xc]
