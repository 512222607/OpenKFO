; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; function 0x5425b0
005425B0 push     ebp
005425B1 mov      ebp, esp
005425B3 sub      esp, 0x1c
005425B6 mov      dword ptr [ebp - 0x1c], ecx
005425B9 mov      eax, dword ptr [ebp - 0x1c]
005425BC mov      edx, dword ptr [eax]
005425BE mov      ecx, dword ptr [ebp - 0x1c]
005425C1 mov      eax, dword ptr [edx + 0x1c]
005425C4 call     eax
005425C6 push     eax
005425C7 call     0xa4b950
005425CC mov      ecx, eax
005425CE call     0xa47ab0
005425D3 mov      dword ptr [ebp - 4], eax
005425D6 cmp      dword ptr [ebp - 4], 0
005425DA jne      0x5425de
005425DC jmp      0x54261c
005425DE mov      ecx, dword ptr [ebp - 4]
005425E1 movzx    edx, byte ptr [ecx + 0x10]
005425E5 cmp      edx, 1
005425E8 jne      0x54261c
005425EA mov      ecx, dword ptr [0x17c86fc]
005425F0 call     0x4651d0
005425F5 mov      dword ptr [ebp - 0x15], eax
005425F8 mov      byte ptr [ebp - 0x16], 2
005425FC mov      eax, dword ptr [ebp - 4]
005425FF mov      cx, word ptr [eax + 0xc]
00542603 mov      word ptr [ebp - 0x18], cx
00542607 push     0x13
00542609 lea      edx, [ebp - 0x18]
0054260C push     edx
0054260D push     0
0054260F push     0x17a3
00542614 call     0xa3c950
00542619 add      esp, 0x10
0054261C mov      esp, ebp
0054261E pop      ebp
0054261F ret

; function 0x542620
00542620 push     ebp
00542621 mov      ebp, esp
00542623 push     ecx
00542624 mov      dword ptr [ebp - 4], ecx
00542627 call     0xa4b950
0054262C mov      ecx, eax
0054262E call     0xa47340
00542633 mov      esp, ebp
00542635 pop      ebp
00542636 ret

; function 0x542750
00542750 push     ebp
00542751 mov      ebp, esp
00542753 sub      esp, 0x1c
00542756 mov      dword ptr [ebp - 0x1c], ecx
00542759 mov      eax, dword ptr [ebp - 0x1c]
0054275C mov      edx, dword ptr [eax]
0054275E mov      ecx, dword ptr [ebp - 0x1c]
00542761 mov      eax, dword ptr [edx + 0x1c]
00542764 call     eax
00542766 push     eax
00542767 call     0xa4b950
0054276C mov      ecx, eax
0054276E call     0xa47ab0
00542773 mov      dword ptr [ebp - 4], eax
00542776 cmp      dword ptr [ebp - 4], 0
0054277A jne      0x54277e
0054277C jmp      0x5427bc
0054277E mov      ecx, dword ptr [ebp - 4]
00542781 movzx    edx, byte ptr [ecx + 0x10]
00542785 cmp      edx, 4
00542788 jne      0x5427bc
0054278A mov      ecx, dword ptr [0x17c86fc]
00542790 call     0x4651d0
00542795 mov      dword ptr [ebp - 0x15], eax
00542798 mov      byte ptr [ebp - 0x16], 3
0054279C mov      eax, dword ptr [ebp - 4]
0054279F mov      cx, word ptr [eax + 0xc]
005427A3 mov      word ptr [ebp - 0x18], cx
005427A7 push     0x13
005427A9 lea      edx, [ebp - 0x18]
005427AC push     edx
005427AD push     0
005427AF push     0x18a7
005427B4 call     0xa3c950
005427B9 add      esp, 0x10
005427BC mov      esp, ebp
005427BE pop      ebp
005427BF ret

