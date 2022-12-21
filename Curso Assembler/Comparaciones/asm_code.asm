;; Instrucción -> CMP

;; 0 0 0 0 0 1 0 0 = 4
;; Complemento a 2:
;; 1 1 1 1 1 1 0 0 = -4 (252 si se interpreta como un positivo)
;; Complemento a 2:
;; 0 0 0 0 0 1 0 0 = 4
	
	;;COMPARACIONES -> RESTAS


	;;FLAGS MODIFICADAS
	; Desbordamiento (OF)
	; Signo (SF -> Sign Flag)
	; Cero (ZF -> Zero Flag)
	; Acarreo (CF -> Carry Flag)
	; Acarreo auxiliar
	; Paridad

	;;COMPARACIÓN DOS ENTEROS SIN SIGNO
	;;Destino < Origen
	;;	ZF: 0
	;;	CF: 1
	;;Destino > Origen
	;;	ZF: 0
	;;	CF: 0
	;;Destino = Origen
	;;	ZF: 1
	;;	CF: 0

	;;COMPARACIÓN DOS ENTEROS CON SIGNO
	;;Destino < Origen
	;;	ZF: 0
	;;	SF != OF
	;;Destino > Origen
	;;	ZF: 0
	;;	SF = OF
	;;Destino = Origen
	;;	ZF: 1

;; UNIR CON SALTOS
;; Ver códigos de distintos saltos condicionales
;; CMP DATO1, DATO2
;; CÓDIGO_SALTO ETIQUETA_A_SALTAR

;;SALTO INCONDICIONAL
;; JMP ETIQUETA_A_SALTAR

section .data
	msg db 0xA, 0xD, "No es posible dividir entre cero.", 0xA, 0xD
	lenmsg equ $-msg

section .bss
	resultado resb 1

section .text
global _start

;; La ejecución es SECUENCIAL

_start:

	;; COMPROBACIÓN DIVISIÓN ENTRE 0

	;;División 16 bits:
	; (DX:AX / Fuente de 16 bits)
	; Resultado: AX
	; Residuo: DX

	mov ebx, 0 ;; Fuente = Denominador

	mov eax, 16
	mov edx, 0

	cmp ebx, 0 ;; Comparación entre ebx y 0
	je es_cero ;; Saltando si son iguales a la etiqueta 'es_cero'

	;; Si entra aquí, el denominador no es cero

	div ebx

	add eax, 48 ; ascii

	mov [resultado], eax

	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 1
	int 0x80

	jmp salida ; Salto incondicional


; Impresión mensaje error
es_cero:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, lenmsg
	int 80h
	; Si entra aquí, sigue la secuencia de ejecución, entrando automáticamente a la etiqueta salida

salida:
	mov eax, 1
	mov ebx, 0
	int 80h
