; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0x822e30..0x822efc
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

; range 0x86d810..0x86d9de
0086D810 push ebp
0086D811 mov ebp, esp
0086D813 push -1
0086D815 push 0xaabc7c
0086D81A mov eax, dword ptr fs:[0]
0086D820 push eax
0086D821 sub esp, 0xb0
0086D827 mov eax, dword ptr [0xc7b480]
0086D82C xor eax, ebp
0086D82E mov dword ptr [ebp - 0x1c], eax
0086D831 push eax
0086D832 lea eax, [ebp - 0xc]
0086D835 mov dword ptr fs:[0], eax
0086D83B mov dword ptr [ebp - 0xb4], ecx
0086D841 push 0xbc54f8
0086D846 lea ecx, [ebp - 0x5c]
0086D849 call 0x405650
0086D84E mov dword ptr [ebp - 4], 0
0086D855 push 0
0086D857 push 0x12f8a44
0086D85C push 0x12f8898
0086D861 lea eax, [ebp - 0x5c]
0086D864 push eax
0086D865 mov ecx, dword ptr [ebp - 0xb4]
0086D86B call 0x75fbf0
0086D870 push 0
0086D872 push eax
0086D873 call 0xa97b0e
0086D878 add esp, 0x14
0086D87B mov dword ptr [ebp - 0x10], eax
0086D87E mov dword ptr [ebp - 4], 0xffffffff
0086D885 lea ecx, [ebp - 0x5c]
0086D888 call 0x4056d0
0086D88D cmp dword ptr [ebp - 0x10], 0
0086D891 je 0x86d8ef
0086D893 mov ecx, dword ptr [0x17c86fc]
0086D899 call 0x9ccf80
0086D89E push eax
0086D89F lea ecx, [ebp - 0x78]
0086D8A2 push ecx
0086D8A3 mov ecx, dword ptr [0x17c86f8]
0086D8A9 call 0xa342e0
0086D8AE mov dword ptr [ebp - 0xb8], eax
0086D8B4 mov edx, dword ptr [ebp - 0xb8]
0086D8BA mov dword ptr [ebp - 0xbc], edx
0086D8C0 mov dword ptr [ebp - 4], 1
0086D8C7 push 1
0086D8C9 mov eax, dword ptr [ebp - 0xbc]
0086D8CF push eax
0086D8D0 mov ecx, dword ptr [ebp - 0x10]
0086D8D3 mov edx, dword ptr [ecx]
0086D8D5 mov ecx, dword ptr [ebp - 0x10]
0086D8D8 mov eax, dword ptr [edx + 0xd4]
0086D8DE call eax
0086D8E0 mov dword ptr [ebp - 4], 0xffffffff
0086D8E7 lea ecx, [ebp - 0x78]
0086D8EA call 0x4056d0
0086D8EF push 0xbc5504
0086D8F4 lea ecx, [ebp - 0x94]
0086D8FA call 0x405650
0086D8FF mov dword ptr [ebp - 4], 2
0086D906 push 0
0086D908 push 0x12f8a44
0086D90D push 0x12f8898
0086D912 lea ecx, [ebp - 0x94]
0086D918 push ecx
0086D919 mov ecx, dword ptr [ebp - 0xb4]
0086D91F call 0x75fbf0
0086D924 push 0
0086D926 push eax
0086D927 call 0xa97b0e
0086D92C add esp, 0x14
0086D92F mov dword ptr [ebp - 0x14], eax
0086D932 mov dword ptr [ebp - 4], 0xffffffff
0086D939 lea ecx, [ebp - 0x94]
0086D93F call 0x4056d0
0086D944 cmp dword ptr [ebp - 0x14], 0
0086D948 je 0x86d9c5
0086D94A lea edx, [ebp - 0x18]
0086D94D push edx
0086D94E lea eax, [ebp - 0x40]
0086D951 push eax
0086D952 mov ecx, dword ptr [0x17c86fc]
0086D958 call 0x9ce200
0086D95D mov eax, dword ptr [ebp - 0x18]
0086D960 cdq
0086D961 mov ecx, 0x3c
0086D966 idiv ecx
0086D968 cdq
0086D969 mov ecx, 0x18
0086D96E idiv ecx
0086D970 push eax
0086D971 push 0xb9dc0c
0086D976 push 0x1f
0086D978 lea edx, [ebp - 0x3c]
0086D97B push edx
0086D97C call 0x663beb
0086D981 add esp, 0x10
0086D984 lea eax, [ebp - 0x3c]
0086D987 push eax
0086D988 lea ecx, [ebp - 0xb0]
0086D98E call 0x405650
0086D993 mov dword ptr [ebp - 4], 3
0086D99A push 1
0086D99C lea ecx, [ebp - 0xb0]
0086D9A2 push ecx
0086D9A3 mov edx, dword ptr [ebp - 0x14]
0086D9A6 mov eax, dword ptr [edx]
0086D9A8 mov ecx, dword ptr [ebp - 0x14]
0086D9AB mov edx, dword ptr [eax + 0xd4]
0086D9B1 call edx
0086D9B3 mov dword ptr [ebp - 4], 0xffffffff
0086D9BA lea ecx, [ebp - 0xb0]
0086D9C0 call 0x4056d0
0086D9C5 mov ecx, dword ptr [ebp - 0xc]
0086D9C8 mov dword ptr fs:[0], ecx
0086D9CF pop ecx
0086D9D0 mov ecx, dword ptr [ebp - 0x1c]
0086D9D3 xor ecx, ebp
0086D9D5 call 0x6634fb
0086D9DA mov esp, ebp
0086D9DC pop ebp
0086D9DD ret

