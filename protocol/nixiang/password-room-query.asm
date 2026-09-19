; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Native password-room preflight, bounded read-only evidence.

; Block 0x7a264b
007A264B fld qword ptr [0xbe97a8]
007A2651 fstp qword ptr [esp]
007A2654 push 0xbe0884
007A2659 mov edx, dword ptr [ebp + 8]
007A265C push edx
007A265D call 0x6ad580
007A2662 add esp, 8
007A2665 fld qword ptr [0xbe97a0]
007A266B fstp qword ptr [esp]
007A266E push 0xbe089c
007A2673 mov eax, dword ptr [ebp + 8]
007A2676 push eax
007A2677 call 0x6ad580
007A267C add esp, 8
007A267F fld qword ptr [0xbe9798]
007A2685 fstp qword ptr [esp]
007A2688 push 0xbe08bc
007A268D mov ecx, dword ptr [ebp + 8]
007A2690 push ecx
007A2691 call 0x6ad580
007A2696 add esp, 8

; Block 0xb237f9
00B237F9 insb byte ptr es:[edi], dx
00B237FA loopne 0xb2382b
00B237FC add edi, eax
00B237FE add eax, 0x12fe070
00B23803 les ecx, ptr [ecx]
00B23805 add byte ptr [eax], al
00B23807 mov dword ptr [0x12fe074], 1
00B23811 mov dword ptr [ebp - 0x40], 0x825250
00B23818 mov dword ptr [ebp - 0x3c], 0
00B2381F mov dword ptr [ebp - 0x38], 0
00B23826 mov dword ptr [ebp - 0x34], 0
00B2382D mov eax, dword ptr [ebp - 0x40]
00B23830 mov dword ptr [0x12fe078], eax
00B23835 mov ecx, dword ptr [ebp - 0x3c]
00B23838 mov dword ptr [0x12fe07c], ecx
00B2383E mov edx, dword ptr [ebp - 0x38]
00B23841 mov dword ptr [0x12fe080], edx
00B23847 mov eax, dword ptr [ebp - 0x34]

