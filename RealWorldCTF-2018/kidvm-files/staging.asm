org 0
bits 16

padding:
   buffer times 0x10 nop

main: 
   mov ax, aLoaded
   mov bx, 7
   call print
   mov ax, 0x69
   mov bx, 0x300
   call read
   mov ax, aLoaded
   mov bx, 7
   call print
   jmp 0x69


read:
    push    cx
    push    dx
    push    si
    mov     cx, bx
    mov     si, ax

readloop:
    in      al, 23
    mov     [si], al
    inc     si
    loop    readloop
    pop     si
    pop     dx
    pop     cx
    retn

print:
   push    cx
   push    dx
   push    si
   mov     cx, bx
   mov     si, ax

printloop:                          
   mov     al, [si]
   out     23, al
   inc     si
   loop    printloop
   pop     si
   pop     dx
   pop     cx
   retn

aLoaded db 'loaded', 0xa

