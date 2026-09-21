
; 0xa1ec20
00a1ec20 push ebp
00a1ec21 mov ebp, esp
00a1ec23 push -1
00a1ec25 push 0xaa5b06
00a1ec2a mov eax, dword ptr fs:[0]
00a1ec30 push eax
00a1ec31 sub esp, 8
00a1ec34 mov eax, dword ptr [0xc7b480]
00a1ec39 xor eax, ebp
00a1ec3b push eax
00a1ec3c lea eax, [ebp - 0xc]
00a1ec3f mov dword ptr fs:[0], eax
00a1ec45 mov dword ptr [ebp - 0x14], 0
00a1ec4c lea ecx, [ebp - 0x10]
00a1ec4f call 0x405f90
00a1ec54 mov dword ptr [ebp - 4], 0
00a1ec5b cmp dword ptr [ebp + 0x14], 0
00a1ec5f jne 0xa1ed85
00a1ec65 cmp dword ptr [ebp + 0x10], 0
00a1ec69 je 0xa1ed85
00a1ec6f cmp dword ptr [ebp + 0xc], 0
00a1ec73 jne 0xa1ecd1
00a1ec75 cmp dword ptr [ebp + 0x10], 0x2238
00a1ec7c jb 0xa1ec91
00a1ec7e push 0xb9dc1c
00a1ec83 lea eax, [ebp - 0x10]
00a1ec86 push eax
00a1ec87 call 0x411c60
00a1ec8c add esp, 8
00a1ec8f jmp 0xa1eccc
00a1ec91 cmp dword ptr [ebp + 0x10], 0x18
00a1ec95 jb 0xa1ecb7
00a1ec97 mov eax, dword ptr [ebp + 0x10]
00a1ec9a xor edx, edx
00a1ec9c mov ecx, 0x18
00a1eca1 div ecx
00a1eca3 push eax
00a1eca4 push 0xb9dc24
00a1eca9 lea edx, [ebp - 0x10]
00a1ecac push edx
00a1ecad call 0x411c60
00a1ecb2 add esp, 0xc
00a1ecb5 jmp 0xa1eccc
00a1ecb7 mov eax, dword ptr [ebp + 0x10]
00a1ecba push eax
00a1ecbb push 0xb9dc2c
00a1ecc0 lea ecx, [ebp - 0x10]
00a1ecc3 push ecx
00a1ecc4 call 0x411c60
00a1ecc9 add esp, 0xc
00a1eccc jmp 0xa1ed83
00a1ecd1 cmp dword ptr [ebp + 0xc], 1
00a1ecd5 jne 0xa1ed70
00a1ecdb mov eax, dword ptr [ebp + 0x10]
00a1ecde xor edx, edx
00a1ece0 mov ecx, 0x5a0
00a1ece5 div ecx
00a1ece7 test eax, eax
00a1ece9 jne 0xa1ed2e
00a1eceb mov eax, dword ptr [ebp + 0x10]
00a1ecee xor edx, edx
00a1ecf0 mov ecx, 0x3c
00a1ecf5 div ecx
00a1ecf7 test eax, eax
00a1ecf9 jne 0xa1ed0e
00a1ecfb push 0xb9dc34
00a1ed00 lea edx, [ebp - 0x10]
00a1ed03 push edx
00a1ed04 call 0x411c60
00a1ed09 add esp, 8
00a1ed0c jmp 0xa1ed2c
00a1ed0e mov eax, dword ptr [ebp + 0x10]
00a1ed11 xor edx, edx
00a1ed13 mov ecx, 0x3c
00a1ed18 div ecx
00a1ed1a push eax
00a1ed1b push 0xb9dc14
00a1ed20 lea edx, [ebp - 0x10]
00a1ed23 push edx
00a1ed24 call 0x411c60
00a1ed29 add esp, 0xc
00a1ed2c jmp 0xa1ed6e
00a1ed2e mov eax, dword ptr [ebp + 0x10]
00a1ed31 xor edx, edx
00a1ed33 mov ecx, 0x3c
00a1ed38 div ecx
00a1ed3a cmp eax, 0x2238
00a1ed3f jb 0xa1ed50
00a1ed41 push 0xb9dc04
00a1ed46 lea ecx, [ebp - 0x10]
00a1ed49 call 0x406090
00a1ed4e jmp 0xa1ed6e
00a1ed50 mov eax, dword ptr [ebp + 0x10]
00a1ed53 xor edx, edx
00a1ed55 mov ecx, 0x5a0
00a1ed5a div ecx
00a1ed5c push eax
00a1ed5d push 0xb9dc0c
00a1ed62 lea edx, [ebp - 0x10]
00a1ed65 push edx
00a1ed66 call 0x411c60
00a1ed6b add esp, 0xc
00a1ed6e jmp 0xa1ed83
00a1ed70 cmp dword ptr [ebp + 0xc], 2
00a1ed74 jne 0xa1ed83
00a1ed76 push 0xb9dc3c
00a1ed7b lea ecx, [ebp - 0x10]
00a1ed7e call 0x406090
00a1ed83 jmp 0xa1edb0
00a1ed85 cmp dword ptr [ebp + 0x14], 0
00a1ed89 je 0xa1eda8
00a1ed8b cmp dword ptr [ebp + 0x10], 0
00a1ed8f jne 0xa1eda8
00a1ed91 mov eax, dword ptr [ebp + 0x14]
00a1ed94 push eax
00a1ed95 push 0xb9dc44
00a1ed9a lea ecx, [ebp - 0x10]
00a1ed9d push ecx
00a1ed9e call 0x411c60
00a1eda3 add esp, 0xc
00a1eda6 jmp 0xa1edb0
00a1eda8 lea ecx, [ebp - 0x10]
00a1edab call 0x4063a0
00a1edb0 lea edx, [ebp - 0x10]
00a1edb3 push edx
00a1edb4 mov ecx, dword ptr [ebp + 8]
00a1edb7 call 0x405fb0
00a1edbc mov eax, dword ptr [ebp - 0x14]
00a1edbf or eax, 1
00a1edc2 mov dword ptr [ebp - 0x14], eax
00a1edc5 mov dword ptr [ebp - 4], 0xffffffff
00a1edcc lea ecx, [ebp - 0x10]
00a1edcf call 0x406050
00a1edd4 mov eax, dword ptr [ebp + 8]
00a1edd7 mov ecx, dword ptr [ebp - 0xc]
00a1edda mov dword ptr fs:[0], ecx
00a1ede1 pop ecx
00a1ede2 mov esp, ebp
00a1ede4 pop ebp
00a1ede5 ret

; 0x8ab7d5
008ab7d5 mov eax, dword ptr [ebp + 0xc]
008ab7d8 push eax
008ab7d9 mov ecx, dword ptr [ebp - 0x460]
008ab7df add ecx, 0x594
008ab7e5 call 0x506880
008ab7ea mov ecx, dword ptr [eax + 0x14]
008ab7ed push ecx
008ab7ee mov edx, dword ptr [ebp + 0xc]
008ab7f1 push edx
008ab7f2 mov ecx, dword ptr [ebp - 0x460]
008ab7f8 add ecx, 0x594
008ab7fe call 0x506880
008ab803 mov eax, dword ptr [eax + 0x20]
008ab806 push eax
008ab807 mov ecx, dword ptr [ebp + 0xc]
008ab80a push ecx
008ab80b mov ecx, dword ptr [ebp - 0x460]
008ab811 add ecx, 0x594
008ab817 call 0x506880
008ab81c mov edx, dword ptr [eax + 0x1c]
008ab81f push edx
008ab820 lea eax, [ebp - 0x2b8]
008ab826 push eax
008ab827 call 0xa1ec20
008ab82c add esp, 0x10
008ab82f mov dword ptr [ebp - 0x4cc], eax
008ab835 mov ecx, dword ptr [ebp - 0x4cc]
008ab83b mov dword ptr [ebp - 0x4d0], ecx
008ab841 mov byte ptr [ebp - 4], 0x12
008ab845 mov edx, dword ptr [ebp - 0x4d0]
008ab84b push edx
008ab84c lea ecx, [ebp - 0x18]
008ab84f call 0x406070
008ab854 mov byte ptr [ebp - 4], 0x11
008ab858 lea ecx, [ebp - 0x2b8]
008ab85e call 0x406050
008ab863 mov eax, dword ptr [ebp + 0xc]
008ab866 push eax
008ab867 mov ecx, dword ptr [ebp - 0x460]
008ab86d add ecx, 0x594
008ab873 call 0x506880
008ab878 mov ecx, dword ptr [eax + 0x14]
008ab87b push ecx
008ab87c mov edx, dword ptr [ebp + 0xc]
008ab87f push edx
008ab880 mov ecx, dword ptr [ebp - 0x460]
008ab886 add ecx, 0x594
008ab88c call 0x506880
008ab891 mov eax, dword ptr [eax + 0x20]
008ab894 push eax
008ab895 mov ecx, dword ptr [ebp + 0xc]
008ab898 push ecx
008ab899 mov ecx, dword ptr [ebp - 0x460]
008ab89f add ecx, 0x594
008ab8a5 call 0x506880
008ab8aa mov edx, dword ptr [eax + 0x1c]
008ab8ad push edx
008ab8ae call 0xa1e1d0
008ab8b3 add esp, 0xc
008ab8b6 mov dword ptr [ebp - 0x10], eax
008ab8b9 mov eax, dword ptr [ebp - 0x10]
008ab8bc push eax
008ab8bd mov ecx, dword ptr [ebp - 0x20]
008ab8c0 call 0x4b2350
008ab8c5 lea ecx, [ebp - 0x18]
008ab8c8 call 0x406410
008ab8cd push eax
008ab8ce lea ecx, [ebp - 0x2d4]
008ab8d4 call 0x405650
008ab8d9 mov byte ptr [ebp - 4], 0x13
008ab8dd push 1
008ab8df lea ecx, [ebp - 0x2d4]
008ab8e5 push ecx
008ab8e6 mov edx, dword ptr [ebp - 0x20]
008ab8e9 mov eax, dword ptr [edx]
008ab8eb mov ecx, dword ptr [ebp - 0x20]
008ab8ee mov edx, dword ptr [eax + 0xd4]
008ab8f4 call edx
008ab8f6 mov byte ptr [ebp - 4], 0x11
008ab8fa lea ecx, [ebp - 0x2d4]
008ab900 call 0x4056d0
008ab905 lea ecx, [ebp - 0x18]
008ab908 call 0x406450
008ab90d movzx eax, al
008ab910 test eax, eax
008ab912 je 0x8aba39
008ab918 lea ecx, [ebp + 8]
008ab91b push ecx
008ab91c lea edx, [ebp - 0x2f0]
008ab922 push edx
008ab923 call 0xa44160
008ab928 add esp, 8
008ab92b mov dword ptr [ebp - 0x4d4], eax
008ab931 mov eax, dword ptr [ebp - 0x4d4]
008ab937 mov dword ptr [ebp - 0x4d8], eax
008ab93d mov byte ptr [ebp - 4], 0x14
008ab941 mov ecx, dword ptr [ebp - 0x4d8]
008ab947 push ecx
008ab948 mov edx, dword ptr [0xb99490]
008ab94e push edx
008ab94f lea eax, [ebp - 0x30c]
008ab955 push eax
008ab956 call 0x411d70
008ab95b add esp, 0xc
008ab95e mov dword ptr [ebp - 0x4dc], eax
008ab964 mov ecx, dword ptr [ebp - 0x4dc]
008ab96a mov dword ptr [ebp - 0x4e0], ecx
008ab970 mov byte ptr [ebp - 4], 0x15
008ab974 push 0
008ab976 mov edx, dword ptr [ebp - 0x4e0]
008ab97c push edx
008ab97d mov ecx, dword ptr [ebp - 0x460]
008ab983 call 0x7611c0
008ab988 mov byte ptr [ebp - 4], 0x14
008ab98c lea ecx, [ebp - 0x30c]
008ab992 call 0x4056d0
008ab997 mov byte ptr [ebp - 4], 0x11
008ab99b lea ecx, [ebp - 0x2f0]
008ab9a1 call 0x4056d0
008ab9a6 lea eax, [ebp + 8]
008ab9a9 push eax
008ab9aa lea ecx, [ebp - 0x328]
008ab9b0 push ecx
008ab9b1 call 0xa44160
008ab9b6 add esp, 8
008ab9b9 mov dword ptr [ebp - 0x4e4], eax
008ab9bf mov edx, dword ptr [ebp - 0x4e4]
008ab9c5 mov dword ptr [ebp - 0x4e8], edx
008ab9cb mov byte ptr [ebp - 4], 0x16
008ab9cf mov eax, dword ptr [ebp - 0x4e8]
008ab9d5 push eax
008ab9d6 mov ecx, dword ptr [0xb993ec]
008ab9dc push ecx
008ab9dd lea edx, [ebp - 0x344]
008ab9e3 push edx
008ab9e4 call 0x411d70
008ab9e9 add esp, 0xc
008ab9ec mov dword ptr [ebp - 0x4ec], eax
008ab9f2 mov eax, dword ptr [ebp - 0x4ec]
008ab9f8 mov dword ptr [ebp - 0x4f0], eax
008ab9fe mov byte ptr [ebp - 4], 0x17
008aba02 push 0
008aba04 mov ecx, dword ptr [ebp - 0x4f0]
008aba0a push ecx
008aba0b mov ecx, dword ptr [ebp - 0x460]
008aba11 call 0x7611c0
008aba16 mov byte ptr [ebp - 4], 0x16
008aba1a lea ecx, [ebp - 0x344]
008aba20 call 0x4056d0
008aba25 mov byte ptr [ebp - 4], 0x11
008aba29 lea ecx, [ebp - 0x328]
008aba2f call 0x4056d0
008aba34 jmp 0x8abbe2

; 0x7eff78
007eff78 push 0xb969bc
007eff7d lea ecx, [ebp - 0x28]
007eff80 call 0x405650
007eff85 mov dword ptr [ebp - 4], 0
007eff8c push 0xb969a8
007eff91 lea ecx, [ebp - 0x44]
007eff94 call 0x405650
007eff99 mov byte ptr [ebp - 4], 1
007eff9d push 0
007eff9f lea eax, [ebp - 0x28]
007effa2 push eax
007effa3 lea ecx, [ebp - 0x44]
007effa6 push ecx

; 0x7f026e
007f026e push 0
007f0270 push 0x533f
007f0275 call 0xa3ca00
007f027a add esp, 8
