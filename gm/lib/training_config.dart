import 'package:flutter/material.dart';

class TrainingConfigPage extends StatefulWidget {
  const TrainingConfigPage({
    super.key,
    required this.api,
    required this.environment,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  @override
  State<TrainingConfigPage> createState() => _TrainingConfigPageState();
}

class _TrainingConfigPageState extends State<TrainingConfigPage> {
  final rates = List.generate(9, (_) => TextEditingController());
  final caps = List.generate(9, (_) => TextEditingController());
  int? revision;
  bool enabled = false, busy = false;
  String status = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    for (final c in [...rates, ...caps]) {
      c.dispose();
    }
    super.dispose();
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
    final levels = (rules['levels'] as List?) ?? [];
    setState(() {
      revision = data['revision'] as int;
      enabled = rules['enabled'] == true;
      for (var i = 0; i < 9; i++) {
        rates[i].text = '${i < levels.length ? levels[i]['xp_per_hour'] : 0}';
        caps[i].text = '${i < levels.length ? levels[i]['xp_cap'] : 0}';
      }
      status = '已读取 ${widget.environment}，版本 $revision';
    });
  }

  Future<void> load() => run(() async {
    apply(await widget.api({'operation': 'training_get'}));
  });
  Future<void> save() => run(() async {
    final levels = <Map<String, int>>[];
    for (var i = 0; i < 9; i++) {
      final rate = int.tryParse(rates[i].text.trim());
      final cap = int.tryParse(caps[i].text.trim());
      if (rate == null ||
          cap == null ||
          rate < 0 ||
          cap < 0 ||
          rate > 2147483647 ||
          cap > 2147483647 ||
          (rate == 0 && cap != 0)) {
        throw FormatException('第$i级数值无效；请输入0–2147483647的整数，每小时经验为0时上限也须为0');
      }
      levels.add({'level': i, 'xp_per_hour': rate, 'xp_cap': cap});
    }
    final result = await widget.api({
      'operation': 'training_save',
      'training': {
        'revision': revision,
        'rules': {'enabled': enabled, 'levels': levels},
      },
    });
    apply(result);
    if (mounted) {
      setState(
        () => status = '已保存到 ${widget.environment}；当前版本尚未接通游戏领奖，请勿视为已生效',
      );
    }
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('名侠奖励 · ${widget.environment}')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '名侠等级与角色等级不同。按整小时累计经验，达到上限后停止增加。关闭开关保留数值。当前仅保存配置，游戏领奖接入尚未完成。',
          ),
          SwitchListTile(
            title: const Text('启用名侠经验奖励'),
            value: enabled,
            onChanged: busy || revision == null
                ? null
                : (v) => setState(() => enabled = v),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 9,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(width: 64, child: Text('名侠 $i级')),
                    Expanded(
                      child: TextField(
                        key: ValueKey('rate$i'),
                        controller: rates[i],
                        enabled: !busy && revision != null,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: '每小时经验'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        key: ValueKey('cap$i'),
                        controller: caps[i],
                        enabled: !busy && revision != null,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: '累计经验上限'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(status),
          Row(
            children: [
              TextButton(
                onPressed: busy ? null : load,
                child: const Text('重新读取'),
              ),
              FilledButton(
                onPressed: busy || revision == null ? null : save,
                child: const Text('保存名侠配置'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
