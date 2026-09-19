
; Function 0x828b90
00828B90  push ebp
00828B91  mov ebp, esp
00828B93  sub esp, 8
00828B96  mov dword ptr [ebp - 8], ecx
00828B99  cmp dword ptr [ebp + 8], 0
00828B9D  jne 0x828ba1
00828B9F  jmp 0x828bdb
00828BA1  mov eax, dword ptr [ebp + 8]
00828BA4  mov dword ptr [ebp - 4], eax
00828BA7  mov ecx, dword ptr [ebp - 4]
00828BAA  mov edx, dword ptr [ecx]
00828BAC  push edx
00828BAD  mov ecx, dword ptr [0x17c8710]
00828BB3  call 0x985490
00828BB8  call 0x4030c0
00828BBD  mov ecx, eax
00828BBF  call 0x4031a0
00828BC4  cmp eax, 2
00828BC7  je 0x828bdb
00828BC9  mov eax, dword ptr [ebp - 4]
00828BCC  mov ecx, dword ptr [eax]
00828BCE  push ecx
00828BCF  call 0x4030c0
00828BD4  mov ecx, eax
00828BD6  call 0x931d00
00828BDB  mov esp, ebp
00828BDD  pop ebp

; Function 0x985490
00985490  push ebp
00985491  mov ebp, esp
00985493  push ecx
00985494  mov dword ptr [ebp - 4], ecx
00985497  mov eax, dword ptr [ebp - 4]
0098549A  mov ecx, dword ptr [ebp + 8]
0098549D  mov dword ptr [eax + 0x84], ecx
009854A3  mov edx, dword ptr [ebp - 4]
009854A6  mov eax, dword ptr [0x17c8690]
009854AB  mov dword ptr [edx + 0x88], eax
009854B1  mov esp, ebp
009854B3  pop ebp
