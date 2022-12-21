;; AND, OR, XOR, TEST, NOT (complemento a 1), ...

section .data
	msg1 db "Es par", 0xA, 0xD
	lenMsg1 equ $-msg1
	msg2 db "No es par", 0xA, 0xD
	lenMsg2 equ $-msg2

section .text
global _start

_start:
	;; PAR O IMPAR

	mov al, 4
	mov bl, 1

	;; si la comparación es 0, es par
	;; si la comparación es 1, es impar
	and al, bl
	jz par ;; jz -> salta si es cero

impar:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, lenMsg2
	int 80h
	jmp salida

par:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, lenMsg1
	int 80h

salida:
	mov eax, 1
	mov ebx, 0
	int 80h