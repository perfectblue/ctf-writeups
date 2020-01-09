# Corewars

**Category**: Reverse

300 Points

3 Solves: PPP, Perfect Blue, RPISEC

**Problem description**:
We must journey deep into the core of the world if we hope to find any meaning here

Written by itszn, Ret2 Systems

**Solved by**: cts

---

Say goodbye to ROP! The new paradigm in 2018 is Crash Oriented Programming. Let's reverse some COPchains!

```c
int __fastcall main(int argc, char **argv, char **envp)
{
  if ( gnu_get_libc_version()[2] > 49 && gnu_get_libc_version()[3] > 53 )
    return puts("woah that libc is a bit too new :( (try ubuntu 16 c:)");
  vaddrWtf = 0;
  if ( argc == 2 )
    return processArg1(argv[1]);
  puts("sudo ./chal key=<key>");
  doCore();
  return 0;
}
```

There's a fork in the road here. Either we process input from `argv[1]`, or do something else entirely.

```c
int __fastcall processArg1(const char *arg)
{
  int result; // eax
  char s; // [rsp+10h] [rbp-120h]
  char buf[128]; // [rsp+90h] [rbp-A0h]
  struct rlimit rlimits; // [rsp+110h] [rbp-20h]
  int v5; // [rsp+12Ch] [rbp-4h]

  if ( geteuid() )
  {
    puts("sudo ./chal key=<key>");
    result = puts("Don't you trust me?");
  }
  else if ( !strncmp(arg, "key=", 4uLL) )
  {
    rlimits.rlim_cur = -1LL;
    rlimits.rlim_max = -1LL;
    v5 = setrlimit(RLIMIT_CORE, &rlimits);
    buf[readlink("/proc/self/exe", buf, 0x80uLL)] = 0;
    sprintf(&s, "echo '|%s' > /proc/sys/kernel/core_pattern", buf);
    system(&s);
    result = bigCrash();                        // trigger crash for core
  }
  else
  {
    result = puts("sudo ./chal key=<key>");
  }
  return result;
}
__int64 bigCrash()
{
  checked *bufferThatIsSearchedFor; // rax
  __int64 result; // rax

  bufferThatIsSearchedFor = (checked *)calloc(0x60uLL, 1uLL);
  bufferThatIsSearchedFor->magic = 'WASC'; // CSAW
  bufferThatIsSearchedFor->pc = 0LL;
  result = 1 / 0;
  vaddrWtf = 1 / 0;
  return result;
}
```

Umm...okay. It's making itself the system core dump handler. Also, it sets rlimit to ensure core dumps are generated. Any core dump that gets generated would get piped into itself. Then, it crashes itself with a SIGFPE after allocating some memory on the heap. I suppose the other branch in main handles core dumps.

