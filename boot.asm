; boot.asm - Minimal boot sector OS for QEMU

BITS 16                 ; 16-bit real mode
ORG 0x7C00              ; BIOS loads boot sector here

start:
    ; Clear the screen
    mov ax, 0x0600       ; Scroll up function
    mov bh, 0x07         ; Text attribute (white on black)
    mov cx, 0x0000       ; Upper-left corner
    mov dx, 0x184F       ; Lower-right corner (80x25)
    int 0x10             ; BIOS video interrupt

    ; Set cursor position
    mov ah, 0x02
    mov bh, 0x00         ; Page number
    mov dh, 0x05         ; Row
    mov dl, 0x0A         ; Column
    int 0x10

    ; Print message
    mov si, message
print_loop:
    lodsb                ; Load next byte from SI into AL
    cmp al, 0
    je done
    mov ah, 0x0E         ; Teletype output
    mov bh, 0x00
    mov bl, 0x07         ; White on black
    int 0x10
    jmp print_loop

done:
    ; Hang the system
    cli
    hlt

message db "Hello from my OS!", 0

; Boot sector padding
times 510-($-$$) db 0
dw 0xAA55               ; Boot signature