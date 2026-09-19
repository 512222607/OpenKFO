; Read-only gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; range 0x7a2bfb
007A2BFB fld qword ptr [0xbe95e8]
007A2C01 fstp qword ptr [esp]
007A2C04 push 0xbe0d40
007A2C09 mov ecx, dword ptr [ebp + 8]
007A2C0C push ecx
007A2C0D call 0x6ad580
007A2C12 add esp, 8
007A2C15 fld qword ptr [0xbe95e0]
007A2C1B fstp qword ptr [esp]
007A2C1E push 0xbe0d50
007A2C23 mov edx, dword ptr [ebp + 8]
007A2C26 push edx
007A2C27 call 0x6ad580
007A2C2C add esp, 8
007A2C2F fld qword ptr [0xbe95d8]
007A2C35 fstp qword ptr [esp]
007A2C38 push 0xbe0d68
007A2C3D mov eax, dword ptr [ebp + 8]
007A2C40 push eax
007A2C41 call 0x6ad580
007A2C46 add esp, 8
007A2C49 fld qword ptr [0xbe95d0]
007A2C4F fstp qword ptr [esp]
007A2C52 push 0xbe0d74
007A2C57 mov ecx, dword ptr [ebp + 8]
007A2C5A push ecx
007A2C5B call 0x6ad580
; range 0xb25daa
00B25DAA mov dword ptr [0x12fe9b8], 0xd70
00B25DB4 mov dword ptr [0x12fe9bc], 1
00B25DBE mov dword ptr [ebp - 0xc0], 0x81f6c0
00B25DC8 mov dword ptr [ebp - 0xbc], 0
00B25DD2 mov dword ptr [ebp - 0xb8], 0
00B25DDC mov dword ptr [ebp - 0xb4], 0
00B25DE6 mov edx, dword ptr [ebp - 0xc0]
00B25DEC mov dword ptr [0x12fe9c0], edx
00B25DF2 mov eax, dword ptr [ebp - 0xbc]
00B25DF8 mov dword ptr [0x12fe9c4], eax
00B25DFD mov ecx, dword ptr [ebp - 0xb8]
00B25E03 mov dword ptr [0x12fe9c8], ecx
00B25E09 mov edx, dword ptr [ebp - 0xb4]
; range 0x81f6c0
0081F6C0 push ebp
0081F6C1 mov ebp, esp
0081F6C3 sub esp, 0xc
0081F6C6 mov dword ptr [ebp - 0xc], ecx
0081F6C9 cmp dword ptr [ebp + 8], 0
0081F6CD je 0x81f6d5
0081F6CF cmp dword ptr [ebp + 0xc], 9
0081F6D3 je 0x81f6d7
0081F6D5 jmp 0x81f70b
0081F6D7 mov eax, dword ptr [ebp + 8]
0081F6DA mov dword ptr [ebp - 4], eax
0081F6DD mov ecx, dword ptr [ebp - 4]
0081F6E0 mov edx, dword ptr [ecx + 4]
0081F6E3 push edx
0081F6E4 mov eax, dword ptr [ecx]
0081F6E6 push eax
0081F6E7 mov ecx, dword ptr [0x17c8708]
0081F6ED call 0x818c70
0081F6F2 mov dword ptr [ebp - 8], eax
0081F6F5 cmp dword ptr [ebp - 8], 0
0081F6F9 je 0x81f70b
0081F6FB mov ecx, dword ptr [ebp - 4]
0081F6FE movzx edx, byte ptr [ecx + 8]
0081F702 push edx
0081F703 mov ecx, dword ptr [ebp - 8]
0081F706 call 0x9e3ff0
0081F70B mov esp, ebp
0081F70D pop ebp
0081F70E ret 8
; range 0x9e3ff0
009E3FF0 push ebp
009E3FF1 mov ebp, esp
009E3FF3 push ecx
009E3FF4 mov dword ptr [ebp - 4], ecx
009E3FF7 cmp dword ptr [ebp + 8], 3
009E3FFB jbe 0x9e3fff
009E3FFD jmp 0x9e400b
009E3FFF mov eax, dword ptr [ebp - 4]
009E4002 mov ecx, dword ptr [ebp + 8]
009E4005 mov dword ptr [eax + 0x1b88], ecx
009E400B mov esp, ebp
009E400D pop ebp
009E400E ret 4
; Lua doubles: BE95E8=3430 BE95E0=3440 BE95D8=3450 BE95D0=3460
