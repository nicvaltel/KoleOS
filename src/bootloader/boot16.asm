org 0x7C00    ; Origin address where bootloader is loaded

;bits 16       ; 16-bit mode
use16

start:
    cli              ;Запрещаем прерывания (чтобы ничего не отвлекало)
    xor ax, ax       ;Обнуляем регистр ax
    mov ds, ax       ;Настраиваем dataSegment на нулевой адрес
    mov es, ax       ;Настраиваем сегмент es на нулевой адрес
    mov ss, ax       ;Настраиваем StackSegment на нулевой адрес
    mov sp, 0x7C00   ;Указываем на текущую вершину стека
    sti              ;Разрешаем прерывания

    mov ah, 0x02   ; BIOS function number for read sector
    mov al, 32     ; Number of sectors to read
    mov ch, 0      ; Cylinder number
    mov cl, 2      ; Sector number
    mov dh, 0      ; Head number
    mov dl, 0x80   ; Drive number (0x80 for first hard drive)

    mov bx, 0x7E00 ; Destination memory address (where to store the data)

    int 0x13       ; Call BIOS interrupt 0x13 (Low Level Disk Services)

    jc error       ; If carry flag is set, there was an error


    ; Display the first few bytes read from the sector
    mov si, bx
    mov cx, 16     ; Number of bytes to display
    call print_bytes

    jmp success

error:
    mov ah, 0x0E   ; BIOS function number for print character
    mov al, 'E'
    int 0x10       ; Call BIOS interrupt 0x10 to print the character
    jmp $

success:
    mov ah, 0x0E   ; BIOS function number for print character
    mov al, 'G'
    int 0x10       ; Call BIOS interrupt 0x10 to print the character
    ; jmp $
    jmp start32_pre

print_bytes:
    mov ah, 0x0E   ; BIOS function number for print character
    mov al, [si]
    int 0x10       ; Call BIOS interrupt 0x10 to print the character
    inc si
    loop print_bytes

    ret

; Запуск 32-разрядного ядра
 start32_pre:
	; Выводим уведомление о запуске 32-битного ядра
	; mov si, start32_msg
	; call write_str
	; Загрузим значение в GDTR
	lgdt [gdtr32]
	; Запретим прерывания
	cli
	; Перейдём в защищённый режим
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	; Перейдём на 32-битный код
	jmp 8:start32
; Таблица дескрипторов сегментов для 32-битного ядра
align 16
gdt32:
	dq 0                  ; NULL - 0
	dq 0x00CF9A000000FFFF ; CODE - 8
	dq 0x00CF92000000FFFF ; DATA - 16
gdtr32:
	dw $ - gdt32 - 1
	dd gdt32
; 32-битный код
use32
start32:
	; Настроим сегментные регистры и стек
	mov eax, 16
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	movzx esp, sp
	; Выводим символ на экран
	; mov byte[0xB8000 + (25 * 80 - 1) * 2], "W"
	; Завершение
	jmp 0x7E00

times 510 - ($ - $$) db 0   ; Fill the rest of the sector with zeroes
dw 0xAA55                   ; Boot signature