using System.Diagnostics;
using System.Text.Json;

namespace KungFuLauncher;

internal sealed class LauncherForm : Form
{
    private readonly InstanceManager instances;
    private readonly HttpClient http = new() { Timeout = TimeSpan.FromSeconds(8) };
    private readonly Label serverState = new() { Text = "正在检测服务器…", AutoSize = true, Font = new Font("Microsoft YaHei UI", 15, FontStyle.Bold), ForeColor = Color.FromArgb(40, 80, 145) };
    private readonly Label serverDetail = new() { Text = "健康检查尚未完成", AutoSize = true, ForeColor = Color.DimGray };
    private readonly Label activity = new() { Text = "选择一个窗口启动；每个游戏窗口请登录不同账号。", AutoSize = false, Dock = DockStyle.Fill };
    private readonly ListView windows = new() { View = View.Details, FullRowSelect = true, MultiSelect = false, HideSelection = false, Dock = DockStyle.Fill, BorderStyle = BorderStyle.None };
    private readonly Button launch = MakeButton("启动选中窗口", true);
    private readonly Button another = MakeButton("再开一个窗口", false);
    private readonly Button refresh = MakeButton("刷新服务器状态", false);
    private readonly System.Windows.Forms.Timer timer = new() { Interval = 3000 };
    private bool launching;
    private bool checking;
    private DateTime lastCheck = DateTime.MinValue;
    internal bool StatusReady => !checking && lastCheck != DateTime.MinValue;
    internal string StatusText => serverState.Text + " / " + serverDetail.Text;

