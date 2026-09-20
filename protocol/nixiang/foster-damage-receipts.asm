; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Native positive damage calls 9E46B0; source HP effects call 9C5E40.
; 9C5E40 emits its actual self HP delta through a separate 94-byte 8121.
; Do not synthesize a second source-side heal from the original damage packet.
; Global mode gate and additional callbacks remain distinct from server reward authority.
; range 0x9f29f0..0x9f2a87
009F29F0 push ebp
009F29F1 mov ebp, esp
009F29F3 sub esp, 0x74
009F29F6 push esi
009F29F7 mov dword ptr [ebp - 0x6c], ecx
009F29FA call 0x4030c0
009F29FF mov ecx, eax
009F2A01 call 0x4031a0
009F2A06 cmp eax, 2
009F2A09 jne 0x9f2a13
009F2A0B or eax, 0xffffffff
009F2A0E jmp 0x9f2dac
009F2A13 mov ecx, dword ptr [ebp - 0x6c]
009F2A16 call 0x9e5570
009F2A1B mov dword ptr [ebp - 4], eax
009F2A1E mov ecx, dword ptr [ebp - 0x6c]
009F2A21 call 0x9e45b0
009F2A26 fstp dword ptr [ebp - 8]
009F2A29 fld dword ptr [ebp - 8]
009F2A2C fcomp qword ptr [0xbe8368]
009F2A32 fnstsw ax
009F2A34 test ah, 0x41
009F2A37 jp 0x9f2a43
009F2A39 mov eax, 0xffffffff
009F2A3E jmp 0x9f2dac
009F2A43 mov dword ptr [ebp - 0x68], 0
009F2A4A mov dword ptr [ebp - 0x64], 0
009F2A51 fld dword ptr [ebp - 8]
009F2A54 fsub dword ptr [ebp + 8]
009F2A57 fcomp qword ptr [0xbe8368]
009F2A5D fnstsw ax
009F2A5F test ah, 1
009F2A62 jne 0x9f2a6c
009F2A64 fld dword ptr [ebp + 8]
009F2A67 fstp dword ptr [ebp - 0x70]
009F2A6A jmp 0x9f2a72
009F2A6C fld dword ptr [ebp - 8]
009F2A6F fstp dword ptr [ebp - 0x70]
009F2A72 fld dword ptr [ebp - 0x70]
009F2A75 fstp dword ptr [ebp - 0x5c]
009F2A78 push ecx
009F2A79 fld dword ptr [ebp + 8]
009F2A7C fstp dword ptr [esp]
009F2A7F mov ecx, dword ptr [ebp - 0x6c]
009F2A82 call 0x9e46b0
; range 0x9f2b2d..0x9f2ba1
009F2B2D cmp dword ptr [ebp + 0xc], 0
009F2B31 je 0x9f2ba1
009F2B33 mov ecx, dword ptr [ebp + 0xc]
009F2B36 call 0x9e9a30
009F2B3B test eax, eax
009F2B3D je 0x9f2ba1
009F2B3F mov ecx, dword ptr [ebp + 0xc]
009F2B42 cmp ecx, dword ptr [ebp - 0x6c]
009F2B45 je 0x9f2ba1
009F2B47 mov ecx, dword ptr [ebp + 0xc]
009F2B4A call 0x446e60
009F2B4F test eax, eax
009F2B51 je 0x9f2ba1
009F2B53 mov ecx, dword ptr [ebp + 0xc]
009F2B56 call 0x446e60
009F2B5B mov ecx, eax
009F2B5D call 0x454040
009F2B62 fcomp qword ptr [0xbe8368]
009F2B68 fnstsw ax
009F2B6A test ah, 0x44
009F2B6D jp 0x9f2b8b
009F2B6F mov ecx, dword ptr [ebp + 0xc]
009F2B72 call 0x446e60
009F2B77 mov ecx, eax
009F2B79 call 0x454060
009F2B7E fcomp qword ptr [0xbe8368]
009F2B84 fnstsw ax
009F2B86 test ah, 0x44
009F2B89 jnp 0x9f2ba1
009F2B8B push ecx
009F2B8C fld dword ptr [ebp + 8]
009F2B8F fstp dword ptr [esp]
009F2B92 mov ecx, dword ptr [ebp + 0xc]
009F2B95 call 0x446e60
009F2B9A mov ecx, eax
009F2B9C call 0x9c5e40
; range 0x9c5f50..0x9c6014
009C5F50 mov ecx, dword ptr [ebp - 0x74]
009C5F53 mov ecx, dword ptr [ecx]
009C5F55 call 0x9e45b0
009C5F5A fsub dword ptr [ebp - 4]
009C5F5D fstp dword ptr [ebp - 8]
009C5F60 fld dword ptr [ebp - 8]
009C5F63 fcomp qword ptr [0xbe8368]
009C5F69 fnstsw ax
009C5F6B test ah, 0x44
009C5F6E jnp 0x9c600e
009C5F74 push 0x5e
009C5F76 push 0
009C5F78 lea edx, [ebp - 0x70]
009C5F7B push edx
009C5F7C call 0x666960
009C5F81 add esp, 0xc
009C5F84 mov ecx, dword ptr [0x17c86fc]
009C5F8A call 0x402aa0
009C5F8F mov dword ptr [ebp - 0x6c], eax
009C5F92 mov dword ptr [ebp - 0x68], edx
009C5F95 mov eax, dword ptr [ebp - 0x74]
009C5F98 mov ecx, dword ptr [eax]
009C5F9A call 0x401000
009C5F9F mov dword ptr [ebp - 0x49], eax
009C5FA2 mov dword ptr [ebp - 0x45], edx
009C5FA5 mov byte ptr [ebp - 0x1c], 1
009C5FA9 fld dword ptr [ebp - 8]
009C5FAC fchs
009C5FAE fstp dword ptr [ebp - 0x2d]
009C5FB1 mov ecx, dword ptr [ebp - 0x74]
009C5FB4 mov ecx, dword ptr [ecx]
009C5FB6 call 0x44e170
009C5FBB fstp dword ptr [ebp - 0x20]
009C5FBE mov edx, dword ptr [ebp - 0x74]
009C5FC1 mov ecx, dword ptr [edx]
009C5FC3 call 0x432480
009C5FC8 mov byte ptr [ebp - 0x39], al
009C5FCB mov byte ptr [ebp - 0x2f], 1
009C5FCF mov dword ptr [ebp - 0x41], 0
009C5FD6 mov dword ptr [ebp - 0x3d], 0
009C5FDD mov byte ptr [ebp - 0x1b], 0
009C5FE1 mov ecx, dword ptr [0x17c8708]
009C5FE7 call 0x432440
009C5FEC mov ecx, dword ptr [eax]
009C5FEE mov edx, dword ptr [eax + 4]
009C5FF1 mov dword ptr [ebp - 0x1a], ecx
009C5FF4 mov dword ptr [ebp - 0x16], edx
009C5FF7 push 0
009C5FF9 push 0
009C5FFB push 0x5e
009C5FFD lea eax, [ebp - 0x70]
009C6000 push eax
009C6001 push 0x1fb9
009C6006 call 0xa3fbb0
009C600B add esp, 0x14
009C600E mov esp, ebp
009C6010 pop ebp
009C6011 ret 4
