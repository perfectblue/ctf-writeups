main:
	mov al, 200
	out 0, al
	mov edi, func
	mov edx, funcend
	sub edx, func
	mov ax, dx
	out 0, ax
	mov ecx, 0
.loop:
	mov al,[edi + ecx]
	out 0, al
	inc ecx
	cmp ecx, edx
	jb .loop

hlt

; bear chode
func:
	mov ecx, 0x04e601b0 ; exploit
	mov al, 0
	out 1, al
	mov eax, ecx
	out 1, eax
	mov al, 100
	out 1, al

	xor edx, edx
bearLoop:
	mov ecx, 0xf6eb ; jump back 16
	or ecx, edx
	add edx, 0x00010000
	
	mov al, 0
	out 1, al
	mov eax, ecx
	out 1, eax
	mov al, 100
	out 1, al

	cmp edx, 0x00160000
	jnz bearLoop

	mov ecx, 0x00008120 ; RIPPR
	mov al, 0
	out 1, al
	mov eax, ecx
	out 1, eax
	mov al, 100
	out 1, al

funcend:
