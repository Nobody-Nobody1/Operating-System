[ORG 0x7C00]          ; BIOS loads bootloader at 0x7C00

cli                   ; Disable interrupts
mov ax, 0x0000        ; Set segment registers
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00        ; Set stack pointer

; Your code here

cli
hlt                   ; Halt the processor

; Padding to 510 bytes
times 510 - ($ - $$) db 0

; Boot signature
dw 0xAA55             ; Magic bytes (little-endian: 0x55AA)