$repoRoot = Split-Path -Parent $PSScriptRoot
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $repoRoot
$client = Join-Path $repoRoot 'runtime-local\client'
$python = Join-Path $repoRoot '.venv\Scripts\python.exe'
if (-not (Get-NetTCPConnection -State Listen -LocalAddress 127.0.0.1 -LocalPort 17999 -ErrorAction SilentlyContinue)) {
    throw 'Start the local server first: Start-LocalServer.cmd'
}
$listener = Get-NetTCPConnection -State Listen -LocalPort 18084 -ErrorAction SilentlyContinue
if ($listener) {
    $owner = Get-CimInstance Win32_Process -Filter "ProcessId=$($listener.OwningProcess)"
    $parent = Get-CimInstance Win32_Process -Filter "ProcessId=$($owner.ParentProcessId)"
    $ourPython = $owner.ExecutablePath -eq $python -or $parent.ExecutablePath -eq $python
    if ($listener.LocalAddress -ne '127.0.0.1' -or $owner.CommandLine -notlike '*server.kk_local.legacy_login*' -or -not $ourPython) {
        throw 'Port 18084 belongs to another process.'
    }
} else {
    Start-Process -FilePath $python -ArgumentList '-u','-m','server.kk_local.legacy_login' -WorkingDirectory $repoRoot -WindowStyle Hidden -RedirectStandardOutput "$repoRoot\runtime-local\legacy-login.log" -RedirectStandardError "$repoRoot\runtime-local\legacy-login-error.log"
    for ($attempt = 0; $attempt -lt 20; $attempt++) {
        if (Get-NetTCPConnection -State Listen -LocalAddress 127.0.0.1 -LocalPort 18084 -ErrorAction SilentlyContinue) { break }
        Start-Sleep -Milliseconds 250
    }
    if (-not (Get-NetTCPConnection -State Listen -LocalAddress 127.0.0.1 -LocalPort 18084 -ErrorAction SilentlyContinue)) { throw 'Legacy login service failed; see runtime-local\legacy-login-error.log' }
}
$running = Get-CimInstance Win32_Process -Filter "Name='gfld.dat'" | Where-Object ExecutablePath -eq "$client\gfld.dat"
if (-not $running) {
    # .dat is an executable here; avoid Windows file-association dispatch.
    $gameInfo = New-Object System.Diagnostics.ProcessStartInfo
    $gameInfo.FileName = "$client\gfld.dat"
    $gameInfo.WorkingDirectory = $client
    $gameInfo.UseShellExecute = $false
    [void][System.Diagnostics.Process]::Start($gameInfo)
}
