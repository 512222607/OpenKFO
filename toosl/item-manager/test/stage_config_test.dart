import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kungfu_item_manager/stage_config.dart';

void main() {
  testWidgets('stage gates preserve revision and selected environment page', (
    tester,
  ) async {
    Map<String, dynamic>? saved;
    await tester.pumpWidget(
      MaterialApp(
        home: StageConfigPage(
          environment: '本地测试服',
          api: (r) async {
            if (r['operation'] == 'stages_save') {
              saved = r;
              return {
                'revision': 8,
                'disabled_maps': [104, 8110],
              };
            }
            return {
              'revision': 7,
              'requirements_enabled': false,
              'client_hash': 'a'.padRight(64, 'a'),
              'requirements': [
                {'map_id': 8110, 'name': 'Map', 'title_level': 3},
              ],
              'disabled_maps': [104],
            };
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('关卡开关 · 本地测试服'), findsOneWidget);
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('关闭').last);
    await tester.pump();
    await tester.tap(find.text('保存关卡开关'));
    await tester.pumpAndSettle();
    expect(saved?['stage_access'], {
      'revision': 7,
      'requirements_enabled': false,
      'client_hash': 'a'.padRight(64, 'a'),
      'requirements': [
        {'map_id': 8110, 'name': 'Map', 'title_level': 3},
      ],
      'disabled_maps': [104, 8110],
      'force_open_all': false,
      'force_open_maps': [],
    });
    expect(find.textContaining('已保存到 本地测试服'), findsOneWidget);
  });
  testWidgets('read failure never enables save', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StageConfigPage(
          environment: '线上服务器',
          api: (r) async => throw Exception('unavailable'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(find.textContaining('操作失败'), findsOneWidget);
  });

  testWidgets(
    'import and edit requirements preserves existing gates and version',
    (tester) async {
      Map<String, dynamic>? saved;
      final hash = 'a'.padRight(64, 'a');
      final data = {
        'revision': 7,
        'disabled_maps': [104],
        'client_hash': hash,
        'requirements_enabled': false,
        'requirements': [
          {'map_id': 8110, 'name': 'Existing', 'title_level': 3},
        ],
      };
      await tester.pumpWidget(
        MaterialApp(
          home: StageConfigPage(
            environment: '本地测试服',
            api: (r) async {
              if (r['operation'] == 'stage_requirements') {
                return {
                  'client_hash': hash,
                  'pve_maps': [
                    {'map_id': 8110},
                    {'map_id': 8111},
                    {'map_id': 8110},
                  ],
                  'maps': [
                    {'map_id': 0, 'name': 'Random', 'title_level': 0},
                    {'map_id': 8110, 'name': 'A', 'title_level': 1},
                    {'map_id': 8111, 'name': 'B', 'title_level': 2},
                  ],
                };
              }
              if (r['operation'] == 'stages_save') {
                saved = r;
              }
              return data;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text('读取客户端地图条件'));
        await tester.pumpAndSettle();
      }
      expect(saved, isNull);
      expect(find.text('Existing · 8110'), findsOneWidget);
      expect(find.text('B · 8111'), findsOneWidget);
      expect(find.text('Random · 0'), findsNothing);
      await tester.tap(find.text('B · 8111'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('stage-title')), '256');
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(find.text('请输入0–255的整数'), findsOneWidget);
      await tester.enterText(find.byKey(const ValueKey('stage-title')), '4');
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('启用地图准入条件'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        true,
      );
      await tester.tap(find.text('启用地图准入条件'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        false,
      );
      expect(find.text('最低称号 4'), findsOneWidget);
      await tester.tap(find.text('保存关卡开关'));
      await tester.pumpAndSettle();
      final access = saved!['stage_access'];
      expect(access['revision'], 7);
      expect(access['pve_maps'], [8110, 8111]);
      expect(access['disabled_maps'], [104]);
      expect(access['requirements_enabled'], false);
      expect(access['requirements'].length, 2);
      expect(access['requirements'][0]['title_level'], 3);
      expect(access['requirements'][1]['title_level'], 4);
    },
  );
  testWidgets('mismatched catalogue rejected and online reader hidden', (
    tester,
  ) async {
    final data = {
      'revision': 1,
      'disabled_maps': [],
      'client_hash': 'a'.padRight(64, 'a'),
      'requirements': [
        {'map_id': 8110, 'name': 'Existing', 'title_level': 3},
      ],
    };
    Future<dynamic> api(Map<String, dynamic> r) async =>
        r['operation'] == 'stage_requirements'
        ? {'client_hash': 'b'.padRight(64, 'b'), 'maps': []}
        : data;
    await tester.pumpWidget(
      MaterialApp(
        home: StageConfigPage(environment: '本地测试服', api: api),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('读取客户端地图条件'));
    await tester.pumpAndSettle();
    expect(find.textContaining('目录版本不同'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        home: StageConfigPage(
          key: const ValueKey('online'),
          environment: '线上服务器',
          canReadClient: false,
          api: api,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('读取客户端地图条件'), findsNothing);
  });
}
