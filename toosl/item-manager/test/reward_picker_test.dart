import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/level_gift_config.dart';

void main() {
  testWidgets('tutorial draft selects client names and currencies without IDs', (t) async {
    t.view.physicalSize = const Size(1300, 1000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final record = Uint8List(68)..[4] = 25;
    ByteData.sublistView(record).setUint32(5, 253001, Endian.little);
    List<Map<String, dynamic>>? result;
    Future<dynamic> api(Map<String, dynamic> r) async {
      switch (r['operation']) {
        case 'catalog': return {'items': [{'kind':25,'id':253001,'key':'25:253001','name':'凌云神腕','category':'武器'}]};
        case 'definitions_get': return [{'key':321,'record':base64Encode(record),'days':7}];
        default: throw StateError('Unexpected mutation: $r');
      }
    }
    await t.pumpWidget(MaterialApp(home: Builder(builder:(c) => TextButton(onPressed:() async {
      result = await showDialog<List<Map<String,dynamic>>>(context:c, builder:(_) => LevelGiftDialog(tutorial:true, gifts:const [{'items':[],'gold':0,'tickets':0}], api:api));
    },child:const Text('打开')))));
    await t.tap(find.text('打开')); await t.pumpAndSettle();
    await t.enterText(find.byType(TextFormField).first,'100');
    await t.enterText(find.byType(TextFormField).last,'50');
    await t.tap(find.text('选择武器 / 道具 / 称号')); await t.pumpAndSettle();
    await t.enterText(find.byType(TextField).last, '凌云'); await t.pumpAndSettle();
    await t.tap(find.text('凌云神腕')); await t.pumpAndSettle();
    expect(find.textContaining('凌云神腕'),findsOneWidget);
    expect(find.text('物品定义编号'),findsNothing);
    await t.tap(find.text('应用到草稿')); await t.pumpAndSettle();
    expect(result, [{'items':[321],'gold':100,'tickets':50}]);
    expect(t.takeException(),isNull);
  });
}
