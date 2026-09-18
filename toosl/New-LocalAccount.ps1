$repoRoot = Split-Path -Parent $PSScriptRoot
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $repoRoot
$account = Read-Host 'Account (3-20 letters or digits)'
if ($account -notmatch '^[A-Za-z0-9]{3,20}$') { throw 'Use 3-20 letters or digits.' }
& "$repoRoot\.venv\Scripts\python.exe" -m server.kk_local.accounts --database "$repoRoot\runtime-local\accounts.sqlite3" register $account
if ($LASTEXITCODE) { throw 'Account registration failed.' }
