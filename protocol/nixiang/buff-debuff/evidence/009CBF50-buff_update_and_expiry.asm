009CBF50  55                       push ebp
009CBF51  8bec                     mov ebp, esp
009CBF53  83ec38                   sub esp, 0x38
009CBF56  894dcc                   mov dword ptr [ebp - 0x34], ecx
009CBF59  8b45cc                   mov eax, dword ptr [ebp - 0x34]
009CBF5C  8b4858                   mov ecx, dword ptr [eax + 0x58]
009CBF5F  e8dc50a3ff               call 0x401040
009CBF64  8bc8                     mov ecx, eax
009CBF66  e8053eb4ff               call 0x50fd70
009CBF6B  8bc8                     mov ecx, eax
009CBF6D  e8be8fa5ff               call 0x424f30
009CBF72  8b08                     mov ecx, dword ptr [eax]
009CBF74  894dfc                   mov dword ptr [ebp - 4], ecx
009CBF77  c745f800000000           mov dword ptr [ebp - 8], 0
009CBF7E  eb09                     jmp 0x9cbf89
009CBF80  8b55f8                   mov edx, dword ptr [ebp - 8]
009CBF83  83c201                   add edx, 1
009CBF86  8955f8                   mov dword ptr [ebp - 8], edx
009CBF89  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CBF8C  83c174                   add ecx, 0x74
009CBF8F  e86c30b9ff               call 0x55f000
009CBF94  3945f8                   cmp dword ptr [ebp - 8], eax
009CBF97  7323                     jae 0x9cbfbc
009CBF99  8b45f8                   mov eax, dword ptr [ebp - 8]
009CBF9C  50                       push eax
009CBF9D  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CBFA0  83c174                   add ecx, 0x74
009CBFA3  e89856acff               call 0x491640
009CBFA8  8b08                     mov ecx, dword ptr [eax]
009CBFAA  894dc8                   mov dword ptr [ebp - 0x38], ecx
009CBFAD  8b55c8                   mov edx, dword ptr [ebp - 0x38]
009CBFB0  8b02                     mov eax, dword ptr [edx]
009CBFB2  8b4dc8                   mov ecx, dword ptr [ebp - 0x38]
009CBFB5  8b5010                   mov edx, dword ptr [eax + 0x10]
009CBFB8  ffd2                     call edx
009CBFBA  ebc4                     jmp 0x9cbf80
009CBFBC  8b45cc                   mov eax, dword ptr [ebp - 0x34]
009CBFBF  8b4858                   mov ecx, dword ptr [eax + 0x58]
009CBFC2  e869da0100               call 0x9e9a30
009CBFC7  85c0                     test eax, eax
009CBFC9  7458                     je 0x9cc023
009CBFCB  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CBFCE  8b4958                   mov ecx, dword ptr [ecx + 0x58]
009CBFD1  e8da850100               call 0x9e45b0
009CBFD6  dc1d6883be00             fcomp qword ptr [0xbe8368]
009CBFDC  dfe0                     fnstsw ax
009CBFDE  f6c441                   test ah, 0x41
009CBFE1  7a40                     jp 0x9cc023
009CBFE3  817dfcb80b0000           cmp dword ptr [ebp - 4], 0xbb8
009CBFEA  7609                     jbe 0x9cbff5
009CBFEC  817dfcc80b0000           cmp dword ptr [ebp - 4], 0xbc8
009CBFF3  722e                     jb 0x9cc023
009CBFF5  817dfca10f0000           cmp dword ptr [ebp - 4], 0xfa1
009CBFFC  7425                     je 0x9cc023
009CBFFE  8b55cc                   mov edx, dword ptr [ebp - 0x34]
009CC001  8b4218                   mov eax, dword ptr [edx + 0x18]
009CC004  50                       push eax
009CC005  68c40b0000               push 0xbc4
009CC00A  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC00D  8b5158                   mov edx, dword ptr [ecx + 0x58]
009CC010  52                       push edx
009CC011  8b45cc                   mov eax, dword ptr [ebp - 0x34]
009CC014  8b4858                   mov ecx, dword ptr [eax + 0x58]
009CC017  e82450a3ff               call 0x401040
009CC01C  8bc8                     mov ecx, eax
009CC01E  e8bd1c0100               call 0x9ddce0
009CC023  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
009CC029  e8f2d0e4ff               call 0x819120
009CC02E  85c0                     test eax, eax
009CC030  7438                     je 0x9cc06a
009CC032  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
009CC038  e8e3d0e4ff               call 0x819120
009CC03D  8bc8                     mov ecx, eax
009CC03F  e8acf3a7ff               call 0x44b3f0
009CC044  85c0                     test eax, eax
009CC046  7422                     je 0x9cc06a
009CC048  8b0d10877c01             mov ecx, dword ptr [0x17c8710]
009CC04E  e87d9bfbff               call 0x985bd0
009CC053  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC056  3b4140                   cmp eax, dword ptr [ecx + 0x40]
009CC059  720f                     jb 0x9cc06a
009CC05B  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC05E  e80dfeffff               call 0x9cbe70
009CC063  33c0                     xor eax, eax
009CC065  e905010000               jmp 0x9cc16f
009CC06A  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
009CC070  e8abd0e4ff               call 0x819120
009CC075  85c0                     test eax, eax
009CC077  0f84ed000000             je 0x9cc16a
009CC07D  8b0d08877c01             mov ecx, dword ptr [0x17c8708]
009CC083  e898d0e4ff               call 0x819120
009CC088  8bc8                     mov ecx, eax
009CC08A  e8a1d90100               call 0x9e9a30
009CC08F  85c0                     test eax, eax
009CC091  0f84d3000000             je 0x9cc16a
009CC097  8b55cc                   mov edx, dword ptr [ebp - 0x34]
009CC09A  8b82c8000000             mov eax, dword ptr [edx + 0xc8]
009CC0A0  83787000                 cmp dword ptr [eax + 0x70], 0
009CC0A4  0f8ec0000000             jle 0x9cc16a
009CC0AA  d9059cd92e01             fld dword ptr [0x12ed99c]
009CC0B0  dc0dd083be00             fmul qword ptr [0xbe83d0]
009CC0B6  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC0B9  da81cc000000             fiadd dword ptr [ecx + 0xcc]
009CC0BF  e86c23caff               call 0x66e430
009CC0C4  8b55cc                   mov edx, dword ptr [ebp - 0x34]
009CC0C7  8982cc000000             mov dword ptr [edx + 0xcc], eax
009CC0CD  8b45cc                   mov eax, dword ptr [ebp - 0x34]
009CC0D0  8b88c8000000             mov ecx, dword ptr [eax + 0xc8]
009CC0D6  8b55cc                   mov edx, dword ptr [ebp - 0x34]
009CC0D9  8b82cc000000             mov eax, dword ptr [edx + 0xcc]
009CC0DF  3b4170                   cmp eax, dword ptr [ecx + 0x70]
009CC0E2  0f8e82000000             jle 0x9cc16a
009CC0E8  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC0EB  8b4958                   mov ecx, dword ptr [ecx + 0x58]
009CC0EE  e80d4fa3ff               call 0x401000
009CC0F3  8945e0                   mov dword ptr [ebp - 0x20], eax
009CC0F6  8955e4                   mov dword ptr [ebp - 0x1c], edx
009CC0F9  8b55cc                   mov edx, dword ptr [ebp - 0x34]
009CC0FC  8b4248                   mov eax, dword ptr [edx + 0x48]
009CC0FF  8945e8                   mov dword ptr [ebp - 0x18], eax
009CC102  8b4a4c                   mov ecx, dword ptr [edx + 0x4c]
009CC105  894dec                   mov dword ptr [ebp - 0x14], ecx
009CC108  8b55cc                   mov edx, dword ptr [ebp - 0x34]
009CC10B  8b4238                   mov eax, dword ptr [edx + 0x38]
009CC10E  8945d0                   mov dword ptr [ebp - 0x30], eax
009CC111  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC114  8b513c                   mov edx, dword ptr [ecx + 0x3c]
009CC117  8955d4                   mov dword ptr [ebp - 0x2c], edx
009CC11A  8b45cc                   mov eax, dword ptr [ebp - 0x34]
009CC11D  8b4850                   mov ecx, dword ptr [eax + 0x50]
009CC120  894ddc                   mov dword ptr [ebp - 0x24], ecx
009CC123  8b55cc                   mov edx, dword ptr [ebp - 0x34]
009CC126  8b4240                   mov eax, dword ptr [edx + 0x40]
009CC129  8945d8                   mov dword ptr [ebp - 0x28], eax
009CC12C  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC12F  8b91d0000000             mov edx, dword ptr [ecx + 0xd0]
009CC135  8955f0                   mov dword ptr [ebp - 0x10], edx
009CC138  8d45d0                   lea eax, [ebp - 0x30]
009CC13B  50                       push eax
009CC13C  e8df70a3ff               call 0x403220
009CC141  8bc8                     mov ecx, eax
009CC143  e8a82bf7ff               call 0x93ecf0
009CC148  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC14B  8b91d0000000             mov edx, dword ptr [ecx + 0xd0]
009CC151  83c201                   add edx, 1
009CC154  8b45cc                   mov eax, dword ptr [ebp - 0x34]
009CC157  8990d0000000             mov dword ptr [eax + 0xd0], edx
009CC15D  8b4dcc                   mov ecx, dword ptr [ebp - 0x34]
009CC160  c781cc00000000000000     mov dword ptr [ecx + 0xcc], 0
009CC16A  b801000000               mov eax, 1
009CC16F  8be5                     mov esp, ebp
009CC171  5d                       pop ebp
009CC172  c3                       ret
