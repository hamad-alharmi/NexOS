param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Import-Module (Join-Path $repoRoot "scripts\lib\NexOS.Common.psm1") -Force
Assert-NexOSAdmin

function Invoke-Step {
    param(
        [string]$Name,
        [scriptblock]$Action
    )
    Write-Host "[*] $Name"
    if (-not $DryRun) {
        & $Action
    }
}

Write-Host "NexOS: Applying idle optimization profile..."

Invoke-Step "Enable High Performance power plan" {
    powercfg /SETACTIVE SCHEME_MIN | Out-Null
}

Invoke-Step "Disable Xbox Game Bar background DVR" {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Type DWord -Value 0
    New-Item -Path "HKCU:\System\GameConfigStore" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
}

Invoke-Step "Set visual effects to performance baseline" {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 2
}

Invoke-Step "Disable selected telemetry services (safe subset)" {
    $services = @("DiagTrack", "dmwappushservice")
    foreach ($svc in $services) {
        if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Disabled
        }
    }
}

Invoke-Step "Disable selected scheduled tasks (safe subset)" {
    $tasks = @(
        @{ TaskPath = "\Microsoft\Windows\Application Experience\"; TaskName = "Microsoft Compatibility Appraiser" },
        @{ TaskPath = "\Microsoft\Windows\Customer Experience Improvement Program\"; TaskName = "Consolidator" },
        @{ TaskPath = "\Microsoft\Windows\Customer Experience Improvement Program\"; TaskName = "UsbCeip" }
    )
    foreach ($task in $tasks) {
        Disable-ScheduledTask -TaskPath $task.TaskPath -TaskName $task.TaskName -ErrorAction SilentlyContinue | Out-Null
    }
}

Write-Host "[+] Idle optimization profile applied."
