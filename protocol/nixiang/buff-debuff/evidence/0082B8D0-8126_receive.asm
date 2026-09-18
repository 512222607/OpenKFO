0082B8D0  55                       push ebp
0082B8D1  8bec                     mov ebp, esp
0082B8D3  81ecac000000             sub esp, 0xac
0082B8D9  898d54ffffff             mov dword ptr [ebp - 0xac], ecx
0082B8DF  837d0800                 cmp dword ptr [ebp + 8], 0
0082B8E3  7406                     je 0x82b8eb
0082B8E5  837d0c47                 cmp dword ptr [ebp + 0xc], 0x47
0082B8E9  7305                     jae 0x82b8f0
0082B8EB  e912020000               jmp 0x82bb02
0082B8F0  8b4508                   mov eax, dword ptr [ebp + 8]
0082B8F3  8945f8                   mov dword ptr [ebp - 8], eax
0082B8F6  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082B8F9  8b513b                   mov edx, dword ptr [ecx + 0x3b]
0082B8FC  52                       push edx
0082B8FD  8b4137                   mov eax, dword ptr [ecx + 0x37]
0082B900  50                       push eax
0082B901  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082B907  e864d3feff               call 0x818c70
0082B90C  8945fc                   mov dword ptr [ebp - 4], eax
0082B90F  837dfc00                 cmp dword ptr [ebp - 4], 0
0082B913  7505                     jne 0x82b91a
0082B915  e9e8010000               jmp 0x82bb02
0082B91A  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082B91D  8b5133                   mov edx, dword ptr [ecx + 0x33]
0082B920  52                       push edx
0082B921  8b412f                   mov eax, dword ptr [ecx + 0x2f]
0082B924  50                       push eax
0082B925  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082B92B  e840d3feff               call 0x818c70
0082B930  8945f4                   mov dword ptr [ebp - 0xc], eax
0082B933  837df400                 cmp dword ptr [ebp - 0xc], 0
0082B937  7505                     jne 0x82b93e
0082B939  e9c4010000               jmp 0x82bb02
0082B93E  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082B941  e82ac31b00               call 0x9e7c70
0082B946  85c0                     test eax, eax
0082B948  0f84b4010000             je 0x82bb02
0082B94E  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082B951  e8ea56bdff               call 0x401040
0082B956  8bc8                     mov ecx, eax
0082B958  e8e38cc9ff               call 0x4c4640
0082B95D  8945ec                   mov dword ptr [ebp - 0x14], eax
0082B960  837dec00                 cmp dword ptr [ebp - 0x14], 0
0082B964  7424                     je 0x82b98a
0082B966  8d4de0                   lea ecx, [ebp - 0x20]
0082B969  e80285c2ff               call 0x453e70
0082B96E  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082B971  8b5143                   mov edx, dword ptr [ecx + 0x43]
0082B974  8955e4                   mov dword ptr [ebp - 0x1c], edx
0082B977  c745e800000000           mov dword ptr [ebp - 0x18], 0
0082B97E  8d45e0                   lea eax, [ebp - 0x20]
0082B981  50                       push eax
0082B982  8b4dec                   mov ecx, dword ptr [ebp - 0x14]
0082B985  e8866a1d00               call 0xa02410
0082B98A  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082B98D  8b513f                   mov edx, dword ptr [ecx + 0x3f]
0082B990  52                       push edx
0082B991  e85a792400               call 0xa732f0
0082B996  8bc8                     mov ecx, eax
0082B998  e883632400               call 0xa71d20
0082B99D  8945f0                   mov dword ptr [ebp - 0x10], eax
0082B9A0  837df000                 cmp dword ptr [ebp - 0x10], 0
0082B9A4  0f8458010000             je 0x82bb02
0082B9AA  8b45f0                   mov eax, dword ptr [ebp - 0x10]
0082B9AD  50                       push eax
0082B9AE  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082B9B1  51                       push ecx
0082B9B2  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0082B9B5  e8e60ac3ff               call 0x45c4a0
0082B9BA  8bc8                     mov ecx, eax
0082B9BC  e82fb62200               call 0xa56ff0
0082B9C1  c745dc00000000           mov dword ptr [ebp - 0x24], 0
0082B9C8  eb09                     jmp 0x82b9d3
0082B9CA  8b55dc                   mov edx, dword ptr [ebp - 0x24]
0082B9CD  83c201                   add edx, 1
0082B9D0  8955dc                   mov dword ptr [ebp - 0x24], edx
0082B9D3  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
0082B9D6  81c1b0000000             add ecx, 0xb0
0082B9DC  e8dfaebeff               call 0x4168c0
0082B9E1  3945dc                   cmp dword ptr [ebp - 0x24], eax
0082B9E4  0f8318010000             jae 0x82bb02
0082B9EA  8b45dc                   mov eax, dword ptr [ebp - 0x24]
0082B9ED  50                       push eax
0082B9EE  8b4df0                   mov ecx, dword ptr [ebp - 0x10]
0082B9F1  81c1b0000000             add ecx, 0xb0
0082B9F7  e8e4aebeff               call 0x4168e0
0082B9FC  8945b4                   mov dword ptr [ebp - 0x4c], eax
0082B9FF  8b4db4                   mov ecx, dword ptr [ebp - 0x4c]
0082BA02  8b5108                   mov edx, dword ptr [ecx + 8]
0082BA05  8955c0                   mov dword ptr [ebp - 0x40], edx
0082BA08  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082BA0B  e8f055bdff               call 0x401000
0082BA10  8945c8                   mov dword ptr [ebp - 0x38], eax
0082BA13  8955cc                   mov dword ptr [ebp - 0x34], edx
0082BA16  8b45b4                   mov eax, dword ptr [ebp - 0x4c]
0082BA19  8b4804                   mov ecx, dword ptr [eax + 4]
0082BA1C  894dbc                   mov dword ptr [ebp - 0x44], ecx
0082BA1F  c745d001000000           mov dword ptr [ebp - 0x30], 1
0082BA26  8b55b4                   mov edx, dword ptr [ebp - 0x4c]
0082BA29  8b02                     mov eax, dword ptr [edx]
0082BA2B  8945b8                   mov dword ptr [ebp - 0x48], eax
0082BA2E  c745d400000000           mov dword ptr [ebp - 0x2c], 0
0082BA35  6a01                     push 1
0082BA37  8d4db8                   lea ecx, [ebp - 0x48]
0082BA3A  51                       push ecx
0082BA3B  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082BA3E  e81db4c1ff               call 0x446e60
0082BA43  8bc8                     mov ecx, eax
0082BA45  e876af1900               call 0x9c69c0
0082BA4A  85c0                     test eax, eax
0082BA4C  0f84ab000000             je 0x82bafd
0082BA52  6a57                     push 0x57
0082BA54  6a00                     push 0
0082BA56  8d9558ffffff             lea edx, [ebp - 0xa8]
0082BA5C  52                       push edx
0082BA5D  e8feaee3ff               call 0x666960
0082BA62  83c40c                   add esp, 0xc
0082BA65  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082BA68  e89355bdff               call 0x401000
0082BA6D  89857fffffff             mov dword ptr [ebp - 0x81], eax
0082BA73  895583                   mov dword ptr [ebp - 0x7d], edx
0082BA76  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082BA79  e88255bdff               call 0x401000
0082BA7E  894587                   mov dword ptr [ebp - 0x79], eax
0082BA81  89558b                   mov dword ptr [ebp - 0x75], edx
0082BA84  d9ee                     fldz
0082BA86  d95d9b                   fstp dword ptr [ebp - 0x65]
0082BA89  c7459f00000000           mov dword ptr [ebp - 0x61], 0
0082BA90  8b45bc                   mov eax, dword ptr [ebp - 0x44]
0082BA93  894593                   mov dword ptr [ebp - 0x6d], eax
0082BA96  8b4db8                   mov ecx, dword ptr [ebp - 0x48]
0082BA99  894d8f                   mov dword ptr [ebp - 0x71], ecx
0082BA9C  8b55c0                   mov edx, dword ptr [ebp - 0x40]
0082BA9F  895597                   mov dword ptr [ebp - 0x69], edx
0082BAA2  c745a301000000           mov dword ptr [ebp - 0x5d], 1
0082BAA9  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082BAAF  e88c69c0ff               call 0x432440
0082BAB4  8b08                     mov ecx, dword ptr [eax]
0082BAB6  8b5004                   mov edx, dword ptr [eax + 4]
0082BAB9  894da7                   mov dword ptr [ebp - 0x59], ecx
0082BABC  8955ab                   mov dword ptr [ebp - 0x55], edx
0082BABF  6a00                     push 0
0082BAC1  6a00                     push 0
0082BAC3  6a57                     push 0x57
0082BAC5  8d8558ffffff             lea eax, [ebp - 0xa8]
0082BACB  50                       push eax
0082BACC  68d61f0000               push 0x1fd6
0082BAD1  e8da402100               call 0xa3fbb0
0082BAD6  83c414                   add esp, 0x14
0082BAD9  e8e275bdff               call 0x4030c0
0082BADE  8bc8                     mov ecx, eax
0082BAE0  e8bb76bdff               call 0x4031a0
0082BAE5  83f802                   cmp eax, 2
0082BAE8  7413                     je 0x82bafd
0082BAEA  8d8d58ffffff             lea ecx, [ebp - 0xa8]
0082BAF0  51                       push ecx
0082BAF1  e8ca75bdff               call 0x4030c0
0082BAF6  8bc8                     mov ecx, eax
0082BAF8  e863621000               call 0x931d60
0082BAFD  e9c8feffff               jmp 0x82b9ca
0082BB02  8be5                     mov esp, ebp
0082BB04  5d                       pop ebp
0082BB05  c20800                   ret 8
