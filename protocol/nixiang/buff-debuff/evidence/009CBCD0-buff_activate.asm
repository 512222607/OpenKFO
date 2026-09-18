009CBCD0  55                       push ebp
009CBCD1  8bec                     mov ebp, esp
009CBCD3  83ec2c                   sub esp, 0x2c
009CBCD6  56                       push esi
009CBCD7  57                       push edi
009CBCD8  894de4                   mov dword ptr [ebp - 0x1c], ecx
009CBCDB  8b45e4                   mov eax, dword ptr [ebp - 0x1c]
009CBCDE  c70001000000             mov dword ptr [eax], 1
009CBCE4  8b7508                   mov esi, dword ptr [ebp + 8]
009CBCE7  8b7de4                   mov edi, dword ptr [ebp - 0x1c]
009CBCEA  83c738                   add edi, 0x38
009CBCED  b908000000               mov ecx, 8
009CBCF2  f3a5                     rep movsd dword ptr es:[edi], dword ptr [esi]
009CBCF4  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBCF7  e8a4eeffff               call 0x9caba0
009CBCFC  85c0                     test eax, eax
009CBCFE  7510                     jne 0x9cbd10
009CBD00  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBD03  c70100000000             mov dword ptr [ecx], 0
009CBD09  33c0                     xor eax, eax
009CBD0B  e949010000               jmp 0x9cbe59
009CBD10  837d0c00                 cmp dword ptr [ebp + 0xc], 0
009CBD14  7418                     je 0x9cbd2e
009CBD16  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBD19  e852f1ffff               call 0x9cae70
009CBD1E  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBD21  e89af0ffff               call 0x9cadc0
009CBD26  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBD29  e8d2f6ffff               call 0x9cb400
009CBD2E  8b55e4                   mov edx, dword ptr [ebp - 0x1c]
009CBD31  837a1400                 cmp dword ptr [edx + 0x14], 0
009CBD35  751b                     jne 0x9cbd52
009CBD37  8b45e4                   mov eax, dword ptr [ebp - 0x1c]
009CBD3A  8b4808                   mov ecx, dword ptr [eax + 8]
009CBD3D  51                       push ecx
009CBD3E  6a01                     push 1
009CBD40  8b55e4                   mov edx, dword ptr [ebp - 0x1c]
009CBD43  8b4a58                   mov ecx, dword ptr [edx + 0x58]
009CBD46  e815b1a7ff               call 0x446e60
009CBD4B  8bc8                     mov ecx, eax
009CBD4D  e8de8bffff               call 0x9c4930
009CBD52  8b45e4                   mov eax, dword ptr [ebp - 0x1c]
009CBD55  83781c00                 cmp dword ptr [eax + 0x1c], 0
009CBD59  0f84dc000000             je 0x9cbe3b
009CBD5F  8b0d10877c01             mov ecx, dword ptr [0x17c8710]
009CBD65  e8e69efbff               call 0x985c50
009CBD6A  8bc8                     mov ecx, eax
009CBD6C  e86f850100               call 0x9e42e0
009CBD71  8b08                     mov ecx, dword ptr [eax]
009CBD73  894de8                   mov dword ptr [ebp - 0x18], ecx
009CBD76  8b5004                   mov edx, dword ptr [eax + 4]
009CBD79  8955ec                   mov dword ptr [ebp - 0x14], edx
009CBD7C  8b4008                   mov eax, dword ptr [eax + 8]
009CBD7F  8945f0                   mov dword ptr [ebp - 0x10], eax
009CBD82  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBD85  8b4958                   mov ecx, dword ptr [ecx + 0x58]
009CBD88  e853850100               call 0x9e42e0
009CBD8D  8b10                     mov edx, dword ptr [eax]
009CBD8F  8955f4                   mov dword ptr [ebp - 0xc], edx
009CBD92  8b4804                   mov ecx, dword ptr [eax + 4]
009CBD95  894df8                   mov dword ptr [ebp - 8], ecx
009CBD98  8b5008                   mov edx, dword ptr [eax + 8]
009CBD9B  8955fc                   mov dword ptr [ebp - 4], edx
009CBD9E  8b0df8867c01             mov ecx, dword ptr [0x17c86f8]
009CBDA4  e8d781a8ff               call 0x453f80
009CBDA9  85c0                     test eax, eax
009CBDAB  754b                     jne 0x9cbdf8
009CBDAD  8b0d10877c01             mov ecx, dword ptr [0x17c8710]
009CBDB3  e88897fbff               call 0x985540
009CBDB8  85c0                     test eax, eax
009CBDBA  743c                     je 0x9cbdf8
009CBDBC  8b0d10877c01             mov ecx, dword ptr [0x17c8710]
009CBDC2  e87997fbff               call 0x985540
009CBDC7  8bc8                     mov ecx, eax
009CBDC9  e86264fbff               call 0x982230
009CBDCE  85c0                     test eax, eax
009CBDD0  7426                     je 0x9cbdf8
009CBDD2  8b0d10877c01             mov ecx, dword ptr [0x17c8710]
009CBDD8  e86397fbff               call 0x985540
009CBDDD  8bc8                     mov ecx, eax
009CBDDF  e84c64fbff               call 0x982230
009CBDE4  8945e0                   mov dword ptr [ebp - 0x20], eax
009CBDE7  8d45e8                   lea eax, [ebp - 0x18]
009CBDEA  50                       push eax
009CBDEB  8b4de0                   mov ecx, dword ptr [ebp - 0x20]
009CBDEE  8b11                     mov edx, dword ptr [ecx]
009CBDF0  8b4de0                   mov ecx, dword ptr [ebp - 0x20]
009CBDF3  8b4230                   mov eax, dword ptr [edx + 0x30]
009CBDF6  ffd0                     call eax
009CBDF8  d945f0                   fld dword ptr [ebp - 0x10]
009CBDFB  d865fc                   fsub dword ptr [ebp - 4]
009CBDFE  d95ddc                   fstp dword ptr [ebp - 0x24]
009CBE01  d945dc                   fld dword ptr [ebp - 0x24]
009CBE04  51                       push ecx
009CBE05  d91c24                   fstp dword ptr [esp]
009CBE08  d945ec                   fld dword ptr [ebp - 0x14]
009CBE0B  d865f8                   fsub dword ptr [ebp - 8]
009CBE0E  d95dd8                   fstp dword ptr [ebp - 0x28]
009CBE11  d945d8                   fld dword ptr [ebp - 0x28]
009CBE14  51                       push ecx
009CBE15  d91c24                   fstp dword ptr [esp]
009CBE18  d945e8                   fld dword ptr [ebp - 0x18]
009CBE1B  d865f4                   fsub dword ptr [ebp - 0xc]
009CBE1E  d95dd4                   fstp dword ptr [ebp - 0x2c]
009CBE21  d945d4                   fld dword ptr [ebp - 0x2c]
009CBE24  51                       push ecx
009CBE25  d91c24                   fstp dword ptr [esp]
009CBE28  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBE2B  8b511c                   mov edx, dword ptr [ecx + 0x1c]
009CBE2E  52                       push edx
009CBE2F  e8ec74a3ff               call 0x403320
009CBE34  8bc8                     mov ecx, eax
009CBE36  e8e5df0900               call 0xa69e20
009CBE3B  8b4508                   mov eax, dword ptr [ebp + 8]
009CBE3E  83781c00                 cmp dword ptr [eax + 0x1c], 0
009CBE42  7410                     je 0x9cbe54
009CBE44  8b4d0c                   mov ecx, dword ptr [ebp + 0xc]
009CBE47  51                       push ecx
009CBE48  8b5508                   mov edx, dword ptr [ebp + 8]
009CBE4B  52                       push edx
009CBE4C  8b4de4                   mov ecx, dword ptr [ebp - 0x1c]
009CBE4F  e8fcfcffff               call 0x9cbb50
009CBE54  b801000000               mov eax, 1
009CBE59  5f                       pop edi
009CBE5A  5e                       pop esi
009CBE5B  8be5                     mov esp, ebp
009CBE5D  5d                       pop ebp
009CBE5E  c20800                   ret 8