; Block 0x9253b0
009253B0 push ebp
009253B1 mov ebp, esp
009253B3 push -1
009253B5 push 0xadbbbf
009253BA mov eax, dword ptr fs:[0]
009253C0 push eax
009253C1 sub esp, 0x128
009253C7 mov eax, dword ptr [0xc7b480]
009253CC xor eax, ebp
009253CE mov dword ptr [ebp - 0x14], eax
009253D1 push esi
009253D2 push eax
009253D3 lea eax, [ebp - 0xc]
009253D6 mov dword ptr fs:[0], eax
009253DC mov dword ptr [ebp - 0x114], ecx
009253E2 mov ecx, dword ptr [0x17c8708]
009253E8 call 0x81b800
009253ED mov dword ptr [ebp - 0x118], eax
009253F3 push 0
009253F5 mov eax, dword ptr [ebp - 0x118]
009253FB mov edx, dword ptr [eax]
009253FD mov ecx, dword ptr [ebp - 0x118]
00925403 mov eax, dword ptr [edx + 0x1cc]
00925409 call eax
0092540B mov dword ptr [ebp - 0x10], 0
00925412 mov dword ptr [ebp - 0x10], 0
00925419 jmp 0x925424
0092541B mov ecx, dword ptr [ebp - 0x10]
0092541E add ecx, 1
00925421 mov dword ptr [ebp - 0x10], ecx
00925424 cmp dword ptr [ebp - 0x10], 9
00925428 jae 0x925944
0092542E lea edx, [ebp - 0x10]
00925431 push edx
00925432 lea eax, [ebp - 0x6c]
00925435 push eax
00925436 call 0xa44160
0092543B add esp, 8
0092543E mov dword ptr [ebp - 0x11c], eax
00925444 mov ecx, dword ptr [ebp - 0x11c]
0092544A mov dword ptr [ebp - 0x120], ecx
00925450 mov dword ptr [ebp - 4], 0
00925457 mov edx, dword ptr [ebp - 0x120]
0092545D push edx
0092545E mov eax, dword ptr [0xb99d30]
00925463 push eax
00925464 lea ecx, [ebp - 0x30]
00925467 push ecx
00925468 call 0x411d70
0092546D add esp, 0xc
00925470 mov byte ptr [ebp - 4], 2
00925474 lea ecx, [ebp - 0x6c]
00925477 call 0x4056d0
0092547C lea edx, [ebp - 0x30]
0092547F push edx
00925480 mov eax, dword ptr [ebp + 0xc]
00925483 push eax
00925484 call 0x4221c0
00925489 add esp, 8
0092548C movzx ecx, al
0092548F test ecx, ecx
00925491 je 0x925930
00925497 mov edx, dword ptr [ebp - 0x10]
0092549A push edx
0092549B mov ecx, dword ptr [0x17c870c]
009254A1 call 0x4e71b0
009254A6 mov byte ptr [ebp - 0x6d], al
009254A9 lea eax, [ebp - 0x6d]
009254AC push eax
009254AD lea ecx, [ebp - 0x38]
009254B0 push ecx
009254B1 mov ecx, dword ptr [0x17c870c]
009254B7 call 0x4e1550
009254BC lea ecx, [ebp - 0x38]
009254BF call 0x4305b0
009254C4 mov dl, byte ptr [eax + 0x2d]
009254C7 mov byte ptr [ebp - 0x39], dl
009254CA movzx eax, byte ptr [ebp - 0x39]
009254CE cmp eax, 0xf
009254D1 je 0x9254ee
009254D3 movzx ecx, byte ptr [ebp - 0x39]
009254D7 cmp ecx, 0xa
009254DA je 0x9254ee
009254DC movzx edx, byte ptr [ebp - 0x39]
009254E0 cmp edx, 0x15
009254E3 je 0x9254ee
009254E5 movzx eax, byte ptr [ebp - 0x39]
009254E9 cmp eax, 5
009254EC jne 0x9254fe
009254EE push 0
009254F0 call 0x41bdf0
009254F5 mov ecx, eax
009254F7 call 0x7fdbc0
009254FC jmp 0x92550c
009254FE push 1
00925500 call 0x41bdf0
00925505 mov ecx, eax
00925507 call 0x7fdbc0
0092550C lea ecx, [ebp - 0x78]
0092550F push ecx
00925510 mov ecx, dword ptr [0x17c870c]
00925516 call 0x45abb0
0092551B push eax
0092551C lea ecx, [ebp - 0x38]
0092551F call 0x4ab8f0
00925524 movzx edx, al
00925527 test edx, edx
00925529 je 0x925930
0092552F lea ecx, [ebp - 0x38]
00925532 call 0x4305b0
00925537 movzx eax, byte ptr [eax + 0x2a]
0092553B test eax, eax
0092553D jne 0x9255a4
0092553F push 0xbb05ac
00925544 lea ecx, [ebp - 0x94]
0092554A call 0x405650
0092554F mov byte ptr [ebp - 4], 3
00925553 call 0x403820
00925558 mov dword ptr [ebp - 0x124], eax
0092555E push 0
00925560 push 0
00925562 push 0
00925564 lea ecx, [ebp - 0x94]
0092556A push ecx
0092556B mov edx, dword ptr [ebp - 0x124]
00925571 mov eax, dword ptr [edx]
00925573 mov ecx, dword ptr [ebp - 0x124]
00925579 mov edx, dword ptr [eax + 0x1c0]
0092557F call edx
00925581 mov byte ptr [ebp - 4], 2
00925585 lea ecx, [ebp - 0x94]
0092558B call 0x4056d0
00925590 mov dword ptr [ebp - 4], 0xffffffff
00925597 lea ecx, [ebp - 0x30]
0092559A call 0x4056d0
0092559F jmp 0x925944
009255A4 cmp dword ptr [ebp + 8], 0x309
009255AB jne 0x9256cb
009255B1 lea ecx, [ebp - 0x38]
009255B4 call 0x4305b0
009255B9 movzx eax, byte ptr [eax + 0x23]
009255BD test eax, eax
009255BF jne 0x925638
009255C1 mov ecx, dword ptr [0x17c86fc]
009255C7 call 0x481080
009255CC movzx ecx, al
009255CF test ecx, ecx
009255D1 jne 0x925638
009255D3 push 0xbb05bc
009255D8 lea ecx, [ebp - 0xb0]
009255DE call 0x405650
009255E3 mov byte ptr [ebp - 4], 4
009255E7 call 0x403820
009255EC mov dword ptr [ebp - 0x128], eax
009255F2 push 0
009255F4 push 0
009255F6 push 0
009255F8 lea edx, [ebp - 0xb0]
009255FE push edx
009255FF mov eax, dword ptr [ebp - 0x128]
00925605 mov edx, dword ptr [eax]
00925607 mov ecx, dword ptr [ebp - 0x128]
0092560D mov eax, dword ptr [edx + 0x1c0]
00925613 call eax
00925615 mov byte ptr [ebp - 4], 2
00925619 lea ecx, [ebp - 0xb0]
0092561F call 0x4056d0
00925624 mov dword ptr [ebp - 4], 0xffffffff
0092562B lea ecx, [ebp - 0x30]
0092562E call 0x4056d0
00925633 jmp 0x925944
00925638 lea ecx, [ebp - 0x38]
0092563B call 0x4305b0
00925640 movzx esi, word ptr [eax + 0x26]
00925644 lea ecx, [ebp - 0x38]
00925647 call 0x4305b0
0092564C movzx ecx, word ptr [eax + 0x24]
00925650 cmp esi, ecx
00925652 jl 0x9256cb
00925654 mov ecx, dword ptr [0x17c86fc]
0092565A call 0x481080
0092565F movzx edx, al
00925662 test edx, edx
00925664 jne 0x9256cb
00925666 push 0xbb05d0
0092566B lea ecx, [ebp - 0xcc]
00925671 call 0x405650
00925676 mov byte ptr [ebp - 4], 5
0092567A call 0x403820
0092567F mov dword ptr [ebp - 0x12c], eax
00925685 push 0
00925687 push 0
00925689 push 0
0092568B lea eax, [ebp - 0xcc]
00925691 push eax
00925692 mov ecx, dword ptr [ebp - 0x12c]
00925698 mov edx, dword ptr [ecx]
0092569A mov ecx, dword ptr [ebp - 0x12c]
009256A0 mov eax, dword ptr [edx + 0x1c0]
009256A6 call eax
009256A8 mov byte ptr [ebp - 4], 2
009256AC lea ecx, [ebp - 0xcc]
009256B2 call 0x4056d0
009256B7 mov dword ptr [ebp - 4], 0xffffffff
009256BE lea ecx, [ebp - 0x30]
009256C1 call 0x4056d0
009256C6 jmp 0x925944
009256CB lea ecx, [ebp - 0x38]
009256CE call 0x4305b0
009256D3 movzx ecx, byte ptr [eax + 0x20]
009256D7 test ecx, ecx
009256D9 je 0x92572e
009256DB cmp dword ptr [ebp + 8], 0x309
009256E2 jne 0x9256f4
009256E4 push 1
009256E6 call 0x4e77f0
009256EB mov ecx, eax
009256ED call 0x4e7870
009256F2 jmp 0x925702
009256F4 push 0
009256F6 call 0x4e77f0
009256FB mov ecx, eax
009256FD call 0x4e7870
00925702 mov edx, dword ptr [ebp - 0x10]
00925705 push edx
00925706 mov ecx, dword ptr [0x17c870c]
0092570C call 0x4e71b0
00925711 mov byte ptr [ebp - 0x3a], al
00925714 push 1
00925716 lea eax, [ebp - 0x3a]
00925719 push eax
0092571A push 0
0092571C push 0x9ba
00925721 call 0xa3c950
00925726 add esp, 0x10
00925729 jmp 0x925930
0092572E push 0xe
00925730 push 0
00925732 lea ecx, [ebp - 0x4c]
00925735 push ecx
00925736 call 0x666960
0092573B add esp, 0xc
0092573E mov edx, dword ptr [ebp - 0x10]
00925741 push edx
00925742 mov ecx, dword ptr [0x17c870c]
00925748 call 0x4e71b0
0092574D movzx ax, al
00925751 mov word ptr [ebp - 0x4c], ax
00925755 cmp dword ptr [ebp + 8], 0x309
0092575C jne 0x925767
0092575E mov byte ptr [ebp - 0x4a], 1
00925762 jmp 0x92590a
00925767 mov cl, byte ptr [ebp - 0x4c]
0092576A mov byte ptr [ebp - 0xcd], cl
00925770 mov dl, byte ptr [ebp - 0x4c]
00925773 mov byte ptr [ebp - 0xce], dl
00925779 lea eax, [ebp - 0xcd]
0092577F push eax
00925780 mov ecx, dword ptr [0x17c870c]
00925786 call 0x4e13a0
0092578B movzx esi, byte ptr [eax + 0x28]
0092578F lea ecx, [ebp - 0xce]
00925795 push ecx
00925796 mov ecx, dword ptr [0x17c870c]
0092579C call 0x4e13a0
009257A1 movzx edx, byte ptr [eax + 0x27]
009257A5 cmp esi, edx
009257A7 jl 0x92590a
009257AD mov al, byte ptr [ebp - 0x4c]
009257B0 mov byte ptr [ebp - 0xcf], al
009257B6 lea ecx, [ebp - 0xcf]
009257BC push ecx
009257BD mov ecx, dword ptr [0x17c870c]
009257C3 call 0x4e13a0
009257C8 movzx edx, byte ptr [eax + 0x22]
009257CC test edx, edx
009257CE je 0x925812
009257D0 mov al, byte ptr [ebp - 0x4c]
009257D3 mov byte ptr [ebp - 0xd0], al
009257D9 mov cl, byte ptr [ebp - 0x4c]
009257DC mov byte ptr [ebp - 0xd1], cl
009257E2 lea edx, [ebp - 0xd0]
009257E8 push edx
009257E9 mov ecx, dword ptr [0x17c870c]
009257EF call 0x4e13a0
009257F4 movzx esi, word ptr [eax + 0x25]
009257F8 lea eax, [ebp - 0xd1]
009257FE push eax
009257FF mov ecx, dword ptr [0x17c870c]
00925805 call 0x4e13a0
0092580A movzx ecx, word ptr [eax + 0x23]
0092580E cmp esi, ecx
00925810 jl 0x925868
00925812 push 0xbb05ec
00925817 lea ecx, [ebp - 0xf0]
0092581D call 0x405650
00925822 mov byte ptr [ebp - 4], 6
00925826 call 0x403820
0092582B mov dword ptr [ebp - 0x130], eax
00925831 push 0
00925833 push 0
00925835 push 0
00925837 lea edx, [ebp - 0xf0]
0092583D push edx
0092583E mov eax, dword ptr [ebp - 0x130]
00925844 mov edx, dword ptr [eax]
00925846 mov ecx, dword ptr [ebp - 0x130]
0092584C mov eax, dword ptr [edx + 0x1c0]
00925852 call eax
00925854 mov byte ptr [ebp - 4], 2
00925858 lea ecx, [ebp - 0xf0]
0092585E call 0x4056d0
00925863 jmp 0x9258f9
00925868 mov byte ptr [ebp - 0x4a], 1
0092586C push 0xe
0092586E call 0x667fbb
00925873 add esp, 4
00925876 mov dword ptr [ebp - 0xf4], eax
0092587C mov ecx, dword ptr [ebp - 0xf4]
00925882 mov dword ptr [ebp - 0x50], ecx
00925885 mov edx, dword ptr [ebp - 0x50]
00925888 mov eax, dword ptr [ebp - 0x4c]
0092588B mov dword ptr [edx], eax
0092588D mov ecx, dword ptr [ebp - 0x48]
00925890 mov dword ptr [edx + 4], ecx
00925893 mov eax, dword ptr [ebp - 0x44]
00925896 mov dword ptr [edx + 8], eax
00925899 mov cx, word ptr [ebp - 0x40]
0092589D mov word ptr [edx + 0xc], cx
009258A1 push 0xbb0608
009258A6 lea ecx, [ebp - 0x110]
009258AC call 0x405650
009258B1 mov byte ptr [ebp - 4], 7
009258B5 call 0x403820
009258BA mov dword ptr [ebp - 0x134], eax
009258C0 mov edx, dword ptr [ebp - 0x50]
009258C3 push edx
009258C4 push 0
009258C6 push 0x824b80
009258CB push 1
009258CD lea eax, [ebp - 0x110]
009258D3 push eax
009258D4 mov ecx, dword ptr [ebp - 0x134]
009258DA mov edx, dword ptr [ecx]
009258DC mov ecx, dword ptr [ebp - 0x134]
009258E2 mov eax, dword ptr [edx + 0x1bc]
009258E8 call eax
009258EA mov byte ptr [ebp - 4], 2
009258EE lea ecx, [ebp - 0x110]
009258F4 call 0x4056d0
009258F9 mov dword ptr [ebp - 4], 0xffffffff
00925900 lea ecx, [ebp - 0x30]
00925903 call 0x4056d0
00925908 jmp 0x925944
0092590A push 0xe
0092590C lea ecx, [ebp - 0x4c]
0092590F push ecx
00925910 push 0
00925912 push 0xbfe
00925917 call 0xa3c950
0092591C add esp, 0x10
0092591F mov dword ptr [ebp - 4], 0xffffffff
00925926 lea ecx, [ebp - 0x30]
00925929 call 0x4056d0
0092592E jmp 0x925944
00925930 mov dword ptr [ebp - 4], 0xffffffff
00925937 lea ecx, [ebp - 0x30]
0092593A call 0x4056d0

