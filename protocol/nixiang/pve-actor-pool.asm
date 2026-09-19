; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Native stage-assault actor pool and shared event sequence.
; range 0x93aec0
0093AEC0 push ebp
0093AEC1 mov ebp, esp
0093AEC3 push -1
0093AEC5 push 0xac2b24
0093AECA mov eax, dword ptr fs:[0]
0093AED0 push eax
0093AED1 sub esp, 0x54
0093AED4 push esi
0093AED5 mov eax, dword ptr [0xc7b480]
0093AEDA xor eax, ebp
0093AEDC push eax
0093AEDD lea eax, [ebp - 0xc]
0093AEE0 mov dword ptr fs:[0], eax
0093AEE6 mov dword ptr [ebp - 0x58], ecx
0093AEE9 lea eax, [ebp - 0x28]
0093AEEC push eax
0093AEED mov ecx, dword ptr [0x17c8708]
0093AEF3 call 0x4b1070
0093AEF8 mov ecx, dword ptr [eax + 4]
0093AEFB push ecx
0093AEFC call 0xa514e0
0093AF01 mov ecx, eax
0093AF03 call 0xa50f10
0093AF08 mov dword ptr [ebp - 0x10], eax
0093AF0B cmp dword ptr [ebp - 0x10], 0
0093AF0F je 0x93af29
0093AF11 push 0xa6041
0093AF16 mov ecx, dword ptr [ebp - 0x10]
0093AF19 call 0xa50ea0
0093AF1E mov edx, dword ptr [ebp - 0x58]
0093AF21 mov dword ptr [edx + 0xfc], eax
0093AF27 jmp 0x93af36
0093AF29 mov eax, dword ptr [ebp - 0x58]
0093AF2C mov dword ptr [eax + 0xfc], 0x270f
0093AF36 mov ecx, dword ptr [ebp - 0x58]
0093AF39 mov dword ptr [ecx + 0x100], 0
0093AF43 mov edx, dword ptr [ebp - 0x58]
0093AF46 mov dword ptr [edx + 0x104], 0
0093AF50 push 0x2c
0093AF52 call 0x667fbb
0093AF57 add esp, 4
0093AF5A mov dword ptr [ebp - 0x30], eax
0093AF5D mov dword ptr [ebp - 4], 0
0093AF64 cmp dword ptr [ebp - 0x30], 0
0093AF68 je 0x93af77
0093AF6A mov ecx, dword ptr [ebp - 0x30]
0093AF6D call 0xa57b30
0093AF72 mov dword ptr [ebp - 0x5c], eax
0093AF75 jmp 0x93af7e
0093AF77 mov dword ptr [ebp - 0x5c], 0
0093AF7E mov eax, dword ptr [ebp - 0x5c]
0093AF81 mov dword ptr [ebp - 0x2c], eax
0093AF84 mov dword ptr [ebp - 4], 0xffffffff
0093AF8B mov ecx, dword ptr [ebp - 0x58]
0093AF8E mov edx, dword ptr [ebp - 0x2c]
0093AF91 mov dword ptr [ecx + 0xd8], edx
0093AF97 mov eax, dword ptr [ebp - 0x58]
0093AF9A mov ecx, dword ptr [eax + 0xd8]
0093AFA0 call 0xa579d0
0093AFA5 movzx ecx, al
0093AFA8 test ecx, ecx
0093AFAA jne 0x93affe
0093AFAC mov edx, dword ptr [ebp - 0x58]
0093AFAF cmp dword ptr [edx + 0xd8], 0
0093AFB6 je 0x93aff7
0093AFB8 mov eax, dword ptr [ebp - 0x58]
0093AFBB mov ecx, dword ptr [eax + 0xd8]
0093AFC1 mov dword ptr [ebp - 0x38], ecx
0093AFC4 mov edx, dword ptr [ebp - 0x38]
0093AFC7 mov dword ptr [ebp - 0x34], edx
0093AFCA cmp dword ptr [ebp - 0x34], 0
0093AFCE je 0x93afe3
0093AFD0 push 1
0093AFD2 mov eax, dword ptr [ebp - 0x34]
0093AFD5 mov edx, dword ptr [eax]
0093AFD7 mov ecx, dword ptr [ebp - 0x34]
0093AFDA mov eax, dword ptr [edx]
0093AFDC call eax
0093AFDE mov dword ptr [ebp - 0x60], eax
0093AFE1 jmp 0x93afea
0093AFE3 mov dword ptr [ebp - 0x60], 0
0093AFEA mov ecx, dword ptr [ebp - 0x58]
0093AFED mov dword ptr [ecx + 0xd8], 0
0093AFF7 xor al, al
0093AFF9 jmp 0x93b126
0093AFFE mov edx, dword ptr [ebp - 0x58]
0093B001 mov byte ptr [edx + 0x1c], 0
0093B005 push 0
0093B007 mov ecx, dword ptr [0x17c8710]
0093B00D call 0x4b0fc0
0093B012 mov ecx, dword ptr [0x17c8708]
0093B018 call 0x819120
0093B01D test eax, eax
0093B01F je 0x93b111
0093B025 mov ecx, dword ptr [0x17c8708]
0093B02B call 0x819120
0093B030 mov ecx, eax
0093B032 call 0x44b3f0
0093B037 test eax, eax
0093B039 je 0x93b111
0093B03F mov dword ptr [ebp - 0x18], 0
0093B046 mov dword ptr [ebp - 0x14], 0
0093B04D mov dword ptr [ebp - 0x14], 0
0093B054 jmp 0x93b05f
0093B056 mov eax, dword ptr [ebp - 0x14]
0093B059 add eax, 1
0093B05C mov dword ptr [ebp - 0x14], eax
0093B05F cmp dword ptr [ebp - 0x14], 8
0093B063 jae 0x93b0c8
0093B065 mov ecx, dword ptr [ebp - 0x14]
0093B068 push ecx
0093B069 mov ecx, dword ptr [0x17c8708]
0093B06F call 0x818450
0093B074 mov dword ptr [ebp - 0x20], eax
0093B077 cmp dword ptr [ebp - 0x20], 0
0093B07B je 0x93b0c6
0093B07D mov edx, dword ptr [ebp - 0x18]
0093B080 add edx, 1
0093B083 mov dword ptr [ebp - 0x18], edx
0093B086 mov ecx, dword ptr [ebp - 0x20]
0093B089 call 0x401000
0093B08E push eax
0093B08F push 0
0093B091 push 0
0093B093 mov eax, dword ptr [ebp - 0x14]
0093B096 push eax
0093B097 lea ecx, [ebp - 0x48]
0093B09A call 0x4d6ee0
0093B09F mov esi, eax
0093B0A1 lea ecx, [ebp - 0x18]
0093B0A4 push ecx
0093B0A5 mov ecx, dword ptr [ebp - 0x58]
0093B0A8 add ecx, 0x20
0093B0AB call 0x4d7060
0093B0B0 mov edx, dword ptr [esi]
0093B0B2 mov dword ptr [eax], edx
0093B0B4 mov ecx, dword ptr [esi + 4]
0093B0B7 mov dword ptr [eax + 4], ecx
0093B0BA mov edx, dword ptr [esi + 8]
0093B0BD mov dword ptr [eax + 8], edx
0093B0C0 mov ecx, dword ptr [esi + 0xc]
0093B0C3 mov dword ptr [eax + 0xc], ecx
0093B0C6 jmp 0x93b056
0093B0C8 mov ecx, dword ptr [ebp - 0x58]
0093B0CB add ecx, 0x60
0093B0CE call 0x4d4900
0093B0D3 call 0x669a7e
0093B0D8 mov dword ptr [ebp - 0x1c], eax
0093B0DB mov dword ptr [ebp - 0x14], 0
0093B0E2 jmp 0x93b0ed
0093B0E4 mov edx, dword ptr [ebp - 0x14]
0093B0E7 add edx, 1
0093B0EA mov dword ptr [ebp - 0x14], edx
0093B0ED cmp dword ptr [ebp - 0x14], 0x64
0093B0F1 jge 0x93b111
0093B0F3 mov eax, dword ptr [ebp - 0x1c]
0093B0F6 add eax, dword ptr [ebp - 0x14]
0093B0F9 cdq
0093B0FA mov dword ptr [ebp - 0x54], eax
0093B0FD mov dword ptr [ebp - 0x50], edx
0093B100 lea eax, [ebp - 0x54]
0093B103 push eax
0093B104 mov ecx, dword ptr [ebp - 0x58]
0093B107 add ecx, 0x60
0093B10A call 0x4d4690
0093B10F jmp 0x93b0e4
0093B111 mov ecx, dword ptr [ebp - 0x58]
0093B114 call 0x93abf0
0093B119 movzx ecx, al
0093B11C test ecx, ecx
0093B11E jne 0x93b124
0093B120 xor al, al
0093B122 jmp 0x93b126
0093B124 mov al, 1
0093B126 mov ecx, dword ptr [ebp - 0xc]
0093B129 mov dword ptr fs:[0], ecx
0093B130 pop ecx
0093B131 pop esi
0093B132 mov esp, ebp
0093B134 pop ebp
0093B135 ret
; range 0x669a7e
00669A7E call 0x672766
00669A83 mov ecx, dword ptr [eax + 0x14]
00669A86 imul ecx, ecx, 0x343fd
00669A8C add ecx, 0x269ec3
00669A92 mov dword ptr [eax + 0x14], ecx
00669A95 mov eax, ecx
00669A97 shr eax, 0x10
00669A9A and eax, 0x7fff
00669A9F ret
; range 0x7d1730
007D1730 push ebp
007D1731 mov ebp, esp
007D1733 sub esp, 8
007D1736 mov dword ptr [ebp - 8], ecx
007D1739 mov eax, dword ptr [ebp + 8]
007D173C mov dword ptr [ebp - 4], eax
007D173F call 0x7d1040
007D1744 mov ecx, eax
007D1746 call 0x7d0e20
007D174B mov ecx, dword ptr [ebp - 4]
007D174E mov dword ptr [ecx + 0x13], eax
007D1751 cmp dword ptr [ebp + 0x10], 0
007D1755 je 0x7d1786
007D1757 mov edx, dword ptr [ebp + 0xc]
007D175A push edx
007D175B mov eax, dword ptr [ebp + 8]
007D175E push eax
007D175F push 0
007D1761 push 0x1f87
007D1766 call 0x7d03e0
007D176B mov ecx, eax
007D176D call 0x7d0410
007D1772 mov ecx, dword ptr [ebp + 0xc]
007D1775 push ecx
007D1776 mov edx, dword ptr [ebp + 8]
007D1779 push edx
007D177A mov ecx, 0x17c8e90
007D177F call 0xa78e00
007D1784 jmp 0x7d17b3
007D1786 mov eax, dword ptr [ebp + 0xc]
007D1789 push eax
007D178A mov ecx, dword ptr [ebp + 8]
007D178D push ecx
007D178E push 0
007D1790 push 0x1f87
007D1795 call 0x7d03e0
007D179A mov ecx, eax
007D179C call 0x7d03b0
007D17A1 mov edx, dword ptr [ebp + 0xc]
007D17A4 push edx
007D17A5 mov eax, dword ptr [ebp + 8]
007D17A8 push eax
007D17A9 mov ecx, 0x17c8e90
007D17AE call 0xa78ef0
007D17B3 mov esp, ebp
007D17B5 pop ebp
007D17B6 ret 0xc
; range 0x7d0e20
007D0E20 push ebp
007D0E21 mov ebp, esp
007D0E23 sub esp, 8
007D0E26 mov dword ptr [ebp - 4], ecx
007D0E29 mov eax, dword ptr [ebp - 4]
007D0E2C mov ecx, dword ptr [eax]
007D0E2E mov dword ptr [ebp - 8], ecx
007D0E31 mov edx, dword ptr [ebp - 4]
007D0E34 mov eax, dword ptr [edx]
007D0E36 add eax, 1
007D0E39 mov ecx, dword ptr [ebp - 4]
007D0E3C mov dword ptr [ecx], eax
007D0E3E mov eax, dword ptr [ebp - 8]
007D0E41 mov esp, ebp
007D0E43 pop ebp
007D0E44 ret
