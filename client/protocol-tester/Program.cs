using System.Diagnostics;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace KungfuProtocolTester;

internal static class Program
{
    [STAThread] static void Main(string[] args) { ApplicationConfiguration.Initialize(); var form = new TesterForm(); if(args.Contains("--protocol-regression")||args.Contains("--self-test")||args.Contains("--scenario-test")||args.Contains("--acceptance-test")||args.Contains("--purchase-test"))form.Shown+=async(_,_)=>{form.Hide();try{if(args.Contains("--protocol-regression")||args.Contains("--acceptance-test")||args.Contains("--purchase-test"))await form.AcceptanceSmokeAsync(args.Contains("--purchase-test"),args.Contains("--protocol-regression"));else if(args.Contains("--scenario-test"))await form.ScenarioSmokeAsync();else await form.SmokeAsync();}catch(Exception e){File.WriteAllText(Path.Combine(AppContext.BaseDirectory,"self-test-error.txt"),e.ToString());Environment.ExitCode=1;}finally{form.Close();}}; Application.Run(form); }
}

internal sealed record Settings(string Account, string Password, string Config, string Target);

internal sealed partial class TesterForm : Form
{
    readonly TextBox account = new() { Text = "localtest10", Width = 115 };
    readonly TextBox password = new() { UseSystemPasswordChar = true, Width = 110 };
    readonly TextBox config = new() { Width = 530 };
    readonly TextBox target = new() { Text = "10001", Width = 110 };
    readonly TextBox protocol = new() { Text = "2420", Width = 75 };
    readonly TextBox payload = new() { Width = 340 };
    readonly TextBox expected = new() { Text = "2421", Width = 75 };
    readonly CheckBox reconnect = new() { Text = "断线自动重连（15秒）", Checked = true, AutoSize = true };
    readonly Button connect = new() { Text = "连接 / 保存账号", AutoSize = true };
    readonly Button disconnect = new() { Text = "断开", AutoSize = true, Enabled = false };
    readonly Label status = new() { Text = "未连接。请使用未在游戏中登录的测试账号。", AutoSize = true, ForeColor = Color.DarkSlateBlue };
    readonly ListView history = new() { View = View.Details, FullRowSelect = true, Dock = DockStyle.Fill, HideSelection = false };
    readonly TextBox detail = new() { Multiline = true, ReadOnly = true, Dock = DockStyle.Fill, ScrollBars = ScrollBars.Both, Font = new Font("Consolas",10), WordWrap = false };
    readonly List<Button> tests = new();
    readonly string root = AppContext.BaseDirectory;
    readonly System.Windows.Forms.Timer timer = new() { Interval = 250 };
    CancellationTokenSource? stop;
    Process? worker;
    bool ready;
    uint pending;
    int matches;
    DateTime sentAt;
    string logPath = "";
    StreamWriter? log;