```c
__int64 doCore()
{
  struct rlimit rlimits; // [rsp+0h] [rbp-20h]
  int v2; // [rsp+1Ch] [rbp-4h]

  alarm(5u);
  getrlimit(RLIMIT_CORE, &rlimits);
  if ( rlimits.rlim_cur != 1 )
    return processCore();
  rlimits.rlim_cur = -1LL;
  rlimits.rlim_max = -1LL;
  v2 = setrlimit(RLIMIT_CORE, &rlimits);
  return processCore();
}
__int64 processCore()
{
  Corefile *corefileBuf; // rax
  __int64 result; // rax
  void *src; // ST10_8
  const char *a2; // ST08_8
  checked *checked; // [rsp+18h] [rbp-88h]
  __int64 v5; // [rsp+20h] [rbp-80h]
  __int64 v6; // [rsp+28h] [rbp-78h]
  __int64 v7; // [rsp+30h] [rbp-70h]
  __int64 v8; // [rsp+38h] [rbp-68h]
  char *s; // [rsp+40h] [rbp-60h]
  unsigned __int64 v10; // [rsp+48h] [rbp-58h]
  int type; // [rsp+54h] [rbp-4Ch]
  signed int k; // [rsp+68h] [rbp-38h]
  int j; // [rsp+6Ch] [rbp-34h]
  const char *v14; // [rsp+70h] [rbp-30h]
  unsigned int descsz; // [rsp+7Ch] [rbp-24h]
  unsigned int namesz; // [rsp+80h] [rbp-20h]
  int v17; // [rsp+84h] [rbp-1Ch]
  Elf_External_Note *vma_ptnote; // [rsp+88h] [rbp-18h]
  core_nt_entry *name; // [rsp+88h] [rbp-18h]
  signed int i; // [rsp+94h] [rbp-Ch]
  elf64_phdr *vma_phdr_ptnote; // [rsp+98h] [rbp-8h]

  corefileBuf = (Corefile *)bigRead(0);
  pCorefile = corefileBuf;
  result = corefileBuf->elf.e_type;
  if ( (_WORD)result != 4 )
    return result;
  phnum = pCorefile->elf.e_phnum;
  result = pCorefile->elf.e_phentsize;
  if ( pCorefile->elf.e_phentsize != 56 )
    return result;
  core_prog_hdr_table = (elf64_phdr *)&pCorefile->elf.e_ident[pCorefile->elf.e_phoff];
  vma_phdr_ptnote = 0LL;
  for ( i = 0; ; ++i )
  {
    result = (unsigned __int16)phnum;
    if ( (unsigned __int16)phnum <= i )
      break;
    if ( core_prog_hdr_table[i].p_type == PT_NOTE )
      vma_phdr_ptnote = &core_prog_hdr_table[i];
    if ( core_prog_hdr_table[i].p_type == PT_LOAD )
    {
      core_prog_hdr_table[i].p_offset += (Elf64_Off)pCorefile;
      if ( core_prog_hdr_table[i].p_vaddr > 0x603FFF && core_prog_hdr_table[i].p_vaddr <= 0x6FFFFFFFFFFFLL )
        heap_ptload_vaddr = core_prog_hdr_table[i].p_vaddr;
    }
  }
  if ( !vma_phdr_ptnote )
    return result;
  result = heap_ptload_vaddr;
  if ( !heap_ptload_vaddr )
    return result;
  vma_phdr_ptnote->p_offset += (Elf64_Off)pCorefile;
  vma_ptnote = (Elf_External_Note *)vma_phdr_ptnote->p_offset;
  v17 = 0;
  while ( (unsigned __int64)&vma_ptnote->namesz[-vma_phdr_ptnote->p_offset] < vma_phdr_ptnote->p_filesz )
  {
    namesz = *(_DWORD *)vma_ptnote->namesz;
    descsz = *(_DWORD *)vma_ptnote->descsz;
    type = *(_DWORD *)vma_ptnote->type;
    if ( *(_DWORD *)vma_ptnote->namesz & 7 )
      namesz = (namesz & 0xFFFFFFF8) + 8;
    if ( descsz & 7 )
      descsz = (descsz & 0xFFFFFFF8) + 8;
    name = (core_nt_entry *)&vma_ptnote->name[namesz];
    if ( type == NT_PRSTATUS )
    {
      prstatus = name;
      pr_preg = (user_regs_struct *)name->pr_reg;
    }
    if ( type == NT_FILE )
    {
      v10 = *(_QWORD *)&name->pr_info.si_signo;
      name = (core_nt_entry *)((char *)name + 16);
      v14 = (char *)name + 24 * v10;
      for ( j = 0; j < v10; ++j )
      {
        s = (char *)v14;
        v14 += strlen(v14) + 1;
        v8 = *(_QWORD *)&name->pr_info.si_signo;
        v7 = *(_QWORD *)&name->pr_info.si_errno;
        v6 = name->pr_sigpend;
        for ( k = 0; (unsigned __int16)phnum > k; ++k )
        {
          if ( core_prog_hdr_table[k].p_type == PT_LOAD
            && core_prog_hdr_table[k].p_vaddr == v8
            && !core_prog_hdr_table[k].p_filesz )
          {
            v5 = doMapsShit(s, v6);
            if ( v5 )
            {
              core_prog_hdr_table[k].p_vaddr -= v6 << 12;
              core_prog_hdr_table[k].p_offset = -4096 * v6 + v5;
              core_prog_hdr_table[k].p_filesz = v7 - v8;
            }
            break;
          }
        }
        name = (core_nt_entry *)((char *)name + 24);
      }
    }
    vma_ptnote = (Elf_External_Note *)((char *)name + descsz);
    ++v17;
  }
  vaddrWtf = (unsigned __int64)read_vaddr((unsigned __int64)&vaddrWtf) + 1;
  if ( vaddrWtf > 400 )
    exit(0);
  checked = (checked *)calloc(0x60uLL, 1uLL);
  src = (void *)searchChecked();
  memcpy(checked, src, 0x60uLL);
  if ( !checked->key[0] )                       // initial crash, copy key to checked
  {
    a2 = searchForKeyInArgs();
    strncpy(checked->key, a2, 0x40uLL);
  }
  result = stepOne(checked);
  return result;
}
```

