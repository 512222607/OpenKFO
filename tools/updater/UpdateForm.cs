using System.Diagnostics;
using System.Text.Json;
namespace OpenKFO.Updater;
internal sealed class UpdateForm : Form
{
    string kind; readonly string target; Uri uri; readonly string? bridge;
    readonly string? launcher, restartRoot;
    internal bool Completed { get; private set; }
    readonly TextBox notes = new() { Multiline = true, ReadOnly = true, ScrollBars = ScrollBars.Vertical, Dock = DockStyle.Fill };
    readonly Label status = new() { Text = "正在检查更新…", Dock = DockStyle.Top, Height = 45 };
    readonly Button install = new() { Text = "下载并更新", Dock = DockStyle.Bottom, Height = 48, Enabled = false };
    readonly HttpClient http = new(new HttpClientHandler { AllowAutoRedirect = false }) { Timeout = TimeSpan.FromSeconds(30) };
    Manifest? manifest; bool working;
    string? offlineManifest;
    readonly Button local = new() { Text = "选择本地更新清单…", AutoSize = true };
    internal UpdateForm(string kind, string target, Uri uri, string? bridge, string? launcher = null, string? restartRoot = null, string? offlineManifest = null)
    {
        this.kind = kind; this.target = target; this.uri = uri; this.bridge = bridge;
        this.launcher = launcher; this.restartRoot = restartRoot;
        this.offlineManifest = offlineManifest;
        Text = kind == "gm" ? "GM管理器 · 更新" : kind == "launcher" ? "启动器更新" : "客户端更新"; Width = 650; Height = 470; StartPosition = FormStartPosition.CenterScreen; Font = new Font("Microsoft YaHei UI", 10); Padding = new Padding(18);
        MinimumSize = new Size(500, 360);
        var layout = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 1, RowCount = 4 };
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize)); layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100)); layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 52));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        status.AutoSize = true; status.Dock = DockStyle.Fill; install.Dock = DockStyle.Fill;
        layout.Controls.Add(status, 0, 0); layout.Controls.Add(notes, 0, 1); layout.Controls.Add(install, 0, 2); Controls.Add(layout); install.Click += async (_, _) => await Install(); Shown += async (_, _) => await Check();
        layout.Controls.Add(local, 0, 3);
        local.Click += async (_, _) => {
            using var picker = new OpenFileDialog { Filter = "更新清单 (*.json)|*.json", Title = "选择发布者提供的更新清单，配套 ZIP 应在同一目录" };
            if (picker.ShowDialog(this) != DialogResult.OK) return;
            offlineManifest = picker.FileName; await Check();
        };
        FormClosing += (_, e) => { if (working) e.Cancel = true; };
    }
    async Task Check()
    {
        local.Enabled = false; install.Enabled = false; manifest = null;
        try
        {
            if (File.Exists(Path.Combine(UpdateEngine.StateDirectory(target, kind), "journal.json")))
            {
                working = true;
                try { status.Text = "正在恢复上次未完成的更新…"; await StopProcesses(); UpdateEngine.Recover(target, kind); }
                finally { working = false; }
            }
            byte[] raw;
            try { raw = offlineManifest == null ? await UpdateEngine.Download(http, uri, 65536, _ => { }) : UpdateEngine.ReadLocal(offlineManifest, 65536); }
            catch (HttpRequestException error) when (kind == "client" && error.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                kind = "weapons"; uri = new Uri(uri, "weapons.json");
                raw = await UpdateEngine.Download(http, uri, 65536, _ => { });
            }
            catch (HttpRequestException error) when (kind == "launcher" && error.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                Completed = true; Close(); return;
            }
            manifest = JsonSerializer.Deserialize<Manifest>(raw) ?? throw new IOException("更新清单为空。"); UpdateEngine.Validate(manifest, kind);
            bool current = UpdateEngine.Current(manifest, target, launcher);
            if (kind is "client" or "weapons" && current) current = System.Text.Json.Nodes.JsonNode.Parse(File.ReadAllText(bridge!))!["config_hash"]?.GetValue<string>() == manifest.ConfigHash;
            if (current) { Completed = true; status.Text = "已经是最新版本"; if (kind != "gm") { Close(); return; } notes.Text = manifest.Notes; return; }
            install.Text = offlineManifest == null ? "下载并更新" : "安装本地更新包";
            status.Text = "新版本：" + manifest.Version; notes.Text = manifest.Notes + "\r\n\r\n" + (kind == "gm" ? "替换前会关闭 GM 管理器，完成后重新打开。" : kind == "launcher" ? "更新助手会关闭旧登录器、替换并自动重新打开。游戏窗口不受影响。" : "替换前会关闭该客户端目录下的全部游戏窗口，完成后继续启动游戏。"); install.Enabled = true;
        }
        catch (Exception e) { status.Text = "检查失败"; notes.Text = PublicError(e); }
        finally { local.Enabled = true; }
    }
    async Task Install()
    {
        working = true; install.Enabled = false; local.Enabled = false; try
        {
            var release = manifest ?? throw new InvalidOperationException("请先选择有效的更新清单。");
            var bytes = offlineManifest == null
                ? await UpdateEngine.Download(http, new Uri(uri, release.Package), release.Size, s => status.Text = s)
                : await Task.Run(() => UpdateEngine.ReadLocal(Path.Combine(Path.GetDirectoryName(offlineManifest)!, release.Package), release.Size));
            var files = await Task.Run(() => UpdateEngine.Unpack(release, bytes));
            status.Text = "正在关闭占用程序…"; await StopProcesses();
            status.Text = "正在安装…"; await Task.Run(() => UpdateEngine.Apply(release, files, target, kind == "launcher" ? Path.Combine(restartRoot!, "bridge.json") : bridge, launcher: launcher));
            status.Text = "更新完成"; Completed = true; working = false;
            if (kind == "gm") Process.Start(new ProcessStartInfo(Path.Combine(target, "GM管理器.exe")) { UseShellExecute = true, WorkingDirectory = target });
            if (kind == "launcher")
            {
                var start = new ProcessStartInfo(launcher!) { UseShellExecute = true, WorkingDirectory = target };
                start.ArgumentList.Add("--root"); start.ArgumentList.Add(restartRoot!);
                Process.Start(start);
            }
            Close();
        }
        catch (Exception e) { status.Text = "更新失败，未完成替换"; notes.Text = PublicError(e); install.Enabled = true; working = false; }
        finally { local.Enabled = true; }
    }
    async Task StopProcesses()
    {
        foreach (var process in Process.GetProcesses()) using (process)
            {
                if (process.Id == Environment.ProcessId) continue; string? path; try { path = process.MainModule?.FileName; } catch { continue; }
                if (path == null) continue;
                bool owned = kind == "gm" ? Path.GetDirectoryName(path)!.Equals(target, StringComparison.OrdinalIgnoreCase) && (Path.GetFileName(path) == "GM管理器.exe" || Path.GetFileName(path) == "kungfu-desktop-admin.exe") : path.Equals(Path.Combine(target, "gfld.dat"), StringComparison.OrdinalIgnoreCase);
                if (kind == "launcher") owned = path.Equals(launcher, StringComparison.OrdinalIgnoreCase);
                if (kind != "gm" && bridge != null && Path.GetFileName(path).Equals("OnlineBridge.exe", StringComparison.OrdinalIgnoreCase) && path.StartsWith(Path.Combine(Path.GetDirectoryName(bridge)!, "launcher-components") + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase)) owned = true;
                if (!owned) continue; process.CloseMainWindow(); using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(5)); try { await process.WaitForExitAsync(timeout.Token); } catch (OperationCanceledException) { process.Kill(); await process.WaitForExitAsync(); }
            }
    }
    static string PublicError(Exception e)
    {
        try {
            string folder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "OpenKFO", "Updater");
            Directory.CreateDirectory(folder); File.AppendAllText(Path.Combine(folder, "update.log"), DateTimeOffset.Now + "\n" + e + "\n");
        } catch { }
        return e is HttpRequestException or TaskCanceledException
            ? "在线更新连接失败，现有文件未替换。可选择发布者提供的本地更新清单进行安装。\r\n诊断日志：%LOCALAPPDATA%\\OpenKFO\\Updater\\update.log"
            : e.Message;
    }
    protected override void Dispose(bool disposing) { if (disposing) http.Dispose(); base.Dispose(disposing); }
}
