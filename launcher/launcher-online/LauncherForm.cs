using System.Diagnostics;
using System.Text.Json;

namespace KungFuLauncher;

internal sealed class LauncherForm : Form
{
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
    private readonly Button launch = MakeButton("启动选中窗口", true);
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
        Text = $"功夫小子 · {instances.EnvironmentName}登录器";
        Font = new Font("Microsoft YaHei UI", 10);
        ClientSize = new Size(900, 850);
        MinimumSize = new Size(915, 885);
        StartPosition = FormStartPosition.CenterScreen;
        BackColor = Color.FromArgb(242, 245, 250);
        var layout = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(28), ColumnCount = 1, RowCount = 7 };
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, localServer.Supported ? 195 : 145));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 38));
        layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 63));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 80));
        Controls.Add(layout);
        var heading = new FlowLayoutPanel { AutoSize = true, Dock = DockStyle.Fill, FlowDirection = FlowDirection.TopDown, WrapContents = false };
        heading.Controls.Add(new Label { Text = "功夫小子", AutoSize = true, Font = new Font("Microsoft YaHei UI", 24, FontStyle.Bold), ForeColor = Color.FromArgb(25, 40, 65) });
        heading.Controls.Add(new Label { Text = instances.EnvironmentDescription, AutoSize = true, ForeColor = Color.DimGray });
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
        heading.Controls.Add(updates);
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
        layout.Controls.Add(new Label { Text = "游戏窗口", Dock = DockStyle.Fill, TextAlign = ContentAlignment.MiddleLeft, Font = new Font(Font, FontStyle.Bold) }, 0, 2);
        windows.Columns.Add("窗口", 300); windows.Columns.Add("状态", 440);
        for (int number = 1; number <= instances.WindowCount; number++)
        {
            var item = new ListViewItem("窗口 " + number) { Tag = number };
            item.SubItems.Add("未启动");
            windows.Items.Add(item);
        }
        windows.Items[0].Selected = true;
        windows.DoubleClick += async (_, _) => await LaunchSelected();
        layout.Controls.Add(windows, 0, 3);
        var credentials = new FlowLayoutPanel { AutoSize = true, Dock = DockStyle.Fill, FlowDirection = FlowDirection.TopDown, WrapContents = false, Padding = new Padding(0, 8, 0, 0) };
        var inputs = new FlowLayoutPanel { AutoSize = true, WrapContents = true, MaximumSize = new Size(800, 0) };
        var save = MakeButton("保存账号密码", false);
        inputs.Controls.AddRange(new Control[] { new Label { Text = "账号", AutoSize = true }, account, new Label { Text = "密码", AutoSize = true }, password, hidePassword, save });
        hidePassword.CheckedChanged += (_, _) => password.UseSystemPasswordChar = hidePassword.Checked;
        credentials.Controls.AddRange(new Control[] { credentialTitle, new Label { Text = "登录即注册账号（账号不存在时自动注册）；已有账号需输入正确密码。", AutoSize = true, ForeColor = Color.DimGray }, inputs, new Label { Text = "按窗口分别记住；切换窗口、启动或关闭登录器时自动保存。清空两项可移除记录。", AutoSize = true, ForeColor = Color.DimGray } });
        layout.Controls.Add(credentials, 0, 4);
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
        help.Click += (_, _) => MessageBox.Show(this, instances.UsageInstructions, "登录器使用说明", MessageBoxButtons.OK, MessageBoxIcon.Information);
        actions.Controls.AddRange(new Control[] { launch, another, focus, logs, help });
        another.Visible = false;
        layout.Controls.Add(actions, 0, 5);
        var footer = new TableLayoutPanel { Dock = DockStyle.Fill, RowCount = 2 };
        footer.RowStyles.Add(new RowStyle(SizeType.Percent, 55)); footer.RowStyles.Add(new RowStyle(SizeType.Percent, 45));
        activity.ForeColor = Color.FromArgb(45, 70, 105); footer.Controls.Add(activity, 0, 0);
        footer.Controls.Add(new Label { Text = "关闭登录器不会关闭游戏。响应耗时是服务器健康检查耗时，不是对战延迟。", AutoSize = true, ForeColor = Color.DimGray, Font = new Font(Font.FontFamily, 9) }, 0, 1);
        layout.Controls.Add(footer, 0, 6);
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
        try { await instances.LaunchAsync(number, new Progress<string>(text => { if (!IsDisposed) activity.Text = text; })); }
        catch (Exception exception) { activity.Text = "启动失败：" + exception.Message; MessageBox.Show(this, exception.Message, "启动失败", MessageBoxButtons.OK, MessageBoxIcon.Warning); }
        finally { launching = false; launch.Enabled = another.Enabled = true; RefreshWindows(); }
    }
    private void RefreshWindows()
    {
        foreach (ListViewItem item in windows.Items)
        {
            int number = (int)item.Tag!;
            bool running = instances.IsRunning(number);
            try { string name = instances.LoadCredentials(number).Account; item.Text = "窗口 " + number + (name.Length == 0 ? "" : " - " + name); if (running) instances.UpdateGameTitle(number, name); }
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
