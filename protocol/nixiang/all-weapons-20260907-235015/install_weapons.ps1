$ErrorActionPreference = 'Stop'
$weaponProject = 'C:\Users\24032\Desktop\code\kungfu-mock-server'
$weaponLab = Join-Path $weaponProject 'research\2026-09-06\work\login-to-world'
$weaponPython = Join-Path $weaponProject 'toolchain\python313\python.exe'
$weaponServer = Get-CimInstance Win32_Process -Filter "ProcessId=22820"
if (!$weaponServer -or $weaponServer.ExecutablePath -ne $weaponPython -or $weaponServer.CommandLine -notlike '*lab_server_v4.py*') {
    throw 'The previously observed v4 process no longer matches; refusing to stop another process.'
}
if ((Get-FileHash -LiteralPath (Join-Path $weaponLab 'role_protocol.py')).Hash -ne 'EA7C295882B1371B8FE891C856015D5A0B4DC7BA473D1EFAAA32E94FCC290CBF') {
    throw 'Role source changed; refusing stale installation.'
}
$weaponStop = Join-Path $weaponLab 'lab-stop-v4'
[IO.File]::WriteAllText($weaponStop, 'Install local weapons inventory')
$weaponDeadline = [DateTime]::UtcNow.AddSeconds(20)
while ((Get-Process -Id 22820 -ErrorAction SilentlyContinue) -and [DateTime]::UtcNow -lt $weaponDeadline) {
    Start-Sleep -Milliseconds 250
}
if (Get-Process -Id 22820 -ErrorAction SilentlyContinue) { throw 'v4 did not stop gracefully; no files or database replaced.' }
try {
    & $weaponPython -B (Join-Path $PSScriptRoot 'install_weapons.py')
    if ($LASTEXITCODE -ne 0) { throw "Inventory installation failed: $LASTEXITCODE" }
} finally {
    # Reuse the established script: loopback ports, hidden Python, original logs.
    & (Join-Path $weaponProject 'tools\START_ROLE_LAB.ps1')
}
