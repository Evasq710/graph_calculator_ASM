section .bss
resultado resb 1

section .text
	global _start
_start:

;;DIVISION
; Instrucción: div Fuente
; RESULTADO / FUENTE

;;8 bits:
; (AH:AL / Fuente de 8 bits)
; Resultado: AL
; Residuo: AH

;;16 bits:
; (DX:AX / Fuente de 16 bits)
; Resultado: AX
; Residuo: DX

;;32 bits:
; (EDX:EAX / Fuente de 32 bits)
; Resultado: EAX
; Residuo: EDX

;;64 bits:
; (RDX:RAX / Fuente de 64 bits)
; Resultado: RAX
; Residuo: RDX

;FUENTE de 16 bits
mov bx, 2

;Al hacer la división , estos registros se toman de forma implícita
mov ax, 8	; RESULTADO
mov dx, 0	; RESIDUO

;Dividiendo RESULTADO / FUENTE
div bx

add ax, 48 ; ASCII

mov [resultado], ax

;Mostrando la división en pantalla
mov eax, 4
mov ebx, 1
mov ecx, resultado
mov edx, 1
int 0x80

;finalizando con proceso exitoso
mov eax, 1
mov ebx, 0
int 0x80