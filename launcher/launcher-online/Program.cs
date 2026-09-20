using System.Text.Json;

namespace KungFuLauncher;

internal static class Program
{
    [STAThread]
    private static void Main(string[] args)
    {
        ApplicationConfiguration.Initialize();
        try
        {
            int controlTest = Array.IndexOf(args,"--server-control-test");
            if(controlTest>=0 && controlTest+1<args.Length){ServerControlTests.Run(args[controlTest+1]);return;}
            string root = AppContext.BaseDirectory;
            int rootOption = Array.IndexOf(args, "--root");
            if (rootOption >= 0 && rootOption + 1 < args.Length) root = Path.GetFullPath(args[rootOption + 1]);
            var instances = new InstanceManager(root);
            int healthOption = Array.IndexOf(args, "--check-server");
            if (healthOption >= 0 && healthOption + 1 < args.Length)
            {
                var elapsed = System.Diagnostics.Stopwatch.StartNew();
                try
                {
                    using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(8) };
                    var timing = instances.CheckHealthAsync(http).GetAwaiter().GetResult();
                    File.WriteAllText(args[healthOption + 1], JsonSerializer.Serialize(new { ok = true, environment = instances.EnvironmentName, endpoint = instances.Endpoint.ToString(), milliseconds = elapsed.ElapsedMilliseconds, round_trip_ms = timing.RoundTripMs, connection_ms = timing.ConnectionMs, health_total_ms = timing.TotalMs }));
                }
                catch (Exception error)
                {
                    File.WriteAllText(args[healthOption + 1], JsonSerializer.Serialize(new { ok = false, error = error.Message }));
                    Environment.ExitCode = 1;
                }
                return;
            }
            if (args.Contains("--self-test"))
            {
                SelfTests.Run(instances);
                return;
            }
            if (!args.Contains("--preview") && !instances.CheckLauncherUpdate()) return;
            int startOption = Array.IndexOf(args, "--start");
            int[] startWindows = startOption >= 0 && startOption + 1 < args.Length ? args[startOption + 1].Split(',').Select(int.Parse).ToArray() : [];
            using var form = new LauncherForm(instances, startWindows);
            int preview = Array.IndexOf(args, "--preview");
            if (preview >= 0 && preview + 1 < args.Length)
            {
                form.Show();
                var deadline = DateTime.UtcNow.AddSeconds(12);
                while (!form.StatusReady && DateTime.UtcNow < deadline) { Application.DoEvents(); Thread.Sleep(30); }
                using var bitmap = new Bitmap(form.Width, form.Height);
                form.DrawToBitmap(bitmap, new Rectangle(Point.Empty, bitmap.Size));
                bitmap.Save(args[preview + 1]);
                File.WriteAllText(args[preview + 1] + ".txt", form.StatusText);
                return;
            }
            Application.Run(form);
        }
        catch (Exception exception)
        {
            if (args.Contains("--self-test") || args.Contains("--server-control-test"))
            {
                File.WriteAllText(Path.Combine(AppContext.BaseDirectory, "self-test-error.txt"), exception.ToString());
                Environment.ExitCode = 1;
            }
            else MessageBox.Show(exception is UnauthorizedAccessException
                ? "登录器无法读写当前文件夹。请把整个游戏文件夹解压到可写目录后再启动，不要在压缩包中运行。"
                : exception.Message, "功夫小子登录器", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
}
