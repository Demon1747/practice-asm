.global _start

.data
msg: .ascii "Hello, Levi!\n"

.text
_start:
	mov X0, #0x1				// stdout file descriptor
	ldr X1, =msg
	mov	X2, #0xD				// msg len
	mov X8, #0x40				// X8 -- register for syscall number
	svc 0								// execute syscall
	
	mov X0, #0x0				// exit status
	mov X8, #0x5D				// syscall for program terminating
	svc 0

