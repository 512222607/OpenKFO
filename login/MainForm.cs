using System.Text;

namespace KfoLogin;

internal sealed class MainForm : Form
{
    private readonly TextBox _clientDir = new();
    private readonly TextBox _serverDir = new();
    private readonly TextBox _account = new();
    private readonly TextBox _password = new() { UseSystemPasswordChar = true };
    private readonly TextBox _endpoint = new() { Text = "127.0.0.1:19091" };
    private readonly Button _loginButton = new() { Text = "登录并启动", Height = 32 };
    private readonly Button _stopButton = new() { Text = "停止客户端", Height = 32, Enabled = false };
    private readonly Label _status = new() { Text = "就绪", AutoSize = true, ForeColor = Color.FromArgb(26, 127, 55) };
    private readonly RichTextBox _log = new()
    {
        ReadOnly = true, BackColor = Color.FromArgb(250, 250, 250),
        Font = new Font("Consolas", 9f), WordWrap = false, ScrollBars = RichTextBoxScrollBars.Both,
    };
    private readonly System.Windows.Forms.Timer _watch = new() { Interval = 1500 };

    private Launcher? _launcher;

    public MainForm()
    {
        Text = "OpenKFO 本地登录器";
        ClientSize = new Size(680, 520);
        MinimumSize = new Size(680, 520);
        Font = new Font("Microsoft YaHei UI", 9f);
        StartPosition = FormStartPosition.CenterScreen;

        BuildLayout();
        AutoLocate();
        Shown += (_, _) =>
        {
            Log($"客户端目录  {_clientDir.Text}", false);
            Log($"服务端目录  {_serverDir.Text}", false);
            if (!Directory.Exists(_serverDir.Text) || !File.Exists(Path.Combine(_serverDir.Text, "config.json")))
                Log("警告：服务端目录下缺少 config.json，请先启动/解压本地服务端", true);
        };

        _watch.Tick += (_, _) =>
        {
            if (_launcher is null) return;
            if (!_launcher.ClientAlive)
            {
                Log("客户端已退出", false);
                SetStatus("客户端已退出", Color.FromArgb(107, 114, 128));
                _watch.Stop();
            }
        };
    }

    private void BuildLayout()
    {
        var root = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 3,
            Padding = new Padding(12),
            RowCount = 7,
        };
        root.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 88));
        root.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        root.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 92));
        for (int i = 0; i < 5; i++) root.RowStyles.Add(new RowStyle(SizeType.Absolute, 38));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 52));
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100));

        // 客户端目录
        root.Controls.Add(FieldLabel("客户端目录"), 0, 0);
        _clientDir.Dock = DockStyle.Fill;
        root.Controls.Add(_clientDir, 1, 0);
        root.Controls.Add(BrowseButton(() => _clientDir.Text, dir =>
        {
            _clientDir.Text = dir;
            AutoLocateFrom(dir);
        }), 2, 0);

        // 服务端目录
        root.Controls.Add(FieldLabel("服务端目录"), 0, 1);
        _serverDir.Dock = DockStyle.Fill;
        root.Controls.Add(_serverDir, 1, 1);
        root.Controls.Add(BrowseButton(() => _serverDir.Text, dir => _serverDir.Text = dir), 2, 1);

        // 账号
        root.Controls.Add(FieldLabel("账号"), 0, 2);
        _account.Dock = DockStyle.Fill;
        root.Controls.Add(_account, 1, 2);

        // 密码
        root.Controls.Add(FieldLabel("密码"), 0, 3);
        _password.Dock = DockStyle.Fill;
        root.Controls.Add(_password, 1, 3);

        // 服务端地址
        root.Controls.Add(FieldLabel("服务端地址"), 0, 4);
        _endpoint.Dock = DockStyle.Fill;
        root.Controls.Add(_endpoint, 1, 4);
        root.Controls.Add(_status, 2, 4);

        // 按钮行
        var buttons = new FlowLayoutPanel { Dock = DockStyle.Fill, FlowDirection = FlowDirection.LeftToRight };
        _loginButton.Width = 130;
        _stopButton.Width = 130;
        _loginButton.Click += (_, _) => DoLogin();
        _stopButton.Click += (_, _) => DoStop();
        buttons.Controls.Add(_loginButton);
        buttons.Controls.Add(_stopButton);
        root.Controls.Add(buttons, 0, 5);
        root.SetColumnSpan(buttons, 3);

        // 日志
        _log.Dock = DockStyle.Fill;
        root.Controls.Add(_log, 0, 6);
        root.SetColumnSpan(_log, 3);

        Controls.Add(root);
        AcceptButton = null;
    }

    private static Label FieldLabel(string text) =>
        new() { Text = text, Dock = DockStyle.Fill, TextAlign = ContentAlignment.MiddleLeft };

    private Button BrowseButton(Func<string> current, Action<string> apply)
    {
        var button = new Button { Text = "浏览…", Dock = DockStyle.Fill };
        button.Click += (_, _) =>
        {
            using var dialog = new FolderBrowserDialog { ShowNewFolderButton = false };
            string start = current();
            if (Directory.Exists(start)) dialog.SelectedPath = start;
            if (dialog.ShowDialog(this) == DialogResult.OK)
                apply(dialog.SelectedPath);
        };
        return button;
    }

    // ---------------------------------------------------------------- 自动定位

    private void AutoLocate()
    {
        string? server = FindUpwards(AppContext.BaseDirectory, Path.Combine("dist", "local-server", "config.json"));
        if (server is not null) _serverDir.Text = Path.GetDirectoryName(server)!;

        if (_serverDir.Text.Length > 0)
            AutoLocateFrom(_serverDir.Text);
    }

    private void AutoLocateFrom(string serverDir)
    {
        if (_clientDir.Text.Length > 0 && ClientPatcher.HasClient(_clientDir.Text)) return;
        string? client = FindUpwards(serverDir, Path.Combine("client", "gfxz.dat"));
        if (client is not null) _clientDir.Text = Path.GetDirectoryName(client)!;
    }

    private static string? FindUpwards(string start, string relative)
    {
        var dir = new DirectoryInfo(start);
        while (dir is not null)
        {
            string candidate = Path.Combine(dir.FullName, relative);
            if (File.Exists(candidate)) return candidate;
            dir = dir.Parent;
        }
        return null;
    }

    // ---------------------------------------------------------------- 动作

    private void DoLogin()
    {
        if (_launcher is not null && _launcher.ClientAlive)
        {
            MessageBox.Show(this, "客户端已在运行，请先停止。", "提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }

        string clientDir = _clientDir.Text.Trim();
        string serverDir = _serverDir.Text.Trim();
        string account = _account.Text.Trim();
        string password = _password.Text;

        if (clientDir.Length == 0 || !ClientPatcher.HasClient(clientDir))
        {
            MessageBox.Show(this, "请选择包含 gfxz.dat 的客户端目录。", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }
        if (serverDir.Length == 0 || !File.Exists(Path.Combine(serverDir, "config.json")))
        {
            MessageBox.Show(this, "请选择包含 config.json 与 certificates/origin.crt 的服务端目录。", "提示",
                MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }
        if (account.Length == 0 || password.Length == 0)
        {
            MessageBox.Show(this, "请输入账号和密码。", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }
        if (account.Length is < 3 or > 20 || !account.All(char.IsLetterOrDigit))
        {
            MessageBox.Show(this, "账号需为 3–20 位字母或数字。", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        string[] hostPort = _endpoint.Text.Trim().Split(':', 2);
        string host = hostPort[0].Length > 0 ? hostPort[0] : "127.0.0.1";
        int tunnelPort = hostPort.Length > 1 && int.TryParse(hostPort[1], out int p) ? p : 19091;

        _loginButton.Enabled = false;
        SetStatus("认证中…", Color.FromArgb(180, 83, 9));
        Log("—— 开始登录 ——", false);

        string client = clientDir, server = serverDir;
        ThreadPool.QueueUserWorkItem(_ =>
        {
            var launcher = new Launcher(client, server, host, tunnelPort, 8000, 8001, Log);
            try
            {
                launcher.Start(account, password, launchClient: true);
                _launcher = launcher;
                SetStatus($"已连接 uid={launcher.Uid}", Color.FromArgb(26, 127, 55));
                Log("登录流程完成，客户端运行中；关闭本窗口会一并停止", false);
                BeginInvoke(() =>
                {
                    _loginButton.Enabled = true;
                    _stopButton.Enabled = true;
                    _watch.Start();
                });
            }
            catch (Exception ex)
            {
                launcher.Stop();
                Log("失败：" + ex.Message, true);
                SetStatus("失败", Color.FromArgb(185, 28, 28));
                BeginInvoke(() => _loginButton.Enabled = true);
            }
        });
    }

    private void DoStop()
    {
        _watch.Stop();
        _launcher?.Stop();
        _launcher = null;
        SetStatus("已停止", Color.FromArgb(107, 114, 128));
        Log("已停止客户端与桥", false);
        _stopButton.Enabled = false;
        _loginButton.Enabled = true;
    }

    // ---------------------------------------------------------------- 日志

    private void Log(string message, bool isError)
    {
        if (IsDisposed) return;
        if (InvokeRequired)
        {
            try { BeginInvoke(() => Log(message, isError)); } catch (InvalidOperationException) { }
            return;
        }
        _log.SelectionColor = isError ? Color.FromArgb(185, 28, 28) : Color.FromArgb(55, 65, 81);
        _log.AppendText((isError ? "!! " : "· ") + message + Environment.NewLine);
        _log.SelectionStart = _log.TextLength;
        _log.ScrollToCaret();
    }

    private void SetStatus(string text, Color color)
    {
        if (IsDisposed) return;
        if (InvokeRequired)
        {
            try { BeginInvoke(() => SetStatus(text, color)); } catch (InvalidOperationException) { }
            return;
        }
        _status.Text = text;
        _status.ForeColor = color;
    }

    protected override void OnFormClosing(FormClosingEventArgs e)
    {
        _watch.Stop();
        _launcher?.Stop();
        base.OnFormClosing(e);
    }
}
