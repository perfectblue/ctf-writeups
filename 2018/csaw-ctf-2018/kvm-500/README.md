# KVM

**Category**: Reverse

500 Points

58 Solves

**Problem description**:
n/a

**Solved by**: cts

---

*Writeup by cts*

KVM rev! So that means realmode, right? Not necessarily:

```C
signed __int64 __fastcall main(__int64 argc, char **argv, char **envp)
{
  kvmCpuData_t pCpu; // [rsp+0h] [rbp-20h]
  kvmData_t dst; // [rsp+10h] [rbp-10h]

  setupKvm(&dst, 0x200000LL);
  setupVcpu(&dst, &pCpu);
  setupAndRunVmState(&dst, &pCpu);
  return 1LL;
}

__int64 __fastcall init_regs(kvmData_t *pKvm, kvm_sregs *kvm_sregs)
{
  _QWORD *pMem3k; // ST20_8
  _QWORD *pMem4k; // ST10_8
  __int64 result; // rax

  pMem3k = (char *)pKvm->memory + 0x3000;
  pMem4k = (char *)pKvm->memory + 0x4000;
  *((_QWORD *)pKvm->memory + 1024) = 0x3007LL;
  *pMem3k = 0x4007LL;
  *pMem4k = 0x87LL;
  kvm_sregs->cr3 = 0x2000LL;
  kvm_sregs->cr4 = 0x20LL;                      // PAE
  kvm_sregs->cr0 = CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_ET|CR0_MP|CR0_PE;
  kvm_sregs->efer = 0x500LL;
  setup_segments(kvm_sregs);
  return result;
}
```

We're in PAE and segments are setup for us already. The rest of the VM setup is pretty typical, I'll include it here for completeness.

