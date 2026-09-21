[CmdletBinding()]
param(
    [string]$Config = (Join-Path (Split-Path $PSScriptRoot -Parent) 'config/network.json'),
    [string]$Root = (Split-Path $PSScriptRoot -Parent),
    [ValidateSet('game', 'direct', 'wss')][string]$Transport = 'game',
    [string[]]$ConfigPaths,
    [string]$CertificatePath,
    [string]$Probe,
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'
$network = Get-Content -LiteralPath $Config -Raw | ConvertFrom-Json
$endpoint = $network."${Transport}_endpoint"
$uri = [uri]$endpoint
$updates = [uri]$network.update_base_url
if (-not $uri.IsAbsoluteUri -or $uri.Scheme -notin @('tls','wss') -or $uri.IsLoopback -or $uri.UserInfo -or $uri.Query -or $uri.Fragment -or ($uri.Scheme -eq 'tls' -and ($uri.Port -lt 1 -or $uri.AbsolutePath -ne '/'))) { throw 'Invalid game endpoint.' }
if (-not $updates.IsAbsoluteUri -or $updates.Scheme -ne 'https' -or $updates.UserInfo -or $updates.Query -or $updates.Fragment -or -not $updates.AbsolutePath.EndsWith('/')) { throw 'Update base must be an HTTPS directory URL.' }
if (-not $network.ssh_host -or $network.ssh_port -lt 1 -or $network.ssh_port -gt 65535) { throw 'Invalid SSH endpoint.' }
function Set-Field($object, $name, $value) { $object | Add-Member -NotePropertyName $name -NotePropertyValue $value -Force }
$changes = @()
$bridges = if ($ConfigPaths) { $ConfigPaths } else { $network.bridge_paths }
$groups = @{ bridge = $bridges }
if (-not $ConfigPaths) {
    $groups.gm = $network.gm_updater_paths
    $groups.admin = $network.admin_paths
    $groups.manifest = $network.launcher_manifest_paths
}
foreach ($kind in $groups.Keys) {
    foreach ($relative in $groups[$kind]) {
        $path = if ([IO.Path]::IsPathRooted($relative)) { [IO.Path]::GetFullPath($relative) } else { [IO.Path]::GetFullPath((Join-Path $Root $relative)) }
        if (-not (Test-Path -LiteralPath $path)) { throw "Configured target missing: $path" }
        $settings = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
        $before = $settings | ConvertTo-Json -Depth 50
        switch ($kind) {
            bridge {
                $old = [uri]$settings.url
                if (-not $old.IsAbsoluteUri -or $old.IsLoopback) { throw "Refusing to change local/invalid bridge: $path" }
                if (-not $settings.credentials_scope) { Set-Field $settings credentials_scope $old.AbsoluteUri }
                Set-Field $settings url $endpoint
                # Preserve update enablement: an absent field disables updates for direct TLS.
                if ($settings.update_base_url) { Set-Field $settings update_base_url $updates.AbsoluteUri }
            }
            gm { Set-Field $settings manifest ([uri]::new($updates, 'gm.json').AbsoluteUri) }
            admin { Set-Field $settings host $network.ssh_host; Set-Field $settings port $network.ssh_port }
            manifest {
                if ($settings.kind -ne 'launcher' -or $uri.Scheme -ne 'tls') { throw 'Launcher route manifests require direct TLS.' }
                Set-Field $settings game_endpoint $endpoint
                Set-Field $settings update_base_url $updates.AbsoluteUri
            }
        }
        $json = $settings | ConvertTo-Json -Depth 50
        if ($json -ne $before) { $changes += @{ Path = $path; Json = $json } }
    }
}
Write-Output "Game: $endpoint; updates: $($updates.AbsoluteUri); SSH: $($network.ssh_host):$($network.ssh_port)"
$changes | ForEach-Object { Write-Output "Change: $($_.Path)" }
if (-not $Apply) { Write-Output 'Preview only. Use -Apply to verify the game connection and write changes.'; return }
if (-not $Probe) { $Probe = Join-Path $Root 'runtime-local/go-online/latency-probe.exe' }
if (-not $CertificatePath) { $CertificatePath = Join-Path $Root 'runtime-local/go-online/origin.crt' }
$reportPath = Join-Path ([IO.Path]::GetTempPath()) ("openkfo-network-$([guid]::NewGuid().ToString('N')).json")
try {
    & $Probe -endpoint $endpoint -count 3 -cert $CertificatePath -output $reportPath
    if ($LASTEXITCODE -ne 0) { throw 'Connection probe failed; settings were not changed.' }
    $report = Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json
    $result = $report.summary.$endpoint
    if (-not $result -or $result.successful -ne 3 -or $result.failures -ne 0) { throw 'Pinned TLS verification failed; settings were not changed.' }
    $suffix = '.before-network-' + [guid]::NewGuid().ToString('N')
    foreach ($change in $changes) { Copy-Item -LiteralPath $change.Path -Destination ($change.Path + $suffix) }
    try {
        foreach ($change in $changes) { [IO.File]::WriteAllText($change.Path, $change.Json, [Text.UTF8Encoding]::new($false)) }
    } catch {
        foreach ($change in $changes) { Copy-Item -LiteralPath ($change.Path + $suffix) -Destination $change.Path -Force }
        throw
    }
    Write-Output "Applied $($changes.Count) files; origin RTT median $($result.median_ms) ms. Restart launchers to load the configuration."
} finally {
    if (Test-Path -LiteralPath $reportPath) { Remove-Item -LiteralPath $reportPath }
}
