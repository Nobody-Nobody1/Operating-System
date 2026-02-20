@echo off
REM Define source file name
SET SOURCE_NAME=hello.asm
REM Define output directory
SET BUILD_DIR=build
REM Define output binary file name
SET OUTPUT_NAME=%SOURCE_NAME%.bin

REM Create the build directory if it doesn't exist
IF NOT EXIST %BUILD_DIR% (
    mkdir %BUILD_DIR%
)
REM Change to the build directory
cd %BUILD_DIR%

REM Assemble the .asm file into a raw .bin file using NASM
REM -f bin specifies raw binary format, -o specifies output file name
nasm -f bin ..\%SOURCE_NAME% -o %OUTPUT_NAME%

REM Go back to the original directory
cd ..

REM Run the binary file with QEMU
REM Use appropriate QEMU system command, e.g., qemu-system-i386 or qemu-system-x86_64
REM -drive configures QEMU to boot from the created binary file as a raw disk image
qemu-system-i386 -drive format=raw,file=%BUILD_DIR%\%OUTPUT_NAME%

powershell.exe pause