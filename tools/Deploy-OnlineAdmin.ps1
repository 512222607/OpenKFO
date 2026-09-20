$repoRoot = Split-Path -Parent $PSScriptRoot
$ErrorActionPreference = 'Stop'
Set-Location $repoRoot
$config = Get-Content 'runtime-local/online-admin.json' -Raw | ConvertFrom-Json
$destination = "$($config.user)@$($config.host)"
$sshOptions = @('-i', $config.key, '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=10')
& ssh @sshOptions -p $config.port $destination 'true'
if ($LASTEXITCODE -ne 0) { throw 'SSH unavailable; nothing deployed.' }
$remoteStage = '/tmp/kungfu-admin-' + [guid]::NewGuid().ToString('N')
& ssh @sshOptions -p $config.port $destination "mkdir -m 700 $remoteStage"
if ($LASTEXITCODE -ne 0) { throw 'Cannot create deployment directory.' }
& scp @sshOptions -P $config.port 'runtime-local/go-online/kungfu-admin' 'runtime-local/go-online/admin-integration.test' "${destination}:$remoteStage/"
if ($LASTEXITCODE -ne 0) { throw 'Upload failed; nothing installed.' }
$script = @'
set -eu
stage="__STAGE__"
chmod 700 "$stage/admin-integration.test"
sudo -n bash -c 'set -eu; export "$(cat /etc/kungfu-go/test.env)"; export KK_TEST_MYSQL_DSN="${KK_TEST_MYSQL_DSN:-${KK_MYSQL_DSN:-}}"; test -n "$KK_TEST_MYSQL_DSN"; exec "$1" -test.v -test.run "^TestDesktopAdminTransactions$"' bash "$stage/admin-integration.test"
if sudo -n test -f /opt/kungfu-go/kungfu-admin; then
  sudo -n cp -p /opt/kungfu-go/kungfu-admin "/opt/kungfu-go/kungfu-admin.before-$(date +%Y%m%d%H%M%S)"
fi
sudo -n install -o root -g root -m 700 "$stage/kungfu-admin" /opt/kungfu-go/kungfu-admin
sudo -n sha256sum /opt/kungfu-go/kungfu-admin
'@
$script.Replace('__STAGE__', $remoteStage) | & ssh @sshOptions -p $config.port $destination "tr -d '\r' | bash -s"
if ($LASTEXITCODE -ne 0) { throw 'Deployment or isolated database checks failed.' }
$request = '{"operation":"accounts"}'
$result = $request | & 'runtime-local/item-manager-online/kungfu-desktop-admin.exe' -root $repoRoot
if ($LASTEXITCODE -ne 0) { throw 'Online verification process failed.' }
$response = $result | ConvertFrom-Json
if (-not $response.ok) { throw $response.error }
Write-Host "Online administration verified. Accounts: $(@($response.result).Count). Game service was not restarted."
