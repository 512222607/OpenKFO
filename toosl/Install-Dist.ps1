[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$GameDirectory,
    [Parameter(Mandatory = $true)][string]$RuntimeRoot
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$dist = Join-Path $repoRoot 'dist'
$gameRoot = (Resolve-Path -LiteralPath $GameDirectory).Path
$adminRoot = (Resolve-Path -LiteralPath $RuntimeRoot).Path
if (-not (Test-Path -LiteralPath "$gameRoot/bridge.json")) { throw 'Game directory must contain bridge.json.' }
if (-not (Test-Path -LiteralPath "$adminRoot/runtime-local/online-admin.json")) { throw 'Runtime root must contain runtime-local/online-admin.json.' }
foreach ($file in @('launcher/功夫小子登录器.exe','item-manager/kungfu_item_manager.exe','item-manager/kungfu-desktop-admin.exe','item-manager/flutter_windows.dll','launcher-components/OnlineBridge.exe','launcher-components/LoginSkin.dll','launcher-components/LoginSkinHost.exe')) {
    if (-not (Test-Path -LiteralPath (Join-Path $dist $file))) { throw "Build output missing: $file" }
}
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$backup = Join-Path $gameRoot "package-backups/$stamp"
New-Item -ItemType Directory -Force $backup | Out-Null
# Preserve old packages, including loaded executables, without stopping games.
foreach ($name in @('功夫小子登录器.exe','item-manager','launcher-components','登录器组件','打开道具管理器.cmd')) {
    $source = [System.IO.Path]::GetFullPath((Join-Path $gameRoot $name))
    $backupName = if ($name -eq '登录器组件') { 'legacy-launcher-components' } else { $name }
    $target = [System.IO.Path]::GetFullPath((Join-Path $backup $backupName))
    if (-not $source.StartsWith($gameRoot.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase) -or
        -not $target.StartsWith($gameRoot.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Backup path is outside game directory.' }
    if (Test-Path -LiteralPath $source) { Move-Item -LiteralPath $source -Destination $target }
}
Copy-Item -LiteralPath "$dist/launcher/功夫小子登录器.exe" -Destination $gameRoot
Copy-Item -LiteralPath "$dist/item-manager" -Destination $gameRoot -Recurse
$components = Join-Path $gameRoot 'launcher-components'
New-Item -ItemType Directory -Force $components | Out-Null
foreach ($name in @('OnlineBridge.exe','LoginSkin.dll','LoginSkinHost.exe')) {
    Copy-Item -LiteralPath "$dist/launcher-components/$name" -Destination $components
}
$entry = "@echo off`r`nstart `"`" `"%~dp0item-manager\kungfu_item_manager.exe`" --root `"$adminRoot`"`r`n"
[System.IO.File]::WriteAllText((Join-Path $gameRoot '打开道具管理器.cmd'), $entry, [System.Text.Encoding]::GetEncoding(936))
Write-Host "Installed: $gameRoot"
Write-Host "Backup: $backup"
