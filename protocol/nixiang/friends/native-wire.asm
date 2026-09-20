SDFriend.dll SHA256 a48c1890e2a24730862e91be7fb5b7101edd9cab5938cec113ade97be552b2ae

RANGE 0x100010b0
100010b0 push ebp
100010b1 mov ebp, esp
100010b3 mov eax, 0xa018
100010b8 call 0x1000ac70
100010bd mov eax, dword ptr [0x1001e118]
100010c2 xor eax, ebp
100010c4 mov dword ptr [ebp - 0xc], eax
100010c7 mov dword ptr [ebp - 0xa014], ecx
100010cd cmp dword ptr [ebp + 8], 0
100010d1 je 0x100010d9
100010d3 cmp dword ptr [ebp + 0xc], 4
100010d7 jae 0x100010de
100010d9 jmp 0x10001261
100010de mov eax, dword ptr [ebp + 8]
100010e1 mov dword ptr [ebp - 4], eax
100010e4 mov ecx, dword ptr [ebp + 8]
100010e7 add ecx, 4
100010ea mov dword ptr [ebp - 8], ecx
100010ed lea edx, [ebp - 0xa010]
100010f3 push edx
100010f4 mov eax, dword ptr [ebp + 0xc]
100010f7 push eax
100010f8 mov ecx, dword ptr [ebp - 4]
100010fb movzx edx, byte ptr [ecx + 3]
100010ff add edx, dword ptr [ebp - 8]
10001102 push edx
10001103 mov eax, dword ptr [ebp - 4]
10001106 movzx ecx, word ptr [eax]
10001109 push ecx
1000110a mov ecx, dword ptr [ebp - 0xa014]
10001110 call 0x10007550
10001115 mov edx, dword ptr [ebp - 4]
10001118 movzx eax, word ptr [edx]
1000111b mov dword ptr [ebp - 0xa018], eax
10001121 mov ecx, dword ptr [ebp - 0xa018]
10001127 sub ecx, 0xcc
1000112d mov dword ptr [ebp - 0xa018], ecx
10001133 cmp dword ptr [ebp - 0xa018], 0x18
1000113a ja 0x10001261
10001140 mov edx, dword ptr [ebp - 0xa018]
10001146 movzx eax, byte ptr [edx + 0x100012ac]
1000114d jmp dword ptr [eax*4 + 0x10001274]
10001154 lea ecx, [ebp - 0xa010]
1000115a push ecx
1000115b mov ecx, dword ptr [ebp - 0xa014]
10001161 call 0x100012d0
10001166 jmp 0x10001261
1000116b lea edx, [ebp - 0xa010]
10001171 push edx
10001172 mov ecx, dword ptr [ebp - 0xa014]
10001178 call 0x10001310
1000117d jmp 0x10001261
10001182 lea eax, [ebp - 0xa010]
10001188 push eax
10001189 mov ecx, dword ptr [ebp - 0xa014]
1000118f call 0x100015a0
10001194 jmp 0x10001261
10001199 lea ecx, [ebp - 0xa010]
1000119f push ecx
100011a0 mov ecx, dword ptr [ebp - 0xa014]
100011a6 call 0x10001600
100011ab jmp 0x10001261
100011b0 lea edx, [ebp - 0xa010]
100011b6 push edx
100011b7 mov ecx, dword ptr [ebp - 0xa014]
100011bd call 0x10001670
100011c2 jmp 0x10001261
100011c7 lea eax, [ebp - 0xa010]
100011cd push eax
100011ce mov ecx, dword ptr [ebp - 0xa014]
100011d4 call 0x100016b0
100011d9 jmp 0x10001261
100011de lea ecx, [ebp - 0xa010]
100011e4 push ecx
100011e5 mov ecx, dword ptr [ebp - 0xa014]
100011eb call 0x10001880
100011f0 jmp 0x10001261
100011f2 lea edx, [ebp - 0xa010]
100011f8 push edx
100011f9 mov ecx, dword ptr [ebp - 0xa014]
100011ff call 0x10001910
10001204 jmp 0x10001261
10001206 lea eax, [ebp - 0xa010]
1000120c push eax
1000120d mov ecx, dword ptr [ebp - 0xa014]
10001213 call 0x10001950
10001218 jmp 0x10001261
1000121a lea ecx, [ebp - 0xa010]
10001220 push ecx
10001221 mov ecx, dword ptr [ebp - 0xa014]
10001227 call 0x10001990
1000122c jmp 0x10001261
1000122e lea edx, [ebp - 0xa010]
10001234 push edx
10001235 mov ecx, dword ptr [ebp - 0xa014]
1000123b call 0x10001440
10001240 jmp 0x10001261
10001242 mov ecx, dword ptr [ebp - 0xa014]
10001248 call 0x100019d0
1000124d jmp 0x10001261
1000124f lea eax, [ebp - 0xa010]
10001255 push eax
10001256 mov ecx, dword ptr [ebp - 0xa014]
1000125c call 0x10001a00
10001261 mov ecx, dword ptr [ebp - 0xc]
10001264 xor ecx, ebp
10001266 call 0x1000ac5c
1000126b mov esp, ebp
1000126d pop ebp
1000126e ret 8

RANGE 0x10001440
10001440 push ebp
10001441 mov ebp, esp
10001443 sub esp, 8
10001446 mov dword ptr [ebp - 4], ecx
10001449 mov eax, dword ptr [ebp + 8]
1000144c movzx ecx, byte ptr [eax]
1000144f test ecx, ecx
10001451 jne 0x1000147c
10001453 mov edx, dword ptr [ebp - 4]
10001456 mov ecx, dword ptr [edx + 0x10014]
1000145c call 0x10002e10
10001461 mov dword ptr [ebp - 8], eax
10001464 push 0
10001466 push 0
10001468 push 0
1000146a push 0
1000146c mov eax, dword ptr [ebp - 8]
1000146f push eax
10001470 mov ecx, dword ptr [ebp - 8]
10001473 mov edx, dword ptr [ecx]
10001475 mov eax, dword ptr [edx + 0xc]
10001478 call eax
1000147a jmp 0x100014b4
1000147c mov ecx, dword ptr [ebp + 8]
1000147f movzx edx, byte ptr [ecx]
10001482 cmp edx, 0xb
10001485 jne 0x10001498
10001487 mov eax, dword ptr [ebp + 8]
1000148a add eax, 4
1000148d push eax
1000148e mov ecx, dword ptr [ebp - 4]
10001491 call 0x100014c0
10001496 jmp 0x100014b4
10001498 mov ecx, dword ptr [ebp + 8]
1000149b movzx edx, byte ptr [ecx]
1000149e cmp edx, 0xc
100014a1 jne 0x100014b4
100014a3 mov eax, dword ptr [ebp + 8]
100014a6 add eax, 0x17f4
100014ab push eax
100014ac mov ecx, dword ptr [ebp - 4]
100014af call 0x10001550
100014b4 mov esp, ebp
100014b6 pop ebp
100014b7 ret 4
100014c0 push ebp
100014c1 mov ebp, esp
100014c3 push ecx
100014c4 mov dword ptr [ebp - 4], ecx
100014c7 mov eax, dword ptr [ebp + 8]
100014ca movzx ecx, word ptr [eax + 4]
100014ce cmp ecx, 0x64
100014d1 jg 0x100014df
100014d3 mov edx, dword ptr [ebp + 8]
100014d6 movzx eax, byte ptr [edx + 6]
100014da cmp eax, 0xa
100014dd jle 0x100014e1
100014df jmp 0x1000154a
100014e1 mov ecx, dword ptr [ebp + 8]
100014e4 mov edx, dword ptr [ecx]
100014e6 push edx
100014e7 mov eax, dword ptr [ebp - 4]
100014ea mov ecx, dword ptr [eax + 0x10014]
100014f0 call 0x10002e30
100014f5 mov ecx, dword ptr [ebp + 8]
100014f8 movzx edx, word ptr [ecx + 4]
100014fc push edx
100014fd mov eax, dword ptr [ebp + 8]
10001500 add eax, 7
10001503 push eax
10001504 mov ecx, dword ptr [ebp + 8]
10001507 add ecx, 0x9e0
1000150d push ecx
1000150e mov edx, dword ptr [ebp - 4]
10001511 mov ecx, dword ptr [edx + 0x10014]
10001517 call 0x100029f0
1000151c mov eax, dword ptr [ebp + 8]
1000151f movzx ecx, byte ptr [eax + 6]
10001523 push ecx
10001524 mov edx, dword ptr [ebp + 8]
10001527 add edx, 0x903
1000152d push edx
1000152e mov eax, dword ptr [ebp - 4]
10001531 mov ecx, dword ptr [eax + 0x10014]
10001537 call 0x10002be0
1000153c mov ecx, dword ptr [ebp - 4]
1000153f mov ecx, dword ptr [ecx + 0x10014]
10001545 call 0x10002e50
1000154a mov esp, ebp
1000154c pop ebp
1000154d ret 4
10001550 push ebp
10001551 mov ebp, esp
10001553 push ecx
10001554 mov dword ptr [ebp - 4], ecx
10001557 mov eax, dword ptr [ebp + 8]
1000155a movzx ecx, word ptr [eax]
1000155d cmp ecx, 0x64
10001560 jle 0x10001564
10001562 jmp 0x10001595
10001564 mov edx, dword ptr [ebp + 8]
10001567 movzx eax, word ptr [edx]
1000156a push eax
1000156b mov ecx, dword ptr [ebp + 8]
1000156e add ecx, 2
10001571 push ecx
10001572 mov edx, dword ptr [ebp + 8]
10001575 add edx, 0x68
10001578 push edx
10001579 mov eax, dword ptr [ebp - 4]
1000157c mov ecx, dword ptr [eax + 0x10014]
10001582 call 0x10002c80
10001587 mov ecx, dword ptr [ebp - 4]
1000158a mov ecx, dword ptr [ecx + 0x10014]
10001590 call 0x10002e50
10001595 mov esp, ebp
10001597 pop ebp
10001598 ret 4
100015a0 push ebp
100015a1 mov ebp, esp
100015a3 sub esp, 8
100015a6 mov dword ptr [ebp - 4], ecx
100015a9 mov eax, dword ptr [ebp + 8]
100015ac mov ecx, dword ptr [eax]
100015ae xor edx, edx
100015b0 push edx
100015b1 push ecx
100015b2 mov eax, dword ptr [ebp + 8]
100015b5 add eax, 4
100015b8 push eax
100015b9 mov ecx, dword ptr [ebp - 4]
100015bc mov ecx, dword ptr [ecx + 0x10014]
100015c2 call 0x10002710
100015c7 mov edx, dword ptr [ebp - 4]
100015ca mov ecx, dword ptr [edx + 0x10014]
100015d0 call 0x10002e10
100015d5 mov dword ptr [ebp - 8], eax
100015d8 mov eax, dword ptr [ebp + 8]
100015db add eax, 0x19
100015de push eax
100015df mov ecx, dword ptr [ebp + 8]
100015e2 add ecx, 4
100015e5 push ecx
100015e6 mov edx, dword ptr [ebp - 8]
100015e9 push edx
100015ea mov eax, dword ptr [ebp - 8]
100015ed mov ecx, dword ptr [eax]
100015ef mov edx, dword ptr [ecx + 0x10]
100015f2 call edx
100015f4 mov esp, ebp
100015f6 pop ebp
100015f7 ret 4
10001600 push ebp
10001601 mov ebp, esp
10001603 sub esp, 0xc
10001606 mov dword ptr [ebp - 4], ecx
10001609 mov eax, dword ptr [ebp + 8]
1000160c movzx ecx, byte ptr [eax]
1000160f cmp ecx, 1
10001612 jne 0x1000163e
10001614 mov edx, dword ptr [ebp - 4]
10001617 mov ecx, dword ptr [edx + 0x10014]
1000161d call 0x10002e10
10001622 mov dword ptr [ebp - 8], eax
10001625 mov eax, dword ptr [ebp + 8]
10001628 add eax, 1
1000162b push eax
1000162c push 1
1000162e mov ecx, dword ptr [ebp - 8]
10001631 push ecx
10001632 mov edx, dword ptr [ebp - 8]
10001635 mov eax, dword ptr [edx]
10001637 mov ecx, dword ptr [eax + 0x28]
1000163a call ecx
1000163c jmp 0x10001666
1000163e mov edx, dword ptr [ebp - 4]
10001641 mov ecx, dword ptr [edx + 0x10014]
10001647 call 0x10002e10
1000164c mov dword ptr [ebp - 0xc], eax
1000164f mov eax, dword ptr [ebp + 8]
10001652 add eax, 1
10001655 push eax
10001656 push 0
10001658 mov ecx, dword ptr [ebp - 0xc]
1000165b push ecx
1000165c mov edx, dword ptr [ebp - 0xc]
1000165f mov eax, dword ptr [edx]
10001661 mov ecx, dword ptr [eax + 0x14]
10001664 call ecx
10001666 mov esp, ebp
10001668 pop ebp
10001669 ret 4

