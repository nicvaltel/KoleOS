format binary as "hex"

org 8100h

mov ah, 0x0E
mov al, "X"
int 0x10

; mov ah, 0x0E
mov al, "Y"
int 0x10

; mov ah, 0x0E
mov al, "N"
int 0x10


cli
hlt

times 0E0h*200h+$$-$ db 0x00