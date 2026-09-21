; SHA256=98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; B9AF00 = name BA2734 (AddMP), function 9DA2F0
; 82D7D0[8127-8120]=5; 82D74C[5]=82D721; branch calls 827D00
009DA2F0 push ebp
009DA2F1 mov ebp, esp
009DA2F3 sub esp, 0x54
009DA2F6 mov eax, dword ptr [ebp + 8]
009DA2F9 push eax
009DA2FA call 0x68bb90
009DA2FF add esp, 4
009DA302 cmp eax, 2
009DA305 jge 0x9da30e
009DA307 xor eax, eax
009DA309 jmp 0x9da3ef
009DA30E push 1
009DA310 mov ecx, dword ptr [ebp + 8]
009DA313 push ecx
009DA314 call 0x68c320
009DA319 fstp qword ptr [esp]
009DA31C call 0x9e3b30
009DA321 add esp, 8
009DA324 push edx
009DA325 push eax
009DA326 mov ecx, dword ptr [0x17c8708]
009DA32C call 0x818c70
009DA331 mov dword ptr [ebp - 4], eax
009DA334 cmp dword ptr [ebp - 4], 0
009DA338 jne 0x9da341
009DA33A xor eax, eax
009DA33C jmp 0x9da3ef
009DA341 mov ecx, dword ptr [ebp - 4]
009DA344 call 0x9e9a30
009DA349 test eax, eax
009DA34B je 0x9da3ed
009DA351 push 2
009DA353 mov edx, dword ptr [ebp + 8]
009DA356 push edx
009DA357 call 0x68c320
009DA35C add esp, 8
009DA35F fstp qword ptr [ebp - 0x10]
009DA362 cmp dword ptr [ebp - 4], 0
009DA366 je 0x9da386
009DA368 sub esp, 8
009DA36B fld qword ptr [ebp - 0x10]
009DA36E fstp qword ptr [esp]
009DA371 call 0x45c9c0
009DA376 add esp, 8
009DA379 fcomp qword ptr [0xbe9b70]
009DA37F fnstsw ax
009DA381 test ah, 0x41
009DA384 jp 0x9da38a
009DA386 xor eax, eax
009DA388 jmp 0x9da3ef
009DA38A push 0
009DA38C fld qword ptr [ebp - 0x10]
009DA38F fstp dword ptr [ebp - 0x54]
009DA392 fld dword ptr [ebp - 0x54]
009DA395 push ecx
009DA396 fstp dword ptr [esp]
009DA399 mov ecx, dword ptr [ebp - 4]
009DA39C call 0x9e55a0
009DA3A1 mov ecx, dword ptr [ebp - 4]
009DA3A4 call 0x401000
009DA3A9 mov dword ptr [ebp - 0x29], eax
009DA3AC mov dword ptr [ebp - 0x25], edx
009DA3AF fld qword ptr [ebp - 0x10]
009DA3B2 fstp dword ptr [ebp - 0x21]
009DA3B5 mov ecx, dword ptr [ebp - 4]
009DA3B8 call 0x9e4430
009DA3BD fstp dword ptr [ebp - 0x1d]
009DA3C0 mov ecx, dword ptr [0x17c8708]
009DA3C6 call 0x432440
009DA3CB mov ecx, dword ptr [eax]
009DA3CD mov edx, dword ptr [eax + 4]
009DA3D0 mov dword ptr [ebp - 0x19], ecx
009DA3D3 mov dword ptr [ebp - 0x15], edx
009DA3D6 push 0
009DA3D8 push 0
009DA3DA push 0x3f
009DA3DC lea eax, [ebp - 0x50]
009DA3DF push eax
009DA3E0 push 0x1fbf
009DA3E5 call 0xa3fbb0
009DA3EA add esp, 0x14
009DA3ED xor eax, eax
009DA3EF mov esp, ebp
009DA3F1 pop ebp
009DA3F2 ret
00827D00 push ebp
00827D01 mov ebp, esp
00827D03 sub esp, 0xc
00827D06 mov dword ptr [ebp - 0xc], ecx
00827D09 cmp dword ptr [ebp + 8], 0
00827D0D je 0x827d15
00827D0F cmp dword ptr [ebp + 0xc], 0x3f
00827D13 je 0x827d17
00827D15 jmp 0x827d66
00827D17 mov eax, dword ptr [ebp + 8]
00827D1A mov dword ptr [ebp - 4], eax
00827D1D mov ecx, dword ptr [ebp - 4]
00827D20 add ecx, 0x37
00827D23 push ecx
00827D24 mov ecx, dword ptr [0x17c8708]
00827D2A call 0x817ac0
00827D2F test eax, eax
00827D31 jne 0x827d35
00827D33 jmp 0x827d66
00827D35 mov edx, dword ptr [ebp - 4]
00827D38 mov eax, dword ptr [edx + 0x2b]
00827D3B push eax
00827D3C mov ecx, dword ptr [edx + 0x27]
00827D3F push ecx
00827D40 mov ecx, dword ptr [0x17c8708]
00827D46 call 0x818c70
00827D4B mov dword ptr [ebp - 8], eax
00827D4E cmp dword ptr [ebp - 8], 0
00827D52 je 0x827d66
00827D54 mov edx, dword ptr [ebp - 4]
00827D57 push ecx
00827D58 fld dword ptr [edx + 0x33]
00827D5B fstp dword ptr [esp]
00827D5E mov ecx, dword ptr [ebp - 8]
00827D61 call 0x9e4470
00827D66 mov esp, ebp
00827D68 pop ebp
00827D69 ret 8
009E9A30 push ebp
009E9A31 mov ebp, esp
009E9A33 push ecx
009E9A34 mov dword ptr [ebp - 4], ecx
009E9A37 call 0x990070
009E9A3C mov ecx, eax
009E9A3E call 0x98fd50
009E9A43 cmp eax, 9
009E9A46 jne 0x9e9a88
009E9A48 mov eax, dword ptr [ebp - 4]
009E9A4B mov edx, dword ptr [eax]
009E9A4D mov ecx, dword ptr [ebp - 4]
009E9A50 mov eax, dword ptr [edx + 4]
009E9A53 call eax
009E9A55 movzx ecx, al
009E9A58 test ecx, ecx
009E9A5A je 0x9e9a88
009E9A5C mov ecx, dword ptr [0x17c8708]
009E9A62 call 0x819120
009E9A67 test eax, eax
009E9A69 je 0x9e9a88
009E9A6B mov ecx, dword ptr [0x17c8708]
009E9A71 call 0x819120
009E9A76 mov ecx, eax
009E9A78 call 0x44b3f0
009E9A7D test eax, eax
009E9A7F je 0x9e9a88
009E9A81 mov eax, 1
009E9A86 jmp 0x9e9aa6
009E9A88 call 0x4030c0
009E9A8D mov ecx, eax
009E9A8F call 0x4031a0
009E9A94 cmp eax, 2
009E9A97 je 0x9e9aa4
009E9A99 mov edx, dword ptr [ebp - 4]
009E9A9C mov eax, dword ptr [edx + 0xdd0]
009E9AA2 jmp 0x9e9aa6
009E9AA4 xor eax, eax
009E9AA6 mov esp, ebp
009E9AA8 pop ebp
009E9AA9 ret
009E4430 push ebp
009E4431 mov ebp, esp
009E4433 sub esp, 0xcc
009E4439 mov dword ptr [ebp - 0xcc], ecx
009E443F lea eax, [ebp - 0xc8]
009E4445 push eax
009E4446 mov ecx, dword ptr [ebp - 0xcc]
009E444C mov ecx, dword ptr [ecx + 0x17b0]
009E4452 call 0x4585e0
009E4457 fld dword ptr [ebp - 0x90]
009E445D mov esp, ebp
009E445F pop ebp
009E4460 ret
009E4470 push ebp
009E4471 mov ebp, esp
009E4473 sub esp, 0xcc
009E4479 mov dword ptr [ebp - 0xcc], ecx
009E447F lea eax, [ebp - 0xc8]
009E4485 push eax
009E4486 mov ecx, dword ptr [ebp - 0xcc]
009E448C mov ecx, dword ptr [ecx + 0x17b0]
009E4492 call 0x4585e0
009E4497 fld dword ptr [ebp + 8]
009E449A fstp dword ptr [ebp - 0x90]
009E44A0 lea edx, [ebp - 0xc8]
009E44A6 push edx
009E44A7 mov eax, dword ptr [ebp - 0xcc]
009E44AD mov ecx, dword ptr [eax + 0x17b0]
009E44B3 call 0x458660
009E44B8 mov esp, ebp
009E44BA pop ebp
009E44BB ret 4
009E4550 push ebp
009E4551 mov ebp, esp
009E4553 sub esp, 0xcc
009E4559 mov dword ptr [ebp - 0xcc], ecx
009E455F lea eax, [ebp - 0xc8]
009E4565 push eax
009E4566 mov ecx, dword ptr [ebp - 0xcc]
009E456C mov ecx, dword ptr [ecx + 0x17b0]
009E4572 call 0x4585e0
009E4577 fld dword ptr [ebp - 0x90]
009E457D fadd dword ptr [ebp + 8]
009E4580 fstp dword ptr [ebp - 0x90]
009E4586 lea edx, [ebp - 0xc8]
009E458C push edx
009E458D mov eax, dword ptr [ebp - 0xcc]
009E4593 mov ecx, dword ptr [eax + 0x17b0]
009E4599 call 0x458660
009E459E mov esp, ebp
009E45A0 pop ebp
009E55A0 push ebp
009E55A1 mov ebp, esp
009E55A3 push ecx
009E55A4 mov dword ptr [ebp - 4], ecx
009E55A7 mov ecx, dword ptr [ebp - 4]
009E55AA call 0x9e47d0
009E55AF test eax, eax
009E55B1 jne 0x9e55b5
009E55B3 jmp 0x9e55ef
009E55B5 cmp dword ptr [ebp + 0xc], 0
009E55B9 jne 0x9e55e0
009E55BB mov eax, dword ptr [ebp - 4]
009E55BE fld dword ptr [eax + 0x1b14]
009E55C4 fcomp qword ptr [0xbe8350]
009E55CA fnstsw ax
009E55CC test ah, 0x44
009E55CF jnp 0x9e55e0
009E55D1 fld dword ptr [ebp + 8]
009E55D4 mov ecx, dword ptr [ebp - 4]
009E55D7 fmul dword ptr [ecx + 0x1b14]
009E55DD fstp dword ptr [ebp + 8]
009E55E0 push ecx
009E55E1 fld dword ptr [ebp + 8]
009E55E4 fstp dword ptr [esp]
009E55E7 mov ecx, dword ptr [ebp - 4]
009E55EA call 0x9e4550
009E55EF mov esp, ebp
009E55F1 pop ebp
009E55F2 ret 8
