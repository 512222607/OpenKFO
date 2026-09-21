; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; function 0xa2bee0
00A2BEE0 push     ebp
00A2BEE1 mov      ebp, esp
00A2BEE3 sub      esp, 0xc
00A2BEE6 mov      dword ptr [ebp - 0xc], ecx
00A2BEE9 mov      eax, dword ptr [ebp + 8]
00A2BEEC mov      dword ptr [ebp - 4], eax
00A2BEEF cmp      dword ptr [ebp - 4], 0
00A2BEF3 jne      0xa2bef7
00A2BEF5 jmp      0xa2bf71
00A2BEF7 mov      dword ptr [ebp - 8], 0
00A2BEFE jmp      0xa2bf09
00A2BF00 mov      ecx, dword ptr [ebp + 0xc]
00A2BF03 add      ecx, 1
00A2BF06 mov      dword ptr [ebp + 0xc], ecx
00A2BF09 mov      eax, dword ptr [ebp + 0xc]
00A2BF0C xor      edx, edx
00A2BF0E mov      ecx, 0x16
00A2BF13 div      ecx
00A2BF15 cmp      dword ptr [ebp - 8], eax
00A2BF18 jae      0xa2bf71
00A2BF1A mov      edx, dword ptr [ebp - 4]
00A2BF1D movzx    eax, word ptr [edx + 0xc]
00A2BF21 cmp      eax, 0x7d0
00A2BF26 jl       0xa2bf47
00A2BF28 mov      ecx, dword ptr [ebp - 4]
00A2BF2B movzx    edx, word ptr [ecx + 0xc]
00A2BF2F cmp      edx, 0xbb8
00A2BF35 jg       0xa2bf47
00A2BF37 mov      eax, dword ptr [ebp - 4]
00A2BF3A push     eax
00A2BF3B call     0xa4b950
00A2BF40 mov      ecx, eax
00A2BF42 call     0xa483b0
00A2BF47 mov      ecx, dword ptr [ebp - 4]
00A2BF4A movzx    edx, word ptr [ecx + 0xc]
00A2BF4E cmp      edx, 0xbb8
00A2BF54 jle      0xa2bf66
00A2BF56 mov      eax, dword ptr [ebp - 4]
00A2BF59 push     eax
00A2BF5A call     0x4045e0
00A2BF5F mov      ecx, eax
00A2BF61 call     0xa481b0
00A2BF66 mov      ecx, dword ptr [ebp - 4]
00A2BF69 add      ecx, 0x16
00A2BF6C mov      dword ptr [ebp - 4], ecx
00A2BF6F jmp      0xa2bf00
00A2BF71 mov      esp, ebp
00A2BF73 pop      ebp
00A2BF74 ret      8

; function 0xa47530
00A47530 push     ebp
00A47531 mov      ebp, esp
00A47533 sub      esp, 0x14
00A47536 mov      dword ptr [ebp - 0x14], ecx
00A47539 lea      eax, [ebp + 8]
00A4753C push     eax
00A4753D lea      ecx, [ebp - 8]
00A47540 push     ecx
00A47541 mov      ecx, dword ptr [ebp - 0x14]
00A47544 call     0x44a220
00A47549 lea      edx, [ebp - 0x10]
00A4754C push     edx
00A4754D mov      ecx, dword ptr [ebp - 0x14]
00A47550 call     0x45abb0
00A47555 push     eax
00A47556 lea      ecx, [ebp - 8]
00A47559 call     0x4ab920
00A4755E movzx    eax, al
00A47561 test     eax, eax
00A47563 je       0xa4756b
00A47565 xor      eax, eax
00A47567 jmp      0xa47576
00A47569 jmp      0xa47576
00A4756B lea      ecx, [ebp - 8]
00A4756E call     0x4305b0
00A47573 mov      eax, dword ptr [eax + 4]
00A47576 mov      esp, ebp
00A47578 pop      ebp
00A47579 ret      4

