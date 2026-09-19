; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Common startup object and resource/input-ready producers. Observer end-to-end path not proven.

; Block 0x7ea03e
007EA03E call 0x65fd90
007EA043 mov ecx, eax
007EA045 call 0x65feb0
007EA04A mov dword ptr [0x17c8690], eax

; Block 0x98d6ee
0098D6EE push 0
0098D6F0 push 0x1040
0098D6F5 call 0xa3ca00
0098D6FA add esp, 8

; Block 0x985660
00985660 push ebp
00985661 mov ebp, esp
00985663 sub esp, 0x14
00985666 mov dword ptr [ebp - 0x14], ecx
00985669 mov ecx, dword ptr [0x17c8708]
0098566F call 0x4b1050
00985674 mov word ptr [ebp - 0x10], ax
00985678 mov ecx, dword ptr [0x17c86fc]
0098567E call 0x402aa0
00985683 mov dword ptr [ebp - 0xe], eax
00985686 mov dword ptr [ebp - 0xa], edx
00985689 mov eax, dword ptr [0x17ba718]
0098568E mov dword ptr [ebp - 6], eax
00985691 cmp dword ptr [0x17c8714], 0
00985698 je 0x9856b8
0098569A cmp dword ptr [0x17c8710], 0
009856A1 je 0x9856b8
009856A3 push 0xe
009856A5 lea ecx, [ebp - 0x10]
009856A8 push ecx
009856A9 push 0
009856AB push 0x1f68
009856B0 call 0xa3c950
009856B5 add esp, 0x10
009856B8 mov esp, ebp
009856BA pop ebp
009856BB ret
