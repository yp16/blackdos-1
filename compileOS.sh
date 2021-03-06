# Compiles the BlackDOS operating system
# Author: Nick Gallimore

# Compile bootloader assembly
nasm bootload.asm

# Creates blank disk image
dd if=/dev/zero of=floppya.img bs=512 count=2880

# Puts bootload into sector 0
dd if=bootload of=floppya.img bs=512 count=1 conv=notrunc

# Compiles kernel.c
bcc -ansi -c -o kernel.o kernel.c

# Compile kernel assembly
as86 kernel.asm -o kasm.o

# Puts disk map at 256 and disk directory at 257
dd if=map of=floppya.img bs=512 count=1 seek=256 conv=notrunc

# Puts config into sector 258
dd if=config of=floppya.img bs=512 count=1 seek=258 conv=notrunc

# Links kernel.o with kasm.o
ld86 -o kernel -d kernel.o kasm.o

# Puts kernel into sector 259
dd if=kernel of=floppya.img bs=512 conv=notrunc seek=259

# Compile load file
gcc -o loadFile loadFile.c

# Compile interrupts for Shell
as86 blackdos.asm -o bdos_asm.o

# Compile Shell
bcc -ansi -c -o Shell.o Shell.c
ld86 -o Shell -d Shell.o bdos_asm.o

# Compile fib
bcc -ansi -c -o fib.o fib.c
ld86 -o fib -d fib.o bdos_asm.o

# Compile cal
bcc -ansi -c -o cal.o cal.c
ld86 -o cal -d cal.o bdos_asm.o

# Compile t3
bcc -ansi -c -o t3.o t3.c
ld86 -o t3 -d t3.o bdos_asm.o

# Load files
./loadFile Shell
# ./loadFile Stenv
./loadFile story
# ./loadFile fib
# ./loadFile cal
# ./loadFile t3
# ./loadFile kitty1
# ./loadFile kitty2
