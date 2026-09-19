using System.Buffers.Binary;
using System.Diagnostics;
using System.Text;

namespace KungfuProtocolTester;

internal sealed record TestCase(string Name, string Help, uint Id, uint Reply,
    string Fields, string State, Func<Dictionary<string,string>,byte[]>? Build, int Timeout=8)
{ public override string ToString()=>Name; }

internal sealed partial class TesterForm
{
    readonly ComboBox scenarios = new(){DropDownStyle=ComboBoxStyle.DropDownList,Width=380,DisplayMember="Name",MaxDropDownItems=14,IntegralHeight=false,DropDownHeight=360};
    readonly FlowLayoutPanel fields = new(){Dock=DockStyle.Fill,AutoScroll=true};
    readonly Label scenarioHelp = new(){Dock=DockStyle.Fill,AutoEllipsis=true};
    readonly Dictionary<string,TextBox> editors = new();
    readonly Label stateLabel = new(){AutoSize=true,Text="大厅 / 尚未连接"};
    ulong ownUid;
    ushort roomId;
    uint battleSerial;
    string phase="大厅";
    int waitSeconds=8;
    readonly Dictionary<uint,int> received=new();
    readonly Dictionary<uint,byte[]> lastPackets=new();

    Control BuildScenarios()
    {
        Height=980;MinimumSize=new Size(1100,900);
        var panel=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=3};
        panel.RowStyles.Add(new RowStyle(SizeType.Absolute,37));panel.RowStyles.Add(new RowStyle(SizeType.Absolute,58));panel.RowStyles.Add(new RowStyle(SizeType.Percent,100));
        var top=new FlowLayoutPanel{Dock=DockStyle.Fill};
        var preview=new Button{Text="生成 HEX",AutoSize=true};
        var send=new Button{Text="执行此项",AutoSize=true};tests.Add(send);send.Enabled=false;
        var peer=new Button{Text="新增测试账号窗口",AutoSize=true};
        peer.Click+=(_,_)=>{var form=new TesterForm();form.account.Text="";form.password.Text="";form.Show();};
        var cancel=new Button{Text="取消等待",AutoSize=true};cancel.Click+=(_,_)=>{pending=0;Add("状态",0,0,"仅取消回包等待，不撤销已发送操作","");};
        top.Controls.AddRange([scenarios,preview,send,peer,cancel,stateLabel]);
        panel.Controls.Add(top,0,0);panel.Controls.Add(scenarioHelp,0,1);panel.Controls.Add(fields,0,2);
        scenarios.Items.AddRange(Cases().Cast<object>().ToArray());
        scenarios.SelectedIndexChanged+=(_,_)=>{
            var c=(TestCase)scenarios.SelectedItem!;scenarioHelp.Text=c.Help;fields.Controls.Clear();editors.Clear();
            foreach(var part in c.Fields.Split(';',StringSplitOptions.RemoveEmptyEntries)){
                var kv=part.Split('=',2);var box=new TextBox{Text=kv.Length==2?kv[1]:"",Width=kv[0]=="HEX"?550:135};
                editors[kv[0]]=box;var group=new FlowLayoutPanel{AutoSize=true,WrapContents=false};
                group.Controls.Add(new Label{Text=kv[0],AutoSize=true,Margin=new Padding(3,7,3,0)});group.Controls.Add(box);fields.Controls.Add(group);
            }
        };
        void Execute(bool transmit){try{
            var c=(TestCase)scenarios.SelectedItem!;
            if(c.Build==null)throw new Exception("该项尚无足够字段证据，说明中已列出缺口；不生成虚假请求。");
            if(transmit&&c.State!=""&&!c.State.Split('|').Contains(phase))throw new Exception($"需要状态：{c.State}；当前：{phase}");
            var args=editors.ToDictionary(x=>x.Key,x=>x.Value.Text.Trim());
            var p=c.Build(args);protocol.Text=c.Id.ToString();expected.Text=c.Reply.ToString();payload.Text=Convert.ToHexString(p);
            if(transmit){Send(c.Id,p,c.Reply,c.Timeout);Add("用例",c.Id,p.Length,c.Name+"；"+c.Help,Convert.ToHexString(p));}
        }catch(Exception e){Add("错误",0,0,e.Message,"");}}
        preview.Click+=(_,_)=>Execute(false);send.Click+=(_,_)=>Execute(true);
        scenarios.SelectedIndex=0;return panel;
    }

    static ulong N(Dictionary<string,string> p,string key,ulong max=uint.MaxValue){
        if(!p.TryGetValue(key,out var s)||!ulong.TryParse(s,out var n)||n>max)throw new Exception(key+" 必须为 0–"+max+" 的整数");return n;
    }
    static byte[] Packet(int length,params (int offset,byte[] value)[] parts){var p=new byte[length];foreach(var (o,v) in parts)v.CopyTo(p,o);return p;}
    static byte[] U16(ulong n)=>BitConverter.GetBytes(checked((ushort)n));
    static byte[] U32(ulong n)=>BitConverter.GetBytes(checked((uint)n));
    static byte[] U64(ulong n)=>BitConverter.GetBytes(n);
    static byte[] FixedText(string s,int size){Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);var b=Encoding.GetEncoding(936,EncoderFallback.ExceptionFallback,DecoderFallback.ExceptionFallback).GetBytes(s);if(b.Length>=size||s.Contains('\0'))throw new Exception($"文本最多 {size-1} 个 GBK 字节");return b;}
    static byte[] Raw(Dictionary<string,string> a)=>Convert.FromHexString(string.Concat(a["HEX"].Where(c=>!char.IsWhiteSpace(c))));
    byte[] Self(int length)=>Packet(length,(0,U64(ownUid)));
    List<TestCase> Cases()
    {
        var cs=new List<TestCase>();
        void Add(string name,string help,uint id,uint reply,string pars,string state,Func<Dictionary<string,string>,byte[]>? build,int timeout=8)=>cs.Add(new(name,help,id,reply,pars,state,build,timeout));
        const string lobby="大厅|房间";
        Add("资料 / 查看玩家", "2420→2421：真实资料与装备；目标 UID 可离线。不存在目标会收到通知。",2420,2421,"玩家UID=10001",lobby,a=>U64(N(a,"玩家UID",ulong.MaxValue)));
        Add("资料 / 刷新本人库存及兵器库","2430 本人查询触发 2160/2161 差量更新，2431 返回武器收藏。完整库存可在登录的1151日志查看。",2430,2431,"",lobby,a=>Self(8));
        Add("资料 / 排行榜","2540→2550；排行类型按服务器支持值填写。",2540,2550,"排行类型=0",lobby,a=>[(byte)N(a,"排行类型",255)]);
        Add("资料 / 本人排行","2560 查本人，不是查他人资料。",2560,2570,"排行类型=0",lobby,a=>Packet(9,(0,[(byte)N(a,"排行类型",255)]),(1,U64(ownUid))));
        Add("资料 / 战报赛季（占位）","20370 当前只有未配置提示；收到包不表示已有赛季战绩。",20360,20370,"",lobby,a=>Self(12));
        Add("资料 / 训练状态","21000→21001；查看资料后客户端自动查询同一目标，允许查看他人，只读且不启动训练。",21000,21001,"玩家UID=10001",lobby,a=>U64(N(a,"玩家UID",ulong.MaxValue)));
        Add("登录 / 重新登录","发送游戏实际请求2060；释放旧账号后由自动重连重新进入大厅。勾选自动重连。",2060,0,"", "",a=>[]);
        Add("登录 / 异常断线恢复","用“断开”再“连接”可重进；关闭另一个测试账号窗口可测试掉线、房主转移。不会顶掉仍在线账号。",0,0,"","",null);
        Add("登录 / 创建角色（待实现）","1125/1150/1130/1151：缺创建角色完整字段和新账号入口。当前自动登录只支持已有角色，不能发零包冒充创建。",1150,1151,"","",null);
        Add("商城 / 全部商品","1540→1550，108字节一条；日志展开显示商品键、类型、ID和价格。",1540,1550,"",lobby,a=>[]);
        Add("商城 / 分类商品","9070→9080，分类和变体由实际商品记录确定；可查宠物/法宝分类，但不代表购买装备效果已完成。",9070,9080,"分类=0;变体=0",lobby,a=>[(byte)N(a,"分类",255),(byte)N(a,"变体",255)]);
        Add("商城 / 查询指定商品","1500→1510；用商品记录中的类型和模板ID，不是库存实例号。",1500,1510,"类型=25;商品ID=0",lobby,a=>Packet(9,(0,[(byte)N(a,"类型",255)]),(1,U32(N(a,"商品ID")))));
        Add("商城 / 购买（扣款）","会实际扣测试账号货币并发货。先查询商品，把商品键和实际价格填入；成功9050、失败9060。重复点击是再次购买。",9040,9050,"商品键=0;金币价格=0;点券价格=0",lobby,a=>Purchase(a));
        Add("商城 / 赠送（拒绝验证）","9041 当前固定9060失败；此入口仅验证拒绝，不表示已实现赠送。",9041,9060,"",lobby,a=>new byte[169]);
        Add("商城 / 推荐优惠（暂缓）","按你的要求暂缓，暂不猜测专用请求。可以通过全部商品查看现有数据。",0,0,"","",null);
        Add("商城 / 宠物法宝完整流程（待确认）","分类商品入口可读取；独立库存类型、购买发放与装备效果字段仍需实包确认。",0,0,"","",null);
        Add("装备 / 装备及默认槽","2080→2090；实例号来自本人库存；槽0由服务器按物品类型解析。失败2100。准备后服务器可能忽略。",2080,2090,"实例号=0;槽位=0",lobby,a=>Packet(16,(0,U32(N(a,"实例号"))),(4,U32(N(a,"槽位",65535)))));
        Add("装备 / 失败应答验证","使用不存在的实例号，应返回2100，连接应保持。",2080,2100,"实例号=4294967295;槽位=0",lobby,a=>Packet(16,(0,U32(N(a,"实例号"))),(4,U32(N(a,"槽位",65535)))));
        Add("装备 / 卸下","2300→2310；会改变测试账号装备。",2300,2310,"实例号=0",lobby,a=>U32(N(a,"实例号")));
        Add("装备 / 武器升级配置（未实现）","21410/0→21411，服务端当前未接。预期超时；不能以全零21字节配置当成功。",21410,21411,"",lobby,a=>[]);
        Add("装备 / 到期删除（待实现）","2121/2162 是通知链，缺到期调度及客户端请求证据。日志会记录这些下行；不向服务器倒发下行包。",0,0,"","",null);
        Add("房间 / 列表翻页","2260→2280；模式136表示全部，每页最多9间。",2260,2280,"页码=1;刷新选项=1;模式=136",lobby,a=>[(byte)N(a,"页码",255),(byte)N(a,"刷新选项",255),(byte)N(a,"模式",255)]);
        Add("房间 / 建房","3010→3100；地图0让服务器从可用池选择。模式0个人、1团队、2/3其他模式、5训练；容量2/4/6/8。",3010,3100,"名称=协议测试;密码=;模式=0;容量=2;地图=0;时长秒=180","大厅",a=>RoomRequest(a));
        Add("房间 / 加入","3070→3100；失败3080会显示错误码。用另一测试窗口建房后填写房号。",3070,3100,"房号=1;密码=","大厅",a=>Packet(14,(0,U16(N(a,"房号",65535))),(3,FixedText(a["密码"],11))));
        Add("房间 / 快速加入","3075→3100；无合适房间会收到通知。模式0为不限制。",3075,3100,"模式=0","大厅",a=>[(byte)N(a,"模式",5)]);
        Add("房间 / 换队","3230→3250；0/1两队，会清除准备状态。",3230,3250,"队伍=1","房间",a=>[(byte)N(a,"队伍",1)]);
        Add("房间 / 修改设置","3200→3220；仅房主，名称/密码/地图/时长及开关一次提交，权限不足可能不回包。",3200,3220,"名称=协议测试;密码=;地图=0;时长秒=180;开关1=0;开关2=0;开关3=0;开关4=0","房间",a=>RoomSettings(a));
        Add("房间 / 踢出玩家","3140→3150；仅等待房房主可踢其他成员；非房主或踢自己不应成功。",3140,3150,"玩家UID=10009","房间",a=>Packet(9,(0,U64(N(a,"玩家UID",ulong.MaxValue)))));
        Add("房间 / 离房或战斗离场","3110→3115；房主离开会转移，战斗离场会中止且保留其他玩家房间。结算阶段该包返回房间。",3110,0,"","房间|加载|等待输入|战斗|结算",a=>[]);
        Add("房间 / 指定房主、观战、锁位（待确认）","没有确认对应请求与完整实现；自动房主转移可通过房主离房测试3160。",0,0,"","",null);
        Add("战斗 / 准备或房主开始","4030→4050；先让其他账号准备，再由房主开始。4080自动记录房号/战斗序号。",4030,4050,"","房间",a=>[]);
        Add("战斗 / 取消准备","4060→4070。",4060,4070,"","房间",a=>[]);
        Add("战斗 / 资源加载完成","4160→4170；每个窗口各点一次，全员完成收到4180。故意不点可测试90秒加载回收。",4160,4170,"","加载",a=>[]);
        Add("战斗 / 输入就绪","8040→8070；每个窗口各点一次，全部就绪才开战。等待回包允许其他窗口完成。",8040,8070,"","等待输入",a=>Packet(14,(0,U16(roomId)),(2,U64(ownUid))),100);
        Add("战斗 / 等待加载超时（观察）","开始后故意不点资源加载/输入就绪；发送合法空心跳，最多等100秒观察3115→3100恢复房间，不替服务器生成超时事件。",0,3100,"","加载|等待输入",a=>[],100);
        Add("战斗 / BUFF添加或删除8150","只验证服务器转发；在另一窗口看8071/8150。毫秒默认3000；不会证明真实客户端3秒自动解冻。序号每次递增。",8071,0,"目标UID=10009;效果类型=0;效果等级=1;持续毫秒=3000;添加1删除0=1;序号=1","战斗",a=>Buff(a));
        Add("战斗 / 技能效果8126","来源为本人，目标属于本房；技能键须从实包/配置取得。另一窗口观察转发；未确认字段用实包值。",8071,0,"目标UID=10009;技能键=0;参数=0;序号=1","战斗",a=>{var p=Envelope(71,8126,a);U64(ownUid).CopyTo(p,39);U64(ownUid).CopyTo(p,47);U64(N(a,"目标UID",ulong.MaxValue)).CopyTo(p,55);U32(N(a,"技能键")).CopyTo(p,63);U32(N(a,"参数")).CopyTo(p,67);return p;});
        Add("战斗 / 事件原包重放","填8071内容HEX（含子命令）；只替换已确认的发送UID/房号/序号上下文字段，目标UID保留，需属于本房。用于动作伤害换装、未知8127/8155及重复序号验证。",8071,0,"HEX=","战斗",a=>RebindEvent(Raw(a)));
        Add("战斗 / 消耗品使用意图","4200/4仅登记意图，无立即回包；还需真实8071/8289配套事件，数量通知4210。",4200,0,"实例号=0","战斗",a=>U32(N(a,"实例号")));
        Add("结算 / 上报胜负平及奖励","所有窗口填相同 UID:剩余HP 清单，例如10009:0,10010:100。只剩一方活为胜，其余败；均活/均死为平。会实际结算金币经验及配置掉落。",4110,4120,"成员HP=10009:0,10010:100","战斗|结算",a=>Report(a),100);
        Add("结算 / 回房与关闭查看结果","3550状态0，UID自动填本人；结果页其他人应同步取消查看结果标志。",3550,3550,"","结算|房间",a=>Self(12));
        Add("结算 / 查看结果标志","3550状态3，观察同房其他窗口通知。",3550,3550,"","结算",a=>Packet(12,(0,U64(ownUid)),(8,U32(3))));
        Add("奖励 / 武器掉落与称号","掉落规则在GM配置，再使用结算上报测试，观察2160和4120并重登核对库存。称号仍未实现，不伪造通知。",0,0,"","",null);
        return cs;
    }

    byte[] Purchase(Dictionary<string,string>a){var g=N(a,"金币价格");var t=N(a,"点券价格");if((g==0)==(t==0))throw new Exception("金币与点券价格必须且只能有一个大于0");return Packet(169,(0,U32(g>0?111ul:109ul)),(4,U64(ownUid)),(54,U64(ownUid)),(145,U32(N(a,"商品键"))),(149,U32(g)),(157,U32(t)));}
    static void Duration(Dictionary<string,string>a){if(N(a,"时长秒") is not (120 or 180 or 240 or 300))throw new Exception("时长支持120/180/240/300秒");}
    static byte[] RoomRequest(Dictionary<string,string>a){Duration(a);var m=N(a,"模式",5);var cap=N(a,"容量",8);if(m==4||cap is not (2 or 4 or 6 or 8)||a["名称"].Length==0)throw new Exception("模式、容量或名称无效");return Packet(81,(0,FixedText(a["名称"],21)),(21,FixedText(a["密码"],11)),(37,[(byte)cap]),(38,U32(N(a,"地图"))),(46,[(byte)m]),(47,U16(N(a,"时长秒"))));}
    static byte[] RoomSettings(Dictionary<string,string>a){Duration(a);if(a["名称"].Length==0)throw new Exception("名称不能为空");return Packet(48,(0,U32(N(a,"地图"))),(9,[(byte)N(a,"开关1",1),(byte)N(a,"开关2",1)]),(12,[(byte)N(a,"开关3",1),(byte)N(a,"开关4",1)]),(14,FixedText(a["名称"],21)),(35,FixedText(a["密码"],11)),(46,U16(N(a,"时长秒"))));}
    byte[] Envelope(int size,uint sub,Dictionary<string,string>a)=>Packet(size,(0,U32(sub)),(4,U64(ownUid)),(12,[1,1]),(19,U32(N(a,"序号"))));
    byte[] Buff(Dictionary<string,string>a){var p=Envelope(87,8150,a);U64(N(a,"目标UID",ulong.MaxValue)).CopyTo(p,39);U64(ownUid).CopyTo(p,47);U32(N(a,"效果类型")).CopyTo(p,55);U32(N(a,"效果等级")).CopyTo(p,59);U32(N(a,"持续毫秒")).CopyTo(p,63);U32(N(a,"添加1删除0",1)).CopyTo(p,75);U32(roomId).CopyTo(p,79);U32(battleSerial).CopyTo(p,83);return p;}
    byte[] RebindEvent(byte[] p){if(p.Length<39)throw new Exception("8071内容至少39字节；必须来自已抓取的实包");var sub=BinaryPrimitives.ReadUInt32LittleEndian(p);U64(ownUid).CopyTo(p,4);int offset=sub switch{8121=>86,8140=>95,8150=>79,8450=>51,8289=>67,_=>0};if(offset>0){if(p.Length<offset+8)throw new Exception("事件长度不足");U32(roomId).CopyTo(p,offset);U32(battleSerial).CopyTo(p,offset+4);}return p;}
    byte[] Report(Dictionary<string,string>a){var pairs=a["成员HP"].Split(',',StringSplitOptions.RemoveEmptyEntries);if(pairs.Length is <1 or >8)throw new Exception("需要1–8位本房成员");var p=new byte[696];var seen=new HashSet<ulong>();for(int i=0;i<pairs.Length;i++){var s=pairs[i].Split(':');if(s.Length!=2||!ulong.TryParse(s[0],out var uid)||uid==0||!ushort.TryParse(s[1],out var hp)||!seen.Add(uid))throw new Exception("成员格式应为不重复 UID:HP，HP为0–65535");U16(hp).CopyTo(p,i*87+2);U64(uid).CopyTo(p,i*87+29);U32(roomId).CopyTo(p,i*87+67);U32(battleSerial).CopyTo(p,i*87+71);}return p;}

    void Observe(uint id,byte[] p)
    {
        received[id]=received.GetValueOrDefault(id)+1;
        lastPackets[id]=p;
        if(id==3100&&p.Length>=245){roomId=BinaryPrimitives.ReadUInt16LittleEndian(p);phase="房间";}
        if(id==3115){roomId=0;phase="大厅";}
        if(id==3150&&p.Length>=8&&BitConverter.ToUInt64(p)==ownUid){roomId=0;phase="大厅";}
        if(id==4080&&p.Length==53){roomId=checked((ushort)BitConverter.ToUInt32(p));battleSerial=BitConverter.ToUInt32(p,5);phase="加载";}
        if(id==4081)phase="房间";
        if(id==4180)phase="等待输入";
        if(id==8070)phase="战斗";
        if(id==4120)phase="结算";
        if(id==3550&&p.Length==12&&BitConverter.ToUInt32(p,8)==0)phase="房间";
        stateLabel.Text=$"{phase} / 房{roomId} / 局{battleSerial}";
        if(id is 3030 or 3080 or 9060 or 2100){var code=id==3080&&p.Length>=18?BitConverter.ToUInt32(p,14):p.Length>=2?BitConverter.ToUInt16(p):0u;Add("失败应答",id,p.Length,$"服务器拒绝，代码 {code}（进房29不存在/30非等待/31密码/32满员；装备38；购买赠送130）",Convert.ToHexString(p));if(pending!=id)pending=0;}
        if(id==20150&&p.Length>=13){Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);int end=Array.IndexOf(p,(byte)0,13);Add("服务器通知",id,p.Length,Encoding.GetEncoding(936).GetString(p,13,(end<0?p.Length:end)-13),Convert.ToHexString(p));}
        if(id==8071&&p.Length>=4)Add("战斗事件",id,p.Length,$"子命令 {BitConverter.ToUInt32(p)}（转发证据，不等于客户端效果通过）",Convert.ToHexString(p));
        if(id==4120&&p.Length%500==0){for(int o=0;o<p.Length;o+=500)Add("结算",id,500,$"UID {BitConverter.ToUInt64(p,o)} 结果{p[o+10]}（1胜2败0平）经验+{BitConverter.ToUInt32(p,o+34)} 金币+{BitConverter.ToUInt32(p,o+63)}",Convert.ToHexString(p.AsSpan(o,500)));}
        if(id is 1550 or 1510 or 9080){int head=id==9080?6:0;if((p.Length-head)%108==0)for(int o=head;o+108<=p.Length;o+=108)Add("商品",id,108,$"键 {BitConverter.ToUInt32(p,o)} 类型 {p[o+4]} ID {BitConverter.ToUInt32(p,o+5)} 金币 {BitConverter.ToUInt32(p,o+30)} 点券 {BitConverter.ToUInt32(p,o+38)}",Convert.ToHexString(p.AsSpan(o,108)));}
        if(id==2280&&p.Length>=8&&(p.Length-8)%259==0)for(int o=8;o+259<=p.Length;o+=259)Add("房间",id,259,$"房号 {BitConverter.ToUInt16(p,o)} 人数 {p[o+40]}/{p[o+39]} 模式 {p[o+44]} 等待 {p[o+41]==1}",Convert.ToHexString(p.AsSpan(o,259)));
        if(id is 1120 or 1151 or 2160 or 2161){int head=id==1151?360:0;if(p.Length>=head&&(p.Length-head)%68==0)for(int o=head;o+68<=p.Length;o+=68)Add("库存",id,68,$"实例 {BitConverter.ToUInt32(p,o)} 已装备槽 {BitConverter.ToUInt16(p,o+17)}",Convert.ToHexString(p.AsSpan(o,68)));}
    }
}
