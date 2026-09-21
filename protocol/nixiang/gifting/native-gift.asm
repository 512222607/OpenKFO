; Current native client SHA256 98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b

; Function 0x85c7e0
0085C7E0 push     ebp
0085C7E1 mov      ebp, esp
0085C7E3 push     -1
0085C7E5 push     0xac6692
0085C7EA mov      eax, dword ptr fs:[0]
0085C7F0 push     eax
0085C7F1 sub      esp, 0x2cc
0085C7F7 mov      eax, dword ptr [0xc7b480]
0085C7FC xor      eax, ebp
0085C7FE mov      dword ptr [ebp - 0x18], eax
0085C801 push     eax
0085C802 lea      eax, [ebp - 0xc]
0085C805 mov      dword ptr fs:[0], eax
0085C80B mov      dword ptr [ebp - 0x2cc], ecx
0085C811 mov      eax, dword ptr [ebp + 8]
0085C814 mov      ecx, dword ptr [eax + 0x26]
0085C817 mov      dword ptr [ebp - 0x14], ecx
0085C81A mov      edx, dword ptr [ebp + 8]
0085C81D movzx    eax, byte ptr [edx + 0x2e]
0085C821 test     eax, eax
0085C823 je       0x85c82e
0085C825 mov      ecx, dword ptr [ebp + 8]
0085C828 mov      edx, dword ptr [ecx + 0x2a]
0085C82B mov      dword ptr [ebp - 0x14], edx
0085C82E mov      ecx, dword ptr [0x17c86fc]
0085C834 call     0x9ccf20
0085C839 mov      dword ptr [ebp - 0x10], eax
0085C83C mov      eax, dword ptr [ebp - 0x14]
0085C83F cmp      eax, dword ptr [ebp - 0x10]
0085C842 jle      0x85c8ce
0085C848 mov      ecx, dword ptr [ebp - 0x14]
0085C84B push     ecx
0085C84C mov      edx, dword ptr [ebp - 0x10]
0085C84F push     edx
0085C850 push     0xbbf290
0085C855 push     0x80
0085C85A lea      eax, [ebp - 0x9c]
0085C860 push     eax
0085C861 call     0x663beb
0085C866 add      esp, 0x14
0085C869 lea      ecx, [ebp - 0x9c]
0085C86F push     ecx
0085C870 lea      ecx, [ebp - 0x2ac]
0085C876 call     0x405650
0085C87B mov      dword ptr [ebp - 4], 0
0085C882 call     0x41c540
0085C887 mov      dword ptr [ebp - 0x2d0], eax
0085C88D push     0
0085C88F push     0
0085C891 push     0
0085C893 lea      edx, [ebp - 0x2ac]
0085C899 push     edx
0085C89A mov      eax, dword ptr [ebp - 0x2d0]
0085C8A0 mov      edx, dword ptr [eax]
0085C8A2 mov      ecx, dword ptr [ebp - 0x2d0]
0085C8A8 mov      eax, dword ptr [edx + 0x1c0]
0085C8AE call     eax
0085C8B0 mov      dword ptr [ebp - 4], 0xffffffff
0085C8B7 lea      ecx, [ebp - 0x2ac]
0085C8BD call     0x4056d0
0085C8C2 xor      eax, eax
0085C8C4 jmp      0x85ca25
0085C8C9 jmp      0x85ca20
0085C8CE push     0x1aa
0085C8D3 push     0
0085C8D5 lea      ecx, [ebp - 0x24c]
0085C8DB push     ecx
0085C8DC call     0x666960
0085C8E1 add      esp, 0xc
0085C8E4 mov      edx, dword ptr [ebp + 8]
0085C8E7 mov      eax, dword ptr [edx + 9]
0085C8EA mov      dword ptr [ebp - 0x1bb], eax
0085C8F0 mov      dword ptr [ebp - 0x24c], 0x6d
0085C8FA mov      cl, byte ptr [ebp + 0x14]
0085C8FD mov      byte ptr [ebp - 0x1a3], cl
0085C903 mov      edx, dword ptr [ebp + 8]
0085C906 mov      eax, dword ptr [edx + 0x4d]
0085C909 mov      dword ptr [ebp - 0x1a7], eax
0085C90F mov      ecx, dword ptr [ebp - 0x14]
0085C912 mov      dword ptr [ebp - 0x1af], ecx
0085C918 mov      edx, dword ptr [ebp + 0xc]
0085C91B push     edx
0085C91C lea      eax, [ebp - 0x1f9]
0085C922 push     eax
0085C923 call     0x4b1970
0085C928 add      esp, 8
0085C92B mov      ecx, dword ptr [ebp + 0x10]
0085C92E push     ecx
0085C92F lea      edx, [ebp - 0x1a2]
0085C935 push     edx
0085C936 call     0x4ed4c0
0085C93B add      esp, 8
0085C93E mov      dword ptr [ebp - 0x254], 0
0085C948 mov      dword ptr [ebp - 0x250], 0
0085C952 lea      ecx, [ebp - 0x28c]
0085C958 call     0x41c720
0085C95D mov      dword ptr [ebp - 4], 1
0085C964 mov      eax, dword ptr [ebp + 0xc]
0085C967 push     eax
0085C968 lea      ecx, [ebp - 0x2c8]
0085C96E call     0x405650
0085C973 mov      dword ptr [ebp - 0x2d4], eax
0085C979 mov      ecx, dword ptr [ebp - 0x2d4]
0085C97F mov      dword ptr [ebp - 0x2d8], ecx
0085C985 mov      byte ptr [ebp - 4], 2
0085C989 lea      edx, [ebp - 0x28c]
0085C98F push     edx
0085C990 mov      eax, dword ptr [ebp - 0x2d8]
0085C996 push     eax
0085C997 call     0x9990a0
0085C99C mov      ecx, eax
0085C99E call     0x998b30
0085C9A3 mov      byte ptr [ebp - 0x28d], al
0085C9A9 mov      byte ptr [ebp - 4], 1
0085C9AD lea      ecx, [ebp - 0x2c8]
0085C9B3 call     0x4056d0
0085C9B8 movzx    ecx, byte ptr [ebp - 0x28d]
0085C9BF test     ecx, ecx
0085C9C1 je       0x85c9db
0085C9C3 mov      edx, dword ptr [ebp - 0x284]
0085C9C9 mov      dword ptr [ebp - 0x254], edx
0085C9CF mov      eax, dword ptr [ebp - 0x280]
0085C9D5 mov      dword ptr [ebp - 0x250], eax
0085C9DB mov      dword ptr [ebp - 4], 0xffffffff
0085C9E2 lea      ecx, [ebp - 0x28c]
0085C9E8 call     0x41c740
0085C9ED mov      ecx, dword ptr [ebp - 0x254]
0085C9F3 mov      dword ptr [ebp - 0x216], ecx
0085C9F9 mov      edx, dword ptr [ebp - 0x250]
0085C9FF mov      dword ptr [ebp - 0x212], edx
0085CA05 push     0x1aa
0085CA0A lea      eax, [ebp - 0x24c]
0085CA10 push     eax
0085CA11 push     0
0085CA13 push     0x2382
0085CA18 call     0xa3c950
0085CA1D add      esp, 0x10
0085CA20 mov      eax, 1
0085CA25 mov      ecx, dword ptr [ebp - 0xc]
0085CA28 mov      dword ptr fs:[0], ecx
0085CA2F pop      ecx
0085CA30 mov      ecx, dword ptr [ebp - 0x18]
0085CA33 xor      ecx, ebp
0085CA35 call     0x6634fb
0085CA3A mov      esp, ebp
0085CA3C pop      ebp
0085CA3D ret      0x10

; Function 0x8406f0
008406F0 push     ebp
008406F1 mov      ebp, esp
008406F3 push     -1
008406F5 push     0xadf677
008406FA mov      eax, dword ptr fs:[0]
00840700 push     eax
00840701 sub      esp, 0x350
00840707 mov      eax, dword ptr [0xc7b480]
0084070C xor      eax, ebp
0084070E mov      dword ptr [ebp - 0x1c], eax
00840711 push     eax
00840712 lea      eax, [ebp - 0xc]
00840715 mov      dword ptr fs:[0], eax
0084071B mov      dword ptr [ebp - 0x344], ecx
00840721 mov      eax, dword ptr [ebp - 0x344]
00840727 cmp      dword ptr [eax + 0x600], 0x10a
00840731 je       0x8407cb
00840737 lea      ecx, [ebp - 0x14]
0084073A call     0x649ac0
0084073F mov      ecx, dword ptr [ebp - 0x344]
00840745 cmp      dword ptr [ecx + 0x72c], 0
0084074C jb       0x8407a1
0084074E mov      ecx, dword ptr [ebp - 0x344]
00840754 add      ecx, 0x708
0084075A call     0x4f3770
0084075F mov      edx, dword ptr [ebp - 0x344]
00840765 cmp      dword ptr [edx + 0x72c], eax
0084076B jae      0x8407a1
0084076D mov      eax, dword ptr [ebp - 0x344]
00840773 mov      ecx, dword ptr [eax + 0x72c]
00840779 push     ecx
0084077A mov      ecx, dword ptr [ebp - 0x344]
00840780 add      ecx, 0x708
00840786 call     0x52f7e0
0084078B mov      dword ptr [ebp - 0x18], eax
0084078E mov      edx, dword ptr [ebp - 0x18]
00840791 mov      eax, dword ptr [edx]
00840793 mov      ecx, dword ptr [eax]
00840795 mov      dword ptr [ebp - 0x14], ecx
00840798 mov      edx, dword ptr [ebp - 0x18]
0084079B mov      eax, dword ptr [edx + 0xc]
0084079E mov      dword ptr [ebp - 0x10], eax
008407A1 mov      ecx, dword ptr [ebp - 0x14]
008407A4 neg      ecx
008407A6 sbb      ecx, ecx
008407A8 lea      edx, [ebp - 0x14]
008407AB and      ecx, edx
008407AD push     ecx
008407AE mov      eax, dword ptr [ebp - 0x344]
008407B4 add      eax, 0x578
008407B9 push     eax
008407BA call     0x41bc70
008407BF mov      ecx, eax
008407C1 call     0x85d230
008407C6 jmp      0x840c99
008407CB mov      ecx, dword ptr [ebp - 0x344]
008407D1 cmp      dword ptr [ecx + 0x600], 0x10a
008407DB jne      0x840c99
008407E1 push     0xa9
008407E6 push     0
008407E8 lea      edx, [ebp - 0x1dc]
008407EE push     edx
008407EF call     0x666960
008407F4 add      esp, 0xc
008407F7 mov      ecx, dword ptr [0x17c86fc]
008407FD call     0x402aa0
00840802 mov      dword ptr [ebp - 0x1d8], eax
00840808 mov      dword ptr [ebp - 0x1d4], edx
0084080E lea      eax, [ebp - 0x2e8]
00840814 push     eax
00840815 mov      ecx, dword ptr [0x17c86fc]
0084081B call     0x416240
00840820 mov      dword ptr [ebp - 0x348], eax
00840826 mov      ecx, dword ptr [ebp - 0x348]
0084082C call     0x453f50
00840831 push     eax
00840832 lea      ecx, [ebp - 0x1d0]
00840838 push     ecx
00840839 call     0x4b1970
0084083E add      esp, 8
00840841 lea      ecx, [ebp - 0x2e8]
00840847 call     0x406050
0084084C mov      ecx, dword ptr [0x17c86fc]
00840852 call     0x402aa0
00840857 mov      dword ptr [ebp - 0x1a6], eax
0084085D mov      dword ptr [ebp - 0x1a2], edx
00840863 lea      edx, [ebp - 0x2ec]
00840869 push     edx
0084086A mov      ecx, dword ptr [0x17c86fc]
00840870 call     0x416240
00840875 mov      dword ptr [ebp - 0x34c], eax
0084087B mov      ecx, dword ptr [ebp - 0x34c]
00840881 call     0x453f50
00840886 push     eax
00840887 lea      eax, [ebp - 0x19e]
0084088D push     eax
0084088E call     0x4b1970
00840893 add      esp, 8
00840896 lea      ecx, [ebp - 0x2ec]
0084089C call     0x406050
008408A1 mov      ecx, dword ptr [ebp - 0x344]
008408A7 mov      edx, dword ptr [ecx + 0x604]
008408AD mov      dword ptr [ebp - 0x14b], edx
008408B3 mov      eax, dword ptr [ebp - 0x344]
008408B9 mov      ecx, dword ptr [eax + 0x620]
008408BF mov      dword ptr [ebp - 0x137], ecx
008408C5 mov      edx, dword ptr [ebp - 0x344]
008408CB mov      eax, dword ptr [edx + 0x614]
008408D1 mov      dword ptr [ebp - 0x13f], eax
008408D7 cmp      dword ptr [0x17c86fc], 0
008408DE je       0x84091e
008408E0 mov      ecx, dword ptr [0x17c86fc]
008408E6 call     0x9ccfa0
008408EB mov      ecx, dword ptr [eax + 0x10]
008408EE mov      dword ptr [ebp - 0x1e0], ecx
008408F4 cmp      dword ptr [ebp - 0x1e0], 0
008408FB jle      0x84091e
008408FD mov      edx, dword ptr [ebp - 0x344]
00840903 mov      eax, dword ptr [edx + 0x614]
00840909 imul     eax, dword ptr [ebp - 0x1e0]
00840910 cdq
00840911 mov      ecx, 0x64
00840916 idiv     ecx
00840918 mov      dword ptr [ebp - 0x13f], eax
0084091E mov      edx, dword ptr [ebp - 0x344]
00840924 cmp      dword ptr [edx + 0x618], 0
0084092B jle      0x84096d
0084092D mov      eax, dword ptr [ebp - 0x344]
00840933 mov      ecx, dword ptr [ebp - 0x13f]
00840939 cmp      ecx, dword ptr [eax + 0x618]
0084093F jge      0x84094f
00840941 mov      edx, dword ptr [ebp - 0x13f]
00840947 mov      dword ptr [ebp - 0x350], edx
0084094D jmp      0x840961
0084094F mov      eax, dword ptr [ebp - 0x344]
00840955 mov      ecx, dword ptr [eax + 0x618]
0084095B mov      dword ptr [ebp - 0x350], ecx
00840961 mov      edx, dword ptr [ebp - 0x350]
00840967 mov      dword ptr [ebp - 0x13f], edx
0084096D mov      eax, dword ptr [ebp - 0x344]
00840973 movzx    ecx, byte ptr [eax + 0x624]
0084097A test     ecx, ecx
0084097C je       0x8409c2
0084097E mov      ecx, dword ptr [0x17c86fc]
00840984 call     0x48e120
00840989 cmp      dword ptr [ebp - 0x13f], eax
0084098F jge      0x84099f
00840991 mov      edx, dword ptr [ebp - 0x13f]
00840997 mov      dword ptr [ebp - 0x143], edx
0084099D jmp      0x8409b0
0084099F mov      ecx, dword ptr [0x17c86fc]
008409A5 call     0x48e120
008409AA mov      dword ptr [ebp - 0x143], eax
008409B0 mov      eax, dword ptr [ebp - 0x13f]
008409B6 sub      eax, dword ptr [ebp - 0x143]
008409BC mov      dword ptr [ebp - 0x13f], eax
008409C2 mov      ecx, dword ptr [0x17c86fc]
008409C8 call     0x9ccf20
008409CD mov      dword ptr [ebp - 0x128], eax
008409D3 mov      ecx, dword ptr [ebp - 0x13f]
008409D9 cmp      ecx, dword ptr [ebp - 0x128]
008409DF jle      0x840a6a
008409E5 mov      edx, dword ptr [ebp - 0x13f]
008409EB push     edx
008409EC mov      eax, dword ptr [ebp - 0x128]
008409F2 push     eax
008409F3 push     0xbbf290
008409F8 push     0x80
008409FD lea      ecx, [ebp - 0x264]
00840A03 push     ecx
00840A04 call     0x663beb
00840A09 add      esp, 0x14
00840A0C lea      edx, [ebp - 0x264]
00840A12 push     edx
00840A13 lea      ecx, [ebp - 0x308]
00840A19 call     0x405650
00840A1E mov      dword ptr [ebp - 4], 0
00840A25 call     0x41c540
00840A2A mov      dword ptr [ebp - 0x354], eax
00840A30 push     0
00840A32 push     0
00840A34 push     0
00840A36 lea      eax, [ebp - 0x308]
00840A3C push     eax
00840A3D mov      ecx, dword ptr [ebp - 0x354]
00840A43 mov      edx, dword ptr [ecx]
00840A45 mov      ecx, dword ptr [ebp - 0x354]
00840A4B mov      eax, dword ptr [edx + 0x1c0]
00840A51 call     eax
00840A53 mov      dword ptr [ebp - 4], 0xffffffff
00840A5A lea      ecx, [ebp - 0x308]
00840A60 call     0x4056d0
00840A65 jmp      0x840caf
00840A6A lea      ecx, [ebp - 0x124]
00840A70 push     ecx
00840A71 mov      edx, dword ptr [ebp - 0x344]
00840A77 mov      eax, dword ptr [edx + 0x620]
00840A7D push     eax
00840A7E call     0x41bc70
00840A83 mov      ecx, eax
00840A85 call     0x85ba40
00840A8A lea      ecx, [ebp - 0xb4]
00840A90 call     0x4c4330
00840A95 mov      dword ptr [ebp - 4], 1
00840A9C push     0xa9
00840AA1 lea      ecx, [ebp - 0x1dc]
00840AA7 push     ecx
00840AA8 push     0
00840AAA push     0x2351
00840AAF call     0xa3c950
00840AB4 add      esp, 0x10
00840AB7 mov      edx, dword ptr [ebp - 0x344]
00840ABD mov      eax, dword ptr [edx + 0x620]
00840AC3 push     eax
00840AC4 call     0x41bf70
00840AC9 mov      ecx, eax
00840ACB call     0x8e0d50
00840AD0 lea      ecx, [ebp - 0x2d8]
00840AD6 call     0x405f90
00840ADB mov      byte ptr [ebp - 4], 2
00840ADF lea      ecx, [ebp - 0x2dc]
00840AE5 call     0x405f90
00840AEA mov      byte ptr [ebp - 4], 3
00840AEE lea      ecx, [ebp - 0x2e0]
00840AF4 call     0x405f90
00840AF9 mov      byte ptr [ebp - 4], 4
00840AFD lea      ecx, [ebp - 0xac]
00840B03 push     ecx
00840B04 lea      ecx, [ebp - 0x2d8]
00840B0A call     0x406070
00840B0F lea      edx, [ebp - 0x2d4]
00840B15 push     edx
00840B16 mov      eax, dword ptr [ebp - 0x344]
00840B1C mov      ecx, dword ptr [eax + 0x620]
00840B22 push     ecx
00840B23 call     0x41bc70
00840B28 mov      ecx, eax
00840B2A call     0x85ba40
00840B2F test     eax, eax
00840B31 je       0x840c5a
00840B37 mov      edx, dword ptr [ebp - 0x2cf]
00840B3D push     edx
00840B3E call     0xa21b30
00840B43 mov      ecx, eax
00840B45 call     0xa1e560
00840B4A mov      dword ptr [ebp - 0x2e4], eax
00840B50 cmp      dword ptr [ebp - 0x2e4], 0
00840B57 je       0x840be2
00840B5D mov      eax, dword ptr [ebp - 0x2e4]
00840B63 mov      ecx, dword ptr [eax + 0xc]
00840B66 push     ecx
00840B67 mov      edx, dword ptr [ebp - 0x344]
00840B6D add      edx, 0x625
00840B73 push     edx
00840B74 push     0xb9cd78
00840B79 lea      eax, [ebp - 0x2e0]
00840B7F push     eax
00840B80 call     0x411c60
00840B85 add      esp, 0x10
00840B88 lea      ecx, [ebp - 0x2e0]
00840B8E call     0x406410
00840B93 push     eax
00840B94 lea      ecx, [ebp - 0x324]
00840B9A call     0x405650
00840B9F mov      byte ptr [ebp - 4], 5
00840BA3 call     0x41bf70
00840BA8 mov      dword ptr [ebp - 0x358], eax
00840BAE push     0
00840BB0 push     0
00840BB2 push     0
00840BB4 lea      ecx, [ebp - 0x324]
00840BBA push     ecx
00840BBB mov      edx, dword ptr [ebp - 0x358]
00840BC1 mov      eax, dword ptr [edx]
00840BC3 mov      ecx, dword ptr [ebp - 0x358]
00840BC9 mov      edx, dword ptr [eax + 0x1c0]
00840BCF call     edx
00840BD1 mov      byte ptr [ebp - 4], 4
00840BD5 lea      ecx, [ebp - 0x324]
00840BDB call     0x4056d0
00840BE0 jmp      0x840c5a
00840BE2 mov      eax, dword ptr [ebp - 0x344]
00840BE8 add      eax, 0x625
00840BED push     eax
00840BEE push     0xb9cdb8
00840BF3 lea      ecx, [ebp - 0x2e0]
00840BF9 push     ecx
00840BFA call     0x411c60
00840BFF add      esp, 0xc
00840C02 lea      ecx, [ebp - 0x2e0]
00840C08 call     0x406410
00840C0D push     eax
00840C0E lea      ecx, [ebp - 0x340]
00840C14 call     0x405650
00840C19 mov      byte ptr [ebp - 4], 6
00840C1D call     0x403820
00840C22 mov      dword ptr [ebp - 0x35c], eax
00840C28 push     0
00840C2A push     0
00840C2C push     0
00840C2E lea      edx, [ebp - 0x340]
00840C34 push     edx
00840C35 mov      eax, dword ptr [ebp - 0x35c]
00840C3B mov      edx, dword ptr [eax]
00840C3D mov      ecx, dword ptr [ebp - 0x35c]
00840C43 mov      eax, dword ptr [edx + 0x1c0]
00840C49 call     eax
00840C4B mov      byte ptr [ebp - 4], 4
00840C4F lea      ecx, [ebp - 0x340]
00840C55 call     0x4056d0
00840C5A mov      byte ptr [ebp - 4], 3
00840C5E lea      ecx, [ebp - 0x2e0]
00840C64 call     0x406050
00840C69 mov      byte ptr [ebp - 4], 2
00840C6D lea      ecx, [ebp - 0x2dc]
00840C73 call     0x406050
00840C78 mov      byte ptr [ebp - 4], 1
00840C7C lea      ecx, [ebp - 0x2d8]
00840C82 call     0x406050
00840C87 mov      dword ptr [ebp - 4], 0xffffffff
00840C8E lea      ecx, [ebp - 0xb4]
00840C94 call     0x4c4370
00840C99 mov      ecx, dword ptr [ebp - 0x344]
00840C9F mov      edx, dword ptr [ecx]
00840CA1 mov      ecx, dword ptr [ebp - 0x344]
00840CA7 mov      eax, dword ptr [edx + 0x11c]
00840CAD call     eax
00840CAF mov      ecx, dword ptr [ebp - 0xc]
00840CB2 mov      dword ptr fs:[0], ecx
00840CB9 pop      ecx
00840CBA mov      ecx, dword ptr [ebp - 0x1c]
00840CBD xor      ecx, ebp
00840CBF call     0x6634fb
00840CC4 mov      esp, ebp
00840CC6 pop      ebp
00840CC7 ret