; function 0x5427c0
005427C0 push     ebp
005427C1 mov      ebp, esp
005427C3 sub      esp, 0x1c
005427C6 mov      dword ptr [ebp - 0x1c], ecx
005427C9 mov      eax, dword ptr [ebp - 0x1c]
005427CC mov      edx, dword ptr [eax]
005427CE mov      ecx, dword ptr [ebp - 0x1c]
005427D1 mov      eax, dword ptr [edx + 0x1c]
005427D4 call     eax
005427D6 push     eax
005427D7 call     0xa4b950
005427DC mov      ecx, eax
005427DE call     0xa47ab0
005427E3 mov      dword ptr [ebp - 4], eax
005427E6 cmp      dword ptr [ebp - 4], 0
005427EA jne      0x5427ee
005427EC jmp      0x54282c
005427EE mov      ecx, dword ptr [ebp - 4]
005427F1 movzx    edx, byte ptr [ecx + 0x10]
005427F5 cmp      edx, 2
005427F8 jne      0x54282c
005427FA mov      ecx, dword ptr [0x17c86fc]
00542800 call     0x4651d0
00542805 mov      dword ptr [ebp - 0x15], eax
00542808 mov      byte ptr [ebp - 0x16], 1
0054280C mov      eax, dword ptr [ebp - 4]
0054280F mov      cx, word ptr [eax + 0xc]
00542813 mov      word ptr [ebp - 0x18], cx
00542817 push     0x13
00542819 lea      edx, [ebp - 0x18]
0054281C push     edx
0054281D push     0
0054281F push     0x17c1
00542824 call     0xa3c950
00542829 add      esp, 0x10
0054282C mov      esp, ebp
0054282E pop      ebp
0054282F ret

; function 0x5453d0
005453D0 push     ebp
005453D1 mov      ebp, esp
005453D3 sub      esp, 0x1c
005453D6 mov      dword ptr [ebp - 0x1c], ecx
005453D9 mov      eax, dword ptr [ebp - 0x1c]
005453DC mov      edx, dword ptr [eax]
005453DE mov      ecx, dword ptr [ebp - 0x1c]
005453E1 mov      eax, dword ptr [edx + 0x1c]
005453E4 call     eax
005453E6 push     eax
005453E7 call     0x4045e0
005453EC mov      ecx, eax
005453EE call     0xa47920
005453F3 mov      dword ptr [ebp - 4], eax
005453F6 cmp      dword ptr [ebp - 4], 0
005453FA jne      0x5453fe
005453FC jmp      0x54543c
005453FE mov      ecx, dword ptr [ebp - 4]
00545401 movzx    edx, byte ptr [ecx + 0x10]
00545405 cmp      edx, 4
00545408 jne      0x54543c
0054540A mov      ecx, dword ptr [0x17c86fc]
00545410 call     0x4651d0
00545415 mov      dword ptr [ebp - 0x15], eax
00545418 mov      byte ptr [ebp - 0x16], 3
0054541C mov      eax, dword ptr [ebp - 4]
0054541F mov      cx, word ptr [eax + 0xc]
00545423 mov      word ptr [ebp - 0x18], cx
00545427 push     0x13
00545429 lea      edx, [ebp - 0x18]
0054542C push     edx
0054542D push     0
0054542F push     0x18a8
00545434 call     0xa3c950
00545439 add      esp, 0x10
0054543C mov      esp, ebp
0054543E pop      ebp
0054543F ret

; function 0x545440
00545440 push     ebp
00545441 mov      ebp, esp
00545443 sub      esp, 0x1c
00545446 mov      dword ptr [ebp - 0x1c], ecx
00545449 mov      eax, dword ptr [ebp - 0x1c]
0054544C mov      edx, dword ptr [eax]
0054544E mov      ecx, dword ptr [ebp - 0x1c]
00545451 mov      eax, dword ptr [edx + 0x1c]
00545454 call     eax
00545456 push     eax
00545457 call     0x4045e0
0054545C mov      ecx, eax
0054545E call     0xa47920
00545463 mov      dword ptr [ebp - 4], eax
00545466 cmp      dword ptr [ebp - 4], 0
0054546A jne      0x54546e
0054546C jmp      0x5454ac
0054546E mov      ecx, dword ptr [ebp - 4]
00545471 movzx    edx, byte ptr [ecx + 0x10]
00545475 cmp      edx, 1
00545478 jne      0x5454ac
0054547A mov      ecx, dword ptr [0x17c86fc]
00545480 call     0x4651d0
00545485 mov      dword ptr [ebp - 0x15], eax
00545488 mov      byte ptr [ebp - 0x16], 2
0054548C mov      eax, dword ptr [ebp - 4]
0054548F mov      cx, word ptr [eax + 0xc]
00545493 mov      word ptr [ebp - 0x18], cx
00545497 push     0x13
00545499 lea      edx, [ebp - 0x18]
0054549C push     edx
0054549D push     0
0054549F push     0x17a4
005454A4 call     0xa3c950
005454A9 add      esp, 0x10
005454AC mov      esp, ebp
005454AE pop      ebp
005454AF ret

