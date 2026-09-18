0065FEB0  55                       push ebp
0065FEB1  8bec                     mov ebp, esp
0065FEB3  83ec1c                   sub esp, 0x1c
0065FEB6  894dfc                   mov dword ptr [ebp - 4], ecx
0065FEB9  6830837b01               push 0x17b8330
0065FEBE  ff15f430b300             call dword ptr [0xb330f4]
0065FEC4  8b45fc                   mov eax, dword ptr [ebp - 4]
0065FEC7  8b0d30837b01             mov ecx, dword ptr [0x17b8330]
0065FECD  2b4808                   sub ecx, dword ptr [eax + 8]
0065FED0  8b1534837b01             mov edx, dword ptr [0x17b8334]
0065FED6  1b500c                   sbb edx, dword ptr [eax + 0xc]
0065FED9  894df4                   mov dword ptr [ebp - 0xc], ecx
0065FEDC  8955f8                   mov dword ptr [ebp - 8], edx
0065FEDF  df6df4                   fild qword ptr [ebp - 0xc]
0065FEE2  8b45fc                   mov eax, dword ptr [ebp - 4]
0065FEE5  dc30                     fdiv qword ptr [eax]
0065FEE7  d97df2                   fnstcw word ptr [ebp - 0xe]
0065FEEA  0fb745f2                 movzx eax, word ptr [ebp - 0xe]
0065FEEE  0d000c0000               or eax, 0xc00
0065FEF3  8945ec                   mov dword ptr [ebp - 0x14], eax
0065FEF6  d96dec                   fldcw word ptr [ebp - 0x14]
0065FEF9  df7de4                   fistp qword ptr [ebp - 0x1c]
0065FEFC  d96df2                   fldcw word ptr [ebp - 0xe]
0065FEFF  8b45e4                   mov eax, dword ptr [ebp - 0x1c]
0065FF02  8be5                     mov esp, ebp
0065FF04  5d                       pop ebp
0065FF05  c3                       ret
