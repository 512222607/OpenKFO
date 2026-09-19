using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;

namespace OpenKFO.Monitor;

internal sealed class ServerHost(string directory, Action<string> report) : IDisposable
{
    private readonly string executable = Path.GetFullPath(Path.Combine(directory, "kungfu-server.exe"));
    private Process? owned;
    internal bool OwnsRunning { get { try { return owned is not null && !owned.HasExited; } catch (InvalidOperationException) { return false; } } }
    internal Process? Find()
    {
        foreach (var p in Process.GetProcessesByName("kungfu-server"))
        {
            try { if (!p.HasExited && string.Equals(p.MainModule?.FileName, executable, StringComparison.OrdinalIgnoreCase)) return p; }
            catch (Exception e) when (e is InvalidOperationException or System.ComponentModel.Win32Exception) { }
            p.Dispose();
        }
        return null;
    }
    internal Task StartAsync() => Task.Run(() => Locked(() =>
    {
        using var running = Find();
        if (running is not null) { report("本地服务器已经运行，已接入现有日志。"); return; }
        foreach (string file in new[] { executable, Path.Combine(directory, "settings.private.json"), Path.Combine(directory, "config.json") })
            if (!File.Exists(file)) throw new FileNotFoundException("缺少本地服务器文件：" + Path.GetFileName(file));
        var info = new ProcessStartInfo(executable) { WorkingDirectory = directory, UseShellExecute = false, CreateNoWindow = true, RedirectStandardOutput = true, RedirectStandardError = true, RedirectStandardInput = true, StandardOutputEncoding = Encoding.UTF8, StandardErrorEncoding = Encoding.UTF8 };
        info.Environment["OPENKFO_LOCAL_MONITOR"] = "1";
        var process = new Process { StartInfo = info, EnableRaisingEvents = true };
        void Capture(object _, DataReceivedEventArgs e)
        {
            // Packet JSON is already in the server's protocol file. Capture
            // bootstrap/errors here, including failures before that file exists.
            if (e.Data is { Length: > 0 } line && !line.StartsWith('{')) report(line);
        }
        process.OutputDataReceived += Capture; process.ErrorDataReceived += Capture;
        process.Exited += (_, _) => report("本地服务器进程已退出。请查看停止前的运行记录。");
        if (!process.Start()) { process.Dispose(); throw new IOException("无法启动服务器。"); }
        owned?.Dispose(); owned = process;
        process.BeginOutputReadLine(); process.BeginErrorReadLine(); report("正在启动本地服务器并连接独立测试数据库…");
    }));
    internal Task StopAsync() => Task.Run(() => Locked(() =>
    {
        using var process = Find();
        if (process is null) { report("本地服务器已停止。"); return; }
        _ = process.SafeHandle;
        if (!string.Equals(process.MainModule?.FileName, executable, StringComparison.OrdinalIgnoreCase)) throw new IOException("服务器进程已变化，停止操作已取消。");
        if (owned is not null && !owned.HasExited && owned.Id == process.Id)
        {
            owned.StandardInput.WriteLine("stop"); owned.StandardInput.Flush();
            if (!process.WaitForExit(12000)) process.Kill();
        }
        else if (!process.CloseMainWindow() || !process.WaitForExit(1000)) process.Kill();
        if (!process.WaitForExit(5000)) throw new IOException("服务器尚未退出。");
        report("本地服务器已停止，游戏连接已断开。");
    }));
    private void Locked(Action action)
    {
        string name = "Local\\OpenKFO-Server-" + Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(executable.ToUpperInvariant())));
        using var gate = new Mutex(false, name); bool acquired = false;
        try { try { acquired = gate.WaitOne(TimeSpan.FromSeconds(5)); } catch (AbandonedMutexException) { acquired = true; } if (!acquired) throw new IOException("另一个本地窗口正在操作服务器。"); action(); }
        finally { if (acquired) gate.ReleaseMutex(); }
    }
    public void Dispose() { owned?.Dispose(); }
}
