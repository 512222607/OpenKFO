# 大厅菜单与角色资料协议（LobbyProtocol）

> 实现基线：`b74129b`，整理日期：2026-09-18。以当前 Go 实现为准，客户端笔记用于交叉参考；本轮未重新反编译或进行实机验证。偏移默认十进制，详见[总索引与约定](protocol.md)。

## 1. 当前收发索引

| 功能/触发 | C上行参数 | S处理/下行 |
| --- | --- | --- |
| 排行列表2540 | 1B类型 | Store.Rankings；2550数据 |
| 个人排行2560 | 9B；当前按+0类型和认证UID查询 | 2570个人数据；剩余8B不用于选择他人 |
| 改名9006 | 29B：+0 UID、+8 21B GBK新名 | 仅lobby；成功9007 54B（旧名+4、新UID+25、新名+33），拒绝9008 54B且+0=130 |
| 余额1232 | 0B | 1230(u32 Tickets) |
| 资料字段20546 | 0B | 20547，Profile[352:356) |
| 1300 / 1400 | 0B | 1310 / 1410，0B；仅当前空应答 |
| 战报/排行20360 | 12B，+0必须本人UID | 20370，36B零头+未配置赛季提示；不是完整排名结算 |
| 训练21000 / 21002 | 8B本人UID / 0B | 21001 / 21005，各56B；+0 UID、+20 minutes、+28 active |
| 未配置活动20561 | 4B，u32≤10 | 20562 878B，回显4B及未配置提示 |
| 活动20563 / 20565 | 0B | 20564 68B首u32=0xffffffff / 20566 48B零 |

这些菜单分支通常只在 lobby/room 阶段处理；未配置活动的占位应答不代表完整活动已实现。处理入口见 [session.go](../server/go-server/internal/game/session.go) 与 [menus.go](../server/go-server/internal/persistence/menus.go)。

登录和选角见 [LoginProtocol.md](LoginProtocol.md)，房间目录查询2260见 [RoomProtocol.md](RoomProtocol.md)。
