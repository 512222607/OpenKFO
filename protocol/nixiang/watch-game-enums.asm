; Source SHA256: 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; Enum names only: this does not establish payload layout or functioning spectator mode.
007A2839  fld qword ptr [0xbe9710]
007A283F  fstp qword ptr [esp]
007A2842  push 0xbe0a34
007A2847  mov eax, dword ptr [ebp + 8]
007A284A  push eax
007A284B  call 0x6ad580
007A2850  add esp, 8
007A2853  fld qword ptr [0xbe9708]
007A2859  fstp qword ptr [esp]
007A285C  push 0xbe0a48
007A2861  mov ecx, dword ptr [ebp + 8]
007A2864  push ecx
007A2865  call 0x6ad580
00BE9710 double bytes: 0000000000fea740
00BE9708 double bytes: 000000000000a840
