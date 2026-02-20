@echo off
REM Create build directory if it does not exist
IF NOT EXIST "build" (
    echo Creating build directory...
    mkdir build
    IF ERRORLEVEL 1 (
        echo Failed to create build directory.
        exit /B 1
    )
)
echo Build directory is ready.

REM Continue with the build process
REM Add your build commands here

echo Starting the build process...
REM Placeholder for actual build commands

echo Build process completed successfully!