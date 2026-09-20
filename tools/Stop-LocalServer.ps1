$repoRoot = Split-Path -Parent $PSScriptRoot
$ErrorActionPreference = 'Stop'
$owners = @(Get-NetTCPConnection -State Listen -LocalPort 17999,18000,18001,18082 -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty OwningProcess -Unique)
if (-not $owners.Count) { Write-Host 'Local server is already stopped.'; exit 0 }
if ($owners.Count -ne 1) { throw 'Ports belong to different processes; refusing to stop them.' }
$service = Get-CimInstance Win32_Process -Filter "ProcessId=$($owners[0])"
$client = Join-Path $repoRoot 'runtime-local\client'
if (-not $service.CommandLine -or
    -not $service.CommandLine.Contains('-m server.kk_local.sdo_service') -or
    $service.CommandLine.IndexOf($client, [StringComparison]::OrdinalIgnoreCase) -lt 0) {
    throw 'Port owner is not this local server; refusing to stop it.'
}
Stop-Process -Id $service.ProcessId
Write-Host 'Local server stopped.'
