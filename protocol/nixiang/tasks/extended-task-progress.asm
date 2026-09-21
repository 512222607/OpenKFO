; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; function 0x542830
00542830 push     ebp
00542831 mov      ebp, esp
00542833 push     -1
00542835 push     0xaeb4f0
0054283A mov      eax, dword ptr fs:[0]
00542840 push     eax
00542841 sub      esp, 0x3b8
00542847 push     esi
00542848 mov      eax, dword ptr [0xc7b480]
0054284D xor      eax, ebp
0054284F push     eax
00542850 lea      eax, [ebp - 0xc]
00542853 mov      dword ptr fs:[0], eax
00542859 mov      dword ptr [ebp - 0x320], ecx
0054285F mov      ecx, dword ptr [ebp - 0x320]
00542865 call     0x53c030
0054286A mov      ecx, dword ptr [ebp - 0x320]
00542870 call     0x53c300
00542875 lea      eax, [ebp - 0x2c]
00542878 push     eax
00542879 call     0xa4b950
0054287E mov      ecx, eax
00542880 call     0xa489e0
00542885 mov      dword ptr [ebp - 4], 0
0054288C lea      ecx, [ebp - 0x2c]
0054288F call     0x4c50a0
00542894 movzx    ecx, al
00542897 test     ecx, ecx
00542899 je       0x5428af
0054289B mov      dword ptr [ebp - 4], 0xffffffff
005428A2 lea      ecx, [ebp - 0x2c]
005428A5 call     0x4c5520
005428AA jmp      0x5430ea
005428AF mov      dword ptr [ebp - 0x14], 0
005428B6 mov      dword ptr [ebp - 0x38], 0
005428BD call     0x4e7570
005428C2 mov      dword ptr [ebp - 0x3c], eax
005428C5 mov      dword ptr [ebp - 0x34], 0
005428CC mov      dword ptr [ebp - 0x30], 0
005428D3 mov      ecx, dword ptr [ebp - 0x320]
005428D9 call     0x462480
005428DE mov      dword ptr [ebp - 0x10], eax
005428E1 mov      dword ptr [ebp - 0x40], 0
005428E8 jmp      0x5428f3
005428EA mov      edx, dword ptr [ebp - 0x40]
005428ED add      edx, 1
005428F0 mov      dword ptr [ebp - 0x40], edx
005428F3 cmp      dword ptr [ebp - 0x40], 0xc
005428F7 je       0x5430d0
005428FD lea      eax, [ebp - 0x40]
00542900 push     eax
00542901 lea      ecx, [ebp - 0x60]
00542904 push     ecx
00542905 call     0x4b9190
0054290A add      esp, 8
0054290D mov      dword ptr [ebp - 0x324], eax
00542913 mov      edx, dword ptr [ebp - 0x324]
00542919 mov      dword ptr [ebp - 0x328], edx
0054291F mov      byte ptr [ebp - 4], 1
00542923 mov      eax, dword ptr [ebp - 0x328]
00542929 push     eax
0054292A mov      ecx, dword ptr [0xb973d4]
00542930 push     ecx
00542931 lea      edx, [ebp - 0x7c]
00542934 push     edx
00542935 call     0x411d70
0054293A add      esp, 0xc
0054293D mov      dword ptr [ebp - 0x32c], eax
00542943 mov      eax, dword ptr [ebp - 0x32c]
00542949 mov      dword ptr [ebp - 0x330], eax
0054294F mov      byte ptr [ebp - 4], 2
00542953 mov      ecx, dword ptr [ebp - 0x330]
00542959 push     ecx
0054295A mov      ecx, dword ptr [ebp - 0x3c]
0054295D call     0x75fbf0
00542962 mov      dword ptr [ebp - 0x34], eax
00542965 mov      byte ptr [ebp - 4], 1
00542969 lea      ecx, [ebp - 0x7c]
0054296C call     0x4056d0
00542971 mov      byte ptr [ebp - 4], 0
00542975 lea      ecx, [ebp - 0x60]
00542978 call     0x4056d0
0054297D cmp      dword ptr [ebp - 0x34], 0
00542981 je       0x5429ba
00542983 push     0xb96699
00542988 lea      ecx, [ebp - 0x98]
0054298E call     0x405650
00542993 mov      byte ptr [ebp - 4], 3
00542997 lea      edx, [ebp - 0x98]
0054299D push     edx
0054299E mov      eax, dword ptr [ebp - 0x34]
005429A1 mov      edx, dword ptr [eax]
005429A3 mov      ecx, dword ptr [ebp - 0x34]
005429A6 mov      eax, dword ptr [edx + 0x28]
005429A9 call     eax
005429AB mov      byte ptr [ebp - 4], 0
005429AF lea      ecx, [ebp - 0x98]
005429B5 call     0x4056d0
005429BA lea      ecx, [ebp - 0x40]
005429BD push     ecx
005429BE lea      edx, [ebp - 0xb4]
005429C4 push     edx
005429C5 call     0x4b9190
005429CA add      esp, 8
005429CD mov      dword ptr [ebp - 0x334], eax
005429D3 mov      eax, dword ptr [ebp - 0x334]
005429D9 mov      dword ptr [ebp - 0x338], eax
005429DF mov      byte ptr [ebp - 4], 4
005429E3 mov      ecx, dword ptr [ebp - 0x338]
005429E9 push     ecx
005429EA mov      edx, dword ptr [0xb973d8]
005429F0 push     edx
005429F1 lea      eax, [ebp - 0xd0]
005429F7 push     eax
005429F8 call     0x411d70
005429FD add      esp, 0xc
00542A00 mov      dword ptr [ebp - 0x33c], eax
00542A06 mov      ecx, dword ptr [ebp - 0x33c]
00542A0C mov      dword ptr [ebp - 0x340], ecx
00542A12 mov      byte ptr [ebp - 4], 5
00542A16 push     1
00542A18 mov      edx, dword ptr [ebp - 0x340]
00542A1E push     edx
00542A1F mov      ecx, dword ptr [ebp - 0x3c]
00542A22 call     0x7611c0
00542A27 mov      byte ptr [ebp - 4], 4
00542A2B lea      ecx, [ebp - 0xd0]
00542A31 call     0x4056d0
00542A36 mov      byte ptr [ebp - 4], 0
00542A3A lea      ecx, [ebp - 0xb4]
00542A40 call     0x4056d0
00542A45 lea      eax, [ebp - 0x40]
00542A48 push     eax
00542A49 lea      ecx, [ebp - 0xec]
00542A4F push     ecx
00542A50 call     0x4b9190
00542A55 add      esp, 8
00542A58 mov      dword ptr [ebp - 0x344], eax
00542A5E mov      edx, dword ptr [ebp - 0x344]
00542A64 mov      dword ptr [ebp - 0x348], edx
00542A6A mov      byte ptr [ebp - 4], 6
00542A6E mov      eax, dword ptr [ebp - 0x348]
00542A74 push     eax
00542A75 mov      ecx, dword ptr [0xb973dc]
00542A7B push     ecx
00542A7C lea      edx, [ebp - 0x108]
00542A82 push     edx
00542A83 call     0x411d70
00542A88 add      esp, 0xc
00542A8B mov      dword ptr [ebp - 0x34c], eax
00542A91 mov      eax, dword ptr [ebp - 0x34c]
00542A97 mov      dword ptr [ebp - 0x350], eax
00542A9D mov      byte ptr [ebp - 4], 7
00542AA1 push     1
00542AA3 mov      ecx, dword ptr [ebp - 0x350]
00542AA9 push     ecx
00542AAA mov      ecx, dword ptr [ebp - 0x3c]
00542AAD call     0x7611c0
00542AB2 mov      byte ptr [ebp - 4], 6
00542AB6 lea      ecx, [ebp - 0x108]
00542ABC call     0x4056d0
00542AC1 mov      byte ptr [ebp - 4], 0
00542AC5 lea      ecx, [ebp - 0xec]
00542ACB call     0x4056d0
00542AD0 lea      edx, [ebp - 0x40]
00542AD3 push     edx
00542AD4 lea      eax, [ebp - 0x124]
00542ADA push     eax
00542ADB call     0x4b9190
00542AE0 add      esp, 8
00542AE3 mov      dword ptr [ebp - 0x354], eax
00542AE9 mov      ecx, dword ptr [ebp - 0x354]
00542AEF mov      dword ptr [ebp - 0x358], ecx
00542AF5 mov      byte ptr [ebp - 4], 8
00542AF9 mov      edx, dword ptr [ebp - 0x358]
00542AFF push     edx
00542B00 mov      eax, dword ptr [0xb973d0]
00542B05 push     eax
00542B06 lea      ecx, [ebp - 0x140]
00542B0C push     ecx
00542B0D call     0x411d70
00542B12 add      esp, 0xc
00542B15 mov      dword ptr [ebp - 0x35c], eax
00542B1B mov      edx, dword ptr [ebp - 0x35c]
00542B21 mov      dword ptr [ebp - 0x360], edx
00542B27 mov      byte ptr [ebp - 4], 9
00542B2B push     0
00542B2D mov      eax, dword ptr [ebp - 0x360]
00542B33 push     eax
00542B34 mov      ecx, dword ptr [ebp - 0x3c]
00542B37 call     0x7603d0
00542B3C mov      byte ptr [ebp - 4], 8
00542B40 lea      ecx, [ebp - 0x140]
00542B46 call     0x4056d0
00542B4B mov      byte ptr [ebp - 4], 0
00542B4F lea      ecx, [ebp - 0x124]
00542B55 call     0x4056d0
00542B5A mov      esi, dword ptr [ebp - 0x10]
00542B5D imul     esi, esi, 0xc
00542B60 add      esi, dword ptr [ebp - 0x40]
00542B63 lea      ecx, [ebp - 0x2c]
00542B66 call     0x55f000
00542B6B cmp      esi, eax
00542B6D jb       0x542b74
00542B6F jmp      0x5428ea
00542B74 lea      ecx, [ebp - 0x40]
00542B77 push     ecx
00542B78 lea      edx, [ebp - 0x15c]
00542B7E push     edx
00542B7F call     0x4b9190
00542B84 add      esp, 8
00542B87 mov      dword ptr [ebp - 0x364], eax
00542B8D mov      eax, dword ptr [ebp - 0x364]
00542B93 mov      dword ptr [ebp - 0x368], eax
00542B99 mov      byte ptr [ebp - 4], 0xa
00542B9D mov      ecx, dword ptr [ebp - 0x368]
00542BA3 push     ecx
00542BA4 mov      edx, dword ptr [0xb973d4]
00542BAA push     edx
00542BAB lea      eax, [ebp - 0x178]
00542BB1 push     eax
00542BB2 call     0x411d70
00542BB7 add      esp, 0xc
00542BBA mov      dword ptr [ebp - 0x36c], eax
00542BC0 mov      ecx, dword ptr [ebp - 0x36c]
00542BC6 mov      dword ptr [ebp - 0x370], ecx
00542BCC mov      byte ptr [ebp - 4], 0xb
00542BD0 push     1
00542BD2 mov      edx, dword ptr [ebp - 0x370]
00542BD8 push     edx
00542BD9 mov      ecx, dword ptr [ebp - 0x3c]
00542BDC call     0x7611c0
00542BE1 mov      byte ptr [ebp - 4], 0xa
00542BE5 lea      ecx, [ebp - 0x178]
00542BEB call     0x4056d0
00542BF0 mov      byte ptr [ebp - 4], 0
00542BF4 lea      ecx, [ebp - 0x15c]
00542BFA call     0x4056d0
00542BFF lea      eax, [ebp - 0x40]
00542C02 push     eax
00542C03 lea      ecx, [ebp - 0x194]
00542C09 push     ecx
00542C0A call     0x4b9190
00542C0F add      esp, 8
00542C12 mov      dword ptr [ebp - 0x374], eax
00542C18 mov      edx, dword ptr [ebp - 0x374]
00542C1E mov      dword ptr [ebp - 0x378], edx
00542C24 mov      byte ptr [ebp - 4], 0xc
00542C28 mov      eax, dword ptr [ebp - 0x378]
00542C2E push     eax
00542C2F mov      ecx, dword ptr [0xb973d8]
00542C35 push     ecx
00542C36 lea      edx, [ebp - 0x1b0]
00542C3C push     edx
00542C3D call     0x411d70
00542C42 add      esp, 0xc
00542C45 mov      dword ptr [ebp - 0x37c], eax
00542C4B mov      eax, dword ptr [ebp - 0x37c]
00542C51 mov      dword ptr [ebp - 0x380], eax
00542C57 mov      byte ptr [ebp - 4], 0xd
00542C5B mov      ecx, dword ptr [ebp - 0x380]
00542C61 push     ecx
00542C62 mov      ecx, dword ptr [ebp - 0x3c]
00542C65 call     0x75fbf0
00542C6A mov      dword ptr [ebp - 0x30], eax
00542C6D mov      byte ptr [ebp - 4], 0xc
00542C71 lea      ecx, [ebp - 0x1b0]
00542C77 call     0x4056d0
00542C7C mov      byte ptr [ebp - 4], 0
00542C80 lea      ecx, [ebp - 0x194]
00542C86 call     0x4056d0
00542C8B cmp      dword ptr [ebp - 0x30], 0
00542C8F je       0x5430cb
00542C95 mov      edx, dword ptr [ebp - 0x10]
00542C98 imul     edx, edx, 0xc
00542C9B add      edx, dword ptr [ebp - 0x40]
00542C9E push     edx
00542C9F call     0xa4b950
00542CA4 mov      ecx, eax
00542CA6 call     0xa47ab0
00542CAB mov      dword ptr [ebp - 0x14], eax
00542CAE cmp      dword ptr [ebp - 0x14], 0
00542CB2 jne      0x542cb9
00542CB4 jmp      0x5428ea
00542CB9 mov      eax, dword ptr [ebp - 0x14]
00542CBC movzx    ecx, word ptr [eax + 0xc]
00542CC0 push     ecx
00542CC1 call     0xa4b950
00542CC6 mov      ecx, eax
00542CC8 call     0xa47530
00542CCD mov      dword ptr [ebp - 0x38], eax
00542CD0 cmp      dword ptr [ebp - 0x38], 0
00542CD4 jne      0x542cdb
00542CD6 jmp      0x5428ea
00542CDB mov      ecx, dword ptr [ebp - 0x38]
00542CDE add      ecx, 0xdc
00542CE4 call     0x405750
00542CE9 push     eax
00542CEA lea      ecx, [ebp - 0x1cc]
00542CF0 call     0x405650
00542CF5 mov      byte ptr [ebp - 4], 0xe
00542CF9 push     1
00542CFB lea      edx, [ebp - 0x1cc]
00542D01 push     edx
00542D02 mov      eax, dword ptr [ebp - 0x30]
00542D05 mov      edx, dword ptr [eax]
00542D07 mov      ecx, dword ptr [ebp - 0x30]
00542D0A mov      eax, dword ptr [edx + 0xd4]
00542D10 call     eax
00542D12 mov      byte ptr [ebp - 4], 0
00542D16 lea      ecx, [ebp - 0x1cc]
00542D1C call     0x4056d0
00542D21 lea      ecx, [ebp - 0x40]
00542D24 push     ecx
00542D25 lea      edx, [ebp - 0x1e8]
00542D2B push     edx
00542D2C call     0x4b9190
00542D31 add      esp, 8
00542D34 mov      dword ptr [ebp - 0x384], eax
00542D3A mov      eax, dword ptr [ebp - 0x384]
00542D40 mov      dword ptr [ebp - 0x388], eax
00542D46 mov      byte ptr [ebp - 4], 0xf
00542D4A mov      ecx, dword ptr [ebp - 0x388]
00542D50 push     ecx
00542D51 mov      edx, dword ptr [0xb973d0]
00542D57 push     edx
00542D58 lea      eax, [ebp - 0x204]
00542D5E push     eax
00542D5F call     0x411d70
00542D64 add      esp, 0xc
00542D67 mov      dword ptr [ebp - 0x38c], eax
00542D6D mov      ecx, dword ptr [ebp - 0x38c]
00542D73 mov      dword ptr [ebp - 0x390], ecx
00542D79 mov      byte ptr [ebp - 4], 0x10
00542D7D push     1
00542D7F mov      edx, dword ptr [ebp - 0x390]
00542D85 push     edx
00542D86 mov      ecx, dword ptr [ebp - 0x3c]
00542D89 call     0x7603d0
00542D8E mov      byte ptr [ebp - 4], 0xf
00542D92 lea      ecx, [ebp - 0x204]
00542D98 call     0x4056d0
00542D9D mov      byte ptr [ebp - 4], 0
00542DA1 lea      ecx, [ebp - 0x1e8]
00542DA7 call     0x4056d0
00542DAC lea      eax, [ebp - 0x40]
00542DAF push     eax
00542DB0 lea      ecx, [ebp - 0x220]
00542DB6 push     ecx
00542DB7 call     0x4b9190
00542DBC add      esp, 8
00542DBF mov      dword ptr [ebp - 0x394], eax
00542DC5 mov      edx, dword ptr [ebp - 0x394]
00542DCB mov      dword ptr [ebp - 0x398], edx
00542DD1 mov      byte ptr [ebp - 4], 0x11
00542DD5 mov      eax, dword ptr [ebp - 0x398]
00542DDB push     eax
00542DDC mov      ecx, dword ptr [0xb973d4]
00542DE2 push     ecx
00542DE3 lea      edx, [ebp - 0x23c]
00542DE9 push     edx
00542DEA call     0x411d70
00542DEF add      esp, 0xc
00542DF2 mov      dword ptr [ebp - 0x39c], eax
00542DF8 mov      eax, dword ptr [ebp - 0x39c]
00542DFE mov      dword ptr [ebp - 0x3a0], eax
00542E04 mov      byte ptr [ebp - 4], 0x12
00542E08 push     1
00542E0A mov      ecx, dword ptr [ebp - 0x3a0]
00542E10 push     ecx
00542E11 mov      ecx, dword ptr [ebp - 0x3c]
00542E14 call     0x7611c0
00542E19 mov      byte ptr [ebp - 4], 0x11
00542E1D lea      ecx, [ebp - 0x23c]
00542E23 call     0x4056d0
00542E28 mov      byte ptr [ebp - 4], 0
00542E2C lea      ecx, [ebp - 0x220]
00542E32 call     0x4056d0
00542E37 lea      edx, [ebp - 0x40]
00542E3A push     edx
00542E3B lea      eax, [ebp - 0x258]
00542E41 push     eax
00542E42 call     0x4b9190
00542E47 add      esp, 8
00542E4A mov      dword ptr [ebp - 0x3a4], eax
00542E50 mov      ecx, dword ptr [ebp - 0x3a4]
00542E56 mov      dword ptr [ebp - 0x3a8], ecx
00542E5C mov      byte ptr [ebp - 4], 0x13
00542E60 mov      edx, dword ptr [ebp - 0x3a8]
00542E66 push     edx
00542E67 mov      eax, dword ptr [0xb973d4]
00542E6C push     eax
00542E6D lea      ecx, [ebp - 0x274]
00542E73 push     ecx
00542E74 call     0x411d70
00542E79 add      esp, 0xc
00542E7C mov      dword ptr [ebp - 0x3ac], eax
00542E82 mov      edx, dword ptr [ebp - 0x3ac]
00542E88 mov      dword ptr [ebp - 0x3b0], edx
00542E8E mov      byte ptr [ebp - 4], 0x14
00542E92 mov      eax, dword ptr [ebp - 0x3b0]
00542E98 push     eax
00542E99 mov      ecx, dword ptr [ebp - 0x3c]
00542E9C call     0x75fbf0
00542EA1 mov      dword ptr [ebp - 0x34], eax
00542EA4 mov      byte ptr [ebp - 4], 0x13
00542EA8 lea      ecx, [ebp - 0x274]
00542EAE call     0x4056d0
00542EB3 mov      byte ptr [ebp - 4], 0
00542EB7 lea      ecx, [ebp - 0x258]
00542EBD call     0x4056d0
00542EC2 cmp      dword ptr [ebp - 0x34], 0
00542EC6 je       0x542f09
00542EC8 mov      ecx, dword ptr [ebp - 0x38]
00542ECB add      ecx, 0xf8
00542ED1 call     0x405750
00542ED6 push     eax
00542ED7 lea      ecx, [ebp - 0x290]
00542EDD call     0x405650
00542EE2 mov      byte ptr [ebp - 4], 0x15
00542EE6 lea      ecx, [ebp - 0x290]
00542EEC push     ecx
00542EED mov      edx, dword ptr [ebp - 0x34]
00542EF0 mov      eax, dword ptr [edx]
00542EF2 mov      ecx, dword ptr [ebp - 0x34]
00542EF5 mov      edx, dword ptr [eax + 0x28]
00542EF8 call     edx
00542EFA mov      byte ptr [ebp - 4], 0
00542EFE lea      ecx, [ebp - 0x290]
00542F04 call     0x4056d0
00542F09 lea      eax, [ebp - 0x40]
00542F0C push     eax
00542F0D lea      ecx, [ebp - 0x2ac]
00542F13 push     ecx
00542F14 call     0x4b9190
00542F19 add      esp, 8
00542F1C mov      dword ptr [ebp - 0x3b4], eax
00542F22 mov      edx, dword ptr [ebp - 0x3b4]
00542F28 mov      dword ptr [ebp - 0x3b8], edx
00542F2E mov      byte ptr [ebp - 4], 0x16
00542F32 mov      eax, dword ptr [ebp - 0x3b8]
00542F38 push     eax
00542F39 mov      ecx, dword ptr [0xb973dc]
00542F3F push     ecx
00542F40 lea      edx, [ebp - 0x2c8]
00542F46 push     edx
00542F47 call     0x411d70
00542F4C add      esp, 0xc
00542F4F mov      dword ptr [ebp - 0x3bc], eax
00542F55 mov      eax, dword ptr [ebp - 0x3bc]
00542F5B mov      dword ptr [ebp - 0x3c0], eax
00542F61 mov      byte ptr [ebp - 4], 0x17
00542F65 mov      ecx, dword ptr [ebp - 0x3c0]
00542F6B push     ecx
00542F6C mov      ecx, dword ptr [ebp - 0x3c]
00542F6F call     0x75fbf0
00542F74 mov      dword ptr [ebp - 0x44], eax
00542F77 mov      byte ptr [ebp - 4], 0x16
00542F7B lea      ecx, [ebp - 0x2c8]
00542F81 call     0x4056d0
00542F86 mov      byte ptr [ebp - 4], 0
00542F8A lea      ecx, [ebp - 0x2ac]
00542F90 call     0x4056d0
00542F95 mov      edx, dword ptr [ebp - 0x14]
00542F98 movzx    eax, byte ptr [edx + 0x10]
00542F9C mov      dword ptr [ebp - 0x3c4], eax
00542FA2 mov      ecx, dword ptr [ebp - 0x3c4]
00542FA8 sub      ecx, 1
00542FAB mov      dword ptr [ebp - 0x3c4], ecx
00542FB1 cmp      dword ptr [ebp - 0x3c4], 3
00542FB8 ja       0x5430cb
00542FBE mov      edx, dword ptr [ebp - 0x3c4]
00542FC4 jmp      dword ptr [edx*4 + 0x5430fc]
00542FCB push     -1
00542FCD mov      ecx, dword ptr [ebp - 0x30]
00542FD0 call     0x4b2350
00542FD5 cmp      dword ptr [ebp - 0x44], 0
00542FD9 je       0x543013
00542FDB mov      eax, dword ptr [0xb973c0]
00542FE0 push     eax
00542FE1 lea      ecx, [ebp - 0x2e4]
00542FE7 call     0x405650
00542FEC mov      byte ptr [ebp - 4], 0x18
00542FF0 lea      ecx, [ebp - 0x2e4]
00542FF6 push     ecx
00542FF7 mov      edx, dword ptr [ebp - 0x44]
00542FFA mov      eax, dword ptr [edx]
00542FFC mov      ecx, dword ptr [ebp - 0x44]
00542FFF mov      edx, dword ptr [eax + 0x28]
00543002 call     edx
00543004 mov      byte ptr [ebp - 4], 0
00543008 lea      ecx, [ebp - 0x2e4]
0054300E call     0x4056d0
00543013 jmp      0x5430cb
00543018 push     0xff00ffff
0054301D mov      ecx, dword ptr [ebp - 0x30]
00543020 call     0x4b2350
00543025 cmp      dword ptr [ebp - 0x44], 0
00543029 je       0x543063
0054302B mov      eax, dword ptr [0xb973c4]
00543030 push     eax
00543031 lea      ecx, [ebp - 0x300]
00543037 call     0x405650
0054303C mov      byte ptr [ebp - 4], 0x19
00543040 lea      ecx, [ebp - 0x300]
00543046 push     ecx
00543047 mov      edx, dword ptr [ebp - 0x44]
0054304A mov      eax, dword ptr [edx]
0054304C mov      ecx, dword ptr [ebp - 0x44]
0054304F mov      edx, dword ptr [eax + 0x28]
00543052 call     edx
00543054 mov      byte ptr [ebp - 4], 0
00543058 lea      ecx, [ebp - 0x300]
0054305E call     0x4056d0
00543063 jmp      0x5430cb
00543065 push     0xffc78dfd
0054306A mov      ecx, dword ptr [ebp - 0x30]
0054306D call     0x4b2350
00543072 cmp      dword ptr [ebp - 0x44], 0
00543076 je       0x5430b0
00543078 mov      eax, dword ptr [0xb973c8]
0054307D push     eax
0054307E lea      ecx, [ebp - 0x31c]
00543084 call     0x405650
00543089 mov      byte ptr [ebp - 4], 0x1a
0054308D lea      ecx, [ebp - 0x31c]
00543093 push     ecx
00543094 mov      edx, dword ptr [ebp - 0x44]
00543097 mov      eax, dword ptr [edx]
00543099 mov      ecx, dword ptr [ebp - 0x44]
0054309C mov      edx, dword ptr [eax + 0x28]
0054309F call     edx
005430A1 mov      byte ptr [ebp - 4], 0
005430A5 lea      ecx, [ebp - 0x31c]
005430AB call     0x4056d0
005430B0 jmp      0x5430cb
005430B2 push     0xffff0000
005430B7 mov      ecx, dword ptr [ebp - 0x30]
005430BA call     0x4b2350
005430BF call     0x41c230
005430C4 mov      ecx, eax
005430C6 call     0x91ea30
005430CB jmp      0x5428ea
005430D0 mov      ecx, dword ptr [ebp - 0x320]
005430D6 call     0x543110
005430DB mov      dword ptr [ebp - 4], 0xffffffff
005430E2 lea      ecx, [ebp - 0x2c]
005430E5 call     0x4c5520
005430EA mov      ecx, dword ptr [ebp - 0xc]
005430ED mov      dword ptr fs:[0], ecx
005430F4 pop      ecx
005430F5 pop      esi
005430F6 mov      esp, ebp
005430F8 pop      ebp
005430F9 ret

