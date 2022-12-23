;; MACRO ESCRITURA EN PANTALLA
%macro print 2
mov eax, 4
mov ebx, 1
mov ecx, %1
mov edx, %2
int 0x80
%endmacro

;; MACRO IMPRIMIR NUM DE 2 DIGITOS
%macro printTwoDigits 1
mov bl, 10 	; BL: Fuente de 8 bits
mov al, %1	; AL: Resultado
mov ah, 0	; AH: Residuo

div bl ;Dividiendo AL / BL
mov [residuo], ah

add al, 48 ; ascii
mov [cociente], al
print cociente, 1

mov ah, [residuo]
add ah, 48 ; ascii
mov [residuo], ah
print residuo, 1
%endmacro

;; MACRO IMPRIMIR NUM DE 3 DIGITOS
%macro printThreeDigits 1
mov bl, 100	; BL: Fuente de 8 bits
mov al, %1	; AL: Resultado
mov ah, 0	; AH: Residuo

div bl ;Dividiendo AL / BL
mov [residuo], ah

add al, 48 ; ascii
mov [cociente], al
print cociente, 1

printTwoDigits [residuo]
%endmacro

;; MACRO IMPRIMIR NÚMERO
%macro printNumber 1
mov cl, %1

mov bl, 100	; BL: Fuente de 8 bits
mov al, cl	; AL: Resultado
mov ah, 0	; AH: Residuo

div bl 		;Dividiendo AL / BL
cmp al, 0
jne %%three	;Si el resultado no es cero, 3 digitos

mov bl, 10
mov al, cl	; AL: Resultado
mov ah, 0	; AH: Residuo

div bl	;Dividiendo AL / BL
cmp al, 0
jne %%two	;Si el resultado no es cero, 2 digitos

jmp %%one	;Un digito

%%three:
printThreeDigits cl
jmp %%exit_macro
%%two:
printTwoDigits cl
jmp %%exit_macro
%%one:
add cl, 48	; ascii
mov [byte_aux1], cl
print byte_aux1, 1
%%exit_macro:

%endmacro

;; MACRO IMPRIMIR NÚMERO DECIMAL PARA RESULTADO DE INTEGRALES
; %1 -> parte entera
; %2 -> residuo
; %3 -> x type
; %4 -> x len
; %5 -> # coeficiente
; %6 -> ¿Imprimir '+'? 1:y, 0:n
%macro printDecimalNumber 6
	; Activando la bandera de signo
	mov al, %1
	add al, 0
	js %%negative
	mov al, %2
	add al, 0
	js %%negative
; POSITIVO
	; imprimiendo el valor entero
	mov al, %6
	cmp al, 0
	je %%no_sign
	print plus, len_plus
%%no_sign:
	mov al, %1
	printNumber al
	; parte resigual
	mov al, %2
	cmp al, 0
	je %%print1_x
	; transformando parte residual a 1 decimal
	print dot, 1
	mov al, %2	
	mov bl, 10	
	mul bl ; en este punto, residuo * 10 = AL
	mov ah, 0
	mov bl, %5
	div bl
	printNumber al ; imprimiendo 1 decimal
%%print1_x:
	print %3, %4
	jmp %%exit_print_decimal
%%negative:
	; imprimiendo el complemento a 2
	print minus, len_minus
	mov al, %1
	neg al
	printNumber al
	; parte resigual
	mov al, %2
	cmp al, 0
	je %%print2_x
	; transformando parte residual a 1 decimal
	print dot, 1
	mov al, %2
	neg al
	mov bl, 10
	mul bl ; en este punto, residuo * 10 = AL
	mov ah, 0
	mov bl, %5
	div bl
	printNumber al ; imprimiendo 1 decimal
%%print2_x:
	print %3, %4
%%exit_print_decimal:

%endmacro

