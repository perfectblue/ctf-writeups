void first_step();
void second_step(unsigned int inp);
void third_step();

int main(int argc, const char **argv, const char **envp)
{
  first_step();
  return 0;
}

void first_step()
{
  long v0; // r8
  long v1; // r9
  long v2; // r8
  long v3; // r9
  char v5; // [rsp+0h] [rbp-10h]
  char v6; // [rsp+0h] [rbp-10h]
  unsigned int v7; // [rsp+Ch] [rbp-4h]

  puts("[+] First Step!!!");
  v7 = 0xDEADBEEF;
  if ( ptrace(0LL, 0LL, 1LL, 0LL, v0, v1, v5) == 0 )
    v7 = 0xE27F;
  if ( ptrace(0LL, 0LL, 1LL, 0LL, v2, v3, v6) == -1 )
    v7 = (v7 << 16) | 0xDEE2;                   // v7 should be 0xe27fdee2
  ptrace_str = calloc(0x11uLL, 1uLL);
  msg_two = calloc(0x41uLL, 1uLL);
  if ( v7 == 0xBEEFDEE2 )
    return puts("[!] Don't be hurry !!");
  puts("  [+] You have nothing to do with this step.");
  snprintf(ptrace_str, "%x", v7);
  second_step(v7);
}

void second_step(unsigned int inp)
{
  long v1; // rax
  long v2; // ST18_8
  unsigned long v3; // rax

  puts("[+] Second Step!!!");
  v1 = strlen("DF6C24C58419A0A15127F614");
  v2 = malloc(v1 + 5);
  snprintf(v2, "%s%X", "DF6C24C58419A0A15127F614", inp ^ 0x5E9F14E7);
  printf("  [?] Guess the key: %s\n", v2);
  snprintf(msg_two, "What is this ? 00000000%x", inp);
  v3 = ptrace_str + strlen(ptrace_str);
  *(_DWORD *)v3 = '....';
  *(_BYTE *)(v3 + 4) = 0;
  third_step();
}

void third_step()
{
  char v0[8]; // [rsp+2h] [rbp-1Eh]
  __int16 v1; // [rsp+Ah] [rbp-16h]
  int v2; // [rsp+Ch] [rbp-14h]
  int *cookie; // [rsp+10h] [rbp-10h]
  int i; // [rsp+1Ch] [rbp-4h]

  sleep(3LL);
  puts("[+] Let's move to the Last Step!!!");
  i = 0;
  cookie = 0LL;
  v2 = 0xB01ABA1A;
  *(_QWORD *)v0 = 0LL;
  v1 = 0;
  printf("Enter password for the last piece: ");
  fgets(v0, 100LL, stdin);
  cookie = &v2;
  for ( i = 0;
        i <= 3
     && *((_BYTE *)cookie + 2) == 0xCAu
     && *(_BYTE *)cookie == 0x1A
     && *((_BYTE *)cookie + 3) == 0xC0u
     && *((_BYTE *)cookie + 1) == 0xC0u;
        ++i )
  {
    if ( i == 3 )
    {
      snprintf(msg_two, "Incomplete flag: %s....%x%x", ptrace_str, v2 ^ 0x2E95373Bu, v2 ^ 0x23939E84u);
      puts("[?] Have you seen the flag yet ?");
      return;
    }
  }
  puts("[-] Wrong password");
}
