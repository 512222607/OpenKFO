; current gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0xa2c240..0xa2c2bd
00A2C240 push ebp
00A2C241 mov ebp, esp
00A2C243 sub esp, 8
00A2C246 mov dword ptr [ebp - 8], ecx
00A2C249 cmp dword ptr [ebp + 8], 0
00A2C24D je 0xa2c2b7
00A2C24F cmp dword ptr [ebp + 0xc], 0x1c
00A2C253 jne 0xa2c2b7
00A2C255 mov eax, dword ptr [ebp + 8]
00A2C258 mov dword ptr [ebp - 4], eax
00A2C25B mov ecx, dword ptr [ebp - 4]
00A2C25E mov edx, dword ptr [ecx]
00A2C260 push edx
00A2C261 mov ecx, dword ptr [0x17c86fc]
00A2C267 call 0x9ccf50
00A2C26C mov eax, dword ptr [ebp - 4]
00A2C26F add eax, 4
00A2C272 push eax
00A2C273 mov ecx, dword ptr [0x17c86fc]
00A2C279 call 0x9ccfc0
00A2C27E call 0x41c230
00A2C283 mov ecx, eax
00A2C285 call 0x91c830
00A2C28A call 0x41c5d0
00A2C28F mov ecx, eax
00A2C291 call 0x41bb50
00A2C296 movzx ecx, al
00A2C299 test ecx, ecx
00A2C29B je 0xa2c2ab
00A2C29D call 0x41c5d0
00A2C2A2 mov ecx, eax
00A2C2A4 call 0x805c00
00A2C2A9 jmp 0xa2c2b7
00A2C2AB call 0x41bdf0
00A2C2B0 mov ecx, eax
00A2C2B2 call 0x805c00
00A2C2B7 mov esp, ebp
00A2C2B9 pop ebp
00A2C2BA ret 8

; range 0x9ccf50..0x9ccfff
009CCF50 push ebp
009CCF51 mov ebp, esp
009CCF53 push ecx
009CCF54 mov dword ptr [ebp - 4], ecx
009CCF57 mov eax, dword ptr [ebp - 4]
009CCF5A mov ecx, dword ptr [ebp + 8]
009CCF5D mov dword ptr [eax + 0x1063], ecx
009CCF63 mov edx, dword ptr [ebp - 4]
009CCF66 mov eax, dword ptr [ebp + 8]
009CCF69 mov dword ptr [edx + 0x4c], eax
009CCF6C mov esp, ebp
009CCF6E pop ebp
009CCF6F ret 4
009CCF72 int3
009CCF73 int3
009CCF74 int3
009CCF75 int3
009CCF76 int3
009CCF77 int3
009CCF78 int3
009CCF79 int3
009CCF7A int3
009CCF7B int3
009CCF7C int3
009CCF7D int3
009CCF7E int3
009CCF7F int3
009CCF80 push ebp
009CCF81 mov ebp, esp
009CCF83 push ecx
009CCF84 mov dword ptr [ebp - 4], ecx
009CCF87 mov eax, dword ptr [ebp - 4]
009CCF8A mov eax, dword ptr [eax + 0x4c]
009CCF8D mov esp, ebp
009CCF8F pop ebp
009CCF90 ret
009CCF91 int3
009CCF92 int3
009CCF93 int3
009CCF94 int3
009CCF95 int3
009CCF96 int3
009CCF97 int3
009CCF98 int3
009CCF99 int3
009CCF9A int3
009CCF9B int3
009CCF9C int3
009CCF9D int3
009CCF9E int3
009CCF9F int3
009CCFA0 push ebp
009CCFA1 mov ebp, esp
009CCFA3 push ecx
009CCFA4 mov dword ptr [ebp - 4], ecx
009CCFA7 mov eax, dword ptr [ebp - 4]
009CCFAA add eax, 0x1131
009CCFAF mov esp, ebp
009CCFB1 pop ebp
009CCFB2 ret
009CCFB3 int3
009CCFB4 int3
009CCFB5 int3
009CCFB6 int3
009CCFB7 int3
009CCFB8 int3
009CCFB9 int3
009CCFBA int3
009CCFBB int3
009CCFBC int3
009CCFBD int3
009CCFBE int3
009CCFBF int3
009CCFC0 push ebp
009CCFC1 mov ebp, esp
009CCFC3 push ecx
009CCFC4 mov dword ptr [ebp - 4], ecx
009CCFC7 mov eax, dword ptr [ebp + 8]
009CCFCA mov ecx, dword ptr [ebp - 4]
009CCFCD add ecx, 0x1131
009CCFD3 mov edx, dword ptr [eax]
009CCFD5 mov dword ptr [ecx], edx
009CCFD7 mov edx, dword ptr [eax + 4]
009CCFDA mov dword ptr [ecx + 4], edx
009CCFDD mov edx, dword ptr [eax + 8]
009CCFE0 mov dword ptr [ecx + 8], edx
009CCFE3 mov edx, dword ptr [eax + 0xc]
009CCFE6 mov dword ptr [ecx + 0xc], edx
009CCFE9 mov edx, dword ptr [eax + 0x10]
009CCFEC mov dword ptr [ecx + 0x10], edx
009CCFEF mov eax, dword ptr [eax + 0x14]
009CCFF2 mov dword ptr [ecx + 0x14], eax
009CCFF5 mov esp, ebp
009CCFF7 pop ebp
009CCFF8 ret 4
009CCFFB int3
009CCFFC int3
009CCFFD int3
009CCFFE int3

