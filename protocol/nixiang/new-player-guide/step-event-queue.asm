; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Read-only bounded extraction; virtual/unseen callbacks not claimed complete
; RANGE 0096A1A0-0096A301
0096A1A0 push ebp
0096A1A1 mov ebp, esp
0096A1A3 push ecx
0096A1A4 mov dword ptr [ebp - 4], ecx
0096A1A7 mov eax, dword ptr [ebp + 8]
0096A1AA push eax
0096A1AB mov ecx, dword ptr [ebp - 4]
0096A1AE mov ecx, dword ptr [ecx + 0x14]
0096A1B1 call 0x4c52d0
0096A1B6 mov esp, ebp
0096A1B8 pop ebp
0096A1B9 ret 4
0096A1BC int3
0096A1BD int3
0096A1BE int3
0096A1BF int3
0096A1C0 push ebp
0096A1C1 mov ebp, esp
0096A1C3 push ecx
0096A1C4 mov dword ptr [ebp - 4], ecx
0096A1C7 push 0x1b
0096A1C9 mov ecx, dword ptr [ebp - 4]
0096A1CC call 0x96a1a0
0096A1D1 mov esp, ebp
0096A1D3 pop ebp
0096A1D4 ret
0096A1D5 int3
0096A1D6 int3
0096A1D7 int3
0096A1D8 int3
0096A1D9 int3
0096A1DA int3
0096A1DB int3
0096A1DC int3
0096A1DD int3
0096A1DE int3
0096A1DF int3
0096A1E0 push ebp
0096A1E1 mov ebp, esp
0096A1E3 push ecx
0096A1E4 mov dword ptr [ebp - 4], ecx
0096A1E7 mov ecx, dword ptr [ebp + 8]
0096A1EA call 0x462480
0096A1EF add eax, 0x14
0096A1F2 cmp eax, 0x15
0096A1F5 jb 0x96a21b
0096A1F7 mov ecx, dword ptr [ebp + 8]
0096A1FA call 0x462480
0096A1FF add eax, 0x14
0096A202 cmp eax, 0x18
0096A205 ja 0x96a21b
0096A207 mov ecx, dword ptr [ebp + 8]
0096A20A call 0x462480
0096A20F add eax, 0x14
0096A212 push eax
0096A213 mov ecx, dword ptr [ebp - 4]
0096A216 call 0x96a1a0
0096A21B mov esp, ebp
0096A21D pop ebp
0096A21E ret 4
0096A221 int3
0096A222 int3
0096A223 int3
0096A224 int3
0096A225 int3
0096A226 int3
0096A227 int3
0096A228 int3
0096A229 int3
0096A22A int3
0096A22B int3
0096A22C int3
0096A22D int3
0096A22E int3
0096A22F int3
0096A230 push ebp
0096A231 mov ebp, esp
0096A233 push ecx
0096A234 mov dword ptr [ebp - 4], ecx
0096A237 mov ecx, dword ptr [ebp + 8]
0096A23A call 0x462480
0096A23F add eax, 0x14
0096A242 cmp eax, 0x15
0096A245 jb 0x96a26b
0096A247 mov ecx, dword ptr [ebp + 8]
0096A24A call 0x462480
0096A24F add eax, 0x14
0096A252 cmp eax, 0x18
0096A255 ja 0x96a26b
0096A257 mov ecx, dword ptr [ebp + 8]
0096A25A call 0x462480
0096A25F add eax, 0x14
0096A262 push eax
0096A263 mov ecx, dword ptr [ebp - 4]
0096A266 call 0x96a1a0
0096A26B mov esp, ebp
0096A26D pop ebp
0096A26E ret 4
0096A271 int3
0096A272 int3
0096A273 int3
0096A274 int3
0096A275 int3
0096A276 int3
0096A277 int3
0096A278 int3
0096A279 int3
0096A27A int3
0096A27B int3
0096A27C int3
0096A27D int3
0096A27E int3
0096A27F int3
0096A280 push ebp
0096A281 mov ebp, esp
0096A283 push ecx
0096A284 mov dword ptr [ebp - 4], ecx
0096A287 mov eax, dword ptr [ebp + 0xc]
0096A28A cmp dword ptr [eax + 0x58], 0
0096A28E jl 0x96a2a8
0096A290 mov ecx, dword ptr [ebp + 0xc]
0096A293 cmp dword ptr [ecx + 0x58], 6
0096A297 jg 0x96a2a8
0096A299 mov edx, dword ptr [ebp + 0xc]
0096A29C mov eax, dword ptr [edx + 0x58]
0096A29F push eax
0096A2A0 mov ecx, dword ptr [ebp - 4]
0096A2A3 call 0x96a1a0
0096A2A8 mov esp, ebp
0096A2AA pop ebp
0096A2AB ret 8
0096A2AE int3
0096A2AF int3
0096A2B0 push ebp
0096A2B1 mov ebp, esp
0096A2B3 push ecx
0096A2B4 mov dword ptr [ebp - 4], ecx
0096A2B7 mov ecx, dword ptr [0x17c8708]
0096A2BD call 0x819120
0096A2C2 test eax, eax
0096A2C4 je 0x96a2ee
0096A2C6 mov ecx, dword ptr [0x17c8708]
0096A2CC call 0x819120
0096A2D1 mov ecx, eax
0096A2D3 call 0x4536e0
0096A2D8 cmp eax, 2
0096A2DB jne 0x96a2ee
0096A2DD push 0
0096A2DF push 0x101c
0096A2E4 call 0xa3ca00
0096A2E9 add esp, 8
0096A2EC jmp 0x96a2fd
0096A2EE push 0
0096A2F0 push 0xc26
0096A2F5 call 0xa3ca00
0096A2FA add esp, 8
0096A2FD mov esp, ebp
0096A2FF pop ebp
0096A300 ret
; RANGE 0096AB90-0096ABE8
0096AB90 push ebp
0096AB91 mov ebp, esp
0096AB93 push ecx
0096AB94 mov dword ptr [ebp - 4], ecx
0096AB97 mov ecx, dword ptr [0x17c8708]
0096AB9D call 0x819120
0096ABA2 test eax, eax
0096ABA4 je 0x96abcd
0096ABA6 push 1
0096ABA8 mov ecx, dword ptr [0x17c8708]
0096ABAE call 0x819120
0096ABB3 push eax
0096ABB4 mov ecx, dword ptr [0x17c8708]
0096ABBA call 0x819120
0096ABBF mov ecx, eax
0096ABC1 call 0x401040
0096ABC6 mov ecx, eax
0096ABC8 call 0x9de260
0096ABCD push 0
0096ABCF mov eax, dword ptr [ebp - 4]
0096ABD2 mov ecx, dword ptr [eax + 0x10]
0096ABD5 call 0x96b080
0096ABDA push 0xa
0096ABDC mov ecx, dword ptr [ebp - 4]
0096ABDF call 0x96a1a0
0096ABE4 mov esp, ebp
0096ABE6 pop ebp
0096ABE7 ret
; RANGE 004C52D0-004C52EA
004C52D0 push ebp
004C52D1 mov ebp, esp
004C52D3 push ecx
004C52D4 mov dword ptr [ebp - 4], ecx
004C52D7 lea eax, [ebp + 8]
004C52DA push eax
004C52DB mov ecx, dword ptr [ebp - 4]
004C52DE add ecx, 0x1c
004C52E1 call 0x45c6b0
004C52E6 mov esp, ebp
004C52E8 pop ebp
; RANGE 0045C6B0-0045C789
0045C6B0 push ebp
0045C6B1 mov ebp, esp
0045C6B3 sub esp, 0xc
0045C6B6 push esi
0045C6B7 mov dword ptr [ebp - 0xc], ecx
0045C6BA mov eax, dword ptr [ebp - 0xc]
0045C6BD mov eax, dword ptr [eax + 0x18]
0045C6C0 mov ecx, dword ptr [ebp - 0xc]
0045C6C3 add eax, dword ptr [ecx + 0x1c]
0045C6C6 xor edx, edx
0045C6C8 mov ecx, 4
0045C6CD div ecx
0045C6CF test edx, edx
0045C6D1 jne 0x45c6f1
0045C6D3 mov edx, dword ptr [ebp - 0xc]
0045C6D6 mov eax, dword ptr [edx + 0x1c]
0045C6D9 add eax, 4
0045C6DC shr eax, 2
0045C6DF mov ecx, dword ptr [ebp - 0xc]
0045C6E2 cmp dword ptr [ecx + 0x14], eax
0045C6E5 ja 0x45c6f1
0045C6E7 push 1
0045C6E9 mov ecx, dword ptr [ebp - 0xc]
0045C6EC call 0x45c790
0045C6F1 mov edx, dword ptr [ebp - 0xc]
0045C6F4 mov eax, dword ptr [edx + 0x18]
0045C6F7 mov ecx, dword ptr [ebp - 0xc]
0045C6FA add eax, dword ptr [ecx + 0x1c]
0045C6FD mov dword ptr [ebp - 4], eax
0045C700 mov edx, dword ptr [ebp - 4]
0045C703 shr edx, 2
0045C706 mov dword ptr [ebp - 8], edx
0045C709 mov eax, dword ptr [ebp - 0xc]
0045C70C mov ecx, dword ptr [eax + 0x14]
0045C70F cmp ecx, dword ptr [ebp - 8]
0045C712 ja 0x45c720
0045C714 mov edx, dword ptr [ebp - 0xc]
0045C717 mov eax, dword ptr [ebp - 8]
0045C71A sub eax, dword ptr [edx + 0x14]
0045C71D mov dword ptr [ebp - 8], eax
0045C720 mov ecx, dword ptr [ebp - 0xc]
0045C723 mov edx, dword ptr [ecx + 0x10]
0045C726 mov eax, dword ptr [ebp - 8]
0045C729 cmp dword ptr [edx + eax*4], 0
0045C72D jne 0x45c748
0045C72F push 4
0045C731 mov ecx, dword ptr [ebp - 0xc]
0045C734 add ecx, 0xc
0045C737 call 0x493650
0045C73C mov ecx, dword ptr [ebp - 0xc]
0045C73F mov edx, dword ptr [ecx + 0x10]
0045C742 mov ecx, dword ptr [ebp - 8]
0045C745 mov dword ptr [edx + ecx*4], eax
0045C748 mov edx, dword ptr [ebp + 8]
0045C74B push edx
0045C74C mov eax, dword ptr [ebp - 0xc]
0045C74F mov ecx, dword ptr [eax + 0x10]
0045C752 mov eax, dword ptr [ebp - 4]
0045C755 xor edx, edx
0045C757 mov esi, 4
0045C75C div esi
0045C75E mov eax, dword ptr [ebp - 8]
0045C761 mov ecx, dword ptr [ecx + eax*4]
0045C764 lea edx, [ecx + edx*4]
0045C767 push edx
0045C768 mov ecx, dword ptr [ebp - 0xc]
0045C76B add ecx, 0xc
0045C76E call 0x4e5b90
0045C773 mov eax, dword ptr [ebp - 0xc]
0045C776 mov ecx, dword ptr [eax + 0x1c]
0045C779 add ecx, 1
0045C77C mov edx, dword ptr [ebp - 0xc]
0045C77F mov dword ptr [edx + 0x1c], ecx
0045C782 pop esi
0045C783 mov esp, ebp
0045C785 pop ebp
0045C786 ret 4
