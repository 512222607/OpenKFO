; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0x821bd0..0x821c3c
00821BD0  push ebp
00821BD1  mov ebp, esp
00821BD3  sub esp, 0xc
00821BD6  mov dword ptr [ebp - 0xc], ecx
00821BD9  cmp dword ptr [ebp + 8], 0
00821BDD  je 0x821be5
00821BDF  cmp dword ptr [ebp + 0xc], 7
00821BE3  jae 0x821be7
00821BE5  jmp 0x821c36
00821BE7  mov eax, dword ptr [ebp + 8]
00821BEA  mov dword ptr [ebp - 4], eax
00821BED  mov dword ptr [ebp - 8], 0
00821BF4  jmp 0x821bff
00821BF6  mov ecx, dword ptr [ebp - 8]
00821BF9  add ecx, 1
00821BFC  mov dword ptr [ebp - 8], ecx
00821BFF  mov eax, dword ptr [ebp + 0xc]
00821C02  xor edx, edx
00821C04  mov ecx, 0x7b
00821C09  div ecx
00821C0B  cmp dword ptr [ebp - 8], eax
00821C0E  jae 0x821c28
00821C10  mov edx, dword ptr [ebp - 8]
00821C13  imul edx, edx, 0x7b
00821C16  add edx, dword ptr [ebp - 4]
00821C19  push edx
00821C1A  call 0x4044d0
00821C1F  mov ecx, eax
00821C21  call 0xa48fc0
00821C26  jmp 0x821bf6
00821C28  push 0
00821C2A  call 0x4e7570
00821C2F  mov ecx, eax
00821C31  call 0x833370
00821C36  mov esp, ebp
00821C38  pop ebp
00821C39  ret 8

; range 0x822290..0x822310
00822290  push ebp
00822291  mov ebp, esp
00822293  sub esp, 0x10
00822296  mov dword ptr [ebp - 0x10], ecx
00822299  call 0xa4b950
0082229E  mov ecx, eax
008222A0  call 0x531460
008222A5  cmp dword ptr [ebp + 8], 0
008222A9  je 0x8222fd
008222AB  mov eax, dword ptr [ebp + 8]
008222AE  mov dword ptr [ebp - 4], eax
008222B1  mov eax, dword ptr [ebp + 0xc]
008222B4  xor edx, edx
008222B6  mov ecx, 0x8d
008222BB  div ecx
008222BD  mov dword ptr [ebp - 8], eax
008222C0  mov dword ptr [ebp - 0xc], 0
008222C7  jmp 0x8222dd
008222C9  mov edx, dword ptr [ebp - 0xc]
008222CC  add edx, 1
008222CF  mov dword ptr [ebp - 0xc], edx
008222D2  mov eax, dword ptr [ebp - 4]
008222D5  add eax, 0x8d
008222DA  mov dword ptr [ebp - 4], eax
008222DD  mov ecx, dword ptr [ebp - 0xc]
008222E0  cmp ecx, dword ptr [ebp - 8]
008222E3  jge 0x8222fd
008222E5  cmp dword ptr [ebp - 4], 0
008222E9  je 0x8222fd
008222EB  mov edx, dword ptr [ebp - 4]
008222EE  push edx
008222EF  call 0xa4b950
008222F4  mov ecx, eax
008222F6  call 0xa49080
008222FB  jmp 0x8222c9
008222FD  call 0x4e7570
00822302  mov ecx, eax
00822304  call 0x8331e0
00822309  mov esp, ebp
0082230B  pop ebp
0082230C  ret 8
0082230F  int3

