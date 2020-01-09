%define TERMINAL_INPUT 0
%define TERMINAL_OUTPUT 1
%define FACTORY_CONTROL 2
%define SYS_RAND 6
%define SYS_UNMAP_ROM 7
%define LOG_OUTPUT 3

__start:
	jmp __init

main:
	push ebp
	push ebx
	mov ecx, [__cookie]
	xor ecx, [esp + 8]
	push ecx
	mov ebp, esp
	sub esp, 32

	call __get_base
.rel_base:
	lea ebx, [ebx + __base - .rel_base]

.new:
	lea eax, [header + ebx - __base]
	push eax
	call puts

.order:
	in al, TERMINAL_INPUT
	cmp al, 'r'
	je .random
	cmp al, 'R'
	je .random
	cmp al, 'a'
	jb .order
	cmp al, 'p'
	ja .order
	sub al, 'a'
	jmp .specific

.specific:
	mov byte [random_robot], 0
	mov [robot_type], al

	lea eax, [selected_msg + ebx - __base]
	push eax
	call puts

	movzx eax, byte [robot_type]
	lea ecx, [factory_item_table + ebx - __base]
	mov eax, [ecx + eax * 4]
	add eax, ecx
	push eax
	call puts

	jmp .select_quantity

.random:
	mov byte [random_robot], 1

	lea eax, [random_msg + ebx - __base]
	push eax
	call puts

.select_quantity:
	lea eax, [quantity_msg + ebx - __base]
	push eax
	call puts

.quantity:
	in al, TERMINAL_INPUT
	cmp al, '1'
	jb .quantity
	cmp al, '8'
	ja .quantity
	sub al, '0'
	mov [robot_quantity], al

	lea eax, [name_msg + ebx - __base]
	push eax
	call puts

	lea eax, [ebp - 32]
	push eax
	call input

	mov al, [robot_type]
	out LOG_OUTPUT, al
	mov al, [robot_quantity]
	out LOG_OUTPUT, al
	lea ecx, [ebp - 32]
.log_name:
	mov al, [ecx]
	out LOG_OUTPUT, al
	inc ecx
	test al, al
	jnz .log_name

	cmp byte [random_robot], 0
	jne .create_random

	mov al, [robot_type]
	xor ecx, ecx
.create_specific_robot:
	mov [robot_array + ecx], al
	inc ecx
	cmp cl, [robot_quantity]
	jb .create_specific_robot
	mov byte [robot_array + ecx], 0xff
	jmp .manufacture

.create_random:
	call rand
	xor ecx, ecx
.random_loop:
	mov dl, al
	and dl, 0xf
	mov [robot_array + ecx], dl
	shr eax, 4
	inc ecx
	cmp cl, [robot_quantity]
	jb .random_loop
	mov byte [robot_array + ecx], 0xff

.manufacture:
	mov esi, robot_array
.manufacture_loop:
	mov al, [esi]
	out FACTORY_CONTROL, al
	inc esi
	cmp al, 0xff
	jne .manufacture_loop

.inspect_loop:
	lea eax, [wait_msg + ebx - __base]
	push eax
	call puts

	in al, FACTORY_CONTROL
	movzx esi, al

	lea eax, [inspect_msg + ebx - __base]
	push eax
	call puts

	in al, TERMINAL_INPUT

	mov al, 0xff
	out FACTORY_CONTROL, al

	test esi, esi
	jne .inspect_loop

	lea eax, [end_msg + ebx - __base]
	push eax
	call puts

	in al, FACTORY_CONTROL
	jmp .new


input:
	push ebp
	push esi
	mov ecx, [__cookie]
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
	cmp al, `\n`
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

	mov ecx, [ebp - 36]
	mov byte [ebp - 32 + ecx], 0

	lea eax, [ebp - 32]
	push eax
	push dword [ebp + 16]
	call strcpy

	mov esp, ebp
	pop ecx
	xor ecx, [esp + 8]
	cmp ecx, [__cookie]
	jne __stack_chk_fail
	pop esi
	pop ebp
	ret 4


sleep:
	push ebp
	mov ecx, [__cookie]
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
	cmp ecx, [__cookie]
	jne __stack_chk_fail
	pop ebp
	ret 4


rand:
	push ebp
	mov ecx, [__cookie]
	xor ecx, [esp + 4]
	push ecx
	mov ebp, esp

	mov eax, [__seed]
	imul eax, eax, 1664525
	add eax, 1013904223
	mov [__seed], eax

	mov esp, ebp
	pop ecx
	xor ecx, [esp + 4]
	cmp ecx, [__cookie]
	jne __stack_chk_fail
	pop ebp
	ret


