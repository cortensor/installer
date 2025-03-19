@echo off
setlocal enabledelayedexpansion

echo Starting Cortensor...

set "BASH_PATH=C:\Program Files\Git\bin\bash.exe"

:: Check if bash.exe exists at the specified path
if not exist "%BASH_PATH%" (
    echo Error: bash.exe not found at "%BASH_PATH%"
    echo Please check the Git installation path.
    pause
    exit /b 1
)

:: Run the script using the specified bash.exe path
"%BASH_PATH%" -c "$HOME/.cortensor/start-cortensor.sh"

:: Check if the script executed successfully
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to start Cortensor
    pause
    exit /b 1
) else (
    echo Cortensor started successfully
)

exit /b 0
