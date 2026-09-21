; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; Function 0x8bae30
008BAE30 push     ebp
008BAE31 mov      ebp, esp
008BAE33 push     -1
008BAE35 push     0xac6cd3
008BAE3A mov      eax, dword ptr fs:[0]
008BAE40 push     eax
008BAE41 sub      esp, 0x140
008BAE47 mov      eax, dword ptr [0xc7b480]
008BAE4C xor      eax, ebp
008BAE4E mov      dword ptr [ebp - 0x14], eax
008BAE51 push     eax
008BAE52 lea      eax, [ebp - 0xc]
008BAE55 mov      dword ptr fs:[0], eax
008BAE5B mov      dword ptr [ebp - 0x148], ecx
008BAE61 mov      eax, dword ptr [ebp + 0x18]
008BAE64 push     eax
008BAE65 mov      ecx, dword ptr [ebp + 0x14]
008BAE68 push     ecx
008BAE69 mov      edx, dword ptr [ebp + 0x10]
008BAE6C push     edx
008BAE6D mov      eax, dword ptr [ebp + 0xc]
008BAE70 push     eax
008BAE71 mov      ecx, dword ptr [ebp + 8]
008BAE74 push     ecx
008BAE75 mov      ecx, dword ptr [ebp - 0x148]
008BAE7B call     0x7ddba0
008BAE80 cmp      dword ptr [ebp + 8], 0x101
008BAE87 jne      0x8bb146
008BAE8D mov      edx, dword ptr [0xb99564]
008BAE93 push     edx
008BAE94 lea      ecx, [ebp - 0xb4]
008BAE9A call     0x405650
008BAE9F mov      dword ptr [ebp - 4], 0
008BAEA6 lea      eax, [ebp - 0xb4]
008BAEAC push     eax
008BAEAD mov      ecx, dword ptr [ebp + 0x10]
008BAEB0 push     ecx
008BAEB1 mov      ecx, dword ptr [ebp - 0x148]
008BAEB7 call     0x7d25b0
008BAEBC mov      dword ptr [ebp - 0x10], eax
008BAEBF mov      dword ptr [ebp - 4], 0xffffffff
008BAEC6 lea      ecx, [ebp - 0xb4]
008BAECC call     0x4056d0
008BAED1 cmp      dword ptr [ebp - 0x10], -1
008BAED5 je       0x8baeeb
008BAED7 mov      edx, dword ptr [ebp - 0x10]
008BAEDA push     edx
008BAEDB mov      ecx, dword ptr [ebp - 0x148]
008BAEE1 call     0x8bad50
008BAEE6 jmp      0x8bb146
008BAEEB mov      eax, dword ptr [0xb995ac]
008BAEF0 push     eax
008BAEF1 lea      ecx, [ebp - 0xd0]
008BAEF7 call     0x405650
008BAEFC mov      dword ptr [ebp - 4], 1
008BAF03 lea      ecx, [ebp - 0xd0]
008BAF09 push     ecx
008BAF0A mov      edx, dword ptr [ebp + 0x10]
008BAF0D push     edx
008BAF0E mov      ecx, dword ptr [ebp - 0x148]
008BAF14 call     0x7d25b0
008BAF19 mov      dword ptr [ebp - 0x10], eax
008BAF1C mov      dword ptr [ebp - 4], 0xffffffff
008BAF23 lea      ecx, [ebp - 0xd0]
008BAF29 call     0x4056d0
008BAF2E cmp      dword ptr [ebp - 0x10], -1
008BAF32 je       0x8baf57
008BAF34 mov      eax, dword ptr [ebp - 0x10]
008BAF37 push     eax
008BAF38 mov      ecx, dword ptr [ebp - 0x148]
008BAF3E call     0x8ba780
008BAF43 mov      ecx, dword ptr [ebp - 0x148]
008BAF49 mov      edx, dword ptr [ebp - 0x10]
008BAF4C mov      dword ptr [ecx + 0x608], edx
008BAF52 jmp      0x8bb146
008BAF57 mov      eax, dword ptr [0xb995b0]
008BAF5C push     eax
008BAF5D lea      ecx, [ebp - 0xec]
008BAF63 call     0x405650
008BAF68 mov      dword ptr [ebp - 4], 2
008BAF6F lea      ecx, [ebp - 0xec]
008BAF75 push     ecx
008BAF76 mov      edx, dword ptr [ebp + 0x10]
008BAF79 push     edx
008BAF7A mov      ecx, dword ptr [ebp - 0x148]
008BAF80 call     0x7d25b0
008BAF85 mov      dword ptr [ebp - 0x10], eax
008BAF88 mov      dword ptr [ebp - 4], 0xffffffff
008BAF8F lea      ecx, [ebp - 0xec]
008BAF95 call     0x4056d0
008BAF9A cmp      dword ptr [ebp - 0x10], -1
008BAF9E je       0x8bb0af
008BAFA4 mov      eax, dword ptr [ebp - 0x148]
008BAFAA mov      ecx, dword ptr [ebp - 0x10]
008BAFAD mov      dword ptr [eax + 0x608], ecx
008BAFB3 mov      dword ptr [ebp - 0xfc], 0
008BAFBD mov      dword ptr [ebp - 0xf8], 0
008BAFC7 mov      dword ptr [ebp - 0xf4], 0
008BAFD1 mov      dword ptr [ebp - 0xf0], 0xffffffff
008BAFDB mov      dword ptr [ebp - 0x10c], 0x8b9160
008BAFE5 mov      dword ptr [ebp - 0x108], 0
008BAFEF mov      dword ptr [ebp - 0x104], 0
008BAFF9 mov      dword ptr [ebp - 0x100], 0
008BB003 push     0xbbc4b0
008BB008 lea      ecx, [ebp - 0x128]
008BB00E call     0x405650
008BB013 mov      dword ptr [ebp - 4], 3
008BB01A call     0x403820
008BB01F mov      dword ptr [ebp - 0x14c], eax
008BB025 push     0
008BB027 sub      esp, 0x10
008BB02A mov      edx, esp
008BB02C mov      eax, dword ptr [ebp - 0xfc]
008BB032 mov      dword ptr [edx], eax
008BB034 mov      ecx, dword ptr [ebp - 0xf8]
008BB03A mov      dword ptr [edx + 4], ecx
008BB03D mov      eax, dword ptr [ebp - 0xf4]
008BB043 mov      dword ptr [edx + 8], eax
008BB046 mov      ecx, dword ptr [ebp - 0xf0]
008BB04C mov      dword ptr [edx + 0xc], ecx
008BB04F sub      esp, 0x10
008BB052 mov      edx, esp
008BB054 mov      eax, dword ptr [ebp - 0x10c]
008BB05A mov      dword ptr [edx], eax
008BB05C mov      ecx, dword ptr [ebp - 0x108]
008BB062 mov      dword ptr [edx + 4], ecx
008BB065 mov      eax, dword ptr [ebp - 0x104]
008BB06B mov      dword ptr [edx + 8], eax
008BB06E mov      ecx, dword ptr [ebp - 0x100]
008BB074 mov      dword ptr [edx + 0xc], ecx
008BB077 mov      edx, dword ptr [ebp - 0x148]
008BB07D push     edx
008BB07E push     1
008BB080 lea      eax, [ebp - 0x128]
008BB086 push     eax
008BB087 mov      ecx, dword ptr [ebp - 0x14c]
008BB08D mov      edx, dword ptr [ecx]
008BB08F mov      ecx, dword ptr [ebp - 0x14c]
008BB095 mov      eax, dword ptr [edx + 0x1b8]
008BB09B call     eax
008BB09D mov      dword ptr [ebp - 4], 0xffffffff
008BB0A4 lea      ecx, [ebp - 0x128]
008BB0AA call     0x4056d0
008BB0AF mov      ecx, dword ptr [0xb995c8]
008BB0B5 push     ecx
008BB0B6 lea      ecx, [ebp - 0x144]
008BB0BC call     0x405650
008BB0C1 mov      dword ptr [ebp - 4], 4
008BB0C8 lea      edx, [ebp - 0x144]
008BB0CE push     edx
008BB0CF mov      eax, dword ptr [ebp + 0x10]
008BB0D2 push     eax
008BB0D3 mov      ecx, dword ptr [ebp - 0x148]
008BB0D9 call     0x7d25b0
008BB0DE mov      dword ptr [ebp - 0x10], eax
008BB0E1 mov      dword ptr [ebp - 4], 0xffffffff
008BB0E8 lea      ecx, [ebp - 0x144]
008BB0EE call     0x4056d0
008BB0F3 cmp      dword ptr [ebp - 0x10], -1
008BB0F7 je       0x8bb146
008BB0F9 push     4
008BB0FB push     0
008BB0FD lea      ecx, [ebp - 0x98]
008BB103 push     ecx
008BB104 call     0x666960
008BB109 add      esp, 0xc
008BB10C lea      edx, [ebp - 0x94]
008BB112 push     edx
008BB113 mov      eax, dword ptr [ebp - 0x10]
008BB116 push     eax
008BB117 mov      ecx, dword ptr [ebp - 0x148]
008BB11D call     0x8b9180
008BB122 mov      ecx, dword ptr [ebp - 0x8c]
008BB128 mov      dword ptr [ebp - 0x98], ecx
008BB12E push     4
008BB130 lea      edx, [ebp - 0x98]
008BB136 push     edx
008BB137 push     0
008BB139 push     0x5a0
008BB13E call     0xa3c950
008BB143 add      esp, 0x10
008BB146 mov      ecx, dword ptr [ebp - 0xc]
008BB149 mov      dword ptr fs:[0], ecx
008BB150 pop      ecx
008BB151 mov      ecx, dword ptr [ebp - 0x14]
008BB154 xor      ecx, ebp
008BB156 call     0x6634fb
008BB15B mov      esp, ebp
008BB15D pop      ebp

