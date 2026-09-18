import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/main.dart';
import 'package:kungfu_item_manager/main_online.dart';

void main() {
  test('online backend refuses insecure URLs and local operations', () async {
    final token = 'x' * 32;
    for (final url in [
      'http://example.com/gm/api',
      'https://user@example.com/gm/api',
      'https://example.com/gm/api?token=x',
      'https://example.com/kk/tunnel',
    ]) {
      expect(() => OnlineBackend(url, token), throwsFormatException);
    }
    expect(
      () => OnlineBackend('https://example.com/gm/api', 'short'),
      throwsFormatException,
    );
    final backend = OnlineBackend('https://example.com/gm/api', token);
    await expectLater(backend.call({'environment': 'local'}), throwsStateError);
  });
  testWidgets(
    'online mode forces online environment and hides weapon editing',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final requests = <Map<String, dynamic>>[];
      Future<dynamic> api(Map<String, dynamic> r) async {
        requests.add(r);
        if (r['operation'] == 'catalog')
          return {'root': '', 'items': <dynamic>[]};
        return <dynamic>[];
      }

      await tester.pumpWidget(
        MaterialApp(home: Manager(api: api, onlineOnly: true)),
      );
      await tester.pumpAndSettle();
      expect(requests.every((r) => r['environment'] == 'online'), true);
      expect(find.text('武器配置（客户端）'), findsNothing);
      expect(find.text('本地测试服'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('phone connection page has no layout exception', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const OnlineManagerApp());
    await tester.pumpAndSettle();
    expect(find.text('连接线上服务器'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
