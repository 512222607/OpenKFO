unsigned int __stdcall sub_8143D0(int a1, int a2)
{
  unsigned int result; // eax
  signed int i; // [esp+4h] [ebp-10h]
  int v4; // [esp+8h] [ebp-Ch]
  signed int v5; // [esp+Ch] [ebp-8h]

  if ( a1 == 0 ) /*0x8143dd*/
    return result; /*0x814484*/
  result = (a2 - 8) / 0x44u; /*0x8143ec*/
  if ( (a2 - 8) % 0x44u != 0 ) /*0x8143f0*/
    return result; /*0x814484*/
  v5 = (a2 - 8) / 0x44u; /*0x814406*/
  if ( v5 != 0 ) /*0x81440d*/
    sub_91E780(a1: 1); /*0x814426*/
  else
    sub_91E780(a1: 0); /*0x814417*/
  result = sub_539600(a1: *(_DWORD *)(a1 + 4)); /*0x81443e*/
  v4 = a1 + 8; /*0x814449*/
  for ( i = 0; i < v5; ++i ) /*0x81444c*/
  {
    sub_91E6C0(a1: v4, a2: i); /*0x814474*/
    v4 += 68; /*0x81447f*/
    result = i + 1; /*0x814458*/
  }
  return result; /*0x814484*/
}
