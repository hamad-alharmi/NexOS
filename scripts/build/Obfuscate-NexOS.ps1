param(
    [string]$PublishRoot = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ([string]::IsNullOrWhiteSpace($PublishRoot)) {
    $PublishRoot = Join-Path $repoRoot "artifacts\publish"
}

$confuser = Get-Command "Confuser.CLI" -ErrorAction SilentlyContinue
if (-not $confuser) {
    throw "Confuser.CLI not found. Install with: dotnet tool install --global Confuser.CLI"
}

$projectFile = Join-Path $repoRoot "scripts\build\confuser.crproj"
if (-not (Test-Path $projectFile)) {
    throw "Missing confuser project file: $projectFile"
}

Write-Host "[*] Running obfuscation..."
& $confuser.Source -n $projectFile
if ($LASTEXITCODE -ne 0) {
    throw "Obfuscation failed with exit code $LASTEXITCODE"
}

Write-Host "[+] Obfuscation complete."
