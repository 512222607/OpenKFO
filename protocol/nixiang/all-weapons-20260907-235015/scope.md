# 本地账号全部武器

用户明确要求“现在的账号里面没有武器……获得所有武器”。范围是已有本地 loopback mock server 合成 UID 1001 当前角色；可修改其物品持久化与必要服务端协议并重启本地服务使之生效。原始角色数据先用 SQLite backup 保存，已有外观/训练功能保留。

目标项目 C:/Users/24032/Desktop/code/kungfu-mock-server。正式安装 C:/Program Files (x86)/kk 只读。不联系原游戏远程服务。此处 work 为候选工作区，完成后重要源码、证据、备份和报告归档到原项目 research，CURRENT_STATUS 更新。

验证：客户端配置筛选、IDA 原始处理器、临时 SQLite 幂等赋予及重连、TCP 分片物品下发、现有53项回归；真实客户端显示需单独证据。
