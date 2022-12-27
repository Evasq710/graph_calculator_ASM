# Assembler_201900131

## LINUX (Fase 1)

### Archivos

- code.asm 		(Código Assembler)
- code.o 		(Código objeto)
- calculator	(Ejecutable)

### Especificaciones técnicas

- Procesador x86
- Ensamblador NASM
- Sintaxis Intel
- Programa de 32 bits

Comando Linux para generar código objeto:

```
nasm -f elf FILE.asm
```

Comando Linux para generar ejecutable:

```
ld -m elf_i386 -o NAME_EXEC_FILE OBJECT_FILE.o
```

## DOS (Fase 2)

### Archivos

- DOS_CODE.asm 	(Código Assembler)
- DOS_CODE.obj 	(Código objeto)
- DOS_CODE.EXE	(Ejecutable)

### Especificaciones técnicas

- Procesador x86
- Ensamblador NASM
- Sintaxis Intel
- Programa de 16 bits

Comando DOS para generar código objeto (archivo .obj):

```
nasm -f obj FILENAME.ASM
```

Utilizar un enlazador si se desea crear el ejecutable a partir del .OBJ.
Recomendación: [Linker VAL](https://people.ece.ubc.ca/edc/379.jan99/assembler.html)