; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; FUNCTION 007F69E0
007F69E0 push ebp
007F69E1 mov ebp, esp
007F69E3 push -1
007F69E5 push 0xaa98a2
007F69EA mov eax, dword ptr fs:[0]
007F69F0 push eax
007F69F1 push ecx
007F69F2 mov eax, dword ptr [0xc7b480]
007F69F7 xor eax, ebp
007F69F9 push eax
007F69FA lea eax, [ebp - 0xc]
007F69FD mov dword ptr fs:[0], eax
007F6A03 mov dword ptr [ebp - 0x10], ecx
007F6A06 mov eax, dword ptr [ebp - 0x10]
007F6A09 mov dword ptr [eax], 0xbce4fc
007F6A0F mov ecx, dword ptr [ebp - 0x10]
007F6A12 mov dword ptr [ecx + 4], 0xbce6b8
007F6A19 mov edx, dword ptr [ebp - 0x10]
007F6A1C mov dword ptr [edx + 0x29c], 0xbce6cc
007F6A26 mov eax, dword ptr [ebp - 0x10]
007F6A29 mov dword ptr [eax + 0x2a0], 0xbce6dc
007F6A33 mov ecx, dword ptr [ebp - 0x10]
007F6A36 mov dword ptr [ecx + 0x2a4], 0xbce6e8
007F6A40 mov edx, dword ptr [ebp - 0x10]
007F6A43 mov dword ptr [edx + 0x2a8], 0xbce6f8
007F6A4D mov eax, dword ptr [ebp - 0x10]
007F6A50 mov dword ptr [eax + 0x2ac], 0xbce708
007F6A5A mov ecx, dword ptr [ebp - 0x10]
007F6A5D mov dword ptr [ecx + 0x2b0], 0xbce730
007F6A67 mov edx, dword ptr [ebp - 0x10]
007F6A6A mov dword ptr [edx + 0x2b4], 0xbce740
007F6A74 mov eax, dword ptr [ebp - 0x10]
007F6A77 mov dword ptr [eax + 0x2b8], 0xbce750
007F6A81 mov dword ptr [ebp - 4], 3
007F6A88 mov ecx, dword ptr [ebp - 0x10]
007F6A8B add ecx, 0x838
007F6A91 call 0x406890
007F6A96 mov ecx, dword ptr [ebp - 0x10]
007F6A99 add ecx, 0x684
007F6A9F call 0x41c760
007F6AA4 mov byte ptr [ebp - 4], 2
007F6AA8 mov ecx, dword ptr [ebp - 0x10]
007F6AAB add ecx, 0x604
007F6AB1 call 0x481460
007F6AB6 mov byte ptr [ebp - 4], 1
007F6ABA mov ecx, dword ptr [ebp - 0x10]
007F6ABD add ecx, 0x580
007F6AC3 call 0x481460
007F6AC8 mov byte ptr [ebp - 4], 0
007F6ACC mov ecx, dword ptr [ebp - 0x10]
007F6ACF add ecx, 0x578
007F6AD5 call 0x556970
007F6ADA mov dword ptr [ebp - 4], 0xffffffff
007F6AE1 mov ecx, dword ptr [ebp - 0x10]
007F6AE4 call 0x7d6350
007F6AE9 mov ecx, dword ptr [ebp - 0xc]
007F6AEC mov dword ptr fs:[0], ecx
007F6AF3 pop ecx
007F6AF4 mov esp, ebp
007F6AF6 pop ebp
007F6AF7 ret

