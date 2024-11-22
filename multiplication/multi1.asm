section .data
    num1 db 5         ; First number (byte-sized)
    num2 db 3         ; Second number (byte-sized)
    result db 0       ; Store the result (byte-sized)

section .text
    global _start

_start:
    ; Load the numbers into registers (zero extend because num1 and num2 are bytes)
    movzx eax, byte [num1] ; Load num1 into EAX (zero extend)
    movzx ebx, byte [num2] ; Load num2 into EBX (zero extend)
    xor ecx, ecx           ; Clear ECX (will be used to accumulate the result)
    
    ; Successive addition
add_loop:
    cmp ebx, 0             ; Check if the multiplier (EBX) is zero
    je done                ; If zero, jump to done
    add ecx, eax           ; Add num1 (in EAX) to ECX (accumulating result)
    dec ebx                ; Decrement EBX (decreasing the multiplier)
    jmp add_loop           ; Repeat until EBX is zero
    
    ; Store the result
    mov [result], cl       ; Store only the lower byte of the result (optional)

done:
    ; Exit the program
    mov eax, 60            ; Syscall number for exit (60)
    xor edi, edi           ; Exit code 0
    syscall                ; Make syscall