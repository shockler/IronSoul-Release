-- MARKET_LITE_V1: run the real source block, including the floor / UI safety rules.
local file=assert(io.open("Stall.lua","rb"))
local full=file:read("*a"); file:close()
local a=assert(full:find("-- STALL_MARKET_LITE_V1_BEGIN",1,true))
local b=assert(full:find("-- STALL_MARKET_LITE_V1_END",a,true))
local block=full:sub(a,b+#"-- STALL_MARKET_LITE_V1_END"-1)
assert(full:find("setMarketLite(enabled)",b,true),"Market Lite must follow LOW FX toggle")
assert(full:find("setLowFX(true)",b,true),"LOW FX/Market Lite defaults ON")
assert(full:find("setLowFX(false)",b,true),"Stop must restore Market visuals")
assert(not block:find(":Destroy%("),"must never destroy Market models")
for _,field in ipairs({"CanCollide","CanTouch","CanQuery","AssemblyLinearVelocity","CFrame="}) do
    assert(not block:find(field,1,true),"must not mutate physics or positions: "..field)
end
local function event()
    local signal={all={}}
    function signal:Connect(fn)
        local conn={connected=true}
        function conn:Disconnect()self.connected=false end
        self.all[#self.all+1]={fn=fn,conn=conn}
        return conn
    end
    function signal:Emit(item)
        for _,v in ipairs(self.all) do if v.conn.connected then v.fn(item) end end
    end
    return signal
end
local function object(class,name,properties)
    local v={ClassName=class,Name=name,Parent={},Children={},
        Anchored=true,Size={X=4,Y=10,Z=2},
        CFrame={UpVector={Y=1}},LocalTransparencyModifier=0,
        CanCollide=true,CanTouch=true,CanQuery=true}
    for k,value in pairs(properties or {}) do v[k]=value end
    function v:IsA(typ)
        return self.ClassName==typ or (typ=="BasePart" and
            (self.ClassName=="Part" or self.ClassName=="MeshPart"))
    end
    function v:GetDescendants()
        local result={}
        local function walk(node)
            for _,child in ipairs(node.Children) do
                result[#result+1]=child
                walk(child)
            end
        end
        walk(self)
        return result
    end
    function v:FindFirstChildOfClass(class)
        for _,child in ipairs(self.Children) do
            if child.ClassName==class then return child end
        end
        return nil
    end
    return v
end
local function attach(parent,child)
    child.Parent=parent
    parent.Children[#parent.Children+1]=child
    return child
end
local Workspace=object("Workspace","Workspace",{DescendantAdded=event()})
Workspace.Terrain=object("Terrain","Terrain")
local district=attach(Workspace,object("Model","MarketCity"))
local booth=attach(Workspace,object("Model","Booth_12"))
local stallWall=attach(booth,object("Part","Wall",{LocalTransparencyModifier=0.22}))
local roof=attach(booth,object("MeshPart","CanopyRoof",{Size={X=15,Y=1,Z=14}}))
local decorations=attach(district,object("MeshPart","SignOrnament",{LocalTransparencyModifier=0.35}))
local tree=attach(district,object("Part","LeafCluster"))
local road=attach(district,object("Part","Road_3"))
local platform=attach(booth,object("Part","StallBase"))
local genericFloor=attach(district,object("Part","Part",{Size={X=18,Y=1,Z=18}}))
local promptPart=attach(booth,object("Part","InteractMesh"))
attach(promptPart,object("ProximityPrompt","TradePrompt"))
local sellerBoard=attach(booth,object("Part","SellerBoard"))
attach(sellerBoard,object("SurfaceGui","SellerNamePrice"))
local dynamicPart=attach(district,object("Part","VendingMachine",{Anchored=false}))
local npc=attach(Workspace,object("Model","Vendor"))
attach(npc,object("Humanoid","Humanoid"))
local npcPart=attach(npc,object("Part","Torso"))
local avatar=attach(Workspace,object("Model","AnotherPlayer"))
attach(avatar,object("Humanoid","Humanoid"))
local avatarPart=attach(avatar,object("Part","Head"))
local terrain=Workspace.Terrain
local state={Alive=true}
local market=true
local changed={}
local queue={}
local task={
    spawn=function(fn)queue[#queue+1]=fn end,
    defer=function(fn)queue[#queue+1]=fn end,
    wait=function()end,
}
local function drain()
    local n=0
    while #queue>0 do
        n=n+1
        assert(n<30,"unbounded task queue")
        table.remove(queue,1)()
    end
end
local function change(bucket,obj,key,value)
    local current=obj[key]
    if current==value then return end
    local record=bucket[obj]
    if not record then record={};bucket[obj]=record end
    if record[key]==nil then record[key]=current end
    obj[key]=value
end
local function restore(bucket)
    for obj,values in pairs(bucket) do
        for key,value in pairs(values) do
            if obj.Parent then obj[key]=value end
        end
        bucket[obj]=nil
    end
end
local function disconnect(list)
    for _,conn in ipairs(list) do conn:Disconnect() end
    for i=#list,1,-1 do list[i]=nil end
end
local env={state=state,marketPlace=function()return market end,
    Workspace=Workspace,change=change,restore=restore,disconnect=disconnect,
    task=task}
setmetatable(env,{__index=_G})
local chunk,reason=load(block,"market_lite_actual","t",env)
assert(chunk,reason)
chunk()
local setMarketLite=assert(env.setMarketLite)
-- No visual changes outside Market.
market=false
setMarketLite(true)
drain()
assert(stallWall.LocalTransparencyModifier==0.22)
assert(state.MarketLite.Enabled==false)
market=true
setMarketLite(true)
drain()
assert(state.MarketLite.Enabled==true)
assert(stallWall.LocalTransparencyModifier==1 and roof.LocalTransparencyModifier==1)
assert(decorations.LocalTransparencyModifier==1 and tree.LocalTransparencyModifier==1)
for _,part in ipairs({road,platform,genericFloor,promptPart,sellerBoard,dynamicPart,npcPart,avatarPart}) do
    assert(part.LocalTransparencyModifier==0,"unexpectedly hidden: "..part.Name)
end
assert(state.MarketLite.Hidden>=4)
assert(stallWall.CanCollide==true and stallWall.CanTouch==true and stallWall.CanQuery==true)
-- Dynamic market additions: later shops/models and standalone parts.
local late=attach(Workspace,object("Model","ShopLate"))
local lateWall=attach(late,object("MeshPart","WallLate"))
Workspace.DescendantAdded:Emit(late)
drain()
assert(lateWall.LocalTransparencyModifier==1,"late model decoration must hide")
local lateSingle=attach(Workspace,object("Part","Pillar"))
Workspace.DescendantAdded:Emit(lateSingle)
assert(lateSingle.LocalTransparencyModifier==1)
local lateRoad=attach(Workspace,object("Part","FloorTile"))
Workspace.DescendantAdded:Emit(lateRoad)
assert(lateRoad.LocalTransparencyModifier==0,"late floors remain visible")
-- OFF restores original non-zero transparency values and disconnects watchers.
setMarketLite(false)
assert(not state.MarketLite.Enabled)
assert(stallWall.LocalTransparencyModifier==0.22)
assert(decorations.LocalTransparencyModifier==0.35)
assert(roof.LocalTransparencyModifier==0 and lateWall.LocalTransparencyModifier==0)
local afterOff=attach(Workspace,object("Part","PostOffDecoration"))
Workspace.DescendantAdded:Emit(afterOff)
assert(afterOff.LocalTransparencyModifier==0)
-- ON/OFF fast toggle must invalidate queued scans.
setMarketLite(true)
setMarketLite(false)
drain()
assert(stallWall.LocalTransparencyModifier==0.22)
assert(not state.MarketLite.Enabled)
setMarketLite(true)
drain()
assert(stallWall.LocalTransparencyModifier==1)
state.Alive=false
setMarketLite(false)
assert(stallWall.LocalTransparencyModifier==0.22)
print("PASS STALL MARKET LITE: static shops hidden, grounds/prompt/sign/player/NPC protected; restored; no physics")
