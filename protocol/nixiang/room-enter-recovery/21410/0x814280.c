void __thiscall sub_814280(void *this, _DWORD *a2, int a3)
{
  int v3; // eax
  signed int i; // [esp+4h] [ebp-10h]
  signed int v6; // [esp+8h] [ebp-Ch]
  _DWORD *v7; // [esp+Ch] [ebp-8h]

  if ( a2 != nullptr && (a3 - 8) % 0x103u == 0 ) /*0x8142a0*/
  {
    v6 = (a3 - 8) / 0x103u; /*0x8142bd*/
    if ( v6 != 0 ) /*0x8142c4*/
    {
      sub_91E5D0(this: (_DWORD *)dword_17C870C, a2: 1); /*0x814314*/
    }
    else
    {
      sub_91E5D0(this: (_DWORD *)dword_17C870C, a2: 0); /*0x8142ce*/
      if ( sub_5395C0(a1: dword_17C870C) > 1 ) /*0x8142e1*/
      {
        v3 = sub_5395C0(a1: dword_17C870C); /*0x8142e9*/
        sub_4D7200(a1: v3 - 1); /*0x8142f8*/
        sub_91DD40(this: (_BYTE *)dword_17C870C, a2: 0); /*0x814305*/
      }
    }
    sub_4D12F0(a1: a2[1]); /*0x81432c*/
    sub_539660(a1: *a2); /*0x81433d*/
    v7 = a2 + 2; /*0x814348*/
    for ( i = 0; i < v6; ++i ) /*0x81434b*/
    {
      sub_91DF80(a1: v7); /*0x81436f*/
      v7 = (_DWORD *)((char *)v7 + 259); /*0x81437d*/
    }
    sub_91E480(a1: dword_17C870C); /*0x814388*/
    (*(void (__fastcall **)(void *))(*(_DWORD *)this + 16))(a1: this); /*0x814398*/
  }
}
