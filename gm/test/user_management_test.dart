import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/user_management.dart';

void main() {
  testWidgets('search targets UID and ban requires reason', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final writes = <Map<String, dynamic>>[];
    Future<dynamic> api(Map<String, dynamic> r) async {
      if (r['operation'] == 'users_list') {
        return [for (int id = 1; id <= 2; id++) {
          'uid': id, 'account': 'test00$id', 'nickname': '角色$id',
          'gold': 0, 'tickets': 0, 'banned': false, 'expires_at': 0, 'reason': '',
        }];
      }
      writes.add(r);
      return {};
    }
    await tester.pumpWidget(MaterialApp(home: UserManagementPage(api: api, environment: '线下')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'test002');
    await tester.pumpAndSettle();
    expect(find.textContaining('test001'), findsNothing);
    await tester.tap(find.text('封禁'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();
    expect(writes, isEmpty);
    expect(find.text('请填写原因'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, '测试原因');
    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();
    expect(writes.single['uid'], 2);
    expect(writes.single['enabled'], true);
    expect(writes.single['reason'], '测试原因');
    expect(writes.single['expires_at'], greaterThan(DateTime.now().millisecondsSinceEpoch ~/ 1000));
  });
}
