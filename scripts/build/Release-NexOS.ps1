param(
    [string]$Version = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = (Get-Content (Join-Path $repoRoot "VERSION") -Raw).Trim()
}

Write-Host "[*] Starting release build for version $Version"
& (Join-Path $repoRoot "scripts\build\Build-NexOS.ps1") -Clean
& (Join-Path $repoRoot "scripts\build\Package-NexOS.ps1") -Version $Version

$releaseNotes = @"
# NexOS $Version

See CHANGELOG.md for the detailed change list.
"@
Set-Content -Path (Join-Path $repoRoot "dist\RELEASE_NOTES.md") -Value $releaseNotes -Encoding UTF8

Write-Host "[+] Release artifacts generated in dist/"
