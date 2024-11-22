section .data
	msg1 db "Hello World", 10, 13
	len equ $-msg1

section .text
	global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, len
	syscall

	mov rax, 60
	mov rdi, 00
	syscall

; https://drive.google.com/drive/folders/1vIY5XyfOANbRowQDxyeht52uSckIWYlA