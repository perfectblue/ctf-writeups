mov edi, eax
call srand
mov dword [rbp-0x4 {var_c}], 0x0
jmp loc_000cc2

loc_000c4c:
call rand
mov ecx, eax ; ecx = eax = rand()
mov edx, 0x66666667 ; edx = 0x66666667
mov eax, ecx ; gcc sucks
imul edx ; edx:eax = rand() * 0x66666667
sar edx, 0x1 ; edx = rand() / 5
mov eax, ecx ; eax = ecx = rand()
sar eax, 0x1f ; sign bit nonsense
sub edx, eax ; signed nonsense
mov eax, edx ; eax = edx
mov edx, eax ; 
shl edx, 0x2 ; edx = edx * 5
add edx, eax ;
mov eax, ecx ; 
sub eax, edx ; eax = rand() % 5
test eax, eax ; jump if less than zero; i.e. sign bit is 1
jle loc_000cbe

call rand
mov ecx, eax
mov edx, 0x4ec4ec4f
mov eax, ecx
imul edx
sar edx, 0x3 ; edx = rand() / 26
mov eax, ecx ; ecx = rand()
sar eax, 0x1f ; sign nonsense
sub edx, eax ; sign nonsense
mov eax, edx
imul eax, eax, 0x1a ; edx = (rand() / 26) * 26
sub ecx, eax ; ecx = rand()
mov eax, ecx ; eax = rand() - (rand() / 26) * 26 = rand() % 26
add eax, 0x61 ; 'a'
mov ecx, eax ; ecx = rand() % 26
mov eax, dwrd [rbp-0x4 {var_c}]
movsxd rdx, eas
mov rax, rdx
shl rax, 0x2
add rax, rdx
add rax, rax
mov rdx, rax ; rax = counter * 10
lea rax, [rel numbers] {"zero"}
mov byte [rdx+rax], cl ; numbers[10 * counter] = rand() % 26

loc_000cbe
add dword [rbp-0x4 {var_c}], 0x1 ; counter++

cmp dword [rbp-0x4 {var_c}], 0x13 ; < 20
jle loc_000c4c