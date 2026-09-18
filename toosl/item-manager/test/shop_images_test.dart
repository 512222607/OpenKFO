import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/shop_config.dart';

void main() {
  testWidgets(
    'scrolling builds a bounded viewport and loads images on demand',
    (tester) async {
      tester.view.physicalSize = const Size(1180, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final requests = <List<dynamic>>[];
      Future<dynamic> api(Map<String, dynamic> request) async {
        if (request['operation'] == 'shop_images') {
          requests.add(List.of(request['keys']));
          return <String, dynamic>{};
        }
        return {
          'items': List.generate(
            1000,
            (i) => {
              'key': '25:$i',
              'id': i,
              'kind': 25,
              'name': '测试武器$i',
              'stackable': false,
              'fields': List.filled(10, ''),
            },
          ),
          'offers': <String, dynamic>{},
        };
      }

      await tester.pumpWidget(MaterialApp(home: ShopConfigPage(api: api)));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(requests.single.length, lessThanOrEqualTo(24));
      expect(find.byType(Card).evaluate().length, lessThan(30));
      expect(find.text('测试武器999'), findsNothing);
      await tester.tap(find.byType(Checkbox).first);
      await tester.drag(find.byType(GridView), const Offset(0, -1000));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(requests.length, greaterThan(1));
      expect(requests.every((keys) => keys.length <= 24), isTrue);
      expect(find.byType(Card).evaluate().length, lessThan(30));
      expect(find.text('已选 1 件'), findsOneWidget);
      await tester.tap(find.text('推荐/优惠'));
      await tester.pumpAndSettle();
      expect(find.textContaining('协议字段待核实'), findsOneWidget);
      await tester.tap(find.text('武器'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(find.text('测试武器0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
