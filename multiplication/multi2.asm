section .data
    msg db "1.. Multiplication using Successive Addition", 10    ; Menu option 1
        db "2.. Multiplication using Add and Shift", 10          ; Menu option 2
        db "3.. Exit", 10                                        ; Menu option 3
    msg_len equ $-msg                                            ; Length of the menu message

    choice_msg db "Enter your choice: 1/2/3", 10                 ; Prompt for user input
    ch_len equ $-choice_msg                                      ; Length of choice prompt

    msg1 db "Enter the multiplicand: ", 10                       ; Prompt for multiplicand input
    msg1_len equ $-msg1                                          ; Length of the prompt

    msg2 db "Enter the multiplier: ", 10                         ; Prompt for multiplier input
    msg2_len equ $-msg2                                          ; Length of the prompt

    msg3 db "Multiplication Result/Product: ", 10                ; Output message for the result
    msg3_len equ $-msg3                                          ; Length of the output message

    msg_space db " ", 10                                         ; Newline/spacing
    msg_space_len equ $-msg_space                                ; Length of spacing

section .bss
    num resb 17                                                  ; Buffer for user input (numbers)
    choice resb 2                                                ; Buffer to store user's choice
    buff resb 16                                                  ; Buffer to store final result for display
    no1 resq 1                                                   ; Storage for multiplicand
    no2 resq 1                                                   ; Storage for multiplier
    A resq 1                                                     ; Storage for accumulator (used in Add and Shift method)
    B resq 1                                                     ; Storage for multiplicand (Add and Shift method)
    Q resq 1                                                     ; Storage for multiplier (Add and Shift method)
    n resq 1                                                     ; Counter for bit shifts (Add and Shift method)

section .text
    global _start

_start:
    ; Main menu
    call main_menu                                                ; Jump to main menu function

main_menu:
    mov rsi, msg_space                                            ; Display spacing
    mov rdx, msg_space_len
    call write

    mov rsi, msg                                                  ; Display menu options
    mov rdx, msg_len
    call write

    mov rsi, msg_space                                            ; Another spacing after menu
    mov rdx, msg_space_len
    call write

    mov rsi, choice_msg                                           ; Prompt user for input (1, 2, or 3)
    mov rdx, ch_len
    call write

    mov rsi, choice                                               ; Read user's choice
    mov rdx, 2
    call read

    cmp byte [choice], '1'                                        ; Compare input choice to '1'
    je op1                                                        ; If choice is 1, jump to operation 1 (Successive Addition)
    cmp byte [choice], '2'                                        ; Compare input choice to '2'
    je op2                                                        ; If choice is 2, jump to operation 2 (Add and Shift)
    cmp byte [choice], '3'                                        ; Compare input choice to '3'
    je exit_program                                               ; If choice is 3, exit the program

op1:  ; Multiplication using Successive Addition
    mov rsi, msg1                                                 ; Prompt for multiplicand
    mov rdx, msg1_len
    call write

    mov rsi, num                                                  ; Read multiplicand input
    mov rdx, 17
    call read
    call convert_input                                            ; Convert input from string to number
    mov qword [no1], rbx                                          ; Store multiplicand

    mov rsi, msg2                                                 ; Prompt for multiplier
    mov rdx, msg2_len
    call write

    mov rsi, num                                                  ; Read multiplier input
    mov rdx, 17
    call read
    call convert_input                                            ; Convert input from string to number
    mov qword [no2], rbx                                          ; Store multiplier

    ; Initialize accumulator (product)
    xor rbx, rbx                                                  ; Clear rbx (accumulator)
    mov rcx, qword [no2]                                          ; Set multiplier as loop counter

    loop1:
        add rbx, qword [no1]                                      ; Add multiplicand to the product
        loop loop1                                                ; Decrement rcx and repeat until 0

    ; rbx now contains the result
    mov rsi, msg3                                                 ; Display result prompt
    mov rdx, msg3_len
    call write

    call display_result                                           ; Display result (in rbx)
    jmp main_menu                                                 ; Go back to main menu


