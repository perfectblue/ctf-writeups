# hfs-vm

**Category**: Reversing

287 Points
42 Solves

---

The binary creates two processes, a parent a child while maintaining an fd between the two so they can communicate.

The child process is a VM that reads up to 0x3e4 bytes, and runs VM on the input. The context set-up is as follows:

```
struct context {
	long socket_fd;
	long mmap_addr;
	short registers[14];
	short sp;
	short counter;
	short stack[32];
}
```

The instructions implemented by the VM include mov, add, sub, swap, xor, push, and pop, and moving values from stack to a register and vice versa. Additionally there is a syscall function that communicates with the parent process and sends over a couple of user bytes based on registers 1, 2, and 3.

The parent process listens for 5 bytes sent from the child process and does a few things based on it:

```
switch ( (_BYTE)opcode )
  {
    case 0:
      system_ls();
      goto LABEL_3;
    case 1:
      fwrite_shit(&com_buf, size_1);
      goto LABEL_3;
    case 2:
      if ( (unsigned int)getuid_shit(*(_WORD *)(buf + 1), (__uid_t *)&com_buf, size_1) )
        goto LABEL_6;
      goto LABEL_3;
    case 3:
      if ( !(unsigned int)sice_flag(&com_buf, size_1) )
        goto LABEL_3;
      goto LABEL_6;
    case 4:
      if ( (unsigned int)read_random(*(_WORD *)(buf + 1), &com_buf, size_1) )
      {
LABEL_6:
        opcode = 0xFFFFFFFFLL;
      }
      else
      {
LABEL_3:
        memcpy((void *)(global_shit + 2), &com_buf, *(unsigned __int16 *)global_shit);
        opcode = 0LL;
      }
```

For this challenge, the interesting function is case 3. This function reads in ./flag1 into com_buf.

Now to obtain the value of this, we have to understand how the child and parent process communicates. They do so through an shared mmaped region. The first 16 bits of the shared mmap region denotes the number of bytes it stores. The parent process always reads from the shared region before the switch into com_buf, then at the end, it copies the data from com_buf back to the shared region.

Then, in the syscall function of the child process, it reads data from the shared mem onto the stack. Additionally, we are able to print the stack in the child process using opcode 10, which prints out the context struct basically.

So, essentially to obtain flag1, we can use the child process to tell the parent process to read flag1, copy it into the shared memory. The child then copies the shared memory onto our stack, which we can print through the debug opcode. The exploit is below:

```python
from pwn import *

def loadreg(reg_num, val):
  return p64(0x2000 | (reg_num << 5) | (val << 16))

def debug():
  return p64(0xa)

def syscall():
  return p64(9)

def pushval(val):
  return p64(5 | 0x2000 | (val << 16))

code = loadreg(1, 3) + (pushval(0))*32 + syscall() + debug()
print len(code)
print code
```

## Flag
midnight{m3_h4bl0_vm}
