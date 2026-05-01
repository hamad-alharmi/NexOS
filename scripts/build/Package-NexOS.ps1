param(
    [string]$Version = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$artifactRoot = Join-Path $repoRoot "artifacts"
$publishRoot = Join-Path $artifactRoot "publish"
$distRoot = Join-Path $repoRoot "dist"

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = (Get-Content (Join-Path $repoRoot "VERSION") -Raw).Trim()
}

if (-not (Test-Path $publishRoot)) {
    throw "Publish output missing. Run Build-NexOS.ps1 first."
}

New-Item -Path $distRoot -ItemType Directory -Force | Out-Null

$staging = Join-Path $artifactRoot "staging"
if (Test-Path $staging) {
    Remove-Item -Path $staging -Recurse -Force
}
New-Item -Path $staging -ItemType Directory -Force | Out-Null

Copy-Item -Path (Join-Path $repoRoot "scripts") -Destination (Join-Path $staging "scripts") -Recurse -Force
Copy-Item -Path (Join-Path $repoRoot "configs") -Destination (Join-Path $staging "configs") -Recurse -Force
Copy-Item -Path (Join-Path $repoRoot "tools") -Destination (Join-Path $staging "tools") -Recurse -Force
Copy-Item -Path (Join-Path $publishRoot "NexShell") -Destination (Join-Path $staging "ui\NexShell") -Recurse -Force
Copy-Item -Path (Join-Path $repoRoot "README.md") -Destination (Join-Path $staging "README.md") -Force

$zipPath = Join-Path $distRoot "NexOS-$Version-win64.zip"
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}

Compress-Archive -Path (Join-Path $staging "*") -DestinationPath $zipPath -CompressionLevel Optimal

$hash = Get-FileHash -Path $zipPath -Algorithm SHA256
$hashLine = "$($hash.Hash) *$(Split-Path $zipPath -Leaf)"
Set-Content -Path (Join-Path $distRoot "NexOS-$Version-win64.sha256") -Value $hashLine -Encoding ASCII

Write-Host "[+] Package ready:"
Write-Host "    $zipPath"
