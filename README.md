# Graphic Calculator ASM

## Detalles de la aplicación

La aplicación tiene como objetivo ser una calculadora que se maneje en consola, pudiendo almacenar ecuaciones de grado n (donde n es un número entero no mayor a 5), y calcular su derivada e integral, graficar dichas funciones almacenadas en ella, y encontrar los ceros de la función por medio del método de Newton o del método de Steffensen, todo esto utilizando como herramienta un ensamblador de x86, el coprocesador matemático e interrupciones de DOS.


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
- Utilización de DosBOX para ejecución del programa

Comando DOS para generar código objeto (archivo .obj):

```
nasm -f obj FILENAME.ASM
```

Utilizar un enlazador si se desea crear el ejecutable a partir del .OBJ.
Recomendación: [Linker VAL](https://people.ece.ubc.ca/edc/379.jan99/assembler.html)
