; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0x941910 .. 0x941A83
00941910 push ebp
00941911 mov ebp, esp
00941913 push -1
00941915 push 0xadbcbe
0094191A mov eax, dword ptr fs:[0]
00941920 push eax
00941921 sub esp, 0x54
00941924 mov eax, dword ptr [0xc7b480]
00941929 xor eax, ebp
0094192B push eax
0094192C lea eax, [ebp - 0xc]
0094192F mov dword ptr fs:[0], eax
00941935 mov dword ptr [ebp - 0x60], ecx
00941938 mov ecx, dword ptr [0x17c8708]
0094193E call 0x819120
00941943 test eax, eax
00941945 je 0x941a74
0094194B mov ecx, dword ptr [0x17c8708]
00941951 call 0x819120
00941956 mov ecx, eax
00941958 call 0x44b3f0
0094195D test eax, eax
0094195F je 0x941a74
00941965 mov ecx, dword ptr [0x17c8710]
0094196B call 0x985c80
00941970 test eax, eax
00941972 je 0x941a74
00941978 push 0
0094197A push 0
0094197C push 0xbad55c
00941981 mov eax, dword ptr [ebp - 0x60]
00941984 mov ecx, dword ptr [eax + 0x10]
00941987 call 0x6399b0
0094198C mov ecx, dword ptr [ebp - 0x60]
0094198F movzx edx, byte ptr [ecx + 0x18]
00941993 test edx, edx
00941995 jne 0x941a74
0094199B lea ecx, [ebp - 0x24]
0094199E call 0x5734a0
009419A3 mov dword ptr [ebp - 4], 0
009419AA lea eax, [ebp - 0x24]
009419AD push eax
009419AE push 0
009419B0 push 0xbad568
009419B5 mov ecx, dword ptr [ebp - 0x60]
009419B8 mov ecx, dword ptr [ecx + 0x10]
009419BB call 0x6399b0
009419C0 movzx edx, al
009419C3 test edx, edx
009419C5 je 0x941a65
009419CB lea ecx, [ebp - 0x24]
009419CE call 0x4341e0
009419D3 cmp eax, 1
009419D6 jne 0x941a65
009419DC push 0
009419DE lea ecx, [ebp - 0x24]
009419E1 call 0x4d4be0
009419E6 mov dword ptr [ebp - 0x28], eax
009419E9 mov ecx, dword ptr [ebp - 0x28]
009419EC call 0x63b010
009419F1 cmp eax, 2
009419F4 jne 0x941a65
009419F6 mov eax, dword ptr [ebp - 0x60]
009419F9 mov cl, byte ptr [eax + 0x18]
009419FC mov byte ptr [ebp - 0x29], cl
009419FF mov ecx, dword ptr [ebp - 0x28]
00941A02 call 0x63b040
00941A07 mov edx, dword ptr [ebp - 0x60]
00941A0A mov byte ptr [edx + 0x18], al
00941A0D movzx eax, byte ptr [ebp - 0x29]
00941A11 mov ecx, dword ptr [ebp - 0x60]
00941A14 movzx edx, byte ptr [ecx + 0x18]
00941A18 cmp eax, edx
00941A1A je 0x941a65
00941A1C mov eax, dword ptr [ebp - 0x60]
00941A1F movzx ecx, byte ptr [eax + 0x18]
00941A23 cmp ecx, 1
00941A26 jne 0x941a65
00941A28 push 0x2f
00941A2A push 0
00941A2C lea edx, [ebp - 0x5c]
00941A2F push edx
00941A30 call 0x666960
00941A35 add esp, 0xc
00941A38 mov ecx, dword ptr [0x17c8708]
00941A3E call 0x432440
00941A43 mov ecx, dword ptr [eax]
00941A45 mov edx, dword ptr [eax + 4]
00941A48 mov dword ptr [ebp - 0x35], ecx
00941A4B mov dword ptr [ebp - 0x31], edx
00941A4E push 0
00941A50 push 0
00941A52 push 0x2f
00941A54 lea eax, [ebp - 0x5c]
00941A57 push eax
00941A58 push 0x4fb7
00941A5D call 0xa3fbb0
00941A62 add esp, 0x14
00941A65 mov dword ptr [ebp - 4], 0xffffffff
00941A6C lea ecx, [ebp - 0x24]
00941A6F call 0x44e4e0
00941A74 mov ecx, dword ptr [ebp - 0xc]
00941A77 mov dword ptr fs:[0], ecx
00941A7E pop ecx
00941A7F mov esp, ebp
00941A81 pop ebp
00941A82 ret

