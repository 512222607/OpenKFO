import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeaponConfigPage extends StatefulWidget {
  const WeaponConfigPage({super.key, required this.api});
  final Future<dynamic> Function(Map<String, dynamic>) api;
  @override
  State<WeaponConfigPage> createState() => _WeaponConfigPageState();
}

class _WeaponConfigPageState extends State<WeaponConfigPage> {
  Map<String, dynamic>? data, weapon;
  Map<String, dynamic> _clientInfo = {};
  final form = GlobalKey<FormState>();
  List<Map<String, dynamic>> rules = [];
  String query = '', message = '';
  String weaponType = '全部类型';
  bool busy = true, dirty = false, failed = false;
  String? selectedAction;
  int editorVersion = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load({int? prefer}) async {
    try {
      final result = Map<String, dynamic>.from(
        await widget.api({'operation': 'weapon_catalog'}),
      );
      Map<String, dynamic> client = {};
      try {
        client = Map<String, dynamic>.from(
          await widget.api({'operation': 'client_directory_get'}),
        );
      } catch (_) {
        // The card falls back to whatever was shown before.
      }
      if (!mounted) return;
      setState(() {
        data = result;
        if (client.isNotEmpty) _clientInfo = client;
        final weapons = (data!['weapons'] as List);
        final selected = weapons.where(
          (w) => w['id'] == (prefer ?? weapon?['id'] ?? 253013),
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

  /// Self-made weapons registered in settings.json, keyed by weapon id.
  /// They exist only as rows injected into item.txt / itemact.txt, so the
  /// client binary stays untouched.
  Map<String, dynamic> get created =>
      Map<String, dynamic>.from(data?['created'] as Map? ?? const {});

  bool isCreated(dynamic id) => created.containsKey('$id');

  /// The registered blueprint behind a self-made weapon, empty for shipped ones.
  Map<String, dynamic> blueprintOf(dynamic id) {
    final value = created['$id'];
    return value is Map ? Map<String, dynamic>.from(value) : const {};
  }

  /// Combo completions recorded in settings.json: weapon id -> reference weapon.
  Map<String, dynamic> get comboFixes =>
      Map<String, dynamic>.from(data?['combos'] as Map? ?? const {});

  int? comboDonorOf(dynamic id) {
    final value = comboFixes['$id'];
    if (value == null) return null;
    return value is int ? value : int.tryParse('$value');
  }

  String weaponName(int id) {
    for (final w in (data?['weapons'] as List? ?? [])) {
      if (w['id'] == id) return '${w['name']}';
    }
    return '$id';
  }

  /// The client this editor reads and writes, plus the server config files that
  /// validate its config.spf2. Loaded separately so switching clients is
  /// reflected without reloading the whole catalogue.
  Map<String, dynamic> get clientInfo => _clientInfo;

  /// config.spf2 digest as the game server sees it — the value to put into the
  /// server's config.json `config_hash`.
  String get clientConfigHash => '${_clientInfo['config_hash'] ?? ''}';

  Future<void> reloadClient() async {
    try {
      final result = Map<String, dynamic>.from(
        await widget.api({'operation': 'client_directory_get'}),
      );
      if (mounted) setState(() => _clientInfo = result);
    } catch (_) {
      // The card simply keeps the previous picture.
    }
  }

  Future<void> chooseClient(/* optional initial pick */) async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => _ClientPickerDialog(
        current: '${_clientInfo['directory'] ?? ''}',
        detected: [
          for (final value in (_clientInfo['detected'] as List? ?? []))
            Map<String, dynamic>.from(value as Map),
        ],
      ),
    );
    if (picked == null || picked.isEmpty || !mounted) return;
    final prefer = weapon?['id'] as int?;
    setState(() {
      busy = true;
      failed = false;
      message = '正在切换客户端…';
    });
    try {
      final result = await widget.api({
        'operation': 'client_directory_set',
        'directory': picked,
      });
      if (!mounted) return;
      setState(() {
        busy = false;
        _clientInfo = Map<String, dynamic>.from(result is Map ? result : {});
        message = '${(result as Map)['message'] ?? '已切换客户端'}';
      });
      await load(prefer: prefer);
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

    Future<void> rebaseClient() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('按当前客户端配置重新采集基线'),
        content: const Text(
          '把客户端现在的 config.spf2 记为新的基线，之后的编辑都以它为准。\n\n'
          '只在客户端被别的程序改过（例如它自己的更新器）而我们手上还是旧基线时才需要这样做。'
          '旧基线会另存一份备份。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('重新采集'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final prefer = weapon?['id'] as int?;
    setState(() {
      busy = true;
      failed = false;
      message = '正在重新采集基线…';
    });
    try {
      final result = await widget.api({'operation': 'weapon_client_rebase'});
      if (!mounted) return;
      setState(() {
        busy = false;
        message = '${(result as Map)['message'] ?? '已重新采集基线'}';
      });
      await load(prefer: prefer);
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

  /// The dialog works with the *value* of item.txt column 2, while the
  /// catalogue exposes the human label. Map back through the same table.
  String typeValueFor(String label) {
    for (final type in (data?['types'] as List? ?? [])) {
      if ('${type['label']}' == label) return '${type['value']}';
    }
    return '';
  }

  /// Weapons that can act as a donor: everything the client already ships.
  List<Map<String, dynamic>> get donors => [
    for (final w in (data?['weapons'] as List? ?? []))
      if (!isCreated(w['id'])) Map<String, dynamic>.from(w as Map),
  ];

  /// Every id already claimed by item.txt, including ids that carry no action
  /// row. Authoritative set for the reserved-range picker.
  List<int> get usedIDs {
    final ids = data?['used_ids'] as List?;
    if (ids != null) return [for (final id in ids) id as int];
    return [for (final w in (data?['weapons'] as List? ?? [])) w['id'] as int];
  }

  /// Lowest unused id in the reserved self-made range.
  int suggestID() {
    final low = data?['blueprint_min'] as int? ?? 253000;
    final high = data?['blueprint_max'] as int? ?? 253999;
    final used = usedIDs.toSet();
    for (var id = low; id <= high; id++) {
      if (!used.contains(id)) return id;
    }
    return low;
  }

  List<Map<String, String>> comboChain = [];

  Future<void> refreshChain(dynamic weaponId) async {
    try {
      final result = Map<String, dynamic>.from(
        await widget.api({'operation': 'weapon_combo_chain', 'weapon': weaponId}),
      );
      if (!mounted) return;
      setState(() {
        comboChain = [
          for (final e in (result['chain'] as List? ?? []))
            Map<String, String>.from(e as Map),
        ];
      });
    } catch (_) {
      if (mounted) {
        setState(() => comboChain = []);
      }
    }
  }

  /// 连招链：按「老状态」分组展示 delayacttable.xml 的状态转移。
  Widget comboChainCard() {
    if (comboChain.isEmpty) return const SizedBox.shrink();
    final byOld = <String, List<Map<String, String>>>{};
    final order = <String>[];
    for (final e in comboChain) {
      final o = e['old']!;
      if (!byOld.containsKey(o)) {
        byOld[o] = [];
        order.add(o);
      }
      byOld[o]!.add(e);
    }
    order.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_tree_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  '连招链 · ${comboChain.length} 条转移',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '来自 delayacttable.xml：站在左侧状态上按下对应键，就切到右侧状态',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final o in order) comboChainGroup(o, byOld[o]!),
          ],
        ),
      ),
    );
  }

  Widget comboChainGroup(String from, List<Map<String, String>> edges) {
    final fromLabel = edges.first['old_label']!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 210,
            child: Text(
              fromLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final e in edges) comboEdgeChip(e),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget comboEdgeChip(Map<String, String> edge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${edge['key_label']} → ${edge['new_label']}',
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }


  void select(Map<String, dynamic> value) {
    editorVersion++;
    selectedAction = null;
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
    refreshChain(value['id']);
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
          title: Text(operation == 'weapon_apply' ? '应用到游戏' : '恢复原效果'),
          content: Text(
            operation == 'weapon_apply'
                ? '将应用「${weapon!['name']}」当前配置的招式伤害、BUFF 和受击效果。修改对使用此客户端的角色生效，不限当前账号。\n\n'
                    '写入 ${_clientInfo['directory'] ?? '当前客户端'}；写前自动备份。\n\n'
                    '请先退出游戏。重启后加载，实战效果尚待验证。'
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

  Future<void> publish() async {
    if (!(form.currentState?.validate() ?? false)) return;
    var notes = '${weapon!['name']}：';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更新到线上'),
        content: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '发布全部已保存的武器方案及当前编辑内容。将重启线上服务器，在线玩家会断开；玩家下次启动游戏时下载更新。不会覆盖本地客户端。',
              ),
              const SizedBox(height: 14),
              TextFormField(
                initialValue: notes,
                onChanged: (value) => notes = value,
                minLines: 4,
                maxLines: 8,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: '给玩家看的更新说明（武器名称、改动内容）',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (notes.trim().isNotEmpty) Navigator.pop(context, true);
            },
            child: const Text('发布到线上'),
          ),
        ],
      ),
    );
    final text = notes.trim();
    if (confirmed != true || !mounted) return;
    setState(() {
      busy = true;
      failed = false;
      message = '正在生成、上传并启用线上配置，请勿重复发布…';
    });
    try {
      final result = await widget.api({
        'operation': 'weapon_publish',
        'environment': 'online',
        'weapon': weapon!['id'],
        'rules': rules,
        'revision': data!['revision'],
        'notes': text,
      });
      if (!mounted) return;
      setState(() {
        message = result['message'];
        dirty = false;
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

  Future<void> createWeapon() async {
    if (!(await discard()) || !mounted) return;
    final blueprint = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _BlueprintDialog(
        types: [for (final t in (data?['types'] as List? ?? [])) t],
        models: [for (final m in (data?['models'] as List? ?? [])) '$m'],
        donors: donors,
        minID: data?['blueprint_min'] as int? ?? 253000,
        maxID: data?['blueprint_max'] as int? ?? 253999,
        suggestedID: suggestID(),
        usedIDs: {
          for (final id in usedIDs) '$id',
        },
      ),
    );
    if (blueprint == null || !mounted) return;
    setState(() {
      busy = true;
      failed = false;
      message = '正在登记自建武器…';
    });
    try {
      final result = await widget.api({
        'operation': 'weapon_create',
        'blueprint': blueprint,
      });
      if (!mounted) return;
      setState(() {
        dirty = false;
        message = '${result['message']}';
      });
      await load(prefer: blueprint['id'] as int);
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

  Future<void> forget() async {
    if (!(await discard()) || !mounted) return;
    final id = weapon!['id'];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除自建武器'),
        content: Text(
          '将从编辑清单中移除「${weapon!['name']}」（$id）及其已保存的效果方案。\n\n'
          '已写入客户端的配置不会自动回滚：请再点一次「应用到游戏」，自建武器才会从配置包中消失。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('移除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      busy = true;
      failed = false;
      message = '正在移除自建武器…';
    });
    try {
      final result = await widget.api({
        'operation': 'weapon_forget',
        'weapon': id,
      });
      if (!mounted) return;
      setState(() {
        dirty = false;
        message = '${result['message']}';
      });
      await load(prefer: 253013);
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

  /// Registers (or clears) a combo-table completion for the current weapon.
  /// A donor of 0 clears it.
  Future<void> setCombo(int donor) async {
    if (!(await discard()) || !mounted) return;
    final id = weapon!['id'];
    setState(() {
      busy = true;
      failed = false;
      message = donor == 0 ? '正在取消连招补齐…' : '正在登记连招补齐…';
    });
    try {
      final result = await widget.api({
        'operation': 'weapon_combo',
        'weapon': id,
        'donor': donor,
      });
      if (!mounted) return;
      setState(() {
        dirty = false;
        message = '${result['message']}';
      });
      await load(prefer: id);
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

  Future<void> pickComboDonor() async {
    if (!(await discard()) || !mounted) return;
    final id = weapon!['id'];
    final suggested = weapon!['combo_suggestion'] as int? ?? 0;
    final donor = await showDialog<int>(
      context: context,
      builder: (_) => _ComboDonorDialog(
        candidates: [
          for (final w in (data?['weapons'] as List? ?? []))
            if ((w['combo_rows'] as int? ?? 0) > 0 && w['id'] != id)
              Map<String, dynamic>.from(w as Map),
        ],
        suggested: suggested,
      ),
    );
    if (donor == null || !mounted) return;
    await setCombo(donor);
  }

  String buffName(dynamic id) {
    final value = int.tryParse('$id') ?? 0;
    if (value == 0) return '无';
    for (final b in (data?['buffs'] as List? ?? [])) {
      if (b['id'] == value) return '${b['name']}';
    }
    return '异常状态 $value（名称未收录）';
  }

  String reactionChoice(dynamic hit, Map<String, dynamic> rule) {
    final original = Map<String, dynamic>.from(hit['values']);
    final current = {...original, ...?rule['properties']?[hit['id']] as Map?};
    final fields = (data?['fields'] as List? ?? []).where(
      (f) => f['key'] != 'SkillDamage' && f['key'] != 'SkillEnhanceDamage',
    );
    if (fields.every((f) => '${current[f['key']]}' == '${original[f['key']]}')) {
      return 'original';
    }
    for (final e in (data?['effects'] as List? ?? [])) {
      if ((e['values'] as Map).entries.every(
        (v) => '${current[v.key]}' == '${v.value}',
      )) {
        return e['id'];
      }
    }
    return 'custom';
  }

  String originalReaction(dynamic hit) {
    final v = hit['values'];
    if ('${v['TripTarget']}' == '1') return '击倒';
    if ('${v['TargetFlurr']}' == '1' && '${v['StandHurtFly']}' == '11') {
      return '上升 / 悬浮';
    }
    if ('${v['RepulseTarget']}' == '1') return '击退';
    return '原受击动作';
  }

  String originalDebuff(dynamic stage) {
    final names = <String>{
      for (final h in (stage['hits'] as List? ?? [])) buffName(h['buff']),
    };
    return names.isEmpty ? '无' : names.join(' / ');
  }

  Widget numberEditors(
    dynamic hit,
    Map<String, dynamic> rule,
    bool enabled, {
    required bool damage,
  }) => Padding(
    padding: const EdgeInsets.all(8),
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final field in (data?['fields'] as List? ?? []).where(
          (f) =>
              damage ==
              ['SkillDamage', 'SkillEnhanceDamage'].contains(f['key']),
        ))
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
                helperText: '默认 ${hit['values'][field['key']]}',
              ),
              keyboardType: TextInputType.number,
              validator: (text) {
                final v = num.tryParse(text ?? '');
                return v == null ||
                        !v.isFinite ||
                        v < field['min'] ||
                        v > field['max'] ||
                        (!damage &&
                            (v != v.roundToDouble() ||
                                ((weapon?['allowed_values']?[field['key']]
                                            as List?)
                                        ?.contains(v.toInt()) ==
                                    false)))
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
  );

  List<Widget> hitEditors(
    dynamic stage,
    Map<String, dynamic> rule,
    bool enabled,
  ) {
    return [
      for (final hit in (stage['hits'] as List? ?? []))
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((stage['hits'] as List).length > 1)
              Text('命中 ${(stage['hits'] as List).indexOf(hit) + 1}'),
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButtonFormField<String>(
                key: ValueKey(
                  '$editorVersion-${rule['stage']}-${hit['id']}-${reactionChoice(hit, rule)}-effect',
                ),
                isExpanded: true,
                initialValue: reactionChoice(hit, rule),
                decoration: const InputDecoration(labelText: '受击动作'),
                items: [
                  DropdownMenuItem(
                    value: 'original',
                    child: Text('默认（${originalReaction(hit)}）'),
                  ),
                  if (reactionChoice(hit, rule) == 'custom')
                    const DropdownMenuItem(
                      value: 'custom',
                      enabled: false,
                      child: Text('自定义受击动作'),
                    ),
                  for (final effect in (data?['effects'] as List? ?? []))
                    DropdownMenuItem(
                      value: effect['id'] as String,
                      child: Text(
                        effect['id'] == 'float' ? '上升 / 悬浮' : effect['name'],
                      ),
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
            numberEditors(hit, rule, enabled, damage: true),
            ExpansionTile(
              title: const Text('击飞参数 / 高级设置'),
              children: [numberEditors(hit, rule, enabled, damage: false)],
            ),
          ],
        ),
    ];
  }

  Map<String, dynamic> get remaps =>
      Map<String, dynamic>.from(data?['remaps'] as Map? ?? const {});

  Map<String, dynamic> remapFor(String state) {
    final per = remaps['${weapon!['id']}'];
    final value = per is Map ? per[state] : null;
    return value is Map ? Map<String, dynamic>.from(value) : const {};
  }

  /// 复用模板：把另一把武器某个状态的动作与命中属性复制到本段。
  Future<void> remapFromTemplate(String stateKey) async {
    final picked = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _RemapTemplateDialog(
        weapons: [
          for (final w in (data?['weapons'] as List? ?? []))
            Map<String, dynamic>.from(w as Map),
        ],
        self: weapon!['id'] as int,
      ),
    );
    if (picked == null || !mounted) return;
    await _callRemap(
      stateKey,
      params: {
        'operation': 'weapon_remap',
        'weapon': weapon!['id'],
        'stage': int.parse(stateKey),
        'template_weapon': picked['weapon'],
        'template_stage': picked['state'],
      },
      busyText: '正在复用动作与命中属性…',
    );
  }

  /// 新增命中属性节点：克隆一个模板节点到全新编号，再指定给本段。
  Future<void> addPropertyFor(String stateKey) async {
    Map<String, dynamic> catalog = {};
    try {
      catalog = Map<String, dynamic>.from(
        await widget.api({'operation': 'weapon_remap_options'}),
      );
    } catch (_) {}
    final properties = [
      for (final p in (catalog['properties'] as List? ?? []))
        Map<String, dynamic>.from(p as Map),
    ];
    final template = await showDialog<String>(
      context: context,
      builder: (_) => _PropertyPickerDialog(properties: properties),
    );
    if (template == null || !mounted) return;
    final prefer = weapon!['id'] as int?;
    setState(() {
      busy = true;
      failed = false;
      message = '正在新增命中属性节点…';
    });
    try {
      final result = Map<String, dynamic>.from(
        await widget.api({'operation': 'weapon_property_add', 'template': template}),
      );
      final newId = '${result['property_id'] ?? ''}';
      if (!mounted) return;
      if (newId.isEmpty) {
        setState(() {
          busy = false;
          failed = true;
          message = '${result['message'] ?? '新增失败'}';
        });
        return;
      }
      final remap = Map<String, dynamic>.from(await widget.api({
        'operation': 'weapon_remap',
        'weapon': weapon!['id'],
        'stage': int.parse(stateKey),
        'property_id': newId,
      }));
      if (!mounted) return;
      setState(() {
        busy = false;
        message = '${remap['message'] ?? '已指定命中属性'}';
      });
      await load(prefer: prefer);
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

  Future<void> clearRemap(String stateKey) async {
    await _callRemap(
      stateKey,
      params: {
        'operation': 'weapon_remap',
        'weapon': weapon!['id'],
        'stage': int.parse(stateKey),
      },
      busyText: '正在取消重映射…',
    );
  }

  Future<void> _callRemap(
    String stateKey, {
    required Map<String, dynamic> params,
    required String busyText,
  }) async {
    final prefer = weapon!['id'] as int?;
    setState(() {
      busy = true;
      failed = false;
      message = busyText;
    });
    try {
      final result = Map<String, dynamic>.from(await widget.api(params));
      if (!mounted) return;
      setState(() {
        busy = false;
        message = '${result['message'] ?? '已更新'}';
      });
      await load(prefer: prefer);
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

  /// 结构重映射区块：复用模板 / 新增命中属性节点 / 取消。
  Widget remapSection(int index, Map<String, dynamic> stage) {
    final stateKey = '${stage['state']}';
    final remap = remapFor(stateKey);
    final hasRemap = remap.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '动作与命中属性（重映射）',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 4),
          if (hasRemap)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '已重映射 → 动作 ${remap['action'] ?? '-'} · 命中属性 ${remap['property_id'] ?? '（沿用动作自带）'}',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: Colors.teal,
                ),
              ),
            ),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              OutlinedButton.icon(
                onPressed: busy ? null : () => remapFromTemplate(stateKey),
                icon: const Icon(Icons.content_copy, size: 16),
                label: const Text('复用模板（武器→状态）'),
              ),
              OutlinedButton.icon(
                onPressed: busy ? null : () => addPropertyFor(stateKey),
                icon: const Icon(Icons.add_box_outlined, size: 16),
                label: const Text('新增命中属性节点'),
              ),
              if (hasRemap)
                TextButton(
                  onPressed: busy ? null : () => clearRemap(stateKey),
                  child: const Text('取消重映射'),
                ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            '复用模板会把所选武器该状态的动作与命中属性一并复制过来；若目标动作被其它武器共用会自动克隆隔离。'
            '新增命中属性节点会先按模板复制一个全新编号的节点，再指定给本段（之后可在下方改伤害/BUFF）。',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }


  Widget stageEditor(int index) {
    final rule = rules[index], stage = weapon!['stages'][index];
    final enabled = stage['supported'] == true && !busy;
    return Card(
      key: ValueKey("$editorVersion-${weapon!['id']}-${rule['stage']}"),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stage['label'] ?? '动作说明缺失（按键待核实）',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 2),
            Text(
              stageIdentity(index),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.black54,
              ),
            ),
            if (stage['supported'] != true)
              Text(
                stage['reason'],
                style: const TextStyle(color: Colors.deepOrange),
              ),
            const SizedBox(height: 8),
            remapSection(index, Map<String, dynamic>.from(stage as Map)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    key: ValueKey(
                      '${weapon!['id']}-${rule['stage']}-buff-${rule['buff']}',
                    ),
                    initialValue: rule['buff'],
                    decoration: const InputDecoration(labelText: 'DEBUFF'),
                    items: (data!['buffs'] as List)
                        .map(
                          (b) => DropdownMenuItem<int>(
                            value: b['id'],
                            child: Text(
                              b['id'] == 0
                                  ? '默认（${originalDebuff(stage)}）'
                                  : b['name'],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: enabled
                        ? (v) => setState(() {
                            rule['buff'] = v;
                            dirty = true;
                          })
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
                    initialValue: rule['level'],
                    decoration: const InputDecoration(labelText: '等级'),
                    items: [1, 2, 3]
                        .map(
                          (v) => DropdownMenuItem(value: v, child: Text('$v')),
                        )
                        .toList(),
                    onChanged: enabled && rule['buff'] != 0
                        ? (v) => setState(() {
                            rule['level'] = v;
                            dirty = true;
                          })
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    key: ValueKey('$editorVersion-${rule['stage']}-duration'),
                    initialValue: '${rule['duration']}',
                    enabled: enabled && rule['buff'] != 0,
                    decoration: const InputDecoration(labelText: '持续周期（原生值）'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      return n == null || n < 1 || n > 60000
                          ? '请输入 1–60000'
                          : null;
                    },
                    onChanged: (v) => setState(() {
                      rule['duration'] = int.tryParse(v) ?? 0;
                      dirty = true;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...hitEditors(stage, rule, enabled),
          ],
        ),
      ),
    );
  }

  /// The 4-digit action state and the action (skill) id it resolves to. The
  /// state is what delayacttable.xml transitions on; the action id is what
  /// itemact.txt points at, and both are what you need when cross-checking the
  /// tables by hand.
  String stageIdentity(int? index) {
    if (index == null || index < 0 || index >= (weapon!['stages'] as List).length) {
      return '';
    }
    final stage = weapon!['stages'][index];
    final ids = (stage['property_ids'] as List? ?? []).join('、');
    return '状态 ${stage['state']} · 动作 ${stage['action']}'
        '${ids.isEmpty ? '' : ' · 命中属性 $ids'}';
  }

  Widget actionChoice(String key, int? index, String label) {
    return Column(
      children: [
        ListTile(
          title: Text(label),
          subtitle: index == null
              ? const Text('提示中的状态没有对应动作，不能编辑')
              : Text(
                  stageIdentity(index),
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
          selected: selectedAction == key,
          trailing: index == null ? null : const Icon(Icons.edit_outlined),
          onTap: index == null || busy
              ? null
              : () {
                  if (!(form.currentState?.validate() ?? true)) return;
                  setState(() {
                    selectedAction = selectedAction == key ? null : key;
                  });
                },
        ),
        if (selectedAction == key && index != null) stageEditor(index),
      ],
    );
  }

  Widget weaponIcon(Map<dynamic, dynamic> value, double size) {
    final path = '${value['icon'] ?? ''}';
    final fallback = Icon(Icons.sports_martial_arts, size: size * .6);
    return SizedBox(
      width: size,
      height: size,
      child: path.isEmpty
          ? fallback
          : Image.file(
              File(path),
              fit: BoxFit.contain,
              errorBuilder: (_, error, stack) => fallback,
            ),
    );
  }

  /// Page-level strip: which client this editor works on and its full
  /// config.spf2 SHA-256. Only the current client's id is shown — comparing it
  /// against the server's stored value was noise.
  Widget clientStrip() {
    if (_clientInfo.isEmpty) return const SizedBox.shrink();
    final directory = '${_clientInfo['directory'] ?? ''}';
    final hash = clientConfigHash;
    final baselineState = '${(data?['client'] as Map?)?['state'] ?? ''}';
    final rebaseNeeded = baselineState == '有差异' ||
        baselineState == '未采集基线' ||
        baselineState == '客户端缺失';
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_open, size: 16),
                const SizedBox(width: 6),
                const Text(
                  '客户端',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: SelectableText(
                    directory,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (baselineState.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  baselineChip(baselineState),
                ],
                if (rebaseNeeded) ...[
                  const SizedBox(width: 4),
                  Text(
                    baselineState == '客户端缺失'
                        ? '没有 Data/config.spf2，无法写入'
                        : '与手上的基线不一致',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepOrange.shade800,
                    ),
                  ),
                  TextButton(
                    onPressed: busy ? null : rebaseClient,
                    child: const Text('重新采集基线',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: busy ? null : chooseClient,
                  icon: const Icon(Icons.swap_horiz, size: 16),
                  label: const Text('更换客户端'),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 22),
                const Text(
                  'config.spf2 SHA-256',
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    hash.isEmpty ? '(读不到)' : hash,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  ),
                ),
                TextButton.icon(
                  onPressed: hash.isEmpty ? null : () => copyConfigHash(hash),
                  icon: const Icon(Icons.copy, size: 14),
                  label: const Text('复制', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> copyConfigHash(String hash) async {
    await Clipboard.setData(ClipboardData(text: hash));
    if (mounted) {
      setState(() => message = '已复制 config.spf2 的完整 SHA-256');
    }
  }

  Widget baselineChip(String state) {
    late final Color color;
    if (state == '已同步') {
      color = Colors.teal.shade700;
    } else if (state == '未写入') {
      color = Colors.blueGrey.shade600;
    } else {
      color = Colors.deepOrange.shade700;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(state, style: TextStyle(fontSize: 12, color: color)),
    );
  }

  /// Warns about weapons the client will refuse to chain.
  ///
  /// itemact.txt only names the animation for each state; the state machine
  /// that turns a key press into the next state lives in delayacttable.xml.
  /// Several shipped weapons (混沌宇宙, D眩晕之锤, 无名剑 …) copy another
  /// weapon's action row but were never registered there, so they look complete
  /// in this editor yet cannot combo in game. The fix is to borrow the
  /// transitions of the weapon whose action row they copied.
  Widget comboBanner() {
    final id = weapon!['id'];
    final rows = weapon!['combo_rows'] as int? ?? 0;
    final registered = comboDonorOf(id);
    if (rows > 0 && registered == null) return const SizedBox.shrink();

    final suggested = weapon!['combo_suggestion'] as int? ?? 0;
    final reference = registered ?? suggested;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: registered == null ? Colors.orange.shade50 : Colors.teal.shade50,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    registered == null ? Icons.link_off : Icons.link,
                    size: 18,
                    color: registered == null
                        ? Colors.deepOrange.shade800
                        : Colors.teal.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      registered == null
                          ? '缺少连招表：进游戏后只能出第一段，按键不会推进到下一段'
                          : '连招表已补齐：借用「${weaponName(reference)}」的 $rows 条转移',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: registered == null
                            ? Colors.deepOrange.shade900
                            : Colors.teal.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              if (registered == null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '动作行（itemact.txt）只决定每段放哪个动画，能否连到下一段由 delayacttable.xml 的状态机决定。'
                    '${suggested > 0 ? '这把武器的动作行与「${weaponName(suggested)}」一致，可以直接借用它的连招。' : ''}'
                    '补齐后需「应用到游戏」并重启客户端才生效。',
                    style: const TextStyle(fontSize: 12, height: 1.6),
                  ),
                ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (registered == null && suggested > 0)
                    FilledButton.tonalIcon(
                      onPressed: busy ? null : () => setCombo(suggested),
                      icon: const Icon(Icons.auto_fix_high, size: 18),
                      label: Text('借用「${weaponName(suggested)}」的连招'),
                    ),
                  if (registered == null)
                    OutlinedButton.icon(
                      onPressed: busy ? null : pickComboDonor,
                      icon: const Icon(Icons.search, size: 18),
                      label: const Text('选择其它参考武器'),
                    ),
                  if (registered != null)
                    TextButton(
                      onPressed: busy ? null : () => setCombo(0),
                      child: const Text('取消连招补齐'),
                    ),
                  if (registered != null)
                    TextButton(
                      onPressed: busy ? null : pickComboDonor,
                      child: const Text('换一个参考武器'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allWeapons = data?['weapons'] as List? ?? [];
    final types =
        allWeapons.map((w) => '${w['type'] ?? '未分类'}').toSet().toList()..sort();
    final weapons = allWeapons
        .where(
          (w) =>
              '${w['name']} ${w['id']}'.contains(query.trim()) &&
              (weaponType == '全部类型' || '${w['type'] ?? '未分类'}' == weaponType),
        )
        .toList();
    final combos = weapon?['combos'] as List? ?? [];
    final stageIndices = <String, int>{
      for (var i = 0; i < rules.length; i++)
        '${weapon!['stages'][i]['state']}': i,
    };
    final mapped = {
      for (final c in combos)
        for (final n in c['nodes'] as List) '${n['state']}',
    };
    final otherStages = stageIndices.entries
        .where((e) => !mapped.contains(e.key))
        .map((e) => e.value)
        .toList();
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
              onPressed: busy || data == null ? null : createWeapon,
              icon: const Icon(Icons.add),
              label: const Text('新建武器'),
            ),
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
            clientStrip(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 300,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonFormField<String>(
                            key: ValueKey('weapon-type-$weaponType'),
                            initialValue:
                                ['全部类型', ...types].contains(weaponType)
                                ? weaponType
                                : '全部类型',
                            decoration: const InputDecoration(
                              labelText: '武器类型',
                            ),
                            items: ['全部类型', ...types]
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => weaponType = value ?? '全部类型'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('共 ${weapons.length} 件武器'),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: weapons.length,
                            itemBuilder: (context, index) {
                              final value = weapons[index];
                              return ListTile(
                                leading: weaponIcon(value, 40),
                                selected: weapon?['id'] == value['id'],
                                title: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${value['name']}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isCreated(value['id']))
                                      const Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: _SelfMadeBadge(),
                                      ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${value['type'] ?? '未分类'} · ${value['id']}\n${(value['stages'] as List).length} 个招式',
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
                                SizedBox(
                                  height: 130,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          weaponIcon(weapon!, 72),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${weapon!['name']}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                Text(
                                                  '${weapon!['type'] ?? '未分类'} · ${weapon!['id']}',
                                                ),
                                                if (isCreated(weapon!['id']))
                                                  Row(
                                                    children: [
                                                      const _SelfMadeBadge(),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          '复用模型 ${weapon!['model'] ?? '未知'} · 供体 ${blueprintOf(weapon!['id'])['donor'] ?? '未知'} · 连招随供体自动补齐',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodySmall,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                const SizedBox(height: 6),
                                                const Text(
                                                  '武器简介',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    key: ValueKey(
                                                      'weapon-description-${weapon!['id']}',
                                                    ),
                                                    child: SelectableText(
                                                      '${weapon!['description'] ?? ''}'
                                                              .trim()
                                                              .isEmpty
                                                          ? '暂无武器简介'
                                                          : '${weapon!['description']}',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                comboBanner(),
                                comboChainCard(),
                                Text(
                                  '连招与命中效果',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  applied.isEmpty
                                      ? '当前游戏配置：原效果'
                                      : '当前游戏配置：已写入 ${applied.length} 段效果；需重启游戏加载',
                                ),
                                const SizedBox(height: 8),
                                const Text('选择招式，设置 DEBUFF、受击动作和伤害。'),
                                if ((weapon!['combos'] as List? ?? []).isEmpty)
                                  const Text('未收录按键提示，按动作名称选择。'),
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
                                      itemCount:
                                          combos.length +
                                          (otherStages.isEmpty ? 0 : 1),
                                      itemBuilder: (context, group) {
                                        final other = group == combos.length;
                                        final combo = other
                                            ? null
                                            : combos[group];
                                        final nodes = other
                                            ? <dynamic>[]
                                            : combo['nodes'] as List;
                                        final title = other
                                            ? '动作说明（${otherStages.length}）'
                                            : nodes.isEmpty
                                            ? '按键提示不完整'
                                            : '${nodes.last['keys']}';
                                        return ExpansionTile(
                                          initiallyExpanded:
                                              other && combos.isEmpty,
                                          key: ValueKey(
                                            '${weapon!['id']}-combo-$group',
                                          ),
                                          title: Text(title),
                                          subtitle: Text(
                                            other
                                                ? '按动作名称选择'
                                                : '${combo['name']} · ${nodes.length} 个动作段',
                                          ),
                                          children: [
                                            for (
                                              var n = 0;
                                              n <
                                                  (other
                                                      ? otherStages.length
                                                      : nodes.length);
                                              n++
                                            )
                                              actionChoice(
                                                '$group:$n',
                                                other
                                                    ? otherStages[n]
                                                    : stageIndices['${nodes[n]['state']}'],
                                                other
                                                    ? '${weapon!['stages'][otherStages[n]]['label'] ?? '动作说明缺失（按键待核实）'}'
                                                    : '第 ${n + 1} 段 · ${nodes[n]['keys']}',
                                              ),
                                          ],
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
                                    if (isCreated(weapon!['id']))
                                      TextButton(
                                        onPressed: busy ? null : forget,
                                        child: const Text('移除自建武器'),
                                      ),
                                    FilledButton.tonalIcon(
                                      onPressed: busy ? null : publish,
                                      icon: const Icon(
                                        Icons.cloud_upload_outlined,
                                      ),
                                      label: const Text('更新到线上'),
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

/// Small tag shown next to weapons that only exist in the editor state.
class _SelfMadeBadge extends StatelessWidget {
  const _SelfMadeBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      color: Colors.teal.shade100,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      '自建',
      style: TextStyle(fontSize: 11, color: Colors.teal.shade900),
    ),
  );
}

/// Collects the fields needed to invent a weapon that the untouched client can
/// still draw.
///
/// A self-made weapon is a new row in item.txt plus a clone of an existing row
/// in itemact.txt, so it must borrow a RenderWare clump the client already
/// ships (we only add rows, we never add archives). The donor supplies the
/// per-stage animation ids that get cloned and isolated server side.
class _BlueprintDialog extends StatefulWidget {
  const _BlueprintDialog({
    required this.types,
    required this.models,
    required this.donors,
    required this.minID,
    required this.maxID,
    required this.suggestedID,
    required this.usedIDs,
  });

  final List types;
  final List<String> models;
  final List<Map<String, dynamic>> donors;
  final int minID, maxID, suggestedID;
  final Set<String> usedIDs;

  @override
  State<_BlueprintDialog> createState() => _BlueprintDialogState();
}

class _BlueprintDialogState extends State<_BlueprintDialog> {
  final form = GlobalKey<FormState>();
  late final TextEditingController number;
  late final TextEditingController name;
  final note = TextEditingController();
  String type = '';
  String? model;
  int? donor;
  String modelNotice = '';

  @override
  void initState() {
    super.initState();
    number = TextEditingController(text: '${widget.suggestedID}');
    name = TextEditingController();
    type = widget.types.isEmpty ? '1' : '${widget.types.first['value']}';
  }

  @override
  void dispose() {
    number.dispose();
    name.dispose();
    note.dispose();
    super.dispose();
  }

  String typeValueFor(String label) {
    for (final value in widget.types) {
      if ('${value['label']}' == label) return '${value['value']}';
    }
    return '';
  }

  /// Reusing the donor's appearance is the whole point: an unknown model name
  /// would leave the client rendering nothing.
  void adoptDonor(int? value) {
    setState(() {
      donor = value;
      modelNotice = '';
      if (value == null) return;
      final weapon = widget.donors.firstWhere((w) => w['id'] == value);
      final candidate = '${weapon['model'] ?? ''}';
      if (widget.models.contains(candidate)) {
        model = candidate;
      } else {
        // A handful of shipped weapons were re-skinned without keeping their
        // original clump, so their model column names a file the client no
        // longer has. Do not guess an appearance; ask the author to choose.
        modelNotice = '客户端没有 $candidate，请手动选择模型';
      }
      final mapped = typeValueFor('${weapon['type'] ?? ''}');
      if (mapped.isNotEmpty) type = mapped;
      if (name.text.trim().isEmpty) {
        name.text = '自建${weapon['name']}';
      }
    });
  }

  void submit() {
    if (!(form.currentState?.validate() ?? false)) return;
    Navigator.pop(context, <String, dynamic>{
      'id': int.tryParse(number.text.trim()) ?? 0,
      'name': name.text.trim(),
      'type': type,
      'model': model,
      'donor': donor,
      'note': note.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.donors]
      ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    final models = [...widget.models]..sort();
    return AlertDialog(
      title: const Text('新建武器（不改动客户端）'),
      content: SizedBox(
        width: 540,
        child: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '自建武器会在配置包里新增两行数据，并复用客户端已有的模型与动作，因此无需改动客户端。'
                  '编号使用预留区间，不影响原有武器。',
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 170,
                      child: TextFormField(
                        controller: number,
                        decoration: InputDecoration(
                          labelText: '武器编号',
                          helperText: '${widget.minID}–${widget.maxID}',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          final v = int.tryParse((text ?? '').trim());
                          if (v == null || v < widget.minID || v > widget.maxID) {
                            return '编号超出预留区间';
                          }
                          if (widget.usedIDs.contains('$v')) return '编号已被占用';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: '武器名称',
                          helperText: '1–24 字',
                        ),
                        validator: (text) {
                          final value = (text ?? '').trim();
                          if (value.isEmpty || value.runes.length > 24) {
                            return '名称需为 1–24 个字符';
                          }
                          if (value.contains('\t')) return '名称不能包含制表符';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  menuMaxHeight: 340,
                  initialValue: donor,
                  decoration: const InputDecoration(
                    labelText: '供体武器（复制其招式结构）',
                    helperText: '从客户端已有武器中选一件作为动作模板',
                  ),
                  items: [
                    for (final weapon in sorted)
                      DropdownMenuItem<int>(
                        value: weapon['id'] as int,
                        child: Text(
                          '${weapon['name']} · ${weapon['id']} · ${weapon['type'] ?? '未分类'}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: adoptDonor,
                  validator: (value) => value == null ? '请选择供体武器' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: type.isEmpty ? null : type,
                        decoration: const InputDecoration(labelText: '武器子类'),
                        items: [
                          for (final value in widget.types)
                            DropdownMenuItem<String>(
                              value: '${value['value']}',
                              child: Text('${value['label']}'),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => type = value ?? type),
                        validator: (value) =>
                            value == null || value.isEmpty ? '请选择子类' : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 230,
                      child: DropdownButtonFormField<String>(
                        key: ValueKey('blueprint-model-$model'),
                        isExpanded: true,
                        menuMaxHeight: 340,
                        initialValue: model,
                        decoration: const InputDecoration(
                          labelText: '模型（.dff）',
                          helperText: '只能选客户已有的模型',
                        ),
                        items: [
                          for (final value in models)
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (value) => setState(() => model = value),
                        validator: (value) =>
                            value == null || value.isEmpty ? '请选择模型' : null,
                      ),
                    ),
                  ],
                ),
                if (modelNotice.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      modelNotice,
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: note,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    labelText: '备注（可选，仅本地记录）',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(onPressed: submit, child: const Text('登记自建武器')),
      ],
    );
  }
}

/// Picks the weapon whose combo state machine should be borrowed.
///
/// Only weapons that already own transitions are offered: a donor with an empty
/// table would produce a weapon that still cannot chain.
class _ComboDonorDialog extends StatefulWidget {
  const _ComboDonorDialog({required this.candidates, required this.suggested});

  final List<Map<String, dynamic>> candidates;
  final int suggested;

  @override
  State<_ComboDonorDialog> createState() => _ComboDonorDialogState();
}

class _ComboDonorDialogState extends State<_ComboDonorDialog> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final suggestedFirst = [...widget.candidates]..sort((a, b) {
      if (a['id'] == widget.suggested) return -1;
      if (b['id'] == widget.suggested) return 1;
      return (a['id'] as int).compareTo(b['id'] as int);
    });
    final matches = suggestedFirst.where((w) {
      final text = query.trim();
      return text.isEmpty ||
          '${w['name']} ${w['id']}'.contains(text);
    }).toList();
    return AlertDialog(
      title: const Text('选择参考武器（借用它的连招表）'),
      content: SizedBox(
        width: 520,
        height: 460,
        child: Column(
          children: [
            if (widget.suggested > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '推荐参考武器编号 ${widget.suggested}：它与当前武器的动作行一致，'
                  '通常就是当初的模板。',
                  style: const TextStyle(fontSize: 12, height: 1.5),
                ),
              ),
            TextField(
              decoration: const InputDecoration(
                labelText: '搜索名称 / 编号',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final value = matches[index];
                  final recommended = value['id'] == widget.suggested;
                  return ListTile(
                    dense: true,
                    selected: recommended,
                    leading: recommended
                        ? const Icon(Icons.star, color: Colors.amber)
                        : null,
                    title: Text('${value['name']}'),
                    subtitle: Text(
                      '${value['type'] ?? '未分类'} · ${value['id']} · '
                      '${value['combo_rows']} 条连招',
                    ),
                    onTap: () => Navigator.pop(context, value['id'] as int),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ],
    );
  }
}

/// Picks which client folder the editor works on.
///
/// Detection only covers folders next to the server tree, so a manual path
/// field is always offered as a fallback. A plain ListTile-based list is used
/// instead of RadioListTile to stay clear of the Radio API churn.
class _ClientPickerDialog extends StatefulWidget {
  const _ClientPickerDialog({required this.current, required this.detected});

  final String current;
  final List<Map<String, dynamic>> detected;

  @override
  State<_ClientPickerDialog> createState() => _ClientPickerDialogState();
}

class _ClientPickerDialogState extends State<_ClientPickerDialog> {
  String chosen = '';
  final manual = TextEditingController();

  @override
  void initState() {
    super.initState();
    chosen = widget.current;
  }

  @override
  void dispose() {
    manual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('选择客户端所在文件夹'),
      content: SizedBox(
        width: 660,
        height: 430,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('自动找到的客户端：', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 2),
            Expanded(
              child: widget.detected.isEmpty
                  ? const Center(
                      child: Text('没有自动找到客户端，请在下面直接填路径'),
                    )
                  : ListView.builder(
                      itemCount: widget.detected.length,
                      itemBuilder: (context, index) {
                        final entry = widget.detected[index];
                        final directory = '${entry['directory']}';
                        final valid = entry['valid'] == true;
                        final hash = '${entry['config_hash'] ?? ''}';
                        final selected = chosen.trim() == directory;
                        return ListTile(
                          dense: true,
                          enabled: valid,
                          selected: selected,
                          leading: Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            size: 18,
                          ),
                          title: Row(
                            children: [
                              Text('${entry['label']}'),
                              if (entry['current'] == true) ...[
                                const SizedBox(width: 8),
                                const Text(
                                  '（当前使用）',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                              if (!valid) ...[
                                const SizedBox(width: 8),
                                const Text(
                                  '（不是客户端目录）',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            hash.isEmpty
                                ? directory
                                : '$directory\nconfig.spf2  ${hash.substring(0, 12)}…',
                            style: const TextStyle(fontSize: 11),
                          ),
                          isThreeLine: hash.isNotEmpty,
                          onTap: valid
                              ? () => setState(() {
                                    chosen = directory;
                                    manual.text = directory;
                                  })
                              : null,
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: manual,
              decoration: const InputDecoration(
                labelText: '或者直接填写文件夹路径',
                hintText: r'例如 D:/OpenKFO/local-client',
                prefixIcon: Icon(Icons.edit),
              ),
              onChanged: (value) => setState(() => chosen = value.trim()),
            ),
            const SizedBox(height: 6),
            const Text(
              '所选目录里必须有能解析的 Data/config.spf2，否则会被拒绝。',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: chosen.trim().isEmpty
              ? null
              : () => Navigator.pop(context, chosen.trim()),
          child: const Text('使用此客户端'),
        ),
      ],
    );
  }
}

/// 复用模板：先选武器，再选它的一个状态，返回 {weapon, state}。
class _RemapTemplateDialog extends StatefulWidget {
  const _RemapTemplateDialog({required this.weapons, required this.self});

  final List<Map<String, dynamic>> weapons;
  final int self;

  @override
  State<_RemapTemplateDialog> createState() => _RemapTemplateDialogState();
}

class _RemapTemplateDialogState extends State<_RemapTemplateDialog> {
  String query = '';
  Map<String, dynamic>? selected;
  String? chosenState;

  @override
  Widget build(BuildContext context) {
    final matches = widget.weapons.where((w) {
      final q = query.trim();
      return q.isEmpty || '${w['name']} ${w['id']}'.contains(q);
    }).toList();
    return AlertDialog(
      title: const Text('复用模板：先选武器，再选它的状态'),
      content: SizedBox(
        width: 620,
        height: 500,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '搜索武器名称 / 编号',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (context, i) {
                        final w = matches[i];
                        return ListTile(
                          dense: true,
                          selected: selected?['id'] == w['id'],
                          title: Text('${w['name']}'),
                          subtitle: Text(
                            '${w['type'] ?? ''} · ${w['id']} · '
                            '${(w['stages'] as List).length} 个状态',
                          ),
                          onTap: () => setState(() {
                            selected = w;
                            chosenState = null;
                          }),
                        );
                      },
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: selected == null
                        ? const Center(child: Text('先选择一把武器'))
                        : ListView.builder(
                            itemCount: (selected!['stages'] as List).length,
                            itemBuilder: (context, i) {
                              final s = selected!['stages'][i];
                              final stateKey = '${s['state']}';
                              final ids = (s['property_ids'] as List? ?? [])
                                  .join('、');
                              return ListTile(
                                dense: true,
                                selected: chosenState == stateKey,
                                title: Text('${s['label'] ?? stateKey}'),
                                subtitle: Text(
                                  '状态 $stateKey · 动作 ${s['action']}'
                                  '${ids.isEmpty ? '' : '\n命中属性 $ids'}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                                isThreeLine: ids.isNotEmpty,
                                onTap: () =>
                                    setState(() => chosenState = stateKey),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: (selected == null || chosenState == null)
              ? null
              : () => Navigator.pop(context, {
                    'weapon': selected!['id'] as int,
                    'state': int.parse(chosenState!),
                  }),
          child: const Text('复用此状态'),
        ),
      ],
    );
  }
}

/// 命中属性模板选择器，返回 SkillProId。
class _PropertyPickerDialog extends StatefulWidget {
  const _PropertyPickerDialog({required this.properties});

  final List<Map<String, dynamic>> properties;

  @override
  State<_PropertyPickerDialog> createState() => _PropertyPickerDialogState();
}

class _PropertyPickerDialogState extends State<_PropertyPickerDialog> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final matches = widget.properties.where((p) {
      final q = query.trim();
      return q.isEmpty || '${p['id']} ${p['summary']}'.contains(q);
    }).toList();
    return AlertDialog(
      title: const Text('选择命中属性模板（按此复制新节点）'),
      content: SizedBox(
        width: 600,
        height: 480,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '搜索编号 / 摘要',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, i) {
                  final p = matches[i];
                  return ListTile(
                    dense: true,
                    title: Text(
                      '${p['id']}',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    subtitle: Text('${p['summary']}'),
                    onTap: () => Navigator.pop(context, '${p['id']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ],
    );
  }
}

