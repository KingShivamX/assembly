section .data
    msg1 db "Enter 1st No: " ; Message to prompt user for the first number
    len1 equ $-msg1 ; Length of the first message

    msg2 db "Enter 2nd No: " ; Message to prompt user for the second number
    len2 equ $-msg2 ; Length of the second message

    msg3 db "The Sum is: " ; Message to display the result
    len3 equ $-msg3 ; Length of the result message

    newline db 0xA ; Newline character to move the prompt to the next line

section .bss ; Section for uninitialized data
    num1 resb 2 ; Reserve 2 bytes for the first number (input)
    num2 resb 2 ; Reserve 2 bytes for the second number (input)
    sum  resb 2 ; Reserve 2 bytes for the sum (output)

section .text
    global _start ; Entry point for the program
_start:
    ; Print the first message ("Enter 1st No: ")
    mov rax, 1       ; System call number for sys_write
    mov rdi, 1       ; File descriptor 1 (stdout)
    mov rsi, msg1    ; Address of the message
    mov rdx, len1    ; Length of the message
    syscall          ; Make the system call

    ; Read the first number from the user
    mov rax, 0       ; System call number for sys_read
    mov rdi, 0       ; File descriptor 0 (stdin)
    mov rsi, num1    ; Buffer to store the input
    mov rdx, 2       ; Number of bytes to read
    syscall          ; Make the system call

    ; Print the second message ("Enter 2nd No: ")
    mov rax, 1       ; System call number for sys_write
    mov rdi, 1       ; File descriptor 1 (stdout)
    mov rsi, msg2    ; Address of the message
    mov rdx, len2    ; Length of the message
    syscall          ; Make the system call

    ; Read the second number from the user
    mov rax, 0       ; System call number for sys_read
    mov rdi, 0       ; File descriptor 0 (stdin)
    mov rsi, num2    ; Buffer to store the input
    mov rdx, 2       ; Number of bytes to read
    syscall          ; Make the system call

    ; Convert the ASCII input characters to integer values and add them
    mov rax, [num1]  ; Load the first input (ASCII)
    sub rax, 30h     ; Convert ASCII to integer by subtracting '0' (0x30)
    mov rbx, [num2]  ; Load the second input (ASCII)
    sub rbx, 30h     ; Convert ASCII to integer
    add rax, rbx     ; Add the two integers
    add rax, 30h     ; Convert the sum back to ASCII
    mov [sum], rax   ; Store the ASCII result in the sum buffer

    ; Print the result message ("The Sum is: ")
    mov rax, 1       ; System call number for sys_write
    mov rdi, 1       ; File descriptor 1 (stdout)
    mov rsi, msg3    ; Address of the message
    mov rdx, len3    ; Length of the message
    syscall          ; Make the system call

    ; Print the calculated sum
    mov rax, 1       ; System call number for sys_write
    mov rdi, 1       ; File descriptor 1 (stdout)
    mov rsi, sum     ; Address of the sum (result)
    mov rdx, 2       ; Length of the sum (2 bytes)
    syscall          ; Make the system call

    ; Print a newline character to move the prompt to the next line
    mov rax, 1       ; System call number for sys_write
    mov rdi, 1       ; File descriptor 1 (stdout)
    mov rsi, newline ; Address of the newline character
    mov rdx, 1       ; Length of the newline character (1 byte)
    syscall          ; Make the system call

    ; Exit the program
    mov rax, 60      ; System call number for sys_exit
    mov rdi, 0       ; Exit code 0 (success)
    syscall          ; Make the system call