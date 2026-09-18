00985BD0  55                       push ebp
00985BD1  8bec                     mov ebp, esp
00985BD3  83ec08                   sub esp, 8
00985BD6  894df8                   mov dword ptr [ebp - 8], ecx
00985BD9  8b45f8                   mov eax, dword ptr [ebp - 8]
00985BDC  83b88400000000           cmp dword ptr [eax + 0x84], 0
00985BE3  7515                     jne 0x985bfa
00985BE5  e8d6d4a7ff               call 0x4030c0
00985BEA  8bc8                     mov ecx, eax
00985BEC  e8afd5a7ff               call 0x4031a0
00985BF1  83f802                   cmp eax, 2
00985BF4  7404                     je 0x985bfa
00985BF6  33c0                     xor eax, eax
00985BF8  eb24                     jmp 0x985c1e
00985BFA  8b4df8                   mov ecx, dword ptr [ebp - 8]
00985BFD  83b98000000000           cmp dword ptr [ecx + 0x80], 0
00985C04  7504                     jne 0x985c0a
00985C06  33c0                     xor eax, eax
00985C08  eb14                     jmp 0x985c1e
00985C0A  8b55f8                   mov edx, dword ptr [ebp - 8]
00985C0D  a190867c01               mov eax, dword ptr [0x17c8690]
00985C12  2b8280000000             sub eax, dword ptr [edx + 0x80]
00985C18  8945fc                   mov dword ptr [ebp - 4], eax
00985C1B  8b45fc                   mov eax, dword ptr [ebp - 4]
00985C1E  8be5                     mov esp, ebp
00985C20  5d                       pop ebp
00985C21  c3                       ret
