# Assembler_201900131

## Especificaciones técnicas Linux

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

## Especificaciones técnicas DOS

- Procesador x86
- Ensamblador NASM
- Sintaxis Intel
- Programa de 16 bits

Comando DOS para generar código objeto (archivo .obj):

```
nasm -f obj FILENAME.ASM
```

Utilizar un enlazador para crear el ejecutable a partir del .EXE