; Block 0x825250
00825250 push ebp
00825251 mov ebp, esp
00825253 push -1
00825255 push 0xac62e6
0082525A mov eax, dword ptr fs:[0]
00825260 push eax
00825261 sub esp, 0x2c
00825264 mov eax, dword ptr [0xc7b480]
00825269 xor eax, ebp
0082526B push eax
0082526C lea eax, [ebp - 0xc]
0082526F mov dword ptr fs:[0], eax
00825275 mov dword ptr [ebp - 0x30], ecx
00825278 cmp dword ptr [ebp + 8], 0
0082527C je 0x825287
0082527E cmp dword ptr [ebp + 0xc], 0x103
00825285 je 0x82528c
00825287 jmp 0x82530d
0082528C mov eax, dword ptr [ebp + 8]
0082528F mov dword ptr [ebp - 0x10], eax
00825292 mov ecx, dword ptr [ebp - 0x10]
00825295 movzx edx, byte ptr [ecx + 4]
00825299 cmp edx, 1
0082529C jne 0x8252c8
0082529E mov eax, dword ptr [ebp - 0x10]
008252A1 push eax
008252A2 call 0x4e77f0
008252A7 mov ecx, eax
008252A9 call 0x5494d0
008252AE call 0x4e77f0
008252B3 mov dword ptr [ebp - 0x34], eax
008252B6 mov ecx, dword ptr [ebp - 0x34]
008252B9 mov edx, dword ptr [ecx]
008252BB mov ecx, dword ptr [ebp - 0x34]
008252BE mov eax, dword ptr [edx + 0x108]
008252C4 call eax
008252C6 jmp 0x82530d
008252C8 push 0xbcb0c4
008252CD lea ecx, [ebp - 0x2c]
008252D0 call 0x405650
008252D5 mov dword ptr [ebp - 4], 0
008252DC call 0x403820
008252E1 mov dword ptr [ebp - 0x38], eax
008252E4 push 0
008252E6 push 0
008252E8 push 0
008252EA lea ecx, [ebp - 0x2c]
008252ED push ecx
008252EE mov edx, dword ptr [ebp - 0x38]
008252F1 mov eax, dword ptr [edx]
008252F3 mov ecx, dword ptr [ebp - 0x38]
008252F6 mov edx, dword ptr [eax + 0x1c0]
008252FC call edx
008252FE mov dword ptr [ebp - 4], 0xffffffff
00825305 lea ecx, [ebp - 0x2c]
00825308 call 0x4056d0
0082530D mov ecx, dword ptr [ebp - 0xc]
00825310 mov dword ptr fs:[0], ecx
00825317 pop ecx
00825318 mov esp, ebp
0082531A pop ebp

; Block 0x5494d0
005494D0 push ebp
005494D1 mov ebp, esp
005494D3 push ecx
005494D4 mov dword ptr [ebp - 4], ecx
005494D7 mov eax, dword ptr [ebp - 4]
005494DA mov ecx, dword ptr [ebp + 8]
005494DD mov dl, byte ptr [ecx]
005494DF mov byte ptr [eax + 0x578], dl
005494E5 mov esp, ebp
005494E7 pop ebp

; Block 0x4e71b0
004E71B0 push ebp
004E71B1 mov ebp, esp
004E71B3 push ecx
004E71B4 mov dword ptr [ebp - 4], ecx
004E71B7 mov eax, dword ptr [ebp - 4]
004E71BA add eax, dword ptr [ebp + 8]
004E71BD mov al, byte ptr [eax + 0x85]
004E71C3 mov esp, ebp
004E71C5 pop ebp

; Block 0x926490
00926490 push ebp
00926491 mov ebp, esp
00926493 push -1
00926495 push 0xabb6e8
0092649A mov eax, dword ptr fs:[0]
009264A0 push eax
009264A1 sub esp, 0x3c
009264A4 mov eax, dword ptr [0xc7b480]
009264A9 xor eax, ebp
009264AB push eax
009264AC lea eax, [ebp - 0xc]
009264AF mov dword ptr fs:[0], eax
009264B5 mov dword ptr [ebp - 0x48], ecx
009264B8 mov eax, dword ptr [0xb99f58]
009264BD push eax
009264BE lea ecx, [ebp - 0x28]
009264C1 call 0x405650
009264C6 mov dword ptr [ebp - 4], 0
009264CD mov ecx, dword ptr [0xb99f64]
009264D3 push ecx
009264D4 lea ecx, [ebp - 0x44]
009264D7 call 0x405650
009264DC mov byte ptr [ebp - 4], 1
009264E0 push 0
009264E2 lea edx, [ebp - 0x28]
009264E5 push edx
009264E6 lea eax, [ebp - 0x44]
009264E9 push eax
009264EA mov ecx, dword ptr [ebp - 0x48]
009264ED call 0x7da5f0
009264F2 mov byte ptr [ebp - 4], 3
009264F6 lea ecx, [ebp - 0x44]
009264F9 call 0x4056d0
009264FE mov byte ptr [ebp - 4], 4
00926502 lea ecx, [ebp - 0x28]
00926505 call 0x4056d0
0092650A mov ecx, dword ptr [ebp - 0x48]
0092650D mov dword ptr [ecx], 0xbaf75c

