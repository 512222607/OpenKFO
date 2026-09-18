import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/shop_config.dart';
import 'package:kungfu_item_manager/wallet_config.dart';

void main() {
  testWidgets('shop saves selected price and duration without granting items', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Map<String, dynamic>? saved;
    var catalogReads = 0;
    Future<dynamic> api(Map<String, dynamic> request) async {
      if (request['operation'] == 'shop_catalog') {
        catalogReads++;
        return {
          'items': [
            {
              'key': '25:253905',
              'id': 253905,
              'name': '骤足',
              'stackable': false,
            },
          ],
          'offers': <String, dynamic>{},
        };
      }
      expect(request['operation'], 'shop_save');
      saved = request;
      return {'message': '商城配置已保存'};
    }

    await tester.pumpWidget(MaterialApp(home: ShopConfigPage(api: api)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('骤足'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile));
    await tester.enterText(find.widgetWithText(TextFormField, '售价'), '88');
    await tester.enterText(
      find.widgetWithText(TextFormField, '装备期限（天）'),
      '365',
    );
    await tester.tap(find.text('保存商城配置'));
    await tester.pumpAndSettle();
    expect(saved?['currency'], 'ticket');
    expect(saved?['price'], 88);
    expect(saved?['days'], 365);
    expect(saved?['enabled'], true);
    expect(
      catalogReads,
      1,
      reason: 'single save must not reload the entire catalog',
    );
    expect(find.text('253905 · 已上架'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'wallet gift requires confirmation and targets selected account',
    (tester) async {
      Map<String, dynamic>? update;
      Future<dynamic> api(Map<String, dynamic> request) async {
        if (request['operation'] == 'wallet_accounts') {
          return [
            {'uid': 1003, 'account': 'localtest', 'tickets': 20},
          ];
        }
        update = request;
        return {'message': '赠送已完成'};
      }

      await tester.pumpWidget(MaterialApp(home: WalletConfigPage(api: api)));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextFormField, '赠送数量'), '80');
      await tester.tap(find.text('确认操作…'));
      await tester.pumpAndSettle();
      expect(update, isNull);
      expect(find.text('localtest：20 → 100 点券'), findsOneWidget);
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(update?['uid'], 1003);
      expect(update?['amount'], 80);
      expect(update?['mode'], 'gift');
      expect(update?['id'], startsWith('wallet-'));
      expect(tester.takeException(), isNull);
    },
  );
}
