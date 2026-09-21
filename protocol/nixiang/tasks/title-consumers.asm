; Read-only gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0xb21f1a
00B21F1A mov dword ptr [0x12fda10], 0x101d
00B21F24 mov dword ptr [0x12fda14], 1
00B21F2E mov dword ptr [ebp - 0x150], 0x829b50
00B21F38 mov dword ptr [ebp - 0x14c], 0
00B21F42 mov dword ptr [ebp - 0x148], 0
00B21F4C mov dword ptr [ebp - 0x144], 0
00B21F56 mov edx, dword ptr [ebp - 0x150]
00B21F5C mov dword ptr [0x12fda18], edx
00B21F62 mov eax, dword ptr [ebp - 0x14c]
00B21F68 mov dword ptr [0x12fda1c], eax
00B21F6D mov ecx, dword ptr [ebp - 0x148]
00B21F73 mov dword ptr [0x12fda20], ecx
00B21F79 mov edx, dword ptr [ebp - 0x144]
00B21F7F mov dword ptr [0x12fda24], edx
00B21F85 mov dword ptr [0x12fda28], 0x184d
00B21F8F mov dword ptr [0x12fda2c], 1

; range 0x829b50
00829B50 push ebp
00829B51 mov ebp, esp
00829B53 push -1
00829B55 push 0xad783a
00829B5A mov eax, dword ptr fs:[0]
00829B60 push eax
00829B61 sub esp, 0x30
00829B64 mov eax, dword ptr [0xc7b480]
00829B69 xor eax, ebp
00829B6B push eax
00829B6C lea eax, [ebp - 0xc]
00829B6F mov dword ptr fs:[0], eax
00829B75 mov dword ptr [ebp - 0x38], ecx
00829B78 cmp dword ptr [ebp + 0xc], 0
00829B7C jne 0x829b83
00829B7E jmp 0x829c62
00829B83 mov eax, dword ptr [ebp + 8]
00829B86 mov dword ptr [ebp - 0x10], eax
00829B89 mov ecx, dword ptr [0x17c86fc]
00829B8F call 0x9cd390
00829B94 mov ecx, dword ptr [ebp - 0x10]
00829B97 mov dl, byte ptr [ecx]
00829B99 mov byte ptr [eax + 0x7b], dl
00829B9C mov ecx, dword ptr [0x17c86fc]
00829BA2 call 0x9cd390
00829BA7 movzx ax, byte ptr [eax + 0x7b]
00829BAC movzx ecx, ax
00829BAF push ecx
00829BB0 call 0x45e2d0
00829BB5 mov ecx, eax
00829BB7 call 0xa73bc0
00829BBC mov dword ptr [ebp - 0x14], eax
00829BBF lea ecx, [ebp - 0x18]
00829BC2 call 0x405f90
00829BC7 mov dword ptr [ebp - 4], 0
00829BCE cmp dword ptr [ebp - 0x14], 0
00829BD2 je 0x829c37
00829BD4 mov ecx, dword ptr [ebp - 0x14]
00829BD7 add ecx, 4
00829BDA call 0x405750
00829BDF push eax
00829BE0 push 0xbcac6c
00829BE5 lea edx, [ebp - 0x18]
00829BE8 push edx
00829BE9 call 0x411c60
00829BEE add esp, 0xc
00829BF1 lea ecx, [ebp - 0x18]
00829BF4 call 0x406410
00829BF9 push eax
00829BFA lea ecx, [ebp - 0x34]
00829BFD call 0x405650
00829C02 mov byte ptr [ebp - 4], 1
00829C06 call 0x403820
00829C0B mov dword ptr [ebp - 0x3c], eax
00829C0E push 0
00829C10 push 0x957250
00829C15 push 0
00829C17 lea eax, [ebp - 0x34]
00829C1A push eax
00829C1B mov ecx, dword ptr [ebp - 0x3c]
00829C1E mov edx, dword ptr [ecx]
00829C20 mov ecx, dword ptr [ebp - 0x3c]
00829C23 mov eax, dword ptr [edx + 0x1c0]
00829C29 call eax
00829C2B mov byte ptr [ebp - 4], 0
00829C2F lea ecx, [ebp - 0x34]
00829C32 call 0x4056d0
00829C37 call 0x4c41e0
00829C3C mov ecx, eax
00829C3E call 0x75f460
00829C43 mov ecx, dword ptr [ebp - 0x10]
00829C46 push ecx
00829C47 call 0x4c41e0
00829C4C mov ecx, eax
00829C4E call 0x957670
00829C53 mov dword ptr [ebp - 4], 0xffffffff
00829C5A lea ecx, [ebp - 0x18]
00829C5D call 0x406050
00829C62 mov ecx, dword ptr [ebp - 0xc]
00829C65 mov dword ptr fs:[0], ecx
00829C6C pop ecx
00829C6D mov esp, ebp
00829C6F pop ebp
00829C70 ret 8

; range 0x957670
00957670 push ebp
00957671 mov ebp, esp
00957673 push -1
00957675 push 0xad696d
0095767A mov eax, dword ptr fs:[0]
00957680 push eax
00957681 sub esp, 0x45c
00957687 mov eax, dword ptr [0xc7b480]
0095768C xor eax, ebp
0095768E mov dword ptr [ebp - 0x10], eax
00957691 push esi
00957692 push edi
00957693 push eax
00957694 lea eax, [ebp - 0xc]
00957697 mov dword ptr fs:[0], eax
0095769D mov dword ptr [ebp - 0x3c8], ecx
009576A3 mov ecx, dword ptr [ebp - 0x3c8]
009576A9 call 0x75f460
009576AE mov esi, dword ptr [ebp + 8]
009576B1 mov edi, dword ptr [ebp - 0x3c8]
009576B7 add edi, 0x578
009576BD mov ecx, 0x10
009576C2 rep movsd dword ptr es:[edi], dword ptr [esi]
009576C4 mov ecx, dword ptr [0x17c86fc]
009576CA call 0x9cd390
009576CF movzx ax, byte ptr [eax + 0x7b]
009576D4 movzx ecx, ax
009576D7 push ecx
009576D8 call 0x45e2d0
009576DD mov ecx, eax

; range 0x9cd960
009CD960 push ebp
009CD961 mov ebp, esp
009CD963 sub esp, 8
009CD966 mov dword ptr [ebp - 8], ecx
009CD969 mov ecx, dword ptr [ebp - 8]
009CD96C call 0x9cd390
009CD971 mov dword ptr [ebp - 4], eax
009CD974 cmp dword ptr [ebp - 4], 0
009CD978 je 0x9cd983
009CD97A mov eax, dword ptr [ebp - 4]
009CD97D movzx eax, byte ptr [eax + 0x7b]
009CD981 jmp 0x9cd988
009CD983 mov eax, 1
009CD988 mov esp, ebp
009CD98A pop ebp
009CD98B ret

; range 0xa73bc0
00A73BC0 push ebp
00A73BC1 mov ebp, esp
00A73BC3 sub esp, 0x1c
00A73BC6 mov dword ptr [ebp - 0x1c], ecx
00A73BC9 mov dword ptr [ebp - 0xc], 0
00A73BD0 movzx eax, word ptr [ebp + 8]
00A73BD4 mov dword ptr [ebp - 0x10], eax
00A73BD7 lea ecx, [ebp - 0x10]
00A73BDA push ecx
00A73BDB lea edx, [ebp - 8]
00A73BDE push edx
00A73BDF mov ecx, dword ptr [ebp - 0x1c]
00A73BE2 call 0x4377e0
00A73BE7 lea eax, [ebp - 0x18]
00A73BEA push eax
00A73BEB mov ecx, dword ptr [ebp - 0x1c]
00A73BEE call 0x45abb0
00A73BF3 push eax
00A73BF4 lea ecx, [ebp - 8]
00A73BF7 call 0x4ab8f0
00A73BFC movzx ecx, al
00A73BFF test ecx, ecx
00A73C01 je 0xa73c13
00A73C03 lea ecx, [ebp - 8]
00A73C06 call 0x4305b0
00A73C0B mov edx, dword ptr [eax + 4]
00A73C0E mov dword ptr [ebp - 0xc], edx
00A73C11 jmp 0xa73c17
00A73C13 xor eax, eax
00A73C15 jmp 0xa73c1a
00A73C17 mov eax, dword ptr [ebp - 0xc]
00A73C1A mov esp, ebp
00A73C1C pop ebp
00A73C1D ret 4

; range 0xa48d90
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