; Function 0x8ba780
008BA780 push     ebp
008BA781 mov      ebp, esp
008BA783 sub      esp, 0x174
008BA789 mov      eax, dword ptr [0xc7b480]
008BA78E xor      eax, ebp
008BA790 mov      dword ptr [ebp - 0x10], eax
008BA793 mov      dword ptr [ebp - 0x16c], ecx
008BA799 lea      eax, [ebp - 0x168]
008BA79F push     eax
008BA7A0 mov      ecx, dword ptr [ebp + 8]
008BA7A3 push     ecx
008BA7A4 mov      ecx, dword ptr [ebp - 0x16c]
008BA7AA call     0x8b8f30
008BA7AF test     eax, eax
008BA7B1 jne      0x8ba7b8
008BA7B3 jmp      0x8ba860
008BA7B8 mov      edx, dword ptr [ebp - 0x168]
008BA7BE mov      dword ptr [ebp - 4], edx
008BA7C1 mov      ecx, dword ptr [0x17c86fc]
008BA7C7 call     0x402aa0
008BA7CC mov      dword ptr [ebp - 0xc], eax
008BA7CF mov      dword ptr [ebp - 8], edx
008BA7D2 push     0xc
008BA7D4 lea      eax, [ebp - 0xc]
008BA7D7 push     eax
008BA7D8 push     0
008BA7DA push     0x528
008BA7DF call     0xa3c950
008BA7E4 add      esp, 0x10
008BA7E7 cmp      dword ptr [ebp - 0x19], 0
008BA7EB jne      0x8ba823
008BA7ED lea      ecx, [ebp - 0x168]
008BA7F3 push     ecx
008BA7F4 call     0x504bf0
008BA7F9 mov      ecx, eax
008BA7FB call     0x89ee30
008BA800 call     0x504bf0
008BA805 mov      dword ptr [ebp - 0x170], eax
008BA80B mov      edx, dword ptr [ebp - 0x170]
008BA811 mov      eax, dword ptr [edx]
008BA813 mov      ecx, dword ptr [ebp - 0x170]
008BA819 mov      edx, dword ptr [eax + 0x108]
008BA81F call     edx
008BA821 jmp      0x8ba860
008BA823 cmp      dword ptr [ebp - 0x19], 0x2383
008BA82A jne      0x8ba860
008BA82C lea      eax, [ebp - 0x168]
008BA832 push     eax
008BA833 call     0x504c80
008BA838 mov      ecx, eax
008BA83A call     0x89d820
008BA83F call     0x504c80
008BA844 mov      dword ptr [ebp - 0x174], eax
008BA84A mov      ecx, dword ptr [ebp - 0x174]
008BA850 mov      edx, dword ptr [ecx]
008BA852 mov      ecx, dword ptr [ebp - 0x174]
008BA858 mov      eax, dword ptr [edx + 0x108]
008BA85E call     eax
008BA860 mov      ecx, dword ptr [ebp - 0x10]
008BA863 xor      ecx, ebp
008BA865 call     0x6634fb
008BA86A mov      esp, ebp
008BA86C pop      ebp
008BA86D ret      4

; Function 0x8b8fe0
008B8FE0 push     ebp
008B8FE1 mov      ebp, esp
008B8FE3 sub      esp, 0x16c
008B8FE9 mov      eax, dword ptr [0xc7b480]
008B8FEE xor      eax, ebp
008B8FF0 mov      dword ptr [ebp - 0x10], eax
008B8FF3 mov      dword ptr [ebp - 0x16c], ecx
008B8FF9 lea      eax, [ebp - 0x168]
008B8FFF push     eax
008B9000 mov      ecx, dword ptr [ebp + 8]
008B9003 push     ecx
008B9004 mov      ecx, dword ptr [ebp - 0x16c]
008B900A call     0x8b8f30
008B900F test     eax, eax
008B9011 jne      0x8b9015
008B9013 jmp      0x8b9044
008B9015 mov      ecx, dword ptr [0x17c86fc]
008B901B call     0x402aa0
008B9020 mov      dword ptr [ebp - 0xc], eax
008B9023 mov      dword ptr [ebp - 8], edx
008B9026 mov      edx, dword ptr [ebp - 0x168]
008B902C mov      dword ptr [ebp - 4], edx
008B902F push     0xc
008B9031 lea      eax, [ebp - 0xc]
008B9034 push     eax
008B9035 push     0
008B9037 push     0x53c
008B903C call     0xa3c950
008B9041 add      esp, 0x10
008B9044 mov      ecx, dword ptr [ebp - 0x10]
008B9047 xor      ecx, ebp
008B9049 call     0x6634fb
008B904E mov      esp, ebp
008B9050 pop      ebp
008B9051 ret      4

; Function 0x89ee80
0089EE80 push     ebp
0089EE81 mov      ebp, esp
0089EE83 sub      esp, 0x1c
0089EE86 mov      dword ptr [ebp - 0x1c], ecx
0089EE89 push     0xc
0089EE8B push     0
0089EE8D lea      eax, [ebp - 0x18]
0089EE90 push     eax
0089EE91 call     0x666960
0089EE96 add      esp, 0xc
0089EE99 mov      ecx, dword ptr [0x17c86fc]
0089EE9F call     0x402aa0
0089EEA4 mov      dword ptr [ebp - 0x18], eax
0089EEA7 mov      dword ptr [ebp - 0x14], edx
0089EEAA mov      ecx, dword ptr [ebp - 0x1c]
0089EEAD mov      edx, dword ptr [ecx + 0x580]
0089EEB3 mov      dword ptr [ebp - 0x10], edx
0089EEB6 push     0xc
0089EEB8 lea      eax, [ebp - 0x18]
0089EEBB push     eax
0089EEBC push     0
0089EEBE push     0x87b
0089EEC3 call     0xa3c950
0089EEC8 add      esp, 0x10
0089EECB mov      ecx, dword ptr [0x17c86fc]
0089EED1 call     0x402aa0
0089EED6 mov      dword ptr [ebp - 0xc], eax
0089EED9 mov      dword ptr [ebp - 8], edx
0089EEDC mov      ecx, dword ptr [ebp - 0x1c]
0089EEDF mov      edx, dword ptr [ecx + 0x578]
0089EEE5 mov      dword ptr [ebp - 4], edx
0089EEE8 push     0xc
0089EEEA lea      eax, [ebp - 0xc]
0089EEED push     eax
0089EEEE push     0
0089EEF0 push     0x53c
0089EEF5 call     0xa3c950
0089EEFA add      esp, 0x10
0089EEFD mov      ecx, dword ptr [ebp - 0x1c]
0089EF00 mov      edx, dword ptr [ecx]
0089EF02 mov      ecx, dword ptr [ebp - 0x1c]
0089EF05 mov      eax, dword ptr [edx + 0x11c]
0089EF0B call     eax
0089EF0D mov      esp, ebp
0089EF0F pop      ebp
0089EF10 ret

; Function 0x826c30
00826C30 push     ebp
00826C31 mov      ebp, esp
00826C33 push     -1
00826C35 push     0xadb9db
00826C3A mov      eax, dword ptr fs:[0]
00826C40 push     eax
00826C41 sub      esp, 0x2c
00826C44 mov      eax, dword ptr [0xc7b480]
00826C49 xor      eax, ebp
00826C4B push     eax
00826C4C lea      eax, [ebp - 0xc]
00826C4F mov      dword ptr fs:[0], eax
00826C55 mov      dword ptr [ebp - 0x38], ecx
00826C58 mov      eax, dword ptr [ebp + 8]
00826C5B mov      dword ptr [ebp - 0x30], eax
00826C5E mov      eax, dword ptr [ebp + 0xc]
00826C61 xor      edx, edx
00826C63 mov      ecx, 0x153
00826C68 div      ecx
00826C6A mov      dword ptr [ebp - 0x2c], eax
00826C6D lea      ecx, [ebp - 0x28]
00826C70 call     0x504d60
00826C75 mov      dword ptr [ebp - 4], 0
00826C7C mov      dword ptr [ebp - 0x34], 0
00826C83 jmp      0x826c99
00826C85 mov      edx, dword ptr [ebp - 0x34]
00826C88 add      edx, 1
00826C8B mov      dword ptr [ebp - 0x34], edx
00826C8E mov      eax, dword ptr [ebp - 0x30]
00826C91 add      eax, 0x153
00826C96 mov      dword ptr [ebp - 0x30], eax
00826C99 mov      ecx, dword ptr [ebp - 0x34]
00826C9C cmp      ecx, dword ptr [ebp - 0x2c]
00826C9F jge      0x826caf
00826CA1 mov      edx, dword ptr [ebp - 0x30]
00826CA4 push     edx
00826CA5 lea      ecx, [ebp - 0x28]
00826CA8 call     0x548fa0
00826CAD jmp      0x826c85
00826CAF lea      eax, [ebp - 0x28]
00826CB2 push     eax
00826CB3 call     0x4e76b0
00826CB8 mov      ecx, eax
00826CBA call     0x8bcc80
00826CBF mov      ecx, dword ptr [ebp - 0x38]
00826CC2 mov      edx, dword ptr [ecx]
00826CC4 mov      ecx, dword ptr [ebp - 0x38]
00826CC7 mov      eax, dword ptr [edx + 0x10]
00826CCA call     eax
00826CCC mov      dword ptr [ebp - 4], 0xffffffff
00826CD3 lea      ecx, [ebp - 0x28]
00826CD6 call     0x5327c0
00826CDB mov      ecx, dword ptr [ebp - 0xc]
00826CDE mov      dword ptr fs:[0], ecx
00826CE5 pop      ecx
00826CE6 mov      esp, ebp
00826CE8 pop      ebp
00826CE9 ret      8

