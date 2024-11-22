Basic Arithmetic

%macro WRITE 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro READ 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
msg1 db "Enter 2 numbers ",10
len1 equ $-msg1
msg2 db "Addition : ",10
len2 equ $-msg2
msg3 db "Substraction : ",10
len3 equ $-msg3
msg4 db "Multiplication : ",10
len4 equ $-msg4
msg5 db "Quotient : ",10
len5 equ $-msg5
msg6 db 10,"Remainder : ",10
len6 equ $-msg6
msg7 db "Wrong choice",10
len7 equ $-msg7

menumsg db 10,"*****Calcultor Menu*****",10
db "1.Addition",10
db "2.Substraction",10
db "3.Multiplication",10
db "4.Division",10
db "5.Exit",10
db "Enter your choice : ",10
menulen equ $-menumsg

section .bss
char_buff resb 17
a resq 1
b resq 1
c resq 1
d resq 1
choice resb 2

section .text
global _start:
_start:

printmenu:WRITE menumsg,menulen
READ choice,02
cmp byte[choice],31H
je addition
cmp byte[choice],32H
je substraction
cmp byte[choice],33H
je multiplication
cmp byte[choice],34H
je division
cmp byte[choice],35H
je exit
WRITE msg7,len7
jmp printmenu

addition:WRITE msg1,len1
READ char_buff,17
dec rax
mov rcx,rax
call accept
mov [a],rbx
READ char_buff,17
dec rax
mov rcx,rax
call accept
mov[b],rbx
WRITE msg2,len2
mov rax,[a]
add rax,[b]
mov [c],rax
mov rbx,[c]
call display
jmp printmenu

substraction:
WRITE msg1,len1
READ char_buff,17
dec rax
mov rcx,rax
call accept
mov [a],rbx
READ char_buff,17
dec rax
mov rcx,rax
call accept
mov[b],rbx
WRITE msg3,len3
mov rax,[a]
sub rax,[b]
mov [c],rax
mov rbx,[c]
call display
jmp printmenu

multiplication:
WRITE msg1,len1
READ char_buff,17
dec rax
mov rcx,rax
call accept
mov [a],rbx
READ char_buff,17
dec rax
mov rcx,rax
call accept
mov[b],rbx

WRITE msg4,len4

mov rax,[a]
mul qword [b]
mov [c],rax
mov rbx,rdx
call display
mov rbx,[c]
call display
jmp printmenu

division:
WRITE msg1,len1
READ char_buff,17
dec rax
mov rcx,rax
call accept
mov [a],rbx

READ char_buff,17
dec rax
mov rcx,rax
call accept
mov[b],rbx

mov rax,[a]
mov rdx,00H
div qword [b]
mov [c],rax
mov [d],rdx
WRITE msg5,len5
mov rbx,[c]
call display
WRITE msg6,len6
mov rbx,[d]
call display
jmp printmenu

exit:mov rax,60
mov rdi,00
syscall


display: mov rsi,char_buff
mov rcx,16
up1:rol rbx,04
mov dl,bl
and dl,0FH
cmp dl,09
jbe add30
add dl,07H
add30:add dl,30H
mov byte[rsi],dl
inc rsi
dec rcx
jnz up1
WRITE char_buff,16
ret

accept:
mov rsi,char_buff
mov rbx,00H
up:mov rdx,00H
mov dl,byte[rsi]
cmp dl,39H
jbe sub30
sub dl,07H
sub30:sub dl,30H
shl rbx,04H
add rbx,rdx
inc rsi
dec rcx
________________________________________________

BCD TO HEX and HEX TO BCD

%macro WRITE 02
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro READ 02
mov rax,0a
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

menu db 10, "***menu***",10
db 10, "1) BCD TO HEX",10
db 10, "2) HEX TO BCD",10
db 10, "3) EXIT",10
db 10, "Enter your choice",10
menulen equ $-menu
msg1 db "enter number to be converted from bcd to hex:",10
len1 equ $-msg1
msg2 db "enter number to be converted from hex to bcd:",10
len2 equ $-msg2
msg3 db "Answer is:",10
len3 equ $-msg3
msg8 db "Wrong choice, choose again :",10
len8 equ $-msg8

section .bss
ans resq 1
cnt resb 1
x resb 1
actl resq 1
choice resb 2
char_buff resb 17

section .text
global _start
_start:

menumsg:WRITE menu,menulen ;menu
READ choice,02

cmp byte[choice],31H ;menu driven
je bcdtohex
cmp byte[choice],32H
je hextobcd
cmp byte[choice],33H
je exit
WRITE msg8,len8
JMP menumsg

bcdtohex: WRITE msg1,len1
READ char_buff,17
dec rax
mov [actl],rax
mov rax,00

mov rsi, char_buff
mov rbx,0AH
up: mul rbx
mov rdx,00
mov dl, byte[rsi]
sub dl,30H
add rax,rdx
inc rsi
dec qword[actl]
jnz up
mov [ans],rax
WRITE msg3,len3
mov rbx,[ans]
call display
JMP _start

hextobcd:WRITE msg2, len2
READ char_buff,17
call accept
mov byte[cnt],00
mov rax,rbx
up1:mov rdx,00
mov rbx,0AH

