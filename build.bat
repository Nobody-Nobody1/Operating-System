@echo off
REM Build script for MyOS on Windows

setlocal enabledelayedexpansion

REM Check for required tools
where nasm >nul 2>&1
if errorlevel 1 (
    echo Error: nasm not found. Please install NASM assembler.
    pause
    exit /b 1
)

where qemu-system-i386 >nul 2>&1
if errorlevel 1 (
    echo Error: qemu-system-i386 not found. Please install QEMU.
    pause
    exit /b 1
)

REM Create build directory if it doesn't exist
if not exist "build" mkdir build

REM Assemble bootloader
echo Assembling bootloader...
nasm -f bin boot\hello.asm -o build\hello.bin
if errorlevel 1 (
    echo Error: Assembly failed!
    pause
    exit /b 1
)

REM Verify bootloader size (should be 512 bytes or less)
for %%A in (build\hello.bin) do set size=%%~zA
if %size% gtr 512 (
    echo Error: Bootloader is larger than 512 bytes (%size% bytes)
    pause
    exit /b 1
)

REM Create floppy image (1.44MB = 2880 sectors * 512 bytes)
echo Creating floppy image...
if exist build\myos.img del build\myos.img
fsutil file createnew build\myos.img 1474560 >nul
if errorlevel 1 (
    echo Error: Failed to create image file.
    pause
    exit /b 1
)

REM Write bootloader to first sector using dd (more reliable)
REM Note: You may need to install GNU coreutils or use a Windows dd alternative
echo Writing bootloader to image...
dd if=build\hello.bin of=build\myos.img bs=512 count=1 >nul 2>&1
if errorlevel 1 (
    echo Warning: dd not available. Trying alternative method...
    REM Fallback: use PowerShell to write the bootloader
    powershell -Command "Copy-Item 'build\hello.bin' 'build\myos.img' -Force" 2>nul
    if errorlevel 1 (
        echo Error: Failed to write bootloader to image.
        pause
        exit /b 1
    )
)

REM Run in QEMU
echo Running MyOS in QEMU...
qemu-system-i386 -fda build\myos.img

endlocal