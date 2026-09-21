"""Archive verified permanent weapons and update the project handoff, without reinstalling."""
from contextlib import closing
from datetime import datetime
import hashlib
import json
from pathlib import Path
import shutil
import sqlite3
import struct

ROOT=Path(__file__).resolve().parent
PROJECT=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB=PROJECT/'research/2026-09-06/work/login-to-world'
CASE=Path(json.loads((ROOT/'installed-location.json').read_text())['case_directory'])
REPORT='2026-09-08_永久武器与仓库换装修复.md'
digest=lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    install=json.loads((ROOT/'permanent-install.json').read_text())
    socket=json.loads((ROOT/'evidence/E-permanent-socket.json').read_text())
    user=json.loads((ROOT/'evidence/E-user-final-confirmation.json').read_text(encoding='utf-8'))
    for name, expected in install['installed'].items():
        assert digest(ROOT/'candidate'/name)==digest(LAB/name)==expected
    assert socket['all_permanent'] and socket['slot_zero_acknowledged']
    assert socket['original_role_unchanged'] and socket['test_count']==82
    assert user['permanent_display_confirmed'] and user['warehouse_equip_confirmed']
    assert 'Ran 82 tests' in (ROOT/'validation-permanent.txt').read_text()
    assert '\nOK' in (ROOT/'validation-permanent.txt').read_text()
    with closing(sqlite3.connect((LAB/'data/lab-roles.sqlite3').as_uri()+'?mode=ro',uri=True)) as db:
        roles=db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
        inv=db.execute('SELECT instance_id,kind,local_id,payload68,permanent FROM lab_inventory WHERE uid=1001 ORDER BY instance_id').fetchall()
    with closing(sqlite3.connect((CASE/'backup/lab-roles.sqlite3').as_uri()+'?mode=ro',uri=True)) as db:
        assert roles==db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
    weapons=[r for r in inv if r[1]==25]
    assert len(inv)==280 and len(weapons)==274
    assert {r[2] for r in weapons}==set(json.loads((LAB/'weapon_ids.json').read_text()))
    assert all(r[4]==1 and struct.unpack_from('<I',r[3],13)[0]==5256000
               and struct.unpack_from('<I',r[3],19)[0]==1
               and struct.unpack_from('<H',r[3],23)[0]==0 for r in weapons)
    assert json.loads((LAB/'lab-control.json').read_text(encoding='utf-8-sig'))==json.loads(
        (CASE/'before-count-fix-20260907-235649/lab-control.json').read_text(encoding='utf-8-sig'))
    summary={**socket,'ui_confirmation_source':'user','ui_inventory_confirmed':True,
             'ui_weapon_switch_confirmed':True,'temporary_control_restored':True,
             'original_role_rows_unchanged':True,'source_sha256':install['installed'],
             'database_sha256':digest(LAB/'data/lab-roles.sqlite3'),
             'equipped_weapons':[{'instance_id':r[0],'local_id':r[2]} for r in weapons
                                 if struct.unpack_from('<H',r[3],17)[0]==8],
             'backup_directory':install['backup_directory']}
    when=datetime.now().strftime('%Y-%m-%d %H:%M')
    relative=CASE.relative_to(PROJECT).as_posix()
    report=f'''# 永久武器与仓库换装修复

完成时间：{when}（Asia/Shanghai）。本地角色 t07 / UID1001 已拥有274种有效武器，服务端保存永久所有权、不设到期时间；客户端显示“365+”。用户完成重启、登录和仓库换装后明确确认：“显示365+，换装成功”。

## 最终实现

- 原836字节角色blob及lab_roles所有原字段逐项比对未改变；6件原服装保留，共280条库存。原武器253002保留，新增273种。目录来自客户端配置type25的274条有效记录，详见evidence/weapons.json。
- lab_inventory独立存储库存。新增permanent INTEGER默认0，旧库事务迁移；本账号274武器设1。读取、装备、卸装均根据该标记生成固定的长期展示字段，不产生到期时间，不随时间扣减。
- 兼容展示使用duration(+13)=5256000分钟、mode(+19)=1、count(+23)=0。客户端将长期时长显示为365+。该值不是已证实的原厂永久哨兵；永久性由本地服务端规则保证。静态证据见equip/permanent-report.md。
- 登录1010返回1020/37、完整1120/19040及1130/360。2080的合法仓库目标槽位0归一为主武器槽位8，保留按角色所有权及type25校验。先发2310/72卸下旧武器，再发2090/84装备新武器。不支持的目标槽位返回2100/2错误38，保留连接；畸形或未拥有实例仍按严格校验处理。

## 已纠正的两个问题

首次仓库为空：旧实现把+9误当显示数量，而真实仓库要求uint16 +23非零或uint32 +13非零。计数修复后用户看到“1个”；随后按用户永久偏好改为上述期限展示。

仓库装备断线：实际客户端可合法发送2080的目标槽位0，旧服务端只接受8并抛错断开。此问题独立于期限。修复及客户端直接路径证据见equip/slot-zero-failure-report.md。

## 验证与备份

82项自动化测试通过，包含永久标记迁移、幂等授予、换装/卸装/重登、原角色不变，以及同TCP发送槽位0与不支持槽位后继续登录。validation-permanent.txt记录完整结果。

实服127.0.0.1:10035验证确认完整274武器与数据库相符；重选当前武器的槽位0请求收到2090，槽位9收到2100后同连接仍可登录，未改变用户武器选择。见evidence/E-permanent-socket.json。用户最终实机确认见evidence/E-user-final-confirmation.json；该确认来自用户操作，本轮未取得最终界面截图。之前计数版本截图只作为历史证据。

原始数据库备份：backup/lab-roles.sqlite3。永久设置前数据库与源码备份：{Path(install['backup_directory']).name}/。当前服务PID {socket['pid']}。最终源码/数据库哈希见final-verification.json，全归档哈希见SHA256.json。初次installed-manifest.json和2026-09-07报告保留为历史记录，当前状态以本报告为准。

临时心跳推送规则已恢复；正式实现依赖持久库存和正常登录。正式游戏安装目录未修改。恢复的是本地兼容服务功能，未恢复丢失的原厂源码文本。
'''
    (ROOT/REPORT).write_text(report,encoding='utf-8')
    for child in ROOT.iterdir():
        if child.is_dir():
            shutil.copytree(child,CASE/child.name,dirs_exist_ok=True,ignore=shutil.ignore_patterns('__pycache__'))
        else:
            shutil.copy2(child,CASE/child.name)
    (CASE/'final-verification.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
    status_path=PROJECT/'CURRENT_STATUS.md'
    old=status_path.read_text(encoding='utf-8-sig')
    backup_status=CASE/'CURRENT_STATUS.before-permanent-final.md'
    if not backup_status.exists():
        shutil.copy2(status_path,backup_status)
    note=f'> 最新状态（{when}，Asia/Shanghai）：**t07 / UID1001 全274种武器已设永久，仓库换装断线已修复**。客户端显示365+，本地服务端不设置到期时间、不扣减时长；用户已确认“显示365+，换装成功”。lab_inventory独立持久化，原lab_roles/836字节未变，6件服装保留，总280条。2080合法slot0归一8；不支持槽位返回2100错误38并保持连接。82项测试及实服完整1120、slot0换装响应、错误后重登验证通过。源码、数据库备份、证据及最新报告：{relative}/{REPORT}；最终哈希见同目录final-verification.json。v4 PID {socket["pid"]}。\n\n'
    if old.startswith('# '):
        first,rest=old.split('\n',1)
        updated=first+'\n\n'+note+rest.lstrip('\n')
    else:
        updated=note+old
    status_path.write_text(updated,encoding='utf-8')
    shutil.copy2(status_path,CASE/'CURRENT_STATUS.after-permanent-final.md')
    hashes={p.relative_to(CASE).as_posix():digest(p) for p in CASE.rglob('*')
            if p.is_file() and p.name!='SHA256.json'}
    (CASE/'SHA256.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({'case_directory':str(CASE),'files_archived':len(hashes),**summary},ensure_ascii=False))

if __name__=='__main__':
    main()
