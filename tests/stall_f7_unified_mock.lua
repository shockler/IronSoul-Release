-- STALL-F7-UNIFIED-001: execute exact Stall.lua buyer source in mocked Market.
local file=assert(io.open("Stall.lua","rb"))
local source=file:read("*a");file:close()
local a=assert(source:find("-- STALL-F7-UNIFIED-001 START",1,true))
local b=assert(source:find("-- STALL-F7-UNIFIED-001 END",a,true))
local section=source:sub(a,b+#"-- STALL-F7-UNIFIED-001 END"-1)
assert(section:find('button(panel,"F7 MUA"',1,true),
    "F7 buyer must be a button inside existing Stall panel")
assert(source:find('if state.F7BuyExact then state.F7BuyExact() end',b,true),
    "F7 hotkey must invoke the same Stall buyer")
assert(source:find("priorBuyer.Stop",1,true),
    "loading Stall must stop the legacy standalone DEV F7 buyer")
assert(not section:find("ScreenGui",1,true),"no floating overlay for F7 buyer")

local function node(children)
    local t={Children=children or {}}
    function t:WaitForChild(name) return assert(self.Children[name],name) end
    return t
end
local function runCase(opt)
    opt=opt or {}
    local logs,calls={},{}
    local clock=100
    local balance=opt.balance
    if balance==nil and not opt.missingBalance then balance=1560 end
    local owner=opt.owner or 12345
    local items=opt.items or {{
        ItemType="Ore",ItemID="Hellstone10",Price=opt.price or 1560,
        ListingId="verified-stall-listing-001"
    },{
        ItemType="Scroll",ItemID="Scroll_10",Price=1560,
        ListingId="scroll-must-not-buy"
    }}
    local currencyUtil={}
    local player={UserId=200}
    local reads=0
    function currencyUtil:GetCount(who,id)
        assert(who==player and id=="Gem","must use initialized native Gem API")
        reads=reads+1
        if opt.balanceError then error("not ready") end
        if reads>1 and opt.changedBalance then return opt.changedBalance end
        return balance
    end
    local framework=node()
    local RS=node({Framework=framework})
    local booth={}
    local state={Alive=true,Busy=false,PurchaseBusy=false,Cancel=false,
        RefreshCount=0,SnapshotReceived=false,Stalls={},Full={},
        FullAt={},ResponseSlot=nil,PendingPurchase=nil,PurchasesSent=0}
    function booth:FireServer(action,...)
        calls[#calls+1]={action,...}
        if action=="RequestBoothShows" and not opt.timeout then
            state.Stalls={[6]={OwnerUserId=owner}}
            state.RefreshCount=state.RefreshCount+1
            state.SnapshotReceived=true
        elseif action=="InteractStall" and not opt.timeout then
            local slot=(...)
            assert(slot==6)
            state.Full[slot]={OwnerUserId=owner,Items=items}
            state.FullAt[slot]=clock
            state.ResponseSlot=slot
            if opt.stopOnDetail then state.Alive=false end
        end
    end
    local buttons={}
    local function button(parent,title,x,y,w,h,cb)
        if title=="F7 MUA" then buttons[#buttons+1]=cb end
        return {Title=title}
    end
    local players={}
    function players:GetUserIdFromNameAsync(name)
        assert(name=="vnbshockler")
        return 12345
    end
    local function positiveUserId(t)
        return type(t)=="table" and tonumber(t.OwnerUserId) or nil
    end
    local function str(t,...)
        for i=1,select("#",...) do
            local v=t[select(i,...)]
            if type(v)=="string" and v~="" then return v end
        end
        return nil
    end
    local function number(t,...)
        for i=1,select("#",...) do
            local v=t[select(i,...)]
            if type(v)=="number" then return v end
        end
        return nil
    end
    local env={
        state=state,RS=RS,LocalPlayer=player,Players=players,
        BoothRE=booth,marketPlace=function()return opt.market~=false end,
        positiveUserId=positiveUserId,getListingId=function(t) return t.ListingId end,
        str=str,number=number,
        saleBusy=opt.saleBusy==true,
        say=function(msg)logs[#logs+1]=msg end,
        button=button,panel={},Color={Green={}},
        task={spawn=function(fn)fn()end,wait=function(dt)clock=clock+(dt or .1)end},
        os={clock=function()return clock end},
        require=function(m)assert(m==framework);return {Modules={CurrencyUtil=currencyUtil}}end
    }
    setmetatable(env,{__index=_G})
    local f,err=load(section.."\nreturn state.F7BuyExact","actual Stall F7","t",env)
    assert(f,err)
    local buy=assert(f())
    assert(#buttons==1,"exactly one Stall F7 button")
    return {buy=buy,click=buttons[1],state=state,calls=calls,logs=logs}
end
local good=runCase()
good.click()
local purchases=0
for _,call in ipairs(good.calls) do
    if call[1]=="Purchase" then
        purchases=purchases+1
        assert(call[2]==12345 and call[3]=="verified-stall-listing-001",
            "exact seller UID and listing ID required")
    end
end
assert(purchases==1 and good.state.PurchasesSent==1,
    "F7 must send one exact Ore Purchase")
assert(good.calls[1][1]=="RequestBoothShows")
assert(good.calls[2][1]=="InteractStall")
assert(good.calls[3][1]=="Purchase")
good.buy()
local after=0
for _,call in ipairs(good.calls) do
    if call[1]=="Purchase" then after=after+1 end
end
assert(after==1,"F7 repeated must not resend the same listing")
local missing=runCase({missingBalance=true})
missing.click()
local missBuy=0
for _,v in ipairs(missing.calls) do if v[1]=="Purchase" then missBuy=missBuy+1 end end
assert(missBuy==0,"unknown Origin Shard must never buy")
local seller=runCase({owner=900})
seller.buy()
assert(seller.state.PurchasesSent==0,"wrong owner must never buy")
local price=runCase({price=2000})
price.buy()
assert(price.state.PurchasesSent==0,"wrong price must never buy")
local noMarket=runCase({market=false})
noMarket.buy()
assert(#noMarket.calls==0,"not in Market must never send")
local busy=runCase({saleBusy=true})
busy.buy()
assert(#busy.calls==0,"busy sale must block buying")
local duplicate=runCase({items={
 {ItemType="Ore",ItemID="Hellstone10",Price=1560,ListingId="verified-001"},
 {ItemType="Ore",ItemID="Hellstone9",Price=1560,ListingId="verified-002"}
}})
duplicate.buy()
assert(duplicate.state.PurchasesSent==1,"multiple exact-price Ore listings permit ONE purchase")
duplicate.buy()
assert(duplicate.state.PurchasesSent==2,"second explicit press may select a different listing")
duplicate.buy()
assert(duplicate.state.PurchasesSent==2,"never resend previously attempted UUID")
local seen={}
for _,call in ipairs(duplicate.calls) do
    if call[1]=="Purchase" then
        assert(call[2]==12345 and not seen[call[3]],"exact owner and distinct UUIDs")
        seen[call[3]]=true
    end
end
assert(seen["verified-001"] and seen["verified-002"])
local unknownId=runCase({items={
 {ItemType="Ore",ItemID="Hellstone10",Price=1560}
}})
unknownId.buy()
assert(unknownId.state.PurchasesSent==0,"missing ListingId must block")
local timeout=runCase({timeout=true})
timeout.buy()
assert(timeout.state.PurchasesSent==0,"server no response must not buy")
for _,opt in ipairs({
 {balance=-1},{balance=1.5},{balance=0/0},{balance=math.huge},
 {balance="1560"},{balanceError=true},{changedBalance=1559},{stopOnDetail=true}
}) do
    local case=runCase(opt);case.buy()
    assert(case.state.PurchasesSent==0,"invalid/changing balance or stop must block")
end
print("PASS STALL F7 UNIFIED: real in-panel button, exact owner+price+Ore, busy/duplicate safeguards")
