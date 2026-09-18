import 'dart:convert';

import 'package:flutter/material.dart';

class ShopConfigPage extends StatefulWidget {
  const ShopConfigPage({
    super.key,
    required this.api,
    this.environment = '当前环境',
  });
  final String environment;
  final Future<dynamic> Function(Map<String, dynamic>) api;
  @override
  State<ShopConfigPage> createState() => _ShopConfigPageState();
}

class _ShopConfigPageState extends State<ShopConfigPage> {
  Map<String, dynamic>? data, item;
  String query = '', message = '', currency = 'ticket';
  bool busy = true, enabled = false, dirty = false;
  final price = TextEditingController(text: '100');
  final days = TextEditingController(text: '365');
  final quantity = TextEditingController(text: '1');
  final form = GlobalKey<FormState>();
  final selected = <String>{};
  String? pendingSignature, pendingId;
  String batchCurrency = 'ticket', batchAmount = '100';

  String operationId(Map<String, dynamic> request) {
    final signature = jsonEncode(request);
    if (signature != pendingSignature) {
      pendingSignature = signature;
      pendingId = 'shop-${DateTime.now().microsecondsSinceEpoch}';
    }
    return pendingId!;
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    price.dispose();
    days.dispose();
    quantity.dispose();
    super.dispose();
  }

  void select(Map<String, dynamic> next) {
    item = next;
    final config = data!['offers'][item!['key']] as Map?;
    currency = config?['currency'] ?? 'ticket';
    enabled = config?['enabled'] ?? false;
    price.text = '${config?['price'] ?? 100}';
    days.text = '${config?['days'] ?? 365}';
    quantity.text = '${config?['quantity'] ?? 1}';
    dirty = false;
  }