; function 0x5454b0
005454B0 push     ebp
005454B1 mov      ebp, esp
005454B3 sub      esp, 0x1c
005454B6 mov      dword ptr [ebp - 0x1c], ecx
005454B9 mov      eax, dword ptr [ebp - 0x1c]
005454BC mov      edx, dword ptr [eax]
005454BE mov      ecx, dword ptr [ebp - 0x1c]
005454C1 mov      eax, dword ptr [edx + 0x1c]
005454C4 call     eax
005454C6 push     eax
005454C7 call     0x4045e0
005454CC mov      ecx, eax
005454CE call     0xa47920
005454D3 mov      dword ptr [ebp - 4], eax
005454D6 cmp      dword ptr [ebp - 4], 0
005454DA jne      0x5454de
005454DC jmp      0x54551c
005454DE mov      ecx, dword ptr [ebp - 4]
005454E1 movzx    edx, byte ptr [ecx + 0x10]
005454E5 cmp      edx, 2
005454E8 jne      0x54551c
005454EA mov      ecx, dword ptr [0x17c86fc]
005454F0 call     0x4651d0
005454F5 mov      dword ptr [ebp - 0x15], eax
005454F8 mov      byte ptr [ebp - 0x16], 1
005454FC mov      eax, dword ptr [ebp - 4]
005454FF mov      cx, word ptr [eax + 0xc]
00545503 mov      word ptr [ebp - 0x18], cx
00545507 push     0x13
00545509 lea      edx, [ebp - 0x18]
0054550C push     edx
0054550D push     0
0054550F push     0x17c2
00545514 call     0xa3c950
00545519 add      esp, 0x10
0054551C mov      esp, ebp
0054551E pop      ebp
0054551F ret

; function 0x545520
00545520 push     ebp
00545521 mov      ebp, esp
00545523 push     ecx
00545524 mov      dword ptr [ebp - 4], ecx
00545527 call     0x4045e0
0054552C mov      ecx, eax
0054552E call     0x53be90
00545533 mov      esp, ebp
00545535 pop      ebp
00545536 ret

; function 0x8220b0
008220B0 push     ebp
008220B1 mov      ebp, esp
008220B3 push     ecx
008220B4 mov      dword ptr [ebp - 4], ecx
008220B7 mov      eax, dword ptr [ebp + 8]
008220BA push     eax
008220BB call     0x4045e0
008220C0 mov      ecx, eax
008220C2 call     0xa480e0
008220C7 push     1
008220C9 call     0x811460
008220CE mov      ecx, eax
008220D0 call     0x549a30
008220D5 push     1
008220D7 call     0x548a20
008220DC mov      ecx, eax
008220DE call     0x549a50
008220E3 push     1
008220E5 call     0x548d10
008220EA mov      ecx, eax
008220EC call     0x549a50
008220F1 call     0x4e7570
008220F6 mov      ecx, eax
008220F8 call     0x8331e0
008220FD mov      esp, ebp
008220FF pop      ebp
00822100 ret      8

; function 0x822110
00822110 push     ebp
00822111 mov      ebp, esp
00822113 push     ecx
00822114 mov      dword ptr [ebp - 4], ecx
00822117 mov      eax, dword ptr [ebp + 8]
0082211A push     eax
0082211B call     0x4045e0
00822120 mov      ecx, eax
00822122 call     0xa480e0
00822127 call     0x4e7570
0082212C mov      ecx, eax
0082212E call     0x8331e0
00822133 mov      esp, ebp
00822135 pop      ebp
00822136 ret      8

; function 0x822140
00822140 push     ebp
00822141 mov      ebp, esp
00822143 push     ecx
00822144 mov      dword ptr [ebp - 4], ecx
00822147 mov      eax, dword ptr [ebp + 8]
0082214A push     eax
0082214B call     0x4045e0
00822150 mov      ecx, eax
00822152 call     0xa480e0
00822157 call     0x4e7570
0082215C mov      ecx, eax
0082215E call     0x8331e0
00822163 mov      esp, ebp
00822165 pop      ebp
00822166 ret      8

; function 0x822170
00822170 push     ebp
00822171 mov      ebp, esp
00822173 push     ecx
00822174 mov      dword ptr [ebp - 4], ecx
00822177 mov      eax, dword ptr [ebp + 8]
0082217A push     eax
0082217B call     0x4045e0
00822180 mov      ecx, eax
00822182 call     0xa480e0
00822187 call     0x4e7570
0082218C mov      ecx, eax
0082218E call     0x8331e0
00822193 mov      esp, ebp
00822195 pop      ebp
00822196 ret      8

