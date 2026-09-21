$ErrorActionPreference = 'Stop'
$weaponProject = 'C:\Users\24032\Desktop\code\kungfu-mock-server'
$weaponLab = Join-Path $weaponProject 'research\2026-09-06\work\login-to-world'
$weaponPython = Join-Path $weaponProject 'toolchain\python313\python.exe'
$weaponServer = Get-CimInstance Win32_Process -Filter "ProcessId=21116"
if (!$weaponServer -or $weaponServer.ExecutablePath -ne $weaponPython -or $weaponServer.CommandLine -notlike '*lab_server_v4.py*') {
    throw 'Observed v4 process does not match; refusing to stop another process.'
}
if ((Get-FileHash -LiteralPath (Join-Path $weaponLab 'role_protocol.py')).Hash -ne '88B5508C18E9C9A6D9D1229F1B0164E4A2CBEEEB1006C71B6404C1D9F99F800A') {
    throw 'Role source changed; refusing stale installation.'
}
[IO.File]::WriteAllText((Join-Path $weaponLab 'lab-stop-v4'), 'Install permanent weapon ownership and slot-zero compatibility')
$weaponDeadline = [DateTime]::UtcNow.AddSeconds(20)
while ((Get-Process -Id 21116 -ErrorAction SilentlyContinue) -and [DateTime]::UtcNow -lt $weaponDeadline) {
    Start-Sleep -Milliseconds 250
}
if (Get-Process -Id 21116 -ErrorAction SilentlyContinue) { throw 'v4 did not stop gracefully; no files replaced.' }
try {
    & $weaponPython -B (Join-Path $PSScriptRoot 'install_permanent.py')
    if ($LASTEXITCODE -ne 0) { throw "Permanent installation failed: $LASTEXITCODE" }
} finally {
    & (Join-Path $weaponProject 'tools\START_ROLE_LAB.ps1')
}
