using System.Security.Cryptography;
using System.Text;

namespace KfoLogin;

internal sealed record PatchPoint(long Offset, byte[] Original, byte[] Patched, string Label);

/// <summary>
/// gfxz.dat（1.13.0.594）GPK/更新绕过补丁 + 登录会话注入。
/// 逻辑逐条对照 <c>tools/patch_kfo_client.py</c> 与 <c>gpk-bypass-patch-guide.md</c>：
/// P1 掐死 GPKitClt 初始化、P2–P5 观察者守卫 je→jmp、P6 会话注入跳转 + 代码洞；
/// gpk/fuc.A 清零、gpk/ver 顶版、三个 ini + Data/config.xml 指向回环、SGDP.dat 封口。
/// 所有写盘动作前留备份，且可重复执行（幂等）。
/// </summary>
internal static class ClientPatcher
{
    // --- gfxz.dat 二进制补丁点（文件偏移）------------------------------------
    private static readonly PatchPoint[] BinaryPatches =
    {
        new(0x63D083, Convert.FromHexString("E884DDBAFF"), Convert.FromHexString("B801000000"), "P1 掐死 GPK 初始化"),
        new(0x4218F0, Convert.FromHexString("7477"),       Convert.FromHexString("EB77"),       "P2 观察者守卫 je->jmp"),
        new(0x63BD94, Convert.FromHexString("741C"),       Convert.FromHexString("EB1C"),       "P3 发送侧观察者 je->jmp"),
        new(0x63FBE5, Convert.FromHexString("74"),         Convert.FromHexString("EB"),         "P4 旁路调用点 je->jmp"),
        new(0x6405DC, Convert.FromHexString("7424"),       Convert.FromHexString("EB24"),       "P5 接收侧观察者 je->jmp"),
        new(0x51228D, Convert.FromHexString("833DEC867C"), Convert.FromHexString("E9FBEA2100"), "P6a 会话注入跳转"),
    };

    public const long CodeCaveOffset = 0x730D8D;
    public const long SessionOffset = 0x730DBC;
    public const int SessionLength = Legacy.SessionLength;
    public const string DefaultSession = "KKSESSION627628A244FAD22D7A6BC86BFF228AC";

    private static readonly byte[] CodeCave = Convert.FromHexString(
        "E89E188DFF6A006A0068B419B3006A00" +
        "E8AE12DEFF6A006A006A006A01E8A112" +
        "DEFFE90316DEFF00000000BC19B3004B" +
        "4B53455353494F4E3632373632384132" +
        "34344641443232443741364243383642" +
        "46463232384143"); // 87 字节

    // --- 其它文件 ------------------------------------------------------------
    private const string GpkFucA = "gpk/fuc.A";
    private static readonly long[] GpkFucAOffsets = { 0x72, 0x7A, 0x82 };
    private const string GpkVer = "gpk/ver";

    private const string LocalHttp = "http://127.0.0.1:8088";

    private static readonly string AutoPatchIni =
        "[update]\r\n\r\n" +
        ";更新文件url\r\n" +
        $"UpdateUrl={LocalHttp}/gfxz/\r\n\r\n" +
        ";主界面显示的页面url\r\n" +
        $"ShowUrl={LocalHttp}/boot.html\r\n\r\n" +
        ";Config.xml下载地址\r\n" +
        $"ConfigUrl={LocalHttp}/gfxz/config.xml\r\n\r\n" +
        ";文件检查url\r\n" +
        $"CheckUrl={LocalHttp}/gfxz/\r\n\r\n" +
        ";游戏客户端下载地址\r\n" +
        $"ClientUrl={LocalHttp}\r\n\r\n" +
        ";更新成功后待启动游戏\r\n" +
        "Game=gfxz.dat\r\n";

    private static readonly string CheckIni =
        "[Config]\r\n" +
        ";获取chkVer.dat文件路径\r\n" +
        $"CheckUrl={LocalHttp}/chkVer.dat\r\n";

    private static readonly string GpkUpdateIni =
        "[gpkupdateinfo]\r\n" +
        $"url={LocalHttp}/gfxz/gpk/\r\n";

