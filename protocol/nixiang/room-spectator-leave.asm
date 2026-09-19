; SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b
; 3130 UID leave: participant slots first, spectator removal fallback.

; Block 0xb25b72
00B25B72 mov dword ptr [0x12fe928], 0xc3a
00B25B7C mov dword ptr [0x12fe92c], 1
00B25B86 mov dword ptr [ebp - 0x60], 0x8207b0
00B25B8D mov dword ptr [ebp - 0x5c], 0

; Block 0x8207d8
008207D8 cmp dword ptr [ebp + 8], 0
008207DC je 0x8207e4
008207DE cmp dword ptr [ebp + 0xc], 8
008207E2 je 0x8207e9
008207E4 jmp 0x8209b9
008207E9 mov eax, dword ptr [ebp + 8]
008207EC mov dword ptr [ebp - 0x14], eax
008207EF mov ecx, dword ptr [ebp - 0x14]
008207F2 mov edx, dword ptr [ecx + 4]
008207F5 push edx
008207F6 mov eax, dword ptr [ecx]
008207F8 push eax
008207F9 mov ecx, dword ptr [0x17c8708]
008207FF call 0x818c00
00820804 push eax
00820805 mov ecx, dword ptr [0x17c8708]
0082080B call 0x818450
00820810 mov dword ptr [ebp - 0x10], eax
00820813 cmp dword ptr [ebp - 0x10], 0

; Block 0x82095a
0082095A push 1
0082095C mov ecx, dword ptr [ebp - 0x14]
0082095F mov edx, dword ptr [ecx + 4]
00820962 push edx
00820963 mov eax, dword ptr [ecx]
00820965 push eax
00820966 mov ecx, dword ptr [0x17c8708]
0082096C call 0x81c7b0

; Block 0x81c7b0
0081C7B0 push ebp
0081C7B1 mov ebp, esp
0081C7B3 sub esp, 0x18
0081C7B6 mov dword ptr [ebp - 8], ecx
0081C7B9 mov dword ptr [ebp - 4], 0
0081C7C0 jmp 0x81c7cb
0081C7C2 mov eax, dword ptr [ebp - 4]
0081C7C5 add eax, 1
0081C7C8 mov dword ptr [ebp - 4], eax
0081C7CB cmp dword ptr [ebp - 4], 8
0081C7CF jae 0x81c885
0081C7D5 lea ecx, [ebp - 4]
0081C7D8 push ecx
0081C7D9 mov ecx, dword ptr [ebp - 8]
0081C7DC add ecx, 0x2d8
0081C7E2 call 0x4b6920
0081C7E7 cmp dword ptr [eax], 0
0081C7EA je 0x81c880
0081C7F0 lea edx, [ebp - 4]
0081C7F3 push edx
0081C7F4 mov ecx, dword ptr [ebp - 8]
0081C7F7 add ecx, 0x2d8
0081C7FD call 0x4b6920
0081C802 mov eax, dword ptr [eax]
0081C804 push eax
0081C805 mov ecx, dword ptr [ebp - 8]
0081C808 call 0x817fa0
0081C80D mov dword ptr [ebp - 0x10], eax
0081C810 mov dword ptr [ebp - 0xc], edx
0081C813 mov ecx, dword ptr [ebp - 0x10]
0081C816 cmp ecx, dword ptr [ebp + 8]
0081C819 jne 0x81c880
0081C81B mov edx, dword ptr [ebp - 0xc]
0081C81E cmp edx, dword ptr [ebp + 0xc]
0081C821 jne 0x81c880
0081C823 mov ecx, dword ptr [0x17c86fc]
0081C829 call 0x402aa0
0081C82E mov dword ptr [ebp - 0x18], eax
0081C831 mov dword ptr [ebp - 0x14], edx
0081C834 mov eax, dword ptr [ebp + 8]
0081C837 cmp eax, dword ptr [ebp - 0x18]
0081C83A jne 0x81c844
0081C83C mov ecx, dword ptr [ebp + 0xc]
0081C83F cmp ecx, dword ptr [ebp - 0x14]
0081C842 je 0x81c870
0081C844 cmp dword ptr [ebp + 0x10], 0
0081C848 je 0x81c870
0081C84A lea edx, [ebp - 4]
0081C84D push edx
0081C84E mov ecx, dword ptr [ebp - 8]
0081C851 add ecx, 0x2d8
0081C857 call 0x4b6920
0081C85C mov ecx, dword ptr [eax]
0081C85E call 0x453630
0081C863 push eax
0081C864 call 0x7d0b90
0081C869 mov ecx, eax
0081C86B call 0x7d0970
0081C870 mov eax, dword ptr [ebp - 4]
0081C873 push eax
0081C874 mov ecx, dword ptr [ebp - 8]
0081C877 call 0x81bc10
0081C87C mov al, 1
0081C87E jmp 0x81c897
0081C880 jmp 0x81c7c2
0081C885 push 1
0081C887 mov ecx, dword ptr [ebp + 0xc]
0081C88A push ecx
0081C88B mov edx, dword ptr [ebp + 8]
0081C88E push edx
0081C88F mov ecx, dword ptr [ebp - 8]
0081C892 call 0x81bd90
0081C897 mov esp, ebp
0081C899 pop ebp

