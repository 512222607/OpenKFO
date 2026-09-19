; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Renewal request builders and reminder-only removal. No server price authority inferred.
; RANGE 008BAD50-008BAE22
008BAD50 push ebp
008BAD51 mov ebp, esp
008BAD53 sub esp, 0x110
008BAD59 mov eax, dword ptr [0xc7b480]
008BAD5E xor eax, ebp
008BAD60 mov dword ptr [ebp - 4], eax
008BAD63 push esi
008BAD64 push edi
008BAD65 mov dword ptr [ebp - 0x10c], ecx
008BAD6B lea eax, [ebp - 0x108]
008BAD71 push eax
008BAD72 mov ecx, dword ptr [ebp + 8]
008BAD75 push ecx
008BAD76 mov ecx, dword ptr [ebp - 0x10c]
008BAD7C call 0x8b9180
008BAD81 test eax, eax
008BAD83 jne 0x8bad8a
008BAD85 jmp 0x8bae12
008BAD8A call 0x504b60
008BAD8F mov dword ptr [ebp - 0x110], eax
008BAD95 mov edx, dword ptr [ebp - 0x110]
008BAD9B mov eax, dword ptr [edx]
008BAD9D mov ecx, dword ptr [ebp - 0x110]
008BADA3 mov edx, dword ptr [eax + 0x108]
008BADA9 call edx
008BADAB mov ecx, 0x1b
008BADB0 lea esi, [ebp - 0xf8]
008BADB6 lea edi, [ebp - 0x78]
008BADB9 rep movsd dword ptr es:[edi], dword ptr [esi]
008BADBB lea eax, [ebp - 0x108]
008BADC1 push eax
008BADC2 call 0x504b60
008BADC7 mov ecx, eax
008BADC9 call 0x8c2560
008BADCE push 9
008BADD0 push 0
008BADD2 lea ecx, [ebp - 0x84]
008BADD8 push ecx
008BADD9 call 0x666960
008BADDE add esp, 0xc
008BADE1 mov dl, byte ptr [ebp - 0x74]
008BADE4 mov byte ptr [ebp - 0x84], dl
008BADEA mov eax, dword ptr [ebp - 0x73]
008BADED mov dword ptr [ebp - 0x83], eax
008BADF3 mov dword ptr [ebp - 0x7f], 1
008BADFA push 9
008BADFC lea ecx, [ebp - 0x84]
008BAE02 push ecx
008BAE03 push 0
008BAE05 push 0x5dc
008BAE0A call 0xa3c950
008BAE0F add esp, 0x10
008BAE12 pop edi
008BAE13 pop esi
008BAE14 mov ecx, dword ptr [ebp - 4]
008BAE17 xor ecx, ebp
008BAE19 call 0x6634fb
008BAE1E mov esp, ebp
008BAE20 pop ebp
; RANGE 008BC020-008BC196
008BC020 push ebp
008BC021 mov ebp, esp
008BC023 push -1
008BC025 push 0xad96a7
008BC02A mov eax, dword ptr fs:[0]
008BC030 push eax
008BC031 sub esp, 0x78
008BC034 mov eax, dword ptr [0xc7b480]
008BC039 xor eax, ebp
008BC03B push eax
008BC03C lea eax, [ebp - 0xc]
008BC03F mov dword ptr fs:[0], eax
008BC045 mov dword ptr [ebp - 0x84], ecx
008BC04B lea ecx, [ebp - 0x14]
008BC04E call 0x471ae0
008BC053 lea eax, [ebp - 0x38]
008BC056 push eax
008BC057 mov ecx, dword ptr [ebp - 0x84]
008BC05D add ecx, 0x5b0
008BC063 call 0x561740
008BC068 mov ecx, dword ptr [eax]
008BC06A mov edx, dword ptr [eax + 4]
008BC06D mov dword ptr [ebp - 0x14], ecx
008BC070 mov dword ptr [ebp - 0x10], edx
008BC073 jmp 0x8bc07d
008BC075 lea ecx, [ebp - 0x14]
008BC078 call 0x504fb0
008BC07D lea eax, [ebp - 0x40]
008BC080 push eax
008BC081 mov ecx, dword ptr [ebp - 0x84]
008BC087 add ecx, 0x5b0
008BC08D call 0x44a4d0
008BC092 push eax
008BC093 lea ecx, [ebp - 0x14]
008BC096 call 0x44a500
008BC09B movzx ecx, al
008BC09E test ecx, ecx
008BC0A0 je 0x8bc0df
008BC0A2 lea ecx, [ebp - 0x14]
008BC0A5 call 0x504f90
008BC0AA mov edx, dword ptr [ebp + 8]
008BC0AD cmp edx, dword ptr [eax + 8]
008BC0B0 jne 0x8bc0dd
008BC0B2 mov eax, dword ptr [ebp - 0x14]
008BC0B5 mov dword ptr [ebp - 0x48], eax
008BC0B8 mov ecx, dword ptr [ebp - 0x10]
008BC0BB mov dword ptr [ebp - 0x44], ecx
008BC0BE mov edx, dword ptr [ebp - 0x44]
008BC0C1 push edx
008BC0C2 mov eax, dword ptr [ebp - 0x48]
008BC0C5 push eax
008BC0C6 lea ecx, [ebp - 0x50]
008BC0C9 push ecx
008BC0CA mov ecx, dword ptr [ebp - 0x84]
008BC0D0 add ecx, 0x5b0
008BC0D6 call 0x43e970
008BC0DB jmp 0x8bc0df
008BC0DD jmp 0x8bc075
008BC0DF lea ecx, [ebp - 0x30]
008BC0E2 call 0x504de0
008BC0E7 mov dword ptr [ebp - 4], 0
008BC0EE lea edx, [ebp - 0x58]
008BC0F1 push edx
008BC0F2 lea ecx, [ebp - 0x30]
008BC0F5 call 0x561740
008BC0FA mov ecx, dword ptr [eax + 4]
008BC0FD push ecx
008BC0FE mov edx, dword ptr [eax]
008BC100 push edx
008BC101 lea eax, [ebp - 0x30]
008BC104 push eax
008BC105 lea ecx, [ebp - 0x64]
008BC108 push ecx
008BC109 call 0x419580
008BC10E add esp, 4
008BC111 mov edx, esp
008BC113 mov ecx, dword ptr [eax]
008BC115 mov dword ptr [edx], ecx
008BC117 mov ecx, dword ptr [eax + 4]
008BC11A mov dword ptr [edx + 4], ecx
008BC11D mov eax, dword ptr [eax + 8]
008BC120 mov dword ptr [edx + 8], eax
008BC123 lea ecx, [ebp - 0x6c]
008BC126 push ecx
008BC127 mov ecx, dword ptr [ebp - 0x84]
008BC12D add ecx, 0x5b0
008BC133 call 0x44a4d0
008BC138 mov edx, dword ptr [eax + 4]
008BC13B push edx
008BC13C mov eax, dword ptr [eax]
008BC13E push eax
008BC13F lea ecx, [ebp - 0x74]
008BC142 push ecx
008BC143 mov ecx, dword ptr [ebp - 0x84]
008BC149 add ecx, 0x5b0
008BC14F call 0x561740
008BC154 mov edx, dword ptr [eax + 4]
008BC157 push edx
008BC158 mov eax, dword ptr [eax]
008BC15A push eax
008BC15B lea ecx, [ebp - 0x80]
008BC15E push ecx
008BC15F call 0x5052b0
008BC164 add esp, 0x20
008BC167 lea edx, [ebp - 0x30]
008BC16A push edx
008BC16B mov ecx, dword ptr [ebp - 0x84]
008BC171 call 0x8bbc20
008BC176 mov dword ptr [ebp - 4], 0xffffffff
008BC17D lea ecx, [ebp - 0x30]
008BC180 call 0x5327c0
008BC185 mov ecx, dword ptr [ebp - 0xc]
008BC188 mov dword ptr fs:[0], ecx
008BC18F pop ecx
008BC190 mov esp, ebp
008BC192 pop ebp
008BC193 ret 4
; RANGE 008BC8F0-008BC97A
008BC8F0 push ebp
008BC8F1 mov ebp, esp
008BC8F3 push -1
008BC8F5 push 0xadb03f
008BC8FA mov eax, dword ptr fs:[0]
008BC900 push eax
008BC901 sub esp, 0x24
008BC904 mov eax, dword ptr [0xc7b480]
008BC909 xor eax, ebp
008BC90B push eax
008BC90C lea eax, [ebp - 0xc]
008BC90F mov dword ptr fs:[0], eax
008BC915 mov dword ptr [ebp - 0x2c], ecx
008BC918 push 0xbbc520
008BC91D lea ecx, [ebp - 0x28]
008BC920 call 0x405650
008BC925 mov dword ptr [ebp - 4], 0
008BC92C call 0x403820
008BC931 mov dword ptr [ebp - 0x30], eax
008BC934 push 0
008BC936 push 0
008BC938 push 0
008BC93A lea eax, [ebp - 0x28]
008BC93D push eax
008BC93E mov ecx, dword ptr [ebp - 0x30]
008BC941 mov edx, dword ptr [ecx]
008BC943 mov ecx, dword ptr [ebp - 0x30]
008BC946 mov eax, dword ptr [edx + 0x1c0]
008BC94C call eax
008BC94E mov dword ptr [ebp - 4], 0xffffffff
008BC955 lea ecx, [ebp - 0x28]
008BC958 call 0x4056d0
008BC95D mov ecx, dword ptr [ebp + 8]
008BC960 push ecx
008BC961 mov ecx, dword ptr [ebp - 0x2c]
008BC964 call 0x8bc020
008BC969 mov ecx, dword ptr [ebp - 0xc]
008BC96C mov dword ptr fs:[0], ecx
008BC973 pop ecx
008BC974 mov esp, ebp
008BC976 pop ebp
008BC977 ret 4
; RANGE 008C2560-008C2650
008C2560 push ebp
008C2561 mov ebp, esp
008C2563 push -1
008C2565 push 0xac15bd
008C256A mov eax, dword ptr fs:[0]
008C2570 push eax
008C2571 sub esp, 0x114
008C2577 push esi
008C2578 push edi
008C2579 mov eax, dword ptr [0xc7b480]
008C257E xor eax, ebp
008C2580 push eax
008C2581 lea eax, [ebp - 0xc]
008C2584 mov dword ptr fs:[0], eax
008C258A mov dword ptr [ebp - 0x100], ecx
008C2590 mov esi, dword ptr [ebp + 8]
008C2593 mov edi, dword ptr [ebp - 0x100]
008C2599 add edi, 0x578
008C259F mov ecx, 0x1f
008C25A4 rep movsd dword ptr es:[edi], dword ptr [esi]
008C25A6 mov eax, dword ptr [ebp + 8]
008C25A9 movzx ecx, byte ptr [eax + 0x46]
008C25AD mov edx, dword ptr [ebp - 0x100]
008C25B3 mov dword ptr [edx + 0x67c], ecx
008C25B9 mov eax, dword ptr [0xb996b4]
008C25BE push eax
008C25BF lea ecx, [ebp - 0x38]
008C25C2 call 0x405650
008C25C7 mov dword ptr [ebp - 4], 0
008C25CE lea ecx, [ebp - 0x38]
008C25D1 push ecx
008C25D2 mov ecx, dword ptr [ebp - 0x100]
008C25D8 call 0x75fbf0
008C25DD mov dword ptr [ebp - 0x10], eax
008C25E0 mov dword ptr [ebp - 4], 0xffffffff
008C25E7 lea ecx, [ebp - 0x38]
008C25EA call 0x4056d0
008C25EF cmp dword ptr [ebp - 0x10], 0
008C25F3 je 0x8c272c
008C25F9 mov edx, dword ptr [ebp - 0x100]
008C25FF cmp dword ptr [edx + 0x67c], 0x64
008C2606 jne 0x8c2646
008C2608 push 0xbbae6c
008C260D lea ecx, [ebp - 0x54]
008C2610 call 0x405650
008C2615 mov dword ptr [ebp - 4], 1
008C261C push 1
008C261E lea eax, [ebp - 0x54]
008C2621 push eax
008C2622 mov ecx, dword ptr [ebp - 0x10]
008C2625 mov edx, dword ptr [ecx]
008C2627 mov ecx, dword ptr [ebp - 0x10]
008C262A mov eax, dword ptr [edx + 0xd4]
008C2630 call eax
008C2632 mov dword ptr [ebp - 4], 0xffffffff
008C2639 lea ecx, [ebp - 0x54]
008C263C call 0x4056d0
008C2641 jmp 0x8c272c
008C2646 mov ecx, dword ptr [ebp - 0x100]
; RANGE 008C2820-008C2AA0
008C2820 push ebp
008C2821 mov ebp, esp
008C2823 push -1
008C2825 push 0xac6e7b
008C282A mov eax, dword ptr fs:[0]
008C2830 push eax
008C2831 sub esp, 0x224
008C2837 mov eax, dword ptr [0xc7b480]
008C283C xor eax, ebp
008C283E mov dword ptr [ebp - 0x14], eax
008C2841 push esi
008C2842 push edi
008C2843 push eax
008C2844 lea eax, [ebp - 0xc]
008C2847 mov dword ptr fs:[0], eax
008C284D mov dword ptr [ebp - 0x224], ecx
008C2853 mov dword ptr [ebp - 0xc8], 0
008C285D mov eax, dword ptr [ebp - 0x224]
008C2863 mov ecx, dword ptr [ebp - 0x224]
008C2869 mov eax, dword ptr [eax + 0x61a]
008C286F imul eax, dword ptr [ecx + 0x67c]
008C2876 cdq
008C2877 mov ecx, 0x64
008C287C idiv ecx
008C287E mov dword ptr [ebp - 0xc8], eax
008C2884 mov ecx, dword ptr [0x17c86fc]
008C288A call 0x9ccf20
008C288F mov dword ptr [ebp - 0x10], eax
008C2892 mov edx, dword ptr [ebp - 0x10]
008C2895 cmp edx, dword ptr [ebp - 0xc8]
008C289B jge 0x8c2923
008C28A1 mov eax, dword ptr [ebp - 0xc8]
008C28A7 push eax
008C28A8 mov ecx, dword ptr [ebp - 0x10]
008C28AB push ecx
008C28AC push 0xbb8dac
008C28B1 push 0x80
008C28B6 lea edx, [ebp - 0x1fc]
008C28BC push edx
008C28BD call 0x663beb
008C28C2 add esp, 0x14
008C28C5 lea eax, [ebp - 0x1fc]
008C28CB push eax
008C28CC lea ecx, [ebp - 0x218]
008C28D2 call 0x405650
008C28D7 mov dword ptr [ebp - 4], 0
008C28DE call 0x41c540
008C28E3 mov dword ptr [ebp - 0x228], eax
008C28E9 push 0
008C28EB push 0
008C28ED push 0
008C28EF lea ecx, [ebp - 0x218]
008C28F5 push ecx
008C28F6 mov edx, dword ptr [ebp - 0x228]
008C28FC mov eax, dword ptr [edx]
008C28FE mov ecx, dword ptr [ebp - 0x228]
008C2904 mov edx, dword ptr [eax + 0x1c0]
008C290A call edx
008C290C mov dword ptr [ebp - 4], 0xffffffff
008C2913 lea ecx, [ebp - 0x218]
008C2919 call 0x4056d0
008C291E jmp 0x8c2a78
008C2923 push 0xad
008C2928 push 0
008C292A lea eax, [ebp - 0xc4]
008C2930 push eax
008C2931 call 0x666960
008C2936 add esp, 0xc
008C2939 mov ecx, dword ptr [ebp - 0x224]
008C293F mov edx, dword ptr [ecx + 0x580]
008C2945 mov dword ptr [ebp - 0xc4], edx
008C294B push 0xa9
008C2950 push 0
008C2952 lea eax, [ebp - 0x17c]
008C2958 push eax
008C2959 call 0x666960
008C295E add esp, 0xc
008C2961 mov ecx, dword ptr [0x17c86fc]
008C2967 call 0x402aa0
008C296C mov dword ptr [ebp - 0x178], eax
008C2972 mov dword ptr [ebp - 0x174], edx
008C2978 lea ecx, [ebp - 0x21c]
008C297E push ecx
008C297F mov ecx, dword ptr [0x17c86fc]
008C2985 call 0x416240
008C298A mov dword ptr [ebp - 0x22c], eax
008C2990 mov ecx, dword ptr [ebp - 0x22c]
008C2996 call 0x453f50
008C299B push eax
008C299C lea edx, [ebp - 0x170]
008C29A2 push edx
008C29A3 call 0x4b1970
008C29A8 add esp, 8
008C29AB lea ecx, [ebp - 0x21c]
008C29B1 call 0x406050
008C29B6 mov ecx, dword ptr [0x17c86fc]
008C29BC call 0x402aa0
008C29C1 mov dword ptr [ebp - 0x146], eax
008C29C7 mov dword ptr [ebp - 0x142], edx
008C29CD lea eax, [ebp - 0x220]
008C29D3 push eax
008C29D4 mov ecx, dword ptr [0x17c86fc]
008C29DA call 0x416240
008C29DF mov dword ptr [ebp - 0x230], eax
008C29E5 mov ecx, dword ptr [ebp - 0x230]
008C29EB call 0x453f50
008C29F0 push eax
008C29F1 lea ecx, [ebp - 0x13e]
008C29F7 push ecx
008C29F8 call 0x4b1970
008C29FD add esp, 8
008C2A00 lea ecx, [ebp - 0x220]
008C2A06 call 0x406050
008C2A0B mov edx, dword ptr [ebp - 0x224]
008C2A11 mov eax, dword ptr [edx + 0x5fd]
008C2A17 mov dword ptr [ebp - 0xeb], eax
008C2A1D mov ecx, dword ptr [ebp - 0xc8]
008C2A23 mov dword ptr [ebp - 0xdf], ecx
008C2A29 mov dword ptr [ebp - 0x17c], 0x69
008C2A33 mov ecx, 0x2a
008C2A38 lea esi, [ebp - 0x17c]
008C2A3E lea edi, [ebp - 0xc0]
008C2A44 rep movsd dword ptr es:[edi], dword ptr [esi]
008C2A46 movsb byte ptr es:[edi], byte ptr [esi]
008C2A47 push 0xad
008C2A4C lea edx, [ebp - 0xc4]
008C2A52 push edx
008C2A53 push 0
008C2A55 push 0x58c
008C2A5A call 0xa3c950
008C2A5F add esp, 0x10
008C2A62 mov eax, dword ptr [ebp - 0x224]
008C2A68 mov edx, dword ptr [eax]
008C2A6A mov ecx, dword ptr [ebp - 0x224]
008C2A70 mov eax, dword ptr [edx + 0x11c]
008C2A76 call eax
008C2A78 mov ecx, dword ptr [ebp - 0xc]
008C2A7B mov dword ptr fs:[0], ecx
008C2A82 pop ecx
008C2A83 pop edi
008C2A84 pop esi
008C2A85 mov ecx, dword ptr [ebp - 0x14]
008C2A88 xor ecx, ebp
008C2A8A call 0x6634fb
008C2A8F mov esp, ebp
008C2A91 pop ebp
008C2A92 ret
