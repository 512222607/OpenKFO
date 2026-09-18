"""Local C-combo effect editor. Clone hit properties; never alter shared originals."""
import copy
import hashlib
import json
import math
import os
from pathlib import Path
import re
import struct
import subprocess
import tempfile
import xml.etree.ElementTree as ET
import zlib
from contextlib import contextmanager
from datetime import datetime

from .maps import ClientConfig
from .spf2 import CONFIG_KEY, decode_config

BUFFS = {0: '保持原效果', 1: '中毒', 37: '燃烧（献祭燃烧）'}
PROPERTY_FIELDS = {
    'SkillDamage': ('基础伤害', 0, 10000),
    'SkillEnhanceDamage': ('强化伤害', 0, 10000),
    'RepulseTarget': ('击退参数', 0, 120),
    'TripTarget': ('击倒参数', 0, 2),
    'TargetFlurr': ('浮空参数', 0, 3),
    'StandHurt': ('站立受击动作', 0, 255),
    'StandHurtDown': ('倒地受击动作', 0, 255),
    'StandHurtFly': ('站立受击飞行动作', 0, 255),
    'FlyHurt': ('飞行受击动作', 0, 255),
    'JumpHurtDown': ('空中受击动作', 0, 255),
    'JumpHurtFall': ('空中落地动作', 0, 255),
}


def combo_sequences(archive, weapon_id):
    name = f'weapon/{weapon_id}/combotip.xml'
    if name not in archive.entries:
        return []
    root = archive.xml(name)
    return [dict(name=s.get('Name', ''), nodes=[dict(state=n.get('State', ''),
                 keys='+'.join(i.get('Name', '') for i in n if i.get('Name')) or '原始按键未标注') for n in s])
            for s in root.iter('Sequence')]


def buff_catalog(archive):
    parser = ET.XMLParser(target=ET.TreeBuilder(insert_comments=True))
    root = ET.fromstring(raw_entry(archive, 'ustate.xml').decode('gb18030'), parser=parser)
    result = [dict(id=0, name='保持原效果'), dict(id=-1, name='清除原有 BUFF')]
    label = ''
    for node in root:
        if node.tag is ET.Comment:
            label = (node.text or '').strip().splitlines()[0] if (node.text or '').strip() else ''
        elif node.tag == 'Data':
            ident = int(node.get('type'))
            if node.get('ActiveState') == '0' and any(n.get('Type') for n in node.iter('LogicHandle')):
                result.append(dict(id=ident, name=BUFFS.get(ident, label[:35] or f'异常状态 {ident}')))
            label = ''
    return result


def effect_catalog(archive):
    rows = list(archive.xml('skillproperty.xml'))
    # Reuse full native reaction tuples; do not combine unrelated movement IDs.
    choices = [('repulse', '击退', lambda p: p.get('RepulseTarget') == '1'),
               ('float', '上升 / 悬空击飞', lambda p: p.get('TargetFlurr') == '1' and p.get('StandHurtDown') == '1' and p.get('StandHurtFly') == '11'),
               ('fall', '击倒', lambda p: p.get('TripTarget') == '1' and p.get('TargetFlurr') == '0')]
    result = []
    for key, name, matches in choices:
        source = next((p for p in rows if matches(p) and p.get('TargetEnemy') == '1' and p.get('TargetSelf') == '0'), None)
        if source is not None:
            values = {k: int(source.get(k, '0') or '0') for k in PROPERTY_FIELDS if k not in ('SkillDamage', 'SkillEnhanceDamage')}
            result.append(dict(id=key, name=name, source=source.get('SkillProId'), values=values))
    return result


def digest(data):
    return hashlib.sha256(data).hexdigest()


def raw_entry(archive, name):
    index = archive.entries[name]
    offset, size = struct.unpack_from('<II', archive.data, archive.table + index * 8)
    if not 64 <= offset < offset + size + 4 <= archive.tree:
        raise ValueError('配置条目边界错误')
    return decode_config(archive.data[offset + 4:offset + size + 4])