; Block 0x9265e0
009265E0 push ebp
009265E1 mov ebp, esp
009265E3 push -1
009265E5 push 0xac292f
009265EA mov eax, dword ptr fs:[0]
009265F0 push eax
009265F1 sub esp, 0x100
009265F7 mov eax, dword ptr [0xc7b480]
009265FC xor eax, ebp
009265FE mov dword ptr [ebp - 0x10], eax
00926601 push eax
00926602 lea eax, [ebp - 0xc]
00926605 mov dword ptr fs:[0], eax
0092660B mov dword ptr [ebp - 0xf0], ecx
00926611 mov eax, dword ptr [0xb99f68]
00926616 push eax
00926617 lea ecx, [ebp - 0x40]
0092661A call 0x405650
0092661F mov dword ptr [ebp - 4], 0
00926626 lea ecx, [ebp - 0x40]
00926629 push ecx
0092662A mov ecx, dword ptr [ebp - 0xf0]
00926630 call 0x75fbf0
00926635 mov dword ptr [ebp - 0x24], eax
00926638 mov dword ptr [ebp - 4], 0xffffffff
0092663F lea ecx, [ebp - 0x40]
00926642 call 0x4056d0
00926647 push 0xe
00926649 push 0
0092664B lea edx, [ebp - 0x20]
0092664E push edx
0092664F call 0x666960
00926654 add esp, 0xc
00926657 mov eax, dword ptr [ebp - 0xf0]
0092665D movzx cx, byte ptr [eax + 0x578]
00926665 mov word ptr [ebp - 0x20], cx
00926669 lea edx, [ebp - 0x5c]
0092666C push edx
0092666D mov ecx, dword ptr [ebp - 0x24]
00926670 call 0x4c1310
00926675 mov dword ptr [ebp - 0xf4], eax
0092667B mov eax, dword ptr [ebp - 0xf4]
00926681 mov dword ptr [ebp - 0xf8], eax
00926687 mov dword ptr [ebp - 4], 1
0092668E lea ecx, [ebp - 0x78]
00926691 push ecx
00926692 mov ecx, dword ptr [ebp - 0x24]
00926695 call 0x4c1310
0092669A mov dword ptr [ebp - 0xfc], eax
009266A0 mov ecx, dword ptr [ebp - 0xf8]
009266A6 call 0x548980
009266AB push eax
009266AC mov ecx, dword ptr [ebp - 0xfc]
009266B2 call 0x405750
009266B7 push eax
009266B8 lea edx, [ebp - 0x1d]
009266BB push edx
009266BC call 0x6636a0
009266C1 add esp, 0xc
009266C4 lea ecx, [ebp - 0x78]
009266C7 call 0x4056d0
009266CC mov dword ptr [ebp - 4], 0xffffffff
009266D3 lea ecx, [ebp - 0x5c]
009266D6 call 0x4056d0
009266DB lea eax, [ebp - 0x94]
009266E1 push eax
009266E2 mov ecx, dword ptr [ebp - 0x24]
009266E5 call 0x4c1310
009266EA mov dword ptr [ebp - 0x100], eax
009266F0 mov ecx, dword ptr [ebp - 0x100]
009266F6 mov dword ptr [ebp - 0x104], ecx
009266FC mov dword ptr [ebp - 4], 2
00926703 mov edx, dword ptr [ebp - 0x104]
00926709 push edx
0092670A mov ecx, dword ptr [ebp - 0xf0]
00926710 add ecx, 0x5c0
00926716 call 0x4056f0
0092671B mov dword ptr [ebp - 4], 0xffffffff
00926722 lea ecx, [ebp - 0x94]
00926728 call 0x4056d0
0092672D mov eax, dword ptr [ebp - 0xf0]
00926733 mov cl, byte ptr [eax + 0x5dc]
00926739 mov byte ptr [ebp - 0x1e], cl
0092673C mov ecx, dword ptr [ebp - 0xf0]
00926742 add ecx, 0x5c0
00926748 call 0x41afb0
0092674D movzx edx, al
00926750 test edx, edx
00926752 je 0x926859
00926758 mov dword ptr [ebp - 0xa4], 0
00926762 mov dword ptr [ebp - 0xa0], 0
0092676C mov dword ptr [ebp - 0x9c], 0
00926776 mov dword ptr [ebp - 0x98], 0xffffffff
00926780 mov dword ptr [ebp - 0xb4], 0x926420
0092678A mov dword ptr [ebp - 0xb0], 0
00926794 mov dword ptr [ebp - 0xac], 0
0092679E mov dword ptr [ebp - 0xa8], 0
009267A8 push 0xbaf720
009267AD lea ecx, [ebp - 0xd0]
009267B3 call 0x405650
009267B8 mov dword ptr [ebp - 4], 3
009267BF call 0x403820
009267C4 mov dword ptr [ebp - 0x108], eax
009267CA push 0
009267CC sub esp, 0x10
009267CF mov eax, esp
009267D1 mov ecx, dword ptr [ebp - 0xa4]
009267D7 mov dword ptr [eax], ecx
009267D9 mov edx, dword ptr [ebp - 0xa0]
009267DF mov dword ptr [eax + 4], edx
009267E2 mov ecx, dword ptr [ebp - 0x9c]
009267E8 mov dword ptr [eax + 8], ecx
009267EB mov edx, dword ptr [ebp - 0x98]
009267F1 mov dword ptr [eax + 0xc], edx
009267F4 sub esp, 0x10
009267F7 mov eax, esp
009267F9 mov ecx, dword ptr [ebp - 0xb4]
009267FF mov dword ptr [eax], ecx
00926801 mov edx, dword ptr [ebp - 0xb0]
00926807 mov dword ptr [eax + 4], edx
0092680A mov ecx, dword ptr [ebp - 0xac]
00926810 mov dword ptr [eax + 8], ecx
00926813 mov edx, dword ptr [ebp - 0xa8]
00926819 mov dword ptr [eax + 0xc], edx
0092681C mov eax, dword ptr [ebp - 0xf0]
00926822 push eax
00926823 push 0
00926825 lea ecx, [ebp - 0xd0]
0092682B push ecx
0092682C mov edx, dword ptr [ebp - 0x108]
00926832 mov eax, dword ptr [edx]
00926834 mov ecx, dword ptr [ebp - 0x108]
0092683A mov edx, dword ptr [eax + 0x1b8]
00926840 call edx
00926842 mov dword ptr [ebp - 4], 0xffffffff
00926849 lea ecx, [ebp - 0xd0]
0092684F call 0x4056d0
00926854 jmp 0x9268ed
00926859 mov ecx, dword ptr [0x17c86fc]
0092685F call 0x462480
00926864 cmp eax, -1
00926867 jne 0x9268c2
00926869 push 0xbaf730
0092686E lea ecx, [ebp - 0xec]
00926874 call 0x405650
00926879 mov dword ptr [ebp - 4], 4
00926880 call 0x403820
00926885 mov dword ptr [ebp - 0x10c], eax
0092688B push 0
0092688D push 0
0092688F push 0
00926891 lea eax, [ebp - 0xec]
00926897 push eax
00926898 mov ecx, dword ptr [ebp - 0x10c]
0092689E mov edx, dword ptr [ecx]
009268A0 mov ecx, dword ptr [ebp - 0x10c]
009268A6 mov eax, dword ptr [edx + 0x1c0]
009268AC call eax
009268AE mov dword ptr [ebp - 4], 0xffffffff
009268B5 lea ecx, [ebp - 0xec]
009268BB call 0x4056d0
009268C0 jmp 0x9268ed
009268C2 push 0xe
009268C4 lea ecx, [ebp - 0x20]
009268C7 push ecx
009268C8 push 0
009268CA push 0xbfe
009268CF call 0xa3c950
009268D4 add esp, 0x10
009268D7 mov edx, dword ptr [ebp - 0xf0]
009268DD mov eax, dword ptr [edx]
009268DF mov ecx, dword ptr [ebp - 0xf0]
009268E5 mov edx, dword ptr [eax + 0x11c]
009268EB call edx
009268ED mov ecx, dword ptr [ebp - 0xc]
009268F0 mov dword ptr fs:[0], ecx
009268F7 pop ecx
009268F8 mov ecx, dword ptr [ebp - 0x10]
009268FB xor ecx, ebp
009268FD call 0x6634fb
00926902 mov esp, ebp
00926904 pop ebp
00926905 ret

