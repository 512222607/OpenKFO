$ErrorActionPreference = 'Stop'
$caseSource = $PSScriptRoot
$project = 'C:\Users\24032\Desktop\code\kungfu-mock-server'
$lab = Join-Path $project 'research\2026-09-06\work\login-to-world'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$caseTarget = Join-Path $project "research\2026-09-07\training-room-actions-$stamp"
$baseline = Get-Content -LiteralPath (Join-Path $caseSource 'baseline-manifest.json') -Raw | ConvertFrom-Json
$names = Get-Content -LiteralPath (Join-Path $caseSource 'install-files.json') -Raw | ConvertFrom-Json
foreach ($prop in $baseline.PSObject.Properties) {
    $actual = (Get-FileHash -LiteralPath (Join-Path $lab $prop.Name) -Algorithm SHA256).Hash
    if ($actual -ne $prop.Value.sha256) { throw "Source changed after baseline: $($prop.Name)" }
}
foreach ($name in $names) {
    if ([IO.Path]::GetFileName($name) -ne $name) { throw "Expected a filename: $name" }
    if (-not (Test-Path -LiteralPath (Join-Path $caseSource "candidate\$name") -PathType Leaf)) { throw "Missing candidate: $name" }
}
New-Item -ItemType Directory -Path $caseTarget | Out-Null
$backup = Join-Path $caseTarget 'backup'
New-Item -ItemType Directory -Path $backup | Out-Null
foreach ($name in $names) {
    $old = Join-Path $lab $name
    if (Test-Path -LiteralPath $old) { Copy-Item -LiteralPath $old -Destination (Join-Path $backup $name) }
}
Copy-Item -LiteralPath (Join-Path $project 'CURRENT_STATUS.md') -Destination (Join-Path $backup 'CURRENT_STATUS.md')
$database = Join-Path $lab 'data\lab-roles.sqlite3'
$databaseBefore = (Get-FileHash -LiteralPath $database -Algorithm SHA256).Hash
Get-ChildItem -LiteralPath $caseSource -Force | Copy-Item -Destination $caseTarget -Recurse
# Only the existing project's documented graceful-stop mechanism is used.
$stopPath = Join-Path $lab 'lab-stop-v4'
[IO.File]::WriteAllText($stopPath, "training room protocol update $stamp")
$limit = (Get-Date).AddSeconds(25)
do {
    $openPorts = @()
    foreach ($port in @(8094,8000,10035,5136)) {
        $probe = [Net.Sockets.TcpClient]::new()
        try { $probe.Connect('127.0.0.1', $port); $openPorts += $port }
        catch [Net.Sockets.SocketException] { }
        finally { $probe.Dispose() }
    }
    if ($openPorts.Count -eq 0) { break }
    Start-Sleep -Milliseconds 250
} while ((Get-Date) -lt $limit)
if ($openPorts.Count -ne 0) { throw "Graceful stop incomplete; source not replaced; ports=$openPorts" }
foreach ($name in $names) {
    Copy-Item -LiteralPath (Join-Path $caseSource "candidate\$name") -Destination (Join-Path $lab $name)
}
& (Join-Path $project 'tools\START_ROLE_LAB.ps1')
$databaseAfter = (Get-FileHash -LiteralPath $database -Algorithm SHA256).Hash
if ($databaseBefore -ne $databaseAfter) { throw 'Unexpected persisted role database change' }
$installed = foreach ($name in $names) {
    $path = Join-Path $lab $name
    [pscustomobject]@{name=$name; sha256=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash}
}
$result = [pscustomobject]@{case_directory=$caseTarget; backup=$backup; installed=$installed; database_sha256=$databaseAfter}
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $caseTarget 'installed-manifest.json') -Encoding utf8
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $caseSource 'installed-manifest.json') -Encoding utf8
$result | ConvertTo-Json -Depth 5
