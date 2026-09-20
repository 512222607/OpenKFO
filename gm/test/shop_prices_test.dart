import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/shop_config.dart';

void main() {
  testWidgets('bulk prices validate and preserve other fields without reload', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var reads = 0;
    final writes = <Map<String, dynamic>>[];
    final offer = <String, dynamic>{
      'price': 100,
      'currency': 'ticket',
      'days': 30,
      'quantity': 2,
      'enabled': false,
    };
    Future<dynamic> api(Map<String, dynamic> request) async {
      if (request['operation'] == 'shop_catalog') {
        reads++;
        return {
          'items': [
            {'key': '25:1', 'id': 1, 'name': '武器甲', 'stackable': false},
            {'key': '25:2', 'id': 2, 'name': '武器乙', 'stackable': false},
          ],
          'offers': {'25:1': offer},
        };
      }
      writes.add(Map.of(request));
      return {'message': '批量改价完成'};
    }

    await tester.pumpWidget(
      MaterialApp(
        home: ShopConfigPage(api: api, environment: '本地测试服'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('武器甲'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('批量改价'));
    await tester.pumpAndSettle();
    expect(find.textContaining('本地测试服 · 1 件'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('batch-price')), '0');
    await tester.tap(find.text('确认改价'));
    await tester.pumpAndSettle();
    expect(writes, isEmpty);
    await tester.enterText(find.byKey(const ValueKey('batch-price')), '88');
    await tester.tap(find.text('确认改价'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 400));
    expect(writes.single['operation'], 'shop_prices');
    expect(writes.single['keys'], ['25:1']);
    expect(writes.single['price'], 88);
    expect(writes.single.containsKey('enabled'), false);
    expect(reads, 1);
    expect(offer, {
      'price': 88,
      'currency': 'ticket',
      'days': 30,
      'quantity': 2,
      'enabled': false,
    });
    expect(
      tester
          .widget<TextFormField>(find.widgetWithText(TextFormField, '售价'))
          .controller!
          .text,
      '88',
    );
    expect(tester.takeException(), isNull);
  });
}
