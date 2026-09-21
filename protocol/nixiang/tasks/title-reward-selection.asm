; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; range 0x956f10
00956F10 push ebp
00956F11 mov ebp, esp
00956F13 sub esp, 0xc
00956F16 mov dword ptr [ebp - 0xc], ecx
00956F19 push 8
00956F1B push 0
00956F1D lea eax, [ebp - 8]
00956F20 push eax
00956F21 call 0x666960
00956F26 add esp, 0xc
00956F29 cmp dword ptr [ebp + 0xc], 0
00956F2D jne 0x956f49
00956F2F mov ecx, dword ptr [ebp - 0xc]
00956F32 mov edx, dword ptr [ecx + 0x580]
00956F38 mov eax, dword ptr [ecx + 0x584]
00956F3E mov dword ptr [ebp - 8], edx
00956F41 mov dword ptr [ebp - 4], eax
00956F44 jmp 0x956ff8
00956F49 cmp dword ptr [ebp + 0xc], 1
00956F4D jne 0x956f69
00956F4F mov ecx, dword ptr [ebp - 0xc]
00956F52 mov edx, dword ptr [ecx + 0x588]
00956F58 mov eax, dword ptr [ecx + 0x58c]
00956F5E mov dword ptr [ebp - 8], edx
00956F61 mov dword ptr [ebp - 4], eax
00956F64 jmp 0x956ff8
00956F69 cmp dword ptr [ebp + 0xc], 2
00956F6D jne 0x956f86
00956F6F mov ecx, dword ptr [ebp - 0xc]
00956F72 mov edx, dword ptr [ecx + 0x590]
00956F78 mov eax, dword ptr [ecx + 0x594]
00956F7E mov dword ptr [ebp - 8], edx
00956F81 mov dword ptr [ebp - 4], eax
00956F84 jmp 0x956ff8
00956F86 cmp dword ptr [ebp + 0xc], 3
00956F8A jne 0x956fa3
00956F8C mov ecx, dword ptr [ebp - 0xc]
00956F8F mov edx, dword ptr [ecx + 0x598]
00956F95 mov eax, dword ptr [ecx + 0x59c]
00956F9B mov dword ptr [ebp - 8], edx
00956F9E mov dword ptr [ebp - 4], eax
00956FA1 jmp 0x956ff8
00956FA3 cmp dword ptr [ebp + 0xc], 4
00956FA7 jne 0x956fc0
00956FA9 mov ecx, dword ptr [ebp - 0xc]
00956FAC mov edx, dword ptr [ecx + 0x5a0]
00956FB2 mov eax, dword ptr [ecx + 0x5a4]
00956FB8 mov dword ptr [ebp - 8], edx
00956FBB mov dword ptr [ebp - 4], eax
00956FBE jmp 0x956ff8
00956FC0 cmp dword ptr [ebp + 0xc], 5
00956FC4 jne 0x956fdd
00956FC6 mov ecx, dword ptr [ebp - 0xc]
00956FC9 mov edx, dword ptr [ecx + 0x5a8]
00956FCF mov eax, dword ptr [ecx + 0x5ac]
00956FD5 mov dword ptr [ebp - 8], edx
00956FD8 mov dword ptr [ebp - 4], eax
00956FDB jmp 0x956ff8
00956FDD cmp dword ptr [ebp + 0xc], 6
00956FE1 jne 0x956ff8
00956FE3 mov ecx, dword ptr [ebp - 0xc]
00956FE6 mov edx, dword ptr [ecx + 0x5b0]
00956FEC mov eax, dword ptr [ecx + 0x5b4]
00956FF2 mov dword ptr [ebp - 8], edx
00956FF5 mov dword ptr [ebp - 4], eax
00956FF8 mov ecx, dword ptr [ebp + 8]
00956FFB mov edx, dword ptr [ebp - 8]
00956FFE mov dword ptr [ecx], edx
00957000 mov eax, dword ptr [ebp - 4]
00957003 mov dword ptr [ecx + 4], eax
00957006 mov eax, dword ptr [ebp + 8]
00957009 mov esp, ebp
0095700B pop ebp
0095700C ret 8
0095700F int3

