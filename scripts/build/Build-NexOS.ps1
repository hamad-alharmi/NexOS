param(
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$artifactRoot = Join-Path $repoRoot "artifacts"
$publishRoot = Join-Path $artifactRoot "publish"
$shellProject = Join-Path $repoRoot "ui\NexShellPrototype\NexShellPrototype.csproj"
$overlayProject = Join-Path $repoRoot "ui\NexOverlay\NexOverlay.csproj"
$oneClickProject = Join-Path $repoRoot "ui\NexOSOneClick\NexOSOneClick.csproj"

function Invoke-NexOSExternal {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$Arguments
    )

    & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code ${LASTEXITCODE}: $FilePath $($Arguments -join ' ')"
    }
}

if ($Clean -and (Test-Path $artifactRoot)) {
    Remove-Item -Path $artifactRoot -Recurse -Force
}

New-Item -Path $publishRoot -ItemType Directory -Force | Out-Null

Write-Host "[*] Restoring .NET project..."
Invoke-NexOSExternal -FilePath "dotnet" -Arguments @("restore", $shellProject)
Invoke-NexOSExternal -FilePath "dotnet" -Arguments @("restore", $overlayProject)
Invoke-NexOSExternal -FilePath "dotnet" -Arguments @("restore", $oneClickProject)

Write-Host "[*] Publishing NexShell..."
Invoke-NexOSExternal -FilePath "dotnet" -Arguments @(
    "publish",
    $shellProject,
    "-c", "Release",
    "-r", "win-x64",
    "--self-contained", "false",
    "-p:PublishSingleFile=false",
    "-o", (Join-Path $publishRoot "NexShell")
)

Write-Host "[*] Publishing NexOverlay..."
Invoke-NexOSExternal -FilePath "dotnet" -Arguments @(
    "publish",
    $overlayProject,
    "-c", "Release",
    "-r", "win-x64",
    "--self-contained", "true",
    "-p:PublishSingleFile=true",
    "-p:DebugType=None",
    "-p:DebugSymbols=false",
    "-o", (Join-Path $publishRoot "NexOverlay")
)

Write-Host "[*] Publishing NexOS OneClick (single exe)..."
Invoke-NexOSExternal -FilePath "dotnet" -Arguments @(
    "publish",
    $oneClickProject,
    "-c", "Release",
    "-r", "win-x64",
    "--self-contained", "true",
    "-p:PublishSingleFile=true",
    "-p:DebugType=None",
    "-p:DebugSymbols=false",
    "-o", (Join-Path $publishRoot "NexOSOneClick")
)

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