;; MACRO IMPRIMIR INTEGRAL COMO SUMA DE FRACCIONES
; %1 -> numerador (coeficiente funcion original)
; %2 -> denominador (# coeficiente actual)
; %3 -> x type
; %4 -> x len
; %5 -> ¿Imprimir '+'? 1:y, 0:n
%macro printFraction 5
	; Activando la bandera de signo
	mov al, %1
	add al, 0
	js %%negative_fraction
; POSITIVO
	; imprimiendo el valor entero
	mov al, %5
	cmp al, 0
	je %%no_sign_fraction
	print plus, len_plus
%%no_sign_fraction:
	mov al, %1
	printNumber al
	print slash, 1 ; /
	mov al, %2
	printNumber al
	print space, 1
	print %3, %4
	jmp %%exit_print_fraction
%%negative_fraction:
	; imprimiendo el complemento a 2
	print minus, len_minus
	mov al, %1
	neg al
	printNumber al
	print slash, 1 ; /
	mov al, %2
	printNumber al
	print space, 1
	print %3, %4
%%exit_print_fraction:

%endmacro

;; MACRO LECTURA DE TECLADO
%macro read 2
mov eax, 3
mov ebx, 0
mov ecx, %1
mov edx, %2
int 0x80
%endmacro


section .data
	;; DEFINIENDO TEXTOS DE MENÚS
	text_menu	db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "1. Ingresar los coeficientes de la funcion.", 0xA, 0xD, "2. Imprimir la funcion almacenada.", 0xA, 0xD, "3. Imprimir la derivada de la funcion almacenada.", 0xA, 0xD, "4. Imprimir la integral de la funcion almacenada.", 0xA, 0xD, "5. Graficar la funcion original, derivada o integral.", 0xA, 0xD, "6. Encontrar los ceros de la funcion por el metodo de Newton.", 0xA, 0xD, "7. Encontrar los ceros de la funcion por el metodo de Steffensen", 0xA, 0xD, "8. Salir de la aplicacion.", 0xA, 0xD, "> Ingrese el numero de la opcion que desee realizar: "
	len_menu	equ	$-text_menu

	text1		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(1) Ingresar los coeficientes de la funcion.", 0xA, 0xD
	len_text1	equ	$-text1
	text1_0		db 	"> Ingrese el coeficiente de x⁰: "
	len_text1_0	equ	$-text1_0
	text1_1		db 	"> Ingrese el coeficiente de x¹: "
	len_text1_1	equ	$-text1_1
	text1_2		db 	"> Ingrese el coeficiente de x²: "
	len_text1_2	equ	$-text1_2
	text1_3		db 	"> Ingrese el coeficiente de x³: "
	len_text1_3	equ	$-text1_3
	text1_4		db 	"> Ingrese el coeficiente de x⁴: "
	len_text1_4	equ	$-text1_4
	text1_5		db 	"> Ingrese el coeficiente de x⁵: "
	len_text1_5	equ	$-text1_5
	success_1	db	0xA, 0xD, "> Coeficientes ingresados con exito.", 0xA, 0xD
	len_succ_1	equ $-success_1

	text2		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(2) Imprimir la funcion almacenada.", 0xA, 0xD
	len_text2	equ	$-text2
	text2_0		db	"Grado de la funcion: "
	len_text2_0	equ $-text2_0
	text2_1		db	"f(x) = "
	len_text2_1	equ $-text2_1
	plus		db	" + "
	len_plus	equ	$-plus
	minus		db	" - "
	len_minus	equ	$-minus
	x_one		db	"x"
	len_x_one	equ $-x_one
	x_two		db	"x²"
	len_x_two	equ $-x_two
	x_three		db	"x³"
	len_x_three	equ $-x_three
	x_four		db	"x⁴"
	len_x_four	equ $-x_four
	x_five		db	"x⁵"
	len_x_five	equ $-x_five
	; para integrales
	x_six		db	"x⁶"
	len_x_six	equ $-x_six

	text3		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(3) Imprimir la derivada de la funcion almacenada.", 0xA, 0xD
	len_text3	equ	$-text3
	text3_0		db	"Derivada:", 0xA, 0xD
	len_text3_0	equ $-text3_0
	text3_1		db	"f", 39 , "(x) = "
	len_text3_1	equ $-text3_1

	text4		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(4) Imprimir la integral de la funcion almacenada.", 0xA, 0xD
	len_text4	equ	$-text4
	text4_0		db	"INTEGRAL(f(x)dx) = "
	len_text4_0	equ $-text4_0
	text4_1		db	"Integral:", 0xA, 0xD
	len_text4_1	equ $-text4_1
	text4_2		db	"Integral truncada a 1 decimal:", 0xA, 0xD
	len_text4_2	equ $-text4_2
	slash		db	"/"
	dot 		db 	"."
	constant	db	"C"

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

	; error de entrada inválida en opción 1
	error2		db	"> Error, se detecto una entrada invalida. Valor a asignar al coeficiente: 0", 0xA, 0xD
	len_error2	equ	$-error2

	; salto de línea
	ln  		db 	0xA, 0xD
	; espacio
	space 		db 	" "

	;; DEFINIENDO COEFICIENTES DE FUNCIÓN ORIGINAL (-128 (-2⁷) hasta 128 (2⁷))
	degree		db	0
	coef_0		db	0
	coef_1		db	0
	coef_2		db	0
	coef_3		db	0
	coef_4		db	0
	coef_5		db	0

	;; DEFINIENDO COEFICIENTES DE DERIVADA (-128 (-2⁷) hasta 128 (2⁷))
	deriv_deg	db	0
	deriv_c0	db	0
	deriv_c1	db	0
	deriv_c2	db	0
	deriv_c3	db	0
	deriv_c4	db	0
	
	;; DEFINIENDO PARTE ENTERA Y RESIDUAL DE INTEGRAL
	integ_deg	db	0
	integ_e1	db	0
	integ_d1	db	0
	integ_e2	db	0
	integ_d2	db	0
	integ_e3	db	0
	integ_d3	db	0
	integ_e4	db	0
	integ_d4	db	0
	integ_e5	db	0
	integ_d5	db	0
	integ_e6	db	0
	integ_d6	db	0


;; RESERVANDO ESPACIOS
section .bss
	; Buffer de lectura
	buffer_in	resb 16
	; Byte para almacenar texto
	byte_aux1	resb 1
	byte_aux2	resb 1
	byte_aux3	resb 1
	; Bytes para almacenar cocientes y residuos
	cociente 	resb 1
	residuo		resb 1


;; ÁREA DE CÓDIGO
section .text

;; PROCEDIMIENTO LECTURA DE NÚMERO
;; DL: Valor de coeficiente
;; byte_aux1: Positivo o negativo
READ_NUMBER:
	read buffer_in, 16
	cld
	xor esi, esi ; limpiando el registro
	mov esi, buffer_in

	mov cl, 0 ; aux
	mov dl, 0 ; coeficiente
	mov [byte_aux1], cl ; 0 positivo, 1 negativo

	lodsb
	; Verificando si se saltó el coeficiente
	cmp al, 10
	je exit_reading
	; Verificando si se ingresó signo
	cmp al, '-'
	je with_minus
	cmp al, '+'
	je with_plus
	; Verificando que sea número
	cmp al, '0'
	jb entry_readNum_error
	cmp al, '9'
	jbe reading
	; Entrada inválida
	jmp entry_readNum_error
with_minus:
	mov cl, 1
	mov [byte_aux1], cl ; negativo
	lodsb
	cmp al, '0'
	jb entry_readNum_error
	cmp al, '9'
	ja entry_readNum_error
	jmp reading
with_plus:
	lodsb
	cmp al, '0'
	jb entry_readNum_error
	cmp al, '9'
	ja entry_readNum_error
reading:
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10

	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL), en AL está el resultado

	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el coeficiente actual en DL

	lodsb
	cmp al, 10
	je exit_reading ; si es igual, siguiente coeficiente
	cmp al, '0'
	jb entry_readNum_error ; si es menor, error en la entrada
	cmp al, '9'
	jbe reading ; si es menor o igual, entrada correcta
