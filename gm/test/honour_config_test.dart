import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/honour_config.dart';

void main() {
  testWidgets('honour settings preserve historical periods and revision', (
    t,
  ) async {
    Map<String, dynamic>? saved;
    await t.pumpWidget(
      MaterialApp(
        home: HonourConfigPage(
          environment: '本地测试服',
          api: (r) async {
            if (r['operation'] == 'honour_save') {
              saved = r;
              return r['honour'];
            }
            return {
              'revision': 7,
              'rules': {
                'periods': ['第一期'],
                'modes': 'AQ==',
                'win_points': 10,
                'loss_points': 2,
                'draw_points': 3,
                'level_points': [100, 300],
              },
            };
          },
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(
      t.widget<FilterChip>(find.widgetWithText(FilterChip, '模式 1')).selected,
      isTrue,
    );
    await t.enterText(find.byType(TextField).at(0), '第二期');
    await t.enterText(find.byType(TextField).at(1), '50');
    FocusManager.instance.primaryFocus?.unfocus();
    await t.pumpAndSettle();
    await t.drag(find.byType(ListView), const Offset(0, -500));
    await t.pumpAndSettle();
    await t.tap(find.text('保存荣誉规则'));
    await t.pumpAndSettle();
    expect(saved?['honour'], {
      'revision': 7,
      'rules': {
        'periods': ['第一期', '第二期'],
        'modes': [1],
        'win_points': 50,
        'loss_points': 2,
        'draw_points': 3,
        'level_points': [100, 300],
      },
    });
    expect(find.text('已保存到 本地测试服'), findsOneWidget);
  });
  testWidgets('honour load failure disables writes', (t) async {
    await t.pumpWidget(
      MaterialApp(
        home: HonourConfigPage(
          environment: '线上服务器',
          api: (r) async => throw Exception('not initialized'),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.drag(find.byType(ListView), const Offset(0, -500));
    await t.pumpAndSettle();
    expect(t.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });
}
