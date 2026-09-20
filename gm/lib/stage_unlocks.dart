import 'package:flutter/material.dart';

class StageUnlocksPage extends StatefulWidget {
  const StageUnlocksPage({
    super.key,
    required this.api,
    required this.environment,
    required this.uid,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  final int uid;
  @override
  State<StageUnlocksPage> createState() => _StageUnlocksPageState();
}

class _StageUnlocksPageState extends State<StageUnlocksPage> {
  bool busy = false;
  String status = '', hash = '';
  int? revision;
  List<Map<String, dynamic>> rows = [];
  Set<int> grants = {};
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    if (busy) return;
    setState(() {
      busy = true;
      revision = null;
    });
    try {
      final rules = await widget.api({'operation': 'stages_get'});
      final data = await widget.api({
        'operation': 'stage_unlocks_get',
        'uid': widget.uid,
      });
      final h = rules['client_hash'];
      if (h is! String ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch(h) ||
          data['uid'] != widget.uid ||
          data['client_hash'] != h ||
          data['revision'] is! int ||
          data['revision'] < 0 ||
          data['maps'] is! List ||
          rules['requirements'] is! List) {
        throw Exception('账号或关卡目录不一致，请先导入目录并重新读取');
      }
      final parsed = (rules['requirements'] as List)
          .map((r) => Map<String, dynamic>.from(r as Map))
          .toList();
      final ids = <int>{};
      for (final r in parsed) {
        final id = r['map_id'];
        if (id is! int ||
            id <= 0 ||
            id > 2147483647 ||
            !ids.add(id) ||
            r['name'] is! String) {
          throw Exception('关卡目录无效');
        }
      }
      final saved = <int>{};
      for (final id in data['maps']) {
        if (id is! int || !ids.contains(id) || !saved.add(id)) {
          throw Exception('已有授权与当前目录不匹配，禁止覆盖');
        }
      }
      if (!mounted) return;
      setState(() {
        hash = h;
        rows = parsed;
        grants = saved;
        revision = data['revision'];
        status = '已读取';
      });
    } catch (e) {
      if (mounted) setState(() => status = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> save() async {
    if (busy || revision == null) return;
    setState(() => busy = true);
    try {
      final data = await widget.api({
        'operation': 'stage_unlocks_save',
        'uid': widget.uid,
        'stage_unlocks': {
          'uid': widget.uid,
          'client_hash': hash,
          'revision': revision,
          'maps': grants.toList()..sort(),
        },
      });
      if (data['uid'] != widget.uid ||
          data['client_hash'] != hash ||
          data['revision'] != revision! + 1) {
        throw Exception('保存回执不匹配，请重新读取核对');
      }
      if (mounted) {
        setState(() {
          revision = data['revision'];
          status = '已保存';
        });
      }
    } catch (e) {
      if (mounted) setState(() => status = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('个人关卡解锁 · ${widget.environment} · UID ${widget.uid}'),
    ),
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            '这是进入关卡的授权，不代表通关，也不会发奖励。仅在关卡条件启用且该地图要求个人解锁时限制进入；关闭地图和称号条件仍有效。配套新版服务器会在游戏重新请求关卡列表时刷新；尚未支持的玩法不会因授权而开放。',
          ),
        ),
        Wrap(
          spacing: 12,
          children: [
            OutlinedButton(
              onPressed: busy ? null : load,
              child: const Text('重新读取'),
            ),
            FilledButton(
              onPressed: busy || revision == null ? null : save,
              child: const Text('保存解锁'),
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.all(8), child: Text(status)),
        Expanded(
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final r = rows[i], id = r['map_id'] as int;
              return CheckboxListTile(
                title: Text('${r['name']} · $id'),
                subtitle: Text(
                  r['unlock_required'] == true ? '要求个人解锁' : '当前不要求个人解锁',
                ),
                value: grants.contains(id),
                onChanged: busy || revision == null
                    ? null
                    : (v) => setState(() {
                        if (v == true) {
                          grants.add(id);
                        } else {
                          grants.remove(id);
                        }
                        status = '有未保存的修改';
                      }),
              );
            },
          ),
        ),
      ],
    ),
  );
}
