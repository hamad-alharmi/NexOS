param(
    [string]$JreMsiUrl = "https://github.com/adoptium/temurin17-binaries/releases/latest/download/OpenJDK17U-jre_x64_windows_hotspot.msi"
)

$ErrorActionPreference = "Stop"
$tempMsi = Join-Path $env:TEMP "nexos-temurin-jre.msi"

Write-Host "Downloading JRE package..."
Invoke-WebRequest -Uri $JreMsiUrl -OutFile $tempMsi

Write-Host "Installing JRE silently..."
Start-Process msiexec.exe -ArgumentList "/i `"$tempMsi`" /qn /norestart" -Wait

Write-Host "[+] Java Runtime installed. .jar execution is now supported."
