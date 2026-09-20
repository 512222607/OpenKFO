; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Mode 10 follows the fallback common result collector/display, not mode21.
; B9709C -> BCC068 = Result.sui; B970D8 -> BCBF74 = frmBattleResult.
; Constructor 8112B0 installs BCC10C; virtual +108 = 811ED0.
; Mode10-specific display branch at 81203B compares room mode with 0xA.
; range 0x82ca62..0x82caca
0082CA62 mov ecx, dword ptr [0x17c8708]
0082CA68 call 0x4535c0
0082CA6D mov dword ptr [ebp - 0x30], eax
0082CA70 cmp dword ptr [ebp - 0x30], 0xf
0082CA74 je 0x82ca84
0082CA76 cmp dword ptr [ebp - 0x30], 0x10
0082CA7A je 0x82ca96
0082CA7C cmp dword ptr [ebp - 0x30], 0x15
0082CA80 je 0x82caa8
0082CA82 jmp 0x82caba
0082CA84 mov ecx, dword ptr [ebp - 4]
0082CA87 push ecx
0082CA88 call 0x548a20
0082CA8D mov ecx, eax
0082CA8F call 0x80d730
0082CA94 jmp 0x82caca
0082CA96 mov edx, dword ptr [ebp - 4]
0082CA99 push edx
0082CA9A call 0x548c80
0082CA9F mov ecx, eax
0082CAA1 call 0x814860
0082CAA6 jmp 0x82caca
0082CAA8 mov eax, dword ptr [ebp - 4]
0082CAAB push eax
0082CAAC call 0x548d10
0082CAB1 mov ecx, eax
0082CAB3 call 0x935f30
0082CAB8 jmp 0x82caca
0082CABA mov ecx, dword ptr [ebp - 4]
0082CABD push ecx
0082CABE call 0x811460
0082CAC3 mov ecx, eax
0082CAC5 call 0x80f560
; range 0x82ccd8..0x82cda5
0082CCD8 mov ecx, dword ptr [0x17c8708]
0082CCDE call 0x4535c0
0082CCE3 mov dword ptr [ebp - 0x38], eax
0082CCE6 cmp dword ptr [ebp - 0x38], 0xf
0082CCEA je 0x82cd4b
0082CCEC cmp dword ptr [ebp - 0x38], 0x10
0082CCF0 je 0x82ccfa
0082CCF2 cmp dword ptr [ebp - 0x38], 0x15
0082CCF6 je 0x82cd23
0082CCF8 jmp 0x82cd73
0082CCFA call 0x548c80
0082CCFF mov ecx, eax
0082CD01 call 0x8153f0
0082CD06 call 0x548c80
0082CD0B mov dword ptr [ebp - 0x3c], eax
0082CD0E mov ecx, dword ptr [ebp - 0x3c]
0082CD11 mov edx, dword ptr [ecx]
0082CD13 mov ecx, dword ptr [ebp - 0x3c]
0082CD16 mov eax, dword ptr [edx + 0x108]
0082CD1C call eax
0082CD1E jmp 0x82cda5
0082CD23 push 1
0082CD25 call 0x548d10
0082CD2A mov ecx, eax
0082CD2C call 0x935ef0
0082CD31 call 0x548d10
0082CD36 mov dword ptr [ebp - 0x40], eax
0082CD39 mov ecx, dword ptr [ebp - 0x40]
0082CD3C mov edx, dword ptr [ecx]
0082CD3E mov ecx, dword ptr [ebp - 0x40]
0082CD41 mov eax, dword ptr [edx + 0x108]
0082CD47 call eax
0082CD49 jmp 0x82cda5
0082CD4B push 1
0082CD4D call 0x548a20
0082CD52 mov ecx, eax
0082CD54 call 0x80d700
0082CD59 call 0x548a20
0082CD5E mov dword ptr [ebp - 0x44], eax
0082CD61 mov ecx, dword ptr [ebp - 0x44]
0082CD64 mov edx, dword ptr [ecx]
0082CD66 mov ecx, dword ptr [ebp - 0x44]
0082CD69 mov eax, dword ptr [edx + 0x108]
0082CD6F call eax
0082CD71 jmp 0x82cda5
0082CD73 push 1
0082CD75 call 0x811460
0082CD7A mov ecx, eax
0082CD7C call 0x80f4e0
0082CD81 call 0x811460
0082CD86 mov dword ptr [ebp - 0x48], eax
0082CD89 mov ecx, dword ptr [ebp - 0x48]
0082CD8C mov edx, dword ptr [ecx]
0082CD8E mov ecx, dword ptr [ebp - 0x48]
0082CD91 mov eax, dword ptr [edx + 0x108]
0082CD97 call eax
0082CD99 call 0x811460
0082CD9E mov ecx, eax
0082CDA0 call 0x813b20
; range 0x80f577..0x80f59d
0080F577 mov esi, dword ptr [ebp + 8]
0080F57A sub esp, 0x8c
0080F580 mov ecx, 0x23
0080F585 mov edi, esp
0080F587 rep movsd dword ptr es:[edi], dword ptr [esi]
0080F589 mov eax, dword ptr [ebp + 8]
0080F58C movzx ecx, byte ptr [eax + 0xa]
0080F590 push ecx
0080F591 lea edx, [ebp - 0x11d]
0080F597 push edx
0080F598 call 0x5535a0
; range 0x8112d8..0x81130d
008112D8 mov eax, dword ptr [0xb9709c]
008112DD push eax
008112DE lea ecx, [ebp - 0x28]
008112E1 call 0x405650
008112E6 mov dword ptr [ebp - 4], 0
008112ED mov ecx, dword ptr [0xb970d8]
008112F3 push ecx
008112F4 lea ecx, [ebp - 0x44]
008112F7 call 0x405650
008112FC mov byte ptr [ebp - 4], 1
00811300 push 0
00811302 lea edx, [ebp - 0x28]
00811305 push edx
00811306 lea eax, [ebp - 0x44]
00811309 push eax
0081130A mov ecx, dword ptr [ebp - 0x48]
; range 0x81132a..0x811333
0081132A mov ecx, dword ptr [ebp - 0x48]
0081132D mov dword ptr [ecx], 0xbcc10c
; range 0x812030..0x81207f
00812030 mov ecx, dword ptr [0x17c8708]
00812036 call 0x4535c0
0081203B cmp eax, 0xa
0081203E jne 0x81207f
00812040 mov ecx, dword ptr [0xb9716c]
00812046 push ecx
00812047 lea ecx, [ebp - 0xa0]
0081204D call 0x405650
00812052 mov dword ptr [ebp - 4], 4
00812059 push 1
0081205B lea edx, [ebp - 0xa0]
00812061 push edx
00812062 mov ecx, dword ptr [ebp - 0x134]
00812068 call 0x7611c0
0081206D mov dword ptr [ebp - 4], 0xffffffff
00812074 lea ecx, [ebp - 0xa0]
0081207A call 0x4056d0
