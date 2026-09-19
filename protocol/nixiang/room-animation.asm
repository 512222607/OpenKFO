; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Native room animation receive path; request producer remains unconfirmed.

; Block 0x7a2bc7
007A2BC7 fld qword ptr [0xbe95f8]
007A2BCD fstp qword ptr [esp]
007A2BD0 push 0xbe0d20
007A2BD5 mov edx, dword ptr [ebp + 8]
007A2BD8 push edx
007A2BD9 call 0x6ad580
007A2BDE add esp, 8
007A2BE1 fld qword ptr [0xbe95f0]
007A2BE7 fstp qword ptr [esp]
007A2BEA push 0xbe0d2c
007A2BEF mov eax, dword ptr [ebp + 8]
007A2BF2 push eax
007A2BF3 call 0x6ad580
007A2BF8 add esp, 8

; Block 0xb26522
00B26522 mov dword ptr [0x12feb80], 0xd5c
00B2652C mov dword ptr [0x12feb84], 1
00B26536 mov dword ptr [ebp - 0x60], 0x81de60
00B2653D mov dword ptr [ebp - 0x5c], 0
00B26544 mov dword ptr [ebp - 0x58], 0
00B2654B mov dword ptr [ebp - 0x54], 0
00B26552 mov edx, dword ptr [ebp - 0x60]
00B26555 mov dword ptr [0x12feb88], edx
00B2655B mov eax, dword ptr [ebp - 0x5c]
00B2655E mov dword ptr [0x12feb8c], eax

; Block 0x81de60
0081DE60 push ebp
0081DE61 mov ebp, esp
0081DE63 sub esp, 8
0081DE66 mov dword ptr [ebp - 8], ecx
0081DE69 cmp dword ptr [ebp + 8], 0
0081DE6D je 0x81de75
0081DE6F cmp dword ptr [ebp + 0xc], 9
0081DE73 je 0x81de77
0081DE75 jmp 0x81de98
0081DE77 mov eax, dword ptr [ebp + 8]
0081DE7A mov dword ptr [ebp - 4], eax
0081DE7D mov ecx, dword ptr [ebp - 4]
0081DE80 movzx edx, byte ptr [ecx + 8]
0081DE84 push edx
0081DE85 mov eax, dword ptr [ebp - 4]
0081DE88 mov ecx, dword ptr [eax]
0081DE8A push ecx
0081DE8B mov edx, dword ptr [ebp - 8]
0081DE8E mov eax, dword ptr [edx]
0081DE90 mov ecx, dword ptr [ebp - 8]
0081DE93 mov edx, dword ptr [eax + 0x20]
0081DE96 call edx
0081DE98 mov esp, ebp
0081DE9A pop ebp

; Lua doubles BE95F8=3410 and BE95F0=3420.
; Integer 3410 matches in the code scan at 520C3A and 56B04A are CALL relative displacements, not opcode producers.
