; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; FUNCTION 00A553D0
00A553D0 push ebp
00A553D1 mov ebp, esp
00A553D3 push -1
00A553D5 push 0xab24fe
00A553DA mov eax, dword ptr fs:[0]
00A553E0 push eax
00A553E1 sub esp, 0x41c
00A553E7 mov eax, dword ptr [0xc7b480]
00A553EC xor eax, ebp
00A553EE push eax
00A553EF lea eax, [ebp - 0xc]
00A553F2 mov dword ptr fs:[0], eax
00A553F8 mov dword ptr [ebp - 0x314], ecx
00A553FE mov dword ptr [ebp - 4], 1
00A55405 push 1
00A55407 lea ecx, [ebp + 8]
00A5540A call 0x406410
00A5540F push eax
00A55410 mov eax, dword ptr [ebp - 0x314]
00A55416 mov ecx, dword ptr [eax + 0x18]
00A55419 call 0xa5fde0
00A5541E movzx ecx, al
00A55421 test ecx, ecx
00A55423 jne 0xa55455
00A55425 mov dword ptr [ebp - 0xf4], 0
00A5542F mov byte ptr [ebp - 4], 0
00A55433 lea ecx, [ebp + 8]
00A55436 call 0x406050
00A5543B mov dword ptr [ebp - 4], 0xffffffff
00A55442 lea ecx, [ebp + 0xc]
00A55445 call 0x406050
00A5544A mov eax, dword ptr [ebp - 0xf4]
00A55450 jmp 0xa55f1e
00A55455 lea ecx, [ebp + 0xc]
00A55458 call 0x406410
00A5545D push eax
00A5545E mov edx, dword ptr [ebp - 0x314]
00A55464 mov ecx, dword ptr [edx + 0x18]
00A55467 call 0xa603e0
00A5546C push 0xba41bc ; '/MapConfig'
00A55471 lea eax, [ebp - 0x18]
00A55474 push eax
00A55475 mov ecx, dword ptr [ebp - 0x314]
00A5547B mov ecx, dword ptr [ecx + 0x18]
00A5547E call 0xa5e650
00A55483 mov byte ptr [ebp - 4], 2
00A55487 push 0
00A55489 lea ecx, [ebp - 0x1c]
00A5548C call 0x56db30
00A55491 mov byte ptr [ebp - 4], 3
00A55495 lea edx, [ebp - 0xfc]
00A5549B push edx
00A5549C lea ecx, [ebp - 0x18]
00A5549F call 0x419eb0
00A554A4 mov ecx, eax
00A554A6 call 0x416170
00A554AB mov dword ptr [ebp - 0x318], eax
00A554B1 mov eax, dword ptr [ebp - 0x318]
00A554B7 mov dword ptr [ebp - 0x31c], eax
00A554BD mov byte ptr [ebp - 4], 4
00A554C1 push 0
00A554C3 mov ecx, dword ptr [ebp - 0x31c]
00A554C9 push ecx
00A554CA lea ecx, [ebp - 0x1c]
00A554CD call 0x4193c0
00A554D2 mov ecx, eax
00A554D4 call 0x4263b0
00A554D9 mov byte ptr [ebp - 0xf5], al
00A554DF mov byte ptr [ebp - 4], 3
00A554E3 lea ecx, [ebp - 0xfc]
00A554E9 call 0x416d30
00A554EE movzx edx, byte ptr [ebp - 0xf5]
00A554F5 test edx, edx
00A554F7 je 0xa559e9
00A554FD push 0
00A554FF push 0xba454c ; 'MapId'
00A55504 push ecx
00A55505 mov ecx, esp
00A55507 mov dword ptr [ebp - 0x100], esp
00A5550D lea eax, [ebp - 0x1c]
00A55510 push eax
00A55511 call 0x4199e0
00A55516 mov dword ptr [ebp - 0x320], eax
00A5551C call 0xa5e240
00A55521 add esp, 0xc
00A55524 mov dword ptr [ebp - 0x324], eax
00A5552A mov ecx, dword ptr [ebp - 0x324]
00A55530 mov dword ptr [ebp - 0x84], ecx
00A55536 push 0
00A55538 push 0xba4554 ; 'Priority'
00A5553D push ecx
00A5553E mov ecx, esp
00A55540 mov dword ptr [ebp - 0x104], esp
00A55546 lea edx, [ebp - 0x1c]
00A55549 push edx
00A5554A call 0x4199e0
00A5554F mov dword ptr [ebp - 0x328], eax
00A55555 call 0xa5e240
00A5555A add esp, 0xc
00A5555D mov dword ptr [ebp - 0x32c], eax
00A55563 mov eax, dword ptr [ebp - 0x32c]
00A55569 mov dword ptr [ebp - 0x20], eax
00A5556C push 0x14
00A5556E push 0xba4560 ; 'MaxAttackCounter'
00A55573 push ecx
00A55574 mov ecx, esp
00A55576 mov dword ptr [ebp - 0x108], esp
00A5557C lea edx, [ebp - 0x1c]
00A5557F push edx
00A55580 call 0x4199e0
00A55585 mov dword ptr [ebp - 0x330], eax
00A5558B call 0xa5e240
00A55590 add esp, 0xc
00A55593 mov dword ptr [ebp - 0x334], eax
00A55599 mov eax, dword ptr [ebp - 0x334]
00A5559F mov dword ptr [ebp - 0x80], eax
00A555A2 lea ecx, [ebp - 0x7c]
00A555A5 call 0x4811c0
00A555AA mov byte ptr [ebp - 4], 5
00A555AE mov ecx, dword ptr [ebp - 0x20]
00A555B1 mov dword ptr [ebp - 0x78], ecx
00A555B4 mov edx, dword ptr [ebp - 0x84]
00A555BA mov dword ptr [ebp - 0x7c], edx
00A555BD mov eax, dword ptr [ebp - 0x80]
00A555C0 mov dword ptr [ebp - 0x44], eax
00A555C3 push 0xb96699
00A555C8 push 0xb9c324 ; 'Name'
00A555CD push ecx
00A555CE mov ecx, esp
00A555D0 mov dword ptr [ebp - 0x10c], esp
00A555D6 lea edx, [ebp - 0x1c]
00A555D9 push edx
00A555DA call 0x4199e0
00A555DF mov dword ptr [ebp - 0x338], eax
00A555E5 lea eax, [ebp - 0x110]
00A555EB push eax
00A555EC call 0xa60260
00A555F1 add esp, 0x10
00A555F4 mov dword ptr [ebp - 0x33c], eax
00A555FA mov ecx, dword ptr [ebp - 0x33c]
00A55600 mov dword ptr [ebp - 0x340], ecx
00A55606 mov byte ptr [ebp - 4], 6
00A5560A mov edx, dword ptr [ebp - 0x340]
00A55610 push edx
00A55611 lea ecx, [ebp - 0x60]
00A55614 call 0x406070
00A55619 mov byte ptr [ebp - 4], 5
00A5561D lea ecx, [ebp - 0x110]
00A55623 call 0x406050
00A55628 push 0xb96699
00A5562D push 0xba4574 ; 'xmlfile'
00A55632 push ecx
00A55633 mov ecx, esp
00A55635 mov dword ptr [ebp - 0x114], esp
00A5563B lea eax, [ebp - 0x1c]
00A5563E push eax
00A5563F call 0x4199e0
00A55644 mov dword ptr [ebp - 0x344], eax
00A5564A lea ecx, [ebp - 0x118]
00A55650 push ecx
00A55651 call 0xa60260
00A55656 add esp, 0x10
00A55659 mov dword ptr [ebp - 0x348], eax
00A5565F mov edx, dword ptr [ebp - 0x348]
00A55665 mov dword ptr [ebp - 0x34c], edx
00A5566B mov byte ptr [ebp - 4], 7
00A5566F mov eax, dword ptr [ebp - 0x34c]
00A55675 push eax
00A55676 lea ecx, [ebp - 0x5c]
00A55679 call 0x406070
00A5567E mov byte ptr [ebp - 4], 5
00A55682 lea ecx, [ebp - 0x118]
00A55688 call 0x406050
00A5568D push 0xb96699
00A55692 push 0xba457c ; 'worldpath'
00A55697 push ecx
00A55698 mov ecx, esp
00A5569A mov dword ptr [ebp - 0x11c], esp
00A556A0 lea edx, [ebp - 0x1c]
00A556A3 push edx
00A556A4 call 0x4199e0
00A556A9 mov dword ptr [ebp - 0x350], eax
00A556AF lea eax, [ebp - 0x120]
00A556B5 push eax
00A556B6 call 0xa60260
00A556BB add esp, 0x10
00A556BE mov dword ptr [ebp - 0x354], eax
00A556C4 mov ecx, dword ptr [ebp - 0x354]
00A556CA mov dword ptr [ebp - 0x358], ecx
00A556D0 mov byte ptr [ebp - 4], 8
00A556D4 mov edx, dword ptr [ebp - 0x358]
00A556DA push edx
00A556DB lea ecx, [ebp - 0x58]
00A556DE call 0x406070
00A556E3 mov byte ptr [ebp - 4], 5
00A556E7 lea ecx, [ebp - 0x120]
00A556ED call 0x406050
00A556F2 push 0xb96699
00A556F7 push 0xba4588 ; 'PicName'
00A556FC push ecx
00A556FD mov ecx, esp
00A556FF mov dword ptr [ebp - 0x124], esp
00A55705 lea eax, [ebp - 0x1c]
00A55708 push eax
00A55709 call 0x4199e0
00A5570E mov dword ptr [ebp - 0x35c], eax
00A55714 lea ecx, [ebp - 0x128]
00A5571A push ecx
00A5571B call 0xa60260
00A55720 add esp, 0x10
00A55723 mov dword ptr [ebp - 0x360], eax
00A55729 mov edx, dword ptr [ebp - 0x360]
00A5572F mov dword ptr [ebp - 0x364], edx
00A55735 mov byte ptr [ebp - 4], 9
00A55739 mov eax, dword ptr [ebp - 0x364]
00A5573F push eax
00A55740 lea ecx, [ebp - 0x54]
00A55743 call 0x406070
00A55748 mov byte ptr [ebp - 4], 5
00A5574C lea ecx, [ebp - 0x128]
00A55752 call 0x406050
00A55757 push 0xb96699
00A5575C push 0xba4590 ; 'Intro'
00A55761 push ecx
00A55762 mov ecx, esp
00A55764 mov dword ptr [ebp - 0x12c], esp
00A5576A lea edx, [ebp - 0x1c]
00A5576D push edx
00A5576E call 0x4199e0
00A55773 mov dword ptr [ebp - 0x368], eax
00A55779 lea eax, [ebp - 0x130]
00A5577F push eax
00A55780 call 0xa60260
00A55785 add esp, 0x10
00A55788 mov dword ptr [ebp - 0x36c], eax
00A5578E mov ecx, dword ptr [ebp - 0x36c]
00A55794 mov dword ptr [ebp - 0x370], ecx
00A5579A mov byte ptr [ebp - 4], 0xa
00A5579E mov edx, dword ptr [ebp - 0x370]
00A557A4 push edx
00A557A5 lea ecx, [ebp - 0x50]
00A557A8 call 0x406070
00A557AD mov byte ptr [ebp - 4], 5
00A557B1 lea ecx, [ebp - 0x130]
00A557B7 call 0x406050
00A557BC push 0
00A557BE push 0xba4270 ; 'MapType'
00A557C3 push ecx
00A557C4 mov ecx, esp
00A557C6 mov dword ptr [ebp - 0x134], esp
00A557CC lea eax, [ebp - 0x1c]
00A557CF push eax
00A557D0 call 0x4199e0
00A557D5 mov dword ptr [ebp - 0x374], eax
00A557DB call 0xa5e240
00A557E0 add esp, 0xc
00A557E3 mov dword ptr [ebp - 0x378], eax
00A557E9 mov ecx, dword ptr [ebp - 0x378]
00A557EF mov dword ptr [ebp - 0x74], ecx
00A557F2 push 0
00A557F4 push 0xba4598 ; 'Difficulty'
00A557F9 push ecx
00A557FA mov ecx, esp
00A557FC mov dword ptr [ebp - 0x138], esp
00A55802 lea edx, [ebp - 0x1c]
00A55805 push edx
00A55806 call 0x4199e0
00A5580B mov dword ptr [ebp - 0x37c], eax
00A55811 call 0xa5e240
00A55816 add esp, 0xc
00A55819 mov dword ptr [ebp - 0x380], eax
00A5581F mov eax, dword ptr [ebp - 0x380]
00A55825 mov dword ptr [ebp - 0x68], eax
00A55828 push 0
00A5582A push 0xba45a4 ; 'NeedTitleLevel'
00A5582F push ecx
00A55830 mov ecx, esp
00A55832 mov dword ptr [ebp - 0x13c], esp
00A55838 lea edx, [ebp - 0x1c]
00A5583B push edx
00A5583C call 0x4199e0
00A55841 mov dword ptr [ebp - 0x384], eax
00A55847 call 0xa5e240
00A5584C add esp, 0xc
00A5584F mov dword ptr [ebp - 0x388], eax
00A55855 mov eax, dword ptr [ebp - 0x388]
00A5585B mov dword ptr [ebp - 0x64], eax
00A5585E push 0
00A55860 push 0xba45b4 ; 'MaxPlayer'
00A55865 push ecx
00A55866 mov ecx, esp
00A55868 mov dword ptr [ebp - 0x140], esp
00A5586E lea edx, [ebp - 0x1c]
00A55871 push edx
00A55872 call 0x4199e0
00A55877 mov dword ptr [ebp - 0x38c], eax
00A5587D call 0xa5e240
00A55882 add esp, 0xc
00A55885 mov dword ptr [ebp - 0x390], eax
00A5588B mov eax, dword ptr [ebp - 0x390]
00A55891 mov dword ptr [ebp - 0x70], eax
00A55894 push 0
00A55896 push 0xba45c0 ; 'Music'
00A5589B push ecx
00A5589C mov ecx, esp
00A5589E mov dword ptr [ebp - 0x144], esp
00A558A4 lea edx, [ebp - 0x1c]
00A558A7 push edx
00A558A8 call 0x4199e0
00A558AD mov dword ptr [ebp - 0x394], eax
00A558B3 call 0xa5e240
00A558B8 add esp, 0xc
00A558BB mov dword ptr [ebp - 0x398], eax
00A558C1 mov eax, dword ptr [ebp - 0x398]
00A558C7 mov dword ptr [ebp - 0x6c], eax
00A558CA push 0
00A558CC push 0xba45c8
00A558D1 push ecx
00A558D2 mov ecx, esp
00A558D4 mov dword ptr [ebp - 0x148], esp
00A558DA lea edx, [ebp - 0x1c]
00A558DD push edx
00A558DE call 0x4199e0
00A558E3 mov dword ptr [ebp - 0x39c], eax
00A558E9 call 0xa5e240
00A558EE add esp, 0xc
00A558F1 mov dword ptr [ebp - 0x3a0], eax
00A558F7 xor eax, eax
00A558F9 cmp dword ptr [ebp - 0x3a0], 0
00A55900 setne al
00A55903 mov dword ptr [ebp - 0x4c], eax
00A55906 push 0
00A55908 push 0xba45cc
00A5590D push ecx
00A5590E mov ecx, esp
00A55910 mov dword ptr [ebp - 0x14c], esp
00A55916 lea edx, [ebp - 0x1c]
00A55919 push edx
00A5591A call 0x4199e0
00A5591F mov dword ptr [ebp - 0x3a4], eax
00A55925 call 0xa5e240
00A5592A add esp, 0xc
00A5592D mov dword ptr [ebp - 0x3a8], eax
00A55933 xor eax, eax
00A55935 cmp dword ptr [ebp - 0x3a8], 0
00A5593C setne al
00A5593F mov dword ptr [ebp - 0x48], eax
00A55942 sub esp, 0x54
00A55945 mov ecx, esp
00A55947 mov dword ptr [ebp - 0x1a8], esp
00A5594D lea edx, [ebp - 0x7c]
00A55950 push edx
00A55951 call 0x4812b0
00A55956 mov dword ptr [ebp - 0x3ac], eax
00A5595C mov eax, dword ptr [ebp - 0x84]
00A55962 push eax
00A55963 lea ecx, [ebp - 0x200]
00A55969 push ecx
00A5596A call 0x485420
00A5596F add esp, 0x5c
00A55972 mov dword ptr [ebp - 0x3b0], eax
00A55978 mov edx, dword ptr [ebp - 0x3b0]
00A5597E mov dword ptr [ebp - 0x3b4], edx
00A55984 mov byte ptr [ebp - 4], 0xb
00A55988 mov eax, dword ptr [ebp - 0x3b4]
00A5598E push eax
00A5598F lea ecx, [ebp - 0x1a4]
00A55995 call 0x4851c0
00A5599A mov byte ptr [ebp - 4], 0xc
00A5599E lea ecx, [ebp - 0x1a4]
00A559A4 push ecx
00A559A5 lea edx, [ebp - 0x20c]
00A559AB push edx
00A559AC mov ecx, dword ptr [ebp - 0x314]
00A559B2 add ecx, 0x1c
00A559B5 call 0x4816c0
00A559BA mov byte ptr [ebp - 4], 0xb
00A559BE lea ecx, [ebp - 0x1a4]
00A559C4 call 0x4813f0
00A559C9 mov byte ptr [ebp - 4], 5
00A559CD lea ecx, [ebp - 0x200]
00A559D3 call 0x4813f0
00A559D8 mov byte ptr [ebp - 4], 3
00A559DC lea ecx, [ebp - 0x7c]
00A559DF call 0x481260
00A559E4 jmp 0xa55495
00A559E9 push 0xba45d0 ; '/RandomMap'
00A559EE lea eax, [ebp - 0x10]
00A559F1 push eax
00A559F2 mov ecx, dword ptr [ebp - 0x314]
00A559F8 mov ecx, dword ptr [ecx + 0x18]
00A559FB call 0xa5e650
00A55A00 mov byte ptr [ebp - 4], 0xd
00A55A04 push 0
00A55A06 lea ecx, [ebp - 0x14]
00A55A09 call 0x56db30
00A55A0E mov byte ptr [ebp - 4], 0xe
00A55A12 lea edx, [ebp - 0x214]
00A55A18 push edx
00A55A19 lea ecx, [ebp - 0x10]
00A55A1C call 0x419eb0
00A55A21 mov ecx, eax
00A55A23 call 0x416170
00A55A28 mov dword ptr [ebp - 0x3b8], eax
00A55A2E mov eax, dword ptr [ebp - 0x3b8]
00A55A34 mov dword ptr [ebp - 0x3bc], eax
00A55A3A mov byte ptr [ebp - 4], 0xf
00A55A3E push 0
00A55A40 mov ecx, dword ptr [ebp - 0x3bc]
00A55A46 push ecx
00A55A47 lea ecx, [ebp - 0x14]
00A55A4A call 0x4193c0
00A55A4F mov ecx, eax
00A55A51 call 0x4263b0
00A55A56 mov byte ptr [ebp - 0x20d], al
00A55A5C mov byte ptr [ebp - 4], 0xe
00A55A60 lea ecx, [ebp - 0x214]
00A55A66 call 0x416d30
00A55A6B movzx edx, byte ptr [ebp - 0x20d]
00A55A72 test edx, edx
00A55A74 je 0xa55ec3
00A55A7A push 0
00A55A7C push 0xba454c ; 'MapId'
00A55A81 push ecx
00A55A82 mov ecx, esp
00A55A84 mov dword ptr [ebp - 0x218], esp
00A55A8A lea eax, [ebp - 0x14]
00A55A8D push eax
00A55A8E call 0x4199e0
00A55A93 mov dword ptr [ebp - 0x3c0], eax
00A55A99 call 0xa5e240
00A55A9E add esp, 0xc
00A55AA1 mov dword ptr [ebp - 0x3c4], eax
00A55AA7 mov ecx, dword ptr [ebp - 0x3c4]
00A55AAD mov dword ptr [ebp - 0xec], ecx
00A55AB3 push 0
00A55AB5 push 0xba4554 ; 'Priority'
00A55ABA push ecx
00A55ABB mov ecx, esp
00A55ABD mov dword ptr [ebp - 0x21c], esp
00A55AC3 lea edx, [ebp - 0x14]
00A55AC6 push edx
00A55AC7 call 0x4199e0
00A55ACC mov dword ptr [ebp - 0x3c8], eax
00A55AD2 call 0xa5e240
00A55AD7 add esp, 0xc
00A55ADA mov dword ptr [ebp - 0x3cc], eax
00A55AE0 mov eax, dword ptr [ebp - 0x3cc]
00A55AE6 mov dword ptr [ebp - 0x88], eax
00A55AEC lea ecx, [ebp - 0xe4]
00A55AF2 call 0x4811c0
00A55AF7 mov byte ptr [ebp - 4], 0x10
00A55AFB mov ecx, dword ptr [ebp - 0x88]
00A55B01 mov dword ptr [ebp - 0xe0], ecx
00A55B07 mov edx, dword ptr [ebp - 0xec]
00A55B0D mov dword ptr [ebp - 0xe4], edx
00A55B13 mov dword ptr [ebp - 0xdc], 0
00A55B1D push 0xb96699
00A55B22 push 0xb9c324 ; 'Name'
00A55B27 push ecx
00A55B28 mov ecx, esp
00A55B2A mov dword ptr [ebp - 0x220], esp
00A55B30 lea eax, [ebp - 0x14]
00A55B33 push eax
00A55B34 call 0x4199e0
00A55B39 mov dword ptr [ebp - 0x3d0], eax
00A55B3F lea ecx, [ebp - 0x224]
00A55B45 push ecx
00A55B46 call 0xa60260
00A55B4B add esp, 0x10
00A55B4E mov dword ptr [ebp - 0x3d4], eax
00A55B54 mov edx, dword ptr [ebp - 0x3d4]
00A55B5A mov dword ptr [ebp - 0x3d8], edx
00A55B60 mov byte ptr [ebp - 4], 0x11
00A55B64 mov eax, dword ptr [ebp - 0x3d8]
00A55B6A push eax
00A55B6B lea ecx, [ebp - 0xc8]
00A55B71 call 0x406070
00A55B76 mov byte ptr [ebp - 4], 0x10
00A55B7A lea ecx, [ebp - 0x224]
00A55B80 call 0x406050
00A55B85 push 0xb96699
00A55B8A push 0xba4588 ; 'PicName'
00A55B8F push ecx
00A55B90 mov ecx, esp
00A55B92 mov dword ptr [ebp - 0x228], esp
00A55B98 lea edx, [ebp - 0x14]
00A55B9B push edx
00A55B9C call 0x4199e0
00A55BA1 mov dword ptr [ebp - 0x3dc], eax
00A55BA7 lea eax, [ebp - 0x22c]
00A55BAD push eax
00A55BAE call 0xa60260
00A55BB3 add esp, 0x10
00A55BB6 mov dword ptr [ebp - 0x3e0], eax
00A55BBC mov ecx, dword ptr [ebp - 0x3e0]
00A55BC2 mov dword ptr [ebp - 0x3e4], ecx
00A55BC8 mov byte ptr [ebp - 4], 0x12
00A55BCC mov edx, dword ptr [ebp - 0x3e4]
00A55BD2 push edx
00A55BD3 lea ecx, [ebp - 0xbc]
00A55BD9 call 0x406070
00A55BDE mov byte ptr [ebp - 4], 0x10
00A55BE2 lea ecx, [ebp - 0x22c]
00A55BE8 call 0x406050
00A55BED push 0xb96699
00A55BF2 push 0xba4590 ; 'Intro'
00A55BF7 push ecx
00A55BF8 mov ecx, esp
00A55BFA mov dword ptr [ebp - 0x230], esp
00A55C00 lea eax, [ebp - 0x14]
00A55C03 push eax
00A55C04 call 0x4199e0
00A55C09 mov dword ptr [ebp - 0x3e8], eax
00A55C0F lea ecx, [ebp - 0x234]
00A55C15 push ecx
00A55C16 call 0xa60260
00A55C1B add esp, 0x10
00A55C1E mov dword ptr [ebp - 0x3ec], eax
00A55C24 mov edx, dword ptr [ebp - 0x3ec]
00A55C2A mov dword ptr [ebp - 0x3f0], edx
00A55C30 mov byte ptr [ebp - 4], 0x13
00A55C34 mov eax, dword ptr [ebp - 0x3f0]
00A55C3A push eax
00A55C3B lea ecx, [ebp - 0xb8]
00A55C41 call 0x406070
00A55C46 mov byte ptr [ebp - 4], 0x10
00A55C4A lea ecx, [ebp - 0x234]
00A55C50 call 0x406050
00A55C55 mov dword ptr [ebp - 0xcc], 0
00A55C5F push 0
00A55C61 push 0xba45c8
00A55C66 push ecx
00A55C67 mov ecx, esp
00A55C69 mov dword ptr [ebp - 0x238], esp
00A55C6F lea edx, [ebp - 0x14]
00A55C72 push edx
00A55C73 call 0x4199e0
00A55C78 mov dword ptr [ebp - 0x3f4], eax
00A55C7E call 0xa5e240
00A55C83 add esp, 0xc
00A55C86 mov dword ptr [ebp - 0x3f8], eax
00A55C8C xor eax, eax
00A55C8E cmp dword ptr [ebp - 0x3f8], 0
00A55C95 setne al
00A55C98 mov dword ptr [ebp - 0xb4], eax
00A55C9E push 0
00A55CA0 push 0xba45cc
00A55CA5 push ecx
00A55CA6 mov ecx, esp
00A55CA8 mov dword ptr [ebp - 0x23c], esp
00A55CAE lea edx, [ebp - 0x14]
00A55CB1 push edx
00A55CB2 call 0x4199e0
00A55CB7 mov dword ptr [ebp - 0x3fc], eax
00A55CBD call 0xa5e240
00A55CC2 add esp, 0xc
00A55CC5 mov dword ptr [ebp - 0x400], eax
00A55CCB xor eax, eax
00A55CCD cmp dword ptr [ebp - 0x400], 0
00A55CD4 setne al
00A55CD7 mov dword ptr [ebp - 0xb0], eax
00A55CDD push ecx
00A55CDE mov ecx, esp
00A55CE0 mov dword ptr [ebp - 0x240], esp
00A55CE6 push 0xba4210
00A55CEB call 0x425e10
00A55CF0 mov dword ptr [ebp - 0x404], eax
00A55CF6 mov ecx, dword ptr [ebp - 0x404]
00A55CFC mov dword ptr [ebp - 0x408], ecx
00A55D02 mov byte ptr [ebp - 4], 0x14
00A55D06 lea edx, [ebp - 0xe8]
00A55D0C push edx
00A55D0D lea ecx, [ebp - 0x14]
00A55D10 call 0x419eb0
00A55D15 mov byte ptr [ebp - 4], 0x10
00A55D19 mov ecx, eax
00A55D1B call 0x426070
00A55D20 mov dword ptr [ebp - 0x40c], eax
00A55D26 mov byte ptr [ebp - 4], 0x15
00A55D2A push 0
00A55D2C lea ecx, [ebp - 0x8c]
00A55D32 call 0x56db30
00A55D37 mov byte ptr [ebp - 4], 0x16
00A55D3B lea eax, [ebp - 0x248]
00A55D41 push eax
00A55D42 lea ecx, [ebp - 0xe8]
00A55D48 call 0x419eb0
00A55D4D mov ecx, eax
00A55D4F call 0x416170
00A55D54 mov dword ptr [ebp - 0x410], eax
00A55D5A mov ecx, dword ptr [ebp - 0x410]
00A55D60 mov dword ptr [ebp - 0x414], ecx
00A55D66 mov byte ptr [ebp - 4], 0x17
00A55D6A push 0
00A55D6C mov edx, dword ptr [ebp - 0x414]
00A55D72 push edx
00A55D73 lea ecx, [ebp - 0x8c]
00A55D79 call 0x4193c0
00A55D7E mov ecx, eax
00A55D80 call 0x4263b0
00A55D85 mov byte ptr [ebp - 0x241], al
00A55D8B mov byte ptr [ebp - 4], 0x16
00A55D8F lea ecx, [ebp - 0x248]
00A55D95 call 0x416d30
00A55D9A movzx eax, byte ptr [ebp - 0x241]
00A55DA1 test eax, eax
00A55DA3 je 0xa55df8
00A55DA5 push 0
00A55DA7 push 0xba454c ; 'MapId'
00A55DAC push ecx
00A55DAD mov ecx, esp
00A55DAF mov dword ptr [ebp - 0x24c], esp
00A55DB5 lea edx, [ebp - 0x8c]
00A55DBB push edx
00A55DBC call 0x4199e0
00A55DC1 mov dword ptr [ebp - 0x418], eax
00A55DC7 call 0xa5e240
00A55DCC add esp, 0xc
00A55DCF mov dword ptr [ebp - 0x41c], eax
00A55DD5 mov eax, dword ptr [ebp - 0x41c]
00A55DDB mov dword ptr [ebp - 0xf0], eax
00A55DE1 lea ecx, [ebp - 0xf0]
00A55DE7 push ecx
00A55DE8 lea ecx, [ebp - 0xa8]
00A55DEE call 0x4a5c30
00A55DF3 jmp 0xa55d3b
00A55DF8 sub esp, 0x54
00A55DFB mov ecx, esp
00A55DFD mov dword ptr [ebp - 0x2a8], esp
00A55E03 lea edx, [ebp - 0xe4]
00A55E09 push edx
00A55E0A call 0x4812b0
00A55E0F mov dword ptr [ebp - 0x420], eax
00A55E15 mov eax, dword ptr [ebp - 0xec]
00A55E1B push eax
00A55E1C lea ecx, [ebp - 0x300]
00A55E22 push ecx
00A55E23 call 0x485420
00A55E28 add esp, 0x5c
00A55E2B mov dword ptr [ebp - 0x424], eax
00A55E31 mov edx, dword ptr [ebp - 0x424]
00A55E37 mov dword ptr [ebp - 0x428], edx
00A55E3D mov byte ptr [ebp - 4], 0x18
00A55E41 mov eax, dword ptr [ebp - 0x428]
00A55E47 push eax
00A55E48 lea ecx, [ebp - 0x2a4]
00A55E4E call 0x4851c0
00A55E53 mov byte ptr [ebp - 4], 0x19
00A55E57 lea ecx, [ebp - 0x2a4]
00A55E5D push ecx
00A55E5E lea edx, [ebp - 0x30c]
00A55E64 push edx
00A55E65 mov ecx, dword ptr [ebp - 0x314]
00A55E6B add ecx, 0x1c
00A55E6E call 0x4816c0
00A55E73 mov byte ptr [ebp - 4], 0x18
00A55E77 lea ecx, [ebp - 0x2a4]
00A55E7D call 0x4813f0
00A55E82 mov byte ptr [ebp - 4], 0x16
00A55E86 lea ecx, [ebp - 0x300]
00A55E8C call 0x4813f0
00A55E91 mov byte ptr [ebp - 4], 0x15
00A55E95 lea ecx, [ebp - 0x8c]
00A55E9B call 0x416d30
00A55EA0 mov byte ptr [ebp - 4], 0x10
00A55EA4 lea ecx, [ebp - 0xe8]
00A55EAA call 0x416d30
00A55EAF mov byte ptr [ebp - 4], 0xe
00A55EB3 lea ecx, [ebp - 0xe4]
00A55EB9 call 0x481260
00A55EBE jmp 0xa55a12
00A55EC3 mov dword ptr [ebp - 0x310], 1
00A55ECD mov byte ptr [ebp - 4], 0xd
00A55ED1 lea ecx, [ebp - 0x14]
00A55ED4 call 0x416d30
00A55ED9 mov byte ptr [ebp - 4], 3
00A55EDD lea ecx, [ebp - 0x10]
00A55EE0 call 0x416d30
00A55EE5 mov byte ptr [ebp - 4], 2
00A55EE9 lea ecx, [ebp - 0x1c]
00A55EEC call 0x416d30
00A55EF1 mov byte ptr [ebp - 4], 1
00A55EF5 lea ecx, [ebp - 0x18]
00A55EF8 call 0x416d30
00A55EFD mov byte ptr [ebp - 4], 0
00A55F01 lea ecx, [ebp + 8]
00A55F04 call 0x406050
00A55F09 mov dword ptr [ebp - 4], 0xffffffff
00A55F10 lea ecx, [ebp + 0xc]
00A55F13 call 0x406050
00A55F18 mov eax, dword ptr [ebp - 0x310]
00A55F1E mov ecx, dword ptr [ebp - 0xc]
00A55F21 mov dword ptr fs:[0], ecx
00A55F28 pop ecx
00A55F29 mov esp, ebp
00A55F2B pop ebp
00A55F2C ret 8
; FUNCTION 00A56560
00A56560 push ebp
00A56561 mov ebp, esp
00A56563 push -1
00A56565 push 0xac423b
00A5656A mov eax, dword ptr fs:[0]
00A56570 push eax
00A56571 sub esp, 0x10c
00A56577 push esi
00A56578 push edi
00A56579 mov eax, dword ptr [0xc7b480]
00A5657E xor eax, ebp
00A56580 push eax
00A56581 lea eax, [ebp - 0xc]
00A56584 mov dword ptr fs:[0], eax
00A5658A mov dword ptr [ebp - 0x118], ecx
00A56590 mov ecx, dword ptr [ebp + 8]
00A56593 call 0x481ae0
00A56598 lea ecx, [ebp - 0x24]
00A5659B call 0x516f30
00A565A0 mov dword ptr [ebp - 4], 0
00A565A7 lea eax, [ebp - 0x24]
00A565AA push eax
00A565AB mov ecx, dword ptr [ebp + 0xc]
00A565AE push ecx
00A565AF mov edx, dword ptr [0x17c8694]
00A565B5 push edx
00A565B6 call 0xa96780
00A565BB mov ecx, eax
00A565BD call 0xa96220
00A565C2 lea eax, [ebp - 0x2c]
00A565C5 push eax
00A565C6 mov ecx, dword ptr [ebp - 0x118]
00A565CC add ecx, 0x1c
00A565CF call 0x5504a0
00A565D4 jmp 0xa565de
00A565D6 lea ecx, [ebp - 0x2c]
00A565D9 call 0x481960
00A565DE lea ecx, [ebp - 0x114]
00A565E4 push ecx
00A565E5 mov ecx, dword ptr [ebp - 0x118]
00A565EB add ecx, 0x1c
00A565EE call 0x45abb0
00A565F3 push eax
00A565F4 lea ecx, [ebp - 0x2c]
00A565F7 call 0x4ab8f0
00A565FC movzx edx, al
00A565FF test edx, edx
00A56601 je 0xa56740
00A56607 lea ecx, [ebp - 0x2c]
00A5660A call 0x4305b0
00A5660F add eax, 4
00A56612 push eax
00A56613 lea ecx, [ebp - 0x84]
00A56619 call 0x4812b0
00A5661E mov byte ptr [ebp - 4], 1
00A56622 mov eax, dword ptr [ebp - 0x7c]
00A56625 xor edx, edx
00A56627 mov ecx, 0xa
00A5662C div ecx
00A5662E test edx, edx
00A56630 jne 0xa5672c
00A56636 mov dword ptr [ebp - 0x88], 0
00A56640 jmp 0xa56651
00A56642 mov edx, dword ptr [ebp - 0x88]
00A56648 add edx, 1
00A5664B mov dword ptr [ebp - 0x88], edx
00A56651 lea ecx, [ebp - 0x24]
00A56654 call 0x54bf20
00A56659 cmp dword ptr [ebp - 0x88], eax
00A5665F jae 0xa5672c
00A56665 mov eax, dword ptr [ebp - 0x88]
00A5666B push eax
00A5666C lea ecx, [ebp - 0x24]
00A5666F call 0x481930
00A56674 mov ecx, dword ptr [eax + 8]
00A56677 mov dword ptr [ebp - 0x8c], ecx
00A5667D cmp dword ptr [ebp - 0x8c], 0
00A56684 jne 0xa56688
00A56686 jmp 0xa56642
00A56688 cmp dword ptr [ebp - 0x8c], 3
00A5668F jne 0xa566a5
00A56691 mov ecx, dword ptr [0x17c86fc]
00A56697 call 0x481080
00A5669C movzx edx, al
00A5669F test edx, edx
00A566A1 jne 0xa566a5
00A566A3 jmp 0xa56642
00A566A5 mov eax, dword ptr [ebp - 0x88]
00A566AB push eax
00A566AC lea ecx, [ebp - 0x24]
00A566AF call 0x481930
00A566B4 mov ecx, dword ptr [eax + 4]
00A566B7 cmp ecx, dword ptr [ebp - 0x84]
00A566BD jne 0xa56727
00A566BF lea ecx, [ebp - 0x10c]
00A566C5 call 0x481440
00A566CA mov byte ptr [ebp - 4], 2
00A566CE lea edx, [ebp - 0x84]
00A566D4 push edx
00A566D5 lea ecx, [ebp - 0x10c]
00A566DB call 0x481480
00A566E0 mov eax, dword ptr [ebp - 0x88]
00A566E6 push eax
00A566E7 lea ecx, [ebp - 0x24]
00A566EA call 0x481930
00A566EF mov ecx, 0xb
00A566F4 mov esi, eax
00A566F6 lea edi, [ebp - 0xb8]
00A566FC rep movsd dword ptr es:[edi], dword ptr [esi]
00A566FE lea ecx, [ebp - 0x10c]
00A56704 push ecx
00A56705 lea edx, [ebp - 0x80]
00A56708 push edx
00A56709 mov ecx, dword ptr [ebp + 8]
00A5670C call 0x481980
00A56711 mov ecx, eax
00A56713 call 0x481580
00A56718 mov byte ptr [ebp - 4], 1
00A5671C lea ecx, [ebp - 0x10c]
00A56722 call 0x481460
00A56727 jmp 0xa56642
00A5672C mov byte ptr [ebp - 4], 0
00A56730 lea ecx, [ebp - 0x84]
00A56736 call 0x481260
00A5673B jmp 0xa565d6
00A56740 mov dword ptr [ebp - 4], 0xffffffff
00A56747 lea ecx, [ebp - 0x24]
00A5674A call 0x516fa0
00A5674F mov ecx, dword ptr [ebp - 0xc]
00A56752 mov dword ptr fs:[0], ecx
00A56759 pop ecx
00A5675A pop edi
00A5675B pop esi
00A5675C mov esp, ebp
00A5675E pop ebp
