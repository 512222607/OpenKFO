using System.Diagnostics;
using System.Text.Json;

namespace OpenKFO.Updater;
internal static class Program
{
    [STAThread]
    static void Main(string[] args)
    {
        ApplicationConfiguration.Initialize(); try
        {
            if (args.Contains("--self-test")) { UpdateTests.Run(); return; }
            string Get(string key) { int i = Array.IndexOf(args, key); if (i < 0 || i + 1 >= args.Length) throw new ArgumentException("缺少参数：" + key); return args[i + 1]; }
            string kind = Get("--kind"), target = Path.GetFullPath(Get("--target")); var uri = UpdateEngine.SecureUri(Get("--manifest"));
            string? bridge = kind == "weapons" ? Path.GetFullPath(Get("--bridge")) : null;
            using var mutex = new Mutex(false, "Local\\OpenKFOUpdate-" + UpdateEngine.Hash(System.Text.Encoding.UTF8.GetBytes(target.ToLowerInvariant())));
            if (!mutex.WaitOne(0)) { throw new IOException("另一个更新程序正在运行。"); }
            try { using var form = new UpdateForm(kind, target, uri, bridge); Application.Run(form); } finally { mutex.ReleaseMutex(); }
        }
        catch (Exception e) { Environment.ExitCode = 1; MessageBox.Show(e.Message, "更新失败", MessageBoxButtons.OK, MessageBoxIcon.Error); }
    }
}
internal sealed class UpdateForm : Form
{
    readonly string kind, target; readonly Uri uri; readonly string? bridge;
    readonly TextBox notes = new() { Multiline = true, ReadOnly = true, ScrollBars = ScrollBars.Vertical, Dock = DockStyle.Fill };
    readonly Label status = new() { Text = "正在检查更新…", Dock = DockStyle.Top, Height = 45 };
    readonly Button install = new() { Text = "下载并更新", Dock = DockStyle.Bottom, Height = 48, Enabled = false };
    readonly HttpClient http = new(new HttpClientHandler { AllowAutoRedirect = false }) { Timeout = TimeSpan.FromSeconds(30) };
    Manifest? manifest; bool working;
    internal UpdateForm(string kind, string target, Uri uri, string? bridge)
    {
        this.kind = kind; this.target = target; this.uri = uri; this.bridge = bridge;
        Environment.ExitCode = 2;
        Text = kind == "gm" ? "GM管理器 · 更新" : "功夫小子 · 武器配置更新"; Width = 650; Height = 470; StartPosition = FormStartPosition.CenterScreen; Font = new Font("Microsoft YaHei UI", 10); Padding = new Padding(18);
        Controls.Add(notes); Controls.Add(status); Controls.Add(install); install.Click += async (_, _) => await Install(); Shown += async (_, _) => await Check();
        FormClosing += (_, e) => { if (working) e.Cancel = true; };
    }
    async Task Check()
    {
        try
        {
            manifest = JsonSerializer.Deserialize<Manifest>(await UpdateEngine.Download(http, uri, 65536, _ => { })) ?? throw new IOException("更新清单为空。"); UpdateEngine.Validate(manifest, kind);
            bool current = UpdateEngine.Current(manifest, target);
            if (kind == "weapons" && current) current = System.Text.Json.Nodes.JsonNode.Parse(File.ReadAllText(bridge!))!["config_hash"]?.GetValue<string>() == manifest.ConfigHash && File.Exists(Path.Combine(target, "weapon-update-notes.txt"));
            if (current) { Environment.ExitCode = 0; status.Text = "已经是最新版本"; if (kind == "weapons") { Close(); return; } notes.Text = manifest.Notes; return; }
            status.Text = "新版本：" + manifest.Version; notes.Text = manifest.Notes + "\r\n\r\n" + (kind == "gm" ? "替换前会关闭 GM 管理器，完成后重新打开。" : "替换前会关闭该客户端目录下的全部游戏窗口。完成后请重新启动游戏。"); install.Enabled = true;
        }
        catch (Exception e) { status.Text = "检查失败"; notes.Text = e.Message; Environment.ExitCode = 1; }
    }
    async Task Install()
    {
        working = true; install.Enabled = false; try
        {
            var bytes = await UpdateEngine.Download(http, new Uri(uri, manifest!.Package), manifest.Size, s => status.Text = s);
            var files = await Task.Run(() => UpdateEngine.Unpack(manifest, bytes));
            status.Text = "正在关闭占用程序…"; await StopProcesses();
            status.Text = "正在安装…"; await Task.Run(() => UpdateEngine.Apply(manifest, files, target, bridge));
            status.Text = "更新完成"; Environment.ExitCode = 0; working = false;
            if (kind == "gm") Process.Start(new ProcessStartInfo(Path.Combine(target, "GM管理器.exe")) { UseShellExecute = true, WorkingDirectory = target });
            Close();
        }
        catch (Exception e) { status.Text = "更新失败，未完成替换"; notes.Text = e.Message; Environment.ExitCode = 1; install.Enabled = true; working = false; }
    }
    async Task StopProcesses()
    {
        foreach (var process in Process.GetProcesses()) using (process)
            {
                if (process.Id == Environment.ProcessId) continue; string? path; try { path = process.MainModule?.FileName; } catch { continue; }
                if (path == null) continue;
                bool owned = kind == "gm" ? Path.GetDirectoryName(path)!.Equals(target, StringComparison.OrdinalIgnoreCase) && (Path.GetFileName(path) == "GM管理器.exe" || Path.GetFileName(path) == "kungfu-desktop-admin.exe") : path.Equals(Path.Combine(target, "gfld.dat"), StringComparison.OrdinalIgnoreCase);
                if (kind == "weapons" && bridge != null && Path.GetFileName(path).Equals("OnlineBridge.exe", StringComparison.OrdinalIgnoreCase) && path.StartsWith(Path.Combine(Path.GetDirectoryName(bridge)!, "launcher-components") + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase)) owned = true;
                if (!owned) continue; process.CloseMainWindow(); using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(5)); try { await process.WaitForExitAsync(timeout.Token); } catch (OperationCanceledException) { process.Kill(); await process.WaitForExitAsync(); }
            }
    }
    protected override void Dispose(bool disposing) { if (disposing) http.Dispose(); base.Dispose(disposing); }
}
