int __thiscall sub_9E3540(_DWORD *this, int a2, int a3)
{
  int v3; // eax
  int v5; // eax
  int v6; // eax
  int v7; // eax
  int v8; // eax
  int v9; // eax
  int v10; // eax
  int v11; // eax
  int v12; // eax
  int *v13; // eax
  int v14; // eax
  int v15; // eax
  float v16[21]; // [esp-38h] [ebp-A0h] BYREF
  int v17; // [esp+1Ch] [ebp-4Ch]
  int v18; // [esp+20h] [ebp-48h]
  int v19; // [esp+24h] [ebp-44h]
  _DWORD *v20; // [esp+28h] [ebp-40h]
  _BYTE v21[20]; // [esp+2Ch] [ebp-3Ch] BYREF
  int v22; // [esp+40h] [ebp-28h]
  int v23; // [esp+44h] [ebp-24h]
  int v24; // [esp+48h] [ebp-20h]
  int v25; // [esp+4Ch] [ebp-1Ch]
  int v26; // [esp+50h] [ebp-18h]
  int v27; // [esp+54h] [ebp-14h]
  int v28; // [esp+58h] [ebp-10h]
  int v29; // [esp+64h] [ebp-4h]

  v20 = this; /*0x9e3567*/
  sub_443580(a1: this + 30); /*0x9e3570*/
  qmemcpy(v20 + 886, (const void *)a2, 0x4D0u); /*0x9e3586*/
  qmemcpy(v20 + 1194, v20 + 886, 0x4D0u); /*0x9e359f*/
  if ( v20[811] != 0 ) /*0x9e35ab*/
  {
    v27 = v20[811]; /*0x9e35c2*/
    v28 = v27; /*0x9e35c8*/
    if ( v27 != 0 ) /*0x9e35cf*/
      v19 = sub_444290(a1: 1); /*0x9e35db*/
    else
      v19 = 0; /*0x9e35e0*/
    v20[811] = 0; /*0x9e35ea*/
  }
  v25 = sub_657FBB(a1: 1332); /*0x9e3601*/
  v29 = 0; /*0x9e3604*/
  if ( v25 != 0 ) /*0x9e360f*/
    v18 = sub_A073C0(a1: v25); /*0x9e3619*/
  else
    v18 = 0; /*0x9e361e*/
  v26 = v18; /*0x9e3628*/
  v29 = -1; /*0x9e362b*/
  v20[811] = v18; /*0x9e3638*/
  if ( v20[811] == 0 ) /*0x9e3648*/
    return 0; /*0x9e3696*/
  if ( a3 != 0 ) /*0x9e364e*/
    sub_A09740(a1: a3, a2); /*0x9e3675*/
  else
    sub_A09150(a1: a2); /*0x9e365d*/
  v3 = sub_A06C80(a1: v20[811]); /*0x9e3683*/
  sub_7667D0(a1: v3); /*0x9e368f*/
  v17 = sub_9D58E0(a1: v20); /*0x9e36a5*/
  (*(void (__thiscall **)(int, _DWORD *, int))(*(_DWORD *)v17 + 52))(a1: v17, a2: v20 + 836, a3: 1); /*0x9e36bf*/
  v5 = sub_9D58E0(a1: v20); /*0x9e36c4*/
  sub_76A100(a1: v5); /*0x9e36cb*/
  LODWORD(v16[17]) = v20 + 881; /*0x9e36d8*/
  LODWORD(v16[16]) = 7832496; /*0x9e36d9*/
  v6 = sub_A06C80(a1: v20[811]); /*0x9e36e7*/
  sub_57E3D0(a1: v6, a2: 7832496, a3: v20 + 881); /*0x9e36ed*/
  v20[1748] = v20[881]; /*0x9e3701*/
  if ( a3 != 0 ) /*0x9e370b*/
  {
    sub_9DFA00(a1: a3, a2: 1); /*0x9e3756*/
    sub_9DFA00(a1: a3, a2: 0); /*0x9e3764*/
  }
  else
  {
    qmemcpy(v16, (const void *)(a2 + 824), 0x44u); /*0x9e3722*/
    sub_9E00A0( /*0x9e3727*/
      a1: v20,
      a2: LODWORD(v16[0]),
      a3: LODWORD(v16[1]),
      a4: LODWORD(v16[2]),
      a5: LODWORD(v16[3]),
      a6: LODWORD(v16[4]),
      a7: LODWORD(v16[5]),
      a8: LODWORD(v16[6]),
      a9: LODWORD(v16[7]),
      a10: LODWORD(v16[8]),
      a11: LODWORD(v16[9]),
      a12: LODWORD(v16[10]),
      a13: LODWORD(v16[11]),
      a14: LODWORD(v16[12]),
      a15: LODWORD(v16[13]),
      a16: LODWORD(v16[14]),
      a17: LODWORD(v16[15]),
      a18: LODWORD(v16[16]),
      a19: 1);
    qmemcpy(v16, (const void *)(a2 + 960), 0x44u); /*0x9e3741*/
    sub_9E00A0( /*0x9e3746*/
      a1: v20,
      a2: LODWORD(v16[0]),
      a3: LODWORD(v16[1]),
      a4: LODWORD(v16[2]),
      a5: LODWORD(v16[3]),
      a6: LODWORD(v16[4]),
      a7: LODWORD(v16[5]),
      a8: LODWORD(v16[6]),
      a9: LODWORD(v16[7]),
      a10: LODWORD(v16[8]),
      a11: LODWORD(v16[9]),
      a12: LODWORD(v16[10]),
      a13: LODWORD(v16[11]),
      a14: LODWORD(v16[12]),
      a15: LODWORD(v16[13]),
      a16: LODWORD(v16[14]),
      a17: LODWORD(v16[15]),
      a18: LODWORD(v16[16]),
      a19: 0);
  }
  v7 = sub_551D00(a1: v20[811]); /*0x9e3772*/
  sub_9DEA10(a1: 2, a2: *(_DWORD *)(v7 + 81)); /*0x9e3780*/
  v8 = sub_551D00(a1: v20[811]); /*0x9e378e*/
  sub_9DEA10(a1: 3, a2: *(_DWORD *)(v8 + 217)); /*0x9e379f*/
  v9 = sub_551D00(a1: v20[811]); /*0x9e37ad*/
  sub_9DEA10(a1: 4, a2: *(_DWORD *)(v9 + 421)); /*0x9e37be*/
  v10 = sub_551D00(a1: v20[811]); /*0x9e37cc*/
  sub_9DEA10(a1: 5, a2: *(_DWORD *)(v10 + 149)); /*0x9e37dd*/
  v11 = sub_551D00(a1: v20[811]); /*0x9e37eb*/
  sub_9DEA10(a1: 6, a2: *(_DWORD *)(v11 + 353)); /*0x9e37fc*/
  v12 = sub_551D00(a1: v20[811]); /*0x9e380a*/
  sub_9DEA10(a1: 7, a2: *(_DWORD *)(v12 + 285)); /*0x9e381b*/
  sub_9E2DC0(a1: 2, a2: 1, a3: 0, a4: 0.0, a5: 0); /*0x9e3831*/
  v13 = (int *)sub_9D4120(a1: v21, a2: 2); /*0x9e383c*/
  v22 = *v13; /*0x9e3846*/
  v23 = v13[1]; /*0x9e384c*/
  v24 = v13[2]; /*0x9e3852*/
  sub_9D40B0(a1: v22, a2: v23, a3: v24); /*0x9e386e*/
  if ( v20[816] != 0 ) /*0x9e387d*/
  {
    v14 = sub_5775A0(a1: v20[816]); /*0x9e3888*/
    sub_9D5DC0(a1: v14); /*0x9e3891*/
  }
  else
  {
    v15 = sub_425F90(a1: v20[811]); /*0x9e38a1*/
    sub_9D5DC0(a1: *(_DWORD *)(v15 + 8)); /*0x9e38ad*/
  }
  return 1; /*0x9e38b7*/
}
