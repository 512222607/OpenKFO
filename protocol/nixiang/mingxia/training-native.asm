; Read-only source SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0x7f4730..0x7f476a
007F4730  push ebp
007F4731  mov ebp, esp
007F4733  push ecx
007F4734  mov dword ptr [ebp - 4], ecx
007F4737  push 0
007F4739  push 0x520e
007F473E  call 0xa3ca00
007F4743  add esp, 8
007F4746  mov esp, ebp
007F4748  pop ebp
007F4749  ret
007F474A  int3
007F474B  int3
007F474C  int3
007F474D  int3
007F474E  int3
007F474F  int3
007F4750  push ebp
007F4751  mov ebp, esp
007F4753  push ecx
007F4754  mov dword ptr [ebp - 4], ecx
007F4757  push 0
007F4759  push 0x520a
007F475E  call 0xa3ca00
007F4763  add esp, 8
007F4766  mov esp, ebp
007F4768  pop ebp
007F4769  ret

; range 0x881230..0x88126a
00881230  push ebp
00881231  mov ebp, esp
00881233  push ecx
00881234  mov dword ptr [ebp - 4], ecx
00881237  push 0
00881239  push 0x520e
0088123E  call 0xa3ca00
00881243  add esp, 8
00881246  mov esp, ebp
00881248  pop ebp
00881249  ret
0088124A  int3
0088124B  int3
0088124C  int3
0088124D  int3
0088124E  int3
0088124F  int3
00881250  push ebp
00881251  mov ebp, esp
00881253  push ecx
00881254  mov dword ptr [ebp - 4], ecx
00881257  push 0
00881259  push 0x520a
0088125E  call 0xa3ca00
00881263  add esp, 8
00881266  mov esp, ebp
00881268  pop ebp
00881269  ret

