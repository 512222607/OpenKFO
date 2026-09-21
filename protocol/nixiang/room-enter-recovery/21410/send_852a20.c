unsigned int __fastcall sub_852A20(int a1)
{
  unsigned int result; // eax
  int v2; // eax
  int v3; // eax
  int v4; // eax
  int v5; // eax
  int v6; // eax
  int v7; // eax
  int v8; // eax
  int v9; // eax
  int v10; // eax
  int v11; // eax
  int v12; // eax
  int v13; // eax
  unsigned int v14; // eax
  int v15; // eax
  int v16; // eax
  int v17; // eax
  long double v18; // fst7
  int v19; // eax
  int v20; // [esp+20h] [ebp-398h]
  __int64 v21; // [esp+28h] [ebp-390h]
  int v22; // [esp+30h] [ebp-388h]
  int v23; // [esp+38h] [ebp-380h]
  __int64 v24; // [esp+40h] [ebp-378h]
  int v25; // [esp+48h] [ebp-370h]
  int v26; // [esp+50h] [ebp-368h]
  int v27; // [esp+60h] [ebp-358h]
  int v28; // [esp+68h] [ebp-350h]
  int v29; // [esp+70h] [ebp-348h]
  int v30; // [esp+78h] [ebp-340h]
  int v31; // [esp+80h] [ebp-338h]
  int v32; // [esp+88h] [ebp-330h]
  int v33; // [esp+90h] [ebp-328h]
  int v34; // [esp+98h] [ebp-320h]
  int v35; // [esp+A0h] [ebp-318h]
  int v36; // [esp+A8h] [ebp-310h]
  int v37; // [esp+B0h] [ebp-308h]
  int v38; // [esp+B8h] [ebp-300h]
  _BYTE v40[28]; // [esp+C4h] [ebp-2F4h] BYREF
  _BYTE v41[28]; // [esp+E0h] [ebp-2D8h] BYREF
  _BYTE v42[28]; // [esp+FCh] [ebp-2BCh] BYREF
  _BYTE v43[28]; // [esp+118h] [ebp-2A0h] BYREF
  int v44; // [esp+134h] [ebp-284h] BYREF
  _BYTE v45[28]; // [esp+138h] [ebp-280h] BYREF
  _BYTE v46[28]; // [esp+154h] [ebp-264h] BYREF
  _BYTE v47[28]; // [esp+170h] [ebp-248h] BYREF
  _BYTE v48[28]; // [esp+18Ch] [ebp-22Ch] BYREF
  _BYTE v49[28]; // [esp+1A8h] [ebp-210h] BYREF
  _BYTE v50[28]; // [esp+1C4h] [ebp-1F4h] BYREF
  _BYTE v51[28]; // [esp+1E0h] [ebp-1D8h] BYREF
  _BYTE v52[28]; // [esp+1FCh] [ebp-1BCh] BYREF
  _BYTE v53[28]; // [esp+218h] [ebp-1A0h] BYREF
  _BYTE v54[28]; // [esp+234h] [ebp-184h] BYREF
  _BYTE v55[28]; // [esp+250h] [ebp-168h] BYREF
  _BYTE v56[28]; // [esp+26Ch] [ebp-14Ch] BYREF
  _BYTE v57[28]; // [esp+288h] [ebp-130h] BYREF
  _BYTE v58[28]; // [esp+2A4h] [ebp-114h] BYREF
  _BYTE v59[28]; // [esp+2C0h] [ebp-F8h] BYREF
  _BYTE v60[28]; // [esp+2DCh] [ebp-DCh] BYREF
  _BYTE v61[28]; // [esp+2F8h] [ebp-C0h] BYREF
  _BYTE v62[28]; // [esp+314h] [ebp-A4h] BYREF
  unsigned int v63; // [esp+330h] [ebp-88h] BYREF
  _BYTE v64[68]; // [esp+334h] [ebp-84h] BYREF
  float v65; // [esp+37Ch] [ebp-3Ch]
  unsigned int v66; // [esp+380h] [ebp-38h]
  float v67; // [esp+384h] [ebp-34h]
  int v68; // [esp+388h] [ebp-30h]
  int v69; // [esp+38Ch] [ebp-2Ch]
  int v70; // [esp+390h] [ebp-28h]
  unsigned int v71; // [esp+394h] [ebp-24h]
  int v72; // [esp+398h] [ebp-20h]
  int v73; // [esp+39Ch] [ebp-1Ch]
  int v74; // [esp+3A0h] [ebp-18h]
  int i; // [esp+3A4h] [ebp-14h] BYREF
  int v76; // [esp+3A8h] [ebp-10h]
  unsigned int v77; // [esp+3ACh] [ebp-Ch]
  int v78; // [esp+3B4h] [ebp-4h]

  if ( sub_5074B0(a1: a1 + 1432) != 0 ) /*0x852a65*/
  {
    sub_3F5650(a1: &unk_B988A8); /*0x852a86*/
    v78 = 0; /*0x852a8b*/
    v2 = sub_74FBF0(a1: v62); /*0x852aab*/
    v76 = sub_A87B0E(a1: v2, a2: 0, a3: &unk_12F8898, a4: &unk_12FA3B4, a5: 0); /*0x852abb*/
    v78 = -1; /*0x852abe*/
    result = sub_3F56D0(a1: v62); /*0x852acb*/
    if ( v76 != 0 ) /*0x852ad4*/
    {
      result = sub_A7F8F0(a1: 24); /*0x852ae0*/
      for ( i = 0; i < 24; ++i ) /*0x852ae5*/
      {
        v71 = i + 24 * *(_DWORD *)(a1 + 1488); /*0x852b13*/
        v38 = sub_A34160(a1: v61, a2: (const char *)&i); /*0x852b35*/
        v78 = 1; /*0x852b3b*/
        v37 = sub_401D70(a1: v60, a2: &unk_B988B8, a3: v38); /*0x852b69*/
        LOBYTE(v78) = 2; /*0x852b6f*/
        v3 = sub_747100(a1: v37); /*0x852b8b*/
        v73 = sub_A87B0E(a1: v3, a2: 0, a3: &unk_12F8898, a4: &unk_12F92CC, a5: 0); /*0x852b99*/
        LOBYTE(v78) = 1; /*0x852b9c*/
        sub_3F56D0(a1: v60); /*0x852ba6*/
        v78 = -1; /*0x852bab*/
        sub_3F56D0(a1: v61); /*0x852bb8*/
        v36 = sub_A34160(a1: v59, a2: (const char *)&i); /*0x852bdc*/
        v78 = 3; /*0x852be2*/
        v35 = sub_401D70(a1: v58, a2: &unk_B988C0, a3: v36); /*0x852c10*/
        LOBYTE(v78) = 4; /*0x852c16*/
        v68 = sub_747100(a1: v35); /*0x852c29*/
        LOBYTE(v78) = 3; /*0x852c2c*/
        sub_3F56D0(a1: v58); /*0x852c36*/
        v78 = -1; /*0x852c3b*/
        sub_3F56D0(a1: v59); /*0x852c48*/
        v34 = sub_A34160(a1: v57, a2: (const char *)&i); /*0x852c6c*/
        v78 = 5; /*0x852c72*/
        v33 = sub_401D70(a1: v56, a2: &unk_B988D8, a3: v34); /*0x852ca0*/
        LOBYTE(v78) = 6; /*0x852ca6*/
        v4 = sub_747100(a1: v33); /*0x852cc2*/
        v69 = sub_A87B0E(a1: v4, a2: 0, a3: &unk_12F8898, a4: &unk_12F8A44, a5: 0); /*0x852cd0*/
        LOBYTE(v78) = 5; /*0x852cd3*/
        sub_3F56D0(a1: v56); /*0x852cdd*/
        v78 = -1; /*0x852ce2*/
        sub_3F56D0(a1: v57); /*0x852cef*/
        v32 = sub_A34160(a1: v55, a2: (const char *)&i); /*0x852d13*/
        v78 = 7; /*0x852d19*/
        v31 = sub_401D70(a1: v54, a2: &unk_B988E4, a3: v32); /*0x852d47*/
        LOBYTE(v78) = 8; /*0x852d4d*/
        v5 = sub_747100(a1: v31); /*0x852d69*/
        v70 = sub_A87B0E(a1: v5, a2: 0, a3: &unk_12F8898, a4: &unk_12F8A64, a5: 0); /*0x852d77*/
        LOBYTE(v78) = 7; /*0x852d7a*/
        sub_3F56D0(a1: v54); /*0x852d84*/
        v78 = -1; /*0x852d89*/
        sub_3F56D0(a1: v55); /*0x852d96*/
        v30 = sub_A34160(a1: v53, a2: (const char *)&i); /*0x852dba*/
        v78 = 9; /*0x852dc0*/
        v29 = sub_401D70(a1: v52, a2: &unk_B988F4, a3: v30); /*0x852dee*/
        LOBYTE(v78) = 10; /*0x852df4*/
        v6 = sub_747100(a1: v29); /*0x852e10*/
        v72 = sub_A87B0E(a1: v6, a2: 0, a3: &unk_12F8898, a4: &unk_12F8A44, a5: 0); /*0x852e1e*/
        LOBYTE(v78) = 9; /*0x852e21*/
        sub_3F56D0(a1: v52); /*0x852e2b*/
        v78 = -1; /*0x852e30*/
        sub_3F56D0(a1: v53); /*0x852e3d*/
        v28 = sub_A34160(a1: v51, a2: (const char *)&i); /*0x852e61*/
        v78 = 11; /*0x852e67*/
        v27 = sub_401D70(a1: v50, a2: &unk_B98904, a3: v28); /*0x852e95*/
        LOBYTE(v78) = 12; /*0x852e9b*/
        v7 = sub_747100(a1: v27); /*0x852eb7*/
        v74 = sub_A87B0E(a1: v7, a2: 0, a3: &unk_12F8898, a4: &unk_12F8A44, a5: 0); /*0x852ec5*/
        LOBYTE(v78) = 11; /*0x852ec8*/
        sub_3F56D0(a1: v50); /*0x852ed2*/
        v78 = -1; /*0x852ed7*/
        result = sub_3F56D0(a1: v51); /*0x852ee4*/
        if ( v73 != 0 && v68 != 0 && v69 != 0 && v70 != 0 && v72 != 0 && v74 != 0 ) /*0x852f0b*/
        {
          sub_74AA30(a1: 0); /*0x852f17*/
          sub_3F5650(a1: &aBattlemodeDoac[5]); /*0x852f27*/
          v78 = 13; /*0x852f2c*/
          (*(void (__thiscall **)(int, _BYTE *, int))(*(_DWORD *)v69 + 212))(a1: v69, a2: v49, a3: 1); /*0x852f4a*/
          v78 = -1; /*0x852f4c*/
          sub_3F56D0(a1: v49); /*0x852f59*/
          result = sub_5471D0(a1: a1 + 1408); /*0x852f6a*/
          if ( v71 < result ) /*0x852f72*/
          {
            v20 = *(_DWORD *)(sub_549130(a1: v71) + 5); /*0x852f90*/
            sub_A11B30(); /*0x852f91*/
            result = sub_A0E560(a1: v20); /*0x852f98*/
            v66 = result; /*0x852f9d*/
            if ( result != 0 ) /*0x852fa4*/
            {
              sub_74AA30(a1: 1); /*0x852fb0*/
              v8 = sub_3F6410(a1: v66 + 68); /*0x852fbb*/
              sub_3F5650(a1: v8); /*0x852fc7*/
              v78 = 14; /*0x852fcc*/
              (*(void (__thiscall **)(int, _BYTE *))(*(_DWORD *)v68 + 40))(a1: v68, a2: v48); /*0x852fe5*/
              v78 = -1; /*0x852fe7*/
              sub_3F56D0(a1: v48); /*0x852ff4*/
              v9 = sub_549130(a1: v71); /*0x853009*/
              v10 = sub_507580(a1: v9 + 5); /*0x85301e*/
              if ( (unsigned __int8)sub_40AFB0(a1: v10) != 0 ) /*0x85302f*/
              {
                v11 = sub_3F6410(a1: v66 + 12); /*0x853037*/
                sub_3F5650(a1: v11); /*0x853043*/
                v78 = 15; /*0x853048*/
                (*(void (__thiscall **)(int, _BYTE *, int))(*(_DWORD *)v69 + 212))(a1: v69, a2: v47, a3: 1); /*0x853066*/
                v78 = -1; /*0x853068*/
                sub_3F56D0(a1: v47); /*0x853075*/
              }
              else
              {
                v12 = sub_549130(a1: v71); /*0x85308e*/
                v13 = sub_507580(a1: v12 + 5); /*0x8530a3*/
                (*(void (__thiscall **)(int, int, int))(*(_DWORD *)v69 + 212))(a1: v69, a2: v13, a3: 1); /*0x8530b7*/
              }
              v67 = (float)*(unsigned int *)(sub_549130(a1: v71) + 47); /*0x8530e7*/
              v63 = *(_DWORD *)(sub_549130(a1: v71) + 43); /*0x853102*/
              v14 = sub_5074B0(a1: a1 + 1432); /*0x853114*/
              if ( v63 >= v14 ) /*0x85311f*/
              {
                v44 = sub_5074B0(a1: a1 + 1432) - 1; /*0x853233*/
                v23 = sub_4A9190(a1: v43, a2: &v44); /*0x85325b*/
                v78 = 18; /*0x853261*/
                v22 = sub_401D70(a1: v42, a2: &unk_BBD520, a3: v23); /*0x85328f*/
                LOBYTE(v78) = 19; /*0x853295*/
                (*(void (__thiscall **)(int, int, int))(*(_DWORD *)v74 + 212))(a1: v74, a2: v22, a3: 1); /*0x8532b0*/
                LOBYTE(v78) = 18; /*0x8532b2*/
                sub_3F56D0(a1: v42); /*0x8532bc*/
                v78 = -1; /*0x8532c1*/
                sub_3F56D0(a1: v43); /*0x8532ce*/
                v16 = sub_5074B0(a1: a1 + 1432); /*0x8532df*/
                v21 = *(unsigned int *)(sub_5074D0(a1: v16 - 1) + 4); /*0x8532fc*/
                v65 = v67 / (long double)v21; /*0x853315*/
                v17 = sub_5074B0(a1: a1 + 1432); /*0x853324*/
                v15 = sub_5074D0(a1: v17 - 1); /*0x853339*/
              }
              else
              {
                v26 = sub_A34160(a1: v46, a2: (const char *)&v63); /*0x853147*/
                v78 = 16; /*0x85314d*/
                v25 = sub_401D70(a1: v45, a2: &unk_BBD520, a3: v26); /*0x85317b*/
                LOBYTE(v78) = 17; /*0x853181*/
                (*(void (__thiscall **)(int, int, int))(*(_DWORD *)v74 + 212))(a1: v74, a2: v25, a3: 1); /*0x85319c*/
                LOBYTE(v78) = 16; /*0x85319e*/
                sub_3F56D0(a1: v45); /*0x8531a8*/
                v78 = -1; /*0x8531ad*/
                sub_3F56D0(a1: v46); /*0x8531ba*/
                v24 = *(unsigned int *)(sub_5074D0(a1: v63) + 4); /*0x8531da*/
                v65 = v67 / (long double)v24; /*0x8531f3*/
                v15 = sub_5074D0(a1: v63); /*0x853209*/
              }
              sub_4A2370(a1: *(_DWORD *)(v15 + 4)); /*0x853215*/
              sub_653BEB(a1: v64, a2: 64, a3: 12345304, v65 * dbl_BE8460); /*0x853367*/
              sub_655B50(a1: v64, a2: &unk_BBEA68); /*0x85337b*/
              if ( v65 < (long double)dbl_BE8350 ) /*0x853391*/
              {
                sub_3F5650(a1: v64); /*0x8533e4*/
                v78 = 21; /*0x8533e9*/
                (*(void (__thiscall **)(int, _BYTE *, int))(*(_DWORD *)v72 + 212))(a1: v72, a2: v40, a3: 1); /*0x853407*/
                v78 = -1; /*0x853409*/
                sub_3F56D0(a1: v40); /*0x853416*/
              }
              else
              {
                sub_3F5650(a1: 12345312); /*0x85339e*/
                v78 = 20; /*0x8533a3*/
                (*(void (__thiscall **)(int, _BYTE *, int))(*(_DWORD *)v72 + 212))(a1: v72, a2: v41, a3: 1); /*0x8533c1*/
                v78 = -1; /*0x8533c3*/
                sub_3F56D0(a1: v41); /*0x8533d0*/
              }
              v18 = v67; /*0x85341b*/
              v19 = sub_65E430(a1: *(double *)&v18); /*0x85341e*/
              result = sub_A759D0(a1: v19); /*0x853427*/
            }
          }
        }
      }
    }
  }
  else
  {
    result = sub_A2CA00(a1: 21410, a2: 0); /*0x852a6e*/
  }
  __writefsdword(0, v77); /*0x853434*/
  return result; /*0x85343c*/
}