    public TesterForm()
    {
        Text = "功夫小子 · 本地协议测试器"; Width = 1120; Height = 800; MinimumSize = new Size(980,650); StartPosition = FormStartPosition.CenterScreen;
        config.Text = Path.GetFullPath(Path.Combine(root,"..","local-server","bridge.json"));
        try { var path = Path.Combine(root,"settings.bin"); if (File.Exists(path)) { var plain = ProtectedData.Unprotect(File.ReadAllBytes(path),null,DataProtectionScope.CurrentUser); try { var s = JsonSerializer.Deserialize<Settings>(plain)!; account.Text=s.Account;password.Text=s.Password;config.Text=s.Config;target.Text=s.Target; } finally { CryptographicOperations.ZeroMemory(plain); } } } catch { status.Text="保存的设置无法读取，请重新输入。"; }
        var layout = new TableLayoutPanel { Dock=DockStyle.Fill, Padding=new Padding(12), ColumnCount=1, RowCount=9 };
        foreach (int height in new[]{40,42,42,42,35}) layout.RowStyles.Add(new RowStyle(SizeType.Absolute,height));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute,225));layout.RowStyles.Add(new RowStyle(SizeType.Percent,55));layout.RowStyles.Add(new RowStyle(SizeType.Percent,45));layout.RowStyles.Add(new RowStyle(SizeType.Absolute,34));Controls.Add(layout);
        FlowLayoutPanel Row(params Control[] controls) {var row=new FlowLayoutPanel {Dock=DockStyle.Fill,WrapContents=false};row.Controls.AddRange(controls);return row;}
        Label Label(string text)=>new(){Text=text,AutoSize=true,Margin=new Padding(3,8,3,0)};
        var browse=new Button{Text="选择配置",AutoSize=true};browse.Click+=(_,_)=>{using var d=new OpenFileDialog{Filter="连接配置|*.json",FileName=config.Text};if(d.ShowDialog()==DialogResult.OK)config.Text=d.FileName;};
        layout.Controls.Add(Row(Label("本地连接配置"),config,browse),0,0);
        layout.Controls.Add(Row(Label("账号"),account,Label("密码"),password,connect,disconnect,reconnect),0,1);
        Button Test(string name,Action action){var b=new Button{Text=name,AutoSize=true,Enabled=false};b.Click+=(_,_)=>{try{action();}catch(Exception e){Add("错误",0,0,e.Message,"");}};tests.Add(b);return b;}
        byte[] Target(){if(!ulong.TryParse(target.Text,out var uid)||uid==0)throw new Exception("目标UID必须是正整数");return BitConverter.GetBytes(uid);}
        layout.Controls.Add(Row(Label("目标玩家UID"),target,Test("查看资料 2420",()=>Send(2420,Target(),2421)),Test("兵器库 2430",()=>Send(2430,Target(),2431)),Test("余额",()=>Send(1232,[],1230)),Test("房间列表",()=>Send(2260,[1,1,0x88],2280))),0,2);
        layout.Controls.Add(Row(Label("协议号"),protocol,Label("内容 HEX"),payload,Label("预期回包"),expected,Test("发送",()=>{if(!uint.TryParse(protocol.Text,out var id)||!uint.TryParse(expected.Text,out var reply))throw new Exception("协议号必须是整数，预期填0表示不检查");Send(id,Convert.FromHexString(string.Concat(payload.Text.Where(c=>!char.IsWhiteSpace(c)))),reply);})),0,3);
        layout.Controls.Add(status,0,4);
        history.Columns.Add("时间",115);history.Columns.Add("方向/结果",95);history.Columns.Add("协议号",85);history.Columns.Add("字节",70);history.Columns.Add("说明",670);
        history.SelectedIndexChanged+=(_,_)=>{if(history.SelectedItems.Count>0)detail.Text=history.SelectedItems[0].Tag as string??"";};
        layout.Controls.Add(BuildScenarios(),0,5);
        layout.Controls.Add(history,0,6);layout.Controls.Add(detail,0,7);
        var openLogs=new Button{Text="打开日志目录",AutoSize=true};openLogs.Click+=(_,_)=>{Directory.CreateDirectory(Path.Combine(root,"logs"));Process.Start(new ProcessStartInfo("explorer.exe"){ArgumentList={Path.Combine(root,"logs")},UseShellExecute=true});};
        var clear=new Button{Text="清空列表",AutoSize=true};clear.Click+=(_,_)=>{history.Items.Clear();detail.Clear();};
        layout.Controls.Add(Row(openLogs,clear,Label("验证协议回包；游戏画面、模型和实际操作仍需客户端复测。")),0,8);
        connect.Click+=async(_,_)=>await ConnectLoop();disconnect.Click+=(_,_)=>Stop();
        timer.Tick+=(_,_)=>{if(pending!=0 && DateTime.UtcNow-sentAt>TimeSpan.FromSeconds(waitSeconds)){Add("超时",pending,0,$"{waitSeconds}秒内没有收到预期回包（不代表服务器已实现该功能）","");pending=0;}};timer.Start();
        FormClosing+=(_,_)=>{Stop();log?.Dispose();};
    }
    void SetReady(bool value){ready=value;foreach(var b in tests)b.Enabled=value;}
    void Save(){var data=JsonSerializer.SerializeToUtf8Bytes(new Settings(account.Text,password.Text,config.Text,target.Text));try{File.WriteAllBytes(Path.Combine(root,"settings.bin"),ProtectedData.Protect(data,null,DataProtectionScope.CurrentUser));}finally{CryptographicOperations.ZeroMemory(data);}}
    void Stop(){stop?.Cancel();SetReady(false);pending=0;try{worker?.StandardInput.Close();}catch{}try{if(worker is {HasExited:false})worker.Kill();}catch{} }
    void Add(string direction,uint id,int length,string text,string hex)
    {
        if(IsDisposed)return;
        var time=DateTime.Now.ToString("HH:mm:ss.fff");var row=new ListViewItem(new[]{time,direction,id==0?"":id.ToString(),length.ToString(),text}){Tag=hex};history.Items.Add(row);while(history.Items.Count>500)history.Items.RemoveAt(0);row.EnsureVisible();
        log?.WriteLine(JsonSerializer.Serialize(new{time=DateTimeOffset.Now,account=account.Text,direction,id,length,text,hex}));log?.Flush();
    }
    void Send(uint id,byte[] data,uint reply,int timeout=8)
    {
        if(!ready||worker==null)throw new Exception("尚未连接");if(pending!=0)throw new Exception("上一条请求仍在等待回包");if(data.Length>32768)throw new Exception("内容不能超过32768字节");
        Save();worker.StandardInput.WriteLine(JsonSerializer.Serialize(new{id,hex=Convert.ToHexString(data)}));worker.StandardInput.Flush();pending=reply;waitSeconds=timeout;sentAt=DateTime.UtcNow;
    }
    async Task ConnectLoop()
    {
        if(stop!=null)return;
        if(string.IsNullOrWhiteSpace(account.Text)||string.IsNullOrEmpty(password.Text)){status.Text="请输入测试账号和密码。";return;}
        try{Save();}catch(Exception e){status.Text=e.Message;return;}
        stop=new CancellationTokenSource();var token=stop.Token;connect.Enabled=false;disconnect.Enabled=true;account.ReadOnly=password.ReadOnly=config.ReadOnly=true;
        Directory.CreateDirectory(Path.Combine(root,"logs"));logPath=Path.Combine(root,"logs",$"protocol-{DateTime.Now:yyyyMMdd-HHmmss-fff}.jsonl");log=new StreamWriter(logPath,true){AutoFlush=true};
        try
        {
            string folder=Path.Combine(root,"components");Directory.CreateDirectory(folder);string image=Path.Combine(folder,"ProtocolTesterCore.exe");
            using(var resource=Assembly.GetExecutingAssembly().GetManifestResourceStream("ProtocolTesterCore.exe")!)using(var bytes=new MemoryStream()){resource.CopyTo(bytes);var data=bytes.ToArray();if(!File.Exists(image)||!SHA256.HashData(File.ReadAllBytes(image)).SequenceEqual(SHA256.HashData(data)))File.WriteAllBytes(image,data);}
            do
            {
                token.ThrowIfCancellationRequested();SetReady(false);pending=0;status.Text="正在认证并进入协议大厅…";bool fatal=false;
                var info=new ProcessStartInfo(image){UseShellExecute=false,CreateNoWindow=true,RedirectStandardInput=true,RedirectStandardOutput=true,RedirectStandardError=true,StandardInputEncoding=new UTF8Encoding(false),StandardOutputEncoding=Encoding.UTF8,StandardErrorEncoding=Encoding.UTF8,WorkingDirectory=folder};
                using var process=Process.Start(info)??throw new Exception("无法启动测试组件");worker=process;
                var stderr=process.StandardError.ReadToEndAsync(token);
                await process.StandardInput.WriteLineAsync(JsonSerializer.Serialize(new{config=config.Text,account=account.Text.Trim(),password=password.Text}));await process.StandardInput.FlushAsync();
                string? line;
                while((line=await process.StandardOutput.ReadLineAsync(token))!=null)
                {
                    using var doc=JsonDocument.Parse(line);var d=doc.RootElement;string kind=d.GetProperty("kind").GetString()??"";string text=d.GetProperty("text").GetString()??"";
                    uint id=d.TryGetProperty("id",out var v)?v.GetUInt32():0;int length=d.TryGetProperty("length",out v)?v.GetInt32():0;string hex=d.TryGetProperty("hex",out v)?v.GetString()??"":"";
                    if(kind=="ready"){ownUid=d.GetProperty("uid").GetUInt64();roomId=0;battleSerial=0;phase="大厅";SetReady(true);status.Text=$"已连接：{account.Text} / UID {ownUid}；服务器重启后自动重连。";}
                    if(kind=="disconnected"){fatal=d.TryGetProperty("fatal",out v)&&v.GetBoolean();status.Text=text;}
                    Add(kind=="send"?"发送":kind=="receive"?"接收":kind,id,length,text,hex);
                    if(kind=="receive"){history.BeginUpdate();try{Observe(id,Convert.FromHexString(hex));}finally{history.EndUpdate();}}
                    if(kind=="receive"&&pending!=0&&id==pending){matches++;Add("匹配成功",id,length,$"收到预期回包，耗时 {(DateTime.UtcNow-sentAt).TotalMilliseconds:F0} ms",hex);pending=0;}
                }
                await process.WaitForExitAsync(token);worker=null;SetReady(false);pending=0;var error=await stderr;if(!string.IsNullOrWhiteSpace(error))Add("组件错误",0,0,error,"");
                if(fatal||!reconnect.Checked)break;
                status.Text="连接断开，15秒后自动重连；无需打开游戏。";await Task.Delay(15000,token);
            }while(!token.IsCancellationRequested);
        }
        catch(OperationCanceledException){status.Text="已断开。";}
        catch(Exception e){status.Text=e.Message;Add("错误",0,0,e.Message,"");}
        finally{try{if(worker is {HasExited:false})worker.Kill();}catch{}worker=null;SetReady(false);pending=0;stop?.Dispose();stop=null;connect.Enabled=true;disconnect.Enabled=false;account.ReadOnly=password.ReadOnly=config.ReadOnly=false;log?.Dispose();log=null;}
    }
    internal async Task SmokeAsync()
    {
        password.Text=Environment.GetEnvironmentVariable("OPENKFO_TEST_PASSWORD")??throw new Exception("missing test password");
        var loop=ConnectLoop();
        async Task Until(Func<bool> condition,int seconds=30){var deadline=DateTime.UtcNow.AddSeconds(seconds);while(!condition()){if(DateTime.UtcNow>deadline)throw new Exception("test timed out: "+status.Text);await Task.Delay(100);}}
        await Until(()=>ready);
        foreach(var q in new[]{(2420u,BitConverter.GetBytes(10001ul),2421u),(21000u,BitConverter.GetBytes(10001ul),21001u),(2430u,BitConverter.GetBytes(10001ul),2431u),(1232u,Array.Empty<byte>(),1230u),(2260u,new byte[]{1,1,0x88},2280u)}){var before=matches;Send(q.Item1,q.Item2,q.Item3);await Until(()=>matches>before,12);}
        worker!.Kill();await Until(()=>!ready);await Until(()=>ready,35);
        int previous=matches;Send(2420,BitConverter.GetBytes(10001ul),2421);await Until(()=>matches>previous,12);
        using(var bitmap=new Bitmap(Width,Height)){DrawToBitmap(bitmap,new Rectangle(Point.Empty,Size));bitmap.Save(Path.Combine(root,"preview.png"));}
        Stop();await loop;
        File.WriteAllText(Path.Combine(root,"self-test.json"),JsonSerializer.Serialize(new{passed=true,matched_replies=matches,reconnected=true,real_local_server=true,game_ui_verified=false}));
    }
}
