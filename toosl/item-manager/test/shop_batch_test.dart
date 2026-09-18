import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/shop_config.dart';

void main() {
  testWidgets('selection is explicit and retry retains operation id', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final writes = <Map<String, dynamic>>[];
    Future<dynamic> api(Map<String, dynamic> request) async {
      if (request['operation'] == 'shop_catalog') {
        return {
          'items': [
            {
              'key': '25:1',
              'id': 1,
              'kind': 25,
              'name': '武器甲',
              'stackable': false,
            },
            {
              'key': '25:2',
              'id': 2,
              'kind': 25,
              'name': '武器乙',
              'stackable': false,
            },
          ],
          'offers': <String, dynamic>{},
        };
      }
      writes.add(Map.of(request));
      if (writes.length == 1) throw Exception('SSH unavailable');
      return {'message': 'updated'};
    }

    await tester.pumpWidget(MaterialApp(home: ShopConfigPage(api: api)));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    for (var attempt = 0; attempt < 2; attempt++) {
      await tester.tap(find.text('选中上架'));
      await tester.pumpAndSettle();
      expect(find.textContaining('100 点券'), findsOneWidget);
      await tester.tap(find.text('确认执行'));
      await tester.pumpAndSettle();
    }
    expect(writes.length, 2);
    expect(writes[0]['keys'], ['25:1']);
    expect(writes[0]['all'], false);
    expect(writes[0]['enabled'], true);
    expect(writes[0]['id'], writes[1]['id']);
    await tester.enterText(find.byType(TextField).first, '武器甲');
    await tester.pumpAndSettle();
    await tester.tap(find.text('全部下架'));
    await tester.pumpAndSettle();
    expect(find.textContaining('当前搜索结果之外'), findsOneWidget);
    await tester.tap(find.text('确认执行'));
    await tester.pumpAndSettle();
    expect(writes.last['all'], true);
    expect(writes.last['enabled'], false);
    expect(writes.last['keys'], isEmpty);
  });
}
