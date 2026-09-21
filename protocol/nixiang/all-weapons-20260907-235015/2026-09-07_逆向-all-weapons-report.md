# 本地角色全武器背包与穿戴

用户要求当前账号获得全部武器。核验现有项目源码完整；实际问题是只有7件初始装备、无持久化背包，游戏道具仓库为空。已从客户端3511条物品配置中确认274种type25武器，候选实现新增独立背包表，保留原角色836字节记录，补273件未持有武器，并恢复武器穿戴、卸装与重登下发。本报告当前记录候选实现；正式安装结果见随后生成的installed-manifest.json，真实显示需安装后验证。

## 范围与输入

见[scope.md](scope.md)，仅现有loopback v4、合成UID1001/角色t07、本地SQLite；原游戏安装只读，flavor=null。未恢复原厂源代码。输入身份、imports等价锚点和raw地址约定见[evidence/E-imports.md](evidence/E-imports.md)。当前工具见[tool-index.md](tool-index.md)。

## 行为与数据

- 客户端配置type25共274种，包含7个100xxx特殊ID，不能只按253xxx筛选；完整目录和GBK名称在[evidence/weapons.json](evidence/weapons.json)。原253002保留，新增273件。type26投射物/战斗道具不混入武器。
- lab_inventory独立保存280条68字节记录：6件服装和274件武器。实例ID唯一；授予幂等。原lab_roles各字段不修改，外观和既有房间训练保持原数据。
- 1010重登下发一帧1120/19040，包含完整物品数组，再发1130/360。1120会清空客户端旧集合，因此不能把列表拆成多帧1120。
- 武器穿戴2080/16：先2310/72卸旧武器，再2090/84装备新武器；2300/4显式卸装回2310/72。重复请求幂等。持久化slot0/8使重登保持选择。
- 不修改客户端性别/其他使用限制。目录中性别提示仅由配置掩码比较推断；全种类拥有不等于所有角色都可装备每件。

## Evidence → Finding → Path

| E-id | source_ref | 复核方式 | content_hash |
|---|---|---|---|
| E-01 | evidence/weapons.json、build_catalog.py | 原3511条E-011配置与类型ID逐一对应 | 原配置SHA256 10f3170fd3d80eebe9c6f49c9912902e77c91bcc6420b668ceaa797e0edb1ebc |
| E-02 | evidence/raw-0x812720.json、E-1120.md | IDA处理器清空后按68字节装载 | 见SHA256.json |
| E-03 | equip/report.md及JSON | 2080/2090/2300/2310请求和回调交叉核验 | 见equip/hashes.json |
| E-04 | candidate/test_inventory_store.py、test_inventory_protocol.py | 临时SQLite、匿名TCP分片、重连、穿戴 | 见validation.txt |
| E-05 | evidence/E-before-empty-warehouse.png | 当前真实t07道具仓库为空，初始火焰刀仍在装备页 | 见SHA256.json |

| F-id | severity | evidence_ids | location | confidence/status |
|---|---|---|---|---|
| F-01 当前代码没有完整背包 | n/a_re | E-01,E-05 | 旧RoleSession1010只发saved[360:] | high，已实现独立存储候选 |
| F-02 全量1120必须一次替换 | n/a_re | E-02,E-04 | raw812720、RoleSession1010 | high，静态和TCP通过 |
| F-03 穿戴需清除旧实例状态 | n/a_re | E-03,E-04 | raw819E20/819E70、RoleSession2080 | high静态/TCP，实机待验证 |

P-01（callflow）：已验证客户端type25目录→事务幂等授予→lab_inventory→1010→1120全量记录→1130→客户端道具仓库。

P-02（callflow）：客户端装备按钮2080(instance,slot8)→验证本UID拥有→旧slot0/新slot8同事务→2310旧记录→2090新记录→库存/模型刷新→重登1120保存选择。

## 验证与恢复

候选目录复用了既有53项协议、角色、P2P、房间与训练回归；新增存储测试覆盖原子授予、并发幂等、实例唯一、非法目录回滚、原角色不变、穿戴卸装和故障回滚。TCP测试发送分段登录请求，以97字节块读取19040字节1120，验证274武器、重复登录、断线重连、换武器后重登。

从原项目根运行正式安装测试：

```powershell
.\toolchain\python313\python.exe -B -m unittest discover -s .\research\2026-09-06\work\login-to-world -p 'test*protocol.py'
.\toolchain\python313\python.exe -B -m unittest discover -s .\research\2026-09-06\work\login-to-world -p 'test_inventory_store.py'
.\toolchain\python313\python.exe -B -m unittest discover -s .\research\2026-09-07\role-create -p 'test_role_protocol.py'
```

安装器先验证当前源码和角色库SHA256，用原停止标记优雅停止v4，SQLite backup保留原库，事务授予并核对原lab_roles全行不变，然后安装已测试文件，仍用tools/START_ROLE_LAB.ps1隐藏启动。installed-manifest.json记录实际路径、角色、数量和哈希；安装失败时恢复原角色库和旧源码。

回退时先通过lab-stop-v4停止服务并确认退出，将backup/role_protocol.py恢复到原lab目录，再用SQLite backup恢复backup/lab-roles.sqlite3；新附加模块可保留，不会被旧角色代码加载。用原启动脚本启动。不要替换正式客户端或无关账号库。

## 时间线与验证边界

- 23:31交接基线：本地单人自由训练已实现；本轮核验代码/角色库与原哈希一致。
- 本轮用户明确改为当前账号全武器需求；仓库界面实测为空，原初始武器已装备。
- 目录确认274，纠正只按253xxx筛选会漏7种。
- 复核raw812720整批语义及2080/2090/2300/2310；未向真实客户端注入Frida。
- 候选测试通过后才安装；正式安装、TCP与界面结果随后追加，不能把服务端发出成功包单独当作真实界面成功。
