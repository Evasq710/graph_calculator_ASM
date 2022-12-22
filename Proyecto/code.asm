;; MACROS DE LECTURA Y ESCRITURA EN PANTALLA
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

;; DEFINIENDO TEXTOS DE MENÚS
section .data
	text_menu	db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "1. Ingresar los coeficientes de la funcion.", 0xA, 0xD, "2. Imprimir la funcion almacenada.", 0xA, 0xD, "3. Imprimir la derivada de la funcion almacenada.", 0xA, 0xD, "4. Imprimir la integral de la funcion almacenada.", 0xA, 0xD, "5. Graficar la funcion original, derivada o integral.", 0xA, 0xD, "6. Encontrar los ceros de la funcion por el metodo de Newton.", 0xA, 0xD, "7. Encontrar los ceros de la funcion por el metodo de Steffensen", 0xA, 0xD, "8. Salir de la aplicacion.", 0xA, 0xD, "Ingrese el numero de la opcion que desee realizar: "
	len_menu	equ	$-text_menu

	text1		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(1) Ingresar los coeficientes de la funcion.", 0xA, 0xD
	len_text1	equ	$-text1

	text2		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(2) Imprimir la funcion almacenada.", 0xA, 0xD
	len_text2	equ	$-text2

	text3		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(3) Imprimir la derivada de la funcion almacenada.", 0xA, 0xD
	len_text3	equ	$-text3

	text4		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(4) Imprimir la integral de la funcion almacenada.", 0xA, 0xD
	len_text4	equ	$-text4

	text5		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(5) Graficar la funcion original, derivada o integral.", 0xA, 0xD
	len_text5	equ	$-text5

	text6		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(6) Encontrar los ceros de la funcion por el metodo de Newton.", 0xA, 0xD
	len_text6	equ	$-text6

	text7		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(7) Encontrar los ceros de la funcion por el metodo de Steffensen.", 0xA, 0xD
	len_text7	equ	$-text7

	text8		db	"Gracias por utilizar esta aplicacion. :)", 0xA, 0xD
	len_text8	equ	$-text8

	; error de entrada inválida
	error1		db	"> Error, ingrese una opcion valida. Entrada detectada: "
	len_error1	equ	$-error1

	; salto de línea
	ln  		db 	0xA, 0xD


;; RESERVANDO ESPACIOS
section .bss
	buffer_in	resb 16 ; buffer de lectura


;; ÁREA DE CÓDIGO
section .text

global _start

_start:

menu:

	print text_menu, len_menu

	; leyendo entrada del teclado
	read buffer_in, 16

	print ln, 2

	cld
	xor esi, esi ; limpiando el registro para almacenar en él la entrada
	mov esi, buffer_in
	lodsw ; toma los dos primeros bytes del registro ESI y lo guarda en AL y AH

	; SI LA PARTE ALTA ES DIFERENTE A \n, ENTRADA INVÁLIDA
	cmp ah, 10
	jne entry_error

	; SALTANDO A LA OPCIÓN QUE SE HAYA ESCOGIDO
	cmp al, '1'
	je option_1
	cmp al, '2'
	je option_2
	cmp al, '3'
	je option_3
	cmp al, '4'
	je option_4
	cmp al, '5'
	je option_5
	cmp al, '6'
	je option_6
	cmp al, '7'
	je option_7
	cmp al, '8'
	je exit

entry_error:
	; SI ENTRA AQUÍ, SE DETECTÓ UNA ENTRADA INVÁLIDA
	print error1, len_error1
	print buffer_in, 16
	print ln, 2
	jmp menu

option_1:
	print text1, len_text1
	print ln, 2
	jmp menu
option_2:
	print text2, len_text2
	print ln, 2
	jmp menu
option_3:
	print text3, len_text3
	print ln, 2
	jmp menu
option_4:
	print text4, len_text4
	print ln, 2
	jmp menu
option_5:
	print text5, len_text5
	print ln, 2
	jmp menu
option_6:
	print text6, len_text6
	print ln, 2
	jmp menu
option_7:
	print text7, len_text7
	print ln, 2
	jmp menu

exit:
	print text8, len_text8

	mov eax, 1
	mov ebx, 0
	int 0x80
