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
  List<int> disabled = [];
  List<int> opened = [];
  bool openAll = false;
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
      opened = ((result['force_open_maps'] as List?) ?? []).cast<int>();
      openAll = result['force_open_all'] == true;
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
        'force_open_all': openAll,
        'force_open_maps': opened,
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
    final wavePlans = <int, Map<String, dynamic>>{
      for (final plan in (preserved['wave_plans'] as List? ?? []))
        plan['map_id'] as int: Map<String, dynamic>.from(plan as Map),
    };
    if (data['pve_maps'] != null) {
      final ids = <int>{};
      for (final r in data['pve_maps'] as List) {
        final id = r['map_id'];
        if (id is! int || !parsed.containsKey(id)) {
          throw const FormatException('PVE目录引用了不存在的地图');
        }
        ids.add(id);
        final preview = r['wave_preview'];
        if (preview is Map && !wavePlans.containsKey(id)) {
          wavePlans[id] = {
            'map_id': id,
            'script_hash': r['script_hash'],
            'runtime_hash': preview['runtime_hash'],
            'templates': preview['templates'],
            'variants': preview['variants'],
          };
        }
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
      if (wavePlans.isNotEmpty)
        preserved['wave_plans'] = wavePlans.values.toList();
      showRequirements = true;
      status = '已导入地图条件草稿，${wavePlans.length} 张地图有波次配置；已有数值保留，未保存、未自动启用';
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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('关卡开关 · ${widget.environment}')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '开放：跳过称号和个人解锁条件。原规则：恢复默认准入。只控制地图准入，不增加未实现的关卡玩法；进行中的战斗不强制中断。',
          ),
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
                label: const Text('地图开放设置'),
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
          Wrap(
            spacing: 8,
            children: [
              for (final mode in ['全部开放', '全部关闭', '恢复原规则'])
                TextButton(
                  onPressed: busy || requirements.isEmpty
                      ? null
                      : () => setState(() {
                          openAll = mode == '全部开放';
                          opened = [];
                          disabled = mode == '全部关闭'
                              ? requirements
                                    .map((r) => r['map_id'] as int)
                                    .toList()
                              : [];
                          status = '有未保存的修改';
                        }),
                  child: Text(mode),
                ),
            ],
          ),
          if (requirements.isEmpty) const Text('请先读取客户端地图条件，保存后可按地图名称设置。'),
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
                    itemCount: requirements.length,
                    itemBuilder: (context, i) {
                      final r = requirements[i];
                      final id = r['map_id'] as int;
                      final mode = disabled.contains(id)
                          ? '关闭'
                          : (openAll || opened.contains(id))
                          ? '开放'
                          : '原规则';
                      return ListTile(
                        title: Text('${r['name']}'),
                        trailing: DropdownButton<String>(
                          value: mode,
                          items: ['原规则', '开放', '关闭']
                              .map(
                                (v) =>
                                    DropdownMenuItem(value: v, child: Text(v)),
                              )
                              .toList(),
                          onChanged: busy || revision == null
                              ? null
                              : (v) => setState(() {
                                  if (openAll) {
                                    opened = requirements
                                        .map((r) => r['map_id'] as int)
                                        .where((id) => !disabled.contains(id))
                                        .toList();
                                    openAll = false;
                                  }
                                  opened.remove(id);
                                  disabled.remove(id);
                                  if (v == '开放') opened.add(id);
                                  if (v == '关闭') disabled.add(id);
                                  status = '有未保存的修改';
                                }),
                        ),
                      );
                    },
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
