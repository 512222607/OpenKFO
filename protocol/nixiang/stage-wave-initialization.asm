; Read-only gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; function 0x93b6b0
0093B6B0 push ebp
0093B6B1 mov ebp, esp
0093B6B3 push ecx
0093B6B4 mov dword ptr [ebp - 4], ecx
0093B6B7 mov eax, dword ptr [ebp - 4]
0093B6BA mov ecx, dword ptr [eax + 4]
0093B6BD mov edx, dword ptr [ebp - 4]
0093B6C0 mov eax, dword ptr [edx + 4]
0093B6C3 mov edx, dword ptr [ecx]
0093B6C5 mov ecx, eax
0093B6C7 mov eax, dword ptr [edx + 0x1c4]
0093B6CD call eax
0093B6CF call 0x94bf10
0093B6D4 mov ecx, eax
0093B6D6 call 0x94ce30
0093B6DB call 0x94bf10
0093B6E0 mov ecx, eax
0093B6E2 call 0x94cc70
0093B6E7 call 0x94bf10
0093B6EC mov ecx, eax
0093B6EE call 0x94bd90
0093B6F3 push 1
0093B6F5 mov ecx, dword ptr [ebp - 4]
0093B6F8 call 0x93a530
0093B6FD mov esp, ebp
0093B6FF pop ebp
0093B700 ret
; function 0x93a530
0093A530 push ebp
0093A531 mov ebp, esp
0093A533 push -1
0093A535 push 0xab0446
0093A53A mov eax, dword ptr fs:[0]
0093A540 push eax
0093A541 sub esp, 0x17c
0093A547 mov eax, dword ptr [0xc7b480]
0093A54C xor eax, ebp
0093A54E mov dword ptr [ebp - 0x14], eax
0093A551 push eax
0093A552 lea eax, [ebp - 0xc]
0093A555 mov dword ptr fs:[0], eax
0093A55B mov dword ptr [ebp - 0x180], ecx
0093A561 mov ecx, dword ptr [0x17c8708]
0093A567 call 0x819120
0093A56C test eax, eax
0093A56E je 0x93a627
0093A574 mov ecx, dword ptr [0x17c8708]
0093A57A call 0x819120
0093A57F mov ecx, eax
0093A581 call 0x44b3f0
0093A586 test eax, eax
0093A588 je 0x93a627
0093A58E mov eax, dword ptr [ebp - 0x180]
0093A594 cmp dword ptr [eax + 0x14], 0
0093A598 je 0x93a627
0093A59E lea ecx, [ebp - 0x12c]
0093A5A4 call 0x5734a0
0093A5A9 mov dword ptr [ebp - 4], 0
0093A5B0 fild dword ptr [ebp + 8]
0093A5B3 push ecx
0093A5B4 fstp dword ptr [esp]
0093A5B7 lea ecx, [ebp - 0x15c]
0093A5BD call 0x63a850
0093A5C2 mov dword ptr [ebp - 0x184], eax
0093A5C8 mov ecx, dword ptr [ebp - 0x184]
0093A5CE mov dword ptr [ebp - 0x188], ecx
0093A5D4 mov byte ptr [ebp - 4], 1
0093A5D8 mov edx, dword ptr [ebp - 0x188]
0093A5DE push edx
0093A5DF lea ecx, [ebp - 0x12c]
0093A5E5 call 0x44e540
0093A5EA mov byte ptr [ebp - 4], 0
0093A5EE lea ecx, [ebp - 0x15c]
0093A5F4 call 0x63a9a0
0093A5F9 push 0
0093A5FB lea eax, [ebp - 0x12c]
0093A601 push eax
0093A602 push 0xbadd04
0093A607 mov ecx, dword ptr [ebp - 0x180]
0093A60D mov ecx, dword ptr [ecx + 0x14]
0093A610 call 0x6399b0
0093A615 mov dword ptr [ebp - 4], 0xffffffff
0093A61C lea ecx, [ebp - 0x12c]
0093A622 call 0x44e4e0
0093A627 mov edx, dword ptr [ebp + 8]
0093A62A push edx
0093A62B push 0xbadd18
0093A630 push 0x100
0093A635 lea eax, [ebp - 0x114]
0093A63B push eax
0093A63C call 0x663beb
0093A641 add esp, 0x10
0093A644 lea ecx, [ebp - 0x114]
0093A64A push ecx
0093A64B lea ecx, [ebp - 0x160]
0093A651 call 0x405fd0
0093A656 mov dword ptr [ebp - 4], 2
0093A65D push 0xb96699
0093A662 lea ecx, [ebp - 0x17c]
0093A668 call 0x405650
0093A66D mov byte ptr [ebp - 4], 3
0093A671 push 0
0093A673 push 0xffff0000
0093A678 push 0
0093A67A push 4
0093A67C lea edx, [ebp - 0x160]
0093A682 push edx
0093A683 lea eax, [ebp - 0x17c]
0093A689 push eax
0093A68A push 0
0093A68C push 0
0093A68E call 0x41b7d0
0093A693 mov ecx, eax
0093A695 call 0xa921b0
0093A69A mov byte ptr [ebp - 4], 2
0093A69E lea ecx, [ebp - 0x17c]
0093A6A4 call 0x4056d0
0093A6A9 mov dword ptr [ebp - 4], 0xffffffff
0093A6B0 lea ecx, [ebp - 0x160]
0093A6B6 call 0x406050
0093A6BB push 0
0093A6BD push 0x12f9120
0093A6C2 push 0x12f8934
0093A6C7 mov ecx, dword ptr [ebp - 0x180]
0093A6CD call 0x4b4f50
0093A6D2 push 0
0093A6D4 push eax
0093A6D5 call 0xa97b0e
0093A6DA add esp, 0x14
0093A6DD mov dword ptr [ebp - 0x10], eax
0093A6E0 cmp dword ptr [ebp - 0x10], 0
0093A6E4 je 0x93a6f2
0093A6E6 mov ecx, dword ptr [ebp + 8]
0093A6E9 push ecx
0093A6EA mov ecx, dword ptr [ebp - 0x10]
0093A6ED call 0x9386f0
0093A6F2 mov ecx, dword ptr [ebp - 0xc]
0093A6F5 mov dword ptr fs:[0], ecx
0093A6FC pop ecx
0093A6FD mov ecx, dword ptr [ebp - 0x14]
0093A700 xor ecx, ebp
0093A702 call 0x6634fb
0093A707 mov esp, ebp
0093A709 pop ebp
0093A70A ret 4
; BADD04 string MonsterWaveBegin; 93B6F3 passes initial wave 1
