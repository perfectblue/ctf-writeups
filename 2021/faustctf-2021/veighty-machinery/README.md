# Veighty Machinery

This service is a bytecode runner.

```
Go program your
                  __
                 /  \
           .-.  |    |
   *    _.-'  \  \__/
    \.-'       \
   /          _/
  |      _  /"
  |     /_\'
   \    \_/
    """"
Give me your bytecode!
I will load the cannon and execute it.
```

## Reverse Engineering

After reverse engineering the service, we find that the bytecode language is a stack-based machine with immediates and strings. The vm_context structure used by the service is shown below:

```C
struct vm_context
{
  __int64 _ip;
  __int64 _sp;
  __int64 stack[0x1000];
  char code[0x1000];
  int flags;
  int code_length;
};
```

There are 0x20 opcodes in the language. These are:

```
nop
push_mem
pop_mem
push_input
add2_stack
sub2_stack
multiply_stack
divide2_stack
modulus2_stack
snprintf_imm
branch
cmp_geq
cmp_leq
cmp_neq
branch_zero
branch_notzero
inc
dec
multiple_by_2
rshift_1
duplicate_top_stack
swap2_stack
alloc_buf_push_ptr_stack
free_buffer
fgets_malloc_push_ptr_stack
concat_strings
free_push_length
atoi_free_stack
do_strcmp
strstr_stack
fopen_write_stack
fread_malloc_stack
```

## Vulnerability Searching

Both string pointers and immediates are stored on the stack. However, pointers are tagged with (1 << 63) to differentiate them from immediates, and every opcode correctly checks whether the operation is acting upon immediates or pointers. I could not find a type confusion vulnerability here.

The vulnerability I found (and the intended one) is in swap2_stack. This opcode swaps the topmost two values on the stack, regardless of whether it's an immediate or pointer. However, it fails to check that there are two or more values on the stack - it only checks that there are 1 or more values. This vulnerability allows us to swap the top-most stack value with the stack pointer, which is right before the stack.

## Exploitation

Using the vulnerability, we can point the stack anywhere relative to the vm_context struct, which exists on the heap. Additionally, the opcodes do not check that the stack pointer points out of range (> 0x1000), but instead checks equivalence to 0x1000. This allows us to use all opcodes even when the stack pointer is out of range. With the push and pop operations, we effectively get arbitrary read and write on the heap.

We can leak a libc pointer through large bins or unsorted bins, and obtain arbitrary write by overwriting tcache freelist FD. I set up the following chunk structure:

```
========================== 
vm_context
========================== 
A - 0x10 sized chunk
========================== 
B - 0x500 sized chunk
========================== 
C - 0x10 sized chunk
==========================
Top
==========================
```

By freeing A, B, and C then pointing the stack pointer to B using the vulnerability, we can use the pop operation and get a libc leak.

Then, we can continue pop-ing the stack pointer until it reaches the freelist FD pointer of chunk A. We then use the push operation to push the address of `__free_hook` onto the tcache freelist.

We then allocate twice from tcache's 0x10 bin, and get a chunk over `__free_hook`.

Actually if we write to `__free_hook - 0x8`, and write the data "/bin/sh;" + p64(system), we can free the chunk that was just allocated and get a shell immediately.

The exploit is in `solve.py`