; range 0x827EF0 .. 0x827FBA
00827EF0 push ebp
00827EF1 mov ebp, esp
00827EF3 sub esp, 0x1c
00827EF6 mov dword ptr [ebp - 0x14], ecx
00827EF9 cmp dword ptr [ebp + 8], 0
00827EFD je 0x827f05
00827EFF cmp dword ptr [ebp + 0xc], 0x2f
00827F03 je 0x827f0a
00827F05 jmp 0x827fb6
00827F0A mov byte ptr [ebp - 1], 0
00827F0E cmp dword ptr [0x17c8708], 0
00827F15 je 0x827f7b
00827F17 mov eax, dword ptr [ebp + 8]
00827F1A mov dword ptr [ebp - 8], eax
00827F1D mov ecx, dword ptr [ebp - 8]
00827F20 mov edx, dword ptr [ecx + 8]
00827F23 push edx
00827F24 mov eax, dword ptr [ecx + 4]
00827F27 push eax
00827F28 mov ecx, dword ptr [0x17c8708]
00827F2E call 0x818c70
00827F33 mov dword ptr [ebp - 0xc], eax
00827F36 cmp dword ptr [ebp - 0xc], 0
00827F3A je 0x827f7b
00827F3C mov ecx, dword ptr [ebp - 0xc]
00827F3F call 0x44b3f0
00827F44 test eax, eax
00827F46 je 0x827f7b
00827F48 mov ecx, dword ptr [0x17c8708]
00827F4E call 0x432440
00827F53 mov ecx, dword ptr [ebp - 8]
00827F56 mov dword ptr [ebp - 0x18], eax
00827F59 mov dword ptr [ebp - 0x1c], ecx
00827F5C mov edx, dword ptr [ebp - 0x18]
00827F5F mov eax, dword ptr [ebp - 0x1c]
00827F62 mov ecx, dword ptr [edx]
00827F64 cmp ecx, dword ptr [eax + 0x27]
00827F67 jne 0x827f7b
00827F69 mov edx, dword ptr [ebp - 0x18]
00827F6C mov eax, dword ptr [ebp - 0x1c]
00827F6F mov ecx, dword ptr [edx + 4]
00827F72 cmp ecx, dword ptr [eax + 0x2b]
00827F75 jne 0x827f7b
00827F77 mov byte ptr [ebp - 1], 1
00827F7B movzx edx, byte ptr [ebp - 1]
00827F7F test edx, edx
00827F81 je 0x827fb6
00827F83 push 0
00827F85 push 0x12f9004
00827F8A push 0x12f899c
00827F8F mov ecx, dword ptr [0x17c8710]
00827F95 call 0x453db0
00827F9A push 0
00827F9C push eax
00827F9D call 0xa97b0e
00827FA2 add esp, 0x14
00827FA5 mov dword ptr [ebp - 0x10], eax
00827FA8 cmp dword ptr [ebp - 0x10], 0
00827FAC je 0x827fb6
00827FAE mov ecx, dword ptr [ebp - 0x10]
00827FB1 call 0x93ff50
00827FB6 mov esp, ebp
00827FB8 pop ebp

; range 0x93FF50 .. 0x93FF62
0093FF50 push ebp
0093FF51 mov ebp, esp
0093FF53 push ecx
0093FF54 mov dword ptr [ebp - 4], ecx
0093FF57 mov eax, dword ptr [ebp - 4]
0093FF5A mov byte ptr [eax + 0x18], 1
0093FF5E mov esp, ebp
0093FF60 pop ebp
0093FF61 ret

; range 0x44B3F0 .. 0x44B404
0044B3F0 push ebp
0044B3F1 mov ebp, esp
0044B3F3 push ecx
0044B3F4 mov dword ptr [ebp - 4], ecx
0044B3F7 mov eax, dword ptr [ebp - 4]
0044B3FA mov eax, dword ptr [eax + 0x1b74]
0044B400 mov esp, ebp
0044B402 pop ebp
0044B403 ret

; range 0x82D22D .. 0x82D24C
0082D22D mov eax, dword ptr [ebp - 0x18]
0082D230 sub eax, 0x4fb1
0082D235 mov dword ptr [ebp - 0x18], eax
0082D238 cmp dword ptr [ebp - 0x18], 7
0082D23C ja 0x82d743
0082D242 mov ecx, dword ptr [ebp - 0x18]
0082D245 jmp dword ptr [ecx*4 + 0x82d8fc]

; range 0x82D64C .. 0x82D661
0082D64C mov ecx, dword ptr [ebp - 4]
0082D64F push ecx
0082D650 mov edx, dword ptr [ebp - 8]
0082D653 push edx
0082D654 mov ecx, dword ptr [ebp - 0x14]
0082D657 call 0x827ef0
0082D65C jmp 0x82d743

; 20407 dispatch table: 82D8FC + (20407-20401)*4 -> 0x82d64c
; string 00BAD55C: map_update
; string 00BAD568: is_finished
; string 012F900C: .?AVCFosterMode@@
; string 012F90D8: .?AVCStageAssaultMode@@
