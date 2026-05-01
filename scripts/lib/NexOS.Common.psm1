$ErrorActionPreference = "Stop"

function Test-NexOSAdmin {
    $current = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($current)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Assert-NexOSAdmin {
    if (-not (Test-NexOSAdmin)) {
        throw "Administrator privileges are required. Re-run in elevated PowerShell."
    }
}

function Get-NexOSRepoRootFromScriptPath {
    param([Parameter(Mandatory = $true)][string]$ScriptRoot)
    return Split-Path -Parent (Split-Path -Parent $ScriptRoot)
}

Export-ModuleMember -Function Test-NexOSAdmin, Assert-NexOSAdmin, Get-NexOSRepoRootFromScriptPath
