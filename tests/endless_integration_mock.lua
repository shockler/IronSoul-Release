-- Integration: the actual standalone movement gate and noclip callback.
local f=assert(io.open('Stable_4.9.50f_EndlessFix.lua','rb'));local s=f:read('*a');f:close()
local a=assert(s:find('local function isTransitioning()',1,true))
local b=assert(s:find('-- ENDLESS_SAFE_ENTRY_BEGIN',a,true))
local active,teleport=false,false
local part={Parent={},CanCollide=true,IsA=function()return true end}
local char={GetDescendants=function()return {part}end}
local rt={Alive=true,HasCombatTarget=true,Collision={},EndlessSafeEntryActive=function()return active end}
local player={Character=char,GetAttribute=function()return teleport end}
local env=setmetatable({Runtime=rt,LocalPlayer=player,combatFarmEnabled=function()return true end,
 GamePlaceUtil={IsMain=function()return false end},
 table=setmetatable({clear=function(t)for k in pairs(t)do t[k]=nil end end},{__index=table})},{__index=_G})
local transition=assert(load(s:sub(a,b-1)..'\nreturn isTransitioning','real_transition_gate','t',env))()
env.isTransitioning=transition
assert(not transition());active=true;assert(transition());active=false;teleport=true;assert(transition());teleport=false
local marker='table.insert(Runtime.Connections, RunService.Stepped:Connect(function()'
a=assert(s:find(marker,1,true))+#marker;b=assert(s:find('\nend))',a,true))
local step=assert(load('return function()'..s:sub(a,b-1)..'\nend','real_collision_gate','t',env))()
step();assert(not part.CanCollide and rt.Collision[part]==true)
active=true;step();assert(part.CanCollide and next(rt.Collision)==nil,'restore physical floor collision before handoff')
step();assert(part.CanCollide,'do not reapply noclip while native transfer owns movement')
a=assert(s:find('function Runtime.TryEndlessEntry(',1,true));b=assert(s:find('\nend',a,true))+4
local entry=s:sub(a,b-1)
assert(not entry:find('startTransition',1,true),'no recorded-coordinate entry for Endless')
rt.EndlessSafeEntryTick=function()return true end
assert(load(entry,'real_legacy_entry_redirect','t',env))()
assert(rt.TryEndlessEntry(nil,nil,nil,false)==true and rt.TryEndlessEntry(nil,nil,nil,true)==true)
local watchdog=assert(s:find('local function watchdogTick()',1,true))
assert(s:find('Runtime.EndlessSafeEntryActive',watchdog,true)<s:find('if stuckWatch.Pending then',watchdog,true),'handoff precedes pending lobby watchdog')
assert(s:find('if Runtime.EndlessSafeEntryTick and Runtime.EndlessSafeEntryTick() then return end\n\t\t\tRuntime.ObserveRouteRun()',1,true),'guard precedes route tick')
print('INTEGRATION PASS: transition gate, collision restore, manual/auto entry redirect, route/watchdog ordering')

-- Execute the real patrol entry: it must return before pathfinding begins.
a=assert(s:find('local function walkPatrol(char, root, hum)',1,true))
b=assert(s:find('\naddSectionHeader("5.',a,true))
local stops=0
env.patrol={Busy=true};env.stopPatrol=function()stops=stops+1;env.patrol.Busy=false end
rt.EndlessPatrolBlocked=function()return true end
local walk=assert(load(s:sub(a,b-1)..'\nreturn walkPatrol','actual_patrol_gate','t',env))()
walk(nil,nil,nil);assert(stops==1,'cancel previously active patrol before it can search')
print('PATROL BLOCK PASS: actual walkPatrol never starts pathfinding before Endless entry confirmation')
