; Read-only native evidence. SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; Function 0x9884d0
009884D0 push     ebp
009884D1 mov      ebp, esp
009884D3 sub      esp, 0x2c
009884D6 push     esi
009884D7 mov      dword ptr [ebp - 0x14], ecx
009884DA push     0x14e
009884DF push     0
009884E1 push     0x1ddb9e0
009884E6 call     0x666960
009884EB add      esp, 0xc
009884EE mov      ecx, dword ptr [ebp - 0x14]
009884F1 call     0x453b80
009884F6 test     eax, eax
009884F8 je       0x9884ff
009884FA jmp      0x98870f
009884FF mov      ecx, dword ptr [ebp - 0x14]
00988502 call     0x453db0
00988507 mov      dword ptr [ebp - 0x18], eax
0098850A mov      eax, dword ptr [ebp - 0x18]
0098850D mov      edx, dword ptr [eax]
0098850F mov      ecx, dword ptr [ebp - 0x18]
00988512 mov      eax, dword ptr [edx + 0x98]
00988518 call     eax
0098851A mov      dword ptr [ebp - 8], eax
0098851D cmp      dword ptr [ebp - 8], 0
00988521 je       0x988536
00988523 push     7
00988525 mov      ecx, dword ptr [ebp - 8]
00988528 push     ecx
00988529 push     0x1ddba07
0098852E call     0x6636a0
00988533 add      esp, 0xc
00988536 mov      ecx, dword ptr [ebp - 0x14]
00988539 call     0x453db0
0098853E mov      dword ptr [ebp - 0x1c], eax
00988541 mov      edx, dword ptr [ebp - 0x1c]
00988544 mov      eax, dword ptr [edx]
00988546 mov      ecx, dword ptr [ebp - 0x1c]
00988549 mov      edx, dword ptr [eax + 0x98]
0098854F call     edx
00988551 mov      dword ptr [ebp - 4], eax
00988554 mov      dword ptr [ebp - 0xc], 0
0098855B jmp      0x988566
0098855D mov      eax, dword ptr [ebp - 0xc]
00988560 add      eax, 1
00988563 mov      dword ptr [ebp - 0xc], eax
00988566 cmp      dword ptr [ebp - 0xc], 8
0098856A jae      0x9886e5
00988570 mov      ecx, dword ptr [ebp - 0xc]
00988573 push     ecx
00988574 mov      ecx, dword ptr [0x17c8708]
0098857A call     0x818450
0098857F mov      dword ptr [ebp - 0x10], eax
00988582 cmp      dword ptr [ebp - 0x10], 0
00988586 je       0x9886e0
0098858C mov      ecx, dword ptr [ebp - 0x10]
0098858F call     0x401000
00988594 mov      ecx, dword ptr [ebp - 0xc]
00988597 imul     ecx, ecx, 0x24
0098859A mov      dword ptr [ecx + 0x1ddba0e], eax
009885A0 mov      dword ptr [ecx + 0x1ddba12], edx
009885A6 mov      ecx, dword ptr [ebp - 0x10]
009885A9 call     0x9e3c70
009885AE mov      edx, dword ptr [ebp - 0xc]
009885B1 imul     edx, edx, 0x24
009885B4 mov      dword ptr [edx + 0x1ddba1a], eax
009885BA mov      ecx, dword ptr [ebp - 0x10]
009885BD call     0x9e3cd0
009885C2 mov      ecx, dword ptr [ebp - 0xc]
009885C5 imul     ecx, ecx, 0x24
009885C8 mov      dword ptr [ecx + 0x1ddba16], eax
009885CE cmp      dword ptr [ebp - 4], 0
009885D2 je       0x9886e0
009885D8 mov      ecx, dword ptr [ebp - 0x10]
009885DB call     0x401000
009885E0 mov      ecx, dword ptr [ebp - 0xc]
009885E3 imul     ecx, ecx, 0x24
009885E6 mov      esi, dword ptr [ebp - 4]
009885E9 mov      dword ptr [ebp - 0x24], eax
009885EC mov      dword ptr [ebp - 0x20], edx
009885EF mov      dword ptr [ebp - 0x28], esi
009885F2 mov      dword ptr [ebp - 0x2c], ecx
009885F5 mov      edx, dword ptr [ebp - 0x2c]
009885F8 mov      eax, dword ptr [ebp - 0x28]
009885FB mov      ecx, dword ptr [ebp - 0x24]
009885FE cmp      ecx, dword ptr [eax + edx]
00988601 jne      0x9886e0
00988607 mov      edx, dword ptr [ebp - 0x2c]
0098860A mov      eax, dword ptr [ebp - 0x28]
0098860D mov      ecx, dword ptr [ebp - 0x20]
00988610 cmp      ecx, dword ptr [eax + edx + 4]
00988614 jne      0x9886e0
0098861A mov      ecx, dword ptr [ebp - 0x10]
0098861D call     0x9e3cd0
00988622 mov      edx, dword ptr [ebp - 0xc]
00988625 imul     edx, edx, 0x24
00988628 mov      ecx, dword ptr [ebp - 4]
0098862B mov      dword ptr [ecx + edx + 8], eax
0098862F mov      ecx, dword ptr [ebp - 0x10]
00988632 call     0x9e3c70
00988637 mov      edx, dword ptr [ebp - 0xc]
0098863A imul     edx, edx, 0x24
0098863D mov      ecx, dword ptr [ebp - 4]
00988640 mov      dword ptr [ecx + edx + 0xc], eax
00988644 mov      edx, dword ptr [ebp - 0xc]
00988647 imul     edx, edx, 0x24
0098864A mov      eax, dword ptr [ebp - 0xc]
0098864D imul     eax, eax, 0x24
00988650 mov      ecx, dword ptr [ebp - 4]
00988653 mov      dx, word ptr [ecx + edx + 0x12]
00988658 mov      word ptr [eax + 0x1ddba20], dx
0098865F mov      eax, dword ptr [ebp - 0xc]
00988662 imul     eax, eax, 0x24
00988665 mov      ecx, dword ptr [ebp - 0xc]
00988668 imul     ecx, ecx, 0x24
0098866B mov      edx, dword ptr [ebp - 4]
0098866E mov      ax, word ptr [edx + eax + 0x10]
00988673 mov      word ptr [ecx + 0x1ddba1e], ax
0098867A mov      ecx, dword ptr [ebp - 0xc]
0098867D imul     ecx, ecx, 0x24
00988680 mov      edx, dword ptr [ebp - 0xc]
00988683 imul     edx, edx, 0x24
00988686 mov      eax, dword ptr [ebp - 4]
00988689 mov      ecx, dword ptr [eax + ecx + 0x14]
0098868D mov      dword ptr [edx + 0x1ddba22], ecx
00988693 mov      edx, dword ptr [ebp - 0xc]
00988696 imul     edx, edx, 0x24
00988699 mov      eax, dword ptr [ebp - 0xc]
0098869C imul     eax, eax, 0x24
0098869F mov      ecx, dword ptr [ebp - 4]
009886A2 mov      edx, dword ptr [ecx + edx + 0x18]
009886A6 mov      dword ptr [eax + 0x1ddba26], edx
009886AC mov      eax, dword ptr [ebp - 0xc]
009886AF imul     eax, eax, 0x24
009886B2 mov      ecx, dword ptr [ebp - 0xc]
009886B5 imul     ecx, ecx, 0x24
009886B8 mov      edx, dword ptr [ebp - 4]
009886BB mov      eax, dword ptr [edx + eax + 0x1c]
009886BF mov      dword ptr [ecx + 0x1ddba2a], eax
009886C5 mov      ecx, dword ptr [ebp - 0xc]
009886C8 imul     ecx, ecx, 0x24
009886CB mov      edx, dword ptr [ebp - 0xc]
009886CE imul     edx, edx, 0x24
009886D1 mov      eax, dword ptr [ebp - 4]
009886D4 mov      cx, word ptr [eax + ecx + 0x20]
009886D9 mov      word ptr [edx + 0x1ddba2e], cx
009886E0 jmp      0x98855d
009886E5 push     0
009886E7 push     0
009886E9 push     0x14e
009886EE push     0x1ddb9e0
009886F3 push     0x1fdb
009886F8 call     0xa3fbb0
009886FD add      esp, 0x14
00988700 call     dword ptr [0xb33048]
00988706 mov      edx, dword ptr [ebp - 0x14]
00988709 mov      dword ptr [edx + 0x274], eax
0098870F pop      esi
00988710 mov      esp, ebp
00988712 pop      ebp
00988713 ret

