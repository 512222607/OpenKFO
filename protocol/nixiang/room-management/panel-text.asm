; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 0x7ed340
007ED340 push ebp
007ED341 mov ebp, esp
007ED343 push -1
007ED345 push 0xad707f
007ED34A mov eax, dword ptr fs:[0]
007ED350 push eax
007ED351 sub esp, 0x44
007ED354 mov eax, dword ptr [0xc7b480]
007ED359 xor eax, ebp
007ED35B mov dword ptr [ebp - 0x10], eax
007ED35E push eax
007ED35F lea eax, [ebp - 0xc]
007ED362 mov dword ptr fs:[0], eax
007ED368 mov dword ptr [ebp - 0x48], ecx
007ED36B mov ecx, dword ptr [ebp - 0x48]
007ED36E call 0x453dd0
007ED373 test eax, eax
007ED375 je 0x7ed3f2
007ED377 lea ecx, [ebp - 0x44]
007ED37A call 0x421860
007ED37F mov dword ptr [ebp - 4], 0
007ED386 mov eax, dword ptr [ebp + 8]
007ED389 mov eax, dword ptr [eax + 4]
007ED38C xor edx, edx
007ED38E mov ecx, 0x64
007ED393 div ecx
007ED395 mov dword ptr [ebp - 0x50], eax
007ED398 mov dword ptr [ebp - 0x4c], 0
007ED39F fild qword ptr [ebp - 0x50]
007ED3A2 sub esp, 8
007ED3A5 fstp qword ptr [esp]
007ED3A8 lea ecx, [ebp - 0x44]
007ED3AB call 0x4218e0
007ED3B0 push 0xbcff70
007ED3B5 mov ecx, dword ptr [ebp - 0x48]
007ED3B8 call 0x453dd0
007ED3BD mov ecx, eax
007ED3BF call 0xa24d00
007ED3C4 push 1
007ED3C6 lea edx, [ebp - 0x44]
007ED3C9 push edx
007ED3CA push 0xbcff70
007ED3CF push 0xbcff70
007ED3D4 mov ecx, dword ptr [ebp - 0x48]
007ED3D7 call 0x453dd0
007ED3DC mov ecx, eax
007ED3DE call 0xa253b0
007ED3E3 mov dword ptr [ebp - 4], 0xffffffff
007ED3EA lea ecx, [ebp - 0x44]
007ED3ED call 0x421960
007ED3F2 mov ecx, dword ptr [ebp - 0x48]
007ED3F5 call 0x7ebe00
007ED3FA mov ecx, dword ptr [ebp - 0xc]
007ED3FD mov dword ptr fs:[0], ecx
007ED404 pop ecx
007ED405 mov ecx, dword ptr [ebp - 0x10]
007ED408 xor ecx, ebp
007ED40A call 0x6634fb
007ED40F mov esp, ebp
007ED411 pop ebp
007ED412 ret 4
; FUNCTION 0x661a70
00661A70 push ebp
00661A71 mov ebp, esp
00661A73 push -1
00661A75 push 0xa9cc57
00661A7A mov eax, dword ptr fs:[0]
00661A80 push eax
00661A81 sub esp, 0x30
00661A84 mov eax, dword ptr [0xc7b480]
00661A89 xor eax, ebp
00661A8B mov dword ptr [ebp - 0x10], eax
00661A8E push eax
00661A8F lea eax, [ebp - 0xc]
00661A92 mov dword ptr fs:[0], eax
00661A98 mov dword ptr [ebp - 4], 1
00661A9F lea eax, [ebp + 0x24]
00661AA2 push eax
00661AA3 lea ecx, [ebp + 8]
00661AA6 call 0x40b240
00661AAB lea ecx, [ebp + 8]
00661AAE call 0x548980
00661AB3 mov dword ptr [ebp - 0x14], eax
00661AB6 mov dword ptr [ebp - 0x1c], 0
00661ABD jmp 0x661ac8
00661ABF mov ecx, dword ptr [ebp - 0x1c]
00661AC2 add ecx, 1
00661AC5 mov dword ptr [ebp - 0x1c], ecx
00661AC8 mov edx, dword ptr [ebp - 0x1c]
00661ACB cmp edx, dword ptr [ebp - 0x14]
00661ACE jge 0x661b32
00661AD0 mov eax, dword ptr [ebp - 0x1c]
00661AD3 push eax
00661AD4 lea ecx, [ebp + 0x24]
00661AD7 push ecx
00661AD8 lea ecx, [ebp + 8]
00661ADB call 0x49cc90
00661AE0 mov dword ptr [ebp - 0x18], eax
00661AE3 mov edx, dword ptr [ebp - 0x18]
00661AE6 cmp edx, dword ptr [ebp - 0x14]
00661AE9 jae 0x661b30
00661AEB mov eax, dword ptr [ebp - 0x18]
00661AEE sub eax, dword ptr [ebp - 0x1c]
00661AF1 push eax
00661AF2 mov ecx, dword ptr [ebp - 0x1c]
00661AF5 push ecx
00661AF6 lea edx, [ebp - 0x38]
00661AF9 push edx
00661AFA lea ecx, [ebp + 8]
00661AFD call 0x41afd0
00661B02 mov byte ptr [ebp - 4], 2
00661B06 lea eax, [ebp - 0x38]
00661B09 push eax
00661B0A mov ecx, dword ptr [ebp + 0x40]
00661B0D call 0x49d150
00661B12 lea ecx, [ebp + 0x24]
00661B15 call 0x548980
00661B1A mov ecx, dword ptr [ebp - 0x18]
00661B1D lea edx, [ecx + eax - 1]
00661B21 mov dword ptr [ebp - 0x1c], edx
00661B24 mov byte ptr [ebp - 4], 1
00661B28 lea ecx, [ebp - 0x38]
00661B2B call 0x4056d0
00661B30 jmp 0x661abf
00661B32 mov ecx, dword ptr [ebp + 0x40]
00661B35 call 0x432c10
00661B3A mov dword ptr [ebp - 0x3c], eax
00661B3D mov byte ptr [ebp - 4], 0
00661B41 lea ecx, [ebp + 8]
00661B44 call 0x4056d0
00661B49 mov dword ptr [ebp - 4], 0xffffffff
00661B50 lea ecx, [ebp + 0x24]
00661B53 call 0x4056d0
00661B58 mov eax, dword ptr [ebp - 0x3c]
00661B5B mov ecx, dword ptr [ebp - 0xc]
00661B5E mov dword ptr fs:[0], ecx
00661B65 pop ecx
00661B66 mov ecx, dword ptr [ebp - 0x10]
00661B69 xor ecx, ebp
00661B6B call 0x6634fb
00661B70 mov esp, ebp
00661B72 pop ebp
00661B73 ret
