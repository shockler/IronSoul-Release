-- TRADE-004 | Stall QUICK LIST - single-screen, no confirmations or popups.
-- Actual listing: one click -> stacks sequential ListStack remote calls.
-- Each remote argument 5 is TOTAL per stack = qtyPerStack * unitPrice.
-- FireServer success does NOT prove server accepted a listing.
-- Standalone mode only; AIO/Stable/DEV code remains unchanged.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local FrameworkFolder=ReplicatedStorage:WaitForChild("Framework",8)
assert(FrameworkFolder,"TRADE004: Framework unavailable")
local Features=FrameworkFolder:WaitForChild("Features",8)
local BoothSystem=Features and Features:WaitForChild("BoothSystem",8)
local BoothRE=BoothSystem and BoothSystem:WaitForChild("BoothRE",8)
assert(BoothRE and BoothRE:IsA("RemoteEvent"),"TRADE004: BoothRE unavailable")
local Framework=require(FrameworkFolder)
local DataUtil=assert(Framework.Modules.DataUtil,"TRADE004: DataUtil unavailable")
local ForgeUtil=Framework.Modules.ForgeUtil
local TranslationUtil=Framework.Modules.TranslationUtil
local EquipmentData=Framework.Modules.EquipmentData
local env=(typeof(getgenv)=="function" and getgenv()) or shared
local previous=env.IronSoulTRADE002
if previous and type(previous.Stop)=="function" then pcall(previous.Stop) end
local oldGui=PlayerGui:FindFirstChild("IronSoulTRADE002Stall")
if oldGui then oldGui:Destroy() end
local UNIT_PRESETS={Hellstone10=80,Hellstone9=70,CurseBorne=60,Soulglass=54}
local session={Active=true,Busy=false,Rows={},LastSent=0}
env.IronSoulTRADE002=session
local function integer(v,lo,hi)
    local n=tonumber(v)
    if not n or n~=n or n==math.huge or n==-math.huge or n%1~=0 or
        n<lo or n>hi then return nil end
    return n
end
local function getBag()
    local ok,bag=pcall(function()
        return DataUtil:GetValue(LocalPlayer,{"Ores"})
    end)
    if not ok or type(bag)~="table" then return nil,"Không đọc được Ore Bag" end
    local result={}
    for id,count in pairs(bag) do
        if type(id)~="string" or not integer(count,0,100000000) then
            return nil,"Ore bag contains an unrecognized entry"
        end
        result[id]=count
    end
    return result
end
local function displayName(id)
    local name=id
    if TranslationUtil then
        local ok,value=pcall(function()
            return TranslationUtil:TranslateByKey("K_"..id:upper())
        end)
        if ok and type(value)=="string" and value~="" then
            name=value:gsub("<[^>]+>","")
        end
    end
    local level=nil
    if ForgeUtil then
        pcall(function()
            local def=ForgeUtil:GetDef(id)
            if def then level=integer(def.Level or def.Lv,0,999) end
        end)
    end
    if not level then
        level=integer(name:lower():match("lv%.?%s*(%d+)"),0,999)
    end
    return name,level
end
-- Keep the existing read-only Scroll attribute decoder for a future inline
-- inventory view. No Scroll listing remote has been verified, so it is NOT sent.
local ScrollUtil=Framework.Modules.ScrollUtil
local EquipmentUtil=Framework.Modules.EquipmentUtil
local KeyString=nil
pcall(function()
    KeyString=require(ReplicatedStorage:WaitForChild("Enum",3):WaitForChild("KeyString",3))
end)

local function scrollNumber(value)
    if type(value)=="number" and value==value and math.abs(value)<1000000000 then
        return string.format("%.12g",value)
    end
    if type(value)=="string" and #value<=50 and tonumber(value) then
        return string.format("%.12g",tonumber(value))
    end
    return nil
