;;eax = 3;
;;ebx = 0;
;;while(eax>0){
;;	ebx = ebx + 2;
;;	eax = eax - 1;
;;}

section .bss
	resultado resb 1

section .text

global _start

_start:
	mov eax, 3
	mov ebx, 0

while:
	cmp eax, 0
	jna salida ;; jna -> si el resultado de CMP no fue mayor, salir

	add ebx, 2
	sub eax, 1

	jmp while

salida:
	add ebx, 48 ; ascii

	mov [resultado], ebx

	;Impresión
	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 1
	int 0x80
	
	;Fin
	mov eax, 1
	mov ebx, 0
	int 80h