entry_readNum_error:
	print error2, len_error2
	mov dl, 0
	mov [byte_aux1], dl
exit_reading:
	ret ;; Para que vuelva a la ejecución desde el punto en que se llamó


;; INICIO DE EJECUCIÓN DE PROGRAMA
global _start

_start:

MENU:

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
	je OPTION_1
	cmp al, '2'
	je OPTION_2
	cmp al, '3'
	je OPTION_3
	cmp al, '4'
	je OPTION_4
	cmp al, '5'
	je OPTION_5
	cmp al, '6'
	je OPTION_6
	cmp al, '7'
	je OPTION_7
	cmp al, '8'
	je EXIT_PROGRAM

entry_error:
	; ENTRADA INVÁLIDA
	print error1, len_error1
	print buffer_in, 16
	print ln, 2
	jmp MENU


OPTION_1:
	;; Ingresar los coeficientes de la funcion
	print text1, len_text1

	; COEFICIENTE 0
	print text1_0, len_text1_0
	call READ_NUMBER ; llamando al procedimiento de lectura de número
	mov [coef_0], dl ; copiando el valor del registro DL al coeficiente 0
	mov cl, 0
	cmp [byte_aux1], cl
	je read_coef_1
	; Guardando complemento a 2 del número al ser negativo
	neg dl
	mov [coef_0], dl
