void __stdcall sub_815250(int a1, int a2)
{
  int v2; // eax
  int v3; // [esp+8h] [ebp-34h]
  _BYTE v4[28]; // [esp+10h] [ebp-2Ch] BYREF
  int v5; // [esp+2Ch] [ebp-10h]
  unsigned int v6; // [esp+30h] [ebp-Ch]
  int v7; // [esp+38h] [ebp-4h]

  if ( a1 != 0 && a2 == 259 ) /*0x815285*/
  {
    v5 = a1; /*0x81528f*/
    if ( *(_BYTE *)(a1 + 4) == 1 ) /*0x81529c*/
    {
      sub_4D77F0(); /*0x8152a2*/
      sub_5394D0(a1: v5); /*0x8152a9*/
      v3 = sub_4D77F0(); /*0x8152b3*/
      (*(void (__fastcall **)(int))(*(_DWORD *)v3 + 264))(a1: v3); /*0x8152c4*/
    }
    else
    {
      sub_3F5650(a1: aEuatUstate); /*0x8152d0*/
      v7 = 0; /*0x8152d5*/
      v2 = sub_3F3820(); /*0x8152dc*/
      (*(void (__thiscall **)(int, _BYTE *, _DWORD, _DWORD, _DWORD))(*(_DWORD *)v2 + 448))( /*0x8152fc*/
        a1: v2,
        a2: v4,
        a3: 0,
        a4: 0,
        a5: 0);
      v7 = -1; /*0x8152fe*/
      sub_3F56D0(a1: v4); /*0x815308*/
    }
  }
  __writefsdword(0, v6); /*0x815310*/
}
