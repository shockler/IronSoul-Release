-- Generated launcher: Stable pinned, DEV remote, Stall remote manual-only.
local makeController = (function()
-- Lifecycle only; no gameplay changes. Adapters make this testable without Roblox.
return function(api, settings)
    local c = {busy = false, active = nil, generation = 0}
    function c.select(channel)
        if c.busy or (channel ~= "Stable" and channel ~= "Dev" and channel ~= "Stall") then return false end
        settings.channel = channel
        -- Trade is always manual; do not accidentally auto-enter Stall on the next session.
        if channel == "Stall" then settings.auto = false end
        api.save(settings)
        api.render(c, settings)
        return true
    end
    function c.auto(enabled)
        settings.auto = settings.channel ~= "Stall" and enabled == true
        api.save(settings)
        api.render(c, settings)
    end
    local function stop()
        local ok, reason = pcall(api.stop)
        if not ok then api.status("Cannot stop safely: " .. tostring(reason)); return false end
        c.active = nil
        return true
    end
    function c.back()
        c.generation = c.generation + 1
        api.cancel()
        c.busy = false
        local stopped = stop()
        api.show()
        api.render(c, settings)
        if stopped then api.status("Choose Stable, Dev or Stall (Trade). Auto Execute applies next session.") end
        return stopped
    end
    function c.run()
        if c.busy then return false end
        c.busy = true
        c.generation = c.generation + 1
        local generation = c.generation
        local channel = settings.channel
        api.render(c, settings)
        api.spawn(function()
            local started = false
            local ok, err = pcall(function()
                -- Download and compile before stopping a working version.
                local entry = api.prepare(channel)
                if generation ~= c.generation then return end
                if not stop() then error("Previous runtime could not stop") end
                started = true
                entry()
                if generation ~= c.generation then return end
                if not api.ready(channel) then error("Selected runtime did not become ready; see boot diagnostic") end
                c.active = channel
                api.hide()
                api.status(channel .. " running")
            end)
            if generation ~= c.generation then return end
            c.busy = false
            if not ok then
                if started then
                    local cleaned, cleanupError = pcall(api.stop)
                    c.active = nil
                    if not cleaned then err = tostring(err) .. " | Cleanup failed: " .. tostring(cleanupError) end
                end
                api.show()
                api.status("Launch failed: " .. tostring(err))
            end
            api.render(c, settings)
        end)
        return true
    end
    return c
end

end)()
-- Standalone launcher assembled with controller.lua. Requires executor HTTP/loadstring.
local env = (typeof(getgenv) == "function" and getgenv()) or shared
if env.IronSoulLauncher and env.IronSoulLauncher.Show then
    env.IronSoulLauncher.Show()
    return
end
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local settings = {channel = "Stable", auto = false}
local config = "IronSoul_Launcher_v1.json"
if type(readfile) == "function" then
    local ok, saved = pcall(function() return Http:JSONDecode(readfile(config)) end)
    if ok and type(saved) == "table" then
        if saved.channel == "Stable" or saved.channel == "Dev" or saved.channel == "Stall" then settings.channel = saved.channel end
        settings.auto = saved.channel ~= "Stall" and saved.auto == true
    end
end
local urls = {
    Stable = "https://raw.githubusercontent.com/shockler/IronSoul-Release/054166e11c327e089a3b4654a1c23c94044c069b/Stable_4.9.50f_EndlessFix.lua",
    Dev = "https://gist.githubusercontent.com/shockler/e5c91e83aa50c3ae26817319c25d153d/raw/IronSoul_DEV.lua",
}
local gui = Instance.new("ScreenGui")
gui.Name = "IronSoulLauncher"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100010
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0.9, 0, 0, 370)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.BackgroundColor3 = Color3.fromRGB(24, 28, 38)
panel.Parent = gui
local size = Instance.new("UISizeConstraint")
size.MaxSize = Vector2.new(440, 370)
size.Parent = panel
local function label(text, y, height)
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(1, -24, 0, height)
    v.Position = UDim2.fromOffset(12, y)
    v.BackgroundTransparency = 1
    v.TextColor3 = Color3.fromRGB(230, 235, 245)
    v.Font = Enum.Font.Gotham
    v.TextSize = 15
    v.TextWrapped = true
    v.Text = text
    v.Parent = panel
    return v
end
label("IRON SOUL | LAUNCHER", 8, 32)
local status = label("Choose Stable, Dev or Stall (Trade). STALL is manual.", 257, 92)
local function button(text, y)
    local v = Instance.new("TextButton")
    v.Size = UDim2.new(1, -24, 0, 34)
    v.Position = UDim2.fromOffset(12, y)
    v.BackgroundColor3 = Color3.fromRGB(43, 52, 70)
    v.TextColor3 = Color3.new(1, 1, 1)
    v.Font = Enum.Font.GothamSemibold
    v.TextSize = 15
    v.Text = text
    v.Parent = panel
    return v
end
local stable = button("Stable", 46)
local dev = button("Dev", 86)
local stall = button("Stall (Trade)", 126)
local auto = button("Auto Execute: OFF", 166)
local run = button("Run selected", 206)
local back = Instance.new("TextButton")
back.Size = UDim2.fromOffset(168, 36)
back.Position = UDim2.new(1, -180, 0, 8)
back.BackgroundColor3 = Color3.fromRGB(43, 52, 70)
back.TextColor3 = Color3.new(1, 1, 1)
back.Text = "Back to Launcher"
back.TextSize = 14
back.Parent = gui
local worker, timeoutThread
local api = {}
function api.status(text) status.Text = text end
function api.show() panel.Visible = true end
function api.hide() panel.Visible = false end
function api.save(value)
    if type(writefile) ~= "function" then
        api.status("Settings apply this session only: file storage unavailable.")
        return
    end
    local ok = pcall(function() writefile(config, Http:JSONEncode(value)) end)
    if not ok then api.status("Could not save settings; using this session only.") end
