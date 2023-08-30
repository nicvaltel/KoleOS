org 0x7C00    ; Origin address where bootloader is loaded

bits 16       ; 16-bit mode

start:
    mov ax, 0x07C0 ; Set up a data segment address
    mov ds, ax
    mov es, ax

    mov ah, 0x02   ; BIOS function number for read sector
    mov al, 1      ; Number of sectors to read
    mov ch, 0      ; Cylinder number
    mov cl, 2      ; Sector number
    mov dh, 0      ; Head number
    mov dl, 0x80   ; Drive number (0x80 for first hard drive)

    mov bx, 0x8100 ; Destination memory address (where to store the data)

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
    jmp 0x8100

print_bytes:
    mov ah, 0x0E   ; BIOS function number for print character
    mov al, [si]
    int 0x10       ; Call BIOS interrupt 0x10 to print the character
    inc si
    loop print_bytes

    ret

times 510 - ($ - $$) db 0   ; Fill the rest of the sector with zeroes
dw 0xAA55                   ; Boot signature