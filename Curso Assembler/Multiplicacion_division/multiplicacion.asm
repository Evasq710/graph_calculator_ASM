section .bss
resultado resb 1

section .text
	global _start
_start:

;;MULTIPLICACIÓN
; Instrucción: mul Fuente
; ParteBaja * Fuente = Parte alta : Parte baja

;;8 bits:
; (AL * Fuente = AH:AL)
; Parte alta: AH
; Parte baja: AL

;;16 bits:
; (AX * Fuente = DX:AX)
; Parte alta: DX
; Parte baja: AX

;;32 bits:
; (EAX * Fuente = EDX:EAX)
; Parte alta: EDX
; Parte baja: EAX

;;64 bits:
; (RAX * Fuente = RDX:RAX)
; Parte alta: RDX
; Parte baja: RAX

;16 bits
mov ax, 3 ;Parte baja
mov cx, 2 ;Fuente

;Multiplicando Parte Baja*Fuente, guardando en DX:AX
mul cx

add ax, 48 ; ASCII
;;como 3*2=6, no se necesita la parte alta para esta instrucción

mov [resultado], ax

;Mostrando la multiplicación en pantalla
mov eax, 4
mov ebx, 1
mov ecx, resultado
mov edx, 1
int 0x80


;finalizando con proceso exitoso
mov eax, 1
mov ebx, 0
int 0x80