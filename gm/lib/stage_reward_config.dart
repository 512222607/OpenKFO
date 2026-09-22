import 'dart:convert';

import 'package:flutter/material.dart';

import 'reward_picker.dart';

class StageRewardDialog extends StatefulWidget {
  const StageRewardDialog({
    super.key,
    required this.rows,
    required this.api,
    this.mapId,
    this.onSave,
  });
  final int? mapId;
  final Future<void> Function(List<Map<String, dynamic>>)? onSave;
  final List<Map<String, dynamic>> rows;
  final PickerApi api;
  @override
  State<StageRewardDialog> createState() => _StageRewardDialogState();
}

class _StageRewardDialogState extends State<StageRewardDialog> {
  late final rows = (jsonDecode(jsonEncode(widget.rows)) as List)
      .map((r) => Map<String, dynamic>.from(r))
      .toList();
  late final catalog = RewardCatalog.load(widget.api);
  late final maps = widget.api({'operation': 'stages_get'});
  String error = '';
  bool saving = false;
  @override
  void initState() {
    super.initState();
    if (widget.mapId != null && !rows.any((r) => r['map_id'] == widget.mapId)) {
      rows.add({
        'map_id': widget.mapId,
        'clear': emptyReward(),
        'failed': emptyReward(),
      });
    }
  }

  Map<String, dynamic> emptyReward() => {
    'experience': 0,
    'gold': 0,
    'tickets': 0,
    'items': <int>[],
  };

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !saving,
    child: AlertDialog(
      title: const Text('关卡奖励'),
      content: AbsorbPointer(
        absorbing: saving,
        child: SizedBox(
          width: 740,
          height: 520,
          child: FutureBuilder<dynamic>(
            future: maps,
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('地图目录读取失败：${snapshot.error}');
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data as Map;
              final pve = (data['pve_maps'] as List? ?? []).toSet();
              final names = <int, String>{
                for (final r in data['requirements'] as List? ?? [])
                  if (pve.contains(r['map_id']) || r['map_id'] == widget.mapId)
                    r['map_id'] as int: '${r['name']}',
              };
              final choices = {...names};
              for (final r in rows) {
                final id = r['map_id'] as int;
                choices.putIfAbsent(id, () => '未匹配地图 $id（保留原配置）');
              }
              final used = rows.map((r) => r['map_id']).toSet();
              final available = names.keys
                  .where((id) => !used.contains(id))
                  .toList();
              final visible = rows
                  .where(
                    (r) => widget.mapId == null || r['map_id'] == widget.mapId,
                  )
                  .toList();
              return Column(
                children: [
                  const Text('通关与失败分别配置，物品全部发放；不使用竞技奖励。配置不会自动开放尚未实现的关卡。'),
                  if (names.isEmpty) const Text('暂无关卡目录，请先在关卡配置中导入客户端地图并保存。'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: visible.length,
                      itemBuilder: (_, i) {
                        final row = visible[i];
                        return Card(
                          key: ObjectKey(row),
                          child: ExpansionTile(
                            initiallyExpanded: widget.mapId != null,
                            title: Text(choices[row['map_id']]!),
                            childrenPadding: const EdgeInsets.all(12),
                            children: [
                              if (widget.mapId == null)
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        initialValue: row['map_id'] as int,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: '地图',
                                        ),
                                        items: choices.entries
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.key,
                                                child: Text(e.value),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (id) {
                                          if (id != null) {
                                            setState(() => row['map_id'] = id);
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: '删除地图奖励',
                                      onPressed: () =>
                                          setState(() => rows.removeAt(i)),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              for (final outcome in {
                                'clear': '通关奖励',
                                'failed': '失败奖励',
                              }.entries)
                                Builder(
                                  builder: (_) {
                                    final reward = row.putIfAbsent(
                                      outcome.key,
                                      emptyReward,
                                    ) as Map;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        Text(outcome.value),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 8,
                                          children: [
                                            for (final field in {
                                              'experience': '经验',
                                              'gold': '金币',
                                              'tickets': '点券',
                                            }.entries)
                                              SizedBox(
                                                width: 150,
                                                child: TextFormField(
                                                  key: ValueKey(
                                                    '${row['map_id']}-${outcome.key}-${field.key}',
                                                  ),
                                                  initialValue:
                                                      '${reward[field.key] ?? 0}',
                                                  decoration: InputDecoration(
                                                    labelText: field.value,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (v) =>
                                                      reward[field.key] =
                                                          int.tryParse(v) ?? -1,
                                                ),
                                              ),
                                          ],
                                        ),
                                        RewardItemsField(
                                          catalog: catalog,
                                          items: List<int>.from(
                                            reward['items'] as List? ?? [],
                                          ),
                                          onChanged: (items) => setState(
                                            () => reward['items'] = items,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Text(error, style: const TextStyle(color: Colors.red)),
                  if (widget.mapId == null)
                    TextButton(
                      onPressed: available.isEmpty || rows.length >= 256
                          ? null
                          : () => setState(
                              () => rows.add({
                                'map_id': available.first,
                                'clear': emptyReward(),
                                'failed': emptyReward(),
                              }),
                            ),
                      child: const Text('新增地图奖励'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: saving
              ? null
              : () async {
                  setState(() {
                    saving = true;
                    error = '';
                  });
                  try {
                    final seen = <int>{};
                    for (final r in rows) {
                      final id = r['map_id'] as int;
                      if (id <= 0 || !seen.add(id)) {
                        throw const FormatException('地图不可重复');
                      }
                      for (final key in ['clear', 'failed']) {
                        final reward = r[key] as Map? ?? {};
                        for (final field in ['experience', 'gold', 'tickets']) {
                          final value = reward[field] as int? ?? 0;
                          if (value < 0 || value > 1000000) {
                            throw const FormatException('经验、金币、点券须为0–1000000');
                          }
                        }
                        if ((reward['items'] as List? ?? []).length > 8) {
                          throw const FormatException('每种结果最多8件物品');
                        }
                      }
                    }
                    if (rows.length > 256)
                      throw const FormatException('最多配置256张地图');
                    if (widget.onSave != null) await widget.onSave!(rows);
                    if (context.mounted) Navigator.pop(context, rows);
                  } catch (e) {
                    if (mounted)
                      setState(() {
                        error = '$e';
                        saving = false;
                      });
                  }
                },
          child: Text(
            saving
                ? '保存中…'
                : widget.onSave == null
                ? '应用到草稿'
                : '保存地图奖励',
          ),
        ),
      ],
    ),
  );
}
