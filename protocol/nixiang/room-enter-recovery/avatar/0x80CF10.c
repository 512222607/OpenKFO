_BYTE *__stdcall sub_80CF10(int a1, int a2, int a3, int a4, int a5)
{
  int v5; // eax
  int v6; // eax
  int v8; // [esp-Ch] [ebp-2Ch]
  int v9; // [esp-8h] [ebp-28h]
  int v10; // [esp-4h] [ebp-24h]
  _BYTE v11[4]; // [esp+8h] [ebp-18h] BYREF
  int v12; // [esp+Ch] [ebp-14h]
  _BYTE *v13; // [esp+10h] [ebp-10h]
  unsigned int v14; // [esp+14h] [ebp-Ch]
  int v15; // [esp+1Ch] [ebp-4h]

  v5 = sub_8E9500(); /*0x80cf38*/
  if ( (unsigned __int8)sub_8E88D0(a1: v5) != 0 ) /*0x80cf49*/
    v12 = *(unsigned __int8 *)(a3 + 10); /*0x80cf5e*/
  else
    v12 = *(unsigned __int8 *)(a3 + 8); /*0x80cf52*/
  v13 = (_BYTE *)sub_80CB00( /*0x80cfa1*/
                   this: (_DWORD **)dword_17C8708,
                   a2: *(_DWORD *)a3,
                   a3: *(_DWORD *)(a3 + 4),
                   a4: *(unsigned __int8 *)(a3 + 8),
                   a5: *(unsigned __int8 *)(a3 + 9),
                   a6: v12,
                   a7: a3 + 11,
                   a8: a4,
                   a9: (_DWORD *)a3,
                   a10: *(_BYTE *)(a3 + 75));
  if ( v13 != nullptr ) /*0x80cfa8*/
  {
    sub_53AF60(a1: *(_DWORD *)(a3 + 67)); /*0x80cfb8*/
    v6 = sub_539560(a1: dword_17C8708); /*0x80cfc3*/
    sub_9D4020(a1: v6); /*0x80cfcc*/
    sub_9D3FF0(a1: *(unsigned __int8 *)(a3 + 63)); /*0x80cfdc*/
    sub_501900(a1: *(unsigned __int8 *)(a3 + 55)); /*0x80cfec*/
    sub_5395A0(a1: *(unsigned __int16 *)(a3 + 65)); /*0x80cffc*/
    sub_9E29A0(a1: *(_DWORD *)(a3 + 71)); /*0x80d00b*/
    sub_9D9680(a1: a3 + 32); /*0x80d01a*/
    sub_3F5FD0(a1: a3 + 78); /*0x80d029*/
    v15 = 0; /*0x80d02e*/
    sub_53AB90(a1: v11); /*0x80d03c*/
    v15 = -1; /*0x80d041*/
    sub_3F6050(a1: v11); /*0x80d04b*/
    sub_53ABB0(a1: *(_DWORD *)(a3 + 120)); /*0x80d05a*/
    sub_53AB70(a1: *(_DWORD *)(a3 + 128)); /*0x80d06c*/
    v13[7412] = *(_BYTE *)(a3 + 77); /*0x80d07a*/
    sub_53AB30(a1: *(_DWORD *)(a3 + 136)); /*0x80d08d*/
    sub_53AB50(a1: *(_DWORD *)(a3 + 145)); /*0x80d09f*/
    sub_5018E0(a1: *(_BYTE *)(a3 + 144)); /*0x80d0b2*/
    if ( *(_BYTE *)(a3 + 53) != 0 ) /*0x80d0c0*/
      sub_4A1140(a1: 1); /*0x80d0c7*/
    if ( (*(unsigned __int8 (__fastcall **)(_BYTE *))(*(_DWORD *)v13 + 4))(a1: v13) == 0 /*0x80d0f9*/
      && *(_DWORD *)(a3 + 67) != 0
      && sub_9D7C70(a1: v13) == 0
      && a5 != 0 )
    {
      v10 = *(_DWORD *)(a3 + 4); /*0x80d101*/
      v9 = *(_DWORD *)a3; /*0x80d104*/
      v8 = *(_DWORD *)(a3 + 67); /*0x80d10b*/
      sub_7C0B90(); /*0x80d10c*/
      sub_7C0860(a1: v8, a2: v9, a3: v10); /*0x80d113*/
    }
    sub_9D6B30(a1: v13); /*0x80d11b*/
    sub_53AF40(a1: *(_DWORD *)(a3 + 140)); /*0x80d12d*/
  }
  __writefsdword(0, v14); /*0x80d138*/
  return v13; /*0x80d140*/
}
