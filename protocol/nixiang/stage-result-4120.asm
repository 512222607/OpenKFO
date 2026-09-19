; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Mode21 4120 selects result21.sui / frmResult21 (B9A2BC/B9A2B8).
; BAE2A4+108 -> 9382A0 -> 937310. 935F30 stores result header pointers.
; range 0x82ca62
0082CA62 mov ecx, dword ptr [0x17c8708]
0082CA68 call 0x4535c0
0082CA6D mov dword ptr [ebp - 0x30], eax
0082CA70 cmp dword ptr [ebp - 0x30], 0xf
0082CA74 je 0x82ca84
0082CA76 cmp dword ptr [ebp - 0x30], 0x10
0082CA7A je 0x82ca96
0082CA7C cmp dword ptr [ebp - 0x30], 0x15
0082CA80 je 0x82caa8
0082CA82 jmp 0x82caba
0082CA84 mov ecx, dword ptr [ebp - 4]
0082CA87 push ecx
0082CA88 call 0x548a20
0082CA8D mov ecx, eax
0082CA8F call 0x80d730
0082CA94 jmp 0x82caca
0082CA96 mov edx, dword ptr [ebp - 4]
0082CA99 push edx
0082CA9A call 0x548c80
0082CA9F mov ecx, eax
0082CAA1 call 0x814860
0082CAA6 jmp 0x82caca
0082CAA8 mov eax, dword ptr [ebp - 4]
0082CAAB push eax
0082CAAC call 0x548d10
0082CAB1 mov ecx, eax
0082CAB3 call 0x935f30
0082CAB8 jmp 0x82caca
0082CABA mov ecx, dword ptr [ebp - 4]
0082CABD push ecx
0082CABE call 0x811460
0082CAC3 mov ecx, eax
; range 0x82cbe1
0082CBE1 mov ecx, dword ptr [ebp - 4]
0082CBE4 add ecx, 0x8c
0082CBEA mov dword ptr [ebp - 4], ecx
0082CBED mov edx, dword ptr [ebp - 4]
0082CBF0 mov dword ptr [ebp - 0x28], edx
0082CBF3 mov eax, dword ptr [ebp - 0x28]
0082CBF6 push eax
0082CBF7 mov ecx, dword ptr [0x17c86fc]
0082CBFD call 0x9cd2f0
0082CC02 mov ecx, dword ptr [ebp - 0x28]
0082CC05 movzx edx, byte ptr [ecx + 0x7b]
0082CC09 push edx
0082CC0A mov ecx, dword ptr [ebp - 0x18]
0082CC0D call 0x511900
0082CC12 call 0x4030c0
0082CC17 mov ecx, eax
0082CC19 call 0x4031a0
; range 0x82cd23
0082CD23 push 1
0082CD25 call 0x548d10
0082CD2A mov ecx, eax
0082CD2C call 0x935ef0
0082CD31 call 0x548d10
0082CD36 mov dword ptr [ebp - 0x40], eax
0082CD39 mov ecx, dword ptr [ebp - 0x40]
0082CD3C mov edx, dword ptr [ecx]
0082CD3E mov ecx, dword ptr [ebp - 0x40]
0082CD41 mov eax, dword ptr [edx + 0x108]
0082CD47 call eax
0082CD49 jmp 0x82cda5
; range 0x935f30
00935F30 push ebp
00935F31 mov ebp, esp
00935F33 sub esp, 0x1c
00935F36 mov dword ptr [ebp - 0x1c], ecx
00935F39 cmp dword ptr [ebp + 8], 0
00935F3D je 0x935f7d
00935F3F mov eax, dword ptr [ebp + 8]
00935F42 push eax
00935F43 mov ecx, dword ptr [ebp - 0x1c]
00935F46 add ecx, 0x578
00935F4C call 0x4c4cb0
00935F51 push eax
00935F52 lea ecx, [ebp - 0x10]
00935F55 push ecx
00935F56 call 0x51db70
00935F5B add esp, 0xc
00935F5E push eax
00935F5F lea ecx, [ebp - 8]
00935F62 call 0x4c06e0
00935F67 lea edx, [ebp - 8]
00935F6A push edx
00935F6B lea eax, [ebp - 0x18]
00935F6E push eax
00935F6F mov ecx, dword ptr [ebp - 0x1c]
00935F72 add ecx, 0x578
00935F78 call 0x4bfeb0
00935F7D mov esp, ebp
00935F7F pop ebp
00935F80 ret 4
; range 0x936cbb
00936CBB mov ecx, dword ptr [ebp + 0x10]
00936CBE add ecx, 0x22
00936CC1 push ecx
00936CC2 lea edx, [ebp - 0x254]
00936CC8 push edx
00936CC9 call 0xa44160
00936CCE add esp, 8
; range 0x936db6
00936DB6 mov eax, dword ptr [ebp + 0x10]
00936DB9 add eax, 0x3f
00936DBC push eax
00936DBD lea ecx, [ebp - 0x2a8]
00936DC3 push ecx
00936DC4 call 0xa44160
00936DC9 add esp, 8
; range 0x936e0a
00936E0A mov ecx, dword ptr [ebp + 0x10]
00936E0D mov edx, dword ptr [ecx + 0x36]
00936E10 push edx
00936E11 call 0xa21b30
00936E16 mov ecx, eax
00936E18 call 0xa1e560
00936E1D mov dword ptr [ebp - 0x30], eax
00936E20 cmp dword ptr [ebp - 0x30], 0
; range 0x937310
00937310 push ebp
00937311 mov ebp, esp
00937313 push -1
00937315 push 0xad63b6
0093731A mov eax, dword ptr fs:[0]
00937320 push eax
00937321 sub esp, 0x254
00937327 mov eax, dword ptr [0xc7b480]
0093732C xor eax, ebp
0093732E mov dword ptr [ebp - 0x44], eax
00937331 push eax
00937332 lea eax, [ebp - 0xc]
00937335 mov dword ptr fs:[0], eax
0093733B mov dword ptr [ebp - 0x248], ecx
00937341 mov dword ptr [ebp - 0x38], 0
00937348 mov byte ptr [ebp - 0x19], 0
0093734C mov dword ptr [ebp - 0x24], 0
00937353 mov dword ptr [ebp - 0x20], 0
0093735A mov dword ptr [ebp - 0x18], 0
00937361 lea ecx, [ebp - 0x14]
00937364 call 0x471ae0
00937369 lea eax, [ebp - 0x168]
0093736F push eax
00937370 mov ecx, dword ptr [ebp - 0x248]
00937376 add ecx, 0x578
0093737C call 0x5504a0
00937381 mov ecx, dword ptr [eax]
00937383 mov edx, dword ptr [eax + 4]
00937386 mov dword ptr [ebp - 0x14], ecx
00937389 mov dword ptr [ebp - 0x10], edx
0093738C jmp 0x937396
0093738E lea ecx, [ebp - 0x14]
00937391 call 0x4668e0
00937396 lea eax, [ebp - 0x170]
0093739C push eax
0093739D mov ecx, dword ptr [ebp - 0x248]
009373A3 add ecx, 0x578
009373A9 call 0x45abb0
009373AE push eax
009373AF lea ecx, [ebp - 0x14]
009373B2 call 0x4ab8f0
009373B7 movzx ecx, al
009373BA test ecx, ecx
009373BC je 0x937461
009373C2 lea ecx, [ebp - 0x14]
009373C5 call 0x4305b0
009373CA mov edx, dword ptr [eax + 4]
009373CD mov eax, dword ptr [edx + 4]
009373D0 push eax
009373D1 mov ecx, dword ptr [edx]
009373D3 push ecx
009373D4 mov ecx, dword ptr [0x17c8708]
009373DA call 0x818c70
009373DF mov dword ptr [ebp - 0x3c], eax
009373E2 cmp dword ptr [ebp - 0x3c], 0
009373E6 je 0x93741b
009373E8 lea ecx, [ebp - 0x14]
009373EB call 0x4305b0
009373F0 mov edx, dword ptr [eax + 4]
009373F3 mov eax, dword ptr [edx + 0x5c]
009373F6 mov dword ptr [ebp - 0x24], eax
009373F9 lea ecx, [ebp - 0x14]
009373FC call 0x4305b0
00937401 mov ecx, dword ptr [eax + 4]
00937404 mov edx, dword ptr [ecx + 0x60]
00937407 mov dword ptr [ebp - 0x20], edx
0093740A lea ecx, [ebp - 0x14]
0093740D call 0x4305b0
00937412 mov eax, dword ptr [eax + 4]
00937415 mov ecx, dword ptr [eax + 0x64]
00937418 mov dword ptr [ebp - 0x18], ecx
0093741B cmp dword ptr [ebp - 0x3c], 0
0093741F je 0x93745c
00937421 mov ecx, dword ptr [ebp - 0x3c]
00937424 call 0x45c440
00937429 movzx edx, al
0093742C test edx, edx
0093742E je 0x93745c
00937430 lea ecx, [ebp - 0x14]
00937433 call 0x4305b0
00937438 mov eax, dword ptr [eax + 4]
0093743B movzx ecx, byte ptr [eax + 0xa]
0093743F cmp ecx, 2
00937442 je 0x937458
00937444 lea ecx, [ebp - 0x14]
00937447 call 0x4305b0
0093744C mov edx, dword ptr [eax + 4]
0093744F movzx eax, byte ptr [edx + 0xa]
00937453 cmp eax, 0xa
00937456 jne 0x93745c
00937458 mov byte ptr [ebp - 0x19], 1
0093745C jmp 0x93738e
00937461 lea ecx, [ebp - 0x178]
00937467 push ecx
00937468 mov ecx, dword ptr [ebp - 0x248]
0093746E add ecx, 0x578
00937474 call 0x5504a0
00937479 mov edx, dword ptr [eax]
0093747B mov eax, dword ptr [eax + 4]
0093747E mov dword ptr [ebp - 0x14], edx
00937481 mov dword ptr [ebp - 0x10], eax
00937484 jmp 0x93748e
00937486 lea ecx, [ebp - 0x14]
00937489 call 0x4668e0
0093748E lea ecx, [ebp - 0x180]
00937494 push ecx
00937495 mov ecx, dword ptr [ebp - 0x248]
0093749B add ecx, 0x578
009374A1 call 0x45abb0
009374A6 push eax
009374A7 lea ecx, [ebp - 0x14]
009374AA call 0x4ab8f0
009374AF movzx edx, al
009374B2 test edx, edx
009374B4 je 0x9375cd
009374BA lea ecx, [ebp - 0x14]
009374BD call 0x4305b0
009374C2 mov eax, dword ptr [eax + 4]
009374C5 mov ecx, dword ptr [eax + 4]
009374C8 push ecx
009374C9 mov edx, dword ptr [eax]
009374CB push edx
009374CC mov ecx, dword ptr [0x17c8708]
009374D2 call 0x818c70
009374D7 mov dword ptr [ebp - 0x40], eax
009374DA cmp dword ptr [ebp - 0x40], 0
009374DE je 0x9375c8
009374E4 mov ecx, dword ptr [ebp - 0x40]
009374E7 call 0x45c440
009374EC movzx eax, al
009374EF test eax, eax
009374F1 jne 0x937597
009374F7 movzx ecx, byte ptr [ebp - 0x19]
009374FB test ecx, ecx
009374FD je 0x937559
009374FF lea ecx, [ebp - 0x14]
00937502 call 0x4305b0
00937507 mov edx, dword ptr [eax + 4]
0093750A movzx eax, byte ptr [edx + 0xa]
0093750E cmp eax, 0xa
00937511 je 0x937536
00937513 push 1
00937515 lea ecx, [ebp - 0x14]
00937518 call 0x4305b0
0093751D mov ecx, dword ptr [eax + 4]
00937520 push ecx
00937521 mov edx, dword ptr [ebp - 0x38]
00937524 push edx
00937525 mov eax, dword ptr [ebp - 0x40]
00937528 push eax
00937529 mov ecx, dword ptr [ebp - 0x248]
0093752F call 0x936900
00937534 jmp 0x937557
00937536 push 0xa
00937538 lea ecx, [ebp - 0x14]
0093753B call 0x4305b0
00937540 mov ecx, dword ptr [eax + 4]
00937543 push ecx
00937544 mov edx, dword ptr [ebp - 0x38]
00937547 push edx
00937548 mov eax, dword ptr [ebp - 0x40]
0093754B push eax
0093754C mov ecx, dword ptr [ebp - 0x248]
00937552 call 0x936900
00937557 jmp 0x93758c
00937559 lea ecx, [ebp - 0x14]
0093755C call 0x4305b0
00937561 mov ecx, dword ptr [eax + 4]
00937564 movzx dx, byte ptr [ecx + 0xa]
00937569 movzx eax, dx
0093756C push eax
0093756D lea ecx, [ebp - 0x14]
00937570 call 0x4305b0
00937575 mov ecx, dword ptr [eax + 4]
00937578 push ecx
00937579 mov edx, dword ptr [ebp - 0x38]
0093757C push edx
0093757D mov eax, dword ptr [ebp - 0x40]
00937580 push eax
00937581 mov ecx, dword ptr [ebp - 0x248]
00937587 call 0x936900
0093758C mov ecx, dword ptr [ebp - 0x38]
0093758F add ecx, 1
00937592 mov dword ptr [ebp - 0x38], ecx
00937595 jmp 0x9375c8
00937597 lea ecx, [ebp - 0x14]
0093759A call 0x4305b0
0093759F mov edx, dword ptr [eax + 4]
009375A2 movzx ax, byte ptr [edx + 0xa]
009375A7 movzx ecx, ax
009375AA push ecx
009375AB lea ecx, [ebp - 0x14]
009375AE call 0x4305b0
009375B3 mov edx, dword ptr [eax + 4]
009375B6 push edx
009375B7 push 0
009375B9 mov eax, dword ptr [ebp - 0x40]
009375BC push eax
009375BD mov ecx, dword ptr [ebp - 0x248]
009375C3 call 0x936900
009375C8 jmp 0x937486
009375CD mov ecx, dword ptr [0xb9a2f0]
009375D3 push ecx
009375D4 lea ecx, [ebp - 0x19c]
009375DA call 0x405650
009375DF mov dword ptr [ebp - 4], 0
009375E6 push 0
009375E8 push 0x12f8a04
009375ED push 0x12f8898
009375F2 lea edx, [ebp - 0x19c]
009375F8 push edx
009375F9 mov ecx, dword ptr [ebp - 0x248]
009375FF call 0x75fbf0
00937604 push 0
00937606 push eax
00937607 call 0xa97b0e
0093760C add esp, 0x14
0093760F mov dword ptr [ebp - 0x2c], eax
00937612 mov dword ptr [ebp - 4], 0xffffffff
00937619 lea ecx, [ebp - 0x19c]
0093761F call 0x4056d0
00937624 mov eax, dword ptr [0xb9a2ec]
00937629 push eax
0093762A lea ecx, [ebp - 0x1b8]
00937630 call 0x405650
00937635 mov dword ptr [ebp - 4], 1
0093763C push 0
0093763E push 0x12f8a04
00937643 push 0x12f8898
00937648 lea ecx, [ebp - 0x1b8]
0093764E push ecx
0093764F mov ecx, dword ptr [ebp - 0x248]
00937655 call 0x75fbf0
0093765A push 0
0093765C push eax
0093765D call 0xa97b0e
00937662 add esp, 0x14
00937665 mov dword ptr [ebp - 0x30], eax
00937668 mov dword ptr [ebp - 4], 0xffffffff
0093766F lea ecx, [ebp - 0x1b8]
00937675 call 0x4056d0
0093767A cmp dword ptr [ebp - 0x30], 0
0093767E je 0x9376e4
00937680 cmp dword ptr [ebp - 0x2c], 0
00937684 je 0x9376e4
00937686 cmp dword ptr [ebp - 0x24], 0x63
0093768A jge 0x937697
0093768C mov edx, dword ptr [ebp - 0x24]
0093768F mov dword ptr [ebp - 0x24c], edx
00937695 jmp 0x9376a1
00937697 mov dword ptr [ebp - 0x24c], 0x63
009376A1 mov eax, dword ptr [ebp - 0x24c]
009376A7 mov dword ptr [ebp - 0x24], eax
009376AA xor ecx, ecx
009376AC cmp dword ptr [ebp - 0x24], 0
009376B0 setle cl
009376B3 sub ecx, 1
009376B6 and ecx, dword ptr [ebp - 0x24]
009376B9 mov dword ptr [ebp - 0x24], ecx
009376BC mov eax, dword ptr [ebp - 0x24]
009376BF cdq
009376C0 mov ecx, 0xa
009376C5 idiv ecx
009376C7 push eax
009376C8 mov ecx, dword ptr [ebp - 0x2c]
009376CB call 0xa5c570
009376D0 mov eax, dword ptr [ebp - 0x24]
009376D3 cdq
009376D4 mov ecx, 0xa
009376D9 idiv ecx
009376DB push edx
009376DC mov ecx, dword ptr [ebp - 0x30]
009376DF call 0xa5c570
009376E4 mov edx, dword ptr [0xb9a2e4]
009376EA push edx
009376EB lea ecx, [ebp - 0x1d4]
009376F1 call 0x405650
009376F6 mov dword ptr [ebp - 4], 2
009376FD push 0
009376FF push 0x12f8a44
00937704 push 0x12f8898
00937709 lea eax, [ebp - 0x1d4]
0093770F push eax
00937710 mov ecx, dword ptr [ebp - 0x248]
00937716 call 0x75fbf0
0093771B push 0
0093771D push eax
0093771E call 0xa97b0e
00937723 add esp, 0x14
00937726 mov dword ptr [ebp - 0x28], eax
00937729 mov dword ptr [ebp - 4], 0xffffffff
00937730 lea ecx, [ebp - 0x1d4]
00937736 call 0x4056d0
0093773B cmp dword ptr [ebp - 0x28], 0
0093773F je 0x9377b6
00937741 mov eax, dword ptr [ebp - 0x20]
00937744 cdq
00937745 mov ecx, 0x3c
0093774A idiv ecx
0093774C push edx
0093774D mov eax, dword ptr [ebp - 0x20]
00937750 cdq
00937751 mov ecx, 0x3c
00937756 idiv ecx
00937758 push eax
00937759 push 0xbae220
0093775E push 0x100
00937763 lea edx, [ebp - 0x144]
00937769 push edx
0093776A call 0x663beb
0093776F add esp, 0x14
00937772 lea eax, [ebp - 0x144]
00937778 push eax
00937779 lea ecx, [ebp - 0x1f0]
0093777F call 0x405650
00937784 mov dword ptr [ebp - 4], 3
0093778B push 1
0093778D lea ecx, [ebp - 0x1f0]
00937793 push ecx
00937794 mov edx, dword ptr [ebp - 0x28]
00937797 mov eax, dword ptr [edx]
00937799 mov ecx, dword ptr [ebp - 0x28]
0093779C mov edx, dword ptr [eax + 0xd4]
009377A2 call edx
009377A4 mov dword ptr [ebp - 4], 0xffffffff
009377AB lea ecx, [ebp - 0x1f0]
009377B1 call 0x4056d0
009377B6 mov eax, dword ptr [0xb9a2e8]
009377BB push eax
009377BC lea ecx, [ebp - 0x20c]
009377C2 call 0x405650
009377C7 mov dword ptr [ebp - 4], 4
009377CE push 0
009377D0 push 0x12f91e4
009377D5 push 0x12f8898
009377DA lea ecx, [ebp - 0x20c]
009377E0 push ecx
009377E1 mov ecx, dword ptr [ebp - 0x248]
009377E7 call 0x75fbf0
009377EC push 0
009377EE push eax
009377EF call 0xa97b0e
009377F4 add esp, 0x14
009377F7 mov dword ptr [ebp - 0x34], eax
009377FA mov dword ptr [ebp - 4], 0xffffffff
00937801 lea ecx, [ebp - 0x20c]
00937807 call 0x4056d0
0093780C cmp dword ptr [ebp - 0x34], 0
00937810 je 0x937964
00937816 push 0xbae22c
0093781B lea ecx, [ebp - 0x160]
00937821 call 0x405650
00937826 mov dword ptr [ebp - 4], 5
0093782D mov edx, dword ptr [ebp - 0x18]
00937830 mov dword ptr [ebp - 0x250], edx
00937836 mov eax, dword ptr [ebp - 0x250]
0093783C sub eax, 2
0093783F mov dword ptr [ebp - 0x250], eax
00937845 cmp dword ptr [ebp - 0x250], 5
0093784C ja 0x9378c5
0093784E mov ecx, dword ptr [ebp - 0x250]
00937854 jmp dword ptr [ecx*4 + 0x937980]
0093785B push 0xbae238
00937860 lea ecx, [ebp - 0x160]
00937866 call 0x405710
0093786B jmp 0x9378c5
0093786D push 0xbae244
00937872 lea ecx, [ebp - 0x160]
00937878 call 0x405710
0093787D jmp 0x9378c5
0093787F push 0xbae250
00937884 lea ecx, [ebp - 0x160]
0093788A call 0x405710
0093788F jmp 0x9378c5
00937891 push 0xbae25c
00937896 lea ecx, [ebp - 0x160]
0093789C call 0x405710
009378A1 jmp 0x9378c5
009378A3 push 0xbae268
009378A8 lea ecx, [ebp - 0x160]
009378AE call 0x405710
009378B3 jmp 0x9378c5
009378B5 push 0xbae274
009378BA lea ecx, [ebp - 0x160]
009378C0 call 0x405710
009378C5 mov edx, dword ptr [0xb9a300]
009378CB push edx
009378CC lea ecx, [ebp - 0x228]
009378D2 call 0x405650
009378D7 mov dword ptr [ebp - 0x254], eax
009378DD mov eax, dword ptr [ebp - 0x254]
009378E3 mov dword ptr [ebp - 0x258], eax
009378E9 mov byte ptr [ebp - 4], 6
009378ED lea ecx, [ebp - 0x160]
009378F3 push ecx
009378F4 mov edx, dword ptr [ebp - 0x258]
009378FA push edx
009378FB lea eax, [ebp - 0x244]
00937901 push eax
00937902 call 0x41b400
00937907 add esp, 0xc
0093790A mov dword ptr [ebp - 0x25c], eax
00937910 mov ecx, dword ptr [ebp - 0x25c]
00937916 mov dword ptr [ebp - 0x260], ecx
0093791C mov byte ptr [ebp - 4], 7
00937920 mov edx, dword ptr [ebp - 0x260]
00937926 push edx
00937927 mov eax, dword ptr [ebp - 0x34]
0093792A mov edx, dword ptr [eax]
0093792C mov ecx, dword ptr [ebp - 0x34]
0093792F mov eax, dword ptr [edx + 0x28]
00937932 call eax
00937934 mov byte ptr [ebp - 4], 6
00937938 lea ecx, [ebp - 0x244]
0093793E call 0x4056d0
00937943 mov byte ptr [ebp - 4], 5
00937947 lea ecx, [ebp - 0x228]
0093794D call 0x4056d0
00937952 mov dword ptr [ebp - 4], 0xffffffff
00937959 lea ecx, [ebp - 0x160]
0093795F call 0x4056d0
00937964 mov ecx, dword ptr [ebp - 0xc]
00937967 mov dword ptr fs:[0], ecx
0093796E pop ecx
0093796F mov ecx, dword ptr [ebp - 0x44]
00937972 xor ecx, ebp
00937974 call 0x6634fb
00937979 mov esp, ebp
0093797B pop ebp
0093797C ret
; range 0x9382a0
009382A0 push ebp
009382A1 mov ebp, esp
009382A3 push -1
009382A5 push 0xaddd9c
009382AA mov eax, dword ptr fs:[0]
009382B0 push eax
009382B1 sub esp, 0x24
009382B4 mov eax, dword ptr [0xc7b480]
009382B9 xor eax, ebp
009382BB push eax
009382BC lea eax, [ebp - 0xc]
009382BF mov dword ptr fs:[0], eax
009382C5 mov dword ptr [ebp - 0x30], ecx
009382C8 mov ecx, dword ptr [ebp - 0x30]
009382CB call 0x7e1730
009382D0 push 0x7e2900
009382D5 mov eax, dword ptr [ebp - 0x30]
009382D8 add eax, 0x210
009382DD push eax
009382DE call 0x7e7910
009382E3 mov ecx, eax
009382E5 call 0x7e70c0
009382EA mov ecx, dword ptr [0xb9a2c0]
009382F0 push ecx
009382F1 lea ecx, [ebp - 0x2c]
009382F4 call 0x405650
009382F9 mov dword ptr [ebp - 4], 0
00938300 lea edx, [ebp - 0x2c]
00938303 push edx
00938304 mov ecx, dword ptr [ebp - 0x30]
00938307 call 0x75fbf0
0093830C mov dword ptr [ebp - 0x10], eax
0093830F mov dword ptr [ebp - 4], 0xffffffff
00938316 lea ecx, [ebp - 0x2c]
00938319 call 0x4056d0
0093831E cmp dword ptr [ebp - 0x10], 0
00938322 je 0x93836b
00938324 call 0x4030c0
00938329 mov ecx, eax
0093832B call 0x4031a0
00938330 cmp eax, 2
00938333 jne 0x938351
00938335 mov eax, dword ptr [ebp - 0x10]
00938338 mov edx, dword ptr [eax]
0093833A mov ecx, dword ptr [ebp - 0x10]
0093833D mov eax, dword ptr [edx + 0xc4]
00938343 call eax
00938345 push 0
00938347 mov ecx, dword ptr [ebp - 0x10]
0093834A call 0x75a960
0093834F jmp 0x93836b
00938351 mov ecx, dword ptr [ebp - 0x10]
00938354 mov edx, dword ptr [ecx]
00938356 mov ecx, dword ptr [ebp - 0x10]
00938359 mov eax, dword ptr [edx + 0xc0]
0093835F call eax
00938361 push 1
00938363 mov ecx, dword ptr [ebp - 0x10]
00938366 call 0x75a960
0093836B push 1
0093836D call 0x4043a0
00938372 mov ecx, eax
00938374 call 0xa22540
00938379 push 7
0093837B call 0x990070
00938380 mov ecx, eax
00938382 call 0x98fde0
00938387 mov ecx, dword ptr [ebp - 0x30]
0093838A call 0x9363d0
0093838F mov ecx, dword ptr [ebp - 0x30]
00938392 call 0x936080
00938397 mov ecx, dword ptr [ebp - 0x30]
0093839A call 0x937310
0093839F mov ecx, dword ptr [ebp - 0x30]
009383A2 mov dword ptr [ecx + 0x5a4], 0
009383AC mov eax, 1
009383B1 mov ecx, dword ptr [ebp - 0xc]
009383B4 mov dword ptr fs:[0], ecx
009383BB pop ecx
009383BC mov esp, ebp
009383BE pop ebp
009383BF ret
