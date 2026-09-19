; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; function 0x82A820
0082A820 push ebp
0082A821 mov ebp, esp
0082A823 sub esp, 0xc
0082A826 mov dword ptr [ebp - 0xc], ecx
0082A829 cmp dword ptr [ebp + 8], 0
0082A82D je 0x82a835
0082A82F cmp dword ptr [ebp + 0xc], 0x28
0082A833 je 0x82a837
0082A835 jmp 0x82a89c
0082A837 mov eax, dword ptr [ebp + 8]
0082A83A mov dword ptr [ebp - 4], eax
0082A83D mov ecx, dword ptr [0x17c8708]
0082A843 call 0x4535c0
0082A848 cmp eax, 0x15
0082A84B jne 0x82a89c
0082A84D push 0
0082A84F push 0x12f90d0
0082A854 push 0x12f899c
0082A859 mov ecx, dword ptr [0x17c8710]
0082A85F call 0x453db0
0082A864 push 0
0082A866 push eax
0082A867 call 0xa97b0e
0082A86C add esp, 0x14
0082A86F mov dword ptr [ebp - 8], eax
0082A872 cmp dword ptr [ebp - 8], 0
0082A876 jne 0x82a87a
0082A878 jmp 0x82a89c
0082A87A mov ecx, dword ptr [ebp - 4]
0082A87D cmp dword ptr [ecx + 8], -1
0082A881 jne 0x82a88d
0082A883 mov ecx, dword ptr [ebp - 8]
0082A886 call 0x93bc60
0082A88B jmp 0x82a89c
0082A88D mov edx, dword ptr [ebp - 4]
0082A890 mov eax, dword ptr [edx + 8]
0082A893 push eax
0082A894 mov ecx, dword ptr [ebp - 8]
0082A897 call 0x93a530
0082A89C mov esp, ebp
0082A89E pop ebp
0082A89F ret 8

; function 0x93BC60
0093BC60 push ebp
0093BC61 mov ebp, esp
0093BC63 sub esp, 0x34
0093BC66 mov dword ptr [ebp - 0x34], ecx
0093BC69 mov eax, dword ptr [ebp - 0x34]
0093BC6C movzx ecx, byte ptr [eax + 0x1c]
0093BC70 test ecx, ecx
0093BC72 je 0x93bc76
0093BC74 jmp 0x93bcba
0093BC76 mov edx, dword ptr [ebp - 0x34]
0093BC79 mov byte ptr [edx + 0x1c], 1
0093BC7D push 0x2f
0093BC7F push 0
0093BC81 lea eax, [ebp - 0x30]
0093BC84 push eax
0093BC85 call 0x666960
0093BC8A add esp, 0xc
0093BC8D mov ecx, dword ptr [0x17c8708]
0093BC93 call 0x432440
0093BC98 mov ecx, dword ptr [eax]
0093BC9A mov edx, dword ptr [eax + 4]
0093BC9D mov dword ptr [ebp - 9], ecx
0093BCA0 mov dword ptr [ebp - 5], edx
0093BCA3 push 0
0093BCA5 push 0
0093BCA7 push 0x2f
0093BCA9 lea eax, [ebp - 0x30]
0093BCAC push eax
0093BCAD push 0x4fb7
0093BCB2 call 0xa3fbb0
0093BCB7 add esp, 0x14
0093BCBA mov esp, ebp
0093BCBC pop ebp
0093BCBD ret

; function 0xA3FBB0
00A3FBB0 push ebp
00A3FBB1 mov ebp, esp
00A3FBB3 push ecx
00A3FBB4 mov eax, dword ptr [ebp + 0xc]
00A3FBB7 mov dword ptr [ebp - 4], eax
00A3FBBA mov ecx, dword ptr [ebp - 4]
00A3FBBD mov byte ptr [ecx + 0xd], 1
00A3FBC1 mov edx, dword ptr [ebp - 4]
00A3FBC4 mov eax, dword ptr [ebp + 8]
00A3FBC7 mov dword ptr [edx], eax
00A3FBC9 mov ecx, dword ptr [0x17c86fc]
00A3FBCF call 0x402aa0
00A3FBD4 mov ecx, dword ptr [ebp - 4]
00A3FBD7 mov dword ptr [ecx + 4], eax
00A3FBDA mov dword ptr [ecx + 8], edx
00A3FBDD mov edx, dword ptr [ebp - 4]
00A3FBE0 mov eax, dword ptr [ebp + 0x14]
00A3FBE3 mov dword ptr [edx + 0x1f], eax
00A3FBE6 mov ecx, dword ptr [ebp + 0x18]
00A3FBE9 mov dword ptr [edx + 0x23], ecx
00A3FBEC mov edx, dword ptr [ebp - 4]
00A3FBEF mov byte ptr [edx + 0xc], 1
00A3FBF3 mov ecx, dword ptr [0x17c8710]
00A3FBF9 call 0x985bd0
00A3FBFE mov ecx, dword ptr [ebp - 4]
00A3FC01 mov dword ptr [ecx + 0x17], eax
00A3FC04 push 0
00A3FC06 mov edx, dword ptr [ebp + 0x10]
00A3FC09 push edx
00A3FC0A mov eax, dword ptr [ebp + 0xc]
00A3FC0D push eax
00A3FC0E call 0x7d0eb0
00A3FC13 mov ecx, eax
00A3FC15 call 0x7d1730
00A3FC1A mov esp, ebp
00A3FC1C pop ebp
00A3FC1D ret

; function 0x432440
00432440 push ebp
00432441 mov ebp, esp
00432443 push ecx
00432444 mov dword ptr [ebp - 4], ecx
00432447 mov eax, dword ptr [ebp - 4]
0043244A add eax, 0x311
0043244F mov esp, ebp
00432451 pop ebp
00432452 ret
