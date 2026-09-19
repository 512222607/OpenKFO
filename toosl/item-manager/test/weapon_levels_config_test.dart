import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/weapon_levels_config.dart';

void main() {
  testWidgets('edit preserves unknown values, environment and revision', (
    tester,
  ) async {
    Map<String, dynamic>? saved;
    final data = {
      'revision': 7,
      'rules': {
        'enabled': true,
        'levels': [
          {
            'level': 0,
            'score_threshold': 10,
            'gold': 20,
            'display_odds': 50,
            'attack_bonus_raw': 100,
            'unknown_16': 7,
          },
          {
            'level': 1,
            'score_threshold': 20,
            'gold': 30,
            'display_odds': 60,
            'attack_bonus_raw': 200,
            'unknown_16': 8,
          },
        ],
      },
    };
    await tester.pumpWidget(
      MaterialApp(
        home: WeaponLevelsConfigPage(
          environment: '线上服务器',
          api: (r) async {
            if (r['operation'] == 'weapon_settings_save') {
              saved = r;
            }
            return data;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('武器升级 · 线上服务器'), findsOneWidget);
    await tester.tap(find.text('等级 0'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('display_odds')), '101');
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(find.text('成功率（0–100）无效'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('display_odds')), '80');
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('启用武器升级'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存升级配置'));
    await tester.pumpAndSettle();
    final config = saved!['weapon_settings'];
    expect(config['revision'], 7);
    expect(config['rules']['enabled'], false);
    expect(config['rules']['levels'][0]['display_odds'], 80);
    expect(config['rules']['levels'][0]['unknown_16'], 7);
    expect(config['rules']['levels'].length, 2);
  });
  testWidgets('read failure disables saving', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WeaponLevelsConfigPage(
          environment: '本地测试服',
          api: (_) async => throw Exception('offline'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });
}
