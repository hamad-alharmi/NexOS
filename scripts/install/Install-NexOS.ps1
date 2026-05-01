param(
    [ValidateSet("GamingMode", "MinimalMode", "AestheticMode")]
    [string]$Preset = "GamingMode",
    [string]$InstallRoot = "C:\Program Files\NexOS",
    [switch]$SkipJava
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Import-Module (Join-Path $repoRoot "scripts\lib\NexOS.Common.psm1") -Force
Assert-NexOSAdmin

Write-Host "[*] Installing NexOS to $InstallRoot"
New-Item -Path $InstallRoot -ItemType Directory -Force | Out-Null

Copy-Item -Path (Join-Path $repoRoot "scripts") -Destination (Join-Path $InstallRoot "scripts") -Recurse -Force
Copy-Item -Path (Join-Path $repoRoot "configs") -Destination (Join-Path $InstallRoot "configs") -Recurse -Force
Copy-Item -Path (Join-Path $repoRoot "tools") -Destination (Join-Path $InstallRoot "tools") -Recurse -Force
if (Test-Path (Join-Path $repoRoot "themes")) {
    Copy-Item -Path (Join-Path $repoRoot "themes") -Destination (Join-Path $InstallRoot "themes") -Recurse -Force
}
if (Test-Path (Join-Path $repoRoot "registry")) {
    Copy-Item -Path (Join-Path $repoRoot "registry") -Destination (Join-Path $InstallRoot "registry") -Recurse -Force
}

$shellBuiltPath = Join-Path $repoRoot "artifacts\publish\NexShell"
if (Test-Path $shellBuiltPath) {
    Copy-Item -Path $shellBuiltPath -Destination (Join-Path $InstallRoot "ui\NexShell") -Recurse -Force
}

if ($SkipJava) {
    Write-Host "[*] Java install skipped by flag."
} else {
    & (Join-Path $InstallRoot "scripts\install\Install-JavaRuntime.ps1")
}

if ($SkipJava) {
    & (Join-Path $InstallRoot "scripts\install\Apply-NexOSProfile.ps1") -Preset $Preset -SkipJava
} else {
    & (Join-Path $InstallRoot "scripts\install\Apply-NexOSProfile.ps1") -Preset $Preset
}

Write-Host "[+] NexOS installed."
