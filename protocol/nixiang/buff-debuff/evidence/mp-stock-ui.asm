; Current gfld.dat SHA256=98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; MP UI: integer(MP / 100) full stocks; residual MP - stocks * 100 progress; four icons.

; 0x947154
00947154 call 0x9e4430
00947159 fstp dword ptr [ebp - 0x3c]
0094715C fld dword ptr [ebp - 0x3c]
0094715F fdiv qword ptr [0xbe8460]
00947165 call 0x66e430
0094716A mov dword ptr [ebp - 0x40], eax
0094716D mov edx, dword ptr [ebp + 8]
00947170 cmp dword ptr [edx + 0xc], 0
00947174 je 0x947194
00947176 xor eax, eax
00947178 cmp dword ptr [ebp - 0x44], 0
0094717C sete al
0094717F push eax
00947180 fld dword ptr [ebp - 0x30]
00947183 call 0x66e430
00947188 push eax
00947189 mov ecx, dword ptr [ebp + 8]
0094718C mov ecx, dword ptr [ecx + 0xc]
0094718F call 0x74edb0
00947194 mov edx, dword ptr [ebp + 8]
00947197 cmp dword ptr [edx + 0x10], 0
0094719B je 0x9471dd
0094719D push 0x64
0094719F mov eax, dword ptr [ebp + 8]
009471A2 mov ecx, dword ptr [eax + 0x10]
009471A5 call 0x4b2370
009471AA push 0
009471AC mov ecx, dword ptr [ebp + 8]
009471AF mov ecx, dword ptr [ecx + 0x10]
009471B2 call 0x4cece0
009471B7 mov edx, dword ptr [ebp - 0x40]
009471BA imul edx, edx, 0x64
009471BD mov dword ptr [ebp - 0x2fc], edx
009471C3 fild dword ptr [ebp - 0x2fc]
009471C9 fsubr dword ptr [ebp - 0x3c]
009471CC call 0x66e430
009471D1 push eax
009471D2 mov eax, dword ptr [ebp + 8]
009471D5 mov ecx, dword ptr [eax + 0x10]
009471D8 call 0xa859d0
009471DD mov ecx, dword ptr [ebp + 8]
009471E0 cmp dword ptr [ecx + 0x1c], 0
009471E4 je 0x947246
009471E6 push 1

; 0x9481bf
009481BF call 0x9e4430
009481C4 fstp dword ptr [ebp - 0xe0]
009481CA fld dword ptr [ebp - 0xe0]
009481D0 fdiv qword ptr [0xbe8460]
009481D6 call 0x66e430
009481DB mov dword ptr [ebp - 0xe4], eax
009481E1 mov eax, dword ptr [ebp + 8]
009481E4 cmp dword ptr [eax + 0x10], 0
009481E8 je 0x948216
009481EA mov ecx, dword ptr [ebp - 0xe4]
009481F0 imul ecx, ecx, 0x64
009481F3 mov dword ptr [ebp - 0x130], ecx
009481F9 fild dword ptr [ebp - 0x130]
009481FF fsubr dword ptr [ebp - 0xe0]
00948205 call 0x66e430
0094820A push eax
0094820B mov edx, dword ptr [ebp + 8]
0094820E mov ecx, dword ptr [edx + 0x10]
00948211 call 0xa859d0
00948216 mov dword ptr [ebp - 0xec], 0
00948220 jmp 0x948231
00948222 mov eax, dword ptr [ebp - 0xec]
00948228 add eax, 1
0094822B mov dword ptr [ebp - 0xec], eax
00948231 cmp dword ptr [ebp - 0xec], 4
00948238 jge 0x948294
0094823A mov ecx, dword ptr [ebp - 0xec]
00948240 cmp ecx, dword ptr [ebp - 0xe4]
00948246 jge 0x94826e
00948248 mov edx, dword ptr [ebp - 0xec]
0094824E mov eax, dword ptr [ebp + 8]
00948251 cmp dword ptr [eax + edx*4 + 0x2c], 0
00948256 je 0x94826e
00948258 push 1
0094825A mov ecx, dword ptr [ebp - 0xec]
00948260 mov edx, dword ptr [ebp + 8]
00948263 mov ecx, dword ptr [edx + ecx*4 + 0x2c]
00948267 call 0x75aa30
0094826C jmp 0x948292
0094826E mov eax, dword ptr [ebp - 0xec]
00948274 mov ecx, dword ptr [ebp + 8]
00948277 cmp dword ptr [ecx + eax*4 + 0x2c], 0
0094827C je 0x948292
0094827E push 0
00948280 mov edx, dword ptr [ebp - 0xec]
00948286 mov eax, dword ptr [ebp + 8]
00948289 mov ecx, dword ptr [eax + edx*4 + 0x2c]
0094828D call 0x75aa30
00948292 jmp 0x948222
00948294 mov ecx, dword ptr [0x17c8708]
0094829A call 0x4535c0

