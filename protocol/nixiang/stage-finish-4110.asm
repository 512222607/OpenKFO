; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Mode 21 virtual +30 at BADD44 points to 93C890.

; range 0x93c890
0093C890 push ebp
0093C891 mov ebp, esp
0093C893 sub esp, 0x2c
0093C896 mov dword ptr [ebp - 0x1c], ecx
0093C899 mov ecx, dword ptr [0x17c8710]
0093C89F call 0x453b80
0093C8A4 test eax, eax
0093C8A6 je 0x93c8c6
0093C8A8 push ecx
0093C8A9 fldz
0093C8AB fstp dword ptr [esp]
0093C8AE push 0
0093C8B0 mov ecx, dword ptr [ebp - 0x1c]
0093C8B3 call 0x4b4f50
0093C8B8 mov ecx, eax
0093C8BA call 0x96c810
0093C8BF mov al, 1
0093C8C1 jmp 0x93cad6
0093C8C6 xor eax, eax
0093C8C8 mov word ptr [ebp - 8], ax
0093C8CC mov dword ptr [ebp - 4], 0
0093C8D3 push ecx
0093C8D4 fldz
0093C8D6 fstp dword ptr [esp]
0093C8D9 push 0
0093C8DB mov ecx, dword ptr [ebp - 0x1c]
0093C8DE call 0x4b4f50
0093C8E3 mov ecx, eax
0093C8E5 call 0x96c810
0093C8EA call 0x94bf10
0093C8EF mov ecx, eax
0093C8F1 call 0x94bc50
0093C8F6 test eax, eax
0093C8F8 jne 0x93c90f
0093C8FA mov ecx, 3
0093C8FF mov word ptr [ebp - 8], cx
0093C903 mov dword ptr [ebp - 4], 1
0093C90A jmp 0x93ca38
0093C90F mov edx, dword ptr [ebp - 0x1c]
0093C912 movzx eax, byte ptr [edx + 0x1c]
0093C916 cmp eax, 1
0093C919 jne 0x93c930
0093C91B mov ecx, 1
0093C920 mov word ptr [ebp - 8], cx
0093C924 mov dword ptr [ebp - 4], 1
0093C92B jmp 0x93ca38
0093C930 mov dword ptr [ebp - 0xc], 1
0093C937 mov dword ptr [ebp - 0x10], 0
0093C93E jmp 0x93c949
0093C940 mov edx, dword ptr [ebp - 0x10]
0093C943 add edx, 1
0093C946 mov dword ptr [ebp - 0x10], edx
0093C949 cmp dword ptr [ebp - 0x10], 8
0093C94D jae 0x93c981
0093C94F mov eax, dword ptr [ebp - 0x10]
0093C952 push eax
0093C953 mov ecx, dword ptr [0x17c8708]
0093C959 call 0x818450
0093C95E mov dword ptr [ebp - 0x14], eax
0093C961 cmp dword ptr [ebp - 0x14], 0
0093C965 je 0x93c97f
0093C967 mov ecx, dword ptr [ebp - 0x14]
0093C96A call 0x44e110
0093C96F movzx ecx, al
0093C972 test ecx, ecx
0093C974 jne 0x93c97f
0093C976 mov dword ptr [ebp - 0xc], 0
0093C97D jmp 0x93c981
0093C97F jmp 0x93c940
0093C981 cmp dword ptr [ebp - 0xc], 0
0093C985 je 0x93ca1d
0093C98B mov ecx, dword ptr [0x17c8710]
0093C991 call 0x985bd0
0093C996 mov edx, dword ptr [ebp - 0x1c]
0093C999 sub eax, dword ptr [edx + 0x104]
0093C99F mov dword ptr [ebp - 0x18], eax
0093C9A2 cmp dword ptr [ebp - 0x18], 0x2328
0093C9A9 jle 0x93c9ec
0093C9AB mov eax, 2
0093C9B0 mov word ptr [ebp - 8], ax
0093C9B4 mov dword ptr [ebp - 4], 1
0093C9BB mov ecx, 0x2328
0093C9C0 sub ecx, dword ptr [ebp - 0x18]
0093C9C3 mov dword ptr [ebp - 0x20], ecx
0093C9C6 fild dword ptr [ebp - 0x20]
0093C9C9 fmul qword ptr [0xbe8378]
0093C9CF fstp dword ptr [ebp - 0x24]
0093C9D2 fld dword ptr [ebp - 0x24]
0093C9D5 push ecx
0093C9D6 fstp dword ptr [esp]
0093C9D9 push 0
0093C9DB mov ecx, dword ptr [ebp - 0x1c]
0093C9DE call 0x4b4f50
0093C9E3 mov ecx, eax
0093C9E5 call 0x96c810
0093C9EA jmp 0x93ca1b
0093C9EC mov edx, 0x2328
0093C9F1 sub edx, dword ptr [ebp - 0x18]
0093C9F4 mov dword ptr [ebp - 0x28], edx
0093C9F7 fild dword ptr [ebp - 0x28]
0093C9FA fmul qword ptr [0xbe8378]
0093CA00 fstp dword ptr [ebp - 0x2c]
0093CA03 fld dword ptr [ebp - 0x2c]
0093CA06 push ecx
0093CA07 fstp dword ptr [esp]
0093CA0A push 1
0093CA0C mov ecx, dword ptr [ebp - 0x1c]
0093CA0F call 0x4b4f50
0093CA14 mov ecx, eax
0093CA16 call 0x96c810
0093CA1B jmp 0x93ca38
0093CA1D mov ecx, dword ptr [0x17c8710]
0093CA23 call 0x985bd0
0093CA28 mov ecx, dword ptr [ebp - 0x1c]
0093CA2B mov dword ptr [ecx + 0x104], eax
0093CA31 mov dword ptr [ebp - 4], 0
0093CA38 cmp dword ptr [ebp - 4], 0
0093CA3C je 0x93cacf
0093CA42 mov ecx, dword ptr [0x17c8708]
0093CA48 call 0x819120
0093CA4D test eax, eax
0093CA4F je 0x93ca77
0093CA51 mov ecx, dword ptr [0x17c8708]
0093CA57 call 0x819120
0093CA5C mov ecx, eax
0093CA5E call 0x44b3f0
0093CA63 test eax, eax
0093CA65 je 0x93ca77
0093CA67 movzx edx, word ptr [ebp - 8]
0093CA6B push edx
0093CA6C mov ecx, dword ptr [0x17c8710]
0093CA72 call 0x987e40
0093CA77 mov eax, dword ptr [ebp - 0x1c]
0093CA7A mov edx, dword ptr [eax]
0093CA7C mov ecx, dword ptr [ebp - 0x1c]
0093CA7F mov eax, dword ptr [edx + 0x2c]
0093CA82 call eax
0093CA84 mov ecx, dword ptr [ebp - 0x1c]
0093CA87 mov edx, dword ptr [ecx]
0093CA89 mov ecx, dword ptr [ebp - 0x1c]
0093CA8C mov eax, dword ptr [edx + 0x34]
0093CA8F call eax
0093CA91 mov ecx, dword ptr [0x17c8690]
0093CA97 push ecx
0093CA98 mov ecx, dword ptr [0x17c86fc]
0093CA9E call 0x4b1000
0093CAA3 push ecx
0093CAA4 fldz
0093CAA6 fstp dword ptr [esp]
0093CAA9 push 0
0093CAAB mov ecx, dword ptr [ebp - 0x1c]
0093CAAE call 0x4b4f50
0093CAB3 mov ecx, eax
0093CAB5 call 0x96c810
0093CABA push 0
0093CABC push 0
0093CABE push 0
0093CAC0 mov ecx, dword ptr [ebp - 0x1c]
0093CAC3 call 0x4b4f50
0093CAC8 mov ecx, eax
0093CACA call 0x973390
0093CACF cmp dword ptr [ebp - 4], 0
0093CAD3 setne al
0093CAD6 mov esp, ebp
0093CAD8 pop ebp
0093CAD9 ret

; range 0x44e110
0044E110 push ebp
0044E111 mov ebp, esp
0044E113 push ecx
0044E114 mov dword ptr [ebp - 4], ecx
0044E117 mov eax, dword ptr [ebp - 4]
0044E11A mov al, byte ptr [eax + 0x1b78]
0044E120 mov esp, ebp
0044E122 pop ebp
0044E123 ret

; range 0x94bc50
0094BC50 push ebp
0094BC51 mov ebp, esp
0094BC53 push ecx
0094BC54 mov dword ptr [ebp - 4], ecx
0094BC57 mov eax, dword ptr [ebp - 4]
0094BC5A mov eax, dword ptr [eax + 0x20]
0094BC5D mov esp, ebp
0094BC5F pop ebp
0094BC60 ret
