;****************************************************************
; DEFINICIÓN DE MACROS
;****************************************************************

;; MACRO ESCRITURA EN PANTALLA
%macro print 2
mov ah, 40h ; ah=0x40 - "Write File or Device"
mov bx, 1 	; Device/handle: standard out (screen)
mov dx, %1 	; message's address in dx
mov cx, %2
int 0x21
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

;; MACRO IMPRIMIR NUM DE 4 DIGITOS GUARDADO EN 2 BYTES
%macro printWordFourDigits 1
mov bx, 1000; BX: Fuente de 16 bits
mov ax, %1	; AX: Resultado
mov dx, 0	; DX: Residuo

div bx 		;Dividiendo AX / BX
mov [word_aux1], dx

add ax, 48 ; ascii
mov [byte_aux1], al
print byte_aux1, 1

printWordThreeDigits [word_aux1]
%endmacro

;; MACRO IMPRIMIR NUM DE 3 DIGITOS GUARDADO EN 2 BYTES
%macro printWordThreeDigits 1
mov bx, 100	; BX: Fuente de 16 bits
mov ax, %1	; AX: Resultado
mov dx, 0	; DX: Residuo

div bx ;Dividiendo AX / BX
mov [word_aux1], dl

add ax, 48 ; ascii
mov [byte_aux1], al
print byte_aux1, 1

printTwoDigits [word_aux1]
%endmacro

;; MACRO IMPRIMIR NÚMERO GUARDADO EN 2 BYTES
%macro printWordNumber 1
mov cx, %1

mov bx, 1000	; BX: Fuente de 16 bits
mov ax, cx	; AX: Resultado
mov dx, 0	; DX: Residuo

div bx 		;Dividiendo AX / BX
cmp ax, 0
jne %%four	;Si el resultado no es cero, 4 digitos

mov bx, 100	; BX: Fuente de 16 bits
mov ax, cx	; AX: Resultado
mov dx, 0	; DX: Residuo

div bx 		;Dividiendo AX / BX
cmp ax, 0
jne %%three	;Si el resultado no es cero, 3 digitos

mov bx, 10
mov ax, cx	; AX: Resultado
mov dx, 0	; DX: Residuo

div bx	;Dividiendo AX / BX
cmp ax, 0
jne %%two	;Si el resultado no es cero, 2 digitos

jmp %%one	;Un digito

%%four:
printWordFourDigits cx
jmp %%exit_macro
%%three:
printWordThreeDigits cx
jmp %%exit_macro
%%two:
printTwoDigits cl
jmp %%exit_macro
%%one:
add cx, 48	; ascii
mov [byte_aux1], cl
print byte_aux1, 1
%%exit_macro:

%endmacro

;; MACRO IMPRIMIR NUM DE 3 DIGITOS GUARDADO EN 4 BYTES
%macro printDwordThreeDigits 1
mov ebx, 100	; EBX: Fuente de 32 bits
mov eax, %1	; EAX: Resultado
mov edx, 0	; EDX: Residuo

div ebx ;Dividiendo EAX / EBX
mov [byte_aux2], dl

add eax, 48 ; ascii
mov [byte_aux1], al
print byte_aux1, 1

printTwoDigits [byte_aux2]
%endmacro

;; MACRO IMPRIMIR NUM DE 4 DIGITOS GUARDADO EN 4 BYTES
%macro printDwordFourDigits 1
mov ebx, 1000; EBX: Fuente de 32 bits
mov eax, %1	; EAX: Resultado
mov edx, 0	; EDX: Residuo

div ebx 			;Dividiendo EAX / EBX
mov [dword_aux1], edx

add eax, 48 ; ascii
mov [byte_aux1], al
print byte_aux1, 1

printDwordThreeDigits [dword_aux1]
%endmacro

;; MACRO IMPRIMIR NUM DE 5 DIGITOS GUARDADO EN 4 BYTES
%macro printDwordFiveDigits 1
mov ebx, 10000; EBX: Fuente de 32 bits
mov eax, %1	; EAX: Resultado
mov edx, 0	; EDX: Residuo

div ebx 			;Dividiendo EAX / EBX
mov [dword_aux1], edx

add eax, 48 ; ascii
mov [byte_aux1], al
print byte_aux1, 1

printDwordFourDigits [dword_aux1]
%endmacro

;; MACRO IMPRIMIR NUM DE 6 DIGITOS GUARDADO EN 4 BYTES
%macro printDwordSixDigits 1
mov ebx, 100000; EBX: Fuente de 32 bits
mov eax, %1	; EAX: Resultado
mov edx, 0	; EDX: Residuo

div ebx 			;Dividiendo EAX / EBX
mov [dword_aux1], edx

add eax, 48 ; ascii
mov [byte_aux1], al
print byte_aux1, 1

printDwordFiveDigits [dword_aux1]
%endmacro

;; MACRO IMPRIMIR NÚMERO GUARDADO EN 4 BYTES
%macro printDwordNumber 1
mov ecx, %1

mov ebx, 100000	; EBX: Fuente de 32 bits
mov eax, ecx	; EAX: Resultado
mov edx, 0		; EDX: Residuo

div ebx 		;Dividiendo EAX / EBX
cmp eax, 0
jne %%six		;Si el resultado no es cero, 6 digitos

mov ebx, 10000	; EBX: Fuente de 32 bits
mov eax, ecx	; EAX: Resultado
mov edx, 0		; EDX: Residuo

div ebx 		;Dividiendo EAX / EBX
cmp eax, 0
jne %%five		;Si el resultado no es cero, 5 digitos

mov ebx, 1000	; EBX: Fuente de 32 bits
mov eax, ecx	; EAX: Resultado
mov edx, 0		; EDX: Residuo

div ebx 		;Dividiendo EAX / EBX
cmp eax, 0
jne %%four	;Si el resultado no es cero, 4 digitos

mov ebx, 100	; BX: Fuente de 16 bits
mov eax, ecx	; AX: Resultado
mov edx, 0	; DX: Residuo

div ebx 		;Dividiendo AX / BX
cmp eax, 0
jne %%three	;Si el resultado no es cero, 3 digitos

mov ebx, 10
mov eax, ecx	; AX: Resultado
mov edx, 0	; DX: Residuo

div ebx	;Dividiendo AX / BX
cmp eax, 0
jne %%two	;Si el resultado no es cero, 2 digitos

jmp %%one	;Un digito

%%six:
printDwordSixDigits ecx
jmp %%exit_macro
%%five:
printDwordFiveDigits ecx
jmp %%exit_macro
%%four:
printDwordFourDigits ecx
jmp %%exit_macro
%%three:
printDwordThreeDigits ecx
jmp %%exit_macro
%%two:
printTwoDigits cl
jmp %%exit_macro
%%one:
add ecx, 48	; ascii
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
mov ah, 3Fh ; "Read File or Device"
mov bx, 1 	; Device/handle: standard out (screen)
mov dx, %1 	; buffer a ser cargado; después de la llamada,
mov cx, %2
int 0x21
%endmacro

;; MACRO f(x)
; %1 -> x a evaluar en la función original
; El resultado se almacena en la variabe f_x
%macro evaluateOriginalFunction 1
	xor ax, ax
	xor dx, dx ; dx tendrá el resultado de la función
	mov al, [coef_0]
	cbw ; extendiendo el signo a AX
	mov dx, ax
	
	; AX = coef_1 * %1
	xor ax, ax
	mov bl, [coef_1]
	mov al, %1
	imul bl ; (AL * BL = AH:AL)
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negative1
	; DX += AX
	add dx, ax
	jmp %%evaluate_coef2
%%evaluate_negative1:
	add dx, ax
	jnc %%evaluate_coef2
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

	; AX = coef_2 * (%1 ^ 2)
%%evaluate_coef2:
	mov al, %1
	mov bl, %1
	imul bl ; AX = (%1 ^ 2)
	mov bx, ax
	xor ax, ax
	mov al, [coef_2]
	cbw ; extendiendo el signo del coeficiente a AX
	mov [f_x], dx ; para no perder el valor de DX
	imul bx ; (AX * BX = DX:AX)
	jo %%OF2
	; no hay OF, el signo resultante está en AX
	jmp %%test_coef2
%%OF2:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%test_coef2
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov cx, 32768 ; 10000000 00000000
	or ax, cx
%%test_coef2:
	mov dx, [f_x] ; recuperando DX
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negative2
	; DX += AX
	add dx, ax
	jmp %%evaluate_coef3
%%evaluate_negative2:
	add dx, ax
	jnc %%evaluate_coef3
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

	; AX = coef_3 * (%1 ^ 3)
%%evaluate_coef3:
	mov [f_x], dx ; para no perder el valor de DX
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov cx, 2 ;para el loop
	mov al, %1
	cbw ; extendiendo el signo a AX
	mov bx, ax ; copiandolo en bx
	; LOOP: AX = (%1 ^ 3)
%%loop3:
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_AX3
	; no hay OF, el signo resultante está en AX
	jmp %%end_loop3
%%OF_AX3:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%end_loop3
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov dx, 32768 ; 10000000 00000000
	or ax, dx
%%end_loop3:
	loop %%loop3
	; AX = (%1 ^ 3)
	mov bx, ax
	xor ax, ax
	xor dx, dx
	mov al, [coef_3]
	cbw ; extendiendo el signo del coeficiente a AX
	imul bx ; (AX * BX = DX:AX)
	jo %%OF3
	; no hay OF, el signo resultante está en AX
	jmp %%test_coef3
%%OF3:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%test_coef3
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov cx, 32768 ; 10000000 00000000
	or ax, cx
%%test_coef3:
	mov dx, [f_x] ; recuperando DX
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negative3
	; DX += AX
	add dx, ax
	jmp %%evaluate_coef4
%%evaluate_negative3:
	add dx, ax
	jnc %%evaluate_coef4
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

	; AX = coef_4 * (%1 ^ 4)
%%evaluate_coef4:
	mov [f_x], dx ; para no perder el valor de DX
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov cx, 3 ;para el loop
	mov al, %1
	cbw ; extendiendo el signo a AX
	mov bx, ax ; copiandolo en bx
	; LOOP: AX = (%1 ^ 4)
%%loop4:
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_AX4
	; no hay OF, el signo resultante está en AX
	jmp %%end_loop4
%%OF_AX4:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%end_loop4
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov dx, 32768 ; 10000000 00000000
	or ax, dx
%%end_loop4:
	loop %%loop4
	; AX = (%1 ^ 4)
	mov bx, ax
	xor ax, ax
	xor dx, dx
	mov al, [coef_4]
	cbw ; extendiendo el signo del coeficiente a AX
	imul bx ; (AX * BX = DX:AX)
	jo %%OF4
	; no hay OF, el signo resultante está en AX
	jmp %%test_coef4
%%OF4:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%test_coef4
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov cx, 32768 ; 10000000 00000000
	or ax, cx
%%test_coef4:
	mov dx, [f_x] ; recuperando DX
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negative4
	; DX += AX
	add dx, ax
	jmp %%evaluate_coef5
%%evaluate_negative4:
	add dx, ax
	jnc %%evaluate_coef5
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

	; AX = coef_5 * (%1 ^ 5)
%%evaluate_coef5:
	mov [f_x], dx ; para no perder el valor de DX
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov cx, 4 ;para el loop
	mov al, %1
	cbw ; extendiendo el signo a AX
	mov bx, ax ; copiandolo en bx
	; LOOP: AX = (%1 ^ 5)
%%loop5:
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_AX5
	; no hay OF, el signo resultante está en AX
	jmp %%end_loop5
%%OF_AX5:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%end_loop5
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov dx, 32768 ; 10000000 00000000
	or ax, dx
%%end_loop5:
	loop %%loop5
	; AX = (%1 ^ 5)
	mov bx, ax
	xor ax, ax
	xor dx, dx
	mov al, [coef_5]
	cbw ; extendiendo el signo del coeficiente a AX
	imul bx ; (AX * BX = DX:AX)
	jo %%OF5
	; no hay OF, el signo resultante está en AX
	jmp %%test_coef5
%%OF5:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%test_coef5
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov cx, 32768 ; 10000000 00000000
	or ax, cx
%%test_coef5:
	mov dx, [f_x] ; recuperando DX
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negative5
	; DX += AX
	add dx, ax
	jmp %%exit_f_x
%%evaluate_negative5:
	add dx, ax
	jnc %%exit_f_x
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

%%exit_f_x:
	mov [f_x], dx
%endmacro

;; MACRO f'(x)
; %1 -> x a evaluar en la derivada de la función original
; El resultado se almacena en la variabe f_prima_x
%macro evaluateDerivativeFunction 1
	xor ax, ax
	xor dx, dx ; dx tendrá el resultado de la función
	mov al, [deriv_c0]
	cbw ; extendiendo el signo a AX
	mov dx, ax
	
	; AX = deriv_c1 * %1
	xor ax, ax
	mov bl, [deriv_c1]
	mov al, %1
	imul bl ; (AL * BL = AH:AL)
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negatived1
	; DX += AX
	add dx, ax
	jmp %%evaluate_deriv2
%%evaluate_negatived1:
	add dx, ax
	jnc %%evaluate_deriv2
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

	; AX = deriv_c2 * (%1 ^ 2)
%%evaluate_deriv2:
	mov al, %1
	mov bl, %1
	imul bl ; AX = (%1 ^ 2)
	mov bx, ax
	xor ax, ax
	mov al, [deriv_c2]
	cbw ; extendiendo el signo del coeficiente a AX
	mov [f_prima_x], dx ; para no perder el valor de DX
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_DERIV2
	; no hay OF, el signo resultante está en AX
	jmp %%test_deriv2
%%OF_DERIV2:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%test_deriv2
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov cx, 32768 ; 10000000 00000000
	or ax, cx
%%test_deriv2:
	mov dx, [f_prima_x] ; recuperando DX
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negatived2
	; DX += AX
	add dx, ax
	jmp %%evaluate_deriv3
%%evaluate_negatived2:
	add dx, ax
	jnc %%evaluate_deriv3
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

	; AX = deriv_c3 * (%1 ^ 3)
%%evaluate_deriv3:
	mov [f_prima_x], dx ; para no perder el valor de DX
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov cx, 2 ;para el loop
	mov al, %1
	cbw ; extendiendo el signo a AX
	mov bx, ax ; copiandolo en bx
	; LOOP: AX = (%1 ^ 3)
%%loop_d3:
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_AX_d3
	; no hay OF, el signo resultante está en AX
	jmp %%end_loop_d3
%%OF_AX_d3:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%end_loop_d3
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov dx, 32768 ; 10000000 00000000
	or ax, dx
%%end_loop_d3:
	loop %%loop_d3
	; AX = (%1 ^ 3)
	mov bx, ax
	xor ax, ax
	xor dx, dx
	mov al, [deriv_c3]
	cbw ; extendiendo el signo del deriviciente a AX
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_DERIV3
	; no hay OF, el signo resultante está en AX
	jmp %%test_deriv3
%%OF_DERIV3:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%test_deriv3
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov cx, 32768 ; 10000000 00000000
	or ax, cx
%%test_deriv3:
	mov dx, [f_prima_x] ; recuperando DX
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negatived3
	; DX += AX
	add dx, ax
	jmp %%evaluate_deriv4
%%evaluate_negatived3:
	add dx, ax
	jnc %%evaluate_deriv4
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

	; AX = deriv_c4 * (%1 ^ 4)
%%evaluate_deriv4:
	mov [f_prima_x], dx ; para no perder el valor de DX
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov cx, 3 ;para el loop
	mov al, %1
	cbw ; extendiendo el signo a AX
	mov bx, ax ; copiandolo en bx
	; LOOP: AX = (%1 ^ 4)
%%loop_d4:
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_AX_d4
	; no hay OF, el signo resultante está en AX
	jmp %%end_loop_d4
%%OF_AX_d4:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%end_loop_d4
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov dx, 32768 ; 10000000 00000000
	or ax, dx
%%end_loop_d4:
	loop %%loop_d4
	; AX = (%1 ^ 4)
	mov bx, ax
	xor ax, ax
	xor dx, dx
	mov al, [deriv_c4]
	cbw ; extendiendo el signo del deriviciente a AX
	imul bx ; (AX * BX = DX:AX)
	jo %%OF_DERIV4
	; no hay OF, el signo resultante está en AX
	jmp %%test_deriv4
%%OF_DERIV4:
	; hay OF, el signo resultante está en DX
	test dx, dx
	jns %%test_deriv4
	; colocando el MSB de AX en 1 para indicar que es negativo
	mov cx, 32768 ; 10000000 00000000
	or ax, cx
%%test_deriv4:
	mov dx, [f_prima_x] ; recuperando DX
	test ax, ax ; para activar la bandera de signo
	js %%evaluate_negatived4
	; DX += AX
	add dx, ax
	jmp %%exit_f_prima_x
%%evaluate_negatived4:
	add dx, ax
	jnc %%exit_f_prima_x
	; hay acarreo
	mov cx, 32768 ; 10000000 00000000
	or dx, cx ; colocando el MSB en 1 para indicar que es negativo

%%exit_f_prima_x:
	mov [f_prima_x], dx
%endmacro

;; MACRO f(x)
; %1 -> x flotante a evaluar en la función original
; El resultado se almacena en la variabe dword_aux3
%macro evaluateFloatInOriginalFunction 1
	xor eax, eax
	mov [dword_aux3], eax ; limpiando var que guardará la respuesta
    mov ebx, %1 ; guardando valor a evaluar en EBX

	finit ; inicilizando stack de FPU

	; Operando con coef_5
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^2
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^3
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^4
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^5
	mov al, [coef_5]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push coef_5
    fmul ; st0 = coef_5 * %1^5

	; Operando con coef_4
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^2
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^3
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^4
	xor eax, eax
	mov al, [coef_4]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push coef_4
    fmul ; st0 = coef_4 * %1^4, st1 = COEF5

	; Operando con coef_3
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^2
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^3
	xor eax, eax
	mov al, [coef_3]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push coef_3
    fmul ; st0 = coef_3 * %1^3, st1 = COEF4, st2 = COEF5

	; Operando con coef_2
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^2
	xor eax, eax
	mov al, [coef_2]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push coef_2
    fmul ; st0 = coef_2 * %1^2, st1 = COEF3, st2 = COEF4, st3 = COEF5

	; Operando con coef_1
	xor eax, eax
	mov al, [coef_1]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push coef_1
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = coef_1 * %1, st1 = COEF2, st2 = COEF3, st3 = COEF4, st4 = COEF5

    fadd ; st0 = coef_1 * %1 + COEF2
    fadd ; st0 = st0 + COEF3
    fadd ; st0 = st0 + COEF4
    fadd ; st0 = st0 + COEF5

    ; Sumando el coef_0
	xor eax, eax
	mov al, [coef_0]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push coef_0 to fpu stack (st0)
    fadd ; st0 = st0 + st1

    fstp   dword [dword_aux3] ; guardando el resultado en dword_aux1

%endmacro


;; MACRO f'(x)
; %1 -> x flotante a evaluar en la derivada de la función original
; El resultado se almacena en la variabe dword_aux3
%macro evaluateFloatInDerivativeFunction 1
	xor eax, eax
	mov [dword_aux3], eax ; limpiando var que guardará la respuesta
    mov ebx, %1 ; guardando valor a evaluar en EBX

	finit ; inicilizando stack de FPU

	; Operando con deriv_c4
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^2
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^3
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^4
	mov al, [deriv_c4]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push deriv_c4
    fmul ; st0 = deriv_c4 * %1^4

	; Operando con deriv_c3
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^2
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^3
	xor eax, eax
	mov al, [deriv_c3]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push deriv_c3
    fmul ; st0 = deriv_c3 * %1^3, st1 = COEF4

	; Operando con deriv_c2
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = %1^2
	xor eax, eax
	mov al, [deriv_c2]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push deriv_c2
    fmul ; st0 = deriv_c2 * %1^2, st1 = COEF3, st2 = COEF4

	; Operando con deriv_c1
	xor eax, eax
	mov al, [deriv_c1]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push deriv_c1
	mov [dword_aux2], ebx
    fld dword [dword_aux2]   ;push %1
    fmul ; st0 = deriv_c1 * %1, st1 = COEF2, st2 = COEF3, st3 = COEF4

    fadd ; st0 = deriv_c1 * %1 + COEF2
    fadd ; st0 = st0 + COEF3
    fadd ; st0 = st0 + COEF4

    ; Sumando el deriv_c0
	xor eax, eax
	mov al, [deriv_c0]
	cbw ; extendiendo el signo a AX
	cwde ; extendiendo el signo a EAX
	mov [dword_aux2], eax
    fild dword [dword_aux2]   ;push deriv_c0 to fpu stack (st0)
    fadd ; st0 = st0 + st1

    fstp   dword [dword_aux3] ; guardando el resultado en dword_aux3

