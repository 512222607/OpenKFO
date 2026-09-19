import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kungfu_item_manager/vip_shop_config.dart';

void main() {
  Map<String, dynamic> config() => {
    'revision': 7,
    'rules': {'enabled': true, 'silver': 90, 'gold': 80, 'platinum': 70},
  };
  Future<void> save(WidgetTester t) async {
    await t.ensureVisible(find.text('保存VIP折扣配置'));
    await t.tap(find.text('保存VIP折扣配置'));
    await t.pumpAndSettle();
  }

  testWidgets('validates percentages and preserves tiers when disabled', (
    t,
  ) async {
    final writes = <Map<String, dynamic>>[];
    await t.pumpWidget(
      MaterialApp(
        home: VipShopConfigPage(
          environment: '线上服务器',
          api: (r) async {
            if (r['operation'] == 'vip_shop_settings_get') return config();
            writes.add(r);
            return {...r['vip_shop_settings'] as Map, 'revision': 8};
          },
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('VIP商城折扣 · 线上服务器'), findsOneWidget);
    final gold = find.byKey(const ValueKey('vip_shop_gold'));
    await t.enterText(gold, '101');
    await save(t);
    expect(writes, isEmpty);
    expect(find.textContaining('支付比例须为0–100的整数'), findsOneWidget);
    await t.enterText(gold, '0');
    await t.ensureVisible(find.byType(SwitchListTile));
    await t.tap(find.byType(SwitchListTile));
    await t.pumpAndSettle();
    await save(t);
    expect(writes.single['operation'], 'vip_shop_settings_save');
    expect(writes.single['vip_shop_settings'], {
      'revision': 7,
      'rules': {'enabled': false, 'silver': 90, 'gold': 0, 'platinum': 70},
    });
    expect(find.text('已保存到 线上服务器'), findsOneWidget);
    await save(t);
    expect(writes.last['vip_shop_settings']['revision'], 8);
  });
  testWidgets('conflict retains draft and original revision', (t) async {
    final revisions = <int>[];
    await t.pumpWidget(
      MaterialApp(
        home: VipShopConfigPage(
          environment: '本地测试服',
          api: (r) async {
            if (r['operation'] == 'vip_shop_settings_get') return config();
            revisions.add(r['vip_shop_settings']['revision'] as int);
            throw Exception('版本冲突');
          },
        ),
      ),
    );
    await t.pumpAndSettle();
    final silver = find.byKey(const ValueKey('vip_shop_silver'));
    await t.enterText(silver, '88');
    await save(t);
    expect(t.widget<TextField>(silver).controller!.text, '88');
    expect(find.textContaining('版本冲突'), findsOneWidget);
    await save(t);
    expect(revisions, [7, 7]);
  });
  testWidgets('failed or malformed read blocks saving', (t) async {
    for (final malformed in [false, true]) {
      await t.pumpWidget(
        MaterialApp(
          home: VipShopConfigPage(
            key: ValueKey(malformed),
            environment: '本地测试服',
            api: (r) async {
              expect(r['operation'], 'vip_shop_settings_get');
              if (!malformed) throw Exception('offline');
              return {
                'revision': 7,
                'rules': {
                  'enabled': true,
                  'silver': 90,
                  'gold': 101,
                  'platinum': 70,
                },
              };
            },
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('保存VIP折扣配置'));
      expect(
        t.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    }
  });
}