; FUNCTION 007F7C90
007F7C90 push ebp
007F7C91 mov ebp, esp
007F7C93 push -1
007F7C95 push 0xac58bc
007F7C9A mov eax, dword ptr fs:[0]
007F7CA0 push eax
007F7CA1 sub esp, 0x5c
007F7CA4 mov eax, dword ptr [0xc7b480]
007F7CA9 xor eax, ebp
007F7CAB push eax
007F7CAC lea eax, [ebp - 0xc]
007F7CAF mov dword ptr fs:[0], eax
007F7CB5 mov dword ptr [ebp - 0x68], ecx
007F7CB8 mov eax, dword ptr [0xb96cf0]
007F7CBD push eax
007F7CBE lea ecx, [ebp - 0x48]
007F7CC1 call 0x405650
007F7CC6 mov dword ptr [ebp - 4], 0
007F7CCD mov ecx, dword ptr [0xb96cec]
007F7CD3 push ecx
007F7CD4 lea ecx, [ebp - 0x64]
007F7CD7 call 0x405650
007F7CDC mov byte ptr [ebp - 4], 1
007F7CE0 push 0
007F7CE2 lea edx, [ebp - 0x48]
007F7CE5 push edx
007F7CE6 lea eax, [ebp - 0x64]
007F7CE9 push eax
007F7CEA mov ecx, dword ptr [ebp - 0x68]
007F7CED call 0x7da5f0
007F7CF2 mov byte ptr [ebp - 4], 3
007F7CF6 lea ecx, [ebp - 0x64]
007F7CF9 call 0x4056d0
007F7CFE mov byte ptr [ebp - 4], 4
007F7D02 lea ecx, [ebp - 0x48]
007F7D05 call 0x4056d0
007F7D0A mov ecx, dword ptr [ebp - 0x68]
007F7D0D add ecx, 0x578
007F7D13 call 0x556850
007F7D18 mov byte ptr [ebp - 4], 5
007F7D1C mov ecx, dword ptr [ebp - 0x68]
007F7D1F mov dword ptr [ecx], 0xbce4fc
007F7D25 mov edx, dword ptr [ebp - 0x68]
007F7D28 mov dword ptr [edx + 4], 0xbce6b8
007F7D2F mov eax, dword ptr [ebp - 0x68]
007F7D32 mov dword ptr [eax + 0x29c], 0xbce6cc
007F7D3C mov ecx, dword ptr [ebp - 0x68]
007F7D3F mov dword ptr [ecx + 0x2a0], 0xbce6dc
007F7D49 mov edx, dword ptr [ebp - 0x68]
007F7D4C mov dword ptr [edx + 0x2a4], 0xbce6e8
007F7D56 mov eax, dword ptr [ebp - 0x68]
007F7D59 mov dword ptr [eax + 0x2a8], 0xbce6f8
007F7D63 mov ecx, dword ptr [ebp - 0x68]
007F7D66 mov dword ptr [ecx + 0x2ac], 0xbce708
007F7D70 mov edx, dword ptr [ebp - 0x68]
007F7D73 mov dword ptr [edx + 0x2b0], 0xbce730
007F7D7D mov eax, dword ptr [ebp - 0x68]
007F7D80 mov dword ptr [eax + 0x2b4], 0xbce740
007F7D8A mov ecx, dword ptr [ebp - 0x68]
007F7D8D mov dword ptr [ecx + 0x2b8], 0xbce750
007F7D97 mov ecx, dword ptr [ebp - 0x68]
007F7D9A add ecx, 0x580
007F7DA0 call 0x481440
007F7DA5 mov byte ptr [ebp - 4], 6
007F7DA9 mov ecx, dword ptr [ebp - 0x68]
007F7DAC add ecx, 0x604
007F7DB2 call 0x481440
007F7DB7 mov byte ptr [ebp - 4], 7
007F7DBB mov ecx, dword ptr [ebp - 0x68]
007F7DBE add ecx, 0x684
007F7DC4 call 0x406590
007F7DC9 mov byte ptr [ebp - 4], 8
007F7DCD mov ecx, dword ptr [ebp - 0x68]
007F7DD0 add ecx, 0x838
007F7DD6 call 0x41c7e0
007F7DDB mov byte ptr [ebp - 4], 9
007F7DDF lea ecx, [ebp - 0x2c]
007F7DE2 call 0x4eaea0
007F7DE7 mov byte ptr [ebp - 4], 0xa
007F7DEB mov edx, dword ptr [ebp - 0x68]
007F7DEE mov eax, dword ptr [edx + 0x600]
007F7DF4 push eax
007F7DF5 lea ecx, [ebp - 0x2c]
007F7DF8 push ecx
007F7DF9 call 0xa55fb0
007F7DFE mov ecx, eax
007F7E00 call 0xa56560
007F7E05 lea ecx, [ebp - 0x2c]
007F7E08 call 0x4c4cb0
007F7E0D test eax, eax
007F7E0F ja 0x7f7e1f
007F7E11 mov byte ptr [ebp - 4], 9
007F7E15 lea ecx, [ebp - 0x2c]
007F7E18 call 0x4eae50
007F7E1D jmp 0x7f7e79
007F7E1F lea ecx, [ebp - 0x2c]
007F7E22 call 0x4c4cb0
007F7E27 xor edx, edx
007F7E29 mov ecx, 6
007F7E2E div ecx
007F7E30 test edx, edx
007F7E32 je 0x7f7e53
007F7E34 lea ecx, [ebp - 0x2c]
007F7E37 call 0x4c4cb0
007F7E3C xor edx, edx
007F7E3E mov ecx, 6
007F7E43 div ecx
007F7E45 add eax, 1
007F7E48 mov edx, dword ptr [ebp - 0x68]
007F7E4B mov dword ptr [edx + 0x57c], eax
007F7E51 jmp 0x7f7e6d
007F7E53 lea ecx, [ebp - 0x2c]
007F7E56 call 0x4c4cb0
007F7E5B xor edx, edx
007F7E5D mov ecx, 6
007F7E62 div ecx
007F7E64 mov edx, dword ptr [ebp - 0x68]
007F7E67 mov dword ptr [edx + 0x57c], eax
007F7E6D mov byte ptr [ebp - 4], 9
007F7E71 lea ecx, [ebp - 0x2c]
007F7E74 call 0x4eae50
007F7E79 mov dword ptr [ebp - 4], 0xffffffff
007F7E80 mov eax, dword ptr [ebp - 0x68]
007F7E83 mov ecx, dword ptr [ebp - 0xc]
007F7E86 mov dword ptr fs:[0], ecx
007F7E8D pop ecx
007F7E8E mov esp, ebp
007F7E90 pop ebp
007F7E91 ret

