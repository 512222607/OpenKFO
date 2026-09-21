
; FUNCTION 00A05BB0
00A05BB0 push ebp
00A05BB1 mov ebp, esp
00A05BB3 sub esp, 0x88
00A05BB9 mov dword ptr [ebp - 0x88], ecx
00A05BBF mov eax, dword ptr [ebp + 8]
00A05BC2 push eax
00A05BC3 mov ecx, dword ptr [ebp + 0xc]
00A05BC6 push ecx
00A05BC7 call 0x43fec0
00A05BCC mov ecx, eax
00A05BCE call 0xa0c540
00A05BD3 mov dword ptr [ebp - 4], eax
00A05BD6 cmp dword ptr [ebp - 4], 0
00A05BDA je 0xa05d04
00A05BE0 mov edx, dword ptr [ebp + 8]
00A05BE3 push edx
00A05BE4 mov ecx, dword ptr [ebp - 0x88]
00A05BEA call 0xa01e60
00A05BEF mov eax, dword ptr [ebp - 4]
00A05BF2 push eax
00A05BF3 mov ecx, dword ptr [ebp - 0x88]
00A05BF9 mov edx, dword ptr [ecx]
00A05BFB mov ecx, dword ptr [ebp - 0x88]
00A05C01 mov eax, dword ptr [edx + 4]
00A05C04 call eax
00A05C06 mov ecx, dword ptr [ebp + 0x10]
00A05C09 push ecx
00A05C0A mov ecx, dword ptr [ebp + 8]
00A05C0D call 0x9e4090
00A05C12 mov edx, dword ptr [ebp - 0x88]
00A05C18 mov dword ptr [edx + 0x50], 0
00A05C1F mov eax, dword ptr [ebp - 0x88]
00A05C25 mov dword ptr [eax + 0x54], 0
00A05C2C mov ecx, dword ptr [ebp + 8]
00A05C2F call 0x9e9a30
00A05C34 test eax, eax
00A05C36 je 0xa05ca6
00A05C38 mov ecx, dword ptr [0x17c8708]
00A05C3E call 0x819120
00A05C43 mov ecx, eax
00A05C45 call 0x44b3f0
00A05C4A test eax, eax
00A05C4C je 0xa05ca6
00A05C4E mov ecx, dword ptr [ebp + 8]
00A05C51 call 0x401000
00A05C56 mov dword ptr [ebp - 0x1d], eax
00A05C59 mov dword ptr [ebp - 0x19], edx
00A05C5C mov ecx, dword ptr [ebp + 0x10]
00A05C5F mov dword ptr [ebp - 0x15], ecx
00A05C62 mov dword ptr [ebp - 0x11], 1
00A05C69 mov ecx, dword ptr [0x17c8708]
00A05C6F call 0x432440
00A05C74 mov edx, dword ptr [eax]
00A05C76 mov eax, dword ptr [eax + 4]
00A05C79 mov dword ptr [ebp - 0xd], edx
00A05C7C mov dword ptr [ebp - 9], eax
00A05C7F mov ecx, dword ptr [ebp - 0x88]
00A05C85 mov edx, dword ptr [ebp + 0x10]
00A05C88 mov dword ptr [ecx + 0x58], edx
00A05C8B lea eax, [ebp - 0x44]
00A05C8E push eax
00A05C8F call 0x44a830
00A05C94 mov ecx, eax
00A05C96 call 0xa444e0
00A05C9B mov ecx, dword ptr [ebp - 0x88]
00A05CA1 mov dword ptr [ecx + 0x54], eax
00A05CA4 jmp 0xa05cfd
00A05CA6 mov ecx, dword ptr [ebp + 8]
00A05CA9 call 0x9e7c70
00A05CAE test eax, eax
00A05CB0 je 0xa05cfd
00A05CB2 mov ecx, dword ptr [ebp + 8]
00A05CB5 call 0x401000
00A05CBA mov dword ptr [ebp - 0x5d], eax
00A05CBD mov dword ptr [ebp - 0x59], edx
00A05CC0 mov edx, dword ptr [ebp + 0x10]
00A05CC3 mov dword ptr [ebp - 0x55], edx
00A05CC6 mov dword ptr [ebp - 0x51], 1
00A05CCD mov ecx, dword ptr [0x17c8708]
00A05CD3 call 0x432440
00A05CD8 mov ecx, dword ptr [eax]
00A05CDA mov edx, dword ptr [eax + 4]
00A05CDD mov dword ptr [ebp - 0x4d], ecx
00A05CE0 mov dword ptr [ebp - 0x49], edx
00A05CE3 push 0
00A05CE5 push 0
00A05CE7 push 0x3f
00A05CE9 lea eax, [ebp - 0x84]
00A05CEF push eax
00A05CF0 push 0x2328
00A05CF5 call 0xa3fbb0
00A05CFA add esp, 0x14
00A05CFD mov eax, 1
00A05D02 jmp 0xa05d06
00A05D04 xor eax, eax
00A05D06 mov esp, ebp
00A05D08 pop ebp
00A05D09 ret 0xc

