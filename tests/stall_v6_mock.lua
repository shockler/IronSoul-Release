-- Execute the actual V6 scorer, bulk selector and shared listing guard.
local f=assert(io.open("Stall.lua","rb"));local source=f:read("*a");f:close()
-- Preserve the deployed launcher's readiness and teardown GUI contract.
local lf=assert(io.open("IronSoul_Launcher_Stall_V5.lua","rb"))
local launcher=lf:read("*a");lf:close()
local guiName=assert(source:match('gui%.Name="([^"]+)"'))
local refs=0
for name in launcher:gmatch('PlayerGui:FindFirstChild%("([^"]+)"%)') do
    if name:match("^IronSoulScrollMarketScanner") then
        refs=refs+1
        assert(name==guiName,"Launcher readiness/cleanup must use actual Stall GUI name")
    end
end
assert(refs==2,"verify both readiness and cleanup")
assert(source:find("STALL MARKET v6",1,true),"V6 display label must remain")
local function section(a,b)
    local first=assert(source:find(a,1,true))
    return source:sub(first,assert(source:find(b,first,true))-1)
end
local function loadIn(code,env)
    setmetatable(env,{__index=_G})
    return assert(load(code,"actual V6 source","t",env))()
end
local parse=loadIn(section("local TARGET_BY_KEY=","local function parseRarity").."\nreturn parseStats",
    {isNumber=function(n)return type(n)=="number" and n==n and math.abs(n)<1e14 end})
local stats,groups,score,_,sum=parse({Attrs={AttackBonus=.20,SkillCDR=.10,CritRate=5,HealthBonus=15}})
assert(#stats==4 and score==3 and groups.CDR and sum==35,"five-type scorer and percentage tie sum")
local _,_,duplicate= parse({Attrs={AttackBonus=20,AtkBonus=10,SkillCDR=5,HealthBonus=1}})
assert(duplicate==2,"aliases count once per good stat TYPE")
local _,_,poor,_,poorSum=parse({Attrs={DashCDR=10,HealthBonus=5,MoveSpeed=7,SkillCharge=4}})
assert(poor==0 and poorSum==0)
local _,_,all= parse({Attrs={AttackBonus=20,SkillCDR=10,CritRate=5,CritDamage=30}})
assert(all==4)
local rarity=parse and loadIn(section("local rarityInfo=","local function rarityStyle").."\nreturn parseRarity",{})
assert(rarity({Rarity=6})==6 and rarity({Info={ScrollRarity=5}})==5)
assert(rarity({Attrs={AttackBonus=10,SkillCDR=10,CritRate=10,CritDamage=10}})==nil,
    "never infer rolled rarity from stat count")
local fitEnv={state={}}
loadIn(section("-- STALL_V61_LAYOUT_BEGIN","-- STALL_V61_LAYOUT_END"),fitEnv)
for _,width in ipairs({800,1280,1600,1920}) do
    for _,sell in ipairs({false,true}) do
        local cols=fitEnv.state.FitColumns({{Name="Gun Scroll: Gravity",Owner="seller"}},width,sell)
        assert(#cols==9)
        local sum=0
        for _,w in ipairs(cols) do assert(w>0);sum=sum+w end
        assert(math.abs(sum-1)<1e-9,"all nine columns fit viewport")
    end
end
local function intRange(v,lo,hi)
    local n=tonumber(v)
    if n and n==n and n%1==0 and n>=lo and n<=hi then return n end
end
local qualityPrice=loadIn(section("local function qualityPrice","-- STALL_V6_PRICE_END").."\nreturn qualityPrice",
    {intRange=intRange})
assert(qualityPrice({Min=3,Max=10},1.5)==5)
assert(qualityPrice({Min=8,Max=10},2)==10)
assert(not qualityPrice({Min=8},1) and not qualityPrice({Min=8,Max=7},1))
local bulkEnv={V6={},saleAttempted={},qualityPrice=qualityPrice}
loadIn(section("-- STALL_V6_BULK_CORE_BEGIN","-- STALL_V6_BULK_CORE_END"),bulkEnv)
local items={}
for i=0,4 do items[#items+1]={UUID="id"..i,Premium=i,GoodSum=i*10,Rarity=i%2+1,Min=10,Max=30} end
local selected=bulkEnv.V6.Select(items,"ALL","POOR",1,30)
assert(#selected==2 and selected[1].Record.Premium==0 and selected[2].Record.Premium==1)
for i=0,4 do
    local exact=bulkEnv.V6.Select(items,"ALL",i,1.5,30)
    assert(#exact==1 and exact[1].Record.Premium==i and exact[1].Price==15)
end
assert(#bulkEnv.V6.Select(items,2,"ALL",2,30)==2)
assert(#bulkEnv.V6.Select(items,"ALL","ALL",1,1)==1)
assert(#bulkEnv.V6.Select(items,"ALL","ALL",1,0)==0)
items[1].Blocked=true;bulkEnv.saleAttempted.id1=true
assert(#bulkEnv.V6.Select(items,"ALL","POOR",1,30)==0)

local guardCode=section("-- STALL_V6_GUARD_BEGIN","-- STALL_V6_GUARD_END").."\nreturn SaleGuard"
local function case(opt)
    opt=opt or {}
    local clock,stock,dispatch=100,100,0
    local listed={}
    for i=1,(opt.count or 0) do
        listed["old"..i]={ListingId="old"..i,ItemType="Ore",ItemID="OreA",Quantity=1,Price=10}
    end
    local st={Alive=true,Busy=false,PurchaseBusy=false,RefreshCount=0,Full={},FullAt={},Stalls={}}
    local remote={}
    local e={state=st,env={},saleStop=false,LocalPlayer={UserId=7},
        intRange=intRange,index={["Ore\0OreA"]={MinPrice=10,MaxPrice=20}},
        marketPlace=function()return opt.market~=false end,
        positiveUserId=function(t)return t and t.OwnerUserId end,
        getListingId=function(t)return t.ListingId end,
        str=function(t,...)for i=1,select("#",...)do local v=t[select(i,...)];if type(v)=="string" then return v end end end,
        number=function(t,...)for i=1,select("#",...)do local v=t[select(i,...)];if type(v)=="number" then return v end end end,
        oreBag=function()if opt.noStock then return nil end return {OreA=stock} end,
        os={clock=function()return clock end},
        task={wait=function(dt)clock=clock+(dt or .1)end}}
    function remote:FireServer(action,...)
        if action=="RequestBoothShows" then
            if opt.timeout then return end
            st.RefreshCount=st.RefreshCount+1;st.Stalls={[1]={OwnerUserId=opt.owner or 7}}
        elseif action=="InteractStall" then
            st.Full[1]={OwnerUserId=opt.owner or 7,Items=opt.noItems and 7 or listed}
            st.ResponseSlot=1
        elseif action=="ListStack" then
            dispatch=dispatch+1
            if opt.throw then error("ambiguous transport") end
            local typ,id,qty,price=...
            assert(typ=="Ore" and id=="OreA")
            if not opt.noAck then
                local uuid="new"..dispatch
                listed[uuid]={ListingId=uuid,ItemType=typ,ItemID=id,Quantity=qty,Price=price}
                if not opt.staleStock then stock=stock-qty end
            end
        else error("unexpected "..action) end
    end
    e.DeliverLate=function()
        listed.new1={ListingId="new1",ItemType="Ore",ItemID="OreA",Quantity=2,Price=30}
        stock=98;opt.noAck=false
    end
    e.BoothRE=remote
    local guard=loadIn(guardCode,e)
    return guard,e,function()return dispatch,stock end
end
local g,e,count=case({count=29})
assert(g.Free()==1)
assert(g.Ore("OreA",2,30))
assert(g.Free()==0)
assert(not g.Ore("OreA",2,30))
assert(count()==1,"30-slot ceiling across sends")
local repeatGuard,repeatEnv,repeatCount=case()
assert(repeatGuard.Ore("OreA",2,30))
assert(repeatGuard.Ore("OreA",2,30))
assert(repeatCount()==2,"confirmed identical manual listings may repeat")
for _,opt in ipairs({{count=30},{owner=8},{timeout=true},{noItems=true},{noStock=true},{market=false}})do
    local guard,env,calls=case(opt)
    assert(not guard.Ore("OreA",2,30))
    assert(calls()==0,"invalid snapshot/stock must not dispatch")
end
for _,opt in ipairs({{noAck=true},{staleStock=true},{throw=true}}) do
    local guard,env,calls=case(opt)
    assert(not guard.Ore("OreA",2,30))
    assert(guard.Pending and env.env.IronSoulStallSalePending)
    assert(not guard.Ore("OreA",2,30))
    assert(calls()==1,"uncertainty must retain reservation and block every next send")
end
local guard,env,calls=case()
assert(not guard.Ore("OreA",2,19) and not guard.Ore("OreA",2,41))
assert(not guard.Ore("OreA",1.5,20))
env.state.Busy=true;assert(not guard.Ore("OreA",2,30))
env.state.Busy=false;env.saleStop=true;assert(not guard.Ore("OreA",2,30))
assert(calls()==0)
-- Execute Clone's real sending loop against the shared guard.
local cloneCode=section("local function cloneSendPlans","for i=1,4 do\n    local row=i").."\nreturn cloneSendPlans"
local cg,ce,cc=case()
ce.SaleGuard=cg;ce.saleBusy=false;ce.cloneSelected="OreA";ce.cloneInFlight={}
ce.cloneMsg=function()end;ce.cloneCalculate=function()end
ce.fmt=tostring;ce.task.spawn=function(fn)fn()end
local send=loadIn(cloneCode,ce)
local plan={Quantity=2,Price=30,Signature="1|OreA|30|2"}
send({plan},{1});send({plan},{1})
assert(cc()==2 and not ce.cloneInFlight[plan.Signature],"actual Clone loop unlocks same row after confirmation")
local ng,ne,nc=case({noAck=true})
ne.SaleGuard=ng;ne.saleBusy=false;ne.cloneSelected="OreA";ne.cloneInFlight={}
ne.cloneMsg=function()end;ne.cloneCalculate=function()end;ne.fmt=tostring
ne.task.spawn=function(fn)fn()end
local uncertain=loadIn(cloneCode,ne)
uncertain({plan},{1});uncertain({plan},{1})
assert(nc()==1 and ne.cloneInFlight[plan.Signature],"actual Clone loop keeps uncertain in-flight lock")
print("PASS V6: shared five-stat scoring, bulk exact filters/caps, integer prices, 30 slots, uncertainty, Clone repeat")

-- Execute owned inventory normalization and the Scroll sending wrapper.
local owned={
 {UUID="scroll-uuid-00000001",ItemId="Scroll_A",Rarity=6,Equipped=true,
  Attrs={AttackBonus=20,SkillCDR=10,CritRate=5,CritDamage=30}},
 {UUID="scroll-uuid-00000002",ItemId="Scroll_A",Rarity=6,Tradeable=false,
  Attrs={AttackBonus=1,SkillCDR=1,CritRate=1,CritDamage=1}},
 {UUID="scroll-uuid-00000003",ItemId="Scroll_A",Rarity=5,
  Attrs={AttackBonus=10,SkillCDR=5,CritRate=3,CritDamage=15}},
}
local invEnv={ScrollUtil={GetOwned=function()return owned end},dataUtil=nil,
    index={["Scroll\0Scroll_A"]={MinPrice=10,MaxPrice=30}},intRange=intRange,
    scrollName=function(id)return id end,parseStats=parse,
    parseRarity=function(raw)return raw.Rarity end}
local scan,valid=loadIn(section("local function validScrollUUID","-- STALL_V6_PRICE_BEGIN")
    .."\nreturn scanOwnedScrolls,validScrollUUID",invEnv)
local records=scan()
assert(#records==3 and records[1].GoodSum==65 and records[1].Premium==4)
assert(not records[1].Blocked,"equipped scanning/protection intentionally dropped")
assert(records[2].GoodSum==33 and records[3].Blocked,"sort by good percentage sum; nontradeable stays blocked")
owned[#owned+1]=owned[1]
assert(#scan()==3,"duplicate UUID inventory sources collapse")
table.remove(owned)
local original=owned[1].Rarity
owned[1].Rarity=nil
owned[#owned+1]={UUID=owned[1].UUID,ItemId=owned[1].ItemId,Rarity=6}
assert(scan()[1].Rarity==6,"explicit rarity from later matching UUID is not lost")
table.remove(owned)
owned[1].Rarity=original
-- Actual game ScrollUtil stores only Id, UUID, Attrs; Rarity comes from GetDef.
do
    local ids={"Scroll_Gun_2","Scroll_Gun_3","Scroll_Sickle_3","Scroll_Sword_1","Scroll_JacksWrath_1"}
    local ranks={6,5,4,3,7}
    local bag,defs,registry={}, {}, {}
    local who={UserId=7}
    for i,id in ipairs(ids) do
        local uuid="native-scroll-uuid-000"..i
        bag[uuid]={Id=id,UUID=uuid,Attrs={AttackBonus=10,HealthBonus=10}}
        defs[id]={ID=id,Rarity=ranks[i],CanTrade=true}
        registry["Scroll\0"..id]={MinPrice=10,MaxPrice=30}
    end
    -- Simulate an explicit non-tradeable config without assuming all Secret is blocked.
    defs[ids[5]].CanTrade=false
    local e={LocalPlayer=who,index=registry,intRange=intRange,scrollName=function(id)return id end,
        parseStats=parse,parseRarity=function(raw)return raw.Rarity end,
        ScrollDefinitions=defs,
        ScrollUtil={
            GetAllOwned=function(_,p)assert(p==who);return bag end,
            GetDef=function(_,id)
                if id==ids[4] then return nil end -- exact ResScrolls fallback
                return defs[id]
            end,
            GetOwned=function()error("native path must not query legacy source")end
        }}
    local native=loadIn(section("local function validScrollUUID","-- STALL_V6_PRICE_BEGIN")
        .."\nreturn scanOwnedScrolls",e)
    local result,unresolved,diagnostics=native()
    assert(#result==5 and unresolved==0 and diagnostics=="ScrollUtil.GetAllOwned:OK")
    local byId={}
    for _,v in ipairs(result) do byId[v.Id]=v end
    for i,id in ipairs(ids)do assert(byId[id].Rarity==ranks[i],"definition rarity: "..id) end
    assert(byId[ids[5]].Blocked and not byId[ids[1]].Blocked)
    assert(byId[ids[1]].Premium==1 and byId[ids[3]].Premium==1)
    local mythic=bulkEnv.V6.Select(result,6,"POOR",1,30)
    assert(#mythic==1 and mythic[1].Record.Id==ids[1],"native inventory Mythic filter")
    local legendary=bulkEnv.V6.Select(result,5,"POOR",1,30)
    assert(#legendary==1 and legendary[1].Record.Id==ids[2],"native inventory Legendary filter")
    assert(#bulkEnv.V6.Select(result,7,"ALL",1,30)==0,"explicit tradeability guard remains")
    print("PASS V6.2 native owned map + definition rarity + exact rarity filters")
end
local sends=0
local se={saleAttempted={},validScrollUUID=valid,scanOwnedScrolls=scan,intRange=intRange,
    SaleGuard={Send=function(kind,id,qty,price,check,uuid)
        assert(kind=="Scroll" and id=="Scroll_A" and qty==1 and price==15)
        assert(check(false))
        sends=sends+1
        for i=#owned,1,-1 do if owned[i].UUID==uuid then table.remove(owned,i) end end
        assert(check(true),"inventory removal confirms scroll")
        return true
    end}}
local sendScroll=loadIn(section("local function sameOwnedScroll","local updateBulkButtons")
    .."\nreturn sendScrollList",se)
assert(not sendScroll(records[3],15),"nontradeable blocked")
assert(not sendScroll(records[1],9) and not sendScroll(records[1],31),"manual legal bounds")
assert(sendScroll(records[1],15))
assert(not sendScroll(records[1],15) and sends==1,"UUID one shot")
print("PASS V6 Scroll: real inventory scorer/sort, tradeability, equipped allowed, duplicate UUID, manual bounds, removal ACK")

do
    local nodes={}
    local function node(kind,parent,text)
        local obj={Kind=kind,Parent=parent,Text=text,Children={},AbsoluteSize={X=1000}}
        function obj:IsA(k)return self.Kind==k end
        function obj:GetChildren()
            local result={}
            for _,child in ipairs(self.Children)do if not child.Destroyed then result[#result+1]=child end end
            return result
        end
        function obj:Destroy()self.Destroyed=true end
        function obj:GetPropertyChangedSignal()return {Connect=function()return {} end}end
        if parent then parent.Children[#parent.Children+1]=obj end
        nodes[#nodes+1]=obj
        return obj
    end
    local rows=node("ScrollingFrame")
    local bar=node("Frame")
    local e={saleRows=rows,bulkBar=bar,saleTitle={},saleHeader={},SCROLL_COLUMNS={},
        saleLayout={AbsoluteContentSize={Y=500}},state={Alive=true,Conn={},FitColumns=fitEnv.state.FitColumns},saleBusy=false,
        saleAttempted={},intRange=intRange,qualityPrice=qualityPrice,rarityInfo={[5]={},[6]={},[7]={}},
        scanOwnedScrolls=function()return {
            {UUID="ui-a",Name="A",Premium=1,GoodSum=10,Rarity=6,Min=10,Max=30,
             Attrs={"Skill CDR +10%","Health Bonus +1%","Move Speed +1%","Dash CDR +1%"}},
            {UUID="ui-b",Name="B",Premium=0,GoodSum=0,Rarity=5,Min=10,Max=30,Attrs={}}
        },0 end,
        rarityStyle=function(id)return "R"..id,"rarity"..id end,
        goodStatText=function(t)return t:find("Skill CDR",1,true)~=nil end,
        saleMsg=function()end,writeSaleHeader=function()end,
        task={spawn=function(fn)fn()end},
        SaleGuard={Free=function()return 1 end},
        UDim2={new=function(...)return {...}end,fromOffset=function(...)return {...}end},
        Enum={Font={GothamBold="GothamBold"}},Color={Text="text",Field="field",Green="green",Blue="blue"},
        Color3={fromRGB=function(r,g,b)return r..","..g..","..b end},
        Instance={new=function(kind,parent)return node(kind,parent)end}}
    e.sellButton=function(parent,text,x,y,w,h,cb)
        local b=node("TextButton",parent,text);b.Click=cb;return b
    end
    e.field=function(parent,placeholder,x,y,w,h,text)return node("TextBox",parent,text)end
    e.label=function(parent,text)return node("TextLabel",parent,text)end
    local refresh=loadIn(section("local updateBulkButtons","-- STALL_V61_RESIZE_BEGIN")
        .."\nreturn refreshScrollSale",e)
    refresh()
    local children=rows:GetChildren()
    assert(#children==2,"fixed header outside scrolling rows")
    assert(children[1].Size[1]==1 and children[1].Size[2]==-10 and rows.CanvasSize[1]==0,
        "narrow viewport fits full width without horizontal canvas")
    local cells=children[1]:GetChildren()
    assert(#cells==10,"nine logical columns with input and button in last column")
    assert(cells[1].TextColor3=="rarity6" and cells[1].Text:find("1/5",1,true))
    for i=1,5 do assert(cells[i].Font=="GothamBold")end
    assert(cells[2].TextColor3=="95,255,135" and cells[3].TextColor3=="205,210,220")
    assert(cells[6].Text=="10" and cells[7].Text=="15" and cells[8].Text=="20")
    local rarityBar=bar:GetChildren()[1]
    local tabs=rarityBar:GetChildren()
    assert(#tabs==4 and tabs[1].Text=="ALL","ALL plus every native rarity, including empty")
    tabs[3].Click()
    assert(#rows:GetChildren()==1,"rarity tab actually filters rows")
    local maxButton
    for _,n in ipairs(nodes)do if n.Kind=="TextButton" and n.Text=="MAX" then maxButton=n end end
    maxButton.Click()
    local quantity
    for _,n in ipairs(bar:GetChildren())do if n.Kind=="TextBox" then quantity=n end end
    assert(quantity.Text=="1","MAX obeys current eligible items and verified free slots")
    print("PASS V6.1 UI: nine columns, responsive width, rarity tabs, bold stat colors, quick prices, MAX")
end

do
    local guard,env,calls=case({noAck=true})
    assert(not guard.Ore("OreA",2,30) and calls()==1)
    env.DeliverLate()
    assert(guard.Ore("OreA",2,30) and calls()==2 and not guard.Pending,
        "manual repeat reconciles a late ACK before reserving a new slot")
    print("PASS V6: late confirmed result releases temporary reservation")
end
