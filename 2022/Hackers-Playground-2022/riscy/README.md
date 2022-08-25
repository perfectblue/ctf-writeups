We have a buffer overflow in a risc-v binary. Find gadgets using riscv-objdump. There's a nice gadget that looks like:

```
   mv      t1,a0
   ld      ra,72(sp)
   ld      a0,8(sp)
   ld      a1,16(sp)
   ld      a2,24(sp)
   ld      a3,32(sp)
   ld      a4,40(sp)
   ld      a5,48(sp)
   ld      a6,56(sp)
   ld      a7,64(sp)
   fld     fa0,80(sp)
   fld     fa1,88(sp)
   fld     fa2,96(sp)
   fld     fa3,104(sp)
   fld     fa4,112(sp)
   fld     fa5,120(sp)
   fld     fa6,128(sp)
   fld     fa7,136(sp)
   addi    sp,sp,144
   jr      t1
```

Use this gadgets to control arguments and do read then ecall (basically syscall in risc-v). Read /bin/sh string, then execve.
