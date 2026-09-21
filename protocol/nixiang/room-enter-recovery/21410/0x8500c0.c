int __thiscall sub_8500C0(char *this, int a2, int a3)
{
  int result; // eax
  int i; // [esp+4h] [ebp-4h]

  result = sub_4FEF60(a1: this + 1432, a2: this); /*0x8500d2*/
  for ( i = 0; i < a3; ++i ) /*0x8500d7*/
  {
    sub_507500(a1: a2 + 21 * i); /*0x850104*/
    result = i + 1; /*0x8500e3*/
  }
  return result; /*0x85010b*/
}
