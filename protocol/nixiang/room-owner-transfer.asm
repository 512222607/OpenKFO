; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; A_CHG_ROOM_OWNER_REQ -> double at BE9570 = 4051.0
; A_CHG_ROOM_OWNER_ACK -> double at BE9568 = 4052.0
; RANGE 007A2D9B-007A2DCF
007A2D9B fld qword ptr [0xbe9570]
007A2DA1 fstp qword ptr [esp]
007A2DA4 push 0xbe0e80
007A2DA9 mov edx, dword ptr [ebp + 8]
007A2DAC push edx
007A2DAD call 0x6ad580
007A2DB2 add esp, 8
007A2DB5 fld qword ptr [0xbe9568]
007A2DBB fstp qword ptr [esp]
007A2DBE push 0xbe0e98
007A2DC3 mov eax, dword ptr [ebp + 8]
007A2DC6 push eax
007A2DC7 call 0x6ad580
007A2DCC add esp, 8
; RANGE 00805D70-00805E24
00805D70 push ebp
00805D71 mov ebp, esp
00805D73 sub esp, 0x20
00805D76 push esi
00805D77 push edi
00805D78 mov dword ptr [ebp - 0x10], ecx
00805D7B mov ecx, dword ptr [0x17c8708]
00805D81 call 0x4b1030
00805D86 mov esi, eax
00805D88 mov edi, edx
00805D8A mov ecx, dword ptr [0x17c8708]
00805D90 call 0x819120
00805D95 mov ecx, eax
00805D97 call 0x401000
00805D9C mov dword ptr [ebp - 0x18], esi
00805D9F mov dword ptr [ebp - 0x14], edi
00805DA2 mov dword ptr [ebp - 0x20], eax
00805DA5 mov dword ptr [ebp - 0x1c], edx
00805DA8 mov eax, dword ptr [ebp - 0x18]
00805DAB cmp eax, dword ptr [ebp - 0x20]
00805DAE jne 0x805dd3
00805DB0 mov ecx, dword ptr [ebp - 0x14]
00805DB3 cmp ecx, dword ptr [ebp - 0x1c]
00805DB6 jne 0x805dd3
00805DB8 mov ecx, dword ptr [0x17c8708]
00805DBE call 0x819120
00805DC3 mov ecx, eax
00805DC5 call 0x44b240
00805DCA movzx edx, al
00805DCD test edx, edx
00805DCF je 0x805dd3
00805DD1 jmp 0x805e1e
00805DD3 push 0xc
00805DD5 push 0
00805DD7 lea eax, [ebp - 0xc]
00805DDA push eax
00805DDB call 0x666960
00805DE0 add esp, 0xc
00805DE3 mov ecx, dword ptr [0x17c8708]
00805DE9 call 0x4b1050
00805DEE movzx ecx, ax
00805DF1 mov dword ptr [ebp - 0xc], ecx
00805DF4 mov edx, dword ptr [ebp - 0x10]
00805DF7 mov eax, dword ptr [edx + 0x5b0]
00805DFD mov dword ptr [ebp - 8], eax
00805E00 mov ecx, dword ptr [edx + 0x5b4]
00805E06 mov dword ptr [ebp - 4], ecx
00805E09 push 0xc
00805E0B lea edx, [ebp - 0xc]
00805E0E push edx
00805E0F push 0
00805E11 push 0xfd3
00805E16 call 0xa3c950
00805E1B add esp, 0x10
00805E1E pop edi
00805E1F pop esi
00805E20 mov esp, ebp
00805E22 pop ebp
00805E23 ret
; RANGE 004B1050-004B1065
004B1050 push ebp
004B1051 mov ebp, esp
004B1053 push ecx
004B1054 mov dword ptr [ebp - 4], ecx
004B1057 mov eax, dword ptr [ebp - 4]
004B105A mov ax, word ptr [eax + 0x88]
004B1061 mov esp, ebp
004B1063 pop ebp
004B1064 ret
; RANGE 00B2623F-00B2627B
00B2623F mov dword ptr [0x12feac0], 0xfd4
00B26249 mov dword ptr [0x12feac4], 1
00B26253 mov dword ptr [ebp - 0x170], 0x81fc30
00B2625D mov dword ptr [ebp - 0x16c], 0
00B26267 mov dword ptr [ebp - 0x168], 0
00B26271 mov dword ptr [ebp - 0x164], 0
; RANGE 0081FC30-0081FDC7
0081FC30 push ebp
0081FC31 mov ebp, esp
0081FC33 push -1
0081FC35 push 0xadb84f
0081FC3A mov eax, dword ptr fs:[0]
0081FC40 push eax
0081FC41 sub esp, 0x64
0081FC44 mov eax, dword ptr [0xc7b480]
0081FC49 xor eax, ebp
0081FC4B push eax
0081FC4C lea eax, [ebp - 0xc]
0081FC4F mov dword ptr fs:[0], eax
0081FC55 mov dword ptr [ebp - 0x5c], ecx
0081FC58 mov eax, dword ptr [ebp + 8]
0081FC5B mov dword ptr [ebp - 0x10], eax
0081FC5E mov ecx, dword ptr [ebp - 0x10]
0081FC61 movzx edx, word ptr [ecx]
0081FC64 test edx, edx
0081FC66 jne 0x81fcd0
0081FC68 push 0xbcb638
0081FC6D lea ecx, [ebp - 0x14]
0081FC70 call 0x405fd0
0081FC75 mov dword ptr [ebp - 4], 0
0081FC7C push 0xb96699
0081FC81 lea ecx, [ebp - 0x30]
0081FC84 call 0x405650
0081FC89 mov byte ptr [ebp - 4], 1
0081FC8D push 2
0081FC8F push 0xffbb0000
0081FC94 push 0
0081FC96 push 4
0081FC98 lea eax, [ebp - 0x14]
0081FC9B push eax
0081FC9C lea ecx, [ebp - 0x30]
0081FC9F push ecx
0081FCA0 push 0
0081FCA2 push 0
0081FCA4 call 0x41b7d0
0081FCA9 mov ecx, eax
0081FCAB call 0xa921b0
0081FCB0 mov byte ptr [ebp - 4], 0
0081FCB4 lea ecx, [ebp - 0x30]
0081FCB7 call 0x4056d0
0081FCBC mov dword ptr [ebp - 4], 0xffffffff
0081FCC3 lea ecx, [ebp - 0x14]
0081FCC6 call 0x406050
0081FCCB jmp 0x81fd96
0081FCD0 push 0xbcb654
0081FCD5 lea ecx, [ebp - 0x38]
0081FCD8 call 0x405fd0
0081FCDD mov dword ptr [ebp - 0x60], eax
0081FCE0 mov edx, dword ptr [ebp - 0x60]
0081FCE3 mov dword ptr [ebp - 0x64], edx
0081FCE6 mov dword ptr [ebp - 4], 2
0081FCED mov eax, dword ptr [ebp - 0x10]
0081FCF0 movzx ecx, word ptr [eax]
0081FCF3 imul ecx, ecx, 0x68
0081FCF6 add ecx, 0xd9b5bc
0081FCFC push ecx
0081FCFD mov edx, dword ptr [ebp - 0x64]
0081FD00 push edx
0081FD01 lea eax, [ebp - 0x3c]
0081FD04 push eax
0081FD05 call 0x406200
0081FD0A add esp, 0xc
0081FD0D mov dword ptr [ebp - 0x68], eax
0081FD10 mov ecx, dword ptr [ebp - 0x68]
0081FD13 mov dword ptr [ebp - 0x6c], ecx
0081FD16 mov byte ptr [ebp - 4], 3
0081FD1A mov ecx, dword ptr [ebp - 0x6c]
0081FD1D call 0x406410
0081FD22 push eax
0081FD23 lea ecx, [ebp - 0x34]
0081FD26 call 0x405fd0
0081FD2B mov byte ptr [ebp - 4], 4
0081FD2F push 0xb96699
0081FD34 lea ecx, [ebp - 0x58]
0081FD37 call 0x405650
0081FD3C mov byte ptr [ebp - 4], 5
0081FD40 push 0
0081FD42 push 0xffbb0000
0081FD47 push 0
0081FD49 push 4
0081FD4B lea edx, [ebp - 0x34]
0081FD4E push edx
0081FD4F lea eax, [ebp - 0x58]
0081FD52 push eax
0081FD53 push 0
0081FD55 push 0
0081FD57 call 0x41b7d0
0081FD5C mov ecx, eax
0081FD5E call 0xa921b0
0081FD63 mov byte ptr [ebp - 4], 4
0081FD67 lea ecx, [ebp - 0x58]
0081FD6A call 0x4056d0
0081FD6F mov byte ptr [ebp - 4], 3
0081FD73 lea ecx, [ebp - 0x34]
0081FD76 call 0x406050
0081FD7B mov byte ptr [ebp - 4], 2
0081FD7F lea ecx, [ebp - 0x3c]
0081FD82 call 0x406050
0081FD87 mov dword ptr [ebp - 4], 0xffffffff
0081FD8E lea ecx, [ebp - 0x38]
0081FD91 call 0x406050
0081FD96 mov ecx, dword ptr [0x17c8708]
0081FD9C call 0x81b800
0081FDA1 mov dword ptr [ebp - 0x70], eax
0081FDA4 push 1
0081FDA6 mov ecx, dword ptr [ebp - 0x70]
0081FDA9 mov edx, dword ptr [ecx]
0081FDAB mov ecx, dword ptr [ebp - 0x70]
0081FDAE mov eax, dword ptr [edx + 0x1bc]
0081FDB4 call eax
0081FDB6 mov ecx, dword ptr [ebp - 0xc]
0081FDB9 mov dword ptr fs:[0], ecx
0081FDC0 pop ecx
0081FDC1 mov esp, ebp
0081FDC3 pop ebp
0081FDC4 ret 8