; function 0x543110
00543110 push     ebp
00543111 mov      ebp, esp
00543113 push     -1
00543115 push     0xaeb39e
0054311A mov      eax, dword ptr fs:[0]
00543120 push     eax
00543121 sub      esp, 0xd7c
00543127 mov      eax, dword ptr [0xc7b480]
0054312C xor      eax, ebp
0054312E mov      dword ptr [ebp - 0x34], eax
00543131 push     esi
00543132 push     eax
00543133 lea      eax, [ebp - 0xc]
00543136 mov      dword ptr fs:[0], eax
0054313C mov      dword ptr [ebp - 0xc4c], ecx
00543142 mov      ecx, dword ptr [ebp - 0xc4c]
00543148 call     0x53c300
0054314D mov      eax, dword ptr [ebp - 0xc4c]
00543153 mov      edx, dword ptr [eax]
00543155 mov      ecx, dword ptr [ebp - 0xc4c]
0054315B mov      eax, dword ptr [edx + 0x1c]
0054315E call     eax
00543160 test     eax, eax
00543162 jl       0x543190
00543164 mov      ecx, dword ptr [ebp - 0xc4c]
0054316A mov      edx, dword ptr [ecx]
0054316C mov      ecx, dword ptr [ebp - 0xc4c]
00543172 mov      eax, dword ptr [edx + 0x1c]
00543175 call     eax
00543177 mov      esi, eax
00543179 mov      ecx, dword ptr [ebp - 0xc4c]
0054317F mov      edx, dword ptr [ecx]
00543181 mov      ecx, dword ptr [ebp - 0xc4c]
00543187 mov      eax, dword ptr [edx + 4]
0054318A call     eax
0054318C cmp      esi, eax
0054318E jl       0x543195
00543190 jmp      0x5452e4
00543195 mov      ecx, dword ptr [ebp - 0xc4c]
0054319B mov      edx, dword ptr [ecx]
0054319D mov      ecx, dword ptr [ebp - 0xc4c]
005431A3 mov      eax, dword ptr [edx + 0x1c]
005431A6 call     eax
005431A8 push     eax
005431A9 call     0xa4b950
005431AE mov      ecx, eax
005431B0 call     0xa47ab0
005431B5 mov      dword ptr [ebp - 0x138], eax
005431BB cmp      dword ptr [ebp - 0x138], 0
005431C2 jne      0x5431c9
005431C4 jmp      0x5452e4
005431C9 mov      ecx, dword ptr [ebp - 0x138]
005431CF movzx    edx, word ptr [ecx + 0xc]
005431D3 push     edx
005431D4 call     0xa4b950
005431D9 mov      ecx, eax
005431DB call     0xa47530
005431E0 mov      dword ptr [ebp - 0x140], eax
005431E6 cmp      dword ptr [ebp - 0x140], 0
005431ED jne      0x5431f4
005431EF jmp      0x5452e4
005431F4 mov      eax, dword ptr [ebp - 0x138]
005431FA movzx    ecx, word ptr [eax + 0xc]
005431FE push     ecx
005431FF lea      edx, [ebp - 0x15c]
00543205 push     edx
00543206 call     0xa4b950
0054320B mov      ecx, eax
0054320D call     0xa47e70
00543212 mov      dword ptr [ebp - 4], 0
00543219 call     0x4e7570
0054321E mov      dword ptr [ebp - 0x30], eax
00543221 mov      eax, dword ptr [0xb9747c]
00543226 push     eax
00543227 lea      ecx, [ebp - 0x2b0]
0054322D call     0x405650
00543232 mov      byte ptr [ebp - 4], 1
00543236 push     1
00543238 lea      ecx, [ebp - 0x2b0]
0054323E push     ecx
0054323F mov      ecx, dword ptr [ebp - 0x30]
00543242 call     0x7611c0
00543247 mov      byte ptr [ebp - 4], 0
0054324B lea      ecx, [ebp - 0x2b0]
00543251 call     0x4056d0
00543256 mov      dword ptr [ebp - 0x13c], 0
00543260 mov      dword ptr [ebp - 0x2c], 0
00543267 mov      dword ptr [ebp - 0x18], 0
0054326E mov      dword ptr [ebp - 0x160], 0
00543278 mov      dword ptr [ebp - 0x144], 0
00543282 mov      edx, dword ptr [0xb973f0]
00543288 push     edx
00543289 lea      ecx, [ebp - 0x2cc]
0054328F call     0x405650
00543294 mov      byte ptr [ebp - 4], 2
00543298 lea      eax, [ebp - 0x2cc]
0054329E push     eax
0054329F mov      ecx, dword ptr [ebp - 0x30]
005432A2 call     0x75fbf0
005432A7 mov      dword ptr [ebp - 0x13c], eax
005432AD mov      byte ptr [ebp - 4], 0
005432B1 lea      ecx, [ebp - 0x2cc]
005432B7 call     0x4056d0
005432BC cmp      dword ptr [ebp - 0x13c], 0
005432C3 je       0x543314
005432C5 mov      ecx, dword ptr [ebp - 0x140]
005432CB add      ecx, 0xdc
005432D1 call     0x405750
005432D6 push     eax
005432D7 lea      ecx, [ebp - 0x2e8]
005432DD call     0x405650
005432E2 mov      byte ptr [ebp - 4], 3
005432E6 push     1
005432E8 lea      ecx, [ebp - 0x2e8]
005432EE push     ecx
005432EF mov      edx, dword ptr [ebp - 0x13c]
005432F5 mov      eax, dword ptr [edx]
005432F7 mov      ecx, dword ptr [ebp - 0x13c]
005432FD mov      edx, dword ptr [eax + 0xd4]
00543303 call     edx
00543305 mov      byte ptr [ebp - 4], 0
00543309 lea      ecx, [ebp - 0x2e8]
0054330F call     0x4056d0
00543314 mov      eax, dword ptr [0xb973f4]
00543319 push     eax
0054331A lea      ecx, [ebp - 0x304]
00543320 call     0x405650
00543325 mov      byte ptr [ebp - 4], 4
00543329 lea      ecx, [ebp - 0x304]
0054332F push     ecx
00543330 mov      ecx, dword ptr [ebp - 0x30]
00543333 call     0x75fbf0
00543338 mov      dword ptr [ebp - 0x14], eax
0054333B mov      byte ptr [ebp - 4], 0
0054333F lea      ecx, [ebp - 0x304]
00543345 call     0x4056d0
0054334A cmp      dword ptr [ebp - 0x14], 0
0054334E je       0x5433a4
00543350 mov      edx, dword ptr [ebp - 0x138]
00543356 movzx    eax, byte ptr [edx + 0x10]
0054335A cmp      eax, 3
0054335D je       0x54336e
0054335F mov      ecx, dword ptr [ebp - 0x138]
00543365 movzx    edx, byte ptr [ecx + 0x10]
00543369 cmp      edx, 4
0054336C jne      0x54338a
0054336E mov      ecx, dword ptr [ebp - 0x140]
00543374 add      ecx, 0x130
0054337A call     0x405750
0054337F push     eax
00543380 mov      ecx, dword ptr [ebp - 0x14]
00543383 call     0x74c640
00543388 jmp      0x5433a4
0054338A mov      ecx, dword ptr [ebp - 0x140]
00543390 add      ecx, 0x114
00543396 call     0x405750
0054339B push     eax
0054339C mov      ecx, dword ptr [ebp - 0x14]
0054339F call     0x74c640
005433A4 push     0x100
005433A9 push     0
005433AB lea      eax, [ebp - 0x134]
005433B1 push     eax
005433B2 call     0x666960
005433B7 add      esp, 0xc
005433BA mov      ecx, dword ptr [0xb97410]
005433C0 push     ecx
005433C1 lea      ecx, [ebp - 0x320]
005433C7 call     0x405650
005433CC mov      byte ptr [ebp - 4], 5
005433D0 lea      edx, [ebp - 0x320]
005433D6 push     edx
005433D7 mov      ecx, dword ptr [ebp - 0x30]
005433DA call     0x75fbf0
005433DF mov      dword ptr [ebp - 0x13c], eax
005433E5 mov      byte ptr [ebp - 4], 0
005433E9 lea      ecx, [ebp - 0x320]
005433EF call     0x4056d0
005433F4 cmp      dword ptr [ebp - 0x13c], 0
005433FB je       0x54343f
005433FD push     0xbc998c
00543402 lea      ecx, [ebp - 0x33c]
00543408 call     0x405650
0054340D mov      byte ptr [ebp - 4], 6
00543411 push     1
00543413 lea      eax, [ebp - 0x33c]
00543419 push     eax
0054341A mov      ecx, dword ptr [ebp - 0x13c]
00543420 mov      edx, dword ptr [ecx]
00543422 mov      ecx, dword ptr [ebp - 0x13c]
00543428 mov      eax, dword ptr [edx + 0xd4]
0054342E call     eax
00543430 mov      byte ptr [ebp - 4], 0
00543434 lea      ecx, [ebp - 0x33c]
0054343A call     0x4056d0
0054343F mov      ecx, dword ptr [0xb9740c]
00543445 push     ecx
00543446 lea      ecx, [ebp - 0x358]
0054344C call     0x405650
00543451 mov      byte ptr [ebp - 4], 7
00543455 lea      edx, [ebp - 0x358]
0054345B push     edx
0054345C mov      ecx, dword ptr [ebp - 0x30]
0054345F call     0x75fbf0
00543464 mov      dword ptr [ebp - 0x13c], eax
0054346A mov      byte ptr [ebp - 4], 0
0054346E lea      ecx, [ebp - 0x358]
00543474 call     0x4056d0
00543479 mov      dword ptr [ebp - 0x24], 0xffffffff
00543480 mov      dword ptr [ebp - 0x20], 0xffffffff
00543487 mov      dword ptr [ebp - 0x1c], 0xffffffff
0054348E xor      eax, eax
00543490 mov      word ptr [ebp - 0x10], ax
00543494 mov      dword ptr [ebp - 0x164], 0
0054349E jmp      0x5434af
005434A0 mov      ecx, dword ptr [ebp - 0x164]
005434A6 add      ecx, 1
005434A9 mov      dword ptr [ebp - 0x164], ecx
005434AF cmp      dword ptr [ebp - 0x164], 7
005434B6 jge      0x5435f7
005434BC mov      edx, dword ptr [ebp - 0x164]
005434C2 imul     edx, edx, 0xc
005434C5 mov      eax, dword ptr [ebp - 0x138]
005434CB cmp      dword ptr [eax + edx + 0x35], 0
005434D0 jbe      0x5434de
005434D2 mov      cx, word ptr [ebp - 0x10]
005434D6 add      cx, 1
005434DA mov      word ptr [ebp - 0x10], cx
005434DE mov      edx, dword ptr [ebp - 0x164]
005434E4 imul     edx, edx, 0xc
005434E7 mov      eax, dword ptr [ebp - 0x138]
005434ED cmp      dword ptr [eax + edx + 0x35], 0
005434F2 jb       0x54353a
005434F4 mov      ecx, dword ptr [ebp - 0x164]
005434FA imul     ecx, ecx, 0xc
005434FD mov      edx, dword ptr [ebp - 0x138]
00543503 mov      eax, dword ptr [ebp - 0x140]
00543509 mov      ecx, dword ptr [edx + ecx + 0x35]
0054350D cmp      ecx, dword ptr [eax + 0xc8]
00543513 jne      0x54353a
00543515 mov      edx, dword ptr [ebp - 0x140]
0054351B movzx    eax, word ptr [edx + 0xd4]
00543522 test     eax, eax
00543524 jle      0x54353a
00543526 cmp      dword ptr [ebp - 0x24], 0
0054352A jge      0x54353a
0054352C mov      ecx, dword ptr [ebp - 0x164]
00543532 mov      dword ptr [ebp - 0x24], ecx
00543535 jmp      0x5434a0
0054353A mov      edx, dword ptr [ebp - 0x164]
00543540 imul     edx, edx, 0xc
00543543 mov      eax, dword ptr [ebp - 0x138]
00543549 cmp      dword ptr [eax + edx + 0x35], 0
0054354E jb       0x543596
00543550 mov      ecx, dword ptr [ebp - 0x164]
00543556 imul     ecx, ecx, 0xc
00543559 mov      edx, dword ptr [ebp - 0x138]
0054355F mov      eax, dword ptr [ebp - 0x140]
00543565 mov      ecx, dword ptr [edx + ecx + 0x35]
00543569 cmp      ecx, dword ptr [eax + 0xcc]
0054356F jne      0x543596
00543571 mov      edx, dword ptr [ebp - 0x140]
00543577 movzx    eax, word ptr [edx + 0xd6]
0054357E test     eax, eax
00543580 jle      0x543596
00543582 cmp      dword ptr [ebp - 0x20], 0
00543586 jge      0x543596
00543588 mov      ecx, dword ptr [ebp - 0x164]
0054358E mov      dword ptr [ebp - 0x20], ecx
00543591 jmp      0x5434a0
00543596 mov      edx, dword ptr [ebp - 0x164]
0054359C imul     edx, edx, 0xc
0054359F mov      eax, dword ptr [ebp - 0x138]
005435A5 cmp      dword ptr [eax + edx + 0x35], 0
005435AA jb       0x5435f2
005435AC mov      ecx, dword ptr [ebp - 0x164]
005435B2 imul     ecx, ecx, 0xc
005435B5 mov      edx, dword ptr [ebp - 0x138]
005435BB mov      eax, dword ptr [ebp - 0x140]
005435C1 mov      ecx, dword ptr [edx + ecx + 0x35]
005435C5 cmp      ecx, dword ptr [eax + 0xd0]
005435CB jne      0x5435f2
005435CD mov      edx, dword ptr [ebp - 0x140]
005435D3 movzx    eax, word ptr [edx + 0xd8]
005435DA test     eax, eax
005435DC jle      0x5435f2
005435DE cmp      dword ptr [ebp - 0x1c], 0
005435E2 jge      0x5435f2
005435E4 mov      ecx, dword ptr [ebp - 0x164]
005435EA mov      dword ptr [ebp - 0x1c], ecx
005435ED jmp      0x5434a0
005435F2 jmp      0x5434a0
005435F7 mov      dword ptr [ebp - 0x168], 0
00543601 jmp      0x543612
00543603 mov      edx, dword ptr [ebp - 0x168]
00543609 add      edx, 1
0054360C mov      dword ptr [ebp - 0x168], edx
00543612 cmp      dword ptr [ebp - 0x168], 3
00543619 jge      0x54393d
0054361F lea      eax, [ebp - 0x168]
00543625 push     eax
00543626 lea      ecx, [ebp - 0x374]
0054362C push     ecx
0054362D call     0xa44160
00543632 add      esp, 8
00543635 mov      dword ptr [ebp - 0xc50], eax
0054363B mov      edx, dword ptr [ebp - 0xc50]
00543641 mov      dword ptr [ebp - 0xc54], edx
00543647 mov      byte ptr [ebp - 4], 8
0054364B mov      eax, dword ptr [ebp - 0xc54]
00543651 push     eax
00543652 mov      ecx, dword ptr [0xb97410]
00543658 push     ecx
00543659 lea      edx, [ebp - 0x390]
0054365F push     edx
00543660 call     0x411d70
00543665 add      esp, 0xc
00543668 mov      dword ptr [ebp - 0xc58], eax
0054366E mov      eax, dword ptr [ebp - 0xc58]
00543674 mov      dword ptr [ebp - 0xc5c], eax
0054367A mov      byte ptr [ebp - 4], 9
0054367E mov      ecx, dword ptr [ebp - 0xc5c]
00543684 push     ecx
00543685 mov      ecx, dword ptr [ebp - 0x30]
00543688 call     0x75fbf0
0054368D mov      dword ptr [ebp - 0x13c], eax
00543693 mov      byte ptr [ebp - 4], 8
00543697 lea      ecx, [ebp - 0x390]
0054369D call     0x4056d0
005436A2 mov      byte ptr [ebp - 4], 0
005436A6 lea      ecx, [ebp - 0x374]
005436AC call     0x4056d0
005436B1 cmp      dword ptr [ebp - 0x13c], 0
005436B8 je       0x5436fc
005436BA push     0xb96699
005436BF lea      ecx, [ebp - 0x3ac]
005436C5 call     0x405650
005436CA mov      byte ptr [ebp - 4], 0xa
005436CE push     1
005436D0 lea      edx, [ebp - 0x3ac]
005436D6 push     edx
005436D7 mov      eax, dword ptr [ebp - 0x13c]
005436DD mov      edx, dword ptr [eax]
005436DF mov      ecx, dword ptr [ebp - 0x13c]
005436E5 mov      eax, dword ptr [edx + 0xd4]
005436EB call     eax
005436ED mov      byte ptr [ebp - 4], 0
005436F1 lea      ecx, [ebp - 0x3ac]
005436F7 call     0x4056d0
005436FC mov      ecx, dword ptr [ebp - 0x168]
00543702 cmp      dword ptr [ebp + ecx*4 - 0x24], 0
00543707 jl       0x543938
0054370D mov      edx, dword ptr [ebp - 0x168]
00543713 cmp      dword ptr [ebp + edx*4 - 0x24], 7
00543718 jge      0x543938
0054371E mov      eax, dword ptr [ebp - 0x138]
00543724 movzx    ecx, word ptr [eax + 0xe]
00543728 cmp      ecx, 2
0054372B jne      0x5437f8
00543731 mov      edx, dword ptr [ebp - 0x168]
00543737 mov      eax, dword ptr [ebp + edx*4 - 0x24]
0054373B imul     eax, eax, 0xc
0054373E mov      ecx, dword ptr [ebp - 0x168]
00543744 mov      edx, dword ptr [ebp - 0x140]
0054374A movzx    ecx, word ptr [edx + ecx*2 + 0xd4]
00543752 mov      edx, dword ptr [ebp - 0x138]
00543758 cmp      dword ptr [edx + eax + 0x39], ecx
0054375C jb       0x5437ab
0054375E mov      eax, dword ptr [ebp - 0x168]
00543764 mov      ecx, dword ptr [ebp - 0x140]
0054376A movzx    edx, word ptr [ecx + eax*2 + 0xd4]
00543772 push     edx
00543773 push     1
00543775 mov      eax, dword ptr [ebp - 0x168]
0054377B push     eax
0054377C mov      ecx, dword ptr [ebp - 0x140]
00543782 add      ecx, 0xb0
00543788 call     0x4eae70
0054378D mov      ecx, eax
0054378F call     0x405750
00543794 push     eax
00543795 push     0xbc99a4
0054379A lea      ecx, [ebp - 0x134]
005437A0 push     ecx
005437A1 call     0x411e00
005437A6 add      esp, 0x14
005437A9 jmp      0x5437f6
005437AB mov      edx, dword ptr [ebp - 0x168]
005437B1 mov      eax, dword ptr [ebp - 0x140]
005437B7 movzx    ecx, word ptr [eax + edx*2 + 0xd4]
005437BF push     ecx
005437C0 push     0
005437C2 mov      edx, dword ptr [ebp - 0x168]
005437C8 push     edx
005437C9 mov      ecx, dword ptr [ebp - 0x140]
005437CF add      ecx, 0xb0
005437D5 call     0x4eae70
005437DA mov      ecx, eax
005437DC call     0x405750
005437E1 push     eax
005437E2 push     0xbc99a4
005437E7 lea      eax, [ebp - 0x134]
005437ED push     eax
005437EE call     0x411e00
005437F3 add      esp, 0x14
005437F6 jmp      0x543859
005437F8 mov      ecx, dword ptr [ebp - 0x168]
005437FE mov      edx, dword ptr [ebp - 0x140]
00543804 movzx    eax, word ptr [edx + ecx*2 + 0xd4]
0054380C push     eax
0054380D mov      ecx, dword ptr [ebp - 0x168]
00543813 mov      edx, dword ptr [ebp + ecx*4 - 0x24]
00543817 imul     edx, edx, 0xc
0054381A mov      eax, dword ptr [ebp - 0x138]
00543820 mov      ecx, dword ptr [eax + edx + 0x39]
00543824 push     ecx
00543825 mov      edx, dword ptr [ebp - 0x168]
0054382B push     edx
0054382C mov      ecx, dword ptr [ebp - 0x140]
00543832 add      ecx, 0xb0
00543838 call     0x4eae70
0054383D mov      ecx, eax
0054383F call     0x405750
00543844 push     eax
00543845 push     0xbc99a4
0054384A lea      eax, [ebp - 0x134]
00543850 push     eax
00543851 call     0x411e00
00543856 add      esp, 0x14
00543859 lea      ecx, [ebp - 0x168]
0054385F push     ecx
00543860 lea      edx, [ebp - 0x3c8]
00543866 push     edx
00543867 call     0xa44160
0054386C add      esp, 8
0054386F mov      dword ptr [ebp - 0xc60], eax
00543875 mov      eax, dword ptr [ebp - 0xc60]
0054387B mov      dword ptr [ebp - 0xc64], eax
00543881 mov      byte ptr [ebp - 4], 0xb
00543885 mov      ecx, dword ptr [ebp - 0xc64]
0054388B push     ecx
0054388C mov      edx, dword ptr [0xb97410]
00543892 push     edx
00543893 lea      eax, [ebp - 0x3e4]
00543899 push     eax
0054389A call     0x411d70
0054389F add      esp, 0xc
005438A2 mov      dword ptr [ebp - 0xc68], eax
005438A8 mov      ecx, dword ptr [ebp - 0xc68]
005438AE mov      dword ptr [ebp - 0xc6c], ecx
005438B4 mov      byte ptr [ebp - 4], 0xc
005438B8 mov      edx, dword ptr [ebp - 0xc6c]
005438BE push     edx
005438BF mov      ecx, dword ptr [ebp - 0x30]
005438C2 call     0x75fbf0
005438C7 mov      dword ptr [ebp - 0x13c], eax
005438CD mov      byte ptr [ebp - 4], 0xb
005438D1 lea      ecx, [ebp - 0x3e4]
005438D7 call     0x4056d0
005438DC mov      byte ptr [ebp - 4], 0
005438E0 lea      ecx, [ebp - 0x3c8]
005438E6 call     0x4056d0
005438EB cmp      dword ptr [ebp - 0x13c], 0
005438F2 je       0x543938
005438F4 lea      eax, [ebp - 0x134]
005438FA push     eax
005438FB lea      ecx, [ebp - 0x400]
00543901 call     0x405650
00543906 mov      byte ptr [ebp - 4], 0xd
0054390A push     1
0054390C lea      ecx, [ebp - 0x400]
00543912 push     ecx
00543913 mov      edx, dword ptr [ebp - 0x13c]
00543919 mov      eax, dword ptr [edx]
0054391B mov      ecx, dword ptr [ebp - 0x13c]
00543921 mov      edx, dword ptr [eax + 0xd4]
00543927 call     edx
00543929 mov      byte ptr [ebp - 4], 0
0054392D lea      ecx, [ebp - 0x400]
00543933 call     0x4056d0
00543938 jmp      0x543603
0054393D movsx    eax, word ptr [ebp - 0x10]
00543941 cmp      eax, 3
00543944 jle      0x543ac2
0054394A mov      ecx, dword ptr [ebp - 0x138]
00543950 movzx    edx, byte ptr [ecx + 0x10]
00543954 cmp      edx, 4
00543957 jne      0x54399a
00543959 mov      eax, dword ptr [ebp - 0x140]
0054395F movzx    ecx, word ptr [eax + 0xd4]
00543966 push     ecx
00543967 push     1
00543969 push     0
0054396B mov      ecx, dword ptr [ebp - 0x140]
00543971 add      ecx, 0xb0
00543977 call     0x4eae70
0054397C mov      ecx, eax
0054397E call     0x405750
00543983 push     eax
00543984 push     0xbc99a4
00543989 lea      edx, [ebp - 0x134]
0054398F push     edx
00543990 call     0x411e00
00543995 add      esp, 0x14
00543998 jmp      0x5439d9
0054399A mov      eax, dword ptr [ebp - 0x140]
005439A0 movzx    ecx, word ptr [eax + 0xd4]
005439A7 push     ecx
005439A8 push     0
005439AA push     0
005439AC mov      ecx, dword ptr [ebp - 0x140]
005439B2 add      ecx, 0xb0
005439B8 call     0x4eae70
005439BD mov      ecx, eax
005439BF call     0x405750
005439C4 push     eax
005439C5 push     0xbc99a4
005439CA lea      edx, [ebp - 0x134]
005439D0 push     edx
005439D1 call     0x411e00
005439D6 add      esp, 0x14
005439D9 mov      dword ptr [ebp - 0x404], 0
005439E3 lea      eax, [ebp - 0x404]
005439E9 push     eax
005439EA lea      ecx, [ebp - 0x420]
005439F0 push     ecx
005439F1 call     0xa44160
005439F6 add      esp, 8
005439F9 mov      dword ptr [ebp - 0xc70], eax
005439FF mov      edx, dword ptr [ebp - 0xc70]
00543A05 mov      dword ptr [ebp - 0xc74], edx
00543A0B mov      byte ptr [ebp - 4], 0xe
00543A0F mov      eax, dword ptr [ebp - 0xc74]
00543A15 push     eax
00543A16 mov      ecx, dword ptr [0xb97410]
00543A1C push     ecx
00543A1D lea      edx, [ebp - 0x43c]
00543A23 push     edx
00543A24 call     0x411d70
00543A29 add      esp, 0xc
00543A2C mov      dword ptr [ebp - 0xc78], eax
00543A32 mov      eax, dword ptr [ebp - 0xc78]
00543A38 mov      dword ptr [ebp - 0xc7c], eax
00543A3E mov      byte ptr [ebp - 4], 0xf
00543A42 mov      ecx, dword ptr [ebp - 0xc7c]
00543A48 push     ecx
00543A49 mov      ecx, dword ptr [ebp - 0x30]
00543A4C call     0x75fbf0
00543A51 mov      dword ptr [ebp - 0x13c], eax
00543A57 mov      byte ptr [ebp - 4], 0xe
00543A5B lea      ecx, [ebp - 0x43c]
00543A61 call     0x4056d0
00543A66 mov      byte ptr [ebp - 4], 0
00543A6A lea      ecx, [ebp - 0x420]
00543A70 call     0x4056d0
00543A75 cmp      dword ptr [ebp - 0x13c], 0
00543A7C je       0x543ac2
00543A7E lea      edx, [ebp - 0x134]
00543A84 push     edx
00543A85 lea      ecx, [ebp - 0x458]
00543A8B call     0x405650
00543A90 mov      byte ptr [ebp - 4], 0x10
00543A94 push     1
00543A96 lea      eax, [ebp - 0x458]
00543A9C push     eax
00543A9D mov      ecx, dword ptr [ebp - 0x13c]
00543AA3 mov      edx, dword ptr [ecx]
00543AA5 mov      ecx, dword ptr [ebp - 0x13c]
00543AAB mov      eax, dword ptr [edx + 0xd4]
00543AB1 call     eax
00543AB3 mov      byte ptr [ebp - 4], 0
00543AB7 lea      ecx, [ebp - 0x458]
00543ABD call     0x4056d0
00543AC2 mov      ecx, dword ptr [ebp - 0x140]
00543AC8 cmp      dword ptr [ecx + 0x11], 0
00543ACC jne      0x543cba
00543AD2 mov      edx, dword ptr [0xb9741c]
00543AD8 push     edx
00543AD9 lea      ecx, [ebp - 0x474]
00543ADF call     0x405650
00543AE4 mov      byte ptr [ebp - 4], 0x11
00543AE8 lea      eax, [ebp - 0x474]
00543AEE push     eax
00543AEF mov      ecx, dword ptr [ebp - 0x30]
00543AF2 call     0x75fbf0
00543AF7 mov      dword ptr [ebp - 0x13c], eax
00543AFD mov      byte ptr [ebp - 4], 0
00543B01 lea      ecx, [ebp - 0x474]
00543B07 call     0x4056d0
00543B0C cmp      dword ptr [ebp - 0x13c], 0
00543B13 je       0x543bc6
00543B19 mov      ecx, dword ptr [ebp - 0x140]
00543B1F cmp      dword ptr [ecx + 0x15], 0
00543B23 je       0x543bc6
00543B29 mov      edx, dword ptr [ebp - 0x140]
00543B2F add      edx, 0x15
00543B32 push     edx
00543B33 lea      eax, [ebp - 0x490]
00543B39 push     eax
00543B3A call     0x411c90
00543B3F add      esp, 8
00543B42 mov      dword ptr [ebp - 0xc80], eax
00543B48 mov      ecx, dword ptr [ebp - 0xc80]
00543B4E mov      dword ptr [ebp - 0xc84], ecx
00543B54 mov      byte ptr [ebp - 4], 0x12
00543B58 mov      edx, dword ptr [ebp - 0xc84]
00543B5E push     edx
00543B5F push     0xbc99b0
00543B64 lea      eax, [ebp - 0x4ac]
00543B6A push     eax
00543B6B call     0x411d70
00543B70 add      esp, 0xc
00543B73 mov      dword ptr [ebp - 0xc88], eax
00543B79 mov      ecx, dword ptr [ebp - 0xc88]
00543B7F mov      dword ptr [ebp - 0xc8c], ecx
00543B85 mov      byte ptr [ebp - 4], 0x13
00543B89 push     1
00543B8B mov      edx, dword ptr [ebp - 0xc8c]
00543B91 push     edx
00543B92 mov      eax, dword ptr [ebp - 0x13c]
00543B98 mov      edx, dword ptr [eax]
00543B9A mov      ecx, dword ptr [ebp - 0x13c]
00543BA0 mov      eax, dword ptr [edx + 0xd4]
00543BA6 call     eax
00543BA8 mov      byte ptr [ebp - 4], 0x12
00543BAC lea      ecx, [ebp - 0x4ac]
00543BB2 call     0x4056d0
00543BB7 mov      byte ptr [ebp - 4], 0
00543BBB lea      ecx, [ebp - 0x490]
00543BC1 call     0x4056d0
00543BC6 mov      ecx, dword ptr [0xb97420]
00543BCC push     ecx
00543BCD lea      ecx, [ebp - 0x4c8]
00543BD3 call     0x405650
00543BD8 mov      byte ptr [ebp - 4], 0x14
00543BDC lea      edx, [ebp - 0x4c8]
00543BE2 push     edx
00543BE3 mov      ecx, dword ptr [ebp - 0x30]
00543BE6 call     0x75fbf0
00543BEB mov      dword ptr [ebp - 0x13c], eax
00543BF1 mov      byte ptr [ebp - 4], 0
00543BF5 lea      ecx, [ebp - 0x4c8]
00543BFB call     0x4056d0
00543C00 cmp      dword ptr [ebp - 0x13c], 0
00543C07 je       0x543cba
00543C0D mov      eax, dword ptr [ebp - 0x140]
00543C13 cmp      dword ptr [eax + 0x19], 0
00543C17 je       0x543cba
00543C1D mov      ecx, dword ptr [ebp - 0x140]
00543C23 add      ecx, 0x19
00543C26 push     ecx
00543C27 lea      edx, [ebp - 0x4e4]
00543C2D push     edx
00543C2E call     0x411c90
00543C33 add      esp, 8
00543C36 mov      dword ptr [ebp - 0xc90], eax
00543C3C mov      eax, dword ptr [ebp - 0xc90]
00543C42 mov      dword ptr [ebp - 0xc94], eax
00543C48 mov      byte ptr [ebp - 4], 0x15
00543C4C mov      ecx, dword ptr [ebp - 0xc94]
00543C52 push     ecx
00543C53 push     0xbc99bc
00543C58 lea      edx, [ebp - 0x500]
00543C5E push     edx
00543C5F call     0x411d70
00543C64 add      esp, 0xc
00543C67 mov      dword ptr [ebp - 0xc98], eax
00543C6D mov      eax, dword ptr [ebp - 0xc98]
00543C73 mov      dword ptr [ebp - 0xc9c], eax
00543C79 mov      byte ptr [ebp - 4], 0x16
00543C7D push     1
00543C7F mov      ecx, dword ptr [ebp - 0xc9c]
00543C85 push     ecx
00543C86 mov      edx, dword ptr [ebp - 0x13c]
00543C8C mov      eax, dword ptr [edx]
00543C8E mov      ecx, dword ptr [ebp - 0x13c]
00543C94 mov      edx, dword ptr [eax + 0xd4]
00543C9A call     edx
00543C9C mov      byte ptr [ebp - 4], 0x15
00543CA0 lea      ecx, [ebp - 0x500]
00543CA6 call     0x4056d0
00543CAB mov      byte ptr [ebp - 4], 0
00543CAF lea      ecx, [ebp - 0x4e4]
00543CB5 call     0x4056d0
00543CBA mov      eax, dword ptr [ebp - 0x140]
00543CC0 cmp      dword ptr [eax + 0x15], 0
00543CC4 jne      0x543eb1
00543CCA mov      ecx, dword ptr [0xb9741c]
00543CD0 push     ecx
00543CD1 lea      ecx, [ebp - 0x51c]
00543CD7 call     0x405650
00543CDC mov      byte ptr [ebp - 4], 0x17
00543CE0 lea      edx, [ebp - 0x51c]
00543CE6 push     edx
00543CE7 mov      ecx, dword ptr [ebp - 0x30]
00543CEA call     0x75fbf0
00543CEF mov      dword ptr [ebp - 0x13c], eax
00543CF5 mov      byte ptr [ebp - 4], 0
00543CF9 lea      ecx, [ebp - 0x51c]
00543CFF call     0x4056d0
00543D04 cmp      dword ptr [ebp - 0x13c], 0
00543D0B je       0x543dbe
00543D11 mov      eax, dword ptr [ebp - 0x140]
00543D17 cmp      dword ptr [eax + 0x11], 0
00543D1B je       0x543dbe
00543D21 mov      ecx, dword ptr [ebp - 0x140]
00543D27 add      ecx, 0x11
00543D2A push     ecx
00543D2B lea      edx, [ebp - 0x538]
00543D31 push     edx
00543D32 call     0x411c90
00543D37 add      esp, 8
00543D3A mov      dword ptr [ebp - 0xca0], eax
00543D40 mov      eax, dword ptr [ebp - 0xca0]
00543D46 mov      dword ptr [ebp - 0xca4], eax
00543D4C mov      byte ptr [ebp - 4], 0x18
00543D50 mov      ecx, dword ptr [ebp - 0xca4]
00543D56 push     ecx
00543D57 push     0xbc99c8
00543D5C lea      edx, [ebp - 0x554]
00543D62 push     edx
00543D63 call     0x411d70
00543D68 add      esp, 0xc
00543D6B mov      dword ptr [ebp - 0xca8], eax
00543D71 mov      eax, dword ptr [ebp - 0xca8]
00543D77 mov      dword ptr [ebp - 0xcac], eax
00543D7D mov      byte ptr [ebp - 4], 0x19
00543D81 push     1
00543D83 mov      ecx, dword ptr [ebp - 0xcac]
00543D89 push     ecx
00543D8A mov      edx, dword ptr [ebp - 0x13c]
00543D90 mov      eax, dword ptr [edx]
00543D92 mov      ecx, dword ptr [ebp - 0x13c]
00543D98 mov      edx, dword ptr [eax + 0xd4]
00543D9E call     edx
00543DA0 mov      byte ptr [ebp - 4], 0x18
00543DA4 lea      ecx, [ebp - 0x554]
00543DAA call     0x4056d0
00543DAF mov      byte ptr [ebp - 4], 0
00543DB3 lea      ecx, [ebp - 0x538]
00543DB9 call     0x4056d0
00543DBE mov      eax, dword ptr [0xb97420]
00543DC3 push     eax
00543DC4 lea      ecx, [ebp - 0x570]
00543DCA call     0x405650
00543DCF mov      byte ptr [ebp - 4], 0x1a
00543DD3 lea      ecx, [ebp - 0x570]
00543DD9 push     ecx
00543DDA mov      ecx, dword ptr [ebp - 0x30]
00543DDD call     0x75fbf0
00543DE2 mov      dword ptr [ebp - 0x13c], eax
00543DE8 mov      byte ptr [ebp - 4], 0
00543DEC lea      ecx, [ebp - 0x570]
00543DF2 call     0x4056d0
00543DF7 cmp      dword ptr [ebp - 0x13c], 0
00543DFE je       0x543eb1
00543E04 mov      edx, dword ptr [ebp - 0x140]
00543E0A cmp      dword ptr [edx + 0x19], 0
00543E0E je       0x543eb1
00543E14 mov      eax, dword ptr [ebp - 0x140]
00543E1A add      eax, 0x19
00543E1D push     eax
00543E1E lea      ecx, [ebp - 0x58c]
00543E24 push     ecx
00543E25 call     0x411c90
00543E2A add      esp, 8
00543E2D mov      dword ptr [ebp - 0xcb0], eax
00543E33 mov      edx, dword ptr [ebp - 0xcb0]
00543E39 mov      dword ptr [ebp - 0xcb4], edx
00543E3F mov      byte ptr [ebp - 4], 0x1b
00543E43 mov      eax, dword ptr [ebp - 0xcb4]
00543E49 push     eax
00543E4A push     0xbc99bc
00543E4F lea      ecx, [ebp - 0x5a8]
00543E55 push     ecx
00543E56 call     0x411d70
00543E5B add      esp, 0xc
00543E5E mov      dword ptr [ebp - 0xcb8], eax
00543E64 mov      edx, dword ptr [ebp - 0xcb8]
00543E6A mov      dword ptr [ebp - 0xcbc], edx
00543E70 mov      byte ptr [ebp - 4], 0x1c
00543E74 push     1
00543E76 mov      eax, dword ptr [ebp - 0xcbc]
00543E7C push     eax
00543E7D mov      ecx, dword ptr [ebp - 0x13c]
00543E83 mov      edx, dword ptr [ecx]
00543E85 mov      ecx, dword ptr [ebp - 0x13c]
00543E8B mov      eax, dword ptr [edx + 0xd4]
00543E91 call     eax
00543E93 mov      byte ptr [ebp - 4], 0x1b
00543E97 lea      ecx, [ebp - 0x5a8]
00543E9D call     0x4056d0
00543EA2 mov      byte ptr [ebp - 4], 0
00543EA6 lea      ecx, [ebp - 0x58c]
00543EAC call     0x4056d0
00543EB1 mov      ecx, dword ptr [ebp - 0x140]
00543EB7 cmp      dword ptr [ecx + 0x19], 0
00543EBB jne      0x5440a9
00543EC1 mov      edx, dword ptr [0xb9741c]
00543EC7 push     edx
00543EC8 lea      ecx, [ebp - 0x5c4]
00543ECE call     0x405650
00543ED3 mov      byte ptr [ebp - 4], 0x1d
00543ED7 lea      eax, [ebp - 0x5c4]
00543EDD push     eax
00543EDE mov      ecx, dword ptr [ebp - 0x30]
00543EE1 call     0x75fbf0
00543EE6 mov      dword ptr [ebp - 0x13c], eax
00543EEC mov      byte ptr [ebp - 4], 0
00543EF0 lea      ecx, [ebp - 0x5c4]
00543EF6 call     0x4056d0
00543EFB cmp      dword ptr [ebp - 0x13c], 0
00543F02 je       0x543fb5
00543F08 mov      ecx, dword ptr [ebp - 0x140]
00543F0E cmp      dword ptr [ecx + 0x15], 0
00543F12 je       0x543fb5
00543F18 mov      edx, dword ptr [ebp - 0x140]
00543F1E add      edx, 0x15
00543F21 push     edx
00543F22 lea      eax, [ebp - 0x5e0]
00543F28 push     eax
00543F29 call     0x411c90
00543F2E add      esp, 8
00543F31 mov      dword ptr [ebp - 0xcc0], eax
00543F37 mov      ecx, dword ptr [ebp - 0xcc0]
00543F3D mov      dword ptr [ebp - 0xcc4], ecx
00543F43 mov      byte ptr [ebp - 4], 0x1e
00543F47 mov      edx, dword ptr [ebp - 0xcc4]
00543F4D push     edx
00543F4E push     0xbc99b0
00543F53 lea      eax, [ebp - 0x5fc]
00543F59 push     eax
00543F5A call     0x411d70
00543F5F add      esp, 0xc
00543F62 mov      dword ptr [ebp - 0xcc8], eax
00543F68 mov      ecx, dword ptr [ebp - 0xcc8]
00543F6E mov      dword ptr [ebp - 0xccc], ecx
00543F74 mov      byte ptr [ebp - 4], 0x1f
00543F78 push     1
00543F7A mov      edx, dword ptr [ebp - 0xccc]
00543F80 push     edx
00543F81 mov      eax, dword ptr [ebp - 0x13c]
00543F87 mov      edx, dword ptr [eax]
00543F89 mov      ecx, dword ptr [ebp - 0x13c]
00543F8F mov      eax, dword ptr [edx + 0xd4]
00543F95 call     eax
00543F97 mov      byte ptr [ebp - 4], 0x1e
00543F9B lea      ecx, [ebp - 0x5fc]
00543FA1 call     0x4056d0
00543FA6 mov      byte ptr [ebp - 4], 0
00543FAA lea      ecx, [ebp - 0x5e0]
00543FB0 call     0x4056d0
00543FB5 mov      ecx, dword ptr [0xb97420]
00543FBB push     ecx
00543FBC lea      ecx, [ebp - 0x618]
00543FC2 call     0x405650
00543FC7 mov      byte ptr [ebp - 4], 0x20
00543FCB lea      edx, [ebp - 0x618]
00543FD1 push     edx
00543FD2 mov      ecx, dword ptr [ebp - 0x30]
00543FD5 call     0x75fbf0
00543FDA mov      dword ptr [ebp - 0x13c], eax
00543FE0 mov      byte ptr [ebp - 4], 0
00543FE4 lea      ecx, [ebp - 0x618]
00543FEA call     0x4056d0
00543FEF cmp      dword ptr [ebp - 0x13c], 0
00543FF6 je       0x5440a9
00543FFC mov      eax, dword ptr [ebp - 0x140]
00544002 cmp      dword ptr [eax + 0x11], 0
00544006 je       0x5440a9
0054400C mov      ecx, dword ptr [ebp - 0x140]
00544012 add      ecx, 0x11
00544015 push     ecx
00544016 lea      edx, [ebp - 0x634]
0054401C push     edx
0054401D call     0x411c90
00544022 add      esp, 8
00544025 mov      dword ptr [ebp - 0xcd0], eax
0054402B mov      eax, dword ptr [ebp - 0xcd0]
00544031 mov      dword ptr [ebp - 0xcd4], eax
00544037 mov      byte ptr [ebp - 4], 0x21
0054403B mov      ecx, dword ptr [ebp - 0xcd4]
00544041 push     ecx
00544042 push     0xbc99c8
00544047 lea      edx, [ebp - 0x650]
0054404D push     edx
0054404E call     0x411d70
00544053 add      esp, 0xc
00544056 mov      dword ptr [ebp - 0xcd8], eax
0054405C mov      eax, dword ptr [ebp - 0xcd8]
00544062 mov      dword ptr [ebp - 0xcdc], eax
00544068 mov      byte ptr [ebp - 4], 0x22
0054406C push     1
0054406E mov      ecx, dword ptr [ebp - 0xcdc]
00544074 push     ecx
00544075 mov      edx, dword ptr [ebp - 0x13c]
0054407B mov      eax, dword ptr [edx]
0054407D mov      ecx, dword ptr [ebp - 0x13c]
00544083 mov      edx, dword ptr [eax + 0xd4]
00544089 call     edx
0054408B mov      byte ptr [ebp - 4], 0x21
0054408F lea      ecx, [ebp - 0x650]
00544095 call     0x4056d0
0054409A mov      byte ptr [ebp - 4], 0
0054409E lea      ecx, [ebp - 0x634]
005440A4 call     0x4056d0
005440A9 mov      eax, dword ptr [0xb9748c]
005440AE push     eax
005440AF lea      ecx, [ebp - 0x66c]
005440B5 call     0x405650
005440BA mov      byte ptr [ebp - 4], 0x23
005440BE lea      ecx, [ebp - 0x66c]
005440C4 push     ecx
005440C5 mov      ecx, dword ptr [ebp - 0x30]
005440C8 call     0x75fbf0
005440CD mov      dword ptr [ebp - 0x13c], eax
005440D3 mov      byte ptr [ebp - 4], 0
005440D7 lea      ecx, [ebp - 0x66c]
005440DD call     0x4056d0
005440E2 cmp      dword ptr [ebp - 0x13c], 0
005440E9 je       0x544167
005440EB mov      edx, dword ptr [ebp - 0x140]
005440F1 cmp      dword ptr [edx + 0x11], 0
005440F5 jne      0x54410f
005440F7 mov      eax, dword ptr [ebp - 0x140]
005440FD cmp      dword ptr [eax + 0x15], 0
00544101 jne      0x54410f
00544103 mov      ecx, dword ptr [ebp - 0x140]
00544109 cmp      dword ptr [ecx + 0x19], 0
0054410D je       0x544167
0054410F mov      edx, dword ptr [ebp - 0x13c]
00544115 mov      eax, dword ptr [edx]
00544117 mov      ecx, dword ptr [ebp - 0x13c]
0054411D mov      edx, dword ptr [eax + 0xc0]
00544123 call     edx
00544125 push     0xbc99d4
0054412A lea      ecx, [ebp - 0x688]
00544130 call     0x405650
00544135 mov      byte ptr [ebp - 4], 0x24
00544139 push     1
0054413B lea      eax, [ebp - 0x688]
00544141 push     eax
00544142 mov      ecx, dword ptr [ebp - 0x13c]
00544148 mov      edx, dword ptr [ecx]
0054414A mov      ecx, dword ptr [ebp - 0x13c]
00544150 mov      eax, dword ptr [edx + 0xd4]
00544156 call     eax
00544158 mov      byte ptr [ebp - 4], 0
0054415C lea      ecx, [ebp - 0x688]
00544162 call     0x4056d0
00544167 xor      ecx, ecx
00544169 mov      word ptr [ebp - 0x28], cx
0054416D mov      edx, dword ptr [0xb97494]
00544173 push     edx
00544174 lea      ecx, [ebp - 0x6a4]
0054417A call     0x405650
0054417F mov      byte ptr [ebp - 4], 0x25
00544183 lea      eax, [ebp - 0x6a4]
00544189 push     eax
0054418A mov      ecx, dword ptr [ebp - 0x30]
0054418D call     0x75fbf0
00544192 mov      dword ptr [ebp - 0x13c], eax
00544198 mov      byte ptr [ebp - 4], 0
0054419C lea      ecx, [ebp - 0x6a4]
005441A2 call     0x4056d0
005441A7 cmp      dword ptr [ebp - 0x13c], 0
005441AE je       0x544208
005441B0 mov      ecx, dword ptr [ebp - 0x13c]
005441B6 mov      edx, dword ptr [ecx]
005441B8 mov      ecx, dword ptr [ebp - 0x13c]
005441BE mov      eax, dword ptr [edx + 0xc4]
005441C4 call     eax
005441C6 push     0xb96699
005441CB lea      ecx, [ebp - 0x6c0]
005441D1 call     0x405650
005441D6 mov      byte ptr [ebp - 4], 0x26
005441DA push     1
005441DC lea      ecx, [ebp - 0x6c0]
005441E2 push     ecx
005441E3 mov      edx, dword ptr [ebp - 0x13c]
005441E9 mov      eax, dword ptr [edx]
005441EB mov      ecx, dword ptr [ebp - 0x13c]
005441F1 mov      edx, dword ptr [eax + 0xd4]
005441F7 call     edx
005441F9 mov      byte ptr [ebp - 4], 0
005441FD lea      ecx, [ebp - 0x6c0]
00544203 call     0x4056d0
00544208 mov      eax, dword ptr [ebp - 0x140]
0054420E cmp      dword ptr [eax + 0x14c], 0
00544215 je       0x5448c8
0054421B mov      ecx, dword ptr [0xb97494]
00544221 push     ecx
00544222 lea      ecx, [ebp - 0x6dc]
00544228 call     0x405650
0054422D mov      byte ptr [ebp - 4], 0x27
00544231 lea      edx, [ebp - 0x6dc]
00544237 push     edx
00544238 mov      ecx, dword ptr [ebp - 0x30]
0054423B call     0x75fbf0
00544240 mov      dword ptr [ebp - 0x13c], eax
00544246 mov      byte ptr [ebp - 4], 0
0054424A lea      ecx, [ebp - 0x6dc]
00544250 call     0x4056d0
00544255 cmp      dword ptr [ebp - 0x13c], 0
0054425C je       0x5442b6
0054425E mov      eax, dword ptr [ebp - 0x13c]
00544264 mov      edx, dword ptr [eax]
00544266 mov      ecx, dword ptr [ebp - 0x13c]
0054426C mov      eax, dword ptr [edx + 0xc0]
00544272 call     eax
00544274 push     0xbc99e0
00544279 lea      ecx, [ebp - 0x6f8]
0054427F call     0x405650
00544284 mov      byte ptr [ebp - 4], 0x28
00544288 push     1
0054428A lea      ecx, [ebp - 0x6f8]
00544290 push     ecx
00544291 mov      edx, dword ptr [ebp - 0x13c]
00544297 mov      eax, dword ptr [edx]
00544299 mov      ecx, dword ptr [ebp - 0x13c]
0054429F mov      edx, dword ptr [eax + 0xd4]
005442A5 call     edx
005442A7 mov      byte ptr [ebp - 4], 0
005442AB lea      ecx, [ebp - 0x6f8]
005442B1 call     0x4056d0
005442B6 mov      dword ptr [ebp - 0x174], 0
005442C0 jmp      0x5442d1
005442C2 mov      eax, dword ptr [ebp - 0x174]
005442C8 add      eax, 1
005442CB mov      dword ptr [ebp - 0x174], eax
005442D1 cmp      dword ptr [ebp - 0x174], 4
005442D8 jge      0x54454c
005442DE lea      ecx, [ebp - 0x174]
005442E4 push     ecx
005442E5 lea      edx, [ebp - 0x714]
005442EB push     edx
005442EC call     0xa44160
005442F1 add      esp, 8
005442F4 mov      dword ptr [ebp - 0xce0], eax
005442FA mov      eax, dword ptr [ebp - 0xce0]
00544300 mov      dword ptr [ebp - 0xce4], eax
00544306 mov      byte ptr [ebp - 4], 0x29
0054430A mov      ecx, dword ptr [ebp - 0xce4]
00544310 push     ecx
00544311 mov      edx, dword ptr [0xb97424]
00544317 push     edx
00544318 lea      eax, [ebp - 0x730]
0054431E push     eax
0054431F call     0x411d70
00544324 add      esp, 0xc
00544327 mov      dword ptr [ebp - 0xce8], eax
0054432D mov      ecx, dword ptr [ebp - 0xce8]
00544333 mov      dword ptr [ebp - 0xcec], ecx
00544339 mov      byte ptr [ebp - 4], 0x2a
0054433D mov      edx, dword ptr [ebp - 0xcec]
00544343 push     edx
00544344 mov      ecx, dword ptr [ebp - 0x30]
00544347 call     0x75fbf0
0054434C mov      dword ptr [ebp - 0x144], eax
00544352 mov      byte ptr [ebp - 4], 0x29
00544356 lea      ecx, [ebp - 0x730]
0054435C call     0x4056d0
00544361 mov      byte ptr [ebp - 4], 0
00544365 lea      ecx, [ebp - 0x714]
0054436B call     0x4056d0
00544370 lea      eax, [ebp - 0x174]
00544376 push     eax
00544377 lea      ecx, [ebp - 0x74c]
0054437D push     ecx
0054437E call     0xa44160
00544383 add      esp, 8
00544386 mov      dword ptr [ebp - 0xcf0], eax
0054438C mov      edx, dword ptr [ebp - 0xcf0]
00544392 mov      dword ptr [ebp - 0xcf4], edx
00544398 mov      byte ptr [ebp - 4], 0x2b
0054439C mov      eax, dword ptr [ebp - 0xcf4]
005443A2 push     eax
005443A3 mov      ecx, dword ptr [0xb97430]
005443A9 push     ecx
005443AA lea      edx, [ebp - 0x768]
005443B0 push     edx
005443B1 call     0x411d70
005443B6 add      esp, 0xc
005443B9 mov      dword ptr [ebp - 0xcf8], eax
005443BF mov      eax, dword ptr [ebp - 0xcf8]
005443C5 mov      dword ptr [ebp - 0xcfc], eax
005443CB mov      byte ptr [ebp - 4], 0x2c
005443CF mov      ecx, dword ptr [ebp - 0xcfc]
005443D5 push     ecx
005443D6 mov      ecx, dword ptr [ebp - 0x30]
005443D9 call     0x75fbf0
005443DE mov      dword ptr [ebp - 0x13c], eax
005443E4 mov      byte ptr [ebp - 4], 0x2b
005443E8 lea      ecx, [ebp - 0x768]
005443EE call     0x4056d0
005443F3 mov      byte ptr [ebp - 4], 0
005443F7 lea      ecx, [ebp - 0x74c]
005443FD call     0x4056d0
00544402 lea      edx, [ebp - 0x174]
00544408 push     edx
00544409 lea      eax, [ebp - 0x784]
0054440F push     eax
00544410 call     0xa44160
00544415 add      esp, 8
00544418 mov      dword ptr [ebp - 0xd00], eax
0054441E mov      ecx, dword ptr [ebp - 0xd00]
00544424 mov      dword ptr [ebp - 0xd04], ecx
0054442A mov      byte ptr [ebp - 4], 0x2d
0054442E mov      edx, dword ptr [ebp - 0xd04]
00544434 push     edx
00544435 mov      eax, dword ptr [0xb97490]
0054443A push     eax
0054443B lea      ecx, [ebp - 0x7a0]
00544441 push     ecx
00544442 call     0x411d70
00544447 add      esp, 0xc
0054444A mov      dword ptr [ebp - 0xd08], eax
00544450 mov      edx, dword ptr [ebp - 0xd08]
00544456 mov      dword ptr [ebp - 0xd0c], edx
0054445C mov      byte ptr [ebp - 4], 0x2e
00544460 mov      eax, dword ptr [ebp - 0xd0c]
00544466 push     eax
00544467 mov      ecx, dword ptr [ebp - 0x30]
0054446A call     0x75fbf0
0054446F mov      dword ptr [ebp - 0x178], eax
00544475 mov      byte ptr [ebp - 4], 0x2d
00544479 lea      ecx, [ebp - 0x7a0]
0054447F call     0x4056d0
00544484 mov      byte ptr [ebp - 4], 0
00544488 lea      ecx, [ebp - 0x784]
0054448E call     0x4056d0
00544493 cmp      dword ptr [ebp - 0x178], 0
0054449A je       0x5444b2
0054449C mov      ecx, dword ptr [ebp - 0x178]
005444A2 mov      edx, dword ptr [ecx]
005444A4 mov      ecx, dword ptr [ebp - 0x178]
005444AA mov      eax, dword ptr [edx + 0xc4]
005444B0 call     eax
005444B2 cmp      dword ptr [ebp - 0x144], 0
005444B9 je       0x544547
005444BF cmp      dword ptr [ebp - 0x13c], 0
005444C6 je       0x544547
005444C8 push     0xb96699
005444CD lea      ecx, [ebp - 0x7bc]
005444D3 call     0x405650
005444D8 mov      byte ptr [ebp - 4], 0x2f
005444DC push     1
005444DE lea      ecx, [ebp - 0x7bc]
005444E4 push     ecx
005444E5 mov      edx, dword ptr [ebp - 0x13c]
005444EB mov      eax, dword ptr [edx]
005444ED mov      ecx, dword ptr [ebp - 0x13c]
005444F3 mov      edx, dword ptr [eax + 0xd4]
005444F9 call     edx
005444FB mov      byte ptr [ebp - 4], 0
005444FF lea      ecx, [ebp - 0x7bc]
00544505 call     0x4056d0
0054450A push     0xb96699
0054450F lea      ecx, [ebp - 0x7d8]
00544515 call     0x405650
0054451A mov      byte ptr [ebp - 4], 0x30
0054451E lea      eax, [ebp - 0x7d8]
00544524 push     eax
00544525 mov      ecx, dword ptr [ebp - 0x144]
0054452B mov      edx, dword ptr [ecx]
0054452D mov      ecx, dword ptr [ebp - 0x144]
00544533 mov      eax, dword ptr [edx + 0x28]
00544536 call     eax
00544538 mov      byte ptr [ebp - 4], 0
0054453C lea      ecx, [ebp - 0x7d8]
00544542 call     0x4056d0
00544547 jmp      0x5442c2
0054454C mov      ecx, dword ptr [0x17c86fc]
00544552 call     0x9cd990
00544557 mov      dword ptr [ebp - 0x170], eax
0054455D mov      ecx, dword ptr [ebp - 0x170]
00544563 sub      ecx, 1
00544566 mov      dword ptr [ebp - 0x16c], ecx
0054456C cmp      dword ptr [ebp - 0x170], 0
00544573 jle      0x5448c3
00544579 cmp      dword ptr [ebp - 0x170], 0x19
00544580 je       0x5448c3
00544586 mov      dword ptr [ebp - 0x7dc], 0
00544590 lea      edx, [ebp - 0x7dc]
00544596 push     edx
00544597 lea      eax, [ebp - 0x7f8]
0054459D push     eax
0054459E call     0xa44160
005445A3 add      esp, 8
005445A6 mov      dword ptr [ebp - 0xd10], eax
005445AC mov      ecx, dword ptr [ebp - 0xd10]
005445B2 mov      dword ptr [ebp - 0xd14], ecx
005445B8 mov      byte ptr [ebp - 4], 0x31
005445BC mov      edx, dword ptr [ebp - 0xd14]
005445C2 push     edx
005445C3 mov      eax, dword ptr [0xb97424]
005445C8 push     eax
005445C9 lea      ecx, [ebp - 0x814]
005445CF push     ecx
005445D0 call     0x411d70
005445D5 add      esp, 0xc
005445D8 mov      dword ptr [ebp - 0xd18], eax
005445DE mov      edx, dword ptr [ebp - 0xd18]
005445E4 mov      dword ptr [ebp - 0xd1c], edx
005445EA mov      byte ptr [ebp - 4], 0x32
005445EE mov      eax, dword ptr [ebp - 0xd1c]
005445F4 push     eax
005445F5 mov      ecx, dword ptr [ebp - 0x30]
005445F8 call     0x75fbf0
005445FD mov      dword ptr [ebp - 0x144], eax
00544603 mov      byte ptr [ebp - 4], 0x31
00544607 lea      ecx, [ebp - 0x814]
0054460D call     0x4056d0
00544612 mov      byte ptr [ebp - 4], 0
00544616 lea      ecx, [ebp - 0x7f8]
0054461C call     0x4056d0
00544621 mov      dword ptr [ebp - 0x818], 0
0054462B lea      ecx, [ebp - 0x818]
00544631 push     ecx
00544632 lea      edx, [ebp - 0x834]
00544638 push     edx
00544639 call     0xa44160
0054463E add      esp, 8
00544641 mov      dword ptr [ebp - 0xd20], eax
00544647 mov      eax, dword ptr [ebp - 0xd20]
0054464D mov      dword ptr [ebp - 0xd24], eax
00544653 mov      byte ptr [ebp - 4], 0x33
00544657 mov      ecx, dword ptr [ebp - 0xd24]
0054465D push     ecx
0054465E mov      edx, dword ptr [0xb97430]
00544664 push     edx
00544665 lea      eax, [ebp - 0x850]
0054466B push     eax
0054466C call     0x411d70
00544671 add      esp, 0xc
00544674 mov      dword ptr [ebp - 0xd28], eax
0054467A mov      ecx, dword ptr [ebp - 0xd28]
00544680 mov      dword ptr [ebp - 0xd2c], ecx
00544686 mov      byte ptr [ebp - 4], 0x34
0054468A mov      edx, dword ptr [ebp - 0xd2c]
00544690 push     edx
00544691 mov      ecx, dword ptr [ebp - 0x30]
00544694 call     0x75fbf0
00544699 mov      dword ptr [ebp - 0x13c], eax
0054469F mov      byte ptr [ebp - 4], 0x33
005446A3 lea      ecx, [ebp - 0x850]
005446A9 call     0x4056d0
005446AE mov      byte ptr [ebp - 4], 0
005446B2 lea      ecx, [ebp - 0x834]
005446B8 call     0x4056d0
005446BD mov      dword ptr [ebp - 0x854], 0
005446C7 lea      eax, [ebp - 0x854]
005446CD push     eax
005446CE lea      ecx, [ebp - 0x870]
005446D4 push     ecx
005446D5 call     0xa44160
005446DA add      esp, 8
005446DD mov      dword ptr [ebp - 0xd30], eax
005446E3 mov      edx, dword ptr [ebp - 0xd30]
005446E9 mov      dword ptr [ebp - 0xd34], edx
005446EF mov      byte ptr [ebp - 4], 0x35
005446F3 mov      eax, dword ptr [ebp - 0xd34]
005446F9 push     eax
005446FA mov      ecx, dword ptr [0xb97490]
00544700 push     ecx
00544701 lea      edx, [ebp - 0x88c]
00544707 push     edx
00544708 call     0x411d70
0054470D add      esp, 0xc
00544710 mov      dword ptr [ebp - 0xd38], eax
00544716 mov      eax, dword ptr [ebp - 0xd38]
0054471C mov      dword ptr [ebp - 0xd3c], eax
00544722 mov      byte ptr [ebp - 4], 0x36
00544726 mov      ecx, dword ptr [ebp - 0xd3c]
0054472C push     ecx
0054472D mov      ecx, dword ptr [ebp - 0x30]
00544730 call     0x75fbf0
00544735 mov      dword ptr [ebp - 0x1f4], eax
0054473B mov      byte ptr [ebp - 4], 0x35
0054473F lea      ecx, [ebp - 0x88c]
00544745 call     0x4056d0
0054474A mov      byte ptr [ebp - 4], 0
0054474E lea      ecx, [ebp - 0x870]
00544754 call     0x4056d0
00544759 push     0x6c
0054475B push     0
0054475D lea      edx, [ebp - 0x1ec]
00544763 push     edx
00544764 call     0x666960
00544769 add      esp, 0xc
0054476C mov      dword ptr [ebp - 0x1f0], 0
00544776 lea      eax, [ebp - 0x1ec]
0054477C push     eax
0054477D mov      ecx, dword ptr [ebp - 0x16c]
00544783 mov      edx, dword ptr [ebp - 0x140]
00544789 mov      eax, dword ptr [edx + ecx*4 + 0x90]
00544790 push     eax
00544791 call     0x41bc70
00544796 mov      ecx, eax
00544798 call     0x85ba40
0054479D test     eax, eax
0054479F je       0x5447ba
005447A1 mov      ecx, dword ptr [ebp - 0x1e7]
005447A7 push     ecx
005447A8 call     0xa21b30
005447AD mov      ecx, eax
005447AF call     0xa1e560
005447B4 mov      dword ptr [ebp - 0x1f0], eax
005447BA cmp      dword ptr [ebp - 0x1f4], 0
005447C1 je       0x5448c3
005447C7 cmp      dword ptr [ebp - 0x13c], 0
005447CE je       0x5448c3
005447D4 cmp      dword ptr [ebp - 0x144], 0
005447DB je       0x5448c3
005447E1 cmp      dword ptr [ebp - 0x1f0], 0
005447E8 je       0x5448c3
005447EE mov      edx, dword ptr [ebp - 0x1f4]
005447F4 mov      eax, dword ptr [edx]
005447F6 mov      ecx, dword ptr [ebp - 0x1f4]
005447FC mov      edx, dword ptr [eax + 0xc0]
00544802 call     edx
00544804 mov      eax, dword ptr [ebp - 0x13c]
0054480A mov      edx, dword ptr [eax]
0054480C mov      ecx, dword ptr [ebp - 0x13c]
00544812 mov      eax, dword ptr [edx + 0xc0]
00544818 call     eax
0054481A mov      ecx, dword ptr [ebp - 0x144]
00544820 mov      edx, dword ptr [ecx]
00544822 mov      ecx, dword ptr [ebp - 0x144]
00544828 mov      eax, dword ptr [edx + 0xc0]
0054482E call     eax
00544830 mov      ecx, dword ptr [ebp - 0x1f0]
00544836 add      ecx, 0x44
00544839 call     0x406410
0054483E push     eax
0054483F lea      ecx, [ebp - 0x8a8]
00544845 call     0x405650
0054484A mov      byte ptr [ebp - 4], 0x37
0054484E lea      ecx, [ebp - 0x8a8]
00544854 push     ecx
00544855 mov      edx, dword ptr [ebp - 0x144]
0054485B mov      eax, dword ptr [edx]
0054485D mov      ecx, dword ptr [ebp - 0x144]
00544863 mov      edx, dword ptr [eax + 0x28]
00544866 call     edx
00544868 mov      byte ptr [ebp - 4], 0
0054486C lea      ecx, [ebp - 0x8a8]
00544872 call     0x4056d0
00544877 mov      ecx, dword ptr [ebp - 0x1f0]
0054487D add      ecx, 0xc
00544880 call     0x406410
00544885 push     eax
00544886 lea      ecx, [ebp - 0x8c4]
0054488C call     0x405650
00544891 mov      byte ptr [ebp - 4], 0x38
00544895 push     1
00544897 lea      eax, [ebp - 0x8c4]
0054489D push     eax
0054489E mov      ecx, dword ptr [ebp - 0x13c]
005448A4 mov      edx, dword ptr [ecx]
005448A6 mov      ecx, dword ptr [ebp - 0x13c]
005448AC mov      eax, dword ptr [edx + 0xd4]
005448B2 call     eax
005448B4 mov      byte ptr [ebp - 4], 0
005448B8 lea      ecx, [ebp - 0x8c4]
005448BE call     0x4056d0
005448C3 jmp      0x544f65
005448C8 mov      dword ptr [ebp - 0x1f8], 0
005448D2 jmp      0x5448e3
005448D4 mov      ecx, dword ptr [ebp - 0x1f8]
005448DA add      ecx, 1
005448DD mov      dword ptr [ebp - 0x1f8], ecx
005448E3 cmp      dword ptr [ebp - 0x1f8], 4
005448EA jge      0x544e20
005448F0 lea      edx, [ebp - 0x1f8]
005448F6 push     edx
005448F7 lea      eax, [ebp - 0x8e0]
005448FD push     eax
005448FE call     0xa44160
00544903 add      esp, 8
00544906 mov      dword ptr [ebp - 0xd40], eax
0054490C mov      ecx, dword ptr [ebp - 0xd40]
00544912 mov      dword ptr [ebp - 0xd44], ecx
00544918 mov      byte ptr [ebp - 4], 0x39
0054491C mov      edx, dword ptr [ebp - 0xd44]
00544922 push     edx
00544923 mov      eax, dword ptr [0xb97424]
00544928 push     eax
00544929 lea      ecx, [ebp - 0x8fc]
0054492F push     ecx
00544930 call     0x411d70
00544935 add      esp, 0xc
00544938 mov      dword ptr [ebp - 0xd48], eax
0054493E mov      edx, dword ptr [ebp - 0xd48]
00544944 mov      dword ptr [ebp - 0xd4c], edx
0054494A mov      byte ptr [ebp - 4], 0x3a
0054494E mov      eax, dword ptr [ebp - 0xd4c]
00544954 push     eax
00544955 mov      ecx, dword ptr [ebp - 0x30]
00544958 call     0x75fbf0
0054495D mov      dword ptr [ebp - 0x144], eax
00544963 mov      byte ptr [ebp - 4], 0x39
00544967 lea      ecx, [ebp - 0x8fc]
0054496D call     0x4056d0
00544972 mov      byte ptr [ebp - 4], 0
00544976 lea      ecx, [ebp - 0x8e0]
0054497C call     0x4056d0
00544981 lea      ecx, [ebp - 0x1f8]
00544987 push     ecx
00544988 lea      edx, [ebp - 0x918]
0054498E push     edx
0054498F call     0xa44160
00544994 add      esp, 8
00544997 mov      dword ptr [ebp - 0xd50], eax
0054499D mov      eax, dword ptr [ebp - 0xd50]
005449A3 mov      dword ptr [ebp - 0xd54], eax
005449A9 mov      byte ptr [ebp - 4], 0x3b
005449AD mov      ecx, dword ptr [ebp - 0xd54]
005449B3 push     ecx
005449B4 mov      edx, dword ptr [0xb97430]
005449BA push     edx
005449BB lea      eax, [ebp - 0x934]
005449C1 push     eax
005449C2 call     0x411d70
005449C7 add      esp, 0xc
005449CA mov      dword ptr [ebp - 0xd58], eax
005449D0 mov      ecx, dword ptr [ebp - 0xd58]
005449D6 mov      dword ptr [ebp - 0xd5c], ecx
005449DC mov      byte ptr [ebp - 4], 0x3c
005449E0 mov      edx, dword ptr [ebp - 0xd5c]
005449E6 push     edx
005449E7 mov      ecx, dword ptr [ebp - 0x30]
005449EA call     0x75fbf0
005449EF mov      dword ptr [ebp - 0x13c], eax
005449F5 mov      byte ptr [ebp - 4], 0x3b
005449F9 lea      ecx, [ebp - 0x934]
005449FF call     0x4056d0
00544A04 mov      byte ptr [ebp - 4], 0
00544A08 lea      ecx, [ebp - 0x918]
00544A0E call     0x4056d0
00544A13 lea      eax, [ebp - 0x1f8]
00544A19 push     eax
00544A1A lea      ecx, [ebp - 0x950]
00544A20 push     ecx
00544A21 call     0xa44160
00544A26 add      esp, 8
00544A29 mov      dword ptr [ebp - 0xd60], eax
00544A2F mov      edx, dword ptr [ebp - 0xd60]
00544A35 mov      dword ptr [ebp - 0xd64], edx
00544A3B mov      byte ptr [ebp - 4], 0x3d
00544A3F mov      eax, dword ptr [ebp - 0xd64]
00544A45 push     eax
00544A46 mov      ecx, dword ptr [0xb97490]
00544A4C push     ecx
00544A4D lea      edx, [ebp - 0x96c]
00544A53 push     edx
00544A54 call     0x411d70
00544A59 add      esp, 0xc
00544A5C mov      dword ptr [ebp - 0xd68], eax
00544A62 mov      eax, dword ptr [ebp - 0xd68]
00544A68 mov      dword ptr [ebp - 0xd6c], eax
00544A6E mov      byte ptr [ebp - 4], 0x3e
00544A72 mov      ecx, dword ptr [ebp - 0xd6c]
00544A78 push     ecx
00544A79 mov      ecx, dword ptr [ebp - 0x30]
00544A7C call     0x75fbf0
00544A81 mov      dword ptr [ebp - 0x1fc], eax
00544A87 mov      byte ptr [ebp - 4], 0x3d
00544A8B lea      ecx, [ebp - 0x96c]
00544A91 call     0x4056d0
00544A96 mov      byte ptr [ebp - 4], 0
00544A9A lea      ecx, [ebp - 0x950]
00544AA0 call     0x4056d0
00544AA5 lea      edx, [ebp - 0x1f8]
00544AAB push     edx
00544AAC lea      eax, [ebp - 0x988]
00544AB2 push     eax
00544AB3 call     0xa44160
00544AB8 add      esp, 8
00544ABB mov      dword ptr [ebp - 0xd70], eax
00544AC1 mov      ecx, dword ptr [ebp - 0xd70]
00544AC7 mov      dword ptr [ebp - 0xd74], ecx
00544ACD mov      byte ptr [ebp - 4], 0x3f
00544AD1 mov      edx, dword ptr [ebp - 0xd74]
00544AD7 push     edx
00544AD8 mov      eax, dword ptr [0xb97428]
00544ADD push     eax
00544ADE lea      ecx, [ebp - 0x9a4]
00544AE4 push     ecx
00544AE5 call     0x411d70
00544AEA add      esp, 0xc
00544AED mov      dword ptr [ebp - 0xd78], eax
00544AF3 mov      edx, dword ptr [ebp - 0xd78]
00544AF9 mov      dword ptr [ebp - 0xd7c], edx
00544AFF mov      byte ptr [ebp - 4], 0x40
00544B03 mov      eax, dword ptr [ebp - 0xd7c]
00544B09 push     eax
00544B0A mov      ecx, dword ptr [ebp - 0x30]
00544B0D call     0x75fbf0
00544B12 mov      dword ptr [ebp - 0x200], eax
00544B18 mov      byte ptr [ebp - 4], 0x3f
00544B1C lea      ecx, [ebp - 0x9a4]
00544B22 call     0x4056d0
00544B27 mov      byte ptr [ebp - 4], 0
00544B2B lea      ecx, [ebp - 0x988]
00544B31 call     0x4056d0
00544B36 cmp      dword ptr [ebp - 0x1fc], 0
00544B3D je       0x544b55
00544B3F mov      ecx, dword ptr [ebp - 0x1fc]
00544B45 mov      edx, dword ptr [ecx]
00544B47 mov      ecx, dword ptr [ebp - 0x1fc]
00544B4D mov      eax, dword ptr [edx + 0xc4]
00544B53 call     eax
00544B55 cmp      dword ptr [ebp - 0x144], 0
00544B5C je       0x544bea
00544B62 cmp      dword ptr [ebp - 0x13c], 0
00544B69 je       0x544bea
00544B6B push     0xb96699
00544B70 lea      ecx, [ebp - 0x9c0]
00544B76 call     0x405650
00544B7B mov      byte ptr [ebp - 4], 0x41
00544B7F push     1
00544B81 lea      ecx, [ebp - 0x9c0]
00544B87 push     ecx
00544B88 mov      edx, dword ptr [ebp - 0x13c]
00544B8E mov      eax, dword ptr [edx]
00544B90 mov      ecx, dword ptr [ebp - 0x13c]
00544B96 mov      edx, dword ptr [eax + 0xd4]
00544B9C call     edx
00544B9E mov      byte ptr [ebp - 4], 0
00544BA2 lea      ecx, [ebp - 0x9c0]
00544BA8 call     0x4056d0
00544BAD push     0xb96699
00544BB2 lea      ecx, [ebp - 0x9dc]
00544BB8 call     0x405650
00544BBD mov      byte ptr [ebp - 4], 0x42
00544BC1 lea      eax, [ebp - 0x9dc]
00544BC7 push     eax
00544BC8 mov      ecx, dword ptr [ebp - 0x144]
00544BCE mov      edx, dword ptr [ecx]
00544BD0 mov      ecx, dword ptr [ebp - 0x144]
00544BD6 mov      eax, dword ptr [edx + 0x28]
00544BD9 call     eax
00544BDB mov      byte ptr [ebp - 4], 0
00544BDF lea      ecx, [ebp - 0x9dc]
00544BE5 call     0x4056d0
00544BEA mov      ecx, dword ptr [ebp - 0x1f8]
00544BF0 mov      edx, dword ptr [ebp - 0x140]
00544BF6 cmp      dword ptr [edx + ecx*4 + 0x90], 0
00544BFE je       0x544e1b
00544C04 push     0x6c
00544C06 push     0
00544C08 lea      eax, [ebp - 0x274]
00544C0E push     eax
00544C0F call     0x666960
00544C14 add      esp, 0xc
00544C17 mov      dword ptr [ebp - 0x278], 0
00544C21 lea      ecx, [ebp - 0x274]
00544C27 push     ecx
00544C28 mov      edx, dword ptr [ebp - 0x1f8]
00544C2E mov      eax, dword ptr [ebp - 0x140]
00544C34 mov      ecx, dword ptr [eax + edx*4 + 0x90]
00544C3B push     ecx
00544C3C call     0x41bc70
00544C41 mov      ecx, eax
00544C43 call     0x85ba40
00544C48 test     eax, eax
00544C4A je       0x544c65
00544C4C mov      edx, dword ptr [ebp - 0x26f]
00544C52 push     edx
00544C53 call     0xa21b30
00544C58 mov      ecx, eax
00544C5A call     0xa1e560
00544C5F mov      dword ptr [ebp - 0x278], eax
00544C65 cmp      dword ptr [ebp - 0x278], 0
00544C6C je       0x544e1b
00544C72 cmp      dword ptr [ebp - 0x1fc], 0
00544C79 je       0x544e1b
00544C7F cmp      dword ptr [ebp - 0x144], 0
00544C86 je       0x544e1b
00544C8C cmp      dword ptr [ebp - 0x13c], 0
00544C93 je       0x544e1b
00544C99 mov      eax, dword ptr [ebp - 0x1fc]
00544C9F mov      edx, dword ptr [eax]
00544CA1 mov      ecx, dword ptr [ebp - 0x1fc]
00544CA7 mov      eax, dword ptr [edx + 0xc0]
00544CAD call     eax
00544CAF mov      ecx, dword ptr [ebp - 0x13c]
00544CB5 mov      edx, dword ptr [ecx]
00544CB7 mov      ecx, dword ptr [ebp - 0x13c]
00544CBD mov      eax, dword ptr [edx + 0xc0]
00544CC3 call     eax
00544CC5 mov      ecx, dword ptr [ebp - 0x144]
00544CCB mov      edx, dword ptr [ecx]
00544CCD mov      ecx, dword ptr [ebp - 0x144]
00544CD3 mov      eax, dword ptr [edx + 0xc0]
00544CD9 call     eax
00544CDB mov      ecx, dword ptr [ebp - 0x278]
00544CE1 add      ecx, 0x44
00544CE4 call     0x406410
00544CE9 push     eax
00544CEA lea      ecx, [ebp - 0x9f8]
00544CF0 call     0x405650
00544CF5 mov      byte ptr [ebp - 4], 0x43
00544CF9 lea      ecx, [ebp - 0x9f8]
00544CFF push     ecx
00544D00 mov      edx, dword ptr [ebp - 0x144]
00544D06 mov      eax, dword ptr [edx]
00544D08 mov      ecx, dword ptr [ebp - 0x144]
00544D0E mov      edx, dword ptr [eax + 0x28]
00544D11 call     edx
00544D13 mov      byte ptr [ebp - 4], 0
00544D17 lea      ecx, [ebp - 0x9f8]
00544D1D call     0x4056d0
00544D22 mov      ecx, dword ptr [ebp - 0x278]
00544D28 add      ecx, 0xc
00544D2B call     0x406410
00544D30 push     eax
00544D31 lea      ecx, [ebp - 0xa14]
00544D37 call     0x405650
00544D3C mov      byte ptr [ebp - 4], 0x44
00544D40 push     1
00544D42 lea      eax, [ebp - 0xa14]
00544D48 push     eax
00544D49 mov      ecx, dword ptr [ebp - 0x13c]
00544D4F mov      edx, dword ptr [ecx]
00544D51 mov      ecx, dword ptr [ebp - 0x13c]
00544D57 mov      eax, dword ptr [edx + 0xd4]
00544D5D call     eax
00544D5F mov      byte ptr [ebp - 4], 0
00544D63 lea      ecx, [ebp - 0xa14]
00544D69 call     0x4056d0
00544D6E mov      ecx, dword ptr [ebp - 0x1f8]
00544D74 mov      edx, dword ptr [ebp - 0x140]
00544D7A mov      eax, dword ptr [edx + ecx*4 + 0x90]
00544D81 cdq
00544D82 mov      ecx, 0x64
00544D87 idiv     ecx
00544D89 mov      dword ptr [ebp - 0xa18], eax
00544D8F lea      edx, [ebp - 0xa18]
00544D95 push     edx
00544D96 lea      eax, [ebp - 0xa34]
00544D9C push     eax
00544D9D call     0xa44160
00544DA2 add      esp, 8
00544DA5 mov      dword ptr [ebp - 0xd80], eax
00544DAB mov      ecx, dword ptr [ebp - 0xd80]
00544DB1 mov      dword ptr [ebp - 0xd84], ecx
00544DB7 mov      byte ptr [ebp - 4], 0x45
00544DBB mov      edx, dword ptr [ebp - 0xd84]
00544DC1 push     edx
00544DC2 push     0xbb6b98
00544DC7 lea      eax, [ebp - 0x294]
00544DCD push     eax
00544DCE call     0x411d70
00544DD3 add      esp, 0xc
00544DD6 mov      byte ptr [ebp - 4], 0x47
00544DDA lea      ecx, [ebp - 0xa34]
00544DE0 call     0x4056d0
00544DE5 cmp      dword ptr [ebp - 0x200], 0
00544DEC je       0x544e00
00544DEE lea      ecx, [ebp - 0x294]
00544DF4 push     ecx
00544DF5 mov      ecx, dword ptr [ebp - 0x200]
00544DFB call     0x4c16b0
00544E00 mov      dx, word ptr [ebp - 0x28]
00544E04 add      dx, 1
00544E08 mov      word ptr [ebp - 0x28], dx
00544E0C mov      byte ptr [ebp - 4], 0
00544E10 lea      ecx, [ebp - 0x294]
00544E16 call     0x4056d0
00544E1B jmp      0x5448d4
00544E20 mov      eax, dword ptr [0xb97494]
00544E25 push     eax
00544E26 lea      ecx, [ebp - 0xa50]
00544E2C call     0x405650
00544E31 mov      byte ptr [ebp - 4], 0x48
00544E35 lea      ecx, [ebp - 0xa50]
00544E3B push     ecx
00544E3C mov      ecx, dword ptr [ebp - 0x30]
00544E3F call     0x75fbf0
00544E44 mov      dword ptr [ebp - 0x13c], eax
00544E4A mov      byte ptr [ebp - 4], 0
00544E4E lea      ecx, [ebp - 0xa50]
00544E54 call     0x4056d0
00544E59 cmp      dword ptr [ebp - 0x13c], 0
00544E60 je       0x544eba
00544E62 mov      edx, dword ptr [ebp - 0x13c]
00544E68 mov      eax, dword ptr [edx]
00544E6A mov      ecx, dword ptr [ebp - 0x13c]
00544E70 mov      edx, dword ptr [eax + 0xc4]
00544E76 call     edx
00544E78 push     0xb96699
00544E7D lea      ecx, [ebp - 0xa6c]
00544E83 call     0x405650
00544E88 mov      byte ptr [ebp - 4], 0x49
00544E8C push     1
00544E8E lea      eax, [ebp - 0xa6c]
00544E94 push     eax
00544E95 mov      ecx, dword ptr [ebp - 0x13c]
00544E9B mov      edx, dword ptr [ecx]
00544E9D mov      ecx, dword ptr [ebp - 0x13c]
00544EA3 mov      eax, dword ptr [edx + 0xd4]
00544EA9 call     eax
00544EAB mov      byte ptr [ebp - 4], 0
00544EAF lea      ecx, [ebp - 0xa6c]
00544EB5 call     0x4056d0
00544EBA movsx    ecx, word ptr [ebp - 0x28]
00544EBE test     ecx, ecx
00544EC0 jle      0x544f1a
00544EC2 mov      edx, dword ptr [ebp - 0x13c]
00544EC8 mov      eax, dword ptr [edx]
00544ECA mov      ecx, dword ptr [ebp - 0x13c]
00544ED0 mov      edx, dword ptr [eax + 0xc0]
00544ED6 call     edx
00544ED8 push     0xbc99e0
00544EDD lea      ecx, [ebp - 0xa88]
00544EE3 call     0x405650
00544EE8 mov      byte ptr [ebp - 4], 0x4a
00544EEC push     1
00544EEE lea      eax, [ebp - 0xa88]
00544EF4 push     eax
00544EF5 mov      ecx, dword ptr [ebp - 0x13c]
00544EFB mov      edx, dword ptr [ecx]
00544EFD mov      ecx, dword ptr [ebp - 0x13c]
00544F03 mov      eax, dword ptr [edx + 0xd4]
00544F09 call     eax
00544F0B mov      byte ptr [ebp - 4], 0
00544F0F lea      ecx, [ebp - 0xa88]
00544F15 call     0x4056d0
00544F1A movsx    ecx, word ptr [ebp - 0x28]
00544F1E cmp      ecx, 1
00544F21 jle      0x544f65
00544F23 push     0xbc9a18
00544F28 lea      ecx, [ebp - 0xaa4]
00544F2E call     0x405650
00544F33 mov      byte ptr [ebp - 4], 0x4b
00544F37 push     1
00544F39 lea      edx, [ebp - 0xaa4]
00544F3F push     edx
00544F40 mov      eax, dword ptr [ebp - 0x13c]
00544F46 mov      edx, dword ptr [eax]
00544F48 mov      ecx, dword ptr [ebp - 0x13c]
00544F4E mov      eax, dword ptr [edx + 0xd4]
00544F54 call     eax
00544F56 mov      byte ptr [ebp - 4], 0
00544F5A lea      ecx, [ebp - 0xaa4]
00544F60 call     0x4056d0
00544F65 mov      ecx, dword ptr [0xb97448]
00544F6B push     ecx
00544F6C lea      ecx, [ebp - 0xac0]
00544F72 call     0x405650
00544F77 mov      byte ptr [ebp - 4], 0x4c
00544F7B push     0
00544F7D lea      edx, [ebp - 0xac0]
00544F83 push     edx
00544F84 mov      ecx, dword ptr [ebp - 0x30]
00544F87 call     0x7611c0
00544F8C mov      byte ptr [ebp - 4], 0
00544F90 lea      ecx, [ebp - 0xac0]
00544F96 call     0x4056d0
00544F9B mov      eax, dword ptr [0xb9744c]
00544FA0 push     eax
00544FA1 lea      ecx, [ebp - 0xadc]
00544FA7 call     0x405650
00544FAC mov      byte ptr [ebp - 4], 0x4d
00544FB0 push     0
00544FB2 lea      ecx, [ebp - 0xadc]
00544FB8 push     ecx
00544FB9 mov      ecx, dword ptr [ebp - 0x30]
00544FBC call     0x7611c0
00544FC1 mov      byte ptr [ebp - 4], 0
00544FC5 lea      ecx, [ebp - 0xadc]
00544FCB call     0x4056d0
00544FD0 mov      edx, dword ptr [0xb97478]
00544FD6 push     edx
00544FD7 lea      ecx, [ebp - 0xaf8]
00544FDD call     0x405650
00544FE2 mov      byte ptr [ebp - 4], 0x4e
00544FE6 push     0
00544FE8 lea      eax, [ebp - 0xaf8]
00544FEE push     eax
00544FEF mov      ecx, dword ptr [ebp - 0x30]
00544FF2 call     0x7611c0
00544FF7 mov      byte ptr [ebp - 4], 0
00544FFB lea      ecx, [ebp - 0xaf8]
00545001 call     0x4056d0
00545006 mov      ecx, dword ptr [ebp - 0x138]
0054500C movzx    edx, byte ptr [ecx + 0x10]
00545010 mov      dword ptr [ebp - 0xd88], edx
00545016 mov      eax, dword ptr [ebp - 0xd88]
0054501C sub      eax, 1
0054501F mov      dword ptr [ebp - 0xd88], eax
00545025 cmp      dword ptr [ebp - 0xd88], 3
0054502C ja       0x5452d2
00545032 mov      ecx, dword ptr [ebp - 0xd88]
00545038 jmp      dword ptr [ecx*4 + 0x545300]
0054503F mov      edx, dword ptr [0xb97448]
00545045 push     edx
00545046 lea      ecx, [ebp - 0xb14]
0054504C call     0x405650
00545051 mov      byte ptr [ebp - 4], 0x4f
00545055 push     1
00545057 lea      eax, [ebp - 0xb14]
0054505D push     eax
0054505E mov      ecx, dword ptr [ebp - 0x30]
00545061 call     0x7611c0
00545066 mov      byte ptr [ebp - 4], 0
0054506A lea      ecx, [ebp - 0xb14]
00545070 call     0x4056d0
00545075 mov      ecx, dword ptr [0xb9744c]
0054507B push     ecx
0054507C lea      ecx, [ebp - 0xb30]
00545082 call     0x405650
00545087 mov      byte ptr [ebp - 4], 0x50
0054508B push     0
0054508D lea      edx, [ebp - 0xb30]
00545093 push     edx
00545094 mov      ecx, dword ptr [ebp - 0x30]
00545097 call     0x7611c0
0054509C mov      byte ptr [ebp - 4], 0
005450A0 lea      ecx, [ebp - 0xb30]
005450A6 call     0x4056d0
005450AB mov      eax, dword ptr [0xb97478]
005450B0 push     eax
005450B1 lea      ecx, [ebp - 0xb4c]
005450B7 call     0x405650
005450BC mov      byte ptr [ebp - 4], 0x51
005450C0 push     0
005450C2 lea      ecx, [ebp - 0xb4c]
005450C8 push     ecx
005450C9 mov      ecx, dword ptr [ebp - 0x30]
005450CC call     0x7611c0
005450D1 mov      byte ptr [ebp - 4], 0
005450D5 lea      ecx, [ebp - 0xb4c]
005450DB call     0x4056d0
005450E0 jmp      0x5452d2
005450E5 mov      edx, dword ptr [0xb97448]
005450EB push     edx
005450EC lea      ecx, [ebp - 0xb68]
005450F2 call     0x405650
005450F7 mov      byte ptr [ebp - 4], 0x52
005450FB push     0
005450FD lea      eax, [ebp - 0xb68]
00545103 push     eax
00545104 mov      ecx, dword ptr [ebp - 0x30]
00545107 call     0x7611c0
0054510C mov      byte ptr [ebp - 4], 0
00545110 lea      ecx, [ebp - 0xb68]
00545116 call     0x4056d0
0054511B mov      ecx, dword ptr [0xb9744c]
00545121 push     ecx
00545122 lea      ecx, [ebp - 0xb84]
00545128 call     0x405650
0054512D mov      byte ptr [ebp - 4], 0x53
00545131 push     1
00545133 lea      edx, [ebp - 0xb84]
00545139 push     edx
0054513A mov      ecx, dword ptr [ebp - 0x30]
0054513D call     0x7611c0
00545142 mov      byte ptr [ebp - 4], 0
00545146 lea      ecx, [ebp - 0xb84]
0054514C call     0x4056d0
00545151 mov      eax, dword ptr [0xb97478]
00545156 push     eax
00545157 lea      ecx, [ebp - 0xba0]
0054515D call     0x405650
00545162 mov      byte ptr [ebp - 4], 0x54
00545166 push     0
00545168 lea      ecx, [ebp - 0xba0]
0054516E push     ecx
0054516F mov      ecx, dword ptr [ebp - 0x30]
00545172 call     0x7611c0
00545177 mov      byte ptr [ebp - 4], 0
0054517B lea      ecx, [ebp - 0xba0]
00545181 call     0x4056d0
00545186 jmp      0x5452d2
0054518B mov      edx, dword ptr [0xb97448]
00545191 push     edx
00545192 lea      ecx, [ebp - 0xbbc]
00545198 call     0x405650
0054519D mov      byte ptr [ebp - 4], 0x55
005451A1 push     0
005451A3 lea      eax, [ebp - 0xbbc]
005451A9 push     eax
005451AA mov      ecx, dword ptr [ebp - 0x30]
005451AD call     0x7611c0
005451B2 mov      byte ptr [ebp - 4], 0
005451B6 lea      ecx, [ebp - 0xbbc]
005451BC call     0x4056d0
005451C1 mov      ecx, dword ptr [0xb9744c]
005451C7 push     ecx
005451C8 lea      ecx, [ebp - 0xbd8]
005451CE call     0x405650
005451D3 mov      byte ptr [ebp - 4], 0x56
005451D7 push     0
005451D9 lea      edx, [ebp - 0xbd8]
005451DF push     edx
005451E0 mov      ecx, dword ptr [ebp - 0x30]
005451E3 call     0x7611c0
005451E8 mov      byte ptr [ebp - 4], 0
005451EC lea      ecx, [ebp - 0xbd8]
005451F2 call     0x4056d0
005451F7 mov      eax, dword ptr [0xb97478]
005451FC push     eax
005451FD lea      ecx, [ebp - 0xbf4]
00545203 call     0x405650
00545208 mov      byte ptr [ebp - 4], 0x57
0054520C push     1
0054520E lea      ecx, [ebp - 0xbf4]
00545214 push     ecx
00545215 mov      ecx, dword ptr [ebp - 0x30]
00545218 call     0x7611c0
0054521D mov      byte ptr [ebp - 4], 0
00545221 lea      ecx, [ebp - 0xbf4]
00545227 call     0x4056d0
0054522C jmp      0x5452d2
00545231 mov      edx, dword ptr [0xb97448]
00545237 push     edx
00545238 lea      ecx, [ebp - 0xc10]
0054523E call     0x405650
00545243 mov      byte ptr [ebp - 4], 0x58
00545247 push     0
00545249 lea      eax, [ebp - 0xc10]
0054524F push     eax
00545250 mov      ecx, dword ptr [ebp - 0x30]
00545253 call     0x7611c0
00545258 mov      byte ptr [ebp - 4], 0
0054525C lea      ecx, [ebp - 0xc10]
00545262 call     0x4056d0
00545267 mov      ecx, dword ptr [0xb9744c]
0054526D push     ecx
0054526E lea      ecx, [ebp - 0xc2c]
00545274 call     0x405650
00545279 mov      byte ptr [ebp - 4], 0x59
0054527D push     0
0054527F lea      edx, [ebp - 0xc2c]
00545285 push     edx
00545286 mov      ecx, dword ptr [ebp - 0x30]
00545289 call     0x7611c0
0054528E mov      byte ptr [ebp - 4], 0
00545292 lea      ecx, [ebp - 0xc2c]
00545298 call     0x4056d0
0054529D mov      eax, dword ptr [0xb97478]
005452A2 push     eax
005452A3 lea      ecx, [ebp - 0xc48]
005452A9 call     0x405650
005452AE mov      byte ptr [ebp - 4], 0x5a
005452B2 push     0
005452B4 lea      ecx, [ebp - 0xc48]
005452BA push     ecx
005452BB mov      ecx, dword ptr [ebp - 0x30]
005452BE call     0x7611c0
005452C3 mov      byte ptr [ebp - 4], 0
005452C7 lea      ecx, [ebp - 0xc48]
005452CD call     0x4056d0
005452D2 mov      dword ptr [ebp - 4], 0xffffffff
005452D9 lea      ecx, [ebp - 0x15c]
005452DF call     0x412d20
005452E4 mov      ecx, dword ptr [ebp - 0xc]
005452E7 mov      dword ptr fs:[0], ecx
005452EE pop      ecx
005452EF pop      esi
005452F0 mov      ecx, dword ptr [ebp - 0x34]
005452F3 xor      ecx, ebp
005452F5 call     0x6634fb
005452FA mov      esp, ebp
005452FC pop      ebp
005452FD ret