; range 0x7f4980..0x7f5060
007F4980  push ebp
007F4981  mov ebp, esp
007F4983  push -1
007F4985  push 0xaa95f0
007F498A  mov eax, dword ptr fs:[0]
007F4990  push eax
007F4991  sub esp, 0x23c
007F4997  mov eax, dword ptr [0xc7b480]
007F499C  xor eax, ebp
007F499E  mov dword ptr [ebp - 0x4c], eax
007F49A1  push eax
007F49A2  lea eax, [ebp - 0xc]
007F49A5  mov dword ptr fs:[0], eax
007F49AB  mov dword ptr [ebp - 0x1f8], ecx
007F49B1  call 0x7f5610
007F49B6  mov ecx, eax
007F49B8  call 0x7f5520
007F49BD  mov dword ptr [ebp - 0x28], eax
007F49C0  call 0x7f5610
007F49C5  mov ecx, eax
007F49C7  call 0x7f5500
007F49CC  mov dword ptr [ebp - 0x14], eax
007F49CF  mov eax, dword ptr [ebp - 0x28]
007F49D2  xor ecx, ecx
007F49D4  cmp dword ptr [eax + 0x1c], 0
007F49D8  sete cl
007F49DB  mov byte ptr [ebp - 0x21], cl
007F49DE  mov ecx, dword ptr [0x17c86fc]
007F49E4  call 0x402aa0
007F49E9  mov ecx, dword ptr [ebp - 0x28]
007F49EC  mov dword ptr [ebp - 0x1fc], ecx
007F49F2  mov dword ptr [ebp - 0x204], eax
007F49F8  mov dword ptr [ebp - 0x200], edx
007F49FE  mov edx, dword ptr [ebp - 0x1fc]
007F4A04  mov eax, dword ptr [edx]
007F4A06  cmp eax, dword ptr [ebp - 0x204]
007F4A0C  jne 0x7f4a1f
007F4A0E  mov ecx, dword ptr [ebp - 0x1fc]
007F4A14  mov edx, dword ptr [ecx + 4]
007F4A17  cmp edx, dword ptr [ebp - 0x200]
007F4A1D  je 0x7f4a24
007F4A1F  jmp 0x7f5032
007F4A24  mov eax, dword ptr [0xb96c90]
007F4A29  push eax
007F4A2A  lea ecx, [ebp - 0x88]
007F4A30  call 0x405650
007F4A35  mov dword ptr [ebp - 4], 0
007F4A3C  lea ecx, [ebp - 0x88]
007F4A42  push ecx
007F4A43  mov ecx, dword ptr [ebp - 0x1f8]
007F4A49  call 0x75fbf0
007F4A4E  mov dword ptr [ebp - 0x40], eax
007F4A51  mov dword ptr [ebp - 4], 0xffffffff
007F4A58  lea ecx, [ebp - 0x88]
007F4A5E  call 0x4056d0
007F4A63  cmp dword ptr [ebp - 0x40], 0
007F4A67  je 0x7f4b11
007F4A6D  mov edx, dword ptr [0xb96c90]
007F4A73  push edx
007F4A74  lea ecx, [ebp - 0xa4]
007F4A7A  call 0x405650
007F4A7F  mov dword ptr [ebp - 4], 1
007F4A86  lea eax, [ebp - 0xa4]
007F4A8C  push eax
007F4A8D  mov ecx, dword ptr [ebp - 0x1f8]
007F4A93  call 0x75fbf0
007F4A98  mov dword ptr [ebp - 0x44], eax
007F4A9B  mov dword ptr [ebp - 4], 0xffffffff
007F4AA2  lea ecx, [ebp - 0xa4]
007F4AA8  call 0x4056d0
007F4AAD  cmp dword ptr [ebp - 0x44], 0
007F4AB1  je 0x7f4b11
007F4AB3  mov ecx, dword ptr [ebp - 0x28]
007F4AB6  mov edx, dword ptr [ecx + 8]
007F4AB9  push edx
007F4ABA  lea eax, [ebp - 0xc0]
007F4AC0  push eax
007F4AC1  call 0x7f5610
007F4AC6  mov ecx, eax
007F4AC8  call 0x7f5660
007F4ACD  mov dword ptr [ebp - 0x208], eax
007F4AD3  mov ecx, dword ptr [ebp - 0x208]
007F4AD9  mov dword ptr [ebp - 0x20c], ecx
007F4ADF  mov dword ptr [ebp - 4], 2
007F4AE6  push 1
007F4AE8  mov edx, dword ptr [ebp - 0x20c]
007F4AEE  push edx
007F4AEF  mov eax, dword ptr [ebp - 0x44]
007F4AF2  mov edx, dword ptr [eax]
007F4AF4  mov ecx, dword ptr [ebp - 0x44]
007F4AF7  mov eax, dword ptr [edx + 0xd4]
007F4AFD  call eax
007F4AFF  mov dword ptr [ebp - 4], 0xffffffff
007F4B06  lea ecx, [ebp - 0xc0]
007F4B0C  call 0x4056d0
007F4B11  mov ecx, dword ptr [ebp - 0x28]
007F4B14  mov eax, dword ptr [ecx + 0x14]
007F4B17  cdq
007F4B18  mov ecx, 0x3c
007F4B1D  idiv ecx
007F4B1F  mov dword ptr [ebp - 0x3c], eax
007F4B22  mov edx, dword ptr [ebp - 0x28]
007F4B25  mov eax, dword ptr [edx + 0x14]
007F4B28  cdq
007F4B29  mov ecx, 0x3c
007F4B2E  idiv ecx
007F4B30  mov dword ptr [ebp - 0x38], edx
007F4B33  mov eax, dword ptr [ebp - 0x3c]
007F4B36  cdq
007F4B37  mov ecx, 0x18
007F4B3C  idiv ecx
007F4B3E  mov dword ptr [ebp - 0x10], eax
007F4B41  mov eax, dword ptr [ebp - 0x3c]
007F4B44  cdq
007F4B45  mov ecx, 0x18
007F4B4A  idiv ecx
007F4B4C  mov dword ptr [ebp - 0x34], edx
007F4B4F  mov edx, dword ptr [0xb96c98]
007F4B55  push edx
007F4B56  lea ecx, [ebp - 0xdc]
007F4B5C  call 0x405650
007F4B61  mov dword ptr [ebp - 4], 3
007F4B68  lea eax, [ebp - 0xdc]
007F4B6E  push eax
007F4B6F  mov ecx, dword ptr [ebp - 0x1f8]
007F4B75  call 0x75fbf0
007F4B7A  mov dword ptr [ebp - 0x20], eax
007F4B7D  mov dword ptr [ebp - 4], 0xffffffff
007F4B84  lea ecx, [ebp - 0xdc]
007F4B8A  call 0x4056d0
007F4B8F  cmp dword ptr [ebp - 0x20], 0
007F4B93  je 0x7f4c68
007F4B99  mov ecx, dword ptr [ebp - 0x14]
007F4B9C  mov edx, dword ptr [ecx + 4]
007F4B9F  imul edx, dword ptr [ebp - 0x3c]
007F4BA3  mov dword ptr [ebp - 0x48], edx
007F4BA6  mov eax, dword ptr [ebp - 0x14]
007F4BA9  mov ecx, dword ptr [ebp - 0x48]
007F4BAC  cmp ecx, dword ptr [eax + 8]
007F4BAF  jge 0x7f4bbc
007F4BB1  mov edx, dword ptr [ebp - 0x48]
007F4BB4  mov dword ptr [ebp - 0x210], edx
007F4BBA  jmp 0x7f4bc8
007F4BBC  mov eax, dword ptr [ebp - 0x14]
007F4BBF  mov ecx, dword ptr [eax + 8]
007F4BC2  mov dword ptr [ebp - 0x210], ecx
007F4BC8  mov edx, dword ptr [ebp - 0x210]
007F4BCE  mov dword ptr [ebp - 0x48], edx
007F4BD1  lea eax, [ebp - 0x48]
007F4BD4  push eax
007F4BD5  lea ecx, [ebp - 0xf8]
007F4BDB  push ecx
007F4BDC  call 0xa44160
007F4BE1  add esp, 8
007F4BE4  mov dword ptr [ebp - 0x214], eax
007F4BEA  mov edx, dword ptr [ebp - 0x214]
007F4BF0  mov dword ptr [ebp - 0x218], edx
007F4BF6  mov dword ptr [ebp - 4], 4
007F4BFD  mov eax, dword ptr [ebp - 0x218]
007F4C03  push eax
007F4C04  push 0xb9d580
007F4C09  lea ecx, [ebp - 0x114]
007F4C0F  push ecx
007F4C10  call 0x411d70
007F4C15  add esp, 0xc
007F4C18  mov dword ptr [ebp - 0x21c], eax
007F4C1E  mov edx, dword ptr [ebp - 0x21c]
007F4C24  mov dword ptr [ebp - 0x220], edx
007F4C2A  mov byte ptr [ebp - 4], 5
007F4C2E  push 1
007F4C30  mov eax, dword ptr [ebp - 0x220]
007F4C36  push eax
007F4C37  mov ecx, dword ptr [ebp - 0x20]
007F4C3A  mov edx, dword ptr [ecx]
007F4C3C  mov ecx, dword ptr [ebp - 0x20]
007F4C3F  mov eax, dword ptr [edx + 0xd4]
007F4C45  call eax
007F4C47  mov byte ptr [ebp - 4], 4
007F4C4B  lea ecx, [ebp - 0x114]
007F4C51  call 0x4056d0
007F4C56  mov dword ptr [ebp - 4], 0xffffffff
007F4C5D  lea ecx, [ebp - 0xf8]
007F4C63  call 0x4056d0
007F4C68  mov ecx, dword ptr [0xb96c9c]
007F4C6E  push ecx
007F4C6F  lea ecx, [ebp - 0x130]
007F4C75  call 0x405650
007F4C7A  mov dword ptr [ebp - 4], 6
007F4C81  lea edx, [ebp - 0x130]
007F4C87  push edx
007F4C88  mov ecx, dword ptr [ebp - 0x1f8]
007F4C8E  call 0x75fbf0
007F4C93  mov dword ptr [ebp - 0x1c], eax
007F4C96  mov dword ptr [ebp - 4], 0xffffffff
007F4C9D  lea ecx, [ebp - 0x130]
007F4CA3  call 0x4056d0
007F4CA8  cmp dword ptr [ebp - 0x1c], 0
007F4CAC  je 0x7f4da8
007F4CB2  mov eax, dword ptr [ebp - 0x28]
007F4CB5  cmp dword ptr [eax + 8], 1
007F4CB9  jae 0x7f4d4d
007F4CBF  cmp dword ptr [ebp - 0x10], 0
007F4CC3  jle 0x7f4d09
007F4CC5  push 0xbce808
007F4CCA  lea ecx, [ebp - 0x14c]
007F4CD0  call 0x405650
007F4CD5  mov dword ptr [ebp - 4], 7
007F4CDC  push 1
007F4CDE  lea ecx, [ebp - 0x14c]
007F4CE4  push ecx
007F4CE5  mov edx, dword ptr [ebp - 0x1c]
007F4CE8  mov eax, dword ptr [edx]
007F4CEA  mov ecx, dword ptr [ebp - 0x1c]
007F4CED  mov edx, dword ptr [eax + 0xd4]
007F4CF3  call edx
007F4CF5  mov dword ptr [ebp - 4], 0xffffffff
007F4CFC  lea ecx, [ebp - 0x14c]
007F4D02  call 0x4056d0
007F4D07  jmp 0x7f4d4b
007F4D09  push 0xbce818
007F4D0E  lea ecx, [ebp - 0x168]
007F4D14  call 0x405650
007F4D19  mov dword ptr [ebp - 4], 8
007F4D20  push 1
007F4D22  lea eax, [ebp - 0x168]
007F4D28  push eax
007F4D29  mov ecx, dword ptr [ebp - 0x1c]
007F4D2C  mov edx, dword ptr [ecx]
007F4D2E  mov ecx, dword ptr [ebp - 0x1c]
007F4D31  mov eax, dword ptr [edx + 0xd4]
007F4D37  call eax
007F4D39  mov dword ptr [ebp - 4], 0xffffffff
007F4D40  lea ecx, [ebp - 0x168]
007F4D46  call 0x4056d0
007F4D4B  jmp 0x7f4da8
007F4D4D  mov ecx, dword ptr [ebp - 0x28]
007F4D50  mov edx, dword ptr [ecx + 0x10]
007F4D53  push edx
007F4D54  push 0xbce81c
007F4D59  push 0x20
007F4D5B  lea eax, [ebp - 0x6c]
007F4D5E  push eax
007F4D5F  call 0x663beb
007F4D64  add esp, 0x10
007F4D67  lea ecx, [ebp - 0x6c]
007F4D6A  push ecx
007F4D6B  lea ecx, [ebp - 0x184]
007F4D71  call 0x405650
007F4D76  mov dword ptr [ebp - 4], 9
007F4D7D  push 1
007F4D7F  lea edx, [ebp - 0x184]
007F4D85  push edx
007F4D86  mov eax, dword ptr [ebp - 0x1c]
007F4D89  mov edx, dword ptr [eax]
007F4D8B  mov ecx, dword ptr [ebp - 0x1c]
007F4D8E  mov eax, dword ptr [edx + 0xd4]
007F4D94  call eax
007F4D96  mov dword ptr [ebp - 4], 0xffffffff
007F4D9D  lea ecx, [ebp - 0x184]
007F4DA3  call 0x4056d0
007F4DA8  mov ecx, dword ptr [0x17c86fc]
007F4DAE  call 0x402aa0
007F4DB3  mov ecx, dword ptr [ebp - 0x28]
007F4DB6  mov dword ptr [ebp - 0x228], eax
007F4DBC  mov dword ptr [ebp - 0x224], edx
007F4DC2  mov dword ptr [ebp - 0x22c], ecx
007F4DC8  mov edx, dword ptr [ebp - 0x22c]
007F4DCE  mov eax, dword ptr [ebp - 0x228]
007F4DD4  cmp eax, dword ptr [edx]
007F4DD6  jne 0x7f4df5
007F4DD8  mov ecx, dword ptr [ebp - 0x22c]
007F4DDE  mov edx, dword ptr [ebp - 0x224]
007F4DE4  cmp edx, dword ptr [ecx + 4]
007F4DE7  jne 0x7f4df5
007F4DE9  mov dword ptr [ebp - 0x230], 1
007F4DF3  jmp 0x7f4dff
007F4DF5  mov dword ptr [ebp - 0x230], 0
007F4DFF  mov al, byte ptr [ebp - 0x230]
007F4E05  mov byte ptr [ebp - 0x15], al
007F4E08  mov ecx, dword ptr [0xb96ca0]
007F4E0E  push ecx
007F4E0F  lea ecx, [ebp - 0x1a0]
007F4E15  call 0x405650
007F4E1A  mov dword ptr [ebp - 4], 0xa
007F4E21  lea edx, [ebp - 0x1a0]
007F4E27  push edx
007F4E28  mov ecx, dword ptr [ebp - 0x1f8]
007F4E2E  call 0x75fbf0
007F4E33  mov dword ptr [ebp - 0x30], eax
007F4E36  mov dword ptr [ebp - 4], 0xffffffff
007F4E3D  lea ecx, [ebp - 0x1a0]
007F4E43  call 0x4056d0
007F4E48  cmp dword ptr [ebp - 0x30], 0
007F4E4C  je 0x7f4f46
007F4E52  mov ecx, dword ptr [0x17c86fc]
007F4E58  call 0x402aa0
007F4E5D  mov ecx, dword ptr [ebp - 0x28]
007F4E60  mov dword ptr [ebp - 0x234], ecx
007F4E66  mov dword ptr [ebp - 0x23c], eax
007F4E6C  mov dword ptr [ebp - 0x238], edx
007F4E72  mov edx, dword ptr [ebp - 0x234]
007F4E78  mov eax, dword ptr [edx]
007F4E7A  cmp eax, dword ptr [ebp - 0x23c]
007F4E80  jne 0x7f4f3c
007F4E86  mov ecx, dword ptr [ebp - 0x234]
007F4E8C  mov edx, dword ptr [ecx + 4]
007F4E8F  cmp edx, dword ptr [ebp - 0x238]
007F4E95  jne 0x7f4f3c
007F4E9B  push 1
007F4E9D  mov ecx, dword ptr [ebp - 0x30]
007F4EA0  call 0x75aa30
007F4EA5  movzx eax, byte ptr [ebp - 0x21]
007F4EA9  push eax
007F4EAA  mov ecx, dword ptr [ebp - 0x30]
007F4EAD  call 0x75a960
007F4EB2  movzx ecx, byte ptr [ebp - 0x21]
007F4EB6  test ecx, ecx
007F4EB8  je 0x7f4efb
007F4EBA  mov edx, dword ptr [0xb96ca8]
007F4EC0  push edx
007F4EC1  lea ecx, [ebp - 0x1bc]
007F4EC7  call 0x405650
007F4ECC  mov dword ptr [ebp - 4], 0xb
007F4ED3  lea eax, [ebp - 0x1bc]
007F4ED9  push eax
007F4EDA  mov ecx, dword ptr [ebp - 0x30]
007F4EDD  mov edx, dword ptr [ecx]
007F4EDF  mov ecx, dword ptr [ebp - 0x30]
007F4EE2  mov eax, dword ptr [edx + 0x28]
007F4EE5  call eax
007F4EE7  mov dword ptr [ebp - 4], 0xffffffff
007F4EEE  lea ecx, [ebp - 0x1bc]
007F4EF4  call 0x4056d0
007F4EF9  jmp 0x7f4f3a
007F4EFB  mov ecx, dword ptr [0xb96cac]
007F4F01  push ecx
007F4F02  lea ecx, [ebp - 0x1d8]
007F4F08  call 0x405650
007F4F0D  mov dword ptr [ebp - 4], 0xc
007F4F14  lea edx, [ebp - 0x1d8]
007F4F1A  push edx
007F4F1B  mov eax, dword ptr [ebp - 0x30]
007F4F1E  mov edx, dword ptr [eax]
007F4F20  mov ecx, dword ptr [ebp - 0x30]
007F4F23  mov eax, dword ptr [edx + 0x28]
007F4F26  call eax
007F4F28  mov dword ptr [ebp - 4], 0xffffffff
007F4F2F  lea ecx, [ebp - 0x1d8]
007F4F35  call 0x4056d0
007F4F3A  jmp 0x7f4f46
007F4F3C  push 0
007F4F3E  mov ecx, dword ptr [ebp - 0x30]
007F4F41  call 0x75aa30
007F4F46  mov ecx, dword ptr [0xb96ca4]
007F4F4C  push ecx
007F4F4D  lea ecx, [ebp - 0x1f4]
007F4F53  call 0x405650
007F4F58  mov dword ptr [ebp - 4], 0xd
007F4F5F  lea edx, [ebp - 0x1f4]
007F4F65  push edx
007F4F66  mov ecx, dword ptr [ebp - 0x1f8]
007F4F6C  call 0x75fbf0
007F4F71  mov dword ptr [ebp - 0x2c], eax
007F4F74  mov dword ptr [ebp - 4], 0xffffffff
007F4F7B  lea ecx, [ebp - 0x1f4]
007F4F81  call 0x4056d0
007F4F86  cmp dword ptr [ebp - 0x2c], 0
007F4F8A  je 0x7f5027
007F4F90  mov ecx, dword ptr [0x17c86fc]
007F4F96  call 0x402aa0
007F4F9B  mov ecx, dword ptr [ebp - 0x28]
007F4F9E  mov dword ptr [ebp - 0x240], ecx
007F4FA4  mov dword ptr [ebp - 0x248], eax
007F4FAA  mov dword ptr [ebp - 0x244], edx
007F4FB0  mov edx, dword ptr [ebp - 0x240]
007F4FB6  mov eax, dword ptr [edx]
007F4FB8  cmp eax, dword ptr [ebp - 0x248]
007F4FBE  jne 0x7f5013
007F4FC0  mov ecx, dword ptr [ebp - 0x240]
007F4FC6  mov edx, dword ptr [ecx + 4]
007F4FC9  cmp edx, dword ptr [ebp - 0x244]
007F4FCF  jne 0x7f5013
007F4FD1  push 1
007F4FD3  mov ecx, dword ptr [ebp - 0x2c]
007F4FD6  call 0x75aa30
007F4FDB  movzx eax, byte ptr [ebp - 0x15]
007F4FDF  test eax, eax
007F4FE1  je 0x7f5007
007F4FE3  cmp dword ptr [ebp - 0x3c], 1
007F4FE7  jge 0x7f4ffb
007F4FE9  cmp dword ptr [ebp - 0x10], 1
007F4FED  jge 0x7f4ffb
007F4FEF  push 0
007F4FF1  mov ecx, dword ptr [ebp - 0x2c]
007F4FF4  call 0x75a960
007F4FF9  jmp 0x7f5005
007F4FFB  push 1
007F4FFD  mov ecx, dword ptr [ebp - 0x2c]
007F5000  call 0x75a960
007F5005  jmp 0x7f5011
007F5007  push 0
007F5009  mov ecx, dword ptr [ebp - 0x2c]
007F500C  call 0x75a960
007F5011  jmp 0x7f5027
007F5013  push 0
007F5015  mov ecx, dword ptr [ebp - 0x2c]
007F5018  call 0x75a960
007F501D  push 0
007F501F  mov ecx, dword ptr [ebp - 0x2c]
007F5022  call 0x75aa30
007F5027  mov ecx, dword ptr [ebp - 0x1f8]
007F502D  call 0x7f4770
007F5032  mov ecx, dword ptr [ebp - 0xc]
007F5035  mov dword ptr fs:[0], ecx
007F503C  pop ecx
007F503D  mov ecx, dword ptr [ebp - 0x4c]
007F5040  xor ecx, ebp
007F5042  call 0x6634fb
007F5047  mov esp, ebp
007F5049  pop ebp
007F504A  ret
007F504B  int3
007F504C  int3
007F504D  int3
007F504E  int3
007F504F  int3
007F5050  push ebp
007F5051  mov ebp, esp
007F5053  push ecx
007F5054  mov dword ptr [ebp - 4], ecx
007F5057  mov eax, dword ptr [ebp - 4]
007F505A  mov dword ptr [eax], 0xbce83c

