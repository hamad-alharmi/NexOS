param(
    [string]$OutDir = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

if ([string]::IsNullOrWhiteSpace($OutDir)) {
    $OutDir = Join-Path $repoRoot "artifacts\diag"
}
New-Item -Path $OutDir -ItemType Directory -Force | Out-Null

$sysInfoPath = Join-Path $OutDir "systeminfo.txt"
$servicesPath = Join-Path $OutDir "services.txt"
$tasksPath = Join-Path $OutDir "tasks.txt"
$powerPath = Join-Path $OutDir "powercfg.txt"

systeminfo | Out-File -FilePath $sysInfoPath -Encoding utf8
Get-Service | Sort-Object Name | Format-Table -AutoSize | Out-String | Out-File -FilePath $servicesPath -Encoding utf8
Get-ScheduledTask | Sort-Object TaskPath, TaskName | Select-Object TaskPath, TaskName, State | Format-Table -AutoSize | Out-String | Out-File -FilePath $tasksPath -Encoding utf8
powercfg /L | Out-File -FilePath $powerPath -Encoding utf8

Write-Host "[+] Diagnostics exported to $OutDir"