That's a lot to take in. It basically parses the core file and iterates over the mapped regions in virtual memory. It looks for two regions: the heap(?), and something else not important. The only part that really matters is the bottom:

```c
__int64 processCore()
{
  // ...
  checked = (checked *)calloc(0x60uLL, 1uLL);
  src = (void *)searchChecked();
  memcpy(checked, src, 0x60uLL);
  if ( !checked->key[0] )                       // initial crash, copy key to checked
  {
    a2 = searchForKeyInArgs();
    strncpy(checked->key, a2, 0x40uLL);
  }
  result = stepOne(checked);
  return result;
}

struct checked
{
  _QWORD magic;
  _QWORD field1;
  _QWORD field2;
  _QWORD pc;
  __int8 key[64];
};

Elf64_Off searchChecked()
{
  __int64 i; // [rsp+18h] [rbp-8h]

  for ( i = heap_ptload_vaddr; read_vaddr(i + 16) != 'WASC'; i += read_vaddr(i + 8) & 0xFFFFFFFFFFFFFFF0LL )
    ;
  return xlate_vaddr(i + 16);
}
char *searchForKeyInArgs()
{
  char *s1; // [rsp+8h] [rbp-8h]

  for ( s1 = (char *)xlate_vaddr(pr_preg->rsp); strncmp(s1, "key=", 4uLL); ++s1 )
    ;
  return s1;
}
```

Looks like it searches for that `calloc`ed buffer from the previous run right before the crash. Then, if the key hasn't been initialized yet, it's copied from argv of the core dump. Note that this isn't the current run's argv, but the argv in the memory of the crashed program. Here `xlate_vaddr` and `read_vaddr` are simply helpers that parse the maps of the core dump to translate and read from a VA in the address space of the crashed program into the current address space (the one which is parsing the coredump).

The meat of the program is really in `stepOne` and `stepTwo`:

```c
// do signal
__int64 __fastcall stepOne(checked *checked)
{
  __int64 result; // rax
  signed __int64 keyIdx; // [rsp+18h] [rbp-8h]

  if ( (unsigned int)checkIfStars() )           // opchode == 2
  {
    checked->field1 ^= checked->field2;
    stepTwo(checked);
  }
  if ( prstatus->pr_info.si_signo == SIGTRAP )  // opchode == 6
  {
    if ( checked->field1 != checked->field2 )   // FAIL
      exit(0);
    stepTwo(checked);
  }
  if ( (unsigned int)checkSigsegvRet() )        // opchode == 5
  {
    checked->field1 <<= pr_preg->rax;
    stepTwo(checked);
  }
  if ( (unsigned int)checkSigsegCallRax() )     // opchode == 3
  {
    checked->field2 = pr_preg->rdi;
    stepTwo(checked);
  }
  if ( prstatus->pr_info.si_signo == SIGFPE )   // opchode == 1
  {
    checked->field1 = pr_preg->rax;
    stepTwo(checked);
  }

  result = checkSigabrtedFromUser();
  if ( !(_DWORD)result )
    return result;                              // wrong
  keyIdx = checked->field2 & 0x3FLL;            // opcode == 2 or 4??? not sure.
                                                // prolly 4
  checked->field2 = checked->key[keyIdx];
  if ( checked->field2 )
    checked->key[keyIdx] ^= checked->pc & 0x1F;
  result = stepTwo(checked);
  return result;
}
// generate signal
__int64 __fastcall stepTwo(checked *checked)
{
  unsigned __int64 v1; // rdx
  unsigned __int64 v2; // ST38_8
  void *ptr; // ST28_8
  __int64 result; // rax
  FILE *stream; // ST18_8
  checked *checked_; // [rsp+8h] [rbp-38h]
  __int64 opchode; // [rsp+30h] [rbp-10h]
  signed __int64 savedregs; // [rsp+40h] [rbp+0h]
  signed __int64 retaddr; // [rsp+48h] [rbp+8h]

  checked_ = checked;
  opchode = getOpchode(checked);
  freeCorefile();
  if ( opchode == 1 )
  {
    v2 = getOpchode(checked);                   // --- rdi = checked 
                                                // rax = getOpchode
    v1 = v2 % 0;                                // SIGFPE -> checked->field1 = pr_preg->rax;
    vaddrWtf = v2 / 0;
  }
  if ( opchode == 3 )
  {
    checked = (checked *)getOpchode(checked);   // rdi = getOpchode
    MEMORY[0x5647455347495300](checked);        // SIGSEGV rax = "SIGSEGV" = rip
                                                // checked->field2 = pr_preg->rdi;
  }
  if ( opchode == 2 )
  {
    ptr = malloc(0xAuLL);                       // SIGABRT
                                                // ---- rdi = rax
                                                //  result = checkSigabrt();
                                                //   if ( !(_DWORD)result )
                                                //     return result;
                                                //   v2 = checked->field2 & 0x3FLL;
                                                //   checked->field2 = checked->key[v2];
                                                //   if ( checked->field2 )
                                                //     checked->key[v2] ^= checked->incrementedWhenGettingOpchode & 0x1F;
                                                //   result = stepTwo(checked);
    free(ptr);
    checked = (checked *)ptr;
    free(ptr);
  }
  if ( opchode == 5 )
  {
    savedregs = 0x2C676E6F7277206FLL;
    retaddr = 0x76656E20756F7920LL;             // ---- rdi = checked
                                                // rax = getOpchode
                                                // So much space on the stack, what could go wrong, you never know!
                                                // SIGSEGV
                                                // checked->field1 <<= pr_preg->rax;
    result = getOpchode(checked_);
  }
  else
  {
    if ( opchode == 4 )                         // exit()
      abort();                                  // SIGABRT
    if ( opchode == 6 )
      ((void (__fastcall *)(checked *, unsigned __int64))((char *)processCore + 0x30C))(checked, v1);// 0xcc -> SIGTRAP
                                                //  if ( checked->field1 != checked->field2 )   // FAIL
                                                //       exit(0);
    if ( opchode == 7 )
    {
      stream = fopen("/tmp/flag", "w");
      fprintf(stream, "flag{%s}\n", &checked_->key[4]);
      fflush(stream);
      fclose(stream);
      exit(0);
    }
    result = 0LL;
  }
  return result;
}

__int64 __fastcall getOpchode(checked *checked)
{
  __int64 v1; // rax

  v1 = checked->pc;
  checked->pc = v1 + 1;
  return program[v1];
}
```

Okay. What happens is that on each execution, it performs one operation based on the previous corefile's crash conditions. Then, it crashes with some new condition, based on the current opcode. It looks like we're basically dealing with a very simple finite state machine. It executes symbols from a tape. The state machine's transition function is basically implemented via crashing. One opcode is executed per crash. The automaton's state is stored in that 0x60 size `check` struct, which is copied from the crashee's memory in the core dump each step. 

Moreover, a check on our inputted key is encoded as a program in this automaton. At several steps, if the automaton's state is invalid, program execution halts without printing a flag, indicating that our input was incorrect. Therefore, our job is to reverse-engineer all the crash conditions, map each one to the operation it performs on the state machine's state, then crack the check function so that we can deduce what input will result in the state machine entering an accepting state.

---

For the sake of comprehension, here is all of the `step_one` and `step_two` stubs rearranged so that the crash setup and crash handling code are grouped together by opcode, with annotations:

```c
if ( opchode == 2 )
{
  ptr = malloc(0xAuLL);
  free(ptr);
  checked = (checked *)ptr;
  free(ptr); // double free generates SIGABRT
}
// ---------------------------------
signed __int64 checkIfStars() // check for *** in output due to libc abort
{
  signed __int64 v0; // rax
  Elf64_Off v2; // [rsp+8h] [rbp-18h]
  signed int i; // [rsp+1Ch] [rbp-4h]

  v0 = read_vaddr(pr_preg->rbp + 8);
  v2 = xlate_vaddr(v0);
  fflush(stream);
  if ( v2 == -1LL )
    return 0LL;
  for ( i = 0; i <= 255; ++i )
  {                                             // abort due to double free
    if ( (*(_DWORD *)(v2 - i) & 0xFFFFFF) == 0x358D48LL )
    {
      fflush(stream);
      if ( *(_DWORD *)(v2 - i + *(unsigned int *)(v2 - i + 3) + 7) == ' ***' )
        return 1LL;
    }
  }
  return 0LL;
}
if ( (unsigned int)checkIfStars() )           // opchode == 2
{
  checked->field1 ^= checked->field2;
  stepTwo(checked);
}
```
First up is opcode 2. This one's mechanism is complex, but its behaviour is quite simple. If in step 2, the opcode at `program[state->pc]` is 2, then it crashes the program with a SIGABRT due to a bad double free. Then, in the corefile handler (step 1 of subsequent re-execution), it checks the output of the crashed program for the ubiquitous three stars we see in a libc crash message. If that's the case, it xors `state->field1` with `state->field`.

---

```c
if ( opchode == 6 ) // Jump to 0xCC -> SIGTRAP
  ((void (__fastcall *)(checked *, unsigned __int64))((char *)processCore + 0x30C))(checked, v1);
// ---------------------------------
if ( prstatus->pr_info.si_signo == SIGTRAP )  // opchode == 6
{
  if ( checked->field1 != checked->field2 )   // FAIL
    exit(0);
  stepTwo(checked);
}
```
This one is very simple. If the current opcode is 6, it jumps to a 0xCC (`int 3`) instruction, generating SIGTRAP. In the crash handler it checks for SIGTRAP and if so, simply validates that field1 and field2 are equal. If they are not, the program halts in a failing state.

---

```c
if ( opchode == 5 )
{
  // rax = getOpchode
  // strcpy(stackbuf, "So much space on the stack, what could go wrong, you never know!");
  // This causes an overflow yielding a SIGSEGV upon returning (0xc3)
  savedregs = 0x2C676E6F7277206FLL;
  retaddr = 0x76656E20756F7920LL;
  result = getOpchode(checked_);
}
// ---------------------------------
_BOOL8 checkSigsegvRet()
{
  _BOOL8 result; // rax

  if ( prstatus->pr_info.si_signo == SIGSEGV )
    result = *(_BYTE *)pr_preg->rip == 0xC3u;   // ret;
  else
    result = 0LL;
  return result;
}
if ( (unsigned int)checkSigsegvRet() )        // opchode == 5
{
  checked->field1 <<= pr_preg->rax;
  stepTwo(checked);
}
```
This one has another complex mechanism. In the crasher, if opcode is 5, it first loads some data from the state machine's program code into `rax`, then smashes the stack with a bad strcpy causing a SIGSEGV to be generated upon executing the `ret` instruction. The crash handler checks if SIGSEGV was generated on 0xC3 instruction, which is `ret`. If so, it loads `field1` with the newly-read data from `rax`.

---

```c
if ( opchode == 3 )
{
  checked = (checked *)getOpchode(checked);   // rdi = getOpchode
  MEMORY[0x5647455347495300](checked);        // rax = "SIGSEGV"; call rax;
}
_BOOL8 checkSigsegCallRax()
{
  _BOOL8 result; // rax

  if ( prstatus->pr_info.si_signo == SIGSEGV )
    result = *(_WORD *)pr_preg->rip == 0xD0FFu; // call rax;
  else
    result = 0LL;
  return result;
}
if ( (unsigned int)checkSigsegCallRax() )     // opchode == 3
{
  checked->field2 = pr_preg->rdi;
  stepTwo(checked);
}
```
This is basically the same thing as opcode 5, but it uses `call rax` with a garbage address rather than `ret`. It effectively loads `field2` with `rdi`, which holds some data read from the automaton's program tape.