; range 0x9ce200..0x9ce362
009CE200 push ebp
009CE201 mov ebp, esp
009CE203 sub esp, 0x34
009CE206 mov dword ptr [ebp - 0x28], ecx
009CE209 mov eax, dword ptr [ebp + 8]
009CE20C mov dword ptr [eax], 1
009CE212 mov ecx, dword ptr [ebp + 0xc]
009CE215 mov dword ptr [ecx], 0
009CE21B mov ecx, dword ptr [ebp - 0x28]
009CE21E call 0x45e200
009CE223 push eax
009CE224 lea ecx, [ebp - 0x18]
009CE227 call 0x45e480
009CE22C mov dword ptr [ebp - 0x1c], 0
009CE233 jmp 0x9ce23e
009CE235 mov edx, dword ptr [ebp - 0x1c]
009CE238 add edx, 1
009CE23B mov dword ptr [ebp - 0x1c], edx
009CE23E lea ecx, [ebp - 0x18]
009CE241 call 0x5571d0
009CE246 cmp dword ptr [ebp - 0x1c], eax
009CE249 jae 0x9ce34d
009CE24F mov eax, dword ptr [ebp - 0x1c]
009CE252 push eax
009CE253 lea ecx, [ebp - 0x18]
009CE256 call 0x559130
009CE25B mov dword ptr [ebp - 0x20], eax
009CE25E mov ecx, dword ptr [ebp - 0x20]
009CE261 cmp dword ptr [ecx + 5], 0xb2391
009CE268 jne 0x9ce2ac
009CE26A mov edx, dword ptr [ebp - 0x20]
009CE26D cmp dword ptr [edx + 0x13], 1
009CE271 jne 0x9ce2ac
009CE273 mov eax, dword ptr [ebp + 8]
009CE276 cmp dword ptr [eax], 2
009CE279 jge 0x9ce2ac
009CE27B mov ecx, dword ptr [ebp + 8]
009CE27E mov dword ptr [ecx], 2
009CE284 mov edx, dword ptr [ebp + 0xc]
009CE287 mov eax, dword ptr [ebp - 0x20]
009CE28A mov ecx, dword ptr [edx]
009CE28C cmp ecx, dword ptr [eax + 0xd]
009CE28F jbe 0x9ce29b
009CE291 mov edx, dword ptr [ebp + 0xc]
009CE294 mov eax, dword ptr [edx]
009CE296 mov dword ptr [ebp - 0x2c], eax
009CE299 jmp 0x9ce2a4
009CE29B mov ecx, dword ptr [ebp - 0x20]
009CE29E mov edx, dword ptr [ecx + 0xd]
009CE2A1 mov dword ptr [ebp - 0x2c], edx
009CE2A4 mov eax, dword ptr [ebp + 0xc]
009CE2A7 mov ecx, dword ptr [ebp - 0x2c]
009CE2AA mov dword ptr [eax], ecx
009CE2AC mov edx, dword ptr [ebp - 0x20]
009CE2AF cmp dword ptr [edx + 5], 0xb2392
009CE2B6 jne 0x9ce2fa
009CE2B8 mov eax, dword ptr [ebp - 0x20]
009CE2BB cmp dword ptr [eax + 0x13], 1
009CE2BF jne 0x9ce2fa
009CE2C1 mov ecx, dword ptr [ebp + 8]
009CE2C4 cmp dword ptr [ecx], 3
009CE2C7 jge 0x9ce2fa
009CE2C9 mov edx, dword ptr [ebp + 8]
009CE2CC mov dword ptr [edx], 3
009CE2D2 mov eax, dword ptr [ebp + 0xc]
009CE2D5 mov ecx, dword ptr [ebp - 0x20]
009CE2D8 mov edx, dword ptr [eax]
009CE2DA cmp edx, dword ptr [ecx + 0xd]
009CE2DD jbe 0x9ce2e9
009CE2DF mov eax, dword ptr [ebp + 0xc]
009CE2E2 mov ecx, dword ptr [eax]
009CE2E4 mov dword ptr [ebp - 0x30], ecx
009CE2E7 jmp 0x9ce2f2
009CE2E9 mov edx, dword ptr [ebp - 0x20]
009CE2EC mov eax, dword ptr [edx + 0xd]
009CE2EF mov dword ptr [ebp - 0x30], eax
009CE2F2 mov ecx, dword ptr [ebp + 0xc]
009CE2F5 mov edx, dword ptr [ebp - 0x30]
009CE2F8 mov dword ptr [ecx], edx
009CE2FA mov eax, dword ptr [ebp - 0x20]
009CE2FD cmp dword ptr [eax + 5], 0xb2393
009CE304 jne 0x9ce348
009CE306 mov ecx, dword ptr [ebp - 0x20]
009CE309 cmp dword ptr [ecx + 0x13], 1
009CE30D jne 0x9ce348
009CE30F mov edx, dword ptr [ebp + 8]
009CE312 cmp dword ptr [edx], 4
009CE315 jge 0x9ce348
009CE317 mov eax, dword ptr [ebp + 8]
009CE31A mov dword ptr [eax], 4
009CE320 mov ecx, dword ptr [ebp + 0xc]
009CE323 mov edx, dword ptr [ebp - 0x20]
009CE326 mov eax, dword ptr [ecx]
009CE328 cmp eax, dword ptr [edx + 0xd]
009CE32B jbe 0x9ce337
009CE32D mov ecx, dword ptr [ebp + 0xc]
009CE330 mov edx, dword ptr [ecx]
009CE332 mov dword ptr [ebp - 0x34], edx
009CE335 jmp 0x9ce340
009CE337 mov eax, dword ptr [ebp - 0x20]
009CE33A mov ecx, dword ptr [eax + 0xd]
009CE33D mov dword ptr [ebp - 0x34], ecx
009CE340 mov edx, dword ptr [ebp + 0xc]
009CE343 mov eax, dword ptr [ebp - 0x34]
009CE346 mov dword ptr [edx], eax
009CE348 jmp 0x9ce235
009CE34D mov byte ptr [ebp - 0x21], 1
009CE351 lea ecx, [ebp - 0x18]
009CE354 call 0x46ea80
009CE359 mov al, byte ptr [ebp - 0x21]
009CE35C mov esp, ebp
009CE35E pop ebp
009CE35F ret 8