    private static readonly string ConfigXml =
        "<?xml version=\"1.0\" encoding=\"gb2312\" ?>\r\n" +
        "<GameClient>\r\n" +
        "\t<Updater>\r\n" +
        "\t\t<UpdateInfo Url=\"http://127.0.0.1:8088/updateinfo.zip           \"></UpdateInfo>\r\n" +
        "\t\t<LaunchExe Name=\"KKClient.dat\"></LaunchExe>\r\n" +
        "\t</Updater>\r\n" +
        "\t<PrePaidURL URL=\"http://127.0.0.1:8088/pay.html                 \"></PrePaidURL>\r\n" +
        "\t<RegisterURL URL= \"http://127.0.0.1:8088/register.html                    \"   />\r\n" +
        "\t<OperationURL opcode=\"\" />\r\n" +
        "\t<!--  \t服务器相关配置    -->\r\n" +
        "\t<LoginServer ID=\"3\" Name=\"三区（全国电信）\" Ip=\"127.0.0.1\"     Port=\"8000\" loadigw=\"3\" AreaID=\"3\"></LoginServer>\r\n" +
        "\t<LoginServer ID=\"2\" Name=\"二区（全国网通）\" Ip=\"127.0.0.1\"    Port=\"8000\" loadigw=\"2\" AreaID=\"2\"></LoginServer>\r\n" +
        "\t<LoginServer ID=\"10\" Name=\"一区（全国电信）\" Ip=\"127.0.0.1\"     Port=\"8000\" loadigw=\"1\" AreaID=\"1\"></LoginServer>\r\n" +
        "</GameClient>\r\n";

    private static readonly (string Name, string Content)[] TextRewrites =
    {
        ("AutoPatch.ini", AutoPatchIni),
        ("check.ini", CheckIni),
        ("gpkupdate.ini", GpkUpdateIni),
        ("Data/config.xml", ConfigXml),
    };

    private static readonly string[] SgdpHosts =
    {
        "reportcollector.igalive.com", "errorcollector.igalive.com",
        "cfg.igalive.com", "update.igalive.com", "gfxz.autopatch.sdo.com",
        "kk.sdo.com", "sdo.com", "igalive.com",
    };

    public static string GfxzPath(string clientDir) => Path.Combine(clientDir, "gfxz.dat");

    public static bool HasClient(string clientDir) => File.Exists(GfxzPath(clientDir));

    // ---------------------------------------------------------------- 校验

    /// <summary>返回缺失/异常的补丁点描述；空列表表示补丁完整。</summary>
    public static List<string> Check(string clientDir)
    {
        var bad = new List<string>();
        string path = GfxzPath(clientDir);
        if (!File.Exists(path))
        {
            bad.Add("找不到 gfxz.dat");
            return bad;
        }

        byte[] data = File.ReadAllBytes(path);
        foreach (PatchPoint p in BinaryPatches)
        {
            if (!data.AsSpan((int)p.Offset, p.Patched.Length).SequenceEqual(p.Patched))
                bad.Add($"{p.Offset:X8} {p.Label}");
        }

        byte[] cave = data.AsSpan((int)CodeCaveOffset, CodeCave.Length).ToArray();
        byte[] session = data.AsSpan((int)SessionOffset, SessionLength).ToArray();
        if (!Encoding.ASCII.GetString(session).StartsWith(Legacy.SessionPrefix))
            bad.Add("代码洞会话串未就位");

        string fuc = Path.Combine(clientDir, GpkFucA);
        if (File.Exists(fuc))
        {
            byte[] fd = File.ReadAllBytes(fuc);
            if (GpkFucAOffsets.Any(o => fd[o] != 0))
                bad.Add("gpk/fuc.A 标志位未清零");
        }

        string ver = Path.Combine(clientDir, GpkVer);
        if (File.Exists(ver))
        {
            ReadOnlySpan<byte> text = File.ReadAllBytes(ver);
            if (!text.TrimEnd((byte)0x20).SequenceEqual("0006"u8))
                bad.Add("gpk/ver 非 0006");
        }

        return bad;
    }

    // ---------------------------------------------------------------- 应用

    /// <summary>应用 GPK/更新绕过全部补丁（幂等）。返回 (改动数, 校验后缺失项)。</summary>
    public static (int Changed, List<string> Missing) Apply(string clientDir, Action<string, bool> log)
    {
        string path = GfxzPath(clientDir);
        if (!File.Exists(path))
            throw new FileNotFoundException("找不到客户端 gfxz.dat", path);

        int changed = ApplyGfxzBinary(path, log);
        ApplyExtras(clientDir, log);

        List<string> missing = Check(clientDir);
        return (changed, missing);
    }

