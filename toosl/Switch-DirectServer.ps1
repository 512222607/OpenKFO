$repoRoot = Split-Path -Parent $PSScriptRoot
$ErrorActionPreference = 'Stop'
Set-Location $repoRoot
$reportPath = Join-Path $repoRoot 'runtime-local/go-online/direct-server-check.json'
& 'runtime-local/go-online/latency-probe.exe' -endpoint 'tls://jrnygtxy.top:19091' -count 3 -cert 'runtime-local/go-online/origin.crt' -output $reportPath
if ($LASTEXITCODE -ne 0) { throw 'Direct TLS probe failed; launcher settings were not changed.' }
$report = Get-Content $reportPath -Raw | ConvertFrom-Json
$result = $report.summary.'tls://jrnygtxy.top:19091'
if (-not $result -or $result.successful -ne 3 -or $result.failures -ne 0) { throw 'TCP 19091 is not ready; launcher settings were not changed.' }
$workspace = Split-Path $repoRoot -Parent
$paths = @((Join-Path $workspace 'bridge.json'), (Join-Path $workspace '第二客户端/bridge.json'))
$stamp = Get-Date -Format yyyyMMdd-HHmmss
foreach ($path in $paths) {
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $settings = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    Copy-Item -LiteralPath $path -Destination "$path.before-direct-$stamp" -ErrorAction Stop
    $settings.url = 'tls://jrnygtxy.top:19091'
    $json = $settings | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($path, $json, [System.Text.UTF8Encoding]::new($false))
}
Write-Host "Direct game connection enabled. Median origin RTT: $($result.median_ms) ms. Reopen the launcher to use it."
