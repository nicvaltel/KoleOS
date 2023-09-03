; nasm -f elf32 kernel.asm -o kasm.o
bits 32
section .text

global start
extern kernel_main

start:
  cli
  mov esp, stack_space
  mov byte[0xB8000 + (25 * 80 - 1) * 2], "!"
	
  call kernel_main
  jmp $
  hlt

section .bss
resb 8192
stack_space: