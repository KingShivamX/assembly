%macro READ 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro WRITE 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data
    msg1 db "Enter the BCD Number: ", 0
    len1 equ $-msg1
    msg2 db "The HEX for the number is: ", 0
    len2 equ $-msg2
    brtag db 10
    brlen equ $-brtag

section .bss
    char_buffer resb 17
    cnt resq 1 ; len
    result resq 1

section .text 
    global _start:
_start:

    WRITE msg1, len1
    READ char_buffer, 17
    dec rax
    mov [cnt], rax

    mov rsi, char_buffer
    mov rcx, [cnt]
    mov rbx, 0H ; here will be result
up: mov rax, 0AH ; 10 in hex
    mul rbx
    mov rbx, rax
    mov rdx, 0H ; for hex num to add
    mov dl, byte[rsi]
    sub dl, 30H ; to get num value , removing num diff
    add rbx, rdx
    inc rsi
    dec rcx
    jnz up

    mov [result], rbx
    WRITE msg2, len2
    WRITE brtag, brlen

    mov rbx, [result]
    call display

    mov rax, 60 ;  exit
    mov rdi, 00
    syscall

accept: mov rsi, char_buffer
    mov rbx, 00H
up: mov rdx, 00H
    mov dl, byte[rsi]
    cmp dl, 39H
    jbe sub30
    sub dl, 07H
sub30: sub, dl 30
    shl rbx, 04
    add rbx, rdx
    inc rsi
    dec rcx
    jnz up
ret

display: mov rsi, char_buffer
    mov rcx, 16
up1: rol rbx, 04
    mov dl, bl 
    and dl, 0FH
    cmp dl, 09
    jbe add30
    add dl, 07H    
add30: add dl, 30H
    mov byte[rsi], dl
    inc rsi
    dec rcx
    jnz up1

WRITE char_buffer, 16
WRITE brtag, brlen
ret