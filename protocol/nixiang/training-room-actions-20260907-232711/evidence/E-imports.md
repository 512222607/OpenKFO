# 输入与导入证据

2026-09-07 当前 IDA server_health 确认目标为项目内 game-runtime.bin.i64，base=0，Hex-Rays 已就绪。survey_binary(minimal) 返回32位平坦运行时镜像，单段0..0x1e19000，31308函数；没有呈现静态导入表。原始镜像 SHA256=707450b209937b2d3e94a68ffe8f9841821ff048fd1cc0d8017d1fdddf493c3b。

复用已读前轮 room-enter-recovery/room-handlers/E-imports.md：原 Client.exe 导入共61项，含Client_CT!MainFunction、KERNEL32!GetProcAddress/LoadLibraryExW/CreateFileW/WriteFile；无静态network/crypto API。本轮只研究已提取消息处理代码，不进行IAT修复。

地址约定：静态表中绝对指针减0x10000得到当前IDB地址；IDA已解析的相对CALL目的地址不得再次减去。
