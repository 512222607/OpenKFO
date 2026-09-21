; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; FUNCTION 00A44340
00A44340 push ebp
00A44341 mov ebp, esp
00A44343 sub esp, 0x24
00A44346 mov dword ptr [ebp - 0x24], ecx
00A44349 lea eax, [ebp + 8]
00A4434C push eax
00A4434D lea ecx, [ebp - 8]
00A44350 push ecx
00A44351 mov ecx, dword ptr [ebp - 0x24]
00A44354 add ecx, 0x20
00A44357 call 0x5658d0
00A4435C lea edx, [ebp - 0x10]
00A4435F push edx
00A44360 mov ecx, dword ptr [ebp - 0x24]
00A44363 add ecx, 0x20
00A44366 call 0x45abb0
00A4436B push eax
00A4436C lea ecx, [ebp - 8]
00A4436F call 0x4ab920
00A44374 movzx eax, al
00A44377 test eax, eax
00A44379 je 0xa4437f
00A4437B xor al, al
00A4437D jmp 0xa443a4
00A4437F mov ecx, dword ptr [ebp - 8]
00A44382 mov dword ptr [ebp - 0x18], ecx
00A44385 mov edx, dword ptr [ebp - 4]
00A44388 mov dword ptr [ebp - 0x14], edx
00A4438B mov eax, dword ptr [ebp - 0x14]
00A4438E push eax
00A4438F mov ecx, dword ptr [ebp - 0x18]
00A44392 push ecx
00A44393 lea edx, [ebp - 0x20]
00A44396 push edx
00A44397 mov ecx, dword ptr [ebp - 0x24]
00A4439A add ecx, 0x20
00A4439D call 0x565090
00A443A2 mov al, 1
00A443A4 mov esp, ebp
00A443A6 pop ebp
00A443A7 ret 0xc

; FUNCTION 00A443B0
00A443B0 push ebp
00A443B1 mov ebp, esp
00A443B3 sub esp, 0x18
00A443B6 push esi
00A443B7 push edi
00A443B8 mov dword ptr [ebp - 0x18], ecx
00A443BB cmp dword ptr [ebp + 8], 0
00A443BF jne 0xa443c8
00A443C1 xor al, al
00A443C3 jmp 0xa44463
00A443C8 mov eax, dword ptr [ebp + 8]
00A443CB mov ecx, dword ptr [eax + 0x2f]
00A443CE push ecx
00A443CF mov ecx, dword ptr [0x17c8710]
00A443D5 call 0x4b4f50
00A443DA mov ecx, eax
00A443DC call 0x633a40
00A443E1 mov ecx, eax
00A443E3 call 0x999d90
00A443E8 mov dword ptr [ebp - 4], eax
00A443EB cmp dword ptr [ebp - 4], 0
00A443EF jne 0xa443f5
00A443F1 xor al, al
00A443F3 jmp 0xa44463
00A443F5 mov ecx, dword ptr [ebp - 4]
00A443F8 call 0x99a140
00A443FD movzx edx, al
00A44400 test edx, edx
00A44402 je 0xa44408
00A44404 xor al, al
00A44406 jmp 0xa44463
00A44408 lea eax, [ebp - 0x14]
00A4440B push eax
00A4440C mov ecx, dword ptr [ebp - 0x18]
00A4440F add ecx, 0x20
00A44412 call 0x45abb0
00A44417 push eax
00A44418 mov ecx, dword ptr [ebp + 8]
00A4441B add ecx, 0x2f
00A4441E push ecx
00A4441F lea edx, [ebp - 0xc]
00A44422 push edx
00A44423 mov ecx, dword ptr [ebp - 0x18]
00A44426 add ecx, 0x20
00A44429 call 0x5658d0
00A4442E mov ecx, eax
00A44430 call 0x4ab8f0
00A44435 movzx eax, al
00A44438 test eax, eax
00A4443A je 0xa44440
00A4443C xor al, al
00A4443E jmp 0xa44463
00A44440 mov esi, dword ptr [ebp + 8]
00A44443 mov ecx, dword ptr [ebp + 8]
00A44446 add ecx, 0x2f
00A44449 push ecx
00A4444A mov ecx, dword ptr [ebp - 0x18]
00A4444D add ecx, 0x20
00A44450 call 0x564f60
00A44455 mov ecx, 0xd
00A4445A mov edi, eax
00A4445C rep movsd dword ptr es:[edi], dword ptr [esi]
00A4445E movsw word ptr es:[edi], word ptr [esi]
00A44460 movsb byte ptr es:[edi], byte ptr [esi]
00A44461 mov al, 1
00A44463 pop edi
00A44464 pop esi
00A44465 mov esp, ebp
00A44467 pop ebp
00A44468 ret 4

