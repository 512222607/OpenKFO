int __thiscall sub_91E5D0(_DWORD *this, int a2)
{
  int result; // eax

  if ( a2 != 0 ) /*0x91e5db*/
  {
    result = sub_91E3F0(a1: this); /*0x91e5f7*/
    if ( *(this + 62) == 10 ) /*0x91e606*/
    {
      if ( (int)*(this + 56) > 1 ) /*0x91e612*/
      {
        result = (int)this; /*0x91e614*/
        --*(this + 56); /*0x91e623*/
      }
    }
    else
    {
      result = (int)this; /*0x91e62b*/
      if ( *(this + 62) == 11 ) /*0x91e635*/
      {
        result = (int)this; /*0x91e643*/
        ++*(this + 56); /*0x91e646*/
      }
    }
    *(this + 62) = 12; /*0x91e64f*/
  }
  else
  {
    *(this + 62) = 12; /*0x91e5e0*/
    return sub_91E3F0(a1: this); /*0x91e5ed*/
  }
  return result; /*0x91e659*/
}
