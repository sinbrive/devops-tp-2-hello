@echo off
REM Batch wrapper to run PowerShell setup script

REM Change to the directory of this batch script
cd /d "%~dp0"

REM Run the PowerShell script bypassing execution policy
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"

pause
