import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'frame_mode.dart';

String hashBytes(List<int> bytes) => sha256.convert(bytes).toString();
Future<String> fileHash(String path) async =>
    (await sha256.bind(File(path).openRead()).first).toString();
Future<void> writeAtomic(String path, List<int> bytes) async {
  final file = File(path);
  await file.parent.create(recursive: true);
  final temp = File('$path.${DateTime.now().microsecondsSinceEpoch}.tmp');
  try {
    await temp.writeAsBytes(bytes, flush: true);
    await temp.rename(path);
  } finally {
    if (await temp.exists()) await temp.delete();
  }
}

String publicError(Object error) => error
    .toString()
    .replaceAll(RegExp(r'(?:https?|wss?|tls)://[^\s"<>]+'), '[NET_ENDPOINT]')
    .replaceAll(
      RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}(?::\d+)?\b'),
      '[NET_ADDRESS]',
    );

class GameDirectoryError implements Exception {
  @override
  String toString() => '请放到游戏目录下\n\n请将完整启动器文件夹中的文件放到游戏目录，与 Data 文件夹同级，然后重新打开。';
}

class LauncherService {
  final String root;
  late Map<String, dynamic> config;
  late Map<String, dynamic> components;
  late String game;
  String credentialsKey = 'LS1KuGmfVgqfuRT2';
  LauncherService(this.root);
  String get payload => p.join(root, 'launcher-files');
  String get support => p.join(root, 'LauncherSupport.exe');
  String get shared => p.join(game, 'launcher-components', 'shared');
  String get clientExecutable {
    final name = config['client_executable'] ?? 'gfld.dat';
    if (name != 'gfld.dat' && name != 'gfxz.dat') {
      throw Exception('不支持的游戏客户端，请选择 gfld.dat 或 gfxz.dat');
    }
    return name as String;
  }
  Uri get endpoint => Uri.parse(config['url'] as String);
  bool get local => ['127.0.0.1', 'localhost', '::1'].contains(endpoint.host);
  String resolve(String name) => p.normalize(p.join(root, name));
  String get configPath {
    final name = p.basename(Platform.resolvedExecutable);
    return p.join(root, name.contains('线下') || name.contains('本地')
        ? 'bridge.local.json' : 'bridge.json');
  }
  Future<dynamic> native(Map<String, dynamic> request) async {
    final process = await Process.start(support, [], workingDirectory: root);
    process.stdin.write(jsonEncode(request));
    await process.stdin.close();
    final output = utf8.decoder.bind(process.stdout).join();
    final errors = utf8.decoder.bind(process.stderr).join();
    final text = await output;
    await errors;
    if (await process.exitCode != 0) throw Exception('本地辅助组件执行失败');
    final response = jsonDecode(text) as Map<String, dynamic>;
    if (response['ok'] != true) throw Exception(response['error']);
    return response['result'];
  }

  Future<void> init() async {
    components = jsonDecode(
      await File(p.join(payload, 'files.json')).readAsString(),
    );
    for (final name in [
      'bridge.json',
      'launcher-certificates/online/origin.crt',
      'launcher-certificates/online/login.crt',
      'launcher-certificates/online/login.key',
    ]) {
      final target = p.join(root, name);
      if (!await File(target).exists()) {
        await writeAtomic(target, await component(name));
      }
    }
    config = jsonDecode(await File(configPath).readAsString());
    config.putIfAbsent('update_version_url', () => 'https://openkfo.oss-cn-hangzhou.aliyuncs.com/version/version.json');
    game = p.normalize(
      p.absolute(root, config['client_directory'] as String? ?? '.'),
    );
    if (config['shared_client'] != true) {
      throw Exception('这个版本需要共享客户端配置，请使用配套完整启动器 ZIP。');
    }
  }

  Future<List<int>> component(String name) async {
    final bytes = await File(p.join(payload, name)).readAsBytes();
    if (components[name] != hashBytes(bytes)) {
      throw Exception('组件校验失败，请重新解压完整启动器 ZIP：$name');
    }
    return bytes;
  }

  Future<void> validate() async {
    if (!await File(p.join(game, 'Data', 'config.spf2')).exists()) {
      throw GameDirectoryError();
    }
  }

  String credentialsPath(int number) {
    var scope = config['credentials_scope'] as String? ?? endpoint.toString();
    if (endpoint.path.isEmpty && config['credentials_scope'] == null) {
      scope = '$scope/';
    }
    return p.join(
      Platform.environment['LOCALAPPDATA']!,
      'OpenKFO',
      'Launcher',
      hashBytes(utf8.encode(scope)).substring(0, 16),
      'window-$number',
      'credentials.bin',
    );
  }

  Future<Map<String, dynamic>> loadAccount(int n) async {
    final dest = credentialsPath(n);
    if (!await File(dest).exists()) {
      final old = p.join(
        root,
        'launcher-components',
        'window-$n',
        'credentials.bin',
      );
      if (await File(old).exists()) {
        final value = Map<String, dynamic>.from(
          await native({'Op': 'load', 'Path': old}),
        );
        await saveAccount(n, value['Account'] ?? '', value['Password'] ?? '');
        // Keep legacy record until the new release has been accepted in live testing.
      }
    }
    return Map<String, dynamic>.from(
      await native({'Op': 'load', 'Path': dest}),
    );
  }

  Future<void> saveAccount(int n, String account, String password) async =>
      await native({
        'Op': 'save',
        'Path': credentialsPath(n),
        'Account': account,
        'Password': password,
        'Key': credentialsKey,
      });
  Future<Map<String, dynamic>?> state(int n) async {
    try {
      final state = jsonDecode(
        await File(p.join(shared, 'window-$n.json')).readAsString(),
      ) as Map<String, dynamic>;
      final alive = await native({
        'Op': 'window',
        'Action': 'status',
        'PID': state['PID'],
        'Created': state['Created'],
        'Image': p.join(game, clientExecutable),
      });
      return alive == true ? state : null;
    } on FileSystemException {
      return null;
    } on FormatException {
      return null;
    }
  }

  Future<void> show(int n) async {
    final s = await state(n);
    if (s != null) {
      await native({
        ...s,
        'Op': 'window',
        'Action': 'show',
        'Image': p.join(game, clientExecutable),
      });
    }
  }

  Future<String> health() async {
    final watch = Stopwatch()..start();
    if (endpoint.scheme != 'tls') throw Exception('此版本使用直连服务器，请检查配套配置。');
    final pem = await File(resolve(config['server_certificate']))
        .readAsString();
    final context=SecurityContext(withTrustedRoots:false)..setTrustedCertificatesBytes(utf8.encode(pem));
    final raw=await Socket.connect(endpoint.host,endpoint.port,timeout:const Duration(seconds:8));
    late SecureSocket socket;
    try {socket=await SecureSocket.secure(raw,host:'kk-origin',context:context).timeout(const Duration(seconds:8));}
    catch (_) {raw.destroy();rethrow;}
    try {
      final connect = watch.elapsedMilliseconds;
      watch.reset();
      socket.write('{"op":"health"}\n');
      await socket.flush();
      final line = await socket
          .cast<List<int>>().transform(utf8.decoder)
          .transform(const LineSplitter())
          .first
          .timeout(const Duration(seconds: 8));
      final data = jsonDecode(line);
      if (data['op'] != 'health' || data['value'] != 1) {
        throw Exception('服务器状态异常');
      }
      final key = data['launcher_credentials_key'];
      if (key is String && RegExp(r'^[!-~]{16}$').hasMatch(key)) {
        credentialsKey = key;
      }
      return '请求往返 ${watch.elapsedMilliseconds} ms · 连接准备 $connect ms';
    } finally {
      socket.destroy();
    }
  }

  Future<void> install(
    String name,
    String destination, {
    bool backup = true,
  }) async {
    final bytes = await component(name);
    final file = File(destination);
    if (await file.exists()) {
      final old = await fileHash(destination);
      if (old == hashBytes(bytes)) return;
      if (backup) {
        final copy = File(
          p.join(
            game,
            'launcher-components',
            'backups',
            old,
            p.basename(destination),
          ),
        );
        if (!await copy.exists()) {
          await copy.parent.create(recursive: true);
          await file.copy(copy.path);
        }
      }
    }
    try {
      await writeAtomic(destination, bytes);
    } on FileSystemException {
      throw Exception('组件正在使用，原文件已保留。请关闭游戏后重试：${p.basename(destination)}');
    }
  }

  Future<void> prepare() async {
    await validate();
    if (clientExecutable == 'gfld.dat') {
      await install('gfld.dat', p.join(game, clientExecutable));
    } else {
      final image = File(p.join(game, clientExecutable));
      if (!await image.exists()) {
        throw Exception('游戏目录缺少 gfxz.dat，请放入对应客户端。');
      }
      if (await fileHash(image.path) !=
          '1b7c8676e778c7bd47f55184f927338da3cf70c6aa5f0beb59869ea0f0ac9d4e') {
        throw Exception('gfxz.dat 版本尚未适配，原文件未修改。');
      }
    }
    for (final name in ['SDError.dll', 'libssl-1_1.dll', 'libcrypto-1_1.dll']) {
      await install(name, p.join(game, name));
    }
    // Private 32-bit runtime for the native login DLLs; no system installation.
    for (final name in components.keys.cast<String>().where(
      (name) => name.startsWith('runtime-x86/') &&
          name.endsWith('.dll') && name.split('/').length == 2,
    )) {
      await install(name, p.join(game, p.basename(name)));
    }
    final cert = await File(resolve(config['login_certificate'])).readAsBytes();
    await writeAtomic(p.join(game, 'zz.crt'), cert);
    await install('client-config.xml', p.join(game, 'Data', 'config.xml'));
    await writeAtomic(
      p.join(game, 'server.ini'),
      ascii.encode('[server]\r\nip=127.0.0.1\r\nport=18084\r\n'),
    );
    final settings = File(p.join(game, 'Settings.xml'));
    if (await settings.exists()) {
      final original = latin1.decode(await settings.readAsBytes());
      final re = RegExp(r'(<LoginServer\b[^>]*\bIndex\s*=\s*")[^"]*(")');
      if (!re.hasMatch(original)) {
        throw Exception('Settings.xml 缺少选区设置，未修改其他设置');
      }
      final updated = original.replaceAllMapped(re, (m) => '${m[1]}0${m[2]}');
      if (updated != original) {
        await writeAtomic(
          '${settings.path}.launcher-backup',
          await settings.readAsBytes(),
        );
        await writeAtomic(settings.path, latin1.encode(updated));
      }
    }
    await Directory(shared).create(recursive: true);
    await install('OnlineBridge.exe', p.join(shared, 'OnlineBridge.exe'));
  }

  Future<void> launch(
    int n,
    FrameMode frameMode,
    bool fps,
    void Function(String) status,
  ) async {
    await validate();
    final lock = await File(p.join(root, '.launcher-start.lock'))
        .open(mode: FileMode.append);
    try {
      await lock.lock(FileLock.exclusive);
      await prepare();
      var s = await state(n);
      if (s == null) {
        final settings = File(p.join(game, 'Settings.xml'));
        final original = await settings.readAsBytes();
        final updated = latin1.encode(applyFrameMode(latin1.decode(original), frameMode));
        await writeAtomic('${settings.path}.before-frame-mode', original);
        await writeAtomic(settings.path, updated);
        final c = Map<String, dynamic>.from(config)
          ..addAll({
            'client_directory': game,
            'client_executable': clientExecutable,
            'client_sha256': await fileHash(p.join(game, clientExecutable)),
            'login_port': 18084,
            'sdk_port': 18000,
            'game_port': 18001,
            'control_directory': shared,
          });
        for (final key in [
          'server_certificate',
          'login_certificate',
          'login_key',
        ]) {
          c[key] = resolve(config[key]);
        }
        final path = p.join(
          root,
          'launcher-components',
          'window-$n',
          'bridge.json',
        );
        await writeAtomic(path, utf8.encode(jsonEncode(c)));
        await writeAtomic(
          p.join(shared, 'performance-$n.json'),
          utf8.encode(jsonEncode({'high_frame_rate': frameMode == FrameMode.high125, 'show_fps': fps})),
        );
        await Process.start(
          p.join(shared, 'OnlineBridge.exe'),
          ['-config', path, '-window', '$n'],
          mode: ProcessStartMode.detached,
          workingDirectory: shared,
        );
        status('窗口 $n 正在启动游戏…');
        for (var i = 0; i < 60; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          s = await state(n);
          if (s != null) break;
        }
        if (s == null) throw Exception('窗口 $n 启动超时\n${await logText()}');
      }
      final skinHash =
          (components['LoginSkin.dll'] as String).substring(0, 12) +
          (components['LoginSkinHost.exe'] as String).substring(0, 12);
      final skin = p.join(game, 'launcher-components', 'login-skin', skinHash);
      for (final name in ['LoginSkin.dll', 'LoginSkinHost.exe']) {
        await install(name, p.join(skin, name));
      }
      await Process.start(
        p.join(skin, 'LoginSkinHost.exe'),
        [
          '${s['PID']}',
          p.join(game, clientExecutable),
          p.join(skin, 'LoginSkin.dll'),
        ],
        mode: ProcessStartMode.detached,
        workingDirectory: skin,
      );
      if (fps && (s['fps_counter'] ?? 0) != 0) {
        await Process.start(support, [
          '--fps',
          '${s['PID']}',
          '${s['Created']}',
          '${s['fps_counter']}',
          p.join(game, clientExecutable),
        ], mode: ProcessStartMode.detached);
      }
      final account = await loadAccount(n);
      for (var i = 0; i < 60; i++) {
        final filled = await native({
          ...s,
          'Op': 'window',
          'Action': 'fill',
          'Image': p.join(game, clientExecutable),
          ...account,
        });
        if (filled == true) {
          status('窗口 $n 已填写账号密码，请在游戏内点击登录。');
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
      status('游戏已启动，未找到登录输入框；若已登录，无需重复操作。');
    } finally {
      await lock.unlock();
      await lock.close();
    }
  }

  Future<String> logText() async {
    final f = File(p.join(shared, 'online-client.log'));
    if (!await f.exists()) return '暂无窗口日志';
    final handle = await f.open();
    try {
      final size = await handle.length();
      await handle.setPosition(size > 32768 ? size - 32768 : 0);
      return publicError(
        utf8.decode(await handle.read(32768), allowMalformed: true),
      );
    } finally {
      await handle.close();
    }
  }
}
