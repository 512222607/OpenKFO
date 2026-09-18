import json
from pathlib import Path
import shutil
import struct
import tempfile
import unittest
from unittest.mock import patch

from server.kk_local.item_admin import CLIENT
from server.kk_local.maps import ClientConfig
from server.kk_local.weapon_admin import handle, raw_entry, verify_checksums


@unittest.skipUnless((CLIENT / 'Data/config.spf2').is_file(), 'installed client fixture required')
class WeaponEditorTests(unittest.TestCase):
    def test_default_combos_and_damage_only_changes(self):
        from server.kk_local.weapon_admin import inspect, render, validate, combo_sequences
        baseline = CLIENT.parent / 'weapon-config/original.spf2'
        source = ClientConfig(baseline)
        # Native secret-book combos have blank Icon names in their ultimate
        # sequences. Do not invent '+' keys or infer keys from stale comments.
        combos = combo_sequences(source, 253013)
        self.assertEqual(next(c for c in combos if c['name'] == '站立必杀')['nodes'][0]['keys'], '原始按键未标注')
        items = [dict(id=253905, name='骤足（纪念版）', kind=25)]
        weapons, blocks, properties = inspect(source, items)
        weapon = weapons[0]
        self.assertEqual([n['keys'] for n in weapon['combos'][0]['nodes']], ['C'] * 5)
        self.assertGreater(len(weapon['stages']), 5)
        first = weapon['stages'][0]
        ref = first['property_ids'][0]
        rule = dict(stage=1, buff=0, level=1, duration=3000,
                    properties={ref: dict(SkillDamage=0, RepulseTarget=1)})
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / 'config.spf2'
            path.write_bytes(render(source, items, {'253905': [rule]}))
            changed = ClientConfig(path)
            verify_checksums(changed)
            props = {p.get('SkillProId'): p.attrib for p in changed.xml('skillproperty.xml')}
            new = props['900000000']
            self.assertEqual(new['SkillDamage'], '0')
            self.assertEqual(new['RepulseTarget'], '1')
            self.assertEqual(new.get('UnNormalState'), properties[ref][0].get('UnNormalState'))
            self.assertEqual(props[ref], properties[ref][0].attrib)
        with self.assertRaises(ValueError):
            validate([dict(rule, properties={ref: {'SkillDamage': -1}})], weapon)
        with self.assertRaises(ValueError):
            validate([dict(rule, properties={'other-hit': {'SkillDamage': 5}})], weapon)

    def test_isolated_combo_save_apply_restore_and_conflicts(self):
        items = [dict(id=253013, name='骤足秘笈', kind=25), dict(id=253110, name='圣枪', kind=25)]
        with tempfile.TemporaryDirectory() as tmp:
            client = Path(tmp) / 'client'
            (client / 'Data').mkdir(parents=True)
            package = client / 'Data/config.spf2'
            baseline = CLIENT.parent / 'weapon-config/original.spf2'
            shutil.copyfile(baseline if baseline.exists() else CLIENT / 'Data/config.spf2', package)
            original = package.read_bytes()
            catalog = handle({'operation': 'weapon_catalog'}, client, items)
            rules = [dict(stage=1, buff=1, level=2, duration=3000), dict(stage=2, buff=37, level=1, duration=5000)]
            request = dict(operation='weapon_save', weapon=253013, rules=rules, revision=catalog['revision'])
            handle(request, client, items)
            self.assertEqual(package.read_bytes(), original)
            with self.assertRaisesRegex(ValueError, '更新'):
                handle(request, client, items)
            request['revision'] = handle({'operation': 'weapon_catalog'}, client, items)['revision']
            request['operation'] = 'weapon_apply'
            with patch('server.kk_local.weapon_admin.subprocess.run') as run:
                run.return_value.stdout = b'"gfld.dat"'
                with self.assertRaisesRegex(ValueError, '退出'):
                    handle(request, client, items)
                run.return_value.stdout = b''
                result = handle(request, client, items)
                self.assertTrue(Path(result['backup']).is_file())
                changed = ClientConfig(package)
                base = ClientConfig(Path(tmp) / 'weapon-config/original.spf2')
                verify_checksums(base)
                verify_checksums(changed)
                # The opaque second DWORD of each CRC record is retained.
                old_tail = struct.unpack_from('<I', base.data, 48)[0]
                new_tail = struct.unpack_from('<I', changed.data, 48)[0]
                for i in range(base.count):
                    self.assertEqual(base.data[old_tail+i*8+4:old_tail+i*8+8],
                                     changed.data[new_tail+i*8+4:new_tail+i*8+8])
                damaged = bytearray(changed.data)
                damaged[56] ^= 1
                package.write_bytes(damaged)
                with self.assertRaisesRegex(ValueError, 'CRC'):
                    verify_checksums(ClientConfig(package))
                package.write_bytes(changed.data)
                for name in base.entries:
                    if name not in ('animation/2001.xml', 'skillproperty.xml'):
                        self.assertEqual(raw_entry(base, name), raw_entry(changed, name), name)
                props = {p.get('SkillProId'): p.attrib for p in changed.xml('skillproperty.xml')}
                baseline_props = {p.get('SkillProId'): p.attrib for p in base.xml('skillproperty.xml')}
                for key, value in baseline_props.items():
                    self.assertEqual(props[key], value)
                animation = changed.xml('animation/2001.xml')
                for action, buff in [('130', '1'), ('131', '37')]:
                    block = next(a for a in animation if a.get('id') == action)
                    hits = [a for a in block.iter() if a.get('skillproid')]
                    self.assertEqual(len(hits), 1 if action == '130' else 2)
                    for hit in hits:
                        self.assertEqual(props[hit.get('skillproid')]['UnNormalState'], buff)
                base_blocks = list(base.xml('animation/2001.xml'))
                import xml.etree.ElementTree as ET
                self.assertEqual(len(animation), len(base_blocks))
                for block, old_block in zip(animation, base_blocks):
                    if block.get('id') not in ('130', '131'):
                        self.assertEqual(ET.tostring(block), ET.tostring(old_block))
                request.update(operation='weapon_restore', revision=handle({'operation': 'weapon_catalog'}, client, items)['revision'])
                handle(request, client, items)
                self.assertEqual(package.read_bytes(), original)
                request.update(operation='weapon_apply', revision=handle({'operation': 'weapon_catalog'}, client, items)['revision'])
                package.write_bytes(original + b'external-change')
                with self.assertRaisesRegex(ValueError, '更新'):
                    handle(request, client, items)
                package.write_bytes(original)
            request.update(operation='weapon_save', revision=handle({'operation': 'weapon_catalog'}, client, items)['revision'])
            request['rules'] = [dict(stage=1, buff=999, level=1, duration=3000)]
            with self.assertRaises(ValueError):
                handle(request, client, items)
            state = json.loads((Path(tmp) / 'weapon-config/settings.json').read_text('utf-8'))
            self.assertEqual(state['drafts']['253013'], rules)


if __name__ == '__main__':
    unittest.main()