; FUNCTION 00A44470
00A44470 push ebp
00A44471 mov ebp, esp
00A44473 sub esp, 0x24
00A44476 mov dword ptr [ebp - 0x24], ecx
00A44479 lea eax, [ebp + 8]
00A4447C push eax
00A4447D lea ecx, [ebp - 8]
00A44480 push ecx
00A44481 mov ecx, dword ptr [ebp - 0x24]
00A44484 call 0x564ec0
00A44489 lea edx, [ebp - 0x10]
00A4448C push edx
00A4448D mov ecx, dword ptr [ebp - 0x24]
00A44490 call 0x45abb0
00A44495 push eax
00A44496 lea ecx, [ebp - 8]
00A44499 call 0x4ab920
00A4449E movzx eax, al
00A444A1 test eax, eax
00A444A3 je 0xa444a9
00A444A5 xor eax, eax
00A444A7 jmp 0xa444ce
00A444A9 mov ecx, dword ptr [ebp - 8]
00A444AC mov dword ptr [ebp - 0x18], ecx
00A444AF mov edx, dword ptr [ebp - 4]
00A444B2 mov dword ptr [ebp - 0x14], edx
00A444B5 mov eax, dword ptr [ebp - 0x14]
00A444B8 push eax
00A444B9 mov ecx, dword ptr [ebp - 0x18]
00A444BC push ecx
00A444BD lea edx, [ebp - 0x20]
00A444C0 push edx
00A444C1 mov ecx, dword ptr [ebp - 0x24]
00A444C4 call 0x564680
00A444C9 mov eax, 1
00A444CE mov esp, ebp
00A444D0 pop ebp
00A444D1 ret 0xc

; FUNCTION 00A444E0
00A444E0 push ebp
00A444E1 mov ebp, esp
00A444E3 sub esp, 0x18
00A444E6 push esi
00A444E7 push edi
00A444E8 mov dword ptr [ebp - 0x18], ecx
00A444EB cmp dword ptr [ebp + 8], 0
00A444EF jne 0xa444f8
00A444F1 xor eax, eax
00A444F3 jmp 0xa4458a
00A444F8 mov eax, dword ptr [ebp + 8]
00A444FB mov ecx, dword ptr [eax + 0x2f]
00A444FE push ecx
00A444FF mov ecx, dword ptr [0x17c8710]
00A44505 call 0x4b4f50
00A4450A mov ecx, eax
00A4450C call 0x453f50
00A44511 mov ecx, eax
00A44513 call 0x9b9ba0
00A44518 mov dword ptr [ebp - 4], eax
00A4451B cmp dword ptr [ebp - 4], 0
00A4451F jne 0xa44525
00A44521 xor eax, eax
00A44523 jmp 0xa4458a
00A44525 mov ecx, dword ptr [ebp - 4]
00A44528 call 0x9bbf00
00A4452D test eax, eax
00A4452F jne 0xa44535
00A44531 xor eax, eax
00A44533 jmp 0xa4458a
00A44535 lea edx, [ebp - 0x14]
00A44538 push edx
00A44539 mov ecx, dword ptr [ebp - 0x18]
00A4453C call 0x45abb0
00A44541 push eax
00A44542 mov eax, dword ptr [ebp + 8]
00A44545 add eax, 0x2f
00A44548 push eax
00A44549 lea ecx, [ebp - 0xc]
00A4454C push ecx
00A4454D mov ecx, dword ptr [ebp - 0x18]
00A44550 call 0x564ec0
00A44555 mov ecx, eax
00A44557 call 0x4ab8f0
00A4455C movzx edx, al
00A4455F test edx, edx
00A44561 je 0xa44567
00A44563 xor eax, eax
00A44565 jmp 0xa4458a
00A44567 mov esi, dword ptr [ebp + 8]
00A4456A mov eax, dword ptr [ebp + 8]
00A4456D add eax, 0x2f
00A44570 push eax
00A44571 mov ecx, dword ptr [ebp - 0x18]
00A44574 call 0x564550
00A44579 mov ecx, 0xf
00A4457E mov edi, eax
00A44580 rep movsd dword ptr es:[edi], dword ptr [esi]
00A44582 movsw word ptr es:[edi], word ptr [esi]
00A44584 movsb byte ptr es:[edi], byte ptr [esi]
00A44585 mov eax, 1
00A4458A pop edi
00A4458B pop esi
00A4458C mov esp, ebp
00A4458E pop ebp
00A4458F ret 4

