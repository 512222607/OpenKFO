using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;

namespace KungFuLauncher;

// Only the local console server beside this launcher is managed. Never use a
// PID file or a process-name match as authorization to stop another server.
internal sealed class LocalServerController
{
    private readonly string executable;
    private readonly string directory;
    private readonly string mutexName;
    internal bool Supported { get; }
    internal LocalServerController(string root, Uri endpoint)
    {
        directory=Path.GetFullPath(root);
        executable=Path.Combine(directory,"kungfu-server.exe");
        Supported=endpoint.Scheme=="tls" && endpoint.IsLoopback && endpoint.Port==19091;
        mutexName="Local\\OpenKFO-Server-"+Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(executable.ToUpperInvariant())));
    }
    private Process? Find()
    {
        foreach(var process in Process.GetProcessesByName("kungfu-server"))
        {
            try { if(IsManaged(process)) return process; }
            catch (InvalidOperationException) { }
            process.Dispose();
        }
        return null;
    }
    internal bool IsManaged(Process process)
    {
        if(!Supported)return false;
        try { return !process.HasExited && string.Equals(process.MainModule?.FileName,executable,StringComparison.OrdinalIgnoreCase); }
        catch(System.ComponentModel.Win32Exception) { return false; }
        catch(InvalidOperationException) { return false; }
    }
    internal bool IsRunning { get { using var p=Find();return p!=null; } }
    internal Task<string> StartAsync(ProcessWindowStyle style=ProcessWindowStyle.Normal)=>Task.Run(()=>
    {
        if(!Supported)throw new InvalidOperationException("当前连接不是此本地服务器，不能控制其进程。");
        using var gate=new Mutex(false,mutexName);
        bool acquired=false;
        try {
            try { acquired=gate.WaitOne(TimeSpan.FromSeconds(5)); } catch(AbandonedMutexException){acquired=true;}
            if(!acquired)throw new IOException("另一个登录器正在操作本地服务器，请稍后重试。");
            using var existing=Find();
            if(existing!=null)return "本地服务器已运行，无需重复启动。";
            foreach(string file in new[]{"kungfu-server.exe","settings.private.json","config.json"})
                if(!File.Exists(Path.Combine(directory,file)))throw new FileNotFoundException("缺少本地服务器文件："+file);
            using var started=Process.Start(new ProcessStartInfo(executable){WorkingDirectory=directory,UseShellExecute=true,WindowStyle=style})??throw new IOException("无法启动本地服务器。");
            return "本地服务器已启动，正在检查连接…";
        }finally{if(acquired)gate.ReleaseMutex();}
    });
    internal Task<string> StopAsync()=>Task.Run(()=>
    {
        if(!Supported)throw new InvalidOperationException("当前连接不是此本地服务器，不能控制其进程。");
        using var gate=new Mutex(false,mutexName);
        bool acquired=false;
        try {
            try { acquired=gate.WaitOne(TimeSpan.FromSeconds(5)); }catch(AbandonedMutexException){acquired=true;}
            if(!acquired)throw new IOException("另一个登录器正在操作本地服务器，请稍后重试。");
            using var process=Find();
            if(process==null)return "本地服务器已停止。";
            // Pin the process handle and recheck its executable before stopping.
            _=process.SafeHandle;
            if(!IsManaged(process))throw new IOException("服务器进程已变化，请刷新状态后重试。");
            if(!process.CloseMainWindow() || !process.WaitForExit(3000))process.Kill();
            if(!process.WaitForExit(8000))throw new IOException("服务器尚未退出，请检查后台窗口。");
            return "本地服务器已停止；本地游戏连接已断开。";
        }finally{if(acquired)gate.ReleaseMutex();}
    });
}
