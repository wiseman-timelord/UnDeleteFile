@echo off
setlocal EnableDelayedExpansion
title UnDeleteFile
mode con cols=85 lines=30
powershell -noprofile -command "& { $w = $Host.UI.RawUI; $b = $w.BufferSize; $b.Height = 6000; $w.BufferSize = $b; }"

:: DP0 TO SCRIPT BLOCK
set "ScriptDirectory=%~dp0"
set "ScriptDirectory=%ScriptDirectory:~0,-1%"
cd /d "%ScriptDirectory%"
echo Dp0'd to Script.

:MENU
cls
echo ===============================================================================
echo    UnDeleteFile
echo ===============================================================================
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo     1. Run UnDeleteFile Tool
echo.
echo     2. Install Dependencies
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo -------------------------------------------------------------------------------
set /p selection="Selection; Menu Options = 1-2, Exit Batch = X: "

if "%selection%"=="1" goto RUN_PROGRAM
if "%selection%"=="2" goto INSTALLER
if "%selection%"=="X" goto EOF
goto MENU

:RUN_PROGRAM
cls
echo Launching UnDeleteFile Tool...
if exist "%~dp0program.ps1" (
    powershell.exe -ExecutionPolicy Bypass -File "%~dp0program.ps1"
) else (
    echo ERROR: program.ps1 not found in the current directory.
    pause
)
goto MENU

:INSTALLER
cls
echo Launching Installer...
if exist "%~dp0installer.ps1" (
    powershell.exe -ExecutionPolicy Bypass -File "%~dp0installer.ps1"
) else (
    echo ERROR: installer.ps1 not found in the current directory.
    pause
)
goto MENU

:EOF
exit /b