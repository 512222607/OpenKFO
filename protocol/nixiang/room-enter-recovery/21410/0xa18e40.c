unsigned int __stdcall sub_A18E40(int a1, unsigned int a2)
{
  unsigned int result; // eax
  signed int v3; // [esp+4h] [ebp-4h]

  result = a2 / 0x15; /*0xa18e53*/
  v3 = a2 / 0x15; /*0xa18e55*/
  if ( a1 == 0 || v3 < 1 ) /*0xa18e62*/
    return result; /*0xa18e8a*/
  result = a2 / 0x15; /*0xa18e6e*/
  if ( a2 % 0x15 != 0 ) /*0xa18e72*/
    return result; /*0xa18e8a*/
  sub_8515E0(); /*0xa18e7e*/
  return sub_8500C0(a1, a2: v3); /*0xa18e85*/
}
