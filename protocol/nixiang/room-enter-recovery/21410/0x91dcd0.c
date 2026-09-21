int __thiscall sub_91DCD0(int this, char a2)
{
  int result; // eax
  _BYTE v4[4]; // [esp+4h] [ebp-4h] BYREF

  result = this; /*0x91dcd9*/
  if ( *(_DWORD *)(this + 248) == 10 || *(_DWORD *)(this + 248) == 11 ) /*0x91dcef*/
    return result; /*0x91dd36*/
  v4[1] = a2; /*0x91dcf6*/
  v4[0] = *(_DWORD *)(this + 224) + 1; /*0x91dd05*/
  v4[2] = *(_BYTE *)(this + 333); /*0x91dd11*/
  result = sub_A2C950(a1: 2260, a2: 0, a3: v4, a4: 3); /*0x91dd21*/
  *(_DWORD *)(this + 248) = 11; /*0x91dd2c*/
  return result; /*0x91dd36*/
}