puts:
	push ebp
	push esi
	mov ecx, [__cookie]
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
	cmp ecx, [__cookie]
	jne __stack_chk_fail
	pop esi
	pop ebp
	ret 4


strcpy:
	push ebp
	push esi
	push edi
	mov ecx, [__cookie]
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
	cmp ecx, [__cookie]
	jne __stack_chk_fail
	pop edi
	pop esi
	pop ebp
	ret 8


__init:
	mov eax, SYS_RAND
	int 0x80
	mov [__seed], eax

	call rand
	mov [__cookie], eax

	call rand
	and eax, 0xfff
	add eax, __aslr_region
	mov ebx, eax
	mov esi, 0x1000
	mov edi, eax
	mov ecx, 0x1000
	rep movsb

	mov eax, .ram
	sub eax, 0x1000
	add eax, ebx
	jmp eax
.ram:
	mov eax, SYS_UNMAP_ROM
	int 0x80
	call main
	int3


__stack_chk_fail:
	call __get_base
.rel_base:
	lea ebx, [ebx + __base - .rel_base]
	lea eax, [__stack_corrupt + ebx - __base]
	push eax
	call puts
	int3


__get_base:
	mov ebx, [esp]
	ret

__base:

header:
	db `\fRobot Factory Control\n\n`
	db `Enter order:\n`
	db `A) Robot 1   B) Robot 2   C) Robot 3\n`
	db `D) Robot 4   E) Robot 5   F) Robot 6\n`
	db `G) Robot 7   H) Robot 8   I) Robot 9\n`
	db `J) Robot 10  K) Robot 11  L) Robot 12\n`
	db `M) Robot 13  N) Robot 14  O) Robot 15\n`
	db `P) Robot 16  R) Random\n`, 0

selected_msg:
	db "\nCreating ", 0

random_msg:
	db "\nCreating random robots", 0

quantity_msg:
	db "\n\nQuantity (1-8):\n", 0

name_msg:
	db "\nQA employee name:\n", 0

wait_msg:
	db "\fWaiting for factory output to reach\n"
	db "inspection station...", 0

inspect_msg:
	db "\fFactory output has reached the\n"
	db "inspection station.\n\n"
	db "Please inspect the factory output\n"
	db "for flaws. If you see any, please\n"
	db "log the issue in the logbook along\n"
	db "with the serial number.\n\n"
	db "Press any key once complete.\n", 0

end_msg:
	db "\fProduction is complete. Waiting for\n"
	db "the factory output to proceed into the\n"
	db "storage area...", 0

factory_item_table:
	dd robot_1 - factory_item_table
	dd robot_2 - factory_item_table
	dd robot_3 - factory_item_table
	dd robot_4 - factory_item_table
	dd robot_5 - factory_item_table
	dd robot_6 - factory_item_table
	dd robot_7 - factory_item_table
	dd robot_8 - factory_item_table
	dd robot_9 - factory_item_table
	dd robot_10 - factory_item_table
	dd robot_11 - factory_item_table
	dd robot_12 - factory_item_table
	dd robot_13 - factory_item_table
	dd robot_14 - factory_item_table
	dd robot_15 - factory_item_table
	dd robot_16 - factory_item_table
	dd key - factory_item_table
	dd rod - factory_item_table

robot_1:
	db "Robot 1", 0
robot_2:
	db "Robot 2", 0
robot_3:
	db "Robot 3", 0
robot_4:
	db "Robot 4", 0
robot_5:
	db "Robot 5", 0
robot_6:
	db "Robot 6", 0
robot_7:
	db "Robot 7", 0
robot_8:
	db "Robot 8", 0
robot_9:
	db "Robot 9", 0
robot_10:
	db "Robot 10", 0
robot_11:
	db "Robot 11", 0
robot_12:
	db "Robot 12", 0
robot_13:
	db "Robot 13", 0
robot_14:
	db "Robot 14", 0
robot_15:
	db "Robot 15", 0
robot_16:
	db "Robot 16", 0
key:
	db "Overlord Domain Key", 0
rod:
	db "Nature's Wrath", 0

__stack_corrupt:
	db "\nINTERNAL ERROR\n"
	db "State corrupted. Please restart\n"
	db "the system.\n", 0

__end_code:


.data
random_robot:
	db 0
robot_type:
	db 0
robot_quantity:
	db 0
robot_array:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0

__seed:
	dd 0
__cookie:
	dd 0

__aslr_region:
