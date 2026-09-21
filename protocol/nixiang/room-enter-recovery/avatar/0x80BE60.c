int __stdcall sub_80BE60(__int64 a1, int a2, const void *a3, int a4, int a5)
{
  void *v5; // eax
  int v6; // eax
  int v7; // eax
  int v9; // [esp-Ch] [ebp-5C4h]
  __int64 v10; // [esp-8h] [ebp-5C0h]
  __int64 v11; // [esp+Ch] [ebp-5ACh]
  __int64 v12; // [esp+14h] [ebp-5A4h]
  _BYTE v13[28]; // [esp+20h] [ebp-598h] BYREF
  _BYTE v14[1388]; // [esp+3Ch] [ebp-57Ch] BYREF
  int v15; // [esp+5B4h] [ebp-4h]

  sub_501AA0(a1: v14); /*0x80be99*/
  qmemcpy(v14, (const void *)a2, 0x95u); /*0x80beac*/
  qmemcpy(&v14[152], a3, 0x4D0u); /*0x80bebd*/
  v5 = (void *)sub_501C80(&a1); /*0x80becf*/
  qmemcpy(v5, v14, 1384); /*0x80bee1*/
  v12 = sub_3F2AA0(a1: dword_17C86FC); /*0x80beee*/
  if ( a1 != v12 && a4 != 0 ) /*0x80bf14*/
  {
    v10 = a1; /*0x80bf1d*/
    v9 = *(_DWORD *)(a2 + 67); /*0x80bf24*/
    sub_7C0B90(); /*0x80bf25*/
    sub_7C0860(a1: v9, a2: v10, a3: HIDWORD(v10)); /*0x80bf2c*/
  }
  v11 = sub_3F2AA0(a1: dword_17C86FC); /*0x80bf3c*/
  if ( a1 == v11 ) /*0x80bf51*/
  {
    sub_3F5650(a1: off_B971F0); /*0x80bf6a*/
    v15 = 0; /*0x80bf6f*/
    sub_80B800(this: (_DWORD *)dword_17C8708); /*0x80bf85*/
    sub_7503D0(a1: v13, a2: 0); /*0x80bf8c*/
    v15 = -1; /*0x80bf91*/
    sub_3F56D0(a1: v13); /*0x80bf9e*/
  }
  v6 = sub_80B800(this: (_DWORD *)dword_17C8708); /*0x80bfa9*/
  v7 = sub_53AE90(a1: v6); /*0x80bfb0*/
  return sub_884F40(a1: v7); /*0x80bfbc*/
}