    internal LauncherForm(InstanceManager manager, int[] startWindows)
    {
        instances = manager;
        AutoScaleDimensions = new SizeF(96, 96);
        AutoScaleMode = AutoScaleMode.Dpi;
        Text = "功夫小子 · 线上登录器";
        Font = new Font("Microsoft YaHei UI", 10);
        ClientSize = new Size(900, 850);
        MinimumSize = new Size(915, 885);
        StartPosition = FormStartPosition.CenterScreen;
        BackColor = Color.FromArgb(242, 245, 250);
        var layout = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(28), ColumnCount = 1, RowCount = 6 };
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 110));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 145));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 38));
        layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 63));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 80));
        Controls.Add(layout);
        var heading = new FlowLayoutPanel { Dock = DockStyle.Fill, FlowDirection = FlowDirection.TopDown, WrapContents = false };
        heading.Controls.Add(new Label { Text = "功夫小子", AutoSize = true, Font = new Font("Microsoft YaHei UI", 24, FontStyle.Bold), ForeColor = Color.FromArgb(25, 40, 65) });
        heading.Controls.Add(new Label { Text = "线上测试 · 多窗口登录", AutoSize = true, ForeColor = Color.DimGray });
        layout.Controls.Add(heading, 0, 0);
        var status = new TableLayoutPanel { Dock = DockStyle.Fill, BackColor = Color.White, Padding = new Padding(14), Margin = new Padding(0, 5, 0, 8), ColumnCount = 2 };
        status.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100)); status.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 185));
        var details = new FlowLayoutPanel { Dock = DockStyle.Fill, FlowDirection = FlowDirection.TopDown, WrapContents = false };
        details.Controls.AddRange(new Control[] { serverState, serverDetail });
        refresh.Anchor = AnchorStyles.None;
        status.Controls.Add(details, 0, 0); status.Controls.Add(refresh, 1, 0);
        layout.Controls.Add(status, 0, 1);
        layout.Controls.Add(new Label { Text = "游戏窗口", Dock = DockStyle.Fill, TextAlign = ContentAlignment.MiddleLeft, Font = new Font(Font, FontStyle.Bold) }, 0, 2);
        windows.Columns.Add("窗口", 300); windows.Columns.Add("状态", 440);
        for (int number = 1; number <= InstanceManager.MaximumInstances; number++)
        {
            var item = new ListViewItem("窗口 " + number) { Tag = number };
            item.SubItems.Add("未启动");
            windows.Items.Add(item);
        }
        windows.Items[0].Selected = true;
        windows.DoubleClick += async (_, _) => await LaunchSelected();
        layout.Controls.Add(windows, 0, 3);
        var actions = new FlowLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(0, 13, 0, 0) };
        var focus = MakeButton("显示游戏窗口", false);
        var logs = MakeButton("查看窗口日志", false);
        actions.Controls.AddRange(new Control[] { launch, another, focus, logs });
        layout.Controls.Add(actions, 0, 4);
        var footer = new TableLayoutPanel { Dock = DockStyle.Fill, RowCount = 2 };
        footer.RowStyles.Add(new RowStyle(SizeType.Percent, 55)); footer.RowStyles.Add(new RowStyle(SizeType.Percent, 45));
        activity.ForeColor = Color.FromArgb(45, 70, 105); footer.Controls.Add(activity, 0, 0);
        footer.Controls.Add(new Label { Text = "关闭登录器不会关闭游戏。响应耗时是服务器健康检查耗时，不是对战延迟。", AutoSize = true, ForeColor = Color.DimGray, Font = new Font(Font.FontFamily, 9) }, 0, 1);
        layout.Controls.Add(footer, 0, 5);
        launch.Click += async (_, _) => await LaunchSelected();
        another.Click += async (_, _) =>
        {
            for (int number = 1; number <= InstanceManager.MaximumInstances; number++)
                if (!instances.IsRunning(number)) { windows.Items[number - 1].Selected = true; await Launch(number); return; }
            activity.Text = "8 个窗口都已启动。";
        };
        focus.Click += (_, _) => instances.Activate(SelectedNumber());
        logs.Click += (_, _) =>
        {
            string path = instances.LogPath(SelectedNumber());
            if (File.Exists(path)) Process.Start(new ProcessStartInfo("notepad.exe") { ArgumentList = { path }, UseShellExecute = false });
            else activity.Text = "这个窗口尚未生成新登录器日志。";
        };
        refresh.Click += async (_, _) => await CheckServer();
        timer.Tick += async (_, _) => { RefreshWindows(); if ((DateTime.UtcNow - lastCheck).TotalSeconds >= 15) await CheckServer(); };
        Shown += async (_, _) => { RefreshWindows(); timer.Start(); await CheckServer(); foreach (int number in startWindows) await Launch(number); };
        FormClosing += (_, args) =>
        {
            if (launching) { args.Cancel = true; activity.Text = "正在准备客户端，请等待本次启动完成后再关闭。"; }
        };
        FormClosed += (_, _) => { timer.Dispose(); http.Dispose(); };
    }

    private static Button MakeButton(string text, bool primary) => new()
    {
        Text = text, Size = new Size(172, 38), FlatStyle = FlatStyle.Flat, Margin = new Padding(0, 0, 12, 0),
        BackColor = primary ? Color.FromArgb(37, 99, 200) : Color.White,
        ForeColor = primary ? Color.White : Color.FromArgb(40, 60, 90), Cursor = Cursors.Hand
    };
    private int SelectedNumber() => windows.SelectedItems.Count == 0 ? 1 : (int)windows.SelectedItems[0].Tag!;
    private Task LaunchSelected() => Launch(SelectedNumber());
    private async Task Launch(int number)
    {
        if (launching) return;
        launching = true; launch.Enabled = another.Enabled = false;
        try { await instances.LaunchAsync(number, new Progress<string>(text => { if (!IsDisposed) activity.Text = text; })); }
        catch (Exception exception) { activity.Text = "启动失败：" + exception.Message; MessageBox.Show(this, exception.Message, "启动失败", MessageBoxButtons.OK, MessageBoxIcon.Warning); }
        finally { launching = false; launch.Enabled = another.Enabled = true; RefreshWindows(); }
    }
    private void RefreshWindows()
    {
        foreach (ListViewItem item in windows.Items)
        {
            bool running = instances.IsRunning((int)item.Tag!);
            item.SubItems[1].Text = running ? "游戏已运行" : "未启动";
            item.ForeColor = running ? Color.FromArgb(20, 125, 75) : Color.FromArgb(55, 65, 80);
        }
    }
    private async Task CheckServer()
    {
        if (checking) return;
        checking = true; refresh.Enabled = false;
        var elapsed = Stopwatch.StartNew();
        try
        {
            await instances.CheckHealthAsync(http);
            if (IsDisposed) return;
            serverState.Text = "●  服务器在线"; serverState.ForeColor = Color.FromArgb(20, 135, 80);
            serverDetail.Text = $"响应 {elapsed.ElapsedMilliseconds} ms · 最近检测 {DateTime.Now:HH:mm:ss}";
        }
        catch (Exception exception)
        {
            if (IsDisposed) return;
            serverState.Text = "●  服务器暂不可达"; serverState.ForeColor = Color.FromArgb(185, 65, 55);
            serverDetail.Text = $"{DateTime.Now:HH:mm:ss} · " + (exception is TaskCanceledException ? "检测超时，可稍后重试" : "连接或健康检查失败");
        }
        finally { lastCheck = DateTime.UtcNow; checking = false; if (!IsDisposed) refresh.Enabled = true; }
    }
}
