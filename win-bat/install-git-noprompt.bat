@echo off
setlocal enabledelayedexpansion

echo Installing Git for Windows...

:: Create a temporary directory for downloads
set "TEMP_DIR=%TEMP%\git_installer"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Detect if system is 32-bit or 64-bit
if exist "%ProgramFiles(x86)%" (
  echo Detected 64-bit system
  set "GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe"
  set "INSTALLER=%TEMP_DIR%\Git-2.49.0-64-bit.exe"
  ) else (
  echo Detected 32-bit system
  set "GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.48.1.windows.1/Git-2.48.1-32-bit.exe"
  set "INSTALLER=%TEMP_DIR%\Git-2.48.1-32-bit.exe"
)

echo Downloading Git installer from %GIT_URL%...

:: Download the installer using PowerShell
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GIT_URL%' -OutFile '%INSTALLER%'}"

:: Check if download was successful
if not exist "%INSTALLER%" (
  echo Error: Failed to download Git installer.
  pause
  exit /b 1
)

echo Download completed.

echo Running installer...
:: Run the installer with silent options and wait for completion
start /wait "" "%INSTALLER%" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS

:: Check installation result
if %ERRORLEVEL% neq 0 (
  echo Error: Installation failed with error code %ERRORLEVEL%
  echo Please check the output above for more details.
  ) else (
  echo Git installation completed successfully.
  
  :: Verify the installation by checking if bash.exe exists
  if exist "%ProgramFiles%\Git\bin\bash.exe" (
    echo Git Bash is now available at: "%ProgramFiles%\Git\bin\bash.exe"
    ) else (
    if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" (
      echo Git Bash is now available at: "%ProgramFiles(x86)%\Git\bin\bash.exe"
      ) else (
      echo Warning: Git Bash executable not found at the expected location.
    )
  )
)

:: Clean up the temporary directory
echo Cleaning up temporary files...
rmdir /S /Q "%TEMP_DIR%"

pause
exit /b %ERRORLEVEL%
