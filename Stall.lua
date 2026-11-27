-- IRON SOUL DUNGEON | STALL MARKET v6.3 | nine-column scanner + Ore listing UI + TP + reversible low-FX
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
    "IronSoulScrollMarketScannerV3", "IronSoulScrollMarketScannerV4", "IronSoulScrollMarketScannerV5", "IronSoulScrollMarketScannerV6"}) do
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
-- Unified Stall mode owns the Market hotkeys. Stop the previous DEV
-- overlay/buyer if this standalone is launched directly (outside launcher).
do
    local priorBuyer=env.IronSoulTradeBuyerF7
    if priorBuyer and type(priorBuyer.Stop)=="function" then
        pcall(priorBuyer.Stop)
    end
end
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
local function positiveUserId(stall)
    if type(stall)~="table" then return nil end
    local n=tonumber(stall.OwnerUserId)
    if n and n==math.floor(n) and n>0 and n<1e14 then return n end
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
        local n=tonumber(value)
        local percent=unit~="flat" and unit~="count"
        if percent and n~=0 and math.abs(n)<1 then n=n*100 end
        entries[#entries+1]={Key=tostring(key),Text=formatted,Group=group,
            Percent=percent and n or 0}
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
    local sum=0
    for _,entry in ipairs(entries) do
        if entry.Group then sum=sum+entry.Percent end
    end
    return stats,foundKinds,match,"OK",sum
end
local rarityInfo={
    [1]={Name="Common"},[2]={Name="Uncommon"},[3]={Name="Rare"},
    [4]={Name="Epic"},[5]={Name="Legendary"},[6]={Name="Mythic"},[7]={Name="Secret"}
}
local function parseRarity(v)
    if type(v)~="table" then return nil end
    for _,key in ipairs({"Rarity","RarityID","RarityId","RarityLevel","ScrollRarity","ItemRarity","Grade","Quality"}) do
        local value=v[key]
        if type(value)=="number" and value%1==0 and value>=1 and value<=7 then return value end
        if type(value)=="string" then
            for id,info in pairs(rarityInfo) do
                if tostring(info.Name):lower()==value:lower() then return id end
            end
            if value:lower()=="mythic" then return 6 end
            local num=tonumber(value)
            if num and num%1==0 and num>=1 and num<=7 then return num end
        end
    end
    -- Explicit rolled instance metadata only, never infer from stat count.
    for _,key in ipairs({"ScrollInfo","ScrollData","ItemData","Info","Data","ItemInfo"}) do
        local nested=v[key]
        if type(nested)=="table" and nested~=v then
            for _,field in ipairs({"Rarity","RarityID","RarityId","RarityLevel","ScrollRarity","ItemRarity"}) do
                local value=nested[field]
                local id=tonumber(value)
                if id and id%1==0 and id>=1 and id<=7 then return id end
                if type(value)=="string" then
                    for n,info in pairs(rarityInfo) do
                        if tostring(info.Name):lower()==value:lower() then return n end
                    end
                end
            end
        end
    end
    return nil
end
-- V6 rarity presentation: read native definitions and include observed rarities.
pcall(function()
    local module=RS.Configs:FindFirstChild("ResRarity")
    local defs=module and require(module)
    for key,def in pairs(type(defs)=="table" and defs or {}) do
        if type(def)=="table" then
            local id=tonumber(def.Id or key)
            if id and rarityInfo[id] then
                local nativeName=def.Name or def.DisplayName
                if type(nativeName)=="string" and not nativeName:match("^K_") and not tonumber(nativeName) then
                    rarityInfo[id].Name=nativeName
                end
                rarityInfo[id].Color=def.Color or def.TextColor
            end
        end
    end
end)
pcall(function()
    local module=RS.Enum:FindFirstChild("Rarity")
    for name,id in pairs(module and require(module) or {}) do
        if type(id)=="number" and id>=1 and id<=7 and id%1==0 and type(name)=="string" then
            rarityInfo[id]=rarityInfo[id] or {Name=tostring(name)}
        end
    end
end)
local function rarityStyle(id)
    local info=rarityInfo[id]
    local palette={
        Color3.fromRGB(205,205,215),Color3.fromRGB(95,225,125),
        Color3.fromRGB(85,165,255),Color3.fromRGB(190,110,255),
        Color3.fromRGB(255,200,70),Color3.fromRGB(255,90,100),
        Color3.fromRGB(255,135,215)}
    local color=info and info.Color
    if typeof(color)~="Color3" then color=palette[tonumber(id)] or palette[1] end
    local name=info and tostring(info.Name) or "Chưa rõ"
    return name,color
