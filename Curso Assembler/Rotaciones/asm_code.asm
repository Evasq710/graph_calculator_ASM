section .data
	; Salto de línea y retorno de carro, para las impresiones
	ln db 10, 13
	lenln equ 2 ; constante

section .bss
	resultado resb 1

section .text

global _start

_start:
	
	mov bl, 128
	; 1 0 0 0 0 0 0 0

	;; ROTACIÓN A LA IZQUIERDA
	rol bl, 1
	; Al hacer 1 rotación a la izquierda, el 1 rota a la primera posición
	; bl: 0 0 0 0 0 0 0 1
	; CARRY: Copia del bit rotado -> 1
	; bl se convierte de 128 decimal a un 1 decimal gracias a la rotación

	add bl, 48

	mov [resultado], bl

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

	mov eax, 1
	mov ebx, 0
	int 0x80

	;;ROTACIONES ADICIONALES
	; ROR: Rotación a la derecha, el bit rotado se copia en el Carry
	; RCL: Rotación de acarreo a la izquierda, el bit que rota es el carry, y a este entra el último bit del registro
	; RCR: Rotación de acarreo a la derecha, el bit que rota es el del carry, y a este entra el primer bit del registro

