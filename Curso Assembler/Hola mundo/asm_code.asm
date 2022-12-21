;db -> define 1 byte:	8 bits
;dw -> define 2 bytes:	16 bits
;dd -> define 4 bytes:	32 bits
;dq -> define 8 bytes:	64 bits

section .data
msg db "Hola mundo!",0x0a, 0x0d
len equ $-msg	;Busca al centinela ($), para saber cuánto espacio ocupa 'msg', y lo guarda en la etiqueta 'len'

section .text
	global _start
_start:
mov eax, 4 ;indicando que se quiere escribir
mov ebx, 1 ;indicando que se quiere escribir en pantalla
mov ecx, msg ;indicando qué se quiere escribir
mov edx, len ;indicar cuántos bytes se van a imprimir
int 80h	;iniciar la interrupción

;finalizando con proceso exitoso
mov eax, 1
mov ebx, 0
int 0x80