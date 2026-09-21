; Current gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 3260 +16/+20 and 3265 operate on entity+0x1B04 (Spawn), not roster Slot.

; FUNCTION 0045C4C0
0045C4C0 push     ebp
0045C4C1 mov      ebp, esp
0045C4C3 push     ecx
0045C4C4 mov      dword ptr [ebp - 4], ecx
0045C4C7 mov      eax, dword ptr [ebp - 4]
0045C4CA mov      eax, dword ptr [eax + 0x1b04]
0045C4D0 mov      esp, ebp
0045C4D2 pop      ebp
0045C4D3 ret

; FUNCTION 00453950
00453950 push     ebp
00453951 mov      ebp, esp
00453953 push     ecx
00453954 mov      dword ptr [ebp - 4], ecx
00453957 mov      eax, dword ptr [ebp - 4]
0045395A mov      ecx, dword ptr [ebp - 4]
0045395D mov      edx, dword ptr [ecx + 0x1b04]
00453963 mov      dword ptr [eax + 0x1b08], edx
00453969 mov      eax, dword ptr [ebp - 4]
0045396C mov      ecx, dword ptr [ebp + 8]
0045396F mov      dword ptr [eax + 0x1b04], ecx
00453975 mov      esp, ebp
00453977 pop      ebp
00453978 ret      4

; FUNCTION 0080D340
0080D340 push     ebp
0080D341 mov      ebp, esp
0080D343 push     -1
0080D345 push     0xadf516
0080D34A mov      eax, dword ptr fs:[0]
0080D350 push     eax
0080D351 sub      esp, 0x44
0080D354 mov      eax, dword ptr [0xc7b480]
0080D359 xor      eax, ebp
0080D35B push     eax
0080D35C lea      eax, [ebp - 0xc]
0080D35F mov      dword ptr fs:[0], eax
0080D365 mov      dword ptr [ebp - 0x50], ecx
0080D368 mov      eax, dword ptr [ebp + 0x18]
0080D36B push     eax
0080D36C mov      ecx, dword ptr [ebp + 0x14]
0080D36F push     ecx
0080D370 mov      edx, dword ptr [ebp + 0x10]
0080D373 push     edx
0080D374 mov      eax, dword ptr [ebp + 0xc]
0080D377 push     eax
0080D378 mov      ecx, dword ptr [ebp + 8]
0080D37B push     ecx
0080D37C mov      ecx, dword ptr [ebp - 0x50]
0080D37F call     0x8083e0
0080D384 cmp      dword ptr [ebp + 8], 0x101
0080D38B jne      0x80d4e7
0080D391 mov      edx, dword ptr [0xb9702c]
0080D397 push     edx
0080D398 lea      ecx, [ebp - 0x48]
0080D39B call     0x405650
0080D3A0 mov      dword ptr [ebp - 4], 0
0080D3A7 lea      eax, [ebp - 0x48]
0080D3AA push     eax
0080D3AB mov      ecx, dword ptr [ebp + 0x10]
0080D3AE push     ecx
0080D3AF mov      ecx, dword ptr [ebp - 0x50]
0080D3B2 call     0x7d25b0
0080D3B7 mov      dword ptr [ebp - 0x10], eax
0080D3BA mov      dword ptr [ebp - 4], 0xffffffff
0080D3C1 lea      ecx, [ebp - 0x48]
0080D3C4 call     0x4056d0
0080D3C9 cmp      dword ptr [ebp - 0x10], -1
0080D3CD je       0x80d4e7
0080D3D3 push     0x18
0080D3D5 push     0
0080D3D7 lea      edx, [ebp - 0x2c]
0080D3DA push     edx
0080D3DB call     0x666960
0080D3E0 add      esp, 0xc
0080D3E3 mov      ecx, dword ptr [0x17c86fc]
0080D3E9 call     0x402aa0
0080D3EE mov      dword ptr [ebp - 0x2c], eax
0080D3F1 mov      dword ptr [ebp - 0x28], edx
0080D3F4 mov      ecx, dword ptr [0x17c8708]
0080D3FA call     0x819120
0080D3FF mov      ecx, eax
0080D401 call     0x45c4c0
0080D406 mov      dword ptr [ebp - 0x1c], eax
0080D409 mov      eax, dword ptr [ebp - 0x10]
0080D40C push     eax
0080D40D mov      ecx, dword ptr [0x17c8708]
0080D413 call     0x818d50
0080D418 mov      dword ptr [ebp - 0x14], eax
0080D41B cmp      dword ptr [ebp - 0x14], 0
0080D41F je       0x80d492
0080D421 mov      ecx, dword ptr [ebp - 0x14]
0080D424 call     0x553a70
0080D429 test     eax, eax
0080D42B je       0x80d46d
0080D42D push     0xbcafd4
0080D432 lea      ecx, [ebp - 0x4c]
0080D435 call     0x405fd0
0080D43A mov      dword ptr [ebp - 4], 1
0080D441 push     0xffff0000
0080D446 lea      ecx, [ebp - 0x4c]
0080D449 push     ecx
0080D44A mov      ecx, dword ptr [0x17c8708]
0080D450 call     0x81b800
0080D455 mov      ecx, eax
0080D457 call     0x7dca00
0080D45C mov      dword ptr [ebp - 4], 0xffffffff
0080D463 lea      ecx, [ebp - 0x4c]
0080D466 call     0x406050
0080D46B jmp      0x80d4e7
0080D46D mov      ecx, dword ptr [ebp - 0x14]
0080D470 call     0x401000
0080D475 mov      dword ptr [ebp - 0x24], eax
0080D478 mov      dword ptr [ebp - 0x20], edx
0080D47B mov      ecx, dword ptr [ebp - 0x14]
0080D47E call     0x45c4c0
0080D483 mov      dword ptr [ebp - 0x18], eax
0080D486 mov      edx, dword ptr [ebp - 0x50]
0080D489 mov      byte ptr [edx + 0x8a8], 1
0080D490 jmp      0x80d4a6
0080D492 mov      dword ptr [ebp - 0x24], 0
0080D499 mov      dword ptr [ebp - 0x20], 0
0080D4A0 mov      eax, dword ptr [ebp - 0x10]
0080D4A3 mov      dword ptr [ebp - 0x18], eax
0080D4A6 mov      ecx, dword ptr [ebp - 0x50]
0080D4A9 add      ecx, 0x8a9
0080D4AF mov      edx, dword ptr [ebp - 0x2c]
0080D4B2 mov      dword ptr [ecx], edx
0080D4B4 mov      eax, dword ptr [ebp - 0x28]
0080D4B7 mov      dword ptr [ecx + 4], eax
0080D4BA mov      edx, dword ptr [ebp - 0x24]
0080D4BD mov      dword ptr [ecx + 8], edx
0080D4C0 mov      eax, dword ptr [ebp - 0x20]
0080D4C3 mov      dword ptr [ecx + 0xc], eax
0080D4C6 mov      edx, dword ptr [ebp - 0x1c]
0080D4C9 mov      dword ptr [ecx + 0x10], edx
0080D4CC mov      eax, dword ptr [ebp - 0x18]
0080D4CF mov      dword ptr [ecx + 0x14], eax
0080D4D2 push     0x18
0080D4D4 lea      ecx, [ebp - 0x2c]
0080D4D7 push     ecx
0080D4D8 push     0
0080D4DA push     0xcbc
0080D4DF call     0xa3c950
0080D4E4 add      esp, 0x10
0080D4E7 mov      ecx, dword ptr [ebp - 0xc]
0080D4EA mov      dword ptr fs:[0], ecx
0080D4F1 pop      ecx
0080D4F2 mov      esp, ebp
0080D4F4 pop      ebp
0080D4F5 ret      0x14

