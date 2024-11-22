; Macro for writing to stdout
%macro WRITE 2
    mov rax, 1         ; syscall number for write
    mov rdi, 1         ; file descriptor (1 = stdout)
    mov rsi, %1        ; pointer to the message
    mov rdx, %2        ; length of the message
    syscall            ; invoke syscall
%endmacro

; Macro for reading from stdin
%macro READ 2
    mov rax, 0         ; syscall number for read
    mov rdi, 0         ; file descriptor (0 = stdin)
    mov rsi, %1        ; buffer to store input
    mov rdx, %2        ; number of bytes to read
    syscall            ; invoke syscall
%endmacro

section .data
    msg1 db "Enter 2 numbers : ", 10
    len1 equ $ - msg1            ; calculate length of msg1
    msg2 db "Addition is : ", 10
    len2 equ $ - msg2
    msg3 db "Subtraction is : ", 10
    len3 equ $ - msg3
    msg4 db "Multiplication is : ", 10
    len4 equ $ - msg4
    msg5 db "Quotient is : ", 10
    len5 equ $ - msg5
    msg6 db 10, "Remainder is : ", 10
    len6 equ $ - msg6
    msg7 db "Wrong Choice!!", 10
    len7 equ $ - msg7
    menu db 10, "*** Menu ***", 10
         db " 1. Addition", 10
         db " 2. Subtraction", 10
         db " 3. Multiplication", 10
         db " 4. Division", 10
         db " 5. Exit", 10
         db "Enter your choice : ", 10
    menu_len equ $ - menu

section .bss
    choice resb 2       ; buffer for choice input
    a resq 1            ; store first number
    b resq 1            ; store second number
    c resq 1            ; store result
    d resq 1            ; store intermediate results
    char_buff resb 17   ; temporary buffer for input/output

section .text
    global _start

_start:
    ; Display menu and read choice
    printmenu:
        WRITE menu, menu_len
        READ choice, 2
        cmp byte [choice], 31H   ; check if choice is 1 (Addition)
        je addition
        cmp byte [choice], 32H   ; check if choice is 2 (Subtraction)
        je subtraction
        cmp byte [choice], 33H   ; check if choice is 3 (Multiplication)
        je multiplication
        cmp byte [choice], 34H   ; check if choice is 4 (Division)
        je division
        cmp byte [choice], 35H   ; check if choice is 5 (Exit)
        je exit
        WRITE msg7, len7         ; Invalid choice message
        jmp printmenu            ; Go back to menu

    ; Addition
    addition:
        WRITE msg1, len1         ; Prompt user for input
        READ char_buff, 17
        call accept              ; Convert input to integer
        mov qword [a], rbx       ; Store first number
        READ char_buff, 17
        call accept
        mov qword [b], rbx       ; Store second number
        mov rax, qword [a]       ; Load first number
        add rax, qword [b]       ; Add second number
        mov qword [c], rax       ; Store result
        WRITE msg2, len2         ; Display result message
        mov rbx, [c]
        call display             ; Display result
        jmp printmenu            ; Back to menu

    ; Subtraction
    subtraction:
        WRITE msg1, len1
        READ char_buff, 17
        call accept
        mov qword [a], rbx
        READ char_buff, 17
        call accept
        mov qword [b], rbx
        mov rax, qword [a]
        sub rax, qword [b]       ; Subtract second number
        mov qword [c], rax
        WRITE msg3, len3
        mov rbx, [c]
        call display
        jmp printmenu

    ; Multiplication
    multiplication:
        WRITE msg1, len1
        READ char_buff, 17
        call accept
        mov qword [a], rbx
        READ char_buff, 17
        call accept
        mov qword [b], rbx
        mov rax, qword [a]
        mul qword [b]            ; Multiply numbers
        mov qword [c], rdx       ; Store high part of result
        mov qword [d], rax       ; Store low part of result
        WRITE msg4, len4
        mov rbx, qword [c]
        call display
        mov rbx, qword [d]
        call display
        jmp printmenu

    ; Division
    division:
        WRITE msg1, len1
        READ char_buff, 17
        call accept
        mov qword [a], rbx
        READ char_buff, 17
        call accept
        mov qword [b], rbx
        mov rdx, 0               ; Clear high part of dividend
        mov rax, qword [a]
        div qword [b]            ; Divide numbers
        mov qword [c], rax       ; Store quotient
        mov qword [d], rdx       ; Store remainder
        WRITE msg5, len5
        mov rbx, qword [c]
        call display
        WRITE msg6, len6
        mov rbx, qword [d]
        call display
        jmp printmenu

    ; Exit program
    exit:
        mov rax, 60              ; syscall number for exit
        mov rdi, 0               ; exit code 0
        syscall

    ; Convert input string to integer
    accept:
        dec rax
        mov rcx, rax
        mov rbx, 0
        mov rsi, char_buff
    up1:
        shl rbx, 4
        mov rdx, 0
        mov dl, byte [rsi]
        cmp dl, 39H
        jbe sub30
        sub dl, 7
    sub30:
        sub dl, 30H
        add rbx, rdx
        inc rsi
        dec rcx
        jnz up1
        ret

    ; Convert integer to string and display
    display:
        mov rsi, char_buff
        mov rcx, 16
    up:
        rol rbx, 4
        mov dl, bl
        and dl, 0FH
        cmp dl, 9H
        jbe add30
        add dl, 7
    add30:
        add dl, 30H
        mov byte [rsi], dl
        inc rsi
        dec rcx
        jnz up
        WRITE char_buff, 16
        ret
