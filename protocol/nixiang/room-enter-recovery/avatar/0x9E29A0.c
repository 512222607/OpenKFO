int __thiscall sub_9E29A0(_DWORD *this, int a2)
{
  int result; // eax

  *(this + 1779) = a2; /*0x9e29ad*/
  result = sub_9D7C70(a1: this); /*0x9e29b6*/
  if ( result != 0 ) /*0x9e29bd*/
    return result; /*0x9e29e4*/
  result = sub_80B800(this: (_DWORD *)dword_17C8708); /*0x9e29c5*/
  if ( result == 0 ) /*0x9e29cc*/
    return result; /*0x9e29e4*/
  sub_80B800(this: (_DWORD *)dword_17C8708); /*0x9e29d8*/
  return sub_7EBC60(a1: this); /*0x9e29df*/
}