; Function 0xa2d550
00A2D550 push     ebp
00A2D551 mov      ebp, esp
00A2D553 push     -1
00A2D555 push     0xadf41b
00A2D55A mov      eax, dword ptr fs:[0]
00A2D560 push     eax
00A2D561 sub      esp, 0x24
00A2D564 mov      eax, dword ptr [0xc7b480]
00A2D569 xor      eax, ebp
00A2D56B push     eax
00A2D56C lea      eax, [ebp - 0xc]
00A2D56F mov      dword ptr fs:[0], eax
00A2D575 mov      dword ptr [ebp - 0x2c], ecx
00A2D578 cmp      dword ptr [ebp + 8], 0
00A2D57C je       0xa2d584
00A2D57E cmp      dword ptr [ebp + 0xc], 0
00A2D582 jne      0xa2d586
00A2D584 jmp      0xa2d5ef
00A2D586 call     0x41bb80
00A2D58B mov      ecx, eax
00A2D58D call     0x842210
00A2D592 call     0x41bb80
00A2D597 mov      ecx, eax
00A2D599 call     0x842140
00A2D59E call     0x41bb80
00A2D5A3 mov      ecx, eax
00A2D5A5 call     0x842070
00A2D5AA push     0xb9cdec
00A2D5AF lea      ecx, [ebp - 0x28]
00A2D5B2 call     0x405650
00A2D5B7 mov      dword ptr [ebp - 4], 0
00A2D5BE call     0x403820
00A2D5C3 mov      dword ptr [ebp - 0x30], eax
00A2D5C6 push     0
00A2D5C8 push     0
00A2D5CA push     0
00A2D5CC lea      eax, [ebp - 0x28]
00A2D5CF push     eax
00A2D5D0 mov      ecx, dword ptr [ebp - 0x30]
00A2D5D3 mov      edx, dword ptr [ecx]
00A2D5D5 mov      ecx, dword ptr [ebp - 0x30]
00A2D5D8 mov      eax, dword ptr [edx + 0x1c0]
00A2D5DE call     eax
00A2D5E0 mov      dword ptr [ebp - 4], 0xffffffff
00A2D5E7 lea      ecx, [ebp - 0x28]
00A2D5EA call     0x4056d0
00A2D5EF mov      ecx, dword ptr [ebp - 0xc]
00A2D5F2 mov      dword ptr fs:[0], ecx
00A2D5F9 pop      ecx
00A2D5FA mov      esp, ebp
00A2D5FC pop      ebp
00A2D5FD ret      8