; range 0x822310..0x8223a0
00822310  push ebp
00822311  mov ebp, esp
00822313  sub esp, 0x10
00822316  mov dword ptr [ebp - 0x10], ecx
00822319  call 0x4045e0
0082231E  mov ecx, eax
00822320  call 0x531480
00822325  cmp dword ptr [ebp + 8], 0
00822329  je 0x822383
0082232B  cmp dword ptr [ebp + 0xc], 0
0082232F  jle 0x822383
00822331  mov eax, dword ptr [ebp + 8]
00822334  mov dword ptr [ebp - 4], eax
00822337  mov eax, dword ptr [ebp + 0xc]
0082233A  xor edx, edx
0082233C  mov ecx, 0x8d
00822341  div ecx
00822343  mov dword ptr [ebp - 8], eax
00822346  mov dword ptr [ebp - 0xc], 0
0082234D  jmp 0x822363
0082234F  mov edx, dword ptr [ebp - 0xc]
00822352  add edx, 1
00822355  mov dword ptr [ebp - 0xc], edx
00822358  mov eax, dword ptr [ebp - 4]
0082235B  add eax, 0x8d
00822360  mov dword ptr [ebp - 4], eax
00822363  mov ecx, dword ptr [ebp - 0xc]
00822366  cmp ecx, dword ptr [ebp - 8]
00822369  jge 0x822383
0082236B  cmp dword ptr [ebp - 4], 0
0082236F  je 0x822383
00822371  mov edx, dword ptr [ebp - 4]
00822374  push edx
00822375  call 0x4045e0
0082237A  mov ecx, eax
0082237C  call 0xa48920
00822381  jmp 0x82234f
00822383  call 0x4e7570
00822388  mov ecx, eax
0082238A  call 0x834700
0082238F  mov esp, ebp
00822391  pop ebp
00822392  ret 8
00822395  int3
00822396  int3
00822397  int3
00822398  int3
00822399  int3
0082239A  int3
0082239B  int3
0082239C  int3
0082239D  int3
0082239E  int3
0082239F  int3

; range 0xa48fc0..0xa49080
00A48FC0  push ebp
00A48FC1  mov ebp, esp
00A48FC3  sub esp, 0x24
00A48FC6  push esi
00A48FC7  push edi
00A48FC8  mov dword ptr [ebp - 0x24], ecx
00A48FCB  mov eax, dword ptr [ebp + 8]
00A48FCE  movzx ecx, word ptr [eax + 4]
00A48FD2  push ecx
00A48FD3  mov ecx, dword ptr [ebp - 0x24]
00A48FD6  call 0xa47d00
00A48FDB  mov dword ptr [ebp - 4], eax
00A48FDE  cmp dword ptr [ebp - 4], 0
00A48FE2  je 0xa48fef
00A48FE4  mov edx, dword ptr [ebp - 4]
00A48FE7  movzx eax, byte ptr [edx + 2]
00A48FEB  test eax, eax
00A48FED  jne 0xa48ff4
00A48FEF  jmp 0xa49074
00A48FF4  push 0x7b
00A48FF6  call 0x667fbb
00A48FFB  add esp, 4
00A48FFE  mov dword ptr [ebp - 0xc], eax
00A49001  mov ecx, dword ptr [ebp - 0xc]
00A49004  mov dword ptr [ebp - 8], ecx
00A49007  mov esi, dword ptr [ebp + 8]
00A4900A  mov ecx, 0x1e
00A4900F  mov edi, dword ptr [ebp - 8]
00A49012  rep movsd dword ptr es:[edi], dword ptr [esi]
00A49014  movsw word ptr es:[edi], word ptr [esi]
00A49016  movsb byte ptr es:[edi], byte ptr [esi]
00A49017  lea edx, [ebp - 8]
00A4901A  push edx
00A4901B  mov ecx, dword ptr [ebp - 0x24]
00A4901E  add ecx, 0x78
00A49021  call 0x4a5c30
00A49026  xor eax, eax
00A49028  mov byte ptr [ebp - 0xd], al
00A4902B  movzx ecx, byte ptr [ebp - 0xd]
00A4902F  push ecx
00A49030  lea edx, [ebp - 0x18]
00A49033  push edx
00A49034  mov ecx, dword ptr [ebp - 0x24]
00A49037  add ecx, 0x78
00A4903A  call 0x4f2590
00A4903F  mov ecx, dword ptr [eax + 4]
00A49042  push ecx
00A49043  mov edx, dword ptr [eax]
00A49045  push edx
00A49046  lea eax, [ebp - 0x20]
00A49049  push eax
00A4904A  mov ecx, dword ptr [ebp - 0x24]
00A4904D  add ecx, 0x78
00A49050  call 0x4d6050
00A49055  mov ecx, dword ptr [eax + 4]
00A49058  push ecx
00A49059  mov edx, dword ptr [eax]
00A4905B  push edx
00A4905C  call 0x539910
00A49061  add esp, 0x14
00A49064  mov ecx, dword ptr [ebp - 0x24]
00A49067  call 0xa48e30
00A4906C  mov ecx, dword ptr [ebp - 0x24]
00A4906F  call 0xa47f70
00A49074  pop edi
00A49075  pop esi
00A49076  mov esp, ebp
00A49078  pop ebp
00A49079  ret 4
00A4907C  int3
00A4907D  int3
00A4907E  int3
00A4907F  int3

