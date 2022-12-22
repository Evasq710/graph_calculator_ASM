%macro print 2
mov eax, 4
mov ebx, 1
mov ecx, %1
mov edx, %2
int 0x80
%endmacro

%macro read 2
mov eax, 3
mov ebx, 0
mov ecx, %1
mov edx, %2
int 0x80
%endmacro

section .data
	datos 		db '0', '0', '0', '0', '0', '0'
	lenDatos 	equ $-datos
	
	salto 		db 0xA, 0xD
	lenSalto 	equ $-salto

section .text
global _start

_start:

	;; RECORRIENDO EL ARRAY DINÁMICAMENTE

	;; Copiando la dirección de memoria del array en EBP
	mov ebp, datos
	;; Contador auxiliar
	mov edi, 0

ciclo_lectura:
	read ebp, 1 ;; leyendo 1 solo valor

	add ebp, 1
	add edi, 1
	cmp edi, lenDatos
	jb ciclo_lectura ;; Salta si edi < lenDatos


	mov ebp, datos
	mov edi, 0

ciclo_escritura:
	print ebp, 1
	print salto, lenSalto

	add ebp, 1
	add edi, 1
	cmp edi, lenDatos
	jb ciclo_escritura ;; Salta si edi < lenDatos


	; Fin
	mov eax, 1
	mov ebx, 0
	int 0x80
