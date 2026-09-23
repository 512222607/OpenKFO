; Read-only analysis; NOT a playable patch
; SHA256 1b7c8676e778c7bd47f55184f927338da3cf70c6aa5f0beb59869ea0f0ac9d4e
; mode=1 factory=0x0098C385 vtable=0x00BA9144 bases=.?AVCLiveTeamMode@@,.?AVCGeneralBattleMode@@,.?AVIBattleMode@@
; mode=3 factory=0x0098C48D vtable=0x00BA87D4 bases=.?AVCDeathTeamMode@@,.?AVCGeneralBattleMode@@,.?AVIBattleMode@@
; mode=10 factory=0x0098C5BD vtable=0x00BAD584 bases=.?AVCFosterMode@@,.?AVCPVEBaseMode@@,.?AVIBattleMode@@
; mode=21 factory=0x0098C618 vtable=0x00BADD44 bases=.?AVCStageAssaultMode@@,.?AVCPVEBaseMode@@,.?AVIBattleMode@@,.?AVILuaHelperDebugTextListener@scgl@@

; create packet consumer: 00827AD0..00827B4E
00827AD0 push ebp
00827AD1 mov ebp, esp
00827AD3 sub esp, 0xc
00827AD6 mov dword ptr [ebp - 0xc], ecx
00827AD9 cmp dword ptr [ebp + 8], 0
00827ADD je 0x827ae5
00827ADF cmp dword ptr [ebp + 0xc], 0x43
00827AE3 je 0x827ae7
00827AE5 jmp 0x827b4a
00827AE7 mov eax, dword ptr [ebp + 8]
00827AEA mov dword ptr [ebp - 8], eax
00827AED push 0
00827AEF push 0x12f8fe8
00827AF4 push 0x12f899c
00827AF9 mov ecx, dword ptr [0x17c8710]
00827AFF call 0x453db0
00827B04 push 0
00827B06 push eax
00827B07 call 0xa97b0e
00827B0C add esp, 0x14
00827B0F mov dword ptr [ebp - 4], eax
00827B12 cmp dword ptr [ebp - 4], 0
00827B16 je 0x827b4a
00827B18 push 0
00827B1A mov ecx, dword ptr [ebp - 8]
00827B1D mov edx, dword ptr [ecx + 0x3f]
00827B20 push edx
00827B21 mov eax, dword ptr [ebp - 8]
00827B24 add eax, 0x33
00827B27 push eax
00827B28 mov ecx, dword ptr [ebp - 8]
00827B2B mov edx, dword ptr [ecx + 0x2f]
00827B2E push edx
00827B2F mov eax, dword ptr [ebp - 8]
00827B32 mov ecx, dword ptr [eax + 0x2b]
00827B35 push ecx
00827B36 mov edx, dword ptr [eax + 0x27]
00827B39 push edx
00827B3A mov eax, dword ptr [ebp - 4]
00827B3D mov edx, dword ptr [eax]
00827B3F mov ecx, dword ptr [ebp - 4]
00827B42 mov eax, dword ptr [edx + 0x108]
00827B48 call eax
00827B4A mov esp, ebp
00827B4C pop ebp