; range 0x7f5500..0x7f5701
007F5500  push ebp
007F5501  mov ebp, esp
007F5503  push ecx
007F5504  mov dword ptr [ebp - 4], ecx
007F5507  mov eax, dword ptr [ebp - 4]
007F550A  add eax, 0x21
007F550D  mov esp, ebp
007F550F  pop ebp
007F5510  ret
007F5511  int3
007F5512  int3
007F5513  int3
007F5514  int3
007F5515  int3
007F5516  int3
007F5517  int3
007F5518  int3
007F5519  int3
007F551A  int3
007F551B  int3
007F551C  int3
007F551D  int3
007F551E  int3
007F551F  int3
007F5520  push ebp
007F5521  mov ebp, esp
007F5523  push ecx
007F5524  mov dword ptr [ebp - 4], ecx
007F5527  mov eax, dword ptr [ebp - 4]
007F552A  add eax, 1
007F552D  mov esp, ebp
007F552F  pop ebp
007F5530  ret
007F5531  int3
007F5532  int3
007F5533  int3
007F5534  int3
007F5535  int3
007F5536  int3
007F5537  int3
007F5538  int3
007F5539  int3
007F553A  int3
007F553B  int3
007F553C  int3
007F553D  int3
007F553E  int3
007F553F  int3
007F5540  push ebp
007F5541  mov ebp, esp
007F5543  push ecx
007F5544  push esi
007F5545  push edi
007F5546  mov dword ptr [ebp - 4], ecx
007F5549  cmp dword ptr [ebp + 8], 0
007F554D  je 0x7f5555
007F554F  cmp dword ptr [ebp + 0xc], 0
007F5553  jne 0x7f5557
007F5555  jmp 0x7f55a3
007F5557  mov eax, dword ptr [ebp - 4]
007F555A  mov byte ptr [eax], 1
007F555D  mov esi, dword ptr [ebp + 8]
007F5560  mov edi, dword ptr [ebp - 4]
007F5563  add edi, 1
007F5566  mov ecx, 8
007F556B  rep movsd dword ptr es:[edi], dword ptr [esi]
007F556D  mov ecx, dword ptr [ebp + 0xc]
007F5570  mov edx, dword ptr [ebp - 4]
007F5573  add edx, 0x21
007F5576  mov eax, dword ptr [ecx]
007F5578  mov dword ptr [edx], eax
007F557A  mov eax, dword ptr [ecx + 4]
007F557D  mov dword ptr [edx + 4], eax
007F5580  mov eax, dword ptr [ecx + 8]
007F5583  mov dword ptr [edx + 8], eax
007F5586  mov eax, dword ptr [ecx + 0xc]
007F5589  mov dword ptr [edx + 0xc], eax
007F558C  mov eax, dword ptr [ecx + 0x10]
007F558F  mov dword ptr [edx + 0x10], eax
007F5592  mov ecx, dword ptr [ecx + 0x14]
007F5595  mov dword ptr [edx + 0x14], ecx
007F5598  mov edx, dword ptr [ebp - 4]
007F559B  mov eax, dword ptr [0x17c8690]
007F55A0  mov dword ptr [edx + 0x3c], eax
007F55A3  pop edi
007F55A4  pop esi
007F55A5  mov esp, ebp
007F55A7  pop ebp
007F55A8  ret 8
007F55AB  int3
007F55AC  int3
007F55AD  int3
007F55AE  int3
007F55AF  int3
007F55B0  push ebp
007F55B1  mov ebp, esp
007F55B3  push ecx
007F55B4  mov dword ptr [ebp - 4], ecx
007F55B7  mov eax, dword ptr [ebp - 4]
007F55BA  mov byte ptr [eax], 0
007F55BD  push 0x20
007F55BF  push 0
007F55C1  mov ecx, dword ptr [ebp - 4]
007F55C4  add ecx, 1
007F55C7  push ecx
007F55C8  call 0x666960
007F55CD  add esp, 0xc
007F55D0  push 0x18
007F55D2  push 0
007F55D4  mov edx, dword ptr [ebp - 4]
007F55D7  add edx, 0x21
007F55DA  push edx
007F55DB  call 0x666960
007F55E0  add esp, 0xc
007F55E3  mov esp, ebp
007F55E5  pop ebp
007F55E6  ret
007F55E7  int3
007F55E8  int3
007F55E9  int3
007F55EA  int3
007F55EB  int3
007F55EC  int3
007F55ED  int3
007F55EE  int3
007F55EF  int3
007F55F0  push ebp
007F55F1  mov ebp, esp
007F55F3  push ecx
007F55F4  mov dword ptr [ebp - 4], ecx
007F55F7  mov eax, dword ptr [ebp - 4]
007F55FA  mov dword ptr [eax + 0x3c], 0
007F5601  mov ecx, dword ptr [ebp - 4]
007F5604  call 0x7f55b0
007F5609  mov eax, dword ptr [ebp - 4]
007F560C  mov esp, ebp
007F560E  pop ebp
007F560F  ret
007F5610  push ebp
007F5611  mov ebp, esp
007F5613  sub esp, 0xc
007F5616  cmp dword ptr [0x17c8b7c], 0
007F561D  jne 0x7f5655
007F561F  push 0x40
007F5621  call 0x667fbb
007F5626  add esp, 4
007F5629  mov dword ptr [ebp - 8], eax
007F562C  cmp dword ptr [ebp - 8], 0
007F5630  je 0x7f563f
007F5632  mov ecx, dword ptr [ebp - 8]
007F5635  call 0x7f55f0
007F563A  mov dword ptr [ebp - 0xc], eax
007F563D  jmp 0x7f5646
007F563F  mov dword ptr [ebp - 0xc], 0
007F5646  mov eax, dword ptr [ebp - 0xc]
007F5649  mov dword ptr [ebp - 4], eax
007F564C  mov ecx, dword ptr [ebp - 4]
007F564F  mov dword ptr [0x17c8b7c], ecx
007F5655  mov eax, dword ptr [0x17c8b7c]
007F565A  mov esp, ebp
007F565C  pop ebp
007F565D  ret
007F565E  int3
007F565F  int3
007F5660  push ebp
007F5661  mov ebp, esp
007F5663  sub esp, 0x2c
007F5666  mov eax, dword ptr [0xc7b480]
007F566B  xor eax, ebp
007F566D  mov dword ptr [ebp - 4], eax
007F5670  mov dword ptr [ebp - 0x2c], ecx
007F5673  mov dword ptr [ebp - 0x28], 0
007F567A  cmp dword ptr [ebp + 0xc], 1
007F567E  jge 0x7f569d
007F5680  push 0xbce758
007F5685  mov ecx, dword ptr [ebp + 8]
007F5688  call 0x405650
007F568D  mov eax, dword ptr [ebp - 0x28]
007F5690  or eax, 1
007F5693  mov dword ptr [ebp - 0x28], eax
007F5696  mov eax, dword ptr [ebp + 8]
007F5699  jmp 0x7f56f3
007F569B  jmp 0x7f56da
007F569D  cmp dword ptr [ebp + 0xc], 1
007F56A1  jl 0x7f56da
007F56A3  cmp dword ptr [ebp + 0xc], 8
007F56A7  jg 0x7f56da
007F56A9  mov ecx, dword ptr [ebp + 0xc]
007F56AC  push ecx
007F56AD  push 0xbce760
007F56B2  push 0x1f
007F56B4  lea edx, [ebp - 0x24]
007F56B7  push edx
007F56B8  call 0x663beb
007F56BD  add esp, 0x10
007F56C0  lea eax, [ebp - 0x24]
007F56C3  push eax
007F56C4  mov ecx, dword ptr [ebp + 8]
007F56C7  call 0x405650
007F56CC  mov ecx, dword ptr [ebp - 0x28]
007F56CF  or ecx, 1
007F56D2  mov dword ptr [ebp - 0x28], ecx
007F56D5  mov eax, dword ptr [ebp + 8]
007F56D8  jmp 0x7f56f3
007F56DA  push 0xb96699
007F56DF  mov ecx, dword ptr [ebp + 8]
007F56E2  call 0x405650
007F56E7  mov edx, dword ptr [ebp - 0x28]
007F56EA  or edx, 1
007F56ED  mov dword ptr [ebp - 0x28], edx
007F56F0  mov eax, dword ptr [ebp + 8]
007F56F3  mov ecx, dword ptr [ebp - 4]
007F56F6  xor ecx, ebp
007F56F8  call 0x6634fb
007F56FD  mov esp, ebp
007F56FF  pop ebp

