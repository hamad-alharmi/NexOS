param(
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$artifactRoot = Join-Path $repoRoot "artifacts"
$publishRoot = Join-Path $artifactRoot "publish"
$shellProject = Join-Path $repoRoot "ui\NexShellPrototype\NexShellPrototype.csproj"

if ($Clean -and (Test-Path $artifactRoot)) {
    Remove-Item -Path $artifactRoot -Recurse -Force
}

New-Item -Path $publishRoot -ItemType Directory -Force | Out-Null

Write-Host "[*] Restoring .NET project..."
dotnet restore $shellProject

Write-Host "[*] Publishing NexShell..."
dotnet publish $shellProject -c Release -r win-x64 --self-contained false -p:PublishSingleFile=false -o (Join-Path $publishRoot "NexShell")

Write-Host "[*] Validating PowerShell scripts..."
$scriptFiles = Get-ChildItem -Path (Join-Path $repoRoot "scripts") -Recurse -Filter *.ps1
foreach ($script in $scriptFiles) {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count -gt 0) {
        throw "Parse error in $($script.FullName): $($errors[0].Message)"
    }
}

Write-Host "[+] Build complete. Artifacts in $artifactRoot"
