$ErrorActionPreference = "Stop"

$script:StateRoot = Join-Path $env:ProgramData "NexOS\state"
if (-not (Test-Path $script:StateRoot)) {
    New-Item -Path $script:StateRoot -ItemType Directory -Force | Out-Null
}

function Get-NexOSStatePath {
    param([Parameter(Mandatory = $true)][string]$Name)
    return Join-Path $script:StateRoot "$Name.json"
}

function Save-NexOSState {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][hashtable]$Value
    )
    $path = Get-NexOSStatePath -Name $Name
    $Value | ConvertTo-Json -Depth 8 | Set-Content -Path $path -Encoding UTF8
}

function Load-NexOSState {
    param([Parameter(Mandatory = $true)][string]$Name)
    $path = Get-NexOSStatePath -Name $Name
    if (-not (Test-Path $path)) {
        return $null
    }
    return (Get-Content -Path $path -Raw | ConvertFrom-Json)
}

Export-ModuleMember -Function Get-NexOSStatePath, Save-NexOSState, Load-NexOSState