; Function 0x826ab0
00826AB0 push     ebp
00826AB1 mov      ebp, esp
00826AB3 sub      esp, 8
00826AB6 mov      dword ptr [ebp - 8], ecx
00826AB9 mov      eax, dword ptr [ebp + 8]
00826ABC mov      dword ptr [ebp - 4], eax
00826ABF mov      ecx, dword ptr [ebp - 4]
00826AC2 push     ecx
00826AC3 call     0x4e76b0
00826AC8 mov      ecx, eax
00826ACA call     0x8ba5d0
00826ACF call     0x504bf0
00826AD4 mov      ecx, eax
00826AD6 call     0x89ee10
00826ADB mov      edx, dword ptr [ebp - 4]
00826ADE mov      eax, dword ptr [eax + 0x14b]
00826AE4 cmp      eax, dword ptr [edx + 8]
00826AE7 jne      0x826afb
00826AE9 mov      ecx, dword ptr [ebp - 4]
00826AEC push     ecx
00826AED call     0x504bf0
00826AF2 mov      ecx, eax
00826AF4 call     0x89f380
00826AF9 jmp      0x826b25
00826AFB call     0x504c80
00826B00 mov      ecx, eax
00826B02 call     0x89d800
00826B07 mov      edx, dword ptr [ebp - 4]
00826B0A mov      eax, dword ptr [eax + 0x14b]
00826B10 cmp      eax, dword ptr [edx + 8]
00826B13 jne      0x826b25
00826B15 mov      ecx, dword ptr [ebp - 4]
00826B18 push     ecx
00826B19 call     0x504c80
00826B1E mov      ecx, eax
00826B20 call     0x89e770
00826B25 mov      esp, ebp
00826B27 pop      ebp
00826B28 ret      8

; Function 0x826cf0
00826CF0 push     ebp
00826CF1 mov      ebp, esp
00826CF3 sub      esp, 8
00826CF6 mov      dword ptr [ebp - 8], ecx
00826CF9 mov      eax, dword ptr [ebp + 8]
00826CFC mov      dword ptr [ebp - 4], eax
00826CFF mov      ecx, dword ptr [ebp - 4]
00826D02 movzx    edx, byte ptr [ecx]
00826D05 test     edx, edx
00826D07 je       0x826d29
00826D09 mov      eax, dword ptr [ebp - 4]
00826D0C mov      ecx, dword ptr [eax + 1]
00826D0F push     ecx
00826D10 call     0x4e76b0
00826D15 mov      ecx, eax
00826D17 call     0x8bcdc0
00826D1C mov      edx, dword ptr [ebp - 8]
00826D1F mov      eax, dword ptr [edx]
00826D21 mov      ecx, dword ptr [ebp - 8]
00826D24 mov      edx, dword ptr [eax + 0x14]
00826D27 call     edx
00826D29 mov      esp, ebp
00826D2B pop      ebp
00826D2C ret      8

; Function 0x8269c0
008269C0 push     ebp
008269C1 mov      ebp, esp
008269C3 push     -1
008269C5 push     0xadad8e
008269CA mov      eax, dword ptr fs:[0]
008269D0 push     eax
008269D1 sub      esp, 0x74
008269D4 mov      eax, dword ptr [0xc7b480]
008269D9 xor      eax, ebp
008269DB push     eax
008269DC lea      eax, [ebp - 0xc]
008269DF mov      dword ptr fs:[0], eax
008269E5 mov      dword ptr [ebp - 0x80], ecx
008269E8 mov      eax, dword ptr [ebp + 8]
008269EB mov      dword ptr [ebp - 0x2c], eax
008269EE mov      eax, dword ptr [ebp + 0xc]
008269F1 xor      edx, edx
008269F3 mov      ecx, 0x7c
008269F8 div      ecx
008269FA mov      dword ptr [ebp - 0x30], eax
008269FD lea      ecx, [ebp - 0x28]
00826A00 call     0x504de0
00826A05 mov      dword ptr [ebp - 4], 0
00826A0C mov      dword ptr [ebp - 0x34], 0
00826A13 jmp      0x826a27
00826A15 mov      edx, dword ptr [ebp - 0x34]
00826A18 add      edx, 1
00826A1B mov      dword ptr [ebp - 0x34], edx
00826A1E mov      eax, dword ptr [ebp - 0x2c]
00826A21 add      eax, 0x7c
00826A24 mov      dword ptr [ebp - 0x2c], eax
00826A27 mov      ecx, dword ptr [ebp - 0x34]
00826A2A cmp      ecx, dword ptr [ebp - 0x30]
00826A2D jge      0x826a6f
00826A2F mov      edx, dword ptr [ebp - 0x2c]
00826A32 mov      eax, dword ptr [edx + 8]
00826A35 push     eax
00826A36 lea      ecx, [ebp - 0x7c]
00826A39 push     ecx
00826A3A mov      ecx, dword ptr [0x17c86fc]
00826A40 call     0x9cd840
00826A45 mov      edx, dword ptr [ebp - 0x2c]
00826A48 mov      eax, dword ptr [edx + 0xc]
00826A4B mov      dword ptr [ebp - 0x69], eax
00826A4E lea      ecx, [ebp - 0x7c]
00826A51 push     ecx
00826A52 mov      edx, dword ptr [ebp - 0x7c]
00826A55 push     edx
00826A56 mov      ecx, dword ptr [0x17c86fc]
00826A5C call     0x9ce660
00826A61 mov      eax, dword ptr [ebp - 0x2c]
00826A64 push     eax
00826A65 lea      ecx, [ebp - 0x28]
00826A68 call     0x548fe0
00826A6D jmp      0x826a15
00826A6F lea      ecx, [ebp - 0x28]
00826A72 push     ecx
00826A73 call     0x4e76b0
00826A78 mov      ecx, eax
00826A7A call     0x8bbc20
00826A7F mov      edx, dword ptr [ebp - 0x80]
00826A82 mov      eax, dword ptr [edx]
00826A84 mov      ecx, dword ptr [ebp - 0x80]
00826A87 mov      edx, dword ptr [eax + 0xc]
00826A8A call     edx
00826A8C mov      dword ptr [ebp - 4], 0xffffffff
00826A93 lea      ecx, [ebp - 0x28]
00826A96 call     0x5327c0
00826A9B mov      ecx, dword ptr [ebp - 0xc]
00826A9E mov      dword ptr fs:[0], ecx
00826AA5 pop      ecx
00826AA6 mov      esp, ebp
00826AA8 pop      ebp
00826AA9 ret      8

; Function 0x8ba5d0
008BA5D0 push     ebp
008BA5D1 mov      ebp, esp
008BA5D3 sub      esp, 0x168
008BA5D9 mov      eax, dword ptr [0xc7b480]
008BA5DE xor      eax, ebp
008BA5E0 mov      dword ptr [ebp - 4], eax
008BA5E3 mov      dword ptr [ebp - 0x168], ecx
008BA5E9 mov      eax, dword ptr [ebp + 8]
008BA5EC mov      ecx, dword ptr [eax + 8]
008BA5EF push     ecx
008BA5F0 mov      ecx, dword ptr [ebp - 0x168]
008BA5F6 call     0x8b90d0
008BA5FB mov      dword ptr [ebp - 0x164], eax
008BA601 cmp      dword ptr [ebp - 0x164], 0
008BA608 jl       0x8ba613
008BA60A cmp      dword ptr [ebp - 0x164], 5
008BA611 jl       0x8ba615
008BA613 jmp      0x8ba66f
008BA615 lea      edx, [ebp - 0x160]
008BA61B push     edx
008BA61C mov      eax, dword ptr [ebp - 0x164]
008BA622 push     eax
008BA623 mov      ecx, dword ptr [ebp - 0x168]
008BA629 call     0x8b8f30
008BA62E test     eax, eax
008BA630 jne      0x8ba634
008BA632 jmp      0x8ba66f
008BA634 mov      ecx, dword ptr [ebp + 8]
008BA637 mov      edx, dword ptr [ecx + 4]
008BA63A mov      dword ptr [ebp - 0x19], edx
008BA63D lea      eax, [ebp - 0x160]
008BA643 push     eax
008BA644 mov      ecx, dword ptr [ebp - 0x164]
008BA64A push     ecx
008BA64B mov      ecx, dword ptr [ebp - 0x168]
008BA651 call     0x8b8ea0
008BA656 lea      edx, [ebp - 0x160]
008BA65C push     edx
008BA65D mov      eax, dword ptr [ebp - 0x164]
008BA663 push     eax
008BA664 mov      ecx, dword ptr [ebp - 0x168]
008BA66A call     0x8b9b80
008BA66F mov      ecx, dword ptr [ebp - 4]
008BA672 xor      ecx, ebp
008BA674 call     0x6634fb
008BA679 mov      esp, ebp
008BA67B pop      ebp
008BA67C ret      4