; Function 0xa2a120
00A2A120 push     ebp
00A2A121 mov      ebp, esp
00A2A123 push     -1
00A2A125 push     0xac4bf0
00A2A12A mov      eax, dword ptr fs:[0]
00A2A130 push     eax
00A2A131 sub      esp, 0x2c
00A2A134 mov      eax, dword ptr [0xc7b480]
00A2A139 xor      eax, ebp
00A2A13B push     eax
00A2A13C lea      eax, [ebp - 0xc]
00A2A13F mov      dword ptr fs:[0], eax
00A2A145 mov      dword ptr [ebp - 0x34], ecx
00A2A148 cmp      dword ptr [ebp + 8], 0
00A2A14C je       0xa2a154
00A2A14E cmp      dword ptr [ebp + 0xc], 0
00A2A152 jne      0xa2a159
00A2A154 jmp      0xa2a1e3
00A2A159 mov      eax, dword ptr [ebp + 8]
00A2A15C mov      dword ptr [ebp - 0x10], eax
00A2A15F mov      dword ptr [ebp - 0x14], 0xb9ce20
00A2A166 mov      ecx, dword ptr [ebp - 0x10]
00A2A169 movzx    edx, word ptr [ecx]
00A2A16C cmp      edx, 0x38
00A2A16F jne      0xa2a17a
00A2A171 mov      dword ptr [ebp - 0x14], 0xb9ce3c
00A2A178 jmp      0xa2a19f
00A2A17A mov      eax, dword ptr [ebp - 0x10]
00A2A17D movzx    ecx, word ptr [eax]
00A2A180 cmp      ecx, 0x13
00A2A183 jne      0xa2a18e
00A2A185 mov      dword ptr [ebp - 0x14], 0xb9ce74
00A2A18C jmp      0xa2a19f
00A2A18E mov      edx, dword ptr [ebp - 0x10]
00A2A191 movzx    eax, word ptr [edx]
00A2A194 imul     eax, eax, 0x68
00A2A197 add      eax, 0x12e2824
00A2A19C mov      dword ptr [ebp - 0x14], eax
00A2A19F mov      ecx, dword ptr [ebp - 0x14]
00A2A1A2 push     ecx
00A2A1A3 lea      ecx, [ebp - 0x30]
00A2A1A6 call     0x405650
00A2A1AB mov      dword ptr [ebp - 4], 0
00A2A1B2 call     0x403820
00A2A1B7 mov      dword ptr [ebp - 0x38], eax
00A2A1BA push     0
00A2A1BC push     0
00A2A1BE push     0
00A2A1C0 lea      edx, [ebp - 0x30]
00A2A1C3 push     edx
00A2A1C4 mov      eax, dword ptr [ebp - 0x38]
00A2A1C7 mov      edx, dword ptr [eax]
00A2A1C9 mov      ecx, dword ptr [ebp - 0x38]
00A2A1CC mov      eax, dword ptr [edx + 0x1c0]
00A2A1D2 call     eax
00A2A1D4 mov      dword ptr [ebp - 4], 0xffffffff
00A2A1DB lea      ecx, [ebp - 0x30]
00A2A1DE call     0x4056d0
00A2A1E3 mov      ecx, dword ptr [ebp - 0xc]
00A2A1E6 mov      dword ptr fs:[0], ecx
00A2A1ED pop      ecx
00A2A1EE mov      esp, ebp
00A2A1F0 pop      ebp

; Function 0x4ed4c0
004ED4C0 push     ebp
004ED4C1 mov      ebp, esp
004ED4C3 mov      eax, dword ptr [ebp + 0xc]
004ED4C6 push     eax
004ED4C7 push     0x100
004ED4CC mov      ecx, dword ptr [ebp + 8]
004ED4CF push     ecx
004ED4D0 call     0x497d10
004ED4D5 add      esp, 0xc
004ED4D8 pop      ebp
004ED4D9 ret

; Function 0x4b1970
004B1970 push     ebp
004B1971 mov      ebp, esp
004B1973 mov      eax, dword ptr [ebp + 0xc]
004B1976 push     eax
004B1977 push     0x15
004B1979 mov      ecx, dword ptr [ebp + 8]
004B197C push     ecx
004B197D call     0x497d10
004B1982 add      esp, 0xc
004B1985 pop      ebp
004B1986 ret