; Block 0x926960
00926960 push ebp
00926961 mov ebp, esp
00926963 push -1
00926965 push 0xad5e91
0092696A mov eax, dword ptr fs:[0]
00926970 push eax
00926971 sub esp, 0x78
00926974 mov eax, dword ptr [0xc7b480]
00926979 xor eax, ebp
0092697B push eax
0092697C lea eax, [ebp - 0xc]
0092697F mov dword ptr fs:[0], eax
00926985 mov dword ptr [ebp - 0x84], ecx
0092698B mov ecx, dword ptr [ebp - 0x84]
00926991 call 0x7e1730
00926996 mov eax, dword ptr [0xb99f68]
0092699B push eax
0092699C lea ecx, [ebp - 0x2c]
0092699F call 0x405650
009269A4 mov dword ptr [ebp - 4], 0
009269AB lea ecx, [ebp - 0x2c]
009269AE push ecx
009269AF mov ecx, dword ptr [ebp - 0x84]
009269B5 call 0x75fbf0
009269BA mov dword ptr [ebp - 0x10], eax
009269BD mov dword ptr [ebp - 4], 0xffffffff
009269C4 lea ecx, [ebp - 0x2c]
009269C7 call 0x4056d0
009269CC mov edx, dword ptr [0xb99f68]
009269D2 push edx
009269D3 lea ecx, [ebp - 0x48]
009269D6 call 0x405650
009269DB mov dword ptr [ebp - 4], 1
009269E2 mov eax, dword ptr [0xb99f64]
009269E7 push eax
009269E8 lea ecx, [ebp - 0x64]
009269EB call 0x405650
009269F0 mov byte ptr [ebp - 4], 2
009269F4 lea ecx, [ebp - 0x48]
009269F7 push ecx
009269F8 lea edx, [ebp - 0x64]
009269FB push edx
009269FC call 0x766690
00926A01 mov ecx, eax
00926A03 call 0x765c50
00926A08 mov byte ptr [ebp - 4], 1
00926A0C lea ecx, [ebp - 0x64]
00926A0F call 0x4056d0
00926A14 mov dword ptr [ebp - 4], 0xffffffff
00926A1B lea ecx, [ebp - 0x48]
00926A1E call 0x4056d0
00926A23 cmp dword ptr [ebp - 0x10], 0
00926A27 je 0x926a62
00926A29 push 0xb96699
00926A2E lea ecx, [ebp - 0x80]
00926A31 call 0x405650
00926A36 mov dword ptr [ebp - 4], 3
00926A3D push 1
00926A3F lea eax, [ebp - 0x80]
00926A42 push eax
00926A43 mov ecx, dword ptr [ebp - 0x10]
00926A46 mov edx, dword ptr [ecx]
00926A48 mov ecx, dword ptr [ebp - 0x10]
00926A4B mov eax, dword ptr [edx + 0xd4]
00926A51 call eax
00926A53 mov dword ptr [ebp - 4], 0xffffffff
00926A5A lea ecx, [ebp - 0x80]
00926A5D call 0x4056d0
00926A62 mov eax, 1
00926A67 mov ecx, dword ptr [ebp - 0xc]
00926A6A mov dword ptr fs:[0], ecx
00926A71 pop ecx
00926A72 mov esp, ebp
00926A74 pop ebp
00926A75 ret

; Lua double opcode values: BE97A8=2490, BE97A0=2500, BE9798=2510.
; Vtable BAF75C+108=926960; 2500 copies only payload BYTE +0 via 5494D0, then opens this dialog.
; 92665D zero-extends dialog BYTE +578 to 3070 WORD +0; +2 comes from dialog mode +5DC.
