global _start          ; making label globally visible

section .data
msg: db "Hello, Levi!",10
msg.len equ $-msg           ; msg length constant

section .text
_start:
    mov rax, 1          ; write syscall
    mov rdi, 1          ; stdout file descriptor
    mov rsi, msg
    mov rdx, msg.len
    syscall             ; executing write syscall

    mov rdi, 0          ; setting exit status
    mov rax, 60         ; exit syscall
    syscall
