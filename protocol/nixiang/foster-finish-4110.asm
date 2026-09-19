; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Mode 10: constructor 941620 installs BAD584; vtable +30 -> 942FE0.
; reason 1 reads mode+18 (Lua is_finished / 20407), not mode21+1C.
; reasons 2/3 and 696B report producer 987E40 are shared with mode21.
00942FE0 push ebp
00942FE1 mov ebp, esp
00942FE3 sub esp, 0x2c
00942FE6 mov dword ptr [ebp - 0x1c], ecx
00942FE9 mov ecx, dword ptr [0x17c8710]
00942FEF call 0x453b80
00942FF4 test eax, eax
00942FF6 je 0x943016
00942FF8 push ecx
00942FF9 fldz
00942FFB fstp dword ptr [esp]
00942FFE push 0
00943000 mov ecx, dword ptr [ebp - 0x1c]
00943003 call 0x4b4f50
00943008 mov ecx, eax
0094300A call 0x96c810
0094300F mov al, 1
00943011 jmp 0x943226
00943016 xor eax, eax
00943018 mov word ptr [ebp - 8], ax
0094301C mov dword ptr [ebp - 4], 0
00943023 push ecx
00943024 fldz
00943026 fstp dword ptr [esp]
00943029 push 0
0094302B mov ecx, dword ptr [ebp - 0x1c]
0094302E call 0x4b4f50
00943033 mov ecx, eax
00943035 call 0x96c810
0094303A call 0x94bf10
0094303F mov ecx, eax
00943041 call 0x94bc50
00943046 test eax, eax
00943048 jne 0x94305f
0094304A mov ecx, 3
0094304F mov word ptr [ebp - 8], cx
00943053 mov dword ptr [ebp - 4], 1
0094305A jmp 0x943188
0094305F mov edx, dword ptr [ebp - 0x1c]
00943062 movzx eax, byte ptr [edx + 0x18]
00943066 cmp eax, 1
00943069 jne 0x943080
0094306B mov ecx, 1
00943070 mov word ptr [ebp - 8], cx
00943074 mov dword ptr [ebp - 4], 1
0094307B jmp 0x943188
00943080 mov dword ptr [ebp - 0xc], 1
00943087 mov dword ptr [ebp - 0x10], 0
0094308E jmp 0x943099
00943090 mov edx, dword ptr [ebp - 0x10]
00943093 add edx, 1
00943096 mov dword ptr [ebp - 0x10], edx
00943099 cmp dword ptr [ebp - 0x10], 8
0094309D jae 0x9430d1
0094309F mov eax, dword ptr [ebp - 0x10]
009430A2 push eax
009430A3 mov ecx, dword ptr [0x17c8708]
009430A9 call 0x818450
009430AE mov dword ptr [ebp - 0x14], eax
009430B1 cmp dword ptr [ebp - 0x14], 0
009430B5 je 0x9430cf
009430B7 mov ecx, dword ptr [ebp - 0x14]
009430BA call 0x44e110
009430BF movzx ecx, al
009430C2 test ecx, ecx
009430C4 jne 0x9430cf
009430C6 mov dword ptr [ebp - 0xc], 0
009430CD jmp 0x9430d1
009430CF jmp 0x943090
009430D1 cmp dword ptr [ebp - 0xc], 0
009430D5 je 0x94316d
009430DB mov ecx, dword ptr [0x17c8710]
009430E1 call 0x985bd0
009430E6 mov edx, dword ptr [ebp - 0x1c]
009430E9 sub eax, dword ptr [edx + 0x100]
009430EF mov dword ptr [ebp - 0x18], eax
009430F2 cmp dword ptr [ebp - 0x18], 0x2328
009430F9 jle 0x94313c
009430FB mov eax, 2
00943100 mov word ptr [ebp - 8], ax
00943104 mov dword ptr [ebp - 4], 1
0094310B mov ecx, 0x2328
00943110 sub ecx, dword ptr [ebp - 0x18]
00943113 mov dword ptr [ebp - 0x20], ecx
00943116 fild dword ptr [ebp - 0x20]
00943119 fmul qword ptr [0xbe8378]
0094311F fstp dword ptr [ebp - 0x24]
00943122 fld dword ptr [ebp - 0x24]
00943125 push ecx
00943126 fstp dword ptr [esp]
00943129 push 0
0094312B mov ecx, dword ptr [ebp - 0x1c]
0094312E call 0x4b4f50
00943133 mov ecx, eax
00943135 call 0x96c810
0094313A jmp 0x94316b
0094313C mov edx, 0x2328
00943141 sub edx, dword ptr [ebp - 0x18]
00943144 mov dword ptr [ebp - 0x28], edx
00943147 fild dword ptr [ebp - 0x28]
0094314A fmul qword ptr [0xbe8378]
00943150 fstp dword ptr [ebp - 0x2c]
00943153 fld dword ptr [ebp - 0x2c]
00943156 push ecx
00943157 fstp dword ptr [esp]
0094315A push 1
0094315C mov ecx, dword ptr [ebp - 0x1c]
0094315F call 0x4b4f50
00943164 mov ecx, eax
00943166 call 0x96c810
0094316B jmp 0x943188
0094316D mov ecx, dword ptr [0x17c8710]
00943173 call 0x985bd0
00943178 mov ecx, dword ptr [ebp - 0x1c]
0094317B mov dword ptr [ecx + 0x100], eax
00943181 mov dword ptr [ebp - 4], 0
00943188 cmp dword ptr [ebp - 4], 0
0094318C je 0x94321f
00943192 mov ecx, dword ptr [0x17c8708]
00943198 call 0x819120
0094319D test eax, eax
0094319F je 0x9431e1
009431A1 mov ecx, dword ptr [0x17c8708]
009431A7 call 0x819120
009431AC mov ecx, eax
009431AE call 0x44b3f0
009431B3 test eax, eax
009431B5 je 0x9431e1
009431B7 movzx edx, word ptr [ebp - 8]
009431BB push edx
009431BC mov ecx, dword ptr [0x17c8710]
009431C2 call 0x987e40
009431C7 mov eax, dword ptr [ebp - 0x1c]
009431CA mov edx, dword ptr [eax]
009431CC mov ecx, dword ptr [ebp - 0x1c]
009431CF mov eax, dword ptr [edx + 0x2c]
009431D2 call eax
009431D4 mov ecx, dword ptr [ebp - 0x1c]
009431D7 mov edx, dword ptr [ecx]
009431D9 mov ecx, dword ptr [ebp - 0x1c]
009431DC mov eax, dword ptr [edx + 0x34]
009431DF call eax
009431E1 mov ecx, dword ptr [0x17c8690]
009431E7 push ecx
009431E8 mov ecx, dword ptr [0x17c86fc]
009431EE call 0x4b1000
009431F3 push ecx
009431F4 fldz
009431F6 fstp dword ptr [esp]
009431F9 push 0
009431FB mov ecx, dword ptr [ebp - 0x1c]
009431FE call 0x4b4f50
00943203 mov ecx, eax
00943205 call 0x96c810
0094320A push 0
0094320C push 0
0094320E push 0
00943210 mov ecx, dword ptr [ebp - 0x1c]
00943213 call 0x4b4f50
00943218 mov ecx, eax
0094321A call 0x973390
0094321F cmp dword ptr [ebp - 4], 0
00943223 setne al
00943226 mov esp, ebp
00943228 pop ebp
00943229 ret
