0044B3F0  55                       push ebp
0044B3F1  8bec                     mov ebp, esp
0044B3F3  51                       push ecx
0044B3F4  894dfc                   mov dword ptr [ebp - 4], ecx
0044B3F7  8b45fc                   mov eax, dword ptr [ebp - 4]
0044B3FA  8b80741b0000             mov eax, dword ptr [eax + 0x1b74]
0044B400  8be5                     mov esp, ebp
0044B402  5d                       pop ebp
0044B403  c3                       ret
