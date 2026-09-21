# Triage 与导入等价锚点

当前 IDA survey 确认 game-runtime.bin.i64，x86 32 位平坦运行时镜像，base=0，0..0x1e19000，31308函数，SHA256 707450b209937b2d3e94a68ffe8f9841821ff048fd1cc0d8017d1fdddf493c3b。无呈现原生 imports 目录。复用已读项目 training-room-actions-20260907-232711/evidence/E-imports.md：原 Client.exe 61项导入，含 Client_CT!MainFunction 和 KERNEL32!GetProcAddress/LoadLibraryExW/CreateFileW/WriteFile。静态 network/crypto 缺失不能否定动态加载的网络能力；不做 IAT 修复，只追已提取的物品处理器。

地址：表项中的绝对 VA 减0x10000才是当前IDB地址；已解析的相对CALL不得再减。旧报告地址须结合实际函数复核。
