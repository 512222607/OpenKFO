; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 8120 native moving identity +4; motion counter +15, distinct from event +19.
; function 0x7d0ee0
007D0EE0 push ebp
007D0EE1 mov ebp, esp
007D0EE3 push ecx
007D0EE4 mov dword ptr [ebp - 4], ecx
007D0EE7 mov eax, dword ptr [ebp - 4]
007D0EEA mov eax, dword ptr [eax]
007D0EEC mov esp, ebp
007D0EEE pop ebp
007D0EEF ret
; function 0x7d0ef0
007D0EF0 push ebp
007D0EF1 mov ebp, esp
007D0EF3 push ecx
007D0EF4 mov dword ptr [ebp - 4], ecx
007D0EF7 mov eax, dword ptr [ebp - 4]
007D0EFA mov ecx, dword ptr [eax]
007D0EFC add ecx, 1
007D0EFF mov edx, dword ptr [ebp - 4]
007D0F02 mov dword ptr [edx], ecx
007D0F04 mov eax, dword ptr [ebp - 4]
007D0F07 mov eax, dword ptr [eax]
007D0F09 mov esp, ebp
007D0F0B pop ebp
007D0F0C ret
; function 0x7d1520
007D1520 push ebp
007D1521 mov ebp, esp
007D1523 sub esp, 0x34
007D1526 mov eax, dword ptr [0xc7b480]
007D152B xor eax, ebp
007D152D mov dword ptr [ebp - 4], eax
007D1530 mov dword ptr [ebp - 0x34], ecx
007D1533 mov eax, dword ptr [ebp + 8]
007D1536 mov dword ptr [eax], 0x1fb8
007D153C mov ecx, dword ptr [ebp + 8]
007D153F mov byte ptr [ecx + 0xc], 0
007D1543 mov edx, dword ptr [ebp + 8]
007D1546 mov al, byte ptr [ebp + 0xc]
007D1549 mov byte ptr [edx + 0xe], al
007D154C mov ecx, dword ptr [ebp + 8]
007D154F mov byte ptr [ecx + 0xd], 0
007D1553 call 0x7d1040
007D1558 mov ecx, eax
007D155A call 0x7d0f90
007D155F mov dword ptr [ebp - 0x24], eax
007D1562 cmp dword ptr [ebp + 0xc], 0
007D1566 jne 0x7d158b
007D1568 mov edx, dword ptr [ebp - 0x34]
007D156B mov eax, dword ptr [ebp - 0x24]
007D156E mov dword ptr [edx + 8], eax
007D1571 mov ecx, dword ptr [ebp + 8]
007D1574 mov dword ptr [ecx + 0x1b], 0
007D157B mov ecx, dword ptr [ebp - 0x34]
007D157E call 0x7d0ef0
007D1583 mov edx, dword ptr [ebp + 8]
007D1586 mov dword ptr [edx + 0xf], eax
007D1589 jmp 0x7d15a8
007D158B mov eax, dword ptr [ebp - 0x34]
007D158E mov ecx, dword ptr [ebp - 0x24]
007D1591 sub ecx, dword ptr [eax + 8]
007D1594 mov edx, dword ptr [ebp + 8]
007D1597 mov dword ptr [edx + 0x1b], ecx
007D159A mov ecx, dword ptr [ebp - 0x34]
007D159D call 0x7d0ee0
007D15A2 mov ecx, dword ptr [ebp + 8]
007D15A5 mov dword ptr [ecx + 0xf], eax
007D15A8 mov edx, dword ptr [ebp + 8]
007D15AB mov eax, dword ptr [ebp - 0x34]
007D15AE mov cx, word ptr [eax + 8]
007D15B2 mov word ptr [edx + 0x5f], cx
007D15B6 mov edx, dword ptr [ebp - 0x34]
007D15B9 mov ecx, dword ptr [edx + 0x78]
007D15BC call 0x401000
007D15C1 mov ecx, dword ptr [ebp + 8]
007D15C4 mov dword ptr [ecx + 4], eax
007D15C7 mov dword ptr [ecx + 8], edx
007D15CA mov edx, dword ptr [ebp - 0x34]
007D15CD mov ecx, dword ptr [edx + 0x78]
007D15D0 call 0x453870
007D15D5 push eax
007D15D6 mov ecx, dword ptr [0x17c8708]
007D15DC call 0x8186a0
007D15E1 test eax, eax
007D15E3 je 0x7d1602
007D15E5 mov eax, dword ptr [ebp - 0x34]
007D15E8 mov ecx, dword ptr [eax + 0x78]
007D15EB call 0x453870
007D15F0 mov ecx, eax
007D15F2 call 0x401000
007D15F7 mov ecx, dword ptr [ebp + 8]
007D15FA mov dword ptr [ecx + 0x4b], eax
007D15FD mov dword ptr [ecx + 0x4f], edx
007D1600 jmp 0x7d1613
007D1602 mov edx, dword ptr [ebp + 8]
007D1605 mov dword ptr [edx + 0x4b], 0
007D160C mov dword ptr [edx + 0x4f], 0
007D1613 mov eax, dword ptr [ebp + 8]
007D1616 mov ecx, dword ptr [ebp + 0x10]
007D1619 mov dword ptr [eax + 0x57], ecx
007D161C mov edx, dword ptr [ebp - 0x34]
007D161F mov ecx, dword ptr [edx + 0x78]
007D1622 call 0x44e170
007D1627 mov eax, dword ptr [ebp + 8]
007D162A fstp dword ptr [eax + 0x5b]
007D162D mov ecx, dword ptr [ebp - 0x34]
007D1630 mov ecx, dword ptr [ecx + 0x78]
007D1633 call 0x9e60e0
007D1638 mov edx, dword ptr [ebp + 8]
007D163B mov dword ptr [edx + 0x63], eax
007D163E mov eax, dword ptr [ebp - 0x34]
007D1641 mov ecx, dword ptr [eax + 0x78]
007D1644 call 0x401040
007D1649 mov ecx, eax
007D164B call 0x50fd70
007D1650 mov ecx, eax
007D1652 call 0x424f30
007D1657 mov ecx, dword ptr [ebp + 8]
007D165A mov dx, word ptr [eax]
007D165D mov word ptr [ecx + 0x61], dx
007D1661 mov eax, dword ptr [ebp - 0x34]
007D1664 mov ecx, dword ptr [eax + 0x78]
007D1667 call 0x401020
007D166C mov ecx, dword ptr [ebp + 8]
007D166F mov byte ptr [ecx + 0x67], al
007D1672 mov edx, dword ptr [ebp - 0x34]
007D1675 mov ecx, dword ptr [edx + 0x78]
007D1678 call 0x4536a0
007D167D mov ecx, eax
007D167F call 0x493e10
007D1684 mov ecx, dword ptr [ebp + 8]
007D1687 mov byte ptr [ecx + 0x68], al
007D168A mov edx, dword ptr [ebp - 0x34]
007D168D mov ecx, dword ptr [edx + 0x78]
007D1690 call 0x44e110
007D1695 mov ecx, dword ptr [ebp + 8]
007D1698 mov byte ptr [ecx + 0x6a], al
007D169B mov edx, dword ptr [ebp - 0x34]
007D169E mov ecx, dword ptr [edx + 0x78]
007D16A1 call 0x44b2c0
007D16A6 movzx eax, al
007D16A9 test eax, eax
007D16AB sete cl
007D16AE mov edx, dword ptr [ebp + 8]
007D16B1 mov byte ptr [edx + 0x69], cl
007D16B4 mov eax, dword ptr [ebp - 0x34]
007D16B7 mov ecx, dword ptr [eax + 0x78]
007D16BA call 0x9e42e0
007D16BF mov ecx, dword ptr [ebp + 8]
007D16C2 add ecx, 0x33
007D16C5 mov edx, dword ptr [eax]
007D16C7 mov dword ptr [ecx], edx
007D16C9 mov edx, dword ptr [eax + 4]
007D16CC mov dword ptr [ecx + 4], edx
007D16CF mov eax, dword ptr [eax + 8]
007D16D2 mov dword ptr [ecx + 8], eax
007D16D5 lea ecx, [ebp - 0x30]
007D16D8 push ecx
007D16D9 mov edx, dword ptr [ebp - 0x34]
007D16DC mov ecx, dword ptr [edx + 0x78]
007D16DF call 0x9e4bf0
007D16E4 mov ecx, dword ptr [ebp + 8]
007D16E7 add ecx, 0x3f
007D16EA mov edx, dword ptr [eax]
007D16EC mov dword ptr [ecx], edx
007D16EE mov edx, dword ptr [eax + 4]
007D16F1 mov dword ptr [ecx + 4], edx
007D16F4 mov eax, dword ptr [eax + 8]
007D16F7 mov dword ptr [ecx + 8], eax
007D16FA mov ecx, dword ptr [ebp + 8]
007D16FD push ecx
007D16FE lea edx, [ebp - 0x20]
007D1701 push edx
007D1702 call 0x7d13f0
007D1707 add esp, 8
007D170A lea ecx, [ebp - 0x20]
007D170D call 0x4056d0
007D1712 mov ecx, dword ptr [ebp - 4]
007D1715 xor ecx, ebp
007D1717 call 0x6634fb
007D171C mov esp, ebp
007D171E pop ebp
007D171F ret 0xc
; function 0x7d17c0
007D17C0 push ebp
007D17C1 mov ebp, esp
007D17C3 push ecx
007D17C4 mov dword ptr [ebp - 4], ecx
007D17C7 cmp dword ptr [0x17c8708], 0
007D17CE jne 0x7d17d5
007D17D0 jmp 0x7d1899
007D17D5 mov eax, dword ptr [ebp + 8]
007D17D8 push eax
007D17D9 mov ecx, dword ptr [0x17c8708]
007D17DF call 0x8186a0
007D17E4 test eax, eax
007D17E6 jne 0x7d17ed
007D17E8 jmp 0x7d1899
007D17ED mov ecx, dword ptr [ebp + 8]
007D17F0 call 0x4536a0
007D17F5 test eax, eax
007D17F7 jne 0x7d17fe
007D17F9 jmp 0x7d1899
007D17FE mov ecx, dword ptr [ebp + 8]
007D1801 call 0x9e9a30
007D1806 test eax, eax
007D1808 jne 0x7d180f
007D180A jmp 0x7d1899
007D180F mov ecx, dword ptr [ebp - 4]
007D1812 mov edx, dword ptr [ebp + 8]
007D1815 mov dword ptr [ecx + 0x78], edx
007D1818 mov eax, dword ptr [ebp + 0xc]
007D181B push eax
007D181C push 0
007D181E mov ecx, dword ptr [ebp - 4]
007D1821 add ecx, 0xc
007D1824 push ecx
007D1825 mov ecx, dword ptr [ebp - 4]
007D1828 call 0x7d1520
007D182D mov edx, dword ptr [ebp - 4]
007D1830 add edx, 0x3f
007D1833 mov eax, dword ptr [ebp - 4]
007D1836 add eax, 0x33
007D1839 mov ecx, dword ptr [edx]
007D183B mov dword ptr [eax], ecx
007D183D mov ecx, dword ptr [edx + 4]
007D1840 mov dword ptr [eax + 4], ecx
007D1843 mov edx, dword ptr [edx + 8]
007D1846 mov dword ptr [eax + 8], edx
007D1849 call 0x4030c0
007D184E mov ecx, eax
007D1850 call 0x4031a0
007D1855 cmp eax, 2
007D1858 je 0x7d187d
007D185A call 0x4030c0
007D185F mov ecx, eax
007D1861 call 0x4b1250
007D1866 test eax, eax
007D1868 je 0x7d187d
007D186A mov eax, dword ptr [ebp - 4]
007D186D add eax, 0xc
007D1870 push eax
007D1871 call 0x4030c0
007D1876 mov ecx, eax
007D1878 call 0x9317b0
007D187D push 0x6c
007D187F mov ecx, dword ptr [ebp - 4]
007D1882 add ecx, 0xc
007D1885 push ecx
007D1886 push 0
007D1888 push 0x1f87
007D188D call 0x7d03e0
007D1892 mov ecx, eax
007D1894 call 0x7d0410
007D1899 mov esp, ebp
007D189B pop ebp
007D189C ret 8
; function 0x82b230
0082B230 push ebp
0082B231 mov ebp, esp
0082B233 sub esp, 0x68
0082B236 push esi
0082B237 mov dword ptr [ebp - 0x68], ecx
0082B23A mov eax, dword ptr [0x1230370]
0082B23F mov dword ptr [ebp - 4], eax
0082B242 cmp dword ptr [ebp + 8], 0
0082B246 je 0x82b24e
0082B248 cmp dword ptr [ebp + 0xc], 0x6c
0082B24C jae 0x82b253
0082B24E jmp 0x82b838
0082B253 mov ecx, dword ptr [ebp + 8]
0082B256 mov dword ptr [ebp - 8], ecx
0082B259 cmp dword ptr [ebp - 8], 0
0082B25D je 0x82b82f
0082B263 mov edx, dword ptr [ebp - 8]
0082B266 mov eax, dword ptr [edx + 0x4f]
0082B269 push eax
0082B26A mov ecx, dword ptr [edx + 0x4b]
0082B26D push ecx
0082B26E mov ecx, dword ptr [0x17c8708]
0082B274 call 0x818c70
0082B279 mov dword ptr [ebp - 0xc], eax
0082B27C mov edx, dword ptr [ebp - 8]
0082B27F mov eax, dword ptr [edx + 8]
0082B282 push eax
0082B283 mov ecx, dword ptr [edx + 4]
0082B286 push ecx
0082B287 mov ecx, dword ptr [0x17c8708]
0082B28D call 0x818c70
0082B292 mov dword ptr [ebp - 0x10], eax
0082B295 cmp dword ptr [ebp - 0x10], 0
0082B299 je 0x82b82f
0082B29F mov ecx, dword ptr [ebp - 0x10]
0082B2A2 call 0x9e7c70
0082B2A7 test eax, eax
0082B2A9 je 0x82b2b9
0082B2AB mov edx, dword ptr [ebp - 4]
0082B2AE mov dword ptr [0x1230370], edx
0082B2B4 jmp 0x82b838
0082B2B9 call 0x4030c0
0082B2BE mov ecx, eax
0082B2C0 call 0x4031a0
0082B2C5 cmp eax, 2
0082B2C8 je 0x82b2da
0082B2CA mov eax, dword ptr [ebp - 8]
0082B2CD push eax
0082B2CE call 0x4030c0
0082B2D3 mov ecx, eax
0082B2D5 call 0x9317b0
0082B2DA mov ecx, dword ptr [ebp - 8]
0082B2DD add ecx, 0x33
0082B2E0 mov edx, dword ptr [ecx]
0082B2E2 mov dword ptr [ebp - 0x1c], edx
0082B2E5 mov eax, dword ptr [ecx + 4]
0082B2E8 mov dword ptr [ebp - 0x18], eax
0082B2EB mov ecx, dword ptr [ecx + 8]
0082B2EE mov dword ptr [ebp - 0x14], ecx
0082B2F1 mov edx, dword ptr [ebp - 8]
0082B2F4 add edx, 0x3f
0082B2F7 mov eax, dword ptr [edx]
0082B2F9 mov dword ptr [ebp - 0x2c], eax
0082B2FC mov ecx, dword ptr [edx + 4]
0082B2FF mov dword ptr [ebp - 0x28], ecx
0082B302 mov edx, dword ptr [edx + 8]
0082B305 mov dword ptr [ebp - 0x24], edx
0082B308 mov eax, dword ptr [ebp - 8]
0082B30B fld dword ptr [eax + 0x5b]
0082B30E fcomp qword ptr [0xbe8368]
0082B314 fnstsw ax
0082B316 test ah, 0x41
0082B319 jne 0x82b32d
0082B31B mov ecx, dword ptr [ebp - 8]
0082B31E push ecx
0082B31F fld dword ptr [ecx + 0x5b]
0082B322 fstp dword ptr [esp]
0082B325 mov ecx, dword ptr [ebp - 0x10]
0082B328 call 0x45ca00
0082B32D mov dword ptr [0x1230370], 0
0082B337 mov dword ptr [ebp - 0x20], 1
0082B33E mov ecx, dword ptr [ebp - 0x10]
0082B341 call 0x432480
0082B346 mov edx, dword ptr [ebp - 8]
0082B349 movzx ecx, byte ptr [edx + 0x68]
0082B34D cmp eax, ecx
0082B34F je 0x82b488
0082B355 mov ecx, dword ptr [ebp - 0x10]
0082B358 call 0x4536a0
0082B35D mov dword ptr [ebp - 0x30], eax
0082B360 mov edx, dword ptr [ebp - 8]
0082B363 movzx eax, byte ptr [edx + 0x68]
0082B367 push eax
0082B368 mov ecx, dword ptr [0x17c8710]
0082B36E call 0x985750
0082B373 mov dword ptr [ebp - 0x34], eax
0082B376 cmp dword ptr [ebp - 0x34], 0
0082B37A je 0x82b488
0082B380 cmp dword ptr [ebp - 0x30], 0
0082B384 je 0x82b488
0082B38A mov ecx, dword ptr [ebp - 0x10]
0082B38D push ecx
0082B38E mov ecx, dword ptr [ebp - 0x30]
0082B391 call 0x97ee70
0082B396 push 0
0082B398 mov edx, dword ptr [ebp - 0x10]
0082B39B push edx
0082B39C mov ecx, dword ptr [ebp - 0x34]
0082B39F call 0x97f470
0082B3A4 push 0
0082B3A6 push 1
0082B3A8 sub esp, 0xc
0082B3AB mov eax, esp
0082B3AD mov ecx, dword ptr [ebp - 0x1c]
0082B3B0 mov dword ptr [eax], ecx
0082B3B2 mov edx, dword ptr [ebp - 0x18]
0082B3B5 mov dword ptr [eax + 4], edx
0082B3B8 mov ecx, dword ptr [ebp - 0x14]
0082B3BB mov dword ptr [eax + 8], ecx
0082B3BE mov ecx, dword ptr [ebp - 0x10]
0082B3C1 call 0x9e9d10
0082B3C6 push 1
0082B3C8 sub esp, 0xc
0082B3CB mov edx, esp
0082B3CD mov eax, dword ptr [0xb97328]
0082B3D2 mov dword ptr [edx], eax
0082B3D4 mov ecx, dword ptr [0xb9732c]
0082B3DA mov dword ptr [edx + 4], ecx
0082B3DD mov eax, dword ptr [0xb97330]
0082B3E2 mov dword ptr [edx + 8], eax
0082B3E5 mov ecx, dword ptr [ebp - 0x10]
0082B3E8 call 0x401000
0082B3ED push edx
0082B3EE push eax
0082B3EF mov ecx, dword ptr [0x17c8710]
0082B3F5 call 0x986890
0082B3FA test eax, eax
0082B3FC je 0x82b408
0082B3FE push 0
0082B400 mov ecx, dword ptr [ebp - 0x10]
0082B403 call 0x9e3ec0
0082B408 mov ecx, dword ptr [0x17c8710]
0082B40E call 0x985c50
0082B413 cmp dword ptr [ebp - 0x10], eax
0082B416 jne 0x82b481
0082B418 push 0
0082B41A mov ecx, dword ptr [ebp - 0x10]
0082B41D call 0x432480
0082B422 push eax
0082B423 mov ecx, dword ptr [0x17c8710]
0082B429 call 0x986e00
0082B42E mov ecx, dword ptr [ebp - 0x10]
0082B431 call 0x4536a0
0082B436 push eax
0082B437 mov ecx, dword ptr [0x17c8710]
0082B43D call 0x45c3e0
0082B442 mov ecx, dword ptr [0x17c8710]
0082B448 call 0x985540
0082B44D mov ecx, eax
0082B44F call 0x982250
0082B454 push eax
0082B455 mov ecx, dword ptr [ebp - 0x10]
0082B458 call 0x4536a0
0082B45D mov ecx, eax
0082B45F call 0x462480
0082B464 mov ecx, eax
0082B466 call 0x774290
0082B46B mov ecx, dword ptr [ebp - 0x10]
0082B46E push ecx
0082B46F mov ecx, dword ptr [0x17c8710]
0082B475 call 0x985540
0082B47A mov ecx, eax
0082B47C call 0x982fb0
0082B481 mov dword ptr [ebp - 0x20], 0
0082B488 cmp dword ptr [ebp - 0xc], 0
0082B48C je 0x82b49a
0082B48E mov edx, dword ptr [ebp - 0xc]
0082B491 push edx
0082B492 mov ecx, dword ptr [ebp - 0x10]
0082B495 call 0x9e99f0
0082B49A mov eax, dword ptr [ebp - 8]
0082B49D movzx ecx, word ptr [eax + 0x61]
0082B4A1 cmp ecx, 0x439
0082B4A7 jne 0x82b4d2
0082B4A9 cmp dword ptr [ebp - 0x10], 0
0082B4AD je 0x82b4d2
0082B4AF mov ecx, dword ptr [ebp - 0x10]
0082B4B2 call 0x9e45b0
0082B4B7 fcomp qword ptr [0xbe8368]
0082B4BD fnstsw ax
0082B4BF test ah, 0x41
0082B4C2 jp 0x82b4d2
0082B4C4 mov edx, dword ptr [ebp - 4]
0082B4C7 mov dword ptr [0x1230370], edx
0082B4CD jmp 0x82b838
0082B4D2 mov ecx, dword ptr [ebp - 0x10]
0082B4D5 call 0x9e60e0
0082B4DA mov ecx, dword ptr [ebp - 8]
0082B4DD cmp eax, dword ptr [ecx + 0x63]
0082B4E0 je 0x82b5fe
0082B4E6 mov edx, dword ptr [ebp - 8]
0082B4E9 cmp dword ptr [edx + 0x63], 0x64
0082B4ED jae 0x82b50f
0082B4EF mov ecx, dword ptr [ebp - 0x10]
0082B4F2 call 0x9e5570
0082B4F7 mov ecx, dword ptr [ebp - 8]
0082B4FA mov edx, dword ptr [eax + 8]
0082B4FD cmp edx, dword ptr [ecx + 0x63]
0082B500 je 0x82b50f
0082B502 mov eax, dword ptr [ebp - 4]
0082B505 mov dword ptr [0x1230370], eax
0082B50A jmp 0x82b838
0082B50F mov dword ptr [ebp - 0x38], 0
0082B516 mov ecx, dword ptr [ebp - 0x10]
0082B519 call 0x432460
0082B51E mov dword ptr [ebp - 0x3c], eax
0082B521 cmp dword ptr [ebp - 0x3c], 0
0082B525 je 0x82b547
0082B527 push 0
0082B529 mov ecx, dword ptr [ebp - 0x3c]
0082B52C call 0x9bfbf0
0082B531 mov ecx, dword ptr [ebp - 0x3c]
0082B534 call 0x5875a0
0082B539 mov ecx, dword ptr [ebp - 8]
0082B53C cmp eax, dword ptr [ecx + 0x63]
0082B53F jne 0x82b547
0082B541 mov edx, dword ptr [ebp - 0x3c]
0082B544 mov dword ptr [ebp - 0x38], edx
0082B547 mov ecx, dword ptr [ebp - 0x10]
0082B54A call 0x41b750
0082B54F mov dword ptr [ebp - 0x3c], eax
0082B552 cmp dword ptr [ebp - 0x3c], 0
0082B556 je 0x82b582
0082B558 push 0
0082B55A mov ecx, dword ptr [ebp - 0x3c]
0082B55D call 0x9bfbf0
0082B562 mov ecx, dword ptr [ebp - 0x3c]
0082B565 call 0x5875a0
0082B56A mov ecx, dword ptr [ebp - 8]
0082B56D cmp eax, dword ptr [ecx + 0x63]
0082B570 jne 0x82b582
0082B572 push 1
0082B574 mov ecx, dword ptr [ebp - 0x10]
0082B577 call 0x4dbad0
0082B57C mov edx, dword ptr [ebp - 0x3c]
0082B57F mov dword ptr [ebp - 0x38], edx
0082B582 mov ecx, dword ptr [ebp - 0x10]
0082B585 call 0x41b770
0082B58A mov dword ptr [ebp - 0x3c], eax
0082B58D cmp dword ptr [ebp - 0x3c], 0
0082B591 je 0x82b5bd
0082B593 push 0
0082B595 mov ecx, dword ptr [ebp - 0x3c]
0082B598 call 0x9bfbf0
0082B59D mov ecx, dword ptr [ebp - 0x3c]
0082B5A0 call 0x5875a0
0082B5A5 mov ecx, dword ptr [ebp - 8]
0082B5A8 cmp eax, dword ptr [ecx + 0x63]
0082B5AB jne 0x82b5bd
0082B5AD push 0
0082B5AF mov ecx, dword ptr [ebp - 0x10]
0082B5B2 call 0x4dbad0
0082B5B7 mov edx, dword ptr [ebp - 0x3c]
0082B5BA mov dword ptr [ebp - 0x38], edx
0082B5BD mov ecx, dword ptr [ebp - 0x10]
0082B5C0 call 0x4dba90
0082B5C5 mov dword ptr [ebp - 0x3c], eax
0082B5C8 cmp dword ptr [ebp - 0x3c], 0
0082B5CC je 0x82b5ee
0082B5CE push 0
0082B5D0 mov ecx, dword ptr [ebp - 0x3c]
0082B5D3 call 0x9bfbf0
0082B5D8 mov ecx, dword ptr [ebp - 0x3c]
0082B5DB call 0x5875a0
0082B5E0 mov ecx, dword ptr [ebp - 8]
0082B5E3 cmp eax, dword ptr [ecx + 0x63]
0082B5E6 jne 0x82b5ee
0082B5E8 mov edx, dword ptr [ebp - 0x3c]
0082B5EB mov dword ptr [ebp - 0x38], edx
0082B5EE cmp dword ptr [ebp - 0x38], 0
0082B5F2 je 0x82b5fe
0082B5F4 push 1
0082B5F6 mov ecx, dword ptr [ebp - 0x38]
0082B5F9 call 0x9bfbf0
0082B5FE mov eax, dword ptr [ebp - 8]
0082B601 mov ecx, dword ptr [eax + 0x63]
0082B604 push ecx
0082B605 mov ecx, dword ptr [ebp - 0x10]
0082B608 call 0x9e5dc0
0082B60D mov edx, dword ptr [ebp - 8]
0082B610 movzx eax, word ptr [edx + 0x61]
0082B614 cmp eax, 0x44d
0082B619 jne 0x82b736
0082B61F mov ecx, dword ptr [ebp - 8]
0082B622 add ecx, 0x33
0082B625 mov edx, dword ptr [ecx]
0082B627 mov dword ptr [ebp - 0x48], edx
0082B62A mov eax, dword ptr [ecx + 4]
0082B62D mov dword ptr [ebp - 0x44], eax
0082B630 mov ecx, dword ptr [ecx + 8]
0082B633 mov dword ptr [ebp - 0x40], ecx
0082B636 mov ecx, dword ptr [ebp - 0x10]
0082B639 call 0x9e42e0
0082B63E mov edx, dword ptr [eax]
0082B640 mov dword ptr [ebp - 0x60], edx
0082B643 mov ecx, dword ptr [eax + 4]
0082B646 mov dword ptr [ebp - 0x5c], ecx
0082B649 mov edx, dword ptr [eax + 8]
0082B64C mov dword ptr [ebp - 0x58], edx
0082B64F fld dword ptr [ebp - 0x48]
0082B652 fsub dword ptr [ebp - 0x60]
0082B655 fstp dword ptr [ebp - 0x54]
0082B658 fld dword ptr [ebp - 0x44]
0082B65B fsub dword ptr [ebp - 0x5c]
0082B65E fstp dword ptr [ebp - 0x50]
0082B661 fld dword ptr [ebp - 0x40]
0082B664 fsub dword ptr [ebp - 0x58]
0082B667 fstp dword ptr [ebp - 0x4c]
0082B66A xor eax, eax
0082B66C jne 0x82b64f
0082B66E push 0
0082B670 push 0
0082B672 sub esp, 0xc
0082B675 mov ecx, esp
0082B677 mov edx, dword ptr [ebp - 0x54]
0082B67A mov dword ptr [ecx], edx
0082B67C mov eax, dword ptr [ebp - 0x50]
0082B67F mov dword ptr [ecx + 4], eax
0082B682 mov edx, dword ptr [ebp - 0x4c]
0082B685 mov dword ptr [ecx + 8], edx
0082B688 mov ecx, dword ptr [ebp - 0x10]
0082B68B call 0x9e9d10
0082B690 push 0
0082B692 push ecx
0082B693 fldz
0082B695 fstp dword ptr [esp]
0082B698 push 0
0082B69A mov eax, dword ptr [ebp - 8]
0082B69D movzx ecx, byte ptr [eax + 0x69]
0082B6A1 push ecx
0082B6A2 mov edx, dword ptr [ebp - 8]
0082B6A5 movzx eax, byte ptr [edx + 0x67]
0082B6A9 push eax
0082B6AA mov ecx, dword ptr [ebp - 0x10]
0082B6AD call 0x9f2dc0
0082B6B2 mov ecx, dword ptr [ebp - 8]
0082B6B5 movzx edx, byte ptr [ecx + 0x69]
0082B6B9 test edx, edx
0082B6BB jne 0x82b6e8
0082B6BD mov ecx, dword ptr [ebp - 0x10]
0082B6C0 call 0x401020
0082B6C5 shl eax, 5
0082B6C8 mov ecx, dword ptr [ebp - 8]
0082B6CB movzx edx, byte ptr [ecx + 0x67]
0082B6CF mov eax, dword ptr [eax + edx*4 + 0xb97228]
0082B6D6 mov dword ptr [ebp - 0x64], eax
0082B6D9 fild dword ptr [ebp - 0x64]
0082B6DC push ecx
0082B6DD fstp dword ptr [esp]
0082B6E0 mov ecx, dword ptr [ebp - 0x10]
0082B6E3 call 0x9e52b0
0082B6E8 sub esp, 0xc
0082B6EB mov ecx, esp
0082B6ED mov edx, dword ptr [ebp - 0x2c]
0082B6F0 mov dword ptr [ecx], edx
0082B6F2 mov eax, dword ptr [ebp - 0x28]
0082B6F5 mov dword ptr [ecx + 4], eax
0082B6F8 mov edx, dword ptr [ebp - 0x24]
0082B6FB mov dword ptr [ecx + 8], edx
0082B6FE mov ecx, dword ptr [ebp - 0x10]
0082B701 call 0x9e40b0
0082B706 mov eax, dword ptr [ebp - 8]
0082B709 mov ecx, dword ptr [eax + 0x57]
0082B70C push ecx
0082B70D mov edx, dword ptr [ebp - 8]
0082B710 movzx eax, word ptr [edx + 0x61]
0082B714 push eax
0082B715 mov ecx, dword ptr [ebp - 0x10]
0082B718 push ecx
0082B719 mov ecx, dword ptr [ebp - 0x10]
0082B71C call 0x401040
0082B721 mov ecx, eax
0082B723 call 0x9ddce0
0082B728 mov edx, dword ptr [ebp - 4]
0082B72B mov dword ptr [0x1230370], edx
0082B731 jmp 0x82b838
0082B736 mov ecx, dword ptr [ebp - 0x10]
0082B739 call 0x9e9a30
0082B73E test eax, eax
0082B740 jne 0x82b818
0082B746 mov eax, dword ptr [ebp - 8]
0082B749 movzx esi, word ptr [eax + 0x61]
0082B74D mov ecx, dword ptr [ebp - 0x10]
0082B750 call 0x401040
0082B755 mov ecx, eax
0082B757 call 0x50fd70
0082B75C mov ecx, eax
0082B75E call 0x424f30
0082B763 cmp esi, dword ptr [eax]
0082B765 jne 0x82b818
0082B76B mov ecx, dword ptr [ebp - 8]
0082B76E movzx edx, word ptr [ecx + 0x61]
0082B772 cmp edx, 0x407
0082B778 je 0x82b7a6
0082B77A mov eax, dword ptr [ebp - 8]
0082B77D movzx ecx, word ptr [eax + 0x61]
0082B781 cmp ecx, 0x411
0082B787 je 0x82b7a6
0082B789 mov edx, dword ptr [ebp - 8]
0082B78C movzx eax, word ptr [edx + 0x61]
0082B790 cmp eax, 0x42f
0082B795 je 0x82b7a6
0082B797 mov ecx, dword ptr [ebp - 8]
0082B79A movzx edx, word ptr [ecx + 0x61]
0082B79E cmp edx, 0x457
0082B7A4 jne 0x82b818
0082B7A6 push 0
0082B7A8 push 1
0082B7AA mov eax, dword ptr [ebp - 8]
0082B7AD add eax, 0x33
0082B7B0 sub esp, 0xc
0082B7B3 mov ecx, esp
0082B7B5 mov edx, dword ptr [eax]
0082B7B7 mov dword ptr [ecx], edx
0082B7B9 mov edx, dword ptr [eax + 4]
0082B7BC mov dword ptr [ecx + 4], edx
0082B7BF mov eax, dword ptr [eax + 8]
0082B7C2 mov dword ptr [ecx + 8], eax
0082B7C5 mov ecx, dword ptr [ebp - 0x10]
0082B7C8 call 0x9e9d10
0082B7CD push 0
0082B7CF push ecx
0082B7D0 fldz
0082B7D2 fstp dword ptr [esp]
0082B7D5 push 0
0082B7D7 mov ecx, dword ptr [ebp - 8]
0082B7DA movzx edx, byte ptr [ecx + 0x69]
0082B7DE push edx
0082B7DF mov eax, dword ptr [ebp - 8]
0082B7E2 movzx ecx, byte ptr [eax + 0x67]
0082B7E6 push ecx
0082B7E7 mov ecx, dword ptr [ebp - 0x10]
0082B7EA call 0x9f2dc0
0082B7EF sub esp, 0xc
0082B7F2 mov edx, esp
0082B7F4 mov eax, dword ptr [ebp - 0x2c]
0082B7F7 mov dword ptr [edx], eax
0082B7F9 mov ecx, dword ptr [ebp - 0x28]
0082B7FC mov dword ptr [edx + 4], ecx
0082B7FF mov eax, dword ptr [ebp - 0x24]
0082B802 mov dword ptr [edx + 8], eax
0082B805 mov ecx, dword ptr [ebp - 0x10]
0082B808 call 0x9e40b0
0082B80D mov ecx, dword ptr [ebp - 4]
0082B810 mov dword ptr [0x1230370], ecx
0082B816 jmp 0x82b838
0082B818 mov edx, dword ptr [ebp - 0x20]
0082B81B push edx
0082B81C mov eax, dword ptr [ebp - 8]
0082B81F push eax
0082B820 mov ecx, dword ptr [ebp - 0x10]
0082B823 call 0x4dbb10
0082B828 mov ecx, eax
0082B82A call 0x7cec80
0082B82F mov ecx, dword ptr [ebp - 4]
0082B832 mov dword ptr [0x1230370], ecx
0082B838 pop esi
0082B839 mov esp, ebp
0082B83B pop ebp
0082B83C ret 8
