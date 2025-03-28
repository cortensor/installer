@echo off
setlocal enabledelayedexpansion

echo Upgrading Cortensor...

:: Set path to Git Bash
set "BASH_PATH=C:\Program Files\Git\bin\bash.exe"

:: Check if bash.exe exists at the specified path
if not exist "%BASH_PATH%" (
    echo Error: bash.exe not found at "%BASH_PATH%"
    echo Please make sure Git for Windows is installed.
    pause
    exit /b 1
)

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

:: Remove trailing backslash if present
if "%SCRIPT_DIR:~-1%" == "\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Convert Windows path to Unix-style path for bash
set "UNIX_PATH=%SCRIPT_DIR:\=/%"

echo Running Cortensor upgrade script from: %SCRIPT_DIR%

:: Run the upgrade-win-cygwin.sh script from the same directory
"%BASH_PATH%" -c "cd \"%UNIX_PATH%\" && ../upgrade-win-cygwin.sh"

:: Check if the script executed successfully
if %ERRORLEVEL% neq 0 (
    echo Error: Cortensor upgrade failed with error code %ERRORLEVEL%
    echo Please check the output above for more details.
) else (
    echo Cortensor upgrade completed successfully.
)

pause
exit /b %ERRORLEVEL%
