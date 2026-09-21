; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 00A963B0
00A963B0 push ebp
00A963B1 mov ebp, esp
00A963B3 push -1
00A963B5 push 0xabd49d
00A963BA mov eax, dword ptr fs:[0]
00A963C0 push eax
00A963C1 sub esp, 0x98
00A963C7 mov eax, dword ptr [0xc7b480]
00A963CC xor eax, ebp
00A963CE push eax
00A963CF lea eax, [ebp - 0xc]
00A963D2 mov dword ptr fs:[0], eax
00A963D8 mov dword ptr [ebp - 0xa4], ecx
00A963DE mov dword ptr [ebp - 4], 1
00A963E5 push 1
00A963E7 lea ecx, [ebp + 8]
00A963EA call 0x406410
00A963EF push eax
00A963F0 mov eax, dword ptr [ebp - 0xa4]
00A963F6 mov ecx, dword ptr [eax + 0x20]
00A963F9 call 0xa5fde0
00A963FE movzx ecx, al
00A96401 test ecx, ecx
00A96403 jne 0xa96435
00A96405 mov dword ptr [ebp - 0x9c], 0
00A9640F mov byte ptr [ebp - 4], 0
00A96413 lea ecx, [ebp + 8]
00A96416 call 0x406050
00A9641B mov dword ptr [ebp - 4], 0xffffffff
00A96422 lea ecx, [ebp + 0xc]
00A96425 call 0x406050
00A9642A mov eax, dword ptr [ebp - 0x9c]
00A96430 jmp 0xa966f3
00A96435 lea ecx, [ebp + 0xc]
00A96438 call 0x406410
00A9643D push eax
00A9643E mov edx, dword ptr [ebp - 0xa4]
00A96444 mov ecx, dword ptr [edx + 0x20]
00A96447 call 0xa603e0
00A9644C push 0xba4624 ; 'LobbyLevel'
00A96451 mov eax, dword ptr [ebp - 0xa4]
00A96457 mov ecx, dword ptr [eax + 0x20]
00A9645A call 0xa5ea10
00A9645F mov dword ptr [ebp - 0x10], eax
00A96462 mov dword ptr [ebp - 0x14], 0
00A96469 jmp 0xa96474
00A9646B mov ecx, dword ptr [ebp - 0x14]
00A9646E add ecx, 1
00A96471 mov dword ptr [ebp - 0x14], ecx
00A96474 mov edx, dword ptr [ebp - 0x14]
00A96477 cmp edx, dword ptr [ebp - 0x10]
00A9647A jge 0xa966c8
00A96480 lea ecx, [ebp - 0x3c]
00A96483 call 0x485da0
00A96488 mov byte ptr [ebp - 4], 2
00A9648C lea ecx, [ebp - 0x40]
00A9648F call 0x405f90
00A96494 mov byte ptr [ebp - 4], 3
00A96498 mov eax, dword ptr [ebp - 0x14]
00A9649B push eax
00A9649C push 0xba4630 ; 'LobbyLevel[%d]'
00A964A1 lea ecx, [ebp - 0x40]
00A964A4 push ecx
00A964A5 call 0x411c60
00A964AA add esp, 0xc
00A964AD push 0xb96699
00A964B2 push 0xb9dd6c ; 'Level'
00A964B7 lea ecx, [ebp - 0x40]
00A964BA call 0x453f50
00A964BF push eax
00A964C0 mov edx, dword ptr [ebp - 0xa4]
00A964C6 mov ecx, dword ptr [edx + 0x20]
00A964C9 call 0xa5f780
00A964CE mov ecx, eax
00A964D0 call 0x406410
00A964D5 push eax
00A964D6 call 0x666139
00A964DB add esp, 4
00A964DE mov dword ptr [ebp - 0x3c], eax
00A964E1 mov eax, dword ptr [ebp - 0x14]
00A964E4 push eax
00A964E5 push 0xba4640 ; 'LobbyLevel[%d]/BattleMode'
00A964EA lea ecx, [ebp - 0x40]
00A964ED push ecx
00A964EE call 0x411c60
00A964F3 add esp, 0xc
00A964F6 lea ecx, [ebp - 0x40]
00A964F9 call 0x406410
00A964FE push eax
00A964FF mov edx, dword ptr [ebp - 0xa4]
00A96505 mov ecx, dword ptr [edx + 0x20]
00A96508 call 0xa5ea10
00A9650D mov dword ptr [ebp - 0x18], eax
00A96510 mov dword ptr [ebp - 0x44], 0
00A96517 jmp 0xa96522
00A96519 mov eax, dword ptr [ebp - 0x44]
00A9651C add eax, 1
00A9651F mov dword ptr [ebp - 0x44], eax
00A96522 mov ecx, dword ptr [ebp - 0x44]
00A96525 cmp ecx, dword ptr [ebp - 0x18]
00A96528 jge 0xa96691
00A9652E lea ecx, [ebp - 0x60]
00A96531 call 0x485de0
00A96536 mov byte ptr [ebp - 4], 4
00A9653A mov edx, dword ptr [ebp - 0x44]
00A9653D push edx
00A9653E mov eax, dword ptr [ebp - 0x14]
00A96541 push eax
00A96542 push 0xba465c ; 'LobbyLevel[%d]/BattleMode[%d]'
00A96547 lea ecx, [ebp - 0x40]
00A9654A push ecx
00A9654B call 0x411c60
00A96550 add esp, 0x10
00A96553 push 0xb96699
00A96558 push 0xba467c ; 'Mode'
00A9655D lea ecx, [ebp - 0x40]
00A96560 call 0x453f50
00A96565 push eax
00A96566 mov edx, dword ptr [ebp - 0xa4]
00A9656C mov ecx, dword ptr [edx + 0x20]
00A9656F call 0xa5f780
00A96574 mov ecx, eax
00A96576 call 0x406410
00A9657B push eax
00A9657C call 0x666139
00A96581 add esp, 4
00A96584 mov dword ptr [ebp - 0x60], eax
00A96587 mov eax, dword ptr [ebp - 0x44]
00A9658A push eax
00A9658B mov ecx, dword ptr [ebp - 0x14]
00A9658E push ecx
00A9658F push 0xba4684 ; 'LobbyLevel[%d]/BattleMode[%d]/Map'
00A96594 lea edx, [ebp - 0x40]
00A96597 push edx
00A96598 call 0x411c60
00A9659D add esp, 0x10
00A965A0 lea ecx, [ebp - 0x40]
00A965A3 call 0x406410
00A965A8 push eax
00A965A9 mov eax, dword ptr [ebp - 0xa4]
00A965AF mov ecx, dword ptr [eax + 0x20]
00A965B2 call 0xa5ea10
00A965B7 mov dword ptr [ebp - 0x64], eax
00A965BA mov dword ptr [ebp - 0x68], 0
00A965C1 jmp 0xa965cc
00A965C3 mov ecx, dword ptr [ebp - 0x68]
00A965C6 add ecx, 1
00A965C9 mov dword ptr [ebp - 0x68], ecx
00A965CC mov edx, dword ptr [ebp - 0x68]
00A965CF cmp edx, dword ptr [ebp - 0x64]
00A965D2 jge 0xa96669
00A965D8 mov eax, dword ptr [ebp - 0x68]
00A965DB push eax
00A965DC mov ecx, dword ptr [ebp - 0x44]
00A965DF push ecx
00A965E0 mov edx, dword ptr [ebp - 0x14]
00A965E3 push edx
00A965E4 push 0xba46a8 ; 'LobbyLevel[%d]/BattleMode[%d]/Map[%d]'
00A965E9 lea eax, [ebp - 0x40]
00A965EC push eax
00A965ED call 0x411c60
00A965F2 add esp, 0x14
00A965F5 push 0xb96699
00A965FA push 0xb9de18 ; mapselect Map attribute ID
00A965FF lea ecx, [ebp - 0x40]
00A96602 call 0x453f50
00A96607 push eax
00A96608 mov ecx, dword ptr [ebp - 0xa4]
00A9660E mov ecx, dword ptr [ecx + 0x20]
00A96611 call 0xa5f780
00A96616 mov ecx, eax
00A96618 call 0x406410
00A9661D push eax
00A9661E call 0x666139
00A96623 add esp, 4
00A96626 mov dword ptr [ebp - 0x98], eax
00A9662C mov edx, dword ptr [ebp - 0x98]
00A96632 mov dword ptr [ebp - 0x90], edx
00A96638 mov eax, dword ptr [ebp - 0x60]
00A9663B mov dword ptr [ebp - 0x94], eax
00A96641 mov dword ptr [ebp - 0x8c], 1
00A9664B mov dword ptr [ebp - 0x88], 0
00A96655 lea ecx, [ebp - 0x94]
00A9665B push ecx
00A9665C lea ecx, [ebp - 0x5c]
00A9665F call 0x486210
00A96664 jmp 0xa965c3
00A96669 lea edx, [ebp - 0x60]
00A9666C push edx
00A9666D lea eax, [ebp - 0x60]
00A96670 push eax
00A96671 lea ecx, [ebp - 0x38]
00A96674 call 0x486290
00A96679 mov ecx, eax
00A9667B call 0x485e20
00A96680 mov byte ptr [ebp - 4], 3
00A96684 lea ecx, [ebp - 0x60]
00A96687 call 0x485e00
00A9668C jmp 0xa96519
00A96691 lea ecx, [ebp - 0x3c]
00A96694 push ecx
00A96695 lea edx, [ebp - 0x3c]
00A96698 push edx
00A96699 mov ecx, dword ptr [ebp - 0xa4]
00A9669F call 0x4867e0
00A966A4 mov ecx, eax
00A966A6 call 0x485e50
00A966AB mov byte ptr [ebp - 4], 2
00A966AF lea ecx, [ebp - 0x40]
00A966B2 call 0x406050
00A966B7 mov byte ptr [ebp - 4], 1
00A966BB lea ecx, [ebp - 0x3c]
00A966BE call 0x485dc0
00A966C3 jmp 0xa9646b
00A966C8 mov dword ptr [ebp - 0xa0], 1
00A966D2 mov byte ptr [ebp - 4], 0
00A966D6 lea ecx, [ebp + 8]
00A966D9 call 0x406050
00A966DE mov dword ptr [ebp - 4], 0xffffffff
00A966E5 lea ecx, [ebp + 0xc]
00A966E8 call 0x406050
00A966ED mov eax, dword ptr [ebp - 0xa0]
00A966F3 mov ecx, dword ptr [ebp - 0xc]
00A966F6 mov dword ptr fs:[0], ecx
00A966FD pop ecx
00A966FE mov esp, ebp
00A96700 pop ebp
00A96701 ret 8
; FUNCTION 00A96780
00A96780 push ebp
00A96781 mov ebp, esp
00A96783 push -1
00A96785 push 0xac41b1
00A9678A mov eax, dword ptr fs:[0]
00A96790 push eax
00A96791 sub esp, 0x20
00A96794 mov eax, dword ptr [0xc7b480]
00A96799 xor eax, ebp
00A9679B push eax
00A9679C lea eax, [ebp - 0xc]
00A9679F mov dword ptr fs:[0], eax
00A967A5 cmp dword ptr [0x17c8968], 0
00A967AC jne 0xa96844
00A967B2 push 0x24
00A967B4 call 0x667fbb
00A967B9 add esp, 4
00A967BC mov dword ptr [ebp - 0x14], eax
00A967BF mov dword ptr [ebp - 4], 0
00A967C6 cmp dword ptr [ebp - 0x14], 0
00A967CA je 0xa967d9
00A967CC mov ecx, dword ptr [ebp - 0x14]
00A967CF call 0xa96710
00A967D4 mov dword ptr [ebp - 0x20], eax
00A967D7 jmp 0xa967e0
00A967D9 mov dword ptr [ebp - 0x20], 0
00A967E0 mov eax, dword ptr [ebp - 0x20]
00A967E3 mov dword ptr [ebp - 0x10], eax
00A967E6 mov dword ptr [ebp - 4], 0xffffffff
00A967ED mov ecx, dword ptr [ebp - 0x10]
00A967F0 mov dword ptr [0x17c8968], ecx
00A967F6 push ecx
00A967F7 mov ecx, esp
00A967F9 mov dword ptr [ebp - 0x18], esp
00A967FC push 0xba45f8 ; '/MapSelectInfo'
00A96801 call 0x405fd0
00A96806 mov dword ptr [ebp - 0x24], eax
00A96809 mov edx, dword ptr [ebp - 0x24]
00A9680C mov dword ptr [ebp - 0x28], edx
00A9680F mov dword ptr [ebp - 4], 1
00A96816 push ecx
00A96817 mov eax, esp
00A96819 mov dword ptr [ebp - 0x1c], esp
00A9681C push 0xba4608 ; '\\data\\config\\mapselect.xml'
00A96821 push 0x17c8e58
00A96826 push eax
00A96827 call 0x406200
00A9682C add esp, 0xc
00A9682F mov dword ptr [ebp - 0x2c], eax
00A96832 mov dword ptr [ebp - 4], 0xffffffff
00A96839 mov ecx, dword ptr [0x17c8968]
00A9683F call 0xa963b0
00A96844 mov eax, dword ptr [0x17c8968]
00A96849 mov ecx, dword ptr [ebp - 0xc]
00A9684C mov dword ptr fs:[0], ecx
00A96853 pop ecx
00A96854 mov esp, ebp
00A96856 pop ebp
00A96857 ret
; FUNCTION 00A96220
00A96220 push ebp
00A96221 mov ebp, esp
00A96223 sub esp, 0x34
00A96226 mov dword ptr [ebp - 0x34], ecx
00A96229 mov dword ptr [ebp + 8], 4
00A96230 lea eax, [ebp + 8]
00A96233 push eax
00A96234 lea ecx, [ebp - 8]
00A96237 push ecx
00A96238 mov ecx, dword ptr [ebp - 0x34]
00A9623B call 0x486ba0
00A96240 lea edx, [ebp - 0x18]
00A96243 push edx
00A96244 mov ecx, dword ptr [ebp - 0x34]
00A96247 call 0x45abb0
00A9624C push eax
00A9624D lea ecx, [ebp - 8]
00A96250 call 0x4ab8f0
00A96255 movzx eax, al
00A96258 test eax, eax
00A9625A je 0xa962f1
00A96260 lea ecx, [ebp + 0xc]
00A96263 push ecx
00A96264 lea edx, [ebp - 0x10]
00A96267 push edx
00A96268 lea eax, [ebp + 8]
00A9626B push eax
00A9626C mov ecx, dword ptr [ebp - 0x34]
00A9626F call 0x4867e0
00A96274 add eax, 4
00A96277 mov ecx, eax
00A96279 call 0x486710
00A9627E lea ecx, [ebp - 0x20]
00A96281 push ecx
00A96282 lea edx, [ebp + 8]
00A96285 push edx
00A96286 mov ecx, dword ptr [ebp - 0x34]
00A96289 call 0x4867e0
00A9628E add eax, 4
00A96291 mov ecx, eax
00A96293 call 0x45abb0
00A96298 push eax
00A96299 lea ecx, [ebp - 0x10]
00A9629C call 0x4ab8f0
00A962A1 movzx eax, al
00A962A4 test eax, eax
00A962A6 je 0xa962f1
00A962A8 lea ecx, [ebp - 0x28]
00A962AB push ecx
00A962AC lea ecx, [ebp - 0x10]
00A962AF call 0x4305b0
00A962B4 add eax, 8
00A962B7 mov ecx, eax
00A962B9 call 0x4f2590
00A962BE mov edx, dword ptr [eax + 4]
00A962C1 push edx
00A962C2 mov eax, dword ptr [eax]
00A962C4 push eax
00A962C5 lea ecx, [ebp - 0x30]
00A962C8 push ecx
00A962C9 lea ecx, [ebp - 0x10]
00A962CC call 0x4305b0
00A962D1 add eax, 8
00A962D4 mov ecx, eax
00A962D6 call 0x4d6050
00A962DB mov edx, dword ptr [eax + 4]
00A962DE push edx
00A962DF mov eax, dword ptr [eax]
00A962E1 push eax
00A962E2 mov ecx, dword ptr [ebp + 0x10]
00A962E5 call 0x48a910
00A962EA mov eax, 1
00A962EF jmp 0xa962f3
00A962F1 xor eax, eax
00A962F3 mov esp, ebp
00A962F5 pop ebp
00A962F6 ret 0xc
; FUNCTION 007F89A0
007F89A0 push ebp
007F89A1 mov ebp, esp
007F89A3 push -1
007F89A5 push 0xad73a1
007F89AA mov eax, dword ptr fs:[0]
007F89B0 push eax
007F89B1 sub esp, 0xbc
007F89B7 mov eax, dword ptr [0xc7b480]
007F89BC xor eax, ebp
007F89BE mov dword ptr [ebp - 0x14], eax
007F89C1 push eax
007F89C2 lea eax, [ebp - 0xc]
007F89C5 mov dword ptr fs:[0], eax
007F89CB mov dword ptr [ebp - 0xc0], ecx
007F89D1 mov dword ptr [ebp - 0x10], 0
007F89D8 jmp 0x7f89e3
007F89DA mov eax, dword ptr [ebp - 0x10]
007F89DD add eax, 1
007F89E0 mov dword ptr [ebp - 0x10], eax
007F89E3 cmp dword ptr [ebp - 0x10], 6
007F89E7 jge 0x7f8c5d
007F89ED lea ecx, [ebp - 0x10]
007F89F0 push ecx
007F89F1 lea edx, [ebp - 0x7c]
007F89F4 push edx
007F89F5 call 0xa44160
007F89FA add esp, 8
007F89FD mov dword ptr [ebp - 0xc4], eax
007F8A03 mov eax, dword ptr [ebp - 0xc4]
007F8A09 mov dword ptr [ebp - 0xc8], eax
007F8A0F mov dword ptr [ebp - 4], 0
007F8A16 mov ecx, dword ptr [ebp - 0xc8]
007F8A1C push ecx
007F8A1D mov edx, dword ptr [0xb96d10]
007F8A23 push edx
007F8A24 lea eax, [ebp - 0x30]
007F8A27 push eax
007F8A28 call 0x411d70
007F8A2D add esp, 0xc
007F8A30 mov byte ptr [ebp - 4], 2
007F8A34 lea ecx, [ebp - 0x7c]
007F8A37 call 0x4056d0
007F8A3C lea ecx, [ebp - 0x30]
007F8A3F push ecx
007F8A40 mov edx, dword ptr [ebp + 0x10]
007F8A43 push edx
007F8A44 call 0x4221c0
007F8A49 add esp, 8
007F8A4C movzx eax, al
007F8A4F test eax, eax
007F8A51 je 0x7f8c49
007F8A57 cmp dword ptr [ebp + 0xc], 0x303
007F8A5E je 0x7f8a76
007F8A60 cmp dword ptr [ebp + 0xc], 0x302
007F8A67 je 0x7f8a76
007F8A69 cmp dword ptr [ebp + 0xc], 0x304
007F8A70 jne 0x7f8c49
007F8A76 lea ecx, [ebp - 0x58]
007F8A79 call 0x4eaea0
007F8A7E mov byte ptr [ebp - 4], 3
007F8A82 mov ecx, dword ptr [ebp - 0xc0]
007F8A88 mov edx, dword ptr [ecx + 0x600]
007F8A8E push edx
007F8A8F lea eax, [ebp - 0x58]
007F8A92 push eax
007F8A93 call 0xa55fb0
007F8A98 mov ecx, eax
007F8A9A call 0xa56560
007F8A9F lea ecx, [ebp - 0x58]
007F8AA2 call 0x4c4cb0
007F8AA7 test eax, eax
007F8AA9 ja 0x7f8acb
007F8AAB mov byte ptr [ebp - 4], 2
007F8AAF lea ecx, [ebp - 0x58]
007F8AB2 call 0x4eae50
007F8AB7 mov dword ptr [ebp - 4], 0xffffffff
007F8ABE lea ecx, [ebp - 0x30]
007F8AC1 call 0x4056d0
007F8AC6 jmp 0x7f8c5d
007F8ACB lea ecx, [ebp - 0x38]
007F8ACE push ecx
007F8ACF lea ecx, [ebp - 0x58]
007F8AD2 call 0x5504a0
007F8AD7 mov dword ptr [ebp - 0x5c], 0
007F8ADE jmp 0x7f8af1
007F8AE0 lea ecx, [ebp - 0x38]
007F8AE3 call 0x4eaf30
007F8AE8 mov edx, dword ptr [ebp - 0x5c]
007F8AEB add edx, 1
007F8AEE mov dword ptr [ebp - 0x5c], edx
007F8AF1 lea eax, [ebp - 0x84]
007F8AF7 push eax
007F8AF8 lea ecx, [ebp - 0x58]
007F8AFB call 0x45abb0
007F8B00 push eax
007F8B01 lea ecx, [ebp - 0x38]
007F8B04 call 0x4ab8f0
007F8B09 movzx ecx, al
007F8B0C test ecx, ecx
007F8B0E je 0x7f8c3d
007F8B14 mov edx, dword ptr [ebp - 0xc0]
007F8B1A mov eax, dword ptr [edx + 0x578]
007F8B20 imul eax, eax, 6
007F8B23 add eax, dword ptr [ebp - 0x10]
007F8B26 cmp dword ptr [ebp - 0x5c], eax
007F8B29 jne 0x7f8c38
007F8B2F lea ecx, [ebp - 0x38]
007F8B32 call 0x4305b0
007F8B37 add eax, 4
007F8B3A push eax
007F8B3B mov ecx, dword ptr [ebp - 0xc0]
007F8B41 add ecx, 0x580
007F8B47 call 0x481580
007F8B4C mov ecx, dword ptr [ebp - 0xc0]
007F8B52 call 0x7f7ea0
007F8B57 movzx ecx, byte ptr [ebp + 8]
007F8B5B test ecx, ecx
007F8B5D je 0x7f8c1b
007F8B63 mov edx, dword ptr [0xb96d38]
007F8B69 push edx
007F8B6A lea ecx, [ebp - 0xa0]
007F8B70 call 0x405650
007F8B75 mov byte ptr [ebp - 4], 4
007F8B79 lea eax, [ebp - 0xa0]
007F8B7F push eax
007F8B80 mov ecx, dword ptr [ebp - 0xc0]
007F8B86 call 0x75fbf0
007F8B8B mov dword ptr [ebp - 0x60], eax
007F8B8E mov byte ptr [ebp - 4], 3
007F8B92 lea ecx, [ebp - 0xa0]
007F8B98 call 0x4056d0
007F8B9D cmp dword ptr [ebp - 0x60], 0
007F8BA1 je 0x7f8bec
007F8BA3 mov ecx, dword ptr [ebp - 0xc0]
007F8BA9 add ecx, 0x59c
007F8BAF call 0x406410
007F8BB4 push eax
007F8BB5 lea ecx, [ebp - 0xbc]
007F8BBB call 0x405650
007F8BC0 mov byte ptr [ebp - 4], 5
007F8BC4 push 1
007F8BC6 lea ecx, [ebp - 0xbc]
007F8BCC push ecx
007F8BCD mov edx, dword ptr [ebp - 0x60]
007F8BD0 mov eax, dword ptr [edx]
007F8BD2 mov ecx, dword ptr [ebp - 0x60]
007F8BD5 mov edx, dword ptr [eax + 0xd4]
007F8BDB call edx
007F8BDD mov byte ptr [ebp - 4], 3
007F8BE1 lea ecx, [ebp - 0xbc]
007F8BE7 call 0x4056d0
007F8BEC push 0
007F8BEE mov ecx, dword ptr [ebp - 0xc0]
007F8BF4 call 0x7f6b00
007F8BF9 mov ecx, dword ptr [ebp - 0xc0]
007F8BFF call 0x4ead50
007F8C04 push eax
007F8C05 mov eax, dword ptr [ebp - 0xc0]
007F8C0B mov edx, dword ptr [eax]
007F8C0D mov ecx, dword ptr [ebp - 0xc0]
007F8C13 mov eax, dword ptr [edx + 0x124]
007F8C19 call eax
007F8C1B mov byte ptr [ebp - 4], 2
007F8C1F lea ecx, [ebp - 0x58]
007F8C22 call 0x4eae50
007F8C27 mov dword ptr [ebp - 4], 0xffffffff
007F8C2E lea ecx, [ebp - 0x30]
007F8C31 call 0x4056d0
007F8C36 jmp 0x7f8c5d
007F8C38 jmp 0x7f8ae0
007F8C3D mov byte ptr [ebp - 4], 2
007F8C41 lea ecx, [ebp - 0x58]
007F8C44 call 0x4eae50
007F8C49 mov dword ptr [ebp - 4], 0xffffffff
007F8C50 lea ecx, [ebp - 0x30]
007F8C53 call 0x4056d0
007F8C58 jmp 0x7f89da
007F8C5D mov ecx, dword ptr [ebp - 0xc]
007F8C60 mov dword ptr fs:[0], ecx
007F8C67 pop ecx
007F8C68 mov ecx, dword ptr [ebp - 0x14]
007F8C6B xor ecx, ebp
007F8C6D call 0x6634fb
007F8C72 mov esp, ebp
007F8C74 pop ebp
007F8C75 ret 0xc
; FUNCTION 00481580
00481580 push ebp
00481581 mov ebp, esp
00481583 push ecx
00481584 push esi
00481585 push edi
00481586 mov dword ptr [ebp - 4], ecx
00481589 mov eax, dword ptr [ebp + 8]
0048158C push eax
0048158D mov ecx, dword ptr [ebp - 4]
00481590 call 0x481480
00481595 mov esi, dword ptr [ebp + 8]
00481598 add esi, 0x54
0048159B mov edi, dword ptr [ebp - 4]
0048159E add edi, 0x54
004815A1 mov ecx, 0xb
004815A6 rep movsd dword ptr es:[edi], dword ptr [esi]
004815A8 mov eax, dword ptr [ebp - 4]
004815AB pop edi
004815AC pop esi
004815AD mov esp, ebp
004815AF pop ebp
004815B0 ret 4
