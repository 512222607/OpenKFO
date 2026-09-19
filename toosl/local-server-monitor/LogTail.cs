using System.Text;

namespace OpenKFO.Monitor;

// Read files only. No TCP listener, remote endpoint or HTTP log API.
internal sealed class LogTail : IDisposable
{
    private FileStream? stream;
    private string current = "";
    private readonly Decoder decoder = Encoding.UTF8.GetDecoder();
    private readonly StringBuilder pending = new();
    private bool skipFirst;
    internal string Current => current;
    internal void Poll(string directory, Action<string> receive)
    {
        if (!Directory.Exists(directory)) return;
        string? newest = Directory.EnumerateFiles(directory, "protocol-*.log").OrderBy(p => Path.GetFileName(p), StringComparer.Ordinal).LastOrDefault();
        if (newest is null) return;
        if (newest != current || stream is not null && stream.Length < stream.Position)
        {
            stream?.Dispose();
            stream = new FileStream(newest, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete);
            current = newest; decoder.Reset(); pending.Clear(); skipFirst = stream.Length > 512 * 1024;
            if (skipFirst) stream.Seek(-512 * 1024, SeekOrigin.End);
            receive("读取日志：" + newest + (skipFirst ? "（从末尾 512 KB 开始；完整记录保留在文件中）" : ""));
        }
        byte[] bytes = new byte[64 * 1024]; char[] chars = new char[Encoding.UTF8.GetMaxCharCount(bytes.Length)];
        // Bound each poll so cancellation and file rotation remain responsive.
        for (int chunk = 0; chunk < 16; chunk++)
        {
            int size = stream!.Read(bytes);
            if (size == 0) break;
            int count = decoder.GetChars(bytes, 0, size, chars, 0, false);
            for (int i = 0; i < count; i++)
            {
                if (chars[i] == '\n')
                {
                    if (!skipFirst) receive(pending.ToString().TrimEnd('\r'));
                    skipFirst = false; pending.Clear();
                }
                else if (!skipFirst) pending.Append(chars[i]);
            }
            if (pending.Length > 16 * 1024 * 1024) { pending.Clear(); skipFirst = true; receive("单条记录超过 16 MB，窗口跳过此条；原始文件未修改。"); }
        }
    }
    public void Dispose() => stream?.Dispose();
}
