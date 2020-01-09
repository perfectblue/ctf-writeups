TERMINAL_INPUT = 0
TERMINAL_OUTPUT = 1
DOOR_CONTROL = 2

main:
.correct_pin = 0

.main_loop:
	call ask_and_verify_code
	test al, al
	jz .invalid

	call open_door
	jmp .main_loop

.invalid:
	; Show denied message
	mov esi, invalid
	mov ecx, end_invalid - invalid
	mov dx, TERMINAL_OUTPUT
	rep outsb

	call sleep
	jmp .main_loop


ask_and_verify_code:
; Variables
.input = -32
.len = -36

	push esi
	push edi
	push ebp
	mov ebp, esp
	sub esp, 36

	mov dword [ebp + .len], 0

	; Display initial message
	mov esi, message
	mov ecx, end_message - message
	mov dx, TERMINAL_OUTPUT
	rep outsb

.input_loop:
	; Grab next input
	in al, TERMINAL_INPUT

	; If enter is pressed, done
	cmp al, '\n'
	je .end_input

	; Look for backspace
	cmp al, 8
	je .backspace

	; Printable only
	cmp al, ' '
	jb .input_loop
	cmp al, '~'
	ja .input_loop

	; Add character to input
	mov ecx, [ebp + .len]
	cmp ecx, 31
	jae .input_loop

	mov [ebp + .input + ecx], al
	inc dword [ebp + .len]
	out TERMINAL_OUTPUT, al
	jmp .input_loop

.backspace:
	cmp dword [ebp + .len], 0
	je .input_loop

	; Erase last character
	mov al, 8
	out TERMINAL_OUTPUT, al
	mov al, ' '
	out TERMINAL_OUTPUT, al
	mov al, 8
	out TERMINAL_OUTPUT, al

	dec dword [ebp + .len]
	jmp .input_loop

.end_input:
	out TERMINAL_OUTPUT, al

	; Null terminate input
	mov ecx, [ebp + .len]
	mov byte [ebp + .input + ecx], 0

	; Check code
	lea eax, [ebp + .input]
	push eax
	call verify_code

	mov esp, ebp
	pop ebp
	pop edi
	pop esi
	ret


verify_code:
	push esi
	push ebp
	mov ebp, esp
	sub esp, 8

	push dword [ebp + 12]
	call strlen
	cmp eax, 16
	jne .bad

	mov esi, [ebp + 12]
	lea edx, [ebp - 8]
	mov ecx, 8
.loop1:
	mov al, [esi]
	xor al, [esi + 8]
	mov [edx], al
	inc esi
	inc edx
	loop .loop1

	lea esi, [ebp - 8]
	mov edx, valid
	mov ecx, 8
.check:
	mov al, [esi]
	cmp al, [edx]
	jne .bad
	inc esi
	inc edx
	loop .check

	mov al, 1
	mov esp, ebp
	pop ebp
	pop esi
	ret 4

.bad:
	xor al, al
	mov esp, ebp
	pop ebp
	pop esi
	ret 4


strlen:
	xor eax, eax
	mov ecx, [esp + 4]
.loop:
	mov dl, [ecx]
	test dl, dl
	jz .end
	inc eax
	inc ecx
	jmp .loop
.end:
	ret 4


open_door:
	push esi

	; Send command to unlock door
	mov al, 1
	out DOOR_CONTROL, al

	; Show open message
	mov esi, open
	mov ecx, end_open - open
	mov dx, TERMINAL_OUTPUT
	rep outsb

	call sleep

	pop esi
	ret


sleep:
	mov ecx, 120
.sleep_loop:
	pause
	loop .sleep_loop
	ret


valid:
	db 0x09, 0x23, 0x06, 0x07, 0x36, 0x38, 0x22, 0x2c

message:
	db "\fCLEARENCE LEVEL 1 REQUIRED\nAuthorization code:\n"
end_message:

open:
	db "ACCESS GRANTED"
end_open:

invalid:
	db "ACCESS DENIED"
end_invalid:
