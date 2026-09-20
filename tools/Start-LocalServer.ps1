[CmdletBinding()]
param()
$repoRoot = Split-Path -Parent $PSScriptRoot

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $repoRoot
$python = Join-Path $repoRoot '.venv\Scripts\python.exe'
$client = Join-Path $repoRoot 'runtime-local\client'
if (-not (Test-Path -LiteralPath $python)) { throw 'Install Python 3.12, create .venv and install requirements.txt first.' }
if (-not (Test-Path -LiteralPath "$client\gfld.dat")) { throw 'Prepared local game executable gfld.dat is missing.' }
$listeners = @(Get-NetTCPConnection -State Listen -LocalPort 17999,18000,18001,18082 -ErrorAction SilentlyContinue)
if ($listeners.Count) { throw 'A local service port is already occupied. Close the existing service before starting another.' }
if (-not (Test-Path -LiteralPath "$client\SDO\sdologin\sdologin.exe")) {
    Write-Warning 'The client SDK is missing. The server can start, but native client login is not ready.'
}
$run = Join-Path $repoRoot ('runtime-local\run-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
Write-Host "Client: $client"
Write-Host "Runtime: $run"
Write-Host 'Local service only. This does not launch or adapt the game. Ctrl+C stops the service.'
& $python -m server.kk_local.sdo_service --client-root $client --client-exe gfld.dat --runtime $run --database "$repoRoot\runtime-local\accounts.sqlite3"
if ($LASTEXITCODE) { throw "Local service exited with code $LASTEXITCODE" }