; Function 0x89f380
0089F380 push     ebp
0089F381 mov      ebp, esp
0089F383 push     -1
0089F385 push     0xad09ab
0089F38A mov      eax, dword ptr fs:[0]
0089F390 push     eax
0089F391 sub      esp, 0x27c
0089F397 mov      eax, dword ptr [0xc7b480]
0089F39C xor      eax, ebp
0089F39E mov      dword ptr [ebp - 0x10], eax
0089F3A1 push     esi
0089F3A2 push     edi
0089F3A3 push     eax
0089F3A4 lea      eax, [ebp - 0xc]
0089F3A7 mov      dword ptr fs:[0], eax
0089F3AD mov      dword ptr [ebp - 0x268], ecx
0089F3B3 mov      esi, dword ptr [ebp + 8]
0089F3B6 mov      edi, dword ptr [ebp - 0x268]
0089F3BC add      edi, 0x578
0089F3C2 mov      ecx, 0x22
0089F3C7 rep movsd dword ptr es:[edi], dword ptr [esi]
0089F3C9 mov      eax, dword ptr [0xb9930c]
0089F3CE push     eax
0089F3CF lea      ecx, [ebp - 0xdc]
0089F3D5 call     0x405650
0089F3DA mov      dword ptr [ebp - 4], 0
0089F3E1 lea      ecx, [ebp - 0xdc]
0089F3E7 push     ecx
0089F3E8 mov      ecx, dword ptr [ebp - 0x268]
0089F3EE call     0x75fbf0
0089F3F3 mov      dword ptr [ebp - 0xb4], eax
0089F3F9 mov      dword ptr [ebp - 4], 0xffffffff
0089F400 lea      ecx, [ebp - 0xdc]
0089F406 call     0x4056d0
0089F40B cmp      dword ptr [ebp - 0xb4], 0
0089F412 je       0x89f474
0089F414 mov      edx, dword ptr [ebp + 8]
0089F417 add      edx, 0xc
0089F41A push     edx
0089F41B lea      eax, [ebp - 0xf8]
0089F421 push     eax
0089F422 call     0xa44160
0089F427 add      esp, 8
0089F42A mov      dword ptr [ebp - 0x26c], eax
0089F430 mov      ecx, dword ptr [ebp - 0x26c]
0089F436 mov      dword ptr [ebp - 0x270], ecx
0089F43C mov      dword ptr [ebp - 4], 1
0089F443 push     1
0089F445 mov      edx, dword ptr [ebp - 0x270]
0089F44B push     edx
0089F44C mov      eax, dword ptr [ebp - 0xb4]
0089F452 mov      edx, dword ptr [eax]
0089F454 mov      ecx, dword ptr [ebp - 0xb4]
0089F45A mov      eax, dword ptr [edx + 0xd4]
0089F460 call     eax
0089F462 mov      dword ptr [ebp - 4], 0xffffffff
0089F469 lea      ecx, [ebp - 0xf8]
0089F46F call     0x4056d0
0089F474 mov      ecx, dword ptr [0xb99310]
0089F47A push     ecx
0089F47B lea      ecx, [ebp - 0x114]
0089F481 call     0x405650
0089F486 mov      dword ptr [ebp - 4], 2
0089F48D lea      edx, [ebp - 0x114]
0089F493 push     edx
0089F494 mov      ecx, dword ptr [ebp - 0x268]
0089F49A call     0x75fbf0
0089F49F mov      dword ptr [ebp - 0xb4], eax
0089F4A5 mov      dword ptr [ebp - 4], 0xffffffff
0089F4AC lea      ecx, [ebp - 0x114]
0089F4B2 call     0x4056d0
0089F4B7 cmp      dword ptr [ebp - 0xb4], 0
0089F4BE je       0x89f520
0089F4C0 mov      eax, dword ptr [ebp + 8]
0089F4C3 add      eax, 0x10
0089F4C6 push     eax
0089F4C7 lea      ecx, [ebp - 0x130]
0089F4CD push     ecx
0089F4CE call     0xa44160
0089F4D3 add      esp, 8
0089F4D6 mov      dword ptr [ebp - 0x274], eax
0089F4DC mov      edx, dword ptr [ebp - 0x274]
0089F4E2 mov      dword ptr [ebp - 0x278], edx
0089F4E8 mov      dword ptr [ebp - 4], 3
0089F4EF push     1
0089F4F1 mov      eax, dword ptr [ebp - 0x278]
0089F4F7 push     eax
0089F4F8 mov      ecx, dword ptr [ebp - 0xb4]
0089F4FE mov      edx, dword ptr [ecx]
0089F500 mov      ecx, dword ptr [ebp - 0xb4]
0089F506 mov      eax, dword ptr [edx + 0xd4]
0089F50C call     eax
0089F50E mov      dword ptr [ebp - 4], 0xffffffff
0089F515 lea      ecx, [ebp - 0x130]
0089F51B call     0x4056d0
0089F520 lea      ecx, [ebp - 0xac]
0089F526 call     0x4c4330
0089F52B mov      dword ptr [ebp - 4], 4
0089F532 mov      ecx, dword ptr [0xb99314]
0089F538 push     ecx
0089F539 lea      ecx, [ebp - 0x14c]
0089F53F call     0x405650
0089F544 mov      byte ptr [ebp - 4], 5
0089F548 lea      edx, [ebp - 0x14c]
0089F54E push     edx
0089F54F mov      ecx, dword ptr [ebp - 0x268]
0089F555 call     0x75fbf0
0089F55A mov      dword ptr [ebp - 0xb8], eax
0089F560 mov      byte ptr [ebp - 4], 4
0089F564 lea      ecx, [ebp - 0x14c]
0089F56A call     0x4056d0
0089F56F mov      eax, dword ptr [ebp + 8]
0089F572 mov      ecx, dword ptr [eax + 0x21]
0089F575 push     ecx
0089F576 call     0xa21b30
0089F57B mov      ecx, eax
0089F57D call     0xa1e560
0089F582 mov      dword ptr [ebp - 0xb0], eax
0089F588 cmp      dword ptr [ebp - 0xb0], 0
0089F58F je       0x89f5e3
0089F591 cmp      dword ptr [ebp - 0xb8], 0
0089F598 je       0x89f5e1
0089F59A mov      ecx, dword ptr [ebp - 0xb0]
0089F5A0 add      ecx, 0x44
0089F5A3 call     0x406410
0089F5A8 push     eax
0089F5A9 lea      ecx, [ebp - 0x168]
0089F5AF call     0x405650
0089F5B4 mov      byte ptr [ebp - 4], 6
0089F5B8 lea      edx, [ebp - 0x168]
0089F5BE push     edx
0089F5BF mov      eax, dword ptr [ebp - 0xb8]
0089F5C5 mov      edx, dword ptr [eax]
0089F5C7 mov      ecx, dword ptr [ebp - 0xb8]
0089F5CD mov      eax, dword ptr [edx + 0x28]
0089F5D0 call     eax
0089F5D2 mov      byte ptr [ebp - 4], 4
0089F5D6 lea      ecx, [ebp - 0x168]
0089F5DC call     0x4056d0
0089F5E1 jmp      0x89f629
0089F5E3 cmp      dword ptr [ebp - 0xb8], 0
0089F5EA je       0x89f629
0089F5EC push     0xb96699
0089F5F1 lea      ecx, [ebp - 0x184]
0089F5F7 call     0x405650
0089F5FC mov      byte ptr [ebp - 4], 7
0089F600 lea      ecx, [ebp - 0x184]
0089F606 push     ecx
0089F607 mov      edx, dword ptr [ebp - 0xb8]
0089F60D mov      eax, dword ptr [edx]
0089F60F mov      ecx, dword ptr [ebp - 0xb8]
0089F615 mov      edx, dword ptr [eax + 0x28]
0089F618 call     edx
0089F61A mov      byte ptr [ebp - 4], 4
0089F61E lea      ecx, [ebp - 0x184]
0089F624 call     0x4056d0
0089F629 mov      eax, dword ptr [0xb99304]
0089F62E push     eax
0089F62F lea      ecx, [ebp - 0x1a0]
0089F635 call     0x405650
0089F63A mov      byte ptr [ebp - 4], 8
0089F63E lea      ecx, [ebp - 0x1a0]
0089F644 push     ecx
0089F645 mov      ecx, dword ptr [ebp - 0x268]
0089F64B call     0x75fbf0
0089F650 mov      dword ptr [ebp - 0xb4], eax
0089F656 mov      byte ptr [ebp - 4], 4
0089F65A lea      ecx, [ebp - 0x1a0]
0089F660 call     0x4056d0
0089F665 cmp      dword ptr [ebp - 0xb4], 0
0089F66C je       0x89f6b7
0089F66E lea      ecx, [ebp - 0xa4]
0089F674 call     0x406410
0089F679 push     eax
0089F67A lea      ecx, [ebp - 0x1bc]
0089F680 call     0x405650
0089F685 mov      byte ptr [ebp - 4], 9
0089F689 push     1
0089F68B lea      edx, [ebp - 0x1bc]
0089F691 push     edx
0089F692 mov      eax, dword ptr [ebp - 0xb4]
0089F698 mov      edx, dword ptr [eax]
0089F69A mov      ecx, dword ptr [ebp - 0xb4]
0089F6A0 mov      eax, dword ptr [edx + 0xd4]
0089F6A6 call     eax
0089F6A8 mov      byte ptr [ebp - 4], 4
0089F6AC lea      ecx, [ebp - 0x1bc]
0089F6B2 call     0x4056d0
0089F6B7 mov      ecx, dword ptr [0xb9931c]
0089F6BD push     ecx
0089F6BE lea      ecx, [ebp - 0x1d8]
0089F6C4 call     0x405650
0089F6C9 mov      byte ptr [ebp - 4], 0xa
0089F6CD lea      edx, [ebp - 0x1d8]
0089F6D3 push     edx
0089F6D4 mov      ecx, dword ptr [ebp - 0x268]
0089F6DA call     0x75fbf0
0089F6DF mov      dword ptr [ebp - 0xb4], eax
0089F6E5 mov      byte ptr [ebp - 4], 4
0089F6E9 lea      ecx, [ebp - 0x1d8]
0089F6EF call     0x4056d0
0089F6F4 cmp      dword ptr [ebp - 0xb4], 0
0089F6FB je       0x89f7d1
0089F701 mov      eax, dword ptr [ebp + 8]
0089F704 mov      ecx, dword ptr [eax + 0x36]
0089F707 push     ecx
0089F708 mov      edx, dword ptr [ebp + 8]
0089F70B mov      eax, dword ptr [edx + 0x32]
0089F70E push     eax
0089F70F lea      ecx, [ebp - 0xbc]
0089F715 push     ecx
0089F716 call     0xa1edf0
0089F71B add      esp, 0xc
0089F71E mov      byte ptr [ebp - 4], 0xb
0089F722 mov      edx, dword ptr [ebp + 8]
0089F725 mov      eax, dword ptr [edx + 0x36]
0089F728 push     eax
0089F729 mov      ecx, dword ptr [ebp + 8]
0089F72C mov      edx, dword ptr [ecx + 0x32]
0089F72F push     edx
0089F730 call     0xa1e220
0089F735 add      esp, 8
0089F738 mov      dword ptr [ebp - 0xc0], eax
0089F73E mov      eax, dword ptr [ebp + 8]
0089F741 movzx    ecx, byte ptr [eax + 0x20]
0089F745 cmp      ecx, 0x50
0089F748 jne      0x89f767
0089F74A lea      edx, [ebp - 0xc0]
0089F750 push     edx
0089F751 lea      eax, [ebp - 0xbc]
0089F757 push     eax
0089F758 mov      ecx, dword ptr [ebp + 8]
0089F75B mov      edx, dword ptr [ecx + 0x25]
0089F75E push     edx
0089F75F call     0xa20d30
0089F764 add      esp, 0xc
0089F767 mov      eax, dword ptr [ebp - 0xc0]
0089F76D push     eax
0089F76E mov      ecx, dword ptr [ebp - 0xb4]
0089F774 call     0x4b2350
0089F779 lea      ecx, [ebp - 0xbc]
0089F77F call     0x406410
0089F784 push     eax
0089F785 lea      ecx, [ebp - 0x1f4]
0089F78B call     0x405650
0089F790 mov      byte ptr [ebp - 4], 0xc
0089F794 push     1
0089F796 lea      ecx, [ebp - 0x1f4]
0089F79C push     ecx
0089F79D mov      edx, dword ptr [ebp - 0xb4]
0089F7A3 mov      eax, dword ptr [edx]
0089F7A5 mov      ecx, dword ptr [ebp - 0xb4]
0089F7AB mov      edx, dword ptr [eax + 0xd4]
0089F7B1 call     edx
0089F7B3 mov      byte ptr [ebp - 4], 0xb
0089F7B7 lea      ecx, [ebp - 0x1f4]
0089F7BD call     0x4056d0
0089F7C2 mov      byte ptr [ebp - 4], 4
0089F7C6 lea      ecx, [ebp - 0xbc]
0089F7CC call     0x406050
0089F7D1 mov      eax, dword ptr [0xb99320]
0089F7D6 push     eax
0089F7D7 lea      ecx, [ebp - 0x210]
0089F7DD call     0x405650
0089F7E2 mov      byte ptr [ebp - 4], 0xd
0089F7E6 lea      ecx, [ebp - 0x210]
0089F7EC push     ecx
0089F7ED mov      ecx, dword ptr [ebp - 0x268]
0089F7F3 call     0x75fbf0
0089F7F8 mov      dword ptr [ebp - 0xb4], eax
0089F7FE mov      byte ptr [ebp - 4], 4
0089F802 lea      ecx, [ebp - 0x210]
0089F808 call     0x4056d0
0089F80D cmp      dword ptr [ebp - 0xb4], 0
0089F814 je       0x89f870
0089F816 mov      edx, dword ptr [ebp + 8]
0089F819 add      edx, 0x14
0089F81C push     edx
0089F81D lea      eax, [ebp - 0x22c]
0089F823 push     eax
0089F824 call     0xa44160
0089F829 add      esp, 8
0089F82C mov      dword ptr [ebp - 0x27c], eax
0089F832 mov      ecx, dword ptr [ebp - 0x27c]
0089F838 mov      dword ptr [ebp - 0x280], ecx
0089F83E mov      byte ptr [ebp - 4], 0xe
0089F842 push     1
0089F844 mov      edx, dword ptr [ebp - 0x280]
0089F84A push     edx
0089F84B mov      eax, dword ptr [ebp - 0xb4]
0089F851 mov      edx, dword ptr [eax]
0089F853 mov      ecx, dword ptr [ebp - 0xb4]
0089F859 mov      eax, dword ptr [edx + 0xd4]
0089F85F call     eax
0089F861 mov      byte ptr [ebp - 4], 4
0089F865 lea      ecx, [ebp - 0x22c]
0089F86B call     0x4056d0
0089F870 mov      ecx, dword ptr [0xb99324]
0089F876 push     ecx
0089F877 lea      ecx, [ebp - 0x248]
0089F87D call     0x405650
0089F882 mov      byte ptr [ebp - 4], 0xf
0089F886 lea      edx, [ebp - 0x248]
0089F88C push     edx
0089F88D mov      ecx, dword ptr [ebp - 0x268]
0089F893 call     0x75fbf0
0089F898 mov      dword ptr [ebp - 0xb4], eax
0089F89E mov      byte ptr [ebp - 4], 4
0089F8A2 lea      ecx, [ebp - 0x248]
0089F8A8 call     0x4056d0
0089F8AD cmp      dword ptr [ebp - 0xb4], 0
0089F8B4 je       0x89f910
0089F8B6 mov      eax, dword ptr [ebp + 8]
0089F8B9 add      eax, 0x18
0089F8BC push     eax
0089F8BD lea      ecx, [ebp - 0x264]
0089F8C3 push     ecx
0089F8C4 call     0xa44160
0089F8C9 add      esp, 8
0089F8CC mov      dword ptr [ebp - 0x284], eax
0089F8D2 mov      edx, dword ptr [ebp - 0x284]
0089F8D8 mov      dword ptr [ebp - 0x288], edx
0089F8DE mov      byte ptr [ebp - 4], 0x10
0089F8E2 push     1
0089F8E4 mov      eax, dword ptr [ebp - 0x288]
0089F8EA push     eax
0089F8EB mov      ecx, dword ptr [ebp - 0xb4]
0089F8F1 mov      edx, dword ptr [ecx]
0089F8F3 mov      ecx, dword ptr [ebp - 0xb4]
0089F8F9 mov      eax, dword ptr [edx + 0xd4]
0089F8FF call     eax
0089F901 mov      byte ptr [ebp - 4], 4
0089F905 lea      ecx, [ebp - 0x264]
0089F90B call     0x4056d0
0089F910 mov      dword ptr [ebp - 4], 0xffffffff
0089F917 lea      ecx, [ebp - 0xac]
0089F91D call     0x4c4370
0089F922 mov      ecx, dword ptr [ebp - 0xc]
0089F925 mov      dword ptr fs:[0], ecx
0089F92C pop      ecx
0089F92D pop      edi
0089F92E pop      esi
0089F92F mov      ecx, dword ptr [ebp - 0x10]
0089F932 xor      ecx, ebp
0089F934 call     0x6634fb
0089F939 mov      esp, ebp
0089F93B pop      ebp
0089F93C ret      4

