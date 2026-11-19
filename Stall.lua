-- IRON SOUL DUNGEON | STALL MARKET v5.0 | nine-column scanner + Ore listing UI + TP + reversible low-FX
-- Source evidence: BoothController:GetAllStalls(), BoothRE:RequestBoothShows,
-- BoothRE events BoothShows/BoothShowUpdate/StallView/StallRefresh.
-- SCAN/DEEP SCAN are read-only. Purchase occurs ONLY after explicit two-step
-- verification and confirmation, never automatically. No ListStack/Unlist.
-- Market/Booth place only. No AIO required. Do not run alongside other market scanners.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Input = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local GuiRoot = LocalPlayer:WaitForChild("PlayerGui")
local BoothSys = RS:WaitForChild("Framework", 10):WaitForChild("Features", 10):WaitForChild("BoothSystem", 10)
local BoothRE = BoothSys:WaitForChild("BoothRE", 10)
assert(BoothRE and BoothRE:IsA("RemoteEvent"), "BoothRE is unavailable")
local ControllerModule = BoothSys:WaitForChild("Client", 10):WaitForChild("BoothController", 10)
local okCtl, Controller = pcall(require, ControllerModule)
if not okCtl or type(Controller) ~= "table" then Controller = nil end
local Config = require(BoothSys:WaitForChild("BoothConfig", 10))
local marketCap = math.clamp(tonumber(Config.StallCount) or 40, 1, 100)
local Registry = nil
pcall(function() Registry = require(RS:WaitForChild("Configs", 5):WaitForChild("ResBoothTradeable", 5)) end)
local MarketUtil = nil
pcall(function() MarketUtil = require(RS:WaitForChild("Utility", 5):WaitForChild("GamePlaceUtil", 5)) end)
local function marketPlace()
    if MarketUtil and type(MarketUtil.IsBooth) == "function" then
        local ok, val = pcall(function() return MarketUtil:IsBooth() end)
        if ok then return val == true end
    end
    return false
end
local env = (type(getgenv) == "function" and getgenv()) or shared
if env.IronSoulMarketScanner and type(env.IronSoulMarketScanner.Stop) == "function" then
    pcall(env.IronSoulMarketScanner.Stop)
end
for _,oldName in ipairs({"IronSoulScrollMarketScannerV2",
    "IronSoulScrollMarketScannerV3", "IronSoulScrollMarketScannerV4", "IronSoulScrollMarketScannerV5"}) do
    local previousGui=GuiRoot:FindFirstChild(oldName)
    if previousGui then previousGui:Destroy() end
end
local state = {
    Alive = true, Busy = false, Cancel = false, Dirty = true,
    Stalls = {}, Full = {}, FullAt = {}, Conn = {}, LastRefresh = -1e6,
    PendingPurchase=nil, PurchaseBusy=false, PurchasesSent=0, Page=1, PageSize=20,
    LastRender=-100, MarkSlot=nil, TpLastDiagnostic="", TpSource={}, TpCoords={},
    ReqSlot = nil, ResponseSlot = nil, Responses = 0,
    Probed={}, ProbedCount=0, ProbedSuccess=0, AllScanCompleted=false,
    ExpectedProbes=0, EmptyCount=0, SnapshotReceived=false,
    Sort = "QUALITY", LastMessage = "", RefreshCount = 0,
}
env.IronSoulMarketScanner = state
-- Scroll-only: never display or purchase Ore, Potion, Crystals etc.
local ScrollDefinitions,ScrollUtil,TranslateUtil,WindowUtil
pcall(function() ScrollDefinitions=require(RS.Configs.ResScrolls) end)
pcall(function()
    local framework=require(RS.Framework)
    ScrollUtil=framework.Modules.ScrollUtil
    TranslateUtil=framework.Modules.TranslationUtil
    WindowUtil=framework.Modules.WindowUtil
end)
local function isNumber(n) return type(n) == "number" and n == n and math.abs(n) < 1e14 end
local function number(t, ...)
    if type(t) ~= "table" then return nil end
    for i=1, select("#", ...) do
        local v = t[select(i,...)]
        if isNumber(v) then return v end
    end
    return nil
end
local function str(t, ...)
    if type(t) ~= "table" then return nil end
    for i=1, select("#", ...) do
        local v = t[select(i,...)]
        if type(v)=="string" and v~="" then return v end
    end
    return nil
end
local index = {}
if type(Registry) == "table" then
    for _, key in ipairs(Registry.__index or {}) do
        local d = Registry[key]
        if type(d)=="table" and type(d.ItemType)=="string" and type(d.ItemID)=="string" then
            index[d.ItemType.."\0"..d.ItemID] = d
        end
    end
end
local function slot(k)
    local n = tonumber(k)
    if n and n == math.floor(n) and n >= 1 and n <= marketCap then return n end
    return nil
end
-- SCROLL_V3_CORE_BEGIN
-- Rarity 6 = Mythic for individual rolled items; do not infer rarity from
-- Scroll ID, registry official price or base ResScrolls template.
-- Four real attribute rolls are required, of which THREE DISTINCT categories
-- must be among Attack, Crit Rate, Crit Damage, Skill Damage, Skill CDR.
-- Dash CD / Move Speed / Skill Charge / Health are NOT qualifying categories.
local TARGET_BY_KEY={
    atkbonus="ATK",attackbonus="ATK",attackbonusrate="ATK",
    chrate="CR",critrate="CR",criticrate="CR",criticalrate="CR",
    criticalchance="CR",critichance="CR",critchance="CR",
    chdmgbonus="CD",critdmgbonus="CD",critdamage="CD",critdmg="CD",
    criticaldamage="CD",criticaldmg="CD",
    skilldmgbonus="SKILL",skilldamage="SKILL",skilldmg="SKILL",
    skilldamagebonus="SKILL",
    skillcdreduce="CDR",skillcdr="CDR",skillcooldownreduction="CDR",
    skillcooldownreduce="CDR",skillcdreduction="CDR",
}
local NAMES={
    atkbonus="Attack Bonus",attackbonus="Attack Bonus",attackbonusrate="Attack Bonus",
    chrate="Crit Rate",critrate="Crit Rate",criticrate="Crit Rate",
    criticalrate="Crit Rate",criticalchance="Crit Rate",critichance="Crit Rate",
    critchance="Crit Rate",
    chdmgbonus="Crit Damage",critdmgbonus="Crit Damage",critdamage="Crit Damage",
    critdmg="Crit Damage",criticaldamage="Crit Damage",criticaldmg="Crit Damage",
    skilldmgbonus="Skill Damage",skilldamage="Skill Damage",
    skilldmg="Skill Damage",skilldamagebonus="Skill Damage",
    skillcdreduce="Skill CDR",skillcdr="Skill CDR",
    skillcooldownreduction="Skill CDR",skillcooldownreduce="Skill CDR",
    skillcdreduction="Skill CDR",
    dashcdreduce="Dash CDR",dashcdreduction="Dash CDR",
    dashcooldownreduction="Dash CDR",dashcdr="Dash CDR",
    movespeedbonus="Move Speed",movespeed="Move Speed",
    movementspeed="Move Speed",movementspeedbonus="Move Speed",
    healthbonus="Health Bonus",hpbonus="Health Bonus",
    skillchargebonus="Skill Charge",ultimatecharge="Ultimate Charge",
    blockchance="Block Chance",
}
local TARGET_ORDER={ATK=1,CR=2,CD=3,SKILL=4,CDR=5}
local IGNORE_FIELDS={id=true,idx=true,index=true,rarity=true,grade=true,
    itemid=true,skillid=true,price=true,quantity=true,qty=true,
    count=true,level=true,lv=true,uuid=true,weight=true,sort=true,
    type=true,value=true,amount=true,val=true,number=true,
    stat=true,key=true,attribute=true,attrtype=true,stattype=true,
    statvalue=true,unit=true,valuetype=true}
local function lowerKey(key)
    return tostring(key):lower():gsub("[^a-z0-9]","")
end
local function niceNumber(n)
    local nearest=math.floor(n+.5)
    if math.abs(n-nearest)<.0000001 then return string.format("%.0f",nearest) end
    return string.format("%.2f",n)
end
local function labelOf(k)
    return NAMES[lowerKey(k)] or tostring(k):gsub("_"," ")
end
local function formatStat(k,num,unit)
    local n=tonumber(num)
    if not isNumber(n) or math.abs(n)>1e8 then return nil end
    local k0=lowerKey(k)
    local perc=not (unit=="flat" or unit=="count")
    if perc and n~=0 and math.abs(n)<1 then n=n*100 end
    return labelOf(k).." "..(n>=0 and "+" or "")..niceNumber(n)..(perc and "%" or "")
