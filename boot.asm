[org 0x7c00]        ; BIOS loads bootloader here
bits 16

start:
    mov ah, 0x0e
    mov al, 'B'
    int 0x10         ; Print 'B' to show bootloader runs

    ; Load kernel (simplified, real code needs disk reads)
    jmp 0x0000:0x7e00

times 510-($-$$) db 0
dw 0xAA55           ; Boot signature