; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 1410 consumer and renewable-items row display; no payment semantics inferred.
; RANGE 008269C0-00826AAA
008269C0 push ebp
008269C1 mov ebp, esp
008269C3 push -1
008269C5 push 0xadad8e
008269CA mov eax, dword ptr fs:[0]
008269D0 push eax
008269D1 sub esp, 0x74
008269D4 mov eax, dword ptr [0xc7b480]
008269D9 xor eax, ebp
008269DB push eax
008269DC lea eax, [ebp - 0xc]
008269DF mov dword ptr fs:[0], eax
008269E5 mov dword ptr [ebp - 0x80], ecx
008269E8 mov eax, dword ptr [ebp + 8]
008269EB mov dword ptr [ebp - 0x2c], eax
008269EE mov eax, dword ptr [ebp + 0xc]
008269F1 xor edx, edx
008269F3 mov ecx, 0x7c
008269F8 div ecx
008269FA mov dword ptr [ebp - 0x30], eax
008269FD lea ecx, [ebp - 0x28]
00826A00 call 0x504de0
00826A05 mov dword ptr [ebp - 4], 0
00826A0C mov dword ptr [ebp - 0x34], 0
00826A13 jmp 0x826a27
00826A15 mov edx, dword ptr [ebp - 0x34]
00826A18 add edx, 1
00826A1B mov dword ptr [ebp - 0x34], edx
00826A1E mov eax, dword ptr [ebp - 0x2c]
00826A21 add eax, 0x7c
00826A24 mov dword ptr [ebp - 0x2c], eax
00826A27 mov ecx, dword ptr [ebp - 0x34]
00826A2A cmp ecx, dword ptr [ebp - 0x30]
00826A2D jge 0x826a6f
00826A2F mov edx, dword ptr [ebp - 0x2c]
00826A32 mov eax, dword ptr [edx + 8]
00826A35 push eax
00826A36 lea ecx, [ebp - 0x7c]
00826A39 push ecx
00826A3A mov ecx, dword ptr [0x17c86fc]
00826A40 call 0x9cd840
00826A45 mov edx, dword ptr [ebp - 0x2c]
00826A48 mov eax, dword ptr [edx + 0xc]
00826A4B mov dword ptr [ebp - 0x69], eax
00826A4E lea ecx, [ebp - 0x7c]
00826A51 push ecx
00826A52 mov edx, dword ptr [ebp - 0x7c]
00826A55 push edx
00826A56 mov ecx, dword ptr [0x17c86fc]
00826A5C call 0x9ce660
00826A61 mov eax, dword ptr [ebp - 0x2c]
00826A64 push eax
00826A65 lea ecx, [ebp - 0x28]
00826A68 call 0x548fe0
00826A6D jmp 0x826a15
00826A6F lea ecx, [ebp - 0x28]
00826A72 push ecx
00826A73 call 0x4e76b0
00826A78 mov ecx, eax
00826A7A call 0x8bbc20
00826A7F mov edx, dword ptr [ebp - 0x80]
00826A82 mov eax, dword ptr [edx]
00826A84 mov ecx, dword ptr [ebp - 0x80]
00826A87 mov edx, dword ptr [eax + 0xc]
00826A8A call edx
00826A8C mov dword ptr [ebp - 4], 0xffffffff
00826A93 lea ecx, [ebp - 0x28]
00826A96 call 0x5327c0
00826A9B mov ecx, dword ptr [ebp - 0xc]
00826A9E mov dword ptr fs:[0], ecx
00826AA5 pop ecx
00826AA6 mov esp, ebp
00826AA8 pop ebp
; RANGE 008BBC20-008BBD3A
008BBC20 push ebp
008BBC21 mov ebp, esp
008BBC23 sub esp, 0x40
008BBC26 mov dword ptr [ebp - 0x3c], ecx
008BBC29 mov ecx, dword ptr [ebp - 0x3c]
008BBC2C add ecx, 0x5b0
008BBC32 call 0x536e70
008BBC37 lea eax, [ebp - 8]
008BBC3A push eax
008BBC3B mov ecx, dword ptr [ebp - 0x3c]
008BBC3E add ecx, 0x5b0
008BBC44 call 0x561740
008BBC49 mov ecx, dword ptr [eax + 4]
008BBC4C push ecx
008BBC4D mov edx, dword ptr [eax]
008BBC4F push edx
008BBC50 mov eax, dword ptr [ebp - 0x3c]
008BBC53 add eax, 0x5b0
008BBC58 push eax
008BBC59 lea ecx, [ebp - 0x14]
008BBC5C push ecx
008BBC5D call 0x419580
008BBC62 add esp, 4
008BBC65 mov edx, esp
008BBC67 mov ecx, dword ptr [eax]
008BBC69 mov dword ptr [edx], ecx
008BBC6B mov ecx, dword ptr [eax + 4]
008BBC6E mov dword ptr [edx + 4], ecx
008BBC71 mov eax, dword ptr [eax + 8]
008BBC74 mov dword ptr [edx + 8], eax
008BBC77 lea ecx, [ebp - 0x1c]
008BBC7A push ecx
008BBC7B mov ecx, dword ptr [ebp + 8]
008BBC7E call 0x504e60
008BBC83 mov edx, dword ptr [eax + 4]
008BBC86 push edx
008BBC87 mov eax, dword ptr [eax]
008BBC89 push eax
008BBC8A lea ecx, [ebp - 0x24]
008BBC8D push ecx
008BBC8E mov ecx, dword ptr [ebp + 8]
008BBC91 call 0x561ea0
008BBC96 mov edx, dword ptr [eax + 4]
008BBC99 push edx
008BBC9A mov eax, dword ptr [eax]
008BBC9C push eax
008BBC9D lea ecx, [ebp - 0x30]
008BBCA0 push ecx
008BBCA1 call 0x505210
008BBCA6 add esp, 0x20
008BBCA9 mov edx, dword ptr [ebp - 0x3c]
008BBCAC mov dword ptr [edx + 0x5f8], 1
008BBCB6 mov ecx, dword ptr [ebp - 0x3c]
008BBCB9 add ecx, 0x5b0
008BBCBF call 0x4f9670
008BBCC4 add eax, 4
008BBCC7 xor edx, edx
008BBCC9 mov ecx, 5
008BBCCE div ecx
008BBCD0 test eax, eax
008BBCD2 jne 0x8bbcdd
008BBCD4 mov dword ptr [ebp - 0x40], 1
008BBCDB jmp 0x8bbcfa
008BBCDD mov ecx, dword ptr [ebp - 0x3c]
008BBCE0 add ecx, 0x5b0
008BBCE6 call 0x4f9670
008BBCEB add eax, 4
008BBCEE xor edx, edx
008BBCF0 mov ecx, 5
008BBCF5 div ecx
008BBCF7 mov dword ptr [ebp - 0x40], eax
008BBCFA mov edx, dword ptr [ebp - 0x3c]
008BBCFD mov eax, dword ptr [ebp - 0x40]
008BBD00 mov dword ptr [edx + 0x5fc], eax
008BBD06 lea ecx, [ebp - 0x38]
008BBD09 push ecx
008BBD0A mov ecx, dword ptr [ebp - 0x3c]
008BBD0D add ecx, 0x5b0
008BBD13 call 0x561740
008BBD18 mov edx, dword ptr [eax]
008BBD1A mov eax, dword ptr [eax + 4]
008BBD1D mov ecx, dword ptr [ebp - 0x3c]
008BBD20 mov dword ptr [ecx + 0x5cc], edx
008BBD26 mov dword ptr [ecx + 0x5d0], eax
008BBD2C mov ecx, dword ptr [ebp - 0x3c]
008BBD2F call 0x8bb7e0
008BBD34 mov esp, ebp
008BBD36 pop ebp
008BBD37 ret 4
; RANGE 008BB240-008BB7E0
008BB240 push ebp
008BB241 mov ebp, esp
008BB243 push -1
008BB245 push 0xad1cd0
008BB24A mov eax, dword ptr fs:[0]
008BB250 push eax
008BB251 sub esp, 0x308
008BB257 mov eax, dword ptr [0xc7b480]
008BB25C xor eax, ebp
008BB25E mov dword ptr [ebp - 0x10], eax
008BB261 push eax
008BB262 lea eax, [ebp - 0xc]
008BB265 mov dword ptr fs:[0], eax
008BB26B mov dword ptr [ebp - 0x2b8], ecx
008BB271 lea ecx, [ebp - 0xac]
008BB277 call 0x4c4330
008BB27C mov dword ptr [ebp - 4], 0
008BB283 lea eax, [ebp + 8]
008BB286 push eax
008BB287 lea ecx, [ebp - 0x128]
008BB28D push ecx
008BB28E call 0xa44160
008BB293 add esp, 8
008BB296 mov dword ptr [ebp - 0x2bc], eax
008BB29C mov edx, dword ptr [ebp - 0x2bc]
008BB2A2 mov dword ptr [ebp - 0x2c0], edx
008BB2A8 mov byte ptr [ebp - 4], 1
008BB2AC mov eax, dword ptr [ebp - 0x2c0]
008BB2B2 push eax
008BB2B3 mov ecx, dword ptr [0xb99570]
008BB2B9 push ecx
008BB2BA lea edx, [ebp - 0x144]
008BB2C0 push edx
008BB2C1 call 0x411d70
008BB2C6 add esp, 0xc
008BB2C9 mov dword ptr [ebp - 0x2c4], eax
008BB2CF mov eax, dword ptr [ebp - 0x2c4]
008BB2D5 mov dword ptr [ebp - 0x2c8], eax
008BB2DB mov byte ptr [ebp - 4], 2
008BB2DF mov ecx, dword ptr [ebp - 0x2c8]
008BB2E5 push ecx
008BB2E6 mov ecx, dword ptr [ebp - 0x2b8]
008BB2EC call 0x75fbf0
008BB2F1 mov dword ptr [ebp - 0xb8], eax
008BB2F7 mov byte ptr [ebp - 4], 1
008BB2FB lea ecx, [ebp - 0x144]
008BB301 call 0x4056d0
008BB306 mov byte ptr [ebp - 4], 0
008BB30A lea ecx, [ebp - 0x128]
008BB310 call 0x4056d0
008BB315 mov edx, dword ptr [ebp + 0xc]
008BB318 mov eax, dword ptr [edx + 0x15]
008BB31B push eax
008BB31C call 0xa21b30
008BB321 mov ecx, eax
008BB323 call 0xa1e560
008BB328 mov dword ptr [ebp - 0xb0], eax
008BB32E cmp dword ptr [ebp - 0xb0], 0
008BB335 je 0x8bb389
008BB337 cmp dword ptr [ebp - 0xb8], 0
008BB33E je 0x8bb387
008BB340 mov ecx, dword ptr [ebp - 0xb0]
008BB346 add ecx, 0x44
008BB349 call 0x406410
008BB34E push eax
008BB34F lea ecx, [ebp - 0x160]
008BB355 call 0x405650
008BB35A mov byte ptr [ebp - 4], 3
008BB35E lea ecx, [ebp - 0x160]
008BB364 push ecx
008BB365 mov edx, dword ptr [ebp - 0xb8]
008BB36B mov eax, dword ptr [edx]
008BB36D mov ecx, dword ptr [ebp - 0xb8]
008BB373 mov edx, dword ptr [eax + 0x28]
008BB376 call edx
008BB378 mov byte ptr [ebp - 4], 0
008BB37C lea ecx, [ebp - 0x160]
008BB382 call 0x4056d0
008BB387 jmp 0x8bb3cf
008BB389 cmp dword ptr [ebp - 0xb8], 0
008BB390 je 0x8bb3cf
008BB392 push 0xb96699
008BB397 lea ecx, [ebp - 0x17c]
008BB39D call 0x405650
008BB3A2 mov byte ptr [ebp - 4], 4
008BB3A6 lea eax, [ebp - 0x17c]
008BB3AC push eax
008BB3AD mov ecx, dword ptr [ebp - 0xb8]
008BB3B3 mov edx, dword ptr [ecx]
008BB3B5 mov ecx, dword ptr [ebp - 0xb8]
008BB3BB mov eax, dword ptr [edx + 0x28]
008BB3BE call eax
008BB3C0 mov byte ptr [ebp - 4], 0
008BB3C4 lea ecx, [ebp - 0x17c]
008BB3CA call 0x4056d0
008BB3CF mov dword ptr [ebp - 0xb4], 0
008BB3D9 lea ecx, [ebp + 8]
008BB3DC push ecx
008BB3DD lea edx, [ebp - 0x198]
008BB3E3 push edx
008BB3E4 call 0xa44160
008BB3E9 add esp, 8
008BB3EC mov dword ptr [ebp - 0x2cc], eax
008BB3F2 mov eax, dword ptr [ebp - 0x2cc]
008BB3F8 mov dword ptr [ebp - 0x2d0], eax
008BB3FE mov byte ptr [ebp - 4], 5
008BB402 mov ecx, dword ptr [ebp - 0x2d0]
008BB408 push ecx
008BB409 mov edx, dword ptr [0xb99574]
008BB40F push edx
008BB410 lea eax, [ebp - 0x1b4]
008BB416 push eax
008BB417 call 0x411d70
008BB41C add esp, 0xc
008BB41F mov dword ptr [ebp - 0x2d4], eax
008BB425 mov ecx, dword ptr [ebp - 0x2d4]
008BB42B mov dword ptr [ebp - 0x2d8], ecx
008BB431 mov byte ptr [ebp - 4], 6
008BB435 mov edx, dword ptr [ebp - 0x2d8]
008BB43B push edx
008BB43C mov ecx, dword ptr [ebp - 0x2b8]
008BB442 call 0x75fbf0
008BB447 mov dword ptr [ebp - 0xb4], eax
008BB44D mov byte ptr [ebp - 4], 5
008BB451 lea ecx, [ebp - 0x1b4]
008BB457 call 0x4056d0
008BB45C mov byte ptr [ebp - 4], 0
008BB460 lea ecx, [ebp - 0x198]
008BB466 call 0x4056d0
008BB46B cmp dword ptr [ebp - 0xb4], 0
008BB472 je 0x8bb4bd
008BB474 lea ecx, [ebp - 0xa4]
008BB47A call 0x406410
008BB47F push eax
008BB480 lea ecx, [ebp - 0x1d0]
008BB486 call 0x405650
008BB48B mov byte ptr [ebp - 4], 7
008BB48F push 1
008BB491 lea eax, [ebp - 0x1d0]
008BB497 push eax
008BB498 mov ecx, dword ptr [ebp - 0xb4]
008BB49E mov edx, dword ptr [ecx]
008BB4A0 mov ecx, dword ptr [ebp - 0xb4]
008BB4A6 mov eax, dword ptr [edx + 0xd4]
008BB4AC call eax
008BB4AE mov byte ptr [ebp - 4], 0
008BB4B2 lea ecx, [ebp - 0x1d0]
008BB4B8 call 0x4056d0
008BB4BD lea ecx, [ebp + 8]
008BB4C0 push ecx
008BB4C1 lea edx, [ebp - 0x1ec]
008BB4C7 push edx
008BB4C8 call 0xa44160
008BB4CD add esp, 8
008BB4D0 mov dword ptr [ebp - 0x2dc], eax
008BB4D6 mov eax, dword ptr [ebp - 0x2dc]
008BB4DC mov dword ptr [ebp - 0x2e0], eax
008BB4E2 mov byte ptr [ebp - 4], 8
008BB4E6 mov ecx, dword ptr [ebp - 0x2e0]
008BB4EC push ecx
008BB4ED mov edx, dword ptr [0xb99578]
008BB4F3 push edx
008BB4F4 lea eax, [ebp - 0x208]
008BB4FA push eax
008BB4FB call 0x411d70
008BB500 add esp, 0xc
008BB503 mov dword ptr [ebp - 0x2e4], eax
008BB509 mov ecx, dword ptr [ebp - 0x2e4]
008BB50F mov dword ptr [ebp - 0x2e8], ecx
008BB515 mov byte ptr [ebp - 4], 9
008BB519 mov edx, dword ptr [ebp - 0x2e8]
008BB51F push edx
008BB520 mov ecx, dword ptr [ebp - 0x2b8]
008BB526 call 0x75fbf0
008BB52B mov dword ptr [ebp - 0xb4], eax
008BB531 mov byte ptr [ebp - 4], 8
008BB535 lea ecx, [ebp - 0x208]
008BB53B call 0x4056d0
008BB540 mov byte ptr [ebp - 4], 0
008BB544 lea ecx, [ebp - 0x1ec]
008BB54A call 0x4056d0
008BB54F cmp dword ptr [ebp - 0xb4], 0
008BB556 je 0x8bb608
008BB55C mov eax, dword ptr [ebp + 0xc]
008BB55F mov ecx, dword ptr [eax + 8]
008BB562 push ecx
008BB563 lea edx, [ebp - 0x104]
008BB569 push edx
008BB56A mov ecx, dword ptr [0x17c86fc]
008BB570 call 0x9cd840
008BB575 movzx eax, word ptr [ebp - 0xed]
008BB57C push eax
008BB57D mov ecx, dword ptr [ebp - 0xf7]
008BB583 push ecx
008BB584 mov edx, dword ptr [ebp - 0xf1]
008BB58A push edx
008BB58B lea eax, [ebp - 0x228]
008BB591 push eax
008BB592 call 0xa1ec20
008BB597 add esp, 0x10
008BB59A mov dword ptr [ebp - 0x2ec], eax
008BB5A0 mov ecx, dword ptr [ebp - 0x2ec]
008BB5A6 mov dword ptr [ebp - 0x2f0], ecx
008BB5AC mov byte ptr [ebp - 4], 0xa
008BB5B0 mov ecx, dword ptr [ebp - 0x2f0]
008BB5B6 call 0x406410
008BB5BB push eax
008BB5BC lea ecx, [ebp - 0x224]
008BB5C2 call 0x405650
008BB5C7 mov byte ptr [ebp - 4], 0xb
008BB5CB push 1
008BB5CD lea edx, [ebp - 0x224]
008BB5D3 push edx
008BB5D4 mov eax, dword ptr [ebp - 0xb4]
008BB5DA mov edx, dword ptr [eax]
008BB5DC mov ecx, dword ptr [ebp - 0xb4]
008BB5E2 mov eax, dword ptr [edx + 0xd4]
008BB5E8 call eax
008BB5EA mov byte ptr [ebp - 4], 0xa
008BB5EE lea ecx, [ebp - 0x224]
008BB5F4 call 0x4056d0
008BB5F9 mov byte ptr [ebp - 4], 0
008BB5FD lea ecx, [ebp - 0x228]
008BB603 call 0x406050
008BB608 lea ecx, [ebp + 8]
008BB60B push ecx
008BB60C lea edx, [ebp - 0x244]
008BB612 push edx
008BB613 call 0xa44160
008BB618 add esp, 8
008BB61B mov dword ptr [ebp - 0x2f4], eax
008BB621 mov eax, dword ptr [ebp - 0x2f4]
008BB627 mov dword ptr [ebp - 0x2f8], eax
008BB62D mov byte ptr [ebp - 4], 0xc
008BB631 mov ecx, dword ptr [ebp - 0x2f8]
008BB637 push ecx
008BB638 mov edx, dword ptr [0xb9957c]
008BB63E push edx
008BB63F lea eax, [ebp - 0x260]
008BB645 push eax
008BB646 call 0x411d70
008BB64B add esp, 0xc
008BB64E mov dword ptr [ebp - 0x2fc], eax
008BB654 mov ecx, dword ptr [ebp - 0x2fc]
008BB65A mov dword ptr [ebp - 0x300], ecx
008BB660 mov byte ptr [ebp - 4], 0xd
008BB664 mov edx, dword ptr [ebp - 0x300]
008BB66A push edx
008BB66B mov ecx, dword ptr [ebp - 0x2b8]
008BB671 call 0x75fbf0
008BB676 mov dword ptr [ebp - 0xb4], eax
008BB67C mov byte ptr [ebp - 4], 0xc
008BB680 lea ecx, [ebp - 0x260]
008BB686 call 0x4056d0
008BB68B mov byte ptr [ebp - 4], 0
008BB68F lea ecx, [ebp - 0x244]
008BB695 call 0x4056d0
008BB69A cmp dword ptr [ebp - 0xb4], 0
008BB6A1 je 0x8bb7b3
008BB6A7 mov eax, dword ptr [ebp + 0xc]
008BB6AA movzx ecx, byte ptr [eax + 0x46]
008BB6AE cmp ecx, 0x64
008BB6B1 jne 0x8bb6fa
008BB6B3 push 0xbbc4f4
008BB6B8 lea ecx, [ebp - 0x27c]
008BB6BE call 0x405650
008BB6C3 mov byte ptr [ebp - 4], 0xe
008BB6C7 push 1
008BB6C9 lea edx, [ebp - 0x27c]
008BB6CF push edx
008BB6D0 mov eax, dword ptr [ebp - 0xb4]
008BB6D6 mov edx, dword ptr [eax]
008BB6D8 mov ecx, dword ptr [ebp - 0xb4]
008BB6DE mov eax, dword ptr [edx + 0xd4]
008BB6E4 call eax
008BB6E6 mov byte ptr [ebp - 4], 0
008BB6EA lea ecx, [ebp - 0x27c]
008BB6F0 call 0x4056d0
008BB6F5 jmp 0x8bb7b3
008BB6FA mov ecx, dword ptr [ebp + 0xc]
008BB6FD movzx edx, byte ptr [ecx + 0x46]
008BB701 mov dword ptr [ebp - 0x304], edx
008BB707 fild dword ptr [ebp - 0x304]
008BB70D fdiv qword ptr [0xbe8478]
008BB713 fstp qword ptr [ebp - 0x10c]
008BB719 lea eax, [ebp - 0x10c]
008BB71F push eax
008BB720 lea ecx, [ebp - 0x298]
008BB726 push ecx
008BB727 call 0x5018c0
008BB72C add esp, 8
008BB72F mov dword ptr [ebp - 0x308], eax
008BB735 mov edx, dword ptr [ebp - 0x308]
008BB73B mov dword ptr [ebp - 0x30c], edx
008BB741 mov byte ptr [ebp - 4], 0xf
008BB745 mov eax, dword ptr [ebp - 0x30c]
008BB74B push eax
008BB74C push 0xbbc504
008BB751 lea ecx, [ebp - 0x2b4]
008BB757 push ecx
008BB758 call 0x411d70
008BB75D add esp, 0xc
008BB760 mov dword ptr [ebp - 0x310], eax
008BB766 mov edx, dword ptr [ebp - 0x310]
008BB76C mov dword ptr [ebp - 0x314], edx
008BB772 mov byte ptr [ebp - 4], 0x10
008BB776 push 1
008BB778 mov eax, dword ptr [ebp - 0x314]
008BB77E push eax
008BB77F mov ecx, dword ptr [ebp - 0xb4]
008BB785 mov edx, dword ptr [ecx]
008BB787 mov ecx, dword ptr [ebp - 0xb4]
008BB78D mov eax, dword ptr [edx + 0xd4]
008BB793 call eax
008BB795 mov byte ptr [ebp - 4], 0xf
008BB799 lea ecx, [ebp - 0x2b4]
008BB79F call 0x4056d0
008BB7A4 mov byte ptr [ebp - 4], 0
008BB7A8 lea ecx, [ebp - 0x298]
008BB7AE call 0x4056d0
008BB7B3 mov dword ptr [ebp - 4], 0xffffffff
008BB7BA lea ecx, [ebp - 0xac]
008BB7C0 call 0x4c4370
008BB7C5 mov ecx, dword ptr [ebp - 0xc]
008BB7C8 mov dword ptr fs:[0], ecx
008BB7CF pop ecx
008BB7D0 mov ecx, dword ptr [ebp - 0x10]
008BB7D3 xor ecx, ebp
008BB7D5 call 0x6634fb
008BB7DA mov esp, ebp
008BB7DC pop ebp
008BB7DD ret 8
