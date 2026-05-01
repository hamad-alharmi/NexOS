$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Import-Module (Join-Path $repoRoot "scripts\lib\NexOS.Common.psm1") -Force
Assert-NexOSAdmin

Write-Host "NexOS: Restoring baseline defaults..."

$services = @("DiagTrack", "dmwappushservice", "SysMain", "WSearch")
foreach ($svc in $services) {
    if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
        Set-Service -Name $svc -StartupType Manual
    }
}

try {
    powercfg /SETACTIVE SCHEME_BALANCED | Out-Null
} catch {
    Write-Warning "Could not set balanced plan automatically."
}

Write-Host "[+] Defaults restored (baseline-safe)."
