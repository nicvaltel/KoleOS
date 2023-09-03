#!/bin/bash
##nasm -f bin -o bootloader/bootloader.bin bootloader/bootloader.asm
##nasm -f elf32 kernel/kernel.asm -o kernel/kasm.o 
# gcc -m32 -c kernel/kernel.c -o kernel/kc.o ## Параметр -c указывает на то, что файл после компиляции не нужно линковать.
# ld -m elf_i386 -T kernel/link.ld -o kernel/kernel-0001 kernel/kasm.o kernel/kc.o ## GRUB требует, чтобы название файла с ядром следовало конвенции kernel-<версия>
# dd if=/dev/zero of=disk/disk count=1000
# cat bootloader/bootloader.bin kernel/kernel-0001 | dd of=disk/disk conv=notrunc

fasm bootloader/boot16.asm
# fasm kernel/kernel.asm
nasm -f elf32 kernel/kernel.asm -o kernel/kasm.o
gcc -c -m32 -ffreestanding -fno-pie -o kernel/kc.o kernel/kernel.c
# gcc -m32 -c kernel/kernel.c -o kernel/kc.o ## Параметр -c указывает на то, что файл после компиляции не нужно линковать.
ld --oformat=binary -m elf_i386 -T kernel/link.ld -o kernel/kernel-0001 kernel/kasm.o kernel/kc.o ## GRUB требует, чтобы название файла с ядром следовало конвенции kernel-<версия>
# ld -m elf_i386 -T kernel/link.ld -o kernel/kernel-0001 kernel/kasm.o kernel/kc.o ## GRUB требует, чтобы название файла с ядром следовало конвенции kernel-<версия>
dd if=/dev/zero of=disk/disk count=1000
cat bootloader/boot16.bin kernel/kernel-0001 | dd of=disk/disk conv=notrunc

