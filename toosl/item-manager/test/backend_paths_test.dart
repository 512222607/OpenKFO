import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/main.dart';

void main() {
  test('EXE resolves adjacent settings independent of working directory', () {
    final temp = Directory.systemTemp.createTempSync('gm-paths-');
    addTearDown(() => temp.deleteSync(recursive: true));
    File('${temp.path}/gm-settings.json').writeAsStringSync(
      jsonEncode({
        'root': 'runtime',
        'local_settings': 'server/settings.private.json',
      }),
    );
    final backend = Backend();
    backend.resolvePaths(
      executableDirectory: temp,
      currentDirectory: Directory('C:/Windows'),
    );
    expect(backend.root, '${temp.path}/runtime');
    expect(backend.localSettings, '${temp.path}/server/settings.private.json');
  });
  test('EXE discovers existing game runtime without CMD arguments', () {
    final temp = Directory.systemTemp.createTempSync('gm-discovery-');
    addTearDown(() => temp.deleteSync(recursive: true));
    final runtime = Directory(
      '${temp.path}/kungfukid-local-server/runtime-local',
    )..createSync(recursive: true);
    File('${runtime.path}/online-admin.json').writeAsStringSync('{}');
    final executable = Directory('${temp.path}/OpenKFO/dist/GM')
      ..createSync(recursive: true);
    final backend = Backend();
    backend.resolvePaths(
      executableDirectory: executable,
      currentDirectory: temp,
    );
    expect(
      Directory(backend.root!).absolute.path,
      Directory('${temp.path}/kungfukid-local-server').absolute.path,
    );
  });
}
