-- STALL-B-LOBBY-001: execute actual standalone hotkey source against safe mocks.
local f=assert(io.open("Stall.lua","rb"));local all=f:read("*a");f:close()
local a=assert(all:find("-- STALL-B-LOBBY-001:",1,true))
local b=assert(all:find("function state.Stop()",a,true))
local source=all:sub(a,b-1)
assert(source:find('remote:FireServer("TeleportWorld","Lobby")',1,true))
assert(source:find("Input:GetFocusedTextBox()",1,true))
assert(source:find("state.Busy or state.PurchaseBusy or saleBusy",1,true))
assert(source:find("Enum.KeyCode.B",1,true))
local function signal()
  local v={listeners={}}
  function v:Connect(fn)
    local c={active=true}
    function c:Disconnect()self.active=false end
    self.listeners[#self.listeners+1]={c=c,fn=fn}
    return c
  end
  function v:Fire(...)
    for _,t in ipairs(self.listeners) do if t.c.active then t.fn(...)end end
  end
  return v
end
local function node(children)
  local v={Children=children or {}}
  function v:FindFirstChild(name)return self.Children[name]end
  return v
end
local function case(saleBusy, fallback)
  local calls,logs={},{}
  local remote=node()
  function remote:IsA(kind)return kind=="RemoteEvent"end
  function remote:FireServer(...)
    calls[#calls+1]={...}
  end
  local wu=node(fallback and {} or {RemoteEvent=remote})
  local wp=node({WorldUtil=wu})
  local gp=node({WorldPlace=wp})
  local fw=node({Gameplay=gp})
  local RS=node({Framework=fw})
  local input={InputBegan=signal(),focused=false}
  function input:GetFocusedTextBox()return self.focused and {} or nil end
  local clock=100
  local gameOS={clock=function()return clock end}
  local visible=true
  local panel={Visible=visible}
  local state={Alive=true,Busy=false,PurchaseBusy=false,Conn={},PendingPurchase={}}
  local market=true
  local renderCalls={}
  local runService={Heartbeat=signal()}
  function runService:Set3dRenderingEnabled(on)renderCalls[#renderCalls+1]=on end
  local game={GetService=function(_,name)assert(name=="RunService");return runService end}
  local exports=assert(load("return function(RS,marketPlace,state,saleBusy,os,require,say,Input,panel,Enum,game,label,sale)\n"
    ..source.."\nreturn state.ReturnLobby\nend","real stall b mock","t"))()
  local run=exports(RS,function()return market end,state,saleBusy,gameOS,
    function()
      return {Modules={WorldUtil={RemoteEvent=remote}}}
    end,
    function(m)logs[#logs+1]=m end,input,panel,
    {KeyCode={H="H",B="B",F7="F7",F8="F8"}},game,function(_,text)return {Text=text}end,{Visible=false})
  return {
    input=input,state=state,remote=remote,calls=calls,logs=logs,panel=panel,run=run,renderCalls=renderCalls,
    setMarket=function(v)market=v end,setTime=function(v)clock=v end
  }
end
local test=case(false,false)
assert(test.state.NoRender==false and test.renderCalls[1]==true,"No Render defaults OFF")
test.input.InputBegan:Fire({KeyCode="F8"},false)
assert(test.state.NoRender==true and test.renderCalls[2]==false,"F8 disables 3D rendering")
test.input.InputBegan:Fire({KeyCode="F8"},false)
assert(test.state.NoRender==false and test.renderCalls[3]==true,"F8 restores rendering")
test.input.InputBegan:Fire({KeyCode="B"},true)
assert(#test.calls==0,"processed input must not teleport")
test.input.focused=true
test.input.InputBegan:Fire({KeyCode="B"},false)
assert(#test.calls==0,"typing must not teleport")
test.input.focused=false
test.state.Busy=true
test.input.InputBegan:Fire({KeyCode="B"},false)
assert(#test.calls==0,"scan busy must block")
test.state.Busy=false
test.state.PurchaseBusy=true
assert(test.run()==false,"pending purchase must block")
test.state.PurchaseBusy=false
test.setMarket(false)
assert(test.run()==false,"not at Market must block")
test.setMarket(true)
test.input.InputBegan:Fire({KeyCode="H"},false)
assert(test.panel.Visible==false,"H hide must still work")
test.input.InputBegan:Fire({KeyCode="B"},false)
assert(#test.calls==1,"B must request exactly one Lobby teleport")
assert(test.calls[1][1]=="TeleportWorld" and test.calls[1][2]=="Lobby")
assert(test.state.PendingPurchase==nil)
test.input.InputBegan:Fire({KeyCode="B"},false)
assert(#test.calls==1,"B must be throttled")
test.setTime(105)
assert(test.run()==true and #test.calls==2,"manual B can be retried after 4s")
local busy=case(true,false)
assert(busy.run()==false and #busy.calls==0,"saleBusy must block")
local fb=case(false,true)
assert(fb.run()==true and #fb.calls==1,"Framework Module WorldUtil fallback")
print("PASS STALL B: exact remote, H unaffected, suppress when typing/processed/busy, cooldown, fallback")
