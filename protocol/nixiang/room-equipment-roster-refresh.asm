; gfld.dat SHA256: 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Existing member refresh (3105), including own appearance branch.
0081F020 push ebp
0081F021 mov ebp, esp
0081F023 push -1
0081F025 push 0xadf5a0
0081F02A mov eax, dword ptr fs:[0]
0081F030 push eax
0081F031 sub esp, 0x4f8
0081F037 mov eax, dword ptr [0xc7b480]
0081F03C xor eax, ebp
0081F03E push eax
0081F03F lea eax, [ebp - 0xc]
0081F042 mov dword ptr fs:[0], eax
0081F048 mov dword ptr [ebp - 0x4f8], ecx
0081F04E mov eax, dword ptr [ebp + 8]
0081F051 mov dword ptr [ebp - 0x14], eax
0081F054 mov ecx, dword ptr [ebp - 0x14]
0081F057 movzx edx, byte ptr [ecx + 0x90]
0081F05E mov dword ptr [0x17c86d4], edx
0081F064 mov eax, dword ptr [ebp - 0x14]
0081F067 add eax, 0x95
0081F06C mov dword ptr [ebp - 0x10], eax
0081F06F mov dword ptr [ebp - 0x18], 0
0081F076 jmp 0x81f081
0081F078 mov ecx, dword ptr [ebp - 0x18]
0081F07B add ecx, 1
0081F07E mov dword ptr [ebp - 0x18], ecx
0081F081 cmp dword ptr [ebp - 0x18], 0x10
0081F085 jae 0x81f244
0081F08B lea ecx, [ebp - 0x4ec]
0081F091 call 0x561d00
0081F096 mov edx, dword ptr [ebp - 0x14]
0081F099 movzx eax, byte ptr [edx + 0x38]
0081F09D push eax
0081F09E mov ecx, dword ptr [ebp - 0x14]
0081F0A1 movzx edx, byte ptr [ecx + 0x36]
0081F0A5 push edx
0081F0A6 mov eax, dword ptr [ebp - 0x14]
0081F0A9 movzx ecx, byte ptr [eax + 0x40]
0081F0AD push ecx
0081F0AE mov edx, dword ptr [ebp - 0x10]
0081F0B1 push edx
0081F0B2 lea eax, [ebp - 0x4ec]
0081F0B8 push eax
0081F0B9 call 0xa3ecc0
0081F0BE add esp, 0x14
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
0081F0F5 mov ecx, dword ptr [0x17c86fc]
0081F0FB call 0x402aa0
0081F100 mov ecx, dword ptr [ebp - 0x14]
0081F103 mov dword ptr [ebp - 0x4fc], ecx
0081F109 mov dword ptr [ebp - 0x504], eax
0081F10F mov dword ptr [ebp - 0x500], edx
0081F115 mov edx, dword ptr [ebp - 0x4fc]
0081F11B mov eax, dword ptr [edx]
0081F11D cmp eax, dword ptr [ebp - 0x504]
0081F123 jne 0x81f136
0081F125 mov ecx, dword ptr [ebp - 0x4fc]
0081F12B mov edx, dword ptr [ecx + 4]
0081F12E cmp edx, dword ptr [ebp - 0x500]
0081F134 je 0x81f15d
0081F136 push 1
0081F138 lea eax, [ebp - 0x4ec]
0081F13E push eax
0081F13F mov ecx, dword ptr [ebp - 0x14]
0081F142 push ecx
0081F143 mov edx, dword ptr [ebp - 0x14]
0081F146 mov eax, dword ptr [edx + 4]
0081F149 push eax
0081F14A mov ecx, dword ptr [edx]
0081F14C push ecx
0081F14D mov ecx, dword ptr [0x17c8708]
0081F153 call 0x81cf10
0081F158 jmp 0x81f216
0081F15D mov edx, dword ptr [ebp - 0x14]
0081F160 mov eax, dword ptr [edx + 4]
0081F163 push eax
0081F164 mov ecx, dword ptr [edx]
0081F166 push ecx
0081F167 mov ecx, dword ptr [0x17c8708]
0081F16D call 0x818c70
0081F172 mov dword ptr [ebp - 0x4f0], eax
0081F178 cmp dword ptr [ebp - 0x4f0], 0
0081F17F je 0x81f216
0081F185 mov edx, dword ptr [ebp - 0x14]
0081F188 mov eax, dword ptr [edx + 0x91]
0081F18E push eax
0081F18F mov ecx, dword ptr [ebp - 0x4f0]
0081F195 call 0x54ab50
0081F19A cmp dword ptr [0x17c86d4], 0
0081F1A1 setne cl
0081F1A4 movzx edx, cl
0081F1A7 push edx
0081F1A8 mov ecx, dword ptr [ebp - 0x4f0]
0081F1AE call 0x5118e0
0081F1B3 mov eax, dword ptr [ebp - 0x14]
0081F1B6 add eax, 0x4e
0081F1B9 push eax
0081F1BA lea ecx, [ebp - 0x4f4]
0081F1C0 call 0x405fd0
0081F1C5 mov dword ptr [ebp - 4], 0
0081F1CC lea ecx, [ebp - 0x4f4]
0081F1D2 push ecx
0081F1D3 mov ecx, dword ptr [ebp - 0x4f0]
0081F1D9 call 0x54ab90
0081F1DE mov dword ptr [ebp - 4], 0xffffffff
0081F1E5 lea ecx, [ebp - 0x4f4]
0081F1EB call 0x406050
0081F1F0 mov edx, dword ptr [ebp - 0x14]
0081F1F3 mov eax, dword ptr [edx + 0x78]
0081F1F6 push eax
0081F1F7 mov ecx, dword ptr [ebp - 0x4f0]
0081F1FD call 0x54abb0
0081F202 push 0
0081F204 lea ecx, [ebp - 0x4ec]
0081F20A push ecx
0081F20B mov ecx, dword ptr [ebp - 0x4f0]
0081F211 call 0x9f3540
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
0081F244 mov eax, dword ptr [ebp - 0x4f8]
0081F24A mov edx, dword ptr [eax]
0081F24C mov ecx, dword ptr [ebp - 0x4f8]
0081F252 mov eax, dword ptr [edx + 0x10]
0081F255 call eax
0081F257 mov ecx, dword ptr [ebp - 0xc]
0081F25A mov dword ptr fs:[0], ecx
0081F261 pop ecx
0081F262 mov esp, ebp
0081F264 pop ebp
0081F265 ret 8
