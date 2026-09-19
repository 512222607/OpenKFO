; Source SHA256: 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 3070 mode=1 spectator path. Does not establish downstream scene initialization.

; Block 0x824b80
00824B80 push ebp
00824B81 mov ebp, esp
00824B83 push ecx
00824B84 mov eax, dword ptr [ebp + 8]
00824B87 mov dword ptr [ebp - 4], eax
00824B8A mov ecx, dword ptr [ebp - 4]
00824B8D mov byte ptr [ecx + 2], 1
00824B91 push 0xe
00824B93 mov edx, dword ptr [ebp - 4]
00824B96 push edx
00824B97 push 0
00824B99 push 0xbfe
00824B9E call 0xa3c950
00824BA3 add esp, 0x10
00824BA6 xor eax, eax
00824BA8 mov esp, ebp
00824BAA pop ebp

; Block 0x92572e
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

; Block 0x925868
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

; Block 0x92590a
0092590A push 0xe
0092590C lea ecx, [ebp - 0x4c]
0092590F push ecx
00925910 push 0
00925912 push 0xbfe
00925917 call 0xa3c950
0092591C add esp, 0x10

; Block 0x92672d
0092672D mov eax, dword ptr [ebp - 0xf0]
00926733 mov cl, byte ptr [eax + 0x5dc]
00926739 mov byte ptr [ebp - 0x1e], cl

; Block 0x9268c2
009268C2 push 0xe
009268C4 lea ecx, [ebp - 0x20]
009268C7 push ecx
009268C8 push 0
009268CA push 0xbfe
009268CF call 0xa3c950
009268D4 add esp, 0x10
; BB0608: full player slots prompt explicitly offers watching; confirmation callback = 824B80.
