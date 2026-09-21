; gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; current PE virtual addresses; read only
00660CE0 push ebp
00660CE1 mov ebp, esp
00660CE3 push ecx
00660CE4 mov eax, dword ptr [ebp + 8]
00660CE7 mov dword ptr [ebp - 4], eax
00660CEA mov ecx, dword ptr [ebp - 4]
00660CED sub ecx, 0xc
00660CF0 mov dword ptr [ebp - 4], ecx
00660CF3 cmp dword ptr [ebp - 4], 0x40
00660CF7 ja 0x660d65
00660CF9 mov edx, dword ptr [ebp - 4]
00660CFC movzx eax, byte ptr [edx + 0x660da4]
00660D03 jmp dword ptr [eax*4 + 0x660d6c]
00660D0A mov eax, 4
00660D0F jmp 0x660d67
00660D11 mov eax, 3
00660D16 jmp 0x660d67
00660D18 mov eax, 7
00660D1D jmp 0x660d67
00660D1F mov eax, 2
00660D24 jmp 0x660d67
00660D26 mov eax, 6
00660D2B jmp 0x660d67
00660D2D mov eax, 5
00660D32 jmp 0x660d67
00660D34 mov eax, 8
00660D39 jmp 0x660d67
00660D3B mov eax, 0x20
00660D40 jmp 0x660d67
00660D42 mov eax, 0x23
00660D47 jmp 0x660d67
00660D49 mov eax, 0x24
00660D4E jmp 0x660d67
00660D50 mov eax, 0xa
00660D55 jmp 0x660d67
00660D57 mov eax, 0xb
00660D5C jmp 0x660d67
00660D5E mov eax, 0x2a
00660D63 jmp 0x660d67
00660D65 xor eax, eax
00660D67 mov esp, ebp
00660D69 pop ebp
00660D6A ret
00660D6B nop
; kind=12 slot=4 target=00660D0A
; kind=13 slot=3 target=00660D11
; kind=14 slot=7 target=00660D18
; kind=15 slot=2 target=00660D1F
; kind=16 slot=6 target=00660D26
; kind=17 slot=5 target=00660D2D
; kind=20 slot=10 target=00660D50
; kind=21 slot=11 target=00660D57
; kind=25 slot=8 target=00660D34
; kind=31 slot=42 target=00660D5E
; kind=71 slot=32 target=00660D3B
; kind=75 slot=35 target=00660D42
; kind=76 slot=36 target=00660D49