; FUNCTION 007F7EA0
007F7EA0 push ebp
007F7EA1 mov ebp, esp
007F7EA3 push -1
007F7EA5 push 0xad734b
007F7EAA mov eax, dword ptr fs:[0]
007F7EB0 push eax
007F7EB1 sub esp, 0x450
007F7EB7 mov eax, dword ptr [0xc7b480]
007F7EBC xor eax, ebp
007F7EBE mov dword ptr [ebp - 0x48], eax
007F7EC1 push esi
007F7EC2 push eax
007F7EC3 lea eax, [ebp - 0xc]
007F7EC6 mov dword ptr fs:[0], eax
007F7ECC mov dword ptr [ebp - 0x450], ecx
007F7ED2 mov eax, dword ptr [0xb96d14]
007F7ED7 push eax
007F7ED8 lea ecx, [ebp - 0x1f0]
007F7EDE call 0x405650
007F7EE3 mov dword ptr [ebp - 4], 0
007F7EEA lea ecx, [ebp - 0x1f0]
007F7EF0 push ecx
007F7EF1 mov ecx, dword ptr [ebp - 0x450]
007F7EF7 call 0x75fbf0
007F7EFC mov dword ptr [ebp - 0x34], eax
007F7EFF mov dword ptr [ebp - 4], 0xffffffff
007F7F06 lea ecx, [ebp - 0x1f0]
007F7F0C call 0x4056d0
007F7F11 cmp dword ptr [ebp - 0x34], 0
007F7F15 je 0x7f7f63
007F7F17 mov ecx, dword ptr [ebp - 0x450]
007F7F1D add ecx, 0x5a8
007F7F23 call 0x406410
007F7F28 push eax
007F7F29 lea ecx, [ebp - 0x20c]
007F7F2F call 0x405650
007F7F34 mov dword ptr [ebp - 4], 1
007F7F3B lea edx, [ebp - 0x20c]
007F7F41 push edx
007F7F42 mov ecx, dword ptr [ebp - 0x34]
007F7F45 call 0x4b85c0
007F7F4A mov ecx, eax
007F7F4C call 0x7564d0
007F7F51 mov dword ptr [ebp - 4], 0xffffffff
007F7F58 lea ecx, [ebp - 0x20c]
007F7F5E call 0x4056d0
007F7F63 mov eax, dword ptr [0xb96d24]
007F7F68 push eax
007F7F69 lea ecx, [ebp - 0x228]
007F7F6F call 0x405650
007F7F74 mov dword ptr [ebp - 4], 2
007F7F7B lea ecx, [ebp - 0x228]
007F7F81 push ecx
007F7F82 mov ecx, dword ptr [ebp - 0x450]
007F7F88 call 0x75fbf0
007F7F8D mov dword ptr [ebp - 0x1c], eax
007F7F90 mov dword ptr [ebp - 4], 0xffffffff
007F7F97 lea ecx, [ebp - 0x228]
007F7F9D call 0x4056d0
007F7FA2 cmp dword ptr [ebp - 0x1c], 0
007F7FA6 je 0x7f7fe4
007F7FA8 mov edx, dword ptr [ebp - 0x450]
007F7FAE add edx, 0x5ac
007F7FB4 push edx
007F7FB5 lea ecx, [ebp - 0x3c]
007F7FB8 call 0x405fb0
007F7FBD mov dword ptr [ebp - 4], 3
007F7FC4 lea ecx, [ebp - 0x3c]
007F7FC7 call 0x406410
007F7FCC push eax
007F7FCD mov ecx, dword ptr [ebp - 0x1c]
007F7FD0 call 0x74c640
007F7FD5 mov dword ptr [ebp - 4], 0xffffffff
007F7FDC lea ecx, [ebp - 0x3c]
007F7FDF call 0x406050
007F7FE4 mov eax, dword ptr [0xb96d74]
007F7FE9 push eax
007F7FEA lea ecx, [ebp - 0x244]
007F7FF0 call 0x405650
007F7FF5 mov dword ptr [ebp - 4], 4
007F7FFC lea ecx, [ebp - 0x244]
007F8002 push ecx
007F8003 mov ecx, dword ptr [ebp - 0x450]
007F8009 call 0x75fbf0
007F800E mov dword ptr [ebp - 0x30], eax
007F8011 mov dword ptr [ebp - 4], 0xffffffff
007F8018 lea ecx, [ebp - 0x244]
007F801E call 0x4056d0
007F8023 cmp dword ptr [ebp - 0x30], 0
007F8027 je 0x7f803e
007F8029 mov edx, dword ptr [ebp - 0x450]
007F802F mov eax, dword ptr [edx + 0x594]
007F8035 push eax
007F8036 mov ecx, dword ptr [ebp - 0x30]
007F8039 call 0xa859d0
007F803E mov ecx, dword ptr [0xb96d88]
007F8044 push ecx
007F8045 lea ecx, [ebp - 0x260]
007F804B call 0x405650
007F8050 mov dword ptr [ebp - 4], 5
007F8057 lea edx, [ebp - 0x260]
007F805D push edx
007F805E mov ecx, dword ptr [ebp - 0x450]
007F8064 call 0x75fbf0
007F8069 mov dword ptr [ebp - 0x28], eax
007F806C mov dword ptr [ebp - 4], 0xffffffff
007F8073 lea ecx, [ebp - 0x260]
007F8079 call 0x4056d0
007F807E mov eax, dword ptr [0xb96d80]
007F8083 push eax
007F8084 lea ecx, [ebp - 0x27c]
007F808A call 0x405650
007F808F mov dword ptr [ebp - 4], 6
007F8096 lea ecx, [ebp - 0x27c]
007F809C push ecx
007F809D mov ecx, dword ptr [ebp - 0x450]
007F80A3 call 0x75fbf0
007F80A8 mov dword ptr [ebp - 0x38], eax
007F80AB mov dword ptr [ebp - 4], 0xffffffff
007F80B2 lea ecx, [ebp - 0x27c]
007F80B8 call 0x4056d0
007F80BD mov edx, dword ptr [0xb96d84]
007F80C3 push edx
007F80C4 lea ecx, [ebp - 0x298]
007F80CA call 0x405650
007F80CF mov dword ptr [ebp - 4], 7
007F80D6 lea eax, [ebp - 0x298]
007F80DC push eax
007F80DD mov ecx, dword ptr [ebp - 0x450]
007F80E3 call 0x75fbf0
007F80E8 mov dword ptr [ebp - 0x2c], eax
007F80EB mov dword ptr [ebp - 4], 0xffffffff
007F80F2 lea ecx, [ebp - 0x298]
007F80F8 call 0x4056d0
007F80FD mov ecx, dword ptr [0xb96d8c]
007F8103 push ecx
007F8104 lea ecx, [ebp - 0x2b4]
007F810A call 0x405650
007F810F mov dword ptr [ebp - 4], 8
007F8116 lea edx, [ebp - 0x2b4]
007F811C push edx
007F811D mov ecx, dword ptr [ebp - 0x450]
007F8123 call 0x75fbf0
007F8128 mov dword ptr [ebp - 0x24], eax
007F812B mov dword ptr [ebp - 4], 0xffffffff
007F8132 lea ecx, [ebp - 0x2b4]
007F8138 call 0x4056d0
007F813D cmp dword ptr [ebp - 0x38], 0
007F8141 je 0x7f83ae
007F8147 cmp dword ptr [ebp - 0x28], 0
007F814B je 0x7f83ae
007F8151 cmp dword ptr [ebp - 0x2c], 0
007F8155 je 0x7f83ae
007F815B cmp dword ptr [ebp - 0x24], 0
007F815F je 0x7f83ae
007F8165 mov eax, dword ptr [ebp - 0x450]
007F816B cmp dword ptr [eax + 0x5dc], 2
007F8172 je 0x7f818c
007F8174 mov ecx, dword ptr [ebp - 0x450]
007F817A cmp dword ptr [ecx + 0x5dc], 4
007F8181 je 0x7f818c
007F8183 mov byte ptr [ebp - 0x451], 0
007F818A jmp 0x7f8193
007F818C mov byte ptr [ebp - 0x451], 1
007F8193 movzx edx, byte ptr [ebp - 0x451]
007F819A push edx
007F819B mov ecx, dword ptr [ebp - 0x24]
007F819E call 0x75aa30
007F81A3 mov eax, dword ptr [ebp - 0x450]
007F81A9 cmp dword ptr [eax + 0x5dc], 2
007F81B0 je 0x7f81c5
007F81B2 mov ecx, dword ptr [ebp - 0x450]
007F81B8 cmp dword ptr [ecx + 0x5dc], 4
007F81BF jne 0x7f83ae
007F81C5 mov edx, dword ptr [ebp - 0x450]
007F81CB mov eax, dword ptr [edx + 0x5e0]
007F81D1 xor edx, edx
007F81D3 mov ecx, 0x64
007F81D8 div ecx
007F81DA mov dword ptr [ebp - 0x44], eax
007F81DD mov edx, dword ptr [ebp - 0x44]
007F81E0 push edx
007F81E1 call 0xa21b30
007F81E6 mov ecx, eax
007F81E8 call 0xa1e560
007F81ED mov dword ptr [ebp - 0x40], eax
007F81F0 cmp dword ptr [ebp - 0x40], 0
007F81F4 jne 0x7f82c0
007F81FA push 0xb96699
007F81FF lea ecx, [ebp - 0x2d0]
007F8205 call 0x405650
007F820A mov dword ptr [ebp - 4], 9
007F8211 push 1
007F8213 lea eax, [ebp - 0x2d0]
007F8219 push eax
007F821A mov ecx, dword ptr [ebp - 0x38]
007F821D mov edx, dword ptr [ecx]
007F821F mov ecx, dword ptr [ebp - 0x38]
007F8222 mov eax, dword ptr [edx + 0xd4]
007F8228 call eax
007F822A mov dword ptr [ebp - 4], 0xffffffff
007F8231 lea ecx, [ebp - 0x2d0]
007F8237 call 0x4056d0
007F823C push 0xb96699
007F8241 lea ecx, [ebp - 0x2ec]
007F8247 call 0x405650
007F824C mov dword ptr [ebp - 4], 0xa
007F8253 lea ecx, [ebp - 0x2ec]
007F8259 push ecx
007F825A mov edx, dword ptr [ebp - 0x28]
007F825D mov eax, dword ptr [edx]
007F825F mov ecx, dword ptr [ebp - 0x28]
007F8262 mov edx, dword ptr [eax + 0x28]
007F8265 call edx
007F8267 mov dword ptr [ebp - 4], 0xffffffff
007F826E lea ecx, [ebp - 0x2ec]
007F8274 call 0x4056d0
007F8279 push 0xb96699
007F827E lea ecx, [ebp - 0x308]
007F8284 call 0x405650
007F8289 mov dword ptr [ebp - 4], 0xb
007F8290 push 1
007F8292 lea eax, [ebp - 0x308]
007F8298 push eax
007F8299 mov ecx, dword ptr [ebp - 0x2c]
007F829C mov edx, dword ptr [ecx]
007F829E mov ecx, dword ptr [ebp - 0x2c]
007F82A1 mov eax, dword ptr [edx + 0xd4]
007F82A7 call eax
007F82A9 mov dword ptr [ebp - 4], 0xffffffff
007F82B0 lea ecx, [ebp - 0x308]
007F82B6 call 0x4056d0
007F82BB jmp 0x7f83ae
007F82C0 mov ecx, dword ptr [ebp - 0x40]
007F82C3 add ecx, 0xc
007F82C6 call 0x406410
007F82CB push eax
007F82CC lea ecx, [ebp - 0x324]
007F82D2 call 0x405650
007F82D7 mov dword ptr [ebp - 4], 0xc
007F82DE push 1
007F82E0 lea ecx, [ebp - 0x324]
007F82E6 push ecx
007F82E7 mov edx, dword ptr [ebp - 0x38]
007F82EA mov eax, dword ptr [edx]
007F82EC mov ecx, dword ptr [ebp - 0x38]
007F82EF mov edx, dword ptr [eax + 0xd4]
007F82F5 call edx
007F82F7 mov dword ptr [ebp - 4], 0xffffffff
007F82FE lea ecx, [ebp - 0x324]
007F8304 call 0x4056d0
007F8309 mov ecx, dword ptr [ebp - 0x40]
007F830C add ecx, 0x44
007F830F call 0x406410
007F8314 push eax
007F8315 lea ecx, [ebp - 0x340]
007F831B call 0x405650
007F8320 mov dword ptr [ebp - 4], 0xd
007F8327 lea eax, [ebp - 0x340]
007F832D push eax
007F832E mov ecx, dword ptr [ebp - 0x28]
007F8331 mov edx, dword ptr [ecx]
007F8333 mov ecx, dword ptr [ebp - 0x28]
007F8336 mov eax, dword ptr [edx + 0x28]
007F8339 call eax
007F833B mov dword ptr [ebp - 4], 0xffffffff
007F8342 lea ecx, [ebp - 0x340]
007F8348 call 0x4056d0
007F834D mov ecx, dword ptr [ebp - 0x450]
007F8353 mov edx, dword ptr [ecx + 0x5e4]
007F8359 push edx
007F835A push 0xb9b2c8
007F835F push 0x20
007F8361 lea eax, [ebp - 0x68]
007F8364 push eax
007F8365 call 0x663beb
007F836A add esp, 0x10
007F836D lea ecx, [ebp - 0x68]
007F8370 push ecx
007F8371 lea ecx, [ebp - 0x35c]
007F8377 call 0x405650
007F837C mov dword ptr [ebp - 4], 0xe
007F8383 push 1
007F8385 lea edx, [ebp - 0x35c]
007F838B push edx
007F838C mov eax, dword ptr [ebp - 0x2c]
007F838F mov edx, dword ptr [eax]
007F8391 mov ecx, dword ptr [ebp - 0x2c]
007F8394 mov eax, dword ptr [edx + 0xd4]
007F839A call eax
007F839C mov dword ptr [ebp - 4], 0xffffffff
007F83A3 lea ecx, [ebp - 0x35c]
007F83A9 call 0x4056d0
007F83AE push 0xbce4c4
007F83B3 lea ecx, [ebp - 0x378]
007F83B9 call 0x405650
007F83BE mov dword ptr [ebp - 4], 0xf
007F83C5 lea ecx, [ebp - 0x378]
007F83CB push ecx
007F83CC mov ecx, dword ptr [ebp - 0x450]
007F83D2 call 0x75fbf0
007F83D7 mov dword ptr [ebp - 0x18], eax
007F83DA mov dword ptr [ebp - 4], 0xffffffff
007F83E1 lea ecx, [ebp - 0x378]
007F83E7 call 0x4056d0
007F83EC cmp dword ptr [ebp - 0x18], 0
007F83F0 je 0x7f8502
007F83F6 push 0xb96699
007F83FB lea ecx, [ebp - 0x394]
007F8401 call 0x405650
007F8406 mov dword ptr [ebp - 4], 0x10
007F840D push 1
007F840F lea edx, [ebp - 0x394]
007F8415 push edx
007F8416 mov eax, dword ptr [ebp - 0x18]
007F8419 mov edx, dword ptr [eax]
007F841B mov ecx, dword ptr [ebp - 0x18]
007F841E mov eax, dword ptr [edx + 0xd4]
007F8424 call eax
007F8426 mov dword ptr [ebp - 4], 0xffffffff
007F842D lea ecx, [ebp - 0x394]
007F8433 call 0x4056d0
007F8438 mov ecx, dword ptr [ebp - 0x450]
007F843E mov edx, dword ptr [ecx + 0x580]
007F8444 push edx
007F8445 call 0xa55020
007F844A mov ecx, eax
007F844C call 0xa54cc0
007F8451 mov dword ptr [ebp - 0x6c], eax
007F8454 cmp dword ptr [ebp - 0x6c], 0
007F8458 je 0x7f8502
007F845E mov dword ptr [ebp - 0x174], 0
007F8468 mov eax, dword ptr [ebp - 0x6c]
007F846B mov ecx, dword ptr [eax]
007F846D push ecx
007F846E call 0xa54e90
007F8473 mov ecx, eax
007F8475 call 0xa54c60
007F847A mov dword ptr [ebp - 0x170], eax
007F8480 cmp dword ptr [ebp - 0x170], 0
007F8487 je 0x7f8498
007F8489 mov edx, dword ptr [ebp - 0x170]
007F848F mov eax, dword ptr [edx + 4]
007F8492 mov dword ptr [ebp - 0x174], eax
007F8498 mov ecx, dword ptr [ebp - 0x6c]
007F849B mov edx, dword ptr [ecx + 4]
007F849E sub edx, dword ptr [ebp - 0x174]
007F84A4 push edx
007F84A5 push 0xbce4d0
007F84AA push 0x100
007F84AF lea eax, [ebp - 0x16c]
007F84B5 push eax
007F84B6 call 0x663beb
007F84BB add esp, 0x10
007F84BE lea ecx, [ebp - 0x16c]
007F84C4 push ecx
007F84C5 lea ecx, [ebp - 0x3b0]
007F84CB call 0x405650
007F84D0 mov dword ptr [ebp - 4], 0x11
007F84D7 push 1
007F84D9 lea edx, [ebp - 0x3b0]
007F84DF push edx
007F84E0 mov eax, dword ptr [ebp - 0x18]
007F84E3 mov edx, dword ptr [eax]
007F84E5 mov ecx, dword ptr [ebp - 0x18]
007F84E8 mov eax, dword ptr [edx + 0xd4]
007F84EE call eax
007F84F0 mov dword ptr [ebp - 4], 0xffffffff
007F84F7 lea ecx, [ebp - 0x3b0]
007F84FD call 0x4056d0
007F8502 lea ecx, [ebp - 0x14]
007F8505 call 0x471ae0
007F850A mov ecx, dword ptr [0xb96cf4]
007F8510 push ecx
007F8511 lea ecx, [ebp - 0x3cc]
007F8517 call 0x405650
007F851C mov dword ptr [ebp - 4], 0x12
007F8523 lea edx, [ebp - 0x3cc]
007F8529 push edx
007F852A mov ecx, dword ptr [ebp - 0x450]
007F8530 call 0x75fbf0
007F8535 mov dword ptr [ebp - 0x20], eax
007F8538 mov dword ptr [ebp - 4], 0xffffffff
007F853F lea ecx, [ebp - 0x3cc]
007F8545 call 0x4056d0
007F854A cmp dword ptr [ebp - 0x20], 0
007F854E je 0x7f897d
007F8554 mov ecx, dword ptr [0x17c8708]
007F855A call 0x4535c0
007F855F mov ecx, dword ptr [ebp - 0x450]
007F8565 mov dword ptr [ecx + 0x600], eax
007F856B mov edx, dword ptr [ebp - 0x450]
007F8571 cmp dword ptr [edx + 0x600], 0xa
007F8578 je 0x7f858d
007F857A mov eax, dword ptr [ebp - 0x450]
007F8580 cmp dword ptr [eax + 0x600], 9
007F8587 jne 0x7f8919
007F858D mov ecx, dword ptr [0xb96d94]
007F8593 push ecx
007F8594 lea ecx, [ebp - 0x3e8]
007F859A call 0x405650
007F859F mov dword ptr [ebp - 4], 0x13
007F85A6 lea edx, [ebp - 0x3e8]
007F85AC push edx
007F85AD mov ecx, dword ptr [ebp - 0x450]
007F85B3 call 0x75fbf0
007F85B8 mov dword ptr [ebp - 0x178], eax
007F85BE mov dword ptr [ebp - 4], 0xffffffff
007F85C5 lea ecx, [ebp - 0x3e8]
007F85CB call 0x4056d0
007F85D0 mov eax, dword ptr [0xb96d94]
007F85D5 push eax
007F85D6 lea ecx, [ebp - 0x404]
007F85DC call 0x405650
007F85E1 mov dword ptr [ebp - 4], 0x14
007F85E8 push 0
007F85EA push 0x12f8a44
007F85EF push 0x12f8898
007F85F4 lea ecx, [ebp - 0x404]
007F85FA push ecx
007F85FB mov ecx, dword ptr [ebp - 0x450]
007F8601 call 0x75fbf0
007F8606 push 0
007F8608 push eax
007F8609 call 0xa97b0e
007F860E add esp, 0x14
007F8611 mov dword ptr [ebp - 0x17c], eax
007F8617 mov dword ptr [ebp - 4], 0xffffffff
007F861E lea ecx, [ebp - 0x404]
007F8624 call 0x4056d0
007F8629 lea edx, [ebp - 0x40c]
007F862F push edx
007F8630 mov ecx, dword ptr [ebp - 0x450]
007F8636 add ecx, 0x838
007F863C call 0x4d6050
007F8641 mov ecx, dword ptr [eax]
007F8643 mov edx, dword ptr [eax + 4]
007F8646 mov dword ptr [ebp - 0x14], ecx
007F8649 mov dword ptr [ebp - 0x10], edx
007F864C jmp 0x7f865f
007F864E push 0
007F8650 lea eax, [ebp - 0x414]
007F8656 push eax
007F8657 lea ecx, [ebp - 0x14]
007F865A call 0x4e6c80
007F865F lea ecx, [ebp - 0x41c]
007F8665 push ecx
007F8666 mov ecx, dword ptr [ebp - 0x450]
007F866C add ecx, 0x838
007F8672 call 0x4f2590
007F8677 push eax
007F8678 lea ecx, [ebp - 0x14]
007F867B call 0x4ab8f0
007F8680 movzx edx, al
007F8683 test edx, edx
007F8685 je 0x7f8917
007F868B lea ecx, [ebp - 0x14]
007F868E call 0x4e19a0
007F8693 push eax
007F8694 call 0x4e6d90
007F8699 add esp, 4
007F869C mov ecx, dword ptr [ebp - 0x450]
007F86A2 cmp dword ptr [ecx + 0x5d8], eax
007F86A8 jne 0x7f86d4
007F86AA cmp dword ptr [ebp - 0x17c], 0
007F86B1 je 0x7f86c0
007F86B3 push 0
007F86B5 mov ecx, dword ptr [ebp - 0x17c]
007F86BB call 0x75aa30
007F86C0 push 1
007F86C2 mov ecx, dword ptr [ebp - 0x20]
007F86C5 call 0x75a960
007F86CA jmp 0x7f8917
007F86CF jmp 0x7f8912
007F86D4 cmp dword ptr [ebp - 0x17c], 0
007F86DB je 0x7f86ea
007F86DD push 1
007F86DF mov ecx, dword ptr [ebp - 0x17c]
007F86E5 call 0x75aa30
007F86EA cmp dword ptr [ebp - 0x178], 0
007F86F1 je 0x7f8903
007F86F7 lea ecx, [ebp - 0x1a4]
007F86FD call 0x471ae0
007F8702 mov edx, dword ptr [ebp - 0x450]
007F8708 mov eax, dword ptr [edx + 0x5d8]
007F870E mov dword ptr [ebp - 0x420], eax
007F8714 lea ecx, [ebp - 0x420]
007F871A push ecx
007F871B lea edx, [ebp - 0x428]
007F8721 push edx
007F8722 mov ecx, dword ptr [ebp - 0x450]
007F8728 add ecx, 0x684
007F872E call 0x532d60
007F8733 mov ecx, dword ptr [eax]
007F8735 mov edx, dword ptr [eax + 4]
007F8738 mov dword ptr [ebp - 0x1a4], ecx
007F873E mov dword ptr [ebp - 0x1a0], edx
007F8744 lea eax, [ebp - 0x430]
007F874A push eax
007F874B mov ecx, dword ptr [ebp - 0x450]
007F8751 add ecx, 0x684
007F8757 call 0x45abb0
007F875C push eax
007F875D lea ecx, [ebp - 0x1a4]
007F8763 call 0x4ab920
007F8768 movzx ecx, al
007F876B test ecx, ecx
007F876D je 0x7f8774
007F876F jmp 0x7f897d
007F8774 lea ecx, [ebp - 0x19c]
007F877A call 0x4eaea0
007F877F mov dword ptr [ebp - 4], 0x15
007F8786 mov edx, dword ptr [ebp - 0x450]
007F878C mov eax, dword ptr [edx + 0x600]
007F8792 push eax
007F8793 lea ecx, [ebp - 0x19c]
007F8799 push ecx
007F879A call 0xa55fb0
007F879F mov ecx, eax
007F87A1 call 0xa56560
007F87A6 lea ecx, [ebp - 0x19c]
007F87AC call 0x4c4cb0
007F87B1 test eax, eax
007F87B3 ja 0x7f87cc
007F87B5 mov dword ptr [ebp - 4], 0xffffffff
007F87BC lea ecx, [ebp - 0x19c]
007F87C2 call 0x4eae50
007F87C7 jmp 0x7f897d
007F87CC lea ecx, [ebp - 0x1ac]
007F87D2 call 0x471ae0
007F87D7 lea edx, [ebp - 0x438]
007F87DD push edx
007F87DE lea ecx, [ebp - 0x19c]
007F87E4 call 0x5504a0
007F87E9 mov ecx, dword ptr [eax]
007F87EB mov edx, dword ptr [eax + 4]
007F87EE mov dword ptr [ebp - 0x1ac], ecx
007F87F4 mov dword ptr [ebp - 0x1a8], edx
007F87FA jmp 0x7f8810
007F87FC push 0
007F87FE lea eax, [ebp - 0x440]
007F8804 push eax
007F8805 lea ecx, [ebp - 0x1ac]
007F880B call 0x556a40
007F8810 lea ecx, [ebp - 0x448]
007F8816 push ecx
007F8817 lea ecx, [ebp - 0x19c]
007F881D call 0x45abb0
007F8822 push eax
007F8823 lea ecx, [ebp - 0x1ac]
007F8829 call 0x4ab8f0
007F882E movzx edx, al
007F8831 test edx, edx
007F8833 je 0x7f88f1
007F8839 lea ecx, [ebp - 0x1ac]
007F883F call 0x4305b0
007F8844 mov esi, eax
007F8846 lea ecx, [ebp - 0x1a4]
007F884C call 0x4305b0
007F8851 mov ecx, dword ptr [esi + 4]
007F8854 cmp ecx, dword ptr [eax + 0x18]
007F8857 jne 0x7f88ec
007F885D lea ecx, [ebp - 0x1ac]
007F8863 call 0x4305b0
007F8868 add eax, 0x20
007F886B push eax
007F886C push 0xbce4e4
007F8871 lea edx, [ebp - 0x44c]
007F8877 push edx
007F8878 call 0x4062b0
007F887D add esp, 0xc
007F8880 mov dword ptr [ebp - 0x458], eax
007F8886 mov eax, dword ptr [ebp - 0x458]
007F888C mov dword ptr [ebp - 0x45c], eax
007F8892 mov byte ptr [ebp - 4], 0x16
007F8896 mov ecx, dword ptr [ebp - 0x45c]
007F889C call 0x453f50
007F88A1 push eax
007F88A2 lea ecx, [ebp - 0x1c8]
007F88A8 call 0x405650
007F88AD mov byte ptr [ebp - 4], 0x18
007F88B1 lea ecx, [ebp - 0x44c]
007F88B7 call 0x406050
007F88BC push 1
007F88BE lea ecx, [ebp - 0x1c8]
007F88C4 push ecx
007F88C5 mov edx, dword ptr [ebp - 0x178]
007F88CB mov eax, dword ptr [edx]
007F88CD mov ecx, dword ptr [ebp - 0x178]
007F88D3 mov edx, dword ptr [eax + 0xd4]
007F88D9 call edx
007F88DB mov byte ptr [ebp - 4], 0x15
007F88DF lea ecx, [ebp - 0x1c8]
007F88E5 call 0x4056d0
007F88EA jmp 0x7f88f1
007F88EC jmp 0x7f87fc
007F88F1 mov dword ptr [ebp - 4], 0xffffffff
007F88F8 lea ecx, [ebp - 0x19c]
007F88FE call 0x4eae50
007F8903 push 0
007F8905 mov ecx, dword ptr [ebp - 0x20]
007F8908 call 0x75a960
007F890D jmp 0x7f864e
007F8912 jmp 0x7f864e
007F8917 jmp 0x7f8923
007F8919 push 1
007F891B mov ecx, dword ptr [ebp - 0x20]
007F891E call 0x75a960
007F8923 cmp dword ptr [0x17c8708], 0
007F892A je 0x7f897d
007F892C mov eax, dword ptr [ebp - 0x450]
007F8932 mov ecx, dword ptr [eax + 0x5e0]
007F8938 mov dword ptr [ebp - 0x1d0], ecx
007F893E mov edx, dword ptr [ebp - 0x450]
007F8944 mov eax, dword ptr [edx + 0x5e4]
007F894A mov dword ptr [ebp - 0x1cc], eax
007F8950 lea ecx, [ebp - 0x1d0]
007F8956 push ecx
007F8957 mov ecx, dword ptr [0x17c8708]
007F895D call 0x81b050
007F8962 mov byte ptr [ebp - 0x1d1], al
007F8968 movzx edx, byte ptr [ebp - 0x1d1]
007F896F test edx, edx
007F8971 jne 0x7f897d
007F8973 push 0
007F8975 mov ecx, dword ptr [ebp - 0x20]
007F8978 call 0x75a960
007F897D mov ecx, dword ptr [ebp - 0xc]
007F8980 mov dword ptr fs:[0], ecx
007F8987 pop ecx
007F8988 pop esi
007F8989 mov ecx, dword ptr [ebp - 0x48]
007F898C xor ecx, ebp
007F898E call 0x6634fb
007F8993 mov esp, ebp
007F8995 pop ebp
007F8996 ret

