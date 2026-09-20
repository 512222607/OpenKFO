[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string[]]$ConfigPaths,
    [Parameter(Mandatory = $true)][string]$CertificatePath,
    [string]$Probe = (Join-Path (Split-Path -Parent $PSScriptRoot) 'dist/server/latency-probe.exe')
)
$ErrorActionPreference = 'Stop'
$endpoint = 'wss://game.example.com/kk/tunnel'
# Resolve every input before checking or changing any launcher.
$paths = @($ConfigPaths | ForEach-Object { (Resolve-Path -LiteralPath $_).Path })
$certificate = (Resolve-Path -LiteralPath $CertificatePath).Path
$probePath = (Resolve-Path -LiteralPath $Probe).Path
$health = Invoke-RestMethod -Uri 'https://game.example.com/health' -TimeoutSec 15
if ($health.status -ne 'ok') { throw 'WSS health check failed; settings were not changed.' }
$reportPath = Join-Path ([System.IO.Path]::GetTempPath()) ('openkfo-wss-' + [guid]::NewGuid().ToString('N') + '.json')
try {
    & $probePath -endpoint $endpoint -count 3 -cert $certificate -output $reportPath
    if ($LASTEXITCODE -ne 0) { throw 'WSS probe failed; settings were not changed.' }
    $report = Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json
    $result = $report.summary.$endpoint
    if (-not $result -or $result.successful -ne 3 -or $result.failures -ne 0) { throw 'Pinned TLS origin verification failed; settings were not changed.' }
    $updates = @($paths | ForEach-Object {
        $settings = Get-Content -LiteralPath $_ -Raw | ConvertFrom-Json
        if (-not $settings.url) { throw "Missing URL in $_" }
        $settings.url = $endpoint
        @{ Path = $_; Json = ($settings | ConvertTo-Json -Depth 20) }
    })
    $stamp = Get-Date -Format yyyyMMdd-HHmmss-fff
    foreach ($update in $updates) { Copy-Item -LiteralPath $update.Path -Destination ($update.Path + '.before-wss-' + $stamp) }
    foreach ($update in $updates) { [System.IO.File]::WriteAllText($update.Path, $update.Json, [System.Text.UTF8Encoding]::new($false)) }
    Write-Output 'WSS verified and enabled. Restart the launcher to use the new connection.'
} finally {
    if (Test-Path -LiteralPath $reportPath) { Remove-Item -LiteralPath $reportPath }
}
