int __fastcall sub_8DCB70(int a1)
{
  int result; // eax
  _BYTE v3[28]; // [esp+8h] [ebp-7Ch] BYREF
  _BYTE v4[28]; // [esp+24h] [ebp-60h] BYREF
  _BYTE v5[28]; // [esp+40h] [ebp-44h] BYREF
  _BYTE v6[28]; // [esp+5Ch] [ebp-28h] BYREF
  unsigned int v7; // [esp+78h] [ebp-Ch]
  int v8; // [esp+80h] [ebp-4h]

  sub_3F5650(a1: dword_F71250); /*0x8dcba1*/
  v8 = 0; /*0x8dcba6*/
  sub_7511C0(a1: v6, a2: 1); /*0x8dcbb9*/
  v8 = -1; /*0x8dcbbe*/
  sub_3F56D0(a1: v6); /*0x8dcbc8*/
  sub_3F5650(a1: dword_F71258); /*0x8dcbd6*/
  v8 = 1; /*0x8dcbdb*/
  sub_7511C0(a1: v5, a2: 0); /*0x8dcbee*/
  v8 = -1; /*0x8dcbf3*/
  sub_3F56D0(a1: v5); /*0x8dcbfd*/
  sub_3F5650(a1: dword_F7124C); /*0x8dcc0b*/
  v8 = 2; /*0x8dcc10*/
  sub_7511C0(a1: v4, a2: 0); /*0x8dcc23*/
  v8 = -1; /*0x8dcc28*/
  sub_3F56D0(a1: v4); /*0x8dcc32*/
  sub_3F5650(a1: dword_F71248); /*0x8dcc40*/
  v8 = 3; /*0x8dcc45*/
  sub_7511C0(a1: v3, a2: 0); /*0x8dcc58*/
  v8 = -1; /*0x8dcc5d*/
  sub_3F56D0(a1: v3); /*0x8dcc67*/
  sub_A2CA00(a1: 21430, a2: 0); /*0x8dcc73*/
  sub_A2CA00(a1: 5272, a2: 0); /*0x8dcc82*/
  result = sub_8DC120(a1); /*0x8dcc8d*/
  __writefsdword(0, v7); /*0x8dcc95*/
  return result; /*0x8dcc9d*/
}