; range 0x957250
00957250 push ebp
00957251 mov ebp, esp
00957253 push ecx
00957254 call 0x4c41e0
00957259 mov dword ptr [ebp - 4], eax
0095725C mov eax, dword ptr [ebp - 4]
0095725F mov edx, dword ptr [eax]
00957261 mov ecx, dword ptr [ebp - 4]
00957264 mov eax, dword ptr [edx + 0x108]
0095726A call eax
0095726C mov eax, 1
00957271 mov esp, ebp
00957273 pop ebp
00957274 ret
00957275 int3
00957276 int3
00957277 int3
00957278 int3
00957279 int3
0095727A int3
0095727B int3
0095727C int3
0095727D int3
0095727E int3
0095727F int3
00957280 push ebp
00957281 mov ebp, esp
00957283 push -1
00957285 push 0xac3114
0095728A mov eax, dword ptr fs:[0]
00957290 push eax
00957291 sub esp, 0x130
00957297 mov eax, dword ptr [0xc7b480]
0095729C xor eax, ebp
0095729E mov dword ptr [ebp - 0x10], eax
009572A1 push eax
009572A2 lea eax, [ebp - 0xc]
009572A5 mov dword ptr fs:[0], eax
009572AB mov dword ptr [ebp - 0x128], ecx
009572B1 mov dword ptr [ebp - 0xb0], 0
009572BB mov dword ptr [ebp - 0xb4], 0xffffffff
009572C5 mov dword ptr [ebp - 0xb8], 0
009572CF jmp 0x9572e0
009572D1 mov eax, dword ptr [ebp - 0xb8]
009572D7 add eax, 1
009572DA mov dword ptr [ebp - 0xb8], eax
009572E0 cmp dword ptr [ebp - 0xb8], 7
009572E7 jge 0x9573b6
009572ED lea ecx, [ebp - 0xb8]
009572F3 push ecx
009572F4 lea edx, [ebp - 0xe4]
009572FA push edx
009572FB call 0xa44160
00957300 add esp, 8
00957303 mov dword ptr [ebp - 0x12c], eax
00957309 mov eax, dword ptr [ebp - 0x12c]
0095730F mov dword ptr [ebp - 0x130], eax
00957315 mov dword ptr [ebp - 4], 0
0095731C mov ecx, dword ptr [ebp - 0x130]
00957322 push ecx
00957323 mov edx, dword ptr [0xb9a744]
00957329 push edx
0095732A lea eax, [ebp - 0x100]
00957330 push eax
00957331 call 0x411d70
00957336 add esp, 0xc
00957339 mov dword ptr [ebp - 0x134], eax
0095733F mov ecx, dword ptr [ebp - 0x134]
00957345 mov dword ptr [ebp - 0x138], ecx
0095734B mov byte ptr [ebp - 4], 1
0095734F mov edx, dword ptr [ebp - 0x138]
00957355 push edx
00957356 mov ecx, dword ptr [ebp - 0x128]
0095735C call 0x75fbf0
00957361 mov dword ptr [ebp - 0xb0], eax
00957367 mov byte ptr [ebp - 4], 0
0095736B lea ecx, [ebp - 0x100]
00957371 call 0x4056d0
00957376 mov dword ptr [ebp - 4], 0xffffffff
0095737D lea ecx, [ebp - 0xe4]
00957383 call 0x4056d0
00957388 cmp dword ptr [ebp - 0xb0], 0
0095738F je 0x9573b1
00957391 mov ecx, dword ptr [ebp - 0xb0]
00957397 call 0x4c41c0
0095739C movzx eax, al
0095739F test eax, eax
009573A1 je 0x9573b1
009573A3 mov ecx, dword ptr [ebp - 0xb8]
009573A9 mov dword ptr [ebp - 0xb4], ecx
009573AF jmp 0x9573b6
009573B1 jmp 0x9572d1
009573B6 cmp dword ptr [ebp - 0xb4], -1
009573BD jne 0x95741e
009573BF push 0xbab3d8
009573C4 lea ecx, [ebp - 0x11c]
009573CA call 0x405650
009573CF mov dword ptr [ebp - 4], 2
009573D6 call 0x403820
009573DB mov dword ptr [ebp - 0x13c], eax
009573E1 push 0
009573E3 push 0x957050
009573E8 push 0
009573EA lea edx, [ebp - 0x11c]
009573F0 push edx
009573F1 mov eax, dword ptr [ebp - 0x13c]
009573F7 mov edx, dword ptr [eax]
009573F9 mov ecx, dword ptr [ebp - 0x13c]
009573FF mov eax, dword ptr [edx + 0x1c0]
00957405 call eax
00957407 mov dword ptr [ebp - 4], 0xffffffff
0095740E lea ecx, [ebp - 0x11c]
00957414 call 0x4056d0
00957419 jmp 0x9574fd
0095741E push 0x95
00957423 push 0
00957425 lea ecx, [ebp - 0xac]
0095742B push ecx
0095742C call 0x666960
00957431 add esp, 0xc
00957434 mov edx, dword ptr [ebp - 0xb4]
0095743A push edx
0095743B lea eax, [ebp - 0x124]
00957441 push eax
00957442 mov ecx, dword ptr [ebp - 0x128]
00957448 call 0x956f10
0095744D mov ecx, dword ptr [eax]
0095744F mov dword ptr [ebp - 0x1b], ecx
00957452 push 0x95
00957457 lea edx, [ebp - 0xac]
0095745D push edx
0095745E push 0
00957460 push 0x101e
00957465 call 0xa3c950
0095746A add esp, 0x10
0095746D cmp dword ptr [0x17c8708], 0
00957474 je 0x9574e7
00957476 mov ecx, dword ptr [0x17c8708]
0095747C call 0x4535c0
00957481 cmp eax, 4
00957484 jne 0x9574e7
00957486 cmp dword ptr [0x17c86fc], 0
0095748D je 0x9574e7
0095748F mov ecx, dword ptr [0x17c86fc]
00957495 call 0x9cd390
0095749A test eax, eax
0095749C je 0x9574e7
0095749E push 0xd
009574A0 push 0
009574A2 lea eax, [ebp - 0xc8]
009574A8 push eax
009574A9 call 0x666960
009574AE add esp, 0xc
009574B1 mov dword ptr [ebp - 0xc4], 0
009574BB mov dword ptr [ebp - 0xc8], 0
009574C5 mov dword ptr [ebp - 0xc0], 0
009574CF push 0xd
009574D1 lea ecx, [ebp - 0xc8]
009574D7 push ecx
009574D8 push 0
009574DA push 0x184c
009574DF call 0xa3c950
009574E4 add esp, 0x10
009574E7 mov edx, dword ptr [ebp - 0x128]
009574ED mov eax, dword ptr [edx]
009574EF mov ecx, dword ptr [ebp - 0x128]
009574F5 mov edx, dword ptr [eax + 0x11c]
009574FB call edx
009574FD mov ecx, dword ptr [ebp - 0xc]
00957500 mov dword ptr fs:[0], ecx
00957507 pop ecx
00957508 mov ecx, dword ptr [ebp - 0x10]
0095750B xor ecx, ebp
0095750D call 0x6634fb
00957512 mov esp, ebp
00957514 pop ebp
00957515 ret
00957516 int3
00957517 int3
00957518 int3
00957519 int3
0095751A int3
0095751B int3
0095751C int3
0095751D int3
0095751E int3
0095751F int3

