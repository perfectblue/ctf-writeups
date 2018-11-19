%define CMD_STOP 100
%define CMD_PASSIVE 101
%define CMD_AGGRESSIVE 102
%define CMD_FURMWARE_UPDATE 200

%define REPORT_ALIVE 0
%define REPORT_SPOTTED 1

%define IN_PORT 0
%define OUT_PORT 1

%define MIN_WAIT_TIME 30
%define MAX_WAIT_TIME 180
%define MIN_WALK_TIME 60
%define MAX_WALK_TIME 240
%define SCAN_DISTANCE 120
%define ATTACK_TIME 180

%define SYS_RAND 69
%define SCAN_PLAYER 70
%define SYS_WALK 71
%define SYS_ATTACK 72
%define SYS_WRITE 73
%define SYS_CAN_READ 74
%define SYS_READ 75
%define SYS_ROM_UPDATE 76
%define SYS_SCAN_AREA 77

main:
	mov eax, SYS_RAND
	int 0x80
	mov [id], eax

	; Randomize keep alive timing
	and eax, 63
	mov dword [keep_alive_time], eax

	mov byte [mode], CMD_AGGRESSIVE

.waiting:
	; Decide how long to wait here
	push MAX_WAIT_TIME
	push MIN_WAIT_TIME
	call rand_int
	mov esi, eax

.wait_loop:
	pause

	cmp byte [mode], CMD_STOP
	je .stop
	call process_commands

	call look_for_player
	test eax, eax
	jnz .wait_loop

	; Stop moving and wait
	mov eax, SYS_WALK
	xor ebx, ebx
	xor ecx, ecx
	int 0x80

	dec esi
	jnz .wait_loop

.wander:
	; Pick a random direction
	push 4
	push 0
	call rand_int
	; Walk in that direction
	mov ebx, [directions + eax * 8]
	mov ecx, [directions + eax * 8 + 4]
	mov eax, SYS_WALK
	int 0x80

	; Pick a random amount of time to walk
	push MAX_WALK_TIME
	push MIN_WALK_TIME
	call rand_int
	mov esi, eax

.walk_loop:
	pause

	cmp byte [mode], CMD_STOP
	je .stop
	call process_commands

	call look_for_player
	test eax, eax
	jnz .waiting
	dec esi
	jnz .walk_loop

	jmp .waiting

.stop:
	mov eax, SYS_WALK
	xor ebx, ebx
	xor ecx, ecx
	int 0x80
	pause
	call process_commands
	cmp byte [mode], CMD_STOP
	jne .waiting
	jmp .stop


look_for_player:
	push ebx

	; If not in aggressive mode, stop now
	cmp byte [mode], CMD_AGGRESSIVE
	jne .player_not_found

	; Scan area
	mov eax, SYS_SCAN_AREA
	mov ebx, SCAN_DISTANCE
	mov ecx, scan_results
	mov edx, end_scan - scan_results
	int 0x80

	mov ecx, 0
.scan_loop:
	cmp ecx, eax
	jge .player_not_found
	imul edx, ecx, 12
	cmp dword [scan_results + edx + 8], SCAN_PLAYER
	jne .next

	; Found the player, walk there
	mov eax, SYS_WALK
	mov ebx, [scan_results + edx]
	mov ecx, [scan_results + edx + 4]
	int 0x80

	; Send spotted report to controller on alive interval
	cmp dword [keep_alive_time], 0
	jnz .check_for_fire
	mov byte [report_buffer], REPORT_SPOTTED
	mov eax, [id]
	mov [report_buffer + 1], eax
	mov eax, SYS_WRITE
	mov ebx, OUT_PORT
	mov ecx, report_buffer
	mov edx, 5
	int 0x80

.check_for_fire:
	; Check for firing cannon
	cmp dword [time_until_attack], 0
	je .attack

	dec dword [time_until_attack]
	mov eax, 1
	jmp .done

.attack:
	mov eax, SYS_ATTACK
	int 0x80
	mov dword [time_until_attack], ATTACK_TIME
	mov eax, 1
	jmp .done

.next:
	inc ecx
	jmp .scan_loop

.player_not_found:
	xor eax, eax

.done:
	pop ebx
	ret


rand_int:
%define .min 4
%define .max 8
	mov ecx, [esp + .max]
	sub ecx, [esp + .min]
	mov eax, SYS_RAND
	int 0x80
	xor edx, edx
	div ecx
	add edx, [esp + .min]
	xchg eax, edx
	ret 8


process_commands:
	push ebx

	; Check if time for alive report
	cmp dword [keep_alive_time], 0
	jnz .check_for_command

	; Send alive report to controller
	mov byte [report_buffer], REPORT_ALIVE
	mov eax, [id]
	mov [report_buffer + 1], eax
	mov al, [mode]
	mov [report_buffer + 5], al
	mov eax, SYS_WRITE
	mov ebx, OUT_PORT
	mov ecx, report_buffer
	mov edx, 6
	int 0x80

	mov dword [keep_alive_time], 120

.check_for_command:
	dec dword [keep_alive_time]

	; See if a command byte is available
	mov eax, SYS_CAN_READ
	mov ebx, IN_PORT
	mov ecx, 1
	int 0x80
	test eax, eax
	jz .done

	; Grab the command byte
	in al, IN_PORT
	mov cl, al
	cmp al, CMD_FURMWARE_UPDATE
	je .update

	; Grab the target id
	in eax, IN_PORT
	; Check for broadcast
	cmp eax, 0xffffffff
	je .do_command
	cmp eax, [id]
	jne .done

.do_command:
	mov byte [mode], cl
	jmp .done

.update:
	in ax, IN_PORT
	movzx edx, ax
	mov eax, SYS_READ
	mov ebx, 0
	mov ecx, update_buffer
	int 0x80
	mov eax, SYS_ROM_UPDATE
	mov ebx, ecx
	mov ecx, edx
	int 0x80

.done:
	pop ebx
	ret


directions:
dd 1, 0
dd -1, 0
dd 0, 1
dd 0, -1


section .data
id:
dd 0

scan_results:
dd 0, 0, 0
dd 0, 0, 0
dd 0, 0, 0
dd 0, 0, 0
dd 0, 0, 0
dd 0, 0, 0
dd 0, 0, 0
dd 0, 0, 0
end_scan:

time_until_attack:
dd 0
keep_alive_time:
dd 0

report_buffer:
db 0
dd 0
db 0

mode:
db 0

update_buffer:
