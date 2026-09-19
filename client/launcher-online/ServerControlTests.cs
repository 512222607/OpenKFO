using System.Diagnostics;
using System.Text.Json;

namespace KungFuLauncher;

internal static class ServerControlTests
{
    internal static void Run(string fixture)
    {
        if(File.ReadAllText(Path.Combine(fixture,"controller-fixture.txt")).Trim()!="OpenKFO server control fixture")throw new IOException("Not an isolated fixture");
        var controller=new LocalServerController(fixture,new Uri("tls://127.0.0.1:19091"));
        var remote=new LocalServerController(fixture,new Uri("wss://example.invalid/kk/tunnel"));
        var foreign=new LocalServerController(Path.Combine(fixture,"other"),new Uri("tls://127.0.0.1:19091"));
        void Check(bool value,string why){if(!value)throw new Exception(why);}
        try {
            Check(!remote.Supported && !remote.IsRunning,"remote process control must be disabled");
            Check(!controller.IsRunning,"fixture must begin stopped");
            controller.StartAsync(ProcessWindowStyle.Hidden).GetAwaiter().GetResult();
            Check(controller.IsRunning,"start did not identify the fixture process");
            using var first=Process.GetProcessesByName("kungfu-server").Single(controller.IsManaged);
            int pid=first.Id;
            controller.StartAsync(ProcessWindowStyle.Hidden).GetAwaiter().GetResult();
            using var same=Process.GetProcessesByName("kungfu-server").Single(controller.IsManaged);
            Check(same.Id==pid,"duplicate start created another process");
            Check(!foreign.IsManaged(first)&&!foreign.IsRunning,"another directory matched by process name");
            foreign.StopAsync().GetAwaiter().GetResult();
            Check(controller.IsRunning,"foreign stop killed this server");
            controller.StopAsync().GetAwaiter().GetResult();
            Check(!controller.IsRunning,"stop did not exit");
            controller.StopAsync().GetAwaiter().GetResult();
            File.WriteAllText(Path.Combine(AppContext.BaseDirectory,"server-control-test.json"),JsonSerializer.Serialize(new{passed=true,fixture_only=true,start=true,stop=true,duplicate_start_prevented=true,foreign_directory_protected=true,remote_control_disabled=true}));
        }finally{if(controller.IsRunning)controller.StopAsync().GetAwaiter().GetResult();}
    }
}
