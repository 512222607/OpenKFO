; Native team-room positioning: mode 1/3 constructor 816990, vtable BCBA00.
; UI index vtable+0C = 816F60 -> Spawn; coordinate index vtable+04 = 816940 -> Spawn+8.
; Read-only live room table: entries 8..11 yaw -145; entries 12..15 yaw +145.

; FUNCTION 00816940
00816940 push     ebp
00816941 mov      ebp, esp
00816943 push     ecx
00816944 mov      dword ptr [ebp - 4], ecx
00816947 cmp      dword ptr [ebp + 8], 0
0081694B jne      0x816951
0081694D xor      eax, eax
0081694F jmp      0x816960
00816951 mov      ecx, dword ptr [ebp + 8]
00816954 call     0x45c4c0
00816959 add      eax, 8
0081695C jmp      0x816960
0081695E xor      eax, eax
00816960 mov      esp, ebp
00816962 pop      ebp
00816963 ret      4

; FUNCTION 00816F60
00816F60 push     ebp
00816F61 mov      ebp, esp
00816F63 push     ecx
00816F64 mov      dword ptr [ebp - 4], ecx
00816F67 cmp      dword ptr [ebp + 8], 0
00816F6B jne      0x816f71
00816F6D xor      eax, eax
00816F6F jmp      0x816f79
00816F71 mov      ecx, dword ptr [ebp + 8]
00816F74 call     0x45c4c0
00816F79 mov      esp, ebp
00816F7B pop      ebp
00816F7C ret      4

; FUNCTION 00820160
00820160 push     ebp
00820161 mov      ebp, esp
00820163 sub      esp, 0x28
00820166 mov      dword ptr [ebp - 0x14], ecx
00820169 cmp      dword ptr [ebp + 8], 0
0082016D je       0x820175
0082016F cmp      dword ptr [ebp + 0xc], 0xa
00820173 je       0x82017a
00820175 jmp      0x8202b3
0082017A mov      eax, dword ptr [ebp + 8]
0082017D mov      dword ptr [ebp - 4], eax
00820180 mov      ecx, dword ptr [ebp - 4]
00820183 mov      edx, dword ptr [ecx + 4]
00820186 push     edx
00820187 mov      eax, dword ptr [ecx]
00820189 push     eax
0082018A mov      ecx, dword ptr [0x17c8708]
00820190 call     0x818c70
00820195 mov      dword ptr [ebp - 8], eax
00820198 cmp      dword ptr [ebp - 8], 0
0082019C je       0x8202b3
008201A2 mov      ecx, dword ptr [0x17c8708]
008201A8 call     0x81b800
008201AD mov      dword ptr [ebp - 0x18], eax
008201B0 mov      ecx, dword ptr [ebp - 8]
008201B3 push     ecx
008201B4 mov      ecx, dword ptr [0x17c8708]
008201BA call     0x817bc0
008201BF push     eax
008201C0 push     0
008201C2 mov      edx, dword ptr [ebp - 0x18]
008201C5 mov      eax, dword ptr [edx]
008201C7 mov      ecx, dword ptr [ebp - 0x18]
008201CA mov      edx, dword ptr [eax + 0x1c0]
008201D0 call     edx
008201D2 mov      ecx, dword ptr [ebp - 8]
008201D5 call     0x45c4c0
008201DA mov      dword ptr [ebp - 0xc], eax
008201DD mov      eax, dword ptr [ebp - 4]
008201E0 movzx    ecx, byte ptr [eax + 9]
008201E4 push     ecx
008201E5 mov      ecx, dword ptr [ebp - 8]
008201E8 call     0x453950
008201ED mov      ecx, dword ptr [ebp - 8]
008201F0 call     0x45c4c0
008201F5 mov      dword ptr [ebp - 0x10], eax
008201F8 mov      edx, dword ptr [ebp - 4]
008201FB movzx    eax, byte ptr [edx + 8]
008201FF push     eax
00820200 mov      ecx, dword ptr [ebp - 8]
00820203 call     0x9e43f0
00820208 push     1
0082020A mov      ecx, dword ptr [ebp - 8]
0082020D push     ecx
0082020E mov      ecx, dword ptr [0x17c8708]
00820214 call     0x819fc0
00820219 mov      ecx, dword ptr [0x17c8708]
0082021F call     0x81b800
00820224 mov      dword ptr [ebp - 0x1c], eax
00820227 mov      edx, dword ptr [ebp - 8]
0082022A push     edx
0082022B mov      ecx, dword ptr [0x17c8708]
00820231 call     0x817bc0
00820236 push     eax
00820237 mov      eax, dword ptr [ebp - 8]
0082023A push     eax
0082023B mov      ecx, dword ptr [ebp - 0x1c]
0082023E mov      edx, dword ptr [ecx]
00820240 mov      ecx, dword ptr [ebp - 0x1c]
00820243 mov      eax, dword ptr [edx + 0x1c0]
00820249 call     eax
0082024B mov      ecx, dword ptr [0x17c8708]
00820251 call     0x81b800
00820256 mov      dword ptr [ebp - 0x20], eax
00820259 mov      ecx, dword ptr [ebp - 4]
0082025C movzx    edx, byte ptr [ecx + 8]
00820260 push     edx
00820261 mov      eax, dword ptr [ebp - 8]
00820264 push     eax
00820265 mov      ecx, dword ptr [ebp - 0x20]
00820268 mov      edx, dword ptr [ecx]
0082026A mov      ecx, dword ptr [ebp - 0x20]
0082026D mov      eax, dword ptr [edx + 0x1e0]
00820273 call     eax
00820275 mov      ecx, dword ptr [0x17c8708]
0082027B call     0x81b800
00820280 mov      dword ptr [ebp - 0x24], eax
00820283 push     0
00820285 mov      ecx, dword ptr [ebp - 0x24]
00820288 mov      edx, dword ptr [ecx]
0082028A mov      ecx, dword ptr [ebp - 0x24]
0082028D mov      eax, dword ptr [edx + 0x1cc]
00820293 call     eax
00820295 mov      ecx, dword ptr [0x17c8708]
0082029B call     0x81b800
008202A0 mov      dword ptr [ebp - 0x28], eax
008202A3 mov      ecx, dword ptr [ebp - 0x28]
008202A6 mov      edx, dword ptr [ecx]
008202A8 mov      ecx, dword ptr [ebp - 0x28]
008202AB mov      eax, dword ptr [edx + 0x1e4]
008202B1 call     eax
008202B3 mov      esp, ebp
008202B5 pop      ebp
008202B6 ret      8