; function 0x8221a0
008221A0 push     ebp
008221A1 mov      ebp, esp
008221A3 push     ecx
008221A4 mov      dword ptr [ebp - 4], ecx
008221A7 cmp      dword ptr [ebp + 8], 0
008221AB je       0x8221bd
008221AD mov      eax, dword ptr [ebp + 8]
008221B0 push     eax
008221B1 call     0xa4b950
008221B6 mov      ecx, eax
008221B8 call     0xa47a00
008221BD call     0x4e7570
008221C2 mov      ecx, eax
008221C4 call     0x8331e0
008221C9 push     1
008221CB call     0x811460
008221D0 mov      ecx, eax
008221D2 call     0x549a30
008221D7 push     1
008221D9 call     0x548a20
008221DE mov      ecx, eax
008221E0 call     0x549a50
008221E5 push     1
008221E7 call     0x548d10
008221EC mov      ecx, eax
008221EE call     0x549a50
008221F3 mov      esp, ebp
008221F5 pop      ebp
008221F6 ret      8

; function 0x822200
00822200 push     ebp
00822201 mov      ebp, esp
00822203 push     ecx
00822204 mov      dword ptr [ebp - 4], ecx
00822207 cmp      dword ptr [ebp + 8], 0
0082220B je       0x82221d
0082220D mov      eax, dword ptr [ebp + 8]
00822210 push     eax
00822211 call     0xa4b950
00822216 mov      ecx, eax
00822218 call     0xa47a00
0082221D call     0x4e7570
00822222 mov      ecx, eax
00822224 call     0x8331e0
00822229 mov      esp, ebp
0082222B pop      ebp
0082222C ret      8

; function 0x822230
00822230 push     ebp
00822231 mov      ebp, esp
00822233 push     ecx
00822234 mov      dword ptr [ebp - 4], ecx
00822237 cmp      dword ptr [ebp + 8], 0
0082223B je       0x82224d
0082223D mov      eax, dword ptr [ebp + 8]
00822240 push     eax
00822241 call     0xa4b950
00822246 mov      ecx, eax
00822248 call     0xa47a00
0082224D call     0x4e7570
00822252 mov      ecx, eax
00822254 call     0x8331e0
00822259 mov      esp, ebp
0082225B pop      ebp
0082225C ret      8

; function 0x822260
00822260 push     ebp
00822261 mov      ebp, esp
00822263 push     ecx
00822264 mov      dword ptr [ebp - 4], ecx
00822267 cmp      dword ptr [ebp + 8], 0
0082226B je       0x82227d
0082226D mov      eax, dword ptr [ebp + 8]
00822270 push     eax
00822271 call     0xa4b950
00822276 mov      ecx, eax
00822278 call     0xa47a00
0082227D call     0x4e7570
00822282 mov      ecx, eax
00822284 call     0x8331e0
00822289 mov      esp, ebp
0082228B pop      ebp
0082228C ret      8

; function 0xa47a00
00A47A00 push     ebp
00A47A01 mov      ebp, esp
00A47A03 sub      esp, 0x1c
00A47A06 mov      dword ptr [ebp - 0x1c], ecx
00A47A09 cmp      dword ptr [ebp + 8], 0
00A47A0D jne      0xa47a14
00A47A0F jmp      0xa47a9c
00A47A14 mov      eax, dword ptr [ebp + 8]
00A47A17 movzx    ecx, word ptr [eax]
00A47A1A mov      dword ptr [ebp - 0x10], ecx
00A47A1D lea      edx, [ebp - 0x10]
00A47A20 push     edx
00A47A21 lea      eax, [ebp - 8]
00A47A24 push     eax
00A47A25 mov      ecx, dword ptr [ebp - 0x1c]
00A47A28 add      ecx, 0x20
00A47A2B call     0x532af0
00A47A30 lea      ecx, [ebp - 0x18]
00A47A33 push     ecx
00A47A34 mov      ecx, dword ptr [ebp - 0x1c]
00A47A37 add      ecx, 0x20
00A47A3A call     0x45abb0
00A47A3F push     eax
00A47A40 lea      ecx, [ebp - 8]
00A47A43 call     0x4ab8f0
00A47A48 movzx    edx, al
00A47A4B test     edx, edx
00A47A4D je       0xa47a9c
00A47A4F mov      eax, dword ptr [ebp + 8]
00A47A52 movzx    ecx, byte ptr [eax + 2]
00A47A56 cmp      ecx, 1
00A47A59 jne      0xa47a8b
00A47A5B mov      dword ptr [ebp - 0xc], 0
00A47A62 jmp      0xa47a6d
00A47A64 mov      edx, dword ptr [ebp - 0xc]
00A47A67 add      edx, 1
00A47A6A mov      dword ptr [ebp - 0xc], edx
00A47A6D cmp      dword ptr [ebp - 0xc], 7
00A47A71 jge      0xa47a8b
00A47A73 lea      ecx, [ebp - 8]
00A47A76 call     0x4305b0
00A47A7B mov      ecx, dword ptr [ebp - 0xc]
00A47A7E imul     ecx, ecx, 0xc
00A47A81 mov      dword ptr [eax + ecx + 0x3d], 0
00A47A89 jmp      0xa47a64
00A47A8B lea      ecx, [ebp - 8]
00A47A8E call     0x4305b0
00A47A93 mov      edx, dword ptr [ebp + 8]
00A47A96 mov      cl, byte ptr [edx + 2]
00A47A99 mov      byte ptr [eax + 0x14], cl
00A47A9C mov      esp, ebp
00A47A9E pop      ebp
00A47A9F ret      4