; FUNCTION 00A44600
00A44600 push ebp
00A44601 mov ebp, esp
00A44603 push -1
00A44605 push 0xaa398a
00A4460A mov eax, dword ptr fs:[0]
00A44610 push eax
00A44611 push ecx
00A44612 mov eax, dword ptr [0xc7b480]
00A44617 xor eax, ebp
00A44619 push eax
00A4461A lea eax, [ebp - 0xc]
00A4461D mov dword ptr fs:[0], eax
00A44623 mov dword ptr [ebp - 0x10], ecx
00A44626 mov dword ptr [ebp - 4], 0
00A4462D mov ecx, dword ptr [ebp - 0x10]
00A44630 add ecx, 0x20
00A44633 call 0x564530
00A44638 mov dword ptr [ebp - 4], 0xffffffff
00A4463F mov ecx, dword ptr [ebp - 0x10]
00A44642 call 0x564510
00A44647 mov ecx, dword ptr [ebp - 0xc]
00A4464A mov dword ptr fs:[0], ecx
00A44651 pop ecx
00A44652 mov esp, ebp
00A44654 pop ebp
00A44655 ret

; FUNCTION 00564EC0
00564EC0 push ebp
00564EC1 mov ebp, esp
00564EC3 sub esp, 0x24
00564EC6 mov dword ptr [ebp - 0x20], ecx
00564EC9 mov eax, dword ptr [ebp + 0xc]
00564ECC push eax
00564ECD lea ecx, [ebp - 8]
00564ED0 push ecx
00564ED1 mov ecx, dword ptr [ebp - 0x20]
00564ED4 call 0x565f90
00564ED9 lea edx, [ebp - 0x14]
00564EDC push edx
00564EDD mov ecx, dword ptr [ebp - 0x20]
00564EE0 call 0x45abb0
00564EE5 push eax
00564EE6 lea ecx, [ebp - 8]
00564EE9 call 0x4ab920
00564EEE movzx eax, al
00564EF1 test eax, eax
00564EF3 jne 0x564f25
00564EF5 lea ecx, [ebp - 8]
00564EF8 call 0x4b4f50
00564EFD push eax
00564EFE call 0x4cecc0
00564F03 add esp, 4
00564F06 push eax
00564F07 mov ecx, dword ptr [ebp + 0xc]
00564F0A push ecx
00564F0B mov ecx, dword ptr [ebp - 0x20]
00564F0E add ecx, 8
00564F11 call 0x4c5f20
00564F16 movzx edx, al
00564F19 test edx, edx
00564F1B jne 0x564f25
00564F1D lea eax, [ebp - 8]
00564F20 mov dword ptr [ebp - 0x24], eax
00564F23 jmp 0x564f34
00564F25 lea ecx, [ebp - 0x1c]
00564F28 push ecx
00564F29 mov ecx, dword ptr [ebp - 0x20]
00564F2C call 0x45abb0
00564F31 mov dword ptr [ebp - 0x24], eax
00564F34 mov edx, dword ptr [ebp - 0x24]
00564F37 mov dword ptr [ebp - 0xc], edx
00564F3A mov eax, dword ptr [ebp - 0xc]
00564F3D mov ecx, dword ptr [eax]
00564F3F mov edx, dword ptr [eax + 4]
00564F42 mov eax, dword ptr [ebp + 8]
00564F45 mov dword ptr [eax], ecx
00564F47 mov dword ptr [eax + 4], edx
00564F4A mov eax, dword ptr [ebp + 8]
00564F4D mov esp, ebp
00564F4F pop ebp
00564F50 ret 8

; FUNCTION 005658D0
005658D0 push ebp
005658D1 mov ebp, esp
005658D3 sub esp, 0x24
005658D6 mov dword ptr [ebp - 0x20], ecx
005658D9 mov eax, dword ptr [ebp + 0xc]
005658DC push eax
005658DD lea ecx, [ebp - 8]
005658E0 push ecx
005658E1 mov ecx, dword ptr [ebp - 0x20]
005658E4 call 0x5667d0
005658E9 lea edx, [ebp - 0x14]
005658EC push edx
005658ED mov ecx, dword ptr [ebp - 0x20]
005658F0 call 0x45abb0
005658F5 push eax
005658F6 lea ecx, [ebp - 8]
005658F9 call 0x4ab920
005658FE movzx eax, al
00565901 test eax, eax
00565903 jne 0x565935
00565905 lea ecx, [ebp - 8]
00565908 call 0x4b4f50
0056590D push eax
0056590E call 0x4cecc0
00565913 add esp, 4
00565916 push eax
00565917 mov ecx, dword ptr [ebp + 0xc]
0056591A push ecx
0056591B mov ecx, dword ptr [ebp - 0x20]
0056591E add ecx, 8
00565921 call 0x4c5f20
00565926 movzx edx, al
00565929 test edx, edx
0056592B jne 0x565935
0056592D lea eax, [ebp - 8]
00565930 mov dword ptr [ebp - 0x24], eax
00565933 jmp 0x565944
00565935 lea ecx, [ebp - 0x1c]
00565938 push ecx
00565939 mov ecx, dword ptr [ebp - 0x20]
0056593C call 0x45abb0
00565941 mov dword ptr [ebp - 0x24], eax
00565944 mov edx, dword ptr [ebp - 0x24]
00565947 mov dword ptr [ebp - 0xc], edx
0056594A mov eax, dword ptr [ebp - 0xc]
0056594D mov ecx, dword ptr [eax]
0056594F mov edx, dword ptr [eax + 4]
00565952 mov eax, dword ptr [ebp + 8]
00565955 mov dword ptr [eax], ecx
00565957 mov dword ptr [eax + 4], edx
0056595A mov eax, dword ptr [ebp + 8]
0056595D mov esp, ebp
0056595F pop ebp
00565960 ret 8

; FUNCTION 004C5F20
004C5F20 push ebp
004C5F21 mov ebp, esp
004C5F23 push ecx
004C5F24 mov dword ptr [ebp - 4], ecx
004C5F27 mov eax, dword ptr [ebp + 8]
004C5F2A mov ecx, dword ptr [ebp + 0xc]
004C5F2D mov edx, dword ptr [eax]
004C5F2F cmp edx, dword ptr [ecx]
004C5F31 sbb eax, eax
004C5F33 neg eax
004C5F35 mov esp, ebp
004C5F37 pop ebp
004C5F38 ret 8

; FUNCTION 00565F90
00565F90 push ebp
00565F91 mov ebp, esp
00565F93 push ecx
00565F94 mov dword ptr [ebp - 4], ecx
00565F97 mov eax, dword ptr [ebp - 4]
00565F9A push eax
00565F9B mov ecx, dword ptr [ebp + 0xc]
00565F9E push ecx
00565F9F mov ecx, dword ptr [ebp - 4]
00565FA2 call 0x567150
00565FA7 push eax
00565FA8 mov ecx, dword ptr [ebp + 8]
00565FAB call 0x4177c0
00565FB0 mov eax, dword ptr [ebp + 8]
00565FB3 mov esp, ebp
00565FB5 pop ebp
00565FB6 ret 8

; FUNCTION 005667D0
005667D0 push ebp
005667D1 mov ebp, esp
005667D3 push ecx
005667D4 mov dword ptr [ebp - 4], ecx
005667D7 mov eax, dword ptr [ebp - 4]
005667DA push eax
005667DB mov ecx, dword ptr [ebp + 0xc]
005667DE push ecx
005667DF mov ecx, dword ptr [ebp - 4]
005667E2 call 0x5678e0
005667E7 push eax
005667E8 mov ecx, dword ptr [ebp + 8]
005667EB call 0x4177c0
005667F0 mov eax, dword ptr [ebp + 8]
005667F3 mov esp, ebp
005667F5 pop ebp
005667F6 ret 8
