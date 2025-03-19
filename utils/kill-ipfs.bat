@echo off
setlocal enabledelayedexpansion

echo Attempting to terminate ipfs.exe processes...

:: Check if any ipfs.exe processes are running
tasklist /FI "IMAGENAME eq ipfs.exe" 2>NUL | find /I "ipfs.exe" >NUL
if %ERRORLEVEL% neq 0 (
    echo No ipfs.exe processes found.
    goto :EOF
)

:: Kill all ipfs.exe processes
taskkill /F /IM ipfs.exe
if %ERRORLEVEL% equ 0 (
    echo Successfully terminated all ipfs.exe processes.
) else (
    echo Failed to terminate some ipfs.exe processes. You might need administrator privileges.
    echo Attempting to terminate with administrator privileges...
    
    :: Create a temporary VBS script to elevate privileges
    echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\elevate.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c taskkill /F /IM ipfs.exe", "", "runas", 1 >> "%TEMP%\elevate.vbs"
    
    :: Run the VBS script
    cscript //nologo "%TEMP%\elevate.vbs"
    del "%TEMP%\elevate.vbs"
    
    :: Check if processes are still running
    timeout /t 2 >NUL
    tasklist /FI "IMAGENAME eq ipfs.exe" 2>NUL | find /I "ipfs.exe" >NUL
    if %ERRORLEVEL% neq 0 (
        echo All ipfs.exe processes have been terminated.
    ) else (
        echo Warning: Some ipfs.exe processes may still be running.
    )
)

exit /b 0
