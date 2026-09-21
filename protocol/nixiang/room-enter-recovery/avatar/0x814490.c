void __thiscall sub_814490(void *this, int a2, int a3)
{
  __int64 v3; // rax
  int v4; // eax
  __int64 v5; // rax
  int v6; // eax
  int v7; // eax
  int v8; // eax
  int v9; // eax
  int v10; // eax
  int v11; // eax
  int v12; // eax
  int v13; // eax
  int v14; // eax
  int v15; // eax
  int v16; // eax
  int v17; // eax
  int v18; // eax
  int v19; // eax
  int v20; // [esp-1Ch] [ebp-124h]
  int v21; // [esp-18h] [ebp-120h]
  int v22; // [esp-14h] [ebp-11Ch]
  int v23; // [esp-10h] [ebp-118h]
  int v24; // [esp-10h] [ebp-118h]
  int v25; // [esp-Ch] [ebp-114h]
  int v26; // [esp-Ch] [ebp-114h]
  int v27; // [esp-8h] [ebp-110h]
  int v28; // [esp-4h] [ebp-10Ch]
  int v29; // [esp-4h] [ebp-10Ch]
  int v30; // [esp+4h] [ebp-104h]
  int v31; // [esp+8h] [ebp-100h]
  _BYTE v33[28]; // [esp+14h] [ebp-F4h] BYREF
  _BYTE v34[4]; // [esp+30h] [ebp-D8h] BYREF
  _BYTE v35[28]; // [esp+34h] [ebp-D4h] BYREF
  __int64 v36; // [esp+50h] [ebp-B8h] BYREF
  int v37; // [esp+58h] [ebp-B0h]
  int v38; // [esp+5Ch] [ebp-ACh]
  int v39; // [esp+60h] [ebp-A8h]
  _BYTE v40[4]; // [esp+64h] [ebp-A4h] BYREF
  int v41; // [esp+68h] [ebp-A0h]
  _DWORD v42[2]; // [esp+6Ch] [ebp-9Ch] BYREF
  char v43; // [esp+74h] [ebp-94h]
  char v44; // [esp+75h] [ebp-93h]
  char v45; // [esp+76h] [ebp-92h]
  char v46; // [esp+77h] [ebp-91h]
  char v47; // [esp+78h] [ebp-90h]
  char v48; // [esp+79h] [ebp-8Fh]
  _BYTE v49[21]; // [esp+7Ah] [ebp-8Eh] BYREF
  _BYTE v50[11]; // [esp+8Fh] [ebp-79h] BYREF
  __int16 v51; // [esp+9Ah] [ebp-6Eh]
  _BYTE v52[21]; // [esp+9Ch] [ebp-6Ch] BYREF
  _BYTE v53[17]; // [esp+B1h] [ebp-57h] BYREF
  int v54; // [esp+C2h] [ebp-46h]
  int v55; // [esp+C6h] [ebp-42h]
  __int16 v56; // [esp+CBh] [ebp-3Dh]
  char v57; // [esp+CDh] [ebp-3Bh]
  int v58; // [esp+D7h] [ebp-31h]
  int v59; // [esp+F8h] [ebp-10h]
  unsigned int v60; // [esp+FCh] [ebp-Ch]
  int v61; // [esp+104h] [ebp-4h]

  if ( a2 != 0 && a3 == 245 ) /*0x8144ce*/
  {
    v59 = a2; /*0x8144d8*/
    sub_539440(a1: *(_WORD *)v59); /*0x8144f2*/
    sub_80AA40(a1: *(_DWORD *)(v59 + 12), a2: *(_DWORD *)(v59 + 16)); /*0x814508*/
    sub_4A0FC0(a1: *(unsigned __int8 *)(v59 + 62)); /*0x81451b*/
    sub_807CE0(a1: 0); /*0x814528*/
    sub_3F5650(a1: v59 + 24); /*0x81453a*/
    v61 = 0; /*0x81453f*/
    sub_4D6740(a1: v35); /*0x814553*/
    v61 = -1; /*0x814558*/
    sub_3F56D0(a1: v35); /*0x814565*/
    sub_80B370(a1: *(unsigned __int8 *)(v59 + 65)); /*0x814578*/
    sub_4D69D0(a1: *(_BYTE *)(v59 + 59)); /*0x81458b*/
    sub_4D69B0(a1: *(_BYTE *)(v59 + 57)); /*0x81459e*/
    sub_4D69F0(a1: *(_BYTE *)(v59 + 60)); /*0x8145b1*/
    sub_80B8E0(a1: *(_WORD *)(v59 + 67)); /*0x8145c4*/
    sub_539540(a1: *(_DWORD *)(v59 + 69)); /*0x8145d6*/
    sub_80B010(a1: v59); /*0x8145e5*/
    sub_813830(a1: v40); /*0x8145f1*/
    if ( *(_BYTE *)(v59 + 65) == 2 || *(_BYTE *)(v59 + 65) == 3 ) /*0x81460f*/
      sub_539580(a1: 25); /*0x814619*/
    else
      sub_539580(a1: 100); /*0x814628*/
    v39 = a2 + 96; /*0x814633*/
    v41 = 0; /*0x814639*/
    if ( *(_BYTE *)(v59 + 10) == 8 ) /*0x81464d*/
    {
      *(_BYTE *)(v39 + 76) = 1; /*0x814655*/
      v25 = sub_443BC0(a1: dword_17C86FC); /*0x814668*/
      v23 = v39; /*0x81466f*/
      v3 = sub_3F2AA0(a1: dword_17C86FC); /*0x814676*/
      sub_80BE60(a1: v3, a2: HIDWORD(v3), a3: v23, a4: v25, a5: 1, a6: 1); /*0x814683*/
    }
    else
    {
      *(_BYTE *)(v39 + 76) = 0; /*0x814693*/
      v4 = sub_8E9500(); /*0x814697*/
      if ( (unsigned __int8)sub_8E88D0(a1: v4) != 0 ) /*0x8146a8*/
        v38 = *(unsigned __int8 *)(v59 + 66); /*0x8146c0*/
      else
        v38 = *(unsigned __int8 *)(v59 + 10); /*0x8146b1*/
      v31 = sub_44E1C0(a1: v34); /*0x8146e4*/
      v61 = 1; /*0x8146ea*/
      v27 = v39; /*0x8146f9*/
      v26 = sub_443BC0(a1: dword_17C86FC); /*0x814705*/
      v24 = sub_3F6410(a1: v31); /*0x814711*/
      v22 = v38; /*0x814718*/
      v21 = *(unsigned __int8 *)(v59 + 11); /*0x814720*/
      v20 = *(unsigned __int8 *)(v59 + 10); /*0x814728*/
      v5 = sub_3F2AA0(a1: dword_17C86FC); /*0x81472f*/
      v41 = sub_80CB00(a1: v5, a2: HIDWORD(v5), a3: v20, a4: v21, a5: v22, a6: v24, a7: v26, a8: v27, a9: 0); /*0x814741*/
      v61 = -1; /*0x814747*/
      sub_3F6050(a1: v34); /*0x814754*/
      v6 = sub_623A40(a1: dword_17C86FC); /*0x81475f*/
      sub_5395A0(a1: v6); /*0x81476b*/
      v7 = sub_539560(a1: dword_17C8708); /*0x814776*/
      sub_9D4020(a1: v7); /*0x814782*/
      v8 = sub_9BD390(a1: dword_17C86FC); /*0x81478d*/
      sub_501900(a1: *(unsigned __int8 *)(v8 + 123)); /*0x81479d*/
      v9 = sub_9BD390(a1: dword_17C86FC); /*0x8147a8*/
      *(_BYTE *)(v41 + 7412) = *(_DWORD *)(v9 + 266) >= *(_DWORD *)(dword_17C86F8 + 20); /*0x8147c7*/
      if ( sub_9D7C70(a1: v41) != 0 ) /*0x8147da*/
      {
        v36 = sub_3F1000(a1: v41); /*0x8147e7*/
        v37 = 0; /*0x8147f3*/
        sub_A2C950(a1: 3550, a2: 0, a3: (int)&v36, a4: 12); /*0x81480d*/
      }
    }
    sub_656960(a1: v42, a2: 0, a3: 48); /*0x814820*/
    v10 = *(_DWORD *)(v59 + 16); /*0x81482e*/
    v42[0] = *(_DWORD *)(v59 + 12); /*0x814831*/
    v42[1] = v10; /*0x814837*/
    v45 = *(_BYTE *)(v59 + 58); /*0x814843*/
    v46 = *(_BYTE *)(v59 + 62); /*0x81484f*/
    v44 = *(_BYTE *)(v59 + 57); /*0x81485b*/
    v43 = *(_BYTE *)(v59 + 56); /*0x814867*/
    v47 = *(_BYTE *)(v59 + 59); /*0x814873*/
    v48 = *(_BYTE *)(v59 + 60); /*0x81487f*/
    v51 = *(_WORD *)(v59 + 67); /*0x81488c*/
    v11 = sub_655950(a1: v59 + 24); /*0x814897*/
    sub_6536A0(a1: v49, a2: v59 + 24, a3: v11); /*0x8148ae*/
    if ( *(_BYTE *)(v59 + 61) != 0 ) /*0x8148bf*/
    {
      v12 = sub_655950(a1: v59 + 45); /*0x8148c8*/
      sub_6536A0(a1: v50, a2: v59 + 45, a3: v12); /*0x8148dc*/
      sub_3F5650(a1: v59 + 45); /*0x8148f1*/
      v61 = 2; /*0x8148f6*/
      sub_4D6A10(a1: v33); /*0x81490a*/
      v61 = -1; /*0x81490f*/
      sub_3F56D0(a1: v33); /*0x81491c*/
    }
    else
    {
      v50[0] = 0; /*0x814923*/
    }
    sub_A2CA00(a1: 21428, a2: 0); /*0x81492e*/
    (*(void (__thiscall **)(void *, int, _DWORD *))(*(_DWORD *)this + 12))(a1: this, a2: v59, a3: v42); /*0x814952*/
    if ( v41 != 0 && sub_9D7C70(a1: v41) != 0 ) /*0x81496a*/
      sub_809D70(a1: v41, a2: 1); /*0x81497b*/
    v30 = sub_80B800(a1: dword_17C8708); /*0x81498b*/
    (*(void (__thiscall **)(int, _DWORD *))(*(_DWORD *)v30 + 456))(a1: v30, a2: v42); /*0x8149ac*/
    sub_980070(); /*0x8149b0*/
    sub_97FDE0(a1: 7); /*0x8149b7*/
    sub_4D12D0(a1: v52); /*0x8149bf*/
    sub_656960(a1: v52, a2: 0, a3: 81); /*0x8149cc*/
    v53[12] = *(_BYTE *)(v59 + 57); /*0x8149da*/
    v53[11] = *(_BYTE *)(v59 + 56); /*0x8149e3*/
    v53[13] = *(_BYTE *)(v59 + 58); /*0x8149ec*/
    v53[14] = *(_BYTE *)(v59 + 59); /*0x8149f5*/
    v53[15] = *(_BYTE *)(v59 + 60); /*0x8149fe*/
    v56 = *(_WORD *)(v59 + 67); /*0x814a08*/
    v13 = sub_4A87E0(a1: dword_17C8708); /*0x814a12*/
    v28 = sub_538980(a1: v13); /*0x814a1e*/
    v14 = sub_4A87E0(a1: dword_17C8708); /*0x814a25*/
    v15 = sub_3F5750(a1: v14); /*0x814a2c*/
    sub_6536A0(a1: v52, a2: v15, a3: v28); /*0x814a36*/
    v16 = sub_539520(a1: dword_17C8708); /*0x814a44*/
    v29 = sub_538980(a1: v16); /*0x814a50*/
    v17 = sub_539520(a1: dword_17C8708); /*0x814a57*/
    v18 = sub_3F5750(a1: v17); /*0x814a5e*/
    sub_6536A0(a1: v53, a2: v18, a3: v29); /*0x814a68*/
    v19 = *(_DWORD *)(v59 + 16); /*0x814a76*/
    v54 = *(_DWORD *)(v59 + 12); /*0x814a79*/
    v55 = v19; /*0x814a7c*/
    v57 = *(_BYTE *)(v59 + 73); /*0x814a85*/
    v58 = *(_DWORD *)(v59 + 78); /*0x814a8e*/
    sub_4D6760(a1: v52); /*0x814a9b*/
    sub_80A300(a1: v58); /*0x814aaa*/
    (*(void (__fastcall **)(int))(*(_DWORD *)dword_17C8708 + 8))(a1: dword_17C8708); /*0x814ac0*/
    if ( *(_BYTE *)(v59 + 65) == 4 ) /*0x814acc*/
      sub_5395E0(a1: 0); /*0x814ad6*/
  }
  __writefsdword(0, v60); /*0x814ade*/
}
