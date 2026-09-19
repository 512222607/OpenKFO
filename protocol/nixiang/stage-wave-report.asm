; Read-only gfld.dat SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; BADCD0 string notify_wave_end; binding B9A370: name BADCD0, function 93D860
; function 0x93d860
0093D860 push ebp
0093D861 mov ebp, esp
0093D863 sub esp, 8
0093D866 mov eax, dword ptr [ebp + 8]
0093D869 push eax
0093D86A call 0x68bb90
0093D86F add esp, 4
0093D872 cmp eax, 1
0093D875 jne 0x93d889
0093D877 push 1
0093D879 mov ecx, dword ptr [ebp + 8]
0093D87C push ecx
0093D87D call 0x68c0c0
0093D882 add esp, 8
0093D885 test eax, eax
0093D887 jne 0x93d88d
0093D889 xor eax, eax
0093D88B jmp 0x93d907
0093D88D mov ecx, dword ptr [0x17c8710]
0093D893 call 0x453db0
0093D898 test eax, eax
0093D89A jne 0x93d8a0
0093D89C xor eax, eax
0093D89E jmp 0x93d907
0093D8A0 mov ecx, dword ptr [0x17c8708]
0093D8A6 call 0x4535c0
0093D8AB cmp eax, 0x15
0093D8AE je 0x93d8b4
0093D8B0 xor eax, eax
0093D8B2 jmp 0x93d907
0093D8B4 push 0
0093D8B6 push 0x12f90d0
0093D8BB push 0x12f899c
0093D8C0 mov ecx, dword ptr [0x17c8710]
0093D8C6 call 0x453db0
0093D8CB push 0
0093D8CD push eax
0093D8CE call 0xa97b0e
0093D8D3 add esp, 0x14
0093D8D6 mov dword ptr [ebp - 8], eax
0093D8D9 cmp dword ptr [ebp - 8], 0
0093D8DD jne 0x93d8e3
0093D8DF xor eax, eax
0093D8E1 jmp 0x93d907
0093D8E3 push 1
0093D8E5 mov edx, dword ptr [ebp + 8]
0093D8E8 push edx
0093D8E9 call 0x68c320
0093D8EE add esp, 8
0093D8F1 call 0x66e430
0093D8F6 mov dword ptr [ebp - 4], eax
0093D8F9 mov eax, dword ptr [ebp - 4]
0093D8FC push eax
0093D8FD mov ecx, dword ptr [ebp - 8]
0093D900 call 0x938c70
0093D905 xor eax, eax
0093D907 mov esp, ebp
0093D909 pop ebp
0093D90A ret
; function 0x938c70
00938C70 push ebp
00938C71 mov ebp, esp
00938C73 sub esp, 0x2c
00938C76 mov dword ptr [ebp - 0x2c], ecx
00938C79 push 0x28
00938C7B push 0
00938C7D lea eax, [ebp - 0x28]
00938C80 push eax
00938C81 call 0x666960
00938C86 add esp, 0xc
00938C89 mov ecx, dword ptr [0x17c8708]
00938C8F call 0x432440
00938C94 mov ecx, dword ptr [eax]
00938C96 mov edx, dword ptr [eax + 4]
00938C99 mov dword ptr [ebp - 0x28], ecx
00938C9C mov dword ptr [ebp - 0x24], edx
00938C9F mov eax, dword ptr [ebp + 8]
00938CA2 mov dword ptr [ebp - 0x20], eax
00938CA5 mov dword ptr [ebp - 0x1c], 1
00938CAC push 0x28
00938CAE lea ecx, [ebp - 0x28]
00938CB1 push ecx
00938CB2 push 0
00938CB4 push 0x505b
00938CB9 call 0xa3c950
00938CBE add esp, 0x10
00938CC1 mov esp, ebp
00938CC3 pop ebp
00938CC4 ret 4
