; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
00A48EE0 push     ebp
00A48EE1 mov      ebp, esp
00A48EE3 sub      esp, 0x28
00A48EE6 mov      dword ptr [ebp - 0x28], ecx
00A48EE9 movzx    eax, word ptr [ebp + 8]
00A48EED push     eax
00A48EEE mov      ecx, dword ptr [ebp - 0x28]
00A48EF1 call     0xa47d00
00A48EF6 mov      dword ptr [ebp - 8], eax
00A48EF9 cmp      dword ptr [ebp - 8], 0
00A48EFD jne      0xa48f04
00A48EFF jmp      0xa48fac
00A48F04 push     0x7b
00A48F06 call     0x667fbb
00A48F0B add      esp, 4
00A48F0E mov      dword ptr [ebp - 0xc], eax
00A48F11 mov      ecx, dword ptr [ebp - 0xc]
00A48F14 mov      dword ptr [ebp - 4], ecx
00A48F17 mov      edx, dword ptr [ebp - 4]
00A48F1A mov      byte ptr [edx + 6], 1
00A48F1E mov      eax, dword ptr [ebp - 4]
00A48F21 mov      cx, word ptr [ebp + 8]
00A48F25 mov      word ptr [eax + 4], cx
00A48F29 lea      edx, [ebp - 4]
00A48F2C push     edx
00A48F2D mov      ecx, dword ptr [ebp - 0x28]
00A48F30 add      ecx, 0x78
00A48F33 call     0x4a5c30
00A48F38 xor      eax, eax
00A48F3A mov      byte ptr [ebp - 0xd], al
00A48F3D movzx    ecx, byte ptr [ebp - 0xd]
00A48F41 push     ecx
00A48F42 lea      edx, [ebp - 0x18]
00A48F45 push     edx
00A48F46 mov      ecx, dword ptr [ebp - 0x28]
00A48F49 add      ecx, 0x78
00A48F4C call     0x4f2590
00A48F51 mov      ecx, dword ptr [eax + 4]
00A48F54 push     ecx
00A48F55 mov      edx, dword ptr [eax]
00A48F57 push     edx
00A48F58 lea      eax, [ebp - 0x20]
00A48F5B push     eax
00A48F5C mov      ecx, dword ptr [ebp - 0x28]
00A48F5F add      ecx, 0x78
00A48F62 call     0x4d6050
00A48F67 mov      ecx, dword ptr [eax + 4]
00A48F6A push     ecx
00A48F6B mov      edx, dword ptr [eax]
00A48F6D push     edx
00A48F6E call     0x539910
00A48F73 add      esp, 0x14
00A48F76 movzx    eax, word ptr [ebp + 8]
00A48F7A mov      dword ptr [ebp - 0x24], eax
00A48F7D lea      ecx, [ebp - 0x24]
00A48F80 push     ecx
00A48F81 mov      ecx, dword ptr [ebp - 0x28]
00A48F84 add      ecx, 0xc0
00A48F8A call     0x532800
00A48F8F movzx    edx, word ptr [ebp + 8]
00A48F93 mov      eax, dword ptr [ebp - 0x28]
00A48F96 mov      dword ptr [eax + 0xf4], edx
00A48F9C mov      ecx, dword ptr [ebp - 0x28]
00A48F9F call     0xa47f70
00A48FA4 mov      ecx, dword ptr [ebp - 0x28]
00A48FA7 call     0xa48e30
00A48FAC mov      esp, ebp
00A48FAE pop      ebp
00A48FAF ret      4