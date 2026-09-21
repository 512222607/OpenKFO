int __thiscall sub_91DD40(_BYTE *this, char a2)
{
  int result; // eax
  _BYTE v3[4]; // [esp+4h] [ebp-4h] BYREF

  if ( dword_17C8714 == 0 ) /*0x91dd50*/
    return result; /*0x91dd87*/
  v3[1] = a2; /*0x91dd57*/
  v3[0] = *(this + 224); /*0x91dd63*/
  v3[2] = *(this + 333); /*0x91dd6f*/
  return sub_A2C950(a1: 2260, a2: 0, a3: v3, a4: 3); /*0x91dd7f*/
}
