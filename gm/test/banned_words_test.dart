import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/banned_words_config.dart';

void main() {
  test('batch parsing trims BOM and deduplicates', () {
    expect(parseBannedWords('\ufeffSB\r\nCNM，SB;SHABI；'), [
      'SB',
      'CNM',
      'SHABI',
    ]);
  });
  testWidgets('list deletion saves selected server revision', (tester) async {
    Map<String, dynamic>? saved;
    await tester.pumpWidget(
      MaterialApp(
        home: BannedWordsPage(
          environment: '本地测试服',
          api: (r) async {
            if (r['operation'] == 'banned_words_save') {
              saved = r;
              return {
                'revision': 8,
                'words': ['SB'],
              };
            }
            return {
              'revision': 7,
              'words': ['SB', 'CNM'],
            };
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('本地测试服 · 违禁词管理'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_outline).last);
    await tester.pump();
    await tester.tap(find.text('保存词库'));
    await tester.pumpAndSettle();
    expect(saved?['banned_words'], {
      'revision': 7,
      'words': ['SB'],
    });
  });
}
