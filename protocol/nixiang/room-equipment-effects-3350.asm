; Current gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 3350 registration, consumer, and equipped-item visual effect rebuild.
00B267C5 mov dword ptr [0x12fec28], 0xd16
00B267CF mov dword ptr [0x12fec2c], 1
00B267D9 mov dword ptr [ebp - 0xd0], 0x81f270
00B267E3 mov dword ptr [ebp - 0xcc], 0
00B267ED mov dword ptr [ebp - 0xc8], 0
00B267F7 mov dword ptr [ebp - 0xc4], 0
00B26801 mov eax, dword ptr [ebp - 0xd0]
00B26807 mov dword ptr [0x12fec30], eax
00B2680C mov ecx, dword ptr [ebp - 0xcc]
00B26812 mov dword ptr [0x12fec34], ecx
00B26818 mov edx, dword ptr [ebp - 0xc8]
00B2681E mov dword ptr [0x12fec38], edx
00B26824 mov eax, dword ptr [ebp - 0xc4]
00B2682A mov dword ptr [0x12fec3c], eax
00B2682F mov dword ptr [0x12fec40], 0x8de
0081F270 push ebp
0081F271 mov ebp, esp
0081F273 sub esp, 0xf28
0081F279 mov eax, dword ptr [0xc7b480]
0081F27E xor eax, ebp
0081F280 mov dword ptr [ebp - 8], eax
0081F283 push esi
0081F284 push edi
0081F285 mov dword ptr [ebp - 0xf24], ecx
0081F28B cmp dword ptr [ebp + 8], 0
0081F28F jne 0x81f296
0081F291 jmp 0x81f545
0081F296 mov eax, dword ptr [ebp + 8]
0081F299 mov dword ptr [ebp - 0x57c], eax
0081F29F mov ecx, dword ptr [ebp - 0x57c]
0081F2A5 movzx edx, byte ptr [ecx + 0x10]
0081F2A9 mov dword ptr [0x17c86d4], edx
0081F2AF mov eax, dword ptr [ebp - 0x57c]
0081F2B5 mov ecx, dword ptr [eax + 0x11]
0081F2B8 mov dword ptr [ebp - 4], ecx
0081F2BB mov edx, dword ptr [ebp - 0x57c]
0081F2C1 add edx, 0x15
0081F2C4 mov dword ptr [ebp - 0x574], edx
0081F2CA mov eax, dword ptr [ebp - 0x57c]
0081F2D0 mov ecx, dword ptr [eax + 4]
0081F2D3 push ecx
0081F2D4 mov edx, dword ptr [eax]
0081F2D6 push edx
0081F2D7 mov ecx, dword ptr [0x17c8708]
0081F2DD call 0x818c70
0081F2E2 mov dword ptr [ebp - 0x578], eax
0081F2E8 lea ecx, [ebp - 0x570]
0081F2EE call 0x511aa0
0081F2F3 lea eax, [ebp - 0x570]
0081F2F9 push eax
0081F2FA mov ecx, dword ptr [ebp - 0x57c]
0081F300 mov edx, dword ptr [ecx + 4]
0081F303 push edx
0081F304 mov eax, dword ptr [ecx]
0081F306 push eax
0081F307 mov ecx, dword ptr [0x17c8708]
0081F30D call 0x511850
0081F312 mov byte ptr [ebp - 0x57d], al
0081F318 cmp dword ptr [ebp - 0x578], 0
0081F31F jne 0x81f331
0081F321 movzx ecx, byte ptr [ebp - 0x57d]
0081F328 test ecx, ecx
0081F32A jne 0x81f331
0081F32C jmp 0x81f545
0081F331 cmp dword ptr [ebp - 0x578], 0
0081F338 je 0x81f4d1
0081F33E mov edx, dword ptr [ebp - 4]
0081F341 push edx
0081F342 mov ecx, dword ptr [ebp - 0x578]
0081F348 call 0x54ab50
0081F34D cmp dword ptr [0x17c86d4], 0
0081F354 setne al
0081F357 movzx ecx, al
0081F35A push ecx
0081F35B mov ecx, dword ptr [ebp - 0x578]
0081F361 call 0x5118e0
0081F366 mov edx, dword ptr [ebp - 0x574]
0081F36C movzx eax, byte ptr [edx + 4]
0081F370 cmp eax, 0x4f
0081F373 jne 0x81f38a
0081F375 mov ecx, dword ptr [ebp - 0x574]
0081F37B mov edx, dword ptr [ecx + 5]
0081F37E push edx
0081F37F mov ecx, dword ptr [ebp - 0x578]
0081F385 call 0x54ab70
0081F38A mov ecx, dword ptr [ebp - 0x578]
0081F390 call 0x4537c0
0081F395 mov ecx, 0x134
0081F39A mov esi, eax
0081F39C lea edi, [ebp - 0xa50]
0081F3A2 rep movsd dword ptr es:[edi], dword ptr [esi]
0081F3A4 mov eax, dword ptr [ebp - 0x57c]
0081F3AA movzx ecx, byte ptr [eax + 9]
0081F3AE push ecx
0081F3AF mov edx, dword ptr [ebp - 0x57c]
0081F3B5 movzx eax, byte ptr [edx + 8]
0081F3B9 push eax
0081F3BA mov ecx, dword ptr [ebp - 0x57c]
0081F3C0 movzx edx, byte ptr [ecx + 0xb]
0081F3C4 push edx
0081F3C5 mov eax, dword ptr [ebp - 0x574]
0081F3CB push eax
0081F3CC lea ecx, [ebp - 0xa50]
0081F3D2 push ecx
0081F3D3 call 0xa3e680
0081F3D8 add esp, 0x14
0081F3DB push 0
0081F3DD lea edx, [ebp - 0xa50]
0081F3E3 push edx
0081F3E4 mov ecx, dword ptr [ebp - 0x578]
0081F3EA call 0x9f3540
0081F3EF push 0
0081F3F1 mov ecx, dword ptr [ebp - 0x578]
0081F3F7 call 0x9ef920
0081F3FC push 0
0081F3FE push 0x1389
0081F403 mov eax, dword ptr [ebp - 0x578]
0081F409 push eax
0081F40A mov ecx, dword ptr [ebp - 0x578]
0081F410 call 0x401040
0081F415 mov ecx, eax
0081F417 call 0x9ddce0
0081F41C mov ecx, dword ptr [ebp - 0x578]
0081F422 call 0x9fac40
0081F427 mov ecx, dword ptr [ebp - 0x578]
0081F42D call 0x9e7c70
0081F432 test eax, eax
0081F434 je 0x81f454
0081F436 call 0x41bd60
0081F43B mov ecx, eax
0081F43D call 0x7d1d30
0081F442 movzx ecx, al
0081F445 test ecx, ecx
0081F447 je 0x81f454
0081F449 mov ecx, dword ptr [0x17c86fc]
0081F44F call 0x9d1410
0081F454 mov edx, dword ptr [ebp - 0x57c]
0081F45A mov eax, dword ptr [edx + 0xc]
0081F45D push eax
0081F45E mov ecx, dword ptr [ebp - 0x578]
0081F464 call 0x54ab30
0081F469 mov ecx, dword ptr [0x17c8708]
0081F46F call 0x81b800
0081F474 mov dword ptr [ebp - 0xf28], eax
0081F47A mov ecx, dword ptr [ebp - 0x578]
0081F480 push ecx
0081F481 mov ecx, dword ptr [0x17c8708]
0081F487 call 0x817bc0
0081F48C push eax
0081F48D mov edx, dword ptr [ebp - 0x578]
0081F493 push edx
0081F494 mov eax, dword ptr [ebp - 0xf28]
0081F49A mov edx, dword ptr [eax]
0081F49C mov ecx, dword ptr [ebp - 0xf28]
0081F4A2 mov eax, dword ptr [edx + 0x1c0]
0081F4A8 call eax
0081F4AA mov ecx, dword ptr [ebp - 0x57c]
0081F4B0 movzx edx, byte ptr [ecx + 8]
0081F4B4 push edx
0081F4B5 mov eax, dword ptr [ebp - 0x578]
0081F4BB push eax
0081F4BC mov ecx, dword ptr [ebp - 0xf24]
0081F4C2 mov edx, dword ptr [ecx]
0081F4C4 mov ecx, dword ptr [ebp - 0xf24]
0081F4CA mov eax, dword ptr [edx + 0x2c]
0081F4CD call eax
0081F4CF jmp 0x81f545
0081F4D1 mov ecx, 0x134
0081F4D6 lea esi, [ebp - 0x4d8]
0081F4DC lea edi, [ebp - 0xf20]
0081F4E2 rep movsd dword ptr es:[edi], dword ptr [esi]
0081F4E4 mov ecx, dword ptr [ebp - 0x57c]
0081F4EA movzx edx, byte ptr [ecx + 9]
0081F4EE push edx
0081F4EF mov eax, dword ptr [ebp - 0x57c]
0081F4F5 movzx ecx, byte ptr [eax + 8]
0081F4F9 push ecx
0081F4FA mov edx, dword ptr [ebp - 0x57c]
0081F500 movzx eax, byte ptr [edx + 0xb]
0081F504 push eax
0081F505 mov ecx, dword ptr [ebp - 0x574]
0081F50B push ecx
0081F50C lea edx, [ebp - 0xf20]
0081F512 push edx
0081F513 call 0xa3e680
0081F518 add esp, 0x14
0081F51B push 0
0081F51D push 0
0081F51F lea eax, [ebp - 0xf20]
0081F525 push eax
0081F526 lea ecx, [ebp - 0x570]
0081F52C push ecx
0081F52D mov edx, dword ptr [ebp - 0x57c]
0081F533 mov eax, dword ptr [edx + 4]
0081F536 push eax
0081F537 mov ecx, dword ptr [edx]
0081F539 push ecx
0081F53A mov ecx, dword ptr [0x17c8708]
0081F540 call 0x81be60
0081F545 pop edi
0081F546 pop esi
0081F547 mov ecx, dword ptr [ebp - 8]
0081F54A xor ecx, ebp
0081F54C call 0x6634fb
0081F551 mov esp, ebp
0081F553 pop ebp
0081F554 ret 8
0081F557 int3
0081F558 int3
0081F559 int3
0081F55A int3
0081F55B int3
0081F55C int3
0081F55D int3
0081F55E int3
0081F55F int3
0081F560 push ebp
0081F561 mov ebp, esp
0081F563 push ecx
009FAC40 push ebp
009FAC41 mov ebp, esp
009FAC43 sub esp, 8
009FAC46 mov dword ptr [ebp - 8], ecx
009FAC49 mov ecx, dword ptr [ebp - 8]
009FAC4C call 0x44b260
009FAC51 push eax
009FAC52 call 0x44a8d0
009FAC57 mov ecx, eax
009FAC59 call 0x44a960
009FAC5E mov dword ptr [ebp - 4], eax
009FAC61 cmp dword ptr [ebp - 4], 0
009FAC65 je 0x9fac75
009FAC67 push ecx
009FAC68 fldz
009FAC6A fstp dword ptr [esp]
009FAC6D mov ecx, dword ptr [ebp - 4]
009FAC70 call 0xa0bc70
009FAC75 mov ecx, dword ptr [ebp - 8]
009FAC78 call 0x9edf20
009FAC7D mov esp, ebp
009FAC7F pop ebp
009FAC80 ret
009EE1F4 mov ecx, dword ptr [ebp - 0x1c]
009EE1F7 call 0x44e0d0
009EE1FC mov ecx, eax
009EE1FE call 0x561d00
009EE203 mov ecx, dword ptr [eax + 0x271]
009EE209 push ecx
009EE20A call 0xa21b30
009EE20F mov ecx, eax
009EE211 call 0xa1e560
009EE216 mov dword ptr [ebp - 0x10], eax
009EE219 cmp dword ptr [ebp - 0x10], 0
009EE21D je 0x9ee253
009EE21F mov ecx, dword ptr [ebp - 0x10]
009EE222 add ecx, 0x100
009EE228 call 0x406450
009EE22D movzx edx, al
009EE230 test edx, edx
009EE232 jne 0x9ee253
009EE234 mov ecx, dword ptr [ebp - 0x10]
009EE237 add ecx, 0x100
009EE23D call 0x406410
009EE242 push eax
009EE243 push 0x25
009EE245 mov eax, dword ptr [ebp - 0x1c]
009EE248 mov ecx, dword ptr [eax + 0x1a8c]
009EE24E call 0xa6ce30
009EE253 mov ecx, dword ptr [ebp - 0x1c]
009EE256 call 0x44e0d0
009EE25B mov ecx, eax
009EE25D call 0x561d00
009EE262 mov ecx, dword ptr [eax + 0x2b5]
009EE268 push ecx
009EE269 call 0xa21b30
009EE26E mov ecx, eax
009EE270 call 0xa1e560
009EE275 mov dword ptr [ebp - 0x10], eax
009EE278 cmp dword ptr [ebp - 0x10], 0
009EE27C je 0x9ee2b2
009EE27E mov ecx, dword ptr [ebp - 0x10]
009EE281 add ecx, 0x100
009EE287 call 0x406450
009EE28C movzx edx, al
009EE28F test edx, edx
009EE291 jne 0x9ee2b2
009EE293 mov ecx, dword ptr [ebp - 0x10]
009EE296 add ecx, 0x100
009EE29C call 0x406410
009EE2A1 push eax
009EE2A2 push 0x26
009EE2A4 mov eax, dword ptr [ebp - 0x1c]
009EE2A7 mov ecx, dword ptr [eax + 0x1a8c]
009EE2AD call 0xa6ce30