; Function 0x8bcc80
008BCC80 push     ebp
008BCC81 mov      ebp, esp
008BCC83 sub      esp, 0x40
008BCC86 mov      dword ptr [ebp - 0x3c], ecx
008BCC89 mov      ecx, dword ptr [ebp - 0x3c]
008BCC8C add      ecx, 0x5dc
008BCC92 call     0x536e70
008BCC97 lea      eax, [ebp - 8]
008BCC9A push     eax
008BCC9B mov      ecx, dword ptr [ebp - 0x3c]
008BCC9E add      ecx, 0x5dc
008BCCA4 call     0x561740
008BCCA9 mov      ecx, dword ptr [eax + 4]
008BCCAC push     ecx
008BCCAD mov      edx, dword ptr [eax]
008BCCAF push     edx
008BCCB0 mov      eax, dword ptr [ebp - 0x3c]
008BCCB3 add      eax, 0x5dc
008BCCB8 push     eax
008BCCB9 lea      ecx, [ebp - 0x14]
008BCCBC push     ecx
008BCCBD call     0x419580
008BCCC2 add      esp, 4
008BCCC5 mov      edx, esp
008BCCC7 mov      ecx, dword ptr [eax]
008BCCC9 mov      dword ptr [edx], ecx
008BCCCB mov      ecx, dword ptr [eax + 4]
008BCCCE mov      dword ptr [edx + 4], ecx
008BCCD1 mov      eax, dword ptr [eax + 8]
008BCCD4 mov      dword ptr [edx + 8], eax
008BCCD7 lea      ecx, [ebp - 0x1c]
008BCCDA push     ecx
008BCCDB mov      ecx, dword ptr [ebp + 8]
008BCCDE call     0x504e60
008BCCE3 mov      edx, dword ptr [eax + 4]
008BCCE6 push     edx
008BCCE7 mov      eax, dword ptr [eax]
008BCCE9 push     eax
008BCCEA lea      ecx, [ebp - 0x24]
008BCCED push     ecx
008BCCEE mov      ecx, dword ptr [ebp + 8]
008BCCF1 call     0x561ea0
008BCCF6 mov      edx, dword ptr [eax + 4]
008BCCF9 push     edx
008BCCFA mov      eax, dword ptr [eax]
008BCCFC push     eax
008BCCFD lea      ecx, [ebp - 0x30]
008BCD00 push     ecx
008BCD01 call     0x505350
008BCD06 add      esp, 0x20
008BCD09 mov      ecx, dword ptr [ebp - 0x3c]
008BCD0C add      ecx, 0x5dc
008BCD12 call     0x4f9670
008BCD17 add      eax, 4
008BCD1A xor      edx, edx
008BCD1C mov      ecx, 5
008BCD21 div      ecx
008BCD23 test     eax, eax
008BCD25 jne      0x8bcd30
008BCD27 mov      dword ptr [ebp - 0x40], 1
008BCD2E jmp      0x8bcd4d
008BCD30 mov      ecx, dword ptr [ebp - 0x3c]
008BCD33 add      ecx, 0x5dc
008BCD39 call     0x4f9670
008BCD3E add      eax, 4
008BCD41 xor      edx, edx
008BCD43 mov      ecx, 5
008BCD48 div      ecx
008BCD4A mov      dword ptr [ebp - 0x40], eax
008BCD4D mov      edx, dword ptr [ebp - 0x3c]
008BCD50 mov      eax, dword ptr [ebp - 0x40]
008BCD53 mov      dword ptr [edx + 0x604], eax
008BCD59 mov      ecx, dword ptr [ebp - 0x3c]
008BCD5C mov      edx, dword ptr [ebp - 0x3c]
008BCD5F mov      eax, dword ptr [ecx + 0x600]
008BCD65 cmp      eax, dword ptr [edx + 0x604]
008BCD6B jle      0x8bcd7f
008BCD6D mov      ecx, dword ptr [ebp - 0x3c]
008BCD70 mov      edx, dword ptr [ebp - 0x3c]
008BCD73 mov      eax, dword ptr [edx + 0x604]
008BCD79 mov      dword ptr [ecx + 0x600], eax
008BCD7F lea      ecx, [ebp - 0x38]
008BCD82 push     ecx
008BCD83 mov      ecx, dword ptr [ebp - 0x3c]
008BCD86 call     0x8b9060
008BCD8B mov      edx, dword ptr [eax]
008BCD8D mov      eax, dword ptr [eax + 4]
008BCD90 mov      ecx, dword ptr [ebp - 0x3c]
008BCD93 mov      dword ptr [ecx + 0x5d4], edx
008BCD99 mov      dword ptr [ecx + 0x5d8], eax
008BCD9F mov      ecx, dword ptr [ebp - 0x3c]
008BCDA2 call     0x8ba8a0
008BCDA7 mov      ecx, dword ptr [ebp - 0x3c]
008BCDAA call     0x8bc790
008BCDAF mov      esp, ebp
008BCDB1 pop      ebp
008BCDB2 ret      4

; Function 0x89efb0
0089EFB0 push     ebp
0089EFB1 mov      ebp, esp
0089EFB3 push     -1
0089EFB5 push     0xab84a5
0089EFBA mov      eax, dword ptr fs:[0]
0089EFC0 push     eax
0089EFC1 sub      esp, 0xf0
0089EFC7 mov      eax, dword ptr [0xc7b480]
0089EFCC xor      eax, ebp
0089EFCE push     eax
0089EFCF lea      eax, [ebp - 0xc]
0089EFD2 mov      dword ptr fs:[0], eax
0089EFD8 mov      dword ptr [ebp - 0xfc], ecx
0089EFDE mov      eax, dword ptr [0xb992f8]
0089EFE3 push     eax
0089EFE4 lea      ecx, [ebp - 0x34]
0089EFE7 call     0x405650
0089EFEC mov      dword ptr [ebp - 4], 0
0089EFF3 lea      ecx, [ebp - 0x34]
0089EFF6 push     ecx
0089EFF7 mov      ecx, dword ptr [ebp - 0xfc]
0089EFFD call     0x75fbf0
0089F002 mov      dword ptr [ebp - 0x14], eax
0089F005 mov      dword ptr [ebp - 4], 0xffffffff
0089F00C lea      ecx, [ebp - 0x34]
0089F00F call     0x4056d0
0089F014 cmp      dword ptr [ebp - 0x14], 0
0089F018 je       0x89f055
0089F01A mov      edx, dword ptr [ebp + 8]
0089F01D add      edx, 4
0089F020 push     edx
0089F021 lea      ecx, [ebp - 0x50]
0089F024 call     0x405650
0089F029 mov      dword ptr [ebp - 4], 1
0089F030 push     1
0089F032 lea      eax, [ebp - 0x50]
0089F035 push     eax
0089F036 mov      ecx, dword ptr [ebp - 0x14]
0089F039 mov      edx, dword ptr [ecx]
0089F03B mov      ecx, dword ptr [ebp - 0x14]
0089F03E mov      eax, dword ptr [edx + 0xd4]
0089F044 call     eax
0089F046 mov      dword ptr [ebp - 4], 0xffffffff
0089F04D lea      ecx, [ebp - 0x50]
0089F050 call     0x4056d0
0089F055 mov      ecx, dword ptr [0xb992fc]
0089F05B push     ecx
0089F05C lea      ecx, [ebp - 0x6c]
0089F05F call     0x405650
0089F064 mov      dword ptr [ebp - 4], 2
0089F06B lea      edx, [ebp - 0x6c]
0089F06E push     edx
0089F06F mov      ecx, dword ptr [ebp - 0xfc]
0089F075 call     0x75fbf0
0089F07A mov      dword ptr [ebp - 0x14], eax
0089F07D mov      dword ptr [ebp - 4], 0xffffffff
0089F084 lea      ecx, [ebp - 0x6c]
0089F087 call     0x4056d0
0089F08C cmp      dword ptr [ebp - 0x14], 0
0089F090 je       0x89f0d6
0089F092 mov      eax, dword ptr [ebp + 8]
0089F095 add      eax, 0x53
0089F098 push     eax
0089F099 lea      ecx, [ebp - 0x88]
0089F09F call     0x405650
0089F0A4 mov      dword ptr [ebp - 4], 3
0089F0AB push     1
0089F0AD lea      ecx, [ebp - 0x88]
0089F0B3 push     ecx
0089F0B4 mov      edx, dword ptr [ebp - 0x14]
0089F0B7 mov      eax, dword ptr [edx]
0089F0B9 mov      ecx, dword ptr [ebp - 0x14]
0089F0BC mov      edx, dword ptr [eax + 0xd4]
0089F0C2 call     edx
0089F0C4 mov      dword ptr [ebp - 4], 0xffffffff
0089F0CB lea      ecx, [ebp - 0x88]
0089F0D1 call     0x4056d0
0089F0D6 mov      eax, dword ptr [0xb99300]
0089F0DB push     eax
0089F0DC lea      ecx, [ebp - 0xa4]
0089F0E2 call     0x405650
0089F0E7 mov      dword ptr [ebp - 4], 4
0089F0EE lea      ecx, [ebp - 0xa4]
0089F0F4 push     ecx
0089F0F5 mov      ecx, dword ptr [ebp - 0xfc]
0089F0FB call     0x75fbf0
0089F100 mov      dword ptr [ebp - 0x10], eax
0089F103 mov      dword ptr [ebp - 4], 0xffffffff
0089F10A lea      ecx, [ebp - 0xa4]
0089F110 call     0x4056d0
0089F115 cmp      dword ptr [ebp - 0x10], 0
0089F119 je       0x89f12a
0089F11B mov      edx, dword ptr [ebp + 8]
0089F11E add      edx, 0x7e
0089F121 push     edx
0089F122 mov      ecx, dword ptr [ebp - 0x10]
0089F125 call     0x74c640
0089F12A mov      eax, dword ptr [0xb99318]
0089F12F push     eax
0089F130 lea      ecx, [ebp - 0xc0]
0089F136 call     0x405650
0089F13B mov      dword ptr [ebp - 4], 5
0089F142 lea      ecx, [ebp - 0xc0]
0089F148 push     ecx
0089F149 mov      ecx, dword ptr [ebp - 0xfc]
0089F14F call     0x75fbf0
0089F154 mov      dword ptr [ebp - 0x18], eax
0089F157 mov      dword ptr [ebp - 4], 0xffffffff
0089F15E lea      ecx, [ebp - 0xc0]
0089F164 call     0x4056d0
0089F169 cmp      dword ptr [ebp - 0x18], 0
0089F16D je       0x89f1fe
0089F173 mov      edx, dword ptr [ebp + 8]
0089F176 cmp      dword ptr [edx + 0x14b], 0
0089F17D je       0x89f1bf
0089F17F mov      eax, dword ptr [0xb99318]
0089F184 push     eax
0089F185 lea      ecx, [ebp - 0xdc]
0089F18B call     0x405650
0089F190 mov      dword ptr [ebp - 4], 6
0089F197 push     1
0089F199 lea      ecx, [ebp - 0xdc]
0089F19F push     ecx
0089F1A0 mov      ecx, dword ptr [ebp - 0xfc]
0089F1A6 call     0x7611c0
0089F1AB mov      dword ptr [ebp - 4], 0xffffffff
0089F1B2 lea      ecx, [ebp - 0xdc]
0089F1B8 call     0x4056d0
0089F1BD jmp      0x89f1fe
0089F1BF mov      edx, dword ptr [0xb99318]
0089F1C5 push     edx
0089F1C6 lea      ecx, [ebp - 0xf8]
0089F1CC call     0x405650
0089F1D1 mov      dword ptr [ebp - 4], 7
0089F1D8 push     0
0089F1DA lea      eax, [ebp - 0xf8]
0089F1E0 push     eax
0089F1E1 mov      ecx, dword ptr [ebp - 0xfc]
0089F1E7 call     0x7611c0
0089F1EC mov      dword ptr [ebp - 4], 0xffffffff
0089F1F3 lea      ecx, [ebp - 0xf8]
0089F1F9 call     0x4056d0
0089F1FE mov      ecx, dword ptr [ebp - 0xc]
0089F201 mov      dword ptr fs:[0], ecx
0089F208 pop      ecx
0089F209 mov      esp, ebp
0089F20B pop      ebp
0089F20C ret      4

; Function 0x8b9b80
008B9B80 push     ebp
008B9B81 mov      ebp, esp
008B9B83 push     -1
008B9B85 push     0xaad56e
008B9B8A mov      eax, dword ptr fs:[0]
008B9B90 push     eax
008B9B91 sub      esp, 0x1e4
008B9B97 mov      eax, dword ptr [0xc7b480]
008B9B9C xor      eax, ebp
008B9B9E push     eax
008B9B9F lea      eax, [ebp - 0xc]
008B9BA2 mov      dword ptr fs:[0], eax
008B9BA8 mov      dword ptr [ebp - 0x1a0], ecx
008B9BAE mov      dword ptr [ebp - 0x10], 0
008B9BB5 lea      eax, [ebp + 8]
008B9BB8 push     eax
008B9BB9 lea      ecx, [ebp - 0x2c]
008B9BBC push     ecx
008B9BBD call     0xa44160
008B9BC2 add      esp, 8
008B9BC5 mov      dword ptr [ebp - 0x1a4], eax
008B9BCB mov      edx, dword ptr [ebp - 0x1a4]
008B9BD1 mov      dword ptr [ebp - 0x1a8], edx
008B9BD7 mov      dword ptr [ebp - 4], 0
008B9BDE mov      eax, dword ptr [ebp - 0x1a8]
008B9BE4 push     eax
008B9BE5 mov      ecx, dword ptr [0xb99594]
008B9BEB push     ecx
008B9BEC lea      edx, [ebp - 0x48]
008B9BEF push     edx
008B9BF0 call     0x411d70
008B9BF5 add      esp, 0xc
008B9BF8 mov      dword ptr [ebp - 0x1ac], eax
008B9BFE mov      eax, dword ptr [ebp - 0x1ac]
008B9C04 mov      dword ptr [ebp - 0x1b0], eax
008B9C0A mov      byte ptr [ebp - 4], 1
008B9C0E mov      ecx, dword ptr [ebp - 0x1b0]
008B9C14 push     ecx
008B9C15 mov      ecx, dword ptr [ebp - 0x1a0]
008B9C1B call     0x75fbf0
008B9C20 mov      dword ptr [ebp - 0x10], eax
008B9C23 mov      byte ptr [ebp - 4], 0
008B9C27 lea      ecx, [ebp - 0x48]
008B9C2A call     0x4056d0
008B9C2F mov      dword ptr [ebp - 4], 0xffffffff
008B9C36 lea      ecx, [ebp - 0x2c]
008B9C39 call     0x4056d0
008B9C3E cmp      dword ptr [ebp - 0x10], 0
008B9C42 je       0x8b9c7f
008B9C44 mov      edx, dword ptr [ebp + 0xc]
008B9C47 add      edx, 4
008B9C4A push     edx
008B9C4B lea      ecx, [ebp - 0x64]
008B9C4E call     0x405650
008B9C53 mov      dword ptr [ebp - 4], 2
008B9C5A push     1
008B9C5C lea      eax, [ebp - 0x64]
008B9C5F push     eax
008B9C60 mov      ecx, dword ptr [ebp - 0x10]
008B9C63 mov      edx, dword ptr [ecx]
008B9C65 mov      ecx, dword ptr [ebp - 0x10]
008B9C68 mov      eax, dword ptr [edx + 0xd4]
008B9C6E call     eax
008B9C70 mov      dword ptr [ebp - 4], 0xffffffff
008B9C77 lea      ecx, [ebp - 0x64]
008B9C7A call     0x4056d0
008B9C7F lea      ecx, [ebp + 8]
008B9C82 push     ecx
008B9C83 lea      edx, [ebp - 0x80]
008B9C86 push     edx
008B9C87 call     0xa44160
008B9C8C add      esp, 8
008B9C8F mov      dword ptr [ebp - 0x1b4], eax
008B9C95 mov      eax, dword ptr [ebp - 0x1b4]
008B9C9B mov      dword ptr [ebp - 0x1b8], eax
008B9CA1 mov      dword ptr [ebp - 4], 3
008B9CA8 mov      ecx, dword ptr [ebp - 0x1b8]
008B9CAE push     ecx
008B9CAF mov      edx, dword ptr [0xb99598]
008B9CB5 push     edx
008B9CB6 lea      eax, [ebp - 0x9c]
008B9CBC push     eax
008B9CBD call     0x411d70
008B9CC2 add      esp, 0xc
008B9CC5 mov      dword ptr [ebp - 0x1bc], eax
008B9CCB mov      ecx, dword ptr [ebp - 0x1bc]
008B9CD1 mov      dword ptr [ebp - 0x1c0], ecx
008B9CD7 mov      byte ptr [ebp - 4], 4
008B9CDB mov      edx, dword ptr [ebp - 0x1c0]
008B9CE1 push     edx
008B9CE2 mov      ecx, dword ptr [ebp - 0x1a0]
008B9CE8 call     0x75fbf0
008B9CED mov      dword ptr [ebp - 0x10], eax
008B9CF0 mov      byte ptr [ebp - 4], 3
008B9CF4 lea      ecx, [ebp - 0x9c]
008B9CFA call     0x4056d0
008B9CFF mov      dword ptr [ebp - 4], 0xffffffff
008B9D06 lea      ecx, [ebp - 0x80]
008B9D09 call     0x4056d0
008B9D0E cmp      dword ptr [ebp - 0x10], 0
008B9D12 je       0x8b9d58
008B9D14 mov      eax, dword ptr [ebp + 0xc]
008B9D17 add      eax, 0x53
008B9D1A push     eax
008B9D1B lea      ecx, [ebp - 0xb8]
008B9D21 call     0x405650
008B9D26 mov      dword ptr [ebp - 4], 5
008B9D2D push     1
008B9D2F lea      ecx, [ebp - 0xb8]
008B9D35 push     ecx
008B9D36 mov      edx, dword ptr [ebp - 0x10]
008B9D39 mov      eax, dword ptr [edx]
008B9D3B mov      ecx, dword ptr [ebp - 0x10]
008B9D3E mov      edx, dword ptr [eax + 0xd4]
008B9D44 call     edx
008B9D46 mov      dword ptr [ebp - 4], 0xffffffff
008B9D4D lea      ecx, [ebp - 0xb8]
008B9D53 call     0x4056d0
008B9D58 lea      eax, [ebp + 8]
008B9D5B push     eax
008B9D5C lea      ecx, [ebp - 0xd4]
008B9D62 push     ecx
008B9D63 call     0xa44160
008B9D68 add      esp, 8
008B9D6B mov      dword ptr [ebp - 0x1c4], eax
008B9D71 mov      edx, dword ptr [ebp - 0x1c4]
008B9D77 mov      dword ptr [ebp - 0x1c8], edx
008B9D7D mov      dword ptr [ebp - 4], 6
008B9D84 mov      eax, dword ptr [ebp - 0x1c8]
008B9D8A push     eax
008B9D8B mov      ecx, dword ptr [0xb9959c]
008B9D91 push     ecx
008B9D92 lea      edx, [ebp - 0xf0]
008B9D98 push     edx
008B9D99 call     0x411d70
008B9D9E add      esp, 0xc
008B9DA1 mov      dword ptr [ebp - 0x1cc], eax
008B9DA7 mov      eax, dword ptr [ebp - 0x1cc]
008B9DAD mov      dword ptr [ebp - 0x1d0], eax
008B9DB3 mov      byte ptr [ebp - 4], 7
008B9DB7 mov      ecx, dword ptr [ebp - 0x1d0]
008B9DBD push     ecx
008B9DBE mov      ecx, dword ptr [ebp - 0x1a0]
008B9DC4 call     0x75fbf0
008B9DC9 mov      dword ptr [ebp - 0x10], eax
008B9DCC mov      byte ptr [ebp - 4], 6
008B9DD0 lea      ecx, [ebp - 0xf0]
008B9DD6 call     0x4056d0
008B9DDB mov      dword ptr [ebp - 4], 0xffffffff
008B9DE2 lea      ecx, [ebp - 0xd4]
008B9DE8 call     0x4056d0
008B9DED cmp      dword ptr [ebp - 0x10], 0
008B9DF1 je       0x8b9e9e
008B9DF7 mov      edx, dword ptr [ebp + 0xc]
008B9DFA movzx    eax, byte ptr [edx + 0x7d]
008B9DFE mov      dword ptr [ebp - 0xf4], eax
008B9E04 lea      ecx, [ebp - 0xf4]
008B9E0A push     ecx
008B9E0B lea      edx, [ebp - 0x110]
008B9E11 push     edx
008B9E12 call     0xa44160
008B9E17 add      esp, 8
008B9E1A mov      dword ptr [ebp - 0x1d4], eax
008B9E20 mov      eax, dword ptr [ebp - 0x1d4]
008B9E26 mov      dword ptr [ebp - 0x1d8], eax
008B9E2C mov      dword ptr [ebp - 4], 8
008B9E33 push     0xbbc510
008B9E38 mov      ecx, dword ptr [ebp - 0x1d8]
008B9E3E push     ecx
008B9E3F lea      edx, [ebp - 0x12c]
008B9E45 push     edx
008B9E46 call     0x4194f0
008B9E4B add      esp, 0xc
008B9E4E mov      dword ptr [ebp - 0x1dc], eax
008B9E54 mov      eax, dword ptr [ebp - 0x1dc]
008B9E5A mov      dword ptr [ebp - 0x1e0], eax
008B9E60 mov      byte ptr [ebp - 4], 9
008B9E64 push     1
008B9E66 mov      ecx, dword ptr [ebp - 0x1e0]
008B9E6C push     ecx
008B9E6D mov      edx, dword ptr [ebp - 0x10]
008B9E70 mov      eax, dword ptr [edx]
008B9E72 mov      ecx, dword ptr [ebp - 0x10]
008B9E75 mov      edx, dword ptr [eax + 0xd4]
008B9E7B call     edx
008B9E7D mov      byte ptr [ebp - 4], 8
008B9E81 lea      ecx, [ebp - 0x12c]
008B9E87 call     0x4056d0
008B9E8C mov      dword ptr [ebp - 4], 0xffffffff
008B9E93 lea      ecx, [ebp - 0x110]
008B9E99 call     0x4056d0
008B9E9E lea      eax, [ebp + 8]
008B9EA1 push     eax
008B9EA2 lea      ecx, [ebp - 0x148]
008B9EA8 push     ecx
008B9EA9 call     0xa44160
008B9EAE add      esp, 8
008B9EB1 mov      dword ptr [ebp - 0x1e4], eax
008B9EB7 mov      edx, dword ptr [ebp - 0x1e4]
008B9EBD mov      dword ptr [ebp - 0x1e8], edx
008B9EC3 mov      dword ptr [ebp - 4], 0xa
008B9ECA mov      eax, dword ptr [ebp - 0x1e8]
008B9ED0 push     eax
008B9ED1 mov      ecx, dword ptr [0xb995a0]
008B9ED7 push     ecx
008B9ED8 lea      edx, [ebp - 0x164]
008B9EDE push     edx
008B9EDF call     0x411d70
008B9EE4 add      esp, 0xc
008B9EE7 mov      dword ptr [ebp - 0x1ec], eax
008B9EED mov      eax, dword ptr [ebp - 0x1ec]
008B9EF3 mov      dword ptr [ebp - 0x1f0], eax
008B9EF9 mov      byte ptr [ebp - 4], 0xb
008B9EFD mov      ecx, dword ptr [ebp - 0x1f0]
008B9F03 push     ecx
008B9F04 mov      ecx, dword ptr [ebp - 0x1a0]
008B9F0A call     0x75fbf0
008B9F0F mov      dword ptr [ebp - 0x10], eax
008B9F12 mov      byte ptr [ebp - 4], 0xa
008B9F16 lea      ecx, [ebp - 0x164]
008B9F1C call     0x4056d0
008B9F21 mov      dword ptr [ebp - 4], 0xffffffff
008B9F28 lea      ecx, [ebp - 0x148]
008B9F2E call     0x4056d0
008B9F33 cmp      dword ptr [ebp - 0x10], 0
008B9F37 je       0x8b9fdb
008B9F3D mov      edx, dword ptr [ebp + 0xc]
008B9F40 cmp      dword ptr [edx + 0x147], 0
008B9F47 jne      0x8b9f8d
008B9F49 push     0xbbc514
008B9F4E lea      ecx, [ebp - 0x180]
008B9F54 call     0x405650
008B9F59 mov      dword ptr [ebp - 4], 0xc
008B9F60 push     1
008B9F62 lea      eax, [ebp - 0x180]
008B9F68 push     eax
008B9F69 mov      ecx, dword ptr [ebp - 0x10]
008B9F6C mov      edx, dword ptr [ecx]
008B9F6E mov      ecx, dword ptr [ebp - 0x10]
008B9F71 mov      eax, dword ptr [edx + 0xd4]
008B9F77 call     eax
008B9F79 mov      dword ptr [ebp - 4], 0xffffffff
008B9F80 lea      ecx, [ebp - 0x180]
008B9F86 call     0x4056d0
008B9F8B jmp      0x8b9fdb
008B9F8D mov      ecx, dword ptr [ebp + 0xc]
008B9F90 cmp      dword ptr [ecx + 0x147], 1
008B9F97 jne      0x8b9fdb
008B9F99 push     0xbbc518
008B9F9E lea      ecx, [ebp - 0x19c]
008B9FA4 call     0x405650
008B9FA9 mov      dword ptr [ebp - 4], 0xd
008B9FB0 push     1
008B9FB2 lea      edx, [ebp - 0x19c]
008B9FB8 push     edx
008B9FB9 mov      eax, dword ptr [ebp - 0x10]
008B9FBC mov      edx, dword ptr [eax]
008B9FBE mov      ecx, dword ptr [ebp - 0x10]
008B9FC1 mov      eax, dword ptr [edx + 0xd4]
008B9FC7 call     eax
008B9FC9 mov      dword ptr [ebp - 4], 0xffffffff
008B9FD0 lea      ecx, [ebp - 0x19c]
008B9FD6 call     0x4056d0
008B9FDB mov      ecx, dword ptr [ebp - 0xc]
008B9FDE mov      dword ptr fs:[0], ecx
008B9FE5 pop      ecx
008B9FE6 mov      esp, ebp
008B9FE8 pop      ebp
008B9FE9 ret      8

