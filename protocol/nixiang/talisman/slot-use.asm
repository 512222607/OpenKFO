; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 0x9de410
009DE410 push ebp
009DE411 mov ebp, esp
009DE413 sub esp, 0xcc
009DE419 mov dword ptr [ebp - 0xc8], ecx
009DE41F cmp dword ptr [0x17c8708], 0
009DE426 je 0x9de46e
009DE428 mov ecx, dword ptr [0x17c8708]
009DE42E call 0x4535c0
009DE433 cmp eax, 0x11
009DE436 je 0x9de469
009DE438 lea eax, [ebp - 0x64]
009DE43B push eax
009DE43C mov ecx, dword ptr [0x17c8708]
009DE442 call 0x4535e0
009DE447 movzx ecx, byte ptr [eax + 0x49]
009DE44B test ecx, ecx
009DE44D je 0x9de46e
009DE44F lea edx, [ebp - 0xc4]
009DE455 push edx
009DE456 mov ecx, dword ptr [0x17c8708]
009DE45C call 0x4535e0
009DE461 movzx eax, byte ptr [eax + 0x5e]
009DE465 test eax, eax
009DE467 je 0x9de46e
009DE469 jmp 0x9de50d
009DE46E mov ecx, dword ptr [ebp + 8]
009DE471 call 0x45c510
009DE476 movzx ecx, al
009DE479 test ecx, ecx
009DE47B je 0x9de482
009DE47D jmp 0x9de50d
009DE482 mov edx, dword ptr [ebp + 8]
009DE485 push edx
009DE486 mov ecx, dword ptr [0x17c8708]
009DE48C call 0x8186a0
009DE491 test eax, eax
009DE493 je 0x9de50d
009DE495 mov dword ptr [ebp - 4], 0
009DE49C cmp dword ptr [ebp + 0xc], 0x25
009DE4A0 jne 0x9de4af
009DE4A2 mov ecx, dword ptr [ebp + 8]
009DE4A5 call 0x41b790
009DE4AA mov dword ptr [ebp - 4], eax
009DE4AD jmp 0x9de4c0
009DE4AF cmp dword ptr [ebp + 0xc], 0x26
009DE4B3 jne 0x9de4c0
009DE4B5 mov ecx, dword ptr [ebp + 8]
009DE4B8 call 0x41b7b0
009DE4BD mov dword ptr [ebp - 4], eax
009DE4C0 cmp dword ptr [ebp - 4], 0
009DE4C4 je 0x9de50d
009DE4C6 mov ecx, dword ptr [ebp - 4]
009DE4C9 call 0x99a750
009DE4CE test eax, eax
009DE4D0 je 0x9de50d
009DE4D2 mov ecx, dword ptr [0x17c8710]
009DE4D8 call 0x453db0
009DE4DD mov dword ptr [ebp - 0xcc], eax
009DE4E3 mov eax, dword ptr [ebp + 0xc]
009DE4E6 push eax
009DE4E7 mov ecx, dword ptr [ebp - 0xcc]
009DE4ED mov edx, dword ptr [ecx]
009DE4EF mov ecx, dword ptr [ebp - 0xcc]
009DE4F5 mov eax, dword ptr [edx + 0x84]
009DE4FB call eax
009DE4FD test eax, eax
009DE4FF je 0x9de50d
009DE501 mov ecx, dword ptr [ebp + 0xc]
009DE504 push ecx
009DE505 mov ecx, dword ptr [ebp - 4]
009DE508 call 0x99ab90
009DE50D mov esp, ebp
009DE50F pop ebp
009DE510 ret 8
; FUNCTION 0x9f94b0
009F94B0 push ebp
009F94B1 mov ebp, esp
009F94B3 sub esp, 0xc4
009F94B9 mov dword ptr [ebp - 0xc4], ecx
009F94BF cmp dword ptr [0x17c8708], 0
009F94C6 je 0x9f950b
009F94C8 mov ecx, dword ptr [0x17c8708]
009F94CE call 0x4535c0
009F94D3 cmp eax, 0x11
009F94D6 je 0x9f9509
009F94D8 lea eax, [ebp - 0x60]
009F94DB push eax
009F94DC mov ecx, dword ptr [0x17c8708]
009F94E2 call 0x4535e0
009F94E7 movzx ecx, byte ptr [eax + 0x49]
009F94EB test ecx, ecx
009F94ED je 0x9f950b
009F94EF lea edx, [ebp - 0xc0]
009F94F5 push edx
009F94F6 mov ecx, dword ptr [0x17c8708]
009F94FC call 0x4535e0
009F9501 movzx eax, byte ptr [eax + 0x5e]
009F9505 test eax, eax
009F9507 je 0x9f950b
009F9509 jmp 0x9f954f
009F950B mov ecx, dword ptr [ebp - 0xc4]
009F9511 cmp dword ptr [ecx + 0xcd4], 0
009F9518 je 0x9f952d
009F951A push 0x25
009F951C mov edx, dword ptr [ebp - 0xc4]
009F9522 mov ecx, dword ptr [edx + 0xcd4]
009F9528 call 0x99ae70
009F952D mov eax, dword ptr [ebp - 0xc4]
009F9533 cmp dword ptr [eax + 0xcd8], 0
009F953A je 0x9f954f
009F953C push 0x26
009F953E mov ecx, dword ptr [ebp - 0xc4]
009F9544 mov ecx, dword ptr [ecx + 0xcd8]
009F954A call 0x99ae70
009F954F mov esp, ebp
009F9551 pop ebp
009F9552 ret
; FUNCTION 0x9f9560
009F9560 push ebp
009F9561 mov ebp, esp
009F9563 sub esp, 0xc8
009F9569 mov dword ptr [ebp - 0xc8], ecx
009F956F cmp dword ptr [0x17c8708], 0
009F9576 je 0x9f95bd
009F9578 mov ecx, dword ptr [0x17c8708]
009F957E call 0x4535c0
009F9583 cmp eax, 0x11
009F9586 je 0x9f95b9
009F9588 lea eax, [ebp - 0x64]
009F958B push eax
009F958C mov ecx, dword ptr [0x17c8708]
009F9592 call 0x4535e0
009F9597 movzx ecx, byte ptr [eax + 0x49]
009F959B test ecx, ecx
009F959D je 0x9f95bd
009F959F lea edx, [ebp - 0xc4]
009F95A5 push edx
009F95A6 mov ecx, dword ptr [0x17c8708]
009F95AC call 0x4535e0
009F95B1 movzx eax, byte ptr [eax + 0x5e]
009F95B5 test eax, eax
009F95B7 je 0x9f95bd
009F95B9 xor eax, eax
009F95BB jmp 0x9f961c
009F95BD mov dword ptr [ebp - 4], 0
009F95C4 cmp dword ptr [ebp + 8], 0x25
009F95C8 jne 0x9f95db
009F95CA mov ecx, dword ptr [ebp - 0xc8]
009F95D0 mov edx, dword ptr [ecx + 0xcd4]
009F95D6 mov dword ptr [ebp - 4], edx
009F95D9 jmp 0x9f95f0
009F95DB cmp dword ptr [ebp + 8], 0x26
009F95DF jne 0x9f95f0
009F95E1 mov eax, dword ptr [ebp - 0xc8]
009F95E7 mov ecx, dword ptr [eax + 0xcd8]
009F95ED mov dword ptr [ebp - 4], ecx
009F95F0 cmp dword ptr [ebp - 4], 0
009F95F4 je 0x9f961a
009F95F6 cmp dword ptr [ebp + 0xc], 0
009F95FA je 0x9f960c
009F95FC mov edx, dword ptr [ebp + 8]
009F95FF push edx
009F9600 mov ecx, dword ptr [ebp - 4]
009F9603 call 0x99ae70
009F9608 jmp 0x9f961c
009F960A jmp 0x9f961a
009F960C mov eax, dword ptr [ebp + 8]
009F960F push eax
009F9610 mov ecx, dword ptr [ebp - 4]
009F9613 call 0x99ab90
009F9618 jmp 0x9f961c
009F961A xor eax, eax
009F961C mov esp, ebp
009F961E pop ebp
009F961F ret 8
; FUNCTION 0x99a750
0099A750 push ebp
0099A751 mov ebp, esp
0099A753 push -1
0099A755 push 0xaa4f91
0099A75A mov eax, dword ptr fs:[0]
0099A760 push eax
0099A761 sub esp, 0x3c
0099A764 push esi
0099A765 mov eax, dword ptr [0xc7b480]
0099A76A xor eax, ebp
0099A76C push eax
0099A76D lea eax, [ebp - 0xc]
0099A770 mov dword ptr fs:[0], eax
0099A776 mov dword ptr [ebp - 0x44], ecx
0099A779 mov eax, dword ptr [ebp - 0x44]
0099A77C cmp dword ptr [eax + 0x16c], 0
0099A783 je 0x99a9c3
0099A789 mov ecx, dword ptr [ebp - 0x44]
0099A78C mov ecx, dword ptr [ecx + 0x16c]
0099A792 call 0x9e4430
0099A797 mov edx, dword ptr [ebp - 0x44]
0099A79A mov eax, dword ptr [edx + 0x168]
0099A7A0 fld dword ptr [eax + 0x5c]
0099A7A3 fmul qword ptr [0xbe8460]
0099A7A9 fcompp
0099A7AB fnstsw ax
0099A7AD test ah, 0x41
0099A7B0 jp 0x99a7b4
0099A7B2 jmp 0x99a832
0099A7B4 lea ecx, [ebp - 0x10]
0099A7B7 call 0x405f90
0099A7BC mov dword ptr [ebp - 4], 0
0099A7C3 push 0xba5d84
0099A7C8 lea ecx, [ebp - 0x10]
0099A7CB push ecx
0099A7CC call 0x411c60
0099A7D1 add esp, 8
0099A7D4 push 0xb96699
0099A7D9 lea ecx, [ebp - 0x3c]
0099A7DC call 0x405650
0099A7E1 mov byte ptr [ebp - 4], 1
0099A7E5 push 0
0099A7E7 push 0xffff0000
0099A7EC push 0
0099A7EE push 4
0099A7F0 lea edx, [ebp - 0x10]
0099A7F3 push edx
0099A7F4 lea eax, [ebp - 0x3c]
0099A7F7 push eax
0099A7F8 push 0
0099A7FA push 0
0099A7FC call 0x41b7d0
0099A801 mov ecx, eax
0099A803 call 0xa921b0
0099A808 mov byte ptr [ebp - 4], 0
0099A80C lea ecx, [ebp - 0x3c]
0099A80F call 0x4056d0
0099A814 mov dword ptr [ebp - 0x40], 0
0099A81B mov dword ptr [ebp - 4], 0xffffffff
0099A822 lea ecx, [ebp - 0x10]
0099A825 call 0x406050
0099A82A mov eax, dword ptr [ebp - 0x40]
0099A82D jmp 0x99a9c5
0099A832 mov ecx, dword ptr [ebp - 0x44]
0099A835 mov ecx, dword ptr [ecx + 0x168]
0099A83B add ecx, 0x64
0099A83E call 0x4c50a0
0099A843 movzx edx, al
0099A846 test edx, edx
0099A848 jne 0x99a8b3
0099A84A mov byte ptr [ebp - 0x11], 0
0099A84E mov dword ptr [ebp - 0x18], 0
0099A855 jmp 0x99a860
0099A857 mov eax, dword ptr [ebp - 0x18]
0099A85A add eax, 1
0099A85D mov dword ptr [ebp - 0x18], eax
0099A860 mov ecx, dword ptr [ebp - 0x44]
0099A863 mov ecx, dword ptr [ecx + 0x168]
0099A869 add ecx, 0x64
0099A86C call 0x55f000
0099A871 cmp dword ptr [ebp - 0x18], eax
0099A874 jae 0x99a8a4
0099A876 mov ecx, dword ptr [0x17c8708]
0099A87C call 0x4535c0
0099A881 mov esi, eax
0099A883 mov edx, dword ptr [ebp - 0x18]
0099A886 push edx
0099A887 mov eax, dword ptr [ebp - 0x44]
0099A88A mov ecx, dword ptr [eax + 0x168]
0099A890 add ecx, 0x64
0099A893 call 0x491640
0099A898 cmp esi, dword ptr [eax]
0099A89A jne 0x99a8a2
0099A89C mov byte ptr [ebp - 0x11], 1
0099A8A0 jmp 0x99a8a4
0099A8A2 jmp 0x99a857
0099A8A4 movzx ecx, byte ptr [ebp - 0x11]
0099A8A8 test ecx, ecx
0099A8AA jne 0x99a8b3
0099A8AC xor eax, eax
0099A8AE jmp 0x99a9c5
0099A8B3 mov edx, dword ptr [ebp - 0x44]
0099A8B6 mov eax, dword ptr [edx + 0x168]
0099A8BC movzx ecx, byte ptr [eax + 0x7c]
0099A8C0 test ecx, ecx
0099A8C2 je 0x99a919
0099A8C4 mov edx, dword ptr [ebp - 0x44]
0099A8C7 mov ecx, dword ptr [edx + 0x16c]
0099A8CD call 0x4634e0
0099A8D2 mov ecx, dword ptr [eax + 4]
0099A8D5 push ecx
0099A8D6 mov edx, dword ptr [eax]
0099A8D8 push edx
0099A8D9 mov ecx, dword ptr [0x17c8708]
0099A8DF call 0x818c70
0099A8E4 mov dword ptr [ebp - 0x1c], eax
0099A8E7 cmp dword ptr [ebp - 0x1c], 0
0099A8EB jne 0x99a8f6
0099A8ED xor eax, eax
0099A8EF jmp 0x99a9c5
0099A8F4 jmp 0x99a919
0099A8F6 mov ecx, dword ptr [ebp - 0x1c]
0099A8F9 call 0x4058b0
0099A8FE mov esi, eax
0099A900 mov eax, dword ptr [ebp - 0x44]
0099A903 mov ecx, dword ptr [eax + 0x16c]
0099A909 call 0x4058b0
0099A90E cmp esi, eax
0099A910 je 0x99a919
0099A912 xor eax, eax
0099A914 jmp 0x99a9c5
0099A919 mov ecx, dword ptr [ebp - 0x44]
0099A91C mov edx, dword ptr [ecx + 0x168]
0099A922 movzx eax, byte ptr [edx + 0x7d]
0099A926 test eax, eax
0099A928 je 0x99a9bc
0099A92E mov ecx, dword ptr [ebp - 0x44]
0099A931 mov ecx, dword ptr [ecx + 0x16c]
0099A937 call 0x401040
0099A93C mov ecx, eax
0099A93E call 0x50fd70
0099A943 mov ecx, eax
0099A945 call 0x424f30
0099A94A cmp dword ptr [eax], 0xbb8
0099A950 jle 0x99a976
0099A952 mov edx, dword ptr [ebp - 0x44]
0099A955 mov ecx, dword ptr [edx + 0x16c]
0099A95B call 0x401040
0099A960 mov ecx, eax
0099A962 call 0x50fd70
0099A967 mov ecx, eax
0099A969 call 0x424f30
0099A96E cmp dword ptr [eax], 0xbc8
0099A974 jl 0x99a9a3
0099A976 mov eax, dword ptr [ebp - 0x44]
0099A979 mov ecx, dword ptr [eax + 0x16c]
0099A97F call 0x401040
0099A984 mov ecx, eax
0099A986 call 0x50fd70
0099A98B mov ecx, eax
0099A98D call 0x424f30
0099A992 cmp dword ptr [eax], 0xfa1
0099A998 je 0x99a9a3
0099A99A mov dword ptr [ebp - 0x48], 0
0099A9A1 jmp 0x99a9aa
0099A9A3 mov dword ptr [ebp - 0x48], 1
0099A9AA mov cl, byte ptr [ebp - 0x48]
0099A9AD mov byte ptr [ebp - 0x1d], cl
0099A9B0 movzx edx, byte ptr [ebp - 0x1d]
0099A9B4 test edx, edx
0099A9B6 je 0x99a9bc
0099A9B8 xor eax, eax
0099A9BA jmp 0x99a9c5
0099A9BC mov eax, 1
0099A9C1 jmp 0x99a9c5
0099A9C3 xor eax, eax
0099A9C5 mov ecx, dword ptr [ebp - 0xc]
0099A9C8 mov dword ptr fs:[0], ecx
0099A9CF pop ecx
0099A9D0 pop esi
0099A9D1 mov esp, ebp
0099A9D3 pop ebp
0099A9D4 ret
