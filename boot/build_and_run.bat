@echo off
REM Define source file name without extension
SET SOURCE_NAME=hello
REM Define output directory
SET BUILD_DIR=build
REM Define output binary file name
SET OUTPUT_NAME=%SOURCE_NAME%.bin

REM Change to the build directory before assembling
cd %BUILD_DIR%

REM Assemble the .asm file into a raw .bin file using NASM
REM -f bin specifies raw binary format, -o specifies output file name
nasm -f bin ..\%SOURCE_NAME%.asm -o %OUTPUT_NAME%

REM Go back to the original directory
cd ..

REM Run the binary file with QEMU
REM Use appropriate QEMU system command, e.g., qemu-system-i386 or qemu-system-x86_64
REM -drive configures QEMU to boot from the created binary file as a raw disk image
qemu-system-i386 -drive format=raw,file=%BUILD_DIR%\%OUTPUT_NAME%

powershell.exe pause