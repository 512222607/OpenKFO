int __thiscall sub_9D84B0(int this, int a2, int a3)
{
  int v4; // [esp+4h] [ebp-90h]
  int v5; // [esp+8h] [ebp-8Ch]
  int v6; // [esp+Ch] [ebp-88h]
  int v7; // [esp+10h] [ebp-84h]
  int v8; // [esp+14h] [ebp-80h]
  int v9; // [esp+2Ch] [ebp-68h]
  int v10; // [esp+30h] [ebp-64h]
  int v11; // [esp+34h] [ebp-60h]
  int v13; // [esp+3Ch] [ebp-58h]
  int v14; // [esp+44h] [ebp-50h]
  int v15; // [esp+4Ch] [ebp-48h]
  int v16; // [esp+54h] [ebp-40h]
  int v17; // [esp+5Ch] [ebp-38h]
  int v18; // [esp+68h] [ebp-2Ch]
  int v19; // [esp+70h] [ebp-24h]
  int i; // [esp+80h] [ebp-14h]
  unsigned int v21[3]; // [esp+84h] [ebp-10h] BYREF
  int v22; // [esp+90h] [ebp-4h]

  *(_DWORD *)(this + 3216) = a2; /*0x9d84e1*/
  *(_DWORD *)(this + 3220) = a3; /*0x9d84ea*/
  *(_DWORD *)(this + 3264) = 0; /*0x9d84f3*/
  *(_DWORD *)(this + 3268) = 0; /*0x9d8500*/
  *(_DWORD *)(this + 3272) = 0; /*0x9d850d*/
  *(_DWORD *)(this + 3276) = 0; /*0x9d851a*/
  *(_DWORD *)(this + 3400) = 6; /*0x9d8527*/
  *(_DWORD *)(this + 3296) = 0; /*0x9d8534*/
  *(_DWORD *)(this + 3244) = 0; /*0x9d8541*/
  *(float *)(this + 3404) = 0.0; /*0x9d8550*/
  *(_DWORD *)(this + 3320) = 0; /*0x9d8559*/
  *(float *)(this + 6012) = 0.0; /*0x9d8568*/
  *(_DWORD *)(this + 3448) = 0; /*0x9d8571*/
  *(_DWORD *)(this + 3396) = 0; /*0x9d857e*/
  *(_DWORD *)(this + 3468) = 0; /*0x9d858b*/
  *(_BYTE *)(this + 3452) = 0; /*0x9d8598*/
  *(_DWORD *)(this + 3324) = 1; /*0x9d85a2*/
  *(_DWORD *)(this + 6848) = 0; /*0x9d85af*/
  *(_DWORD *)(this + 6016) = 0; /*0x9d85bc*/
  *(_DWORD *)(this + 6776) = 0; /*0x9d85c9*/
  *(_DWORD *)(this + 6764) = 0; /*0x9d85d6*/
  *(_DWORD *)(this + 44) = -1; /*0x9d85e3*/
  *(_DWORD *)(this + 40) = -1; /*0x9d85ed*/
  *(_DWORD *)(this + 7004) = 0; /*0x9d85f7*/
  *(_DWORD *)(this + 6900) = 0; /*0x9d8604*/
  *(float *)(this + 6904) = 0.0; /*0x9d8613*/
  *(_DWORD *)(this + 6884) = 1; /*0x9d861c*/
  *(_DWORD *)(this + 3524) = 0; /*0x9d8629*/
  *(_DWORD *)(this + 6992) = 0; /*0x9d8636*/
  *(_DWORD *)(this + 3532) = 0; /*0x9d8643*/
  *(_DWORD *)(this + 3528) = 0; /*0x9d8650*/
  *(_DWORD *)(this + 6780) = -1; /*0x9d865d*/
  *(_DWORD *)(this + 36) = 0; /*0x9d866a*/
  *(_DWORD *)(this + 7008) = 1; /*0x9d8674*/
  *(_DWORD *)(this + 7024) = 0; /*0x9d8681*/
  *(_DWORD *)(this + 6928) = 1; /*0x9d868e*/
  *(_DWORD *)(this + 3300) = -1; /*0x9d869b*/
  *(_DWORD *)(this + 3328) = 0; /*0x9d86a8*/
  *(_DWORD *)(this + 3388) = 0; /*0x9d86b5*/
  *(_DWORD *)(this + 3392) = 0; /*0x9d86c2*/
  *(_DWORD *)(this + 6920) = 0; /*0x9d86cf*/
  *(_DWORD *)(this + 6916) = 0; /*0x9d86dc*/
  *(_DWORD *)(this + 7028) = 0; /*0x9d86e9*/
  *(_DWORD *)(this + 7048) = 1; /*0x9d86f6*/
  *(_DWORD *)(this + 7044) = 100; /*0x9d8703*/
  *(_DWORD *)(this + 3256) = 0; /*0x9d8710*/
  *(_DWORD *)(this + 3260) = 0; /*0x9d871d*/
  *(_DWORD *)(this + 6100) = 0; /*0x9d872a*/
  *(_DWORD *)(this + 7052) = 0; /*0x9d8737*/
  *(_DWORD *)(this + 7040) = 0; /*0x9d8744*/
  *(float *)(this + 7012) = 1.0; /*0x9d8753*/
  *(_DWORD *)(this + 7016) = 0; /*0x9d875c*/
  *(_DWORD *)(this + 7020) = 0; /*0x9d8769*/
  *(_DWORD *)(this + 6924) = 0; /*0x9d8776*/
  *(_DWORD *)(this + 6756) = 0; /*0x9d8783*/
  *(_DWORD *)(this + 3416) = off_B9B0CC; /*0x9d879b*/
  *(_DWORD *)(this + 3420) = off_B9B0D0; /*0x9d87a3*/
  *(_DWORD *)(this + 3424) = dword_B9B0D4; /*0x9d87ab*/
  *(float *)(this + 3428) = 0.0; /*0x9d87b3*/
  *(float *)(this + 3432) = 0.0; /*0x9d87be*/
  *(_DWORD *)(this + 3436) = off_B9B0CC; /*0x9d87d2*/
  *(_DWORD *)(this + 3440) = off_B9B0D0; /*0x9d87da*/
  *(_DWORD *)(this + 3444) = dword_B9B0D4; /*0x9d87e3*/
  *(_WORD *)(this + 6908) = 0; /*0x9d87eb*/
  *(_WORD *)(this + 6910) = 0; /*0x9d87f7*/
  *(_WORD *)(this + 6912) = 0; /*0x9d8803*/
  *(_WORD *)(this + 6914) = 0; /*0x9d880f*/
  *(_DWORD *)(this + 7100) = -1; /*0x9d8819*/
  *(_DWORD *)(this + 3280) = 0; /*0x9d8826*/
  *(_DWORD *)(this + 6108) = 0; /*0x9d8833*/
  *(_DWORD *)(this + 3292) = 0; /*0x9d8840*/
  *(float *)(this + 6932) = 1.0; /*0x9d884f*/
  *(_DWORD *)(this + 3248) = 1; /*0x9d8858*/
  *(_DWORD *)(this + 7108) = 1; /*0x9d8865*/
  *(_DWORD *)(this + 7116) = 0; /*0x9d8872*/
  *(float *)(this + 7120) = 0.0; /*0x9d8881*/
  *(_DWORD *)(this + 6936) = 0; /*0x9d888a*/
  *(_DWORD *)(this + 7112) = 0; /*0x9d8897*/
  *(_DWORD *)(this + 7124) = 0; /*0x9d88a4*/
  *(_DWORD *)(this + 6768) = 0; /*0x9d88b1*/
  v22 = 0; /*0x9d88cb*/
  if ( sub_657FBB(a1: 540) != 0 ) /*0x9d88d6*/
    v11 = sub_A5E440(a1: this); /*0x9d88e4*/
  else
    v11 = 0; /*0x9d88e9*/
  v22 = -1; /*0x9d88f6*/
  *(_DWORD *)(this + 6772) = v11; /*0x9d8903*/
  *(_DWORD *)(this + 3284) = 0; /*0x9d890c*/
  *(_DWORD *)(this + 3288) = 0; /*0x9d8919*/
  *(_BYTE *)(this + 7413) &= ~1u; /*0x9d8931*/
  *(_DWORD *)(this + 7416) |= 1u; /*0x9d8946*/
  *(_DWORD *)(this + 6996) = 0; /*0x9d894f*/
  *(_BYTE *)(this + 7412) = 0; /*0x9d895c*/
  sub_3F63A0(a1: this + 7000); /*0x9d896c*/
  *(_DWORD *)(this + 3520) = -1; /*0x9d8974*/
  sub_42C070(a1: this + 6940); /*0x9d8987*/
  v21[0] = 0; /*0x9d898c*/
  sub_4484D0(a1: v21); /*0x9d89a0*/
  *(_DWORD *)(this + 6976) = 0; /*0x9d89a8*/
  *(_DWORD *)(this + 6980) = 0; /*0x9d89b2*/
  *(_DWORD *)(this + 3316) = 1; /*0x9d89bf*/
  *(_BYTE *)(this + 7032) = 0; /*0x9d89cc*/
  sub_7BE810(a1: this); /*0x9d89e0*/
  *(_DWORD *)(this + 7036) = 1; /*0x9d89e8*/
  *(_DWORD *)(this + 6892) = 0; /*0x9d89f5*/
  *(_DWORD *)(this + 7128) = 1; /*0x9d8a02*/
  *(_BYTE *)(this + 21) = 1; /*0x9d8a0f*/
  *(_BYTE *)(this + 22) = 1; /*0x9d8a16*/
  *(_DWORD *)(this + 7444) = -1; /*0x9d8a1d*/
  *(_DWORD *)(this + 7064) = 0; /*0x9d8a2a*/
  *(_DWORD *)(this + 7056) = 0; /*0x9d8a37*/
  v19 = sub_657FBB(a1: 28); /*0x9d8a4b*/
  v22 = 1; /*0x9d8a4e*/
  if ( v19 != 0 ) /*0x9d8a59*/
    v10 = sub_448530(a1: v19); /*0x9d8a63*/
  else
    v10 = 0; /*0x9d8a68*/
  v22 = -1; /*0x9d8a75*/
  *(_DWORD *)(this + 6064) = v10; /*0x9d8a82*/
  v18 = sub_657FBB(a1: 360); /*0x9d8a95*/
  v22 = 2; /*0x9d8a98*/
  if ( v18 != 0 ) /*0x9d8aa3*/
    v9 = sub_9CC070(a1: v18); /*0x9d8aad*/
  else
    v9 = 0; /*0x9d8ab2*/
  v22 = -1; /*0x9d8abf*/
  *(_DWORD *)(this + 3304) = v9; /*0x9d8acc*/
  *(_DWORD *)(this + 3252) = sub_657FBB(a1: 40); /*0x9d8ae5*/
  sub_656960(a1: *(_DWORD *)(this + 3252), a2: 0, a3: 40); /*0x9d8af9*/
  *(_DWORD *)(*(_DWORD *)(this + 3252) + 20) = 0xFFFF; /*0x9d8b0a*/
  sub_656960(a1: this + 3240, a2: 0, a3: 4); /*0x9d8b1e*/
  sub_656960(a1: this + 6316, a2: 0, a3: 184); /*0x9d8b37*/
  sub_656960(a1: this + 6572, a2: 0, a3: 184); /*0x9d8b50*/
  *(_DWORD *)(this + 3536) = sub_3F2AA0(a1: dword_17C86FC) == *(_QWORD *)(this + 3216); /*0x9d8ba1*/
  sub_439FC0(a1: this + 6068); /*0x9d8bb0*/
  *(float *)(this + 3352) = 0.0; /*0x9d8bba*/
  *(float *)(this + 3348) = 0.0; /*0x9d8bc5*/
  *(float *)(this + 3344) = 0.0; /*0x9d8bd0*/
  *(float *)(this + 3340) = 0.0; /*0x9d8bdb*/
  *(float *)(this + 3336) = 0.0; /*0x9d8be6*/
  *(float *)(this + 3332) = 0.0; /*0x9d8bf1*/
  sub_656960(a1: this + 3544, a2: 0, a3: 1232); /*0x9d8c08*/
  sub_439FC0(a1: this + 7068); /*0x9d8c19*/
  *(_DWORD *)(this + 3224) = -1; /*0x9d8c21*/
  *(_DWORD *)(this + 3384) = sub_650900(a1: dword_17B830C); /*0x9d8c39*/
  if ( *(_QWORD *)(this + 3216) == 0 ) /*0x9d8c57*/
    *(_QWORD *)(this + 3216) = sub_650900(a1: dword_17B8308); /*0x9d8c67*/
  *(_DWORD *)(this + 6936) = 1; /*0x9d8c76*/
  *(_DWORD *)(this + 6964) = 0; /*0x9d8c83*/
  *(_DWORD *)(this + 6968) = 0; /*0x9d8c90*/
  *(_DWORD *)(this + 6988) = 0; /*0x9d8c9d*/
  *(_DWORD *)(this + 16) = 0; /*0x9d8caa*/
  *(_DWORD *)(this + 7132) = 0; /*0x9d8cb4*/
  sub_439FC0(a1: this + 6148); /*0x9d8cc7*/
  *(_BYTE *)(this + 7413) &= ~2u; /*0x9d8cda*/
  *(_BYTE *)(this + 20) = 0; /*0x9d8ce3*/
  sub_656960(a1: this + 7420, a2: 1, a3: 2); /*0x9d8cf4*/
  *(_DWORD *)(this + 7424) = 0; /*0x9d8cff*/
  *(_DWORD *)(this + 6788) = 0; /*0x9d8d0c*/
  *(_DWORD *)(this + 6784) = 0; /*0x9d8d19*/
  *(_DWORD *)(this + 6792) = 0; /*0x9d8d26*/
  sub_656960(a1: this + 7468, a2: 0, a3: 4); /*0x9d8d3e*/
  *(_BYTE *)(this + 7467) = 0; /*0x9d8d49*/
  *(_BYTE *)(this + 7472) = 0; /*0x9d8d53*/
  sub_54E700(a1: 64); /*0x9d8d65*/
  for ( i = 0; i < 64; ++i ) /*0x9d8d6a*/
    *(_DWORD *)sub_481640(a1: i) = 0; /*0x9d8d94*/
  v17 = sub_657FBB(a1: 48); /*0x9d8da6*/
  v22 = 3; /*0x9d8da9*/
  if ( v17 != 0 ) /*0x9d8db4*/
    v8 = sub_A5C980(a1: this); /*0x9d8dc2*/
  else
    v8 = 0; /*0x9d8dc7*/
  v22 = -1; /*0x9d8dd4*/
  *(_DWORD *)(this + 6796) = v8; /*0x9d8de1*/
  v16 = sub_657FBB(a1: 40); /*0x9d8df1*/
  v22 = 4; /*0x9d8df4*/
  if ( v16 != 0 ) /*0x9d8dff*/
    v7 = sub_9B0D90(a1: this); /*0x9d8e0d*/
  else
    v7 = 0; /*0x9d8e15*/
  v22 = -1; /*0x9d8e28*/
  *(_DWORD *)(this + 6800) = v7; /*0x9d8e35*/
  v15 = sub_657FBB(a1: 28); /*0x9d8e45*/
  v22 = 5; /*0x9d8e48*/
  if ( v15 != 0 ) /*0x9d8e53*/
    v6 = sub_A47060(a1: this); /*0x9d8e61*/
  else
    v6 = 0; /*0x9d8e69*/
  v22 = -1; /*0x9d8e7c*/
  *(_DWORD *)(this + 6804) = v6; /*0x9d8e89*/
  v14 = sub_657FBB(a1: 48); /*0x9d8e99*/
  v22 = 6; /*0x9d8e9c*/
  if ( v14 != 0 ) /*0x9d8ea7*/
    v5 = sub_A476D0(a1: v14); /*0x9d8eb1*/
  else
    v5 = 0; /*0x9d8eb9*/
  v22 = -1; /*0x9d8ecc*/
  *(_DWORD *)(this + 3308) = v5; /*0x9d8ed9*/
  v13 = sub_657FBB(a1: 32); /*0x9d8ee9*/
  v22 = 7; /*0x9d8eec*/
  if ( v13 != 0 ) /*0x9d8ef7*/
    v4 = sub_A634D0(a1: v13); /*0x9d8f01*/
  else
    v4 = 0; /*0x9d8f09*/
  v22 = -1; /*0x9d8f1c*/
  *(_DWORD *)(this + 3312) = v4; /*0x9d8f29*/
  *(float *)(this + 6020) = 0.0; /*0x9d8f34*/
  *(float *)(this + 6024) = 0.0; /*0x9d8f3f*/
  *(_DWORD *)(this + 6120) = 0; /*0x9d8f48*/
  *(_DWORD *)(this + 6112) = 0; /*0x9d8f55*/
  *(_DWORD *)(this + 6116) = 0; /*0x9d8f5f*/
  *(_DWORD *)(this + 6028) = dword_17C8690; /*0x9d8f71*/
  sub_9D3B40(a1: this); /*0x9d8f7a*/
  *(_BYTE *)(this + 7464) = 0; /*0x9d8f82*/
  *(_DWORD *)(this + 7436) = 0; /*0x9d8f8c*/
  *(_BYTE *)(this + 7440) = 0; /*0x9d8f99*/
  __writefsdword(0, v21[1]); /*0x9d8fa3*/
  return this; /*0x9d8fab*/
}