```c
// #STR: "open /dev/kvm", "KVM_GET_API_VERSION", "Got KVM api version %d, expected %d\n", "KVM_CREATE_VM", "KVM_SET_TSS_ADDR", "mmap mem", "KVM_SET_USER_MEMORY_REGION", "/dev/kvm"
int __fastcall setupKvm(kvmData_t *pKvm, __int64 len)
{
  int result; // eax
  kvm_userspace_memory_region usermem; // [rsp+10h] [rbp-30h]
  int kvmApiVersion; // [rsp+3Ch] [rbp-4h]

  pKvm->kvm_fd = open("/dev/kvm", 2, len);
  if ( pKvm->kvm_fd < 0 )
  {
    perror("open /dev/kvm");
    exit(1);
  }
  kvmApiVersion = ioctl(pKvm->kvm_fd, KVM_GET_API_VERSION, 0LL);
  if ( kvmApiVersion < 0 )
  {
    perror("KVM_GET_API_VERSION");
    exit(1);
  }
  if ( kvmApiVersion != 12 )
  {
    fprintf(stderr, "Got KVM api version %d, expected %d\n", (unsigned int)kvmApiVersion, 12LL);
    exit(1);
  }
  pKvm->vmfd = ioctl(pKvm->kvm_fd, KVM_CREATE_VM, 0LL);
  if ( pKvm->vmfd < 0 )
  {
    perror("KVM_CREATE_VM");
    exit(1);
  }
  if ( ioctl(pKvm->vmfd, KVM_SET_TSS_ADDR, 0xFFFBD000LL) < 0 )
  {
    perror("KVM_SET_TSS_ADDR");
    exit(1);
  }
  pKvm->memory = mmap(0LL, len, 3, MAP_NORESERVE|MAP_ANON|MAP_PRIVATE, -1, 0LL);// zEroEd
  if ( pKvm->memory == (void *)-1LL )
  {
    perror("mmap mem");
    exit(1);
  }
  madvise(pKvm->memory, len, MADV_MERGEABLE);   // MADV_MERGEABLE (since Linux 2.6.32)
                                                // Enable Kernel Samepage Merging (KSM) for the pages in the
                                                // range specified by addr and length.  The kernel regularly
                                                // scans those areas of user memory that have been marked as
                                                // mergeable, looking for pages with identical content.  These
                                                // are replaced by a single write-protected page (which is
                                                // automatically copied if a process later wants to update the
                                                // content of the page).  KSM merges only private anonymous pages
                                                // (see mmap(2)).
                                                // 
                                                // The KSM feature is intended for applications that generate
                                                // many instances of the same data (e.g., virtualization systems
                                                // such as KVM).  It can consume a lot of processing power; use
                                                // with care.  See the Linux kernel source file
                                                // Documentation/vm/ksm.txt for more details.
                                                // 
                                                // The MADV_MERGEABLE and MADV_UNMERGEABLE operations are
                                                // available only if the kernel was configured with CONFIG_KSM.
  usermem.slot = 0;
  usermem.flags = 0;
  usermem.guest_phys_addr = 0LL;
  usermem.memory_size = len;
  usermem.userspace_addr = (__u64)pKvm->memory;
  result = ioctl(pKvm->vmfd, KVM_SET_USER_MEMORY_REGION, &usermem);
  if ( result >= 0 )
    return result;
  perror("KVM_SET_USER_MEMORY_REGION");
  exit(1);
  return result;
}

// #STR: "KVM_GET_VCPU_MMAP_SIZE", "mmap kvm_run", "KVM_CREATE_VCPU"
kvm_run *__fastcall setupVcpu(kvmData_t *pKvm, kvmCpuData_t *pCpu)
{
  kvm_run *result; // rax
  int mem_len; // [rsp+1Ch] [rbp-4h]

  pCpu->vcpufd = ioctl(pKvm->vmfd, KVM_CREATE_VCPU, 0LL);
  if ( pCpu->vcpufd < 0 )
  {
    perror("KVM_CREATE_VCPU");
    exit(1);
  }
  mem_len = ioctl(pKvm->kvm_fd, KVM_GET_VCPU_MMAP_SIZE, 0LL);
  if ( mem_len <= 0 )
  {
    perror("KVM_GET_VCPU_MMAP_SIZE");
    exit(1);
  }
  pCpu->pKvm_run = (kvm_run *)mmap(0LL, mem_len, PROT_WRITE|PROT_READ, 1, pCpu->vcpufd, 0LL);
  result = pCpu->pKvm_run;
  if ( result != (kvm_run *)-1LL )
    return result;
  perror("mmap kvm_run");
  exit(1);
  return result;
}

__int64 __fastcall init_regs(kvmData_t *pKvm, kvm_sregs *kvm_sregs)
{
  _QWORD *pMem3k; // ST20_8
  _QWORD *pMem4k; // ST10_8
  __int64 result; // rax

  pMem3k = (char *)pKvm->memory + 0x3000;
  pMem4k = (char *)pKvm->memory + 0x4000;
  *((_QWORD *)pKvm->memory + 1024) = 0x3007LL;
  *pMem3k = 0x4007LL;
  *pMem4k = 0x87LL;
  kvm_sregs->cr3 = 0x2000LL;
  kvm_sregs->cr4 = 0x20LL;                      // PAE
  kvm_sregs->cr0 = CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_ET|CR0_MP|CR0_PE;
  kvm_sregs->efer = 0x500LL;
  setup_segments(kvm_sregs);
  return result;
}

void __fastcall setup_segments(kvm_sregs *p_kvm_sregs)
{
  p_kvm_sregs->cs.base = 0LL;
  *(_QWORD *)&p_kvm_sregs->cs.limit = 0x10B0008FFFFFFFFLL;
  *(_QWORD *)&p_kvm_sregs->cs.dpl = 0x101010000LL;
  p_kvm_sregs->ss.base = 0LL;
  *(_QWORD *)&p_kvm_sregs->ss.limit = 0x1030010FFFFFFFFLL;
  *(_QWORD *)&p_kvm_sregs->ss.dpl = 0x101010000LL;
  p_kvm_sregs->gs.base = p_kvm_sregs->ss.base;
  *(_QWORD *)&p_kvm_sregs->gs.limit = *(_QWORD *)&p_kvm_sregs->ss.limit;
  *(_QWORD *)&p_kvm_sregs->gs.dpl = *(_QWORD *)&p_kvm_sregs->ss.dpl;
  p_kvm_sregs->fs.base = p_kvm_sregs->gs.base;
  *(_QWORD *)&p_kvm_sregs->fs.limit = *(_QWORD *)&p_kvm_sregs->gs.limit;
  *(_QWORD *)&p_kvm_sregs->fs.dpl = *(_QWORD *)&p_kvm_sregs->gs.dpl;
  p_kvm_sregs->es.base = p_kvm_sregs->fs.base;
  *(_QWORD *)&p_kvm_sregs->es.limit = *(_QWORD *)&p_kvm_sregs->fs.limit;
  *(_QWORD *)&p_kvm_sregs->es.dpl = *(_QWORD *)&p_kvm_sregs->fs.dpl;
  p_kvm_sregs->ds.base = p_kvm_sregs->es.base;
  *(_QWORD *)&p_kvm_sregs->ds.limit = *(_QWORD *)&p_kvm_sregs->es.limit;
  *(_QWORD *)&p_kvm_sregs->ds.dpl = *(_QWORD *)&p_kvm_sregs->es.dpl;
}

// #STR: "KVM_SET_SREGS", "KVM_SET_REGS", "KVM_GET_SREGS"
__int64 __fastcall setupAndRunVmState(kvmData_t *pKvm, kvmCpuData_t *pCpu)
{
  kvm_regs kvm_regs; // [rsp+10h] [rbp-1D0h]
  kvm_sregs kvm_sregs; // [rsp+A0h] [rbp-140h]

  if ( ioctl(pCpu->vcpufd, KVM_GET_SREGS, &kvm_sregs) < 0 )
  {
    perror("KVM_GET_SREGS");
    exit(1);
  }
  init_regs(pKvm, &kvm_sregs);
  if ( ioctl(pCpu->vcpufd, KVM_SET_SREGS, &kvm_sregs) < 0 )
  {
    perror("KVM_SET_SREGS");
    exit(1);
  }
  memset(&kvm_regs, 0, 0x90uLL);
  kvm_regs.rflags = 2LL;
  kvm_regs.rip = 0LL;
  kvm_regs.rsp = 0x200000LL;
  if ( ioctl(pCpu->vcpufd, KVM_SET_REGS, &kvm_regs) < 0 )
  {
    perror("KVM_SET_REGS");
    exit(1);
  }
  memcpy(pKvm->memory, guestMem, &guestMem_end - (_UNKNOWN *)guestMem);
  return runVm(pKvm, pCpu, (int)pCpu);
}
```