    private static int ApplyGfxzBinary(string path, Action<string, bool> log)
    {
        string backup = path + ".pregpk.bak";
        if (!File.Exists(backup))
        {
            File.Copy(path, backup);
            log($"原件 -> {Path.GetFileName(backup)}", false);
        }

        byte[] data = File.ReadAllBytes(path);
        int changed = 0;

        foreach (PatchPoint p in BinaryPatches)
        {
            Span<byte> cur = data.AsSpan((int)p.Offset, p.Patched.Length);
            if (cur.SequenceEqual(p.Patched)) continue;
            if (!cur.SequenceEqual(p.Original))
            {
                log($"{p.Offset:X8} 原始字节不匹配，跳过（请先还原）", true);
                continue;
            }
            p.Patched.CopyTo(data.AsSpan((int)p.Offset));
            changed++;
        }

        Span<byte> caveSpan = data.AsSpan((int)CodeCaveOffset, CodeCave.Length);
        if (caveSpan.SequenceEqual(new byte[CodeCave.Length]))
        {
            CodeCave.CopyTo(data.AsSpan((int)CodeCaveOffset));
            changed++;
        }

        if (changed > 0)
        {
            MakeWritable(path);
            File.WriteAllBytes(path, data);
        }
        log($"gfxz.dat 写入 {changed} 处改动", false);
        return changed;
    }

    private static void ApplyExtras(string clientDir, Action<string, bool> log)
    {
        string fuc = Path.Combine(clientDir, GpkFucA);
        if (File.Exists(fuc))
        {
            Backup(fuc, ".orig");
            byte[] data = File.ReadAllBytes(fuc);
            foreach (long o in GpkFucAOffsets) data[o] = 0x00;
            MakeWritable(fuc);
            File.WriteAllBytes(fuc, data);
            log("gpk/fuc.A 三字节清零", false);
        }

        string ver = Path.Combine(clientDir, GpkVer);
        if (File.Exists(ver))
        {
            Backup(ver, ".bak");
            MakeWritable(ver);
            File.WriteAllBytes(ver, "0006"u8.ToArray());
            log("gpk/ver -> 0006", false);
        }

        Encoding gb = Encoding.GetEncoding("GB18030");
        foreach ((string name, string content) in TextRewrites)
        {
            string p = Path.Combine(clientDir, name);
            if (!File.Exists(p))
            {
                log($"{name} 不存在，跳过", true);
                continue;
            }
            Backup(p, ".orig");
            MakeWritable(p);
            File.WriteAllBytes(p, gb.GetBytes(content));
            log($"{name} 已改写为本地回环", false);
        }

        string sgdp = Path.Combine(clientDir, "SGDP.dat");
        if (File.Exists(sgdp))
        {
            Backup(sgdp, ".bak");
            byte[] body = File.ReadAllBytes(sgdp);
            foreach (string host in SgdpHosts)
                body = Replace(body, Encoding.ASCII.GetBytes(host), "127.0.0.1"u8.ToArray());
            MakeWritable(sgdp);
            File.WriteAllBytes(sgdp, body);
            log("SGDP.dat 公网主机 -> 127.0.0.1", false);
        }
    }

    // ---------------------------------------------------------------- 会话注入

    /// <summary>把本轮 sessionId 定长 40 字节写入代码洞（0x730DBC）。</summary>
    public static void InjectSession(string clientDir, string session)
    {
        if (session.Length != SessionLength)
            throw new ArgumentException($"session 必须为 {SessionLength} 字节", nameof(session));

        string path = GfxzPath(clientDir);
        byte[] data = File.ReadAllBytes(path);
        Encoding.ASCII.GetBytes(session).CopyTo(data.AsSpan((int)SessionOffset));
        MakeWritable(path);
        File.WriteAllBytes(path, data);
    }

    // ---------------------------------------------------------------- 工具

    private static void MakeWritable(string path)
    {
        try
        {
            FileAttributes attrs = File.GetAttributes(path);
            if (attrs.HasFlag(FileAttributes.ReadOnly))
                File.SetAttributes(path, attrs & ~FileAttributes.ReadOnly);
        }
        catch (IOException) { }
    }

    private static void Backup(string path, string suffix)
    {
        string target = path + suffix;
        if (!File.Exists(target))
            File.Copy(path, target);
    }

    private static byte[] Replace(byte[] haystack, byte[] needle, byte[] replacement)
    {
        int idx = haystack.AsSpan().IndexOf(needle);
        if (idx < 0) return haystack;
        using var ms = new MemoryStream();
        ms.Write(haystack, 0, idx);
        ms.Write(replacement);
        ms.Write(haystack, idx + needle.Length, haystack.Length - idx - needle.Length);
        return Replace(ms.ToArray(), needle, replacement); // 处理多次出现
    }
}
