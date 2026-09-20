using System.Security.Cryptography;
using System.Text;

namespace KfoLogin;

/// <summary>
/// 与客户端 / 服务端约定的「64 位 legacy」摘要与会话串生成，逐一对照
/// <c>kfo_launcher.py</c> 的 legacy_digest / build_session 行为。
/// </summary>
internal static class Legacy
{
    /// <summary>服务端 NewAccount / Authenticate 认这个盐。</summary>
    public const string Salt = "xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLv";

    public const string SessionPrefix = "KKSESSION";
    public const int SessionLength = 40; // KKSESSION(9) + 31 位大写十六进制

    /// <summary>hex(SHA256(salt + 明文密码))，小写。服务端只做比对，账号不存在时按此值自动注册。</summary>
    public static string Digest(string password)
    {
        byte[] hash = SHA256.HashData(Encoding.UTF8.GetBytes(Salt + password));
        return Convert.ToHexString(hash).ToLowerInvariant();
    }

    /// <summary>本轮 sessionId：KKSESSION + 31 位大写十六进制（与出厂串等长同形，定长 40）。</summary>
    public static string BuildSession(string account, long uid)
    {
        string seed = string.Format(
            System.Globalization.CultureInfo.InvariantCulture,
            "{0}|{1}|{2:F6}",
            account.ToLowerInvariant(),
            uid,
            DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() / 1000.0);
        string hex = Convert.ToHexString(MD5.HashData(Encoding.UTF8.GetBytes(seed)));
        return (SessionPrefix + hex)[..SessionLength];
    }
}
