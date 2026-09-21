unsigned int __stdcall sub_80EA80(int a1, int a2)
{
  unsigned int result; // eax
  signed int i; // [esp+4h] [ebp-10h]
  int v4; // [esp+8h] [ebp-Ch]
  signed int v5; // [esp+Ch] [ebp-8h]

  if ( a1 == 0 ) /*0x80ea8d*/
    return result; /*0x80eb34*/
  result = (a2 - 8) / 0x44u; /*0x80ea9c*/
  if ( (a2 - 8) % 0x44u != 0 ) /*0x80eaa0*/
    return result; /*0x80eb34*/
  v5 = (a2 - 8) / 0x44u; /*0x80eab6*/
  if ( v5 != 0 ) /*0x80eabd*/
    sub_80B210(a1: 1); /*0x80ead6*/
  else
    sub_80B210(a1: 0); /*0x80eac7*/
  result = sub_53AAC0(a1: *(_DWORD *)(a1 + 4)); /*0x80eaee*/
  v4 = a1 + 8; /*0x80eaf9*/
  for ( i = 0; i < v5; ++i ) /*0x80eafc*/
  {
    sub_80B290(a1: v4, a2: i); /*0x80eb24*/
    v4 += 68; /*0x80eb2f*/
    result = i + 1; /*0x80eb08*/
  }
  return result; /*0x80eb34*/
}
