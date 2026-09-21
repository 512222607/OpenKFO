import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/shop_config.dart';

void main() {
  testWidgets('missing image batch delists only verified filtered keys', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1500, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final writes = <Map<String, dynamic>>[];
    Future<dynamic> api(Map<String, dynamic> r) async {
      if (r['operation'] == 'shop_image_status') {
        return {'30:1': true, '12:2': false, '95:3': false};
      }
      if (r['operation'] == 'shop_batch') {
        writes.add(Map.of(r));
        return {'message': '完成'};
      }
      return {
        'items': [
          {
            'key': '30:1',
            'id': 1,
            'kind': 30,
            'name': '有图宠物',
            'stackable': false,
          },
          {
            'key': '12:2',
            'id': 2,
            'kind': 12,
            'name': '无图衣服',
            'stackable': false,
          },
          {
            'key': '95:3',
            'id': 3,
            'kind': 95,
            'name': '无图礼包',
            'stackable': false,
            'supported': false,
          },
        ],
        'offers': <String, dynamic>{},
      };
    }

    await tester.pumpWidget(MaterialApp(home: ShopConfigPage(api: api)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('缺少图片'));
    await tester.pumpAndSettle();
    expect(find.text('无图衣服'), findsNothing);
    await tester.tap(find.text('检测全部商品图片'));
    await tester.pumpAndSettle();
    expect(find.text('无图衣服'), findsOneWidget);
    expect(find.text('无图礼包'), findsOneWidget);
    expect(find.text('有图宠物'), findsNothing);
    await tester.tap(find.text('批量下架当前缺图商品'));
    await tester.pumpAndSettle();
    expect(writes, isEmpty);
    await tester.tap(find.text('确认执行'));
    await tester.pumpAndSettle();
    expect(writes.single['keys'], ['12:2', '95:3']);
    expect(writes.single['all'], false);
    expect(writes.single['enabled'], false);
    expect(tester.takeException(), isNull);
  });
}
