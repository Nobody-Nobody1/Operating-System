@echo off

nasm -f bin boot\hello.asm -o boot\hello.bin

echo Boot assembly completed!