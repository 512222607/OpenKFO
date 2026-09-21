using System.Net.Security;
using System.Net.Sockets;
using System.Security.Authentication;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace KfoLogin;

/// <summary>
/// 一行一条 JSON 的 TLS 隧道客户端（TransportProtocol.md §1.2）。
/// 认证成功后由 <see cref="Bridge"/> 独占读取循环，本类只保证发送线程安全。
/// 证书校验采用「指纹钉扎」：对端证书 DER 必须与本机 origin.crt 逐字节一致。
/// </summary>
internal sealed class Tunnel : IDisposable
{
    private const string Sni = "kk-origin";
    private const int MaxLine = 4 * 1024 * 1024;

    private readonly string _host;
    private readonly int _port;
    private readonly string _certPath;

    private TcpClient? _client;
    private SslStream? _stream;
    private readonly SemaphoreSlim _sendLock = new(1, 1);

    private readonly byte[] _readBuf = new byte[65536];
    private int _readPos;
    private int _readLen;

    public long Uid { get; private set; }

    public Tunnel(string host, int port, string certPath)
    {
        _host = host;
        _port = port;
        _certPath = certPath;
    }

    public void Connect(double timeoutSec = 8)
    {
        byte[] expected;
        using (X509Certificate2 local = X509CertificateLoader.LoadCertificateFromFile(_certPath))
            expected = local.RawData;

        _client = new TcpClient { NoDelay = true };
        _client.Connect(_host, _port);
        _client.ReceiveTimeout = (int)(timeoutSec * 1000);

        var ssl = new SslStream(_client.GetStream(), leaveInnerStreamOpen: false,
            (_, cert, _, _) =>
            {
                if (cert is null) return false;
                byte[] got = cert.GetRawCertData();
                return got.Length == expected.Length &&
                       CryptographicOperations.FixedTimeEquals(got, expected);
            });

        ssl.AuthenticateAsClient(new SslClientAuthenticationOptions
        {
            TargetHost = Sni,
            EnabledSslProtocols = SslProtocols.Tls12 | SslProtocols.Tls13,
            CertificateRevocationCheckMode = X509RevocationMode.NoCheck,
        });
        ssl.ReadTimeout = 20000;
        _stream = ssl;
    }

    public void Send(JsonObject frame)
    {
        if (_stream is null) throw new InvalidOperationException("隧道未连接");
        string line = frame.ToJsonString() + "\n";
        byte[] bytes = Encoding.UTF8.GetBytes(line);
        _sendLock.Wait();
        try
        {
            _stream.Write(bytes, 0, bytes.Length);
            _stream.Flush();
        }
        finally
        {
            _sendLock.Release();
        }
    }

    /// <summary>读取一条以 \n 结尾的 JSON 帧（阻塞，单一读者）。</summary>
    public JsonObject Read(double timeoutSec = 75)
    {
        if (_stream is null) throw new InvalidOperationException("隧道未连接");
        _stream.ReadTimeout = (int)(timeoutSec * 1000);

        using var line = new MemoryStream();
        while (true)
        {
            if (_readPos >= _readLen)
            {
                _readLen = _stream.Read(_readBuf, 0, _readBuf.Length);
                _readPos = 0;
                if (_readLen <= 0) throw new IOException("隧道已关闭");
            }

            byte b = _readBuf[_readPos++];
            if (b == (byte)'\n') break;
            line.WriteByte(b);
            if (line.Length > MaxLine) throw new InvalidDataException("隧道帧过大");
        }

        string text = Encoding.UTF8.GetString(line.ToArray());
        return JsonNode.Parse(text) as JsonObject ?? new JsonObject();
    }

    public long Authenticate(string account, string password, string configHash, int gamePort)
    {
        Send(new JsonObject
        {
            ["op"] = "auth",
            ["account"] = account,
            ["password"] = Legacy.Digest(password),
            ["config_hash"] = configHash,
            ["port"] = gamePort,
        });

        JsonObject reply = Read(20);
        string? op = reply["op"]?.GetValue<string>();
        double uid = reply["uid"]?.GetValue<double>() ?? 0;
        if (op != "auth" || uid <= 0)
        {
            string err = reply["error"]?.GetValue<string>() ?? reply.ToJsonString();
            throw new UnauthorizedAccessException($"认证被拒绝：{err}");
        }

        Uid = (long)uid;
        Send(new JsonObject { ["op"] = "ready" });
        return Uid;
    }

    public void Dispose()
    {
        try { _stream?.Dispose(); } catch { /* ignore */ }
        try { _client?.Dispose(); } catch { /* ignore */ }
        _sendLock.Dispose();
    }
}
