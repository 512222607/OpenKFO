using System.Diagnostics;
using System.Runtime.InteropServices;
using Microsoft.Win32.SafeHandles;

namespace KungFuLauncher;

// Separate, read-only observer: it survives closing the launcher and exits
// with its exact game process. No input interception or global window title changes.
internal sealed class FpsOverlay : Form
{
    readonly Process game;
    readonly SafeProcessHandle memory;
    readonly IntPtr counter;
    readonly System.Windows.Forms.Timer timer = new() { Interval = 100 };
    readonly Stopwatch sample = Stopwatch.StartNew();
    uint previous;
    bool initialized;
    string caption = "FPS：…";
    bool tickLogged;
    IntPtr ownerWindow;
    bool sampleLogged;
    internal static void Trace(string text)
    {
        try { File.AppendAllText(Path.Combine(AppContext.BaseDirectory, "fps-overlay.log"), $"{DateTime.Now:O} {Environment.ProcessId} {text}{Environment.NewLine}"); } catch (IOException) { }
    }

    internal FpsOverlay(Process game, uint address)
    {
        this.game = game; counter = new IntPtr((long)address);
        memory = OpenProcess(0x10, false, game.Id); // PROCESS_VM_READ only
        if (memory.IsInvalid) throw new System.ComponentModel.Win32Exception();
        FormBorderStyle = FormBorderStyle.None; ShowInTaskbar = false;
        StartPosition = FormStartPosition.Manual; Size = new Size(160, 32);
        BackColor = TransparencyKey = Color.Magenta; Opacity = 0;
        Font = new Font("Microsoft YaHei UI", 13, FontStyle.Bold);
        DoubleBuffered = true;
        timer.Tick += (_, _) => Tick(); timer.Start();
    }
    protected override bool ShowWithoutActivation => true;
    protected override CreateParams CreateParams {
        get { var p = base.CreateParams; p.ExStyle |= 0x08000000 | 0x00000020 | 0x00080000 | 0x00000080; return p; }
    }
    void Tick()
    {
        try
        {
            if (!tickLogged) { tickLogged = true; Trace("timer_started"); }
            if (game.HasExited) { Close(); return; }
            game.Refresh(); IntPtr window = game.MainWindowHandle;
            if (window == IntPtr.Zero) { Opacity = 0; return; }
            if (ownerWindow != window) {
                // Native ownership keeps FPS above this game, without covering
                // other applications or disappearing when its login dialog has focus.
                SetLastError(0);
                if (SetWindowLongPtrW(Handle, -8, window) == IntPtr.Zero && Marshal.GetLastWin32Error() != 0)
                    throw new System.ComponentModel.Win32Exception();
                ownerWindow = window;
                Trace($"attached game={game.Id} window={window}");
            }
            bool visible = IsWindowVisible(window) && !IsIconic(window);
            Opacity = visible ? 1 : 0;
            if (visible && GetClientRect(window, out var rect)) {
                var origin = new Point(0, 0); ClientToScreen(window, ref origin);
                Location = new Point(origin.X + (rect.Right - Width) / 2, origin.Y + 8);
            }
            var data = new byte[4];
            if (!ReadProcessMemory(memory, counter, data, 4, out nuint read) || read != 4) { caption = "FPS：不可用"; Invalidate(); return; }
            uint current = BitConverter.ToUInt32(data);
            if (!initialized) { initialized = true; previous = current; sample.Restart(); return; }
            if (sample.Elapsed.TotalMilliseconds >= 500) {
                uint frames = unchecked(current - previous);
                caption = $"FPS：{frames / sample.Elapsed.TotalSeconds:0}";
                previous = current; sample.Restart(); Invalidate();
                if (visible && frames > 0 && !sampleLogged) { sampleLogged = true; Trace($"display_visible game={game.Id} {caption}"); }
            }
        }
        catch (InvalidOperationException error) { Trace(error.Message); Close(); }
        catch (System.ComponentModel.Win32Exception error) { Trace(error.Message); Close(); }
    }
    protected override void OnPaint(PaintEventArgs e)
    {
        base.OnPaint(e);
        const TextFormatFlags flags = TextFormatFlags.HorizontalCenter | TextFormatFlags.VerticalCenter | TextFormatFlags.SingleLine | TextFormatFlags.NoPadding;
        foreach (var offset in new[] {new Point(-1,0),new Point(1,0),new Point(0,-1),new Point(0,1)}) {
            var rect = ClientRectangle; rect.Offset(offset);
            TextRenderer.DrawText(e.Graphics, caption, Font, rect, Color.Black, flags);
        }
        TextRenderer.DrawText(e.Graphics, caption, Font, ClientRectangle, Color.White, flags);
    }
    internal static void Run(string[] args)
    {
        Trace("observer_start");
        if (args.Length != 4) throw new ArgumentException("FPS 参数不完整");
        int pid = int.Parse(args[1]);
        using var game = Process.GetProcessById(pid);
        if (game.StartTime.ToFileTimeUtc() != long.Parse(args[2]) || !game.ProcessName.Equals("gfld.dat", StringComparison.OrdinalIgnoreCase)) return;
        using var mutex = new Mutex(false, $"Local\\OpenKFO-FPS-{pid}-{args[2]}");
        bool acquired;
        try { acquired = mutex.WaitOne(0); } catch (AbandonedMutexException) { acquired = true; }
        if (!acquired) return;
        try { using var overlay = new FpsOverlay(game, uint.Parse(args[3])); Trace("observer_ready"); Application.Run(overlay); Trace("observer_exit"); }
        finally { mutex.ReleaseMutex(); }
    }
    protected override void Dispose(bool disposing) { if (disposing) { timer.Dispose(); memory.Dispose(); } base.Dispose(disposing); }
    [StructLayout(LayoutKind.Sequential)] struct NativeRect { public int Left, Top, Right, Bottom; }
    [DllImport("kernel32.dll", SetLastError=true)] static extern SafeProcessHandle OpenProcess(uint access, bool inherit, int pid);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool ReadProcessMemory(SafeProcessHandle process, IntPtr address, byte[] buffer, nuint size, out nuint read);
    [DllImport("user32.dll")] static extern bool GetClientRect(IntPtr window, out NativeRect rect);
    [DllImport("user32.dll")] static extern bool ClientToScreen(IntPtr window, ref Point point);
    [DllImport("user32.dll", SetLastError=true)] static extern IntPtr SetWindowLongPtrW(IntPtr window, int index, IntPtr value);
    [DllImport("kernel32.dll")] static extern void SetLastError(uint error);
    [DllImport("user32.dll")] static extern bool IsWindowVisible(IntPtr window);
    [DllImport("user32.dll")] static extern bool IsIconic(IntPtr window);
}
