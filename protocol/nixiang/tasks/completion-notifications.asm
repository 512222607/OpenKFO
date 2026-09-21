; Read-only gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; function 0x829300
00829300 push ebp
00829301 mov ebp, esp
00829303 sub esp, 8
00829306 mov dword ptr [ebp - 8], ecx
00829309 mov eax, dword ptr [ebp + 8]
0082930C mov dword ptr [ebp - 4], eax
0082930F mov ecx, dword ptr [ebp - 4]
00829312 movzx edx, word ptr [ecx + 0xc]
00829316 push edx
00829317 call 0x4044d0
0082931C mov ecx, eax
0082931E call 0xa48d90
00829323 call 0x548b10
00829328 mov ecx, eax
0082932A call 0x830a80
0082932F cmp dword ptr [0x17c8710], 0
00829336 je 0x8293e9
0082933C mov ecx, dword ptr [0x17c8710]
00829342 call 0x493d50
00829347 cmp eax, 5
0082934A jne 0x8293e9
00829350 call 0x811460
00829355 mov ecx, eax
00829357 call 0x41bb50
0082935C movzx eax, al
0082935F test eax, eax
00829361 je 0x8293e9
00829367 call 0x811460
0082936C mov ecx, eax
0082936E call 0x4b8780
00829373 test eax, eax
00829375 je 0x8293e9
00829377 mov ecx, dword ptr [0x17c8708]
0082937D call 0x4535c0
00829382 cmp eax, 0xf
00829385 jne 0x8293a3
00829387 push 0
00829389 call 0x548a20
0082938E mov ecx, eax
00829390 call 0x80d700
00829395 call 0x548a20
0082939A mov ecx, eax
0082939C call 0x80d780
008293A1 jmp 0x8293e9
008293A3 mov ecx, dword ptr [0x17c8708]
008293A9 call 0x4535c0
008293AE cmp eax, 0x15
008293B1 jne 0x8293cf
008293B3 push 0
008293B5 call 0x548d10
008293BA mov ecx, eax
008293BC call 0x935ef0
008293C1 call 0x548d10
008293C6 mov ecx, eax
008293C8 call 0x935f10
008293CD jmp 0x8293e9
008293CF push 0
008293D1 call 0x811460
008293D6 mov ecx, eax
008293D8 call 0x80f4e0
008293DD call 0x811460
008293E2 mov ecx, eax
008293E4 call 0x80fd80
008293E9 mov esp, ebp
008293EB pop ebp
008293EC ret 8

; function 0x8293f0
008293F0 push ebp
008293F1 mov ebp, esp
008293F3 sub esp, 8
008293F6 mov dword ptr [ebp - 8], ecx
008293F9 mov eax, dword ptr [ebp + 8]
008293FC mov dword ptr [ebp - 4], eax
008293FF mov ecx, dword ptr [ebp - 4]
00829402 movzx edx, word ptr [ecx + 4]
00829406 push edx
00829407 call 0x4044d0
0082940C mov ecx, eax
0082940E call 0xa48ee0
00829413 mov eax, dword ptr [ebp - 4]
00829416 movzx ecx, word ptr [eax + 4]
0082941A push ecx
0082941B call 0x548b10
00829420 mov ecx, eax
00829422 call 0x4e7690
00829427 push 1
00829429 call 0x811460
0082942E mov ecx, eax
00829430 call 0x8102e0
00829435 cmp dword ptr [0x17c8710], 0
0082943C je 0x8294ef
00829442 mov ecx, dword ptr [0x17c8710]
00829448 call 0x493d50
0082944D cmp eax, 5
00829450 jne 0x8294ef
00829456 call 0x811460
0082945B mov ecx, eax
0082945D call 0x41bb50
00829462 movzx edx, al
00829465 test edx, edx
00829467 je 0x8294ef
0082946D call 0x811460
00829472 mov ecx, eax
00829474 call 0x4b8780
00829479 test eax, eax
0082947B je 0x8294ef
0082947D mov ecx, dword ptr [0x17c8708]
00829483 call 0x4535c0
00829488 cmp eax, 0xf
0082948B jne 0x8294a9
0082948D push 0
0082948F call 0x548a20
00829494 mov ecx, eax
00829496 call 0x80d700
0082949B call 0x548a20
008294A0 mov ecx, eax
008294A2 call 0x80d780
008294A7 jmp 0x8294ef
008294A9 mov ecx, dword ptr [0x17c8708]
008294AF call 0x4535c0
008294B4 cmp eax, 0x15
008294B7 jne 0x8294d5
008294B9 push 0
008294BB call 0x548d10
008294C0 mov ecx, eax
008294C2 call 0x935ef0
008294C7 call 0x548d10
008294CC mov ecx, eax
008294CE call 0x935f10
008294D3 jmp 0x8294ef
008294D5 push 0
008294D7 call 0x811460
008294DC mov ecx, eax
008294DE call 0x80f4e0
008294E3 call 0x811460
008294E8 mov ecx, eax
008294EA call 0x80fd80
008294EF mov esp, ebp
008294F1 pop ebp
008294F2 ret 8

; function 0xa48d90
00A48D90 push ebp
00A48D91 mov ebp, esp
00A48D93 sub esp, 0x14
00A48D96 mov dword ptr [ebp - 0x14], ecx
00A48D99 movzx eax, word ptr [ebp + 8]
00A48D9D push eax
00A48D9E mov ecx, dword ptr [ebp - 0x14]
00A48DA1 call 0xa47400
00A48DA6 mov dword ptr [ebp - 8], eax
00A48DA9 cmp dword ptr [ebp - 8], 0
00A48DAD je 0xa48db6
00A48DAF mov ecx, dword ptr [ebp - 8]
00A48DB2 mov byte ptr [ecx + 6], 3
00A48DB6 movzx edx, word ptr [ebp + 8]
00A48DBA push edx
00A48DBB mov ecx, dword ptr [ebp - 0x14]
00A48DBE call 0xa47d00
00A48DC3 mov dword ptr [ebp - 0xc], eax
00A48DC6 mov ecx, dword ptr [0x17c86fc]
00A48DCC call 0x9cd390
00A48DD1 mov dword ptr [ebp - 4], eax
00A48DD4 mov eax, dword ptr [ebp - 4]
00A48DD7 movzx ecx, byte ptr [eax + 0x7b]
00A48DDB mov edx, dword ptr [ebp - 0xc]
00A48DDE movzx eax, word ptr [edx + 0xd]
00A48DE2 cmp ecx, eax
00A48DE4 jge 0xa48df2
00A48DE6 mov ecx, dword ptr [ebp - 4]
00A48DE9 mov edx, dword ptr [ebp - 0xc]
00A48DEC mov al, byte ptr [edx + 0xd]
00A48DEF mov byte ptr [ecx + 0x7b], al
00A48DF2 movzx ecx, word ptr [ebp + 8]
00A48DF6 mov dword ptr [ebp - 0x10], ecx
00A48DF9 lea edx, [ebp - 0x10]
00A48DFC push edx
00A48DFD mov ecx, dword ptr [ebp - 0x14]
00A48E00 add ecx, 0xa8
00A48E06 call 0x4a5c30
00A48E0B movzx eax, word ptr [ebp + 8]
00A48E0F mov ecx, dword ptr [ebp - 0x14]
00A48E12 mov dword ptr [ecx + 0xf8], eax
00A48E18 mov ecx, dword ptr [ebp - 0x14]
00A48E1B call 0xa47f70
00A48E20 mov esp, ebp
00A48E22 pop ebp
00A48E23 ret 4

; function 0xa47f70
00A47F70 push ebp
00A47F71 mov ebp, esp
00A47F73 sub esp, 0x2c
00A47F76 mov dword ptr [ebp - 0x2c], ecx
00A47F79 mov ecx, dword ptr [ebp - 0x2c]
00A47F7C add ecx, 0x90
00A47F82 call 0x43c070
00A47F87 lea ecx, [ebp - 8]
00A47F8A call 0x471ae0
00A47F8F lea ecx, [ebp - 0x10]
00A47F92 call 0x471ae0
00A47F97 lea eax, [ebp - 0x18]
00A47F9A push eax
00A47F9B mov ecx, dword ptr [ebp - 0x2c]
00A47F9E add ecx, 0x78
00A47FA1 call 0x4d6050
00A47FA6 mov ecx, dword ptr [eax]
00A47FA8 mov edx, dword ptr [eax + 4]
00A47FAB mov dword ptr [ebp - 0x10], ecx
00A47FAE mov dword ptr [ebp - 0xc], edx
00A47FB1 jmp 0xa47fc1
00A47FB3 push 0
00A47FB5 lea eax, [ebp - 0x20]
00A47FB8 push eax
00A47FB9 lea ecx, [ebp - 0x10]
00A47FBC call 0x582570
00A47FC1 lea ecx, [ebp - 0x28]
00A47FC4 push ecx
00A47FC5 mov ecx, dword ptr [ebp - 0x2c]
00A47FC8 add ecx, 0x78
00A47FCB call 0x4f2590
00A47FD0 push eax
00A47FD1 lea ecx, [ebp - 0x10]
00A47FD4 call 0x4ab8f0
00A47FD9 movzx edx, al
00A47FDC test edx, edx
00A47FDE je 0xa4800c
00A47FE0 lea ecx, [ebp - 0x10]
00A47FE3 call 0x4e19a0
00A47FE8 mov eax, dword ptr [eax]
00A47FEA movzx ecx, byte ptr [eax + 6]
00A47FEE cmp ecx, 3
00A47FF1 je 0xa4800a
00A47FF3 lea ecx, [ebp - 0x10]
00A47FF6 call 0x4e19a0
00A47FFB push eax
00A47FFC mov ecx, dword ptr [ebp - 0x2c]
00A47FFF add ecx, 0x90
00A48005 call 0x4a5c30
00A4800A jmp 0xa47fb3
00A4800C mov esp, ebp
00A4800E pop ebp
00A4800F ret

; function 0x830a80
00830A80 push ebp
00830A81 mov ebp, esp
00830A83 push ecx
00830A84 mov dword ptr [ebp - 4], ecx
00830A87 call 0x4044d0
00830A8C mov ecx, eax
00830A8E call 0xa47b90
00830A93 push eax
00830A94 mov ecx, dword ptr [ebp - 4]
00830A97 call 0x4e7690
00830A9C mov eax, dword ptr [ebp - 4]
00830A9F mov edx, dword ptr [eax]
00830AA1 mov ecx, dword ptr [ebp - 4]
00830AA4 mov eax, dword ptr [edx + 0x108]
00830AAA call eax
00830AAC mov esp, ebp
00830AAE pop ebp
00830AAF ret

; function 0x493d50
00493D50 push ebp
00493D51 mov ebp, esp
00493D53 push ecx
00493D54 mov dword ptr [ebp - 4], ecx
00493D57 mov eax, dword ptr [ebp - 4]
00493D5A mov eax, dword ptr [eax + 0x78]
00493D5D mov esp, ebp
00493D5F pop ebp
00493D60 ret

; function 0x41bb50
0041BB50 push ebp
0041BB51 mov ebp, esp
0041BB53 push ecx
0041BB54 mov dword ptr [ebp - 4], ecx
0041BB57 mov eax, dword ptr [ebp - 4]
0041BB5A cmp dword ptr [eax + 0x24c], 0
0041BB61 je 0x41bb75
0041BB63 mov ecx, dword ptr [ebp - 4]
0041BB66 mov ecx, dword ptr [ecx + 0x24c]
0041BB6C call 0x41bb30
0041BB71 jmp 0x41bb77
0041BB73 jmp 0x41bb77
0041BB75 xor al, al
0041BB77 mov esp, ebp
0041BB79 pop ebp
0041BB7A ret

; function 0x4b8780
004B8780 push ebp
004B8781 mov ebp, esp
004B8783 push ecx
004B8784 mov dword ptr [ebp - 4], ecx
004B8787 mov eax, dword ptr [ebp - 4]
004B878A mov eax, dword ptr [eax + 0x614]
004B8790 mov esp, ebp
004B8792 pop ebp
004B8793 ret

