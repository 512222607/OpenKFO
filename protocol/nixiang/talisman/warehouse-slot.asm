; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; current PE addresses; type 30 warehouse slot 37 and normal equip call
008B3890 push ebp
008B3891 mov ebp, esp
008B3893 push -1
008B3895 push 0xadc945
008B389A mov eax, dword ptr fs:[0]
008B38A0 push eax
008B38A1 sub esp, 0xe8
008B38A7 mov eax, dword ptr [0xc7b480]
008B38AC xor eax, ebp
008B38AE mov dword ptr [ebp - 0x6c], eax
008B38B1 push esi
008B38B2 push edi
008B38B3 push eax
008B38B4 lea eax, [ebp - 0xc]
008B38B7 mov dword ptr fs:[0], eax
008B38BD mov dword ptr [ebp - 0xe8], ecx
008B38C3 mov eax, dword ptr [ebp - 0xe8]
008B38C9 mov ecx, dword ptr [eax + 0x650]
008B38CF sub ecx, 1
008B38D2 imul ecx, ecx, 0x18
008B38D5 mov edx, dword ptr [ebp - 0xe8]
008B38DB add ecx, dword ptr [edx + 0x634]
008B38E1 mov dword ptr [ebp - 0x10], ecx
008B38E4 mov eax, dword ptr [ebp - 0x10]
008B38E7 push eax
008B38E8 mov ecx, dword ptr [ebp - 0xe8]
008B38EE add ecx, 0x594
008B38F4 call 0x506880
008B38F9 mov dword ptr [ebp - 0x14], eax
008B38FC mov ecx, dword ptr [ebp - 0x14]
008B38FF cmp dword ptr [ecx], 0x40
008B3902 jne 0x8b3916
008B3904 mov edx, dword ptr [ebp - 0xe8]
008B390A mov dword ptr [edx + 0x630], 0x1b
008B3914 jmp 0x8b395c
008B3916 mov eax, dword ptr [ebp - 0x14]
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
008B3972 cmp dword ptr [ebp - 0x5c], 0
008B3976 je 0x8b39ed
008B3978 mov ecx, dword ptr [ebp - 0x57]
008B397B push ecx
008B397C call 0x41c190
008B3981 mov ecx, eax
008B3983 call 0xa76830
008B3988 mov dword ptr [ebp - 0x60], eax
008B398B cmp dword ptr [ebp - 0x60], 0
008B398F je 0x8b39c2
008B3991 push 0xba2bb8
008B3996 mov edx, dword ptr [ebp - 0x60]
008B3999 push edx
008B399A call 0x41b3e0
008B399F add esp, 8
008B39A2 movzx eax, al
008B39A5 test eax, eax
008B39A7 je 0x8b39c2
008B39A9 mov ecx, dword ptr [ebp - 0xe8]
008B39AF mov edx, dword ptr [ecx + 0x578]
008B39B5 push edx
008B39B6 call 0x7eb9b0
008B39BB mov ecx, eax
008B39BD call 0x7eac30
008B39C2 sub esp, 0x44
008B39C5 mov ecx, 0x11
008B39CA lea esi, [ebp - 0x5c]
008B39CD mov edi, esp
008B39CF rep movsd dword ptr es:[edi], dword ptr [esi]
008B39D1 call 0x9cc460
008B39D6 mov ecx, eax
008B39D8 call 0x9cc840
008B39DD mov byte ptr [ebp - 0x61], al
008B39E0 movzx eax, byte ptr [ebp - 0x61]
008B39E4 test eax, eax
008B39E6 je 0x8b39ed
008B39E8 jmp 0x8b3cc8
008B39ED mov ecx, dword ptr [ebp - 0x14]
008B39F0 cmp dword ptr [ecx], 0x49
008B39F3 jne 0x8b3b42
008B39F9 lea ecx, [ebp - 0x68]
008B39FC call 0x405f90
008B3A01 mov dword ptr [ebp - 4], 0
008B3A08 mov ecx, dword ptr [ebp - 0x14]
008B3A0B add ecx, 0x40
008B3A0E call 0x405750
008B3A13 push eax
008B3A14 push 0xbbd634
008B3A19 lea edx, [ebp - 0x68]
008B3A1C push edx
008B3A1D call 0x411c60
008B3A22 add esp, 0xc
008B3A25 mov eax, dword ptr [ebp - 0xe8]
008B3A2B mov ecx, dword ptr [ebp - 0x10]
008B3A2E mov dword ptr [eax + 0x648], ecx
008B3A34 mov dword ptr [ebp - 0x98], 0
008B3A3E mov dword ptr [ebp - 0x94], 0
008B3A48 mov dword ptr [ebp - 0x90], 0
008B3A52 mov dword ptr [ebp - 0x8c], 0xffffffff
008B3A5C mov dword ptr [ebp - 0xa8], 0x8afa90
008B3A66 mov dword ptr [ebp - 0xa4], 0
008B3A70 mov dword ptr [ebp - 0xa0], 0
008B3A7A mov dword ptr [ebp - 0x9c], 0
008B3A84 lea ecx, [ebp - 0x68]
008B3A87 call 0x406410
008B3A8C push eax
008B3A8D lea ecx, [ebp - 0xc4]
008B3A93 call 0x405650
008B3A98 mov byte ptr [ebp - 4], 1
008B3A9C call 0x403820
008B3AA1 mov dword ptr [ebp - 0xec], eax
008B3AA7 push 0
008B3AA9 sub esp, 0x10
008B3AAC mov edx, esp
008B3AAE mov eax, dword ptr [ebp - 0x98]
008B3AB4 mov dword ptr [edx], eax
008B3AB6 mov ecx, dword ptr [ebp - 0x94]
008B3ABC mov dword ptr [edx + 4], ecx
008B3ABF mov eax, dword ptr [ebp - 0x90]
008B3AC5 mov dword ptr [edx + 8], eax
008B3AC8 mov ecx, dword ptr [ebp - 0x8c]
008B3ACE mov dword ptr [edx + 0xc], ecx
008B3AD1 sub esp, 0x10
008B3AD4 mov edx, esp
008B3AD6 mov eax, dword ptr [ebp - 0xa8]
008B3ADC mov dword ptr [edx], eax
008B3ADE mov ecx, dword ptr [ebp - 0xa4]
008B3AE4 mov dword ptr [edx + 4], ecx
008B3AE7 mov eax, dword ptr [ebp - 0xa0]
008B3AED mov dword ptr [edx + 8], eax
008B3AF0 mov ecx, dword ptr [ebp - 0x9c]
008B3AF6 mov dword ptr [edx + 0xc], ecx
008B3AF9 mov edx, dword ptr [ebp - 0xe8]
008B3AFF push edx
008B3B00 push 1
008B3B02 lea eax, [ebp - 0xc4]
008B3B08 push eax
008B3B09 mov ecx, dword ptr [ebp - 0xec]
008B3B0F mov edx, dword ptr [ecx]
008B3B11 mov ecx, dword ptr [ebp - 0xec]
008B3B17 mov eax, dword ptr [edx + 0x1b8]
008B3B1D call eax
008B3B1F mov byte ptr [ebp - 4], 0
008B3B23 lea ecx, [ebp - 0xc4]
008B3B29 call 0x4056d0
008B3B2E mov dword ptr [ebp - 4], 0xffffffff
008B3B35 lea ecx, [ebp - 0x68]
008B3B38 call 0x406050
008B3B3D jmp 0x8b3cc8
008B3B42 mov ecx, dword ptr [ebp - 0x14]
008B3B45 cmp dword ptr [ecx], 0x32
008B3B48 jne 0x8b3cb9
008B3B4E cmp dword ptr [ebp - 0x14], 0
008B3B52 jne 0x8b3b59
008B3B54 jmp 0x8b3cc8
008B3B59 mov ecx, dword ptr [0x17c86fc]
008B3B5F call 0x9cd390
008B3B64 cmp dword ptr [eax + 0x15c], 0
008B3B6B ja 0x8b3b85
008B3B6D mov ecx, dword ptr [0x17c86fc]
008B3B73 call 0x9cd390
008B3B78 cmp dword ptr [eax + 0x160], 0
008B3B7F jbe 0x8b3c83
008B3B85 push 0xbbd660
008B3B8A lea ecx, [ebp - 0x88]
008B3B90 call 0x405650
008B3B95 mov dword ptr [ebp - 4], 2
008B3B9C mov dword ptr [ebp - 0xd4], 0
008B3BA6 mov dword ptr [ebp - 0xd0], 0
008B3BB0 mov dword ptr [ebp - 0xcc], 0
008B3BBA mov dword ptr [ebp - 0xc8], 0xffffffff
008B3BC4 mov dword ptr [ebp - 0xe4], 0
008B3BCE mov dword ptr [ebp - 0xe0], 0
008B3BD8 mov dword ptr [ebp - 0xdc], 0
008B3BE2 mov dword ptr [ebp - 0xd8], 0xffffffff
008B3BEC call 0x403820
008B3BF1 mov dword ptr [ebp - 0xf0], eax
008B3BF7 push 0
008B3BF9 sub esp, 0x10
008B3BFC mov edx, esp
008B3BFE mov eax, dword ptr [ebp - 0xd4]
008B3C04 mov dword ptr [edx], eax
008B3C06 mov ecx, dword ptr [ebp - 0xd0]
008B3C0C mov dword ptr [edx + 4], ecx
008B3C0F mov eax, dword ptr [ebp - 0xcc]
008B3C15 mov dword ptr [edx + 8], eax
008B3C18 mov ecx, dword ptr [ebp - 0xc8]
008B3C1E mov dword ptr [edx + 0xc], ecx
008B3C21 sub esp, 0x10
008B3C24 mov edx, esp
008B3C26 mov eax, dword ptr [ebp - 0xe4]
008B3C2C mov dword ptr [edx], eax
008B3C2E mov ecx, dword ptr [ebp - 0xe0]
008B3C34 mov dword ptr [edx + 4], ecx
008B3C37 mov eax, dword ptr [ebp - 0xdc]
008B3C3D mov dword ptr [edx + 8], eax
008B3C40 mov ecx, dword ptr [ebp - 0xd8]
008B3C46 mov dword ptr [edx + 0xc], ecx
008B3C49 mov edx, dword ptr [ebp - 0xe8]
008B3C4F push edx
008B3C50 push 0
008B3C52 lea eax, [ebp - 0x88]
008B3C58 push eax
008B3C59 mov ecx, dword ptr [ebp - 0xf0]
008B3C5F mov edx, dword ptr [ecx]
008B3C61 mov ecx, dword ptr [ebp - 0xf0]
008B3C67 mov eax, dword ptr [edx + 0x1b8]
008B3C6D call eax
008B3C6F mov dword ptr [ebp - 4], 0xffffffff
008B3C76 lea ecx, [ebp - 0x88]
008B3C7C call 0x4056d0
008B3C81 jmp 0x8b3cc8
008B3C83 mov ecx, dword ptr [ebp - 0x14]
008B3C86 mov edx, dword ptr [ecx + 8]
008B3C89 push edx
008B3C8A call 0x506ab0
008B3C8F mov ecx, eax
008B3C91 call 0x836590
008B3C96 call 0x506ab0
008B3C9B mov dword ptr [ebp - 0xf4], eax
008B3CA1 mov eax, dword ptr [ebp - 0xf4]
008B3CA7 mov edx, dword ptr [eax]
008B3CA9 mov ecx, dword ptr [ebp - 0xf4]
008B3CAF mov eax, dword ptr [edx + 0x108]
008B3CB5 call eax
008B3CB7 jmp 0x8b3cc8
008B3CB9 mov ecx, dword ptr [ebp - 0x10]
008B3CBC push ecx
008B3CBD mov ecx, dword ptr [ebp - 0xe8]
008B3CC3 call 0x8a9700
008B3CC8 mov ecx, dword ptr [ebp - 0xc]
008B3CCB mov dword ptr fs:[0], ecx
008B3CD2 pop ecx
008B3CD3 pop edi
008B3CD4 pop esi
008B3CD5 mov ecx, dword ptr [ebp - 0x6c]
008B3CD8 xor ecx, ebp
008B3CDA call 0x6634fb
008B3CDF mov esp, ebp
008B3CE1 pop ebp
008B3CE2 ret
