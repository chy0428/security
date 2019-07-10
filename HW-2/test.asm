    global  _start
    extern   puts
    section .text
_start:
    extern  puts
    push    rdi
    push    rsi
    sub     rsp, 8

    mov     rdi, [rsi]
    call    puts

    mov       rax, 1
    mov       rdi, 1
    mov       rsi, message
    mov       rdx, 37
    syscall
    mov       rax, 60
    xor       rdi, rdi
    syscall
    section   .data
message:
    db        "Hello, World", 10
    db        "My name is Choi hayeong", 10
