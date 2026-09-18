0065FE70  55                       push ebp
0065FE71  8bec                     mov ebp, esp
0065FE73  83ec0c                   sub esp, 0xc
0065FE76  894df4                   mov dword ptr [ebp - 0xc], ecx
0065FE79  8d45f8                   lea eax, [ebp - 8]
0065FE7C  50                       push eax
0065FE7D  ff15f830b300             call dword ptr [0xb330f8]
0065FE83  df6df8                   fild qword ptr [ebp - 8]
0065FE86  dc35d083be00             fdiv qword ptr [0xbe83d0]
0065FE8C  8b4df4                   mov ecx, dword ptr [ebp - 0xc]
0065FE8F  dd19                     fstp qword ptr [ecx]
0065FE91  8b55f4                   mov edx, dword ptr [ebp - 0xc]
0065FE94  83c208                   add edx, 8
0065FE97  52                       push edx
0065FE98  ff15f430b300             call dword ptr [0xb330f4]
0065FE9E  8b45f4                   mov eax, dword ptr [ebp - 0xc]
0065FEA1  8be5                     mov esp, ebp
0065FEA3  5d                       pop ebp
0065FEA4  c3                       ret