; FUNCTION 00A06270
00A06270 push ebp
00A06271 mov ebp, esp
00A06273 sub esp, 0x44
00A06276 mov dword ptr [ebp - 0x44], ecx
00A06279 mov eax, dword ptr [ebp - 0x44]
00A0627C cmp dword ptr [eax + 0x54], 0
00A06280 je 0xa06358
00A06286 mov ecx, dword ptr [ebp - 0x44]
00A06289 cmp dword ptr [ecx + 4], 0
00A0628D je 0xa06358
00A06293 mov edx, dword ptr [ebp - 0x44]
00A06296 mov ecx, dword ptr [edx + 4]
00A06299 call 0x9e7c70
00A0629E test eax, eax
00A062A0 je 0xa06313
00A062A2 mov eax, dword ptr [ebp - 0x44]
00A062A5 mov ecx, dword ptr [eax + 4]
00A062A8 call 0x44b300
00A062AD test eax, eax
00A062AF je 0xa06313
00A062B1 mov ecx, dword ptr [ebp - 0x44]
00A062B4 mov ecx, dword ptr [ecx + 4]
00A062B7 call 0x44b3f0
00A062BC test eax, eax
00A062BE jne 0xa06313
00A062C0 mov edx, dword ptr [ebp - 0x44]
00A062C3 mov ecx, dword ptr [edx + 4]
00A062C6 call 0x401000
00A062CB mov dword ptr [ebp - 0x19], eax
00A062CE mov dword ptr [ebp - 0x15], edx
00A062D1 mov eax, dword ptr [ebp - 0x44]
00A062D4 mov ecx, dword ptr [eax + 4]
00A062D7 call 0x44b300
00A062DC mov dword ptr [ebp - 0x11], eax
00A062DF mov dword ptr [ebp - 0xd], 0
00A062E6 mov ecx, dword ptr [0x17c8708]
00A062EC call 0x432440
00A062F1 mov ecx, dword ptr [eax]
00A062F3 mov edx, dword ptr [eax + 4]
00A062F6 mov dword ptr [ebp - 9], ecx
00A062F9 mov dword ptr [ebp - 5], edx
00A062FC push 0
00A062FE push 0
00A06300 push 0x3f
00A06302 lea eax, [ebp - 0x40]
00A06305 push eax
00A06306 push 0x2328
00A0630B call 0xa3fbb0
00A06310 add esp, 0x14
00A06313 mov ecx, dword ptr [ebp - 0x44]
00A06316 mov ecx, dword ptr [ecx + 4]
00A06319 call 0x9e9a30
00A0631E test eax, eax
00A06320 je 0xa06358
00A06322 mov ecx, dword ptr [0x17c8708]
00A06328 call 0x819120
00A0632D mov ecx, eax
00A0632F call 0x44b3f0
00A06334 test eax, eax
00A06336 je 0xa06358
00A06338 mov edx, dword ptr [ebp - 0x44]
00A0633B mov ecx, dword ptr [edx + 4]
00A0633E call 0x401000
00A06343 push edx
00A06344 push eax
00A06345 mov eax, dword ptr [ebp - 0x44]
00A06348 mov ecx, dword ptr [eax + 0x58]
00A0634B push ecx
00A0634C call 0x44a830
00A06351 mov ecx, eax
00A06353 call 0xa44470
00A06358 mov edx, dword ptr [ebp - 0x44]
00A0635B cmp dword ptr [edx + 4], 0
00A0635F je 0xa0636e
00A06361 push 0
00A06363 mov eax, dword ptr [ebp - 0x44]
00A06366 mov ecx, dword ptr [eax + 4]
00A06369 call 0x9e4090
00A0636E mov ecx, dword ptr [ebp - 0x44]
00A06371 call 0xa05dc0
00A06376 mov esp, ebp
00A06378 pop ebp
00A06379 ret

