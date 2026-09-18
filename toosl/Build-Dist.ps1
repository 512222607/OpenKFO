[CmdletBinding()]
param(
    [string]$Go = 'go',
    [string]$Flutter = 'flutter'
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$dist = Join-Path $repoRoot 'dist'
$components = Join-Path $dist 'launcher-components'
$manager = Join-Path $dist 'item-manager'
New-Item -ItemType Directory -Force $components, $manager | Out-Null
Push-Location $repoRoot
try {
    Push-Location 'server/go-server'
    try {
        & $Go build -o "$components/OnlineBridge.exe" ./cmd/bridge
        if ($LASTEXITCODE) { throw 'Go bridge build failed' }
        & $Go build -o "$manager/kungfu-desktop-admin.exe" ./cmd/desktop-admin
        if ($LASTEXITCODE) { throw 'Go administration build failed' }
    } finally { Pop-Location }
    & '.\client\client-adapter\build-login-skin.cmd'
    if ($LASTEXITCODE) { throw 'Login component build failed' }
    & dotnet publish client/launcher-online/OnlineLauncher.csproj -c Release -o "$dist/launcher"
    if ($LASTEXITCODE) { throw 'Launcher build failed' }

    # Flutter/MSBuild cannot reliably read this project's Chinese workspace path.
    $stage = Join-Path ([System.IO.Path]::GetTempPath()) ('openkfo-build-' + [guid]::NewGuid().ToString('N'))
    if ($stage -match '[^\x00-\x7F]') { throw 'Set TEMP to an ASCII-only build directory before building Flutter.' }
    & robocopy 'toosl/item-manager' $stage /E /XD build .dart_tool .idea ephemeral /XF '*.iml' /NFL /NDL /NJH /NJS > $null
    if ($LASTEXITCODE -ge 8) { throw 'Flutter source staging failed' }
    Push-Location $stage
    try {
        & $Flutter pub get
        if ($LASTEXITCODE) { throw 'Flutter dependency resolution failed' }
        & $Flutter build windows --release
        if ($LASTEXITCODE) { throw 'Flutter build failed' }
    } finally { Pop-Location }
    Copy-Item -Path "$stage/build/windows/x64/runner/Release/*" -Destination $manager -Recurse -Force
    Set-Content -LiteralPath "$dist/flutter-build-path.txt" -Value $stage -Encoding utf8
    Write-Host "Built: $dist"
} finally { Pop-Location }
