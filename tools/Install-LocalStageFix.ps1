# Run manually after reviewing. Installs only the local stage fix; never contacts production.
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$serverDir = Join-Path $repo 'dist\local-server'
$serverExe = Join-Path $serverDir 'kungfu-server.exe'
$candidate = Join-Path $serverDir 'kungfu-server-stage-fix.exe'
$gmDir = Join-Path $repo 'dist\GM管理器'
$gmRelease = Join-Path $env:TEMP 'openkfo-gm-local-stage-20260922\build\windows\x64\runner\Release'
$settings = Get-Content -LiteralPath (Join-Path $serverDir 'settings.private.json') -Raw | ConvertFrom-Json
if ($settings.ssh_config -or $settings.database -ne 'kungfu_game' -or $settings.dsn -notmatch '127\.0\.0\.1:3306') { throw 'Expected direct local database configuration.' }
if ((Get-FileHash -LiteralPath $candidate -Algorithm SHA256).Hash -ne '27C4CD9827E383D8354BA69832473CE9AC1031763AF73DE5D298C20D0BCC430B') { throw 'Server candidate changed; rebuild/review before installing.' }
if (-not (Test-Path -LiteralPath (Join-Path $gmRelease 'kungfu_item_manager.exe'))) { throw 'GM build is missing.' }
$gmExe = Join-Path $gmDir 'GM管理器.exe'
if (Get-CimInstance Win32_Process | Where-Object ExecutablePath -EQ $gmExe) { throw 'Close the GM manager first.' }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$serverBackup = Join-Path $serverDir "kungfu-server.before-stage-$stamp.exe"
Copy-Item -LiteralPath $serverExe -Destination $serverBackup
$gmBackup = Join-Path $repo "dist\package-backups\gm-before-stage-$stamp"
Copy-Item -LiteralPath $gmDir -Destination $gmBackup -Recurse
try {
    foreach ($worker in @(Get-CimInstance Win32_Process | Where-Object ExecutablePath -EQ $serverExe)) {
        Stop-Process -Id $worker.ProcessId -Force
        Wait-Process -Id $worker.ProcessId -ErrorAction SilentlyContinue
    }
    # Windows can hold the image briefly after process exit.
    for ($attempt = 0; ; $attempt++) {
        try { Copy-Item -LiteralPath $candidate -Destination $serverExe -Force; break }
        catch { if ($attempt -ge 9) { throw }; Start-Sleep -Milliseconds 500 }
    }
    Get-ChildItem -LiteralPath $gmRelease | Where-Object Name -NE 'kungfu_item_manager.exe' | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $gmDir -Recurse -Force
    }
    Copy-Item -LiteralPath (Join-Path $gmRelease 'kungfu_item_manager.exe') -Destination $gmExe -Force
} catch {
    Copy-Item -LiteralPath $serverBackup -Destination $serverExe -Force
    Get-ChildItem -LiteralPath $gmBackup | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $gmDir -Recurse -Force }
    throw
} finally {
    if (-not (Get-CimInstance Win32_Process | Where-Object ExecutablePath -EQ $serverExe)) {
        Start-Process -FilePath $serverExe -WorkingDirectory $serverDir -WindowStyle Hidden -RedirectStandardOutput (Join-Path $serverDir "stage-$stamp.out.log") -RedirectStandardError (Join-Path $serverDir "stage-$stamp.err.log") | Out-Null
    }
}
Write-Host 'Local server and GM installed. Re-login to refresh the stage list.'
Write-Host $gmExe