; FUNCTION 00A08850
00A08850 push ebp
00A08851 mov ebp, esp
00A08853 sub esp, 0x58
00A08856 mov dword ptr [ebp - 0x54], ecx
00A08859 mov eax, dword ptr [ebp - 0x54]
00A0885C mov ecx, dword ptr [eax + 0xc]
00A0885F mov edx, dword ptr [ecx]
00A08861 mov dword ptr [ebp - 0x58], edx
00A08864 mov eax, dword ptr [ebp - 0x58]
00A08867 sub eax, 1
00A0886A mov dword ptr [ebp - 0x58], eax
00A0886D cmp dword ptr [ebp - 0x58], 3
00A08871 ja 0xa08a4b
00A08877 mov ecx, dword ptr [ebp - 0x58]
00A0887A jmp dword ptr [ecx*4 + 0xa08a54]
00A08881 mov dword ptr [ebp - 0x48], 2
00A08888 lea edx, [ebp - 0x48]
00A0888B push edx
00A0888C mov eax, dword ptr [ebp - 0x54]
00A0888F mov ecx, dword ptr [eax + 8]
00A08892 add ecx, 0xc
00A08895 call 0x450eb0
00A0889A mov ecx, dword ptr [ebp - 0x54]
00A0889D mov edx, dword ptr [eax]
00A0889F mov dword ptr [ecx + 0xc], edx
00A088A2 push 0
00A088A4 mov ecx, dword ptr [ebp - 0x54]
00A088A7 call 0xa052e0
00A088AC jmp 0xa08a4b
00A088B1 mov eax, dword ptr [ebp - 0x54]
00A088B4 mov ecx, dword ptr [eax + 4]
00A088B7 call 0x9e7c70
00A088BC test eax, eax
00A088BE je 0xa088ec
00A088C0 mov ecx, dword ptr [ebp - 0x54]
00A088C3 cmp dword ptr [ecx + 0x50], 0
00A088C7 jne 0xa088ec
00A088C9 mov edx, dword ptr [ebp - 0x54]
00A088CC mov ecx, dword ptr [edx + 4]
00A088CF call 0x44b3f0
00A088D4 test eax, eax
00A088D6 jne 0xa088ec
00A088D8 push 5
00A088DA push 1
00A088DC mov eax, dword ptr [ebp - 0x54]
00A088DF mov ecx, dword ptr [eax + 4]
00A088E2 call 0x9e4040
00A088E7 jmp 0xa089f4
00A088EC mov dword ptr [ebp - 0x4c], 3
00A088F3 lea ecx, [ebp - 0x4c]
00A088F6 push ecx
00A088F7 mov edx, dword ptr [ebp - 0x54]
00A088FA mov ecx, dword ptr [edx + 8]
00A088FD add ecx, 0xc
00A08900 call 0x450eb0
00A08905 mov ecx, dword ptr [ebp - 0x54]
00A08908 mov edx, dword ptr [eax]
00A0890A mov dword ptr [ecx + 0xc], edx
00A0890D push 0
00A0890F mov ecx, dword ptr [ebp - 0x54]
00A08912 call 0xa052e0
00A08917 mov eax, dword ptr [ebp - 0x54]
00A0891A mov ecx, dword ptr [eax + 4]
00A0891D call 0x9e9a30
00A08922 test eax, eax
00A08924 je 0xa089f4
00A0892A mov ecx, dword ptr [ebp - 0x54]
00A0892D cmp dword ptr [ecx + 0x54], 0
00A08931 je 0xa089f4
00A08937 mov edx, dword ptr [ebp - 0x54]
00A0893A mov ecx, dword ptr [edx + 4]
00A0893D call 0x44b300
00A08942 mov dword ptr [ebp - 4], eax
00A08945 mov eax, dword ptr [ebp - 0x54]
00A08948 mov ecx, dword ptr [eax + 4]
00A0894B call 0x9f3220
00A08950 mov ecx, dword ptr [ebp - 0x54]
00A08953 mov dword ptr [ecx + 0x54], 0
00A0895A mov edx, dword ptr [ebp - 0x54]
00A0895D mov ecx, dword ptr [edx + 4]
00A08960 call 0x401000
00A08965 mov dword ptr [ebp - 0x1d], eax
00A08968 mov dword ptr [ebp - 0x19], edx
00A0896B mov eax, dword ptr [ebp - 4]
00A0896E mov dword ptr [ebp - 0x15], eax
00A08971 mov dword ptr [ebp - 0x11], 1
00A08978 mov ecx, dword ptr [0x17c8708]
00A0897E call 0x432440
00A08983 mov ecx, dword ptr [eax]
00A08985 mov edx, dword ptr [eax + 4]
00A08988 mov dword ptr [ebp - 0xd], ecx
00A0898B mov dword ptr [ebp - 9], edx
00A0898E push 0
00A08990 push 0
00A08992 push 0x3f
00A08994 lea eax, [ebp - 0x44]
00A08997 push eax
00A08998 push 0x232a
00A0899D call 0xa3fbb0
00A089A2 add esp, 0x14
00A089A5 push 0
00A089A7 mov ecx, dword ptr [ebp - 0x54]
00A089AA mov ecx, dword ptr [ecx + 4]
00A089AD call 0x9e4090
00A089B2 mov ecx, dword ptr [0x17c8708]
00A089B8 call 0x819120
00A089BD test eax, eax
00A089BF je 0xa089f4
00A089C1 mov ecx, dword ptr [0x17c8708]
00A089C7 call 0x819120
00A089CC mov ecx, eax
00A089CE call 0x44b3f0
00A089D3 test eax, eax
00A089D5 je 0xa089f4
00A089D7 mov edx, dword ptr [ebp - 0x54]
00A089DA mov ecx, dword ptr [edx + 4]
00A089DD call 0x401000
00A089E2 push edx
00A089E3 push eax
00A089E4 mov eax, dword ptr [ebp - 4]
00A089E7 push eax
00A089E8 call 0x44a830
00A089ED mov ecx, eax
00A089EF call 0xa44470
00A089F4 jmp 0xa08a4b
00A089F6 mov dword ptr [ebp - 0x50], 4
00A089FD lea ecx, [ebp - 0x50]
00A08A00 push ecx
00A08A01 mov edx, dword ptr [ebp - 0x54]
00A08A04 mov ecx, dword ptr [edx + 8]
00A08A07 add ecx, 0xc
00A08A0A call 0x450eb0
00A08A0F mov ecx, dword ptr [ebp - 0x54]
00A08A12 mov edx, dword ptr [eax]
00A08A14 mov dword ptr [ecx + 0xc], edx
00A08A17 push 0
00A08A19 mov ecx, dword ptr [ebp - 0x54]
00A08A1C call 0xa052e0
00A08A21 jmp 0xa08a4b
00A08A23 mov eax, dword ptr [ebp - 0x54]
00A08A26 mov ecx, dword ptr [eax + 4]
00A08A29 call 0x9e9a30
00A08A2E test eax, eax
00A08A30 je 0xa08a4b
00A08A32 mov ecx, dword ptr [ebp - 0x54]
00A08A35 mov edx, dword ptr [ecx + 4]
00A08A38 push edx
00A08A39 mov eax, dword ptr [ebp - 0x54]
00A08A3C mov ecx, dword ptr [eax + 4]
00A08A3F call 0x401040
00A08A44 mov ecx, eax
00A08A46 call 0x9ddd40
00A08A4B mov eax, 1
00A08A50 mov esp, ebp
00A08A52 pop ebp
00A08A53 ret

