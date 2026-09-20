; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Foster initial HP: Lua field 12 -> definition+74 -> max/current attribute+2C/+34.
; 94350A commits the attribute block. No scale conversion in these assignments.
; Getter/damage/healing below operate on decoded current HP; not a full damage policy.
; range 0xa6310c..0xa63147
00A6310C mov edx, dword ptr [ebp - 0x20]
00A6310F add edx, 1
00A63112 mov dword ptr [ebp - 0x20], edx
00A63115 mov eax, dword ptr [ebp - 0x20]
00A63118 push eax
00A63119 push -1
00A6311B mov ecx, dword ptr [ebp + 8]
00A6311E push ecx
00A6311F call 0x68cc10
00A63124 add esp, 0xc
00A63127 push -1
00A63129 mov edx, dword ptr [ebp + 8]
00A6312C push edx
00A6312D call 0x68c320
00A63132 add esp, 8
00A63135 mov eax, dword ptr [ebp - 0x14]
00A63138 fstp dword ptr [eax + 0x74]
00A6313B push -2
00A6313D mov ecx, dword ptr [ebp + 8]
00A63140 push ecx
00A63141 call 0x68bbb0
; range 0x943435..0x94350f
00943435 push 0
00943437 push ecx
00943438 fldz
0094343A fstp dword ptr [esp]
0094343D push 0
0094343F push 0
00943441 mov ecx, dword ptr [ebp + 0x10]
00943444 push ecx
00943445 mov ecx, dword ptr [ebp + 8]
00943448 call 0x9f2dc0
0094344D mov edx, dword ptr [ebp + 0xc]
00943450 movzx eax, byte ptr [edx + 0x78]
00943454 push eax
00943455 mov ecx, dword ptr [ebp + 8]
00943458 call 0x4d4340
0094345D mov ecx, dword ptr [ebp + 8]
00943460 call 0x9e5570
00943465 mov ecx, dword ptr [ebp + 0xc]
00943468 fld dword ptr [ecx + 0x74]
0094346B fstp dword ptr [eax + 0x2c]
0094346E mov ecx, dword ptr [ebp + 8]
00943471 call 0x9e5570
00943476 mov edx, dword ptr [ebp + 0xc]
00943479 fld dword ptr [edx + 0x74]
0094347C fstp dword ptr [eax + 0x34]
0094347F push 0
00943481 mov eax, dword ptr [ebp + 0xc]
00943484 push ecx
00943485 fld dword ptr [eax + 0x7c]
00943488 fstp dword ptr [esp]
0094348B mov ecx, dword ptr [ebp + 8]
0094348E call 0x9e55a0
00943493 mov ecx, dword ptr [0x17c8708]
00943499 call 0x819120
0094349E test eax, eax
009434A0 je 0x9434c4
009434A2 mov ecx, dword ptr [0x17c8708]
009434A8 call 0x819120
009434AD mov ecx, eax
009434AF call 0x4058b0
009434B4 test eax, eax
009434B6 jne 0x9434c4
009434B8 mov dword ptr [ebp - 0x94], 1
009434C2 jmp 0x9434ce
009434C4 mov dword ptr [ebp - 0x94], 0
009434CE mov ecx, dword ptr [ebp - 0x94]
009434D4 push ecx
009434D5 mov ecx, dword ptr [ebp + 8]
009434D8 call 0x9e43f0
009434DD mov edx, dword ptr [ebp + 0xc]
009434E0 push ecx
009434E1 fld dword ptr [edx + 0x74]
009434E4 fstp dword ptr [esp]
009434E7 mov ecx, dword ptr [ebp + 8]
009434EA call 0x9fe7e0
009434EF mov ecx, dword ptr [ebp + 8]
009434F2 call 0x9fe880
009434F7 mov ecx, dword ptr [ebp + 8]
009434FA call 0x9e5570
009434FF push eax
00943500 mov ecx, dword ptr [ebp + 8]
00943503 call 0x453930
00943508 mov ecx, eax
0094350A call 0x458660
; range 0x9e45b0..0x9e45f0
009E45B0 push ebp
009E45B1 mov ebp, esp
009E45B3 sub esp, 0xcc
009E45B9 mov dword ptr [ebp - 0xcc], ecx
009E45BF lea eax, [ebp - 0xc8]
009E45C5 push eax
009E45C6 mov ecx, dword ptr [ebp - 0xcc]
009E45CC mov ecx, dword ptr [ecx + 0x17b0]
009E45D2 call 0x4585e0
009E45D7 fld dword ptr [ebp - 0x94]
009E45DD mov esp, ebp
009E45DF pop ebp
009E45E0 ret
; range 0x9e46b0..0x9e4740
009E46B0 push ebp
009E46B1 mov ebp, esp
009E46B3 sub esp, 0xd0
009E46B9 mov dword ptr [ebp - 0xcc], ecx
009E46BF lea eax, [ebp - 0xc8]
009E46C5 push eax
009E46C6 mov ecx, dword ptr [ebp - 0xcc]
009E46CC mov ecx, dword ptr [ecx + 0x17b0]
009E46D2 call 0x4585e0
009E46D7 fld dword ptr [ebp - 0x94]
009E46DD fsub dword ptr [ebp + 8]
009E46E0 fstp dword ptr [ebp - 0x94]
009E46E6 fld dword ptr [ebp - 0x94]
009E46EC fcomp qword ptr [0xbe8368]
009E46F2 fnstsw ax
009E46F4 test ah, 5
009E46F7 jp 0x9e4703
009E46F9 fldz
009E46FB fstp dword ptr [ebp - 0xd0]
009E4701 jmp 0x9e470f
009E4703 fld dword ptr [ebp - 0x94]
009E4709 fstp dword ptr [ebp - 0xd0]
009E470F fld dword ptr [ebp - 0xd0]
009E4715 fstp dword ptr [ebp - 0x94]
009E471B lea edx, [ebp - 0xc8]
009E4721 push edx
009E4722 mov eax, dword ptr [ebp - 0xcc]
009E4728 mov ecx, dword ptr [eax + 0x17b0]
009E472E call 0x458660
009E4733 mov esp, ebp
009E4735 pop ebp
009E4736 ret 4
; range 0x9e4740..0x9e4800
009E4740 push ebp
009E4741 mov ebp, esp
009E4743 sub esp, 0xd0
009E4749 mov dword ptr [ebp - 0xcc], ecx
009E474F lea eax, [ebp - 0xc8]
009E4755 push eax
009E4756 mov ecx, dword ptr [ebp - 0xcc]
009E475C mov ecx, dword ptr [ecx + 0x17b0]
009E4762 call 0x4585e0
009E4767 fld dword ptr [ebp - 0x94]
009E476D fadd dword ptr [ebp + 8]
009E4770 fstp dword ptr [ebp - 0x94]
009E4776 fld dword ptr [ebp - 0x94]
009E477C fld dword ptr [ebp - 0x9c]
009E4782 fcompp
009E4784 fnstsw ax
009E4786 test ah, 0x41
009E4789 jne 0x9e4799
009E478B fld dword ptr [ebp - 0x94]
009E4791 fstp dword ptr [ebp - 0xd0]
009E4797 jmp 0x9e47a5
009E4799 fld dword ptr [ebp - 0x9c]
009E479F fstp dword ptr [ebp - 0xd0]
009E47A5 fld dword ptr [ebp - 0xd0]
009E47AB fstp dword ptr [ebp - 0x94]
009E47B1 lea edx, [ebp - 0xc8]
009E47B7 push edx
009E47B8 mov eax, dword ptr [ebp - 0xcc]
009E47BE mov ecx, dword ptr [eax + 0x17b0]
009E47C4 call 0x458660
009E47C9 mov esp, ebp
009E47CB pop ebp
009E47CC ret 4
