$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

Write-Host "[*] Running NexOS smoke tests..."

$required = @(
    "scripts\build\Build-NexOS.ps1",
    "scripts\build\Package-NexOS.ps1",
    "scripts\install\Install-NexOS.ps1",
    "scripts\install\Uninstall-NexOS.ps1",
    "scripts\build\Obfuscate-NexOS.ps1",
    "scripts\performance\GameMode.ps1",
    "tools\nexctl.ps1",
    "configs\presets\GamingMode.json",
    "ui\NexOverlay\NexOverlay.csproj",
    "ui\NexOSOneClick\NexOSOneClick.csproj"
)

foreach ($rel in $required) {
    $p = Join-Path $repoRoot $rel
    if (-not (Test-Path $p)) {
        throw "Missing required file: $rel"
    }
}

$ps1Files = Get-ChildItem -Path (Join-Path $repoRoot "scripts") -Recurse -Filter *.ps1
foreach ($f in $ps1Files) {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($f.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count -gt 0) {
        throw "Parse error in $($f.FullName): $($errors[0].Message)"
    }
}

Write-Host "[+] Smoke tests passed."