; range 0x91c830..0x91c8ef
0091C830 push ebp
0091C831 mov ebp, esp
0091C833 push -1
0091C835 push 0xaafd0d
0091C83A mov eax, dword ptr fs:[0]
0091C840 push eax
0091C841 sub esp, 0x48
0091C844 mov eax, dword ptr [0xc7b480]
0091C849 xor eax, ebp
0091C84B push eax
0091C84C lea eax, [ebp - 0xc]
0091C84F mov dword ptr fs:[0], eax
0091C855 mov dword ptr [ebp - 0x4c], ecx
0091C858 push 0xbb082c
0091C85D lea ecx, [ebp - 0x2c]
0091C860 call 0x405650
0091C865 mov dword ptr [ebp - 4], 0
0091C86C lea eax, [ebp - 0x2c]
0091C86F push eax
0091C870 mov ecx, dword ptr [ebp - 0x4c]
0091C873 call 0x75fbf0
0091C878 mov dword ptr [ebp - 0x10], eax
0091C87B mov dword ptr [ebp - 4], 0xffffffff
0091C882 lea ecx, [ebp - 0x2c]
0091C885 call 0x4056d0
0091C88A cmp dword ptr [ebp - 0x10], 0
0091C88E je 0x91c8e0
0091C890 mov ecx, dword ptr [0x17c86fc]
0091C896 call 0x9ccf80
0091C89B push eax
0091C89C lea ecx, [ebp - 0x48]
0091C89F push ecx
0091C8A0 mov ecx, dword ptr [0x17c86f8]
0091C8A6 call 0xa342e0
0091C8AB mov dword ptr [ebp - 0x50], eax
0091C8AE mov edx, dword ptr [ebp - 0x50]
0091C8B1 mov dword ptr [ebp - 0x54], edx
0091C8B4 mov dword ptr [ebp - 4], 1
0091C8BB push 1
0091C8BD mov eax, dword ptr [ebp - 0x54]
0091C8C0 push eax
0091C8C1 mov ecx, dword ptr [ebp - 0x10]
0091C8C4 mov edx, dword ptr [ecx]
0091C8C6 mov ecx, dword ptr [ebp - 0x10]
0091C8C9 mov eax, dword ptr [edx + 0xd4]
0091C8CF call eax
0091C8D1 mov dword ptr [ebp - 4], 0xffffffff
0091C8D8 lea ecx, [ebp - 0x48]
0091C8DB call 0x4056d0
0091C8E0 mov ecx, dword ptr [ebp - 0xc]
0091C8E3 mov dword ptr fs:[0], ecx
0091C8EA pop ecx
0091C8EB mov esp, ebp
0091C8ED pop ebp
0091C8EE ret

; range 0xa342e0..0xa34384
00A342E0 push ebp
00A342E1 mov ebp, esp
00A342E3 sub esp, 0xc
00A342E6 mov dword ptr [ebp - 8], ecx
00A342E9 mov dword ptr [ebp - 4], 0
00A342F0 cmp dword ptr [ebp + 0xc], 1
00A342F4 jle 0xa34365
00A342F6 mov eax, dword ptr [ebp + 0xc]
00A342F9 mov dword ptr [ebp - 0xc], eax
00A342FC cmp dword ptr [ebp - 0xc], 2
00A34300 je 0xa34310
00A34302 cmp dword ptr [ebp - 0xc], 3
00A34306 je 0xa3432d
00A34308 cmp dword ptr [ebp - 0xc], 4
00A3430C je 0xa3434a
00A3430E jmp 0xa34365
00A34310 push 0xb9c84c
00A34315 mov ecx, dword ptr [ebp + 8]
00A34318 call 0x405650
00A3431D mov ecx, dword ptr [ebp - 4]
00A34320 or ecx, 1
00A34323 mov dword ptr [ebp - 4], ecx
00A34326 mov eax, dword ptr [ebp + 8]
00A34329 jmp 0xa3437e
00A3432B jmp 0xa34365
00A3432D push 0xb9c854
00A34332 mov ecx, dword ptr [ebp + 8]
00A34335 call 0x405650
00A3433A mov edx, dword ptr [ebp - 4]
00A3433D or edx, 1
00A34340 mov dword ptr [ebp - 4], edx
00A34343 mov eax, dword ptr [ebp + 8]
00A34346 jmp 0xa3437e
00A34348 jmp 0xa34365
00A3434A push 0xb9c85c
00A3434F mov ecx, dword ptr [ebp + 8]
00A34352 call 0x405650
00A34357 mov eax, dword ptr [ebp - 4]
00A3435A or eax, 1
00A3435D mov dword ptr [ebp - 4], eax
00A34360 mov eax, dword ptr [ebp + 8]
00A34363 jmp 0xa3437e
00A34365 push 0xb9c864
00A3436A mov ecx, dword ptr [ebp + 8]
00A3436D call 0x405650
00A34372 mov ecx, dword ptr [ebp - 4]
00A34375 or ecx, 1
00A34378 mov dword ptr [ebp - 4], ecx
00A3437B mov eax, dword ptr [ebp + 8]
00A3437E mov esp, ebp
00A34380 pop ebp
00A34381 ret 8

