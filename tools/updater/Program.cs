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
            string? bridge = kind is "client" or "weapons" ? Path.GetFullPath(Get("--bridge")) : null;
            string? launcher = kind == "launcher" ? Path.GetFullPath(Get("--launcher")) : null;
            string? restartRoot = kind == "launcher" ? Path.GetFullPath(Get("--restart-root")) : null;
            using var mutex = new Mutex(false, "Local\\OpenKFOUpdate-" + UpdateEngine.Hash(System.Text.Encoding.UTF8.GetBytes(target.ToLowerInvariant())));
            if (!mutex.WaitOne(0)) { throw new IOException("另一个更新程序正在运行。"); }
            try { using var form = new UpdateForm(kind, target, uri, bridge, launcher, restartRoot); Application.Run(form); Environment.ExitCode = form.Completed ? 0 : 2; } finally { mutex.ReleaseMutex(); }
        }
        catch (Exception e) { Environment.ExitCode = 1; MessageBox.Show(e.Message, "更新失败", MessageBoxButtons.OK, MessageBoxIcon.Error); }
    }
}
