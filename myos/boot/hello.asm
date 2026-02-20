; boot/hello.asm — Minimal bootloader for Windows build
[org 0x7c00]        ; BIOS loads boot sector here

mov si, message     ; Point SI to our string

print_loop:
    lodsb           ; Load next character into AL
    cmp al, 0       ; End of string?
    je done
    mov ah, 0x0E    ; BIOS teletype function
    mov bh, 0x00    ; Page number
    mov bl, 0x07    ; Text color (light gray)
    int 0x10        ; Call BIOS
    jmp print_loop

done:
    hlt             ; Halt CPU

message db "Hello World from MyOS!", 0

times 510-($-$$) db 0  ; Fill rest of sector with zeros
dw 0xAA55              ; Boot signature