read_coef_1:
	; COEFICIENTE 1
	print text1_1, len_text1_1
	call READ_NUMBER ; llamando al procedimiento de lectura de número
	cmp dl, 0
	je no_update_1
	; Actualizando el grado de la función
	mov cl, 1
	mov [degree], cl
no_update_1:
	mov [coef_1], dl ; copiando el valor del registro DL al coeficiente 1
	mov cl, 0
	cmp [byte_aux1], cl
	je read_coef_2
	; Guardando complemento a 2 del número al ser negativo
	neg dl
	mov [coef_1], dl
read_coef_2:
	; COEFICIENTE 2
	print text1_2, len_text1_2
	call READ_NUMBER ; llamando al procedimiento de lectura de número
	cmp dl, 0
	je no_update_2
	; Actualizando el grado de la función
	mov cl, 2
	mov [degree], cl
no_update_2:
	mov [coef_2], dl ; copiando el valor del registro DL al coeficiente 2
	mov cl, 0
	cmp [byte_aux1], cl
	je read_coef_3
	; Guardando complemento a 2 del número al ser negativo
	neg dl
	mov [coef_2], dl
read_coef_3:
	; COEFICIENTE 3
	print text1_3, len_text1_3
	call READ_NUMBER ; llamando al procedimiento de lectura de número
	cmp dl, 0
	je no_update_3
	; Actualizando el grado de la función
	mov cl, 3
	mov [degree], cl
no_update_3:
	mov [coef_3], dl ; copiando el valor del registro DL al coeficiente 3
	mov cl, 0
	cmp [byte_aux1], cl
	je read_coef_4
	; Guardando complemento a 2 del número al ser negativo
	neg dl
	mov [coef_3], dl
read_coef_4:
	; COEFICIENTE 4
	print text1_4, len_text1_4
	call READ_NUMBER ; llamando al procedimiento de lectura de número
	cmp dl, 0
	je no_update_4
	; Actualizando el grado de la función
	mov cl, 4
	mov [degree], cl
no_update_4:
	mov [coef_4], dl ; copiando el valor del registro DL al coeficiente 4
	mov cl, 0
	cmp [byte_aux1], cl
	je read_coef_5
	; Guardando complemento a 2 del número al ser negativo
	neg dl
	mov [coef_4], dl
read_coef_5:
	; COEFICIENTE 5
	print text1_5, len_text1_5
	call READ_NUMBER ; llamando al procedimiento de lectura de número
	cmp dl, 0
	je no_update_5
	; Actualizando el grado de la función
	mov cl, 5
	mov [degree], cl
no_update_5:
	mov [coef_5], dl ; copiando el valor del registro DL al coeficiente 5
	mov cl, 0
	cmp [byte_aux1], cl
	je end_coefs
	; Guardando complemento a 2 del número al ser negativo
	neg dl
	mov [coef_5], dl
end_coefs:
	print success_1, len_succ_1
	print ln, 2

	jmp MENU


OPTION_2:
	print text2, len_text2
	print ln, 2
	; Imprimiendo grado de función
	print text2_0, len_text2_0
	mov al, [degree]
	add al, 48 ; transformando a ascii
	mov [byte_aux1], al
	print byte_aux1, 1
	print ln, 2
	;Imprimiendo función
	print text2_1, len_text2_1
print_5:
	mov al, [coef_5]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_5
	print minus, len_minus
	mov al, [coef_5]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_five, len_x_five
	jmp print_4
no_complement_5:
	printNumber al ; imprimiendo el valor normal
	print x_five, len_x_five
print_4:
	mov al, [coef_4]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_4
	print minus, len_minus
	mov al, [coef_4]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_four, len_x_four
	jmp print_3
no_complement_4:
	print plus, len_plus
	mov al, [coef_4]
	printNumber al ; imprimiendo el valor normal
	print x_four, len_x_four
print_3:
	mov al, [coef_3]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_3
	print minus, len_minus
	mov al, [coef_3]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_three, len_x_three
	jmp print_2
no_complement_3:
	print plus, len_plus
	mov al, [coef_3]
	printNumber al ; imprimiendo el valor normal
	print x_three, len_x_three
