import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/level_gift_config.dart';

void main() {
  testWidgets(
    'level gift draft returns configured IDs without inventing rewards',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      List<Map<String, dynamic>>? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showDialog<List<Map<String, dynamic>>>(
                    context: context,
                    builder: (_) => const LevelGiftDialog(
                      gifts: [
                        {
                          'level': 5,
                          'items': [7, 8],
                        },
                      ],
                    ),
                  );
                },
                child: const Text('编辑'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('编辑'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '1');
      await tester.tap(find.text('应用到草稿'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      await tester.enterText(find.byType(TextFormField).first, '10');
      await tester.tap(find.text('应用到草稿'));
      await tester.pumpAndSettle();
      expect(result, [
        {
          'level': 10,
          'items': [7, 8],
        },
      ]);
      expect(tester.takeException(), isNull);
    },
  );
}
