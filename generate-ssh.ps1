$pub = Join-Path $env:USERPROFILE '.ssh\id_ed25519.pub'
$priv = Join-Path $env:USERPROFILE '.ssh\id_ed25519'
if (-not (Test-Path $pub)) {
    Write-Output 'SSH 公鑰不存在，將產生新的 ed25519 金鑰（不設密碼）'
    New-Item -ItemType Directory -Path (Join-Path $env:USERPROFILE '.ssh') -ErrorAction SilentlyContinue | Out-Null
    if (Test-Path 'C:\Program Files\Git\usr\bin\ssh-keygen.exe') {
        & 'C:\Program Files\Git\usr\bin\ssh-keygen.exe' -t ed25519 -f $priv -N '' -C 'webseb@local'
    } else {
        ssh-keygen -t ed25519 -f $priv -N '' -C 'webseb@local'
    }
} else {
    Write-Output 'SSH 公鑰已存在，顯示中...'
}
Write-Output '---PUBLIC KEY START---'
Get-Content $pub
Write-Output '---PUBLIC KEY END---'
