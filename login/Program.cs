using System.Text;
using System.Windows.Forms;

namespace KfoLogin;

internal static class Program
{
    [STAThread]
    private static int Main(string[] args)
    {
        // GB18030(54936) / GBK 用于读写客户端 ini、xml 等本地化文本文件。
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

        if (args.Length > 0 && args[0] == "--selftest")
            return SelfTest.Run(args);

        Application.SetHighDpiMode(HighDpiMode.PerMonitorV2);
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new MainForm());
        return 0;
    }
}