def replace_entries(archive, replacements):
    # SPF2 header +48 points to CRC records, NOT a second offset/size table.
    # sdfile 10010A0C/10010A18: CRC32(flags DWORD + encoded payload).
    # 1001131B: header +56 is CRC32 of the concatenated entry CRC DWORDs.
    additions = bytearray()
    records = {}
    for name, raw in replacements.items():
        compressed = zlib.compress(raw)
        encoded = bytes(v ^ 255 ^ CONFIG_KEY[i % len(CONFIG_KEY)] for i, v in enumerate(compressed))
        records[archive.entries[name]] = (archive.tree + len(additions), len(encoded))
        additions.extend(struct.pack('<I', 0x2200) + encoded)
    result = bytearray(archive.data[:archive.tree] + additions + archive.data[archive.tree:])
    delta = len(additions)
    tree, table, checksums, count = struct.unpack_from('<4I', result, 40)
    struct.pack_into('<4I', result, 40, tree + delta, table + delta, checksums + delta, count)
    for index, record in records.items():
        struct.pack_into('<II', result, table + delta + index * 8, *record)
        offset, size = record
        struct.pack_into('<I', result, checksums + delta + index * 8,
                         zlib.crc32(result[offset:offset + size + 4]))
    summary = b''.join(result[checksums + delta + i * 8:checksums + delta + i * 8 + 4]
                       for i in range(count))
    struct.pack_into('<I', result, 56, zlib.crc32(summary))
    return bytes(result)


def verify_checksums(archive):
    checksums = struct.unpack_from('<I', archive.data, 48)[0]
    summary = bytearray()
    for i in range(archive.count):
        offset, size = struct.unpack_from('<II', archive.data, archive.table + i * 8)
        record = archive.data[checksums + i * 8:checksums + i * 8 + 4]
        if not 64 <= offset < offset + size + 4 <= archive.tree:
            raise ValueError('配置条目边界错误')
        if struct.unpack('<I', record)[0] != zlib.crc32(archive.data[offset:offset + size + 4]):
            raise ValueError('配置包条目 CRC 校验失败，未写入')
        summary.extend(record)
    if zlib.crc32(summary) != struct.unpack_from('<I', archive.data, 56)[0]:
        raise ValueError('配置包汇总 CRC 校验失败，未写入')


def atomic_write(path, data):
    fd, temp = tempfile.mkstemp(dir=path.parent, prefix=path.name + '.', suffix='.tmp')
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temp, path)
    finally:
        if os.path.exists(temp):
            os.unlink(temp)