; FUNCTION 005569D0
005569D0 push ebp
005569D1 mov ebp, esp
005569D3 sub esp, 0x2c
005569D6 mov dword ptr [ebp - 0x2c], ecx
005569D9 mov eax, dword ptr [ebp - 0x2c]
005569DC cmp eax, dword ptr [ebp + 8]
005569DF je 0x556a37
005569E1 lea ecx, [ebp - 0x10]
005569E4 push ecx
005569E5 mov ecx, dword ptr [ebp - 0x2c]
005569E8 call 0x45abb0
005569ED mov edx, dword ptr [eax]
005569EF mov eax, dword ptr [eax + 4]
005569F2 mov dword ptr [ebp - 8], edx
005569F5 mov dword ptr [ebp - 4], eax
005569F8 lea ecx, [ebp - 0x20]
005569FB push ecx
005569FC mov ecx, dword ptr [ebp - 0x2c]
005569FF call 0x5504a0
00556A04 mov edx, dword ptr [eax]
00556A06 mov eax, dword ptr [eax + 4]
00556A09 mov dword ptr [ebp - 0x18], edx
00556A0C mov dword ptr [ebp - 0x14], eax
00556A0F mov ecx, dword ptr [ebp - 4]
00556A12 push ecx
00556A13 mov edx, dword ptr [ebp - 8]
00556A16 push edx
00556A17 mov eax, dword ptr [ebp - 0x14]
00556A1A push eax
00556A1B mov ecx, dword ptr [ebp - 0x18]
00556A1E push ecx
00556A1F lea edx, [ebp - 0x28]
00556A22 push edx
00556A23 mov ecx, dword ptr [ebp - 0x2c]
00556A26 call 0x41f180
00556A2B mov eax, dword ptr [ebp + 8]
00556A2E push eax
00556A2F mov ecx, dword ptr [ebp - 0x2c]
00556A32 call 0x556a80
00556A37 mov eax, dword ptr [ebp - 0x2c]
00556A3A mov esp, ebp
00556A3C pop ebp
00556A3D ret 4

; FUNCTION 004822D0
004822D0 push ebp
004822D1 mov ebp, esp
004822D3 push ecx
004822D4 mov dword ptr [ebp - 4], ecx
004822D7 mov ecx, dword ptr [ebp - 4]
004822DA call 0x483230
004822DF mov esp, ebp
004822E1 pop ebp
004822E2 ret

; FUNCTION 00A2A7D0
00A2A7D0 push ebp
00A2A7D1 mov ebp, esp
00A2A7D3 push -1
00A2A7D5 push 0xaca18c
00A2A7DA mov eax, dword ptr fs:[0]
00A2A7E0 push eax
00A2A7E1 sub esp, 0x30
00A2A7E4 push esi
00A2A7E5 mov eax, dword ptr [0xc7b480]
00A2A7EA xor eax, ebp
00A2A7EC push eax
00A2A7ED lea eax, [ebp - 0xc]
00A2A7F0 mov dword ptr fs:[0], eax
00A2A7F6 mov dword ptr [ebp - 0x3c], ecx
00A2A7F9 cmp dword ptr [ebp + 8], 0
00A2A7FD jne 0xa2a804
00A2A7FF jmp 0xa2a8a5
00A2A804 lea ecx, [ebp - 0x34]
00A2A807 call 0x406590
00A2A80C mov dword ptr [ebp - 4], 0
00A2A813 lea ecx, [ebp - 0x34]
00A2A816 call 0x41ce40
00A2A81B mov eax, dword ptr [ebp + 0xc]
00A2A81E xor edx, edx
00A2A820 mov ecx, 0x18
00A2A825 div ecx
00A2A827 mov dword ptr [ebp - 0x10], eax
00A2A82A mov edx, dword ptr [ebp + 8]
00A2A82D mov dword ptr [ebp - 0x14], edx
00A2A830 mov dword ptr [ebp - 0x38], 0
00A2A837 jmp 0xa2a842
00A2A839 mov eax, dword ptr [ebp - 0x38]
00A2A83C add eax, 1
00A2A83F mov dword ptr [ebp - 0x38], eax
00A2A842 mov ecx, dword ptr [ebp - 0x38]
00A2A845 cmp ecx, dword ptr [ebp - 0x10]
00A2A848 jge 0xa2a886
00A2A84A mov esi, dword ptr [ebp - 0x14]
00A2A84D mov edx, dword ptr [ebp - 0x14]
00A2A850 push edx
00A2A851 lea ecx, [ebp - 0x34]
00A2A854 call 0x41cd20
00A2A859 mov ecx, dword ptr [esi]
00A2A85B mov dword ptr [eax], ecx
00A2A85D mov edx, dword ptr [esi + 4]
00A2A860 mov dword ptr [eax + 4], edx
00A2A863 mov ecx, dword ptr [esi + 8]
00A2A866 mov dword ptr [eax + 8], ecx
00A2A869 mov edx, dword ptr [esi + 0xc]
00A2A86C mov dword ptr [eax + 0xc], edx
00A2A86F mov ecx, dword ptr [esi + 0x10]
00A2A872 mov dword ptr [eax + 0x10], ecx
00A2A875 mov edx, dword ptr [esi + 0x14]
00A2A878 mov dword ptr [eax + 0x14], edx
00A2A87B mov eax, dword ptr [ebp - 0x14]
00A2A87E add eax, 0x18
00A2A881 mov dword ptr [ebp - 0x14], eax
00A2A884 jmp 0xa2a839
00A2A886 lea ecx, [ebp - 0x34]
00A2A889 push ecx
00A2A88A call 0x41cd00
00A2A88F mov ecx, eax
00A2A891 call 0x7f58a0
00A2A896 mov dword ptr [ebp - 4], 0xffffffff
00A2A89D lea ecx, [ebp - 0x34]
00A2A8A0 call 0x41c760
00A2A8A5 mov ecx, dword ptr [ebp - 0xc]
00A2A8A8 mov dword ptr fs:[0], ecx
00A2A8AF pop ecx
00A2A8B0 pop esi
00A2A8B1 mov esp, ebp
00A2A8B3 pop ebp
00A2A8B4 ret 8