; range 0xa49080..0xa491a0
00A49080  push ebp
00A49081  mov ebp, esp
00A49083  sub esp, 0x1f0
00A49089  push esi
00A4908A  push edi
00A4908B  mov dword ptr [ebp - 0x1f0], ecx
00A49091  cmp dword ptr [ebp + 8], 0
00A49095  jne 0xa4909c
00A49097  jmp 0xa49189
00A4909C  mov ecx, dword ptr [ebp - 0x1f0]
00A490A2  add ecx, 0x20
00A490A5  call 0x514a70
00A490AA  movzx eax, al
00A490AD  test eax, eax
00A490AF  jne 0xa49103
00A490B1  mov ecx, dword ptr [ebp + 8]
00A490B4  movzx edx, word ptr [ecx + 0xc]
00A490B8  mov dword ptr [ebp - 0x9c], edx
00A490BE  lea eax, [ebp - 0x9c]
00A490C4  push eax
00A490C5  lea ecx, [ebp - 0xa4]
00A490CB  push ecx
00A490CC  mov ecx, dword ptr [ebp - 0x1f0]
00A490D2  add ecx, 0x20
00A490D5  call 0x532af0
00A490DA  push eax
00A490DB  lea edx, [ebp - 0x98]
00A490E1  push edx
00A490E2  mov ecx, dword ptr [ebp - 0x1f0]
00A490E8  add ecx, 0x20
00A490EB  call 0x45abb0
00A490F0  mov ecx, eax
00A490F2  call 0x4ab8f0
00A490F7  movzx eax, al
00A490FA  test eax, eax
00A490FC  je 0xa49103
00A490FE  jmp 0xa49189
00A49103  mov esi, dword ptr [ebp + 8]
00A49106  mov ecx, 0x23
00A4910B  lea edi, [ebp - 0x90]
00A49111  rep movsd dword ptr es:[edi], dword ptr [esi]
00A49113  movsb byte ptr es:[edi], byte ptr [esi]
00A49114  sub esp, 0x90
00A4911A  mov ecx, 0x23
00A4911F  lea esi, [ebp - 0x90]
00A49125  mov edi, esp
00A49127  rep movsd dword ptr es:[edi], dword ptr [esi]
00A49129  movsb byte ptr es:[edi], byte ptr [esi]
00A4912A  mov ecx, dword ptr [ebp + 8]
00A4912D  movzx edx, word ptr [ecx + 0xc]
00A49131  push edx
00A49132  lea eax, [ebp - 0x1c8]
00A49138  push eax
00A49139  call 0x539b70
00A4913E  add esp, 0x98
00A49144  push eax
00A49145  lea ecx, [ebp - 0x138]
00A4914B  call 0x539b90
00A49150  lea ecx, [ebp - 0x138]
00A49156  push ecx
00A49157  lea edx, [ebp - 0x1d4]
00A4915D  push edx
00A4915E  mov ecx, dword ptr [ebp - 0x1f0]
00A49164  add ecx, 0x20
00A49167  call 0x532920
00A4916C  lea eax, [ebp - 0x1ec]
00A49172  push eax
00A49173  mov ecx, dword ptr [ebp - 0x1f0]
00A49179  call 0xa489e0
00A4917E  lea ecx, [ebp - 0x1ec]
00A49184  call 0x4c5520
00A49189  pop edi
00A4918A  pop esi
00A4918B  mov esp, ebp
00A4918D  pop ebp
00A4918E  ret 4
00A49191  int3
00A49192  int3
00A49193  int3
00A49194  int3
00A49195  int3
00A49196  int3
00A49197  int3
00A49198  int3
00A49199  int3
00A4919A  int3
00A4919B  int3
00A4919C  int3
00A4919D  int3
00A4919E  int3
00A4919F  int3