; function 0xa480e0
00A480E0 push     ebp
00A480E1 mov      ebp, esp
00A480E3 sub      esp, 0x2c
00A480E6 mov      dword ptr [ebp - 0x2c], ecx
00A480E9 cmp      dword ptr [ebp + 8], 0
00A480ED jne      0xa480f4
00A480EF jmp      0xa481a4
00A480F4 mov      eax, dword ptr [ebp + 8]
00A480F7 movzx    ecx, word ptr [eax]
00A480FA mov      dword ptr [ebp - 0x10], ecx
00A480FD lea      edx, [ebp - 0x10]
00A48100 push     edx
00A48101 lea      eax, [ebp - 8]
00A48104 push     eax
00A48105 mov      ecx, dword ptr [ebp - 0x2c]
00A48108 call     0x532af0
00A4810D lea      ecx, [ebp - 0x18]
00A48110 push     ecx
00A48111 mov      ecx, dword ptr [ebp - 0x2c]
00A48114 call     0x45abb0
00A48119 push     eax
00A4811A lea      ecx, [ebp - 8]
00A4811D call     0x4ab8f0
00A48122 movzx    edx, al
00A48125 test     edx, edx
00A48127 je       0xa481a4
00A48129 mov      eax, dword ptr [ebp + 8]
00A4812C movzx    ecx, byte ptr [eax + 2]
00A48130 cmp      ecx, 3
00A48133 jne      0xa48157
00A48135 mov      edx, dword ptr [ebp - 8]
00A48138 mov      dword ptr [ebp - 0x20], edx
00A4813B mov      eax, dword ptr [ebp - 4]
00A4813E mov      dword ptr [ebp - 0x1c], eax
00A48141 mov      ecx, dword ptr [ebp - 0x1c]
00A48144 push     ecx
00A48145 mov      edx, dword ptr [ebp - 0x20]
00A48148 push     edx
00A48149 lea      eax, [ebp - 0x28]
00A4814C push     eax
00A4814D mov      ecx, dword ptr [ebp - 0x2c]
00A48150 call     0x40e7d0
00A48155 jmp      0xa481a4
00A48157 mov      ecx, dword ptr [ebp + 8]
00A4815A movzx    edx, byte ptr [ecx + 2]
00A4815E cmp      edx, 1
00A48161 jne      0xa48193
00A48163 mov      dword ptr [ebp - 0xc], 0
00A4816A jmp      0xa48175
00A4816C mov      eax, dword ptr [ebp - 0xc]
00A4816F add      eax, 1
00A48172 mov      dword ptr [ebp - 0xc], eax
00A48175 cmp      dword ptr [ebp - 0xc], 7
00A48179 jge      0xa48193
00A4817B lea      ecx, [ebp - 8]
00A4817E call     0x4305b0
00A48183 mov      ecx, dword ptr [ebp - 0xc]
00A48186 imul     ecx, ecx, 0xc
00A48189 mov      dword ptr [eax + ecx + 0x3d], 0
00A48191 jmp      0xa4816c
00A48193 lea      ecx, [ebp - 8]
00A48196 call     0x4305b0
00A4819B mov      edx, dword ptr [ebp + 8]
00A4819E mov      cl, byte ptr [edx + 2]
00A481A1 mov      byte ptr [eax + 0x14], cl
00A481A4 mov      esp, ebp
00A481A6 pop      ebp
00A481A7 ret      4

