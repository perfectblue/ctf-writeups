%define MSG     	xmm0
%define STATE0  	xmm1
%define STATE1  	xmm2
%define MSGTMP0 	xmm3
%define MSGTMP1 	xmm4
%define MSGTMP2 	xmm5
%define MSGTMP3 	xmm6
%define MSGTMP4 	xmm7

%define SHUF_MASK       xmm8

%define ABEF_SAVE       xmm9
%define CDGH_SAVE       xmm10

%define ISTATE  rdi
%define IMSG    rsi
%define OSTATE  rdx
%define TIME    rcx

%define IDX     r8      ; local variable -- consistent with caller
%define DPTR    r11     ; local variable -- input buffer pointer
%define TMP     r9      ; local variable -- assistant to address digest
%define TBL     rax

global _start

section .text
_start:
    jmp print_random ; 5byte
    
data: incbin 'data.bin'

print_random:
    mov rax, 0x01
    mov rdi, 0x01
    mov rsi, data
    mov rdx, 0xC00
    syscall

    mov rax, 0x2
    mov rdi, tmp
    mov rsi, 0x641
    mov rdx, 0
    syscall

    mov rdi, rax
    mov rax, 0x3
    syscall

    mov rax, 0x3c
    mov rdi, 0x00
    syscall

    mov rax, padding
    mov byte [rax + 0x00], 0x80
    mov dword [rax + 0x1c], 0x009f0000

    xor rbx, rbx
    sub rsp, 0x40

hash_loop:
    lea ISTATE, [8*rbx]
    lea ISTATE, [4*ISTATE]
    add ISTATE, states
    mov IMSG, print_random
    mov OSTATE, rsp
    mov TIME, 29

    call sha256

    mov rax, 0x01
    mov rdi, 0x00
    mov rsi, rsp
    mov rdx, 0x20
    syscall

    inc rbx
    cmp rbx, 0x10
    jl  hash_loop

    mov rax, 0x3c
    mov rdi, 0x00
    syscall

tmp:
    db 0x2f, 0x74, 0x6d, 0x70, 0x2f, 0x77, 0x6f, 0x77, 0x00

states: incbin 'states.bin'

sha256:
    mov DPTR, IMSG

    pinsrd STATE0, [ISTATE + 0x00], 3 ; A
    pinsrd STATE0, [ISTATE + 0x04], 2 ; B
    pinsrd STATE1, [ISTATE + 0x08], 3 ; C
    pinsrd STATE1, [ISTATE + 0x0C], 2 ; D
    pinsrd STATE0, [ISTATE + 0x10], 1 ; E
    pinsrd STATE0, [ISTATE + 0x14], 0 ; F
    pinsrd STATE1, [ISTATE + 0x18], 1 ; G
    pinsrd STATE1, [ISTATE + 0x1C], 0 ; H

    movdqa  SHUF_MASK, [PSHUFFLE_SHANI_MASK]
	lea     TBL, [TABLE]