---

```c
if ( opchode == 1 )
{
  v2 = getOpchode(checked); // rax = getOpchode()
  v1 = v2 % 0;              // SIGFPE
  vaddrWtf = v2 / 0;
}
if ( prstatus->pr_info.si_signo == SIGFPE )   // opchode == 1
{
  checked->field1 = pr_preg->rax;
  stepTwo(checked);
}
```
Very simple one. It crashes with a floating point exception (division by zero). It does the same thing as opcode 5, loading `field1` with some data from the program tape.

---

```c
if ( opchode == 4 )
  abort();          // SIGABRT
_BOOL8 checkSigabrtedFromUser()
{
  // return 1 if abort from user, 0 if aborted from libc.
  // e.g., return 1 if SIGABRT due to opcode 2.
  _BOOL8 result; // rax
  if ( prstatus->pr_info.si_signo == SIGABRT )
    result = (read_vaddr(pr_preg->rbp + 8) & 0xFFFFFFFFFF000000LL) == 0;
  else
    result = 0LL;
  return result;
}
result = checkSigabrtedFromUser();
if ( !(_DWORD)result )
  return result; // fail
// opchode == 2
keyIdx = checked->field2 & 0x3FLL;
checked->field2 = checked->key[keyIdx];
if ( checked->field2 )
  checked->key[keyIdx] ^= checked->pc & 0x1F;
result = stepTwo(checked);
return result;
```
Very complex mechanism for this one. In the crasher, if opcode is 4, it simply calls abort, leading to an abort from **user code**. This is different from the abort in opcode 2, because that abort was generated in **libc code**. As it so happens, this binary doesn't have PIE, so libc addresses are always `00007fXXXXXXXXXX` and the program's code addresses are always `0x0000000000XXXXXX`. It uses this to distinguish between *user aborts* and *libc aborts*. If an abort was not due to the user, the program halts in an failing state. Otherwise, it loads `field2` with a byte from the key at index `field2`, then xors it with the `pc` if the byte was nonzero. This is difficult to encode in z3 because it has both conditional behavior as well as array access at a variable index.

---

```c
if ( opchode == 7 )
{
  stream = fopen("/tmp/flag", "w");
  fprintf(stream, "flag{%s}\n", &checked_->key[4]);
  fflush(stream);
  fclose(stream);
  exit(0);
}
```
This is our accepting state. If the program completes execution with no problems then we have succeeded.

---

To crack the check function, I opted to use z3. Encoding all of the semantics exactly was extremely tricky and I wasted a lot of time on typo bugs. Nevertheless, z3 made short work of it once it had been encoded properly. There are several unknowns: `checked->field1`, `checked->field2`, `rax` at crash time, `rdx` at crash time. Moreover, the entirety of the `checked->key` array is unknown, and that buffer stores not only our input but also our computed flag. The hardest part was encoding opcode 2, the key xor opcode. The resulting z3 SMT expression was basically:
```
keyIdx_next = field2_current & 0x3f
field2_next = key_current[keyIdx_next]
Or (
  And ( field2_next != 0 , key_next = Store(key_current, keyIdx_next, key_current[keyIdx_next] ^ (pc & 0x1f) )
  And ( field2_next == 0 , key_next = key_current )
)
```

Notice how the conditional behavior was encoded into an or-statement between the two cases: field2 is nonzero in which case the xor is performed and key is modified, or field2 is zero in which case the key is left unmodified. When using z3, it's crucial to never make huge expressions. That's why I implement a form of SSA by versioning my variables by creating new versions whenever they are assigned to. This makes z3's job much easier so it can complete in a reasonable amount of time.

Finally, we are done with this hellish problem and we get our correct input and output:
```
key=R"yXkFw8X3jRu=v.L,w}Rn9iL]7Lu#y`XVaX`$rc<ILMq"Ij2X2}
flag{_1t_rUn5_4s_r0o7_5nd_c4n_D0_l0ts_Of_s7up1D_Th1Ng5_!}
```

