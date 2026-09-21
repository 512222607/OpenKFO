; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; function 0x821c40
00821C40  push ebp
00821C41  mov ebp, esp
00821C43  sub esp, 0x90
00821C49  mov dword ptr [ebp - 0x90], ecx
00821C4F  cmp dword ptr [ebp + 8], 0
00821C53  je 0x821c5b
00821C55  cmp dword ptr [ebp + 0xc], 7
00821C59  jae 0x821c60
00821C5B  jmp 0x821d1b
00821C60  mov eax, dword ptr [ebp + 8]
00821C63  mov dword ptr [ebp - 4], eax
00821C66  mov dword ptr [ebp - 0x8c], 0
00821C70  jmp 0x821c81
00821C72  mov ecx, dword ptr [ebp - 0x8c]
00821C78  add ecx, 1
00821C7B  mov dword ptr [ebp - 0x8c], ecx
00821C81  mov eax, dword ptr [ebp + 0xc]
00821C84  xor edx, edx
00821C86  mov ecx, 7
00821C8B  div ecx
00821C8D  cmp dword ptr [ebp - 0x8c], eax
00821C93  jae 0x821d0d
00821C95  push 0x7b
00821C97  push 0
00821C99  lea edx, [ebp - 0x88]
00821C9F  push edx
00821CA0  call 0x666960
00821CA5  add esp, 0xc
00821CA8  mov eax, dword ptr [ebp - 0x8c]
00821CAE  imul eax, eax, 7
00821CB1  mov ecx, dword ptr [ebp - 4]
00821CB4  mov dl, byte ptr [ecx + eax + 6]
00821CB8  mov byte ptr [ebp - 0x82], dl
00821CBE  mov dword ptr [ebp - 0x81], 0
00821CC8  mov eax, dword ptr [ebp - 0x8c]
00821CCE  imul eax, eax, 7
00821CD1  mov ecx, dword ptr [ebp - 4]
00821CD4  mov edx, dword ptr [ecx + eax]
00821CD7  mov dword ptr [ebp - 0x88], edx
00821CDD  mov eax, dword ptr [ebp - 0x8c]
00821CE3  imul eax, eax, 7
00821CE6  mov ecx, dword ptr [ebp - 4]
00821CE9  mov dx, word ptr [ecx + eax + 4]
00821CEE  mov word ptr [ebp - 0x84], dx
00821CF5  lea eax, [ebp - 0x88]
00821CFB  push eax
00821CFC  call 0x4044d0
00821D01  mov ecx, eax
00821D03  call 0xa48fc0
00821D08  jmp 0x821c72
00821D0D  push 0
00821D0F  call 0x4e7570
00821D14  mov ecx, eax
00821D16  call 0x833370
00821D1B  mov esp, ebp
00821D1D  pop ebp

; function 0x821b90
00821B90  push ebp
00821B91  mov ebp, esp
00821B93  sub esp, 8
00821B96  mov dword ptr [ebp - 8], ecx
00821B99  mov eax, dword ptr [ebp + 8]
00821B9C  mov dword ptr [ebp - 4], eax
00821B9F  mov ecx, dword ptr [ebp - 4]
00821BA2  movzx edx, word ptr [ecx + 0xc]
00821BA6  push edx
00821BA7  call 0x4044d0
00821BAC  mov ecx, eax
00821BAE  call 0xa47690
00821BB3  push -1
00821BB5  call 0x4e7570
00821BBA  mov ecx, eax
00821BBC  call 0x833370
00821BC1  mov esp, ebp
00821BC3  pop ebp
00821BC4  ret 8
00821BC7  int3
00821BC8  int3
00821BC9  int3
00821BCA  int3
00821BCB  int3
00821BCC  int3
00821BCD  int3
00821BCE  int3
00821BCF  int3

; function 0x821b50
00821B50  push ebp
00821B51  mov ebp, esp
00821B53  sub esp, 8
00821B56  mov dword ptr [ebp - 8], ecx
00821B59  mov eax, dword ptr [ebp + 8]
00821B5C  mov dword ptr [ebp - 4], eax
00821B5F  mov ecx, dword ptr [ebp - 4]
00821B62  movzx edx, word ptr [ecx + 0xc]
00821B66  push edx
00821B67  call 0x4044d0
00821B6C  mov ecx, eax
00821B6E  call 0xa47660
00821B73  push -1
00821B75  call 0x4e7570
00821B7A  mov ecx, eax
00821B7C  call 0x833370
00821B81  mov esp, ebp
00821B83  pop ebp
00821B84  ret 8
00821B87  int3
00821B88  int3
00821B89  int3
00821B8A  int3
00821B8B  int3
00821B8C  int3
00821B8D  int3
00821B8E  int3
00821B8F  int3

; function 0xa47660
00A47660  push ebp
00A47661  mov ebp, esp
00A47663  sub esp, 8
00A47666  mov dword ptr [ebp - 8], ecx
00A47669  movzx eax, word ptr [ebp + 8]
00A4766D  push eax
00A4766E  mov ecx, dword ptr [ebp - 8]
00A47671  call 0xa47400
00A47676  mov dword ptr [ebp - 4], eax
00A47679  cmp dword ptr [ebp - 4], 0
00A4767D  je 0xa47686
00A4767F  mov ecx, dword ptr [ebp - 4]
00A47682  mov byte ptr [ecx + 6], 1
00A47686  mov esp, ebp
00A47688  pop ebp
00A47689  ret 4
00A4768C  int3
00A4768D  int3
00A4768E  int3
00A4768F  int3
00A47690  push ebp
00A47691  mov ebp, esp
00A47693  sub esp, 0xc
00A47696  push esi
00A47697  push edi
00A47698  mov dword ptr [ebp - 0xc], ecx
00A4769B  movzx eax, word ptr [ebp + 8]
00A4769F  push eax
00A476A0  mov ecx, dword ptr [ebp - 0xc]
00A476A3  call 0xa47400
00A476A8  mov dword ptr [ebp - 4], eax
00A476AB  cmp dword ptr [ebp - 4], 0
00A476AF  je 0xa476f1
00A476B1  mov ecx, dword ptr [ebp - 4]
00A476B4  mov byte ptr [ecx + 6], 2
00A476B8  mov ecx, dword ptr [0x17c86fc]
00A476BE  call 0x9cd390
00A476C3  mov dword ptr [ebp - 8], eax
00A476C6  cmp dword ptr [ebp - 8], 0
00A476CA  je 0xa476f1
00A476CC  mov edx, dword ptr [ebp - 4]
00A476CF  mov eax, dword ptr [ebp - 8]
00A476D2  mov ecx, dword ptr [eax + 0x81]
00A476D8  mov dword ptr [edx + 7], ecx
00A476DB  mov esi, dword ptr [ebp - 8]
00A476DE  add esi, 0x85
00A476E4  mov edi, dword ptr [ebp - 4]
00A476E7  add edi, 0xb
00A476EA  mov ecx, 0x1c
00A476EF  rep movsd dword ptr es:[edi], dword ptr [esi]
00A476F1  pop edi
00A476F2  pop esi
00A476F3  mov esp, ebp
00A476F5  pop ebp
00A476F6  ret 4
00A476F9  int3
00A476FA  int3
00A476FB  int3
00A476FC  int3
00A476FD  int3
00A476FE  int3
00A476FF  int3