; range 0xa2ad80..0xa2aeb0
00A2AD80  push ebp
00A2AD81  mov ebp, esp
00A2AD83  sub esp, 0x38
00A2AD86  push esi
00A2AD87  push edi
00A2AD88  mov dword ptr [ebp - 0x2c], ecx
00A2AD8B  cmp dword ptr [ebp + 8], 0
00A2AD8F  jne 0xa2ad96
00A2AD91  jmp 0xa2aea8
00A2AD96  cmp dword ptr [ebp + 0xc], 0x38
00A2AD9A  je 0xa2ada1
00A2AD9C  jmp 0xa2aea8
00A2ADA1  mov eax, dword ptr [ebp + 8]
00A2ADA4  mov dword ptr [ebp - 4], eax
00A2ADA7  mov ecx, dword ptr [ebp - 4]
00A2ADAA  add ecx, 0x20
00A2ADAD  mov dword ptr [ebp - 8], ecx
00A2ADB0  mov esi, dword ptr [ebp - 4]
00A2ADB3  mov ecx, 8
00A2ADB8  lea edi, [ebp - 0x28]
00A2ADBB  rep movsd dword ptr es:[edi], dword ptr [esi]
00A2ADBD  push 0
00A2ADBF  push 0x520a
00A2ADC4  call 0xa3ca00
00A2ADC9  add esp, 8
00A2ADCC  mov dword ptr [ebp - 0x1c], 0
00A2ADD3  mov dword ptr [ebp - 0x18], 0
00A2ADDA  mov ecx, dword ptr [0x17c86fc]
00A2ADE0  call 0x41b6f0
00A2ADE5  test eax, eax
00A2ADE7  je 0xa2ae85
00A2ADED  mov ecx, dword ptr [0x17c86fc]
00A2ADF3  call 0x402aa0
00A2ADF8  mov ecx, dword ptr [ebp - 4]
00A2ADFB  mov dword ptr [ebp - 0x34], eax
00A2ADFE  mov dword ptr [ebp - 0x30], edx
00A2AE01  mov dword ptr [ebp - 0x38], ecx
00A2AE04  mov edx, dword ptr [ebp - 0x38]
00A2AE07  mov eax, dword ptr [ebp - 0x34]
00A2AE0A  cmp eax, dword ptr [edx]
00A2AE0C  jne 0xa2ae85
00A2AE0E  mov ecx, dword ptr [ebp - 0x38]
00A2AE11  mov edx, dword ptr [ebp - 0x30]
00A2AE14  cmp edx, dword ptr [ecx + 4]
00A2AE17  jne 0xa2ae85
00A2AE19  mov eax, dword ptr [ebp - 8]
00A2AE1C  push eax
00A2AE1D  lea ecx, [ebp - 0x28]
00A2AE20  push ecx
00A2AE21  mov ecx, dword ptr [0x17c86fc]
00A2AE27  call 0x41b6f0
00A2AE2C  mov ecx, eax
00A2AE2E  call 0x9e3ba0
00A2AE33  mov edx, dword ptr [ebp - 8]
00A2AE36  push edx
00A2AE37  lea eax, [ebp - 0x28]
00A2AE3A  push eax
00A2AE3B  call 0x7f5610
00A2AE40  mov ecx, eax
00A2AE42  call 0x7f5540
00A2AE47  call 0x41c400
00A2AE4C  mov ecx, eax
00A2AE4E  call 0x41bb50
00A2AE53  movzx ecx, al
00A2AE56  test ecx, ecx
00A2AE58  je 0xa2ae66
00A2AE5A  call 0x41c400
00A2AE5F  mov ecx, eax
00A2AE61  call 0x7f4980
00A2AE66  call 0x41c230
00A2AE6B  mov ecx, eax
00A2AE6D  call 0x41bb50
00A2AE72  movzx edx, al
00A2AE75  test edx, edx
00A2AE77  je 0xa2ae85
00A2AE79  call 0x41c230
00A2AE7E  mov ecx, eax
00A2AE80  call 0x91c620
00A2AE85  call 0x4162a0
00A2AE8A  mov ecx, eax
00A2AE8C  call 0x41bb50
00A2AE91  movzx eax, al
00A2AE94  test eax, eax
00A2AE96  je 0xa2aea8
00A2AE98  mov ecx, dword ptr [ebp - 4]
00A2AE9B  push ecx
00A2AE9C  call 0x4162a0
00A2AEA1  mov ecx, eax
00A2AEA3  call 0x881620
00A2AEA8  pop edi
00A2AEA9  pop esi
00A2AEAA  mov esp, ebp
00A2AEAC  pop ebp
00A2AEAD  ret 8

