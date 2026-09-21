param(
    [Parameter(Mandatory = $true)][string[]]$ConfigPaths,
    [Parameter(Mandatory = $true)][string]$CertificatePath,
    [string]$Probe = (Join-Path (Split-Path $PSScriptRoot -Parent) 'dist/server/latency-probe.exe'),
    [string]$Config = (Join-Path (Split-Path $PSScriptRoot -Parent) 'config/network.json')
)
& "$PSScriptRoot/Sync-NetworkConfig.ps1" -Config $Config -Transport wss -ConfigPaths $ConfigPaths -CertificatePath $CertificatePath -Probe $Probe -Apply
