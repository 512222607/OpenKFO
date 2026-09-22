import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> parseBannedWords(String text) => text
    .replaceAll('\ufeff', '')
    .split(RegExp(r'[\r\n,，;；]'))
    .map((w) => w.trim())
    .where((w) => w.isNotEmpty)
    .toSet()
    .toList();

class BannedWordsPage extends StatefulWidget {
  const BannedWordsPage({
    super.key,
    required this.api,
    required this.environment,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  @override
  State<BannedWordsPage> createState() => _BannedWordsPageState();
}

class _BannedWordsPageState extends State<BannedWordsPage> {
  List<String> words = [];
  int? revision;
  bool busy = false, dirty = false;
  String status = '', query = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> run(Future<void> Function() f) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await f();
    } catch (e) {
      if (mounted) setState(() => status = '操作失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void apply(dynamic data) {
    if (!mounted) return;
    setState(() {
      words = (data['words'] as List).cast<String>();
      revision = data['revision'] as int;
      dirty = false;
    });
  }

  Future<void> load() => run(() async {
    apply(await widget.api({'operation': 'banned_words_get'}));
    if (mounted) setState(() => status = '已读取${widget.environment}词库');
  });
  Future<void> reload() async {
    if (dirty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('放弃未保存修改？'),
          content: const Text('重新读取服务器词库会替换当前草稿。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('重新读取'),
            ),
          ],
        ),
      );
      if (discard != true || !mounted) return;
    }
    await load();
  }

  Future<void> save() => run(() async {
    apply(
      await widget.api({
        'operation': 'banned_words_save',
        'banned_words': {'revision': revision, 'words': words},
      }),
    );
    if (mounted) {
      setState(() => status = '已保存到${widget.environment}；运行中的新版服务器约 1 秒内生效');
    }
  });
  Future<String?> input(
    String title,
    String label, {
    String value = '',
    bool multiline = false,
  }) async {
    final controller = TextEditingController(text: value);
    final result = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 600,
          child: TextField(
            controller: controller,
            autofocus: true,
            minLines: multiline ? 8 : 1,
            maxLines: multiline ? 12 : 1,
            decoration: InputDecoration(labelText: label),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, controller.text),
            child: const Text('导入草稿'),
          ),
        ],
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
    return result;
  }

  void merge(String text) {
    final added = parseBannedWords(text);
    final next = {...words, ...added}.toList()..sort();
    if (next.length > 50000) throw const FormatException('最多 50000 条违禁词');
    if (next.any((w) => w.runes.length > 64)) {
      throw const FormatException('单条最多 64 个字符');
    }
    if (!mounted) return;
    setState(() {
      status = '导入 ${next.length - words.length} 条，保存后生效';
      words = next;
      dirty = true;
    });
  }

  Future<void> importText() => run(() async {
    final text = await input(
      '批量导入违禁词',
      '每行一词，也支持逗号、分号分隔；追加并去重',
      multiline: true,
    );
    if (text != null) merge(text);
  });
  Future<void> importFile() => run(() async {
    final path = await input('导入 TXT 文件', 'UTF-8 TXT 文件完整路径');
    if (path == null || path.trim().isEmpty) return;
    final file = File(path.trim().replaceAll('"', ''));
    if (await file.length() > 2 * 1024 * 1024) {
      throw const FormatException('TXT 文件最大 2 MB');
    }
    merge(await file.readAsString());
  });
  @override
  Widget build(BuildContext context) {
    final visible = words
        .where((w) => w.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text('${widget.environment} · 违禁词管理')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '命中后拒绝角色取名、改名、房间名和公开/私聊发言，提示“违禁词！”。\n忽略大小写、全半角、简繁体常见字形及空格符号；按包含匹配，短词可能误拦正常内容。',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: busy || revision == null || !dirty ? null : save,
                  child: const Text('保存词库'),
                ),
                OutlinedButton(
                  onPressed: busy || revision == null ? null : importText,
                  child: const Text('添加 / 批量粘贴'),
                ),
                OutlinedButton(
                  onPressed: busy || revision == null ? null : importFile,
                  child: const Text('导入 TXT'),
                ),
                OutlinedButton(
                  onPressed: busy || revision == null
                      ? null
                      : () => run(() async {
                          await Clipboard.setData(
                            ClipboardData(text: words.join('\n')),
                          );
                          if (mounted) setState(() => status = '词库已复制');
                        }),
                  child: const Text('复制全部'),
                ),
                OutlinedButton(
                  onPressed: busy ? null : reload,
                  child: const Text('重新读取'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(status),
            Text(
              '${words.length} 条 · 显示 ${visible.length} 条${dirty ? ' · 有未保存修改' : ''}',
            ),
            TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                labelText: '搜索违禁词',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            if (busy) const LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final word = visible[index];
                  return ListTile(
                    title: Text(word),
                    trailing: IconButton(
                      tooltip: '删除此词（保存后生效）',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: busy
                          ? null
                          : () => setState(() {
                              words.remove(word);
                              dirty = true;
                            }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