; UI binding range 0xb2ad45..0xb2aed0
00B2AD45  mov dword ptr [0x1df82e0], 0x101
00B2AD4F  mov dword ptr [0x1df82e4], 1
00B2AD59  mov dword ptr [ebp - 0x1c], 0x7d1c90
00B2AD60  mov dword ptr [ebp - 0x18], 0
00B2AD67  mov dword ptr [ebp - 0x14], 0
00B2AD6E  mov dword ptr [ebp - 0x10], 0
00B2AD75  mov eax, dword ptr [ebp - 0x1c]
00B2AD78  mov dword ptr [0x1df82e8], eax
00B2AD7D  mov ecx, dword ptr [ebp - 0x18]
00B2AD80  mov dword ptr [0x1df82ec], ecx
00B2AD86  mov edx, dword ptr [ebp - 0x14]
00B2AD89  mov dword ptr [0x1df82f0], edx
00B2AD8F  mov eax, dword ptr [ebp - 0x10]
00B2AD92  mov dword ptr [0x1df82f4], eax
00B2AD97  mov ecx, dword ptr [0xb96c88]
00B2AD9D  push ecx
00B2AD9E  mov ecx, 0x1df82f8
00B2ADA3  call 0x405650
00B2ADA8  mov dword ptr [ebp - 4], 0
00B2ADAF  mov dword ptr [0x1df8318], 0x101
00B2ADB9  mov dword ptr [0x1df831c], 1
00B2ADC3  mov dword ptr [ebp - 0x2c], 0x7f4750
00B2ADCA  mov dword ptr [ebp - 0x28], 0
00B2ADD1  mov dword ptr [ebp - 0x24], 0
00B2ADD8  mov dword ptr [ebp - 0x20], 0
00B2ADDF  mov edx, dword ptr [ebp - 0x2c]
00B2ADE2  mov dword ptr [0x1df8320], edx
00B2ADE8  mov eax, dword ptr [ebp - 0x28]
00B2ADEB  mov dword ptr [0x1df8324], eax
00B2ADF0  mov ecx, dword ptr [ebp - 0x24]
00B2ADF3  mov dword ptr [0x1df8328], ecx
00B2ADF9  mov edx, dword ptr [ebp - 0x20]
00B2ADFC  mov dword ptr [0x1df832c], edx
00B2AE02  mov eax, dword ptr [0xb96ca0]
00B2AE07  push eax
00B2AE08  mov ecx, 0x1df8330
00B2AE0D  call 0x405650
00B2AE12  mov byte ptr [ebp - 4], 1
00B2AE16  mov dword ptr [0x1df8350], 0x101
00B2AE20  mov dword ptr [0x1df8354], 1
00B2AE2A  mov dword ptr [ebp - 0x3c], 0x7f4730
00B2AE31  mov dword ptr [ebp - 0x38], 0
00B2AE38  mov dword ptr [ebp - 0x34], 0
00B2AE3F  mov dword ptr [ebp - 0x30], 0
00B2AE46  mov ecx, dword ptr [ebp - 0x3c]
00B2AE49  mov dword ptr [0x1df8358], ecx
00B2AE4F  mov edx, dword ptr [ebp - 0x38]
00B2AE52  mov dword ptr [0x1df835c], edx
00B2AE58  mov eax, dword ptr [ebp - 0x34]
00B2AE5B  mov dword ptr [0x1df8360], eax
00B2AE60  mov ecx, dword ptr [ebp - 0x30]
00B2AE63  mov dword ptr [0x1df8364], ecx
00B2AE69  mov edx, dword ptr [0xb96ca4]
00B2AE6F  push edx
00B2AE70  mov ecx, 0x1df8368
00B2AE75  call 0x405650
00B2AE7A  mov byte ptr [ebp - 4], 2
00B2AE7E  mov dword ptr [0x1df8388], 0x101
00B2AE88  mov dword ptr [0x1df838c], 1
00B2AE92  mov dword ptr [ebp - 0x4c], 0x7f52b0
00B2AE99  mov dword ptr [ebp - 0x48], 0
00B2AEA0  mov dword ptr [ebp - 0x44], 0
00B2AEA7  mov dword ptr [ebp - 0x40], 0
00B2AEAE  mov eax, dword ptr [ebp - 0x4c]
00B2AEB1  mov dword ptr [0x1df8390], eax
00B2AEB6  mov ecx, dword ptr [ebp - 0x48]
00B2AEB9  mov dword ptr [0x1df8394], ecx
00B2AEBF  mov edx, dword ptr [ebp - 0x44]
00B2AEC2  mov dword ptr [0x1df8398], edx
00B2AEC8  mov eax, dword ptr [ebp - 0x40]
00B2AECB  mov dword ptr [0x1df839c], eax