; FUNCTION 00A05AA0
00A05AA0 push ebp
00A05AA1 mov ebp, esp
00A05AA3 sub esp, 0x78
00A05AA6 mov dword ptr [ebp - 0x78], ecx
00A05AA9 mov eax, dword ptr [ebp + 8]
00A05AAC push eax
00A05AAD mov ecx, dword ptr [ebp + 0xc]
00A05AB0 push ecx
00A05AB1 call 0x440070
00A05AB6 mov ecx, eax
00A05AB8 call 0xa0c540
00A05ABD mov dword ptr [ebp - 4], eax
00A05AC0 cmp dword ptr [ebp - 4], 0
00A05AC4 je 0xa05ba1
00A05ACA mov edx, dword ptr [ebp + 8]
00A05ACD push edx
00A05ACE mov ecx, dword ptr [ebp - 0x78]
00A05AD1 call 0xa01e60
00A05AD6 mov eax, dword ptr [ebp - 4]
00A05AD9 push eax
00A05ADA mov ecx, dword ptr [ebp - 0x78]
00A05ADD mov edx, dword ptr [ecx]
00A05ADF mov ecx, dword ptr [ebp - 0x78]
00A05AE2 mov eax, dword ptr [edx + 4]
00A05AE5 call eax
00A05AE7 mov ecx, dword ptr [ebp - 0x78]
00A05AEA mov dword ptr [ecx + 0x50], 0
00A05AF1 mov edx, dword ptr [ebp - 0x78]
00A05AF4 mov dword ptr [edx + 0x54], 0
00A05AFB mov ecx, dword ptr [ebp + 8]
00A05AFE call 0x9e9a30
00A05B03 test eax, eax
00A05B05 je 0xa05b5c
00A05B07 mov ecx, dword ptr [0x17c8708]
00A05B0D call 0x819120
00A05B12 mov ecx, eax
00A05B14 call 0x44b3f0
00A05B19 test eax, eax
00A05B1B je 0xa05b5c
00A05B1D mov ecx, dword ptr [ebp + 8]
00A05B20 call 0x401000
00A05B25 mov dword ptr [ebp - 0x15], eax
00A05B28 mov dword ptr [ebp - 0x11], edx
00A05B2B mov eax, dword ptr [ebp + 0x10]
00A05B2E mov dword ptr [ebp - 0xd], eax
00A05B31 mov dword ptr [ebp - 9], 1
00A05B38 mov ecx, dword ptr [ebp - 0x78]
00A05B3B mov edx, dword ptr [ebp + 0x10]
00A05B3E mov dword ptr [ecx + 0x58], edx
00A05B41 lea eax, [ebp - 0x3c]
00A05B44 push eax
00A05B45 call 0x44a830
00A05B4A mov ecx, eax
00A05B4C call 0xa443b0
00A05B51 movzx ecx, al
00A05B54 mov edx, dword ptr [ebp - 0x78]
00A05B57 mov dword ptr [edx + 0x54], ecx
00A05B5A jmp 0xa05b9a
00A05B5C mov ecx, dword ptr [ebp + 8]
00A05B5F call 0x9e7c70
00A05B64 test eax, eax
00A05B66 je 0xa05b9a
00A05B68 mov ecx, dword ptr [ebp + 8]
00A05B6B call 0x401000
00A05B70 mov dword ptr [ebp - 0x4d], eax
00A05B73 mov dword ptr [ebp - 0x49], edx
00A05B76 mov eax, dword ptr [ebp + 0x10]
00A05B79 mov dword ptr [ebp - 0x45], eax
00A05B7C mov dword ptr [ebp - 0x41], 1
00A05B83 push 0
00A05B85 push 0
00A05B87 push 0x37
00A05B89 lea ecx, [ebp - 0x74]
00A05B8C push ecx
00A05B8D push 0x251c
00A05B92 call 0xa3fbb0
00A05B97 add esp, 0x14
00A05B9A mov eax, 1
00A05B9F jmp 0xa05ba3
00A05BA1 xor eax, eax
00A05BA3 mov esp, ebp
00A05BA5 pop ebp
00A05BA6 ret 0xc

