$ErrorActionPreference = 'Stop'
$temp = Join-Path ([IO.Path]::GetTempPath()) ('openkfo-network-test-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temp | Out-Null
try {
    $bridge = Join-Path $temp 'bridge.json'
    '{"url":"tls://old.example:19091","config_hash":"keep","custom":42}' | Set-Content $bridge
    '{"host":"old.example","port":22,"key":"keep.pem"}' | Set-Content (Join-Path $temp 'admin.json')
    '{"manifest":"https://old.example/updates/gm.json"}' | Set-Content (Join-Path $temp 'gm.json')
    $config = Join-Path $temp 'network.json'
    $network = @{
        game_endpoint='tls://new.example:19091'; update_base_url='https://new.example/updates/'
        ssh_host='new.example'; ssh_port=2222
        bridge_paths=@('bridge.json'); admin_paths=@('admin.json'); gm_updater_paths=@('gm.json')
        launcher_manifest_paths=@()
    }
    $network | ConvertTo-Json | Set-Content $config
    $probe = Join-Path $temp 'probe.ps1'
    @'
param($endpoint, $count, $cert, $output)
@{summary=@{$endpoint=@{successful=3;failures=0;median_ms=1}}} | ConvertTo-Json -Depth 5 | Set-Content $output
$global:LASTEXITCODE=0
'@ | Set-Content $probe
    $argsForSync = @{Config=$config; Root=$temp; Probe=$probe; CertificatePath='unused'}
    $before = Get-Content $bridge -Raw
    & "$PSScriptRoot/Sync-NetworkConfig.ps1" @argsForSync | Out-Null
    if ((Get-Content $bridge -Raw) -ne $before) { throw 'Preview changed a file' }
    $network.bridge_paths += 'missing.json'
    $network | ConvertTo-Json | Set-Content $config
    $rejected = $false
    try { & "$PSScriptRoot/Sync-NetworkConfig.ps1" @argsForSync -Apply | Out-Null } catch { $rejected=$true }
    if (-not $rejected -or (Get-Content $bridge -Raw) -ne $before) { throw 'Preflight failed' }
    $network.bridge_paths = @('bridge.json')
    $network | ConvertTo-Json | Set-Content $config
    & "$PSScriptRoot/Sync-NetworkConfig.ps1" @argsForSync -Apply | Out-Null
    $saved = Get-Content $bridge -Raw | ConvertFrom-Json
    if ($saved.url -ne $network.game_endpoint -or $saved.credentials_scope -ne 'tls://old.example:19091/' -or $saved.config_hash -ne 'keep' -or $saved.custom -ne 42 -or $saved.PSObject.Properties['update_base_url']) { throw 'Bridge preservation failed' }
    $admin = Get-Content (Join-Path $temp 'admin.json') -Raw | ConvertFrom-Json
    if ($admin.host -ne 'new.example' -or $admin.port -ne 2222 -or $admin.key -ne 'keep.pem') { throw 'Admin preservation failed' }
    $preview = & "$PSScriptRoot/Sync-NetworkConfig.ps1" @argsForSync
    if ($preview -like 'Change:*') { throw 'Sync is not idempotent' }
    $preview = & "$PSScriptRoot/Sync-NetworkConfig.ps1" @argsForSync -ConfigPaths @($bridge)
    if ($preview -like 'Change:*') { throw 'Absolute bridge path failed' }
    $stable = Get-Content $bridge -Raw
    $network.game_endpoint='tls://another.example:19091'
    $network | ConvertTo-Json | Set-Content $config
    'param($endpoint, $count, $cert, $output); $global:LASTEXITCODE=1' | Set-Content $probe
    $rejected=$false
    try { & "$PSScriptRoot/Sync-NetworkConfig.ps1" @argsForSync -Apply | Out-Null } catch { $rejected=$true }
    if (-not $rejected -or (Get-Content $bridge -Raw) -ne $stable) { throw 'Failed probe changed a file' }
    $saved.url='tls://127.0.0.1:19091'
    $saved | ConvertTo-Json | Set-Content $bridge
    $rejected=$false
    try { & "$PSScriptRoot/Sync-NetworkConfig.ps1" @argsForSync -Apply | Out-Null } catch { $rejected=$true }
    if (-not $rejected) { throw 'Local bridge was accepted' }
    Write-Output 'PASS: preview, complete preflight, field preservation, credential scope, update policy, idempotence, local protection.'
} finally {
    # This unique directory is created above directly under the system temp directory.
    $resolved = [IO.Path]::GetFullPath($temp)
    if (-not $resolved.StartsWith([IO.Path]::GetFullPath([IO.Path]::GetTempPath())) -or (Split-Path $resolved -Leaf) -notlike 'openkfo-network-test-*') { throw 'Unsafe cleanup path' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