; range 0x957670
00957670 push ebp
00957671 mov ebp, esp
00957673 push -1
00957675 push 0xad696d
0095767A mov eax, dword ptr fs:[0]
00957680 push eax
00957681 sub esp, 0x45c
00957687 mov eax, dword ptr [0xc7b480]
0095768C xor eax, ebp
0095768E mov dword ptr [ebp - 0x10], eax
00957691 push esi
00957692 push edi
00957693 push eax
00957694 lea eax, [ebp - 0xc]
00957697 mov dword ptr fs:[0], eax
0095769D mov dword ptr [ebp - 0x3c8], ecx
009576A3 mov ecx, dword ptr [ebp - 0x3c8]
009576A9 call 0x75f460
009576AE mov esi, dword ptr [ebp + 8]
009576B1 mov edi, dword ptr [ebp - 0x3c8]
009576B7 add edi, 0x578
009576BD mov ecx, 0x10
009576C2 rep movsd dword ptr es:[edi], dword ptr [esi]
009576C4 mov ecx, dword ptr [0x17c86fc]
009576CA call 0x9cd390
009576CF movzx ax, byte ptr [eax + 0x7b]
009576D4 movzx ecx, ax
009576D7 push ecx
009576D8 call 0x45e2d0
009576DD mov ecx, eax
009576DF call 0xa73bc0
009576E4 mov dword ptr [ebp - 0xb4], eax
009576EA mov edx, dword ptr [0xb9a734]
009576F0 push edx
009576F1 lea ecx, [ebp - 0x154]
009576F7 call 0x405650
009576FC mov dword ptr [ebp - 4], 0
00957703 lea eax, [ebp - 0x154]
00957709 push eax
0095770A mov ecx, dword ptr [ebp - 0x3c8]
00957710 call 0x75fbf0
00957715 mov dword ptr [ebp - 0xb0], eax
0095771B mov dword ptr [ebp - 4], 0xffffffff
00957722 lea ecx, [ebp - 0x154]
00957728 call 0x4056d0
0095772D cmp dword ptr [ebp - 0xb0], 0
00957734 je 0x957761
00957736 cmp dword ptr [ebp - 0xb4], 0
0095773D je 0x957761
0095773F push 1
00957741 mov ecx, dword ptr [ebp - 0xb4]
00957747 add ecx, 4
0095774A push ecx
0095774B mov edx, dword ptr [ebp - 0xb0]
00957751 mov eax, dword ptr [edx]
00957753 mov ecx, dword ptr [ebp - 0xb0]
00957759 mov edx, dword ptr [eax + 0xd4]
0095775F call edx
00957761 mov eax, dword ptr [0xb9a738]
00957766 push eax
00957767 lea ecx, [ebp - 0x170]
0095776D call 0x405650
00957772 mov dword ptr [ebp - 4], 1
00957779 lea ecx, [ebp - 0x170]
0095777F push ecx
00957780 mov ecx, dword ptr [ebp - 0x3c8]
00957786 call 0x75fbf0
0095778B mov dword ptr [ebp - 0xbc], eax
00957791 mov dword ptr [ebp - 4], 0xffffffff
00957798 lea ecx, [ebp - 0x170]
0095779E call 0x4056d0
009577A3 cmp dword ptr [ebp - 0xbc], 0
009577AA je 0x9577d2
009577AC cmp dword ptr [ebp - 0xb4], 0
009577B3 je 0x9577d2
009577B5 mov edx, dword ptr [ebp - 0xb4]
009577BB add edx, 0x20
009577BE push edx
009577BF mov eax, dword ptr [ebp - 0xbc]
009577C5 mov edx, dword ptr [eax]
009577C7 mov ecx, dword ptr [ebp - 0xbc]
009577CD mov eax, dword ptr [edx + 0x28]
009577D0 call eax
009577D2 mov dword ptr [ebp - 0xb8], 0
009577DC mov dword ptr [ebp - 0xc0], 0
009577E6 lea ecx, [ebp - 0xac]
009577EC call 0x4c4330
009577F1 mov dword ptr [ebp - 4], 2
009577F8 mov dword ptr [ebp - 0xc4], 0
00957802 jmp 0x957813
00957804 mov ecx, dword ptr [ebp - 0xc4]
0095780A add ecx, 1
0095780D mov dword ptr [ebp - 0xc4], ecx
00957813 cmp dword ptr [ebp - 0xc4], 7
0095781A jge 0x957e98
00957820 lea edx, [ebp - 0xc4]
00957826 push edx
00957827 lea eax, [ebp - 0x18c]
0095782D push eax
0095782E call 0xa44160
00957833 add esp, 8
00957836 mov dword ptr [ebp - 0x3cc], eax
0095783C mov ecx, dword ptr [ebp - 0x3cc]
00957842 mov dword ptr [ebp - 0x3d0], ecx
00957848 mov byte ptr [ebp - 4], 3
0095784C mov edx, dword ptr [ebp - 0x3d0]
00957852 push edx
00957853 mov eax, dword ptr [0xb9a73c]
00957858 push eax
00957859 lea ecx, [ebp - 0x1a8]
0095785F push ecx
00957860 call 0x411d70
00957865 add esp, 0xc
00957868 mov dword ptr [ebp - 0x3d4], eax
0095786E mov edx, dword ptr [ebp - 0x3d4]
00957874 mov dword ptr [ebp - 0x3d8], edx
0095787A mov byte ptr [ebp - 4], 4
0095787E mov eax, dword ptr [ebp - 0x3d8]
00957884 push eax
00957885 mov ecx, dword ptr [ebp - 0x3c8]
0095788B call 0x75fbf0
00957890 mov dword ptr [ebp - 0xb8], eax
00957896 mov byte ptr [ebp - 4], 3
0095789A lea ecx, [ebp - 0x1a8]
009578A0 call 0x4056d0
009578A5 mov byte ptr [ebp - 4], 2
009578A9 lea ecx, [ebp - 0x18c]
009578AF call 0x4056d0
009578B4 lea ecx, [ebp - 0xc4]
009578BA push ecx
009578BB lea edx, [ebp - 0x1c4]
009578C1 push edx
009578C2 call 0xa44160
009578C7 add esp, 8
009578CA mov dword ptr [ebp - 0x3dc], eax
009578D0 mov eax, dword ptr [ebp - 0x3dc]
009578D6 mov dword ptr [ebp - 0x3e0], eax
009578DC mov byte ptr [ebp - 4], 5
009578E0 mov ecx, dword ptr [ebp - 0x3e0]
009578E6 push ecx
009578E7 mov edx, dword ptr [0xb9a744]
009578ED push edx
009578EE lea eax, [ebp - 0x1e0]
009578F4 push eax
009578F5 call 0x411d70
009578FA add esp, 0xc
009578FD mov dword ptr [ebp - 0x3e4], eax
00957903 mov ecx, dword ptr [ebp - 0x3e4]
00957909 mov dword ptr [ebp - 0x3e8], ecx
0095790F mov byte ptr [ebp - 4], 6
00957913 mov edx, dword ptr [ebp - 0x3e8]
00957919 push edx
0095791A mov ecx, dword ptr [ebp - 0x3c8]
00957920 call 0x75fbf0
00957925 mov dword ptr [ebp - 0xc0], eax
0095792B mov byte ptr [ebp - 4], 5
0095792F lea ecx, [ebp - 0x1e0]
00957935 call 0x4056d0
0095793A mov byte ptr [ebp - 4], 2
0095793E lea ecx, [ebp - 0x1c4]
00957944 call 0x4056d0
00957949 lea eax, [ebp - 0x134]
0095794F push eax
00957950 mov ecx, dword ptr [ebp - 0xc4]
00957956 push ecx
00957957 lea edx, [ebp - 0x1e8]
0095795D push edx
0095795E mov ecx, dword ptr [ebp - 0x3c8]
00957964 call 0x956f10
00957969 mov eax, dword ptr [eax]
0095796B push eax
0095796C call 0x41bc70
00957971 mov ecx, eax
00957973 call 0x85ba40
00957978 test eax, eax
0095797A je 0x957e02
00957980 lea ecx, [ebp - 0xc4]
00957986 push ecx
00957987 lea edx, [ebp - 0x204]
0095798D push edx
0095798E call 0xa44160
00957993 add esp, 8
00957996 mov dword ptr [ebp - 0x3ec], eax
0095799C mov eax, dword ptr [ebp - 0x3ec]
009579A2 mov dword ptr [ebp - 0x3f0], eax
009579A8 mov byte ptr [ebp - 4], 7
009579AC mov ecx, dword ptr [ebp - 0x3f0]
009579B2 push ecx
009579B3 mov edx, dword ptr [0xb9a744]
009579B9 push edx
009579BA lea eax, [ebp - 0x220]
009579C0 push eax
009579C1 call 0x411d70
009579C6 add esp, 0xc
009579C9 mov dword ptr [ebp - 0x3f4], eax
009579CF mov ecx, dword ptr [ebp - 0x3f4]
009579D5 mov dword ptr [ebp - 0x3f8], ecx
009579DB mov byte ptr [ebp - 4], 8
009579DF push 1
009579E1 mov edx, dword ptr [ebp - 0x3f8]
009579E7 push edx
009579E8 mov ecx, dword ptr [ebp - 0x3c8]
009579EE call 0x7611c0
009579F3 mov byte ptr [ebp - 4], 7
009579F7 lea ecx, [ebp - 0x220]
009579FD call 0x4056d0
00957A02 mov byte ptr [ebp - 4], 2
00957A06 lea ecx, [ebp - 0x204]
00957A0C call 0x4056d0
00957A11 mov eax, dword ptr [ebp - 0x12f]
00957A17 push eax
00957A18 call 0xa21b30
00957A1D mov ecx, eax
00957A1F call 0xa1e560
00957A24 mov dword ptr [ebp - 0x138], eax
00957A2A cmp dword ptr [ebp - 0x138], 0
00957A31 je 0x957c4b
00957A37 cmp dword ptr [ebp - 0xb8], 0
00957A3E je 0x957a94
00957A40 mov ecx, dword ptr [ebp - 0x138]
00957A46 add ecx, 0x44
00957A49 call 0x406410
00957A4E push eax
00957A4F lea ecx, [ebp - 0x23c]
00957A55 call 0x405650
00957A5A mov byte ptr [ebp - 4], 9
00957A5E lea ecx, [ebp - 0x23c]
00957A64 push ecx
00957A65 mov edx, dword ptr [ebp - 0xb8]
00957A6B mov eax, dword ptr [edx]
00957A6D mov ecx, dword ptr [ebp - 0xb8]
00957A73 mov edx, dword ptr [eax + 0x28]
00957A76 call edx
00957A78 mov byte ptr [ebp - 4], 2
00957A7C lea ecx, [ebp - 0x23c]
00957A82 call 0x4056d0
00957A87 push 1
00957A89 mov ecx, dword ptr [ebp - 0xb8]
00957A8F call 0x75aa30
00957A94 lea eax, [ebp - 0xc4]
00957A9A push eax
00957A9B lea ecx, [ebp - 0x258]
00957AA1 push ecx
00957AA2 call 0xa44160
00957AA7 add esp, 8
00957AAA mov dword ptr [ebp - 0x3fc], eax
00957AB0 mov edx, dword ptr [ebp - 0x3fc]
00957AB6 mov dword ptr [ebp - 0x400], edx
00957ABC mov byte ptr [ebp - 4], 0xa
00957AC0 mov eax, dword ptr [ebp - 0x400]
00957AC6 push eax
00957AC7 mov ecx, dword ptr [0xb9a740]
00957ACD push ecx
00957ACE lea edx, [ebp - 0x274]
00957AD4 push edx
00957AD5 call 0x411d70
00957ADA add esp, 0xc
00957ADD mov dword ptr [ebp - 0x404], eax
00957AE3 mov eax, dword ptr [ebp - 0x404]
00957AE9 mov dword ptr [ebp - 0x408], eax
00957AEF mov byte ptr [ebp - 4], 0xb
00957AF3 push 1
00957AF5 mov ecx, dword ptr [ebp - 0x408]
00957AFB push ecx
00957AFC mov ecx, dword ptr [ebp - 0x3c8]
00957B02 call 0x7611c0
00957B07 mov byte ptr [ebp - 4], 0xa
00957B0B lea ecx, [ebp - 0x274]
00957B11 call 0x4056d0
00957B16 mov byte ptr [ebp - 4], 2
00957B1A lea ecx, [ebp - 0x258]
00957B20 call 0x4056d0
00957B25 lea edx, [ebp - 0xc4]
00957B2B push edx
00957B2C lea eax, [ebp - 0x290]
00957B32 push eax
00957B33 call 0xa44160
00957B38 add esp, 8
00957B3B mov dword ptr [ebp - 0x40c], eax
00957B41 mov ecx, dword ptr [ebp - 0x40c]
00957B47 mov dword ptr [ebp - 0x410], ecx
00957B4D mov byte ptr [ebp - 4], 0xc
00957B51 mov edx, dword ptr [ebp - 0x410]
00957B57 push edx
00957B58 mov eax, dword ptr [0xb9a744]
00957B5D push eax
00957B5E lea ecx, [ebp - 0x2ac]
00957B64 push ecx
00957B65 call 0x411d70
00957B6A add esp, 0xc
00957B6D mov dword ptr [ebp - 0x414], eax
00957B73 mov edx, dword ptr [ebp - 0x414]
00957B79 mov dword ptr [ebp - 0x418], edx
00957B7F mov byte ptr [ebp - 4], 0xd
00957B83 push 1
00957B85 mov eax, dword ptr [ebp - 0x418]
00957B8B push eax
00957B8C mov ecx, dword ptr [ebp - 0x3c8]
00957B92 call 0x7611c0
00957B97 mov byte ptr [ebp - 4], 0xc
00957B9B lea ecx, [ebp - 0x2ac]
00957BA1 call 0x4056d0
00957BA6 mov byte ptr [ebp - 4], 2
00957BAA lea ecx, [ebp - 0x290]
00957BB0 call 0x4056d0
00957BB5 lea ecx, [ebp - 0xc4]
00957BBB push ecx
00957BBC lea edx, [ebp - 0x2c8]
00957BC2 push edx
00957BC3 call 0xa44160
00957BC8 add esp, 8
00957BCB mov dword ptr [ebp - 0x41c], eax
00957BD1 mov eax, dword ptr [ebp - 0x41c]
00957BD7 mov dword ptr [ebp - 0x420], eax
00957BDD mov byte ptr [ebp - 4], 0xe
00957BE1 mov ecx, dword ptr [ebp - 0x420]
00957BE7 push ecx
00957BE8 mov edx, dword ptr [0xb9a744]
00957BEE push edx
00957BEF lea eax, [ebp - 0x2e4]
00957BF5 push eax
00957BF6 call 0x411d70
00957BFB add esp, 0xc
00957BFE mov dword ptr [ebp - 0x424], eax
00957C04 mov ecx, dword ptr [ebp - 0x424]
00957C0A mov dword ptr [ebp - 0x428], ecx
00957C10 mov byte ptr [ebp - 4], 0xf
00957C14 push 1
00957C16 mov edx, dword ptr [ebp - 0x428]
00957C1C push edx
00957C1D mov ecx, dword ptr [ebp - 0x3c8]
00957C23 call 0x7603d0
00957C28 mov byte ptr [ebp - 4], 0xe
00957C2C lea ecx, [ebp - 0x2e4]
00957C32 call 0x4056d0
00957C37 mov byte ptr [ebp - 4], 2
00957C3B lea ecx, [ebp - 0x2c8]
00957C41 call 0x4056d0
00957C46 jmp 0x957dfd
00957C4B lea eax, [ebp - 0xc4]
00957C51 push eax
00957C52 lea ecx, [ebp - 0x300]
00957C58 push ecx
00957C59 call 0xa44160
00957C5E add esp, 8
00957C61 mov dword ptr [ebp - 0x42c], eax
00957C67 mov edx, dword ptr [ebp - 0x42c]
00957C6D mov dword ptr [ebp - 0x430], edx
00957C73 mov byte ptr [ebp - 4], 0x10
00957C77 mov eax, dword ptr [ebp - 0x430]
00957C7D push eax
00957C7E mov ecx, dword ptr [0xb9a740]
00957C84 push ecx
00957C85 lea edx, [ebp - 0x31c]
00957C8B push edx
00957C8C call 0x411d70
00957C91 add esp, 0xc
00957C94 mov dword ptr [ebp - 0x434], eax
00957C9A mov eax, dword ptr [ebp - 0x434]
00957CA0 mov dword ptr [ebp - 0x438], eax
00957CA6 mov byte ptr [ebp - 4], 0x11
00957CAA push 0
00957CAC mov ecx, dword ptr [ebp - 0x438]
00957CB2 push ecx
00957CB3 mov ecx, dword ptr [ebp - 0x3c8]
00957CB9 call 0x7611c0
00957CBE mov byte ptr [ebp - 4], 0x10
00957CC2 lea ecx, [ebp - 0x31c]
00957CC8 call 0x4056d0
00957CCD mov byte ptr [ebp - 4], 2
00957CD1 lea ecx, [ebp - 0x300]
00957CD7 call 0x4056d0
00957CDC lea edx, [ebp - 0xc4]
00957CE2 push edx
00957CE3 lea eax, [ebp - 0x338]
00957CE9 push eax
00957CEA call 0xa44160
00957CEF add esp, 8
00957CF2 mov dword ptr [ebp - 0x43c], eax
00957CF8 mov ecx, dword ptr [ebp - 0x43c]
00957CFE mov dword ptr [ebp - 0x440], ecx
00957D04 mov byte ptr [ebp - 4], 0x12
00957D08 mov edx, dword ptr [ebp - 0x440]
00957D0E push edx
00957D0F mov eax, dword ptr [0xb9a744]
00957D14 push eax
00957D15 lea ecx, [ebp - 0x354]
00957D1B push ecx
00957D1C call 0x411d70
00957D21 add esp, 0xc
00957D24 mov dword ptr [ebp - 0x444], eax
00957D2A mov edx, dword ptr [ebp - 0x444]
00957D30 mov dword ptr [ebp - 0x448], edx
00957D36 mov byte ptr [ebp - 4], 0x13
00957D3A push 0
00957D3C mov eax, dword ptr [ebp - 0x448]
00957D42 push eax
00957D43 mov ecx, dword ptr [ebp - 0x3c8]
00957D49 call 0x7611c0
00957D4E mov byte ptr [ebp - 4], 0x12
00957D52 lea ecx, [ebp - 0x354]
00957D58 call 0x4056d0
00957D5D mov byte ptr [ebp - 4], 2
00957D61 lea ecx, [ebp - 0x338]
00957D67 call 0x4056d0
00957D6C lea ecx, [ebp - 0xc4]
00957D72 push ecx
00957D73 lea edx, [ebp - 0x370]
00957D79 push edx
00957D7A call 0xa44160
00957D7F add esp, 8
00957D82 mov dword ptr [ebp - 0x44c], eax
00957D88 mov eax, dword ptr [ebp - 0x44c]
00957D8E mov dword ptr [ebp - 0x450], eax
00957D94 mov byte ptr [ebp - 4], 0x14
00957D98 mov ecx, dword ptr [ebp - 0x450]
00957D9E push ecx
00957D9F mov edx, dword ptr [0xb9a744]
00957DA5 push edx
00957DA6 lea eax, [ebp - 0x38c]
00957DAC push eax
00957DAD call 0x411d70
00957DB2 add esp, 0xc
00957DB5 mov dword ptr [ebp - 0x454], eax
00957DBB mov ecx, dword ptr [ebp - 0x454]
00957DC1 mov dword ptr [ebp - 0x458], ecx
00957DC7 mov byte ptr [ebp - 4], 0x15
00957DCB push 0
00957DCD mov edx, dword ptr [ebp - 0x458]
00957DD3 push edx
00957DD4 mov ecx, dword ptr [ebp - 0x3c8]
00957DDA call 0x7603d0
00957DDF mov byte ptr [ebp - 4], 0x14
00957DE3 lea ecx, [ebp - 0x38c]
00957DE9 call 0x4056d0
00957DEE mov byte ptr [ebp - 4], 2
00957DF2 lea ecx, [ebp - 0x370]
00957DF8 call 0x4056d0
00957DFD jmp 0x957e93
00957E02 lea eax, [ebp - 0xc4]
00957E08 push eax
00957E09 lea ecx, [ebp - 0x3a8]
00957E0F push ecx
00957E10 call 0xa44160
00957E15 add esp, 8
00957E18 mov dword ptr [ebp - 0x45c], eax
00957E1E mov edx, dword ptr [ebp - 0x45c]
00957E24 mov dword ptr [ebp - 0x460], edx
00957E2A mov byte ptr [ebp - 4], 0x16
00957E2E mov eax, dword ptr [ebp - 0x460]
00957E34 push eax
00957E35 mov ecx, dword ptr [0xb9a744]
00957E3B push ecx
00957E3C lea edx, [ebp - 0x3c4]
00957E42 push edx
00957E43 call 0x411d70
00957E48 add esp, 0xc
00957E4B mov dword ptr [ebp - 0x464], eax
00957E51 mov eax, dword ptr [ebp - 0x464]
00957E57 mov dword ptr [ebp - 0x468], eax
00957E5D mov byte ptr [ebp - 4], 0x17
00957E61 push 0
00957E63 mov ecx, dword ptr [ebp - 0x468]
00957E69 push ecx
00957E6A mov ecx, dword ptr [ebp - 0x3c8]
00957E70 call 0x7611c0
00957E75 mov byte ptr [ebp - 4], 0x16
00957E79 lea ecx, [ebp - 0x3c4]
00957E7F call 0x4056d0
00957E84 mov byte ptr [ebp - 4], 2
00957E88 lea ecx, [ebp - 0x3a8]
00957E8E call 0x4056d0
00957E93 jmp 0x957804
00957E98 mov dword ptr [ebp - 4], 0xffffffff
00957E9F lea ecx, [ebp - 0xac]
00957EA5 call 0x4c4370
00957EAA mov ecx, dword ptr [ebp - 0xc]
00957EAD mov dword ptr fs:[0], ecx
00957EB4 pop ecx
00957EB5 pop edi
00957EB6 pop esi
00957EB7 mov ecx, dword ptr [ebp - 0x10]
00957EBA xor ecx, ebp
00957EBC call 0x6634fb
00957EC1 mov esp, ebp
00957EC3 pop ebp
00957EC4 ret 4
00957EC7 int3