print_2:
	mov al, [coef_2]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_2
	print minus, len_minus
	mov al, [coef_2]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_two, len_x_two
	jmp print_1
no_complement_2:
	print plus, len_plus
	mov al, [coef_2]
	printNumber al ; imprimiendo el valor normal
	print x_two, len_x_two
print_1:
	mov al, [coef_1]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_1
	print minus, len_minus
	mov al, [coef_1]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_one, len_x_one
	jmp print_0
no_complement_1:
	print plus, len_plus
	mov al, [coef_1]
	printNumber al ; imprimiendo el valor normal
	print x_one, len_x_one
print_0:
	mov al, [coef_0]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_0
	print minus, len_minus
	mov al, [coef_0]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	jmp end_print
no_complement_0:
	print plus, len_plus
	mov al, [coef_0]
	printNumber al ; imprimiendo el valor normal
end_print:
	print ln, 2
	print ln, 2

	jmp MENU

;; DERIVADA
OPTION_3:
	print text3, len_text3
	print ln, 2

	; Calculando derivada
	; TODO deriv_deg
	;5*coef_5 = deriv_c4
	mov al, [coef_5]
	mov bl, 5
	mul bl
	mov [deriv_c4], al
	;4*coef_4 = deriv_c3
	mov al, [coef_4]
	mov bl, 4
	mul bl
	mov [deriv_c3], al
	;3*coef_3 = deriv_c2
	mov al, [coef_3]
	mov bl, 3
	mul bl
	mov [deriv_c2], al
	;2*coef_2 = deriv_c1
	mov al, [coef_2]
	mov bl, 2
	mul bl
	mov [deriv_c1], al
	;coef_1 = deriv_c0
	mov al, [coef_1]
	mov [deriv_c0], al
	
	; Imprimiendo derivada
	print text3_0, len_text3_0
	print text3_1, len_text3_1 ; f'(x) =
print_d4:
	mov al, [deriv_c4]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d4
	print minus, len_minus
	mov al, [deriv_c4]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_four, len_x_four
	jmp print_d3
no_complement_d4:
	mov al, [deriv_c4]
	printNumber al ; imprimiendo el valor normal
	print x_four, len_x_four
print_d3:
	mov al, [deriv_c3]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d3
	print minus, len_minus
	mov al, [deriv_c3]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_three, len_x_three
	jmp print_d2
no_complement_d3:
	print plus, len_plus
	mov al, [deriv_c3]
	printNumber al ; imprimiendo el valor normal
	print x_three, len_x_three
print_d2:
	mov al, [deriv_c2]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d2
	print minus, len_minus
	mov al, [deriv_c2]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_two, len_x_two
	jmp print_d1
no_complement_d2:
	print plus, len_plus
	mov al, [deriv_c2]
	printNumber al ; imprimiendo el valor normal
	print x_two, len_x_two
print_d1:
	mov al, [deriv_c1]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d1
	print minus, len_minus
	mov al, [deriv_c1]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_one, len_x_one
	jmp print_d0
no_complement_d1:
	print plus, len_plus
	mov al, [deriv_c1]
	printNumber al ; imprimiendo el valor normal
	print x_one, len_x_one
print_d0:
	mov al, [deriv_c0]
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d0
	print minus, len_minus
	mov al, [deriv_c0]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	jmp end_print_deriv
no_complement_d0:
	print plus, len_plus
	mov al, [deriv_c0]
	printNumber al ; imprimiendo el valor normal
end_print_deriv:
	print ln, 2
	print ln, 2

	jmp MENU


