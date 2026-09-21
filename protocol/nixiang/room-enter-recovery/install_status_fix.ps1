$ErrorActionPreference = 'Stop'
$project = 'C:\Users\24032\Desktop\code\kungfu-mock-server'
$lab = Join-Path $project 'research\2026-09-06\work\login-to-world'
$caseTarget = Join-Path $project 'research\2026-09-07\room-enter-recovery'
$candidate = Join-Path $PSScriptRoot 'candidate'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = Join-Path $caseTarget "before-status-fix-$stamp"
New-Item -ItemType Directory -Path $backup -Force | Out-Null
foreach ($name in @('room_protocol.py','test_room_protocol.py')) {
    Copy-Item -LiteralPath (Join-Path $lab $name) -Destination $backup
}
[IO.File]::WriteAllText((Join-Path $lab 'lab-stop-v4'), 'post-enter status compatibility fix')
$limit = (Get-Date).AddSeconds(20)
do {
    $portOpen = $false
    $probe = [Net.Sockets.TcpClient]::new()
    try { $probe.Connect('127.0.0.1',10035); $portOpen = $true }
    catch [Net.Sockets.SocketException] { }
    finally { $probe.Dispose() }
    if (-not $portOpen) { break }
    Start-Sleep -Milliseconds 250
} while ((Get-Date) -lt $limit)
if ($portOpen) { throw 'Server did not stop; files not replaced' }
Start-Sleep -Milliseconds 600
foreach ($name in @('room_protocol.py','test_room_protocol.py')) {
    Copy-Item -LiteralPath (Join-Path $candidate $name) -Destination (Join-Path $lab $name) -Force
    Copy-Item -LiteralPath (Join-Path $candidate $name) -Destination (Join-Path $caseTarget "candidate\$name") -Force
}
& (Join-Path $project 'tools\START_ROLE_LAB.ps1')
Write-Output "Post-enter status compatibility fix installed; backup=$backup"
