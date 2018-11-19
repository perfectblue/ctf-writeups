TERMINAL_INPUT = 0
TERMINAL_OUTPUT = 1
SECURE_PIN_STORAGE = 2
DOOR_CONTROL = 3

main:
	call __init

	push user_msg
	call puts
	push username
	call input

	push correct_pwd
	push username
	call get_secure_pin

	push hello_msg
	call puts
	push username
	call puts
	push hello_end_msg
	call puts

	push password
	call input

	push password
	push correct_pwd
	call verify
	test al, al
	jz .invalid

	call open_door
	jmp main

.invalid:
	push invalid
	call puts
	push 120
	call sleep
	jmp main


input:
	push ebp
	push esi
	mov ecx, [cookie]
	xor ecx, [esp + 8]
	push ecx
	mov ebp, esp
	sub esp, 36

	mov dword [ebp - 36], 0
	xor ecx, ecx
.clear_loop:
	mov byte [ebp - 32 + ecx], 0
	inc ecx
	cmp ecx, 32
	jb .clear_loop

.input_loop:
	in al, TERMINAL_INPUT
	cmp al, '\n'
	je .end_input
	cmp al, 8
	je .backspace

	mov ecx, [ebp - 36]
	mov [ebp - 32 + ecx], al
	inc dword [ebp - 36]
	out TERMINAL_OUTPUT, al
	jmp .input_loop

.backspace:
	cmp dword [ebp - 36], 0
	je .input_loop
	mov al, 8
	out TERMINAL_OUTPUT, al
	mov al, ' '
	out TERMINAL_OUTPUT, al
	mov al, 8
	out TERMINAL_OUTPUT, al
	dec dword [ebp - 36]
	jmp .input_loop

.end_input:
	out TERMINAL_OUTPUT, al

	lea eax, [ebp - 32]
	push eax
	push [ebp + 16]
	call strcpy

	mov esp, ebp
	pop ecx
	xor ecx, [esp + 8]
	cmp ecx, [cookie]
	jne __stack_chk_fail
	pop esi
	pop ebp
	ret


open_door:
	push ebp
	push esi
	mov ecx, [cookie]
	xor ecx, [esp + 8]
	push ecx
	mov ebp, esp

	mov al, 1
	out DOOR_CONTROL, al

	push open
	call puts
	push 120
	call sleep

	mov esp, ebp
	pop ecx
	xor ecx, [esp + 8]
	cmp ecx, [cookie]
	jne __stack_chk_fail
	pop esi
	pop ebp
	ret


get_secure_pin:
	push ebp
	push esi
	mov ecx, [cookie]
	xor ecx, [esp + 8]
	push ecx
	mov ebp, esp

	mov ecx, [ebp + 16]
.send_username_loop:
	mov al, [ecx]
	out SECURE_PIN_STORAGE, al
	inc ecx
	test al, al
	jnz .send_username_loop

	mov ecx, [ebp + 20]
.get_pin_loop:
	in al, SECURE_PIN_STORAGE
	mov [ecx], al
	inc ecx
	test al, al
	jnz .get_pin_loop

	mov esp, ebp
	pop ecx
	xor ecx, [esp + 8]
	cmp ecx, [cookie]
	jne __stack_chk_fail
	pop esi
	pop ebp
	ret 8


verify:
	push ebp
	push esi
	push edi
	mov ecx, [cookie]
	xor ecx, [esp + 12]
	push ecx
	mov ebp, esp

	mov esi, [ebp + 20]
	mov edi, [ebp + 24]
.loop:
	mov al, [esi]
	cmp al, [edi]
	jne .mismatch
	test al, al
	je .match
	inc esi
	inc edi
	jmp .loop

.mismatch:
	xor al, al
	jmp .done

.match:
	mov al, 1

.done:
	mov esp, ebp
	pop ecx
	xor ecx, [esp + 12]
	cmp ecx, [cookie]
	jne __stack_chk_fail
	pop edi
	pop esi
	pop ebp
	ret 8


sleep:
	push ebp
	mov ecx, [cookie]
	xor ecx, [esp + 4]
	push ecx
	mov ebp, esp

	mov ecx, [ebp + 12]
.sleep_loop:
	pause
	loop .sleep_loop

	mov esp, ebp
	pop ecx
	xor ecx, [esp + 4]
	cmp ecx, [cookie]
	jne __stack_chk_fail
	pop ebp
	ret 4


puts:
	push ebp
	push esi
	mov ecx, [cookie]
	xor ecx, [esp + 8]
	push ecx
	mov ebp, esp

	mov esi, [ebp + 16]
.outloop:
	lodsb
	test al, al
	jz .end
	out TERMINAL_OUTPUT, al
	jmp .outloop
.end:

	mov esp, ebp
	pop ecx
	xor ecx, [esp + 8]
	cmp ecx, [cookie]
	jne __stack_chk_fail
	pop esi
	pop ebp
	ret 4


strcpy:
	push ebp
	push esi
	push edi
	mov ecx, [cookie]
	xor ecx, [esp + 12]
	push ecx
	mov ebp, esp

	mov edi, [ebp + 20]
	mov esi, [ebp + 24]
.copy:
	mov al, [esi]
	mov [edi], al
	test al, al
	jz .end
	inc esi
	inc edi
	jmp .copy
.end:

	pop ecx
	xor ecx, [esp + 12]
	cmp ecx, [cookie]
	jne __stack_chk_fail
	pop edi
	pop esi
	pop ebp
	ret 8


__init:
	mov eax, SYS_RAND
	int 0x80
	mov [cookie], eax
	ret


__stack_chk_fail:
	push stack_corrupt
	call puts
	int3


user_msg:
	db "\fMT. CHAR RESEARCH AREA\n"
	db "This area is restricted. Please\n"
	db "provide your access code.\n\n"
	db "Username:\n", 0

hello_msg:
	db "\fHello, ", 0
hello_end_msg:
	db ".\nYour account requires a password.\n"
	db "Please enter your password now:\n", 0

stack_corrupt:
	db "\nINTERNAL ERROR\n"
	db "State corrupted. Please restart\n"
	db "the system.\n", 0

open:
	db "\nACCESS GRANTED"
end_open:

invalid:
	db "\nACCESS DENIED"
end_invalid:


.data
cookie:
	dd 0

correct_pwd:
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0

username:
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0

password:
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0
