import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({
    super.key,
    required this.api,
    required this.environment,
  });
  final Future<dynamic> Function(Map<String, dynamic>) api;
  final String environment;
  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<dynamic> users = [];
  bool busy = false;
  String query = '', message = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => busy = true);
    try {
      final result = await widget.api({'operation': 'users_list'});
      if (mounted) setState(() => users = result as List);
    } catch (e) {
      if (mounted) setState(() => message = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String deadline(dynamic value) => value == 0
      ? '永久'
      : DateTime.fromMillisecondsSinceEpoch((value as num).toInt() * 1000)
            .toLocal()
            .toString()
            .split('.')
            .first;

  Future<void> history(Map<String, dynamic> user) async {
    setState(() => busy = true);
    try {
      final rows = await widget.api({
        'operation': 'user_ban_history',
        'uid': user['uid'],
      }) as List;
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${user['account']} · 最近 100 条封禁记录'),
          content: SizedBox(
            width: 650,
            child: SingleChildScrollView(
              child: SelectableText(
                rows.isEmpty
                    ? '暂无记录'
                    : rows
                          .map((r) {
                            final b = r['after'];
                            return "${r['created']}  ${b['enabled'] == true ? '封禁至 ${deadline(b['expires_at'])}' : '解封'}\n原因：${b['reason']}\n操作号：${r['id']}";
                          })
                          .join('\n\n'),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) setState(() => message = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> changeBan(Map<String, dynamic> user, bool enabled) async {
    String reason = '';
    int hours = 24;
    String error = '';
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text('${enabled ? '封禁' : '解封'} ${user['account']}'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.environment} · UID ${user['uid']} · ${user['nickname']}',
                ),
                if (enabled) ...[
                  const Text('封禁后通常 1 秒内踢下线，并禁止再次登录。'),
                  DropdownButton<int>(
                    value: hours,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1 小时')),
                      DropdownMenuItem(value: 24, child: Text('1 天')),
                      DropdownMenuItem(value: 168, child: Text('7 天')),
                      DropdownMenuItem(value: 720, child: Text('30 天')),
                      DropdownMenuItem(value: 0, child: Text('永久')),
                    ],
                    onChanged: (v) => update(() => hours = v!),
                  ),
                ],
                TextField(
                  onChanged: (value) => reason = value,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '原因（必填）'),
                ),
                if (error.isNotEmpty)
                  Text(error, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (reason.trim().isEmpty) {
                  update(() => error = '请填写原因');
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text('确认'),
            ),
          ],
        ),
      ),
    );
    final text = reason.trim();
    if (accepted != true || !mounted) return;
    setState(() {
      busy = true;
      message = '';
    });
    try {
      await widget.api({
        'operation': 'user_ban_save',
        'uid': user['uid'],
        'id': 'ban-${user['uid']}-${DateTime.now().microsecondsSinceEpoch}',
        'enabled': enabled,
        'reason': text,
        'expires_at': enabled && hours > 0
            ? DateTime.now()
                      .add(Duration(hours: hours))
                      .millisecondsSinceEpoch ~/
                  1000
            : 0,
      });
      if (mounted) {
        setState(
          () => message = enabled ? '封禁已保存；新版游戏服务器通常 1 秒内踢下线。' : '已解封，可以重新登录。',
        );
      }
      if (mounted) await load();
    } catch (e) {
      if (mounted) setState(() => message = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = users
        .where(
          (u) => '${u['uid']} ${u['account']} ${u['nickname']}'
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text('${widget.environment} · 用户管理')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: '搜索 UID、账号、角色名',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => query = v),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: busy ? null : load,
                  child: const Text('刷新'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (busy) const LinearProgressIndicator(),
            if (message.isNotEmpty) SelectableText(message),
            Expanded(
              child: ListView.builder(
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final user = Map<String, dynamic>.from(visible[index] as Map);
                  final banned = user['banned'] == true;
                  return Card(
                    child: ListTile(
                      title: Text(
                        "${user['account']} · ${user['nickname']} · UID ${user['uid']}",
                      ),
                      subtitle: Text(
                        "金币 ${user['gold']} · 点券 ${user['tickets']}\n${banned ? '已封禁，期限：${deadline(user['expires_at'])}' : '正常'}${user['reason'] == '' ? '' : '\n最近原因：${user['reason']}'}",
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: busy ? null : () => history(user),
                            child: const Text('记录'),
                          ),
                          OutlinedButton(
                            onPressed: busy
                                ? null
                                : () => changeBan(user, !banned),
                            child: Text(banned ? '解封' : '封禁'),
                          ),
                        ],
                      ),
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
