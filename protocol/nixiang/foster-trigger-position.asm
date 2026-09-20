; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Player position accessor and absolute-position consumer for 8120 +51.
; range 0x9e42e0
009E42E0 push ebp
009E42E1 mov ebp, esp
009E42E3 push ecx
009E42E4 mov dword ptr [ebp - 4], ecx
009E42E7 mov eax, dword ptr [ebp - 4]
009E42EA add eax, 0xd10
009E42EF mov esp, ebp
009E42F1 pop ebp
009E42F2 ret
; range 0x7d16b4
007D16B4 mov eax, dword ptr [ebp - 0x34]
007D16B7 mov ecx, dword ptr [eax + 0x78]
007D16BA call 0x9e42e0
007D16BF mov ecx, dword ptr [ebp + 8]
007D16C2 add ecx, 0x33
007D16C5 mov edx, dword ptr [eax]
007D16C7 mov dword ptr [ecx], edx
007D16C9 mov edx, dword ptr [eax + 4]
007D16CC mov dword ptr [ecx + 4], edx
007D16CF mov eax, dword ptr [eax + 8]
007D16D2 mov dword ptr [ecx + 8], eax
; range 0x82b7a6
0082B7A6 push 0
0082B7A8 push 1
0082B7AA mov eax, dword ptr [ebp - 8]
0082B7AD add eax, 0x33
0082B7B0 sub esp, 0xc
0082B7B3 mov ecx, esp
0082B7B5 mov edx, dword ptr [eax]
0082B7B7 mov dword ptr [ecx], edx
0082B7B9 mov edx, dword ptr [eax + 4]
0082B7BC mov dword ptr [ecx + 4], edx
0082B7BF mov eax, dword ptr [eax + 8]
0082B7C2 mov dword ptr [ecx + 8], eax
0082B7C5 mov ecx, dword ptr [ebp - 0x10]
0082B7C8 call 0x9e9d10
; range 0x9e9f1d
009E9F1D cmp dword ptr [ebp + 0x14], 0
009E9F21 jne 0x9e9f68
009E9F23 mov eax, dword ptr [ebp - 0x40]
009E9F26 fld dword ptr [eax + 0xd10]
009E9F2C fadd dword ptr [ebp + 8]
009E9F2F mov ecx, dword ptr [ebp - 0x40]
009E9F32 fstp dword ptr [ecx + 0xd10]
009E9F38 mov edx, dword ptr [ebp - 0x40]
009E9F3B fld dword ptr [edx + 0xd14]
009E9F41 fadd dword ptr [ebp + 0xc]
009E9F44 mov eax, dword ptr [ebp - 0x40]
009E9F47 fstp dword ptr [eax + 0xd14]
009E9F4D mov ecx, dword ptr [ebp - 0x40]
009E9F50 fld dword ptr [ecx + 0xd18]
009E9F56 fadd dword ptr [ebp + 0x10]
009E9F59 mov edx, dword ptr [ebp - 0x40]
009E9F5C fstp dword ptr [edx + 0xd18]
009E9F62 xor eax, eax
009E9F64 jne 0x9e9f23
009E9F66 jmp 0x9e9f82
009E9F68 mov ecx, dword ptr [ebp - 0x40]
009E9F6B add ecx, 0xd10
009E9F71 mov edx, dword ptr [ebp + 8]
009E9F74 mov dword ptr [ecx], edx
009E9F76 mov eax, dword ptr [ebp + 0xc]
009E9F79 mov dword ptr [ecx + 4], eax
009E9F7C mov edx, dword ptr [ebp + 0x10]
009E9F7F mov dword ptr [ecx + 8], edx
