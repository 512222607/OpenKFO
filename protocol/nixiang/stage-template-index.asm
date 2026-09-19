; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 938E10 returns the name-vector index; it is not a model ID.
00938E10 push ebp
00938E11 mov ebp, esp
00938E13 sub esp, 8
00938E16 mov dword ptr [ebp - 8], ecx
00938E19 mov dword ptr [ebp - 4], 0
00938E20 jmp 0x938e2b
00938E22 mov eax, dword ptr [ebp - 4]
00938E25 add eax, 1
00938E28 mov dword ptr [ebp - 4], eax
00938E2B mov ecx, dword ptr [ebp - 8]
00938E2E add ecx, 0x12c
00938E34 call 0x432c10
00938E39 cmp dword ptr [ebp - 4], eax
00938E3C jae 0x938e6b
00938E3E mov ecx, dword ptr [ebp + 8]
00938E41 push ecx
00938E42 mov edx, dword ptr [ebp - 4]
00938E45 push edx
00938E46 mov ecx, dword ptr [ebp - 8]
00938E49 add ecx, 0x12c
00938E4F call 0x4eae70
00938E54 push eax
00938E55 call 0x4221c0
00938E5A add esp, 8
00938E5D movzx eax, al
00938E60 test eax, eax
00938E62 je 0x938e69
00938E64 mov eax, dword ptr [ebp - 4]
00938E67 jmp 0x938e6e
00938E69 jmp 0x938e22
00938E6B or eax, 0xffffffff
00938E6E mov esp, ebp
00938E70 pop ebp
00938E71 ret 4