; UI binding range 0xb16825..0xb16939
00B16825  mov ecx, dword ptr [0xb98fd0]
00B1682B  push ecx
00B1682C  mov ecx, 0x1df22b8
00B16831  call 0x405650
00B16836  mov byte ptr [ebp - 4], 0x24
00B1683A  mov dword ptr [0x1df22d8], 0x101
00B16844  mov dword ptr [0x1df22dc], 1
00B1684E  mov dword ptr [ebp - 0x26c], 0x881250
00B16858  mov dword ptr [ebp - 0x268], 0
00B16862  mov dword ptr [ebp - 0x264], 0
00B1686C  mov dword ptr [ebp - 0x260], 0
00B16876  mov edx, dword ptr [ebp - 0x26c]
00B1687C  mov dword ptr [0x1df22e0], edx
00B16882  mov eax, dword ptr [ebp - 0x268]
00B16888  mov dword ptr [0x1df22e4], eax
00B1688D  mov ecx, dword ptr [ebp - 0x264]
00B16893  mov dword ptr [0x1df22e8], ecx
00B16899  mov edx, dword ptr [ebp - 0x260]
00B1689F  mov dword ptr [0x1df22ec], edx
00B168A5  mov eax, dword ptr [0xb99008]
00B168AA  push eax
00B168AB  mov ecx, 0x1df22f0
00B168B0  call 0x405650
00B168B5  mov byte ptr [ebp - 4], 0x25
00B168B9  mov dword ptr [0x1df2310], 0x101
00B168C3  mov dword ptr [0x1df2314], 1
00B168CD  mov dword ptr [ebp - 0x27c], 0x881230
00B168D7  mov dword ptr [ebp - 0x278], 0
00B168E1  mov dword ptr [ebp - 0x274], 0
00B168EB  mov dword ptr [ebp - 0x270], 0
00B168F5  mov ecx, dword ptr [ebp - 0x27c]
00B168FB  mov dword ptr [0x1df2318], ecx
00B16901  mov edx, dword ptr [ebp - 0x278]
00B16907  mov dword ptr [0x1df231c], edx
00B1690D  mov eax, dword ptr [ebp - 0x274]
00B16913  mov dword ptr [0x1df2320], eax
00B16918  mov ecx, dword ptr [ebp - 0x270]
00B1691E  mov dword ptr [0x1df2324], ecx
00B16924  mov edx, dword ptr [0xb9900c]
00B1692A  push edx
00B1692B  mov ecx, 0x1df2328
00B16930  call 0x405650
00B16935  mov byte ptr [ebp - 4], 0x26

