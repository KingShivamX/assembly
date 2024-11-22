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
    msg1 db "Enter the 2 numbers ", 0
    len1 equ $-msg1
    msg2 db "The quetient ", 0 
    len2 equ $-msg2
    msg3 db "The reminder ", 0 
    len3 equ $-msg3
    brtag db 10
    brlen equ $-brtag

section .bss
    char_buff resb 17 ; array of 17 continues bytes, 1 extra for enter press 
    a resq 1
    b resq 1
    c resq 1
    d resq 1

section .text
    global _start
_start:

    WRITE msg1, len1

    READ char_buff, 17
    dec rax ; // rax has actual input size, dec to remove enter key cnt
    mov rcx, rax ; ll length in counter var
    call accept ;  call accept function
    mov [a], rbx ; copy final rbx value in [a]

    READ char_buff, 17
    dec rax 
    mov rcx, rax
    call accept 
    mov [b], rbx

    mov rdx, 00H
    mov rax, [a]
    div qword[b]
    mov [c], rax
    mov [d], rdx

    WRITE msg2, len2 ; for quetient
    mov rbx, [c]
    call display

    WRITE msg3, len3 ; for reminder
    mov rbx, [d]
    call display

    mov rax, 60
    mov rdi, 00
    syscall 

accept: ; accept function
    mov rsi, char_buff ; pointing to first byte
    mov rbx, 00H ; here to store final value, 00H means 0 in hexadecimal form, 0x0 same
up1: mov rdx, 00H ; dl is lower 8 bit in rdx register, assigned so not has any garbage
    mov dl, byte[rsi]
    cmp dl, 39H ; compare value in dl with 39
    jbe sub30 ; jump to label sub30 if dl is be -> below or equal to 39
    sub dl, 07H ; if not below ie its char , not num so need to - 37 , 07 here , 30 ahed.
sub30: sub dl, 30H
    shl rbx, 04H ; shift left rbx with 4 bits 
    add rbx, rdx ; add dl's lower 8 bit in rbx
    inc rsi ; increament pointer value to next
    dec rcx ;  decrement input size counter 
    jnz up1 ; if rcx is nz - not nero , then jump to label up
    ret ; functions returns


display: ; it will diaplay hex value in rbx converting into ascii 
    mov rsi, char_buff ; will store here , pointer rsi it is
    mov rcx, 16 ; counter , num can be max 16 digits here
up2: rol rbx, 04 ; by 1 digit
    mov dl, bl ; taking rbx, lower 8 bit in dl
    and dl, 0FH ; taking and with 15 "1111" binary, so we only get , last 4 bits, last digit. of bl
    cmp dl, 09H ; if value lower then 09 (in hex) decimal it is
    jbe add30
    add dl, 07H ; if char not number
add30: add dl, 30H ; 
    mov byte[rsi], dl ; storing asci value in rsi
    inc rsi 
    dec rcx
    jnz up2 
WRITE char_buff, 16
WRITE brtag, brlen
    ret
