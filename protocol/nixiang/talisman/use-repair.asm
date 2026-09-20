; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 0x99ab90
0099AB90 push ebp
0099AB91 mov ebp, esp
0099AB93 sub esp, 0x98
0099AB99 push esi
0099AB9A mov dword ptr [ebp - 0x84], ecx
0099ABA0 mov eax, dword ptr [ebp - 0x84]
0099ABA6 mov ecx, dword ptr [eax + 0x168]
0099ABAC add ecx, 0x14
0099ABAF call 0x4c50a0
0099ABB4 movzx ecx, al
0099ABB7 test ecx, ecx
0099ABB9 jne 0x99acdf
0099ABBF mov edx, dword ptr [ebp - 0x84]
0099ABC5 mov ecx, dword ptr [edx + 0x16c]
0099ABCB call 0x446e60
0099ABD0 test eax, eax
0099ABD2 je 0x99acdf
0099ABD8 call 0x669a7e
0099ABDD mov esi, eax
0099ABDF mov eax, dword ptr [ebp - 0x84]
0099ABE5 mov ecx, dword ptr [eax + 0x168]
0099ABEB add ecx, 0x14
0099ABEE call 0x55f000
0099ABF3 mov ecx, eax
0099ABF5 mov eax, esi
0099ABF7 xor edx, edx
0099ABF9 div ecx
0099ABFB mov dword ptr [ebp - 8], edx
0099ABFE mov edx, dword ptr [ebp - 8]
0099AC01 push edx
0099AC02 mov eax, dword ptr [ebp - 0x84]
0099AC08 mov ecx, dword ptr [eax + 0x168]
0099AC0E add ecx, 0x14
0099AC11 call 0x491640
0099AC16 mov ecx, dword ptr [eax]
0099AC18 mov dword ptr [ebp - 4], ecx
0099AC1B cmp dword ptr [ebp - 4], 0
0099AC1F jle 0x99acdf
0099AC25 mov dword ptr [ebp - 0x24], 1
0099AC2C mov edx, dword ptr [ebp - 0x84]
0099AC32 mov ecx, dword ptr [edx + 0x168]
0099AC38 add ecx, 0x2c
0099AC3B call 0x55f000
0099AC40 cmp dword ptr [ebp - 8], eax
0099AC43 jae 0x99ac62
0099AC45 mov eax, dword ptr [ebp - 8]
0099AC48 push eax
0099AC49 mov ecx, dword ptr [ebp - 0x84]
0099AC4F mov ecx, dword ptr [ecx + 0x168]
0099AC55 add ecx, 0x2c
0099AC58 call 0x491640
0099AC5D mov edx, dword ptr [eax]
0099AC5F mov dword ptr [ebp - 0x24], edx
0099AC62 mov dword ptr [ebp - 0x20], 0
0099AC69 mov eax, dword ptr [ebp - 0x84]
0099AC6F mov ecx, dword ptr [eax + 0x168]
0099AC75 add ecx, 0x44
0099AC78 call 0x55f000
0099AC7D cmp dword ptr [ebp - 8], eax
0099AC80 jae 0x99ac9f
0099AC82 mov ecx, dword ptr [ebp - 8]
0099AC85 push ecx
0099AC86 mov edx, dword ptr [ebp - 0x84]
0099AC8C mov ecx, dword ptr [edx + 0x168]
0099AC92 add ecx, 0x44
0099AC95 call 0x491640
0099AC9A mov eax, dword ptr [eax]
0099AC9C mov dword ptr [ebp - 0x20], eax
0099AC9F mov dword ptr [ebp - 0x18], 0
0099ACA6 mov dword ptr [ebp - 0x14], 0
0099ACAD mov dword ptr [ebp - 0x10], 0
0099ACB4 mov ecx, dword ptr [ebp - 4]
0099ACB7 mov dword ptr [ebp - 0x28], ecx
0099ACBA mov dword ptr [ebp - 0xc], 0
0099ACC1 push 1
0099ACC3 lea edx, [ebp - 0x28]
0099ACC6 push edx
0099ACC7 mov eax, dword ptr [ebp - 0x84]
0099ACCD mov ecx, dword ptr [eax + 0x16c]
0099ACD3 call 0x446e60
0099ACD8 mov ecx, eax
0099ACDA call 0x9c69c0
0099ACDF mov ecx, dword ptr [ebp - 0x84]
0099ACE5 mov edx, dword ptr [ecx + 0x168]
0099ACEB cmp dword ptr [edx + 0x60], 0
0099ACEF je 0x99ad2b
0099ACF1 mov eax, dword ptr [ebp - 0x84]
0099ACF7 mov ecx, dword ptr [eax + 0x168]
0099ACFD mov edx, dword ptr [ecx + 0x60]
0099AD00 push edx
0099AD01 push 0x45a
0099AD06 mov eax, dword ptr [ebp - 0x84]
0099AD0C mov ecx, dword ptr [eax + 0x16c]
0099AD12 push ecx
0099AD13 mov edx, dword ptr [ebp - 0x84]
0099AD19 mov ecx, dword ptr [edx + 0x16c]
0099AD1F call 0x401040
0099AD24 mov ecx, eax
0099AD26 call 0x9ddce0
0099AD2B mov eax, dword ptr [ebp - 0x84]
0099AD31 mov ecx, dword ptr [eax + 0x168]
0099AD37 fld dword ptr [ecx + 0x5c]
0099AD3A fmul qword ptr [0xbe8460]
0099AD40 fstp dword ptr [ebp - 0x88]
0099AD46 fld dword ptr [ebp - 0x88]
0099AD4C push ecx
0099AD4D fstp dword ptr [esp]
0099AD50 mov edx, dword ptr [ebp - 0x84]
0099AD56 mov ecx, dword ptr [edx + 0x16c]
0099AD5C call 0x9e5180
0099AD61 mov eax, dword ptr [ebp - 0x84]
0099AD67 mov ecx, dword ptr [eax + 0x16c]
0099AD6D call 0x9e7c70
0099AD72 test eax, eax
0099AD74 je 0x99ae2d
0099AD7A mov ecx, dword ptr [ebp + 8]
0099AD7D mov dword ptr [ebp - 0x59], ecx
0099AD80 mov edx, dword ptr [ebp - 0x84]
0099AD86 mov ecx, dword ptr [edx + 0x16c]
0099AD8C call 0x401000
0099AD91 mov dword ptr [ebp - 0x45], eax
0099AD94 mov dword ptr [ebp - 0x41], edx
0099AD97 mov ecx, dword ptr [0x17c8708]
0099AD9D call 0x432440
0099ADA2 mov ecx, dword ptr [eax]
0099ADA4 mov edx, dword ptr [eax + 4]
0099ADA7 mov dword ptr [ebp - 0x3d], ecx
0099ADAA mov dword ptr [ebp - 0x39], edx
0099ADAD push 0
0099ADAF push 0
0099ADB1 push 0x4b
0099ADB3 lea eax, [ebp - 0x80]
0099ADB6 push eax
0099ADB7 push 0x2064
0099ADBC call 0xa3fbb0
0099ADC1 add esp, 0x14
0099ADC4 mov ecx, dword ptr [ebp - 0x84]
0099ADCA mov edx, dword ptr [ecx + 8]
0099ADCD mov dword ptr [ebp - 0x30], edx
0099ADD0 mov eax, dword ptr [ebp - 0x84]
0099ADD6 mov ecx, dword ptr [eax + 0x168]
0099ADDC fld dword ptr [ecx + 4]
0099ADDF fmul qword ptr [0xbe8460]
0099ADE5 fnstcw word ptr [ebp - 0x8a]
0099ADEB movzx eax, word ptr [ebp - 0x8a]
0099ADF2 or eax, 0xc00
0099ADF7 mov dword ptr [ebp - 0x90], eax
0099ADFD fldcw word ptr [ebp - 0x90]
0099AE03 fistp qword ptr [ebp - 0x98]
0099AE09 fldcw word ptr [ebp - 0x8a]
0099AE0F mov edx, dword ptr [ebp - 0x98]
0099AE15 mov dword ptr [ebp - 0x2c], edx
0099AE18 push 8
0099AE1A lea eax, [ebp - 0x30]
0099AE1D push eax
0099AE1E push 0
0099AE20 push 0x1069
0099AE25 call 0xa3c950
0099AE2A add esp, 0x10
0099AE2D call 0x4030c0
0099AE32 mov ecx, eax
0099AE34 call 0x4031a0
0099AE39 cmp eax, 2
0099AE3C je 0x99ae63
0099AE3E push 0
0099AE40 mov ecx, dword ptr [ebp + 8]
0099AE43 push ecx
0099AE44 mov edx, dword ptr [ebp - 0x84]
0099AE4A mov ecx, dword ptr [edx + 0x16c]
0099AE50 call 0x401000
0099AE55 push edx
0099AE56 push eax
0099AE57 call 0x4030c0
0099AE5C mov ecx, eax
0099AE5E call 0x931a70
0099AE63 mov eax, 1
0099AE68 pop esi
0099AE69 mov esp, ebp
0099AE6B pop ebp
0099AE6C ret 4
; FUNCTION 0x99ae70
0099AE70 push ebp
0099AE71 mov ebp, esp
0099AE73 sub esp, 0x80
0099AE79 mov dword ptr [ebp - 0x7c], ecx
0099AE7C cmp dword ptr [0x17c8710], 0
0099AE83 je 0x99affe
0099AE89 mov ecx, dword ptr [0x17c8710]
0099AE8F call 0x453db0
0099AE94 test eax, eax
0099AE96 je 0x99affe
0099AE9C mov eax, dword ptr [ebp - 0x7c]
0099AE9F mov ecx, dword ptr [eax + 0x16c]
0099AEA5 call 0x446e60
0099AEAA test eax, eax
0099AEAC je 0x99affe
0099AEB2 mov ecx, dword ptr [ebp - 0x7c]
0099AEB5 mov edx, dword ptr [ecx + 0x168]
0099AEBB cmp dword ptr [edx + 0x10], 0
0099AEBF jne 0x99aee4
0099AEC1 mov ecx, dword ptr [0x17c8710]
0099AEC7 call 0x453db0
0099AECC mov dword ptr [ebp - 0x80], eax
0099AECF mov eax, dword ptr [ebp - 0x80]
0099AED2 mov edx, dword ptr [eax]
0099AED4 mov ecx, dword ptr [ebp - 0x80]
0099AED7 mov eax, dword ptr [edx + 0x14]
0099AEDA call eax
0099AEDC imul eax, eax, 0xa
0099AEDF mov dword ptr [ebp - 0x18], eax
0099AEE2 jmp 0x99aef3
0099AEE4 mov ecx, dword ptr [ebp - 0x7c]
0099AEE7 mov edx, dword ptr [ecx + 0x168]
0099AEED mov eax, dword ptr [edx + 0x10]
0099AEF0 mov dword ptr [ebp - 0x18], eax
0099AEF3 mov dword ptr [ebp - 0x10], 0
0099AEFA mov dword ptr [ebp - 0xc], 0
0099AF01 mov ecx, dword ptr [ebp - 0x7c]
0099AF04 mov edx, dword ptr [ecx + 0x168]
0099AF0A mov eax, dword ptr [edx + 0xc]
0099AF0D mov dword ptr [ebp - 0x1c], eax
0099AF10 mov dword ptr [ebp - 8], 0
0099AF17 mov ecx, dword ptr [ebp - 0x7c]
0099AF1A mov edx, dword ptr [ecx + 0x168]
0099AF20 mov eax, dword ptr [edx + 8]
0099AF23 mov dword ptr [ebp - 0x20], eax
0099AF26 mov ecx, dword ptr [ebp - 0x7c]
0099AF29 mov edx, dword ptr [ecx + 0x16c]
0099AF2F mov dword ptr [ebp - 4], edx
0099AF32 push 1
0099AF34 lea eax, [ebp - 0x20]
0099AF37 push eax
0099AF38 mov ecx, dword ptr [ebp - 0x7c]
0099AF3B mov ecx, dword ptr [ecx + 0x16c]
0099AF41 call 0x446e60
0099AF46 mov ecx, eax
0099AF48 call 0x9c69c0
0099AF4D mov edx, dword ptr [ebp - 0x7c]
0099AF50 mov ecx, dword ptr [edx + 0x16c]
0099AF56 call 0x9e7c70
0099AF5B test eax, eax
0099AF5D je 0x99afc4
0099AF5F mov eax, dword ptr [ebp + 8]
0099AF62 mov dword ptr [ebp - 0x51], eax
0099AF65 mov ecx, dword ptr [ebp - 0x7c]
0099AF68 mov ecx, dword ptr [ecx + 0x16c]
0099AF6E call 0x401000
0099AF73 mov dword ptr [ebp - 0x3d], eax
0099AF76 mov dword ptr [ebp - 0x39], edx
0099AF79 mov ecx, dword ptr [0x17c8708]
0099AF7F call 0x432440
0099AF84 mov edx, dword ptr [eax]
0099AF86 mov eax, dword ptr [eax + 4]
0099AF89 mov dword ptr [ebp - 0x35], edx
0099AF8C mov dword ptr [ebp - 0x31], eax
0099AF8F push 0
0099AF91 push 0
0099AF93 push 0x4b
0099AF95 lea ecx, [ebp - 0x78]
0099AF98 push ecx
0099AF99 push 0x2063
0099AF9E call 0xa3fbb0
0099AFA3 add esp, 0x14
0099AFA6 mov edx, dword ptr [ebp - 0x7c]
0099AFA9 mov eax, dword ptr [edx + 8]
0099AFAC mov dword ptr [ebp - 0x28], eax
0099AFAF push 8
0099AFB1 lea ecx, [ebp - 0x28]
0099AFB4 push ecx
0099AFB5 push 0
0099AFB7 push 0x1069
0099AFBC call 0xa3c950
0099AFC1 add esp, 0x10
0099AFC4 call 0x4030c0
0099AFC9 mov ecx, eax
0099AFCB call 0x4031a0
0099AFD0 cmp eax, 2
0099AFD3 je 0x99aff7
0099AFD5 push 1
0099AFD7 mov edx, dword ptr [ebp + 8]
0099AFDA push edx
0099AFDB mov eax, dword ptr [ebp - 0x7c]
0099AFDE mov ecx, dword ptr [eax + 0x16c]
0099AFE4 call 0x401000
0099AFE9 push edx
0099AFEA push eax
0099AFEB call 0x4030c0
0099AFF0 mov ecx, eax
0099AFF2 call 0x931a70
0099AFF7 mov eax, 1
0099AFFC jmp 0x99b000
0099AFFE xor eax, eax
0099B000 mov esp, ebp
0099B002 pop ebp
0099B003 ret 4
; FUNCTION 0x873f30
00873F30 push ebp
00873F31 mov ebp, esp
00873F33 sub esp, 8
00873F36 mov dword ptr [ebp - 8], ecx
00873F39 push 4
00873F3B push 0
00873F3D lea eax, [ebp - 4]
00873F40 push eax
00873F41 call 0x666960
00873F46 add esp, 0xc
00873F49 mov ecx, dword ptr [ebp - 8]
00873F4C mov edx, dword ptr [ecx + 0x5d4]
00873F52 mov dword ptr [ebp - 4], edx
00873F55 push 4
00873F57 lea eax, [ebp - 4]
00873F5A push eax
00873F5B push 0
00873F5D push 0x106a
00873F62 call 0xa3c950
00873F67 add esp, 0x10
00873F6A mov ecx, dword ptr [ebp - 8]
00873F6D call 0x89b9c0
00873F72 mov esp, ebp
00873F74 pop ebp
00873F75 ret
; FUNCTION 0x874360
00874360 push ebp
00874361 mov ebp, esp
00874363 sub esp, 0x10
00874366 mov dword ptr [ebp - 0x10], ecx
00874369 push 0xc
0087436B push 0
0087436D lea eax, [ebp - 0xc]
00874370 push eax
00874371 call 0x666960
00874376 add esp, 0xc
00874379 mov ecx, dword ptr [ebp - 0x10]
0087437C mov edx, dword ptr [ecx + 0x578]
00874382 mov dword ptr [ebp - 0xc], edx
00874385 mov eax, dword ptr [ebp - 0x10]
00874388 mov ecx, dword ptr [eax + 0x580]
0087438E mov dword ptr [ebp - 8], ecx
00874391 push 0xc
00874393 lea edx, [ebp - 0xc]
00874396 push edx
00874397 push 0
00874399 push 0x106c
0087439E call 0xa3c950
008743A3 add esp, 0x10
008743A6 mov eax, dword ptr [ebp - 0x10]
008743A9 mov edx, dword ptr [eax]
008743AB mov ecx, dword ptr [ebp - 0x10]
008743AE mov eax, dword ptr [edx + 0x11c]
008743B4 call eax
008743B6 mov esp, ebp
008743B8 pop ebp
008743B9 ret
