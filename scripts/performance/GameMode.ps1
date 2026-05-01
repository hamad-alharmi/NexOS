param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Enable", "Disable")]
    [string]$Mode
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Import-Module (Join-Path $repoRoot "scripts\lib\NexOS.State.psm1") -Force
Import-Module (Join-Path $repoRoot "scripts\lib\NexOS.Common.psm1") -Force
Assert-NexOSAdmin

function Set-ServiceState {
    param(
        [string]$ServiceName,
        [ValidateSet("Disabled", "Manual", "Automatic")]
        [string]$StartupType
    )
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        if ($StartupType -eq "Disabled") {
            Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
        }
        Set-Service -Name $ServiceName -StartupType $StartupType
    }
}

$targetServices = @("SysMain", "WSearch")

if ($Mode -eq "Enable") {
    Write-Host "NexOS Game Mode: enabling..."
    $old = @{}
    foreach ($svc in $targetServices) {
        $s = Get-CimInstance Win32_Service -Filter "Name='$svc'" -ErrorAction SilentlyContinue
        if ($null -ne $s) {
            $old[$svc] = $s.StartMode
            Set-ServiceState -ServiceName $svc -StartupType Disabled
        }
    }

    powercfg /SETACTIVE SCHEME_MIN | Out-Null
    Save-NexOSState -Name "gamemode-state" -Value @{
        timestamp = (Get-Date).ToString("o")
        services  = $old
    }

    Write-Host "[+] Game Mode enabled."
    exit 0
}

if ($Mode -eq "Disable") {
    Write-Host "NexOS Game Mode: disabling..."
    $saved = Load-NexOSState -Name "gamemode-state"
    if ($null -ne $saved -and $saved.services) {
        foreach ($prop in $saved.services.PSObject.Properties) {
            $startup = switch ($prop.Value) {
                "Auto" { "Automatic" }
                "Manual" { "Manual" }
                default { "Manual" }
            }
            Set-ServiceState -ServiceName $prop.Name -StartupType $startup
        }
    }
    Write-Host "[+] Game Mode disabled."
}
