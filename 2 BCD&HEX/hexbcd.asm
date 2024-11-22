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
    msg1 db "Enter the HEX Number: ", 0
    len1 equ $-msg1
    msg2 db "The BCD for the number is: ", 0
    len2 equ $-msg2
    brtag db 10
    brlen equ $-brtag

section .bss
    char_buffer resb 17
    cnt resb 1 ; for pushes
    len resq 1 ; len
    char resb 1;


section .text 
    global _start
_start:

    WRITE msg1, len1
    READ char_buffer, 17
    dec rax
    mov [len], rax
    mov rcx, [len]
    call accept

    mov rcx, 00
    mov rax, rbx
l1: mov rdx, 00
    mov rbx, 0AH
    div rbx
    push rdx ; push reminder
    inc rcx
    cmp rax, 00
    jnz l1 ; if not equal to zero

    mov byte[cnt], cl

l2: pop rbx 
    cmp bl, 09H
    jbe l3
    add bl, 07H
l3: add bl, 30H
    mov byte[char], bl
    WRITE char, 01
    dec byte[cnt]
    jnz l2

    mov rax, 60 ;  exit
    mov rdi, 00
    syscall

accept: 
    mov rsi, char_buffer
    mov rbx, 00H
up: mov rdx, 0H
    mov dl, byte[rsi]
    cmp dl, 39H
    jbe sub30
    sub dl, 07H
sub30: sub dl, 30H
    shl rbx, 04
    add rbx, rdx
    inc rsi
    dec rcx
    jnz up
ret

display: 
    mov rsi, char_buffer
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