; function 0x80d780
0080D780 push ebp
0080D781 mov ebp, esp
0080D783 push -1
0080D785 push 0xaa9e4b
0080D78A mov eax, dword ptr fs:[0]
0080D790 push eax
0080D791 sub esp, 0x24
0080D794 mov eax, dword ptr [0xc7b480]
0080D799 xor eax, ebp
0080D79B push eax
0080D79C lea eax, [ebp - 0xc]
0080D79F mov dword ptr fs:[0], eax
0080D7A5 mov dword ptr [ebp - 0x30], ecx
0080D7A8 mov eax, dword ptr [ebp - 0x30]
0080D7AB cmp dword ptr [eax + 0x598], -1
0080D7B2 je 0x80d81b
0080D7B4 mov ecx, dword ptr [0xb97090]
0080D7BA push ecx
0080D7BB lea ecx, [ebp - 0x2c]
0080D7BE call 0x405650
0080D7C3 mov dword ptr [ebp - 4], 0
0080D7CA lea edx, [ebp - 0x2c]
0080D7CD push edx
0080D7CE mov ecx, dword ptr [ebp - 0x30]
0080D7D1 call 0x75fbf0
0080D7D6 mov dword ptr [ebp - 0x10], eax
0080D7D9 mov dword ptr [ebp - 4], 0xffffffff
0080D7E0 lea ecx, [ebp - 0x2c]
0080D7E3 call 0x4056d0
0080D7E8 cmp dword ptr [ebp - 0x10], 0
0080D7EC je 0x80d7f8
0080D7EE push 0
0080D7F0 mov ecx, dword ptr [ebp - 0x10]
0080D7F3 call 0x75aa30
0080D7F8 mov eax, dword ptr [ebp - 0x30]
0080D7FB mov ecx, dword ptr [eax + 0x598]
0080D801 push ecx
0080D802 call 0x402840
0080D807 mov ecx, eax
0080D809 call 0x904e80
0080D80E mov edx, dword ptr [ebp - 0x30]
0080D811 mov dword ptr [edx + 0x598], 0xffffffff
0080D81B mov ecx, dword ptr [ebp - 0xc]
0080D81E mov dword ptr fs:[0], ecx
0080D825 pop ecx
0080D826 mov esp, ebp
0080D828 pop ebp
0080D829 ret

; function 0x80fd80
0080FD80 push ebp
0080FD81 mov ebp, esp
0080FD83 push -1
0080FD85 push 0xaa9ec2
0080FD8A mov eax, dword ptr fs:[0]
0080FD90 push eax
0080FD91 sub esp, 0x24
0080FD94 mov eax, dword ptr [0xc7b480]
0080FD99 xor eax, ebp
0080FD9B push eax
0080FD9C lea eax, [ebp - 0xc]
0080FD9F mov dword ptr fs:[0], eax
0080FDA5 mov dword ptr [ebp - 0x30], ecx
0080FDA8 mov eax, dword ptr [ebp - 0x30]
0080FDAB cmp dword ptr [eax + 0x60c], -1
0080FDB2 je 0x80fe1b
0080FDB4 mov ecx, dword ptr [0xb97148]
0080FDBA push ecx
0080FDBB lea ecx, [ebp - 0x2c]
0080FDBE call 0x405650
0080FDC3 mov dword ptr [ebp - 4], 0
0080FDCA lea edx, [ebp - 0x2c]
0080FDCD push edx
0080FDCE mov ecx, dword ptr [ebp - 0x30]
0080FDD1 call 0x75fbf0
0080FDD6 mov dword ptr [ebp - 0x10], eax
0080FDD9 mov dword ptr [ebp - 4], 0xffffffff
0080FDE0 lea ecx, [ebp - 0x2c]
0080FDE3 call 0x4056d0
0080FDE8 cmp dword ptr [ebp - 0x10], 0
0080FDEC je 0x80fdf8
0080FDEE push 0
0080FDF0 mov ecx, dword ptr [ebp - 0x10]
0080FDF3 call 0x75aa30
0080FDF8 mov eax, dword ptr [ebp - 0x30]
0080FDFB mov ecx, dword ptr [eax + 0x60c]
0080FE01 push ecx
0080FE02 call 0x402840
0080FE07 mov ecx, eax
0080FE09 call 0x904e80
0080FE0E mov edx, dword ptr [ebp - 0x30]
0080FE11 mov dword ptr [edx + 0x60c], 0xffffffff
0080FE1B mov ecx, dword ptr [ebp - 0xc]
0080FE1E mov dword ptr fs:[0], ecx
0080FE25 pop ecx
0080FE26 mov esp, ebp
0080FE28 pop ebp
0080FE29 ret

; function 0x80f4e0
0080F4E0 push ebp
0080F4E1 mov ebp, esp
0080F4E3 push ecx
0080F4E4 mov dword ptr [ebp - 4], ecx
0080F4E7 mov eax, dword ptr [ebp - 4]
0080F4EA mov ecx, dword ptr [ebp + 8]
0080F4ED mov dword ptr [eax + 0x614], ecx
0080F4F3 mov esp, ebp
0080F4F5 pop ebp
0080F4F6 ret 4
