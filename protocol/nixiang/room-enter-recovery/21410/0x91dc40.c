int __thiscall sub_91DC40(int this, char a2)
{
  int result; // eax
  _BYTE v4[4]; // [esp+4h] [ebp-4h] BYREF

  result = this; /*0x91dc49*/
  if ( *(_DWORD *)(this + 248) == 10 || *(_DWORD *)(this + 248) == 11 ) /*0x91dc5f*/
    return result; /*0x91dcc0*/
  v4[1] = a2; /*0x91dc66*/
  if ( *(int *)(this + 224) <= 1 ) /*0x91dc73*/
    v4[0] = *(_BYTE *)(this + 224); /*0x91dc8f*/
  else
    v4[0] = *(_DWORD *)(this + 224) - 1; /*0x91dc81*/
  v4[2] = *(_BYTE *)(this + 333); /*0x91dc9b*/
  result = sub_A2C950(a1: 2260, a2: 0, a3: v4, a4: 3); /*0x91dcab*/
  *(_DWORD *)(this + 248) = 10; /*0x91dcb6*/
  return result; /*0x91dcc0*/
}
