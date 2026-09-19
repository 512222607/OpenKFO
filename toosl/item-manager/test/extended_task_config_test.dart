import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/extended_task_config.dart';

void main() {
  final conditions = [
    {'key': 0, 'required': 1},
    {'key': 3, 'required': 1},
    {'key': 0, 'required': 0},
  ];
  testWidgets('import preserves rewards, validates edits and applies a draft', (
    tester,
  ) async {
    final initial = <String, dynamic>{
      'client_hash': 'a' * 64,
      'catalogue': [
        {
          'kind': 'daily',
          'id': 2001,
          'conditions': [
            {...conditions[0], 'event': 'tutorial_complete'},
            conditions[1],
            conditions[2],
          ],
        },
      ],
      'tasks': [
        {
          'kind': 'daily',
          'id': 2001,
          'enabled': false,
          'experience': 20,
          'gold': 50,
          'reward_catalog': 0,
        },
      ],
    };
    Map<String, dynamic>? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => ExtendedTaskConfigPage(
                    environment: '本地',
                    initial: initial,
                    canReadClient: true,
                    api: (r) async {
                      expect(r['operation'], 'task_extended_templates');
                      return {
                        'client_hash': 'a' * 64,
                        'catalogues': {
                          'daily': [
                            {
                              'id': 2001,
                              'name': '每日一',
                              'conditions': conditions,
                            },
                          ],
                          'newbie': [
                            {
                              'id': 3002,
                              'name': '训练',
                              'conditions': conditions,
                            },
                          ],
                        },
                      };
                    },
                  ),
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('读取每日／新手目录'));
    await tester.pumpAndSettle();
    expect(find.textContaining('金币 50'), findsOneWidget);
    await tester.tap(find.textContaining('2001 每日一'));
    await tester.pumpAndSettle();
    final eventField = find.byKey(const ValueKey('extended_event_0'));
    expect(
      tester.widget<DropdownButtonFormField<String>>(eventField).initialValue,
      'tutorial_complete',
    );
    await tester.ensureVisible(eventField);
    await tester.tap(eventField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('有效对战：参加一场').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('extended_gold')), '-1');
    await tester.tap(find.text('应用'));
    await tester.pumpAndSettle();
    expect(find.text('奖励数值无效'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('extended_gold')), '88');
    await tester.tap(find.text('应用'));
    await tester.pumpAndSettle();
    expect(find.textContaining('金币 88'), findsOneWidget);
    expect((initial['tasks'] as List).first['gold'], 50);
    await tester.tap(find.text('新手任务'));
    await tester.pumpAndSettle();
    expect(find.text('3002 训练 · 关闭'), findsOneWidget);
    await tester.tap(find.text('应用到任务配置（待保存）'));
    await tester.pumpAndSettle();
    expect((result!['tasks'] as List).first['gold'], 88);
    expect((result!['tasks'] as List).last['enabled'], false);
    expect(
      (result!['catalogue'] as List).first['conditions'][0]['event'],
      'battle_play',
    );
    expect(
      (initial['catalogue'] as List).first['conditions'][0]['event'],
      'tutorial_complete',
    );
  });
  testWidgets('wrong client version preserves draft', (tester) async {
    final initial = <String, dynamic>{
      'client_hash': 'a' * 64,
      'catalogue': [
        {'id': 2001, 'kind': 'daily', 'conditions': conditions},
      ],
      'tasks': [
        {
          'id': 2001,
          'kind': 'daily',
          'enabled': false,
          'experience': 9,
          'gold': 10,
        },
      ],
    };
    await tester.pumpWidget(
      MaterialApp(
        home: ExtendedTaskConfigPage(
          environment: '线上',
          initial: initial,
          canReadClient: true,
          api: (r) async => {'client_hash': 'b' * 64},
        ),
      ),
    );
    await tester.tap(find.text('读取每日／新手目录'));
    await tester.pumpAndSettle();
    expect(find.textContaining('客户端版本与已有配置不同'), findsOneWidget);
    expect(find.textContaining('金币 10'), findsOneWidget);
  });
}
