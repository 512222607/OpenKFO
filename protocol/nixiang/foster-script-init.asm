; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; function 0x942910
00942910 push ebp
00942911 mov ebp, esp
00942913 push -1
00942915 push 0xadbd77
0094291A mov eax, dword ptr fs:[0]
00942920 push eax
00942921 sub esp, 0xf8
00942927 mov eax, dword ptr [0xc7b480]
0094292C xor eax, ebp
0094292E mov dword ptr [ebp - 0x14], eax
00942931 push eax
00942932 lea eax, [ebp - 0xc]
00942935 mov dword ptr fs:[0], eax
0094293B mov dword ptr [ebp - 0xec], ecx
00942941 lea eax, [ebp - 0xa8]
00942947 push eax
00942948 mov ecx, dword ptr [0x17c8708]
0094294E call 0x4b1070
00942953 mov ecx, dword ptr [eax + 4]
00942956 push ecx
00942957 call 0x4d4380
0094295C mov ecx, eax
0094295E call 0xa62a90
00942963 mov dword ptr [ebp - 0x10], eax
00942966 cmp dword ptr [ebp - 0x10], 0
0094296A jne 0x942973
0094296C xor al, al
0094296E jmp 0x942c54
00942973 call 0x44e280
00942978 push eax
00942979 push 0xa5be20
0094297E call 0x63a110
00942983 add esp, 8
00942986 mov edx, dword ptr [ebp - 0xec]
0094298C mov dword ptr [edx + 0x10], eax
0094298F mov eax, dword ptr [ebp - 0xec]
00942995 cmp dword ptr [eax + 0x10], 0
00942999 jne 0x9429a2
0094299B xor al, al
0094299D jmp 0x942c54
009429A2 mov ecx, dword ptr [ebp - 0xec]
009429A8 mov ecx, dword ptr [ecx + 0x10]
009429AB call 0x6393c0
009429B0 push 0x17c93a4
009429B5 push 0x17c8e58
009429BA lea edx, [ebp - 0xac]
009429C0 push edx
009429C1 call 0x4166a0
009429C6 add esp, 0xc
009429C9 mov dword ptr [ebp - 0xf0], eax
009429CF mov eax, dword ptr [ebp - 0xf0]
009429D5 mov dword ptr [ebp - 0xf4], eax
009429DB mov dword ptr [ebp - 4], 0
009429E2 mov ecx, dword ptr [ebp - 0xf4]
009429E8 call 0x453f50
009429ED push eax
009429EE lea ecx, [ebp - 0x84]
009429F4 call 0x405650
009429F9 mov byte ptr [ebp - 4], 2
009429FD lea ecx, [ebp - 0xac]
00942A03 call 0x406050
00942A08 push 0xb9d750
; literal b'?'
00942A0D lea ecx, [ebp - 0x84]
00942A13 call 0x405750
00942A18 push eax
00942A19 mov ecx, dword ptr [ebp - 0xec]
00942A1F mov ecx, dword ptr [ecx + 0x10]
00942A22 call 0x6393f0
00942A27 mov ecx, 0x17c9388
00942A2C call 0x548980
00942A31 test eax, eax
00942A33 jbe 0x942abe
00942A39 push 0xb9d750
; literal b'?'
00942A3E lea ecx, [ebp - 0xc8]
00942A44 call 0x405650
00942A49 mov dword ptr [ebp - 0xf8], eax
00942A4F mov edx, dword ptr [ebp - 0xf8]
00942A55 mov dword ptr [ebp - 0xfc], edx
00942A5B mov byte ptr [ebp - 4], 3
00942A5F push 0x17c9388
00942A64 mov eax, dword ptr [ebp - 0xfc]
00942A6A push eax
00942A6B lea ecx, [ebp - 0xa0]
00942A71 push ecx
00942A72 call 0x41b400
00942A77 add esp, 0xc
00942A7A mov byte ptr [ebp - 4], 5
00942A7E lea ecx, [ebp - 0xc8]
00942A84 call 0x4056d0
00942A89 lea ecx, [ebp - 0xa0]
00942A8F call 0x405750
00942A94 push eax
00942A95 lea ecx, [ebp - 0x84]
00942A9B call 0x405750
00942AA0 push eax
00942AA1 mov edx, dword ptr [ebp - 0xec]
00942AA7 mov ecx, dword ptr [edx + 0x10]
00942AAA call 0x6393f0
00942AAF mov byte ptr [ebp - 4], 2
00942AB3 lea ecx, [ebp - 0xa0]
00942AB9 call 0x4056d0
00942ABE push 0xbad050
; literal b'include'
00942AC3 lea eax, [ebp - 0x84]
00942AC9 push eax
00942ACA lea ecx, [ebp - 0x30]
00942ACD push ecx
00942ACE call 0x4194f0
00942AD3 add esp, 0xc
00942AD6 mov byte ptr [ebp - 4], 6
00942ADA push 0xbad058
; literal b'config.lua'
00942ADF lea edx, [ebp - 0x84]
00942AE5 push edx
00942AE6 lea eax, [ebp - 0x68]
00942AE9 push eax
00942AEA call 0x4194f0
00942AEF add esp, 0xc
00942AF2 mov byte ptr [ebp - 4], 7
00942AF6 mov ecx, dword ptr [ebp - 0x10]
00942AF9 add ecx, 4
00942AFC push ecx
00942AFD lea edx, [ebp - 0x84]
00942B03 push edx
00942B04 lea eax, [ebp - 0xe4]
00942B0A push eax
00942B0B call 0x41b400
00942B10 add esp, 0xc
00942B13 mov dword ptr [ebp - 0x100], eax
00942B19 mov ecx, dword ptr [ebp - 0x100]
00942B1F mov dword ptr [ebp - 0x104], ecx
00942B25 mov byte ptr [ebp - 4], 8
00942B29 push 0xbad02c
; literal b'.lua'
00942B2E mov edx, dword ptr [ebp - 0x104]
00942B34 push edx
00942B35 lea eax, [ebp - 0x4c]
00942B38 push eax
00942B39 call 0x4194f0
00942B3E add esp, 0xc
00942B41 mov byte ptr [ebp - 4], 0xa
00942B45 lea ecx, [ebp - 0xe4]
00942B4B call 0x4056d0
00942B50 lea ecx, [ebp - 0x30]
00942B53 call 0x405750
00942B58 push eax
00942B59 mov ecx, dword ptr [ebp - 0xec]
00942B5F mov ecx, dword ptr [ecx + 0x10]
00942B62 call 0x639820
00942B67 movzx edx, al
00942B6A test edx, edx
00942B6C je 0x942baa
00942B6E lea ecx, [ebp - 0x68]
00942B71 call 0x405750
00942B76 push eax
00942B77 mov eax, dword ptr [ebp - 0xec]
00942B7D mov ecx, dword ptr [eax + 0x10]
00942B80 call 0x639820
00942B85 movzx ecx, al
00942B88 test ecx, ecx
00942B8A je 0x942baa
00942B8C lea ecx, [ebp - 0x4c]
00942B8F call 0x405750
00942B94 push eax
00942B95 mov edx, dword ptr [ebp - 0xec]
00942B9B mov ecx, dword ptr [edx + 0x10]
00942B9E call 0x639820
00942BA3 movzx eax, al
00942BA6 test eax, eax
00942BA8 jne 0x942bef
00942BAA mov byte ptr [ebp - 0xe5], 0
00942BB1 mov byte ptr [ebp - 4], 7
00942BB5 lea ecx, [ebp - 0x4c]
00942BB8 call 0x4056d0
00942BBD mov byte ptr [ebp - 4], 6
00942BC1 lea ecx, [ebp - 0x68]
00942BC4 call 0x4056d0
00942BC9 mov byte ptr [ebp - 4], 2
00942BCD lea ecx, [ebp - 0x30]
00942BD0 call 0x4056d0
00942BD5 mov dword ptr [ebp - 4], 0xffffffff
00942BDC lea ecx, [ebp - 0x84]
00942BE2 call 0x4056d0
00942BE7 mov al, byte ptr [ebp - 0xe5]
00942BED jmp 0x942c54
00942BEF mov ecx, dword ptr [ebp - 0xec]
00942BF5 call 0x942750
00942BFA push 0
00942BFC push 0
00942BFE push 0xbad064
; literal b'main'
00942C03 mov ecx, dword ptr [ebp - 0xec]
00942C09 mov ecx, dword ptr [ecx + 0x10]
00942C0C call 0x6399b0
00942C11 mov byte ptr [ebp - 0xe6], 1
00942C18 mov byte ptr [ebp - 4], 7
00942C1C lea ecx, [ebp - 0x4c]
00942C1F call 0x4056d0
00942C24 mov byte ptr [ebp - 4], 6
00942C28 lea ecx, [ebp - 0x68]
00942C2B call 0x4056d0
00942C30 mov byte ptr [ebp - 4], 2
00942C34 lea ecx, [ebp - 0x30]
00942C37 call 0x4056d0
00942C3C mov dword ptr [ebp - 4], 0xffffffff
00942C43 lea ecx, [ebp - 0x84]
00942C49 call 0x4056d0
00942C4E mov al, byte ptr [ebp - 0xe6]
00942C54 mov ecx, dword ptr [ebp - 0xc]
00942C57 mov dword ptr fs:[0], ecx
00942C5E pop ecx
00942C5F mov ecx, dword ptr [ebp - 0x14]
00942C62 xor ecx, ebp
00942C64 call 0x6634fb
00942C69 mov esp, ebp
00942C6B pop ebp
00942C6C ret