div rbx

push rdx
inc byte[cnt]
cmp rax,00
jne up1

WRITE msg3,len3

up2: pop rdx
add dl,30H
mov byte[x],dl
WRITE x , 01
dec byte[cnt]
jnz up2
JMP _start


JMP menumsg


exit: mov rax,60;
mov rdi,0
syscall

accept: dec rax
mov [actl],rax

mov rbx,0
mov rsi,char_buff

up3:shl rbx,04H
mov rdx,0
mov dl, byte[rsi]
cmp dl,39H
jbe sub30
sub dl,07H

sub30: sub dl,30H
add rbx,rdx
inc rsi
dec qword[actl]
jnz up3
ret

display:mov rsi,char_buff
mov rcx,16
up4:rol rbx,04
mov dl,bl
and dl,0FH
cmp dl,09H
jbe add30

add dl,07H
add30:add dl,30H
mov byte[rsi],dl
inc rsi
dec rcx
jnz up4

WRITE char_buff,16
ret

jnz up
ret
________________________________________

Successive Addition and Shift Add

%macro WRITE 02
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro READ 02
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
menu db 10,"***Menu***",10
db " 1. Successive Addition ",10
db " 2. Shift and Add ",10
db " 3. Exit ",10
db " Enter your choice : ",10
len equ $-menu
msg1 db " Enter 2 numbers : ",10
len1 equ $-msg1
msg2 db " The answer is : ",10
len2 equ $-msg2
msg3 db " Wrong Choice ",10
len3 equ $-msg3

section .bss
m resq 1
n resq 1
char_buff resb 17
B resq 1
Q resq 1
A resq 1
ans resq 1
choice resb 02

section .text
global _start
_start: WRITE msg1,len1
READ char_buff,17
call accept

mov [m],rbx
READ char_buff,17
call accept

mov [n],rbx

printmenu:WRITE menu,len
READ choice,02
cmp byte[choice],31H
je succadd
cmp byte[choice],32H
je shiftnadd
cmp byte[choice],33H
je exit
WRITE msg3,len3
jmp printmenu

succadd: mov rbx,00H
mov rcx,[n]

up1: add rbx,[m]
dec rcx
jnz up1
mov [ans],rbx
WRITE msg2,len2
mov rbx,[ans]
call display
jmp printmenu

shiftnadd:mov rbx,[m]
mov [B],rbx
mov rbx,[n]
mov [Q],rbx
mov qword[A],00
mov rcx,64

up2:mov rbx,[Q]
and rbx,01H
jz shiftaq
mov rbx,[B]
add [A],rbx

shiftaq: shr qword[Q],01
mov rbx,[A]
and rbx,01
jz shifta

mov rbx,01H
ror rbx,01H
or qword[Q],rbx

shifta: shr qword[A],01H
dec rcx
jnz up2
WRITE msg2,len2
mov rbx,[A]
call display
mov rbx,[Q]
call display
jmp printmenu

exit: mov rax,60
mov rdi,00
syscall

accept : dec rax
mov rcx,rax
mov rbx,00H
mov rsi,char_buff

up3: shl rbx,04H
mov rdx,00H
mov dl,byte[rsi]
cmp dl,39H
jbe sub30
sub dl,07H
sub30: sub dl,30H
add rbx,rdx
inc rsi
dec rcx
jnz up3
ret

display:mov rsi,char_buff
mov rcx,16

up:rol rbx,04
mov dl,bl
and dl,0FH
cmp dl,09H
jbe add30
add dl,07H

add30:add dl,30H
mov byte[rsi],dl
inc rsi
dec rcx
jnz up
WRITE char_buff,16
ret
___________________________________________________
String ops

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
menumsg db 10,"1. String length",10
db 10,"2. String copy",10
db 10,"3. String reverse",10
db 10,"4. String compare",10
db 10,"5. String concat",10
db 10,"6. Check palindrome",10
db 10,"7. String substring",10
db 10,"8. Exit",10
db 10,"Enter your choice: ",10

menulen equ $-menumsg
msg1 db "Enter String1",10
len1 equ $-msg1
msg2 db "Enter String2",10
len2 equ $-msg2
msg3 db "The length of the string is: ",10
len3 equ $-msg3
msg4 db "The copied String: ",10
len4 equ $-msg4
msg5 db "The reverse string",10
len5 equ $-msg5
msg6 db "String equal",10
len6 equ $-msg6
msg7 db "String are not equal",10
len7 equ $-msg7
msg8 db "String concatenated",10
len8 equ $-msg8
msg9 db "String Palindrome",10
len9 equ $-msg9
msg10 db "String not palindrome",10
len10 equ $-msg10
msg11 db "substring",10
len11 equ $-msg11
msg12 db "Not substring",10
len12 equ $-msg12
msg13 db "Wrong choice",10
len13 equ $-msg13

section .bss
string1 resb 20
string2 resb 20
string3 resb 40
l1 resq 1
l2 resq 1
l3 resq 1
choice resb 2
char_buff resb 16

