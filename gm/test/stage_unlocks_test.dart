import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/stage_unlocks.dart';

void main() {
  final hash = List.filled(64, 'a').join();
  testWidgets(
    'account grants preserve revision on conflict and advance on success',
    (t) async {
      final saves = <Map<String, dynamic>>[];
      await t.pumpWidget(
        MaterialApp(
          home: StageUnlocksPage(
            environment: '本地测试服',
            uid: 17,
            api: (r) async {
              if (r['operation'] == 'stages_get')
                return {
                  'client_hash': hash,
                  'requirements': [
                    {'map_id': 8110, 'name': '地图', 'unlock_required': true},
                  ],
                };
              if (r['operation'] == 'stage_unlocks_get')
                return {
                  'uid': 17,
                  'client_hash': hash,
                  'revision': 4,
                  'maps': <int>[],
                };
              saves.add(Map<String, dynamic>.from(r['stage_unlocks']));
              if (saves.length == 1) throw Exception('版本冲突');
              return {...saves.last, 'revision': 5};
            },
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.textContaining('本地测试服'), findsOneWidget);
      await t.tap(find.byType(CheckboxListTile));
      await t.pumpAndSettle();
      await t.tap(find.text('保存解锁'));
      await t.pumpAndSettle();
      expect(find.textContaining('版本冲突'), findsOneWidget);
      expect(
        t.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
        isTrue,
      );
      await t.tap(find.text('保存解锁'));
      await t.pumpAndSettle();
      expect(saves[0], {
        'uid': 17,
        'client_hash': hash,
        'revision': 4,
        'maps': [8110],
      });
      expect(saves[1], saves[0]);
      expect(find.text('已保存'), findsOneWidget);
    },
  );
  testWidgets('wrong account response blocks save', (t) async {
    await t.pumpWidget(
      MaterialApp(
        home: StageUnlocksPage(
          environment: '线上服务器',
          uid: 17,
          api: (r) async {
            if (r['operation'] == 'stages_get')
              return {'client_hash': hash, 'requirements': []};
            return {'uid': 18, 'client_hash': hash, 'revision': 1, 'maps': []};
          },
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(t.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });
}