; function 0x545650
00545650 push     ebp
00545651 mov      ebp, esp
00545653 push     -1
00545655 push     0xaeafa0
0054565A mov      eax, dword ptr fs:[0]
00545660 push     eax
00545661 sub      esp, 0x3b8
00545667 push     esi
00545668 mov      eax, dword ptr [0xc7b480]
0054566D xor      eax, ebp
0054566F push     eax
00545670 lea      eax, [ebp - 0xc]
00545673 mov      dword ptr fs:[0], eax
00545679 mov      dword ptr [ebp - 0x320], ecx
0054567F mov      ecx, dword ptr [ebp - 0x320]
00545685 call     0x53c030
0054568A mov      ecx, dword ptr [ebp - 0x320]
00545690 call     0x53c300
00545695 lea      eax, [ebp - 0x30]
00545698 push     eax
00545699 call     0x4045e0
0054569E mov      ecx, eax
005456A0 call     0xa48870
005456A5 mov      dword ptr [ebp - 4], 0
005456AC lea      ecx, [ebp - 0x30]
005456AF call     0x4c50a0
005456B4 movzx    ecx, al
005456B7 test     ecx, ecx
005456B9 je       0x5456cf
005456BB mov      dword ptr [ebp - 4], 0xffffffff
005456C2 lea      ecx, [ebp - 0x30]
005456C5 call     0x4c5520
005456CA jmp      0x545f14
005456CF mov      dword ptr [ebp - 0x14], 0
005456D6 mov      dword ptr [ebp - 0x38], 0
005456DD call     0x4e7570
005456E2 mov      dword ptr [ebp - 0x3c], eax
005456E5 push     1
005456E7 mov      ecx, dword ptr [ebp - 0x3c]
005456EA call     0x8335b0
005456EF mov      dword ptr [ebp - 0x34], 0
005456F6 mov      dword ptr [ebp - 0x18], 0
005456FD mov      ecx, dword ptr [ebp - 0x320]
00545703 call     0x462480
00545708 mov      dword ptr [ebp - 0x10], eax
0054570B mov      dword ptr [ebp - 0x40], 0
00545712 jmp      0x54571d
00545714 mov      edx, dword ptr [ebp - 0x40]
00545717 add      edx, 1
0054571A mov      dword ptr [ebp - 0x40], edx
0054571D cmp      dword ptr [ebp - 0x40], 0xc
00545721 je       0x545efa
00545727 lea      eax, [ebp - 0x40]
0054572A push     eax
0054572B lea      ecx, [ebp - 0x60]
0054572E push     ecx
0054572F call     0x4b9190
00545734 add      esp, 8
00545737 mov      dword ptr [ebp - 0x324], eax
0054573D mov      edx, dword ptr [ebp - 0x324]
00545743 mov      dword ptr [ebp - 0x328], edx
00545749 mov      byte ptr [ebp - 4], 1
0054574D mov      eax, dword ptr [ebp - 0x328]
00545753 push     eax
00545754 mov      ecx, dword ptr [0xb973d4]
0054575A push     ecx
0054575B lea      edx, [ebp - 0x7c]
0054575E push     edx
0054575F call     0x411d70
00545764 add      esp, 0xc
00545767 mov      dword ptr [ebp - 0x32c], eax
0054576D mov      eax, dword ptr [ebp - 0x32c]
00545773 mov      dword ptr [ebp - 0x330], eax
00545779 mov      byte ptr [ebp - 4], 2
0054577D mov      ecx, dword ptr [ebp - 0x330]
00545783 push     ecx
00545784 mov      ecx, dword ptr [ebp - 0x3c]
00545787 call     0x75fbf0
0054578C mov      dword ptr [ebp - 0x34], eax
0054578F mov      byte ptr [ebp - 4], 1
00545793 lea      ecx, [ebp - 0x7c]
00545796 call     0x4056d0
0054579B mov      byte ptr [ebp - 4], 0
0054579F lea      ecx, [ebp - 0x60]
005457A2 call     0x4056d0
005457A7 cmp      dword ptr [ebp - 0x34], 0
005457AB je       0x5457e4
005457AD push     0xb96699
005457B2 lea      ecx, [ebp - 0x98]
005457B8 call     0x405650
005457BD mov      byte ptr [ebp - 4], 3
005457C1 lea      edx, [ebp - 0x98]
005457C7 push     edx
005457C8 mov      eax, dword ptr [ebp - 0x34]
005457CB mov      edx, dword ptr [eax]
005457CD mov      ecx, dword ptr [ebp - 0x34]
005457D0 mov      eax, dword ptr [edx + 0x28]
005457D3 call     eax
005457D5 mov      byte ptr [ebp - 4], 0
005457D9 lea      ecx, [ebp - 0x98]
005457DF call     0x4056d0
005457E4 lea      ecx, [ebp - 0x40]
005457E7 push     ecx
005457E8 lea      edx, [ebp - 0xb4]
005457EE push     edx
005457EF call     0x4b9190
005457F4 add      esp, 8
005457F7 mov      dword ptr [ebp - 0x334], eax
005457FD mov      eax, dword ptr [ebp - 0x334]
00545803 mov      dword ptr [ebp - 0x338], eax
00545809 mov      byte ptr [ebp - 4], 4
0054580D mov      ecx, dword ptr [ebp - 0x338]
00545813 push     ecx
00545814 mov      edx, dword ptr [0xb973d8]
0054581A push     edx
0054581B lea      eax, [ebp - 0xd0]
00545821 push     eax
00545822 call     0x411d70
00545827 add      esp, 0xc
0054582A mov      dword ptr [ebp - 0x33c], eax
00545830 mov      ecx, dword ptr [ebp - 0x33c]
00545836 mov      dword ptr [ebp - 0x340], ecx
0054583C mov      byte ptr [ebp - 4], 5
00545840 push     1
00545842 mov      edx, dword ptr [ebp - 0x340]
00545848 push     edx
00545849 mov      ecx, dword ptr [ebp - 0x3c]
0054584C call     0x7611c0
00545851 mov      byte ptr [ebp - 4], 4
00545855 lea      ecx, [ebp - 0xd0]
0054585B call     0x4056d0
00545860 mov      byte ptr [ebp - 4], 0
00545864 lea      ecx, [ebp - 0xb4]
0054586A call     0x4056d0
0054586F lea      eax, [ebp - 0x40]
00545872 push     eax
00545873 lea      ecx, [ebp - 0xec]
00545879 push     ecx
0054587A call     0x4b9190
0054587F add      esp, 8
00545882 mov      dword ptr [ebp - 0x344], eax
00545888 mov      edx, dword ptr [ebp - 0x344]
0054588E mov      dword ptr [ebp - 0x348], edx
00545894 mov      byte ptr [ebp - 4], 6
00545898 mov      eax, dword ptr [ebp - 0x348]
0054589E push     eax
0054589F mov      ecx, dword ptr [0xb973dc]
005458A5 push     ecx
005458A6 lea      edx, [ebp - 0x108]
005458AC push     edx
005458AD call     0x411d70
005458B2 add      esp, 0xc
005458B5 mov      dword ptr [ebp - 0x34c], eax
005458BB mov      eax, dword ptr [ebp - 0x34c]
005458C1 mov      dword ptr [ebp - 0x350], eax
005458C7 mov      byte ptr [ebp - 4], 7
005458CB push     1
005458CD mov      ecx, dword ptr [ebp - 0x350]
005458D3 push     ecx
005458D4 mov      ecx, dword ptr [ebp - 0x3c]
005458D7 call     0x7611c0
005458DC mov      byte ptr [ebp - 4], 6
005458E0 lea      ecx, [ebp - 0x108]
005458E6 call     0x4056d0
005458EB mov      byte ptr [ebp - 4], 0
005458EF lea      ecx, [ebp - 0xec]
005458F5 call     0x4056d0
005458FA lea      edx, [ebp - 0x40]
005458FD push     edx
005458FE lea      eax, [ebp - 0x124]
00545904 push     eax
00545905 call     0x4b9190
0054590A add      esp, 8
0054590D mov      dword ptr [ebp - 0x354], eax
00545913 mov      ecx, dword ptr [ebp - 0x354]
00545919 mov      dword ptr [ebp - 0x358], ecx
0054591F mov      byte ptr [ebp - 4], 8
00545923 mov      edx, dword ptr [ebp - 0x358]
00545929 push     edx
0054592A mov      eax, dword ptr [0xb973d0]
0054592F push     eax
00545930 lea      ecx, [ebp - 0x140]
00545936 push     ecx
00545937 call     0x411d70
0054593C add      esp, 0xc
0054593F mov      dword ptr [ebp - 0x35c], eax
00545945 mov      edx, dword ptr [ebp - 0x35c]
0054594B mov      dword ptr [ebp - 0x360], edx
00545951 mov      byte ptr [ebp - 4], 9
00545955 push     0
00545957 mov      eax, dword ptr [ebp - 0x360]
0054595D push     eax
0054595E mov      ecx, dword ptr [ebp - 0x3c]
00545961 call     0x7603d0
00545966 mov      byte ptr [ebp - 4], 8
0054596A lea      ecx, [ebp - 0x140]
00545970 call     0x4056d0
00545975 mov      byte ptr [ebp - 4], 0
00545979 lea      ecx, [ebp - 0x124]
0054597F call     0x4056d0
00545984 mov      esi, dword ptr [ebp - 0x10]
00545987 imul     esi, esi, 0xc
0054598A add      esi, dword ptr [ebp - 0x40]
0054598D lea      ecx, [ebp - 0x30]
00545990 call     0x55f000
00545995 cmp      esi, eax
00545997 jb       0x54599e
00545999 jmp      0x545714
0054599E lea      ecx, [ebp - 0x40]
005459A1 push     ecx
005459A2 lea      edx, [ebp - 0x15c]
005459A8 push     edx
005459A9 call     0x4b9190
005459AE add      esp, 8
005459B1 mov      dword ptr [ebp - 0x364], eax
005459B7 mov      eax, dword ptr [ebp - 0x364]
005459BD mov      dword ptr [ebp - 0x368], eax
005459C3 mov      byte ptr [ebp - 4], 0xa
005459C7 mov      ecx, dword ptr [ebp - 0x368]
005459CD push     ecx
005459CE mov      edx, dword ptr [0xb973d4]
005459D4 push     edx
005459D5 lea      eax, [ebp - 0x178]
005459DB push     eax
005459DC call     0x411d70
005459E1 add      esp, 0xc
005459E4 mov      dword ptr [ebp - 0x36c], eax
005459EA mov      ecx, dword ptr [ebp - 0x36c]
005459F0 mov      dword ptr [ebp - 0x370], ecx
005459F6 mov      byte ptr [ebp - 4], 0xb
005459FA push     1
005459FC mov      edx, dword ptr [ebp - 0x370]
00545A02 push     edx
00545A03 mov      ecx, dword ptr [ebp - 0x3c]
00545A06 call     0x7611c0
00545A0B mov      byte ptr [ebp - 4], 0xa
00545A0F lea      ecx, [ebp - 0x178]
00545A15 call     0x4056d0
00545A1A mov      byte ptr [ebp - 4], 0
00545A1E lea      ecx, [ebp - 0x15c]
00545A24 call     0x4056d0
00545A29 lea      eax, [ebp - 0x40]
00545A2C push     eax
00545A2D lea      ecx, [ebp - 0x194]
00545A33 push     ecx
00545A34 call     0x4b9190
00545A39 add      esp, 8
00545A3C mov      dword ptr [ebp - 0x374], eax
00545A42 mov      edx, dword ptr [ebp - 0x374]
00545A48 mov      dword ptr [ebp - 0x378], edx
00545A4E mov      byte ptr [ebp - 4], 0xc
00545A52 mov      eax, dword ptr [ebp - 0x378]
00545A58 push     eax
00545A59 mov      ecx, dword ptr [0xb973d8]
00545A5F push     ecx
00545A60 lea      edx, [ebp - 0x1b0]
00545A66 push     edx
00545A67 call     0x411d70
00545A6C add      esp, 0xc
00545A6F mov      dword ptr [ebp - 0x37c], eax
00545A75 mov      eax, dword ptr [ebp - 0x37c]
00545A7B mov      dword ptr [ebp - 0x380], eax
00545A81 mov      byte ptr [ebp - 4], 0xd
00545A85 mov      ecx, dword ptr [ebp - 0x380]
00545A8B push     ecx
00545A8C mov      ecx, dword ptr [ebp - 0x3c]
00545A8F call     0x75fbf0
00545A94 mov      dword ptr [ebp - 0x18], eax
00545A97 mov      byte ptr [ebp - 4], 0xc
00545A9B lea      ecx, [ebp - 0x1b0]
00545AA1 call     0x4056d0
00545AA6 mov      byte ptr [ebp - 4], 0
00545AAA lea      ecx, [ebp - 0x194]
00545AB0 call     0x4056d0
00545AB5 lea      edx, [ebp - 0x40]
00545AB8 push     edx
00545AB9 lea      eax, [ebp - 0x1cc]
00545ABF push     eax
00545AC0 call     0x4b9190
00545AC5 add      esp, 8
00545AC8 mov      dword ptr [ebp - 0x384], eax
00545ACE mov      ecx, dword ptr [ebp - 0x384]
00545AD4 mov      dword ptr [ebp - 0x388], ecx
00545ADA mov      byte ptr [ebp - 4], 0xe
00545ADE mov      edx, dword ptr [ebp - 0x388]
00545AE4 push     edx
00545AE5 mov      eax, dword ptr [0xb973d4]
00545AEA push     eax
00545AEB lea      ecx, [ebp - 0x1e8]
00545AF1 push     ecx
00545AF2 call     0x411d70
00545AF7 add      esp, 0xc
00545AFA mov      dword ptr [ebp - 0x38c], eax
00545B00 mov      edx, dword ptr [ebp - 0x38c]
00545B06 mov      dword ptr [ebp - 0x390], edx
00545B0C mov      byte ptr [ebp - 4], 0xf
00545B10 push     1
00545B12 mov      eax, dword ptr [ebp - 0x390]
00545B18 push     eax
00545B19 mov      ecx, dword ptr [ebp - 0x3c]
00545B1C call     0x7611c0
00545B21 mov      byte ptr [ebp - 4], 0xe
00545B25 lea      ecx, [ebp - 0x1e8]
00545B2B call     0x4056d0
00545B30 mov      byte ptr [ebp - 4], 0
00545B34 lea      ecx, [ebp - 0x1cc]
00545B3A call     0x4056d0
00545B3F lea      ecx, [ebp - 0x40]
00545B42 push     ecx
00545B43 lea      edx, [ebp - 0x204]
00545B49 push     edx
00545B4A call     0x4b9190
00545B4F add      esp, 8
00545B52 mov      dword ptr [ebp - 0x394], eax
00545B58 mov      eax, dword ptr [ebp - 0x394]
00545B5E mov      dword ptr [ebp - 0x398], eax
00545B64 mov      byte ptr [ebp - 4], 0x10
00545B68 mov      ecx, dword ptr [ebp - 0x398]
00545B6E push     ecx
00545B6F mov      edx, dword ptr [0xb973d4]
00545B75 push     edx
00545B76 lea      eax, [ebp - 0x220]
00545B7C push     eax
00545B7D call     0x411d70
00545B82 add      esp, 0xc
00545B85 mov      dword ptr [ebp - 0x39c], eax
00545B8B mov      ecx, dword ptr [ebp - 0x39c]
00545B91 mov      dword ptr [ebp - 0x3a0], ecx
00545B97 mov      byte ptr [ebp - 4], 0x11
00545B9B mov      edx, dword ptr [ebp - 0x3a0]
00545BA1 push     edx
00545BA2 mov      ecx, dword ptr [ebp - 0x3c]
00545BA5 call     0x75fbf0
00545BAA mov      dword ptr [ebp - 0x34], eax
00545BAD mov      byte ptr [ebp - 4], 0x10
00545BB1 lea      ecx, [ebp - 0x220]
00545BB7 call     0x4056d0
00545BBC mov      byte ptr [ebp - 4], 0
00545BC0 lea      ecx, [ebp - 0x204]
00545BC6 call     0x4056d0
00545BCB cmp      dword ptr [ebp - 0x18], 0
00545BCF je       0x545ef5
00545BD5 mov      eax, dword ptr [ebp - 0x10]
00545BD8 imul     eax, eax, 0xc
00545BDB add      eax, dword ptr [ebp - 0x40]
00545BDE push     eax
00545BDF call     0x4045e0
00545BE4 mov      ecx, eax
00545BE6 call     0xa47920
00545BEB mov      dword ptr [ebp - 0x14], eax
00545BEE cmp      dword ptr [ebp - 0x14], 0
00545BF2 jne      0x545bf9
00545BF4 jmp      0x545714
00545BF9 mov      ecx, dword ptr [ebp - 0x14]
00545BFC movzx    edx, word ptr [ecx + 0xc]
00545C00 push     edx
00545C01 call     0x4045e0
00545C06 mov      ecx, eax
00545C08 call     0xa474d0
00545C0D mov      dword ptr [ebp - 0x38], eax
00545C10 cmp      dword ptr [ebp - 0x38], 0
00545C14 jne      0x545c1b
00545C16 jmp      0x545714
00545C1B lea      eax, [ebp - 0x40]
00545C1E push     eax
00545C1F lea      ecx, [ebp - 0x23c]
00545C25 push     ecx
00545C26 call     0x4b9190
00545C2B add      esp, 8
00545C2E mov      dword ptr [ebp - 0x3a4], eax
00545C34 mov      edx, dword ptr [ebp - 0x3a4]
00545C3A mov      dword ptr [ebp - 0x3a8], edx
00545C40 mov      byte ptr [ebp - 4], 0x12
00545C44 mov      eax, dword ptr [ebp - 0x3a8]
00545C4A push     eax
00545C4B mov      ecx, dword ptr [0xb973d0]
00545C51 push     ecx
00545C52 lea      edx, [ebp - 0x258]
00545C58 push     edx
00545C59 call     0x411d70
00545C5E add      esp, 0xc
00545C61 mov      dword ptr [ebp - 0x3ac], eax
00545C67 mov      eax, dword ptr [ebp - 0x3ac]
00545C6D mov      dword ptr [ebp - 0x3b0], eax
00545C73 mov      byte ptr [ebp - 4], 0x13
00545C77 push     1
00545C79 mov      ecx, dword ptr [ebp - 0x3b0]
00545C7F push     ecx
00545C80 mov      ecx, dword ptr [ebp - 0x3c]
00545C83 call     0x7603d0
00545C88 mov      byte ptr [ebp - 4], 0x12
00545C8C lea      ecx, [ebp - 0x258]
00545C92 call     0x4056d0
00545C97 mov      byte ptr [ebp - 4], 0
00545C9B lea      ecx, [ebp - 0x23c]
00545CA1 call     0x4056d0
00545CA6 cmp      dword ptr [ebp - 0x34], 0
00545CAA je       0x545ced
00545CAC mov      ecx, dword ptr [ebp - 0x38]
00545CAF add      ecx, 0xf8
00545CB5 call     0x405750
00545CBA push     eax
00545CBB lea      ecx, [ebp - 0x274]
00545CC1 call     0x405650
00545CC6 mov      byte ptr [ebp - 4], 0x14
00545CCA lea      edx, [ebp - 0x274]
00545CD0 push     edx
00545CD1 mov      eax, dword ptr [ebp - 0x34]
00545CD4 mov      edx, dword ptr [eax]
00545CD6 mov      ecx, dword ptr [ebp - 0x34]
00545CD9 mov      eax, dword ptr [edx + 0x28]
00545CDC call     eax
00545CDE mov      byte ptr [ebp - 4], 0
00545CE2 lea      ecx, [ebp - 0x274]
00545CE8 call     0x4056d0
00545CED mov      ecx, dword ptr [ebp - 0x38]
00545CF0 add      ecx, 0xdc
00545CF6 call     0x405750
00545CFB push     eax
00545CFC lea      ecx, [ebp - 0x290]
00545D02 call     0x405650
00545D07 mov      byte ptr [ebp - 4], 0x15
00545D0B push     1
00545D0D lea      ecx, [ebp - 0x290]
00545D13 push     ecx
00545D14 mov      edx, dword ptr [ebp - 0x18]
00545D17 mov      eax, dword ptr [edx]
00545D19 mov      ecx, dword ptr [ebp - 0x18]
00545D1C mov      edx, dword ptr [eax + 0xd4]
00545D22 call     edx
00545D24 mov      byte ptr [ebp - 4], 0
00545D28 lea      ecx, [ebp - 0x290]
00545D2E call     0x4056d0
00545D33 lea      eax, [ebp - 0x40]
00545D36 push     eax
00545D37 lea      ecx, [ebp - 0x2ac]
00545D3D push     ecx
00545D3E call     0x4b9190
00545D43 add      esp, 8
00545D46 mov      dword ptr [ebp - 0x3b4], eax
00545D4C mov      edx, dword ptr [ebp - 0x3b4]
00545D52 mov      dword ptr [ebp - 0x3b8], edx
00545D58 mov      byte ptr [ebp - 4], 0x16
00545D5C mov      eax, dword ptr [ebp - 0x3b8]
00545D62 push     eax
00545D63 mov      ecx, dword ptr [0xb973dc]
00545D69 push     ecx
00545D6A lea      edx, [ebp - 0x2c8]
00545D70 push     edx
00545D71 call     0x411d70
00545D76 add      esp, 0xc
00545D79 mov      dword ptr [ebp - 0x3bc], eax
00545D7F mov      eax, dword ptr [ebp - 0x3bc]
00545D85 mov      dword ptr [ebp - 0x3c0], eax
00545D8B mov      byte ptr [ebp - 4], 0x17
00545D8F mov      ecx, dword ptr [ebp - 0x3c0]
00545D95 push     ecx
00545D96 mov      ecx, dword ptr [ebp - 0x3c]
00545D99 call     0x75fbf0
00545D9E mov      dword ptr [ebp - 0x44], eax
00545DA1 mov      byte ptr [ebp - 4], 0x16
00545DA5 lea      ecx, [ebp - 0x2c8]
00545DAB call     0x4056d0
00545DB0 mov      byte ptr [ebp - 4], 0
00545DB4 lea      ecx, [ebp - 0x2ac]
00545DBA call     0x4056d0
00545DBF mov      edx, dword ptr [ebp - 0x14]
00545DC2 movzx    eax, byte ptr [edx + 0x10]
00545DC6 mov      dword ptr [ebp - 0x3c4], eax
00545DCC mov      ecx, dword ptr [ebp - 0x3c4]
00545DD2 sub      ecx, 1
00545DD5 mov      dword ptr [ebp - 0x3c4], ecx
00545DDB cmp      dword ptr [ebp - 0x3c4], 3
00545DE2 ja       0x545ef5
00545DE8 mov      edx, dword ptr [ebp - 0x3c4]
00545DEE jmp      dword ptr [edx*4 + 0x545f24]
00545DF5 push     -1
00545DF7 mov      ecx, dword ptr [ebp - 0x18]
00545DFA call     0x4b2350
00545DFF cmp      dword ptr [ebp - 0x44], 0
00545E03 je       0x545e3d
00545E05 mov      eax, dword ptr [0xb973c0]
00545E0A push     eax
00545E0B lea      ecx, [ebp - 0x2e4]
00545E11 call     0x405650
00545E16 mov      byte ptr [ebp - 4], 0x18
00545E1A lea      ecx, [ebp - 0x2e4]
00545E20 push     ecx
00545E21 mov      edx, dword ptr [ebp - 0x44]
00545E24 mov      eax, dword ptr [edx]
00545E26 mov      ecx, dword ptr [ebp - 0x44]
00545E29 mov      edx, dword ptr [eax + 0x28]
00545E2C call     edx
00545E2E mov      byte ptr [ebp - 4], 0
00545E32 lea      ecx, [ebp - 0x2e4]
00545E38 call     0x4056d0
00545E3D jmp      0x545ef5
00545E42 push     0xff00ffff
00545E47 mov      ecx, dword ptr [ebp - 0x18]
00545E4A call     0x4b2350
00545E4F cmp      dword ptr [ebp - 0x44], 0
00545E53 je       0x545e8d
00545E55 mov      eax, dword ptr [0xb973c4]
00545E5A push     eax
00545E5B lea      ecx, [ebp - 0x300]
00545E61 call     0x405650
00545E66 mov      byte ptr [ebp - 4], 0x19
00545E6A lea      ecx, [ebp - 0x300]
00545E70 push     ecx
00545E71 mov      edx, dword ptr [ebp - 0x44]
00545E74 mov      eax, dword ptr [edx]
00545E76 mov      ecx, dword ptr [ebp - 0x44]
00545E79 mov      edx, dword ptr [eax + 0x28]
00545E7C call     edx
00545E7E mov      byte ptr [ebp - 4], 0
00545E82 lea      ecx, [ebp - 0x300]
00545E88 call     0x4056d0
00545E8D jmp      0x545ef5
00545E8F push     0xffc78dfd
00545E94 mov      ecx, dword ptr [ebp - 0x18]
00545E97 call     0x4b2350
00545E9C cmp      dword ptr [ebp - 0x44], 0
00545EA0 je       0x545eda
00545EA2 mov      eax, dword ptr [0xb973c8]
00545EA7 push     eax
00545EA8 lea      ecx, [ebp - 0x31c]
00545EAE call     0x405650
00545EB3 mov      byte ptr [ebp - 4], 0x1a
00545EB7 lea      ecx, [ebp - 0x31c]
00545EBD push     ecx
00545EBE mov      edx, dword ptr [ebp - 0x44]
00545EC1 mov      eax, dword ptr [edx]
00545EC3 mov      ecx, dword ptr [ebp - 0x44]
00545EC6 mov      edx, dword ptr [eax + 0x28]
00545EC9 call     edx
00545ECB mov      byte ptr [ebp - 4], 0
00545ECF lea      ecx, [ebp - 0x31c]
00545ED5 call     0x4056d0
00545EDA jmp      0x545ef5
00545EDC push     0xffff0000
00545EE1 mov      ecx, dword ptr [ebp - 0x18]
00545EE4 call     0x4b2350
00545EE9 call     0x41c230
00545EEE mov      ecx, eax
00545EF0 call     0x91ea30
00545EF5 jmp      0x545714
00545EFA mov      ecx, dword ptr [ebp - 0x320]
00545F00 call     0x545f40
00545F05 mov      dword ptr [ebp - 4], 0xffffffff
00545F0C lea      ecx, [ebp - 0x30]
00545F0F call     0x4c5520
00545F14 mov      ecx, dword ptr [ebp - 0xc]
00545F17 mov      dword ptr fs:[0], ecx
00545F1E pop      ecx
00545F1F pop      esi
00545F20 mov      esp, ebp
00545F22 pop      ebp
00545F23 ret