; FUNCTION 00A06190
00A06190 push ebp
00A06191 mov ebp, esp
00A06193 sub esp, 0x3c
00A06196 mov dword ptr [ebp - 0x3c], ecx
00A06199 mov eax, dword ptr [ebp - 0x3c]
00A0619C cmp dword ptr [eax + 0x54], 0
00A061A0 je 0xa06262
00A061A6 mov ecx, dword ptr [ebp - 0x3c]
00A061A9 cmp dword ptr [ecx + 4], 0
00A061AD je 0xa06262
00A061B3 mov edx, dword ptr [ebp - 0x3c]
00A061B6 mov ecx, dword ptr [edx + 4]
00A061B9 call 0x9e7c70
00A061BE test eax, eax
00A061C0 je 0xa0621d
00A061C2 mov eax, dword ptr [ebp - 0x3c]
00A061C5 mov ecx, dword ptr [eax + 4]
00A061C8 call 0x9e48b0
00A061CD test eax, eax
00A061CF je 0xa0621d
00A061D1 mov ecx, dword ptr [ebp - 0x3c]
00A061D4 mov ecx, dword ptr [ecx + 4]
00A061D7 call 0x44b3f0
00A061DC test eax, eax
00A061DE jne 0xa0621d
00A061E0 mov edx, dword ptr [ebp - 0x3c]
00A061E3 mov ecx, dword ptr [edx + 4]
00A061E6 call 0x401000
00A061EB mov dword ptr [ebp - 0x11], eax
00A061EE mov dword ptr [ebp - 0xd], edx
00A061F1 mov eax, dword ptr [ebp - 0x3c]
00A061F4 mov ecx, dword ptr [eax + 4]
00A061F7 call 0x9e48b0
00A061FC mov dword ptr [ebp - 9], eax
00A061FF mov dword ptr [ebp - 5], 0
00A06206 push 0
00A06208 push 0
00A0620A push 0x37
00A0620C lea ecx, [ebp - 0x38]
00A0620F push ecx
00A06210 push 0x251c
00A06215 call 0xa3fbb0
00A0621A add esp, 0x14
00A0621D mov edx, dword ptr [ebp - 0x3c]
00A06220 mov ecx, dword ptr [edx + 4]
00A06223 call 0x9e9a30
00A06228 test eax, eax
00A0622A je 0xa06262
00A0622C mov ecx, dword ptr [0x17c8708]
00A06232 call 0x819120
00A06237 mov ecx, eax
00A06239 call 0x44b3f0
00A0623E test eax, eax
00A06240 je 0xa06262
00A06242 mov eax, dword ptr [ebp - 0x3c]
00A06245 mov ecx, dword ptr [eax + 4]
00A06248 call 0x401000
00A0624D push edx
00A0624E push eax
00A0624F mov ecx, dword ptr [ebp - 0x3c]
00A06252 mov edx, dword ptr [ecx + 0x58]
00A06255 push edx
00A06256 call 0x44a830
00A0625B mov ecx, eax
00A0625D call 0xa44340
00A06262 mov ecx, dword ptr [ebp - 0x3c]
00A06265 call 0xa05dc0
00A0626A mov esp, ebp
00A0626C pop ebp
00A0626D ret