end
local function parseStats(raw)
    local entries,seen,foundKinds={}, {}, {}
    local source=nil
    for _,name in ipairs({"Attrs","Attributes","BonusAttrs","Stats","StatData",
        "AttributeData","ExtraAttrs","Options","Affixes","ScrollData"}) do
        if type(raw[name])=="table" then source=raw[name];break end
    end
    if not source then return {},{},0,"MISSING_ATTRS" end
    local visited={}
    local function add(key,value,unit)
        if (type(key)~="string" and type(key)~="number") then return end
        local tag=lowerKey(key)
        if IGNORE_FIELDS[tag] or seen[tag] then return end
        local formatted=formatStat(key,value,unit)
        if not formatted then return end
        seen[tag]=true
        local group=TARGET_BY_KEY[tag]
        entries[#entries+1]={Key=tostring(key),Text=formatted,Group=group}
        if group then foundKinds[group]=true end
    end
    local function walk(t,depth)
        if type(t)~="table" or depth>5 or visited[t] then return end
        visited[t]=true
        local key=t.Type or t.Stat or t.Key or t.Attribute or t.AttrType or t.StatType
        local value=t.Value
        if value==nil then value=t.Amount end
        if value==nil then value=t.Val end
        if value==nil then value=t.Number end
        if value==nil then value=t.StatValue end
        if key~=nil and value~=nil then add(key,value,t.Unit or t.ValueType) end
        for k,v in pairs(t) do
            if type(v)=="number" and type(k)=="string" then add(k,v)
            elseif type(v)=="table" then walk(v,depth+1) end
        end
    end
    walk(source,0)
    table.sort(entries,function(a,b)
        local wa=TARGET_ORDER[a.Group] or 99
        local wb=TARGET_ORDER[b.Group] or 99
        if wa~=wb then return wa<wb end
        return a.Key<b.Key
    end)
    local stats={}
    for _,e in ipairs(entries) do stats[#stats+1]=e.Text end
    local match=0
    for _ in pairs(foundKinds) do match=match+1 end
    return stats,foundKinds,match,"OK"
end
local function parseRarity(v)
    for _,key in ipairs({"Rarity","RarityID","RarityId","Grade","Quality"}) do
        local value=v[key]
        if type(value)=="number" and value%1==0 then return value end
        if type(value)=="string" then
            if value:lower()=="mythic" then return 6 end
            local num=tonumber(value)
            if num and num%1==0 then return num end
        end
    end
    return nil
end
local function getListingId(v, itemId)
    local id=str(v,"ListingId","ListingID","ListingUUID","ListingUid",
        "ListingUID","ListId","ListID","ListUUID","UUID","Uid","UID")
    if id and id~=itemId then return id,"explicit" end
    local raw=str(v,"Id","ID")
    if raw and raw~=itemId and #raw>=16 and #raw<=128 then
        return raw,"strong-id"
    end
    return nil,"missing"
end
local function scrollName(id,listing)
    local direct=str(listing,"DisplayName","ScrollName","Title","ItemTitle")
    if direct then return direct,nil end
    local def
    if type(ScrollDefinitions)=="table" then def=ScrollDefinitions[id] end
    if not def and type(ScrollUtil)=="table" and type(ScrollUtil.GetDef)=="function" then
        pcall(function()def=ScrollUtil:GetDef(id)end)
    end
    local skill=str(listing,"SkillName","SkillDisplayName","NewSkill","SkillId")
        or (type(def)=="table" and str(def,"SkillName","SkillId","SkillID") or nil)
    local declared=type(def)=="table" and str(def,"DisplayName","Name","Title") or nil
    local translation=nil
    if type(TranslateUtil)=="table" and type(TranslateUtil.TranslateByKey)=="function" then
        pcall(function() translation=TranslateUtil:TranslateByKey("K_"..id:upper()) end)
        if translation=="K_"..id:upper() or translation=="" then translation=nil end
    end
    -- Localized name may be an untranslated K_SCROLL_* key. Replace keys
    -- with readable weapon class + skill name, not raw resource identifiers.
    if declared and declared:match("^K_[A-Z0-9_]+$") then declared=nil end
    if translation and translation:match("^K_[A-Z0-9_]+$") then translation=nil end
    local class,level=id:match("^Scroll_([^_]+)_(%d+)$")
    local short=skill and skill:match("([^_]+)$")
    if short then short=short:gsub("(%l)(%u)","%1 %2") end
    local natural=(class and (class.." Scroll")) or id:gsub("_"," ")
    local name=declared or translation or
        (natural..(short and (": "..short) or (level and (" #"..level) or "")))
    return tostring(name):gsub("<[^>]+>",""),skill
end
local function normalizeListing(v,key,s,stall,detail)
    if type(v)~="table" then return nil end
    local typ=str(v,"ItemType","Type","Category")
    if typ~="Scroll" then return nil end
    local id=str(v,"ItemID","ItemId","ItemIDStr","ItemName")
    if not id and type(v.Id)=="string" and v.Id:sub(1,7)=="Scroll_" then id=v.Id end
    if not id then return nil end
    local price=number(v,"TotalPrice","ListingPrice","Price","SellPrice","Gold")
    local info=index["Scroll\0"..id]
    local listingId,idSource=getListingId(v,id)
    local name,skill=scrollName(id,v)
    local stats,groups,good,parseStatus=parseStats(v)
    local rarity=parseRarity(v)
    local reason=(rarity~=6 and "NOT_MYTHIC" or
        #stats~=4 and "NOT_4_ATTRS" or
        good<3 and "LESS_THAN_3_DPS_CATEGORIES" or "PASS")
    local distinct={}
    for _,k in ipairs({"ATK","CR","CD","SKILL","CDR"}) do
        if groups[k] then distinct[#distinct+1]=k end
    end
    return {
        Slot=s,Type="Scroll",Id=id,Name=name,Skill=skill,Stats=stats,
        StatCount=#stats,Rarity=rarity,Matched=good,MatchedList=table.concat(distinct,"+"),
        Pass=reason=="PASS",Reject=reason,ParseStatus=parseStatus,
        Count=number(v,"Quantity","Qty","Count","Amount"),
        Price=price,Unit=number(v,"UnitPrice","PricePerItem") or price,
        Ref=info and number(info,"OfficialPrice") or nil,
        Min=info and number(info,"MinPrice") or nil,
        Max=info and number(info,"MaxPrice") or nil,
        Owner=str(stall,"OwnerName","Username","UserName") or "?",
        OwnerUserId=number(stall,"OwnerUserId"),
        ListingId=listingId,IdSource=idSource,Detail=detail==true,
        Raw=v,RawKey=tostring(key),
    }
end
local function extractItems(stall,s,detail)
    local rows={}
    if type(stall)~="table" or type(stall.Items)~="table" then return rows end
    local seen={}
    for key,v in pairs(stall.Items) do
        local row=normalizeListing(v,key,s,stall,detail)
        if row then
            local unique=row.ListingId or (row.Id..":"..tostring(key))
            if not seen[unique] then seen[unique]=true;rows[#rows+1]=row end
        end
    end
    return rows
end
local function fingerprint(r)
    return table.concat({tostring(r.Slot),tostring(r.OwnerUserId or r.Owner),
        tostring(r.Id),tostring(r.ListingId),tostring(r.Price),
        tostring(r.Rarity),tostring(r.StatCount),tostring(r.MatchedList),
        table.concat(r.Stats,";")},"|")
end
-- SCROLL_V3_CORE_END
local function absorb(slotIndex, data, detail)
    local s=slot(slotIndex)
    if s == nil or type(data)~="table" then return false end
    state.Stalls[s]=data
    if detail then state.Full[s]=data;state.FullAt[s]=os.clock() end
    state.Dirty=true
    return true
end
local function occupiedStall(t)
    if type(t)~="table" or t.Empty==true or t.IsEmpty==true then return false end
    local uid=number(t,"OwnerUserId","OwnerId","UserId")
    local owner=str(t,"OwnerName","Username","UserName")
    if owner and (owner:lower():match("^%s*empty%s*$")
        or owner:lower():match("^%s*vacant%s*$")) then owner=nil end
    return (uid~=nil and uid>0) or owner~=nil
end
local function countOccupied()
    local n=0
    for _,st in pairs(state.Stalls) do if occupiedStall(st) then n=n+1 end end
    return n
end
local function scanCurrentCache()
    if not Controller or type(Controller.GetAllStalls)~="function" then return 0 end
    local ok, cache = pcall(function() return Controller:GetAllStalls() end)
    if not ok or type(cache)~="table" then return 0 end
    local count=0
    for key,data in pairs(cache) do
        if occupiedStall(data) and absorb(key,data,false) then count=count+1 end
    end
    return count
end
local function handleEvent(action,payload)
    if not state.Alive then return end
    if action=="BoothShows" and type(payload)=="table" then
        -- Native client replaces the entire snapshot, rather than merging it.
        local copy={}
        for k,d in pairs(payload) do
            local s=slot(k)
            if s~=nil and occupiedStall(d) then copy[s]=d end
        end
        state.Stalls=copy
        state.SnapshotReceived=true
        state.EmptyCount=math.max(0,marketCap-countOccupied())
        for key,old in pairs(state.Full) do
            local updated=copy[key]
            if not updated or (old.OwnerUserId and updated.OwnerUserId
                and old.OwnerUserId~=updated.OwnerUserId) then
                state.Full[key]=nil;state.FullAt[key]=nil
            end
        end
        state.RefreshCount=state.RefreshCount+1
        state.Dirty=true
    elseif action=="BoothShowUpdate" and type(payload)=="table" then
        local s=slot(payload.SlotIndex)
        if s~=nil then
            state.Stalls[s]=occupiedStall(payload.Stall) and payload.Stall or nil
            if state.SnapshotReceived then state.EmptyCount=math.max(0,marketCap-countOccupied()) end
            state.Full[s]=nil;state.FullAt[s]=nil -- stall changed; previous deep details may be stale
            state.PendingPurchase=nil
            state.Dirty=true
        end
    elseif action=="StallView" and type(payload)=="table" then
        local s=slot(payload.SlotIndex)
        if s~=nil and type(payload.Stall)=="table" then
            absorb(s,payload.Stall,true)
            state.ResponseSlot=s
            state.Responses=state.Responses+1
            if state.Probed[s] then state.Probed[s].Status="RESPONSE" end
            -- Native BoothController opens its full purchase UI after every
            -- StallView, including DEEP scans. Close *only while scanning*;
            -- keep it available when user TP's to check a price manually.
            if state.Busy and WindowUtil and type(WindowUtil.Close)=="function" then
                task.defer(function()
                    if state.Alive and state.Busy then
                        pcall(function()WindowUtil:Close("ScreenBoothRoot")end)
                    end
                end)
            end
        end
    elseif action=="StallRefresh" and type(payload)=="table" then
        local uid=number(payload,"OwnerUserId")
        if uid then
            for s,known in pairs(state.Stalls) do
                if number(known,"OwnerUserId")==uid then
                    absorb(s,payload,true)
                    break
                end
            end
        end
    end
end
state.Conn[#state.Conn+1]=BoothRE.OnClientEvent:Connect(handleEvent)
local oldSnapshot=scanCurrentCache()
local Color={BG=Color3.fromRGB(17,23,35),Panel=Color3.fromRGB(29,38,55),
    Field=Color3.fromRGB(41,53,72),Green=Color3.fromRGB(28,117,87),
    Blue=Color3.fromRGB(51,82,127),Red=Color3.fromRGB(137,63,67),
    Text=Color3.fromRGB(235,241,251),Mute=Color3.fromRGB(174,191,217)}
-- SCROLL_V4_PERF_BEGIN: reversible client-side optimizations only.
-- Keep booth surfaces, signs, UI and price boards visible. Do not modify
-- Marketplace inventory, other clients, or any server state.
local perf={LowFX=false,HidePlayers=false,Changes=setmetatable({},{__mode="k"}),
    PlayerChanges=setmetatable({},{__mode="k"}),Conns={},PlayerConns={},SeenPlayers={}}
local fxClasses={ParticleEmitter=true,Trail=true,Beam=true,Fire=true,
    Smoke=true,Sparkles=true,PointLight=true,SpotLight=true,SurfaceLight=true,
    BloomEffect=true,SunRaysEffect=true,DepthOfFieldEffect=true,BlurEffect=true,
    ColorCorrectionEffect=true,Atmosphere=false}
local function change(bucket,obj,key,value)
    if not obj then return end
    local ok,current=pcall(function()return obj[key]end)
    if not ok or current==value then return end
    local record=bucket[obj]
    if not record then record={};bucket[obj]=record end
    if record[key]==nil then record[key]=current end
    pcall(function()obj[key]=value end)
end
local function restore(bucket)
    for obj,values in pairs(bucket) do
        for k,v in pairs(values) do
            pcall(function()if obj and obj.Parent then obj[k]=v end end)
        end
        bucket[obj]=nil
    end
end
local function disconnect(list)
    for _,conn in ipairs(list) do pcall(function()conn:Disconnect()end) end
    table.clear(list)
end
local function applyFX(obj)
    if perf.LowFX and fxClasses[obj.ClassName] then
        change(perf.Changes,obj,"Enabled",false)
    end
end
local function setLowFX(enabled)
    if perf.LowFX==enabled then return end
    perf.LowFX=enabled
    disconnect(perf.Conns)
    if not enabled then restore(perf.Changes);return end
    change(perf.Changes,Lighting,"GlobalShadows",false)
    perf.Conns[#perf.Conns+1]=Workspace.DescendantAdded:Connect(applyFX)
    perf.Conns[#perf.Conns+1]=Lighting.DescendantAdded:Connect(applyFX)
    task.spawn(function()
        for _,container in ipairs({Workspace,Lighting}) do
            local objects=container:GetDescendants()
            for i,obj in ipairs(objects) do
                if not state.Alive or not perf.LowFX then return end
                applyFX(obj)
                if i%160==0 then task.wait() end
            end
        end
    end)
end
local function hidePart(obj)
    if perf.HidePlayers and obj:IsA("BasePart") then
        change(perf.PlayerChanges,obj,"LocalTransparencyModifier",1)
    end
end
local function watchCharacter(character)
    if not character or not perf.HidePlayers then return end
    for _,obj in ipairs(character:GetDescendants()) do hidePart(obj) end
    perf.PlayerConns[#perf.PlayerConns+1]=character.DescendantAdded:Connect(hidePart)
end
local function watchPlayer(player)
    if not perf.HidePlayers or player==LocalPlayer or perf.SeenPlayers[player] then return end
    perf.SeenPlayers[player]=true
    perf.PlayerConns[#perf.PlayerConns+1]=player.CharacterAdded:Connect(function(char)
        task.defer(watchCharacter,char)
    end)
    if player.Character then task.defer(watchCharacter,player.Character) end
end
local function setHidePlayers(enabled)
    if perf.HidePlayers==enabled then return end
    perf.HidePlayers=enabled
    disconnect(perf.PlayerConns)
    perf.SeenPlayers={}
    if not enabled then restore(perf.PlayerChanges);return end
    perf.PlayerConns[#perf.PlayerConns+1]=Players.PlayerAdded:Connect(watchPlayer)
    for _,p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
end
-- SCROLL_V4_PERF_END

-- SCROLL_V4_TP_BEGIN: resolve real in-world stall; fail closed when ambiguous.
-- BoothController exposes indices and seller data but NOT world coordinates.
-- Strong candidates must have a matching SlotIndex attribute or a slot-like
-- object name. No invented 40-position grid and no hardcoded XYZ guesses.
local TP_FILE="IronSoul_ScrollMarketTP_"..tostring(game.PlaceId)..".json"
local function validPos(v)
    return type(v)=="table" and isNumber(v.x) and isNumber(v.y)
        and isNumber(v.z) and math.abs(v.x)<100000 and math.abs(v.y)<100000
        and math.abs(v.z)<100000
end
local function loadTPs()
    if type(readfile)~="function" then return end
    local ok,value=pcall(function()return HttpService:JSONDecode(readfile(TP_FILE))end)
    if not ok or type(value)~="table" or value.PlaceId~=game.PlaceId then return end
    if type(value.Slots)=="table" then
        for k,p in pairs(value.Slots) do
            local id=slot(k)
            if id and validPos(p) then state.TpCoords[id]=p end
        end
    end
end
local function saveTPs()
    if type(writefile)~="function" then return false end
    local slots={}
    for k,v in pairs(state.TpCoords) do
        if validPos(v) then slots[tostring(k)]=v end
    end
    return pcall(function()
        writefile(TP_FILE,HttpService:JSONEncode({PlaceId=game.PlaceId,Slots=slots}))
    end)
end
loadTPs()
local function getAnchor(o)
    if o:IsA("BasePart") then return o.CFrame,o end
    if not o:IsA("Model") then return nil end
    local part=o.PrimaryPart
    if not part then
        for _,name in ipairs({"StallBase","BoothBase","InteractPart","Counter",
            "Floor","Base","Platform","Stand","Main"}) do
            local found=o:FindFirstChild(name,true)
            if found and found:IsA("BasePart") then part=found;break end
        end
    end
    if part then return part.CFrame,o end
    local ok,cf=pcall(function()return o:GetPivot()end)
    if ok then return cf,o end
    return nil
end
local function directSlotId(inst)
    local props={"SlotIndex","StallIndex","BoothIndex","StallId",
        "BoothId","SlotId","StallSlot","BoothSlot"}
    for _,field in ipairs(props) do
        local ok,val=pcall(function()return inst:GetAttribute(field)end)
        if ok and val~=nil then
            local id=slot(val)
            if id then return id,"attribute:"..field,150 end
        end
    end
    local name=inst.Name:lower():gsub("%s+","")
    local id=name:match("^stall[_%-]?(%d+)$")
        or name:match("^booth[_%-]?(%d+)$")
        or name:match("^stallslot[_%-]?(%d+)$")
        or name:match("^boothslot[_%-]?(%d+)$")
        or name:match("^marketstall[_%-]?(%d+)$")
        or name:match("^boothpoint[_%-]?(%d+)$")
        or name:match("^stallpoint[_%-]?(%d+)$")
    if id and slot(id) then return tonumber(id),"name:"..inst.Name,90 end
    return nil
end
local function findStallAnchor(slotId,owner)
    local candidates={}
    local parts=Workspace:GetDescendants()
    local trace={}
    local seen={}
    for _,obj in ipairs(parts) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local id,why,score=directSlotId(obj)
            if id==slotId then
                local cf,parent=getAnchor(obj)
                if cf and parent then
                    local key=tostring(cf.Position)
                    if not seen[key] then
                        seen[key]=true
                        candidates[#candidates+1]={CF=cf,Part=parent,
                            Why=why,Score=score+(obj:IsA("Model") and 5 or 0)}
                    end
                end
            end
        end
        if #trace<30 then
            local nm=obj.Name:lower()
            if nm:find("stall",1,true) or nm:find("booth",1,true) then
                trace[#trace+1]=obj:GetFullName()
            end
        end
    end
    -- Fallback to a physical booth's SurfaceGui/BillboardGui seller text,
    -- not a Player character nameplate or arbitrary ScreenGui text.
    if #candidates==0 and type(owner)=="string" and owner~="?" then
        for _,obj in ipairs(parts) do
            if obj:IsA("TextLabel") and obj.Text==owner then
                local parent=obj.Parent
                local gui=parent
                while gui and not gui:IsA("SurfaceGui") and not gui:IsA("BillboardGui") do
                    gui=gui.Parent
                end
                if gui then
                    local anchor=gui.Adornee
                    if not anchor then
                        anchor=gui.Parent
                        while anchor and not anchor:IsA("BasePart") do anchor=anchor.Parent end
                    end
                    local context=gui
                    local reasonable=false
                    for _=1,5 do
                        if not context then break end
                        local n=context.Name:lower()
                        if n:find("booth",1,true) or n:find("stall",1,true) then
                            reasonable=true;break
                        end
                        context=context.Parent
                    end
                    if reasonable and anchor and anchor:IsA("BasePart") then
                        candidates[#candidates+1]={CF=anchor.CFrame,Part=anchor,
                            Why="world-seller-label",Score=45}
                    end
                end
            end
        end
    end
    table.sort(candidates,function(a,b)return a.Score>b.Score end)
    local first=candidates[1]
    state.TpLastDiagnostic="slot="..slotId.." candidate_count="..#candidates
        .." paths="..table.concat(trace," | ")
    if not first then return nil,"NOT_FOUND" end
    for i=2,#candidates do
        local c=candidates[i]
        if c.Score>=first.Score and (c.CF.Position-first.CF.Position).Magnitude>14 then
            return nil,"AMBIGUOUS_LOCATIONS"
        end
    end
    return first,nil
end
local function safeLanding(booth,character)
    local cf=booth.CF
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    local exclude={character}
    if booth.Part then exclude[#exclude+1]=booth.Part end
    params.FilterDescendantsInstances=exclude
    local offsets={-cf.LookVector*6,cf.LookVector*6,
        cf.RightVector*6,-cf.RightVector*6}
    for _,delta in ipairs(offsets) do
        local test=cf.Position+delta
        local result=Workspace:Raycast(test+Vector3.new(0,13,0),
            Vector3.new(0,-50,0),params)
        if result and result.Normal.Y>.76 and
            math.abs(result.Position.Y-cf.Position.Y)<20 then
            local pos=Vector3.new(test.X,result.Position.Y+3.5,test.Z)
            return pos
        end
    end
    return nil
end
local function teleportToStall(r)
    if not state.Alive or not marketPlace() then say("TP chỉ hoạt động tại Market Place.");return end
    state.MarkSlot=r.Slot
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health<=0 then say("Chưa có nhân vật để TP.");return end
    local pos,source,lookAt
    local saved=state.TpCoords[r.Slot]
    if validPos(saved) then
        pos=Vector3.new(saved.x,saved.y,saved.z)
        source="CALIBRATED"
    else
        local booth,why=findStallAnchor(r.Slot,r.Owner)
        if not booth then
            say("Chưa xác định tọa độ Stall #"..r.Slot.." ("..why
                .."). Đến quầy bằng tay rồi bấm GHI TP #"..r.Slot.."; COPY REPORT có TP DIAG.")
            return
        end
        pos=safeLanding(booth,char)
        source=booth.Why
        if not pos then
            say("Tìm thấy Stall #"..r.Slot.." nhưng chưa xác định được nền an toàn."
                .." Đến bằng tay, bấm GHI TP #"..r.Slot..".")
            return
        end
        lookAt=booth.CF.Position
    end
    -- Keep the player upright and face the booth horizontally.
    local target
    if lookAt and (Vector3.new(lookAt.X,pos.Y,lookAt.Z)-pos).Magnitude>.5 then
        target=CFrame.lookAt(pos,Vector3.new(lookAt.X,pos.Y,lookAt.Z))
    else
        local d=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
        target=CFrame.lookAt(pos,pos+(d.Magnitude>.01 and d.Unit or Vector3.new(0,0,-1)))
    end
    char:PivotTo(target)
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    state.TpSource[r.Slot]=source
    say("Đã TP đến Stall #"..r.Slot.." ("..r.Owner..") bằng "..source
        ..". Có thể mở quầy để kiểm tra giá trước khi mua.")
end
-- SCROLL_V4_TP_END

local gui=Instance.new("ScreenGui")
gui.Name="IronSoulScrollMarketScannerV5"
gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true
-- Above native Stall popup so scanning/buy confirmation remains accessible.
gui.DisplayOrder=100006;gui.Parent=GuiRoot
local panel=Instance.new("Frame",gui)
panel.BackgroundColor3=Color.BG
panel.Size=UDim2.new(.96,0,.92,0)
panel.Position=UDim2.new(.02,0,.04,0)
panel.BorderSizePixel=0
local minSize=Instance.new("UISizeConstraint",panel)
minSize.MinSize=Vector2.new(780,375)
local function label(parent,text,x,y,w,h,size,bold,wrap)
    local t=Instance.new("TextLabel",parent)
    t.BackgroundTransparency=1;t.Text=tostring(text or "")
    t.TextColor3=Color.Text;t.TextSize=size or 14
    t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.TextYAlignment=Enum.TextYAlignment.Center
    t.TextWrapped=wrap==true
    if not wrap then t.TextTruncate=Enum.TextTruncate.AtEnd end
    t.Position=UDim2.new(x,0,y,0);t.Size=UDim2.new(w,0,h,0)
    return t
end
local function button(parent,txt,x,y,w,h,cb,tint)
    local b=Instance.new("TextButton",parent)
    b.Text=txt;b.Font=Enum.Font.GothamBold;b.TextSize=12
    b.TextColor3=Color.Text;b.BackgroundColor3=tint or Color.Blue
    b.Position=UDim2.new(x,0,y,0);b.Size=UDim2.new(w,0,h,0)
    b.MouseButton1Click:Connect(cb)
    return b
end
local function field(parent,placeholder,x,y,w,h,default)
    local b=Instance.new("TextBox",parent)
    b.ClearTextOnFocus=false;b.Text=default or ""
    b.PlaceholderText=placeholder;b.Font=Enum.Font.Gotham
    b.TextColor3=Color.Text;b.BackgroundColor3=Color.Field
    b.TextSize=14;b.Position=UDim2.new(x,0,y,0);b.Size=UDim2.new(w,0,h,0)
    return b
end
local status=label(panel,"SCAN → DEEP QUẦY CÓ NGƯỜI | chỉ Mythic đủ 4 dòng, ≥3 chỉ số DPS.",.014,.151,.97,.048,12)
status.TextColor3=Color.Mute
local stats=label(panel,"",.014,.208,.97,.035,12,true)
local function say(message)
    state.LastMessage=tostring(message)
    if state.Alive and status.Parent then status.Text=state.LastMessage end
    print("[SCROLL_MARKET] "..state.LastMessage)
end
local function fmt(n)
    if not isNumber(n) then return "?" end
    return niceNumber(n)
end
local function allRows()
    local rows={}
    local allSlots={}
    for s in pairs(state.Stalls) do allSlots[s]=true end
    for s in pairs(state.Full) do allSlots[s]=true end
    for s in pairs(allSlots) do
        local byId={}
        local summary=state.Stalls[s]
        local full=state.Full[s]
        if summary and full and summary.OwnerUserId and full.OwnerUserId
            and summary.OwnerUserId~=full.OwnerUserId then full=nil end
        -- Merge summary and detail by UUID. Neither a partial StallView nor
        -- an old cached summary should silently erase unique scroll listings.
        if summary then
            for _,r in ipairs(extractItems(summary,s,false)) do
                byId[r.ListingId or (r.Id..":"..r.RawKey)]=r
            end
        end
        if full then
            for _,r in ipairs(extractItems(full,s,true)) do
                byId[r.ListingId or (r.Id..":"..r.RawKey)]=r
            end
        end
        for _,r in pairs(byId) do rows[#rows+1]=r end
    end
    return rows
end
local function matchingDetail(original)
    local last=state.Full[original.Slot]
    if type(last)~="table" then return nil end
    for _,r in ipairs(extractItems(last,original.Slot,true)) do
        if fingerprint(r)==fingerprint(original) then return r end
    end
    return nil
end
local search=field(panel,"Tên Scroll / Skill / chỉ số / người bán",.014,.092,.37,.050,"")
local minPrice=field(panel,"Min $",.392,.092,.14,.050,"")
local maxPrice=field(panel,"Max $",.541,.092,.14,.050,"")
label(panel,"STALL MARKET v5 | SCAN / MUA / BÁN ORE",.014,.018,.72,.058,15,true)
button(panel,"H ẨN",.730,.017,.126,.055,function()panel.Visible=false end)
button(panel,"X",.864,.017,.122,.055,function() state.Stop() end,Color.Red)
local list=Instance.new("ScrollingFrame",panel)
list.Name="ScrollListings";list.Position=UDim2.new(.012,0,.293,0)
list.Size=UDim2.new(.975,0,.598,0)
list.BorderSizePixel=0;list.BackgroundColor3=Color.Panel
list.ScrollBarThickness=8;list.ScrollingDirection=Enum.ScrollingDirection.XY
list.CanvasSize=UDim2.fromOffset(0,0)
local layout=Instance.new("UIListLayout",list)
layout.SortOrder=Enum.SortOrder.LayoutOrder
layout.Padding=UDim.new(0,3)
local function clearRows()
    for _,c in ipairs(list:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end
local function getFiltered()
    local all=allRows()
    local q=search.Text:lower()
    local mn=tonumber(minPrice.Text)
    local mx=tonumber(maxPrice.Text)
    local result={}
    for _,r in ipairs(all) do
        local joined=(r.Name.." "..r.Id.." "..r.Owner.." "..
            table.concat(r.Stats," ")):lower()
        if r.Pass and (q=="" or joined:find(q,1,true)) and
            (not mn or r.Price and r.Price>=mn) and
            (not mx or r.Price and r.Price<=mx) then
            result[#result+1]=r
        end
    end
    table.sort(result,function(a,b)
        if state.Sort=="QUALITY" and a.Matched~=b.Matched then
            return a.Matched>b.Matched
        end
        local va=state.Sort=="REFERENCE" and a.Ref and a.Ref>0 and a.Price and a.Price/a.Ref
            or state.Sort=="NAME" and a.Name or a.Price
        local vb=state.Sort=="REFERENCE" and b.Ref and b.Ref>0 and b.Price and b.Price/b.Ref
            or state.Sort=="NAME" and b.Name or b.Price
        if va~=nil and vb==nil then return true end
        if va==nil and vb~=nil then return false end
        if va~=vb then return (va or 1e18)<(vb or 1e18) end
        return a.Slot<b.Slot
    end)
    return all,result
end
local function requestShows()
    if not marketPlace() then say("Chỉ dùng được trong Market Place.");return false end
    if os.clock()-state.LastRefresh<2 then
        say("SCAN yêu cầu giãn ít nhất 2 giây; thử lại sau.")
        return false
    end
    state.LastRefresh=os.clock()
    local ok,err=pcall(function() BoothRE:FireServer("RequestBoothShows") end)
    if not ok then say("Lỗi RequestBoothShows: "..tostring(err));return false end
    scanCurrentCache()
    say("Đã yêu cầu danh sách quầy. Chờ BoothShows trả về.")
    return true
end
local function deepScan()
    if state.Busy or state.PurchaseBusy or state.PendingPurchase then
        say("Đang có lượt quét/mua. STOP hoặc hoàn tất trước.")
        return
    end
    if not marketPlace() then say("Chỉ dùng trong Market Place.");return end
    state.Busy=true;state.Cancel=false
    state.Probed={};state.ProbedCount=0;state.ProbedSuccess=0
    state.AllScanCompleted=false;state.ExpectedProbes=0
    task.spawn(function()
        -- Ask native server for its occupied-slot snapshot. Empty slots MUST
        -- NOT be InteractStall'd: no owner => no inventory to inspect.
        local previous=state.RefreshCount
        local sent=requestShows()
        if not sent and state.Alive and not state.Cancel then
            while state.Alive and not state.Cancel and
                os.clock()-state.LastRefresh<2.05 do task.wait(.1) end
            if state.Alive and not state.Cancel then sent=requestShows() end
        end
        if sent then
            local t0=os.clock()
            while state.Alive and not state.Cancel and state.RefreshCount==previous
                and os.clock()-t0<3 do task.wait(.1) end
        end
        if state.Cancel or not state.Alive then state.Busy=false;return end
        if not state.SnapshotReceived then scanCurrentCache() end
        local ids={}
        for id,stall in pairs(state.Stalls) do
            if occupiedStall(stall) then ids[#ids+1]=id end
        end
        table.sort(ids)
        state.ExpectedProbes=#ids
        state.EmptyCount=state.SnapshotReceived and math.max(0,marketCap-#ids) or 0
        if #ids==0 and not state.SnapshotReceived then
            state.Busy=false
            say("Chưa có BoothShows trả về: chưa kết luận 40 stall đều Empty. Bấm SCAN lại.")
            return
        end
        local got=0
        for i,id in ipairs(ids) do
            if not state.Alive or state.Cancel then break end
            -- If a slot becomes empty while we are scanning, mark it Empty
            -- rather than claiming the server timed out.
            if not occupiedStall(state.Stalls[id]) then
                state.Probed[id]={Status="EMPTY_DURING_SCAN"}
            else
                state.ReqSlot=id;state.ResponseSlot=nil
                state.Probed[id]={Status="SENT",Known=true}
                local sentOK,err=pcall(function() BoothRE:FireServer("InteractStall",id) end)
                if not sentOK then
                    state.Probed[id].Status="SEND_ERROR"
                    say("Lỗi InteractStall #"..id..": "..tostring(err))
                else
                    local t0=os.clock()
                    while state.Alive and not state.Cancel and os.clock()-t0<3 do
                        if state.ResponseSlot==id then break end
                        task.wait(.1)
                    end
                    if state.ResponseSlot==id then
                        got=got+1
                        state.ProbedSuccess=state.ProbedSuccess+1
                        state.Probed[id].Status="RESPONSE"
                    else
                        state.Probed[id].Status="NO_RESPONSE_NOT_EMPTY"
                    end
                end
                state.ProbedCount=state.ProbedCount+1
            end
            state.Dirty=true
            say("DEEP OCCUPIED "..i.."/"..#ids.." | detail "..got
                .." | Stall #"..id.." "..state.Probed[id].Status)
            if i<#ids and state.Alive and not state.Cancel then task.wait(.7) end
        end
        state.ReqSlot=nil;state.Busy=false
        state.AllScanCompleted=not state.Cancel and state.ProbedCount==#ids
        say("Đã kiểm tra "..state.ProbedCount.."/"..#ids.." quầy có người"
            .." | nhận chi tiết "..got.." | Empty "
            ..(state.SnapshotReceived and tostring(state.EmptyCount) or "chưa rõ")
            ..". COPY REPORT để xem quầy bị timeout.")
        state.Cancel=false;state.Dirty=true
    end)
end

local function purchaseClick(r)
    if not state.Alive then return end
    if not r.Pass or r.Rarity~=6 or r.StatCount~=4 or r.Matched<3 then
        say("KHÔNG MUA: phải là Mythic R6 / đúng 4 dòng / >=3 nhóm DPS.")
        return
    end
    if state.Busy or state.PurchaseBusy then
        say("Đang quét hoặc kiểm tra mua; đợi hoàn tất.")
        return
    end
    if not marketPlace() then say("MUA chỉ dùng tại Market Place.");return end
    if not r.ListingId then
        say("Scroll chưa có ListingId xác thực. COPY REPORT gửi em raw keys; KHÔNG mua nhầm bằng ItemID.")
        return
    end
    if not r.Price or r.Price<=0 or not r.OwnerUserId then
        say("Không đủ Price/OwnerUserId để xác minh chính xác listing. Chưa mua.")
        return
    end
    local pending=state.PendingPurchase
    local now=os.clock()
    if pending and pending.Ready and pending.Expires>now and
        pending.Fingerprint==fingerprint(r) then
        local live=matchingDetail(r)
        if not live or not live.Pass or not live.ListingId
            or live.Price~=r.Price or live.Rarity~=6
            or live.StatCount~=4 or live.Matched<3 then
            state.PendingPurchase=nil
            say("Listing thay đổi hoặc đã bán; MUA bị hủy, hãy scan lại.")
            state.Dirty=true
            return
        end
        state.PendingPurchase=nil
        state.PurchaseBusy=true
        local ok,err=pcall(function()
            -- Confirmed source protocol: BoothController.RequestPurchase(slotIndex, listingId)
            BoothRE:FireServer("Purchase",r.Slot,r.ListingId)
        end)
        if ok then
            state.PurchasesSent=state.PurchasesSent+1
            say("Đã GỬI yêu cầu Purchase cho "..r.Name.." tại quầy #"..r.Slot..
                " giá "..fmt(r.Price).."$. Kiểm tra game xác nhận thành công; không tự thử lại.")
            state.Full[r.Slot]=nil;state.FullAt[r.Slot]=nil
        else
            say("Purchase FireServer lỗi: "..tostring(err).."; không thử lại.")
        end
        state.Dirty=true
        task.delay(1.2,function()state.PurchaseBusy=false end)
        return
    end
    if pending then
        state.PendingPurchase=nil
        say("Đã hủy yêu cầu mua cũ. Bấm MUA lần nữa để bắt đầu kiểm tra listing mới.")
        state.Dirty=true
        return
    end
    local selected=fingerprint(r)
    local req={Fingerprint=selected,Slot=r.Slot,Ready=false,Expires=now+8}
    state.PendingPurchase=req;state.PurchaseBusy=true;state.Dirty=true
    say("Đang đọc lại quầy #"..r.Slot.." để xác minh giá/ID Scroll trước khi mua...")
    task.spawn(function()
        local mark=os.clock()
        local ok,err=pcall(function()BoothRE:FireServer("InteractStall",r.Slot)end)
        if not ok then
            state.PendingPurchase=nil
            say("Không mở lại được quầy: "..tostring(err))
        else
            local verified=nil
            local deadline=os.clock()+3
            while state.Alive and state.PendingPurchase==req and os.clock()<deadline do
                if (state.FullAt[r.Slot] or 0)>=mark then
                    verified=matchingDetail(r)
                    break
                end
                task.wait(.08)
            end
            if state.PendingPurchase==req then
                if verified and verified.Detail and verified.Pass and
                    verified.Rarity==6 and verified.StatCount==4 and
                    verified.Matched>=3 and verified.OwnerUserId==r.OwnerUserId then
                    req.Ready=true;req.Expires=os.clock()+8
                    say("ĐÃ XÁC MINH: "..r.Name.." | "..fmt(r.Price).."$ | "..r.Owner..
                        ". Bấm XÁC NHẬN MUA trong 8 giây để gửi Purchase.")
                else
                    state.PendingPurchase=nil
                    say("Không xác minh được đúng Scroll/giá/mã listing. Không gửi Purchase.")
                end
            end
        end
        state.PurchaseBusy=false;state.Dirty=true
    end)
end
local function report()
    local all=allRows()
    table.sort(all,function(a,b)
        if a.Slot~=b.Slot then return a.Slot<b.Slot end
        if a.Id~=b.Id then return a.Id<b.Id end
        return tostring(a.ListingId)<tostring(b.ListingId)
    end)
    local accepted,mythic,four,good3=0,0,0,0
    local occupied={}
    for _,r in ipairs(all) do
        occupied[r.Slot]=true
        if r.Rarity==6 then mythic=mythic+1 end
        if r.StatCount==4 then four=four+1 end
        if r.Matched>=3 then good3=good3+1 end
        if r.Pass then accepted=accepted+1 end
    end
    local known=countOccupied()
    local lines={"SCROLL MARKET SCANNER v4.0 (MYTHIC 4 ATTRS; >=3 OF ATK,CR,CD,SKILL,CDR)",
        "PLACE="..tostring(game.PlaceId).." STALL_CAP="..marketCap..
            " BOOTH_SHOWS="..known.." SLOTS_WITH_SCROLL="..(function()
                local c=0;for _ in pairs(occupied) do c=c+1 end;return c end)(),
        "FOUND_SCROLLS="..#all.." MYTHIC_R6="..mythic.." FOUR_ATTRS="..four..
            " THREE_GOOD="..good3.." QUALIFIED="..accepted..
            " PURCHASE_REQUESTS_SENT="..state.PurchasesSent,
        "DEEP_OCCUPIED_PROBED="..state.ProbedCount.."/"..state.ExpectedProbes..
            " DETAIL_RECEIVED="..state.ProbedSuccess..
            " SCAN_COMPLETE="..tostring(state.AllScanCompleted)..
            " EMPTY="..(state.SnapshotReceived and tostring(state.EmptyCount) or "UNVERIFIED")..
            " BOOTH_SHOWS_REPLIES="..state.RefreshCount,
        "Note: Empty = no owner in latest BoothShows; timeout is NOT Empty.",
        "TP_DIAG="..tostring(state.TpLastDiagnostic),
        "Slot | Seller | ItemId | Rarity | Lines | Good/5 | Groups | Attrs | Price | ListingUUID | Filter | Detail"}
    for _,r in ipairs(all) do
        lines[#lines+1]=table.concat({tostring(r.Slot),r.Owner,r.Id,
            tostring(r.Rarity or "UNKNOWN"),tostring(r.StatCount),
            tostring(r.Matched),r.MatchedList~="" and r.MatchedList or "NONE",
            #r.Stats>0 and table.concat(r.Stats," ; ") or "ATTRIBUTES_UNAVAILABLE",
            fmt(r.Price),tostring(r.ListingId or "MISSING"),r.Reject,
            tostring(r.Detail)}," | ")
        if r.Rarity==nil or r.StatCount==0 then
            local fields={}
            for k,v in pairs(r.Raw or {}) do
                fields[#fields+1]=tostring(k)..":"..type(v)
            end
            table.sort(fields)
            lines[#lines+1]="UNPARSED #"..r.Slot.." "..r.Id..
                " FIELDS="..table.concat(fields,",")
        end
    end
    lines[#lines+1]="SLOT COVERAGE (known/summary_scrolls/deep_scrolls/probe):"
    for id=1,marketCap do
        local summary=state.Stalls[id]
        local detail=state.Full[id]
        local p=state.Probed[id]
        local occupation=occupiedStall(summary) and
            tostring(summary.OwnerName or "OCCUPIED") or
            (state.SnapshotReceived and "EMPTY" or "UNKNOWN")
        lines[#lines+1]=string.format("#%02d | %s | summary=%d | detail=%d | %s | TP=%s",
            id,occupation,#extractItems(summary,id,false),
            #extractItems(detail,id,true),p and p.Status or "NOT_PROBED",
            tostring(state.TpSource[id] or (state.TpCoords[id] and "CALIBRATED" or "UNRESOLVED")))
    end
    return table.concat(lines,"\n")
end
local function render()
    if not state.Alive or not gui.Parent then return end
    local all,filtered=getFiltered()
    local occupied=countOccupied()
    local details=0
    for _ in pairs(state.Full) do details=details+1 end
    local pages=math.max(1,math.ceil(#filtered/state.PageSize))
    state.Page=math.clamp(state.Page,1,pages)
    stats.Text="CÓ NGƯỜI "..occupied.."/"..marketCap
        .."  | EMPTY "..(state.SnapshotReceived and tostring(state.EmptyCount) or "?")
        .." | DETAIL "..details.." | TẤT CẢ SCROLL "..#all
        .." | ĐẠT MYTHIC DPS "..#filtered
        .." | PAGE "..state.Page.."/"..pages
    clearRows()
    -- Nine explicit columns; use a horizontal canvas when Delta's viewport
    -- is narrow instead of squeezing four distinct attributes together.
    local tableWidth=math.max(1500,math.floor(list.AbsoluteSize.X)-16)
    local widths={.204,.111,.121,.121,.121,.121,.074,.061,.066}
    local function cell(parent,text,x,width,size,bold,paint)
        local l=label(parent,text,x+.005,.07,width-.01,.86,size or 11,bold,true)
        l.TextYAlignment=Enum.TextYAlignment.Center
        if paint then l.TextColor3=paint end
        return l
    end
    local function base(order,height,shade)
        local frame=Instance.new("Frame",list)
        frame.Size=UDim2.fromOffset(tableWidth,height)
        frame.LayoutOrder=order;frame.BorderSizePixel=0
        frame.BackgroundColor3=shade or Color.BG
        return frame
    end
    local function separators(row)
        -- Thin lines separate every column, not just the entire row.
        local x=0
        for i=1,#widths-1 do
            x=x+widths[i]
            local line=Instance.new("Frame",row)
            line.Name="ColumnDivider"
            line.BorderSizePixel=0
            line.BackgroundColor3=Color3.fromRGB(93,112,139)
            line.BackgroundTransparency=.48
            line.Size=UDim2.new(0,1,1,0)
            line.Position=UDim2.new(x,0,0,0)
        end
        local bottom=Instance.new("Frame",row)
        bottom.BorderSizePixel=0
        bottom.BackgroundColor3=Color3.fromRGB(71,87,111)
        bottom.BackgroundTransparency=.55
        bottom.Size=UDim2.new(1,0,0,1)
        bottom.Position=UDim2.new(0,0,1,-1)
    end
    local titles={"1 · TÊN SCROLL","2 · NGƯỜI BÁN","3 · CHỈ SỐ 1",
        "4 · CHỈ SỐ 2","5 · CHỈ SỐ 3","6 · CHỈ SỐ 4",
        "7 · GIÁ ($)","8 · MUA","9 · TP"}
    local head=base(1,30,Color.Field)
    local cursor=0
    for i,title in ipairs(titles) do
        cell(head,title,cursor,widths[i],11,true)
        cursor=cursor+widths[i]
    end
    separators(head)
    local first=(state.Page-1)*state.PageSize+1
    local last=math.min(#filtered,first+state.PageSize-1)
    local display=0
    for idx=first,last do
        local r=filtered[idx]
        display=display+1
        local row=base(display+1,58,display%2==0 and Color.Panel or Color.BG)
        cell(row,r.Name.."\n#"..r.Slot.." · MYTHIC · "..r.Matched.."/5 DPS",
            0,widths[1],11,true)
        cell(row,r.Owner,widths[1],widths[2],11,true)
        local x=widths[1]+widths[2]
        for i=1,4 do
            local entry=r.Stats[i] or "?"
                local good=entry:find("Attack Bonus",1,true) or
                entry:find("Crit Rate",1,true) or
                entry:find("Crit Damage",1,true) or
                entry:find("Skill Damage",1,true) or
                entry:find("Skill CDR",1,true)
            cell(row,entry,x,widths[2+i],11,false,good and
                Color3.fromRGB(128,225,170) or Color.Mute)
            x=x+widths[2+i]
        end
        cell(row,fmt(r.Price).." $",x,widths[7],12,true)
        x=x+widths[7]
        local pending=state.PendingPurchase
        local isPending=pending and pending.Fingerprint==fingerprint(r)
        local action=(not r.ListingId) and "ID?" or
            (isPending and (pending.Ready and "XÁC NHẬN" or "ĐANG ĐỌC") or "MUA")
        button(row,action,x+.003,.21,widths[8]-.006,.59,
            function()purchaseClick(r)end,
            isPending and Color.Green or (r.ListingId and Color.Blue or Color.Red))
        x=x+widths[8]
        button(row,"TP #"..r.Slot,x+.003,.21,widths[9]-.008,.59,
            function()teleportToStall(r)end,Color.Green)
        separators(row)
    end
    list.CanvasSize=UDim2.fromOffset(tableWidth,30+display*61+5)
    state.LastRender=os.clock()
    state.Dirty=false
end

button(panel,"SCAN",.013,.919,.13,.055,requestShows,Color.Green)
button(panel,"DEEP CÓ NGƯỜI",.149,.919,.155,.055,deepScan)
button(panel,"STOP",.310,.919,.09,.055,function()
    state.Cancel=true;state.PendingPurchase=nil
    say("Đã dừng scan / hủy yêu cầu xác nhận mua đang chờ.")
    state.Dirty=true
end,Color.Red)
button(panel,"COPY REPORT",.406,.919,.16,.055,function()
    local value=report()
    local copy=(type(setclipboard)=="function" and setclipboard)
        or (type(toclipboard)=="function" and toclipboard)
    if copy then
        local ok=pcall(copy,value)
        say(ok and "Đã copy report Scroll + raw keys." or "Clipboard lỗi; xem console.")
    else
        print(value);say("Delta chưa hỗ trợ clipboard; xem console.")
    end
end)
button(panel,"◀",.578,.919,.065,.055,function()
    state.Page=math.max(1,state.Page-1);state.Dirty=true
end)
button(panel,"▶",.649,.919,.065,.055,function()
    state.Page=state.Page+1;state.Dirty=true
end)
button(panel,"GHI TP",.724,.919,.066,.055,function()
    local id=state.MarkSlot
    if not id then say("Bấm TP của một Scroll để chọn số Stall, sau đó đến quầy và bấm GHI TP.");return end
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then say("Không tìm thấy HumanoidRootPart");return end
    local p=root.Position
    state.TpCoords[id]={x=p.X,y=p.Y,z=p.Z}
    state.TpSource[id]="CALIBRATED"
    local saved=saveTPs()
    say("Đã ghi tọa độ Stall #"..id..(saved and " (đã lưu cho lần sau)." or
        " (chỉ phiên hiện tại; Delta không cho ghi file)."))
end)
local sortBtn
sortBtn=button(panel,"SORT: QUALITY",.795,.919,.192,.055,function()
    state.Sort=({QUALITY="PRICE",PRICE="REFERENCE",REFERENCE="NAME",NAME="QUALITY"})[state.Sort] or "QUALITY"
    sortBtn.Text="SORT: "..state.Sort
    state.Dirty=true
end)
local lowFxBtn
lowFxBtn=button(panel,"LOW FX: ON",.705,.093,.138,.050,function()
    setLowFX(not perf.LowFX)
    lowFxBtn.Text="LOW FX: "..(perf.LowFX and "ON" or "OFF")
    say("LOW FX "..(perf.LowFX and "ON" or "OFF").."; quầy, chữ giá và UI vẫn hiển thị.")
end,Color.Green)
local hidePlayersBtn
hidePlayersBtn=button(panel,"ẨN NGƯỜI: OFF",.849,.093,.138,.050,function()
    setHidePlayers(not perf.HidePlayers)
    hidePlayersBtn.Text="ẨN NGƯỜI: "..(perf.HidePlayers and "ON" or "OFF")
    say("ẨN NGƯỜI "..(perf.HidePlayers and "ON" or "OFF").."; không ẩn Booth.")
end)

-- MARKET V5 SELL PANEL: uses verified TRADE-004 Ore ListStack protocol.
-- Scroll listing intentionally disabled until an actual scroll listing payload is captured.
local sale=Instance.new("Frame",panel)
sale.Name="SalePanel";sale.Visible=false
sale.BackgroundColor3=Color.BG;sale.BorderSizePixel=0
sale.Position=UDim2.new(.008,0,.076,0);sale.Size=UDim2.new(.984,0,.906,0)
sale.ZIndex=20
local saleTitle=label(sale,"BÁN ORE | ListStack Remote | Giá Min game",.018,.008,.70,.055,17,true)
saleTitle.ZIndex=21
local saleStatus=label(sale,"Bấm QUÉT TÚI. Min Price lấy từ ResBoothTradeable; không đoán giá.",.018,.912,.95,.066,12,false,true)
saleStatus.ZIndex=21
local saleRows=Instance.new("ScrollingFrame",sale)
saleRows.Name="SaleRows";saleRows.BackgroundColor3=Color.Panel
saleRows.BorderSizePixel=0;saleRows.Position=UDim2.new(.014,0,.135,0)
saleRows.Size=UDim2.new(.972,0,.765,0);saleRows.ScrollBarThickness=7
saleRows.CanvasSize=UDim2.fromOffset(0,0);saleRows.ZIndex=21
local saleLayout=Instance.new("UIListLayout",saleRows)
saleLayout.Padding=UDim.new(0,5);saleLayout.SortOrder=Enum.SortOrder.LayoutOrder
saleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    if saleRows.Parent then saleRows.CanvasSize=UDim2.fromOffset(0,saleLayout.AbsoluteContentSize.Y+8) end
end)
local saleBusy=false
local saleStop=false
local function saleMsg(msg)
    saleStatus.Text=tostring(msg):sub(1,280)
    print("[STALL_V5_SELL] "..tostring(msg))
end
local function intRange(v,lo,hi)
    local n=tonumber(v)
    if n and n==n and n%1==0 and n>=lo and n<=hi then return n end
    return nil
end
local dataUtil=nil
local forgeUtil=nil
pcall(function()
    local f=require(RS.Framework)
    dataUtil=f.Modules.DataUtil;forgeUtil=f.Modules.ForgeUtil
end)
local function oreBag()
    if not dataUtil then return nil,"DataUtil chưa sẵn sàng" end
    local ok,bag=pcall(function()return dataUtil:GetValue(LocalPlayer,{"Ores"})end)
    if not ok or type(bag)~="table" then return nil,"Không đọc được Ore Bag" end
    return bag
end
local function oreMin(id)
    local d=index["Ore\0"..id]
    if type(d)~="table" then return nil end
    return intRange(d.MinPrice,1,1000000000)
end
local function sellButton(parent,title,x,y,w,h,fn)
    local b=button(parent,title,x,y,w,h,fn)
    b.ZIndex=24
    return b
end
local function numericControl(parent,default,x,y,w,limit)
    local f=field(parent,"",x+.036,y,w-.072,.70,default)
    f.ZIndex=24
    sellButton(parent,"−",x,y,.033,.70,function()
        f.Text=tostring(math.max(1,(tonumber(f.Text) or 1)-1))
    end)
    sellButton(parent,"+",x+w-.033,y,.033,.70,function()
        f.Text=tostring(math.min(limit,(tonumber(f.Text) or 1)+1))
    end)
    return f
end
local function sellOre(id,stacksField,qtyField,priceField,minToggle,btn)
    if saleBusy or not state.Alive then saleMsg("Đang gửi lệnh trước.");return end
    local stacks=intRange(stacksField.Text,1,30)
    local qty=intRange(qtyField.Text,1,1000000)
    local unit=minToggle.Value and oreMin(id) or intRange(priceField.Text,1,1000000000)
    if not stacks or not qty or not unit then
        saleMsg("Giá Min chưa xác minh hoặc số nhập không hợp lệ; chưa gửi Remote.")
        return
    end
    local total=qty*unit
    if total>1000000000 then saleMsg("Tổng giá/stack vượt 1 tỷ; chưa gửi.");return end
    local bag,err=oreBag()
    if not bag then saleMsg(err);return end
    if (tonumber(bag[id]) or 0)<stacks*qty then
        saleMsg("Không đủ "..id.." để bán "..stacks*qty.." viên.");return
    end
    saleBusy=true;saleStop=false
    btn.Text="0/"..stacks
    task.spawn(function()
        local sent=0
        for i=1,stacks do
            if not state.Alive or saleStop then break end
            local live=oreBag()
            if not live or (tonumber(live[id]) or 0)<qty then
                saleMsg("Dừng: túi không đủ hoặc không đọc được dữ liệu.");break
            end
            local ok,e=pcall(function()
                BoothRE:FireServer("ListStack","Ore",id,qty,total)
            end)
            if not ok then saleMsg("Lỗi gửi: "..tostring(e));break end
            sent=sent+1;btn.Text=sent.."/"..stacks
            saleMsg("Đã gửi "..sent.."/"..stacks.." lệnh "..id.."; server chưa xác nhận listing.")
            if i<stacks then task.wait(.8) end
        end
        saleBusy=false;btn.Text="BÁN"
        if state.Alive then saleMsg("Hoàn tất gửi "..sent.."/"..stacks.." lệnh. Kiểm tra quầy để xác nhận.") end
    end)
end
local function refreshSale()
    if saleBusy then saleMsg("Đang gửi; chờ xong mới quét lại.");return end
    local bag,err=oreBag()
    if not bag then saleMsg(err);return end
    for _,c in ipairs(saleRows:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local ids={}
    for id,count in pairs(bag) do
        if type(id)=="string" and (tonumber(count) or 0)>0 then ids[#ids+1]=id end
    end
    table.sort(ids)
    for _,id in ipairs(ids) do
        local item=Instance.new("Frame",saleRows)
        item.Name="Ore_"..id;item.BackgroundColor3=Color.Field
        item.BorderSizePixel=0;item.Size=UDim2.new(1,-10,0,78);item.ZIndex=22
        local mn=oreMin(id)
        local title=label(item,id.." | Túi: "..tostring(bag[id]).." | Min: "..tostring(mn or "N/A"),.012,.02,.34,.35,12,true)
        title.ZIndex=23
        local mode={Value=true}
        local stacks=numericControl(item,"1",.365,.19,.145,30)
        local qty=numericControl(item,tostring(math.min(tonumber(bag[id]) or 1,10)),.52,.19,.155,1000000)
        local price=field(item,"Giá/viên",.687,.19,.12,.55,mn and tostring(mn) or "")
        price.ZIndex=24
        local toggle
        toggle=sellButton(item,"MIN",.81,.19,.065,.55,function()
            mode.Value=not mode.Value
            toggle.Text=mode.Value and "MIN" or "TAY"
            toggle.BackgroundColor3=mode.Value and Color.Green or Color.Blue
        end)
        toggle.BackgroundColor3=Color.Green
        local buy
        buy=sellButton(item,"BÁN",.883,.19,.103,.55,function()
            sellOre(id,stacks,qty,price,mode,buy)
        end)
        local note=label(item,"STACKS                 VIÊN/STACK                  GIÁ/VIÊN",.365,.78,.50,.20,10)
        note.ZIndex=23
    end
    saleMsg("Đã đọc "..#ids.." loại Ore. Scroll bán chưa có payload Remote được xác minh.")
end
sellButton(sale,"QUÉT TÚI",.018,.072,.18,.05,refreshSale)
sellButton(sale,"DỪNG BÁN",.215,.072,.18,.05,function()saleStop=true;saleMsg("Đã yêu cầu dừng sau lệnh hiện tại.")end)
sellButton(sale,"SCROLL: CHƯA XÁC MINH",.425,.072,.33,.05,function()
    saleMsg("Không gửi ListStack Scroll khi chưa biết đúng loại ID/UUID và cấu trúc Remote.")
end)
sellButton(sale,"ĐÓNG",.80,.008,.18,.055,function()sale.Visible=false end)
button(panel,"BÁN HÀNG",.577,.017,.14,.055,function()
    sale.Visible=not sale.Visible
    if sale.Visible and #saleRows:GetChildren()<=1 then refreshSale() end
end,Color.Green)

-- LowFX defaults ON while this standalone is active. This is reversible
-- when it is stopped or replaced by another scan version.
setLowFX(true)
for _,item in ipairs({search,minPrice,maxPrice}) do
    state.Conn[#state.Conn+1]=item:GetPropertyChangedSignal("Text"):Connect(function()
        state.Page=1;state.Dirty=true
    end)
end
state.Conn[#state.Conn+1]=Input.InputBegan:Connect(function(key,handled)
    if not handled and state.Alive and key.KeyCode==Enum.KeyCode.H then
        panel.Visible=not panel.Visible
    end
end)
function state.Stop()
    state.Alive=false;state.Cancel=true;state.PendingPurchase=nil
    saleStop=true
    setHidePlayers(false)
    setLowFX(false)
    for _,c in ipairs(state.Conn) do pcall(function()c:Disconnect()end) end
    if gui and gui.Parent then gui:Destroy() end
    if env.IronSoulMarketScanner==state then env.IronSoulMarketScanner=nil end
end
task.spawn(function()
    while state.Alive do
        task.wait(.35)
        if state.Alive then
            if state.PendingPurchase and state.PendingPurchase.Ready and
                os.clock()>state.PendingPurchase.Expires then
                state.PendingPurchase=nil
                state.Dirty=true
                say("Hết hạn xác nhận mua. Hãy bấm MUA để kiểm tra lại listing.")
            end
            if state.Dirty and os.clock()-state.LastRender>=.9 then
                local ok,err=pcall(render)
                if not ok then warn("[SCROLL_MARKET] UI error: "..tostring(err)) end
            end
        end
    end
end)
if marketPlace() then
    task.delay(.7,function()if state.Alive then requestShows() end end)
else
    say("Hãy vào Market Place rồi bấm SCAN.")
end