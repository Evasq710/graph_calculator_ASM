# Assembler_201900131

## Especificaciones técnicas

- Procesador x86
- Sistema operativo Linux
- Ensamblador NASM
- Sintaxis Intel

Comando Linux para generar código objeto:

```
nasm -f elf FILE.asm
```

Comando Linux para generar ejecutable:

```
ld -m elf_i386 -o NAME_EXEC_FILE OBJECT_FILE.o
```