RANGE 0x10001e60
10001e60 push ebp
10001e61 mov ebp, esp
10001e63 sub esp, 0x10
10001e66 mov eax, dword ptr [ebp + 8]
10001e69 cmp dword ptr [eax + 0xc], 0
10001e6d jne 0x10001e76
10001e6f xor al, al
10001e71 jmp 0x10001efa
10001e76 movzx ecx, byte ptr [ebp + 0xc]
10001e7a cmp ecx, 1
10001e7d jne 0x10001e88
10001e7f mov dword ptr [ebp - 0x10], 0
10001e86 jmp 0x10001e91
10001e88 mov edx, dword ptr [ebp + 8]
10001e8b mov eax, dword ptr [edx + 0x58]
10001e8e mov dword ptr [ebp - 0x10], eax
10001e91 mov ecx, dword ptr [ebp - 0x10]
10001e94 mov dword ptr [ebp - 0xc], ecx
10001e97 mov edx, dword ptr [ebp + 0x14]
10001e9a push edx
10001e9b mov eax, dword ptr [ebp + 0x10]
10001e9e add eax, 4
10001ea1 push eax
10001ea2 lea ecx, [ebp - 0xc]
10001ea5 push ecx
10001ea6 push 0xe1
10001eab mov ecx, 0x1001f360
10001eb0 call 0x10007500
10001eb5 mov dword ptr [ebp - 4], eax
10001eb8 cmp dword ptr [ebp - 4], 0
10001ebc jge 0x10001ec2
10001ebe xor al, al
10001ec0 jmp 0x10001efa
10001ec2 push 0
10001ec4 push 0
10001ec6 mov edx, dword ptr [ebp - 4]
10001ec9 push edx
10001eca mov eax, dword ptr [ebp + 0x10]
10001ecd push eax
10001ece push 0xe1
10001ed3 mov ecx, dword ptr [ebp + 8]
10001ed6 call 0x100025f0
10001edb mov dword ptr [ebp - 8], eax
10001ede mov ecx, dword ptr [ebp - 8]
10001ee1 push ecx
10001ee2 mov edx, dword ptr [ebp + 0x10]
10001ee5 push edx
10001ee6 mov eax, dword ptr [ebp + 8]
10001ee9 mov ecx, dword ptr [eax + 0xc]
10001eec mov edx, dword ptr [ebp + 8]
10001eef mov eax, dword ptr [edx + 0xc]
10001ef2 mov ecx, dword ptr [ecx]
10001ef4 push eax
10001ef5 mov edx, dword ptr [ecx + 0x34]
10001ef8 call edx
10001efa mov esp, ebp
10001efc pop ebp
10001efd ret 0x10
10001f00 push ebp
10001f01 mov ebp, esp
10001f03 sub esp, 0xf0
10001f09 mov eax, dword ptr [0x1001e118]
10001f0e xor eax, ebp
10001f10 mov dword ptr [ebp - 0xc], eax
10001f13 mov eax, dword ptr [ebp + 8]
10001f16 cmp dword ptr [eax + 0xc], 0
10001f1a jne 0x10001f23
10001f1c xor al, al
10001f1e jmp 0x10001fc5
10001f23 push 0xdd
10001f28 push 0
10001f2a lea ecx, [ebp - 0xf0]
10001f30 push ecx
10001f31 call 0x1000aca0
10001f36 add esp, 0xc
10001f39 mov edx, dword ptr [ebp + 0xc]
10001f3c push edx
10001f3d lea eax, [ebp - 0xf0]
10001f43 push eax
10001f44 call 0x10001a40
10001f49 add esp, 8
10001f4c mov ecx, dword ptr [ebp + 0x10]
10001f4f push ecx
10001f50 lea edx, [ebp - 0xdb]
10001f56 push edx
10001f57 call 0x100065a0
10001f5c add esp, 8
10001f5f mov eax, dword ptr [ebp + 0x18]
10001f62 push eax
10001f63 mov ecx, dword ptr [ebp + 0x14]
10001f66 add ecx, 4
10001f69 push ecx
10001f6a lea edx, [ebp - 0xf0]
10001f70 push edx
10001f71 push 0xcf
10001f76 mov ecx, 0x1001f360
10001f7b call 0x10007500
10001f80 mov dword ptr [ebp - 4], eax
10001f83 cmp dword ptr [ebp - 4], 0
10001f87 jge 0x10001f8d
10001f89 xor al, al
10001f8b jmp 0x10001fc5
10001f8d push 0
10001f8f push 0
10001f91 mov eax, dword ptr [ebp - 4]
10001f94 push eax
10001f95 mov ecx, dword ptr [ebp + 0x14]
10001f98 push ecx
10001f99 push 0xcf
10001f9e mov ecx, dword ptr [ebp + 8]
10001fa1 call 0x100025f0
10001fa6 mov dword ptr [ebp - 8], eax
10001fa9 mov edx, dword ptr [ebp - 8]
10001fac push edx
10001fad mov eax, dword ptr [ebp + 0x14]
10001fb0 push eax
10001fb1 mov ecx, dword ptr [ebp + 8]
10001fb4 mov edx, dword ptr [ecx + 0xc]
10001fb7 mov eax, dword ptr [ebp + 8]
10001fba mov ecx, dword ptr [eax + 0xc]
10001fbd mov edx, dword ptr [edx]
10001fbf push ecx
10001fc0 mov eax, dword ptr [edx + 0x34]
10001fc3 call eax
10001fc5 mov ecx, dword ptr [ebp - 0xc]
10001fc8 xor ecx, ebp
10001fca call 0x1000ac5c
10001fcf mov esp, ebp
10001fd1 pop ebp
10001fd2 ret 0x14
10001fe0 push ebp
10001fe1 mov ebp, esp
10001fe3 sub esp, 0x34
10001fe6 mov eax, dword ptr [0x1001e118]
10001feb xor eax, ebp
10001fed mov dword ptr [ebp - 4], eax
10001ff0 mov eax, dword ptr [ebp + 8]
10001ff3 cmp dword ptr [eax + 0xc], 0
10001ff7 jne 0x10002000
10001ff9 xor al, al
10001ffb jmp 0x100020b7
10002000 mov ecx, dword ptr [ebp + 0x10]
10002003 push ecx
10002004 mov ecx, dword ptr [ebp + 8]
10002007 call 0x10002790
1000200c mov dword ptr [ebp - 0x30], eax
1000200f mov dword ptr [ebp - 0x2c], edx
10002012 mov edx, dword ptr [ebp - 0x30]
10002015 or edx, dword ptr [ebp - 0x2c]
10002018 jne 0x10002021
1000201a xor al, al
1000201c jmp 0x100020b7
10002021 push 0x1c
10002023 push 0
10002025 lea eax, [ebp - 0x20]
10002028 push eax
10002029 call 0x1000aca0
1000202e add esp, 0xc
10002031 movzx ecx, byte ptr [ebp + 0xc]
10002035 neg ecx
10002037 sbb ecx, ecx
10002039 neg ecx
1000203b mov byte ptr [ebp - 0x1c], cl
1000203e mov edx, dword ptr [ebp - 0x30]
10002041 mov dword ptr [ebp - 0x20], edx
10002044 mov eax, dword ptr [ebp + 0x10]
10002047 push eax
10002048 lea ecx, [ebp - 0x1b]
1000204b push ecx
1000204c call 0x10001a40
10002051 add esp, 8
10002054 mov edx, dword ptr [ebp + 0x18]
10002057 push edx
10002058 mov eax, dword ptr [ebp + 0x14]
1000205b add eax, 4
1000205e push eax
1000205f lea ecx, [ebp - 0x20]
10002062 push ecx
10002063 push 0xd1
10002068 mov ecx, 0x1001f360
1000206d call 0x10007500
10002072 mov dword ptr [ebp - 0x24], eax
10002075 cmp dword ptr [ebp - 0x24], 0
10002079 jge 0x1000207f
1000207b xor al, al
1000207d jmp 0x100020b7
1000207f push 0
10002081 push 0
10002083 mov edx, dword ptr [ebp - 0x24]
10002086 push edx
10002087 mov eax, dword ptr [ebp + 0x14]
1000208a push eax
1000208b push 0xd1
10002090 mov ecx, dword ptr [ebp + 8]
10002093 call 0x100025f0
10002098 mov dword ptr [ebp - 0x34], eax
1000209b mov ecx, dword ptr [ebp - 0x34]
1000209e push ecx
1000209f mov edx, dword ptr [ebp + 0x14]
100020a2 push edx
100020a3 mov eax, dword ptr [ebp + 8]
100020a6 mov ecx, dword ptr [eax + 0xc]
100020a9 mov edx, dword ptr [ebp + 8]
100020ac mov eax, dword ptr [edx + 0xc]
100020af mov ecx, dword ptr [ecx]
100020b1 push eax
100020b2 mov edx, dword ptr [ecx + 0x34]
100020b5 call edx
100020b7 mov ecx, dword ptr [ebp - 4]
100020ba xor ecx, ebp
100020bc call 0x1000ac5c
100020c1 mov esp, ebp
100020c3 pop ebp
100020c4 ret 0x14
100020d0 push ebp
100020d1 mov ebp, esp
100020d3 sub esp, 0x24
100020d6 mov eax, dword ptr [0x1001e118]
100020db xor eax, ebp
100020dd mov dword ptr [ebp - 0xc], eax
100020e0 mov eax, dword ptr [ebp + 8]
100020e3 cmp dword ptr [eax + 0xc], 0
100020e7 jne 0x100020f0
100020e9 xor al, al
100020eb jmp 0x10002173
100020f0 push 0x15
100020f2 push 0
100020f4 lea ecx, [ebp - 0x24]
100020f7 push ecx
100020f8 call 0x1000aca0
100020fd add esp, 0xc
10002100 mov edx, dword ptr [ebp + 0xc]
10002103 push edx
10002104 lea eax, [ebp - 0x24]
10002107 push eax
10002108 call 0x10001a40
1000210d add esp, 8
10002110 mov ecx, dword ptr [ebp + 0x14]
10002113 push ecx
10002114 mov edx, dword ptr [ebp + 0x10]
10002117 add edx, 4
1000211a push edx
1000211b lea eax, [ebp - 0x24]
1000211e push eax
1000211f push 0xd5
10002124 mov ecx, 0x1001f360
10002129 call 0x10007500
1000212e mov dword ptr [ebp - 4], eax
10002131 cmp dword ptr [ebp - 4], 0
10002135 jge 0x1000213b
10002137 xor al, al
10002139 jmp 0x10002173
1000213b push 0
1000213d push 0
1000213f mov ecx, dword ptr [ebp - 4]
10002142 push ecx
10002143 mov edx, dword ptr [ebp + 0x10]
10002146 push edx
10002147 push 0xd5
1000214c mov ecx, dword ptr [ebp + 8]
1000214f call 0x100025f0
10002154 mov dword ptr [ebp - 8], eax
10002157 mov eax, dword ptr [ebp - 8]
1000215a push eax
1000215b mov ecx, dword ptr [ebp + 0x10]
1000215e push ecx
1000215f mov edx, dword ptr [ebp + 8]
10002162 mov eax, dword ptr [edx + 0xc]
10002165 mov ecx, dword ptr [ebp + 8]
10002168 mov edx, dword ptr [ecx + 0xc]
1000216b mov eax, dword ptr [eax]
1000216d push edx
1000216e mov ecx, dword ptr [eax + 0x34]
10002171 call ecx
10002173 mov ecx, dword ptr [ebp - 0xc]
10002176 xor ecx, ebp
10002178 call 0x1000ac5c
1000217d mov esp, ebp
1000217f pop ebp