; foster create or reuse: 00941350..009415C6
00941350 push ebp
00941351 mov ebp, esp
00941353 sub esp, 0x38
00941356 mov dword ptr [ebp - 0x38], ecx
00941359 cmp dword ptr [ebp + 0x10], 0
0094135D jge 0x941366
0094135F xor al, al
00941361 jmp 0x9415c2
00941366 mov eax, dword ptr [ebp + 0x10]
00941369 push eax
0094136A call 0x4d4380
0094136F mov ecx, eax
00941371 call 0xa62b40
00941376 mov dword ptr [ebp - 4], eax
00941379 cmp dword ptr [ebp - 4], 0
0094137D jne 0x941386
0094137F xor al, al
00941381 jmp 0x9415c2
00941386 lea ecx, [ebp - 0xc]
00941389 push ecx
0094138A mov ecx, dword ptr [ebp - 0x38]
0094138D add ecx, 0x98
00941393 call 0x561740
00941398 jmp 0x9413a2
0094139A lea ecx, [ebp - 0xc]
0094139D call 0x504fb0
009413A2 lea edx, [ebp - 0x20]
009413A5 push edx
009413A6 mov ecx, dword ptr [ebp - 0x38]
009413A9 add ecx, 0x98
009413AF call 0x44a4d0
009413B4 push eax
009413B5 lea ecx, [ebp - 0xc]
009413B8 call 0x44a500
009413BD movzx eax, al
009413C0 test eax, eax
009413C2 je 0x94159e
009413C8 lea ecx, [ebp - 0xc]
009413CB call 0x58a020
009413D0 mov ecx, dword ptr [eax]
009413D2 push ecx
009413D3 mov ecx, dword ptr [0x17c8708]
009413D9 call 0x818450
009413DE mov dword ptr [ebp - 0x10], eax
009413E1 cmp dword ptr [ebp - 0x10], 0
009413E5 je 0x941599
009413EB mov edx, dword ptr [ebp - 0x10]
009413EE mov eax, dword ptr [edx]
009413F0 mov ecx, dword ptr [ebp - 0x10]
009413F3 mov edx, dword ptr [eax + 4]
009413F6 call edx
009413F8 movzx eax, al
009413FB test eax, eax
009413FD je 0x941599
00941403 mov ecx, dword ptr [ebp - 0x10]
00941406 call 0x44e130
0094140B test eax, eax
0094140D jne 0x941599
00941413 mov ecx, dword ptr [ebp - 0x10]
00941416 call 0x44e110
0094141B movzx ecx, al
0094141E cmp ecx, 1
00941421 jne 0x941599
00941427 mov ecx, dword ptr [ebp - 0x10]
0094142A call 0x4537c0
0094142F mov dword ptr [ebp - 0x14], eax
00941432 mov edx, dword ptr [ebp - 0x14]
00941435 mov eax, dword ptr [ebp - 4]
00941438 mov ecx, dword ptr [edx]
0094143A cmp ecx, dword ptr [eax + 0x1c]
0094143D jne 0x941599
00941443 mov edx, dword ptr [ebp - 0x14]
00941446 mov eax, dword ptr [ebp - 4]
00941449 mov ecx, dword ptr [edx + 0x11]
0094144C cmp ecx, dword ptr [eax + 0x1c]
0094144F jne 0x941599
00941455 mov edx, dword ptr [ebp - 0x14]
00941458 mov eax, dword ptr [ebp - 4]
0094145B mov ecx, dword ptr [edx + 0x99]
00941461 cmp ecx, dword ptr [eax + 0x20]
00941464 jne 0x941599
0094146A mov edx, dword ptr [ebp - 0x14]
0094146D mov eax, dword ptr [ebp - 4]
00941470 mov ecx, dword ptr [edx + 0xdd]
00941476 cmp ecx, dword ptr [eax + 0x24]
00941479 jne 0x941599
0094147F mov edx, dword ptr [ebp - 0x14]
00941482 mov eax, dword ptr [ebp - 4]
00941485 mov ecx, dword ptr [edx + 0x55]
00941488 cmp ecx, dword ptr [eax + 0x28]
0094148B jne 0x941599
00941491 mov edx, dword ptr [ebp - 0x14]
00941494 mov eax, dword ptr [ebp - 4]
00941497 mov ecx, dword ptr [edx + 0x121]
0094149D cmp ecx, dword ptr [eax + 0x2c]
009414A0 jne 0x941599
009414A6 mov edx, dword ptr [ebp - 0x14]
009414A9 mov eax, dword ptr [ebp - 4]
009414AC mov ecx, dword ptr [edx + 0x165]
009414B2 cmp ecx, dword ptr [eax + 0x30]
009414B5 jne 0x941599
009414BB mov edx, dword ptr [ebp - 0x14]
009414BE mov eax, dword ptr [ebp - 4]
009414C1 mov ecx, dword ptr [edx + 0x1a9]
009414C7 cmp ecx, dword ptr [eax + 0x34]
009414CA jne 0x941599
009414D0 mov edx, dword ptr [ebp - 0x14]
009414D3 mov eax, dword ptr [ebp - 4]
009414D6 mov ecx, dword ptr [edx + 0x341]
009414DC cmp ecx, dword ptr [eax + 0x38]
009414DF jne 0x941599
009414E5 mov edx, dword ptr [ebp - 0xc]
009414E8 mov dword ptr [ebp - 0x28], edx
009414EB mov eax, dword ptr [ebp - 8]
009414EE mov dword ptr [ebp - 0x24], eax
009414F1 mov ecx, dword ptr [ebp - 0x24]
009414F4 push ecx
009414F5 mov edx, dword ptr [ebp - 0x28]
009414F8 push edx
009414F9 lea eax, [ebp - 0x30]
009414FC push eax
009414FD mov ecx, dword ptr [ebp - 0x38]
00941500 add ecx, 0x98
00941506 call 0x43e970
0094150B push 0x20
0094150D call 0x667fbb
00941512 add esp, 4
00941515 mov dword ptr [ebp - 0x34], eax
00941518 mov ecx, dword ptr [ebp - 0x34]
0094151B mov dword ptr [ebp - 0x18], ecx
0094151E mov edx, dword ptr [ebp - 0x18]
00941521 mov eax, dword ptr [ebp + 8]
00941524 mov dword ptr [edx], eax
00941526 mov ecx, dword ptr [ebp + 0xc]
00941529 mov dword ptr [edx + 4], ecx
0094152C mov edx, dword ptr [ebp + 0x14]
0094152F mov eax, dword ptr [ebp - 0x18]
00941532 add eax, 8
00941535 mov ecx, dword ptr [edx]
00941537 mov dword ptr [eax], ecx
00941539 mov ecx, dword ptr [edx + 4]
0094153C mov dword ptr [eax + 4], ecx
0094153F mov edx, dword ptr [edx + 8]
00941542 mov dword ptr [eax + 8], edx
00941545 mov eax, dword ptr [ebp - 0x18]
00941548 mov ecx, dword ptr [ebp + 0x18]
0094154B mov dword ptr [eax + 0x14], ecx
0094154E mov edx, dword ptr [ebp - 0x18]
00941551 mov eax, dword ptr [ebp + 0x1c]
00941554 mov dword ptr [edx + 0x18], eax
00941557 mov ecx, dword ptr [ebp - 0x18]
0094155A mov edx, dword ptr [ebp - 4]
0094155D mov dword ptr [ecx + 0x1c], edx
00941560 lea eax, [ebp + 8]
00941563 push eax
00941564 mov ecx, dword ptr [ebp - 0x38]
00941567 add ecx, 0xd8
0094156D call 0x4d7230
00941572 mov ecx, dword ptr [ebp - 0x18]
00941575 mov dword ptr [eax], ecx
00941577 mov edx, dword ptr [ebp - 0x18]
0094157A push edx
0094157B mov eax, dword ptr [ebp + 0xc]
0094157E push eax
0094157F mov ecx, dword ptr [ebp + 8]
00941582 push ecx
00941583 mov edx, dword ptr [ebp - 0x10]
00941586 push edx
00941587 mov eax, dword ptr [ebp - 0x38]
0094158A mov ecx, dword ptr [eax + 0xd4]
00941590 call 0xa57d10
00941595 mov al, 1
00941597 jmp 0x9415c2
00941599 jmp 0x94139a
0094159E mov ecx, dword ptr [ebp + 0x1c]
009415A1 push ecx
009415A2 mov edx, dword ptr [ebp + 0x18]
009415A5 push edx
009415A6 mov eax, dword ptr [ebp + 0x14]
009415A9 push eax
009415AA mov ecx, dword ptr [ebp + 0x10]
009415AD push ecx
009415AE mov edx, dword ptr [ebp + 0xc]
009415B1 push edx
009415B2 mov eax, dword ptr [ebp + 8]
009415B5 push eax
009415B6 mov ecx, dword ptr [ebp - 4]
009415B9 push ecx
009415BA mov ecx, dword ptr [ebp - 0x38]
009415BD call 0x941060
009415C2 mov esp, ebp
009415C4 pop ebp

