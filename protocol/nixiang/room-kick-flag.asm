; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Client flag source only. No inferred nonzero authorization or operation semantics.
; RANGE 008062F0-0080634F
008062F0 push ebp
008062F1 mov ebp, esp
008062F3 sub esp, 0x10
008062F6 mov dword ptr [ebp - 0x10], ecx
008062F9 mov eax, dword ptr [ebp - 0x10]
008062FC mov edx, dword ptr [eax]
008062FE mov ecx, dword ptr [ebp - 0x10]
00806301 mov eax, dword ptr [edx + 0x1ac]
00806307 call eax
00806309 mov ecx, dword ptr [ebp - 0x10]
0080630C mov edx, dword ptr [ecx + 0x5b0]
00806312 mov dword ptr [ebp - 0xc], edx
00806315 mov eax, dword ptr [ecx + 0x5b4]
0080631B mov dword ptr [ebp - 8], eax
0080631E mov ecx, dword ptr [0x17c86fc]
00806324 call 0x481080
00806329 mov byte ptr [ebp - 4], al
0080632C push 9
0080632E lea ecx, [ebp - 0xc]
00806331 push ecx
00806332 push 0
00806334 push 0xc44
00806339 call 0xa3c950
0080633E add esp, 0x10
00806341 mov ecx, dword ptr [ebp - 0x10]
00806344 call 0x7fc330
00806349 mov esp, ebp
0080634B pop ebp
0080634C ret
0080634D int3
0080634E int3
; RANGE 00481080-00481094
00481080 push ebp
00481081 mov ebp, esp
00481083 push ecx
00481084 mov dword ptr [ebp - 4], ecx
00481087 mov eax, dword ptr [ebp - 4]
0048108A mov al, byte ptr [eax + 0x107c]
00481090 mov esp, ebp
00481092 pop ebp
00481093 ret
; RANGE 0041B670-0041B689
0041B670 push ebp
0041B671 mov ebp, esp
0041B673 push ecx
0041B674 mov dword ptr [ebp - 4], ecx
0041B677 mov eax, dword ptr [ebp - 4]
0041B67A mov cl, byte ptr [ebp + 8]
0041B67D mov byte ptr [eax + 0x107c], cl
0041B683 mov esp, ebp
0041B685 pop ebp
0041B686 ret 4
; RANGE 00822E30-00822EFC
00822E30 push ebp
00822E31 mov ebp, esp
00822E33 sub esp, 8
00822E36 mov dword ptr [ebp - 8], ecx
00822E39 cmp dword ptr [ebp + 8], 0
00822E3D je 0x822e45
00822E3F cmp dword ptr [ebp + 0xc], 0x25
00822E43 jae 0x822e4a
00822E45 jmp 0x822ef6
00822E4A mov eax, dword ptr [ebp + 8]
00822E4D mov dword ptr [ebp - 4], eax
00822E50 mov ecx, dword ptr [ebp - 4]
00822E53 mov edx, dword ptr [ecx + 0xc]
00822E56 mov dword ptr [0x17c8b30], edx
00822E5C mov eax, dword ptr [ebp - 4]
00822E5F mov ecx, dword ptr [eax + 0xc]
00822E62 push ecx
00822E63 mov ecx, dword ptr [0x17c86fc]
00822E69 call 0x549900
00822E6E mov edx, dword ptr [ebp - 4]
00822E71 mov eax, dword ptr [edx + 0x10]
00822E74 push eax
00822E75 mov ecx, dword ptr [0x17c86fc]
00822E7B call 0x41b690
00822E80 mov ecx, dword ptr [ebp - 4]
00822E83 mov edx, dword ptr [ecx + 0x14]
00822E86 push edx
00822E87 mov ecx, dword ptr [0x17c86fc]
00822E8D call 0x41b6c0
00822E92 mov eax, dword ptr [ebp - 4]
00822E95 mov ecx, dword ptr [eax + 0x21]
00822E98 push ecx
00822E99 mov ecx, dword ptr [0x17c86fc]
00822E9F call 0x9ccf50
00822EA4 call 0x41c230
00822EA9 mov ecx, eax
00822EAB call 0x91c830
00822EB0 mov edx, dword ptr [ebp - 4]
00822EB3 movzx eax, byte ptr [edx + 0x20]
00822EB7 push eax
00822EB8 mov ecx, dword ptr [0x17c86fc]
00822EBE call 0x41b670
00822EC3 call 0x4164e0
00822EC8 mov ecx, eax
00822ECA call 0x4f3a50
00822ECF push eax
00822ED0 call 0x4164e0
00822ED5 mov ecx, eax
00822ED7 call 0x549840
00822EDC push 1
00822EDE call 0x45e240
00822EE3 mov ecx, eax
00822EE5 call 0x911c20
00822EEA call 0xa4dfa0
00822EEF mov ecx, eax
00822EF1 call 0xa50230
00822EF6 mov esp, ebp
00822EF8 pop ebp
00822EF9 ret 8
; RANGE 00A27330-00A273A9
00A27330 push ebp
00A27331 mov ebp, esp
00A27333 sub esp, 0x14
00A27336 mov dword ptr [ebp - 8], ecx
00A27339 cmp dword ptr [ebp + 8], 0
00A2733D je 0xa27345
00A2733F cmp dword ptr [ebp + 0xc], 0xc
00A27343 je 0xa27347
00A27345 jmp 0xa273a3
00A27347 mov eax, dword ptr [ebp + 8]
00A2734A mov dword ptr [ebp - 4], eax
00A2734D mov ecx, dword ptr [0x17c86fc]
00A27353 call 0x402aa0
00A27358 mov ecx, dword ptr [ebp - 4]
00A2735B mov dword ptr [ebp - 0xc], ecx
00A2735E mov dword ptr [ebp - 0x14], eax
00A27361 mov dword ptr [ebp - 0x10], edx
00A27364 mov edx, dword ptr [ebp - 0xc]
00A27367 mov eax, dword ptr [edx]
00A27369 cmp eax, dword ptr [ebp - 0x14]
00A2736C jne 0xa27379
00A2736E mov ecx, dword ptr [ebp - 0xc]
00A27371 mov edx, dword ptr [ecx + 4]
00A27374 cmp edx, dword ptr [ebp - 0x10]
00A27377 je 0xa2737b
00A27379 jmp 0xa273a3
00A2737B mov eax, dword ptr [ebp - 4]
00A2737E cmp dword ptr [eax + 8], 0x1f
00A27382 je 0xa27396
00A27384 mov ecx, dword ptr [ebp - 4]
00A27387 cmp dword ptr [ecx + 8], 4
00A2738B je 0xa27396
00A2738D mov edx, dword ptr [ebp - 4]
00A27390 cmp dword ptr [edx + 8], 0x11
00A27394 jne 0xa273a3
00A27396 push 1
00A27398 mov ecx, dword ptr [0x17c86fc]
00A2739E call 0x41b670
00A273A3 mov esp, ebp
00A273A5 pop ebp
00A273A6 ret 8
