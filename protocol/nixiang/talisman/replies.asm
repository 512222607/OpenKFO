; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 0x826870
00826870 push ebp
00826871 mov ebp, esp
00826873 sub esp, 0xc
00826876 mov dword ptr [ebp - 8], ecx
00826879 mov eax, dword ptr [ebp + 8]
0082687C mov dword ptr [ebp - 4], eax
0082687F call 0x5490e0
00826884 mov dword ptr [ebp - 0xc], eax
00826887 mov ecx, dword ptr [ebp - 0xc]
0082688A mov edx, dword ptr [ecx]
0082688C mov ecx, dword ptr [ebp - 0xc]
0082688F mov eax, dword ptr [edx + 0x108]
00826895 call eax
00826897 mov ecx, dword ptr [ebp - 4]
0082689A push ecx
0082689B call 0x5490e0
008268A0 mov ecx, eax
008268A2 call 0x874600
008268A7 mov esp, ebp
008268A9 pop ebp
008268AA ret 8
; FUNCTION 0x826450
00826450 push ebp
00826451 mov ebp, esp
00826453 push -1
00826455 push 0xabfcc1
0082645A mov eax, dword ptr fs:[0]
00826460 push eax
00826461 sub esp, 0x48
00826464 mov eax, dword ptr [0xc7b480]
00826469 xor eax, ebp
0082646B push eax
0082646C lea eax, [ebp - 0xc]
0082646F mov dword ptr fs:[0], eax
00826475 mov dword ptr [ebp - 0x4c], ecx
00826478 mov eax, dword ptr [ebp + 8]
0082647B mov dword ptr [ebp - 0x10], eax
0082647E mov ecx, dword ptr [ebp - 0x10]
00826481 cmp dword ptr [ecx + 4], 0
00826485 je 0x8264d8
00826487 mov edx, dword ptr [ebp - 0x10]
0082648A mov eax, dword ptr [edx + 4]
0082648D imul eax, eax, 0x68
00826490 add eax, 0xdcf0d4
00826495 push eax
00826496 lea ecx, [ebp - 0x2c]
00826499 call 0x405650
0082649E mov dword ptr [ebp - 4], 0
008264A5 call 0x403820
008264AA mov dword ptr [ebp - 0x50], eax
008264AD push 0
008264AF push 0
008264B1 push 0
008264B3 lea ecx, [ebp - 0x2c]
008264B6 push ecx
008264B7 mov edx, dword ptr [ebp - 0x50]
008264BA mov eax, dword ptr [edx]
008264BC mov ecx, dword ptr [ebp - 0x50]
008264BF mov edx, dword ptr [eax + 0x1c0]
008264C5 call edx
008264C7 mov dword ptr [ebp - 4], 0xffffffff
008264CE lea ecx, [ebp - 0x2c]
008264D1 call 0x4056d0
008264D6 jmp 0x82652a
008264D8 push 0xbcaed4
008264DD lea ecx, [ebp - 0x48]
008264E0 call 0x405650
008264E5 mov dword ptr [ebp - 4], 1
008264EC call 0x403820
008264F1 mov dword ptr [ebp - 0x54], eax
008264F4 push 0
008264F6 push 0
008264F8 push 0
008264FA lea eax, [ebp - 0x48]
008264FD push eax
008264FE mov ecx, dword ptr [ebp - 0x54]
00826501 mov edx, dword ptr [ecx]
00826503 mov ecx, dword ptr [ebp - 0x54]
00826506 mov eax, dword ptr [edx + 0x1c0]
0082650C call eax
0082650E mov dword ptr [ebp - 4], 0xffffffff
00826515 lea ecx, [ebp - 0x48]
00826518 call 0x4056d0
0082651D mov ecx, dword ptr [ebp - 0x4c]
00826520 mov edx, dword ptr [ecx]
00826522 mov ecx, dword ptr [ebp - 0x4c]
00826525 mov eax, dword ptr [edx + 0x20]
00826528 call eax
0082652A mov ecx, dword ptr [ebp - 0xc]
0082652D mov dword ptr fs:[0], ecx
00826534 pop ecx
00826535 mov esp, ebp
00826537 pop ebp
00826538 ret 8
; FUNCTION 0x826610
00826610 push ebp
00826611 mov ebp, esp
00826613 push -1
00826615 push 0xacc491
0082661A mov eax, dword ptr fs:[0]
00826620 push eax
00826621 sub esp, 0x2c
00826624 mov eax, dword ptr [0xc7b480]
00826629 xor eax, ebp
0082662B push eax
0082662C lea eax, [ebp - 0xc]
0082662F mov dword ptr fs:[0], eax
00826635 mov dword ptr [ebp - 0x34], ecx
00826638 mov eax, dword ptr [ebp + 8]
0082663B mov dword ptr [ebp - 0x14], eax
0082663E mov ecx, dword ptr [ebp - 0x14]
00826641 mov edx, dword ptr [ecx + 4]
00826644 push edx
00826645 call 0xa21b30
0082664A mov ecx, eax
0082664C call 0xa1e560
00826651 mov dword ptr [ebp - 0x10], eax
00826654 cmp dword ptr [ebp - 0x10], 0
00826658 je 0x8266c4
0082665A push 0xbcaee0
0082665F lea ecx, [ebp - 0x30]
00826662 call 0x405650
00826667 mov dword ptr [ebp - 4], 0
0082666E call 0x549100
00826673 mov dword ptr [ebp - 0x38], eax
00826676 push 0
00826678 push 0
0082667A push 0
0082667C lea eax, [ebp - 0x30]
0082667F push eax
00826680 mov ecx, dword ptr [ebp - 0x38]
00826683 mov edx, dword ptr [ecx]
00826685 mov ecx, dword ptr [ebp - 0x38]
00826688 mov eax, dword ptr [edx + 0x1c0]
0082668E call eax
00826690 mov dword ptr [ebp - 4], 0xffffffff
00826697 lea ecx, [ebp - 0x30]
0082669A call 0x4056d0
0082669F mov ecx, dword ptr [ebp - 0x10]
008266A2 add ecx, 0x44
008266A5 push ecx
008266A6 call 0x549100
008266AB mov ecx, eax
008266AD call 0x873f80
008266B2 mov edx, dword ptr [ebp - 0x14]
008266B5 mov eax, dword ptr [edx]
008266B7 push eax
008266B8 call 0x549100
008266BD mov ecx, eax
008266BF call 0x873f00
008266C4 mov ecx, dword ptr [ebp - 0xc]
008266C7 mov dword ptr fs:[0], ecx
008266CE pop ecx
008266CF mov esp, ebp
008266D1 pop ebp
008266D2 ret 8
; FUNCTION 0xa28290
00A28290 push ebp
00A28291 mov ebp, esp
00A28293 sub esp, 0x18
00A28296 mov dword ptr [ebp - 0x10], ecx
00A28299 cmp dword ptr [ebp + 8], 0
00A2829D je 0xa282a5
00A2829F cmp dword ptr [ebp + 0xc], 0xc
00A282A3 je 0xa282aa
00A282A5 jmp 0xa28382
00A282AA mov eax, dword ptr [ebp + 8]
00A282AD mov dword ptr [ebp - 4], eax
00A282B0 cmp dword ptr [ebp - 4], 0
00A282B4 je 0xa28382
00A282BA mov ecx, dword ptr [ebp - 4]
00A282BD cmp dword ptr [ecx + 8], 0
00A282C1 je 0xa282e7
00A282C3 mov ecx, dword ptr [0x17c8710]
00A282C9 call 0x453db0
00A282CE mov dword ptr [ebp - 0x14], eax
00A282D1 push 1
00A282D3 push 1
00A282D5 mov edx, dword ptr [ebp - 0x14]
00A282D8 mov eax, dword ptr [edx]
00A282DA mov ecx, dword ptr [ebp - 0x14]
00A282DD mov edx, dword ptr [eax + 0x88]
00A282E3 call edx
00A282E5 jmp 0xa28309
00A282E7 mov ecx, dword ptr [0x17c8710]
00A282ED call 0x453db0
00A282F2 mov dword ptr [ebp - 0x18], eax
00A282F5 push 1
00A282F7 push 0
00A282F9 mov eax, dword ptr [ebp - 0x18]
00A282FC mov edx, dword ptr [eax]
00A282FE mov ecx, dword ptr [ebp - 0x18]
00A28301 mov eax, dword ptr [edx + 0x88]
00A28307 call eax
00A28309 mov ecx, dword ptr [0x17c8708]
00A2830F call 0x819120
00A28314 mov dword ptr [ebp - 8], eax
00A28317 mov dword ptr [ebp - 0xc], 0
00A2831E cmp dword ptr [ebp - 8], 0
00A28322 je 0xa28382
00A28324 mov ecx, dword ptr [ebp - 8]
00A28327 call 0x41b790
00A2832C mov dword ptr [ebp - 0xc], eax
00A2832F cmp dword ptr [ebp - 0xc], 0
00A28333 je 0xa28354
00A28335 mov ecx, dword ptr [ebp - 0xc]
00A28338 call 0x462480
00A2833D mov ecx, dword ptr [ebp - 4]
00A28340 cmp eax, dword ptr [ecx]
00A28342 jne 0xa28354
00A28344 push 0x25
00A28346 mov edx, dword ptr [ebp - 4]
00A28349 push edx
00A2834A mov ecx, dword ptr [ebp - 0xc]
00A2834D call 0x99a620
00A28352 jmp 0xa28382
00A28354 mov ecx, dword ptr [ebp - 8]
00A28357 call 0x41b7b0
00A2835C mov dword ptr [ebp - 0xc], eax
00A2835F cmp dword ptr [ebp - 0xc], 0
00A28363 je 0xa28382
00A28365 mov ecx, dword ptr [ebp - 0xc]
00A28368 call 0x462480
00A2836D mov ecx, dword ptr [ebp - 4]
00A28370 cmp eax, dword ptr [ecx]
00A28372 jne 0xa28382
00A28374 push 0x26
00A28376 mov edx, dword ptr [ebp - 4]
00A28379 push edx
00A2837A mov ecx, dword ptr [ebp - 0xc]
00A2837D call 0x99a620
00A28382 mov esp, ebp
00A28384 pop ebp
00A28385 ret 8
; FUNCTION 0x99a620
0099A620 push ebp
0099A621 mov ebp, esp
0099A623 push -1
0099A625 push 0xaa4f66
0099A62A mov eax, dword ptr fs:[0]
0099A630 push eax
0099A631 sub esp, 0x34
0099A634 mov eax, dword ptr [0xc7b480]
0099A639 xor eax, ebp
0099A63B push eax
0099A63C lea eax, [ebp - 0xc]
0099A63F mov dword ptr fs:[0], eax
0099A645 mov dword ptr [ebp - 0x34], ecx
0099A648 cmp dword ptr [ebp + 8], 0
0099A64C je 0x99a73e
0099A652 mov eax, dword ptr [ebp + 8]
0099A655 mov ecx, dword ptr [eax + 4]
0099A658 mov dword ptr [ebp - 0x3c], ecx
0099A65B mov dword ptr [ebp - 0x38], 0
0099A662 fild qword ptr [ebp - 0x3c]
0099A665 fdiv qword ptr [0xbe8460]
0099A66B mov edx, dword ptr [ebp - 0x34]
0099A66E fstp dword ptr [edx + 0x170]
0099A674 mov ecx, dword ptr [0x17c8710]
0099A67A call 0x453db0
0099A67F mov dword ptr [ebp - 0x40], eax
0099A682 mov eax, dword ptr [ebp - 0x34]
0099A685 push ecx
0099A686 fld dword ptr [eax + 0x170]
0099A68C fstp dword ptr [esp]
0099A68F mov ecx, dword ptr [ebp + 0xc]
0099A692 push ecx
0099A693 mov edx, dword ptr [ebp - 0x40]
0099A696 mov eax, dword ptr [edx]
0099A698 mov ecx, dword ptr [ebp - 0x40]
0099A69B mov edx, dword ptr [eax + 0x8c]
0099A6A1 call edx
0099A6A3 mov ecx, dword ptr [0x17c86fc]
0099A6A9 call 0x453bc0
0099A6AE mov dword ptr [ebp - 0x10], eax
0099A6B1 cmp dword ptr [ebp - 0x10], 0
0099A6B5 je 0x99a6c6
0099A6B7 mov eax, dword ptr [ebp - 0x10]
0099A6BA push eax
0099A6BB mov ecx, dword ptr [0x17c86fc]
0099A6C1 call 0x9ce800
0099A6C6 mov ecx, dword ptr [ebp + 8]
0099A6C9 cmp dword ptr [ecx + 8], 0
0099A6CD je 0x99a73e
0099A6CF lea ecx, [ebp - 0x14]
0099A6D2 call 0x405f90
0099A6D7 mov dword ptr [ebp - 4], 0
0099A6DE push 0xba5da8
0099A6E3 lea edx, [ebp - 0x14]
0099A6E6 push edx
0099A6E7 call 0x411c60
0099A6EC add esp, 8
0099A6EF push 0xb96699
0099A6F4 lea ecx, [ebp - 0x30]
0099A6F7 call 0x405650
0099A6FC mov byte ptr [ebp - 4], 1
0099A700 push 0
0099A702 push 0xffff0000
0099A707 push 0
0099A709 push 4
0099A70B lea eax, [ebp - 0x14]
0099A70E push eax
0099A70F lea ecx, [ebp - 0x30]
0099A712 push ecx
0099A713 push 0
0099A715 push 0
0099A717 call 0x41b7d0
0099A71C mov ecx, eax
0099A71E call 0xa921b0
0099A723 mov byte ptr [ebp - 4], 0
0099A727 lea ecx, [ebp - 0x30]
0099A72A call 0x4056d0
0099A72F mov dword ptr [ebp - 4], 0xffffffff
0099A736 lea ecx, [ebp - 0x14]
0099A739 call 0x406050
0099A73E mov ecx, dword ptr [ebp - 0xc]
0099A741 mov dword ptr fs:[0], ecx
0099A748 pop ecx
0099A749 mov esp, ebp
0099A74B pop ebp
0099A74C ret 8
; FUNCTION 0x874600
00874600 push ebp
00874601 mov ebp, esp
00874603 push -1
00874605 push 0xacefc8
0087460A mov eax, dword ptr fs:[0]
00874610 push eax
00874611 sub esp, 0x3c0
00874617 push esi
00874618 push edi
00874619 mov eax, dword ptr [0xc7b480]
0087461E xor eax, ebp
00874620 push eax
00874621 lea eax, [ebp - 0xc]
00874624 mov dword ptr fs:[0], eax
0087462A mov dword ptr [ebp - 0x314], ecx
00874630 mov esi, dword ptr [ebp + 8]
00874633 mov edi, dword ptr [ebp - 0x314]
00874639 add edi, 0x578
0087463F mov ecx, 8
00874644 rep movsd dword ptr es:[edi], dword ptr [esi]
00874646 mov dword ptr [ebp - 0x18], 0
0087464D mov eax, dword ptr [ebp + 8]
00874650 mov ecx, dword ptr [eax + 4]
00874653 push ecx
00874654 call 0xa21b30
00874659 mov ecx, eax
0087465B call 0xa1e560
00874660 mov dword ptr [ebp - 0x10], eax
00874663 cmp dword ptr [ebp - 0x10], 0
00874667 je 0x874823
0087466D mov dword ptr [ebp - 0x1c], 0
00874674 lea edx, [ebp - 0x1c]
00874677 push edx
00874678 lea eax, [ebp - 0x38]
0087467B push eax
0087467C call 0xa44160
00874681 add esp, 8
00874684 mov dword ptr [ebp - 0x318], eax
0087468A mov ecx, dword ptr [ebp - 0x318]
00874690 mov dword ptr [ebp - 0x31c], ecx
00874696 mov dword ptr [ebp - 4], 0
0087469D mov edx, dword ptr [ebp - 0x31c]
008746A3 push edx
008746A4 mov eax, dword ptr [0xb98c3c]
008746A9 push eax
008746AA lea ecx, [ebp - 0x54]
008746AD push ecx
008746AE call 0x411d70
008746B3 add esp, 0xc
008746B6 mov dword ptr [ebp - 0x320], eax
008746BC mov edx, dword ptr [ebp - 0x320]
008746C2 mov dword ptr [ebp - 0x324], edx
008746C8 mov byte ptr [ebp - 4], 1
008746CC mov eax, dword ptr [ebp - 0x324]
008746D2 push eax
008746D3 mov ecx, dword ptr [ebp - 0x314]
008746D9 call 0x75fbf0
008746DE mov dword ptr [ebp - 0x18], eax
008746E1 mov byte ptr [ebp - 4], 0
008746E5 lea ecx, [ebp - 0x54]
008746E8 call 0x4056d0
008746ED mov dword ptr [ebp - 4], 0xffffffff
008746F4 lea ecx, [ebp - 0x38]
008746F7 call 0x4056d0
008746FC cmp dword ptr [ebp - 0x18], 0
00874700 je 0x87473d
00874702 mov ecx, dword ptr [ebp - 0x10]
00874705 add ecx, 0x44
00874708 call 0x406410
0087470D push eax
0087470E lea ecx, [ebp - 0x70]
00874711 call 0x405650
00874716 mov dword ptr [ebp - 4], 2
0087471D lea ecx, [ebp - 0x70]
00874720 push ecx
00874721 mov edx, dword ptr [ebp - 0x18]
00874724 mov eax, dword ptr [edx]
00874726 mov ecx, dword ptr [ebp - 0x18]
00874729 mov edx, dword ptr [eax + 0x28]
0087472C call edx
0087472E mov dword ptr [ebp - 4], 0xffffffff
00874735 lea ecx, [ebp - 0x70]
00874738 call 0x4056d0
0087473D mov dword ptr [ebp - 0x74], 1
00874744 lea eax, [ebp - 0x74]
00874747 push eax
00874748 lea ecx, [ebp - 0x90]
0087474E push ecx
0087474F call 0xa44160
00874754 add esp, 8
00874757 mov dword ptr [ebp - 0x328], eax
0087475D mov edx, dword ptr [ebp - 0x328]
00874763 mov dword ptr [ebp - 0x32c], edx
00874769 mov dword ptr [ebp - 4], 3
00874770 mov eax, dword ptr [ebp - 0x32c]
00874776 push eax
00874777 mov ecx, dword ptr [0xb98c3c]
0087477D push ecx
0087477E lea edx, [ebp - 0xac]
00874784 push edx
00874785 call 0x411d70
0087478A add esp, 0xc
0087478D mov dword ptr [ebp - 0x330], eax
00874793 mov eax, dword ptr [ebp - 0x330]
00874799 mov dword ptr [ebp - 0x334], eax
0087479F mov byte ptr [ebp - 4], 4
008747A3 mov ecx, dword ptr [ebp - 0x334]
008747A9 push ecx
008747AA mov ecx, dword ptr [ebp - 0x314]
008747B0 call 0x75fbf0
008747B5 mov dword ptr [ebp - 0x18], eax
008747B8 mov byte ptr [ebp - 4], 3
008747BC lea ecx, [ebp - 0xac]
008747C2 call 0x4056d0
008747C7 mov dword ptr [ebp - 4], 0xffffffff
008747CE lea ecx, [ebp - 0x90]
008747D4 call 0x4056d0
008747D9 cmp dword ptr [ebp - 0x18], 0
008747DD je 0x874823
008747DF mov ecx, dword ptr [ebp - 0x10]
008747E2 add ecx, 0x44
008747E5 call 0x406410
008747EA push eax
008747EB lea ecx, [ebp - 0xc8]
008747F1 call 0x405650
008747F6 mov dword ptr [ebp - 4], 5
008747FD lea edx, [ebp - 0xc8]
00874803 push edx
00874804 mov eax, dword ptr [ebp - 0x18]
00874807 mov edx, dword ptr [eax]
00874809 mov ecx, dword ptr [ebp - 0x18]
0087480C mov eax, dword ptr [edx + 0x28]
0087480F call eax
00874811 mov dword ptr [ebp - 4], 0xffffffff
00874818 lea ecx, [ebp - 0xc8]
0087481E call 0x4056d0
00874823 mov ecx, dword ptr [ebp + 8]
00874826 mov edx, dword ptr [ecx + 8]
00874829 push edx
0087482A call 0xa21b30
0087482F mov ecx, eax
00874831 call 0xa1e560
00874836 mov dword ptr [ebp - 0x10], eax
00874839 cmp dword ptr [ebp - 0x10], 0
0087483D je 0x87492f
00874843 mov dword ptr [ebp - 0xcc], 0
0087484D lea eax, [ebp - 0xcc]
00874853 push eax
00874854 lea ecx, [ebp - 0xe8]
0087485A push ecx
0087485B call 0xa44160
00874860 add esp, 8
00874863 mov dword ptr [ebp - 0x338], eax
00874869 mov edx, dword ptr [ebp - 0x338]
0087486F mov dword ptr [ebp - 0x33c], edx
00874875 mov dword ptr [ebp - 4], 6
0087487C mov eax, dword ptr [ebp - 0x33c]
00874882 push eax
00874883 mov ecx, dword ptr [0xb98c40]
00874889 push ecx
0087488A lea edx, [ebp - 0x104]
00874890 push edx
00874891 call 0x411d70
00874896 add esp, 0xc
00874899 mov dword ptr [ebp - 0x340], eax
0087489F mov eax, dword ptr [ebp - 0x340]
008748A5 mov dword ptr [ebp - 0x344], eax
008748AB mov byte ptr [ebp - 4], 7
008748AF mov ecx, dword ptr [ebp - 0x344]
008748B5 push ecx
008748B6 mov ecx, dword ptr [ebp - 0x314]
008748BC call 0x75fbf0
008748C1 mov dword ptr [ebp - 0x18], eax
008748C4 mov byte ptr [ebp - 4], 6
008748C8 lea ecx, [ebp - 0x104]
008748CE call 0x4056d0
008748D3 mov dword ptr [ebp - 4], 0xffffffff
008748DA lea ecx, [ebp - 0xe8]
008748E0 call 0x4056d0
008748E5 cmp dword ptr [ebp - 0x18], 0
008748E9 je 0x87492f
008748EB mov ecx, dword ptr [ebp - 0x10]
008748EE add ecx, 0x44
008748F1 call 0x406410
008748F6 push eax
008748F7 lea ecx, [ebp - 0x120]
008748FD call 0x405650
00874902 mov dword ptr [ebp - 4], 8
00874909 lea edx, [ebp - 0x120]
0087490F push edx
00874910 mov eax, dword ptr [ebp - 0x18]
00874913 mov edx, dword ptr [eax]
00874915 mov ecx, dword ptr [ebp - 0x18]
00874918 mov eax, dword ptr [edx + 0x28]
0087491B call eax
0087491D mov dword ptr [ebp - 4], 0xffffffff
00874924 lea ecx, [ebp - 0x120]
0087492A call 0x4056d0
0087492F mov ecx, dword ptr [0xb98c4c]
00874935 push ecx
00874936 lea ecx, [ebp - 0x13c]
0087493C call 0x405650
00874941 mov dword ptr [ebp - 4], 9
00874948 lea edx, [ebp - 0x13c]
0087494E push edx
0087494F mov ecx, dword ptr [ebp - 0x314]
00874955 call 0x75fbf0
0087495A mov dword ptr [ebp - 0x14], eax
0087495D mov dword ptr [ebp - 4], 0xffffffff
00874964 lea ecx, [ebp - 0x13c]
0087496A call 0x4056d0
0087496F cmp dword ptr [ebp - 0x14], 0
00874973 je 0x8749cf
00874975 mov eax, dword ptr [ebp + 8]
00874978 add eax, 0x10
0087497B push eax
0087497C lea ecx, [ebp - 0x158]
00874982 push ecx
00874983 call 0x4b9190
00874988 add esp, 8
0087498B mov dword ptr [ebp - 0x348], eax
00874991 mov edx, dword ptr [ebp - 0x348]
00874997 mov dword ptr [ebp - 0x34c], edx
0087499D mov dword ptr [ebp - 4], 0xa
008749A4 push 1
008749A6 mov eax, dword ptr [ebp - 0x34c]
008749AC push eax
008749AD mov ecx, dword ptr [ebp - 0x14]
008749B0 mov edx, dword ptr [ecx]
008749B2 mov ecx, dword ptr [ebp - 0x14]
008749B5 mov eax, dword ptr [edx + 0xd4]
008749BB call eax
008749BD mov dword ptr [ebp - 4], 0xffffffff
008749C4 lea ecx, [ebp - 0x158]
008749CA call 0x4056d0
008749CF mov dword ptr [ebp - 0x15c], 0
008749D9 lea ecx, [ebp - 0x15c]
008749DF push ecx
008749E0 lea edx, [ebp - 0x178]
008749E6 push edx
008749E7 call 0xa44160
008749EC add esp, 8
008749EF mov dword ptr [ebp - 0x350], eax
008749F5 mov eax, dword ptr [ebp - 0x350]
008749FB mov dword ptr [ebp - 0x354], eax
00874A01 mov dword ptr [ebp - 4], 0xb
00874A08 mov ecx, dword ptr [ebp - 0x354]
00874A0E push ecx
00874A0F mov edx, dword ptr [0xb98c48]
00874A15 push edx
00874A16 lea eax, [ebp - 0x194]
00874A1C push eax
00874A1D call 0x411d70
00874A22 add esp, 0xc
00874A25 mov dword ptr [ebp - 0x358], eax
00874A2B mov ecx, dword ptr [ebp - 0x358]
00874A31 mov dword ptr [ebp - 0x35c], ecx
00874A37 mov byte ptr [ebp - 4], 0xc
00874A3B mov edx, dword ptr [ebp - 0x35c]
00874A41 push edx
00874A42 mov ecx, dword ptr [ebp - 0x314]
00874A48 call 0x75fbf0
00874A4D mov dword ptr [ebp - 0x14], eax
00874A50 mov byte ptr [ebp - 4], 0xb
00874A54 lea ecx, [ebp - 0x194]
00874A5A call 0x4056d0
00874A5F mov dword ptr [ebp - 4], 0xffffffff
00874A66 lea ecx, [ebp - 0x178]
00874A6C call 0x4056d0
00874A71 cmp dword ptr [ebp - 0x14], 0
00874A75 je 0x874bfe
00874A7B mov eax, dword ptr [ebp + 8]
00874A7E mov ecx, dword ptr [eax + 0x18]
00874A81 mov dword ptr [ebp - 0x364], ecx
00874A87 mov dword ptr [ebp - 0x360], 0
00874A91 fild qword ptr [ebp - 0x364]
00874A97 fdiv qword ptr [0xbe8460]
00874A9D sub esp, 8
00874AA0 fstp qword ptr [esp]
00874AA3 call 0x511300
00874AA8 add esp, 8
00874AAB fstp qword ptr [ebp - 0x19c]
00874AB1 mov edx, dword ptr [ebp + 8]
00874AB4 mov eax, dword ptr [edx + 0x14]
00874AB7 mov dword ptr [ebp - 0x36c], eax
00874ABD mov dword ptr [ebp - 0x368], 0
00874AC7 fild qword ptr [ebp - 0x36c]
00874ACD fdiv qword ptr [0xbe8460]
00874AD3 sub esp, 8
00874AD6 fstp qword ptr [esp]
00874AD9 call 0x511300
00874ADE add esp, 8
00874AE1 fstp qword ptr [ebp - 0x1c4]
00874AE7 lea ecx, [ebp - 0x19c]
00874AED push ecx
00874AEE lea edx, [ebp - 0x1b8]
00874AF4 push edx
00874AF5 call 0x511390
00874AFA add esp, 8
00874AFD mov dword ptr [ebp - 0x370], eax
00874B03 mov eax, dword ptr [ebp - 0x370]
00874B09 mov dword ptr [ebp - 0x374], eax
00874B0F mov dword ptr [ebp - 4], 0xd
00874B16 lea ecx, [ebp - 0x1c4]
00874B1C push ecx
00874B1D lea edx, [ebp - 0x1e0]
00874B23 push edx
00874B24 call 0x511390
00874B29 add esp, 8
00874B2C mov dword ptr [ebp - 0x378], eax
00874B32 mov eax, dword ptr [ebp - 0x378]
00874B38 mov dword ptr [ebp - 0x37c], eax
00874B3E mov byte ptr [ebp - 4], 0xe
00874B42 push 0xb9cbe0
00874B47 mov ecx, dword ptr [ebp - 0x37c]
00874B4D push ecx
00874B4E lea edx, [ebp - 0x1fc]
00874B54 push edx
00874B55 call 0x4194f0
00874B5A add esp, 0xc
00874B5D mov dword ptr [ebp - 0x380], eax
00874B63 mov eax, dword ptr [ebp - 0x380]
00874B69 mov dword ptr [ebp - 0x384], eax
00874B6F mov byte ptr [ebp - 4], 0xf
00874B73 mov ecx, dword ptr [ebp - 0x374]
00874B79 push ecx
00874B7A mov edx, dword ptr [ebp - 0x384]
00874B80 push edx
00874B81 lea eax, [ebp - 0x218]
00874B87 push eax
00874B88 call 0x41b400
00874B8D add esp, 0xc
00874B90 mov dword ptr [ebp - 0x388], eax
00874B96 mov ecx, dword ptr [ebp - 0x388]
00874B9C mov dword ptr [ebp - 0x38c], ecx
00874BA2 mov byte ptr [ebp - 4], 0x10
00874BA6 push 1
00874BA8 mov edx, dword ptr [ebp - 0x38c]
00874BAE push edx
00874BAF mov eax, dword ptr [ebp - 0x14]
00874BB2 mov edx, dword ptr [eax]
00874BB4 mov ecx, dword ptr [ebp - 0x14]
00874BB7 mov eax, dword ptr [edx + 0xd4]
00874BBD call eax
00874BBF mov byte ptr [ebp - 4], 0xf
00874BC3 lea ecx, [ebp - 0x218]
00874BC9 call 0x4056d0
00874BCE mov byte ptr [ebp - 4], 0xe
00874BD2 lea ecx, [ebp - 0x1fc]
00874BD8 call 0x4056d0
00874BDD mov byte ptr [ebp - 4], 0xd
00874BE1 lea ecx, [ebp - 0x1e0]
00874BE7 call 0x4056d0
00874BEC mov dword ptr [ebp - 4], 0xffffffff
00874BF3 lea ecx, [ebp - 0x1b8]
00874BF9 call 0x4056d0
00874BFE mov dword ptr [ebp - 0x21c], 1
00874C08 lea ecx, [ebp - 0x21c]
00874C0E push ecx
00874C0F lea edx, [ebp - 0x238]
00874C15 push edx
00874C16 call 0xa44160
00874C1B add esp, 8
00874C1E mov dword ptr [ebp - 0x390], eax
00874C24 mov eax, dword ptr [ebp - 0x390]
00874C2A mov dword ptr [ebp - 0x394], eax
00874C30 mov dword ptr [ebp - 4], 0x11
00874C37 mov ecx, dword ptr [ebp - 0x394]
00874C3D push ecx
00874C3E mov edx, dword ptr [0xb98c48]
00874C44 push edx
00874C45 lea eax, [ebp - 0x254]
00874C4B push eax
00874C4C call 0x411d70
00874C51 add esp, 0xc
00874C54 mov dword ptr [ebp - 0x398], eax
00874C5A mov ecx, dword ptr [ebp - 0x398]
00874C60 mov dword ptr [ebp - 0x39c], ecx
00874C66 mov byte ptr [ebp - 4], 0x12
00874C6A mov edx, dword ptr [ebp - 0x39c]
00874C70 push edx
00874C71 mov ecx, dword ptr [ebp - 0x314]
00874C77 call 0x75fbf0
00874C7C mov dword ptr [ebp - 0x14], eax
00874C7F mov byte ptr [ebp - 4], 0x11
00874C83 lea ecx, [ebp - 0x254]
00874C89 call 0x4056d0
00874C8E mov dword ptr [ebp - 4], 0xffffffff
00874C95 lea ecx, [ebp - 0x238]
00874C9B call 0x4056d0
00874CA0 cmp dword ptr [ebp - 0x14], 0
00874CA4 je 0x874e2d
00874CAA mov eax, dword ptr [ebp + 8]
00874CAD mov ecx, dword ptr [eax + 0x18]
00874CB0 mov dword ptr [ebp - 0x3a4], ecx
00874CB6 mov dword ptr [ebp - 0x3a0], 0
00874CC0 fild qword ptr [ebp - 0x3a4]
00874CC6 fdiv qword ptr [0xbe8460]
00874CCC sub esp, 8
00874CCF fstp qword ptr [esp]
00874CD2 call 0x511300
00874CD7 add esp, 8
00874CDA fstp qword ptr [ebp - 0x25c]
00874CE0 mov edx, dword ptr [ebp + 8]
00874CE3 mov eax, dword ptr [edx + 0x18]
00874CE6 mov dword ptr [ebp - 0x3ac], eax
00874CEC mov dword ptr [ebp - 0x3a8], 0
00874CF6 fild qword ptr [ebp - 0x3ac]
00874CFC fdiv qword ptr [0xbe8460]
00874D02 sub esp, 8
00874D05 fstp qword ptr [esp]
00874D08 call 0x511300
00874D0D add esp, 8
00874D10 fstp qword ptr [ebp - 0x284]
00874D16 lea ecx, [ebp - 0x25c]
00874D1C push ecx
00874D1D lea edx, [ebp - 0x278]
00874D23 push edx
00874D24 call 0x511390
00874D29 add esp, 8
00874D2C mov dword ptr [ebp - 0x3b0], eax
00874D32 mov eax, dword ptr [ebp - 0x3b0]
00874D38 mov dword ptr [ebp - 0x3b4], eax
00874D3E mov dword ptr [ebp - 4], 0x13
00874D45 lea ecx, [ebp - 0x284]
00874D4B push ecx
00874D4C lea edx, [ebp - 0x2a0]
00874D52 push edx
00874D53 call 0x511390
00874D58 add esp, 8
00874D5B mov dword ptr [ebp - 0x3b8], eax
00874D61 mov eax, dword ptr [ebp - 0x3b8]
00874D67 mov dword ptr [ebp - 0x3bc], eax
00874D6D mov byte ptr [ebp - 4], 0x14
00874D71 push 0xb9cbe0
00874D76 mov ecx, dword ptr [ebp - 0x3bc]
00874D7C push ecx
00874D7D lea edx, [ebp - 0x2bc]
00874D83 push edx
00874D84 call 0x4194f0
00874D89 add esp, 0xc
00874D8C mov dword ptr [ebp - 0x3c0], eax
00874D92 mov eax, dword ptr [ebp - 0x3c0]
00874D98 mov dword ptr [ebp - 0x3c4], eax
00874D9E mov byte ptr [ebp - 4], 0x15
00874DA2 mov ecx, dword ptr [ebp - 0x3b4]
00874DA8 push ecx
00874DA9 mov edx, dword ptr [ebp - 0x3c4]
00874DAF push edx
00874DB0 lea eax, [ebp - 0x2d8]
00874DB6 push eax
00874DB7 call 0x41b400
00874DBC add esp, 0xc
00874DBF mov dword ptr [ebp - 0x3c8], eax
00874DC5 mov ecx, dword ptr [ebp - 0x3c8]
00874DCB mov dword ptr [ebp - 0x3cc], ecx
00874DD1 mov byte ptr [ebp - 4], 0x16
00874DD5 push 1
00874DD7 mov edx, dword ptr [ebp - 0x3cc]
00874DDD push edx
00874DDE mov eax, dword ptr [ebp - 0x14]
00874DE1 mov edx, dword ptr [eax]
00874DE3 mov ecx, dword ptr [ebp - 0x14]
00874DE6 mov eax, dword ptr [edx + 0xd4]
00874DEC call eax
00874DEE mov byte ptr [ebp - 4], 0x15
00874DF2 lea ecx, [ebp - 0x2d8]
00874DF8 call 0x4056d0
00874DFD mov byte ptr [ebp - 4], 0x14
00874E01 lea ecx, [ebp - 0x2bc]
00874E07 call 0x4056d0
00874E0C mov byte ptr [ebp - 4], 0x13
00874E10 lea ecx, [ebp - 0x2a0]
00874E16 call 0x4056d0
00874E1B mov dword ptr [ebp - 4], 0xffffffff
00874E22 lea ecx, [ebp - 0x278]
00874E28 call 0x4056d0
00874E2D mov ecx, dword ptr [ebp + 8]
00874E30 cmp dword ptr [ecx + 0x1c], 0
00874E34 je 0x874e77
00874E36 mov edx, dword ptr [0xb98c50]
00874E3C push edx
00874E3D lea ecx, [ebp - 0x2f4]
00874E43 call 0x405650
00874E48 mov dword ptr [ebp - 4], 0x17
00874E4F push 0
00874E51 lea eax, [ebp - 0x2f4]
00874E57 push eax
00874E58 mov ecx, dword ptr [ebp - 0x314]
00874E5E call 0x7611c0
00874E63 mov dword ptr [ebp - 4], 0xffffffff
00874E6A lea ecx, [ebp - 0x2f4]
00874E70 call 0x4056d0
00874E75 jmp 0x874eb6
00874E77 mov ecx, dword ptr [0xb98c50]
00874E7D push ecx
00874E7E lea ecx, [ebp - 0x310]
00874E84 call 0x405650
00874E89 mov dword ptr [ebp - 4], 0x18
00874E90 push 1
00874E92 lea edx, [ebp - 0x310]
00874E98 push edx
00874E99 mov ecx, dword ptr [ebp - 0x314]
00874E9F call 0x7611c0
00874EA4 mov dword ptr [ebp - 4], 0xffffffff
00874EAB lea ecx, [ebp - 0x310]
00874EB1 call 0x4056d0
00874EB6 mov ecx, dword ptr [ebp - 0xc]
00874EB9 mov dword ptr fs:[0], ecx
00874EC0 pop ecx
00874EC1 pop edi
00874EC2 pop esi
00874EC3 mov esp, ebp
00874EC5 pop ebp
00874EC6 ret 4
; FUNCTION 0x462480
00462480 push ebp
00462481 mov ebp, esp
00462483 push ecx
00462484 mov dword ptr [ebp - 4], ecx
00462487 mov eax, dword ptr [ebp - 4]
0046248A mov eax, dword ptr [eax + 8]
0046248D mov esp, ebp
0046248F pop ebp
00462490 ret
