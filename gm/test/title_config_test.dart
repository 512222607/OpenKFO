import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kungfu_item_manager/title_config.dart';

void main() {
  testWidgets('load failure prevents saving', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TitleConfigPage(
          environment: '本地测试服',
          api: (_) async => throw Exception('offline'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, '保存称号配置'))
          .onPressed,
      isNull,
    );
  });
  testWidgets(
    'edits preserve revision disabled rewards and require explicit save',
    (tester) async {
      Map<String, dynamic>? saved;
      final data = {
        'revision': 7,
        'rules': {
          'enabled': false,
          'titles': [
            {
              'level': 1,
              'enabled': false,
              'min_player_level': 5,
              'completed_task': 1001,
              'matches': 10,
              'wins': 3,
              'choices': [7, 8],
            },
          ],
        },
      };
      await tester.pumpWidget(
        MaterialApp(
          home: TitleConfigPage(
            environment: '线上服务器',
            api: (r) async {
              if (r['operation'] == 'titles_save') saved = r;
              return data;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('称号规则 · 线上服务器'), findsOneWidget);
      await tester.tap(find.text('称号 1 · 关闭'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('title-choices')),
        '7,7',
      );
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(find.textContaining('输入错误'), findsOneWidget);
      expect(saved, isNull);
      await tester.enterText(
        find.byKey(const ValueKey('title-choices')),
        '9,8',
      );
      await tester.enterText(find.byKey(const ValueKey('title-matches')), '20');
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(saved, isNull);
      await tester.tap(find.text('保存称号配置'));
      await tester.pumpAndSettle();
      expect(saved!['titles']['revision'], 7);
      expect(saved!['titles']['rules']['enabled'], false);
      final row = saved!['titles']['rules']['titles'][0];
      expect(row['matches'], 20);
      expect(row['completed_task'], 1001);
      expect(row['choices'], [9, 8]);
      expect(row['enabled'], false);
    },
  );
  testWidgets('save errors preserve edited draft', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TitleConfigPage(
          environment: '本地测试服',
          api: (r) async {
            if (r['operation'] == 'titles_save') throw Exception('版本冲突');
            return {
              'revision': 2,
              'rules': {'enabled': false, 'titles': []},
            };
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('新增称号规则'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('title-choices')), '7');
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存称号配置'));
    await tester.pumpAndSettle();
    expect(find.textContaining('版本冲突'), findsOneWidget);
    expect(find.text('称号 1 · 关闭'), findsOneWidget);
  });

  testWidgets(
    'catalogue merge preserves existing values and never auto saves',
    (tester) async {
      Map<String, dynamic>? saved;
      final data = {
        'revision': 9,
        'rules': {
          'enabled': false,
          'titles': [
            {
              'level': 1,
              'enabled': false,
              'min_player_level': 5,
              'completed_task': 0,
              'matches': 10,
              'wins': 3,
              'choices': [7],
            },
          ],
        },
      };
      await tester.pumpWidget(
        MaterialApp(
          home: TitleConfigPage(
            environment: '本地测试服',
            api: (r) async {
              if (r['operation'] == 'title_catalog') {
                return {
                  'client_hash': 'a'.padRight(64, 'a'),
                  'titles': [
                    {'level': 0, 'name': '初始称号'},
                    {'level': 1, 'name': '少年'},
                    {'level': 2, 'name': '新秀'},
                  ],
                };
              }
              if (r['operation'] == 'titles_save') saved = r;
              return data;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text('读取客户端称号并补充缺项'));
        await tester.pumpAndSettle();
      }
      expect(saved, isNull);
      expect(find.text('称号 2 · 关闭'), findsOneWidget);
      expect(find.text('称号 0 · 关闭'), findsNothing);
      expect(find.textContaining('新秀'), findsOneWidget);
      await tester.tap(find.text('保存称号配置'));
      await tester.pumpAndSettle();
      final rows = saved!['titles']['rules']['titles'] as List;
      expect(rows.length, 2);
      expect(rows[0]['choices'], [7]);
      expect(rows[0]['matches'], 10);
      expect(rows[1]['choices'], isEmpty);
      expect(rows[1]['enabled'], false);
      expect(saved!['titles']['revision'], 9);
      expect(saved!['titles']['rules']['client_hash'], 'a'.padRight(64, 'a'));
      expect(saved!['titles']['rules']['catalogue'].length, 3);
    },
  );
  testWidgets('bad catalogue preserves draft; online-only hides local reader', (
    tester,
  ) async {
    final data = {
      'revision': 1,
      'rules': {'enabled': false, 'titles': []},
    };
    Future<dynamic> api(Map<String, dynamic> r) async =>
        r['operation'] == 'title_catalog'
        ? {
            'titles': [
              {'level': 1, 'name': 'A'},
              {'level': 1, 'name': 'B'},
            ],
          }
        : data;
    await tester.pumpWidget(
      MaterialApp(
        home: TitleConfigPage(environment: '本地测试服', api: api),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('读取客户端称号并补充缺项'));
    await tester.pumpAndSettle();
    expect(find.textContaining('重复条目'), findsOneWidget);
    expect(find.text('称号 1 · 关闭'), findsNothing);
    await tester.pumpWidget(
      MaterialApp(
        home: TitleConfigPage(
          key: const ValueKey('online'),
          environment: '线上服务器',
          canReadClient: false,
          api: api,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('读取客户端称号并补充缺项'), findsNothing);
  });
}
