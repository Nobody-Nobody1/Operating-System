; boot.asm - Minimal GUI-like OS boot sector for QEMU

[org 0x7C00]          ; BIOS loads boot sector here

; --- Set video mode 13h (320x200, 256 colors) ---
mov ax, 0x0013
int 0x10

; --- Set ES to video memory segment ---
mov ax, 0xA000
mov es, ax

; --- Draw a rectangle (like a window) ---
mov cx, 50            ; X start
mov dx, 50            ; Y start
mov si, 100           ; Width
mov di, 60            ; Height
mov al, 12            ; Color (light red)

call draw_rect

; --- Infinite loop ---
jmp $

; --- Draw rectangle subroutine ---
; CX = X, DX = Y, SI = width, DI = height, AL = color
draw_rect:
    push bx
    push dx
    mov bx, dx        ; current Y
row_loop:
    push cx
    mov dx, cx        ; current X
    mov cx, si        ; width counter
col_loop:
    mov di, bx
    imul di, 320      ; di = y * 320
    add di, dx        ; di = y * 320 + x
    mov [es:di], al   ; set pixel
    inc dx
    loop col_loop
    inc bx
    dec word [sp]     ; height counter on stack
    jnz row_loop
    pop dx
    pop bx
    ret

; --- Boot sector padding ---
times 510-($-$$) db 0
dw 0xAA55