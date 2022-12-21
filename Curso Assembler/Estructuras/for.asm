;; Loop DECREMENTA el valor de ECX automáticamente
;; Si ECX es diferente de cero, Loop saltará a la etiqueta pasada como parámetro
;; Instrucción:
;; mov ecx, Cantidad_iteraciones
;; loop etiqueta_for

;; LOOPE/LOOPZ
;; Verifica que ECX sea diferente cero, pero además verificará que la bandera de cero (ZF) sea igual a 1 para saltar a la etiqueta

;; LOOPNE/LOOPNZ
;; Verifica que ECX sea diferente cero, pero además verificará que la bandera de cero (ZF) sea igual a 0 para saltar a la etiqueta


;; for(int ecx = 3; ecx > 0; ecx--) {
;;	eax = eax + ecx;
;;	// Sumatoria: 3 + 2 + 1
;;}

section .bss
	resultado resb 1

section .text

global _start

_start:
	mov ecx, 3
	mov eax, 0

;; Con esta lógica, el for se hace mínimo una vez
for:
	add eax, ecx
	loop for

	add eax, 48 ; ascii

	mov [resultado], eax

	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 1
	int 80h

	mov eax, 1
	mov ebx, 0
	int 0x80
