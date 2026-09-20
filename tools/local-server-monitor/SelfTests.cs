using System.Text;
using System.Text.Json;

namespace OpenKFO.Monitor;

internal static class SelfTests
{
    internal static async Task<int> Lifecycle(string root,string[] args)
    {
        string result=Path.Combine(root,"monitor-lifecycle-test.json");
        int at=Array.IndexOf(args,"--result");if(at>=0&&at+1<args.Length) result=Path.GetFullPath(args[at+1]);
        using var host=new ServerHost(root,_=>{});
        try
        {
            using var settings=JsonDocument.Parse(File.ReadAllText(Path.Combine(root,"settings.private.json")));
            if(!settings.RootElement.GetProperty("database").GetString()!.StartsWith("openkfo_debug_",StringComparison.Ordinal)) throw new InvalidOperationException("Requires independent debug database");
            using(var existing=host.Find()) {if(existing is not null)throw new InvalidOperationException("Server must be stopped before lifecycle test");}
            await host.StartAsync();
            using var first=host.Find()??throw new InvalidOperationException("Worker did not start");
            _=first.SafeHandle; // Keep the exit status readable after the PID disappears.
            await host.StartAsync();
            using(var again=host.Find()) {if(again?.Id!=first.Id)throw new InvalidOperationException("Duplicate worker");}
            bool ready=false;using var http=new HttpClient{Timeout=TimeSpan.FromSeconds(2)};
            for(int i=0;i<40&&!first.HasExited;i++)
            {
                try {using var response=await http.GetAsync("http://127.0.0.1:19090/health");if(response.IsSuccessStatusCode){ready=true;break;}} catch(HttpRequestException){} catch(TaskCanceledException){}
                await Task.Delay(500);
            }
            if(!ready)throw new IOException("Local server did not become healthy");
            await host.StopAsync();first.WaitForExit(15000);
            if(!first.HasExited||first.ExitCode!=0)throw new IOException("Worker did not stop gracefully");
            File.WriteAllText(result,JsonSerializer.Serialize(new{passed=true,local_only=true,start=true,duplicate_prevented=true,health=true,graceful_stop=true}));
            return 0;
        }
        catch(Exception ex){File.WriteAllText(result,JsonSerializer.Serialize(new{passed=false,error=ex.ToString()}));return 1;}
        finally{if(host.OwnsRunning)await host.StopAsync();}
    }
    internal static int Run(string[] args)
    {
        string folder = Path.Combine(Path.GetTempPath(), "openkfo-monitor-test-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(folder);
        string result = Path.Combine(AppContext.BaseDirectory, "monitor-self-test.json");
        int at = Array.IndexOf(args, "--result"); if (at >= 0 && at + 1 < args.Length) result = Path.GetFullPath(args[at + 1]);
        var checks = new List<string>();
        try
        {
            void Check(bool value, string name) { if (!value) throw new InvalidOperationException(name); checks.Add(name); }
            const string packet = "{\"time\":\"2026-09-20T12:00:00+08:00\",\"direction\":\"S->C queued\",\"account\":\"localtest1\",\"player\":\"测试玩家\",\"protocol\":4125,\"hex\":\"0200\",\"length\":2,\"transport\":\"game\"}";
            var row = TraceRow.Parse(packet);
            Check(row.Flow.Contains("待发送") && row.Description.Contains("测试玩家"), "中文身份与队列方向");
            Check(row.Original.Contains("02 00") && row.Raw == packet, "原始JSON和HEX无损");
            foreach (uint opcode in new uint[] {4140, 4150})
            {
                string sample = JsonSerializer.Serialize(new { direction = opcode == 4140 ? "C->S" : "S->C", transport = "game", protocol = opcode, content = "检测状态详情", hex = "" });
                var probe = TraceRow.Parse(sample);
                Check(probe.Name.Contains("网络检测") && probe.Description.Contains("检测状态详情") && probe.Raw == sample, $"网络检测{opcode}中文名称与原文");
            }
            Check(row.Matches("localtest1", false) && !row.Matches("localtest2", false), "账号筛选");
            foreach (uint opcode in new uint[] {4110, 20572})
            {
                string sample = JsonSerializer.Serialize(new { direction = opcode == 4110 ? "C->S" : "S->C", transport = "game", protocol = opcode, content = "结束原因码=1，仍需服务器验证", hex = "0100" });
                var report = TraceRow.Parse(sample);
                Check(!report.Name.Contains("尚未") && report.Description.Contains("结束原因码=1") && report.Raw == sample, $"结算与波次{opcode}名称及服务器详情");
            }
            var pve = TraceRow.Parse(JsonSerializer.Serialize(new { direction = "C->S", transport = "game", protocol = 8071, subprotocol = 20407, hex = "" }));
            Check(pve.Description.Contains("20407 · PVE结束标记"), "PVE子协议中文名称");
            Check(!TraceRow.Parse("{\"direction\":\"C->S\",\"protocol\":1157}").Matches("", true), "心跳筛选");
            Check(TraceRow.Parse("{\"protocol\":{}}").Direction == "", "损坏字段保留为运行日志");
            using (var tail = new LogTail())
            {
                var read = new List<string>(); string file = Path.Combine(folder, "protocol-20260920-120000.log");
                byte[] encoded = Encoding.UTF8.GetBytes(packet + "\n");
                int cut = Encoding.UTF8.GetByteCount(packet[..packet.IndexOf("测试", StringComparison.Ordinal)]) + 1;
                File.WriteAllBytes(file, encoded[..cut]); tail.Poll(folder, read.Add);
                Check(!read.Contains(packet), "半行和半个UTF8字符暂存");
                using (var stream = new FileStream(file, FileMode.Append, FileAccess.Write, FileShare.ReadWrite)) stream.Write(encoded[cut..]);
                tail.Poll(folder, read.Add); Check(read.Count(s => s == packet) == 1, "追加完整行仅接收一次");
                tail.Poll(folder, read.Add); Check(read.Count(s => s == packet) == 1, "空轮询不重复");
                string next = Path.Combine(folder, "protocol-20260920-120100.log"); File.WriteAllText(next, "新的服务进程\n", new UTF8Encoding(false));
                tail.Poll(folder, read.Add); Check(read.Contains("新的服务进程"), "服务器重启自动切换日志");
            }
            using (var form = new MonitorForm(folder, false))
            {
                form.ShowInTaskbar=false;form.StartPosition=FormStartPosition.Manual;form.Location=new Point(-20000,-20000);
                form.Show();Application.DoEvents();
                Check(form.TestInject(packet) == 1, "原生WinForms虚拟列表");
                form.TestSelect(0); Check(form.TestRaw.Contains("02 00"), "选中记录同步原始数据Tab");
                Check(form.Controls.Count >= 4, "完整窗口布局构建");
                using var bitmap = new Bitmap(form.Width,form.Height);
                form.DrawToBitmap(bitmap,new Rectangle(Point.Empty,bitmap.Size));
                bitmap.Save(Path.ChangeExtension(result,".png"));
                form.Close();
            }
            File.WriteAllText(result, JsonSerializer.Serialize(new { passed = true, checks }, new JsonSerializerOptions { WriteIndented = true }));
            return 0;
        }
        catch (Exception ex)
        {
            File.WriteAllText(result, JsonSerializer.Serialize(new { passed = false, checks, error = ex.ToString() }, new JsonSerializerOptions { WriteIndented = true }));
            return 1;
        }
        finally { Directory.Delete(folder, true); }
    }
}
