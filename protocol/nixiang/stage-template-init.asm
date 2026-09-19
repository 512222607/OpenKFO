; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Registration pair at B9A3B8: 00BADCBC (init_monster_conf), 0093DB40 callback.
; Bounded excerpts: template load, final sort, string comparator.
; region 0x93db40
0093DB40 push ebp
0093DB41 mov ebp, esp
0093DB43 push ecx
0093DB44 mov ecx, dword ptr [0x17c8710]
0093DB4A call 0x453db0
0093DB4F test eax, eax
0093DB51 jne 0x93db57
0093DB53 xor eax, eax
0093DB55 jmp 0x93dba6
0093DB57 mov ecx, dword ptr [0x17c8708]
0093DB5D call 0x4535c0
0093DB62 cmp eax, 0x15
0093DB65 je 0x93db6b
0093DB67 xor eax, eax
0093DB69 jmp 0x93dba6
0093DB6B push 0
0093DB6D push 0x12f90d0
0093DB72 push 0x12f899c
0093DB77 mov ecx, dword ptr [0x17c8710]
0093DB7D call 0x453db0
0093DB82 push 0
0093DB84 push eax
0093DB85 call 0xa97b0e
0093DB8A add esp, 0x14
0093DB8D mov dword ptr [ebp - 4], eax
0093DB90 cmp dword ptr [ebp - 4], 0
0093DB94 jne 0x93db9a
0093DB96 xor eax, eax
0093DB98 jmp 0x93dba6
0093DB9A mov eax, dword ptr [ebp + 8]
0093DB9D push eax
0093DB9E mov ecx, dword ptr [ebp - 4]
0093DBA1 call 0x939bf0
0093DBA6 mov esp, ebp
0093DBA8 pop ebp
0093DBA9 ret 
; region 0x939bf0
00939BF0 push ebp
00939BF1 mov ebp, esp
00939BF3 push -1
00939BF5 push 0xaa498d
00939BFA mov eax, dword ptr fs:[0]
00939C00 push eax
00939C01 sub esp, 0x4c
00939C04 mov eax, dword ptr [0xc7b480]
00939C09 xor eax, ebp
00939C0B push eax
00939C0C lea eax, [ebp - 0xc]
00939C0F mov dword ptr fs:[0], eax
00939C15 mov dword ptr [ebp - 0x54], ecx
00939C18 push -1
00939C1A mov eax, dword ptr [ebp + 8]
00939C1D push eax
00939C1E call 0x68c000
00939C23 add esp, 8
00939C26 cmp eax, 5
00939C29 je 0x939c32
00939C2B xor eax, eax
00939C2D jmp 0x93a2ab
00939C32 mov ecx, dword ptr [ebp - 0x54]
00939C35 call 0x938d60
00939C3A mov ecx, dword ptr [ebp - 0x54]
00939C3D add ecx, 0x12c
00939C43 call 0x4998d0
00939C48 mov ecx, dword ptr [ebp + 8]
00939C4B push ecx
00939C4C call 0x68bb90
00939C51 add esp, 4
00939C54 mov dword ptr [ebp - 0x10], eax
00939C57 mov edx, dword ptr [ebp + 8]
00939C5A push edx
00939C5B call 0x68c6f0
00939C60 add esp, 4
00939C63 mov eax, dword ptr [ebp - 0x10]
00939C66 push eax
00939C67 mov ecx, dword ptr [ebp + 8]
00939C6A push ecx
00939C6B call 0x68d700
00939C70 add esp, 8
00939C73 test eax, eax
00939C75 je 0x93a26c
00939C7B push -1
00939C7D mov edx, dword ptr [ebp + 8]
00939C80 push edx
00939C81 call 0x68c000
00939C86 add esp, 8
00939C89 cmp eax, 5
00939C8C jne 0x93a259
00939C92 mov dword ptr [ebp - 0x20], 0
00939C99 push 0x9c
00939C9E call 0x667fbb
00939CA3 add esp, 4
00939CA6 mov dword ptr [ebp - 0x40], eax
00939CA9 mov dword ptr [ebp - 4], 0
00939CB0 cmp dword ptr [ebp - 0x40], 0
00939CB4 je 0x939cc3
00939CB6 mov ecx, dword ptr [ebp - 0x40]
00939CB9 call 0x4d6f70
00939CBE mov dword ptr [ebp - 0x58], eax
00939CC1 jmp 0x939cca
00939CC3 mov dword ptr [ebp - 0x58], 0
00939CCA mov eax, dword ptr [ebp - 0x58]
00939CCD mov dword ptr [ebp - 0x3c], eax
00939CD0 mov dword ptr [ebp - 4], 0xffffffff
00939CD7 mov ecx, dword ptr [ebp - 0x3c]
00939CDA mov dword ptr [ebp - 0x1c], ecx
00939CDD mov edx, dword ptr [ebp - 0x1c]
00939CE0 mov dword ptr [ebp - 0x14], edx
00939CE3 mov eax, dword ptr [ebp - 0x20]
00939CE6 add eax, 1
00939CE9 mov dword ptr [ebp - 0x20], eax
00939CEC mov ecx, dword ptr [ebp - 0x20]
00939CEF push ecx
00939CF0 push -1
00939CF2 mov edx, dword ptr [ebp + 8]
00939CF5 push edx
00939CF6 call 0x68cc10
00939CFB add esp, 0xc
00939CFE push 0
00939D00 push -1
00939D02 mov eax, dword ptr [ebp + 8]
00939D05 push eax
00939D06 call 0x68c430
00939D0B add esp, 0xc
00939D0E push eax
00939D0F mov ecx, dword ptr [ebp - 0x14]
00939D12 call 0x405710
00939D17 push -2
00939D19 mov ecx, dword ptr [ebp + 8]
00939D1C push ecx
00939D1D call 0x68bbb0
00939D22 add esp, 8
00939D25 mov edx, dword ptr [ebp - 0x20]
00939D28 add edx, 1
00939D2B mov dword ptr [ebp - 0x20], edx
00939D2E mov eax, dword ptr [ebp - 0x20]
00939D31 push eax
00939D32 push -1
00939D34 mov ecx, dword ptr [ebp + 8]
00939D37 push ecx
00939D38 call 0x68cc10
00939D3D add esp, 0xc
00939D40 push -1
00939D42 mov edx, dword ptr [ebp + 8]
00939D45 push edx
00939D46 call 0x68c370
00939D4B add esp, 8
00939D4E mov ecx, dword ptr [ebp - 0x14]
00939D51 mov dword ptr [ecx + 0x1c], eax
00939D54 push -2
00939D56 mov edx, dword ptr [ebp + 8]
00939D59 push edx
00939D5A call 0x68bbb0
00939D5F add esp, 8
00939D62 mov eax, dword ptr [ebp - 0x20]
00939D65 add eax, 1
00939D68 mov dword ptr [ebp - 0x20], eax
00939D6B mov ecx, dword ptr [ebp - 0x20]
00939D6E push ecx
00939D6F push -1
00939D71 mov edx, dword ptr [ebp + 8]
00939D74 push edx
00939D75 call 0x68cc10
00939D7A add esp, 0xc
00939D7D push -1
00939D7F mov eax, dword ptr [ebp + 8]
00939D82 push eax
00939D83 call 0x68c370
00939D88 add esp, 8
00939D8B mov ecx, dword ptr [ebp - 0x14]
00939D8E mov dword ptr [ecx + 0x20], eax
00939D91 push -2
00939D93 mov edx, dword ptr [ebp + 8]
00939D96 push edx
00939D97 call 0x68bbb0
00939D9C add esp, 8
00939D9F mov eax, dword ptr [ebp - 0x20]
00939DA2 add eax, 1
00939DA5 mov dword ptr [ebp - 0x20], eax
00939DA8 mov ecx, dword ptr [ebp - 0x20]
00939DAB push ecx
00939DAC push -1
00939DAE mov edx, dword ptr [ebp + 8]
00939DB1 push edx
00939DB2 call 0x68cc10
00939DB7 add esp, 0xc
00939DBA push -1
00939DBC mov eax, dword ptr [ebp + 8]
00939DBF push eax
00939DC0 call 0x68c370
00939DC5 add esp, 8
00939DC8 mov ecx, dword ptr [ebp - 0x14]
00939DCB mov dword ptr [ecx + 0x24], eax
00939DCE push -2
00939DD0 mov edx, dword ptr [ebp + 8]
00939DD3 push edx
00939DD4 call 0x68bbb0
00939DD9 add esp, 8
00939DDC mov eax, dword ptr [ebp - 0x20]
00939DDF add eax, 1
00939DE2 mov dword ptr [ebp - 0x20], eax
00939DE5 mov ecx, dword ptr [ebp - 0x20]
00939DE8 push ecx
00939DE9 push -1
00939DEB mov edx, dword ptr [ebp + 8]
00939DEE push edx
00939DEF call 0x68cc10
00939DF4 add esp, 0xc
00939DF7 push -1
00939DF9 mov eax, dword ptr [ebp + 8]
00939DFC push eax
00939DFD call 0x68c370
00939E02 add esp, 8
00939E05 mov ecx, dword ptr [ebp - 0x14]
00939E08 mov dword ptr [ecx + 0x28], eax
00939E0B push -2
00939E0D mov edx, dword ptr [ebp + 8]
00939E10 push edx
00939E11 call 0x68bbb0
00939E16 add esp, 8
00939E19 mov eax, dword ptr [ebp - 0x20]
00939E1C add eax, 1
00939E1F mov dword ptr [ebp - 0x20], eax
00939E22 mov ecx, dword ptr [ebp - 0x20]
00939E25 push ecx
00939E26 push -1
00939E28 mov edx, dword ptr [ebp + 8]
00939E2B push edx
00939E2C call 0x68cc10
00939E31 add esp, 0xc
00939E34 push -1
00939E36 mov eax, dword ptr [ebp + 8]
00939E39 push eax
00939E3A call 0x68c370
00939E3F add esp, 8
00939E42 mov ecx, dword ptr [ebp - 0x14]
00939E45 mov dword ptr [ecx + 0x2c], eax
00939E48 push -2
00939E4A mov edx, dword ptr [ebp + 8]
00939E4D push edx
00939E4E call 0x68bbb0
00939E53 add esp, 8
00939E56 mov eax, dword ptr [ebp - 0x20]
00939E59 add eax, 1
00939E5C mov dword ptr [ebp - 0x20], eax
00939E5F mov ecx, dword ptr [ebp - 0x20]
00939E62 push ecx
00939E63 push -1
00939E65 mov edx, dword ptr [ebp + 8]
00939E68 push edx
00939E69 call 0x68cc10
00939E6E add esp, 0xc
00939E71 push -1
00939E73 mov eax, dword ptr [ebp + 8]
00939E76 push eax
00939E77 call 0x68c370
00939E7C add esp, 8
00939E7F mov ecx, dword ptr [ebp - 0x14]
00939E82 mov dword ptr [ecx + 0x30], eax
00939E85 push -2
00939E87 mov edx, dword ptr [ebp + 8]
00939E8A push edx
00939E8B call 0x68bbb0
00939E90 add esp, 8
00939E93 mov eax, dword ptr [ebp - 0x20]
00939E96 add eax, 1
00939E99 mov dword ptr [ebp - 0x20], eax
00939E9C mov ecx, dword ptr [ebp - 0x20]
00939E9F push ecx
00939EA0 push -1
00939EA2 mov edx, dword ptr [ebp + 8]
00939EA5 push edx
00939EA6 call 0x68cc10
00939EAB add esp, 0xc
00939EAE push -1
00939EB0 mov eax, dword ptr [ebp + 8]
00939EB3 push eax
00939EB4 call 0x68c370
00939EB9 add esp, 8
00939EBC mov ecx, dword ptr [ebp - 0x14]
00939EBF mov dword ptr [ecx + 0x34], eax
00939EC2 push -2
00939EC4 mov edx, dword ptr [ebp + 8]
00939EC7 push edx
00939EC8 call 0x68bbb0
00939ECD add esp, 8
00939ED0 mov eax, dword ptr [ebp - 0x20]
00939ED3 add eax, 1
00939ED6 mov dword ptr [ebp - 0x20], eax
00939ED9 mov ecx, dword ptr [ebp - 0x20]
00939EDC push ecx
00939EDD push -1
00939EDF mov edx, dword ptr [ebp + 8]
00939EE2 push edx
00939EE3 call 0x68cc10
00939EE8 add esp, 0xc
00939EEB push -1
00939EED mov eax, dword ptr [ebp + 8]
00939EF0 push eax
00939EF1 call 0x68c370
00939EF6 add esp, 8
00939EF9 mov ecx, dword ptr [ebp - 0x14]
00939EFC mov dword ptr [ecx + 0x38], eax
00939EFF push -2
00939F01 mov edx, dword ptr [ebp + 8]
00939F04 push edx
00939F05 call 0x68bbb0
00939F0A add esp, 8
00939F0D mov eax, dword ptr [ebp - 0x20]
00939F10 add eax, 1
00939F13 mov dword ptr [ebp - 0x20], eax
00939F16 mov ecx, dword ptr [ebp - 0x20]
00939F19 push ecx
00939F1A push -1
00939F1C mov edx, dword ptr [ebp + 8]
00939F1F push edx
00939F20 call 0x68cc10
00939F25 add esp, 0xc
00939F28 push 0
00939F2A push -1
00939F2C mov eax, dword ptr [ebp + 8]
00939F2F push eax
00939F30 call 0x68c430
00939F35 add esp, 0xc
00939F38 push eax
00939F39 mov ecx, dword ptr [ebp - 0x14]
00939F3C add ecx, 0x3c
00939F3F call 0x405710
00939F44 push -2
00939F46 mov ecx, dword ptr [ebp + 8]
00939F49 push ecx
00939F4A call 0x68bbb0
00939F4F add esp, 8
00939F52 mov edx, dword ptr [ebp - 0x20]
00939F55 add edx, 1
00939F58 mov dword ptr [ebp - 0x20], edx
00939F5B mov eax, dword ptr [ebp - 0x20]
00939F5E push eax
00939F5F push -1
00939F61 mov ecx, dword ptr [ebp + 8]
00939F64 push ecx
00939F65 call 0x68cc10
00939F6A add esp, 0xc
00939F6D push 0
00939F6F push -1
00939F71 mov edx, dword ptr [ebp + 8]
00939F74 push edx
00939F75 call 0x68c430
00939F7A add esp, 0xc
00939F7D push eax
00939F7E mov ecx, dword ptr [ebp - 0x14]
00939F81 add ecx, 0x58
00939F84 call 0x405710
00939F89 push -2
00939F8B mov eax, dword ptr [ebp + 8]
00939F8E push eax
00939F8F call 0x68bbb0
00939F94 add esp, 8
00939F97 mov ecx, dword ptr [ebp - 0x20]
00939F9A add ecx, 1
00939F9D mov dword ptr [ebp - 0x20], ecx
00939FA0 mov edx, dword ptr [ebp - 0x20]
00939FA3 push edx
00939FA4 push -1
00939FA6 mov eax, dword ptr [ebp + 8]
00939FA9 push eax
00939FAA call 0x68cc10
00939FAF add esp, 0xc
00939FB2 push -1
00939FB4 mov ecx, dword ptr [ebp + 8]
00939FB7 push ecx
00939FB8 call 0x68c320
00939FBD add esp, 8
00939FC0 mov edx, dword ptr [ebp - 0x14]
00939FC3 fstp dword ptr [edx + 0x74]
00939FC6 push -2
00939FC8 mov eax, dword ptr [ebp + 8]
00939FCB push eax
00939FCC call 0x68bbb0
00939FD1 add esp, 8
00939FD4 mov ecx, dword ptr [ebp - 0x20]
00939FD7 add ecx, 1
00939FDA mov dword ptr [ebp - 0x20], ecx
00939FDD mov edx, dword ptr [ebp - 0x20]
00939FE0 push edx
00939FE1 push -1
00939FE3 mov eax, dword ptr [ebp + 8]
00939FE6 push eax
00939FE7 call 0x68cc10
00939FEC add esp, 0xc
00939FEF push -1
00939FF1 mov ecx, dword ptr [ebp + 8]
00939FF4 push ecx
00939FF5 call 0x68c3e0
00939FFA add esp, 8
00939FFD test eax, eax
00939FFF setne dl
0093A002 mov eax, dword ptr [ebp - 0x14]
0093A005 mov byte ptr [eax + 0x78], dl
0093A008 push -2
0093A00A mov ecx, dword ptr [ebp + 8]
0093A00D push ecx
0093A00E call 0x68bbb0
0093A013 add esp, 8
0093A016 mov edx, dword ptr [ebp - 0x20]
0093A019 add edx, 1
0093A01C mov dword ptr [ebp - 0x20], edx
0093A01F mov eax, dword ptr [ebp - 0x20]
0093A022 push eax
0093A023 push -1
0093A025 mov ecx, dword ptr [ebp + 8]
0093A028 push ecx
0093A029 call 0x68cc10
0093A02E add esp, 0xc
0093A031 push -1
0093A033 mov edx, dword ptr [ebp + 8]
0093A036 push edx
0093A037 call 0x68c320
0093A03C add esp, 8
0093A03F mov eax, dword ptr [ebp - 0x14]
0093A042 fstp dword ptr [eax + 0x7c]
0093A045 push -2
0093A047 mov ecx, dword ptr [ebp + 8]
0093A04A push ecx
0093A04B call 0x68bbb0
0093A050 add esp, 8
0093A053 mov edx, dword ptr [ebp - 0x20]
0093A056 add edx, 1
0093A059 mov dword ptr [ebp - 0x20], edx
0093A05C mov eax, dword ptr [ebp - 0x20]
0093A05F push eax
0093A060 push -1
0093A062 mov ecx, dword ptr [ebp + 8]
0093A065 push ecx
0093A066 call 0x68cc10
0093A06B add esp, 0xc
0093A06E push -1
0093A070 mov edx, dword ptr [ebp + 8]
0093A073 push edx
0093A074 call 0x68c370
0093A079 add esp, 8
0093A07C mov ecx, dword ptr [ebp - 0x14]
0093A07F mov dword ptr [ecx + 0x80], eax
0093A085 push -2
0093A087 mov edx, dword ptr [ebp + 8]
0093A08A push edx
0093A08B call 0x68bbb0
0093A090 add esp, 8
0093A093 mov eax, dword ptr [ebp - 0x20]
0093A096 add eax, 1
0093A099 mov dword ptr [ebp - 0x20], eax
0093A09C mov ecx, dword ptr [ebp - 0x20]
0093A09F push ecx
0093A0A0 push -1
0093A0A2 mov edx, dword ptr [ebp + 8]
0093A0A5 push edx
0093A0A6 call 0x68cc10
0093A0AB add esp, 0xc
0093A0AE push -1
0093A0B0 mov eax, dword ptr [ebp + 8]
0093A0B3 push eax
0093A0B4 call 0x68c4d0
0093A0B9 add esp, 8
0093A0BC mov dword ptr [ebp - 0x18], eax
0093A0BF push -1
0093A0C1 mov ecx, dword ptr [ebp + 8]
0093A0C4 push ecx
0093A0C5 call 0x68c000
0093A0CA add esp, 8
0093A0CD cmp eax, 5
0093A0D0 jne 0x93a222
0093A0D6 cmp dword ptr [ebp - 0x18], 0
0093A0DA jle 0x93a222
0093A0E0 mov edx, dword ptr [ebp + 8]
0093A0E3 push edx
0093A0E4 call 0x68bb90
0093A0E9 add esp, 4
0093A0EC mov dword ptr [ebp - 0x24], eax
0093A0EF mov eax, dword ptr [ebp + 8]
0093A0F2 push eax
0093A0F3 call 0x68c6f0
0093A0F8 add esp, 4
0093A0FB mov ecx, dword ptr [ebp - 0x24]
0093A0FE push ecx
0093A0FF mov edx, dword ptr [ebp + 8]
0093A102 push edx
0093A103 call 0x68d700
0093A108 add esp, 8
0093A10B test eax, eax
0093A10D je 0x93a222
0093A113 mov dword ptr [ebp - 0x28], 3
0093A11A push -1
0093A11C mov eax, dword ptr [ebp + 8]
0093A11F push eax
0093A120 call 0x68c000
0093A125 add esp, 8
0093A128 cmp eax, 5
0093A12B jne 0x93a20f
0093A131 push -1
0093A133 mov ecx, dword ptr [ebp + 8]
0093A136 push ecx
0093A137 call 0x68c4d0
0093A13C add esp, 8
0093A13F cmp eax, 3
0093A142 jne 0x93a20f
0093A148 mov dword ptr [ebp - 0x2c], 0
0093A14F mov edx, dword ptr [ebp - 0x2c]
0093A152 add edx, 1
0093A155 mov dword ptr [ebp - 0x2c], edx
0093A158 mov eax, dword ptr [ebp - 0x2c]
0093A15B push eax
0093A15C push -1
0093A15E mov ecx, dword ptr [ebp + 8]
0093A161 push ecx
0093A162 call 0x68cc10
0093A167 add esp, 0xc
0093A16A push -1
0093A16C mov edx, dword ptr [ebp + 8]
0093A16F push edx
0093A170 call 0x68c370
0093A175 add esp, 8
0093A178 mov dword ptr [ebp - 0x38], eax
0093A17B push -2
0093A17D mov eax, dword ptr [ebp + 8]
0093A180 push eax
0093A181 call 0x68bbb0
0093A186 add esp, 8
0093A189 mov ecx, dword ptr [ebp - 0x2c]
0093A18C add ecx, 1
0093A18F mov dword ptr [ebp - 0x2c], ecx
0093A192 mov edx, dword ptr [ebp - 0x2c]
0093A195 push edx
0093A196 push -1
0093A198 mov eax, dword ptr [ebp + 8]
0093A19B push eax
0093A19C call 0x68cc10
0093A1A1 add esp, 0xc
0093A1A4 push -1
0093A1A6 mov ecx, dword ptr [ebp + 8]
0093A1A9 push ecx
0093A1AA call 0x68c370
0093A1AF add esp, 8
0093A1B2 mov dword ptr [ebp - 0x34], eax
0093A1B5 push -2
0093A1B7 mov edx, dword ptr [ebp + 8]
0093A1BA push edx
0093A1BB call 0x68bbb0
0093A1C0 add esp, 8
0093A1C3 mov eax, dword ptr [ebp - 0x2c]
0093A1C6 add eax, 1
0093A1C9 mov dword ptr [ebp - 0x2c], eax
0093A1CC mov ecx, dword ptr [ebp - 0x2c]
0093A1CF push ecx
0093A1D0 push -1
0093A1D2 mov edx, dword ptr [ebp + 8]
0093A1D5 push edx
0093A1D6 call 0x68cc10
0093A1DB add esp, 0xc
0093A1DE push -1
0093A1E0 mov eax, dword ptr [ebp + 8]
0093A1E3 push eax
0093A1E4 call 0x68c320
0093A1E9 add esp, 8
0093A1EC fstp dword ptr [ebp - 0x30]
0093A1EF push -2
0093A1F1 mov ecx, dword ptr [ebp + 8]
0093A1F4 push ecx
0093A1F5 call 0x68bbb0
0093A1FA add esp, 8
0093A1FD lea edx, [ebp - 0x38]
0093A200 push edx
0093A201 mov ecx, dword ptr [ebp - 0x14]
0093A204 add ecx, 0x84
0093A20A call 0x48e560
0093A20F push -2
0093A211 mov eax, dword ptr [ebp + 8]
0093A214 push eax
0093A215 call 0x68bbb0
0093A21A add esp, 8
0093A21D jmp 0x93a0fb
0093A222 push -2
0093A224 mov ecx, dword ptr [ebp + 8]
0093A227 push ecx
0093A228 call 0x68bbb0
0093A22D add esp, 8
0093A230 mov edx, dword ptr [ebp - 0x14]
0093A233 push edx
0093A234 mov ecx, dword ptr [ebp - 0x54]
0093A237 add ecx, 0x10c
0093A23D call 0x55e560
0093A242 mov ecx, dword ptr [ebp - 0x1c]
0093A245 mov dword ptr [eax], ecx
0093A247 mov edx, dword ptr [ebp - 0x14]
0093A24A push edx
0093A24B mov ecx, dword ptr [ebp - 0x54]
0093A24E add ecx, 0x12c
0093A254 call 0x49d150
0093A259 push -2
0093A25B mov eax, dword ptr [ebp + 8]
0093A25E push eax
0093A25F call 0x68bbb0
0093A264 add esp, 8
0093A267 jmp 0x939c63
0093A26C lea ecx, [ebp - 0x48]
0093A26F push ecx
0093A270 mov ecx, dword ptr [ebp - 0x54]
0093A273 add ecx, 0x12c
0093A279 call 0x4f2590
0093A27E mov edx, dword ptr [eax + 4]
0093A281 push edx
0093A282 mov eax, dword ptr [eax]
0093A284 push eax
0093A285 lea ecx, [ebp - 0x50]
0093A288 push ecx
0093A289 mov ecx, dword ptr [ebp - 0x54]
0093A28C add ecx, 0x12c
0093A292 call 0x4d6050
0093A297 mov edx, dword ptr [eax + 4]
0093A29A push edx
0093A29B mov eax, dword ptr [eax]
0093A29D push eax
0093A29E call 0x4d8b50
0093A2A3 add esp, 0x10
0093A2A6 mov eax, 1
0093A2AB mov ecx, dword ptr [ebp - 0xc]
0093A2AE mov dword ptr fs:[0], ecx
0093A2B5 pop ecx
0093A2B6 mov esp, ebp
0093A2B8 pop ebp
0093A2B9 ret 4
; region 0x4d8b50
004D8B50 push ebp
004D8B51 mov ebp, esp
004D8B53 lea eax, [ebp + 8]
004D8B56 push eax
004D8B57 lea ecx, [ebp + 0x10]
004D8B5A call 0x4d8b90
004D8B5F push eax
004D8B60 lea ecx, [ebp + 0x10]
004D8B63 push ecx
004D8B64 call 0x4338f0
004D8B69 add esp, 4
004D8B6C push eax
004D8B6D lea edx, [ebp + 8]
004D8B70 push edx
004D8B71 call 0x4338f0
004D8B76 add esp, 4
004D8B79 push eax
004D8B7A call 0x4d8bb0
004D8B7F add esp, 0xc
004D8B82 pop ebp
004D8B83 ret 
004D8B84 int3 
004D8B85 int3 
004D8B86 int3 
004D8B87 int3 
004D8B88 int3 
004D8B89 int3 
004D8B8A int3 
004D8B8B int3 
004D8B8C int3 
004D8B8D int3 
004D8B8E int3 
004D8B8F int3 
004D8B90 push ebp
004D8B91 mov ebp, esp
004D8B93 push ecx
004D8B94 mov dword ptr [ebp - 4], ecx
004D8B97 mov eax, dword ptr [ebp + 8]
004D8B9A push eax
004D8B9B mov ecx, dword ptr [ebp - 4]
004D8B9E call 0x49e8e0
004D8BA3 mov esp, ebp
004D8BA5 pop ebp
004D8BA6 ret 4
004D8BA9 int3 
004D8BAA int3 
004D8BAB int3 
004D8BAC int3 
004D8BAD int3 
004D8BAE int3 
004D8BAF int3 
004D8BB0 push ebp
004D8BB1 mov ebp, esp
004D8BB3 sub esp, 0xc
004D8BB6 push esi
004D8BB7 mov eax, dword ptr [ebp + 0xc]
004D8BBA sub eax, dword ptr [ebp + 8]
004D8BBD cdq 
004D8BBE mov ecx, 0x1c
004D8BC3 idiv ecx
004D8BC5 mov dword ptr [ebp - 4], eax
004D8BC8 cmp dword ptr [ebp - 4], 0x20
004D8BCC jle 0x4d8c66
004D8BD2 cmp dword ptr [ebp + 0x10], 0
004D8BD6 jle 0x4d8c66
004D8BDC mov edx, dword ptr [ebp + 0xc]
004D8BDF push edx
004D8BE0 mov eax, dword ptr [ebp + 8]
004D8BE3 push eax
004D8BE4 lea ecx, [ebp - 0xc]
004D8BE7 push ecx
004D8BE8 call 0x4d8cf0
004D8BED add esp, 0xc
004D8BF0 mov eax, dword ptr [ebp + 0x10]
004D8BF3 cdq 
004D8BF4 sub eax, edx
004D8BF6 sar eax, 1
004D8BF8 mov dword ptr [ebp + 0x10], eax
004D8BFB mov eax, dword ptr [ebp + 0x10]
004D8BFE cdq 
004D8BFF sub eax, edx
004D8C01 sar eax, 1
004D8C03 add eax, dword ptr [ebp + 0x10]
004D8C06 mov dword ptr [ebp + 0x10], eax
004D8C09 mov eax, dword ptr [ebp - 0xc]
004D8C0C sub eax, dword ptr [ebp + 8]
004D8C0F cdq 
004D8C10 mov ecx, 0x1c
004D8C15 idiv ecx
004D8C17 mov ecx, eax
004D8C19 mov eax, dword ptr [ebp + 0xc]
004D8C1C sub eax, dword ptr [ebp - 8]
004D8C1F cdq 
004D8C20 mov esi, 0x1c
004D8C25 idiv esi
004D8C27 cmp ecx, eax
004D8C29 jge 0x4d8c47
004D8C2B mov edx, dword ptr [ebp + 0x10]
004D8C2E push edx
004D8C2F mov eax, dword ptr [ebp - 0xc]
004D8C32 push eax
004D8C33 mov ecx, dword ptr [ebp + 8]
004D8C36 push ecx
004D8C37 call 0x4d8bb0
004D8C3C add esp, 0xc
004D8C3F mov edx, dword ptr [ebp - 8]
004D8C42 mov dword ptr [ebp + 8], edx
004D8C45 jmp 0x4d8c61
004D8C47 mov eax, dword ptr [ebp + 0x10]
004D8C4A push eax
004D8C4B mov ecx, dword ptr [ebp + 0xc]
004D8C4E push ecx
004D8C4F mov edx, dword ptr [ebp - 8]
004D8C52 push edx
004D8C53 call 0x4d8bb0
004D8C58 add esp, 0xc
004D8C5B mov eax, dword ptr [ebp - 0xc]
004D8C5E mov dword ptr [ebp + 0xc], eax
004D8C61 jmp 0x4d8bb7
004D8C66 cmp dword ptr [ebp - 4], 0x20
004D8C6A jle 0x4d8c8e
004D8C6C mov ecx, dword ptr [ebp + 0xc]
004D8C6F push ecx
004D8C70 mov edx, dword ptr [ebp + 8]
004D8C73 push edx
004D8C74 call 0x4d8fa0
004D8C79 add esp, 8
004D8C7C mov eax, dword ptr [ebp + 0xc]
004D8C7F push eax
004D8C80 mov ecx, dword ptr [ebp + 8]
004D8C83 push ecx
004D8C84 call 0x4d9000
004D8C89 add esp, 8
004D8C8C jmp 0x4d8ca4
004D8C8E cmp dword ptr [ebp - 4], 1
004D8C92 jle 0x4d8ca4
004D8C94 mov edx, dword ptr [ebp + 0xc]
004D8C97 push edx
004D8C98 mov eax, dword ptr [ebp + 8]
004D8C9B push eax
004D8C9C call 0x4d9030
004D8CA1 add esp, 8
004D8CA4 pop esi
004D8CA5 mov esp, ebp
004D8CA7 pop ebp
; region 0x4d8cf0
004D8CF0 push ebp
004D8CF1 mov ebp, esp
004D8CF3 sub esp, 0x24
004D8CF6 mov eax, dword ptr [ebp + 0x10]
004D8CF9 sub eax, dword ptr [ebp + 0xc]
004D8CFC cdq 
004D8CFD mov ecx, 0x1c
004D8D02 idiv ecx
004D8D04 cdq 
004D8D05 sub eax, edx
004D8D07 sar eax, 1
004D8D09 imul eax, eax, 0x1c
004D8D0C add eax, dword ptr [ebp + 0xc]
004D8D0F mov dword ptr [ebp - 4], eax
004D8D12 mov edx, dword ptr [ebp + 0x10]
004D8D15 sub edx, 0x1c
004D8D18 push edx
004D8D19 mov eax, dword ptr [ebp - 4]
004D8D1C push eax
004D8D1D mov ecx, dword ptr [ebp + 0xc]
004D8D20 push ecx
004D8D21 call 0x4d9060
004D8D26 add esp, 0xc
004D8D29 mov edx, dword ptr [ebp - 4]
004D8D2C mov dword ptr [ebp - 0xc], edx
004D8D2F mov eax, dword ptr [ebp - 0xc]
004D8D32 add eax, 0x1c
004D8D35 mov dword ptr [ebp - 0x14], eax
004D8D38 mov ecx, dword ptr [ebp + 0xc]
004D8D3B cmp ecx, dword ptr [ebp - 0xc]
004D8D3E jae 0x4d8d7f
004D8D40 mov edx, dword ptr [ebp - 0xc]
004D8D43 push edx
004D8D44 mov eax, dword ptr [ebp - 0xc]
004D8D47 sub eax, 0x1c
004D8D4A push eax
004D8D4B call 0x4120b0
004D8D50 add esp, 8
004D8D53 movzx ecx, al
004D8D56 test ecx, ecx
004D8D58 jne 0x4d8d7f
004D8D5A mov edx, dword ptr [ebp - 0xc]
004D8D5D sub edx, 0x1c
004D8D60 push edx
004D8D61 mov eax, dword ptr [ebp - 0xc]
004D8D64 push eax
004D8D65 call 0x4120b0
004D8D6A add esp, 8
004D8D6D movzx ecx, al
004D8D70 test ecx, ecx
004D8D72 jne 0x4d8d7f
004D8D74 mov edx, dword ptr [ebp - 0xc]
004D8D77 sub edx, 0x1c
004D8D7A mov dword ptr [ebp - 0xc], edx
004D8D7D jmp 0x4d8d38
004D8D7F mov eax, dword ptr [ebp - 0x14]
004D8D82 cmp eax, dword ptr [ebp + 0x10]
004D8D85 jae 0x4d8dc0
004D8D87 mov ecx, dword ptr [ebp - 0xc]
004D8D8A push ecx
004D8D8B mov edx, dword ptr [ebp - 0x14]
004D8D8E push edx
004D8D8F call 0x4120b0
004D8D94 add esp, 8
004D8D97 movzx eax, al
004D8D9A test eax, eax
004D8D9C jne 0x4d8dc0
004D8D9E mov ecx, dword ptr [ebp - 0x14]
004D8DA1 push ecx
004D8DA2 mov edx, dword ptr [ebp - 0xc]
004D8DA5 push edx
004D8DA6 call 0x4120b0
004D8DAB add esp, 8
004D8DAE movzx eax, al
004D8DB1 test eax, eax
004D8DB3 jne 0x4d8dc0
004D8DB5 mov ecx, dword ptr [ebp - 0x14]
004D8DB8 add ecx, 0x1c
004D8DBB mov dword ptr [ebp - 0x14], ecx
004D8DBE jmp 0x4d8d7f
004D8DC0 mov edx, dword ptr [ebp - 0x14]
004D8DC3 mov dword ptr [ebp - 8], edx
004D8DC6 mov eax, dword ptr [ebp - 0xc]
004D8DC9 mov dword ptr [ebp - 0x10], eax
004D8DCC jmp 0x4d8dd7
004D8DCE mov ecx, dword ptr [ebp - 8]
004D8DD1 add ecx, 0x1c
004D8DD4 mov dword ptr [ebp - 8], ecx
004D8DD7 mov edx, dword ptr [ebp - 8]
004D8DDA cmp edx, dword ptr [ebp + 0x10]
004D8DDD jae 0x4d8e34
004D8DDF mov eax, dword ptr [ebp - 8]
004D8DE2 push eax
004D8DE3 mov ecx, dword ptr [ebp - 0xc]
004D8DE6 push ecx
004D8DE7 call 0x4120b0
004D8DEC add esp, 8
004D8DEF movzx edx, al
004D8DF2 test edx, edx
004D8DF4 je 0x4d8df8
004D8DF6 jmp 0x4d8e32
004D8DF8 mov eax, dword ptr [ebp - 0xc]
004D8DFB push eax
004D8DFC mov ecx, dword ptr [ebp - 8]
004D8DFF push ecx
004D8E00 call 0x4120b0
004D8E05 add esp, 8
004D8E08 movzx edx, al
004D8E0B test edx, edx
004D8E0D je 0x4d8e13
004D8E0F jmp 0x4d8e34
004D8E11 jmp 0x4d8e32
004D8E13 mov eax, dword ptr [ebp - 0x14]
004D8E16 mov dword ptr [ebp - 0x18], eax
004D8E19 mov ecx, dword ptr [ebp - 0x14]
004D8E1C add ecx, 0x1c
004D8E1F mov dword ptr [ebp - 0x14], ecx
004D8E22 mov edx, dword ptr [ebp - 8]
004D8E25 push edx
004D8E26 mov eax, dword ptr [ebp - 0x18]
004D8E29 push eax
; region 0x4d91f0
004D91F0 push ebp
004D91F1 mov ebp, esp
004D91F3 push -1
004D91F5 push 0xae3988
004D91FA mov eax, dword ptr fs:[0]
004D9200 push eax
004D9201 sub esp, 0x2c
004D9204 mov eax, dword ptr [0xc7b480]
004D9209 xor eax, ebp
004D920B mov dword ptr [ebp - 0x18], eax
004D920E push eax
004D920F lea eax, [ebp - 0xc]
004D9212 mov dword ptr fs:[0], eax
004D9218 mov eax, dword ptr [ebp + 8]
004D921B cmp eax, dword ptr [ebp + 0xc]
004D921E je 0x4d92f6
004D9224 mov ecx, dword ptr [ebp + 8]
004D9227 mov dword ptr [ebp - 0x10], ecx
004D922A mov edx, dword ptr [ebp - 0x10]
004D922D add edx, 0x1c
004D9230 mov dword ptr [ebp - 0x10], edx
004D9233 mov eax, dword ptr [ebp - 0x10]
004D9236 cmp eax, dword ptr [ebp + 0xc]
004D9239 je 0x4d92f6
004D923F mov ecx, dword ptr [ebp - 0x10]
004D9242 mov dword ptr [ebp - 0x14], ecx
004D9245 mov edx, dword ptr [ebp - 0x10]
004D9248 push edx
004D9249 lea ecx, [ebp - 0x34]
004D924C call 0x405690
004D9251 mov dword ptr [ebp - 4], 0
004D9258 mov eax, dword ptr [ebp + 8]
004D925B push eax
004D925C lea ecx, [ebp - 0x34]
004D925F push ecx
004D9260 call 0x4120b0
004D9265 add esp, 8
004D9268 movzx edx, al
004D926B test edx, edx
004D926D je 0x4d929a
004D926F mov eax, dword ptr [ebp - 0x14]
004D9272 add eax, 0x1c
004D9275 mov dword ptr [ebp - 0x14], eax
004D9278 mov ecx, dword ptr [ebp - 0x14]
004D927B push ecx
004D927C mov edx, dword ptr [ebp - 0x10]
004D927F push edx
004D9280 mov eax, dword ptr [ebp + 8]
004D9283 push eax
004D9284 call 0x4d9500
004D9289 add esp, 0xc
004D928C lea ecx, [ebp - 0x34]
004D928F push ecx
004D9290 mov ecx, dword ptr [ebp + 8]
004D9293 call 0x4056f0
004D9298 jmp 0x4d92e2
004D929A mov edx, dword ptr [ebp - 0x14]
004D929D mov dword ptr [ebp - 0x38], edx
004D92A0 jmp 0x4d92a8
004D92A2 mov eax, dword ptr [ebp - 0x38]
004D92A5 mov dword ptr [ebp - 0x14], eax
004D92A8 mov ecx, dword ptr [ebp - 0x38]
004D92AB sub ecx, 0x1c
004D92AE mov dword ptr [ebp - 0x38], ecx
004D92B1 mov edx, dword ptr [ebp - 0x38]
004D92B4 push edx
004D92B5 lea eax, [ebp - 0x34]
004D92B8 push eax
004D92B9 call 0x4120b0
004D92BE add esp, 8
004D92C1 movzx ecx, al
004D92C4 test ecx, ecx
004D92C6 je 0x4d92d6
004D92C8 mov edx, dword ptr [ebp - 0x38]
004D92CB push edx
004D92CC mov ecx, dword ptr [ebp - 0x14]
004D92CF call 0x4056f0
004D92D4 jmp 0x4d92a2
004D92D6 lea eax, [ebp - 0x34]
004D92D9 push eax
004D92DA mov ecx, dword ptr [ebp - 0x14]
004D92DD call 0x4056f0
004D92E2 mov dword ptr [ebp - 4], 0xffffffff
004D92E9 lea ecx, [ebp - 0x34]
004D92EC call 0x4056d0
004D92F1 jmp 0x4d922a
004D92F6 mov ecx, dword ptr [ebp - 0xc]
004D92F9 mov dword ptr fs:[0], ecx
004D9300 pop ecx
004D9301 mov ecx, dword ptr [ebp - 0x18]
004D9304 xor ecx, ebp
004D9306 call 0x6634fb
004D930B mov esp, ebp
004D930D pop ebp
004D930E ret 
004D930F int3 
004D9310 push ebp
; region 0x4120b0
004120B0 push ebp
004120B1 mov ebp, esp
004120B3 mov eax, dword ptr [ebp + 0xc]
004120B6 push eax
004120B7 mov ecx, dword ptr [ebp + 8]
004120BA call 0x4057a0
004120BF xor ecx, ecx
004120C1 test eax, eax
004120C3 setl cl
004120C6 mov al, cl
004120C8 pop ebp
004120C9 ret 
; region 0x4057a0
004057A0 push ebp
004057A1 mov ebp, esp
004057A3 push ecx
004057A4 mov dword ptr [ebp - 4], ecx
004057A7 mov ecx, dword ptr [ebp + 8]
004057AA call 0x548980
004057AF push eax
004057B0 mov ecx, dword ptr [ebp + 8]
004057B3 call 0x407fc0
004057B8 push eax
004057B9 mov eax, dword ptr [ebp - 4]
004057BC mov ecx, dword ptr [eax + 0x14]
004057BF push ecx
004057C0 push 0
004057C2 mov ecx, dword ptr [ebp - 4]
004057C5 call 0x407e90
004057CA mov esp, ebp
004057CC pop ebp
004057CD ret 4
; region 0x407e90
00407E90 push ebp
00407E91 mov ebp, esp
00407E93 sub esp, 0x14
00407E96 mov dword ptr [ebp - 8], ecx
00407E99 mov eax, dword ptr [ebp - 8]
00407E9C mov ecx, dword ptr [eax + 0x14]
00407E9F cmp ecx, dword ptr [ebp + 8]
00407EA2 jae 0x407ea9
00407EA4 call 0x66229e
00407EA9 mov edx, dword ptr [ebp - 8]
00407EAC mov eax, dword ptr [edx + 0x14]
00407EAF sub eax, dword ptr [ebp + 8]
00407EB2 cmp eax, dword ptr [ebp + 0xc]
00407EB5 jae 0x407ec3
00407EB7 mov ecx, dword ptr [ebp - 8]
00407EBA mov edx, dword ptr [ecx + 0x14]
00407EBD sub edx, dword ptr [ebp + 8]
00407EC0 mov dword ptr [ebp + 0xc], edx
00407EC3 mov eax, dword ptr [ebp + 0xc]
00407EC6 cmp eax, dword ptr [ebp + 0x14]
00407EC9 jae 0x407ed3
00407ECB mov ecx, dword ptr [ebp + 0xc]
00407ECE mov dword ptr [ebp - 0xc], ecx
00407ED1 jmp 0x407ed9
00407ED3 mov edx, dword ptr [ebp + 0x14]
00407ED6 mov dword ptr [ebp - 0xc], edx
00407ED9 mov eax, dword ptr [ebp - 0xc]
00407EDC push eax
00407EDD mov ecx, dword ptr [ebp + 0x10]
00407EE0 push ecx
00407EE1 mov ecx, dword ptr [ebp - 8]
00407EE4 call 0x407fc0
00407EE9 add eax, dword ptr [ebp + 8]
00407EEC push eax
00407EED call 0x401120
00407EF2 add esp, 0xc
00407EF5 mov dword ptr [ebp - 4], eax
00407EF8 cmp dword ptr [ebp - 4], 0
00407EFC je 0x407f06
00407EFE mov edx, dword ptr [ebp - 4]
00407F01 mov dword ptr [ebp - 0x10], edx
00407F04 jmp 0x407f2b
00407F06 mov eax, dword ptr [ebp + 0xc]
00407F09 cmp eax, dword ptr [ebp + 0x14]
00407F0C jae 0x407f17
00407F0E mov dword ptr [ebp - 0x14], 0xffffffff
00407F15 jmp 0x407f25
00407F17 mov ecx, dword ptr [ebp + 0xc]
00407F1A xor edx, edx
00407F1C cmp ecx, dword ptr [ebp + 0x14]
00407F1F setne dl
00407F22 mov dword ptr [ebp - 0x14], edx
00407F25 mov eax, dword ptr [ebp - 0x14]
00407F28 mov dword ptr [ebp - 0x10], eax
00407F2B mov eax, dword ptr [ebp - 0x10]
00407F2E mov esp, ebp
00407F30 pop ebp
00407F31 ret 0x10
; region 0x401120
00401120 push ebp
00401121 mov ebp, esp
00401123 mov eax, dword ptr [ebp + 0x10]
00401126 push eax
00401127 mov ecx, dword ptr [ebp + 0xc]
0040112A push ecx
0040112B mov edx, dword ptr [ebp + 8]
0040112E push edx
0040112F call 0x663e3f
00401134 add esp, 0xc
00401137 pop ebp
00401138 ret 
; region 0x663e3f
00663E3F mov edi, edi
00663E41 push ebp
00663E42 mov ebp, esp
00663E44 push esi
00663E45 push edi
00663E46 mov edi, dword ptr [ebp + 0x10]
00663E49 mov eax, edi
00663E4B sub eax, 0
00663E4E je 0x665439
00663E54 dec eax
00663E55 je 0x665428
00663E5B dec eax
00663E5C je 0x6653fa
00663E62 dec eax
00663E63 je 0x6653b2
00663E69 dec eax
00663E6A je 0x665329
00663E70 mov ecx, dword ptr [ebp + 0xc]
00663E73 mov eax, dword ptr [ebp + 8]
00663E76 push ebx
00663E77 push 0x20
00663E79 pop edx
00663E7A jmp 0x6642f1
00663E7F mov esi, dword ptr [eax]
00663E81 cmp esi, dword ptr [ecx]
00663E83 je 0x663f01
00663E85 movzx esi, byte ptr [eax]
00663E88 movzx ebx, byte ptr [ecx]
00663E8B sub esi, ebx
00663E8D je 0x663ea4
00663E8F xor ebx, ebx
00663E91 test esi, esi
00663E93 setg bl
00663E96 lea ebx, [ebx + ebx - 1]
00663E9A mov esi, ebx
00663E9C test esi, esi
00663E9E jne 0x66430d
00663EA4 movzx esi, byte ptr [eax + 1]
00663EA8 movzx ebx, byte ptr [ecx + 1]
00663EAC sub esi, ebx
00663EAE je 0x663ec5
00663EB0 xor ebx, ebx
00663EB2 test esi, esi
00663EB4 setg bl
00663EB7 lea ebx, [ebx + ebx - 1]
00663EBB mov esi, ebx
00663EBD test esi, esi
00663EBF jne 0x66430d
