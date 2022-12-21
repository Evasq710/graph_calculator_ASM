section .bss
	resultado resb 1

section .text
global _start
_start:
	;; ebx = 9;
	;; if(eax==5)
	;;{
	;;	ebx = 1;
	;;}
	;; else
	;;{
	;;	ebx = 0;
	;;}
	;; print(ebx)

	mov eax, 5
	mov ebx, 9

	cmp eax, 5
	jz cuerpo_if ;; si la comparación es 0, los dos son iguales

else:
	mov ebx, 0
	jmp salida

cuerpo_if:
	mov ebx, 1

salida:
	add ebx, 48
	mov [resultado], ebx

	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 1
	int 80h

	mov eax, 1
	mov ebx, 0
	int 80h