; foster create submission: 00941060..0094134B
00941060 push ebp
00941061 mov ebp, esp
00941063 sub esp, 0x4e4
00941069 push esi
0094106A mov dword ptr [ebp - 0x4e4], ecx
00941070 mov ecx, dword ptr [ebp - 0x4e4]
00941076 add ecx, 0x98
0094107C call 0x4f9670
00941081 test eax, eax
00941083 jbe 0x94112c
00941089 mov eax, dword ptr [ebp - 0x4e4]
0094108F mov ecx, dword ptr [eax + 0xd4]
00941095 call 0xa57770
0094109A mov dword ptr [ebp - 0x4d4], eax
009410A0 mov ecx, dword ptr [0x17c8710]
009410A6 call 0x44e300
009410AB mov ecx, eax
009410AD call 0x61de30
009410B2 mov ecx, eax
009410B4 call 0x4c4cb0
009410B9 mov esi, eax
009410BB mov ecx, dword ptr [0x17c8708]
009410C1 call 0x818cf0
009410C6 sub esi, eax
009410C8 mov dword ptr [ebp - 0x4d8], esi
009410CE mov ecx, dword ptr [ebp - 0x4e4]
009410D4 add ecx, 0x98
009410DA call 0x4f9670
009410DF add eax, dword ptr [ebp - 0x4d4]
009410E5 add eax, dword ptr [ebp - 0x4d8]
009410EB cmp eax, 0x20
009410EE jb 0x94112c
009410F0 mov ecx, dword ptr [ebp - 0x4e4]
009410F6 add ecx, 0x98
009410FC call 0x4d4a00
00941101 mov ecx, dword ptr [eax]
00941103 push ecx
00941104 mov ecx, dword ptr [0x17c8708]
0094110A call 0x818450
0094110F push eax
00941110 mov ecx, dword ptr [0x17c8710]
00941116 call 0x986d20
0094111B mov ecx, dword ptr [ebp - 0x4e4]
00941121 add ecx, 0x98
00941127 call 0x4d4a70
0094112C lea ecx, [ebp - 0x4d0]
00941132 call 0x561d00
00941137 push 0x4d0
0094113C push 0
0094113E lea edx, [ebp - 0x4d0]
00941144 push edx
00941145 call 0x666960
0094114A add esp, 0xc
0094114D mov eax, dword ptr [ebp + 8]
00941150 mov ecx, dword ptr [eax + 0x1c]
00941153 mov dword ptr [ebp - 0x4d0], ecx
00941159 mov byte ptr [ebp - 0x4c4], 0xb
00941160 mov edx, dword ptr [ebp + 8]
00941163 mov eax, dword ptr [edx + 0x1c]
00941166 mov dword ptr [ebp - 0x4bf], eax
0094116C mov dword ptr [ebp - 0x4c8], 0xffffffff
00941176 mov byte ptr [ebp - 0x43c], 0xf
0094117D mov ecx, dword ptr [ebp + 8]
00941180 mov edx, dword ptr [ecx + 0x20]
00941183 mov dword ptr [ebp - 0x437], edx
00941189 mov dword ptr [ebp - 0x440], 0xffffffff
00941193 mov byte ptr [ebp - 0x3f8], 0xd
0094119A mov eax, dword ptr [ebp + 8]
0094119D mov ecx, dword ptr [eax + 0x24]
009411A0 mov dword ptr [ebp - 0x3f3], ecx
009411A6 mov dword ptr [ebp - 0x3fc], 0xffffffff
009411B0 mov edx, dword ptr [ebp + 8]
009411B3 mov eax, dword ptr [edx + 0x28]
009411B6 push eax
009411B7 call 0x41c100
009411BC mov ecx, eax
009411BE call 0x85b5e0
009411C3 movzx ecx, al
009411C6 test ecx, ecx
009411C8 je 0x9411e9
009411CA mov byte ptr [ebp - 0x480], 0x12
009411D1 mov edx, dword ptr [ebp + 8]
009411D4 mov eax, dword ptr [edx + 0x28]
009411D7 mov dword ptr [ebp - 0x47f], eax
009411DD mov dword ptr [ebp - 0x484], 0xffffffff
009411E7 jmp 0x941206
009411E9 mov byte ptr [ebp - 0x480], 0xc
009411F0 mov ecx, dword ptr [ebp + 8]
009411F3 mov edx, dword ptr [ecx + 0x28]
009411F6 mov dword ptr [ebp - 0x47b], edx
009411FC mov dword ptr [ebp - 0x484], 0xffffffff
00941206 mov byte ptr [ebp - 0x3b4], 0x11
0094120D mov eax, dword ptr [ebp + 8]
00941210 mov ecx, dword ptr [eax + 0x2c]
00941213 mov dword ptr [ebp - 0x3af], ecx
00941219 mov dword ptr [ebp - 0x3b8], 0xffffffff
00941223 mov byte ptr [ebp - 0x370], 0x10
0094122A mov edx, dword ptr [ebp + 8]
0094122D mov eax, dword ptr [edx + 0x30]
00941230 mov dword ptr [ebp - 0x36b], eax
00941236 mov dword ptr [ebp - 0x374], 0xffffffff
00941240 mov byte ptr [ebp - 0x32c], 0xe
00941247 mov ecx, dword ptr [ebp + 8]
0094124A mov edx, dword ptr [ecx + 0x34]
0094124D mov dword ptr [ebp - 0x327], edx
00941253 mov dword ptr [ebp - 0x330], 0xffffffff
0094125D mov byte ptr [ebp - 0x194], 0x19
00941264 mov eax, dword ptr [ebp + 8]
00941267 mov ecx, dword ptr [eax + 0x38]
0094126A mov dword ptr [ebp - 0x18f], ecx
00941270 mov dword ptr [ebp - 0x198], 0xffffffff
0094127A mov edx, dword ptr [ebp - 0x4e4]
00941280 cmp dword ptr [edx + 0xd4], 0
00941287 je 0x941342
0094128D push 0x20
0094128F call 0x667fbb
00941294 add esp, 4
00941297 mov dword ptr [ebp - 0x4e0], eax
0094129D mov eax, dword ptr [ebp - 0x4e0]
009412A3 mov dword ptr [ebp - 0x4dc], eax
009412A9 mov ecx, dword ptr [ebp - 0x4dc]
009412AF mov edx, dword ptr [ebp + 0xc]
009412B2 mov dword ptr [ecx], edx
009412B4 mov eax, dword ptr [ebp + 0x10]
009412B7 mov dword ptr [ecx + 4], eax
009412BA mov ecx, dword ptr [ebp + 0x18]
009412BD mov edx, dword ptr [ebp - 0x4dc]
009412C3 add edx, 8
009412C6 mov eax, dword ptr [ecx]
009412C8 mov dword ptr [edx], eax
009412CA mov eax, dword ptr [ecx + 4]
009412CD mov dword ptr [edx + 4], eax
009412D0 mov ecx, dword ptr [ecx + 8]
009412D3 mov dword ptr [edx + 8], ecx
009412D6 mov edx, dword ptr [ebp - 0x4dc]
009412DC mov eax, dword ptr [ebp + 0x1c]
009412DF mov dword ptr [edx + 0x14], eax
009412E2 mov ecx, dword ptr [ebp - 0x4dc]
009412E8 mov edx, dword ptr [ebp + 0x20]
009412EB mov dword ptr [ecx + 0x18], edx
009412EE mov eax, dword ptr [ebp - 0x4dc]
009412F4 mov ecx, dword ptr [ebp + 8]
009412F7 mov dword ptr [eax + 0x1c], ecx
009412FA lea edx, [ebp + 0xc]
009412FD push edx
009412FE mov ecx, dword ptr [ebp - 0x4e4]
00941304 add ecx, 0xd8
0094130A call 0x4d7230
0094130F mov ecx, dword ptr [ebp - 0x4dc]
00941315 mov dword ptr [eax], ecx
00941317 mov edx, dword ptr [ebp - 0x4dc]
0094131D push edx
0094131E mov eax, dword ptr [ebp + 0x10]
00941321 push eax
00941322 mov ecx, dword ptr [ebp + 0xc]
00941325 push ecx
00941326 lea edx, [ebp - 0x4d0]
0094132C push edx
0094132D mov eax, dword ptr [ebp - 0x4e4]
00941333 mov ecx, dword ptr [eax + 0xd4]
00941339 call 0xa57da0
0094133E mov al, 1
00941340 jmp 0x941344
00941342 xor al, al
00941344 pop esi
00941345 mov esp, ebp
00941347 pop ebp
00941348 ret 0x1c

