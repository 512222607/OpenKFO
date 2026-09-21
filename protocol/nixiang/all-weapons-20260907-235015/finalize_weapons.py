"""Archive final source/evidence and update the project's handoff note."""
from pathlib import Path
from contextlib import closing
from datetime import datetime
import hashlib
import json
import shutil
import sqlite3
import sys

ROOT=Path(__file__).resolve().parent
PROJECT=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB=PROJECT/'research/2026-09-06/work/login-to-world'
manifest=json.loads((ROOT/'installed-location.json').read_text(encoding='utf-8'))
CASE=Path(manifest['case_directory'])
REPORT='2026-09-07_逆向-all-weapons-report.md'
verified='--ui-confirmed' in sys.argv
equipped='--equip-confirmed' in sys.argv


def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    # The only final source adjustment renames the misleading +9 variable;
    # binary behavior remains the already tested +23 count implementation.
    for name in ['inventory_protocol.py','test_inventory_store.py','test_inventory_protocol.py']:
        shutil.copy2(ROOT/'candidate'/name,LAB/name)
    for child in ROOT.iterdir():
        if child.is_dir():
            shutil.copytree(child,CASE/child.name,dirs_exist_ok=True,
                            ignore=shutil.ignore_patterns('__pycache__'))
        else:
            shutil.copy2(child,CASE/child.name)
    with closing(sqlite3.connect((LAB/'data/lab-roles.sqlite3').as_uri()+'?mode=ro',uri=True)) as db:
        rows=db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
        inv=db.execute('SELECT instance_id,kind,local_id,payload68 FROM lab_inventory WHERE uid=1001 ORDER BY instance_id').fetchall()
    with closing(sqlite3.connect((CASE/'backup/lab-roles.sqlite3').as_uri()+'?mode=ro',uri=True)) as db:
        assert rows==db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
    assert len(inv)==280
    assert sum(kind==25 for _,kind,_,_ in inv)==274
    assert all(int.from_bytes(bytes(p)[23:25],'little')==1 for _,kind,_,p in inv if kind==25)
    actual_ids={local_id for _,kind,local_id,_ in inv if kind==25}
    assert actual_ids==set(json.loads((LAB/'weapon_ids.json').read_text()))
    current_control=json.loads((LAB/'lab-control.json').read_text(encoding='utf-8-sig'))
    original_control=json.loads((CASE/'before-count-fix-20260907-235649/lab-control.json').read_text(encoding='utf-8-sig'))
    assert current_control==original_control, 'Temporary rules must be restored'
    summary={'uid':1001,'name':'t07','items':280,'weapons':274,
             'original_role_rows_unchanged':True,'all_weapon_counts_one':True,
             'temporary_control_restored':True,'ui_inventory_confirmed':verified,
             'ui_weapon_switch_confirmed':equipped,'v4_pid':21116,
             'equipped_weapons':[{'instance_id':i,'local_id':l} for i,k,l,p in inv
                                 if k==25 and int.from_bytes(bytes(p)[17:19],'little')==8],
             'source_sha256':{n:digest(LAB/n) for n in manifest['installed']},
             'database_sha256':digest(LAB/'data/lab-roles.sqlite3'),
             'test_count':76}
    (CASE/'final-verification.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
    when=datetime.now().strftime('%Y-%m-%d %H:%M')
    ui_text='真实客户端已显示多页武器仓库' if verified else '真实客户端仓库显示待最终复核'
    equip_text='，实机换装成功' if equipped else '；穿戴/卸装已通过TCP测试'
    addon=f'''\n\n## 正式安装与数量字段纠正（{when}）

正式安装目录为本报告所在目录，v4 PID21116。角色t07/UID1001持久拥有274种武器，原有253002保留，补273件，总库存280条。SQLite备份在backup/lab-roles.sqlite3，角色原始lab_roles各字段逐项比对不变。

首轮真实重登确实收到1120/19040但仓库为空，用户反馈已记录。IDA进一步定位raw89ADE0的仓库过滤：uint16 item+23计数或uint32 item+13时长必须非零。旧的item+9不是此数量；已把独立库存中全部274武器的+23设为1，原角色blob不动。证据见equip/warehouse-report.md。新增两项仓库计数与已有坏记录修复回归后共76项通过。

一次临时心跳1120推送只证明当前会话收到网络包，不代表大厅分发器使用登录消息，配置已完整恢复。后续正常登录仍由RoleSession从持久库下发修正的全量1120。{ui_text}{equip_text}。完整19040字节经正式10035端口202次小块读取重组，与SQLite逐字节一致；见evidence/E-installed-inventory-socket.json。

当前最终验证见final-verification.json；最初installed-manifest.json保留第一次安装的哈希，后续数量修正以final-verification.json为准。before-count-fix-20260907-235649保留修正前库存、代码和配置。全部测试、证据和脚本留在原项目；临时心跳规则不作为正式实现。
'''
    report=(CASE/REPORT).read_text(encoding='utf-8')
    report=report.replace('本报告当前记录候选实现；正式安装结果见随后生成的installed-manifest.json，真实显示需安装后验证。',
                          '正式安装及数量字段纠正已完成；最终验证和备份路径见文末。')
    (CASE/REPORT).write_text(report+addon,encoding='utf-8')
    status_path=PROJECT/'CURRENT_STATUS.md'
    old=status_path.read_text(encoding='utf-8-sig')
    shutil.copy2(status_path,CASE/'CURRENT_STATUS.before-weapons-final.md')
    relative=CASE.relative_to(PROJECT).as_posix()
    note=f'> 最新状态（{when}，Asia/Shanghai）：**t07全武器背包已安装**。本地UID1001共274种有效type25武器（保留原253002，补273件），6件原服装保留，总280条。新增lab_inventory独立持久化，原lab_roles/836字节未改；1010→1120/19040→1130。仓库空的根因是实际数量uint16+23为0，非旧+9字段，现所有武器+23=1。2080/16→2310/72旧卸装+2090/84新装备，2300/4→2310/72；换装/卸装重登保持。{ui_text}{equip_text}。76项测试、正式socket全量清单验证通过，临时心跳配置已恢复。v4 PID21116。源码、SQLite备份、目录、静态/实机证据和报告：{relative}/；最终哈希看final-verification.json。未实现完整多人、其他模式或原厂源码文本恢复。\n\n'
    if old.startswith('# '):
        first,rest=old.split('\n',1)
        updated=first+'\n\n'+note+rest.lstrip('\n')
    else:
        updated=note+old
    status_path.write_text(updated,encoding='utf-8')
    hashes={p.relative_to(CASE).as_posix():digest(p) for p in CASE.rglob('*')
            if p.is_file() and p.name!='SHA256.json'}
    (CASE/'SHA256.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({'case_directory':str(CASE),**summary},ensure_ascii=False),flush=True)


if __name__=='__main__':
    main()