end
local function goodStatText(text)
    for _,name in ipairs({"Attack Bonus","Skill Damage","Crit Rate","Crit Damage","Skill CDR"}) do
        if text:sub(1,#name+1)==name.." " then return true end
    end
    return false
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
    local stats,groups,good,parseStatus,goodSum=parseStats(v)
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
        StatCount=#stats,Rarity=rarity,Matched=good,GoodSum=goodSum or 0,MatchedList=table.concat(distinct,"+"),
        Pass=reason=="PASS",Reject=reason,ParseStatus=parseStatus,
        Count=number(v,"Quantity","Qty","Count","Amount"),
        Price=price,Unit=number(v,"UnitPrice","PricePerItem") or price,
        Ref=info and number(info,"OfficialPrice") or nil,
        Min=info and number(info,"MinPrice") or nil,
        Max=info and number(info,"MaxPrice") or nil,
        Owner=str(stall,"OwnerName","Username","UserName") or "?",
        OwnerUserId=positiveUserId(stall),
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
            -- StallView, including DEEP scans. Close while scanning/verifying a sale;
            -- keep it available when user TP's to check a price manually.
            if (state.Busy or state.SaleBusy) and WindowUtil and type(WindowUtil.Close)=="function" then
                task.defer(function()
                    if state.Alive and (state.Busy or state.SaleBusy) then
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
-- STALL_MARKET_LITE_V1_BEGIN
-- Visual-only Market reduction. Hide static shop/building/booth decoration
-- without Destroy(), reparent, geometry/collision changes, or server remotes.
-- Floors, interaction anchors, booth signage, players and NPCs remain intact.
-- Integrated into existing LOW FX toggle; OFF/Stop restores exact values.
local setMarketLite=(function()
    local lite={Enabled=false,Epoch=0,Changed=setmetatable({},{__mode="k"}),
        Connections={},Hidden=0,Scanned=0}
    state.MarketLite=lite
    local safeNames={
        "ground","floor","baseplate","platform","road","path","walk",
        "bridge","spawn","stair","step","ramp","foundation","landing",
        "checkpoint","teleport","interact","trigger","hitbox","portal",
        "boothbase","stallbase","boothpoint","stallpoint","boothslot",
        "stallslot","collision","safezone","zonebase","water",
    }
    local function markedSafe(name)
        local lower=tostring(name or ""):lower()
        for _,word in ipairs(safeNames) do
            if lower:find(word,1,true) then return true end
        end
        return false
    end
    local function hasInteractUI(part)
        -- Never hide a part carrying a player prompt or a seller/price board.
        for _,child in ipairs(part:GetDescendants()) do
            if child:IsA("ProximityPrompt") or child:IsA("ClickDetector")
                or child:IsA("TouchTransmitter") or child:IsA("SurfaceGui")
                or child:IsA("BillboardGui") then return true end
        end
        return false
    end
    local function isProtected(part)
        if not part:IsA("BasePart") or not part.Anchored then return true end
        if part==Workspace.Terrain then return true end
        if markedSafe(part.Name) or hasInteractUI(part) then return true end
        -- Flat, upward-facing structural plates may be walkable even if named Part.
        -- Leave these visible rather than hiding ground or invisible bridges.
        local size,cf=part.Size,part.CFrame
        local visualRoof=tostring(part.Name):lower()
        visualRoof=visualRoof:find("roof",1,true) or visualRoof:find("canopy",1,true)
            or visualRoof:find("awning",1,true) or visualRoof:find("ceiling",1,true)
        if not visualRoof and size and cf and cf.UpVector and cf.UpVector.Y>=0.72
            and size.Y>0 and size.X>=size.Y*3 and size.Z>=size.Y*3 then
            return true
        end
        local ancestor=part.Parent
        for _=1,16 do
            if not ancestor or ancestor==Workspace then break end
            if ancestor:IsA("Model") then
                -- Keep avatars, NPCs and pets, even if their limbs are anchored.
                if ancestor:FindFirstChildOfClass("Humanoid") then return true end
                local n=ancestor.Name:lower()
                if n:find("npc",1,true) or n:find("enemy",1,true)
                    or n:find("boss",1,true) or n:find("pet",1,true) then
                    return true
                end
            end
            ancestor=ancestor.Parent
        end
        return false
    end
    local function hidePart(part)
        if not lite.Enabled or not part or not part:IsA("BasePart") then return end
        lite.Scanned=lite.Scanned+1
        if isProtected(part) then return end
        local before=lite.Changed[part]
        change(lite.Changed,part,"LocalTransparencyModifier",1)
        if not before and lite.Changed[part] then lite.Hidden=lite.Hidden+1 end
    end
    local function restoreMarket()
        lite.Enabled=false
        lite.Epoch=lite.Epoch+1
        disconnect(lite.Connections)
        restore(lite.Changed)
        lite.Hidden=0
        lite.Scanned=0
    end
    local function setEnabled(on)
        on=on==true and state.Alive and marketPlace()
        if not on then
            restoreMarket()
            return
        end
        if lite.Enabled then return end
        lite.Enabled=true
        lite.Epoch=lite.Epoch+1
        local epoch=lite.Epoch
        lite.Hidden=0;lite.Scanned=0
        lite.Connections[#lite.Connections+1]=Workspace.DescendantAdded:Connect(function(obj)
            if not lite.Enabled or not state.Alive or lite.Epoch~=epoch then return end
            if obj:IsA("BasePart") then
                hidePart(obj)
            elseif obj:IsA("Model") then
                -- A fully parented building can arrive with children preloaded.
                task.defer(function()
                    if not lite.Enabled or not state.Alive or lite.Epoch~=epoch then return end
                    for _,desc in ipairs(obj:GetDescendants()) do hidePart(desc) end
                end)
            end
        end)
        task.spawn(function()
            local descendants=Workspace:GetDescendants()
            for i,obj in ipairs(descendants) do
                if not state.Alive or not lite.Enabled or lite.Epoch~=epoch then return end
                hidePart(obj)
                if i%180==0 then task.wait() end
            end
            if state.Alive and lite.Enabled and lite.Epoch==epoch then
                print("[STALL_MARKET_LITE] ON; hidden_static_parts="..lite.Hidden
                    .." scanned="..lite.Scanned
                    .."; floor/prompts/booth signs/characters kept; visual only")
            end
        end)
    end
    return setEnabled
end)()
-- STALL_MARKET_LITE_V1_END

local function setLowFX(enabled)
    if perf.LowFX==enabled then return end
    perf.LowFX=enabled
    disconnect(perf.Conns)
    -- Market Lite follows the SAME Low FX button; no separate toggle.
    setMarketLite(enabled)
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
-- Keep the public GUI identifier compatible with already deployed V5 launchers.
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
minSize.MinSize=Vector2.new(0,0)
-- STALL_V61_LAYOUT_BEGIN
function state.FitColumns(rows,viewport,sell)
    local width=math.max(1,viewport or 1)
    local longestName,longestOwner=0,0
    local measurements={}
    local function measure(text)
        text=tostring(text or "")
        if measurements[text] then return measurements[text] end
        local ok,size=pcall(function()
            return game:GetService("TextService"):GetTextSize(tostring(text or ""),11,
                Enum.Font.GothamBold,Vector2.new(10000,1000))
        end)
        local result=ok and size.X or #text*7
        measurements[text]=result
        return result
    end
    for _,r in ipairs(rows) do
        longestName=math.max(longestName,measure(r.Name))
        longestOwner=math.max(longestOwner,measure(r.Owner))
    end
    local function clamp(n,lo,hi)return math.max(lo,math.min(hi,n))end
    local name=clamp((longestName+14)/width,.13,.23)
    if sell then
        local quick,manual=.075,.165
        local stat=(1-name-quick*3-manual)/4
        return {name,stat,stat,stat,stat,quick,quick,quick,manual}
    end
    local owner=clamp((longestOwner+14)/width,.075,.13)
    local price,buy,tp=.075,.075,.055
    local stat=(1-name-owner-price-buy-tp)/4
    return {name,owner,stat,stat,stat,stat,price,buy,tp}
end
-- STALL_V61_LAYOUT_END
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
local status=label(panel,"SCAN → DEEP QUẦY CÓ NGƯỜI | xem mọi Scroll, kiểm tra đúng listing trước khi mua.",.014,.151,.97,.048,12)
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
-- Compare purchase identity, not a display fingerprint: BoothShows and StallView
-- may expose different fields for the SAME listing. Never relax owner/id/price.
local function samePurchaseTarget(a,b)
    if not a or not b or a.Type~="Scroll" or b.Type~="Scroll" then return false end
    if not a.OwnerUserId or not b.OwnerUserId or
        a.OwnerUserId~=b.OwnerUserId or a.Slot~=b.Slot then return false end
    if not a.ListingId or b.ListingId~=a.ListingId or a.Id~=b.Id then return false end
    if not a.Price or a.Price<=0 or b.Price~=a.Price then return false end
    if a.Rarity~=nil and b.Rarity~=a.Rarity then return false end
    if a.StatCount>0 then
        if b.StatCount~=a.StatCount or
            table.concat(a.Stats,"|")~=table.concat(b.Stats,"|") then return false end
    end
    return true
end
local function purchaseKey(r)
    return table.concat({tostring(r.Slot),tostring(r.OwnerUserId),
        tostring(r.Id),tostring(r.ListingId),tostring(r.Price)},"|")
end
local function matchingDetail(original)
    local last=state.Full[original.Slot]
    if type(last)~="table" or positiveUserId(last)~=original.OwnerUserId then return nil end
    for _,r in ipairs(extractItems(last,original.Slot,true)) do
        if samePurchaseTarget(original,r) then return r end
    end
    return nil
end
local search=field(panel,"Tên Scroll / Skill / chỉ số / người bán",.014,.092,.37,.050,"")
local minPrice=field(panel,"Min $",.392,.092,.14,.050,"")
local maxPrice=field(panel,"Max $",.541,.092,.14,.050,"")
label(panel,"STALL MARKET v6.3 | SCAN / MUA / BÁN ORE + SCROLL",.014,.018,.72,.058,15,true)
button(panel,"H ẨN",.825,.017,.081,.055,function()panel.Visible=false end)
button(panel,"X",.915,.017,.070,.055,function() state.Stop() end,Color.Red)
local list=Instance.new("ScrollingFrame",panel)
list.Name="ScrollListings";list.Position=UDim2.new(.012,0,.327,0)
list.Size=UDim2.new(.975,0,.564,0)
list.BorderSizePixel=0;list.BackgroundColor3=Color.Panel
list.ScrollBarThickness=8;list.ScrollingDirection=Enum.ScrollingDirection.Y
list.CanvasSize=UDim2.fromOffset(0,0)
state.BuyHeader=Instance.new("Frame",panel)
state.BuyHeader.Position=UDim2.new(.012,0,.287,0)
state.BuyHeader.Size=UDim2.new(.975,-10,.038,0)
state.BuyHeader.BackgroundColor3=Color.Field;state.BuyHeader.BorderSizePixel=0
state.HideOwn=true;state.BuyRarity="ALL"
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
    local hidden=0
    for _,r in ipairs(all) do
        local own=r.OwnerUserId==LocalPlayer.UserId or tostring(r.Owner):lower()=="vnbshockler"
        if state.HideOwn and own then hidden=hidden+1 end
        local joined=(r.Name.." "..r.Id.." "..r.Owner.." "..
            table.concat(r.Stats," ")):lower()
        if (not state.HideOwn or not own) and (state.BuyRarity=="ALL" or r.Rarity==state.BuyRarity) and (q=="" or joined:find(q,1,true)) and
            (not mn or r.Price and r.Price>=mn) and
            (not mx or r.Price and r.Price<=mx) then
            result[#result+1]=r
        end
    end
    table.sort(result,function(a,b)
        if state.Sort=="RARITY" and (a.Rarity or 0)~=(b.Rarity or 0) then return (a.Rarity or 0)>(b.Rarity or 0) end
        if (state.Sort=="QUALITY" or state.Sort=="RARITY") and a.Matched~=b.Matched then
            return a.Matched>b.Matched
        end
        if (state.Sort=="QUALITY" or state.Sort=="RARITY") and a.GoodSum~=b.GoodSum then
            return a.GoodSum>b.GoodSum
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
    return all,result,hidden
end
local function requestShows()
    if state.SaleBusy then say("Đang xác minh bán; chờ hoàn tất.");return false end
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
    if state.SaleBusy or state.Busy or state.PurchaseBusy or state.PendingPurchase then
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
    if not r or r.Type~="Scroll" then
        say("KHÔNG MUA: dòng hiện tại không phải listing Scroll.")
        return
    end
    if state.SaleBusy or state.Busy or state.PurchaseBusy then
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
        pending.Fingerprint==purchaseKey(r) then
        local live=matchingDetail(pending.Selected)
        if not live or not samePurchaseTarget(pending.Selected,r)
            or not samePurchaseTarget(r,live) then
            state.PendingPurchase=nil
            say("Listing thay đổi hoặc đã bán; MUA bị hủy, hãy scan lại.")
            state.Dirty=true
            return
        end
        state.PendingPurchase=nil
        state.PurchaseBusy=true
        local ok,err=pcall(function()
            -- RemoteSpy verified from native stall purchase: Purchase(ownerUserId, listingId)
            -- Slot is used only for InteractStall / detail verification.
            BoothRE:FireServer("Purchase",r.OwnerUserId,r.ListingId)
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
    local selected=purchaseKey(r)
    local req={Fingerprint=selected,Selected=r,Slot=r.Slot,Ready=false,Expires=now+8}
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
                if verified and verified.Detail and
                    samePurchaseTarget(r,verified) then
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
    local all,filtered,hidden=getFiltered()
    local occupied=countOccupied()
    local details=0
    for _ in pairs(state.Full) do details=details+1 end
    local pages=math.max(1,math.ceil(#filtered/state.PageSize))
    state.Page=math.clamp(state.Page,1,pages)
    stats.Text="CÓ NGƯỜI "..occupied.."/"..marketCap
        .."  | EMPTY "..(state.SnapshotReceived and tostring(state.EmptyCount) or "?")
        .." | DETAIL "..details.." | TẤT CẢ SCROLL "..#all
        .." | HIỆN "..#filtered.." | ẨN CỦA TÔI "..hidden
        .." | PAGE "..state.Page.."/"..pages
    clearRows()
    local widths=state.FitColumns(filtered,list.AbsoluteSize.X,false)
    for _,child in ipairs(state.BuyHeader:GetChildren()) do child:Destroy() end
    local function cell(parent,text,x,width,size,bold,paint)
        local l=label(parent,text,x+.005,.07,width-.01,.86,size or 11,bold,true)
        l.TextYAlignment=Enum.TextYAlignment.Center
        if paint then l.TextColor3=paint end
        return l
    end
    local function base(order,height,shade)
        local frame=Instance.new("Frame",list)
        frame.Size=UDim2.new(1,-10,0,height)
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
    local head=state.BuyHeader
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
        local row=base(display,38,display%2==0 and Color.Panel or Color.BG)
        cell(row,r.Name.."\n#"..r.Slot.." · "..rarityStyle(r.Rarity).." · "..r.Matched.."/5",
            0,widths[1],11,true,select(2,rarityStyle(r.Rarity)))
        cell(row,r.Owner,widths[1],widths[2],11,true)
        local x=widths[1]+widths[2]
        for i=1,4 do
            local entry=r.Stats[i] or "?"
                local good=entry:find("Attack Bonus",1,true) or
                entry:find("Crit Rate",1,true) or
                entry:find("Crit Damage",1,true) or
                entry:find("Skill Damage",1,true) or
                entry:find("Skill CDR",1,true)
            cell(row,entry,x,widths[2+i],11,true,good and
                Color3.fromRGB(95,255,135) or Color3.fromRGB(205,210,220))
            x=x+widths[2+i]
        end
        cell(row,fmt(r.Price).." $",x,widths[7],12,true)
        x=x+widths[7]
        local pending=state.PendingPurchase
        local isPending=pending and pending.Fingerprint==purchaseKey(r)
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
    list.CanvasSize=UDim2.fromOffset(0,display*41+5)
    state.LastRender=os.clock()
    state.Dirty=false
end

do
    local ownBtn
    ownBtn=button(panel,"ẨN HÀNG CỦA TÔI: ON",.014,.247,.25,.036,function()
        state.HideOwn=not state.HideOwn
        ownBtn.Text="ẨN HÀNG CỦA TÔI: "..(state.HideOwn and "ON" or "OFF")
        state.Page=1;state.Dirty=true
    end,Color.Green)
    local rarityBtn
    rarityBtn=button(panel,"RARITY: ALL",.272,.247,.18,.036,function()
        local ids={"ALL"}
        for id in pairs(rarityInfo) do ids[#ids+1]=id end
        table.sort(ids,function(a,b)if a=="ALL" then return b~="ALL" elseif b=="ALL" then return false end return a>b end)
        local i=1
        for n,id in ipairs(ids) do if id==state.BuyRarity then i=n end end
        state.BuyRarity=ids[i%#ids+1]
        rarityBtn.Text="RARITY: "..(state.BuyRarity=="ALL" and "ALL" or rarityStyle(state.BuyRarity))
        state.Page=1;state.Dirty=true
    end)
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
    state.Sort=({QUALITY="RARITY",RARITY="PRICE",PRICE="REFERENCE",REFERENCE="NAME",NAME="QUALITY"})[state.Sort] or "QUALITY"
    sortBtn.Text="SORT: "..state.Sort
    state.Dirty=true
end)
local lowFxBtn
lowFxBtn=button(panel,"LOW FX: ON",.705,.093,.138,.050,function()
    setLowFX(not perf.LowFX)
    lowFxBtn.Text="LOW FX: "..(perf.LowFX and "ON" or "OFF")
    say("LOW FX + MARKET LITE "..(perf.LowFX and "ON" or "OFF").."; giữ nền, điểm tương tác, bảng giá, UI.")
end,Color.Green)
local hidePlayersBtn
hidePlayersBtn=button(panel,"ẨN NGƯỜI: OFF",.849,.093,.138,.050,function()
    setHidePlayers(not perf.HidePlayers)
    hidePlayersBtn.Text="ẨN NGƯỜI: "..(perf.HidePlayers and "ON" or "OFF")
    say("ẨN NGƯỜI "..(perf.HidePlayers and "ON" or "OFF").."; không ẩn Booth.")
end)

-- MARKET V6 SELL PANEL: Ore ListStack, Scroll List(UUID, price), manual/bulk tiers.
local sale=Instance.new("Frame",panel)
sale.Name="SalePanel";sale.Visible=false
sale.BackgroundColor3=Color.BG;sale.BorderSizePixel=0
sale.Position=UDim2.new(.008,0,.076,0);sale.Size=UDim2.new(.984,0,.906,0)
sale.ZIndex=20
local saleTitle=label(sale,"BÁN ORE / SCROLL | Remote Booth",.018,.008,.70,.055,17,true)
saleTitle.ZIndex=21
local saleStatus=label(sale,"Chọn QUÉT ORE hoặc QUÉT SCROLL. Scroll cần có UUID riêng.",.018,.912,.95,.066,12,false,true)
saleStatus.ZIndex=21
local bulkBar=Instance.new("Frame",sale)
bulkBar.Name="QualityBulkBar";bulkBar.BackgroundTransparency=1
bulkBar.Position=UDim2.new(.014,0,.138,0);bulkBar.Size=UDim2.new(.972,0,.062,0)
bulkBar.Visible=false;bulkBar.ZIndex=23
local saleHeader=Instance.new("Frame",sale)
saleHeader.Name="SaleTableHeader";saleHeader.BorderSizePixel=0
saleHeader.BackgroundColor3=Color.Field
saleHeader.Position=UDim2.new(.014,0,.142,0)
saleHeader.Size=UDim2.new(.972,-10,.056,0);saleHeader.ZIndex=22
local saleRows=Instance.new("ScrollingFrame",sale)
saleRows.Name="SaleRows";saleRows.BackgroundColor3=Color.Panel
saleRows.BorderSizePixel=0;saleRows.Position=UDim2.new(.014,0,.204,0)
saleRows.Size=UDim2.new(.972,0,.695,0);saleRows.ScrollBarThickness=7
saleRows.CanvasSize=UDim2.fromOffset(0,0);saleRows.ZIndex=21
saleRows.ScrollingDirection=Enum.ScrollingDirection.Y
local saleLayout=Instance.new("UIListLayout",saleRows)
saleLayout.Padding=UDim.new(0,5);saleLayout.SortOrder=Enum.SortOrder.LayoutOrder
saleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    if saleRows.Parent and not bulkBar.Visible then saleRows.CanvasSize=UDim2.fromOffset(0,saleLayout.AbsoluteContentSize.Y+8) end
end)
local saleBusy=false;state.SaleBusy=false
local saleStop=false
local saleAttempted={}
local bulkPending=nil
local bulkButtons={}
local scrollInventoryCache={}
local function writeSaleHeader(columns,scrollMode)
    bulkBar.Visible=scrollMode
    saleHeader.Visible=true
    saleHeader.Position=UDim2.new(.014,0,scrollMode and .267 or .142,0)
    saleRows.Position=UDim2.new(.014,0,scrollMode and .327 or .204,0)
    saleRows.Size=UDim2.new(.972,0,scrollMode and .573 or .695,0)
    for _,child in ipairs(saleHeader:GetChildren()) do child:Destroy() end
    for _,col in ipairs(columns) do
        local item=Instance.new("TextLabel",saleHeader)
        item.BackgroundTransparency=1
        item.Text=col[1];item.Font=Enum.Font.GothamBold;item.TextSize=11
        item.TextColor3=Color.Text;item.TextXAlignment=Enum.TextXAlignment.Center
        item.Position=UDim2.new(col[2],0,0,0)
        item.Size=UDim2.new(col[3],0,1,0)
        item.ZIndex=23
    end
end
local ORE_COLUMNS={
    {"ORE / TỒN KHO",.010,.345},{"SỐ STACK",.365,.145},
    {"VIÊN/STACK",.520,.155},{"GIÁ/VIÊN",.686,.120},
    {"CHỌN GIÁ",.810,.068},{"BÁN",.883,.104},
}
local SCROLL_COLUMNS={
    {"TÊN SCROLL",.006,.182},{"CHỈ SỐ 1",.189,.134},
    {"CHỈ SỐ 2",.324,.134},{"CHỈ SỐ 3",.459,.134},
    {"CHỈ SỐ 4",.594,.134},{"XỊN",.730,.058},
    {"GIÁ",.793,.095},{"BÁN",.896,.090},
}
local function saleMsg(msg)
    saleStatus.Text=tostring(msg):sub(1,280)
    print("[STALL_V6_SELL] "..tostring(msg))
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
-- STALL_V6_GUARD_BEGIN: one reservation shared by Scroll, Ore and Clone.
local SaleGuard={Pending=env.IronSoulStallSalePending}
function SaleGuard.Wait(check,seconds)
    local deadline=os.clock()+seconds
    repeat
        local result=check()
        if result then return result end
        if not state.Alive or saleStop then return nil end
        task.wait(.1)
    until os.clock()>=deadline
end
function SaleGuard.Snapshot()
    if not state.Alive or saleStop or not marketPlace() then return nil,"Đã dừng/rời Market" end
    local before=state.RefreshCount
    local ok=pcall(function()BoothRE:FireServer("RequestBoothShows")end)
    if not ok or not SaleGuard.Wait(function()return state.RefreshCount>before end,6) then
        return nil,"Không xác minh được quầy mới"
    end
    local own
    for i,stall in pairs(state.Stalls) do
        if positiveUserId(stall)==LocalPlayer.UserId then
            if own then return nil,"Nhiều quầy cùng chủ" end
            own=i
        end
    end
    if not own then return nil,"Chưa có quầy của bạn" end
    state.Full[own]=nil;state.FullAt[own]=nil;state.ResponseSlot=nil
    ok=pcall(function()BoothRE:FireServer("InteractStall",own)end)
    local detail=ok and SaleGuard.Wait(function()
        return state.ResponseSlot==own and state.Full[own]
    end,6)
    if not detail or positiveUserId(detail)~=LocalPlayer.UserId or type(detail.Items)~="table" then
        return nil,"Không xác minh được danh sách listing"
    end
    local snap={Slot=own,Count=0,Ids={},Items={}}
    for key,item in pairs(detail.Items) do
        if type(item)~="table" then return nil,"Listing không hợp lệ" end
        local itemId=str(item,"ItemID","ItemId","ItemIDStr","ItemName")
        local uuid=getListingId(item,itemId)
        if not uuid or snap.Ids[uuid] then return nil,"Listing thiếu/trùng UUID" end
        snap.Ids[uuid]=true;snap.Items[uuid]=item;snap.Count=snap.Count+1
    end
    if snap.Count>30 then return nil,"Số listing vượt 30; dừng" end
    return snap
end
function SaleGuard.Confirmed(pending,after)
    if not pending.Snapshot or type(pending.Check)~="function" then return false end
    local before=pending.Snapshot
    if not after or after.Slot~=before.Slot then return false end
    local matches=0
    for listingId,item in pairs(after.Items) do
        if not before.Ids[listingId]
            and str(item,"ItemType","Type","Category")==pending.Kind
            and str(item,"ItemID","ItemId","ItemIDStr","ItemName")==pending.Id
            and number(item,"TotalPrice","ListingPrice","Price","SellPrice")==pending.Price
            and (pending.Kind=="Scroll"
                or number(item,"Quantity","Qty","Count","Amount")==pending.Quantity) then
            matches=matches+1
        end
    end
    local ok,changed=pcall(pending.Check,true)
    return matches==1 and ok and changed==true
end
function SaleGuard.Reconcile()
    local pending=SaleGuard.Pending
    if not pending then return true end
    local after=SaleGuard.Snapshot()
    if SaleGuard.Confirmed(pending,after) then
        SaleGuard.Pending=nil;env.IronSoulStallSalePending=nil
        return true
    end
    return false
end
function SaleGuard.Free()
    if not SaleGuard.Reconcile() then return nil,"Lệnh trước chưa rõ kết quả; dừng bán để kiểm tra quầy" end
    local snap,err=SaleGuard.Snapshot()
    return snap and math.max(0,30-snap.Count) or nil,err
end
function SaleGuard.Send(kind,id,quantity,price,check,uuid)
    if not SaleGuard.Reconcile() then return false,"Lệnh trước chưa xác nhận; không gửi tiếp" end
    if state.Busy or state.PurchaseBusy then return false,"Đang quét/mua" end
    local snap,err=SaleGuard.Snapshot()
    if not snap then return false,err end
    if snap.Count>=30 then return false,"Quầy đã đủ 30 slot" end
    if uuid and snap.Ids[uuid] then return false,"UUID đã có trên quầy" end
    local valid,reason=check(false)
    if not valid then return false,reason or "Túi đã thay đổi" end
    if not state.Alive or saleStop or not marketPlace() then return false,"Đã dừng" end
    -- Reserve BEFORE dispatch. An uncertain result survives panel changes/reinjection.
    local pending={Kind=kind,Id=id,Quantity=quantity,Price=price,UUID=uuid,Snapshot=snap,Check=check}
    SaleGuard.Pending=pending;env.IronSoulStallSalePending=pending
    local sent,sendErr=pcall(function()
        if kind=="Scroll" then BoothRE:FireServer("List",uuid,price)
        else BoothRE:FireServer("ListStack","Ore",id,quantity,price) end
    end)
    if not sent then return false,"Gửi lỗi; kết quả chưa rõ: "..tostring(sendErr) end
    local deadline=os.clock()+10
    repeat
        local after=SaleGuard.Snapshot()
        if SaleGuard.Confirmed(pending,after) then
            SaleGuard.Pending=nil;env.IronSoulStallSalePending=nil
            return true
        end
        if not state.Alive or saleStop then break end
        task.wait(.35)
    until os.clock()>=deadline
    return false,"Chưa xác nhận listing và túi; đã dừng mọi đường bán"
end
function SaleGuard.Ore(id,quantity,price)
    local def=index["Ore\0"..id]
    local mn=type(def)=="table" and intRange(def.MinPrice,1,1000000000)
    local mx=type(def)=="table" and intRange(def.MaxPrice,1,1000000000)
    if not mn or not mx or not intRange(quantity,1,1000000)
        or not intRange(price,1,1000000000) or price<quantity*mn or price>quantity*mx then
        return false,"Giá/số lượng Ore ngoài Min/Max"
    end
    local before
    return SaleGuard.Send("Ore",id,quantity,price,function(confirm)
        local bag=oreBag()
        local count=bag and intRange(bag[id] or 0,0,1000000000)
        if count==nil then return false,"Không đọc được tồn Ore" end
        if confirm then return count<=before-quantity end
        before=count
        return count>=quantity,"Không đủ Ore"
    end)
end
-- STALL_V6_GUARD_END
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
    saleBusy=true;state.SaleBusy=true;saleStop=false
    btn.Text="0/"..stacks
    task.spawn(function()
        local sent=0
        for i=1,stacks do
            if not state.Alive or saleStop then break end
            local live=oreBag()
            if not live or (tonumber(live[id]) or 0)<qty then
                saleMsg("Dừng: túi không đủ hoặc không đọc được dữ liệu.");break
            end
            local ok,e=SaleGuard.Ore(id,qty,total)
            if not ok then saleMsg("Lỗi gửi: "..tostring(e));break end
            sent=sent+1;btn.Text=sent.."/"..stacks
            saleMsg("Đã gửi "..sent.."/"..stacks.." lệnh "..id.."; listing đã xác nhận.")
            if i<stacks then task.wait(.8) end
        end
        saleBusy=false;state.SaleBusy=false;btn.Text="BÁN"
        if state.Alive then saleMsg("Đã xác nhận "..sent.."/"..stacks.." listing."..(SaleGuard.Pending and " DỪNG: lệnh cuối chưa rõ kết quả." or "")) end
    end)
end
local function refreshSale()
    if saleBusy then saleMsg("Đang gửi; chờ xong mới quét lại.");return end
    saleTitle.Text="BÁN ORE | ListStack | Giá Min game"
    bulkPending=nil
    if state.ScrollWindowClear then state.ScrollWindowClear() end
    writeSaleHeader(ORE_COLUMNS,false)
    saleLayout.Parent=saleRows
    saleRows.CanvasPosition=Vector2.zero
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
        item.BorderSizePixel=0;item.Size=UDim2.new(1,-10,0,48);item.ZIndex=22
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
        -- Column labels live in the fixed header and do not scroll with each row.
    end
    saleMsg("Đã đọc "..#ids.." loại Ore. Số stack × viên/stack × giá/viên.")
end
-- CLONE_PLAN_CORE_BEGIN: pure exact-total single-stack optimizer.
-- For a stack of n units: n*MinPrice <= target <= n*MaxPrice.
-- All smaller stacks fail the max bound, so ceil(target/MaxPrice) is optimal.
local function planCloneStack(target,minPrice,maxPrice,stock)
    target=intRange(target,1,1000000000)
    minPrice=intRange(minPrice,1,1000000000)
    maxPrice=intRange(maxPrice,1,1000000000)
    stock=intRange(stock,0,1000000000)
    if not target then return nil,"Nhập số Shards nguyên từ 1 đến 1 tỷ" end
    if not minPrice or not maxPrice or maxPrice<minPrice then
        return nil,"Thiếu Min/Max Ore hợp lệ từ ResBoothTradeable"
    end
    if stock==nil then return nil,"Số Ore trong túi chưa xác minh" end
    local quantity=math.ceil(target/maxPrice)
    if quantity<1 or quantity>1000000 then
        return nil,"Vượt giới hạn 1.000.000 Ore/stack"
    end
    local low,high=quantity*minPrice,quantity*maxPrice
    if target<low or target>high then
        return nil,"Không có stack khớp chính xác giá trị này"
    end
    if quantity>stock then
        return nil,"Thiếu Ore: cần "..quantity..", hiện có "..stock
    end
    return {Quantity=quantity,Price=target,MinAllowed=low,MaxAllowed=high}
end
-- CLONE_PLAN_CORE_END

-- Scroll listing: RemoteSpy and BoothController verify List(UUID, price).
-- Inventory formats can vary; only actual UUIDs from owned records are listed.
local function validScrollUUID(s)
    return type(s)=="string" and #s>=16 and #s<=128 and
        s:match("^[%w_%-]+$")~=nil and s:lower():sub(1,7)~="scroll_"
end
local function scrollResource(v)
    if type(v)~="table" then return nil end
    for _,k in ipairs({"ItemID","ItemId","ScrollId","ScrollID",
        "ResourceId","BaseId","Id"}) do
        local id=v[k]
        if type(id)=="string" and id:lower():sub(1,7)=="scroll_" then return id end
    end
    return nil
end
local function scanOwnedScrolls()
    local items,seen,unresolved,diagnostics,sources={},{},0,{},{}
    local definitions={}
    local names={}
    local function source(name,ok,val)
        local found=ok and type(val)=="table"
        diagnostics[#diagnostics+1]=name..":"..(found and "OK" or "N/A")
        if found then sources[#sources+1]={Name=name,Value=val} end
    end
    -- Native ScrollUtil owns Id/UUID/Attrs. Rarity is in the definition, not
    -- in the owned row (GiveScroll/GiveScrollWithData/GiveScrollFromData).
    local nativeOwned=false
    if type(ScrollUtil)=="table" and type(ScrollUtil.GetAllOwned)=="function" then
        local ok,v=pcall(function()return ScrollUtil:GetAllOwned(LocalPlayer)end)
        -- GetAllOwned returns {} even if the profile is not ready. Require an
        -- actual data source for empty inventory before treating removal as ACK.
        nativeOwned=ok and type(v)=="table" and next(v)~=nil
        source("ScrollUtil.GetAllOwned",nativeOwned,v)
    end
    if not nativeOwned and type(ScrollUtil)=="table" then
        for _,method in ipairs({"GetOwned","GetOwnedScrolls","GetInventory","GetScrolls"}) do
            if type(ScrollUtil[method])=="function" then
                local ok,v=pcall(function()return ScrollUtil[method](ScrollUtil,LocalPlayer)end)
                if not ok or type(v)~="table" then
                    ok,v=pcall(function()return ScrollUtil[method](ScrollUtil)end)
                end
                source("ScrollUtil."..method,ok,v)
            end
        end
    elseif not nativeOwned then diagnostics[#diagnostics+1]="ScrollUtil:MISSING" end
    if not nativeOwned and dataUtil then
        local okData,playerData=pcall(function()return dataUtil:GetPlayerData(LocalPlayer)end)
        if okData and type(playerData)=="table" then
            for _,key in ipairs({"Scrolls","Scroll","OwnedScrolls","ScrollInventory"}) do
                if type(playerData[key])=="table" then source("GetPlayerData."..key,true,playerData[key]) end
            end
        end
        local paths={{"Scrolls","Owned"},{"Scroll","Owned"},
            {"OwnedScrolls"},{"Scrolls"},{"ScrollInventory"}}
        local ok,k=pcall(function()
            local folder=RS:FindFirstChild("Enum")
            local module=folder and folder:FindFirstChild("KeyString")
            return module and require(module)
        end)
        local keys=ok and type(k)=="table" and k.ScrollUtil
        local root=type(keys)=="table" and (keys.Scrolls or keys.Scroll or keys.Name)
        local owned=type(keys)=="table" and (keys.Owned or keys.Inventory)
        if type(root)=="string" then
            table.insert(paths,1,{root})
            if type(owned)=="string" then table.insert(paths,1,{root,owned}) end
        end
        local already={}
        for _,path in ipairs(paths) do
            local name=table.concat(path,"/")
            if not already[name] then
                already[name]=true
                local ok,v=pcall(function()return dataUtil:GetValue(LocalPlayer,path)end)
                source("DataUtil."..name,ok,v)
            end
        end
    elseif not nativeOwned then diagnostics[#diagnostics+1]="DataUtil:MISSING" end
    local function register(raw,key,origin)
        if type(raw)~="table" then return false end
        local id=scrollResource(raw)
        if not id and raw.ItemType~="Scroll" and raw.Type~="Scroll" then return false end
        local uuid=nil
        for _,field in ipairs({"UUID","Uuid","UID","UniqueId",
            "Guid","GUID","InstanceId","Id"}) do
            if validScrollUUID(raw[field]) then uuid=raw[field];break end
        end
        if not uuid and validScrollUUID(key) then uuid=key end
        if not uuid then unresolved=unresolved+1;return true end
        local previous=seen[uuid]
        local name=id and names[id]
        if not name then
            name=id and scrollName(id,raw) or "Scroll (chưa rõ loại)"
            if id then names[id]=name end
        end
        local attrs,_,premium,_,goodSum=parseStats(raw)
        local def=id and index["Scroll\0"..id]
        local min=type(def)=="table" and intRange(def.MinPrice,1,1000000000) or nil
        local max=type(def)=="table" and intRange(def.MaxPrice,1,1000000000) or nil
        local scrollDef=id and definitions[id]
        if scrollDef==nil and id and type(ScrollUtil)=="table" and type(ScrollUtil.GetDef)=="function" then
            local ok,v=pcall(function()return ScrollUtil:GetDef(id)end)
            if ok and type(v)=="table" then scrollDef=v end
        end
        if scrollDef==nil and id and type(ScrollDefinitions)=="table" then
            scrollDef=ScrollDefinitions[id]
        end
        if type(scrollDef)~="table" or (scrollDef.ID and scrollDef.ID~=id) then scrollDef=nil end
        if id then definitions[id]=scrollDef or false end
        local rarity=scrollDef and parseRarity(scrollDef) or nil
        if rarity==nil and not nativeOwned then rarity=parseRarity(raw) end
        local quality=(#attrs>=1 and #attrs<=4 and premium<=4 and (#attrs==4 or rarity~=nil)) and premium or nil
        local explicitBlocked=(scrollDef and scrollDef.CanTrade==false) or raw.Tradeable==false or raw.Tradable==false or raw.CanTrade==false
            or raw.Locked==true or raw.IsLocked==true or raw.IsListed==true or raw.Listed==true
        local record={UUID=uuid,Id=id,Name=name,Attrs=attrs,
            Rarity=rarity,GoodSum=goodSum or 0,
            Min=min,Max=max,Premium=quality,Source=origin,
            Blocked=not def or explicitBlocked,ExplicitBlocked=explicitBlocked}
        if previous then
            if previous.Id and record.Id and previous.Id~=record.Id then
                previous.Rarity=nil;previous.RarityConflict=true;previous.Blocked=true
                return true
            end
            if record.Rarity and not previous.RarityConflict then
                if previous.Rarity and previous.Rarity~=record.Rarity then
                    previous.Rarity=nil;previous.RarityConflict=true;previous.Blocked=true
                else previous.Rarity=record.Rarity end
            end
            if record.Id and not previous.Id then
                previous.Id=record.Id;previous.Name=record.Name;previous.Min=record.Min;previous.Max=record.Max
            end
            if #record.Attrs>#previous.Attrs then
                previous.Attrs=record.Attrs;previous.Premium=record.Premium;previous.GoodSum=record.GoodSum
            end
            previous.ExplicitBlocked=previous.ExplicitBlocked or record.ExplicitBlocked
            previous.Blocked=previous.RarityConflict or previous.ExplicitBlocked or not previous.Min or not previous.Max
            if previous.Premium==nil and previous.Rarity and #previous.Attrs>=1 and #previous.Attrs<=4 then
                -- Do not invent a score from missing attribute data. A richer
                -- record with a parsed score can safely supply it.
                if record.Premium~=nil and #record.Attrs==#previous.Attrs and table.concat(record.Attrs,"|")==table.concat(previous.Attrs,"|") then previous.Premium=record.Premium end
            end
        else
            items[#items+1]=record;seen[uuid]=record
        end
        return true
    end
    for _,src in ipairs(sources) do
        local walked={}
        local function walk(node,key,depth)
            if depth>6 or type(node)~="table" or walked[node] then return end
            walked[node]=true
            if register(node,key,src.Name) then return end
            for k,v in pairs(node) do
                if type(v)=="table" then walk(v,k,depth+1)
                elseif type(v)=="string" and v:lower():sub(1,7)=="scroll_"
                    and validScrollUUID(k) then
                    register({ItemId=v,UUID=k},k,src.Name)
                end
            end
        end
        walk(src.Value,nil,0)
    end
    table.sort(items,function(a,b)
        if (a.Premium or -1)~=(b.Premium or -1) then return (a.Premium or -1)>(b.Premium or -1) end
        if a.GoodSum~=b.GoodSum then return a.GoodSum>b.GoodSum end
        if a.Name~=b.Name then return a.Name<b.Name end
        return a.UUID<b.UUID
    end)
    return items,unresolved,table.concat(diagnostics," | ")
end
-- STALL_V6_PRICE_BEGIN
local function qualityPrice(record,multiplier)
    if not record.Min or not record.Max or record.Max<record.Min then return nil end
    local price=math.min(record.Max,math.ceil(record.Min*(multiplier or 1)))
    return intRange(price,record.Min,record.Max)
end
-- STALL_V6_PRICE_END
local function sameOwnedScroll(a,b)
    return a.UUID==b.UUID and a.Id==b.Id and a.Premium==b.Premium and a.Rarity==b.Rarity and
        table.concat(a.Attrs,"|")==table.concat(b.Attrs,"|") and
        a.Min==b.Min and a.Max==b.Max and not b.Blocked
end
-- Fast path uses the actual native UUID API; nil/error is never proof of removal.
local function liveOwnedScroll(record)
    if type(ScrollUtil)=="table" and type(ScrollUtil.GetOwnedScrollData)=="function" then
        local ok,raw=pcall(function()return ScrollUtil:GetOwnedScrollData(LocalPlayer,record.UUID)end)
        if not ok or type(raw)~="table" or raw.UUID~=record.UUID or raw.Id~=record.Id then return false end
        if raw.Tradeable==false or raw.Tradable==false or raw.CanTrade==false
            or raw.Locked==true or raw.IsLocked==true or raw.IsListed==true or raw.Listed==true then return false end
        local okDef,def=pcall(function()return ScrollUtil:GetDef(record.Id)end)
        if not okDef or type(def)~="table" or def.CanTrade==false or parseRarity(def)~=record.Rarity then return false end
        local market=index["Scroll\0"..record.Id]
        if not market or market.MinPrice~=record.Min or market.MaxPrice~=record.Max then return false end
        local attrs,_,premium=parseStats(raw)
        return premium==record.Premium and table.concat(attrs,"|")==table.concat(record.Attrs,"|")
    end
    local current=scanOwnedScrolls()
    for _,item in ipairs(current) do
        if sameOwnedScroll(record,item) then return true end
    end
    return false
end
local function sendScrollList(record,price)
    if saleAttempted[record.UUID] then return false,"UUID đã gửi trong phiên" end
    if record.Blocked or not validScrollUUID(record.UUID) or not record.Id then return false,"Scroll không tradeable" end
    if not record.Min or not record.Max or not intRange(price,record.Min,record.Max) then
        return false,"Giá ngoài Min/Max hoặc thiếu giới hạn"
    end
    return SaleGuard.Send("Scroll",record.Id,1,price,function(confirm)
        if confirm then
            if type(ScrollUtil)=="table" and type(ScrollUtil.GetOwnedScrollData)=="function" then
                local ok,raw=pcall(function()return ScrollUtil:GetOwnedScrollData(LocalPlayer,record.UUID)end)
                if not ok or raw~=nil then return false end
                -- Ensure profile is readable: GetAllOwned may return {} when not ready.
                local okBag,bag=pcall(function()return ScrollUtil:GetAllOwned(LocalPlayer)end)
                if okBag and type(bag)=="table" and next(bag)~=nil then return bag[record.UUID]==nil end
            end
            local items,unresolved,diagnostics=scanOwnedScrolls()
            if unresolved>0 or not diagnostics:find(":OK",1,true) then return false end
            for _,item in ipairs(items) do if item.UUID==record.UUID then return false end end
            return true
        end
        if not liveOwnedScroll(record) then return false,"Scroll đã thay đổi/không còn trong túi" end
        saleAttempted[record.UUID]=true
        return true
    end,record.UUID)
end
local updateBulkButtons
local refreshScrollSale
local V6={Rarity="ALL",Quality="POOR",Multiplier=1,Quantity=1,Tabs={},Drafts={},Mounted={}}
bulkBar.Size=UDim2.new(.972,0,.125,0)
local rarityBar=Instance.new("ScrollingFrame",bulkBar)
rarityBar.BackgroundTransparency=1;rarityBar.BorderSizePixel=0
rarityBar.Size=UDim2.new(1,0,.43,0);rarityBar.ScrollBarThickness=3
rarityBar.ZIndex=24
local function invalidateBulk()
    bulkPending=nil
    if updateBulkButtons then updateBulkButtons() end
end
local qualityButton
qualityButton=sellButton(bulkBar,"KÉM 0–1/5",.003,.50,.18,.45,function()
    local choices={"POOR",0,1,2,3,4,"ALL"}
    local selected=1
    for i,v in ipairs(choices) do if v==V6.Quality then selected=i end end
    V6.Quality=choices[selected%#choices+1]
    qualityButton.Text=V6.Quality=="POOR" and "KÉM 0–1/5"
        or V6.Quality=="ALL" and "MỌI CHẤT LƯỢNG" or tostring(V6.Quality).."/5"
    invalidateBulk()
end)
local multiplierButton
multiplierButton=sellButton(bulkBar,"MIN",.190,.50,.13,.45,function()
    V6.Multiplier=V6.Multiplier==1 and 1.5 or V6.Multiplier==1.5 and 2 or 1
    multiplierButton.Text=V6.Multiplier==1 and "MIN" or "MIN ×"..V6.Multiplier
    invalidateBulk()
end)
local quantityField=field(bulkBar,"Số lượng",.370,.50,.10,.45,"1")
quantityField.ZIndex=24
state.Conn[#state.Conn+1]=quantityField:GetPropertyChangedSignal("Text"):Connect(invalidateBulk)
sellButton(bulkBar,"−",.330,.50,.035,.45,function()
    quantityField.Text=tostring(math.max(1,(tonumber(quantityField.Text) or 1)-1))
end)
sellButton(bulkBar,"+",.475,.50,.035,.45,function()
    quantityField.Text=tostring(math.min(30,(tonumber(quantityField.Text) or 1)+1))
end)
-- STALL_V6_BULK_CORE_BEGIN
function V6.Select(items,rarity,quality,multiplier,limit)
    local selected={}
    for _,record in ipairs(items) do
        local q=record.Premium
        if (rarity=="ALL" or rarity=="UNKNOWN" and record.Rarity==nil or record.Rarity==rarity) and q~=nil
            and (quality=="ALL" or quality=="POOR" and q<=1 or q==quality)
            and not record.Blocked and not saleAttempted[record.UUID] then
            local price=qualityPrice(record,multiplier)
            if price then selected[#selected+1]={Record=record,Price=price} end
        end
    end
    table.sort(selected,function(a,b)
        local x,y=a.Record,b.Record
        if x.Premium~=y.Premium then return x.Premium<y.Premium end
        if x.GoodSum~=y.GoodSum then return x.GoodSum<y.GoodSum end
        return x.UUID<y.UUID
    end)
    while #selected>limit do table.remove(selected) end
    return selected
end
-- STALL_V6_BULK_CORE_END
sellButton(bulkBar,"MAX",.520,.50,.08,.45,function()
    if saleBusy or state.Busy or state.PurchaseBusy then return end
    saleBusy=true;state.SaleBusy=true;saleStop=false
    task.spawn(function()
        local free,err=SaleGuard.Free()
        if free then
            local items=scanOwnedScrolls()
            local list=V6.Select(items,V6.Rarity,V6.Quality,V6.Multiplier,free)
            quantityField.Text=tostring(#list)
            saleMsg("MAX: "..#list.." Scroll đủ điều kiện / "..free.." slot trống")
        else saleMsg(err) end
        saleBusy=false;state.SaleBusy=false
    end)
end)
local bulkSell
updateBulkButtons=function()
    if bulkSell then bulkSell.Text=bulkPending and "XÁC NHẬN BÁN" or "BULK SELL" end
end
bulkSell=sellButton(bulkBar,"BULK SELL",.620,.50,.37,.45,function()
    if saleBusy or state.Busy or state.PurchaseBusy then saleMsg("Đang có tác vụ khác");return end
    local requested=intRange(quantityField.Text,1,30)
    if not requested then saleMsg("Nhập số lượng nguyên 1–30");return end
    local rarity,quality,multiplier=V6.Rarity,V6.Quality,V6.Multiplier
    saleBusy=true;state.SaleBusy=true;saleStop=false
    task.spawn(function()
        local free,err=SaleGuard.Free()
        if free==nil then saleBusy=false;state.SaleBusy=false;saleMsg(err);return end
        local list=V6.Select(scanOwnedScrolls(),rarity,quality,multiplier,math.min(requested,free))
        if #list==0 then saleBusy=false;state.SaleBusy=false;saleMsg("Không có Scroll/slot đủ điều kiện");return end
        local parts={tostring(rarity),tostring(quality),tostring(multiplier),tostring(requested)}
        for _,entry in ipairs(list) do
            parts[#parts+1]=entry.Record.UUID..":"..entry.Price..":"..table.concat(entry.Record.Attrs,",")
        end
        local signature=table.concat(parts,"|")
        if V6.Rarity~=rarity or V6.Quality~=quality or V6.Multiplier~=multiplier
            or tonumber(quantityField.Text)~=requested then
            saleBusy=false;state.SaleBusy=false;invalidateBulk();saleMsg("Bộ lọc đã đổi; hãy bấm lại");return
        end
        if not bulkPending or bulkPending.Signature~=signature or os.clock()>bulkPending.Expires then
            bulkPending={Signature=signature,Expires=os.clock()+12}
            saleBusy=false;state.SaleBusy=false;updateBulkButtons()
            saleMsg("Bấm lại trong 12 giây: bán "..#list.." Scroll, ưu tiên điểm thấp; "..free.." slot trống")
            return
        end
        bulkPending=nil;updateBulkButtons()
        local confirmed=0
        for _,entry in ipairs(list) do
            if not state.Alive or saleStop then break end
            local ok,why=sendScrollList(entry.Record,entry.Price)
            if not ok then err=why;break end
            confirmed=confirmed+1
        end
        saleBusy=false;state.SaleBusy=false
        if state.Alive then refreshScrollSale() end
        saleMsg("Đã xác nhận "..confirmed.."/"..#list.." listing. "..(err or ""))
    end)
end)
function V6.Sell(record,price)
    if saleBusy or state.Busy or state.PurchaseBusy then saleMsg("Đang có tác vụ khác");return end
    saleBusy=true;state.SaleBusy=true;saleStop=false;invalidateBulk()
    task.spawn(function()
        local ok,err=sendScrollList(record,price)
        saleBusy=false;state.SaleBusy=false
        if state.Alive then refreshScrollSale() end
        saleMsg(ok and ("Đã xác nhận bán "..record.Name.." giá "..price) or tostring(err))
    end)
end
refreshScrollSale=function(useCache)
    if saleBusy then saleMsg("Đang chờ xác nhận bán");return end
    saleTitle.Text="SELL SCROLL | 5 LOẠI CHỈ SỐ TỐT | TỐI ĐA 30 LISTING"
    bulkPending=nil
    if state.ScrollWindowClear then state.ScrollWindowClear() end
    for _,child in ipairs(saleRows:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local items,unresolved
    if useCache==true and V6.CacheReady then
        items,unresolved=V6.CachedItems,V6.Unresolved
    else
        items,unresolved=scanOwnedScrolls()
        V6.CachedItems=items;V6.Unresolved=unresolved;V6.CacheReady=true
        V6.ScanAt=os.clock()
    end
    local rarities={}
    local unknown=0
    for id in pairs(rarityInfo) do rarities[id]=true end
    for _,record in ipairs(items) do
        if record.Rarity then rarities[record.Rarity]=true else unknown=unknown+1 end
    end
    local keys={}
    for id in pairs(rarities) do keys[#keys+1]=id end
    table.sort(keys,function(a,b)return a>b end)
    table.insert(keys,1,"ALL")
    if unknown>0 then keys[#keys+1]="UNKNOWN"
    elseif V6.Rarity=="UNKNOWN" then V6.Rarity="ALL" end
    for _,child in ipairs(rarityBar:GetChildren()) do child:Destroy() end
    for i,id in ipairs(keys) do
        local title=id=="ALL" and "ALL" or id=="UNKNOWN" and "CHƯA RÕ" or rarityStyle(id)
        local tab=sellButton(rarityBar,title,0,0,0,1,function()
            V6.Rarity=id;refreshScrollSale(true)
        end)
        tab.Position=UDim2.new((i-1)/#keys,0,0,0)
        tab.Size=UDim2.new(1/#keys,-4,1,-3)
        tab.BackgroundColor3=V6.Rarity==id and Color.Green or Color.Blue
    end
    rarityBar.CanvasSize=UDim2.fromOffset(0,0)
    local widths=state.FitColumns(items,saleRows.AbsoluteSize.X,true)
    local titles={"TÊN + ĐIỂM","CHỈ SỐ 1","CHỈ SỐ 2","CHỈ SỐ 3","CHỈ SỐ 4","MIN","MIN ×1.5","MIN ×2","GIÁ TAY / BÁN"}
    local columns,offsets={},{}
    local x=0
    for k,title in ipairs(titles) do
        columns[k]={title,x,widths[k]};offsets[k]=x;x=x+widths[k]
    end
    writeSaleHeader(columns,true)
    local function cell(row,text,x,w,color)
        local item=label(row,text,x+.003,.05,w-.006,.90,11,true,true)
        item.Font=Enum.Font.GothamBold;item.TextColor3=color or Color.Text;item.ZIndex=23
        return item
    end
    local filtered={}
    for _,record in ipairs(items) do
        if V6.Rarity=="ALL" or V6.Rarity=="UNKNOWN" and record.Rarity==nil or record.Rarity==V6.Rarity then
            filtered[#filtered+1]=record
        end
    end
    local function mount(record,visible)
            local row=Instance.new("Frame",saleRows)
            row.BackgroundColor3=Color.Field;row.BorderSizePixel=0
            row.Size=UDim2.new(1,-10,0,40);row.LayoutOrder=visible;row.ZIndex=22
            row.Position=UDim2.fromOffset(0,(visible-1)*45)
            local rarity,color=rarityStyle(record.Rarity)
            cell(row,record.Name.."\n"..rarity.." · "..tostring(record.Premium or "?").."/5",
                0,widths[1],color)
            for k=1,4 do
                local stat=record.Attrs[k] or "?"
                cell(row,stat,offsets[k+1],widths[k+1],goodStatText(stat)
                    and Color3.fromRGB(95,255,135) or Color3.fromRGB(205,210,220))
            end
            for k,mult in ipairs({1,1.5,2}) do
                local price=qualityPrice(record,mult)
                sellButton(row,price and tostring(price) or "N/A",offsets[k+5]+.002,.20,widths[k+5]-.004,.60,
                    function()V6.Sell(record,price)end)
            end
            local price=field(row,"Giá",offsets[9]+.003,.20,widths[9]*.59-.005,.60,V6.Drafts[record.UUID] or (record.Min and tostring(record.Min) or ""))
            price.ZIndex=24
            sellButton(row,record.Blocked and "KHÓA" or saleAttempted[record.UUID] and "ĐÃ GỬI" or "BÁN",
                offsets[9]+widths[9]*.60,.20,widths[9]*.40-.004,.60,function()V6.Sell(record,tonumber(price.Text))end)
            return {Frame=row,Price=price,UUID=record.UUID}
    end
    -- Keep only visible rows plus a small buffer. Unchanged rows are retained.
    -- Each row closure binds exactly one UUID; never retarget a live sell button.
    local function unmount(i)
        local entry=V6.Mounted[i]
        if entry then
            V6.Drafts[entry.UUID]=entry.Price.Text
            entry.Frame:Destroy()
            V6.Mounted[i]=nil
        end
    end
    state.ScrollWindowClear=function()
        for i in pairs(V6.Mounted) do unmount(i) end
        state.ScrollWindowUpdate=nil
    end
    saleLayout.Parent=nil
    saleRows.CanvasPosition=Vector2 and Vector2.zero or {Y=0}
    saleRows.CanvasSize=UDim2.fromOffset(0,#filtered*45+8)
    state.ScrollWindowUpdate=function()
        local y=saleRows.CanvasPosition and saleRows.CanvasPosition.Y or 0
        local h=saleRows.AbsoluteSize.Y or 500
        local first=math.max(1,math.floor(y/45)+1-3)
        local last=math.min(#filtered,math.ceil((y+h)/45)+3)
        for i in pairs(V6.Mounted) do
            if i<first or i>last then unmount(i) end
        end
        for i=first,last do
            if not V6.Mounted[i] then V6.Mounted[i]=mount(filtered[i],i) end
        end
        state.VisibleScrollRows=math.max(0,last-first+1)
        state.TotalScrollRows=#filtered
    end
    state.ScrollWindowUpdate()
    updateBulkButtons()
    saleMsg("Hiện "..#filtered.."/"..#items.." Scroll; "..unresolved.." thiếu UUID; "..unknown.." chưa rõ rarity." )
    if unknown>0 then print("[STALL_V62_RARITY] "..unknown.." instance(s) lack verified Scroll definition rarity.") end
end
-- STALL_V61_RESIZE_BEGIN
state.Conn[#state.Conn+1]=panel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    state.Dirty=true
    state.SellResize=true
end)
-- STALL_V61_RESIZE_END
state.Conn[#state.Conn+1]=saleRows:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if state.Alive and state.ScrollWindowUpdate and sale.Visible and panel.Visible then state.ScrollWindowUpdate() end
end)
-- CLONE_SHARD_TAB_BEGIN: four independent clone targets, one chosen owned Ore.
-- No client-side purchases or automatic shard transfers. Seller manually lists
-- exact-price stacks; a buyer still needs to purchase them in the game.
local clone
;(function()
clone=Instance.new("Frame",panel)
clone.Name="CloneShardPanel";clone.BackgroundColor3=Color.BG
clone.BorderSizePixel=0;clone.Visible=false;clone.ZIndex=25
clone.Position=UDim2.new(.008,0,.076,0);clone.Size=UDim2.new(.984,0,.906,0)
local function cloneLabel(parent,str,x,y,w,h,fontSize,bold,wrap)
    local obj=label(parent,str,x,y,w,h,fontSize,bold,wrap)
    obj.ZIndex=27
    return obj
end
local function cloneButton(parent,str,x,y,w,h,callback,tint)
    local obj=button(parent,str,x,y,w,h,callback,tint)
    obj.ZIndex=29
    return obj
end
local function cloneField(parent,str,x,y,w,h)
    local obj=field(parent,str,x,y,w,h,"")
    obj.ZIndex=29
    return obj
end
cloneLabel(clone,"CLONE | TÍNH ORE ÍT NHẤT ĐỂ NHẬN SHARDS",.018,.012,.77,.062,16,true)
cloneLabel(clone,"Chọn 1 Ore trong túi → nhập 4 khoản Shards → xem số viên + tổng giá treo.",
    .018,.087,.95,.056,12,false,true)
cloneButton(clone,"ĐÓNG",.827,.014,.15,.067,function()clone.Visible=false end,Color.Red)
cloneLabel(clone,"ORE TRONG TÚI (GIÁ MIN / MAX)",.018,.155,.398,.052,12,true)
local cloneInventory=Instance.new("ScrollingFrame",clone)
cloneInventory.Name="CloneOreInventory";cloneInventory.ZIndex=27
cloneInventory.Position=UDim2.new(.018,0,.219,0)
cloneInventory.Size=UDim2.new(.409,0,.590,0)
cloneInventory.BorderSizePixel=0;cloneInventory.BackgroundColor3=Color.Panel
cloneInventory.ScrollBarThickness=7;cloneInventory.CanvasSize=UDim2.fromOffset(0,0)
local cloneInventoryLayout=Instance.new("UIListLayout",cloneInventory)
cloneInventoryLayout.SortOrder=Enum.SortOrder.LayoutOrder
cloneInventoryLayout.Padding=UDim.new(0,4)
cloneInventoryLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    if cloneInventory.Parent then
        cloneInventory.CanvasSize=UDim2.fromOffset(0,cloneInventoryLayout.AbsoluteContentSize.Y+8)
    end
end)

local cloneSelected=nil
local clonePending=nil
local cloneInFlight={} -- cleared only after the shared guard confirms the result.
local cloneInputs,clonePreview={},{}
local cloneAllButton=nil
local cloneSelectedLabel=cloneLabel(clone,"Chưa chọn Ore",.442,.155,.537,.063,12,true,true)
cloneLabel(clone,"CLONE",.444,.236,.105,.04,11,true)
cloneLabel(clone,"SHARDS",.559,.236,.165,.04,11,true)
cloneLabel(clone,"ORE ÍT NHẤT",.737,.236,.16,.04,11,true)
local cloneTotalLabel=cloneLabel(clone,"Tổng: chưa tính",.442,.738,.538,.058,12,true,true)
local cloneStatus=cloneLabel(clone,"Chỉ tính giá treo (gross); phí game và mua thành công chưa được xác minh.",
    .018,.918,.96,.066,11,false,true)
local function cloneMsg(s)
    cloneStatus.Text=tostring(s):sub(1,400)
    print("[STALL_CLONE] "..tostring(s))
end
local function cloneOreRange(id)
    local record=index["Ore\0"..tostring(id)]
    if type(record)~="table" then return nil,nil end
    return intRange(record.MinPrice,1,1000000000),
        intRange(record.MaxPrice,1,1000000000)
end
local function cloneSignature(indexRow,id,plan)
    return tostring(indexRow).."|"..tostring(id).."|"..tostring(plan.Price)
        .."|"..tostring(plan.Quantity)
end
local function cloneCalculate()
    local bag,bagError=oreBag()
    local stock=bag and (tonumber(bag[cloneSelected]) or 0) or 0
    local minimum,maximum=nil,nil
    if cloneSelected then
        minimum,maximum=cloneOreRange(cloneSelected)
    end
    local info=cloneSelected and (cloneSelected.." | Túi: "..tostring(stock)
        .." | Min: "..tostring(minimum or "?")
        .." / Max: "..tostring(maximum or "?")) or "Chưa chọn Ore"
    cloneSelectedLabel.Text=info
    local plans,totalQty,totalPrice,validCount={},0,0,0
    local failure=nil
    for i=1,4 do
        local raw=cloneInputs[i].Text
        if not raw or raw:match("^%s*$") then
            clonePreview[i].Text="—"
        else
            local plan,reason=planCloneStack(raw,minimum,maximum,stock)
            if not cloneSelected then reason="Chưa chọn Ore";plan=nil end
            if not bag then reason=bagError or "Không đọc được túi";plan=nil end
            if plan then
                plan.Signature=cloneSignature(i,cloneSelected,plan)
                plans[i]=plan
                totalQty=totalQty+plan.Quantity
                totalPrice=totalPrice+plan.Price
                validCount=validCount+1
                clonePreview[i].Text=cloneInFlight[plan.Signature]
                    and "ĐÃ GỬI" or (tostring(plan.Quantity).." viên")
            else
                clonePreview[i].Text="KHÔNG HỢP LỆ"
                failure=failure or ("Clone "..i..": "..tostring(reason))
            end
        end
    end
    if not failure and validCount>0 and totalQty>stock then
        failure="Không đủ "..cloneSelected..": cần "..totalQty
            .." Ore cho cả 4; tồn "..stock
    end
    cloneTotalLabel.Text="Tổng "..validCount.." khoản: "..fmt(totalPrice)
        .." Shards | "..fmt(totalQty).." Ore | Tồn "..fmt(stock)
    return plans,failure,validCount,totalQty
end
local function cloneSnapshot(plans)
    local parts={tostring(cloneSelected)}
    for i=1,4 do
        parts[#parts+1]=plans[i] and plans[i].Signature or "-"
    end
    return table.concat(parts,";")
end

local function cloneSendPlans(plans,rows)
    if saleBusy or not state.Alive then cloneMsg("Đang bán hàng; không gửi trùng.");return end
    if not marketPlace() then cloneMsg("Phải ở Stall Market mới treo bán.");return end
    local bag,err=oreBag()
    if not bag then cloneMsg(err);return end
    local chosen=cloneSelected
    local available=tonumber(bag[chosen]) or 0
    local needed=0
    for _,i in ipairs(rows) do
        local plan=plans[i]
        if not plan then
            cloneMsg("Clone "..i..": chưa có plan hoặc đang chờ xác nhận.")
            return
        end
        needed=needed+plan.Quantity
    end
    if needed>available then
        cloneMsg("Không đủ túi: cần "..needed.." Ore, có "..available..".")
        return
    end
    saleBusy=true;state.SaleBusy=true;saleStop=false;clonePending=nil
    task.spawn(function()
        local sent,remaining=0,available
        for _,i in ipairs(rows) do
            if not state.Alive or saleStop then break end
            local plan=plans[i]
            local liveBag=oreBag()
            if not liveBag or (tonumber(liveBag[chosen]) or 0)<plan.Quantity
                or remaining<plan.Quantity then
                cloneMsg("Dừng: không đủ Ore hoặc dữ liệu túi thay đổi.")
                break
            end
            if not marketPlace() then cloneMsg("Dừng: đã rời Stall Market.");break end
            cloneInFlight[plan.Signature]=true
            local ok,sendErr=SaleGuard.Ore(chosen,plan.Quantity,plan.Price)
            if not ok then
                if not SaleGuard.Pending then cloneInFlight[plan.Signature]=nil end
                cloneMsg("Dừng Clone "..i..": "..tostring(sendErr));break
            end
            cloneInFlight[plan.Signature]=nil
            remaining=remaining-plan.Quantity
            sent=sent+1
            cloneMsg("Clone "..i..": đã gửi "..plan.Quantity.." "..chosen
                .." giá "..fmt(plan.Price).." Shards; server chưa xác nhận listing.")
            cloneCalculate()
            if sent<#rows then task.wait(.8) end
        end
        saleBusy=false;state.SaleBusy=false
        if state.Alive then
            cloneCalculate()
            cloneMsg("Hoàn tất gửi "..sent.."/"..#rows
                .." listing đã xác nhận."..(SaleGuard.Pending and " DỪNG: lệnh cuối chưa rõ kết quả." or ""))
        end
    end)
end
for i=1,4 do
    local row=i
    local y=.295+(i-1)*.109
    cloneLabel(clone,"Clone "..i,.443,y,.111,.072,12,true)
    cloneInputs[i]=cloneField(clone,"VD: 1560",.559,y,.162,.078)
    clonePreview[i]=cloneLabel(clone,"—",.735,y,.152,.078,12,true)
    cloneButton(clone,"TREO",.889,y,.087,.078,function()
        local plans,err=cloneCalculate()
        if not plans[row] then
            cloneMsg(err or "Clone "..row..": nhập mục tiêu hợp lệ trước.")
            return
        end
        cloneSendPlans(plans,{row})
    end,Color.Green)
end
for i=1,4 do
    state.Conn[#state.Conn+1]=cloneInputs[i]:GetPropertyChangedSignal("Text"):Connect(function()
        clonePending=nil
        if cloneAllButton then cloneAllButton.Text="TREO CẢ 4" end
        if state.Alive then cloneCalculate() end
    end)
end

local function cloneRefreshInventory()
    if saleBusy then cloneMsg("Đang gửi lệnh; chưa quét túi.");return end
    local bag,err=oreBag()
    if not bag then cloneMsg(err);return end
    local ids={}
    for id,count in pairs(bag) do
        if type(id)=="string" and (tonumber(count) or 0)>0 then
            ids[#ids+1]=id
        end
    end
    table.sort(ids)
    for _,child in ipairs(cloneInventory:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    if not cloneSelected or (tonumber(bag[cloneSelected]) or 0)<=0 then
        cloneSelected=nil
    end
    for j,id in ipairs(ids) do
        local row=Instance.new("Frame",cloneInventory)
        row.Name="CloneOre_"..id
        row.LayoutOrder=j
        row.Size=UDim2.new(1,-9,0,54)
        row.BackgroundColor3=Color.Field
        row.BorderSizePixel=0;row.ZIndex=28
        local mn,mx=cloneOreRange(id)
        local stock=tonumber(bag[id]) or 0
        local title=(id==cloneSelected and "✓ " or "")..id
            .." | "..fmt(stock).." viên"
            .." | "..tostring(mn or "?").."-"..tostring(mx or "?")
        cloneButton(row,title,.015,.10,.97,.80,function()
            cloneSelected=id
            clonePending=nil
            if cloneAllButton then cloneAllButton.Text="TREO CẢ 4" end
            cloneCalculate()
            cloneMsg("Đã chọn "..id..". Nhập các khoản Shards rồi bấm TREO.")
        end,id==cloneSelected and Color.Green or Color.Blue)
    end
    cloneCalculate()
    cloneMsg("Đã quét "..#ids.." loại Ore; chọn 1 loại có giá Min/Max hợp lệ.")
end
cloneButton(clone,"QUÉT LẠI TÚI",.019,.827,.192,.066,cloneRefreshInventory)
cloneButton(clone,"TÍNH LẠI",.440,.825,.160,.066,function()
    clonePending=nil
    if cloneAllButton then cloneAllButton.Text="TREO CẢ 4" end
    local _,err,n=cloneCalculate()
    cloneMsg(err or ("Đã tính "..n.." khoản theo giá Max/Ore, ưu tiên ít viên nhất."))
end)
cloneButton(clone,"DỪNG",.221,.827,.145,.066,function()
    saleStop=true
    clonePending=nil
    cloneMsg("Yêu cầu dừng sau lệnh đang gửi.")
end,Color.Red)
cloneAllButton=cloneButton(clone,"TREO CẢ 4",.616,.825,.359,.066,function()
    if saleBusy then cloneMsg("Đang gửi lệnh, hãy chờ.");return end
    local plans,err,count=cloneCalculate()
    if err or count==0 then
        clonePending=nil
        cloneMsg(err or "Nhập ít nhất một khoản Shards.")
        return
    end
    local signature=cloneSnapshot(plans)
    if not clonePending or clonePending.Signature~=signature
        or os.clock()>clonePending.Expires then
        clonePending={Signature=signature,Expires=os.clock()+12}
        cloneMsg("XÁC NHẬN: bán "..count.." stack, tổng "
            ..cloneTotalLabel.Text..". Bấm TREO CẢ 4 lần nữa trong 12 giây.")
        cloneAllButton.Text="XÁC NHẬN TREO"
        return
    end
    clonePending=nil
    cloneAllButton.Text="TREO CẢ 4"
    local rows={}
    for i=1,4 do if plans[i] then rows[#rows+1]=i end end
    cloneSendPlans(plans,rows)
end,Color.Green)

-- Clone and Sell are independent panels, but share the same saleBusy lock.
local cloneOpenButton=button(panel,"CLONE",.579,.017,.136,.055,function()
    clone.Visible=not clone.Visible
    if clone.Visible then
        sale.Visible=false
        cloneRefreshInventory()
    end
end,Color.Green)
end)()
-- CLONE_SHARD_TAB_END

sellButton(sale,"QUÉT ORE",.018,.072,.18,.05,refreshSale)
sellButton(sale,"DỪNG BÁN",.215,.072,.18,.05,function()
    saleStop=true;bulkPending=nil;updateBulkButtons()
    saleMsg("Đã yêu cầu dừng sau lệnh hiện tại; đã hủy xác nhận bán nhóm.")
end)
sellButton(sale,"QUÉT SCROLL",.425,.072,.32,.05,refreshScrollSale)

sellButton(sale,"ĐÓNG",.80,.008,.18,.055,function()sale.Visible=false end)
button(panel,"BÁN HÀNG",.440,.017,.129,.055,function()
    clone.Visible=false
    sale.Visible=not sale.Visible
    if sale.Visible and #saleRows:GetChildren()<=1 then refreshSale() end
end,Color.Green)

-- STALL-F7-UNIFIED-001 START: single button + F7 in the existing Stall UI.
-- Uses the shared BoothRE/BoothShows/StallView parser; no floating DEV overlay,
-- no automatic purchases, and no interaction with Dungeon AIO.
;(function()
    local sellerName="vnbshockler"
    local lastSent={} -- one shot per seller + listing UUID, even if price changes.
    local f7Busy=false
    local function exactBalance()
        local ok,value=pcall(function()
            local framework=require(RS:WaitForChild("Framework",6))
            local currency=framework and framework.Modules and framework.Modules.CurrencyUtil
            if type(currency)~="table" or type(currency.GetCount)~="function" then return nil end
            return currency:GetCount(LocalPlayer,"Gem")
        end)
        if not ok or type(value)~="number" or value~=value or value<0
            or value>1000000000 or value%1~=0 then
            return nil,"Không đọc được số dư Gem hợp lệ từ CurrencyUtil"
        end
        return value
    end
    local function waitFor(check,secs)
        local deadline=os.clock()+secs
        while state.Alive and not state.Cancel and os.clock()<deadline do
            local value=check()
            if value then return value end
            task.wait(.1)
        end
        return nil
    end
    local function buy()
        if f7Busy or not state.Alive then return end
        if not marketPlace() then say("F7: phải ở Trade Server");return end
        if state.Busy or state.PurchaseBusy or saleBusy then
            say("F7: đang scan/mua/bán, không gửi lệnh");return
        end
        f7Busy=true
        state.Busy=true
        state.Cancel=false
        task.spawn(function()
            local ok,err=xpcall(function()
                local ownerId=Players:GetUserIdFromNameAsync(sellerName)
                assert(type(ownerId)=="number" and ownerId>0,
                    "Không xác thực được UserId "..sellerName)
                assert(ownerId~=LocalPlayer.UserId,"Không mua hàng của chính mình")
                local balance,why=exactBalance()
                assert(balance and balance>0,why or "Origin Shard bằng 0")
                say("F7: tìm Stall "..sellerName.." | Shards "..balance)
                local before=state.RefreshCount
                local sent,reason=pcall(function()
                    BoothRE:FireServer("RequestBoothShows")
                end)
                assert(sent,"Không quét được BoothShows: "..tostring(reason))
                assert(waitFor(function()
                    return state.RefreshCount>before and state.SnapshotReceived
                end,8),"BoothShows timeout; không mua")
                local chosenSlot=nil
                for s,data in pairs(state.Stalls) do
                    if positiveUserId(data)==ownerId then
                        assert(not chosenSlot,"Có nhiều Stall cùng chủ, không tự chọn")
                        chosenSlot=s
                    end
                end
                assert(chosenSlot,"Không thấy quầy của "..sellerName)
                state.ResponseSlot=nil
                state.Full[chosenSlot]=nil
                state.FullAt[chosenSlot]=nil
                local mark=os.clock()
                say("F7: quầy #"..chosenSlot.."; xác minh listing Ore")
                local sentDetail,whyDetail=pcall(function()
                    BoothRE:FireServer("InteractStall",chosenSlot)
                end)
                assert(sentDetail,"StallView lỗi: "..tostring(whyDetail))
                assert(waitFor(function()
                    return state.ResponseSlot==chosenSlot
                        and (state.FullAt[chosenSlot] or 0)>=mark
                        and state.Full[chosenSlot]
                end,8),"StallView timeout; không mua")
                local detail=state.Full[chosenSlot]
                assert(positiveUserId(detail)==ownerId,
                    "Không xác minh được chủ quầy trong StallView")
                assert(type(detail.Items)=="table",
                    "StallView không có Items hợp lệ")
                local matches,seenListings={},{}
                for _,row in pairs(detail.Items) do
                    if type(row)=="table" then
                        local typ=str(row,"ItemType","Type","Category")
                        local itemId=str(row,"ItemID","ItemId","ItemIDStr","ItemName")
                        local price=number(row,"TotalPrice","ListingPrice",
                            "Price","SellPrice")
                        if typ=="Ore" and itemId and price==balance then
                            local id=getListingId(row,itemId)
                            assert(type(id)=="string" and #id>0 and #id<=128,
                                "Ore khớp giá nhưng thiếu ListingID")
                            if not lastSent[tostring(ownerId).."|"..id] and not seenListings[id] then
                                seenListings[id]=true
                                matches[#matches+1]={Id=id,Item=itemId,Price=price}
                            end
                        end
                    end
                end
                assert(#matches>0,"Không có Ore chưa gửi mua đúng "..balance.." Shards")
                table.sort(matches,function(a,b)return a.Id<b.Id end)
                local listing=matches[(LocalPlayer.UserId%#matches)+1]
                local confirmed,whyConfirm=exactBalance()
                assert(confirmed==balance,
                    whyConfirm or "Số dư Origin Shard đã thay đổi")
                -- The native listing is identified by ownerUserId and UUID,
                -- never by item name alone. Do not retry the same request.
                local fingerprint=tostring(ownerId).."|"..listing.Id
                assert(not lastSent[fingerprint],
                    "Đã gửi mua listing này trong phiên; không mua trùng")
                assert(state.Alive and not state.Cancel and marketPlace(),"Đã dừng hoặc rời Market")
                assert(state.Full[chosenSlot]==detail and positiveUserId(state.Stalls[chosenSlot])==ownerId,
                    "Quầy đã thay đổi; không mua")
                lastSent[fingerprint]=true
                local fired,whyFire=pcall(function()
                    BoothRE:FireServer("Purchase",ownerId,listing.Id)
                end)
                assert(fired,"Purchase FireServer lỗi: "..tostring(whyFire))
                state.PurchasesSent=state.PurchasesSent+1
                state.Full[chosenSlot]=nil
                state.FullAt[chosenSlot]=nil
                say("F7: đã GỬI mua "..listing.Item.." của "..sellerName..
                    " giá "..balance.." Shards. Server chưa xác nhận giao dịch.")
            end,debug.traceback)
            f7Busy=false
            state.Busy=false
            state.Dirty=true
            if not ok and state.Alive then
                say("F7 KHÔNG MUA: "..tostring(err):sub(1,220))
            end
        end)
    end
    state.F7BuyExact=buy
    button(panel,"F7 MUA",.719,.017,.101,.055,buy,Color.Green)
end)()
-- STALL-F7-UNIFIED-001 END

-- LowFX defaults ON while this standalone is active. This is reversible
-- when it is stopped or replaced by another scan version.
setLowFX(true)
for _,item in ipairs({search,minPrice,maxPrice}) do
    state.Conn[#state.Conn+1]=item:GetPropertyChangedSignal("Text"):Connect(function()
        state.Page=1;state.Dirty=true
    end)
end
-- STALL-B-LOBBY-001: manual B request, only in Market, never interrupt a sale.
-- Reuse exactly the WorldUtil TeleportWorld Lobby remote from AIO.
local lastStallBAt=-1000
local function stallBackLobby()
    if not state.Alive then return false end
    if not marketPlace() then say("B LOBBY chỉ dùng trong Market Place.");return false end
    if state.Busy or state.PurchaseBusy or saleBusy then
        say("B LOBBY: đang quét/mua/bán; hoàn tất hoặc dừng tác vụ rồi thử lại.")
        return false
    end
    local now=os.clock()
    if now-lastStallBAt<4 then
        say("B LOBBY: đã gửi gần đây; đợi 4 giây để tránh spam.")
        return false
    end
    local fw=RS:FindFirstChild("Framework")
    local gp=fw and fw:FindFirstChild("Gameplay")
    local wp=gp and gp:FindFirstChild("WorldPlace")
    local util=wp and wp:FindFirstChild("WorldUtil")
    local remote=util and util:FindFirstChild("RemoteEvent")
    if not remote and fw then
        -- Fallback to the Framework module API used by Modular AIO.
        local ok,module=pcall(require,fw)
        if ok and type(module)=="table" and type(module.Modules)=="table" then
            local worldUtil=module.Modules.WorldUtil
            remote=worldUtil and worldUtil.RemoteEvent
        end
    end
    if not remote or not remote:IsA("RemoteEvent") then
        say("B LOBBY: chưa tìm thấy WorldUtil.RemoteEvent; không gửi lệnh.")
        return false
    end
    lastStallBAt=now
    local ok,err=pcall(function()
        remote:FireServer("TeleportWorld","Lobby")
    end)
    if not ok then
        say("B LOBBY gửi lỗi: "..tostring(err))
        return false
    end
    state.PendingPurchase=nil -- no pending second-step purchase after leaving
    say("B LOBBY: đã gửi TeleportWorld Lobby. Chờ game xác nhận chuyển map.")
    print("[STALL_B_LOBBY] SENT; server transition not verified")
    return true
end
state.ReturnLobby=stallBackLobby
-- STALL-B-LOBBY-001 END
state.Conn[#state.Conn+1]=Input.InputBegan:Connect(function(key,handled)
    if not state.Alive or handled or Input:GetFocusedTextBox() then return end
    if key.KeyCode==Enum.KeyCode.H then
        panel.Visible=not panel.Visible
    elseif key.KeyCode==Enum.KeyCode.B then
        stallBackLobby()
    elseif key.KeyCode==Enum.KeyCode.F7 then
        if state.F7BuyExact then state.F7BuyExact() end
    end
end)
function state.Stop()
    state.Alive=false;state.Cancel=true;state.PendingPurchase=nil
    saleStop=true
    if state.ScrollWindowClear then state.ScrollWindowClear() end
    if not saleLayout.Parent then saleLayout:Destroy() end
    state.ScrollWindowClear=nil;state.ScrollWindowUpdate=nil
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
            if state.SellResize and not saleBusy and panel.Visible and sale.Visible and bulkBar.Visible then
                state.SellResize=false
                local ok,err=pcall(refreshScrollSale,true)
                if not ok then warn("[SCROLL_MARKET] resize error: "..tostring(err)) end
            end
            if state.Dirty and panel.Visible and not sale.Visible and not clone.Visible and os.clock()-state.LastRender>=.9 then
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