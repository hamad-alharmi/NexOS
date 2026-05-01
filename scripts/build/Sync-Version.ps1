param(
    [Parameter(Mandatory = $true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

Set-Content -Path (Join-Path $repoRoot "VERSION") -Value $Version -Encoding ASCII

$installerPath = Join-Path $repoRoot "installer\NexOSInstaller.iss"
$installer = Get-Content -Path $installerPath -Raw
$installer = [Regex]::Replace($installer, "AppVersion=.*", "AppVersion=$Version")
Set-Content -Path $installerPath -Value $installer -Encoding ASCII

Write-Host "[+] Synced version to $Version"