The most important part is that it maps into the guest's memory some binary blob and executes it at CS:IP = 0.

So, let's extract this binary blob and open it in IDA, 64bit mode.

```c
void __noreturn main()
{
  char v0[10252]; // [rsp+0h] [rbp-2810h]
  unsigned int v1; // [rsp+280Ch] [rbp-4h]

  gets(v0, 10240LL);
  v1 = 0;
  if ( v1 > 0x27FF )
  {
    if ( !(unsigned int)strings_equal(4896LL, 1408LL, 0x54AuLL) )
      puts("Correct!\n");
    __halt();
    JUMPOUT(loc_8A);
  }
  mystery((unsigned int)v0[v1], (char *)&unk_1300);
}
```

Wait, but if this is in the guest, how is it doing IO?

```c
__int64 __cdecl gets(char *a1, signed int len)
{
  unsigned __int8 inputbyte; // al
  __int64 result; // rax
  signed int i; // [rsp+18h] [rbp-4h]

  for ( i = 0; ; ++i )
  {
    result = (unsigned int)i;
    if ( i >= len )
      break;
    inputbyte = __inbyte(0xE9u);
    a1[i] = inputbyte;
  }
  return result;
}
__int64 __usercall puts@<rax>(unsigned __int8 *a1@<rdi>)
{
  __int64 result; // rax
  unsigned __int8 *i; // [rsp+10h] [rbp-8h]

  for ( i = a1; ; ++i )
  {
    result = *i;
    if ( !(_BYTE)result )
      break;
    __outbyte(0xE9u, *i);
  }
  return result;
}
```

Aha, so it's doing IO on port E9...which gets handled by the host, of course:

```c
// #STR: "Got exit_reason %d, expected KVM_EXIT_HLT (%d)\n", "KVM_GET_REGS", "KVM_SET_REGS", "KVM_RUN"
__int64 __fastcall runVm(kvmData_t *pKvm, kvmCpuData_t *pCpu, int rip)
{
  __u32 v3; // eax
  __int64 result; // rax
  Jumptable_entry tableEntry; // ax
  kvm_regs kvm_regs; // [rsp+20h] [rbp-A0h]
  kvm_run *pKvm_run; // [rsp+B0h] [rbp-10h]
  kvm_run *pKvm_run_; // [rsp+B8h] [rbp-8h]

  while ( 1 )
  {
    while ( 1 )
    {
      if ( ioctl(pCpu->vcpufd, KVM_RUN, 0LL) < 0 )
      {
        perror("KVM_RUN");
        exit(1);
      }
      v3 = pCpu->pKvm_run->exit_reason;
      if ( v3 != KVM_EXIT_IO )
        break;
      if ( pCpu->pKvm_run->io.direction == KVM_EXIT_IO_OUT && pCpu->pKvm_run->io.port == 0xE9 )
      {                                         // vm write
        pKvm_run_ = pCpu->pKvm_run;
        fwrite(
          &pKvm_run_->request_interrupt_window + pCpu->pKvm_run->io.data_offset,
          pCpu->pKvm_run->io.size,
          1uLL,
          stdout);
        fflush(stdout);
      }
      else
      {
        if ( pCpu->pKvm_run->io.direction || pCpu->pKvm_run->io.port != 0xE9 )
        {
badExit:
          fprintf(
            stderr,
            "Got exit_reason %d, expected KVM_EXIT_HLT (%d)\n",
            pCpu->pKvm_run->exit_reason,
            5LL,
            pCpu,
            pKvm);
          exit(1);
        }                                       // vm read
        pKvm_run = pCpu->pKvm_run;
        fread(
          &pKvm_run->request_interrupt_window + pCpu->pKvm_run->io.data_offset,
          pCpu->pKvm_run->io.size,
          1uLL,
          stdin);
      }
    }
    if ( v3 != KVM_EXIT_HLT )
      goto badExit;
    if ( ioctl(pCpu->vcpufd, KVM_GET_REGS, &kvm_regs) < 0 )
    {
      perror("KVM_GET_REGS");
      exit(1);
    }
    result = kvm_regs.rax;
    if ( !kvm_regs.rax )                        // exit
      return result;
    tableEntry = lookupRip(kvm_regs.rax);
    kvm_regs.rip = tableEntry.rip;
    if ( ioctl(pCpu->vcpufd, KVM_SET_REGS, &kvm_regs) < 0 )
    {
      perror("KVM_SET_REGS");
      exit(1);
    }
  }
}
// #STR: "Error - bug the organizer\n"
Jumptable_entry __fastcall lookupRip(int rax_)
{
  Jumptable_entry result; // ax
  int i; // [rsp+1Ch] [rbp-14h]

  for ( i = 0; ; ++i )
  {
    if ( i >= jumptableLen )                    // >= D
    {
      fwrite("Error - bug the organizer\n", 1uLL, 0x1AuLL, stderr);
      exit(1);
    }
    if ( LODWORD(jumpTable[i].rax) == rax_ )
      break;
  }
  result = jumpTable[i];
  result.rax = LODWORD(result.rax);
  return result;
}
struct Jumptable_entry
{
  _QWORD rax;
  _QWORD rip;
};
```

It also looks like that whenever the guest halts, it sets RIP to a new value based on RAX.
RAX = 0 halts the program.
That explains the strange control flow with halts all over the place:

```
seg000:00000000000001FC                 mov     eax, 3493310Dh
seg000:0000000000000201                 hlt
...
seg000:000000000000039C                 mov     edi, 0FC2FF49Fh
seg000:00000000000003A1                 mov     edx, 64D8A529h
seg000:00000000000003A6                 mov     [rbp-1Ch], eax
seg000:00000000000003A9                 cmp     dword ptr [rbp-1Ch], 1
seg000:00000000000003AD                 cmovz   edi, edx
seg000:00000000000003B0                 mov     eax, edi
seg000:00000000000003B2                 hlt
```

What I did was I simply patched every halt instruction to corresponding jumps to make IDA render everything nicely.

The reconstructed control flow looks like this:

```c
void __noreturn main()
{
  char a1[10252]; // [rsp+0h] [rbp-2810h]
  unsigned int i; // [rsp+280Ch] [rbp-4h]

  gets(a1, 10240);
  for ( i = 0; i <= 0x27FF; ++i )
  {
    if ( !generateBuf1(a1[i], &rootNode) )
    {
      puts("Wrong!\n");
      goto returnZero;
    }
  }
  if ( !bufs_unequal(0x54AuLL, buf1, buf2) )
    puts("Correct!\n");
returnZero:
  __halt();
  JUMPOUT(*(_QWORD *)j_returnZero);
}
// return 1 if found
int __fastcall generateBuf1(char charFromInput, tree_t *node)
{
  if ( SLOBYTE(node->value) != -1 )             // leaf
    return SLOBYTE(node->value) == charFromInput;
  if ( generateBuf1(charFromInput, node->left) == 1 )
  {
    appendBit(0);
    return 1;
  }
  if ( generateBuf1(charFromInput, node->right) != 1 )
    return 0;
  appendBit(1);
  return 1;
}
struct __attribute__((aligned(16))) tree_t
{
  _QWORD value;
  tree_t *left;
  tree_t *right;
};

```

So, it converts our input to a bitstream, and uses that to traverse a binary tree.
The traversed leaf nodes' values are used to construct a buffer, which is compared against one which is correct, or the "goal".

We can solve that by brute-forcing it and using recursive backtracking...but it doesn't work! There's too many strings of repeated 1s and 0s in the goal bitstream.
The solution to this is just to (smh) discard bits off the start of the bitstream until we find the flag. Very guessy.

`WOW, FUCKED! flag{who would win?  100 ctf teams or 1 obfuscat3d boi?}`
