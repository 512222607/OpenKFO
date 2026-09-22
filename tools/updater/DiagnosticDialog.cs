using System.Text;
using System.Text.RegularExpressions;

namespace OpenKFO.Updater;

internal static class DiagnosticDialog
{
    internal static string Redact(string text)
    {
        text = Regex.Replace(text, @"(?i)\b(?:https?|wss?|tls)://[^\s""<>]+", "[NET_ENDPOINT]");
        text = Regex.Replace(text, @"\b(?:\d{1,3}\.){3}\d{1,3}(?::\d+)?\b", "[NET_ENDPOINT]");
        text = Regex.Replace(text, @"(?i)\b(?:[a-z0-9-]+\.)+(?:com|net|org|top|cn|io|dev|xyz)(?::\d+)?\b", "[NET_ENDPOINT]");
        text = Regex.Replace(text, @"(?i)(password|passwd|token|secret|authorization|密码)(\s*[=:]\s*)(""[^""]*""|[^\s,;]+)", "$1$2[REDACTED]");
        return text;
    }

    internal static string Details(Exception error, string? logPath = null)
    {
        var text = new StringBuilder().AppendLine(DateTimeOffset.Now.ToString("O"))
            .AppendLine(error.ToString());
        if (logPath != null)
        {
            text.AppendLine().AppendLine("最近的网络组件日志（可能包含之前的启动记录）：");
            try
            {
                using var stream = new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete);
                const int tailBytes = 32 * 1024;
                stream.Seek(Math.Max(0, stream.Length - tailBytes), SeekOrigin.Begin);
                using var reader = new StreamReader(stream, Encoding.UTF8);
                text.AppendLine(reader.ReadToEnd());
            }
            catch (Exception e) when (e is IOException or UnauthorizedAccessException)
            { text.AppendLine("无法读取日志：" + e.Message); }
        }
        return Redact(text.ToString());
    }

    internal static void Show(IWin32Window? owner, string title, string details)
    {
        using var dialog = new Form { Text = title, Size = new Size(760, 480), MinimumSize = new Size(460, 300),
            StartPosition = owner == null ? FormStartPosition.CenterScreen : FormStartPosition.CenterParent,
            Font = new Font("Microsoft YaHei UI", 10), MinimizeBox = false, Padding = new Padding(12) };
        var content = new TextBox { Multiline = true, ReadOnly = true, ScrollBars = ScrollBars.Both,
            WordWrap = false, Dock = DockStyle.Fill, Text = Redact(details) };
        var buttons = new FlowLayoutPanel { Dock = DockStyle.Bottom, Height = 44, FlowDirection = FlowDirection.RightToLeft };
        var close = new Button { Text = "关闭", AutoSize = true, DialogResult = DialogResult.OK };
        var copy = new Button { Text = "复制详情", AutoSize = true };
        copy.Click += (_, _) => {
            try { Clipboard.SetText(content.Text); copy.Text = "已复制"; }
            catch (System.Runtime.InteropServices.ExternalException) { copy.Text = "复制失败，请重试"; }
        };
        buttons.Controls.Add(close); buttons.Controls.Add(copy);
        dialog.Controls.Add(content); dialog.Controls.Add(buttons); dialog.CancelButton = close;
        dialog.ShowDialog(owner);
    }
}
