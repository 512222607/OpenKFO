import 'package:flutter/material.dart';

class WeaponLevelsConfigPage extends StatefulWidget {
  const WeaponLevelsConfigPage({
    super.key,
    required this.api,
    required this.environment,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  @override
  State<WeaponLevelsConfigPage> createState() => _WeaponLevelsConfigPageState();
}

class _WeaponLevelsConfigPageState extends State<WeaponLevelsConfigPage> {
  List<Map<String, dynamic>> levels = [];
  int? revision;
  bool busy = false, enabled = false;
  String status = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => status = '操作失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void apply(dynamic data) {
    if (!mounted) return;
    final rules = data['rules'] as Map;
    final rows = ((rules['levels'] as List?) ?? [])
        .map((v) => Map<String, dynamic>.from(v as Map))
        .toList();
    setState(() {
      revision = data['revision'] as int;
      enabled = rules['enabled'] == true;
      levels = rows;
      status = '已读取 ${widget.environment}，版本 $revision';
    });
  }

  Future<void> load() => run(() async {
    setState(() => revision = null);
    apply(await widget.api({'operation': 'weapon_settings_get'}));
  });
  Future<void> save() => run(() async {
    if (enabled && levels.length < 2) throw const FormatException('启用需要至少两个等级');
    apply(
      await widget.api({
        'operation': 'weapon_settings_save',
        'weapon_settings': {
          'revision': revision,
          'rules': {'enabled': enabled, 'levels': levels},
        },
      }),
    );
    if (mounted) {
      setState(() => status = '已保存到 ${widget.environment}；新版服务器使用此配置，玩家需重新打开升级面板');
    }
  });
  Future<void> edit(int index) async {
    final row = index < levels.length
        ? levels[index]
        : <String, dynamic>{'level': index, 'unknown_16': 0};
    const fields = {
      'score_threshold': '升级所需熟练度',
      'gold': '升级金币',
      'display_odds': '成功率（0–100）',
      'attack_bonus_raw': '攻击加成显示原值',
    };
    final values = {for (final key in fields.keys) key: '${row[key] ?? ''}'};
    String error = '';
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text('武器等级 $index'),
          content: SizedBox(
            width: 360,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final field in fields.entries)
                    TextFormField(
                      key: ValueKey(field.key),
                      initialValue: values[field.key],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: field.value),
                      onChanged: (v) => values[field.key] = v,
                    ),
                  Text('保留字段：${row['unknown_16'] ?? 0}（不修改）'),
                  Text(error),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final parsed = <String, dynamic>{...row};
                for (final field in fields.keys) {
                  final n = int.tryParse(values[field]!.trim());
                  final max = field == 'display_odds' ? 100 : 4294967295;
                  if (n == null ||
                      n < 0 ||
                      n > max ||
                      (field == 'score_threshold' && n == 0)) {
                    update(() => error = '${fields[field]}无效');
                    return;
                  }
                  parsed[field] = n;
                }
                Navigator.pop(context, parsed);
              },
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (index == levels.length) {
        levels.add(result);
      } else {
        levels[index] = result;
      }
      status = '有未保存的修改';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('武器升级 · ${widget.environment}')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '按当前等级扣熟练度和金币，失败保留等级。最高一行是满级。此为自定义规则；攻击加成原值是客户端显示字段，不代表已验证的伤害公式。需部署支持动态读取的新版服务器。',
          ),
          SwitchListTile(
            title: const Text('启用武器升级'),
            value: enabled,
            onChanged: busy || revision == null
                ? null
                : (v) => setState(() => enabled = v),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, i) {
                final r = levels[i];
                return ListTile(
                  title: Text('等级 $i'),
                  subtitle: Text(
                    '熟练度 ${r['score_threshold']} · 金币 ${r['gold']} · 成功率 ${r['display_odds']}%',
                  ),
                  onTap: busy || revision == null ? null : () => edit(i),
                );
              },
            ),
          ),
          Text(status),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: busy ? null : load,
                child: const Text('重新读取'),
              ),
              TextButton(
                onPressed: busy || revision == null || levels.length >= 256
                    ? null
                    : () => edit(levels.length),
                child: const Text('新增下一级'),
              ),
              TextButton(
                onPressed: busy || revision == null || levels.isEmpty
                    ? null
                    : () => setState(() {
                        levels.removeLast();
                        status = '有未保存的修改';
                      }),
                child: const Text('删除最高级'),
              ),
              FilledButton(
                onPressed: busy || revision == null ? null : save,
                child: const Text('保存升级配置'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
