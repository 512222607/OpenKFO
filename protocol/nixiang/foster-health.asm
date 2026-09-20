; Read-only gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 940650 returns HP via 9E45B0 for ACTOR_ATTR 1; 8121 +67 is an amount, not final HP.
; range 0x940765 .. 0x9407e1
00940765 fldz
00940767 fstp dword ptr [ebp - 0x18]
0094076A lea ecx, [ebp - 8]
0094076D call 0x4822d0
00940772 cmp dword ptr [eax + 4], -2
00940776 jne 0x940793
00940778 lea ecx, [ebp - 8]
0094077B call 0x4822d0
00940780 cmp dword ptr [eax + 4], -2
00940784 jne 0x940791
00940786 cmp dword ptr [ebp - 0xc], 1
0094078A jne 0x940791
0094078C fld1
0094078E fstp dword ptr [ebp - 0x20]
00940791 jmp 0x9407e1
00940793 lea ecx, [ebp - 8]
00940796 call 0x4822d0
0094079B mov ecx, dword ptr [eax + 4]
0094079E push ecx
0094079F mov ecx, dword ptr [0x17c8708]
009407A5 call 0x818450
009407AA mov dword ptr [ebp - 0x24], eax
009407AD cmp dword ptr [ebp - 0x24], 0
009407B1 jne 0x9407cb
009407B3 push 0xbad438
009407B8 push 0
009407BA mov edx, dword ptr [ebp + 8]
009407BD push edx
009407BE call 0x639f10
009407C3 add esp, 0xc
009407C6 jmp 0x94089f
009407CB mov ecx, dword ptr [ebp - 0x24]
009407CE call 0x9e45b0
009407D3 fstp dword ptr [ebp - 0x20]
009407D6 mov ecx, dword ptr [ebp - 0x24]
009407D9 call 0x9e4430
009407DE fstp dword ptr [ebp - 0x18]
; range 0x940826 .. 0x940893
00940826 mov ecx, dword ptr [ebp - 0xc]
00940829 mov dword ptr [ebp - 0x44], ecx
0094082C cmp dword ptr [ebp - 0x44], 1
00940830 je 0x940840
00940832 cmp dword ptr [ebp - 0x44], 2
00940836 je 0x940857
00940838 cmp dword ptr [ebp - 0x44], 3
0094083C je 0x94086e
0094083E jmp 0x94087e
00940840 fld dword ptr [ebp - 0x20]
00940843 sub esp, 8
00940846 fstp qword ptr [esp]
00940849 mov edx, dword ptr [ebp + 8]
0094084C push edx
0094084D call 0x68c720
00940852 add esp, 0xc
00940855 jmp 0x940893
00940857 fld dword ptr [ebp - 0x18]
0094085A sub esp, 8
0094085D fstp qword ptr [esp]
00940860 mov eax, dword ptr [ebp + 8]
00940863 push eax
00940864 call 0x68c720
00940869 add esp, 0xc
0094086C jmp 0x940893
0094086E push 1
00940870 mov ecx, dword ptr [ebp + 8]
00940873 push ecx
00940874 call 0x68ca20
00940879 add esp, 8
0094087C jmp 0x940893
0094087E push 0xbad484
00940883 push 0
00940885 mov edx, dword ptr [ebp + 8]
00940888 push edx
00940889 call 0x639f10
0094088E add esp, 0xc
00940891 jmp 0x94089f
; range 0x82a9d0 .. 0x82aa8d
0082A9D0 push ebp
0082A9D1 mov ebp, esp
0082A9D3 sub esp, 0x68
0082A9D6 mov dword ptr [ebp - 0x64], ecx
0082A9D9 cmp dword ptr [ebp + 8], 0
0082A9DD je 0x82a9e5
0082A9DF cmp dword ptr [ebp + 0xc], 0x5e
0082A9E3 jae 0x82a9ea
0082A9E5 jmp 0x82ac1b
0082A9EA mov eax, dword ptr [ebp + 8]
0082A9ED mov dword ptr [ebp - 4], eax
0082A9F0 cmp dword ptr [ebp - 4], 0
0082A9F4 je 0x82ac1b
0082A9FA mov ecx, dword ptr [ebp - 4]
0082A9FD add ecx, 0x56
0082AA00 push ecx
0082AA01 mov ecx, dword ptr [0x17c8708]
0082AA07 call 0x817ac0
0082AA0C test eax, eax
0082AA0E jne 0x82aa15
0082AA10 jmp 0x82ac1b
0082AA15 mov edx, dword ptr [ebp - 4]
0082AA18 mov eax, dword ptr [edx + 0x33]
0082AA1B push eax
0082AA1C mov ecx, dword ptr [edx + 0x2f]
0082AA1F push ecx
0082AA20 mov ecx, dword ptr [0x17c8708]
0082AA26 call 0x818c70
0082AA2B mov dword ptr [ebp - 8], eax
0082AA2E mov edx, dword ptr [ebp - 4]
0082AA31 mov eax, dword ptr [edx + 0x2b]
0082AA34 push eax
0082AA35 mov ecx, dword ptr [edx + 0x27]
0082AA38 push ecx
0082AA39 mov ecx, dword ptr [0x17c8708]
0082AA3F call 0x818c70
0082AA44 mov dword ptr [ebp - 0xc], eax
0082AA47 cmp dword ptr [ebp - 0xc], 0
0082AA4B je 0x82ac1b
0082AA51 mov edx, dword ptr [ebp - 4]
0082AA54 fld dword ptr [edx + 0x50]
0082AA57 fcomp qword ptr [0xbe8368]
0082AA5D fnstsw ax
0082AA5F test ah, 0x41
0082AA62 jne 0x82aa76
0082AA64 mov eax, dword ptr [ebp - 4]
0082AA67 push ecx
0082AA68 fld dword ptr [eax + 0x50]
0082AA6B fstp dword ptr [esp]
0082AA6E mov ecx, dword ptr [ebp - 0xc]
0082AA71 call 0x45ca00
0082AA76 mov ecx, dword ptr [ebp - 4]
0082AA79 fld dword ptr [ecx + 0x43]
0082AA7C fcomp qword ptr [0xbe8368]
0082AA82 fnstsw ax
0082AA84 test ah, 0x41
0082AA87 jne 0x82abdc
; range 0x82ab7d .. 0x82abab
0082AB7D push 0
0082AB7F mov edx, dword ptr [ebp - 4]
0082AB82 push ecx
0082AB83 fld dword ptr [edx + 0x48]
0082AB86 fstp dword ptr [esp]
0082AB89 mov ecx, dword ptr [ebp - 0xc]
0082AB8C call 0x9e55a0
0082AB91 cmp dword ptr [ebp - 8], 0
0082AB95 je 0x82abab
0082AB97 push 0
0082AB99 mov eax, dword ptr [ebp - 4]
0082AB9C push ecx
0082AB9D fld dword ptr [eax + 0x4c]
0082ABA0 fstp dword ptr [esp]
0082ABA3 mov ecx, dword ptr [ebp - 8]
0082ABA6 call 0x9e55a0
; range 0x82abdc .. 0x82ac1f
0082ABDC mov eax, dword ptr [ebp - 4]
0082ABDF fld dword ptr [eax + 0x43]
0082ABE2 fchs
0082ABE4 push ecx
0082ABE5 fstp dword ptr [esp]
0082ABE8 mov ecx, dword ptr [ebp - 0xc]
0082ABEB call 0x9e4740
0082ABF0 mov ecx, dword ptr [ebp - 0xc]
0082ABF3 push ecx
0082ABF4 push 1
0082ABF6 mov edx, dword ptr [ebp - 4]
0082ABF9 fld dword ptr [edx + 0x43]
0082ABFC fchs
0082ABFE push ecx
0082ABFF fstp dword ptr [esp]
0082AC02 mov ecx, dword ptr [0x17c8710]
0082AC08 call 0x453db0
0082AC0D mov ecx, eax
0082AC0F call 0x4b4f50
0082AC14 mov ecx, eax
0082AC16 call 0x971000
0082AC1B mov esp, ebp
0082AC1D pop ebp
