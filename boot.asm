; boot.asm - Minimal NASM boot sector that prints "Hello World" in QEMU
; Assemble: nasm -f bin boot.asm -o boot.bin
; Run:      qemu-system-x86_64 -drive format=raw,file=boot.bin

BITS 16                 ; 16-bit real mode
ORG 0x7C00              ; BIOS loads boot sector here

start:
    ; Set up segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00       ; Stack grows down from here

    ; Load message address into SI
    mov si, message

print_loop:
    lodsb                ; Load next byte from DS:SI into AL
    cmp al, 0            ; End of string?
    je done
    mov ah, 0x0E         ; BIOS teletype function
    mov bh, 0x00         ; Page number
    mov bl, 0x07         ; Text attribute (light gray on black)
    int 0x10             ; Call BIOS video interrupt
    jmp print_loop

done:
    hlt                  ; Halt CPU
    jmp $                ; Infinite loop

message:
    db "Hello World", 0  ; Null-terminated string

; Boot sector padding
times 510-($-$$) db 0
dw 0xAA55               ; Boot signature