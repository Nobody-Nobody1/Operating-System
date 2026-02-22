# MyOS - Operating System

A minimal operating system bootloader project written in x86 assembly for educational purposes.

## Prerequisites

Before running the build script, you need to install the following tools:

### Required Tools

1. **NASM (Netwide Assembler)**
   - Download: https://www.nasm.us/
   - Installation on Windows:
     - Download the Windows installer
     - Run the installer and follow the prompts
     - Add NASM to your system PATH (or install will do this for you)
   - Verify installation: Open Command Prompt and run `nasm -version`
   - Documentation: https://nasmnitc.github.io/NASM%20Manual.pdf
   - Unofficial Documentation: [text](https://linuxvox.com/blog/basic-yet-thorough-assembly-tutorial-linux/#4-assembly-fundamentals)

2. **QEMU (Quick Emulator)**
   - Download: https://www.qemu.org/download/
   - Installation on Windows:
     - Download the Windows installer
     - Run the installer and follow the prompts
     - Add QEMU to your system PATH
   - Verify installation: Open Command Prompt and run `qemu-system-i386 --version`

3. **GNU coreutils (optional but recommended)**
   - Provides the `dd` command for better bootloader writing
   - Download: https://gnuwin32.sourceforge.io/packages/coreutils.html
   - Or use Windows Subsystem for Linux (WSL) as an alternative

## Project Structure

```
Operating-System/
├── boot/
│   └── hello.asm          # Bootloader assembly code
├── build/                 # Output directory (created automatically)
│   ├── hello.bin          # Compiled bootloader
│   └── myos.img           # Floppy disk image
├── build.bat              # Build script
└── README.md              # This file
```

## Building and Running

### Step 1: Clone the Repository

```bash
git clone https://github.com/Nobody-Nobody1/Operating-System.git
cd Operating-System
```

### Step 2: Run the Build Script

On Windows, open Command Prompt or PowerShell in the repository directory and run:

```cmd
cd boot
build_and_run.bat
```

The script will:
1. ✓ Verify that NASM and QEMU are installed
2. ✓ Create a `build/` directory for output files
3. ✓ Assemble `boot/hello.asm` into `build/hello.bin`
4. ✓ Validate that the bootloader is exactly 512 bytes (one sector)
5. ✓ Create a 1.44MB floppy disk image (`myos.img`)
6. ✓ Write the bootloader to the first sector
7. ✓ Launch QEMU and run the operating system

### What You Should See

When QEMU launches, you should see a window with your bootloader running. The output depends on what your `hello.asm` contains.

## Bootloader Requirements

Your `boot/hello.asm` file must:

- Be **512 bytes or smaller** (one sector)
- End with the **magic bytes** `0x55AA` (bootloader signature)
- Be **padded with zeros** to reach exactly 512 bytes
- Include proper x86 real mode code

### Example Bootloader Template

```asm
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
```

## Troubleshooting

### "nasm not found"
- Make sure NASM is installed and added to your system PATH
- Restart Command Prompt/PowerShell after installation
- Check: `nasm -version`

### "qemu-system-i386 not found"
- Make sure QEMU is installed and added to your system PATH
- Restart Command Prompt/PowerShell after installation
- Check: `qemu-system-i386 --version`

### "Bootloader is larger than 512 bytes"
- Your assembly file is too large
- Reduce code size or use external files
- Remember: bootloader must fit in 512 bytes

### "Failed to write bootloader to image"
- Try installing GNU coreutils for the `dd` command
- Or use WSL (Windows Subsystem for Linux)
- The script has a PowerShell fallback, but it may not write to the exact first sector

### QEMU Window Won't Open
- Check that QEMU is properly installed
- Try running QEMU directly: `qemu-system-i386 build/myos.img`
- On some systems, you may need to run as Administrator

## Next Steps

- Modify `boot/hello.asm` to add more functionality
- Add a bootloader stage 2
- Implement kernel code
- Add disk I/O operations
- Implement interrupt handlers

## Resources

- [NASM Assembly Language Tutorial](https://www.tutorialspoint.com/assembly_programming/)
- [OSDev.org - OS Development Wiki](https://wiki.osdev.org/)
- [Intel x86 Reference](https://www.felixcloutier.com/x86/)
- [Bootloader Development Guide](https://wiki.osdev.org/Bootloader)

## License

This project is provided as-is for educational purposes.

## Author

Nobody-Nobody1