; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 0xa54390
00A54390 push ebp
00A54391 mov ebp, esp
00A54393 push -1
00A54395 push 0xa9d5b7
00A5439A mov eax, dword ptr fs:[0]
00A543A0 push eax
00A543A1 sub esp, 0x78
00A543A4 mov eax, dword ptr [0xc7b480]
00A543A9 xor eax, ebp
00A543AB push eax
00A543AC lea eax, [ebp - 0xc]
00A543AF mov dword ptr fs:[0], eax
00A543B5 mov dword ptr [ebp - 0x3c], ecx
00A543B8 mov dword ptr [ebp - 4], 0
00A543BF lea ecx, [ebp + 8]
00A543C2 call 0x4012b0
00A543C7 movzx eax, al
00A543CA test eax, eax
00A543CC jne 0xa543e9
00A543CE mov byte ptr [ebp - 0xd], 0
00A543D2 mov dword ptr [ebp - 4], 0xffffffff
00A543D9 lea ecx, [ebp + 8]
00A543DC call 0x416d30
00A543E1 mov al, byte ptr [ebp - 0xd]
00A543E4 jmp 0xa54599
00A543E9 push 0
00A543EB push 0xba46d8
00A543F0 push ecx
00A543F1 mov ecx, esp
00A543F3 mov dword ptr [ebp - 0x14], esp
00A543F6 lea edx, [ebp + 8]
00A543F9 push edx
00A543FA call 0x4199e0
00A543FF mov dword ptr [ebp - 0x40], eax
00A54402 call 0xa5e240
00A54407 add esp, 0xc
00A5440A mov dword ptr [ebp - 0x44], eax
00A5440D mov eax, dword ptr [ebp - 0x3c]
00A54410 mov ecx, dword ptr [ebp - 0x44]
00A54413 mov dword ptr [eax], ecx
00A54415 push 0
00A54417 push 0xba43a8
00A5441C push ecx
00A5441D mov ecx, esp
00A5441F mov dword ptr [ebp - 0x18], esp
00A54422 lea edx, [ebp + 8]
00A54425 push edx
00A54426 call 0x4199e0
00A5442B mov dword ptr [ebp - 0x48], eax
00A5442E call 0xa5e240
00A54433 add esp, 0xc
00A54436 mov dword ptr [ebp - 0x4c], eax
00A54439 mov eax, dword ptr [ebp - 0x3c]
00A5443C mov ecx, dword ptr [ebp - 0x4c]
00A5443F mov dword ptr [eax + 4], ecx
00A54442 push 0
00A54444 push 0xba46e4
00A54449 push ecx
00A5444A mov ecx, esp
00A5444C mov dword ptr [ebp - 0x1c], esp
00A5444F lea edx, [ebp + 8]
00A54452 push edx
00A54453 call 0x4199e0
00A54458 mov dword ptr [ebp - 0x50], eax
00A5445B call 0xa5e240
00A54460 add esp, 0xc
00A54463 mov dword ptr [ebp - 0x54], eax
00A54466 mov eax, dword ptr [ebp - 0x3c]
00A54469 mov ecx, dword ptr [ebp - 0x54]
00A5446C mov dword ptr [eax + 8], ecx
00A5446F push 0
00A54471 push 0xba46f8
00A54476 push ecx
00A54477 mov ecx, esp
00A54479 mov dword ptr [ebp - 0x20], esp
00A5447C lea edx, [ebp + 8]
00A5447F push edx
00A54480 call 0x4199e0
00A54485 mov dword ptr [ebp - 0x58], eax
00A54488 call 0xa5e240
00A5448D add esp, 0xc
00A54490 mov dword ptr [ebp - 0x5c], eax
00A54493 mov eax, dword ptr [ebp - 0x3c]
00A54496 mov ecx, dword ptr [ebp - 0x5c]
00A54499 mov dword ptr [eax + 0xc], ecx
00A5449C push 0
00A5449E push 0xba4270
00A544A3 push ecx
00A544A4 mov ecx, esp
00A544A6 mov dword ptr [ebp - 0x24], esp
00A544A9 lea edx, [ebp + 8]
00A544AC push edx
00A544AD call 0x4199e0
00A544B2 mov dword ptr [ebp - 0x60], eax
00A544B5 call 0xa5e240
00A544BA add esp, 0xc
00A544BD mov dword ptr [ebp - 0x64], eax
00A544C0 mov eax, dword ptr [ebp - 0x3c]
00A544C3 mov ecx, dword ptr [ebp - 0x64]
00A544C6 mov dword ptr [eax + 0x10], ecx
00A544C9 push 0
00A544CB push 0xba4700
00A544D0 push ecx
00A544D1 mov ecx, esp
00A544D3 mov dword ptr [ebp - 0x28], esp
00A544D6 lea edx, [ebp + 8]
00A544D9 push edx
00A544DA call 0x4199e0
00A544DF mov dword ptr [ebp - 0x68], eax
00A544E2 call 0xa5e240
00A544E7 add esp, 0xc
00A544EA mov dword ptr [ebp - 0x6c], eax
00A544ED mov eax, dword ptr [ebp - 0x3c]
00A544F0 mov ecx, dword ptr [ebp - 0x6c]
00A544F3 mov dword ptr [eax + 0x14], ecx
00A544F6 push 0
00A544F8 push 0xba4714
00A544FD push ecx
00A544FE mov ecx, esp
00A54500 mov dword ptr [ebp - 0x2c], esp
00A54503 lea edx, [ebp + 8]
00A54506 push edx
00A54507 call 0x4199e0
00A5450C mov dword ptr [ebp - 0x70], eax
00A5450F call 0xa5e240
00A54514 add esp, 0xc
00A54517 mov dword ptr [ebp - 0x74], eax
00A5451A mov eax, dword ptr [ebp - 0x3c]
00A5451D mov ecx, dword ptr [ebp - 0x74]
00A54520 mov dword ptr [eax + 0x18], ecx
00A54523 push 0
00A54525 push 0xba4720
00A5452A push ecx
00A5452B mov ecx, esp
00A5452D mov dword ptr [ebp - 0x30], esp
00A54530 lea edx, [ebp + 8]
00A54533 push edx
00A54534 call 0x4199e0
00A54539 mov dword ptr [ebp - 0x78], eax
00A5453C call 0xa5e240
00A54541 add esp, 0xc
00A54544 mov dword ptr [ebp - 0x7c], eax
00A54547 mov eax, dword ptr [ebp - 0x3c]
00A5454A mov ecx, dword ptr [ebp - 0x7c]
00A5454D mov dword ptr [eax + 0x1c], ecx
00A54550 push 0
00A54552 push 0xba472c
00A54557 push ecx
00A54558 mov ecx, esp
00A5455A mov dword ptr [ebp - 0x34], esp
00A5455D lea edx, [ebp + 8]
00A54560 push edx
00A54561 call 0x4199e0
00A54566 mov dword ptr [ebp - 0x80], eax
00A54569 call 0xa5e240
00A5456E add esp, 0xc
00A54571 mov dword ptr [ebp - 0x84], eax
00A54577 mov eax, dword ptr [ebp - 0x3c]
00A5457A mov ecx, dword ptr [ebp - 0x84]
00A54580 mov dword ptr [eax + 0x20], ecx
00A54583 mov byte ptr [ebp - 0x35], 1
00A54587 mov dword ptr [ebp - 4], 0xffffffff
00A5458E lea ecx, [ebp + 8]
00A54591 call 0x416d30
00A54596 mov al, byte ptr [ebp - 0x35]
00A54599 mov ecx, dword ptr [ebp - 0xc]
00A5459C mov dword ptr fs:[0], ecx
00A545A3 pop ecx
00A545A4 mov esp, ebp
00A545A6 pop ebp
00A545A7 ret 4
; STRING 00BA46D8 LogicType
; STRING 00BA43A8 Group
; STRING 00BA46E4 SelectDifficulty
; STRING 00BA46F8 MapID
; STRING 00BA4270 MapType
; STRING 00BA4700 DisplayDifficulty
; STRING 00BA4714 RewardItem1
; STRING 00BA4720 RewardItem2
; STRING 00BA472C RewardItem3
