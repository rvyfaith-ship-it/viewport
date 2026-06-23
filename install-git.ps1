Set-Location -Path 'C:\Users\student\Desktop\webseb'
$installer = Join-Path $env:TEMP 'Git-Installer.exe'
$uri = 'https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe'
Write-Output "Downloading $uri to $installer"

# 強制使用 TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Download-WithRetry {
    param(
        [string]$Url,
        [string]$OutPath,
        [int]$Retries = 3
    )
    $wc = New-Object System.Net.WebClient
    for ($i = 1; $i -le $Retries; $i++) {
        try {
            $wc.DownloadFile($Url, $OutPath)
            Write-Output "Downloaded to $OutPath"
            return $true
        } catch {
            Write-Warning "Download attempt $i failed: $($_.Exception.Message)"
            if ($i -lt $Retries) { Start-Sleep -Seconds (2 * $i) }
        }
    }
    return $false
}

$success = Download-WithRetry -Url $uri -OutPath $installer -Retries 3
if (-not $success) {
    Write-Error "Failed to download installer after multiple attempts. Please check network or download manually: $uri"
    exit 1
}

Write-Output 'Running installer (UAC prompt may appear)...'
Start-Process -FilePath $installer -ArgumentList '/VERYSILENT','/NORESTART' -Wait -Verb RunAs

Write-Output 'Checking git availability...'
if (Test-Path 'C:\Program Files\Git\cmd\git.exe') {
    & 'C:\Program Files\Git\cmd\git.exe' --version
} else {
    try { git --version } catch { Write-Warning 'git not found in PATH after install.' }
}
