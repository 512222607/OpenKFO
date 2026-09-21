int __thiscall sub_80CB00(
        _DWORD **this,
        int a2,
        int a3,
        unsigned int a4,
        int a5,
        int a6,
        int a7,
        int a8,
        _DWORD *a9,
        char a10)
{
  int result; // eax
  int v11; // eax
  int *v12; // eax
  int v13; // eax
  int v14; // eax
  int v15; // eax
  int v16; // eax
  int v17; // [esp-Ch] [ebp-74h]
  int v18; // [esp+4h] [ebp-64h]
  int v19; // [esp+8h] [ebp-60h]
  int v20; // [esp+Ch] [ebp-5Ch]
  int v21; // [esp+10h] [ebp-58h]
  int v22; // [esp+18h] [ebp-50h]
  char v24[4]; // [esp+20h] [ebp-48h] BYREF
  char v25[4]; // [esp+24h] [ebp-44h] BYREF
  int v26; // [esp+28h] [ebp-40h]
  int v27; // [esp+2Ch] [ebp-3Ch]
  void (__thiscall ***v28)(_DWORD, int); // [esp+30h] [ebp-38h]
  void (__thiscall ***v29)(_DWORD, int); // [esp+34h] [ebp-34h]
  int v30; // [esp+38h] [ebp-30h]
  int v31; // [esp+3Ch] [ebp-2Ch]
  float v32[2]; // [esp+40h] [ebp-28h] BYREF
  float v33; // [esp+48h] [ebp-20h]
  int v34; // [esp+4Ch] [ebp-1Ch] BYREF
  int v35; // [esp+50h] [ebp-18h]
  int v36; // [esp+54h] [ebp-14h]
  int v37; // [esp+58h] [ebp-10h]
  unsigned int v38; // [esp+5Ch] [ebp-Ch]
  int v39; // [esp+64h] [ebp-4h]

  if ( a4 < 8 && a8 != 0 && a9 != nullptr ) /*0x80cb3e*/
  {
    if ( *(_DWORD *)sub_4A6920(a1: &a4) != 0 ) /*0x80cb5c*/
      sub_80BC10(a1: a4); /*0x80cb65*/
    v37 = 0; /*0x80cb6a*/
    if ( a10 != 0 ) /*0x80cb77*/
    {
      v30 = sub_657FBB(a1: 8744); /*0x80cb86*/
      v39 = 0; /*0x80cb89*/
      if ( v30 != 0 ) /*0x80cb94*/
        v22 = sub_9F0210(a1: a2, a2: a3); /*0x80cba6*/
      else
        v22 = 0; /*0x80cbab*/
      v31 = v22; /*0x80cbb5*/
      v39 = -1; /*0x80cbb8*/
      v37 = v22; /*0x80cbc2*/
      sub_53AF80(a1: a10); /*0x80cbcd*/
    }
    else
    {
      if ( *(_DWORD *)sub_4A6920(a1: &a4) != 0 ) /*0x80cbec*/
      {
        v28 = *(void (__thiscall ****)(_DWORD, int))sub_4A6920(a1: &a4); /*0x80cc02*/
        v29 = v28; /*0x80cc08*/
        if ( v28 != nullptr ) /*0x80cc0f*/
          (**v29)(a1: v29, a2: 1); /*0x80cc1d*/
        *(_DWORD *)sub_4A6920(a1: &a4) = 0; /*0x80cc3d*/
      }
      v26 = sub_657FBB(a1: 7592); /*0x80cc50*/
      v39 = 1; /*0x80cc53*/
      if ( v26 != 0 ) /*0x80cc5e*/
        v21 = sub_9D8FC0(a1: a2, a2: a3); /*0x80cc70*/
      else
        v21 = 0; /*0x80cc75*/
      v27 = v21; /*0x80cc7f*/
      v39 = -1; /*0x80cc82*/
      v37 = v21; /*0x80cc8c*/
    }
    *(_DWORD *)sub_4A6920(a1: &a4) = v37; /*0x80cca4*/
    if ( v37 != 0 ) /*0x80ccaa*/
    {
      sub_9E3540(a1: a8, a2: 0); /*0x80ccbc*/
      sub_9DF920(a1: 0); /*0x80ccc6*/
      sub_443950(a1: a5); /*0x80ccd2*/
      sub_3F5FD0(a1: a7); /*0x80ccde*/
      v39 = 2; /*0x80cce3*/
      sub_444840(a1: v25); /*0x80ccf1*/
      v39 = -1; /*0x80ccf6*/
      sub_3F6050(a1: v25); /*0x80cd00*/
      sub_9D43F0(a1: a6); /*0x80cd0c*/
      v11 = sub_807D00(a1: v37); /*0x80cd18*/
      v12 = (int *)(sub_422810(a1: v11) + 4); /*0x80cd29*/
      v34 = *v12; /*0x80cd2e*/
      v35 = v12[1]; /*0x80cd34*/
      v36 = v12[2]; /*0x80cd3a*/
      sub_9D9FC0(a1: v34, a2: v35, a3: v36); /*0x80cd56*/
      if ( sub_43E0D0(a1: v37) != 0 ) /*0x80cd65*/
      {
        v13 = sub_43E0D0(a1: v37); /*0x80cd6e*/
        if ( sub_43E320(a1: v13) != 0 ) /*0x80cd7c*/
        {
          v14 = sub_43E0D0(a1: v37); /*0x80cd81*/
          v33 = *(float *)(sub_425F90(a1: v14) + 28); /*0x80cd90*/
          v32[0] = v33; /*0x80cd9c*/
          v32[1] = v33 * dbl_BE9E50; /*0x80cda8*/
          v15 = sub_43E0D0(a1: v37); /*0x80cdae*/
          v20 = sub_43E320(a1: v15); /*0x80cdba*/
          (*(void (__thiscall **)(int, float *))(*(_DWORD *)v20 + 32))(a1: v20, a2: v32); /*0x80cdcc*/
          v16 = sub_43E0D0(a1: v37); /*0x80cdd1*/
          v19 = sub_43E320(a1: v16); /*0x80cddd*/
          (*(void (__thiscall **)(int, int *, int))(*(_DWORD *)v19 + 52))(a1: v19, a2: &v34, a3: 1); /*0x80cdf1*/
        }
      }
      v17 = v37; /*0x80cdfd*/
      sub_3F1040(a1: v37); /*0x80ce01*/
      sub_9CDCE0(a1: v17, a2: 5001, a3: 0); /*0x80ce08*/
      sub_9EAC40(a1: v37); /*0x80ce10*/
      sub_3F5FD0(a1: (char *)a9 + 78); /*0x80ce1f*/
      v39 = 3; /*0x80ce24*/
      sub_53AB90(a1: v24); /*0x80ce32*/
      v39 = -1; /*0x80ce37*/
      sub_3F6050(a1: v24); /*0x80ce41*/
      sub_53ABB0(a1: a9[30]); /*0x80ce50*/
      sub_55D980(a1: a9[31]); /*0x80ce5f*/
      sub_53AB70(a1: a9[32]); /*0x80ce71*/
      sub_53AB30(a1: a9[34]); /*0x80ce83*/
      sub_53AF40(a1: a9[35]); /*0x80ce95*/
      if ( sub_9D7C70(a1: v37) != 0 ) /*0x80cea4*/
      {
        sub_80B800(a1: this); /*0x80ceab*/
        sub_7EB070(a1: 1); /*0x80ceb2*/
      }
      (*(void (__thiscall **)(_DWORD, int))(**(this + 231) + 8))(a1: *(this + 231), a2: v37); /*0x80ced2*/
      if ( sub_80B800(a1: this) != 0 ) /*0x80cede*/
      {
        v18 = sub_80B800(a1: this); /*0x80cee8*/
        (*(void (__fastcall **)(int))(*(_DWORD *)v18 + 484))(a1: v18); /*0x80cef9*/
      }
      result = v37; /*0x80cefb*/
    }
    else
    {
      result = 0; /*0x80ccac*/
    }
  }
  else
  {
    result = 0; /*0x80cb40*/
  }
  __writefsdword(0, v38); /*0x80cf01*/
  return result; /*0x80cf09*/
}
