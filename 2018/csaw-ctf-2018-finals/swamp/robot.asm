;flag{Blown_Away_By_Your_Amazing_Shellcode}
; no nullbytes; <0x40 bytes total
INPUT = 0

main:
  mov esi, 0
.loop:
  mov ebx, func
  add ebx, esi
  xor eax, eax
  mov al, [ebx]
  out INPUT, al
  mov edx, func_end
  sub edx, func
  inc esi
  cmp esi, edx 
  jne .loop
  mov al, 0
  out INPUT, al
  hlt
func:
.robot_loop:
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
      mov al, SYS_SCAN_AREA
    mov bx, 1000
    mov cx, 0x8033
    xor edx, edx
    mov dl, 12
    int 0x80
    mov al, SYS_WALK
    xor edi, edi
    mov di, 0x8033
    mov ebx, [edi]
    add edi, 0x4
    mov ecx, [edi]
    add edi, 0x4
    mov edx, [edi]
    cmp edx, SCAN_PLAYER
    jne .normal
    int 0x80
.normal:
  jmp .robot_loop

scan_results:
dd -1, -1, -1

func_end: