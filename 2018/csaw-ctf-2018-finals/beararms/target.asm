STDIN_PORT = 0
STDOUT_PORT = 1
BEAR_RESPONSE_PORT = 2
BEAR_CMD_PORT = 3
SECURE_AREA_DOOR_PORT = 4

CMD_STOP = 100
CMD_PASSIVE = 101
CMD_AGGRESSIVE = 102
CMD_FURMWARE_UPDATE = 200

REPORT_ALIVE = 0
REPORT_SPOTTED = 1

REFRESH_TIME = 300
TIME_UNTIL_DECLARED_DEAD = 240
REFRESHES_UNTIL_REMOVE = 6
REFRESHES_UNTIL_NOT_SPOTTED = 4

BEAR_STATUS_SPOT_TIME = 4
BEAR_STATUS_DEAD = 5
BEAR_STATUS_ORDERS = 6
BEAR_STATUS_UPDATE_TIME = 7

BEAR_REACTIVATE_TIME = 480

main:
	mov dword [bear_display_func], spotted_foe_status

.loop:
	pause

	call check_for_reports
	call check_for_input
	call check_for_reactivation
	call update_status

	cmp dword [refresh_time], 0
	jnz .no_refresh

	call update_refresh_status
	call refresh_display
	mov dword [refresh_time], REFRESH_TIME

.no_refresh:
	dec dword [refresh_time]
	jmp .loop


refresh_display:
	push ebx
	push esi
	push edi

	push header_string
	call puts

	xor ebx, ebx
	xor esi, esi
	xor edi, edi

.status_loop:
	mov eax, [bear_status + ebx * 8]
	test eax, eax
	jz .to_bottom_loop

	push eax
	call print_id
	mov al, ' '
	out STDOUT_PORT, al
	lea eax, [bear_status + ebx * 8]
	push eax
	call [bear_display_func]
	mov al, ' '
	out STDOUT_PORT, al
	out STDOUT_PORT, al

	cmp esi, 2
	je .end_of_row

	inc esi
	jmp .next

.end_of_row:
	mov al, '\n'
	out STDOUT_PORT, al
	xor esi, esi
	inc edi

.next:
	inc ebx
	jmp .status_loop

.to_bottom_loop:
	cmp edi, 9
	jge .footer
	mov al, '\n'
	out STDOUT_PORT, al
	inc edi
	jmp .to_bottom_loop

.footer:
	push footer_string
	call puts

.done:
	pop edi
	pop esi
	pop ebx
	ret


spotted_foe_status:
	mov eax, [esp + 4]
	cmp byte [eax + BEAR_STATUS_DEAD], 0
	jne .dead

	cmp byte [eax + BEAR_STATUS_SPOT_TIME], 0
	jne .spotted

	mov al, ' '
	out STDOUT_PORT, al
	ret 4

.dead:
	mov al, 'x'
	out STDOUT_PORT, al
	ret 4

.spotted:
	mov al, '!'
	out STDOUT_PORT, al
	ret 4


order_status:
	mov eax, [esp + 4]
	cmp byte [eax + BEAR_STATUS_DEAD], 0
	jne .dead

	mov al, [eax + BEAR_STATUS_ORDERS]
	sub al, 100 - '0'
	out STDOUT_PORT, al
	ret 4

.dead:
	mov al, 'x'
	out STDOUT_PORT, al
	ret 4


check_for_reports:
	push ebx

	mov eax, SYS_CAN_READ
	mov ebx, BEAR_RESPONSE_PORT
	mov ecx, 1
	int 0x80
	test eax, eax
	jz .done

	in al, BEAR_RESPONSE_PORT
	cmp al, REPORT_ALIVE
	je .alive
	cmp al, REPORT_SPOTTED
	je .spotted
	jmp .done

.alive:
	in eax, BEAR_RESPONSE_PORT
	mov ecx, eax
	in al, BEAR_RESPONSE_PORT
	movzx eax, al
	push eax ; orders
	push ecx ; id
	call mark_bear_alive
	jmp .done

.spotted:
	in eax, BEAR_RESPONSE_PORT
	push eax
	call mark_bear_spotted_foe

.done:
	pop ebx
	ret


mark_bear_alive:
	xor ecx, ecx
.find_existing:
	mov eax, [bear_status + ecx * 8]
	test eax, eax
	jz .not_found
	cmp eax, [esp + 4]
	je .found
	inc ecx
	jmp .find_existing

.found:
	mov al, [esp + 8]
	mov [bear_status + ecx * 8 + BEAR_STATUS_ORDERS], al
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_UPDATE_TIME], TIME_UNTIL_DECLARED_DEAD
	jmp .done

.not_found:
	; Place new bear at end of list
	mov eax, [esp + 4]
	mov [bear_status + ecx * 8], eax
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_SPOT_TIME], 0
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_UPDATE_TIME], TIME_UNTIL_DECLARED_DEAD
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_DEAD], 0
	mov al, [esp + 8]
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_ORDERS], al
	mov dword [bear_status + ecx * 8 + 8], 0

.done:
	ret 8


mark_bear_spotted_foe:
	xor ecx, ecx
.find_existing:
	mov eax, [bear_status + ecx * 8]
	test eax, eax
	jz .done
	cmp eax, [esp + 4]
	je .found
	inc ecx
	jmp .find_existing

.found:
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_SPOT_TIME], REFRESHES_UNTIL_NOT_SPOTTED
	jmp .done

.done:
	ret 4


update_status:
	xor ecx, ecx
.loop:
	mov eax, [bear_status + ecx * 8]
	test eax, eax
	jz .done

	cmp byte [bear_status + ecx * 8 + BEAR_STATUS_DEAD], 0
	jne .next

	cmp byte [bear_status + ecx * 8 + BEAR_STATUS_UPDATE_TIME], 0
	je .declare_dead
	dec byte [bear_status + ecx * 8 + BEAR_STATUS_UPDATE_TIME]
	jmp .next

.declare_dead:
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_DEAD], 1
	mov byte [bear_status + ecx * 8 + BEAR_STATUS_UPDATE_TIME], REFRESHES_UNTIL_REMOVE

.next:
	inc ecx
	jmp .loop

.done:
	ret


update_refresh_status:
	xor ecx, ecx
.loop:
	mov eax, [bear_status + ecx * 8]
	test eax, eax
	jz .done

	cmp byte [bear_status + ecx * 8 + BEAR_STATUS_DEAD], 0
	jne .dead

	cmp byte [bear_status + ecx * 8 + BEAR_STATUS_SPOT_TIME], 0
	je .next
	dec byte [bear_status + ecx * 8 + BEAR_STATUS_SPOT_TIME]
	jmp .next

.dead:
	cmp byte [bear_status + ecx * 8 + BEAR_STATUS_UPDATE_TIME], 0
	je .remove
	dec byte [bear_status + ecx * 8 + BEAR_STATUS_UPDATE_TIME]
	jmp .next

.remove:
	mov edx, ecx
.remove_loop:
	mov eax, [bear_status + edx * 8 + 12]
	mov [bear_status + edx * 8 + 4], eax
	mov eax, [bear_status + edx * 8 + 8]
	mov [bear_status + edx * 8], eax
	test eax, eax
	jz .loop
	inc edx
	jmp .remove_loop

.next:
	inc ecx
	jmp .loop

.done:
	ret


check_for_input:
	push ebx

	mov eax, SYS_CAN_READ
	mov ebx, STDIN_PORT
	mov ecx, 1
	int 0x80
	test eax, eax
	jz .done

	in al, STDIN_PORT
	cmp al, 's'
	je .spot_mode
	cmp al, 'o'
	je .order_mode
	cmp al, '0'
	je .stop
	cmp al, '1'
	je .passive
	cmp al, '2'
	je .aggressive
;	cmp al, 'd'
;	je .open_door
	jmp .done

.spot_mode:
	mov dword [bear_display_func], spotted_foe_status
	mov dword [refresh_time], 0
	jmp .done

.order_mode:
	mov dword [bear_display_func], order_status
	mov dword [refresh_time], 0
	jmp .done

.stop:
	mov al, CMD_STOP
	out BEAR_CMD_PORT, al
	mov eax, 0xffffffff
	out BEAR_CMD_PORT, eax
	mov dword [reactivate_time], BEAR_REACTIVATE_TIME
	jmp .done

.passive:
	mov al, CMD_PASSIVE
	out BEAR_CMD_PORT, al
	mov eax, 0xffffffff
	out BEAR_CMD_PORT, eax
	mov dword [reactivate_time], BEAR_REACTIVATE_TIME
	jmp .done

.aggressive:
	mov al, CMD_AGGRESSIVE
	out BEAR_CMD_PORT, al
	mov eax, 0xffffffff
	out BEAR_CMD_PORT, eax
	jmp .done

; By orders of the boss: Secure area to be
; manually opened only until further notice
;.open_door:
;	mov al, 1
;	out SECURE_AREA_DOOR_PORT, al
;	jmp .done

.done:
	pop ebx
	ret


check_for_reactivation:
	dec dword [reactivate_time]
	cmp dword [reactivate_time], 0
	jne .done
	mov al, CMD_AGGRESSIVE
	out BEAR_CMD_PORT, al
	mov eax, 0xffffffff
	out BEAR_CMD_PORT, eax
.done:
	ret


puts:
	push esi
	mov esi, [esp + 8]
.loop:
	lodsb
	test al, al
	je .end
	out STDOUT_PORT, al
	jmp .loop
.end:
	pop esi
	ret 4


print_id:
	mov edx, [esp + 4]
	mov ecx, 28
.loop:
	mov eax, edx
	shr eax, cl
	and eax, 0xf
	mov al, [hex_chars + eax]
	out STDOUT_PORT, al
	test ecx, ecx
	jz .done
	sub ecx, 4
	jmp .loop
.done:
	ret 4


hex_chars:
	db "0123456789ABCDEF"

header_string:
	db "\fBear Army Command\n"
	db "BEAR STATUS REPORTS:\n", 0

footer_string:
	db "(S)pot (O)rders (0)Stop (1)Pasv (2)Aggr", 0


.data
bear_status:
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0
dd 0, 0, 0, 0, 0, 0, 0, 0

bear_display_func:
dd 0

reactivate_time:
dd 0

refresh_time:
dd 0