  Future<void> load() async {
    try {
      final result = Map<String, dynamic>.from(
        await widget.api({'operation': 'shop_catalog'}),
      );
      if (!mounted) return;
      setState(() {
        data = result;
        busy = false;
        if (item != null) select(item!);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          message = '$e';
          busy = false;
        });
      }
    }
  }

  Future<bool> discard() async {
    if (!dirty) return true;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('有未保存的商城配置'),
            content: const Text('是否丢弃当前修改？'),
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
  }

  Future<void> save() async {
    if (busy || !form.currentState!.validate()) return;
    setState(() {
      busy = true;
      message = "正在保存到${widget.environment}，请稍候…";
    });
    try {
      final request = <String, dynamic>{
        'operation': 'shop_save',
        'key': item!['key'],
        'currency': currency,
        'price': int.parse(price.text),
        'days': int.parse(days.text),
        'quantity': int.parse(quantity.text),
        'enabled': enabled,
      };
      final result = await widget.api({...request, 'id': operationId(request)});
      if (!mounted) return;
      setState(() {
        final offers = data!['offers'] as Map;
        offers[request['key']] = {
          for (final key in [
            'currency',
            'price',
            'days',
            'quantity',
            'enabled',
          ])
            key: request[key],
        };
        message = '${widget.environment} · ${result['message']}';
        dirty = false;
        busy = false;
        pendingId = pendingSignature = null;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          message = '$e';
          busy = false;
        });
      }
    }
  }

  Future<void> batch(bool publish, {bool all = false}) async {
    if (busy || data == null || (!all && selected.isEmpty)) return;
    if (!await discard() || !mounted) return;
    final keys = selected.toList()..sort();
    final count = all ? (data!['items'] as List).length : keys.length;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${all ? '全部' : '批量'}${publish ? '上架' : '下架'}当前环境商品'),
        content: Text(
          publish
              ? '将上架 $count 件可售商品。已有价格、币种、期限和数量保持不变。\n\n未配置商品默认：100 点券；装备 365 天；消耗品每次 1 个。'
              : all
              ? '将下架当前环境商城全部销售记录，包括当前搜索结果之外的商品。价格和发货设置保留。'
              : '将下架选中的 $count 件商品，保留价格和发货设置。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认执行'),
          ),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    final request = <String, dynamic>{
      'operation': 'shop_batch',
      'enabled': publish,
      'all': all,
      'keys': all ? <String>[] : keys,
    };
    setState(() => busy = true);
    try {
      final result = await widget.api({...request, 'id': operationId(request)});
      if (!mounted) return;
      setState(() {
        message = result['message'];
        dirty = false;
        pendingId = pendingSignature = null;
      });
      await load();
    } catch (error) {
      if (mounted) {
        setState(() {
          busy = false;
          message = '$error';
        });
      }
    }
  }

  Future<void> batchPrices() async {
    if (busy || data == null || selected.isEmpty) return;
    if (!await discard() || !mounted) return;
    final keys = selected.toList()..sort();
    final amount = TextEditingController(text: batchAmount);
    var chosen = batchCurrency;
    String? error;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, update) => AlertDialog(
          title: Text('批量改价 · ${widget.environment} · ${keys.length} 件'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '仅修改所选商品已有销售记录的币种和售价。多条销售规格统一改价；期限、数量、上下架及其他标记保留。未配置商品跳过，不自动上架。',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: chosen,
                  decoration: const InputDecoration(labelText: '批量币种'),
                  items: const [
                    DropdownMenuItem(value: 'ticket', child: Text('点券')),
                    DropdownMenuItem(value: 'gold', child: Text('金币')),
                  ],
                  onChanged: (v) => update(() => chosen = v!),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('batch-price'),
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '统一售价',
                    errorText: error,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(amount.text.trim());
                if (value == null || value < 1 || value > 2147483647) {
                  update(() => error = '请输入 1–2147483647 的整数');
                  return;
                }
                Navigator.pop(c, true);
              },
              child: const Text('确认改价'),
            ),
          ],
        ),
      ),
    );
    if (accepted == true && mounted) {
      batchCurrency = chosen;
      batchAmount = amount.text.trim();
      final request = <String, dynamic>{
        'operation': 'shop_prices',
        'keys': keys,
        'currency': chosen,
        'price': int.parse(batchAmount),
      };
      setState(() {
        busy = true;
        message = '正在批量改价，请稍候…';
      });
      try {
        final result = await widget.api({
          ...request,
          'id': operationId(request),
        });
        if (mounted) {
          setState(() {
            final offers = data!['offers'] as Map;
            for (final key in keys) {
              if (offers[key] != null) {
                offers[key]['currency'] = request['currency'];
                offers[key]['price'] = request['price'];
              }
            }
            if (item != null) select(item!);
            dirty = false;
            pendingId = pendingSignature = null;
            message = result['message'];
          });
        }
      } catch (e) {
        if (mounted) setState(() => message = '$e');
      } finally {
        if (mounted) setState(() => busy = false);
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    amount.dispose();
  }

  Widget number(TextEditingController controller, String label, int max) =>
      TextFormField(
        controller: controller,
        enabled: !busy,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (_) => setState(() => dirty = true),
        validator: (text) {
          final v = int.tryParse(text ?? '');
          return v == null || v < 1 || v > max ? '请输入 1–$max' : null;
        },
      );

  @override
  Widget build(BuildContext context) {
    final items = (data?['items'] as List? ?? [])
        .where((i) => '${i['id']} ${i['name']}'.contains(query))
        .toList();
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
        appBar: AppBar(title: Text('${widget.environment} · 商城配置')),
        body: Column(
          children: [
            if (busy) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: busy || data == null
                        ? null
                        : () => batch(true, all: true),
                    child: const Text('全部上架'),
                  ),
                  OutlinedButton(
                    onPressed: busy || data == null
                        ? null
                        : () => batch(false, all: true),
                    child: const Text('全部下架'),
                  ),
                  FilledButton(
                    onPressed: busy || selected.isEmpty
                        ? null
                        : () => batch(true),
                    child: const Text('选中上架'),
                  ),
                  OutlinedButton(
                    onPressed: busy || selected.isEmpty
                        ? null
                        : () => batch(false),
                    child: const Text('选中下架'),
                  ),
                  FilledButton(
                    onPressed: busy || selected.isEmpty ? null : batchPrices,
                    child: const Text('批量改价'),
                  ),
                  Text('已选 ${selected.length} 件'),
                  IconButton(
                    onPressed: busy ? null : load,
                    tooltip: '刷新当前环境商品',
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 340,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: '搜索商品',
                            ),
                            onChanged: (v) => setState(() => query = v),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () => setState(
                                      () => selected.addAll(
                                        items.map(
                                          (row) => row['key'] as String,
                                        ),
                                      ),
                                    ),
                              child: const Text('选择搜索结果'),
                            ),
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () => setState(selected.clear),
                              child: const Text('清空选择'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final row = items[index];
                              final offer = data!['offers'][row['key']];
                              return ListTile(
                                leading: Checkbox(
                                  value: selected.contains(row['key']),
                                  onChanged: busy
                                      ? null
                                      : (checked) => setState(() {
                                          if (checked == true) {
                                            selected.add(row['key']);
                                          } else {
                                            selected.remove(row['key']);
                                          }
                                        }),
                                ),
                                selected: item?['key'] == row['key'],
                                title: Text(row['name']),
                                subtitle: Text(
                                  '${row['id']} · ${offer?['enabled'] == true ? '已上架' : '未上架'}',
                                ),
                                onTap: busy
                                    ? null
                                    : () async {
                                        if (await discard() && mounted) {
                                          setState(
                                            () => select(
                                              Map<String, dynamic>.from(row),
                                            ),
                                          );
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
                    child: item == null
                        ? const Center(child: Text('选择商品，配置价格和发货内容'))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: form,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item!['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  SwitchListTile(
                                    title: const Text('上架销售'),
                                    value: enabled,
                                    onChanged: busy
                                        ? null
                                        : (v) => setState(() {
                                            enabled = v;
                                            dirty = true;
                                          }),
                                  ),
                                  SegmentedButton<String>(
                                    segments: const [
                                      ButtonSegment(
                                        value: 'ticket',
                                        label: Text('点券'),
                                      ),
                                      ButtonSegment(
                                        value: 'gold',
                                        label: Text('金币'),
                                      ),
                                    ],
                                    selected: {currency},
                                    onSelectionChanged: busy
                                        ? null
                                        : (v) => setState(() {
                                            currency = v.first;
                                            dirty = true;
                                          }),
                                  ),
                                  const SizedBox(height: 20),
                                  number(price, '售价', 2147483647),
                                  const SizedBox(height: 20),
                                  if (item!['stackable'] == true)
                                    number(quantity, '每次购买数量', 999)
                                  else
                                    number(days, '装备期限（天）', 3650),
                                  const SizedBox(height: 24),
                                  FilledButton(
                                    onPressed: busy ? null : save,
                                    child: const Text('保存商城配置'),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    '直接保存到当前环境的数据库；下架保留价格与发货设置。游戏会缓存商品，修改后请重新登录。',
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(message),
            ),
          ],
        ),
      ),
    );
  }
}