; function 0x545f40
00545F40 push     ebp
00545F41 mov      ebp, esp
00545F43 push     -1
00545F45 push     0xaeae4e
00545F4A mov      eax, dword ptr fs:[0]
00545F50 push     eax
00545F51 sub      esp, 0xd84
00545F57 mov      eax, dword ptr [0xc7b480]
00545F5C xor      eax, ebp
00545F5E mov      dword ptr [ebp - 0x38], eax
00545F61 push     esi
00545F62 push     eax
00545F63 lea      eax, [ebp - 0xc]
00545F66 mov      dword ptr fs:[0], eax
00545F6C mov      dword ptr [ebp - 0xc54], ecx
00545F72 mov      ecx, dword ptr [ebp - 0xc54]
00545F78 call     0x53c300
00545F7D mov      eax, dword ptr [ebp - 0xc54]
00545F83 mov      edx, dword ptr [eax]
00545F85 mov      ecx, dword ptr [ebp - 0xc54]
00545F8B mov      eax, dword ptr [edx + 0x1c]
00545F8E call     eax
00545F90 test     eax, eax
00545F92 jl       0x545fc0
00545F94 mov      ecx, dword ptr [ebp - 0xc54]
00545F9A mov      edx, dword ptr [ecx]
00545F9C mov      ecx, dword ptr [ebp - 0xc54]
00545FA2 mov      eax, dword ptr [edx + 0x1c]
00545FA5 call     eax
00545FA7 mov      esi, eax
00545FA9 mov      ecx, dword ptr [ebp - 0xc54]
00545FAF mov      edx, dword ptr [ecx]
00545FB1 mov      ecx, dword ptr [ebp - 0xc54]
00545FB7 mov      eax, dword ptr [edx + 4]
00545FBA call     eax
00545FBC cmp      esi, eax
00545FBE jl       0x545fc5
00545FC0 jmp      0x548102
00545FC5 mov      ecx, dword ptr [ebp - 0xc54]
00545FCB mov      edx, dword ptr [ecx]
00545FCD mov      ecx, dword ptr [ebp - 0xc54]
00545FD3 mov      eax, dword ptr [edx + 0x1c]
00545FD6 call     eax
00545FD8 push     eax
00545FD9 call     0x4045e0
00545FDE mov      ecx, eax
00545FE0 call     0xa47920
00545FE5 mov      dword ptr [ebp - 0x140], eax
00545FEB cmp      dword ptr [ebp - 0x140], 0
00545FF2 jne      0x545ff9
00545FF4 jmp      0x548102
00545FF9 mov      ecx, dword ptr [ebp - 0x140]
00545FFF movzx    edx, word ptr [ecx + 0xc]
00546003 push     edx
00546004 call     0x4045e0
00546009 mov      ecx, eax
0054600B call     0xa474d0
00546010 mov      dword ptr [ebp - 0x148], eax
00546016 cmp      dword ptr [ebp - 0x148], 0
0054601D jne      0x546024
0054601F jmp      0x548102
00546024 mov      eax, dword ptr [ebp - 0x140]
0054602A movzx    ecx, word ptr [eax + 0xc]
0054602E push     ecx
0054602F lea      edx, [ebp - 0x164]
00546035 push     edx
00546036 call     0x4045e0
0054603B mov      ecx, eax
0054603D call     0xa47d70
00546042 mov      dword ptr [ebp - 4], 0
00546049 call     0x4e7570
0054604E mov      dword ptr [ebp - 0x34], eax
00546051 mov      eax, dword ptr [0xb9747c]
00546056 push     eax
00546057 lea      ecx, [ebp - 0x2b8]
0054605D call     0x405650
00546062 mov      byte ptr [ebp - 4], 1
00546066 push     1
00546068 lea      ecx, [ebp - 0x2b8]
0054606E push     ecx
0054606F mov      ecx, dword ptr [ebp - 0x34]
00546072 call     0x7611c0
00546077 mov      byte ptr [ebp - 4], 0
0054607B lea      ecx, [ebp - 0x2b8]
00546081 call     0x4056d0
00546086 mov      edx, dword ptr [0xb97470]
0054608C push     edx
0054608D lea      ecx, [ebp - 0x2d4]
00546093 call     0x405650
00546098 mov      byte ptr [ebp - 4], 2
0054609C push     0
0054609E lea      eax, [ebp - 0x2d4]
005460A4 push     eax
005460A5 mov      ecx, dword ptr [ebp - 0x34]
005460A8 call     0x7611c0
005460AD mov      byte ptr [ebp - 4], 0
005460B1 lea      ecx, [ebp - 0x2d4]
005460B7 call     0x4056d0
005460BC mov      dword ptr [ebp - 0x144], 0
005460C6 mov      dword ptr [ebp - 0x30], 0
005460CD mov      dword ptr [ebp - 0x1c], 0
005460D4 mov      dword ptr [ebp - 0x168], 0
005460DE mov      dword ptr [ebp - 0x14c], 0
005460E8 mov      ecx, dword ptr [0xb973f0]
005460EE push     ecx
005460EF lea      ecx, [ebp - 0x2f0]
005460F5 call     0x405650
005460FA mov      byte ptr [ebp - 4], 3
005460FE lea      edx, [ebp - 0x2f0]
00546104 push     edx
00546105 mov      ecx, dword ptr [ebp - 0x34]
00546108 call     0x75fbf0
0054610D mov      dword ptr [ebp - 0x144], eax
00546113 mov      byte ptr [ebp - 4], 0
00546117 lea      ecx, [ebp - 0x2f0]
0054611D call     0x4056d0
00546122 cmp      dword ptr [ebp - 0x144], 0
00546129 je       0x54617a
0054612B mov      ecx, dword ptr [ebp - 0x148]
00546131 add      ecx, 0xdc
00546137 call     0x405750
0054613C push     eax
0054613D lea      ecx, [ebp - 0x30c]
00546143 call     0x405650
00546148 mov      byte ptr [ebp - 4], 4
0054614C push     1
0054614E lea      eax, [ebp - 0x30c]
00546154 push     eax
00546155 mov      ecx, dword ptr [ebp - 0x144]
0054615B mov      edx, dword ptr [ecx]
0054615D mov      ecx, dword ptr [ebp - 0x144]
00546163 mov      eax, dword ptr [edx + 0xd4]
00546169 call     eax
0054616B mov      byte ptr [ebp - 4], 0
0054616F lea      ecx, [ebp - 0x30c]
00546175 call     0x4056d0
0054617A mov      ecx, dword ptr [0xb973f4]
00546180 push     ecx
00546181 lea      ecx, [ebp - 0x328]
00546187 call     0x405650
0054618C mov      byte ptr [ebp - 4], 5
00546190 lea      edx, [ebp - 0x328]
00546196 push     edx
00546197 mov      ecx, dword ptr [ebp - 0x34]
0054619A call     0x75fbf0
0054619F mov      dword ptr [ebp - 0x18], eax
005461A2 mov      byte ptr [ebp - 4], 0
005461A6 lea      ecx, [ebp - 0x328]
005461AC call     0x4056d0
005461B1 cmp      dword ptr [ebp - 0x18], 0
005461B5 je       0x54620b
005461B7 mov      eax, dword ptr [ebp - 0x140]
005461BD movzx    ecx, byte ptr [eax + 0x10]
005461C1 cmp      ecx, 3
005461C4 je       0x5461d5
005461C6 mov      edx, dword ptr [ebp - 0x140]
005461CC movzx    eax, byte ptr [edx + 0x10]
005461D0 cmp      eax, 4
005461D3 jne      0x5461f1
005461D5 mov      ecx, dword ptr [ebp - 0x148]
005461DB add      ecx, 0x130
005461E1 call     0x405750
005461E6 push     eax
005461E7 mov      ecx, dword ptr [ebp - 0x18]
005461EA call     0x74c640
005461EF jmp      0x54620b
005461F1 mov      ecx, dword ptr [ebp - 0x148]
005461F7 add      ecx, 0x114
005461FD call     0x405750
00546202 push     eax
00546203 mov      ecx, dword ptr [ebp - 0x18]
00546206 call     0x74c640
0054620B mov      ecx, dword ptr [0xb97410]
00546211 push     ecx
00546212 lea      ecx, [ebp - 0x344]
00546218 call     0x405650
0054621D mov      byte ptr [ebp - 4], 6
00546221 lea      edx, [ebp - 0x344]
00546227 push     edx
00546228 mov      ecx, dword ptr [ebp - 0x34]
0054622B call     0x75fbf0
00546230 mov      dword ptr [ebp - 0x144], eax
00546236 mov      byte ptr [ebp - 4], 0
0054623A lea      ecx, [ebp - 0x344]
00546240 call     0x4056d0
00546245 cmp      dword ptr [ebp - 0x144], 0
0054624C je       0x546290
0054624E push     0xbc9998
00546253 lea      ecx, [ebp - 0x360]
00546259 call     0x405650
0054625E mov      byte ptr [ebp - 4], 7
00546262 push     1
00546264 lea      eax, [ebp - 0x360]
0054626A push     eax
0054626B mov      ecx, dword ptr [ebp - 0x144]
00546271 mov      edx, dword ptr [ecx]
00546273 mov      ecx, dword ptr [ebp - 0x144]
00546279 mov      eax, dword ptr [edx + 0xd4]
0054627F call     eax
00546281 mov      byte ptr [ebp - 4], 0
00546285 lea      ecx, [ebp - 0x360]
0054628B call     0x4056d0
00546290 mov      dword ptr [ebp - 0x14], 7
00546297 mov      dword ptr [ebp - 0x28], 0xffffffff
0054629E mov      dword ptr [ebp - 0x24], 0xffffffff
005462A5 mov      dword ptr [ebp - 0x20], 0xffffffff
005462AC xor      ecx, ecx
005462AE mov      word ptr [ebp - 0x10], cx
005462B2 mov      dword ptr [ebp - 0x16c], 0
005462BC jmp      0x5462cd
005462BE mov      edx, dword ptr [ebp - 0x16c]
005462C4 add      edx, 1
005462C7 mov      dword ptr [ebp - 0x16c], edx
005462CD cmp      dword ptr [ebp - 0x16c], 7
005462D4 jge      0x546415
005462DA mov      eax, dword ptr [ebp - 0x16c]
005462E0 imul     eax, eax, 0xc
005462E3 mov      ecx, dword ptr [ebp - 0x140]
005462E9 cmp      dword ptr [ecx + eax + 0x35], 0
005462EE jbe      0x5462fc
005462F0 mov      dx, word ptr [ebp - 0x10]
005462F4 add      dx, 1
005462F8 mov      word ptr [ebp - 0x10], dx
005462FC mov      eax, dword ptr [ebp - 0x16c]
00546302 imul     eax, eax, 0xc
00546305 mov      ecx, dword ptr [ebp - 0x140]
0054630B cmp      dword ptr [ecx + eax + 0x35], 0
00546310 jb       0x546358
00546312 mov      edx, dword ptr [ebp - 0x16c]
00546318 imul     edx, edx, 0xc
0054631B mov      eax, dword ptr [ebp - 0x140]
00546321 mov      ecx, dword ptr [ebp - 0x148]
00546327 mov      edx, dword ptr [eax + edx + 0x35]
0054632B cmp      edx, dword ptr [ecx + 0xc8]
00546331 jne      0x546358
00546333 mov      eax, dword ptr [ebp - 0x148]
00546339 movzx    ecx, word ptr [eax + 0xd4]
00546340 test     ecx, ecx
00546342 jle      0x546358
00546344 cmp      dword ptr [ebp - 0x28], 0
00546348 jge      0x546358
0054634A mov      edx, dword ptr [ebp - 0x16c]
00546350 mov      dword ptr [ebp - 0x28], edx
00546353 jmp      0x5462be
00546358 mov      eax, dword ptr [ebp - 0x16c]
0054635E imul     eax, eax, 0xc
00546361 mov      ecx, dword ptr [ebp - 0x140]
00546367 cmp      dword ptr [ecx + eax + 0x35], 0
0054636C jb       0x5463b4
0054636E mov      edx, dword ptr [ebp - 0x16c]
00546374 imul     edx, edx, 0xc
00546377 mov      eax, dword ptr [ebp - 0x140]
0054637D mov      ecx, dword ptr [ebp - 0x148]
00546383 mov      edx, dword ptr [eax + edx + 0x35]
00546387 cmp      edx, dword ptr [ecx + 0xcc]
0054638D jne      0x5463b4
0054638F mov      eax, dword ptr [ebp - 0x148]
00546395 movzx    ecx, word ptr [eax + 0xd6]
0054639C test     ecx, ecx
0054639E jle      0x5463b4
005463A0 cmp      dword ptr [ebp - 0x24], 0
005463A4 jge      0x5463b4
005463A6 mov      edx, dword ptr [ebp - 0x16c]
005463AC mov      dword ptr [ebp - 0x24], edx
005463AF jmp      0x5462be
005463B4 mov      eax, dword ptr [ebp - 0x16c]
005463BA imul     eax, eax, 0xc
005463BD mov      ecx, dword ptr [ebp - 0x140]
005463C3 cmp      dword ptr [ecx + eax + 0x35], 0
005463C8 jb       0x546410
005463CA mov      edx, dword ptr [ebp - 0x16c]
005463D0 imul     edx, edx, 0xc
005463D3 mov      eax, dword ptr [ebp - 0x140]
005463D9 mov      ecx, dword ptr [ebp - 0x148]
005463DF mov      edx, dword ptr [eax + edx + 0x35]
005463E3 cmp      edx, dword ptr [ecx + 0xd0]
005463E9 jne      0x546410
005463EB mov      eax, dword ptr [ebp - 0x148]
005463F1 movzx    ecx, word ptr [eax + 0xd8]
005463F8 test     ecx, ecx
005463FA jle      0x546410
005463FC cmp      dword ptr [ebp - 0x20], 0
00546400 jge      0x546410
00546402 mov      edx, dword ptr [ebp - 0x16c]
00546408 mov      dword ptr [ebp - 0x20], edx
0054640B jmp      0x5462be
00546410 jmp      0x5462be
00546415 mov      dword ptr [ebp - 0x170], 0
0054641F jmp      0x546430
00546421 mov      eax, dword ptr [ebp - 0x170]
00546427 add      eax, 1
0054642A mov      dword ptr [ebp - 0x170], eax
00546430 cmp      dword ptr [ebp - 0x170], 3
00546437 jge      0x54675b
0054643D lea      ecx, [ebp - 0x170]
00546443 push     ecx
00546444 lea      edx, [ebp - 0x37c]
0054644A push     edx
0054644B call     0xa44160
00546450 add      esp, 8
00546453 mov      dword ptr [ebp - 0xc58], eax
00546459 mov      eax, dword ptr [ebp - 0xc58]
0054645F mov      dword ptr [ebp - 0xc5c], eax
00546465 mov      byte ptr [ebp - 4], 8
00546469 mov      ecx, dword ptr [ebp - 0xc5c]
0054646F push     ecx
00546470 mov      edx, dword ptr [0xb97410]
00546476 push     edx
00546477 lea      eax, [ebp - 0x398]
0054647D push     eax
0054647E call     0x411d70
00546483 add      esp, 0xc
00546486 mov      dword ptr [ebp - 0xc60], eax
0054648C mov      ecx, dword ptr [ebp - 0xc60]
00546492 mov      dword ptr [ebp - 0xc64], ecx
00546498 mov      byte ptr [ebp - 4], 9
0054649C mov      edx, dword ptr [ebp - 0xc64]
005464A2 push     edx
005464A3 mov      ecx, dword ptr [ebp - 0x34]
005464A6 call     0x75fbf0
005464AB mov      dword ptr [ebp - 0x144], eax
005464B1 mov      byte ptr [ebp - 4], 8
005464B5 lea      ecx, [ebp - 0x398]
005464BB call     0x4056d0
005464C0 mov      byte ptr [ebp - 4], 0
005464C4 lea      ecx, [ebp - 0x37c]
005464CA call     0x4056d0
005464CF cmp      dword ptr [ebp - 0x144], 0
005464D6 je       0x54651a
005464D8 push     0xb96699
005464DD lea      ecx, [ebp - 0x3b4]
005464E3 call     0x405650
005464E8 mov      byte ptr [ebp - 4], 0xa
005464EC push     1
005464EE lea      eax, [ebp - 0x3b4]
005464F4 push     eax
005464F5 mov      ecx, dword ptr [ebp - 0x144]
005464FB mov      edx, dword ptr [ecx]
005464FD mov      ecx, dword ptr [ebp - 0x144]
00546503 mov      eax, dword ptr [edx + 0xd4]
00546509 call     eax
0054650B mov      byte ptr [ebp - 4], 0
0054650F lea      ecx, [ebp - 0x3b4]
00546515 call     0x4056d0
0054651A mov      ecx, dword ptr [ebp - 0x170]
00546520 cmp      dword ptr [ebp + ecx*4 - 0x28], 0
00546525 jl       0x546756
0054652B mov      edx, dword ptr [ebp - 0x170]
00546531 cmp      dword ptr [ebp + edx*4 - 0x28], 7
00546536 jge      0x546756
0054653C mov      eax, dword ptr [ebp - 0x140]
00546542 movzx    ecx, word ptr [eax + 0xe]
00546546 cmp      ecx, 2
00546549 jne      0x546616
0054654F mov      edx, dword ptr [ebp - 0x170]
00546555 mov      eax, dword ptr [ebp + edx*4 - 0x28]
00546559 imul     eax, eax, 0xc
0054655C mov      ecx, dword ptr [ebp - 0x170]
00546562 mov      edx, dword ptr [ebp - 0x148]
00546568 movzx    ecx, word ptr [edx + ecx*2 + 0xd4]
00546570 mov      edx, dword ptr [ebp - 0x140]
00546576 cmp      dword ptr [edx + eax + 0x39], ecx
0054657A jb       0x5465c9
0054657C mov      eax, dword ptr [ebp - 0x170]
00546582 mov      ecx, dword ptr [ebp - 0x148]
00546588 movzx    edx, word ptr [ecx + eax*2 + 0xd4]
00546590 push     edx
00546591 push     1
00546593 mov      eax, dword ptr [ebp - 0x170]
00546599 push     eax
0054659A mov      ecx, dword ptr [ebp - 0x148]
005465A0 add      ecx, 0xb0
005465A6 call     0x4eae70
005465AB mov      ecx, eax
005465AD call     0x405750
005465B2 push     eax
005465B3 push     0xbc99a4
005465B8 lea      ecx, [ebp - 0x13c]
005465BE push     ecx
005465BF call     0x411e00
005465C4 add      esp, 0x14
005465C7 jmp      0x546614
005465C9 mov      edx, dword ptr [ebp - 0x170]
005465CF mov      eax, dword ptr [ebp - 0x148]
005465D5 movzx    ecx, word ptr [eax + edx*2 + 0xd4]
005465DD push     ecx
005465DE push     0
005465E0 mov      edx, dword ptr [ebp - 0x170]
005465E6 push     edx
005465E7 mov      ecx, dword ptr [ebp - 0x148]
005465ED add      ecx, 0xb0
005465F3 call     0x4eae70
005465F8 mov      ecx, eax
005465FA call     0x405750
005465FF push     eax
00546600 push     0xbc99a4
00546605 lea      eax, [ebp - 0x13c]
0054660B push     eax
0054660C call     0x411e00
00546611 add      esp, 0x14
00546614 jmp      0x546677
00546616 mov      ecx, dword ptr [ebp - 0x170]
0054661C mov      edx, dword ptr [ebp - 0x148]
00546622 movzx    eax, word ptr [edx + ecx*2 + 0xd4]
0054662A push     eax
0054662B mov      ecx, dword ptr [ebp - 0x170]
00546631 mov      edx, dword ptr [ebp + ecx*4 - 0x28]
00546635 imul     edx, edx, 0xc
00546638 mov      eax, dword ptr [ebp - 0x140]
0054663E mov      ecx, dword ptr [eax + edx + 0x39]
00546642 push     ecx
00546643 mov      edx, dword ptr [ebp - 0x170]
00546649 push     edx
0054664A mov      ecx, dword ptr [ebp - 0x148]
00546650 add      ecx, 0xb0
00546656 call     0x4eae70
0054665B mov      ecx, eax
0054665D call     0x405750
00546662 push     eax
00546663 push     0xbc99a4
00546668 lea      eax, [ebp - 0x13c]
0054666E push     eax
0054666F call     0x411e00
00546674 add      esp, 0x14
00546677 lea      ecx, [ebp - 0x170]
0054667D push     ecx
0054667E lea      edx, [ebp - 0x3d0]
00546684 push     edx
00546685 call     0xa44160
0054668A add      esp, 8
0054668D mov      dword ptr [ebp - 0xc68], eax
00546693 mov      eax, dword ptr [ebp - 0xc68]
00546699 mov      dword ptr [ebp - 0xc6c], eax
0054669F mov      byte ptr [ebp - 4], 0xb
005466A3 mov      ecx, dword ptr [ebp - 0xc6c]
005466A9 push     ecx
005466AA mov      edx, dword ptr [0xb97410]
005466B0 push     edx
005466B1 lea      eax, [ebp - 0x3ec]
005466B7 push     eax
005466B8 call     0x411d70
005466BD add      esp, 0xc
005466C0 mov      dword ptr [ebp - 0xc70], eax
005466C6 mov      ecx, dword ptr [ebp - 0xc70]
005466CC mov      dword ptr [ebp - 0xc74], ecx
005466D2 mov      byte ptr [ebp - 4], 0xc
005466D6 mov      edx, dword ptr [ebp - 0xc74]
005466DC push     edx
005466DD mov      ecx, dword ptr [ebp - 0x34]
005466E0 call     0x75fbf0
005466E5 mov      dword ptr [ebp - 0x144], eax
005466EB mov      byte ptr [ebp - 4], 0xb
005466EF lea      ecx, [ebp - 0x3ec]
005466F5 call     0x4056d0
005466FA mov      byte ptr [ebp - 4], 0
005466FE lea      ecx, [ebp - 0x3d0]
00546704 call     0x4056d0
00546709 cmp      dword ptr [ebp - 0x144], 0
00546710 je       0x546756
00546712 lea      eax, [ebp - 0x13c]
00546718 push     eax
00546719 lea      ecx, [ebp - 0x408]
0054671F call     0x405650
00546724 mov      byte ptr [ebp - 4], 0xd
00546728 push     1
0054672A lea      ecx, [ebp - 0x408]
00546730 push     ecx
00546731 mov      edx, dword ptr [ebp - 0x144]
00546737 mov      eax, dword ptr [edx]
00546739 mov      ecx, dword ptr [ebp - 0x144]
0054673F mov      edx, dword ptr [eax + 0xd4]
00546745 call     edx
00546747 mov      byte ptr [ebp - 4], 0
0054674B lea      ecx, [ebp - 0x408]
00546751 call     0x4056d0
00546756 jmp      0x546421
0054675B movsx    eax, word ptr [ebp - 0x10]
0054675F cmp      eax, 3
00546762 jle      0x5468e0
00546768 mov      ecx, dword ptr [ebp - 0x140]
0054676E movzx    edx, byte ptr [ecx + 0x10]
00546772 cmp      edx, 4
00546775 jne      0x5467b8
00546777 mov      eax, dword ptr [ebp - 0x148]
0054677D movzx    ecx, word ptr [eax + 0xd4]
00546784 push     ecx
00546785 push     1
00546787 push     0
00546789 mov      ecx, dword ptr [ebp - 0x148]
0054678F add      ecx, 0xb0
00546795 call     0x4eae70
0054679A mov      ecx, eax
0054679C call     0x405750
005467A1 push     eax
005467A2 push     0xbc99a4
005467A7 lea      edx, [ebp - 0x13c]
005467AD push     edx
005467AE call     0x411e00
005467B3 add      esp, 0x14
005467B6 jmp      0x5467f7
005467B8 mov      eax, dword ptr [ebp - 0x148]
005467BE movzx    ecx, word ptr [eax + 0xd4]
005467C5 push     ecx
005467C6 push     0
005467C8 push     0
005467CA mov      ecx, dword ptr [ebp - 0x148]
005467D0 add      ecx, 0xb0
005467D6 call     0x4eae70
005467DB mov      ecx, eax
005467DD call     0x405750
005467E2 push     eax
005467E3 push     0xbc99a4
005467E8 lea      edx, [ebp - 0x13c]
005467EE push     edx
005467EF call     0x411e00
005467F4 add      esp, 0x14
005467F7 mov      dword ptr [ebp - 0x40c], 0
00546801 lea      eax, [ebp - 0x40c]
00546807 push     eax
00546808 lea      ecx, [ebp - 0x428]
0054680E push     ecx
0054680F call     0xa44160
00546814 add      esp, 8
00546817 mov      dword ptr [ebp - 0xc78], eax
0054681D mov      edx, dword ptr [ebp - 0xc78]
00546823 mov      dword ptr [ebp - 0xc7c], edx
00546829 mov      byte ptr [ebp - 4], 0xe
0054682D mov      eax, dword ptr [ebp - 0xc7c]
00546833 push     eax
00546834 mov      ecx, dword ptr [0xb97410]
0054683A push     ecx
0054683B lea      edx, [ebp - 0x444]
00546841 push     edx
00546842 call     0x411d70
00546847 add      esp, 0xc
0054684A mov      dword ptr [ebp - 0xc80], eax
00546850 mov      eax, dword ptr [ebp - 0xc80]
00546856 mov      dword ptr [ebp - 0xc84], eax
0054685C mov      byte ptr [ebp - 4], 0xf
00546860 mov      ecx, dword ptr [ebp - 0xc84]
00546866 push     ecx
00546867 mov      ecx, dword ptr [ebp - 0x34]
0054686A call     0x75fbf0
0054686F mov      dword ptr [ebp - 0x144], eax
00546875 mov      byte ptr [ebp - 4], 0xe
00546879 lea      ecx, [ebp - 0x444]
0054687F call     0x4056d0
00546884 mov      byte ptr [ebp - 4], 0
00546888 lea      ecx, [ebp - 0x428]
0054688E call     0x4056d0
00546893 cmp      dword ptr [ebp - 0x144], 0
0054689A je       0x5468e0
0054689C lea      edx, [ebp - 0x13c]
005468A2 push     edx
005468A3 lea      ecx, [ebp - 0x460]
005468A9 call     0x405650
005468AE mov      byte ptr [ebp - 4], 0x10
005468B2 push     1
005468B4 lea      eax, [ebp - 0x460]
005468BA push     eax
005468BB mov      ecx, dword ptr [ebp - 0x144]
005468C1 mov      edx, dword ptr [ecx]
005468C3 mov      ecx, dword ptr [ebp - 0x144]
005468C9 mov      eax, dword ptr [edx + 0xd4]
005468CF call     eax
005468D1 mov      byte ptr [ebp - 4], 0
005468D5 lea      ecx, [ebp - 0x460]
005468DB call     0x4056d0
005468E0 mov      ecx, dword ptr [ebp - 0x148]
005468E6 cmp      dword ptr [ecx + 0x11], 0
005468EA jne      0x546ad8
005468F0 mov      edx, dword ptr [0xb9741c]
005468F6 push     edx
005468F7 lea      ecx, [ebp - 0x47c]
005468FD call     0x405650
00546902 mov      byte ptr [ebp - 4], 0x11
00546906 lea      eax, [ebp - 0x47c]
0054690C push     eax
0054690D mov      ecx, dword ptr [ebp - 0x34]
00546910 call     0x75fbf0
00546915 mov      dword ptr [ebp - 0x144], eax
0054691B mov      byte ptr [ebp - 4], 0
0054691F lea      ecx, [ebp - 0x47c]
00546925 call     0x4056d0
0054692A cmp      dword ptr [ebp - 0x144], 0
00546931 je       0x5469e4
00546937 mov      ecx, dword ptr [ebp - 0x148]
0054693D cmp      dword ptr [ecx + 0x15], 0
00546941 je       0x5469e4
00546947 mov      edx, dword ptr [ebp - 0x148]
0054694D add      edx, 0x15
00546950 push     edx
00546951 lea      eax, [ebp - 0x498]
00546957 push     eax
00546958 call     0x411c90
0054695D add      esp, 8
00546960 mov      dword ptr [ebp - 0xc88], eax
00546966 mov      ecx, dword ptr [ebp - 0xc88]
0054696C mov      dword ptr [ebp - 0xc8c], ecx
00546972 mov      byte ptr [ebp - 4], 0x12
00546976 mov      edx, dword ptr [ebp - 0xc8c]
0054697C push     edx
0054697D push     0xbc99b0
00546982 lea      eax, [ebp - 0x4b4]
00546988 push     eax
00546989 call     0x411d70
0054698E add      esp, 0xc
00546991 mov      dword ptr [ebp - 0xc90], eax
00546997 mov      ecx, dword ptr [ebp - 0xc90]
0054699D mov      dword ptr [ebp - 0xc94], ecx
005469A3 mov      byte ptr [ebp - 4], 0x13
005469A7 push     1
005469A9 mov      edx, dword ptr [ebp - 0xc94]
005469AF push     edx
005469B0 mov      eax, dword ptr [ebp - 0x144]
005469B6 mov      edx, dword ptr [eax]
005469B8 mov      ecx, dword ptr [ebp - 0x144]
005469BE mov      eax, dword ptr [edx + 0xd4]
005469C4 call     eax
005469C6 mov      byte ptr [ebp - 4], 0x12
005469CA lea      ecx, [ebp - 0x4b4]
005469D0 call     0x4056d0
005469D5 mov      byte ptr [ebp - 4], 0
005469D9 lea      ecx, [ebp - 0x498]
005469DF call     0x4056d0
005469E4 mov      ecx, dword ptr [0xb97420]
005469EA push     ecx
005469EB lea      ecx, [ebp - 0x4d0]
005469F1 call     0x405650
005469F6 mov      byte ptr [ebp - 4], 0x14
005469FA lea      edx, [ebp - 0x4d0]
00546A00 push     edx
00546A01 mov      ecx, dword ptr [ebp - 0x34]
00546A04 call     0x75fbf0
00546A09 mov      dword ptr [ebp - 0x144], eax
00546A0F mov      byte ptr [ebp - 4], 0
00546A13 lea      ecx, [ebp - 0x4d0]
00546A19 call     0x4056d0
00546A1E cmp      dword ptr [ebp - 0x144], 0
00546A25 je       0x546ad8
00546A2B mov      eax, dword ptr [ebp - 0x148]
00546A31 cmp      dword ptr [eax + 0x19], 0
00546A35 je       0x546ad8
00546A3B mov      ecx, dword ptr [ebp - 0x148]
00546A41 add      ecx, 0x19
00546A44 push     ecx
00546A45 lea      edx, [ebp - 0x4ec]
00546A4B push     edx
00546A4C call     0x411c90
00546A51 add      esp, 8
00546A54 mov      dword ptr [ebp - 0xc98], eax
00546A5A mov      eax, dword ptr [ebp - 0xc98]
00546A60 mov      dword ptr [ebp - 0xc9c], eax
00546A66 mov      byte ptr [ebp - 4], 0x15
00546A6A mov      ecx, dword ptr [ebp - 0xc9c]
00546A70 push     ecx
00546A71 push     0xbc99bc
00546A76 lea      edx, [ebp - 0x508]
00546A7C push     edx
00546A7D call     0x411d70
00546A82 add      esp, 0xc
00546A85 mov      dword ptr [ebp - 0xca0], eax
00546A8B mov      eax, dword ptr [ebp - 0xca0]
00546A91 mov      dword ptr [ebp - 0xca4], eax
00546A97 mov      byte ptr [ebp - 4], 0x16
00546A9B push     1
00546A9D mov      ecx, dword ptr [ebp - 0xca4]
00546AA3 push     ecx
00546AA4 mov      edx, dword ptr [ebp - 0x144]
00546AAA mov      eax, dword ptr [edx]
00546AAC mov      ecx, dword ptr [ebp - 0x144]
00546AB2 mov      edx, dword ptr [eax + 0xd4]
00546AB8 call     edx
00546ABA mov      byte ptr [ebp - 4], 0x15
00546ABE lea      ecx, [ebp - 0x508]
00546AC4 call     0x4056d0
00546AC9 mov      byte ptr [ebp - 4], 0
00546ACD lea      ecx, [ebp - 0x4ec]
00546AD3 call     0x4056d0
00546AD8 mov      eax, dword ptr [ebp - 0x148]
00546ADE cmp      dword ptr [eax + 0x15], 0
00546AE2 jne      0x546ccf
00546AE8 mov      ecx, dword ptr [0xb9741c]
00546AEE push     ecx
00546AEF lea      ecx, [ebp - 0x524]
00546AF5 call     0x405650
00546AFA mov      byte ptr [ebp - 4], 0x17
00546AFE lea      edx, [ebp - 0x524]
00546B04 push     edx
00546B05 mov      ecx, dword ptr [ebp - 0x34]
00546B08 call     0x75fbf0
00546B0D mov      dword ptr [ebp - 0x144], eax
00546B13 mov      byte ptr [ebp - 4], 0
00546B17 lea      ecx, [ebp - 0x524]
00546B1D call     0x4056d0
00546B22 cmp      dword ptr [ebp - 0x144], 0
00546B29 je       0x546bdc
00546B2F mov      eax, dword ptr [ebp - 0x148]
00546B35 cmp      dword ptr [eax + 0x11], 0
00546B39 je       0x546bdc
00546B3F mov      ecx, dword ptr [ebp - 0x148]
00546B45 add      ecx, 0x11
00546B48 push     ecx
00546B49 lea      edx, [ebp - 0x540]
00546B4F push     edx
00546B50 call     0x411c90
00546B55 add      esp, 8
00546B58 mov      dword ptr [ebp - 0xca8], eax
00546B5E mov      eax, dword ptr [ebp - 0xca8]
00546B64 mov      dword ptr [ebp - 0xcac], eax
00546B6A mov      byte ptr [ebp - 4], 0x18
00546B6E mov      ecx, dword ptr [ebp - 0xcac]
00546B74 push     ecx
00546B75 push     0xbc99c8
00546B7A lea      edx, [ebp - 0x55c]
00546B80 push     edx
00546B81 call     0x411d70
00546B86 add      esp, 0xc
00546B89 mov      dword ptr [ebp - 0xcb0], eax
00546B8F mov      eax, dword ptr [ebp - 0xcb0]
00546B95 mov      dword ptr [ebp - 0xcb4], eax
00546B9B mov      byte ptr [ebp - 4], 0x19
00546B9F push     1
00546BA1 mov      ecx, dword ptr [ebp - 0xcb4]
00546BA7 push     ecx
00546BA8 mov      edx, dword ptr [ebp - 0x144]
00546BAE mov      eax, dword ptr [edx]
00546BB0 mov      ecx, dword ptr [ebp - 0x144]
00546BB6 mov      edx, dword ptr [eax + 0xd4]
00546BBC call     edx
00546BBE mov      byte ptr [ebp - 4], 0x18
00546BC2 lea      ecx, [ebp - 0x55c]
00546BC8 call     0x4056d0
00546BCD mov      byte ptr [ebp - 4], 0
00546BD1 lea      ecx, [ebp - 0x540]
00546BD7 call     0x4056d0
00546BDC mov      eax, dword ptr [0xb97420]
00546BE1 push     eax
00546BE2 lea      ecx, [ebp - 0x578]
00546BE8 call     0x405650
00546BED mov      byte ptr [ebp - 4], 0x1a
00546BF1 lea      ecx, [ebp - 0x578]
00546BF7 push     ecx
00546BF8 mov      ecx, dword ptr [ebp - 0x34]
00546BFB call     0x75fbf0
00546C00 mov      dword ptr [ebp - 0x144], eax
00546C06 mov      byte ptr [ebp - 4], 0
00546C0A lea      ecx, [ebp - 0x578]
00546C10 call     0x4056d0
00546C15 cmp      dword ptr [ebp - 0x144], 0
00546C1C je       0x546ccf
00546C22 mov      edx, dword ptr [ebp - 0x148]
00546C28 cmp      dword ptr [edx + 0x19], 0
00546C2C je       0x546ccf
00546C32 mov      eax, dword ptr [ebp - 0x148]
00546C38 add      eax, 0x19
00546C3B push     eax
00546C3C lea      ecx, [ebp - 0x594]
00546C42 push     ecx
00546C43 call     0x411c90
00546C48 add      esp, 8
00546C4B mov      dword ptr [ebp - 0xcb8], eax
00546C51 mov      edx, dword ptr [ebp - 0xcb8]
00546C57 mov      dword ptr [ebp - 0xcbc], edx
00546C5D mov      byte ptr [ebp - 4], 0x1b
00546C61 mov      eax, dword ptr [ebp - 0xcbc]
00546C67 push     eax
00546C68 push     0xbc99bc
00546C6D lea      ecx, [ebp - 0x5b0]
00546C73 push     ecx
00546C74 call     0x411d70
00546C79 add      esp, 0xc
00546C7C mov      dword ptr [ebp - 0xcc0], eax
00546C82 mov      edx, dword ptr [ebp - 0xcc0]
00546C88 mov      dword ptr [ebp - 0xcc4], edx
00546C8E mov      byte ptr [ebp - 4], 0x1c
00546C92 push     1
00546C94 mov      eax, dword ptr [ebp - 0xcc4]
00546C9A push     eax
00546C9B mov      ecx, dword ptr [ebp - 0x144]
00546CA1 mov      edx, dword ptr [ecx]
00546CA3 mov      ecx, dword ptr [ebp - 0x144]
00546CA9 mov      eax, dword ptr [edx + 0xd4]
00546CAF call     eax
00546CB1 mov      byte ptr [ebp - 4], 0x1b
00546CB5 lea      ecx, [ebp - 0x5b0]
00546CBB call     0x4056d0
00546CC0 mov      byte ptr [ebp - 4], 0
00546CC4 lea      ecx, [ebp - 0x594]
00546CCA call     0x4056d0
00546CCF mov      ecx, dword ptr [ebp - 0x148]
00546CD5 cmp      dword ptr [ecx + 0x19], 0
00546CD9 jne      0x546ec7
00546CDF mov      edx, dword ptr [0xb9741c]
00546CE5 push     edx
00546CE6 lea      ecx, [ebp - 0x5cc]
00546CEC call     0x405650
00546CF1 mov      byte ptr [ebp - 4], 0x1d
00546CF5 lea      eax, [ebp - 0x5cc]
00546CFB push     eax
00546CFC mov      ecx, dword ptr [ebp - 0x34]
00546CFF call     0x75fbf0
00546D04 mov      dword ptr [ebp - 0x144], eax
00546D0A mov      byte ptr [ebp - 4], 0
00546D0E lea      ecx, [ebp - 0x5cc]
00546D14 call     0x4056d0
00546D19 cmp      dword ptr [ebp - 0x144], 0
00546D20 je       0x546dd3
00546D26 mov      ecx, dword ptr [ebp - 0x148]
00546D2C cmp      dword ptr [ecx + 0x15], 0
00546D30 je       0x546dd3
00546D36 mov      edx, dword ptr [ebp - 0x148]
00546D3C add      edx, 0x15
00546D3F push     edx
00546D40 lea      eax, [ebp - 0x5e8]
00546D46 push     eax
00546D47 call     0x411c90
00546D4C add      esp, 8
00546D4F mov      dword ptr [ebp - 0xcc8], eax
00546D55 mov      ecx, dword ptr [ebp - 0xcc8]
00546D5B mov      dword ptr [ebp - 0xccc], ecx
00546D61 mov      byte ptr [ebp - 4], 0x1e
00546D65 mov      edx, dword ptr [ebp - 0xccc]
00546D6B push     edx
00546D6C push     0xbc99b0
00546D71 lea      eax, [ebp - 0x604]
00546D77 push     eax
00546D78 call     0x411d70
00546D7D add      esp, 0xc
00546D80 mov      dword ptr [ebp - 0xcd0], eax
00546D86 mov      ecx, dword ptr [ebp - 0xcd0]
00546D8C mov      dword ptr [ebp - 0xcd4], ecx
00546D92 mov      byte ptr [ebp - 4], 0x1f
00546D96 push     1
00546D98 mov      edx, dword ptr [ebp - 0xcd4]
00546D9E push     edx
00546D9F mov      eax, dword ptr [ebp - 0x144]
00546DA5 mov      edx, dword ptr [eax]
00546DA7 mov      ecx, dword ptr [ebp - 0x144]
00546DAD mov      eax, dword ptr [edx + 0xd4]
00546DB3 call     eax
00546DB5 mov      byte ptr [ebp - 4], 0x1e
00546DB9 lea      ecx, [ebp - 0x604]
00546DBF call     0x4056d0
00546DC4 mov      byte ptr [ebp - 4], 0
00546DC8 lea      ecx, [ebp - 0x5e8]
00546DCE call     0x4056d0
00546DD3 mov      ecx, dword ptr [0xb97420]
00546DD9 push     ecx
00546DDA lea      ecx, [ebp - 0x620]
00546DE0 call     0x405650
00546DE5 mov      byte ptr [ebp - 4], 0x20
00546DE9 lea      edx, [ebp - 0x620]
00546DEF push     edx
00546DF0 mov      ecx, dword ptr [ebp - 0x34]
00546DF3 call     0x75fbf0
00546DF8 mov      dword ptr [ebp - 0x144], eax
00546DFE mov      byte ptr [ebp - 4], 0
00546E02 lea      ecx, [ebp - 0x620]
00546E08 call     0x4056d0
00546E0D cmp      dword ptr [ebp - 0x144], 0
00546E14 je       0x546ec7
00546E1A mov      eax, dword ptr [ebp - 0x148]
00546E20 cmp      dword ptr [eax + 0x11], 0
00546E24 je       0x546ec7
00546E2A mov      ecx, dword ptr [ebp - 0x148]
00546E30 add      ecx, 0x11
00546E33 push     ecx
00546E34 lea      edx, [ebp - 0x63c]
00546E3A push     edx
00546E3B call     0x411c90
00546E40 add      esp, 8
00546E43 mov      dword ptr [ebp - 0xcd8], eax
00546E49 mov      eax, dword ptr [ebp - 0xcd8]
00546E4F mov      dword ptr [ebp - 0xcdc], eax
00546E55 mov      byte ptr [ebp - 4], 0x21
00546E59 mov      ecx, dword ptr [ebp - 0xcdc]
00546E5F push     ecx
00546E60 push     0xbc99c8
00546E65 lea      edx, [ebp - 0x658]
00546E6B push     edx
00546E6C call     0x411d70
00546E71 add      esp, 0xc
00546E74 mov      dword ptr [ebp - 0xce0], eax
00546E7A mov      eax, dword ptr [ebp - 0xce0]
00546E80 mov      dword ptr [ebp - 0xce4], eax
00546E86 mov      byte ptr [ebp - 4], 0x22
00546E8A push     1
00546E8C mov      ecx, dword ptr [ebp - 0xce4]
00546E92 push     ecx
00546E93 mov      edx, dword ptr [ebp - 0x144]
00546E99 mov      eax, dword ptr [edx]
00546E9B mov      ecx, dword ptr [ebp - 0x144]
00546EA1 mov      edx, dword ptr [eax + 0xd4]
00546EA7 call     edx
00546EA9 mov      byte ptr [ebp - 4], 0x21
00546EAD lea      ecx, [ebp - 0x658]
00546EB3 call     0x4056d0
00546EB8 mov      byte ptr [ebp - 4], 0
00546EBC lea      ecx, [ebp - 0x63c]
00546EC2 call     0x4056d0
00546EC7 mov      eax, dword ptr [0xb9748c]
00546ECC push     eax
00546ECD lea      ecx, [ebp - 0x674]
00546ED3 call     0x405650
00546ED8 mov      byte ptr [ebp - 4], 0x23
00546EDC lea      ecx, [ebp - 0x674]
00546EE2 push     ecx
00546EE3 mov      ecx, dword ptr [ebp - 0x34]
00546EE6 call     0x75fbf0
00546EEB mov      dword ptr [ebp - 0x144], eax
00546EF1 mov      byte ptr [ebp - 4], 0
00546EF5 lea      ecx, [ebp - 0x674]
00546EFB call     0x4056d0
00546F00 cmp      dword ptr [ebp - 0x144], 0
00546F07 je       0x546f85
00546F09 mov      edx, dword ptr [ebp - 0x148]
00546F0F cmp      dword ptr [edx + 0x11], 0
00546F13 jne      0x546f2d
00546F15 mov      eax, dword ptr [ebp - 0x148]
00546F1B cmp      dword ptr [eax + 0x15], 0
00546F1F jne      0x546f2d
00546F21 mov      ecx, dword ptr [ebp - 0x148]
00546F27 cmp      dword ptr [ecx + 0x19], 0
00546F2B je       0x546f85
00546F2D mov      edx, dword ptr [ebp - 0x144]
00546F33 mov      eax, dword ptr [edx]
00546F35 mov      ecx, dword ptr [ebp - 0x144]
00546F3B mov      edx, dword ptr [eax + 0xc0]
00546F41 call     edx
00546F43 push     0xbc99d4
00546F48 lea      ecx, [ebp - 0x690]
00546F4E call     0x405650
00546F53 mov      byte ptr [ebp - 4], 0x24
00546F57 push     1
00546F59 lea      eax, [ebp - 0x690]
00546F5F push     eax
00546F60 mov      ecx, dword ptr [ebp - 0x144]
00546F66 mov      edx, dword ptr [ecx]
00546F68 mov      ecx, dword ptr [ebp - 0x144]
00546F6E mov      eax, dword ptr [edx + 0xd4]
00546F74 call     eax
00546F76 mov      byte ptr [ebp - 4], 0
00546F7A lea      ecx, [ebp - 0x690]
00546F80 call     0x4056d0
00546F85 xor      ecx, ecx
00546F87 mov      word ptr [ebp - 0x2c], cx
00546F8B mov      edx, dword ptr [0xb97494]
00546F91 push     edx
00546F92 lea      ecx, [ebp - 0x6ac]
00546F98 call     0x405650
00546F9D mov      byte ptr [ebp - 4], 0x25
00546FA1 lea      eax, [ebp - 0x6ac]
00546FA7 push     eax
00546FA8 mov      ecx, dword ptr [ebp - 0x34]
00546FAB call     0x75fbf0
00546FB0 mov      dword ptr [ebp - 0x144], eax
00546FB6 mov      byte ptr [ebp - 4], 0
00546FBA lea      ecx, [ebp - 0x6ac]
00546FC0 call     0x4056d0
00546FC5 cmp      dword ptr [ebp - 0x144], 0
00546FCC je       0x547026
00546FCE mov      ecx, dword ptr [ebp - 0x144]
00546FD4 mov      edx, dword ptr [ecx]
00546FD6 mov      ecx, dword ptr [ebp - 0x144]
00546FDC mov      eax, dword ptr [edx + 0xc4]
00546FE2 call     eax
00546FE4 push     0xb96699
00546FE9 lea      ecx, [ebp - 0x6c8]
00546FEF call     0x405650
00546FF4 mov      byte ptr [ebp - 4], 0x26
00546FF8 push     1
00546FFA lea      ecx, [ebp - 0x6c8]
00547000 push     ecx
00547001 mov      edx, dword ptr [ebp - 0x144]
00547007 mov      eax, dword ptr [edx]
00547009 mov      ecx, dword ptr [ebp - 0x144]
0054700F mov      edx, dword ptr [eax + 0xd4]
00547015 call     edx
00547017 mov      byte ptr [ebp - 4], 0
0054701B lea      ecx, [ebp - 0x6c8]
00547021 call     0x4056d0
00547026 mov      eax, dword ptr [ebp - 0x148]
0054702C cmp      dword ptr [eax + 0x14c], 0
00547033 je       0x5476e6
00547039 mov      ecx, dword ptr [0xb97494]
0054703F push     ecx
00547040 lea      ecx, [ebp - 0x6e4]
00547046 call     0x405650
0054704B mov      byte ptr [ebp - 4], 0x27
0054704F lea      edx, [ebp - 0x6e4]
00547055 push     edx
00547056 mov      ecx, dword ptr [ebp - 0x34]
00547059 call     0x75fbf0
0054705E mov      dword ptr [ebp - 0x144], eax
00547064 mov      byte ptr [ebp - 4], 0
00547068 lea      ecx, [ebp - 0x6e4]
0054706E call     0x4056d0
00547073 cmp      dword ptr [ebp - 0x144], 0
0054707A je       0x5470d4
0054707C mov      eax, dword ptr [ebp - 0x144]
00547082 mov      edx, dword ptr [eax]
00547084 mov      ecx, dword ptr [ebp - 0x144]
0054708A mov      eax, dword ptr [edx + 0xc0]
00547090 call     eax
00547092 push     0xbc99e0
00547097 lea      ecx, [ebp - 0x700]
0054709D call     0x405650
005470A2 mov      byte ptr [ebp - 4], 0x28
005470A6 push     1
005470A8 lea      ecx, [ebp - 0x700]
005470AE push     ecx
005470AF mov      edx, dword ptr [ebp - 0x144]
005470B5 mov      eax, dword ptr [edx]
005470B7 mov      ecx, dword ptr [ebp - 0x144]
005470BD mov      edx, dword ptr [eax + 0xd4]
005470C3 call     edx
005470C5 mov      byte ptr [ebp - 4], 0
005470C9 lea      ecx, [ebp - 0x700]
005470CF call     0x4056d0
005470D4 mov      dword ptr [ebp - 0x17c], 0
005470DE jmp      0x5470ef
005470E0 mov      eax, dword ptr [ebp - 0x17c]
005470E6 add      eax, 1
005470E9 mov      dword ptr [ebp - 0x17c], eax
005470EF cmp      dword ptr [ebp - 0x17c], 4
005470F6 jge      0x54736a
005470FC lea      ecx, [ebp - 0x17c]
00547102 push     ecx
00547103 lea      edx, [ebp - 0x71c]
00547109 push     edx
0054710A call     0xa44160
0054710F add      esp, 8
00547112 mov      dword ptr [ebp - 0xce8], eax
00547118 mov      eax, dword ptr [ebp - 0xce8]
0054711E mov      dword ptr [ebp - 0xcec], eax
00547124 mov      byte ptr [ebp - 4], 0x29
00547128 mov      ecx, dword ptr [ebp - 0xcec]
0054712E push     ecx
0054712F mov      edx, dword ptr [0xb97424]
00547135 push     edx
00547136 lea      eax, [ebp - 0x738]
0054713C push     eax
0054713D call     0x411d70
00547142 add      esp, 0xc
00547145 mov      dword ptr [ebp - 0xcf0], eax
0054714B mov      ecx, dword ptr [ebp - 0xcf0]
00547151 mov      dword ptr [ebp - 0xcf4], ecx
00547157 mov      byte ptr [ebp - 4], 0x2a
0054715B mov      edx, dword ptr [ebp - 0xcf4]
00547161 push     edx
00547162 mov      ecx, dword ptr [ebp - 0x34]
00547165 call     0x75fbf0
0054716A mov      dword ptr [ebp - 0x14c], eax
00547170 mov      byte ptr [ebp - 4], 0x29
00547174 lea      ecx, [ebp - 0x738]
0054717A call     0x4056d0
0054717F mov      byte ptr [ebp - 4], 0
00547183 lea      ecx, [ebp - 0x71c]
00547189 call     0x4056d0
0054718E lea      eax, [ebp - 0x17c]
00547194 push     eax
00547195 lea      ecx, [ebp - 0x754]
0054719B push     ecx
0054719C call     0xa44160
005471A1 add      esp, 8
005471A4 mov      dword ptr [ebp - 0xcf8], eax
005471AA mov      edx, dword ptr [ebp - 0xcf8]
005471B0 mov      dword ptr [ebp - 0xcfc], edx
005471B6 mov      byte ptr [ebp - 4], 0x2b
005471BA mov      eax, dword ptr [ebp - 0xcfc]
005471C0 push     eax
005471C1 mov      ecx, dword ptr [0xb97430]
005471C7 push     ecx
005471C8 lea      edx, [ebp - 0x770]
005471CE push     edx
005471CF call     0x411d70
005471D4 add      esp, 0xc
005471D7 mov      dword ptr [ebp - 0xd00], eax
005471DD mov      eax, dword ptr [ebp - 0xd00]
005471E3 mov      dword ptr [ebp - 0xd04], eax
005471E9 mov      byte ptr [ebp - 4], 0x2c
005471ED mov      ecx, dword ptr [ebp - 0xd04]
005471F3 push     ecx
005471F4 mov      ecx, dword ptr [ebp - 0x34]
005471F7 call     0x75fbf0
005471FC mov      dword ptr [ebp - 0x144], eax
00547202 mov      byte ptr [ebp - 4], 0x2b
00547206 lea      ecx, [ebp - 0x770]
0054720C call     0x4056d0
00547211 mov      byte ptr [ebp - 4], 0
00547215 lea      ecx, [ebp - 0x754]
0054721B call     0x4056d0
00547220 lea      edx, [ebp - 0x17c]
00547226 push     edx
00547227 lea      eax, [ebp - 0x78c]
0054722D push     eax
0054722E call     0xa44160
00547233 add      esp, 8
00547236 mov      dword ptr [ebp - 0xd08], eax
0054723C mov      ecx, dword ptr [ebp - 0xd08]
00547242 mov      dword ptr [ebp - 0xd0c], ecx
00547248 mov      byte ptr [ebp - 4], 0x2d
0054724C mov      edx, dword ptr [ebp - 0xd0c]
00547252 push     edx
00547253 mov      eax, dword ptr [0xb97490]
00547258 push     eax
00547259 lea      ecx, [ebp - 0x7a8]
0054725F push     ecx
00547260 call     0x411d70
00547265 add      esp, 0xc
00547268 mov      dword ptr [ebp - 0xd10], eax
0054726E mov      edx, dword ptr [ebp - 0xd10]
00547274 mov      dword ptr [ebp - 0xd14], edx
0054727A mov      byte ptr [ebp - 4], 0x2e
0054727E mov      eax, dword ptr [ebp - 0xd14]
00547284 push     eax
00547285 mov      ecx, dword ptr [ebp - 0x34]
00547288 call     0x75fbf0
0054728D mov      dword ptr [ebp - 0x180], eax
00547293 mov      byte ptr [ebp - 4], 0x2d
00547297 lea      ecx, [ebp - 0x7a8]
0054729D call     0x4056d0
005472A2 mov      byte ptr [ebp - 4], 0
005472A6 lea      ecx, [ebp - 0x78c]
005472AC call     0x4056d0
005472B1 cmp      dword ptr [ebp - 0x180], 0
005472B8 je       0x5472d0
005472BA mov      ecx, dword ptr [ebp - 0x180]
005472C0 mov      edx, dword ptr [ecx]
005472C2 mov      ecx, dword ptr [ebp - 0x180]
005472C8 mov      eax, dword ptr [edx + 0xc4]
005472CE call     eax
005472D0 cmp      dword ptr [ebp - 0x14c], 0
005472D7 je       0x547365
005472DD cmp      dword ptr [ebp - 0x144], 0
005472E4 je       0x547365
005472E6 push     0xb96699
005472EB lea      ecx, [ebp - 0x7c4]
005472F1 call     0x405650
005472F6 mov      byte ptr [ebp - 4], 0x2f
005472FA push     1
005472FC lea      ecx, [ebp - 0x7c4]
00547302 push     ecx
00547303 mov      edx, dword ptr [ebp - 0x144]
00547309 mov      eax, dword ptr [edx]
0054730B mov      ecx, dword ptr [ebp - 0x144]
00547311 mov      edx, dword ptr [eax + 0xd4]
00547317 call     edx
00547319 mov      byte ptr [ebp - 4], 0
0054731D lea      ecx, [ebp - 0x7c4]
00547323 call     0x4056d0
00547328 push     0xb96699
0054732D lea      ecx, [ebp - 0x7e0]
00547333 call     0x405650
00547338 mov      byte ptr [ebp - 4], 0x30
0054733C lea      eax, [ebp - 0x7e0]
00547342 push     eax
00547343 mov      ecx, dword ptr [ebp - 0x14c]
00547349 mov      edx, dword ptr [ecx]
0054734B mov      ecx, dword ptr [ebp - 0x14c]
00547351 mov      eax, dword ptr [edx + 0x28]
00547354 call     eax
00547356 mov      byte ptr [ebp - 4], 0
0054735A lea      ecx, [ebp - 0x7e0]
00547360 call     0x4056d0
00547365 jmp      0x5470e0
0054736A mov      ecx, dword ptr [0x17c86fc]
00547370 call     0x9cd990
00547375 mov      dword ptr [ebp - 0x178], eax
0054737B mov      ecx, dword ptr [ebp - 0x178]
00547381 sub      ecx, 1
00547384 mov      dword ptr [ebp - 0x174], ecx
0054738A cmp      dword ptr [ebp - 0x178], 0
00547391 jle      0x5476e1
00547397 cmp      dword ptr [ebp - 0x178], 0x19
0054739E je       0x5476e1
005473A4 mov      dword ptr [ebp - 0x7e4], 0
005473AE lea      edx, [ebp - 0x7e4]
005473B4 push     edx
005473B5 lea      eax, [ebp - 0x800]
005473BB push     eax
005473BC call     0xa44160
005473C1 add      esp, 8
005473C4 mov      dword ptr [ebp - 0xd18], eax
005473CA mov      ecx, dword ptr [ebp - 0xd18]
005473D0 mov      dword ptr [ebp - 0xd1c], ecx
005473D6 mov      byte ptr [ebp - 4], 0x31
005473DA mov      edx, dword ptr [ebp - 0xd1c]
005473E0 push     edx
005473E1 mov      eax, dword ptr [0xb97424]
005473E6 push     eax
005473E7 lea      ecx, [ebp - 0x81c]
005473ED push     ecx
005473EE call     0x411d70
005473F3 add      esp, 0xc
005473F6 mov      dword ptr [ebp - 0xd20], eax
005473FC mov      edx, dword ptr [ebp - 0xd20]
00547402 mov      dword ptr [ebp - 0xd24], edx
00547408 mov      byte ptr [ebp - 4], 0x32
0054740C mov      eax, dword ptr [ebp - 0xd24]
00547412 push     eax
00547413 mov      ecx, dword ptr [ebp - 0x34]
00547416 call     0x75fbf0
0054741B mov      dword ptr [ebp - 0x14c], eax
00547421 mov      byte ptr [ebp - 4], 0x31
00547425 lea      ecx, [ebp - 0x81c]
0054742B call     0x4056d0
00547430 mov      byte ptr [ebp - 4], 0
00547434 lea      ecx, [ebp - 0x800]
0054743A call     0x4056d0
0054743F mov      dword ptr [ebp - 0x820], 0
00547449 lea      ecx, [ebp - 0x820]
0054744F push     ecx
00547450 lea      edx, [ebp - 0x83c]
00547456 push     edx
00547457 call     0xa44160
0054745C add      esp, 8
0054745F mov      dword ptr [ebp - 0xd28], eax
00547465 mov      eax, dword ptr [ebp - 0xd28]
0054746B mov      dword ptr [ebp - 0xd2c], eax
00547471 mov      byte ptr [ebp - 4], 0x33
00547475 mov      ecx, dword ptr [ebp - 0xd2c]
0054747B push     ecx
0054747C mov      edx, dword ptr [0xb97430]
00547482 push     edx
00547483 lea      eax, [ebp - 0x858]
00547489 push     eax
0054748A call     0x411d70
0054748F add      esp, 0xc
00547492 mov      dword ptr [ebp - 0xd30], eax
00547498 mov      ecx, dword ptr [ebp - 0xd30]
0054749E mov      dword ptr [ebp - 0xd34], ecx
005474A4 mov      byte ptr [ebp - 4], 0x34
005474A8 mov      edx, dword ptr [ebp - 0xd34]
005474AE push     edx
005474AF mov      ecx, dword ptr [ebp - 0x34]
005474B2 call     0x75fbf0
005474B7 mov      dword ptr [ebp - 0x144], eax
005474BD mov      byte ptr [ebp - 4], 0x33
005474C1 lea      ecx, [ebp - 0x858]
005474C7 call     0x4056d0
005474CC mov      byte ptr [ebp - 4], 0
005474D0 lea      ecx, [ebp - 0x83c]
005474D6 call     0x4056d0
005474DB mov      dword ptr [ebp - 0x85c], 0
005474E5 lea      eax, [ebp - 0x85c]
005474EB push     eax
005474EC lea      ecx, [ebp - 0x878]
005474F2 push     ecx
005474F3 call     0xa44160
005474F8 add      esp, 8
005474FB mov      dword ptr [ebp - 0xd38], eax
00547501 mov      edx, dword ptr [ebp - 0xd38]
00547507 mov      dword ptr [ebp - 0xd3c], edx
0054750D mov      byte ptr [ebp - 4], 0x35
00547511 mov      eax, dword ptr [ebp - 0xd3c]
00547517 push     eax
00547518 mov      ecx, dword ptr [0xb97490]
0054751E push     ecx
0054751F lea      edx, [ebp - 0x894]
00547525 push     edx
00547526 call     0x411d70
0054752B add      esp, 0xc
0054752E mov      dword ptr [ebp - 0xd40], eax
00547534 mov      eax, dword ptr [ebp - 0xd40]
0054753A mov      dword ptr [ebp - 0xd44], eax
00547540 mov      byte ptr [ebp - 4], 0x36
00547544 mov      ecx, dword ptr [ebp - 0xd44]
0054754A push     ecx
0054754B mov      ecx, dword ptr [ebp - 0x34]
0054754E call     0x75fbf0
00547553 mov      dword ptr [ebp - 0x1fc], eax
00547559 mov      byte ptr [ebp - 4], 0x35
0054755D lea      ecx, [ebp - 0x894]
00547563 call     0x4056d0
00547568 mov      byte ptr [ebp - 4], 0
0054756C lea      ecx, [ebp - 0x878]
00547572 call     0x4056d0
00547577 push     0x6c
00547579 push     0
0054757B lea      edx, [ebp - 0x1f4]
00547581 push     edx
00547582 call     0x666960
00547587 add      esp, 0xc
0054758A mov      dword ptr [ebp - 0x1f8], 0
00547594 lea      eax, [ebp - 0x1f4]
0054759A push     eax
0054759B mov      ecx, dword ptr [ebp - 0x174]
005475A1 mov      edx, dword ptr [ebp - 0x148]
005475A7 mov      eax, dword ptr [edx + ecx*4 + 0x90]
005475AE push     eax
005475AF call     0x41bc70
005475B4 mov      ecx, eax
005475B6 call     0x85ba40
005475BB test     eax, eax
005475BD je       0x5475d8
005475BF mov      ecx, dword ptr [ebp - 0x1ef]
005475C5 push     ecx
005475C6 call     0xa21b30
005475CB mov      ecx, eax
005475CD call     0xa1e560
005475D2 mov      dword ptr [ebp - 0x1f8], eax
005475D8 cmp      dword ptr [ebp - 0x1fc], 0
005475DF je       0x5476e1
005475E5 cmp      dword ptr [ebp - 0x144], 0
005475EC je       0x5476e1
005475F2 cmp      dword ptr [ebp - 0x14c], 0
005475F9 je       0x5476e1
005475FF cmp      dword ptr [ebp - 0x1f8], 0
00547606 je       0x5476e1
0054760C mov      edx, dword ptr [ebp - 0x1fc]
00547612 mov      eax, dword ptr [edx]
00547614 mov      ecx, dword ptr [ebp - 0x1fc]
0054761A mov      edx, dword ptr [eax + 0xc0]
00547620 call     edx
00547622 mov      eax, dword ptr [ebp - 0x144]
00547628 mov      edx, dword ptr [eax]
0054762A mov      ecx, dword ptr [ebp - 0x144]
00547630 mov      eax, dword ptr [edx + 0xc0]
00547636 call     eax
00547638 mov      ecx, dword ptr [ebp - 0x14c]
0054763E mov      edx, dword ptr [ecx]
00547640 mov      ecx, dword ptr [ebp - 0x14c]
00547646 mov      eax, dword ptr [edx + 0xc0]
0054764C call     eax
0054764E mov      ecx, dword ptr [ebp - 0x1f8]
00547654 add      ecx, 0x44
00547657 call     0x406410
0054765C push     eax
0054765D lea      ecx, [ebp - 0x8b0]
00547663 call     0x405650
00547668 mov      byte ptr [ebp - 4], 0x37
0054766C lea      ecx, [ebp - 0x8b0]
00547672 push     ecx
00547673 mov      edx, dword ptr [ebp - 0x14c]
00547679 mov      eax, dword ptr [edx]
0054767B mov      ecx, dword ptr [ebp - 0x14c]
00547681 mov      edx, dword ptr [eax + 0x28]
00547684 call     edx
00547686 mov      byte ptr [ebp - 4], 0
0054768A lea      ecx, [ebp - 0x8b0]
00547690 call     0x4056d0
00547695 mov      ecx, dword ptr [ebp - 0x1f8]
0054769B add      ecx, 0xc
0054769E call     0x406410
005476A3 push     eax
005476A4 lea      ecx, [ebp - 0x8cc]
005476AA call     0x405650
005476AF mov      byte ptr [ebp - 4], 0x38
005476B3 push     1
005476B5 lea      eax, [ebp - 0x8cc]
005476BB push     eax
005476BC mov      ecx, dword ptr [ebp - 0x144]
005476C2 mov      edx, dword ptr [ecx]
005476C4 mov      ecx, dword ptr [ebp - 0x144]
005476CA mov      eax, dword ptr [edx + 0xd4]
005476D0 call     eax
005476D2 mov      byte ptr [ebp - 4], 0
005476D6 lea      ecx, [ebp - 0x8cc]
005476DC call     0x4056d0
005476E1 jmp      0x547d83
005476E6 mov      dword ptr [ebp - 0x200], 0
005476F0 jmp      0x547701
005476F2 mov      ecx, dword ptr [ebp - 0x200]
005476F8 add      ecx, 1
005476FB mov      dword ptr [ebp - 0x200], ecx
00547701 cmp      dword ptr [ebp - 0x200], 4
00547708 jge      0x547c3e
0054770E lea      edx, [ebp - 0x200]
00547714 push     edx
00547715 lea      eax, [ebp - 0x8e8]
0054771B push     eax
0054771C call     0xa44160
00547721 add      esp, 8
00547724 mov      dword ptr [ebp - 0xd48], eax
0054772A mov      ecx, dword ptr [ebp - 0xd48]
00547730 mov      dword ptr [ebp - 0xd4c], ecx
00547736 mov      byte ptr [ebp - 4], 0x39
0054773A mov      edx, dword ptr [ebp - 0xd4c]
00547740 push     edx
00547741 mov      eax, dword ptr [0xb97424]
00547746 push     eax
00547747 lea      ecx, [ebp - 0x904]
0054774D push     ecx
0054774E call     0x411d70
00547753 add      esp, 0xc
00547756 mov      dword ptr [ebp - 0xd50], eax
0054775C mov      edx, dword ptr [ebp - 0xd50]
00547762 mov      dword ptr [ebp - 0xd54], edx
00547768 mov      byte ptr [ebp - 4], 0x3a
0054776C mov      eax, dword ptr [ebp - 0xd54]
00547772 push     eax
00547773 mov      ecx, dword ptr [ebp - 0x34]
00547776 call     0x75fbf0
0054777B mov      dword ptr [ebp - 0x14c], eax
00547781 mov      byte ptr [ebp - 4], 0x39
00547785 lea      ecx, [ebp - 0x904]
0054778B call     0x4056d0
00547790 mov      byte ptr [ebp - 4], 0
00547794 lea      ecx, [ebp - 0x8e8]
0054779A call     0x4056d0
0054779F lea      ecx, [ebp - 0x200]
005477A5 push     ecx
005477A6 lea      edx, [ebp - 0x920]
005477AC push     edx
005477AD call     0xa44160
005477B2 add      esp, 8
005477B5 mov      dword ptr [ebp - 0xd58], eax
005477BB mov      eax, dword ptr [ebp - 0xd58]
005477C1 mov      dword ptr [ebp - 0xd5c], eax
005477C7 mov      byte ptr [ebp - 4], 0x3b
005477CB mov      ecx, dword ptr [ebp - 0xd5c]
005477D1 push     ecx
005477D2 mov      edx, dword ptr [0xb97430]
005477D8 push     edx
005477D9 lea      eax, [ebp - 0x93c]
005477DF push     eax
005477E0 call     0x411d70
005477E5 add      esp, 0xc
005477E8 mov      dword ptr [ebp - 0xd60], eax
005477EE mov      ecx, dword ptr [ebp - 0xd60]
005477F4 mov      dword ptr [ebp - 0xd64], ecx
005477FA mov      byte ptr [ebp - 4], 0x3c
005477FE mov      edx, dword ptr [ebp - 0xd64]
00547804 push     edx
00547805 mov      ecx, dword ptr [ebp - 0x34]
00547808 call     0x75fbf0
0054780D mov      dword ptr [ebp - 0x144], eax
00547813 mov      byte ptr [ebp - 4], 0x3b
00547817 lea      ecx, [ebp - 0x93c]
0054781D call     0x4056d0
00547822 mov      byte ptr [ebp - 4], 0
00547826 lea      ecx, [ebp - 0x920]
0054782C call     0x4056d0
00547831 lea      eax, [ebp - 0x200]
00547837 push     eax
00547838 lea      ecx, [ebp - 0x958]
0054783E push     ecx
0054783F call     0xa44160
00547844 add      esp, 8
00547847 mov      dword ptr [ebp - 0xd68], eax
0054784D mov      edx, dword ptr [ebp - 0xd68]
00547853 mov      dword ptr [ebp - 0xd6c], edx
00547859 mov      byte ptr [ebp - 4], 0x3d
0054785D mov      eax, dword ptr [ebp - 0xd6c]
00547863 push     eax
00547864 mov      ecx, dword ptr [0xb97490]
0054786A push     ecx
0054786B lea      edx, [ebp - 0x974]
00547871 push     edx
00547872 call     0x411d70
00547877 add      esp, 0xc
0054787A mov      dword ptr [ebp - 0xd70], eax
00547880 mov      eax, dword ptr [ebp - 0xd70]
00547886 mov      dword ptr [ebp - 0xd74], eax
0054788C mov      byte ptr [ebp - 4], 0x3e
00547890 mov      ecx, dword ptr [ebp - 0xd74]
00547896 push     ecx
00547897 mov      ecx, dword ptr [ebp - 0x34]
0054789A call     0x75fbf0
0054789F mov      dword ptr [ebp - 0x204], eax
005478A5 mov      byte ptr [ebp - 4], 0x3d
005478A9 lea      ecx, [ebp - 0x974]
005478AF call     0x4056d0
005478B4 mov      byte ptr [ebp - 4], 0
005478B8 lea      ecx, [ebp - 0x958]
005478BE call     0x4056d0
005478C3 lea      edx, [ebp - 0x200]
005478C9 push     edx
005478CA lea      eax, [ebp - 0x990]
005478D0 push     eax
005478D1 call     0xa44160
005478D6 add      esp, 8
005478D9 mov      dword ptr [ebp - 0xd78], eax
005478DF mov      ecx, dword ptr [ebp - 0xd78]
005478E5 mov      dword ptr [ebp - 0xd7c], ecx
005478EB mov      byte ptr [ebp - 4], 0x3f
005478EF mov      edx, dword ptr [ebp - 0xd7c]
005478F5 push     edx
005478F6 mov      eax, dword ptr [0xb97428]
005478FB push     eax
005478FC lea      ecx, [ebp - 0x9ac]
00547902 push     ecx
00547903 call     0x411d70
00547908 add      esp, 0xc
0054790B mov      dword ptr [ebp - 0xd80], eax
00547911 mov      edx, dword ptr [ebp - 0xd80]
00547917 mov      dword ptr [ebp - 0xd84], edx
0054791D mov      byte ptr [ebp - 4], 0x40
00547921 mov      eax, dword ptr [ebp - 0xd84]
00547927 push     eax
00547928 mov      ecx, dword ptr [ebp - 0x34]
0054792B call     0x75fbf0
00547930 mov      dword ptr [ebp - 0x208], eax
00547936 mov      byte ptr [ebp - 4], 0x3f
0054793A lea      ecx, [ebp - 0x9ac]
00547940 call     0x4056d0
00547945 mov      byte ptr [ebp - 4], 0
00547949 lea      ecx, [ebp - 0x990]
0054794F call     0x4056d0
00547954 cmp      dword ptr [ebp - 0x204], 0
0054795B je       0x547973
0054795D mov      ecx, dword ptr [ebp - 0x204]
00547963 mov      edx, dword ptr [ecx]
00547965 mov      ecx, dword ptr [ebp - 0x204]
0054796B mov      eax, dword ptr [edx + 0xc4]
00547971 call     eax
00547973 cmp      dword ptr [ebp - 0x14c], 0
0054797A je       0x547a08
00547980 cmp      dword ptr [ebp - 0x144], 0
00547987 je       0x547a08
00547989 push     0xb96699
0054798E lea      ecx, [ebp - 0x9c8]
00547994 call     0x405650
00547999 mov      byte ptr [ebp - 4], 0x41
0054799D push     1
0054799F lea      ecx, [ebp - 0x9c8]
005479A5 push     ecx
005479A6 mov      edx, dword ptr [ebp - 0x144]
005479AC mov      eax, dword ptr [edx]
005479AE mov      ecx, dword ptr [ebp - 0x144]
005479B4 mov      edx, dword ptr [eax + 0xd4]
005479BA call     edx
005479BC mov      byte ptr [ebp - 4], 0
005479C0 lea      ecx, [ebp - 0x9c8]
005479C6 call     0x4056d0
005479CB push     0xb96699
005479D0 lea      ecx, [ebp - 0x9e4]
005479D6 call     0x405650
005479DB mov      byte ptr [ebp - 4], 0x42
005479DF lea      eax, [ebp - 0x9e4]
005479E5 push     eax
005479E6 mov      ecx, dword ptr [ebp - 0x14c]
005479EC mov      edx, dword ptr [ecx]
005479EE mov      ecx, dword ptr [ebp - 0x14c]
005479F4 mov      eax, dword ptr [edx + 0x28]
005479F7 call     eax
005479F9 mov      byte ptr [ebp - 4], 0
005479FD lea      ecx, [ebp - 0x9e4]
00547A03 call     0x4056d0
00547A08 mov      ecx, dword ptr [ebp - 0x200]
00547A0E mov      edx, dword ptr [ebp - 0x148]
00547A14 cmp      dword ptr [edx + ecx*4 + 0x90], 0
00547A1C je       0x547c39
00547A22 push     0x6c
00547A24 push     0
00547A26 lea      eax, [ebp - 0x27c]
00547A2C push     eax
00547A2D call     0x666960
00547A32 add      esp, 0xc
00547A35 mov      dword ptr [ebp - 0x280], 0
00547A3F lea      ecx, [ebp - 0x27c]
00547A45 push     ecx
00547A46 mov      edx, dword ptr [ebp - 0x200]
00547A4C mov      eax, dword ptr [ebp - 0x148]
00547A52 mov      ecx, dword ptr [eax + edx*4 + 0x90]
00547A59 push     ecx
00547A5A call     0x41bc70
00547A5F mov      ecx, eax
00547A61 call     0x85ba40
00547A66 test     eax, eax
00547A68 je       0x547a83
00547A6A mov      edx, dword ptr [ebp - 0x277]
00547A70 push     edx
00547A71 call     0xa21b30
00547A76 mov      ecx, eax
00547A78 call     0xa1e560
00547A7D mov      dword ptr [ebp - 0x280], eax
00547A83 cmp      dword ptr [ebp - 0x280], 0
00547A8A je       0x547c39
00547A90 cmp      dword ptr [ebp - 0x204], 0
00547A97 je       0x547c39
00547A9D cmp      dword ptr [ebp - 0x14c], 0
00547AA4 je       0x547c39
00547AAA cmp      dword ptr [ebp - 0x144], 0
00547AB1 je       0x547c39
00547AB7 mov      eax, dword ptr [ebp - 0x204]
00547ABD mov      edx, dword ptr [eax]
00547ABF mov      ecx, dword ptr [ebp - 0x204]
00547AC5 mov      eax, dword ptr [edx + 0xc0]
00547ACB call     eax
00547ACD mov      ecx, dword ptr [ebp - 0x144]
00547AD3 mov      edx, dword ptr [ecx]
00547AD5 mov      ecx, dword ptr [ebp - 0x144]
00547ADB mov      eax, dword ptr [edx + 0xc0]
00547AE1 call     eax
00547AE3 mov      ecx, dword ptr [ebp - 0x14c]
00547AE9 mov      edx, dword ptr [ecx]
00547AEB mov      ecx, dword ptr [ebp - 0x14c]
00547AF1 mov      eax, dword ptr [edx + 0xc0]
00547AF7 call     eax
00547AF9 mov      ecx, dword ptr [ebp - 0x280]
00547AFF add      ecx, 0x44
00547B02 call     0x406410
00547B07 push     eax
00547B08 lea      ecx, [ebp - 0xa00]
00547B0E call     0x405650
00547B13 mov      byte ptr [ebp - 4], 0x43
00547B17 lea      ecx, [ebp - 0xa00]
00547B1D push     ecx
00547B1E mov      edx, dword ptr [ebp - 0x14c]
00547B24 mov      eax, dword ptr [edx]
00547B26 mov      ecx, dword ptr [ebp - 0x14c]
00547B2C mov      edx, dword ptr [eax + 0x28]
00547B2F call     edx
00547B31 mov      byte ptr [ebp - 4], 0
00547B35 lea      ecx, [ebp - 0xa00]
00547B3B call     0x4056d0
00547B40 mov      ecx, dword ptr [ebp - 0x280]
00547B46 add      ecx, 0xc
00547B49 call     0x406410
00547B4E push     eax
00547B4F lea      ecx, [ebp - 0xa1c]
00547B55 call     0x405650
00547B5A mov      byte ptr [ebp - 4], 0x44
00547B5E push     1
00547B60 lea      eax, [ebp - 0xa1c]
00547B66 push     eax
00547B67 mov      ecx, dword ptr [ebp - 0x144]
00547B6D mov      edx, dword ptr [ecx]
00547B6F mov      ecx, dword ptr [ebp - 0x144]
00547B75 mov      eax, dword ptr [edx + 0xd4]
00547B7B call     eax
00547B7D mov      byte ptr [ebp - 4], 0
00547B81 lea      ecx, [ebp - 0xa1c]
00547B87 call     0x4056d0
00547B8C mov      ecx, dword ptr [ebp - 0x200]
00547B92 mov      edx, dword ptr [ebp - 0x148]
00547B98 mov      eax, dword ptr [edx + ecx*4 + 0x90]
00547B9F cdq
00547BA0 mov      ecx, 0x64
00547BA5 idiv     ecx
00547BA7 mov      dword ptr [ebp - 0xa20], eax
00547BAD lea      edx, [ebp - 0xa20]
00547BB3 push     edx
00547BB4 lea      eax, [ebp - 0xa3c]
00547BBA push     eax
00547BBB call     0xa44160
00547BC0 add      esp, 8
00547BC3 mov      dword ptr [ebp - 0xd88], eax
00547BC9 mov      ecx, dword ptr [ebp - 0xd88]
00547BCF mov      dword ptr [ebp - 0xd8c], ecx
00547BD5 mov      byte ptr [ebp - 4], 0x45
00547BD9 mov      edx, dword ptr [ebp - 0xd8c]
00547BDF push     edx
00547BE0 push     0xbb6b98
00547BE5 lea      eax, [ebp - 0x29c]
00547BEB push     eax
00547BEC call     0x411d70
00547BF1 add      esp, 0xc
00547BF4 mov      byte ptr [ebp - 4], 0x47
00547BF8 lea      ecx, [ebp - 0xa3c]
00547BFE call     0x4056d0
00547C03 cmp      dword ptr [ebp - 0x208], 0
00547C0A je       0x547c1e
00547C0C lea      ecx, [ebp - 0x29c]
00547C12 push     ecx
00547C13 mov      ecx, dword ptr [ebp - 0x208]
00547C19 call     0x4c16b0
00547C1E mov      dx, word ptr [ebp - 0x2c]
00547C22 add      dx, 1
00547C26 mov      word ptr [ebp - 0x2c], dx
00547C2A mov      byte ptr [ebp - 4], 0
00547C2E lea      ecx, [ebp - 0x29c]
00547C34 call     0x4056d0
00547C39 jmp      0x5476f2
00547C3E mov      eax, dword ptr [0xb97494]
00547C43 push     eax
00547C44 lea      ecx, [ebp - 0xa58]
00547C4A call     0x405650
00547C4F mov      byte ptr [ebp - 4], 0x48
00547C53 lea      ecx, [ebp - 0xa58]
00547C59 push     ecx
00547C5A mov      ecx, dword ptr [ebp - 0x34]
00547C5D call     0x75fbf0
00547C62 mov      dword ptr [ebp - 0x144], eax
00547C68 mov      byte ptr [ebp - 4], 0
00547C6C lea      ecx, [ebp - 0xa58]
00547C72 call     0x4056d0
00547C77 cmp      dword ptr [ebp - 0x144], 0
00547C7E je       0x547cd8
00547C80 mov      edx, dword ptr [ebp - 0x144]
00547C86 mov      eax, dword ptr [edx]
00547C88 mov      ecx, dword ptr [ebp - 0x144]
00547C8E mov      edx, dword ptr [eax + 0xc4]
00547C94 call     edx
00547C96 push     0xb96699
00547C9B lea      ecx, [ebp - 0xa74]
00547CA1 call     0x405650
00547CA6 mov      byte ptr [ebp - 4], 0x49
00547CAA push     1
00547CAC lea      eax, [ebp - 0xa74]
00547CB2 push     eax
00547CB3 mov      ecx, dword ptr [ebp - 0x144]
00547CB9 mov      edx, dword ptr [ecx]
00547CBB mov      ecx, dword ptr [ebp - 0x144]
00547CC1 mov      eax, dword ptr [edx + 0xd4]
00547CC7 call     eax
00547CC9 mov      byte ptr [ebp - 4], 0
00547CCD lea      ecx, [ebp - 0xa74]
00547CD3 call     0x4056d0
00547CD8 movsx    ecx, word ptr [ebp - 0x2c]
00547CDC test     ecx, ecx
00547CDE jle      0x547d38
00547CE0 mov      edx, dword ptr [ebp - 0x144]
00547CE6 mov      eax, dword ptr [edx]
00547CE8 mov      ecx, dword ptr [ebp - 0x144]
00547CEE mov      edx, dword ptr [eax + 0xc0]
00547CF4 call     edx
00547CF6 push     0xbc9a3c
00547CFB lea      ecx, [ebp - 0xa90]
00547D01 call     0x405650
00547D06 mov      byte ptr [ebp - 4], 0x4a
00547D0A push     1
00547D0C lea      eax, [ebp - 0xa90]
00547D12 push     eax
00547D13 mov      ecx, dword ptr [ebp - 0x144]
00547D19 mov      edx, dword ptr [ecx]
00547D1B mov      ecx, dword ptr [ebp - 0x144]
00547D21 mov      eax, dword ptr [edx + 0xd4]
00547D27 call     eax
00547D29 mov      byte ptr [ebp - 4], 0
00547D2D lea      ecx, [ebp - 0xa90]
00547D33 call     0x4056d0
00547D38 movsx    ecx, word ptr [ebp - 0x2c]
00547D3C cmp      ecx, 1
00547D3F jle      0x547d83
00547D41 push     0xbc99f4
00547D46 lea      ecx, [ebp - 0xaac]
00547D4C call     0x405650
00547D51 mov      byte ptr [ebp - 4], 0x4b
00547D55 push     1
00547D57 lea      edx, [ebp - 0xaac]
00547D5D push     edx
00547D5E mov      eax, dword ptr [ebp - 0x144]
00547D64 mov      edx, dword ptr [eax]
00547D66 mov      ecx, dword ptr [ebp - 0x144]
00547D6C mov      eax, dword ptr [edx + 0xd4]
00547D72 call     eax
00547D74 mov      byte ptr [ebp - 4], 0
00547D78 lea      ecx, [ebp - 0xaac]
00547D7E call     0x4056d0
00547D83 mov      ecx, dword ptr [0xb97448]
00547D89 push     ecx
00547D8A lea      ecx, [ebp - 0xac8]
00547D90 call     0x405650
00547D95 mov      byte ptr [ebp - 4], 0x4c
00547D99 push     0
00547D9B lea      edx, [ebp - 0xac8]
00547DA1 push     edx
00547DA2 mov      ecx, dword ptr [ebp - 0x34]
00547DA5 call     0x7611c0
00547DAA mov      byte ptr [ebp - 4], 0
00547DAE lea      ecx, [ebp - 0xac8]
00547DB4 call     0x4056d0
00547DB9 mov      eax, dword ptr [0xb9744c]
00547DBE push     eax
00547DBF lea      ecx, [ebp - 0xae4]
00547DC5 call     0x405650
00547DCA mov      byte ptr [ebp - 4], 0x4d
00547DCE push     0
00547DD0 lea      ecx, [ebp - 0xae4]
00547DD6 push     ecx
00547DD7 mov      ecx, dword ptr [ebp - 0x34]
00547DDA call     0x7611c0
00547DDF mov      byte ptr [ebp - 4], 0
00547DE3 lea      ecx, [ebp - 0xae4]
00547DE9 call     0x4056d0
00547DEE mov      edx, dword ptr [0xb97478]
00547DF4 push     edx
00547DF5 lea      ecx, [ebp - 0xb00]
00547DFB call     0x405650
00547E00 mov      byte ptr [ebp - 4], 0x4e
00547E04 push     0
00547E06 lea      eax, [ebp - 0xb00]
00547E0C push     eax
00547E0D mov      ecx, dword ptr [ebp - 0x34]
00547E10 call     0x7611c0
00547E15 mov      byte ptr [ebp - 4], 0
00547E19 lea      ecx, [ebp - 0xb00]
00547E1F call     0x4056d0
00547E24 mov      ecx, dword ptr [ebp - 0x140]
00547E2A movzx    edx, byte ptr [ecx + 0x10]
00547E2E mov      dword ptr [ebp - 0xd90], edx
00547E34 mov      eax, dword ptr [ebp - 0xd90]
00547E3A sub      eax, 1
00547E3D mov      dword ptr [ebp - 0xd90], eax
00547E43 cmp      dword ptr [ebp - 0xd90], 3
00547E4A ja       0x5480f0
00547E50 mov      ecx, dword ptr [ebp - 0xd90]
00547E56 jmp      dword ptr [ecx*4 + 0x54811c]
00547E5D mov      edx, dword ptr [0xb97448]
00547E63 push     edx
00547E64 lea      ecx, [ebp - 0xb1c]
00547E6A call     0x405650
00547E6F mov      byte ptr [ebp - 4], 0x4f
00547E73 push     1
00547E75 lea      eax, [ebp - 0xb1c]
00547E7B push     eax
00547E7C mov      ecx, dword ptr [ebp - 0x34]
00547E7F call     0x7611c0
00547E84 mov      byte ptr [ebp - 4], 0
00547E88 lea      ecx, [ebp - 0xb1c]
00547E8E call     0x4056d0
00547E93 mov      ecx, dword ptr [0xb9744c]
00547E99 push     ecx
00547E9A lea      ecx, [ebp - 0xb38]
00547EA0 call     0x405650
00547EA5 mov      byte ptr [ebp - 4], 0x50
00547EA9 push     0
00547EAB lea      edx, [ebp - 0xb38]
00547EB1 push     edx
00547EB2 mov      ecx, dword ptr [ebp - 0x34]
00547EB5 call     0x7611c0
00547EBA mov      byte ptr [ebp - 4], 0
00547EBE lea      ecx, [ebp - 0xb38]
00547EC4 call     0x4056d0
00547EC9 mov      eax, dword ptr [0xb97478]
00547ECE push     eax
00547ECF lea      ecx, [ebp - 0xb54]
00547ED5 call     0x405650
00547EDA mov      byte ptr [ebp - 4], 0x51
00547EDE push     0
00547EE0 lea      ecx, [ebp - 0xb54]
00547EE6 push     ecx
00547EE7 mov      ecx, dword ptr [ebp - 0x34]
00547EEA call     0x7611c0
00547EEF mov      byte ptr [ebp - 4], 0
00547EF3 lea      ecx, [ebp - 0xb54]
00547EF9 call     0x4056d0
00547EFE jmp      0x5480f0
00547F03 mov      edx, dword ptr [0xb97448]
00547F09 push     edx
00547F0A lea      ecx, [ebp - 0xb70]
00547F10 call     0x405650
00547F15 mov      byte ptr [ebp - 4], 0x52
00547F19 push     0
00547F1B lea      eax, [ebp - 0xb70]
00547F21 push     eax
00547F22 mov      ecx, dword ptr [ebp - 0x34]
00547F25 call     0x7611c0
00547F2A mov      byte ptr [ebp - 4], 0
00547F2E lea      ecx, [ebp - 0xb70]
00547F34 call     0x4056d0
00547F39 mov      ecx, dword ptr [0xb9744c]
00547F3F push     ecx
00547F40 lea      ecx, [ebp - 0xb8c]
00547F46 call     0x405650
00547F4B mov      byte ptr [ebp - 4], 0x53
00547F4F push     1
00547F51 lea      edx, [ebp - 0xb8c]
00547F57 push     edx
00547F58 mov      ecx, dword ptr [ebp - 0x34]
00547F5B call     0x7611c0
00547F60 mov      byte ptr [ebp - 4], 0
00547F64 lea      ecx, [ebp - 0xb8c]
00547F6A call     0x4056d0
00547F6F mov      eax, dword ptr [0xb97478]
00547F74 push     eax
00547F75 lea      ecx, [ebp - 0xba8]
00547F7B call     0x405650
00547F80 mov      byte ptr [ebp - 4], 0x54
00547F84 push     0
00547F86 lea      ecx, [ebp - 0xba8]
00547F8C push     ecx
00547F8D mov      ecx, dword ptr [ebp - 0x34]
00547F90 call     0x7611c0
00547F95 mov      byte ptr [ebp - 4], 0
00547F99 lea      ecx, [ebp - 0xba8]
00547F9F call     0x4056d0
00547FA4 jmp      0x5480f0
00547FA9 mov      edx, dword ptr [0xb97448]
00547FAF push     edx
00547FB0 lea      ecx, [ebp - 0xbc4]
00547FB6 call     0x405650
00547FBB mov      byte ptr [ebp - 4], 0x55
00547FBF push     0
00547FC1 lea      eax, [ebp - 0xbc4]
00547FC7 push     eax
00547FC8 mov      ecx, dword ptr [ebp - 0x34]
00547FCB call     0x7611c0
00547FD0 mov      byte ptr [ebp - 4], 0
00547FD4 lea      ecx, [ebp - 0xbc4]
00547FDA call     0x4056d0
00547FDF mov      ecx, dword ptr [0xb9744c]
00547FE5 push     ecx
00547FE6 lea      ecx, [ebp - 0xbe0]
00547FEC call     0x405650
00547FF1 mov      byte ptr [ebp - 4], 0x56
00547FF5 push     0
00547FF7 lea      edx, [ebp - 0xbe0]
00547FFD push     edx
00547FFE mov      ecx, dword ptr [ebp - 0x34]
00548001 call     0x7611c0
00548006 mov      byte ptr [ebp - 4], 0
0054800A lea      ecx, [ebp - 0xbe0]
00548010 call     0x4056d0
00548015 mov      eax, dword ptr [0xb97478]
0054801A push     eax
0054801B lea      ecx, [ebp - 0xbfc]
00548021 call     0x405650
00548026 mov      byte ptr [ebp - 4], 0x57
0054802A push     1
0054802C lea      ecx, [ebp - 0xbfc]
00548032 push     ecx
00548033 mov      ecx, dword ptr [ebp - 0x34]
00548036 call     0x7611c0
0054803B mov      byte ptr [ebp - 4], 0
0054803F lea      ecx, [ebp - 0xbfc]
00548045 call     0x4056d0
0054804A jmp      0x5480f0
0054804F mov      edx, dword ptr [0xb97448]
00548055 push     edx
00548056 lea      ecx, [ebp - 0xc18]
0054805C call     0x405650
00548061 mov      byte ptr [ebp - 4], 0x58
00548065 push     0
00548067 lea      eax, [ebp - 0xc18]
0054806D push     eax
0054806E mov      ecx, dword ptr [ebp - 0x34]
00548071 call     0x7611c0
00548076 mov      byte ptr [ebp - 4], 0
0054807A lea      ecx, [ebp - 0xc18]
00548080 call     0x4056d0
00548085 mov      ecx, dword ptr [0xb9744c]
0054808B push     ecx
0054808C lea      ecx, [ebp - 0xc34]
00548092 call     0x405650
00548097 mov      byte ptr [ebp - 4], 0x59
0054809B push     0
0054809D lea      edx, [ebp - 0xc34]
005480A3 push     edx
005480A4 mov      ecx, dword ptr [ebp - 0x34]
005480A7 call     0x7611c0
005480AC mov      byte ptr [ebp - 4], 0
005480B0 lea      ecx, [ebp - 0xc34]
005480B6 call     0x4056d0
005480BB mov      eax, dword ptr [0xb97478]
005480C0 push     eax
005480C1 lea      ecx, [ebp - 0xc50]
005480C7 call     0x405650
005480CC mov      byte ptr [ebp - 4], 0x5a
005480D0 push     0
005480D2 lea      ecx, [ebp - 0xc50]
005480D8 push     ecx
005480D9 mov      ecx, dword ptr [ebp - 0x34]
005480DC call     0x7611c0
005480E1 mov      byte ptr [ebp - 4], 0
005480E5 lea      ecx, [ebp - 0xc50]
005480EB call     0x4056d0
005480F0 mov      dword ptr [ebp - 4], 0xffffffff
005480F7 lea      ecx, [ebp - 0x164]
005480FD call     0x412d20
00548102 mov      ecx, dword ptr [ebp - 0xc]
00548105 mov      dword ptr fs:[0], ecx
0054810C pop      ecx
0054810D pop      esi
0054810E mov      ecx, dword ptr [ebp - 0x38]
00548111 xor      ecx, ebp
00548113 call     0x6634fb
00548118 mov      esp, ebp
0054811A pop      ebp
0054811B ret

