import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/training_config.dart';

void main() {
  testWidgets('load failure disables save', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TrainingConfigPage(
          environment: '本地测试服',
          api: (_) async => throw Exception('offline'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, '保存名侠配置'))
          .onPressed,
      isNull,
    );
    expect(find.textContaining('offline'), findsOneWidget);
  });
  testWidgets('preserves revision and disabled values; rejects bad input', (
    tester,
  ) async {
    Map<String, dynamic>? saved;
    final data = {
      'revision': 7,
      'rules': {
        'enabled': false,
        'levels': List.generate(
          9,
          (i) => {'level': i, 'xp_per_hour': 100, 'xp_cap': 500},
        ),
      },
    };
    await tester.pumpWidget(
      MaterialApp(
        home: TrainingConfigPage(
          environment: '本地测试服',
          api: (r) async {
            if (r['operation'] == 'training_save') saved = r;
            return data;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('rate0')), '-1');
    await tester.tap(find.text('保存名侠配置'));
    await tester.pumpAndSettle();
    expect(saved, isNull);
    await tester.enterText(find.byKey(const ValueKey('rate0')), '250');
    await tester.tap(find.text('保存名侠配置'));
    await tester.pumpAndSettle();
    expect(saved!['training']['revision'], 7);
    expect(saved!['training']['rules']['enabled'], false);
    expect(saved!['training']['rules']['levels'][0]['xp_per_hour'], 250);
    expect(saved!['training']['rules']['levels'].length, 9);
  });
}