; loader queue submit: 00A57DA0..00A57E43
00A57DA0 push ebp
00A57DA1 mov ebp, esp
00A57DA3 sub esp, 0x14
00A57DA6 push esi
00A57DA7 push edi
00A57DA8 mov dword ptr [ebp - 0x10], ecx
00A57DAB push 0x4e8
00A57DB0 call 0x667fbb
00A57DB5 add esp, 4
00A57DB8 mov dword ptr [ebp - 0xc], eax
00A57DBB cmp dword ptr [ebp - 0xc], 0
00A57DBF je 0xa57dce
00A57DC1 mov ecx, dword ptr [ebp - 0xc]
00A57DC4 call 0x44a430
00A57DC9 mov dword ptr [ebp - 0x14], eax
00A57DCC jmp 0xa57dd5
00A57DCE mov dword ptr [ebp - 0x14], 0
00A57DD5 mov eax, dword ptr [ebp - 0x14]
00A57DD8 mov dword ptr [ebp - 8], eax
00A57DDB mov ecx, dword ptr [ebp - 8]
00A57DDE mov dword ptr [ebp - 4], ecx
00A57DE1 mov edx, dword ptr [ebp - 4]
00A57DE4 mov dword ptr [edx], 0
00A57DEA mov eax, dword ptr [ebp - 4]
00A57DED mov dword ptr [eax + 4], 0
00A57DF4 mov ecx, dword ptr [ebp - 4]
00A57DF7 mov edx, dword ptr [ebp + 0xc]
00A57DFA mov dword ptr [ecx + 8], edx
00A57DFD mov eax, dword ptr [ebp + 0x10]
00A57E00 mov dword ptr [ecx + 0xc], eax
00A57E03 mov ecx, dword ptr [ebp - 4]
00A57E06 mov edx, dword ptr [ebp + 0x14]
00A57E09 mov dword ptr [ecx + 0x10], edx
00A57E0C mov esi, dword ptr [ebp + 8]
00A57E0F mov edi, dword ptr [ebp - 4]
00A57E12 add edi, 0x14
00A57E15 mov ecx, 0x134
00A57E1A rep movsd dword ptr es:[edi], dword ptr [esi]
00A57E1C mov ecx, dword ptr [ebp - 0x10]
00A57E1F call 0xa57750
00A57E24 lea eax, [ebp - 4]
00A57E27 push eax
00A57E28 mov ecx, dword ptr [ebp - 0x10]
00A57E2B add ecx, 4
00A57E2E call 0x532800
00A57E33 mov ecx, dword ptr [ebp - 0x10]
00A57E36 call 0xa57730
00A57E3B pop edi
00A57E3C pop esi
00A57E3D mov esp, ebp
00A57E3F pop ebp
00A57E40 ret 0x10