%endmacro

; ***********************************************************
; Representación IEE de punto flotante
; Precisión sencilla (32 BITS):
; * bit de signo
; * exponente de 8 bits (-127 hasta 127 -REAL-) (infinitos: +- 128)
; * significando o matinsa de 23 bits
; [S][EEEEEEE E][MMMMMMM MMMMMMMM MMMMMMMM]
;
; FÓRMULAS
; * exponente real = exponente - 127 (01111111)
; * matinsa -> parte fraccionaria
;
; EJEMPLOS:
; * 0.75 ->	00111111 01000000 00000000 00000000
;		SIGNO: 0 -> POSITIVO
;		EXPONENTE: 126 - 127 = -1
;		MATINSA: 1/2
;		0.75 = 1.5 * 2^-1
;
; * 2 ->	01000000 00000000 00000000 00000000
;		SIGNO: 0 -> POSITIVO
;		EXPONENTE: 128 - 127 = 1
;		MATINSA: 0
;		2 = 1 * 2^1
;
; * 0.1 ->	00111101 11001100 11001100 11001101
;		SIGNO: 0 -> POSITIVO
;		EXPONENTE: 123 - 127 = -4
;		MATINSA: 1/2 + 1/16 + 1/32 + ... = .6
;		0.1 = 1.6 * 2^-4
; ***********************************************************
%macro castFloatToInt 1 ; %1 -> [dword], [byte_aux1] signo: 0 | 1
	mov bl, 0 ;signo
	mov eax,%1				; EAX = [S][EEEEEEE E][MMMMMMM MMMMMMMM MMMMMMMM]
	rcl  eax,1 				; Rotación a la izquierda para enviar el signo al carry (carry -> LSB | MSB -> carry)
							; EAX = [EEEEEEEE][MMMMMMMM MMMMMMMM MMMMMMMX] | C = S
	
	jnc %%positive_integer
	mov bl, 1
%%positive_integer:
	mov [byte_aux1], bl ; guardando el signo
	mov  ebx,eax 			; Guardándolo en ebx
	mov  edx,4278190080 	; EDX = 11111111 00000000 00000000 00000000
	and  eax,edx 			; Obteniendo el exponente en la parte alta de EAX
	shr  eax,24 			; EAX = 00000000 00000000 00000000 EEEEEEEE
	sub  eax,127			; Restando 127 para obtener el exponente real
	mov  edx,eax			; EDX = EXPONENTE REAL EN BINARIO
	mov  eax,ebx 			; EAX = [EEEEEEEE][MMMMMMMM MMMMMMMM MMMMMMMX] | C = X
	rcl  eax,8 				; EAX = [MMMMMMMM][MMMMMMMM MMMMMMMX XEEEEEEE] | C = E
	mov  ebx,eax 			; EBX = [MMMMMMMM][MMMMMMMM MMMMMMMX XEEEEEEE] | C = E
	mov  ecx, 31 			; ECX = 00000000 00000000 00000000 00011111
	sub  ecx,edx 			; ECX = ECX - EDX
	mov  edx,0h 			; EDX = 0
	cmp  ecx,0
	je   %%end_cast 		; Si ECX == EDX, FIN
	shr  eax,1 				; EAX = [0MMMMMMM][MMMMMMMM MMMMMMMM XXEEEEEE]
	or   eax,2147483648		; 10000000 00000000 00000000 00000000
							; EAX = [1MMMMMMM][MMMMMMMM MMMMMMMM XXEEEEEE]
%%loop_cast:
	shr  eax,1 				; Desplazando EAX 1 bit a la derecha
	sub  ecx,1 				; ECX -= 1
	cmp  ecx,0
	ja   %%loop_cast 			; Si ECX > 0, repetir ciclo
%%end_cast:  
	mov  %1, eax
%endmacro

;; MACRO PARA IMPRIMIR FLOTANTES
%macro printFloatingNumber 1
	mov eax, %1 ; recibiendo el flotante a imprimir
	mov [dword_aux6], eax

	finit
    fld dword [dword_aux6]		; push flotante
    frndint
    fistp dword [dword_aux5]	; pop entero redondeado

    ; Verificando que el redondeo no haya cambiado el valor (que se trunque)
    mov eax, [dword_aux5]
    test eax, eax
    jns %%positive_comp
    fld dword [dword_aux6]		; push flotante
    fild dword [dword_aux5]		; push redondeado
    xor eax, eax
    fcom   st0, st1 	; compare st0 with st1
    fstsw  ax 			; ax := fpu status register
    and eax, 0100011100000000B ; Solo condition code flags
    cmp eax, 0000000100000000B ; ¿st0 < st1?
    jne %%print_integer
    mov eax, [dword_aux5]
    add eax, 1
    mov [dword_aux5], eax
    jmp %%print_integer
%%positive_comp:
    mov eax, [dword_aux6] ; parte flotante
    test eax, eax
    jns %%continue_comp
    ; La parte flotante era negativa, pero la entera se detectó positiva
    ; Ej: -0.1 -> 0 ¿único caso? ¿[-0.00.., -0.499..] a 0?
    print minus, len_minus
    jmp %%print_integer
%%continue_comp:
    fld dword [dword_aux6]		; push flotante
    fild dword [dword_aux5]		; push redondeado
    xor eax, eax
    fcom   st0, st1 	; compare st0 with st1
    fstsw  ax 			; ax := fpu status register
    and eax, 0100011100000000B ; Solo condition code flags
    cmp eax, 0000000000000000B ; ¿st0 > st1?
    jne %%print_integer
    mov eax, [dword_aux5]
    sub eax, 1
    mov [dword_aux5], eax
%%print_integer:
    mov eax, [dword_aux5]
    test eax, eax
    jns %%positive_num
    neg eax
    mov [dword_aux5], eax
    ; Pasando a positivo el flotante
	finit
    fld dword [dword_aux6]
    fchs
    fstp dword [dword_aux6]
    print minus, len_minus
%%positive_num:
    printDwordNumber [dword_aux5]

    mov al, '.'
    mov [byte_aux1], al
    print byte_aux1, 1

	finit
    fld dword [dword_aux6]		; push flotante
    fild dword [dword_aux5]		; push parte entera
    fsub 						; obteniendo solo la parte decimal
    mov ebx, 1000000
	mov [dword_aux4], ebx
    fild dword [dword_aux4]		; push 1000000
    fmul
    fabs
    fistp dword [dword_aux3]

    ; Imprimiendo los ceros antes del primer decimal distinto a cero

    mov edx, 0
    mov ebx, 100000
%%printing_zeros:
    mov [dword_aux1], ebx
    cmp ebx, 1
    je %%print_decimal_part
    mov eax, [dword_aux3]
    div ebx
    cmp eax, 0
    jne %%print_decimal_part
    mov al, '0'
    mov [byte_aux1], al
    print byte_aux1, 1
    mov eax, [dword_aux1]
    mov edx, 0
    mov ebx, 10
    div ebx
    mov [dword_aux1], eax
    mov ebx, [dword_aux1]
    jmp %%printing_zeros
%%print_decimal_part:
    printDwordNumber [dword_aux3]
%endmacro



;****************************************************************
;; ÁREA DE CÓDIGO
;****************************************************************
segment code

;; PROCEDIMIENTO LIMPIEZA DE BUFFER DE ENTRADA
;CLEAR_BUFFER:
;	xor al, al
;	mov [buffer_in], al
;	mov [buffer_in+1], al
;	mov [buffer_in+2], al
;	mov [buffer_in+3], al
;	mov [buffer_in+4], al
;	mov [buffer_in+5], al
;	mov [buffer_in+6], al
;	mov [buffer_in+7], al
;	mov [buffer_in+8], al
;	mov [buffer_in+9], al
;	mov [buffer_in+10], al
;	mov [buffer_in+11], al
;	mov [buffer_in+12], al
;	mov [buffer_in+13], al
;	mov [buffer_in+14], al
;	mov [buffer_in+15], al
;	ret

;; PROCEDIMIENTO LIMPIEZA DE PANTALLA
CLEAR_TERMINAL:
	mov ah, 0x2     ; Assuming text screen not graphics
	mov dl, 0
	mov dh, 0
	int 10h
	mov ah, 0xA
	mov  cx,25*80
	mov  al, ' '
	int 10h
	ret ;; Para que vuelva a la ejecución desde el punto en que se llamó

;; PROCEDIMIENTO LECTURA DE NÚMERO
; DL: Valor de coeficiente
; byte_aux1: Positivo o negativo
READ_NUMBER:
	read buffer_in, 16
	cld
	xor si, si ; limpiando el registro
	mov si, buffer_in

	mov cl, 0 ; aux
	mov dl, 0 ; coeficiente
	mov [byte_aux1], cl ; 0 positivo, 1 negativo

	lodsb
	; Verificando si se saltó el coeficiente
	cmp al, 10
	je exit_reading
	cmp al, 13
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
	cmp al, 13
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

; PROCEDIMIENTO GRÁFICA DE PLANO CARTESIANO
GRAPH_CARTESIAN_MAP:
	; EJE X -> 320
	mov cx, 1 ; X (column)
drawing_x:
	xor ax, ax
	xor bx, bx
	mov dx, 100  ; Y (line)
	mov ah, 0Ch ; writing mode
	mov al, 03h ; green color
	mov bh, 00h ; page number
	int 10h
	mov [word_aux1], cx
	mov ax, [word_aux1]
	mov dx, 0
	mov bx, 10
	div bx ; (DX:AX / BX) -> Resultado: AX, Residuo: DX
	cmp dx, 0
	jne increase_x
	mov dx, 98
	xor ax, ax
	xor bx, bx
x_value:
	; Dibujando valor en X
	mov ah, 0Ch ; writing mode
	mov al, 03h ; green color
	mov bh, 00h ; page number
	int 10h
	inc dx
	cmp dx, 102 ; 4 px de longitud
	jne x_value
increase_x:
	inc cx
	cmp cx, 320
	jne drawing_x

	; EJE Y -> 200
	mov cx, 160 ; X (column)
	mov dx, 1  ; Y (line)
drawing_y:
	xor ax, ax
	xor bx, bx
	mov cx, 160 ; X (column)
	mov ah, 0Ch ; writing mode
	mov al, 03h ; green color
	mov bh, 00h ; page number
	int 10h
	mov [word_aux1], dx
	mov ax, [word_aux1]
	mov dx, 0
	mov bx, 10
	div bx ; (DX:AX / BX) -> Resultado: AX, Residuo: DX
	cmp dx, 0
	jne increase_y
	mov dx, [word_aux1]
	mov cx, 158
	xor ax, ax
	xor bx, bx
