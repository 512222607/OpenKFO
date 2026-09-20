import 'dart:convert';

import 'package:flutter/material.dart';

class HonourConfigPage extends StatefulWidget {
  const HonourConfigPage({
    super.key,
    required this.api,
    required this.environment,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  @override
  State<HonourConfigPage> createState() => _HonourConfigPageState();
}

class _HonourConfigPageState extends State<HonourConfigPage> {
  final fields = List.generate(5, (_) => TextEditingController());
  List<String> periods = [];
  Set<int> modes = {};
  int? revision;
  bool busy = false;
  String status = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    for (final f in fields) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        setState(() => status = '操作失败：$e');
      }
    } finally {
      if (mounted) {
        setState(() => busy = false);
      }
    }
  }

  void apply(dynamic data) {
    if (!mounted) return;
    final r = data['rules'] as Map;
    final rawModes = r['modes'];
    final decodedModes = rawModes is String
        ? base64Decode(rawModes)
        : (rawModes as List? ?? []).cast<int>();
    setState(() {
      revision = data['revision'] as int;
      periods = (r['periods'] as List? ?? []).cast<String>().toList();
      modes = decodedModes.toSet();
      for (var i = 0; i < 3; i++) {
        fields[i].text =
            '${r[['win_points', 'loss_points', 'draw_points'][i]] ?? 0}';
      }
      fields[3].text = (r['level_points'] as List? ?? []).join(',');
      fields[4].clear();
    });
  }

  Future<void> load() => run(() async {
    apply(await widget.api({'operation': 'honour_get'}));
    if (mounted) {
      setState(() => status = '已读取 ${widget.environment}');
    }
  });
  Future<void> save() => run(() async {
    final points = fields
        .take(3)
        .map((f) => int.tryParse(f.text.trim()))
        .toList();
    if (points.any((n) => n == null || n < 0 || n > 2147483647)) {
      throw const FormatException('积分须为0–2147483647的整数');
    }
    final text = fields[3].text.trim();
    final levels = text.isEmpty
        ? <int?>[]
        : text.split(RegExp(r'[,，\s]+')).map(int.tryParse).toList();
    if (levels.length > 10 ||
        levels.any((n) => n == null || n < 0 || n > 2147483647)) {
      throw const FormatException('等级门槛最多10项，须为非负整数');
    }
    for (var i = 1; i < levels.length; i++) {
      if (levels[i]! <= levels[i - 1]!) {
        throw const FormatException('等级门槛须严格递增');
      }
    }
    final nextPeriods = [...periods];
    final added = fields[4].text.trim();
    if (added.isNotEmpty) {
      nextPeriods.add(added);
    }
    if (nextPeriods.isEmpty && (modes.isNotEmpty || levels.isNotEmpty)) {
      throw const FormatException('请先添加期次');
    }
    final result = await widget.api({
      'operation': 'honour_save',
      'honour': {
        'revision': revision,
        'rules': {
          'periods': nextPeriods,
          'modes': (modes.toList()..sort()),
          'win_points': points[0],
          'loss_points': points[1],
          'draw_points': points[2],
          'level_points': levels,
        },
      },
    });
    apply(result);
    if (mounted) {
      setState(() => status = '已保存到 ${widget.environment}');
    }
  });
  @override
  Widget build(BuildContext context) {
    final editable = !busy && revision != null;
    return Scaffold(
      appBar: AppBar(title: Text('荣誉规则 · ${widget.environment}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('自定义荣誉积分与等级规则。取消全部计分模式可停止累计，历史战绩保留。'),
          const SizedBox(height: 12),
          Text(
            '已有期次：${periods.isEmpty ? '暂无' : periods.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('；')}',
          ),
          TextField(
            controller: fields[4],
            enabled: editable,
            decoration: const InputDecoration(
              labelText: '追加一期名称（留空不新增）',
              helperText: '旧期次不能删除、改名或重排；新增期次成为当前期。',
            ),
          ),
          const SizedBox(height: 12),
          const Text('计分模式（协议模式编号）'),
          Wrap(
            spacing: 8,
            children: List.generate(
              4,
              (i) => FilterChip(
                label: Text('模式 $i'),
                selected: modes.contains(i),
                onSelected: editable
                    ? (v) => setState(() {
                        if (v) {
                          modes.add(i);
                        } else {
                          modes.remove(i);
                        }
                      })
                    : null,
              ),
            ),
          ),
          for (var i = 0; i < 3; i++)
            TextField(
              controller: fields[i],
              enabled: editable,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: ['胜利积分', '失败积分', '平局积分'][i],
              ),
            ),
          TextField(
            controller: fields[3],
            enabled: editable,
            decoration: const InputDecoration(
              labelText: '荣誉等级门槛',
              helperText: '逗号分隔，最多10项；留空关闭分级。修改会重新计算历史资料显示等级。',
            ),
          ),
          const SizedBox(height: 12),
          const Text('积分从下一次结算读取；资料查询即时读取。新增期次后，客户端期次目录需重新登录刷新。'),
          const SizedBox(height: 12),
          Text(status),
          Row(
            children: [
              TextButton(
                onPressed: busy ? null : load,
                child: const Text('重新读取'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: editable ? save : null,
                child: const Text('保存荣誉规则'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
