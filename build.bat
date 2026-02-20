@echo off

REM Creating a floppy disk image
if exist floppy.img del floppy.img

echo Creating floppy disk image...

fsutil.exe sparse setflag floppy.img

REM Writing the bootloader to the floppy disk image
if not exist build\hello.bin (
    echo Bootloader not found.
    exit /b 1
)

echo Writing bootloader to floppy disk image...
diskpart /s write_bootloader.txt

REM Launching QEMU
echo Launching QEMU...
qemu-system-x86_64 -fda floppy.img -boot a
if errorlevel 1 (
    echo QEMU failed to launch.
    exit /b 1
)

echo Process completed successfully.