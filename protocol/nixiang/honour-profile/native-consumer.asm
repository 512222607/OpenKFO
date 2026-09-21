; SHA256=98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
00821890 push ebp
00821891 mov ebp, esp
00821893 sub esp, 8
00821896 mov dword ptr [ebp - 8], ecx
00821899 mov eax, dword ptr [ebp + 8]
0082189C mov dword ptr [ebp - 4], eax
0082189F mov ecx, dword ptr [ebp - 4]
008218A2 push ecx
008218A3 call 0x4162a0
008218A8 mov ecx, eax
008218AA call 0x882c20
008218AF mov esp, ebp
008218B1 pop ebp
008218B2 ret 8
00882C20 push ebp
00882C21 mov ebp, esp
00882C23 push -1
00882C25 push 0xaac49e
00882C2A mov eax, dword ptr fs:[0]
00882C30 push eax
00882C31 sub esp, 0x240
00882C37 mov eax, dword ptr [0xc7b480]
00882C3C xor eax, ebp
00882C3E push eax
00882C3F lea eax, [ebp - 0xc]
00882C42 mov dword ptr fs:[0], eax
00882C48 mov dword ptr [ebp - 0x21c], ecx
00882C4E mov eax, dword ptr [ebp + 8]
00882C51 cmp dword ptr [eax], 0
00882C54 jne 0x882c6a
00882C56 mov ecx, dword ptr [ebp + 8]
00882C59 push ecx
00882C5A mov ecx, dword ptr [ebp - 0x21c]
00882C60 call 0x882770
00882C65 jmp 0x883264
00882C6A mov dword ptr [ebp - 0x10], 0
00882C71 mov edx, dword ptr [0xb98f84]
00882C77 push edx
00882C78 lea ecx, [ebp - 0x38]
00882C7B call 0x405650
00882C80 mov dword ptr [ebp - 4], 0
00882C87 lea eax, [ebp - 0x38]
00882C8A push eax
00882C8B mov ecx, dword ptr [ebp - 0x21c]
00882C91 call 0x75fbf0
00882C96 mov dword ptr [ebp - 0x10], eax
00882C99 mov dword ptr [ebp - 4], 0xffffffff
00882CA0 lea ecx, [ebp - 0x38]
00882CA3 call 0x4056d0
00882CA8 cmp dword ptr [ebp - 0x10], 0
00882CAC je 0x882ce9
00882CAE mov ecx, dword ptr [ebp + 8]
00882CB1 add ecx, 0x24
00882CB4 push ecx
00882CB5 lea ecx, [ebp - 0x54]
00882CB8 call 0x405650
00882CBD mov dword ptr [ebp - 4], 1
00882CC4 push 1
00882CC6 lea edx, [ebp - 0x54]
00882CC9 push edx
00882CCA mov eax, dword ptr [ebp - 0x10]
00882CCD mov edx, dword ptr [eax]
00882CCF mov ecx, dword ptr [ebp - 0x10]
00882CD2 mov eax, dword ptr [edx + 0xd4]
00882CD8 call eax
00882CDA mov dword ptr [ebp - 4], 0xffffffff
00882CE1 lea ecx, [ebp - 0x54]
00882CE4 call 0x4056d0
00882CE9 mov ecx, dword ptr [0xb98f88]
00882CEF push ecx
00882CF0 lea ecx, [ebp - 0x70]
00882CF3 call 0x405650
00882CF8 mov dword ptr [ebp - 4], 2
00882CFF lea edx, [ebp - 0x70]
00882D02 push edx
00882D03 mov ecx, dword ptr [ebp - 0x21c]
00882D09 call 0x75fbf0
00882D0E mov dword ptr [ebp - 0x10], eax
00882D11 mov dword ptr [ebp - 4], 0xffffffff
00882D18 lea ecx, [ebp - 0x70]
00882D1B call 0x4056d0
00882D20 cmp dword ptr [ebp - 0x10], 0
00882D24 je 0x882dd1
00882D2A mov eax, dword ptr [ebp + 8]
00882D2D cmp dword ptr [eax + 0x10], 0
00882D31 jne 0x882d77
00882D33 push 0xbb3bc0
00882D38 lea ecx, [ebp - 0x8c]
00882D3E call 0x405650
00882D43 mov dword ptr [ebp - 4], 3
00882D4A push 1
00882D4C lea ecx, [ebp - 0x8c]
00882D52 push ecx
00882D53 mov edx, dword ptr [ebp - 0x10]
00882D56 mov eax, dword ptr [edx]
00882D58 mov ecx, dword ptr [ebp - 0x10]
00882D5B mov edx, dword ptr [eax + 0xd4]
00882D61 call edx
00882D63 mov dword ptr [ebp - 4], 0xffffffff
00882D6A lea ecx, [ebp - 0x8c]
00882D70 call 0x4056d0
00882D75 jmp 0x882dd1
00882D77 mov eax, dword ptr [ebp + 8]
00882D7A add eax, 0x10
00882D7D push eax
00882D7E lea ecx, [ebp - 0xa8]
00882D84 push ecx
00882D85 call 0xa44160
00882D8A add esp, 8
00882D8D mov dword ptr [ebp - 0x220], eax
00882D93 mov edx, dword ptr [ebp - 0x220]
00882D99 mov dword ptr [ebp - 0x224], edx
00882D9F mov dword ptr [ebp - 4], 4
00882DA6 push 1
00882DA8 mov eax, dword ptr [ebp - 0x224]
00882DAE push eax
00882DAF mov ecx, dword ptr [ebp - 0x10]
00882DB2 mov edx, dword ptr [ecx]
00882DB4 mov ecx, dword ptr [ebp - 0x10]
00882DB7 mov eax, dword ptr [edx + 0xd4]
00882DBD call eax
00882DBF mov dword ptr [ebp - 4], 0xffffffff
00882DC6 lea ecx, [ebp - 0xa8]
00882DCC call 0x4056d0
00882DD1 mov ecx, dword ptr [0xb98f8c]
00882DD7 push ecx
00882DD8 lea ecx, [ebp - 0xc4]
00882DDE call 0x405650
00882DE3 mov dword ptr [ebp - 4], 5
00882DEA lea edx, [ebp - 0xc4]
00882DF0 push edx
00882DF1 mov ecx, dword ptr [ebp - 0x21c]
00882DF7 call 0x75fbf0
00882DFC mov dword ptr [ebp - 0x10], eax
00882DFF mov dword ptr [ebp - 4], 0xffffffff
00882E06 lea ecx, [ebp - 0xc4]
00882E0C call 0x4056d0
00882E11 cmp dword ptr [ebp - 0x10], 0
00882E15 je 0x882e71
00882E17 mov eax, dword ptr [ebp + 8]
00882E1A add eax, 0x18
00882E1D push eax
00882E1E lea ecx, [ebp - 0xe0]
00882E24 push ecx
00882E25 call 0xa44160
00882E2A add esp, 8
00882E2D mov dword ptr [ebp - 0x228], eax
00882E33 mov edx, dword ptr [ebp - 0x228]
00882E39 mov dword ptr [ebp - 0x22c], edx
00882E3F mov dword ptr [ebp - 4], 6
00882E46 push 1
00882E48 mov eax, dword ptr [ebp - 0x22c]
00882E4E push eax
00882E4F mov ecx, dword ptr [ebp - 0x10]
00882E52 mov edx, dword ptr [ecx]
00882E54 mov ecx, dword ptr [ebp - 0x10]
00882E57 mov eax, dword ptr [edx + 0xd4]
00882E5D call eax
00882E5F mov dword ptr [ebp - 4], 0xffffffff
00882E66 lea ecx, [ebp - 0xe0]
00882E6C call 0x4056d0
00882E71 mov ecx, dword ptr [0xb98f94]
00882E77 push ecx
00882E78 lea ecx, [ebp - 0xfc]
00882E7E call 0x405650
00882E83 mov dword ptr [ebp - 4], 7
00882E8A lea edx, [ebp - 0xfc]
00882E90 push edx
00882E91 mov ecx, dword ptr [ebp - 0x21c]
00882E97 call 0x75fbf0
00882E9C mov dword ptr [ebp - 0x10], eax
00882E9F mov dword ptr [ebp - 4], 0xffffffff
00882EA6 lea ecx, [ebp - 0xfc]
00882EAC call 0x4056d0
00882EB1 cmp dword ptr [ebp - 0x10], 0
00882EB5 je 0x882f11
00882EB7 mov eax, dword ptr [ebp + 8]
00882EBA add eax, 0x14
00882EBD push eax
00882EBE lea ecx, [ebp - 0x118]
00882EC4 push ecx
00882EC5 call 0xa44160
00882ECA add esp, 8
00882ECD mov dword ptr [ebp - 0x230], eax
00882ED3 mov edx, dword ptr [ebp - 0x230]
00882ED9 mov dword ptr [ebp - 0x234], edx
00882EDF mov dword ptr [ebp - 4], 8
00882EE6 push 1
00882EE8 mov eax, dword ptr [ebp - 0x234]
00882EEE push eax
00882EEF mov ecx, dword ptr [ebp - 0x10]
00882EF2 mov edx, dword ptr [ecx]
00882EF4 mov ecx, dword ptr [ebp - 0x10]
00882EF7 mov eax, dword ptr [edx + 0xd4]
00882EFD call eax
00882EFF mov dword ptr [ebp - 4], 0xffffffff
00882F06 lea ecx, [ebp - 0x118]
00882F0C call 0x4056d0
00882F11 mov ecx, dword ptr [0xb98f98]
00882F17 push ecx
00882F18 lea ecx, [ebp - 0x134]
00882F1E call 0x405650
00882F23 mov dword ptr [ebp - 4], 9
00882F2A lea edx, [ebp - 0x134]
00882F30 push edx
00882F31 mov ecx, dword ptr [ebp - 0x21c]
00882F37 call 0x75fbf0
00882F3C mov dword ptr [ebp - 0x10], eax
00882F3F mov dword ptr [ebp - 4], 0xffffffff
00882F46 lea ecx, [ebp - 0x134]
00882F4C call 0x4056d0
00882F51 cmp dword ptr [ebp - 0x10], 0
00882F55 je 0x882fb1
00882F57 mov eax, dword ptr [ebp + 8]
00882F5A add eax, 0x1c
00882F5D push eax
00882F5E lea ecx, [ebp - 0x150]
00882F64 push ecx
00882F65 call 0xa44160
00882F6A add esp, 8
00882F6D mov dword ptr [ebp - 0x238], eax
00882F73 mov edx, dword ptr [ebp - 0x238]
00882F79 mov dword ptr [ebp - 0x23c], edx
00882F7F mov dword ptr [ebp - 4], 0xa
00882F86 push 1
00882F88 mov eax, dword ptr [ebp - 0x23c]
00882F8E push eax
00882F8F mov ecx, dword ptr [ebp - 0x10]
00882F92 mov edx, dword ptr [ecx]
00882F94 mov ecx, dword ptr [ebp - 0x10]
00882F97 mov eax, dword ptr [edx + 0xd4]
00882F9D call eax
00882F9F mov dword ptr [ebp - 4], 0xffffffff
00882FA6 lea ecx, [ebp - 0x150]
00882FAC call 0x4056d0
00882FB1 mov ecx, dword ptr [0xb98f9c]
00882FB7 push ecx
00882FB8 lea ecx, [ebp - 0x16c]
00882FBE call 0x405650
00882FC3 mov dword ptr [ebp - 4], 0xb
00882FCA lea edx, [ebp - 0x16c]
00882FD0 push edx
00882FD1 mov ecx, dword ptr [ebp - 0x21c]
00882FD7 call 0x75fbf0
00882FDC mov dword ptr [ebp - 0x10], eax
00882FDF mov dword ptr [ebp - 4], 0xffffffff
00882FE6 lea ecx, [ebp - 0x16c]
00882FEC call 0x4056d0
00882FF1 cmp dword ptr [ebp - 0x10], 0
00882FF5 je 0x883051
00882FF7 mov eax, dword ptr [ebp + 8]
00882FFA add eax, 0x20
00882FFD push eax
00882FFE lea ecx, [ebp - 0x188]
00883004 push ecx
00883005 call 0xa44160
0088300A add esp, 8
0088300D mov dword ptr [ebp - 0x240], eax
00883013 mov edx, dword ptr [ebp - 0x240]
00883019 mov dword ptr [ebp - 0x244], edx
0088301F mov dword ptr [ebp - 4], 0xc
00883026 push 1
00883028 mov eax, dword ptr [ebp - 0x244]
0088302E push eax
0088302F mov ecx, dword ptr [ebp - 0x10]
00883032 mov edx, dword ptr [ecx]
00883034 mov ecx, dword ptr [ebp - 0x10]
00883037 mov eax, dword ptr [edx + 0xd4]
0088303D call eax
0088303F mov dword ptr [ebp - 4], 0xffffffff
00883046 lea ecx, [ebp - 0x188]
0088304C call 0x4056d0
00883051 mov ecx, dword ptr [0xb98fa0]
00883057 push ecx
00883058 lea ecx, [ebp - 0x1a4]
0088305E call 0x405650
00883063 mov dword ptr [ebp - 4], 0xd
0088306A lea edx, [ebp - 0x1a4]
00883070 push edx
00883071 mov ecx, dword ptr [ebp - 0x21c]
00883077 call 0x75fbf0
0088307C mov dword ptr [ebp - 0x10], eax
0088307F mov dword ptr [ebp - 4], 0xffffffff
00883086 lea ecx, [ebp - 0x1a4]
0088308C call 0x4056d0
00883091 cmp dword ptr [ebp - 0x10], 0
00883095 je 0x883191
0088309B mov eax, dword ptr [ebp + 8]
0088309E cmp dword ptr [eax + 0x1c], 0
008830A2 jne 0x8830eb
008830A4 push 0xb9b354
008830A9 lea ecx, [ebp - 0x1c0]
008830AF call 0x405650
008830B4 mov dword ptr [ebp - 4], 0xe
008830BB push 1
008830BD lea ecx, [ebp - 0x1c0]
008830C3 push ecx
008830C4 mov edx, dword ptr [ebp - 0x10]
008830C7 mov eax, dword ptr [edx]
008830C9 mov ecx, dword ptr [ebp - 0x10]
008830CC mov edx, dword ptr [eax + 0xd4]
008830D2 call edx
008830D4 mov dword ptr [ebp - 4], 0xffffffff
008830DB lea ecx, [ebp - 0x1c0]
008830E1 call 0x4056d0
008830E6 jmp 0x883191
008830EB lea ecx, [ebp - 0x18]
008830EE call 0x405f90
008830F3 mov dword ptr [ebp - 4], 0xf
008830FA mov eax, dword ptr [ebp + 8]
008830FD fild dword ptr [eax + 0x20]
00883100 mov ecx, dword ptr [ebp + 8]
00883103 fidiv dword ptr [ecx + 0x1c]
00883106 fmul qword ptr [0xbe8460]
0088310C fstp dword ptr [ebp - 0x1c]
0088310F fld dword ptr [ebp - 0x1c]
00883112 fcomp qword ptr [0xbe8460]
00883118 fnstsw ax
0088311A test ah, 0x41
0088311D jne 0x883128
0088311F fld dword ptr [0xbe9b9c]
00883125 fstp dword ptr [ebp - 0x1c]
00883128 fld dword ptr [ebp - 0x1c]
0088312B sub esp, 8
0088312E fstp qword ptr [esp]
00883131 push 0xbc3288
00883136 lea edx, [ebp - 0x18]
00883139 push edx
0088313A call 0x411c60
0088313F add esp, 0x10
00883142 lea ecx, [ebp - 0x18]
00883145 call 0x406410
0088314A push eax
0088314B lea ecx, [ebp - 0x1dc]
00883151 call 0x405650
00883156 mov byte ptr [ebp - 4], 0x10
0088315A push 1
0088315C lea eax, [ebp - 0x1dc]
00883162 push eax
00883163 mov ecx, dword ptr [ebp - 0x10]
00883166 mov edx, dword ptr [ecx]
00883168 mov ecx, dword ptr [ebp - 0x10]
0088316B mov eax, dword ptr [edx + 0xd4]
00883171 call eax
00883173 mov byte ptr [ebp - 4], 0xf
00883177 lea ecx, [ebp - 0x1dc]
0088317D call 0x4056d0
00883182 mov dword ptr [ebp - 4], 0xffffffff
00883189 lea ecx, [ebp - 0x18]
0088318C call 0x406050
00883191 mov dword ptr [ebp - 0x14], 0
00883198 mov ecx, dword ptr [0xb98f90]
0088319E push ecx
0088319F lea ecx, [ebp - 0x1f8]
008831A5 call 0x405650
008831AA mov dword ptr [ebp - 4], 0x11
008831B1 lea edx, [ebp - 0x1f8]
008831B7 push edx
008831B8 mov ecx, dword ptr [ebp - 0x21c]
008831BE call 0x75fbf0
008831C3 mov dword ptr [ebp - 0x14], eax
008831C6 mov dword ptr [ebp - 4], 0xffffffff
008831CD lea ecx, [ebp - 0x1f8]
008831D3 call 0x4056d0
008831D8 cmp dword ptr [ebp - 0x14], 0
008831DC je 0x883264
008831E2 mov eax, dword ptr [ebp + 8]
008831E5 mov ecx, dword ptr [eax + 0x18]
008831E8 push ecx
008831E9 lea edx, [ebp - 0x218]
008831EF push edx
008831F0 mov ecx, dword ptr [ebp - 0x21c]
008831F6 call 0x7d22b0
008831FB mov dword ptr [ebp - 0x248], eax
00883201 mov eax, dword ptr [ebp - 0x248]
00883207 mov dword ptr [ebp - 0x24c], eax
0088320D mov dword ptr [ebp - 4], 0x12
00883214 mov ecx, dword ptr [ebp - 0x24c]
0088321A call 0x406410
0088321F push eax
00883220 lea ecx, [ebp - 0x214]
00883226 call 0x405650
0088322B mov byte ptr [ebp - 4], 0x13
0088322F lea ecx, [ebp - 0x214]
00883235 push ecx
00883236 mov edx, dword ptr [ebp - 0x14]
00883239 mov eax, dword ptr [edx]
0088323B mov ecx, dword ptr [ebp - 0x14]
0088323E mov edx, dword ptr [eax + 0x28]
00883241 call edx
00883243 mov byte ptr [ebp - 4], 0x12
00883247 lea ecx, [ebp - 0x214]
0088324D call 0x4056d0
00883252 mov dword ptr [ebp - 4], 0xffffffff
00883259 lea ecx, [ebp - 0x218]
0088325F call 0x406050
00883264 mov ecx, dword ptr [ebp - 0xc]
00883267 mov dword ptr fs:[0], ecx
0088326E pop ecx
0088326F mov esp, ebp
00883271 pop ebp
00883EA0 push ebp
00883EA1 mov ebp, esp
00883EA3 push -1
00883EA5 push 0xab7c33
00883EAA mov eax, dword ptr fs:[0]
00883EB0 push eax
00883EB1 sub esp, 0xa0
00883EB7 mov eax, dword ptr [0xc7b480]
00883EBC xor eax, ebp
00883EBE push eax
00883EBF lea eax, [ebp - 0xc]
00883EC2 mov dword ptr fs:[0], eax
00883EC8 mov dword ptr [ebp - 0xac], ecx
00883ECE mov eax, dword ptr [0xb98ea4]
00883ED3 push eax
00883ED4 lea ecx, [ebp - 0x38]
00883ED7 call 0x405650
00883EDC mov dword ptr [ebp - 4], 0
00883EE3 push 1
00883EE5 lea ecx, [ebp - 0x38]
00883EE8 push ecx
00883EE9 mov ecx, dword ptr [ebp - 0xac]
00883EEF call 0x7611c0
00883EF4 mov dword ptr [ebp - 4], 0xffffffff
00883EFB lea ecx, [ebp - 0x38]
00883EFE call 0x4056d0
00883F03 mov edx, dword ptr [0xb98ea0]
00883F09 push edx
00883F0A lea ecx, [ebp - 0x54]
00883F0D call 0x405650
00883F12 mov dword ptr [ebp - 4], 1
00883F19 push 0
00883F1B lea eax, [ebp - 0x54]
00883F1E push eax
00883F1F mov ecx, dword ptr [ebp - 0xac]
00883F25 call 0x7611c0
00883F2A mov dword ptr [ebp - 4], 0xffffffff
00883F31 lea ecx, [ebp - 0x54]
00883F34 call 0x4056d0
00883F39 mov ecx, dword ptr [0xb98ea8]
00883F3F push ecx
00883F40 lea ecx, [ebp - 0x70]
00883F43 call 0x405650
00883F48 mov dword ptr [ebp - 4], 2
00883F4F push 0
00883F51 lea edx, [ebp - 0x70]
00883F54 push edx
00883F55 mov ecx, dword ptr [ebp - 0xac]
00883F5B call 0x7611c0
00883F60 mov dword ptr [ebp - 4], 0xffffffff
00883F67 lea ecx, [ebp - 0x70]
00883F6A call 0x4056d0
00883F6F mov eax, dword ptr [0xb98eac]
00883F74 push eax
00883F75 lea ecx, [ebp - 0x8c]
00883F7B call 0x405650
00883F80 mov dword ptr [ebp - 4], 3
00883F87 push 0
00883F89 lea ecx, [ebp - 0x8c]
00883F8F push ecx
00883F90 mov ecx, dword ptr [ebp - 0xac]
00883F96 call 0x7611c0
00883F9B mov dword ptr [ebp - 4], 0xffffffff
00883FA2 lea ecx, [ebp - 0x8c]
00883FA8 call 0x4056d0
00883FAD mov edx, dword ptr [0xb98eb0]
00883FB3 push edx
00883FB4 lea ecx, [ebp - 0xa8]
00883FBA call 0x405650
00883FBF mov dword ptr [ebp - 4], 4
00883FC6 push 0
00883FC8 lea eax, [ebp - 0xa8]
00883FCE push eax
00883FCF mov ecx, dword ptr [ebp - 0xac]
00883FD5 call 0x7611c0
00883FDA mov dword ptr [ebp - 4], 0xffffffff
00883FE1 lea ecx, [ebp - 0xa8]
00883FE7 call 0x4056d0
00883FEC mov ecx, dword ptr [0xb98e50]
00883FF2 push ecx
00883FF3 mov ecx, dword ptr [ebp - 0xac]
00883FF9 add ecx, 0x5cc
00883FFF call 0x405710
00884004 mov edx, dword ptr [ebp - 0xac]
0088400A add edx, 0x5cc
00884010 push edx
00884011 mov ecx, dword ptr [ebp - 0xac]
00884017 call 0x75fbf0
0088401C mov dword ptr [ebp - 0x1c], eax
0088401F cmp dword ptr [ebp - 0x1c], 0
00884023 je 0x88402f
00884025 push 1
00884027 mov ecx, dword ptr [ebp - 0x1c]
0088402A call 0x750a70
0088402F push 0xc
00884031 push 0
00884033 lea eax, [ebp - 0x18]
00884036 push eax
00884037 call 0x666960
0088403C add esp, 0xc
0088403F mov ecx, dword ptr [ebp - 0xac]
00884045 call 0x881200
0088404A mov ecx, eax
0088404C call 0x401000
00884051 mov dword ptr [ebp - 0x18], eax
00884054 mov dword ptr [ebp - 0x14], edx
00884057 mov ecx, dword ptr [ebp - 0xac]
0088405D mov edx, dword ptr [ecx + 0x754]
00884063 mov dword ptr [ebp - 0x10], edx
00884066 push 0xc
00884068 lea eax, [ebp - 0x18]
0088406B push eax
0088406C push 0
0088406E push 0x4f88
00884073 call 0xa3c950
00884078 add esp, 0x10
0088407B mov ecx, dword ptr [ebp - 0xc]
0088407E mov dword ptr fs:[0], ecx
00884085 pop ecx
00884086 mov esp, ebp
00884088 pop ebp
00884089 ret
00886EF0 push ebp
00886EF1 mov ebp, esp
00886EF3 push -1
00886EF5 push 0xacf45c
00886EFA mov eax, dword ptr fs:[0]
00886F00 push eax
00886F01 sub esp, 0xe4
00886F07 mov eax, dword ptr [0xc7b480]
00886F0C xor eax, ebp
00886F0E push eax
00886F0F lea eax, [ebp - 0xc]
00886F12 mov dword ptr fs:[0], eax
00886F18 mov dword ptr [ebp - 0xf0], ecx
00886F1E call 0x4164e0
00886F23 mov ecx, eax
00886F25 call 0x4f4570
00886F2A cmp dword ptr [eax], 1
00886F2D jne 0x886f9f
00886F2F mov eax, dword ptr [0xb98fa4]
00886F34 push eax
00886F35 lea ecx, [ebp - 0x28]
00886F38 call 0x405650
00886F3D mov dword ptr [ebp - 4], 0
00886F44 push 0
00886F46 lea ecx, [ebp - 0x28]
00886F49 push ecx
00886F4A mov ecx, dword ptr [ebp - 0xf0]
00886F50 call 0x7603d0
00886F55 mov dword ptr [ebp - 4], 0xffffffff
00886F5C lea ecx, [ebp - 0x28]
00886F5F call 0x4056d0
00886F64 mov edx, dword ptr [0xb98fa8]
00886F6A push edx
00886F6B lea ecx, [ebp - 0x44]
00886F6E call 0x405650
00886F73 mov dword ptr [ebp - 4], 1
00886F7A push 0
00886F7C lea eax, [ebp - 0x44]
00886F7F push eax
00886F80 mov ecx, dword ptr [ebp - 0xf0]
00886F86 call 0x7603d0
00886F8B mov dword ptr [ebp - 4], 0xffffffff
00886F92 lea ecx, [ebp - 0x44]
00886F95 call 0x4056d0
00886F9A jmp 0x887137
00886F9F mov ecx, dword ptr [ebp - 0xf0]
00886FA5 cmp dword ptr [ecx + 0x754], 1
00886FAC jne 0x88701f
00886FAE mov edx, dword ptr [0xb98fa4]
00886FB4 push edx
00886FB5 lea ecx, [ebp - 0x60]
00886FB8 call 0x405650
00886FBD mov dword ptr [ebp - 4], 2
00886FC4 push 0
00886FC6 lea eax, [ebp - 0x60]
00886FC9 push eax
00886FCA mov ecx, dword ptr [ebp - 0xf0]
00886FD0 call 0x7603d0
00886FD5 mov dword ptr [ebp - 4], 0xffffffff
00886FDC lea ecx, [ebp - 0x60]
00886FDF call 0x4056d0
00886FE4 mov ecx, dword ptr [0xb98fa8]
00886FEA push ecx
00886FEB lea ecx, [ebp - 0x7c]
00886FEE call 0x405650
00886FF3 mov dword ptr [ebp - 4], 3
00886FFA push 1
00886FFC lea edx, [ebp - 0x7c]
00886FFF push edx
00887000 mov ecx, dword ptr [ebp - 0xf0]
00887006 call 0x7603d0
0088700B mov dword ptr [ebp - 4], 0xffffffff
00887012 lea ecx, [ebp - 0x7c]
00887015 call 0x4056d0
0088701A jmp 0x887137
0088701F call 0x4164e0
00887024 mov ecx, eax
00887026 call 0x4f4570
0088702B mov ecx, dword ptr [ebp - 0xf0]
00887031 mov edx, dword ptr [ecx + 0x754]
00887037 cmp edx, dword ptr [eax]
00887039 jne 0x8870ba
0088703B mov eax, dword ptr [0xb98fa4]
00887040 push eax
00887041 lea ecx, [ebp - 0x98]
00887047 call 0x405650
0088704C mov dword ptr [ebp - 4], 4
00887053 push 1
00887055 lea ecx, [ebp - 0x98]
0088705B push ecx
0088705C mov ecx, dword ptr [ebp - 0xf0]
00887062 call 0x7603d0
00887067 mov dword ptr [ebp - 4], 0xffffffff
0088706E lea ecx, [ebp - 0x98]
00887074 call 0x4056d0
00887079 mov edx, dword ptr [0xb98fa8]
0088707F push edx
00887080 lea ecx, [ebp - 0xb4]
00887086 call 0x405650
0088708B mov dword ptr [ebp - 4], 5
00887092 push 0
00887094 lea eax, [ebp - 0xb4]
0088709A push eax
0088709B mov ecx, dword ptr [ebp - 0xf0]
008870A1 call 0x7603d0
008870A6 mov dword ptr [ebp - 4], 0xffffffff
008870AD lea ecx, [ebp - 0xb4]
008870B3 call 0x4056d0
008870B8 jmp 0x887137
008870BA mov ecx, dword ptr [0xb98fa4]
008870C0 push ecx
008870C1 lea ecx, [ebp - 0xd0]
008870C7 call 0x405650
008870CC mov dword ptr [ebp - 4], 6
008870D3 push 1
008870D5 lea edx, [ebp - 0xd0]
008870DB push edx
008870DC mov ecx, dword ptr [ebp - 0xf0]
008870E2 call 0x7603d0
008870E7 mov dword ptr [ebp - 4], 0xffffffff
008870EE lea ecx, [ebp - 0xd0]
008870F4 call 0x4056d0
008870F9 mov eax, dword ptr [0xb98fa8]
008870FE push eax
008870FF lea ecx, [ebp - 0xec]
00887105 call 0x405650
0088710A mov dword ptr [ebp - 4], 7
00887111 push 1
00887113 lea ecx, [ebp - 0xec]
00887119 push ecx
0088711A mov ecx, dword ptr [ebp - 0xf0]
00887120 call 0x7603d0
00887125 mov dword ptr [ebp - 4], 0xffffffff
0088712C lea ecx, [ebp - 0xec]
00887132 call 0x4056d0
00887137 mov ecx, dword ptr [ebp - 0xc]
0088713A mov dword ptr fs:[0], ecx
00887141 pop ecx
00887142 mov esp, ebp
00887144 pop ebp
00887145 ret
00887150 push ebp
00887151 mov ebp, esp
00887153 sub esp, 0x10
00887156 mov dword ptr [ebp - 0x10], ecx
00887159 push 0xc
0088715B push 0
0088715D lea eax, [ebp - 0xc]
00887160 push eax
00887161 call 0x666960
00887166 add esp, 0xc
00887169 mov ecx, dword ptr [ebp - 0x10]
0088716C call 0x881200
00887171 mov ecx, eax
00887173 call 0x401000
00887178 mov dword ptr [ebp - 0xc], eax
0088717B mov dword ptr [ebp - 8], edx
0088717E mov ecx, dword ptr [ebp - 0x10]
00887181 mov edx, dword ptr [ecx + 0x754]
00887187 add edx, 1
0088718A mov eax, dword ptr [ebp - 0x10]
0088718D mov dword ptr [eax + 0x754], edx
00887193 mov ecx, dword ptr [ebp - 0x10]
00887196 mov edx, dword ptr [ecx + 0x754]
0088719C mov dword ptr [ebp - 4], edx
0088719F push 0xc
008871A1 lea eax, [ebp - 0xc]
008871A4 push eax
008871A5 push 0
008871A7 push 0x4f88
008871AC call 0xa3c950
008871B1 add esp, 0x10
008871B4 mov ecx, dword ptr [ebp - 0x10]
008871B7 call 0x886ef0
008871BC mov esp, ebp
008871BE pop ebp
008871BF ret
004F4570 push ebp
004F4571 mov ebp, esp
004F4573 push ecx
004F4574 mov dword ptr [ebp - 4], ecx
004F4577 mov eax, dword ptr [ebp - 4]
004F457A add eax, 0x18c
004F457F mov esp, ebp
004F4581 pop ebp
004F4582 ret
007D22B0 push ebp
007D22B1 mov ebp, esp
007D22B3 push -1
007D22B5 push 0xaa39ad
007D22BA mov eax, dword ptr fs:[0]
007D22C0 push eax
007D22C1 sub esp, 0xc
007D22C4 mov eax, dword ptr [0xc7b480]
007D22C9 xor eax, ebp
007D22CB push eax
007D22CC lea eax, [ebp - 0xc]
007D22CF mov dword ptr fs:[0], eax
007D22D5 mov dword ptr [ebp - 0x18], ecx
007D22D8 mov dword ptr [ebp - 0x14], 0
007D22DF lea ecx, [ebp - 0x10]
007D22E2 call 0x405f90
007D22E7 mov dword ptr [ebp - 4], 0
007D22EE mov eax, dword ptr [ebp + 0xc]
007D22F1 push eax
007D22F2 push 0xbb3bd8
007D22F7 lea ecx, [ebp - 0x10]
007D22FA push ecx
007D22FB call 0x411c60
007D2300 add esp, 0xc
007D2303 lea edx, [ebp - 0x10]
007D2306 push edx
007D2307 mov ecx, dword ptr [ebp + 8]
007D230A call 0x405fb0
007D230F mov eax, dword ptr [ebp - 0x14]
007D2312 or eax, 1
007D2315 mov dword ptr [ebp - 0x14], eax
007D2318 mov dword ptr [ebp - 4], 0xffffffff
007D231F lea ecx, [ebp - 0x10]
007D2322 call 0x406050
007D2327 mov eax, dword ptr [ebp + 8]
007D232A mov ecx, dword ptr [ebp - 0xc]
007D232D mov dword ptr fs:[0], ecx
007D2334 pop ecx
007D2335 mov esp, ebp
007D2337 pop ebp
007D2338 ret 8
; 00B98E40 -> 00BC31A8 RoleInfo.sui
; 00B98E3C -> 00BC31B8 frmRoleInfo
; 00B98F84 -> 00BC2E70 txtDescription
; 00B98F88 -> 00BC2E60 txtHonourRank
; 00B98F8C -> 00BC2E50 txtHonourLevel
; 00B98F90 -> 00BB3680 anmHonourLevel
; 00B98F94 -> 00BC2E44 txtHonour
; 00B98F98 -> 00BC2E2C txtChallengeBattleTimes
; 00B98F9C -> 00BC2E20 txtWinTimes
; 00B98FA0 -> 00BC2E14 txtWinRate
