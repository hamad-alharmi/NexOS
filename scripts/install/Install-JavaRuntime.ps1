param(
    [string]$JreMsiUrl = "https://github.com/adoptium/temurin17-binaries/releases/latest/download/OpenJDK17U-jre_x64_windows_hotspot.msi"
)

$ErrorActionPreference = "Stop"
$tempMsi = Join-Path $env:TEMP "nexos-temurin-jre.msi"

function Download-WithRetry {
    param(
        [Parameter(Mandatory = $true)][string]$Url,
        [Parameter(Mandatory = $true)][string]$OutFile,
        [int]$MaxAttempts = 3
    )

    # Force TLS 1.2 for older PowerShell/.NET environments.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            Write-Host "Download attempt $attempt/$MaxAttempts via Invoke-WebRequest..."
            Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
            return
        }
        catch {
            if ($attempt -eq $MaxAttempts) {
                throw
            }
            Start-Sleep -Seconds (2 * $attempt)
        }
    }
}

Write-Host "Downloading JRE package..."
try {
    Download-WithRetry -Url $JreMsiUrl -OutFile $tempMsi
}
catch {
    Write-Warning "Invoke-WebRequest download failed. Falling back to BITS..."
    Start-BitsTransfer -Source $JreMsiUrl -Destination $tempMsi -ErrorAction Stop
}

Write-Host "Installing JRE silently..."
Start-Process msiexec.exe -ArgumentList "/i `"$tempMsi`" /qn /norestart" -Wait

Write-Host "[+] Java Runtime installed. .jar execution is now supported."
