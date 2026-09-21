; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; function 0xa4b220
00A4B220 push ebp
00A4B221 mov ebp, esp
00A4B223 push -1
00A4B225 push 0xac65b8
00A4B22A mov eax, dword ptr fs:[0]
00A4B230 push eax
00A4B231 mov eax, 0x1110
00A4B236 call 0x66d6c0
00A4B23B mov eax, dword ptr [0xc7b480]
00A4B240 xor eax, ebp
00A4B242 mov dword ptr [ebp - 0x14], eax
00A4B245 push eax
00A4B246 lea eax, [ebp - 0xc]
00A4B249 mov dword ptr fs:[0], eax
00A4B24F mov dword ptr [ebp - 0x110c], ecx
00A4B255 mov ecx, dword ptr [ebp - 0x110c]
00A4B25B call 0xa477a0
00A4B260 push 0xbc94c8
00A4B265 push 0x17c8e58
00A4B26A lea eax, [ebp - 0x10d0]
00A4B270 push eax
00A4B271 call 0x406200
00A4B276 add esp, 0xc
00A4B279 mov dword ptr [ebp - 0x1110], eax
00A4B27F mov ecx, dword ptr [ebp - 0x1110]
00A4B285 mov dword ptr [ebp - 0x1114], ecx
00A4B28B mov dword ptr [ebp - 4], 0
00A4B292 mov ecx, dword ptr [ebp - 0x1114]
00A4B298 call 0x453f50
00A4B29D push eax
00A4B29E lea ecx, [ebp - 0x10c8]
00A4B2A4 call 0x405650
00A4B2A9 mov byte ptr [ebp - 4], 2
00A4B2AD lea ecx, [ebp - 0x10d0]
00A4B2B3 call 0x406050
00A4B2B8 lea edx, [ebp - 0x10c8]
00A4B2BE push edx
00A4B2BF call 0xa5c1a0
00A4B2C4 add esp, 4
00A4B2C7 mov byte ptr [ebp - 0x10c9], al
00A4B2CD movzx eax, byte ptr [ebp - 0x10c9]
00A4B2D4 test eax, eax
00A4B2D6 jne 0xa4b2ff
00A4B2D8 mov dword ptr [ebp - 0x10d4], 0
00A4B2E2 mov dword ptr [ebp - 4], 0xffffffff
00A4B2E9 lea ecx, [ebp - 0x10c8]
00A4B2EF call 0x4056d0
00A4B2F4 mov eax, dword ptr [ebp - 0x10d4]
00A4B2FA jmp 0xa4b816
00A4B2FF push 1
00A4B301 push 0x40
00A4B303 push 1
00A4B305 lea ecx, [ebp - 0x10c8]
00A4B30B call 0x405750
00A4B310 push eax
00A4B311 lea ecx, [ebp - 0x10ac]
00A4B317 call 0x406b50
00A4B31C mov byte ptr [ebp - 4], 3
00A4B320 mov ecx, dword ptr [ebp - 0x10ac]
00A4B326 mov edx, dword ptr [ecx + 4]
00A4B329 lea ecx, [ebp + edx - 0x10ac]
00A4B330 call 0x402380
00A4B335 movzx eax, al
00A4B338 test eax, eax
00A4B33A je 0xa4b372
00A4B33C mov dword ptr [ebp - 0x10d8], 0
00A4B346 mov byte ptr [ebp - 4], 2
00A4B34A lea ecx, [ebp - 0x10ac]
00A4B350 call 0x4053a0
00A4B355 mov dword ptr [ebp - 4], 0xffffffff
00A4B35C lea ecx, [ebp - 0x10c8]
00A4B362 call 0x4056d0
00A4B367 mov eax, dword ptr [ebp - 0x10d8]
00A4B36D jmp 0xa4b816
00A4B372 mov dword ptr [ebp - 0x10], 0
00A4B379 mov dword ptr [ebp - 0x1018], 0
00A4B383 lea ecx, [ebp - 0x1018]
00A4B389 push ecx
00A4B38A lea ecx, [ebp - 0x10ac]
00A4B390 call 0x4058f0
00A4B395 mov dword ptr [ebp - 0x10dc], eax
00A4B39B mov edx, dword ptr [ebp - 0x10dc]
00A4B3A1 mov eax, dword ptr [edx]
00A4B3A3 mov ecx, dword ptr [ebp - 0x10dc]
00A4B3A9 add ecx, dword ptr [eax + 4]
00A4B3AC call 0x416090
00A4B3B1 test eax, eax
00A4B3B3 je 0xa4b7cb
00A4B3B9 push 0xa0
00A4B3BE call 0x667fbb
00A4B3C3 add esp, 4
00A4B3C6 mov dword ptr [ebp - 0x10e0], eax
00A4B3CC cmp dword ptr [ebp - 0x10e0], 0
00A4B3D3 je 0xa4b3e8
00A4B3D5 mov ecx, dword ptr [ebp - 0x10e0]
00A4B3DB call 0x531560
00A4B3E0 mov dword ptr [ebp - 0x1118], eax
00A4B3E6 jmp 0xa4b3f2
00A4B3E8 mov dword ptr [ebp - 0x1118], 0
00A4B3F2 mov ecx, dword ptr [ebp - 0x1118]
00A4B3F8 mov dword ptr [ebp - 0x10], ecx
00A4B3FB mov edx, dword ptr [ebp - 0x10]
00A4B3FE add edx, 2
00A4B401 push edx
00A4B402 mov eax, dword ptr [ebp - 0x10]
00A4B405 add eax, 0xf
00A4B408 push eax
00A4B409 mov ecx, dword ptr [ebp - 0x10]
00A4B40C add ecx, 0xd
00A4B40F push ecx
00A4B410 mov edx, dword ptr [ebp - 0x10]
00A4B413 add edx, 5
00A4B416 push edx
00A4B417 mov eax, dword ptr [ebp - 0x10]
00A4B41A add eax, 3
00A4B41D push eax
00A4B41E mov ecx, dword ptr [ebp - 0x10]
00A4B421 add ecx, 0x89
00A4B427 push ecx
00A4B428 mov edx, dword ptr [ebp - 0x10]
00A4B42B add edx, 0x85
00A4B431 push edx
00A4B432 mov eax, dword ptr [ebp - 0x10]
00A4B435 add eax, 0x81
00A4B43A push eax
00A4B43B mov ecx, dword ptr [ebp - 0x10]
00A4B43E add ecx, 0x7d
00A4B441 push ecx
00A4B442 mov edx, dword ptr [ebp - 0x10]
00A4B445 add edx, 0x79
00A4B448 push edx
00A4B449 mov eax, dword ptr [ebp - 0x10]
00A4B44C add eax, 0x75
00A4B44F push eax
00A4B450 mov ecx, dword ptr [ebp - 0x10]
00A4B453 add ecx, 0x71
00A4B456 push ecx
00A4B457 mov edx, dword ptr [ebp - 0x10]
00A4B45A add edx, 0x6d
00A4B45D push edx
00A4B45E mov eax, dword ptr [ebp - 0x10]
00A4B461 add eax, 0x69
00A4B464 push eax
00A4B465 mov ecx, dword ptr [ebp - 0x10]
00A4B468 add ecx, 0x65
00A4B46B push ecx
00A4B46C mov edx, dword ptr [ebp - 0x10]
00A4B46F add edx, 0x61
00A4B472 push edx
00A4B473 mov eax, dword ptr [ebp - 0x10]
00A4B476 add eax, 0x5d
00A4B479 push eax
00A4B47A mov ecx, dword ptr [ebp - 0x10]
00A4B47D add ecx, 0x59
00A4B480 push ecx
00A4B481 mov edx, dword ptr [ebp - 0x10]
00A4B484 add edx, 0x55
00A4B487 push edx
00A4B488 mov eax, dword ptr [ebp - 0x10]
00A4B48B add eax, 0x51
00A4B48E push eax
00A4B48F mov ecx, dword ptr [ebp - 0x10]
00A4B492 add ecx, 0x4d
00A4B495 push ecx
00A4B496 mov edx, dword ptr [ebp - 0x10]
00A4B499 add edx, 0x49
00A4B49C push edx
00A4B49D mov eax, dword ptr [ebp - 0x10]
00A4B4A0 add eax, 0x45
00A4B4A3 push eax
00A4B4A4 mov ecx, dword ptr [ebp - 0x10]
00A4B4A7 add ecx, 0x41
00A4B4AA push ecx
00A4B4AB mov edx, dword ptr [ebp - 0x10]
00A4B4AE add edx, 0x3d
00A4B4B1 push edx
00A4B4B2 mov eax, dword ptr [ebp - 0x10]
00A4B4B5 add eax, 0x39
00A4B4B8 push eax
00A4B4B9 mov ecx, dword ptr [ebp - 0x10]
00A4B4BC add ecx, 0x35
00A4B4BF push ecx
00A4B4C0 mov edx, dword ptr [ebp - 0x10]
00A4B4C3 add edx, 0x31
00A4B4C6 push edx
00A4B4C7 mov eax, dword ptr [ebp - 0x10]
00A4B4CA add eax, 0x2d
00A4B4CD push eax
00A4B4CE mov ecx, dword ptr [ebp - 0x10]
00A4B4D1 add ecx, 0x29
00A4B4D4 push ecx
00A4B4D5 mov edx, dword ptr [ebp - 0x10]
00A4B4D8 add edx, 0x25
00A4B4DB push edx
00A4B4DC mov eax, dword ptr [ebp - 0x10]
00A4B4DF add eax, 0x21
00A4B4E2 push eax
00A4B4E3 mov ecx, dword ptr [ebp - 0x10]
00A4B4E6 add ecx, 0x1d
00A4B4E9 push ecx
00A4B4EA mov edx, dword ptr [ebp - 0x10]
00A4B4ED add edx, 0x19
00A4B4F0 push edx
00A4B4F1 mov eax, dword ptr [ebp - 0x10]
00A4B4F4 add eax, 0x15
00A4B4F7 push eax
00A4B4F8 mov ecx, dword ptr [ebp - 0x10]
00A4B4FB add ecx, 0x11
00A4B4FE push ecx
00A4B4FF lea edx, [ebp - 0x414]
00A4B505 push edx
00A4B506 lea eax, [ebp - 0x814]
00A4B50C push eax
00A4B50D lea ecx, [ebp - 0xc14]
00A4B513 push ecx
00A4B514 lea edx, [ebp - 0x1014]
00A4B51A push edx
00A4B51B lea eax, [ebp - 0x10ac]
00A4B521 push eax
00A4B522 call 0x425b20
00A4B527 add esp, 8
00A4B52A push eax
00A4B52B call 0x425b20
00A4B530 add esp, 8
00A4B533 push eax
00A4B534 call 0x425b20
00A4B539 add esp, 8
00A4B53C push eax
00A4B53D call 0x425b20
00A4B542 add esp, 8
00A4B545 mov ecx, eax
00A4B547 call 0x42c140
00A4B54C mov ecx, eax
00A4B54E call 0x42c140
00A4B553 mov ecx, eax
00A4B555 call 0x42c140
00A4B55A mov ecx, eax
00A4B55C call 0x42c140
00A4B561 mov ecx, eax
00A4B563 call 0x42c140
00A4B568 mov ecx, eax
00A4B56A call 0x42c140
00A4B56F mov ecx, eax
00A4B571 call 0x42c140
00A4B576 mov ecx, eax
00A4B578 call 0x42c140
00A4B57D mov ecx, eax
00A4B57F call 0x42c140
00A4B584 mov ecx, eax
00A4B586 call 0x42c140
00A4B58B mov ecx, eax
00A4B58D call 0x42c140
00A4B592 mov ecx, eax
00A4B594 call 0x42c140
00A4B599 mov ecx, eax
00A4B59B call 0x42c140
00A4B5A0 mov ecx, eax
00A4B5A2 call 0x42c140
00A4B5A7 mov ecx, eax
00A4B5A9 call 0x42c140
00A4B5AE mov ecx, eax
00A4B5B0 call 0x42c140
00A4B5B5 mov ecx, eax
00A4B5B7 call 0x42c140
00A4B5BC mov ecx, eax
00A4B5BE call 0x42c140
00A4B5C3 mov ecx, eax
00A4B5C5 call 0x42c140
00A4B5CA mov ecx, eax
00A4B5CC call 0x42c140
00A4B5D1 mov ecx, eax
00A4B5D3 call 0x42c140
00A4B5D8 mov ecx, eax
00A4B5DA call 0x42c140
00A4B5DF mov ecx, eax
00A4B5E1 call 0x42c140
00A4B5E6 mov ecx, eax
00A4B5E8 call 0x42c140
00A4B5ED mov ecx, eax
00A4B5EF call 0x42c140
00A4B5F4 mov ecx, eax
00A4B5F6 call 0x42c140
00A4B5FB mov ecx, eax
00A4B5FD call 0x42c140
00A4B602 mov ecx, eax
00A4B604 call 0x42c140
00A4B609 mov ecx, eax
00A4B60B call 0x42c140
00A4B610 mov ecx, eax
00A4B612 call 0x42c140
00A4B617 mov ecx, eax
00A4B619 call 0x42c140
00A4B61E mov ecx, eax
00A4B620 call 0x531aa0
00A4B625 mov ecx, eax
00A4B627 call 0x42c140
00A4B62C mov ecx, eax
00A4B62E call 0x531c50
00A4B633 mov ecx, eax
00A4B635 call 0x531c50
00A4B63A mov ecx, eax
00A4B63C call 0x4bfa30
00A4B641 mov ecx, dword ptr [ebp - 0x10]
00A4B644 movzx edx, byte ptr [ecx + 2]
00A4B648 test edx, edx
00A4B64A jne 0xa4b68e
00A4B64C mov eax, dword ptr [ebp - 0x10]
00A4B64F mov dword ptr [ebp - 0x10e8], eax
00A4B655 mov ecx, dword ptr [ebp - 0x10e8]
00A4B65B mov dword ptr [ebp - 0x10e4], ecx
00A4B661 cmp dword ptr [ebp - 0x10e4], 0
00A4B668 je 0xa4b67f
00A4B66A push 1
00A4B66C mov ecx, dword ptr [ebp - 0x10e4]
00A4B672 call 0x5314e0
00A4B677 mov dword ptr [ebp - 0x111c], eax
00A4B67D jmp 0xa4b689
00A4B67F mov dword ptr [ebp - 0x111c], 0
00A4B689 jmp 0xa4b383
00A4B68E mov edx, dword ptr [ebp - 0x10]
00A4B691 mov ax, word ptr [ebp - 0x1018]
00A4B698 mov word ptr [edx], ax
00A4B69B lea ecx, [ebp - 0x1014]
00A4B6A1 push ecx
00A4B6A2 mov ecx, dword ptr [ebp - 0x10]
00A4B6A5 add ecx, 0x90
00A4B6AB call 0x406090
00A4B6B0 lea edx, [ebp - 0xc14]
00A4B6B6 push edx
00A4B6B7 mov ecx, dword ptr [ebp - 0x10]
00A4B6BA add ecx, 0x94
00A4B6C0 call 0x406090
00A4B6C5 lea eax, [ebp - 0x814]
00A4B6CB push eax
00A4B6CC mov ecx, dword ptr [ebp - 0x10]
00A4B6CF add ecx, 0x98
00A4B6D5 call 0x406090
00A4B6DA lea ecx, [ebp - 0x414]
00A4B6E0 push ecx
00A4B6E1 mov ecx, dword ptr [ebp - 0x10]
00A4B6E4 add ecx, 0x9c
00A4B6EA call 0x406090
00A4B6EF push 0
00A4B6F1 mov ecx, dword ptr [ebp - 0x10]
00A4B6F4 add ecx, 0x90
00A4B6FA call 0x56daf0
00A4B6FF movsx edx, al
00A4B702 cmp edx, 0x23
00A4B705 jne 0xa4b715
00A4B707 mov ecx, dword ptr [ebp - 0x10]
00A4B70A add ecx, 0x90
00A4B710 call 0x4063a0
00A4B715 push 0
00A4B717 mov ecx, dword ptr [ebp - 0x10]
00A4B71A add ecx, 0x94
00A4B720 call 0x56daf0
00A4B725 movsx eax, al
00A4B728 cmp eax, 0x23
00A4B72B jne 0xa4b73b
00A4B72D mov ecx, dword ptr [ebp - 0x10]
00A4B730 add ecx, 0x94
00A4B736 call 0x4063a0
00A4B73B push 0
00A4B73D mov ecx, dword ptr [ebp - 0x10]
00A4B740 add ecx, 0x98
00A4B746 call 0x56daf0
00A4B74B movsx ecx, al
00A4B74E cmp ecx, 0x23
00A4B751 jne 0xa4b761
00A4B753 mov ecx, dword ptr [ebp - 0x10]
00A4B756 add ecx, 0x98
00A4B75C call 0x4063a0
00A4B761 push 0
00A4B763 mov ecx, dword ptr [ebp - 0x10]
00A4B766 add ecx, 0x9c
00A4B76C call 0x56daf0
00A4B771 movsx edx, al
00A4B774 cmp edx, 0x23
00A4B777 jne 0xa4b787
00A4B779 mov ecx, dword ptr [ebp - 0x10]
00A4B77C add ecx, 0x9c
00A4B782 call 0x4063a0
00A4B787 mov eax, dword ptr [ebp - 0x10]
00A4B78A push eax
00A4B78B mov ecx, dword ptr [ebp - 0x10]
00A4B78E movzx edx, word ptr [ecx]
00A4B791 push edx
00A4B792 lea eax, [ebp - 0x10f8]
00A4B798 push eax
00A4B799 call 0x419480
00A4B79E add esp, 0xc
00A4B7A1 push eax
00A4B7A2 lea ecx, [ebp - 0x10f0]
00A4B7A8 call 0x5398e0
00A4B7AD lea ecx, [ebp - 0x10f0]
00A4B7B3 push ecx
00A4B7B4 lea edx, [ebp - 0x1104]
00A4B7BA push edx
00A4B7BB mov ecx, dword ptr [ebp - 0x110c]
00A4B7C1 call 0x449df0
00A4B7C6 jmp 0xa4b383
00A4B7CB lea ecx, [ebp - 0x10ac]
00A4B7D1 call 0x406cb0
00A4B7D6 lea eax, [ebp - 0x10c8]
00A4B7DC push eax
00A4B7DD call 0xa5b810
00A4B7E2 add esp, 4
00A4B7E5 mov dword ptr [ebp - 0x1108], 1
00A4B7EF mov byte ptr [ebp - 4], 2
00A4B7F3 lea ecx, [ebp - 0x10ac]
00A4B7F9 call 0x4053a0
00A4B7FE mov dword ptr [ebp - 4], 0xffffffff
00A4B805 lea ecx, [ebp - 0x10c8]
00A4B80B call 0x4056d0
00A4B810 mov eax, dword ptr [ebp - 0x1108]
00A4B816 mov ecx, dword ptr [ebp - 0xc]
00A4B819 mov dword ptr fs:[0], ecx
00A4B820 pop ecx
00A4B821 mov ecx, dword ptr [ebp - 0x14]
00A4B824 xor ecx, ebp
00A4B826 call 0x6634fb
00A4B82B mov esp, ebp
00A4B82D pop ebp
00A4B82E ret
00A4B82F int3
00A4B830 push ebp
00A4B831 mov ebp, esp
00A4B833 push -1
00A4B835 push 0xacc683
00A4B83A mov eax, dword ptr fs:[0]
00A4B840 push eax
00A4B841 push ecx
00A4B842 mov eax, dword ptr [0xc7b480]
00A4B847 xor eax, ebp
00A4B849 push eax
00A4B84A lea eax, [ebp - 0xc]
00A4B84D mov dword ptr fs:[0], eax
00A4B853 mov dword ptr [ebp - 0x10], ecx
00A4B856 mov ecx, dword ptr [ebp - 0x10]
00A4B859 call 0x406910
00A4B85E mov dword ptr [ebp - 4], 0
00A4B865 mov ecx, dword ptr [ebp - 0x10]
00A4B868 add ecx, 0x20
00A4B86B call 0x406a60
00A4B870 mov byte ptr [ebp - 4], 1
00A4B874 mov ecx, dword ptr [ebp - 0x10]
00A4B877 add ecx, 0x40
00A4B87A call 0x587960
00A4B87F mov byte ptr [ebp - 4], 2
00A4B883 mov ecx, dword ptr [ebp - 0x10]
00A4B886 add ecx, 0x58
00A4B889 call 0x406590
00A4B88E mov byte ptr [ebp - 4], 3
00A4B892 mov ecx, dword ptr [ebp - 0x10]
00A4B895 call 0xa4a300
00A4B89A mov ecx, dword ptr [ebp - 0x10]
00A4B89D call 0x531480
00A4B8A2 mov dword ptr [ebp - 4], 0xffffffff
00A4B8A9 mov eax, dword ptr [ebp - 0x10]
00A4B8AC mov ecx, dword ptr [ebp - 0xc]
00A4B8AF mov dword ptr fs:[0], ecx
00A4B8B6 pop ecx
00A4B8B7 mov esp, ebp
00A4B8B9 pop ebp
00A4B8BA ret
00A4B8BB int3
00A4B8BC int3
00A4B8BD int3
00A4B8BE int3
00A4B8BF int3
00A4B8C0 push ebp
00A4B8C1 mov ebp, esp
00A4B8C3 push -1
00A4B8C5 push 0xacc6c7
00A4B8CA mov eax, dword ptr fs:[0]
00A4B8D0 push eax
00A4B8D1 push ecx
00A4B8D2 mov eax, dword ptr [0xc7b480]
00A4B8D7 xor eax, ebp
00A4B8D9 push eax
00A4B8DA lea eax, [ebp - 0xc]
00A4B8DD mov dword ptr fs:[0], eax
00A4B8E3 mov dword ptr [ebp - 0x10], ecx
00A4B8E6 mov ecx, dword ptr [ebp - 0x10]
00A4B8E9 call 0x47f540
00A4B8EE mov dword ptr [ebp - 4], 0
00A4B8F5 mov ecx, dword ptr [ebp - 0x10]
00A4B8F8 add ecx, 0x20
00A4B8FB call 0x406910
00A4B900 mov byte ptr [ebp - 4], 1
00A4B904 mov ecx, dword ptr [ebp - 0x10]
00A4B907 add ecx, 0x40
00A4B90A call 0x587960
00A4B90F mov byte ptr [ebp - 4], 2
00A4B913 mov ecx, dword ptr [ebp - 0x10]
00A4B916 add ecx, 0x58
00A4B919 call 0x406590
00A4B91E mov byte ptr [ebp - 4], 3
00A4B922 mov ecx, dword ptr [ebp - 0x10]
00A4B925 call 0xa4aae0
00A4B92A mov ecx, dword ptr [ebp - 0x10]
00A4B92D call 0x531460
00A4B932 mov dword ptr [ebp - 4], 0xffffffff
00A4B939 mov eax, dword ptr [ebp - 0x10]
00A4B93C mov ecx, dword ptr [ebp - 0xc]
00A4B93F mov dword ptr fs:[0], ecx
00A4B946 pop ecx
00A4B947 mov esp, ebp
00A4B949 pop ebp
00A4B94A ret
00A4B94B int3
00A4B94C int3
00A4B94D int3
00A4B94E int3
00A4B94F int3
; function 0xa48aa0
00A48AA0 push ebp
00A48AA1 mov ebp, esp
00A48AA3 sub esp, 0x2c
00A48AA6 push esi
00A48AA7 mov dword ptr [ebp - 0x24], ecx
00A48AAA mov eax, dword ptr [0x1ddb0f8]
00A48AAF and eax, 1
00A48AB2 jne 0xa48ada
00A48AB4 mov ecx, dword ptr [0x1ddb0f8]
00A48ABA or ecx, 1
00A48ABD mov dword ptr [0x1ddb0f8], ecx
00A48AC3 mov ecx, 0x1ddb0ec
00A48AC8 call 0x531230
00A48ACD push 0xb311b0
00A48AD2 call 0x663631
00A48AD7 add esp, 4
00A48ADA mov dword ptr [ebp - 4], 0
00A48AE1 movzx edx, word ptr [ebp + 8]
00A48AE5 push edx
00A48AE6 mov ecx, dword ptr [ebp - 0x24]
00A48AE9 call 0xa47d00
00A48AEE mov dword ptr [ebp - 0x1c], eax
00A48AF1 movzx eax, word ptr [ebp + 8]
00A48AF5 push eax
00A48AF6 mov ecx, dword ptr [ebp - 0x24]
00A48AF9 call 0xa47400
00A48AFE mov dword ptr [ebp - 0x18], eax
00A48B01 cmp dword ptr [ebp - 0x1c], 0
00A48B05 je 0xa48b0d
00A48B07 cmp dword ptr [ebp - 0x18], 0
00A48B0B jne 0xa48b17
00A48B0D mov eax, 0x1ddb0ec
00A48B12 jmp 0xa48d82
00A48B17 mov ecx, dword ptr [0x17c86fc]
00A48B1D call 0x9cd390
00A48B22 mov dword ptr [ebp - 0x10], eax
00A48B25 mov ecx, dword ptr [ebp - 0x1c]
00A48B28 cmp dword ptr [ecx + 0x11], 0
00A48B2C jbe 0xa48bf5
00A48B32 mov edx, dword ptr [ebp - 4]
00A48B35 cmp edx, dword ptr [ebp + 0xc]
00A48B38 jge 0xa48b48
00A48B3A mov eax, dword ptr [ebp - 4]
00A48B3D add eax, 1
00A48B40 mov dword ptr [ebp - 4], eax
00A48B43 jmp 0xa48bf5
00A48B48 mov ecx, dword ptr [ebp - 0x1c]
00A48B4B mov edx, dword ptr [ecx + 0x11]
00A48B4E mov dword ptr [0x1ddb0ec], edx
00A48B54 mov eax, dword ptr [ebp - 0x18]
00A48B57 mov cl, byte ptr [eax + 6]
00A48B5A mov byte ptr [ebp - 0x28], cl
00A48B5D cmp byte ptr [ebp - 0x28], 1
00A48B61 je 0xa48b71
00A48B63 cmp byte ptr [ebp - 0x28], 2
00A48B67 je 0xa48b7d
00A48B69 cmp byte ptr [ebp - 0x28], 3
00A48B6D je 0xa48bc0
00A48B6F jmp 0xa48bcc
00A48B71 mov dword ptr [0x1ddb0f0], 0
00A48B7B jmp 0xa48bcc
00A48B7D mov edx, dword ptr [ebp - 0x10]
00A48B80 mov eax, dword ptr [edx + 0x85]
00A48B86 mov ecx, dword ptr [ebp - 0x10]
00A48B89 add eax, dword ptr [ecx + 0x8d]
00A48B8F mov edx, dword ptr [ebp - 0x10]
00A48B92 add eax, dword ptr [edx + 0x95]
00A48B98 mov ecx, dword ptr [ebp - 0x10]
00A48B9B add eax, dword ptr [ecx + 0x9d]
00A48BA1 mov edx, dword ptr [ebp - 0x18]
00A48BA4 sub eax, dword ptr [edx + 0xb]
00A48BA7 mov ecx, dword ptr [ebp - 0x18]
00A48BAA sub eax, dword ptr [ecx + 0x13]
00A48BAD mov edx, dword ptr [ebp - 0x18]
00A48BB0 sub eax, dword ptr [edx + 0x1b]
00A48BB3 mov ecx, dword ptr [ebp - 0x18]
00A48BB6 sub eax, dword ptr [ecx + 0x23]
00A48BB9 mov dword ptr [0x1ddb0f0], eax
00A48BBE jmp 0xa48bcc
00A48BC0 mov edx, dword ptr [0x1ddb0ec]
00A48BC6 mov dword ptr [0x1ddb0f0], edx
00A48BCC mov eax, dword ptr [0x1ddb0ec]
00A48BD1 push eax
00A48BD2 mov ecx, dword ptr [0x1ddb0f0]
00A48BD8 push ecx
00A48BD9 push 0xbc94e4
00A48BDE push 0x1ddb0f4
00A48BE3 call 0x411c60
00A48BE8 add esp, 0x10
00A48BEB mov eax, 0x1ddb0ec
00A48BF0 jmp 0xa48d82
00A48BF5 mov edx, dword ptr [ebp - 0x1c]
00A48BF8 cmp dword ptr [edx + 0x15], 0
00A48BFC jbe 0xa48c68
00A48BFE mov eax, dword ptr [ebp - 4]
00A48C01 cmp eax, dword ptr [ebp + 0xc]
00A48C04 jge 0xa48c11
00A48C06 mov ecx, dword ptr [ebp - 4]
00A48C09 add ecx, 1
00A48C0C mov dword ptr [ebp - 4], ecx
00A48C0F jmp 0xa48c68
00A48C11 mov edx, dword ptr [ebp - 0x1c]
00A48C14 mov eax, dword ptr [edx + 0x15]
00A48C17 mov dword ptr [0x1ddb0ec], eax
00A48C1C mov ecx, dword ptr [ebp - 0x18]
00A48C1F movzx edx, byte ptr [ecx + 6]
00A48C23 cmp edx, 3
00A48C26 jne 0xa48c34
00A48C28 mov eax, dword ptr [0x1ddb0ec]
00A48C2D mov dword ptr [0x1ddb0f0], eax
00A48C32 jmp 0xa48c3e
00A48C34 mov dword ptr [0x1ddb0f0], 0
00A48C3E mov ecx, dword ptr [0x1ddb0ec]
00A48C44 push ecx
00A48C45 mov edx, dword ptr [0x1ddb0f0]
00A48C4B push edx
00A48C4C push 0xbc9500
00A48C51 push 0x1ddb0f4
00A48C56 call 0x411c60
00A48C5B add esp, 0x10
00A48C5E mov eax, 0x1ddb0ec
00A48C63 jmp 0xa48d82
00A48C68 mov eax, dword ptr [ebp - 0x10]
00A48C6B add eax, 0x81
00A48C70 mov dword ptr [ebp - 0x14], eax
00A48C73 mov ecx, dword ptr [ebp - 0x1c]
00A48C76 add ecx, 0x19
00A48C79 mov dword ptr [ebp - 8], ecx
00A48C7C mov edx, dword ptr [ebp - 0x18]
00A48C7F add edx, 7
00A48C82 mov dword ptr [ebp - 0xc], edx
00A48C85 mov dword ptr [ebp - 0x20], 0
00A48C8C jmp 0xa48c97
00A48C8E mov eax, dword ptr [ebp - 0x20]
00A48C91 add eax, 1
00A48C94 mov dword ptr [ebp - 0x20], eax
00A48C97 cmp dword ptr [ebp - 0x20], 0x1d
00A48C9B jge 0xa48d5f
00A48CA1 mov ecx, dword ptr [ebp - 0x20]
00A48CA4 mov edx, dword ptr [ebp - 8]
00A48CA7 cmp dword ptr [edx + ecx*4], 0
00A48CAB jbe 0xa48d5a
00A48CB1 mov eax, dword ptr [ebp - 4]
00A48CB4 cmp eax, dword ptr [ebp + 0xc]
00A48CB7 jge 0xa48cc9
00A48CB9 mov ecx, dword ptr [ebp - 4]
00A48CBC add ecx, 1
00A48CBF mov dword ptr [ebp - 4], ecx
00A48CC2 jmp 0xa48c8e
00A48CC4 jmp 0xa48d5a
00A48CC9 mov edx, dword ptr [ebp - 0x20]
00A48CCC mov eax, dword ptr [ebp - 8]
00A48CCF mov ecx, dword ptr [eax + edx*4]
00A48CD2 mov dword ptr [0x1ddb0ec], ecx
00A48CD8 mov edx, dword ptr [ebp - 0x18]
00A48CDB mov al, byte ptr [edx + 6]
00A48CDE mov byte ptr [ebp - 0x2c], al
00A48CE1 cmp byte ptr [ebp - 0x2c], 1
00A48CE5 je 0xa48cf5
00A48CE7 cmp byte ptr [ebp - 0x2c], 2
00A48CEB je 0xa48d01
00A48CED cmp byte ptr [ebp - 0x2c], 3
00A48CF1 je 0xa48d1b
00A48CF3 jmp 0xa48d27
00A48CF5 mov dword ptr [0x1ddb0f0], 0
00A48CFF jmp 0xa48d27
00A48D01 mov ecx, dword ptr [ebp - 0x20]
00A48D04 mov edx, dword ptr [ebp - 0x14]
00A48D07 mov eax, dword ptr [ebp - 0x20]
00A48D0A mov esi, dword ptr [ebp - 0xc]
00A48D0D mov ecx, dword ptr [edx + ecx*4]
00A48D10 sub ecx, dword ptr [esi + eax*4]
00A48D13 mov dword ptr [0x1ddb0f0], ecx
00A48D19 jmp 0xa48d27
00A48D1B mov edx, dword ptr [0x1ddb0ec]
00A48D21 mov dword ptr [0x1ddb0f0], edx
00A48D27 mov eax, dword ptr [0x1ddb0ec]
00A48D2C push eax
00A48D2D mov ecx, dword ptr [0x1ddb0f0]
00A48D33 push ecx
00A48D34 mov edx, dword ptr [ebp - 0x20]
00A48D37 shl edx, 7
00A48D3A add edx, 0xb974a8
00A48D40 push edx
00A48D41 push 0xbc9518
00A48D46 push 0x1ddb0f4
00A48D4B call 0x411c60
00A48D50 add esp, 0x14
00A48D53 mov eax, 0x1ddb0ec
00A48D58 jmp 0xa48d82
00A48D5A jmp 0xa48c8e
00A48D5F mov dword ptr [0x1ddb0f0], 0
00A48D69 mov dword ptr [0x1ddb0ec], 0
00A48D73 mov ecx, 0x1ddb0f4
00A48D78 call 0x4063a0
00A48D7D mov eax, 0x1ddb0ec
00A48D82 pop esi
00A48D83 mov esp, ebp
00A48D85 pop ebp
00A48D86 ret 8
00A48D89 int3
00A48D8A int3
00A48D8B int3
00A48D8C int3
00A48D8D int3
00A48D8E int3
00A48D8F int3
