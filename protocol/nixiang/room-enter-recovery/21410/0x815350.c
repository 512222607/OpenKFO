int __stdcall sub_815350(int a1, int a2)
{
  int result; // eax
  int v3; // eax

  sub_980070(); /*0x81535b*/
  sub_97FDE0(a1: 6); /*0x815362*/
  result = sub_539420(a1: dword_17C870C); /*0x81536d*/
  if ( result == 0 ) /*0x815374*/
    return result; /*0x815391*/
  v3 = sub_91E3C0(a1: dword_17C870C); /*0x81537c*/
  return (*(int (__thiscall **)(int, int))(*(_DWORD *)v3 + 12))(a1: v3, a2: v3); /*0x81538f*/
}