; Block 0x81bd90
0081BD90 push ebp
0081BD91 mov ebp, esp
0081BD93 sub esp, 0x2c
0081BD96 mov dword ptr [ebp - 0x24], ecx
0081BD99 lea eax, [ebp + 8]
0081BD9C push eax
0081BD9D lea ecx, [ebp - 8]
0081BDA0 push ecx
0081BDA1 mov ecx, dword ptr [ebp - 0x24]
0081BDA4 add ecx, 0x98
0081BDAA call 0x511d60
0081BDAF lea edx, [ebp - 0x10]
0081BDB2 push edx
0081BDB3 mov ecx, dword ptr [ebp - 0x24]
0081BDB6 add ecx, 0x98
0081BDBC call 0x45abb0
0081BDC1 push eax
0081BDC2 lea ecx, [ebp - 8]
0081BDC5 call 0x4ab8f0
0081BDCA movzx eax, al
0081BDCD test eax, eax
0081BDCF je 0x81be57
0081BDD5 mov ecx, dword ptr [0x17c86fc]
0081BDDB call 0x402aa0
0081BDE0 mov dword ptr [ebp - 0x2c], eax
0081BDE3 mov dword ptr [ebp - 0x28], edx
0081BDE6 mov ecx, dword ptr [ebp + 8]
0081BDE9 cmp ecx, dword ptr [ebp - 0x2c]
0081BDEC jne 0x81bdf6
0081BDEE mov edx, dword ptr [ebp + 0xc]
0081BDF1 cmp edx, dword ptr [ebp - 0x28]
0081BDF4 je 0x81be14
0081BDF6 cmp dword ptr [ebp + 0x10], 0
0081BDFA je 0x81be14
0081BDFC lea ecx, [ebp - 8]
0081BDFF call 0x569150
0081BE04 mov eax, dword ptr [eax + 0x4b]
0081BE07 push eax
0081BE08 call 0x7d0b90
0081BE0D mov ecx, eax
0081BE0F call 0x7d0970
0081BE14 mov ecx, dword ptr [ebp - 8]
0081BE17 mov dword ptr [ebp - 0x18], ecx
0081BE1A mov edx, dword ptr [ebp - 4]
0081BE1D mov dword ptr [ebp - 0x14], edx
0081BE20 mov eax, dword ptr [ebp - 0x14]
0081BE23 push eax
0081BE24 mov ecx, dword ptr [ebp - 0x18]
0081BE27 push ecx
0081BE28 lea edx, [ebp - 0x20]
0081BE2B push edx
0081BE2C mov ecx, dword ptr [ebp - 0x24]
0081BE2F add ecx, 0x98
0081BE35 call 0x54b280
0081BE3A mov ecx, dword ptr [0x17c8708]
0081BE40 call 0x81b800
0081BE45 mov ecx, eax
0081BE47 call 0x54ae90
0081BE4C mov ecx, eax
0081BE4E call 0x894f40
0081BE53 mov al, 1
0081BE55 jmp 0x81be59
0081BE57 xor al, al
0081BE59 mov esp, ebp
0081BE5B pop ebp
0081BE5C ret 0xc