; FUNCTION 00825B30
00825B30 push     ebp
00825B31 mov      ebp, esp
00825B33 push     -1
00825B35 push     0xadb972
00825B3A mov      eax, dword ptr fs:[0]
00825B40 push     eax
00825B41 sub      esp, 0x38
00825B44 mov      eax, dword ptr [0xc7b480]
00825B49 xor      eax, ebp
00825B4B push     eax
00825B4C lea      eax, [ebp - 0xc]
00825B4F mov      dword ptr fs:[0], eax
00825B55 mov      dword ptr [ebp - 0x30], ecx
00825B58 call     0x549290
00825B5D mov      dword ptr [ebp - 0x34], eax
00825B60 mov      eax, dword ptr [ebp - 0x34]
00825B63 mov      edx, dword ptr [eax]
00825B65 mov      ecx, dword ptr [ebp - 0x34]
00825B68 mov      eax, dword ptr [edx + 0x11c]
00825B6E call     eax
00825B70 mov      ecx, dword ptr [ebp + 8]
00825B73 mov      dword ptr [ebp - 0x1c], ecx
00825B76 mov      edx, dword ptr [ebp - 0x1c]
00825B79 mov      eax, dword ptr [edx + 4]
00825B7C push     eax
00825B7D mov      ecx, dword ptr [edx]
00825B7F push     ecx
00825B80 mov      ecx, dword ptr [0x17c8708]
00825B86 call     0x818c70
00825B8B mov      dword ptr [ebp - 0x24], eax
00825B8E mov      ecx, dword ptr [ebp - 0x24]
00825B91 call     0x45c4c0
00825B96 mov      dword ptr [ebp - 0x18], eax
00825B99 mov      ecx, dword ptr [ebp - 0x24]
00825B9C call     0x4058b0
00825BA1 mov      dword ptr [ebp - 0x14], eax
00825BA4 mov      edx, dword ptr [ebp - 0x1c]
00825BA7 mov      eax, dword ptr [edx + 0xc]
00825BAA push     eax
00825BAB mov      ecx, dword ptr [edx + 8]
00825BAE push     ecx
00825BAF mov      ecx, dword ptr [0x17c8708]
00825BB5 call     0x818c70
00825BBA mov      dword ptr [ebp - 0x10], eax
00825BBD cmp      dword ptr [ebp - 0x24], 0
00825BC1 je       0x825be3
00825BC3 mov      ecx, dword ptr [ebp - 0x24]
00825BC6 call     0x44b240
00825BCB movzx    edx, al
00825BCE test     edx, edx
00825BD0 je       0x825be3
00825BD2 push     2
00825BD4 mov      eax, dword ptr [ebp - 0x24]
00825BD7 push     eax
00825BD8 mov      ecx, dword ptr [0x17c8708]
00825BDE call     0x818dd0
00825BE3 cmp      dword ptr [ebp - 0x10], 0
00825BE7 je       0x825c39
00825BE9 mov      ecx, dword ptr [ebp - 0x10]
00825BEC call     0x45c4c0
00825BF1 mov      dword ptr [ebp - 0x20], eax
00825BF4 mov      ecx, dword ptr [ebp - 0x10]
00825BF7 call     0x4058b0
00825BFC mov      dword ptr [ebp - 0x28], eax
00825BFF mov      ecx, dword ptr [ebp - 0x10]
00825C02 call     0x44b240
00825C07 movzx    ecx, al
00825C0A test     ecx, ecx
00825C0C je       0x825c1f
00825C0E push     2
00825C10 mov      edx, dword ptr [ebp - 0x10]
00825C13 push     edx
00825C14 mov      ecx, dword ptr [0x17c8708]
00825C1A call     0x818dd0
00825C1F mov      eax, dword ptr [ebp - 0x18]
00825C22 push     eax
00825C23 mov      ecx, dword ptr [ebp - 0x10]
00825C26 call     0x453950
00825C2B mov      ecx, dword ptr [ebp - 0x14]
00825C2E push     ecx
00825C2F mov      ecx, dword ptr [ebp - 0x10]
00825C32 call     0x9e43f0
00825C37 jmp      0x825c74
00825C39 mov      edx, dword ptr [ebp - 0x1c]
00825C3C mov      eax, dword ptr [edx + 0x14]
00825C3F mov      dword ptr [ebp - 0x20], eax
00825C42 mov      ecx, dword ptr [ebp - 0x24]
00825C45 call     0x4058b0
00825C4A mov      dword ptr [ebp - 0x28], eax
00825C4D mov      ecx, dword ptr [0x17c8708]
00825C53 call     0x81b800
00825C58 mov      dword ptr [ebp - 0x38], eax
00825C5B mov      ecx, dword ptr [ebp - 0x1c]
00825C5E mov      edx, dword ptr [ecx + 0x10]
00825C61 push     edx
00825C62 push     0
00825C64 mov      eax, dword ptr [ebp - 0x38]
00825C67 mov      edx, dword ptr [eax]
00825C69 mov      ecx, dword ptr [ebp - 0x38]
00825C6C mov      eax, dword ptr [edx + 0x1c0]
00825C72 call     eax
00825C74 mov      ecx, dword ptr [ebp - 0x20]
00825C77 push     ecx
00825C78 mov      ecx, dword ptr [ebp - 0x24]
00825C7B call     0x453950
00825C80 mov      edx, dword ptr [ebp - 0x28]
00825C83 push     edx
00825C84 mov      ecx, dword ptr [ebp - 0x24]
00825C87 call     0x9e43f0
00825C8C push     1
00825C8E mov      eax, dword ptr [ebp - 0x24]
00825C91 push     eax
00825C92 mov      ecx, dword ptr [0x17c8708]
00825C98 call     0x819fc0
00825C9D mov      ecx, dword ptr [0x17c8708]
00825CA3 call     0x81b800
00825CA8 mov      dword ptr [ebp - 0x3c], eax
00825CAB mov      ecx, dword ptr [ebp - 0x24]
00825CAE push     ecx
00825CAF mov      ecx, dword ptr [0x17c8708]
00825CB5 call     0x817bc0
00825CBA push     eax
00825CBB mov      edx, dword ptr [ebp - 0x24]
00825CBE push     edx
00825CBF mov      eax, dword ptr [ebp - 0x3c]
00825CC2 mov      edx, dword ptr [eax]
00825CC4 mov      ecx, dword ptr [ebp - 0x3c]
00825CC7 mov      eax, dword ptr [edx + 0x1c0]
00825CCD call     eax
00825CCF cmp      dword ptr [ebp - 0x10], 0
00825CD3 je       0x825d38
00825CD5 push     1
00825CD7 mov      ecx, dword ptr [ebp - 0x10]
00825CDA push     ecx
00825CDB mov      ecx, dword ptr [0x17c8708]
00825CE1 call     0x819fc0
00825CE6 mov      ecx, dword ptr [0x17c8708]
00825CEC call     0x81b800
00825CF1 mov      dword ptr [ebp - 0x40], eax
00825CF4 mov      edx, dword ptr [ebp - 0x10]
00825CF7 push     edx
00825CF8 mov      ecx, dword ptr [0x17c8708]
00825CFE call     0x817bc0
00825D03 push     eax
00825D04 mov      eax, dword ptr [ebp - 0x10]
00825D07 push     eax
00825D08 mov      ecx, dword ptr [ebp - 0x40]
00825D0B mov      edx, dword ptr [ecx]
00825D0D mov      ecx, dword ptr [ebp - 0x40]
00825D10 mov      eax, dword ptr [edx + 0x1c0]
00825D16 call     eax
00825D18 mov      ecx, dword ptr [ebp - 0x10]
00825D1B call     0x44b240
00825D20 movzx    ecx, al
00825D23 test     ecx, ecx
00825D25 je       0x825d38
00825D27 push     2
00825D29 mov      edx, dword ptr [ebp - 0x10]
00825D2C push     edx
00825D2D mov      ecx, dword ptr [0x17c8708]
00825D33 call     0x8194c0
00825D38 cmp      dword ptr [ebp - 0x24], 0
00825D3C je       0x825d5e
00825D3E mov      ecx, dword ptr [ebp - 0x24]
00825D41 call     0x44b240
00825D46 movzx    eax, al
00825D49 test     eax, eax
00825D4B je       0x825d5e
00825D4D push     2
00825D4F mov      ecx, dword ptr [ebp - 0x24]
00825D52 push     ecx
00825D53 mov      ecx, dword ptr [0x17c8708]
00825D59 call     0x8194c0
00825D5E push     0xbcaff4
00825D63 lea      ecx, [ebp - 0x2c]
00825D66 call     0x405fd0
00825D6B mov      dword ptr [ebp - 4], 0
00825D72 push     0xffff0000
00825D77 lea      edx, [ebp - 0x2c]
00825D7A push     edx
00825D7B mov      ecx, dword ptr [0x17c8708]
00825D81 call     0x81b800
00825D86 mov      ecx, eax
00825D88 call     0x7dca00
00825D8D mov      dword ptr [ebp - 4], 0xffffffff
00825D94 lea      ecx, [ebp - 0x2c]
00825D97 call     0x406050
00825D9C mov      ecx, dword ptr [0x17c8708]
00825DA2 call     0x81b800
00825DA7 mov      dword ptr [ebp - 0x44], eax
00825DAA push     1
00825DAC mov      eax, dword ptr [ebp - 0x44]
00825DAF mov      edx, dword ptr [eax]
00825DB1 mov      ecx, dword ptr [ebp - 0x44]
00825DB4 mov      eax, dword ptr [edx + 0x1cc]
00825DBA call     eax
00825DBC mov      ecx, dword ptr [ebp - 0xc]
00825DBF mov      dword ptr fs:[0], ecx
00825DC6 pop      ecx
00825DC7 mov      esp, ebp
00825DC9 pop      ebp
00825DCA ret      8

