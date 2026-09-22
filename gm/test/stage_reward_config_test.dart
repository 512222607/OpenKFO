import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/stage_reward_config.dart';
import 'package:kungfu_item_manager/reward_table.dart';

void main() {
  testWidgets('single map save preserves siblings and retains failed draft', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final other = <String, dynamic>{
      'map_id': 9170,
      'clear': {'gold': 30},
      'failed': {'gold': 5},
    };
    List<Map<String, dynamic>>? saved;
    await tester.pumpWidget(
      MaterialApp(
        home: StageRewardDialog(
          mapId: 8110,
          rows: [other],
          api: (r) async {
            switch (r['operation']) {
              case 'stages_get':
                return {
                  'pve_maps': [8110, 9170],
                  'requirements': [
                    {'map_id': 8110, 'name': '森林'},
                    {'map_id': 9170, 'name': '城堡'},
                  ],
                };
              case 'catalog':
                return {'items': []};
              case 'definitions_get':
                return [];
            }
            throw StateError('unexpected request');
          },
          onSave: (rows) async {
            saved = rows;
            throw StateError('revision conflict');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('城堡'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('8110-clear-gold')),
      '789',
    );
    await tester.tap(find.text('保存地图奖励'));
    await tester.pumpAndSettle();
    expect(saved!.first, other);
    expect(saved!.last['clear']['gold'], 789);
    expect(find.textContaining('revision conflict'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('8110-clear-gold')))
          .initialValue,
      '789',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('map names, draft isolation and validation', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Future<dynamic> api(Map<String, dynamic> request) async {
      switch (request['operation']) {
        case 'stages_get':
          return {
            'pve_maps': [20051],
            'requirements': [
              {'map_id': 20051, 'name': '僵尸防御'},
            ],
          };
        case 'catalog':
          return {'items': []};
        case 'definitions_get':
          return [];
      }
      throw StateError('unexpected operation');
    }

    final original = <Map<String, dynamic>>[
      {
        'map_id': 20051,
        'clear': {'experience': 20, 'items': <int>[]},
        'failed': {'gold': 1, 'items': <int>[]},
      },
    ];
    List<Map<String, dynamic>>? draft;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                draft = await showDialog<List<Map<String, dynamic>>>(
                  context: context,
                  builder: (_) => StageRewardDialog(rows: original, api: api),
                );
              },
              child: const Text('打开'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('僵尸防御'));
    await tester.pumpAndSettle();
    final field = find.byKey(const ValueKey('20051-clear-experience'));
    await tester.enterText(field, '-1');
    await tester.tap(find.text('应用到草稿'));
    await tester.pumpAndSettle();
    expect(find.textContaining('须为0–1000000'), findsOneWidget);
    expect(draft, isNull);
    await tester.enterText(field, '123');
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(original.single['clear']['experience'], 20);
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('僵尸防御'));
    await tester.pumpAndSettle();
    await tester.enterText(field, '123');
    await tester.tap(find.text('应用到草稿'));
    await tester.pumpAndSettle();
    expect(draft?.single['clear']['experience'], 123);
    expect(original.single['clear']['experience'], 20);
    expect(tester.takeException(), isNull);
  });

  test('cross-environment preview includes stage rewards', () {
    expect(
      rewardDiff({
        'stage_rewards': [
          {'map_id': 20051},
        ],
      }, {}).any((line) => line.startsWith('关卡奖励')),
      isTrue,
    );
  });
}
