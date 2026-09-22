import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'launcher_service.dart';
import 'frame_mode.dart';
import 'update_service.dart';
import 'update_progress_view.dart';
import 'log_export.dart';
import 'package:file_selector/file_selector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LauncherApp());
}

class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: '启动器 2026.09.22-oss.3',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff23645c)),
      fontFamily: 'Microsoft YaHei',
      scaffoldBackgroundColor: const Color(0xfff4f6f8),
    ),
    home: const LauncherPage(),
  );
}

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key, this.preview = false});
  final bool preview;
  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  final service = LauncherService(p.dirname(Platform.resolvedExecutable));
  late final updates = UpdateService(service, onProgress: (value) { if(mounted) setState(()=>transfer=value); });
  UpdateProgress? transfer;
  final account = TextEditingController(), password = TextEditingController();
  final accounts = List.generate(
    8,
    (_) => <String, dynamic>{'Account': '', 'Password': ''},
  );
  int selected = 1;
  final running = <int, bool>{};
  Timer? stateTimer;
  bool readingState = false;

  Future<void> refreshRunning() async {
    if (!ready || readingState) return;
    readingState = true;
    final n = selected;
    try {
      final alive = await service.state(n) != null;
      if (mounted) setState(() => running[n] = alive);
    } catch (_) {
      if (mounted) setState(() => running.remove(n));
    } finally {
      readingState = false;
    }
  }
  bool busy = true, ready = false, hide = false, fps = true;
  FrameMode frameMode = FrameMode.normal;
  String status = '正在准备启动器…', health = '正在检查服务器…';
  Map<String, dynamic>? release;
  File get preferences => File(
    p.join(
      Platform.environment['LOCALAPPDATA']!,
      'OpenKFO',
      'Launcher',
      'flutter-preferences.json',
    ),
  );
  @override
  void initState() {
    super.initState();
    if(widget.preview) { busy=false; ready=false; status="本地布局预览"; } else { WidgetsBinding.instance.addPostFrameCallback((_) => initialize()); }
  }

  void report(String text) {
    if (mounted) setState(() => status = text);
  }

  Future<void> initialize() async {
    try {
      await service.init();
      await service.validate();
      if (await preferences.exists()) {
        final m = jsonDecode(await preferences.readAsString());
        frameMode = FrameMode.values.where((v) => v.name == m['frame_mode']).firstOrNull
            ?? (m['high'] == true ? FrameMode.high125 : FrameMode.normal);
        fps = m['fps'] != false;
        hide = m['hide'] == true;
      }
      for (var n = 1; n <= 8; n++) {
        accounts[n - 1] = await service.loadAccount(n);
      }
      loadFields();
      ready = true;
      await refreshRunning();
      stateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!busy) unawaited(refreshRunning());
      });
      report('选择窗口，填写账号后启动游戏');
      await refreshHealth();
      await checkUpdate();
    } catch (e) {
      await error(e);
    } finally {
      await refreshRunning();
      if (mounted) setState(() => busy = false);
    }
  }

  void loadFields() {
    account.text = accounts[selected - 1]['Account'] ?? '';
    password.text = accounts[selected - 1]['Password'] ?? '';
  }

  Future<void> save() async {
    if (!ready) return;
    await service.saveAccount(selected, account.text.trim(), password.text);
    accounts[selected - 1] = {
      'Account': account.text.trim(),
      'Password': password.text,
    };
    await writeAtomic(
      preferences.path,
      utf8.encode(jsonEncode({'frame_mode': frameMode.name, 'fps': fps, 'hide': hide})),
    );
  }

  Future<void> refreshHealth() async {
    try {
      final text = await service.health();
      if (mounted) setState(() => health = '服务器连接正常 · $text');
    } catch (e) {
      if (mounted) setState(() => health = '服务器连接失败，可点击重新检查');
    }
  }

  Future<void> error(Object e) async {
    if (!mounted) return;
    report(e is GameDirectoryError ? '请放到游戏目录下' : '操作未完成');
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(e is GameDirectoryError ? '启动器提示' : '操作详情'),
        content: SizedBox(
          width: 640,
          child: SingleChildScrollView(child: SelectableText(publicError(e))),
        ),
        actions: [
          if (e is! GameDirectoryError)
            TextButton(
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: publicError(e))),
              child: const Text('复制详情'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Future<bool> confirm(
    String title,
    String body, {
    String yes = '更新',
    String no = '取消',
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(child: Text(body)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: Text(no),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: Text(yes),
            ),
          ],
        ),
      ) ??
      false;
  Future<void> checkUpdate() async {
    final previousBusy=busy;
    if(mounted)setState(()=>busy=true);
    try {
      release = await updates.check();
      if (release != null && mounted) {
        if (await confirm('启动器有新版本', release!['notes'], no: '跳过本次更新')) {
          await save();
          await updates.install(release!, report);
        }
      }
    } catch (e) {
      await error(e);
    } finally {if(mounted)setState(()=>busy=previousBusy);}
  }

  Future<void> launch() async {
    setState(() { busy = true; transfer = null; });
    try {
      await save();
      await service.validate();
      final client = await updates.clientCheck();
      if (client != null) {
        if (!await confirm('客户端更新', client['notes'] ?? '发现客户端更新，更新前需要关闭游戏。')) {
          return;
        }
        await updates.installClient(client, report);
      }
      await service.launch(selected, frameMode, fps, report);
    } catch (e) {
      await error(e);
    } finally {
      await refreshRunning();
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> select(int n) async {
    if (busy || !ready) return;
    try {
      await save();
      setState(() {
        selected = n;
        running.remove(n);
        loadFields();
      });
      await refreshRunning();
    } catch (e) {
      await error(e);
    }
  }

  Future<void> logs() async {
    try {
      final text=await service.logText();
      if(!mounted)return;
      await showDialog<void>(context:context,builder:(dialogContext)=>AlertDialog(
        title:Text('窗口 $selected 日志'),
        content:SizedBox(width:760,height:420,child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const Text('预览最近 32 KB；导出 TXT 包含当前日志的完整内容。多开窗口共用网络日志。'),
          const SizedBox(height:12),Expanded(child:SingleChildScrollView(child:SelectableText(text))),
        ])),
        actions:[
          TextButton(onPressed:()=>Clipboard.setData(ClipboardData(text:text)),child:const Text('复制预览')),
          TextButton(onPressed:() async {
            try {
              final stamp=DateTime.now().toIso8601String().replaceAll(':','-').split('.').first;
              final username=account.text.trim().replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1f]'), '_');
              final prefix=username.isEmpty ? '' : '$username-';
              final location=await getSaveLocation(suggestedName:'$prefix窗口$selected-日志-$stamp.txt',acceptedTypeGroups:[const XTypeGroup(label:'TXT 文本',extensions:['txt'])]);
              if(location==null)return;
              final destination=location.path.toLowerCase().endsWith('.txt')?location.path:'${location.path}.txt';
              await exportLog(File(p.join(service.shared,'online-client.log')),destination);
              report('日志已导出：$destination');
              if(dialogContext.mounted)Navigator.pop(dialogContext);
            } catch(e) {await error(e);}
          },child:const Text('导出 TXT')),
          TextButton(onPressed:()=>Navigator.pop(dialogContext),child:const Text('关闭')),
        ]));
    } catch(e) {await error(e);}
  }

  @override
  void dispose() {
    stateTimer?.cancel();
    account.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.sports_martial_arts, size: 28),
                const SizedBox(width: 12),
                Expanded(child: Text('启动器 2026.09.22-oss.3', maxLines: 2, style: Theme.of(context).textTheme.headlineSmall)),
                TextButton(
                  onPressed: busy ? null : checkUpdate,
                  child: const Text('检查更新'),
                ),
                TextButton(
                  onPressed: () => confirm(
                    '使用说明',
                    '将整个 ZIP 解压到完整游戏目录，与 Data 文件夹同级。\n只点击启动器.exe；登录组件、证书与 gfld.dat 会自动准备。\n\n账号不存在时登录即注册；已有账号需输入正确密码。\n账号密码保存在本机用户目录，使用 AES 加密。\n高帧模式切换后需重新启动游戏。\n更新只下载变化的文件。',
                    yes: '知道了',
                  ),
                  child: const Text('使用说明'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.public, color: Color(0xff23645c)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(health)),
                    IconButton(
                      onPressed: ready ? refreshHealth : null,
                      tooltip: '刷新服务器状态',
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, bounds) {
                  final panels = [
                    SizedBox(
                      width: 230,
                      child: Card(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: 8,
                          itemBuilder: (context, index) => ListTile(
                            selected: selected == index + 1,
                            selectedTileColor: const Color(0xffdeeee9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const Icon(Icons.desktop_windows_outlined),
                            title: Text('窗口 ${index + 1}'),
                            subtitle: Text(
                              accounts[index]['Account'] == ''
                                  ? '未保存账号'
                                  : accounts[index]['Account'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => select(index + 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: FocusTraversalGroup(
                          policy: WidgetOrderTraversalPolicy(),
                          child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '窗口 $selected 的账号',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              const Text('账号不存在时，登录即自动注册。已有账号请输入正确密码。'),
                              const SizedBox(height: 24),
                              TextField(
                                controller: account,
                                enabled: ready && !busy,
                                decoration: const InputDecoration(
                                  labelText: '账号',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: password,
                                enabled: ready && !busy,
                                obscureText: hide,
                                decoration: InputDecoration(
                                  labelText: '密码',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => hide = !hide),
                                    tooltip: hide ? '显示密码' : '隐藏密码',
                                    icon: Icon(
                                      hide
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: ready && !busy
                                    ? () async {
                                        try {
                                          await save();
                                          report('账号密码已保存');
                                          setState(() {});
                                        } catch (e) {
                                          await error(e);
                                        }
                                      }
                                    : null,
                                icon: const Icon(Icons.save_outlined),
                                label: const Text('保存账号密码'),
                              ),
                              const Text('按窗口分别保存，切换窗口和启动游戏时自动保存。'),
                              const SizedBox(height: 16),
                            ],
                          ),
                          ),
                        ),
                      ),
                    ),
                  ];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: panels,
                  );
                },
              ),
            ),
            Row(children: [
              Expanded(child: DropdownButtonFormField<FrameMode>(
                value: frameMode,
                isExpanded: true,
                decoration: const InputDecoration(labelText: '帧率模式（重启游戏生效）'),
                items: const [
                  DropdownMenuItem(value: FrameMode.normal, child: Text('普通模式')),
                  DropdownMenuItem(value: FrameMode.high125, child: Text('高帧一：约 125 FPS')),
                  DropdownMenuItem(value: FrameMode.configZero, child: Text('高帧二：配置设为 0（实验）')),
                ],
                onChanged: busy ? null : (v) { if (v != null) setState(() => frameMode = v); },
              )),
                              Expanded(child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('顶部居中显示 FPS'),
                                subtitle: const Text('窗口模式'),
                                value: fps,
                                onChanged: busy
                                    ? null
                                    : (v) => setState(() => fps = v),
                              )),
            ]),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: ready && !busy && running[selected] == false ? launch : null,
                  icon: const Icon(Icons.play_arrow),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(running[selected] == true ? '已启动' : '启动游戏'),
                  ),
                ),
                OutlinedButton(
                  onPressed: ready && !busy
                      ? () => service.show(selected)
                      : null,
                  child: const Text('显示游戏窗口'),
                ),
                OutlinedButton(
                  onPressed: ready ? logs : null,
                  child: const Text('查看窗口日志'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (transfer != null) UpdateProgressView(transfer!),
            if (busy && transfer == null) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            SelectableText(status, maxLines: 3),
          ],
        ),
      ),
    ),
  );
}
