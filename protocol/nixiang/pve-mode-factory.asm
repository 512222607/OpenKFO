; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0098C2AF..0098C2D2
0098C2AF mov eax, dword ptr [ebp + 8]
0098C2B2 mov dword ptr [ebp - 0xa0], eax
0098C2B8 cmp dword ptr [ebp - 0xa0], 0x15
0098C2BF ja 0x98c7ec
0098C2C5 mov ecx, dword ptr [ebp - 0xa0]
0098C2CB jmp dword ptr [ecx*4 + 0x98c86c]

; range 0098C5BD..0098C673
0098C5BD push 0x11c
0098C5C2 call 0x667fbb
0098C5C7 add esp, 4
0098C5CA mov dword ptr [ebp - 0x74], eax
0098C5CD mov dword ptr [ebp - 4], 8
0098C5D4 cmp dword ptr [ebp - 0x74], 0
0098C5D8 je 0x98c5ea
0098C5DA mov ecx, dword ptr [ebp - 0x74]
0098C5DD call 0x941620
0098C5E2 mov dword ptr [ebp - 0xc4], eax
0098C5E8 jmp 0x98c5f4
0098C5EA mov dword ptr [ebp - 0xc4], 0
0098C5F4 mov eax, dword ptr [ebp - 0xc4]
0098C5FA mov dword ptr [ebp - 0x70], eax
0098C5FD mov dword ptr [ebp - 4], 0xffffffff
0098C604 mov ecx, dword ptr [ebp - 0x98]
0098C60A mov edx, dword ptr [ebp - 0x70]
0098C60D mov dword ptr [ecx + 0xac], edx
0098C613 jmp 0x98c7ec
0098C618 push 0x160
0098C61D call 0x667fbb
0098C622 add esp, 4
0098C625 mov dword ptr [ebp - 0x7c], eax
0098C628 mov dword ptr [ebp - 4], 9
0098C62F cmp dword ptr [ebp - 0x7c], 0
0098C633 je 0x98c645
0098C635 mov ecx, dword ptr [ebp - 0x7c]
0098C638 call 0x93b710
0098C63D mov dword ptr [ebp - 0xc8], eax
0098C643 jmp 0x98c64f
0098C645 mov dword ptr [ebp - 0xc8], 0
0098C64F mov eax, dword ptr [ebp - 0xc8]
0098C655 mov dword ptr [ebp - 0x78], eax
0098C658 mov dword ptr [ebp - 4], 0xffffffff
0098C65F mov ecx, dword ptr [ebp - 0x98]
0098C665 mov edx, dword ptr [ebp - 0x78]
0098C668 mov dword ptr [ecx + 0xac], edx
0098C66E jmp 0x98c7ec

; range 00941620..0094166E
00941620 push ebp
00941621 mov ebp, esp
00941623 push -1
00941625 push 0xad6656
0094162A mov eax, dword ptr fs:[0]
00941630 push eax
00941631 push ecx
00941632 mov eax, dword ptr [0xc7b480]
00941637 xor eax, ebp
00941639 push eax
0094163A lea eax, [ebp - 0xc]
0094163D mov dword ptr fs:[0], eax
00941643 mov dword ptr [ebp - 0x10], ecx
00941646 call 0x93f8c0
0094164B push eax
0094164C mov ecx, dword ptr [ebp - 0x10]
0094164F call 0xa4bef0
00941654 mov dword ptr [ebp - 4], 0
0094165B mov eax, dword ptr [ebp - 0x10]
0094165E mov dword ptr [eax], 0xbad584
00941664 mov ecx, dword ptr [ebp - 0x10]
00941667 mov dword ptr [ecx + 0x10], 0

; range 0093B710..0093B773
0093B710 push ebp
0093B711 mov ebp, esp
0093B713 push -1
0093B715 push 0xad65af
0093B71A mov eax, dword ptr fs:[0]
0093B720 push eax
0093B721 push ecx
0093B722 mov eax, dword ptr [0xc7b480]
0093B727 xor eax, ebp
0093B729 push eax
0093B72A lea eax, [ebp - 0xc]
0093B72D mov dword ptr fs:[0], eax
0093B733 mov dword ptr [ebp - 0x10], ecx
0093B736 call 0x938a10
0093B73B push eax
0093B73C mov ecx, dword ptr [ebp - 0x10]
0093B73F call 0xa4bef0
0093B744 mov dword ptr [ebp - 4], 0
0093B74B mov ecx, dword ptr [ebp - 0x10]
0093B74E add ecx, 0x10
0093B751 call 0x4d6f50
0093B756 mov byte ptr [ebp - 4], 1
0093B75A mov eax, dword ptr [ebp - 0x10]
0093B75D mov dword ptr [eax], 0xbadd44
0093B763 mov ecx, dword ptr [ebp - 0x10]
0093B766 mov dword ptr [ecx + 0x10], 0xbade6c
0093B76D mov edx, dword ptr [ebp - 0x10]
; mode 10 switch target = 0098C5BD
; mode 21 switch target = 0098C618
; hierarchy 00BF5B54 flags=0 count=3
; base descriptor 00BF5BAC type 012F9004 .?AVCFosterMode@@
; base descriptor 00BF5B74 type 012F8FE8 .?AVCPVEBaseMode@@
; base descriptor 00BF3CA0 type 012F899C .?AVIBattleMode@@
; hierarchy 00BF5F44 flags=1 count=4
; base descriptor 00BF5F84 type 012F90D0 .?AVCStageAssaultMode@@
; base descriptor 00BF5B74 type 012F8FE8 .?AVCPVEBaseMode@@
; base descriptor 00BF3CA0 type 012F899C .?AVIBattleMode@@
; base descriptor 00BF5F68 type 012F90F0 .?AVILuaHelperDebugTextListener@scgl@@
