$repoRoot = Split-Path -Parent $PSScriptRoot
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
Set-Location -LiteralPath $repoRoot
Start-Transcript -LiteralPath (Join-Path $repoRoot 'runtime-local\oneclick-launcher.log') -Force | Out-Null
$python = Join-Path $repoRoot '.venv\Scripts\python.exe'
$runtime = Join-Path $repoRoot 'runtime-local'
$listener = Get-NetTCPConnection -State Listen -LocalPort 17999 -ErrorAction SilentlyContinue
if ($listener) {
    $owner = Get-CimInstance Win32_Process -Filter "ProcessId=$($listener.OwningProcess)"
    $parent = Get-CimInstance Win32_Process -Filter "ProcessId=$($owner.ParentProcessId)"
    if ($listener.LocalAddress -ne '127.0.0.1' -or $owner.CommandLine -notlike '*server.kk_local.sdo_service*' -or ($owner.ExecutablePath -ne $python -and $parent.ExecutablePath -ne $python)) {
        throw 'Port 17999 belongs to another service. Close the conflicting program first.'
    }
} else {
    $serverScript = Join-Path $repoRoot 'tools\Start-LocalServer.ps1'
    $server = Start-Process -FilePath "$PSHOME\powershell.exe" -ArgumentList "-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$serverScript`"" -WorkingDirectory $repoRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput "$runtime\oneclick-server.log" -RedirectStandardError "$runtime\oneclick-server-error.log"
    $deadline = (Get-Date).AddSeconds(30)
    do {
        $listener = Get-NetTCPConnection -State Listen -LocalAddress 127.0.0.1 -LocalPort 17999 -ErrorAction SilentlyContinue
        if ($listener) { break }
        if ($server.HasExited) { throw "Server startup failed. See $runtime\oneclick-server-error.log" }
        Start-Sleep -Milliseconds 300
    } while ((Get-Date) -lt $deadline)
    if (-not $listener) { throw "Server startup timed out. See $runtime\oneclick-server-error.log" }
}
& (Join-Path $repoRoot 'tools\Start-LegacyGame.ps1')
$game = Get-CimInstance Win32_Process -Filter "Name='gfld.dat'" | Where-Object { $_.ExecutablePath -eq "$runtime\client\gfld.dat" }
if (-not $game) { throw 'The game process did not start.' }
Write-Output "Client running. PID: $($game.ProcessId)"
Stop-Transcript | Out-Null