; foster loader result processing: 00943960..00943D8C
00943960 push ebp
00943961 mov ebp, esp
00943963 push -1
00943965 push 0xae0c7f
0094396A mov eax, dword ptr fs:[0]
00943970 push eax
00943971 sub esp, 0x48
00943974 push esi
00943975 mov eax, dword ptr [0xc7b480]
0094397A xor eax, ebp
0094397C push eax
0094397D lea eax, [ebp - 0xc]
00943980 mov dword ptr fs:[0], eax
00943986 mov dword ptr [ebp - 0x48], ecx
00943989 cmp dword ptr [ebp + 8], 0
0094398D jne 0x943994
0094398F jmp 0x943b49
00943994 mov eax, dword ptr [ebp + 8]
00943997 mov ecx, dword ptr [eax + 4]
0094399A mov dword ptr [ebp - 0x10], ecx
0094399D mov edx, dword ptr [ebp + 8]
009439A0 mov eax, dword ptr [edx + 0x10]
009439A3 mov dword ptr [ebp - 0x14], eax
009439A6 cmp dword ptr [ebp - 0x10], 0
009439AA je 0x943ad9
009439B0 cmp dword ptr [ebp - 0x14], 0
009439B4 je 0x943ad9
009439BA mov ecx, dword ptr [ebp - 0x14]
009439BD cmp dword ptr [ecx + 0x1c], 0
009439C1 je 0x943ad9
009439C7 mov edx, dword ptr [ebp - 0x14]
009439CA mov eax, dword ptr [edx + 4]
009439CD push eax
009439CE mov ecx, dword ptr [edx]
009439D0 push ecx
009439D1 mov ecx, dword ptr [ebp - 0x10]
009439D4 call 0x9e48d0
009439D9 mov edx, dword ptr [ebp - 0x14]
009439DC mov ecx, dword ptr [edx + 0x1c]
009439DF call 0x405750
009439E4 push eax
009439E5 lea ecx, [ebp - 0x2c]
009439E8 call 0x405fd0
009439ED mov dword ptr [ebp - 0x4c], eax
009439F0 mov eax, dword ptr [ebp - 0x4c]
009439F3 mov dword ptr [ebp - 0x50], eax
009439F6 mov dword ptr [ebp - 4], 0
009439FD mov ecx, dword ptr [ebp - 0x50]
00943A00 push ecx
00943A01 mov ecx, dword ptr [ebp - 0x10]
00943A04 call 0x454840
00943A09 mov dword ptr [ebp - 4], 0xffffffff
00943A10 lea ecx, [ebp - 0x2c]
00943A13 call 0x406050
00943A18 mov byte ptr [ebp - 0x24], 0
00943A1C xor edx, edx
00943A1E mov dword ptr [ebp - 0x23], edx
00943A21 mov dword ptr [ebp - 0x1f], edx
00943A24 mov dword ptr [ebp - 0x1b], edx
00943A27 mov word ptr [ebp - 0x17], dx
00943A2B mov byte ptr [ebp - 0x15], dl
00943A2E mov byte ptr [ebp - 0x18], 0xff
00943A32 mov al, byte ptr [ebp - 0x18]
00943A35 mov byte ptr [ebp - 0x1c], al
00943A38 mov cl, byte ptr [ebp - 0x1c]
00943A3B mov byte ptr [ebp - 0x20], cl
00943A3E mov dl, byte ptr [ebp - 0x20]
00943A41 mov byte ptr [ebp - 0x24], dl
00943A44 mov byte ptr [ebp - 0x15], 0xff
00943A48 mov al, byte ptr [ebp - 0x15]
00943A4B mov byte ptr [ebp - 0x19], al
00943A4E mov cl, byte ptr [ebp - 0x19]
00943A51 mov byte ptr [ebp - 0x1d], cl
00943A54 mov dl, byte ptr [ebp - 0x1d]
00943A57 mov byte ptr [ebp - 0x21], dl
00943A5A mov eax, dword ptr [ebp - 0x14]
00943A5D push eax
00943A5E push 0
00943A60 mov ecx, dword ptr [ebp - 0x10]
00943A63 push ecx
00943A64 mov ecx, dword ptr [ebp - 0x48]
00943A67 call 0x943870
00943A6C mov edx, dword ptr [ebp - 0x14]
00943A6F mov eax, dword ptr [edx + 4]
00943A72 push eax
00943A73 mov ecx, dword ptr [edx]
00943A75 push ecx
00943A76 mov ecx, dword ptr [0x17c8708]
00943A7C call 0x818c00
00943A81 mov dword ptr [ebp - 0x28], eax
00943A84 cmp dword ptr [ebp - 0x28], -1
00943A88 jne 0x943a9e
00943A8A mov edx, dword ptr [ebp - 0x14]
00943A8D add edx, 0x18
00943A90 push edx
00943A91 mov ecx, dword ptr [ebp - 0x48]
00943A94 add ecx, 0x3c
00943A97 call 0x4d4520
00943A9C jmp 0x943ad7
00943A9E mov eax, dword ptr [ebp - 0x14]
00943AA1 mov ecx, dword ptr [eax + 0x1c]
00943AA4 push ecx
00943AA5 push 0
00943AA7 mov edx, dword ptr [ebp - 0x28]
00943AAA push edx
00943AAB lea ecx, [ebp - 0x38]
00943AAE call 0x4d4310
00943AB3 mov esi, eax
00943AB5 mov eax, dword ptr [ebp - 0x14]
00943AB8 add eax, 0x18
00943ABB push eax
00943ABC mov ecx, dword ptr [ebp - 0x48]
00943ABF add ecx, 0x3c
00943AC2 call 0x4d4470
00943AC7 mov ecx, dword ptr [esi]
00943AC9 mov dword ptr [eax], ecx
00943ACB mov edx, dword ptr [esi + 4]
00943ACE mov dword ptr [eax + 4], edx
00943AD1 mov ecx, dword ptr [esi + 8]
00943AD4 mov dword ptr [eax + 8], ecx
00943AD7 jmp 0x943b12
00943AD9 cmp dword ptr [ebp - 0x10], 0
00943ADD je 0x943b12
00943ADF mov edx, dword ptr [ebp - 0x10]
00943AE2 mov dword ptr [ebp - 0x40], edx
00943AE5 mov eax, dword ptr [ebp - 0x40]
00943AE8 mov dword ptr [ebp - 0x3c], eax
00943AEB cmp dword ptr [ebp - 0x3c], 0
00943AEF je 0x943b04
00943AF1 push 1
00943AF3 mov ecx, dword ptr [ebp - 0x3c]
00943AF6 mov edx, dword ptr [ecx]
00943AF8 mov ecx, dword ptr [ebp - 0x3c]
00943AFB mov eax, dword ptr [edx]
00943AFD call eax
00943AFF mov dword ptr [ebp - 0x54], eax
00943B02 jmp 0x943b0b
00943B04 mov dword ptr [ebp - 0x54], 0
00943B0B mov dword ptr [ebp - 0x10], 0
00943B12 cmp dword ptr [ebp - 0x14], 0
00943B16 je 0x943b49
00943B18 mov ecx, dword ptr [ebp - 0x14]
00943B1B push ecx
00943B1C mov ecx, dword ptr [ebp - 0x48]
00943B1F add ecx, 0xd8
00943B25 call 0x4d4ae0
00943B2A cmp dword ptr [ebp - 0x14], 0
00943B2E je 0x943b49
00943B30 mov edx, dword ptr [ebp - 0x14]
00943B33 mov dword ptr [ebp - 0x44], edx
00943B36 mov eax, dword ptr [ebp - 0x44]
00943B39 push eax
00943B3A call 0x6634f0
00943B3F add esp, 4
00943B42 mov dword ptr [ebp - 0x14], 0
00943B49 mov ecx, dword ptr [ebp - 0xc]
00943B4C mov dword ptr fs:[0], ecx
00943B53 pop ecx
00943B54 pop esi
00943B55 mov esp, ebp
00943B57 pop ebp
00943B58 ret 4
00943B5B int3
00943B5C int3
00943B5D int3
00943B5E int3
00943B5F int3
00943B60 push ebp
00943B61 mov ebp, esp
00943B63 sub esp, 0x70
00943B66 mov dword ptr [ebp - 0x70], ecx
00943B69 mov eax, dword ptr [ebp - 0x70]
00943B6C cmp dword ptr [eax + 0xd4], 0
00943B73 jne 0x943b7a
00943B75 jmp 0x943d88
00943B7A mov ecx, dword ptr [ebp - 0x70]
00943B7D mov ecx, dword ptr [ecx + 0xd4]
00943B83 call 0xa580f0
00943B88 mov ecx, dword ptr [0x17c8708]
00943B8E call 0x819120
00943B93 test eax, eax
00943B95 je 0x943d0e
00943B9B mov ecx, dword ptr [0x17c8708]
00943BA1 call 0x819120
00943BA6 mov ecx, eax
00943BA8 call 0x44b3f0
00943BAD test eax, eax
00943BAF je 0x943d0e
00943BB5 mov dword ptr [ebp - 4], 0
00943BBC mov dword ptr [ebp - 8], 0
00943BC3 jmp 0x943bce
00943BC5 mov edx, dword ptr [ebp - 8]
00943BC8 add edx, 1
00943BCB mov dword ptr [ebp - 8], edx
00943BCE cmp dword ptr [ebp - 8], 8
00943BD2 jae 0x943c2a
00943BD4 mov eax, dword ptr [ebp - 8]
00943BD7 push eax
00943BD8 mov ecx, dword ptr [0x17c8708]
00943BDE call 0x818450
00943BE3 mov dword ptr [ebp - 0xc], eax
00943BE6 cmp dword ptr [ebp - 0xc], 0
00943BEA je 0x943c28
00943BEC mov ecx, dword ptr [ebp - 0xc]
00943BEF call 0x44b3f0
00943BF4 test eax, eax
00943BF6 jne 0x943c28
00943BF8 mov ecx, dword ptr [ebp - 0xc]
00943BFB call 0x44b280
00943C00 test eax, eax
00943C02 jne 0x943c28
00943C04 mov ecx, dword ptr [ebp - 0xc]
00943C07 mov edx, dword ptr [ecx]
00943C09 mov ecx, dword ptr [ebp - 0xc]
00943C0C mov eax, dword ptr [edx + 4]
00943C0F call eax
00943C11 movzx ecx, al
00943C14 test ecx, ecx
00943C16 jne 0x943c28
00943C18 mov edx, 1
00943C1D mov ecx, dword ptr [ebp - 8]
00943C20 shl edx, cl
00943C22 or edx, dword ptr [ebp - 4]
00943C25 mov dword ptr [ebp - 4], edx
00943C28 jmp 0x943bc5
00943C2A lea eax, [ebp - 0x14]
00943C2D push eax
00943C2E mov ecx, dword ptr [ebp - 0x70]
00943C31 add ecx, 0xb4
00943C37 call 0x5504a0
00943C3C lea ecx, [ebp - 0x54]
00943C3F push ecx
00943C40 mov ecx, dword ptr [ebp - 0x70]
00943C43 add ecx, 0xb4
00943C49 call 0x45abb0
00943C4E push eax
00943C4F lea ecx, [ebp - 0x14]
00943C52 call 0x4ab8f0
00943C57 movzx edx, al
00943C5A test edx, edx
00943C5C je 0x943d0c
00943C62 lea ecx, [ebp - 0x14]
00943C65 call 0x569150
00943C6A mov ecx, dword ptr [ebp - 4]
00943C6D cmp ecx, dword ptr [eax + 8]
00943C70 jne 0x943cff
00943C76 push 1
00943C78 lea ecx, [ebp - 0x14]
00943C7B call 0x569150
00943C80 mov edx, dword ptr [eax + 4]
00943C83 push edx
00943C84 mov eax, dword ptr [eax]
00943C86 push eax
00943C87 mov ecx, dword ptr [ebp - 0x70]
00943C8A mov ecx, dword ptr [ecx + 0xd4]
00943C90 call 0xa57b70
00943C95 mov dword ptr [ebp - 0x18], eax
00943C98 cmp dword ptr [ebp - 0x18], 0
00943C9C je 0x943cff
00943C9E mov edx, dword ptr [ebp - 0x18]
00943CA1 push edx
00943CA2 mov ecx, dword ptr [ebp - 0x70]
00943CA5 call 0x943960
00943CAA cmp dword ptr [ebp - 0x18], 0
00943CAE je 0x943cc9
00943CB0 mov eax, dword ptr [ebp - 0x18]
00943CB3 mov dword ptr [ebp - 0x58], eax
00943CB6 mov ecx, dword ptr [ebp - 0x58]
00943CB9 push ecx
00943CBA call 0x6634f0
00943CBF add esp, 4
00943CC2 mov dword ptr [ebp - 0x18], 0
00943CC9 mov edx, dword ptr [ebp - 0x14]
00943CCC mov dword ptr [ebp - 0x60], edx
00943CCF mov eax, dword ptr [ebp - 0x10]
00943CD2 mov dword ptr [ebp - 0x5c], eax
00943CD5 mov ecx, dword ptr [ebp - 0x5c]
00943CD8 push ecx
00943CD9 mov edx, dword ptr [ebp - 0x60]
00943CDC push edx
00943CDD lea eax, [ebp - 0x68]
00943CE0 push eax
00943CE1 mov ecx, dword ptr [ebp - 0x70]
00943CE4 add ecx, 0xb4
00943CEA call 0x48d2a0
00943CEF mov ecx, dword ptr [eax]
00943CF1 mov edx, dword ptr [eax + 4]
00943CF4 mov dword ptr [ebp - 0x14], ecx
00943CF7 mov dword ptr [ebp - 0x10], edx
00943CFA jmp 0x943c3c
00943CFF lea ecx, [ebp - 0x14]
00943D02 call 0x4d72f0
00943D07 jmp 0x943c3c
00943D0C jmp 0x943d88
00943D0E push 1
00943D10 mov eax, dword ptr [ebp - 0x70]
00943D13 mov ecx, dword ptr [eax + 0xd4]
00943D19 call 0xa57c50
00943D1E mov dword ptr [ebp - 0x1c], eax
00943D21 cmp dword ptr [ebp - 0x1c], 0
00943D25 je 0x943d88
00943D27 mov ecx, dword ptr [ebp - 0x1c]
00943D2A push ecx
00943D2B mov ecx, dword ptr [ebp - 0x70]
00943D2E call 0x943960
00943D33 push 0x2f
00943D35 push 0
00943D37 lea edx, [ebp - 0x4c]
00943D3A push edx
00943D3B call 0x666960
00943D40 add esp, 0xc
00943D43 mov eax, dword ptr [ebp - 0x1c]
00943D46 mov ecx, dword ptr [eax + 8]
00943D49 mov dword ptr [ebp - 0x25], ecx
00943D4C mov edx, dword ptr [eax + 0xc]
00943D4F mov dword ptr [ebp - 0x21], edx
00943D52 push 0
00943D54 push 0
00943D56 push 0x2f
00943D58 lea eax, [ebp - 0x4c]
00943D5B push eax
00943D5C push 0x4fb6
00943D61 call 0xa3fbb0
00943D66 add esp, 0x14
00943D69 cmp dword ptr [ebp - 0x1c], 0
00943D6D je 0x943d88
00943D6F mov ecx, dword ptr [ebp - 0x1c]
00943D72 mov dword ptr [ebp - 0x6c], ecx
00943D75 mov edx, dword ptr [ebp - 0x6c]
00943D78 push edx
00943D79 call 0x6634f0
00943D7E add esp, 4
00943D81 mov dword ptr [ebp - 0x1c], 0
00943D88 mov esp, ebp
00943D8A pop ebp
00943D8B ret

; foster update: 00943D90..00943DAB
00943D90 push ebp
00943D91 mov ebp, esp
00943D93 push ecx
00943D94 mov dword ptr [ebp - 4], ecx
00943D97 mov ecx, dword ptr [ebp - 4]
00943D9A call 0x943b60
00943D9F mov ecx, dword ptr [ebp - 4]
00943DA2 call 0x941910
00943DA7 mov esp, ebp
00943DA9 pop ebp
00943DAA ret
