import 'package:flutter/material.dart';

class DropConfigDialog extends StatefulWidget {
  const DropConfigDialog({super.key, required this.drops});
  final List<Map<String, dynamic>> drops;
  @override
  State<DropConfigDialog> createState() => _DropConfigDialogState();
}

class _DropConfigDialogState extends State<DropConfigDialog> {
  final form = GlobalKey<FormState>();
  late final rows = widget.drops
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('战斗武器掉落'),
    content: SizedBox(
      width: 680,
      height: 440,
      child: Column(
        children: [
          const Text(
            '每条规则独立判定，按开战等级匹配。概率 10000 = 100%，0 = 关闭。商品编号使用商城销售配置编号，期限沿用该商品的发放配置。中止或结果不一致不掉落。',
          ),
          Expanded(
            child: Form(
              key: form,
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (_, i) {
                  final row = rows[i];
                  Widget number(String key, String label, int min, int max) =>
                      SizedBox(
                        width: 125,
                        child: TextFormField(
                          initialValue: '${row[key]}',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: label),
                          onChanged: (v) => row[key] = int.tryParse(v) ?? -1,
                          validator: (_) {
                            final v = row[key] as int;
                            if (v < min || v > max) return '$min–$max';
                            if (key == 'max_level' &&
                                v < (row['min_level'] as int)) {
                              return '不能小于最低等级';
                            }
                            return null;
                          },
                        ),
                      );
                  return Card(
                    key: ObjectKey(row),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          number('catalog_key', '商品编号', 1, 4294967295),
                          SizedBox(
                            width: 100,
                            child: DropdownButtonFormField<String>(
                              initialValue: row['outcome'] as String,
                              items: const [
                                DropdownMenuItem(
                                  value: 'win',
                                  child: Text('胜利'),
                                ),
                                DropdownMenuItem(
                                  value: 'loss',
                                  child: Text('失败'),
                                ),
                                DropdownMenuItem(
                                  value: 'draw',
                                  child: Text('平局'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) row['outcome'] = v;
                              },
                            ),
                          ),
                          number('min_level', '最低等级', 1, 150),
                          number('max_level', '最高等级', 1, 150),
                          number('chance_per_10000', '概率（万分之）', 0, 10000),
                          IconButton(
                            tooltip: '删除规则',
                            onPressed: () => setState(() => rows.removeAt(i)),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          TextButton(
            onPressed: rows.length >= 32
                ? null
                : () => setState(
                    () => rows.add({
                      'catalog_key': 0,
                      'outcome': 'win',
                      'min_level': 1,
                      'max_level': 150,
                      'chance_per_10000': 0,
                    }),
                  ),
            child: const Text('新增规则'),
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
        onPressed: () {
          if (form.currentState!.validate()) Navigator.pop(context, rows);
        },
        child: const Text('应用到表格（仍需保存）'),
      ),
    ],
  );
}