; range 0x83b3e0..0x83b992
0083B3E0 push ebp
0083B3E1 mov ebp, esp
0083B3E3 push -1
0083B3E5 push 0xab6add
0083B3EA mov eax, dword ptr fs:[0]
0083B3F0 push eax
0083B3F1 sub esp, 0x374
0083B3F7 mov eax, dword ptr [0xc7b480]
0083B3FC xor eax, ebp
0083B3FE push eax
0083B3FF lea eax, [ebp - 0xc]
0083B402 mov dword ptr fs:[0], eax
0083B408 mov dword ptr [ebp - 0x320], ecx
0083B40E mov eax, dword ptr [0xb983c0]
0083B413 push eax
0083B414 lea ecx, [ebp - 0x58]
0083B417 call 0x405650
0083B41C mov dword ptr [ebp - 4], 0
0083B423 lea ecx, [ebp - 0x58]
0083B426 push ecx
0083B427 mov ecx, dword ptr [ebp - 0x320]
0083B42D call 0x75fbf0
0083B432 mov dword ptr [ebp - 0x28], eax
0083B435 mov dword ptr [ebp - 4], 0xffffffff
0083B43C lea ecx, [ebp - 0x58]
0083B43F call 0x4056d0
0083B444 cmp dword ptr [ebp - 0x28], 0
0083B448 je 0x83b4a9
0083B44A mov ecx, dword ptr [0x17c86fc]
0083B450 call 0x50d850
0083B455 mov dword ptr [ebp - 0x5c], eax
0083B458 lea edx, [ebp - 0x5c]
0083B45B push edx
0083B45C lea eax, [ebp - 0x78]
0083B45F push eax
0083B460 call 0xa44160
0083B465 add esp, 8
0083B468 mov dword ptr [ebp - 0x324], eax
0083B46E mov ecx, dword ptr [ebp - 0x324]
0083B474 mov dword ptr [ebp - 0x328], ecx
0083B47A mov dword ptr [ebp - 4], 1
0083B481 push 1
0083B483 mov edx, dword ptr [ebp - 0x328]
0083B489 push edx
0083B48A mov eax, dword ptr [ebp - 0x28]
0083B48D mov edx, dword ptr [eax]
0083B48F mov ecx, dword ptr [ebp - 0x28]
0083B492 mov eax, dword ptr [edx + 0xd4]
0083B498 call eax
0083B49A mov dword ptr [ebp - 4], 0xffffffff
0083B4A1 lea ecx, [ebp - 0x78]
0083B4A4 call 0x4056d0
0083B4A9 mov ecx, dword ptr [0xb983c4]
0083B4AF push ecx
0083B4B0 lea ecx, [ebp - 0x94]
0083B4B6 call 0x405650
0083B4BB mov dword ptr [ebp - 4], 2
0083B4C2 lea edx, [ebp - 0x94]
0083B4C8 push edx
0083B4C9 mov ecx, dword ptr [ebp - 0x320]
0083B4CF call 0x75fbf0
0083B4D4 mov dword ptr [ebp - 0x28], eax
0083B4D7 mov dword ptr [ebp - 4], 0xffffffff
0083B4DE lea ecx, [ebp - 0x94]
0083B4E4 call 0x4056d0
0083B4E9 cmp dword ptr [ebp - 0x28], 0
0083B4ED je 0x83b55a
0083B4EF mov ecx, dword ptr [0x17c86fc]
0083B4F5 call 0x9ccf20
0083B4FA mov dword ptr [ebp - 0x98], eax
0083B500 lea eax, [ebp - 0x98]
0083B506 push eax
0083B507 lea ecx, [ebp - 0xb4]
0083B50D push ecx
0083B50E call 0xa44160
0083B513 add esp, 8
0083B516 mov dword ptr [ebp - 0x32c], eax
0083B51C mov edx, dword ptr [ebp - 0x32c]
0083B522 mov dword ptr [ebp - 0x330], edx
0083B528 mov dword ptr [ebp - 4], 3
0083B52F push 1
0083B531 mov eax, dword ptr [ebp - 0x330]
0083B537 push eax
0083B538 mov ecx, dword ptr [ebp - 0x28]
0083B53B mov edx, dword ptr [ecx]
0083B53D mov ecx, dword ptr [ebp - 0x28]
0083B540 mov eax, dword ptr [edx + 0xd4]
0083B546 call eax
0083B548 mov dword ptr [ebp - 4], 0xffffffff
0083B54F lea ecx, [ebp - 0xb4]
0083B555 call 0x4056d0
0083B55A mov ecx, dword ptr [0xb983c8]
0083B560 push ecx
0083B561 lea ecx, [ebp - 0xd0]
0083B567 call 0x405650
0083B56C mov dword ptr [ebp - 4], 4
0083B573 lea edx, [ebp - 0xd0]
0083B579 push edx
0083B57A mov ecx, dword ptr [ebp - 0x320]
0083B580 call 0x75fbf0
0083B585 mov dword ptr [ebp - 0x28], eax
0083B588 mov dword ptr [ebp - 4], 0xffffffff
0083B58F lea ecx, [ebp - 0xd0]
0083B595 call 0x4056d0
0083B59A cmp dword ptr [ebp - 0x28], 0
0083B59E je 0x83b60b
0083B5A0 mov ecx, dword ptr [0x17c86fc]
0083B5A6 call 0x48e120
0083B5AB mov dword ptr [ebp - 0xd4], eax
0083B5B1 lea eax, [ebp - 0xd4]
0083B5B7 push eax
0083B5B8 lea ecx, [ebp - 0xf0]
0083B5BE push ecx
0083B5BF call 0xa44160
0083B5C4 add esp, 8
0083B5C7 mov dword ptr [ebp - 0x334], eax
0083B5CD mov edx, dword ptr [ebp - 0x334]
0083B5D3 mov dword ptr [ebp - 0x338], edx
0083B5D9 mov dword ptr [ebp - 4], 5
0083B5E0 push 1
0083B5E2 mov eax, dword ptr [ebp - 0x338]
0083B5E8 push eax
0083B5E9 mov ecx, dword ptr [ebp - 0x28]
0083B5EC mov edx, dword ptr [ecx]
0083B5EE mov ecx, dword ptr [ebp - 0x28]
0083B5F1 mov eax, dword ptr [edx + 0xd4]
0083B5F7 call eax
0083B5F9 mov dword ptr [ebp - 4], 0xffffffff
0083B600 lea ecx, [ebp - 0xf0]
0083B606 call 0x4056d0
0083B60B mov ecx, dword ptr [0xb983cc]
0083B611 push ecx
0083B612 lea ecx, [ebp - 0x10c]
0083B618 call 0x405650
0083B61D mov dword ptr [ebp - 4], 6
0083B624 lea edx, [ebp - 0x10c]
0083B62A push edx
0083B62B mov ecx, dword ptr [ebp - 0x320]
0083B631 call 0x75fbf0
0083B636 mov dword ptr [ebp - 0x28], eax
0083B639 mov dword ptr [ebp - 4], 0xffffffff
0083B640 lea ecx, [ebp - 0x10c]
0083B646 call 0x4056d0
0083B64B cmp dword ptr [ebp - 0x28], 0
0083B64F je 0x83b6bc
0083B651 mov ecx, dword ptr [0x17c86fc]
0083B657 call 0x50d850
0083B65C mov dword ptr [ebp - 0x110], eax
0083B662 lea eax, [ebp - 0x110]
0083B668 push eax
0083B669 lea ecx, [ebp - 0x12c]
0083B66F push ecx
0083B670 call 0xa44160
0083B675 add esp, 8
0083B678 mov dword ptr [ebp - 0x33c], eax
0083B67E mov edx, dword ptr [ebp - 0x33c]
0083B684 mov dword ptr [ebp - 0x340], edx
0083B68A mov dword ptr [ebp - 4], 7
0083B691 push 1
0083B693 mov eax, dword ptr [ebp - 0x340]
0083B699 push eax
0083B69A mov ecx, dword ptr [ebp - 0x28]
0083B69D mov edx, dword ptr [ecx]
0083B69F mov ecx, dword ptr [ebp - 0x28]
0083B6A2 mov eax, dword ptr [edx + 0xd4]
0083B6A8 call eax
0083B6AA mov dword ptr [ebp - 4], 0xffffffff
0083B6B1 lea ecx, [ebp - 0x12c]
0083B6B7 call 0x4056d0
0083B6BC mov ecx, dword ptr [0xb983d0]
0083B6C2 push ecx
0083B6C3 lea ecx, [ebp - 0x148]
0083B6C9 call 0x405650
0083B6CE mov dword ptr [ebp - 4], 8
0083B6D5 lea edx, [ebp - 0x148]
0083B6DB push edx
0083B6DC mov ecx, dword ptr [ebp - 0x320]
0083B6E2 call 0x75fbf0
0083B6E7 mov dword ptr [ebp - 0x28], eax
0083B6EA mov dword ptr [ebp - 4], 0xffffffff
0083B6F1 lea ecx, [ebp - 0x148]
0083B6F7 call 0x4056d0
0083B6FC cmp dword ptr [ebp - 0x28], 0
0083B700 je 0x83b76d
0083B702 mov ecx, dword ptr [0x17c86fc]
0083B708 call 0x9ccf20
0083B70D mov dword ptr [ebp - 0x14c], eax
0083B713 lea eax, [ebp - 0x14c]
0083B719 push eax
0083B71A lea ecx, [ebp - 0x168]
0083B720 push ecx
0083B721 call 0xa44160
0083B726 add esp, 8
0083B729 mov dword ptr [ebp - 0x344], eax
0083B72F mov edx, dword ptr [ebp - 0x344]
0083B735 mov dword ptr [ebp - 0x348], edx
0083B73B mov dword ptr [ebp - 4], 9
0083B742 push 1
0083B744 mov eax, dword ptr [ebp - 0x348]
0083B74A push eax
0083B74B mov ecx, dword ptr [ebp - 0x28]
0083B74E mov edx, dword ptr [ecx]
0083B750 mov ecx, dword ptr [ebp - 0x28]
0083B753 mov eax, dword ptr [edx + 0xd4]
0083B759 call eax
0083B75B mov dword ptr [ebp - 4], 0xffffffff
0083B762 lea ecx, [ebp - 0x168]
0083B768 call 0x4056d0
0083B76D mov ecx, dword ptr [0xb983d4]
0083B773 push ecx
0083B774 lea ecx, [ebp - 0x184]
0083B77A call 0x405650
0083B77F mov dword ptr [ebp - 4], 0xa
0083B786 lea edx, [ebp - 0x184]
0083B78C push edx
0083B78D mov ecx, dword ptr [ebp - 0x320]
0083B793 call 0x75fbf0
0083B798 mov dword ptr [ebp - 0x28], eax
0083B79B mov dword ptr [ebp - 4], 0xffffffff
0083B7A2 lea ecx, [ebp - 0x184]
0083B7A8 call 0x4056d0
0083B7AD cmp dword ptr [ebp - 0x28], 0
0083B7B1 je 0x83b81e
0083B7B3 mov ecx, dword ptr [0x17c86fc]
0083B7B9 call 0x48e120
0083B7BE mov dword ptr [ebp - 0x188], eax
0083B7C4 lea eax, [ebp - 0x188]
0083B7CA push eax
0083B7CB lea ecx, [ebp - 0x1a4]
0083B7D1 push ecx
0083B7D2 call 0xa44160
0083B7D7 add esp, 8
0083B7DA mov dword ptr [ebp - 0x34c], eax
0083B7E0 mov edx, dword ptr [ebp - 0x34c]
0083B7E6 mov dword ptr [ebp - 0x350], edx
0083B7EC mov dword ptr [ebp - 4], 0xb
0083B7F3 push 1
0083B7F5 mov eax, dword ptr [ebp - 0x350]
0083B7FB push eax
0083B7FC mov ecx, dword ptr [ebp - 0x28]
0083B7FF mov edx, dword ptr [ecx]
0083B801 mov ecx, dword ptr [ebp - 0x28]
0083B804 mov eax, dword ptr [edx + 0xd4]
0083B80A call eax
0083B80C mov dword ptr [ebp - 4], 0xffffffff
0083B813 lea ecx, [ebp - 0x1a4]
0083B819 call 0x4056d0
0083B81E mov dword ptr [ebp - 0x24], 0x64
0083B825 mov byte ptr [ebp - 0xd], 0
0083B829 mov ecx, dword ptr [ebp + 8]
0083B82C mov edx, dword ptr [ecx + 0x1e]
0083B82F mov dword ptr [ebp - 0x20], edx
0083B832 mov eax, dword ptr [ebp - 0x320]
0083B838 mov ecx, dword ptr [ebp + 8]
0083B83B mov edx, dword ptr [ecx + 0x26]
0083B83E mov dword ptr [eax + 0x730], edx
0083B844 mov eax, dword ptr [ebp - 0x320]
0083B84A cmp dword ptr [eax + 0x600], 0x10a
0083B854 je 0x83b8a6
0083B856 lea ecx, [ebp - 0x24]
0083B859 push ecx
0083B85A mov ecx, dword ptr [ebp - 0x320]
0083B860 call 0x83adb0
0083B865 movzx edx, al
0083B868 test edx, edx
0083B86A je 0x83b8a6
0083B86C mov eax, dword ptr [ebp - 0x24]
0083B86F push eax
0083B870 mov ecx, dword ptr [ebp + 8]
0083B873 mov edx, dword ptr [ecx + 0x1e]
0083B876 push edx
0083B877 call 0x523920
0083B87C add esp, 8
0083B87F mov dword ptr [ebp - 0x20], eax
0083B882 mov eax, dword ptr [ebp - 0x24]
0083B885 push eax
0083B886 mov ecx, dword ptr [ebp + 8]
0083B889 mov edx, dword ptr [ecx + 0x26]
0083B88C push edx
0083B88D call 0x523920
0083B892 add esp, 8
0083B895 mov ecx, dword ptr [ebp - 0x320]
0083B89B mov dword ptr [ecx + 0x730], eax
0083B8A1 jmp 0x83b992
0083B8A6 mov ecx, dword ptr [0x17c86fc]
0083B8AC call 0x9ccfa0
0083B8B1 mov edx, dword ptr [eax + 0x10]
0083B8B4 mov dword ptr [ebp - 0x2c], edx
0083B8B7 mov dword ptr [ebp - 0x34], 0x7fffffff
0083B8BE mov dword ptr [ebp - 0x30], 0x7fffffff
0083B8C5 cmp dword ptr [ebp - 0x2c], 0
0083B8C9 jle 0x83b90e
0083B8CB mov eax, dword ptr [ebp + 8]
0083B8CE mov eax, dword ptr [eax + 0x1e]
0083B8D1 imul eax, dword ptr [ebp - 0x2c]
0083B8D5 cdq
0083B8D6 mov ecx, 0x64
0083B8DB idiv ecx
0083B8DD mov dword ptr [ebp - 0x34], eax
0083B8E0 mov edx, dword ptr [ebp + 8]
0083B8E3 mov eax, dword ptr [edx + 0x26]
0083B8E6 imul eax, dword ptr [ebp - 0x2c]
0083B8EA cdq
0083B8EB mov ecx, 0x64
0083B8F0 idiv ecx
0083B8F2 mov dword ptr [ebp - 0x30], eax
0083B8F5 mov edx, dword ptr [ebp - 0x34]
0083B8F8 mov dword ptr [ebp - 0x20], edx
0083B8FB mov eax, dword ptr [ebp - 0x320]
0083B901 mov ecx, dword ptr [ebp - 0x30]
0083B904 mov dword ptr [eax + 0x730], ecx
0083B90A mov byte ptr [ebp - 0xd], 1
0083B90E mov edx, dword ptr [ebp + 8]
0083B911 movzx eax, byte ptr [edx + 0x2e]
0083B915 test eax, eax
0083B917 je 0x83b992
0083B919 mov ecx, dword ptr [ebp + 8]
0083B91C mov edx, dword ptr [ebp - 0x34]
0083B91F cmp edx, dword ptr [ecx + 0x22]
0083B922 jge 0x83b92f
0083B924 mov eax, dword ptr [ebp - 0x34]
0083B927 mov dword ptr [ebp - 0x354], eax
0083B92D jmp 0x83b93b
0083B92F mov ecx, dword ptr [ebp + 8]
0083B932 mov edx, dword ptr [ecx + 0x22]
0083B935 mov dword ptr [ebp - 0x354], edx
0083B93B mov eax, dword ptr [ebp - 0x354]
0083B941 mov dword ptr [ebp - 0x20], eax
0083B944 mov ecx, dword ptr [ebp + 8]
0083B947 mov edx, dword ptr [ebp - 0x30]
0083B94A cmp edx, dword ptr [ecx + 0x2a]
0083B94D jge 0x83b95a
0083B94F mov eax, dword ptr [ebp - 0x30]
0083B952 mov dword ptr [ebp - 0x358], eax
0083B958 jmp 0x83b966
0083B95A mov ecx, dword ptr [ebp + 8]
0083B95D mov edx, dword ptr [ecx + 0x2a]
0083B960 mov dword ptr [ebp - 0x358], edx
0083B966 mov eax, dword ptr [ebp - 0x320]
0083B96C mov ecx, dword ptr [ebp - 0x358]
0083B972 mov dword ptr [eax + 0x730], ecx
0083B978 mov edx, dword ptr [ebp + 8]
0083B97B mov eax, dword ptr [edx + 0x22]
0083B97E cmp eax, dword ptr [ebp - 0x34]
0083B981 jl 0x83b98e
0083B983 mov ecx, dword ptr [ebp + 8]
0083B986 mov edx, dword ptr [ecx + 0x2a]
0083B989 cmp edx, dword ptr [ebp - 0x30]
0083B98C jge 0x83b992
0083B98E mov byte ptr [ebp - 0xd], 0

; range 0x8406f0..0x84096d
008406F0 push ebp
008406F1 mov ebp, esp
008406F3 push -1
008406F5 push 0xadf677
008406FA mov eax, dword ptr fs:[0]
00840700 push eax
00840701 sub esp, 0x350
00840707 mov eax, dword ptr [0xc7b480]
0084070C xor eax, ebp
0084070E mov dword ptr [ebp - 0x1c], eax
00840711 push eax
00840712 lea eax, [ebp - 0xc]
00840715 mov dword ptr fs:[0], eax
0084071B mov dword ptr [ebp - 0x344], ecx
00840721 mov eax, dword ptr [ebp - 0x344]
00840727 cmp dword ptr [eax + 0x600], 0x10a
00840731 je 0x8407cb
00840737 lea ecx, [ebp - 0x14]
0084073A call 0x649ac0
0084073F mov ecx, dword ptr [ebp - 0x344]
00840745 cmp dword ptr [ecx + 0x72c], 0
0084074C jb 0x8407a1
0084074E mov ecx, dword ptr [ebp - 0x344]
00840754 add ecx, 0x708
0084075A call 0x4f3770
0084075F mov edx, dword ptr [ebp - 0x344]
00840765 cmp dword ptr [edx + 0x72c], eax
0084076B jae 0x8407a1
0084076D mov eax, dword ptr [ebp - 0x344]
00840773 mov ecx, dword ptr [eax + 0x72c]
00840779 push ecx
0084077A mov ecx, dword ptr [ebp - 0x344]
00840780 add ecx, 0x708
00840786 call 0x52f7e0
0084078B mov dword ptr [ebp - 0x18], eax
0084078E mov edx, dword ptr [ebp - 0x18]
00840791 mov eax, dword ptr [edx]
00840793 mov ecx, dword ptr [eax]
00840795 mov dword ptr [ebp - 0x14], ecx
00840798 mov edx, dword ptr [ebp - 0x18]
0084079B mov eax, dword ptr [edx + 0xc]
0084079E mov dword ptr [ebp - 0x10], eax
008407A1 mov ecx, dword ptr [ebp - 0x14]
008407A4 neg ecx
008407A6 sbb ecx, ecx
008407A8 lea edx, [ebp - 0x14]
008407AB and ecx, edx
008407AD push ecx
008407AE mov eax, dword ptr [ebp - 0x344]
008407B4 add eax, 0x578
008407B9 push eax
008407BA call 0x41bc70
008407BF mov ecx, eax
008407C1 call 0x85d230
008407C6 jmp 0x840c99
008407CB mov ecx, dword ptr [ebp - 0x344]
008407D1 cmp dword ptr [ecx + 0x600], 0x10a
008407DB jne 0x840c99
008407E1 push 0xa9
008407E6 push 0
008407E8 lea edx, [ebp - 0x1dc]
008407EE push edx
008407EF call 0x666960
008407F4 add esp, 0xc
008407F7 mov ecx, dword ptr [0x17c86fc]
008407FD call 0x402aa0
00840802 mov dword ptr [ebp - 0x1d8], eax
00840808 mov dword ptr [ebp - 0x1d4], edx
0084080E lea eax, [ebp - 0x2e8]
00840814 push eax
00840815 mov ecx, dword ptr [0x17c86fc]
0084081B call 0x416240
00840820 mov dword ptr [ebp - 0x348], eax
00840826 mov ecx, dword ptr [ebp - 0x348]
0084082C call 0x453f50
00840831 push eax
00840832 lea ecx, [ebp - 0x1d0]
00840838 push ecx
00840839 call 0x4b1970
0084083E add esp, 8
00840841 lea ecx, [ebp - 0x2e8]
00840847 call 0x406050
0084084C mov ecx, dword ptr [0x17c86fc]
00840852 call 0x402aa0
00840857 mov dword ptr [ebp - 0x1a6], eax
0084085D mov dword ptr [ebp - 0x1a2], edx
00840863 lea edx, [ebp - 0x2ec]
00840869 push edx
0084086A mov ecx, dword ptr [0x17c86fc]
00840870 call 0x416240
00840875 mov dword ptr [ebp - 0x34c], eax
0084087B mov ecx, dword ptr [ebp - 0x34c]
00840881 call 0x453f50
00840886 push eax
00840887 lea eax, [ebp - 0x19e]
0084088D push eax
0084088E call 0x4b1970
00840893 add esp, 8
00840896 lea ecx, [ebp - 0x2ec]
0084089C call 0x406050
008408A1 mov ecx, dword ptr [ebp - 0x344]
008408A7 mov edx, dword ptr [ecx + 0x604]
008408AD mov dword ptr [ebp - 0x14b], edx
008408B3 mov eax, dword ptr [ebp - 0x344]
008408B9 mov ecx, dword ptr [eax + 0x620]
008408BF mov dword ptr [ebp - 0x137], ecx
008408C5 mov edx, dword ptr [ebp - 0x344]
008408CB mov eax, dword ptr [edx + 0x614]
008408D1 mov dword ptr [ebp - 0x13f], eax
008408D7 cmp dword ptr [0x17c86fc], 0
008408DE je 0x84091e
008408E0 mov ecx, dword ptr [0x17c86fc]
008408E6 call 0x9ccfa0
008408EB mov ecx, dword ptr [eax + 0x10]
008408EE mov dword ptr [ebp - 0x1e0], ecx
008408F4 cmp dword ptr [ebp - 0x1e0], 0
008408FB jle 0x84091e
008408FD mov edx, dword ptr [ebp - 0x344]
00840903 mov eax, dword ptr [edx + 0x614]
00840909 imul eax, dword ptr [ebp - 0x1e0]
00840910 cdq
00840911 mov ecx, 0x64
00840916 idiv ecx
00840918 mov dword ptr [ebp - 0x13f], eax
0084091E mov edx, dword ptr [ebp - 0x344]
00840924 cmp dword ptr [edx + 0x618], 0
0084092B jle 0x84096d
0084092D mov eax, dword ptr [ebp - 0x344]
00840933 mov ecx, dword ptr [ebp - 0x13f]
00840939 cmp ecx, dword ptr [eax + 0x618]
0084093F jge 0x84094f
00840941 mov edx, dword ptr [ebp - 0x13f]
00840947 mov dword ptr [ebp - 0x350], edx
0084094D jmp 0x840961
0084094F mov eax, dword ptr [ebp - 0x344]
00840955 mov ecx, dword ptr [eax + 0x618]
0084095B mov dword ptr [ebp - 0x350], ecx
00840961 mov edx, dword ptr [ebp - 0x350]
00840967 mov dword ptr [ebp - 0x13f], edx

