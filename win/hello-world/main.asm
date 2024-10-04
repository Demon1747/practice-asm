global _main            ; making label globally visible

extern GetStdHandle     ; connecting external functions
extern WriteFile

section .data
STD_OUTPUT_HANDLE equ -11                   ; STD_OUTPUT constant
SHADOW_SPACE equ 0x20                       ; size of shadow space for WinAPI function calling
msg: db "Hello, Levi!",10
msg.len equ $-msg                           ; szie of msg macro

section .text           
_main:
    sub     rsp, SHADOW_SPACE + 0x8         ; reserving memory for shadow space + 1 argument 
    mov     rcx, STD_OUTPUT_HANDLE          ; placing argument for GetStdHandle
    call    GetStdHandle
    mov     rcx, rax                        ; placing stdout descriptor as first argument
    mov     rdx, msg                        ; 2-nd argument -- msg pointer
    mov     r8d, msg.len                    ; 3-rd argument -- msg length to write
    mov     qword [rsp + SHADOW_SPACE], 0   ; 5-th argument (directly behind the shadow space) -- NULL
    xor     r9, r9                          ; 4-th argument -- NULL
    call    WriteFile
    xor     rax, rax                        ; setting return value to 0
    add     rsp, SHADOW_SPACE + 0x8
    ret