; function 0xa47ab0
00A47AB0 push     ebp
00A47AB1 mov      ebp, esp
00A47AB3 sub      esp, 0x14
00A47AB6 mov      dword ptr [ebp - 0x14], ecx
00A47AB9 mov      ecx, dword ptr [ebp - 0x14]
00A47ABC add      ecx, 0x40
00A47ABF call     0x55f000
00A47AC4 cmp      eax, dword ptr [ebp + 8]
00A47AC7 jle      0xa47b14
00A47AC9 mov      eax, dword ptr [ebp + 8]
00A47ACC push     eax
00A47ACD mov      ecx, dword ptr [ebp - 0x14]
00A47AD0 add      ecx, 0x40
00A47AD3 call     0x491640
00A47AD8 push     eax
00A47AD9 lea      ecx, [ebp - 8]
00A47ADC push     ecx
00A47ADD mov      ecx, dword ptr [ebp - 0x14]
00A47AE0 add      ecx, 0x20
00A47AE3 call     0x532af0
00A47AE8 lea      edx, [ebp - 0x10]
00A47AEB push     edx
00A47AEC mov      ecx, dword ptr [ebp - 0x14]
00A47AEF add      ecx, 0x20
00A47AF2 call     0x45abb0
00A47AF7 push     eax
00A47AF8 lea      ecx, [ebp - 8]
00A47AFB call     0x4ab8f0
00A47B00 movzx    eax, al
00A47B03 test     eax, eax
00A47B05 je       0xa47b14
00A47B07 lea      ecx, [ebp - 8]
00A47B0A call     0x4305b0
00A47B0F add      eax, 4
00A47B12 jmp      0xa47b16
00A47B14 xor      eax, eax
00A47B16 mov      esp, ebp
00A47B18 pop      ebp
00A47B19 ret      4

; function 0xa47920
00A47920 push     ebp
00A47921 mov      ebp, esp
00A47923 sub      esp, 0x14
00A47926 mov      dword ptr [ebp - 0x14], ecx
00A47929 mov      ecx, dword ptr [ebp - 0x14]
00A4792C add      ecx, 0x40
00A4792F call     0x55f000
00A47934 cmp      eax, dword ptr [ebp + 8]
00A47937 jbe      0xa4797e
00A47939 mov      eax, dword ptr [ebp + 8]
00A4793C push     eax
00A4793D mov      ecx, dword ptr [ebp - 0x14]
00A47940 add      ecx, 0x40
00A47943 call     0x491640
00A47948 push     eax
00A47949 lea      ecx, [ebp - 8]
00A4794C push     ecx
00A4794D mov      ecx, dword ptr [ebp - 0x14]
00A47950 call     0x532af0
00A47955 lea      edx, [ebp - 0x10]
00A47958 push     edx
00A47959 mov      ecx, dword ptr [ebp - 0x14]
00A4795C call     0x45abb0
00A47961 push     eax
00A47962 lea      ecx, [ebp - 8]
00A47965 call     0x4ab8f0
00A4796A movzx    eax, al
00A4796D test     eax, eax
00A4796F je       0xa4797e
00A47971 lea      ecx, [ebp - 8]
00A47974 call     0x4305b0
00A47979 add      eax, 4
00A4797C jmp      0xa47980
00A4797E xor      eax, eax
00A47980 mov      esp, ebp
00A47982 pop      ebp
00A47983 ret      4



; registration 0x8220b0
00B2544E mov      dword ptr [ebp - 0x120], 0x8220b0
00B25458 mov      dword ptr [ebp - 0x11c], 0
00B25462 mov      dword ptr [ebp - 0x118], 0
00B2546C mov      dword ptr [ebp - 0x114], 0
00B25476 mov      edx, dword ptr [ebp - 0x120]
00B2547C mov      dword ptr [0x12fe768], edx
00B25482 mov      eax, dword ptr [ebp - 0x11c]
00B25488 mov      dword ptr [0x12fe76c], eax
00B2548D mov      ecx, dword ptr [ebp - 0x118]
00B25493 mov      dword ptr [0x12fe770], ecx
00B25499 mov      edx, dword ptr [ebp - 0x114]
00B2549F mov      dword ptr [0x12fe774], edx

