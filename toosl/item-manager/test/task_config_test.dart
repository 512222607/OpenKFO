import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kungfu_item_manager/task_config.dart';

void main() {
  testWidgets(
    'template merge preserves existing rules and requires explicit save',
    (tester) async {
      final existing = <String, dynamic>{
        'id': 1001,
        'next': 0,
        'enabled': true,
        'matches': 99,
        'max_combo': 0,
        'experience': 200,
        'gold': 50,
        'counters': List.filled(29, 0),
      };
      final template = <String, dynamic>{
        'id': 1001,
        'next': 1002,
        'enabled': true,
        'name': '初入江湖',
        'description': '参加对战',
        'matches': 10,
        'max_combo': 0,
        'counters': List.filled(29, 0),
        'unknown_reward': 999,
        'title_level': 2,
        'item': 200001,
      };
      Map<String, dynamic>? saved;
      final extended = <String, dynamic>{
        'client_hash': 'b' * 64,
        'catalogue': [
          {'kind': 'daily', 'id': 2001, 'conditions': []},
        ],
        'tasks': [
          {'kind': 'daily', 'id': 2001, 'enabled': false, 'gold': 100},
        ],
      };
      await tester.pumpWidget(
        MaterialApp(
          home: TaskConfigPage(
            environment: '线上服务器',
            api: (r) async {
              if (r['operation'] == 'task_templates') {
                return {
                  'client_hash': 'a' * 64,
                  'templates': [
                    template,
                    {...template, 'id': 1002, 'next': 0, 'name': '再战'},
                  ],
                };
              }
              if (r['operation'] == 'tasks_save') {
                saved = r;
                return {'revision': 8, 'rules': r['tasks']['rules']};
              }
              return {
                'revision': 7,
                'rules': {
                  'enabled': true,
                  'tasks': [existing],
                  'extended': extended,
                },
              };
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text('读取客户端模板并补充缺项'));
        await tester.pumpAndSettle();
      }
      expect(saved, isNull);
      expect(find.text('任务 1002 · 关闭'), findsOneWidget);
      expect(find.textContaining('再战'), findsOneWidget);
      await tester.tap(find.text('保存任务配置'));
      await tester.pumpAndSettle();
      final rules = saved!['tasks']['rules'];
      expect(saved!['tasks']['revision'], 7);
      expect(rules['enabled'], true);
      expect(rules['extended'], extended);
      expect(rules['client_hash'], 'a' * 64);
      expect(rules['catalogue'].length, 2);
      expect(rules['catalogue'][0]['title_level'], 2);
      expect(rules['tasks'].length, 2);
      expect(rules['tasks'][0], existing);
      expect(rules['tasks'][1]['experience'], 0);
      expect(rules['tasks'][1]['gold'], 0);
      expect(rules['tasks'][1]['enabled'], false);
      expect(rules['tasks'][1].containsKey('item'), false);
    },
  );
  testWidgets('invalid template leaves current draft intact', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TaskConfigPage(
          environment: '本地测试服',
          api: (r) async => r['operation'] == 'task_templates'
              ? {
                  'client_hash': 'a' * 64,
                  'templates': [
                    {
                      'id': 1001,
                      'name': '坏模板',
                      'title_level': 0,
                      'enabled': true,
                      'next': 0,
                      'matches': 1,
                      'max_combo': 0,
                      'counters': [1],
                    },
                  ],
                }
              : {
                  'revision': 0,
                  'rules': {'enabled': false, 'tasks': []},
                },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('读取客户端模板并补充缺项'));
    await tester.pumpAndSettle();
    expect(find.textContaining('不是29项'), findsOneWidget);
    expect(find.text('任务 1001 · 关闭'), findsNothing);
  });
  testWidgets('failed read prevents overwriting configuration', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TaskConfigPage(
          environment: '本地测试服',
          api: (_) async => throw Exception('offline'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, '保存任务配置'))
          .onPressed,
      isNull,
    );
    expect(find.textContaining('offline'), findsOneWidget);
  });
  testWidgets('edit preserves revision counters and disabled rules', (
    tester,
  ) async {
    Map<String, dynamic>? saved;
    final counters = List.generate(29, (i) => i);
    final row = {
      'id': 1001,
      'next': 0,
      'enabled': false,
      'matches': 10,
      'max_combo': 0,
      'experience': 200,
      'gold': 50,
      'counters': counters,
      'reward_catalog': 7,
    };
    await tester.pumpWidget(
      MaterialApp(
        home: TaskConfigPage(
          environment: '线上服务器',
          api: (r) async {
            if (r['operation'] == 'tasks_save') {
              saved = r;
              return {'revision': 8, 'rules': r['tasks']['rules']};
            }
            return {
              'revision': 7,
              'rules': {
                'enabled': false,
                'tasks': [row],
              },
            };
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('任务 1001 · 关闭'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('task_matches')), '12');
    await tester.tap(find.text('应用到列表'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存任务配置'));
    await tester.pumpAndSettle();
    expect(saved!['tasks']['revision'], 7);
    expect(saved!['tasks']['rules']['enabled'], false);
    final result = saved!['tasks']['rules']['tasks'][0];
    expect(result['matches'], 12);
    expect(result['counters'], counters);
    expect(result['experience'], 200);
    expect(result['reward_catalog'], 7);
    expect(row['matches'], 10);
  });
  testWidgets('missing successor blocks save and preserves draft', (
    tester,
  ) async {
    var saves = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: TaskConfigPage(
          environment: '本地测试服',
          api: (r) async {
            if (r['operation'] == 'tasks_save') saves++;
            return {
              'revision': 0,
              'rules': {'enabled': false, 'tasks': []},
            };
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('新增任务'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('task_id')), '1001');
    await tester.enterText(find.byKey(const ValueKey('task_next')), '1002');
    await tester.tap(find.text('应用到列表'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存任务配置'));
    await tester.pumpAndSettle();
    expect(saves, 0);
    expect(find.textContaining('后续任务不存在'), findsOneWidget);
    expect(find.text('任务 1001 · 关闭'), findsOneWidget);
  });
}
