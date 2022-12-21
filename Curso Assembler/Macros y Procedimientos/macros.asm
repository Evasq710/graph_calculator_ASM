;; Se le pueden pasar parámetros
;; No entran en ninguna sección o segmento

%macro print 2 ;; cantidad de parametros
mov eax, 4
mov ebx, 1
mov ecx, %1 ;; primer param
mov edx, %2 ;; segundo param
int 0x80
%endmacro

section .data
	msg1 db "mensaje 1", 0xA, 0xD
	len1 equ $-msg1
	msg2 db "mensaje 2", 0xA, 0xD
	len2 equ $-msg2

section .text

global _start

_start:
	;; Llamando a la macro, pasandole parámetros
	print msg1, len1
	print msg2, len2

	; Fin
	mov eax, 1
	mov ebx, 0
	int 0x80