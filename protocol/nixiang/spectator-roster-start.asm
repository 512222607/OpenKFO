; Source SHA256: 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 3105 list spectator branch and 4080 eight participant peer slots.

; Block 0xb263d7
00B263D7 mov dword ptr [0x12feb20], 0xc21
00B263E1 mov dword ptr [0x12feb24], 1
00B263EB mov dword ptr [ebp - 0x20], 0x81f020
00B263F2 mov dword ptr [ebp - 0x1c], 0

; Block 0x81f0c1
0081F0C1 mov ecx, dword ptr [ebp - 0x14]
0081F0C4 movzx edx, byte ptr [ecx + 0x4c]
0081F0C8 test edx, edx
0081F0CA je 0x81f0f5
0081F0CC push 1
0081F0CE push 1
0081F0D0 lea eax, [ebp - 0x4ec]
0081F0D6 push eax
0081F0D7 mov ecx, dword ptr [ebp - 0x14]
0081F0DA push ecx
0081F0DB mov edx, dword ptr [ebp - 0x14]
0081F0DE mov eax, dword ptr [edx + 4]
0081F0E1 push eax
0081F0E2 mov ecx, dword ptr [edx]
0081F0E4 push ecx
0081F0E5 mov ecx, dword ptr [0x17c8708]
0081F0EB call 0x81be60
0081F0F0 jmp 0x81f216

; Block 0x81f216
0081F216 mov edx, dword ptr [ebp - 0x14]
0081F219 movzx eax, byte ptr [edx + 0x40]
0081F21D imul eax, eax, 0x44
0081F220 add eax, dword ptr [ebp - 0x10]
0081F223 mov dword ptr [ebp - 0x14], eax
0081F226 mov ecx, dword ptr [ebp - 0x14]
0081F229 add ecx, 0x95
0081F22F mov dword ptr [ebp - 0x10], ecx
0081F232 mov edx, dword ptr [ebp - 0x14]
0081F235 sub edx, dword ptr [ebp + 8]
0081F238 cmp edx, dword ptr [ebp + 0xc]
0081F23B jl 0x81f23f
0081F23D jmp 0x81f244
0081F23F jmp 0x81f078

; Block 0xb26575
00B26575 mov dword ptr [0x12feb98], 0xff0
00B2657F mov dword ptr [0x12feb9c], 1
00B26589 mov dword ptr [ebp - 0x70], 0x81e1a0
00B26590 mov dword ptr [ebp - 0x6c], 0

; Block 0x81e26b
0081E26B jmp 0x81e276
0081E26D mov eax, dword ptr [ebp - 0xc]
0081E270 add eax, 1
0081E273 mov dword ptr [ebp - 0xc], eax
0081E276 cmp dword ptr [ebp - 0xc], 8
0081E27A jae 0x81e2f5
0081E27C mov ecx, dword ptr [ebp - 0xc]
0081E27F push ecx
0081E280 mov ecx, dword ptr [0x17c8708]
0081E286 call 0x818450
0081E28B mov dword ptr [ebp - 8], eax
0081E28E cmp dword ptr [ebp - 8], 0
0081E292 je 0x81e2f0
0081E294 mov edx, dword ptr [ebp - 0xc]
0081E297 mov eax, dword ptr [ebp - 4]
0081E29A mov ecx, dword ptr [eax + edx*4 + 0xd]
0081E29E push ecx
0081E29F mov ecx, dword ptr [ebp - 8]
0081E2A2 call 0x5495a0
