; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; range 0x660ce0
00660CE0 push ebp
00660CE1 mov ebp, esp
00660CE3 push ecx
00660CE4 mov eax, dword ptr [ebp + 8]
00660CE7 mov dword ptr [ebp - 4], eax
00660CEA mov ecx, dword ptr [ebp - 4]
00660CED sub ecx, 0xc
00660CF0 mov dword ptr [ebp - 4], ecx
00660CF3 cmp dword ptr [ebp - 4], 0x40
00660CF7 ja 0x660d65
00660CF9 mov edx, dword ptr [ebp - 4]
00660CFC movzx eax, byte ptr [edx + 0x660da4]
00660D03 jmp dword ptr [eax*4 + 0x660d6c]
00660D0A mov eax, 4
00660D0F jmp 0x660d67
00660D11 mov eax, 3
00660D16 jmp 0x660d67
00660D18 mov eax, 7
00660D1D jmp 0x660d67
00660D1F mov eax, 2
00660D24 jmp 0x660d67
00660D26 mov eax, 6
00660D2B jmp 0x660d67
00660D2D mov eax, 5
00660D32 jmp 0x660d67
00660D34 mov eax, 8
00660D39 jmp 0x660d67
00660D3B mov eax, 0x20
00660D40 jmp 0x660d67
00660D42 mov eax, 0x23
00660D47 jmp 0x660d67
00660D49 mov eax, 0x24
00660D4E jmp 0x660d67
00660D50 mov eax, 0xa
00660D55 jmp 0x660d67
00660D57 mov eax, 0xb
00660D5C jmp 0x660d67
00660D5E mov eax, 0x2a
00660D63 jmp 0x660d67
00660D65 xor eax, eax
00660D67 mov esp, ebp
00660D69 pop ebp
00660D6A ret
; range 0x8b3919
008B3919 cmp dword ptr [eax], 0x1e
008B391C jne 0x8b3930
008B391E mov ecx, dword ptr [ebp - 0xe8]
008B3924 mov dword ptr [ecx + 0x630], 0x25
008B392E jmp 0x8b395c
008B3930 mov edx, dword ptr [ebp - 0x14]
008B3933 cmp dword ptr [edx], 0x32
008B3936 jne 0x8b394a
008B3938 mov eax, dword ptr [ebp - 0xe8]
008B393E mov dword ptr [eax + 0x630], 0x37
008B3948 jmp 0x8b395c
008B394A mov ecx, dword ptr [ebp - 0xe8]
008B3950 mov edx, dword ptr [ebp - 0x14]
008B3953 mov eax, dword ptr [edx + 0x10]
008B3956 mov dword ptr [ecx + 0x630], eax
008B395C mov ecx, dword ptr [ebp - 0x14]
008B395F mov edx, dword ptr [ecx + 8]
008B3962 push edx
008B3963 lea eax, [ebp - 0x5c]
008B3966 push eax
008B3967 mov ecx, dword ptr [0x17c86fc]
008B396D call 0x9cd840
; type31: index=9, target=00660D5E, returns 0x2A (42)