void __thiscall sub_9D9680(char *this, int a2)
{
  if ( a2 != 0 ) /*0x9d968b*/
  {
    if ( sub_6595D0(a1: a2, a2: aCompanylogo) != 0 ) /*0x9d96a0*/
    {
      sub_401C60(a1: this + 7000, a2: &unk_B9B468); /*0x9d96b5*/
      if ( sub_9D7C70(a1: this) != 0 ) /*0x9d96c7*/
        sub_443C00(a1: a2); /*0x9d96d3*/
    }
    else
    {
      sub_3F63A0(a1: this + 7000); /*0x9d96e3*/
      if ( sub_9D7C70(a1: this) != 0 ) /*0x9d96f2*/
        sub_443C00(a1: &aBattlemodeDoac[5]); /*0x9d96ff*/
    }
  }
}