; range 0x85ba40
0085BA40 push ebp
0085BA41 mov ebp, esp
0085BA43 sub esp, 0x1c
0085BA46 push esi
0085BA47 push edi
0085BA48 mov dword ptr [ebp - 0x1c], ecx
0085BA4B lea eax, [ebp + 8]
0085BA4E push eax
0085BA4F lea ecx, [ebp - 0x10]
0085BA52 push ecx
0085BA53 mov ecx, dword ptr [ebp - 0x1c]
0085BA56 add ecx, 0x40
0085BA59 call 0x5242c0
0085BA5E mov edx, dword ptr [eax]
0085BA60 mov eax, dword ptr [eax + 4]
0085BA63 mov dword ptr [ebp - 8], edx
0085BA66 mov dword ptr [ebp - 4], eax
0085BA69 lea ecx, [ebp - 0x18]
0085BA6C push ecx
0085BA6D mov ecx, dword ptr [ebp - 0x1c]
0085BA70 add ecx, 0x40
0085BA73 call 0x45abb0
0085BA78 push eax
0085BA79 lea ecx, [ebp - 8]
0085BA7C call 0x4ab8f0
0085BA81 movzx edx, al
0085BA84 test edx, edx
0085BA86 je 0x85baa6
0085BA88 lea ecx, [ebp - 8]
0085BA8B call 0x4822d0
0085BA90 add eax, 4
0085BA93 mov ecx, 0x1b
0085BA98 mov esi, eax
0085BA9A mov edi, dword ptr [ebp + 0xc]
0085BA9D rep movsd dword ptr es:[edi], dword ptr [esi]
0085BA9F mov eax, 1
0085BAA4 jmp 0x85baa8
0085BAA6 xor eax, eax
0085BAA8 pop edi
0085BAA9 pop esi
0085BAAA mov esp, ebp
0085BAAC pop ebp
0085BAAD ret 8