;; INTEGRAL
OPTION_4:
	print text4, len_text4
	print ln, 2

	; TODO integ_deg

	; CALCULANDO INTEGRAL
	; Guardando la división truncada en los coeficientes del resultado
	;coef_5 / 6 = integ_c6
	mov al, [coef_5]
	mov ah, 0
	cbw ; Extendiendo el bit de signo de AL a AH para el residuo
	mov bl, 6
	idiv bl
	mov [integ_e6], al
	mov [integ_d6], ah
	;coef_4 / 5 = integ_c5
	mov al, [coef_4]
	mov ah, 0
	cbw ; Extendiendo el bit de signo de AL a AH para el residuo
	mov bl, 5
	idiv bl
	mov [integ_e5], al
	mov [integ_d5], ah
	;coef_3 / 4 = integ_c4
	mov al, [coef_3]
	mov ah, 0
	cbw ; Extendiendo el bit de signo de AL a AH para el residuo
	mov bl, 4
	idiv bl
	mov [integ_e4], al
	mov [integ_d4], ah
	;coef_2 / 3 = integ_c3
	mov al, [coef_2]
	mov ah, 0
	cbw ; Extendiendo el bit de signo de AL a AH para el residuo
	mov bl, 3
	idiv bl
	mov [integ_e3], al
	mov [integ_d3], ah
	;coef_1 / 2 = integ_c2
	mov al, [coef_1]
	mov ah, 0
	cbw ; Extendiendo el bit de signo de AL a AH para el residuo
	mov bl, 2
	idiv bl
	mov [integ_e2], al
	mov [integ_d2], ah
	;coef_0 = integ_c1
	mov al, [coef_0]
	mov ah, 0
	mov [integ_e1], al
	mov [integ_d1], ah
	;constante

	; Mostrando la división tal cual
	print text4_1, len_text4_1
	print text4_0, len_text4_0

	;; Parámetros macro printFraction
	; %1 -> numerador (coeficiente funcion original)
	; %2 -> denominador (# coeficiente actual)
	; %3 -> x type
	; %4 -> x len
	; %5 -> ¿Imprimir '+'? 1:y, 0:n

	mov al, 6
	mov [byte_aux2], al
	mov al, 0
	mov [byte_aux3], al
	printFraction [coef_5], [byte_aux2], x_six, len_x_six, [byte_aux3]
	mov al, 5
	mov [byte_aux2], al
	mov al, 1
	mov [byte_aux3], al
	printFraction [coef_4], [byte_aux2], x_five, len_x_five, [byte_aux3]
	mov al, 4
	mov [byte_aux2], al
	printFraction [coef_3], [byte_aux2], x_four, len_x_four, [byte_aux3]
	mov al, 3
	mov [byte_aux2], al
	printFraction [coef_2], [byte_aux2], x_three, len_x_three, [byte_aux3]
	mov al, 2
	mov [byte_aux2], al
	printFraction [coef_1], [byte_aux2], x_two, len_x_two, [byte_aux3]
	mov al, 1
	mov [byte_aux2], al
	printFraction [coef_0], [byte_aux2], x_one, len_x_one, [byte_aux3]

	print plus, len_plus
	print constant, 1
	print ln, 2
	print ln, 2


	; Mostrando la división truncada a 1 decimal
	print text4_2, len_text4_2
	print text4_0, len_text4_0

	; Parámetros macro printDecimalNumber
	; %1 -> parte entera
	; %2 -> residuo
	; %3 -> x type
	; %4 -> x len
	; %5 -> # coeficiente
	; %6 -> ¿Imprimir '+'? 1:y, 0:n

	mov al, 6
	mov [byte_aux2], al
	mov al, 0
	mov [byte_aux3], al
	printDecimalNumber [integ_e6], [integ_d6], x_six, len_x_six, [byte_aux2], [byte_aux3]
	mov al, 5
	mov [byte_aux2], al
	mov al, 1
	mov [byte_aux3], al
	printDecimalNumber [integ_e5], [integ_d5], x_five, len_x_five, [byte_aux2], [byte_aux3]
	mov al, 4
	mov [byte_aux2], al
	printDecimalNumber [integ_e4], [integ_d4], x_four, len_x_four, [byte_aux2], [byte_aux3]
	mov al, 3
	mov [byte_aux2], al
	printDecimalNumber [integ_e3], [integ_d3], x_three, len_x_three, [byte_aux2], [byte_aux3]
	mov al, 2
	mov [byte_aux2], al
	printDecimalNumber [integ_e2], [integ_d2], x_two, len_x_two, [byte_aux2], [byte_aux3]
	mov al, 1
	mov [byte_aux2], al
	printDecimalNumber [integ_e1], [integ_d1], x_one, len_x_one, [byte_aux2], [byte_aux3]

	print plus, len_plus
	print constant, 1
	print ln, 2
	print ln, 2

	jmp MENU


OPTION_5:
	print text5, len_text5
	print ln, 2
	jmp MENU


OPTION_6:
	print text6, len_text6
	print ln, 2
	jmp MENU


OPTION_7:
	print text7, len_text7
	print ln, 2
	jmp MENU


EXIT_PROGRAM:
	print text8, len_text8

	mov eax, 1
	mov ebx, 0
	int 0x80
