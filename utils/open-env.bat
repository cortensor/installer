@echo off
setlocal enabledelayedexpansion

echo Attempting to open Cortensor .env file...

:: Get the user's home directory
set "HOME_DIR=%USERPROFILE%"

:: Set the path to the .env file
set "ENV_FILE=%HOME_DIR%\.cortensor\.env"

:: Check if the file exists
if not exist "%ENV_FILE%" (
    echo Error: .env file not found at "%ENV_FILE%"
    echo Please make sure Cortensor is properly installed.
    pause
    exit /b 1
)

:: Open the file with Notepad
echo Opening %ENV_FILE% with Notepad...
notepad "%ENV_FILE%"

echo .env file opened successfully.

exit /b 0