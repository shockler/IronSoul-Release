-- Endless Safe Entry mock: executes the REAL RouteCore guarded fragment.
-- Goal: game owns RoundDoor transfer; no blind TP, combat paused until safe floor.
local f=assert(io.open("Stable_4.9.50f_EndlessFix.lua","rb"))
local source=f:read("*a");f:close()
local a=assert(source:find("-- ENDLESS_SAFE_ENTRY_BEGIN",1,true))
local b=assert(source:find("-- ENDLESS_SAFE_ENTRY_END",a,true))
local segment=source:sub(a,b+#"-- ENDLESS_SAFE_ENTRY_END"-1)
assert(not segment:find("PivotTo(",1,true),"Never directly teleport into Endless arena")
assert(not segment:find("AssemblyLinearVelocity",1,true),"Do not override game physics")
assert(not segment:find("InvokeServer",1,true),"Game itself must trigger RoundDoor")

local mt={}
mt.__index=function(v,k)
    if k=="Magnitude" then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z) end
    if k=="Unit" then
        local m=math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)
        return setmetatable({X=v.X/m,Y=v.Y/m,Z=v.Z/m},mt)
    end
    if k=="Dot" then
        return function(_,rhs)return v.X*rhs.X+v.Y*rhs.Y+v.Z*rhs.Z end
    end
end
local function vec(x,y,z) return setmetatable({X=x,Y=y,Z=z},mt) end
mt.__sub=function(v,w)return vec(v.X-w.X,v.Y-w.Y,v.Z-w.Z)end
mt.__add=function(v,w)return vec(v.X+w.X,v.Y+w.Y,v.Z+w.Z)end
mt.__mul=function(v,k) return vec(v.X*k,v.Y*k,v.Z*k) end
local staging=vec(8537.64,473.59,2602.89)
local arena=vec(8569.24,273.70,-3742.76)
local function scenario()
    local clock=0
    local isTeleport=false
    local world="Endless1"
    local armed=true
    local doorAvailable=true
    local cfgVisible=true
    local rayAvailable=true
    local logs,moves={},{}
    local door={Name="Root",Position=staging+vec(0,0,-24),
        Parent={Name="Portal"},CanTouch=true,
        IsA=function(_,what)return what=="BasePart"end,
        GetFullName=function()return "Workspace.RoundDoor.Portal.Root" end}
    local folder={GetDescendants=function()return {door} end}
    local root={Name="HumanoidRootPart",Position=staging,
        CFrame={LookVector=vec(0,0,-1)}}
    local hum={Health=100,FloorMaterial="Concrete",MoveTo=function(_,dest)moves[#moves+1]=dest end}
    local char={FindFirstChild=function(_,name)return name=="HumanoidRootPart" and root end,
        FindFirstChildOfClass=function(_,name)return name=="Humanoid" and hum end}
    local function newCfg()
        return {GetAttribute=function(_,key) if key=="WorldId" then return world end
            if key=="GameRound" then return 1 end
            return nil
        end}
    end
    local cfg=newCfg()
    local rt={Alive=true,Owner=nil,RouteBusy=false,Log=function(s)logs[#logs+1]=s end,
        Acquire=function(self,name)
            if self.Owner then return nil end
            self.Owner={Name=name}
            return self.Owner
        end,
        Release=function(self,token)if self.Owner==token then self.Owner=nil end end,
        CancelPatrol=function()end,ClearTargets=function()end}
    -- Real source uses Runtime.Acquire() dot style, not Lua colon style.
    rt.Acquire=function(name)
        if rt.Owner then return nil end
        rt.Owner={Name=name}
        return rt.Owner
    end
    rt.Release=function(token) if rt.Owner==token then rt.Owner=nil end end
    local ws={
        FindFirstChild=function(_,name)
            if name=="RoundDoor" and doorAvailable then return folder end
        end,
        Raycast=function(_,origin,direction)
            if not rayAvailable or (root.Position-arena).Magnitude>50 then return nil end
            return {Position=vec(root.Position.X,root.Position.Y-3,root.Position.Z),
                Normal=vec(0,1,0),Instance={CanCollide=true}}
        end
    }
    local env=setmetatable({
        Runtime=rt,LocalPlayer={Character=char,GetAttribute=function(_,key)if key=="IsTeleporting" then return isTeleport end end},ReplicatedStorage={
            FindFirstChild=function(_,name)return name=="GameRoundCfg" and cfgVisible and cfg or nil end},
        Workspace=ws,GamePlaceUtil={IsMain=function()return false end},
        combatFarmEnabled=function()return armed end,
        isTransitioning=function()return isTeleport end,
        RaycastParams={new=function()return {}end},
        Enum={RaycastFilterType={Exclude="Exclude"},Material={Air="Air"}},
        Vector3={new=vec},os={clock=function()return clock end},
        stopPatrol=function()end,pcall=pcall
    },{__index=_G})
    assert(load(segment,"ENDLESS_REAL_GUARD","t",env))()
    return {
        rt=rt,logs=logs,moves=moves,root=root,hum=hum,char=char,env=env,
        tick=function(t) clock=t;return rt.EndlessSafeEntryTick() end,
        setWorld=function(w)world=w end,
        setTP=function(b)isTeleport=b end,
        setDoor=function(b)doorAvailable=b end,
        setRay=function(b)rayAvailable=b end,
        setCombat=function(b)armed=b end,
        setCfgVisible=function(b)cfgVisible=b end,
        rebindCfg=function()cfg=newCfg() end,
        door=door
    }
end

local x=scenario()
assert(x.rt.EndlessSafeEntryActive()==true,"Staging must arm before worker tick")
assert(x.tick(0)==true and x.rt.RouteBusy and x.rt.Owner.Name=="ENDLESS_SAFE_ENTRY")
assert(x.rt.EndlessSafeEntryPhase=="WAIT" and #x.moves==0)
x.tick(9.99)
assert(#x.moves==0,"Must wait ten seconds before walking")
x.tick(10.00)
assert(x.rt.EndlessSafeEntryPhase=="APPROACH" and #x.moves==1)
assert(x.moves[1].X==x.door.Position.X and x.moves[1].Z==x.door.Position.Z,"DEV walks to the live forward door; never a fixed arena TP")
x.root.Position=x.door.Position+vec(0,0,3)
x.tick(10.60)
assert(x.rt.EndlessSafeEntryPhase=="HANDOFF")
local count=#x.moves
x.setTP(true)
x.tick(11.00)
assert(#x.moves==count and x.rt.RouteBusy,"Never move during IsTeleporting")
x.setCfgVisible(false)
x.tick(11.10)
assert(x.rt.EndlessSafeEntryActive()==true and x.rt.RouteBusy,
    "Missing GameRoundCfg in native transfer must NOT release combat")
x.setCfgVisible(true)
x.rebindCfg()
x.root.Position=arena
x.tick(11.20)
assert(x.rt.EndlessSafeEntryPhase=="LANDING","Far transfer requires verified landing")
x.setTP(false)
x.tick(11.30)
x.tick(12.20)
assert(x.rt.RouteBusy and x.rt.Owner,"Cannot resume combat prematurely")
assert(x.tick(13.40)==false and not x.rt.RouteBusy and x.rt.Owner==nil)
assert(x.rt.EndlessSafeEntryPhase==nil and x.rt.EndlessSafeEntryActive()==false)
x.tick(15)
assert(#x.moves==count,"Never rearm after same-character landing")

-- Scanner can fail to expose RoundDoor, but walking straight must still work.
local noDoor=scenario()
noDoor.setDoor(false)
noDoor.tick(0);noDoor.tick(9.99)
assert(#noDoor.moves==0)
noDoor.tick(10)
assert(#noDoor.moves==1 and noDoor.moves[1].Z<staging.Z,
    "Forward approach must not depend on RoundDoor scanner")
noDoor.root.Position=arena
noDoor.tick(11);noDoor.tick(12);noDoor.tick(13.2)
assert(noDoor.rt.EndlessSafeEntryPhase==nil and not noDoor.rt.RouteBusy)

-- If raycast misses the streamed floor but Roblox Humanoid is grounded,
-- release Combat after two seconds; this covers the old indefinite LANDING.
local fallback=scenario()
fallback.setRay(false)
fallback.tick(0);fallback.root.Position=arena
fallback.tick(1);fallback.tick(2);fallback.tick(3.5)
assert(fallback.rt.EndlessSafeEntryPhase==nil and not fallback.rt.RouteBusy,
    "Grounded Humanoid must allow Combat to resume without raycast")

-- If neither raycast nor FloorMaterial confirms ground, stay protected.
local missing=scenario()
missing.setRay(false);missing.hum.FloorMaterial="Air"
missing.tick(0);missing.root.Position=arena
missing.tick(1);missing.tick(4)
assert(missing.rt.EndlessSafeEntryPhase=="LANDING" and missing.rt.RouteBusy)
missing.hum.FloorMaterial="Concrete"
missing.tick(5);missing.tick(7.2)
assert(not missing.rt.RouteBusy,
    "Guard must release once genuine floor is confirmed")

-- IsTeleporting remaining true must not be misreported as Combat resumed.
local flagged=scenario()
flagged.tick(0);flagged.root.Position=arena
flagged.setTP(true);flagged.tick(2);flagged.tick(14)
assert(flagged.rt.RouteBusy and flagged.rt.EndlessSafeEntryPhase=="LANDING")
flagged.setTP(false);flagged.tick(15);flagged.tick(17.2)
assert(not flagged.rt.RouteBusy)

-- Player death, leaving Endless, and turning off combat must always release
-- the exclusive movement owner. Other maps are unaffected.
local death=scenario()
death.tick(0);death.hum.Health=0;death.tick(0.1)
assert(not death.rt.RouteBusy and death.rt.Owner==nil)
local other=scenario()
other.setWorld("World1")
assert(other.rt.EndlessSafeEntryActive()==false)
assert(other.tick(0)==false and not other.rt.RouteBusy)
local off=scenario()
off.tick(0);off.setCombat(false);off.tick(0.1)
assert(off.rt.Owner==nil and off.rt.RouteBusy==false)

print("ENDLESS SAFE ENTRY PASS: 10s wait, straight fallback, game handoff, floor-release Combat, stuck-flag, death/off")

-- DEV selects the visible forward portal instead of blind forward stepping.
local sideways=scenario()
sideways.door.Position=staging+vec(12,0,-24)
sideways.tick(0);sideways.tick(10)
assert(sideways.moves[1].X==sideways.door.Position.X and sideways.moves[1].Z==sideways.door.Position.Z)
-- While native transfer temporarily drops the character, remain game-owned.
local absent=scenario();absent.tick(0)
absent.env.LocalPlayer.Character=nil;assert(absent.tick(11)==true)
absent.env.LocalPlayer.Character=absent.char
-- A never-activated door must time out into HOLD, never teleport or resume farm.
local timeout=scenario();timeout.setDoor(false);timeout.tick(0)
for t=10,60,2 do timeout.tick(t) end
assert(timeout.rt.EndlessSafeEntryPhase=="HOLD" and timeout.rt.RouteBusy)
assert(#timeout.moves<=8,'forward motion bounded to 96 studs')
-- Landing drift restarts the stability timer instead of releasing too early.
local drift=scenario();drift.tick(0);drift.root.Position=arena;drift.tick(1)
drift.root.Position=arena+vec(5,0,0);drift.tick(2.5);drift.tick(3.5)
assert(drift.rt.RouteBusy);assert(drift.tick(4.6)==false)
print('EXTRA PASS: DEV forward portal targeting, missing character, bounded HOLD, landing drift')

-- Regression: the waiting room can spawn outside the old fixed 180-stud sphere.
local shifted=scenario()
shifted.root.Position=staging+vec(1000,0,1000)
shifted.door.Position=shifted.root.Position+vec(0,0,-24)
assert(shifted.rt.EndlessSafeEntryActive(),'nearby native door must guard a shifted spawn')
assert(shifted.tick(0) and shifted.rt.RouteBusy)
shifted.tick(9.9);assert(#shifted.moves==0)
shifted.tick(10);assert(#shifted.moves==1)
assert(shifted.rt.EndlessSafeEntryPhase=='APPROACH','shifted spawn is not an arena landing')
shifted.root.Position=arena;shifted.tick(11);shifted.tick(13.1)
assert(not shifted.rt.RouteBusy)
print('SHIFTED SPAWN PASS: local RoundDoor detection and dynamic origin')

-- A fresh Lobby entry is guarded even before the RoundDoor streams in.
local fresh=scenario();local lobby=true
fresh.env.GamePlaceUtil.IsMain=function()return lobby end
fresh.tick(0);lobby=false
fresh.root.Position=staging+vec(2000,0,2000);fresh.setDoor(false)
assert(fresh.rt.EndlessPatrolBlocked(),'no search circles before verified entry')
assert(fresh.rt.EndlessSafeEntryActive());fresh.tick(5);fresh.tick(14.99)
assert(#fresh.moves==0);fresh.tick(15);assert(#fresh.moves==1)
local origin=fresh.root.Position
fresh.root.Position=origin+vec(5,0,-5);fresh.tick(17)
assert(fresh.moves[2].X==origin.X and fresh.moves[2].Z==origin.Z-24,'forward goals stay on original line despite sideways drift')
assert(not shifted.rt.EndlessPatrolBlocked(),'patrol lock ends only after confirmed landing')
local alreadyArena=scenario();alreadyArena.root.Position=arena;alreadyArena.setDoor(false)
assert(not alreadyArena.rt.EndlessSafeEntryActive(),'do not force forward walk on reinjection in arena without entry evidence')
print('ENTRY OWNERSHIP PASS: shifted Lobby entry, streaming gap, 10s boundary, drift-resistant line, arena reinjection')
