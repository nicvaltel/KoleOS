#!/bin/bash
nasm -f bin -o bootloader.bin bootloader.asm
fasm kernel.asm
## dd if=/dev/zero bs=1 count=10000 | tr '\000' '\x41' > filedata.bin
dd if=/dev/zero of=disk count=1000
cat bootloader.bin kernel.hex | dd of=disk conv=notrunc
