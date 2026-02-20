@echo off

REM Build script for OS Project
setlocal

REM Create build directory
if not exist build (
    mkdir build
)

REM Assemble the bootloader
nasm -f bin bootloader.asm -o build/bootloader.bin
if %errorlevel% neq 0 (
    echo "Error during assembly"
    exit /b 1
)

REM Create a floppy disk image
fsutil.exe sparse setfloppy build/floppy.img
if %errorlevel% neq 0 (
    echo "Error creating floppy image"
    exit /b 1
)

REM Write bootloader to floppy image
copy /b build/bootloader.bin build/floppy.img
if %errorlevel% neq 0 (
    echo "Error writing bootloader to image"
    exit /b 1
)

REM Launch QEMU
qemu-system-i386 -fda build/floppy.img -boot a -m 16M
if %errorlevel% neq 0 (
    echo "Error launching QEMU"
    exit /b 1
)
echo "Build and launch completed successfully!"
endlocal