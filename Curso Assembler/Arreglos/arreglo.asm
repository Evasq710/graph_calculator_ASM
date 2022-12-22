%macro print 2
mov eax, 4
mov ebx, 1
mov ecx, %1
mov edx, %2
int 0x80
%endmacro

section .data
	datos 		db '45', '23', '11', '09', '56'
	lenDatos 	equ $-datos
	
	salto 		db 0xA, 0xD
	lenSalto 	equ $-salto

section .text
global _start

_start:

	;; RECORRIENDO EL ARRAY MANUALMENTE

	;;print datos, 2 ;; imprimiendo('45')
	;;print salto, lenSalto
	
	;;print datos+2, 2 ;; imprimiendo ('23')
	;;print salto, lenSalto

	;; RECORRIENDO EL ARRAY DINÁMICAMENTE

	;; Copiando la dirección de memoria del array en EBP
	mov ebp, datos
	;; Contador auxiliar
	mov edi, 0

ciclo:
	print ebp, 2
	print salto, lenSalto

	add ebp, 2 ;; Aumentando en 2 
	add edi, 2 ;; Aumentando en 2, para compararlo con el size del array
	cmp edi, lenDatos
	jb ciclo ;; Salta si edi < lenDatos


	; Fin
	mov eax, 1
	mov ebx, 0
	int 0x80
