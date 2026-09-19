; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 1550 appends entries. Native lookup key is DWORD +9; duplicate keys retain first entry.
; function 0xa27f60
00A27F60 push ebp
00A27F61 mov ebp, esp
00A27F63 sub esp, 0x10
00A27F66 mov dword ptr [ebp - 0x10], ecx
00A27F69 mov eax, dword ptr [ebp + 8]
00A27F6C mov dword ptr [ebp - 4], eax
00A27F6F mov eax, dword ptr [ebp + 0xc]
00A27F72 xor edx, edx
00A27F74 mov ecx, 0x6c
00A27F79 div ecx
00A27F7B mov dword ptr [ebp - 8], eax
00A27F7E mov dword ptr [ebp - 0xc], 0
00A27F85 jmp 0xa27f99
00A27F87 mov edx, dword ptr [ebp - 0xc]
00A27F8A add edx, 1
00A27F8D mov dword ptr [ebp - 0xc], edx
00A27F90 mov eax, dword ptr [ebp - 4]
00A27F93 add eax, 0x6c
00A27F96 mov dword ptr [ebp - 4], eax
00A27F99 mov ecx, dword ptr [ebp - 0xc]
00A27F9C cmp ecx, dword ptr [ebp - 8]
00A27F9F jge 0xa27fb3
00A27FA1 mov edx, dword ptr [ebp - 4]
00A27FA4 push edx
00A27FA5 call 0x41bc70
00A27FAA mov ecx, eax
00A27FAC call 0x85c5c0
00A27FB1 jmp 0xa27f87
00A27FB3 mov esp, ebp
00A27FB5 pop ebp
00A27FB6 ret 8
; function 0x85c5c0
0085C5C0 push ebp
0085C5C1 mov ebp, esp
0085C5C3 sub esp, 0xf4
0085C5C9 push esi
0085C5CA push edi
0085C5CB mov dword ptr [ebp - 0xf4], ecx
0085C5D1 mov dword ptr [ebp - 4], 0
0085C5D8 jmp 0x85c5e3
0085C5DA mov eax, dword ptr [ebp - 4]
0085C5DD add eax, 1
0085C5E0 mov dword ptr [ebp - 4], eax
0085C5E3 mov ecx, dword ptr [ebp - 0xf4]
0085C5E9 add ecx, 0x640
0085C5EF call 0x4fcd40
0085C5F4 cmp dword ptr [ebp - 4], eax
0085C5F7 jae 0x85c61d
0085C5F9 mov ecx, dword ptr [ebp - 4]
0085C5FC push ecx
0085C5FD mov ecx, dword ptr [ebp - 0xf4]
0085C603 add ecx, 0x640
0085C609 call 0x4fcd60
0085C60E mov edx, dword ptr [ebp + 8]
0085C611 mov eax, dword ptr [eax + 9]
0085C614 cmp eax, dword ptr [edx + 9]
0085C617 jne 0x85c61b
0085C619 jmp 0x85c679
0085C61B jmp 0x85c5da
0085C61D mov esi, dword ptr [ebp + 8]
0085C620 sub esp, 0x6c
0085C623 mov ecx, 0x1b
0085C628 mov edi, esp
0085C62A rep movsd dword ptr es:[edi], dword ptr [esi]
0085C62C mov ecx, dword ptr [ebp + 8]
0085C62F mov edx, dword ptr [ecx + 9]
0085C632 push edx
0085C633 lea eax, [ebp - 0xe4]
0085C639 push eax
0085C63A call 0x528c70
0085C63F add esp, 0x74
0085C642 push eax
0085C643 lea ecx, [ebp - 0x74]
0085C646 call 0x528c90
0085C64B lea ecx, [ebp - 0x74]
0085C64E push ecx
0085C64F lea edx, [ebp - 0xf0]
0085C655 push edx
0085C656 mov ecx, dword ptr [ebp - 0xf4]
0085C65C add ecx, 0x40
0085C65F call 0x524380
0085C664 mov eax, dword ptr [ebp + 8]
0085C667 push eax
0085C668 mov ecx, dword ptr [ebp - 0xf4]
0085C66E add ecx, 0x640
0085C674 call 0x523940
0085C679 pop edi
0085C67A pop esi
0085C67B mov esp, ebp
0085C67D pop ebp
0085C67E ret 4
