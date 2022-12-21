section .data
result db '0'

;DATOS NO INICIALIZADOS
section .bss
result2 resb 1 ;reservando espacio de 1 byte

section .text
	global _start
_start:
;SUMA
mov eax, 2
mov ebx, 3

add eax, ebx ;eax += ebx

add eax, 48 ; para convertir el número a su representación ASCII

mov [result], eax ; indicando que se quiere modificar el valor de etiqueta en result, no la etiqueta de memoria en si

;Mostrando la suma en pantalla
mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, 1 ; indicando que se quiere imprimir 1 dato
int 0x80


;RESTA
mov eax, 8
mov ebx, 1

sub eax, ebx ;eax -= ebx

add eax, 48 ; para convertir el número a su representación ASCII

mov [result2], eax

;Mostrando la resta en pantalla
mov eax, 4
mov ebx, 1
mov ecx, result2
mov edx, 1 ; indicando que se quiere imprimir 1 dato
int 0x80

;finalizando con proceso exitoso
mov eax, 1
mov ebx, 0
int 80h