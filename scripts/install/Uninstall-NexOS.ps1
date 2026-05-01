param(
    [string]$InstallRoot = "C:\Program Files\NexOS",
    [switch]$KeepConfigs
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Import-Module (Join-Path $repoRoot "scripts\lib\NexOS.Common.psm1") -Force
Assert-NexOSAdmin

Write-Host "[*] Restoring defaults before uninstall..."
if (Test-Path (Join-Path $InstallRoot "scripts\performance\Restore-Defaults.ps1")) {
    & (Join-Path $InstallRoot "scripts\performance\Restore-Defaults.ps1")
}

Write-Host "[*] Removing install directory..."
if (Test-Path $InstallRoot) {
    if ($KeepConfigs) {
        Get-ChildItem $InstallRoot -Force | Where-Object { $_.Name -ne "configs" } | Remove-Item -Recurse -Force
    } else {
        Remove-Item -Path $InstallRoot -Recurse -Force
    }
}

Write-Host "[+] NexOS uninstalled."
