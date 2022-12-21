section .data
	; Salto de línea y retorno de carro, para las impresiones
	ln db 10, 13
	lenln equ 2 ; constante

section .bss
	resultado resb 1

section .text

	global _start

_start:

	;; DESPLAZAMIENTO POR LA IZQUIERDA
	
	mov ebx, 2
	; ... 0 0 0 0 0 0 1 0

	; Desplazando el registro 1 bit a la izquierda
	shl ebx, 1
	; entra 0 por la izquierda
	; ... 0 0 0 0 0 1 0 0 <----
	; CARRY: 0 (el que salió)
	; Ahora EBX es un 4, osea, SE MULTIPLICÓ POR 2^(bits desplazados)

	add ebx, 48 ;ascii
	mov [resultado], ebx

	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 1
	int 0x80

	; IMPRIMIENDO SALTO DE LÍNEA Y RETORNO
	mov eax, 4
	mov ebx, 1
	mov ecx, ln
	mov edx, lenln
	int 0x80



	;; DESPLAZAMIENTO POR LA DERECHA
	
	mov ebx, 8
	; ... 0 0 0 0 1 0 0 0

	; Desplazando el registro 2 bits a la derecha
	shr ebx, 2
	;; TAMBIÉN:
	;mov cl, 2
	;shr ebx, cl
	;(solo se puede usar el registro CL)

	; entran 2 ceros por la derecha
	; ---> ... 0 0 0 0 0 0 1 0
	; CARRY: 0 (el que salió)??
	; Ahora EBX es un 2, osea, SE DIVIDIÓ DENTRO DE 2^(bits desplazados)

	add ebx, 48 ;ascii
	mov [resultado], ebx

	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 1
	int 0x80

	; IMPRIMIENDO SALTO DE LÍNEA Y RETORNO
	mov eax, 4
	mov ebx, 1
	mov ecx, ln
	mov edx, lenln
	int 0x80


	;; FIN
	mov eax, 1
	mov ebx, 0
	int 0x80