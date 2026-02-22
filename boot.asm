; keyboard_irq.asm
; Assemble: nasm -f bin keyboard_irq.asm -o boot.bin
; Run: qemu-system-i386 -drive format=raw,file=boot.bin

BITS 16
ORG 0x7C00

start:
    cli                         ; Disable interrupts during setup

    ; Setup segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Save old IRQ1 vector (optional, for restoration)
    mov ax, [0x0004 * 9]        ; Offset of old handler
    mov [old_irq1_offset], ax
    mov ax, [0x0004 * 9 + 2]    ; Segment of old handler
    mov [old_irq1_segment], ax

    ; Install our IRQ1 handler
    mov word [0x0004 * 9], keyboard_handler
    mov word [0x0004 * 9 + 2], 0x0000

    sti                         ; Enable interrupts

main_loop:
    hlt                         ; Wait for interrupt (saves CPU)
    jmp main_loop

; -------------------------
; IRQ1 Keyboard Handler
; -------------------------
keyboard_handler:
    pusha                       ; Save all registers

    in al, 0x60                 ; Read scan code from keyboard data port

    ; Simple example: print 'K' for any key press
    mov ah, 0x0E                ; BIOS teletype output
    mov bh, 0x00
    mov bl, 0x07
    mov al, 'K'
    int 0x10

    ; Send End Of Interrupt (EOI) to PIC
    mov al, 0x20
    out 0x20, al

    popa
    iret                        ; Return from interrupt

; -------------------------
; Data storage
; -------------------------
old_irq1_offset dw 0
old_irq1_segment dw 0

; Boot sector padding
times 510-($-$$) db 0
dw 0xAA55