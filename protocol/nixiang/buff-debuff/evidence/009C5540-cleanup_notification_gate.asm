009C5540  55                       push ebp
009C5541  8bec                     mov ebp, esp
009C5543  51                       push ecx
009C5544  894dfc                   mov dword ptr [ebp - 4], ecx
009C5547  8b45fc                   mov eax, dword ptr [ebp - 4]
009C554A  8b08                     mov ecx, dword ptr [eax]
009C554C  e8df440200               call 0x9e9a30
009C5551  85c0                     test eax, eax
009C5553  7502                     jne 0x9c5557
009C5555  eb18                     jmp 0x9c556f
009C5557  8b4d10                   mov ecx, dword ptr [ebp + 0x10]
009C555A  51                       push ecx
009C555B  8b550c                   mov edx, dword ptr [ebp + 0xc]
009C555E  52                       push edx
009C555F  8b4508                   mov eax, dword ptr [ebp + 8]
009C5562  50                       push eax
009C5563  e8b8dca3ff               call 0x403220
009C5568  8bc8                     mov ecx, eax
009C556A  e8419af7ff               call 0x93efb0
009C556F  8be5                     mov esp, ebp
009C5571  5d                       pop ebp
009C5572  c20c00                   ret 0xc
