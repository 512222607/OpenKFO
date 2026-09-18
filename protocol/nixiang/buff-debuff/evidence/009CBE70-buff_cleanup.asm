009CBE70  55                       push ebp
009CBE71  8bec                     mov ebp, esp
009CBE73  51                       push ecx
009CBE74  894dfc                   mov dword ptr [ebp - 4], ecx
009CBE77  8b45fc                   mov eax, dword ptr [ebp - 4]
009CBE7A  c70000000000             mov dword ptr [eax], 0
009CBE80  8b4dfc                   mov ecx, dword ptr [ebp - 4]
009CBE83  e8e8efffff               call 0x9cae70
009CBE88  8b4dfc                   mov ecx, dword ptr [ebp - 4]
009CBE8B  e830efffff               call 0x9cadc0
009CBE90  8b4dfc                   mov ecx, dword ptr [ebp - 4]
009CBE93  e8a8ecffff               call 0x9cab40
009CBE98  6a20                     push 0x20
009CBE9A  6a00                     push 0
009CBE9C  8b4dfc                   mov ecx, dword ptr [ebp - 4]
009CBE9F  83c138                   add ecx, 0x38
009CBEA2  51                       push ecx
009CBEA3  e8b8aac9ff               call 0x666960
009CBEA8  83c40c                   add esp, 0xc
009CBEAB  8b55fc                   mov edx, dword ptr [ebp - 4]
009CBEAE  8b4a58                   mov ecx, dword ptr [edx + 0x58]
009CBEB1  e88a51a3ff               call 0x401040
009CBEB6  8bc8                     mov ecx, eax
009CBEB8  e8b33eb4ff               call 0x50fd70
009CBEBD  8bc8                     mov ecx, eax
009CBEBF  e86c90a5ff               call 0x424f30
009CBEC4  8138c70b0000             cmp dword ptr [eax], 0xbc7
009CBECA  7520                     jne 0x9cbeec
009CBECC  6a00                     push 0
009CBECE  68f3030000               push 0x3f3
009CBED3  8b45fc                   mov eax, dword ptr [ebp - 4]
009CBED6  8b4858                   mov ecx, dword ptr [eax + 0x58]
009CBED9  51                       push ecx
009CBEDA  8b55fc                   mov edx, dword ptr [ebp - 4]
009CBEDD  8b4a58                   mov ecx, dword ptr [edx + 0x58]
009CBEE0  e85b51a3ff               call 0x401040
009CBEE5  8bc8                     mov ecx, eax
009CBEE7  e8f41d0100               call 0x9ddce0
009CBEEC  8b45fc                   mov eax, dword ptr [ebp - 4]
009CBEEF  83781400                 cmp dword ptr [eax + 0x14], 0
009CBEF3  751b                     jne 0x9cbf10
009CBEF5  8b4dfc                   mov ecx, dword ptr [ebp - 4]
009CBEF8  8b5108                   mov edx, dword ptr [ecx + 8]
009CBEFB  52                       push edx
009CBEFC  6a00                     push 0
009CBEFE  8b45fc                   mov eax, dword ptr [ebp - 4]
009CBF01  8b4858                   mov ecx, dword ptr [eax + 0x58]
009CBF04  e857afa7ff               call 0x446e60
009CBF09  8bc8                     mov ecx, eax
009CBF0B  e8208affff               call 0x9c4930
009CBF10  8b4dfc                   mov ecx, dword ptr [ebp - 4]
009CBF13  8b4958                   mov ecx, dword ptr [ecx + 0x58]
009CBF16  e845afa7ff               call 0x446e60
009CBF1B  8bc8                     mov ecx, eax
009CBF1D  e86e89ffff               call 0x9c4890
009CBF22  8b55fc                   mov edx, dword ptr [ebp - 4]
009CBF25  8b4208                   mov eax, dword ptr [edx + 8]
009CBF28  50                       push eax
009CBF29  8b4dfc                   mov ecx, dword ptr [ebp - 4]
009CBF2C  8b4958                   mov ecx, dword ptr [ecx + 0x58]
009CBF2F  e8cc50a3ff               call 0x401000
009CBF34  52                       push edx
009CBF35  50                       push eax
009CBF36  8b55fc                   mov edx, dword ptr [ebp - 4]
009CBF39  8b4a58                   mov ecx, dword ptr [edx + 0x58]
009CBF3C  e81fafa7ff               call 0x446e60
009CBF41  8bc8                     mov ecx, eax
009CBF43  e8f895ffff               call 0x9c5540
009CBF48  8be5                     mov esp, ebp
009CBF4A  5d                       pop ebp
009CBF4B  c3                       ret