RANGE 0x100025f0
100025f0 push ebp
100025f1 mov ebp, esp
100025f3 sub esp, 8
100025f6 mov dword ptr [ebp - 8], ecx
100025f9 push 4
100025fb push 0
100025fd lea eax, [ebp - 4]
10002600 push eax
10002601 call 0x1000aca0
10002606 add esp, 0xc
10002609 mov cx, word ptr [ebp + 8]
1000260d mov word ptr [ebp - 4], cx
10002611 mov dl, byte ptr [ebp + 0x14]
10002614 mov byte ptr [ebp - 1], dl
10002617 push 4
10002619 lea eax, [ebp - 4]
1000261c push eax
1000261d mov ecx, dword ptr [ebp + 0xc]
10002620 push ecx
10002621 call 0x1000af70
10002626 add esp, 0xc
10002629 cmp dword ptr [ebp + 0x18], 0
1000262d je 0x10002647
1000262f movzx edx, byte ptr [ebp + 0x14]
10002633 push edx
10002634 mov eax, dword ptr [ebp + 0x18]
10002637 push eax
10002638 mov ecx, dword ptr [ebp + 0xc]
1000263b add ecx, 4
1000263e push ecx
1000263f call 0x1000af70
10002644 add esp, 0xc
10002647 movzx edx, byte ptr [ebp - 1]
1000264b mov eax, dword ptr [ebp + 0x10]
1000264e lea eax, [eax + edx + 4]
10002652 mov esp, ebp
10002654 pop ebp
10002655 ret 0x14
10002660 push ebp
10002661 mov ebp, esp
10002663 mov eax, dword ptr [ebp + 0x10]
10002666 push eax
10002667 mov ecx, dword ptr [ebp + 0xc]
1000266a push ecx
1000266b mov edx, dword ptr [ebp + 8]
1000266e mov ecx, dword ptr [edx + 8]
10002671 call 0x100010b0
10002676 pop ebp

RANGE 0x10007830
10007830 push ebp
10007831 mov ebp, esp
10007833 sub esp, 8
10007836 mov dword ptr [ebp - 8], ecx
10007839 mov eax, dword ptr [ebp + 8]
1000783c mov dword ptr [ebp - 4], eax
1000783f mov ecx, dword ptr [ebp - 4]
10007842 movzx edx, byte ptr [ecx]
10007845 push edx
10007846 mov ecx, dword ptr [ebp - 8]
10007849 add ecx, 0x10000
1000784f call 0x10009f60
10007854 cmp eax, -1
10007857 jne 0x1000785e
10007859 or eax, 0xffffffff
1000785c jmp 0x10007885
1000785e mov eax, dword ptr [ebp - 4]
10007861 add eax, 1
10007864 push eax
10007865 mov ecx, dword ptr [ebp - 8]
10007868 call 0x10007600
1000786d cmp eax, -1
10007870 jne 0x10007877
10007872 or eax, 0xffffffff
10007875 jmp 0x10007885
10007877 mov ecx, dword ptr [ebp - 8]
1000787a add ecx, 0x10000
10007880 call 0x10009f40
10007885 mov esp, ebp
10007887 pop ebp
10007888 ret 4
10007890 push ebp
10007891 mov ebp, esp
10007893 sub esp, 8
10007896 mov dword ptr [ebp - 8], ecx
10007899 mov eax, dword ptr [ebp + 8]
1000789c mov dword ptr [ebp - 4], eax
1000789f mov ecx, dword ptr [ebp - 4]
100078a2 push ecx
100078a3 mov ecx, dword ptr [ebp - 8]
100078a6 add ecx, 0x10000
100078ac call 0x10009fb0
100078b1 cmp eax, -1
100078b4 jne 0x100078bb
100078b6 or eax, 0xffffffff
100078b9 jmp 0x100078d9
100078bb mov edx, dword ptr [ebp - 4]
100078be add edx, 1
100078c1 push edx
100078c2 mov ecx, dword ptr [ebp - 8]
100078c5 call 0x10007670
100078ca cmp eax, -1
100078cd jne 0x100078d4
100078cf or eax, 0xffffffff
100078d2 jmp 0x100078d9
100078d4 mov eax, 0x17
100078d9 mov esp, ebp
100078db pop ebp
100078dc ret 4
100078e0 push ebp
100078e1 mov ebp, esp
100078e3 sub esp, 8
100078e6 mov dword ptr [ebp - 8], ecx
100078e9 mov eax, dword ptr [ebp + 8]
100078ec mov dword ptr [ebp - 4], eax
100078ef mov ecx, dword ptr [ebp - 4]
100078f2 movzx edx, byte ptr [ecx]
100078f5 push edx
100078f6 mov ecx, dword ptr [ebp - 8]
100078f9 add ecx, 0x10000
100078ff call 0x10009f60
10007904 cmp eax, -1
10007907 jne 0x1000790e
10007909 or eax, 0xffffffff
1000790c jmp 0x10007935
1000790e mov eax, dword ptr [ebp - 4]
10007911 add eax, 1
10007914 push eax
10007915 mov ecx, dword ptr [ebp - 8]
10007918 call 0x10007600
1000791d cmp eax, -1
10007920 jne 0x10007927
10007922 or eax, 0xffffffff
10007925 jmp 0x10007935
10007927 mov ecx, dword ptr [ebp - 8]
1000792a add ecx, 0x10000
10007930 call 0x10009f40
10007935 mov esp, ebp
10007937 pop ebp
10007938 ret 4
10007940 push ebp
10007941 mov ebp, esp
10007943 sub esp, 8
10007946 mov dword ptr [ebp - 8], ecx
10007949 mov eax, dword ptr [ebp + 8]
1000794c mov dword ptr [ebp - 4], eax
1000794f mov ecx, dword ptr [ebp - 4]
10007952 push ecx
10007953 mov ecx, dword ptr [ebp - 8]
10007956 add ecx, 0x10000
1000795c call 0x10009fb0
10007961 cmp eax, -1
10007964 jne 0x1000796b
10007966 or eax, 0xffffffff
10007969 jmp 0x10007989
1000796b mov edx, dword ptr [ebp - 4]
1000796e add edx, 1
10007971 push edx
10007972 mov ecx, dword ptr [ebp - 8]
10007975 call 0x10007670
1000797a cmp eax, -1
1000797d jne 0x10007984
1000797f or eax, 0xffffffff
10007982 jmp 0x10007989
10007984 mov eax, 0x17
10007989 mov esp, ebp
1000798b pop ebp
1000798c ret 4

