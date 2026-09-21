; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; function 0x8a0f00
008A0F00 push ebp
008A0F01 mov ebp, esp
008A0F03 push -1
008A0F05 push 0xac116d
008A0F0A mov eax, dword ptr fs:[0]
008A0F10 push eax
008A0F11 sub esp, 0x90
008A0F17 mov eax, dword ptr [0xc7b480]
008A0F1C xor eax, ebp
008A0F1E mov dword ptr [ebp - 0x10], eax
008A0F21 push eax
008A0F22 lea eax, [ebp - 0xc]
008A0F25 mov dword ptr fs:[0], eax
008A0F2B mov dword ptr [ebp - 0x9c], ecx
008A0F31 call 0x4ab280
008A0F36 push eax
008A0F37 call 0x4ab660
008A0F3C mov ecx, eax
008A0F3E call 0xa2dbf0
008A0F43 mov eax, dword ptr [ebp - 0x9c]
008A0F49 mov edx, dword ptr [eax]
008A0F4B mov ecx, dword ptr [ebp - 0x9c]
008A0F51 mov eax, dword ptr [edx + 0x1ac]
008A0F57 call eax
008A0F59 lea ecx, [ebp - 0x6c]
008A0F5C call 0x4e12d0
008A0F61 push 0x51
008A0F63 push 0
008A0F65 lea ecx, [ebp - 0x6c]
008A0F68 push ecx
008A0F69 call 0x666960
008A0F6E add esp, 0xc
008A0F71 mov byte ptr [ebp - 0x4a], 0
008A0F75 mov byte ptr [ebp - 0x49], 0
008A0F79 mov byte ptr [ebp - 0x4b], 1
008A0F7D mov byte ptr [ebp - 0x4c], 1
008A0F81 mov byte ptr [ebp - 0x48], 0
008A0F85 call 0xa55fb0
008A0F8A mov ecx, eax
008A0F8C call 0xa55170
008A0F91 mov dword ptr [ebp - 0x70], eax
008A0F94 cmp dword ptr [ebp - 0x70], 0
008A0F98 je 0x8a0fa2
008A0F9A mov edx, dword ptr [ebp - 0x70]
008A0F9D mov eax, dword ptr [edx]
008A0F9F mov dword ptr [ebp - 0x42], eax
008A0FA2 mov ecx, dword ptr [ebp - 0x70]
008A0FA5 mov edx, dword ptr [ecx]
008A0FA7 mov dword ptr [ebp - 0x46], edx
008A0FAA mov byte ptr [ebp - 0x47], 1
008A0FAE mov byte ptr [ebp - 0x3e], 4
008A0FB2 xor eax, eax
008A0FB4 mov word ptr [ebp - 0x3d], ax
008A0FB8 mov ecx, dword ptr [0xbb050c]
008A0FBE mov dword ptr [ebp - 0x7c], ecx
008A0FC1 mov edx, dword ptr [0xbb0510]
008A0FC7 mov dword ptr [ebp - 0x78], edx
008A0FCA mov al, byte ptr [0xbb0514]
008A0FCF mov byte ptr [ebp - 0x74], al
008A0FD2 lea ecx, [ebp - 0x7c]
008A0FD5 push ecx
008A0FD6 lea edx, [ebp - 0x6c]
008A0FD9 push edx
008A0FDA call 0x665b40
008A0FDF add esp, 8
008A0FE2 lea eax, [ebp - 0x7c]
008A0FE5 push eax
008A0FE6 lea ecx, [ebp - 0x98]
008A0FEC call 0x405650
008A0FF1 mov dword ptr [ebp - 4], 0
008A0FF8 lea ecx, [ebp - 0x98]
008A0FFE push ecx
008A0FFF mov ecx, dword ptr [0x17c8708]
008A1005 call 0x4e6740
008A100A mov dword ptr [ebp - 4], 0xffffffff
008A1011 lea ecx, [ebp - 0x98]
008A1017 call 0x4056d0
008A101C push 1
008A101E mov ecx, dword ptr [0x17c8708]
008A1024 call 0x4b0fc0
008A1029 lea edx, [ebp - 0x6c]
008A102C push edx
008A102D mov ecx, dword ptr [0x17c870c]
008A1033 call 0x4e6760
008A1038 movzx eax, byte ptr [ebp - 0x3e]
008A103C push eax
008A103D call 0x8f9500
008A1042 mov ecx, eax
008A1044 call 0x8f89d0
008A1049 push 0x51
008A104B lea ecx, [ebp - 0x6c]
008A104E push ecx
008A104F push 0
008A1051 push 0xbc2
008A1056 call 0xa3c950
008A105B add esp, 0x10
008A105E mov ecx, dword ptr [ebp - 0xc]
008A1061 mov dword ptr fs:[0], ecx
008A1068 pop ecx
008A1069 mov ecx, dword ptr [ebp - 0x10]
008A106C xor ecx, ebp
008A106E call 0x6634fb
008A1073 mov esp, ebp
008A1075 pop ebp
008A1076 ret