; FUNCTION 00820160
00820160 push     ebp
00820161 mov      ebp, esp
00820163 sub      esp, 0x28
00820166 mov      dword ptr [ebp - 0x14], ecx
00820169 cmp      dword ptr [ebp + 8], 0
0082016D je       0x820175
0082016F cmp      dword ptr [ebp + 0xc], 0xa
00820173 je       0x82017a
00820175 jmp      0x8202b3
0082017A mov      eax, dword ptr [ebp + 8]
0082017D mov      dword ptr [ebp - 4], eax
00820180 mov      ecx, dword ptr [ebp - 4]
00820183 mov      edx, dword ptr [ecx + 4]
00820186 push     edx
00820187 mov      eax, dword ptr [ecx]
00820189 push     eax
0082018A mov      ecx, dword ptr [0x17c8708]
00820190 call     0x818c70
00820195 mov      dword ptr [ebp - 8], eax
00820198 cmp      dword ptr [ebp - 8], 0
0082019C je       0x8202b3
008201A2 mov      ecx, dword ptr [0x17c8708]
008201A8 call     0x81b800
008201AD mov      dword ptr [ebp - 0x18], eax
008201B0 mov      ecx, dword ptr [ebp - 8]
008201B3 push     ecx
008201B4 mov      ecx, dword ptr [0x17c8708]
008201BA call     0x817bc0
008201BF push     eax
008201C0 push     0
008201C2 mov      edx, dword ptr [ebp - 0x18]
008201C5 mov      eax, dword ptr [edx]
008201C7 mov      ecx, dword ptr [ebp - 0x18]
008201CA mov      edx, dword ptr [eax + 0x1c0]
008201D0 call     edx
008201D2 mov      ecx, dword ptr [ebp - 8]
008201D5 call     0x45c4c0
008201DA mov      dword ptr [ebp - 0xc], eax
008201DD mov      eax, dword ptr [ebp - 4]
008201E0 movzx    ecx, byte ptr [eax + 9]
008201E4 push     ecx
008201E5 mov      ecx, dword ptr [ebp - 8]
008201E8 call     0x453950
008201ED mov      ecx, dword ptr [ebp - 8]
008201F0 call     0x45c4c0
008201F5 mov      dword ptr [ebp - 0x10], eax
008201F8 mov      edx, dword ptr [ebp - 4]
008201FB movzx    eax, byte ptr [edx + 8]
008201FF push     eax
00820200 mov      ecx, dword ptr [ebp - 8]
00820203 call     0x9e43f0
00820208 push     1
0082020A mov      ecx, dword ptr [ebp - 8]
0082020D push     ecx
0082020E mov      ecx, dword ptr [0x17c8708]
00820214 call     0x819fc0
00820219 mov      ecx, dword ptr [0x17c8708]
0082021F call     0x81b800
00820224 mov      dword ptr [ebp - 0x1c], eax
00820227 mov      edx, dword ptr [ebp - 8]
0082022A push     edx
0082022B mov      ecx, dword ptr [0x17c8708]
00820231 call     0x817bc0
00820236 push     eax
00820237 mov      eax, dword ptr [ebp - 8]
0082023A push     eax
0082023B mov      ecx, dword ptr [ebp - 0x1c]
0082023E mov      edx, dword ptr [ecx]
00820240 mov      ecx, dword ptr [ebp - 0x1c]
00820243 mov      eax, dword ptr [edx + 0x1c0]
00820249 call     eax
0082024B mov      ecx, dword ptr [0x17c8708]
00820251 call     0x81b800
00820256 mov      dword ptr [ebp - 0x20], eax
00820259 mov      ecx, dword ptr [ebp - 4]
0082025C movzx    edx, byte ptr [ecx + 8]
00820260 push     edx
00820261 mov      eax, dword ptr [ebp - 8]
00820264 push     eax
00820265 mov      ecx, dword ptr [ebp - 0x20]
00820268 mov      edx, dword ptr [ecx]
0082026A mov      ecx, dword ptr [ebp - 0x20]
0082026D mov      eax, dword ptr [edx + 0x1e0]
00820273 call     eax
00820275 mov      ecx, dword ptr [0x17c8708]
0082027B call     0x81b800
00820280 mov      dword ptr [ebp - 0x24], eax
00820283 push     0
00820285 mov      ecx, dword ptr [ebp - 0x24]
00820288 mov      edx, dword ptr [ecx]
0082028A mov      ecx, dword ptr [ebp - 0x24]
0082028D mov      eax, dword ptr [edx + 0x1cc]
00820293 call     eax
00820295 mov      ecx, dword ptr [0x17c8708]
0082029B call     0x81b800
008202A0 mov      dword ptr [ebp - 0x28], eax
008202A3 mov      ecx, dword ptr [ebp - 0x28]
008202A6 mov      edx, dword ptr [ecx]
008202A8 mov      ecx, dword ptr [ebp - 0x28]
008202AB mov      eax, dword ptr [edx + 0x1e4]
008202B1 call     eax
008202B3 mov      esp, ebp
008202B5 pop      ebp
008202B6 ret      8