; range 0x45e200..0x45e213
0045E200 push ebp
0045E201 mov ebp, esp
0045E203 push ecx
0045E204 mov dword ptr [ebp - 4], ecx
0045E207 mov eax, dword ptr [ebp - 4]
0045E20A add eax, 0xec8
0045E20F mov esp, ebp
0045E211 pop ebp
0045E212 ret

; range 0x45e480..0x45e510
0045E480 push ebp
0045E481 mov ebp, esp
0045E483 push -1
0045E485 push 0xae5a28
0045E48A mov eax, dword ptr fs:[0]
0045E490 push eax
0045E491 push ecx
0045E492 sub esp, 0x1c
0045E495 push ebx
0045E496 push esi
0045E497 push edi
0045E498 mov eax, dword ptr [0xc7b480]
0045E49D xor eax, ebp
0045E49F push eax
0045E4A0 lea eax, [ebp - 0xc]
0045E4A3 mov dword ptr fs:[0], eax
0045E4A9 mov dword ptr [ebp - 0x10], esp
0045E4AC mov dword ptr [ebp - 0x28], ecx
0045E4AF mov eax, dword ptr [ebp + 8]
0045E4B2 add eax, 8
0045E4B5 push ecx
0045E4B6 mov ecx, esp
0045E4B8 mov dword ptr [ebp - 0x14], esp
0045E4BB push eax
0045E4BC call 0x52f530
0045E4C1 mov ecx, dword ptr [ebp - 0x28]
0045E4C4 call 0x584fd0
0045E4C9 mov dword ptr [ebp - 4], 0
0045E4D0 mov ecx, dword ptr [ebp + 8]
0045E4D3 call 0x5571d0
0045E4D8 push eax
0045E4D9 mov ecx, dword ptr [ebp - 0x28]
0045E4DC call 0x572160
0045E4E1 movzx ecx, al
0045E4E4 test ecx, ecx
0045E4E6 je 0x45e554
0045E4E8 mov byte ptr [ebp - 4], 1
0045E4EC mov edx, dword ptr [ebp - 0x28]
0045E4EF mov eax, dword ptr [edx + 0xc]
0045E4F2 push eax
0045E4F3 lea ecx, [ebp - 0x1c]
0045E4F6 push ecx
0045E4F7 mov ecx, dword ptr [ebp + 8]
0045E4FA call 0x4330d0
0045E4FF mov edx, dword ptr [eax + 4]
0045E502 push edx
0045E503 mov eax, dword ptr [eax]
0045E505 push eax
0045E506 lea ecx, [ebp - 0x24]
0045E509 push ecx
0045E50A mov ecx, dword ptr [ebp + 8]