y_value:
	; Dibujando valor en Y
	mov ah, 0Ch ; writing mode
	mov al, 03h ; green color
	mov bh, 00h ; page number
	int 10h
	inc cx
	cmp cx, 162 ; 4 px de longitud
	jne y_value
increase_y:
	mov dx, [word_aux1]
	inc dx
	cmp dx, 200
	jne drawing_y

	ret



;; *********************************
;; INICIO DE EJECUCIÓN DE PROGRAMA
;; *********************************

..start:

		mov     ax,data 
        mov     ds,ax 
        mov     ax,stack 
        mov     ss,ax 
        mov     sp,stacktop

; ***********************************************
; Menú principal
; ***********************************************
MENU:
	print text_menu, len_menu

	; leyendo entrada del teclado
	read buffer_in, 16

	print ln, 2

	cld
	xor si, si ; limpiando el registro para almacenar en él la entrada
	mov si, buffer_in
	lodsw ; toma los dos primeros bytes del registro ESI y lo guarda en AL y AH

	; SI LA PARTE ALTA ES DIFERENTE A \n o 13 (ascii), ENTRADA INVÁLIDA
	cmp ah, 10
	je CASES
	cmp ah, 13
	jne entry_error

CASES:
	xor si, si
	mov [buffer_in], si
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
	xor si, si
	mov [buffer_in], si
	; ENTRADA INVÁLIDA
	print error1, len_error1
	print ln, 2
	jmp MENU

; ***********************************************
; 1) Ingreso de coeficientes
; ***********************************************
OPTION_1:
	call CLEAR_TERMINAL

	;; Ingresar los coeficientes de la funcion
	print text1, len_text1

	mov cl, 10
	mov [degree], cl ; para indicar que no hay función

	; COEFICIENTE 0
	print text1_0, len_text1_0
	call READ_NUMBER ; llamando al procedimiento de lectura de número
	mov [coef_0], dl ; copiando el valor del registro DL al coeficiente 0
	cmp dl, 0
	je read_coef_1
	; No es cero el coeficiente
	mov cl, 0
	mov [degree], cl
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


; ***********************************************
; 2) Impresión de función original
; ***********************************************
OPTION_2:
	call CLEAR_TERMINAL
	
	print text2, len_text2
	print ln, 2

	; Validando que exista función almacenada
	mov al, [degree]
	cmp al, 10
	jne ok_option2
	print warning1, len_warning1
	print ln, 2
	jmp MENU

ok_option2:
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
	cmp al, 0
	je print_4 ; saltando este coeficiente en caso sea cero
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
	cmp al, 0
	je print_3 ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_4
	print minus, len_minus
	mov al, [coef_4]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_four, len_x_four
	jmp print_3
no_complement_4:
	mov al, [degree]
	cmp al, 4
	je first_4
	print plus, len_plus
first_4:
	mov al, [coef_4]
	printNumber al ; imprimiendo el valor normal
	print x_four, len_x_four
print_3:
	mov al, [coef_3]
	cmp al, 0
	je print_2 ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_3
	print minus, len_minus
	mov al, [coef_3]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_three, len_x_three
	jmp print_2
no_complement_3:
	mov al, [degree]
	cmp al, 3
	je first_3
	print plus, len_plus
first_3:
	mov al, [coef_3]
	printNumber al ; imprimiendo el valor normal
	print x_three, len_x_three
print_2:
	mov al, [coef_2]
	cmp al, 0
	je print_1 ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_2
	print minus, len_minus
	mov al, [coef_2]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_two, len_x_two
	jmp print_1
no_complement_2:
	mov al, [degree]
	cmp al, 2
	je first_2
	print plus, len_plus
first_2:
	mov al, [coef_2]
	printNumber al ; imprimiendo el valor normal
	print x_two, len_x_two
print_1:
	mov al, [coef_1]
	cmp al, 0
	je print_0 ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_1
	print minus, len_minus
	mov al, [coef_1]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_one, len_x_one
	jmp print_0
no_complement_1:
	mov al, [degree]
	cmp al, 1
	je first_1
	print plus, len_plus
first_1:
	mov al, [coef_1]
	printNumber al ; imprimiendo el valor normal
	print x_one, len_x_one
print_0:
	mov al, [coef_0]
	cmp al, 0
	je end_print ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_0
	print minus, len_minus
	mov al, [coef_0]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	jmp end_print
no_complement_0:
	mov al, [degree]
	cmp al, 0
	je first_0
	print plus, len_plus
first_0:
	mov al, [coef_0]
	printNumber al ; imprimiendo el valor normal
end_print:
	print ln, 2
	print ln, 2

	jmp MENU


; ***********************************************
; 3) Derivada de función original
; ***********************************************
OPTION_3:
	call CLEAR_TERMINAL
	
	print text3, len_text3
	print ln, 2

	; Validando que exista función almacenada
	mov al, [degree]
	cmp al, 10
	jne ok_option3
	print warning1, len_warning1
	print ln, 2
	jmp MENU

ok_option3:

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
	cmp al, 0
	je print_d3 ; saltando este coeficiente en caso sea cero
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
	cmp al, 0
	je print_d2 ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d3
	print minus, len_minus
	mov al, [deriv_c3]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_three, len_x_three
	jmp print_d2
no_complement_d3:
	mov al, [degree]
	cmp al, 4
	je first_d3
	print plus, len_plus
first_d3:
	mov al, [deriv_c3]
	printNumber al ; imprimiendo el valor normal
	print x_three, len_x_three
print_d2:
	mov al, [deriv_c2]
	cmp al, 0
	je print_d1 ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d2
	print minus, len_minus
	mov al, [deriv_c2]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_two, len_x_two
	jmp print_d1
no_complement_d2:
	mov al, [degree]
	cmp al, 3
	je first_d2
	print plus, len_plus
first_d2:
	mov al, [deriv_c2]
	printNumber al ; imprimiendo el valor normal
	print x_two, len_x_two
print_d1:
	mov al, [deriv_c1]
	cmp al, 0
	je print_d0 ; saltando este coeficiente en caso sea cero
	add al, 0 ; para activar la bandera de signo
	jns no_complement_d1
	print minus, len_minus
	mov al, [deriv_c1]
	neg al
	printNumber al ; imprimiendo el complemento a 2
	print x_one, len_x_one
	jmp print_d0
no_complement_d1:
	mov al, [degree]
	cmp al, 2
	je first_d1
	print plus, len_plus
first_d1:
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
	mov al, [degree]
	cmp al, 1
	je first_d0
	cmp al, 0
	je first_d0
	print plus, len_plus
first_d0:
	mov al, [deriv_c0]
	printNumber al ; imprimiendo el valor normal
end_print_deriv:
	print ln, 2
	print ln, 2

	jmp MENU


; ***********************************************
; 4) Integral de función original
; ***********************************************
OPTION_4:
	call CLEAR_TERMINAL
	
	print text4, len_text4
	print ln, 2

	; Validando que exista función almacenada
	mov al, [degree]
	cmp al, 10
	jne ok_option4
	print warning1, len_warning1
	print ln, 2
	jmp MENU

ok_option4:

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

print_fraction6:
	mov al, [coef_5]
	cmp al, 0
	je print_fraction5 ; saltando este en caso sea cero
	mov al, 6
	mov [byte_aux2], al
	mov al, 0
	mov [byte_aux3], al
	printFraction [coef_5], [byte_aux2], x_six, len_x_six, [byte_aux3]
print_fraction5:
	mov al, [coef_4]
	cmp al, 0
	je print_fraction4 ; saltando este en caso sea cero
	mov al, 5
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 4
	je no_sign_fraction5
	mov al, 1
no_sign_fraction5:
	mov [byte_aux3], al
	printFraction [coef_4], [byte_aux2], x_five, len_x_five, [byte_aux3]
print_fraction4:
	mov al, [coef_3]
	cmp al, 0
	je print_fraction3 ; saltando este en caso sea cero
	mov al, 4
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 3
	je no_sign_fraction4
	mov al, 1
no_sign_fraction4:
	mov [byte_aux3], al
	printFraction [coef_3], [byte_aux2], x_four, len_x_four, [byte_aux3]
print_fraction3:
	mov al, [coef_2]
	cmp al, 0
	je print_fraction2 ; saltando este en caso sea cero
	mov al, 3
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 2
	je no_sign_fraction3
	mov al, 1
no_sign_fraction3:
	mov [byte_aux3], al
	printFraction [coef_2], [byte_aux2], x_three, len_x_three, [byte_aux3]
print_fraction2:
	mov al, [coef_1]
	cmp al, 0
	je print_fraction1 ; saltando este en caso sea cero
	mov al, 2
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 1
	je no_sign_fraction2
	mov al, 1
no_sign_fraction2:
	mov [byte_aux3], al
	printFraction [coef_1], [byte_aux2], x_two, len_x_two, [byte_aux3]
print_fraction1:
	mov al, [coef_0]
	cmp al, 0
	je print_fraction_const ; saltando este en caso sea cero
	mov al, 1
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 0
	je no_sign_fraction1
	mov al, 1
no_sign_fraction1:
	mov [byte_aux3], al
	printFraction [coef_0], [byte_aux2], x_one, len_x_one, [byte_aux3]
print_fraction_const:
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

print_decimal6:
	mov al, [coef_5]
	cmp al, 0
	je print_decimal5 ; saltando este en caso sea cero
	mov al, 6
	mov [byte_aux2], al
	mov al, 0
	mov [byte_aux3], al
	printDecimalNumber [integ_e6], [integ_d6], x_six, len_x_six, [byte_aux2], [byte_aux3]
print_decimal5:
	mov al, [coef_4]
	cmp al, 0
	je print_decimal4 ; saltando este en caso sea cero
	mov al, 5
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 4
	je no_sign_decimal5
	mov al, 1
no_sign_decimal5:
	mov [byte_aux3], al
	printDecimalNumber [integ_e5], [integ_d5], x_five, len_x_five, [byte_aux2], [byte_aux3]
print_decimal4:
	mov al, [coef_3]
	cmp al, 0
	je print_decimal3 ; saltando este en caso sea cero
	mov al, 4
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 3
	je no_sign_decimal4
	mov al, 1
no_sign_decimal4:
	mov [byte_aux3], al
	printDecimalNumber [integ_e4], [integ_d4], x_four, len_x_four, [byte_aux2], [byte_aux3]
print_decimal3:
	mov al, [coef_2]
	cmp al, 0
	je print_decimal2 ; saltando este en caso sea cero
	mov al, 3
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 2
	je no_sign_decimal3
	mov al, 1
no_sign_decimal3:
	mov [byte_aux3], al
	printDecimalNumber [integ_e3], [integ_d3], x_three, len_x_three, [byte_aux2], [byte_aux3]
print_decimal2:
	mov al, [coef_1]
	cmp al, 0
	je print_decimal1 ; saltando este en caso sea cero
	mov al, 2
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 1
	je no_sign_decimal2
	mov al, 1
no_sign_decimal2:
	mov [byte_aux3], al
	printDecimalNumber [integ_e2], [integ_d2], x_two, len_x_two, [byte_aux2], [byte_aux3]
print_decimal1:
	mov al, [coef_0]
	cmp al, 0
	je print_decimal_const ; saltando este en caso sea cero
	mov al, 1
	mov [byte_aux2], al
	mov al, 0
	mov bl, [degree]
	cmp bl, 0
	je no_sign_decimal1
	mov al, 1
no_sign_decimal1:
	mov [byte_aux3], al
	printDecimalNumber [integ_e1], [integ_d1], x_one, len_x_one, [byte_aux2], [byte_aux3]
print_decimal_const:
	print plus, len_plus
	print constant, 1
	print ln, 2
	print ln, 2

	jmp MENU


; ***********************************************
; 5) Graficar funciones
; ***********************************************
OPTION_5:
	call CLEAR_TERMINAL
	
	print text5, len_text5
	print ln, 2

	; Validando que exista función almacenada
	mov al, [degree]
	cmp al, 10
	jne ok_option5
	print warning1, len_warning1
	print ln, 2
	jmp MENU

ok_option5:
	; Solicitando la opción a graficar
	print text5_0, len_text5_0

	; leyendo entrada del teclado
	read buffer_in, 16

	print ln, 2

	cld
	xor si, si ; limpiando el registro para almacenar en él la entrada
	mov si, buffer_in
	lodsw ; toma los dos primeros bytes del registro ESI y lo guarda en AL y AH

	; SI LA PARTE ALTA ES DIFERENTE A \n o 13 (ascii), ENTRADA INVÁLIDA
	cmp ah, 10
	je graph_cases
	cmp ah, 13
	jne graph_entry_error

graph_cases:
	xor si, si
	mov [buffer_in], si
	; SALTANDO A LA OPCIÓN QUE SE HAYA ESCOGIDO
	cmp al, '1'
	je graph_type
	cmp al, '2'
	je graph_type
	cmp al, '3'
	je graph_type

graph_entry_error:
	xor si, si
	mov [buffer_in], si
	; ENTRADA INVÁLIDA
	print error1, len_error1
	print ln, 2
	jmp MENU

graph_type:
	mov [byte_aux3], al ; '1' | '2' | '3'

	mov ah, 00h ; video mode
	mov al, 0xD ; 320x200 16 color graphics (EGA,VGA)
	int 10h

	mov ah, 0Bh ; set background color
	mov bh, 00h
	mov bl, 00h ; black color
	int 10h

	; EJE X: -16 <=> 16
	; EJE Y: -10 <=> 10
	call GRAPH_CARTESIAN_MAP

	mov ecx, 1		; (Pixel en X)

drawing_points:
	mov eax, 10		; Para manejar la escala
	mov ebx, 16		; Para manejar la escala

	finit ; inicializando stack de flotantes
	mov [dword_aux4], ecx
	fild dword [dword_aux4] ; push pixel actual
	mov [dword_aux4], eax
	fild dword [dword_aux4] ; push escala 1:10
	fdiv ; st0 = Pixel / 10
	mov [dword_aux4], ebx
	fild dword [dword_aux4] ; push ajuste de +/- X
	fsub ; st0 = X - 16
	fstp dword [dword_aux5] ; Guardando la X en dword_aux5

	mov al, [byte_aux3]
	cmp al, '1'
	je get_original_point
	cmp al, '2'
	je get_derivative_point
	cmp al, '3'
	je get_integral_point

get_original_point:
	; Evaluando X en la función original
    evaluateFloatInOriginalFunction [dword_aux5]
    jmp exit_get_point
get_derivative_point:
	; Evaluando X en la derivada de la función original
	evaluateFloatInDerivativeFunction [dword_aux5]
    jmp exit_get_point
get_integral_point:
	; Evaluando X en la función original
    evaluateFloatInOriginalFunction [dword_aux5]
exit_get_point:
	; el punto en Y se guarda en dword_aux3

	finit ; inicializando stack de flotantes
	fld dword [dword_aux3] ; push Y

	xor eax, eax
	mov eax, -1		; Para ajustar Y
	mov [dword_aux4], eax
	fild dword [dword_aux4] ; push ajuste +/- Y
	fmul

	mov eax, 10		; Para manejar la escala
	mov [dword_aux4], eax
	fild dword [dword_aux4] ; push ajuste +/- Y
	fadd ; st0 = Y + 10

	fild dword [dword_aux4] ; push escala 1:10
	fmul ; st0 = Y * 10
	fstp dword [dword_aux6] ; (Pixel en Y)

	mov [dword_aux5], ecx ; guardando pixel en X

    castFloatToInt [dword_aux6] ; parámetro el valor a convertir, y se guarda en la misma variable, en byte_aux1 está el signo

    mov ecx, [dword_aux5] ; Recuperando pixel en X
    mov edx, [dword_aux6] ; Guardando pixel en Y

    mov ebx, 200
    cmp edx, ebx
    ja next_point
    mov al, [byte_aux1]
    mov bl, 0
    cmp al, bl
    jne next_point

    xor eax, eax
    xor ebx, ebx

    ; Dibujando el pixel
	mov ah, 0Ch ; writing mode
	mov al, 0Fh ; White color
	mov bh, 00h ; page number
	int 10h

	; Verificando si se debe graficar área bajo la curva
	mov al, [byte_aux3]
	cmp al, '3'
	jne next_point

	; Graficando área bajo la curva
    cmp dx, 100
    ja low_area
    jb up_area
    jmp next_point
low_area:
	; Decrementar dx (Y) hasta 100 (Eje x)
	mov ah, 0Ch ; writing mode
	mov al, 0Fh ; White color
	mov bh, 00h ; page number
	int 10h
	dec dx
	cmp dx, 100
    ja low_area
	jmp next_point
up_area:
	; Incrementar dx (Y) hasta 100 (Eje x)
	mov ah, 0Ch ; writing mode
	mov al, 0Fh ; White color
	mov bh, 00h ; page number
	int 10h
	inc dx
	cmp dx, 100
    jb up_area
next_point:
	add ecx, 1
	cmp ecx, 320
	jne drawing_points


	; Wait for key press
	mov ah, 08h
	int 21h

	call CLEAR_TERMINAL

	; Regresando a la resolución original
	mov ah, 00h ; video mode
	mov al, 03h ; 80x25 16-color text mode
	int 10h

	jmp MENU


; ***********************************************
; 6) Método de Newton
; ***********************************************
OPTION_6:
	call CLEAR_TERMINAL
	
	print text6, len_text6
	print ln, 2

	; Validando que exista función almacenada
	mov al, [degree]
	cmp al, 10
	jne ok_option6
	print warning1, len_warning1
	print ln, 2
	jmp MENU

ok_option6:

	;; VARIABLES PARA NEWTON Y STEFFENSEN
	;iteraciones	db 0
	;coef_toler		db 0
	;grado_toler	db 0
	;int_p_0 		db 0
	;decimal_p_0	dd 0 ; double-word para que quepan varios decimales
	;factor_div		dd 0 ; para transformar la parte decimal a float (decimal_p_0/factor_div)
	;tolerancia		dd 0 ; float con la tolerancia (calculada)
	;p_0 		dd 0 ; float con la aproximación inicial / anterior (calculada)
	;p_n 		dd 0 ; float con la aproximación actual

	; SOLICITANDO DATOS DE ENTRADA

	; == Número máximo de iteraciones == 

	print text6_0, len_text6_0

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	mov dl, 0 ; iteraciones
	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_newton
	cmp al, 13
	je error_lectura_newton
	; Verificando si se ingresó signo
	cmp al, '-'
	je error_lectura_newton
	cmp al, '+'
	je signo_iteraciones
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	jbe lectura_iteraciones
	; Entrada inválida
	jmp error_lectura_newton
signo_iteraciones:
	lodsb
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	ja error_lectura_newton
lectura_iteraciones:
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL

	lodsb
	cmp al, 10
	je exit_iteraciones
	cmp al, 13
	je exit_iteraciones
	cmp al, '0'
	jb error_lectura_newton ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_iteraciones ; si es menor o igual, entrada correcta
	jmp error_lectura_newton ; entrada incorrecta
exit_iteraciones:
	mov [iteraciones], dl ; Guardando el número máximo de iteraciones

	; == Coeficiente de la tolerancia ==

	print text6_1, len_text6_1

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	mov dl, 0 ; coeficiente
	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_newton
	cmp al, 13
	je error_lectura_newton
	; Verificando si se ingresó signo
	cmp al, '-'
	je error_lectura_newton
	cmp al, '+'
	je signo_coef_toler
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	jbe lectura_coef_toler
	; Entrada inválida
	jmp error_lectura_newton
signo_coef_toler:
	lodsb
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	ja error_lectura_newton
lectura_coef_toler:
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL

	lodsb
	cmp al, 10
	je exit_coef_toler
	cmp al, 13
	je exit_coef_toler
	cmp al, '0'
	jb error_lectura_newton ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_coef_toler ; si es menor o igual, entrada correcta
	jmp error_lectura_newton ; entrada incorrecta
exit_coef_toler:
	mov [coef_toler], dl ; Guardando el coeficiente de tolerancia

	; == Grado de tolerancia ==

	print text6_2, len_text6_2

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	mov dl, 0 ; grado de tolerancia
	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_newton
	cmp al, 13
	je error_lectura_newton
	; Verificando si se ingresó signo
	cmp al, '-'
	je error_lectura_newton
	cmp al, '+'
	je signo_grado_toler
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	jbe lectura_grado_toler
	; Entrada inválida
	jmp error_lectura_newton
signo_grado_toler:
	lodsb
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	ja error_lectura_newton
lectura_grado_toler:
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL

	lodsb
	cmp al, 10
	je exit_grado_coef
	cmp al, 13
	je exit_grado_coef
	cmp al, '0'
	jb error_lectura_newton ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_grado_toler ; si es menor o igual, entrada correcta
	jmp error_lectura_newton ; entrada incorrecta
exit_grado_coef:
	mov [grado_toler], dl ; Guardando el grado de tolerancia

	; == Aproximacion inicial (p_0) ==

	print text6_3, len_text6_3

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	xor edx, edx
	mov [decimal_p_0], edx 	; Seteando parte decimal como 0 (decimal_p_0 es dword)
	mov edx, 10
	mov [factor_div], edx 	; Seteando factor para convertir el decimal a float como 10
	xor edx, edx 			; parte entera: DL
	mov [byte_aux1], dl 		; 0 | 1 (signo de p_0)

	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_newton
	cmp al, 13
	je error_lectura_newton
	; Verificando si se ingresó signo
	cmp al, '-'
	je with_minus_p0
	cmp al, '+'
	je with_plus_p_0
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	jbe lectura_entero_p0
	; Entrada inválida
	jmp error_lectura_newton
with_minus_p0:
	lodsb
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	ja error_lectura_newton
	mov dl, 1
	mov [byte_aux1], dl ; indicando que es negativo
	mov dl, 0
	jmp lectura_entero_p0
with_plus_p_0:
	lodsb
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	ja error_lectura_newton
lectura_entero_p0:
	; Leyendo parte entera de p_0
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL
	mov [int_p_0], dl ; Guardando la parte entera de p_0

	lodsb
	cmp al, 10
	je exit_lectura_p_0
	cmp al, 13
	je exit_lectura_p_0
	cmp al, '.'
	je parte_decimal_p_0
	cmp al, '0'
	jb error_lectura_newton ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_entero_p0 ; si es menor o igual, entrada correcta
	jmp error_lectura_newton ; entrada incorrecta

parte_decimal_p_0:
	xor ecx, ecx ; aux
	xor edx, edx ; parte decimal

	lodsb
	cmp al, '0'
	jb error_lectura_newton
	cmp al, '9'
	ja error_lectura_newton
lectura_decimal_p0:
	; Leyendo parte decimal de p_0
	sub al, 48 		; conviertiendo el número leído de 'num' -> num
	mov cl, al 		; copiando el número leído a CL
	xor eax, eax
	mov eax, [decimal_p_0] 	; copiando a EAX lo que se lleva en decimal (EDX), para multiplicarlo por 10
	mov edx, 0
	mov ebx, 10 	; Fuente: factor *10 por cada número leído
	mul ebx			; mul Fuente -> (EAX * EBX = EDX:EAX)
	add eax, ecx 	; Sumandole a EAX el número leído
	mov [decimal_p_0], eax

	lodsb
	cmp al, 10
	je exit_lectura_p_0
	cmp al, 13
	je exit_lectura_p_0
	cmp al, '0'
	jb error_lectura_newton ; si es menor, error en la entrada
	cmp al, '9'
	ja error_lectura_newton ; si es mayor, error en la entrada
	mov [byte_aux2], al
	; aumentando el factor de conversión * 10
	mov eax, [factor_div]
	mov ebx, 10
	mul ebx
	mov [factor_div], eax
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov al, [byte_aux2]
	jmp lectura_decimal_p0 ; entrada correcta
exit_lectura_p_0:
	mov al, [byte_aux1]
	cmp al, 0
	je convertir_p_0
	; p_0 es negativo
	mov al, [int_p_0]
	neg al
	mov [int_p_0], al
	xor eax, eax
	mov eax, [decimal_p_0]
	neg eax
	mov [decimal_p_0], eax
	jmp convertir_p_0

error_lectura_newton:
	print error3, len_error3
	jmp exit_option6

convertir_p_0:
	; Cálculo de p_0 para pasarlo a flotante
	xor eax, eax
	mov al, [int_p_0]
	cbw 					; extendiendo el signo a AX
	cwde 					; extendiendo el signo a EAX
	
	finit
	mov [dword_aux1], eax
    fild dword [dword_aux1]		; push int_p_0
    fild dword [decimal_p_0]	; push decimal_p_0
    fild dword [factor_div]		; push factor_div
    fdiv 						; st0 := st1 / st0
    fadd 						; st0 := entero + decimal
    fstp dword [p_0]			; p_0 = flotante calculado

    ; Cálculo de tolerancia para pasarla a flotante
	xor eax, eax
	xor ebx, ebx
	mov al, [coef_toler]
	mov bl, [grado_toler]
	finit
	mov [dword_aux1], eax
    fild dword [dword_aux1]		; push coef_toler
	xor ecx, ecx
	mov ecx, 1
	mov [dword_aux1], ecx
    fild dword [dword_aux1]		; push 1 (10^0)
	xor ecx, ecx
	mov ecx, 10
	mov [dword_aux1], ecx
pow_ten:
	cmp bl, 0
	je exit_pow_ten
    fild dword [dword_aux1]		; push 10
    fmul 						; st0 = st1 * 10
	dec bl
	jmp pow_ten
exit_pow_ten:
    fdiv 						; st0 = coef_toler / (10 ^ grado_toler)
    fstp dword [tolerancia]		; tolerancia = flotante calculado

    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov bl, 0
    mov [iter_actual_new], bl
NEWTON:
    mov al, [iteraciones]
    mov bl, [iter_actual_new]
    sub al, bl
	cmp al, 0
	je ERROR_NEWTON

	add bl, 1
	mov [iter_actual_new], bl

	print text6_4, len_text6_4 ; header
	print text6_5, len_text6_5 ; # iteración
	printNumber [iter_actual_new]
	print ln, 2
	print text6_6, len_text6_6 ; p_n
	printFloatingNumber [p_0]
	print ln, 2

	evaluateFloatInOriginalFunction [p_0]	; se guarda en dword_aux3
	mov ebx, [dword_aux3]
	mov [numerador_new], ebx
	evaluateFloatInDerivativeFunction [p_0]	; se guarda en dword_aux3
	mov ebx, [dword_aux3]
	mov [denominador_new], ebx

	;𝑥𝑛+1=𝑥𝑛−𝑓(𝑥𝑛)/𝑓′(𝑥𝑛)
	finit
	fld dword [p_0]
	fld dword [numerador_new]
	fld dword [denominador_new]
	fdiv
	fsub
	fst dword [p_n] ; guardando p_n sin sacarlo de la pila

	; ¿|p - p0| < TOLERANCIA?
	fld dword [p_0]
	fsub
	fabs
	fstp dword [error_actual_new] ; guardando error sin sacarlo de la pila

	print text6_7, len_text6_7 ; p_n+1
	printFloatingNumber [p_n]
	print ln, 2
	print text6_8, len_text6_8 ; error
	printFloatingNumber [error_actual_new]
	print ln, 2
	print text6_9, len_text6_9 ; tolerancia
	printFloatingNumber [tolerancia]
	print ln, 2
	print text6_10, len_text6_10 ; end
	print ln, 2

	fld dword [tolerancia]
	fld dword [error_actual_new]

    xor eax, eax
    fcom   st0, st1 	; compare st0 with st1
    fstsw  ax 			; ax := fpu status register

	; Exito -> |p - p0| < TOLERANCIA
    and eax, 0100011100000000B ; Solo condition code flags
    cmp eax, 0000000100000000B ; ¿st0 < source? (ERROR < TOLERANCIA)
    je EXIT_NEWTON

	print press_key, len_press_key ; pause

	; Wait for key press
	mov ah, 08h
	int 21h

	print ln, 2

    ; P_0 = P_n
    mov edx, [p_n]
    mov [p_0], edx

	jmp NEWTON

EXIT_NEWTON:
	print success_new1, len_succ_new1 ; pn
	printFloatingNumber [p_n]
	print success_new2, len_succ_new2 ; error
	printFloatingNumber [error_actual_new]
	print ln, 2
	jmp exit_option6

ERROR_NEWTON:
	print fail_new1, len_fail_new1 ; pn
	printFloatingNumber [p_n]
	print fail_new2, len_fail_new2 ; error
	printFloatingNumber [error_actual_new]
	print ln, 2

exit_option6:

	print press_key2, len_press_key2 ; pause

	; Wait for key press
	mov ah, 08h
	int 21h

	call CLEAR_TERMINAL

	jmp MENU


; ***********************************************
; 7) Método de Steffensen
; ***********************************************
OPTION_7:
	call CLEAR_TERMINAL
	
	print text7, len_text7
	print ln, 2

	; Validando que exista función almacenada
	mov al, [degree]
	cmp al, 10
	jne ok_option7
	print warning1, len_warning1
	print ln, 2
	jmp MENU

ok_option7:

	;; VARIABLES PARA NEWTON Y STEFFENSEN
	;iteraciones	db 0
	;coef_toler		db 0
	;grado_toler	db 0
	;int_p_0 		db 0
	;decimal_p_0	dd 0 ; double-word para que quepan varios decimales
	;factor_div		dd 0 ; para transformar la parte decimal a float (decimal_p_0/factor_div)
	;tolerancia		dd 0 ; float con la tolerancia (calculada)
	;p_0 		dd 0 ; float con la aproximación inicial / anterior (calculada)
	;p_n 		dd 0 ; float con la aproximación actual

	; SOLICITANDO DATOS DE ENTRADA

	; == Número máximo de iteraciones == 

	print text6_0, len_text6_0

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	mov dl, 0 ; iteraciones
	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_steff
	cmp al, 13
	je error_lectura_steff
	; Verificando si se ingresó signo
	cmp al, '-'
	je error_lectura_steff
	cmp al, '+'
	je signo_iteraciones_steff
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	jbe lectura_iteraciones_steff
	; Entrada inválida
	jmp error_lectura_steff
signo_iteraciones_steff:
	lodsb
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	ja error_lectura_steff
lectura_iteraciones_steff:
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL

	lodsb
	cmp al, 10
	je exit_iteraciones_steff
	cmp al, 13
	je exit_iteraciones_steff
	cmp al, '0'
	jb error_lectura_steff ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_iteraciones_steff ; si es menor o igual, entrada correcta
	jmp error_lectura_steff ; entrada incorrecta
exit_iteraciones_steff:
	mov [iteraciones], dl ; Guardando el número máximo de iteraciones

	; == Coeficiente de la tolerancia ==

	print text6_1, len_text6_1

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	mov dl, 0 ; coeficiente
	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_steff
	cmp al, 13
	je error_lectura_steff
	; Verificando si se ingresó signo
	cmp al, '-'
	je error_lectura_steff
	cmp al, '+'
	je signo_coef_toler_steff
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	jbe lectura_coef_toler_steff
	; Entrada inválida
	jmp error_lectura_steff
signo_coef_toler_steff:
	lodsb
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	ja error_lectura_steff
lectura_coef_toler_steff:
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL

	lodsb
	cmp al, 10
	je exit_coef_toler_steff
	cmp al, 13
	je exit_coef_toler_steff
	cmp al, '0'
	jb error_lectura_steff ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_coef_toler_steff ; si es menor o igual, entrada correcta
	jmp error_lectura_steff ; entrada incorrecta
exit_coef_toler_steff:
	mov [coef_toler], dl ; Guardando el coeficiente de tolerancia

	; == Grado de tolerancia ==

	print text6_2, len_text6_2

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	mov dl, 0 ; grado de tolerancia
	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_steff
	cmp al, 13
	je error_lectura_steff
	; Verificando si se ingresó signo
	cmp al, '-'
	je error_lectura_steff
	cmp al, '+'
	je signo_grado_toler_steff
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	jbe lectura_grado_toler_steff
	; Entrada inválida
	jmp error_lectura_steff
signo_grado_toler_steff:
	lodsb
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	ja error_lectura_steff
lectura_grado_toler_steff:
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL

	lodsb
	cmp al, 10
	je exit_grado_coef_steff
	cmp al, 13
	je exit_grado_coef_steff
	cmp al, '0'
	jb error_lectura_steff ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_grado_toler_steff ; si es menor o igual, entrada correcta
	jmp error_lectura_steff ; entrada incorrecta
exit_grado_coef_steff:
	mov [grado_toler], dl ; Guardando el grado de tolerancia

	; == Aproximacion inicial (p_0) ==

	print text6_3, len_text6_3

	xor si, si
	mov [buffer_in], si

	read buffer_in, 16

	cld
	mov si, buffer_in
	mov cl, 0 ; aux
	xor edx, edx
	mov [decimal_p_0], edx 	; Seteando parte decimal como 0 (decimal_p_0 es dword)
	mov edx, 10
	mov [factor_div], edx 	; Seteando factor para convertir el decimal a float como 10
	xor edx, edx 			; parte entera: DL
	mov [byte_aux1], dl 		; 0 | 1 (signo de p_0)

	lodsb
	; Verificando si se saltó
	cmp al, 10
	je error_lectura_steff
	cmp al, 13
	je error_lectura_steff
	; Verificando si se ingresó signo
	cmp al, '-'
	je with_minus_p0_steff
	cmp al, '+'
	je with_plus_p_0_steff
	; Verificando que sea número
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	jbe lectura_entero_p0_steff
	; Entrada inválida
	jmp error_lectura_steff
with_minus_p0_steff:
	lodsb
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	ja error_lectura_steff
	mov dl, 1
	mov [byte_aux1], dl ; indicando que es negativo
	mov dl, 0
	jmp lectura_entero_p0_steff
with_plus_p_0_steff:
	lodsb
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	ja error_lectura_steff
lectura_entero_p0_steff:
	; Leyendo parte entera de p_0
	sub al, 48 	; conviertiendo el número leído de 'num' -> num
	mov cl, al 	; copiando el número leído a CL
	mov al, dl 	; copiando a AL lo que se lleva en coeficiente (DL), para multiplicarlo * 10
	mov bl, 10 	; Fuente: factor *10 por cada número leído
	mul bl		; mul Fuente -> (AL * BL = AH:AL)
	add al, cl 	; Sumandole a AL el número leído
	mov dl, al 	; Guardando el resultado en DL
	mov [int_p_0], dl ; Guardando la parte entera de p_0

	lodsb
	cmp al, 10
	je exit_lectura_p_0_steff
	cmp al, 13
	je exit_lectura_p_0_steff
	cmp al, '.'
	je parte_decimal_p_0_steff
	cmp al, '0'
	jb error_lectura_steff ; si es menor, error en la entrada
	cmp al, '9'
	jbe lectura_entero_p0_steff ; si es menor o igual, entrada correcta
	jmp error_lectura_steff ; entrada incorrecta

parte_decimal_p_0_steff:
	xor ecx, ecx ; aux
	xor edx, edx ; parte decimal

	lodsb
	cmp al, '0'
	jb error_lectura_steff
	cmp al, '9'
	ja error_lectura_steff
lectura_decimal_p0_steff:
	; Leyendo parte decimal de p_0
	sub al, 48 		; conviertiendo el número leído de 'num' -> num
	mov cl, al 		; copiando el número leído a CL
	xor eax, eax
	mov eax, [decimal_p_0] 	; copiando a EAX lo que se lleva en decimal (EDX), para multiplicarlo por 10
	mov edx, 0
	mov ebx, 10 	; Fuente: factor *10 por cada número leído
	mul ebx			; mul Fuente -> (EAX * EBX = EDX:EAX)
	add eax, ecx 	; Sumandole a EAX el número leído
	mov [decimal_p_0], eax

	lodsb
	cmp al, 10
	je exit_lectura_p_0_steff
	cmp al, 13
	je exit_lectura_p_0_steff
	cmp al, '0'
	jb error_lectura_steff ; si es menor, error en la entrada
	cmp al, '9'
	ja error_lectura_steff ; si es mayor, error en la entrada
	mov [byte_aux2], al
	; aumentando el factor de conversión * 10
	mov eax, [factor_div]
	mov ebx, 10
	mul ebx
	mov [factor_div], eax
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov al, [byte_aux2]
	jmp lectura_decimal_p0_steff ; entrada correcta
exit_lectura_p_0_steff:
	mov al, [byte_aux1]
	cmp al, 0
	je convertir_p_0_steff
	; p_0 es negativo
	mov al, [int_p_0]
	neg al
	mov [int_p_0], al
	xor eax, eax
	mov eax, [decimal_p_0]
	neg eax
	mov [decimal_p_0], eax
	jmp convertir_p_0_steff

error_lectura_steff:
	print error3, len_error3
	jmp exit_option7

convertir_p_0_steff:
	; Cálculo de p_0 para pasarlo a flotante
	xor eax, eax
	mov al, [int_p_0]
	cbw 					; extendiendo el signo a AX
	cwde 					; extendiendo el signo a EAX
	
	finit
	mov [dword_aux1], eax
    fild dword [dword_aux1]		; push int_p_0
    fild dword [decimal_p_0]	; push decimal_p_0
    fild dword [factor_div]		; push factor_div
    fdiv 						; st0 := st1 / st0
    fadd 						; st0 := entero + decimal
    fstp dword [p_0]			; p_0 = flotante calculado

    ; Cálculo de tolerancia para pasarla a flotante
	xor eax, eax
	xor ebx, ebx
	mov al, [coef_toler]
	mov bl, [grado_toler]
	finit
	mov [dword_aux1], eax
    fild dword [dword_aux1]		; push coef_toler
	xor ecx, ecx
	mov ecx, 1
	mov [dword_aux1], ecx
    fild dword [dword_aux1]		; push 1 (10^0)
	xor ecx, ecx
	mov ecx, 10
	mov [dword_aux1], ecx
pow_ten_steff:
	cmp bl, 0
	je exit_pow_ten_steff
    fild dword [dword_aux1]		; push 10
    fmul 						; st0 = st1 * 10
	dec bl
	jmp pow_ten_steff
exit_pow_ten_steff:
    fdiv 						; st0 = coef_toler / (10 ^ grado_toler)
    fstp dword [tolerancia]		; tolerancia = flotante calculado

    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov bl, 0
    mov [iter_actual_new], bl
STEFFENSEN:
    mov al, [iteraciones]
    mov bl, [iter_actual_new]
    sub al, bl
	cmp al, 0
	je ERROR_STEFFENSEN

	add bl, 1
	mov [iter_actual_new], bl

	print text7_0, len_text7_0 ; header
	print text6_5, len_text6_5 ; # iteración
	printNumber [iter_actual_new]
	print ln, 2
	print text6_6, len_text6_6 ; p_n
	printFloatingNumber [p_0]
	print ln, 2

	evaluateFloatInOriginalFunction [p_0]	; se guarda en dword_aux3
	mov ebx, [dword_aux3]
	mov [f_p_0], ebx

	; 𝑥𝑛+1= 𝑥𝑛 − 𝑓(𝑥𝑛) / { [𝑓(𝑥𝑛 + 𝑓(𝑥𝑛)) − 𝑓(𝑥𝑛)] / [𝑓(𝑥𝑛)] }
	
	; g(𝑥𝑛) = [𝑓(𝑥𝑛 + 𝑓(𝑥𝑛)) − 𝑓(𝑥𝑛)] / [𝑓(𝑥𝑛)]

	; INIT FPU STACK FOR g(𝑥𝑛)
	; 1) push 𝑥𝑛
	; 2) push 𝑓(𝑥𝑛)
	; 3) fadd
	; 4) pop st0, calc f(st0) and push
	; 5) push 𝑓(𝑥𝑛)
	; 6) fsub
	; 7) push 𝑓(𝑥𝑛)
	; 8) fdiv
	; 9) pop st0 into g(xn)

	finit
	fld dword [p_0]
	fld dword [f_p_0]
	fadd
	fstp dword [dword_aux1]
	evaluateFloatInOriginalFunction [dword_aux1]	; se guarda en dword_aux3
	fld dword [dword_aux3]
	fld dword [f_p_0]
	fsub
	fld dword [f_p_0]
	fdiv
	fstp dword [g_p_0]

	; 𝑥𝑛+1= 𝑥𝑛 − 𝑓(𝑥𝑛) / g(𝑥𝑛)

	; INIT FPU STACK FOR 𝑥𝑛+1
	; 1) push 𝑥𝑛
	; 2) push 𝑓(𝑥𝑛)
	; 3) push g(𝑥𝑛)
	; 4) fdiv
	; 5) fsub
	; 6) store st0 into 𝑥𝑛+1

	finit
	fld dword [p_0]
	fld dword [f_p_0]
	fld dword [g_p_0]
	fdiv
	fsub
	fst dword [p_n] ; guardando p_n sin sacarlo de la pila

	; ¿|p - p0| < TOLERANCIA?
	fld dword [p_0]
	fsub
	fabs
	fstp dword [error_actual_new] ; guardando error

	print text6_7, len_text6_7 ; p_n+1
	printFloatingNumber [p_n]
	print ln, 2
	print text6_8, len_text6_8 ; error
	printFloatingNumber [error_actual_new]
	print ln, 2
	print text6_9, len_text6_9 ; tolerancia
	printFloatingNumber [tolerancia]
	print ln, 2
	print text7_1, len_text7_1 ; end
	print ln, 2

	fld dword [tolerancia]
	fld dword [error_actual_new]

    xor eax, eax
    fcom   st0, st1 	; compare st0 with st1
    fstsw  ax 			; ax := fpu status register

	; Exito -> |p - p0| < TOLERANCIA
    and eax, 0100011100000000B ; Solo condition code flags
    cmp eax, 0000000100000000B ; ¿st0 < source? (ERROR < TOLERANCIA)
    je EXIT_STEFFENSEN

	print press_key, len_press_key ; pause

	; Wait for key press
	mov ah, 08h
	int 21h

	print ln, 2

    ; P_0 = P_n
    mov edx, [p_n]
    mov [p_0], edx

	jmp STEFFENSEN

EXIT_STEFFENSEN:
	print success_new1, len_succ_new1 ; pn
	printFloatingNumber [p_n]
	print success_new2, len_succ_new2 ; error
	printFloatingNumber [error_actual_new]
	print ln, 2
	jmp exit_option7

ERROR_STEFFENSEN:
	print fail_new1, len_fail_new1 ; pn
	printFloatingNumber [p_n]
	print fail_new2, len_fail_new2 ; error
	printFloatingNumber [error_actual_new]
	print ln, 2

exit_option7:

	print press_key2, len_press_key2 ; pause

	; Wait for key press
	mov ah, 08h
	int 21h

	call CLEAR_TERMINAL

	jmp MENU


; ***********************************************
; 8) Exit
; ***********************************************
EXIT_PROGRAM:
	call CLEAR_TERMINAL

	print ln, 2
	print text8, len_text8
	print ln, 2

	mov ah, 0x4c
	int 0x21


;****************************************************************
; VARIABLES INICIALIZADAS
;****************************************************************

segment data
	;; DEFINIENDO TEXTOS DE MENÚS
	text_menu	db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "1. Ingresar los coeficientes de la funcion.", 0xA, 0xD, "2. Imprimir la funcion almacenada.", 0xA, 0xD, "3. Imprimir la derivada de la funcion almacenada.", 0xA, 0xD, "4. Imprimir la integral de la funcion almacenada.", 0xA, 0xD, "5. Graficar la funcion original, derivada o integral.", 0xA, 0xD, "6. Encontrar los ceros de la funcion por el metodo de Newton.", 0xA, 0xD, "7. Encontrar los ceros de la funcion por el metodo de Steffensen", 0xA, 0xD, "8. Salir de la aplicacion.", 0xA, 0xD, "> Ingrese el numero de la opcion que desee realizar: "
	len_menu	equ	$-text_menu

	text1		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(1) Ingresar los coeficientes de la funcion.", 0xA, 0xD
	len_text1	equ	$-text1
	text1_0		db 	"> Ingrese el coeficiente de x^0: "
	len_text1_0	equ	$-text1_0
	text1_1		db 	"> Ingrese el coeficiente de x^1: "
	len_text1_1	equ	$-text1_1
	text1_2		db 	"> Ingrese el coeficiente de x^2: "
	len_text1_2	equ	$-text1_2
	text1_3		db 	"> Ingrese el coeficiente de x^3: "
	len_text1_3	equ	$-text1_3
	text1_4		db 	"> Ingrese el coeficiente de x^4: "
	len_text1_4	equ	$-text1_4
	text1_5		db 	"> Ingrese el coeficiente de x^5: "
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
	x_two		db	"x^2"
	len_x_two	equ $-x_two
	x_three		db	"x^3"
	len_x_three	equ $-x_three
	x_four		db	"x^4"
	len_x_four	equ $-x_four
	x_five		db	"x^5"
	len_x_five	equ $-x_five
	; para integrales
	x_six		db	"x^6"
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
	text5_0		db	"1. Graficar funcion original. ", 0xA, 0xD, "2. Graficar derivada de la funcion original. ", 0xA, 0xD, "3. Graficar integra de la funcion original. ", 0xA, 0xD, "> Ingrese el numero de la funcion que desea graficar: "
	len_text5_0	equ $-text5_0

	text6		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(6) Encontrar los ceros de la funcion por el metodo de Newton.", 0xA, 0xD
	len_text6	equ	$-text6
	text6_0		db 0xA, 0xD, "> Ingrese el numero maximo de iteraciones: "
	len_text6_0	equ	$-text6_0
	text6_1		db "> Ingrese el coeficiente de la tolerancia: "
	len_text6_1	equ	$-text6_1
	text6_2		db "> Ingrese el grado de tolerancia: "
	len_text6_2	equ	$-text6_2
	text6_3		db "> Ingrese la aproximacion inicial (P_0): "
	len_text6_3	equ	$-text6_3
	; Mensajes de iteraciones
	text6_4		db 0xA, 0xD,"******************* NEWTON *******************", 0xA, 0xD
	len_text6_4	equ	$-text6_4
	text6_5		db "> Iteracion: "
	len_text6_5	equ	$-text6_5
	text6_6		db "> Valor inicial (Pn): "
	len_text6_6	equ	$-text6_6
	text6_7		db "> Nuevo valor (Pn+1): "
	len_text6_7	equ	$-text6_7
	text6_8		db "> Error: "
	len_text6_8	equ	$-text6_8
	text6_9		db "> Tolerancia: "
	len_text6_9	equ	$-text6_9
	text6_10	db "***********************************************"
	len_text6_10 equ	$-text6_10
	press_key	db "> Presione cualquier tecla para la siguiente iteracion... "
	len_press_key	equ	$-press_key
	press_key2	db "> Presione cualquier tecla para volver al menu.", 0xA, 0xD
	len_press_key2	equ	$-press_key2

	success_new1 db "> Solucion encontrada en Pn = "
	len_succ_new1 equ $-success_new1
	success_new2 db " con error de "
	len_succ_new2 equ $-success_new2

	fail_new1	db "> Se llego al limite de iteraciones sin encontrar solucion.", 0xA, 0xD, " Ultimo valor Pn calculado: "
	len_fail_new1 equ $-fail_new1
	fail_new2 db " con error de "
	len_fail_new2 equ $-fail_new2


	text7		db	"========== CALCULADORA ARQUI 1 - Elias Vasquez ==========", 0xA, 0xD, "(7) Encontrar los ceros de la funcion por el metodo de Steffensen.", 0xA, 0xD
	len_text7	equ	$-text7
	; Mensajes de iteraciones
	text7_0		db 0xA, 0xD,"******************* STEFFENSEN *******************", 0xA, 0xD
	len_text7_0	equ	$-text7_0
	text7_1	db "**************************************************"
	len_text7_1	equ	$-text7_1
	; Los demás mensajes se reciclan de Newton

	text8		db	"Gracias por utilizar esta aplicacion. :)", 0xA, 0xD
	len_text8	equ	$-text8

	; error de entrada inválida
	error1		db	"> Error, ingrese una opcion valida.", 0xA, 0xD
	len_error1	equ	$-error1

	; error de entrada inválida en opción 1
	error2		db	"> Error, se detecto una entrada invalida. Valor a asignar al coeficiente: 0", 0xA, 0xD
	len_error2	equ	$-error2

	; error de entrada inválida en iteraciones
	error3		db	"> Error, ingrese una entrada valida (numero entero positivo).", 0xA, 0xD
	len_error3	equ	$-error3

	; warning, no hay función declarada
	warning1	db "> No se encontro ninguna funcion almacenada. Seleccione opcion 1) para almacenar una funcion.", 0xA, 0xD
	len_warning1 equ $-warning1

	; salto de línea
	ln  		db 	0xA, 0xD
	; espacio
	space 		db 	" "

	;; DEFINIENDO COEFICIENTES DE FUNCIÓN ORIGINAL (-128 (-2⁷) hasta 128 (2⁷))
	degree		db	10 ; valor para indicar que no hay función
	coef_0		db	0
	coef_1		db	0
	coef_2		db	0
	coef_3		db	0
	coef_4		db	0
	coef_5		db	0

	;; DEFINIENDO COEFICIENTES DE DERIVADA (-128 (-2⁷) hasta 128 (2⁷))
	deriv_c0	db	0
	deriv_c1	db	0
	deriv_c2	db	0
	deriv_c3	db	0
	deriv_c4	db	0
	
	;; DEFINIENDO PARTE ENTERA Y RESIDUAL DE INTEGRAL
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

	;; AUXILIARES, ALMACENAN f(x), f('x') - Suma de productos -
	f_x			dw	0.0
	f_prima_x	dw	0.0
	; Words auxiliares
	word_aux1	dw 0.0
	word_aux2	dw 0.0
	; dwords auxiliares
	dword_aux1	dd 0.0
	dword_aux2	dd 0.0
	dword_aux3	dd 0.0
	dword_aux4	dd 0.0
	dword_aux5	dd 0.0
	dword_aux6	dd 0.0

	;; VARIABLES PARA NEWTON Y STEFFENSEN
	iteraciones	db 0
	coef_toler	db 0
	grado_toler	db 0
	int_p_0 	db 0
	decimal_p_0	dd 0 ; double-word para que quepan varios decimales
	factor_div	dd 0 ; para transformar la parte decimal a float (decimal_p_0/factor_div)
	tolerancia	dd 0 ; float con la tolerancia (calculada)
	p_0 		dd 0 ; float con la aproximación inicial / anterior (calculada)
	p_n 		dd 0 ; float con la aproximación actual
	; Aux Newton
	iter_actual_new	db 0
	error_actual_new dd 0
	numerador_new	dd 0
	denominador_new	dd 0
	;Aux Steffensen
	f_p_0 		dd 0
	g_p_0 		dd 0

	;; LIMPIANDO TERMINAL
	clear 		db 	27,"[H",27,"[2J"    ; <ESC> [H <ESC> [2J
	len_clear 	equ	$-clear


;****************************************************************
; VARIABLES NO INICIALIZADAS (PILA)
;****************************************************************

segment stack stack 
	; Buffer de lectura
	buffer_in	resb 16
	; Byte para almacenar texto
	byte_aux1	resb 1
	byte_aux2	resb 1
	byte_aux3	resb 1
	; Bytes para almacenar cocientes y residuos
	cociente 	resb 1
	residuo		resb 1

stacktop: