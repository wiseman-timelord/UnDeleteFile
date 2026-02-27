<#
.SYNOPSIS
Dependency Installer for UnDeleteFile
#>
function Write-Header {
    Clear-Host
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host "   UnDeleteFile - Package Installer" -ForegroundColor Cyan
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host ""
}

Write-Header
$PackageID = "9N26S50LN705"
$PackageName = "Windows File Recovery"

# 1. Check if winget exists
Write-Host " [1/2] Checking for winget..." -ForegroundColor Yellow
try {
    $null = Get-Command winget -ErrorAction Stop
} catch {
    Write-Host " ERROR: 'winget' is not installed or not in PATH." -ForegroundColor Red
    Write-Host " Please install the App Installer from the Microsoft Store first." -ForegroundColor Gray
    Read-Host "Press Enter to return to Menu"
    exit
}

# 2. Install/Verify Package
Write-Host " [2/2] Verifying/Installing $PackageName..." -ForegroundColor Yellow
Write-Host ""

try {
    # Run winget install directly. It handles "already installed" states gracefully.
    $output = & winget install $PackageID --accept-source-agreements --accept-package-agreements 2>&1
    $exitCode = $LASTEXITCODE

    Write-Host ""
    Write-Host " -------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "  INSTALLATION PROCESS FINISHED " -ForegroundColor Cyan
    Write-Host " -------------------------------------------------------------------------------" -ForegroundColor Cyan

    # Analyze output for status
    $outputString = $output -join " "
    
    if ($outputString -match "Found an existing package" -or $outputString -match "No available upgrade") {
        Write-Host "  Result: ALREADY INSTALLED " -ForegroundColor Green
        Write-Host "  $PackageName is already up-to-date on this system. " -ForegroundColor White
    } 
    elseif ($outputString -match "Successfully installed" -or $exitCode -eq 0) {
        Write-Host "  Result: SUCCESS " -ForegroundColor Green
        Write-Host "  $PackageName has been installed or verified. " -ForegroundColor White
    } 
    else {
        Write-Host "  Result: CHECK LOGS " -ForegroundColor Yellow
        Write-Host "  Winget finished with code: $exitCode " -ForegroundColor Gray
        if ($exitCode -ne 0) {
            Write-Host "  Raw Output: " -ForegroundColor Gray
            Write-Host "  $outputString " -ForegroundColor DarkGray
        }
    }

} catch {
    Write-Host " -------------------------------------------------------------------------------" -ForegroundColor Red
    Write-Host "  INSTALLATION FAILED " -ForegroundColor Red
    Write-Host " -------------------------------------------------------------------------------" -ForegroundColor Red
    Write-Host "  Error: $_ " -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to return to Menu"