org 0x7c00

; load the second sector (the kernel) to 0x8000
mov bx, 0x8000
mov al, 1       ; load 1 sector
mov ch, 0       ; cylinder 0
mov dh, 0       ; head 0
mov cl, 2       ; sector 2
mov ah, 2       ; BIOS read sector function
int 0x13

; jump to the loaded kernel
jmp 0x8000

; boot sector padding and signature
times 510 - ( $ - $$ ) db 0
dw 0xAA55