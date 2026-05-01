param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("preset", "gamemode", "optimize", "restore", "install", "uninstall", "build", "package", "release", "diag", "smoke", "sync-version", "overlay", "oneclick", "obfuscate")]
    [string]$Command,
    [string]$Arg = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

switch ($Command) {
    "preset" {
        if ([string]::IsNullOrWhiteSpace($Arg)) {
            throw "Usage: .\tools\nexctl.ps1 -Command preset -Arg GamingMode|MinimalMode|AestheticMode"
        }
        & (Join-Path $root "scripts\install\Apply-NexOSProfile.ps1") -Preset $Arg
    }
    "gamemode" {
        if ([string]::IsNullOrWhiteSpace($Arg)) {
            throw "Usage: .\tools\nexctl.ps1 -Command gamemode -Arg Enable|Disable"
        }
        & (Join-Path $root "scripts\performance\GameMode.ps1") -Mode $Arg
    }
    "optimize" {
        & (Join-Path $root "scripts\performance\Optimize-Idle.ps1")
    }
    "restore" {
        & (Join-Path $root "scripts\performance\Restore-Defaults.ps1")
    }
    "install" {
        $preset = if ([string]::IsNullOrWhiteSpace($Arg)) { "GamingMode" } else { $Arg }
        & (Join-Path $root "scripts\install\Install-NexOS.ps1") -Preset $preset
    }
    "uninstall" {
        & (Join-Path $root "scripts\install\Uninstall-NexOS.ps1")
    }
    "build" {
        & (Join-Path $root "scripts\build\Build-NexOS.ps1") -Clean
    }
    "package" {
        & (Join-Path $root "scripts\build\Package-NexOS.ps1")
    }
    "release" {
        & (Join-Path $root "scripts\build\Release-NexOS.ps1")
    }
    "diag" {
        & (Join-Path $root "scripts\ops\Export-Diagnostics.ps1")
    }
    "smoke" {
        & (Join-Path $root "scripts\qa\Smoke-Test.ps1")
    }
    "sync-version" {
        if ([string]::IsNullOrWhiteSpace($Arg)) {
            throw "Usage: .\tools\nexctl.ps1 -Command sync-version -Arg 0.2.0"
        }
        & (Join-Path $root "scripts\build\Sync-Version.ps1") -Version $Arg
    }
    "overlay" {
        $overlayExe = Join-Path $root "artifacts\publish\NexOverlay\NexOverlay.exe"
        if (-not (Test-Path $overlayExe)) {
            throw "Overlay exe not found. Run build first."
        }
        Start-Process -FilePath $overlayExe
    }
    "oneclick" {
        $oneClickExe = Join-Path $root "artifacts\publish\NexOSOneClick\NexOSOneClick.exe"
        if (-not (Test-Path $oneClickExe)) {
            throw "OneClick exe not found. Run build first."
        }
        Start-Process -FilePath $oneClickExe
    }
    "obfuscate" {
        & (Join-Path $root "scripts\build\Obfuscate-NexOS.ps1")
    }
}
