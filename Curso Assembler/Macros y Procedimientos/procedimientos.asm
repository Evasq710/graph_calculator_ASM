section .data
	msg1 db "mensaje 1", 0xA, 0xD
	len1 equ $-msg1
	msg2 db "mensaje 2", 0xA, 0xD
	len2 equ $-msg2

section .text

print:
	mov eax, 4
	mov ebx, 1
	int 0x80
	ret ;; Para que vuelva a la ejecución desde el punto en que se llamó


global _start

_start:
	mov ecx, msg1
	mov edx, len1
	call print ;; Salta al procedimiento 'print'

	mov ecx, msg2
	mov edx, len2
	call print

	mov eax, 1
	mov ebx, 0
	int 0x80