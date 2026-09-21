_DWORD *__fastcall sub_851490(_DWORD *a1)
{
  _BYTE v3[28]; // [esp+8h] [ebp-44h] BYREF
  _BYTE v4[28]; // [esp+24h] [ebp-28h] BYREF
  unsigned int v5; // [esp+40h] [ebp-Ch]
  int v6; // [esp+48h] [ebp-4h]

  sub_3F5650(a1: off_B98894); /*0x8514c1*/
  v6 = 1; /*0x8514c6*/
  sub_3F5650(a1: off_B98890); /*0x8514d7*/
  sub_7CA5F0(a1: v3, a2: v4, a3: 0); /*0x8514ed*/
  LOBYTE(v6) = 3; /*0x8514f2*/
  sub_3F56D0(a1: v3); /*0x8514f9*/
  LOBYTE(v6) = 4; /*0x8514fe*/
  sub_3F56D0(a1: v4); /*0x851505*/
  *a1 = &aFerrorInFuncti_183[24]; /*0x85150d*/
  a1[1] = &aInvalidSelfInF_189[36]; /*0x851516*/
  a1[167] = &aFerrorInFuncti_189[8]; /*0x851520*/
  a1[168] = 12345836; /*0x85152d*/
  a1[169] = 12345848; /*0x85153a*/
  a1[170] = &aInvalidSelfInF_190[12]; /*0x851547*/
  a1[171] = 12345880; /*0x851554*/
  a1[172] = &aFerrorInFuncti_190[20]; /*0x851561*/
  a1[173] = 12345936; /*0x85156e*/
  a1[174] = &aInvalidSelfInF_191[8]; /*0x85157b*/
  sub_44E410(a1: a1 + 352); /*0x85158e*/
  LOBYTE(v6) = 5; /*0x851593*/
  sub_507340(a1: a1 + 358); /*0x8515a0*/
  LOBYTE(v6) = 6; /*0x8515a5*/
  sub_4069F0(a1: a1 + 364); /*0x8515b2*/
  a1[372] = 0; /*0x8515ba*/
  __writefsdword(0, v5); /*0x8515d1*/
  return a1; /*0x8515d9*/
}
