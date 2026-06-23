$git = "C:\Program Files\Git\cmd\git.exe"
Set-Location "C:\Users\student\Desktop\webseb"

Write-Output "Using git: $git"
& $git config user.name "webseb user"
& $git config user.email "webseb@example.com"
& $git init
& $git add .

$changes = & $git status --porcelain
if ($changes) {
    Write-Output "Changes detected, creating commit..."
    & $git commit -m "Initial commit"
} else {
    Write-Output "No changes to commit."
}

& $git branch -M main

$remoteExists = $false
try {
    & $git remote get-url origin 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $remoteExists = $true }
} catch {
    $remoteExists = $false
}

if ($remoteExists) {
    Write-Output "Remote origin exists, removing it..."
    & $git remote remove origin
}

Write-Output "Adding remote origin git@github.com:rvyfaith-ship-it/viewport.git"
& $git remote add origin git@github.com:rvyfaith-ship-it/viewport.git

Write-Output "Pushing to origin main..."
& $git push -u origin main
