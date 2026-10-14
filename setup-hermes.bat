@echo off
rem ==========================================
rem Hermes LinkedIn Automation Setup (Windows)
rem ==========================================
echo.
echo === LinkedIn Automation Sovereignty Kit — Hermes Setup ===
echo.

:: Step 1: Check Hermes is installed
if not exist "%APPDATA%\hermes\hermes-agent\venv\python.exe" (
    echo ERROR: Hermes not found at %APPDATA%\hermes\hermes-agent
    echo Please install Hermes desktop first.
    pause
    exit /b 1
)

:: Step 2: Create profile folder
set PROFILE_NAME=linkedin-base-%date:~-4%
mkdir "%APPDATA%\hermes\profiles\%PROFILE_NAME%"
echo Profile folder created: %APPDATA%\hermes\profiles\%PROFILE_NAME%

:: Step 3: Copy base config
copy /y "linkedin-base-config.yaml" "%APPDATA%\hermes\profiles\%PROFILE_NAME%\config.yaml" >nul
echo Base config copied.

:: Step 4: Enable required tools
echo.
echo enabling tools... this may take a moment.
hermes setup --quick --tools 2>nul | find /i "Firecrawl" && echo Firecrawl: OK || echo Firecrawl: skipping (optional)

:: Step 5: Final check
echo.
echo === Setup Complete ===
echo Your profile: %APPDATA%\hermes\profiles\%PROFILE_NAME%
echo 1. Open Hermes Desktop
echo 2. Select your new profile
echo 3. Run: hermes run scripts\linkedin-daily-enrich.sh
echo.
pause
