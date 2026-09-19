import 'package:flutter/material.dart';

class StageConfigPage extends StatefulWidget {
  const StageConfigPage({
    super.key,
    required this.api,
    required this.environment,
    this.canReadClient = true,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  final bool canReadClient;
  @override
  State<StageConfigPage> createState() => _StageConfigPageState();
}

class _StageConfigPageState extends State<StageConfigPage> {
  final input = TextEditingController();
  List<int> disabled = [];
  Map<String, dynamic> preserved = {};
  List<Map<String, dynamic>> requirements = [];
  bool showRequirements = false;
  int? revision;
  bool busy = false;
  String status = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => status = '操作失败：$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void apply(dynamic result) {
    if (!mounted) return;
    setState(() {
      revision = result['revision'] as int;
      preserved = Map<String, dynamic>.from(result as Map);
      requirements = ((result['requirements'] as List?) ?? [])
          .map((r) => Map<String, dynamic>.from(r as Map))
          .toList();
      disabled = (result['disabled_maps'] as List).cast<int>()..sort();
      status = '已读取 ${widget.environment}，版本 $revision';
    });
  }

  Future<void> load() => run(() async {
    setState(() => revision = null);
    apply(await widget.api({'operation': 'stages_get'}));
  });
  Future<void> save() => run(() async {
    final result = await widget.api({
      'operation': 'stages_save',
      'stage_access': {
        ...preserved,
        'revision': revision,
        'disabled_maps': disabled,
        if (preserved.containsKey('requirements')) 'requirements': requirements,
      },
    });
    apply(result);
    if (mounted) {
      setState(() => status = '已保存到 ${widget.environment}；新建、换图及下一次开战生效');
    }
  });
  Future<void> importRequirements() => run(() async {
    if (revision == null) return;
    final data = await widget.api({'operation': 'stage_requirements'});
    final hash = data['client_hash'];
    if (hash is! String || !RegExp(r'^[0-9a-f]{64}$').hasMatch(hash)) {
      throw const FormatException('地图目录缺少有效版本指纹');
    }
    final oldHash = preserved['client_hash'] as String? ?? '';
    if (oldHash.isNotEmpty && oldHash != hash) {
      throw const FormatException('本机客户端与已保存目录版本不同，请先核对目标服务器客户端');
    }
    final parsed = <int, Map<String, dynamic>>{};
    for (final r in data['maps'] as List) {
      final id = r['map_id'], name = r['name'], title = r['title_level'];
      if (id is! int ||
          id < 0 ||
          id > 2147483647 ||
          name is! String ||
          name.trim().isEmpty ||
          title is! int ||
          title < 0 ||
          title > 255 ||
          parsed.containsKey(id)) {
        throw const FormatException('地图目录存在错误或重复条目');
      }
      parsed[id] = {'map_id': id, 'name': name, 'title_level': title};
    }
    parsed.remove(0); // Random selector is not a concrete map requirement.
    if (parsed.isEmpty) {
      throw const FormatException('没有可导入的具体地图');
    }
    final existing = requirements.map((r) => r['map_id']).toSet();
    final merged = [
      ...requirements,
      ...parsed.values.where((r) => !existing.contains(r['map_id'])),
    ];
    if (merged.length > 4096) {
      throw const FormatException('合并后超过4096项');
    }
    List<int>? pve;
    if (data['pve_maps'] != null) {
      final ids = <int>{};
      for (final r in data['pve_maps'] as List) {
        final id = r['map_id'];
        if (id is! int || !parsed.containsKey(id)) {
          throw const FormatException('PVE目录引用了不存在的地图');
        }
        ids.add(id);
      }
      pve = ids.toList()..sort();
      if (pve.map((id) => '$id,').join().length >= 400) {
        throw const FormatException('PVE目录超过客户端进度包容量');
      }
    }
    if (!mounted) return;
    setState(() {
      requirements = merged
        ..sort((a, b) => (a['map_id'] as int).compareTo(b['map_id'] as int));
      preserved['client_hash'] = hash;
      preserved['requirements'] = requirements;
      if (pve != null) preserved['pve_maps'] = pve;
      showRequirements = true;
      status = '已导入地图条件草稿，已有数值保留；未保存，未自动启用';
    });
  });
  Future<void> editRequirement(int index) async {
    final row = requirements[index];
    var inputValue = '${row['title_level']}';
    String error = '';
    final value = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text('${row['name']} · ${row['map_id']}'),
          content: TextFormField(
            key: const ValueKey('stage-title'),
            initialValue: inputValue,
            onChanged: (v) => inputValue = v,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '最低称号等级（0–255）',
              errorText: error.isEmpty ? null : error,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final n = int.tryParse(inputValue.trim());
                if (n == null || n < 0 || n > 255) {
                  update(() => error = '请输入0–255的整数');
                  return;
                }
                Navigator.pop(context, n);
              },
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
    if (value == null || !mounted) return;
    setState(() {
      requirements[index] = {...row, 'title_level': value};
      status = '有未保存的修改';
    });
  }

  void add() {
    final id = int.tryParse(input.text.trim());
    if (id == null ||
        id <= 0 ||
        id > 2147483647 ||
        disabled.contains(id) ||
        disabled.length >= 4096) {
      setState(() => status = '请输入未重复的正整数地图ID（最多4096项）');
      return;
    }
    setState(() {
      disabled.add(id);
      disabled.sort();
      input.clear();
      status = '有未保存的修改';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('关卡开关 · ${widget.environment}')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('列表中的地图已关闭。移除后恢复服务器原有开放规则，不会解锁尚未支持的玩法。进行中的战斗不强制中断。'),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('启用地图准入条件'),
            subtitle: const Text('检查客户端版本、全员称号及已勾选的个人解锁条件；关闭后保留配置，不解锁未支持玩法'),
            value: preserved['requirements_enabled'] == true,
            onChanged: busy || revision == null || requirements.isEmpty
                ? null
                : (v) => setState(() {
                    preserved['requirements_enabled'] = v;
                    status = '有未保存的修改';
                  }),
          ),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('关闭地图'),
                selected: !showRequirements,
                onSelected: (_) => setState(() => showRequirements = false),
              ),
              ChoiceChip(
                label: const Text('称号条件'),
                selected: showRequirements,
                onSelected: (_) => setState(() => showRequirements = true),
              ),
              if (widget.canReadClient)
                OutlinedButton(
                  onPressed: busy || revision == null
                      ? null
                      : importRequirements,
                  child: const Text('读取客户端地图条件'),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: input,
                  enabled: !busy && revision != null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '地图ID'),
                ),
              ),
              TextButton(
                onPressed: busy || revision == null ? null : add,
                child: const Text('加入关闭列表'),
              ),
            ],
          ),
          Expanded(
            child: showRequirements
                ? ListView.builder(
                    itemCount: requirements.length,
                    itemBuilder: (context, i) {
                      final r = requirements[i];
                      return ListTile(
                        title: Text('${r['name']} · ${r['map_id']}'),
                        subtitle: Text('最低称号 ${r['title_level']}'),
                        trailing: Tooltip(
                          message: '要求个人关卡解锁（随关卡条件总开关生效）',
                          child: Checkbox(
                            value: r['unlock_required'] == true,
                            onChanged: busy || revision == null
                                ? null
                                : (value) => setState(() {
                                    requirements[i] = {
                                      ...r,
                                      'unlock_required': value == true,
                                    };
                                    status = '有未保存的修改';
                                  }),
                          ),
                        ),
                        onTap: busy || revision == null
                            ? null
                            : () => editRequirement(i),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: disabled.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text('地图 ${disabled[i]}'),
                      subtitle: const Text('关闭'),
                      trailing: IconButton(
                        tooltip: '恢复开放',
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: busy
                            ? null
                            : () => setState(() {
                                disabled.removeAt(i);
                                status = '有未保存的修改';
                              }),
                      ),
                    ),
                  ),
          ),
          Text(status),
          Row(
            children: [
              TextButton(
                onPressed: busy ? null : load,
                child: const Text('重新读取'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: busy || revision == null ? null : save,
                child: const Text('保存关卡开关'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