; function 0x921430
00921430 push ebp
00921431 mov ebp, esp
00921433 push -1
00921435 push 0xac27a6
0092143A mov eax, dword ptr fs:[0]
00921440 push eax
00921441 sub esp, 0x90
00921447 mov eax, dword ptr [0xc7b480]
0092144C xor eax, ebp
0092144E mov dword ptr [ebp - 0x10], eax
00921451 push eax
00921452 lea eax, [ebp - 0xc]
00921455 mov dword ptr fs:[0], eax
0092145B mov dword ptr [ebp - 0x9c], ecx
00921461 call 0x4ab280
00921466 push eax
00921467 call 0x4ab660
0092146C mov ecx, eax
0092146E call 0xa2dbf0
00921473 mov eax, dword ptr [ebp - 0x9c]
00921479 mov edx, dword ptr [eax]
0092147B mov ecx, dword ptr [ebp - 0x9c]
00921481 mov eax, dword ptr [edx + 0x1ac]
00921487 call eax
00921489 lea ecx, [ebp - 0x6c]
0092148C call 0x4e12d0
00921491 push 0x51
00921493 push 0
00921495 lea ecx, [ebp - 0x6c]
00921498 push ecx
00921499 call 0x666960
0092149E add esp, 0xc
009214A1 mov byte ptr [ebp - 0x4a], 0
009214A5 mov byte ptr [ebp - 0x49], 0
009214A9 mov byte ptr [ebp - 0x4b], 1
009214AD mov byte ptr [ebp - 0x4c], 1
009214B1 mov byte ptr [ebp - 0x48], 0
009214B5 call 0xa55fb0
009214BA mov ecx, eax
009214BC call 0xa55170
009214C1 mov dword ptr [ebp - 0x70], eax
009214C4 cmp dword ptr [ebp - 0x70], 0
009214C8 je 0x9214d2
009214CA mov edx, dword ptr [ebp - 0x70]
009214CD mov eax, dword ptr [edx]
009214CF mov dword ptr [ebp - 0x42], eax
009214D2 mov ecx, dword ptr [ebp - 0x70]
009214D5 mov edx, dword ptr [ecx]
009214D7 mov dword ptr [ebp - 0x46], edx
009214DA mov byte ptr [ebp - 0x47], 1
009214DE mov byte ptr [ebp - 0x3e], 4
009214E2 xor eax, eax
009214E4 mov word ptr [ebp - 0x3d], ax
009214E8 mov ecx, dword ptr [0xbb050c]
009214EE mov dword ptr [ebp - 0x7c], ecx
009214F1 mov edx, dword ptr [0xbb0510]
009214F7 mov dword ptr [ebp - 0x78], edx
009214FA mov al, byte ptr [0xbb0514]
009214FF mov byte ptr [ebp - 0x74], al
00921502 lea ecx, [ebp - 0x7c]
00921505 push ecx
00921506 lea edx, [ebp - 0x6c]
00921509 push edx
0092150A call 0x665b40
0092150F add esp, 8
00921512 lea eax, [ebp - 0x7c]
00921515 push eax
00921516 lea ecx, [ebp - 0x98]
0092151C call 0x405650
00921521 mov dword ptr [ebp - 4], 0
00921528 lea ecx, [ebp - 0x98]
0092152E push ecx
0092152F mov ecx, dword ptr [0x17c8708]
00921535 call 0x4e6740
0092153A mov dword ptr [ebp - 4], 0xffffffff
00921541 lea ecx, [ebp - 0x98]
00921547 call 0x4056d0
0092154C push 1
0092154E mov ecx, dword ptr [0x17c8708]
00921554 call 0x4b0fc0
00921559 lea edx, [ebp - 0x6c]
0092155C push edx
0092155D mov ecx, dword ptr [0x17c870c]
00921563 call 0x4e6760
00921568 movzx eax, byte ptr [ebp - 0x3e]
0092156C push eax
0092156D call 0x8f9500
00921572 mov ecx, eax
00921574 call 0x8f89d0
00921579 push 0x51
0092157B lea ecx, [ebp - 0x6c]
0092157E push ecx
0092157F push 0
00921581 push 0xbc2
00921586 call 0xa3c950
0092158B add esp, 0x10
0092158E mov ecx, dword ptr [ebp - 0xc]
00921591 mov dword ptr fs:[0], ecx
00921598 pop ecx
00921599 mov ecx, dword ptr [ebp - 0x10]
0092159C xor ecx, ebp
0092159E call 0x6634fb
009215A3 mov esp, ebp
009215A5 pop ebp
009215A6 ret

; function 0x8253a0
008253A0 push ebp
008253A1 mov ebp, esp
008253A3 sub esp, 0xbc
008253A9 mov eax, dword ptr [0xc7b480]
008253AE xor eax, ebp
008253B0 mov dword ptr [ebp - 8], eax
008253B3 push esi
008253B4 push edi
008253B5 mov dword ptr [ebp - 0xb4], ecx
008253BB cmp dword ptr [ebp + 8], 0
008253BF je 0x8253c7
008253C1 cmp dword ptr [ebp + 0xc], 0x53
008253C5 je 0x8253cc
008253C7 jmp 0x825629
008253CC mov eax, dword ptr [ebp + 8]
008253CF mov dword ptr [ebp - 4], eax
008253D2 mov ecx, dword ptr [ebp - 4]
008253D5 add ecx, 2
008253D8 push ecx
008253D9 mov ecx, dword ptr [0x17c870c]
008253DF call 0x4e6760
008253E4 mov edx, dword ptr [ebp - 4]
008253E7 movzx eax, word ptr [edx]
008253EA push eax
008253EB mov ecx, dword ptr [0x17c8708]
008253F1 call 0x549440
008253F6 push 1
008253F8 mov ecx, dword ptr [0x17c86fc]
008253FE call 0x402aa0
00825403 push edx
00825404 push eax
00825405 mov ecx, dword ptr [0x17c8708]
0082540B call 0x81bbe0
00825410 mov ecx, dword ptr [ebp - 4]
00825413 movzx edx, byte ptr [ecx + 0x30]
00825417 push edx
00825418 mov ecx, dword ptr [0x17c8708]
0082541E call 0x81b370
00825423 mov eax, dword ptr [ebp - 4]
00825426 movzx ecx, word ptr [eax + 0x31]
0082542A push ecx
0082542B mov ecx, dword ptr [0x17c8708]
00825431 call 0x81b8e0
00825436 call 0x8f9500
0082543B mov ecx, eax
0082543D call 0x8f88d0
00825442 movzx edx, al
00825445 test edx, edx
00825447 je 0x825452
00825449 mov dword ptr [ebp - 0x48], 1
00825450 jmp 0x82546d
00825452 mov ecx, dword ptr [0x17c8708]
00825458 call 0x4b1030
0082545D push edx
0082545E push eax
0082545F mov ecx, dword ptr [0x17c8708]
00825465 call 0x818c00
0082546A mov dword ptr [ebp - 0x48], eax
0082546D mov eax, dword ptr [ebp - 4]
00825470 movzx ecx, byte ptr [eax + 0x30]
00825474 cmp ecx, 4
00825477 jne 0x825487
00825479 push 0
0082547B call 0x4164e0
00825480 mov ecx, eax
00825482 call 0x4f35a0
00825487 mov edx, dword ptr [ebp - 4]
0082548A mov eax, dword ptr [edx + 0x2c]
0082548D push eax
0082548E mov ecx, dword ptr [edx + 0x28]
00825491 push ecx
00825492 mov ecx, dword ptr [0x17c8708]
00825498 call 0x81aa40
0082549D push 0
0082549F mov ecx, dword ptr [0x17c8708]
008254A5 call 0x817ce0
008254AA mov ecx, dword ptr [0x17c870c]
008254B0 call 0x4d9870
008254B5 mov ecx, 0x14
008254BA mov esi, eax
008254BC lea edi, [ebp - 0xa0]
008254C2 rep movsd dword ptr es:[edi], dword ptr [esi]
008254C4 movsb byte ptr es:[edi], byte ptr [esi]
008254C5 push 0x30
008254C7 push 0
008254C9 lea edx, [ebp - 0x38]
008254CC push edx
008254CD call 0x666960
008254D2 add esp, 0xc
008254D5 mov al, byte ptr [ebp - 0x7e]
008254D8 mov byte ptr [ebp - 0x2e], al
008254DB mov cl, byte ptr [ebp - 0x7b]
008254DE mov byte ptr [ebp - 0x2d], cl
008254E1 mov dl, byte ptr [ebp - 0x7f]
008254E4 mov byte ptr [ebp - 0x2f], dl
008254E7 mov al, byte ptr [ebp - 0x80]
008254EA mov byte ptr [ebp - 0x30], al
008254ED mov ecx, dword ptr [ebp - 0x7a]
008254F0 mov dword ptr [ebp - 0x38], ecx
008254F3 mov edx, dword ptr [ebp - 0x76]
008254F6 mov dword ptr [ebp - 0x34], edx
008254F9 mov al, byte ptr [ebp - 0x7d]
008254FC mov byte ptr [ebp - 0x2c], al
008254FF mov cl, byte ptr [ebp - 0x7c]
00825502 mov byte ptr [ebp - 0x2b], cl
00825505 mov dx, word ptr [ebp - 0x71]
00825509 mov word ptr [ebp - 0xa], dx
0082550D push 0x15
0082550F lea eax, [ebp - 0xa0]
00825515 push eax
00825516 lea ecx, [ebp - 0x2a]
00825519 push ecx
0082551A call 0x6636a0
0082551F add esp, 0xc
00825522 push 0xb
00825524 lea edx, [ebp - 0x8b]
0082552A push edx
0082552B lea eax, [ebp - 0x15]
0082552E push eax
0082552F call 0x6636a0
00825534 add esp, 0xc
00825537 mov ecx, dword ptr [0x17c8708]
0082553D call 0x81b800
00825542 mov dword ptr [ebp - 0xb8], eax
00825548 lea ecx, [ebp - 0x38]
0082554B push ecx
0082554C mov edx, dword ptr [ebp - 0xb8]
00825552 mov eax, dword ptr [edx]
00825554 mov ecx, dword ptr [ebp - 0xb8]
0082555A mov edx, dword ptr [eax + 0x1c8]
00825560 call edx
00825562 mov eax, dword ptr [ebp - 0x65]
00825565 push eax
00825566 mov ecx, dword ptr [0x17c8708]
0082556C call 0x81a300
00825571 mov ecx, dword ptr [0x17c86fc]
00825577 call 0x402aa0
0082557C mov dword ptr [ebp - 0x44], eax
0082557F mov dword ptr [ebp - 0x40], edx
00825582 mov dword ptr [ebp - 0x3c], 0
00825589 push 0xc
0082558B lea ecx, [ebp - 0x44]
0082558E push ecx
0082558F push 0
00825591 push 0xdde
00825596 call 0xa3c950
0082559B add esp, 0x10
0082559E mov ecx, dword ptr [0x17c86fc]
008255A4 call 0x481080
008255A9 movzx edx, al
008255AC test edx, edx
008255AE je 0x8255ec
008255B0 mov eax, dword ptr [ebp - 4]
008255B3 movzx ecx, byte ptr [eax + 0x33]
008255B7 test ecx, ecx
008255B9 je 0x8255ec
008255BB mov edx, dword ptr [ebp - 4]
008255BE movzx eax, byte ptr [edx + 0x38]
008255C2 test eax, eax
008255C4 jne 0x8255ec
008255C6 mov ecx, dword ptr [0x17c870c]
008255CC call 0x92e3c0
008255D1 mov dword ptr [ebp - 0xbc], eax
008255D7 mov ecx, dword ptr [ebp - 0xbc]
008255DD mov edx, dword ptr [ecx]
008255DF mov ecx, dword ptr [ebp - 0xbc]
008255E5 mov eax, dword ptr [edx + 0xc]
008255E8 call eax
008255EA jmp 0x825629
008255EC push 0xe
008255EE push 0
008255F0 lea ecx, [ebp - 0xb0]
008255F6 push ecx
008255F7 call 0x666960
008255FC add esp, 0xc
008255FF mov ecx, dword ptr [0x17c8708]
00825605 call 0x4b1050
0082560A mov word ptr [ebp - 0xb0], ax
00825611 push 0xe
00825613 lea edx, [ebp - 0xb0]
00825619 push edx
0082561A push 0
0082561C push 0xbfe
00825621 call 0xa3c950
00825626 add esp, 0x10
00825629 pop edi
0082562A pop esi
0082562B mov ecx, dword ptr [ebp - 8]
0082562E xor ecx, ebp
00825630 call 0x6634fb
00825635 mov esp, ebp
00825637 pop ebp
00825638 ret 8

; function 0x96a2b0
0096A2B0 push ebp
0096A2B1 mov ebp, esp
0096A2B3 push ecx
0096A2B4 mov dword ptr [ebp - 4], ecx
0096A2B7 mov ecx, dword ptr [0x17c8708]
0096A2BD call 0x819120
0096A2C2 test eax, eax
0096A2C4 je 0x96a2ee
0096A2C6 mov ecx, dword ptr [0x17c8708]
0096A2CC call 0x819120
0096A2D1 mov ecx, eax
0096A2D3 call 0x4536e0
0096A2D8 cmp eax, 2
0096A2DB jne 0x96a2ee
0096A2DD push 0
0096A2DF push 0x101c
0096A2E4 call 0xa3ca00
0096A2E9 add esp, 8
0096A2EC jmp 0x96a2fd
0096A2EE push 0
0096A2F0 push 0xc26
0096A2F5 call 0xa3ca00
0096A2FA add esp, 8
0096A2FD mov esp, ebp
0096A2FF pop ebp
0096A300 ret

; function 0x96ab90
0096AB90 push ebp
0096AB91 mov ebp, esp
0096AB93 push ecx
0096AB94 mov dword ptr [ebp - 4], ecx
0096AB97 mov ecx, dword ptr [0x17c8708]
0096AB9D call 0x819120
0096ABA2 test eax, eax
0096ABA4 je 0x96abcd
0096ABA6 push 1
0096ABA8 mov ecx, dword ptr [0x17c8708]
0096ABAE call 0x819120
0096ABB3 push eax
0096ABB4 mov ecx, dword ptr [0x17c8708]
0096ABBA call 0x819120
0096ABBF mov ecx, eax
0096ABC1 call 0x401040
0096ABC6 mov ecx, eax
0096ABC8 call 0x9de260
0096ABCD push 0
0096ABCF mov eax, dword ptr [ebp - 4]
0096ABD2 mov ecx, dword ptr [eax + 0x10]
0096ABD5 call 0x96b080
0096ABDA push 0xa
0096ABDC mov ecx, dword ptr [ebp - 4]
0096ABDF call 0x96a1a0
0096ABE4 mov esp, ebp
0096ABE6 pop ebp
0096ABE7 ret

; function 0x953a30
00953A30 push ebp
00953A31 mov ebp, esp
00953A33 sub esp, 0x14
00953A36 mov dword ptr [ebp - 0x14], ecx
00953A39 mov eax, dword ptr [ebp - 0x14]
00953A3C mov ecx, dword ptr [eax + 0x5c]
00953A3F cmp dword ptr [ecx], 0xe
00953A42 jge 0x953a93
00953A44 push 0xd
00953A46 push 0
00953A48 lea edx, [ebp - 0x10]
00953A4B push edx
00953A4C call 0x666960
00953A51 add esp, 0xc
00953A54 mov eax, dword ptr [ebp - 0x14]
00953A57 mov ecx, dword ptr [eax + 0x5c]
00953A5A mov edx, dword ptr [ecx]
00953A5C mov dword ptr [ebp - 0xc], edx
00953A5F mov eax, dword ptr [ebp - 0x14]
00953A62 mov ecx, dword ptr [eax + 0x1c]
00953A65 mov dword ptr [ebp - 0x10], ecx
00953A68 mov edx, dword ptr [ebp - 0x14]
00953A6B mov eax, dword ptr [edx + 0xcc]
00953A71 mov dword ptr [ebp - 8], eax
00953A74 push 0xd
00953A76 lea ecx, [ebp - 0x10]
00953A79 push ecx
00953A7A push 0
00953A7C push 0x184c
00953A81 call 0xa3c950
00953A86 add esp, 0x10
00953A89 mov ecx, dword ptr [ebp - 0x14]
00953A8C call 0x953890
00953A91 jmp 0x953aa3
00953A93 mov ecx, dword ptr [ebp - 0x14]
00953A96 call 0x953960
00953A9B mov ecx, dword ptr [ebp - 0x14]
00953A9E call 0x953890
00953AA3 mov esp, ebp
00953AA5 pop ebp
00953AA6 ret

; function 0x953910
00953910 push ebp
00953911 mov ebp, esp
00953913 sub esp, 8
00953916 mov dword ptr [ebp - 8], ecx
00953919 cmp dword ptr [ebp + 8], 0
0095391D je 0x953925
0095391F cmp dword ptr [ebp + 0xc], 0x11
00953923 je 0x953927
00953925 jmp 0x95394f
00953927 mov eax, dword ptr [ebp + 8]
0095392A mov dword ptr [ebp - 4], eax
0095392D mov ecx, dword ptr [ebp - 8]
00953930 call 0x953890
00953935 mov ecx, dword ptr [ebp - 4]
00953938 push ecx
00953939 call 0x4abdb0
0095393E mov ecx, eax
00953940 call 0x94d1f0
00953945 push 7
00953947 mov ecx, dword ptr [ebp - 8]
0095394A call 0x952100
0095394F mov esp, ebp
00953951 pop ebp
00953952 ret 8
