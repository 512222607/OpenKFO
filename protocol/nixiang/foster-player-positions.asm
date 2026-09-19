; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 20405 is 183B = 39-byte envelope + six 24-byte records.
; 98D6E9 calls producer before 98D6F5 sends 4160.
; range 0x941a90
00941A90 push ebp
00941A91 mov ebp, esp
00941A93 sub esp, 0xe0
00941A99 push esi
00941A9A push edi
00941A9B mov dword ptr [ebp - 0xe0], ecx
00941AA1 mov ecx, dword ptr [ebp - 0xe0]
00941AA7 add ecx, 0x80
00941AAD call 0x5361a0
00941AB2 test eax, eax
00941AB4 jne 0x941abd
00941AB6 xor al, al
00941AB8 jmp 0x941c5e
00941ABD push 0x90
00941AC2 push 0
00941AC4 lea eax, [ebp - 0x99]
00941ACA push eax
00941ACB call 0x666960
00941AD0 add esp, 0xc
00941AD3 mov dword ptr [ebp - 4], 0
00941ADA lea ecx, [ebp - 0xd4]
00941AE0 push ecx
00941AE1 mov ecx, dword ptr [ebp - 0xe0]
00941AE7 add ecx, 0x1c
00941AEA call 0x5504a0
00941AEF mov edx, dword ptr [eax]
00941AF1 mov eax, dword ptr [eax + 4]
00941AF4 mov dword ptr [ebp - 0xc8], edx
00941AFA mov dword ptr [ebp - 0xc4], eax
00941B00 jmp 0x941b16
00941B02 lea ecx, [ebp - 0xc8]
00941B08 call 0x4d4b60
00941B0D mov ecx, dword ptr [ebp - 4]
00941B10 add ecx, 1
00941B13 mov dword ptr [ebp - 4], ecx
00941B16 lea edx, [ebp - 0xdc]
00941B1C push edx
00941B1D mov ecx, dword ptr [ebp - 0xe0]
00941B23 add ecx, 0x1c
00941B26 call 0x45abb0
00941B2B push eax
00941B2C lea ecx, [ebp - 0xc8]
00941B32 call 0x4ab8f0
00941B37 movzx eax, al
00941B3A test eax, eax
00941B3C je 0x941c3f
00941B42 mov ecx, dword ptr [ebp - 0xe0]
00941B48 add ecx, 0x80
00941B4E call 0x5361a0
00941B53 cmp eax, dword ptr [ebp - 4]
00941B56 jbe 0x941c3f
00941B5C lea ecx, [ebp - 0xc8]
00941B62 call 0x4822d0
00941B67 mov ecx, dword ptr [eax + 4]
00941B6A push ecx
00941B6B mov ecx, dword ptr [0x17c8708]
00941B71 call 0x818450
00941B76 mov dword ptr [ebp - 0xcc], eax
00941B7C cmp dword ptr [ebp - 0xcc], 0
00941B83 je 0x941c3a
00941B89 mov ecx, dword ptr [ebp - 0xcc]
00941B8F call 0x401000
00941B94 mov esi, eax
00941B96 mov edi, edx
00941B98 mov edx, dword ptr [ebp - 4]
00941B9B push edx
00941B9C mov ecx, dword ptr [ebp - 0xe0]
00941BA2 add ecx, 0x80
00941BA8 call 0x5737c0
00941BAD mov dword ptr [eax], esi
00941BAF mov dword ptr [eax + 4], edi
00941BB2 mov eax, dword ptr [ebp - 4]
00941BB5 push eax
00941BB6 mov ecx, dword ptr [ebp - 0xe0]
00941BBC add ecx, 0x80
00941BC2 call 0x5737c0
00941BC7 mov ecx, dword ptr [ebp - 4]
00941BCA imul ecx, ecx, 0x18
00941BCD mov edx, dword ptr [eax]
00941BCF mov dword ptr [ebp + ecx - 0x99], edx
00941BD6 mov eax, dword ptr [eax + 4]
00941BD9 mov dword ptr [ebp + ecx - 0x95], eax
00941BE0 mov ecx, dword ptr [ebp - 4]
00941BE3 push ecx
00941BE4 mov ecx, dword ptr [ebp - 0xe0]
00941BEA add ecx, 0x80
00941BF0 call 0x5737c0
00941BF5 add eax, 0xc
00941BF8 mov edx, dword ptr [ebp - 4]
00941BFB imul edx, edx, 0x18
00941BFE lea ecx, [ebp + edx - 0x91]
00941C05 mov edx, dword ptr [eax]
00941C07 mov dword ptr [ecx], edx
00941C09 mov edx, dword ptr [eax + 4]
00941C0C mov dword ptr [ecx + 4], edx
00941C0F mov eax, dword ptr [eax + 8]
00941C12 mov dword ptr [ecx + 8], eax
00941C15 mov ecx, dword ptr [ebp - 4]
00941C18 push ecx
00941C19 mov ecx, dword ptr [ebp - 0xe0]
00941C1F add ecx, 0x80
00941C25 call 0x5737c0
00941C2A mov edx, dword ptr [ebp - 4]
00941C2D imul edx, edx, 0x18
00941C30 mov eax, dword ptr [eax + 8]
00941C33 mov dword ptr [ebp + edx - 0x85], eax
00941C3A jmp 0x941b02
00941C3F push 0
00941C41 push 0
00941C43 push 0xb7
00941C48 lea ecx, [ebp - 0xc0]
00941C4E push ecx
00941C4F push 0x4fb5
00941C54 call 0xa3fbb0
00941C59 add esp, 0x14
00941C5C mov al, 1
00941C5E pop edi
00941C5F pop esi
00941C60 mov esp, ebp
00941C62 pop ebp
00941C63 ret
; range 0x827780
00827780 push ebp
00827781 mov ebp, esp
00827783 sub esp, 0xa0
00827789 push esi
0082778A mov dword ptr [ebp - 0xa0], ecx
00827790 cmp dword ptr [ebp + 8], 0
00827794 je 0x82779f
00827796 cmp dword ptr [ebp + 0xc], 0xb7
0082779D je 0x8277a4
0082779F jmp 0x827898
008277A4 mov eax, dword ptr [ebp + 8]
008277A7 mov dword ptr [ebp - 8], eax
008277AA push 0
008277AC push 0x12f8fe8
008277B1 push 0x12f899c
008277B6 mov ecx, dword ptr [0x17c8710]
008277BC call 0x453db0
008277C1 push 0
008277C3 push eax
008277C4 call 0xa97b0e
008277C9 add esp, 0x14
008277CC mov dword ptr [ebp - 4], eax
008277CF cmp dword ptr [ebp - 4], 0
008277D3 je 0x827898
008277D9 mov dword ptr [ebp - 0x9c], 0
008277E3 jmp 0x8277f4
008277E5 mov ecx, dword ptr [ebp - 0x9c]
008277EB add ecx, 1
008277EE mov dword ptr [ebp - 0x9c], ecx
008277F4 cmp dword ptr [ebp - 0x9c], 6
008277FB jge 0x827881
00827801 mov edx, dword ptr [ebp - 0x9c]
00827807 imul edx, edx, 0x18
0082780A mov eax, dword ptr [ebp - 0x9c]
00827810 imul eax, eax, 0x18
00827813 mov ecx, dword ptr [ebp - 8]
00827816 mov esi, dword ptr [ecx + edx + 0x27]
0082781A mov dword ptr [ebp + eax - 0x98], esi
00827821 mov edx, dword ptr [ecx + edx + 0x2b]
00827825 mov dword ptr [ebp + eax - 0x94], edx
0082782C mov eax, dword ptr [ebp - 0x9c]
00827832 imul eax, eax, 0x18
00827835 mov ecx, dword ptr [ebp - 0x9c]
0082783B imul ecx, ecx, 0x18
0082783E mov edx, dword ptr [ebp - 8]
00827841 mov eax, dword ptr [edx + eax + 0x3b]
00827845 mov dword ptr [ebp + ecx - 0x90], eax
0082784C mov ecx, dword ptr [ebp - 0x9c]
00827852 imul ecx, ecx, 0x18
00827855 mov edx, dword ptr [ebp - 8]
00827858 lea eax, [edx + ecx + 0x2f]
0082785C mov ecx, dword ptr [ebp - 0x9c]
00827862 imul ecx, ecx, 0x18
00827865 lea edx, [ebp + ecx - 0x8c]
0082786C mov ecx, dword ptr [eax]
0082786E mov dword ptr [edx], ecx
00827870 mov ecx, dword ptr [eax + 4]
00827873 mov dword ptr [edx + 4], ecx
00827876 mov eax, dword ptr [eax + 8]
00827879 mov dword ptr [edx + 8], eax
0082787C jmp 0x8277e5
00827881 lea ecx, [ebp - 0x98]
00827887 push ecx
00827888 mov edx, dword ptr [ebp - 4]
0082788B mov eax, dword ptr [edx]
0082788D mov ecx, dword ptr [ebp - 4]
00827890 mov edx, dword ptr [eax + 0x11c]
00827896 call edx
00827898 pop esi
00827899 mov esp, ebp
0082789B pop ebp
0082789C ret 8
; range 0x98d694
0098D694 cmp dword ptr [0x17c8708], 0
0098D69B je 0x98d6ee
0098D69D mov ecx, dword ptr [0x17c8708]
0098D6A3 call 0x819120
0098D6A8 test eax, eax
0098D6AA je 0x98d6ee
0098D6AC mov ecx, dword ptr [0x17c8708]
0098D6B2 call 0x819120
0098D6B7 mov ecx, eax
0098D6B9 call 0x44b3f0
0098D6BE test eax, eax
0098D6C0 je 0x98d6ee
0098D6C2 mov ecx, dword ptr [0x17c8708]
0098D6C8 call 0x4535c0
0098D6CD cmp eax, 0xa
0098D6D0 jne 0x98d6ee
0098D6D2 mov ecx, dword ptr [0x17c8710]
0098D6D8 call 0x453db0
0098D6DD mov dword ptr [ebp - 0x2c], eax
0098D6E0 cmp dword ptr [ebp - 0x2c], 0
0098D6E4 je 0x98d6ee
0098D6E6 mov ecx, dword ptr [ebp - 0x2c]
0098D6E9 call 0x941a90
0098D6EE push 0
0098D6F0 push 0x1040
0098D6F5 call 0xa3ca00
0098D6FA add esp, 8