RANGE 0x10007a90
10007a90 push ebp
10007a91 mov ebp, esp
10007a93 sub esp, 8
10007a96 mov dword ptr [ebp - 8], ecx
10007a99 mov eax, dword ptr [ebp + 8]
10007a9c mov dword ptr [ebp - 4], eax
10007a9f mov ecx, dword ptr [ebp - 4]
10007aa2 mov edx, dword ptr [ecx]
10007aa4 push edx
10007aa5 mov ecx, dword ptr [ebp - 8]
10007aa8 add ecx, 0x10000
10007aae call 0x1000a230
10007ab3 cmp eax, -1
10007ab6 jne 0x10007ac0
10007ab8 or eax, 0xffffffff
10007abb jmp 0x10007bf6
10007ac0 mov eax, dword ptr [ebp - 4]
10007ac3 mov ecx, dword ptr [eax + 4]
10007ac6 push ecx
10007ac7 mov ecx, dword ptr [ebp - 8]
10007aca add ecx, 0x10000
10007ad0 call 0x1000a230
10007ad5 cmp eax, -1
10007ad8 jne 0x10007ae2
10007ada or eax, 0xffffffff
10007add jmp 0x10007bf6
10007ae2 mov edx, dword ptr [ebp - 4]
10007ae5 mov eax, dword ptr [edx + 8]
10007ae8 push eax
10007ae9 mov ecx, dword ptr [ebp - 8]
10007aec add ecx, 0x10000
10007af2 call 0x1000a230
10007af7 cmp eax, -1
10007afa jne 0x10007b04
10007afc or eax, 0xffffffff
10007aff jmp 0x10007bf6
10007b04 mov ecx, dword ptr [ebp - 4]
10007b07 movzx edx, byte ptr [ecx + 0xc]
10007b0b push edx
10007b0c mov ecx, dword ptr [ebp - 8]
10007b0f add ecx, 0x10000
10007b15 call 0x10009f60
10007b1a cmp eax, -1
10007b1d jne 0x10007b27
10007b1f or eax, 0xffffffff
10007b22 jmp 0x10007bf6
10007b27 mov eax, dword ptr [ebp - 4]
10007b2a movzx ecx, byte ptr [eax + 0xd]
10007b2e push ecx
10007b2f mov ecx, dword ptr [ebp - 8]
10007b32 add ecx, 0x10000
10007b38 call 0x10009f60
10007b3d cmp eax, -1
10007b40 jne 0x10007b4a
10007b42 or eax, 0xffffffff
10007b45 jmp 0x10007bf6
10007b4a mov edx, dword ptr [ebp - 4]
10007b4d mov eax, dword ptr [edx + 0x10]
10007b50 push eax
10007b51 mov ecx, dword ptr [ebp - 8]
10007b54 add ecx, 0x10000
10007b5a call 0x1000a2f0
10007b5f cmp eax, -1
10007b62 jne 0x10007b6c
10007b64 or eax, 0xffffffff
10007b67 jmp 0x10007bf6
10007b6c mov ecx, dword ptr [ebp - 4]
10007b6f mov edx, dword ptr [ecx + 0x14]
10007b72 push edx
10007b73 mov ecx, dword ptr [ebp - 8]
10007b76 add ecx, 0x10000
10007b7c call 0x1000a2f0
10007b81 cmp eax, -1
10007b84 jne 0x10007b8b
10007b86 or eax, 0xffffffff
10007b89 jmp 0x10007bf6
10007b8b mov eax, dword ptr [ebp - 4]
10007b8e mov ecx, dword ptr [eax + 0x18]
10007b91 push ecx
10007b92 mov ecx, dword ptr [ebp - 8]
10007b95 add ecx, 0x10000
10007b9b call 0x1000a230
10007ba0 cmp eax, -1
10007ba3 jne 0x10007baa
10007ba5 or eax, 0xffffffff
10007ba8 jmp 0x10007bf6
10007baa mov edx, dword ptr [ebp - 4]
10007bad mov eax, dword ptr [edx + 0x1c]
10007bb0 push eax
10007bb1 mov ecx, dword ptr [ebp - 8]
10007bb4 add ecx, 0x10000
10007bba call 0x1000a2f0
10007bbf cmp eax, -1
10007bc2 jne 0x10007bc9
10007bc4 or eax, 0xffffffff
10007bc7 jmp 0x10007bf6
10007bc9 mov ecx, dword ptr [ebp - 4]
10007bcc mov edx, dword ptr [ecx + 0x20]
10007bcf push edx
10007bd0 mov ecx, dword ptr [ebp - 8]
10007bd3 add ecx, 0x10000
10007bd9 call 0x1000a2f0
10007bde cmp eax, -1
10007be1 jne 0x10007be8
10007be3 or eax, 0xffffffff
10007be6 jmp 0x10007bf6
10007be8 mov ecx, dword ptr [ebp - 8]
10007beb add ecx, 0x10000
10007bf1 call 0x10009f40
10007bf6 mov esp, ebp
10007bf8 pop ebp
10007bf9 ret 4

RANGE 0x10008190
10008190 push ebp
10008191 mov ebp, esp
10008193 sub esp, 0xc
10008196 mov dword ptr [ebp - 0xc], ecx
10008199 mov eax, dword ptr [ebp + 8]
1000819c mov dword ptr [ebp - 8], eax
1000819f mov ecx, dword ptr [ebp - 8]
100081a2 mov edx, dword ptr [ecx]
100081a4 push edx
100081a5 mov ecx, dword ptr [ebp - 0xc]
100081a8 add ecx, 0x10000
100081ae call 0x1000a230
100081b3 cmp eax, -1
100081b6 jne 0x100081c0
100081b8 or eax, 0xffffffff
100081bb jmp 0x100082f5
100081c0 mov eax, dword ptr [ebp - 8]
100081c3 movzx ecx, word ptr [eax + 4]
100081c7 push ecx
100081c8 mov ecx, dword ptr [ebp - 0xc]
100081cb add ecx, 0x10000
100081d1 call 0x1000a0b0
100081d6 cmp eax, -1
100081d9 jne 0x100081e3
100081db or eax, 0xffffffff
100081de jmp 0x100082f5
100081e3 mov edx, dword ptr [ebp - 8]
100081e6 movzx eax, byte ptr [edx + 6]
100081ea push eax
100081eb mov ecx, dword ptr [ebp - 0xc]
100081ee add ecx, 0x10000
100081f4 call 0x10009f60
100081f9 cmp eax, -1
100081fc jne 0x10008206
100081fe or eax, 0xffffffff
10008201 jmp 0x100082f5
10008206 mov dword ptr [ebp - 4], 0
1000820d jmp 0x10008218
1000820f mov ecx, dword ptr [ebp - 4]
10008212 add ecx, 1
10008215 mov dword ptr [ebp - 4], ecx
10008218 cmp dword ptr [ebp - 4], 0x64
1000821c jge 0x10008251
1000821e mov edx, dword ptr [ebp - 8]
10008221 movzx eax, word ptr [edx + 4]
10008225 cmp dword ptr [ebp - 4], eax
10008228 jl 0x1000822c
1000822a jmp 0x10008251
1000822c mov ecx, dword ptr [ebp - 4]
1000822f imul ecx, ecx, 0x17
10008232 mov edx, dword ptr [ebp - 8]
10008235 lea eax, [edx + ecx + 7]
10008239 push eax
1000823a mov ecx, dword ptr [ebp - 0xc]
1000823d call 0x10007830
10008242 cmp eax, -1
10008245 jne 0x1000824f
10008247 or eax, 0xffffffff
1000824a jmp 0x100082f5
1000824f jmp 0x1000820f
10008251 mov dword ptr [ebp - 4], 0
10008258 jmp 0x10008263
1000825a mov ecx, dword ptr [ebp - 4]
1000825d add ecx, 1
10008260 mov dword ptr [ebp - 4], ecx
10008263 cmp dword ptr [ebp - 4], 0xa
10008267 jge 0x1000829c
10008269 mov edx, dword ptr [ebp - 8]
1000826c movzx eax, byte ptr [edx + 6]
10008270 cmp dword ptr [ebp - 4], eax
10008273 jl 0x10008277
10008275 jmp 0x1000829c
10008277 mov ecx, dword ptr [ebp - 4]
1000827a imul ecx, ecx, 0x16
1000827d mov edx, dword ptr [ebp - 8]
10008280 lea eax, [edx + ecx + 0x903]
10008287 push eax
10008288 mov ecx, dword ptr [ebp - 0xc]
1000828b call 0x100076d0
10008290 cmp eax, -1
10008293 jne 0x1000829a
10008295 or eax, 0xffffffff
10008298 jmp 0x100082f5
1000829a jmp 0x1000825a
1000829c mov dword ptr [ebp - 4], 0
100082a3 jmp 0x100082ae
100082a5 mov ecx, dword ptr [ebp - 4]
100082a8 add ecx, 1
100082ab mov dword ptr [ebp - 4], ecx
100082ae cmp dword ptr [ebp - 4], 0x64
100082b2 jge 0x100082e7
100082b4 mov edx, dword ptr [ebp - 8]
100082b7 movzx eax, word ptr [edx + 4]
100082bb cmp dword ptr [ebp - 4], eax
100082be jl 0x100082c2
100082c0 jmp 0x100082e7
100082c2 mov ecx, dword ptr [ebp - 4]
100082c5 imul ecx, ecx, 0x24
100082c8 mov edx, dword ptr [ebp - 8]
100082cb lea eax, [edx + ecx + 0x9e0]
100082d2 push eax
100082d3 mov ecx, dword ptr [ebp - 0xc]
100082d6 call 0x10007a90
100082db cmp eax, -1
100082de jne 0x100082e5
100082e0 or eax, 0xffffffff
100082e3 jmp 0x100082f5
100082e5 jmp 0x100082a5
100082e7 mov ecx, dword ptr [ebp - 0xc]
100082ea add ecx, 0x10000
100082f0 call 0x10009f40
100082f5 mov esp, ebp
100082f7 pop ebp
100082f8 ret 4

