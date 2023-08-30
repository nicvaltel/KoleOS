; FASM: 
; fasm bootloader.asm
; dd if=/dev/zero of=disk count=10000
; cat bootloader.bin | dd of=disk conv=notrunc
; qemu-virgil -drive format=raw,file=disk

org 7C00h            ;код нужно загружать в ОЗУ по адресу 0x7C00

 start:
    cli              ;Запрещаем прерывания (чтобы ничего не отвлекало)
    xor ax, ax       ;Обнуляем регистр ax
    mov ds, ax       ;Настраиваем dataSegment на нулевой адрес
    mov es, ax       ;Настраиваем сегмент es на нулевой адрес
    mov ss, ax       ;Настраиваем StackSegment на нулевой адрес
    mov sp, 07C00h   ;Указываем на текущую вершину стека
    sti              ;Запрещаем прерывания

  ;Очищаем экран
  mov ax, 3         ;устанавливаем видео режим 80х25 (80 символов в строке и 25 строк) и тем самым очищаем экран.
  int 10h

  mov ah, 2h        ; устанавливаем курсор. За это отвечает функция 2h прерывания 10h. В регистр dh мы помещаем координату курсора по Y, а в регистр dl — по X.
  mov dh, 0
  mov dl, 0
  xor bh, bh
  int 10h

  ;Печатаем строку
  mov ax, 1301h
  mov bp, message
  mov cx, 12
  mov bl, 02h
  int 10h

  jmp $  ;infinite loop - jump to this line

message db 'Hello World!',0

times 510 - ($ - $$) db 0 ;Заполнение оставшихся байт нулями до 510-го байта
; TIMES 510 - ($ - $$) db 0: As bootloader is always of length 512 bytes, our code does not fit in this size as its small. We need to use rest of memory and hence we clear it out using TIMES directive. $ stands for start of instruction and $$ stands for start of program. Thus ($ - $$) means length of our code.
db 0x55, 0xAA ;Загрузочная сигнатура  