import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/weapon_config.dart';

void main() {
  testWidgets(
    'weapon icons, descriptions and type filters keep combo selection',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final folder = Directory.systemTemp.createTempSync('weapon-icon-');
      addTearDown(() => folder.deleteSync(recursive: true));
      final icon = File('${folder.path}/icon.png')
        ..writeAsBytesSync(
          base64Decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
          ),
        );
      final calls = <String>[];
      Map<String, dynamic> weapon(
        int id,
        String name,
        String type,
        String path,
      ) => {
        'id': id,
        'name': name,
        'type': type,
        'icon': path,
        'description': '$name 的原始简介',
        'stages': <dynamic>[],
        'combos': [
          {
            'name': '$name 连招',
            'nodes': [
              {'state': '1', 'keys': 'CCX'},
            ],
          },
        ],
      };
      await tester.pumpWidget(
        MaterialApp(
          home: WeaponConfigPage(
            api: (request) async {
              calls.add('${request['operation']}');
              return {
                'revision': 'test',
                'drafts': <String, dynamic>{},
                'applied': <String, dynamic>{},
                'weapons': [
                  weapon(1, '烈焰刀', '刀类', icon.path),
                  weapon(2, '寒冰剑', '剑类', ''),
                ],
              };
            },
          ),
        ),
      );
      await tester.runAsync(() async {
        await precacheImage(
          FileImage(icon),
          tester.element(find.byType(WeaponConfigPage)),
        );
      });
      await tester.pumpAndSettle();
      expect(find.text('烈焰刀 的原始简介'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
      expect(
        tester.getTopLeft(find.text('武器简介')).dy,
        lessThan(tester.getTopLeft(find.text('连招与命中效果')).dy),
      );
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('剑类').last);
      await tester.pumpAndSettle();
      expect(find.text('共 1 件武器'), findsOneWidget);
      expect(find.widgetWithText(ListTile, '烈焰刀'), findsNothing);
      await tester.tap(find.widgetWithText(ListTile, '寒冰剑'));
      await tester.pumpAndSettle();
      expect(find.text('寒冰剑 的原始简介'), findsOneWidget);
      expect(find.text('CCX'), findsOneWidget);
      expect(find.byIcon(Icons.sports_martial_arts), findsNWidgets(2));
      await tester.enterText(find.byType(TextField), '不存在');
      await tester.pumpAndSettle();
      expect(find.text('共 0 件武器'), findsOneWidget);
      expect(calls, ['weapon_catalog']);
      expect(tester.takeException(), isNull);
    },
  );
}