; function 0xa47e70
00A47E70 push     ebp
00A47E71 mov      ebp, esp
00A47E73 push     -1
00A47E75 push     0xa9de8d
00A47E7A mov      eax, dword ptr fs:[0]
00A47E80 push     eax
00A47E81 sub      esp, 0x34
00A47E84 mov      eax, dword ptr [0xc7b480]
00A47E89 xor      eax, ebp
00A47E8B push     eax
00A47E8C lea      eax, [ebp - 0xc]
00A47E8F mov      dword ptr fs:[0], eax
00A47E95 mov      dword ptr [ebp - 0x40], ecx
00A47E98 mov      dword ptr [ebp - 0x3c], 0
00A47E9F lea      ecx, [ebp - 0x2c]
00A47EA2 call     0x533170
00A47EA7 mov      dword ptr [ebp - 4], 0
00A47EAE movzx    eax, word ptr [ebp + 0xc]
00A47EB2 mov      dword ptr [ebp - 0x30], eax
00A47EB5 lea      ecx, [ebp - 0x30]
00A47EB8 push     ecx
00A47EB9 lea      edx, [ebp - 0x14]
00A47EBC push     edx
00A47EBD mov      ecx, dword ptr [ebp - 0x40]
00A47EC0 add      ecx, 0x58
00A47EC3 call     0x532d60
00A47EC8 lea      eax, [ebp - 0x38]
00A47ECB push     eax
00A47ECC mov      ecx, dword ptr [ebp - 0x40]
00A47ECF add      ecx, 0x58
00A47ED2 call     0x45abb0
00A47ED7 push     eax
00A47ED8 lea      ecx, [ebp - 0x14]
00A47EDB call     0x4ab920
00A47EE0 movzx    ecx, al
00A47EE3 test     ecx, ecx
00A47EE5 je       0xa47f12
00A47EE7 lea      edx, [ebp - 0x2c]
00A47EEA push     edx
00A47EEB mov      ecx, dword ptr [ebp + 8]
00A47EEE call     0x5331e0
00A47EF3 mov      eax, dword ptr [ebp - 0x3c]
00A47EF6 or       eax, 1
00A47EF9 mov      dword ptr [ebp - 0x3c], eax
00A47EFC mov      dword ptr [ebp - 4], 0xffffffff
00A47F03 lea      ecx, [ebp - 0x2c]
00A47F06 call     0x412d20
00A47F0B mov      eax, dword ptr [ebp + 8]
00A47F0E jmp      0xa47f52
00A47F10 jmp      0xa47f43
00A47F12 lea      ecx, [ebp - 0x14]
00A47F15 call     0x4305b0
00A47F1A add      eax, 4
00A47F1D push     eax
00A47F1E mov      ecx, dword ptr [ebp + 8]
00A47F21 call     0x5331e0
00A47F26 mov      ecx, dword ptr [ebp - 0x3c]
00A47F29 or       ecx, 1
00A47F2C mov      dword ptr [ebp - 0x3c], ecx
00A47F2F mov      dword ptr [ebp - 4], 0xffffffff
00A47F36 lea      ecx, [ebp - 0x2c]
00A47F39 call     0x412d20
00A47F3E mov      eax, dword ptr [ebp + 8]
00A47F41 jmp      0xa47f52
00A47F43 mov      dword ptr [ebp - 4], 0xffffffff
00A47F4A lea      ecx, [ebp - 0x2c]
00A47F4D call     0x412d20
00A47F52 mov      ecx, dword ptr [ebp - 0xc]
00A47F55 mov      dword ptr fs:[0], ecx
00A47F5C pop      ecx
00A47F5D mov      esp, ebp
00A47F5F pop      ebp
00A47F60 ret      8