; FUNCTION 00A08650
00A08650 push ebp
00A08651 mov ebp, esp
00A08653 sub esp, 0x50
00A08656 mov dword ptr [ebp - 0x4c], ecx
00A08659 mov eax, dword ptr [ebp - 0x4c]
00A0865C mov ecx, dword ptr [eax + 0xc]
00A0865F mov edx, dword ptr [ecx]
00A08661 mov dword ptr [ebp - 0x50], edx
00A08664 mov eax, dword ptr [ebp - 0x50]
00A08667 sub eax, 1
00A0866A mov dword ptr [ebp - 0x50], eax
00A0866D cmp dword ptr [ebp - 0x50], 3
00A08671 ja 0xa08828
00A08677 mov ecx, dword ptr [ebp - 0x50]
00A0867A jmp dword ptr [ecx*4 + 0xa08834]
00A08681 mov dword ptr [ebp - 0x40], 2
00A08688 lea edx, [ebp - 0x40]
00A0868B push edx
00A0868C mov eax, dword ptr [ebp - 0x4c]
00A0868F mov ecx, dword ptr [eax + 8]
00A08692 add ecx, 0xc
00A08695 call 0x450eb0
00A0869A mov ecx, dword ptr [ebp - 0x4c]
00A0869D mov edx, dword ptr [eax]
00A0869F mov dword ptr [ecx + 0xc], edx
00A086A2 push 0
00A086A4 mov ecx, dword ptr [ebp - 0x4c]
00A086A7 call 0xa052e0
00A086AC jmp 0xa08828
00A086B1 mov eax, dword ptr [ebp - 0x4c]
00A086B4 mov ecx, dword ptr [eax + 4]
00A086B7 call 0x9e7c70
00A086BC test eax, eax
00A086BE je 0xa086ec
00A086C0 mov ecx, dword ptr [ebp - 0x4c]
00A086C3 cmp dword ptr [ecx + 0x50], 0
00A086C7 jne 0xa086ec
00A086C9 mov edx, dword ptr [ebp - 0x4c]
00A086CC mov ecx, dword ptr [edx + 4]
00A086CF call 0x44b3f0
00A086D4 test eax, eax
00A086D6 jne 0xa086ec
00A086D8 push 5
00A086DA push 1
00A086DC mov eax, dword ptr [ebp - 0x4c]
00A086DF mov ecx, dword ptr [eax + 4]
00A086E2 call 0x9e4040
00A086E7 jmp 0xa087d1
00A086EC mov dword ptr [ebp - 0x44], 3
00A086F3 lea ecx, [ebp - 0x44]
00A086F6 push ecx
00A086F7 mov edx, dword ptr [ebp - 0x4c]
00A086FA mov ecx, dword ptr [edx + 8]
00A086FD add ecx, 0xc
00A08700 call 0x450eb0
00A08705 mov ecx, dword ptr [ebp - 0x4c]
00A08708 mov edx, dword ptr [eax]
00A0870A mov dword ptr [ecx + 0xc], edx
00A0870D push 0
00A0870F mov ecx, dword ptr [ebp - 0x4c]
00A08712 call 0xa052e0
00A08717 mov eax, dword ptr [ebp - 0x4c]
00A0871A mov ecx, dword ptr [eax + 4]
00A0871D call 0x9e9a30
00A08722 test eax, eax
00A08724 je 0xa087d1
00A0872A mov ecx, dword ptr [ebp - 0x4c]
00A0872D cmp dword ptr [ecx + 0x54], 0
00A08731 je 0xa087d1
00A08737 mov edx, dword ptr [ebp - 0x4c]
00A0873A mov ecx, dword ptr [edx + 4]
00A0873D call 0x9e48b0
00A08742 mov dword ptr [ebp - 4], eax
00A08745 mov eax, dword ptr [ebp - 0x4c]
00A08748 mov ecx, dword ptr [eax + 4]
00A0874B call 0x9e42a0
00A08750 mov ecx, dword ptr [ebp - 0x4c]
00A08753 mov dword ptr [ecx + 0x54], 0
00A0875A mov edx, dword ptr [ebp - 0x4c]
00A0875D mov ecx, dword ptr [edx + 4]
00A08760 call 0x401000
00A08765 mov dword ptr [ebp - 0x15], eax
00A08768 mov dword ptr [ebp - 0x11], edx
00A0876B mov eax, dword ptr [ebp - 4]
00A0876E mov dword ptr [ebp - 0xd], eax
00A08771 mov dword ptr [ebp - 9], 1
00A08778 push 0
00A0877A push 0
00A0877C push 0x37
00A0877E lea ecx, [ebp - 0x3c]
00A08781 push ecx
00A08782 push 0x251e
00A08787 call 0xa3fbb0
00A0878C add esp, 0x14
00A0878F mov ecx, dword ptr [0x17c8708]
00A08795 call 0x819120
00A0879A test eax, eax
00A0879C je 0xa087d1
00A0879E mov ecx, dword ptr [0x17c8708]
00A087A4 call 0x819120
00A087A9 mov ecx, eax
00A087AB call 0x44b3f0
00A087B0 test eax, eax
00A087B2 je 0xa087d1
00A087B4 mov edx, dword ptr [ebp - 0x4c]
00A087B7 mov ecx, dword ptr [edx + 4]
00A087BA call 0x401000
00A087BF push edx
00A087C0 push eax
00A087C1 mov eax, dword ptr [ebp - 4]
00A087C4 push eax
00A087C5 call 0x44a830
00A087CA mov ecx, eax
00A087CC call 0xa44340
00A087D1 jmp 0xa08828
00A087D3 mov dword ptr [ebp - 0x48], 4
00A087DA lea ecx, [ebp - 0x48]
00A087DD push ecx
00A087DE mov edx, dword ptr [ebp - 0x4c]
00A087E1 mov ecx, dword ptr [edx + 8]
00A087E4 add ecx, 0xc
00A087E7 call 0x450eb0
00A087EC mov ecx, dword ptr [ebp - 0x4c]
00A087EF mov edx, dword ptr [eax]
00A087F1 mov dword ptr [ecx + 0xc], edx
00A087F4 push 0
00A087F6 mov ecx, dword ptr [ebp - 0x4c]
00A087F9 call 0xa052e0
00A087FE jmp 0xa08828
00A08800 mov eax, dword ptr [ebp - 0x4c]
00A08803 mov ecx, dword ptr [eax + 4]
00A08806 call 0x9e9a30
00A0880B test eax, eax
00A0880D je 0xa08828
00A0880F mov ecx, dword ptr [ebp - 0x4c]
00A08812 mov edx, dword ptr [ecx + 4]
00A08815 push edx
00A08816 mov eax, dword ptr [ebp - 0x4c]
00A08819 mov ecx, dword ptr [eax + 4]
00A0881C call 0x401040
00A08821 mov ecx, eax
00A08823 call 0x9ddd40
00A08828 mov eax, 1
00A0882D mov esp, ebp
00A0882F pop ebp
00A08830 ret
