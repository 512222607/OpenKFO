import 'package:flutter/material.dart';

class VipShopConfigPage extends StatefulWidget {
  const VipShopConfigPage({
    super.key,
    required this.api,
    required this.environment,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  @override
  State<VipShopConfigPage> createState() => _VipShopConfigPageState();
}

class _VipShopConfigPageState extends State<VipShopConfigPage> {
  static const tiers = {
    'silver': '白银VIP',
    'gold': '黄金VIP',
    'platinum': '铂金VIP',
  };
  final fields = {for (final key in tiers.keys) key: TextEditingController()};
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
    for (final field in fields.values) {
      field.dispose();
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
    final nextRevision = data['revision'];
    final rules = data['rules'] as Map;
    if (nextRevision is! int || nextRevision < 0 || rules['enabled'] is! bool) {
      throw const FormatException('VIP配置格式无效');
    }
    for (final key in tiers.keys) {
      final value = rules[key];
      if (value is! int || value < 0 || value > 100) {
        throw const FormatException('支付比例须为0–100的整数');
      }
    }
    setState(() {
      revision = nextRevision;
      enabled = rules['enabled'] as bool;
      for (final key in tiers.keys) {
        fields[key]!.text = '${rules[key]}';
      }
      status = '已读取 ${widget.environment}，版本 $revision';
    });
  }

  Future<void> load() => run(() async {
    setState(() => revision = null);
    apply(await widget.api({'operation': 'vip_shop_settings_get'}));
  });
  Future<void> save() => run(() async {
    if (revision == null) throw const FormatException('请先读取配置');
    final rules = <String, dynamic>{'enabled': enabled};
    for (final key in tiers.keys) {
      final value = int.tryParse(fields[key]!.text.trim());
      if (value == null || value < 0 || value > 100) {
        throw const FormatException('支付比例须为0–100的整数');
      }
      rules[key] = value;
    }
    apply(
      await widget.api({
        'operation': 'vip_shop_settings_save',
        'vip_shop_settings': {'revision': revision, 'rules': rules},
      }),
    );
    if (mounted) {
      setState(() => status = '已保存到 ${widget.environment}');
    }
  });
  @override
  Widget build(BuildContext context) {
    final editable = !busy && revision != null;
    return Scaffold(
      appBar: AppBar(title: Text('VIP商城折扣 · ${widget.environment}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '此配置作用于当前环境的全部VIP玩家。填写支付原价的百分比：80表示八折，100表示原价，0表示不额外打折。关闭后保留各档数值。',
          ),
          const SizedBox(height: 12),
          const Text('需部署支持VIP折扣的新版服务器。普通购买和赠送按当前有效会员档位计价；改价或会员到期后，旧价格会被拒绝，请重新打开商城确认。暂不支持与商品推荐／优惠叠加。'),
          SwitchListTile(
            title: const Text('启用VIP商城折扣'),
            value: enabled,
            onChanged: editable ? (v) => setState(() => enabled = v) : null,
          ),
          for (final entry in tiers.entries)
            TextField(
              key: ValueKey('vip_shop_${entry.key}'),
              controller: fields[entry.key],
              enabled: editable,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${entry.value}支付比例（0–100）',
              ),
            ),
          const SizedBox(height: 16),
          Text(status),
          Wrap(
            spacing: 12,
            children: [
              TextButton(
                onPressed: busy ? null : load,
                child: const Text('重新读取'),
              ),
              FilledButton(
                onPressed: editable ? save : null,
                child: const Text('保存VIP折扣配置'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
