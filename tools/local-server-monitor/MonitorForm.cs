using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text;

namespace OpenKFO.Monitor;

internal sealed class MonitorForm : Form
{
    [System.Runtime.InteropServices.DllImport("user32.dll")]
    private static extern bool ShowWindow(nint window,int command);
    private readonly string root;
    private readonly ServerHost host;
    private readonly CancellationTokenSource cancellation = new();
    private readonly ConcurrentQueue<TraceRow> incoming = new();
    private readonly List<TraceRow> rows = [];
    private readonly List<TraceRow> visible = [];
    private readonly Label status = new() { AutoSize = true, Text = "正在读取本地状态…", Padding = new Padding(0, 9, 10, 0) };
    private readonly TextBox search = new() { Width = 330, PlaceholderText = "账号 / 玩家 / UID / 协议号 / 名称" };
    private readonly CheckBox hideHeartbeat = new() { Text = "隐藏心跳及健康检查", AutoSize = true };
    private readonly CheckBox pause = new() { Text = "暂停刷新", AutoSize = true };
    private readonly CheckBox follow = new() { Text = "跟随最新", AutoSize = true, Checked = true };
    private readonly ListView list = new() { Dock = DockStyle.Fill, View = View.Details, FullRowSelect = true, HideSelection = false, VirtualMode = true, MultiSelect = false };
    private readonly TextBox description = DetailBox(false), raw = DetailBox(true);
    private readonly Button start = new() { Text = "启动服务器", AutoSize = true }, stop = new() { Text = "停止服务器", AutoSize = true };
    private readonly System.Windows.Forms.Timer timer = new() { Interval = 250 };
    private readonly object startupLock = new();
    private int queued, queuedBytes, dropped, byteCount, ticks;
    private bool busy, closing;
    private TraceRow? selected;
    private static TextBox DetailBox(bool monospace) => new() { Multiline = true, ReadOnly = true, Dock = DockStyle.Fill, ScrollBars = ScrollBars.Both, WordWrap = !monospace, Font = new Font(monospace ? "Consolas" : "Microsoft YaHei UI", 10), MaxLength = 0 };
    internal MonitorForm(string root, bool autoStart)
    {
        this.root = Path.GetFullPath(root); host = new ServerHost(this.root, Report);
        Text = "功夫小子 · 本地服务器日志"; Size = new Size(1250, 850); MinimumSize = new Size(950, 650); Font = new Font("Microsoft YaHei UI", 10); StartPosition = FormStartPosition.CenterScreen;
        var top = new FlowLayoutPanel { Dock = DockStyle.Top, AutoSize = true, Padding = new Padding(12), WrapContents = true };
        var folder = new Button { Text = "打开日志目录", AutoSize = true };
        var clear = new Button { Text = "清空显示", AutoSize = true };
        top.Controls.AddRange([status, start, stop, folder, clear]);
        var filters = new FlowLayoutPanel { Dock = DockStyle.Top, AutoSize = true, Padding = new Padding(12, 0, 12, 10) };
        filters.Controls.AddRange([search, hideHeartbeat, pause, follow]);
        foreach (var c in new[] { ("时间", 120), ("玩家", 130), ("账号", 125), ("方向", 225), ("协议", 75), ("内容", 280), ("字节", 75) }) list.Columns.Add(c.Item1, c.Item2);
        list.RetrieveVirtualItem += (_, e) =>
        {
            if (e.ItemIndex >= visible.Count) { e.Item = new ListViewItem(""); return; }
            var r = visible[e.ItemIndex];
            e.Item = new ListViewItem([r.Clock, r.Player, r.Account, r.Flow, r.Direction == "" ? "—" : r.Protocol.ToString(), r.Direction == "" ? r.Content : r.Name, r.Direction == "" ? "" : r.Length.ToString()]);
            e.Item.ForeColor = r.Direction.StartsWith("C->") ? Color.FromArgb(32, 91, 170) : r.Direction.StartsWith("S->") ? Color.FromArgb(30, 125, 75) : Color.FromArgb(130, 85, 20);
        };
        list.SelectedIndexChanged += (_, _) =>
        {
            if (list.SelectedIndices.Count > 0 && list.SelectedIndices[0] < visible.Count) { selected = visible[list.SelectedIndices[0]]; description.Text = selected.Description; raw.Text = selected.Original; }
        };
        var tabs = new TabControl { Dock = DockStyle.Fill };
        var readable = new TabPage("中文详情"); readable.Controls.Add(description); var original = new TabPage("原始数据 JSON / HEX"); original.Controls.Add(raw); tabs.TabPages.AddRange([readable, original]);
        var split = new SplitContainer { Size = new Size(1200, 700), Dock = DockStyle.Fill, Orientation = Orientation.Horizontal, Panel1MinSize = 180, Panel2MinSize = 130, SplitterDistance = 400 };
        split.Panel1.Controls.Add(list); split.Panel2.Controls.Add(tabs);
        var footer = new Label { Dock = DockStyle.Bottom, Height = 30, Text = "仅本地文件读取 · 完整日志保留在 logs · 窗口最多 5000 条 / 32 MB · 关闭窗口会停止本窗口启动的服务器", Padding = new Padding(12, 5, 0, 0) };
        Controls.Add(split); Controls.Add(filters); Controls.Add(top); Controls.Add(footer);
        start.Click += async (_, _) => await Operate(host.StartAsync); stop.Click += async (_, _) => await Operate(host.StopAsync);
        folder.Click += (_, _) => { try { Directory.CreateDirectory(Path.Combine(this.root, "logs")); Process.Start(new ProcessStartInfo(Path.Combine(this.root, "logs")) { UseShellExecute = true }); } catch (Exception e) { Report(e.Message); } };
        clear.Click += (_, _) => { rows.Clear(); byteCount = 0; selected = null; description.Clear(); raw.Clear(); Refilter(); };
        search.TextChanged += (_, _) => Refilter(); hideHeartbeat.CheckedChanged += (_, _) => Refilter();
        timer.Tick += (_, _) => RefreshRows();
        Shown += async (_, _) => { ShowWindow(Handle,5); timer.Start(); _ = ReadFilesAsync(); if (autoStart) await Operate(host.StartAsync); };
        FormClosing += async (_, e) =>
        {
            if (!closing && busy) { e.Cancel=true; Report("正在操作服务器，请稍后关闭窗口。"); return; }
            if (!closing && host.OwnsRunning)
            {
                e.Cancel = true;
                if (busy) { Report("正在操作服务器，请稍后关闭窗口。"); return; }
                await Operate(host.StopAsync); closing = true; Close(); return;
            }
            closing = true; cancellation.Cancel(); timer.Stop(); host.Dispose();
        };
    }
    private async Task Operate(Func<Task> action)
    {
        if (busy) return; busy = true; start.Enabled = stop.Enabled = false;
        try { await action(); } catch (Exception e) { Report("操作失败：" + e.Message); }
        finally { busy = false; if (!closing) { start.Enabled = stop.Enabled = true; } }
    }
    private void Enqueue(string line)
    {
        int bytes=line.Length*2;
        int count=Interlocked.Increment(ref queued);
        int total=Interlocked.Add(ref queuedBytes,bytes);
        if (count > 10000 || total > 32*1024*1024) { Interlocked.Decrement(ref queued); Interlocked.Add(ref queuedBytes,-bytes); Interlocked.Increment(ref dropped); return; }
        incoming.Enqueue(TraceRow.Parse(line));
    }
    private void Report(string message)
    {
        Enqueue(message);
        try { lock (startupLock) { Directory.CreateDirectory(Path.Combine(root, "logs")); File.AppendAllText(Path.Combine(root, "logs", "monitor-startup.log"), DateTimeOffset.Now.ToString("O") + " " + message + Environment.NewLine, Encoding.UTF8); } }
        catch (IOException) { }
        catch (UnauthorizedAccessException) { }
    }
    private async Task ReadFilesAsync()
    {
        await Task.Run(async () =>
        {
            using var tail = new LogTail(); string lastError = "";
            while (!cancellation.IsCancellationRequested)
            {
                try { tail.Poll(Path.Combine(root, "logs"), Enqueue); lastError = ""; }
                catch (Exception e) when (e is IOException or UnauthorizedAccessException) { if (lastError != e.Message) { Enqueue("日志读取失败：" + e.Message); lastError = e.Message; } }
                try { await Task.Delay(200, cancellation.Token); } catch (OperationCanceledException) { break; }
            }
        });
    }
    private void RefreshRows()
    {
        if (!pause.Checked)
        {
            bool changed = false;
            for (int i = 0; i < 500 && incoming.TryDequeue(out var row); i++) { Interlocked.Decrement(ref queued); Interlocked.Add(ref queuedBytes,-row.Raw.Length*2); rows.Add(row); byteCount += row.Raw.Length * 2; changed = true; }
            int remove = 0;
            while (rows.Count - remove > 1 && (rows.Count - remove > 5000 || byteCount > 32 * 1024 * 1024)) { byteCount -= rows[remove++].Raw.Length * 2; }
            if (remove > 0) rows.RemoveRange(0, remove);
            if (changed) Refilter();
        }
        if (++ticks % 8 == 0)
        {
            using var running = host.Find();
            status.Text = (running is null ? "● 已停止" : "● 进程运行中") + $"  显示 {visible.Count} 条" + (dropped > 0 ? $" · 窗口跳过 {dropped} 条" : "");
            status.ForeColor = running is null ? Color.DimGray : Color.DarkGreen;
            if (!busy) { start.Enabled = running is null; stop.Enabled = running is not null; }
        }
    }
    private void Refilter()
    {
        list.BeginUpdate();
        try
        {
            list.SelectedIndices.Clear(); visible.Clear(); visible.AddRange(rows.Where(r => r.Matches(search.Text, hideHeartbeat.Checked)));
            list.VirtualListSize = visible.Count; list.Invalidate();
            if (selected is not null) { int index = visible.IndexOf(selected); if (index >= 0) list.SelectedIndices.Add(index); }
            if (follow.Checked && visible.Count > 0) list.EnsureVisible(visible.Count - 1);
        }
        finally { list.EndUpdate(); }
    }
    internal int TestInject(string line) { rows.Add(TraceRow.Parse(line)); Refilter(); return list.VirtualListSize; }
    internal void TestSelect(int index) { _ = list.Handle; list.SelectedIndices.Add(index); }
    internal string TestRaw => raw.Text;
}
