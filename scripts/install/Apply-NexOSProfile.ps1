param(
    [ValidateSet("GamingMode", "MinimalMode", "AestheticMode")]
    [string]$Preset = "GamingMode"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$presetPath = Join-Path $root "configs\presets\$Preset.json"

if (-not (Test-Path $presetPath)) {
    throw "Preset not found: $presetPath"
}

$cfg = Get-Content $presetPath -Raw | ConvertFrom-Json
Write-Host "Applying preset: $($cfg.name)"

if ($cfg.performance.optimizeIdle -eq $true) {
    & (Join-Path $root "scripts\performance\Optimize-Idle.ps1")
}

if ($cfg.performance.enableGameModeDefault -eq $true) {
    & (Join-Path $root "scripts\performance\GameMode.ps1") -Mode Enable
}

if ($cfg.runtime.installJava -eq $true) {
    & (Join-Path $root "scripts\install\Install-JavaRuntime.ps1")
}

Write-Host "[+] Preset applied."