RANGE 0x10008610
10008610 push ebp
10008611 mov ebp, esp
10008613 sub esp, 8
10008616 mov dword ptr [ebp - 8], ecx
10008619 mov eax, dword ptr [ebp + 8]
1000861c mov dword ptr [ebp - 4], eax
1000861f mov ecx, dword ptr [ebp - 4]
10008622 push ecx
10008623 mov ecx, dword ptr [ebp - 8]
10008626 call 0x10008190
1000862b cmp eax, -1
1000862e jne 0x10008635
10008630 or eax, 0xffffffff
10008633 jmp 0x1000865f
10008635 mov edx, dword ptr [ebp - 4]
10008638 add edx, 0x17f0
1000863e push edx
1000863f mov ecx, dword ptr [ebp - 8]
10008642 call 0x10008460
10008647 cmp eax, -1
1000864a jne 0x10008651
1000864c or eax, 0xffffffff
1000864f jmp 0x1000865f
10008651 mov ecx, dword ptr [ebp - 8]
10008654 add ecx, 0x10000
1000865a call 0x10009f40
1000865f mov esp, ebp
10008661 pop ebp
10008662 ret 4
10008670 push ebp
10008671 mov ebp, esp
10008673 sub esp, 8
10008676 mov dword ptr [ebp - 8], ecx
10008679 mov eax, dword ptr [ebp + 8]
1000867c mov dword ptr [ebp - 4], eax
1000867f mov ecx, dword ptr [ebp - 4]
10008682 push ecx
10008683 mov ecx, dword ptr [ebp - 8]
10008686 call 0x10008300
1000868b cmp eax, -1
1000868e jne 0x10008695
10008690 or eax, 0xffffffff
10008693 jmp 0x100086b6
10008695 mov edx, dword ptr [ebp - 4]
10008698 add edx, 0x17f0
1000869e push edx
1000869f mov ecx, dword ptr [ebp - 8]
100086a2 call 0x10008540
100086a7 cmp eax, -1
100086aa jne 0x100086b1
100086ac or eax, 0xffffffff
100086af jmp 0x100086b6
100086b1 mov eax, 0x2668
100086b6 mov esp, ebp
100086b8 pop ebp
100086b9 ret 4
100086c0 push ebp
100086c1 mov ebp, esp
100086c3 sub esp, 8
100086c6 mov dword ptr [ebp - 8], ecx
100086c9 mov eax, dword ptr [ebp + 8]
100086cc mov dword ptr [ebp - 4], eax
100086cf mov ecx, dword ptr [ebp - 4]
100086d2 movzx edx, byte ptr [ecx]
100086d5 push edx
100086d6 mov ecx, dword ptr [ebp - 8]
100086d9 add ecx, 0x10000
100086df call 0x10009f60
100086e4 cmp eax, -1
100086e7 jne 0x100086ee
100086e9 or eax, 0xffffffff
100086ec jmp 0x10008715
100086ee mov eax, dword ptr [ebp - 4]
100086f1 add eax, 4
100086f4 push eax
100086f5 mov ecx, dword ptr [ebp - 8]
100086f8 call 0x10008610
100086fd cmp eax, -1
10008700 jne 0x10008707
10008702 or eax, 0xffffffff
10008705 jmp 0x10008715
10008707 mov ecx, dword ptr [ebp - 8]
1000870a add ecx, 0x10000
10008710 call 0x10009f40
10008715 mov esp, ebp
10008717 pop ebp
10008718 ret 4
10008720 push ebp
10008721 mov ebp, esp
10008723 sub esp, 8
10008726 mov dword ptr [ebp - 8], ecx
10008729 mov eax, dword ptr [ebp + 8]
1000872c mov dword ptr [ebp - 4], eax
1000872f mov ecx, dword ptr [ebp - 4]
10008732 push ecx
10008733 mov ecx, dword ptr [ebp - 8]
10008736 add ecx, 0x10000
1000873c call 0x10009fb0
10008741 cmp eax, -1
10008744 jne 0x1000874b
10008746 or eax, 0xffffffff
10008749 jmp 0x10008769
1000874b mov edx, dword ptr [ebp - 4]
1000874e add edx, 4
10008751 push edx
10008752 mov ecx, dword ptr [ebp - 8]
10008755 call 0x10008670
1000875a cmp eax, -1
1000875d jne 0x10008764
1000875f or eax, 0xffffffff
10008762 jmp 0x10008769
10008764 mov eax, 0x266c
10008769 mov esp, ebp
1000876b pop ebp
1000876c ret 4
10008770 push ebp
10008771 mov ebp, esp
10008773 sub esp, 8
10008776 mov dword ptr [ebp - 8], ecx
10008779 mov eax, dword ptr [ebp + 8]
1000877c mov dword ptr [ebp - 4], eax
1000877f push 0x15
10008781 mov ecx, dword ptr [ebp - 4]
10008784 push ecx
10008785 mov ecx, dword ptr [ebp - 8]
10008788 add ecx, 0x10000
1000878e call 0x1000a3b0
10008793 cmp eax, -1
10008796 jne 0x1000879d
10008798 or eax, 0xffffffff
1000879b jmp 0x100087cf
1000879d push 0xc8
100087a2 mov edx, dword ptr [ebp - 4]
100087a5 add edx, 0x15
100087a8 push edx
100087a9 mov ecx, dword ptr [ebp - 8]
100087ac add ecx, 0x10000
100087b2 call 0x1000a3b0
100087b7 cmp eax, -1
100087ba jne 0x100087c1
100087bc or eax, 0xffffffff
100087bf jmp 0x100087cf
100087c1 mov ecx, dword ptr [ebp - 8]
100087c4 add ecx, 0x10000
100087ca call 0x10009f40
100087cf mov esp, ebp
100087d1 pop ebp
100087d2 ret 4
100087e0 push ebp
100087e1 mov ebp, esp
100087e3 sub esp, 8
100087e6 mov dword ptr [ebp - 8], ecx
100087e9 mov eax, dword ptr [ebp + 8]
100087ec mov dword ptr [ebp - 4], eax
100087ef push 0x15
100087f1 mov ecx, dword ptr [ebp - 4]
100087f4 push ecx
100087f5 mov ecx, dword ptr [ebp - 8]
100087f8 add ecx, 0x10000
100087fe call 0x1000a440
10008803 cmp eax, -1
10008806 jne 0x1000880d
10008808 or eax, 0xffffffff
1000880b jmp 0x10008836
1000880d push 0xc8
10008812 mov edx, dword ptr [ebp - 4]
10008815 add edx, 0x15
10008818 push edx
10008819 mov ecx, dword ptr [ebp - 8]
1000881c add ecx, 0x10000
10008822 call 0x1000a440
10008827 cmp eax, -1
1000882a jne 0x10008831
1000882c or eax, 0xffffffff
1000882f jmp 0x10008836
10008831 mov eax, 0xdd
10008836 mov esp, ebp
10008838 pop ebp
10008839 ret 4
10008840 push ebp
10008841 mov ebp, esp
10008843 sub esp, 8
10008846 mov dword ptr [ebp - 8], ecx
10008849 mov eax, dword ptr [ebp + 8]
1000884c mov dword ptr [ebp - 4], eax
1000884f mov ecx, dword ptr [ebp - 4]
10008852 mov edx, dword ptr [ecx]
10008854 push edx
10008855 mov ecx, dword ptr [ebp - 8]
10008858 add ecx, 0x10000
1000885e call 0x1000a230
10008863 cmp eax, -1
10008866 jne 0x1000886d
10008868 or eax, 0xffffffff
1000886b jmp 0x100088c0
1000886d push 0x15
1000886f mov eax, dword ptr [ebp - 4]
10008872 add eax, 4
10008875 push eax
10008876 mov ecx, dword ptr [ebp - 8]
10008879 add ecx, 0x10000
1000887f call 0x1000a3b0
10008884 cmp eax, -1
10008887 jne 0x1000888e
10008889 or eax, 0xffffffff
1000888c jmp 0x100088c0
1000888e push 0xc8
10008893 mov ecx, dword ptr [ebp - 4]
10008896 add ecx, 0x19
10008899 push ecx
1000889a mov ecx, dword ptr [ebp - 8]
1000889d add ecx, 0x10000
100088a3 call 0x1000a3b0
100088a8 cmp eax, -1
100088ab jne 0x100088b2
100088ad or eax, 0xffffffff
100088b0 jmp 0x100088c0
100088b2 mov ecx, dword ptr [ebp - 8]
100088b5 add ecx, 0x10000
100088bb call 0x10009f40
100088c0 mov esp, ebp
100088c2 pop ebp
100088c3 ret 4
100088d0 push ebp
100088d1 mov ebp, esp
100088d3 sub esp, 8
100088d6 mov dword ptr [ebp - 8], ecx
100088d9 mov eax, dword ptr [ebp + 8]
100088dc mov dword ptr [ebp - 4], eax
100088df mov ecx, dword ptr [ebp - 4]
100088e2 push ecx
100088e3 mov ecx, dword ptr [ebp - 8]
100088e6 add ecx, 0x10000
100088ec call 0x1000a290
100088f1 cmp eax, -1
100088f4 jne 0x100088fb
100088f6 or eax, 0xffffffff
100088f9 jmp 0x10008945
100088fb push 0x15
100088fd mov edx, dword ptr [ebp - 4]
10008900 add edx, 4
10008903 push edx
10008904 mov ecx, dword ptr [ebp - 8]
10008907 add ecx, 0x10000
1000890d call 0x1000a440
10008912 cmp eax, -1
10008915 jne 0x1000891c
10008917 or eax, 0xffffffff
1000891a jmp 0x10008945
1000891c push 0xc8
10008921 mov eax, dword ptr [ebp - 4]
10008924 add eax, 0x19
10008927 push eax
10008928 mov ecx, dword ptr [ebp - 8]
1000892b add ecx, 0x10000
10008931 call 0x1000a440
10008936 cmp eax, -1
10008939 jne 0x10008940
1000893b or eax, 0xffffffff
1000893e jmp 0x10008945
10008940 mov eax, 0xe4
10008945 mov esp, ebp
10008947 pop ebp
10008948 ret 4
10008950 push ebp
10008951 mov ebp, esp
10008953 sub esp, 8
10008956 mov dword ptr [ebp - 8], ecx
10008959 mov eax, dword ptr [ebp + 8]
1000895c mov dword ptr [ebp - 4], eax
1000895f mov ecx, dword ptr [ebp - 4]
10008962 mov edx, dword ptr [ecx]
10008964 push edx
10008965 mov ecx, dword ptr [ebp - 8]
10008968 add ecx, 0x10000
1000896e call 0x1000a230
10008973 cmp eax, -1
10008976 jne 0x1000897d
10008978 or eax, 0xffffffff
1000897b jmp 0x100089cc
1000897d mov eax, dword ptr [ebp - 4]
10008980 movzx ecx, byte ptr [eax + 4]
10008984 push ecx
10008985 mov ecx, dword ptr [ebp - 8]
10008988 add ecx, 0x10000
1000898e call 0x10009f60
10008993 cmp eax, -1
10008996 jne 0x1000899d
10008998 or eax, 0xffffffff
1000899b jmp 0x100089cc
1000899d push 0x15
1000899f mov edx, dword ptr [ebp - 4]
100089a2 add edx, 5
100089a5 push edx
100089a6 mov ecx, dword ptr [ebp - 8]
100089a9 add ecx, 0x10000
100089af call 0x1000a3b0
100089b4 cmp eax, -1
100089b7 jne 0x100089be
100089b9 or eax, 0xffffffff
100089bc jmp 0x100089cc
100089be mov ecx, dword ptr [ebp - 8]
100089c1 add ecx, 0x10000
100089c7 call 0x10009f40
100089cc mov esp, ebp
100089ce pop ebp
100089cf ret 4
100089e0 push ebp
100089e1 mov ebp, esp
100089e3 sub esp, 8
100089e6 mov dword ptr [ebp - 8], ecx
100089e9 mov eax, dword ptr [ebp + 8]
100089ec mov dword ptr [ebp - 4], eax
100089ef mov ecx, dword ptr [ebp - 4]
100089f2 push ecx
100089f3 mov ecx, dword ptr [ebp - 8]
100089f6 add ecx, 0x10000
100089fc call 0x1000a290
10008a01 cmp eax, -1
10008a04 jne 0x10008a0b
10008a06 or eax, 0xffffffff
10008a09 jmp 0x10008a50
10008a0b mov edx, dword ptr [ebp - 4]
10008a0e add edx, 4
10008a11 push edx
10008a12 mov ecx, dword ptr [ebp - 8]
10008a15 add ecx, 0x10000
10008a1b call 0x10009fb0
10008a20 cmp eax, -1
10008a23 jne 0x10008a2a
10008a25 or eax, 0xffffffff
10008a28 jmp 0x10008a50
10008a2a push 0x15
10008a2c mov eax, dword ptr [ebp - 4]
10008a2f add eax, 5
10008a32 push eax
10008a33 mov ecx, dword ptr [ebp - 8]
10008a36 add ecx, 0x10000
10008a3c call 0x1000a440
10008a41 cmp eax, -1
10008a44 jne 0x10008a4b
10008a46 or eax, 0xffffffff
10008a49 jmp 0x10008a50
10008a4b mov eax, 0x1c
10008a50 mov esp, ebp
10008a52 pop ebp
10008a53 ret 4
10008a60 push ebp
10008a61 mov ebp, esp
10008a63 sub esp, 8
10008a66 mov dword ptr [ebp - 8], ecx
10008a69 mov eax, dword ptr [ebp + 8]
10008a6c mov dword ptr [ebp - 4], eax
10008a6f mov ecx, dword ptr [ebp - 4]
10008a72 movzx edx, byte ptr [ecx]
10008a75 push edx
10008a76 mov ecx, dword ptr [ebp - 8]
10008a79 add ecx, 0x10000
10008a7f call 0x10009f60
10008a84 cmp eax, -1
10008a87 jne 0x10008a8e
10008a89 or eax, 0xffffffff
10008a8c jmp 0x10008abd
10008a8e push 0x15
10008a90 mov eax, dword ptr [ebp - 4]
10008a93 add eax, 1
10008a96 push eax
10008a97 mov ecx, dword ptr [ebp - 8]
10008a9a add ecx, 0x10000
10008aa0 call 0x1000a3b0
10008aa5 cmp eax, -1
10008aa8 jne 0x10008aaf
10008aaa or eax, 0xffffffff
10008aad jmp 0x10008abd
10008aaf mov ecx, dword ptr [ebp - 8]
10008ab2 add ecx, 0x10000
10008ab8 call 0x10009f40
10008abd mov esp, ebp
10008abf pop ebp
10008ac0 ret 4
10008ad0 push ebp
10008ad1 mov ebp, esp
10008ad3 sub esp, 8
10008ad6 mov dword ptr [ebp - 8], ecx
10008ad9 mov eax, dword ptr [ebp + 8]
10008adc mov dword ptr [ebp - 4], eax
10008adf mov ecx, dword ptr [ebp - 4]
10008ae2 push ecx
10008ae3 mov ecx, dword ptr [ebp - 8]
10008ae6 add ecx, 0x10000
10008aec call 0x10009fb0
10008af1 cmp eax, -1
10008af4 jne 0x10008afb
10008af6 or eax, 0xffffffff
10008af9 jmp 0x10008b21
10008afb push 0x15
10008afd mov edx, dword ptr [ebp - 4]
10008b00 add edx, 1
10008b03 push edx
10008b04 mov ecx, dword ptr [ebp - 8]
10008b07 add ecx, 0x10000
10008b0d call 0x1000a440
10008b12 cmp eax, -1
10008b15 jne 0x10008b1c
10008b17 or eax, 0xffffffff
10008b1a jmp 0x10008b21
10008b1c mov eax, 0x16
10008b21 mov esp, ebp
10008b23 pop ebp
10008b24 ret 4

