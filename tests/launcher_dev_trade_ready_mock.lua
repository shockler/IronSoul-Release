-- Launcher DEV Trade readiness: use actual api.ready + api.stop source.
local f=assert(io.open("IronSoul_Launcher_Stall_V5.lua","rb"))
local all=f:read("*a");f:close()
local a=assert(all:find("function api.stop()",1,true))
local b=assert(all:find("function api.prepare(channel)",a,true))
local section=all:sub(a,b-1)
assert(section:find("env.IronSoulTradeBuyerF7",1,true))
assert(section:find("buyer.Panel:IsA",1,true))
local function playerGui()
    local v={}
    function v:FindFirstChild()return nil end
    return v
end
local p={LocalPlayer={PlayerGui=playerGui()}}
local api={}
local env={IronSoulTradeBuyerF7=nil,IronSoulMainRuntime=nil,
    IronSoulMarketScanner=nil}
local mocks=setmetatable({api=api,env=env,Players=p},{__index=_G})
assert(load(section,"launcher state slice","t",mocks))()
assert(api.ready("Dev")==nil or api.ready("Dev")==false)
local panel={Parent={}}
function panel:IsA(kind)return kind=="GuiObject"end
local buyer={Alive=true,Panel=panel,Stop=function()
    buyer.Alive=false
end}
-- Lua closures resolve the local declared above only after initialization;
-- assign Stop after creating buyer so tests use the real reference.
buyer.Stop=function() buyer.Alive=false end
env.IronSoulTradeBuyerF7=buyer
assert(api.ready("Dev")==true,"F7 Market Buyer must satisfy DEV ready")
assert(api.ready("Stable")==nil or api.ready("Stable")==false,
    "DEV Market runtime must NOT masquerade as Stable")
panel.Parent=nil
assert(not api.ready("Dev"),"detached F7 panel cannot signal DEV ready")
panel.Parent={}
api.stop()
assert(buyer.Alive==false,"back/channel switch must stop F7")
assert(env.IronSoulTradeBuyerF7~=nil or buyer.Alive==false)
env.IronSoulTradeBuyerF7=nil
local main={Alive=true,Gui={Parent={}}}
env.IronSoulMainRuntime=main
assert(api.ready("Dev")==true,"normal DEV AIO runtime must still be recognized")
assert(api.ready("Stable")==true,"existing Stable readiness must remain")
main.Stop=function() main.Alive=false end
api.stop()
assert(main.Alive==false,"AIO stop unchanged")
print("PASS LAUNCHER: DEV F7 Market recognized, Stable isolated, Back stops F7, normal AIO unaffected")
