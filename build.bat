@echo off
setlocal enabledelayedexpansion

REM Enable better error handling
set ERRORLEVEL=0

REM Example debug output
echo Starting build process...

REM Insert your build commands here

if !ERRORLEVEL! NEQ 0 (
    echo Error: Build command failed with error level !ERRORLEVEL!.
    exit /b !ERRORLEVEL!
)

echo Build completed successfully.
exit /b 0