sha256_loop_big:
    ; /* Save hash values for addition after rounds */
	movdqa  	ABEF_SAVE, STATE0
	movdqa  	CDGH_SAVE, STATE1

	; /* Rounds 0-3 */
	movdqu  	MSG, [DPTR + 0*16]
	pshufb  	MSG, SHUF_MASK
	movdqa  	MSGTMP0, MSG
		paddd   	MSG, [TBL + 0*16]
		sha256rnds2     STATE1, STATE0, MSG
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG

	; /* Rounds 4-7 */
	movdqu  	MSG, [DPTR + 1*16]
	pshufb  	MSG, SHUF_MASK
	movdqa  	MSGTMP1, MSG
		paddd   	MSG, [TBL + 1*16]
		sha256rnds2     STATE1, STATE0, MSG
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP0, MSGTMP1

	; /* Rounds 8-11 */
	movdqu  	MSG, [DPTR + 2*16]
	pshufb  	MSG, SHUF_MASK
	movdqa  	MSGTMP2, MSG
		paddd   	MSG, [TBL + 2*16]
		sha256rnds2     STATE1, STATE0, MSG
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP1, MSGTMP2

	; /* Rounds 12-15 */
	movdqu  	MSG, [DPTR + 3*16]
	pshufb  	MSG, SHUF_MASK
	movdqa  	MSGTMP3, MSG
		paddd   	MSG, [TBL + 3*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP3
	palignr 	MSGTMP4, MSGTMP2, 4
	paddd   	MSGTMP0, MSGTMP4
	sha256msg2      MSGTMP0, MSGTMP3
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP2, MSGTMP3

	; /* Rounds 16-19 */
	movdqa  	MSG, MSGTMP0
		paddd   	MSG, [TBL + 4*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP0
	palignr 	MSGTMP4, MSGTMP3, 4
	paddd   	MSGTMP1, MSGTMP4
	sha256msg2      MSGTMP1, MSGTMP0
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP3, MSGTMP0

	; /* Rounds 20-23 */
	movdqa  	MSG, MSGTMP1
		paddd   	MSG, [TBL + 5*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP1
	palignr 	MSGTMP4, MSGTMP0, 4
	paddd   	MSGTMP2, MSGTMP4
	sha256msg2      MSGTMP2, MSGTMP1
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP0, MSGTMP1

	; /* Rounds 24-27 */
	movdqa  	MSG, MSGTMP2
		paddd   	MSG, [TBL + 6*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP2
	palignr 	MSGTMP4, MSGTMP1, 4
	paddd   	MSGTMP3, MSGTMP4
	sha256msg2      MSGTMP3, MSGTMP2
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP1, MSGTMP2

	; /* Rounds 28-31 */
	movdqa  	MSG, MSGTMP3
		paddd   	MSG, [TBL + 7*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP3
	palignr 	MSGTMP4, MSGTMP2, 4
	paddd   	MSGTMP0, MSGTMP4
	sha256msg2      MSGTMP0, MSGTMP3
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP2, MSGTMP3

	; /* Rounds 32-35 */
	movdqa  	MSG, MSGTMP0
		paddd   	MSG, [TBL + 8*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP0
	palignr 	MSGTMP4, MSGTMP3, 4
	paddd   	MSGTMP1, MSGTMP4
	sha256msg2      MSGTMP1, MSGTMP0
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP3, MSGTMP0

	; /* Rounds 36-39 */
	movdqa  	MSG, MSGTMP1
		paddd   	MSG, [TBL + 9*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP1
	palignr 	MSGTMP4, MSGTMP0, 4
	paddd   	MSGTMP2, MSGTMP4
	sha256msg2      MSGTMP2, MSGTMP1
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP0, MSGTMP1

	; /* Rounds 40-43 */
	movdqa  	MSG, MSGTMP2
		paddd   	MSG, [TBL + 10*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP2
	palignr 	MSGTMP4, MSGTMP1, 4
	paddd   	MSGTMP3, MSGTMP4
	sha256msg2      MSGTMP3, MSGTMP2
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP1, MSGTMP2

	; /* Rounds 44-47 */
	movdqa  	MSG, MSGTMP3
		paddd   	MSG, [TBL + 11*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP3
	palignr 	MSGTMP4, MSGTMP2, 4
	paddd   	MSGTMP0, MSGTMP4
	sha256msg2      MSGTMP0, MSGTMP3
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP2, MSGTMP3

	; /* Rounds 48-51 */
	movdqa  	MSG, MSGTMP0
		paddd   	MSG, [TBL + 12*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP0
	palignr 	MSGTMP4, MSGTMP3, 4
	paddd   	MSGTMP1, MSGTMP4
	sha256msg2      MSGTMP1, MSGTMP0
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG
	sha256msg1      MSGTMP3, MSGTMP0

	; /* Rounds 52-55 */
	movdqa  	MSG, MSGTMP1
		paddd   	MSG, [TBL + 13*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP1
	palignr 	MSGTMP4, MSGTMP0, 4
	paddd   	MSGTMP2, MSGTMP4
	sha256msg2      MSGTMP2, MSGTMP1
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG

	; /* Rounds 56-59 */
	movdqa  	MSG, MSGTMP2
		paddd   	MSG, [TBL + 14*16]
		sha256rnds2     STATE1, STATE0, MSG
	movdqa  	MSGTMP4, MSGTMP2
	palignr 	MSGTMP4, MSGTMP1, 4
	paddd   	MSGTMP3, MSGTMP4
	sha256msg2      MSGTMP3, MSGTMP2
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG

	; /* Rounds 60-63 */
	movdqa  	MSG, MSGTMP3
		paddd   	MSG, [TBL + 15*16]
		sha256rnds2     STATE1, STATE0, MSG
		pshufd  	MSG, MSG, 0x0E
		sha256rnds2     STATE0, STATE1, MSG

	; /* Add current hash values with previously saved */
	paddd   	STATE0, ABEF_SAVE
	paddd   	STATE1, CDGH_SAVE

	; Increment data pointer and loop if more to process
	add     	DPTR, 64
    dec         TIME
	test        TIME, TIME
	jnz     	sha256_loop_big

    ;; ABEF(state0), CDGH(state1) -> digests
	pextrd  eax, STATE0, 3     ; A
    bswap   eax
    mov     [OSTATE + 0x00], eax
    pextrd  eax, STATE0, 2     ; B
    bswap   eax
    mov     [OSTATE + 0x04], eax
    pextrd  eax, STATE1, 3     ; C
    bswap   eax
    mov     [OSTATE + 0x08], eax
    pextrd  eax, STATE1, 2     ; D
    bswap   eax
    mov     [OSTATE + 0x0C], eax
    pextrd  eax, STATE0, 1     ; E
    bswap   eax
    mov     [OSTATE + 0x10], eax
    pextrd  eax, STATE0, 0     ; F
    bswap   eax
    mov     [OSTATE + 0x14], eax
    pextrd  eax, STATE1, 1     ; G
    bswap   eax
    mov     [OSTATE + 0x18], eax
    pextrd  eax, STATE1, 0     ; H
    bswap   eax
    mov     [OSTATE + 0x1C], eax
	; pextrd  [OSTATE + 0x04], STATE0, 2     ; B
	; pextrd  [OSTATE + 0x08], STATE1, 3     ; C
	; pextrd  [OSTATE + 0x0C], STATE1, 2     ; D
	; pextrd  [OSTATE + 0x10], STATE0, 1     ; E
	; pextrd  [OSTATE + 0x14], STATE0, 0     ; F
	; pextrd  [OSTATE + 0x18], STATE1, 1     ; G
	; pextrd  [OSTATE + 0x1C], STATE1, 0     ; H

    ret

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

PSHUFFLE_SHANI_MASK:    dq 0x0405060700010203, 0x0c0d0e0f08090a0b
TABLE:	dd	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
	dd      0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
	dd      0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
	dd      0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
	dd      0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
	dd      0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
	dd      0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
	dd      0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
	dd      0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
	dd      0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
	dd      0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
	dd      0xd192e819,0xd6990624,0xf40e3585,0x106aa070
	dd      0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
	dd      0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
	dd      0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
	dd      0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
padding: