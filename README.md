# UnDeleteFile
Status: Planning (Pre-Alpha)

### Description
This will be a program inspired from the following prompt...
```
I just deleted Qwen 3.5 35B A4B Heretic GGUF, with file names "Qwen3.5-35B-A3B-heretic-Q4_K_M.gguf" and "Qwen3.5-35B-A3B-heretic-Q8_0.gguf", here is where I deleted it from G:\LargeModels\Agentic_Models\Qwen3.5-35B-A3B-heretic-GGUF. I need a script for windows 10 that will undelete the two files to "E:\Undelete". i have Windows 10, with, powershell 5.1 + Powershell 7.x. I will put the script in "E:\Undelete" and run it as admin. It will need a batch that DP0 at the start. They are not in the recycle bin.
```
...here was the resulting script...
```
@echo off
setlocal EnableDelayedExpansion

REM =====================================================================
REM  Undelete script for the two specific Qwen3.5-35B-A3B-heretic GGUF files
REM  Place this .bat file in E:\Undelete and run as Administrator
REM
REM  Requirements:
REM  • Windows File Recovery installed from Microsoft Store
REM  • Run this script as Administrator
REM  • Files were deleted from G:\LargeModels\Agentic_Models\Qwen3.5-35B-A3B-heretic-GGUF\
REM =====================================================================

echo.
echo ========================================================
echo   Windows File Recovery - Targeted Undelete Script
echo   Target files:
echo     1. Qwen3.5-35B-A3B-heretic-Q4_K_M.gguf
echo     2. Qwen3.5-35B-A3B-heretic-Q8_0.gguf
echo   Source drive : G:
echo   Destination  : E:\Undelete
echo ========================================================
echo.

REM Check if Windows File Recovery (winfr) is available
where winfr >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: 'winfr' command not found.
    echo.
    echo Please install "Windows File Recovery" from the Microsoft Store.
    echo Search for "Windows File Recovery" in the Store → Install → then run this script again.
    echo.
    pause
    exit /b 1
)

set "DEST=%~dp0"
set "DEST=!DEST:~0,-1!"   REM remove trailing slash

set "PATTERN1=\LargeModels\Agentic_Models\Qwen3.5-35B-A3B-heretic-GGUF\Qwen3.5-35B-A3B-heretic-Q4_K_M.gguf"
set "PATTERN2=\LargeModels\Agentic_Models\Qwen3.5-35B-A3B-heretic-GGUF\Qwen3.5-35B-A3B-heretic-Q8_0.gguf"

echo Destination folder: %DEST%
echo.

echo [1/2] Trying Regular mode recovery...
echo.
winfr G: %DEST% /regular /n %PATTERN1% /n %PATTERN2%

echo.
echo [2/2] Trying Extensive mode recovery (slower, more thorough)...
echo This may take a long time depending on drive size and usage.
echo.
choice /C YN /M "Continue with Extensive mode recovery? (recommended if nothing was found above)"
if errorlevel 2 goto :skip_extensive

winfr G: %DEST% /extensive /n %PATTERN1% /n %PATTERN2%
goto :done

:skip_extensive
echo.
echo Skipped Extensive mode.

:done
echo.
echo ========================================================
echo Recovery finished.
echo.
echo Check folder: %DEST%\Recovery_xxxxxxxx_xxxxxx\
echo (Windows File Recovery creates a new timestamped folder each run)
echo.
echo Look for your .gguf files inside - they may have generic names
echo like "0000000000000000.gguf" — check file size and contents.
echo.
pause
exit /b 0
```
...this solved the dependencies...
```
winget install 9N26S50LN705
```
