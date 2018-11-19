main:
    push 32
    push 0x41
    call bitch
    sub esp, 8
    
    mov eax, 0xa
    out 0, al

    push 73
    call bitch2
    sub esp, 4

    mov edi, cookie
    in al, 1
    mov [edi], al
    push eax
    call p
    sub esp, 4
    inc edi
    in al, 1
    mov [edi], al
    push eax
    call p
    sub esp, 4
    inc edi
    in al, 1
    mov [edi], al
    push eax
    call p
    sub esp, 4
    inc edi
    in al, 1
    mov [edi], al
    push eax
    call p
    sub esp, 4
    mov edx, [cookie]
    xor edx, 0x00001019
    xor edx, 0x000010f6
    mov [cookie], edx


    pause

    push 32
    push 0x41
    call bitch
    sub esp, 8

    mov edi, cookie
    mov al, [edi]
    out 0, al
    push eax
    call p
    sub esp, 4
    inc edi
    mov al, [edi]
    out 0, al
    push eax
    call p
    sub esp, 4
    inc edi    
    mov al, [edi]
    out 0, al
    push eax
    call p
    sub esp, 4
    inc edi    
    mov al, [edi]
    out 0, al
    push eax
    call p
    sub esp, 4
    inc edi    

    mov eax, 0x12345678
    out 0, al
out 0, al
out 0, al
out 0, al
out 0, al
out 0, al
out 0, al
out 0, al
    mov eax, 0x000010f6
    out 0, al
    shr eax, 8
    out 0, al
    shr eax, 8
    out 0, al
    shr eax, 8
    out 0, al

    mov eax, 10
    out 0, al

    hlt


bitch: ; __cdecl bitch(int n, int val)
    push ebp
    mov ebp, esp
    mov eax, [ebp+8] ; val
    mov edx, [ebp+12] ; n
l:
    test edx, edx
    jz fin
    out 0, al
    dec edx
    jmp l
fin:
    leave
    ret

bitch2: ; __cdecl bitch2(int n)
    push ebp
    mov ebp, esp
    mov edx, [ebp+8] ; n
l2:
    test edx, edx
    jz fin2
    in al, 1
    out 1, al
    dec edx
    jmp l2
fin2:
    leave
    ret

p: ; __cdecl p(char c)
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    mov ecx, eax
    and al, 0xf0
    shr eax, 4
    and cl, 0x0f
    add al, 0x61
    add cl, 0x61
    out 1, al
    mov al, cl
    out 1, al
    mov al, 0x20
    out 1, al
    leave
    ret

.data
cookie:
db 0, 0, 0, 0