; function 0xa48d90
00A48D90  push ebp
00A48D91  mov ebp, esp
00A48D93  sub esp, 0x14
00A48D96  mov dword ptr [ebp - 0x14], ecx
00A48D99  movzx eax, word ptr [ebp + 8]
00A48D9D  push eax
00A48D9E  mov ecx, dword ptr [ebp - 0x14]
00A48DA1  call 0xa47400
00A48DA6  mov dword ptr [ebp - 8], eax
00A48DA9  cmp dword ptr [ebp - 8], 0
00A48DAD  je 0xa48db6
00A48DAF  mov ecx, dword ptr [ebp - 8]
00A48DB2  mov byte ptr [ecx + 6], 3
00A48DB6  movzx edx, word ptr [ebp + 8]
00A48DBA  push edx
00A48DBB  mov ecx, dword ptr [ebp - 0x14]
00A48DBE  call 0xa47d00
00A48DC3  mov dword ptr [ebp - 0xc], eax
00A48DC6  mov ecx, dword ptr [0x17c86fc]
00A48DCC  call 0x9cd390
00A48DD1  mov dword ptr [ebp - 4], eax
00A48DD4  mov eax, dword ptr [ebp - 4]
00A48DD7  movzx ecx, byte ptr [eax + 0x7b]
00A48DDB  mov edx, dword ptr [ebp - 0xc]
00A48DDE  movzx eax, word ptr [edx + 0xd]
00A48DE2  cmp ecx, eax
00A48DE4  jge 0xa48df2
00A48DE6  mov ecx, dword ptr [ebp - 4]
00A48DE9  mov edx, dword ptr [ebp - 0xc]
00A48DEC  mov al, byte ptr [edx + 0xd]
00A48DEF  mov byte ptr [ecx + 0x7b], al
00A48DF2  movzx ecx, word ptr [ebp + 8]
00A48DF6  mov dword ptr [ebp - 0x10], ecx
00A48DF9  lea edx, [ebp - 0x10]
00A48DFC  push edx
00A48DFD  mov ecx, dword ptr [ebp - 0x14]
00A48E00  add ecx, 0xa8
00A48E06  call 0x4a5c30
00A48E0B  movzx eax, word ptr [ebp + 8]
00A48E0F  mov ecx, dword ptr [ebp - 0x14]
00A48E12  mov dword ptr [ecx + 0xf8], eax
00A48E18  mov ecx, dword ptr [ebp - 0x14]
00A48E1B  call 0xa47f70
00A48E20  mov esp, ebp
00A48E22  pop ebp
00A48E23  ret 4
00A48E26  int3
00A48E27  int3
00A48E28  int3
00A48E29  int3
00A48E2A  int3
00A48E2B  int3
00A48E2C  int3
00A48E2D  int3
00A48E2E  int3
00A48E2F  int3

; function 0x831400
00831400  push ebp
00831401  mov ebp, esp
00831403  sub esp, 0x18
00831406  mov dword ptr [ebp - 0x18], ecx
00831409  mov eax, dword ptr [ebp - 0x18]
0083140C  movzx ecx, word ptr [eax + 0x578]
00831413  push ecx
00831414  call 0x4044d0
00831419  mov ecx, eax
0083141B  call 0xa47400
00831420  mov dword ptr [ebp - 4], eax
00831423  cmp dword ptr [ebp - 4], 0
00831427  jne 0x83142b
00831429  jmp 0x83147a
0083142B  mov edx, dword ptr [ebp - 4]
0083142E  movzx eax, byte ptr [edx + 6]
00831432  cmp eax, 1
00831435  jne 0x83146a
00831437  mov ecx, dword ptr [0x17c86fc]
0083143D  call 0x4651d0
00831442  mov dword ptr [ebp - 0xc], eax
00831445  mov ecx, dword ptr [ebp - 0x18]
00831448  mov dx, word ptr [ecx + 0x578]
0083144F  mov word ptr [ebp - 8], dx
00831453  push 0xe
00831455  lea eax, [ebp - 0x14]
00831458  push eax
00831459  push 0
0083145B  push 0x17a2
00831460  call 0xa3c950
00831465  add esp, 0x10
00831468  jmp 0x831472
0083146A  mov ecx, dword ptr [ebp - 0x18]
0083146D  call 0x830c00
00831472  mov ecx, dword ptr [ebp - 0x18]
00831475  call 0x831380
0083147A  mov esp, ebp
0083147C  pop ebp
0083147D  ret
0083147E  int3
0083147F  int3

