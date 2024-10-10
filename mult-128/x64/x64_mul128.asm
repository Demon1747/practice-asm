global x64_mul128

section .text

; rdi, rsi, rdx
; args: res ptr, mul1 ptr, mul2 ptr
x64_mul128:
	mov rax, qword [rsi]		; mul1[0]
	mov r8, qword [rdx]		; mul2[0]
	mov rcx, rdx			; rdx will be used as res for mul

; // 0 * 0
	mul r8
	mov qword [rdi], rax		; res[0] = 0 * 0 (0:63) -- finished
	mov r9, rdx			; res[1] = 0 * 0 (64:127)

; // 1 * 0
	xor r10, r10
	xor r11, r11
	mov rax, qword [rsi + 0x8]	; mul1[1]
	mul r8
	add r9, rax			; res[1] += 1 * 0 (0:63)
	adc r10, rdx			; res[2] = 1 * 0 (64:127) + carry flag
	adc r11, 0			; res[3] = carry flag

; // 0 * 1
	mov r8, qword [rcx + 0x8]	; mul2[1]
	mov rax, qword [rsi]		; mul1[0]
	mul r8
	add r9, rax			; res[1] += 0 * 1 (0:63) -- finished
	adc r10, rdx			; res[2] += 0 * 1 (64:127) + carry flag
	adc r11, 0			; res[3] += carry flag
	mov qword [rdi + 0x8], r9

; // 1 * 1
	mov rax, qword [rsi + 0x8]	; mul1[1]
	mul r8
	add r10, rax			; res[2] += 1 * 1 (0:63) -- finished
	adc r11, rdx			; res[3] += 1 * 1 (64:127) + carry flag -- finished
	mov qword [rdi + 0x10], r10
	mov qword [rdi + 0x18], r11
	ret

