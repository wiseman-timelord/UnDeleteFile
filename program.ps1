<#
.SYNOPSIS
UnDeleteFile Recovery Module
#>

# Default Configuration
$script:SourcePath = "G:\Some Folder"
$script:Destination = "E:\Some Folder"
$script:FilePatterns = @("SomeFile1.Ext", "SomeFile2.Ext")

function Show-Header {
    Clear-Host
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host "    UnDeleteFile" -ForegroundColor Cyan
    Write-Host "===============================================================================" -ForegroundColor Cyan
    # No trailing newline here, managed in Show-Config for exact spacing
}

function Show-Config {
    # 8 Empty Lines after Header
    1..8 | ForEach-Object { Write-Host "" }
    
    Write-Host "    1. Set Full Path: $SourcePath" -ForegroundColor White
    Write-Host ""
    Write-Host "    2. Set File Name(s): $($FilePatterns -join ', ')" -ForegroundColor White
    Write-Host ""
    Write-Host "    3. Set Destination: $Destination" -ForegroundColor White
    
    # 8 Empty Lines before Footer
    1..8 | ForEach-Object { Write-Host "" }
    
    Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------------------" -ForegroundColor Gray
}

function Edit-Source {
    $newPath = Read-Host "Enter Full Path or Drive (e.g., G:\ or G:\Folder)"
    if ($newPath) {
        $script:SourcePath = $newPath
        Write-Host "Path updated." -ForegroundColor Green
    }
    Start-Sleep -Seconds 1
}

function Edit-Patterns {
    $newPatterns = Read-Host "Enter file names/extensions (comma separated, e.g., *.jpg, document.docx)"
    if ($newPatterns) {
        $script:FilePatterns = $newPatterns.Split(',') | ForEach-Object { $_.Trim() }
        Write-Host "File Patterns updated." -ForegroundColor Green
    }
    Start-Sleep -Seconds 1
}

function Edit-Destination {
    Write-Host "IMPORTANT: Destination MUST be on a different drive than Source." -ForegroundColor Yellow
    $newDest = Read-Host "Enter Destination Path (e.g., E:\Undelete)"
    if ($newDest) {
        $script:Destination = $newDest
        Write-Host "Destination updated." -ForegroundColor Green
    }
    Start-Sleep -Seconds 1
}

function Start-Recovery {
    Show-Header
    Write-Host " Checking for Windows File Recovery (winfr)..." -ForegroundColor Yellow
    $winfr = Get-Command winfr -ErrorAction SilentlyContinue

    if (-not $winfr) {
        Write-Host " ERROR: 'winfr' not found. " -ForegroundColor Red
        Write-Host " Please run Option 2 (Install Packages) from the Main Menu. " -ForegroundColor Red
        Read-Host "Press Enter to return "
        return
    }

    # Extract Drive Letter from Source Path for winfr (winfr requires 'G:' not 'G:\Folder')
    $sourceDriveLetter = $SourcePath.Substring(0,2)
    
    # Validate Destination != Source
    if ($sourceDriveLetter.Substring(0,1) -eq $Destination.Substring(0,1)) {
        Write-Host " ERROR: Destination cannot be on the same drive as Source. " -ForegroundColor Red
        Read-Host "Press Enter to return "
        return
    }

    Write-Host " 'winfr' found. Preparing recovery... " -ForegroundColor Green
    Write-Host " "

    # Ensure destination directory exists
    if (-not (Test-Path $Destination)) {
        try {
            New-Item -Path $Destination -ItemType Directory -Force | Out-Null
            Write-Host " Created destination folder: $Destination " -ForegroundColor Gray
        } catch {
            Write-Host " Error creating destination folder: $_ " -ForegroundColor Red
            Read-Host "Press Enter to return "
            return
        }
    }

    # Build arguments
    $argList = @("$sourceDriveLetter", "$Destination", "/regular")
    foreach ($pattern in $FilePatterns) {
        $argList += "/n"
        if ($pattern -notmatch "^\\") {
            $argList += "\$pattern"
        } else {
            $argList += "$pattern"
        }
    }

    Write-Host "-----------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host " Starting Recovery Process... " -ForegroundColor Cyan
    Write-Host "-----------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host " "

    try {
         & winfr $argList
        Write-Host " "
        Write-Host " Recovery process initiated. Check output above for results. " -ForegroundColor Green
    } catch {
        Write-Host " Error running winfr: $_ " -ForegroundColor Red
    }

    Read-Host "Press Enter to return to menu "
}

# Main Loop
do {
    Show-Header
    Show-Config
    $choice = Read-Host "Selection; Menu Options = 1-3, Run Recovery = R, Exit Program = X"
    
    switch ($choice.ToUpper()) {
        '1' { Edit-Source }
        '2' { Edit-Patterns }
        '3' { Edit-Destination }
        'R' { Start-Recovery }
        'X' { Write-Host "Exiting..."; Start-Sleep -Seconds 1 }
        default { Write-Host "Invalid selection."; Start-Sleep -Seconds 1 }
    }
} until ($choice -eq 'X')