; Function 0x82c1d0
0082C1D0 push     ebp
0082C1D1 mov      ebp, esp
0082C1D3 sub      esp, 0x148
0082C1D9 mov      dword ptr [ebp - 0x13c], ecx
0082C1DF push     0x10
0082C1E1 mov      ecx, dword ptr [0x17c8708]
0082C1E7 call     0x4c11c0
0082C1EC movzx    eax, al
0082C1EF test     eax, eax
0082C1F1 je       0x82c202
0082C1F3 cmp      dword ptr [ebp + 8], 0
0082C1F7 je       0x82c202
0082C1F9 cmp      dword ptr [ebp + 0xc], 0x14e
0082C200 jae      0x82c207
0082C202 jmp      0x82c42e
0082C207 mov      ecx, dword ptr [ebp + 8]
0082C20A mov      dword ptr [ebp - 0x12c], ecx
0082C210 mov      ecx, dword ptr [0x17c8710]
0082C216 call     0x453db0
0082C21B mov      dword ptr [ebp - 0x140], eax
0082C221 mov      edx, dword ptr [ebp - 0x140]
0082C227 mov      eax, dword ptr [edx]
0082C229 mov      ecx, dword ptr [ebp - 0x140]
0082C22F mov      edx, dword ptr [eax + 0x98]
0082C235 call     edx
0082C237 mov      dword ptr [ebp - 0x128], eax
0082C23D cmp      dword ptr [ebp - 0x128], 0
0082C244 je       0x82c261
0082C246 push     7
0082C248 mov      eax, dword ptr [ebp - 0x12c]
0082C24E add      eax, 0x27
0082C251 push     eax
0082C252 mov      ecx, dword ptr [ebp - 0x128]
0082C258 push     ecx
0082C259 call     0x6636a0
0082C25E add      esp, 0xc
0082C261 push     0x120
0082C266 push     0
0082C268 lea      edx, [ebp - 0x120]
0082C26E push     edx
0082C26F call     0x666960
0082C274 add      esp, 0xc
0082C277 mov      ecx, dword ptr [0x17c8710]
0082C27D call     0x453db0
0082C282 mov      dword ptr [ebp - 0x144], eax
0082C288 mov      eax, dword ptr [ebp - 0x144]
0082C28E mov      edx, dword ptr [eax]
0082C290 mov      ecx, dword ptr [ebp - 0x144]
0082C296 mov      eax, dword ptr [edx + 0x98]
0082C29C call     eax
0082C29E mov      dword ptr [ebp - 0x124], eax
0082C2A4 cmp      dword ptr [ebp - 0x124], 0
0082C2AB je       0x82c42e
0082C2B1 mov      dword ptr [ebp - 0x130], 0
0082C2BB mov      dword ptr [ebp - 0x134], 0
0082C2C5 jmp      0x82c2d6
0082C2C7 mov      ecx, dword ptr [ebp - 0x134]
0082C2CD add      ecx, 1
0082C2D0 mov      dword ptr [ebp - 0x134], ecx
0082C2D6 cmp      dword ptr [ebp - 0x134], 8
0082C2DD jae      0x82c3fb
0082C2E3 mov      edx, dword ptr [ebp - 0x134]
0082C2E9 imul     edx, edx, 0x24
0082C2EC mov      eax, dword ptr [ebp - 0x12c]
0082C2F2 mov      ecx, dword ptr [eax + edx + 0x32]
0082C2F6 push     ecx
0082C2F7 mov      edx, dword ptr [eax + edx + 0x2e]
0082C2FB push     edx
0082C2FC mov      ecx, dword ptr [0x17c8708]
0082C302 call     0x818c70
0082C307 mov      dword ptr [ebp - 0x138], eax
0082C30D cmp      dword ptr [ebp - 0x138], 0
0082C314 je       0x82c3f6
0082C31A mov      eax, dword ptr [ebp - 0x134]
0082C320 imul     eax, eax, 0x24
0082C323 mov      ecx, dword ptr [ebp - 0x12c]
0082C329 mov      edx, dword ptr [ecx + eax + 0x3a]
0082C32D push     edx
0082C32E mov      ecx, dword ptr [ebp - 0x138]
0082C334 call     0x9e3c90
0082C339 mov      eax, dword ptr [ebp - 0x134]
0082C33F imul     eax, eax, 0x24
0082C342 mov      ecx, dword ptr [ebp - 0x12c]
0082C348 mov      edx, dword ptr [ecx + eax + 0x36]
0082C34C push     edx
0082C34D mov      ecx, dword ptr [ebp - 0x138]
0082C353 call     0x9e3cb0
0082C358 mov      eax, dword ptr [ebp - 0x134]
0082C35E imul     eax, eax, 0x24
0082C361 mov      ecx, dword ptr [ebp - 0x124]
0082C367 movzx    edx, word ptr [ecx + eax + 0x20]
0082C36C mov      dword ptr [ebp - 0x130], edx
0082C372 push     0x24
0082C374 mov      eax, dword ptr [ebp - 0x134]
0082C37A imul     eax, eax, 0x24
0082C37D mov      ecx, dword ptr [ebp - 0x12c]
0082C383 lea      edx, [ecx + eax + 0x2e]
0082C387 push     edx
0082C388 mov      eax, dword ptr [ebp - 0x134]
0082C38E imul     eax, eax, 0x24
0082C391 lea      ecx, [ebp + eax - 0x120]
0082C398 push     ecx
0082C399 call     0x6636a0
0082C39E add      esp, 0xc
0082C3A1 mov      edx, dword ptr [ebp - 0x134]
0082C3A7 imul     edx, edx, 0x24
0082C3AA mov      eax, dword ptr [ebp - 0x12c]
0082C3B0 movzx    ecx, word ptr [eax + edx + 0x4e]
0082C3B5 cmp      dword ptr [ebp - 0x130], ecx
0082C3BB jae      0x82c3f6
0082C3BD mov      ecx, dword ptr [ebp - 0x138]
0082C3C3 call     0x44e110
0082C3C8 movzx    edx, al
0082C3CB test     edx, edx
0082C3CD jne      0x82c3f6
0082C3CF mov      eax, dword ptr [ebp - 0x134]
0082C3D5 imul     eax, eax, 0x24
0082C3D8 mov      ecx, dword ptr [ebp - 0x12c]
0082C3DE movzx    edx, word ptr [ecx + eax + 0x4e]
0082C3E3 push     edx
0082C3E4 mov      eax, dword ptr [ebp - 0x138]
0082C3EA push     eax
0082C3EB mov      ecx, dword ptr [0x17c8710]
0082C3F1 call     0x98ae80
0082C3F6 jmp      0x82c2c7
0082C3FB mov      ecx, dword ptr [0x17c8710]
0082C401 call     0x453db0
0082C406 mov      dword ptr [ebp - 0x148], eax
0082C40C push     0x120
0082C411 lea      ecx, [ebp - 0x120]
0082C417 push     ecx
0082C418 mov      edx, dword ptr [ebp - 0x148]
0082C41E mov      eax, dword ptr [edx]
0082C420 mov      ecx, dword ptr [ebp - 0x148]
0082C426 mov      edx, dword ptr [eax + 0x94]
0082C42C call     edx
0082C42E mov      esp, ebp
0082C430 pop      ebp
0082C431 ret      8