; UI binding range 0x7f52b0..0x7f533d
007F52B0  push ebp
007F52B1  mov ebp, esp
007F52B3  sub esp, 0x80
007F52B9  mov eax, dword ptr [0xc7b480]
007F52BE  xor eax, ebp
007F52C0  mov dword ptr [ebp - 8], eax
007F52C3  mov dword ptr [ebp - 0x7c], ecx
007F52C6  push 0xe7efb
007F52CB  call 0xa21b30
007F52D0  mov ecx, eax
007F52D2  call 0xa1e560
007F52D7  mov dword ptr [ebp - 4], eax
007F52DA  cmp dword ptr [ebp - 4], 0
007F52DE  je 0x7f532f
007F52E0  call 0x4c4270
007F52E5  mov dword ptr [ebp - 0x80], eax
007F52E8  mov eax, dword ptr [ebp - 0x80]
007F52EB  mov edx, dword ptr [eax]
007F52ED  mov ecx, dword ptr [ebp - 0x80]
007F52F0  mov eax, dword ptr [edx + 0x108]
007F52F6  call eax
007F52F8  push 0x6c
007F52FA  push 0
007F52FC  lea ecx, [ebp - 0x78]
007F52FF  push ecx
007F5300  call 0x666960
007F5305  add esp, 0xc
007F5308  mov edx, dword ptr [ebp - 4]
007F530B  mov eax, dword ptr [edx + 4]
007F530E  mov dword ptr [ebp - 0x73], eax
007F5311  mov dword ptr [ebp - 0x5e], 1
007F5318  mov dword ptr [ebp - 0x62], 0x2238
007F531F  lea ecx, [ebp - 0x78]
007F5322  push ecx
007F5323  call 0x4c4270
007F5328  mov ecx, eax
007F532A  call 0x86f6d0
007F532F  mov ecx, dword ptr [ebp - 8]
007F5332  xor ecx, ebp
007F5334  call 0x6634fb
007F5339  mov esp, ebp
007F533B  pop ebp
007F533C  ret

; 4300 XP writer: does not write profile level +120
009CD5B0  push ebp
009CD5B1  mov ebp, esp
009CD5B3  sub esp, 8
009CD5B6  mov dword ptr [ebp - 8], ecx
009CD5B9  mov ecx, dword ptr [ebp - 8]
009CD5BC  call 0x9cd390
009CD5C1  mov dword ptr [ebp - 4], eax
009CD5C4  cmp dword ptr [ebp - 4], 0
009CD5C8  je 0x9cd5e2
009CD5CA  mov eax, dword ptr [ebp - 4]
009CD5CD  mov ecx, dword ptr [ebp + 8]
009CD5D0  mov dword ptr [eax + 0xf5], ecx
009CD5D6  mov edx, dword ptr [ebp - 4]
009CD5D9  mov eax, dword ptr [ebp + 0xc]
009CD5DC  mov dword ptr [edx + 0xf9], eax
009CD5E2  mov esp, ebp
009CD5E4  pop ebp
009CD5E5  ret 8
