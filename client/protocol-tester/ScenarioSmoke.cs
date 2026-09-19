using System.Text.Json;

namespace KungfuProtocolTester;

internal sealed partial class TesterForm
{
    // Opt-in real local-server acceptance test. Mutates only two test accounts
    // and their temporary room. No server bypass and no game client launch.
    internal async Task ScenarioSmokeAsync()
    {
        File.WriteAllText(Path.Combine(root,"scenario-test.json"),JsonSerializer.Serialize(new{passed=false,state="running",time=DateTimeOffset.Now}));
        using var peer=new TesterForm();peer.Show();peer.Hide();
        account.Text="localtest10";peer.account.Text="localtest9";
        password.Text=peer.password.Text=Environment.GetEnvironmentVariable("OPENKFO_TEST_PASSWORD")??throw new Exception("missing test password");
        peer.config.Text=config.Text;
        var runs=new List<string>();var first=ConnectLoop();var second=peer.ConnectLoop();
        async Task Until(Func<bool> predicate,string label,int seconds=30){var until=DateTime.UtcNow.AddSeconds(seconds);while(!predicate()){if(DateTime.UtcNow>until)throw new Exception(label+": "+status.Text+"; peer "+peer.status.Text);await Task.Delay(80);}}
        void Run(TesterForm f,string prefix,params (string,string)[] edits){
            var c=f.Cases().Single(x=>x.Name.StartsWith(prefix,StringComparison.Ordinal));
            var values=c.Fields.Split(';',StringSplitOptions.RemoveEmptyEntries).Select(x=>x.Split('=',2)).ToDictionary(x=>x[0],x=>x.Length>1?x[1]:"");
            foreach(var(k,v) in edits)values[k]=v;
            f.pending=0;f.Send(c.Id,c.Build!(values),c.Reply,c.Timeout);runs.Add(c.Name);
        }
        async Task Query(TesterForm f,string prefix,uint reply,params (string,string)[] edits){int before=f.received.GetValueOrDefault(reply);Run(f,prefix,edits);await Until(()=>f.received.GetValueOrDefault(reply)>before,prefix);}
        try {
            await Until(()=>ready&&peer.ready,"two accounts ready");
            foreach(var c in new[]{("资料 / 查看玩家",2421u),("资料 / 刷新本人",2431u),("资料 / 排行榜",2550u),("资料 / 本人排行",2570u),("资料 / 战报",20370u),("商城 / 分类",9080u),("商城 / 查询",1510u),("商城 / 赠送",9060u),("装备 / 失败",2100u)})await Query(this,c.Item1,c.Item2);
            await Query(this,"房间 / 建房",3100);
            var room=roomId;
            await Query(peer,"房间 / 加入",3100,("房号",room.ToString()));
            await Query(peer,"房间 / 换队",3250,("队伍","1"));
            await Query(this,"房间 / 修改",3220);
            await Query(peer,"战斗 / 准备",4050);
            await Query(peer,"战斗 / 取消",4070);
            await Query(peer,"战斗 / 准备",4050);
            await Query(this,"战斗 / 准备",4080);await Until(()=>peer.phase=="加载","peer loading");
            await Query(this,"战斗 / 资源",4170);await Query(peer,"战斗 / 资源",4180);await Until(()=>phase=="等待输入","all loaded");
            Run(this,"战斗 / 输入");await Query(peer,"战斗 / 输入",8070);await Until(()=>phase=="战斗","both in battle");
            int relays=peer.received.GetValueOrDefault(8071u);
            Run(this,"战斗 / BUFF",("目标UID",Convert.ToString(peer.ownUid)),("效果类型","1"));
            await Until(()=>peer.received.GetValueOrDefault(8071u)>relays,"buff relay");
            var health=$"{ownUid}:100,{peer.ownUid}:0";
            Run(this,"结算 / 上报",("成员HP",health));await Query(peer,"结算 / 上报",4120,("成员HP",health));await Until(()=>phase=="结算","both settled");
            await Query(this,"结算 / 回房",3550);await Query(peer,"结算 / 回房",3550);
            await Query(this,"房间 / 踢出",3150,("玩家UID",Convert.ToString(peer.ownUid)));await Until(()=>peer.phase=="大厅","peer kicked");
            await Query(peer,"房间 / 加入",3100,("房号",room.ToString()));
            // A second match interrupted during loading must preserve the room.
            await Query(peer,"战斗 / 准备",4050);await Query(this,"战斗 / 准备",4080);
            await Query(this,"房间 / 离房",3115);await Until(()=>peer.phase=="房间"&&peer.roomId==room,"room survives owner exit");
            await Query(peer,"房间 / 离房",3115);
            // Keep P2P renewed past its one-minute lease; the server alone owns
            // the 90-second load timeout. No shortened server timers in this test.
            await Query(this,"房间 / 建房",3100);
            await Query(peer,"房间 / 加入",3100,("房号",roomId.ToString()));
            await Query(peer,"战斗 / 准备",4050);await Query(this,"战斗 / 准备",4080);
            Run(this,"战斗 / 等待加载");
            await Until(()=>phase=="房间"&&peer.phase=="房间","90 second loading timeout",105);
            await Query(this,"房间 / 离房",3115);await Query(peer,"房间 / 离房",3115);
            Run(this,"登录 / 重新");await Until(()=>!ready,"relogin disconnected");await Until(()=>ready,"relogin ready",40);
            await Query(this,"资料 / 查看",2421);
            using(var bitmap=new Bitmap(Width,Height)){DrawToBitmap(bitmap,new Rectangle(Point.Empty,Size));bitmap.Save(Path.Combine(root,"preview.png"));}
            File.WriteAllText(Path.Combine(root,"scenario-test.json"),JsonSerializer.Serialize(new{passed=true,time=DateTimeOffset.Now,real_local_server=true,loading_timeout_seconds=90,accounts=new[]{ownUid,peer.ownUid},cases=runs,game_ui_verified=false},new JsonSerializerOptions{WriteIndented=true}));
        } finally {Stop();peer.Stop();await Task.WhenAll(first,second);Save();}
    }
}