end
-- Preserve RAW values instead of guessing whether a bonus is % or flat.
local function flattenScrollAttrs(attrs)
    if type(attrs)~="table" then return nil end
    local fields={}
    local visited={}
    local overflow=false
    local function walk(tab,prefix,depth)
        if depth>4 then overflow=true return end
        if type(tab)~="table" or visited[tab] then return end
        visited[tab]=true
        local name=tab.Type or tab.Key or tab.Stat or tab.AttrType
        local value=tab.Value or tab.Amount or tab.Val
        if (type(name)=="string" or type(name)=="number") and scrollNumber(value) then
            fields[#fields+1]={Key=tostring(name),Value=scrollNumber(value)}
            return
        end
        for key,v in pairs(tab) do
            if #fields>=60 then overflow=true return end
            local path=(prefix=="" and tostring(key) or prefix.."."..tostring(key))
            local n=scrollNumber(v)
            if n then
                fields[#fields+1]={Key=path,Value=n}
            elseif type(v)=="table" then
                walk(v,path,depth+1)
            end
        end
    end
    walk(attrs,"",0)
    table.sort(fields,function(a,b)
        if a.Key~=b.Key then return a.Key<b.Key end
        return a.Value<b.Value
    end)
    if #fields==0 or overflow then return nil end
    local names={}
    for _,e in ipairs(fields) do names[#names+1]=e.Key.."="..e.Value end
    local signature=table.concat(names,"|")
    if #signature>3800 then return nil end
    return names,signature
end
local function scrollVariant(rawSignature)
    if not rawSignature or rawSignature=="" then return nil end
    local h1,h2=2166136261,5381
    for i=1,#rawSignature do
        local code=string.byte(rawSignature,i)
        h1=(h1*131+code)%4294967291
        h2=(h2*257+code)%4294967279
    end
    return "ATTR_"..#rawSignature.."_"..string.format("%08X%08X",h1,h2)
end
local function scanOwnedScrollRecords()
    if type(ScrollUtil)~="table" then
        return {},"ScrollUtil unavailable"
    end
    local sources,diagnostics={},{}
    local function add(label,ok,data)
        if ok and type(data)=="table" then
            sources[#sources+1]={Label=label,Data=data}
            diagnostics[#diagnostics+1]=label..":TABLE"
        else
            diagnostics[#diagnostics+1]=label..":NO_TABLE"
        end
    end
    for _,method in ipairs({"GetOwned","GetOwnedScrolls"}) do
        if type(ScrollUtil[method])=="function" then
            local ok,data=pcall(function()return ScrollUtil[method](ScrollUtil,LocalPlayer)end)
            add("ScrollUtil."..method,ok,data)
        end
    end
    local keys=type(KeyString)=="table" and KeyString.ScrollUtil or nil
    local root=type(keys)=="table" and (keys.Scrolls or keys.Scroll or keys.Name) or nil
    local owned=type(keys)=="table" and (keys.Owned or keys.Inventory) or nil
    local candidatePaths={
        {"Scrolls","Owned"},{"Scroll","Owned"},{"Scrolls"},
        {"OwnedScrolls"}
    }
    if type(root)=="string" and type(owned)=="string" then
        table.insert(candidatePaths,1,{root,owned})
    end
    if type(root)=="string" then
        candidatePaths[#candidatePaths+1]={root}
    end
    local pathSeen={}
    for _,path in ipairs(candidatePaths) do
        local label=table.concat(path,"/")
        if not pathSeen[label] then
            pathSeen[label]=true
            local ok,data=pcall(function()return DataUtil:GetValue(LocalPlayer,path)end)
            add("DataUtil."..label,ok,data)
        end
    end
    -- Even if the owned inventory path is not exposed, show confirmed equipped
    -- Scrolls for actual equipped weapon classes (not guessed class strings).
    if EquipmentData and EquipmentUtil then
        local ok,gear=pcall(function()return EquipmentData:GetOwned(LocalPlayer)end)
        if ok and type(gear)=="table" then
            local classes={}
            for uuid,item in pairs(gear) do
                local e,equipped=pcall(function()
                    return EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)
                end)
                if e and equipped==true then
                    local info=nil
                    pcall(function() info=EquipmentUtil:GetEquipmentInfo(LocalPlayer,uuid) end)
                    local class=(type(info)=="table" and info.Class)
                        or (type(item)=="table" and item.Class)
                    if type(class)=="string" and #class<60 then classes[class]=true end
                end
            end
            for class in pairs(classes) do
                if type(ScrollUtil.GetEquippedScroll)=="function" then
                    local yes,data=pcall(function()
                        return ScrollUtil:GetEquippedScroll(LocalPlayer,class)
                    end)
                    if yes and type(data)=="table" then
                        add("Equipped."..class,true,{data})
                    end
                end
            end
        end
    end
    local records,knownUUID,seenContainers={},{},{}
    local count=0
    local function addOne(raw,path,source)
        local attr=raw.Attrs or raw.Attributes or raw.BonusAttrs
        local id=raw.Id or raw.ID or raw.ScrollId
        if id==nil or type(attr)~="table" then return false end
        local fields,signature=flattenScrollAttrs(attr)
        local uuid=raw.UUID or raw.Uuid or raw.UID
        if uuid==nil and type(path)=="string" then
            local trailing=path:match("([^./]+)$")
            if trailing and #trailing>=10 and not trailing:match("^%d+$") then uuid=trailing end
        end
        local uuidKey=tostring(uuid or "")
        if uuidKey~="" and knownUUID[uuidKey] then return true end
        local def=nil
        if type(ScrollUtil.GetDef)=="function" then
            pcall(function()def=ScrollUtil:GetDef(id)end)
        end
        local skill=(type(def)=="table" and (def.SkillId or def.SkillID))
            or raw.SkillId or raw.SkillID
        local level=integer(raw.Level or raw.Lv,0,999)
        local variant=scrollVariant(signature)
        count=count+1
        records[#records+1]={
            Id=tostring(id),Skill=skill and tostring(skill) or "UNKNOWN_SKILL",
            Level=level,UUID=uuidKey,RawSignature=signature,
            Variant=variant,Attrs=fields or {},Source=source,
            PriceEligible=variant~=nil,
        }
        if uuidKey~="" then knownUUID[uuidKey]=true end
        return true
    end
    local function inspect(node,path,source,depth)
        if count>=500 or depth>5 or type(node)~="table" or seenContainers[node] then return end
        seenContainers[node]=true
        if addOne(node,path,source) then return end
        for key,v in pairs(node) do
            if type(v)=="table" then
                inspect(v,path.."."..tostring(key),source,depth+1)
            end
        end
    end
    for _,entry in ipairs(sources) do
        inspect(entry.Data,entry.Label,entry.Label,0)
    end
    table.sort(records,function(a,b)
        local x,y=a.Skill..a.Id,b.Skill..b.Id
        if x~=y then return x<y end
        return (a.RawSignature or "")<(b.RawSignature or "")
    end)
    return records,table.concat(diagnostics,"; ")
end


local gui=Instance.new("ScreenGui")
gui.Name="IronSoulTRADE002Stall"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.DisplayOrder=100005 -- game Stall below; Launcher Back is 100010
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=PlayerGui
local panel=Instance.new("Frame")
panel.Name="StallPanel"
panel.Size=UDim2.new(.92,0,.85,0)
panel.Position=UDim2.new(.04,0,.055,0)
panel.BackgroundColor3=Color3.fromRGB(17,22,32)
panel.BorderSizePixel=0
panel.Parent=gui
local function label(parent,content,x,y,w,h,color)
    local o=Instance.new("TextLabel")
    o.BackgroundTransparency=1
    o.Text=content
    o.TextColor3=color or Color3.fromRGB(231,236,245)
    o.TextSize=17
    o.Font=Enum.Font.SourceSans
    o.TextWrapped=true
    o.TextXAlignment=Enum.TextXAlignment.Left
    o.Position=UDim2.new(x,0,y,0)
    o.Size=UDim2.new(w,0,h,0)
    o.Parent=parent
    return o
end
local function button(parent,content,x,y,w,h,callback)
    local o=Instance.new("TextButton")
    o.BackgroundColor3=Color3.fromRGB(54,77,111)
    o.TextColor3=Color3.new(1,1,1)
    o.TextSize=17
    o.Font=Enum.Font.SourceSansBold
    o.Text=content
    o.Position=UDim2.new(x,0,y,0)
    o.Size=UDim2.new(w,0,h,0)
    o.Parent=parent
    o.MouseButton1Click:Connect(callback)
    return o
end
local function field(parent,placeholder,x,y,w,h,default)
    local o=Instance.new("TextBox")
    o.BackgroundColor3=Color3.fromRGB(29,37,52)
    o.TextColor3=Color3.new(1,1,1)
    o.Font=Enum.Font.SourceSans
    o.TextSize=18
    o.Text=default or ""
    o.PlaceholderText=placeholder
    o.ClearTextOnFocus=false
    o.Position=UDim2.new(x,0,y,0)
    o.Size=UDim2.new(w,0,h,0)
    o.Parent=parent
    return o
end

-- TRADE-003: isolated, client-only, REVERSIBLE Trade performance controls.
-- No gameplay state changes and no AIO Ultra Low Graphics v2 module dependency.
-- LOW FX hides non-essential VFX and local world lights; HIDE OTHERS is optional.
local UserInputService=game:GetService("UserInputService")
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local lowFxClasses={
    ParticleEmitter=true,Trail=true,Beam=true,Fire=true,Smoke=true,Sparkles=true,
    PointLight=true,SpotLight=true,SurfaceLight=true,
    BloomEffect=true,SunRaysEffect=true,DepthOfFieldEffect=true,BlurEffect=true,
}
local perf={
    FxActive=false,HideActive=false,FxGeneration=0,HideGeneration=0,
    FxChanges=setmetatable({}, {__mode="k"}),
    PlayerChanges=setmetatable({}, {__mode="k"}),
    FxConns={},PlayerConns={},PlayersById={},
}
local function disconnectAll(conns)
    for _,conn in ipairs(conns) do
        pcall(function() conn:Disconnect() end)
    end
    for i=#conns,1,-1 do conns[i]=nil end
end
local function rememberAndSet(bucket,obj,key,newValue)
    if not obj then return end
    local ok,previousValue=pcall(function() return obj[key] end)
    if not ok or previousValue==newValue then return end
    local saved=bucket[obj]
    if not saved then saved={};bucket[obj]=saved end
    if saved[key]==nil then saved[key]=previousValue end
    local changed=pcall(function() obj[key]=newValue end)
    if not changed and saved[key]==previousValue then saved[key]=nil end
end
local function restoreBucket(bucket)
    for obj,fields in pairs(bucket) do
        for prop,original in pairs(fields) do
            pcall(function()
                if obj and obj.Parent~=nil then obj[prop]=original end
            end)
        end
        bucket[obj]=nil
    end
end
local function applyLowFx(obj)
    if perf.FxActive and lowFxClasses[obj.ClassName] then
        rememberAndSet(perf.FxChanges,obj,"Enabled",false)
    end
end
local function enableLowFx()
    if perf.FxActive or not session.Active then return end
    perf.FxActive=true
    perf.FxGeneration=perf.FxGeneration+1
    local generation=perf.FxGeneration
    rememberAndSet(perf.FxChanges,Lighting,"GlobalShadows",false)
    table.insert(perf.FxConns,Workspace.DescendantAdded:Connect(applyLowFx))
    table.insert(perf.FxConns,Lighting.DescendantAdded:Connect(applyLowFx))
    task.spawn(function()
        -- One one-time chunked pass; don't rescan all of Workspace every frame.
        for _,container in ipairs({Workspace,Lighting}) do
            local objects=container:GetDescendants()
            for i,obj in ipairs(objects) do
                if not session.Active or not perf.FxActive or
                    perf.FxGeneration~=generation then return end
                applyLowFx(obj)
                if i%180==0 then task.wait() end
            end
        end
    end)
end
local function disableLowFx()
    perf.FxActive=false
    perf.FxGeneration=perf.FxGeneration+1
    disconnectAll(perf.FxConns)
    restoreBucket(perf.FxChanges)
    perf.FxChanges=setmetatable({}, {__mode="k"})
end
local function hideOtherPart(obj)
    if perf.HideActive and obj:IsA("BasePart") then
        rememberAndSet(perf.PlayerChanges,obj,"LocalTransparencyModifier",1)
    end
end
local function hideOtherCharacter(character,epoch)
    if not perf.HideActive or not character or perf.HideGeneration~=epoch then return end
    for i,obj in ipairs(character:GetDescendants()) do
        if not perf.HideActive or perf.HideGeneration~=epoch then return end
        hideOtherPart(obj)
        if i%100==0 then task.wait() end
    end
    if perf.HideActive and perf.HideGeneration==epoch then
        table.insert(perf.PlayerConns,character.DescendantAdded:Connect(hideOtherPart))
    end
end
local function connectOtherPlayer(player)
    if not perf.HideActive or player==LocalPlayer or
        perf.PlayersById[player] then return end
    perf.PlayersById[player]=true
    table.insert(perf.PlayerConns,player.CharacterAdded:Connect(function(character)
        task.spawn(function() hideOtherCharacter(character,perf.HideGeneration) end)
    end))
    if player.Character then
        task.spawn(function() hideOtherCharacter(player.Character,perf.HideGeneration) end)
    end
end
local function enableHideOthers()
    if perf.HideActive or not session.Active then return end
    perf.HideActive=true
    perf.HideGeneration=perf.HideGeneration+1
    table.insert(perf.PlayerConns,Players.PlayerAdded:Connect(connectOtherPlayer))
    for _,player in ipairs(Players:GetPlayers()) do connectOtherPlayer(player) end
end
local function disableHideOthers()
    perf.HideActive=false
    perf.HideGeneration=perf.HideGeneration+1
    disconnectAll(perf.PlayerConns)
    perf.PlayersById={}
    restoreBucket(perf.PlayerChanges)
    perf.PlayerChanges=setmetatable({}, {__mode="k"})
end
local function stopTradePerf()
    disableHideOthers()
    disableLowFx()
end
local lowFxButton
lowFxButton=button(panel,"LOW FX: ON",.555,.007,.20,.044,function()
    if perf.FxActive then disableLowFx() else enableLowFx() end
    lowFxButton.Text="LOW FX: "..(perf.FxActive and "ON" or "OFF")
end)
local hidePlayersButton
hidePlayersButton=button(panel,"HIDE OTHERS: OFF",.765,.007,.22,.044,function()
    if perf.HideActive then disableHideOthers() else enableHideOthers() end
    hidePlayersButton.Text="HIDE OTHERS: "..(perf.HideActive and "ON" or "OFF")
end)

label(panel,"STALL | TRADE-003 | QUICK LIST | H ẨN/HIỆN",.012,.003,.53,.055)
label(panel,"Mỗi dòng: Số stack × Số viên/stack × Giá/viên. Bấm LIST để gửi trực tiếp.",.017,.065,.95,.06)
local header=Instance.new("Frame")
header.BackgroundColor3=Color3.fromRGB(38,49,70)
header.BorderSizePixel=0
header.Position=UDim2.new(.015,0,.135,0)
header.Size=UDim2.new(.97,0,.063,0)
header.Parent=panel
label(header,"VẬT PHẨM / TỒN KHO",.015,.03,.395,.94)
label(header,"STACKS",.414,.03,.112,.94)
label(header,"VIÊN/STACK",.538,.03,.146,.94)
label(header,"GIÁ/VIÊN",.70,.03,.137,.94)
local listArea=Instance.new("ScrollingFrame")
listArea.Name="ItemList"
listArea.Position=UDim2.new(.015,0,.207,0)
listArea.Size=UDim2.new(.97,0,.68,0)
listArea.BackgroundColor3=Color3.fromRGB(22,29,41)
listArea.BorderSizePixel=0
listArea.ScrollBarThickness=8
listArea.CanvasSize=UDim2.new(0,0,0,0)
listArea.Parent=panel
local listLayout=Instance.new("UIListLayout")
listLayout.Padding=UDim.new(0,4)
listLayout.Parent=listArea
local listConn=listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listArea.CanvasSize=UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+8)
end)
local status=label(panel,"Sẵn sàng. Bấm LIST trên dòng muốn bán.",.018,.936,.89,.055,Color3.fromRGB(245,203,137))
local function inform(textValue)
    status.Text=tostring(textValue):sub(1,550)
    print("[TRADE004] "..tostring(textValue))
end
local function listRow(row)
    if not session.Active then return end
    if session.Busy then inform("Đang gửi stack khác; chờ gửi xong.") return end
    local stacks=integer(row.Stacks.Text,1,30)
    local qty=integer(row.Qty.Text,1,1000000)
    local unitPrice=integer(row.Price.Text,1,1000000000)
    if not stacks or not qty or not unitPrice then
        inform("Nhập số nguyên hợp lệ: Stacks 1–30; Viên/stack và Giá/viên phải > 0.")
        return
    end
    local total=qty*unitPrice
    if total>1000000000 then
        inform("Tổng giá mỗi stack vượt giới hạn an toàn 1 tỷ.")
        return
    end
    local required=stacks*qty
    local bag,err=getBag()
    if not bag then inform(err) return end
    local held=bag[row.Id] or 0
    if required>held then
        inform(row.Title..": cần "..required.." viên ("..stacks.."×"..qty
            .."), túi chỉ có "..held..". Chưa gửi.")
        return
    end
    session.Busy=true
    row.Button.Text="0/"..stacks
    inform(row.Title..": bắt đầu gửi "..stacks.." stacks × "..qty
        .." viên, giá "..unitPrice.."/viên; tổng/stack "..total..".")
    task.spawn(function()
        local sent=0
        for i=1,stacks do
            if not session.Active then break end
            local liveBag,liveErr=getBag()
            if not liveBag or (liveBag[row.Id] or 0)<qty then
                inform("DỪNG: số lượng thay đổi; đã gửi "..sent.."/"..stacks
                    ..". "..tostring(liveErr or "Không đủ hàng"))
                break
            end
            -- This is a deliberate user-requested batch. No preview, extra
            -- type-LIST confirmation, or automatic retry on uncertain result.
            local ok,sendErr=pcall(function()
                BoothRE:FireServer("ListStack","Ore",row.Id,qty,total)
            end)
            if not ok then
                inform("LỖI GỬI "..(i).."/"..stacks..": "..tostring(sendErr)
                    .."; không thử gửi lại tự động.")
                break
            end
            sent=sent+1
            row.Button.Text=sent.."/"..stacks
            inform(row.Title..": đã gửi "..sent.."/"..stacks
                .." lệnh (chưa xác nhận server đăng thành công).")
            if i<stacks then task.wait(.7) end
        end
        session.Busy=false
        row.Button.Text="LIST"
        session.LastSent=sent
        if session.Active then
            inform("XONG "..row.Title..": gửi "..sent.."/"..stacks
                .." lệnh; xem gian hàng game để xác nhận listing.")
        end
    end)
end
local function scan()
    if session.Busy then inform("Đang gửi. Không quét lại lúc này.") return end
    local bag,err=getBag()
    if not bag then inform(err) return end
    local saved={}
    for _,row in ipairs(session.Rows) do
        saved[row.Id]={row.Stacks.Text,row.Qty.Text,row.Price.Text}
    end
    for _,child in ipairs(listArea:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    session.Rows={}
    local entries={}
    for id,count in pairs(bag) do
        if count>0 then
            local title,level=displayName(id)
            entries[#entries+1]={Id=id,Title=title,Level=level or -1,Count=count}
        end
    end
    table.sort(entries,function(a,b)
        if a.Level~=b.Level then return a.Level>b.Level end
        return a.Id<b.Id
    end)
    for _,entry in ipairs(entries) do
        local rowPanel=Instance.new("Frame")
        rowPanel.Name="OreRow"
        rowPanel.BackgroundColor3=Color3.fromRGB(35,44,63)
        rowPanel.BorderSizePixel=0
        rowPanel.Size=UDim2.new(1,-10,0,60)
        rowPanel.Parent=listArea
        local d=saved[entry.Id] or {}
        local row={Id=entry.Id,Title=entry.Title}
        label(rowPanel,entry.Title.." | x"..entry.Count,.015,.10,.39,.8)
        row.Stacks=field(rowPanel,"Stacks",.414,.18,.109,.64,d[1] or "1")
        row.Qty=field(rowPanel,"Qty",.538,.18,.142,.64,
            d[2] or tostring(math.min(entry.Count,10)))
        row.Price=field(rowPanel,"Price",.695,.18,.140,.64,
            d[3] or (UNIT_PRESETS[entry.Id] and tostring(UNIT_PRESETS[entry.Id]) or ""))
        row.Button=button(rowPanel,"LIST",.848,.18,.142,.64,function()
            listRow(row)
        end)
        session.Rows[#session.Rows+1]=row
    end
    inform("Đã quét "..#entries.." loại Ore. Chọn dòng, nhập Stacks/Viên/Giá rồi bấm LIST.")
end
button(panel,"QUÉT LẠI",.018,.891,.14,.044,scan)
label(panel,"Chỉ hỗ trợ Ore. Scroll/Gear/Potion/Skin chưa có remote bán được xác minh.",
    .17,.890,.79,.045,Color3.fromRGB(184,194,209))
local hKeyConnection
hKeyConnection=UserInputService.InputBegan:Connect(function(input)
    if not session.Active or input.KeyCode~=Enum.KeyCode.H then return end
    if UserInputService:GetFocusedTextBox()~=nil then return end
    gui.Enabled=not gui.Enabled
end)
function session.Stop()
    session.Active=false -- queued stack sends stop on next loop
    if hKeyConnection then hKeyConnection:Disconnect();hKeyConnection=nil end
    if listConn then listConn:Disconnect();listConn=nil end
    stopTradePerf()
    if gui.Parent then gui:Destroy() end
end
enableLowFx()
scan()
