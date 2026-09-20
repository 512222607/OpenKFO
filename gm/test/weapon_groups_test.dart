import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/weapon_config.dart';

void main() {
  testWidgets('combo groups share state edits and keep unmapped actions', (tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Map<String, dynamic>? saved;
    Map<String, dynamic> stage(int id) => {'stage': id, 'state': '$id', 'label': '动作 $id', 'action': '2001001', 'property_ids': <String>[], 'hits': <dynamic>[], 'supported': true};
    final catalog = {
      'revision': 'test', 'drafts': {'1': [{'stage': 2021, 'buff': 14, 'level': 1, 'duration': 3000}]},
      'applied': <String, dynamic>{}, 'buffs': [{'id': 0, 'name': '原效果'}, {'id': 14, 'name': '冰冻'}],
      'weapons': [{'id': 1, 'name': '测试武器', 'stages': [stage(2021), stage(999)], 'combos': [
        {'name': '路线一', 'nodes': [{'state': '2021', 'keys': 'CCCX'}]},
        {'name': '路线二', 'nodes': [{'state': '2021', 'keys': 'XX'}]},
      ]}],
    };
    await tester.pumpWidget(MaterialApp(home: WeaponConfigPage(api: (r) async {
      if (r['operation'] == 'weapon_save') { saved = r; return {'message': '已保存'}; }
      return catalog;
    })));
    await tester.pumpAndSettle();
    expect(find.text('该武器默认连招'), findsNothing);
    expect(find.text('其他动作（1）'), findsOneWidget);
    await tester.tap(find.text('CCCX')); await tester.pumpAndSettle();
    await tester.tap(find.text('第 1 段 · CCCX')); await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, '3000'), '5000');
    await tester.tap(find.text('CCCX')); await tester.pumpAndSettle();
    await tester.tap(find.text('XX')); await tester.pumpAndSettle();
    await tester.tap(find.text('第 1 段 · XX')); await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, '5000'), findsOneWidget);
    await tester.tap(find.text('保存方案')); await tester.pumpAndSettle();
    final rules = saved!['rules'] as List;
    expect(rules.where((r) => r['stage'] == 2021).single['duration'], 5000);
    expect(rules.where((r) => r['stage'] == 999).length, 1);
    expect(tester.takeException(), isNull);
  });
}
