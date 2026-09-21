$ErrorActionPreference = 'Stop'
$caseSource = $PSScriptRoot
$project = 'C:\Users\24032\Desktop\code\kungfu-mock-server'
$lab = Join-Path $project 'research\2026-09-06\work\login-to-world'
$caseTarget = Join-Path $project 'research\2026-09-07\room-enter-recovery'
$candidate = Join-Path $caseSource 'candidate'
$names = @('role_protocol.py','room_protocol.py','test_game_protocol.py','test_room_protocol.py','room-create-captured.json','lab-control.json')
foreach ($name in @('role_protocol.py','test_game_protocol.py','lab-control.json')) {
    $expected = (Get-FileHash -LiteralPath (Join-Path $caseSource "baseline\login-to-world\$name") -Algorithm SHA256).Hash
    $current = (Get-FileHash -LiteralPath (Join-Path $lab $name) -Algorithm SHA256).Hash
    if ($expected -ne $current) { throw "Source changed since baseline: $name" }
}
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = Join-Path $caseTarget "backup-$stamp"
New-Item -ItemType Directory -Path $backup -Force | Out-Null
foreach ($name in $names) {
    $current = Join-Path $lab $name
    if (Test-Path -LiteralPath $current) { Copy-Item -LiteralPath $current -Destination (Join-Path $backup $name) }
}
Copy-Item -LiteralPath (Join-Path $project 'CURRENT_STATUS.md') -Destination (Join-Path $backup 'CURRENT_STATUS.md')
foreach ($folder in @('room-handlers','avatar','21410','candidate')) {
    Copy-Item -LiteralPath (Join-Path $caseSource $folder) -Destination $caseTarget -Recurse -Force
}
foreach ($file in @('scope.md','root-decompilation.json','2026-09-07_逆向-room-enter-report.md','install_candidate.ps1')) {
    Copy-Item -LiteralPath (Join-Path $caseSource $file) -Destination $caseTarget -Force
}
# The v4 main loop watches only this project-local stop marker. No force kill.
$stopPath = Join-Path $lab 'lab-stop-v4'
[IO.File]::WriteAllText($stopPath, "room protocol recovery $stamp")
$limit = (Get-Date).AddSeconds(20)
do {
    $openPorts = @()
    foreach ($port in @(8094,8000,10035,5136)) {
        $probe = [Net.Sockets.TcpClient]::new()
        try { $probe.Connect('127.0.0.1',$port); $openPorts += $port }
        catch [Net.Sockets.SocketException] { }
        finally { $probe.Dispose() }
    }
    if ($openPorts.Count -eq 0) { break }
    Start-Sleep -Milliseconds 250
} while ((Get-Date) -lt $limit)
if ($openPorts.Count -ne 0) { throw "Server did not stop gracefully; ports $openPorts still open; code was not replaced" }
foreach ($name in $names) { Copy-Item -LiteralPath (Join-Path $candidate $name) -Destination (Join-Path $lab $name) -Force }
$status = Join-Path $project 'CURRENT_STATUS.md'
$prior = [IO.File]::ReadAllText($status)
$heading = '# 功夫小子 mock server 交接状态'
$note = "> 最新状态（$(Get-Date -Format 'yyyy-MM-dd HH:mm')，Asia/Shanghai）：本轮发现根本地址映射错误：game-runtime.bin.i64 中表指针须减0x10000，且消息表项为opcode/kind/handler。真正3020要求83字节（WORD房间handle+原3010/81回显），会推进3550/12与3070/14；3070成功回复为3100/245。已新增room_protocol.py，删除旧3020/4和3030/196/20564/40/20560/1误推送，纠正2250->2270/8、2260->2280/8；旧顶部25xx推进判断不再成立。地图0已从真实客户端配置树确认是随机地图。源码/TCP19项测试通过，服务已准备切换。真实进房UI尚待重登复测；重点看3070、3100后是否发21428/0。详细证据见research/2026-09-07/room-enter-recovery/2026-09-07_逆向-room-enter-report.md；本轮前源码和文档已备份于同目录backup-$stamp。`r`n`r`n"
if ($prior.StartsWith($heading)) { $prior = $heading + "`r`n`r`n" + $note + $prior.Substring($heading.Length).TrimStart([char[]]"`r`n") }
else { $prior = $note + $prior }
[IO.File]::WriteAllText($status,$prior,[Text.UTF8Encoding]::new($false))
& (Join-Path $project 'tools\START_ROLE_LAB.ps1')
$manifest = @()
foreach ($name in $names) {
    $f = Get-Item -LiteralPath (Join-Path $lab $name)
    $manifest += [pscustomobject]@{ path=$name; size=$f.Length; sha256=(Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash }
}
$manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $caseTarget 'installed-manifest.json') -Encoding utf8
Write-Output "Installed corrected room handlers; backup=$backup"
