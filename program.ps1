<#
.SYNOPSIS
UnDeleteFile Recovery Module
#>

$ConfigPath = Join-Path $PSScriptRoot "configuration.json"

# Default Configuration
$script:SourcePath = "G:\Some Folder"
$script:Destination = "E:\Undelete"
$script:FilePatterns = @("SomeFile1.Ext", "SomeFile2.Ext")
$script:RecoveryMode = "regular"

$ModeDescriptions = @{
    "regular"   = "Fastest for Recent Deletes"
    "extensive" = "Scans Entire Drive"
    "segment"   = "File Segments (NTFS Only)"
}

function Load-Config {
    if (Test-Path $ConfigPath) {
        try {
            $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
            $script:SourcePath = $config.SourcePath
            $script:Destination = $config.Destination
            $script:FilePatterns = $config.FilePatterns
            $script:RecoveryMode = $config.RecoveryMode
            Write-Host " Configuration loaded from configuration.json" -ForegroundColor Gray
            Start-Sleep -Seconds 1
        } catch {
            Write-Host " Could not load configuration.json, using defaults." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
    }
}

function Save-Config {
    try {
        $config = @{
            SourcePath = $SourcePath
            Destination = $Destination
            FilePatterns = $FilePatterns
            RecoveryMode = $RecoveryMode
        }
        $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $ConfigPath -Encoding UTF8
        Write-Host " Configuration saved to configuration.json" -ForegroundColor Green
    } catch {
        Write-Host " Could not save configuration: $_ " -ForegroundColor Red
    }
}

function Show-Header {
    Clear-Host
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host "    UnDeleteFile" -ForegroundColor Cyan
    Write-Host "===============================================================================" -ForegroundColor Cyan
}

function Show-Config {
    1..8 | ForEach-Object { Write-Host "" }
    
    Write-Host "    1. Set Full Path: $SourcePath" -ForegroundColor White
    Write-Host ""
    Write-Host "    2. Set File Name(s): $($FilePatterns -join ', ')" -ForegroundColor White
    Write-Host ""
    Write-Host "    3. Set Destination: $Destination" -ForegroundColor White
    Write-Host ""
    Write-Host "    4. Set Recovery Mode: $RecoveryMode ($($ModeDescriptions[$RecoveryMode]))" -ForegroundColor White
    
    1..8 | ForEach-Object { Write-Host "" }
    
    Write-Host "-------------------------------------------------------------------------------" -ForegroundColor Gray
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
    $newPatterns = Read-Host "Enter file names/extensions (comma separated, e.g., *.gguf, document.docx)"
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

function Edit-Mode {
    Clear-Host
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host "    Recovery Mode Selection" -ForegroundColor Cyan
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    1. Regular   - $($ModeDescriptions['regular'])" -ForegroundColor White
    Write-Host ""
    Write-Host "    2. Extensive - $($ModeDescriptions['extensive'])" -ForegroundColor White
    Write-Host ""
    Write-Host "    3. Segment   - $($ModeDescriptions['segment'])" -ForegroundColor White
    Write-Host ""
    Write-Host "    Current Mode: $RecoveryMode ($($ModeDescriptions[$RecoveryMode]))" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "-------------------------------------------------------------------------------" -ForegroundColor Gray
    
    $modeChoice = Read-Host "Select Mode (1-3)"
    
    switch ($modeChoice) {
        '1' { 
            $script:RecoveryMode = "regular"
            Write-Host "Mode set to Regular." -ForegroundColor Green 
        }
        '2' { 
            $script:RecoveryMode = "extensive"
            Write-Host "Mode set to Extensive." -ForegroundColor Green 
        }
        '3' { 
            $script:RecoveryMode = "segment"
            Write-Host "Mode set to Segment." -ForegroundColor Green 
        }
        default { 
            Write-Host "Invalid selection." -ForegroundColor Red 
        }
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

    $sourceDriveLetter = $SourcePath.Substring(0,2)
    
    if ($sourceDriveLetter.Substring(0,1) -eq $Destination.Substring(0,1)) {
        Write-Host " ERROR: Destination cannot be on the same drive as Source. " -ForegroundColor Red
        Read-Host "Press Enter to return "
        return
    }

    Write-Host " 'winfr' found. Preparing recovery... " -ForegroundColor Green
    Write-Host " "

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

    Save-Config

    $argList = @("$sourceDriveLetter", "$Destination", "/$RecoveryMode")
    
    foreach ($pattern in $FilePatterns) {
        $argList += "/n"
        if ($pattern -notmatch "^\*\.") {
            $argList += "*$pattern"
        } else {
            $argList += "$pattern"
        }
    }

    Write-Host "-------------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host " Starting Recovery Process... " -ForegroundColor Cyan
    Write-Host " Mode : $RecoveryMode ($($ModeDescriptions[$RecoveryMode]))" -ForegroundColor White
    Write-Host " Source : $sourceDriveLetter " -ForegroundColor White
    Write-Host " Target : $Destination " -ForegroundColor White
    Write-Host "-------------------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host " "
    
    if ($RecoveryMode -eq "extensive") {
        Write-Host " NOTE: Extensive mode can take several hours for large drives." -ForegroundColor Yellow
        Write-Host " "
    }

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
Load-Config

do {
    Show-Header
    Show-Config
    $choice = Read-Host "Selection; Menu Option 1-4, Run Recovery=R, Exit Program=X:"
    
    switch ($choice.ToUpper()) {
        '1' { Edit-Source }
        '2' { Edit-Patterns }
        '3' { Edit-Destination }
        '4' { Edit-Mode }
        'R' { Start-Recovery }
        'X' { Write-Host "Exiting..."; Start-Sleep -Seconds 1 }
        default { Write-Host "Invalid selection."; Start-Sleep -Seconds 1 }
    }
} until ($choice -eq 'X')