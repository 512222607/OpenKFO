import 'package:flutter/material.dart';

class WeaponConfigPage extends StatefulWidget {
  const WeaponConfigPage({super.key, required this.api});
  final Future<dynamic> Function(Map<String, dynamic>) api;
  @override
  State<WeaponConfigPage> createState() => _WeaponConfigPageState();
}

class _WeaponConfigPageState extends State<WeaponConfigPage> {
  Map<String, dynamic>? data, weapon;
  final form = GlobalKey<FormState>();
  List<Map<String, dynamic>> rules = [];
  String query = '', message = '';
  bool busy = true, dirty = false, failed = false, showOtherActions = false;
  int editorVersion = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final result = Map<String, dynamic>.from(
        await widget.api({'operation': 'weapon_catalog'}),
      );
      if (!mounted) return;
      setState(() {
        data = result;
        final weapons = (data!['weapons'] as List);
        final selected = weapons.where(
          (w) => w['id'] == (weapon?['id'] ?? 253013),
        );
        if (selected.isNotEmpty) {
          select(Map<String, dynamic>.from(selected.first));
        } else if (weapons.isNotEmpty) {
          select(Map<String, dynamic>.from(weapons.first));
        }
        busy = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          busy = false;
          failed = true;
          message = '$e';
        });
      }
    }
  }

  void select(Map<String, dynamic> value) {
    editorVersion++;
    weapon = value;
    final stored = data!['drafts']['${value['id']}'] as List? ?? [];
    rules = (value['stages'] as List).map((stage) {
      final saved = stored.where((r) => r['stage'] == stage['stage']);
      return saved.isEmpty
          ? <String, dynamic>{
              'stage': stage['stage'],
              'buff': 0,
              'level': 1,
              'duration': 3000,
            }
          : Map<String, dynamic>.from(saved.first);
    }).toList();
    dirty = false;
  }

  Future<bool> discard() async =>
      !dirty ||
      await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('有未保存的修改'),
              content: const Text('离开后会丢弃当前修改。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('继续编辑'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('丢弃修改'),
                ),
              ],
            ),
          ) ==
          true;

  Future<void> execute(String operation) async {
    if (!(form.currentState?.validate() ?? false)) return;
    if (operation != 'weapon_save') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(operation == 'weapon_apply' ? '应用到本地客户端' : '恢复原效果'),
          content: Text(
            operation == 'weapon_apply'
                ? '将应用「${weapon!['name']}」当前配置的招式伤害、BUFF 和受击效果。修改对使用此客户端的角色生效，不限当前账号。\n\n请先退出游戏；写入前自动备份。重启后加载，实战效果尚待验证。'
                : '恢复「${weapon!['name']}」的原始招式伤害、BUFF 和受击效果，其他武器配置保留。请先退出游戏。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('确认写入'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    setState(() {
      busy = true;
      failed = false;
      message = '';
    });
    try {
      final result = await widget.api({
        'operation': operation,
        'weapon': weapon!['id'],
        'rules': rules,
        'revision': data!['revision'],
      });
      if (!mounted) return;
      setState(() {
        dirty = false;
        message = result['message'];
      });
      await load();
    } catch (e) {
      if (mounted) {
        setState(() {
          busy = false;
          failed = true;
          message = '$e';
        });
      }
    }
  }

  List<Widget> hitEditors(
    dynamic stage,
    Map<String, dynamic> rule,
    bool enabled,
  ) {
    return [
      for (final hit in (stage['hits'] as List? ?? []))
        ExpansionTile(
          title: Text(
            '命中 ${hit['id']} · 基础伤害 ${rule['properties']?[hit['id']]?['SkillDamage'] ?? hit['values']['SkillDamage']}',
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButtonFormField<String>(
                key: ValueKey(
                  '$editorVersion-${rule['stage']}-${hit['id']}-effect',
                ),
                decoration: const InputDecoration(labelText: '搭配攻击效果'),
                items: [
                  const DropdownMenuItem(
                    value: 'original',
                    child: Text('恢复该命中的原攻击效果'),
                  ),
                  for (final effect in (data?['effects'] as List? ?? []))
                    DropdownMenuItem(
                      value: effect['id'] as String,
                      child: Text(effect['name']),
                    ),
                ],
                onChanged: !enabled
                    ? null
                    : (value) => setState(() {
                        final changes = rule.putIfAbsent(
                          'properties',
                          () => <String, dynamic>{},
                        ) as Map;
                        final values = changes.putIfAbsent(
                          hit['id'],
                          () => <String, dynamic>{},
                        ) as Map;
                        if (value == 'original') {
                          values.removeWhere(
                            (key, _) =>
                                key != 'SkillDamage' &&
                                key != 'SkillEnhanceDamage',
                          );
                          if (values.isEmpty) changes.remove(hit['id']);
                          if (changes.isEmpty) rule.remove('properties');
                        } else {
                          final effect = (data!['effects'] as List).firstWhere(
                            (e) => e['id'] == value,
                          );
                          values.addAll(effect['values'] as Map);
                        }
                        editorVersion++;
                        dirty = true;
                      }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final field in (data?['fields'] as List? ?? []))
                    SizedBox(
                      width: 170,
                      child: TextFormField(
                        key: ValueKey(
                          '$editorVersion-${rule['stage']}-${hit['id']}-${field['key']}',
                        ),
                        initialValue:
                            '${rule['properties']?[hit['id']]?[field['key']] ?? hit['values'][field['key']]}',
                        enabled: enabled,
                        decoration: InputDecoration(
                          labelText: field['name'],
                          helperText:
                              '${field['min']}–${field['max']}；原值 ${hit['values'][field['key']]}',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          final v = num.tryParse(text ?? '');
                          return v == null ||
                                  !v.isFinite ||
                                  v < field['min'] ||
                                  v > field['max']
                              ? '数值超出范围'
                              : null;
                        },
                        onChanged: (text) => setState(() {
                          final changes = rule.putIfAbsent(
                            'properties',
                            () => <String, dynamic>{},
                          ) as Map;
                          final values = changes.putIfAbsent(
                            hit['id'],
                            () => <String, dynamic>{},
                          ) as Map;
                          values[field['key']] = num.tryParse(text) ?? -1;
                          dirty = true;
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final weapons = (data?['weapons'] as List? ?? [])
        .where((w) => '${w['name']} ${w['id']}'.contains(query))
        .toList();
    final visibleStages = List.generate(rules.length, (i) => i).where((i) {
      final stage = weapon!['stages'][i];
      final state =
          int.tryParse('${stage['state'] ?? ''}') ?? (stage['stage'] as int);
      return showOtherActions ||
          (state >= 2000 && state < 3000) ||
          state <= 6 ||
          stage['supported'] == true;
    }).toList();
    final applied = data?['applied']['${weapon?['id']}'] as List? ?? [];
    return PopScope(
      canPop: !dirty && !busy,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || busy) return;
        if (await discard() && mounted) {
          setState(() => dirty = false);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.pop(context);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('武器配置'),
          actions: [
            TextButton.icon(
              onPressed: busy
                  ? null
                  : () async {
                      if (await discard() && mounted) {
                        setState(() {
                          dirty = false;
                          busy = true;
                          message = '';
                        });
                        await load();
                      }
                    },
              icon: const Icon(Icons.refresh),
              label: const Text('重新读取'),
            ),
          ],
        ),
        body: Column(
          children: [
            if (busy) const LinearProgressIndicator(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 260,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: '搜索武器名称 / 编号',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) => setState(() => query = value),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: weapons.length,
                            itemBuilder: (context, index) {
                              final value = weapons[index];
                              return ListTile(
                                selected: weapon?['id'] == value['id'],
                                title: Text(value['name']),
                                subtitle: Text(
                                  '${value['id']} · ${(value['stages'] as List).length} 个招式',
                                ),
                                onTap: busy
                                    ? null
                                    : () async {
                                        if (value['id'] == weapon?['id']) {
                                          return;
                                        }
                                        if (await discard() && mounted) {
                                          setState(() {
                                            select(
                                              Map<String, dynamic>.from(value),
                                            );
                                            message = '';
                                          });
                                        }
                                      },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: weapon == null
                        ? Center(child: Text(busy ? '读取武器动作配置…' : '没有可读取的武器'))
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weapon!['name']} · 连招与命中效果',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  applied.isEmpty
                                      ? '当前游戏配置：原效果'
                                      : '当前游戏配置：已写入 ${applied.length} 段效果；需重启游戏加载',
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '命中目标时施加所选状态，替换该段原有异常状态；可分别设置各命中的基础伤害和攻击效果，保持原连招顺序。\n持续周期使用客户端原生数值（默认 3000），尚未验证与秒数的换算；多次命中的招式可能重复施加。',
                                ),
                                if ((weapon!['combos'] as List? ?? []).isEmpty)
                                  const Text(
                                    '当前配置包未找到该武器独立连招提示，已读取完整动作表。标有“动画说明”的文字来自原资源注释，不代表完整按键或正式招式名；共享动作可能保留其他武器的名称。',
                                  ),
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    '显示移动、受击等其他动作（共 ${rules.length} 项）',
                                  ),
                                  value: showOtherActions,
                                  onChanged: busy
                                      ? null
                                      : (v) => setState(
                                          () => showOtherActions = v ?? false,
                                        ),
                                ),
                                if ((weapon!['combos'] as List? ?? [])
                                    .isNotEmpty)
                                  ExpansionTile(
                                    title: const Text('该武器默认连招'),
                                    initiallyExpanded: true,
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        child: ListView(
                                          children: [
                                            for (final combo
                                                in (weapon!['combos']
                                                        as List? ??
                                                    []))
                                              ListTile(
                                                dense: true,
                                                title: Text(combo['name']),
                                                subtitle: Text(
                                                  (combo['nodes'] as List)
                                                      .map((n) => n['keys'])
                                                      .join(' → '),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                if (weapon!['id'] == 253013)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: busy
                                          ? null
                                          : () => setState(() {
                                              editorVersion++;
                                              for (final r in rules) {
                                                r['buff'] = r['stage'] == 1
                                                    ? 1
                                                    : r['stage'] == 2
                                                    ? 37
                                                    : 0;
                                                r['level'] = 1;
                                                r['duration'] = 3000;
                                              }
                                              dirty = true;
                                            }),
                                      icon: const Icon(Icons.auto_fix_high),
                                      label: const Text('填入示例：第一下中毒，第二下燃烧'),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Form(
                                    key: form,
                                    child: ListView.builder(
                                      itemCount: visibleStages.length,
                                      itemBuilder: (context, visibleIndex) {
                                        final index =
                                            visibleStages[visibleIndex];
                                        final rule = rules[index],
                                            stage = weapon!['stages'][index];
                                        final enabled =
                                            stage['supported'] == true && !busy;
                                        return Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  stage['label'] ??
                                                      '第 ${rule['stage']} 下 C',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                Text(
                                                  '状态 ${stage['state'] ?? rule['stage']} · 动作 ${stage['action']} · ${stage['property_ids'].length} 个命中属性',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                if (stage['supported'] != true)
                                                  Text(
                                                    stage['reason'],
                                                    style: const TextStyle(
                                                      color: Colors.deepOrange,
                                                    ),
                                                  ),
                                                ...hitEditors(
                                                  stage,
                                                  rule,
                                                  enabled,
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: DropdownButtonFormField<int>(
                                                        isExpanded: true,
                                                        key: ValueKey(
                                                          '${weapon!['id']}-${rule['stage']}-buff-${rule['buff']}',
                                                        ),
                                                        initialValue:
                                                            rule['buff'],
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText: '命中效果',
                                                            ),
                                                        items: (data!['buffs'] as List)
                                                            .map(
                                                              (b) =>
                                                                  DropdownMenuItem<
                                                                    int
                                                                  >(
                                                                    value:
                                                                        b['id'],
                                                                    child: Text(
                                                                      b['name'],
                                                                    ),
                                                                  ),
                                                            )
                                                            .toList(),
                                                        onChanged: enabled
                                                            ? (v) => setState(
                                                                () {
                                                                  rule['buff'] =
                                                                      v;
                                                                  dirty = true;
                                                                },
                                                              )
                                                            : null,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: DropdownButtonFormField<int>(
                                                        isExpanded: true,
                                                        key: ValueKey(
                                                          '${weapon!['id']}-${rule['stage']}-level-${rule['level']}',
                                                        ),
                                                        initialValue:
                                                            rule['level'],
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText: '等级',
                                                            ),
                                                        items: [1, 2, 3]
                                                            .map(
                                                              (v) =>
                                                                  DropdownMenuItem(
                                                                    value: v,
                                                                    child: Text(
                                                                      '$v',
                                                                    ),
                                                                  ),
                                                            )
                                                            .toList(),
                                                        onChanged:
                                                            enabled &&
                                                                rule['buff'] !=
                                                                    0
                                                            ? (
                                                                v,
                                                              ) => setState(() {
                                                                rule['level'] =
                                                                    v;
                                                                dirty = true;
                                                              })
                                                            : null,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      flex: 2,
                                                      child: TextFormField(
                                                        key: ValueKey(
                                                          '$editorVersion-${rule['stage']}-duration',
                                                        ),
                                                        initialValue:
                                                            '${rule['duration']}',
                                                        enabled:
                                                            enabled &&
                                                            rule['buff'] != 0,
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText:
                                                                  '持续周期（原生值）',
                                                            ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (v) {
                                                          final n =
                                                              int.tryParse(
                                                                v ?? '',
                                                              );
                                                          return n == null ||
                                                                  n < 1 ||
                                                                  n > 60000
                                                              ? '请输入 1–60000'
                                                              : null;
                                                        },
                                                        onChanged: (v) =>
                                                            setState(() {
                                                              rule['duration'] =
                                                                  int.tryParse(
                                                                    v,
                                                                  ) ??
                                                                  0;
                                                              dirty = true;
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: busy
                                          ? null
                                          : () => execute('weapon_save'),
                                      icon: const Icon(Icons.save_outlined),
                                      label: const Text('保存方案'),
                                    ),
                                    FilledButton.icon(
                                      onPressed: busy
                                          ? null
                                          : () => execute('weapon_apply'),
                                      icon: const Icon(Icons.check),
                                      label: const Text('应用到游戏'),
                                    ),
                                    TextButton(
                                      onPressed: busy || applied.isEmpty
                                          ? null
                                          : () => execute('weapon_restore'),
                                      child: const Text('恢复原效果'),
                                    ),
                                    if (dirty)
                                      const Text(
                                        '有未保存修改',
                                        style: TextStyle(
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            if (message.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                color: failed ? Colors.red.shade50 : Colors.teal.shade50,
                child: SelectableText(
                  message,
                  style: TextStyle(
                    color: failed ? Colors.red.shade900 : Colors.teal.shade900,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
