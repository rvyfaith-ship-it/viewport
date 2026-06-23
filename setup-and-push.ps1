# setup-and-push.ps1
# 說明：在已安裝 git 且已把 SSH 公鑰加入 GitHub 的情況下，初始化 repo 並推送到指定遠端。
# 使用方法：以 PowerShell 在專案目錄或任何位置執行本檔案（需以使用者身分執行）。

param(
    [string]$ProjectPath = "C:\Users\student\Desktop\webseb",
    [string]$RemoteSsh = 'git@github.com:rvyfaith-ship-it/viewport.git'
)

function ExitWithError($msg) {
    Write-Error $msg
    exit 1
}

# 檢查 git
try {
    git --version > $null 2>&1
} catch {
    ExitWithError 'git not found in PATH. 請先安裝 Git 並重新執行此腳本。'
}
Write-Output "git found: $(git --version)"

# 檢查或建立 SSH key
$sshDir = Join-Path $env:USERPROFILE '.ssh'
if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir | Out-Null }
$pubKey = Join-Path $sshDir 'id_ed25519.pub'
$privKey = Join-Path $sshDir 'id_ed25519'
if (-not (Test-Path $pubKey)) {
    Write-Output 'SSH 公鑰不存在，將為你產生新的 ed25519 金鑰（不設密碼）。'
    ssh-keygen -t ed25519 -f $privKey -N "" -C "webseb@local" | Out-Null
    if (-not (Test-Path $pubKey)) { ExitWithError '產生 SSH 金鑰失敗。請手動建立 SSH 金鑰。' }
}

Write-Output "你的公鑰（複製並貼到 GitHub -> Settings -> SSH and GPG keys）:"
Get-Content $pubKey

Write-Host "
請到 GitHub 新增 SSH 金鑰後，按 Enter 繼續..."
Read-Host | Out-Null

# 確認 SSH 連線
Write-Output '嘗試以 SSH 連線 GitHub（這會產生一個互動式輸出）...'
ssh -T git@github.com 2>&1 | ForEach-Object { Write-Output $_ }
Write-Output '如出現 Hi <user> 的訊息，代表 SSH 金鑰已設定完成。'

# 初始化並推送
if (-not (Test-Path $ProjectPath)) { ExitWithError "找不到專案路徑：$ProjectPath" }
Set-Location -Path $ProjectPath

if (-not (Test-Path '.git')) {
    Write-Output '初始化 git 倉庫...'
    git init
} else {
    Write-Output '已存在 .git 目錄，保留現有設定。'
}

Write-Output '加入檔案並提交...'
git add .
try { git commit -m "Initial commit" } catch { Write-Warning 'Commit 可能失敗（可能沒有變更或已提交）。' }

# 設定主要分支為 main
git branch -M main 2>$null

# 設定/更新遠端
$existing = git remote get-url origin 2>$null
if ($?) {
    Write-Output "已存在 remote origin（$existing），將更新為 $RemoteSsh"
    git remote remove origin
}
Write-Output "新增 remote origin -> $RemoteSsh"
git remote add origin $RemoteSsh

# 推上遠端
Write-Output '推送到遠端 main 分支，可能需要你的 SSH 認證...'
try {
    git push -u origin main
    Write-Output '推送完成！'
} catch {
    Write-Error '推送失敗，請檢查 SSH 金鑰、遠端權限或網路。'
}