; registration 0x822110
00B252A3 mov      dword ptr [ebp - 0xe0], 0x822110
00B252AD mov      dword ptr [ebp - 0xdc], 0
00B252B7 mov      dword ptr [ebp - 0xd8], 0
00B252C1 mov      dword ptr [ebp - 0xd4], 0
00B252CB mov      ecx, dword ptr [ebp - 0xe0]
00B252D1 mov      dword ptr [0x12fe708], ecx
00B252D7 mov      edx, dword ptr [ebp - 0xdc]
00B252DD mov      dword ptr [0x12fe70c], edx
00B252E3 mov      eax, dword ptr [ebp - 0xd8]
00B252E9 mov      dword ptr [0x12fe710], eax
00B252EE mov      ecx, dword ptr [ebp - 0xd4]
00B252F4 mov      dword ptr [0x12fe714], ecx

; registration 0x822140
00B253E3 mov      dword ptr [ebp - 0x110], 0x822140
00B253ED mov      dword ptr [ebp - 0x10c], 0
00B253F7 mov      dword ptr [ebp - 0x108], 0
00B25401 mov      dword ptr [ebp - 0x104], 0
00B2540B mov      ecx, dword ptr [ebp - 0x110]
00B25411 mov      dword ptr [0x12fe750], ecx
00B25417 mov      edx, dword ptr [ebp - 0x10c]
00B2541D mov      dword ptr [0x12fe754], edx
00B25423 mov      eax, dword ptr [ebp - 0x108]
00B25429 mov      dword ptr [0x12fe758], eax
00B2542E mov      ecx, dword ptr [ebp - 0x104]
00B25434 mov      dword ptr [0x12fe75c], ecx

; registration 0x822170
00B25379 mov      dword ptr [ebp - 0x100], 0x822170
00B25383 mov      dword ptr [ebp - 0xfc], 0
00B2538D mov      dword ptr [ebp - 0xf8], 0
00B25397 mov      dword ptr [ebp - 0xf4], 0
00B253A1 mov      eax, dword ptr [ebp - 0x100]
00B253A7 mov      dword ptr [0x12fe738], eax
00B253AC mov      ecx, dword ptr [ebp - 0xfc]
00B253B2 mov      dword ptr [0x12fe73c], ecx
00B253B8 mov      edx, dword ptr [ebp - 0xf8]
00B253BE mov      dword ptr [0x12fe740], edx
00B253C4 mov      eax, dword ptr [ebp - 0xf4]
00B253CA mov      dword ptr [0x12fe744], eax
00B253CF mov      dword ptr [0x12fe748], 0x17ae

; registration 0x8221a0
00B25239 mov      dword ptr [ebp - 0xd0], 0x8221a0
00B25243 mov      dword ptr [ebp - 0xcc], 0
00B2524D mov      dword ptr [ebp - 0xc8], 0
00B25257 mov      dword ptr [ebp - 0xc4], 0
00B25261 mov      eax, dword ptr [ebp - 0xd0]
00B25267 mov      dword ptr [0x12fe6f0], eax
00B2526C mov      ecx, dword ptr [ebp - 0xcc]
00B25272 mov      dword ptr [0x12fe6f4], ecx
00B25278 mov      edx, dword ptr [ebp - 0xc8]
00B2527E mov      dword ptr [0x12fe6f8], edx
00B25284 mov      eax, dword ptr [ebp - 0xc4]
00B2528A mov      dword ptr [0x12fe6fc], eax
00B2528F mov      dword ptr [0x12fe700], 0x17cc

; registration 0x822200
00B2508E mov      dword ptr [ebp - 0x90], 0x822200
00B25098 mov      dword ptr [ebp - 0x8c], 0
00B250A2 mov      dword ptr [ebp - 0x88], 0
00B250AC mov      dword ptr [ebp - 0x84], 0
00B250B6 mov      edx, dword ptr [ebp - 0x90]
00B250BC mov      dword ptr [0x12fe690], edx
00B250C2 mov      eax, dword ptr [ebp - 0x8c]
00B250C8 mov      dword ptr [0x12fe694], eax
00B250CD mov      ecx, dword ptr [ebp - 0x88]
00B250D3 mov      dword ptr [0x12fe698], ecx
00B250D9 mov      edx, dword ptr [ebp - 0x84]
00B250DF mov      dword ptr [0x12fe69c], edx

; registration 0x822230
00B251CE mov      dword ptr [ebp - 0xc0], 0x822230
00B251D8 mov      dword ptr [ebp - 0xbc], 0
00B251E2 mov      dword ptr [ebp - 0xb8], 0
00B251EC mov      dword ptr [ebp - 0xb4], 0
00B251F6 mov      edx, dword ptr [ebp - 0xc0]
00B251FC mov      dword ptr [0x12fe6d8], edx
00B25202 mov      eax, dword ptr [ebp - 0xbc]
00B25208 mov      dword ptr [0x12fe6dc], eax
00B2520D mov      ecx, dword ptr [ebp - 0xb8]
00B25213 mov      dword ptr [0x12fe6e0], ecx
00B25219 mov      edx, dword ptr [ebp - 0xb4]
00B2521F mov      dword ptr [0x12fe6e4], edx

; registration 0x822260
00B25163 mov      dword ptr [ebp - 0xb0], 0x822260
00B2516D mov      dword ptr [ebp - 0xac], 0
00B25177 mov      dword ptr [ebp - 0xa8], 0
00B25181 mov      dword ptr [ebp - 0xa4], 0
00B2518B mov      ecx, dword ptr [ebp - 0xb0]
00B25191 mov      dword ptr [0x12fe6c0], ecx
00B25197 mov      edx, dword ptr [ebp - 0xac]
00B2519D mov      dword ptr [0x12fe6c4], edx
00B251A3 mov      eax, dword ptr [ebp - 0xa8]
00B251A9 mov      dword ptr [0x12fe6c8], eax
00B251AE mov      ecx, dword ptr [ebp - 0xa4]
00B251B4 mov      dword ptr [0x12fe6cc], ecx

; opcode assignments preceding handlers
00B25444 mov      dword ptr [0x12fe764], 1
00B2544E mov      dword ptr [ebp - 0x120], 0x8220b0
00B25299 mov      dword ptr [0x12fe704], 1
00B252A3 mov      dword ptr [ebp - 0xe0], 0x822110
00B253D9 mov      dword ptr [0x12fe74c], 1
00B253E3 mov      dword ptr [ebp - 0x110], 0x822140
00B2536F mov      dword ptr [0x12fe734], 1
00B25379 mov      dword ptr [ebp - 0x100], 0x822170
00B2522F mov      dword ptr [0x12fe6ec], 1
00B25239 mov      dword ptr [ebp - 0xd0], 0x8221a0
00B25084 mov      dword ptr [0x12fe68c], 1
00B2508E mov      dword ptr [ebp - 0x90], 0x822200
00B251C4 mov      dword ptr [0x12fe6d4], 1
00B251CE mov      dword ptr [ebp - 0xc0], 0x822230
00B25159 mov      dword ptr [0x12fe6bc], 1
00B25163 mov      dword ptr [ebp - 0xb0], 0x822260

; opcode and flag assignments
00B2543A mov      dword ptr [0x12fe760], 0x1790
00B25444 mov      dword ptr [0x12fe764], 1
00B2544E mov      dword ptr [ebp - 0x120], 0x8220b0
00B2528F mov      dword ptr [0x12fe700], 0x17cc
00B25299 mov      dword ptr [0x12fe704], 1
00B252A3 mov      dword ptr [ebp - 0xe0], 0x822110
00B253CF mov      dword ptr [0x12fe748], 0x17ae
00B253D9 mov      dword ptr [0x12fe74c], 1
00B253E3 mov      dword ptr [ebp - 0x110], 0x822140
00B25365 mov      dword ptr [0x12fe730], 0x189e
00B2536F mov      dword ptr [0x12fe734], 1
00B25379 mov      dword ptr [ebp - 0x100], 0x822170
00B25225 mov      dword ptr [0x12fe6e8], 0x178f
00B2522F mov      dword ptr [0x12fe6ec], 1
00B25239 mov      dword ptr [ebp - 0xd0], 0x8221a0
00B2507A mov      dword ptr [0x12fe688], 0x17cb
00B25084 mov      dword ptr [0x12fe68c], 1
00B2508E mov      dword ptr [ebp - 0x90], 0x822200
00B251BA mov      dword ptr [0x12fe6d0], 0x17ad
00B251C4 mov      dword ptr [0x12fe6d4], 1
00B251CE mov      dword ptr [ebp - 0xc0], 0x822230
00B2514F mov      dword ptr [0x12fe6b8], 0x189d
00B25159 mov      dword ptr [0x12fe6bc], 1
00B25163 mov      dword ptr [ebp - 0xb0], 0x822260
