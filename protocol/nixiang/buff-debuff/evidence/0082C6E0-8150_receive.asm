0082C6E0  55                       push ebp
0082C6E1  8bec                     mov ebp, esp
0082C6E3  83ec34                   sub esp, 0x34
0082C6E6  894dcc                   mov dword ptr [ebp - 0x34], ecx
0082C6E9  837d0800                 cmp dword ptr [ebp + 8], 0
0082C6ED  7406                     je 0x82c6f5
0082C6EF  837d0c57                 cmp dword ptr [ebp + 0xc], 0x57
0082C6F3  7305                     jae 0x82c6fa
0082C6F5  e9dd010000               jmp 0x82c8d7
0082C6FA  8b4508                   mov eax, dword ptr [ebp + 8]
0082C6FD  8945f4                   mov dword ptr [ebp - 0xc], eax
0082C700  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0082C703  51                       push ecx
0082C704  8b0d10877c01             mov ecx, dword ptr [0x17c8710]
0082C70A  e8a1971500               call 0x985eb0
0082C70F  85c0                     test eax, eax
0082C711  7505                     jne 0x82c718
0082C713  e9bf010000               jmp 0x82c8d7
0082C718  8b55f4                   mov edx, dword ptr [ebp - 0xc]
0082C71B  83c24f                   add edx, 0x4f
0082C71E  52                       push edx
0082C71F  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082C725  e896b3feff               call 0x817ac0
0082C72A  85c0                     test eax, eax
0082C72C  7505                     jne 0x82c733
0082C72E  e9a4010000               jmp 0x82c8d7
0082C733  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0082C736  8b482b                   mov ecx, dword ptr [eax + 0x2b]
0082C739  51                       push ecx
0082C73A  8b5027                   mov edx, dword ptr [eax + 0x27]
0082C73D  52                       push edx
0082C73E  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082C744  e827c5feff               call 0x818c70
0082C749  8945f8                   mov dword ptr [ebp - 8], eax
0082C74C  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0082C74F  8b4833                   mov ecx, dword ptr [eax + 0x33]
0082C752  51                       push ecx
0082C753  8b502f                   mov edx, dword ptr [eax + 0x2f]
0082C756  52                       push edx
0082C757  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
0082C75D  e80ec5feff               call 0x818c70
0082C762  8945fc                   mov dword ptr [ebp - 4], eax
0082C765  837df800                 cmp dword ptr [ebp - 8], 0
0082C769  0f8468010000             je 0x82c8d7
0082C76F  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0082C772  83784b01                 cmp dword ptr [eax + 0x4b], 1
0082C776  0f85e0000000             jne 0x82c85c
0082C77C  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0082C77F  8b513f                   mov edx, dword ptr [ecx + 0x3f]
0082C782  8955d8                   mov dword ptr [ebp - 0x28], edx
0082C785  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0082C788  8b482f                   mov ecx, dword ptr [eax + 0x2f]
0082C78B  894de0                   mov dword ptr [ebp - 0x20], ecx
0082C78E  8b5033                   mov edx, dword ptr [eax + 0x33]
0082C791  8955e4                   mov dword ptr [ebp - 0x1c], edx
0082C794  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0082C797  8b483b                   mov ecx, dword ptr [eax + 0x3b]
0082C79A  894dd4                   mov dword ptr [ebp - 0x2c], ecx
0082C79D  c745e801000000           mov dword ptr [ebp - 0x18], 1
0082C7A4  8b55f4                   mov edx, dword ptr [ebp - 0xc]
0082C7A7  8b4237                   mov eax, dword ptr [edx + 0x37]
0082C7AA  8945d0                   mov dword ptr [ebp - 0x30], eax
0082C7AD  c745ec00000000           mov dword ptr [ebp - 0x14], 0
0082C7B4  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C7B7  e864a6c1ff               call 0x446e20
0082C7BC  85c0                     test eax, eax
0082C7BE  7414                     je 0x82c7d4
0082C7C0  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C7C3  e858a6c1ff               call 0x446e20
0082C7C8  8bc8                     mov ecx, eax
0082C7CA  e8a175c2ff               call 0x453d70
0082C7CF  8945ec                   mov dword ptr [ebp - 0x14], eax
0082C7D2  eb07                     jmp 0x82c7db
0082C7D4  c745ec00000000           mov dword ptr [ebp - 0x14], 0
0082C7DB  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C7DE  e87d6cc3ff               call 0x463460
0082C7E3  85c0                     test eax, eax
0082C7E5  7429                     je 0x82c810
0082C7E7  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0082C7EA  8379370c                 cmp dword ptr [ecx + 0x37], 0xc
0082C7EE  7520                     jne 0x82c810
0082C7F0  6a00                     push 0
0082C7F2  8d55d0                   lea edx, [ebp - 0x30]
0082C7F5  52                       push edx
0082C7F6  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C7F9  e862a6c1ff               call 0x446e60
0082C7FE  8bc8                     mov ecx, eax
0082C800  e8bba11900               call 0x9c69c0
0082C805  85c0                     test eax, eax
0082C807  7505                     jne 0x82c80e
0082C809  e9c9000000               jmp 0x82c8d7
0082C80E  eb1e                     jmp 0x82c82e
0082C810  6a01                     push 1
0082C812  8d45d0                   lea eax, [ebp - 0x30]
0082C815  50                       push eax
0082C816  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C819  e842a6c1ff               call 0x446e60
0082C81E  8bc8                     mov ecx, eax
0082C820  e89ba11900               call 0x9c69c0
0082C825  85c0                     test eax, eax
0082C827  7505                     jne 0x82c82e
0082C829  e9a9000000               jmp 0x82c8d7
0082C82E  8d4dd0                   lea ecx, [ebp - 0x30]
0082C831  51                       push ecx
0082C832  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C835  e826a6c1ff               call 0x446e60
0082C83A  8bc8                     mov ecx, eax
0082C83C  e83f8d1900               call 0x9c5580
0082C841  837dfc00                 cmp dword ptr [ebp - 4], 0
0082C845  7413                     je 0x82c85a
0082C847  8b55f4                   mov edx, dword ptr [ebp - 0xc]
0082C84A  8b4237                   mov eax, dword ptr [edx + 0x37]
0082C84D  50                       push eax
0082C84E  8b4dfc                   mov ecx, dword ptr [ebp - 4]
0082C851  51                       push ecx
0082C852  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C855  e826ac1b00               call 0x9e7480
0082C85A  eb5a                     jmp 0x82c8b6
0082C85C  8b55f4                   mov edx, dword ptr [ebp - 0xc]
0082C85F  837a4b00                 cmp dword ptr [edx + 0x4b], 0
0082C863  7551                     jne 0x82c8b6
0082C865  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0082C868  8378370d                 cmp dword ptr [eax + 0x37], 0xd
0082C86C  7532                     jne 0x82c8a0
0082C86E  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C871  e83a7d1b00               call 0x9e45b0
0082C876  dc1d6883be00             fcomp qword ptr [0xbe8368]
0082C87C  dfe0                     fnstsw ax
0082C87E  f6c441                   test ah, 0x41
0082C881  751d                     jne 0x82c8a0
0082C883  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C886  e8d5a5c1ff               call 0x446e60
0082C88B  8bc8                     mov ecx, eax
0082C88D  e85e9d1900               call 0x9c65f0
0082C892  6a00                     push 0
0082C894  6aff                     push -1
0082C896  6a00                     push 0
0082C898  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C89B  e890e71c00               call 0x9fb030
0082C8A0  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0082C8A3  8b5137                   mov edx, dword ptr [ecx + 0x37]
0082C8A6  52                       push edx
0082C8A7  8b4df8                   mov ecx, dword ptr [ebp - 8]
0082C8AA  e8b1a5c1ff               call 0x446e60
0082C8AF  8bc8                     mov ecx, eax
0082C8B1  e80a9c1900               call 0x9c64c0
0082C8B6  e80568bdff               call 0x4030c0
0082C8BB  8bc8                     mov ecx, eax
0082C8BD  e8de68bdff               call 0x4031a0
0082C8C2  83f802                   cmp eax, 2
0082C8C5  7410                     je 0x82c8d7
0082C8C7  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0082C8CA  50                       push eax
0082C8CB  e8f067bdff               call 0x4030c0
0082C8D0  8bc8                     mov ecx, eax
0082C8D2  e889541000               call 0x931d60
0082C8D7  8be5                     mov esp, ebp
0082C8D9  5d                       pop ebp
0082C8DA  c20800                   ret 8
