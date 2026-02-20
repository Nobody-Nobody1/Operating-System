@echo off

REM Create build directory if it doesn't exist
if not exist build mkdir build

REM Check for boot/hello.asm
if not exist boot\hello.asm (
    echo Error: boot/hello.asm not found!
    exit /b 1
)

REM Assemble the bootloader
nasm -f bin boot/hello.asm -o build/bootloader.bin
if errorlevel 1 (
    echo Error: Failed to assemble bootloader.
    exit /b 1
)

REM Verify bootloader size
set /p size=< build/bootloader.bin
if %size% LSS 512 (
    echo Error: Bootloader size is less than 512 bytes.
    exit /b 1
)

REM Create a 1.44MB floppy disk image
if exist floppy.img del floppy.img
fallocate -l 1440k floppy.img
if errorlevel 1 (
    echo Error: Failed to create floppy image.
    exit /b 1
)

REM Write the bootloader to the image
cat build/bootloader.bin floppy.img > tmp.img
if errorlevel 1 (
    echo Error: Failed to write bootloader to image.
    exit /b 1
)

REM Launch QEMU
qemu-system-i386 -fda floppy.img
if errorlevel 1 (
    echo Error: QEMU failed to launch.
    exit /b 1
)