; function 0x5420d0
005420D0  push ebp
005420D1  mov ebp, esp
005420D3  push -1
005420D5  push 0xaebe28
005420DA  mov eax, dword ptr fs:[0]
005420E0  push eax
005420E1  sub esp, 0x48
005420E4  push esi
005420E5  mov eax, dword ptr [0xc7b480]
005420EA  xor eax, ebp
005420EC  push eax
005420ED  lea eax, [ebp - 0xc]
005420F0  mov dword ptr fs:[0], eax
005420F6  mov dword ptr [ebp - 0x50], ecx
005420F9  mov eax, dword ptr [ebp - 0x50]
005420FC  mov edx, dword ptr [eax]
005420FE  mov ecx, dword ptr [ebp - 0x50]
00542101  mov eax, dword ptr [edx + 0x1c]
00542104  call eax
00542106  push eax
00542107  call 0x4044d0
0054210C  mov ecx, eax
0054210E  call 0xa47360
00542113  mov dword ptr [ebp - 0x10], eax
00542116  mov ecx, dword ptr [ebp - 0x50]
00542119  mov edx, dword ptr [ecx]
0054211B  mov ecx, dword ptr [ebp - 0x50]
0054211E  mov eax, dword ptr [edx + 0x1c]
00542121  call eax
00542123  mov esi, eax
00542125  call 0x4044d0
0054212A  mov ecx, eax
0054212C  call 0x53be70
00542131  cmp esi, eax
00542133  jb 0x54220e
00542139  mov ecx, dword ptr [ebp - 0x50]
0054213C  mov edx, dword ptr [ecx]
0054213E  mov ecx, dword ptr [ebp - 0x50]
00542141  mov eax, dword ptr [edx + 0x1c]
00542144  call eax
00542146  mov esi, eax
00542148  call 0x4044d0
0054214D  mov ecx, eax
0054214F  call 0x53be70
00542154  sub esi, eax
00542156  push esi
00542157  call 0x404700
0054215C  mov ecx, eax
0054215E  call 0xa47840
00542163  mov dword ptr [ebp - 0x14], eax
00542166  cmp dword ptr [ebp - 0x14], 0
0054216A  jne 0x542171
0054216C  jmp 0x5422aa
00542171  mov ecx, dword ptr [ebp - 0x14]
00542174  movzx edx, byte ptr [ecx + 0x10]
00542178  cmp edx, 1
0054217B  jne 0x542209
00542181  push 0x13
00542183  call 0x667fbb
00542188  add esp, 4
0054218B  mov dword ptr [ebp - 0x2c], eax
0054218E  mov eax, dword ptr [ebp - 0x2c]
00542191  mov dword ptr [ebp - 0x18], eax
00542194  push 0x13
00542196  push 0
00542198  mov ecx, dword ptr [ebp - 0x18]
0054219B  push ecx
0054219C  call 0x666960
005421A1  add esp, 0xc
005421A4  mov edx, dword ptr [ebp - 0x18]
005421A7  mov byte ptr [edx + 2], 2
005421AB  mov ecx, dword ptr [0x17c86fc]
005421B1  call 0x4651d0
005421B6  mov ecx, dword ptr [ebp - 0x18]
005421B9  mov dword ptr [ecx + 3], eax
005421BC  mov ecx, dword ptr [0x17c86fc]
005421C2  call 0x402aa0
005421C7  mov ecx, dword ptr [ebp - 0x18]
005421CA  mov dword ptr [ecx + 7], eax
005421CD  mov dword ptr [ecx + 0xb], edx
005421D0  mov edx, dword ptr [ebp - 0x14]
005421D3  movzx eax, word ptr [edx + 0xc]
005421D7  sub eax, 0xfa0
005421DC  mov ecx, dword ptr [ebp - 0x18]
005421DF  mov word ptr [ecx], ax
005421E2  push 0x13
005421E4  mov edx, dword ptr [ebp - 0x18]
005421E7  push edx
005421E8  push 0
005421EA  push 0x17a5
005421EF  call 0xa3c950
005421F4  add esp, 0x10
005421F7  mov eax, dword ptr [ebp - 0x18]
005421FA  mov dword ptr [ebp - 0x30], eax
005421FD  mov ecx, dword ptr [ebp - 0x30]
00542200  push ecx
00542201  call 0x6634f0
00542206  add esp, 4
00542209  jmp 0x5422aa
0054220E  cmp dword ptr [ebp - 0x10], 0
00542212  je 0x542261
00542214  mov edx, dword ptr [ebp - 0x10]
00542217  movzx eax, byte ptr [edx + 6]
0054221B  cmp eax, 1
0054221E  jne 0x542261
00542220  mov ecx, dword ptr [0x17c86fc]
00542226  call 0x4651d0
0054222B  mov dword ptr [ebp - 0x20], eax
0054222E  mov ecx, dword ptr [0x17c86fc]
00542234  call 0x402aa0
00542239  mov dword ptr [ebp - 0x28], eax
0054223C  mov dword ptr [ebp - 0x24], edx
0054223F  mov ecx, dword ptr [ebp - 0x10]
00542242  mov dx, word ptr [ecx + 4]
00542246  mov word ptr [ebp - 0x1c], dx
0054224A  push 0xe
0054224C  lea eax, [ebp - 0x28]
0054224F  push eax
00542250  push 0
00542252  push 0x17a2
00542257  call 0xa3c950
0054225C  add esp, 0x10
0054225F  jmp 0x542269
00542261  mov ecx, dword ptr [ebp - 0x50]
00542264  call 0x53f220
00542269  mov ecx, dword ptr [0xb9743c]
0054226F  push ecx
00542270  lea ecx, [ebp - 0x4c]
00542273  call 0x405650
00542278  mov dword ptr [ebp - 4], 0
0054227F  call 0x4e7570
00542284  mov dword ptr [ebp - 0x54], eax
00542287  lea edx, [ebp - 0x4c]
0054228A  push edx
0054228B  mov eax, dword ptr [ebp - 0x54]
0054228E  mov edx, dword ptr [eax]
00542290  mov ecx, dword ptr [ebp - 0x54]
00542293  mov eax, dword ptr [edx + 0x124]
00542299  call eax
0054229B  mov dword ptr [ebp - 4], 0xffffffff
005422A2  lea ecx, [ebp - 0x4c]
005422A5  call 0x4056d0
005422AA  mov ecx, dword ptr [ebp - 0xc]

; function 0x5422c0
005422C0  push ebp
005422C1  mov ebp, esp
005422C3  push -1
005422C5  push 0xaebe28
005422CA  mov eax, dword ptr fs:[0]
005422D0  push eax
005422D1  sub esp, 0x48
005422D4  push esi
005422D5  mov eax, dword ptr [0xc7b480]
005422DA  xor eax, ebp
005422DC  push eax
005422DD  lea eax, [ebp - 0xc]
005422E0  mov dword ptr fs:[0], eax
005422E6  mov dword ptr [ebp - 0x50], ecx
005422E9  mov eax, dword ptr [ebp - 0x50]
005422EC  mov edx, dword ptr [eax]
005422EE  mov ecx, dword ptr [ebp - 0x50]
005422F1  mov eax, dword ptr [edx + 0x1c]
005422F4  call eax
005422F6  push eax
005422F7  call 0x4044d0
005422FC  mov ecx, eax
005422FE  call 0xa47360
00542303  mov dword ptr [ebp - 0x10], eax
00542306  mov ecx, dword ptr [ebp - 0x50]
00542309  mov edx, dword ptr [ecx]
0054230B  mov ecx, dword ptr [ebp - 0x50]
0054230E  mov eax, dword ptr [edx + 0x1c]
00542311  call eax
00542313  mov esi, eax
00542315  call 0x4044d0
0054231A  mov ecx, eax
0054231C  call 0x53be70
00542321  cmp esi, eax
00542323  jb 0x5423fe
00542329  mov ecx, dword ptr [ebp - 0x50]
0054232C  mov edx, dword ptr [ecx]
0054232E  mov ecx, dword ptr [ebp - 0x50]
00542331  mov eax, dword ptr [edx + 0x1c]
00542334  call eax
00542336  mov esi, eax
00542338  call 0x4044d0
0054233D  mov ecx, eax
0054233F  call 0x53be70
00542344  sub esi, eax
00542346  push esi
00542347  call 0x404700
0054234C  mov ecx, eax
0054234E  call 0xa47840
00542353  mov dword ptr [ebp - 0x14], eax
00542356  cmp dword ptr [ebp - 0x14], 0
0054235A  jne 0x542361
0054235C  jmp 0x54249a
00542361  mov ecx, dword ptr [ebp - 0x14]
00542364  movzx edx, byte ptr [ecx + 0x10]
00542368  cmp edx, 2
0054236B  jne 0x5423f9
00542371  push 0x13
00542373  call 0x667fbb
00542378  add esp, 4
0054237B  mov dword ptr [ebp - 0x2c], eax
0054237E  mov eax, dword ptr [ebp - 0x2c]
00542381  mov dword ptr [ebp - 0x18], eax
00542384  push 0x13
00542386  push 0
00542388  mov ecx, dword ptr [ebp - 0x18]
0054238B  push ecx
0054238C  call 0x666960
00542391  add esp, 0xc
00542394  mov edx, dword ptr [ebp - 0x18]
00542397  mov byte ptr [edx + 2], 1
0054239B  mov ecx, dword ptr [0x17c86fc]
005423A1  call 0x4651d0
005423A6  mov ecx, dword ptr [ebp - 0x18]
005423A9  mov dword ptr [ecx + 3], eax
005423AC  mov ecx, dword ptr [0x17c86fc]
005423B2  call 0x402aa0
005423B7  mov ecx, dword ptr [ebp - 0x18]
005423BA  mov dword ptr [ecx + 7], eax
005423BD  mov dword ptr [ecx + 0xb], edx
005423C0  mov edx, dword ptr [ebp - 0x14]
005423C3  movzx eax, word ptr [edx + 0xc]
005423C7  sub eax, 0xfa0
005423CC  mov ecx, dword ptr [ebp - 0x18]
005423CF  mov word ptr [ecx], ax
005423D2  push 0x13
005423D4  mov edx, dword ptr [ebp - 0x18]
005423D7  push edx
005423D8  push 0
005423DA  push 0x17c3
005423DF  call 0xa3c950
005423E4  add esp, 0x10
005423E7  mov eax, dword ptr [ebp - 0x18]
005423EA  mov dword ptr [ebp - 0x30], eax
005423ED  mov ecx, dword ptr [ebp - 0x30]
005423F0  push ecx
005423F1  call 0x6634f0
005423F6  add esp, 4
005423F9  jmp 0x54249a
005423FE  cmp dword ptr [ebp - 0x10], 0
00542402  je 0x542451
00542404  mov edx, dword ptr [ebp - 0x10]
00542407  movzx eax, byte ptr [edx + 6]
0054240B  cmp eax, 2
0054240E  jne 0x542451
00542410  mov ecx, dword ptr [0x17c86fc]
00542416  call 0x4651d0
0054241B  mov dword ptr [ebp - 0x20], eax
0054241E  mov ecx, dword ptr [0x17c86fc]
00542424  call 0x402aa0
00542429  mov dword ptr [ebp - 0x28], eax
0054242C  mov dword ptr [ebp - 0x24], edx
0054242F  mov ecx, dword ptr [ebp - 0x10]
00542432  mov dx, word ptr [ecx + 4]
00542436  mov word ptr [ebp - 0x1c], dx
0054243A  push 0xe
0054243C  lea eax, [ebp - 0x28]
0054243F  push eax
00542440  push 0
00542442  push 0x17c0
00542447  call 0xa3c950
0054244C  add esp, 0x10
0054244F  jmp 0x542459
00542451  mov ecx, dword ptr [ebp - 0x50]
00542454  call 0x53f220
00542459  mov ecx, dword ptr [0xb97438]
0054245F  push ecx
00542460  lea ecx, [ebp - 0x4c]
00542463  call 0x405650
00542468  mov dword ptr [ebp - 4], 0
0054246F  call 0x4e7570
00542474  mov dword ptr [ebp - 0x54], eax
00542477  lea edx, [ebp - 0x4c]
0054247A  push edx
0054247B  mov eax, dword ptr [ebp - 0x54]
0054247E  mov edx, dword ptr [eax]
00542480  mov ecx, dword ptr [ebp - 0x54]
00542483  mov eax, dword ptr [edx + 0x124]
00542489  call eax
0054248B  mov dword ptr [ebp - 4], 0xffffffff
00542492  lea ecx, [ebp - 0x4c]
00542495  call 0x4056d0
0054249A  mov ecx, dword ptr [ebp - 0xc]