op2:  ; Multiplication using Add and Shift
    ; Input multiplicand
    mov rsi, msg1                                                 ; Prompt for multiplicand
    mov rdx, msg1_len
    call write

    mov rsi, num                                                  ; Read multiplicand input
    mov rdx, 17
    call read
    call convert_input                                            ; Convert input to number
    mov qword [B], rbx                                            ; Store multiplicand (B)

    ; Input multiplier
    mov rsi, msg2                                                 ; Prompt for multiplier
    mov rdx, msg2_len
    call write

    mov rsi, num                                                  ; Read multiplier input
    mov rdx, 17
    call read
    call convert_input                                            ; Convert input to number
    mov qword [Q], rbx                                            ; Store multiplier (Q)

    ; Initialize accumulator and bit counter
    mov qword [A], 0                                              ; Clear accumulator (A)
    mov qword [n], 64                                             ; Initialize bit shift count to 64

    loop_shift:
        mov rax, qword [Q]                                        ; Check LSB of Q
        and rax, 1
        cmp rax, 1
        jne shift                                                 ; Skip if LSB is 0

        mov rax, qword [A]
        add rax, qword [B]                                        ; Add multiplicand to accumulator
        mov qword [A], rax

    shift:
        mov rax, qword [A]
        shr rax, 1                                                ; Right shift accumulator
        mov qword [A], rax

        mov rbx, qword [Q]
        shr rbx, 1                                                ; Right shift multiplier
        mov qword [Q], rbx

        dec qword [n]                                             ; Decrement shift count
        jnz loop_shift                                            ; Repeat until n = 0

    mov rsi, msg3                                                 ; Display result prompt
    mov rdx, msg3_len
    call write

    mov rbx, qword [A]                                            ; Move result to rbx for display
    call display_result
    jmp main_menu                                                 ; Return to main menu

exit_program:
    mov rax, 60                                                   ; System call for exit
    xor rdi, rdi                                                  ; Exit code 0
    syscall

convert_input:
    mov rbx, 0                                                    ; Clear rbx for result
    mov rsi, num                                                  ; Start at input buffer
    mov rcx, 17                                                   ; Length of input buffer
convert_loop:
    mov al, [rsi]                                                 ; Load byte
    cmp al, 10                                                    ; Check for newline
    je convert_done
    sub al, '0'                                                   ; Convert ASCII to digit
    imul rbx, 10                                                  ; Multiply current result by 10
    add rbx, rax                                                  ; Add current digit
    inc rsi                                                       ; Move to next character
    loop convert_loop
convert_done:
    ret                                                           ; Return result in rbx

display_result:
    mov rsi, buff                                                 ; Buffer for display
    mov rcx, 16                                                   ; Number of digits
    xor rdx, rdx                                                  ; Clear rdx for result
display_loop:
    rol rbx, 4                                                    ; Rotate left to isolate hex digit
    mov dl, bl
    and dl, 0Fh                                                   ; Mask out other bits
    cmp dl, 9
    jbe convert_hex
    add dl, 7                                                     ; Convert to letter for A-F
convert_hex:
    add dl, '0'                                                   ; Convert to ASCII
    mov [rsi], dl                                                 ; Store in buffer
    inc rsi                                                       ; Move to next buffer position
    dec rcx                                                       ; Decrement digit count
    jnz display_loop                                              ; Repeat for all digits
    mov rsi, buff                                                 ; Load buffer start
    mov rdx, 16                                                   ; Length of buffer
    call write                                                    ; Output buffer
    ret                                                           ; Return from display

write:
    mov rax, 1                                                    ; System call for write
    mov rdi, 1                                                    ; File descriptor (stdout)
    syscall
    ret

read:
    mov rax, 0                                                    ; System call for read
    mov rdi, 0                                                    ; File descriptor (stdin)
    syscall
    ret
