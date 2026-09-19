using System.Text.Json;

namespace KungfuProtocolTester;

internal sealed partial class TesterForm
{
    internal async Task AcceptanceSmokeAsync(bool purchaseOnly=false,bool protocolOnly=false)
    {
        using var peer=new TesterForm();using var outsider=new TesterForm();
        peer.Show();peer.Hide();outsider.Show();outsider.Hide();
        var forms=new[]{this,peer,outsider};
        var results=new List<object>();
        string stage="connect";
        var path=Path.Combine(root,protocolOnly?"protocol-regression.json":purchaseOnly?"purchase-test.json":"acceptance-test.json");
        void Record(string name,object evidence)=>results.Add(new{name,passed=true,evidence});
        void Check(bool ok,string why){if(!ok)throw new Exception(why);}
        async Task Until(Func<bool> condition,string why,int seconds=30){var deadline=DateTime.UtcNow.AddSeconds(seconds);while(!condition()){if(DateTime.UtcNow>deadline)throw new Exception(why+"; "+string.Join("; ",forms.Select(f=>f.status.Text)));await Task.Delay(60);}}
        async Task<byte[]> Ask(TesterForm f,uint id,byte[] p,uint reply){var n=f.received.GetValueOrDefault(reply);f.pending=0;f.Send(id,p,reply);await Until(()=>f.received.GetValueOrDefault(reply)>n,$"waiting {id}->{reply}");return f.lastPackets[reply];}
        void Fire(TesterForm f,uint id,byte[] p){f.pending=0;f.Send(id,p,0);}
        async Task<byte[]> Profile(TesterForm f,ulong uid){var p=await Ask(f,2420,U64(uid),2421);Check(p.Length>=377&&BitConverter.ToUInt64(p,8)==uid&&p.Length==377+68*p[16],"profile identity/length");var training=await Ask(f,21000,U64(uid),21001);Check(training.Length==56&&BitConverter.ToUInt64(training)==uid,"profile follow-up training identity");var stats=await Ask(f,20360,Packet(12,(0,U64(uid)),(8,new byte[]{0xc4,0xb6,0xaf,0xd7})),20370);Check(stats.Length>=36,"statistics placeholder shape");return p;}
        async Task Relog(TesterForm f){Fire(f,2060,[]);await Until(()=>!f.ready,"logout");await Until(()=>f.ready,"relogin",40);}
        Dictionary<string,string> RoomArgs(string password="")=>new(){["名称"]="验收测试",["密码"]=password,["模式"]="0",["容量"]="2",["地图"]="0",["时长秒"]="180"};
        byte[] Join(ushort room,string password="")=>Packet(14,(0,U16(room)),(3,FixedText(password,11)));
        async Task StartBattle(){var gates=new[]{received.GetValueOrDefault(8090u),peer.received.GetValueOrDefault(8090u)};await Ask(peer,4030,[],4050);await Ask(this,4030,[],4080);await Until(()=>peer.phase=="加载","peer loading");await Ask(this,4160,[],4170);await Ask(peer,4160,[],4180);await Until(()=>phase=="等待输入","loaded");Fire(this,8040,Packet(14,(0,U16(roomId)),(2,U64(ownUid))));await Ask(peer,8040,Packet(14,(0,U16(peer.roomId)),(2,U64(peer.ownUid))),8070);await Until(()=>phase=="战斗"&&received.GetValueOrDefault(8090u)>gates[0]&&peer.received.GetValueOrDefault(8090u)>gates[1],"battle clocks enabled");foreach(var f in new[]{this,peer})Check(f.lastPackets[8090].SequenceEqual(U32(1)),"clock gate payload");}
        byte[][] Inventory(TesterForm f)=>Enumerable.Range(0,f.lastPackets[1120].Length/68).Select(i=>f.lastPackets[1120].AsSpan(i*68,68).ToArray()).ToArray();
        uint Gold(TesterForm f)=>f.lastPackets.TryGetValue(1240,out var p)?BitConverter.ToUInt32(p):BitConverter.ToUInt32(f.lastPackets[1020],16);
        var loops=new List<Task>();
        try {
            for(int i=0;i<forms.Length;i++){var f=forms[i];f.account.Text="localtest"+(10-i);f.password.Text=Environment.GetEnvironmentVariable("OPENKFO_TEST_PASSWORD")??throw new Exception("missing password");f.config.Text=config.Text;loops.Add(f.ConnectLoop());}
            await Until(()=>forms.All(f=>f.ready),"three test accounts");
            if(!purchaseOnly){
            stage="profiles";
            var self=await Profile(this,ownUid);var other=await Profile(this,peer.ownUid);
            Record(stage,new{self_uid=ownUid,self_equipped=self[16],other_uid=peer.ownUid,other_equipped=other[16],game_ui_verified=false});
            stage="room errors";
            await Ask(this,3010,RoomRequest(RoomArgs("2468")),3100);var room=roomId;
            var denied=await Ask(peer,3070,Join(room,"wrong"),3080);Check(BitConverter.ToUInt32(denied,14)==31,"wrong password error code");
            await Ask(peer,3070,Join(room,"2468"),3100);
            denied=await Ask(outsider,3070,Join(room,"2468"),3080);Check(BitConverter.ToUInt32(denied,14)==32,"full room error code");
            int kicks=received.GetValueOrDefault(3150u);
            Fire(peer,3140,Packet(9,(0,U64(ownUid))));
            // Same-channel read acts as a processing barrier, not an arbitrary sleep.
            await Profile(peer,peer.ownUid);Check(received.GetValueOrDefault(3150u)==kicks&&roomId==room&&peer.roomId==room,"nonowner kicked host");
            Record(stage,new{wrong_password=31,full_room=32,nonowner_kick_denied=true,connections_alive=forms.All(f=>f.ready)});
            stage="win loss draw and return";
            for(int round=0;round<3;round++){
                var before=new[]{await Profile(this,ownUid),await Profile(peer,peer.ownUid)};var goldBefore=new[]{Gold(this),Gold(peer)};
                await StartBattle();
                if(round==0){
                    stage="buff 14 relay";
                    var args=new Dictionary<string,string>{["序号"]="1",["目标UID"]=Convert.ToString(peer.ownUid),["效果类型"]="14",["效果等级"]="1",["持续毫秒"]="3000",["添加1删除0"]="1"};
                    var packet=Buff(args);int count=peer.received.GetValueOrDefault(8071u);Fire(this,8071,packet);await Until(()=>peer.received.GetValueOrDefault(8071u)>count,"buff relay");Check(peer.lastPackets[8071].SequenceEqual(packet),"buff payload changed");
                    // Replay the native remote-expiration shape: source and effect parameters cleared.
                    var cleanup=packet.ToArray();U64(peer.ownUid).CopyTo(cleanup,4);Array.Clear(cleanup,47,8);Array.Clear(cleanup,59,20);
                    int cleared=received.GetValueOrDefault(8071u);Fire(peer,8071,cleanup);await Until(()=>received.GetValueOrDefault(8071u)>cleared,"remote buff cleanup relay");Check(lastPackets[8071].SequenceEqual(cleanup),"cleanup payload changed");
                    Fire(peer,8071,cleanup);var barrier=cleanup.ToArray();U32(BitConverter.ToUInt32(cleanup,19)+1).CopyTo(barrier,19);Fire(peer,8071,barrier);await Until(()=>received.GetValueOrDefault(8071u)>=cleared+2,"battle cleanup barrier");Check(received.GetValueOrDefault(8071u)==cleared+2&&lastPackets[8071].SequenceEqual(barrier),"duplicate cleanup relayed");
                    Record(stage,new{effect=14,duration_ms=3000,bytes_preserved=true,remote_cleanup=true,duplicate_cleanup_ignored=true,connection_alive=true,natural_expiry_verified=false});stage="win loss draw and return";
                }
                string hp=round==0?$"{ownUid}:100,{peer.ownUid}:0":round==1?$"{ownUid}:0,{peer.ownUid}:100":$"{ownUid}:100,{peer.ownUid}:100";
                var argsReport=new Dictionary<string,string>{["成员HP"]=hp};var report=Report(argsReport);
                Fire(this,4110,report);await Ask(peer,4110,peer.Report(argsReport),4120);await Until(()=>phase=="结算","host settled");
                foreach(var pair in new[]{(this,0),(peer,1)}){
                    var f=pair.Item1;int i=pair.Item2;var result=f.lastPackets[4120];
                    int at=Enumerable.Range(0,result.Length/500).Select(j=>j*500).Single(o=>BitConverter.ToUInt64(result,o)==f.ownUid);
                    byte expectedOutcome=round==2?(byte)0:(round==i?(byte)1:(byte)2);
                    Check(result[at+10]==expectedOutcome,"wrong outcome");uint exp=BitConverter.ToUInt32(result,at+34),gold=BitConverter.ToUInt32(result,at+63);
                    Check(Gold(f)==goldBefore[i]+gold,"gold reward delta");
                    Check(BitConverter.ToUInt32(result,at+140+249)==BitConverter.ToUInt32(before[i],17+249)+exp,"total experience delta");
                    Record($"round {round+1} account {f.ownUid}",new{outcome=expectedOutcome,experience=exp,gold});
                }
                var settledGold=Gold(this);var countSettled=received.GetValueOrDefault(4120u);
                Fire(this,4110,report);await Ask(this,3550,Self(12),3550);await Ask(peer,3550,peer.Self(12),3550);
                var persisted=await Profile(this,ownUid);Check(Gold(this)==settledGold&&received.GetValueOrDefault(4120u)==countSettled,"duplicate settlement awarded twice");
                Check(phase=="房间"&&peer.phase=="房间","result view remains");
                Record($"round {round+1} return",new{same_room=roomId==room&&peer.roomId==room,duplicate_report_did_not_award=true,total_experience=BitConverter.ToUInt32(persisted,17+249)});
            }
            stage="host disconnect";
            peer.pending=0;reconnect.Checked=false;worker!.Kill();await Until(()=>!ready&&peer.ready,"host disconnect");await Until(()=>peer.lastPackets.TryGetValue(3160,out var p)&&BitConverter.ToUInt64(p)==peer.ownUid,"owner transfer");
            await Profile(peer,peer.ownUid);Check(peer.roomId==room&&peer.phase=="房间","peer lost room");Record(stage,new{remaining_room=room,new_owner=peer.ownUid});await Ask(peer,3110,[],3115);
            await loops[0];reconnect.Checked=true;loops[0]=ConnectLoop();await Until(()=>ready,"host reconnect");
            }
            if(!protocolOnly){
            stage="purchase equip persist";
            var inventoryBefore=Inventory(this);var previousWeapon=inventoryBefore.FirstOrDefault(p=>BitConverter.ToUInt16(p,17)==8);
            // Item kind 25 is not the shop category number. Fetch real offers
            // and filter the record kind instead of guessing a category.
            var catalog=await Ask(this,1540,[],1550);Check(catalog.Length%108==0,"catalog shape");
            uint tickets=BitConverter.ToUInt32(lastPackets[1230]);uint goldBalance=Gold(this);
            var offer=Enumerable.Range(0,catalog.Length/108).Select(i=>catalog.AsSpan(i*108,108).ToArray()).Where(p=>p[4]==25&&p[48]!=0&&p[46]==0&&p[49]==0&&p[13]==0&&p[83]==1&&BitConverter.ToUInt32(p,88)==0&&BitConverter.ToUInt32(p,77)==0)
                .Where(p=>{uint g=BitConverter.ToUInt32(p,30),t=BitConverter.ToUInt32(p,38);return (g==0)!=(t==0)&&g<=goldBalance&&t<=tickets&&BitConverter.ToUInt32(p,34)==g&&BitConverter.ToUInt32(p,42)==t;})
                .OrderBy(p=>(ulong)BitConverter.ToUInt32(p,30)+BitConverter.ToUInt32(p,38)).FirstOrDefault();
            Check(offer!=null,"no affordable supported weapon offer; purchase not verified");
            uint priceGold=BitConverter.ToUInt32(offer!,30),priceTickets=BitConverter.ToUInt32(offer!,38),key=BitConverter.ToUInt32(offer!);
            int grants=received.GetValueOrDefault(2160u);
            await Ask(this,9040,Purchase(new(){["商品键"]=key.ToString(),["金币价格"]=priceGold.ToString(),["点券价格"]=priceTickets.ToString()}),9050);
            Check(received.GetValueOrDefault(2160u)==grants+1,"purchase grant count");uint instance=BitConverter.ToUInt32(lastPackets[2160]);
            Check(priceGold>0?Gold(this)==goldBalance-priceGold:BitConverter.ToUInt32(lastPackets[1230])==tickets-priceTickets,"purchase charged wrong amount");
            var equip=await Ask(this,2080,Packet(16,(0,U32(instance))),2090);Check(BitConverter.ToUInt32(equip,4)==8&&BitConverter.ToUInt16(equip,16+17)==8,"slot0 not resolved to8");
            Check(Inventory(this).Length==inventoryBefore.Length+1,"purchase inventory count");
            await Ask(this,2300,U32(instance),2310);await Ask(this,2080,Packet(16,(0,U32(instance))),2090);
            await Relog(this);Check(Inventory(this).Length==inventoryBefore.Length+1&&Inventory(this).Count(p=>BitConverter.ToUInt32(p)==instance&&BitConverter.ToUInt16(p,17)==8)==1,"inventory/equip not persistent");
            Check(priceGold>0?BitConverter.ToUInt32(lastPackets[1020],16)==goldBalance-priceGold:BitConverter.ToUInt32(lastPackets[1230])==tickets-priceTickets,"purchase balance not persistent");
            await Ask(this,2300,U32(instance),2310);
            if(previousWeapon!=null)await Ask(this,2080,Packet(16,(0,previousWeapon.AsSpan(0,4).ToArray())),2090);
            Record(stage,new{catalog_key=key,instance,gold_price=priceGold,ticket_price=priceTickets,one_grant=true,persistent=true,previous_weapon_restored=previousWeapon!=null});
            }
            File.WriteAllText(path,JsonSerializer.Serialize(new{passed=true,time=DateTimeOffset.Now,results,game_ui_verified=false,buff_natural_expiry_verified=false},new JsonSerializerOptions{WriteIndented=true}));
        }catch(Exception e){File.WriteAllText(path,JsonSerializer.Serialize(new{passed=false,time=DateTimeOffset.Now,stage,error=e.Message,results},new JsonSerializerOptions{WriteIndented=true}));throw;}
        finally{foreach(var f in forms)f.Stop();await Task.WhenAll(loops);Save();}
    }
}
