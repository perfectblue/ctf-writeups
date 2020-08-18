# Expected Value

The challenge is to compute expected value in 128 byte shellcode or less. The difficult part is to accommodate for 128 bit values. However, this is easily doable by storing values in two 64-bit registers. At the end, to divide by 100, we can divide the upper bits by 100 using the `idiv` instruction, carry the remainder, then divide the lower bits with carry by 100. My final shellcode is:

```
push rbp
mov rbp, rsp
xor r10, r10
xor r12, r12
xor r13, r13
xor rdx, rdx
loop:
mov rax, qword ptr [rdi + r10*8]
mov ebx, dword ptr [rsi + r10*4]
mul rbx
add r12, rax
adc r13, rdx
add r10, 1
cmp r10, 9
jle loop
xor rdx, rdx
xor rbx, rbx
mov bl, 0x64
mov rax, r13
idiv rbx
mov r13, rax
mov rax, r12
idiv rbx
leave 
ret 
```