@contextmanager
def locked(folder):
    folder.mkdir(parents=True, exist_ok=True)
    lock = folder / 'editing.lock'
    try:
        fd = os.open(lock, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
    except FileExistsError:
        raise ValueError('另一项武器配置操作正在进行，请稍后重试') from None
    try:
        os.close(fd)
        yield
    finally:
        lock.unlink()


def inspect(archive, items):
    buff_ids = [b['id'] for b in buff_catalog(archive)]
    lines = [line.split('\t') for line in raw_entry(archive, 'itemact.txt').decode('gb18030').splitlines() if line.strip()]
    header, rows = lines[0], lines[1:]
    owners = {}
    for row in rows:
        for i, action in enumerate(row[2:], 2):
            if action != '0':
                owners.setdefault(action, set()).add((row[0], header[i]))
    animation = raw_entry(archive, 'animation/2001.xml').decode('gb18030')
    blocks = {}
    for match in re.finditer(r'<AnmDesc\b[^>]*>.*?</AnmDesc\s*>', animation, re.S):
        element = ET.fromstring(match.group())
        blocks.setdefault(element.get('id'), []).append((match.group(), element))
    properties = {}
    for element in archive.xml('skillproperty.xml'):
        properties.setdefault(element.get('SkillProId'), []).append(element)
    allowed_values = {field: sorted({int(p.get(field, '0') or '0') for entries in properties.values() for p in entries})
                      for field in PROPERTY_FIELDS if field not in ('SkillDamage', 'SkillEnhanceDamage')}
    names = {str(i['id']): i['name'] for i in items if i['kind'] == 25}
    weapons = []
    for row in rows:
        if row[0] not in names:
            continue
        stages = []
        sequences = combo_sequences(archive, row[0])
        states = list(dict.fromkeys([str(2010 + n) for n in range(1, 7)] +
                      [n['state'] for s in sequences for n in s['nodes'] if n['state'] in header]))
        for state in states:
            number = int(state) - 2010 if 2011 <= int(state) <= 2016 else int(state)
            action = row[header.index(state)]
            if action == '0':
                continue
            candidates = blocks.get(action[4:], []) if action.startswith('2001') else []
            refs = sorted({node.get('skillproid') for _, el in candidates for node in el.iter() if node.get('skillproid') not in (None, '', '0')})
            reason = ''
            if len(candidates) != 1 or not refs or any(len(properties.get(ref, [])) != 1 for ref in refs):
                reason = '动作或命中属性未能唯一对应，暂不可应用'
            elif owners[action] != {(row[0], state)}:
                reason = '该动作被其他武器或招式共用，暂不可单独修改'
            elif any(properties[ref][0].get('TargetSelf') != '0' or properties[ref][0].get('TargetEnemy') != '1' for ref in refs):
                reason = '该段包含非敌方命中效果，暂不可应用'
            hits = [dict(id=ref, values={key: properties[ref][0].get(key, '0') or '0'
                    for key in PROPERTY_FIELDS}, buff=properties[ref][0].get('UnNormalState', '0'))
                    for ref in refs if len(properties.get(ref, [])) == 1]
            labels = list(dict.fromkeys(n['keys'] for s in sequences for n in s['nodes'] if n['state'] == state))
            stages.append(dict(stage=number, state=state, label=f'第 {number} 下 C' if number <= 6 else ' / '.join(labels) or state,
                               action=action, property_ids=refs, hits=hits, supported=not reason, reason=reason))
        if stages:
            weapons.append(dict(id=int(row[0]), name=names[row[0]], stages=stages, combos=sequences, buff_ids=buff_ids, allowed_values=allowed_values))
    return weapons, blocks, properties


def validate(rules, weapon):
    if not isinstance(rules, list) or len(rules) > len(weapon['stages']):
        raise ValueError('连招配置格式错误')
    stages = {s['stage']: s for s in weapon['stages']}
    result, seen = [], set()
    for rule in rules:
        if not isinstance(rule, dict) or any(type(rule.get(k)) is not int for k in ('stage', 'buff', 'level', 'duration')):
            raise ValueError('连招、效果、等级和持续周期必须为整数')
        stage, buff, level, duration = (rule[k] for k in ('stage', 'buff', 'level', 'duration'))
        if stage not in stages or stage in seen or buff not in weapon.get('buff_ids', BUFFS) or not 1 <= level <= 3 or not 1 <= duration <= 60000:
            raise ValueError('效果参数超出范围，等级 1–3，持续周期 1–60000')
        overrides = rule.get('properties', {})
        if not isinstance(overrides, dict) or any(key not in stages[stage]['property_ids'] for key in overrides):
            raise ValueError('命中属性不属于当前招式')
        for values in overrides.values():
            if not isinstance(values, dict):
                raise ValueError('命中属性格式错误')
            for field, value in values.items():
                numeric = type(value) in (int, float) and math.isfinite(value)
                if field not in PROPERTY_FIELDS or not numeric or not PROPERTY_FIELDS[field][1] <= value <= PROPERTY_FIELDS[field][2]:
                    raise ValueError('伤害或攻击效果超出范围')
                if field not in ('SkillDamage', 'SkillEnhanceDamage') and type(value) is not int:
                    raise ValueError('攻击效果编号必须为整数')
                if field in weapon.get('allowed_values', {}) and value not in weapon['allowed_values'][field]:
                    raise ValueError('受击参数不属于本客户端原始配置，请选择原生攻击效果')
        if (buff or overrides) and not stages[stage]['supported']:
            raise ValueError(stages[stage]['reason'])
        seen.add(stage)
        if buff or overrides:
            saved = dict(stage=stage, buff=buff, level=level, duration=duration)
            if overrides:
                saved['properties'] = overrides
            result.append(saved)
    return sorted(result, key=lambda r: r['stage'])


def render(archive, items, plans):
    weapons, blocks, properties = inspect(archive, items)
    by_id = {str(w['id']): w for w in weapons}
    animation = raw_entry(archive, 'animation/2001.xml').decode('gb18030')
    prop_text = raw_entry(archive, 'skillproperty.xml').decode('gb18030')
    clones = []
    next_id = 900000000
    for weapon_id, rules in sorted(plans.items()):
        if weapon_id not in by_id:
            raise ValueError('武器配置已变化')
        weapon = by_id[weapon_id]
        for rule in validate(rules, weapon):
            stage = next(s for s in weapon['stages'] if s['stage'] == rule['stage'])
            original, element = blocks[stage['action'][4:]][0]
            changed = copy.deepcopy(element)
            remap = {}
            for old_id in stage['property_ids']:
                while str(next_id) in properties:
                    next_id += 1
                new_id = str(next_id)
                next_id += 1
                prop = copy.deepcopy(properties[old_id][0])
                prop.set('SkillProId', new_id)
                if rule['buff']:
                    prop.set('UnNormalState', str(max(0, rule['buff'])))
                    prop.set('UStateLevel', str(rule['level'] if rule['buff'] > 0 else 0))
                    prop.set('UStateLastCycle', str(rule['duration'] if rule['buff'] > 0 else 0))
                for field, value in rule.get('properties', {}).get(old_id, {}).items():
                    prop.set(field, str(value))
                clones.append(ET.tostring(prop, encoding='unicode'))
                remap[old_id] = new_id
            for node in changed.iter():
                if node.get('skillproid') in remap:
                    node.set('skillproid', remap[node.get('skillproid')])
            if animation.count(original) != 1:
                raise ValueError('动作定义无法唯一替换')
            animation = animation.replace(original, ET.tostring(changed, encoding='unicode'), 1)
    if not clones:
        return archive.data
    prop_text, count = re.subn(r'</SkillProperty\s*>', lambda _: '\n' + '\n'.join(clones) + '\n</SkillProperty>', prop_text)
    if count != 1:
        raise ValueError('技能属性表结构错误')
    ET.fromstring(prop_text)
    return replace_entries(archive, {'animation/2001.xml': animation.encode('gb18030'), 'skillproperty.xml': prop_text.encode('gb18030')})


def handle(request, client, items, folder=None):
    package = Path(client) / 'Data/config.spf2'
    folder = Path(folder) if folder else Path(client).parent / 'weapon-config'
    with locked(folder):
        state_path = folder / 'settings.json'
        state = json.loads(state_path.read_text('utf-8')) if state_path.exists() else dict(drafts={}, applied={})
        baseline = folder / 'original.spf2'
        source = ClientConfig(baseline if baseline.exists() else package)
        verify_checksums(source)
        if state.get('source_hash') and digest(source.data) != state['source_hash']:
            raise ValueError('原始配置备份已变化，已停止写入')
        weapons, _, _ = inspect(source, items)
        current = package.read_bytes()
        revision = digest(current + (state_path.read_bytes() if state_path.exists() else b''))
        operation = request.get('operation')
        if operation == 'weapon_catalog':
            return dict(weapons=weapons, effects=effect_catalog(source), fields=[dict(key=k, name=v[0], min=v[1], max=v[2]) for k, v in PROPERTY_FIELDS.items()], buffs=buff_catalog(source), drafts=state['drafts'], applied=state['applied'], revision=revision, folder=str(folder))
        if request.get('revision') != revision:
            raise ValueError('配置已被其他操作更新，请重新打开武器配置后再保存')
        weapon = next((w for w in weapons if w['id'] == request.get('weapon')), None)
        if weapon is None:
            raise ValueError('请选择本客户端的武器')
        key = str(weapon['id'])
        rules = validate(request.get('rules'), weapon)
        if operation not in ('weapon_save', 'weapon_apply', 'weapon_restore'):
            raise ValueError('未知武器配置操作')
        backup = None
        if operation in ('weapon_apply', 'weapon_restore'):
            if os.name == 'nt':
                running = subprocess.run(['tasklist', '/FI', 'IMAGENAME eq gfld.dat', '/FO', 'CSV', '/NH'], capture_output=True, creationflags=0x08000000, check=True)
                if b'gfld.dat' in running.stdout.lower():
                    raise ValueError('请先退出游戏客户端，再应用；可以先保存方案')
            if digest(current) != state.get('applied_hash', digest(source.data)):
                raise ValueError('游戏配置已被其他程序修改，已停止覆盖；请保留现有文件并重新核对')
            if operation == 'weapon_restore':
                state['applied'].pop(key, None)
            else:
                state['applied'][key] = rules
            data = render(source, items, state['applied'])
            if not baseline.exists():
                atomic_write(baseline, source.data)
            backup = folder / (datetime.now().strftime('before-%Y%m%d-%H%M%S-%f') + '.spf2')
            atomic_write(backup, current)
            # Validate the finished archive through the same reader as the game tooling.
            temp = folder / 'validate.spf2'
            try:
                temp.write_bytes(data)
                verified = ClientConfig(temp)
                verify_checksums(verified)
                verified.xml('skillproperty.xml')
                for name in source.entries:
                    expected = raw_entry(verified, name)
                    if name not in ('animation/2001.xml', 'skillproperty.xml') and expected != raw_entry(source, name):
                        raise ValueError('无关配置校验失败，未写入')
            finally:
                temp.unlink(missing_ok=True)
            atomic_write(package, data)
            state['source_hash'] = digest(source.data)
            state['applied_hash'] = digest(data)
        if operation != 'weapon_restore':
            state['drafts'][key] = rules
        try:
            atomic_write(state_path, json.dumps(state, ensure_ascii=False, indent=2).encode('utf-8'))
        except Exception:
            if backup is not None:
                atomic_write(package, current)
            raise
        return dict(backup=str(backup) if backup else None, message='方案已保存，尚未应用到游戏' if operation == 'weapon_save' else '配置已写入；启动游戏后加载，实战效果仍需验证' if operation == 'weapon_apply' else '该武器已恢复原效果；保存的方案仍保留')
