using System.Diagnostics;
using System.Text.Json;

namespace OpenKFO.Monitor;

internal static class Program
{
    [STAThread]
    static int Main(string[] args)
    {
        ApplicationConfiguration.Initialize();
        if (args.Contains("--self-test")) return SelfTests.Run(args);
        string root = AppContext.BaseDirectory;
        int index = Array.IndexOf(args, "--server-dir");
        if (index >= 0 && index + 1 < args.Length) root = Path.GetFullPath(args[index + 1]);
        if(args.Contains("--lifecycle-test")) return SelfTests.Lifecycle(root,args).GetAwaiter().GetResult();
        Application.Run(new MonitorForm(root, args.Contains("--start")));
        return 0;
    }
}

internal sealed record TraceRow(string Time, string Player, string Account, string Direction,
    uint Protocol, uint Subprotocol, string Transport, ulong Uid, uint Room, int Length,
    string Hex, string Content, string Raw)
{
    internal static TraceRow Parse(string line)
    {
        try
        {
            using var document = JsonDocument.Parse(line);
            var r = document.RootElement;
            string Text(string key) => r.TryGetProperty(key, out var value) && value.ValueKind == JsonValueKind.String ? value.GetString() ?? "" : "";
            ulong Number(string key) => r.TryGetProperty(key, out var value) && value.TryGetUInt64(out var number) ? number : 0;
            string direction = Text("direction");
            if (direction.Length != 0)
                return new(Text("time"), Text("player"), Text("account"), direction, (uint)Number("protocol"),
                    (uint)Number("subprotocol"), Text("transport"), Number("uid"), (uint)Number("room"),
                    (int)Number("length"), Text("hex"), Text("content"), line);
        }
        catch (Exception ex) when (ex is JsonException or InvalidOperationException or FormatException) { }
        return new(DateTimeOffset.Now.ToString("O"), "", "", "", 0, 0, "", 0, 0, 0, "", line, line);
    }
    internal string Clock => DateTimeOffset.TryParse(Time, out var time) ? time.LocalDateTime.ToString("HH:mm:ss.fff") : Time;
    internal string Flow => Direction switch { "C->S" => "玩家 → 服务器", "S->C" => "服务器 → 玩家（已发送）", "S->C queued" => "服务器 → 玩家（待发送）", "" => "运行信息", _ => Direction };
    internal string Name => Direction == "" ? "运行日志" : Transport.StartsWith("tunnel:") ? "连接控制 · " + Transport[7..] : Transport == "sdk" ? "账号认证" : Transport == "udp" ? "UDP 数据" : Names.GetValueOrDefault(Protocol, "尚未标注的协议");
    internal bool Heartbeat => Protocol == 1157 || Transport is "tunnel:ping" or "tunnel:pong" or "tunnel:health";
    internal bool Matches(string filter, bool hideHeartbeat) => (!hideHeartbeat || !Heartbeat) &&
        $"{Account} {Player} {Uid} {Protocol} {Subprotocol} {Name} {Flow} {Content}".Contains(filter.Trim(), StringComparison.OrdinalIgnoreCase);
    internal string Description
    {
        get
        {
            if (Direction == "") return FriendlyError(Content) + Environment.NewLine + Content;
            string text = $"时间：{Time}\r\n玩家：{(Player == "" ? "尚未登录 / 尚未创建角色" : Player)}    账号：{Account}    UID：{Uid}\r\n方向：{Flow}\r\n协议：{Protocol} · {Name}\r\n传输：{Transport}    房间：{Room}\r\n长度：{Length} 字节";
            if (Subprotocol != 0) text += $"\r\n子协议：{Subprotocol} · {Names.GetValueOrDefault(Subprotocol, "尚未标注")}";
            try
            {
                byte[] data = Convert.FromHexString(Hex);
                if (Transport == "game")
                {
                    if (Protocol is 1230 or 1240 && data.Length == 4) text += $"\r\n当前余额：{System.Buffers.Binary.BinaryPrimitives.ReadUInt32LittleEndian(data)}";
                    if (Protocol == 4125 && data.Length >= 64)
                    {
                        var candidates = Enumerable.Range(0, 7).Select(i => System.Buffers.Binary.BinaryPrimitives.ReadUInt32LittleEndian(data.AsSpan(8 + i * 8))).Where(k => k != 0);
                        text += $"\r\n称号等级：{data[0]}\r\n奖励候选目录键：{string.Join("、", candidates)}";
                    }
                    if (Protocol == 3010 && data.Length == 81)
                        text += $"\r\n房间模式：{RoomMode(data[46])}    人数上限：{data[37]}    地图：{System.Buffers.Binary.BinaryPrimitives.ReadUInt32LittleEndian(data.AsSpan(38))}";
                }
            }
            catch (FormatException) { }
            if (Content.Length != 0) text += "\r\n内容：" + Content;
            return text + "\r\n\r\n未确认的字段请查看原始数据；待发送表示进入队列，不代表发送成功。";
        }
    }
    internal string Original
    {
        get
        {
            string json = Raw;
            try { using var doc = JsonDocument.Parse(Raw); json = JsonSerializer.Serialize(doc.RootElement, new JsonSerializerOptions { WriteIndented = true, Encoder = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping }); } catch (JsonException) { }
            var result = new System.Text.StringBuilder(json);
            try
            {
                byte[] data = Convert.FromHexString(Hex);
                if (data.Length != 0) result.Append("\r\n\r\n字节偏移    HEX\r\n");
                for (int offset = 0; offset < data.Length; offset += 16)
                    result.Append(offset.ToString("X8")).Append("    ").AppendJoin(' ', data.Skip(offset).Take(16).Select(b => b.ToString("X2"))).Append("\r\n");
            }
            catch (FormatException) { result.Append("\r\n十六进制内容无效，原始记录保留如上。"); }
            return result.ToString();
        }
    }
    private static string RoomMode(byte mode) => mode switch { 0 => "个人生存", 1 => "团队生存", 2 => "个人死亡竞赛", 3 => "团队死亡竞赛", 4 => "新手引导", 5 => "自由练习", _ => $"尚未标注（{mode}）" };
    private static string FriendlyError(string line) => line.Contains("ssh:") ? "独立测试数据库的 SSH 通道连接失败。" : line.Contains("cannot open game database") ? "无法连接游戏数据库。" : line.Contains("listening on") ? "服务器监听已启动。" : line.Contains("Local server startup failed") ? "本地服务器启动失败，请检查下面的原始原因。" : "服务器运行记录";
    internal static readonly Dictionary<uint, string> Names = new()
    {
        [1010]="登录游戏",[1020]="登录基础数据",[1120]="背包列表",[1125]="角色创建选项",[1130]="角色资料",[1150]="创建角色",[1151]="角色创建成功",[1152]="创建角色失败",[1156]="P2P 身份绑定",[1157]="连接心跳",
        [1230]="点券余额",[1240]="金币余额",[2010]="进入大厅 / 频道",[2030]="进入大厅通知",[2060]="退出登录",[2070]="退出登录确认",[2080]="装备物品",[2090]="装备变更",[2100]="装备失败",[2160]="新增背包物品",[2161]="更新背包物品",[2162]="移除背包物品",[2250]="请求玩家列表",[2260]="请求房间列表",[2270]="玩家列表",[2280]="房间列表",[2300]="卸下物品",[2420]="查看玩家资料",[2421]="玩家资料响应",[2430]="查看武器库存",[2431]="武器库存响应",
        [3010]="创建房间 / 新手引导",[3020]="房间创建成功",[3030]="房间创建失败",[3070]="进入房间",[3100]="房间进入数据",[3110]="退出房间",[3115]="返回大厅",[3130]="玩家离开房间",[3140]="踢出玩家请求",[3150]="踢出通知",[3160]="房主变更",[3200]="修改房间设置",[3220]="房间设置通知",[3230]="切换队伍",[3250]="队伍变更通知",[3550]="房间数据回执",
        [4030]="玩家准备",[4050]="准备状态通知",[4060]="取消准备",[4070]="取消准备通知",[4080]="加载战斗",[4081]="开战失败",[4120]="房间 / 战斗实体数据",[4124]="完成新手引导",[4125]="称号与奖励候选",[4126]="选择奖励武器",[4160]="资源加载完成",[4170]="玩家资源就绪",[4180]="全员资源就绪",[6000]="查询任务及待领取奖励",
        [1540]="请求商品目录",[1550]="商品目录",[9040]="购买商品",[9050]="购买结果",[9070]="请求商城分类",[9080]="商城分类数据",[8040]="战斗输入就绪",[8050]="战斗渲染准备",[8070]="战斗开始",[8071]="战斗事件",[8090]="战斗时钟",[8120]="移动",[8121]="血量变化",[8122]="状态变化",[8126]="技能效果",[8127]="能量变化",[8140]="动作",[8150]="BUFF / DEBUFF",[8155]="战斗记分板",[20150]="系统提示"
    };
}
