org 0x69
bits 16

main: 
   mov     ax, menu
   mov     bx, 13
   call    print
   mov     ax, 0x233e
   mov     bx, 1
   call    read
   mov     si, 0x233e
   mov     ax, [si]
   cmp     al, '4'
   jz      alloc
   cmp     al, '5'
   jz      update
   cmp     al, '6'
   jz      free
   cmp     al, '7'
   jz      exit
   cmp     al, '8'
   jz      copy
   cmp     al, '9'
   jz      leak
   jmp     main


update:
   call doupdate
   jmp main

  
copy:
   call docopy
   jmp main


alloc:
   call doalloc
   jmp main

free:
   call dofree
   jmp main

leak:
   call doleak
   jmp main

exit:
   hlt

doalloc:
   push    ax
   push    bx
   push    cx
   push    dx
   push    si
   push    di
   mov     ax, aSize
   mov     bx, 5
   call    print
   mov     ax, 0x2340
   mov     bx, 2
   call    read
   push    100h
   popf
   mov     bx, [0x2340]
   mov     ax, 100h
   vmcall
   pop     di
   pop     si
   pop     dx
   pop     cx
   pop     bx
   pop     ax
   retn

dofree:
   push    ax
   push    bx
   push    cx
   push    dx
   push    si
   push    di
   mov     ax, aIndex
   mov     bx, 6
   call    print
   mov     ax, 0x2343
   mov     bx, 1
   call    read
   push    100h
   popf
   mov     ax, 101h
   mov     bx, 1
   mov     cx, [0x2343]
   vmcall
   pop     di
   pop     si
   pop     dx
   pop     cx
   pop     bx
   pop     ax
   retn


doleak:
   push    ax
   push    bx
   push    cx
   push    dx
   push    si
   push    di
   mov     ax, aSize
   mov     bx, 5
   call    print
   mov     ax, 0x2340
   mov     bx, 2
   call    read
   mov     ax, 0x4000
   mov     bx, [0x2340]
   call    print
   pop     di
   pop     si
   pop     dx
   pop     cx
   pop     bx
   pop     ax
   retn

docopy:
   push    ax
   push    bx
   push    cx
   push    dx
   push    si
   push    di
   mov     ax, aSize
   mov     bx, 5
   call    print
   mov     ax, 0x2340
   mov     bx, 2
   call    read
   mov     ax, aIndex
   mov     bx, 6
   call    print
   mov     ax, 0x2343
   mov     bx, 1
   call    read
   push    100h
   popf
   mov     ax, 102h
   mov     bx, 2
   mov     cx, [0x2343]
   mov     dx, [0x2340]
   vmcall
   pop     di
   pop     si
   pop     dx
   pop     cx
   pop     bx
   pop     ax
   retn

doupdate:
   push    ax
   push    bx
   push    cx
   push    dx
   push    si
   push    di
   mov     ax, aSize
   mov     bx, 5
   call    print
   mov     ax, 0x2340
   mov     bx, 2
   call    read
   mov     ax, aIndex
   mov     bx, 6
   call    print
   mov     ax, 0x2343
   mov     bx, 1
   call    read
   mov     ax, aContent
   mov     bx, 8
   call    print
   mov     ax, 0x4000
   mov     bx, [0x2340]
   call    read
   push    100h
   popf
   mov     ax, 102h
   mov     bx, 1
   mov     cx, [0x2343]
   mov     dx, [0x2340]
   vmcall
   pop     di
   pop     si
   pop     dx
   pop     cx
   pop     bx
   pop     ax
   retn

print:
   push    cx
   push    dx
   push    si
   mov     cx, bx
   mov     si, ax

printLoop:                          
   mov     al, [si]
   out     23, al
   inc     si
   loop    printLoop
   pop     si
   pop     dx
   pop     cx
   retn

read:
    push    cx
    push    dx
    push    si
    mov     cx, bx
    mov     si, ax

readLoop:
    in      al, 23
    mov     [si], al
    inc     si
    loop    readLoop
    pop     si
    pop     dx
    pop     cx
    retn

aIndex db 'Index:'
menu db 'Your choice:', 0xa
aSize db 'Size:'
aContent db 'Content:'