; range 0x85d230..0x85d421
0085D230 push ebp
0085D231 mov ebp, esp
0085D233 push -1
0085D235 push 0xadee23
0085D23A mov eax, dword ptr fs:[0]
0085D240 push eax
0085D241 sub esp, 0x2a4
0085D247 mov eax, dword ptr [0xc7b480]
0085D24C xor eax, ebp
0085D24E mov dword ptr [ebp - 0x10], eax
0085D251 push esi
0085D252 push eax
0085D253 lea eax, [ebp - 0xc]
0085D256 mov dword ptr fs:[0], eax
0085D25C mov dword ptr [ebp - 0x298], ecx
0085D262 push 0xa9
0085D267 push 0
0085D269 lea eax, [ebp - 0x1cc]
0085D26F push eax
0085D270 call 0x666960
0085D275 add esp, 0xc
0085D278 mov ecx, dword ptr [0x17c86fc]
0085D27E call 0x402aa0
0085D283 mov dword ptr [ebp - 0x1c8], eax
0085D289 mov dword ptr [ebp - 0x1c4], edx
0085D28F lea ecx, [ebp - 0x258]
0085D295 push ecx
0085D296 mov ecx, dword ptr [0x17c86fc]
0085D29C call 0x416240
0085D2A1 mov dword ptr [ebp - 0x29c], eax
0085D2A7 mov ecx, dword ptr [ebp - 0x29c]
0085D2AD call 0x453f50
0085D2B2 push eax
0085D2B3 lea edx, [ebp - 0x1c0]
0085D2B9 push edx
0085D2BA call 0x4b1970
0085D2BF add esp, 8
0085D2C2 lea ecx, [ebp - 0x258]
0085D2C8 call 0x406050
0085D2CD mov ecx, dword ptr [0x17c86fc]
0085D2D3 call 0x402aa0
0085D2D8 mov dword ptr [ebp - 0x196], eax
0085D2DE mov dword ptr [ebp - 0x192], edx
0085D2E4 lea eax, [ebp - 0x25c]
0085D2EA push eax
0085D2EB mov ecx, dword ptr [0x17c86fc]
0085D2F1 call 0x416240
0085D2F6 mov dword ptr [ebp - 0x2a0], eax
0085D2FC mov ecx, dword ptr [ebp - 0x2a0]
0085D302 call 0x453f50
0085D307 push eax
0085D308 lea ecx, [ebp - 0x18e]
0085D30E push ecx
0085D30F call 0x4b1970
0085D314 add esp, 8
0085D317 lea ecx, [ebp - 0x25c]
0085D31D call 0x406050
0085D322 mov edx, dword ptr [ebp + 8]
0085D325 mov eax, dword ptr [edx + 0x4d]
0085D328 mov dword ptr [ebp - 0x127], eax
0085D32E mov ecx, dword ptr [ebp + 8]
0085D331 mov edx, dword ptr [ecx + 9]
0085D334 mov dword ptr [ebp - 0x13b], edx
0085D33A mov eax, dword ptr [ebp + 8]
0085D33D mov ecx, dword ptr [eax + 0x1e]
0085D340 mov dword ptr [ebp - 0x137], ecx
0085D346 mov edx, dword ptr [ebp + 8]
0085D349 mov eax, dword ptr [edx + 0x26]
0085D34C mov dword ptr [ebp - 0x12f], eax
0085D352 cmp dword ptr [0x17c86fc], 0
0085D359 je 0x85d3ae
0085D35B mov ecx, dword ptr [0x17c86fc]
0085D361 call 0x9ccfa0
0085D366 mov ecx, dword ptr [eax + 0x10]
0085D369 mov dword ptr [ebp - 0x1d0], ecx
0085D36F cmp dword ptr [ebp - 0x1d0], 0
0085D376 jle 0x85d3ae
0085D378 mov edx, dword ptr [ebp + 8]
0085D37B mov eax, dword ptr [edx + 0x1e]
0085D37E imul eax, dword ptr [ebp - 0x1d0]
0085D385 cdq
0085D386 mov ecx, 0x64
0085D38B idiv ecx
0085D38D mov dword ptr [ebp - 0x137], eax
0085D393 mov edx, dword ptr [ebp + 8]
0085D396 mov eax, dword ptr [edx + 0x26]
0085D399 imul eax, dword ptr [ebp - 0x1d0]
0085D3A0 cdq
0085D3A1 mov ecx, 0x64
0085D3A6 idiv ecx
0085D3A8 mov dword ptr [ebp - 0x12f], eax
0085D3AE mov edx, dword ptr [ebp + 8]
0085D3B1 movzx eax, byte ptr [edx + 0x2e]
0085D3B5 test eax, eax
0085D3B7 je 0x85d421
0085D3B9 mov ecx, dword ptr [ebp + 8]
0085D3BC mov edx, dword ptr [ebp - 0x137]
0085D3C2 cmp edx, dword ptr [ecx + 0x22]
0085D3C5 jge 0x85d3d5
0085D3C7 mov eax, dword ptr [ebp - 0x137]
0085D3CD mov dword ptr [ebp - 0x2a4], eax
0085D3D3 jmp 0x85d3e1
0085D3D5 mov ecx, dword ptr [ebp + 8]
0085D3D8 mov edx, dword ptr [ecx + 0x22]
0085D3DB mov dword ptr [ebp - 0x2a4], edx
0085D3E1 mov eax, dword ptr [ebp - 0x2a4]
0085D3E7 mov dword ptr [ebp - 0x137], eax
0085D3ED mov ecx, dword ptr [ebp + 8]
0085D3F0 mov edx, dword ptr [ebp - 0x12f]
0085D3F6 cmp edx, dword ptr [ecx + 0x2a]
0085D3F9 jge 0x85d409
0085D3FB mov eax, dword ptr [ebp - 0x12f]
0085D401 mov dword ptr [ebp - 0x2a8], eax
0085D407 jmp 0x85d415
0085D409 mov ecx, dword ptr [ebp + 8]
0085D40C mov edx, dword ptr [ecx + 0x2a]
0085D40F mov dword ptr [ebp - 0x2a8], edx
0085D415 mov eax, dword ptr [ebp - 0x2a8]
0085D41B mov dword ptr [ebp - 0x12f], eax
