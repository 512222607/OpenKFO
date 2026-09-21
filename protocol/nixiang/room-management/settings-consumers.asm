; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 0x8062f0
008062F0 push ebp
008062F1 mov ebp, esp
008062F3 sub esp, 0x10
008062F6 mov dword ptr [ebp - 0x10], ecx
008062F9 mov eax, dword ptr [ebp - 0x10]
008062FC mov edx, dword ptr [eax]
008062FE mov ecx, dword ptr [ebp - 0x10]
00806301 mov eax, dword ptr [edx + 0x1ac]
00806307 call eax
00806309 mov ecx, dword ptr [ebp - 0x10]
0080630C mov edx, dword ptr [ecx + 0x5b0]
00806312 mov dword ptr [ebp - 0xc], edx
00806315 mov eax, dword ptr [ecx + 0x5b4]
0080631B mov dword ptr [ebp - 8], eax
0080631E mov ecx, dword ptr [0x17c86fc]
00806324 call 0x481080
00806329 mov byte ptr [ebp - 4], al
0080632C push 9
0080632E lea ecx, [ebp - 0xc]
00806331 push ecx
00806332 push 0
00806334 push 0xc44
00806339 call 0xa3c950
0080633E add esp, 0x10
00806341 mov ecx, dword ptr [ebp - 0x10]
00806344 call 0x7fc330
00806349 mov esp, ebp
0080634B pop ebp
0080634C ret
; FUNCTION 0x481080
00481080 push ebp
00481081 mov ebp, esp
00481083 push ecx
00481084 mov dword ptr [ebp - 4], ecx
00481087 mov eax, dword ptr [ebp - 4]
0048108A mov al, byte ptr [eax + 0x107c]
00481090 mov esp, ebp
00481092 pop ebp
00481093 ret
; FUNCTION 0xa2bb90
00A2BB90 push ebp
00A2BB91 mov ebp, esp
00A2BB93 sub esp, 8
00A2BB96 mov dword ptr [ebp - 8], ecx
00A2BB99 cmp dword ptr [ebp + 8], 0
00A2BB9D je 0xa2bba5
00A2BB9F cmp dword ptr [ebp + 0xc], 8
00A2BBA3 je 0xa2bba7
00A2BBA5 jmp 0xa2bbbd
00A2BBA7 mov eax, dword ptr [ebp + 8]
00A2BBAA mov dword ptr [ebp - 4], eax
00A2BBAD mov ecx, dword ptr [ebp - 4]
00A2BBB0 push ecx
00A2BBB1 call 0x7eb9b0
00A2BBB6 mov ecx, eax
00A2BBB8 call 0x7ed340
00A2BBBD mov esp, ebp
00A2BBBF pop ebp
00A2BBC0 ret 8
; FUNCTION 0xa2a8c0
00A2A8C0 push ebp
00A2A8C1 mov ebp, esp
00A2A8C3 sub esp, 8
00A2A8C6 mov dword ptr [ebp - 8], ecx
00A2A8C9 cmp dword ptr [ebp + 8], 0
00A2A8CD jne 0xa2a8d1
00A2A8CF jmp 0xa2a917
00A2A8D1 mov eax, dword ptr [ebp + 8]
00A2A8D4 mov dword ptr [ebp - 4], eax
00A2A8D7 mov ecx, dword ptr [ebp - 4]
00A2A8DA push ecx
00A2A8DB call 0x926d50
00A2A8E0 mov ecx, eax
00A2A8E2 call 0x928840
00A2A8E7 mov edx, dword ptr [ebp - 4]
00A2A8EA push edx
00A2A8EB call 0x92bb30
00A2A8F0 mov ecx, eax
00A2A8F2 call 0x928840
00A2A8F7 mov eax, dword ptr [ebp - 4]
00A2A8FA push eax
00A2A8FB call 0x926ba0
00A2A900 mov ecx, eax
00A2A902 call 0x928840
00A2A907 mov ecx, dword ptr [ebp - 4]
00A2A90A push ecx
00A2A90B call 0x41cd00
00A2A910 mov ecx, eax
00A2A912 call 0x7f5770
00A2A917 mov esp, ebp
00A2A919 pop ebp
00A2A91A ret 8
; FUNCTION 0xa2a7d0
00A2A7D0 push ebp
00A2A7D1 mov ebp, esp
00A2A7D3 push -1
00A2A7D5 push 0xaca18c
00A2A7DA mov eax, dword ptr fs:[0]
00A2A7E0 push eax
00A2A7E1 sub esp, 0x30
00A2A7E4 push esi
00A2A7E5 mov eax, dword ptr [0xc7b480]
00A2A7EA xor eax, ebp
00A2A7EC push eax
00A2A7ED lea eax, [ebp - 0xc]
00A2A7F0 mov dword ptr fs:[0], eax
00A2A7F6 mov dword ptr [ebp - 0x3c], ecx
00A2A7F9 cmp dword ptr [ebp + 8], 0
00A2A7FD jne 0xa2a804
00A2A7FF jmp 0xa2a8a5
00A2A804 lea ecx, [ebp - 0x34]
00A2A807 call 0x406590
00A2A80C mov dword ptr [ebp - 4], 0
00A2A813 lea ecx, [ebp - 0x34]
00A2A816 call 0x41ce40
00A2A81B mov eax, dword ptr [ebp + 0xc]
00A2A81E xor edx, edx
00A2A820 mov ecx, 0x18
00A2A825 div ecx
00A2A827 mov dword ptr [ebp - 0x10], eax
00A2A82A mov edx, dword ptr [ebp + 8]
00A2A82D mov dword ptr [ebp - 0x14], edx
00A2A830 mov dword ptr [ebp - 0x38], 0
00A2A837 jmp 0xa2a842
00A2A839 mov eax, dword ptr [ebp - 0x38]
00A2A83C add eax, 1
00A2A83F mov dword ptr [ebp - 0x38], eax
00A2A842 mov ecx, dword ptr [ebp - 0x38]
00A2A845 cmp ecx, dword ptr [ebp - 0x10]
00A2A848 jge 0xa2a886
00A2A84A mov esi, dword ptr [ebp - 0x14]
00A2A84D mov edx, dword ptr [ebp - 0x14]
00A2A850 push edx
00A2A851 lea ecx, [ebp - 0x34]
00A2A854 call 0x41cd20
00A2A859 mov ecx, dword ptr [esi]
00A2A85B mov dword ptr [eax], ecx
00A2A85D mov edx, dword ptr [esi + 4]
00A2A860 mov dword ptr [eax + 4], edx
00A2A863 mov ecx, dword ptr [esi + 8]
00A2A866 mov dword ptr [eax + 8], ecx
00A2A869 mov edx, dword ptr [esi + 0xc]
00A2A86C mov dword ptr [eax + 0xc], edx
00A2A86F mov ecx, dword ptr [esi + 0x10]
00A2A872 mov dword ptr [eax + 0x10], ecx
00A2A875 mov edx, dword ptr [esi + 0x14]
00A2A878 mov dword ptr [eax + 0x14], edx
00A2A87B mov eax, dword ptr [ebp - 0x14]
00A2A87E add eax, 0x18
00A2A881 mov dword ptr [ebp - 0x14], eax
00A2A884 jmp 0xa2a839
00A2A886 lea ecx, [ebp - 0x34]
00A2A889 push ecx
00A2A88A call 0x41cd00
00A2A88F mov ecx, eax
00A2A891 call 0x7f58a0
00A2A896 mov dword ptr [ebp - 4], 0xffffffff
00A2A89D lea ecx, [ebp - 0x34]
00A2A8A0 call 0x41c760
00A2A8A5 mov ecx, dword ptr [ebp - 0xc]
00A2A8A8 mov dword ptr fs:[0], ecx
00A2A8AF pop ecx
00A2A8B0 pop esi
00A2A8B1 mov esp, ebp
00A2A8B3 pop ebp
00A2A8B4 ret 8
; FUNCTION 0xa2bfb0
00A2BFB0 push ebp
00A2BFB1 mov ebp, esp
00A2BFB3 sub esp, 8
00A2BFB6 mov dword ptr [ebp - 8], ecx
00A2BFB9 cmp dword ptr [ebp + 8], 0
00A2BFBD jne 0xa2bfc1
00A2BFBF jmp 0xa2bfd7
00A2BFC1 mov eax, dword ptr [ebp + 8]
00A2BFC4 mov dword ptr [ebp - 4], eax
00A2BFC7 mov ecx, dword ptr [ebp - 4]
00A2BFCA push ecx
00A2BFCB call 0x41bdf0
00A2BFD0 mov ecx, eax
00A2BFD2 call 0x806d40
00A2BFD7 mov esp, ebp
00A2BFD9 pop ebp
00A2BFDA ret 8
; FUNCTION 0x928840
00928840 push ebp
00928841 mov ebp, esp
00928843 push -1
00928845 push 0xac8834
0092884A mov eax, dword ptr fs:[0]
00928850 push eax
00928851 sub esp, 0x490
00928857 mov eax, dword ptr [0xc7b480]
0092885C xor eax, ebp
0092885E mov dword ptr [ebp - 0x48], eax
00928861 push esi
00928862 push edi
00928863 push eax
00928864 lea eax, [ebp - 0xc]
00928867 mov dword ptr fs:[0], eax
0092886D mov dword ptr [ebp - 0x3c4], ecx
00928873 mov esi, dword ptr [ebp + 8]
00928876 mov edi, dword ptr [ebp - 0x3c4]
0092887C add edi, 0x5a4
00928882 mov ecx, 0x65
00928887 rep movsd dword ptr es:[edi], dword ptr [esi]
00928889 mov ecx, dword ptr [ebp - 0x3c4]
0092888F add ecx, 0x738
00928895 call 0x4998d0
0092889A mov eax, dword ptr [ebp - 0x3c4]
009288A0 add eax, 0x738
009288A5 push eax
009288A6 sub esp, 0x1c
009288A9 mov ecx, esp
009288AB mov dword ptr [ebp - 0xf4], esp
009288B1 push 0xb9c808
009288B6 call 0x405650
009288BB mov dword ptr [ebp - 0x3c8], eax
009288C1 mov ecx, dword ptr [ebp - 0x3c8]
009288C7 mov dword ptr [ebp - 0x3cc], ecx
009288CD mov dword ptr [ebp - 4], 0
009288D4 mov edx, dword ptr [ebp - 0x3c4]
009288DA add edx, 0x5a8
009288E0 sub esp, 0x1c
009288E3 mov ecx, esp
009288E5 mov dword ptr [ebp - 0xf8], esp
009288EB push edx
009288EC call 0x405650
009288F1 mov dword ptr [ebp - 0x3d0], eax
009288F7 mov dword ptr [ebp - 4], 0xffffffff
009288FE call 0x661a70
00928903 add esp, 0x3c
00928906 mov dword ptr [ebp - 0x10], 0
0092890D jmp 0x928918
0092890F mov eax, dword ptr [ebp - 0x10]
00928912 add eax, 1
00928915 mov dword ptr [ebp - 0x10], eax
00928918 cmp dword ptr [ebp - 0x10], 9
0092891C jg 0x9292f3
00928922 lea ecx, [ebp - 0x10]
00928925 push ecx
00928926 lea edx, [ebp - 0x114]
0092892C push edx
0092892D call 0xa44160
00928932 add esp, 8
00928935 mov dword ptr [ebp - 0x3d4], eax
0092893B mov eax, dword ptr [ebp - 0x3d4]
00928941 mov dword ptr [ebp - 0x3d8], eax
00928947 mov dword ptr [ebp - 4], 1
0092894E mov ecx, dword ptr [ebp - 0x3d8]
00928954 push ecx
00928955 push 0xb9a004
0092895A lea edx, [ebp - 0x130]
00928960 push edx
00928961 call 0x411d70
00928966 add esp, 0xc
00928969 mov dword ptr [ebp - 0x3dc], eax
0092896F mov eax, dword ptr [ebp - 0x3dc]
00928975 mov dword ptr [ebp - 0x3e0], eax
0092897B mov byte ptr [ebp - 4], 2
0092897F mov ecx, dword ptr [ebp - 0x3e0]
00928985 push ecx
00928986 mov ecx, dword ptr [ebp - 0x3c4]
0092898C call 0x75fbf0
00928991 mov dword ptr [ebp - 0x18], eax
00928994 mov byte ptr [ebp - 4], 1
00928998 lea ecx, [ebp - 0x130]
0092899E call 0x4056d0
009289A3 mov dword ptr [ebp - 4], 0xffffffff
009289AA lea ecx, [ebp - 0x114]
009289B0 call 0x4056d0
009289B5 cmp dword ptr [ebp - 0x18], 0
009289B9 jne 0x9289c0
009289BB jmp 0x92890f
009289C0 lea edx, [ebp - 0x10]
009289C3 push edx
009289C4 lea eax, [ebp - 0x14c]
009289CA push eax
009289CB call 0xa44160
009289D0 add esp, 8
009289D3 mov dword ptr [ebp - 0x3e4], eax
009289D9 mov ecx, dword ptr [ebp - 0x3e4]
009289DF mov dword ptr [ebp - 0x3e8], ecx
009289E5 mov dword ptr [ebp - 4], 3
009289EC mov edx, dword ptr [ebp - 0x3e8]
009289F2 push edx
009289F3 push 0xb9a014
009289F8 lea eax, [ebp - 0x168]
009289FE push eax
009289FF call 0x411d70
00928A04 add esp, 0xc
00928A07 mov dword ptr [ebp - 0x3ec], eax
00928A0D mov ecx, dword ptr [ebp - 0x3ec]
00928A13 mov dword ptr [ebp - 0x3f0], ecx
00928A19 mov byte ptr [ebp - 4], 4
00928A1D push 0
00928A1F mov edx, dword ptr [ebp - 0x3f0]
00928A25 push edx
00928A26 mov ecx, dword ptr [ebp - 0x3c4]
00928A2C call 0x7611c0
00928A31 mov byte ptr [ebp - 4], 3
00928A35 lea ecx, [ebp - 0x168]
00928A3B call 0x4056d0
00928A40 mov dword ptr [ebp - 4], 0xffffffff
00928A47 lea ecx, [ebp - 0x14c]
00928A4D call 0x4056d0
00928A52 lea eax, [ebp - 0x10]
00928A55 push eax
00928A56 lea ecx, [ebp - 0x184]
00928A5C push ecx
00928A5D call 0xa44160
00928A62 add esp, 8
00928A65 mov dword ptr [ebp - 0x3f4], eax
00928A6B mov edx, dword ptr [ebp - 0x3f4]
00928A71 mov dword ptr [ebp - 0x3f8], edx
00928A77 mov dword ptr [ebp - 4], 5
00928A7E mov eax, dword ptr [ebp - 0x3f8]
00928A84 push eax
00928A85 push 0xb9a01c
00928A8A lea ecx, [ebp - 0x1a0]
00928A90 push ecx
00928A91 call 0x411d70
00928A96 add esp, 0xc
00928A99 mov dword ptr [ebp - 0x3fc], eax
00928A9F mov edx, dword ptr [ebp - 0x3fc]
00928AA5 mov dword ptr [ebp - 0x400], edx
00928AAB mov byte ptr [ebp - 4], 6
00928AAF push 0
00928AB1 mov eax, dword ptr [ebp - 0x400]
00928AB7 push eax
00928AB8 mov ecx, dword ptr [ebp - 0x3c4]
00928ABE call 0x7611c0
00928AC3 mov byte ptr [ebp - 4], 5
00928AC7 lea ecx, [ebp - 0x1a0]
00928ACD call 0x4056d0
00928AD2 mov dword ptr [ebp - 4], 0xffffffff
00928AD9 lea ecx, [ebp - 0x184]
00928ADF call 0x4056d0
00928AE4 lea ecx, [ebp - 0x10]
00928AE7 push ecx
00928AE8 lea edx, [ebp - 0x1bc]
00928AEE push edx
00928AEF call 0xa44160
00928AF4 add esp, 8
00928AF7 mov dword ptr [ebp - 0x404], eax
00928AFD mov eax, dword ptr [ebp - 0x404]
00928B03 mov dword ptr [ebp - 0x408], eax
00928B09 mov dword ptr [ebp - 4], 7
00928B10 mov ecx, dword ptr [ebp - 0x408]
00928B16 push ecx
00928B17 push 0xb9a028
00928B1C lea edx, [ebp - 0x1d8]
00928B22 push edx
00928B23 call 0x411d70
00928B28 add esp, 0xc
00928B2B mov dword ptr [ebp - 0x40c], eax
00928B31 mov eax, dword ptr [ebp - 0x40c]
00928B37 mov dword ptr [ebp - 0x410], eax
00928B3D mov byte ptr [ebp - 4], 8
00928B41 push 0
00928B43 mov ecx, dword ptr [ebp - 0x410]
00928B49 push ecx
00928B4A mov ecx, dword ptr [ebp - 0x3c4]
00928B50 call 0x7611c0
00928B55 mov byte ptr [ebp - 4], 7
00928B59 lea ecx, [ebp - 0x1d8]
00928B5F call 0x4056d0
00928B64 mov dword ptr [ebp - 4], 0xffffffff
00928B6B lea ecx, [ebp - 0x1bc]
00928B71 call 0x4056d0
00928B76 lea edx, [ebp - 0x10]
00928B79 push edx
00928B7A lea eax, [ebp - 0x1f4]
00928B80 push eax
00928B81 call 0xa44160
00928B86 add esp, 8
00928B89 mov dword ptr [ebp - 0x414], eax
00928B8F mov ecx, dword ptr [ebp - 0x414]
00928B95 mov dword ptr [ebp - 0x418], ecx
00928B9B mov dword ptr [ebp - 4], 9
00928BA2 mov edx, dword ptr [ebp - 0x418]
00928BA8 push edx
00928BA9 push 0xb9a030
00928BAE lea eax, [ebp - 0x210]
00928BB4 push eax
00928BB5 call 0x411d70
00928BBA add esp, 0xc
00928BBD mov dword ptr [ebp - 0x41c], eax
00928BC3 mov ecx, dword ptr [ebp - 0x41c]
00928BC9 mov dword ptr [ebp - 0x420], ecx
00928BCF mov byte ptr [ebp - 4], 0xa
00928BD3 push 0
00928BD5 mov edx, dword ptr [ebp - 0x420]
00928BDB push edx
00928BDC mov ecx, dword ptr [ebp - 0x3c4]
00928BE2 call 0x7611c0
00928BE7 mov byte ptr [ebp - 4], 9
00928BEB lea ecx, [ebp - 0x210]
00928BF1 call 0x4056d0
00928BF6 mov dword ptr [ebp - 4], 0xffffffff
00928BFD lea ecx, [ebp - 0x1f4]
00928C03 call 0x4056d0
00928C08 lea ecx, [ebp - 0x38]
00928C0B call 0x473c00
00928C10 mov dword ptr [ebp - 4], 0xb
00928C17 mov eax, dword ptr [ebp - 0x3c4]
00928C1D cmp dword ptr [eax + 0x580], 1
00928C24 jne 0x928c7e
00928C26 mov ecx, dword ptr [ebp - 0x10]
00928C29 push ecx
00928C2A mov edx, dword ptr [ebp - 0x3c4]
00928C30 mov eax, dword ptr [edx + 0x578]
00928C36 push eax
00928C37 lea ecx, [ebp - 0x228]
00928C3D push ecx
00928C3E call 0xa54bd0
00928C43 mov ecx, eax
00928C45 call 0xa54900
00928C4A mov dword ptr [ebp - 0x424], eax
00928C50 mov edx, dword ptr [ebp - 0x424]
00928C56 mov dword ptr [ebp - 0x428], edx
00928C5C mov byte ptr [ebp - 4], 0xc
00928C60 mov eax, dword ptr [ebp - 0x428]
00928C66 push eax
00928C67 lea ecx, [ebp - 0x38]
00928C6A call 0x4e6a60
00928C6F mov byte ptr [ebp - 4], 0xb
00928C73 lea ecx, [ebp - 0x228]
00928C79 call 0x48b730
00928C7E mov ecx, dword ptr [ebp - 0x3c4]
00928C84 cmp dword ptr [ecx + 0x580], 2
00928C8B jne 0x928ce5
00928C8D mov edx, dword ptr [ebp - 0x10]
00928C90 push edx
00928C91 mov eax, dword ptr [ebp - 0x3c4]
00928C97 mov ecx, dword ptr [eax + 0x578]
00928C9D push ecx
00928C9E lea edx, [ebp - 0x240]
00928CA4 push edx
00928CA5 call 0xa54bd0
00928CAA mov ecx, eax
00928CAC call 0xa54750
00928CB1 mov dword ptr [ebp - 0x42c], eax
00928CB7 mov eax, dword ptr [ebp - 0x42c]
00928CBD mov dword ptr [ebp - 0x430], eax
00928CC3 mov byte ptr [ebp - 4], 0xd
00928CC7 mov ecx, dword ptr [ebp - 0x430]
00928CCD push ecx
00928CCE lea ecx, [ebp - 0x38]
00928CD1 call 0x4e6a60
00928CD6 mov byte ptr [ebp - 4], 0xb
00928CDA lea ecx, [ebp - 0x240]
00928CE0 call 0x48b730
00928CE5 mov edx, dword ptr [ebp - 0x3c4]
00928CEB cmp dword ptr [edx + 0x580], 3
00928CF2 jne 0x928d4c
00928CF4 mov eax, dword ptr [ebp - 0x10]
00928CF7 push eax
00928CF8 mov ecx, dword ptr [ebp - 0x3c4]
00928CFE mov edx, dword ptr [ecx + 0x578]
00928D04 push edx
00928D05 lea eax, [ebp - 0x258]
00928D0B push eax
00928D0C call 0xa54bd0
00928D11 mov ecx, eax
00928D13 call 0xa54670
00928D18 mov dword ptr [ebp - 0x434], eax
00928D1E mov ecx, dword ptr [ebp - 0x434]
00928D24 mov dword ptr [ebp - 0x438], ecx
00928D2A mov byte ptr [ebp - 4], 0xe
00928D2E mov edx, dword ptr [ebp - 0x438]
00928D34 push edx
00928D35 lea ecx, [ebp - 0x38]
00928D38 call 0x4e6a60
00928D3D mov byte ptr [ebp - 4], 0xb
00928D41 lea ecx, [ebp - 0x258]
00928D47 call 0x48b730
00928D4C mov byte ptr [ebp - 0x19], 0
00928D50 mov byte ptr [ebp - 0x11], 1
00928D54 mov dword ptr [ebp - 0x3c], 0
00928D5B jmp 0x928d66
00928D5D mov eax, dword ptr [ebp - 0x3c]
00928D60 add eax, 1
00928D63 mov dword ptr [ebp - 0x3c], eax
00928D66 lea ecx, [ebp - 0x38]
00928D69 call 0x474c50
00928D6E cmp dword ptr [ebp - 0x3c], eax
00928D71 jae 0x929175
00928D77 mov ecx, dword ptr [ebp - 0x3c]
00928D7A push ecx
00928D7B lea ecx, [ebp - 0x38]
00928D7E call 0x43bfe0
00928D83 mov dword ptr [ebp - 0x68], eax
00928D86 lea ecx, [ebp - 0xec]
00928D8C call 0x481440
00928D91 mov byte ptr [ebp - 4], 0xf
00928D95 lea edx, [ebp - 0xec]
00928D9B push edx
00928D9C mov eax, dword ptr [ebp - 0x68]
00928D9F mov ecx, dword ptr [eax + 0x10]
00928DA2 push ecx
00928DA3 mov edx, dword ptr [ebp - 0x68]
00928DA6 mov eax, dword ptr [edx + 0xc]
00928DA9 push eax
00928DAA call 0xa55fb0
00928DAF mov ecx, eax
00928DB1 call 0xa56090
00928DB6 mov dword ptr [ebp - 0xf0], eax
00928DBC cmp dword ptr [ebp - 0xf0], 0
00928DC3 jne 0x928dd6
00928DC5 mov byte ptr [ebp - 4], 0xb
00928DC9 lea ecx, [ebp - 0xec]
00928DCF call 0x481460
00928DD4 jmp 0x928d5d
00928DD6 cmp dword ptr [ebp - 0x90], 0
00928DDD je 0x928de8
00928DDF cmp dword ptr [ebp - 0x90], 3
00928DE6 jne 0x928dfc
00928DE8 mov byte ptr [ebp - 4], 0xb
00928DEC lea ecx, [ebp - 0xec]
00928DF2 call 0x481460
00928DF7 jmp 0x928d5d
00928DFC lea ecx, [ebp - 0x64]
00928DFF call 0x405620
00928E04 mov byte ptr [ebp - 4], 0x10
00928E08 mov ecx, dword ptr [ebp - 0x68]
00928E0B mov edx, dword ptr [ecx + 8]
00928E0E mov dword ptr [ebp - 0x43c], edx
00928E14 mov eax, dword ptr [ebp - 0x43c]
00928E1A sub eax, 1
00928E1D mov dword ptr [ebp - 0x43c], eax
00928E23 cmp dword ptr [ebp - 0x43c], 3
00928E2A ja 0x929068
00928E30 mov ecx, dword ptr [ebp - 0x43c]
00928E36 jmp dword ptr [ecx*4 + 0x929310]
00928E3D lea edx, [ebp - 0x10]
00928E40 push edx
00928E41 lea eax, [ebp - 0x274]
00928E47 push eax
00928E48 call 0xa44160
00928E4D add esp, 8
00928E50 mov dword ptr [ebp - 0x440], eax
00928E56 mov ecx, dword ptr [ebp - 0x440]
00928E5C mov dword ptr [ebp - 0x444], ecx
00928E62 mov byte ptr [ebp - 4], 0x11
00928E66 mov edx, dword ptr [ebp - 0x444]
00928E6C push edx
00928E6D push 0xb9a014
00928E72 lea eax, [ebp - 0x290]
00928E78 push eax
00928E79 call 0x411d70
00928E7E add esp, 0xc
00928E81 mov dword ptr [ebp - 0x448], eax
00928E87 mov ecx, dword ptr [ebp - 0x448]
00928E8D mov dword ptr [ebp - 0x44c], ecx
00928E93 mov byte ptr [ebp - 4], 0x12
00928E97 mov edx, dword ptr [ebp - 0x44c]
00928E9D push edx
00928E9E lea ecx, [ebp - 0x64]
00928EA1 call 0x4056f0
00928EA6 mov byte ptr [ebp - 4], 0x11
00928EAA lea ecx, [ebp - 0x290]
00928EB0 call 0x4056d0
00928EB5 mov byte ptr [ebp - 4], 0x10
00928EB9 lea ecx, [ebp - 0x274]
00928EBF call 0x4056d0
00928EC4 jmp 0x929068
00928EC9 lea eax, [ebp - 0x10]
00928ECC push eax
00928ECD lea ecx, [ebp - 0x2ac]
00928ED3 push ecx
00928ED4 call 0xa44160
00928ED9 add esp, 8
00928EDC mov dword ptr [ebp - 0x450], eax
00928EE2 mov edx, dword ptr [ebp - 0x450]
00928EE8 mov dword ptr [ebp - 0x454], edx
00928EEE mov byte ptr [ebp - 4], 0x13
00928EF2 mov eax, dword ptr [ebp - 0x454]
00928EF8 push eax
00928EF9 push 0xb9a01c
00928EFE lea ecx, [ebp - 0x2c8]
00928F04 push ecx
00928F05 call 0x411d70
00928F0A add esp, 0xc
00928F0D mov dword ptr [ebp - 0x458], eax
00928F13 mov edx, dword ptr [ebp - 0x458]
00928F19 mov dword ptr [ebp - 0x45c], edx
00928F1F mov byte ptr [ebp - 4], 0x14
00928F23 mov eax, dword ptr [ebp - 0x45c]
00928F29 push eax
00928F2A lea ecx, [ebp - 0x64]
00928F2D call 0x4056f0
00928F32 mov byte ptr [ebp - 4], 0x13
00928F36 lea ecx, [ebp - 0x2c8]
00928F3C call 0x4056d0
00928F41 mov byte ptr [ebp - 4], 0x10
00928F45 lea ecx, [ebp - 0x2ac]
00928F4B call 0x4056d0
00928F50 jmp 0x929068
00928F55 lea ecx, [ebp - 0x10]
00928F58 push ecx
00928F59 lea edx, [ebp - 0x2e4]
00928F5F push edx
00928F60 call 0xa44160
00928F65 add esp, 8
00928F68 mov dword ptr [ebp - 0x460], eax
00928F6E mov eax, dword ptr [ebp - 0x460]
00928F74 mov dword ptr [ebp - 0x464], eax
00928F7A mov byte ptr [ebp - 4], 0x15
00928F7E mov ecx, dword ptr [ebp - 0x464]
00928F84 push ecx
00928F85 push 0xb9a028
00928F8A lea edx, [ebp - 0x300]
00928F90 push edx
00928F91 call 0x411d70
00928F96 add esp, 0xc
00928F99 mov dword ptr [ebp - 0x468], eax
00928F9F mov eax, dword ptr [ebp - 0x468]
00928FA5 mov dword ptr [ebp - 0x46c], eax
00928FAB mov byte ptr [ebp - 4], 0x16
00928FAF mov ecx, dword ptr [ebp - 0x46c]
00928FB5 push ecx
00928FB6 lea ecx, [ebp - 0x64]
00928FB9 call 0x4056f0
00928FBE mov byte ptr [ebp - 4], 0x15
00928FC2 lea ecx, [ebp - 0x300]
00928FC8 call 0x4056d0
00928FCD mov byte ptr [ebp - 4], 0x10
00928FD1 lea ecx, [ebp - 0x2e4]
00928FD7 call 0x4056d0
00928FDC jmp 0x929068
00928FE1 lea edx, [ebp - 0x10]
00928FE4 push edx
00928FE5 lea eax, [ebp - 0x31c]
00928FEB push eax
00928FEC call 0xa44160
00928FF1 add esp, 8
00928FF4 mov dword ptr [ebp - 0x470], eax
00928FFA mov ecx, dword ptr [ebp - 0x470]
00929000 mov dword ptr [ebp - 0x474], ecx
00929006 mov byte ptr [ebp - 4], 0x17
0092900A mov edx, dword ptr [ebp - 0x474]
00929010 push edx
00929011 push 0xb9a030
00929016 lea eax, [ebp - 0x338]
0092901C push eax
0092901D call 0x411d70
00929022 add esp, 0xc
00929025 mov dword ptr [ebp - 0x478], eax
0092902B mov ecx, dword ptr [ebp - 0x478]
00929031 mov dword ptr [ebp - 0x47c], ecx
00929037 mov byte ptr [ebp - 4], 0x18
0092903B mov edx, dword ptr [ebp - 0x47c]
00929041 push edx
00929042 lea ecx, [ebp - 0x64]
00929045 call 0x4056f0
0092904A mov byte ptr [ebp - 4], 0x17
0092904E lea ecx, [ebp - 0x338]
00929054 call 0x4056d0
00929059 mov byte ptr [ebp - 4], 0x10
0092905D lea ecx, [ebp - 0x31c]
00929063 call 0x4056d0
00929068 push 1
0092906A lea eax, [ebp - 0x64]
0092906D push eax
0092906E mov ecx, dword ptr [ebp - 0x3c4]
00929074 call 0x7611c0
00929079 lea ecx, [ebp - 0x44]
0092907C call 0x471ae0
00929081 lea ecx, [ebp - 0x340]
00929087 push ecx
00929088 mov ecx, dword ptr [ebp - 0x3c4]
0092908E add ecx, 0x738
00929094 call 0x4d6050
00929099 mov edx, dword ptr [eax]
0092909B mov eax, dword ptr [eax + 4]
0092909E mov dword ptr [ebp - 0x44], edx
009290A1 mov dword ptr [ebp - 0x40], eax
009290A4 jmp 0x9290b7
009290A6 push 0
009290A8 lea ecx, [ebp - 0x348]
009290AE push ecx
009290AF lea ecx, [ebp - 0x44]
009290B2 call 0x4e6c80
009290B7 lea edx, [ebp - 0x350]
009290BD push edx
009290BE mov ecx, dword ptr [ebp - 0x3c4]
009290C4 add ecx, 0x738
009290CA call 0x4f2590
009290CF push eax
009290D0 lea ecx, [ebp - 0x44]
009290D3 call 0x4ab8f0
009290D8 movzx eax, al
009290DB test eax, eax
009290DD je 0x929151
009290DF lea ecx, [ebp - 0x44]
009290E2 call 0x4e19a0
009290E7 push eax
009290E8 call 0x4e6d90
009290ED add esp, 4
009290F0 mov ecx, dword ptr [ebp - 0x68]
009290F3 cmp eax, dword ptr [ecx + 0xc]
009290F6 jne 0x929136
009290F8 push 1
009290FA lea edx, [ebp - 0x64]
009290FD push edx
009290FE mov ecx, dword ptr [ebp - 0x3c4]
00929104 call 0x7603d0
00929109 movzx eax, byte ptr [ebp - 0x11]
0092910D test eax, eax
0092910F je 0x929132
00929111 lea ecx, [ebp - 0x10]
00929114 push ecx
00929115 mov ecx, dword ptr [ebp - 0x3c4]
0092911B add ecx, 0x584
00929121 call 0x4b6920
00929126 mov edx, dword ptr [ebp - 0x68]
00929129 mov ecx, dword ptr [edx + 8]
0092912C mov dword ptr [eax], ecx
0092912E mov byte ptr [ebp - 0x11], 0
00929132 jmp 0x929151
00929134 jmp 0x92914c
00929136 push 0
00929138 lea edx, [ebp - 0x64]
0092913B push edx
0092913C mov ecx, dword ptr [ebp - 0x3c4]
00929142 call 0x7603d0
00929147 jmp 0x9290a6
0092914C jmp 0x9290a6
00929151 mov byte ptr [ebp - 0x19], 1
00929155 mov byte ptr [ebp - 4], 0xf
00929159 lea ecx, [ebp - 0x64]
0092915C call 0x4056d0
00929161 mov byte ptr [ebp - 4], 0xb
00929165 lea ecx, [ebp - 0xec]
0092916B call 0x481460
00929170 jmp 0x928d5d
00929175 lea eax, [ebp - 0x10]
00929178 push eax
00929179 lea ecx, [ebp - 0x36c]
0092917F push ecx
00929180 call 0xa44160
00929185 add esp, 8
00929188 mov dword ptr [ebp - 0x480], eax
0092918E mov edx, dword ptr [ebp - 0x480]
00929194 mov dword ptr [ebp - 0x484], edx
0092919A mov byte ptr [ebp - 4], 0x19
0092919E mov eax, dword ptr [ebp - 0x484]
009291A4 push eax
009291A5 push 0xb99fc0
009291AA lea ecx, [ebp - 0x388]
009291B0 push ecx
009291B1 call 0x411d70
009291B6 add esp, 0xc
009291B9 mov dword ptr [ebp - 0x488], eax
009291BF mov edx, dword ptr [ebp - 0x488]
009291C5 mov dword ptr [ebp - 0x48c], edx
009291CB mov byte ptr [ebp - 4], 0x1a
009291CF movzx eax, byte ptr [ebp - 0x19]
009291D3 push eax
009291D4 mov ecx, dword ptr [ebp - 0x48c]
009291DA push ecx
009291DB mov ecx, dword ptr [ebp - 0x3c4]
009291E1 call 0x7603d0
009291E6 mov byte ptr [ebp - 4], 0x19
009291EA lea ecx, [ebp - 0x388]
009291F0 call 0x4056d0
009291F5 mov byte ptr [ebp - 4], 0xb
009291F9 lea ecx, [ebp - 0x36c]
009291FF call 0x4056d0
00929204 lea edx, [ebp - 0x10]
00929207 push edx
00929208 mov ecx, dword ptr [ebp - 0x3c4]
0092920E add ecx, 0x584
00929214 call 0x4b6920
00929219 mov eax, dword ptr [eax]
0092921B push eax
0092921C mov ecx, dword ptr [ebp - 0x10]
0092921F push ecx
00929220 mov ecx, dword ptr [ebp - 0x3c4]
00929226 call 0x9280e0
0092922B lea edx, [ebp - 0x10]
0092922E push edx
0092922F lea eax, [ebp - 0x3a4]
00929235 push eax
00929236 call 0xa44160
0092923B add esp, 8
0092923E mov dword ptr [ebp - 0x490], eax
00929244 mov ecx, dword ptr [ebp - 0x490]
0092924A mov dword ptr [ebp - 0x494], ecx
00929250 mov byte ptr [ebp - 4], 0x1b
00929254 mov edx, dword ptr [ebp - 0x494]
0092925A push edx
0092925B push 0xb99fe8
00929260 lea eax, [ebp - 0x3c0]
00929266 push eax
00929267 call 0x411d70
0092926C add esp, 0xc
0092926F mov dword ptr [ebp - 0x498], eax
00929275 mov ecx, dword ptr [ebp - 0x498]
0092927B mov dword ptr [ebp - 0x49c], ecx
00929281 mov byte ptr [ebp - 4], 0x1c
00929285 push 0
00929287 push 0x12f9290
0092928C push 0x12f8898
00929291 push 0
00929293 mov edx, dword ptr [ebp - 0x49c]
00929299 push edx
0092929A mov ecx, dword ptr [ebp - 0x3c4]
009292A0 call 0x75fbf0
009292A5 push eax
009292A6 call 0xa97b0e
009292AB add esp, 0x14
009292AE mov dword ptr [ebp - 0x20], eax
009292B1 mov byte ptr [ebp - 4], 0x1b
009292B5 lea ecx, [ebp - 0x3c0]
009292BB call 0x4056d0
009292C0 mov byte ptr [ebp - 4], 0xb
009292C4 lea ecx, [ebp - 0x3a4]
009292CA call 0x4056d0
009292CF cmp dword ptr [ebp - 0x20], 0
009292D3 je 0x9292df
009292D5 push 0
009292D7 mov ecx, dword ptr [ebp - 0x20]
009292DA call 0x7455e0
009292DF mov dword ptr [ebp - 4], 0xffffffff
009292E6 lea ecx, [ebp - 0x38]
009292E9 call 0x48b730
009292EE jmp 0x92890f
009292F3 mov ecx, dword ptr [ebp - 0xc]
009292F6 mov dword ptr fs:[0], ecx
009292FD pop ecx
009292FE pop edi
009292FF pop esi
00929300 mov ecx, dword ptr [ebp - 0x48]
00929303 xor ecx, ebp
00929305 call 0x6634fb
0092930A mov esp, ebp
0092930C pop ebp
0092930D ret 4
; FUNCTION 0x7f5770
007F5770 push ebp
007F5771 mov ebp, esp
007F5773 push -1
007F5775 push 0xa9dd38
007F577A mov eax, dword ptr fs:[0]
007F5780 push eax
007F5781 sub esp, 0x20
007F5784 push esi
007F5785 push edi
007F5786 mov eax, dword ptr [0xc7b480]
007F578B xor eax, ebp
007F578D push eax
007F578E lea eax, [ebp - 0xc]
007F5791 mov dword ptr fs:[0], eax
007F5797 mov dword ptr [ebp - 0x1c], ecx
007F579A mov esi, dword ptr [ebp + 8]
007F579D mov edi, dword ptr [ebp - 0x1c]
007F57A0 add edi, 0x6a4
007F57A6 mov ecx, 0x65
007F57AB rep movsd dword ptr es:[edi], dword ptr [esi]
007F57AD mov ecx, dword ptr [ebp - 0x1c]
007F57B0 add ecx, 0x838
007F57B6 call 0x4998d0
007F57BB mov eax, dword ptr [ebp - 0x1c]
007F57BE add eax, 0x838
007F57C3 push eax
007F57C4 sub esp, 0x1c
007F57C7 mov ecx, esp
007F57C9 mov dword ptr [ebp - 0x14], esp
007F57CC push 0xb9c808
007F57D1 call 0x405650
007F57D6 mov dword ptr [ebp - 0x20], eax
007F57D9 mov ecx, dword ptr [ebp - 0x20]
007F57DC mov dword ptr [ebp - 0x24], ecx
007F57DF mov dword ptr [ebp - 4], 0
007F57E6 mov edx, dword ptr [ebp - 0x1c]
007F57E9 add edx, 0x6a8
007F57EF sub esp, 0x1c
007F57F2 mov ecx, esp
007F57F4 mov dword ptr [ebp - 0x18], esp
007F57F7 push edx
007F57F8 call 0x405650
007F57FD mov dword ptr [ebp - 0x28], eax
007F5800 mov dword ptr [ebp - 4], 0xffffffff
007F5807 call 0x661a70
007F580C add esp, 0x3c
007F580F mov dword ptr [ebp - 0x2c], eax
007F5812 mov eax, dword ptr [ebp - 0x2c]
007F5815 mov dword ptr [ebp - 0x10], eax
007F5818 mov ecx, dword ptr [ebp - 0xc]
007F581B mov dword ptr fs:[0], ecx
007F5822 pop ecx
007F5823 pop edi
007F5824 pop esi
007F5825 mov esp, ebp
007F5827 pop ebp
007F5828 ret 4
; FUNCTION 0x7f58a0
007F58A0 push ebp
007F58A1 mov ebp, esp
007F58A3 push ecx
007F58A4 mov dword ptr [ebp - 4], ecx
007F58A7 mov eax, dword ptr [ebp + 8]
007F58AA push eax
007F58AB mov ecx, dword ptr [ebp - 4]
007F58AE add ecx, 0x684
007F58B4 call 0x556990
007F58B9 mov esp, ebp
007F58BB pop ebp
007F58BC ret 4
; FUNCTION 0x806d40
00806D40 push ebp
00806D41 mov ebp, esp
00806D43 push -1
00806D45 push 0xac5d90
00806D4A mov eax, dword ptr fs:[0]
00806D50 push eax
00806D51 sub esp, 0x6c
00806D54 push esi
00806D55 push edi
00806D56 mov eax, dword ptr [0xc7b480]
00806D5B xor eax, ebp
00806D5D push eax
00806D5E lea eax, [ebp - 0xc]
00806D61 mov dword ptr fs:[0], eax
00806D67 mov dword ptr [ebp - 0x64], ecx
00806D6A mov esi, dword ptr [ebp + 8]
00806D6D mov edi, dword ptr [ebp - 0x64]
00806D70 add edi, 0x6dc
00806D76 mov ecx, 0x65
00806D7B rep movsd dword ptr es:[edi], dword ptr [esi]
00806D7D mov ecx, dword ptr [ebp - 0x64]
00806D80 add ecx, 0x88c
00806D86 call 0x4998d0
00806D8B mov eax, dword ptr [ebp - 0x64]
00806D8E add eax, 0x88c
00806D93 push eax
00806D94 sub esp, 0x1c
00806D97 mov ecx, esp
00806D99 mov dword ptr [ebp - 0x40], esp
00806D9C push 0xb9c808
00806DA1 call 0x405650
00806DA6 mov dword ptr [ebp - 0x68], eax
00806DA9 mov ecx, dword ptr [ebp - 0x68]
00806DAC mov dword ptr [ebp - 0x6c], ecx
00806DAF mov dword ptr [ebp - 4], 0
00806DB6 mov edx, dword ptr [ebp - 0x64]
00806DB9 add edx, 0x6e0
00806DBF sub esp, 0x1c
00806DC2 mov ecx, esp
00806DC4 mov dword ptr [ebp - 0x44], esp
00806DC7 push edx
00806DC8 call 0x405650
00806DCD mov dword ptr [ebp - 0x70], eax
00806DD0 mov dword ptr [ebp - 4], 0xffffffff
00806DD7 call 0x661a70
00806DDC add esp, 0x3c
00806DDF lea ecx, [ebp - 0x2c]
00806DE2 call 0x4eaea0
00806DE7 mov dword ptr [ebp - 4], 1
00806DEE push 0xa
00806DF0 lea eax, [ebp - 0x2c]
00806DF3 push eax
00806DF4 call 0xa55fb0
00806DF9 mov ecx, eax
00806DFB call 0xa56560
00806E00 lea ecx, [ebp - 0x2c]
00806E03 call 0x4c4cb0
00806E08 test eax, eax
00806E0A ja 0x806e20
00806E0C mov dword ptr [ebp - 4], 0xffffffff
00806E13 lea ecx, [ebp - 0x2c]
00806E16 call 0x4eae50
00806E1B jmp 0x806f20
00806E20 lea ecx, [ebp - 0x34]
00806E23 push ecx
00806E24 mov ecx, dword ptr [ebp - 0x64]
00806E27 add ecx, 0x88c
00806E2D call 0x4d6050
00806E32 jmp 0x806e42
00806E34 push 0
00806E36 lea edx, [ebp - 0x4c]
00806E39 push edx
00806E3A lea ecx, [ebp - 0x34]
00806E3D call 0x4e6c80
00806E42 lea eax, [ebp - 0x54]
00806E45 push eax
00806E46 mov ecx, dword ptr [ebp - 0x64]
00806E49 add ecx, 0x88c
00806E4F call 0x4f2590
00806E54 push eax
00806E55 lea ecx, [ebp - 0x34]
00806E58 call 0x4ab8f0
00806E5D movzx ecx, al
00806E60 test ecx, ecx
00806E62 je 0x806f11
00806E68 lea edx, [ebp - 0x3c]
00806E6B push edx
00806E6C lea ecx, [ebp - 0x2c]
00806E6F call 0x5504a0
00806E74 jmp 0x806e7e
00806E76 lea ecx, [ebp - 0x3c]
00806E79 call 0x4eaf30
00806E7E lea eax, [ebp - 0x5c]
00806E81 push eax
00806E82 lea ecx, [ebp - 0x2c]
00806E85 call 0x45abb0
00806E8A push eax
00806E8B lea ecx, [ebp - 0x3c]
00806E8E call 0x4ab8f0
00806E93 movzx ecx, al
00806E96 test ecx, ecx
00806E98 je 0x806f0c
00806E9A lea ecx, [ebp - 0x34]
00806E9D call 0x4e19a0
00806EA2 push eax
00806EA3 call 0x4e6d90
00806EA8 add esp, 4
00806EAB mov esi, eax
00806EAD lea ecx, [ebp - 0x3c]
00806EB0 call 0x4305b0
00806EB5 cmp esi, dword ptr [eax + 4]
00806EB8 jne 0x806f07
00806EBA push 0xbcd994
00806EBF lea ecx, [ebp - 0x3c]
00806EC2 call 0x4305b0
00806EC7 add eax, 0x20
00806ECA push eax
00806ECB lea edx, [ebp - 0x60]
00806ECE push edx
00806ECF call 0x406200
00806ED4 add esp, 0xc
00806ED7 mov dword ptr [ebp - 0x74], eax
00806EDA mov eax, dword ptr [ebp - 0x74]
00806EDD mov dword ptr [ebp - 0x78], eax
00806EE0 mov byte ptr [ebp - 4], 2
00806EE4 mov ecx, dword ptr [ebp - 0x78]
00806EE7 call 0x453f50
00806EEC push eax
00806EED mov ecx, dword ptr [ebp - 0x64]
00806EF0 add ecx, 0x870
00806EF6 call 0x4199c0
00806EFB mov byte ptr [ebp - 4], 1
00806EFF lea ecx, [ebp - 0x60]
00806F02 call 0x406050
00806F07 jmp 0x806e76
00806F0C jmp 0x806e34
00806F11 mov dword ptr [ebp - 4], 0xffffffff
00806F18 lea ecx, [ebp - 0x2c]
00806F1B call 0x4eae50
00806F20 mov ecx, dword ptr [ebp - 0xc]
00806F23 mov dword ptr fs:[0], ecx
00806F2A pop ecx
00806F2B pop edi
00806F2C pop esi
00806F2D mov esp, ebp
00806F2F pop ebp
00806F30 ret 4