; function 0xa483b0
00A483B0 push     ebp
00A483B1 mov      ebp, esp
00A483B3 push     -1
00A483B5 push     0xaa01e3
00A483BA mov      eax, dword ptr fs:[0]
00A483C0 push     eax
00A483C1 sub      esp, 0x8c
00A483C7 push     esi
00A483C8 mov      eax, dword ptr [0xc7b480]
00A483CD xor      eax, ebp
00A483CF push     eax
00A483D0 lea      eax, [ebp - 0xc]
00A483D3 mov      dword ptr fs:[0], eax
00A483D9 mov      dword ptr [ebp - 0x8c], ecx
00A483DF mov      eax, dword ptr [ebp + 8]
00A483E2 movzx    ecx, word ptr [eax + 0xc]
00A483E6 mov      dword ptr [ebp - 0x38], ecx
00A483E9 lea      edx, [ebp - 0x38]
00A483EC push     edx
00A483ED lea      eax, [ebp - 0x14]
00A483F0 push     eax
00A483F1 mov      ecx, dword ptr [ebp - 0x8c]
00A483F7 add      ecx, 0x58
00A483FA call     0x532d60
00A483FF lea      ecx, [ebp - 0x2c]
00A48402 call     0x533170
00A48407 mov      dword ptr [ebp - 4], 0
00A4840E lea      ecx, [ebp - 0x40]
00A48411 push     ecx
00A48412 mov      ecx, dword ptr [ebp - 0x8c]
00A48418 add      ecx, 0x58
00A4841B call     0x45abb0
00A48420 push     eax
00A48421 lea      ecx, [ebp - 0x14]
00A48424 call     0x4ab920
00A48429 movzx    edx, al
00A4842C test     edx, edx
00A4842E je       0xa484ca
00A48434 mov      eax, dword ptr [ebp + 8]
00A48437 push     eax
00A48438 lea      ecx, [ebp - 0x2c]
00A4843B call     0x533330
00A48440 sub      esp, 0x18
00A48443 mov      ecx, esp
00A48445 mov      dword ptr [ebp - 0x60], esp
00A48448 lea      edx, [ebp - 0x2c]
00A4844B push     edx
00A4844C call     0x5331e0
00A48451 mov      dword ptr [ebp - 0x90], eax
00A48457 mov      eax, dword ptr [ebp + 8]
00A4845A movzx    ecx, word ptr [eax + 0xc]
00A4845E push     ecx
00A4845F lea      edx, [ebp - 0x7c]
00A48462 push     edx
00A48463 call     0x539ad0
00A48468 add      esp, 0x20
00A4846B mov      dword ptr [ebp - 0x94], eax
00A48471 mov      eax, dword ptr [ebp - 0x94]
00A48477 mov      dword ptr [ebp - 0x98], eax
00A4847D mov      byte ptr [ebp - 4], 1
00A48481 mov      ecx, dword ptr [ebp - 0x98]
00A48487 push     ecx
00A48488 lea      ecx, [ebp - 0x5c]
00A4848B call     0x539b40
00A48490 mov      byte ptr [ebp - 4], 2
00A48494 lea      edx, [ebp - 0x5c]
00A48497 push     edx
00A48498 lea      eax, [ebp - 0x88]
00A4849E push     eax
00A4849F mov      ecx, dword ptr [ebp - 0x8c]
00A484A5 add      ecx, 0x58
00A484A8 call     0x532b90
00A484AD mov      byte ptr [ebp - 4], 1
00A484B1 lea      ecx, [ebp - 0x5c]
00A484B4 call     0x5318d0
00A484B9 mov      byte ptr [ebp - 4], 0
00A484BD lea      ecx, [ebp - 0x7c]
00A484C0 call     0x5318d0
00A484C5 jmp      0xa4858a
00A484CA mov      byte ptr [ebp - 0x2d], 0
00A484CE mov      dword ptr [ebp - 0x34], 0
00A484D5 jmp      0xa484e0
00A484D7 mov      ecx, dword ptr [ebp - 0x34]
00A484DA add      ecx, 1
00A484DD mov      dword ptr [ebp - 0x34], ecx
00A484E0 lea      ecx, [ebp - 0x14]
00A484E3 call     0x4305b0
00A484E8 add      eax, 4
00A484EB mov      ecx, eax
00A484ED call     0x5332e0
00A484F2 cmp      dword ptr [ebp - 0x34], eax
00A484F5 jae      0xa4856c
00A484F7 mov      edx, dword ptr [ebp + 8]
00A484FA movzx    esi, word ptr [edx + 0xc]
00A484FE mov      eax, dword ptr [ebp - 0x34]
00A48501 push     eax
00A48502 lea      ecx, [ebp - 0x14]
00A48505 call     0x4305b0
00A4850A add      eax, 4
00A4850D mov      ecx, eax
00A4850F call     0x533300
00A48514 movzx    ecx, word ptr [eax + 0xc]
00A48518 xor      edx, edx
00A4851A cmp      dword ptr [ebp - 0x34], ecx
00A4851D setl     dl
00A48520 cmp      esi, edx
00A48522 jne      0xa48567
00A48524 mov      byte ptr [ebp - 0x2d], 1
00A48528 mov      esi, dword ptr [ebp + 8]
00A4852B mov      eax, dword ptr [ebp - 0x34]
00A4852E push     eax
00A4852F lea      ecx, [ebp - 0x14]
00A48532 call     0x4305b0
00A48537 add      eax, 4
00A4853A mov      ecx, eax
00A4853C call     0x533300
00A48541 mov      ecx, dword ptr [esi]
00A48543 mov      dword ptr [eax], ecx
00A48545 mov      edx, dword ptr [esi + 4]
00A48548 mov      dword ptr [eax + 4], edx
00A4854B mov      ecx, dword ptr [esi + 8]
00A4854E mov      dword ptr [eax + 8], ecx
00A48551 mov      edx, dword ptr [esi + 0xc]
00A48554 mov      dword ptr [eax + 0xc], edx
00A48557 mov      ecx, dword ptr [esi + 0x10]
00A4855A mov      dword ptr [eax + 0x10], ecx
00A4855D mov      dx, word ptr [esi + 0x14]
00A48561 mov      word ptr [eax + 0x14], dx
00A48565 jmp      0xa4856c
00A48567 jmp      0xa484d7
00A4856C movzx    eax, byte ptr [ebp - 0x2d]
00A48570 test     eax, eax
00A48572 jne      0xa4858a
00A48574 mov      ecx, dword ptr [ebp + 8]
00A48577 push     ecx
00A48578 lea      ecx, [ebp - 0x14]
00A4857B call     0x4305b0
00A48580 add      eax, 4
00A48583 mov      ecx, eax
00A48585 call     0x533330
00A4858A mov      dword ptr [ebp - 4], 0xffffffff
00A48591 lea      ecx, [ebp - 0x2c]
00A48594 call     0x412d20
00A48599 mov      ecx, dword ptr [ebp - 0xc]
00A4859C mov      dword ptr fs:[0], ecx
00A485A3 pop      ecx
00A485A4 pop      esi
00A485A5 mov      esp, ebp
00A485A7 pop      ebp
00A485A8 ret      4

; function 0xa481b0
00A481B0 push     ebp
00A481B1 mov      ebp, esp
00A481B3 push     -1
00A481B5 push     0xaa01ad
00A481BA mov      eax, dword ptr fs:[0]
00A481C0 push     eax
00A481C1 sub      esp, 0x8c
00A481C7 push     esi
00A481C8 mov      eax, dword ptr [0xc7b480]
00A481CD xor      eax, ebp
00A481CF push     eax
00A481D0 lea      eax, [ebp - 0xc]
00A481D3 mov      dword ptr fs:[0], eax
00A481D9 mov      dword ptr [ebp - 0x8c], ecx
00A481DF mov      eax, dword ptr [ebp + 8]
00A481E2 movzx    ecx, word ptr [eax + 0xc]
00A481E6 mov      dword ptr [ebp - 0x38], ecx
00A481E9 lea      edx, [ebp - 0x38]
00A481EC push     edx
00A481ED lea      eax, [ebp - 0x14]
00A481F0 push     eax
00A481F1 mov      ecx, dword ptr [ebp - 0x8c]
00A481F7 add      ecx, 0x58
00A481FA call     0x532d60
00A481FF lea      ecx, [ebp - 0x2c]
00A48202 call     0x533170
00A48207 mov      dword ptr [ebp - 4], 0
00A4820E lea      ecx, [ebp - 0x40]
00A48211 push     ecx
00A48212 mov      ecx, dword ptr [ebp - 0x8c]
00A48218 add      ecx, 0x58
00A4821B call     0x45abb0
00A48220 push     eax
00A48221 lea      ecx, [ebp - 0x14]
00A48224 call     0x4ab920
00A48229 movzx    edx, al
00A4822C test     edx, edx
00A4822E je       0xa482ca
00A48234 mov      eax, dword ptr [ebp + 8]
00A48237 push     eax
00A48238 lea      ecx, [ebp - 0x2c]
00A4823B call     0x533330
00A48240 sub      esp, 0x18
00A48243 mov      ecx, esp
00A48245 mov      dword ptr [ebp - 0x60], esp
00A48248 lea      edx, [ebp - 0x2c]
00A4824B push     edx
00A4824C call     0x5331e0
00A48251 mov      dword ptr [ebp - 0x90], eax
00A48257 mov      eax, dword ptr [ebp + 8]
00A4825A movzx    ecx, word ptr [eax + 0xc]
00A4825E push     ecx
00A4825F lea      edx, [ebp - 0x7c]
00A48262 push     edx
00A48263 call     0x539ad0
00A48268 add      esp, 0x20
00A4826B mov      dword ptr [ebp - 0x94], eax
00A48271 mov      eax, dword ptr [ebp - 0x94]
00A48277 mov      dword ptr [ebp - 0x98], eax
00A4827D mov      byte ptr [ebp - 4], 1
00A48281 mov      ecx, dword ptr [ebp - 0x98]
00A48287 push     ecx
00A48288 lea      ecx, [ebp - 0x5c]
00A4828B call     0x539b40
00A48290 mov      byte ptr [ebp - 4], 2
00A48294 lea      edx, [ebp - 0x5c]
00A48297 push     edx
00A48298 lea      eax, [ebp - 0x88]
00A4829E push     eax
00A4829F mov      ecx, dword ptr [ebp - 0x8c]
00A482A5 add      ecx, 0x58
00A482A8 call     0x532b90
00A482AD mov      byte ptr [ebp - 4], 1
00A482B1 lea      ecx, [ebp - 0x5c]
00A482B4 call     0x5318d0
00A482B9 mov      byte ptr [ebp - 4], 0
00A482BD lea      ecx, [ebp - 0x7c]
00A482C0 call     0x5318d0
00A482C5 jmp      0xa4838a
00A482CA mov      byte ptr [ebp - 0x2d], 0
00A482CE mov      dword ptr [ebp - 0x34], 0
00A482D5 jmp      0xa482e0
00A482D7 mov      ecx, dword ptr [ebp - 0x34]
00A482DA add      ecx, 1
00A482DD mov      dword ptr [ebp - 0x34], ecx
00A482E0 lea      ecx, [ebp - 0x14]
00A482E3 call     0x4305b0
00A482E8 add      eax, 4
00A482EB mov      ecx, eax
00A482ED call     0x5332e0
00A482F2 cmp      dword ptr [ebp - 0x34], eax
00A482F5 jae      0xa4836c
00A482F7 mov      edx, dword ptr [ebp + 8]
00A482FA movzx    esi, word ptr [edx + 0xc]
00A482FE mov      eax, dword ptr [ebp - 0x34]
00A48301 push     eax
00A48302 lea      ecx, [ebp - 0x14]
00A48305 call     0x4305b0
00A4830A add      eax, 4
00A4830D mov      ecx, eax
00A4830F call     0x533300
00A48314 movzx    ecx, word ptr [eax + 0xc]
00A48318 xor      edx, edx
00A4831A cmp      dword ptr [ebp - 0x34], ecx
00A4831D setl     dl
00A48320 cmp      esi, edx
00A48322 jne      0xa48367
00A48324 mov      byte ptr [ebp - 0x2d], 1
00A48328 mov      esi, dword ptr [ebp + 8]
00A4832B mov      eax, dword ptr [ebp - 0x34]
00A4832E push     eax
00A4832F lea      ecx, [ebp - 0x14]
00A48332 call     0x4305b0
00A48337 add      eax, 4
00A4833A mov      ecx, eax
00A4833C call     0x533300
00A48341 mov      ecx, dword ptr [esi]
00A48343 mov      dword ptr [eax], ecx
00A48345 mov      edx, dword ptr [esi + 4]
00A48348 mov      dword ptr [eax + 4], edx
00A4834B mov      ecx, dword ptr [esi + 8]
00A4834E mov      dword ptr [eax + 8], ecx
00A48351 mov      edx, dword ptr [esi + 0xc]
00A48354 mov      dword ptr [eax + 0xc], edx
00A48357 mov      ecx, dword ptr [esi + 0x10]
00A4835A mov      dword ptr [eax + 0x10], ecx
00A4835D mov      dx, word ptr [esi + 0x14]
00A48361 mov      word ptr [eax + 0x14], dx
00A48365 jmp      0xa4836c
00A48367 jmp      0xa482d7
00A4836C movzx    eax, byte ptr [ebp - 0x2d]
00A48370 test     eax, eax
00A48372 jne      0xa4838a
00A48374 mov      ecx, dword ptr [ebp + 8]
00A48377 push     ecx
00A48378 lea      ecx, [ebp - 0x14]
00A4837B call     0x4305b0
00A48380 add      eax, 4
00A48383 mov      ecx, eax
00A48385 call     0x533330
00A4838A mov      dword ptr [ebp - 4], 0xffffffff
00A48391 lea      ecx, [ebp - 0x2c]
00A48394 call     0x412d20
00A48399 mov      ecx, dword ptr [ebp - 0xc]
00A4839C mov      dword ptr fs:[0], ecx
00A483A3 pop      ecx
00A483A4 pop      esi
00A483A5 mov      esp, ebp
00A483A7 pop      ebp
00A483A8 ret      4

; registration
00AF31FA mov      dword ptr [0x12fcc90], 0x5032
00AF3204 mov      dword ptr [0x12fcc94], 1
00AF320E mov      dword ptr [ebp - 0x5d0], 0xa2bee0
