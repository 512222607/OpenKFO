; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; MapInfo / MapConfig loader: MapId, MapType, NeedTitleLevel; 21374 notification match.
; 00BA4528 /MapInfo
; 00BA4534 \data\config\mapmgr.xml
; 00BA454C MapId
; 00BA4270 MapType
; 00BA45A4 NeedTitleLevel
; 00BCD994 关卡已开启！

; RANGE 00A554E0-00A55540
00A554E0 inc ebp
00A554E1 cld
00A554E2 add ecx, dword ptr [ebp - 0xfb73]

; RANGE 00A557AA-00A55860
00A557AA or byte ptr [ebx - 0x3ba3901], bl
00A557B0 add eax, 0xfed08d8d

; RANGE 00A55FB0-00A56088
00A55FB0 push ebp
00A55FB1 mov ebp, esp
00A55FB3 push -1
00A55FB5 push 0xabd4f1
00A55FBA mov eax, dword ptr fs:[0]
00A55FC0 push eax
00A55FC1 sub esp, 0x20
00A55FC4 mov eax, dword ptr [0xc7b480]
00A55FC9 xor eax, ebp
00A55FCB push eax
00A55FCC lea eax, [ebp - 0xc]
00A55FCF mov dword ptr fs:[0], eax
00A55FD5 cmp dword ptr [0x17c8964], 0
00A55FDC jne 0xa56074
00A55FE2 push 0x5c
00A55FE4 call 0x667fbb
00A55FE9 add esp, 4
00A55FEC mov dword ptr [ebp - 0x14], eax
00A55FEF mov dword ptr [ebp - 4], 0
00A55FF6 cmp dword ptr [ebp - 0x14], 0
00A55FFA je 0xa56009
00A55FFC mov ecx, dword ptr [ebp - 0x14]
00A55FFF call 0xa55f30
00A56004 mov dword ptr [ebp - 0x20], eax
00A56007 jmp 0xa56010
00A56009 mov dword ptr [ebp - 0x20], 0
00A56010 mov eax, dword ptr [ebp - 0x20]
00A56013 mov dword ptr [ebp - 0x10], eax
00A56016 mov dword ptr [ebp - 4], 0xffffffff
00A5601D mov ecx, dword ptr [ebp - 0x10]
00A56020 mov dword ptr [0x17c8964], ecx
00A56026 push ecx
00A56027 mov ecx, esp
00A56029 mov dword ptr [ebp - 0x18], esp
00A5602C push 0xba4528
00A56031 call 0x405fd0
00A56036 mov dword ptr [ebp - 0x24], eax
00A56039 mov edx, dword ptr [ebp - 0x24]
00A5603C mov dword ptr [ebp - 0x28], edx
00A5603F mov dword ptr [ebp - 4], 1
00A56046 push ecx
00A56047 mov eax, esp
00A56049 mov dword ptr [ebp - 0x1c], esp
00A5604C push 0xba4534
00A56051 push 0x17c8e58
00A56056 push eax
00A56057 call 0x406200
00A5605C add esp, 0xc
00A5605F mov dword ptr [ebp - 0x2c], eax
00A56062 mov dword ptr [ebp - 4], 0xffffffff
00A56069 mov ecx, dword ptr [0x17c8964]
00A5606F call 0xa553d0
00A56074 mov eax, dword ptr [0x17c8964]
00A56079 mov ecx, dword ptr [ebp - 0xc]
00A5607C mov dword ptr fs:[0], ecx
00A56083 pop ecx
00A56084 mov esp, ebp
00A56086 pop ebp
00A56087 ret

; RANGE 00806E9A-00806F08
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
