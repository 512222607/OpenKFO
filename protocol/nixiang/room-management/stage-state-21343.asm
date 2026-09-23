; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; range 0x924b80..0x924bc2
00924B80 push ebp
00924B81 mov ebp, esp
00924B83 sub esp, 8
00924B86 mov dword ptr [ebp - 4], ecx
00924B89 push 0
00924B8B push 0x535e
00924B90 call 0xa3ca00
00924B95 add esp, 8
00924B98 push 0
00924B9A call 0x41bdf0
00924B9F mov ecx, eax
00924BA1 call 0x7fdbc0
00924BA6 call 0x914c10
00924BAB mov dword ptr [ebp - 8], eax
00924BAE mov eax, dword ptr [ebp - 8]
00924BB1 mov edx, dword ptr [eax]
00924BB3 mov ecx, dword ptr [ebp - 8]
00924BB6 mov eax, dword ptr [edx + 0x108]
00924BBC call eax
00924BBE mov esp, ebp
00924BC0 pop ebp
00924BC1 ret
; range 0xaf4679..0xaf46e3
00AF4679 mov dword ptr [ebp - 0x8e0], 0xa27670
00AF4683 mov dword ptr [ebp - 0x8dc], 0
00AF468D mov dword ptr [ebp - 0x8d8], 0
00AF4697 mov dword ptr [ebp - 0x8d4], 0
00AF46A1 mov eax, dword ptr [ebp - 0x8e0]
00AF46A7 mov dword ptr [0x12fd130], eax
00AF46AC mov ecx, dword ptr [ebp - 0x8dc]
00AF46B2 mov dword ptr [0x12fd134], ecx
00AF46B8 mov edx, dword ptr [ebp - 0x8d8]
00AF46BE mov dword ptr [0x12fd138], edx
00AF46C4 mov eax, dword ptr [ebp - 0x8d4]
00AF46CA mov dword ptr [0x12fd13c], eax
00AF46CF mov dword ptr [0x12fd140], 0x535f
00AF46D9 mov dword ptr [0x12fd144], 1
; range 0xa27670..0xa276f6
00A27670 push ebp
00A27671 mov ebp, esp
00A27673 sub esp, 0x14
00A27676 mov dword ptr [ebp - 0x14], ecx
00A27679 cmp dword ptr [ebp + 8], 0
00A2767D je 0xa27685
00A2767F cmp dword ptr [ebp + 0xc], 8
00A27683 jae 0xa27687
00A27685 jmp 0xa276f0
00A27687 mov eax, dword ptr [ebp + 8]
00A2768A mov dword ptr [ebp - 0x10], eax
00A2768D mov ecx, dword ptr [ebp - 0x10]
00A27690 mov dword ptr [ebp - 4], ecx
00A27693 mov edx, dword ptr [ebp - 0x10]
00A27696 add edx, 8
00A27699 mov dword ptr [ebp - 0x10], edx
00A2769C mov eax, dword ptr [ebp - 4]
00A2769F mov ecx, dword ptr [eax]
00A276A1 imul ecx, ecx, 0xc
00A276A4 mov edx, dword ptr [ebp - 4]
00A276A7 mov eax, dword ptr [edx + 4]
00A276AA lea ecx, [ecx + eax*8 + 8]
00A276AE cmp dword ptr [ebp + 0xc], ecx
00A276B1 jae 0xa276b5
00A276B3 jmp 0xa276f0
00A276B5 mov edx, dword ptr [ebp - 0x10]
00A276B8 mov dword ptr [ebp - 8], edx
00A276BB mov eax, dword ptr [ebp - 4]
00A276BE mov ecx, dword ptr [eax]
00A276C0 imul ecx, ecx, 0xc
00A276C3 add ecx, dword ptr [ebp - 0x10]
00A276C6 mov dword ptr [ebp - 0x10], ecx
00A276C9 mov edx, dword ptr [ebp - 0x10]
00A276CC mov dword ptr [ebp - 0xc], edx
00A276CF mov eax, dword ptr [ebp - 4]
00A276D2 mov ecx, dword ptr [eax + 4]
00A276D5 push ecx
00A276D6 mov edx, dword ptr [ebp - 0xc]
00A276D9 push edx
00A276DA mov eax, dword ptr [ebp - 4]
00A276DD mov ecx, dword ptr [eax]
00A276DF push ecx
00A276E0 mov edx, dword ptr [ebp - 8]
00A276E3 push edx
00A276E4 call 0xa55020
00A276E9 mov ecx, eax
00A276EB call 0xa54f20
00A276F0 mov esp, ebp
00A276F2 pop ebp
00A276F3 ret 8
; range 0xa54f20..0xa54fa5
00A54F20 push ebp
00A54F21 mov ebp, esp
00A54F23 sub esp, 0xc
00A54F26 mov dword ptr [ebp - 0xc], ecx
00A54F29 mov ecx, dword ptr [ebp - 0xc]
00A54F2C add ecx, 4
00A54F2F call 0x4a4430
00A54F34 mov dword ptr [ebp - 4], 0
00A54F3B jmp 0xa54f46
00A54F3D mov eax, dword ptr [ebp - 4]
00A54F40 add eax, 1
00A54F43 mov dword ptr [ebp - 4], eax
00A54F46 mov ecx, dword ptr [ebp - 4]
00A54F49 cmp ecx, dword ptr [ebp + 0xc]
00A54F4C jge 0xa54f65
00A54F4E mov edx, dword ptr [ebp - 4]
00A54F51 imul edx, edx, 0xc
00A54F54 add edx, dword ptr [ebp + 8]
00A54F57 push edx
00A54F58 mov ecx, dword ptr [ebp - 0xc]
00A54F5B add ecx, 4
00A54F5E call 0x48e560
00A54F63 jmp 0xa54f3d
00A54F65 mov ecx, dword ptr [ebp - 0xc]
00A54F68 add ecx, 0x1c
00A54F6B call 0x45a410
00A54F70 mov dword ptr [ebp - 8], 0
00A54F77 jmp 0xa54f82
00A54F79 mov eax, dword ptr [ebp - 8]
00A54F7C add eax, 1
00A54F7F mov dword ptr [ebp - 8], eax
00A54F82 mov ecx, dword ptr [ebp - 8]
00A54F85 cmp ecx, dword ptr [ebp + 0x14]
00A54F88 jge 0xa54fa1
00A54F8A mov edx, dword ptr [ebp - 8]
00A54F8D mov eax, dword ptr [ebp + 0x10]
00A54F90 lea ecx, [eax + edx*8]
00A54F93 push ecx
00A54F94 mov ecx, dword ptr [ebp - 0xc]
00A54F97 add ecx, 0x1c
00A54F9A call 0x4ee110
00A54F9F jmp 0xa54f79
00A54FA1 mov esp, ebp
00A54FA3 pop ebp