; Function 0x8b8f30
008B8F30 push     ebp
008B8F31 mov      ebp, esp
008B8F33 sub      esp, 0x18
008B8F36 push     esi
008B8F37 push     edi
008B8F38 mov      dword ptr [ebp - 0x18], ecx
008B8F3B mov      dword ptr [ebp - 0xc], 0
008B8F42 push     0x153
008B8F47 push     0
008B8F49 mov      eax, dword ptr [ebp + 0xc]
008B8F4C push     eax
008B8F4D call     0x666960
008B8F52 add      esp, 0xc
008B8F55 mov      ecx, dword ptr [ebp - 0x18]
008B8F58 mov      edx, dword ptr [ecx + 0x5d4]
008B8F5E mov      eax, dword ptr [ecx + 0x5d8]
008B8F64 mov      dword ptr [ebp - 8], edx
008B8F67 mov      dword ptr [ebp - 4], eax
008B8F6A jmp      0x8b8f7d
008B8F6C lea      ecx, [ebp - 8]
008B8F6F call     0x504fb0
008B8F74 mov      ecx, dword ptr [ebp - 0xc]
008B8F77 add      ecx, 1
008B8F7A mov      dword ptr [ebp - 0xc], ecx
008B8F7D lea      edx, [ebp - 0x14]
008B8F80 push     edx
008B8F81 mov      ecx, dword ptr [ebp - 0x18]
008B8F84 add      ecx, 0x5dc
008B8F8A call     0x44a4d0
008B8F8F push     eax
008B8F90 lea      ecx, [ebp - 8]
008B8F93 call     0x44a500
008B8F98 movzx    eax, al
008B8F9B test     eax, eax
008B8F9D je       0x8b8fc7
008B8F9F mov      ecx, dword ptr [ebp - 0xc]
008B8FA2 cmp      ecx, dword ptr [ebp + 8]
008B8FA5 jne      0x8b8fc5
008B8FA7 lea      ecx, [ebp - 8]
008B8FAA call     0x58a020
008B8FAF mov      ecx, 0x54
008B8FB4 mov      esi, eax
008B8FB6 mov      edi, dword ptr [ebp + 0xc]
008B8FB9 rep movsd dword ptr es:[edi], dword ptr [esi]
008B8FBB movsw    word ptr es:[edi], word ptr [esi]
008B8FBD movsb    byte ptr es:[edi], byte ptr [esi]
008B8FBE mov      eax, 1
008B8FC3 jmp      0x8b8fc9
008B8FC5 jmp      0x8b8f6c
008B8FC7 xor      eax, eax
008B8FC9 pop      edi
008B8FCA pop      esi
008B8FCB mov      esp, ebp
008B8FCD pop      ebp

; Function 0x89ee30
0089EE30 push     ebp
0089EE31 mov      ebp, esp
0089EE33 push     ecx
0089EE34 push     esi
0089EE35 push     edi
0089EE36 mov      dword ptr [ebp - 4], ecx
0089EE39 mov      esi, dword ptr [ebp + 8]
0089EE3C mov      edi, dword ptr [ebp - 4]
0089EE3F add      edi, 0x600
0089EE45 mov      ecx, 0x54
0089EE4A rep movsd dword ptr es:[edi], dword ptr [esi]
0089EE4C movsw    word ptr es:[edi], word ptr [esi]
0089EE4E movsb    byte ptr es:[edi], byte ptr [esi]
0089EE4F push     0x88
0089EE54 push     0
0089EE56 mov      eax, dword ptr [ebp - 4]
0089EE59 add      eax, 0x578
0089EE5E push     eax
0089EE5F call     0x666960
0089EE64 add      esp, 0xc
0089EE67 pop      edi
0089EE68 pop      esi
0089EE69 mov      esp, ebp
0089EE6B pop      ebp
0089EE6C ret      4
