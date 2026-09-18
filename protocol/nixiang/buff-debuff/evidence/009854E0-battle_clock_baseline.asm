009854E0  55                       push ebp
009854E1  8bec                     mov ebp, esp
009854E3  51                       push ecx
009854E4  894dfc                   mov dword ptr [ebp - 4], ecx
009854E7  8b45fc                   mov eax, dword ptr [ebp - 4]
009854EA  8b0d90867c01             mov ecx, dword ptr [0x17c8690]
009854F0  898888000000             mov dword ptr [eax + 0x88], ecx
009854F6  8b55fc                   mov edx, dword ptr [ebp - 4]
009854F9  a190867c01               mov eax, dword ptr [0x17c8690]
009854FE  898280000000             mov dword ptr [edx + 0x80], eax
00985504  8b4dfc                   mov ecx, dword ptr [ebp - 4]
00985507  8b1590867c01             mov edx, dword ptr [0x17c8690]
0098550D  899110010000             mov dword ptr [ecx + 0x110], edx
00985513  8be5                     mov esp, ebp
00985515  5d                       pop ebp
00985516  c3                       ret