end
function api.render(c, value)
    stable.Text = (value.channel == "Stable" and "[Selected] " or "") .. "Stable"
    dev.Text = (value.channel == "Dev" and "[Selected] " or "") .. "Dev"
    stall.Text = (value.channel == "Stall" and "[Selected] " or "") .. "Stall (Trade)"
    auto.Text = value.channel == "Stall" and "Auto Execute: OFF (Stall manual)"
        or ("Auto Execute: " .. (value.auto and "ON" or "OFF"))
    run.Text = c.busy and "Loading..." or "Run selected"
    stable.Active = not c.busy
    dev.Active = not c.busy
    stall.Active = not c.busy
    auto.Active = not c.busy and value.channel ~= "Stall"
    run.Active = not c.busy
end
function api.stop()
    local runtime = env.IronSoulMainRuntime
    if runtime and runtime.Alive ~= false then
        if type(runtime.Stop) ~= "function" then error("AIO runtime has no Stop hook") end
        runtime.Stop()
        if runtime.Alive ~= false then error("AIO runtime remains alive") end
    end
    local trade = env.IronSoulMarketScanner
    local stopError
    if trade then
        if type(trade.Stop) == "function" then
            local ok, reason = pcall(trade.Stop)
            if not ok then stopError = "Stall v5 Stop failed: " .. tostring(reason) end
        else
            stopError = "Stall v5 runtime has no Stop hook (initialization incomplete)"
        end
        -- Also stop a partially initialized runtime. Native Stop restores low-FX
        -- and hidden players; its Alive/Cancel guards terminate queued work.
        trade.Alive = false
        trade.Cancel = true
        trade.PendingPurchase = nil
        for _, connection in pairs(trade.Conn or {}) do
            local ok, reason = pcall(function() connection:Disconnect() end)
            if not ok then stopError = (stopError or "Stall disconnect failed") .. ": " .. tostring(reason) end
        end
        if not stopError and env.IronSoulMarketScanner == trade then
            env.IronSoulMarketScanner = nil
        end
    end
    local tradeGui = Players.LocalPlayer.PlayerGui:FindFirstChild("IronSoulScrollMarketScannerV5")
    if tradeGui then tradeGui:Destroy() end
    if stopError then error(stopError) end
end
function api.ready(channel)
    if channel == "Stall" then
        local trade = env.IronSoulMarketScanner
        if type(trade) ~= "table" then error("Stall v5 did not register IronSoulMarketScanner") end
        if trade.Alive ~= true then error("Stall v5 runtime is not alive") end
        if type(trade.Stop) ~= "function" then error("Stall v5 initialization incomplete: Stop hook missing") end
        local tradeGui = Players.LocalPlayer.PlayerGui:FindFirstChild("IronSoulScrollMarketScannerV5")
        if not tradeGui or not tradeGui:IsA("ScreenGui") or tradeGui.Parent == nil then
            error("Stall v5 ScreenGui IronSoulScrollMarketScannerV5 is missing")
        end
        return true
    end
    local r = env.IronSoulMainRuntime
    return r and r.Alive == true and r.Gui and r.Gui.Parent ~= nil
end
function api.prepare(channel)
    if channel == "Stall" then
        api.status("Downloading Stall (Trade)...")
        local source = game:HttpGet("https://raw.githubusercontent.com/shockler/IronSoul-Release/main/Stall.lua")
        if type(source) ~= "string" or source:match("^%s*$") then
            error("Stall download returned empty source")
        end
        local entry, reason = loadstring(source, "IronSoul_Stall")
        if not entry then error(reason) end
        return entry
    end
    api.status("Downloading " .. channel .. "...")
    local source = game:HttpGet(urls[channel])
    if type(source) ~= "string" or #source < 1000 or not source:find("IronSoulMainRuntime", 1, true) then
        error("Channel has no published runtime yet")
    end
    local entry, reason = loadstring(source, "IronSoul_" .. channel)
    if not entry then error(reason) end
    return entry
end
function api.cancel()
    if timeoutThread then pcall(task.cancel, timeoutThread); timeoutThread = nil end
    if worker and coroutine.status(worker) ~= "dead" then pcall(task.cancel, worker) end
    worker = nil
end
local controller
function api.spawn(fn)
    worker = task.defer(function()
        fn()
        if timeoutThread then pcall(task.cancel, timeoutThread); timeoutThread = nil end
    end)
    timeoutThread = task.delay(60, function()
        timeoutThread = nil
        if controller.back() then
            api.status("Launch timed out. Runtime stopped; choose a channel to retry.")
        end
    end)
end
controller = makeController(api, settings)
stable.Activated:Connect(function() controller.select("Stable") end)
dev.Activated:Connect(function() controller.select("Dev") end)
stall.Activated:Connect(function() controller.select("Stall") end)
auto.Activated:Connect(function() controller.auto(not settings.auto) end)
run.Activated:Connect(function() controller.run() end)
back.Activated:Connect(function() controller.back() end)
env.IronSoulLauncher = {Show = api.show, Back = controller.back}
api.render(controller, settings)
if settings.auto then
    api.status("Auto Execute in 5 seconds. Turn OFF or press Back to cancel.")
    local initialGeneration = controller.generation
    task.delay(5, function()
        if settings.auto and controller.generation == initialGeneration then controller.run() end
    end)
end
