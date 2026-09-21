param([string]$Config = (Join-Path (Split-Path $PSScriptRoot -Parent) 'config/network.json'))
& "$PSScriptRoot/Sync-NetworkConfig.ps1" -Config $Config -Transport direct -Apply
