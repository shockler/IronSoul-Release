-- Stall Clone shard planner — real source extraction + static listing safety.
local f=assert(io.open("Stall.lua","rb"))
local source=f:read("*a");f:close()
local startTag="-- CLONE_PLAN_CORE_BEGIN"
local endTag="-- CLONE_PLAN_CORE_END"
local a=assert(source:find(startTag,1,true))
local b=assert(source:find(endTag,a,true))
local pure=source:sub(a,b+#endTag-1)
local intRange=function(v,lo,hi)
    local n=tonumber(v)
    if n and n==n and n%1==0 and n>=lo and n<=hi then return n end
    return nil
end
local planner=assert(load("return function(intRange)\n"..pure..
    "\nreturn planCloneStack\nend","ClonePlan core","t"))()(intRange)
local cases={{1560,6},{1900,7},{4200,14},{5000,17}}
local sumOre,sumShards=0,0
for _,c in ipairs(cases) do
    local price,expectedQty=c[1],c[2]
    local res,err=planner(price,80,300,100)
    assert(res and not err,"expected valid plan for "..price)
    assert(res.Quantity==expectedQty,"minimum qty wrong for "..price)
    assert(res.Price==price,"exact listing total must equal requested price")
    assert(res.MinAllowed<=price and price<=res.MaxAllowed,"outside price range")
    assert((expectedQty-1)*300<price,"quantity is not mathematically minimal")
    sumOre=sumOre+res.Quantity
    sumShards=sumShards+res.Price
end
assert(sumOre==44 and sumShards==12660)
local result,reason=planner(79,80,300,100)
assert(not result and reason:find("khớp",1,true),"cannot sell below minimum total")
result,reason=planner(1560,80,300,5)
assert(not result and reason:find("Thiếu Ore",1,true),"must not over-sell inventory")
assert(not planner(1560,80,nil,100),"missing verified Max must fail closed")
assert(not planner(1560,nil,300,100),"missing verified Min must fail closed")
assert(not planner(1560,301,300,100),"inverted registry bounds must fail")
assert(not planner("1550.5",80,300,100),"fractional shard price must fail")
assert(not planner(0,80,300,100),"zero shard price must fail")
assert(not planner(1000000001,80,300,1000000),"per-stack cap enforced")
assert(not planner(1560,80,300,-1),"negative inventory must fail")
local p=assert(planner(300,300,300,1))
assert(p.Quantity==1 and p.Price==300)
local p2=assert(planner(301,80,300,2))
assert(p2.Quantity==2 and p2.MinAllowed==160)

local uiStart=assert(source:find("-- CLONE_SHARD_TAB_BEGIN",b,true))
local uiEnd=assert(source:find("-- CLONE_SHARD_TAB_END",uiStart,true))
local ui=source:sub(uiStart,uiEnd)
assert(ui:find("CloneShardPanel",1,true))
assert(ui:find("CloneOreInventory",1,true))
assert(ui:find("for i=1,4 do",1,true),"exactly 4 input slots")
assert(ui:find("cloneSent[plan.Signature]=true",1,true),
    "listing safety: suppress duplicate clicks in the session")
assert(ui:find("clonePending={Signature=signature,Expires=os.clock()+12}",1,true),
    "all-list requires two-step confirmation")
assert(ui:find('BoothRE:FireServer("ListStack","Ore",chosen,plan.Quantity,plan.Price)',1,true),
    "must use exact-quantity exact-total ListStack")
assert(ui:find("if not marketPlace()",1,true),"must require Market Place")
assert(ui:find("if saleBusy",1,true),"must respect shared sell lock")
assert(ui:find("if not state.Alive or saleStop then break end",1,true),
    "bulk send must honor stop")
assert(ui:find("cloneCalculate()",1,true),"plans must be rechecked before listing")
assert(ui:find("MinPrice",1,true) and ui:find("MaxPrice",1,true),
    "min/max bounds must come from the game registry")
assert(ui:find("Treo",1,true) or ui:find("TREO",1,true))
assert(source:find('clone.Visible=false',uiEnd,true),
    "opening existing Sell panel must close Clone panel")
assert(not ui:find("PurchaseStack",1,true),"Clone tab must never auto-purchase")
print("PASS: 4 Clone targets exact prices, min Ore, stock limits, 2-click confirmation, no auto purchase")
