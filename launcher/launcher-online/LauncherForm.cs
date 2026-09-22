using System.Diagnostics;
using System.Text.Json;

namespace KungFuLauncher;

internal sealed class LauncherForm : Form
{
    private readonly CheckBox highFrameRate = new() { Text = "高帧模式（约125 FPS，实验）", AutoSize = true };
    private readonly CheckBox showFPS = new() { Text = "顶部居中显示 FPS（窗口模式）", AutoSize = true, Checked = true };
    private readonly InstanceManager instances;
    private readonly LocalServerController localServer;
    private readonly Button startServer = MakeButton("启动本地服务器", false);
    private readonly Button stopServer = MakeButton("停止本地服务器", false);
    private bool controllingServer;
    private readonly HttpClient http = new() { Timeout = TimeSpan.FromSeconds(8) };
    private readonly Label serverState = new() { Text = "正在检测服务器…", AutoSize = true, Font = new Font("Microsoft YaHei UI", 15, FontStyle.Bold), ForeColor = Color.FromArgb(40, 80, 145) };
    private readonly Label serverDetail = new() { Text = "健康检查尚未完成", AutoSize = true, ForeColor = Color.DimGray };
    private readonly Label activity = new() { Text = "选择一个窗口启动；每个游戏窗口请登录不同账号。", AutoSize = false, Dock = DockStyle.Fill };
    private readonly ListView windows = new() { View = View.Details, FullRowSelect = true, MultiSelect = false, HideSelection = false, Dock = DockStyle.Fill, BorderStyle = BorderStyle.None };
    private readonly Button launch = MakeButton("启动游戏", true);
    private readonly Button another = MakeButton("再开一个窗口", false);
    private readonly CheckBox hidePassword = new() { Text = "隐藏密码", AutoSize = true };
    private readonly Button refresh = MakeButton("刷新服务器状态", false);
    private readonly System.Windows.Forms.Timer timer = new() { Interval = 3000 };
    private bool launching;
    private bool checking;
    private readonly TextBox account = new() { Width = 190 };
    private readonly TextBox password = new() { Width = 170, UseSystemPasswordChar = false };
    private readonly Label credentialTitle = new() { AutoSize = true, Text = "窗口 1 的账号" };
    private int credentialWindow = 1;
    private bool credentialsLoaded;
    private DateTime lastCheck = DateTime.MinValue;
    internal bool StatusReady => !checking && lastCheck != DateTime.MinValue;
    internal string StatusText => serverState.Text + " / " + serverDetail.Text;

    internal LauncherForm(InstanceManager manager, int[] startWindows)
    {
        instances = manager;
        localServer = new LocalServerController(instances.RootDirectory, instances.Endpoint);
        AutoScaleDimensions = new SizeF(96, 96);
        AutoScaleMode = AutoScaleMode.Dpi;
        Text = "启动器";
        Font = new Font("Microsoft YaHei UI", 10);
        ClientSize = new Size(960, 740);
        MinimumSize = new Size(900, 740);
        StartPosition = FormStartPosition.CenterScreen;
        BackColor = Color.FromArgb(242, 245, 250);
        var layout = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(24), ColumnCount = 1, RowCount = 6 };
        layout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 42));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, localServer.Supported ? 166 : 112));
        layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 66));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 62));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 68));
        Controls.Add(layout);
        var heading = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 2, RowCount = 1, Margin = Padding.Empty };
        heading.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        heading.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
        heading.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        heading.Controls.Add(new Label { Text = instances.EnvironmentDescription, AutoSize = true, Anchor = AnchorStyles.Left, ForeColor = Color.DimGray }, 0, 0);
        var updates = new LinkLabel { Text = "客户端更新说明", AutoSize = true };
        updates.LinkClicked += (_, _) =>
        {
            string path = Path.Combine(instances.SourceDirectory, "client-update-notes.txt");
            if (!File.Exists(path)) path = Path.Combine(instances.SourceDirectory, "weapon-update-notes.txt");
            string text;
            try { text = File.Exists(path) ? File.ReadAllText(path) : "点击启动游戏时会先检查客户端更新。当前没有已安装的更新说明。"; }
            catch (IOException) { text = "暂时无法读取更新说明，请稍后重试。"; }
            using var dialog = new Form { Text = "客户端更新说明", Size = new Size(650, 470), StartPosition = FormStartPosition.CenterParent, Font = Font };
            dialog.Controls.Add(new TextBox { Text = text, Multiline = true, ReadOnly = true, ScrollBars = ScrollBars.Vertical, Dock = DockStyle.Fill });
            dialog.ShowDialog(this);
        };
        updates.Anchor = AnchorStyles.Right;
        heading.Controls.Add(updates, 1, 0);
        layout.Controls.Add(heading, 0, 0);
        var status = new TableLayoutPanel { Dock = DockStyle.Fill, BackColor = Color.White, Padding = new Padding(14), Margin = new Padding(0, 5, 0, 8), ColumnCount = 2 };
        status.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100)); status.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 185));
        var details = new FlowLayoutPanel { Dock = DockStyle.Fill, FlowDirection = FlowDirection.TopDown, WrapContents = false };
        details.Controls.AddRange(new Control[] { serverState, serverDetail });
        refresh.Anchor = AnchorStyles.None;
        var serverActions = new FlowLayoutPanel { Dock = DockStyle.Fill, FlowDirection=FlowDirection.TopDown, WrapContents=false };
        refresh.Margin=new Padding(0,0,0,6);startServer.Margin=new Padding(0,0,0,6);
        serverActions.Controls.Add(refresh);
        if(localServer.Supported){serverActions.Controls.Add(startServer);serverActions.Controls.Add(stopServer);details.Controls.Add(new Label{Text="停止服务器会断开所有本地玩家。",AutoSize=true,ForeColor=Color.DimGray});}
        status.Controls.Add(details, 0, 0); status.Controls.Add(serverActions, 1, 0);
        layout.Controls.Add(status, 0, 1);
        var body = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 2, RowCount = 1, Margin = Padding.Empty };
        body.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 42));
        body.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 58));
        body.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        layout.Controls.Add(body, 0, 2);
        var windowPanel = new TableLayoutPanel { Dock = DockStyle.Fill, BackColor = Color.White, Padding = new Padding(14), ColumnCount = 1, RowCount = 2, Margin = new Padding(0, 0, 12, 0) };
        windowPanel.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        windowPanel.RowStyles.Add(new RowStyle(SizeType.Absolute, 36));
        windowPanel.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        windowPanel.Controls.Add(new Label { Text = "游戏窗口", AutoSize = true, Font = new Font(Font, FontStyle.Bold) }, 0, 0);
        body.Controls.Add(windowPanel, 0, 0);
        windows.Columns.Add("窗口 / 账号", 220); windows.Columns.Add("状态", 90);
        windows.SizeChanged += (_, _) => { if (windows.ClientSize.Width > 120) { windows.Columns[1].Width = 90; windows.Columns[0].Width = windows.ClientSize.Width - 94; } };
        for (int number = 1; number <= instances.WindowCount; number++)
        {
            var item = new ListViewItem("窗口 " + number) { Tag = number };
            item.SubItems.Add("未启动");
            windows.Items.Add(item);
        }
        windows.Items[0].Selected = true;
        windows.DoubleClick += async (_, _) => await LaunchSelected();
        windowPanel.Controls.Add(windows, 0, 1);
        var credentials = new TableLayoutPanel { Dock = DockStyle.Fill, BackColor = Color.White, Padding = new Padding(18), ColumnCount = 1, RowCount = 8, AutoScroll = true, Margin = Padding.Empty };
        credentials.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        foreach (int height in new[] { 32, 46, 24, 42, 24, 42, 44, 54 }) credentials.RowStyles.Add(new RowStyle(SizeType.Absolute, height));
        credentials.RowStyles[1].SizeType = SizeType.AutoSize;
        credentials.RowStyles[7].SizeType = SizeType.AutoSize;
        credentialTitle.Font = new Font(Font, FontStyle.Bold);
        credentials.Controls.Add(credentialTitle, 0, 0);
        credentials.Controls.Add(new Label { Text = "账号不存在时自动注册。\n已有账号请输入正确密码。", AutoSize = true, Dock = DockStyle.Fill, Margin = new Padding(3, 0, 3, 12), ForeColor = Color.DimGray }, 0, 1);
        credentials.Controls.Add(new Label { Text = "账号", AutoSize = true }, 0, 2);
        account.Dock = DockStyle.Top; account.PlaceholderText = "输入账号";
        credentials.Controls.Add(account, 0, 3);
        credentials.Controls.Add(new Label { Text = "密码", AutoSize = true }, 0, 4);
        password.Dock = DockStyle.Top; password.PlaceholderText = "输入密码";
        credentials.Controls.Add(password, 0, 5);
        var save = MakeButton("保存账号密码", false);
        var credentialActions = new FlowLayoutPanel { Dock = DockStyle.Fill, WrapContents = false, Margin = Padding.Empty };
        hidePassword.Margin = new Padding(0, 9, 20, 0);
        credentialActions.Controls.AddRange(new Control[] { hidePassword, save });
        credentials.Controls.Add(credentialActions, 0, 6);
        hidePassword.CheckedChanged += (_, _) => password.UseSystemPasswordChar = hidePassword.Checked;
        credentials.Controls.Add(new Label { Text = "账号按窗口分别记住，启动或切换窗口时自动保存。\n清空账号和密码后保存，可移除本窗口记录。", AutoSize = true, Dock = DockStyle.Fill, ForeColor = Color.DimGray, Font = new Font(Font.FontFamily, 9) }, 0, 7);
        highFrameRate.Enabled = showFPS.Enabled = instances.SharedClient;
        var performance = new FlowLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(0, 6, 0, 0) };
        highFrameRate.Margin = new Padding(0, 2, 20, 0);
        performance.Controls.AddRange(new Control[] { highFrameRate, showFPS });
        performance.SetFlowBreak(showFPS, true);
        performance.Controls.Add(new Label { Text = "切换模式后需关闭游戏再启动；实际帧率取决于场景和设备。", AutoSize = true, ForeColor = Color.DimGray, Font = new Font(Font.FontFamily, 9) });
        layout.Controls.Add(performance, 0, 3);
        body.Controls.Add(credentials, 1, 0);
        save.Click += (_, _) => { if (SaveCredentials()) activity.Text = $"窗口 {credentialWindow} 的账号密码已保存在本地。"; };
        windows.SelectedIndexChanged += (_, _) =>
        {
            if (windows.SelectedItems.Count == 0 || SelectedNumber() == credentialWindow) return;
            if (!SaveCredentials()) { windows.Items[credentialWindow - 1].Selected = true; return; }
            credentialWindow = SelectedNumber();
            LoadCredentials();
        };
        LoadCredentials();
        var actions = new FlowLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(0, 13, 0, 0) };
        var focus = MakeButton("显示游戏窗口", false);
        var logs = MakeButton("查看窗口日志", false);
        var help = MakeButton("使用说明", false);
        help.Width = 88;
        help.Click += (_, _) => MessageBox.Show(this, instances.UsageInstructions, "启动器使用说明", MessageBoxButtons.OK, MessageBoxIcon.Information);
        actions.Controls.AddRange(new Control[] { launch, another, focus, logs, help });
        another.Visible = false;
        layout.Controls.Add(actions, 0, 4);
        var footer = new TableLayoutPanel { Dock = DockStyle.Fill, RowCount = 2 };
        footer.RowStyles.Add(new RowStyle(SizeType.Percent, 55)); footer.RowStyles.Add(new RowStyle(SizeType.Percent, 45));
        activity.ForeColor = Color.FromArgb(45, 70, 105); footer.Controls.Add(activity, 0, 0);
        footer.Controls.Add(new Label { Text = "关闭启动器不会关闭游戏。服务器检测耗时不等于对战延迟。", Dock = DockStyle.Fill, ForeColor = Color.DimGray, Font = new Font(Font.FontFamily, 9) }, 0, 1);
        layout.Controls.Add(footer, 0, 5);
        launch.Click += async (_, _) => await LaunchSelected();
        another.Click += async (_, _) =>
        {
            for (int number = 1; number <= instances.WindowCount; number++)
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
        RefreshServerButtons();
        startServer.Click += async (_, _) => await ControlServer(true);
        stopServer.Click += async (_, _) => await ControlServer(false);
        timer.Tick += async (_, _) => { RefreshWindows(); if ((DateTime.UtcNow - lastCheck).TotalSeconds >= 15) await CheckServer(); };
        Shown += async (_, _) => { RefreshWindows(); timer.Start(); await CheckServer(); foreach (int number in startWindows) await Launch(number); };
        FormClosing += (_, args) =>
        {
            if (launching || controllingServer) { args.Cancel = true; activity.Text = "正在启动游戏或操作服务器，请等待完成后再关闭。"; }
            else if (!SaveCredentials()) args.Cancel = true;
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
    private void LoadCredentials()
    {
        credentialsLoaded = false;
        credentialTitle.Text = $"窗口 {credentialWindow} 的账号";
        try
        {
            var saved = instances.LoadCredentials(credentialWindow);
            account.Text = saved.Account; password.Text = saved.Password;
            credentialsLoaded = true;
        }
        catch (Exception error)
        {
            account.Text = password.Text = "";
            activity.Text = "读取已保存账号失败：" + error.Message;
        }
    }
    private bool SaveCredentials()
    {
        if (!credentialsLoaded && account.Text.Length == 0 && password.Text.Length == 0) return true;
        try
        {
            instances.SaveCredentials(credentialWindow, new WindowCredentials(account.Text.Trim(), password.Text));
            windows.Items[credentialWindow - 1].Text = "窗口 " + credentialWindow + (account.Text.Trim().Length == 0 ? "" : " - " + account.Text.Trim());
            credentialsLoaded = true;
            return true;
        }
        catch (Exception error) { activity.Text = "保存账号失败：" + error.Message; return false; }
    }
    private Task LaunchSelected() => Launch(SelectedNumber());
    private async Task Launch(int number)
    {
        if (launching) return;
        if (!SaveCredentials()) return;
        launching = true; launch.Enabled = another.Enabled = false;
        try { await instances.LaunchAsync(number, new Progress<string>(text => { if (!IsDisposed) activity.Text = text; }), highFrameRate.Checked, showFPS.Checked); }
        catch (GameDirectoryException exception) { activity.Text = "请放到游戏目录下"; MessageBox.Show(this, exception.Message, "启动器提示", MessageBoxButtons.OK, MessageBoxIcon.Information); }
        catch (Exception exception) { activity.Text = "启动失败：" + exception.Message; OpenKFO.Updater.DiagnosticDialog.Show(this, "启动失败", OpenKFO.Updater.DiagnosticDialog.Details(exception, instances.LogPath(number))); }
        finally { launching = false; launch.Enabled = another.Enabled = true; RefreshWindows(); }
    }
    private void RefreshWindows()
    {
        foreach (ListViewItem item in windows.Items)
        {
            int number = (int)item.Tag!;
            bool running = instances.IsRunning(number);
            try { string name = instances.LoadCredentials(number).Account; item.Text = "窗口 " + number + (name.Length == 0 ? "" : " - " + name); if (running) instances.UpdateGameTitle(number); }
            catch (Exception error) { activity.Text = "读取窗口账号失败：" + error.Message; }
            item.SubItems[1].Text = running ? "游戏已运行" : "未启动";
            item.ForeColor = running ? Color.FromArgb(20, 125, 75) : Color.FromArgb(55, 65, 80);
        }
    }
    private async Task CheckServer()
    {
        if (checking) return;
        checking = true; refresh.Enabled = false;
        try
        {
            var timing = await instances.CheckHealthAsync(http);
            if (IsDisposed) return;
            serverState.Text = $"●  {instances.EnvironmentName}连接正常"; serverState.ForeColor = Color.FromArgb(20, 135, 80);
            serverDetail.Text = timing.RoundTripMs is long rtt
                ? $"请求往返 {rtt} ms · 连接准备 {timing.ConnectionMs} ms · {DateTime.Now:HH:mm:ss}"
                : $"健康检查总耗时 {timing.TotalMs} ms（含连接）· {DateTime.Now:HH:mm:ss}";
        }
        catch (Exception exception)
        {
            if (IsDisposed) return;
            serverState.Text = $"●  {instances.EnvironmentName}暂不可达"; serverState.ForeColor = Color.FromArgb(185, 65, 55);
            serverDetail.Text = $"{DateTime.Now:HH:mm:ss} · " + (exception is TaskCanceledException ? "检测超时，可稍后重试" : "连接或健康检查失败");
        }
        finally { lastCheck = DateTime.UtcNow; checking = false; if (!IsDisposed) { refresh.Enabled = !controllingServer; RefreshServerButtons(); } }
    }
    private void RefreshServerButtons()
    {
        bool running=localServer.IsRunning;
        startServer.Enabled=localServer.Supported&&!controllingServer&&!running;
        stopServer.Enabled=localServer.Supported&&!controllingServer&&running;
    }
    private async Task ControlServer(bool start)
    {
        if(controllingServer||launching)return;
        controllingServer=true;refresh.Enabled=launch.Enabled=another.Enabled=false;RefreshServerButtons();
        try {
            activity.Text=start?"正在启动本地服务器…":"正在停止本地服务器…";
            activity.Text=await (start?localServer.StartAsync():localServer.StopAsync());
            if(start){
                // SSH/database initialization can take a few seconds. Keep the
                // UI responsive and distinguish process start from health ready.
                var deadline=DateTime.UtcNow.AddSeconds(30);
                bool healthy=false;
                while(DateTime.UtcNow<deadline){try{await instances.CheckHealthAsync(http);healthy=true;activity.Text="本地服务器连接正常，可以启动游戏。";break;}catch{if(!localServer.IsRunning)throw new IOException("服务器启动失败，请查看后台窗口和 logs 目录。");await Task.Delay(500);}}
                if(!healthy)throw new IOException("服务器进程已启动，但30秒内尚未就绪，请查看后台窗口和 logs 目录。");
            }
            await CheckServer();
        }catch(Exception error){activity.Text="服务器操作失败："+error.Message;}
        finally{controllingServer=false;refresh.Enabled=launch.Enabled=another.Enabled=true;RefreshServerButtons();}
    }
}
