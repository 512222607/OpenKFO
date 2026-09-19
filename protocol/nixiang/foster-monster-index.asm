; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 942350 -> A62AE0 name index -> 20400/67, 9421D0 -> 20401/47.
; A633C3 appends template name to +40 vector then sorts via 4D8B50.
; range 0x942350
00942350 push ebp
00942351 mov ebp, esp
00942353 push -1
00942355 push 0xadbce4
0094235A mov eax, dword ptr fs:[0]
00942360 push eax
00942361 sub esp, 0xb0
00942367 push esi
00942368 mov eax, dword ptr [0xc7b480]
0094236D xor eax, ebp
0094236F push eax
00942370 lea eax, [ebp - 0xc]
00942373 mov dword ptr fs:[0], eax
00942379 mov dword ptr [ebp - 0xb0], ecx
0094237F mov eax, dword ptr [ebp + 8]
00942382 push eax
00942383 call 0x68bb90
00942388 add esp, 4
0094238B cmp eax, 5
0094238E jne 0x9423ea
00942390 push 1
00942392 mov ecx, dword ptr [ebp + 8]
00942395 push ecx
00942396 call 0x68c0c0
0094239B add esp, 8
0094239E test eax, eax
009423A0 je 0x9423ea
009423A2 push 2
009423A4 mov edx, dword ptr [ebp + 8]
009423A7 push edx
009423A8 call 0x68c0c0
009423AD add esp, 8
009423B0 test eax, eax
009423B2 je 0x9423ea
009423B4 push 3
009423B6 mov eax, dword ptr [ebp + 8]
009423B9 push eax
009423BA call 0x68c0c0
009423BF add esp, 8
009423C2 test eax, eax
009423C4 je 0x9423ea
009423C6 push 4
009423C8 mov ecx, dword ptr [ebp + 8]
009423CB push ecx
009423CC call 0x68c0c0
009423D1 add esp, 8
009423D4 test eax, eax
009423D6 je 0x9423ea
009423D8 push 5
009423DA mov edx, dword ptr [ebp + 8]
009423DD push edx
009423DE call 0x68c120
009423E3 add esp, 8
009423E6 test eax, eax
009423E8 jne 0x942402
009423EA push 0xbad20c
009423EF push 0
009423F1 mov eax, dword ptr [ebp + 8]
009423F4 push eax
009423F5 call 0x639f10
009423FA add esp, 0xc
009423FD jmp 0x94273d
00942402 push 0
00942404 push 5
00942406 mov ecx, dword ptr [ebp + 8]
00942409 push ecx
0094240A call 0x68c430
0094240F add esp, 0xc
00942412 push eax
00942413 lea ecx, [ebp - 0xa0]
00942419 call 0x405650
0094241E mov dword ptr [ebp - 0xb4], eax
00942424 mov edx, dword ptr [ebp - 0xb4]
0094242A mov dword ptr [ebp - 0xb8], edx
00942430 mov dword ptr [ebp - 4], 0
00942437 mov eax, dword ptr [ebp - 0xb8]
0094243D push eax
0094243E call 0x4d4380
00942443 mov ecx, eax
00942445 call 0xa62ae0
0094244A mov dword ptr [ebp - 0x70], eax
0094244D mov dword ptr [ebp - 4], 0xffffffff
00942454 lea ecx, [ebp - 0xa0]
0094245A call 0x4056d0
0094245F cmp dword ptr [ebp - 0x70], 0
00942463 jge 0x94247d
00942465 push 0xbad22c
0094246A push 0
0094246C mov ecx, dword ptr [ebp + 8]
0094246F push ecx
00942470 call 0x639f10
00942475 add esp, 0xc
00942478 jmp 0x94273d
0094247D push 1
0094247F mov edx, dword ptr [ebp + 8]
00942482 push edx
00942483 call 0x68c320
00942488 add esp, 8
0094248B fstp dword ptr [ebp - 0x18]
0094248E push 2
00942490 mov eax, dword ptr [ebp + 8]
00942493 push eax
00942494 call 0x68c320
00942499 add esp, 8
0094249C fstp dword ptr [ebp - 0x14]
0094249F push 3
009424A1 mov ecx, dword ptr [ebp + 8]
009424A4 push ecx
009424A5 call 0x68c320
009424AA add esp, 8
009424AD fstp dword ptr [ebp - 0x10]
009424B0 push 4
009424B2 mov edx, dword ptr [ebp + 8]
009424B5 push edx
009424B6 call 0x68c320
009424BB add esp, 8
009424BE call 0x66e430
009424C3 mov dword ptr [ebp - 0x6c], eax
009424C6 mov ecx, dword ptr [ebp - 0xb0]
009424CC add ecx, 0x5c
009424CF call 0x4c4cb0
009424D4 test eax, eax
009424D6 jne 0x9424f0
009424D8 push 0xbad258
009424DD push 0
009424DF mov eax, dword ptr [ebp + 8]
009424E2 push eax
009424E3 call 0x639f10
009424E8 add esp, 0xc
009424EB jmp 0x94273d
009424F0 mov ecx, dword ptr [ebp - 0xb0]
009424F6 add ecx, 0x5c
009424F9 call 0x4d4660
009424FE mov ecx, dword ptr [eax]
00942500 mov dword ptr [ebp - 0x7c], ecx
00942503 mov edx, dword ptr [eax + 4]
00942506 mov dword ptr [ebp - 0x78], edx
00942509 mov eax, dword ptr [ebp - 0x70]
0094250C push eax
0094250D call 0x4d4380
00942512 mov ecx, eax
00942514 call 0xa62b40
00942519 mov dword ptr [ebp - 0x84], eax
0094251F cmp dword ptr [ebp - 0x84], 0
00942526 jne 0x942540
00942528 push 0xbad27c
0094252D push 0
0094252F mov ecx, dword ptr [ebp + 8]
00942532 push ecx
00942533 call 0x639f10
00942538 add esp, 0xc
0094253B jmp 0x94273d
00942540 mov edx, dword ptr [ebp - 0x70]
00942543 push edx
00942544 mov ecx, dword ptr [ebp - 0xb0]
0094254A call 0x940f20
0094254F movzx eax, al
00942552 test eax, eax
00942554 jne 0x94256e
00942556 push 0xbad258
0094255B push 0
0094255D mov ecx, dword ptr [ebp + 8]
00942560 push ecx
00942561 call 0x639f10
00942566 add esp, 0xc
00942569 jmp 0x94273d
0094256E mov edx, dword ptr [ebp - 0x7c]
00942571 mov dword ptr [ebp - 0x3d], edx
00942574 mov eax, dword ptr [ebp - 0x78]
00942577 mov dword ptr [ebp - 0x39], eax
0094257A mov ecx, dword ptr [ebp - 0x70]
0094257D mov dword ptr [ebp - 0x35], ecx
00942580 mov edx, dword ptr [ebp - 0x18]
00942583 mov dword ptr [ebp - 0x31], edx
00942586 mov eax, dword ptr [ebp - 0x14]
00942589 mov dword ptr [ebp - 0x2d], eax
0094258C mov ecx, dword ptr [ebp - 0x10]
0094258F mov dword ptr [ebp - 0x29], ecx
00942592 mov edx, dword ptr [ebp - 0x6c]
00942595 mov dword ptr [ebp - 0x25], edx
00942598 push 0
0094259A push 0
0094259C push 0x43
0094259E lea eax, [ebp - 0x64]
009425A1 push eax
009425A2 push 0x4fb0
009425A7 call 0xa3fbb0
009425AC add esp, 0x14
009425AF mov ecx, dword ptr [ebp - 0xb0]
009425B5 mov edx, dword ptr [ecx + 0x7c]
009425B8 add edx, 1
009425BB mov eax, dword ptr [ebp - 0xb0]
009425C1 mov dword ptr [eax + 0x7c], edx
009425C4 mov ecx, dword ptr [ebp - 0xb0]
009425CA mov edx, dword ptr [ecx + 0x7c]
009425CD push edx
009425CE mov eax, dword ptr [ebp - 0x6c]
009425D1 push eax
009425D2 lea ecx, [ebp - 0x18]
009425D5 push ecx
009425D6 mov edx, dword ptr [ebp - 0x70]
009425D9 push edx
009425DA mov eax, dword ptr [ebp - 0x78]
009425DD push eax
009425DE mov ecx, dword ptr [ebp - 0x7c]
009425E1 push ecx
009425E2 mov edx, dword ptr [ebp - 0xb0]
009425E8 mov eax, dword ptr [edx]
009425EA mov ecx, dword ptr [ebp - 0xb0]
009425F0 mov edx, dword ptr [eax + 0x108]
009425F6 call edx
009425F8 movzx eax, al
009425FB test eax, eax
009425FD jne 0x94262c
009425FF mov ecx, dword ptr [ebp - 0xb0]
00942605 mov edx, dword ptr [ecx + 0x7c]
00942608 sub edx, 1
0094260B mov eax, dword ptr [ebp - 0xb0]
00942611 mov dword ptr [eax + 0x7c], edx
00942614 push 0xbad2a0
00942619 push 0
0094261B mov ecx, dword ptr [ebp + 8]
0094261E push ecx
0094261F call 0x639f10
00942624 add esp, 0xc
00942627 jmp 0x94273d
0094262C mov ecx, dword ptr [ebp - 0xb0]
00942632 add ecx, 0x5c
00942635 call 0x4d4860
0094263A mov edx, dword ptr [ebp - 0x78]
0094263D push edx
0094263E mov eax, dword ptr [ebp - 0x7c]
00942641 push eax
00942642 mov ecx, dword ptr [0x17c8708]
00942648 call 0x818c00
0094264D mov dword ptr [ebp - 0x80], eax
00942650 cmp dword ptr [ebp - 0x80], -1
00942654 je 0x942661
00942656 mov ecx, dword ptr [ebp - 0x80]
00942659 mov dword ptr [ebp - 0xbc], ecx
0094265F jmp 0x94266b
00942661 mov dword ptr [ebp - 0xbc], 0xfffffffe
0094266B mov edx, dword ptr [ebp - 0x84]
00942671 push edx
00942672 push 0
00942674 mov eax, dword ptr [ebp - 0xbc]
0094267A push eax
0094267B lea ecx, [ebp - 0xac]
00942681 call 0x4d4310
00942686 mov esi, eax
00942688 mov ecx, dword ptr [ebp - 0xb0]
0094268E add ecx, 0x7c
00942691 push ecx
00942692 mov ecx, dword ptr [ebp - 0xb0]
00942698 add ecx, 0x3c
0094269B call 0x4d4470
009426A0 mov edx, dword ptr [esi]
009426A2 mov dword ptr [eax], edx
009426A4 mov ecx, dword ptr [esi + 4]
009426A7 mov dword ptr [eax + 4], ecx
009426AA mov edx, dword ptr [esi + 8]
009426AD mov dword ptr [eax + 8], edx
009426B0 mov eax, dword ptr [ebp - 0xb0]
009426B6 mov ecx, dword ptr [eax + 0x7c]
009426B9 mov dword ptr [ebp - 0x68], ecx
009426BC lea edx, [ebp - 0x7c]
009426BF push edx
009426C0 mov ecx, dword ptr [ebp - 0xb0]
009426C6 add ecx, 0xb4
009426CC call 0x4d7230
009426D1 mov dword ptr [eax], 0
009426D7 mov eax, dword ptr [ebp + 8]
009426DA push eax
009426DB call 0x68bb90
009426E0 add esp, 4
009426E3 neg eax
009426E5 sub eax, 1
009426E8 push eax
009426E9 mov ecx, dword ptr [ebp + 8]
009426EC push ecx
009426ED call 0x68bbb0
009426F2 add esp, 8
009426F5 push 1
009426F7 mov edx, dword ptr [ebp + 8]
009426FA push edx
009426FB call 0x68b9a0
00942700 add esp, 8
00942703 test eax, eax
00942705 jne 0x94271c
00942707 push 0xbad2c4
0094270C push 0
0094270E mov eax, dword ptr [ebp + 8]
00942711 push eax
00942712 call 0x639f10
00942717 add esp, 0xc
0094271A jmp 0x94273d
0094271C fild dword ptr [ebp - 0x68]
0094271F sub esp, 8
00942722 fstp qword ptr [esp]
00942725 mov ecx, dword ptr [ebp + 8]
00942728 push ecx
00942729 call 0x68c720
0094272E add esp, 0xc
00942731 mov edx, dword ptr [ebp + 8]
00942734 push edx
00942735 call 0x68bb90
0094273A add esp, 4
0094273D mov ecx, dword ptr [ebp - 0xc]
00942740 mov dword ptr fs:[0], ecx
00942747 pop ecx
00942748 pop esi
00942749 mov esp, ebp
0094274B pop ebp
0094274C ret 4
; range 0x9421d0
009421D0 push ebp
009421D1 mov ebp, esp
009421D3 sub esp, 0x70
009421D6 mov dword ptr [ebp - 0x70], ecx
009421D9 mov eax, dword ptr [ebp + 8]
009421DC push eax
009421DD call 0x68bb90
009421E2 add esp, 4
009421E5 cmp eax, 1
009421E8 jne 0x9421fc
009421EA push 1
009421EC mov ecx, dword ptr [ebp + 8]
009421EF push ecx
009421F0 call 0x68c0c0
009421F5 add esp, 8
009421F8 test eax, eax
009421FA jne 0x942214
009421FC push 0xbad2e4
00942201 push 0
00942203 mov edx, dword ptr [ebp + 8]
00942206 push edx
00942207 call 0x639f10
0094220C add esp, 0xc
0094220F jmp 0x94233c
00942214 push 1
00942216 mov eax, dword ptr [ebp + 8]
00942219 push eax
0094221A call 0x68c370
0094221F add esp, 8
00942222 cdq
00942223 mov dword ptr [ebp - 0x48], eax
00942226 mov dword ptr [ebp - 0x44], edx
00942229 mov ecx, dword ptr [ebp - 0x48]
0094222C mov dword ptr [ebp - 0x54], ecx
0094222F lea edx, [ebp - 0x54]
00942232 push edx
00942233 lea eax, [ebp - 0xc]
00942236 push eax
00942237 mov ecx, dword ptr [ebp - 0x70]
0094223A add ecx, 0x3c
0094223D call 0x4d45a0
00942242 lea ecx, [ebp - 0x5c]
00942245 push ecx
00942246 mov ecx, dword ptr [ebp - 0x70]
00942249 add ecx, 0x3c
0094224C call 0x45abb0
00942251 push eax
00942252 lea ecx, [ebp - 0xc]
00942255 call 0x4ab920
0094225A movzx edx, al
0094225D test edx, edx
0094225F je 0x942279
00942261 push 0xbad304
00942266 push 0
00942268 mov eax, dword ptr [ebp + 8]
0094226B push eax
0094226C call 0x639f10
00942271 add esp, 0xc
00942274 jmp 0x94233c
00942279 lea ecx, [ebp - 0xc]
0094227C call 0x4305b0
00942281 mov ecx, dword ptr [eax + 4]
00942284 push ecx
00942285 mov ecx, dword ptr [0x17c8708]
0094228B call 0x818450
00942290 mov dword ptr [ebp - 4], eax
00942293 cmp dword ptr [ebp - 4], 0
00942297 jne 0x9422b1
00942299 push 0xbad304
0094229E push 0
009422A0 mov edx, dword ptr [ebp + 8]
009422A3 push edx
009422A4 call 0x639f10
009422A9 add esp, 0xc
009422AC jmp 0x94233c
009422B1 mov ecx, dword ptr [ebp - 4]
009422B4 call 0x401000
009422B9 mov dword ptr [ebp - 0x50], eax
009422BC mov dword ptr [ebp - 0x4c], edx
009422BF mov eax, dword ptr [ebp - 0xc]
009422C2 mov dword ptr [ebp - 0x64], eax
009422C5 mov ecx, dword ptr [ebp - 8]
009422C8 mov dword ptr [ebp - 0x60], ecx
009422CB mov edx, dword ptr [ebp - 0x60]
009422CE push edx
009422CF mov eax, dword ptr [ebp - 0x64]
009422D2 push eax
009422D3 lea ecx, [ebp - 0x6c]
009422D6 push ecx
009422D7 mov ecx, dword ptr [ebp - 0x70]
009422DA add ecx, 0x3c
009422DD call 0x4b7a00
009422E2 lea edx, [ebp - 0x50]
009422E5 push edx
009422E6 mov ecx, dword ptr [ebp - 0x70]
009422E9 add ecx, 0x5c
009422EC call 0x4d4780
009422F1 mov eax, dword ptr [ebp - 0x4c]
009422F4 push eax
009422F5 mov ecx, dword ptr [ebp - 0x50]
009422F8 push ecx
009422F9 mov edx, dword ptr [ebp - 0x70]
009422FC mov eax, dword ptr [edx]
009422FE mov ecx, dword ptr [ebp - 0x70]
00942301 mov edx, dword ptr [eax + 0x10c]
00942307 call edx
00942309 mov eax, dword ptr [ebp - 0x50]
0094230C mov dword ptr [ebp - 0x15], eax
0094230F mov ecx, dword ptr [ebp - 0x4c]
00942312 mov dword ptr [ebp - 0x11], ecx
00942315 push 0
00942317 push 0
00942319 push 0x2f
0094231B lea edx, [ebp - 0x3c]
0094231E push edx
0094231F push 0x4fb1
00942324 call 0xa3fbb0
00942329 add esp, 0x14
0094232C push 0
0094232E push 1
00942330 mov eax, dword ptr [ebp + 8]
00942333 push eax
00942334 call 0x639f10
00942339 add esp, 0xc
0094233C mov esp, ebp
0094233E pop ebp
; range 0xa62ae0
00A62AE0 push ebp
00A62AE1 mov ebp, esp
00A62AE3 sub esp, 8
00A62AE6 mov dword ptr [ebp - 8], ecx
00A62AE9 mov dword ptr [ebp - 4], 0
00A62AF0 jmp 0xa62afb
00A62AF2 mov eax, dword ptr [ebp - 4]
00A62AF5 add eax, 1
00A62AF8 mov dword ptr [ebp - 4], eax
00A62AFB mov ecx, dword ptr [ebp - 8]
00A62AFE add ecx, 0x40
00A62B01 call 0x432c10
00A62B06 cmp dword ptr [ebp - 4], eax
00A62B09 jae 0xa62b35
00A62B0B mov ecx, dword ptr [ebp + 8]
00A62B0E push ecx
00A62B0F mov edx, dword ptr [ebp - 4]
00A62B12 push edx
00A62B13 mov ecx, dword ptr [ebp - 8]
00A62B16 add ecx, 0x40
00A62B19 call 0x4eae70
00A62B1E push eax
00A62B1F call 0x4221c0
00A62B24 add esp, 8
00A62B27 movzx eax, al
00A62B2A test eax, eax
00A62B2C je 0xa62b33
00A62B2E mov eax, dword ptr [ebp - 4]
00A62B31 jmp 0xa62b38
00A62B33 jmp 0xa62af2
00A62B35 or eax, 0xffffffff
00A62B38 mov esp, ebp
00A62B3A pop ebp
00A62B3B ret 4
; range 0xa62b40
00A62B40 push ebp
00A62B41 mov ebp, esp
00A62B43 sub esp, 0x14
00A62B46 mov dword ptr [ebp - 0x14], ecx
00A62B49 mov eax, dword ptr [ebp + 8]
00A62B4C push eax
00A62B4D mov ecx, dword ptr [ebp - 0x14]
00A62B50 add ecx, 0x40
00A62B53 call 0x4eae70
00A62B58 push eax
00A62B59 lea ecx, [ebp - 8]
00A62B5C push ecx
00A62B5D mov ecx, dword ptr [ebp - 0x14]
00A62B60 add ecx, 0x20
00A62B63 call 0x55e660
00A62B68 lea edx, [ebp - 0x10]
00A62B6B push edx
00A62B6C mov ecx, dword ptr [ebp - 0x14]
00A62B6F add ecx, 0x20
00A62B72 call 0x45abb0
00A62B77 push eax
00A62B78 lea ecx, [ebp - 8]
00A62B7B call 0x4ab8f0
00A62B80 movzx eax, al
00A62B83 test eax, eax
00A62B85 je 0xa62b94
00A62B87 lea ecx, [ebp - 8]
00A62B8A call 0x4305b0
00A62B8F mov eax, dword ptr [eax + 0x1c]
00A62B92 jmp 0xa62b96
00A62B94 xor eax, eax
00A62B96 mov esp, ebp
00A62B98 pop ebp
00A62B99 ret 4
; range 0xa633af
00A633AF call 0x55e560
00A633B4 mov ecx, dword ptr [ebp - 0x1c]
00A633B7 mov dword ptr [eax], ecx
00A633B9 mov edx, dword ptr [ebp - 0x14]
00A633BC push edx
00A633BD mov ecx, dword ptr [ebp - 0x54]
00A633C0 add ecx, 0x40
00A633C3 call 0x49d150
00A633C8 push -2
00A633CA mov eax, dword ptr [ebp + 8]
00A633CD push eax
00A633CE call 0x68bbb0
00A633D3 add esp, 8
00A633D6 jmp 0xa62dd8
00A633DB lea ecx, [ebp - 0x48]
00A633DE push ecx
00A633DF mov ecx, dword ptr [ebp - 0x54]
00A633E2 add ecx, 0x40
00A633E5 call 0x4f2590
00A633EA mov edx, dword ptr [eax + 4]
00A633ED push edx
00A633EE mov eax, dword ptr [eax]
00A633F0 push eax
00A633F1 lea ecx, [ebp - 0x50]
00A633F4 push ecx
00A633F5 mov ecx, dword ptr [ebp - 0x54]
00A633F8 add ecx, 0x40
00A633FB call 0x4d6050
00A63400 mov edx, dword ptr [eax + 4]
00A63403 push edx
00A63404 mov eax, dword ptr [eax]
00A63406 push eax
00A63407 call 0x4d8b50
00A6340C add esp, 0x10
00A6340F mov al, 1
; first definition field becomes the vector name (Lua rawgeti index 1)
00A62E60 loopne 0xa62ded
00A62E62 inc ebp
00A62E63 loopne 0xa62eb5
00A62E65 push -1
00A62E67 mov ecx, dword ptr [ebp + 8]
00A62E6A push ecx
00A62E6B call 0x68cc10
00A62E70 add esp, 0xc
00A62E73 push 0
00A62E75 push -1
00A62E77 mov edx, dword ptr [ebp + 8]
00A62E7A push edx
00A62E7B call 0x68c430
00A62E80 add esp, 0xc
00A62E83 push eax
00A62E84 mov ecx, dword ptr [ebp - 0x14]
00A62E87 call 0x405710
00A62E8C push -2
00A62E8E mov eax, dword ptr [ebp + 8]
00A62E91 push eax
00A62E92 call 0x68bbb0