section .text
global _start
_start:
write msg1,len1
read string1,20
dec rax
mov[l1],rax
write msg2,len2
read string2,20
dec rax
mov[l2],rax

printmenu:write menumsg,menulen
read choice,2
cmp byte[choice],31h
je strlen
cmp byte[choice],32h
je strcpy
cmp byte[choice],33h
je strrev
cmp byte[choice],34h
je strcmp
cmp byte[choice],35h
je strcat
cmp byte[choice],36h
je strpal
cmp byte[choice],37h
je substr
cmp byte[choice],38h
je exit
write msg13,len13
jmp printmenu

strlen: write msg3,len3
mov rbx,[l1]
call display
jmp printmenu

strcpy: mov rsi,string1
mov rdi,string3
mov rcx,[l1]
cld
rep movsb
write msg4,len4
write string3,[l1]
jmp printmenu

strrev: mov rsi,string1
add rsi,[l1]
dec rsi
mov rdi,string3
mov rcx,[l1]
up: mov bl,byte[rsi]
mov byte[rdi],bl
dec rsi
inc rdi
dec rcx
jnz up
write msg5,len5
write string3,[l1]
jmp printmenu

strcmp:mov rbx,[l1]
cmp rbx,qword[l2]
jne nonequal
mov rsi,string1
mov rdi,string2
mov rcx,[l1]
cld
repe cmpsb
jne nonequal
write msg6,len6
jmp printmenu
nonequal: write msg7,len7
jmp printmenu

strcat: mov rsi,string1
mov rdi,string3
mov rcx,[l1]
cld
rep movsb
mov rsi,string2
mov rcx,[l2]
rep movsb
mov rbx,[l1]
add rbx,[l2]
mov[l3],rbx
write msg8,len8
write string3,[l3]
jmp printmenu

strpal: write msg1,len1
read string1,20
dec rax
mov[l1],rax
mov rsi,string1
add rsi,[l1]
dec rsi
mov rdi,string3
mov rcx,[l1]

up1:mov dl,byte[rsi]
mov byte[rdi],dl
dec rsi
inc rdi
dec rcx
jnz up1
mov rsi,string1
mov rdi,string3
mov rcx,[l1]
cld
repe cmpsb
jne notequal1
write msg9,len9
jmp printmenu

notequal1:write msg10,len10
jmp printmenu

substr:
write msg1,len1
read string1,20
dec rax
mov[l1],rax
write msg2,len2
read string2,20
dec rax
mov[l2],rax
mov rbx,qword[l2]
mov rsi,string1
mov rdi,string2

up3:mov al,byte[rdi]
cmp al,byte[rdi]
je same
mov rdi,string2
mov rbx,qword[l2]

same:
inc rsi
inc rdi
dec rbx
dec qword[l1]
cmp rbx,0
je st
cmp qword[l1],0
jne up3
write msg12,len12
jmp printmenu

st: write msg11,len11
jmp printmenu

display:
mov rsi,char_buff
mov rcx,16

up2: rol rbx,04
mov dl,bl
and dl,0FH
cmp dl,09H
jbe add30
add dl,07H

add30:
add dl,30H
mov byte[rsi],dl
inc rsi
dec rcx
jnz up2
write char_buff,16
ret

exit: mov rax,60
mov rdi,00
syscall
___________________________________________________

Quadratic Roots

extern printf,scanf

%macro PRINT 02
push rbp
mov rax,00H
mov rdi,%1
mov rsi,%2
call printf
pop rbp
%endmacro

%macro SCAN 02
push rbp
mov rax,00H
mov rdi,%1
mov rsi,%2
call scanf
pop rbp
%endmacro

%macro PRINTFLOAT 02
push rbp
mov rax,01
mov rdi,%1
movsd xmm0,%2
call printf
pop rbp
%endmacro

section .data
msg1 db "Enter the three numbers",10,0
fmt1 db "%lf",0
fmt2 db "%s",0
msg2 db "Roots are ",10


section .bss
a resb 08
b resb 08
c resb 08
r1 resb 08
r2 resb 08
t1 resb 08
t2 resb 08
t3 resb 08
t4 resb 08
temp resw 01


section .text
global main
main: PRINT fmt2,msg1
SCAN fmt1,a
SCAN fmt1,b
SCAN fmt1,c
finit
fld qword[b]
fmul st0,st0
fstp qword[t1]
fld qword[a]
fmul qword[c]
mov word[temp],04
fimul word[temp]
fstp qword[t2]
fld qword[t1]
fsub qword[t2]
fstp qword[t1]
fld qword[b]
fchs
fstp qword[t2]
mov word[temp],02
fld qword[a]
fimul word[temp]
fstp qword[t3]
fld qword[t1]
fabs
fsqrt
fstp qword[t4]
cmp qword[t1],00H
je equal_roots
PRINT fmt2,msg2
fld qword[t2]
fadd qword[t4]
fdiv qword[t3]
fstp qword[r1]
PRINTFLOAT fmt1,qword[r1]
equal_roots: fld qword[t2]
fsub qword[t4]
fdiv qword[t3]
fstp qword[r2]
PRINTFLOAT fmt1,qword[r2]
mov rax,00
ret