; 0x9e5620
009E5620 push ebp
009E5621 mov ebp, esp
009E5623 sub esp, 8
009E5626 mov dword ptr [ebp - 4], ecx
009E5629 cmp dword ptr [ebp + 8], 4
009E562D jle 0x9e5636
009E562F mov dword ptr [ebp + 8], 4
009E5636 mov eax, dword ptr [ebp + 8]
009E5639 imul eax, eax, 0x64
009E563C mov dword ptr [ebp - 8], eax
009E563F fild dword ptr [ebp - 8]
009E5642 push ecx
009E5643 fstp dword ptr [esp]
009E5646 mov ecx, dword ptr [ebp - 4]
009E5649 call 0x9e4470
009E564E mov esp, ebp
009E5650 pop ebp
009E5651 ret 4
009E5654 int3

; 0x9e47d0
009E47D0 push ebp
009E47D1 mov ebp, esp
009E47D3 sub esp, 0xcc
009E47D9 mov dword ptr [ebp - 0xcc], ecx
009E47DF lea eax, [ebp - 0xc8]
009E47E5 push eax
009E47E6 mov ecx, dword ptr [ebp - 0xcc]
009E47EC mov ecx, dword ptr [ecx + 0x17b0]
009E47F2 call 0x4585e0
009E47F7 mov ecx, dword ptr [ebp - 0xcc]
009E47FD call 0x446e60
009E4802 mov ecx, eax
009E4804 call 0x453db0
009E4809 test eax, eax
009E480B je 0x9e4820
009E480D fld dword ptr [ebp - 0x90]
009E4813 fcomp qword ptr [0xbe9b90]
009E4819 fnstsw ax
009E481B test ah, 1
009E481E jne 0x9e4839
009E4820 push ecx
009E4821 fld dword ptr [0xbe9b88]
009E4827 fstp dword ptr [esp]
009E482A mov ecx, dword ptr [ebp - 0xcc]
009E4830 call 0x9e4470
009E4835 xor eax, eax
009E4837 jmp 0x9e4845
009E4839 mov edx, dword ptr [ebp - 0xcc]
009E483F mov eax, dword ptr [edx + 0x1bd8]
009E4845 mov esp, ebp
009E4847 pop ebp
009E4848 ret

; 0x9e55a0
009E55A0 push ebp
009E55A1 mov ebp, esp
009E55A3 push ecx
009E55A4 mov dword ptr [ebp - 4], ecx
009E55A7 mov ecx, dword ptr [ebp - 4]
009E55AA call 0x9e47d0
009E55AF test eax, eax
009E55B1 jne 0x9e55b5
009E55B3 jmp 0x9e55ef
009E55B5 cmp dword ptr [ebp + 0xc], 0
009E55B9 jne 0x9e55e0
009E55BB mov eax, dword ptr [ebp - 4]
009E55BE fld dword ptr [eax + 0x1b14]
009E55C4 fcomp qword ptr [0xbe8350]
009E55CA fnstsw ax
009E55CC test ah, 0x44
009E55CF jnp 0x9e55e0
009E55D1 fld dword ptr [ebp + 8]
009E55D4 mov ecx, dword ptr [ebp - 4]
009E55D7 fmul dword ptr [ecx + 0x1b14]
009E55DD fstp dword ptr [ebp + 8]
009E55E0 push ecx
009E55E1 fld dword ptr [ebp + 8]
009E55E4 fstp dword ptr [esp]
009E55E7 mov ecx, dword ptr [ebp - 4]
009E55EA call 0x9e4550
009E55EF mov esp, ebp
009E55F1 pop ebp
009E55F2 ret 8

; 0x82ab7d
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