; FUNCTION 00483230
00483230 push ebp
00483231 mov ebp, esp
00483233 push ecx
00483234 mov dword ptr [ebp - 4], ecx
00483237 mov ecx, dword ptr [ebp - 4]
0048323A call 0x4012b0
0048323F movzx eax, al
00483242 test eax, eax
00483244 jne 0x48324b
00483246 call 0x666943
0048324B xor ecx, ecx
0048324D jne 0x48324b
0048324F mov ecx, dword ptr [ebp - 4]
00483252 call 0x401280
00483257 mov edx, dword ptr [ebp - 4]
0048325A mov ecx, dword ptr [edx + 4]
0048325D cmp ecx, dword ptr [eax + 0x18]
00483260 jne 0x483267
00483262 call 0x666943
00483267 xor edx, edx
00483269 jne 0x483267
0048326B mov eax, dword ptr [ebp - 4]
0048326E mov ecx, dword ptr [eax + 4]
00483271 push ecx
00483272 call 0x57ceb0
00483277 add esp, 4
0048327A mov esp, ebp
0048327C pop ebp
0048327D ret

; FUNCTION 0041CD20
0041CD20 push ebp
0041CD21 mov ebp, esp
0041CD23 sub esp, 0x58
0041CD26 mov dword ptr [ebp - 0x58], ecx
0041CD29 mov eax, dword ptr [ebp + 8]
0041CD2C push eax
0041CD2D lea ecx, [ebp - 8]
0041CD30 push ecx
0041CD31 mov ecx, dword ptr [ebp - 0x58]
0041CD34 call 0x41e3f0
0041CD39 lea edx, [ebp - 0x10]
0041CD3C push edx
0041CD3D mov ecx, dword ptr [ebp - 0x58]
0041CD40 call 0x45abb0
0041CD45 push eax
0041CD46 lea ecx, [ebp - 8]
0041CD49 call 0x4ab920
0041CD4E movzx eax, al
0041CD51 test eax, eax
0041CD53 jne 0x41cd7d
0041CD55 lea ecx, [ebp - 8]
0041CD58 call 0x4b4f50
0041CD5D push eax
0041CD5E call 0x4cecc0
0041CD63 add esp, 4
0041CD66 push eax
0041CD67 mov ecx, dword ptr [ebp + 8]
0041CD6A push ecx
0041CD6B mov ecx, dword ptr [ebp - 0x58]
0041CD6E add ecx, 8
0041CD71 call 0x4c5f20
0041CD76 movzx edx, al
0041CD79 test edx, edx
0041CD7B je 0x41cdcd
0041CD7D xor eax, eax
0041CD7F mov dword ptr [ebp - 0x44], eax
0041CD82 mov dword ptr [ebp - 0x40], eax
0041CD85 mov dword ptr [ebp - 0x3c], eax
0041CD88 mov dword ptr [ebp - 0x38], eax
0041CD8B mov dword ptr [ebp - 0x34], eax
0041CD8E mov dword ptr [ebp - 0x30], eax
0041CD91 mov ecx, dword ptr [ebp - 8]
0041CD94 mov dword ptr [ebp - 0x4c], ecx
0041CD97 mov edx, dword ptr [ebp - 4]
0041CD9A mov dword ptr [ebp - 0x48], edx
0041CD9D lea eax, [ebp - 0x44]
0041CDA0 push eax
0041CDA1 mov ecx, dword ptr [ebp + 8]
0041CDA4 push ecx
0041CDA5 lea ecx, [ebp - 0x2c]
0041CDA8 call 0x41e6c0
0041CDAD push eax
0041CDAE mov edx, dword ptr [ebp - 0x48]
0041CDB1 push edx
0041CDB2 mov eax, dword ptr [ebp - 0x4c]
0041CDB5 push eax
0041CDB6 lea ecx, [ebp - 0x54]
0041CDB9 push ecx
0041CDBA mov ecx, dword ptr [ebp - 0x58]
0041CDBD call 0x41ddd0
0041CDC2 mov edx, dword ptr [eax]
0041CDC4 mov eax, dword ptr [eax + 4]
0041CDC7 mov dword ptr [ebp - 8], edx
0041CDCA mov dword ptr [ebp - 4], eax
0041CDCD lea ecx, [ebp - 8]
0041CDD0 call 0x4822d0
0041CDD5 add eax, 4
0041CDD8 mov esp, ebp
0041CDDA pop ebp
0041CDDB ret 4
