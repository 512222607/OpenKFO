; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Head label uses +1B18, not +1B90 GetNetDelay.
; RANGE 0x7fbb25..0x7fbba7
007FBB25 mov ecx, dword ptr [ebp + 8]
007FBB28 call 0x9e7c70
007FBB2D test eax, eax
007FBB2F jne 0x7fbc29
007FBB35 mov ecx, dword ptr [0x17c8708]
007FBB3B call 0x819120
007FBB40 test eax, eax
007FBB42 je 0x7fbc29
007FBB48 mov ecx, dword ptr [ebp + 8]
007FBB4B call 0x5564e0
007FBB50 mov dword ptr [ebp - 0x20], eax
007FBB53 lea ecx, [ebp - 0x24]
007FBB56 call 0x405f90
007FBB5B mov byte ptr [ebp - 4], 6
007FBB5F mov ecx, dword ptr [ebp - 0x20]
007FBB62 push ecx
007FBB63 push 0xbcdf04
007FBB68 lea edx, [ebp - 0x24]
007FBB6B push edx
007FBB6C call 0x411c60
007FBB71 add esp, 0xc
007FBB74 push 0
007FBB76 lea ecx, [ebp - 0x24]
007FBB79 call 0x40b720
007FBB7E push eax
007FBB7F lea ecx, [ebp - 0xcc]
007FBB85 call 0x405650
007FBB8A mov byte ptr [ebp - 4], 7
007FBB8E push 1
007FBB90 lea eax, [ebp - 0xcc]
007FBB96 push eax
007FBB97 mov ecx, dword ptr [ebp - 0x10]
007FBB9A mov edx, dword ptr [ecx]
007FBB9C mov ecx, dword ptr [ebp - 0x10]
007FBB9F mov eax, dword ptr [edx + 0xd4]
007FBBA5 call eax
; RANGE 0x5564e0..0x5564f4
005564E0 push ebp
005564E1 mov ebp, esp
005564E3 push ecx
005564E4 mov dword ptr [ebp - 4], ecx
005564E7 mov eax, dword ptr [ebp - 4]
005564EA mov eax, dword ptr [eax + 0x1b18]
005564F0 mov esp, ebp
005564F2 pop ebp
005564F3 ret
; RANGE 0x9e9710..0x9e98e8
009E9710 push ebp
009E9711 mov ebp, esp
009E9713 sub esp, 0x34
009E9716 mov dword ptr [ebp - 0x30], ecx
009E9719 mov eax, dword ptr [ebp + 0xc]
009E971C push eax
009E971D mov ecx, dword ptr [ebp + 8]
009E9720 push ecx
009E9721 mov ecx, dword ptr [0x17c8708]
009E9727 call 0x818c70
009E972C mov dword ptr [ebp - 4], eax
009E972F mov ecx, dword ptr [ebp - 0x30]
009E9732 call 0x9e7c70
009E9737 test eax, eax
009E9739 je 0x9e9770
009E973B cmp dword ptr [ebp - 4], 0
009E973F je 0x9e976b
009E9741 mov ecx, dword ptr [ebp - 4]
009E9744 call 0x453630
009E9749 mov dword ptr [ebp - 8], eax
009E974C push 1
009E974E lea edx, [ebp - 8]
009E9751 push edx
009E9752 push 0x18
009E9754 lea eax, [ebp + 8]
009E9757 push eax
009E9758 push 0
009E975A push 0x2710
009E975F call 0x7d03e0
009E9764 mov ecx, eax
009E9766 call 0x7d0330
009E976B jmp 0x9e98e2
009E9770 mov ecx, dword ptr [ebp - 0x30]
009E9773 mov dword ptr [ebp - 0x34], ecx
009E9776 mov edx, dword ptr [ebp - 0x34]
009E9779 mov eax, dword ptr [ebp + 0x18]
009E977C cmp eax, dword ptr [edx + 0x1b40]
009E9782 jne 0x9e98e2
009E9788 mov ecx, dword ptr [ebp - 0x34]
009E978B mov edx, dword ptr [ebp + 0x1c]
009E978E cmp edx, dword ptr [ecx + 0x1b44]
009E9794 jne 0x9e98e2
009E979A mov eax, dword ptr [ebp - 0x30]
009E979D mov ecx, dword ptr [0x17c8690]
009E97A3 sub ecx, dword ptr [eax + 0x1b4c]
009E97A9 mov dword ptr [ebp - 0xc], ecx
009E97AC mov edx, dword ptr [ebp - 0xc]
009E97AF mov dword ptr [ebp - 0x14], edx
009E97B2 lea eax, [ebp - 0x14]
009E97B5 push eax
009E97B6 mov ecx, dword ptr [ebp - 0x30]
009E97B9 add ecx, 0x1b1c
009E97BF call 0x4a5c30
009E97C4 mov ecx, dword ptr [ebp - 0x30]
009E97C7 add ecx, 0x1b1c
009E97CD call 0x55f000
009E97D2 cmp eax, 5
009E97D5 jbe 0x9e980e
009E97D7 lea ecx, [ebp - 0x24]
009E97DA push ecx
009E97DB mov ecx, dword ptr [ebp - 0x30]
009E97DE add ecx, 0x1b1c
009E97E4 call 0x4d6050
009E97E9 mov edx, dword ptr [eax]
009E97EB mov eax, dword ptr [eax + 4]
009E97EE mov dword ptr [ebp - 0x1c], edx
009E97F1 mov dword ptr [ebp - 0x18], eax
009E97F4 mov ecx, dword ptr [ebp - 0x18]
009E97F7 push ecx
009E97F8 mov edx, dword ptr [ebp - 0x1c]
009E97FB push edx
009E97FC lea eax, [ebp - 0x2c]
009E97FF push eax
009E9800 mov ecx, dword ptr [ebp - 0x30]
009E9803 add ecx, 0x1b1c
009E9809 call 0x581000
009E980E mov ecx, dword ptr [ebp - 0x30]
009E9811 add ecx, 0x1b1c
009E9817 call 0x55f000
009E981C mov ecx, dword ptr [ebp - 0x30]
009E981F mov dword ptr [ecx + 0x1b38], eax
009E9825 mov edx, dword ptr [ebp - 0x30]
009E9828 mov dword ptr [edx + 0x1b34], 0
009E9832 mov dword ptr [ebp - 0x10], 0
009E9839 jmp 0x9e9844
009E983B mov eax, dword ptr [ebp - 0x10]
009E983E add eax, 1
009E9841 mov dword ptr [ebp - 0x10], eax
009E9844 mov ecx, dword ptr [ebp - 0x30]
009E9847 mov edx, dword ptr [ebp - 0x10]
009E984A cmp edx, dword ptr [ecx + 0x1b38]
009E9850 jge 0x9e987a
009E9852 mov eax, dword ptr [ebp - 0x10]
009E9855 push eax
009E9856 mov ecx, dword ptr [ebp - 0x30]
009E9859 add ecx, 0x1b1c
009E985F call 0x491640
009E9864 mov ecx, dword ptr [ebp - 0x30]
009E9867 mov edx, dword ptr [ecx + 0x1b34]
009E986D add edx, dword ptr [eax]
009E986F mov eax, dword ptr [ebp - 0x30]
009E9872 mov dword ptr [eax + 0x1b34], edx
009E9878 jmp 0x9e983b
009E987A mov ecx, dword ptr [ebp - 0x30]
009E987D cmp dword ptr [ecx + 0x1b38], 0
009E9884 je 0x9e98a4
009E9886 mov edx, dword ptr [ebp - 0x30]
009E9889 mov ecx, dword ptr [ebp - 0x30]
009E988C mov eax, dword ptr [edx + 0x1b34]
009E9892 cdq
009E9893 idiv dword ptr [ecx + 0x1b38]
009E9899 mov edx, dword ptr [ebp - 0x30]
009E989C mov dword ptr [edx + 0x1b18], eax
009E98A2 jmp 0x9e98b1
009E98A4 mov eax, dword ptr [ebp - 0x30]
009E98A7 mov dword ptr [eax + 0x1b18], 0x15e
009E98B1 mov ecx, dword ptr [ebp - 0x30]
009E98B4 mov edx, dword ptr [ecx + 0x1b40]
009E98BA add edx, 1
009E98BD mov eax, dword ptr [ecx + 0x1b44]
009E98C3 adc eax, 0
009E98C6 mov ecx, dword ptr [ebp - 0x30]
009E98C9 mov dword ptr [ecx + 0x1b40], edx
009E98CF mov dword ptr [ecx + 0x1b44], eax
009E98D5 mov edx, dword ptr [ebp - 0x30]
009E98D8 mov dword ptr [edx + 0x1b48], 1
009E98E2 mov esp, ebp
009E98E4 pop ebp
009E98E5 ret 0x18