; range 0xa48920..0xa489e0
00A48920  push ebp
00A48921  mov ebp, esp
00A48923  sub esp, 0x2c
00A48926  push esi
00A48927  push edi
00A48928  mov dword ptr [ebp - 0x2c], ecx
00A4892B  cmp dword ptr [ebp + 8], 0
00A4892F  jne 0xa48936
00A48931  jmp 0xa489d0
00A48936  mov eax, dword ptr [ebp + 8]
00A48939  add eax, 0xc
00A4893C  push eax
00A4893D  lea ecx, [ebp - 0x10]
00A48940  push ecx
00A48941  mov ecx, dword ptr [ebp - 0x2c]
00A48944  add ecx, 0x40
00A48947  call 0x4f2590
00A4894C  mov edx, dword ptr [eax + 4]
00A4894F  push edx
00A48950  mov eax, dword ptr [eax]
00A48952  push eax
00A48953  lea ecx, [ebp - 0x18]
00A48956  push ecx
00A48957  mov ecx, dword ptr [ebp - 0x2c]
00A4895A  add ecx, 0x40
00A4895D  call 0x4d6050
00A48962  mov edx, dword ptr [eax + 4]
00A48965  push edx
00A48966  mov eax, dword ptr [eax]
00A48968  push eax
00A48969  lea ecx, [ebp - 8]
00A4896C  push ecx
00A4896D  call 0x539c70
00A48972  add esp, 0x18
00A48975  lea edx, [ebp - 0x20]
00A48978  push edx
00A48979  mov ecx, dword ptr [ebp - 0x2c]
00A4897C  add ecx, 0x40
00A4897F  call 0x4f2590
00A48984  push eax
00A48985  lea ecx, [ebp - 8]
00A48988  call 0x4ab920
00A4898D  movzx eax, al
00A48990  test eax, eax
00A48992  je 0xa489ad
00A48994  mov ecx, dword ptr [ebp + 8]
00A48997  movzx edx, word ptr [ecx + 0xc]
00A4899B  mov dword ptr [ebp - 0x24], edx
00A4899E  lea eax, [ebp - 0x24]
00A489A1  push eax
00A489A2  mov ecx, dword ptr [ebp - 0x2c]
00A489A5  add ecx, 0x40
00A489A8  call 0x4a5c30
00A489AD  mov ecx, dword ptr [ebp + 8]
00A489B0  movzx edx, word ptr [ecx + 0xc]
00A489B4  mov dword ptr [ebp - 0x28], edx
00A489B7  mov esi, dword ptr [ebp + 8]
00A489BA  lea eax, [ebp - 0x28]
00A489BD  push eax
00A489BE  mov ecx, dword ptr [ebp - 0x2c]
00A489C1  call 0x532840
00A489C6  mov ecx, 0x23
00A489CB  mov edi, eax
00A489CD  rep movsd dword ptr es:[edi], dword ptr [esi]
00A489CF  movsb byte ptr es:[edi], byte ptr [esi]
00A489D0  pop edi
00A489D1  pop esi
00A489D2  mov esp, ebp
00A489D4  pop ebp
00A489D5  ret 4
00A489D8  int3
00A489D9  int3
00A489DA  int3
00A489DB  int3
00A489DC  int3
00A489DD  int3
00A489DE  int3
00A489DF  int3
