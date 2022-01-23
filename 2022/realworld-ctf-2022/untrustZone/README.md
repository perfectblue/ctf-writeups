# UntrustZone

Category: Pwn

Solves: 1 (we're the only solve!)

Solve by: cts and theKidOfArcrania

Points: 500

---

# introduction

hello!! I recommend you read the [prequel](https://github.com/perfectblue/ctf-writeups/tree/master/2022/realworld-ctf-2022/trust%20or%20not) in this series. to understand what is going on here.

# level up!!!

this time they actually change the signing keys or something, since i can't upload and run my own TA on the remote anymore. and the remote is different from the local this time and the local has dummy flags only.

so we gotta exploit the TA to read out our objects.

# the vulnerability

TA runs in secure world, it has a simple stack BOF bug

```c
__int64 __fastcall TA_InvokeCommandEntryPoint(void *session, uint32_t command, uint32_t param_types, TEE_Param *a4)
{
  unsigned int obj_id_sz; // w21
  void *obj_id; // x20 MAPDST
  unsigned int v8; // w0
  unsigned int v9; // w19
  unsigned int v11; // w0
  unsigned __int64 obj; // [xsp+48h] [xbp+48h] BYREF
  __int64 data[4]; // [xsp+50h] [xbp+50h] BYREF

  if ( command )
    return 0xFFFF0006;
  memset(data, 0, sizeof(data));
  if ( param_types != 0x55 )
  {
    return 0xFFFF0006;
  }
  else
  {
    obj_id_sz = a4->memref.size;
    obj_id = (void *)TEE_Malloc(obj_id_sz, 0);
    if ( obj_id )
    {
      TEE_MemMove((unsigned __int64)obj_id, (unsigned __int64)a4->memref.buffer, obj_id_sz);
      TEE_MemMove((unsigned __int64)data, (unsigned __int64)a4[1].memref.buffer, a4[1].memref.size);// <-- stack BOF
      v8 = TEE_CreatePersistentObject(1u, obj_id, obj_id_sz, 0x407u, 0LL, 0LL, 0, &obj);
      v9 = v8;
      if ( v8 )
      {
        EMSG("random_number_generate", 0x72u, 1u, 1u, "TEE_CreatePersistentObject failed 0x%08x", v8);
      }
      else
      {
        v11 = TEE_WriteObjectData(obj, (__int64)data, 0x20u);
        v9 = v11;
        if ( v11 )
        {
          EMSG("random_number_generate", 0x79u, 1u, 1u, "TEE_WriteObjectData failed 0x%08x", v11);
          TEE_CloseAndDeletePersistentObject1(obj);
        }
        else
        {
          TEE_CloseObject(obj);
        }
      }
      TEE_Free((__int64)obj_id);
    }
    else
    {
      return 0xFFFF000C;
    }
  }
  return v9;
}
```

ASLR is totally ineffective and secure world address space is 32 bits

```c
unsigned __int64 get_pad_begin()
{
  unsigned int v0; // w0
  int v2; // [xsp+1Ch] [xbp+1Ch] BYREF

  v2 = 0;
  v0 = sub_E14D6CC(&v2, 4LL);
  if ( !v0 )
    return (unsigned __int64)(v2 & 0x7F) << 12; // <-- only 7 bits entropy
  sub_E1536EC("get_pad_begin", 714LL, 3LL, 1LL, "Random read failed: %#x", v0);
  return 0LL;
}
```

^ When debugging, patch this function to just return 0 so ASLR slide is always 0

When testing, just run 150 times (Up + Enter lol) brute works fine.

Address space look like this (when aslr slide is 0)

```
E/LD:  Status of TA b6c53aba-9669-4668-a7f2-205629d00f86
E/LD:   arch: aarch64
E/LD:  region  0: va 0x40004000 pa 0x0e300000 size 0x002000 flags rw-s (ldelf)
E/LD:  region  1: va 0x40006000 pa 0x0e302000 size 0x008000 flags r-xs (ldelf)
E/LD:  region  2: va 0x4000e000 pa 0x0e30a000 size 0x001000 flags rw-s (ldelf)
E/LD:  region  3: va 0x4000f000 pa 0x0e30b000 size 0x004000 flags rw-s (ldelf)
E/LD:  region  4: va 0x40013000 pa 0x0e30f000 size 0x001000 flags r--s
E/LD:  region  5: va 0x40014000 pa 0x00001000 size 0x012000 flags r-xs [0]
E/LD:  region  6: va 0x40026000 pa 0x00013000 size 0x00c000 flags rw-s [0]
E/LD:  region  7: va 0x40032000 pa 0x0e32e000 size 0x001000 flags rw-s (stack)
E/LD:  region  8: va 0x40033000 pa 0x76ca92b0 size 0x005000 flags rw-- (param)
E/LD:  region  9: va 0x40038000 pa 0x7f404cc8 size 0x001000 flags rw-- (param)
E/LD:   [0] b6c53aba-9669-4668-a7f2-205629d00f86 @ 0x40014000
```

Stack and .text are based on same aslr base so no need for stack leak. Have extra space after stack segment that hold our params. Param pages are mapped to non secure world. **However we cannot make Optee syscall with pointer in non-secure (param) pages as in/out pointer argument, it will fail with Access denied.**

If brute succeed, all request in same session are serviced by same process so pointer will stay the same across requests. Good meme. If failed, will just crash and we have unlimited attempt. Also good meme. I hope apple and google should learn from this approach :+1:

# Target info

flag is stored with the "secure object" storage API in encrypted hash tree blob in /data/tee

we don't know the object name so we need to enumerate them using the api.

# Overall strategy

1. write a trusted application (TA) and run on local qemu to learn how to enumerate all the secure objects names (We can load our own TA on our local test but not on the remote). then we know the name on local at least (`this_is_test`)

2. write a program on the host that can crash the target TA using bof

3. write basic exploit for bof to return cleanly to syscall_exit_return in the TA

4. write exploit that can at least open the file, in rop, with TA aslr off

5. write exploit that can open, read, and copy out the file

6. test with aslr on

7. write exploit to enumerate the files with rop. without reading

8. test locally again with aslr

9. test on remote (we get the flag at this point)

10. (optional) write cool exploit that combine enumeration with the reading

# debugging

debugging this shit sucks. we used qemu gdbstub and it kinda works

```
$ gdb-multiarch random_aarch64_binary # do NOT use the optee kernel elf, gdb will get too smart because it sees its loading at the same address, don't do that shit. just pick some totally random unrelated binary and it should work. fuck it. gdbstubs always suck
gdb> optee
gdb> b *0xe100000 # break at entrypoint
gdb> c # wait for TZ optee entrypoint
gdb> b *0xE125A20 # breakpoint in syscall_storage_obj_open
gdb> c
gdb> b *0x400276c # breakpoint in TEE_OpenPersistentObject
```

now you should be able to have breakpoint in optee kernel and also even the TA.

**but really i just enabled serial uart for secure world in qemu and log to file serial2.txt, this works quite good.**

```
D/TC:1 0 abort_handler:531 [abort] abort in User mode (TA will panic)
E/TC:? 0 
E/TC:? 0 User mode data-abort at address 0x1234567 (translation fault)
E/TC:? 0  esr 0x82000005  ttbr0 0x200000e191020   ttbr1 0x00000000   cidr 0x0
E/TC:? 0  cpu #1          cpsr 0x40000100
E/TC:? 0  x0  aaaaaaaaaaaaaaaa x1  0000000000000001
E/TC:? 0  x2  2121212121212121 x3  0000000000000000
E/TC:? 0  x4  0000000040033000 x5  0000000000000000
E/TC:? 0  x6  ffffffffffffffff x7  0000000040033000
E/TC:? 0  x8  000000000000002d x9  0000000040029540
E/TC:? 0  x10 0000000000000000 x11 0000000000000000
E/TC:? 0  x12 0000000000000000 x13 0000000040032f80
E/TC:? 0  x14 0000000000000000 x15 0000000000000000
E/TC:? 0  x16 000000000e126100 x17 0000000000000000
E/TC:? 0  x18 0000000000000000 x19 1919191919191919
E/TC:? 0  x20 2020202020202020 x21 2121212121212121
E/TC:? 0  x22 0000000000000001 x23 aaaaaaaaaaaaaaaa
E/TC:? 0  x24 2424242424242424 x25 2525252525252525
E/TC:? 0  x26 2626262626262626 x27 0000000001234567
E/TC:? 0  x28 2828282828282828 x29 6969696969696969
E/TC:? 0  x30 00000000400182d4 elr 0000000001234567
E/TC:? 0  sp_el0 0000000040032110
E/LD:  Status of TA b6c53aba-9669-4668-a7f2-205629d00f86
E/LD:   arch: aarch64
E/LD:  region  0: va 0x40004000 pa 0x0e300000 size 0x002000 flags rw-s (ldelf)
E/LD:  region  1: va 0x40006000 pa 0x0e302000 size 0x008000 flags r-xs (ldelf)
E/LD:  region  2: va 0x4000e000 pa 0x0e30a000 size 0x001000 flags rw-s (ldelf)
E/LD:  region  3: va 0x4000f000 pa 0x0e30b000 size 0x004000 flags rw-s (ldelf)
E/LD:  region  4: va 0x40013000 pa 0x0e30f000 size 0x001000 flags r--s
E/LD:  region  5: va 0x40014000 pa 0x00001000 size 0x012000 flags r-xs [0]
E/LD:  region  6: va 0x40026000 pa 0x00013000 size 0x00c000 flags rw-s [0]
E/LD:  region  7: va 0x40032000 pa 0x0e32e000 size 0x001000 flags rw-s (stack)
E/LD:  region  8: va 0x40033000 pa 0x7c4612b0 size 0x005000 flags rw-- (param)
E/LD:  region  9: va 0x40038000 pa 0x7f36d848 size 0x001000 flags rw-- (param)
E/LD:   [0] b6c53aba-9669-4668-a7f2-205629d00f86 @ 0x40014000
```

i debug many exploit before with only dump like this. this is my curse. i am alone on this barren earth. i am empty. and yet. i fish

# exploit detail

Go read `gucci_chain.c` for exploit

1. aarch64 rop is tough, author says we could have used gadgets in ldelf but i did not notice this during ctf

2. optee syscall will not like pointer arguments outside of secure pages, so param pages past end of stack won't work. so just pivot the entire chain up to stack_base (0x40032000) at the start

3. alloc enum -> start enum -> next enum -> open -> read -> memmove

4. done

this chain was fucking hard to write. At least the panic message give me registers and mappings.

`rwctf{Pwn_Ta_fr0m_c4_1s_Fun!!!}`

# acknowledgements

shout out to the challenge author for enabling internet and wget inside the vm on the remote because that shit totally sucks when you have to echo-load a 50KB exploit binary with base64.
