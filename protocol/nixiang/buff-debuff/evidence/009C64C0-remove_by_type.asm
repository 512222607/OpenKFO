009C64C0  55                       push ebp
009C64C1  8bec                     mov ebp, esp
009C64C3  83ec14                   sub esp, 0x14
009C64C6  894dec                   mov dword ptr [ebp - 0x14], ecx
009C64C9  8d4508                   lea eax, [ebp + 8]
009C64CC  50                       push eax
009C64CD  8d4df8                   lea ecx, [ebp - 8]
009C64D0  51                       push ecx
009C64D1  8b4dec                   mov ecx, dword ptr [ebp - 0x14]
009C64D4  83c104                   add ecx, 4
009C64D7  e80413a7ff               call 0x4377e0
009C64DC  8d55f0                   lea edx, [ebp - 0x10]
009C64DF  52                       push edx
009C64E0  8b4dec                   mov ecx, dword ptr [ebp - 0x14]
009C64E3  83c104                   add ecx, 4
009C64E6  e8c546a9ff               call 0x45abb0
009C64EB  50                       push eax
009C64EC  8d4df8                   lea ecx, [ebp - 8]
009C64EF  e8fc53aeff               call 0x4ab8f0
009C64F4  0fb6c0                   movzx eax, al
009C64F7  85c0                     test eax, eax
009C64F9  745f                     je 0x9c655a
009C64FB  8d4df8                   lea ecx, [ebp - 8]
009C64FE  e8ada0a6ff               call 0x4305b0
009C6503  8b4804                   mov ecx, dword ptr [eax + 4]
009C6506  e845daa8ff               call 0x453f50
009C650B  85c0                     test eax, eax
009C650D  7421                     je 0x9c6530
009C650F  8d4df8                   lea ecx, [ebp - 8]
009C6512  e899a0a6ff               call 0x4305b0
009C6517  8b4804                   mov ecx, dword ptr [eax + 4]
009C651A  e851590000               call 0x9cbe70
009C651F  8b4dec                   mov ecx, dword ptr [ebp - 0x14]
009C6522  e829f2ffff               call 0x9c5750
009C6527  b801000000               mov eax, 1
009C652C  eb2e                     jmp 0x9c655c
009C652E  eb2a                     jmp 0x9c655a
009C6530  8b4dec                   mov ecx, dword ptr [ebp - 0x14]
009C6533  8b09                     mov ecx, dword ptr [ecx]
009C6535  e826cfa9ff               call 0x463460
009C653A  85c0                     test eax, eax
009C653C  741c                     je 0x9c655a
009C653E  8b5508                   mov edx, dword ptr [ebp + 8]
009C6541  52                       push edx
009C6542  8b45ec                   mov eax, dword ptr [ebp - 0x14]
009C6545  8b08                     mov ecx, dword ptr [eax]
009C6547  e814cfa9ff               call 0x463460
009C654C  8bc8                     mov ecx, eax
009C654E  e80d09a8ff               call 0x446e60
009C6553  8bc8                     mov ecx, eax
009C6555  e866ffffff               call 0x9c64c0
009C655A  33c0                     xor eax, eax
009C655C  8be5                     mov esp, ebp
009C655E  5d                       pop ebp
009C655F  c20400                   ret 4
