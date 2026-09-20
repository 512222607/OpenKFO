# 模式10事件组完成条件

来源为当前客户端实际加载的 `script/pve/include`，SHA256：
`0a083607cab1456c0976038f1e78658a208607355c015060a4492259cde5280f`。
Lua 5.1 子原型 `libs/event.lua` 267–411，397条指令；不是只依据同目录松散源码。

关键指令（PC从0计，括号内为原始32位指令）：

| PC | 核对结果 |
| --- | --- |
| 75（00800042） | `create_end`初始为true |
| 80–90 | 对每个子组比较`cur_index`与`table.maxn(group.subs[i].monsters)`；未生成完则置false |
| 94–101 | 检查`create_end`且`table.maxn(self.monsters)==0`；常量17为0 |
| 102–109 | 若组绑定阻挡，调用`destroy_block(group.block)` |
| 110（00000082）、111（0100009e） | 返回false，结束事件组 |

同一编译include的`libs/pve.lua`37–55原型先从活怪列表移除`is_dead()`的怪物；62–72原型登记5秒销毁计时器，66–70的回调才调用`destroy_monster`。因此事件组可以在最后尸体尚未销毁时结束。怪物`is_dead()`的HP条件及原生属性证据分别见 `foster-health.asm`、`foster-initial-health.asm`。

服务器的`fosterReceiptsComplete`只核对结束标记、逐组生成数与接收的血量/移除记录。活着移除的实体不补记为死亡；零血量但仍活动的尸体可参与核对；编号复用前的已移除记录按组保留。它不是客户端脚本执行器，也不能单独证明掉落或通关资格，完整模式10结算尚未开放。