RANGE 0x10008c00
10008c00 push ebp
10008c01 mov ebp, esp
10008c03 sub esp, 8
10008c06 mov dword ptr [ebp - 8], ecx
10008c09 mov eax, dword ptr [ebp + 8]
10008c0c mov dword ptr [ebp - 4], eax
10008c0f mov ecx, dword ptr [ebp - 4]
10008c12 mov edx, dword ptr [ecx]
10008c14 push edx
10008c15 mov ecx, dword ptr [ebp - 8]
10008c18 add ecx, 0x10000
10008c1e call 0x1000a2f0
10008c23 cmp eax, -1
10008c26 jne 0x10008c2d
10008c28 or eax, 0xffffffff
10008c2b jmp 0x10008c5c
10008c2d push 0x15
10008c2f mov eax, dword ptr [ebp - 4]
10008c32 add eax, 4
10008c35 push eax
10008c36 mov ecx, dword ptr [ebp - 8]
10008c39 add ecx, 0x10000
10008c3f call 0x1000a3b0
10008c44 cmp eax, -1
10008c47 jne 0x10008c4e
10008c49 or eax, 0xffffffff
10008c4c jmp 0x10008c5c
10008c4e mov ecx, dword ptr [ebp - 8]
10008c51 add ecx, 0x10000
10008c57 call 0x10009f40
10008c5c mov esp, ebp
10008c5e pop ebp
10008c5f ret 4
10008c70 push ebp
10008c71 mov ebp, esp
10008c73 sub esp, 8
10008c76 mov dword ptr [ebp - 8], ecx
10008c79 mov eax, dword ptr [ebp + 8]
10008c7c mov dword ptr [ebp - 4], eax
10008c7f mov ecx, dword ptr [ebp - 4]
10008c82 push ecx
10008c83 mov ecx, dword ptr [ebp - 8]
10008c86 add ecx, 0x10000
10008c8c call 0x1000a350
10008c91 cmp eax, -1
10008c94 jne 0x10008c9b
10008c96 or eax, 0xffffffff
10008c99 jmp 0x10008cc1
10008c9b push 0x15
10008c9d mov edx, dword ptr [ebp - 4]
10008ca0 add edx, 4
10008ca3 push edx
10008ca4 mov ecx, dword ptr [ebp - 8]
10008ca7 add ecx, 0x10000
10008cad call 0x1000a440
10008cb2 cmp eax, -1
10008cb5 jne 0x10008cbc
10008cb7 or eax, 0xffffffff
10008cba jmp 0x10008cc1
10008cbc mov eax, 0x1c
10008cc1 mov esp, ebp
10008cc3 pop ebp
10008cc4 ret 4
10008cd0 push ebp
10008cd1 mov ebp, esp
10008cd3 sub esp, 8
10008cd6 mov dword ptr [ebp - 8], ecx
10008cd9 mov eax, dword ptr [ebp + 8]
10008cdc mov dword ptr [ebp - 4], eax
10008cdf push 0x15
10008ce1 mov ecx, dword ptr [ebp - 4]
10008ce4 push ecx
10008ce5 mov ecx, dword ptr [ebp - 8]
10008ce8 add ecx, 0x10000
10008cee call 0x1000a3b0
10008cf3 cmp eax, -1
10008cf6 jne 0x10008cfd
10008cf8 or eax, 0xffffffff
10008cfb jmp 0x10008d0b
10008cfd mov ecx, dword ptr [ebp - 8]
10008d00 add ecx, 0x10000
10008d06 call 0x10009f40
10008d0b mov esp, ebp
10008d0d pop ebp
10008d0e ret 4
10008d20 push ebp
10008d21 mov ebp, esp
10008d23 sub esp, 8
10008d26 mov dword ptr [ebp - 8], ecx
10008d29 mov eax, dword ptr [ebp + 8]
10008d2c mov dword ptr [ebp - 4], eax
10008d2f push 0x15
10008d31 mov ecx, dword ptr [ebp - 4]
10008d34 push ecx
10008d35 mov ecx, dword ptr [ebp - 8]
10008d38 add ecx, 0x10000
10008d3e call 0x1000a440
10008d43 cmp eax, -1
10008d46 jne 0x10008d4d
10008d48 or eax, 0xffffffff
10008d4b jmp 0x10008d52
10008d4d mov eax, 0x15
10008d52 mov esp, ebp
10008d54 pop ebp
10008d55 ret 4

RANGE 0x10009b60
10009b60 push ebp
10009b61 mov ebp, esp
10009b63 push ecx
10009b64 mov dword ptr [ebp - 4], ecx
10009b67 push 0x8000
10009b6c push 0
10009b6e mov eax, dword ptr [ebp - 4]
10009b71 push eax
10009b72 call 0x1000aca0
10009b77 add esp, 0xc
10009b7a push 0x8000
10009b7f push 0
10009b81 mov ecx, dword ptr [ebp - 4]
10009b84 add ecx, 0x8000
10009b8a push ecx
10009b8b call 0x1000aca0
10009b90 add esp, 0xc
10009b93 mov edx, dword ptr [ebp - 4]
10009b96 mov dword ptr [edx + 4], 0x10007d60
10009b9d mov eax, dword ptr [ebp - 4]
10009ba0 mov dword ptr [eax + 0x8004], 0x10007db0
10009baa mov ecx, dword ptr [ebp - 4]
10009bad mov dword ptr [ecx + 8], 0x10009760
10009bb4 mov edx, dword ptr [ebp - 4]
10009bb7 mov dword ptr [edx + 0x8008], 0x100097d0
10009bc1 mov eax, dword ptr [ebp - 4]
10009bc4 mov dword ptr [eax + 0x324], 0x10007df0
10009bce mov ecx, dword ptr [ebp - 4]
10009bd1 mov dword ptr [ecx + 0x8324], 0x10007e50
10009bdb mov edx, dword ptr [ebp - 4]
10009bde mov dword ptr [edx + 0x32c], 0x10007ea0
10009be8 mov eax, dword ptr [ebp - 4]
10009beb mov dword ptr [eax + 0x832c], 0x10007ef0
10009bf5 mov ecx, dword ptr [ebp - 4]
10009bf8 mov dword ptr [ecx + 0x330], 0x10007f30
10009c02 mov edx, dword ptr [ebp - 4]
10009c05 mov dword ptr [edx + 0x8330], 0x10007f80
10009c0f mov eax, dword ptr [ebp - 4]
10009c12 mov dword ptr [eax + 0x338], 0x10008010
10009c1c mov ecx, dword ptr [ebp - 4]
10009c1f mov dword ptr [ecx + 0x8338], 0x10008090
10009c29 mov edx, dword ptr [ebp - 4]
10009c2c mov dword ptr [edx + 0x33c], 0x10008770
10009c36 mov eax, dword ptr [ebp - 4]
10009c39 mov dword ptr [eax + 0x833c], 0x100087e0
10009c43 mov ecx, dword ptr [ebp - 4]
10009c46 mov dword ptr [ecx + 0x340], 0x10008840
10009c50 mov edx, dword ptr [ebp - 4]
10009c53 mov dword ptr [edx + 0x8340], 0x100088d0
10009c5d mov eax, dword ptr [ebp - 4]
10009c60 mov dword ptr [eax + 0x344], 0x10008950
10009c6a mov ecx, dword ptr [ebp - 4]
10009c6d mov dword ptr [ecx + 0x8344], 0x100089e0
10009c77 mov edx, dword ptr [ebp - 4]
10009c7a mov dword ptr [edx + 0x348], 0x10008a60
10009c84 mov eax, dword ptr [ebp - 4]
10009c87 mov dword ptr [eax + 0x8348], 0x10008ad0
10009c91 mov ecx, dword ptr [ebp - 4]
10009c94 mov dword ptr [ecx + 0x350], 0x10008c00
10009c9e mov edx, dword ptr [ebp - 4]
10009ca1 mov dword ptr [edx + 0x8350], 0x10008c70
10009cab mov eax, dword ptr [ebp - 4]
10009cae mov dword ptr [eax + 0x354], 0x10008cd0
10009cb8 mov ecx, dword ptr [ebp - 4]
10009cbb mov dword ptr [ecx + 0x8354], 0x10008d20
10009cc5 mov edx, dword ptr [ebp - 4]
10009cc8 mov dword ptr [edx + 0x358], 0x10008d60
10009cd2 mov eax, dword ptr [ebp - 4]
10009cd5 mov dword ptr [eax + 0x8358], 0x10008dd0
10009cdf mov ecx, dword ptr [ebp - 4]
10009ce2 mov dword ptr [ecx + 0x35c], 0x10008e30
10009cec mov edx, dword ptr [ebp - 4]
10009cef mov dword ptr [edx + 0x835c], 0x10008ea0
10009cf9 mov eax, dword ptr [ebp - 4]
10009cfc mov dword ptr [eax + 0x360], 0x10008f00
10009d06 mov ecx, dword ptr [ebp - 4]
10009d09 mov dword ptr [ecx + 0x8360], 0x10008f70
10009d13 mov edx, dword ptr [ebp - 4]
10009d16 mov dword ptr [edx + 0x368], 0x10008fd0
10009d20 mov eax, dword ptr [ebp - 4]
10009d23 mov dword ptr [eax + 0x8368], 0x10009040
10009d2d mov ecx, dword ptr [ebp - 4]
10009d30 mov dword ptr [ecx + 0x36c], 0x100090a0
10009d3a mov edx, dword ptr [ebp - 4]
10009d3d mov dword ptr [edx + 0x836c], 0x10009130
10009d47 mov eax, dword ptr [ebp - 4]
10009d4a mov dword ptr [eax + 0x370], 0x100091b0
10009d54 mov ecx, dword ptr [ebp - 4]
10009d57 mov dword ptr [ecx + 0x8370], 0x10009240
10009d61 mov edx, dword ptr [ebp - 4]
10009d64 mov dword ptr [edx + 0x374], 0x100092c0
10009d6e mov eax, dword ptr [ebp - 4]
10009d71 mov dword ptr [eax + 0x8374], 0x10009350
10009d7b mov ecx, dword ptr [ebp - 4]
10009d7e mov dword ptr [ecx + 0x378], 0x10009650
10009d88 mov edx, dword ptr [ebp - 4]
10009d8b mov dword ptr [edx + 0x8378], 0x100096e0
10009d95 mov eax, dword ptr [ebp - 4]
10009d98 mov dword ptr [eax + 0x380], 0x10007fc0
10009da2 mov ecx, dword ptr [ebp - 4]
10009da5 mov dword ptr [ecx + 0x8380], 0x10007ff0
10009daf mov edx, dword ptr [ebp - 4]
10009db2 mov dword ptr [edx + 0x384], 0x10008100
10009dbc mov eax, dword ptr [ebp - 4]
10009dbf mov dword ptr [eax + 0x8384], 0x10008150
10009dc9 mov ecx, dword ptr [ebp - 4]
10009dcc mov dword ptr [ecx + 0x388], 0x100086c0
10009dd6 mov edx, dword ptr [ebp - 4]
10009dd9 mov dword ptr [edx + 0x8388], 0x10008720
10009de3 mov eax, dword ptr [ebp - 4]
10009de6 mov dword ptr [eax + 0x390], 0x10008b30
10009df0 mov ecx, dword ptr [ebp - 4]
10009df3 mov dword ptr [ecx + 0x8390], 0x10008ba0
10009dfd mov edx, dword ptr [ebp - 4]
10009e00 mov dword ptr [edx + 0x3c0], 0x10007990
10009e0a mov eax, dword ptr [ebp - 4]
10009e0d mov dword ptr [eax + 0x83c0], 0x10007a10
10009e17 mov ecx, dword ptr [ebp - 4]
10009e1a mov dword ptr [ecx + 0x640], 0x10009830
10009e24 mov edx, dword ptr [ebp - 4]
10009e27 mov dword ptr [edx + 0x8640], 0x100098c0
10009e31 mov eax, dword ptr [ebp - 4]
10009e34 mov dword ptr [eax + 0x644], 0x10009940
10009e3e mov ecx, dword ptr [ebp - 4]
10009e41 mov dword ptr [ecx + 0x8644], 0x100099d0
10009e4b mov edx, dword ptr [ebp - 4]
10009e4e mov dword ptr [edx + 0x648], 0x10009a50
10009e58 mov eax, dword ptr [ebp - 4]
10009e5b mov dword ptr [eax + 0x8648], 0x10009ae0
10009e65 mov al, 1

RANGE 0x1000a230
1000a230 push ebp
1000a231 mov ebp, esp
1000a233 push ecx
1000a234 mov dword ptr [ebp - 4], ecx
1000a237 mov eax, dword ptr [ebp - 4]
1000a23a mov ecx, dword ptr [eax + 0xc]
1000a23d add ecx, 4
1000a240 mov edx, dword ptr [ebp - 4]
1000a243 cmp ecx, dword ptr [edx + 8]
1000a246 jle 0x1000a24d
1000a248 or eax, 0xffffffff
1000a24b jmp 0x1000a27b
1000a24d mov eax, dword ptr [ebp + 8]
1000a250 push eax
1000a251 call dword ptr [0x1001a12c]
1000a257 mov ecx, dword ptr [ebp - 4]
1000a25a mov edx, dword ptr [ecx + 4]
1000a25d mov ecx, dword ptr [ebp - 4]
1000a260 mov ecx, dword ptr [ecx + 0xc]
1000a263 mov dword ptr [edx + ecx], eax
1000a266 mov edx, dword ptr [ebp - 4]
1000a269 mov eax, dword ptr [edx + 0xc]
1000a26c add eax, 4
1000a26f mov ecx, dword ptr [ebp - 4]
1000a272 mov dword ptr [ecx + 0xc], eax
1000a275 mov edx, dword ptr [ebp - 4]
1000a278 mov eax, dword ptr [edx + 0xc]
1000a27b mov esp, ebp
1000a27d pop ebp
1000a27e ret 4
1000a290 push ebp
1000a291 mov ebp, esp
1000a293 push ecx
1000a294 mov dword ptr [ebp - 4], ecx
1000a297 mov eax, dword ptr [ebp - 4]
1000a29a mov ecx, dword ptr [eax + 0xc]
1000a29d add ecx, 4
1000a2a0 mov edx, dword ptr [ebp - 4]
1000a2a3 cmp ecx, dword ptr [edx + 8]
1000a2a6 jle 0x1000a2ad
1000a2a8 or eax, 0xffffffff
1000a2ab jmp 0x1000a2dd
1000a2ad mov eax, dword ptr [ebp - 4]
1000a2b0 mov ecx, dword ptr [eax + 4]
1000a2b3 mov edx, dword ptr [ebp - 4]
1000a2b6 mov eax, dword ptr [edx + 0xc]
1000a2b9 mov ecx, dword ptr [ecx + eax]
1000a2bc push ecx
1000a2bd call dword ptr [0x1001a130]
1000a2c3 mov edx, dword ptr [ebp + 8]
1000a2c6 mov dword ptr [edx], eax
1000a2c8 mov eax, dword ptr [ebp - 4]
1000a2cb mov ecx, dword ptr [eax + 0xc]
1000a2ce add ecx, 4
1000a2d1 mov edx, dword ptr [ebp - 4]
1000a2d4 mov dword ptr [edx + 0xc], ecx
1000a2d7 mov eax, dword ptr [ebp - 4]
1000a2da mov eax, dword ptr [eax + 0xc]
1000a2dd mov esp, ebp
1000a2df pop ebp
1000a2e0 ret 4
1000a2f0 push ebp
1000a2f1 mov ebp, esp
1000a2f3 push ecx
1000a2f4 mov dword ptr [ebp - 4], ecx
1000a2f7 mov eax, dword ptr [ebp - 4]
1000a2fa mov ecx, dword ptr [eax + 0xc]
1000a2fd add ecx, 4
1000a300 mov edx, dword ptr [ebp - 4]
1000a303 cmp ecx, dword ptr [edx + 8]
1000a306 jle 0x1000a30d
1000a308 or eax, 0xffffffff
1000a30b jmp 0x1000a33b
1000a30d mov eax, dword ptr [ebp + 8]
1000a310 push eax
1000a311 call dword ptr [0x1001a12c]
1000a317 mov ecx, dword ptr [ebp - 4]
1000a31a mov edx, dword ptr [ecx + 4]
1000a31d mov ecx, dword ptr [ebp - 4]
1000a320 mov ecx, dword ptr [ecx + 0xc]
1000a323 mov dword ptr [edx + ecx], eax
1000a326 mov edx, dword ptr [ebp - 4]
1000a329 mov eax, dword ptr [edx + 0xc]
1000a32c add eax, 4
1000a32f mov ecx, dword ptr [ebp - 4]
1000a332 mov dword ptr [ecx + 0xc], eax
1000a335 mov edx, dword ptr [ebp - 4]
1000a338 mov eax, dword ptr [edx + 0xc]
1000a33b mov esp, ebp
1000a33d pop ebp
1000a33e ret 4
1000a350 push ebp
1000a351 mov ebp, esp
1000a353 push ecx
1000a354 mov dword ptr [ebp - 4], ecx
1000a357 mov eax, dword ptr [ebp - 4]
1000a35a mov ecx, dword ptr [eax + 0xc]
1000a35d add ecx, 4
1000a360 mov edx, dword ptr [ebp - 4]
1000a363 cmp ecx, dword ptr [edx + 8]
1000a366 jle 0x1000a36d
1000a368 or eax, 0xffffffff
1000a36b jmp 0x1000a39d
1000a36d mov eax, dword ptr [ebp - 4]
1000a370 mov ecx, dword ptr [eax + 4]
1000a373 mov edx, dword ptr [ebp - 4]
1000a376 mov eax, dword ptr [edx + 0xc]
1000a379 mov ecx, dword ptr [ecx + eax]
1000a37c push ecx
1000a37d call dword ptr [0x1001a130]
1000a383 mov edx, dword ptr [ebp + 8]
1000a386 mov dword ptr [edx], eax
1000a388 mov eax, dword ptr [ebp - 4]
1000a38b mov ecx, dword ptr [eax + 0xc]
1000a38e add ecx, 4
1000a391 mov edx, dword ptr [ebp - 4]
1000a394 mov dword ptr [edx + 0xc], ecx
1000a397 mov eax, dword ptr [ebp - 4]
1000a39a mov eax, dword ptr [eax + 0xc]
1000a39d mov esp, ebp
1000a39f pop ebp
1000a3a0 ret 4
1000a3b0 push ebp
1000a3b1 mov ebp, esp
1000a3b3 sub esp, 8
1000a3b6 mov dword ptr [ebp - 8], ecx
1000a3b9 mov eax, dword ptr [ebp + 0xc]
1000a3bc sub eax, 1
1000a3bf push eax
1000a3c0 mov ecx, dword ptr [ebp + 8]
1000a3c3 push ecx
1000a3c4 mov ecx, dword ptr [ebp - 8]
1000a3c7 call 0x1000a4e0
1000a3cc mov dword ptr [ebp - 4], eax
1000a3cf mov edx, dword ptr [ebp - 8]
1000a3d2 mov eax, dword ptr [edx + 0xc]
1000a3d5 mov ecx, dword ptr [ebp - 4]
1000a3d8 lea edx, [eax + ecx + 2]
1000a3dc mov eax, dword ptr [ebp - 8]
1000a3df cmp edx, dword ptr [eax + 8]
1000a3e2 jle 0x1000a3e9
1000a3e4 or eax, 0xffffffff
1000a3e7 jmp 0x1000a432
1000a3e9 movzx ecx, word ptr [ebp - 4]
1000a3ed push ecx
1000a3ee mov ecx, dword ptr [ebp - 8]
1000a3f1 call 0x1000a0b0
1000a3f6 cmp eax, -1
1000a3f9 jne 0x1000a400
1000a3fb or eax, 0xffffffff
1000a3fe jmp 0x1000a432
1000a400 mov edx, dword ptr [ebp - 4]
1000a403 push edx
1000a404 mov eax, dword ptr [ebp + 8]
1000a407 push eax
1000a408 mov ecx, dword ptr [ebp - 8]
1000a40b mov edx, dword ptr [ecx + 4]
1000a40e mov eax, dword ptr [ebp - 8]
1000a411 add edx, dword ptr [eax + 0xc]
1000a414 push edx
1000a415 call 0x1000af70
1000a41a add esp, 0xc
1000a41d mov ecx, dword ptr [ebp - 8]
1000a420 mov edx, dword ptr [ecx + 0xc]
1000a423 add edx, dword ptr [ebp - 4]
1000a426 mov eax, dword ptr [ebp - 8]
1000a429 mov dword ptr [eax + 0xc], edx
1000a42c mov ecx, dword ptr [ebp - 8]
1000a42f mov eax, dword ptr [ecx + 0xc]
1000a432 mov esp, ebp
1000a434 pop ebp
1000a435 ret 8
1000a440 push ebp
1000a441 mov ebp, esp
1000a443 sub esp, 8
1000a446 mov dword ptr [ebp - 8], ecx
1000a449 xor eax, eax
1000a44b mov word ptr [ebp - 4], ax
1000a44f lea ecx, [ebp - 4]
1000a452 push ecx
1000a453 mov ecx, dword ptr [ebp - 8]
1000a456 call 0x1000a110
1000a45b cmp eax, -1
1000a45e jne 0x1000a465
1000a460 or eax, 0xffffffff
1000a463 jmp 0x1000a4cc
1000a465 movzx edx, word ptr [ebp - 4]
1000a469 mov eax, dword ptr [ebp - 8]
1000a46c add edx, dword ptr [eax + 0xc]
1000a46f mov ecx, dword ptr [ebp - 8]
1000a472 cmp edx, dword ptr [ecx + 8]
1000a475 jle 0x1000a47c
1000a477 or eax, 0xffffffff
1000a47a jmp 0x1000a4cc
1000a47c movzx edx, word ptr [ebp - 4]
1000a480 add edx, 1
1000a483 cmp edx, dword ptr [ebp + 0xc]
1000a486 jle 0x1000a48d
1000a488 or eax, 0xffffffff
1000a48b jmp 0x1000a4cc
1000a48d movzx eax, word ptr [ebp - 4]
1000a491 push eax
1000a492 mov ecx, dword ptr [ebp - 8]
1000a495 mov edx, dword ptr [ecx + 4]
1000a498 mov eax, dword ptr [ebp - 8]
1000a49b add edx, dword ptr [eax + 0xc]
1000a49e push edx
1000a49f mov ecx, dword ptr [ebp + 8]
1000a4a2 push ecx
1000a4a3 call 0x1000af70
1000a4a8 add esp, 0xc
1000a4ab movzx edx, word ptr [ebp - 4]
1000a4af mov eax, dword ptr [ebp + 8]
1000a4b2 mov byte ptr [eax + edx], 0
1000a4b6 movzx ecx, word ptr [ebp - 4]
1000a4ba mov edx, dword ptr [ebp - 8]
1000a4bd add ecx, dword ptr [edx + 0xc]
1000a4c0 mov eax, dword ptr [ebp - 8]
1000a4c3 mov dword ptr [eax + 0xc], ecx
1000a4c6 mov ecx, dword ptr [ebp - 8]
1000a4c9 mov eax, dword ptr [ecx + 0xc]
1000a4cc mov esp, ebp
1000a4ce pop ebp