; Read-only gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Lua bindings: B9A378 create_monster -> 93DDE0; B9A380 destroy_monster -> 93DD70; B9A3C0 get_alive_monster_count -> 93D7D0
; function 0x93dde0
0093DDE0 push ebp
0093DDE1 mov ebp, esp
0093DDE3 push ecx
0093DDE4 mov ecx, dword ptr [0x17c8710]
0093DDEA call 0x453db0
0093DDEF test eax, eax
0093DDF1 jne 0x93ddf7
0093DDF3 xor eax, eax
0093DDF5 jmp 0x93de46
0093DDF7 mov ecx, dword ptr [0x17c8708]
0093DDFD call 0x4535c0
0093DE02 cmp eax, 0x15
0093DE05 je 0x93de0b
0093DE07 xor eax, eax
0093DE09 jmp 0x93de46
0093DE0B push 0
0093DE0D push 0x12f90d0
0093DE12 push 0x12f899c
0093DE17 mov ecx, dword ptr [0x17c8710]
0093DE1D call 0x453db0
0093DE22 push 0
0093DE24 push eax
0093DE25 call 0xa97b0e
0093DE2A add esp, 0x14
0093DE2D mov dword ptr [ebp - 4], eax
0093DE30 cmp dword ptr [ebp - 4], 0
0093DE34 jne 0x93de3a
0093DE36 xor eax, eax
0093DE38 jmp 0x93de46
0093DE3A mov eax, dword ptr [ebp + 8]
0093DE3D push eax
0093DE3E mov ecx, dword ptr [ebp - 4]
0093DE41 call 0x93c340
0093DE46 mov esp, ebp
0093DE48 pop ebp
0093DE49 ret
; function 0x93dd70
0093DD70 push ebp
0093DD71 mov ebp, esp
0093DD73 push ecx
0093DD74 mov ecx, dword ptr [0x17c8710]
0093DD7A call 0x453db0
0093DD7F test eax, eax
0093DD81 jne 0x93dd87
0093DD83 xor eax, eax
0093DD85 jmp 0x93ddd6
0093DD87 mov ecx, dword ptr [0x17c8708]
0093DD8D call 0x4535c0
0093DD92 cmp eax, 0x15
0093DD95 je 0x93dd9b
0093DD97 xor eax, eax
0093DD99 jmp 0x93ddd6
0093DD9B push 0
0093DD9D push 0x12f90d0
0093DDA2 push 0x12f899c
0093DDA7 mov ecx, dword ptr [0x17c8710]
0093DDAD call 0x453db0
0093DDB2 push 0
0093DDB4 push eax
0093DDB5 call 0xa97b0e
0093DDBA add esp, 0x14
0093DDBD mov dword ptr [ebp - 4], eax
0093DDC0 cmp dword ptr [ebp - 4], 0
0093DDC4 jne 0x93ddca
0093DDC6 xor eax, eax
0093DDC8 jmp 0x93ddd6
0093DDCA mov eax, dword ptr [ebp + 8]
0093DDCD push eax
0093DDCE mov ecx, dword ptr [ebp - 4]
0093DDD1 call 0x93c1c0
0093DDD6 mov esp, ebp
0093DDD8 pop ebp
0093DDD9 ret
; function 0x93d7d0
0093D7D0 push ebp
0093D7D1 mov ebp, esp
0093D7D3 sub esp, 8
0093D7D6 mov ecx, dword ptr [0x17c8710]
0093D7DC call 0x453db0
0093D7E1 test eax, eax
0093D7E3 jne 0x93d7e9
0093D7E5 xor eax, eax
0093D7E7 jmp 0x93d851
0093D7E9 mov ecx, dword ptr [0x17c8708]
0093D7EF call 0x4535c0
0093D7F4 cmp eax, 0x15
0093D7F7 je 0x93d7fd
0093D7F9 xor eax, eax
0093D7FB jmp 0x93d851
0093D7FD push 0
0093D7FF push 0x12f90d0
0093D804 push 0x12f899c
0093D809 mov ecx, dword ptr [0x17c8710]
0093D80F call 0x453db0
0093D814 push 0
0093D816 push eax
0093D817 call 0xa97b0e
0093D81C add esp, 0x14
0093D81F mov dword ptr [ebp - 8], eax
0093D822 cmp dword ptr [ebp - 8], 0
0093D826 jne 0x93d82c
0093D828 xor eax, eax
0093D82A jmp 0x93d851
0093D82C mov ecx, dword ptr [ebp - 8]
0093D82F call 0x938ba0
0093D834 mov dword ptr [ebp - 4], eax
0093D837 fild dword ptr [ebp - 4]
0093D83A sub esp, 8
0093D83D fstp qword ptr [esp]
0093D840 mov eax, dword ptr [ebp + 8]
0093D843 push eax
0093D844 call 0x68c720
0093D849 add esp, 0xc
0093D84C mov eax, 1
0093D851 mov esp, ebp
0093D853 pop ebp
0093D854 ret
; function 0x938ba0
00938BA0 push ebp
00938BA1 mov ebp, esp
00938BA3 push ecx
00938BA4 mov dword ptr [ebp - 4], ecx
00938BA7 mov ecx, dword ptr [ebp - 4]
00938BAA add ecx, 0x40
00938BAD call 0x4c4cb0
00938BB2 mov esp, ebp
00938BB4 pop ebp
00938BB5 ret
; function 0x93c340
0093C340 push ebp
0093C341 mov ebp, esp
0093C343 push -1
0093C345 push 0xadbc98
0093C34A mov eax, dword ptr fs:[0]
0093C350 push eax
0093C351 sub esp, 0xb0
0093C357 mov eax, dword ptr [0xc7b480]
0093C35C xor eax, ebp
0093C35E push eax
0093C35F lea eax, [ebp - 0xc]
0093C362 mov dword ptr fs:[0], eax
0093C368 mov dword ptr [ebp - 0xb0], ecx
0093C36E mov eax, dword ptr [ebp + 8]
0093C371 push eax
0093C372 call 0x68bb90
0093C377 add esp, 4
0093C37A cmp eax, 5
0093C37D jl 0x93c3d9
0093C37F push 1
0093C381 mov ecx, dword ptr [ebp + 8]
0093C384 push ecx
0093C385 call 0x68c0c0
0093C38A add esp, 8
0093C38D test eax, eax
0093C38F je 0x93c3d9
0093C391 push 2
0093C393 mov edx, dword ptr [ebp + 8]
0093C396 push edx
0093C397 call 0x68c0c0
0093C39C add esp, 8
0093C39F test eax, eax
0093C3A1 je 0x93c3d9
0093C3A3 push 3
0093C3A5 mov eax, dword ptr [ebp + 8]
0093C3A8 push eax
0093C3A9 call 0x68c0c0
0093C3AE add esp, 8
0093C3B1 test eax, eax
0093C3B3 je 0x93c3d9
0093C3B5 push 4
0093C3B7 mov ecx, dword ptr [ebp + 8]
0093C3BA push ecx
0093C3BB call 0x68c0c0
0093C3C0 add esp, 8
0093C3C3 test eax, eax
0093C3C5 je 0x93c3d9
0093C3C7 push 5
0093C3C9 mov edx, dword ptr [ebp + 8]
0093C3CC push edx
0093C3CD call 0x68c120
0093C3D2 add esp, 8
0093C3D5 test eax, eax
0093C3D7 jne 0x93c3f1
0093C3D9 push 0xbad20c
0093C3DE push 0
0093C3E0 mov eax, dword ptr [ebp + 8]
0093C3E3 push eax
0093C3E4 call 0x639f10
0093C3E9 add esp, 0xc
0093C3EC jmp 0x93c77d
0093C3F1 push 0
0093C3F3 push 5
0093C3F5 mov ecx, dword ptr [ebp + 8]
0093C3F8 push ecx
0093C3F9 call 0x68c430
0093C3FE add esp, 0xc
0093C401 push eax
0093C402 lea ecx, [ebp - 0xa8]
0093C408 call 0x405650
0093C40D mov dword ptr [ebp - 0xb4], eax
0093C413 mov edx, dword ptr [ebp - 0xb4]
0093C419 mov dword ptr [ebp - 0xb8], edx
0093C41F mov dword ptr [ebp - 4], 0
0093C426 mov eax, dword ptr [ebp - 0xb8]
0093C42C push eax
0093C42D mov ecx, dword ptr [ebp - 0xb0]
0093C433 call 0x938e10
0093C438 mov dword ptr [ebp - 0x7c], eax
0093C43B mov dword ptr [ebp - 4], 0xffffffff
0093C442 lea ecx, [ebp - 0xa8]
0093C448 call 0x4056d0
0093C44D cmp dword ptr [ebp - 0x7c], 0
0093C451 jge 0x93c46b
0093C453 push 0xbad22c
0093C458 push 0
0093C45A mov ecx, dword ptr [ebp + 8]
0093C45D push ecx
0093C45E call 0x639f10
0093C463 add esp, 0xc
0093C466 jmp 0x93c77d
0093C46B push 1
0093C46D mov edx, dword ptr [ebp + 8]
0093C470 push edx
0093C471 call 0x68c320
0093C476 add esp, 8
0093C479 fstp dword ptr [ebp - 0x28]
0093C47C push 2
0093C47E mov eax, dword ptr [ebp + 8]
0093C481 push eax
0093C482 call 0x68c320
0093C487 add esp, 8
0093C48A fstp dword ptr [ebp - 0x24]
0093C48D push 3
0093C48F mov ecx, dword ptr [ebp + 8]
0093C492 push ecx
0093C493 call 0x68c320
0093C498 add esp, 8
0093C49B fstp dword ptr [ebp - 0x20]
0093C49E push 4
0093C4A0 mov edx, dword ptr [ebp + 8]
0093C4A3 push edx
0093C4A4 call 0x68c320
0093C4A9 add esp, 8
0093C4AC call 0x66e430
0093C4B1 mov dword ptr [ebp - 0x78], eax
0093C4B4 mov ecx, dword ptr [ebp - 0xb0]
0093C4BA add ecx, 0x60
0093C4BD call 0x4c4cb0
0093C4C2 test eax, eax
0093C4C4 jne 0x93c4de
0093C4C6 push 0xbad258
0093C4CB push 0
0093C4CD mov eax, dword ptr [ebp + 8]
0093C4D0 push eax
0093C4D1 call 0x639f10
0093C4D6 add esp, 0xc
0093C4D9 jmp 0x93c77d
0093C4DE mov ecx, dword ptr [ebp - 0xb0]
0093C4E4 add ecx, 0x60
0093C4E7 call 0x4d4660
0093C4EC mov ecx, dword ptr [eax]
0093C4EE mov dword ptr [ebp - 0x84], ecx
0093C4F4 mov edx, dword ptr [eax + 4]
0093C4F7 mov dword ptr [ebp - 0x80], edx
0093C4FA mov eax, dword ptr [ebp - 0x7c]
0093C4FD push eax
0093C4FE mov ecx, dword ptr [ebp - 0xb0]
0093C504 call 0x938e80
0093C509 mov dword ptr [ebp - 0x8c], eax
0093C50F cmp dword ptr [ebp - 0x8c], 0
0093C516 jne 0x93c530
0093C518 push 0xbad27c
0093C51D push 0
0093C51F mov ecx, dword ptr [ebp + 8]
0093C522 push ecx
0093C523 call 0x639f10
0093C528 add esp, 0xc
0093C52B jmp 0x93c77d
0093C530 mov edx, dword ptr [ebp - 0x7c]
0093C533 push edx
0093C534 mov ecx, dword ptr [ebp - 0xb0]
0093C53A call 0x938f70
0093C53F movzx eax, al
0093C542 test eax, eax
0093C544 jne 0x93c55e
0093C546 push 0xbad258
0093C54B push 0
0093C54D mov ecx, dword ptr [ebp + 8]
0093C550 push ecx
0093C551 call 0x639f10
0093C556 add esp, 0xc
0093C559 jmp 0x93c77d
0093C55E mov edx, dword ptr [ebp - 0x84]
0093C564 mov dword ptr [ebp - 0x4d], edx
0093C567 mov eax, dword ptr [ebp - 0x80]
0093C56A mov dword ptr [ebp - 0x49], eax
0093C56D mov ecx, dword ptr [ebp - 0x7c]
0093C570 mov dword ptr [ebp - 0x45], ecx
0093C573 mov edx, dword ptr [ebp - 0x28]
0093C576 mov dword ptr [ebp - 0x41], edx
0093C579 mov eax, dword ptr [ebp - 0x24]
0093C57C mov dword ptr [ebp - 0x3d], eax
0093C57F mov ecx, dword ptr [ebp - 0x20]
0093C582 mov dword ptr [ebp - 0x39], ecx
0093C585 mov edx, dword ptr [ebp - 0x78]
0093C588 mov dword ptr [ebp - 0x35], edx
0093C58B push 0
0093C58D push 0
0093C58F push 0x43
0093C591 lea eax, [ebp - 0x74]
0093C594 push eax
0093C595 push 0x4fb0
0093C59A call 0xa3fbb0
0093C59F add esp, 0x14
0093C5A2 mov ecx, dword ptr [ebp - 0xb0]
0093C5A8 mov edx, dword ptr [ecx + 0x80]
0093C5AE add edx, 1
0093C5B1 mov eax, dword ptr [ebp - 0xb0]
0093C5B7 mov dword ptr [eax + 0x80], edx
0093C5BD mov ecx, dword ptr [ebp - 0xb0]
0093C5C3 mov edx, dword ptr [ecx + 0x80]
0093C5C9 push edx
0093C5CA mov eax, dword ptr [ebp - 0x78]
0093C5CD push eax
0093C5CE lea ecx, [ebp - 0x28]
0093C5D1 push ecx
0093C5D2 mov edx, dword ptr [ebp - 0x7c]
0093C5D5 push edx
0093C5D6 mov eax, dword ptr [ebp - 0x80]
0093C5D9 push eax
0093C5DA mov ecx, dword ptr [ebp - 0x84]
0093C5E0 push ecx
0093C5E1 mov edx, dword ptr [ebp - 0xb0]
0093C5E7 mov eax, dword ptr [edx]
0093C5E9 mov ecx, dword ptr [ebp - 0xb0]
0093C5EF mov edx, dword ptr [eax + 0x108]
0093C5F5 call edx
0093C5F7 movzx eax, al
0093C5FA test eax, eax
0093C5FC jne 0x93c631
0093C5FE mov ecx, dword ptr [ebp - 0xb0]
0093C604 mov edx, dword ptr [ecx + 0x80]
0093C60A sub edx, 1
0093C60D mov eax, dword ptr [ebp - 0xb0]
0093C613 mov dword ptr [eax + 0x80], edx
0093C619 push 0xbad2a0
0093C61E push 0
0093C620 mov ecx, dword ptr [ebp + 8]
0093C623 push ecx
0093C624 call 0x639f10
0093C629 add esp, 0xc
0093C62C jmp 0x93c77d
0093C631 mov ecx, dword ptr [ebp - 0xb0]
0093C637 add ecx, 0x60
0093C63A call 0x4d4860
0093C63F mov edx, dword ptr [ebp - 0x80]
0093C642 push edx
0093C643 mov eax, dword ptr [ebp - 0x84]
0093C649 push eax
0093C64A mov ecx, dword ptr [0x17c8708]
0093C650 call 0x818c00
0093C655 mov dword ptr [ebp - 0x88], eax
0093C65B cmp dword ptr [ebp - 0x88], -1
0093C662 je 0x93c672
0093C664 mov ecx, dword ptr [ebp - 0x88]
0093C66A mov dword ptr [ebp - 0xbc], ecx
0093C670 jmp 0x93c67c
0093C672 mov dword ptr [ebp - 0xbc], 0xfffffffe
0093C67C mov edx, dword ptr [ebp - 0x84]
0093C682 push edx
0093C683 mov eax, dword ptr [ebp - 0x8c]
0093C689 push eax
0093C68A push 0
0093C68C mov ecx, dword ptr [ebp - 0xbc]
0093C692 push ecx
0093C693 lea ecx, [ebp - 0x1c]
0093C696 call 0x4d6ee0
0093C69B mov edx, dword ptr [ebp - 0x84]
0093C6A1 mov dword ptr [ebp - 0xac], edx
0093C6A7 lea eax, [ebp - 0xac]
0093C6AD push eax
0093C6AE mov ecx, dword ptr [ebp - 0xb0]
0093C6B4 add ecx, 0x40
0093C6B7 call 0x4d7060
0093C6BC mov ecx, dword ptr [ebp - 0x1c]
0093C6BF mov dword ptr [eax], ecx
0093C6C1 mov edx, dword ptr [ebp - 0x18]
0093C6C4 mov dword ptr [eax + 4], edx
0093C6C7 mov ecx, dword ptr [ebp - 0x14]
0093C6CA mov dword ptr [eax + 8], ecx
0093C6CD mov edx, dword ptr [ebp - 0x10]
0093C6D0 mov dword ptr [eax + 0xc], edx
0093C6D3 lea eax, [ebp - 0x84]
0093C6D9 push eax
0093C6DA mov ecx, dword ptr [ebp - 0xb0]
0093C6E0 add ecx, 0xb8
0093C6E6 call 0x4d7230
0093C6EB mov dword ptr [eax], 0
0093C6F1 mov ecx, dword ptr [ebp + 8]
0093C6F4 push ecx
0093C6F5 call 0x68bb90
0093C6FA add esp, 4
0093C6FD neg eax
0093C6FF sub eax, 1
0093C702 push eax
0093C703 mov edx, dword ptr [ebp + 8]
0093C706 push edx
0093C707 call 0x68bbb0
0093C70C add esp, 8
0093C70F push 1
0093C711 mov eax, dword ptr [ebp + 8]
0093C714 push eax
0093C715 call 0x68b9a0
0093C71A add esp, 8
0093C71D test eax, eax
0093C71F jne 0x93c736
0093C721 push 0xbad2c4
0093C726 push 0
0093C728 mov ecx, dword ptr [ebp + 8]
0093C72B push ecx
0093C72C call 0x639f10
0093C731 add esp, 0xc
0093C734 jmp 0x93c77d
0093C736 fild qword ptr [ebp - 0x84]
0093C73C sub esp, 8
0093C73F fstp qword ptr [esp]
0093C742 mov edx, dword ptr [ebp + 8]
0093C745 push edx
0093C746 call 0x68c720
0093C74B add esp, 0xc
0093C74E mov eax, dword ptr [ebp - 0xb0]
0093C754 mov eax, dword ptr [eax + 0x80]
0093C75A cdq
0093C75B push edx
0093C75C push eax
0093C75D call 0x9e3b20
0093C762 fstp qword ptr [esp]
0093C765 mov ecx, dword ptr [ebp + 8]
0093C768 push ecx
0093C769 call 0x68c720
0093C76E add esp, 0xc
0093C771 mov edx, dword ptr [ebp + 8]
0093C774 push edx
0093C775 call 0x68bb90
0093C77A add esp, 4
0093C77D mov ecx, dword ptr [ebp - 0xc]
0093C780 mov dword ptr fs:[0], ecx
0093C787 pop ecx
0093C788 mov esp, ebp
0093C78A pop ebp
0093C78B ret 4
; function 0x93c1c0
0093C1C0 push ebp
0093C1C1 mov ebp, esp
0093C1C3 sub esp, 0x70
0093C1C6 mov dword ptr [ebp - 0x70], ecx
0093C1C9 mov eax, dword ptr [ebp + 8]
0093C1CC push eax
0093C1CD call 0x68bb90
0093C1D2 add esp, 4
0093C1D5 cmp eax, 1
0093C1D8 jne 0x93c1ec
0093C1DA push 1
0093C1DC mov ecx, dword ptr [ebp + 8]
0093C1DF push ecx
0093C1E0 call 0x68c0c0
0093C1E5 add esp, 8
0093C1E8 test eax, eax
0093C1EA jne 0x93c204
0093C1EC push 0xbad2e4
0093C1F1 push 0
0093C1F3 mov edx, dword ptr [ebp + 8]
0093C1F6 push edx
0093C1F7 call 0x639f10
0093C1FC add esp, 0xc
0093C1FF jmp 0x93c32c
0093C204 push 1
0093C206 mov eax, dword ptr [ebp + 8]
0093C209 push eax
0093C20A call 0x68c370
0093C20F add esp, 8
0093C212 cdq
0093C213 mov dword ptr [ebp - 0x48], eax
0093C216 mov dword ptr [ebp - 0x44], edx
0093C219 mov ecx, dword ptr [ebp - 0x48]
0093C21C mov dword ptr [ebp - 0x54], ecx
0093C21F lea edx, [ebp - 0x54]
0093C222 push edx
0093C223 lea eax, [ebp - 0xc]
0093C226 push eax
0093C227 mov ecx, dword ptr [ebp - 0x70]
0093C22A add ecx, 0x40
0093C22D call 0x4d7190
0093C232 lea ecx, [ebp - 0x5c]
0093C235 push ecx
0093C236 mov ecx, dword ptr [ebp - 0x70]
0093C239 add ecx, 0x40
0093C23C call 0x45abb0
0093C241 push eax
0093C242 lea ecx, [ebp - 0xc]
0093C245 call 0x4ab920
0093C24A movzx edx, al
0093C24D test edx, edx
0093C24F je 0x93c269
0093C251 push 0xbad304
0093C256 push 0
0093C258 mov eax, dword ptr [ebp + 8]
0093C25B push eax
0093C25C call 0x639f10
0093C261 add esp, 0xc
0093C264 jmp 0x93c32c
0093C269 lea ecx, [ebp - 0xc]
0093C26C call 0x4305b0
0093C271 mov ecx, dword ptr [eax + 4]
0093C274 push ecx
0093C275 mov ecx, dword ptr [0x17c8708]
0093C27B call 0x818450
0093C280 mov dword ptr [ebp - 4], eax
0093C283 cmp dword ptr [ebp - 4], 0
0093C287 jne 0x93c2a1
0093C289 push 0xbad304
0093C28E push 0
0093C290 mov edx, dword ptr [ebp + 8]
0093C293 push edx
0093C294 call 0x639f10
0093C299 add esp, 0xc
0093C29C jmp 0x93c32c
0093C2A1 mov ecx, dword ptr [ebp - 4]
0093C2A4 call 0x401000
0093C2A9 mov dword ptr [ebp - 0x50], eax
0093C2AC mov dword ptr [ebp - 0x4c], edx
0093C2AF mov eax, dword ptr [ebp - 0xc]
0093C2B2 mov dword ptr [ebp - 0x64], eax
0093C2B5 mov ecx, dword ptr [ebp - 8]
0093C2B8 mov dword ptr [ebp - 0x60], ecx
0093C2BB mov edx, dword ptr [ebp - 0x60]
0093C2BE push edx
0093C2BF mov eax, dword ptr [ebp - 0x64]
0093C2C2 push eax
0093C2C3 lea ecx, [ebp - 0x6c]
0093C2C6 push ecx
0093C2C7 mov ecx, dword ptr [ebp - 0x70]
0093C2CA add ecx, 0x40
0093C2CD call 0x48d2a0
0093C2D2 lea edx, [ebp - 0x50]
0093C2D5 push edx
0093C2D6 mov ecx, dword ptr [ebp - 0x70]
0093C2D9 add ecx, 0x60
0093C2DC call 0x4d4780
0093C2E1 mov eax, dword ptr [ebp - 0x4c]
0093C2E4 push eax
0093C2E5 mov ecx, dword ptr [ebp - 0x50]
0093C2E8 push ecx
0093C2E9 mov edx, dword ptr [ebp - 0x70]
0093C2EC mov eax, dword ptr [edx]
0093C2EE mov ecx, dword ptr [ebp - 0x70]
0093C2F1 mov edx, dword ptr [eax + 0x10c]
0093C2F7 call edx
0093C2F9 mov eax, dword ptr [ebp - 0x50]
0093C2FC mov dword ptr [ebp - 0x15], eax
0093C2FF mov ecx, dword ptr [ebp - 0x4c]
0093C302 mov dword ptr [ebp - 0x11], ecx
0093C305 push 0
0093C307 push 0
0093C309 push 0x2f
0093C30B lea edx, [ebp - 0x3c]
0093C30E push edx
0093C30F push 0x4fb1
0093C314 call 0xa3fbb0
0093C319 add esp, 0x14
0093C31C push 0
0093C31E push 1
0093C320 mov eax, dword ptr [ebp + 8]
0093C323 push eax
0093C324 call 0x639f10
0093C329 add esp, 0xc
0093C32C mov esp, ebp
0093C32E pop ebp
0093C32F ret 4
; function 0x827ad0
00827AD0 push ebp
00827AD1 mov ebp, esp
00827AD3 sub esp, 0xc
00827AD6 mov dword ptr [ebp - 0xc], ecx
00827AD9 cmp dword ptr [ebp + 8], 0
00827ADD je 0x827ae5
00827ADF cmp dword ptr [ebp + 0xc], 0x43
00827AE3 je 0x827ae7
00827AE5 jmp 0x827b4a
00827AE7 mov eax, dword ptr [ebp + 8]
00827AEA mov dword ptr [ebp - 8], eax
00827AED push 0
00827AEF push 0x12f8fe8
00827AF4 push 0x12f899c
00827AF9 mov ecx, dword ptr [0x17c8710]
00827AFF call 0x453db0
00827B04 push 0
00827B06 push eax
00827B07 call 0xa97b0e
00827B0C add esp, 0x14
00827B0F mov dword ptr [ebp - 4], eax
00827B12 cmp dword ptr [ebp - 4], 0
00827B16 je 0x827b4a
00827B18 push 0
00827B1A mov ecx, dword ptr [ebp - 8]
00827B1D mov edx, dword ptr [ecx + 0x3f]
00827B20 push edx
00827B21 mov eax, dword ptr [ebp - 8]
00827B24 add eax, 0x33
00827B27 push eax
00827B28 mov ecx, dword ptr [ebp - 8]
00827B2B mov edx, dword ptr [ecx + 0x2f]
00827B2E push edx
00827B2F mov eax, dword ptr [ebp - 8]
00827B32 mov ecx, dword ptr [eax + 0x2b]
00827B35 push ecx
00827B36 mov edx, dword ptr [eax + 0x27]
00827B39 push edx
00827B3A mov eax, dword ptr [ebp - 4]
00827B3D mov edx, dword ptr [eax]
00827B3F mov ecx, dword ptr [ebp - 4]
00827B42 mov eax, dword ptr [edx + 0x108]
00827B48 call eax
00827B4A mov esp, ebp
00827B4C pop ebp
00827B4D ret 8
; function 0x827a60
00827A60 push ebp
00827A61 mov ebp, esp
00827A63 sub esp, 0xc
00827A66 mov dword ptr [ebp - 0xc], ecx
00827A69 cmp dword ptr [ebp + 8], 0
00827A6D je 0x827a75
00827A6F cmp dword ptr [ebp + 0xc], 0x2f
00827A73 je 0x827a77
00827A75 jmp 0x827ac3
00827A77 mov eax, dword ptr [ebp + 8]
00827A7A mov dword ptr [ebp - 8], eax
00827A7D push 0
00827A7F push 0x12f8fe8
00827A84 push 0x12f899c
00827A89 mov ecx, dword ptr [0x17c8710]
00827A8F call 0x453db0
00827A94 push 0
00827A96 push eax
00827A97 call 0xa97b0e
00827A9C add esp, 0x14
00827A9F mov dword ptr [ebp - 4], eax
00827AA2 cmp dword ptr [ebp - 4], 0
00827AA6 je 0x827ac3
00827AA8 mov ecx, dword ptr [ebp - 8]
00827AAB mov edx, dword ptr [ecx + 0x2b]
00827AAE push edx
00827AAF mov eax, dword ptr [ecx + 0x27]
00827AB2 push eax
00827AB3 mov ecx, dword ptr [ebp - 4]
00827AB6 mov edx, dword ptr [ecx]
00827AB8 mov ecx, dword ptr [ebp - 4]
00827ABB mov eax, dword ptr [edx + 0x10c]
00827AC1 call eax
00827AC3 mov esp, ebp
00827AC5 pop ebp
00827AC6 ret 8
; dispatch 20400 -> 82D5A4 -> 827AD0; table 82D8FC[0] for 20401 -> 82D5B9 -> 827A60
