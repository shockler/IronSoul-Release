-- 4.9.50f Endless hotfix: wait 10s, walk forward, native RoundDoor, verified landing before farm.
-- Iron Soul Dungeon AIO v4.9.50f | Standalone ASTRAL + UNDERGROUND MODE (from v4.9.50e)
-- Five exclusive combat modes. ASTRAL_UG maps to existing Astral scheduler,
-- owns underground movement and does NOT automatically surface on target loss.
-- TEST ONLY: Static audit; live Roblox/Luau validation still required.
-- New: Underground Hover (exclusive), Wheel of Luck (1215s + AutoFarm Lobby return),
-- Forge safety separation and verified UUID Bow sell, orphan worker recovery,
-- Endless Tower per-account counter, UpdateLog rewards in F6.
-- OFFLINE PATCH ONLY: MUST LIVE TEST in Roblox/Delta. Never run simultaneously with old AIO.
--[[
IRON SOUL DUNGEON | AIO v4.9.49 | 2026-11-10
BOOT COMPILER FIX: v4.9.48 diagnostic reported local register limit 200 at
  former line 12476 when allocating `clone` within Utilities initialization.
  Wrap the existing Utilities/Spin/Clone Forge initializer in its own closure:
  it now has a distinct function local-register budget. NO feature deleted.
  Runtime behavior/remote calls remain unchanged, no auto-hatch reactivation.
  Local diagnostics should report COMPILE OK before testing in Delta.
  Only source/structural checks can be performed offline here.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.48 FINAL MONOLITHIC (BASE) | 2026-11-10
UI-only stabilization before Modular Source + Single-file AIO migration.
- CODE contains original Clone Forge, F.E.B.S, and clone graphics controls.
- SPIN responsive 2 columns; Race Slot1/2 hotkeys persist per account.
- Utilities Grocery fully in right column; descriptions shortened.
- Auto Hatch and experimental DPS three-gear scanner hidden, source retained.
- No Dungeon/Combat/Forge remote or worker behavior intentionally changed.
  Syntax and mock checks are NOT equivalent to live Roblox verification.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.48 | 2026-11-10
PATCH: Siege3 native pad activation mirrors World (teleport -> MoveTo 5 studs
  in four directions -> confirm ScreenMatch + EnterRoomId -> CreatRoom -> WaitTeleport).
  CODE tab uses responsive GCode/Exchange left + Daily right columns.
  Manual Clone Forge in Lobby auto-disarms background Trash, allows Auto Combat.
  Forge Target labels are compact numeric recipes: 4-Scepter, 15-Heavy Helmet.
CODE TAB: persisted 20s GCodes + 1s GS_11 EventHall exchange with manual
  numeric request count, independent ON/OFF and attempts not falsely called rewards.
DAILY: Siege3 five, World1 Diff1 three, Endless three (server validation needed).
MELEE: anchor +10 on target root instead of giant NPC top for M1 hover.
CLONE F.E.B.S: Sell confirmed unlocked unequipped Bow before EquipBest.
DUNGEON TEST HISTORY: One-click + to queue a Description for the NEXT
  full Dungeon run; newest completion shows Time / Deaths / Description.
  Queue supports multiple sequential build tests, per-account persistence,
  and retry of a note when a run fails/is incomplete. No premature results.
  Existing last-five history files are migrated without data loss.
KEEP: v4.9.43 Rush Q/E/R/G, Solo Stuck30, TP routes, Forge, Boss/DPS.
VALIDATION: offline syntax/invariant checks; Delta live test pending.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.43 | 2026-11-10
BOOT HOTFIX: Luau ambiguous-syntax at former v4.9.42 line 7837.
  Prefix watchdog function expression with ';' so it is parsed as an
  independent statement, not another argument list of preceding task.spawn.
  No changes to the Rush/Combat/Route/Forge/Watchdog behaviors.
  Requires live Delta compile confirmation.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.42 | 2026-11-10
ASTRAL RUSH: replace the global FAST PHASE GUI with independent RUSH Q/E/R/G,
saved per account. ON shortens inter-stage/End waits but still sends EVERY
server-defined stage in order; OFF retains the existing normal stage timing.
Rush only applies in confirmed Astral Rastar mode, not to other combat modes.
One-stage Scroll G: ON uses existing Rapid G worker; OFF normal shared caster.
Previously saved global FastSkillPhases=true is migrated ONCE to all four Rush
flags so existing Fast ON users are not silently changed; can toggle each OFF.
COMBAT UI: clear group headings for Mode / Safety / Cast altitude / Rush;
blue Rush vs green enabled cast/mode, gray inactive and explanatory hints.
NO CHANGE: Stuck 30s watchdog, Combat TP height, Recorded Room TP, Forge,
DPS, death replay, boss targeting or the number/order of skill phases.
VALIDATION: static source and packaging checks only, LIVE Delta not verified.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.41 | 2026-11-10
BOOT HOTFIX: isolate Stuck 30s watchdog inside a separate function scope
so added local variables do NOT consume the parent AIO Luau local-register
budget. This addresses possible loadstring compile failures that surface as
"attempt to call a nil value" from LocalScript line 1.
KEEP: Solo STUCK 30S: HP=0 OR no valid enemy, then request TeleportWorld Lobby
without toggling AutoFarm OFF; bounded retries. Combat TP and saved room routes
not changed. Source-only review; live Delta compiler result not verified.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.40 | 2026-11-10
BASE: v4.9.39, minimal stuck-recovery patch only.
STUCK WATCHDOG (Solo Auto Farm ONLY): in a loaded Dungeon, 30 seconds
  without a detectable valid enemy, OR Humanoid HP=0 continuously for 30s,
  requests the existing WorldUtil RemoteEvent: TeleportWorld, Lobby.
  Keeps AutoFarm ON so the existing Lobby entry loop can start a new run.
  A changed room/character or a genuinely visible enemy resets the relevant
  30-second clock; map-loading/isTeleporting are excluded.
  Bounded 3 attempts, 8 seconds apart; a sent Remote is NOT server success.
  The watchdog overrides pending Play Again ONLY after the 30-second stuck limit.
KEEP: NO raycast/height changes to mob TP; NO raycast or Y correction on
  user-verified Recorded Room TP. Forge/FEBS/DPS/Routing unchanged.
VALIDATION: offline source invariants only; confirm in Roblox/Delta.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.39 | 2026-11-09
1) DEATH/PLAY AGAIN: explicit VotePlayAgain remains VotePlayAgain after terminal
   death. Sends the existing GameRoundRE vote with bounded retry; no automatic
   BackLobby fallback in that mode. Other end actions retain old recovery.
2) WORLD1 DIFF1/2/3: synchronize a newly reported room to its saved entry if
   the character remains physically in the previous room. Optional stale-clear
   recovery requires a witnessed enemy and >=9 seconds with no room enemies;
   never uses Diff5 coordinates and never hops on time alone.
3) CLONE MODE: teleport directly beside the highest-priority mob at its
   own ground-level combat height (NO Hover/MoveTo), M1 0.10s + real skills.
   Smart Dodge defaults OFF when selecting CLONE.
4) TARGET: detected Boss > highest MaxHP > nearest within current-room guard;
   sticky target with bounded preemption only for materially stronger mobs.
5) COMBAT: three-column analytics table (NO: 1-5, clear duration, deaths)
   records the five most recent full successful Dungeon runs, per account.
6) KEEP: World1 recorder coordinates, Clone Forge, two-column Combat, four QERG
   DESCEND toggles, Fast Phase, VIP 1400 / no Ore Guard and Halloween safety.
OFFLINE SOURCE REVIEW ONLY: Delta/server damage, death replay and W1 clear
   recovery MUST be checked in real game. A client vote can be rejected by server.
--]]

--[[
IRON SOUL AIO v4.9.38 | CHANGELOG (HISTORY) | 2026-11-09
BASE: v4.9.37 No Ore Guard VIP 1400. This is the 4.9.38 update, NOT a duplicate.
1) COMBAT GUI: real 2-column layout (modes/settings on left, Q/E/R/G on right).
   The four skill controls are simple ON/OFF DESCEND-to-cast toggles;
   casting phases remain resolved from equipped actual Skill IDs.
2) MELEE: corrected ordinary Hover to +12 studs instead of auto +30;
   Smart Dodge ON/OFF is exposed and the auto-profile no longer forces it ON.
3) ROUTE: accept manually saved airborne Room coordinates without requiring
   a successful floor raycast; still verify arrival and room progression.
4) UTILITIES: CLONE FORGE rotation: Weapon 3 ores, Helmet-target 6 ores,
   Armor-target 10 ores, selecting highest ore Level then Rarity.
   Uses Armor forge type for Helmet/Armor targets; subtype is server RNG.
   After crafting, verify inventory/UUID before Equip Best and protected Sell.
   Clone Forge requires a stable LOBBY; Dungeon forging is not verified.
5) FORGE GUI: remove unused Manual E Pause and Forge E Diagnostics buttons.
6) BOOT: guard hidden legacy Recorder refresh on fresh clone accounts to
   prevent nil-coordinate boot errors; Recorder v1.5 remains standalone.
7) KEEP: World1 Diff1/2/3 CFrames, Diff5 routes, VIP1400 No Ore Guard,
   Fast Phase toggle, Astral Rastar special skills, Halloween safe dodge.
VALIDATION: static code/ZIP checks only; Roblox/Delta live operation not verified.
--]]

--[[
IRON SOUL AIO v4.9.37 | 2026-11-09
- REMOVE ORE CAPACITY GUARD from GUI and disable forced Lobby/Auto Entry block on ores.
- VIP capacity 1400 shown only as information; never assume old 500/550 safety threshold.
- HOTFIX: hidden legacy Recorder list no longer crashes startup on nil world/diff coordinate.
- Combat/Dungeon/Forge other than Ore Guard unchanged.
W1 Diff 1/2/3 CFrame routes from Recorder 1.5; Diff5 kept.
Historical v4.9.37: three modes RANGE/MELEE/ASTRAL. v4.9.39 adds CLONE.
Fast phase toggle keeps stage count but may lose server multi-hits; per-skill aim/descent persisted.
AIO GUI hidden on boot (H). Halloween lateral dodge validates multi-point floor samples
and conservative 52-stud leash; bounds/server HP protection remain NOT verified in Delta.
Forge/Dungeon/Grocery still from v4.9.35. Do not inject v4.9.35 simultaneously.
]]

--[[
IRON SOUL DUNGEON AIO v4.9.35 | UNIVERSAL +30 / PER-SKILL DESCENT | 2026-11-09
- Automatic weapon/skill identification for Astral Rastar, Staff S5, Bow and generic dynamic resolver.
- Single AUTO COMBAT button; separate Astral Halloween +30/lateral dodge preset.
- Recorder hidden in AIO navigation; standalone Recorder v1.5 remains independent.
- Compact 30/60-minute FULL dungeon clear times. DPS inventory scan remains experimental.
- Server-side damage/hit acceptance NOT verified. Test in Delta before long farming.
--]]

-- IRON SOUL AIO v4.9.31: OPT-IN ASTRAL ORBIT LURE +12 / BURST +30, dynamic Q/E/R/G, 2026-11-09.
-- v4.9.30 RETRIEVED + DISPLAY-ORDER FIX: 6 DPS columns in user-requested order. No change to scoring.
--[[
IRON SOUL DUNGEON | AIO v4.9.30 | 2026-11-09
GEAR DPS TABLE (owned inventory):
- 'SCAN BEST 3' automatically opens a full inventory table: best weapon, armor, helmet,
  their names, levels and ATK Bonus / Skill DMG / Crit Rate / Crit DMG (percent).
- Full inventory beneath the top 3, grouped by gear category with equipped/selected labels.
- Gear with UNRECOGNIZED Attrs remains visible but is EXCLUDED from the search when
  recognized alternatives exist. No assumption that missing Attrs = 0%.
- Sort each gear category by expected full-build score when replacing the corresponding
  recommended slot, not by a misleading isolated multiplier.
- Export detailed schema of sampled raw owned/info item fields for parser debugging.
- Keep Pet/Scroll/Total manual override, Forge3, mixed4 ores, Spin, Hatch, all Combat.
- Display-only: DOES NOT auto-equip, forge or sell anything.
- Exact source schema, in-game stats and server damage NOT VERIFIED in Roblox/Delta.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.29 | 2026-11-09
- AUTO CLAIM finished eggs: PetsHatchUtil.RemoteEvent:FireServer("Claim", slot) for verified READY slots 1..3.
- Verify CLAIM creates a FREE slot before StartHatch, then verify BUSY after starting new egg.
- Hatch LOOP toggle checks every 10s in Lobby. OFF at injection; unknown schema/failed remote -> fail closed.
- Detect ready only from explicit claim-ready status/flag or verified Unix-epoch finish time.
- Keep v4.9.28 Gear DPS tables, mixed4 Forge KEEP, Spin, manual E protections and all Combat.
- Static parse only; actual server recognition of PetHatch.Slots fields not yet verified.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.32 | 2026-11-09
ASTRAL RASTAR SKILL-FIRST COMBAT (experimental):
  - Q Astral Orbit = forced safe horizontal cast, even with Astral Orbit lure/burst ON.
    Optional 0.12s quick phase test; ordinary mode uses configured stage time.
  - E Stellar Singularity = quick stage1/end at hover; R Cosmic Convergence
    = phase1/2 quick, phase3 4.65s preserve 9-hit window, phase4/end.
    Optional fast-R stage3 test; tick persistence unverified.
  - Rapid G (one-stage <=0.35s Scroll) is available outside legacy Scepter
    mode when Astral Rastar is equipped; yields to Q/E/R, never guarantees hits.
  - Q/E/R/G get priority over M1. Rastar M1 only uses spare windows and sends
    proper BulletShoot: stages 1-3 (nil,{Idx,Pos}), stage4 ({Idx,Enemy}).
    Projectile hit acceptance and coordination with skills unverified.
  - Preserves v4.9.31 orbit lure, v4.9.30 full inventory DPS table and all
    Forge/Spin/Hatch logic. Offline validation only, not live gameplay-tested.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.28 | 2026-11-09
- DPS Gear scan now displays a readable, full-screen table for EVERY owned Weapon,
  Armor and Helmet with translated name (when available), level and four DPS stats.
- Best 3-item build highlighted; equipped items marked separately. Missing parsed
  stats display '?' and never count as confirmed 0%.
- Richer attribute decoders (dictionary/list/struct), slot/level identification,
  and one-click schema debug export. No gear equip/sell/forge from the DPS scan.
- Keep Forge3, mixed-4 ore KEEP, Spin, Hatch, Combat and old controls.
- Offline syntax only. Live game item schema still needs runtime verification.

- FIX UI: Hatch is not a blank UID form anymore. SCAN EGGS reads PetHatch.Egg
  and PetHatch.Slots, reports human-readable statuses and prepares candidates.
  AUTO HATCH fills confirmed-empty slots sequentially, verifying data changes
  after each request. Unknown slot/UID schema -> STOP safely, no guessed IDs.
  Manual UID is now behind an optional ADVANCED control and errors are readable.
- FORGE & KEEP: Select up to FOUR different ore IDs in one recipe. Each ore
  gets its own amount; total must equal the target's ore count. Counts and
  inventory are validated for every craft, keeping all outputs; no auto sell.
- Keep Forge3 3-target cycles, Pet/Scroll DPS scan, Spin, dodge, Manual E fix.
- Validation: offline Lua parse/structure ONLY; live server protocol unverified.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.26 | 2026-11-09
- Keep user-input 3-piece forge rotation: Scepter-target (Weapon), Armor-target (Armor),
  Helmet-target (Armor). Each takes its own ore ID/mixture + count; number of rounds editable.
  Subtypes are random; server craftType takes only Weapon or Armor, cannot promise Scepter/Helmet.
  Every output is KEEP and batch-protected. STOP AFTER CURRENT ITEM supported.
- New Spin tab: Race Roll moved from Utilities; HonorSpin(10) button + physical key 0.
- Hatch UI: diagnostic egg scan + MANUAL StartHatch(number, eggUID); not automatic 3-slot
  hatching because live hatch-slot occupancy/UID field schema is NOT verified.
- Manual E safety: never blindly WindowUtil:Close hidden Forge screen after Remote Forge;
  PAUSE AUTO FORGE/SELL and Forge UI state diagnostics. Not a verified full fix for game prompts.
- No change to DPS gear optimizer, pet/scroll manual stats, combat, routes, etc.
- Static source checks only. Roblox/Delta and server behavior NOT verified.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.25 | 2026-11-09
OWNED-GEAR DPS OPTIMIZER: NO crafting by this module, NO selling, NO auto-equipping.
Scan Weapon / Helmet / Breastplate already in inventory, rank whole 3-piece combinations
by the Discord expected-damage formula; retain SAME CLASS by default because real DPS
varies with skill hits, AoE, cooldown and scroll identity across weapon classes.
Pet FOLLOW + active Scroll provenance scanned; manual Pet / Scroll / Total-stat inputs
available for bad/missing reads. Game total stats already include active buffs, so Pet and
Scroll are NEVER added on top of valid game totals. When a total stat is missing, use a
labeled partial reconstruction from observed equipped gear and manual Pet/Scroll values.
Actual forging is probabilistic; no fixed 10/15/22 material 'recipes' assumed.
No UI or flow changes to the AIO's other, separately enabled Forge/Trash routines.
Server/Delta behavior and inventory field schema still require live verification.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.24 | 2026-11-09
DPS Forge Lab: scan owned equipment, followed pets, equipped Scroll by current weapon class.
Compute expected skill damage using Discord multiplicative formula, including AttrEntryUtil aggregate.
HISTORICAL ONLY: the 10/15/22 ore presets below were incorrect; v4.9.25 removes them.
Bow +20 and SmartDodge +30 retained from user's most recent test preferences.
All forged items kept. NO auto sell, NO unverified equip, random outputs are not guaranteed.
PARTIAL diagnostics if total stats or effective weapon ATK cannot be read reliably.
Roblox runtime/server outcomes NOT tested.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.23 | 2026-11-09
Dynamic Q/E/R/G/M1: WeaponUtil.GetWeaponSkillId -> ResSkill.Stage1..10 -> ResSkillStage.
Multi-hit hold is experimental (ON/OFF). Beam uses configured Stage2 / Stage3 times.
Missing/invalid skill IDs: skip and log, never hardcode two phases. Rapid G only for single-stage Scroll.
NEW: independent downward-only AIM 3D (90 degrees vertical, no above-player fallback).
NEW: explicit Scepter combat modes S5+G ONLY versus FULL SKILLS (S5 + Q/E/R/G).
FULL: Staff_Skill_Ult_Beam phase 2 kept running for 6s (30 x .2) before phase 3;
      other M1/G/Q/E client requests are permitted during this hold (server unverified).
GROCERY: Silver/SeasonPotion_1 option sends BuyShopItem Gold GoldShop_30 only if selected.
CAUTION: Remote request acceptance and cumulative server DPS are not guaranteed.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.21 | 2026-11-09
USER-REQUESTED EXPERIMENTAL COMBAT / UTILITY RELEASE
- B: disarm AutoFarm and AutoAttackTeleport, cancel current combat/route, return Lobby via TeleportWorld Lobby.
- Per-account Ultra Low Graphics; hide cosmetics only, preserve enemies, RedShow, collision, Remote and data.
- Race Roll separate slot 1 (Free_1), slot 2 (1), one request on click.
- M1 independent of Q/E/R/G scheduler for all weapons. Bow retains its own projectile stage worker.
- Scepter mode: only Staff_Atk2 BaseAttack phase 5, requested interval 0.08s adjustable;
  overlapping S5 requests with periodic End (NOT server-confirmed damage).
- Optional 3D DOWN aiming for hover and camera.
CAUTION: Parallel M1+skills and 0.08 S5 are experiments; server may ignore/interfere.
NO override of Q/E/R/G user cast direction; existing ForgeUncertain sell locks preserved.
--]]

--[[
IRON SOUL AIO v4.9.20 | 2026-11-08
FIX — MELEE M1 FIRST: reserve a complete four-stage BaseAttack combo before
  checking any Q/E/R/G skill; allow one optional ready skill after the combo's
  closing End packet, then immediately resume M1. Skills cannot starve M1.
  Bow remains on its existing BulletShoot worker; Scepter Rapid Explosive keeps
  Q/E/R -> Rapid G and intentionally suppresses competing BaseAttack.
NEW — M1 SENT / END / ERROR button for client request diagnostics (NOT hit proof).
F.E.B.S — clones always forge Weapon with all ELIGIBLE normal and Mythic Ore;
  remove the redundant Mythic-Weapon ON/OFF UI. Main-account Mythic Trash
  keeps Armor. F.E.B.S ON/OFF still automatically couples Auto Trash ON/OFF.
KEEP — Halloween lateral Dodge, saved Q Horizontal preference, forge receipt
  verification and fail-closed Sell UUID protection. No unverified phase changes.
OFFLINE CHECK ONLY: Roblox/Delta and damage acceptance not yet validated.
--]]

--[[
IRON SOUL AIO v4.9.19 | 2026-11-08
- Respect saved Q/E/R/G Horizontal ON/OFF on inject and Scepter toggle; no auto overrides.
- Clone F.E.B.S ON auto-arms Auto Trash, normal and Mythic Forge prioritize Weapon by default;
  no change to main-account exact-UUID SELL or batch F.E.B.S safety locks.
- Halloween Mode is explicit opt-in: cap aerial hover to +20 and use lateral RedShow avoidance
  with ground-check + lock safe dodge position until warning clears; no +60 dodge.
- No changes to skill stage protocol or the known Sell receipt timeout logic.
- OFFLINE ONLY: raycasts, danger geometry and server Forge results require in-game validation.
--]]

--[[
IRON SOUL AIO v4.9.18 | 2026-11-08
- GUI: two balanced columns on wide screens, responsive single-column on narrow screens.
- Staff/Scepter RemoteSpy profile (requires live hit validation):
  Q Skill1: stage 1 -> 2 -> 3 -> end, low HORIZONTAL cast ~10-14 studs.
  E Skill2: stage 1 -> end, aerial AoE.
  R SkillU: stage 1 (charge) -> 2 (release) -> end, aerial.
  G SkillAW: stage 1 -> end, aerial Explosive.
- Q/E/R remain equal priority by observed readiness; G uses spare cast windows.
- Scepter default horizontal toggles corrected Q ON / E,R,G OFF; no changes
  to Staff BulletShoot/BaseAttack during Rapid G until concurrent safety tested.
- Other weapons retain legacy stage 1 -> 2 -> end as an unverified fallback.
- Preserve v4.9.17 boot/H diagnostics, condition trash and batch F.E.B.S.
- OFFLINE CHECKS ONLY. Server acceptance, phase timing and damage unverified.
--]]

--[[
IRON SOUL AIO v4.9.17 | 2026-11-08
BOOT FIX: early diagnostic overlay, protected startup error, H hotkey wired first, prior Stop guarded.
KEEP: v4.9.16 trash, batch F.E.B.S, fullscreen controls.

IRON SOUL AIO v4.9.16 | 2026-11-08
- Main account: auto filter -> Forge -> exact UUID Sell.
- Clone F.E.B.S: Forge ALL eligible recipes as one safe Lobby batch, Equip Best once,
  then sell only unlocked / confirmed unequipped equipment; no Ore/material sold.
- Auto Clean runs whenever a full eligible recipe exists in Lobby, irrespective of bag count.
- Solo "Lobby if full or Again" returns to Lobby on eligible trash; explicitly chosen
  "Always Play Again" is NEVER redirected due to trash / Ore Guard thresholds.
- Full-screen editing GUI, minimize button, H hide/show, shortened informational labels.
- Preserves v4.9.15 Q/E/R priority, Scepter Rapid G and safety guards.
- UNTESTED ON ROBLOX SERVER: validate with expendable gear on a clone first.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.15 | CHANGELOG | 2026-11-08
FIX — CONDITION-BASED ORE CLEANUP: Auto Clear Trash runs in a safe Lobby
      whenever enabled, regardless of how many Ores remain. It stops only
      when no full eligible recipe exists; no forced cleanup-to-300 target.
      Ore Capacity Guard retains a separate RETURN-TO-LOBBY safety threshold.
FILTER — Normal trash: Common..configured rarity (default Legendary), 3 ores
      per Weapon. Mythic trash: explicit opt-in, known Lv <= chosen cutoff,
      configurable exact 3..100 ores per Armor; protected/unknown ores untouched.
SAFETY — If no eligible recipe exists but the bag is near/full (>= ReturnAt
      or game reports FULL), stop Solo Auto Entry instead of making an unsafe run.
      Preserve exact-UUID Sell, Forge transaction locks and F.EB.S semantics.
KEEP — Q/E/R ready-time priority, weapon-specific Dodge, Rapid G, analytics,
       Dungeon routes, Grocery and all non-cleanup modules from v4.9.14.
NOTE — Offline code patch; verify crafting and rarity/level rules in Roblox.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.14 | CHANGELOG | 2026-11-08
FIX — COMBAT PRIORITY: Q/E/R have EQUAL priority. The first eligible skill
      observed READY is dispatched first (ties rotate); no fixed Q > E > R.
      Rapid Scepter G yields BEFORE starting a new stage when Q/E/R can cast.
FIX — DODGE CAST PROFILE: horizontal Q/E/R/G waits for the Boss RedShow
      warning to disappear and for a safe low-altitude position; ordinary
      non-horizontal skills continue casting during +60 dodge, including
      Scepter's downward Explosive G. Horizontal stage is never overridden.
KEEP — Bow high-hover +50 profile (no automatic extra +60 while already high),
       Scepter hover +30 / emergency +60; existing 1/2/end protocol; shared
       no-overlap guards, ore/forge, analytics, all routes and settings.
CHECK — Stage requests are not proof of accepted damage; verify Q/E/R counts,
        actual skill hits and World5 Diff10 clear times in Roblox.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.13 | CHANGELOG | 2026-11-08
FIX — READ ORE BAG / CHECK STATUS button was displaying UNKNOWN even after
      obtaining a valid snapshot: it declared `local bag` but called
      `Runtime.OreStatusText(b)` (undefined b). Now passes `bag` correctly.
KEEP — DataUtil-based ore count, Ore Capacity Guard safety, Mythic Trash,
       F.EB.S, Scepter Rapid G, analytics, Dungeon routes, and all Forge logic.
NOTE — This fixes the UI display bug; whether the live DataUtil path returns
       valid numeric ore inventory still needs verifying with READ in-game.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.12 | CHANGELOG | 2026-11-08
NEW — RAPID EXPLOSIVE G REQUEST RATE OPTIONS (Combat):
  * Saved interval choices: 0.01 / 0.02 / 0.03 / 0.05 / 0.08 / 0.10 / 0.15 / 0.20s.
  * Default stays 0.10s, preserving prior user settings when valid.
  * Experimental option 'BYPASS CLIENT CD GATE' defaults OFF. ON skips
    SkillAWLastTs LOCAL check for Rapid G only; the server still controls hits.
  * Adaptive stage1-to-stage2 scheduling for fast requests, while preserving
    the ordered SkillActive / SkillAction(1,2,end) sequence and single-flight
    protection. No concurrent overlapping G cast sequences are launched.
  * Worker checks faster only when Scepter Rapid G is active; adds attempted
    stage1 count to G stats for rate experiments.
CAUTION — 0.01s means REQUESTED interval only; Roblox task scheduling,
          client/remote throttles, game skill logic and server cooldowns can
          lower actual throughput. Stage2/end observed != confirmed damage.
KEEP — v4.9.11 F.EB.S, Mythic Trash, 450/300 Ore Guard, World/Diff analytics,
       Hover, Dynamic Fly, Smart Dodge, Dungeon routes, Forge and Utilities.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.11 | CHANGELOG | 2026-11-08
NEW — UTILITIES F.EB.S (Forge -> Equip Best -> Sell), DEFAULT OFF:
  * Only applies to AUTO CLEAR TRASH runs when explicitly enabled.
  * Forge normally, call game EquipBest for Weapon/Breastplate/Helmet, wait
    for owned/equipped inventory state, then sell all UNLOCKED + UNEQUIPPED
    gear. Ores, materials and locked/equipped items are never sold directly.
  * OFF (main account) retains SAFE EXACT-UUID sale of only newly forged gear.
  * If EquipBest/verification/selling fails, stop cleanup and do not create
    another Dungeon until inspected. Do not restart on an uncertain receipt.
NEW — MYTHIC TRASH (separate opt-in, default OFF):
  * Strict ore level < configured cutoff (example 87) and rarity 6 only;
    unknown/ambiguous level and protected ores are never touched.
  * User-adjustable exact ores per forge (example 22). ForgeRF craftType=Armor
    for Heavy Breastplate-style recipe; SERVER decides actual subtype.
  * Normal rarity 1..5 still uses independent 3-ore Weapon cleanup.
  * Deprecated old Mythic 3-ore cleanup; preserve its saved setting as
    legacy only, never spend Mythics from it without NEW Mythic Trash ON.
  * Both paths honor 450/300 Ore Capacity Guard and same single Forge worker.
KEEP — Scepter Rapid G, Dynamic Fly, routes, World/Diff analytics, Grocery.
CAUTION — Cannot confirm server EquipBest and Heavy Armor output offline;
          clone-only F.EB.S should be tested with expendable gear first.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.10 | CHANGELOG | 2026-11-08
FIX — ORE CAPACITY GUARD (default ON; based on manually observed 500 slots):
  * Count actual Ores inventory amounts, not solely ForgeUtil:CheckCanAdd(player, 1).
  * Solo runs: after Settlement choose BackLobby at >=450/500 ores,
    even when CheckCanAdd(1) still says true; otherwise keep Play Again.
  * Lobby: only start AUTO cleanup on threshold, not every return.
    Forge+sell eligible 3-ore recipes down to <=300/500, then re-enter.
  * Missing recipe / unknown ore count / game reports full: do NOT
    auto-create another Solo Dungeon; keep ores protected and show reason.
  * Recover automatically after manual bag clearing or user changes filters.
  * NEW Utilities controls: capacity, return threshold, resume threshold;
    READ ORE BAG button to compare script's count with in-game UI.
  * ORE_CAPACITY events in AIO logs when returning/blocked/cleared.
  * Only Ore loot is covered by counted thresholds; Material worlds retain
    the game's existing MaterialUtil:CheckCanAdd behavior.
KEEP — v4.9.9 Scepter rapid G, Q/E/R/G dynamic skills, Bow, smart dodge,
       Forge exact-UUID safe-sale, routes, 30-minute World/Diff analytics.
CAUTION — 500/450/300 are editable heuristics; game may have different
          effective limits or per-run loot amounts. Not Roblox runtime-tested.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.9 | CHANGELOG | 2026-11-08

NEW — SCEPTER / STAFF EXPLOSIVE RAPID MODE:
  * Persistent Combat toggle: SCEPTER MODE (+30 over tallest nearby enemy).
  * Independent Rapid G loop, target 0.10s between SkillAW cast starts; optional
    0.08 / 0.10 / 0.12 / 0.15s request interval (game/server may rate-limit).
  * Each attempt follows the known SkillActive + SkillAction 1/2/end protocol;
    no 0.35s shared AutoSkills scan or 0.65s Dynamic Fly throttle.
  * Switching Scepter ON sets G Horizontal OFF, because Explosive hits from
    altitude; user can turn G Horizontal ON later to favor the normal dynamic
    horizontal casting of a DIFFERENT scroll skill (Rapid G pauses).
  * Q / E / R retain independent Dynamic Fly settings, and remain eligible
    for the standard skill scheduler. Rapid G yields during horizontal casts,
    dodge, equipment transitions, other skill stages and settlement.
  * Normal BaseAttack is paused while Rapid G is active to avoid clobbering
    the 0.1s SkillAW sequence. Pet attacks continue.
  * Counts Remote stage-2/end attempts (not server-confirmed damage); one log
    every 100 dispatched G skills. On-demand G rate shown in Combat.
FIX — Scepter dodge probes nearby RedShow at ground level even when +30 above
      tall Elite; +60 still takes priority on a detected warning.
KEEP — v4.9.8 World/Diff full-Dungeon clear-time statistics, independent
       30-minute build windows, Forge presets, Dynamic Fly Q/E/R/G, Bow, routes.
CAUTION — Local CD is not proof of server throughput; actual skill hits and
          scroll protocol must be verified in-game. No Roblox runtime test.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.8 | PRIOR CHANGELOG | 2026-11-08

FOCUS — WORLD/DIFF DUNGEON CLEAR TIME (the key build-comparison KPI):
  * Read ACTUAL WorldId / DiffLevel / GameRound from game GameRoundCfg,
    rather than relying on selected config or guessed room totals.
  * Start an observed Dungeon run on the first active room; confirm SUCCESS
    only on settlement (native result GUI or Settlement attribute).
  * Save each result with World, Diff, clear seconds, room progress,
    deaths, HP lost, and dodge counts to DungeonClearTimes.csv / JSON.
  * Break down complete runs / average clear time / fastest clear time
    by World+Diff inside independent 30-minute build-test windows.
  * Mark injected-mid-run measurements as PARTIAL; exclude them from
    full clear-time averages. Preserve run state across quick reinjections
    when executor file APIs work.
  * Expose current World/Diff, live run duration, completed-run times in UI.
FIX — RoomClear counter watches GameRoundComplete (including World5).
  * No success claimed merely because GameRoundComplete advanced.
OTHER — Retain deaths/HP/dodge/Cores metrics, custom Forge presets, Dynamic
  Fly, Bow, Dodge, all routes. Gold no longer shown in build comparison.
SAFETY — Observed timing starts at first detected room (roughly within 1s),
  NOT the exact server matchmaking start; no Roblox runtime test performed.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.7 | CHANGELOG | 2026-11-08

NEW — AUTO ANALYTICS (Utilities):
  * Session log + JSON summary exported to executor files in IronSoul_AnhLy/auto_reports.
  * Auto-save every 30 seconds when enabled (default ON); manual EXPORT LOG button.
  * Measures elapsed time, observed HP loss, deaths, room-clear events, entry attempts,
    dodge/skill/route/forge/error events, and approximate Auto Farm/Combat uptime.
  * Counts script-observed events, NOT verified DPS, actual server damage or loot value.
  * Each injection starts a NEW session and file pair; existing files are not overwritten.
PRESERVED FROM MANUAL HOLD TUNING:
  * Horizontal Cast Hold permits 0.05s and defaults to 0.10s for new users.
    Previously saved hold selections are retained and can be reselected in Combat.
NEW — USER FORGE PRESETS (Forge):
  * Enter a target label and integer ore quantity; ADD to the existing Target dropdown.
  * Presets persist in config_v23.json; DELETE SELECTED CUSTOM removes only user presets.
  * Example: Staff + 4 ores, Sword + 3 ores (selected Weapon/Armor group).
  * Names are LOCAL LABELS ONLY: ForgeRF receives ore recipe + Weapon/Armor,
    and the game SERVER determines the resulting gear subtype and probability.
KEEP: v4.9.6 Dynamic Fly, Bow persistence, Smart Dodge, Forge UUID safety,
      Auto Clear Trash, Grocery, Race Roll, routes and F6 Rewards unchanged.
CAUTION: Tested by source/static checks only, not run inside Roblox/Delta.
--]]

--[[
IRON SOUL DUNGEON | AIO v4.9.6 | CHANGELOG | 2026-11-08

NEW:
  [Fly] Hover above TALLEST live enemy in the current nearby group, rather than
        over the small current target. Normal Hover base: 12 studs above model top.
  [Bow] Bow Combat ON/OFF is saved across reinjections. At high flight, hover
        +50 above tallest enemy; no unnecessary RedShow +60 dodge in that state.
  [Skill] Four INDEPENDENT ON/OFF options in Combat for Q/E/R/G, valid
          for ALL weapons. ON = find safe horizontal cast point, then ascend;
          OFF = cast at current Hover altitude. Suggested initial settings:
          Q=OFF, E=ON, R=OFF, G=ON. All options are saved.
  [Skill] Horizontal auto-cast: scan candidate standoff positions on solid
        ground, avoid nearby RedShow and enemy contact range; if none safe,
        SKIP cast without spending skill. Hold aim until cast finishes; ascend.
  [Hotkeys] Optional intercept of Q/E/R/G when horizontal profile is enabled,
        using ContextActionService (game may also have direct input listeners).
FIX:
  [Dodge] HP damage no longer disables Dodge for 12 seconds. Clustered
          RedShow warnings extend airborne safety window 1.0s after last signal.
  [Combat] Pending Bow pulses stop during horizontal casting; BaseAttack and
           AutoSkills cannot override Fly movement.
  [GUI] Skill mode switches and Hover height selection visible in Combat.
UNCHANGED:
  World1-4 route logic, Forge/Auto Clear Trash, Grocery, Utilities Race Roll,
  equipment sale, F6 Rewards and LDPlayer cursor-safe target lock.
CAUTION:
  Enemy attack radius, RedShow footprints, horizontal projectile range and
  native key interception are heuristic. Positions that cannot be verified are
  rejected; this is not a guarantee of invulnerability or hits.
--]]

-- Iron Soul AIO v4.9.4 | Compact UI fix: visible Combat toggles; Auto Clear Trash/Grocery controls moved to Utilities.
-- Based on v4.9.3: no changes to Combat, Forge, routes, shopping workers or equipment selling logic.
-- ADD: auto-entry retry, RedShow adaptive dodge, soft target aim, optional Bow native stages + BulletShoot.
-- KEEP: original W1/W2/W3/W4 routes, Forge, Chest/Egg, Grocery worker and existing F6 Rewards.
-- IMPORTANT: smart dodge and camera aim are experimental; RedShow timing / server skill targeting not validated.
-- Run only ONE AIO. Bow Combat now persists the user's explicit ON/OFF choice.
-- Iron Soul AIO v23 COMPACT v4 | v3 World4 Hybrid preserved | Roblox verification pending
-- Run only one main; do not also run the older standalone automation scripts.
-- BOOT DIAGNOSTICS: appears before loading Framework, so an early startup
-- error cannot leave the player with a blank screen and no explanation.
local BootUIParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local OldBoot = BootUIParent:FindFirstChild("IronSoulBootDiagnostic")
if OldBoot then OldBoot:Destroy() end
local BootGui = Instance.new("ScreenGui")
BootGui.Name = "IronSoulBootDiagnostic"
BootGui.ResetOnSpawn = false
BootGui.IgnoreGuiInset = true
BootGui.DisplayOrder = 100000
BootGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BootGui.Parent = BootUIParent
local BootPanel = Instance.new("Frame")
BootPanel.Name = "BootStatus"
BootPanel.AnchorPoint = Vector2.new(0.5, 0)
BootPanel.Position = UDim2.new(0.5, 0, 0, 30)
BootPanel.Size = UDim2.new(0.88, 0, 0, 118)
BootPanel.BackgroundColor3 = Color3.fromRGB(28, 29, 42)
BootPanel.BorderColor3 = Color3.fromRGB(185, 122, 54)
BootPanel.BorderSizePixel = 2
BootPanel.Parent = BootGui
local BootLabel = Instance.new("TextLabel")
BootLabel.Size = UDim2.new(1,-18,1,-12)
BootLabel.Position = UDim2.fromOffset(9,6)
BootLabel.BackgroundTransparency = 1
BootLabel.TextWrapped = true
BootLabel.TextXAlignment = Enum.TextXAlignment.Left
BootLabel.TextYAlignment = Enum.TextYAlignment.Top
BootLabel.TextColor3 = Color3.fromRGB(250,230,193)
BootLabel.TextSize = 16
BootLabel.Font = Enum.Font.GothamSemibold
BootLabel.Text = "Iron Soul AIO v4.9.50f: đang khởi tạo..."
BootLabel.Parent = BootPanel
local function BootStatus(step)
    if BootLabel.Parent then BootLabel.Text = "Iron Soul AIO v4.9.50f\n"..tostring(step) end
end
-- H must be connected before risky initialization. One handler toggles either
-- the main window, or the boot/error overlay if the main GUI was not created.
local BootEnv = (typeof(getgenv)=="function" and getgenv()) or shared
if BootEnv.IronSoulBootHotkey then
    pcall(function() BootEnv.IronSoulBootHotkey:Disconnect() end)
end
local BootHotkeyConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode ~= Enum.KeyCode.H then return end
    if game:GetService("UserInputService"):GetFocusedTextBox() then return end
    local env = (typeof(getgenv)=="function" and getgenv()) or shared
    local runtime = env and env.IronSoulMainRuntime
    if runtime and runtime.Alive and runtime.Gui and runtime.Gui.Parent then
        runtime.Gui.Enabled = not runtime.Gui.Enabled
        if runtime.Gui.Enabled and runtime.ResizeAIO then pcall(runtime.ResizeAIO) end
    elseif BootGui and BootGui.Parent then
        BootGui.Enabled = not BootGui.Enabled
    end
end)
BootEnv.IronSoulBootHotkey=BootHotkeyConnection
local BootSucceeded, BootFailure = xpcall(function()
BootStatus("Đang dừng phiên bản cũ / đọc cấu hình...")
local runtimeEnv = (typeof(getgenv) == "function" and getgenv()) or shared
local previous = runtimeEnv.IronSoulMainRuntime
-- The integrated Grocery worker owns purchases now; never run two 60s loops.
do
    local legacy = runtimeEnv.IronSoulGroceryAutoV2
    if legacy and type(legacy.Stop) == "function" then pcall(legacy.Stop) end
end
if previous and type(previous.Stop)=="function" then
    local stopped,reason=pcall(previous.Stop)
    if not stopped then error("Không dừng được phiên bản cũ an toàn: "..tostring(reason),0) end
end
-- Avoid two independent Bow probes firing the same PlayerActionRE while AIO combat runs.
do
    for _,name in ipairs({"IronSoulBowAerialV12","IronSoulBowAerialV11","IronSoulBowAerialV10",
        "IronSoulBowBase4BenchmarkV9","IronSoulBowPulseTraceV8"}) do
        local probe=runtimeEnv[name]
        if type(probe)=="table" and type(probe.Stop)=="function" then pcall(probe.Stop) end
    end
end
local Runtime = {ForgeUncertain = previous and (previous.ForgeUncertain or previous.ForgeBusy) or false,
    ForgeSafetyPending = (previous and previous.ForgeSafetyPending) or {},
    Alive = true, Connections = {}, Collision = {}, Forged = (previous and previous.Forged) or {}, ToggleRefresh = {}}
runtimeEnv.IronSoulMainRuntime = Runtime
table.insert(Runtime.Connections, BootHotkeyConnection)
function Runtime.Stop()
    if Runtime.ExitUnderground then pcall(Runtime.ExitUnderground,"script stopped") end
	if Runtime.CancelRoute then Runtime.CancelRoute("script stopped") end
	if Runtime.ForgeBusy then Runtime.ForgeUncertain=true end
    if Runtime.Analytics and Runtime.Analytics.Flush then
        pcall(function() Runtime.Analytics.Flush(true, "STOP") end)
    end
	Runtime.Alive = false
	if Runtime.EntryHumanoid and Runtime.EntryHumanoid.Parent then
		pcall(function() Runtime.EntryHumanoid:Move(Vector3.zero); Runtime.EntryHumanoid:MoveTo(Runtime.EntryHumanoid.RootPart.Position) end)
	end
	Runtime.EntryBusy = false
	Runtime.Owner = nil
	if Runtime.ProtectPendingForge then Runtime.ProtectPendingForge() end
	if Runtime.CancelPatrol then Runtime.CancelPatrol() end
	if Runtime.RestoreQTE then Runtime.RestoreQTE() end
	if Runtime.ReleaseEggInput then Runtime.ReleaseEggInput() end
    if Runtime.CleanupNightCombat then pcall(Runtime.CleanupNightCombat) end
    if Runtime.CloseScepterS5 then pcall(Runtime.CloseScepterS5) end
    if Runtime.RestoreUltraLowGraphics then pcall(Runtime.RestoreUltraLowGraphics) end
	for _, connection in ipairs(Runtime.Connections) do connection:Disconnect() end
	for part, value in pairs(Runtime.Collision) do
		if part.Parent then part.CanCollide = value end
	end
	table.clear(Runtime.Collision)
	if Runtime.Gui then Runtime.Gui:Destroy() end
end
local function checkRunning()
	if not Runtime.Alive then error("Script stopped", 0) end
end
local function waitUntil(predicate, timeout)
	local deadline = os.clock() + timeout
	repeat
		checkRunning()
		local result = predicate()
		if result then return result end
		task.wait(0.1)
	until os.clock() >= deadline
	return nil
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local PathfindingService = game:GetService("PathfindingService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

BootStatus("Đang tải Framework / modules...")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local GameEnum = require(ReplicatedStorage:WaitForChild("Enum"):WaitForChild("GameEnum"))
local KeyString = require(ReplicatedStorage:WaitForChild("Enum"):WaitForChild("KeyString"))
local GamePlaceUtil = require(ReplicatedStorage:WaitForChild("Utility"):WaitForChild("GamePlaceUtil"))
local ResEnchantedStoneConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("ResEnchantedStoneConfig"))
local EndlessConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("EndlessConfig"))
local EndlessRoundUtil = require(ReplicatedStorage:WaitForChild("Utility"):WaitForChild("EndlessRoundUtil"))

local DataUtil = Framework.Modules.DataUtil
local ForgeUtil = Framework.Modules.ForgeUtil
local WorldUtil = Framework.Modules.WorldUtil
local LevelUtil = Framework.Modules.LevelUtil
local PlayerInfoUtil = Framework.Modules.PlayerInfoUtil
local SeasonUtil = Framework.Modules.SeasonUtil
local EquipmentData = Framework.Modules.EquipmentData
local EquipmentUtil = Framework.Modules.EquipmentUtil
local TimeLimitUtil = Framework.Modules.TimeLimitUtil
local MaterialUtil = Framework.Modules.MaterialUtil
local EnchantmentUtil = Framework.Modules.EnchantmentUtil
local CurrencyUtil = Framework.Modules.CurrencyUtil
local WindowUtil = Framework.Modules.WindowUtil

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PlayerActionRE = Remotes:WaitForChild("PlayerActionRE")
local SkillActiveBE = Remotes:WaitForChild("SkillActiveBE")
local GameMatchRE = Remotes:WaitForChild("GameMatchRE")
local PlayerPetRE = Remotes:WaitForChild("PlayerPetRE")
local GameRoundRE = Remotes:FindFirstChild("GameRoundRE")

local fwFolder = ReplicatedStorage:WaitForChild("Framework")
local TaskRE = fwFolder:FindFirstChild("TaskRE", true)
local EquipRE = fwFolder:FindFirstChild("EquipmentRE", true)
local ForgeRF = fwFolder:FindFirstChild("ForgeRF", true)
local WorldRE = WorldUtil and WorldUtil.RemoteEvent
local RedPointRE = fwFolder:FindFirstChild("RedPointUtil", true) and fwFolder:FindFirstChild("RedPointUtil", true):FindFirstChild("RemoteEvent")

local ConfigFolder = "IronSoul_AnhLy"
local ConfigFile = ConfigFolder .. "/config_v23.json"
local LegacyConfigFile = ConfigFolder .. "/config.json"

local Config = {
	HybridRoute = true,
	AutoRecord = true,
	SpawnAnchors = {},
	AutoFallbackRooms = {},
	EndlessEntryEnabled = false,
	EndlessEntryVerified = false,
	RecordedCoordinates = {},
	AutoRouteEnabled = {},
	SelectedRecordWorld = "World1",
	SelectedRecordRoom = 4,
	BatchMode = "KEEP",
	AutoTrashSell = false,
	AutoClearTrash = false, -- Persistent background cleanup, distinct from manual Forge Sell/Keep.
	AutoClearTrashMaxRarity = 5, -- 1 Common through 5 Legendary (normal cleanup threshold).
	AutoClearTrashMythicMaxLevel = 0, -- LEGACY saved setting, no longer used for 3-ore Mythic forge.
    AutoTrashFEBS = false, -- Clone opt-in: Forge -> EquipBest -> Sell remaining unlocked gear.
    MythicTrashEnabled = false, -- Separate opt-in: Mythic-only Armor forge.
    MythicTrashOreCount = 22, -- Exact Mythic ores per Armor forge (example 22).
    MythicTrashLevelBelow = 87, -- Inclusive level cutoff (legacy key): Lv <= 87.
	AutoClearTrashPending = false, -- Condition-driven cleanup; scan at next safe Lobby opportunity.
    OreSafetyEnabled = false, -- VIP 1400: Ore Guard RETIRED. Never route to Lobby due to ores.
    OreBagCapacity = 1400, -- VIP bag size: informational only, not used to gate replay.
    OreReturnAt = 1400, -- Deprecated; never used by Auto Farm while guard is removed.
    OreResumeAt = 300, -- LEGACY saved field; no longer stops or gates Auto Clear Trash.
    OreCleanupActive = false, -- Informational only: whether condition-based cleanup is running.
	ForgeRarity5 = false,
	ProtectedOres = {},
	AutoBuy = false,
    GroceryAutoBuy = false, -- OFF until the user explicitly switches ON.
    GroceryFate = false, GroceryHarvest = false, GroceryAttack = false, GroceryBerserker = false,
    GrocerySilver = false, -- SeasonPotion_1, observed GoldShop_30; server availability unverified
    SequentialW23ImportVersion = "", -- MUST persist; prevents reimport overwriting edited W2/W3 points.
	ShopSelected = {},
	ShopPriority = {},
	ShopTestId = "GoldShop_15",
	LootRadius = 120,
	ActiveTab = "Dungeon",
	AutoFarm = true,
	AutoAttackTeleport = false, -- Independent combat in manual team dungeons; never creates Solo rooms.
	HoverCombat = true,
	HoverHeight = 12,
    HoverHeightMigrated496 = false,
    UndergroundHover = false, -- v4.9.50: exclusive movement owner; disabled by default
    UndergroundDepth = 8, -- studs BELOW detected solid floor; 16/20 opt-in test only
    WheelOfLuck = false, -- autonomous free spin, 20m15s; Lobby-return fast attempt
    AutoCombatPresetEnabled = true, -- compatibility master switch; three mode buttons are UI
    CombatMode = "RANGE", -- RANGE / MELEE / ASTRAL / ASTRAL_UG / CLONE
    FastSkillPhases = false, -- LEGACY; migrated once to independent Astral Rush flags, then disabled
    AstralRushQ = false, AstralRushE = false, AstralRushR = false, AstralRushG = false,
    AstralRushMigrated = false, -- one-time migration preserves saved global Fast ON
    AutoCombatHalloweenAstral = false, -- separate deliberate one-click override only for Astral Rastar
    SkillDirectionOverrides = {}, -- per actual Skill ID: HORIZONTAL/HOVER
    SkillDescentOverrides = {}, -- per actual Skill ID: DESCEND/HOVER, nil = per-class default
    AstralSkillPriority = true, -- ONLY for equipped Rastar Exclusive; Q/E/R/G outrank M1
    AstralFastQ = true, -- TEST 0.12s between Q phases; persistent damage after End not verified
    AstralRFastTest = false, -- SAFETY default: hold R stage3 for its 9-hit 4.5s window
    AstralRastarM1Projectiles = true, -- BulletShoot only during free Q/E/R/G windows
    AstralOrbitCombat = false, -- OPT-IN: circle at +12 above tallest mob -> +30 AoE cast
    AstralOrbitRadius = 12, -- horizontal circle radius in studs
    AstralOrbitPullSeconds = 4.5, -- max seconds to gather per cycle
    AstralOrbitBurstSeconds = 7.0, -- at least this long at +30 to let Q/E/R/G run
    ScepterCombat = false, -- explicit/persisted Staff/Scepter profile; not auto-detected
    ScepterCombatMode = "FULL", -- legacy S5G retired; FULL skills only
    HalloweenMode = false, -- Explicit mode; 20-stud hover, lateral RedShow dodge (no +60)
    ScepterGInterval = 0.10, -- requested seconds between G casts; server permitting
    ScepterS5Interval = 0.08, -- desired S5 stage-5 packet interval, server permitting
    DynamicHoldMultiHit = true, -- hold only stage metadata with plausible multi-hit timing; can turn OFF for A/B
    Aim3DDown = false, -- optional downward body/camera aim
    UltraLowGraphics = false, -- effective value loaded per ACCOUNT, not shared config
    ScepterGBypassClientCooldown = false, -- experimental; do not trust remote count as damage
    FlyDynamicSkills = true,
    FlyHorizontalQ = false,
    FlyHorizontalE = true,
    FlyHorizontalR = false,
    FlyHorizontalG = true,
    FlyHotkeys = true,
    FlyCastDistance = 38,
    FlyCastHold = 0.10,
    SmartTargetLock = true,
    SmartDodge = true,
    BowCombat = false, -- user choice is persisted; default OFF only on first install
    DPSCompareAllClasses = false, -- opt in: cross-class formula-only, not real skill DPS
    DPSManualPet = "", -- comma-separated ATK%,Skill%,CritRate%,CritDmg%,FlatATK
    DPSManualScroll = "", -- current-class Scroll manual, empty means auto
    DPSManualTotals = "", -- total ATK%,Skill%,CritRate%,CritDmg%; empty means auto
	AutoM1 = true,
	AutoEndlessDeathLobby = true,
	AutoSkills = true,
	AutoPatrol = true,
	PatrolRoutes = {},
	BreakChestsEggs = true,
	HideFX = true,
	AutoStartDungeon = false,
	AutoCreateRole = "Solo",
	SelectedWorld = "World3",
	SelectedDiff = 7,
	EndlessMode = "NextChallenge",
	RunEndAction = "LobbyIfFullOrAgain",
	AutoForge = false,
	AutoQTE = true,
	ForgeRecipe = {},
    CustomForgeTargets = {}, -- Persistent local presets: label + ore count + Weapon/Armor.
    CustomForgeNextId = 1,
    AnalyticsEnabled = true, -- Write session event log/summary every 30s if executor supports file APIs.
    AnalyticsBuildName = "Build A", -- Editable 30-minute comparison label.
    AnalyticsGoldPath = "", -- Optional DataUtil path override, e.g. Currency.Gold.
    AnalyticsCorePath = "", -- Optional DataUtil path override, e.g. Currency.Cores.
	BatchCount = 1,
	BatchTargetType = "Armor",
	BatchProtected = {},
	DamageFilter = "crit,attack,atk,damage,dmg",
	LobbyEntrances = {},
	PortalEntrances = {},
	ForgeTargetType = "Armor",
	ForgeSubtype = "LightHelmet",
	ForgeRarity1 = true,
	ForgeRarity2 = true,
	ForgeRarity3 = true,
	ForgeRarity4 = true,
	ForgeFilterMode = "Rarity",
	ForgeMaxOreLevel = 0,
	AutoSellEquip = false,
	SellOnlyForged = true,
	FilterMinLines = 1,
	AutoEquipBest = false,
	AutoFuseRune = true,
	FuseLv1 = true,
	FuseLv2 = true,
	FuseLv3 = true,
	FuseLv4 = true
}

local function loadSavedConfig()
	local ok, err = pcall(function()
		if typeof(isfolder) == "function" and not isfolder(ConfigFolder) then
			makefolder(ConfigFolder)
		end
		local sourceFile = ConfigFile
		if typeof(isfile) == "function" and not isfile(sourceFile) then
			sourceFile = ConfigFolder .. "/config_v22_phase1.json"
			if not isfile(sourceFile) then sourceFile = LegacyConfigFile end
		end
		if typeof(isfile) == "function" and isfile(sourceFile) then
			local raw = readfile(sourceFile)
			local decoded = HttpService:JSONDecode(raw)
			if type(decoded) == "table" then
				for k, v in pairs(decoded) do
					if Config[k] ~= nil and (typeof(v) == typeof(Config[k]) or (k == "SelectedDiff" and (type(v) == "string" or type(v) == "number"))) then
						Config[k] = v
					end
				end
			end
		end
	end)
	if not ok then warn("[IronSoul v23] Config load failed: " .. tostring(err)) end
end

local function saveConfig()
	local ok, err = pcall(function()
		if typeof(isfolder) == "function" and not isfolder(ConfigFolder) then
			makefolder(ConfigFolder)
		end
		assert(typeof(writefile) == "function", "Không có writefile; cấu hình chỉ tồn tại trong phiên")
		writefile(ConfigFile, HttpService:JSONEncode(Config))
	end)
	if not ok then
		Runtime.LastError = "Config save: " .. tostring(err)
		warn("[IronSoul v23] " .. Runtime.LastError)
		if Runtime.Log then Runtime.Log(Runtime.LastError) end
	end
	return ok, err
end

loadSavedConfig()
-- The compact build has four user-facing features; legacy experimental toggles never resume.
Config.HybridRoute, Config.HoverCombat, Config.HideFX = true, true, true
Config.AutoQTE, Config.AutoFuseRune = true, true
Config.AutoEndlessDeathLobby = true -- terminal death exit for any World, legacy toggle hidden in Compact UI
Config.FuseLv1, Config.FuseLv2, Config.FuseLv3, Config.FuseLv4 = true, true, true, true
Config.AutoCreateRole = "Solo"
Config.AutoPatrol = true -- only the hidden fallback after a missing Spawn Anchor
Config.AutoBuy, Config.AutoTrashSell, Config.AutoForge = false, false, false
-- Four-item Grocery runs under its own explicit opt-in, not legacy AutoBuy.
Config.GroceryAutoBuy = Config.GroceryAutoBuy == true
-- AutoClearTrash is NOT a legacy toggle: restore saved user choice on injection.
Config.AutoClearTrash = Config.AutoClearTrash == true
local trashMax = tonumber(Config.AutoClearTrashMaxRarity)
Config.AutoClearTrashMaxRarity = trashMax and trashMax%1==0 and math.clamp(trashMax,1,5) or 5
local mythicMax=tonumber(Config.AutoClearTrashMythicMaxLevel)
Config.AutoClearTrashMythicMaxLevel = mythicMax and mythicMax==mythicMax and mythicMax<math.huge
    and mythicMax>=0 and mythicMax<=999 and mythicMax%1==0 and mythicMax or 0
-- Legacy cutoff never authorizes Mythic disposal; explicit MythicTrashEnabled required.
Config.AutoTrashFEBS=(Config.AutoTrashFEBS==true)
-- F.E.B.S is a cleanup MODE: enabling it means its worker is enabled too.
-- No need for the user to toggle Auto Clear Trash separately on clones.
if Config.AutoTrashFEBS then Config.AutoClearTrash=true end
Config.MythicTrashEnabled=(Config.MythicTrashEnabled==true)
do -- avoid adding persistent top-level local registers to large Luau chunk
    local mythicOreCount=tonumber(Config.MythicTrashOreCount)
    Config.MythicTrashOreCount=(mythicOreCount and mythicOreCount==mythicOreCount
        and mythicOreCount%1==0 and mythicOreCount>=3 and mythicOreCount<=100) and mythicOreCount or 22
    local mythicLevelBelow=tonumber(Config.MythicTrashLevelBelow)
    Config.MythicTrashLevelBelow=(mythicLevelBelow and mythicLevelBelow==mythicLevelBelow
        and mythicLevelBelow%1==0 and mythicLevelBelow>=1 and mythicLevelBelow<=999) and mythicLevelBelow or 87
end
Config.AutoClearTrashPending = (Config.AutoClearTrash == true and Config.AutoClearTrashPending == true)
Config.OreSafetyEnabled = false -- FORCED OFF regardless of config_v23.json legacy values
do -- keep temporary validation locals out of Luau chunk's top-level register budget
local function normalizeOreThresholds()
    local cap=tonumber(Config.OreBagCapacity)
    cap=(cap and cap==cap and cap>=100 and cap<=100000 and cap%1==0) and cap or 500
    local ret=tonumber(Config.OreReturnAt)
    ret=(ret and ret==ret and ret%1==0) and ret or math.floor(cap*.9)
    local resume=tonumber(Config.OreResumeAt)
    resume=(resume and resume==resume and resume%1==0) and resume or math.floor(cap*.6)
    Config.OreBagCapacity=cap
    Config.OreReturnAt=math.clamp(ret,math.max(3,math.floor(cap*.25)),cap)
    Config.OreResumeAt=math.clamp(resume,0,Config.OreReturnAt-3)
end
normalizeOreThresholds()
end
-- Override stale persisted capacity (550 etc.) for informational reporting only.
Config.OreBagCapacity=1400
Config.OreReturnAt=1400
Config.OreResumeAt=0
Config.OreCleanupActive=false
-- Direct count of ore units in the same owned table consumed by Forge.
-- Fail closed on unreadable/non-numeric data: don't guess the bag has space.
function Runtime.OreBagSnapshot()
    local ok,ores=pcall(function()return DataUtil:GetValue(LocalPlayer,{"Ores"})end)
    local used,known=0,(ok and type(ores)=="table")
    if known then
        for _,amount in pairs(ores) do
            if type(amount)~="number" or amount~=amount or amount<0 or amount==math.huge or amount%1~=0 then
                known=false;break
            end
            used=used+amount
        end
    end
    local validApi,canAdd=pcall(function()return ForgeUtil:CheckCanAdd(LocalPlayer,1)end)
    local apiKnown=(validApi and type(canAdd)=="boolean")
    local apiCanAdd=nil
    if apiKnown then apiCanAdd=canAdd end -- preserve false; `and/or` would turn false into nil!
    return {Known=known,Used=known and used or nil,Capacity=Config.OreBagCapacity,
        ReturnAt=Config.OreReturnAt,ResumeAt=Config.OreResumeAt,
        ApiKnown=apiKnown,CanAdd=apiCanAdd}
end
function Runtime.OreNeedsLobby()
    -- VIP 1400: never force BackLobby/Stop Entry based on ore count or CanAdd.
    -- Item drops may be refused by the game when genuinely full; XP/replay is independent.
    return false,Runtime.OreBagSnapshot(),"ORE_GUARD_REMOVED"
end
function Runtime.OreBlocksSoloEntry()
    if not Config.OreSafetyEnabled then return false,Runtime.OreBagSnapshot(),"REMOVED" end
    local blocked,b,why=Runtime.OreNeedsLobby()
    if blocked then return true,b,why end
    return false,b,"SAFE"
end
function Runtime.OreStatusText(b)
    if not b or not b.Known then return "Ore count: UNKNOWN (Ores data path unreadable)" end
    local api=b.CanAdd==nil and "unknown" or (b.CanAdd and "space" or "FULL")
    return string.format("Ores %d/%d | Ore Guard OFF | API=%s",b.Used,b.Capacity,api)
end
Runtime.AutoClearTrashBlocked = false
Runtime.AutoClearTrashErrorBlocked = false -- Forge/receipt uncertainty: MUST NOT auto-unblock based on capacity.
Runtime.AutoClearTrashRecoverCheckAt = 0
Runtime.AutoClearTrashSold = 0
Runtime.AutoClearTrashNextScanAt = 0 -- Do not repeatedly scan a clean bag every 0.4 seconds.
Config.AutoSellEquip, Config.AutoEquipBest = false, false
-- Honor the user's explicitly saved Bow ON/OFF selection across reinjections.
Config.BowCombat = (Config.BowCombat == true)
-- One-time migration: saved legacy HoverHeight=8 -> safer 12 studs, still user-editable.
if Config.HoverHeightMigrated496 ~= true then
    if tonumber(Config.HoverHeight)==8 then Config.HoverHeight=12 end
    Config.HoverHeightMigrated496=true
end
Config.HoverHeight=math.clamp(tonumber(Config.HoverHeight) or 30,4,30)
Config.UndergroundHover=(Config.UndergroundHover==true)
Config.UndergroundDepth=math.clamp(tonumber(Config.UndergroundDepth) or 8,4,20)
Config.WheelOfLuck=(Config.WheelOfLuck==true)
Config.AutoCombatPresetEnabled=(Config.AutoCombatPresetEnabled~=false)
if Config.CombatMode~="RANGE" and Config.CombatMode~="MELEE" and Config.CombatMode~="ASTRAL"
    and Config.CombatMode~="ASTRAL_UG" and Config.CombatMode~="CLONE" then Config.CombatMode="RANGE" end
-- Underground is owned exclusively by the combined Mode, including on reinject.
-- Legacy standalone saved toggle is migrated into mode selection, not run in parallel.
Config.UndergroundHover=(Config.CombatMode=="ASTRAL_UG" and Config.AutoCombatPresetEnabled)
-- One-time migration from the retired global Fast Phase setting.
-- Do not force Rush ON merely because the user selects Astral Mode again.
if Config.AstralRushMigrated~=true then
    if Config.FastSkillPhases==true then
        Config.AstralRushQ=true
        Config.AstralRushE=true
        Config.AstralRushR=true
        Config.AstralRushG=true
    end
    Config.AstralRushMigrated=true
end
Config.AstralRushQ=(Config.AstralRushQ==true)
Config.AstralRushE=(Config.AstralRushE==true)
Config.AstralRushR=(Config.AstralRushR==true)
Config.AstralRushG=(Config.AstralRushG==true)
Config.FastSkillPhases=false -- retired, must never drive phase timing
Config.AutoCombatHalloweenAstral=(Config.AutoCombatHalloweenAstral==true)
-- Every override follows the ACTUAL equipped Skill ID, never a universal Q/E/R/G flag.
-- Keep only supported values from saved JSON; old global horizontal toggles are legacy.
if type(Config.SkillDirectionOverrides)~="table" then Config.SkillDirectionOverrides={} end
do
    local safe={}
    local n=0
    for id,dir in pairs(Config.SkillDirectionOverrides) do
        if type(id)=="string" and #id>0 and #id<180
            and (dir=="HORIZONTAL" or dir=="HOVER") and n<300 then
            safe[id]=dir
            n=n+1
        end
    end
    Config.SkillDirectionOverrides=safe
end
-- Descend/Stay-hover is a DIFFERENT axis from planar/target aim.
if type(Config.SkillDescentOverrides)~="table" then Config.SkillDescentOverrides={} end
do
    local safe={}
    local n=0
    for id,mode in pairs(Config.SkillDescentOverrides) do
        if type(id)=="string" and #id>0 and #id<180 and n<300
            and (mode=="DESCEND" or mode=="HOVER") then
            safe[id]=mode
            n=n+1
        end
    end
    Config.SkillDescentOverrides=safe
end
Config.AstralSkillPriority=(Config.AstralSkillPriority~=false)
Config.AstralFastQ=(Config.AstralFastQ~=false)
Config.AstralRFastTest=(Config.AstralRFastTest==true)
Config.AstralRastarM1Projectiles=(Config.AstralRastarM1Projectiles~=false)
Config.AstralOrbitCombat=(Config.AstralOrbitCombat==true)
Config.AstralOrbitRadius=math.clamp(tonumber(Config.AstralOrbitRadius) or 12,8,24)
Config.AstralOrbitPullSeconds=math.clamp(tonumber(Config.AstralOrbitPullSeconds) or 4.5,2,8)
Config.AstralOrbitBurstSeconds=math.clamp(tonumber(Config.AstralOrbitBurstSeconds) or 7,3,15)
Config.ScepterCombat = (Config.ScepterCombat == true)
if Config.AstralOrbitCombat then Config.ScepterCombat=false end
Config.ScepterCombatMode = "FULL"
Config.GrocerySilver = (Config.GrocerySilver==true)
Config.HalloweenMode = (Config.HalloweenMode == true)
Config.ScepterGInterval = math.clamp(tonumber(Config.ScepterGInterval) or 0.10,0.01,0.20)
Config.ScepterS5Interval = math.clamp(tonumber(Config.ScepterS5Interval) or 0.08,0.04,1.0)
Config.DynamicHoldMultiHit = (Config.DynamicHoldMultiHit ~= false)
Config.Aim3DDown = (Config.Aim3DDown==true)
-- Per-account file is authoritative, even if config.json is copied to main account.
-- Without an account-specific file this mode defaults OFF, not to a copied ON.
Config.UltraLowAccountFile=ConfigFolder.."/ultralow_"..tostring(LocalPlayer.UserId)..".json"
Config.UltraLowGraphics=false
do
    local ok,enabled=pcall(function()
        if typeof(isfile)=="function" and isfile(Config.UltraLowAccountFile)
            and typeof(readfile)=="function" then
            local data=HttpService:JSONDecode(readfile(Config.UltraLowAccountFile))
            return type(data)=="table" and data.Enabled==true
        end
        return false
    end)
    if ok then Config.UltraLowGraphics=(enabled==true) end
end
Config.ScepterGBypassClientCooldown = Config.ScepterGBypassClientCooldown == true
Config.FlyDynamicSkills=(Config.FlyDynamicSkills ~= false)
for _,k in ipairs({"FlyHorizontalQ","FlyHorizontalE","FlyHorizontalR","FlyHorizontalG"}) do
    Config[k]=(Config[k]==true)
end
Config.FlyHotkeys=(Config.FlyHotkeys ~= false)
Config.FlyCastDistance=math.clamp(tonumber(Config.FlyCastDistance) or 38,28,55)
Config.FlyCastHold=math.clamp(tonumber(Config.FlyCastHold) or 0.10,0.05,2.0)
-- Q/E/R/G horizontal flags are explicitly user-controlled, including on teleport.
-- Do not overwrite them when restoring a saved Scepter profile.
Config.SmartDodge = Config.SmartDodge ~= false
Config.SmartTargetLock = Config.SmartTargetLock ~= false
Config.AutoRecord = false -- Recorder hidden and autosave disabled; use standalone v1.5
if type(Config.AutoFallbackRooms) ~= "table" then Config.AutoFallbackRooms = {} end
if type(Config.SpawnAnchors) ~= "table" then Config.SpawnAnchors = {} end
-- World1 Diff5 spawn anchors from the recorded JSON, fallback only.
do
    local defaults={["1"]={-675.1343994140625,11.285950660705566,27.95033836364746}, ["2"]={-454.84332275390625,6.635365962982178,43.399749755859375}, ["3"]={-425.662109375,13.227676391601562,211.75372314453125}, ["4"]={1070.2864990234375,9.444025993347168,-9.935873985290527}, ["5"]={387.9281921386719,13.112164497375488,196.39834594726562}, ["6"]={310.94818115234375,6.632350921630859,183.48617553710938}, ["7"]={-2433.32958984375,51.384788513183594,67.07020568847656}, ["8"]={-2466.431396484375,42.87867736816406,-2.3673555850982666}}
    local existing=Config.SpawnAnchors.World1
    if type(existing)~="table" then existing={}; Config.SpawnAnchors.World1=existing end
    for room,xyz in pairs(defaults) do
        local prev=existing[room]
        if type(prev)~="table" or type(prev[1])~="number" or type(prev[2])~="number" or type(prev[3])~="number" then
            existing[room]=table.clone(xyz)
        end
    end
end
Config.AutoStartDungeon = (Config.AutoFarm == true) -- Solo-only auto entry. Manual team combat is independent.
-- Auto Farm Solo ON => legacy Auto Combat + Hybrid; Auto Attack Teleport ON => team combat without Solo Create.
-- Combat workers consult this helper. Lobby auto-entry must continue to check ONLY Config.AutoFarm.
local function combatFarmEnabled()
    return Config.AutoFarm == true or Config.AutoAttackTeleport == true
end
if Config.ActiveTab ~= "Dungeon" and Config.ActiveTab ~= "Combat" and Config.ActiveTab ~= "Forge" and Config.ActiveTab ~= "Utilities" and Config.ActiveTab ~= "Spin" and Config.ActiveTab ~= "Code" then
    Config.ActiveTab = "Dungeon"
end
-- New workers never resume automatically on injection; selections still persist.
Runtime.CharacterEpoch = 0
function Runtime.Acquire(name)
	if Runtime.Owner then return nil end
	local token = {Name=name,Epoch=Runtime.CharacterEpoch,Started=os.clock()}
	Runtime.Owner=token
	return token
end
function Runtime.Release(token)
	if Runtime.Owner==token then Runtime.Owner=nil end
end
if Config.AutoCreateRole~="Solo" and Config.AutoCreateRole~="Follower" then Config.AutoCreateRole="Solo" end

local function getSafeGuiParent()
	-- Use the player's own GUI container; no privileged GUI access required.
	return PlayerGui
end

local uiParent = getSafeGuiParent()
local oldUI = uiParent:FindFirstChild("IronSoulMasterUI")
if oldUI then oldUI:Destroy() end

BootStatus("Đang tạo giao diện...")
local ScreenGui = Instance.new("ScreenGui")
Runtime.Gui = ScreenGui
ScreenGui.Name = "IronSoulMasterUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10000
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = false -- 4.9.36: always start hidden; H shows the GUI.
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = uiParent

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(1, -16, 1, -16)
MainFrame.Position = UDim2.fromOffset(8, 8)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(100, 75, 160)
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Draggable = false
do
    -- UIScale was shrinking the entire compact UI on LDPlayer. Use responsive full screen.
    local function fit()
        local camera=Workspace.CurrentCamera
        local screen=(camera and camera.ViewportSize) or Vector2.new(800,600)
        if screen.X<1 or screen.Y<1 then return end
        if Runtime.Minimized then
            MainFrame.Size=UDim2.fromOffset(math.max(220,math.min(420,screen.X-16)),70)
        else
            MainFrame.Size=UDim2.new(1,-16,1,-16)
        end
        MainFrame.Position=UDim2.fromOffset(8,8)
    end
    Runtime.ResizeAIO=fit
    if Workspace.CurrentCamera then
        table.insert(Runtime.Connections, Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit))
    end
    task.defer(fit)
end

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 34)
Title.BackgroundColor3 = Color3.fromRGB(36, 30, 50)
Title.Text = "IRON SOUL AIO v4.9.50f | H ẨN/HIỆN"
Title.TextColor3 = Color3.fromRGB(240, 205, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -31, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(Runtime.Stop)
table.insert(Runtime.Connections, ScreenGui.Destroying:Connect(function()
	if Runtime.Alive then Runtime.Stop() end
end))

local StatusLbl = Instance.new("TextLabel", MainFrame)
StatusLbl.Size = UDim2.new(1, -14, 0, 32)
StatusLbl.Position = UDim2.new(0, 7, 0, 36)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "Status: Đã nạp cấu hình!"
StatusLbl.TextColor3 = Color3.fromRGB(140, 255, 160)
StatusLbl.Font = Enum.Font.GothamSemibold
StatusLbl.TextSize = 13
StatusLbl.TextWrapped = true
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
table.insert(Runtime.Connections, LocalPlayer.CharacterAdded:Connect(function()
	Runtime.CharacterEpoch = Runtime.CharacterEpoch + 1
    Runtime.HoverTarget,Runtime.HasCombatTarget = nil,false
    Runtime.UndergroundActive=false
    Runtime.UndergroundSavedCF=nil
    Runtime.UndergroundProbe=nil
    if Runtime.CleanupNightCombat then pcall(Runtime.CleanupNightCombat) end
	if Runtime.CancelPatrol then Runtime.CancelPatrol() end
	if Runtime.ReleaseEggInput then Runtime.ReleaseEggInput() end
	if Runtime.ClearTargets then Runtime.ClearTargets() end
	-- Do NOT reset EndlessEntryDone on death; only observed new-run boundaries do that.
end))
local lastErrors = {}
Runtime.Logs = {}
Runtime.LastError = "Chưa có"
function Runtime.Log(message)
	local line = string.format("[%.1f] %s", os.clock(), tostring(message))
	table.insert(Runtime.Logs, line)
	if #Runtime.Logs > 150 then table.remove(Runtime.Logs, 1) end
	print("[IronSoul v23] " .. line)
end
-- v4.9.8 AUTO ANALYTICS: 30-minute build windows and local telemetry. Never infer server DPS.
-- Files live under the executor's own sandbox; no HTTP uploads or external destinations.
do
    local A={
        Started=os.clock(), UnixStarted=os.time(), LastSample=os.clock(), LastFlush=0,
        Events={}, Pending={}, FileCreated=false, FileErrors=0,
        AutoFarmSeconds=0, CombatSeconds=0, DamageObserved=0, HitEvents=0,
        MaxHitObserved=0, HealthAtLastSample=nil, LastWorld="?", LastRoom="?",
        Counters={RoomClears=0, EntryAttempts=0, EntryFailures=0, TerminalDeaths=0,
            CharacterDeaths=0, DodgeStarts=0, DodgeHpLossEvents=0, FlyCastAttempts=0,
            FlyUnsafeSkips=0, FlyNoCasts=0, ForgeReceived=0, ForgeSold=0,
            RouteArrivals=0, RouteFailures=0, LootStarts=0, ErrorEvents=0,
            GroceryRequests=0, RaceRollRequests=0},
    }
    Runtime.Analytics=A
    local reportRoot=ConfigFolder.."/auto_reports"
    local stamp=os.date("!%Y%m%d_%H%M%S").."_U"..tostring(LocalPlayer.UserId)
        .."_T"..tostring(math.floor((os.clock()%1000)*1000))
    local fileBase=reportRoot.."/IronSoul_v499_"..stamp
    A.EventFile=fileBase..".log"
    A.ReportFile=fileBase..".json"
    A.Header="IRON SOUL AIO v4.9.9 | session="..stamp
        .." | PlaceId="..tostring(game.PlaceId).." | JobId="..tostring(game.JobId)
        .."\nCounters are LOCAL observations, not server-confirmed damage or drops.\n"
    local prefixes={
        -- ROOM_CLEAR is a diagnostic event, not the canonical room-clear counter.
        {"STATE DUNGEON_ENTRY","EntryAttempts"},
        {"ENTRY_FAILED","EntryFailures"},
        {"TERMINAL_DEATH","TerminalDeaths"},
        {"DODGE_START","DodgeStarts"},
        {"DODGE_HP_LOSS","DodgeHpLossEvents"},
        {"FLY_CAST_BEGIN","FlyCastAttempts"},
        {"FLY_SKIP_UNSAFE","FlyUnsafeSkips"},
        {"FLY_SKILL_NO_CAST","FlyNoCasts"},
        {"FORGE_RECEIVED","ForgeReceived"},
        {"FORGE_SOLD","ForgeSold"},
        {"ROUTE_ARRIVED","RouteArrivals"},
        {"ROUTE_FAILED","RouteFailures"},
        {"LOOT_START","LootStarts"},
        {"ERROR ","ErrorEvents"},
        {"GROCERY_SENT","GroceryRequests"},
        {"UTIL_RACE_ROLL_SENT","RaceRollRequests"},
    }
    local importantPrefixes={"ROOM_","ENTRY_","STATE DUNGEON_ENTRY","TERMINAL_",
        "DEATH_","DODGE_","FLY_","BOW_","SCEPTER_","FORGE_","AUTO_CLEAR_",
        "ROUTE_","LOOT_","ERROR ","GROCERY_","UTIL_","AUTO_ENTRY_","F_E_B_S_","MYTHIC_TRASH_"}
    local function addEvent(msg)
        local elapsed=math.max(0,os.clock()-A.Started)
        local line=string.format("+%.2fs | %s",elapsed,tostring(msg))
        table.insert(A.Events,line)
        if #A.Events>1800 then table.remove(A.Events,1) end
        table.insert(A.Pending,line)
        -- Bound queued output if the sandbox lacks persistent file support.
        if #A.Pending>1800 then table.remove(A.Pending,1) end
    end
    local baseLog=Runtime.Log
    Runtime.Log=function(message)
        baseLog(message)
        if not Config.AnalyticsEnabled then return end
        local msg=tostring(message)
        for _,pair in ipairs(prefixes) do
            if msg:sub(1,#pair[1])==pair[1] then
                A.Counters[pair[2]]=A.Counters[pair[2]]+1
                break
            end
        end
        for _,prefix in ipairs(importantPrefixes) do
            if msg:sub(1,#prefix)==prefix then addEvent(msg);break end
        end
    end
    function A.Sample()
        local now=os.clock()
        local dt=math.clamp(now-A.LastSample,0,15)
        A.LastSample=now
        if Config.AnalyticsEnabled then
            if Config.AutoFarm then A.AutoFarmSeconds=A.AutoFarmSeconds+dt end
            if Config.AutoFarm or Config.AutoAttackTeleport then
                A.CombatSeconds=A.CombatSeconds+dt
            end
        end
        if Runtime.CurrentRouteInfo then
            local ok,w,r,complete=pcall(Runtime.CurrentRouteInfo)
            if ok then
                A.LastWorld=tostring(w or "Lobby")
                A.LastRoom=tostring(r or "-")
                -- Client-observed server progress: this works in World5 too.
                -- First reading is ONLY a baseline; resets/world changes are NOT negative clears.
                if type(w)=="string" and type(complete)=="number"
                    and complete>=0 and complete<10000 then
                    if A.LastCompleteWorld~=w or A.LastCompleteValue==nil
                        or complete < A.LastCompleteValue then
                        A.LastCompleteWorld=w
                        A.LastCompleteValue=complete
                    elseif complete>A.LastCompleteValue then
                        local gained=math.min(complete-A.LastCompleteValue,100)
                        A.LastCompleteValue=complete
                        if Config.AnalyticsEnabled then
                            A.Counters.RoomClears=A.Counters.RoomClears+gained
                            addEvent(string.format("ROOM_COMPLETE_OBSERVED world=%s room=%s progress=%s plus=%d",
                                tostring(w),tostring(r),tostring(complete),gained))
                        end
                    end
                elseif type(w)=="string" and type(r)=="number"
                    and r==1 and complete==nil then
                    -- New dungeon starts at Room1 with Complete=nil in this game.
                    -- Treat that as zero, so the FIRST clear (nil -> 1) is counted.
                    -- A mid-dungeon injection with Complete=6 is still only a baseline.
                    A.LastCompleteWorld,A.LastCompleteValue=w,0
                else
                    A.LastCompleteWorld,A.LastCompleteValue=nil,nil
                end
            end
        end
        if A.Observe30m then A.Observe30m() end
    end
    local healthConn=nil
    local deathConn=nil
    table.insert(Runtime.Connections,{Disconnect=function()
        if healthConn then healthConn:Disconnect();healthConn=nil end
        if deathConn then deathConn:Disconnect();deathConn=nil end
    end})
    function A.AttachCharacter(char)
        if healthConn then healthConn:Disconnect();healthConn=nil end
        if deathConn then deathConn:Disconnect();deathConn=nil end
        if not char then return end
        task.spawn(function()
            local hum=char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",8)
            if not hum or not Runtime.Alive or LocalPlayer.Character~=char then return end
            local prevHealth=hum.Health
            local deathCounted=false
            local function countDeath(source)
                if deathCounted then return end
                deathCounted=true
                if Config.AnalyticsEnabled then
                    A.Counters.CharacterDeaths=A.Counters.CharacterDeaths+1
                    addEvent("CHARACTER_DIED ("..tostring(source)..")")
                end
            end
            healthConn=hum.HealthChanged:Connect(function(hp)
                local delta=prevHealth-hp
                local oldHP=prevHealth
                prevHealth=hp
                if oldHP>0 and hp<=0 then countDeath("Health<=0") end
                if not Config.AnalyticsEnabled or delta<=0 then return end
                A.DamageObserved=A.DamageObserved+delta
                A.HitEvents=A.HitEvents+1
                A.MaxHitObserved=math.max(A.MaxHitObserved,delta)
                if delta>=10 then
                    addEvent(string.format("HP_LOSS observed=%.1f remaining=%.1f",delta,hp))
                end
            end)
            deathConn=hum.Died:Connect(function() countDeath("Humanoid.Died") end)
        end)
    end
    table.insert(Runtime.Connections,LocalPlayer.CharacterAdded:Connect(A.AttachCharacter))
    if LocalPlayer.Character then A.AttachCharacter(LocalPlayer.Character) end
    local function ensureDir()
        if typeof(writefile)~="function" then return false,"Executor không hỗ trợ writefile" end
        if typeof(isfolder)=="function" and typeof(makefolder)=="function" then
            if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
            if not isfolder(reportRoot) then makefolder(reportRoot) end
        elseif typeof(makefolder)=="function" then
            pcall(makefolder,ConfigFolder)
            pcall(makefolder,reportRoot)
        end
        return true
    end
    function A.Summary(reason)
        A.Sample()
        local elapsed=math.max(0,os.clock()-A.Started)
        local counts={}
        for k,v in pairs(A.Counters) do counts[k]=v end
        return {
            Version="4.9.8", Reason=reason or "AUTO", StartUnix=A.UnixStarted,
            ElapsedSeconds=math.floor(elapsed*10+.5)/10,
            AutoFarmSeconds=math.floor(A.AutoFarmSeconds*10+.5)/10,
            CombatEnabledSeconds=math.floor(A.CombatSeconds*10+.5)/10,
            HPDecreaseObserved=math.floor(A.DamageObserved*10+.5)/10,
            HPLossEvents=A.HitEvents, LargestSingleHPDecrease=A.MaxHitObserved,
            CurrentWorld=A.LastWorld, CurrentRoom=A.LastRoom,
            -- Derived rates are reported only after 2 minutes to avoid misleading startup spikes.
            ObservedRoomsPerHour=(elapsed>=120) and (math.floor(A.Counters.RoomClears*36000/elapsed+.5)/10) or nil,
            HPDecreasePerHour=(elapsed>=120) and (math.floor(A.DamageObserved*36000/elapsed+.5)/10) or nil,
            AutoFarmEnabled=Config.AutoFarm==true, AnalyticsEnabled=Config.AnalyticsEnabled==true,
            Counters=counts, PlaceId=game.PlaceId, JobId=game.JobId,
            Build30mCurrent=A.WindowSnapshot and A.WindowSnapshot("IN_PROGRESS") or nil,
            Build30mFinished=A.CompletedWindows or {},
            Notes={"RoomClear is now increases observed in GameRoundComplete; not proof of loot rewards.",
                "FLY_CAST_BEGIN is a request/attempt, not server-confirmed skill damage.",
                "HP decreases can include environment effects. No real DPS or item drop rate is inferred.",
                "30-minute build windows can resume through quick reinjection when file APIs work.",
                "Dungeon success requires Settlement UI or attribute; start time is observed Room1."}
        }
    end
    function A.Flush(force,reason)
        if not force and not Config.AnalyticsEnabled then return false,"Analytics OFF" end
        if A.Flushing then return false,"Đang ghi log" end
        A.Flushing=true
        local ok,err=pcall(function()
            local ready,msg=ensureDir()
            assert(ready,msg)
            local pendingCount=#A.Pending
            if not A.FileCreated then
                writefile(A.EventFile,A.Header)
                A.FileCreated=true
            end
            if typeof(appendfile)=="function" then
                if pendingCount>0 then
                    local appended=pcall(appendfile,A.EventFile,table.concat(A.Pending,"\n").."\n")
                    if not appended then
                        -- Some executors advertise appendfile but cannot append; use bounded rewrite.
                        writefile(A.EventFile,A.Header..table.concat(A.Events,"\n").."\n")
                    end
                end
            else
                -- No appendfile in some executors. Re-write bounded recent event log.
                writefile(A.EventFile,A.Header..table.concat(A.Events,"\n").."\n")
            end
            -- Commit event watermark before writing the summary. A failed JSON write
            -- must not append the same events again on the next retry.
            table.clear(A.Pending)
            writefile(A.ReportFile,HttpService:JSONEncode(A.Summary(reason or (force and "MANUAL" or "AUTO"))))
            if A.SaveActive30m then A.SaveActive30m() end
            A.LastFlush=os.clock()
        end)
        A.Flushing=false
        if not ok then A.FileErrors=A.FileErrors+1 end
        return ok,err
    end
    -- v4.9.8: per-build 30-minute analytics. Keep the public AIO log unchanged.
    -- All state lives in this analytics do-block, so no extra top-level Luau locals.
    A.WindowSeconds=1800
    A.CompletedWindows={}
    A.WindowCSV=reportRoot.."/BuildComparison_30min.csv"
    A.DungeonCSV=reportRoot.."/DungeonClearTimes.csv"
    A.ActiveWindowFile=reportRoot.."/active_build_test_30min.json"
    A.ActiveRun=nil
    A.RecentDungeonRuns={}
    -- v4.9.39: show the last five FULL SUCCESS Dungeon runs in Combat.
    -- Per-account file keeps the table across Play Again and reinjection.
    A.LastFiveRunsFile=ConfigFolder.."/last_5_dungeon_U"..tostring(LocalPlayer.UserId)..".json"
    A.LastFiveRuns={}
    A.PendingTestQueue={} -- FIFO: one label for each future FULL Dungeon run
    pcall(function()
        if typeof(isfile)=="function" and isfile(A.LastFiveRunsFile)
            and typeof(readfile)=="function" then
            local payload=HttpService:JSONDecode(readfile(A.LastFiveRunsFile))
            if type(payload)=="table" and payload.UserId==LocalPlayer.UserId
                and type(payload.Runs)=="table" then
                for _,r in ipairs(payload.Runs) do
                    if type(r)=="table" and type(r.Seconds)=="number"
                        and r.Seconds>0 and type(r.Deaths)=="number"
                        and r.Deaths>=0 and type(r.RunId)=="string" then
                        A.LastFiveRuns[#A.LastFiveRuns+1]=r
                    end
                end
                while #A.LastFiveRuns>5 do table.remove(A.LastFiveRuns,1) end
                if type(payload.TestQueue)=="table" then
                    for _,description in ipairs(payload.TestQueue) do
                        if type(description)=="string" and description~=""
                            and #description<=240 and #A.PendingTestQueue<20 then
                            A.PendingTestQueue[#A.PendingTestQueue+1]=description
                        end
                    end
                end
            end
        end
    end)
    -- Persist queued tests in the SAME per-account file as the last five results.
    -- Existing installs without this key remain readable.
    function A.SaveDungeonTestHistory()
        if typeof(writefile)~="function" then return false,"Executor does not support writefile" end
        local ok,err=pcall(function()
            if typeof(isfolder)=="function" and typeof(makefolder)=="function"
                and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
            writefile(A.LastFiveRunsFile,HttpService:JSONEncode({
                UserId=LocalPlayer.UserId,Runs=A.LastFiveRuns,
                TestQueue=A.PendingTestQueue,
            }))
        end)
        return ok,err
    end
    -- UI + action only queues a note. It NEVER fabricates a completion row.
    function A.QueueNextDungeonTest(raw)
        local description=type(raw)=="string" and raw:match("^%s*(.-)%s*$") or ""
        if description=="" then return false,"Nhập Description trước khi bấm +" end
        if #description>240 then return false,"Description tối đa 240 byte (khoảng 80 chữ tiếng Việt)" end
        if not Config.AnalyticsEnabled then return false,"Bật Analytics để ghi lượt Dungeon" end
        if #A.PendingTestQueue>=20 then return false,"Hàng chờ tối đa 20 lượt test" end
        A.PendingTestQueue[#A.PendingTestQueue+1]=description
        local ok,err=A.SaveDungeonTestHistory()
        Runtime.Log("DUNGEON_TEST_QUEUED count="..tostring(#A.PendingTestQueue)
            .." label="..description)
        if not ok then
            return true,"Đã xếp lịch trong phiên; chưa lưu được file: "..tostring(err)
        end
        return true,"Đã xếp lịch: "..description
    end
    function A.RecordRecentSuccess(report)
        if not (report and report.Status=="SUCCESS"
            and report.FullRunTiming==true and type(report.ElapsedSeconds)=="number"
            and report.ElapsedSeconds>0) then return end
        for i=#A.LastFiveRuns,1,-1 do
            if A.LastFiveRuns[i].RunId==report.RunId then
                table.remove(A.LastFiveRuns,i)
            end
        end
        A.LastFiveRuns[#A.LastFiveRuns+1]={
            RunId=report.RunId,World=report.World,Diff=report.Diff,
            Seconds=report.ElapsedSeconds,Deaths=math.max(0,math.floor(report.Deaths or 0)),
            FinishedUnix=report.FinishedUnix,
            Description=type(report.Description)=="string" and report.Description or "",
        }
        while #A.LastFiveRuns>5 do table.remove(A.LastFiveRuns,1) end
        -- Consume ONLY the description reserved when this actual run began.
        -- A newly queued note added mid-run remains for the NEXT run.
        if type(report.Description)=="string" and report.Description~=""
            and A.PendingTestQueue[1]==report.Description then
            table.remove(A.PendingTestQueue,1)
        end
        local ok,err=A.SaveDungeonTestHistory()
        if not ok then Runtime.Log("DUNGEON_TEST_SAVE_FAILED "..tostring(err)) end
    end
    -- Rolling 60-minute full-run timings, persisted per account across teleports.
    -- Not the whole analytics payload; never count partial or incomplete runs.
    A.FarmHourFile=ConfigFolder.."/farm_60min_U"..tostring(LocalPlayer.UserId)..".json"
    A.FarmHourRuns={}
    pcall(function()
        if typeof(isfile)=="function" and isfile(A.FarmHourFile) and typeof(readfile)=="function" then
            local payload=HttpService:JSONDecode(readfile(A.FarmHourFile))
            if type(payload)=="table" and type(payload.Runs)=="table" then
                local now=os.time()
                for _,row in ipairs(payload.Runs) do
                    if type(row)=="table" and type(row.At)=="number"
                        and row.At<=now and now-row.At<=3600
                        and type(row.Seconds)=="number" and row.Seconds>0
                        and type(row.World)=="string" then
                        A.FarmHourRuns[#A.FarmHourRuns+1]=row
                    end
                end
            end
        end
    end)
    function A.FarmAverage(minutes)
        local now=os.time()
        local rows=A.FarmHourRuns
        local world,diff=nil,nil
        for i=#rows,1,-1 do
            local r=rows[i]
            if type(r)=="table" and now-(r.At or 0)<=3600 then
                world,diff=r.World,r.Diff;break
            end
        end
        if not world then return nil,0,nil,nil end
        local total,n=0,0
        for _,r in ipairs(rows) do
            if now-(r.At or 0)<=minutes*60
                and r.World==world and tostring(r.Diff)==tostring(diff) then
                total=total+(r.Seconds or 0);n=n+1
            end
        end
        return n>0 and total/n or nil,n,world,diff
    end
    A.DungeonRunSequence=0
    A.WindowIndex=0
    local allCountKeys={"RoomClears","CharacterDeaths","TerminalDeaths","DodgeStarts",
        "DodgeHpLossEvents","FlyCastAttempts","FlyUnsafeSkips","FlyNoCasts",
        "ForgeReceived","ForgeSold","RouteArrivals","RouteFailures","EntryAttempts",
        "EntryFailures","ErrorEvents"}
    local function cleanName(value)
        local v=tostring(value or "Build A"):gsub("[%c]"," "):sub(1,55)
        if v:gsub("%s+","")=="" then return "Build A" end
        return v
    end
    local function copyCounters()
        local c={}
        for _,k in ipairs(allCountKeys) do c[k]=A.Counters[k] or 0 end
        return c
    end
    local function readableNumber(v)
        if typeof(v)=="Instance" and v:IsA("ValueBase") then v=v.Value end
        if type(v)=="table" then
            if type(v.Amount)=="number" then v=v.Amount
            elseif type(v.Value)=="number" then v=v.Value
            elseif type(v.Count)=="number" then v=v.Count end
        end
        if type(v)=="string" then v=tonumber((v:gsub(",",""))) end
        if type(v)=="number" and v==v and v>=0 and v<1e15 then return v end
        return nil
    end
    local function splitPath(path)
        local parts={}
        for part in tostring(path):gmatch("[^%.]+") do
            if part~="" and #parts<8 then parts[#parts+1]=part end
        end
        return parts
    end
    local balanceCandidates={
        Gold={"Currencies.Gold","Currency.Gold","Gold","GoldCoin","GoldCoins",
            "Currencies.Currency1","Currency.Currency1","Currency1","Wallet.Gold",
            "PlayerInfo.Gold","PlayerData.Gold"},
        Cores={"Currencies.Cores","Currency.Cores","Cores","Core",
            "Currencies.Core","Currency.Core","Inventory.Cores",
            "Materials.Cores","Material.Cores","Bag.Cores"},
    }
    function A.ReadBalance(kind)
        local custom=kind=="Gold" and Config.AnalyticsGoldPath or Config.AnalyticsCorePath
        local paths={}
        if type(custom)=="string" and custom~="" then
            paths[1]=custom
        else
            for _,path in ipairs(balanceCandidates[kind] or {}) do paths[#paths+1]=path end
        end
        for _,path in ipairs(paths) do
            local parts=splitPath(path)
            if #parts>0 then
                local ok,val=pcall(function() return DataUtil:GetValue(LocalPlayer,parts) end)
                if ok then
                    local number=readableNumber(val)
                    if number~=nil then
                        local tentative=(path=="Currency1" or path:find(".Currency1",1,true))
                        return number,"DataUtil:"..path..(tentative and " [check=Gold]" or "")
                    end
                end
            end
        end
        -- Fall back to a bounded scan of root player data for an EXACT key match.
        -- No fuzzy substring matches (e.g. GoldShopPrice is NOT Gold balance).
        A.DiscoveredBalancePaths=A.DiscoveredBalancePaths or {}
        A.DiscoveryCheckedAt=A.DiscoveryCheckedAt or {}
        if not (type(custom)=="string" and custom~="") then
            local cached=A.DiscoveredBalancePaths[kind]
            if cached then
                local ok,value=pcall(function() return DataUtil:GetValue(LocalPlayer,splitPath(cached)) end)
                local number=ok and readableNumber(value) or nil
                if number~=nil then return number,"DataUtil:discovered:"..cached end
            end
            if os.clock()-(A.DiscoveryCheckedAt[kind] or -math.huge)>30 then
                A.DiscoveryCheckedAt[kind]=os.clock()
                local ok,root=pcall(function() return DataUtil:GetValue(LocalPlayer,{}) end)
                if ok and type(root)=="table" then
                    local hits={}
                    local seen={}
                    local budget=300
                    local desired=kind=="Gold" and {Gold=true,GoldCoins=true}
                        or {Core=true,Cores=true}
                    local function inspect(tbl,prefix,depth)
                        if seen[tbl] or depth>4 or budget<=0 then return end
                        seen[tbl]=true
                        for key,v in pairs(tbl) do
                            budget=budget-1
                            if budget<=0 then break end
                            if type(key)=="string" then
                                local path=prefix=="" and key or (prefix.."."..key)
                                if desired[key] then
                                    local number=readableNumber(v)
                                    if number~=nil then hits[#hits+1]={Path=path,Value=number} end
                                end
                                if depth<4 and type(v)=="table" and key~="Equipment"
                                    and key~="Ores" and key~="Owned" and key~="Items" then
                                    inspect(v,path,depth+1)
                                end
                            end
                        end
                    end
                    inspect(root,"",0)
                    if #hits==1 then
                        A.DiscoveredBalancePaths[kind]=hits[1].Path
                        return hits[1].Value,"DataUtil:discovered:"..hits[1].Path
                    end
                end
            end
        end
        -- Leaderstats/Attributes are fallbacks, never guessed from unrelated UI strings.
        local names=(kind=="Gold") and {"Gold","GoldCoins"} or {"Cores","Core"}
        for _,n in ipairs(names) do
            local ls=LocalPlayer:FindFirstChild("leaderstats")
            local child=ls and ls:FindFirstChild(n)
            local val=child and readableNumber(child)
            if val~=nil then return val,"leaderstats:"..n end
            local ok,att=pcall(function() return LocalPlayer:GetAttribute(n) end)
            val=ok and readableNumber(att) or nil
            if val~=nil then return val,"PlayerAttribute:"..n end
        end
        return nil,nil
    end
    local function makeBalances()
        return {Gold={Start=nil,Last=nil,Gained=0,Spent=0,Source=nil,Samples=0},
                Cores={Start=nil,Last=nil,Gained=0,Spent=0,Source=nil,Samples=0}}
    end
    local function balancesFromSaved(saved)
        local balances=makeBalances()
        if type(saved)=="table" then
            for _,key in ipairs({"Gold","Cores"}) do
                local b=type(saved[key])=="table" and saved[key] or {}
                for _,field in ipairs({"Start","Last","Gained","Spent","Source","Samples"}) do
                    if b[field]~=nil then balances[key][field]=b[field] end
                end
            end
        end
        return balances
    end
    local function countWindow(w,k)
        return (w.PriorCounters[k] or 0)+math.max(0,(A.Counters[k] or 0)-(w.BaselineCounters[k] or 0))
    end
    local function round1(x)
        return math.floor(x*10+0.5)/10
    end
    local function summarizeRuns(runs)
        local grouped={}
        local allSuccess=0
        local allTimed=0
        local total=0
        local best=nil
        local latest=nil
        local combos={}
        for _,r in ipairs(runs or {}) do
            local key=tostring(r.World or "?").."/Diff"..tostring(r.Diff or "?")
            local g=grouped[key]
            if not g then
                g={World=r.World,Diff=r.Diff,Success=0,FullTimed=0,
                    SumClearSeconds=0,FastestClearSeconds=nil,LastClearSeconds=nil,
                    Incomplete=0,RoomClearsObserved=0}
                grouped[key]=g
            end
            g.RoomClearsObserved=g.RoomClearsObserved+(tonumber(r.RoomClearsObserved) or 0)
            if r.Status=="SUCCESS" then
                g.Success=g.Success+1
                allSuccess=allSuccess+1
                if r.FullRunTiming==true and type(r.ElapsedSeconds)=="number" then
                    g.FullTimed=g.FullTimed+1
                    g.SumClearSeconds=g.SumClearSeconds+r.ElapsedSeconds
                    g.FastestClearSeconds=math.min(g.FastestClearSeconds or math.huge,r.ElapsedSeconds)
                    g.LastClearSeconds=r.ElapsedSeconds
                    allTimed=allTimed+1
                    total=total+r.ElapsedSeconds
                    best=math.min(best or math.huge,r.ElapsedSeconds)
                    latest=r.ElapsedSeconds
                end
            else
                g.Incomplete=g.Incomplete+1
            end
            combos[key]=true
        end
        local groupCount=0
        local onlyKey=nil
        for key,g in pairs(grouped) do
            g.AverageClearSeconds=g.FullTimed>0 and round1(g.SumClearSeconds/g.FullTimed) or nil
            g.SumClearSeconds=round1(g.SumClearSeconds)
            if g.FastestClearSeconds then g.FastestClearSeconds=round1(g.FastestClearSeconds) end
            if g.LastClearSeconds then g.LastClearSeconds=round1(g.LastClearSeconds) end
            groupCount=groupCount+1
            onlyKey=key
        end
        return {ByWorldDiff=grouped,WorldDiff=(groupCount==1 and onlyKey or (groupCount==0 and "N/A" or "MIXED")),
            FullClears=allTimed,SuccessObserved=allSuccess,
            AverageClearSeconds=allTimed>0 and round1(total/allTimed) or nil,
            FastestClearSeconds=best and round1(best) or nil,
            LastClearSeconds=latest and round1(latest) or nil}
    end
    function A.RunSummaryForCurrentWindow()
        local w=A.CurrentWindow
        return summarizeRuns(w and w.Runs or {})
    end
    function A.LiveRunStatus()
        local r=A.ActiveRun
        if not r then return nil end
        local elapsed=(r.StartClock and not r.Resumed) and math.max(0,os.clock()-r.StartClock)
            or math.max(0,os.time()-r.StartUnix)
        return {World=r.World,Diff=r.Diff,Room=r.LastRoom,ElapsedSeconds=round1(elapsed),
            FullRunTiming=r.FullRunTiming==true,RoomClearsObserved=r.RoomClearsObserved or 0}
    end
    function A.WindowSnapshot(reason)
        local w=A.CurrentWindow
        if not w then return nil end
        local elapsed=math.max(0,os.time()-w.StartedUnix)
        local seconds=math.min(elapsed,A.WindowSeconds)
        local counts={}
        for _,k in ipairs(allCountKeys) do counts[k]=countWindow(w,k) end
        local hp=(w.PriorDamage or 0)+math.max(0,A.DamageObserved-(w.BaselineDamage or 0))
        local farm=(w.PriorFarm or 0)+math.max(0,A.AutoFarmSeconds-(w.BaselineFarm or 0))
        local combat=(w.PriorCombat or 0)+math.max(0,A.CombatSeconds-(w.BaselineCombat or 0))
        local bOut={}
        for _,key in ipairs({"Gold","Cores"}) do
            local b=w.Balances[key]
            bOut[key]={Start=b.Start,EndBalance=b.Last,Net=(b.Start~=nil and b.Last~=nil) and (b.Last-b.Start) or nil,
                GainedObserved=b.Start~=nil and b.Gained or nil,
                SpentObserved=b.Start~=nil and b.Spent or nil,
                Source=b.Source,SampleCount=b.Samples,Available=(b.Start~=nil),
            }
        end
        local runStats=summarizeRuns(w.Runs)
        return {
            Schema="IronSoul.BuildTest30m.v2",Build=w.Build,TestId=w.TestId,
            WindowIndex=w.Index,StartedUnix=w.StartedUnix,LastObservedUnix=os.time(),
            ElapsedSeconds=seconds,TargetSeconds=A.WindowSeconds,
            Status=reason or "IN_PROGRESS",WorldStart=w.WorldStart,
            WorldNow=A.LastWorld,RoomNow=A.LastRoom,
            Counters=counts,HPDecreaseObserved=math.floor(hp*10+.5)/10,
            AutoFarmSeconds=math.floor(farm*10+.5)/10,
            CombatEnabledSeconds=math.floor(combat*10+.5)/10,
            Balance=bOut,
            DungeonRuns=w.Runs,WorldDiffBreakdown=runStats.ByWorldDiff,
            DungeonWorldDiff=runStats.WorldDiff,
            DungeonFullClears=runStats.FullClears,
            DungeonSuccessObserved=runStats.SuccessObserved,
            AvgClearSeconds=runStats.AverageClearSeconds,
            FastestClearSeconds=runStats.FastestClearSeconds,
            LastClearSeconds=runStats.LastClearSeconds,
            DungeonLive=A.LiveRunStatus(),
            RoomsPer30mEquivalent=seconds>=120 and (math.floor(counts.RoomClears*18000/seconds+.5)/10) or nil,
            Notes={"World/Diff read from GameRoundCfg attributes; SUCCESS only on settlement signal.",
                "Dungeon timing begins at first observed room, not the earlier matchmaking request.",
                "Mid-run injections without resumed state are EXCLUDED from average full clear times.",
                "Cores are client-observed balances, not server-confirmed drops.",
                "N/A means the game balance path is unknown; no fake zero is reported.",
                "Timing is wall-clock. Active AutoFarm time excludes observed inactive periods.",
                "Window can resume across quick reinjection only if file APIs work."},
        }
    end
    function A.Observe30m()
        if not Config.AnalyticsEnabled then return end
        local w=A.CurrentWindow
        if not w then return end
        local now=os.clock()
        if now-(A.LastBalancesAt or 0)<4 then return end
        A.LastBalancesAt=now
        for _,kind in ipairs({"Cores"}) do
            local val,source=A.ReadBalance(kind)
            if val~=nil then
                local b=w.Balances[kind]
                if b.Start==nil then
                    b.Start,b.Last,b.Source,b.Samples=val,val,source,1
                    addEvent("BALANCE_SOURCE "..kind.." "..source.." baseline="..tostring(val))
                elseif b.Source==source then
                    local delta=val-b.Last
                    if delta>0 then b.Gained=b.Gained+delta
                    elseif delta<0 then b.Spent=b.Spent-delta end
                    b.Last,b.Samples=val,b.Samples+1
                else
                    -- Never compute fictitious gains across different sources/IDs.
                    addEvent("BALANCE_SOURCE_CHANGED "..kind.." from="..tostring(b.Source).." to="..tostring(source))
                    b.Start,b.Last,b.Source,b.Gained,b.Spent,b.Samples=val,val,source,0,0,1
                end
            end
        end
        if os.time()-w.StartedUnix>=A.WindowSeconds then
            A.CloseWindow("COMPLETE_30MIN")
            A.StartWindow(Config.AnalyticsBuildName)
        end
    end
    local function csvField(x)
        local v=tostring(x==nil and "N/A" or x)
        return '"'..v:gsub('"','""')..'"'
    end
    local csvColumns={"TestId","Build","WindowIndex","Status","StartedUnix","ElapsedSeconds",
        "DungeonWorldDiff","CompletedDungeonRuns","SuccessObserved","AvgClearSeconds",
        "BestClearSeconds","LastClearSeconds","RoomClears","Deaths","TerminalDeaths",
        "HPDecrease","DodgeStarts","DodgeHitEvents","FlyCasts","FlyUnsafeSkips",
        "AutoFarmSeconds","CoresGainedObserved","CoresNet","ErrorEvents"}
    local function snapshotRow(snap)
        local c=snap.Counters
        local core=snap.Balance.Cores
        local values={snap.TestId,snap.Build,snap.WindowIndex,snap.Status,snap.StartedUnix,
            snap.ElapsedSeconds,snap.DungeonWorldDiff,snap.DungeonFullClears,
            snap.DungeonSuccessObserved,snap.AvgClearSeconds,snap.FastestClearSeconds,
            snap.LastClearSeconds,c.RoomClears,c.CharacterDeaths,c.TerminalDeaths,
            snap.HPDecreaseObserved,c.DodgeStarts,c.DodgeHpLossEvents,
            c.FlyCastAttempts,c.FlyUnsafeSkips,snap.AutoFarmSeconds,
            core.GainedObserved,core.Net,c.ErrorEvents}
        -- Numeric positions may contain nil when the currency is not discoverable.
        -- ipairs/#values would truncate at the first hole; serialize fixed CSV columns.
        local fields={}
        for i=1,#csvColumns do fields[i]=csvField(values[i]) end
        return table.concat(fields,",")
    end
    local function saveFinalWindow(snap)
        local ok,err=pcall(function()
            local ready,msg=ensureDir()
            assert(ready,msg)
            local fileName=reportRoot.."/BuildTest_"..tostring(snap.TestId).."_W"..tostring(snap.WindowIndex)..".json"
            writefile(fileName,HttpService:JSONEncode(snap))
            local header=table.concat(csvColumns,",").."\n"
            local row=snapshotRow(snap).."\n"
            if typeof(isfile)=="function" and isfile(A.WindowCSV) then
                if typeof(appendfile)=="function" then
                    local added=pcall(appendfile,A.WindowCSV,row)
                    if not added then writefile(A.WindowCSV,readfile(A.WindowCSV)..row) end
                else
                    writefile(A.WindowCSV,readfile(A.WindowCSV)..row)
                end
            else
                writefile(A.WindowCSV,header..row)
            end
        end)
        if not ok then
            A.FileErrors=A.FileErrors+1
            warn("[IronSoul Analytics] 30m report write failed: "..tostring(err))
        end
    end
    function A.SaveActive30m()
        if not A.CurrentWindow then return end
        local ready,msg=ensureDir()
        assert(ready,msg)
        local snap=A.WindowSnapshot("IN_PROGRESS")
        local w=A.CurrentWindow
        writefile(A.ActiveWindowFile,HttpService:JSONEncode({Active=true,UserId=LocalPlayer.UserId,
            SavedAtUnix=os.time(),Window={Build=w.Build,TestId=w.TestId,Index=w.Index,
            StartedUnix=w.StartedUnix,WorldStart=w.WorldStart,Balances=w.Balances},
            ActiveRun=A.ActiveRun,Snapshot=snap}))
    end
    function A.CloseWindow(reason)
        local snap=A.WindowSnapshot(reason or "PARTIAL")
        if not snap then return nil end
        A.CompletedWindows[#A.CompletedWindows+1]=snap
        if #A.CompletedWindows>12 then table.remove(A.CompletedWindows,1) end
        saveFinalWindow(snap)
        addEvent(string.format("BUILD_WINDOW_FINISHED build=%s secs=%d clears=%d dead=%d HP=%.1f status=%s",
            snap.Build,snap.ElapsedSeconds,snap.Counters.RoomClears,snap.Counters.CharacterDeaths,
            snap.HPDecreaseObserved,tostring(snap.Status)))
        A.CurrentWindow=nil
        -- Mark the old resume record closed; prevents an injection from reviving it.
        pcall(function()
            local ready=ensureDir()
            if ready then writefile(A.ActiveWindowFile,HttpService:JSONEncode({Active=false,ClosedUnix=os.time()})) end
        end)
        return snap
    end
    function A.StartWindow(name,saved)
        local n=cleanName(name)
        local base=saved and saved.Window or nil
        local snap=saved and saved.Snapshot or nil
        A.WindowIndex=(base and base.Index) or (A.WindowIndex+1)
        A.CurrentWindow={
            Build=n,Index=A.WindowIndex,
            TestId=(base and base.TestId) or (stamp.."_B"..tostring(A.WindowIndex)),
            StartedUnix=(base and base.StartedUnix) or os.time(),
            WorldStart=(base and base.WorldStart) or A.LastWorld,
            BaselineCounters=copyCounters(),PriorCounters=(snap and snap.Counters) or {},
            BaselineDamage=A.DamageObserved,PriorDamage=(snap and snap.HPDecreaseObserved) or 0,
            BaselineFarm=A.AutoFarmSeconds,PriorFarm=(snap and snap.AutoFarmSeconds) or 0,
            BaselineCombat=A.CombatSeconds,PriorCombat=(snap and snap.CombatEnabledSeconds) or 0,
            Balances=balancesFromSaved(base and base.Balances),
            Runs=(snap and type(snap.DungeonRuns)=="table") and snap.DungeonRuns or {},
        }
        Config.AnalyticsBuildName=n
        A.LastBalancesAt=-math.huge
        addEvent("BUILD_WINDOW_START name="..n.." index="..tostring(A.WindowIndex)..(saved and " RESUMED" or ""))
        A.Observe30m()
    end
    function A.SwitchBuild(name)
        assert(GamePlaceUtil:IsMain() and not A.ActiveRun,
            "Đổi build khi ở Lobby để kết quả một Dungeon thuộc đúng một build")
        A.Sample()
        local snap=A.WindowSnapshot("PARTIAL_SWITCH_BUILD")
        if snap and snap.ElapsedSeconds>=5 then A.CloseWindow("PARTIAL_SWITCH_BUILD")
        else A.CurrentWindow=nil end
        A.StartWindow(name)
    end
    -- Per-Dungeon timers: actual game World/Diff, never inferred from UI selector.
    local function currentDungeonState()
        local cfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
        if not cfg or GamePlaceUtil:IsMain() then return nil end
        local world=cfg:GetAttribute("WorldId")
        local diff=tonumber(cfg:GetAttribute("DiffLevel"))
        local room=tonumber(cfg:GetAttribute("GameRound"))
        local complete=tonumber(cfg:GetAttribute("GameRoundComplete"))
        if type(world)~="string" or not world:match("^World%d+$") or
            not diff or not room or diff<1 or diff>30 or room<1 or room>100 then return nil end
        return {World=world,Diff=diff,Room=room,Complete=complete}
    end
    local function isSettlementVisible()
        local gui=PlayerGui:FindFirstChild("ResultGui")
        local settlement=gui and gui:FindFirstChild("ScreenSettlement")
        return settlement and settlement.Visible==true
            and (not gui:IsA("ScreenGui") or gui.Enabled==true)
    end
    local function runElapsed(r)
        if type(r.StartClock)=="number" and r.Resumed~=true then
            return math.max(0,os.clock()-r.StartClock)
        end
        return math.max(0,os.time()-(r.StartUnix or os.time()))
    end
    local function appendDungeonRow(report)
        local cols={"RunId","Build","World","Diff","Status","FullRunTiming",
            "StartedUnix","FinishedUnix","ElapsedSeconds","FirstRoom","LastRoom",
            "RoomClearsObserved","Deaths","HPDecrease","DodgeStarts","Source"}
        local fields={report.RunId,report.Build,report.World,report.Diff,report.Status,
            tostring(report.FullRunTiming),report.StartUnix,report.FinishedUnix,
            report.ElapsedSeconds,report.FirstRoom,report.LastRoom,report.RoomClearsObserved,
            report.Deaths,report.HPDecreaseObserved,report.DodgeStarts,report.Source}
        local line={}
        for i=1,#cols do line[i]=csvField(fields[i]) end
        local ok,err=pcall(function()
            local ready,msg=ensureDir()
            assert(ready,msg)
            local head=table.concat(cols,",").."\n"
            local row=table.concat(line,",").."\n"
            if typeof(isfile)=="function" and isfile(A.DungeonCSV) then
                if typeof(appendfile)=="function" then
                    local written=pcall(appendfile,A.DungeonCSV,row)
                    if not written then writefile(A.DungeonCSV,readfile(A.DungeonCSV)..row) end
                else
                    writefile(A.DungeonCSV,readfile(A.DungeonCSV)..row)
                end
            else
                writefile(A.DungeonCSV,head..row)
            end
            writefile(reportRoot.."/DungeonRun_"..tostring(report.RunId)..".json",
                HttpService:JSONEncode(report))
        end)
        if not ok then
            A.FileErrors=A.FileErrors+1
            warn("[IronSoul Analytics] DungeonClearTimes write failed: "..tostring(err))
        end
    end
    local function finishDungeon(status,source)
        local r=A.ActiveRun
        if not r or r.Finished then return end
        r.Finished=true
        local elapsed=round1(runElapsed(r))
        local deaths=(r.PriorDeaths or 0)+math.max(0,A.Counters.CharacterDeaths-(r.StartDeaths or 0))
        local dodges=(r.PriorDodges or 0)+math.max(0,A.Counters.DodgeStarts-(r.StartDodges or 0))
        local lost=(r.PriorDamage or 0)+math.max(0,A.DamageObserved-(r.StartDamage or 0))
        local report={Schema="IronSoul.DungeonClear.v1",RunId=r.RunId,
            Build=r.Build,World=r.World,Diff=r.Diff,
            Status=status,FullRunTiming=r.FullRunTiming==true,
            StartEvidence=r.StartEvidence,StartedUnix=r.StartUnix,
            FinishedUnix=os.time(),ElapsedSeconds=elapsed,
            FirstRoom=r.FirstRoom,LastRoom=r.LastRoom,
            RoomClearsObserved=r.RoomClearsObserved or 0,
            Deaths=deaths,HPDecreaseObserved=round1(lost),DodgeStarts=dodges,
            Description=r.TestDescription or "",
            Source=source or "UNKNOWN",TimingNote="Start=first room observed by AIO; when mid-run, no full-time claim"}
        local win=A.CurrentWindow
        if win then
            win.Runs[#win.Runs+1]=report
            if #win.Runs>100 then table.remove(win.Runs,1) end
        end
        A.RecentDungeonRuns[#A.RecentDungeonRuns+1]=report
        if #A.RecentDungeonRuns>10 then table.remove(A.RecentDungeonRuns,1) end
        if A.RecordRecentSuccess then A.RecordRecentSuccess(report) end
        if Runtime.DailyRunSuccess then pcall(Runtime.DailyRunSuccess,report) end
        if Runtime.DungeonCounterOnSuccess then pcall(Runtime.DungeonCounterOnSuccess,report) end
        if status=="SUCCESS" and report.FullRunTiming==true and elapsed>0 then
            local now=os.time()
            local hour=A.FarmHourRuns
            hour[#hour+1]={At=now,Seconds=elapsed,World=r.World,Diff=r.Diff,RunId=r.RunId}
            for i=#hour,1,-1 do
                if now-(hour[i].At or 0)>3600 or #hour>150 then table.remove(hour,i) end
            end
            pcall(function()
                if typeof(writefile)=="function" then
                    if typeof(isfolder)=="function" and typeof(makefolder)=="function"
                        and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
                    writefile(A.FarmHourFile,HttpService:JSONEncode({Runs=hour,UserId=LocalPlayer.UserId}))
                end
            end)
        end
        addEvent(string.format("DUNGEON_%s world=%s diff=%s seconds=%.1f rooms=%d full=%s source=%s",
            status,r.World,tostring(r.Diff),elapsed,report.RoomClearsObserved,
            tostring(report.FullRunTiming),tostring(source)))
        appendDungeonRow(report)
        if status=="SUCCESS" then
            A.PostClearLatch={World=r.World,Diff=r.Diff,LastRoom=r.LastRoom,
                LastComplete=r.LastComplete}
        end
        A.ActiveRun=nil
        -- Clear or abort must be persisted immediately, not lost to teleport.
        pcall(function() A.SaveActive30m() end)
        return report
    end
    function A.ObserveDungeonRun()
        if not Config.AnalyticsEnabled or not Runtime.Alive then return end
        local state=currentDungeonState()
        local now=os.clock()
        local r=A.ActiveRun
        if not state then
            if r then
                r.AbsentSince=r.AbsentSince or now
                if now-r.AbsentSince>=8 then finishDungeon("INCOMPLETE","LEFT_DUNGEON_NO_SETTLEMENT") end
            end
            return
        end
        if r and (r.World~=state.World or r.Diff~=state.Diff or
            (state.Room==1 and (r.LastRoom or 1)>1 and state.Complete==nil)) then
            finishDungeon("INCOMPLETE","CHANGED_WORLD_DIFF_OR_RESET")
            r=nil
        end
        if not r then
            -- A settlement can hide before actual teleport; do not create a fake new run.
            local latch=A.PostClearLatch
            if latch then
                local newRoom1=state.Room==1 and (state.Complete==nil or state.Complete==0)
                if state.World~=latch.World or state.Diff~=latch.Diff or
                    (newRoom1 and ((latch.LastRoom or 1)>1 or (latch.LastComplete or 0)>0)) then
                    A.PostClearLatch=nil
                else
                    return
                end
            end
            -- Do not treat an already-visible settlement during reinjection as a full run.
            if isSettlementVisible() or LocalPlayer:GetAttribute("Settlement")==true then return end
            A.DungeonRunSequence=A.DungeonRunSequence+1
            local firstRoom=(state.Room==1 and (state.Complete==nil or state.Complete==0))
            r={RunId=stamp.."_R"..tostring(A.DungeonRunSequence),
                Build=(A.CurrentWindow and A.CurrentWindow.Build) or Config.AnalyticsBuildName,
                World=state.World,Diff=state.Diff,FirstRoom=state.Room,LastRoom=state.Room,
                LastComplete=state.Complete or (firstRoom and 0 or nil),
                StartUnix=os.time(),StartClock=os.clock(),Resumed=false,
                FullRunTiming=firstRoom,StartEvidence=firstRoom and "ROOM1_OBSERVED" or "MID_RUN_INJECTION",
                TestDescription=firstRoom and A.PendingTestQueue[1] or nil,
                StartDeaths=A.Counters.CharacterDeaths,StartDamage=A.DamageObserved,
                StartDodges=A.Counters.DodgeStarts,RoomClearsObserved=0}
            A.ActiveRun=r
            addEvent(string.format("DUNGEON_TIMER_START world=%s diff=%s room=%d full=%s",
                r.World,tostring(r.Diff),r.FirstRoom,tostring(r.FullRunTiming)))
        end
        r.AbsentSince=nil
        r.LastRoom=state.Room
        if type(state.Complete)=="number" and type(r.LastComplete)=="number" then
            if state.Complete>r.LastComplete then
                local change=math.min(100,state.Complete-r.LastComplete)
                r.RoomClearsObserved=(r.RoomClearsObserved or 0)+change
                r.LastComplete=state.Complete
            elseif state.Complete<r.LastComplete then
                r.LastComplete=state.Complete
            end
        elseif type(state.Complete)=="number" then
            r.LastComplete=state.Complete
        end
        if LocalPlayer:GetAttribute("Settlement")==true then
            -- Settlement is the server-derived player state; route logic also uses it.
            finishDungeon("SUCCESS","SETTLEMENT_ATTRIBUTE")
        end
    end
    function A.MarkDungeonClear(source)
        if not Config.AnalyticsEnabled then return end
        if not A.ActiveRun then A.ObserveDungeonRun() end
        if A.ActiveRun then return finishDungeon("SUCCESS",source or "SETTLEMENT_UI") end
    end
    -- Lightweight attribute monitoring prevents missing a short-lived settlement UI.
    table.insert(Runtime.Connections,LocalPlayer:GetAttributeChangedSignal("Settlement"):Connect(function()
        if LocalPlayer:GetAttribute("Settlement")==true and A.MarkDungeonClear then
            pcall(A.MarkDungeonClear,"SETTLEMENT_ATTRIBUTE_CHANGED")
        end
    end))
    task.spawn(function()
        while Runtime.Alive do
            task.wait(1)
            if Runtime.Alive and A.ObserveDungeonRun then
                local ok,err=pcall(A.ObserveDungeonRun)
                if not ok and not A.RunObserveErrorWarned then
                    A.RunObserveErrorWarned=true
                    warn("[IronSoul Analytics] run observer error: "..tostring(err))
                end
            end
        end
    end)

    -- Resume a comparison window across quick dungeon/lobby teleports or reinjections.
    local resumed=nil
    pcall(function()
        if typeof(isfile)=="function" and isfile(A.ActiveWindowFile)
            and typeof(readfile)=="function" then
            local cached=HttpService:JSONDecode(readfile(A.ActiveWindowFile))
            if type(cached)=="table" and cached.Active==true
                and cached.UserId==LocalPlayer.UserId and type(cached.Window)=="table"
                and type(cached.Snapshot)=="table" and type(cached.SavedAtUnix)=="number"
                and os.time()-cached.SavedAtUnix>=0 and os.time()-cached.SavedAtUnix<=180
                and type(cached.Window.StartedUnix)=="number"
                and os.time()-cached.Window.StartedUnix<7200 then
                resumed=cached
            end
        end
    end)
    A.StartWindow(resumed and resumed.Window.Build or Config.AnalyticsBuildName,resumed)
    if resumed and type(resumed.ActiveRun)=="table" then
        local r=resumed.ActiveRun
        if type(r.StartUnix)=="number" and os.time()-r.StartUnix>=0
            and os.time()-r.StartUnix<7200 and r.Finished~=true then
            r.StartClock=nil
            r.Resumed=true
            r.AbsentSince=nil
            r.StartDeaths=A.Counters.CharacterDeaths
            r.StartDamage=A.DamageObserved
            r.StartDodges=A.Counters.DodgeStarts
            A.ActiveRun=r
            addEvent("DUNGEON_TIMER_RESUMED world="..tostring(r.World).." diff="..tostring(r.Diff))
        end
    end
    -- End of 30m engine. No currency Remote calls; all reads are local and read-only.

    task.spawn(function()
        while Runtime.Alive do
            task.wait(5)
            if not Runtime.Alive then break end
            A.Sample()
            if Config.AnalyticsEnabled and os.clock()-(A.LastSnapshot or 0)>=60 then
                A.LastSnapshot=os.clock()
                local c=A.Counters
                addEvent(string.format("PERIODIC_STATE world=%s room=%s roomClears=%d deaths=%d hpLoss=%.1f dodge=%d forgeSold=%d autoFarm=%s",
                    A.LastWorld,A.LastRoom,c.RoomClears,c.CharacterDeaths,
                    A.DamageObserved,c.DodgeStarts,c.ForgeSold,tostring(Config.AutoFarm)))
            end
            if Config.AnalyticsEnabled and os.clock()-A.LastFlush>=30 then
                local ok,err=A.Flush(false,"AUTO")
                if not ok and A.FileErrors<=2 then
                    warn("[IronSoul Analytics] Không lưu được log: "..tostring(err))
                end
            end
        end
    end)
end
table.insert(Runtime.Connections, StatusLbl:GetPropertyChangedSignal("Text"):Connect(function()
	local now=os.clock()
	if now-(Runtime.LastStatusLog or 0)>1 then Runtime.LastStatusLog=now; Runtime.Log(StatusLbl.Text) end
end))
local function reportError(context, err)
	if not Runtime.Alive then return end
	local message = tostring(err)
	Runtime.LastError = context .. ": " .. message
	if os.clock()-(lastErrors[context] or -math.huge)>5 then Runtime.Log("ERROR " .. Runtime.LastError) end
	pcall(function() StatusLbl.Text = "Lỗi " .. context .. ": " .. message:sub(1, 140) end)
	for _, refresh in pairs(Runtime.ToggleRefresh) do pcall(refresh) end
	if os.clock() - (lastErrors[context] or -math.huge) > 5 then
		lastErrors[context] = os.clock()
		warn("[IronSoul v23][" .. context .. "] " .. message)
	end
end
local function isTransitioning()
    -- All existing combat, noclip and movement workers yield before the first tick.
    return LocalPlayer:GetAttribute("IsTeleporting") == true
        or (Runtime.EndlessSafeEntryActive and Runtime.EndlessSafeEntryActive()) == true
end
-- ENDLESS_SAFE_ENTRY_BEGIN
-- Endless first room is a waiting room; the live RoundDoor performs an
-- approximately 6,350-stud transfer into floor 1. Recorded destination
-- teleports skip the game's transition and can land in a void.
-- Only this entry stage is guarded. Never change other World/Cave routes.
do
    local function nativeTransition()
        return LocalPlayer:GetAttribute("IsTeleporting")==true
    end
    local stage=Vector3.new(8537.64,473.59,2602.89) -- observed LIVE_R1 waiting room
    local guard={Phase=nil,Token=nil,OwnsRouteBusy=false,Character=nil,Cfg=nil,
        CompletedCharacter=nil,CompletedCfg=nil,Started=0,
        LastMove=0,MoveAttempts=0,LastWarn=0,StableAt=nil,LastSafe=nil,
        Heading=nil,Origin=nil,FromLobby=GamePlaceUtil:IsMain(),
        ForwardDistance=0,LandedAt=nil,MissingCfgAt=nil}
    local function log(message)
        if Runtime.Log then Runtime.Log("ENDLESS_SAFE_ENTRY "..message) end
    end
    local function stopGuard(reason,completed)
        if guard.Token then Runtime.Release(guard.Token) end
        guard.Token=nil
        if guard.OwnsRouteBusy then Runtime.RouteBusy=false end
        guard.OwnsRouteBusy=false
        if completed then
            guard.CompletedCharacter=guard.Character
            guard.CompletedCfg=guard.Cfg
        end
        guard.Phase=nil
        guard.Character=nil
        guard.Cfg=nil
        Runtime.EndlessSafeEntryPhase=nil
        log((completed and "CONFIRMED " or "RELEASED ")..tostring(reason))
    end
    local function live()
        if not Runtime.Alive or GamePlaceUtil:IsMain() then return nil,nil,nil,nil end
        local cfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
        if not cfg or cfg:GetAttribute("WorldId")~="Endless1" then return nil,nil,nil,nil end
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        return cfg,char,root,hum
    end
    local function waitingRoom(root)
        if guard.FromLobby or (root.Position-stage).Magnitude<=180 then return true end
        -- Reinjection/shifted spawn: use the live local door, not a map coordinate.
        local folder=Workspace:FindFirstChild("RoundDoor")
        if not folder then return false end
        for _,node in ipairs(folder:GetDescendants()) do
            if node.Name=="Root" and node:IsA("BasePart") and node.Parent
                and node.Parent.Name=="Portal" then
                local offset=node.Position-root.Position
                local horizontal=Vector3.new(offset.X,0,offset.Z)
                if horizontal.Magnitude<=150 and math.abs(offset.Y)<=60 then return true end
            end
        end
        return false
    end
    function Runtime.EndlessPatrolBlocked()
        local cfg,char=live()
        return cfg~=nil and not (guard.CompletedCfg==cfg and guard.CompletedCharacter==char)
    end
    function Runtime.EndlessSafeEntryActive()
        if guard.Phase and Runtime.Alive and not GamePlaceUtil:IsMain()
            and combatFarmEnabled() and (not LocalPlayer.Character or guard.Character==LocalPlayer.Character) then
            -- The game may temporarily remove or replace GameRoundCfg during
            -- RoundDoor teleport; retaining this guard prevents a race.
            return true
        end
        local cfg,char,root,hum=live()
        if not cfg or not char or not root or not hum or hum.Health<=0
            or not combatFarmEnabled() then return false end
        if guard.CompletedCfg==cfg and guard.CompletedCharacter==char then return false end
        return waitingRoom(root)
    end
    local function nearestForwardRoundDoor(root)
        local folder=Workspace:FindFirstChild("RoundDoor")
        if not folder then return nil end
        local facing=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
        if facing.Magnitude<0.1 then return nil end
        facing=facing.Unit
        local chosen,distance=nil,math.huge
        for _,node in ipairs(folder:GetDescendants()) do
            if node.Name=="Root" and node:IsA("BasePart")
                and node.Parent and node.Parent.Name=="Portal" and node.CanTouch then
                local offset=node.Position-root.Position
                local flat=Vector3.new(offset.X,0,offset.Z)
                local d=flat.Magnitude
                if d>=1 and d<=150 and math.abs(offset.Y)<=60
                    and facing:Dot(flat.Unit)>=0.2 and d<distance then
                    chosen,distance=node,d
                end
            end
        end
        return chosen,distance
    end
    local function floorReady(char,root,hum)
        local ray=RaycastParams.new()
        ray.FilterType=Enum.RaycastFilterType.Exclude
        ray.FilterDescendantsInstances={char}
        local hit=Workspace:Raycast(root.Position+Vector3.new(0,5,0),
            Vector3.new(0,-35,0),ray)
        local rayGround=hit and hit.Normal.Y>=0.5 and hit.Instance
            and hit.Instance.CanCollide and root.Position.Y-hit.Position.Y>=1
            and root.Position.Y-hit.Position.Y<=24
        -- If streamed geometry is not exposed to our Raycast yet,
        -- Roblox's own grounded Humanoid state is an independent signal.
        local grounded=hum and hum.FloorMaterial~=nil
            and hum.FloorMaterial~=Enum.Material.Air
        return rayGround or grounded
    end
    function Runtime.EndlessSafeEntryTick()
        if GamePlaceUtil:IsMain() then
            guard.FromLobby=true
            guard.CompletedCfg,guard.CompletedCharacter=nil,nil
        else
            local observed=ReplicatedStorage:FindFirstChild("GameRoundCfg")
            local world=observed and observed:GetAttribute("WorldId")
            if world and world~="Endless1" then guard.FromLobby=false end
        end
        -- Only an explicit exit/stop/death may cancel the game-owned entry.
        -- Missing GameRoundCfg/character/root while changing maps is NOT
        -- proof that transfer finished; continue blocking other workers.
        if not Runtime.Alive or GamePlaceUtil:IsMain() or not combatFarmEnabled() then
            if guard.Phase then stopGuard("exit/combat disabled",false) end
            return false
        end
        local now=os.clock()
        local cfg,char,root,hum=live()
        if guard.Phase and not cfg then
            guard.MissingCfgAt=guard.MissingCfgAt or now
            local other=ReplicatedStorage:FindFirstChild("GameRoundCfg")
            local otherWorld=other and other:GetAttribute("WorldId")
            if otherWorld and otherWorld~="Endless1"
                and now-guard.MissingCfgAt>=3 then
                stopGuard("server switched to "..tostring(otherWorld),false)
                return false
            end
            if now-guard.LastWarn>=10 then
                guard.LastWarn=now
                log("WAIT_GAME_CFG: native transfer still guarded; no combat until server state returns")
            end
            return true
        end
        guard.MissingCfgAt=nil
        if guard.Phase and (not char or not root or not hum) then return true end
        if not cfg or not char or not root or not hum then return false end
        if hum.Health<=0 then
            if guard.Phase then stopGuard("character died",false) end
            return false
        end
        if guard.Phase and guard.Character~=char then
            stopGuard("character replaced",false)
        elseif guard.Phase and guard.Cfg~=cfg then
            -- The server replaced the GameRoundCfg Instance in the SAME
            -- Endless run; retain exclusive movement ownership.
            guard.Cfg=cfg
            log("GAME_CFG_REBOUND native transfer still guarded")
        end
        if not guard.Phase then
            if guard.CompletedCfg==cfg and guard.CompletedCharacter==char
                or not waitingRoom(root)
                or Runtime.Owner or Runtime.RouteBusy then return false end
            local token=Runtime.Acquire("ENDLESS_SAFE_ENTRY")
            if not token then return false end
            guard.Phase="WAIT"
            guard.Token=token
            guard.OwnsRouteBusy=true
            guard.Cfg,guard.Character=cfg,char
            guard.Started=now
            guard.Origin=root.Position
            guard.FromLobby=false
            guard.LastMove,guard.MoveAttempts,guard.LastWarn=0,0,0
            guard.StableAt,guard.LastSafe=nil,nil
            guard.ForwardDistance,guard.LandedAt=0,nil
            local v=root.CFrame.LookVector
            local flat=Vector3.new(v.X,0,v.Z)
            guard.Heading=flat.Magnitude>=0.1 and flat.Unit or nil
            Runtime.RouteBusy=true
            Runtime.EndlessSafeEntryPhase="WAIT"
            -- A previously running Patrol MoveTo must not compete with the
            -- scripted forward approach. No PivotTo or velocity writes here.
            if Runtime.CancelPatrol and not nativeTransition() then pcall(Runtime.CancelPatrol) end
            if Runtime.UndergroundActive and Runtime.ExitUnderground then
                pcall(Runtime.ExitUnderground,"Endless entry handoff",true)
            end
            Runtime.HoverTarget=nil
            Runtime.HasCombatTarget=false
            if Runtime.ClearTargets then pcall(Runtime.ClearTargets) end
            log("WAIT 10s; then walk straight ahead through native RoundDoor")
        end
        -- A real portal transition shifts the character thousands of studs.
        -- No movement commands are allowed once this displacement is seen.
        if guard.Origin and (root.Position-guard.Origin).Magnitude>500 then
            if guard.Phase~="LANDING" then
                guard.Phase="LANDING"
                guard.StableAt,guard.LastSafe=nil,nil
                guard.LandedAt=now
                Runtime.EndlessSafeEntryPhase="LANDING"
                log("HANDOFF: arrived far from stage; waiting ground + stable position")
            end
        elseif guard.Phase=="WAIT" then
            if now-guard.Started<10 or nativeTransition() then return true end
            guard.Phase="APPROACH"
            Runtime.EndlessSafeEntryPhase="APPROACH"
            log("APPROACH: walking to forward RoundDoor, no teleport")
        end
        if guard.Phase=="APPROACH" then
            if nativeTransition() then
                if guard.MoveAttempts>0 then
                    guard.Phase="HANDOFF"
                    Runtime.EndlessSafeEntryPhase="HANDOFF"
                    log("HANDOFF: game IsTeleporting; yielding all movement")
                end
                return true
            end
            local door,distance=nearestForwardRoundDoor(root)
            -- Normal case: RoundDoor lies directly ahead. The scanner is
            -- OPTIONAL; a streamed-out/CanTouch=false Root cannot freeze us.
            if now-guard.LastMove>=1.5 and guard.MoveAttempts<14 then
                local destination=nil
                -- Keep the spawn heading: the user requested forward walking.
                -- The door scan only confirms contact; it never steers sideways.
                if guard.Heading and guard.ForwardDistance<96 then
                    local step=math.min(12,96-guard.ForwardDistance)
                    guard.ForwardDistance=guard.ForwardDistance+step
                    destination=guard.Origin+guard.Heading*guard.ForwardDistance
                end
                if destination then
                    guard.LastMove=now
                    guard.MoveAttempts=guard.MoveAttempts+1
                    hum:MoveTo(destination)
                    if guard.MoveAttempts==1 then
                        log("WALK_FORWARD (native door contact; scanner not required)")
                    end
                end
            end
            if door and distance<=4 then
                guard.Phase="HANDOFF"
                Runtime.EndlessSafeEntryPhase="HANDOFF"
                guard.LastWarn=now
                log("HANDOFF: reached door; leaving teleport to the game")
            end
            if now-guard.Started>=55 and guard.Phase=="APPROACH" then
                guard.Phase="HOLD"
                Runtime.EndlessSafeEntryPhase="HOLD"
                log("HOLD: no door activation; no blind teleport")
            end
        elseif guard.Phase=="HANDOFF" then
            -- If touch did not activate, allow a bounded new MoveTo.
            -- Never teleport the player or force a portal RemoteFunction.
            if not nativeTransition() and now-guard.LastWarn>=4
                and guard.MoveAttempts<14 then
                guard.Phase="APPROACH"
                Runtime.EndlessSafeEntryPhase="APPROACH"
            end
            if now-guard.Started>=55 then
                guard.Phase="HOLD"
                Runtime.EndlessSafeEntryPhase="HOLD"
                log("HOLD: no verified transfer after door contact")
            end
        elseif guard.Phase=="LANDING" then
            -- Never declare success while the game still reports a
            -- transition: the other Combat workers would remain blocked by
            -- nativeTransition() even after we released the movement owner.
            local ready=not nativeTransition() and floorReady(char,root,hum)
            if nativeTransition() and guard.LandedAt
                and now-guard.LandedAt>=8 and now-guard.LastWarn>=10 then
                guard.LastWarn=now
                log("GAME_TELEPORT_FLAG_STUCK: arena seen but IsTeleporting still true")
            end
            if ready then
                -- Compare against the ORIGINAL landing anchor, not the last
                -- 0.1s sample. A lingering Humanoid MoveTo could otherwise
                -- walk several dozen studs while falsely counting as stable.
                if not guard.LastSafe
                    or (root.Position-guard.LastSafe).Magnitude>4 then
                    guard.StableAt=now
                    guard.LastSafe=root.Position
                end
                if guard.StableAt and now-guard.StableAt>=2 then
                    -- Only after a stable, collidable floor may workers resume.
                    stopGuard("floor stable >=2s; native transition accepted",true)
                    return false
                end
            else
                guard.StableAt,guard.LastSafe=nil,nil
            end
            if now-guard.Started>=45 and now-guard.LastWarn>=10 then
                guard.LastWarn=now
                log("LANDING_UNVERIFIED: floor/ground state not stable; combat paused")
            end
        elseif guard.Phase=="HOLD" then
            -- Manual RoundDoor crossing can still complete the same guard.
            if now-guard.LastWarn>=20 then
                guard.LastWarn=now
                log("HOLD: waiting manual RoundDoor/valid floor; no unsafe movement")
            end
        end
        return true
    end
end
-- ENDLESS_SAFE_ENTRY_END
table.insert(Runtime.Connections,RunService.Heartbeat:Connect(function()
    if Runtime.Alive then
        local ok,err=pcall(Runtime.EndlessSafeEntryTick)
        if not ok and Runtime.Log then Runtime.Log("ENDLESS_SAFE_ENTRY_ERROR "..tostring(err)) end
    end
end))


local Scroll
local activePopups = {}
Runtime.Tabs = {}
Runtime.TabButtons = {}
Runtime.Minimized = false
local tabBar = Instance.new("Frame", MainFrame)
tabBar.Position = UDim2.new(0, 4, 0, 72)
tabBar.Size = UDim2.new(1, -8, 0, 30)
tabBar.BackgroundTransparency = 1
function Runtime.ShowTab(name)
    if name=="Record" then name="Dungeon" end -- Recorder 1.5 is a SEPARATE script
	if not Runtime.Tabs[name] then name = "Dungeon" end
	Config.ActiveTab = name
	for _, popup in ipairs(activePopups) do popup.Visible = false end
	for key, page in pairs(Runtime.Tabs) do
		page.Visible = key == name and not Runtime.Minimized
		if Runtime.TabButtons[key] then Runtime.TabButtons[key].BackgroundColor3 = key == name and Color3.fromRGB(95,65,145) or Color3.fromRGB(35,35,48) end
	end
end
local visibleTabNames = {"Dungeon", "Combat", "Forge", "Utilities", "Spin", "Code"}
local visibleTabIndex={}
for idx,tabName in ipairs(visibleTabNames) do visibleTabIndex[tabName]=idx end
local tabNames = {"Dungeon", "Record", "Combat", "Forge", "Utilities", "Spin", "Grocery", "Loot", "Rewards", "Settings", "Code"}
for index, name in ipairs(tabNames) do
	local page = Instance.new("ScrollingFrame", MainFrame)
	page.Name = name
	page.Position = UDim2.new(0,4,0,108)
	page.Size = UDim2.new(1,-8,1,-112)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 5
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new()
	page.Visible = false
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0,5)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	Runtime.Tabs[name] = page
	local visibleIndex=visibleTabIndex[name]
	if visibleIndex then
		local button = Instance.new("TextButton", tabBar)
		button.Size = UDim2.new(1/#visibleTabNames,-2,1,0)
		button.Position = UDim2.new((visibleIndex-1)/#visibleTabNames,0,0,0)
		button.Text = name
		button.TextColor3 = Color3.new(1,1,1)
		button.TextSize = 15
		Runtime.TabButtons[name] = button
		button.MouseButton1Click:Connect(function() Runtime.ShowTab(name); saveConfig() end)
	end
end
Scroll = Runtime.Tabs.Dungeon
local uiOrder = 0
local function orderWidget(widget)
	uiOrder = uiOrder + 1
	widget.LayoutOrder = uiOrder
end
do
	local button = Instance.new("TextButton", Title)
	button.Size = UDim2.new(0,28,0,28)
	button.Position = UDim2.new(1,-63,0,3)
	button.Text = "—"
	button.MouseButton1Click:Connect(function()
		Runtime.Minimized = not Runtime.Minimized
        tabBar.Visible=not Runtime.Minimized
        if Runtime.ResizeAIO then Runtime.ResizeAIO() end
        Runtime.ShowTab(Config.ActiveTab)
	end)
end
Runtime.ShowTab(Config.ActiveTab)
-- H handled by early boot shortcut; no duplicate listener.

local function addSectionHeader(text)
	local section = tonumber(text:match("^(%d+)"))
	local names = {[1]="Dungeon", [2]="Combat", [3]="Forge", [4]="Forge", [5]="Combat", [6]="Dungeon", [7]="Forge"}
	if names[section] then Scroll = Runtime.Tabs[names[section]] end
	local lbl = Instance.new("TextLabel", Scroll)
	orderWidget(lbl)
	lbl.Size = UDim2.new(0.94, 0, 0, 22)
	lbl.BackgroundColor3 = Color3.fromRGB(45, 40, 65)
	lbl.Text = "  " .. text
	lbl.TextColor3 = Color3.fromRGB(255, 215, 110)
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
end

Runtime.ToggleGuards={}
local function addToggle(label, configKey)
	local btn = Instance.new("TextButton", Scroll)
	orderWidget(btn)
	btn.Size = UDim2.new(0.94, 0, 0, 30)
	local state = Config[configKey]
	btn.BackgroundColor3 = state and Color3.fromRGB(45, 155, 75) or Color3.fromRGB(130, 45, 55)
	btn.Text = label .. ": " .. (state and "ON" or "OFF")
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	Runtime.ToggleRefresh[configKey] = function()
		local enabled = Config[configKey]
		btn.BackgroundColor3 = enabled and Color3.fromRGB(45, 155, 75) or Color3.fromRGB(130, 45, 55)
		btn.Text = label .. ": " .. (enabled and "ON" or "OFF")
	end
	btn.MouseButton1Click:Connect(function()
		if Runtime.ToggleGuards[configKey] then
			local ok,allow=pcall(Runtime.ToggleGuards[configKey],not Config[configKey])
			if not ok then reportError(label,allow); return end
			if allow==false then Runtime.ToggleRefresh[configKey](); return end
		end
		Config[configKey] = not Config[configKey]
		local s = Config[configKey]
		btn.BackgroundColor3 = s and Color3.fromRGB(45, 155, 75) or Color3.fromRGB(130, 45, 55)
		btn.Text = label .. ": " .. (s and "ON" or "OFF")
		saveConfig()
	end)
end

local function addDropdown(labelPrefix, items, configKey)
	local btn = Instance.new("TextButton", Scroll)
	orderWidget(btn)
	btn.Size = UDim2.new(0.94, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
	btn.BorderColor3 = Color3.fromRGB(80, 80, 105)
	btn.TextColor3 = Color3.fromRGB(255, 235, 140)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11

	local currentText = tostring(Config[configKey])
	for _, it in ipairs(items) do
		if tostring(it.val) == tostring(Config[configKey]) then
			currentText = it.text
			break
		end
	end
	btn.Text = labelPrefix .. ": " .. currentText

	local listFrame = Instance.new("ScrollingFrame", ScreenGui)
	listFrame.Size = UDim2.new(0, 320, 0, 185)
	listFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	listFrame.BorderColor3 = Color3.fromRGB(120, 95, 175)
	listFrame.BorderSizePixel = 2
	listFrame.Visible = false
	listFrame.ZIndex = 100
	listFrame.ScrollBarThickness = 5
	listFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 30)
	table.insert(activePopups, listFrame)

	local listLayout = Instance.new("UIListLayout", listFrame)
	listLayout.Padding = UDim.new(0, 2)

	for _, item in ipairs(items) do
		local opt = Instance.new("TextButton", listFrame)
		opt.Size = UDim2.new(1, -6, 0, 28)
		opt.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		opt.Text = tostring(item.text)
		opt.TextColor3 = Color3.new(1, 1, 1)
		opt.Font = Enum.Font.GothamSemibold
		opt.TextSize = 11
		opt.ZIndex = 101
		opt.MouseButton1Click:Connect(function()
                Config[configKey] = item.val
                if configKey == "AutoClearTrashMaxRarity" then
                    if not Runtime.AutoClearTrashErrorBlocked then Runtime.AutoClearTrashBlocked=false end
                    Runtime.AutoClearTrashNextScanAt=0
                    Runtime.AutoClearTrashRecoverCheckAt=0
                    Config.AutoClearTrashPending=Config.AutoClearTrash==true
                end
                btn.Text = labelPrefix .. ": " .. tostring(item.text)
			listFrame.Visible = false
			saveConfig()
			if (configKey == "SelectedRecordWorld" or configKey == "SelectedRecordRoom") and Runtime.RefreshRecordUI then
				Runtime.RefreshRecordUI()
			end
		end)
	end

	btn.MouseButton1Click:Connect(function()
		local nextVis = not listFrame.Visible
		for _, p in ipairs(activePopups) do p.Visible = false end
		if nextVis then
			local absPos = btn.AbsolutePosition
			local size=ScreenGui.AbsoluteSize
			listFrame.Size=UDim2.fromOffset(math.min(320,size.X-12),math.min(185,size.Y-12))
			listFrame.Position = UDim2.fromOffset(math.clamp(absPos.X,6,math.max(6,size.X-listFrame.AbsoluteSize.X-6)), math.clamp(absPos.Y+34,6,math.max(6,size.Y-listFrame.AbsoluteSize.Y-6)))
			listFrame.Visible = true
		end
	end)
end

local worldItems = {
	{text = "World1 - Starless Forest", val = "World1"},
	{text = "World2 - Frozen Valley", val = "World2"},
	{text = "World3 - Oathlost Castle", val = "World3"},
	{text = "World4 - Tartarus", val = "World4"},
	{text = "World5 - Sakura Village", val = "World5"},
	{text = "Cave1 - Cave of Crystal (Max 5)", val = "Cave1"},
	{text = "Cave2 - Cave of Runes (Max 4)", val = "Cave2"},
	{text = "Cave3 - Abandoned Courtyard (Max 4)", val = "Cave3"},
	{text = "Endless1 - Endless Tower", val = "Endless1"}
}

local diffItems = {
	{text = "Best For My Power", val = "BEST"},
	{text = "Highest Unlocked", val = "HIGHEST"},
	{text = "Diff 1 - Trial", val = 1},
	{text = "Diff 2 - Challenge", val = 2},
	{text = "Diff 3 - Penitent", val = 3},
	{text = "Diff 4 - Torment (Max Cave2/3)", val = 4},
	{text = "Diff 5 - Inferno (Max Cave1)", val = 5},
	{text = "Hell 6 - Trial", val = 6},
	{text = "Hell 7 - Challenge", val = 7},
	{text = "Hell 8 - Penitent", val = 8},
	{text = "Hell 9 - Torment", val = 9},
	{text = "Hell 10 - Inferno", val = 10}
}

local endlessFloorItems = {
	{text = "Next Challenge (Tầng Cao Nhất, VD: 11-15)", val = "NextChallenge"},
	{text = "Highest Cleared (Tầng Đã Qua, VD: 6-10)", val = "HighestCleared"}
}

local runEndItems = {
	{text = "Auto: về Lobby khi có rác hoặc gần đầy", val = "LobbyIfFullOrAgain"},
	{text = "Luôn Về Lobby (Rèn/Bán/Fuse Xong Vào Lại)", val = "AlwaysBackLobby"},
	{text = "Luôn Play Again (Chơi Lại)", val = "VotePlayAgain"},
	{text = "Luôn Next Chapter (Màn Tiếp)", val = "VoteNextChapter"},
	{text = "Off (Không Tự Chọn)", val = "Off"}
}

local forgeTypeItems = {
	{text = "Rèn Giáp (Armor)", val = "Armor"},
	{text = "Rèn Vũ Khí (Weapon)", val = "Weapon"}
}

addSectionHeader("1. DUNGEON / CAVE / ENDLESS")
addDropdown("Map", worldItems, "SelectedWorld")
addDropdown("Độ Khó", diffItems, "SelectedDiff")
addDropdown("Tầng Endless", endlessFloorItems, "EndlessMode")
addDropdown("Khi Xong Màn", runEndItems, "RunEndAction")
addDropdown("Auto Create", {{text="Solo Auto Create",val="Solo"},{text="Team Follower (không tự tạo)",val="Follower"}}, "AutoCreateRole")
addToggle("Auto Vào Map (lưu theo cấu hình)", "AutoStartDungeon")
addToggle("Chết trong Endless: về Lobby và vào lại", "AutoEndlessDeathLobby")
-- v4.9.50d: finite/infinite Solo Dungeon COUNTER. Only server-derived full
-- success reports are counted; CloneDaily is a separate 5/3/Tower owner.
function Runtime.InitDungeonRunCounter()
    local path=ConfigFolder.."/dungeon_counter_U"..tostring(LocalPlayer.UserId)..".json"
    local today=os.date("!%Y-%m-%d")
    local st={UserId=LocalPlayer.UserId,Day=today,Used=0,Target=0,LastIds={},ForceBack=false}
    if typeof(readfile)=="function" then
        pcall(function()
            if typeof(isfile)~="function" or isfile(path) then
                local old=HttpService:JSONDecode(readfile(path))
                if type(old)=="table" and old.UserId==LocalPlayer.UserId then
                    st.Day=tostring(old.Day or today)
                    st.Used=math.clamp(math.floor(tonumber(old.Used) or 0),0,9999)
                    st.Target=math.clamp(math.floor(tonumber(old.Target) or 0),0,9999)
                    st.LastIds=type(old.LastIds)=="table" and old.LastIds or {}
                    st.ForceBack=old.ForceBack==true
                    st.PreviousRunEndAction=type(old.PreviousRunEndAction)=="string" and old.PreviousRunEndAction or nil
                end
            end
        end)
    end
    local function persist()
        if typeof(writefile)~="function" then return false end
        return pcall(function()
            if typeof(makefolder)=="function" and (typeof(isfolder)~="function" or not isfolder(ConfigFolder)) then makefolder(ConfigFolder) end
            writefile(path,HttpService:JSONEncode(st))
        end)
    end
    local function refresh()
        if Runtime.DungeonCounterUIRefresh then pcall(Runtime.DungeonCounterUIRefresh) end
    end
    local function rollover()
        local day=os.date("!%Y-%m-%d")
        if st.Day~=day then
            st.Day=day;st.Used=0;st.LastIds={};st.ForceBack=false;st.PreviousRunEndAction=nil
            persist();refresh()
        end
    end
    local function reached()
        return st.Target>0 and st.Used>=st.Target
    end
    Runtime.DungeonCounter=st
    Runtime.DungeonCounterReached=function() rollover();return reached() end
    Runtime.DungeonCounterSetTarget=function(t)
        rollover()
        t=tonumber(t)
        assert(t and t%1==0 and t>=0 and t<=9999,"Số lượt Dungeon phải từ 0 đến 9999 (0 = vô hạn)")
        st.Target=t
        if t>0 then Config.AnalyticsEnabled=true end
        if t==0 then
            st.ForceBack=false
            if st.PreviousRunEndAction then Config.RunEndAction=st.PreviousRunEndAction end
            st.PreviousRunEndAction=nil
        end
        assert(persist(),"Không thể lưu Dungeon counter")
        if t==0 and not Runtime.CloneDailyActive and not (Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled()) then
            Runtime.SuppressAutoCreate=false
        end
        refresh();pcall(saveConfig)
    end
    Runtime.DungeonCounterAdjust=function(amount)
        assert(not Runtime.CloneDailyActive and not (Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled()),"Dừng routine trước khi chỉnh Dungeon counter")
        rollover();st.Used=math.clamp(st.Used+amount,0,9999)
        persist();refresh()
    end
    Runtime.DungeonCounterReset=function()
        assert(not Runtime.CloneDailyActive and not (Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled()),"Dừng routine trước khi reset")
        st.Day=os.date("!%Y-%m-%d");st.Used=0;st.LastIds={};st.ForceBack=false
        if st.PreviousRunEndAction then Config.RunEndAction=st.PreviousRunEndAction end
        st.PreviousRunEndAction=nil
        Runtime.SuppressAutoCreate=false
        persist();refresh();pcall(saveConfig)
    end
    Runtime.DungeonCounterOnSuccess=function(report)
        if not Runtime.Alive or not Config.AutoFarm or Runtime.CloneDailyActive
            or (Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled()) then return end
        if type(report)~="table" or report.Status~="SUCCESS" or report.FullRunTiming~=true then return end
        if type(report.World)~="string" or not (report.World:match("^World%d+$") or report.World:match("^Cave%d+$")) then return end
        rollover()
        local runId=tostring(report.RunId or "")
        if runId=="" then return end
        for _,v in ipairs(st.LastIds) do if v==runId then return end end
        st.LastIds[#st.LastIds+1]=runId
        if #st.LastIds>15 then table.remove(st.LastIds,1) end
        st.Used=math.min(9999,st.Used+1)
        if reached() then
            -- Keep AutoFarm on until settlement finishes; require Back Lobby.
            if not st.ForceBack then st.PreviousRunEndAction=Config.RunEndAction end
            st.ForceBack=true
            Config.RunEndAction="AlwaysBackLobby"
            Runtime.SuppressAutoCreate=true
        end
        local stored=persist();refresh()
        Runtime.Log("DUNGEON_COUNTER_CONFIRMED "..st.Used.."/"..st.Target.." world="..report.World.." id="..runId.." saved="..tostring(stored))
    end
    task.spawn(function()
        while Runtime.Alive do
            task.wait(.7)
            rollover()
            if not Runtime.CloneDailyActive and not (Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled())
                and Config.SelectedWorld~="Endless1" and reached() then
                Runtime.SuppressAutoCreate=true
                if GamePlaceUtil:IsMain() and not isTransitioning() then
                    if Config.AutoFarm then Config.AutoFarm=false;Config.AutoStartDungeon=false end
                    if st.ForceBack then
                        st.ForceBack=false
                        if st.PreviousRunEndAction then Config.RunEndAction=st.PreviousRunEndAction end
                        st.PreviousRunEndAction=nil
                        persist();pcall(saveConfig)
                        if Runtime.ToggleRefresh.AutoFarm then pcall(Runtime.ToggleRefresh.AutoFarm) end
                        Runtime.Log("DUNGEON_COUNTER_STOP after confirmed target; now in Lobby")
                    end
                end
            end
        end
    end)
    refresh()
end
Runtime.InitDungeonRunCounter()

-- v4.9.50d: SINGLE account-level Tower counter shared by Dungeon and Clone Daily.
-- No legacy widget here: the visible compact Dungeon UI is built AFTER ClearAllChildren.
function Runtime.InitTowerDailyCounter()
    local path=ConfigFolder.."/endless_counter_U"..tostring(LocalPlayer.UserId)..".json"
    local today=os.date("!%Y-%m-%d")
    local st={UserId=LocalPlayer.UserId,Day=today,Used=0,Target=3,Floor=1,AutoEnabled=false}
    if typeof(readfile)=="function" then
        pcall(function()
            if typeof(isfile)~="function" or isfile(path) then
                local old=HttpService:JSONDecode(readfile(path))
                if type(old)=="table" and old.UserId==LocalPlayer.UserId then
                    st.Day=tostring(old.Day or today)
                    st.Used=math.clamp(math.floor(tonumber(old.Used) or 0),0,99)
                    st.Target=math.clamp(math.floor(tonumber(old.Target) or 3),1,99)
                    st.Floor=math.clamp(math.floor(tonumber(old.Floor) or 1),1,EndlessConfig.ConfigRoundCount or 100)
                    st.AutoEnabled=old.AutoEnabled==true
                    st.Pending=type(old.Pending)=="table" and old.Pending or nil
                    st.AutoSnapshot=type(old.AutoSnapshot)=="table" and old.AutoSnapshot or nil
                end
            end
        end)
    end
    local function persist()
        if typeof(writefile)~="function" then return false end
        return pcall(function()
            if typeof(makefolder)=="function" and (typeof(isfolder)~="function" or not isfolder(ConfigFolder)) then
                makefolder(ConfigFolder)
            end
            writefile(path,HttpService:JSONEncode(st))
        end)
    end
    local function refresh()
        if Runtime.TowerCounterUIRefresh then pcall(Runtime.TowerCounterUIRefresh) end
    end
    local function rollover()
        local day=os.date("!%Y-%m-%d")
        if st.Day~=day then
            local wasAuto=st.AutoEnabled
            if wasAuto and Runtime.TowerAutoStop then Runtime.TowerAutoStop("UTC reset during Tower") end
            st.Day=day;st.Used=0;st.AutoEnabled=false;st.Pending=nil;st.AutoSnapshot=nil
            persist();refresh()
            Runtime.Log("TOWER_COUNTER_DAY_RESET "..day)
        end
    end
    local function updateUsed(newValue,proof)
        rollover()
        newValue=math.clamp(math.floor(tonumber(newValue) or st.Used),0,99)
        if newValue==st.Used then return false end
        st.Used=newValue
        local saved=persist()
        refresh()
        Runtime.Log("TOWER_COUNTER_"..tostring(proof).." "..st.Used.."/"..st.Target.." persisted="..tostring(saved))
        if st.Used>=st.Target and st.AutoEnabled then Runtime.SuppressAutoCreate=true end
        return true
    end
    Runtime.TowerCounter=st
    Runtime.EndlessCounter=st
    Runtime.EndlessCounterRefresh=refresh
    Runtime.TowerRollover=rollover
    Runtime.TowerGetUsed=function() rollover();return st.Used end
    Runtime.TowerGetTarget=function() rollover();return st.Target end
    Runtime.TowerGetFloor=function() return st.Floor end
    Runtime.TowerIsAutoEnabled=function() return st.AutoEnabled end
    Runtime.TowerSetInputs=function(target,floor)
        rollover()
        local maxFloor=EndlessConfig.ConfigRoundCount or 100
        local t=tonumber(target);local f=tonumber(floor)
        assert(t and t%1==0 and t>=1 and t<=99,"Mục tiêu Tower phải là số nguyên 1–99")
        assert(f and f%1==0 and f>=1 and f<=maxFloor,"Level Tower phải là số nguyên 1–"..tostring(maxFloor))
        st.Target=t;st.Floor=f
        assert(persist(),"Không lưu được Tower Target/Level; kiểm tra file API")
        refresh()
        return true
    end
    Runtime.TowerManualAdjust=function(change)
        assert(not Runtime.CloneDailyActive and not st.AutoEnabled,"Dừng Clone Daily/Auto Tower trước khi sửa lượt")
        return updateUsed(st.Used+change,"MANUAL")
    end
    Runtime.TowerReset=function()
        assert(not Runtime.CloneDailyActive and not st.AutoEnabled,"Dừng Clone Daily/Auto Tower trước khi RESET")
        st.Day=os.date("!%Y-%m-%d");st.Pending=nil
        updateUsed(0,"RESET");persist();refresh()
    end
    -- Save the attempt BEFORE CreatRoom. A fresh Lua runtime after a teleport
    -- can still confirm the real Endless1 world from this pending ticket.
    Runtime.TowerPrepareCreate=function()
        rollover()
        if st.AutoEnabled and st.Used>=st.Target then return false,"Tower đã đủ lượt" end
        if Runtime.CloneDailyTowerActive and st.Used>=st.Target then return false,"Clone Tower đã đủ lượt" end
        local now=os.time()
        if st.Pending and (now-(tonumber(st.Pending.At) or 0))<45 then
            return false,"Tower Create trước còn chờ xác minh; không gửi trùng trong 45 giây"
        end
        st.Pending={At=now,Floor=st.Floor,UserId=LocalPlayer.UserId}
        if not persist() then
            st.Pending=nil
            return false,"Không lưu được pending Tower; dừng để tránh đếm sai khi Teleport"
        end
        return true
    end
    -- Daily shares this counter; never creates a second increment for an entry
    -- already witnessed by the Tower observer.
    Runtime.TowerReconcileClone=function(prior)
        rollover()
        prior=math.clamp(math.floor(tonumber(prior) or 0),0,99)
        if prior>st.Used then updateUsed(prior,"LEGACY_DAILY_RECONCILE") end
        return st.Used
    end
    Runtime.TowerCloneReturn=function(previous)
        rollover()
        previous=math.max(0,math.floor(tonumber(previous) or 0))
        -- A confirmed Clone tower terminal/settlement plus lobby return can
        -- reconcile a missed server-world observation, but never double count.
        if st.Used<=previous then updateUsed(previous+1,"CLONE_CONFIRMED_RETURN") end
        return st.Used
    end
    local function restoreIndependent(reason)
        st.AutoEnabled=false
        local snap=st.AutoSnapshot
        st.AutoSnapshot=nil
        if type(snap)=="table" then
            for _,key in ipairs({"AutoFarm","AutoAttackTeleport","SelectedWorld","SelectedDiff","RunEndAction","AutoCreateRole","AutoEndlessDeathLobby"}) do
                if snap[key]~=nil then Config[key]=snap[key] end
            end
        else
            Config.AutoFarm=false
        end
        Runtime.SuppressAutoCreate=Runtime.DungeonCounterReached and Runtime.DungeonCounterReached() or false
        persist();pcall(saveConfig);refresh()
        if Runtime.ToggleRefresh.AutoFarm then pcall(Runtime.ToggleRefresh.AutoFarm) end
        Runtime.Log("TOWER_AUTO_STOP "..tostring(reason).." used="..st.Used.." target="..st.Target)
    end
    Runtime.TowerAutoStop=restoreIndependent
    Runtime.TowerAutoToggle=function(enabled)
        rollover()
        if not enabled then restoreIndependent("manual OFF");return end
        assert(not Runtime.CloneDailyActive,"Clone Daily đang chạy; Tower dùng chung cấu hình nhưng không bật Auto Tower riêng")
        assert(GamePlaceUtil:IsMain() and not isTransitioning(),"Chỉ BẬT Auto Tower tại Lobby")
        assert(not Runtime.EntryBusy and not Runtime.ForgeBusy and not Runtime.BatchActive,"Đợi tác vụ hiện tại hoàn tất")
        assert(st.Used<st.Target,"Đã đủ lượt Tower; reset hoặc điều chỉnh mục tiêu trước")
        assert(typeof(writefile)=="function" and typeof(readfile)=="function","Thiếu file API lưu bộ đếm qua Teleport")
        st.AutoSnapshot={}
        for _,key in ipairs({"AutoFarm","AutoAttackTeleport","SelectedWorld","SelectedDiff","RunEndAction","AutoCreateRole","AutoEndlessDeathLobby"}) do
            st.AutoSnapshot[key]=Config[key]
        end
        st.AutoEnabled=true
        assert(persist(),"Lưu Tower Auto thất bại")
        Config.AutoFarm=true
        Config.AutoCreateRole="Solo"
        Config.SelectedWorld="Endless1";Config.SelectedDiff=1
        Config.RunEndAction="AlwaysBackLobby"
        Config.AutoEndlessDeathLobby=true
        Runtime.SuppressAutoCreate=false
        pcall(saveConfig);refresh()
        if Runtime.ToggleRefresh.AutoFarm then pcall(Runtime.ToggleRefresh.AutoFarm) end
        Runtime.Log("TOWER_AUTO_START floor="..st.Floor.." target="..st.Target.." used="..st.Used)
    end
    task.spawn(function()
        local witnessedLobby=GamePlaceUtil:IsMain()==true
        local countedThisVisit=false
        local lastWorld=""
        while Runtime.Alive do
            task.wait(.55)
            if not Runtime.Alive then break end
            rollover()
            local lobby=GamePlaceUtil:IsMain()
            if lobby and not isTransitioning() then
                witnessedLobby=true
                countedThisVisit=false
                lastWorld=""
                if st.AutoEnabled then
                    if st.Used>=st.Target then
                        -- Last run has RETURNED to Lobby. Stop creating new rooms now.
                        restoreIndependent("target complete, back in Lobby")
                    else
                        Config.AutoFarm=true
                        Config.AutoCreateRole="Solo"
                        Config.SelectedWorld="Endless1"
                        Config.SelectedDiff=1
                        Config.RunEndAction="AlwaysBackLobby"
                        Config.AutoEndlessDeathLobby=true
                        -- Do not clear locks owned by Forge/other supervisors here.
                    end
                end
            elseif not lobby and not isTransitioning() then
                local cfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
                local world=cfg and cfg:GetAttribute("WorldId")
                if world=="Endless1" and not countedThisVisit then
                    local pending=st.Pending
                    local validPending=type(pending)=="table" and os.time()-(tonumber(pending.At) or 0)<240
                    if witnessedLobby or validPending then
                        countedThisVisit=true
                        witnessedLobby=false
                        st.Pending=nil
                        updateUsed(st.Used+1,"ENTERED_ENDLESS1")
                        persist()
                    end
                end
                lastWorld=world or lastWorld
            end
            if st.AutoEnabled and st.Used>=st.Target then Runtime.SuppressAutoCreate=true end
        end
    end)
    refresh()
end
Runtime.InitTowerDailyCounter()

addSectionHeader("2. AUTO FARM TRONG MÀN")
addToggle("Auto Farm (Tele 1 Lần & Đánh)", "AutoFarm")
addToggle("Auto Base Attack (Chém M1)", "AutoM1")
addToggle("Auto Skills (Theo Hồi Chiêu)", "AutoSkills")
addToggle("Bay trên mob (cần test tầm đánh)", "HoverCombat")
addDropdown("Độ cao trên mob", {{val=4,text="4 studs"},{val=6,text="6 studs"},{val=8,text="8 studs"}}, "HoverHeight")
addToggle("Đi tìm vùng spawn khi hết quái", "AutoPatrol")
Scroll = Runtime.Tabs.Loot
addToggle("Đập Chests & Eggs (v21, chưa nâng cấp)", "BreakChestsEggs")
Scroll = Runtime.Tabs.Combat
addToggle("Tàng Hình Hitbox & FX", "HideFX")
addToggle("SMART DODGE (+30 thường / né ngang Halloween)", "SmartDodge")
addToggle("SMART TARGET LOCK (camera 3D)", "SmartTargetLock")
addToggle("BOW COMBAT (+20, DYNAMIC STAGES)", "BowCombat")
-- v4.9.50: exclusive underground hover, NOT linked to melee/range/astral preset.
addToggle("NOCLIP — UNDERGROUND HOVER", "UndergroundHover")
addDropdown("Độ sâu dưới sàn", {
    {val=4,text="-4 studs"},{val=6,text="-6 studs"},
    {val=8,text="-8 studs"},{val=10,text="-10 studs"},
    {val=12,text="-12 studs"},{val=16,text="-16 studs"},
    {val=20,text="-20 studs"}}, "UndergroundDepth")
Runtime.ToggleGuards.UndergroundHover=function(nextState)
    if not nextState and Runtime.ExitUnderground then
        Runtime.ExitUnderground("manual toggle OFF")
    end
    if nextState and Runtime.CancelFlySkill then
        Runtime.CancelFlySkill("underground takes movement priority")
    end
    return true
end

addSectionHeader("3. AUTO FORGE & SELL (TẠI LOBBY)")
addToggle("Auto QTE Perfect (kể cả tự Forge)", "AutoQTE")
addDropdown("Loại Đồ Rèn", forgeTypeItems, "ForgeTargetType")
addToggle("1. Auto Forge Đá (Không Tự Bán)", "AutoForge")
addDropdown("Lọc đá dọn túi", {
	{text="Theo độ hiếm (các nút Common–Epic)", val="Rarity"},
	{text="Theo level tối đa (mọi độ hiếm)", val="Level"}
}, "ForgeFilterMode")
do
	local row = Instance.new("Frame", Scroll)
	orderWidget(row)
	row.Size = UDim2.new(0.94, 0, 0, 34)
	row.BackgroundTransparency = 1
	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.73, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "Rèn đá level ≤ (0 = chưa chọn)"
	label.Font = Enum.Font.GothamBold
	label.TextSize = 11
	label.TextColor3 = Color3.new(1, 1, 1)
	local input = Instance.new("TextBox", row)
	input.Position = UDim2.new(0.73, 0, 0, 0)
	input.Size = UDim2.new(0.27, 0, 1, 0)
	input.BackgroundColor3 = Color3.fromRGB(45,45,62)
	input.TextColor3 = Color3.new(1,1,1)
	input.Font = Enum.Font.GothamBold
	input.TextSize = 13
	input.ClearTextOnFocus = false
	input.Text = tostring(Config.ForgeMaxOreLevel)
	input.FocusLost:Connect(function()
		local value = tonumber(input.Text)
		if not value or value < 0 or value == math.huge or value % 1 ~= 0 then
			input.Text = tostring(Config.ForgeMaxOreLevel)
			StatusLbl.Text = "Level tối đa phải là số nguyên >= 0; giữ nguyên ngưỡng cũ."
			return
		end
		Config.ForgeMaxOreLevel = value
		input.Text = tostring(value)
		saveConfig()
		StatusLbl.Text = "Đã lưu ngưỡng Lv." .. value .. "; chọn lọc Theo level để áp dụng cho mọi độ hiếm."
	end)
end
addToggle("   + Đá Common (Tier 1)", "ForgeRarity1")
addToggle("   + Đá Uncommon (Tier 2)", "ForgeRarity2")
addToggle("   + Đá Rare (Tier 3)", "ForgeRarity3")
addToggle("   + Đá Epic (Tier 4)", "ForgeRarity4")
addToggle("   + Đá Legendary (Tier 5)", "ForgeRarity5")
addToggle("2. Auto Sell Trang Bị Chưa Khóa", "AutoSellEquip")
addToggle("   Chỉ bán đồ vừa rèn trong phiên này", "SellOnlyForged")
addToggle("Auto Equip Best Gear", "AutoEquipBest")

addSectionHeader("4. AUTO FUSE RUNE (3 VIÊN CÙNG LOẠI)")
addToggle("Bật Auto Fuse Rune", "AutoFuseRune")
addToggle("   + Fuse Rune Lv.1 -> Lv.2", "FuseLv1")
addToggle("   + Fuse Rune Lv.2 -> Lv.3", "FuseLv2")
addToggle("   + Fuse Rune Lv.3 -> Lv.4", "FuseLv3")
addToggle("   + Fuse Rune Lv.4 -> Lv.5", "FuseLv4")

local function forgingGui()
	local parent = PlayerGui:FindFirstChild("MainGuiIgnoreGuiInset")
	return parent and parent:FindFirstChild("ScreenForging")
end

-- Preserve the native UI flow. It advances each QTE and calls ForgeFinish itself.
-- Normalize this module's QTE submissions so manual taps also submit Rating 15.
do
	local original = ForgeUtil.QTE
	local wrapper = function(self, player, payload, ...)
		if Runtime.Alive and Config.AutoQTE and player == LocalPlayer and type(payload) == "table" then
			local perfect = {}
			for key, value in pairs(payload) do perfect[key] = value end
			perfect.Rating = 15
			local result = original(self, player, perfect, ...)
			if result ~= false and Runtime.QTEObserved then Runtime.QTEObserved(perfect.UUID) end
			return result
		end
		return original(self, player, payload, ...)
	end
	local ok, err = pcall(function()
		assert(type(original) == "function", "Thiếu ForgeUtil.QTE")
		ForgeUtil.QTE = wrapper
	end)
	if ok then
		Runtime.RestoreQTE = function()
			if ForgeUtil.QTE == wrapper then ForgeUtil.QTE = original end
		end
	else
		Config.AutoQTE = false
		reportError("AutoQTE", err)
	end
end

local qteBusy = false
-- Chance.Visible toggles for EVERY round, including toggles between two frames.
-- Do not reserve a UUID before Tap: a no-op callback used to consume that UUID.
local manualRound = {Number = 0, Done = false, LastTry = -math.huge}
local watchedChance, chanceConnection
local lastManualUUID
local function beginManualRound()
	manualRound.Number = manualRound.Number + 1
	manualRound.Done = false
	manualRound.Delta = nil
	manualRound.ReadyAt = os.clock() + 0.15
end
Runtime.QTEObserved = function(uuid)
	if not Runtime.ForgeBusy then
		manualRound.Done = true
		lastManualUUID = uuid
	end
end
table.insert(Runtime.Connections, RunService.Heartbeat:Connect(function()
	if not Runtime.Alive or not Config.AutoQTE or Runtime.ForgeBusy or qteBusy then return end
	local gui = forgingGui()
	if not gui or not gui.Visible then return end
	local chance, tap = gui:FindFirstChild("Chance"), gui:FindFirstChild("Tap")
	if chance and watchedChance ~= chance then
		if chanceConnection then chanceConnection:Disconnect() end
		watchedChance = chance
		lastManualUUID = nil
		chanceConnection = chance:GetPropertyChangedSignal("Visible"):Connect(function()
			if chance.Visible then beginManualRound() end
		end)
		table.insert(Runtime.Connections, chanceConnection)
		if chance.Visible then beginManualRound() end
	end
	if not chance or not chance.Visible or not tap or not tap.Visible then return end
	if manualRound.Done or os.clock() < (manualRound.ReadyAt or 0) then return end
	local circle = chance:FindFirstChild("Circle")
	local req = circle and circle:FindFirstChild("Req")
	local rot = circle and circle:FindFirstChild("Rot")
	local perfect = req and req:FindFirstChild("Range2")
	if not req or not rot or not perfect then return end
	-- These are the same scale values used by CreateChance/Tap in the decompile.
	local delta = rot.Position.X.Scale - req.Position.X.Scale
	local crossed = manualRound.Delta and manualRound.Delta * delta <= 0
	manualRound.Delta = delta
	if math.abs(delta) >= perfect.Size.X.Scale / 2 and not crossed then return end
	if os.clock() - manualRound.LastTry < 0.35 then return end
	manualRound.LastTry = os.clock()
	local roundNumber = manualRound.Number
	qteBusy = true
	task.spawn(function()
		local ok, err = pcall(function()
			checkRunning()
			if roundNumber ~= manualRound.Number or manualRound.Done or not chance.Visible then return end
			local qte = ForgeUtil:GetQTE(LocalPlayer)
			if not qte or not qte.UUID or qte.UUID == lastManualUUID then return end
			if typeof(firesignal) == "function" then
				firesignal(tap.MouseButton1Down)
			elseif typeof(getconnections) == "function" then
				local count = 0
				for _, connection in ipairs(getconnections(tap.MouseButton1Down)) do
					if connection.Enabled ~= false and type(connection.Function) == "function" then
						connection.Function()
						count = count + 1
					end
				end
				assert(count > 0, "Không gọi được nút Tap")
			else
				error("Executor cần firesignal/getconnections để tự bấm QTE; click tay vẫn gửi Rating15 khi AutoQTE bật")
			end
			-- firesignal may dispatch asynchronously. Allow the callback to enter QTE.
			task.wait(0.1)
		end)
		qteBusy = false
		if not ok then reportError("AutoQTE", err) end
	end)
end))

local function isAllowedForgeRarity(r)
	if r == 1 then return Config.ForgeRarity1 end
	if r == 2 then return Config.ForgeRarity2 end
	if r == 3 then return Config.ForgeRarity3 end
	if r == 4 then return Config.ForgeRarity4 end
	if r == 5 then return Config.ForgeRarity5 end
	return false
end

local function getOreLevel(oreId, def)
	-- The decompiled UI displays the translated ore name, which may contain (Lv.N).
	-- Never infer level from Rarity, Sort or ValueMultiplier.
	local values = {}
	local function add(value)
		local n = tonumber(value)
		if n and n >= 0 and n < math.huge and n % 1 == 0 then values[#values+1] = n end
	end
	add(def.Level); add(def.Lv)
	pcall(function()
		local name = Framework.Modules.TranslationUtil:TranslateByKey("K_" .. tostring(oreId):upper())
		if type(name) == "string" then
			local clean = name:gsub("<[^>]+>", ""):lower()
			add(clean:match("lv%.?%s*(%d+)") or clean:match("level%s*(%d+)"))
		end
	end)
	if #values == 0 then return nil end
	for _, value in ipairs(values) do if value ~= values[1] then return nil end end
	return values[1]
end
local function isCleanupOreAllowed(oreId, def)
	if Config.ProtectedOres[oreId] then return false end
	if Config.ForgeFilterMode == "Level" then
		local maximum = tonumber(Config.ForgeMaxOreLevel)
		if not maximum or maximum <= 0 or maximum == math.huge or maximum % 1 ~= 0 then return false end
		local level = getOreLevel(oreId, def)
		return level ~= nil and level <= maximum, level
	end
	return isAllowedForgeRarity(def.Rarity)
end
local function findNextCraftableOre()
	local ores = DataUtil:GetValue(LocalPlayer, {"Ores"}) or {}
	local candidates = {}
	for oreId, count in pairs(ores) do
		if type(count) == "number" and count >= 3 then
			local def = ForgeUtil:GetDef(oreId)
			if def then
				local allowed, level = isCleanupOreAllowed(oreId, def)
				if allowed then
					table.insert(candidates, {id=oreId, count=count, rarity=def.Rarity or 0, sort=def.Sort or 0, level=level})
				end
			end
		end
	end
	table.sort(candidates, function(a, b)
		if Config.ForgeFilterMode == "Level" and a.level ~= b.level then return a.level < b.level end
		if a.rarity == b.rarity then return a.sort < b.sort end
		return a.rarity < b.rarity
	end)
	return candidates[1]
end

local function sellAllUnlockedEquipment(includeAllUnlocked, previewOnly)
	local owned = EquipmentData:GetOwned(LocalPlayer) or {}
	local sellList = {}
	for uuid, itemData in pairs(owned) do
		local isEquipped = EquipmentUtil:IsEquipByUUID(LocalPlayer, uuid)
		local isLocked = EquipmentUtil:IsLocked(LocalPlayer, uuid)
		local eligible = false
		if includeAllUnlocked == true then
			-- UTILITIES: Only gear from EquipmentData:GetOwned. This is the
			-- Weapon / Helmet / Breastplate inventory, NOT Ores/materials.
			-- Game rules: only locked or equipped gear is excluded.
			-- Do not apply Forge batch protection or time-limited flags here.
			eligible = isEquipped==false and isLocked==false
		else
			-- Preserve the more restrictive existing AUTOMATIC Forge/Sell behavior.
			local isTemp = TimeLimitUtil and TimeLimitUtil:IsTimeLimited(itemData) or false
			eligible = not (Runtime.PendingForge and Runtime.PendingForge[uuid])
				and not Config.BatchProtected[tostring(uuid)]
				and not isEquipped and not isLocked and not isTemp
				and (not Config.SellOnlyForged or Runtime.Forged[uuid])
		end
		if eligible then table.insert(sellList, uuid) end
	end
	-- Preview is read-only. Utilities requires a deliberate second click before selling.
	if previewOnly == true then return #sellList end
	if #sellList > 0 then
		StatusLbl.Text = string.format("Status: Đang bán %d trang bị chưa khóa...", #sellList)
		checkRunning()
		EquipmentUtil:Sell(LocalPlayer, sellList)
		waitUntil(function()
			local remaining = EquipmentData:GetOwned(LocalPlayer) or {}
			for _, uuid in ipairs(sellList) do if remaining[uuid] then return false end end
			return true
		end, 4)
		local remaining = EquipmentData:GetOwned(LocalPlayer) or {}
		local sold = 0
		for _, uuid in ipairs(sellList) do
			if not remaining[uuid] then sold = sold + 1; Runtime.Forged[uuid] = nil end
		end
		if sold == 0 then error("Chưa xác nhận bán thành công; kiểm tra túi đồ") end
		return sold
	end
	return 0
end

local function forgeRecipeCore(recipe, craftType, batch, disposition)
	checkRunning()
	local inventoryBefore = {}
	local initialOwned = EquipmentData:GetOwned(LocalPlayer)
	assert(type(initialOwned)=="table", "Chưa đọc được trang bị trước Forge")
	for uuid in pairs(initialOwned) do inventoryBefore[uuid] = true end
	Runtime.Log("FORGE_START " .. tostring(disposition or "LEGACY"))
	local epoch, character = Runtime.CharacterEpoch, LocalPlayer.Character
	local function forgeCall(action, ...)
		checkRunning()
		if (not batch and not Config.AutoForge) or isTransitioning() then error("Đã dừng rèn") end
		assert(ForgeRF, "Thiếu ForgeRF")
		assert(GamePlaceUtil:IsMain() and epoch==Runtime.CharacterEpoch and character==LocalPlayer.Character, "Mất trạng thái rèn/nhân vật")
		local args=table.pack(...)
		local finished, response
		task.spawn(function()
			response=table.pack(pcall(function() return ForgeRF:InvokeServer(action,table.unpack(args,1,args.n)) end))
			finished=true
		end)
		if not waitUntil(function() return finished end,12) then
			Runtime.ForgeUncertain=true
			error("Forge remote timeout " .. action .. "; khóa Forge/Create đến phiên game mới để tránh gửi lặp")
		end
		checkRunning()
		assert(response[1], tostring(response[2]))
		assert(response[2] ~= false, "Server từ chối " .. action .. ": " .. tostring(response[3]))
		return response[2]
	end
	local totalOres = 0
	local ownedOres = DataUtil:GetValue(LocalPlayer, {"Ores"}) or {}
	for id, count in pairs(recipe) do
		assert(type(count) == "number" and count >= 1 and count % 1 == 0, "Số đá phải là số nguyên dương")
		assert((ownedOres[id] or 0) >= count, "Không đủ đá " .. tostring(id))
		totalOres = totalOres + count
	end
	assert(totalOres >= 3, "Công thức cần ít nhất 3 viên")
	StatusLbl.Text = string.format("Status: Rèn %s từ %d viên...", craftType, totalOres)

	local existingResult = ForgeUtil:GetResult(LocalPlayer)
	assert(not (existingResult and existingResult.ID), "Có kết quả rèn cũ; nhận thủ công rồi bật lại Auto Forge")
	forgeCall("DropOres", recipe, craftType)

	local waitStart = os.clock()
	local forgeData = nil
	repeat
		checkRunning()
		task.wait(0.05)
		forgeData = ForgeUtil:GetForgeData(LocalPlayer)
	until (forgeData and forgeData.OresNum and forgeData.OresNum > 0) or (os.clock() - waitStart > 2.5)
	assert(forgeData and forgeData.OresNum and forgeData.OresNum > 0, "Không nhận được trạng thái rèn")

	assert(forgeData.OresNum == totalOres, "Trạng thái rèn không khớp công thức; dừng để kiểm tra")
	local qteCfg = ForgeUtil:GetForgeQTE(forgeData.OresNum)
	local totalQTE = qteCfg and tonumber(qteCfg.QT)
	assert(totalQTE and totalQTE > 0 and totalQTE % 1 == 0, "Chưa đọc được số lượt QTE; không gửi Finish")
	local function completedQTE()
		local data = ForgeUtil:GetForgeData(LocalPlayer)
		return data and data.QTE and tonumber(data.QTE.Times) or 0
	end

	local usedUUIDs = {}
	for i = completedQTE() + 1, totalQTE do
		checkRunning()
		local qteUUID = nil
		local t0 = os.clock()
		repeat
			checkRunning()
			pcall(function()
				local qteObj = ForgeUtil:GetQTE(LocalPlayer)
				if qteObj and qteObj.UUID and not usedUUIDs[qteObj.UUID] then
					qteUUID = qteObj.UUID
				end
			end)
			if not qteUUID then task.wait(0.04) end
		until qteUUID or (os.clock() - t0 > 6.0)
		assert(qteUUID, "Hết thời gian chờ QTE " .. tostring(i))

		if qteUUID then
			usedUUIDs[qteUUID] = true
			forgeCall("QTE", {["UUID"] = qteUUID, ["Rating"] = 15})
			assert(waitUntil(function() return completedQTE() >= i end, 6),
				"Chưa xác nhận QTE " .. tostring(i) .. "; dừng, không gửi Finish sớm")
		end
	end

	assert(completedQTE() >= totalQTE, "Chưa đủ lượt QTE")
	forgeCall("ForgeFinish")
	assert(waitUntil(function()
		local result = ForgeUtil:GetResult(LocalPlayer)
		return result and result.ID
	end, 6), "Không nhận được kết quả rèn")
	local result = ForgeUtil:GetResult(LocalPlayer)
	local resultId = result and result.ID
	local resultUUID = result and result.UUID
	local receivedUUID
	forgeCall("ForgeResult", true)
	assert(waitUntil(function()
		local owned = EquipmentData:GetOwned(LocalPlayer)
		if type(owned)~="table" then return false end
		local candidates={}
		for uuid,item in pairs(owned) do
			if not inventoryBefore[uuid] and type(item)=="table" and
				(tostring(item.ID)==tostring(resultId) or tostring(item.Id)==tostring(resultId)) then
				if not resultUUID or tostring(uuid)==tostring(resultUUID) then table.insert(candidates,uuid) end
			end
		end
		assert(#candidates<=1, "Nhiều UUID cùng khớp; không xác định nguồn gốc, không bán")
		receivedUUID=candidates[1]
		return receivedUUID~=nil
	end,8), "Chưa xác định được trang bị vừa rèn; không bán, không rèn tiếp")
	-- ForgeResult often supplies an item ID but no UUID.  We already verified that
	-- exactly ONE freshly created inventory UUID matches that result ID, and (if
	-- present) matches the server-returned UUID.  That uniquely identifies THIS
	-- craft's output without requiring result.UUID to exist.
	local identificationSource = resultUUID ~= nil and "SERVER_UUID" or "INVENTORY_DIFF_RESULT_ID"
	Runtime.Forged[receivedUUID]=true
	if disposition == "SELL" then
		Runtime.PendingForge[receivedUUID]=true
		Runtime.ForgeReceipts[receivedUUID]={Exact=true,Mode="SELL",Source=identificationSource,ResultId=resultId}
	elseif batch and disposition~="FEBS" then
        -- F.EB.S is explicitly meant to compare and dispose of unlocked gear;
        -- do not quietly mark its new result as long-term batch protected.
		Config.BatchProtected[tostring(receivedUUID)]=true
		saveConfig()
	end
	Runtime.Log("FORGE_RECEIVED " .. tostring(receivedUUID) .. " source=" .. identificationSource .. " resultId=" .. tostring(resultId))
	-- Remote Forge does not open native windows. Closing invisible windows on every
    -- remote-only forge may interfere with the game's manual interaction state.
    -- Never touch an unopened native forge UI. Do NOT create fake E prompts.
    local closed, closeErr=pcall(function()
        local main=PlayerGui:FindFirstChild("MainGuiIgnoreGuiInset")
        for _,windowName in ipairs({"ScreenForging","ScreenForgeResult"}) do
            local view=main and main:FindFirstChild(windowName)
            if view and view.Visible then
                WindowUtil:Close(windowName)
            end
        end
    end)
    if not closed then Runtime.Log("FORGE_UI_CLOSE_FAILED " .. tostring(closeErr)) end
	return receivedUUID
end
local function forgeRecipe(recipe,craftType,batch,disposition)
	assert(not Runtime.ForgeUncertain, "Giao dịch Forge trước chưa rõ; kiểm tra game và vào phiên mới")
	local token=assert(Runtime.Acquire("FORGE"), "Đang có tác vụ giữ quyền")
	local ok,result=pcall(forgeRecipeCore,recipe,craftType,batch,disposition)
	Runtime.Release(token)
	if not ok then error(result,0) end
	return result
end

-- Exact output sale: no whole-inventory selling is used here.
Runtime.ForgeReceipts = {}
Runtime.PendingForge = {}
function Runtime.SellForgeOutput(uuid)
    checkRunning()
    local receipt=Runtime.ForgeReceipts[uuid]
    assert(receipt and receipt.Exact and receipt.Mode=="SELL" and Runtime.PendingForge[uuid], "Không có nguồn gốc Forge SELL chắc chắn")
    assert(not Config.BatchProtected[tostring(uuid)], "Thành phẩm đã được bảo vệ; không bán")
    local owned=EquipmentData:GetOwned(LocalPlayer)
    assert(type(owned)=="table" and owned[uuid], "Chưa thấy UUID trong túi")
    assert(EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)==false, "Đang đeo hoặc không xác minh được trạng thái đeo")
    assert(EquipmentUtil:IsLocked(LocalPlayer,uuid)==false, "Đã khóa hoặc không xác minh được khóa")
    assert(TimeLimitUtil and TimeLimitUtil:IsTimeLimited(owned[uuid])==false, "Không xác minh được điều kiện time-limit")
    assert(not isTransitioning() and GamePlaceUtil:IsMain(), "Đã rời Lobby")
    local finished,response
    task.spawn(function()
        response=table.pack(pcall(function() return EquipmentUtil:Sell(LocalPlayer,{uuid}) end))
        finished=true
    end)
    if not waitUntil(function() return finished end,12) then
        Runtime.ForgeUncertain=true
        error("Sell timeout; chưa biết kết quả, không gửi lại")
    end
    assert(response[1],tostring(response[2]))
    assert(response[2]~=false, "Server từ chối Sell UUID " .. tostring(uuid))
    local confirmed=waitUntil(function()
        assert(not isTransitioning() and GamePlaceUtil:IsMain(), "Mất trạng thái Lobby trong khi xác nhận Sell")
        local current=EquipmentData:GetOwned(LocalPlayer)
        return type(current)=="table" and current[uuid]==nil
    end,8)
    if not confirmed then
        Runtime.ForgeUncertain=true
        error("Chưa xác nhận Sell UUID; không rèn tiếp")
    end
    Runtime.PendingForge[uuid],Runtime.ForgeReceipts[uuid],Runtime.Forged[uuid]=nil,nil,nil
    Runtime.Log("FORGE_SOLD " .. tostring(uuid))
end
-- v4.9.15: Background Auto Clear Trash, independent of manual Forge & Sell/Keep.
-- Runs when enabled in a safe Lobby, without any cleanup-to-count target.
-- 3 normal ores -> Weapon; opt-in Mythic -> Weapon for clone, Armor for main.
-- Main account sells ONLY the exact newly forged result UUID.
do
    -- Shared safe recipe-builder for regular 3-ore cleanup and Mythic Trash.
    -- Both paths use the very same ForgeRF flow; only eligibility/count/type vary.
    local function collectTrashRecipe(count,rarity,levelBelow)
        local ores=DataUtil:GetValue(LocalPlayer,{"Ores"})
        assert(type(ores)=="table", "Auto Clear Trash: không đọc được túi nguyên liệu")
        local candidates={}
        for id,amount in pairs(ores) do
            if type(amount)=="number" and amount>=1 and amount<math.huge and amount%1==0
                and not (type(Config.ProtectedOres)=="table" and Config.ProtectedOres[id]) then
                local def=ForgeUtil:GetDef(id)
                local r=def and tonumber(def.Rarity)
                local level=nil
                local eligible=false
                if rarity==6 then
                    -- At or BELOW chosen Lv; unknown/conflicting level is protected.
                    if r==6 then
                        level=getOreLevel(id,def)
                        eligible=level~=nil and level<=levelBelow
                    end
                else
                    eligible=r~=nil and r>=1 and r<=rarity
                end
                if eligible then
                    candidates[#candidates+1]={Id=id,Count=amount,Rarity=r,Level=level}
                end
            end
        end
        table.sort(candidates,function(a,b)
            if a.Rarity~=b.Rarity then return a.Rarity<b.Rarity end
            if a.Level~=b.Level then return (a.Level or math.huge)<(b.Level or math.huge) end
            return tostring(a.Id)<tostring(b.Id)
        end)
        local recipe,needed={},count
        for _,ore in ipairs(candidates) do
            local take=math.min(needed,ore.Count)
            if take>0 then recipe[ore.Id]=take;needed=needed-take end
            if needed==0 then return recipe end
        end
        return nil
    end
    local function nextTrashRecipe()
        -- Spend lower rarity trash first; Mythic needs separate explicit opt-in.
        -- No total-bag target: stop only when no full eligible recipe remains.
        local regular=collectTrashRecipe(3,Config.AutoClearTrashMaxRarity,nil)
        if regular then return regular,"NORMAL","Weapon",3 end
        if Config.MythicTrashEnabled then
            local n=Config.MythicTrashOreCount
            local mythic=collectTrashRecipe(n,6,Config.MythicTrashLevelBelow)
            if mythic then
                local typeForMythic = Config.AutoTrashFEBS and "Weapon" or "Armor"
                return mythic,"MYTHIC",typeForMythic,n
            end
        end
        return nil,nil,nil,nil
    end
    function Runtime.HasEligibleTrashRecipe()
        if not Config.AutoClearTrash then return false end
        local ok,recipe=pcall(nextTrashRecipe)
        return ok and recipe~=nil
    end
    -- Clone-only purge. Only Bow items CONFIRMED by inventory metadata/ID,
    -- unlocked and UNEQUIPPED, are eligible. Does not touch Ores, locked gear,
    -- non-Bows or an actively worn Bow. Never infer class from a numeric enum.
    function Runtime.CloneSellUnlockedBowsBeforeEquip()
        assert(GamePlaceUtil:IsMain() and not isTransitioning() and not Runtime.ForgeUncertain,
            "F.E.B.S Bow cleanup requires stable Lobby / certain forge state")
        local owned=EquipmentData:GetOwned(LocalPlayer)
        assert(type(owned)=="table","F.E.B.S Bow cleanup: missing owned equipment")
        local bows={}
        for uuid,item in pairs(owned) do
            if type(item)=="table" then
                local ok,info=pcall(function()
                    return EquipmentUtil:GetEquipmentInfo(LocalPlayer,uuid)
                end)
                if not ok or type(info)~="table" then info={} end
                local def=type(info.Def)=="table" and info.Def or {}
                local confirmedBow=false
                for _,node in ipairs({item,info,def}) do
                    for _,field in ipairs({"Class","WeaponClass","WeaponType","WeaponCategory",
                        "ID","Id","Name","DisplayName","ItemName"}) do
                        local value=node[field]
                        if type(value)=="string" then
                            local low=value:lower()
                            -- Word boundary prevents false matching of 'rainbow'.
                            if low=="bow" or low:find("%f[%a]bow%f[%A]") then
                                confirmedBow=true
                                break
                            end
                        end
                    end
                    if confirmedBow then break end
                end
                if confirmedBow then
                    local equipped=EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)
                    local locked=EquipmentUtil:IsLocked(LocalPlayer,uuid)
                    if equipped==false and locked==false then
                        bows[#bows+1]=uuid
                    else
                        Runtime.Log("FEBS_BOW_PROTECTED uuid="..tostring(uuid)
                            .." equipped="..tostring(equipped).." locked="..tostring(locked))
                    end
                end
            end
        end
        if #bows==0 then return 0,{} end
        -- Sell one UUID at a time: a bulk request used to leave us unsure WHICH
        -- of N bows was sold. Never auto-retry an uncertain UUID.
        local sold={}
        for _,uuid in ipairs(bows) do
            checkRunning()
            assert(not Runtime.ForgeUncertain and GamePlaceUtil:IsMain()
                and not isTransitioning(),"F.E.B.S: Lobby/forge state changed")
            local current=EquipmentData:GetOwned(LocalPlayer)
            assert(type(current)=="table","F.E.B.S: cannot re-read owned bag")
            if current[uuid]~=nil then
                assert(EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)==false
                    and EquipmentUtil:IsLocked(LocalPlayer,uuid)==false,
                    "F.E.B.S: Bow protection changed for "..tostring(uuid))
                Runtime.ForgeSafetyPending[uuid]=true
                local finished,response=false,nil
                task.spawn(function()
                    response=table.pack(pcall(function()
                        return EquipmentUtil:Sell(LocalPlayer,{uuid})
                    end))
                    finished=true
                end)
                if not waitUntil(function() return finished end,12) then
                    Runtime.ForgeUncertain=true
                    error("FEBS_BOW_SELL_TIMEOUT uuid="..tostring(uuid).."; no auto retry")
                end
                if not response or not response[1] or response[2]==false then
                    -- An explicit error is still not permission to issue a second sell.
                    Runtime.ForgeUncertain=true
                    error("FEBS_BOW_SELL_FAILED uuid="..tostring(uuid).." response="..tostring(response and response[2]))
                end
                local confirmed=waitUntil(function()
                    if not GamePlaceUtil:IsMain() or isTransitioning() then return false end
                    local bag=EquipmentData:GetOwned(LocalPlayer)
                    return type(bag)=="table" and bag[uuid]==nil
                end,10)
                if not confirmed then
                    Runtime.ForgeUncertain=true
                    error("FEBS_BOW_SELL_UNCONFIRMED uuid="..tostring(uuid)
                        .."; Forge quarantined, Dungeon not blocked")
                end
                sold[uuid]=true
                Runtime.ForgeSafetyPending[uuid]=nil
                Runtime.Forged[uuid]=nil
                Runtime.Log("FEBS_BOW_SELL_VERIFIED uuid="..tostring(uuid))
            end
        end
        Runtime.Log("FEBS_BOW_PURGE_CONFIRMED count="..#bows.." BEFORE_EQUIP_BEST")
        return #bows,sold
    end

    local function equipBestAndSellForClone(forgedUUIDs)
        assert(type(forgedUUIDs)=="table" and #forgedUUIDs>0,"F.E.B.S: không có món rèn mới")
        assert(EquipRE and EquipRE:IsA("RemoteEvent"),"Không tìm thấy EquipmentRE để Equip Best; KHÔNG bán")
        assert(not Runtime.ForgeUncertain and not isTransitioning() and GamePlaceUtil:IsMain(),
            "Không ở Lobby ổn định hoặc Forge chưa chắc chắn; KHÔNG bán")
        local before=EquipmentData:GetOwned(LocalPlayer)
        assert(type(before)=="table","Không đọc được gear sau Forge; KHÔNG bán")
        for _,uuid in ipairs(forgedUUIDs) do
            assert(before[uuid],"Thiếu UUID trong batch: "..tostring(uuid).."; KHÔNG bán")
        end
        -- User's requested order: Sell ALL eligible unlocked Bow -> EquipBest.
        local soldBow,purgedBow=Runtime.CloneSellUnlockedBowsBeforeEquip()
        Runtime.Log("F_E_B_S_EQUIP_BEST_START batch="..tostring(#forgedUUIDs)
            .." preSoldBow="..tostring(soldBow))
        for _,kind in ipairs({"Weapon","Breastplate","Helmet"}) do
            EquipRE:FireServer("EquipBest",kind)
            task.wait(0.15) -- allow server equipment changes to replicate
        end
        -- EquipBest is a RemoteEvent (no direct success response). Fail closed
        -- if no equipped UUID is visible; never sell on a blind assumption.
        local sawEquipped=waitUntil(function()
            local current=EquipmentData:GetOwned(LocalPlayer)
            if type(current)~="table" then return false end
            for _,uuid in ipairs(forgedUUIDs) do
                if not purgedBow[uuid] and not current[uuid] then return false end
            end
            for uuid in pairs(current) do
                if EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)==true then return true end
            end
            return false
        end,2.5)
        assert(sawEquipped,"Chưa xác minh được Equip Best; KHÔNG bán bất kỳ gear nào")
        -- EquipmentRE has no success response. Require replicated equip state to
        -- settle and remain stable before the IRREVERSIBLE unlocked-gear sale.
        local function equippedSignature()
            local owned=EquipmentData:GetOwned(LocalPlayer)
            assert(type(owned)=="table","Không đọc được gear khi kiểm tra EquipBest")
            for _,uuid in ipairs(forgedUUIDs) do
                assert(purgedBow[uuid] or owned[uuid],
                    "Mất UUID mới trước khi bán: "..tostring(uuid))
            end
            local uuids={}
            for uuid in pairs(owned) do
                if EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)==true then
                    uuids[#uuids+1]=tostring(uuid)
                end
            end
            table.sort(uuids)
            return table.concat(uuids,"|")
        end
        task.wait(0.9)
        local first=equippedSignature()
        task.wait(0.35)
        local second=equippedSignature()
        assert(first~="" and second==first,
            "EquipBest chưa ổn định sau khi gọi remote; KHÔNG bán")
        local sold=soldBow
        local available=sellAllUnlockedEquipment(true,true)
        if available>0 then
            local soldLater=sellAllUnlockedEquipment(true,false)
            sold=sold+soldLater
            assert(soldLater==available,
                "F.EB.S: bán chỉ xác nhận "..tostring(sold).."/"..tostring(available).." gear; dừng và kiểm tra")
        end
        local after=EquipmentData:GetOwned(LocalPlayer)
        assert(type(after)=="table","Không đọc được túi sau F.EB.S")
        -- Every newly forged item is worn, sold, or locked by the player.
        for _,uuid in ipairs(forgedUUIDs) do
            if after[uuid] then
                assert(EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)==true
                    or EquipmentUtil:IsLocked(LocalPlayer,uuid)==true,
                    "Gear batch chưa được mặc/khóa/bán: "..tostring(uuid))
            else
                Runtime.Log("FORGE_SOLD "..tostring(uuid).." via F.E.B.S")
            end
        end
        Runtime.Log("F_E_B_S_COMPLETE forged="..#forgedUUIDs
            .." preSoldBow="..tostring(soldBow).." soldTotal="..tostring(sold))
        return sold
    end
    Runtime.CloneEquipBestSell=equipBestAndSellForClone -- same verified UUID/equipped checks
    local function updateTrashStatus(message)
        Runtime.AutoClearTrashStatus=message
        if Runtime.AutoClearTrashLabel and Runtime.AutoClearTrashLabel.Parent then
            Runtime.AutoClearTrashLabel.Text=message
        end
    end
    function Runtime.RecheckAutoClearTrashBlocked()
        if not Runtime.AutoClearTrashBlocked or Runtime.AutoClearTrashErrorBlocked or Runtime.ForgeUncertain then return false end
        -- Capacity or eligible inventory may change outside this script (manual trash sale).
        -- Recheck occasionally while staying in Lobby, WITHOUT needing Auto Farm OFF/ON.
        local now=os.clock()
        if now < (Runtime.AutoClearTrashRecoverCheckAt or 0) then return false end
        Runtime.AutoClearTrashRecoverCheckAt=now+2
        local bag=Runtime.OreBagSnapshot()
        local safe=(bag.Known and bag.Used<Config.OreReturnAt and bag.CanAdd~=false)
        local okRecipe,recipe=pcall(nextTrashRecipe)
        if bag.Known and (safe or (okRecipe and recipe~=nil)) then
            Runtime.AutoClearTrashBlocked=false
            Runtime.AutoClearTrashNextScanAt=0
            Config.AutoClearTrashPending=Config.AutoClearTrash==true
            updateTrashStatus("Túi đã đổi; Auto Clear Trash mở khóa và quét lại.")
            Runtime.Log("AUTO_CLEAR_TRASH_RECOVERED after manual inventory/threshold change")
            return true
        end
        return false
    end
    function Runtime.AutoClearTrashStep()
        if not Config.AutoClearTrash then return false end
        -- A failed/uncertain receipt quarantines ONLY Forge/Sell, not Dungeon combat.
        if Runtime.ForgeUncertain or Runtime.AutoClearTrashErrorBlocked then return false end
        -- Read Bag may be used by the guard, but its count NEVER decides which
        -- ores to forge or when to stop. Filter + full recipe alone decide that.
        if Config.OreSafetyEnabled then
            local bag=Runtime.OreBagSnapshot()
            if not bag.Known then
                Runtime.AutoClearTrashBlocked=true
                Config.OreCleanupActive=false
                updateTrashStatus("Không đọc được số Ores: tạm ngừng Auto Farm để tránh mất phần thưởng.")
                return false
            end
        end
        if Runtime.AutoClearTrashBlocked then
            Runtime.RecheckAutoClearTrashBlocked()
            if Runtime.AutoClearTrashBlocked then return false end
        end
        assert(GamePlaceUtil:IsMain() and not isTransitioning(),"Auto Clear Trash: chỉ rèn ở Lobby")
        assert(not Runtime.BatchActive and not Runtime.EntryBusy and not Runtime.ShopBusy and not Runtime.ForgeBusy and not Runtime.Owner,
            "Auto Clear Trash: đang có tác vụ khác")
        assert(not Runtime.ForgeUncertain,"Forge chưa xác định kết quả; không được bán/rèn tiếp")
        local recipe,mode,craftType,oreCount=nextTrashRecipe()
        if not recipe then
            -- Condition-based completion, independently of the number of Ores left.
            -- Keep the separate safety guard: never enter Solo while near/full.
            local bag=Runtime.OreBagSnapshot()
            Config.OreCleanupActive=false
            Config.AutoClearTrashPending=false
            Runtime.AutoClearTrashNextScanAt=os.clock()+12 -- Recheck later or on next Lobby return.
            local unsafe=(Config.OreSafetyEnabled and (
                not bag.Known or bag.Used>=Config.OreReturnAt or bag.CanAdd==false))
                or false -- legacy guard OFF never blocks Auto Entry due to full ore bag
            if unsafe then
                Runtime.AutoClearTrashBlocked=true
                Runtime.AutoClearTrashRecoverCheckAt=0
                updateTrashStatus("Hết rác hợp lệ nhưng túi gần/đầy; dừng Auto Entry để bảo vệ loot. "..Runtime.OreStatusText(bag))
                Runtime.Log("AUTO_CLEAR_TRASH_CAPACITY_BLOCK "..Runtime.OreStatusText(bag).." no eligible recipe")
            else
                Runtime.AutoClearTrashBlocked=false
                updateTrashStatus("Dọn xong theo bộ lọc; hết recipe hợp lệ. Đã xử lý "..tostring(Runtime.AutoClearTrashSold).." món. "..Runtime.OreStatusText(bag))
                Runtime.Log("AUTO_CLEAR_TRASH_FILTER_DONE sold="..tostring(Runtime.AutoClearTrashSold))
            end
            saveConfig()
            return false
        end
        Config.OreCleanupActive=true
        Runtime.ForgeBusy=true
        local doFEBS=(Config.AutoTrashFEBS==true) -- freeze account mode during the entire transaction
        local crafted=0
        updateTrashStatus(doFEBS and "F.E.B.S: Đang rèn toàn bộ Ore hợp lệ..." or "Forge -> Sell UUID mới...")
        local ok,err=pcall(function()
            if doFEBS then
                -- Clone: complete the *entire eligible batch* before EquipBest and any Sell.
                -- Up to 100 receipts per pass is a generous bound for 100-slot clone Ore bags;
                -- if ever exceeded, settle the batch safely, then resume on the next Lobby tick.
                local uuids={}
                for i=1,100 do
                    checkRunning()
                    assert(Config.AutoTrashFEBS and Config.AutoClearTrash,
                        "Chế độ F.E.B.S bị tắt giữa batch; không tiếp tục")
                    local r,m,ct,n=nextTrashRecipe()
                    if not r then break end
                    local beforeOres=DataUtil:GetValue(LocalPlayer,{"Ores"})
                    assert(type(beforeOres)=="table","Không đọc được Ore trước Forge")
                    local prior=0
                    for id,count in pairs(r) do prior=prior+(tonumber(beforeOres[id]) or 0) end
                    local uuid=forgeRecipe(r,ct,true,"FEBS")
                    uuids[#uuids+1]=uuid
                    crafted=crafted+1
                    Runtime.Log("FEBS_BATCH_FORGED "..crafted.." mode="..m.." ores="..n.." uuid="..tostring(uuid))
                    -- Never blindly craft using an old replicated inventory snapshot.
                    assert(waitUntil(function()
                        local current=DataUtil:GetValue(LocalPlayer,{"Ores"})
                        if type(current)~="table" then return false end
                        local remaining=0
                        for id in pairs(r) do remaining=remaining+(tonumber(current[id]) or 0) end
                        return remaining<prior
                    end,5),"Chưa thấy Ore giảm sau Forge; dừng batch, không bán")
                end
                assert(#uuids>0,"F.E.B.S: batch rỗng")
                updateTrashStatus("F.E.B.S: Đã rèn "..#uuids.." món; bán Bow rồi EquipBest và Sell...")
                -- No sale whatsoever until all forge receipts are confirmed.
                equipBestAndSellForClone(uuids)
            else
                -- Main account: sell only exact forge output UUID, NEVER bulk sell.
                local uuid=forgeRecipe(recipe,craftType,true,"SELL")
                Runtime.SellForgeOutput(uuid)
                crafted=1
            end
        end)
        Runtime.ForgeBusy=false
        if not ok then
            if Runtime.ForgeUncertain then
                Runtime.Log("FORGE_SAFETY_LOCK pending_uuid="..tostring(next(Runtime.ForgeSafetyPending)))
            end
            Runtime.AutoClearTrashBlocked=true
            Runtime.AutoClearTrashErrorBlocked=true
            if Runtime.ProtectPendingForge then Runtime.ProtectPendingForge() end
            updateTrashStatus("Auto Trash gặp lỗi Forge/receipt; DỪNG, không tự thử lại. Xem log.")
            Runtime.Log("AUTO_CLEAR_TRASH_FAILED "..tostring(err))
            error(err,0)
        end
        Runtime.AutoClearTrashSold=(Runtime.AutoClearTrashSold or 0)+crafted
        Runtime.AutoClearTrashNextScanAt=0
        updateTrashStatus((doFEBS and "F.E.B.S" or "Forge/Sell")..": đã xử lý "
            ..Runtime.AutoClearTrashSold.." lượt; tiếp tục quét các Ore đủ điều kiện")
        return true
    end
end

function Runtime.ProtectPendingForge()
    for uuid in pairs(Runtime.PendingForge) do Config.BatchProtected[tostring(uuid)]=true end
    saveConfig()
end
function Runtime.MixedTrashRecipe(requireMixed)
    local ores=DataUtil:GetValue(LocalPlayer,{"Ores"})
    assert(type(ores)=="table", "Chưa đọc được tồn kho đá")
    local candidates={}
    for id,count in pairs(ores) do
        if type(count)=="number" and count>=1 and count<math.huge and count%1==0 and not Config.ProtectedOres[id] then
            local def=ForgeUtil:GetDef(id)
            if def then
                local allowed,level=isCleanupOreAllowed(id,def)
                if allowed then table.insert(candidates,{Id=id,Count=count,Rarity=def.Rarity or math.huge,Level=level or getOreLevel(id,def) or math.huge,Sort=def.Sort or 0}) end
            end
        end
    end
    table.sort(candidates,function(a,b)
        if Config.ForgeFilterMode=="Level" and a.Level~=b.Level then return a.Level<b.Level end
        if a.Rarity~=b.Rarity then return a.Rarity<b.Rarity end
        if a.Level~=b.Level then return a.Level<b.Level end
        return tostring(a.Id)<tostring(b.Id)
    end)
    local recipe,remaining={},3
    if requireMixed then
        assert(#candidates>=2, "Cần ít nhất hai loại đá trong bộ lọc để test hỗn hợp")
        recipe[candidates[1].Id],recipe[candidates[2].Id]=1,1
        remaining=1
    end
    for _,ore in ipairs(candidates) do
        local take=math.min(remaining,ore.Count-(recipe[ore.Id] or 0))
        if take>0 then recipe[ore.Id]=(recipe[ore.Id] or 0)+take; remaining=remaining-take end
        if remaining==0 then break end
    end
    if remaining>0 then return nil end
    return recipe
end
function Runtime.RecipeText(recipe,count)
    local parts,totals={},{}
    for id,n in pairs(recipe) do
        table.insert(parts,tostring(id).." x"..n)
        table.insert(totals,tostring(id).." x"..(n*count))
    end
    table.sort(parts); table.sort(totals)
    return table.concat(parts," + ") .. " | " .. count .. " món cần: " .. table.concat(totals," + ")
end
function Runtime.TrashStep(testOnly)
    assert(not Runtime.BatchActive and not Runtime.EntryBusy and not Runtime.ShopBusy, "Đang có tác vụ khác")
    assert(GamePlaceUtil:IsMain() and not isTransitioning(), "Chỉ rèn tại Lobby")
    local recipe=Runtime.MixedTrashRecipe(testOnly)
    if not recipe then
        Config.AutoTrashSell=false
        if Runtime.ToggleRefresh.AutoTrashSell then Runtime.ToggleRefresh.AutoTrashSell() end
        Runtime.Log("FORGE_TRASH_IDLE tổng đá hợp lệ còn dưới 3")
        return false
    end
    local kinds=0
    for _ in pairs(recipe) do kinds=kinds+1 end
    assert(testOnly or kinds==1 or Runtime.MixedForgeVerified, "Chưa test công thức hỗn hợp trong phiên; dùng nút Test 1 món KEEP")
    Runtime.Log("FORGE_TRASH_RECIPE " .. Runtime.RecipeText(recipe,1))
    Runtime.ForgeBusy=true
    local ok,err=pcall(function()
        local uuid=forgeRecipe(recipe,Config.ForgeTargetType,true,testOnly and "KEEP" or "SELL")
        if testOnly then
            Runtime.MixedForgeVerified=true
            StatusLbl.Text="Đã nhận 1 sản phẩm mixed; giữ lại. Có thể bật Auto Trash SELL."
        else Runtime.SellForgeOutput(uuid) end
    end)
    Runtime.ForgeBusy=false
    if not ok then Runtime.ProtectPendingForge(); error(err,0) end
    return true
end

local function forgeSingleItem(oreId)
	return forgeRecipe({[oreId] = 3}, Config.ForgeTargetType or "Armor", false)
end

local function getRuneLevel(stoneId, def)
	local num = tonumber(tostring(stoneId):match("(%d+)$"))
	if num then return num end
	if def and def.Rarity then return def.Rarity end
	return 1
end

local function isAllowedRuneLevel(lv)
	if lv == 1 then return Config.FuseLv1 end
	if lv == 2 then return Config.FuseLv2 end
	if lv == 3 then return Config.FuseLv3 end
	if lv == 4 then return Config.FuseLv4 end
	return false
end

local function tryFuseRunesOnce()
	local ownedRunes = DataUtil:GetValue(LocalPlayer, {KeyString.MaterialUtil.EnchantedStone, KeyString.EquipmentUtil.Owned}) or {}
	local groups = {}

	for uuid, runeData in pairs(ownedRunes) do
		local rId = runeData.Id
		if rId then
			local cfg = ResEnchantedStoneConfig[rId]
			local def = MaterialUtil:GetDef(rId)
			if cfg and cfg.UpgradeToID and cfg.UpgradeToID ~= "" then
				local lv = getRuneLevel(rId, def)
				if isAllowedRuneLevel(lv) then
					groups[rId] = groups[rId] or {}
					table.insert(groups[rId], uuid)
				end
			end
		end
	end

	for rId, uuidList in pairs(groups) do
		if #uuidList >= 3 then
			local cfg = ResEnchantedStoneConfig[rId]
			local nextCfg = cfg and ResEnchantedStoneConfig[cfg.UpgradeToID]
			local cost = (nextCfg and nextCfg.UpgradePrice) or 0
			local canAfford = true
			if cost > 0 then
				pcall(function()
					canAfford = CurrencyUtil:Has(LocalPlayer, CurrencyUtil.CurrencyIds.Currency1, cost)
				end)
			end
			if canAfford then
				local batch = {uuidList[1], uuidList[2], uuidList[3]}
				StatusLbl.Text = string.format("Status: Đang Fuse 3 Rune [%s]...", tostring(rId))
				checkRunning()
				local result = EnchantmentUtil:FuseStones(LocalPlayer, batch)
				assert(result ~= false, "Server từ chối Fuse")
				assert(waitUntil(function()
					local remaining = DataUtil:GetValue(LocalPlayer, {KeyString.MaterialUtil.EnchantedStone, KeyString.EquipmentUtil.Owned}) or {}
					for _, uuid in ipairs(batch) do if remaining[uuid] then return false end end
					return true
				end, 5), "Chưa xác nhận Fuse thành công")
				return true
			end
		end
	end
	return false
end

local function getEndlessStartFloor()
	local maxRound = 1
	pcall(function()
		maxRound = WorldUtil:GetWorldRecords(LocalPlayer, "Endless1", 1, "MaxRound", SeasonUtil:GetCurrentSeason()) or 1
	end)
	local clamped = 1
	if type(maxRound) == "number" then
		clamped = math.clamp(math.floor(maxRound), 1, EndlessConfig.ConfigRoundCount or 100)
	end
	local step = EndlessRoundUtil.ROUND_STEP or 5
	local base = math.floor(clamped / step) * step
	local hasHighestCleared = step <= base
	local highestClearedFloor = base - step + 1
	local floorStart = EndlessRoundUtil.GetFloorStart(clamped)
	local nextChallengeFloor = math.max(floorStart, base + 1)

	if Config.EndlessMode == "HighestCleared" and hasHighestCleared then
		return highestClearedFloor
	end
	if nextChallengeFloor <= (EndlessConfig.ConfigRoundCount or 100) then
		return nextChallengeFloor
	end
	return hasHighestCleared and highestClearedFloor or 1
end

local function resolveTargetWorldAndDiff()
	local w = Config.SelectedWorld
	if w == "Endless1" then
		return "Endless1", 1, (Runtime.TowerGetFloor and Runtime.TowerGetFloor() or getEndlessStartFloor())
	end

	local maxDiff = 10
	if w == "Cave1" then
		maxDiff = 5
	elseif w == "Cave2" or w == "Cave3" then
		maxDiff = 4
	end

	local currentPower = PlayerInfoUtil:GetPower(LocalPlayer) or 0
	local currentLevel = LevelUtil:GetPlayerLevel(LocalPlayer) or 1

	local function isDiffUnlocked(worldId, d)
		return WorldUtil:IsUnlockWorld(LocalPlayer, worldId, d) == true
	end

	if Config.SelectedDiff == "BEST" then
		for d = maxDiff, 1, -1 do
			local ok, diffInfo = pcall(function() return WorldUtil:GetWorldDiffInfo(w, d) end)
			if ok and diffInfo and isDiffUnlocked(w, d) then
				local reqP = diffInfo.RecBattlePower or 0
				local reqL = diffInfo.RecPlayerLv or 1
				if currentPower >= reqP and currentLevel >= reqL then
					return w, d, nil
				end
			end
		end
		error("Không có độ khó phù hợp đã mở khóa cho " .. tostring(w))
	elseif Config.SelectedDiff == "HIGHEST" then
		for d = maxDiff, 1, -1 do
			local ok, diffInfo = pcall(function() return WorldUtil:GetWorldDiffInfo(w, d) end)
			if ok and diffInfo and isDiffUnlocked(w, d) then
				return w, d, nil
			end
		end
		error("Chưa mở khóa độ khó nào của " .. tostring(w))
	else
		local d = math.clamp(tonumber(Config.SelectedDiff) or 1, 1, maxDiff)
		return w, d, nil
	end
end

local function currentLobbyRoomState()
	local id = LocalPlayer:GetAttribute("EnterRoomId")
	local rooms = Workspace:FindFirstChild("MatchRoom")
	local room = id and rooms and rooms:FindFirstChild(tostring(id))
	return room and room:GetAttribute("RoomState"), room
end
local function roomWaitingTeleport()
	local state = currentLobbyRoomState()
	return GameEnum.RoomState and state == GameEnum.RoomState.WaitTeleport
end

local function lobbyCharacterReady()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	return char and char.Parent and root and root.Parent and hum and hum.Health > 0
end

local DefaultPortalEntrances = {
	World1_2 = {118.42, 27.22, 170.90},
	World3_4 = {9959.47, 12.98, 105.28},
	Cave = {9940.43, 12.98, 102.20},
	Endless = {-31.11, 64.73, -156.66},
	Valhalla = {106.77, -449.25, -563.18}
}
Runtime.DefaultPortalEntrances = DefaultPortalEntrances

local function portalKey(world)
	if type(world) ~= "string" then return nil end
	if world == "World1" or world == "World2" then return "World1_2" end
	if world == "World3" or world == "World4" or world == "World5" then return "World3_4" end
	if world:match("^World%d+$") then return "Dungeon" end
	if world:match("^Cave%d+$") then return "Cave" end
	if world:match("^Endless%d+$") then return "Endless" end
	if world:lower():find("valhalla") then return "Valhalla" end
end
local function validEntrance(value)
	if type(value) ~= "table" or (#value ~= 3 and #value ~= 12) then return false end
	for _, n in ipairs(value) do
		if type(n) ~= "number" or n ~= n or math.abs(n) == math.huge then return false end
	end
	return true
end
local function savedEntrance(world)
	local key = assert(portalKey(world), "Không nhận diện được loại cổng: " .. tostring(world))
	-- Fixed lobby pads verified by the user; old saved overrides must not silently replace them.
	local default = DefaultPortalEntrances[key]
	if validEntrance(default) then return table.clone(default), key, "HARDCODED" end
	return nil, key, "MISSING"
end

local portalRetry = {Count=0, At=0}
local function retryPortal(reason)
	portalRetry.Count = portalRetry.Count + 1
	local delay = math.min(30, 3 * portalRetry.Count)
	portalRetry.At = os.clock() + delay
	StatusLbl.Text = string.format("Status: %s; thử lại sau %ds, Auto vẫn ON", reason, delay)
end
local function performDungeonEntry(activationOnly)
	checkRunning()
	if (not Config.AutoFarm and not Runtime.ManualEntry) or Runtime.SuppressAutoCreate or isTransitioning() then return end
	if roomWaitingTeleport() or os.clock() < portalRetry.At then return end
	-- Returning to the lobby can precede Character/RootPart replication.
	-- This is a pending respawn, not a configuration error: retry next tick.
	if not lobbyCharacterReady() then
		StatusLbl.Text = "Status: Chờ nhân vật hồi sinh ở Lobby; Auto vẫn ON..."
		return
	end
	local w, d, floor = resolveTargetWorldAndDiff()
    if w~="Endless1" and Runtime.DungeonCounterReached and Runtime.DungeonCounterReached() and not Runtime.CloneDailyActive
        and not (Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled()) and not Runtime.ManualEntry then
        Runtime.SuppressAutoCreate=true
        return
    end
    if w=="Endless1" and Runtime.TowerCounter then
        local st=Runtime.TowerCounter
        if (st.AutoEnabled or Runtime.CloneDailyTowerActive) and Runtime.TowerGetUsed()>=Runtime.TowerGetTarget() then
            Runtime.SuppressAutoCreate=true
            return
        end
    end
	local windowName = w == "Endless1" and "ScreenMatch_Endless" or "ScreenMatch"
	local mode = WorldUtil:GetWorldMode(w)
	local entrance, entranceKey, entranceSource = savedEntrance(w)
	Runtime.Log("ENTRY_PAD " .. tostring(entranceKey) .. " source=" .. tostring(entranceSource))
	assert(validEntrance(entrance),
		"Chưa lưu cổng " .. entranceKey .. "; bước vào ô đúng rồi lưu một lần ở mục 6")
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local padCFrame = CFrame.new(table.unpack(entrance))
	local position = padCFrame.Position
	Runtime.EntryHumanoid = hum
	local selectedWorld, selectedDiff, selectedFloorMode, selectedTowerLevel = Config.SelectedWorld, Config.SelectedDiff, Config.EndlessMode, (Runtime.TowerGetFloor and Runtime.TowerGetFloor())
	local function stillValid()
		checkRunning()
		assert(os.clock() < Runtime.EntryDeadline, "Hết thời gian giữ quyền DUNGEON_ENTRY")
		assert((Config.AutoFarm or Runtime.ManualEntry) and GamePlaceUtil:IsMain() and not isTransitioning(), "Đã hủy hoặc rời Lobby")
		assert(activationOnly or Config.AutoCreateRole=="Solo", "Đã chuyển sang Team Follower; hủy Create")
		assert(lobbyCharacterReady() and LocalPlayer.Character == char, "Nhân vật đã thay đổi")
		assert(Config.SelectedWorld == selectedWorld and Config.SelectedDiff == selectedDiff and Config.EndlessMode == selectedFloorMode and selectedTowerLevel == (Runtime.TowerGetFloor and Runtime.TowerGetFloor()), "Map/độ khó/Level Tower đã thay đổi; hủy Create")
	end
	local mainGui = PlayerGui:WaitForChild("MainGui", 10)
	if not mainGui then retryPortal("Chờ MainGui tải"); return end
	local gui = mainGui:WaitForChild(windowName, 10)
	if not gui then retryPortal("Chờ GUI chọn map tải"); return end
	if not lobbyCharacterReady() or LocalPlayer.Character ~= char or isTransitioning() then return end
	StatusLbl.Text = string.format("Status: Vào ô -> %s / Diff %d...", w, d)
	local data = WindowUtil:GetOpenData(windowName)
	local otherName = windowName == "ScreenMatch" and "ScreenMatch_Endless" or "ScreenMatch"
	local otherGui = mainGui:FindFirstChild(otherName)
	local wrongNormal = gui.Visible and windowName == "ScreenMatch" and data and data.Mode ~= mode
	if wrongNormal or (otherGui and otherGui.Visible) then
		-- Closing the native selector releases its draft room; do not overwrite saved coordinates.
		WindowUtil:Close(wrongNormal and windowName or otherName)
		StatusLbl.Text = "Status: Rời ô cũ; chuẩn bị chuyển sang cổng " .. entranceKey
		waitUntil(function() return not LocalPlayer:GetAttribute("EnterRoomId") or isTransitioning() end, 5)
		return
	end
	local function nativeReady()
		local id = LocalPlayer:GetAttribute("EnterRoomId")
		local open = WindowUtil:GetOpenData(windowName)
		return mainGui.Enabled and gui.Visible and id ~= nil and id ~= false and tostring(id) ~= ""
			and (windowName == "ScreenMatch_Endless" or (type(open) == "table" and open.Mode == mode))
	end
	if not nativeReady() then
		assert(not LocalPlayer:GetAttribute("EnterRoomId"), "Còn phòng nháp cũ; đóng native UI và rời ô rồi thử lại")
		local directions = {Vector3.new(0,0,-5), Vector3.new(5,0,0), Vector3.new(0,0,5), Vector3.new(-5,0,0)}
		for index, direction in ipairs(directions) do
			stillValid()
			char:PivotTo(padCFrame)
			root.AssemblyLinearVelocity = Vector3.zero
			task.wait(0.3)
			stillValid()
			hum:MoveTo(position + direction)
			Runtime.Log("PAD " .. entranceKey .. " MoveTo 5 studs, direction=" .. index)
			local ready = waitUntil(function() stillValid(); return nativeReady() end, 4)
			hum:MoveTo(root.Position)
			if ready then break end
			Runtime.Log("PAD chưa hợp lệ: Visible=" .. tostring(gui.Visible) .. " EnterRoomId=" .. tostring(LocalPlayer:GetAttribute("EnterRoomId")))
		end
	end
	stillValid()
	assert(nativeReady(), "Không có native UI + EnterRoomId đúng mode sau 4 hướng; kiểm tra tọa độ ô")
	Runtime.Log("PAD_READY " .. entranceKey .. " EnterRoomId=" .. tostring(LocalPlayer:GetAttribute("EnterRoomId")))
	if activationOnly then StatusLbl.Text = "Đã kích hoạt native UI + EnterRoomId; CHƯA gửi Create"; return end
	assert(WorldRE, "Thiếu WorldRE")
	WorldRE:FireServer("SelectWorld", w, d)
	task.wait(0.5)
	checkRunning()
	if roomWaitingTeleport() then return end
	stillValid()
	if not lobbyCharacterReady() or LocalPlayer.Character ~= char then return end
	assert(nativeReady(), "Mất native UI/EnterRoomId trước Create")
	if (root.Position - position).Magnitude >= 16 then retryPortal("Đã rời vị trí cổng"); return end
	local newWorld, newDiff = resolveTargetWorldAndDiff()
	if newWorld ~= w or newDiff ~= d then return end
	StatusLbl.Text = string.format("Status: CreatRoom %s / Diff %d / arg4=1...", w, d)
	if w == "Endless1" then
        if Runtime.TowerPrepareCreate then
            local allowed,why=Runtime.TowerPrepareCreate()
            assert(allowed,why or "Tower bị chặn")
        end
		GameMatchRE:FireServer("CreatRoom", w, d, 1, floor or 1)
	else
		GameMatchRE:FireServer("CreatRoom", w, d, 1)
	end
	-- Leave the game window alone; manually closing it can invoke LeaveRoom.
	assert(waitUntil(function()
		return roomWaitingTeleport() or isTransitioning() or not GamePlaceUtil:IsMain()
	end, 12), "Đã gửi Create nhưng chưa có WaitTeleport; EnterRoomId riêng lẻ chưa đủ xác nhận")
	portalRetry.Count, portalRetry.At = 0, 0
	StatusLbl.Text = "Status: Đã nhận phòng; chờ chuyển map..."
end
local function enterSelectedDungeon(activationOnly, manual)
	checkRunning()
	assert(activationOnly or Config.AutoCreateRole=="Solo", "Team Follower: không tự tạo phòng riêng; đổi chế độ lưu nếu muốn Create")
	assert(not Runtime.Owner and not Runtime.ShopBusy, "Đang có tác vụ khác")
	assert(not Runtime.EntryBusy and not Runtime.ForgeBusy and not Runtime.BatchActive, "Đang có tác vụ Entry/Forge")
	local forgeUI = forgingGui()
	assert(not (forgeUI and forgeUI.Visible), "Hoàn tất rèn thủ công trước")
	Runtime.EntryBusy, Runtime.ManualEntry = true, manual == true
	Runtime.EntryDeadline = os.clock() + 60
	Runtime.Log("STATE DUNGEON_ENTRY")
	if Runtime.CancelPatrol then Runtime.CancelPatrol() end
	local ok, err = pcall(performDungeonEntry, activationOnly)
	if Runtime.EntryHumanoid and Runtime.EntryHumanoid.Parent then
		pcall(function() Runtime.EntryHumanoid:MoveTo(Runtime.EntryHumanoid.RootPart.Position) end)
	end
	Runtime.EntryHumanoid = nil
	Runtime.EntryBusy, Runtime.ManualEntry = false, false
	Runtime.Log(ok and "ENTRY_RELEASED" or ("ENTRY_FAILED " .. tostring(err)))
	if not ok then error(err, 0) end
end
local isLobbyBusy = false

task.spawn(function()
	while Runtime.Alive and task.wait(0.4) do
		if not Runtime.Alive then break end
		if GamePlaceUtil:IsMain() and not isTransitioning() and not roomWaitingTeleport() and not isLobbyBusy and not Runtime.BatchActive and not Runtime.EntryBusy and not Runtime.Owner and not Runtime.ShopBusy then
			isLobbyBusy = true
			local stage = "Lobby"
			local ok, err = pcall(function()
				if not lobbyCharacterReady() then
					if Config.AutoFarm and Config.AutoCreateRole=="Solo" then
						StatusLbl.Text = "Status: Chờ nhân vật hồi sinh ở Lobby; Auto vẫn ON..."
					end
					return
				end
                -- Neither background cleanup nor Auto Create may interrupt a native Forge UI
                -- or a result that still awaits manual acknowledgement.
                local manualGui=forgingGui()
                if manualGui and manualGui.Visible then return end
                local pendingResult=ForgeUtil:GetResult(LocalPlayer)
                if pendingResult and pendingResult.ID then return end
                -- Capacity guard controls RETURN/BLOCK only; cleanup runs by filters.
                if Config.OreSafetyEnabled then
                    local needs,b,why=Runtime.OreNeedsLobby()
                    if needs and b.Known and (b.Used>=Config.OreReturnAt or b.CanAdd==false) and not Config.OreCleanupActive then
                        Config.OreCleanupActive=true
                        Config.AutoClearTrashPending=Config.AutoClearTrash==true
                        Runtime.AutoClearTrashNextScanAt=0
                        saveConfig()
                        Runtime.Log("ORE_CLEANUP_QUEUED "..Runtime.OreStatusText(b).." reason="..why)
                    end
                end
                -- Auto trash scans eligible recipes in Lobby, independent of bag count.
                if Config.AutoClearTrash then
                    if Runtime.ForgeUncertain or Runtime.AutoClearTrashErrorBlocked then
                        -- Do not re-send any uncertain Forge/Sell. Dungeon may still enter.
                        if os.clock()>(Runtime.LastForgeQuarantineLogAt or 0)+30 then
                            Runtime.LastForgeQuarantineLogAt=os.clock()
                            Runtime.Log("FORGE_QUARANTINED Dungeon/Combat remain enabled")
                        end
                    else
                        if Runtime.AutoClearTrashBlocked then
                            if Runtime.RecheckAutoClearTrashBlocked then Runtime.RecheckAutoClearTrashBlocked() end
                            if Runtime.AutoClearTrashBlocked then return end
                        end
                        if Config.AutoClearTrashPending or os.clock()>=(Runtime.AutoClearTrashNextScanAt or 0) then
                            stage="AutoClearTrash"
                            local forgedAndSold=Runtime.AutoClearTrashStep()
                            if forgedAndSold then return end
                        end
                    end
                end
                if Config.AutoFarm and Config.AutoCreateRole=="Solo" and Config.OreSafetyEnabled then
                    local blocked,bag,reason=Runtime.OreBlocksSoloEntry()
                    if blocked or (Config.AutoClearTrash and Runtime.AutoClearTrashBlocked and not Runtime.AutoClearTrashErrorBlocked and not Runtime.ForgeUncertain) then
                        StatusLbl.Text="Status: Chưa vào Dungeon: "..Runtime.OreStatusText(bag)
                            .." | "..tostring(reason)..(not Config.AutoClearTrash and " | BẬT Auto Clear Trash hoặc dọn thủ công" or "")
                        return
                    end
                end
                if LocalPlayer:GetAttribute("EnterRoomId") then
                    if Config.AutoFarm and not (Config.AutoClearTrash and Runtime.AutoClearTrashBlocked and not Runtime.AutoClearTrashErrorBlocked and not Runtime.ForgeUncertain) and not Runtime.SuppressAutoCreate and Config.AutoCreateRole=="Solo" then
                        stage="CreateRoom"; enterSelectedDungeon()
                    end
                    return
                end
				if Config.AutoEquipBest and EquipRE and not Runtime.ForgeUncertain then
					EquipRE:FireServer("EquipBest", "Weapon")
					EquipRE:FireServer("EquipBest", "Breastplate")
					EquipRE:FireServer("EquipBest", "Helmet")
				end

				if Config.AutoSellEquip and not Runtime.ForgeUncertain then
					stage = "Sell"
					local sold = sellAllUnlockedEquipment()
					if sold > 0 then return end
				end

				if Config.AutoTrashSell and not Runtime.ForgeUncertain then
					stage = "Trash"
					Runtime.TrashStep(false)
					return
				end
				if Config.AutoForge and not Runtime.ForgeUncertain then
					stage = "Forge"
					-- ForgeUtil capacity is ORE capacity, not equipment capacity.
					local nextOre = findNextCraftableOre()
					if nextOre then
						Runtime.ForgeBusy = true
						forgeSingleItem(nextOre.id)
						Runtime.ForgeBusy = false
						return
					end
				end

				if Config.AutoFuseRune then
					stage = "Fuse"
					local fused = tryFuseRunesOnce()
					if fused then return end
				end

				if Config.AutoFarm and not (Config.AutoClearTrash and Runtime.AutoClearTrashBlocked and not Runtime.AutoClearTrashErrorBlocked and not Runtime.ForgeUncertain) and not Runtime.SuppressAutoCreate and Config.AutoCreateRole=="Solo" then
					stage = "CreateRoom"
					enterSelectedDungeon()
					task.wait(2)
				end
			end)
			Runtime.ForgeBusy = false
			isLobbyBusy = false
			if not ok and Runtime.Alive then
				if stage == "Forge" then Config.AutoForge = false end
				if stage == "Trash" then Config.AutoTrashSell=false; Runtime.ProtectPendingForge() end
				if stage == "Sell" then Config.AutoSellEquip = false end
				if stage == "Fuse" then Config.AutoFuseRune = false end
				if stage == "CreateRoom" then
					if isTransitioning() or not GamePlaceUtil:IsMain() or not lobbyCharacterReady() then
						-- A respawn/transition interrupted the attempt. Preserve the user's toggle.
						StatusLbl.Text = "Status: Chờ tải nhân vật/map; Auto vẫn ON..."
					else
                        -- v4.9: transient CreateRoom failure must NOT turn the user's Auto Farm OFF.
                        -- Retry uses existing portalRetry backoff; no repeated Create while pending.
                        retryPortal("Create lỗi; giữ Auto Farm ON")
                        Runtime.Log("AUTO_ENTRY_RETRY " .. tostring(err))
					end
				else
					reportError(stage, err)
				end
			end
		end
	end
end)

table.insert(Runtime.Connections, RunService.Stepped:Connect(function()
	if Runtime.Alive and combatFarmEnabled() and (Runtime.HasCombatTarget or Runtime.UndergroundActive) and not Runtime.Patrolling and not GamePlaceUtil:IsMain() and not isTransitioning() and LocalPlayer.Character then
		for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				if Runtime.Collision[part] == nil then Runtime.Collision[part] = part.CanCollide end
				part.CanCollide = false
			end
		end
	else
		for part, value in pairs(Runtime.Collision) do if part.Parent then part.CanCollide = value end end
		table.clear(Runtime.Collision)
	end
end))

local function getModelRoot(model)
	if not model then return nil end
	return model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Root") or model:FindFirstChildWhichIsA("BasePart", true)
end

local function isAliveEnemy(model)
	if not model or not model.Parent or not model:IsA("Model") then return false end
	if Players:GetPlayerFromCharacter(model) then return false end
	local name = model.Name:lower()
	if name:find("chest") or name:find("egg") or name:find("door") or name:find("portal") then return false end
	local hum = model:FindFirstChildOfClass("Humanoid")
	local hpAttr = model:GetAttribute("HP") or model:GetAttribute("Health")
	if hum then return hum.Health > 0 end
	if type(hpAttr) == "number" then return hpAttr > 0 end
	return false
end

local function getEnemyRoomContext(model, expectedWorld, expectedRoom)
	local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	if not cfg then return true, nil, nil end
	local curWorld = expectedWorld or cfg:GetAttribute("WorldId")
	local curRound = expectedRoom or cfg:GetAttribute("GameRound")
	local curComplete = cfg:GetAttribute("GameRoundComplete")
	local isCleared = (type(curRound) == "number" and curComplete == curRound)
	local node = model
	local objWorld, objRound = nil, nil
	while node and node ~= Workspace do
		local w = node:GetAttribute("WorldId")
		local r = node:GetAttribute("GameRound") or node:GetAttribute("RoomId") or node:GetAttribute("Round")
		if w ~= nil and objWorld == nil then objWorld = w end
		if r ~= nil and objRound == nil then objRound = tonumber(r) or r end
		if objRound == nil then
			local nr = tonumber(node.Name:match("^[Rr]oom_?(%d+)$") or node.Name:match("^[Rr]ound_?(%d+)$"))
			if nr then objRound = nr end
		end
		node = node.Parent
	end
	if objWorld ~= nil and curWorld ~= nil and objWorld ~= curWorld then
		return false, isCleared, "mismatch_world"
	end
	if objRound ~= nil and type(curRound) == "number" and objRound ~= curRound then
		return false, isCleared, "mismatch_room"
	end
	return true, isCleared, (objRound ~= nil and "explicit_room_match" or "no_room_tag")
end

-- v4.9.39: current-room target ranking. Boss metadata is game-dependent;
-- when absent, MaxHealth/MaxHP drives the preference (not remaining HP).
function Runtime.EnemyRankInfo(model)
    if not model then return false, 0 end
    local hum=model:FindFirstChildOfClass("Humanoid")
    local hp=tonumber(model:GetAttribute("MaxHP"))
        or tonumber(model:GetAttribute("MaxHealth"))
        or tonumber(model:GetAttribute("MaxHp"))
    if not hp or hp<=0 then
        hp=math.max(tonumber(model:GetAttribute("HP")) or 0,
            tonumber(model:GetAttribute("Health")) or 0,
            hum and tonumber(hum.MaxHealth) or 0)
    end
    if type(hp)~="number" or hp~=hp or hp<0 or hp==math.huge then hp=0 end
    local boss=false
    for _,name in ipairs({"IsBoss","Boss"}) do
        if model:GetAttribute(name)==true then boss=true; break end
    end
    if not boss then
        for _,name in ipairs({"NpcType","EnemyType","MonsterType","Rank","Type"}) do
            local value=model:GetAttribute(name)
            if type(value)=="string" and value:lower():find("boss",1,true) then boss=true; break end
        end
    end
    if not boss then
        local name=tostring(model.Name):lower()
        boss=name:find("boss",1,true)~=nil
    end
    if not boss then
        local ok,tag=pcall(function() return CollectionService:HasTag(model,"Boss") end)
        boss=ok and tag==true
    end
    return boss,hp
end

local function findNearestEnemy(myPos, ignoreRoomClearGate)
	local closestModel, closestRoot = nil, nil
	local minDist = math.huge
    local bestTier,bestHP=-1,-1
	local candidates = {}

	local enemyTag = GameEnum and GameEnum.HumanTag and GameEnum.HumanTag.EnemyNpc or "EnemyNpc"
	for _, m in ipairs(CollectionService:GetTagged(enemyTag)) do
		candidates[m] = true
	end

	local entityFolder = Workspace:FindFirstChild("Entity")
	if entityFolder then
		for _, desc in ipairs(entityFolder:GetDescendants()) do
			if desc:IsA("Model") then candidates[desc] = true end
		end
	end

	local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	local curRound = cfg and cfg:GetAttribute("GameRound")
	local curComplete = cfg and cfg:GetAttribute("GameRoundComplete")
	local isRoomCleared = (type(curRound) == "number" and curComplete == curRound)
	local activeTransition = Runtime.RouteState and Runtime.RouteState.Active
	local arrivedNewRoom = activeTransition and (activeTransition.Stage == "ARRIVED" or activeTransition.Stage == "WAIT_ROOM_UPDATE" or activeTransition.Stage == "ACTIVATED")

	for model in pairs(candidates) do
		if isAliveEnemy(model) then
			local root = getModelRoot(model)
			if root then
				local dist = (root.Position - myPos).Magnitude
				local validRoom, _, roomSignal = getEnemyRoomContext(model,
					arrivedNewRoom and activeTransition.World or nil,
					arrivedNewRoom and activeTransition.Destination or nil)
				if arrivedNewRoom and activeTransition.CF then
					-- An explicitly wrong World/Room stays rejected even if physically nearby.
					validRoom = validRoom and (roomSignal == "explicit_room_match" or (root.Position - activeTransition.CF.Position).Magnitude <= 140)
				elseif isRoomCleared and not ignoreRoomClearGate then
					if not validRoom then
						validRoom = false
					elseif Runtime.RouteExpected and Runtime.RouteExpected() and not (Runtime.RouteLegacyReady and Runtime.RouteLegacyReady()) then
						validRoom = false
					elseif dist > 110 then
						validRoom = false
					end
				elseif not isRoomCleared then
					-- Explicit mismatched Room tags must not be bypassed by distance.
					validRoom = validRoom and (roomSignal == "explicit_room_match" or dist <= 500)
				end
                if validRoom then
                    local boss,hp=Runtime.EnemyRankInfo(model)
                    -- Do not let a distant, untagged mob from a future room
                    -- steal target solely because its HP is high.
                    local priorityRange=(roomSignal=="explicit_room_match") and 300 or 180
                    local ranked=dist<=priorityRange
                    local tier=ranked and (boss and 2 or hp>0 and 1 or 0) or 0
                    if tier>bestTier
                        or (tier==bestTier and tier>=1 and hp>bestHP*1.025)
                        or (tier==bestTier and (tier==0 or math.abs(hp-bestHP)<=math.max(1,bestHP*.025)) and dist<minDist) then
                        bestTier,bestHP,minDist=tier,hp,dist
                        closestModel,closestRoot=model,root
                    end
                end
			end
		end
	end
	return closestModel, closestRoot
end
local ignoredLoot = setmetatable({}, {__mode = "k"})
local function isValidLoot(obj)
	if not obj or not obj.Parent then return false end
	if (ignoredLoot[obj] or 0) > os.clock() then return false end
	local name = obj.Name:lower()
	if not (name:find("chest") or name:find("egg")) then return false end
	if not getModelRoot(obj) then return false end
	local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
	local hum = obj:FindFirstChildOfClass("Humanoid")
	local hpAttr = obj:GetAttribute("HP") or obj:GetAttribute("Health")
	if prompt and prompt.Enabled then return true end
	if hum then return hum.Health > 0 end
	if type(hpAttr) == "number" then return hpAttr > 0 end
	return obj:IsDescendantOf(Workspace)
end

local function findNearestLoot(myPos)
	local closestLoot, closestRoot = nil, nil
	local minDist = math.huge
	local folders = {Workspace:FindFirstChild("EItem"), Workspace:FindFirstChild("Entity")}
	for _, folder in ipairs(folders) do
		if folder then
			for _, obj in ipairs(folder:GetDescendants()) do
				if obj:IsA("Model") and isValidLoot(obj) then
					local root = getModelRoot(obj)
					if root then
						local dist = (root.Position - myPos).Magnitude
						if dist < minDist then
							minDist = dist
							closestLoot = obj
							closestRoot = root
						end
					end
				end
			end
		end
	end
	return closestLoot, closestRoot
end

-- === v4.9 shared target lock, Bow detection and RedShow adaptive dodge ===
do
local weaponUtilNight = Framework.Modules.WeaponUtil
local bowCache={At=0,Id=nil,Active=false}
local function equippedBow()
    if not Config.BowCombat then return false,nil end
    if os.clock()-bowCache.At < .55 then return bowCache.Active,bowCache.Id end
    bowCache.At=os.clock()
    local id=nil
    local eq=LocalPlayer:FindFirstChild("PlayerEquippedWeapon")
    local override=eq and eq:GetAttribute("BaseAttackReplace")
    if type(override)=="string" and override~="" then id=override end
    if not id and weaponUtilNight then
        local ok,res=pcall(function()
            local wid=weaponUtilNight:GetEquippedWeaponId(LocalPlayer)
            return wid and weaponUtilNight:GetBaseAttackId(wid)
        end)
        if ok and type(res)=="string" then id=res end
    end
    bowCache.Id=id
    bowCache.Active=type(id)=="string" and id:lower():find("bow",1,true)~=nil
    return bowCache.Active,bowCache.Id
end
Runtime.BowMode=false
Runtime.BowBusy=false
Runtime.BowToken=0
Runtime.BowStage=1
Runtime.AimTarget=nil
Runtime.DodgeActive=false
Runtime.DodgeUntil=0
Runtime.HalloweenDodgePosition=nil
Runtime.HalloweenDodgeLastMoveAt=0
Runtime.HalloweenDodgeLastWarnAt=0
Runtime.DodgeCooldownUntil=0
Runtime.DodgeStartHP=nil
Runtime.DodgeWatchAt=0
Runtime.DodgeSkillResumeAt=0
Runtime.SkillCastEpoch=0
Runtime.FlySkillBusy=false
Runtime.FlySkillPosition=nil
Runtime.FlySkillTarget=nil
Runtime.FlySkillToken=0
Runtime.FlySkillResumeAt=0
Runtime.FlySkillLastAttempt={}
local aimBind="IronSoulNightAim_"..tostring(LocalPlayer.UserId)
local aimBound=false
local function releaseNightAim()
    Runtime.AimTarget=nil
    if aimBound then
        pcall(function() RunService:UnbindFromRenderStep(aimBind) end)
        aimBound=false
    end
    -- Smart Target Lock only steers aim/camera; it never toggles game LockView.
    -- Do not hide LDPlayer cursor or override the player's Ctrl / mouse-lock setting.
end
local function nightAimFrame()
    if not Runtime.Alive or not (Config.SmartTargetLock or Config.Aim3DDown) or not combatFarmEnabled() or Runtime.Owner
        or Runtime.RouteBusy or isTransitioning() or GamePlaceUtil:IsMain() then return end
    local t=Runtime.AimTarget
    local c=LocalPlayer.Character
    local root=c and c:FindFirstChild("HumanoidRootPart")
    if not t or not t.Parent or not root or not root.Parent then return end
    local camera=Workspace.CurrentCamera
    if not camera then return end
    local origin=camera.CFrame.Position
    if Config.Aim3DDown then
        -- Exact nadir: independent of target XY. An explicit nonparallel up
        -- axis prevents CFrame.lookAt's singular case when facing straight down.
        camera.CFrame=CFrame.lookAt(origin,origin+Vector3.new(0,-1,0),Vector3.new(0,0,-1))
        return
    end
    local point=t.Position+Vector3.new(0,1.2,0)
    if (point-origin).Magnitude>.5 then
        camera.CFrame=CFrame.lookAt(origin,point)
    end
end
local function ensureNightAim()
    if not (Config.SmartTargetLock or Config.Aim3DDown) then releaseNightAim();return end
    if not aimBound then
        RunService:BindToRenderStep(aimBind,Enum.RenderPriority.Camera.Value+2,nightAimFrame)
        aimBound=true
    end
    -- Deliberately do not SetAttribute("LockView", true): LDPlayer needs its cursor.
end
local function releaseDodge(reason)
    if Runtime.DodgeActive then
        Runtime.Log("DODGE_END "..tostring(reason or "clear"))
        -- Landing grace applies ONLY to low-altitude horizontal skills.
        -- Non-horizontal Q/E/R and downward Scepter G may cast during/after Dodge.
        Runtime.DodgeSkillResumeAt=os.clock()+.45
    end
    Runtime.DodgeActive=false
    Runtime.DodgeUntil=0
    Runtime.DodgeStartHP=nil
    Runtime.HalloweenDodgePosition=nil
end
local function nearRedWarning(root)
    local folder=Workspace:FindFirstChild("RedShow")
    if not folder then return nil end
    for _,obj in ipairs(folder:GetChildren()) do
        if obj:GetAttribute("IsSelf")~=true then
            local part=obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)))
            if part then
                local p=part.Position
                local delta=Vector3.new(root.Position.X-p.X,0,root.Position.Z-p.Z)
                -- Bounding size is approximate, not verified hitbox; add modest buffer.
                local radius=math.max(14,math.sqrt(part.Size.X^2+part.Size.Z^2)*.5+8)
                if delta.Magnitude<=radius and math.abs(root.Position.Y-p.Y)<38 then
                    return obj
                end
            end
        end
    end
    return nil
end
-- Halloween: scan warning FOOTPRINT at any height; altitude does NOT make it safe.
-- This is an approximate visual hazard radius, not the server's actual hitbox.
local function halloweenWarningAt(pos,extra)
    local folder=Workspace:FindFirstChild("RedShow")
    if not folder then return nil end
    local margin=extra or 0
    for _,obj in ipairs(folder:GetChildren()) do
        if obj:GetAttribute("IsSelf")~=true then
            local part=obj:IsA("BasePart") and obj or
                (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)))
            if part then
                local dx,dz=pos.X-part.Position.X,pos.Z-part.Position.Z
                local radius=math.max(14,math.sqrt(part.Size.X^2+part.Size.Z^2)*.5+8)+margin
                if dx*dx+dz*dz <= radius*radius then return obj end
            end
        end
    end
    return nil
end

local function findHalloweenDodgePosition(root,target,warning)
    local folder=Workspace:FindFirstChild("RedShow")
    local char=LocalPlayer.Character
    if not root or not target or not char then return nil end
    local filter={char}
    if folder then table.insert(filter,folder) end
    -- Ignore enemies' colliders when testing the actual walkable floor.
    local npcFolder=Workspace:FindFirstChild("EnemyNpc")
    if npcFolder then table.insert(filter,npcFolder) end
    local targetModel=target:FindFirstAncestorWhichIsA("Model")
    if targetModel then table.insert(filter,targetModel) end
    for _,name in ipairs({"Entity","EItem"}) do
        local f=Workspace:FindFirstChild(name)
        if f then table.insert(filter,f) end
    end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances=filter
    params.IgnoreWater=true
    local warnPart=warning and (warning:IsA("BasePart") and warning or
        (warning:IsA("Model") and (warning.PrimaryPart or warning:FindFirstChildWhichIsA("BasePart",true))))
    local away=warnPart and Vector3.new(root.Position.X-warnPart.Position.X,0,root.Position.Z-warnPart.Position.Z)
        or Vector3.new(root.Position.X-target.Position.X,0,root.Position.Z-target.Position.Z)
    if away.Magnitude<.5 then away=Vector3.new(1,0,0) end
    local baseAngle=math.atan2(away.Z,away.X)
    local start=root.Position
    -- Astral Halloween sidesteps at CONSTANT Y, with a ground ray only as a safety filter.
    -- Do not reset to floor +20; its normal hover is tallest-mob +30.
    local constantY=Config.HalloweenMode -- EVERY mode sidesteps at its current Y
    -- Test rings outside projected hitboxes. Raycast prevents teleporting into void.
    -- Never deliberately dodge 78-96 studs away: that can leave the
    -- Halloween arena and cause 2%% HP loss/sec. Test close rings only.
    local originY=math.max(start.Y,target.Position.Y)+60
    local reference=Workspace:Raycast(Vector3.new(target.Position.X,originY,target.Position.Z),Vector3.new(0,-210,0),params)
    if not reference or not reference.Instance or not reference.Instance.CanCollide or reference.Normal.Y<.70 then return nil end
    local floorY=reference.Position.Y
    local function safeGroundFootprint(x,z)
        -- A center ground ray alone can clip a platform edge. Validate
        -- a full 8-stud footprint, including diagonals, before moving.
        for _,off in ipairs({{0,0},{8,0},{-8,0},{0,8},{0,-8},{6,6},{6,-6},{-6,6},{-6,-6}}) do
            local hit=Workspace:Raycast(Vector3.new(x+off[1],originY,z+off[2]),Vector3.new(0,-210,0),params)
            if not hit or not hit.Instance or not hit.Instance.CanCollide
                or hit.Normal.Y<.70 or math.abs(hit.Position.Y-floorY)>13 then return false end
        end
        return true
    end
    for _,radius in ipairs({20,28,36,44}) do
        for step=0,15 do
            local angle=baseAngle+step*math.pi/8
            local x=start.X+math.cos(angle)*radius
            local z=start.Z+math.sin(angle)*radius
            local sample=Vector3.new(x,start.Y,z)
            local fromTarget=Vector3.new(x-target.Position.X,0,z-target.Position.Z).Magnitude
            -- Conservative arena leash. If no safe spot exists, hold at the
            -- current position rather than jumping outside the play area.
            if fromTarget<=52 and not halloweenWarningAt(sample,12)
                and safeGroundFootprint(x,z) then
                local rayOrigin=Vector3.new(x,math.max(start.Y,target.Position.Y)+55,z)
                local hit=Workspace:Raycast(rayOrigin,Vector3.new(0,-190,0),params)
                if hit and hit.Instance and hit.Instance.CanCollide and hit.Normal.Y>.65
                    and math.abs(hit.Position.Y-(start.Y-(constantY and 30 or 20)))<=(constantY and 90 or 48) then
                    -- Astral Halloween: keep the CURRENT height exactly, no extra climb.
                    local safe=Vector3.new(x,constantY and start.Y or (hit.Position.Y+20),z)
                    if not halloweenWarningAt(safe,12) and (Vector3.new(safe.X-target.Position.X,0,safe.Z-target.Position.Z)).Magnitude<=52 then
                        return safe
                    end
                end
            end
        end
    end
    return nil
end

local function tickNightDodge()
    local now=os.clock()
    if now-Runtime.DodgeWatchAt < .10 then return end
    Runtime.DodgeWatchAt=now
    if Config.UndergroundHover then
        if Runtime.DodgeActive then releaseDodge("Underground owns hover") end
        return
    end
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    -- Bow now hovers +20; do NOT disable SmartDodge just because Bow is active.
    -- User-tested emergency hover +30 preserves mob aggro better than +60.
    local enabled=Runtime.Alive and Config.SmartDodge and combatFarmEnabled()
        and not Runtime.Owner and not Runtime.RouteBusy and not Runtime.DeathRecovery
        and not GamePlaceUtil:IsMain() and not isTransitioning() and root and hum and hum.Health>0
        and Runtime.HoverTarget and Runtime.HoverTarget.Parent
    if not enabled then
        if Runtime.DodgeActive then releaseDodge("not in combat") end
        return
    end
    -- A tall Elite can hit our character even when hovering over a short mob.
    -- Damage MUST NOT disable safety movement for twelve seconds.
    if Runtime.DodgeActive and hum.Health < (Runtime.DodgeStartHP or hum.Health)-.01 then
        Runtime.DodgeStartHP=hum.Health
        Runtime.DodgeUntil=math.max(Runtime.DodgeUntil,now+1.0)
        Runtime.Log("DODGE_HP_LOSS keep dodging; no cooldown lockout")
    end
    -- Halloween watches the intended target-hover footprint AS WELL as our
    -- current location. Otherwise, after sidestepping, Hover immediately
    -- pulls the character back into the still-active danger zone.
    local warning
    if Config.HalloweenMode then
        local targetPos=Runtime.HoverTarget.Position
        warning=halloweenWarningAt(root.Position,3)
            or halloweenWarningAt(targetPos,3)
        if Runtime.FlySkillBusy and Runtime.FlySkillPosition then
            warning=warning or halloweenWarningAt(Runtime.FlySkillPosition,3)
        end
    else
        local useGroundProbe=(Runtime.DodgeActive or Config.AutoCombatPresetEnabled
            or Config.ScepterCombat or Runtime.BowMode
            or (Runtime.OrbitEnabled and Runtime.OrbitEnabled()))
            and not Runtime.FlySkillBusy
        local probe=useGroundProbe and Vector3.new(root.Position.X,(Runtime.HoverTarget.Position.Y+8),root.Position.Z) or root.Position
        warning=nearRedWarning({Position=probe})
    end
    -- Normal Range/Astral already at +30: do NOT perform a redundant
    -- dodge. Lower cast attempts independently verify RedShow near the floor.
    -- Melee +12 can still rise to +30. Halloween uses lateral-only dodge.
    if warning and not Config.HalloweenMode and Config.HoverHeight>=29 then
        local top=tonumber(Runtime.HoverAnchorTopY)
        if top and root.Position.Y >= top+27 then
            if Runtime.DodgeActive then releaseDodge("already +30") end
            return
        end
    end
    if warning then
        if not Runtime.DodgeActive then
            Runtime.DodgeActive=true
            Runtime.DodgeStartHP=hum.Health
            Runtime.SkillCastEpoch=Runtime.SkillCastEpoch+1
            Runtime.Log("DODGE_START red="..warning.Name..(Config.HalloweenMode
                and " HALLOWEEN_LATERAL CONSTANT_Y" or " +30").." | HORIZONTAL_DEFERRED; HIGH_CASTS_CONTINUE")
        end
        if Runtime.FlySkillBusy then
            -- Stop an unsafe horizontal cast; ordinary mode rises, Halloween sidesteps.
            Runtime.FlySkillToken=Runtime.FlySkillToken+1
            Runtime.FlySkillBusy=false
            Runtime.FlySkillPosition=nil
            Runtime.FlySkillTarget=nil
            -- The canceled horizontal worker may still be closing stage1.
            -- Brief shared safety gap prevents a high cast from overlapping it.
            Runtime.FlySkillResumeAt=math.max(Runtime.FlySkillResumeAt or 0,now+.30)
            Runtime.Log("FLY_SKILL_ABORT: warning during horizontal cast")
        end
        if Config.HalloweenMode then
            local safe=Runtime.HalloweenDodgePosition
            if (not safe or halloweenWarningAt(safe,9) or
                (Vector3.new(safe.X-Runtime.HoverTarget.Position.X,0,
                    safe.Z-Runtime.HoverTarget.Position.Z)).Magnitude>52)
                and now-(Runtime.HalloweenDodgeLastMoveAt or 0)>=.28 then
                Runtime.HalloweenDodgeLastMoveAt=now
                safe=findHalloweenDodgePosition(root,Runtime.HoverTarget,warning)
                Runtime.HalloweenDodgePosition=safe
                if safe then
                    Runtime.Log("HALLOWEEN_DODGE_SIDE safe="..tostring(safe))
                elseif now-(Runtime.HalloweenDodgeLastWarnAt or 0)>4 then
                    Runtime.HalloweenDodgeLastWarnAt=now
                    Runtime.Log("HALLOWEEN_DODGE_NO_GROUND_SAFE_POINT; hold, do not teleport into void")
                end
            end
        end
        Runtime.DodgeUntil=now+(Config.HalloweenMode and .45 or 1.0)
    elseif Runtime.DodgeActive and now >= Runtime.DodgeUntil then
        releaseDodge("RedShow disappeared")
    end
end
Runtime.NearRedWarning=nearRedWarning
Runtime.CleanupNightCombat=function()
    if Runtime.CancelLaser then pcall(Runtime.CancelLaser,"combat cleanup") end
    Runtime.FlySkillToken=Runtime.FlySkillToken+1
    Runtime.FlySkillBusy=false
    Runtime.FlySkillPosition=nil
    Runtime.FlySkillTarget=nil
    Runtime.BowToken=Runtime.BowToken+1
    Runtime.BowBusy=false
    Runtime.BowMode=false
    Runtime.SkillCastEpoch=Runtime.SkillCastEpoch+1
    releaseNightAim()
    releaseDodge("script stopped")
    pcall(function() PlayerActionRE:FireServer("SkillAction","BaseAttack") end)
end
Runtime.NightEquippedBow=equippedBow
Runtime.NightWeaponUtil=weaponUtilNight
Runtime.NightTickDodge=tickNightDodge
Runtime.NightReleaseDodge=releaseDodge
Runtime.NightReleaseAim=releaseNightAim
Runtime.NightEnsureAim=ensureNightAim
-- Turn the experimental Bow stage scheduling OFF immediately when user toggles it.
Runtime.ToggleGuards.BowCombat=function(enabling)
    if not enabling then
        Runtime.BowToken=Runtime.BowToken+1
        Runtime.BowBusy=false
        Runtime.BowMode=false
        pcall(function()PlayerActionRE:FireServer("SkillAction","BaseAttack")end)
    end
end
end -- v4.9 shared helper scope
-- Protect the regular target position, then let HoverCombat choose the right height.
local function teleportOnceToTarget(myChar, myRoot, myHum, targetRoot)
	local tPos = targetRoot.Position
	local lookDir = targetRoot.CFrame.LookVector
	local flatLook = Vector3.new(lookDir.X, 0, lookDir.Z)
	flatLook = (flatLook.Magnitude < 0.01) and Vector3.new(0, 0, 1) or flatLook.Unit
	local standPos = Vector3.new(tPos.X, tPos.Y, tPos.Z) - (flatLook * 2.5)
	myRoot.AssemblyLinearVelocity = Vector3.zero
	myRoot.AssemblyAngularVelocity = Vector3.zero
	myChar:PivotTo(CFrame.lookAt(standPos, Vector3.new(tPos.X, standPos.Y, tPos.Z)))
	if myHum:GetState() == Enum.HumanoidStateType.Freefall then
		myHum:ChangeState(Enum.HumanoidStateType.Running)
	end
end

-- Safely measure the actual body top; HRP alone underestimates Elite height.
local hoverTopCache={At=0,Base=nil,Anchor=nil,Top=nil,Height=0}
local function modelTop(model,root)
    local top=root.Position.Y+3
    local height=6
    if model and model:IsA("Model") then
        local ok,cf,size=pcall(function() return model:GetBoundingBox() end)
        if ok and cf and size then
            height=math.clamp(size.Y,2,75)
            -- Cap exaggerated FX/weapon bounding boxes to avoid flying into ceilings.
            top=math.clamp(cf.Position.Y+size.Y*.5,root.Position.Y+2,root.Position.Y+50)
        end
    end
    return top,height
end
local function chooseTallestHover(base)
    local now=os.clock()
    if now-hoverTopCache.At<.28 and hoverTopCache.Base==base
        and hoverTopCache.Anchor and hoverTopCache.Anchor.Parent then
        return hoverTopCache.Anchor,hoverTopCache.Top,hoverTopCache.Height
    end
    hoverTopCache.At,hoverTopCache.Base=now,base
    local model=base:FindFirstAncestorWhichIsA("Model")
    local top,height=modelTop(model,base)
    local anchor=base
    local enemyTag=GameEnum and GameEnum.HumanTag and GameEnum.HumanTag.EnemyNpc or "EnemyNpc"
    for _,enemy in ipairs(CollectionService:GetTagged(enemyTag)) do
        if isAliveEnemy(enemy) and getEnemyRoomContext(enemy) then
            local er=getModelRoot(enemy)
            if er and er.Parent and (Vector3.new(er.Position.X-base.Position.X,0,er.Position.Z-base.Position.Z)).Magnitude<=62 then
                local et,eh=modelTop(enemy,er)
                if eh>height+1 or (math.abs(eh-height)<=1 and et>top) then
                    anchor,top,height=er,et,eh
                end
            end
        end
    end
    hoverTopCache.Anchor,hoverTopCache.Top,hoverTopCache.Height=anchor,top,height
    return anchor,top,height
end
do
Runtime.OrbitModuleInit=function()
-- === v4.9.31 OPT-IN ASTRAL ORBIT PULL -> BURST (no invented Remote protocol). ===
-- Altitude is relative to highest enemy top, preserving the user's tested geometry.
-- The old Staff_Atk2 S5 and beam workers are bypassed by requiring ScepterCombat OFF.
Runtime.OrbitPhase="IDLE"
Runtime.OrbitState={}
Runtime.OrbitUsedSlots={}
function Runtime.OrbitEnabled()
    return Config.AstralOrbitCombat==true and Config.ScepterCombat~=true
        and not Runtime.NightEquippedBow()
end
function Runtime.OrbitLuring()
    return Runtime.OrbitEnabled() and Runtime.OrbitPhase=="LURE"
end
function Runtime.OrbitReset(reason)
    if Runtime.OrbitPhase~="IDLE" and Runtime.Alive then
        Runtime.Log("ASTRAL_ORBIT_RESET "..tostring(reason or "state changed"))
    end
    Runtime.OrbitPhase="IDLE"
    Runtime.OrbitState={}
    Runtime.OrbitUsedSlots={}
end
local function orbitRoomStamp()
    local cfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
    if not cfg then return "none" end
    return tostring(cfg:GetAttribute("WorldId"))..":"..tostring(cfg:GetAttribute("GameRound"))
end
local function orbitScan(targetRoot)
    -- One bounded NPC scan every 0.23s, never on every heartbeat.
    local p=targetRoot.Position
    local sumX,sumZ,total=0,0,0
    local tag=GameEnum and GameEnum.HumanTag and GameEnum.HumanTag.EnemyNpc or "EnemyNpc"
    local roots={}
    for _,mob in ipairs(CollectionService:GetTagged(tag)) do
        if isAliveEnemy(mob) and getEnemyRoomContext(mob) then
            local eRoot=getModelRoot(mob)
            if eRoot and eRoot.Parent then
                local ep=eRoot.Position
                local dx,dz=ep.X-p.X,ep.Z-p.Z
                if dx*dx+dz*dz<=58*58 then
                    total=total+1
                    sumX=sumX+ep.X
                    sumZ=sumZ+ep.Z
                    roots[#roots+1]=eRoot
                end
            end
        end
    end
    if total==0 then return p,0,0 end
    local center=Vector3.new(sumX/total,p.Y,sumZ/total)
    local near=0
    for _,eRoot in ipairs(roots) do
        local ep=eRoot.Position
        local dx,dz=ep.X-center.X,ep.Z-center.Z
        if dx*dx+dz*dz<=19*19 then near=near+1 end
    end
    return center,total,near
end
local function orbitStartPhase(state,phase,now,reason)
    Runtime.OrbitPhase=phase
    state.PhaseSince=now
    state.GroupedSince=nil
    if phase=="BURST" then
        Runtime.OrbitUsedSlots={}
        state.BurstStart=now
        state.BurstCompleted=0
    else
        -- No new skill/attack request while lure walking; honor in-flight cast locks.
        Runtime.OrbitUsedSlots={}
        if Runtime.NightReleaseAim then Runtime.NightReleaseAim() end
    end
    Runtime.Log(string.format("ASTRAL_ORBIT_%s nearby=%d tight=%d reason=%s",
        phase,state.Total or 0,state.Near or 0,tostring(reason)))
end
local function orbitHover(target,tallest,topY,char,root)
    if not Runtime.OrbitEnabled() then return false end
    local now=os.clock()
    local state=Runtime.OrbitState
    local stamp=orbitRoomStamp()
    if Runtime.OrbitPhase=="IDLE" or state.Room~=stamp or state.Char~=char then
        state={Room=stamp,Char=char,Angle=0,Total=0,Near=0,
            Center=Vector3.new(target.Position.X,target.Position.Y,target.Position.Z),
            LastScanAt=-100,LastMoveAt=now,LastMoveTick=0}
        Runtime.OrbitState=state
        orbitStartPhase(state,"LURE",now,"new room/character")
    end
    if now-(state.LastScanAt or -100)>.23 then
        state.LastScanAt=now
        local center,total,near=orbitScan(target)
        state.Total,state.Near=total,near
        if total>0 then
            -- Smooth center as mobs chase; avoid snapping around small changes.
            if state.Center then
                state.Center=Vector3.new(
                    state.Center.X+(center.X-state.Center.X)*.30,
                    center.Y,
                    state.Center.Z+(center.Z-state.Center.Z)*.30)
            else
                state.Center=center
            end
        end
    end
    local center=state.Center or target.Position
    local elapsed=now-(state.PhaseSince or now)
    local tight=state.Total>=3 and state.Near>=3
        and (state.Near/math.max(state.Total,1))>=.60
    if Runtime.OrbitPhase=="LURE" then
        if tight then state.GroupedSince=state.GroupedSince or now
        else state.GroupedSince=nil end
        local groupReady=state.GroupedSince and now-state.GroupedSince>=.60 and elapsed>=1.4
        local fewMobs=state.Total<=2 and state.Total>0 and elapsed>=.85
        local timeout=elapsed>=Config.AstralOrbitPullSeconds
        local safeToBurst=not Runtime.QERStageBusy and not Runtime.FlySkillBusy
            and not Runtime.ScepterGStageBusy and not Runtime.DodgeActive
        if safeToBurst and (groupReady or fewMobs or timeout) then
            orbitStartPhase(state,"BURST",now,groupReady and "grouped"
                or fewMobs and "few mobs" or "pull timeout")
        end
    elseif Runtime.OrbitPhase=="BURST" then
        local held=elapsed>=Config.AstralOrbitBurstSeconds
        local castIdle=not Runtime.QERStageBusy and not Runtime.FlySkillBusy
            and not Runtime.ScepterGStageBusy and not Runtime.LaserActive
        -- Do not waste time re-pulling a single remaining mob; continue casting.
        if held and castIdle and not Runtime.DodgeActive and state.Total>=3 then
            orbitStartPhase(state,"LURE",now,"burst cycle ended")
        end
    end
    if Runtime.OrbitPhase=="LURE" and not Runtime.DodgeActive then
        -- 3.5s/revolution; throttle PivotTo to ~14Hz to reduce physics jitter.
        if now-(state.LastMoveTick or 0)<.065 then return true end
        local dt=math.clamp(now-(state.LastMoveAt or now),0,.16)
        state.LastMoveAt=now
        state.LastMoveTick=now
        state.Angle=(state.Angle+dt*(math.pi*2/3.5))%(math.pi*2)
        local radius=Config.AstralOrbitRadius
        local p=Vector3.new(center.X+math.cos(state.Angle)*radius,
            topY+12,center.Z+math.sin(state.Angle)*radius)
        local direction=Vector3.new(center.X,p.Y,center.Z)
        if (direction-p).Magnitude<.1 then direction=p+Vector3.new(0,0,-1) end
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
        char:PivotTo(CFrame.lookAt(p,direction))
        return true
    end
    -- BURST +30: lock XZ above crowd instead of chasing one moving enemy.
    -- A RedShow during LURE temporarily raises to +30, no new attacks until BURST.
    local altitude=30
    local p=Vector3.new(center.X,topY+altitude,center.Z)
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    if Config.Aim3DDown then
        char:PivotTo(CFrame.lookAt(p,p+Vector3.new(0,-1,0),Vector3.new(0,0,-1)))
    else
        local look=Vector3.new(target.Position.X,p.Y,target.Position.Z)
        if (look-p).Magnitude<.1 then look=p+Vector3.new(0,0,-1) end
        char:PivotTo(CFrame.lookAt(p,look))
    end
    return true
end
-- === end Astral Orbit state machine ===


Runtime.OrbitHover=orbitHover
end
Runtime.OrbitModuleInit()
Runtime.OrbitModuleInit=nil
end
-- v4.9.50 underground movement: floor raycast excludes the current target model.
-- This cannot bypass server damage checks; exit safely on toggle-off/target loss.
;(function()
    function Runtime.ExitUnderground(reason, skipSurfaceTeleport)
        if not Runtime.UndergroundActive then return end
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local saved=Runtime.UndergroundSavedCF
        local nearbySurface=Runtime.UndergroundSafePos
        Runtime.UndergroundActive=false
        Runtime.UndergroundSavedCF=nil
        Runtime.UndergroundSafePos=nil
        Runtime.UndergroundProbe=nil
        Runtime.UndergroundNoTargetAt=nil
        Runtime.UndergroundNoFloorAt=nil
        Runtime.UndergroundLastCF=nil
        if not skipSurfaceTeleport and char and root and hum and hum.Health>0
            and not Runtime.RouteBusy and not Runtime.Owner
            and not GamePlaceUtil:IsMain() and not isTransitioning() then
            local dest=saved or CFrame.new(root.Position+Vector3.new(0,14,0))
            -- If the target moved far since entry, return above CURRENT floor,
            -- not to a stale location in a different part of the map.
            if nearbySurface and saved then
                local old=saved.Position
                local deltaXZ=Vector3.new(old.X-nearbySurface.X,0,old.Z-nearbySurface.Z)
                if deltaXZ.Magnitude>35 then dest=CFrame.new(nearbySurface) end
            end
            -- Keep collision disabled until next Stepped restores it after rescue.
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if Runtime.Collision[part]==nil then Runtime.Collision[part]=part.CanCollide end
                    part.CanCollide=false
                end
            end
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            char:PivotTo(dest)
        end
        Runtime.Log("UNDERGROUND_EXIT "..tostring(reason or "unknown"))
    end
    function Runtime.TryUndergroundHover(target,char,root,hum)
        if not Config.UndergroundHover then return false end
        if not (target and target.Parent and hum.Health>0) then
            -- v50f: Do not expose the player above ground when a mob dies.
            -- Route/Lobby/death handoff is managed by updateHover, never here.
            if Runtime.UndergroundActive and hum.Health>0 then
                Runtime.UndergroundNoTargetAt=Runtime.UndergroundNoTargetAt or os.clock()
                if Runtime.UndergroundLastCF then
                    root.AssemblyLinearVelocity=Vector3.zero
                    root.AssemblyAngularVelocity=Vector3.zero
                    char:PivotTo(Runtime.UndergroundLastCF)
                end
            end
            return true
        end
        Runtime.UndergroundNoTargetAt=nil
        -- No other Combat Mode, Orbit, Fly/Descent or lateral Dodge may own
        -- CFrame while UndergroundHover is enabled.
        if Runtime.FlySkillBusy and Runtime.CancelFlySkill then
            Runtime.CancelFlySkill("Underground movement priority")
        end
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        local excluded={char,target.Parent}
        params.FilterDescendantsInstances=excluded
        local cache=Runtime.UndergroundProbe
        local now=os.clock()
        local floorY
        local freshFloorY
        if cache and now-cache.At<.18 and (cache.AtPos-target.Position).Magnitude<2.5 then
            floorY=cache.Y
        else
            local begin=target.Position+Vector3.new(0,45,0)
            local hit=Workspace:Raycast(begin,Vector3.new(0,-135,0),params)
            if hit and hit.Normal.Y>.55
                and (hit.Instance:IsA("Terrain") or hit.Instance.CanCollide)
                and hit.Position.Y<=target.Position.Y+2
                and math.abs(target.Position.Y-hit.Position.Y)<=65 then
                floorY=hit.Position.Y
                freshFloorY=floorY -- Only a fresh raycast may refresh the cache timestamp.
            end
        end
        -- Floor can flicker when the boss moves or level geometry streams.
        -- Reuse a recent, nearby valid hit instead of immediately popping above ground.
        if floorY and cache and Runtime.UndergroundActive
            and (Vector3.new(cache.AtPos.X-target.Position.X,0,cache.AtPos.Z-target.Position.Z)).Magnitude<15
            and math.abs(cache.Y-floorY)>9 then
            floorY=nil -- Reject sudden floor-level switches on nearby target.
        end
        if not floorY and cache and now-cache.At<1.8 then
            local dx=cache.AtPos.X-target.Position.X
            local dz=cache.AtPos.Z-target.Position.Z
            if dx*dx+dz*dz<20*20 then floorY=cache.Y end
        end
        -- Keep the cache on the LAST ACCEPTED fresh raycast, not the rejected
        -- nearby platform, or a level-switch can stick for subsequent frames.
        if floorY and freshFloorY and floorY==freshFloorY then
            Runtime.UndergroundProbe={At=now,AtPos=target.Position,Y=floorY}
        end
        if not floorY then
            if Runtime.UndergroundActive then
                Runtime.UndergroundNoFloorAt=Runtime.UndergroundNoFloorAt or now
                if Runtime.UndergroundLastCF then
                    root.AssemblyLinearVelocity=Vector3.zero
                    root.AssemblyAngularVelocity=Vector3.zero
                    char:PivotTo(Runtime.UndergroundLastCF)
                end
            end
            if os.clock()-(Runtime.LastUndergroundLogAt or 0)>5 then
                Runtime.LastUndergroundLogAt=os.clock()
                Runtime.Log("UNDERGROUND_SKIP no reliable ground below target")
            end
            return true
        end
        Runtime.UndergroundNoFloorAt=nil
        local depth=math.clamp(tonumber(Config.UndergroundDepth) or 8,4,20)
        local pos=Vector3.new(target.Position.X,floorY-depth,target.Position.Z)
        if not Runtime.UndergroundActive then
            -- If re-entering after a route/loot movement from below ground,
            -- store a valid above-floor rescue point rather than an underground CF.
            Runtime.UndergroundSavedCF=(root.Position.Y < floorY+1)
                and CFrame.new(root.Position.X,floorY+8,root.Position.Z)
                or char:GetPivot()
            Runtime.Log(string.format("UNDERGROUND_ENTER groundY=%.2f depth=%.1f",floorY,depth))
        end
        Runtime.UndergroundActive=true
        Runtime.UndergroundSafePos=Vector3.new(pos.X,floorY+10,pos.Z)
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                if Runtime.Collision[part]==nil then Runtime.Collision[part]=part.CanCollide end
                part.CanCollide=false
            end
        end
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
        -- Look UP toward the actual target, never use Aim3DDown while underground.
        local aim=target.Position
        if (aim-pos).Magnitude<1 then aim=pos+Vector3.new(0,1,0) end
        local belowCF=CFrame.lookAt(pos,aim)
        Runtime.UndergroundLastCF=belowCF
        char:PivotTo(belowCF)
        return true
    end
end)()
local function updateHover()
    if Config.AutoCombatPresetEnabled and Config.CombatMode=="CLONE" and not Config.UndergroundHover then return end
    local target=Runtime.HoverTarget
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not (Runtime.Alive and not Runtime.Owner and not Runtime.RouteBusy
        and combatFarmEnabled() and root and hum and hum.Health>0
        and not Runtime.DeathRecovery and not GamePlaceUtil:IsMain()
        and not isTransitioning()) then
        if Runtime.UndergroundActive and Runtime.ExitUnderground then
            local handoff=Runtime.RouteBusy or Runtime.Owner or Runtime.DeathRecovery
                or GamePlaceUtil:IsMain() or isTransitioning()
            Runtime.ExitUnderground("combat unavailable", handoff)
        end
        return
    end
    if Config.UndergroundHover then
        Runtime.TryUndergroundHover(target,char,root,hum)
        return
    elseif Runtime.UndergroundActive then
        Runtime.ExitUnderground("mode OFF")
    end
    if Runtime.FlySkillBusy and not Runtime.DodgeActive then
        local cast=Runtime.FlySkillPosition
        local aiming=Runtime.FlySkillTarget
        if cast and aiming and aiming.Parent then
            -- Hold horizontal firing altitude until the projectile is released.
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            local t=aiming.Position
            local dir=Runtime.GetSkillCastDirection and Runtime.GetSkillCastDirection(Runtime.FlySkillSlot or "Skill1")
            local look=dir=="HORIZONTAL" and Vector3.new(t.X,cast.Y,t.Z) or t
            if (look-cast).Magnitude<.1 then look=cast+Vector3.new(0,0,-1) end
            char:PivotTo(CFrame.lookAt(cast,look))
        end
        return
    end
    if Config.HalloweenMode and Runtime.DodgeActive then
        local safe=Runtime.HalloweenDodgePosition
        -- Hold the lateral safe position until the RedShow clears; do not
        -- teleport back above the Boss while its warning is still active.
        if safe then
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            local look=target and target.Parent and target.Position or (safe+Vector3.new(0,0,-1))
            if (Vector3.new(look.X,0,look.Z)-Vector3.new(safe.X,0,safe.Z)).Magnitude<.1 then
                look=safe+Vector3.new(0,0,-1)
            end
            char:PivotTo(CFrame.lookAt(safe,Vector3.new(look.X,safe.Y,look.Z)))
        end
        return
    end
    if not (target and target.Parent and (Config.HoverCombat or Runtime.BowMode or Runtime.DodgeActive)) then return end
    local tallest,topY=chooseTallestHover(target)
    Runtime.HoverAnchor=tallest
    Runtime.HoverAnchorTopY=topY
    if Runtime.OrbitHover(target,tallest,topY,char,root) then return end
    local height=math.clamp(tonumber(Config.HoverHeight) or 12,4,30)
    if Config.AutoCombatPresetEnabled then
        -- CombatMode owns altitude: MELEE +12, RANGE/ASTRAL +30.
        height=((Config.CombatMode=="MELEE" or Config.CombatMode=="CLONE")) and 12 or 30
    elseif Runtime.BowMode then
        height=20 -- legacy manual Bow profile
    elseif Config.ScepterCombat then
        height=30
    end
    if Config.HalloweenMode then
        -- Halloween dodge NEVER changes the selected mode altitude.
        -- RANGE/ASTRAL remain +30; MELEE remains +12, then sidestep laterally.
        height=((Config.CombatMode=="MELEE" or Config.CombatMode=="CLONE")) and 12 or 30
    elseif Runtime.DodgeActive and Config.SmartDodge then
        height=math.max(height,30) -- user-tested dodge height; not a guarantee vs every Boss
    end
    -- MELEE M1 hover is relative to the chosen enemy's HumanoidRootPart,
    -- NOT the giant model's top. This prevents an oversized boss from
    -- forcing M1 to fly far above its effective hitbox. Descent skill
    -- positions are still owned by Q/E/R/G controls and can override this.
    local meleeRootHover=Config.AutoCombatPresetEnabled and Config.CombatMode=="MELEE"
    if meleeRootHover and not Runtime.DodgeActive then height=10 end
    local anchor=meleeRootHover and target or tallest
    local baseY=meleeRootHover and target.Position.Y or topY
    local p=Vector3.new(anchor.Position.X,baseY+height,anchor.Position.Z)
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    if Config.Aim3DDown then
        -- A real 90-degree nose-down cast, not lookAt(enemy) which tilts
        -- unpredictably when standing on top of the target.
        char:PivotTo(CFrame.lookAt(p,p+Vector3.new(0,-1,0),Vector3.new(0,0,-1)))
    else
        local look=target.Position
        local flat=Vector3.new(look.X,p.Y,look.Z)
        if (flat-p).Magnitude<.15 then flat=p+Vector3.new(0,0,-1) end
        char:PivotTo(CFrame.lookAt(p,flat))
    end
end
table.insert(Runtime.Connections, RunService.Heartbeat:Connect(function()
    if Runtime.Alive then
        Runtime.NightTickDodge()
        updateHover()
    end
end))

local function canCastSkill(slot)
	local eqWpn = LocalPlayer:FindFirstChild("PlayerEquippedWeapon")
	if not eqWpn then return true end
	if slot == "SkillU" then
		local maxC = eqWpn:GetAttribute("MaxCharge")
		local curC = eqWpn:GetAttribute("SkillCharge") or 0
		if maxC and curC < maxC then return false end
	end
	local lastTs = eqWpn:GetAttribute(slot .. "LastTs")
	if lastTs and Workspace:GetServerTimeNow() < lastTs then return false end
	return true
end


-- === v4.9.23 Dynamic Skill Phase Resolver (all equipped weapons / Scroll G). ===
-- IDs are resolved from the actual equipped Weapon + active skill tree / Scroll.
-- No guessed Stage2 for a one-stage skill, and no silent skips for missing IDs.
Runtime.SkillProfileCache={}
Runtime.SkillProfileWarnAt={}
Runtime.SkillProfileChanges=0
Runtime.SkillPhaseRequests={}
local skillResolverSlots={BaseAttack=true,Skill1=true,Skill2=true,SkillU=true,SkillAW=true}
local function skillResolverWarning(slot,reason)
    local now=os.clock()
    if now-(Runtime.SkillProfileWarnAt[slot] or -1000)>=8 then
        Runtime.SkillProfileWarnAt[slot]=now
        Runtime.Log("SKILL_RESOLVE_SKIP "..tostring(slot).." "..tostring(reason))
    end
end
function Runtime.ResolveSkillProfile(slot,force)
    if not skillResolverSlots[slot] then return nil end
    local cache=Runtime.SkillProfileCache[slot]
    local now=os.clock()
    if not force and cache and now-cache.At<.40 then return cache.Profile end
    local ok,profile,reason=pcall(function()
        local util=Runtime.NightWeaponUtil or Framework.Modules.WeaponUtil
        if not util then return nil,"WeaponUtil unavailable" end
        local w=util:GetEquippedWeaponId(LocalPlayer)
        if not w then return nil,"no equipped weapon" end
        local skillId=util:GetWeaponSkillId(LocalPlayer,w,slot)
        if type(skillId)~="string" or skillId=="" then
            return nil,"no equipped skill in slot"
        end
        local def=util:GetSkillInfo(skillId)
        if type(def)~="table" then return nil,"ResSkill missing "..skillId end
        local stages,phaseNumbers,stageIds={}, {}, {}
        local seenGap=false
        for i=1,10 do
            local stageId=def["Stage"..i]
            if type(stageId)=="string" and stageId~="" then
                if seenGap then return nil,"non-contiguous stages in "..skillId end
                local cfg=util:GetSkillStageInfo(stageId)
                if type(cfg)~="table" then
                    return nil,"ResSkillStage missing "..stageId.." ("..skillId..")"
                end
                phaseNumbers[#phaseNumbers+1]=i
                stageIds[#stageIds+1]=stageId
                stages[#stages+1]=cfg
            else
                seenGap=true
            end
        end
        if #stages==0 then return nil,"no configured phases in "..skillId end
        return {Id=skillId,WeaponId=w,Slot=slot,Stages=stages,
            Phases=phaseNumbers,StageIds=stageIds,Count=#stages,
            CD=tonumber(def.CD),Charge=tonumber(def.Charge)}
    end)
    if not ok then reason="WeaponUtil lookup error: "..tostring(profile); profile=nil end
    if profile==nil then skillResolverWarning(slot,reason or "unknown") end
    if cache and cache.Profile and profile and
        (cache.Profile.Id~=profile.Id or cache.Profile.WeaponId~=profile.WeaponId) then
        Runtime.SkillProfileChanges=Runtime.SkillProfileChanges+1
        Runtime.Log("SKILL_CHANGED "..slot.." "..cache.Profile.Id.." -> "..profile.Id.." ("..profile.Count.." phases)")
    end
    Runtime.SkillProfileCache[slot]={At=now,Profile=profile,Reason=reason}
    return profile
end
function Runtime.SkillCastPhases(slot)
    local p=Runtime.ResolveSkillProfile(slot)
    return p and p.Phases or nil
end
-- A stage's DamageTimes is NOT the number of remote requests. Hold long
-- multi-hit stages only when Time/HitTime/DamageStep/ActEndTime agree enough
-- to make the intended span plausible; otherwise preserve fast .10s protocol.
function Runtime.SkillPhaseDelay(profile,index)
    if not profile then return .10 end
    -- v4.9.42: Rush is per CURRENT skill slot, never the retired global flag.
    -- Only enabled in the actual ASTRAL RASTAR preset, not when other weapons
    -- share the generic SkillPhaseDelay helper. Do not manufacture/omit stages.
    if Config.AutoCombatPresetEnabled and Runtime.ActiveCombatMode=="ASTRAL"
        and Config.AstralSkillPriority then
        if profile.Slot=="Skill1" and Config.AstralRushQ then return .12 end
        if profile.Slot=="Skill2" and Config.AstralRushE then return .10 end
        if profile.Slot=="SkillU" and Config.AstralRushR then return .15 end
        if profile.Slot=="SkillAW" and Config.AstralRushG then return .08 end
    end
    if Config.AstralSkillPriority and profile.Id=="Staff_Rastar_Skill_Backflip" then
        -- OFF: preserve the normal 0.50s hold so persistent multi-hits can run.
        return .50
    elseif Config.AstralSkillPriority and profile.Id=="Staff_Rastar_Skill_StarFall" then
        -- 7 hits at .01s after a .1s HitTime => earliest last tick ~.16s.
        return .20
    elseif Config.AstralSkillPriority and profile.Id=="Staff_Rastar_Skill_Ult_FinalAct" then
        -- OFF: preserve multi-hit hold; ON Rush R uses the slot override above.
        -- Phase 3 has 9 hits: HitTime=.5 plus 8*.5 =4.5s.
        -- Keep it long by default; other stages are tested as persistent.
        if index==3 then return 4.65 end
        if index==4 then return .70 end
        return .20
    end
    if not Config.DynamicHoldMultiHit then return .10 end
    local stage=profile.Stages[index]
    if not stage then return .10 end
    local times=tonumber(stage.DamageTimes) or 0
    local step=tonumber(stage.DamageStep) or 0
    local action=tonumber(stage.ActEndTime) or 0
    local first=tonumber(stage.HitTime) or 0
    if times>=2 and step>0 and action>0 then
        local lastHit=first+(times-1)*step
        -- Some skills declare DamageStep spanning far beyond ActEndTime,
        -- likely persistent effects. We cannot assume they require channeling.
        if lastHit<=action+.16 and action<=12 then
            return math.clamp(math.max(lastHit,action)+.025,.10,12.2)
        end
    end
    return .10
end
function Runtime.SkillProfileIsCurrent(slot,profile,force)
    if not profile then return false end
    -- Normal checks use the .4s cache (Bow pulses / Beam watchdog are frequent).
    -- Force a fresh lookup only before sending a stage or closing a cast.
    local current=Runtime.ResolveSkillProfile(slot,force==true)
    return current~=nil and current.Id==profile.Id and current.WeaponId==profile.WeaponId
end

-- Only opt into special behavior when the ACTUAL equipped Q is Rastar.
-- No hardcoded stage list: the Dynamic Resolver still determines stage count.
function Runtime.IsAstralRastar()
    if not Config.AstralSkillPriority or Config.ScepterCombat or Runtime.NightEquippedBow() then
        return false
    end
    local q=Runtime.ResolveSkillProfile("Skill1")
    return q~=nil and q.Id=="Staff_Rastar_Skill_Backflip" and q.Count==3
end

-- === v4.9.34 PER-SKILL AIM: skill IDs are the stable profile keys. ===
-- AUTO uses ONLY tested/known positioning rules. An unknown skill defaults
-- to HOVER, not to a guessed horizontal cast. Manual choices survive changing
-- weapon class and are restored when the same skill ID is equipped again.
local knownCastDirection={
    Staff_Rastar_Skill_Backflip="HORIZONTAL",     -- Q: orbit rings spread laterally
    Staff_Rastar_Skill_StarFall="HOVER",          -- E: cylindrical falling damage
    Staff_Rastar_Skill_Ult_FinalAct="HOVER",      -- R: cylindrical multi-stage AOE
    Staff_Skill_Ult_Beam="HOVER",                 -- old beam requires long channel
}
function Runtime.GetSkillCastDirection(slot,profile)
    local p=profile or Runtime.ResolveSkillProfile(slot)
    local id=p and p.Id
    if type(id)~="string" or id=="" then return "HOVER","UNKNOWN",nil end
    if Config.UndergroundHover then return "HOVER","UNDERGROUND_3D_AIM",id end
    local manual=Config.SkillDirectionOverrides and Config.SkillDirectionOverrides[id]
    if manual=="HORIZONTAL" or manual=="HOVER" then
        return manual,"MANUAL",id
    end
    local known=knownCastDirection[id]
    if known then return known,"AUTO_KNOWN",id end
    return "HOVER","AUTO_SAFE",id -- no untested angle inference
end
-- === v4.9.35: independent PER-SKILL altitude selector ===
-- AUTO defaults: ALL weapons Q/E/R descend to lure, except sustained beam;
-- G stays at +30 for Staff/Astral/Bow/Gun, descends for other weapons.
-- Manual values follow the skill ID across weapon/scroll switches.
function Runtime.GetSkillCastElevation(slot,profile)
    local p=profile or Runtime.ResolveSkillProfile(slot)
    local id=p and p.Id
    if type(id)~="string" or id=="" then return "HOVER","UNKNOWN",nil end
    if Config.UndergroundHover then return "HOVER","UNDERGROUND_ALTITUDE",id end
    local manual=Config.SkillDescentOverrides and Config.SkillDescentOverrides[id]
    if manual=="DESCEND" or manual=="HOVER" then
        return manual,"MANUAL",id
    end
    if id=="Staff_Skill_Ult_Beam" then
        return "HOVER","AUTO_BEAM_SUSTAINED",id
    end
    local cls=Runtime.AutoCombatClass
    if cls==nil then
        cls=Runtime.IsAstralRastar() and "ASTRAL"
            or (Runtime.NightEquippedBow() and "BOW")
            or (Config.ScepterCombat and "STAFF_S5") or "GENERIC"
    end
    if slot=="SkillAW" and Config.CombatMode~="MELEE" then
        return "HOVER","AUTO_RANGED_G",id
    end
    return "DESCEND","AUTO_LURE",id
end
function Runtime.IsDescentSkill(slot)
    if not Config.FlyDynamicSkills or not Config.AutoCombatPresetEnabled
        or Config.CombatMode=="CLONE" then return false end
    if slot=="SkillU" and Runtime.IsStaffBeamEquipped and Runtime.IsStaffBeamEquipped() then
        return false -- dedicated multi-second Beam must own its location
    end
    local pos=Runtime.GetSkillCastElevation(slot)
    return pos=="DESCEND"
end
function Runtime.IsHorizontalSkill(slot)
    if Config.UndergroundHover or not Config.FlyDynamicSkills then return false end
    -- Horizontal fly positioning and 90-degree down camera control conflict.
    if Config.Aim3DDown then return false end
    if slot=="SkillU" and Runtime.IsStaffBeamEquipped and Runtime.IsStaffBeamEquipped() then
        return false -- Beam's sustained worker must own the complete cast.
    end
    local direction=Runtime.GetSkillCastDirection(slot)
    if direction~="HORIZONTAL" then return false end
    -- In the special Orbit path, an explicit or known horizontal rule still
    -- applies to Astral Q; non-Rastar arbitrary horizontal casts are deferred.
    if Runtime.OrbitEnabled and Runtime.OrbitEnabled()
        and not Runtime.IsAstralRastar() then return false end
    return true
end
-- Explicit Scepter profile. In Rapid mode G always fires from the current
-- hover height. Turning G Horizontal back ON suspends rapid spam and restores
-- the shared safe horizontal caster (useful when changing Scroll skills).
function Runtime.ScepterRapidActive()
    -- Both requested Scepter modes have independent Rapid Explosive G.
    -- v4.9.42: for Astral Rastar ONLY, Rush G determines the one-stage
    -- rapid worker. OFF returns G to the normal shared skill scheduler.
    -- The user can still disable AutoSkills to stop G in either mode.
    if Config.AutoSkills ~= true then return false end
    if Runtime.ActiveCombatMode=="ASTRAL" and Runtime.IsAstralRastar()
        and not Config.AstralRushG then return false end
    if Config.ScepterCombat~=true and not Runtime.IsAstralRastar()
        and Runtime.AutoCombatClass~="BOW" and Runtime.AutoCombatClass~="GUN"
        and Runtime.AutoCombatClass~="STAFF" then return false end
    local g=Runtime.ResolveSkillProfile("SkillAW")
    -- A manually lowered G must run its full stage sequence at ground level.
    if Runtime.IsDescentSkill("SkillAW") then return false end
    -- Fast G worker is appropriate only for an actual short-CD, one-phase Scroll.
    -- Other Scrolls fall back to normal dynamic SkillAW stages/timing.
    return g~=nil and g.Count==1 and (g.CD==nil or g.CD<=.35)
end
local function flatDistance(a,b)
    return (Vector3.new(a.X-b.X,0,a.Z-b.Z)).Magnitude
end
local function horizontalWarningNearFight(targetRoot)
    if Runtime.DodgeActive then return true end
    if not targetRoot or not targetRoot.Parent or not Runtime.NearRedWarning then return false end
    -- Probe near ground, not the airborne Scepter/Bow HRP. RedShow height
    -- and bounds are approximate; the actual low cast position is rechecked.
    local ty=targetRoot.Position.Y+8
    if Runtime.NearRedWarning({Position=Vector3.new(targetRoot.Position.X,ty,targetRoot.Position.Z)}) then
        return true
    end
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if root and Runtime.NearRedWarning({Position=Vector3.new(root.Position.X,ty,root.Position.Z)}) then
        return true
    end
    return false
end
Runtime.HorizontalWarningNearFight=horizontalWarningNearFight
local function horizontalCastSafePosition(myRoot,targetRoot,slot)
    if not targetRoot or not targetRoot.Parent then return nil,"no target" end
    -- Staff Q has two near-melee slashes before the forward blast. The old
    -- 28-55 stud horizontal standoff would often miss the first two hits.
    local staffQ=(slot=="Skill1" and not Runtime.NightEquippedBow()
        and (Config.ScepterCombat or Runtime.IsAstralRastar()))
    local char=LocalPlayer.Character
    local enemyTag=GameEnum and GameEnum.HumanTag and GameEnum.HumanTag.EnemyNpc or "EnemyNpc"
    local threats={}
    for _,model in ipairs(CollectionService:GetTagged(enemyTag)) do
        if isAliveEnemy(model) and getEnemyRoomContext(model) then
            local er=getModelRoot(model)
            if er and flatDistance(er.Position,targetRoot.Position)<100 then
                local _,h=modelTop(model,er)
                threats[#threats+1]={Root=er,Radius=h>12 and 31 or 23}
            end
        end
    end
    if #threats==0 then
        threats[1]={Root=targetRoot,Radius=26}
    end
    local dir=Vector3.new(myRoot.Position.X-targetRoot.Position.X,0,myRoot.Position.Z-targetRoot.Position.Z)
    if dir.Magnitude<.01 then
        local f=targetRoot.CFrame.LookVector
        dir=Vector3.new(f.X,0,f.Z)
    end
    if dir.Magnitude<.01 then dir=Vector3.new(1,0,0) end
    local angle0=math.atan2(dir.Z,dir.X)
    local floorParams=RaycastParams.new()
    floorParams.FilterType=Enum.RaycastFilterType.Exclude
    local red=Workspace:FindFirstChild("RedShow")
    local ignore={char,targetRoot.Parent}
    if red then ignore[#ignore+1]=red end
    floorParams.FilterDescendantsInstances=ignore
    floorParams.IgnoreWater=true
    local best=nil
    local bestScore=-math.huge
    local distBase=math.clamp(tonumber(Config.FlyCastDistance) or 28,10,55)
    local ranged=(Runtime.AutoCombatClass=="BOW" or Runtime.AutoCombatClass=="GUN")
    local closeCast=staffQ or not ranged
    local radii=closeCast and {8,10,12,14} or {16,20,24,28}
    for _,radius in ipairs(radii) do
        for i=0,11 do
            local angle=angle0+i*math.pi/6
            local x=targetRoot.Position.X+math.cos(angle)*radius
            local z=targetRoot.Position.Z+math.sin(angle)*radius
            local hit=Workspace:Raycast(Vector3.new(x,targetRoot.Position.Y+17,z),Vector3.new(0,-78,0),floorParams)
            if hit and hit.Instance and hit.Instance.CanCollide then
                local y=math.max(targetRoot.Position.Y+1,hit.Position.Y+3.2)
                if math.abs(y-targetRoot.Position.Y)<=(closeCast and 26 or 18) then
                    local cast=Vector3.new(x,y,z)
                    local danger=Runtime.NearRedWarning and Runtime.NearRedWarning({Position=cast})
                    local minGap=math.huge
                    local nearest=math.huge
                    for _,t in ipairs(threats) do
                        if t.Root.Parent then
                            local gap=flatDistance(t.Root.Position,cast)
                            nearest=math.min(nearest,gap)
                            minGap=math.min(minGap,gap-t.Radius)
                        end
                    end
                    -- Staff Q deliberately stands near enough for sword slashes,
                    -- but outside the nearest mob's 5-stud center and RedShow.
                    local safeSpacing=closeCast and nearest>=5 or (not closeCast and minGap>=2)
                    if not danger and safeSpacing then
                        local rayParams=RaycastParams.new()
                        rayParams.FilterType=Enum.RaycastFilterType.Exclude
                        rayParams.FilterDescendantsInstances={char,targetRoot.Parent,red}
                        local aim=targetRoot.Position+Vector3.new(0,1.5,0)
                        local block=Workspace:Raycast(cast,aim-cast,rayParams)
                        if not block then
                            local score=closeCast and (100-radius*2+i*(-.2))
                                or (minGap*1.7-radius*.25-(i*1.5))
                            if score>bestScore then best,bestScore=cast,score end
                        end
                    end
                end
            end
        end
    end
    if not best then return nil,"no safe solid ground / target line of sight" end
    return best,nil
end
function Runtime.CancelFlySkill(reason)
    if Runtime.FlySkillBusy then Runtime.Log("FLY_SKILL_CANCEL "..tostring(reason or "cancel")) end
    Runtime.FlySkillToken=Runtime.FlySkillToken+1
    Runtime.FlySkillBusy=false
    Runtime.FlySkillPosition=nil
    Runtime.FlySkillTarget=nil
    Runtime.FlySkillSlot=nil
end
function Runtime.RequestFlySkill(slot,targetRoot,manual)
    if not Runtime.IsDescentSkill(slot) or not targetRoot or not targetRoot.Parent then return false end
    local skillProfile=Runtime.ResolveSkillProfile(slot)
    if not skillProfile then return false end
    if Runtime.FlySkillBusy or Runtime.DodgeActive or Runtime.ScepterGStageBusy
        or Runtime.QERStageBusy or not Runtime.Alive or Runtime.Owner
        or Runtime.RouteBusy or Runtime.DeathRecovery or isTransitioning() or GamePlaceUtil:IsMain()
        or not combatFarmEnabled() or Config.UndergroundHover or os.clock()<(Runtime.DodgeSkillResumeAt or 0)
        or os.clock()<(Runtime.FlySkillResumeAt or 0) or not canCastSkill(slot)
        or horizontalWarningNearFight(targetRoot) then return false end
    local now=os.clock()
    if now-(Runtime.FlySkillLastAttempt[slot] or -1000)<.65 then return false end
    Runtime.FlySkillLastAttempt[slot]=now
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health<=0 then return false end
    local pos,err=horizontalCastSafePosition(root,targetRoot,slot)
    if not pos then
        if now-(Runtime.LastFlyUnsafeLogAt or 0)>4 then
            Runtime.LastFlyUnsafeLogAt=now
            Runtime.Log("FLY_SKIP_UNSAFE "..slot.." "..tostring(err))
        end
        return false
    end
    Runtime.FlySkillBusy=true
    Runtime.FlySkillToken=Runtime.FlySkillToken+1
    local token=Runtime.FlySkillToken
    Runtime.FlySkillPosition=pos
    Runtime.FlySkillTarget=targetRoot
    Runtime.FlySkillSlot=slot
    Runtime.BowToken=Runtime.BowToken+1 -- invalidate any in-flight Bow pulse.
    Runtime.BowBusy=false
    Runtime.BowPauseUntil=now+1.2
    pcall(function() PlayerActionRE:FireServer("SkillAction","BaseAttack") end)
    local castEpoch=Runtime.SkillCastEpoch
    task.spawn(function()
        local fired=false
        local ended=false
        local function valid()
            return Runtime.Alive and Runtime.FlySkillToken==token and Runtime.FlySkillBusy
                and not Runtime.DodgeActive and castEpoch==Runtime.SkillCastEpoch
                and not Runtime.Owner and not Runtime.RouteBusy and not Runtime.DeathRecovery
                and not isTransitioning() and not GamePlaceUtil:IsMain() and combatFarmEnabled()
                and LocalPlayer.Character==char and targetRoot.Parent and root.Parent
                and hum.Health>0
        end
        local ok,castErr=pcall(function()
            if not valid() then return end
            -- Horizontal aim is acquired BEFORE spending server cooldown.
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            local aimDir=Runtime.GetSkillCastDirection(slot,skillProfile)
            local look=aimDir=="HORIZONTAL"
                and Vector3.new(targetRoot.Position.X,pos.Y,targetRoot.Position.Z)
                or targetRoot.Position
            if (look-pos).Magnitude<.1 then look=pos+Vector3.new(0,0,-1) end
            char:PivotTo(CFrame.lookAt(pos,look))
            Runtime.AimTarget=targetRoot
            Runtime.NightEnsureAim()
            task.wait(.10)
            if not valid() or horizontalWarningNearFight(targetRoot)
                or (Runtime.NearRedWarning and Runtime.NearRedWarning({Position=pos})) then return end
            if not canCastSkill(slot) then return end
            if not Runtime.SkillProfileIsCurrent(slot,skillProfile,true) then return end
            local phases=skillProfile.Phases
            SkillActiveBE:Fire("SkillActive",{SkillSlot=slot})
            local sent=0
            for i,phase in ipairs(phases) do
                if i>1 then task.wait(Runtime.SkillPhaseDelay(skillProfile,i-1)) end
                -- If a boss warning arrives mid-Q, do not send more sword phases
                -- from the danger zone. Close the sequence without retry-spam.
                if not valid() or not Runtime.SkillProfileIsCurrent(slot,skillProfile,true)
                    or horizontalWarningNearFight(targetRoot)
                    or (Runtime.NearRedWarning and Runtime.NearRedWarning({Position=pos})) then break end
                PlayerActionRE:FireServer("SkillAction",slot,phase)
                fired=true
                sent=sent+1
            end
            if sent>0 and sent==#phases then
                task.wait(Runtime.SkillPhaseDelay(skillProfile,#phases))
            end
            if sent>0 and Runtime.Alive and Runtime.SkillProfileIsCurrent(slot,skillProfile,true) then
                PlayerActionRE:FireServer("SkillAction",slot)
                ended=true
            end
            if sent<#phases then
                Runtime.Log("FLY_STAGE_INTERRUPTED "..slot.." completed="..sent.."/"..#phases)
                return
            end
            -- Projectiles / skill effects need a short horizontal release window.
            local untilAt=os.clock()+math.clamp(tonumber(Config.FlyCastHold) or 0.10,0.05,2.0)
            while valid() and os.clock()<untilAt do task.wait(.06) end
        end)
        if fired and not ended and Runtime.Alive
            and Runtime.SkillProfileIsCurrent(slot,skillProfile,true) then
            -- Close a partially-sent Q cast only if the same skill is equipped.
            pcall(function() PlayerActionRE:FireServer("SkillAction",slot) end)
        end
        if not ok then Runtime.Log("FLY_SKILL_ERROR "..slot.." "..tostring(castErr)) end
        if token==Runtime.FlySkillToken then
            Runtime.FlySkillBusy=false
            Runtime.FlySkillPosition=nil
            Runtime.FlySkillTarget=nil
            Runtime.FlySkillSlot=nil
            Runtime.FlySkillResumeAt=os.clock()+.18
            if not fired and Runtime.Alive then Runtime.Log("FLY_SKILL_NO_CAST "..slot) end
            -- Next Heartbeat restores +50 Bow or the tallest-mob safe Hover.
        end
    end)
    Runtime.Log("FLY_CAST_BEGIN "..slot.." from outside warnings"..(manual and " HOTKEY" or " AUTO"))
    return true
end

local m1Stage = 1
local lastM1Time = 0
local lastSkillCheck = 0
-- Melee-first: reserve an M1 combo (1..4 -> End) BEFORE granting one skill slot.
-- A completed combo gives the Q/E/R/G scheduler one opportunity; if none is
-- ready, start the next combo immediately. Scepter Rapid and Bow bypass this.
Runtime.MeleeComboClosedAt = 0
Runtime.MeleeSkillOpportunity = false
Runtime.MeleeM1Sent = 0
Runtime.MeleeM1EndSent = 0
Runtime.MeleeM1Errors = 0
Runtime.MeleeM1LastSentAt = 0
do
local weaponUtilNight=Runtime.NightWeaponUtil
local bowStageCache={}
local function bowStageInfo(stage,baseId)
    local key=tostring(baseId)..":"..tostring(stage)
    if bowStageCache[key] then return bowStageCache[key] end
    assert(type(baseId)=="string","Bow BaseAttackId unavailable")
    local info,stageId,config
    if weaponUtilNight then
        local ok=pcall(function()
            info=weaponUtilNight:GetSkillInfo(baseId)
            stageId=info and info["Stage"..stage]
            config=stageId and weaponUtilNight:GetSkillStageInfo(stageId)
        end)
        if not ok then info,config=nil,nil end
    end
    if not config then
        local folders=ReplicatedStorage:FindFirstChild("Configs")
        local skillModule=folders and folders:FindFirstChild("ResSkill")
        local stageModule=folders and folders:FindFirstChild("ResSkillStage")
        if skillModule and stageModule then
            local okay=pcall(function()
                local infoTable=require(skillModule)
                local stageTable=require(stageModule)
                info=infoTable[baseId]
                stageId=info and info["Stage"..stage] or (baseId.."_"..stage)
                config=stageTable[stageId]
            end)
            if not okay then info,config=nil,nil end
        end
    end
    assert(info and config,"Bow Stage"..stage.." config not found")
    local count=tonumber(config.BulletCount) or 1
    -- Protocol verified only for ONE bullet index. Do not guess multi-bullet Idx behavior.
    assert(count==1,"Unverified BulletCount="..tostring(count))
    local result={
        id=tostring(info.ID or baseId)..tostring(config.StageID or stageId),
        hit=math.clamp(tonumber(config.HitTime) or .4,.05,3),
        finish=math.clamp(tonumber(config.ActEndTime) or .7,.1,5),
        pulses=math.clamp(math.floor(tonumber(config.DamageTimes) or 1),1,12),
        step=math.clamp(tonumber(config.DamageStep) or 0,0,1),
        range=math.max(95,tonumber(config.BulletDistance) or 100),
    }
    bowStageCache[key]=result
    return result
end
local function bowTargetPacket(myRoot,range)
    local packet={}
    local list={}
    local tag=GameEnum and GameEnum.HumanTag and GameEnum.HumanTag.EnemyNpc or "EnemyNpc"
    for _,m in ipairs(CollectionService:GetTagged(tag)) do
        if isAliveEnemy(m) then
            local eRoot=getModelRoot(m)
            if eRoot then
                local dist=(eRoot.Position-myRoot.Position).Magnitude
                if dist<=range and getEnemyRoomContext(m) then
                    list[#list+1]={model=m,dist=dist}
                end
            end
        end
    end
    table.sort(list,function(a,b) return a.dist<b.dist end)
    for i=1,math.min(#list,80) do
        packet[#packet+1]={Idx=1,Enemy=list[i].model}
    end
    return packet
end
local function startBowStage(myRoot)
    if Runtime.BowBusy or Runtime.FlySkillBusy
        or not Config.BowCombat or not Config.AutoM1 or not Runtime.Alive
        or not combatFarmEnabled() or Runtime.Owner or Runtime.RouteBusy or isTransitioning() then return end
    if os.clock()<(Runtime.BowPauseUntil or 0) then return end
    local isBow,baseId=Runtime.NightEquippedBow()
    if not isBow then return end
    local baseProfile=Runtime.ResolveSkillProfile("BaseAttack")
    if not baseProfile or baseProfile.Id~=baseId then return end
    local total=baseProfile.Count
    if Runtime.BowResolvedBase~=baseId then
        Runtime.BowResolvedBase=baseId
        Runtime.BowStage=1
    end
    local stage=math.clamp(Runtime.BowStage or 1,1,total)
    local ok,cfg=pcall(bowStageInfo,stage,baseId)
    if not ok then
        -- Do not stall forever on a stage whose multi-projectile protocol is not yet known.
        -- Move to the next stage; preserve tested BulletCount=1 packet shape.
        Runtime.BowPauseUntil=os.clock()+.35
        if os.clock()-(Runtime.BowConfigWarnAt or 0)>10 then
            Runtime.BowConfigWarnAt=os.clock()
            Runtime.Log("BOW_STAGE_CONFIG_ERROR stage="..stage.." "..tostring(cfg))
        end
        return
    end
    Runtime.BowBusy=true
    Runtime.BowToken=Runtime.BowToken+1
    local token=Runtime.BowToken
    local char=LocalPlayer.Character
    local cfgWorld=ReplicatedStorage:FindFirstChild("GameRoundCfg")
    local world=cfgWorld and cfgWorld:GetAttribute("WorldId")
    local round=cfgWorld and cfgWorld:GetAttribute("GameRound")
    local function valid()
        if not Runtime.Alive or token~=Runtime.BowToken or not Config.BowCombat
            or not Runtime.SkillProfileIsCurrent("BaseAttack",baseProfile)
            or not combatFarmEnabled() or Runtime.RouteBusy or Runtime.Owner or isTransitioning()
            or LocalPlayer.Character~=char or not myRoot.Parent then return false end
        local gc=ReplicatedStorage:FindFirstChild("GameRoundCfg")
        return gc and gc:GetAttribute("WorldId")==world and gc:GetAttribute("GameRound")==round
    end
    task.spawn(function()
        local good,err=pcall(function()
            if not valid() then return end
            local start=os.clock()
            PlayerActionRE:FireServer("SkillAction","BaseAttack",stage)
            local last=cfg.hit+(cfg.pulses-1)*cfg.step
            for pulse=1,cfg.pulses do
                local due=start+cfg.hit+(pulse-1)*cfg.step
                while valid() and os.clock()<due do task.wait(math.min(.04,math.max(.01,due-os.clock()))) end
                if not valid() then return end
                local targets=bowTargetPacket(myRoot,cfg.range)
                if #targets>0 then
                    PlayerActionRE:FireServer("BulletShoot",cfg.id,targets,nil)
                end
            end
            local finish=start+math.max(last,cfg.finish)+.045
            while valid() and os.clock()<finish do task.wait(.025) end
            if valid() then
                PlayerActionRE:FireServer("SkillAction","BaseAttack")
                Runtime.BowStage=stage%total+1
            end
        end)
        if not good then Runtime.Log("BOW_STAGE_ERROR "..tostring(err)) end
        if token==Runtime.BowToken then
            Runtime.BowBusy=false
            -- Small cooldown: don't restart before closing the previous stage.
            Runtime.BowPauseUntil=math.max(Runtime.BowPauseUntil or 0,os.clock()+.32)
        end
    end)
end

Runtime.NightStartBowStage=startBowStage
end -- Bow pulse worker module

-- v4.9.14: one shared Q/E/R queue. 'Ready first' is the time first
-- observed ready after the game's LastTs/charge guard; ties rotate fairly.
-- Blocked horizontal casts KEEP their ready time, but do not block high casts
-- or Rapid G while a RedShow warning/unsafe cast geometry persists.
local qerSlots={"Skill1","Skill2","SkillU"}
Runtime.QERReadySince={}
Runtime.QERLocalRetryUntil={}
Runtime.QERLocalCooldownUntil={}
Runtime.QERDispatchCount={Skill1=0,Skill2=0,SkillU=0}
Runtime.QERFinishedCount={Skill1=0,Skill2=0,SkillU=0}
Runtime.QERHorizontalDeferred=0
Runtime.QERStageBusy=false
Runtime.QERLastChosenIndex=0
local function nextReadyQER(now,targetRoot)
    if not Config.AutoSkills or not targetRoot or not targetRoot.Parent then return nil end
    if Runtime.IsAstralRastar() and
        (not Runtime.OrbitEnabled() or Runtime.OrbitPhase=="BURST") then
        -- Astral: initial E pulls, Q makes horizontal rings, R damages column.
        -- Skip unavailable/charging skills rather than starving the queue.
        for _,choice in ipairs({{"Skill2",2},{"Skill1",1},{"SkillU",3}}) do
            local slot,index=choice[1],choice[2]
            if (not Runtime.OrbitEnabled() or not Runtime.OrbitUsedSlots[slot])
                and now>=(Runtime.QERLocalRetryUntil[slot] or 0)
                and now>=(Runtime.QERLocalCooldownUntil[slot] or 0)
                and Runtime.ResolveSkillProfile(slot) and canCastSkill(slot) then
                return slot,index
            end
        end
    end
    local bestSlot,bestIndex,bestSince,bestTie
    local horizontalHazard=nil -- lazy: avoid warning scan for non-horizontal slots
    for i,slot in ipairs(qerSlots) do
        local ready=not (slot=="SkillU" and Runtime.LaserActive)
            and Runtime.ResolveSkillProfile(slot)~=nil and canCastSkill(slot)
        if not ready then
            Runtime.QERReadySince[slot]=nil
        elseif now >= (Runtime.QERLocalCooldownUntil[slot] or 0) then
            if not Runtime.QERReadySince[slot] then Runtime.QERReadySince[slot]=now end
            local blocked=now<(Runtime.QERLocalRetryUntil[slot] or 0)
            if not blocked and Runtime.IsDescentSkill(slot) then
                if horizontalHazard==nil then
                    horizontalHazard=Runtime.DodgeActive
                        or now<(Runtime.DodgeSkillResumeAt or 0)
                        or now<(Runtime.FlySkillResumeAt or 0)
                        or horizontalWarningNearFight(targetRoot)
                end
                blocked=horizontalHazard
            end
            if not blocked then
                local since=Runtime.QERReadySince[slot]
                -- For equal ready times, use last successfully chosen slot as
                -- a circular tie breaker, rather than permanently preferring Q.
                local tie=(i-Runtime.QERLastChosenIndex-1+#qerSlots)%#qerSlots
                if not bestSlot or since<bestSince-0.0001
                    or (math.abs(since-bestSince)<=0.0001 and tie<bestTie) then
                    bestSlot,bestIndex,bestSince,bestTie=slot,i,since,tie
                end
            end
        end
    end
    return bestSlot,bestIndex
end
Runtime.NextReadyQER=nextReadyQER

-- The G worker calls this independently of the 0.1s combat tick, so a Q/E/R
-- becoming available reserves the NEXT cast window before Rapid G can take it.
function Runtime.QERHasPriority(now)
    -- Keep Explosive G from starving throughout the sustained Beam hold.
    -- Q/E still get scheduled by the regular queue in its free windows.
    if Runtime.LaserActive and Config.ScepterCombat then return false end
    if Runtime.FlySkillBusy or Runtime.QERStageBusy
        or not Runtime.HasCombatTarget then return false end
    local target=Runtime.HoverTarget
    local slot=nextReadyQER(now,target)
    return slot~=nil
end

-- v4.9.22: sustained Staff Beam lifecycle. This is a client-side protocol
-- hypothesis: Stage2 DamageTimes=30, DamageStep=.2, ActEndTime=6.
-- We intentionally allow G/M1/Q/E during the hold; whether the server keeps
-- ticking Beam under overlapping actions MUST be tested on a boss.
Runtime.LaserActive=false
Runtime.LaserToken=0
Runtime.LaserOwnsQERLock=false
Runtime.LaserHoldUntil=0
Runtime.LaserSentStage2At=0
Runtime.LaserCompleted=0
function Runtime.CancelLaser(reason)
    Runtime.LaserToken=Runtime.LaserToken+1
    local wasActive=Runtime.LaserActive
    Runtime.LaserActive=false
    Runtime.LaserHoldUntil=0
    if Runtime.LaserOwnsQERLock then
        Runtime.LaserOwnsQERLock=false
        Runtime.QERStageBusy=false
        Runtime.StandardSkillBusyUntil=os.clock()
    end
    if wasActive then
        -- Include script Stop/reinject: Runtime.Alive was already set false.
        pcall(function() PlayerActionRE:FireServer("SkillAction","SkillU") end)
        Runtime.Log("LASER_CANCEL "..tostring(reason or "unknown"))
    end
end
function Runtime.IsStaffBeamEquipped()
    if not Config.ScepterCombat or Config.ScepterCombatMode~="FULL"
        or Runtime.NightEquippedBow() then return false end
    local profile=Runtime.ResolveSkillProfile("SkillU")
    return profile~=nil and profile.Id=="Staff_Skill_Ult_Beam" and profile.Count==3
end
function Runtime.LaunchSustainedBeam(char,now,profile)
    Runtime.LaserToken=Runtime.LaserToken+1
    local token=Runtime.LaserToken
    Runtime.LaserActive=true
    Runtime.LaserSkillProfile=profile
    Runtime.LaserOwnsQERLock=true -- Stage1 still owns shared QER dispatch lock.
    Runtime.LaserHoldUntil=0
    task.spawn(function()
        local function valid()
            return Runtime.Alive and Runtime.LaserActive and token==Runtime.LaserToken
                and Config.AutoSkills and Config.ScepterCombat and Config.ScepterCombatMode=="FULL"
                and Runtime.SkillProfileIsCurrent("SkillU",profile)
                and LocalPlayer.Character==char and not Runtime.Owner
                and not Runtime.RouteBusy and not Runtime.DeathRecovery
                and not isTransitioning() and not GamePlaceUtil:IsMain()
                and combatFarmEnabled()
        end
        local success,err=pcall(function()
            -- Setup Stage1 was already sent by launchStandardSkill.
            -- Keep the tested fast Remote path: setup delay is client-side 0.10s,
            -- NOT the normal 2s animation. The six-second damage hold is exact.
            task.wait(.10)
            if not valid() then Runtime.CancelLaser("stage2 precondition failed"); return end
            local activeStage=profile.Stages[2]
            local hold=math.clamp(tonumber(activeStage.ActEndTime) or 6,0.1,12)
            PlayerActionRE:FireServer("SkillAction","SkillU",profile.Phases[2])
            Runtime.LaserSentStage2At=os.clock()
            Runtime.LaserHoldUntil=Runtime.LaserSentStage2At+hold
            Runtime.Log(string.format("LASER_STAGE2_START id=%s hold=%.2fs multi=%s step=%s; concurrent requests TEST",
                profile.Id,hold,tostring(activeStage.DamageTimes),tostring(activeStage.DamageStep)))
            -- Release Q/E/R scheduler while Laser keeps running separately.
            Runtime.LaserOwnsQERLock=false
            Runtime.QERStageBusy=false
            Runtime.StandardSkillBusyUntil=os.clock()
            while valid() and os.clock()<Runtime.LaserHoldUntil do
                task.wait(math.min(.05, math.max(.01,Runtime.LaserHoldUntil-os.clock())))
            end
            if not valid() then Runtime.CancelLaser("damage hold interrupted"); return end
            -- Stage3 recovery from currently equipped Staff Beam metadata.
            PlayerActionRE:FireServer("SkillAction","SkillU",profile.Phases[3])
            local recoverySeconds=math.clamp(tonumber(profile.Stages[3].ActEndTime) or 1.5,0.1,8)
            local recoveryUntil=os.clock()+recoverySeconds
            while valid() and os.clock()<recoveryUntil do task.wait(.05) end
            if not valid() then Runtime.CancelLaser("recovery interrupted"); return end
            PlayerActionRE:FireServer("SkillAction","SkillU")
            Runtime.LaserCompleted=Runtime.LaserCompleted+1
            Runtime.Log(string.format("LASER_COMPLETE hold=%.2fs stage3=%.2fs; server hits unverified",
                hold,recoverySeconds))
        end)
        if token==Runtime.LaserToken then
            if not success then
                Runtime.Log("LASER_WORKER_ERROR "..tostring(err))
                pcall(function()PlayerActionRE:FireServer("SkillAction","SkillU")end)
            end
            Runtime.LaserActive=false
            Runtime.LaserHoldUntil=0
            if Runtime.LaserOwnsQERLock then
                Runtime.LaserOwnsQERLock=false
                Runtime.QERStageBusy=false
                Runtime.StandardSkillBusyUntil=os.clock()
            end
        end
    end)
end

local function launchStandardSkill(slot,castRoot,now)
    local skillProfile=Runtime.ResolveSkillProfile(slot)
    if not skillProfile then return false end
    if slot=="SkillU" and Runtime.LaserActive then return false end
    if Runtime.QERStageBusy or Runtime.ScepterGStageBusy or Runtime.FlySkillBusy
        or not Runtime.Alive or Runtime.Owner or not combatFarmEnabled()
        or isTransitioning() or not canCastSkill(slot) then return false end
    -- Do not check Dodge here: high/non-horizontal skills are allowed at +60.
    Runtime.QERStageBusy=true
    Runtime.StandardSkillBusyUntil=now+.30
    local char=LocalPlayer.Character
    local stage1Sent=false
    local ok,err=pcall(function()
        if Config.SmartTargetLock and castRoot and castRoot.Parent then
            Runtime.AimTarget=castRoot
            Runtime.NightEnsureAim()
        end
        if not Runtime.SkillProfileIsCurrent(slot,skillProfile,true) then return end
        SkillActiveBE:Fire("SkillActive",{SkillSlot=slot})
        PlayerActionRE:FireServer("SkillAction",slot,skillProfile.Phases[1])
        stage1Sent=true
    end)
    if not ok or not stage1Sent then
        Runtime.QERStageBusy=false
        Runtime.StandardSkillBusyUntil=os.clock()
        Runtime.Log("PRIORITY_SKILL_STAGE1_ERROR "..slot.." "..tostring(err))
        return false
    end
    if slot=="SkillU" and Runtime.IsStaffBeamEquipped() then
        Runtime.LaunchSustainedBeam(char,now,skillProfile)
        return true
    end
    local phases=skillProfile.Phases
    task.spawn(function()
        local function valid()
            return Runtime.Alive and LocalPlayer.Character==char
                and not Runtime.Owner and not Runtime.RouteBusy and not Runtime.DeathRecovery
                and not isTransitioning() and not GamePlaceUtil:IsMain()
                and combatFarmEnabled() and not Runtime.FlySkillBusy
        end
        local sent=1
        local okay,stageErr=pcall(function()
            -- E is one stage then end; R is 1->2->end. The fallback remains 1->2.
            for i=2,#phases do
                task.wait(Runtime.SkillPhaseDelay(skillProfile,i-1))
                if not valid() or not Runtime.SkillProfileIsCurrent(slot,skillProfile,true) then break end
                PlayerActionRE:FireServer("SkillAction",slot,phases[i])
                sent=sent+1
            end
            if sent==#phases then task.wait(Runtime.SkillPhaseDelay(skillProfile,#phases)) end
            -- Do not abort high/aerial skills only because Scepter is dodging +60.
        end)
        local endSent=false
        local endOk,endErr=pcall(function()
            if Runtime.Alive and Runtime.SkillProfileIsCurrent(slot,skillProfile,true) then
                PlayerActionRE:FireServer("SkillAction",slot)
                endSent=true
            end
        end)
        if not okay or not endOk then
            Runtime.Log("PRIORITY_SKILL_PHASE_ERROR "..slot.." "..tostring(stageErr or endErr))
        end
        if sent==#phases and valid() and okay and endOk and endSent
            and Runtime.QERFinishedCount[slot] then
            Runtime.QERFinishedCount[slot]=Runtime.QERFinishedCount[slot]+1
        end
        Runtime.QERStageBusy=false
        Runtime.StandardSkillBusyUntil=os.clock()
    end)
    return true
end

-- Astral M1 deliberately yields the scheduler to Q/E/R and short-CD G.
Runtime.RastarM1Busy=false
Runtime.RastarM1Token=0
Runtime.RastarM1NextAt=0
Runtime.RastarM1BulletCount=0
Runtime.RastarM1BulletWarnAt=0
Runtime.AstralPriorityCache={At=0,Need=false}
function Runtime.AstralQERGWantWindow(now)
    if not Runtime.IsAstralRastar() or not Config.AutoSkills then return false end
    if Runtime.QERStageBusy or Runtime.FlySkillBusy or Runtime.ScepterGStageBusy then return true end
    local cache=Runtime.AstralPriorityCache
    if now-cache.At<.07 then return cache.Need end
    cache.At=now
    local need=(Runtime.QERHasPriority and Runtime.QERHasPriority(now)) or false
    if not need and Runtime.ResolveSkillProfile("SkillAW") then
        -- Respect client cooldown; no fictional accepted G rate.
        need=canCastSkill("SkillAW")
    end
    cache.Need=need and true or false
    return cache.Need
end

-- Rastar M1 RemoteSpy (first 3 stage projectiles use Pos/4 args,
-- fourth uses Enemy/3 args). No multi-target guesses or stale fixed coords.
function Runtime.StartRastarM1(root,now)
    if Runtime.RastarM1Busy or not Config.AstralRastarM1Projectiles
        or now<(Runtime.RastarM1NextAt or 0) or Runtime.AstralQERGWantWindow(now)
        or not Runtime.HasCombatTarget or not Runtime.HoverTarget then return false end
    local p=Runtime.ResolveSkillProfile("BaseAttack")
    if not p or p.Id~="Staff_Rastar_Atk" or p.Count~=4 then return false end
    local char=LocalPlayer.Character
    Runtime.RastarM1Busy=true
    Runtime.RastarM1Token=Runtime.RastarM1Token+1
    local token=Runtime.RastarM1Token
    task.spawn(function()
        local stageSent=0
        local function valid()
            return Runtime.Alive and token==Runtime.RastarM1Token
                and LocalPlayer.Character==char and root.Parent~=nil
                and not Runtime.Owner and not Runtime.RouteBusy
                and not Runtime.DeathRecovery and not Runtime.FlySkillBusy
                and not isTransitioning() and combatFarmEnabled()
                and Runtime.SkillProfileIsCurrent("BaseAttack",p)
        end
        local ok,err=pcall(function()
            for i,phase in ipairs(p.Phases) do
                if not valid() or Runtime.AstralQERGWantWindow(os.clock()) then break end
                local stage=p.Stages[i]
                if not stage or tonumber(stage.BulletCount)~=1 then
                    Runtime.Log("RASTAR_M1_SKIP_UNVERIFIED_BULLET stage="..tostring(phase))
                    break
                end
                local target=Runtime.HoverTarget
                local mob=target and target:FindFirstAncestorWhichIsA("Model")
                if not target or not target.Parent or not mob or not isAliveEnemy(mob)
                    or not getEnemyRoomContext(mob) then break end
                PlayerActionRE:FireServer("SkillAction","BaseAttack",phase)
                stageSent=stageSent+1
                local hit=math.clamp(tonumber(stage.HitTime) or .30,.10,2)
                task.wait(hit)
                if not valid() then break end
                target=Runtime.HoverTarget
                mob=target and target:FindFirstAncestorWhichIsA("Model")
                if not target or not target.Parent or not mob or not isAliveEnemy(mob)
                    or not getEnemyRoomContext(mob) then break end
                local shotId=tostring(p.Id)..tostring(p.StageIds[i])
                if i<4 then
                    PlayerActionRE:FireServer("BulletShoot",shotId,nil,
                        {{Idx=1,Pos=target.Position}})
                else
                    PlayerActionRE:FireServer("BulletShoot",shotId,
                        {{Idx=1,Enemy=mob}})
                end
                Runtime.RastarM1BulletCount=Runtime.RastarM1BulletCount+1
                task.wait(math.max(.01,math.clamp(tonumber(stage.Time) or .70,.30,2)-hit))
            end
        end)
        -- Close any opened M1 stage even when Q/E/R becomes ready mid-combo.
        if stageSent>0 and Runtime.Alive and LocalPlayer.Character==char then
            pcall(function() PlayerActionRE:FireServer("SkillAction","BaseAttack") end)
        end
        if not ok and os.clock()-(Runtime.RastarM1BulletWarnAt or 0)>5 then
            Runtime.RastarM1BulletWarnAt=os.clock()
            Runtime.Log("RASTAR_M1_BULLET_ERROR "..tostring(err))
        end
        if token==Runtime.RastarM1Token then
            Runtime.RastarM1Busy=false
            Runtime.RastarM1NextAt=os.clock()+.08
        end
    end)
    return true
end

-- v4.9.21: independent weapon M1 stream. Skill and M1 packets may overlap.
-- A FireServer count is NOT a server-confirmed hit, especially during casts.
Runtime.M1Spec={CheckedAt=-1000,WeaponId=nil,BaseId=nil,Count=0}
Runtime.ScepterS5Sent=0
Runtime.ScepterS5LastEndAt=0
Runtime.ScepterS5Open=false
Runtime.ScepterS5WarnAt=0
function Runtime.ResolveCurrentM1()
    local cache=Runtime.M1Spec
    local now=os.clock()
    if now-cache.CheckedAt<0.8 then return cache.Count,cache.BaseId end
    cache.CheckedAt=now
    local ok,weaponId,baseId,count=pcall(function()
        local p=Runtime.ResolveSkillProfile("BaseAttack")
        if not p then return nil,nil,0 end
        return p.WeaponId,p.Id,p.Count
    end)
    if not ok then return cache.Count,cache.BaseId end
    if weaponId~=cache.WeaponId or baseId~=cache.BaseId then
        m1Stage=1
        Runtime.MeleeComboClosedAt=0
        if Runtime.ScepterS5Open then
            pcall(function() PlayerActionRE:FireServer("SkillAction","BaseAttack") end)
            Runtime.ScepterS5Open=false
        end
    end
    cache.WeaponId,cache.BaseId=weaponId,baseId
    cache.Count=(type(count)=="number" and count>=1 and count<=10) and count or 0
    return cache.Count,cache.BaseId
end
function Runtime.CloseScepterS5()
    if Runtime.ScepterS5Open then
        Runtime.ScepterS5Open=false
        local ok=pcall(function() PlayerActionRE:FireServer("SkillAction","BaseAttack") end)
        if ok then Runtime.MeleeM1EndSent=Runtime.MeleeM1EndSent+1
        else Runtime.MeleeM1Errors=Runtime.MeleeM1Errors+1 end
    end
end
function Runtime.TryMeleeM1(myRoot,now)
    if Runtime.OrbitLuring and Runtime.OrbitLuring() then
        Runtime.CloseScepterS5()
        return false
    end
    if not Config.AutoM1 or not myRoot or not myRoot.Parent
        or Runtime.Owner or not Runtime.Alive or not combatFarmEnabled()
        or Runtime.RouteBusy or Runtime.DeathRecovery or isTransitioning()
        or Runtime.DodgeActive or Runtime.FlySkillBusy or GamePlaceUtil:IsMain()
        or not (Runtime.HasCombatTarget and Runtime.HoverTarget and Runtime.HoverTarget.Parent) then
        Runtime.CloseScepterS5()
        return false
    end
    local count,baseId=Runtime.ResolveCurrentM1()
    if count<1 then return false end
    -- RANGE/ASTRAL: yield M1 while a ready Q/E/R wants the next cast window.
    -- MELEE: M1 at ~0.10s between requests, skills still run independently.
    if (Runtime.ActiveCombatMode=="RANGE" or Runtime.ActiveCombatMode=="ASTRAL")
        and Runtime.QERHasPriority and Runtime.QERHasPriority(now) then
        Runtime.CloseScepterS5()
        return false
    end
    -- Astral Rastar: Q/E/R/G get every ready window. M1 uses the projectile
    -- worker only in leftover windows; generic Staff M1 lacks BulletShoot.
    if baseId=="Staff_Rastar_Atk" and Runtime.IsAstralRastar() then
        if not Config.AstralRastarM1Projectiles then return false end
        return Runtime.StartRastarM1(myRoot,now)
    end
    local scepter=Config.ScepterCombat and not Runtime.NightEquippedBow()
    if scepter then
        if baseId~="Staff_Atk2" or count<5 then
            Runtime.CloseScepterS5()
            if now-(Runtime.ScepterS5WarnAt or 0)>7 then
                Runtime.ScepterS5WarnAt=now
                Runtime.Log("S5_SKIP: needs Staff_Atk2 BaseAttack with real Stage5; current="..tostring(baseId))
            end
            return false
        end
        local interval=math.clamp(tonumber(Config.ScepterS5Interval) or .08,.04,1.0)
        if now-lastM1Time<interval then return false end
        -- Experimental rapid stage-5 stream. End once per roughly full S5 act
        -- duration instead of sending End after .04s (before HitTime=.43s).
        -- The server can still reject overlapping stage requests.
        if Runtime.ScepterS5Open and now-(Runtime.ScepterS5LastEndAt or 0)>=.91 then
            Runtime.CloseScepterS5()
            Runtime.ScepterS5LastEndAt=now
        end
        local ok,err=pcall(function() PlayerActionRE:FireServer("SkillAction","BaseAttack",5) end)
        if not ok then
            Runtime.MeleeM1Errors=Runtime.MeleeM1Errors+1
            if now-(Runtime.MeleeM1LastErrorAt or 0)>4 then
                Runtime.MeleeM1LastErrorAt=now; Runtime.Log("S5_SEND_ERROR "..tostring(err))
            end
            return false
        end
        if not Runtime.ScepterS5Open then Runtime.ScepterS5LastEndAt=now end
        Runtime.ScepterS5Open=true
        Runtime.ScepterS5Sent=Runtime.ScepterS5Sent+1
        Runtime.MeleeM1Sent=Runtime.MeleeM1Sent+1
        Runtime.MeleeM1LastSentAt=now
        lastM1Time=now
    else
        Runtime.CloseScepterS5()
        if now-lastM1Time<((Runtime.ActiveCombatMode=="MELEE" or Runtime.ActiveCombatMode=="CLONE") and .10 or .08) or now<Runtime.MeleeComboClosedAt then return false end
        local stage=m1Stage
        local ok,err=pcall(function() PlayerActionRE:FireServer("SkillAction","BaseAttack",stage) end)
        if not ok then
            Runtime.MeleeM1Errors=Runtime.MeleeM1Errors+1
            if now-(Runtime.MeleeM1LastErrorAt or 0)>4 then
                Runtime.MeleeM1LastErrorAt=now; Runtime.Log("M1_STAGE_ERROR "..tostring(err))
            end
            return false
        end
        lastM1Time=now
        Runtime.MeleeM1Sent=Runtime.MeleeM1Sent+1
        Runtime.MeleeM1LastSentAt=now
        m1Stage=stage%count+1
        if stage==count then
            Runtime.MeleeComboClosedAt=now+.075
            local char=LocalPlayer.Character
            task.delay(.06,function()
                if not Runtime.Alive or Runtime.Owner or Runtime.RouteBusy
                    or isTransitioning() or not combatFarmEnabled()
                    or LocalPlayer.Character~=char then return end
                local closeOk,closeErr=pcall(function()
                    PlayerActionRE:FireServer("SkillAction","BaseAttack")
                end)
                if closeOk then Runtime.MeleeM1EndSent=Runtime.MeleeM1EndSent+1
                else Runtime.MeleeM1Errors=Runtime.MeleeM1Errors+1
                    Runtime.Log("M1_END_ERROR "..tostring(closeErr)) end
            end)
        end
    end
    if Runtime.MeleeM1Sent%10==0 and Runtime.MeleeM1InfoLabel
        and Runtime.MeleeM1InfoLabel.Parent then
        Runtime.MeleeM1InfoLabel.Text=string.format(
            "M1 client: stages=%d | S5=%d | End=%d | err=%d (hits not verified)",
            Runtime.MeleeM1Sent,Runtime.ScepterS5Sent,Runtime.MeleeM1EndSent,Runtime.MeleeM1Errors)
    end
    if Runtime.MeleeM1Sent%100==0 then
        Runtime.Log("M1_CONCURRENT_REQUESTS="..Runtime.MeleeM1Sent.." S5="..Runtime.ScepterS5Sent)
    end
    return true
end

local function executeCombat(myRoot, targetRoot)
    if Runtime.Owner or not Runtime.Alive or not combatFarmEnabled() or isTransitioning() then return end
    if Runtime.OrbitLuring and Runtime.OrbitLuring() then return end
    if Runtime.FlySkillBusy then return end -- horizontal cast owns movement.
    local bow=Runtime.NightEquippedBow()
    Runtime.BowMode=bow and true or false
    if targetRoot and targetRoot.Parent then
        local myPos=myRoot.Position
        local tPos=targetRoot.Position
        if Config.Aim3DDown then
            -- Do not let the Combat loop overwrite Hover's vertical aim.
            myRoot.CFrame=CFrame.lookAt(myPos,myPos+Vector3.new(0,-1,0),Vector3.new(0,0,-1))
        else
            local flat=Vector3.new(tPos.X,myPos.Y,tPos.Z)
            if (flat-myPos).Magnitude>.1 then myRoot.CFrame=CFrame.lookAt(myPos,flat) end
        end
        if Config.SmartTargetLock or Config.Aim3DDown then
            Runtime.AimTarget=targetRoot
            Runtime.NightEnsureAim()
        else Runtime.NightReleaseAim() end
    else Runtime.NightReleaseAim() end
    local now=os.clock()
    local rapid=Runtime.ScepterRapidActive()
    -- Q/E/R/G scheduler runs separately from M1 worker for EVERY weapon.
    local skillLaunched=false
    if Config.AutoSkills
        and not Runtime.QERStageBusy and not Runtime.ScepterGStageBusy
        and now>=(Runtime.FlySkillResumeAt or 0)
        and now-lastSkillCheck>=.08 then
        lastSkillCheck=now
        local slot,index=nextReadyQER(now,targetRoot)
        -- Non-Rapid weapons retain conventional G after Q/E/R.
        if not slot and not rapid and Runtime.ResolveSkillProfile("SkillAW")
            and canCastSkill("SkillAW") then
            local gMustDescend=Runtime.IsDescentSkill("SkillAW")
            if not gMustDescend or (now>=(Runtime.DodgeSkillResumeAt or 0)
                and not horizontalWarningNearFight(targetRoot)) then
                slot="SkillAW"
            end
        end
        if slot then
            if Runtime.IsDescentSkill(slot) then
                skillLaunched=Runtime.RequestFlySkill(slot,targetRoot,false)
                if not skillLaunched then
                    Runtime.QERLocalRetryUntil[slot]=now+.66
                    if Runtime.QERDispatchCount[slot] then
                        Runtime.QERHorizontalDeferred=Runtime.QERHorizontalDeferred+1
                    end
                end
            else
                skillLaunched=launchStandardSkill(slot,targetRoot,now)
            end
            if skillLaunched then
                if Runtime.OrbitEnabled and Runtime.OrbitEnabled()
                    and Runtime.OrbitPhase=="BURST" then
                    Runtime.OrbitUsedSlots[slot]=true
                end
                Runtime.QERReadySince[slot]=nil
                Runtime.QERLocalCooldownUntil[slot]=now+.30
                if index then Runtime.QERLastChosenIndex=index end
                if Runtime.QERDispatchCount[slot] then
                    Runtime.QERDispatchCount[slot]=Runtime.QERDispatchCount[slot]+1
                end
            end
        end
    end
    -- Pet attacks are independent of skill windows and M1 combo stages.
    if Config.AutoSkills and targetRoot and targetRoot.Parent
        and now-(Runtime.PetAttackLastAt or 0)>=.08 then
        Runtime.PetAttackLastAt=now
        local pets=LocalPlayer:FindFirstChild("EquippedPets")
        if pets then
            for _,pet in ipairs(pets:GetChildren()) do
                local uid=pet:GetAttribute("UID")
                if uid then pcall(function() PlayerPetRE:FireServer("PetAttack",uid) end) end
            end
        end
    end
    -- M1 and Bow are advanced by the independent worker; no skill lockout here.

end

-- === v4.9.9: dedicated Staff/Scepter rapid Explosive (Scroll G / SkillAW). ===
-- The older shared AutoSkills scheduler checks every ~0.35s and rotates through
-- Q/E/R/G, which cannot sustain a nominal 0.10s Scroll cooldown. This is a
-- separate, co-operative request loop, NOT a guarantee of accepted server hits.
Runtime.ScepterGStageBusy=false
Runtime.ScepterGCount=0
Runtime.ScepterGStage1Attempts=0
Runtime.ScepterGErrorCount=0
Runtime.ScepterGLastSentAt=0
Runtime.ScepterGStartedAt=nil
Runtime.ScepterGPreviousBatchAt=nil
Runtime.ScepterGRecentRate=0
Runtime.ScepterGLastErrorLogAt=0
local function rapidGAllowed()
    if not Runtime.ScepterRapidActive() or not Runtime.Alive or Runtime.Owner
        or Runtime.RouteBusy or Runtime.DeathRecovery or isTransitioning()
        or GamePlaceUtil:IsMain() or not combatFarmEnabled()
        or Runtime.FlySkillBusy
        or Runtime.ScepterGStageBusy or Runtime.QERStageBusy
        or os.clock() < (Runtime.StandardSkillBusyUntil or 0)
        or os.clock() < (Runtime.FlySkillResumeAt or 0)
        or not Runtime.HasCombatTarget then return false end
    -- Non-horizontal G is safe during Scepter +60 dodge, but yields
    -- whenever ANY ready and SAFE Q/E/R wants the next cast window.
    if Runtime.QERHasPriority and Runtime.QERHasPriority(os.clock()) then return false end
    local target=Runtime.HoverTarget
    if not (target and target.Parent) then return false end
    local c=LocalPlayer.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    return h~=nil and h.Health>0 and r~=nil
        and ((Config.ScepterCombat and Config.ScepterGBypassClientCooldown)
            or canCastSkill("SkillAW"))
end
-- This loop belongs to Runtime.Alive and ends immediately on reinjection/Stop.
task.spawn(function()
    local nextAt=0
    while Runtime.Alive do
        local modeOn=Runtime.ScepterRapidActive()
        local interval=math.clamp(tonumber(Config.ScepterGInterval) or .10,.01,.20)
        -- Avoid 100-200Hz polling when Scepter Rapid G is disabled.
        task.wait(not modeOn and .10 or (interval<=.05 and .005 or .01))
        if not Runtime.Alive then break end
        local now=os.clock()
        if now>=nextAt and rapidGAllowed() then
            nextAt=now+interval
            Runtime.ScepterGStageBusy=true
            -- Dodge does NOT invalidate downward Explosive G; stage2/end
            -- continue even if Scepter rises from +30 to +60 mid-cast.
            local char=LocalPlayer.Character
            local gProfile=Runtime.ResolveSkillProfile("SkillAW")
            local ok,err=pcall(function()
                -- Client Bindable + server stage protocol from existing AIO. No
                -- animation-hold, no ground teleport, no wait for global skill scan.
                if not gProfile or not Runtime.SkillProfileIsCurrent("SkillAW",gProfile) then
                    error("Rapid G Scroll changed / unresolved")
                end
                SkillActiveBE:Fire("SkillActive",{SkillSlot="SkillAW"})
                PlayerActionRE:FireServer("SkillAction","SkillAW",gProfile.Phases[1])
            end)
            if ok then Runtime.ScepterGStage1Attempts=Runtime.ScepterGStage1Attempts+1 end
            if not ok then
                Runtime.ScepterGStageBusy=false
                Runtime.ScepterGErrorCount=Runtime.ScepterGErrorCount+1
                if now-(Runtime.ScepterGLastErrorLogAt or 0)>5 then
                    Runtime.ScepterGLastErrorLogAt=now
                    Runtime.Log("SCEPTER_G_ERROR stage1 "..tostring(err))
                end
            else
                -- For 0.01/0.02s tests, avoid the fixed 0.018s stage gap.
                -- The callback remains scheduler-bound; actual throughput may be lower.
                local phaseDelay=math.min(.018,math.max(.005,interval*.35))
                task.delay(phaseDelay,function()
                    local valid=Runtime.Alive
                        and LocalPlayer.Character==char and Runtime.ScepterRapidActive()
                        and not Runtime.Owner and not Runtime.RouteBusy and not Runtime.DeathRecovery
                        and not Runtime.FlySkillBusy
                        and not isTransitioning() and not GamePlaceUtil:IsMain()
                        and combatFarmEnabled()
                    local success,stageErr=pcall(function()
                        -- Staff Explosive is one observed stage: 1 -> end.
                        -- No stage 2 was captured in the user's SkillAW trace.
                        if Runtime.Alive and LocalPlayer.Character==char
                            and combatFarmEnabled() and not isTransitioning()
                            and Runtime.SkillProfileIsCurrent("SkillAW",gProfile) then
                            PlayerActionRE:FireServer("SkillAction","SkillAW")
                        end
                    end)
                    Runtime.ScepterGStageBusy=false
                    if success and valid then
                        Runtime.ScepterGLastSentAt=os.clock()
                        if Runtime.ScepterGCount==0 then
                            Runtime.ScepterGStartedAt=Runtime.ScepterGLastSentAt
                            Runtime.ScepterGPreviousBatchAt=Runtime.ScepterGLastSentAt
                        end
                        Runtime.ScepterGCount=Runtime.ScepterGCount+1
                        if Runtime.ScepterGCount%100==0 then
                            local dt=math.max(.1,Runtime.ScepterGLastSentAt-(Runtime.ScepterGPreviousBatchAt or Runtime.ScepterGLastSentAt))
                            Runtime.ScepterGRecentRate=100/dt
                            Runtime.ScepterGPreviousBatchAt=Runtime.ScepterGLastSentAt
                            Runtime.Log(string.format("SCEPTER_G_BATCH sent=%d last100=%.2f/s interval=%.2fs",
                                Runtime.ScepterGCount,Runtime.ScepterGRecentRate,interval))
                        end
                    elseif not success then
                        Runtime.ScepterGErrorCount=Runtime.ScepterGErrorCount+1
                        if os.clock()-(Runtime.ScepterGLastErrorLogAt or 0)>5 then
                            Runtime.ScepterGLastErrorLogAt=os.clock()
                            Runtime.Log("SCEPTER_G_ERROR stage2 "..tostring(stageErr))
                        end
                    end
                end)
            end
        end
    end
end)
-- Dedicated independent M1/Bow worker; its send path does not depend on Q/E/R/G busy.
task.spawn(function()
    while Runtime.Alive do
        task.wait(.02)
        if not Runtime.Alive then break end
        if not (Runtime.OrbitLuring and Runtime.OrbitLuring())
            and Config.AutoM1 and Runtime.HasCombatTarget and Runtime.HoverTarget
            and Runtime.HoverTarget.Parent and combatFarmEnabled() and not GamePlaceUtil:IsMain()
            and not isTransitioning() and not Runtime.RouteBusy and not Runtime.Owner
            and not Runtime.DeathRecovery and not Runtime.FlySkillBusy then
            local char=LocalPlayer.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health>0 and root then
                local ok,err=pcall(function()
                    local now=os.clock()
                    local waitForSkill=(Runtime.ActiveCombatMode=="RANGE" or Runtime.ActiveCombatMode=="ASTRAL")
                        and Runtime.QERHasPriority and Runtime.QERHasPriority(now)
                    if not waitForSkill then
                        if Runtime.NightEquippedBow() and Config.BowCombat then
                            Runtime.NightStartBowStage(root)
                        else
                            Runtime.TryMeleeM1(root,now)
                        end
                    end
                end)
                if not ok and os.clock()-(Runtime.M1WorkerWarnAt or 0)>5 then
                    Runtime.M1WorkerWarnAt=os.clock()
                    Runtime.Log("M1_WORKER_ERROR "..tostring(err))
                end
            end
        elseif Runtime.ScepterS5Open then
            Runtime.CloseScepterS5()
        end
    end
    if Runtime.ScepterS5Open then Runtime.CloseScepterS5() end
end)
-- === end Rapid G worker ===

-- A spawn may require physically crossing a region; teleporting to an Elite skips it.
local patrol = {Token = 0, Busy = false, Index = 0, Origin = nil, Character = nil, World = nil, IdleSince = nil}
local function stopPatrol()
	patrol.Token = patrol.Token + 1
	patrol.Busy = false
	Runtime.Patrolling = false
	if patrol.Humanoid and patrol.Root and patrol.Root.Parent then
		patrol.Humanoid:MoveTo(patrol.Root.Position)
	end
	patrol.Humanoid = nil
	patrol.Root = nil
end
Runtime.CancelPatrol = stopPatrol
local function currentWorldId()
	local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	return cfg and cfg:GetAttribute("WorldId")
end
local function capturePatrolOrigin(char, root)
	local world = currentWorldId()
	if not world then return end
	if patrol.Character ~= char or patrol.World ~= world or not patrol.Origin then
		stopPatrol()
		patrol.Character, patrol.World, patrol.Origin = char, world, root.Position
		patrol.Index, patrol.IdleSince = 0, nil
	end
end
local function patrolDestinations()
	local saved = Config.PatrolRoutes[patrol.World]
	local points = {}
	if type(saved) == "table" then
		for _, p in ipairs(saved) do
			if type(p) == "table" and type(p[1]) == "number" and type(p[2]) == "number" and type(p[3]) == "number" then
				table.insert(points, Vector3.new(p[1], p[2], p[3]))
			end
		end
	end
	if #points > 0 then return points, true end
	if not patrol.Origin then return points, false end
	table.insert(points, patrol.Origin)
	-- Generic search only: exact Castle trigger coordinates are not present in the dump.
	for _, radius in ipairs({30, 60, 100}) do
		for _, dir in ipairs({{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}}) do
			table.insert(points, patrol.Origin + Vector3.new(dir[1] * radius, 0, dir[2] * radius))
		end
	end
	return points, false
end
local function walkPatrol(char, root, hum)
    if Runtime.EndlessPatrolBlocked and Runtime.EndlessPatrolBlocked() then
        if patrol.Busy then stopPatrol() end
        return
    end
	if Runtime.Owner or Runtime.RouteBusy or Runtime.RouteAwaitingSpawn or not Config.AutoPatrol or patrol.Busy or not patrol.Origin then return end
	patrol.IdleSince = patrol.IdleSince or os.clock()
	if os.clock() - patrol.IdleSince < 1.5 then return end
	local points, isSaved = patrolDestinations()
	if #points == 0 then return end
	patrol.Index = patrol.Index % #points + 1
	local destination = points[patrol.Index]
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {char}
	local ground = Workspace:Raycast(destination + Vector3.new(0, 16, 0), Vector3.new(0, -50, 0), rayParams)
	if not ground or ground.Normal.Y < 0.5 then return end
	destination = ground.Position + Vector3.new(0, 3, 0)
	patrol.Token = patrol.Token + 1
	local token = patrol.Token
	patrol.Busy = true
	Runtime.Patrolling = true
	patrol.Humanoid, patrol.Root = hum, root
	-- Restore collision before walking; noclip prevents reliable ground navigation.
	for part, value in pairs(Runtime.Collision) do if part.Parent then part.CanCollide = value end end
	table.clear(Runtime.Collision)
	StatusLbl.Text = string.format("Status: Đi tìm spawn %s %d/%d", isSaved and "theo tuyến" or "quanh điểm vào", patrol.Index, #points)
	task.spawn(function()
		local function active()
			return Runtime.Alive and not Runtime.Owner and token == patrol.Token and combatFarmEnabled() and Config.AutoPatrol
				and not isTransitioning() and not GamePlaceUtil:IsMain() and char.Parent and hum.Health > 0
                and not (Runtime.EndlessPatrolBlocked and Runtime.EndlessPatrolBlocked())
		end
		local ok, err = pcall(function()
			local path = PathfindingService:CreatePath({AgentRadius = 2, AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 5})
			path:ComputeAsync(root.Position, destination)
			if not active() or path.Status ~= Enum.PathStatus.Success then return end
			local deadline = os.clock() + 25
			for _, waypoint in ipairs(path:GetWaypoints()) do
				if not active() or os.clock() > deadline then return end
				if waypoint.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
				hum:MoveTo(waypoint.Position)
				local stepDeadline = os.clock() + 5
				while active() and (root.Position - waypoint.Position).Magnitude > 4 do
					if os.clock() > stepDeadline or os.clock() > deadline then return end
					task.wait(0.1)
				end
			end
		end)
		if token == patrol.Token then
			stopPatrol()
			patrol.IdleSince = os.clock()
			if not ok then reportError("Patrol", err) end
		end
	end)
end

addSectionHeader("5. TUYẾN ĐI KÍCH HOẠT SPAWN")
local function routeButton(text, callback)
	local button = Instance.new("TextButton", Scroll)
	orderWidget(button)
	button.Size = UDim2.new(0.94, 0, 0, 32)
	button.BackgroundColor3 = Color3.fromRGB(45, 85, 125)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 11
	button.Text = text
	button.MouseButton1Click:Connect(function()
		local ok, err = pcall(callback)
		if not ok then reportError(text, err) end
	end)
end
routeButton("Lưu vị trí hiện tại làm điểm tuần tra", function()
	assert(not GamePlaceUtil:IsMain(), "Hãy đứng trong dungeon")
	local world = assert(currentWorldId(), "Chưa có WorldId")
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	assert(root, "Chưa có nhân vật")
	local list = Config.PatrolRoutes[world] or {}
	assert(#list < 30, "Tối đa 30 điểm mỗi map")
	local p = root.Position
	table.insert(list, {p.X, p.Y, p.Z})
	Config.PatrolRoutes[world] = list
	saveConfig()
	stopPatrol()
	patrol.Index = 0
	StatusLbl.Text = string.format("Status: Đã lưu điểm %d cho %s", #list, world)
end)
routeButton("Xóa tuyến tuần tra của map hiện tại", function()
	local world = assert(currentWorldId(), "Hãy vào map cần xóa tuyến")
	Config.PatrolRoutes[world] = nil
	saveConfig()
	stopPatrol()
	patrol.Index = 0
	StatusLbl.Text = "Status: Đã xóa tuyến " .. world
end)

addSectionHeader("6. LƯU CỔNG TẠO PHÒNG (LÀM MỘT LẦN)")
routeButton("Lưu cổng tại vị trí hiện tại cho loại map đã chọn", function()
	assert(GamePlaceUtil:IsMain(), "Chỉ lưu cổng khi ở Lobby")
	assert(not Runtime.EntryBusy and not Runtime.ForgeBusy and not Runtime.BatchActive, "Chờ tác vụ hiện tại kết thúc trước khi lưu")
	assert(not isTransitioning() and not roomWaitingTeleport(), "Phòng đang chuyển map; không lưu lúc này")
	assert(LocalPlayer:GetAttribute("EnterRoomId"), "Hãy bước vào ô để game tự mở GUI, rồi lưu khi còn trong ô")
	local mode = WorldUtil:GetWorldMode(Config.SelectedWorld)
	assert(mode, "Không đọc được loại map")
	local main = PlayerGui:FindFirstChild("MainGui")
	local name = Config.SelectedWorld == "Endless1" and "ScreenMatch_Endless" or "ScreenMatch"
	local gui = main and main:FindFirstChild(name)
	assert(gui and gui.Visible, "Đứng sát đúng cổng, mở GUI theo cách thường rồi lưu")
	if name == "ScreenMatch" then
		local data = WindowUtil:GetOpenData(name)
		assert(data and data.Mode == mode, "GUI đang mở không cùng loại map đã chọn trên bảng auto")
	end
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	assert(root, "Chưa có nhân vật")
	local key = assert(portalKey(Config.SelectedWorld), "Loại cổng không hợp lệ")
	Config.PortalEntrances[key] = {root.CFrame:GetComponents()}
	local saved, err = saveConfig()
	assert(saved, "Đã giữ tọa độ trong phiên nhưng ghi JSON thất bại: " .. tostring(err))
	StatusLbl.Text = "Status: Đã lưu riêng cổng " .. key .. "; các cổng khác được giữ nguyên."
end)
routeButton("Kiểm tra 5 cổng tạo phòng (Lobby Portals)", function()
	local labels = {}
	for _, sample in ipairs({
		{w="World1", label="W1/2"},
		{w="World3", label="W3/4"},
		{w="Cave1", label="Cave"},
		{w="Endless1", label="Endless"},
		{w="Valhalla", label="Valhalla"}
	}) do
		local value, key, src = savedEntrance(sample.w)
		if value then
			labels[#labels+1] = string.format("%s(%.2f,%.2f,%.2f)[%s]", sample.label, value[1], value[2], value[3], src == "SavedConfig" and "LƯU" or "MẶC ĐỊNH")
		else
			labels[#labels+1] = sample.label .. ": CHƯA LƯU"
		end
	end
	local msg = table.concat(labels, " | ")
	Runtime.Log("LOBBY_PORTALS_CHECK " .. msg)
	StatusLbl.Text = msg
end)
routeButton("Khôi phục 5 tọa độ cổng mặc định chuẩn", function()
	assert(not Runtime.EntryBusy and not isLobbyBusy, "Đang xử lý Lobby")
	for k, v in pairs(DefaultPortalEntrances) do
		Config.PortalEntrances[k] = table.clone(v)
	end
	saveConfig()
	StatusLbl.Text = "Status: Đã nạp 5 tọa độ cổng chuẩn (W1/2, W3/4, Cave, Endless, Valhalla)"
end)
routeButton("TP vào ô đã lưu (không Create)", function()
	assert(GamePlaceUtil:IsMain() and lobbyCharacterReady() and not isTransitioning() and not roomWaitingTeleport(), "Chờ nhân vật ở Lobby")
	assert(not isLobbyBusy and not Runtime.EntryBusy and not Runtime.BatchActive and not Runtime.ForgeBusy, "Đang có tác vụ")
	local gui = forgingGui()
	assert(not (gui and gui.Visible), "Đang rèn thủ công")
	local value, key, src = savedEntrance(Config.SelectedWorld)
	assert(validEntrance(value), "Chưa lưu cổng " .. key)
	LocalPlayer.Character:PivotTo(CFrame.new(table.unpack(value)))
	StatusLbl.Text = "TP " .. key .. " (" .. tostring(src) .. "); chưa xác nhận kích hoạt ô"
end)
routeButton("TP tới cổng Valhalla (chỉ TP, không tự gọi Remote)", function()
	assert(GamePlaceUtil:IsMain() and lobbyCharacterReady() and not isTransitioning() and not roomWaitingTeleport(), "Chờ nhân vật ở Lobby")
	assert(not isLobbyBusy and not Runtime.EntryBusy and not Runtime.BatchActive and not Runtime.ForgeBusy, "Đang có tác vụ")
	local value = Config.PortalEntrances.Valhalla or DefaultPortalEntrances.Valhalla
	assert(validEntrance(value), "Thiếu tọa độ Valhalla")
	LocalPlayer.Character:PivotTo(CFrame.new(table.unpack(value)))
	StatusLbl.Text = "TP cổng Valhalla (106.77, -449.25, -563.18); không tự gọi Remote chưa xác minh"
end)
routeButton("Activate: TP + MoveTo 5 studs (không Create)", function()
	assert(not isLobbyBusy, "Đang xử lý Lobby")
	assert(GamePlaceUtil:IsMain(), "Chỉ kích hoạt ở Lobby")
	portalRetry.At = 0
	enterSelectedDungeon(true, true)
end)
routeButton("CREATE một lần: Activate + chọn map + Create", function()
	assert(not isLobbyBusy, "Đang xử lý Lobby")
	assert(GamePlaceUtil:IsMain(), "Chỉ Create ở Lobby")
	portalRetry.At = 0
	enterSelectedDungeon(false, true)
end)

-- Recorded keys are DESTINATION rooms, independent of difficulty.
-- Tách bạch RecordedCoordinates (lưu toàn bộ tọa độ) và AutoRouteEnabled (cấu hình Room nào được Auto TP).
do
local RouteFile = "IronSoul_RoomRoutes_Test.json"
local RouteBackupFile = "IronSoul_RoomRoutes_Test.backup.json"

-- Imported from the user's two JSON exports (2026-11-07). World4 remains untouched.
-- The one-time migration writes a backup before updating old route/config data.
local SequentialImportVersion = "W23_20261107_FULL"
local SequentialImportedCoordinates = {
    World2 = {["1"]={-6164.69921875, 5.793244361877441, 644.2157592773438, -0.04840638488531113, -6.499201532506049e-08, 0.9988276958465576, -4.4231054374677115e-09, 1.0, 6.485393555522023e-08, -0.9988276958465576, -1.2785755787447783e-09, -0.04840638488531113}, ["2"]={-4354.30859375, 567.7891845703125, 1569.2520751953125, 0.3920781910419464, -1.307953390039529e-08, -0.9199318885803223, 1.2416982997365267e-07, 1.0, 3.870367848435308e-08, 0.9199318885803223, -1.2940265037286736e-07, 0.3920781910419464}, ["3"]={-4106.3662109375, 561.8613891601562, 1580.9052734375, 0.06966418772935867, 1.244090839236378e-07, -0.9975705146789551, 2.3744808785863825e-08, 1.0, 1.2637026713946398e-07, 0.9975705146789551, -3.249060043231111e-08, 0.06966418772935867}, ["4"]={-6273.28125, 3.617537021636963, -1435.8062744140625, 0.3640502393245697, 8.284136754355131e-08, -0.9313793182373047, 4.321361757320119e-08, 1.0, 1.0583582366052724e-07, 0.9313793182373047, -7.87778233757308e-08, 0.3640502393245697}, ["5"]={-4134.560546875, 561.595458984375, 2514.181396484375, -0.061003539711236954, 8.471859302972007e-08, -0.9981375336647034, 7.414605374123084e-09, 1.0, 8.442351173698626e-08, 0.9981375336647034, -2.250663211356141e-09, -0.061003539711236954}, ["6"]={-4382.8125, 565.780029296875, 2510.637939453125, 0.0018384646391496062, -3.6336796682689965e-08, 0.9999983310699463, -7.638028542977793e-10, 1.0, 3.633826395343931e-08, -0.9999983310699463, -8.306081378250951e-10, 0.0018384646391496062}, ["7"]={-4191.6640625, 649.7337036132812, -1869.6229248046875, 0.029202552512288094, -1.5473629488838014e-08, 0.9995735287666321, -8.924524314002369e-11, 1.0, 1.5482838122693465e-08, -0.9995735287666321, -5.413455794744948e-10, 0.029202552512288094}},
    World3 = {["1"]={685.6613159179688, 64.36203002929688, 534.1989135742188, 0.7968733906745911, 1.3247970720442481e-08, 0.6041463613510132, -6.150946722446871e-13, 1.0, -2.1927602844584726e-08, -0.6041463613510132, 1.7473150037972118e-08, 0.7968733906745911}, ["2"]={117.47030639648438, -7.262232303619385, 806.8925170898438, -0.011833420023322105, -9.956017521517424e-08, -0.9999299645423889, -1.440696034693545e-10, 1.0, -9.956544033684622e-08, 0.9999299645423889, -1.0341402179037118e-09, -0.011833420023322105}, ["3"]={152.11886596679688, 3.595966100692749, 279.3916015625, 0.0708310455083847, -4.1580836551702305e-09, -0.9974883198738098, -2.4058117720215932e-09, 1.0, -4.339388848251247e-09, 0.9974883198738098, 2.7071325181537986e-09, 0.0708310455083847}, ["4"]={770.8950805664062, 64.36203002929688, -37.48000717163086, -0.05277120694518089, -8.139102192217251e-08, -0.9986066222190857, 3.84111796189468e-12, 1.0, -8.150479402502242e-08, 0.9986066222190857, -4.304942180510807e-09, -0.05277120694518089}, ["5"]={-890.1591186523438, 18.033464431762695, 253.69273376464844, 0.014460558071732521, 1.379621039632184e-08, -0.999895453453064, -1.1844130121119179e-09, 1.0, 1.3780524277251516e-08, 0.999895453453064, 9.850150695100979e-10, 0.014460558071732521}, ["6"]={-519.7216796875, 30.007596969604492, 261.3257141113281, 0.1654454916715622, 1.1018739343171546e-07, 0.9862189292907715, 2.0895494223793776e-09, 1.0, -1.1207765027165806e-07, -0.9862189292907715, 2.0603495798354743e-08, 0.1654454916715622}}
}
local SequentialImportedAnchors = {
    World2 = {["1"]={-6272.0068359375, 14.362823486328125, 639.9319458007812}, ["2"]={-4337.0439453125, 568.0438232421875, 1539.9508056640625}, ["3"]={-4044.1767578125, 562.7171020507812, 1547.4864501953125}, ["4"]={-6279.01123046875, 4.82664155960083, -1471.230712890625}, ["5"]={-4086.40087890625, 562.8969116210938, 2466.4775390625}, ["6"]={-4340.998046875, 565.5828247070312, 2502.56298828125}, ["7"]={-4164.32861328125, 651.0707397460938, -1888.8243408203125}},
    World3 = {["1"]={597.8900756835938, 68.06700134277344, 596.1836547851562}, ["2"]={130.33563232421875, 3.3018712997436523, 804.7600708007812}, ["3"]={83.38995361328125, 6.696282386779785, 262.6654357910156}, ["4"]={772.6834106445312, 68.10847473144531, -31.197153091430664}, ["5"]={-896.3831787109375, 18.157773971557617, 258.12744140625}, ["6"]={-611.9556274414062, 21.840505599975586, 261.8833923339844}}
}

-- === v4.9.36 VERIFIED RECORDER 1.5: World1 Diff1/2/3 (ROOM ENTRY CFRAMES) ===
-- Diff 4 partial points are deliberately disabled. Diff5 legacy AIO route remains untouched.
local World1BeginnerByDiff = {
    [1] = {
        [1] = {-675.252685546875, 19.092723846435547, -26.535621643066406, -0.5423771142959595, 0.023622266948223114, -0.8398028612136841, -0.004014398902654648, 0.9995203614234924, 0.03070748597383499, 0.8401257991790771, 0.02002631686627865, -0.5420219302177429},
        [2] = {-455.4840393066406, 19.294986724853516, -29.19390869140625, -0.6926732063293457, 0.06645388156175613, -0.7181836366653442, 0.0023635774850845337, 0.9959501624107361, 0.08987612277269363, 0.721247673034668, 0.0605572909116745, -0.6900250911712646},
        [3] = {-475.5736083984375, 26.711027145385742, 200.25579833984375, 0.07091884315013885, 0.006760702468454838, -0.9974591732025146, -0.003457405138760805, 0.9999727606773376, 0.00653191888704896, 0.9974761009216309, 0.002985381754115224, 0.070940300822258},
        [4] = {162.52886962890625, 5.133002758026123, 199.29568481445312, -0.04127106815576553, 1.0068132993978907e-08, 0.9991480112075806, -5.115402501587596e-08, 1.0, -1.2189699916120844e-08, -0.9991480112075806, -5.161352234495098e-08, -0.04127106815576553},
        [5] = {408.5204772949219, 22.03959083557129, -17.590118408203125, -0.9950530529022217, -0.010137238539755344, 0.09882695972919464, -0.008747804909944534, 0.9998568296432495, 0.014482604339718819, -0.09895963221788406, 0.013546441681683064, -0.9949991106987},
        [6] = {-2467.657958984375, 52.654972076416016, -11.48528003692627, 1.0, 2.448454613156962e-20, 0.0, -4.870439446712227e-20, 0.9999276399612427, -0.012027396820485592, 0.0, 0.012027396820485592, 0.9999276399612427},
    },
    [2] = {
        [1] = {-685.3578491210938, 4.702972888946533, -33.34174346923828, 0.9997750520706177, 1.6051728835009271e-09, 0.021210502833127975, -3.1991964632993586e-09, 1.0, 7.51186277625493e-08, -0.021210502833127975, -7.516958788755801e-08, 0.9997750520706177},
        [2] = {-456.4677429199219, 21.09747886657715, -24.947233200073242, -0.9638628959655762, -0.021794263273477554, 0.26550543308258057, 0.0017056138021871448, 0.9961225390434265, 0.08795950561761856, -0.2663929760456085, 0.08523377776145935, -0.9600884914398193},
        [3] = {-485.0982360839844, 15.069602012634277, 211.66293334960938, 0.39556482434272766, -1.2914968294808205e-07, -0.9184380769729614, 5.636958899657429e-09, 1.0, -1.3819102662182559e-07, 0.9184380769729614, 4.948631016077343e-08, 0.39556482434272766},
        [4] = {173.7445526123047, 13.808182716369629, 209.58786010742188, -0.9449942708015442, -0.0013161879032850266, -0.3270842730998993, -0.005389833822846413, 0.9999186992645264, 0.011548379436135292, 0.32704246044158936, 0.012676083482801914, -0.9449245929718018},
        [5] = {365.1246337890625, 15.094644546508789, 179.30801391601562, -0.47505390644073486, -0.030348945409059525, 0.8794332146644592, -0.007888423278927803, 0.9995117783546448, 0.030231647193431854, -0.8799212574958801, 0.007424337789416313, -0.4750613272190094},
        [6] = {-2420.06396484375, 58.237640380859375, 54.50886535644531, 0.2550196349620819, -0.009792386554181576, 0.9668862819671631, -0.0053898342885077, 0.9999188184738159, 0.011548519134521484, -0.9669208526611328, -0.008156444877386093, 0.25494614243507385},
    },
    [3] = {
        [1] = {-690.656005859375, 15.147040367126465, -40.699180603027344, 1.0, 0.0, 0.0, 0.0, 0.9995406270027161, -0.030305426567792892, 0.0, 0.030305426567792892, 0.9995406270027161},
        [2] = {-455.1257629394531, 16.864099502563477, 48.263092041015625, 0.42680779099464417, 0.03228290379047394, 0.9037657976150513, -0.010353422723710537, 0.9994714856147766, -0.0308120995759964, -0.9042830467224121, 0.003793790005147457, 0.4269164502620697},
        [3] = {-485.2340393066406, 19.775972366333008, 230.15138244628906, 0.9057989120483398, -0.011171096004545689, -0.4235607385635376, -0.009792596101760864, 0.998833417892456, -0.047285228967666626, 0.4235948920249939, 0.04697864502668381, 0.9046328067779541},
        [4] = {1168.43212890625, 26.15945053100586, -9.805852890014648, 0.9985057711601257, 0.011032184585928917, 0.05352018401026726, -0.010151959024369717, 0.9998091459274292, -0.016690872609615326, -0.05369410291314125, 0.016122598201036453, 0.9984272718429565},
        [5] = {164.8601531982422, 5.133002758026123, 232.5179901123047, 0.999618649482727, 5.1829307068373964e-08, 0.02761511504650116, -5.421898663371394e-08, 1.0, 8.578639665302035e-08, -0.02761511504650116, -8.725094602368699e-08, 0.999618649482727},
        [6] = {377.6944885253906, 21.577030181884766, 190.91705322265625, -0.5132251977920532, -0.07521624863147736, 0.8549516797065735, 0.00193789042532444, 0.9960482120513916, 0.0887928158044815, -0.8582519292831421, 0.04722749814391136, -0.5110512971878052},
        [7] = {-2315.95068359375, 74.87041473388672, 54.05378723144531, 0.9998453259468079, -6.377194949891418e-06, 0.01758190430700779, -0.00030325696570798755, 0.9998449683189392, 0.017608312889933586, -0.017579257488250732, -0.01761091873049736, 0.9996902942657471},
    },
}

local SeedRecordedCoordinates = {
	World1 = {[1]={-631.6807250976562,5.133018016815186,10.20448875427246,0.3788419663906097,7.625047260262363e-08,0.9254613518714905,-2.764236484154026e-08,1,-7.10763146116733e-08,-0.9254613518714905,1.34475131030598e-09,0.3788419663906097}, [2]={-454.3291320800781,5.132979869842529,-5.235568523406982,0.006550014019012451,7.266451884646585e-09,-0.9999785423278809,-8.366043857677141e-08,1,6.71861899448345e-09,0.9999785423278809,8.361463699202432e-08,0.006550014019012451}, [3]={-467.1418762207031,5.132979869842529,214.895751953125,-0.8091380596160889,-6.190282419993309e-08,0.5876185894012451,-1.518355219332079e-08,1,8.443782206768446e-08,-0.5876185894012451,5.939971714497005e-08,-0.8091380596160889}, [4]={1123.680786132812,8.164865493774414,-19.62835693359375,0.4314503371715546,5.042454631620785e-08,-0.9021366834640503,2.895146877790467e-08,1,6.974072874754711e-08,0.9021366834640503,-5.620784193638428e-08,0.4314503371715546}, [5]={-649.0005493164062,5.132987499237061,-403.0781555175781,0.1389321088790894,-5.582889528454871e-08,-0.9903019070625305,3.713491514290013e-09,1,-5.585465245872001e-08,0.9903019070625305,4.082527205184761e-09,0.1389321088790894}, [6]={-449.245849609375,5.132979869842529,-391.6961669921875,0.142545223236084,-8.26231740802541e-08,-0.989788293838501,7.75567388089371e-11,1,-8.346443536311199e-08,0.989788293838501,1.182069109262329e-08,0.142545223236084}, [7]={-439.7626037597656,5.483097553253174,-607.9410400390625,0.9991609454154968,1.035574825891672e-08,0.04095661267638206,-5.720104390150027e-09,1,-1.133014464471671e-07,-0.04095661267638206,1.129721027837149e-07,0.9991609454154968}, [8]={-2380.78369140625,41.38996887207031,2.381709337234497,0.01626324467360973,3.138939996816248e-09,-0.9998677372932434,-2.31922640814286e-11,1,3.13897796644369e-09,0.9998677372932434,-2.786077098193562e-11,0.01626324467360973}},
    World2 = SequentialImportedCoordinates.World2,
    World3 = SequentialImportedCoordinates.World3,
	World4 = {
		[2]={-4194.61669921875,452.81634521484375,1500.90234375,0.6327587366104126,-4.4120427311611365e-09,-0.7743489742279053,-7.140968372176815e-10,1,-6.281267950214442e-09,0.7743489742279053,4.527487273975339e-09,0.6327587366104126},
		[3]={-4086.330810546875,451.1867980957031,3165.383056640625,0.7880908846855164,1.2069354227151052e-07,-0.6155588626861572,-6.230537508145062e-08,1,1.1630283580643663e-07,0.6155588626861572,-5.330457852892323e-08,0.7880908846855164},
		[4]={-8740.92578125,206.82675170898438,-1274.2587890625,-0.6849774718284607,3.728388620061196e-08,-0.7285642623901367,6.65943602484731e-08,1,-1.1435851376973005e-08,0.7285642623901367,-5.635157052097384e-08,-0.6849774718284607},
		[5]={-4426.90966796875,528.3953857421875,-1963.906494140625,-0.08629849553108215,6.965061771779801e-08,0.9962693452835083,6.867590229830967e-08,1,-6.396261653662805e-08,-0.9962693452835083,6.289982223961488e-08,-0.08629849553108215}
	},
	World5 = {},
	Endless1 = {[2]={8493.95703125,270.01959228515627,-6386.2626953125}}
}

local DefaultAutoRouteEnabled = {
	World1 = {[4]=true, [5]=true, [8]=true},
	World2 = {[2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true},
	World3 = {[2]=true, [3]=true, [4]=true, [5]=true, [6]=true},
	World4 = {[2]=true, [3]=true, [4]=true, [5]=true},
	World5 = {},
	Endless1 = {[2]=true}
}

local AllRouteWorlds = {"World1", "World2", "World3", "World4", "World5", "Endless1"}
local RecordedCoordinates = {}
local AutoRouteEnabled = {}
local sources = {}
local UnsavedRouteChanges = false
local pendingReloadConfirmUntil = 0

local function validPosition(p)
	if type(p) ~= "table" or (#p ~= 3 and #p ~= 12) then return false end
	for key, n in pairs(p) do
		if type(key) ~= "number" or key % 1 ~= 0 or key < 1 or key > #p or type(n) ~= "number" or n ~= n or math.abs(n) == math.huge then return false end
	end
	if #p == 12 then
		local x,y,z = Vector3.new(p[4],p[7],p[10]), Vector3.new(p[5],p[8],p[11]), Vector3.new(p[6],p[9],p[12])
		if math.abs(x.Magnitude-1) > 0.02 or math.abs(y.Magnitude-1) > 0.02 or math.abs(z.Magnitude-1) > 0.02
			or math.abs(x:Dot(y)) > 0.02 or math.abs(x:Dot(z)) > 0.02 or math.abs(y:Dot(z)) > 0.02 or x:Cross(y):Dot(z) < 0.98 then return false end
	end
	return true
end

Runtime.RecordedCoordinates = RecordedCoordinates
Runtime.AutoRouteEnabled = AutoRouteEnabled
Runtime.RouteSources = sources

local function syncRouteTablesToConfig()
	Config.RecordedCoordinates = {}
	Config.AutoRouteEnabled = {}
	for _, world in ipairs(AllRouteWorlds) do
		Config.RecordedCoordinates[world] = {}
		Config.AutoRouteEnabled[world] = {}
		for room, coord in pairs(RecordedCoordinates[world] or {}) do
			if validPosition(coord) then
				Config.RecordedCoordinates[world][tostring(room)] = table.clone(coord)
			end
		end
		for room, enabled in pairs(AutoRouteEnabled[world] or {}) do
			Config.AutoRouteEnabled[world][tostring(room)] = (enabled == true)
		end
	end
end

-- World1 beginner Trial/Challenge maps use a different layout; do not borrow Diff5 room points.
-- The game exposes DiffLevel on GameRoundCfg (also used by its own settlement code).
function Runtime.CurrentWorld1Diff()
    local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
    local serverDiff = cfg and tonumber(cfg:GetAttribute("DiffLevel"))
    if serverDiff then return serverDiff end
    if Config.SelectedWorld == "World1" then return tonumber(Config.SelectedDiff) end
    return nil -- Unknown = conservative, never assume Diff5.
end

function Runtime.IsAutoRouteEnabled(world, room)
    local r = tonumber(room)
    if not world or not r then return false end
    -- Sequential W2/W3: use full recorded room positions, regardless of the
    -- legacy per-room AutoRouteEnabled booleans from old configurations.
    if world == "World1" then
        local diff=Runtime.CurrentWorld1Diff()
        if World1BeginnerByDiff[diff] then
            return r>=2 and validPosition(World1BeginnerByDiff[diff][r])
        end
        if diff~=5 then return false end -- Diff4 incomplete / unknown
        local p=RecordedCoordinates.World1 and RecordedCoordinates.World1[r]
        return r>=2 and validPosition(p)
    end
    if (world == "World2" or world == "World3") and r >= 2 then
        local p = RecordedCoordinates[world] and RecordedCoordinates[world][r]
        return validPosition(p)
    end
    return AutoRouteEnabled[world] and AutoRouteEnabled[world][r] == true or false
end

function Runtime.GetRecordedCoordinate(world, room)
    local r=tonumber(room)
    if not world or not r then return nil end
    if world=="World1" then
        local diff=Runtime.CurrentWorld1Diff()
        local beginner=World1BeginnerByDiff[diff]
        if beginner then
            local p=beginner[r]
            return validPosition(p) and p or nil
        end
        if diff~=5 then return nil end -- never load W1 Diff5 into Diff4 or unknown
    end
    local p=RecordedCoordinates[world] and RecordedCoordinates[world][r]
    return validPosition(p) and p or nil
end

function Runtime.SetAutoRouteEnabled(world, room, enabled, markUnsaved)
	local r = tonumber(room)
	assert(type(world) == "string" and r and r >= 1 and r <= 20 and r % 1 == 0, "World/Room không hợp lệ")
    assert(not ((world == "World2" or world == "World3") or
         (world == "World1" and Runtime.CurrentWorld1Diff() == 5)) or enabled == true,
        "Sequential Route tự dùng tọa độ: không tắt riêng Room; muốn dừng hãy tắt Auto Combat")
	AutoRouteEnabled[world] = AutoRouteEnabled[world] or {}
	AutoRouteEnabled[world][r] = (enabled == true)
	if markUnsaved ~= false then UnsavedRouteChanges = true end
	syncRouteTablesToConfig()
	if markUnsaved ~= false then Runtime.SaveRoutesJSON() else saveConfig() end
	Runtime.Log(string.format("AUTO_ROUTE_TOGGLE %s Room %d -> %s (coordinate preserved=%s)",
		world, r, tostring(enabled == true), tostring(Runtime.GetRecordedCoordinate(world, r) ~= nil)))
	if Runtime.RefreshRecordUI then pcall(Runtime.RefreshRecordUI) end
end

function Runtime.SetRecordedCoordinate(world, room, coord, srcLabel, autoSaveJson)
	local r = tonumber(room)
	assert(type(world) == "string" and r and r >= 1 and r <= 20 and r % 1 == 0, "World/Room không hợp lệ")
	assert(validPosition(coord), "Tọa độ không hợp lệ (cần 3 hoặc 12 số thực chuẩn trực giao)")
	RecordedCoordinates[world] = RecordedCoordinates[world] or {}
	sources[world] = sources[world] or {}
	AutoRouteEnabled[world] = AutoRouteEnabled[world] or {}
	RecordedCoordinates[world][r] = table.clone(coord)
	sources[world][r] = srcLabel or "Recorder-v1.3-Runtime"
    Config.AutoFallbackRooms[world] = Config.AutoFallbackRooms[world] or {}
    Config.AutoFallbackRooms[world][tostring(r)] = (srcLabel == "AUTO-FALLBACK") and true or nil
	if AutoRouteEnabled[world][r] == nil then
		AutoRouteEnabled[world][r] = (DefaultAutoRouteEnabled[world] and DefaultAutoRouteEnabled[world][r] == true) or false
	end
	UnsavedRouteChanges = true
	syncRouteTablesToConfig()
	saveConfig()
	Runtime.Log(string.format("RECORD_COORD_SAVED %s Room %d (%s) AutoTP=%s",
		world, r, sources[world][r], tostring(AutoRouteEnabled[world][r] == true)))
	if autoSaveJson then
		Runtime.SaveRoutesJSON()
	end
	if Runtime.RefreshRecordUI then pcall(Runtime.RefreshRecordUI) end
end

function Runtime.SaveRoutesJSON()
	assert(not Runtime.RouteJSONLocked, "Route JSON hiện có bị lỗi; không được ghi đè trước khi khôi phục/đổi tên thủ công.")
	assert(typeof(writefile) == "function", "Executor không hỗ trợ writefile; chỉ lưu trong phiên")
	if typeof(isfile) == "function" and isfile(RouteFile) and typeof(readfile) == "function" then
		local okRead, oldRaw = pcall(readfile, RouteFile)
		if okRead and type(oldRaw) == "string" and #oldRaw > 0 then
			if typeof(isfile) == "function" and not isfile(RouteBackupFile) then
				writefile(RouteBackupFile, oldRaw) -- immutable original safety backup
			end
			writefile("IronSoul_RoomRoutes_Previous_v3.json", oldRaw)
			Runtime.Log("ROUTE_JSON_BACKUP original + previous preserved")
		end
	end
	local payload = {
		Version = "v23_route_hotfix_v2",
		SavedAt = os.time(),
		RecordedCoordinates = {},
		AutoRouteEnabled = {}
	}
	for _, world in ipairs(AllRouteWorlds) do
		payload.RecordedCoordinates[world] = {}
		payload.AutoRouteEnabled[world] = {}
		payload[world] = {} -- Tương thích ngược với cấu trúc JSON cũ
		for room, coord in pairs(RecordedCoordinates[world] or {}) do
			if validPosition(coord) then
				local copy = table.clone(coord)
				payload.RecordedCoordinates[world][tostring(room)] = copy
				payload[world][tostring(room)] = copy
			end
		end
		for room, enabled in pairs(AutoRouteEnabled[world] or {}) do
			payload.AutoRouteEnabled[world][tostring(room)] = (enabled == true)
		end
	end
	local encoded = HttpService:JSONEncode(payload)
	writefile(RouteFile, encoded)
	UnsavedRouteChanges = false
	syncRouteTablesToConfig()
	saveConfig()
	Runtime.Log("ROUTE_JSON_SAVED " .. RouteFile)
	if Runtime.RefreshRecordUI then pcall(Runtime.RefreshRecordUI) end
	return true
end

function Runtime.ReloadRoutes(forceReload)
	assert(not Runtime.RouteBusy, "Chờ chuyển room xong trước khi reload")
	if UnsavedRouteChanges and not forceReload then
		local now = os.clock()
		if now > pendingReloadConfirmUntil then
			pendingReloadConfirmUntil = now + 10
			StatusLbl.Text = "CẢNH BÁO: Có tọa độ/AutoTP vừa sửa chưa lưu JSON! Bấm Reload lần nữa trong 10s để ghi đè."
			Runtime.Log("ROUTE_RELOAD_WARN unsaved runtime changes; press again within 10s to confirm")
			return false
		end
	end
	pendingReloadConfirmUntil = 0
	local decoded
	if typeof(isfile) == "function" and isfile(RouteFile) then
		local ok, value = pcall(function() return HttpService:JSONDecode(readfile(RouteFile)) end)
		if not ok or type(value) ~= "table" then
			Runtime.RouteJSONLocked = true
			error("Route JSON lỗi; FILE ĐƯỢC KHÓA KHÔNG CHO GHI ĐÈ: " .. tostring(value))
		end
		Runtime.RouteJSONLocked = false
		decoded = value
	end
	local freshCoords, freshAuto, provenance = {}, {}, {}
	local jsonCoords = decoded and (type(decoded.RecordedCoordinates) == "table" and decoded.RecordedCoordinates or decoded) or nil
	local jsonAuto = decoded and type(decoded.AutoRouteEnabled) == "table" and decoded.AutoRouteEnabled or nil

	for _, world in ipairs(AllRouteWorlds) do
		freshCoords[world], freshAuto[world], provenance[world] = {}, {}, {}
		-- 1. Nạp từ Seed mặc định (World5 để trống, không tự bịa tọa độ)
		for roomKey, seedCoord in pairs(SeedRecordedCoordinates[world] or {}) do
            -- v4.6 imported World2/World3 with ["1"], ["2"], etc.
            -- Numeric runtime keys are REQUIRED by GetRecordedCoordinate and RoomList.
            local room = tonumber(roomKey)
            if room and room >= 1 and room <= 20 and room % 1 == 0 and validPosition(seedCoord) then
                freshCoords[world][room] = table.clone(seedCoord)
                provenance[world][room] = world == "World4" and "Recorder-v1.3-seed-CFrame" or "embedded-coordinate"
            end
        end
		-- 2. Nạp từ Config đã lưu (nếu có)
		if type(Config.RecordedCoordinates) == "table" and type(Config.RecordedCoordinates[world]) == "table" then
			for rStr, c in pairs(Config.RecordedCoordinates[world]) do
				local r = tonumber(rStr)
				if r and validPosition(c) then
					freshCoords[world][r] = table.clone(c)
					provenance[world][r] = "Config-Saved"
				end
			end
		end
		-- 3. Nạp toàn bộ tọa độ hợp lệ từ JSON (kể cả Room đang OFF Auto TP như W1 R3, R6)
		if type(jsonCoords) == "table" and type(jsonCoords[world]) == "table" then
			for rStr, c in pairs(jsonCoords[world]) do
				local r = tonumber(rStr)
				if r and r >= 1 and r <= 20 and validPosition(c) then
					freshCoords[world][r] = table.clone(c)
					provenance[world][r] = "JSON"
				elseif r then
					Runtime.Log("ROUTE_DATA " .. world .. "/" .. tostring(r) .. ": JSON không hợp lệ; giữ fallback")
				end
			end
		end
		-- 4. Khôi phục AutoRouteEnabled: Mặc định -> Config -> JSON
		for r, defVal in pairs(DefaultAutoRouteEnabled[world] or {}) do
			freshAuto[world][r] = (defVal == true)
		end
		if type(Config.AutoRouteEnabled) == "table" and type(Config.AutoRouteEnabled[world]) == "table" then
			for rStr, bVal in pairs(Config.AutoRouteEnabled[world]) do
				local r = tonumber(rStr)
				if r and type(bVal) == "boolean" then
					freshAuto[world][r] = bVal
				end
			end
		end
		if type(jsonAuto) == "table" and type(jsonAuto[world]) == "table" then
			for rStr, bVal in pairs(jsonAuto[world]) do
				local r = tonumber(rStr)
				if r and type(bVal) == "boolean" then
					freshAuto[world][r] = bVal
				end
			end
		end
		-- Tuyệt đối không tự bật World5 nếu không có xác nhận thủ công
		if world == "World5" and not (jsonAuto and jsonAuto.World5) and not (Config.AutoRouteEnabled and Config.AutoRouteEnabled.World5) then
			freshAuto.World5 = {}
		end
	end

    -- First v4.6 injection only: import the uploaded FULL W2/W3 room CFrames and
    -- Mob Spawn Anchors. Preserve World1/4/5/Endless as loaded from JSON.
    local doSequentialImport = Config.SequentialW23ImportVersion ~= SequentialImportVersion
    if doSequentialImport then
        for _, w in ipairs({"World2", "World3"}) do
            for roomStr, pos in pairs(SequentialImportedCoordinates[w]) do
                local r = tonumber(roomStr)
                assert(r and validPosition(pos), "Invalid uploaded W2/W3 CFrame "..w.."/"..tostring(roomStr))
                freshCoords[w][r] = table.clone(pos)
                provenance[w][r] = "UserJSON-20261107"
            end
            Config.SpawnAnchors[w] = Config.SpawnAnchors[w] or {}
            for roomStr, anchor in pairs(SequentialImportedAnchors[w]) do
                Config.SpawnAnchors[w][tostring(roomStr)] = table.clone(anchor)
            end
        end
        Runtime.SpawnAnchors = Config.SpawnAnchors
    end
    -- Legacy OFF flags no longer gate W2/W3. Keep the on-disk config consistent
    -- with sequential behaviour; user edits to later coordinates remain editable.
    for _,w in ipairs({"World2","World3"}) do
        for roomKey, p in pairs(freshCoords[w]) do
            local r = tonumber(roomKey)
            if r and r >= 2 and r <= 20 and r % 1 == 0 and validPosition(p) then
                freshAuto[w][r] = true
            end
        end
    end

    -- Canonicalize all Room keys once at the boundary, including legacy JSON
    -- with string keys. Preserve the merge-precedence that has already run.
    for _, world in ipairs(AllRouteWorlds) do
        local canonical = {}
        local canonicalSources = {}
        for key, p in pairs(freshCoords[world]) do
            local r = tonumber(key)
            if r and r >= 1 and r <= 20 and r % 1 == 0 and validPosition(p) then
                if type(key) == "number" or canonical[r] == nil then
                    canonical[r] = p
                    canonicalSources[r] = provenance[world][key]
                end
            end
        end
        freshCoords[world] = canonical
        provenance[world] = canonicalSources
    end

	for _, world in ipairs(AllRouteWorlds) do
		RecordedCoordinates[world] = freshCoords[world]
		AutoRouteEnabled[world] = freshAuto[world]
		sources[world] = provenance[world]
		local cCount, aCount = 0, 0
		for _ in pairs(RecordedCoordinates[world]) do cCount = cCount + 1 end
		for _, v in pairs(AutoRouteEnabled[world]) do if v == true then aCount = aCount + 1 end end
		Runtime.Log(string.format("ROUTE_DATA %s recorded=%d autoEnabled=%d", world, cCount, aCount))
	end
    UnsavedRouteChanges = false
    syncRouteTablesToConfig()
    if doSequentialImport then
        -- Only mark migration successful if both JSON and Config saves work.
        -- If unavailable, keep using embedded data in this session and retry later.
        Config.SequentialW23ImportVersion = SequentialImportVersion
        local ok, err = pcall(Runtime.SaveRoutesJSON)
        if not ok then
            Config.SequentialW23ImportVersion = ""
            Runtime.Log("SEQUENTIAL_IMPORT_RAM_ONLY "..tostring(err))
        else
            Runtime.Log("SEQUENTIAL_IMPORT_SAVED World2=7 World3=6; World4 unchanged")
        end
    end
    if Runtime.RefreshRecordUI then pcall(Runtime.RefreshRecordUI) end
    StatusLbl.Text = string.format("Route OK | W2: %d rooms | W3: %d rooms | W4 unchanged",
        (function() local n=0 for _ in pairs(RecordedCoordinates.World2 or {}) do n=n+1 end return n end)(),
        (function() local n=0 for _ in pairs(RecordedCoordinates.World3 or {}) do n=n+1 end return n end)())
    return true
end

-- Transition States chuẩn chống teleport lặp
local TRANSITION_STATES = {
	WAIT_CLEAR = "WAIT_CLEAR",
	LOOT_CHECK = "LOOT_CHECK",
	TP_IN_PROGRESS = "TP_IN_PROGRESS",
	ARRIVED = "ARRIVED",
	WAIT_ROOM_UPDATE = "WAIT_ROOM_UPDATE",
	ACTIVATED = "ACTIVATED",
	COMPLETED = "COMPLETED",
	RETRY_WAIT = "RETRY_WAIT",
	FAILED = "FAILED"
}
Runtime.TransitionStates = TRANSITION_STATES

local state = {
	Version = 4,
	Run = 0,
	TransitionState = TRANSITION_STATES.WAIT_CLEAR,
	Portals = {},
	ClearedRoomDone = {},
	EndlessEntryDone = false,
	EndlessAttempted = false
}
if previous and type(previous.RouteState) == "table" then
	local old = previous.RouteState
	for _, key in ipairs({"Run","Initialized","World","Round","Cfg","Lobby","WasSettlement","EndlessEntryDone","EndlessAttempted","EndlessEligible","EndlessTestPassed"}) do
		state[key] = old[key]
	end
	state.Run = state.Run or 0
	if old.Version == 4 or old.Version == 3 then
		for key, value in pairs(old.Portals or {}) do
			state.Portals[key] = table.clone(value)
		end
		for key, value in pairs(old.ClearedRoomDone or {}) do
			state.ClearedRoomDone[key] = value
		end
		if old.Active and state.Portals[old.Active.Key] then
			local portal = state.Portals[old.Active.Key]
			portal.NextAt = os.clock() + 0.6
			portal.Blocked = (portal.Attempts or 0) >= 2 and not portal.Landed
		end
	end
end
Runtime.RouteState = state

local function setTransitionState(newState, portal, reason)
	if state.TransitionState ~= newState then
		Runtime.Log("TRANSITION_STATE " .. tostring(state.TransitionState) .. " -> " .. tostring(newState) .. (reason and (" (" .. tostring(reason) .. ")") or ""))
		state.TransitionState = newState
	end
	if portal then
		portal.State = newState
		if reason then portal.Reason = reason end
	end
	if state.Active then
		state.Active.Stage = newState
	end
end

local function currentRoundInfo()
	local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	if not cfg then return nil, nil, nil end
	return cfg:GetAttribute("WorldId"), cfg:GetAttribute("GameRound"), cfg:GetAttribute("GameRoundComplete")
end
local function observed()
	local world, room, complete = currentRoundInfo()
	return ReplicatedStorage:FindFirstChild("GameRoundCfg"), world, room, complete
end
function Runtime.CurrentRouteInfo() return currentRoundInfo() end
local function keyFor(world, room, dest) return tostring(world)..":"..tostring(room).."->"..tostring(dest) end
local function clearEventKey(world, room) return tostring(state.Run)..":"..tostring(world)..":clear:"..tostring(room) end
function Runtime.RouteAttemptLimit(world)
    return (world=="World1" and World1BeginnerByDiff[Runtime.CurrentWorld1Diff()]~=nil) and 4 or 2
end
local function getPortal(world, room, dest)
	local key = keyFor(world, room, dest)
	if not state.Portals[key] then
		state.Portals[key] = {
			Attempts = 0,
			NextAt = 0,
			World = world,
			Room = room,
			Destination = dest,
			State = TRANSITION_STATES.WAIT_CLEAR,
			Reason = "not attempted"
		}
	end
	return state.Portals[key], key
end

function Runtime.RouteDiagnostic(reason, force)
	if reason then state.GateReason = reason end
	local _, world, room, complete = observed()
	local dest = type(room) == "number" and room + 1 or "?"
	if world == "Endless1" then dest = 2 end
	local p = state.Portals[keyFor(world, room, dest)]
	local hasCoord = Runtime.GetRecordedCoordinate(world, dest) ~= nil
	local autoOn = Runtime.IsAutoRouteEnabled(world, dest)
	local source = (sources[world] and sources[world][dest]) or (hasCoord and "Recorded" or "NONE")
	local line = string.format(
		"World=%s Room=%s Complete=%s dest=%s Hybrid=%s AutoRoute=%s Coord=%s(%s) State=%s LootActive=%s LootBlocked=%s Ray=%s Blocked=%s Attempts=%s Confirmed=%s Owner=%s Reason=%s",
		tostring(world), tostring(room), tostring(complete), tostring(dest),
		tostring(Config.HybridRoute), tostring(autoOn), tostring(hasCoord), source,
		tostring(p and p.State or state.TransitionState),
		tostring(Runtime.LootActive == true), tostring(Runtime.LootBlocked == true),
		p and (p.LastRay or "not-run") or "not-run",
		tostring(p and p.Blocked == true or false),
		tostring(p and p.Attempts or 0),
		tostring(p and p.Confirmed == true or false),
		Runtime.Owner and Runtime.Owner.Name or "none",
		tostring(reason or state.GateReason or (p and p.Reason) or "idle")
	)
	local now = os.clock()
	if force or (line ~= state.LastDiagnostic and now - (state.LastDiagnosticAt or -math.huge) >= 1) or now - (state.LastDiagnosticAt or -math.huge) >= 5 then
		Runtime.Log("ROUTE_CHECK " .. line)
		state.LastDiagnostic, state.LastDiagnosticAt = line, now
	end
end

local function releaseMovement(active, updatePatrolOrigin)
	Runtime.Release(active.Token)
	Runtime.RouteBusy = false
	if updatePatrolOrigin and active.Root and active.Root.Parent then
		patrol.Origin, patrol.Index = active.Root.Position, 0
		Runtime.Log("PATROL_ORIGIN_UPDATED after destination arrival confirmed")
	end
end

local function finishFailure(active, reason, recoverFall)
	local portal = state.Portals[active.Key]
	if recoverFall and LocalPlayer.Character == active.Character and active.Humanoid.Health > 0 and not GamePlaceUtil:IsMain() and not isTransitioning() then
		local ok, err = pcall(function()
			active.Root.AssemblyLinearVelocity, active.Root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			if active.CF then
				active.Character:PivotTo(active.CF + Vector3.new(0, 8, 0))
				Runtime.Log("ROUTE_VOID_RECOVERY placed at targetCF + 8Y")
			else
				active.Character:PivotTo(active.Origin)
				Runtime.Log("ROUTE_VOID_RECOVERY placed back at Origin")
			end
		end)
		if not ok then Runtime.Log("ROUTE_RECOVERY_FAILED " .. tostring(err)) end
	end
	releaseMovement(active, false)
	Runtime.RouteAwaitingSpawn = false
	if portal then
		if active.Manual and not active.Endless then portal.Attempts = math.max(0, portal.Attempts - 1) end
		portal.Reason = tostring(reason)
		portal.NextAt = os.clock() + 1.5
		portal.Blocked = (portal.Attempts >= Runtime.RouteAttemptLimit(active.World))
		portal.Landed = false -- ARRIVED without activation must remain retryable.
		setTransitionState(portal.Blocked and TRANSITION_STATES.FAILED or TRANSITION_STATES.RETRY_WAIT, portal, reason)
	else
		setTransitionState(TRANSITION_STATES.FAILED, nil, reason)
	end
	state.Active = nil
	Runtime.Log("ROUTE_FAILED " .. active.Key .. " reason=" .. tostring(reason) .. " attempts=" .. tostring(portal and portal.Attempts or 0) .. "; AutoFarm/Combat unlocked")
	StatusLbl.Text = string.format("Status: Route %s lỗi (%s); trả quyền cho Auto Farm", active.Key, tostring(reason):sub(1, 55))
	Runtime.RouteDiagnostic(reason, true)
end

function Runtime.CancelRoute(reason)
	if state.Active then finishFailure(state.Active, reason or "cancelled", false) end
end

function Runtime.ResetRouteRun(reason)
	if state.Active then releaseMovement(state.Active, false) end
	state.Active = nil
	state.Run = (state.Run or 0) + 1
	state.TransitionState = TRANSITION_STATES.WAIT_CLEAR
	state.Portals = {}
	state.ClearedRoomDone = {}
    state.SequentialClearAt = {}
    state.W1EnemySeen = {}
    state.W1RoomSync = {}
	state.GateReason = nil
	state.ManualPause = false
	state.EndlessEntryDone, state.EndlessAttempted = false, false
	state.EndlessEligible = reason ~= "initial-injection"
	Runtime.RouteAwaitingSpawn = false
	Runtime.LootBlocked, Runtime.LootSkippedRoom = false, nil
	Runtime.Log("ROUTE_RUN " .. state.Run .. " " .. reason)
end

function Runtime.ObserveRouteRun()
	local cfg, world, round = observed()
	local lobby = GamePlaceUtil:IsMain()
	if not lobby and (type(world) ~= "string" or type(round) ~= "number") then return end
	if not state.Initialized then
		state.Initialized = true
		Runtime.ResetRouteRun("initial-injection")
	elseif lobby ~= state.Lobby or world ~= state.World or cfg ~= state.Cfg
		or (type(round) == "number" and type(state.Round) == "number" and round < state.Round)
		or (state.WasSettlement and LocalPlayer:GetAttribute("Settlement") ~= true) then
		Runtime.ResetRouteRun("observed-new-map-or-run")
	elseif type(round) == "number" and type(state.Round) == "number" and round > state.Round then
		if not state.Active then
			setTransitionState(TRANSITION_STATES.WAIT_CLEAR, nil, "advanced to room " .. tostring(round))
		end
	end
	state.Lobby, state.World, state.Round, state.Cfg = lobby, world, round, cfg
	state.WasSettlement = LocalPlayer:GetAttribute("Settlement") == true
end

-- v4.9.39 World1 low-difficulty recovery. Some beginner maps increment
-- GameRound before the character physically reaches the newly reported room.
-- This can leave a clone in the preceding room with no usable clear signal.
function Runtime.W1BeginnerRoom(world,room)
    local diff=Runtime.CurrentWorld1Diff()
    return world=="World1" and World1BeginnerByDiff[diff]~=nil
        and type(room)=="number" and room>=1 and room<=#World1BeginnerByDiff[diff]
end
function Runtime.W1SeenKey(world,room)
    return tostring(state.Run)..":"..tostring(Runtime.CurrentWorld1Diff())..":"..tostring(room)
end
function Runtime.W1MarkEnemySeen(world,room,enemyRoot)
    if not Runtime.W1BeginnerRoom(world,room) or not enemyRoot then return end
    local p=Runtime.GetRecordedCoordinate(world,room)
    if not p then return end
    local origin=Vector3.new(p[1],p[2],p[3])
    if (Vector3.new(enemyRoot.Position.X-origin.X,0,enemyRoot.Position.Z-origin.Z)).Magnitude>180 then return end
    state.W1EnemySeen=state.W1EnemySeen or {}
    local key=Runtime.W1SeenKey(world,room)
    local data=state.W1EnemySeen[key] or {First=os.clock()}
    data.Last=os.clock()
    state.W1EnemySeen[key]=data
end
function Runtime.W1ObservedClear(world,room)
    if not Runtime.W1BeginnerRoom(world,room) or not Runtime.RouteExpected then return false end
    local data=state.W1EnemySeen and state.W1EnemySeen[Runtime.W1SeenKey(world,room)]
    if not data or os.clock()-(data.Last or os.clock())<9 then return false end
    if not Runtime.GetRecordedCoordinate(world,room+1) then return false end
    if LocalPlayer:GetAttribute("Settlement")==true or GamePlaceUtil:IsMain() then return false end
    local resultGui=PlayerGui:FindFirstChild("ResultGui")
    local screen=resultGui and resultGui:FindFirstChild("ScreenSettlement")
    if screen and screen.Visible then return false end
    -- A tagless enemy from the previous/future room must not be used as proof
    -- the room cleared. Search near the current recorded entry, not the player.
    local p=Runtime.GetRecordedCoordinate(world,room)
    if not p then return false end
    local anchor=Vector3.new(p[1],p[2],p[3])
    local enemyTag=GameEnum and GameEnum.HumanTag and GameEnum.HumanTag.EnemyNpc or "EnemyNpc"
    for _,mob in ipairs(CollectionService:GetTagged(enemyTag)) do
        if isAliveEnemy(mob) then
            local er=getModelRoot(mob)
            local valid=select(1,getEnemyRoomContext(mob,world,room))
            if valid and er and (Vector3.new(er.Position.X-anchor.X,0,er.Position.Z-anchor.Z)).Magnitude<190 then
                data.Last=os.clock()
                return false
            end
        end
    end
    if not data.Announced then
        data.Announced=true
        Runtime.Log("W1_CLEAR_FALLBACK "..Runtime.W1SeenKey(world,room).." mobs previously seen, no mob for >=9s")
    end
    return true
end
function Runtime.W1SyncCurrentRoom(char,root,hum)
    local world,room=Runtime.CurrentRouteInfo()
    if not Runtime.W1BeginnerRoom(world,room) or room<2 or not Config.HybridRoute
        or not combatFarmEnabled() or not char or not root or not hum or hum.Health<=0
        or Runtime.Owner or Runtime.RouteBusy or Runtime.DeathRecovery
        or isTransitioning() or GamePlaceUtil:IsMain()
        or (state.Active~=nil) then return false end
    local p=Runtime.GetRecordedCoordinate(world,room)
    if not p then return false end
    local target=Vector3.new(p[1],p[2],p[3])
    local horizontal=(Vector3.new(root.Position.X-target.X,0,root.Position.Z-target.Z)).Magnitude
    if horizontal<125 then return false end
    state.W1RoomSync=state.W1RoomSync or {}
    local key=Runtime.W1SeenKey(world,room)
    local sync=state.W1RoomSync[key] or {First=os.clock(),Attempts=0,Next=0}
    state.W1RoomSync[key]=sync
    if os.clock()-sync.First<1.5 or os.clock()<sync.Next or sync.Attempts>=2 then return false end
    -- No blind teleport while actively fighting living mobs at the current
    -- physical location. Prefer the reported room when it is actually far away.
    local enemy,enemyRoot=findNearestEnemy(root.Position,false)
    if enemy and enemyRoot and (enemyRoot.Position-root.Position).Magnitude<70 then return false end
    sync.Attempts=sync.Attempts+1
    sync.Next=os.clock()+4
    task.spawn(function() pcall(function() LocalPlayer:RequestStreamAroundAsync(target,2) end) end)
    char:PivotTo(CFrame.new(table.unpack(p)) + Vector3.new(0,5,0))
    root.AssemblyLinearVelocity,root.AssemblyAngularVelocity=Vector3.zero,Vector3.zero
    Runtime.Log(string.format("W1_ROOM_SYNC Diff%d Room%d attempt=%d from horizontal %.1f studs",Runtime.CurrentWorld1Diff(),room,sync.Attempts,horizontal))
    return true
end

function Runtime.RouteExpected()
	local _, world, room = observed()
	if not Config.HybridRoute or world == "Endless1" or type(room) ~= "number" then return false end
	local dest = room + 1
	return Runtime.IsAutoRouteEnabled(world, dest) and Runtime.GetRecordedCoordinate(world, dest) ~= nil
end

local function groundAt(target, char)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {char}
	return Workspace:Raycast(target.Position + Vector3.new(0, 25, 0), Vector3.new(0, -95, 0), params)
end

local function nearDestinationEnemy(active)
	local enemy, enemyRoot = findNearestEnemy(active.Root.Position, true)
	if not enemy or not enemyRoot then return false end
	return (enemyRoot.Position - active.CF.Position).Magnitude <= 130 and (active.Root.Position - active.CF.Position).Magnitude <= 130
end

local function confirmTransition(active, evidence)
	local portal = state.Portals[active.Key]
	if portal then
		portal.Confirmed = true
		portal.Landed = true
		portal.Blocked = false
	end
	state.ClearedRoomDone[clearEventKey(active.World, active.Room)] = true
	setTransitionState(TRANSITION_STATES.COMPLETED, portal, evidence)
	releaseMovement(active, true)
	Runtime.RouteAwaitingSpawn = false
	state.Active = nil
	state.GateReason = evidence
	Runtime.Log("ROUTE_CONFIRMED " .. active.Key .. " state=COMPLETED evidence=" .. evidence)
	if active.Endless then state.EndlessEntryDone, state.EndlessTestPassed = true, true end
end

function Runtime.TickRoute()
	local active = state.Active
	if not active then
		local _, world, round = observed()
		for key, p in pairs(state.Portals) do
			if p.World == world and p.Attempts > 0 and not p.Confirmed and round == p.Destination then
				p.Confirmed, p.Blocked = true, false
				state.ClearedRoomDone[clearEventKey(world, p.Room)] = true
				setTransitionState(TRANSITION_STATES.COMPLETED, p, "late GameRound=" .. tostring(round))
				Runtime.Log("ROUTE_CONFIRMED " .. key .. " " .. tostring(p.Reason))
			end
		end
		return
	end
	local ok, err = pcall(function()
		local cfg, world, room = observed()
		if not Runtime.Alive or LocalPlayer.Character ~= active.Character or Runtime.CharacterEpoch ~= active.Epoch or active.Humanoid.Health <= 0
			or GamePlaceUtil:IsMain() or isTransitioning() or cfg ~= active.Cfg or world ~= active.World then
			finishFailure(active, "character/map/run changed", false)
			return
		end
		if not active.Manual and (not combatFarmEnabled() or (not active.Endless and not Config.HybridRoute)) then
			finishFailure(active, "automation switched OFF", false)
			return
		end
		local portal = state.Portals[active.Key]
		local now = os.clock()
		local actual = active.Root.Position
		local horizontalDist = Vector3.new(actual.X - active.CF.Position.X, 0, actual.Z - active.CF.Position.Z).Magnitude
		local fullDist = (actual - active.CF.Position).Magnitude

		-- Bảo vệ rơi khỏi map (void/freefall sâu dưới đích)
		local fallenHeight = Workspace.FallenPartsDestroyHeight or -500
		if actual.Y < math.max(fallenHeight + 45, active.CF.Position.Y - 85) then
			Runtime.Log("ROUTE_FALL_DETECTED y=" .. string.format("%.1f", actual.Y) .. " targetY=" .. string.format("%.1f", active.CF.Position.Y))
			finishFailure(active, "rơi xuống dưới nền phòng đích (streaming/void)", true)
			return
		end

		if not active.Manual and not active.Endless and room == active.Destination then
			confirmTransition(active, "server GameRound=" .. tostring(room))
			return
		end
		if type(room) ~= "number" or (not active.Endless and room ~= active.Room) then
			finishFailure(active, "unexpected GameRound=" .. tostring(room), false)
			return
		end

		if active.Stage == TRANSITION_STATES.TP_IN_PROGRESS then
			if now < active.MinWaitAt then
				active.Root.AssemblyLinearVelocity = Vector3.zero
				active.Root.AssemblyAngularVelocity = Vector3.zero
				return
			end
            -- A saved room point may be AIRBORNE (player pressed SAVE while
            -- flying over mobs). No floor is REQUIRED to accept teleport.
            -- We still probe optional ground for a genuine below-floor rescue.
            local ground=groundAt(active.CF,active.Character)
            portal.LastRay=ground and "post-hit" or "AIRBORNE_RECORDED_OK"
			if ground and ground.Normal.Y > 0.5 and math.abs(ground.Position.Y - active.CF.Position.Y) < 18 and actual.Y < ground.Position.Y + 1.8 then
				local rescue = active.CF + Vector3.new(0, math.max(5, ground.Position.Y + 5 - active.CF.Position.Y), 0)
				active.Character:PivotTo(rescue)
				active.Root.AssemblyLinearVelocity = Vector3.zero
				active.Root.AssemblyAngularVelocity = Vector3.zero
				Runtime.Log("ROUTE_RESCUE " .. active.Key .. " groundY=" .. string.format("%.2f", ground.Position.Y))
				actual = active.Root.Position
				horizontalDist = Vector3.new(actual.X - active.CF.Position.X, 0, actual.Z - active.CF.Position.Z).Magnitude
				fullDist = (actual - active.CF.Position).Magnitude
			end
			if horizontalDist < 28 and actual.Y >= active.CF.Position.Y - 12 then
				portal.Landed, portal.Blocked = true, false
				-- Physical ARRIVED is not evidence of Room activation or successful completion.
				active.ArrivedAt = now
				setTransitionState(TRANSITION_STATES.ARRIVED, portal, "arrived at destination; updating patrol origin")
				releaseMovement(active, true)
				Runtime.RouteAwaitingSpawn = false
				setTransitionState(TRANSITION_STATES.WAIT_ROOM_UPDATE, portal, "arrived; combat unlocked while waiting GameRound/mob")
				Runtime.Log("ROUTE_ARRIVED " .. active.Key .. " dist=" .. string.format("%.2f", fullDist) .. " ray=" .. tostring(portal.LastRay))
				if active.Manual and not active.Endless then
					-- Recorder manual test never consumes an automatic transition or retry budget.
					portal.Attempts = math.max(0, portal.Attempts - 1)
					portal.Landed = false
					portal.Confirmed = false
					portal.Reason = "manual ARRIVED; user must verify PASS/FAIL"
					state.Active = nil
					setTransitionState(TRANSITION_STATES.WAIT_CLEAR, portal, "manual test finished; Hybrid paused until RESUME")
					Runtime.Log("RECORD_TEST_ARRIVED " .. active.Key .. " (manual; no auto success claimed)")
					return
				end
			else
				finishFailure(active, "landing lệch đích dist=" .. string.format("%.1f", fullDist), false)
				return
			end
		end

		if active.Stage == TRANSITION_STATES.ARRIVED or active.Stage == TRANSITION_STATES.WAIT_ROOM_UPDATE then
			if nearDestinationEnemy(active) then
				if active.Endless then
					-- Endless is a single combat room: visible combat spawn is the entry confirmation.
					confirmTransition(active, "Endless mob spawned near recorded entry")
				else
					setTransitionState(TRANSITION_STATES.ACTIVATED, portal, "enemy spawned near destination; waiting GameRound")
					Runtime.Log("ROUTE_ACTIVATED " .. active.Key .. "; combat unlocked, awaiting GameRound")
				end
				return
			end
			if now - (active.ArrivedAt or active.Started) >= 12 then
				-- Without any activation evidence, retry safely. NEVER mark completed on timeout.
				finishFailure(active, "arrived but GameRound/mob did not activate within 12s", false)
				return
			end
		elseif active.Stage == TRANSITION_STATES.ACTIVATED then
			-- Combat may take time. Do not teleport again while enemies are active.
			if now - (active.LastPendingLogAt or active.ArrivedAt or now) >= 25 then
				active.LastPendingLogAt = now
				Runtime.Log("ROUTE_ACTIVATED_PENDING " .. active.Key .. "; waiting GameRound while Combat continues")
			end
		end
	end)
	if not ok and state.Active == active then
		finishFailure(active, "observer error: " .. tostring(err), false)
	end
end

function Runtime.RouteObservationActive()
	return state.Active ~= nil and (state.Active.Stage == TRANSITION_STATES.ARRIVED
		or state.Active.Stage == TRANSITION_STATES.WAIT_ROOM_UPDATE or state.Active.Stage == TRANSITION_STATES.ACTIVATED)
end

function Runtime.RouteLegacyReady()
	local _, world, room = observed()
	if type(room) ~= "number" then return false end
	if state.ClearedRoomDone[clearEventKey(world, room)] then return true end
	local portal = state.Portals[keyFor(world, room, room + 1)]
	return portal and (portal.Confirmed or portal.Attempts >= Runtime.RouteAttemptLimit(world)) or false
end

local function startTransition(char, root, hum, world, room, destination, manual, endless)
	assert(not state.Active and not Runtime.RouteBusy, "Đang trong tiến trình chuyển phòng (TP_IN_PROGRESS/WAIT_ROOM_UPDATE)")
	assert(not Runtime.Owner and not Runtime.EntryBusy and not Runtime.ForgeBusy, "Đang có tác vụ giữ quyền di chuyển")
	local cfg, currentWorld, currentRoom, complete = observed()
	assert(not GamePlaceUtil:IsMain() and not isTransitioning() and world == currentWorld and room == currentRoom, "Map/room đã thay đổi")
	assert(manual or endless or complete == room or
        (Runtime.W1ObservedClear and Runtime.W1ObservedClear(world,room)),
        "GameRoundComplete chưa bằng GameRound, chưa có bằng chứng room đã clear")
	if not manual and not endless then
		assert(Runtime.IsAutoRouteEnabled(world, destination), "AutoRouteEnabled đang OFF cho " .. tostring(world) .. " Room " .. tostring(destination))
		assert(not state.ClearedRoomDone[clearEventKey(world, room)], "Room này đã chuyển thành công trong lượt hiện tại")
	end
	local p = Runtime.GetRecordedCoordinate(world, destination)
	assert(validPosition(p), "Thiếu tọa độ RecordedCoordinates cho " .. tostring(world) .. " Room " .. tostring(destination))
	local portal, key = getPortal(world, room, destination)
	assert(portal.Attempts < Runtime.RouteAttemptLimit(world) or manual,
        "Đã hết giới hạn retry cho Room này; kiểm tra ROUTE_CHECK và quái")
	local targetCF = CFrame.new(table.unpack(p))
	local origin = char:GetPivot()
	local token = assert(Runtime.Acquire("ROOM_TRANSITION"), "Movement đang được sử dụng")
	local now = os.clock()
	local active = {
		Key = key,
		Token = token,
		Character = char,
		Root = root,
		Humanoid = hum,
		Epoch = Runtime.CharacterEpoch,
		Cfg = cfg,
		World = world,
		Room = room,
		Destination = destination,
		CF = targetCF,
		Origin = origin,
		Started = now,
		MinWaitAt = now + 0.55,
		StreamDeadline = now + 3.2,
		LastHoldPivot = now,
		Stage = TRANSITION_STATES.TP_IN_PROGRESS,
		Manual = manual,
		Endless = endless
	}
	portal.Attempts = portal.Attempts + 1
	portal.Confirmed, portal.Blocked, portal.Landed = false, false, false
	setTransitionState(TRANSITION_STATES.TP_IN_PROGRESS, portal, "teleporting +5 studs")
	state.GateReason = "TP_IN_PROGRESS"
	state.Active = active
	Runtime.RouteBusy = true
	local ok, err = pcall(function()
		stopPatrol()
        Runtime.HasCombatTarget, Runtime.HoverTarget = false, nil
        if Runtime.CleanupNightCombat then pcall(Runtime.CleanupNightCombat) end
		if Runtime.ClearTargets then Runtime.ClearTargets() end
		for part, value in pairs(Runtime.Collision) do if part.Parent then part.CanCollide = value end end
		table.clear(Runtime.Collision)
		portal.LastRay = "pending-post-TP"
		local src = (sources[world] and sources[world][destination]) or "Recorded"
		Runtime.Log(string.format("ROUTE_SELECTED %s source=%s attempt=%d xyz=%.2f,%.2f,%.2f", key, src, portal.Attempts, p[1], p[2], p[3]))
		char:PivotTo(active.CF + Vector3.new(0, 5, 0))
		root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		Runtime.Log("ROUTE_TELEPORT state=TP_IN_PROGRESS " .. key .. " manual=" .. tostring(manual))
	end)
	if not ok then finishFailure(active, tostring(err), false) end
	return Runtime.RouteBusy
end

-- v4.9.50 RECOVERY WORKER LOCK: release stale non-transactional locks only.
-- Never resend an uncertain Forge/Sell request or clear the Forge safety flag.
;(function()
    local lastReported=-100
    function Runtime.RecoverWorkerLocks(manual)
        if not Runtime.Alive then return 0 end
        local fixed=0
        local now=os.clock()
        local token=Runtime.Owner
        if token and token.Epoch~=Runtime.CharacterEpoch then
            if token.Name=="ROOM_TRANSITION" and Runtime.RouteBusy
                and Runtime.CancelRoute then
                pcall(Runtime.CancelRoute,"WORKER_RECOVERY_CHANGED_CHARACTER")
            end
            if not Runtime.RouteBusy and not Runtime.ForgeBusy and not Runtime.BatchActive
                and not Runtime.ShopBusy and not Runtime.EntryBusy then
                Runtime.Log("WORKER_RECOVER_OWNER_STALE "..tostring(token.Name))
                Runtime.Owner=nil;fixed=fixed+1
            end
        elseif token and token.Name=="ROOM_TRANSITION" and not Runtime.RouteBusy
            and now-(token.Started or now)>12 then
            Runtime.Log("WORKER_RECOVER_ROUTE_OWNER_ORPHAN")
            Runtime.Owner=nil;fixed=fixed+1
        end
        if Runtime.EntryBusy and not isTransitioning()
            and now>(Runtime.EntryDeadline or (now+100))+12
            and not roomWaitingTeleport() then
            Runtime.Log("WORKER_RECOVER_ENTRY_TIMEOUT")
            Runtime.EntryBusy=false
            Runtime.ManualEntry=false
            Runtime.EntryDeadline=nil
            if Runtime.EntryHumanoid and Runtime.EntryHumanoid.Parent then
                pcall(function() Runtime.EntryHumanoid:MoveTo(Runtime.EntryHumanoid.RootPart.Position) end)
            end
            Runtime.EntryHumanoid=nil
            fixed=fixed+1
        end
        -- If a Forge is unresolved, quarantine the transaction and unblock
        -- COMBAT/DUNGEON, never sell/forge/equip while status is unknown.
        if Runtime.ForgeUncertain and Runtime.ForgeBusy
            and not Runtime.BatchActive and not Runtime.Owner then
            Runtime.ForgeBusy=false
            Runtime.AutoClearTrashErrorBlocked=true
            Runtime.Log("WORKER_RECOVER_FORGE_BUSY_QUARANTINED")
            fixed=fixed+1
        end
        if manual or fixed>0 then
            if manual or now-lastReported>5 then
                lastReported=now
                Runtime.Log("WORKER_LOCK_CHECK recovered="..fixed
                    .." owner="..tostring(Runtime.Owner and Runtime.Owner.Name or "idle")
                    .." forgeQuarantine="..tostring(Runtime.ForgeUncertain))
            end
        end
        return fixed
    end
    task.spawn(function()
        while Runtime.Alive do
            task.wait(3)
            if Runtime.Alive then
                local ok,err=pcall(Runtime.RecoverWorkerLocks,false)
                if not ok then Runtime.Log("WORKER_RECOVERY_ERROR "..tostring(err)) end
            end
        end
    end)
end)()
-- W1 Diff1/2/3 and W2/W3: never
-- transition while the result screen is present or the server indicates
-- the current room is the final one. Where no total is exposed, wait briefly
-- for the win/settlement transition to replicate before trying next room.
local function sequentialTerminalStatus(world, room)
    if world ~= "World2" and world ~= "World3" and
        not (world=="World1" and (World1BeginnerByDiff[Runtime.CurrentWorld1Diff()]~=nil
            or Runtime.CurrentWorld1Diff()==5)) then return nil end
    if LocalPlayer:GetAttribute("Settlement") == true then return "Settlement attribute" end
    local result = PlayerGui:FindFirstChild("ResultGui")
    local screen = result and result:FindFirstChild("ScreenSettlement")
    if screen and screen.Visible and (not result:IsA("ScreenGui") or result.Enabled) then
        return "Settlement UI visible"
    end
    local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
    if cfg then
        local explicitTotal = cfg:GetAttribute("TotalGameRound")
            or cfg:GetAttribute("GameRoundTotal")
            or cfg:GetAttribute("MaxGameRound")
            or cfg:GetAttribute("TotalRounds")
            or cfg:GetAttribute("RoomCount")
        local n = tonumber(explicitTotal)
        if n and n == math.floor(n) and n >= 1 and n <= 20 and room >= n then
            return "last room per server total=" .. tostring(n)
        end
    end
    return nil
end

function Runtime.TryRecordedRoute(char, root, hum)
	if state.Active then return Runtime.RouteBusy end
	if not Runtime.RouteExpected() then
		Runtime.RouteDiagnostic("Hybrid OFF or AutoRouteEnabled OFF or no coordinate")
		return false
	end
	local _, world, room, complete = observed()
	local dest = room + 1
	local portal = getPortal(world, room, dest)
	local reason
	if state.ManualPause then reason = "manual test paused Hybrid; press Resume"
	elseif complete ~= room and not (Runtime.W1ObservedClear and Runtime.W1ObservedClear(world,room)) then
		setTransitionState(TRANSITION_STATES.WAIT_CLEAR, portal, "waiting room clear")
		reason = "GameRoundComplete ~= GameRound"
    elseif (world == "World2" or world == "World3" or
        (world=="World1" and (World1BeginnerByDiff[Runtime.CurrentWorld1Diff()]~=nil
            or Runtime.CurrentWorld1Diff()==5))) then
        local terminal = sequentialTerminalStatus(world, room)
        if terminal then
            reason = "Sequential final room: " .. terminal
        else
            -- This key is reset with a new run. One bounded grace period is
            -- important on lower Difficulty whose last Room differs.
            state.SequentialClearAt = state.SequentialClearAt or {}
            local clearKey = clearEventKey(world, room)
            state.SequentialClearAt[clearKey] = state.SequentialClearAt[clearKey] or os.clock()
            if os.clock() - state.SequentialClearAt[clearKey] < 2.2 then
                reason = "waiting 2.2s for possible Settlement after clear"
            end
        end
    end
    if not reason and (Runtime.LootBlocked or Runtime.LootActive) then
		setTransitionState(TRANSITION_STATES.LOOT_CHECK, portal, "waiting valid loot")
		reason = "loot check in progress"
	elseif state.ClearedRoomDone[clearEventKey(world, room)] then
		reason = "room clear event already transitioned once"
	elseif portal.Confirmed then
		reason = "already server-confirmed"
	elseif portal.Attempts >= Runtime.RouteAttemptLimit(world) then
		setTransitionState(TRANSITION_STATES.FAILED, portal, "retry limit reached")
		reason = "retry limit reached; check room/target"
	elseif os.clock() < portal.NextAt then
		setTransitionState(TRANSITION_STATES.RETRY_WAIT, portal, "cooldown before retry")
		reason = "retry cooldown"
	elseif Runtime.Owner or Runtime.EntryBusy or Runtime.ForgeBusy then
		reason = "movement owned by another task"
	end
	if reason then Runtime.RouteDiagnostic(reason); return false end
	return startTransition(char, root, hum, world, room, dest, false, false)
end

function Runtime.TryEndlessEntry(char, root, hum, manual)
    -- Retire recorded-coordinate entry: native RoundDoor owns the transfer.
    -- Both automatic and manual entry use the same guarded walk, never TP.
    return Runtime.EndlessSafeEntryTick and Runtime.EndlessSafeEntryTick() or false
end

local okReload, errReload = pcall(Runtime.ReloadRoutes, true)
if not okReload then reportError("Route JSON", errReload) end
Runtime.ObserveRouteRun()

-- UI Tab Dungeon: Hybrid Route Controls
Scroll = Runtime.Tabs.Dungeon
addSectionHeader("Hybrid Route — RecordedCoordinates + AutoRouteEnabled")
addToggle("Hybrid Route (chỉ Auto TP các Room bật AutoRouteEnabled)", "HybridRoute")
routeButton("Reload Route JSON + kiểm tra thay đổi chưa lưu", function() Runtime.ReloadRoutes(false) end)
routeButton("LOG ROUTE: trạng thái Transition & điều kiện chặn", function() Runtime.RouteDiagnostic(nil, true) end)
routeButton("HỦY trạng thái chờ Hybrid (không dừng Auto Farm)", function()
	if Runtime.RouteState and Runtime.RouteState.Active then
		Runtime.CancelRoute("Người dùng hủy trạng thái WAIT_ROOM_UPDATE/ACTIVATED")
	else Runtime.Log("ROUTE_CANCEL manual: no active transition") end
end)
local preview = Instance.new("TextLabel", Scroll)
orderWidget(preview)
preview.Size = UDim2.new(0.94, 0, 0, 84)
preview.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
preview.TextColor3 = Color3.new(1, 1, 1)
preview.TextSize = 11
preview.TextWrapped = true
preview.Text = "Test thủ công: bấm lần 1 xem World/Room/XYZ, bấm lại trong 15s để TP +5 studs. Tạm dừng Hybrid sau test để tránh tranh quyền."
local pendingPreview
routeButton("TEST TP ROOM TIẾP THEO (THỦ CÔNG)", function()
	local _, world, room = observed()
	assert(not GamePlaceUtil:IsMain() and not isTransitioning() and type(room) == "number", "Chỉ test trong Dungeon đã tải")
	assert(world ~= "Endless1", "Dùng nút Test Endless Entry riêng")
	assert(not state.Active and not Runtime.Owner and not Runtime.EntryBusy and not Runtime.ForgeBusy, "Đang có tác vụ giữ quyền")
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	assert(root and hum and hum.Health > 0, "Nhân vật chưa sẵn sàng")
	if Runtime.ReconcileLoot then Runtime.ReconcileLoot(root) end
	assert(not Runtime.LootActive, "Loot đang hoạt động; hoàn tất/dừng loot trước khi test")
	local dest = room + 1
	local p = Runtime.GetRecordedCoordinate(world, dest)
	assert(validPosition(p), "Chưa có tọa độ trong RecordedCoordinates cho " .. tostring(world) .. " Room " .. tostring(dest))
	local signature = world .. ":" .. room .. ":" .. HttpService:JSONEncode(p)
	local autoFlag = Runtime.IsAutoRouteEnabled(world, dest) and "ON" or "OFF"
	preview.Text = string.format("%s | Room %d → %d (AutoTP=%s)\nXYZ %.2f, %.2f, %.2f | %s\nBấm lại trong 15s để TP thử; tự động bật ManualPause.",
		world, room, dest, autoFlag, p[1], p[2], p[3], tostring(sources[world] and sources[world][dest] or "Recorded"))
	if not pendingPreview or pendingPreview.Signature ~= signature or os.clock() > pendingPreview.Until then
		pendingPreview = {Signature = signature, Until = os.clock() + 15}
		Runtime.Log("ROUTE_MANUAL_PREVIEW " .. preview.Text)
		return
	end
	pendingPreview = nil
	state.ManualPause = true
	startTransition(char, root, hum, world, room, dest, true, false)
end)
routeButton("TIẾP TỤC Hybrid Route (Resume sau test thủ công)", function()
	assert(not state.Active, "Chờ kết thúc quan sát TP hiện tại")
	state.ManualPause = false
	Runtime.Log("ROUTE_MANUAL_PAUSE cleared; Hybrid resumed")
	StatusLbl.Text = "Status: Đã tiếp tục Hybrid Route sau test thủ công."
end)
routeButton("Đã kiểm tra: reset retry Room hiện tại", function()
	assert(not state.Active and not Runtime.Owner, "Đang có tác vụ")
	local _, world, room = observed()
	assert(type(room) == "number" and world ~= "Endless1", "Chỉ reset trong Dungeon")
	state.Portals[keyFor(world, room, room + 1)] = nil
	state.ClearedRoomDone[clearEventKey(world, room)] = nil
	setTransitionState(TRANSITION_STATES.WAIT_CLEAR, nil, "manual reset by user")
	Runtime.RouteDiagnostic("current room transition rearmed by user", true)
end)
routeButton("Test Endless Entry MỘT LẦN trong lượt này", function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	assert(not GamePlaceUtil:IsMain() and state.World == "Endless1" and root and hum and hum.Health > 0, "Chưa sẵn sàng trong Endless")
	assert(not state.EndlessAttempted, "Đã thử Entry trong lượt này")
	Runtime.TryEndlessEntry(char, root, hum, true)
end)
routeButton("XÁC NHẬN đã test Endless Entry hoạt động", function()
	assert(state.EndlessTestPassed, "Chưa có test với mob tại Entry")
	Config.EndlessEntryVerified = true; saveConfig()
end)
addToggle("Auto Endless Entry (cần xác nhận test)", "EndlessEntryEnabled")

-- UI Tab Record: Recorder v1.3 tích hợp đồng bộ với Hybrid Runtime
Scroll = Runtime.Tabs.Record
addSectionHeader("RECORDER v1.3 — ĐỒNG BỘ RUNTIME VỚI HYBRID")
local recLiveLbl = Instance.new("TextLabel",Scroll)
orderWidget(recLiveLbl)
recLiveLbl.Size=UDim2.new(0.94,0,0,38)
recLiveLbl.BackgroundColor3=Color3.fromRGB(35,48,56)
recLiveLbl.TextColor3=Color3.fromRGB(170,255,215)
recLiveLbl.TextSize=11
recLiveLbl.TextWrapped=true
recLiveLbl.Text="GameRoundCfg: chờ dữ liệu"
local recStatusLbl = Instance.new("TextLabel", Scroll)
orderWidget(recStatusLbl)
recStatusLbl.Size = UDim2.new(0.94, 0, 0, 96)
recStatusLbl.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
recStatusLbl.TextColor3 = Color3.fromRGB(220, 245, 255)
recStatusLbl.Font = Enum.Font.GothamSemibold
recStatusLbl.TextSize = 11
recStatusLbl.TextWrapped = true
recStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
recStatusLbl.Text = "Recorder sẵn sàng."

local recWorldItems = {
	{text = "World1 - Starless Forest", val = "World1"},
	{text = "World2 - Frozen Valley", val = "World2"},
	{text = "World3 - Oathlost Castle", val = "World3"},
	{text = "World4 - Tartarus", val = "World4"},
	{text = "World5 - Sakura Village (chưa xác minh)", val = "World5"},
	{text = "Endless1 - Endless Tower", val = "Endless1"}
}
local recRoomItems = {}
for r = 1, 10 do
	table.insert(recRoomItems, {text = "Room đích " .. r, val = r})
end
addDropdown("Recorder World", recWorldItems, "SelectedRecordWorld")
addDropdown("Recorder Room đích", recRoomItems, "SelectedRecordRoom")
local recRoomManual = Instance.new("TextBox",Scroll)
orderWidget(recRoomManual)
recRoomManual.Size=UDim2.new(0.94,0,0,29)
recRoomManual.BackgroundColor3=Color3.fromRGB(42,42,58)
recRoomManual.TextColor3=Color3.new(1,1,1)
recRoomManual.ClearTextOnFocus=false
recRoomManual.Text=tostring(Config.SelectedRecordRoom)
recRoomManual.PlaceholderText="Nhập Room 1..20 nếu không có trong danh sách"
recRoomManual.FocusLost:Connect(function()
	local n=tonumber(recRoomManual.Text)
	if n and n>=1 and n<=20 and n%1==0 then
		Config.SelectedRecordRoom=n
		saveConfig()
		if Runtime.RefreshRecordUI then Runtime.RefreshRecordUI() end
	else
		recRoomManual.Text=tostring(Config.SelectedRecordRoom)
		StatusLbl.Text="Room phải là số nguyên từ 1 đến 20"
	end
end)

-- XYZ editor: manually enter a coordinate without needing to stand there.
local recCoordFrame = Instance.new("Frame", Scroll)
orderWidget(recCoordFrame)
recCoordFrame.Size = UDim2.new(0.94, 0, 0, 34)
recCoordFrame.BackgroundTransparency = 1
local recCoordBoxes = {}
for i, axis in ipairs({"X","Y","Z"}) do
	local input = Instance.new("TextBox", recCoordFrame)
	input.Size = UDim2.new(1/3, -4, 1, 0)
	input.Position = UDim2.new((i-1)/3, 0, 0, 0)
	input.BackgroundColor3 = Color3.fromRGB(44,44,62)
	input.TextColor3 = Color3.new(1,1,1)
	input.ClearTextOnFocus = false
	input.PlaceholderText = axis
	input.TextSize = 12
	recCoordBoxes[i] = input
end
local recLastShownSelection
local recResultsFile = "IronSoul_RoomRoute_Results_v13.json"
local recResults = {}
pcall(function()
	if typeof(isfile)=="function" and isfile(recResultsFile) and typeof(readfile)=="function" then
		recResults=HttpService:JSONDecode(readfile(recResultsFile))
	end
end)
if type(recResults)~="table" then recResults={} end
local recList = Instance.new("ScrollingFrame", Scroll)
orderWidget(recList)
recList.Size = UDim2.new(0.94,0,0,210)
recList.BackgroundColor3 = Color3.fromRGB(30,30,43)
recList.ScrollBarThickness = 5
recList.AutomaticCanvasSize = Enum.AutomaticSize.Y
recList.CanvasSize = UDim2.new()
local recListLayout = Instance.new("UIListLayout",recList)
recListLayout.Padding = UDim.new(0,4)

local autoTpBtn = Instance.new("TextButton", Scroll)
orderWidget(autoTpBtn)
autoTpBtn.Size = UDim2.new(0.94, 0, 0, 32)
autoTpBtn.Font = Enum.Font.GothamBold
autoTpBtn.TextSize = 11
autoTpBtn.TextColor3 = Color3.new(1, 1, 1)

local function refreshRecList()
    -- Independent Recorder 1.5 is the supported editor; this hidden legacy list
    -- must never block AIO boot on fresh clone accounts or nested route tables.
    if not (Runtime.Tabs.Record and Runtime.Tabs.Record.Visible) then return end
	for _,child in ipairs(recList:GetChildren()) do
		if child~=recListLayout then child:Destroy() end
	end
	local w=tostring(Config.SelectedRecordWorld or "World1")
	local saved={}
	for room,p in pairs(RecordedCoordinates[w] or {}) do
		if validPosition(p) and tonumber(room) then saved[#saved+1]=tonumber(room) end
	end
	table.sort(saved)
	for _,roomNum in ipairs(saved) do
		local p=Runtime.GetRecordedCoordinate(w,roomNum)
        -- W1 Diff-specific routes can be present in the list but not in current legacy view.
        -- Never index p[1] unless the resolved coordinate is still valid.
        if type(p)~="table" or not validPosition(p)
            or not (tonumber(p[1]) and tonumber(p[2]) and tonumber(p[3])) then continue end
		local line=Instance.new("Frame",recList)
		line.Size=UDim2.new(1,-8,0,54)
		line.BackgroundColor3=Color3.fromRGB(38,38,53)
		local title=Instance.new("TextLabel",line)
		title.Size=UDim2.new(1,-2,0,24)
		title.BackgroundTransparency=1;title.TextXAlignment=Enum.TextXAlignment.Left
		title.TextSize=10;title.TextColor3=Color3.new(1,1,1)
		title.Text=string.format("R%d XYZ %.1f %.1f %.1f | AutoTP %s | %s",
			roomNum,p[1],p[2],p[3],Runtime.IsAutoRouteEnabled(w,roomNum) and "ON" or "OFF",
			recResults[w] and recResults[w][tostring(roomNum)] and recResults[w][tostring(roomNum)].Status or "--")
		for i,label in ipairs({"TP","SAVE","PASS","FAIL"}) do
			local btn=Instance.new("TextButton",line)
			btn.Position=UDim2.new((i-1)/4,1,0,26);btn.Size=UDim2.new(0.25,-3,0,25)
			btn.Text=label;btn.TextSize=11;btn.TextColor3=Color3.new(1,1,1)
			btn.BackgroundColor3=label=="FAIL" and Color3.fromRGB(138,46,57) or label=="PASS" and Color3.fromRGB(45,127,80) or Color3.fromRGB(48,83,130)
			btn.MouseButton1Click:Connect(function()
				local ok,err=pcall(function()
					Config.SelectedRecordWorld=w;Config.SelectedRecordRoom=roomNum
					recLastShownSelection=nil
					Runtime.RefreshRecordUI()
					if label=="TP" then Runtime.RecordManualTest(w,roomNum)
					elseif label=="SAVE" then Runtime.RecordSaveCurrent(w,roomNum)
					else Runtime.RecordMark(w,roomNum,label) end
				end)
				if not ok then reportError("Record "..label,err) end
			end)
		end
	end
end

function Runtime.RefreshRecordUI()
    if not (Runtime.Tabs.Record and Runtime.Tabs.Record.Visible) then return end
	local w = tostring(Config.SelectedRecordWorld or "World1")
	local r = tonumber(Config.SelectedRecordRoom) or 4
	recRoomManual.Text=tostring(r)
	local coord = Runtime.GetRecordedCoordinate(w, r)
	local choice = w..":"..tostring(r)
	if recLastShownSelection ~= choice then
		recLastShownSelection = choice
		for i=1,3 do recCoordBoxes[i].Text=coord and string.format("%.14g",coord[i]) or "" end
	end
	local autoOn = Runtime.IsAutoRouteEnabled(w, r)
	local src = (sources[w] and sources[w][r]) or (coord and "Recorded" or "CHƯA CÓ TỌA ĐỘ")
	autoTpBtn.BackgroundColor3 = autoOn and Color3.fromRGB(45, 155, 75) or Color3.fromRGB(130, 45, 55)
	autoTpBtn.Text = string.format("Auto TP cho [%s - Room %d]: %s (Giữ nguyên tọa độ khi OFF)", w, r, autoOn and "ON" or "OFF")
	local coordText = coord and string.format("%.2f, %.2f, %.2f (%d comp)", coord[1], coord[2], coord[3], #coord) or "Chưa lưu"
	local wSummary = {}
	for rm = 1, 10 do
		local hasC = Runtime.GetRecordedCoordinate(w, rm) ~= nil
		local isA = Runtime.IsAutoRouteEnabled(w, rm)
		if hasC or isA then
			table.insert(wSummary, string.format("R%d:%s/%s", rm, hasC and "XY" or "--", isA and "ON" or "OFF"))
		end
	end
	recStatusLbl.Text = string.format(
		"  Đang chọn: %s | Room %d | AutoTP: %s | UnsavedJSON: %s\n  Tọa độ: %s [%s]\n  Tổng quan %s: %s\n  Trạng thái Route: %s | ManualPause: %s",
		w, r, autoOn and "ON" or "OFF", UnsavedRouteChanges and "CÓ" or "KHÔNG",
		coordText, src, w, (#wSummary > 0 and table.concat(wSummary, ", ") or "Trống"),
		tostring(state.TransitionState), tostring(state.ManualPause == true)
	)
	refreshRecList()
end

autoTpBtn.MouseButton1Click:Connect(function()
	local w = tostring(Config.SelectedRecordWorld or "World1")
	local r = tonumber(Config.SelectedRecordRoom) or 4
	local nextState = not Runtime.IsAutoRouteEnabled(w, r)
	Runtime.SetAutoRouteEnabled(w, r, nextState, true)
	StatusLbl.Text = string.format("Status: %s Room %d AutoRouteEnabled = %s (Tọa độ vẫn giữ nguyên)", w, r, nextState and "ON" or "OFF")
end)

routeButton("Đồng bộ World/Room đang chọn theo GameRoundCfg hiện tại", function()
	local w, r = currentRoundInfo()
	assert(type(w) == "string" and type(r) == "number", "Hãy đứng trong Dungeon để đọc WorldId/GameRound")
	Config.SelectedRecordWorld = w
	Config.SelectedRecordRoom = r
	saveConfig()
	Runtime.RefreshRecordUI()
	StatusLbl.Text = string.format("Recorder đã chọn %s Room %d theo phòng đang đứng", w, r)
end)

local recordMismatchPending
function Runtime.RecordSaveCurrent(w,r)
	assert(not GamePlaceUtil:IsMain() and not isTransitioning(),"Chỉ SAVE vị trí đang đứng trong Dungeon")
	local live,liveRoom=currentRoundInfo()
	assert(w==live,"World đang chơi "..tostring(live).." khác World Record "..tostring(w))
	local char=LocalPlayer.Character
	local root=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	assert(root and hum and hum.Health>0,"Chưa có nhân vật sống để SAVE")
	if r~=liveRoom then
		local key=tostring(w)..":"..tostring(r)..":"..tostring(liveRoom)
		if not recordMismatchPending or recordMismatchPending.Key~=key or os.clock()>recordMismatchPending.Deadline then
			recordMismatchPending={Key=key,Deadline=os.clock()+12}
			StatusLbl.Text="CẢNH BÁO: GameRound="..tostring(liveRoom).." nhưng đang SAVE R"..r..". Bấm SAVE lại trong 12s để ghi đè."
			return false
		end
	end
	recordMismatchPending=nil
	Runtime.SetRecordedCoordinate(w,r,{root.CFrame:GetComponents()},"Recorder-v1.3-LiveSave",true)
	recLastShownSelection=nil
	Runtime.RefreshRecordUI()
	StatusLbl.Text="Record SAVE: "..w.." R"..r.." (JSON đã lưu)"
	return true
end
function Runtime.RecordMark(w,r,outcome)
	assert(outcome=="PASS" or outcome=="FAIL","Trạng thái không hợp lệ")
	assert(Runtime.GetRecordedCoordinate(w,r),"Room chưa có tọa độ")
	local live,room,done=currentRoundInfo()
	assert(live==w,"Phải ở đúng World khi đánh dấu PASS/FAIL")
	assert(typeof(writefile)=="function","Executor không hỗ trợ writefile")
	recResults[w]=recResults[w] or {}
	recResults[w][tostring(r)]={Status=outcome,AtUTC=os.date("!%Y-%m-%d %H:%M:%S"),ObservedRound=room,ObservedClear=done}
	writefile(recResultsFile,HttpService:JSONEncode(recResults))
	Runtime.RefreshRecordUI()
	Runtime.Log("RECORDER_"..outcome.." "..w.." R"..r)
end

routeButton("SAVE TỌA ĐỘ HIỆN TẠI (CFrame) + JSON", function()
	local w=Config.SelectedRecordWorld
	local r=tonumber(Config.SelectedRecordRoom)
	Runtime.RecordSaveCurrent(w,r)
end)

routeButton("SAVE + NEXT (lưu CFrame và chọn Room kế)", function()
	assert(not GamePlaceUtil:IsMain(), "Chỉ dùng trong Dungeon")
	local w=Config.SelectedRecordWorld
	local live,liveRoom=currentRoundInfo()
	assert(w==live, "World thực tế và World trong Record khác nhau")
	local r=tonumber(Config.SelectedRecordRoom)
	assert(r and r>=1 and r<20,"Room phải là 1..19 để SAVE + NEXT")
	local char=LocalPlayer.Character
	local root=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	assert(root and hum and hum.Health>0,"Nhân vật chưa sẵn sàng")
	assert(r==liveRoom,"Room đang chọn khác Room game; hãy Sync theo GameRoundCfg trước khi SAVE+NEXT")
	Runtime.SetRecordedCoordinate(w,r,{root.CFrame:GetComponents()},"Recorder-v1.3-SaveNext",true)
	Config.SelectedRecordRoom=r+1
	saveConfig()
	recLastShownSelection=nil
	Runtime.RefreshRecordUI()
	StatusLbl.Text="Record SAVE + NEXT: "..w.." Room "..r.." đã lưu; chọn Room "..(r+1)
end)
routeButton("SAVE XYZ NHẬP TAY cho Room đang chọn", function()
	local w=Config.SelectedRecordWorld
	local r=tonumber(Config.SelectedRecordRoom)
	local coords3={tonumber(recCoordBoxes[1].Text),tonumber(recCoordBoxes[2].Text),tonumber(recCoordBoxes[3].Text)}
	assert(#coords3==3 and validPosition(coords3),"X Y Z phải là ba số hữu hạn")
	Runtime.SetRecordedCoordinate(w,r,coords3,"Record-MANUAL-XYZ",true)
	recLastShownSelection=nil
	Runtime.RefreshRecordUI()
	StatusLbl.Text="Đã lưu XYZ thủ công cho "..w.." Room "..r
end)

routeButton("SAVE JSON (Kèm Backup trước khi ghi đè)", function()
	Runtime.SaveRoutesJSON()
	StatusLbl.Text = "Status: Đã lưu " .. RouteFile .. " (kèm bản backup) & đồng bộ Config!"
end)

local resetRecordPreview
routeButton("RESET tọa độ Room đang chọn về SEED mặc định", function()
	local w=tostring(Config.SelectedRecordWorld)
	local r=tonumber(Config.SelectedRecordRoom)
	local default=SeedRecordedCoordinates[w] and SeedRecordedCoordinates[w][r]
	assert(validPosition(default),"Room này không có tọa độ SEED đã biết; không tự bịa vị trí.")
	local key=w..":"..tostring(r)
	if not resetRecordPreview or resetRecordPreview.Key~=key or os.clock()>resetRecordPreview.Until then
		resetRecordPreview={Key=key,Until=os.clock()+12}
		StatusLbl.Text="RESET "..key.."? Bấm lần nữa trong 12s để xác nhận; JSON cũ sẽ được sao lưu."
		return
	end
	resetRecordPreview=nil
	Runtime.SetRecordedCoordinate(w,r,default,"VERIFIED-EMBEDDED-RESET",true)
	recLastShownSelection=nil
	Runtime.RefreshRecordUI()
	StatusLbl.Text="Đã reset "..key.." về tọa độ SEED. Auto TP giữ nguyên."
end)

routeButton("RELOAD JSON (Có cảnh báo nếu chưa lưu)", function()
	local reloaded = Runtime.ReloadRoutes(false)
	if reloaded then
		Runtime.RefreshRecordUI()
	end
end)

function Runtime.RecordManualTest(w,r)
	assert(not GamePlaceUtil:IsMain() and not isTransitioning(),"Chỉ test trong Dungeon")
	assert(not state.Active and not Runtime.RouteBusy and not Runtime.Owner and not Runtime.EntryBusy and not Runtime.ForgeBusy,
		"Đang có tác vụ di chuyển")
	local char=LocalPlayer.Character
	local root=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	assert(root and hum and hum.Health>0,"Chưa có nhân vật sống")
	local live,curR=currentRoundInfo()
	assert(live==w,"Đang ở "..tostring(live)..", không thể test "..w)
	assert(Runtime.GetRecordedCoordinate(w,r),"Chưa có tọa độ hợp lệ")
	if Runtime.ReconcileLoot then Runtime.ReconcileLoot(root) end
	assert(not Runtime.LootActive,"Loot đang hoạt động; hoàn tất trước khi TP")
	state.ManualPause=true
	startTransition(char,root,hum,w,curR or math.max(1,r-1),r,true,false)
	Runtime.RefreshRecordUI()
end
routeButton("TEST TP Room đang chọn (+5 studs, manual)",function()
	Runtime.RecordManualTest(tostring(Config.SelectedRecordWorld),tonumber(Config.SelectedRecordRoom))
end)

routeButton("RESUME HYBRID (Trả quyền cho Auto Farm/Hybrid sau khi Test TP)", function()
	assert(not state.Active, "Chờ lượt TP hiện tại kết thúc kiểm tra landing")
	state.ManualPause = false
	Runtime.RefreshRecordUI()
	StatusLbl.Text = "Status: Đã tắt ManualPause; Hybrid/Auto Farm hoạt động bình thường."
end)

pcall(Runtime.RefreshRecordUI) -- hidden legacy Recorder must not prevent startup
 task.spawn(function()
	while Runtime.Alive do
		if Runtime.Tabs.Record and Runtime.Tabs.Record.Visible and recLiveLbl.Parent then
			local w,r,c=currentRoundInfo()
			recLiveLbl.Text=string.format("LIVE World=%s | GameRound=%s | GameRoundComplete=%s | Cleared=%s",
				tostring(w),tostring(r),tostring(c),tostring(type(r)=="number" and c==r))
		end
		task.wait(1.2)
	end
end)
end

local function isBagFullForCurrentDungeon()
	local round = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	assert(round, "Thiếu GameRoundCfg")
	local world, diff = round:GetAttribute("WorldId"), round:GetAttribute("DiffLevel")
	local info = world and diff and WorldUtil:GetWorldDiffInfo(world, diff)
	assert(info, "Chưa có dữ liệu World/Diff của trận")
	if info.LootType == KeyString.WorldLootType.Ore then
        local need,b,reason=Runtime.OreNeedsLobby()
        if need then Runtime.Log("ORE_CAPACITY_RETURN "..Runtime.OreStatusText(b).." reason="..reason) end
        return need
    end
	if info.LootType == KeyString.WorldLootType.Material then return not MaterialUtil:CheckCanAdd(LocalPlayer, 1) end
	return false
end

-- Compact v4 uses the existing forgeRecipe/UUID services instead of the legacy batch UI.

local settlementState = {Object = nil, Armed = false, Handled = false, VisibleSince = nil}
local function handleSettlement()
	local resultGui = PlayerGui:FindFirstChild("ResultGui")
	local settlement = resultGui and resultGui:FindFirstChild("ScreenSettlement")
	if settlementState.Object ~= settlement then
		settlementState = {Object = settlement, Armed = false, Handled = false, VisibleSince = nil}
	end
	if not settlement or not settlement.Visible or (resultGui:IsA("ScreenGui") and not resultGui.Enabled) then
		settlementState.Armed = true
		settlementState.Handled = false
		settlementState.VisibleSince = nil
		return false
	end
	-- Require a hidden -> visible cycle observed in this session.
	-- A pre-existing visible result on injection never triggers automatic BackLobby.
	if not settlementState.Armed or isTransitioning() then return true end
    if Runtime.Analytics and Runtime.Analytics.MarkDungeonClear then
        pcall(Runtime.Analytics.MarkDungeonClear,"SETTLEMENT_GUI_ARMED")
    end
	settlementState.VisibleSince = settlementState.VisibleSince or os.clock()
	if os.clock() - settlementState.VisibleSince < 1 or settlementState.Handled or Config.RunEndAction == "Off" then return true end
    if Runtime.DailySettlement and LocalPlayer:GetAttribute("Settlement")==true then
        local r=ReplicatedStorage:FindFirstChild("GameRoundCfg")
        if r then pcall(Runtime.DailySettlement,r:GetAttribute("WorldId")) end
    end
	local round = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	local openData = WindowUtil:GetOpenData("ScreenSettlement")
	if not round or not round:GetAttribute("WorldId") or not round:GetAttribute("DiffLevel") or type(openData) ~= "table" then return true end
	local action = Config.RunEndAction
	if action == "LobbyIfFullOrAgain" then
		action = isBagFullForCurrentDungeon() and "BackLobby" or "VotePlayAgain"
	elseif action == "AlwaysBackLobby" then action = "BackLobby" end
    -- Automatic Solo mode: return for eligible trash; explicit Always Play Again
    -- is supervised by the user and must not be rewritten by cleanup.
    if Config.RunEndAction=="LobbyIfFullOrAgain" and action=="VotePlayAgain"
        and Config.AutoFarm and Config.AutoCreateRole=="Solo"
        and Config.AutoClearTrash and Runtime.HasEligibleTrashRecipe
        and Runtime.HasEligibleTrashRecipe() then
        action="BackLobby"
        Runtime.Log("AUTO_TRASH_SETTLEMENT_RETURN eligible recipe at Lobby")
    end
	if action == "VoteNextChapter" then
		local world = LocalPlayer:GetAttribute("NextChapterWorldId")
		local diff = LocalPlayer:GetAttribute("NextChapterDiffLevel")
		if type(world) ~= "string" or world == "" or type(diff) ~= "number" or diff <= 0 then
			settlementState.Handled = true
			StatusLbl.Text = "Status: Không có màn tiếp theo; chờ anh chọn."
			return true
		end
	end
    -- Ore Safety may override conditional Solo replay, but NEVER the user's
    -- explicit supervised "Always Play Again" choice.
    if Config.RunEndAction~="VotePlayAgain" and Config.AutoFarm
        and Config.AutoCreateRole=="Solo" and Config.OreSafetyEnabled then
        local currentInfo=WorldUtil:GetWorldDiffInfo(round:GetAttribute("WorldId"),round:GetAttribute("DiffLevel"))
        if currentInfo and currentInfo.LootType==KeyString.WorldLootType.Ore then
            local need,b,reason=Runtime.OreNeedsLobby()
            if need then
                action="BackLobby"
                if b.Known and (b.Used>=Config.OreReturnAt or b.CanAdd==false) then Config.OreCleanupActive=true end
                Runtime.Log("ORE_CAPACITY_RETURN "..Runtime.OreStatusText(b).." reason="..reason)
            end
        end
    end
	-- Explicit VotePlayAgain is honoured for manual four-account party runs.
	if action ~= "BackLobby" then
		local world = action == "VoteNextChapter" and LocalPlayer:GetAttribute("NextChapterWorldId") or round:GetAttribute("WorldId")
		local diff = action == "VoteNextChapter" and LocalPlayer:GetAttribute("NextChapterDiffLevel") or round:GetAttribute("DiffLevel")
		local ticket, amount = WorldUtil:GetWorldNeedTicket(world, diff)
		if ticket and amount and not CurrencyUtil:Has(LocalPlayer, ticket, amount) then
            if Config.RunEndAction=="VotePlayAgain" then
                Runtime.Log("ALWAYS_PLAY_AGAIN_TICKET_WARNING: server may reject vote; no BackLobby override")
            else
                action="BackLobby"
            end
        end
		local info = WorldUtil:GetWorldDiffInfo(world, diff)
        if info then
            if info.LootType == KeyString.WorldLootType.Ore then
                local need=Runtime.OreNeedsLobby()
                if need and Config.RunEndAction~="VotePlayAgain" then action="BackLobby" end
                if need and Config.RunEndAction=="VotePlayAgain" then
                    Runtime.Log("SUPERVISED_ALWAYS_PLAY_AGAIN ORE_WARNING: check bag/loot manually")
                end
            elseif info.LootType == KeyString.WorldLootType.Material then
                if not MaterialUtil:CheckCanAdd(LocalPlayer,1) then
                    if Config.RunEndAction=="VotePlayAgain" then
                        Runtime.Log("SUPERVISED_ALWAYS_PLAY_AGAIN MATERIAL_WARNING: check bag/loot manually")
                    else
                        action="BackLobby"
                    end
                end
            end
        end
	end
	checkRunning()
    if action == "BackLobby" then
        assert(WorldRE, "Thiếu WorldRE")
        if Config.AutoClearTrash then
            Config.AutoClearTrashPending=true
            Runtime.AutoClearTrashNextScanAt=0
            Runtime.AutoClearTrashSold=0
            saveConfig()
            Runtime.Log("AUTO_CLEAR_TRASH_Lobby: condition-based; will scan eligible recipes")
        end
        settlementState.Handled = true
        WorldRE:FireServer("BackLobby")
	elseif action == "VotePlayAgain" or action == "VoteNextChapter" then
		GameRoundRE = GameRoundRE or Remotes:FindFirstChild("GameRoundRE")
		assert(GameRoundRE, "Thiếu GameRoundRE")
		settlementState.Handled = true
		GameRoundRE:FireServer(action)
	else
		settlementState.Handled = true
		error("Hành động kết thúc không hợp lệ: " .. tostring(action))
	end
	StatusLbl.Text = "Status: Hết trận -> " .. action .. " (đã gửi 1 lần)"
	return true
end

-- Compact v4.3.1: Terminal-death recovery for all dungeon Worlds, NOT every normal KO.
-- Do not turn on Solo Auto Create for manual four-account parties.
local terminalDeath = {Since=nil, ExitSent=false, NextBack=nil, Attempts=0, World=nil}
local function resetTerminalDeath()
    terminalDeath={Since=nil, ExitSent=false, NextBack=nil, Attempts=0, World=nil}
    Runtime.DeathRecovery=false
end
local function isVisibleDeathUI()
    -- Text is a secondary signal only; Never exit solely because of a stray UI label.
    for _, node in ipairs(PlayerGui:GetDescendants()) do
        if (node:IsA("TextLabel") or node:IsA("TextButton")) and type(node.Text)=="string" then
            local title=node.Text:upper()
            if title:find("YOU DIED",1,true) or title:find("GAME OVER",1,true) then
                local visible=true
                local parent=node
                while parent and parent~=PlayerGui do
                    if parent:IsA("GuiObject") and not parent.Visible then visible=false; break end
                    if parent:IsA("ScreenGui") and not parent.Enabled then visible=false; break end
                    parent=parent.Parent
                end
                if visible then return true end
            end
        end
    end
    return false
end
local function handleTerminalDeath()
    if Runtime.StuckRecoveryPending then return end -- watchdog owns the Lobby transfer
    if not Config.AutoEndlessDeathLobby or GamePlaceUtil:IsMain() then
        resetTerminalDeath()
        return
    end
    if isTransitioning() then return end
    local roundCfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
    local world=roundCfg and roundCfg:GetAttribute("WorldId")
    if type(world)~="string" or world=="" then return end
    local char=LocalPlayer.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local deadHum=hum~=nil and hum.Health<=0
    local spectator=LocalPlayer:GetAttribute("Spectator")==true
    local lives=LocalPlayer:GetAttribute("RemainLife")
    local exhausted=(type(lives)=="number" and lives<=0)
    local deadScreen=false
    if deadHum or spectator then deadScreen=isVisibleDeathUI() end
    local terminal=(exhausted and (deadHum or spectator))
        or (deadHum and deadScreen and (lives==nil or exhausted))
        or (deadHum and Runtime.DailyExactDead and Runtime.DailyExactDead(world))
    if terminalDeath.ExitSent and hum and hum.Health>0 and not spectator
        and not LocalPlayer:GetAttribute("Settlement") then
        Runtime.Log("DEATH_REPLAY_RECOVERED character alive; stop retry")
        resetTerminalDeath()
        return
    end
    if Config.RunEndAction=="VotePlayAgain" and settlementState.Handled
        and not terminalDeath.ExitSent then
        -- Settlement handler already sent the normal VotePlayAgain.
        return
    end
    -- Normal death with lives remaining, or a missing Character while loading: do nothing.
    if not terminalDeath.ExitSent then
        if not terminal then
            if (deadHum or spectator) and os.clock()-(Runtime.LastDeathProbeAt or -math.huge)>6 then
                Runtime.LastDeathProbeAt=os.clock()
                Runtime.Log("DEATH_PROBE not terminal; world="..tostring(world)
                    .." HP0="..tostring(deadHum).." RemainLife="..tostring(lives)
                    .." Spectator="..tostring(spectator).." DeathUI="..tostring(deadScreen))
            end
            if terminalDeath.Since then resetTerminalDeath() end
            return
        end
        if terminalDeath.World~=world then
            terminalDeath.Since=os.clock()
            terminalDeath.World=world
        end
        if os.clock()-(terminalDeath.Since or os.clock())<2.5 then return end
        Runtime.DeathRecovery=true
        Runtime.HasCombatTarget=false
        Runtime.HoverTarget=nil
        if Runtime.CancelPatrol then Runtime.CancelPatrol() end
        if Runtime.CancelRoute then Runtime.CancelRoute("terminal death") end
        local gamePlayerRE=Remotes:FindFirstChild("GamePlayerRE")
        -- Do not manufacture a new Remote. Only use the two existing AIO actions.
        if Config.RunEndAction~="VotePlayAgain"
            and not LocalPlayer:GetAttribute("Settlement") and not gamePlayerRE then
            Runtime.Log("DEATH_EXIT_PENDING: GamePlayerRE missing")
            return
        end
        terminalDeath.ExitSent=true
        if Runtime.DailyTerminal then pcall(Runtime.DailyTerminal,world,lives) end
        terminalDeath.NextBack=os.clock() + (Config.RunEndAction=="VotePlayAgain" and .1 or 5)
        Runtime.Log("TERMINAL_DEATH "..world.." RemainLife="..tostring(lives)
            .." Spectator="..tostring(spectator).." DeadUI="..tostring(deadScreen)
            .." Solo="..tostring(Config.AutoFarm and Config.AutoCreateRole=="Solo"))
        if Config.RunEndAction=="VotePlayAgain" then
            -- Do not call ExitSettlement or BackLobby in this explicit mode.
            StatusLbl.Text="Status: Hết mạng -> VotePlayAgain theo lựa chọn của anh..."
        else
            if not LocalPlayer:GetAttribute("Settlement") then
                gamePlayerRE:FireServer("ExitSettlement")
            else
                terminalDeath.NextBack=os.clock()+0.3
            end
            StatusLbl.Text="Status: Hết mạng thật -> thoát "..world.." về Lobby..."
        end
    end
    -- Explicit replay applies to TERMINAL death as well as a victory screen.
    -- The server may refuse death votes; log bounded attempts, never silently
    -- substitute BackLobby. Reset occurs when the next run/map is observed.
    if Config.RunEndAction=="VotePlayAgain" and terminalDeath.ExitSent then
        if terminalDeath.NextBack and os.clock()>=terminalDeath.NextBack then
            if terminalDeath.Attempts>=3 then
                terminalDeath.NextBack=nil
                StatusLbl.Text="Status: Đã thử Play Again 3 lần; server chưa xác nhận. Không tự về Lobby."
                Runtime.Log("DEATH_PLAY_AGAIN_UNCONFIRMED attempts=3")
                return
            end
            GameRoundRE=GameRoundRE or Remotes:FindFirstChild("GameRoundRE")
            if not GameRoundRE then
                terminalDeath.NextBack=os.clock()+3
                Runtime.Log("DEATH_PLAY_AGAIN_WAIT_REMOTE")
                return
            end
            terminalDeath.Attempts=terminalDeath.Attempts+1
            terminalDeath.NextBack=os.clock()+7
            local ok,err=pcall(function() GameRoundRE:FireServer("VotePlayAgain") end)
            if ok then
                settlementState.Handled=true -- avoid simultaneous GUI replay vote
                Runtime.Log("DEATH_VOTE_PLAY_AGAIN attempt="..terminalDeath.Attempts.." world="..world)
            else
                Runtime.Log("DEATH_VOTE_PLAY_AGAIN_ERROR "..tostring(err))
            end
        end
        return
    end
    if terminalDeath.ExitSent and terminalDeath.NextBack and os.clock()>=terminalDeath.NextBack then
        if terminalDeath.Attempts>=3 then
            StatusLbl.Text="Status: Chưa về Lobby sau 3 lần BackLobby; kiểm tra UI chết/Remote."
            return
        end
        if not WorldRE then
            StatusLbl.Text="Status: Không có WorldRE để BackLobby"
            return
        end
        terminalDeath.Attempts=terminalDeath.Attempts+1
        terminalDeath.NextBack=os.clock()+15
        WorldRE:FireServer("BackLobby")
        Runtime.Log("DEATH_BACK_LOBBY attempt="..terminalDeath.Attempts.." world="..tostring(world))
    end
end
task.spawn(function()
    while Runtime.Alive do
        local ok,err=pcall(handleTerminalDeath)
        if not ok then reportError("True Death Recovery",err) end
        task.wait(0.3)
    end
end)

-- v4.9.40: Solo Dungeon STUCK watchdog. Never calls manual BReturnLobby(),
-- because B disables AutoFarm. It uses B's existing TeleportWorld/Lobby
-- action directly and lets the existing lobby AutoFarm worker re-enter.
-- The two clocks are independent: enemies seen reset only the no-mob clock;
-- restored HP resets only the HP0 clock. Neither clock changes recorded routes.
;(function() -- v4.9.41: separate Luau function frame; keep large AIO outer locals unchanged
local STUCK_SECONDS, STUCK_RETRY_SECONDS, STUCK_MAX_ATTEMPTS = 30, 8, 3
local stuckWatch = {
    World=nil, Room=nil, Character=nil,
    NoMobSince=nil, HP0Since=nil, Pending=false,
    Reason=nil, Attempts=0, NextRetryAt=0, FailedLogged=false
}
Runtime.StuckRecoveryPending=false
local function clearStuckWatchdog(reason)
    if stuckWatch.Pending then
        Runtime.Log("STUCK_WATCH_RESET reason="..tostring(reason)
            .." attempts="..tostring(stuckWatch.Attempts))
        Runtime.StuckRecoveryPending=false
        Runtime.DeathRecovery=false
    end
    stuckWatch = {
        World=nil, Room=nil, Character=nil,
        NoMobSince=nil, HP0Since=nil, Pending=false,
        Reason=nil, Attempts=0, NextRetryAt=0, FailedLogged=false
    }
end
local function watchdogSendLobby()
    if not stuckWatch.Pending or GamePlaceUtil:IsMain() or isTransitioning() then return end
    local now=os.clock()
    if now < stuckWatch.NextRetryAt then return end
    if stuckWatch.Attempts >= STUCK_MAX_ATTEMPTS then
        if not stuckWatch.FailedLogged then
            stuckWatch.FailedLogged=true
            Runtime.Log("STUCK_LOBBY_UNCONFIRMED attempts="..tostring(stuckWatch.Attempts)
                .." reason="..tostring(stuckWatch.Reason)
                .."; AutoFarm remains ON; manual diagnosis required")
            StatusLbl.Text="STUCK: đã gọi Lobby 3 lần, game chưa xác nhận về Lobby"
        end
        return
    end
    stuckWatch.Attempts=stuckWatch.Attempts+1
    stuckWatch.NextRetryAt=now+STUCK_RETRY_SECONDS
    -- Same invocation path as the B hotkey; server acceptance still needs a live test.
    local remote=WorldRE
    if not remote or not remote:IsA("RemoteEvent") then
        local fw=ReplicatedStorage:FindFirstChild("Framework")
        local gameplay=fw and fw:FindFirstChild("Gameplay")
        local worldPlace=gameplay and gameplay:FindFirstChild("WorldPlace")
        local worldUtilFolder=worldPlace and worldPlace:FindFirstChild("WorldUtil")
        remote=worldUtilFolder and worldUtilFolder:FindFirstChild("RemoteEvent")
    end
    if not remote or not remote:IsA("RemoteEvent") then
        Runtime.Log("STUCK_LOBBY_MISSING_REMOTE attempt="..stuckWatch.Attempts)
        return
    end
    local ok,err=pcall(function() remote:FireServer("TeleportWorld","Lobby") end)
    if ok then
        Runtime.Log("STUCK_LOBBY_SENT attempt="..stuckWatch.Attempts
            .." reason="..tostring(stuckWatch.Reason)
            .." world="..tostring(stuckWatch.World)
            .." room="..tostring(stuckWatch.Room)
            .." AutoFarm="..tostring(Config.AutoFarm)
            .." (server acceptance NOT verified)")
        StatusLbl.Text="STUCK 30s: đã yêu cầu về Lobby; giữ Auto Farm ON"
    else
        Runtime.Log("STUCK_LOBBY_SEND_ERROR attempt="..stuckWatch.Attempts
            .." err="..tostring(err))
    end
end
local function watchdogTick()
    if Runtime.EndlessSafeEntryActive and Runtime.EndlessSafeEntryActive() then
        clearStuckWatchdog("Endless native RoundDoor handoff")
        return
    end
    if GamePlaceUtil:IsMain() then
        if stuckWatch.Pending then
            Runtime.Log("STUCK_LOBBY_CONFIRMED AutoFarm="..tostring(Config.AutoFarm)
                .." Solo="..tostring(Config.AutoCreateRole=="Solo")
                .."; normal lobby AutoCreate loop resumes")
        end
        clearStuckWatchdog("in lobby")
        return
    end
    -- Manual party/follower never gets involuntarily sent to Lobby.
    if not Config.AutoFarm or Config.AutoCreateRole~="Solo" then
        clearStuckWatchdog("Solo AutoFarm disabled")
        return
    end
    -- Once a transfer is requested, freeze both timers; no repeated trigger.
    if stuckWatch.Pending then
        watchdogSendLobby()
        return
    end
    if isTransitioning() or Runtime.EntryBusy then
        -- Do not count map-loading/entry time toward 30s.
        clearStuckWatchdog("loading/entry")
        return
    end
    local roundCfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
    local world=roundCfg and roundCfg:GetAttribute("WorldId")
    local room=roundCfg and roundCfg:GetAttribute("GameRound")
    if type(world)~="string" or world=="" or type(room)~="number" then
        clearStuckWatchdog("round not ready")
        return
    end
    local char=LocalPlayer.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local now=os.clock()
    if stuckWatch.World~=world or stuckWatch.Room~=room
        or stuckWatch.Character~=char then
        stuckWatch.World,stuckWatch.Room,stuckWatch.Character=world,room,char
        stuckWatch.NoMobSince,stuckWatch.HP0Since=nil,nil
    end
    if hum and hum.Health<=0 then
        if not stuckWatch.HP0Since then
            stuckWatch.HP0Since=now
            Runtime.Log("STUCK_HP0_START world="..world.." room="..tostring(room))
        end
    else
        stuckWatch.HP0Since=nil
    end
    -- Use the SAME live-enemy/current-room filter as combat. A stale target
    -- pointer, unspawned enemy or unrelated next-room model is not evidence.
    local enemy=nil
    if root then enemy=findNearestEnemy(root.Position,false) end
    if enemy then
        stuckWatch.NoMobSince=nil
    elseif not stuckWatch.NoMobSince then
        stuckWatch.NoMobSince=now
        Runtime.Log("STUCK_NO_MOB_START world="..world.." room="..tostring(room))
    end
    local hp0For=stuckWatch.HP0Since and now-stuckWatch.HP0Since or 0
    local noMobFor=stuckWatch.NoMobSince and now-stuckWatch.NoMobSince or 0
    if hp0For<STUCK_SECONDS and noMobFor<STUCK_SECONDS then return end
    stuckWatch.Pending=true
    stuckWatch.Reason=(hp0For>=STUCK_SECONDS) and "HP_ZERO_30S" or "NO_MOB_30S"
    stuckWatch.Attempts=0
    stuckWatch.NextRetryAt=0
    Runtime.StuckRecoveryPending=true
    Runtime.SuppressAutoCreate=false -- explicit Solo AutoFarm recovery must allow next Lobby create
    Runtime.DeathRecovery=true -- stops combat workers during outbound Lobby request
    Runtime.HasCombatTarget=false
    Runtime.HoverTarget=nil
    local xyz=root and root.Position
    Runtime.Log("STUCK_TRIGGER "..stuckWatch.Reason
        .." world="..world.." room="..tostring(room)
        .." HP0sec="..string.format("%.1f",hp0For)
        .." NoMobSec="..string.format("%.1f",noMobFor)
        .." xyz="..(xyz and string.format("%.1f,%.1f,%.1f",xyz.X,xyz.Y,xyz.Z) or "NO_ROOT")
        .." humState="..(hum and tostring(hum:GetState()) or "NO_HUM"))
    if Runtime.CancelPatrol then pcall(Runtime.CancelPatrol) end
    if Runtime.CancelRoute then pcall(Runtime.CancelRoute,"stuck 30s -> Lobby") end
    if Runtime.CancelFlySkill then pcall(Runtime.CancelFlySkill,"stuck 30s -> Lobby") end
    if Runtime.NightReleaseDodge then pcall(Runtime.NightReleaseDodge,"stuck watchdog") end
    watchdogSendLobby()
end
task.spawn(function()
    while Runtime.Alive do
        local ok,err=pcall(watchdogTick)
        if not ok then reportError("Stuck Watchdog",err) end
        task.wait(0.8)
    end
end)
end)()

local currentEnemy = nil
local currentLoot = nil
local eggEngageTime = 0
local eggSession
local eggInput
local function releaseEggInput()
	local held = eggInput
	eggInput = nil
	if held then
		pcall(function()
			if held.Prompt then held.Prompt:InputHoldEnd()
			else held.Service:SendKeyEvent(false, Enum.KeyCode.F, false, game) end
		end)
	end
end
Runtime.ReleaseEggInput = releaseEggInput
local function legacyEggCountdown(egg)
	-- Read the visible timer, not damage or HP. Example from the game: 00:10.00.
	for _, node in ipairs(egg:GetDescendants()) do
		if (node:IsA("TextLabel") or node:IsA("TextButton")) and node.Visible then
			local text = node.Text:gsub("<[^>]+>", "")
			local minutes, seconds, fraction = text:match("^%s*(%d%d?):(%d%d)%.(%d+)%s*$")
			if minutes then
				local value = tonumber(minutes)*60 + tonumber(seconds) + tonumber("0." .. fraction)
				if value >= 0 and value <= 11 then return value end
			end
		end
	end
end
local handleEgg

-- V23_LOOT_MODULE: phân biệt rõ LOOT_SUCCESS, LOOT_FAILED, LOOT_SKIPPED; timeout KHÔNG phải đã nhận thưởng.
do
local LOOT_STATUS = {
	SUCCESS = "LOOT_INTERACTION_COMPLETE", -- reward receipt is NOT verified
	FAILED = "LOOT_FAILED",
	SKIPPED = "LOOT_SKIPPED"
}
Runtime.LootStatusEnum = LOOT_STATUS
local completed = setmetatable({}, {__mode = "k"})
local failedAttempts = setmetatable({}, {__mode = "k"})
local session
local clearQuietSince
local routeLootKey, routeLootSince
local lootRun = Runtime.RouteState and Runtime.RouteState.Run

local function roomKey()
	local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	return cfg and (tostring(cfg:GetAttribute("WorldId")) .. ":" .. tostring(cfg:GetAttribute("GameRound"))) or "unknown"
end

local function visible(node)
	local cursor = node
	while cursor and cursor ~= PlayerGui do
		if cursor:IsA("GuiObject") and not cursor.Visible then return false end
		if cursor:IsA("ScreenGui") and not cursor.Enabled then return false end
		cursor = cursor.Parent
	end
	return true
end

local function guiTimers()
	local result = {}
	for _, node in ipairs(PlayerGui:GetDescendants()) do
		if node:IsA("TextLabel") and visible(node) and not node:IsDescendantOf(ScreenGui) then
			local m, s, f = node.Text:gsub("<[^>]+>", ""):match("^%s*(%d%d?):(%d%d)%.(%d+)%s*$")
			local seconds = m and tonumber(m) * 60 + tonumber(s) + tonumber("0." .. f)
			if seconds and seconds >= 0 and seconds <= 11 then result[node] = seconds end
		end
	end
	return result
end

local function isDecorativeOrInvalidLoot(obj)
	if not obj or not obj.Parent or not obj:IsA("Model") then return true end
	if completed[obj] then return true end
	if (failedAttempts[obj] or 0) >= 2 then return true end
	local name = obj.Name:lower()
	if not (name:find("egg") or name:find("chest")) then return true end
	if name:find("deco") or name:find("prop") or name:find("fake") or name:find("statue") or name:find("visual") or name:find("opened") or name:find("empty") then
		return true
	end
	if obj:GetAttribute("IsOpened") == true or obj:GetAttribute("Opened") == true or obj:GetAttribute("Claimed") == true then
		return true
	end
	local inValidContainer = false
	local eItem = Workspace:FindFirstChild("EItem")
	local entity = Workspace:FindFirstChild("Entity")
	if (eItem and obj:IsDescendantOf(eItem)) or (entity and obj:IsDescendantOf(entity)) then
		inValidContainer = true
	end
	local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
	local hum = obj:FindFirstChildOfClass("Humanoid")
	local hp = obj:GetAttribute("HP") or obj:GetAttribute("Health")
	local hasTimerGui = legacyEggCountdown(obj) ~= nil or obj:FindFirstChildWhichIsA("BillboardGui", true) ~= nil
	-- Vật trang trí trên map sẽ không nằm trong EItem/Entity và không có Prompt/HP/Timer hợp lệ
	if not inValidContainer and not (prompt and prompt.Enabled) and type(hp) ~= "number" and not hum then
		return true
	end
	local dead = (hum and hum.Health <= 0) or (type(hp) == "number" and hp <= 0)
	if dead and not (prompt and prompt.Enabled) then return true end
	local isEgg = name:find("egg") ~= nil
	local actionable = (prompt and prompt.Enabled)
		or (type(hp) == "number" and hp > 0)
		or (hum and hum.Health > 0)
		or (isEgg and inValidContainer and not dead and (hasTimerGui or prompt == nil))
	return not actionable
end

local function inRoom(obj, root)
	local cfg = ReplicatedStorage:FindFirstChild("GameRoundCfg")
	if not cfg then return false end
	local node = obj
	while node and node ~= Workspace do
		local world, round = node:GetAttribute("WorldId"), node:GetAttribute("GameRound")
		if world ~= nil and world ~= cfg:GetAttribute("WorldId") then return false end
		if round ~= nil and round ~= cfg:GetAttribute("GameRound") then return false end
		node = node.Parent
	end
	local target = getModelRoot(obj)
	return target and (target.Position - root.Position).Magnitude <= math.clamp(tonumber(Config.LootRadius) or 120, 20, 200)
end

local function nearest(root)
	local best, distance
	local folders = {Workspace:FindFirstChild("EItem"), Workspace:FindFirstChild("Entity")}
	local candidates = {}
	for _, folder in ipairs(folders) do
		if folder then
			for _, obj in ipairs(folder:GetDescendants()) do
				if obj:IsA("Model") then candidates[obj] = true end
			end
		end
	end
	for _, obj in ipairs(Workspace:GetChildren()) do
		if obj:IsA("Model") then candidates[obj] = true end
	end
	for obj in pairs(candidates) do
		if not isDecorativeOrInvalidLoot(obj) and inRoom(obj, root) then
			local tRoot = getModelRoot(obj)
			if tRoot then
				local d = (tRoot.Position - root.Position).Magnitude
				if not distance or d < distance then best, distance = obj, d end
			end
		end
	end
	return best
end

local function recordLootOutcome(status, objName, reason)
	Runtime.LastLootStatus = status
	Runtime.LastLootReason = reason
	Runtime.Log(string.format("%s object=%s reason=%s", status, tostring(objName), tostring(reason)))
end

local function finishSuccess(obj, evidence)
	completed[obj] = true
	releaseEggInput()
	Runtime.LootActive = false
	Runtime.LootBlocked = false
	Runtime.EggInteracting = false
	currentLoot, session, eggSession = nil, nil, nil
	recordLootOutcome(LOOT_STATUS.SUCCESS, obj and obj.Name or "unknown", evidence)
end

local function finishSkipped(obj, reason)
	if obj then completed[obj] = true end
	releaseEggInput()
	Runtime.LootActive = false
	Runtime.LootBlocked = false
	Runtime.EggInteracting = false
	currentLoot, session, eggSession = nil, nil, nil
	recordLootOutcome(LOOT_STATUS.SKIPPED, obj and obj.Name or "room", reason)
end

local function failLoot(obj, reason)
	releaseEggInput()
	Runtime.LootActive = false
	Runtime.EggInteracting = false
	if obj then
		failedAttempts[obj] = (failedAttempts[obj] or 0) + 1
	end
	currentLoot, session, eggSession = nil, nil, nil
	-- Không giữ khóa LootBlocked vô hạn; chỉ đánh dấu tạm thời kèm deadline tự giải phóng
	Runtime.LootBlocked = true
	Runtime.LootBlockedUntil = os.clock() + 4.0
	recordLootOutcome(LOOT_STATUS.FAILED, obj and obj.Name or "unknown", reason .. " (unverified reward; bounded retry)")
	StatusLbl.Text = "Loot lỗi/timeout (" .. tostring(reason) .. "); không coi là đã nhận thưởng."
end

local function process(obj, char, root, hum)
	local now = os.clock()
	if not session or session.Object ~= obj then
		session = {Object = obj, Since = now, NextTry = now, Tries = 0, Timers = guiTimers(), Room = roomKey()}
		Runtime.Log("LOOT_START " .. obj:GetFullName())
	end
	local data = session
	Runtime.LootActive = true
	currentLoot = obj
	if data.Room ~= roomKey() then
		finishSkipped(obj, "Room changed during loot interaction")
		return
	end
	if not obj.Parent then
		finishSuccess(obj, "object removed after interaction")
		return
	end
	local target = getModelRoot(obj)
	if not target then
		failLoot(obj, "missing model root")
		return
	end
	local egg = obj.Name:lower():find("egg") ~= nil
	local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
	local lootHum = obj:FindFirstChildOfClass("Humanoid")
	local hp = lootHum and lootHum.Health or obj:GetAttribute("HP") or obj:GetAttribute("Health")

	if not egg and data.Interacted and type(hp) == "number" and hp <= 0 then
		finishSuccess(obj, "Chest HP <= 0 after attack")
		return
	end
	if data.PromptActivated and prompt and not prompt.Enabled and (not egg or data.Started) then
		if not egg or data.TimerEnded then
			finishSuccess(obj, "prompt disabled & countdown completed")
			return
		end
	end

	-- Bảo vệ thời gian Egg đang tương tác hợp lệ (countdown đang chạy)
	local maxDuration = egg and (data.Started and 28 or 18) or 16
	if now - data.Since > maxDuration then
		failLoot(obj, (egg and "Egg" or "Chest") .. " timeout (" .. tostring(maxDuration) .. "s); KHÔNG tính là đã nhận thưởng")
		return
	end

	if patrol.Busy then stopPatrol() end
	Runtime.HoverTarget = nil
	if (target.Position - root.Position).Magnitude > 4 then
		teleportOnceToTarget(char, root, hum, target)
	end
	if eggInput and now >= eggInput.Until then releaseEggInput() end
	if not data.Started and not eggInput and data.Tries < 3 and now >= data.NextTry then
		if prompt and prompt.Enabled and (target.Position - root.Position).Magnitude <= prompt.MaxActivationDistance then
			data.Tries = data.Tries + 1
			eggInput = {Prompt = prompt, Until = now + math.max(0.2, prompt.HoldDuration + 0.2)}
			prompt:InputHoldBegin()
			data.PromptActivated, data.Interacted = true, true
			data.NextTry = eggInput.Until + 1.8
		elseif egg and not prompt then
			data.Tries = data.Tries + 1
			eggInput = {Service = game:GetService("VirtualInputManager"), Until = now + 2}
			eggInput.Service:SendKeyEvent(true, Enum.KeyCode.F, false, game)
			data.Interacted = true
			data.NextTry = now + 3.5
		end
	end
	if egg then
		local timer = legacyEggCountdown(obj)
		if timer == nil and data.Interacted then
			local candidates = {}
			for node, value in pairs(guiTimers()) do
				if data.Timers[node] == nil or data.TimerNode == node then
					table.insert(candidates, {Node = node, Value = value})
				end
			end
			if #candidates == 1 then data.TimerNode = candidates[1].Node; timer = candidates[1].Value end
		end
		if timer and timer > 0 and not data.Started then
			data.Started = true
			data.StartedAt = now
			Runtime.EggInteracting = true
			Runtime.Log("EGG_COUNTDOWN_STARTED " .. tostring(timer) .. "s; holding room transition until countdown finishes")
			releaseEggInput()
		end
		if data.Started then
			Runtime.EggInteracting = true
			if timer ~= nil and timer <= 0.15 then
				data.TimerEnded = true
				Runtime.EggInteracting = false
				finishSuccess(obj, "Egg countdown reached 0")
				return
			elseif timer == nil and now - (data.StartedAt or data.Since) >= 11.5 then
				data.TimerEnded = true
				Runtime.EggInteracting = false
				finishSuccess(obj, "Egg timer UI disappeared after full countdown window")
				return
			end
			Runtime.HasCombatTarget = true
			executeCombat(root, target)
		elseif data.Tries >= 3 and now >= data.NextTry then
			-- Quá 3 lần bấm F/Prompt mà Egg không hề kích hoạt countdown -> vật tĩnh hoặc lỗi, không giữ khóa lâu
			failLoot(obj, "Egg did not start countdown after 3 attempts")
		end
	elseif type(hp) == "number" and hp > 0 then
		data.Interacted = true
		Runtime.HasCombatTarget = true
		executeCombat(root, target)
	end
end

handleEgg = function(obj, char, root, hum)
	local ok, err = pcall(process, obj, char, root, hum)
	if not ok then failLoot(obj, tostring(err)) end
end

function Runtime.ClearTargets()
	releaseEggInput()
	currentEnemy, currentLoot, session, eggSession = nil, nil, nil, nil
	Runtime.LootActive = false
	Runtime.EggInteracting = false
end

function Runtime.ReconcileLoot(root)
	-- Khi BreakChestsEggs OFF, tuyệt đối không để trạng thái Loot chặn Route
	if not Config.BreakChestsEggs then
		if Runtime.LootActive or Runtime.LootBlocked or currentLoot then
			Runtime.ClearTargets()
			Runtime.LootBlocked = false
			recordLootOutcome(LOOT_STATUS.SKIPPED, "all", "BreakChestsEggs is OFF; route unblocked")
		end
		return nil
	end
	if Runtime.LootBlocked and Runtime.LootBlockedUntil and os.clock() >= Runtime.LootBlockedUntil then
		Runtime.LootBlocked = false
		Runtime.LootBlockedUntil = nil
		Runtime.Log("LOOT_BLOCK_EXPIRED auto-unblocked after bounded cooldown")
	end
	local candidate = nearest(root)
	if currentLoot and (not currentLoot.Parent or not inRoom(currentLoot, root) or isDecorativeOrInvalidLoot(currentLoot)) then
		Runtime.Log("LOOT_STALE_TARGET cleared; absent/outside current room")
		Runtime.ClearTargets()
	end
	if Runtime.LootBlocked and not candidate then
		Runtime.Log("LOOT_STALE_BLOCK cleared: no actionable valid loot in room")
		Runtime.LootBlocked = false
		Runtime.ClearTargets()
	elseif Runtime.LootActive and not currentLoot and not candidate then
		Runtime.LootActive = false
		Runtime.EggInteracting = false
	end
	return candidate
end

function Runtime.ProcessLoot(char, root, hum)
	if Runtime.RouteState and lootRun ~= Runtime.RouteState.Run then
		lootRun = Runtime.RouteState.Run
		completed = setmetatable({}, {__mode = "k"})
		failedAttempts = setmetatable({}, {__mode = "k"})
		Runtime.ClearTargets()
		Runtime.LootBlocked = false
		clearQuietSince = nil
	end
	-- Khi BreakChestsEggs OFF: trả về false ngay để KHÔNG chặn Route
	if not Config.BreakChestsEggs then
		if Runtime.LootActive or Runtime.LootBlocked then Runtime.ClearTargets() end
		Runtime.LootBlocked = false
		Runtime.LootActive = false
		Runtime.EggInteracting = false
		return false
	end
	local candidate = Runtime.ReconcileLoot(root)
	if Runtime.LootSkippedRoom == roomKey() then return false end
	if Runtime.LootBlocked then
		Runtime.RouteDiagnostic("loot cooldown before retry/skip")
		return candidate ~= nil
	end
	local obj = currentLoot or candidate
	if not obj then
		Runtime.LootActive = false
		Runtime.EggInteracting = false
		return false
	end
	handleEgg(obj, char, root, hum)
	return true
end

function Runtime.ProcessPostClear(char, root, hum)
	if not Runtime.RouteExpected() then return false end
	if Runtime.RouteObservationActive() or Runtime.RouteLegacyReady() then
		if Runtime.LootSkippedRoom ~= roomKey() then
			Runtime.LootSkippedRoom = roomKey()
			Runtime.LootBlocked = false
			Runtime.ClearTargets()
		end
		return false
	end
	local world, room, complete = Runtime.CurrentRouteInfo()
	if type(room) ~= "number" or (complete ~= room
        and not (Runtime.W1ObservedClear and Runtime.W1ObservedClear(world,room))) then
		clearQuietSince = nil
		routeLootKey, routeLootSince = nil, nil
		Runtime.RouteDiagnostic("GameRoundComplete ~= GameRound; waiting server clear")
		return false
	end
	local key = tostring(Runtime.RouteState.Run) .. ":" .. world .. ":" .. room
	if routeLootKey ~= key then
		routeLootKey, routeLootSince = key, os.clock()
		clearQuietSince = nil
		Runtime.LootBlocked = false
		Runtime.ClearTargets()
		Runtime.Log("ROOM_CLEAR " .. key .. "; transition entering LOOT_CHECK")
	end

	-- Khi BreakChestsEggs OFF: bỏ qua loot hoàn toàn và chuyển phòng ngay
	if not Config.BreakChestsEggs then
		if Runtime.LastLootSkipKey ~= key then
			Runtime.LastLootSkipKey = key
			recordLootOutcome(LOOT_STATUS.SKIPPED, key, "BreakChestsEggs OFF")
		end
	else
		local elapsed = os.clock() - routeLootSince
		-- Nếu Egg đang đếm ngược hợp lệ, chờ tối đa 38s để hoàn tất đập Egg; nếu không có Egg đang đếm thì tối đa 22s
		local roomLootLimit = Runtime.EggInteracting and 38 or 22
		if elapsed >= roomLootLimit then
			if Runtime.LootSkippedRoom ~= roomKey() then
				Runtime.LootSkippedRoom = roomKey()
				Runtime.LootBlocked = false
				Runtime.ClearTargets()
				recordLootOutcome(LOOT_STATUS.FAILED, key, "Room loot timeout (" .. tostring(roomLootLimit) .. "s); unblocking route without claiming reward")
			end
		elseif Runtime.ProcessLoot(char, root, hum) then
			clearQuietSince = nil
			Runtime.RouteDiagnostic(Runtime.EggInteracting and "Egg countdown active; holding transition" or "LOOT_CHECK active")
			return true
		end
	end

	clearQuietSince = clearQuietSince or os.clock()
	if os.clock() - clearQuietSince < 0.45 then return true end
	return Runtime.TryRecordedRoute(char, root, hum)
end

Scroll = Runtime.Tabs.Loot
routeButton("Đã xử lý loot thủ công: kiểm tra lại", function()
	Runtime.LootBlocked = false
	Runtime.LootBlockedUntil = nil
	Runtime.ClearTargets()
	Runtime.Log("LOOT_RECHECK requested by user")
end)
routeButton("CHỦ ĐỘNG bỏ qua loot Room hiện tại (LOOT_SKIPPED)", function()
	assert(not GamePlaceUtil:IsMain() and not Runtime.RouteBusy, "Chỉ bỏ qua trong room, khi không chuyển map")
	Runtime.LootSkippedRoom = roomKey()
	Runtime.LootBlocked = false
	Runtime.LootBlockedUntil = nil
	Runtime.ClearTargets()
	recordLootOutcome(LOOT_STATUS.SKIPPED, Runtime.LootSkippedRoom, "manual skip by user")
end)
end

-- Compact v4: persistent Room Spawn Anchors (separate from the v3 Hybrid destination coordinates).
Runtime.SpawnAnchors = Config.SpawnAnchors
local autoRoomObserve = {}
local spawnAnchorAttempted = {}
local function roomObservationKey(world, round)
    return tostring(world)..":"..tostring(round)
end
local function validSpawnXYZ(p)
    if type(p) ~= "table" or #p ~= 3 then return false end
    for i=1,3 do
        if type(p[i]) ~= "number" or p[i] ~= p[i] or math.abs(p[i]) == math.huge then return false end
    end
    return true
end
local function persistSpawnAnchor(world, round, enemyRoot)
    local w = Config.SpawnAnchors[world] or {}
    Config.SpawnAnchors[world] = w
    local key = tostring(round)
    if validSpawnXYZ(w[key]) or not enemyRoot then return false end
    local p = enemyRoot.Position
    w[key] = {p.X, p.Y, p.Z}
    Runtime.SpawnAnchors = Config.SpawnAnchors
    local ok = saveConfig()
    Runtime.Log("AUTO_RECORD_SPAWN "..world.." R"..round.." xyz="..tostring(p).." saved="..tostring(ok))
    return true
end
Runtime.TrySpawnAnchor = function(char, root, hum)
    local world, round, complete = Runtime.CurrentRouteInfo()
    if type(world) ~= "string" or type(round) ~= "number" or round == complete then return false end
    if Runtime.RouteBusy or Runtime.Owner or Runtime.DeathRecovery or (Runtime.RouteState and Runtime.RouteState.Active) then return false end
    local anchor = Config.SpawnAnchors[world] and Config.SpawnAnchors[world][tostring(round)]
    if not validSpawnXYZ(anchor) then return false end
    if world=="World1" and Runtime.CurrentWorld1Diff()~=5 then return false end
    local attemptKey = tostring(Runtime.RouteState and Runtime.RouteState.Run or 0)..":"..roomObservationKey(world,round)
    if spawnAnchorAttempted[attemptKey] then return false end
    spawnAnchorAttempted[attemptKey] = true
    local target = Vector3.new(anchor[1],anchor[2],anchor[3])
    if (target - root.Position).Magnitude < 12 then return false end
    stopPatrol()
    task.spawn(function() pcall(function() LocalPlayer:RequestStreamAroundAsync(target,2) end) end)
    char:PivotTo(CFrame.new(target + Vector3.new(0,4,0)))
    root.AssemblyLinearVelocity,root.AssemblyAngularVelocity = Vector3.zero,Vector3.zero
    Runtime.Log("SPAWN_ANCHOR_TP "..attemptKey.." distance="..string.format("%.1f",(target-root.Position).Magnitude))
    StatusLbl.Text = "Status: Đã đến điểm spawn "..world.." Room "..round
    return true
end
-- Observation runs at low frequency and only writes once per room; user's manual/seed points win.
task.spawn(function()
    while Runtime.Alive do
        task.wait(0.85)
        if Runtime.Alive and Config.AutoRecord and not GamePlaceUtil:IsMain() and not isTransitioning() then
            local ok,err = pcall(function()
                local world,room,complete = Runtime.CurrentRouteInfo()
                if world=="World1" and Runtime.CurrentWorld1Diff()~=5 then return end
                if type(world)~="string" or type(room)~="number" or room<1 or room>20 or complete==room then return end
                local savedAnchor = Config.SpawnAnchors[world] and Config.SpawnAnchors[world][tostring(room)]
                local savedCoord = Runtime.GetRecordedCoordinate(world,room)
                if validSpawnXYZ(savedAnchor) and savedCoord and
                    not (Config.AutoFallbackRooms[world] and Config.AutoFallbackRooms[world][tostring(room)]) then return end
                local char=LocalPlayer.Character
                local root=char and char:FindFirstChild("HumanoidRootPart")
                local hum=char and char:FindFirstChildOfClass("Humanoid")
                if not root or not hum or hum.Health<=0 or Runtime.RouteBusy or Runtime.Owner then return end
                if not Runtime.RecordedCoordinates[world] then return end
                local key=roomObservationKey(world,room)
                local memo=autoRoomObserve[key] or {EnteredAt=os.clock()}
                autoRoomObserve[key]=memo
                local enemy,enemyRoot=findNearestEnemy(root.Position, true)
                -- Confirm metadata when available; never learn an explicitly different room.
                if enemyRoot and enemy then
                    local valid,_,signal=getEnemyRoomContext(enemy,world,room)
                    if not valid or (signal=="no_room_tag" and (enemyRoot.Position-root.Position).Magnitude>160) then
                        enemy,enemyRoot=nil,nil
                    end
                end
                if enemyRoot then
                    persistSpawnAnchor(world,room,enemyRoot)
                    memo.HadEnemy=true
                    local isFallback = Config.AutoFallbackRooms[world] and Config.AutoFallbackRooms[world][tostring(room)]
                    if not Runtime.GetRecordedCoordinate(world,room) or isFallback then
                        local p=enemyRoot.Position
                        Runtime.SetRecordedCoordinate(world,room,{p.X,p.Y,p.Z},"AUTO-MOB-ANCHOR",true)
                    end
                elseif not Runtime.GetRecordedCoordinate(world,room) and os.clock()-memo.EnteredAt>1.8 then
                    -- Room 1 is captured as well. Upgrade fallback to mob coordinate when one appears.
                    Runtime.SetRecordedCoordinate(world,room,{root.CFrame:GetComponents()},"AUTO-FALLBACK",true)
                end
            end)
            if not ok then Runtime.Log("AUTO_RECORD_ERROR "..tostring(err)) end
        end
    end
end)

-- CLONE mode: lock Boss/MaxHP mob and teleport straight beside it.
-- No Hover, no MoveTo. Character Y matches the selected mob's root Y,
-- so clone is not held 12/30 studs above the target.
-- Reposition only if out of M1 range to avoid thrashing teleports.
function Runtime.TeleportCloneToTarget(char,root,hum,enemyRoot,force)
    if Config.UndergroundHover then return false end -- Underground owns movement, never clone TP.
    if not char or not root or not root.Parent or not hum or hum.Health<=0
        or not enemyRoot or not enemyRoot.Parent or isTransitioning()
        or Runtime.RouteBusy or Runtime.DeathRecovery or Runtime.FlySkillBusy then return false end
    local now=os.clock()
    if not force and now<(Runtime.CloneTeleportNextAt or 0) then return false end
    local delta=enemyRoot.Position-root.Position
    local flatDistance=Vector3.new(delta.X,0,delta.Z).Magnitude
    -- Protect against teleporting every 0.1s; base teleport helper stands
    -- 2.5 studs beside the mob at its height and zeros velocity.
    if not force and flatDistance<=7.0 and math.abs(delta.Y)<=6.0 then return false end
    Runtime.CloneTeleportNextAt=now+.30
    teleportOnceToTarget(char,root,hum,enemyRoot)
    return true
end

task.spawn(function()
	while Runtime.Alive and task.wait(0.1) do
		if not Runtime.Alive then break end
		local routeOK, routeError = pcall(function()
            if Runtime.EndlessSafeEntryTick and Runtime.EndlessSafeEntryTick() then return end
			Runtime.ObserveRouteRun()
			Runtime.TickRoute()
			if not GamePlaceUtil:IsMain() then Runtime.RouteDiagnostic() end
		end)
		if not routeOK then
			Runtime.CancelRoute("route tick error")
			reportError("Route observer", routeError)
		end
		if GamePlaceUtil:IsMain() or isTransitioning() or not combatFarmEnabled() or not Config.BreakChestsEggs then
			releaseEggInput(); eggSession = nil
		end
		if not GamePlaceUtil:IsMain() and not isTransitioning() and not Runtime.EntryBusy and not Runtime.Owner and not Runtime.RouteBusy then
			local ok, err = pcall(function()
                Runtime.HasCombatTarget = false
                -- Keep the last valid target through scan's 0.1s gap; clear only
                -- when the room really has no enemy, or during loot/transition.
                if not Config.SmartTargetLock or not currentEnemy then Runtime.NightReleaseAim() end
				if Runtime.DeathRecovery then releaseEggInput(); eggSession = nil; Runtime.LootActive = false; return end
				if handleSettlement() then
					releaseEggInput(); eggSession = nil
					if patrol.Busy then stopPatrol() end
					patrol.Origin = nil
					currentEnemy = nil; currentLoot = nil; return
				end

				-- Group dungeons: Solo Entry OFF does not disable teleport/combat/Hybrid if AutoAttackTeleport is ON.
				if not combatFarmEnabled() then
					if patrol.Busy then stopPatrol() end
					return
				end
				local myChar = LocalPlayer.Character
				local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart)
				local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
				if not myRoot or not myHum or myHum.Health <= 0 then
					releaseEggInput(); eggSession = nil
					if patrol.Busy then stopPatrol() end
					return
				end
				-- Capture the entry location before any teleport to a distant Elite.
				capturePatrolOrigin(myChar, myRoot)
                if Runtime.TryEndlessEntry(myChar, myRoot, myHum, false) then return end
                if Runtime.W1SyncCurrentRoom
                    and Runtime.W1SyncCurrentRoom(myChar,myRoot,myHum) then return end

				local curWorld, curRoom, curComplete = Runtime.CurrentRouteInfo()
				local isRoomCleared = (type(curRoom) == "number" and
                    (curComplete == curRoom or (Runtime.W1ObservedClear
                        and Runtime.W1ObservedClear(curWorld,curRoom))))

				-- Khi Room đã Clear và Hybrid Route có cấu hình cho phòng tiếp theo: ưu tiên Loot hợp lệ -> Chuyển phòng, bỏ qua quái phòng khác
				if isRoomCleared and Runtime.RouteExpected() and not Runtime.RouteLegacyReady()
					and not (Runtime.RouteObservationActive and Runtime.RouteObservationActive()) then
					currentEnemy = nil
					if Runtime.ProcessPostClear(myChar, myRoot, myHum) then return end
                    -- Sequential W2/W3 NEVER targets an enemy from a later room
                    -- while waiting for a valid room-clear transition or Victory.
                    if curWorld == "World2" or curWorld == "World3" or curWorld == "World1" then
                        if patrol.Busy then stopPatrol() end
                        return
                    end
				end
                -- Cleared: never enter generic 1/25 spawn patrol or chase mobs
                -- in other rooms. W1 Diff1/2 is intentionally unimplemented;
                -- W4 and W5 keep their verified legacy behavior.
                if isRoomCleared and (curWorld == "World1" or curWorld == "World2" or curWorld == "World3")
                    and not (Runtime.RouteObservationActive and Runtime.RouteObservationActive()) then
                    currentEnemy = nil
                    if patrol.Busy then stopPatrol() end
                    if Config.BreakChestsEggs then Runtime.ProcessLoot(myChar,myRoot,myHum) end
                    return
                end

				-- Khi Egg đang tương tác hợp lệ và BreakChestsEggs ON: hoàn tất Egg trước khi chọn mục tiêu khác
				if Config.BreakChestsEggs and currentLoot and currentLoot.Name:lower():find("egg") then
					handleEgg(currentLoot, myChar, myRoot, myHum)
					return
				end

				-- Kiểm tra currentEnemy còn hợp lệ với phòng hiện tại không
				if currentEnemy then
					local activeT = Runtime.RouteState and Runtime.RouteState.Active
					local inNewRoom = activeT and (activeT.Stage=="ARRIVED" or activeT.Stage=="WAIT_ROOM_UPDATE" or activeT.Stage=="ACTIVATED")
					local validEnemyRoom = getEnemyRoomContext(currentEnemy,
						inNewRoom and activeT.World or nil, inNewRoom and activeT.Destination or nil)
					if not isAliveEnemy(currentEnemy) or not validEnemyRoom then
						currentEnemy = nil
					end
				end

                -- v4.9.39: retain sticky target until death, except newly
                -- available Boss or clearly higher MaxHP in the same room.
                if currentEnemy and not Runtime.FlySkillBusy and not Runtime.QERStageBusy
                    and os.clock()>=(Runtime.NextTargetUpgradeAt or 0) then
                    Runtime.NextTargetUpgradeAt=os.clock()+1.2
                    local candidate,candidateRoot=findNearestEnemy(myRoot.Position,false)
                    if candidate and candidate~=currentEnemy and candidateRoot then
                        local bossNow,hpNow=Runtime.EnemyRankInfo(currentEnemy)
                        local bossNew,hpNew=Runtime.EnemyRankInfo(candidate)
                        local upgrade=(bossNew and not bossNow)
                            or (bossNew==bossNow and hpNew>math.max(0,hpNow)*1.55
                                and (hpNow>0 or hpNew>0))
                        if upgrade then
                            currentEnemy=candidate
                            Runtime.Log("TARGET_UPGRADE Boss="..tostring(bossNew)..
                                " MaxHP="..tostring(hpNew).." name="..tostring(candidate.Name))
                        end
                    end
                end
				if not currentEnemy then
					local newEnemy, newRoot = findNearestEnemy(myRoot.Position, false)
					if newEnemy and newRoot then
						if patrol.Busy then stopPatrol() end
						patrol.IdleSince = nil
						currentEnemy = newEnemy
						currentLoot = nil
						StatusLbl.Text = "Target: " .. newEnemy.Name
                        if Config.UndergroundHover then
                            -- v4.9.50e: Underground owns all movement even on new target.
                            -- Do not execute ASTRA +18, Bow +20, or normal melee TP here.
                            Runtime.HoverTarget=newRoot
                            updateHover()
                        elseif Config.AutoCombatPresetEnabled and Config.CombatMode=="CLONE" then
                            Runtime.TeleportCloneToTarget(myChar,myRoot,myHum,newRoot,true)
                        elseif Config.AstralOrbitCombat and not Config.ScepterCombat
                            and not Runtime.NightEquippedBow() then
                            -- Initial safe approach; the orbit worker then uses highest mob top.
                            local p=newRoot.Position+Vector3.new(12,18,0)
                            myRoot.AssemblyLinearVelocity=Vector3.zero
                            myChar:PivotTo(CFrame.new(p))
                        elseif Runtime.NightEquippedBow() then
                            local p=newRoot.Position+Vector3.new(0,20,0)
                            myRoot.AssemblyLinearVelocity=Vector3.zero
                            myChar:PivotTo(CFrame.new(p))
                        else
                            teleportOnceToTarget(myChar, myRoot, myHum, newRoot)
                        end
					end
				end

				if currentEnemy then
					Runtime.HasCombatTarget = true
					if patrol.Busy then stopPatrol() end
					patrol.IdleSince = nil
					local eRoot = getModelRoot(currentEnemy)
					if eRoot then
                        if Runtime.W1MarkEnemySeen then
                            Runtime.W1MarkEnemySeen(curWorld,curRoom,eRoot)
                        end
                        local cloneGround=Config.AutoCombatPresetEnabled and Config.CombatMode=="CLONE"
                            and not Config.UndergroundHover
                        Runtime.HoverTarget=(Config.UndergroundHover or cloneGround or Config.HoverCombat
                            or Runtime.NightEquippedBow() or Config.SmartDodge) and eRoot or nil
                        if cloneGround then
                            Runtime.TeleportCloneToTarget(myChar,myRoot,myHum,eRoot,false)
                        elseif Config.UndergroundHover or Config.HoverCombat or Runtime.NightEquippedBow() then updateHover()
                        elseif (eRoot.Position - myRoot.Position).Magnitude > 9 then
                            teleportOnceToTarget(myChar, myRoot, myHum, eRoot)
                        end
                        -- CLONE attacks immediately after a valid teleport.
                        -- Don't gate skills by height: Boss root Y can differ
                        -- from player Y even while both stand on the same floor.
                        executeCombat(myRoot,eRoot)
					else
						currentEnemy = nil
					end
					return
				end

				Runtime.HoverTarget=nil
                -- No-target grace in updateHover now handles short spawn/target gaps.
                -- Never teleport to an old above-ground position before route/loot handoff.

                if Runtime.OrbitReset and Runtime.OrbitPhase~="IDLE" then
                    Runtime.OrbitReset("no enemies in room")
                end
				if Runtime.ProcessPostClear(myChar, myRoot, myHum) then return end
				if Config.BreakChestsEggs and Runtime.ProcessLoot(myChar, myRoot, myHum) then return end

				if Runtime.TrySpawnAnchor and Runtime.TrySpawnAnchor(myChar, myRoot, myHum) then return end
                local pendingWorld=select(1,Runtime.CurrentRouteInfo())
                if (pendingWorld=="World1" or pendingWorld=="World2" or pendingWorld=="World3")
                    and Runtime.RouteObservationActive and Runtime.RouteObservationActive() then return end
				if Config.AutoPatrol then
					walkPatrol(myChar, myRoot, myHum)
				else
					if patrol.Busy then stopPatrol() end
					StatusLbl.Text = "Status: Chưa thấy quái; bật đi tìm spawn hoặc lưu tuyến."
				end
			end)
			if not ok then reportError("Dungeon", err) end
		else
			if patrol.Busy then stopPatrol() end
            Runtime.HasCombatTarget = false
            Runtime.HoverTarget = nil
            Runtime.BowMode=false
            Runtime.NightReleaseAim()
            Runtime.NightReleaseDodge("left dungeon")
			patrol.Origin = nil
			patrol.IdleSince = nil
			currentEnemy = nil
			currentLoot = nil
			settlementState.Armed = false
			settlementState.Handled = false
			settlementState.VisibleSince = nil
		end
	end
end)

-- V4.8 performance: HideFX + hard mute always ON. One initial scan,
-- then incremental events instead of Workspace:GetDescendants() every second.
-- The client never deletes hitboxes, doors, enemy models or combat state.
do
    local tracked = setmetatable({}, {__mode="k"})
    local function trackMute(obj, property, stopPlayback)
        if tracked[obj] then return end
        tracked[obj] = true
        local updating = false
        local function quiet()
            if not Runtime.Alive or not obj.Parent or updating then return end
            updating = true
            pcall(function()
                if obj.Volume ~= 0 then obj.Volume = 0 end
                if stopPlayback and obj:IsA("Sound") and obj.Playing then obj:Stop() end
            end)
            updating = false
        end
        quiet()
        table.insert(Runtime.Connections, obj:GetPropertyChangedSignal(property):Connect(quiet))
        if stopPlayback then
            table.insert(Runtime.Connections, obj:GetPropertyChangedSignal("Playing"):Connect(quiet))
        end
    end
    local function hideEffect(obj)
        if not Runtime.Alive then return end
        if obj:IsA("Sound") then trackMute(obj,"Volume",true); return end
        if obj:IsA("SoundGroup") then trackMute(obj,"Volume",false); return end
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or
            obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or
            obj:IsA("Highlight") or obj:IsA("PointLight") or obj:IsA("SpotLight") or
            obj:IsA("SurfaceLight") then
            pcall(function() obj.Enabled=false end)
            if not tracked[obj] then
                tracked[obj]=true
                table.insert(Runtime.Connections,obj:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if Runtime.Alive and obj.Parent then pcall(function()
                        if obj.Enabled then obj.Enabled=false end
                    end) end
                end))
            end
            return
        end
        if not Config.HideFX then return end
        if obj:IsA("BasePart") then
            local name=string.lower(obj.Name)
            if name:find("hitbox",1,true) or name:find("fx_",1,true) or
                name:find("vfx",1,true) or name:find("warning",1,true) then
                pcall(function() obj.LocalTransparencyModifier=1 end)
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            local name=string.lower(obj.Name)
            if name:find("fx",1,true) or name:find("warning",1,true) then
                pcall(function() obj.Transparency=1 end)
            end
        end
    end
    Runtime.FXAudioAlwaysOff=true
    -- Sources in SoundService, Workspace, Lighting and PlayerGui are handled;
    -- cloned resources are caught when parented in those live trees.
    for _,root in ipairs({SoundService,Workspace,Lighting,PlayerGui}) do
        table.insert(Runtime.Connections,root.DescendantAdded:Connect(hideEffect))
    end
    task.spawn(function()
        for _,root in ipairs({SoundService,Workspace,Lighting,PlayerGui}) do
            local items=root:GetDescendants()
            for i,obj in ipairs(items) do
                if not Runtime.Alive then return end
                hideEffect(obj)
                if i%250==0 then task.wait() end -- small batches for low-end LDPlayer
            end
        end
        Runtime.Log("FX_AUDIO_DISABLED: incremental client-side mute, no 1s Workspace sweep")
    end)
end

-- Phase 1 informational tabs; no reward remote is invoked.
Scroll = Runtime.Tabs.Rewards
addSectionHeader("Rewards — chờ Phase 5 xác minh giao thức")
Scroll = Runtime.Tabs.Settings
addSectionHeader("v23 — bản kiểm thử")
routeButton("Hiện lỗi gần nhất", function() StatusLbl.Text = Runtime.LastError end)
routeButton("In log phiên này ra console", function()
	for _, line in ipairs(Runtime.Logs) do print("[IronSoul v23] " .. line) end
end)
routeButton("Lưu log ra IronSoul_AnhLy/v23_test2_log.txt", function()
	assert(typeof(writefile) == "function", "Môi trường không hỗ trợ writefile; xem console")
	writefile(ConfigFolder .. "/v23_test2_log.txt", table.concat(Runtime.Logs, "\n"))
	StatusLbl.Text = "Đã xuất log v23"
end)
routeButton("Lưu cấu hình v23 riêng", function()
	local ok, err = saveConfig()
	assert(ok, tostring(err))
	StatusLbl.Text = "Đã lưu config_v23.json"
end)
routeButton("DỪNG SCRIPT và đóng GUI", Runtime.Stop)
Runtime.ShowTab(Config.ActiveTab)
Runtime.Log("BOOT v23-route-hotfix | PlaceId=" .. game.PlaceId .. " | JobId=" .. game.JobId)

-- Grocery diagnostics: Buy protocol supplied by user; stock/quota/receipt schema is NOT known.
do
local catalog={
 {"Hellstone4",1,30000},{"Starfall",1,25000},{"Redsunder",1,20000},{"Glacium",1,18000},{"Hellstone3",1,16000},
 {"Earthmaw",1,16000},{"Voidstar",1,15000},{"Sunflare",1,14000},{"VoidcubeCrystal",1,12000},{"RoseTourmaline",1,8000},
 {"BerylFragment",1,6000},{"IceCrystalOre",1,4000},{"Sunstone",1,2000},{"CrystalGem",3,10000},{"CrystalPrism",3,5000},
 {"CrystalFlake",3,3000},{"CrystalShards",3,1000},{"Burn_3",1,3000},{"Methysis_3",1,3000},{"Frost_3",1,3000},
 {"Corrode_3",1,3000},{"GoldPotion_1",1,2000},{"EXPPotion_1",1,2000},{"LuckPotion_1",1,15000},{"DropPotion_1",1,12000},
 {"AtkPotion_1",1,3000},{"HPPotion_1",1,3000},{"CHPotion_1",1,4000},{"BondPotion_1",1,2000},{"SeasonPotion_1",1,6000},
 {"BrokenDragonScale",5,1000},{"WholeDragonScale",5,2000},{"DragonClaw",5,3500},{"DragonHorn",5,5000},{"DragonTear",5,7500}
}
local function boundedValue(value,depth,seen)
    local kind=typeof(value)
    if kind=="string" then return value:sub(1,500) end
    if kind=="boolean" then return value end
    if kind=="number" then return value==value and math.abs(value)<math.huge and value or tostring(value) end
    if kind=="Instance" then return value.ClassName .. ":" .. value:GetFullName() end
    if kind~="table" then return "<"..kind..">" end
    if depth<=0 or seen[value] then return "<depth/cycle>" end
    seen[value]=true
    local out,count={},0
    for key,item in pairs(value) do
        count=count+1
        if count>150 then out.__truncated=true; break end
        out[tostring(key)]=boundedValue(item,depth-1,seen)
    end
    return out
end
function Runtime.DumpGrocery()
    assert(not Runtime.ShopBusy, "Đang kiểm tra Grocery")
    Runtime.ShopBusy=true
    local ok,result=pcall(function()
        local snapshot={Protocol={Action="BuyShopItem",Currency="Gold",Source="user RemoteSpy"},ObservedAt=os.time(),StockStatus="UNVERIFIED",DailyUsed="UNKNOWN /15",Modules={},NativeUI={}}
        local configs=ReplicatedStorage:FindFirstChild("Configs")
        local configModule=configs and configs:FindFirstChild("ResShop_Gold")
        local features=fwFolder:FindFirstChild("Features")
        local system=features and features:FindFirstChild("ConsumableShopSystem")
        local util=system and system:FindFirstChild("ConsumableShopUtil")
        for _,instance in pairs({Config=configModule,Util=util}) do
            if instance then
                local entry={Path=instance:GetFullName(),Class=instance.ClassName,Attributes=boundedValue(instance:GetAttributes(),2,{})}
                if instance:IsA("ModuleScript") then
                    local loaded,data=pcall(require,instance)
                    entry.Data=loaded and boundedValue(data,4,{}) or ("require failed: "..tostring(data))
                end
                snapshot.Modules[instance.Name]=entry
            end
        end
        local remote=util and util:FindFirstChild("RemoteEvent")
        snapshot.Remote=remote and remote:GetFullName() or "MISSING"
        snapshot.RemoteClass=remote and remote.ClassName or "MISSING"
        local count=0
        for _,node in ipairs(PlayerGui:GetDescendants()) do
            local path=node:GetFullName():lower()
            if (path:find("shop",1,true) or path:find("grocery",1,true)) and not node:IsDescendantOf(ScreenGui) then
                count=count+1
                if count>350 then snapshot.UITruncated=true; break end
                local row={Path=node:GetFullName(),Class=node.ClassName,Attributes=boundedValue(node:GetAttributes(),2,{})}
                if node:IsA("TextLabel") or node:IsA("TextButton") or node:IsA("TextBox") then row.Text=node.Text end
                if node:IsA("GuiObject") then row.Visible=node.Visible end
                table.insert(snapshot.NativeUI,row)
            end
        end
        return HttpService:JSONEncode(snapshot)
    end)
    Runtime.ShopBusy=false
    Runtime.ShopLastScan=os.time()
    if not ok then error(result,0) end
    Runtime.Log("SHOP_REFRESH diagnostic only; stock/quota/receipt UNKNOWN")
    if typeof(writefile)=="function" then
        writefile(ConfigFolder.."/v23_grocery_state.json",result)
        StatusLbl.Text="Đã xuất v23_grocery_state.json; lượt mua ?/15, Auto Buy khóa"
    else print("[IronSoul Grocery] "..result); StatusLbl.Text="Đã in Grocery dump ra console; lượt mua ?/15" end
end
Runtime.ToggleGuards.AutoBuy=function()
    Config.AutoBuy=false
    Runtime.Log("SHOP_BUY_FAILED BLOCKED: chưa xác minh stock/quota/receipt; không gửi BuyShopItem")
    StatusLbl.Text="Auto Buy chưa hỗ trợ an toàn. Mở Shop, bấm Dump Grocery State."
    return false
end
-- Grocery remains OFF until a verifiable receipt/stock protocol exists. UI intentionally omitted.

end

Scroll=Runtime.Tabs.Dungeon
Scroll=Runtime.Tabs.Forge
Runtime.ToggleGuards.AutoTrashSell=function(enabling)
    if enabling then
        assert(not Runtime.Owner and not isLobbyBusy and not Runtime.BatchActive and not Runtime.ForgeBusy,"Đang có tác vụ")
        assert(Runtime.MixedForgeVerified,"Test hỗn hợp 1 món KEEP thành công trong phiên trước khi bật Auto Trash SELL")
        for _,key in ipairs({"AutoForge","AutoSellEquip","AutoEquipBest"}) do
            Config[key]=false
            if Runtime.ToggleRefresh[key] then Runtime.ToggleRefresh[key]() end
        end
    end
    return true
end
for _,key in ipairs({"AutoForge","AutoSellEquip","AutoEquipBest"}) do
    Runtime.ToggleGuards[key]=function(enabling)
        assert(not enabling or (not Config.AutoTrashSell and not Runtime.BatchActive),"Tắt Auto Trash/đợi batch xong trước")
        return true
    end
end
addSectionHeader("Auto Trash Mixed — riêng với Auto Forge cũ")
addToggle("Auto Trash Forge–SELL", "AutoTrashSell")
routeButton("Xem công thức Trash kế tiếp (không tiêu đá)",function()
    local recipe=Runtime.MixedTrashRecipe(false)
    StatusLbl.Text=recipe and Runtime.RecipeText(recipe,1) or "Tổng đá hợp lệ dưới 3"
end)
routeButton("TEST hỗn hợp 1 món KEEP — xem rồi bấm lại",function()
    assert(not isLobbyBusy and not Runtime.Owner and not Runtime.ForgeBusy and not Runtime.BatchActive and not Runtime.EntryBusy,"Đang có tác vụ")
    assert(GamePlaceUtil:IsMain() and not isTransitioning() and not LocalPlayer:GetAttribute("EnterRoomId"),"Rời ô Dungeon, ở Lobby để test")
    local gui=forgingGui()
    assert(not (gui and gui.Visible),"Hoàn tất Forge thủ công trước")
    local recipe=assert(Runtime.MixedTrashRecipe(true),"Không đủ đá hỗn hợp hợp lệ")
    local key=Runtime.RecipeText(recipe,1).."|"..Config.ForgeTargetType
    if Runtime.TrashPreview~=key then Runtime.TrashPreview=key; StatusLbl.Text=key..". Bấm lại để rèn một món KEEP."; return end
    Runtime.TrashPreview=nil
    isLobbyBusy=true
    local ok,err=pcall(function() Runtime.TrashStep(true) end)
    isLobbyBusy=false
    if not ok then reportError("Mixed test",err) end
end)
Scroll=Runtime.Tabs.Rewards
routeButton("Claim All Rewards — F6",function()
    if Runtime.ClaimAllRewards then Runtime.ClaimAllRewards() end
end)
Scroll=Runtime.Tabs.Settings
routeButton("Dump Round / Room / Party attributes",function()
    local data={PlaceId=game.PlaceId,JobId=game.JobId,StreamingEnabled=Workspace.StreamingEnabled,PlayerAttributes=LocalPlayer:GetAttributes()}
    local cfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
    if cfg then data.GameRoundCfg=cfg:GetAttributes() end
    local state,room=currentLobbyRoomState()
    data.RoomState=tostring(state)
    if room then data.RoomAttributes=room:GetAttributes() end
    local encoded=HttpService:JSONEncode(data)
    if typeof(writefile)=="function" then writefile(ConfigFolder.."/v23_room_state.json",encoded) else print(encoded) end
    Runtime.Log("DIAGNOSTIC Room state exported; party attribute semantics not inferred")
end)
routeButton("RECOVER STALE WORKER LOCKS (an toàn)",function()
    local count=Runtime.RecoverWorkerLocks and Runtime.RecoverWorkerLocks(true) or 0
    StatusLbl.Text="Recovery: đã xử lý "..tostring(count).." khóa mồ côi; Forge không chắc vẫn bị khóa."
end)
routeButton("Trạng thái worker",function()
    StatusLbl.Text="Owner="..(Runtime.Owner and Runtime.Owner.Name or "legacy/idle").." | Entry="..tostring(Runtime.EntryBusy).." Forge="..tostring(Runtime.ForgeBusy).." Route="..tostring(Runtime.RouteBusy).." Shop="..tostring(Runtime.ShopBusy)
end)
Runtime.ShowTab(Config.ActiveTab)


-- ===============================================================================
-- COMPACT v4 UI | only Dungeon, Record, Combat and Forge are visible.
-- Original v3 World4 route state machine, Combat, Loot and entry remotes stay intact.
-- ===============================================================================
local UserInputService = game:GetService("UserInputService")
for _,popup in ipairs(activePopups) do if popup.Parent then popup:Destroy() end end
table.clear(activePopups)
for _,tabName in ipairs({"Dungeon","Record","Combat","Forge","Utilities","Spin"}) do
    local page=Runtime.Tabs[tabName]
    page:ClearAllChildren()
    local layout=Instance.new("UIListLayout",page)
    layout.Padding=UDim.new(0,6)
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.SortOrder=Enum.SortOrder.LayoutOrder
end
local function compactButton(parent, label, callback, color)
    local b=Instance.new("TextButton",parent)
    b.BackgroundColor3=color or Color3.fromRGB(49,83,125)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold
    b.TextSize=12
    b.Text=label
    b.Size=UDim2.new(0.94,0,0,33)
    orderWidget(b)
    b.MouseButton1Click:Connect(function()
        local ok,err=pcall(callback)
        if not ok then reportError(label,err) end
    end)
    return b
end
local function compactLabel(parent, label, size)
    local lbl=Instance.new("TextLabel",parent)
    lbl.Size=UDim2.new(0.94,0,0,size or 28)
    lbl.BackgroundColor3=Color3.fromRGB(37,36,53)
    lbl.TextColor3=Color3.fromRGB(237,231,252)
    lbl.Font=Enum.Font.GothamSemibold
    lbl.TextSize=12
    lbl.TextWrapped=true
    lbl.Text=label
    orderWidget(lbl)
    return lbl
end
-- v4.9.50c: Underground controls must be made AFTER the legacy pages are cleared.
-- Defined out-of-line to protect the large Luau AIO function's local-register budget.
function Runtime.CreateUndergroundCombatControls(parent)
    if not parent or parent:FindFirstChild("UndergroundToggleV50c") then return end
    local heading=compactLabel(parent,"00  |  ASTRAL + UNDERGROUND  ·  NOCLIP",29)
    heading.Name="UndergroundHeadingV50c"
    heading.LayoutOrder=-310
    heading.BackgroundColor3=Color3.fromRGB(32,71,85)
    heading.TextColor3=Color3.fromRGB(236,245,254)
    local toggle,depth
    local function refresh()
        if not (toggle and depth) then return end
        local enabled=Config.CombatMode=="ASTRAL_UG" and Config.AutoCombatPresetEnabled
        toggle.Text="ASTRAL + UNDERGROUND MODE: "..(enabled and "ON" or "OFF")
        toggle.BackgroundColor3=enabled and Color3.fromRGB(40,137,93) or Color3.fromRGB(124,65,67)
        depth.Text="ĐỘ SÂU DƯỚI SÀN: -"..tostring(math.clamp(tonumber(Config.UndergroundDepth) or 8,4,20)).." studs  (BẤM ĐỂ ĐỔI)"
    end
    toggle=compactButton(parent,"ASTRAL + UNDERGROUND MODE: OFF",function()
        local enabling=Config.CombatMode~="ASTRAL_UG" or not Config.AutoCombatPresetEnabled
        if enabling then
            local ok,p=pcall(Runtime.ResolveSkillProfile,"Skill1",true)
            if not ok or type(p)~="table" or p.Id~="Staff_Rastar_Skill_Backflip" then
                StatusLbl.Text="ASTRAL + UNDERGROUND cần Astral Rastar đang trang bị."
                return
            end
        end
        local guard=Runtime.ToggleGuards and Runtime.ToggleGuards.UndergroundHover
        if guard then
            local ok,allow=pcall(guard,enabling)
            if not ok then error("Underground guard: "..tostring(allow)) end
            if allow==false then refresh(); return end
        end
        Config.CombatMode=enabling and "ASTRAL_UG" or "ASTRAL"
        Config.AutoCombatPresetEnabled=true
        Config.UndergroundHover=enabling
        if Runtime.AutoCombatSync then Runtime.AutoCombatSync(true) end
        saveConfig()
        refresh()
        Runtime.Log("COMBAT_MODE_ASTRAL_UG "..tostring(enabling))
    end,Color3.fromRGB(124,65,67))
    toggle.Name="UndergroundToggleV50c"
    toggle.LayoutOrder=-309
    toggle.Size=UDim2.new(.94,0,0,42)
    toggle.TextWrapped=true
    depth=compactButton(parent,"ĐỘ SÂU DƯỚI SÀN: -8 studs",function()
        local current=math.clamp(math.floor(tonumber(Config.UndergroundDepth) or 8),4,20)
        Config.UndergroundDepth=({[4]=6,[6]=8,[8]=10,[10]=12,[12]=16,[16]=20,[20]=4})[current] or 8
        saveConfig()
        refresh()
        Runtime.Log("UNDERGROUND_UI_DEPTH "..tostring(Config.UndergroundDepth))
    end,Color3.fromRGB(49,77,106))
    depth.Name="UndergroundDepthV50c"
    depth.LayoutOrder=-308
    depth.Size=UDim2.new(.94,0,0,39)
    depth.TextWrapped=true
    local note=compactLabel(parent,"Chọn ASTRAL + UNDERGROUND ở mục 01. -4 đến -20 studs; thử -12 trước. Không tự kéo lên khi mất target.",42)
    note.Name="UndergroundNoteV50c"
    note.LayoutOrder=-307
    note.TextSize=11
    note.BackgroundColor3=Color3.fromRGB(31,43,56)
    local legacyRefresh=Runtime.ToggleRefresh and Runtime.ToggleRefresh.UndergroundHover
    Runtime.ToggleRefresh.UndergroundHover=function()
        if legacyRefresh then pcall(legacyRefresh) end
        refresh()
    end
    refresh()
    Runtime.Log("UNDERGROUND_GUI_V50C_CREATED in visible Combat column")
end

local function compactTextBox(parent, label, initial)
    local row=Instance.new("Frame",parent)
    orderWidget(row)
    row.Size=UDim2.new(0.94,0,0,32)
    row.BackgroundTransparency=1
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(.55,0,1,0)
    lbl.BackgroundTransparency=1
    lbl.TextColor3=Color3.new(1,1,1)
    lbl.TextSize=11
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Text=label
    local input=Instance.new("TextBox",row)
    input.Position=UDim2.new(.56,0,0,0)
    input.Size=UDim2.new(.44,0,1,0)
    input.BackgroundColor3=Color3.fromRGB(47,46,65)
    input.TextColor3=Color3.new(1,1,1)
    input.TextSize=12
    input.ClearTextOnFocus=false
    input.Text=tostring(initial or "")
    return input
end
-- DUNGEON: Auto Farm alone controls Solo Auto Entry; no independent Create switch.
Scroll=Runtime.Tabs.Dungeon
addSectionHeader("Dungeon  |  SOLO + TOWER COUNTERS")
addDropdown("Map",worldItems,"SelectedWorld")
addDropdown("Difficulty",diffItems,"SelectedDiff")
addDropdown("When Finished",runEndItems,"RunEndAction")
Runtime.ToggleGuards.AutoFarm=function(nextOn)
    if nextOn and Config.SelectedWorld~="Endless1" and Runtime.DungeonCounterReached and Runtime.DungeonCounterReached()
        and not Runtime.CloneDailyActive and not (Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled()) then
        error("Dungeon đã đủ số lượt; chỉnh mục tiêu hoặc RESET bộ đếm trước")
    end
    if nextOn then Runtime.SuppressAutoCreate=false end
    Config.AutoStartDungeon=nextOn
    return true
end
addToggle("Auto Farm Solo (Auto Entry + Combat)","AutoFarm")

-- Visible Tower controls in the FINAL compact Dungeon GUI (legacy controls were cleared).
function Runtime.CreateTowerCompactControls(parent)
    local st=assert(Runtime.TowerCounter,"Tower manager chưa khởi tạo")
    local heading=compactLabel(parent,"02  |  ENDLESS TOWER — AUTO 3 LƯỢT / LEVEL TÙY CHỌN",38)
    heading.BackgroundColor3=Color3.fromRGB(47,62,95)
    heading.TextColor3=Color3.fromRGB(247,230,161)
    local status=compactLabel(parent,"Tower đang tải...",39)
    status.TextWrapped=true
    local goal=compactTextBox(parent,"SỐ LƯỢT MỤC TIÊU",st.Target)
    goal.Name="TowerTargetV50d"
    local floor=compactTextBox(parent,"LEVEL TOWER (vd: 1)",st.Floor)
    floor.Name="TowerFloorV50d"
    local btn
    local function update()
        local used=Runtime.TowerGetUsed()
        status.Text=string.format("ENDLESS: %d / %d lượt | Level %d | UTC %s%s",used,st.Target,st.Floor,st.Day,
            Runtime.CloneDailyTowerActive and " | CLONE" or "")
        if btn then
            btn.Text=st.AutoEnabled and "[ON] AUTO TOWER — BẤM ĐỂ DỪNG" or "[OFF] AUTO TOWER — CHẠY ĐỦ LƯỢT"
            btn.BackgroundColor3=st.AutoEnabled and Color3.fromRGB(29,124,85) or Color3.fromRGB(57,94,133)
        end
    end
    local function saveInputs()
        Runtime.TowerSetInputs(goal.Text,floor.Text)
        goal.Text=tostring(st.Target)
        floor.Text=tostring(st.Floor)
        update()
    end
    goal.FocusLost:Connect(function()
        if not Runtime.Alive then return end
        local ok,err=pcall(saveInputs)
        if not ok then Runtime.Log("TOWER_TARGET_INVALID "..tostring(err));goal.Text=tostring(st.Target) end
    end)
    floor.FocusLost:Connect(function()
        if not Runtime.Alive then return end
        local ok,err=pcall(saveInputs)
        if not ok then Runtime.Log("TOWER_LEVEL_INVALID "..tostring(err));floor.Text=tostring(st.Floor) end
    end)
    compactButton(parent,"LƯU SỐ LƯỢT + LEVEL",function() saveInputs() end)
    btn=compactButton(parent,"[OFF] AUTO TOWER — CHẠY ĐỦ LƯỢT",function()
        if st.AutoEnabled then Runtime.TowerAutoToggle(false)
        else saveInputs();Runtime.TowerAutoToggle(true) end
        update()
    end)
    compactButton(parent,"TOWER +1 (CHỈNH TAY)",function() Runtime.TowerManualAdjust(1);update() end)
    compactButton(parent,"TOWER -1 (CHỈNH TAY)",function() Runtime.TowerManualAdjust(-1);update() end)
    compactButton(parent,"RESET BỘ ĐẾM TOWER (KHI OFF)",function() Runtime.TowerReset();update() end,Color3.fromRGB(102,70,75))
    local hint=compactLabel(parent,"Clone Daily dùng chung LEVEL và bộ đếm này. Một lượt tính khi vào Tower thật; lượt cuối vẫn đánh rồi về Lobby.",53)
    hint.TextSize=11
    Runtime.TowerCounterUIRefresh=update
    update()
    Runtime.Log("TOWER_V50D_VISIBLE_COMPACT_DUNGEON_UI")
end
Runtime.CreateTowerCompactControls(Runtime.Tabs.Dungeon)

function Runtime.CreateDungeonCounterCompactControls(parent)
    local st=assert(Runtime.DungeonCounter,"Thiếu Dungeon counter")
    local heading=compactLabel(parent,"03  |  DUNGEON RUN COUNTER (0 = VÔ HẠN)",34)
    heading.BackgroundColor3=Color3.fromRGB(47,63,96)
    local status=compactLabel(parent,"Số lượt Dungeon đang tải...",35)
    local input=compactTextBox(parent,"SỐ LƯỢT DUNGEON",st.Target)
    input.Name="DungeonRunTargetV50d"
    local function refresh()
        status.Text=string.format("DUNGEON: %d lượt đã clear / %s | UTC %s",st.Used,st.Target==0 and "VÔ HẠN" or tostring(st.Target),st.Day)
    end
    local function setTarget()
        Runtime.DungeonCounterSetTarget(input.Text)
        input.Text=tostring(st.Target)
        refresh()
    end
    input.FocusLost:Connect(function()
        if not Runtime.Alive then return end
        local ok,err=pcall(setTarget)
        if not ok then Runtime.Log("DUNGEON_COUNTER_INVALID "..tostring(err));input.Text=tostring(st.Target) end
    end)
    compactButton(parent,"LƯU SỐ LƯỢT DUNGEON",setTarget)
    compactButton(parent,"DUNGEON +1 (CHỈNH TAY)",function() Runtime.DungeonCounterAdjust(1);refresh() end)
    compactButton(parent,"DUNGEON -1 (CHỈNH TAY)",function() Runtime.DungeonCounterAdjust(-1);refresh() end)
    compactButton(parent,"RESET DUNGEON COUNTER",function() Runtime.DungeonCounterReset();refresh() end)
    local hint=compactLabel(parent,"Chỉ đếm World/Cave clear SUCCESS đủ lượt. Khi chạm mục tiêu, về Lobby rồi AutoFarm OFF. Clone Daily không bị đếm chồng.",52)
    hint.TextSize=11
    Runtime.DungeonCounterUIRefresh=refresh
    refresh()
    Runtime.Log("DUNGEON_COUNTER_V50D_VISIBLE_UI")
end
Runtime.CreateDungeonCounterCompactControls(Runtime.Tabs.Dungeon)

-- COMBAT: hover/FX always ON behind the scenes; the three toggles remain accessible.
Scroll=Runtime.Tabs.Combat
addSectionHeader("Combat")
addToggle("Auto Attack Teleport (Team / Dungeon)","AutoAttackTeleport")

addToggle("Auto Base Attack","AutoM1")
addToggle("Auto Skills","AutoSkills")
addToggle("Auto Chest & Egg","BreakChestsEggs")
-- v4.9.4: compact UI clears the legacy Combat page above; restore the 3
-- v4.9 opt-in controls HERE, after the clear, so they're actually clickable.
addToggle("SMART DODGE (+30 thường / né ngang Halloween)","SmartDodge")
addToggle("SMART TARGET LOCK (3D)","SmartTargetLock")
addToggle("BOW COMBAT (+20, DYNAMIC STAGES)","BowCombat")
-- Scepter Mode only controls weapon-specific cast/hover, NOT horizontal preferences.
Runtime.ToggleGuards.ScepterCombat=function(enabling)
    if enabling and Config.AstralOrbitCombat then
        Config.AstralOrbitCombat=false
        if Runtime.OrbitReset then Runtime.OrbitReset("Scepter enabled") end
        if Runtime.ToggleRefresh.AstralOrbitCombat then Runtime.ToggleRefresh.AstralOrbitCombat() end
    end
    if not enabling then
        if Runtime.CancelLaser then Runtime.CancelLaser("Scepter mode disabled") end
        if Runtime.CloseScepterS5 then Runtime.CloseScepterS5() end
    end
    return true
end
Runtime.ToggleGuards.AutoSkills=function(enabling)
    if not enabling and Runtime.CancelLaser then Runtime.CancelLaser("AutoSkills disabled") end
    return true
end
addToggle("SCEPTER MODE: +30 / Staff S5 + Rapid G", "ScepterCombat")
-- S5+G ONLY retired: user testing showed FULL skills clear faster.
-- Legacy ScepterCombat still supports FULL skill + Beam only, behind the auto preset.
Config.ScepterCombatMode="FULL"
Runtime.ToggleGuards.HalloweenMode=function(enabling)
    if not enabling then
        Runtime.HalloweenDodgePosition=nil
        Runtime.HalloweenDodgeLastMoveAt=0
        Runtime.DodgeActive=false
        Runtime.DodgeUntil=0
    end
    return true
end
-- Astral Rastar: optional group-pull state machine, safe for any staff but
-- disables legacy S5 mode so Exclusive skill IDs dispatch via the resolver.
Runtime.ToggleGuards.AstralOrbitCombat=function(enabling)
    if enabling then
        Config.ScepterCombat=false
        Config.BowCombat=false
        Config.HoverCombat=true
        Config.AutoSkills=true
        if Runtime.ToggleRefresh.ScepterCombat then Runtime.ToggleRefresh.ScepterCombat() end
        if Runtime.ToggleRefresh.BowCombat then Runtime.ToggleRefresh.BowCombat() end
        if Runtime.ToggleRefresh.AutoSkills then Runtime.ToggleRefresh.AutoSkills() end
        if Runtime.CancelFlySkill then Runtime.CancelFlySkill("Astral orbit enabled") end
        if Runtime.CancelLaser then Runtime.CancelLaser("Astral orbit enabled") end
    end
    if Runtime.OrbitReset then Runtime.OrbitReset(enabling and "orbit enabled" or "orbit disabled") end
    return true
end
addToggle("ASTRAL RASTAR: Q/E/R/G FIRST (M1 LOW PRIORITY)","AstralSkillPriority")
addToggle("ASTRAL Q: FAST 0.12s PHASES (TEST)","AstralFastQ")
addToggle("ASTRAL R: RUSH PHASE3 (TEST - MAY LOSE 9 HITS)","AstralRFastTest")
addToggle("ASTRAL M1: CORRECT BULLETS WHEN SKILLS IDLE","AstralRastarM1Projectiles")
addToggle("ASTRAL: CIRCLE +12 LURE -> +30 FULL SKILLS", "AstralOrbitCombat")
addDropdown("ASTRAL circle radius",{
    {val=8,text="8 studs"},{val=10,text="10 studs"},
    {val=12,text="12 studs (default)"},{val=16,text="16 studs"},
    {val=20,text="20 studs"},{val=24,text="24 studs"}
},"AstralOrbitRadius")
addDropdown("ASTRAL max lure time",{
    {val=2,text="2s"},{val=3,text="3s"},
    {val=4.5,text="4.5s (default)"},{val=6,text="6s"},{val=8,text="8s"}
},"AstralOrbitPullSeconds")
addDropdown("ASTRAL burst time",{
    {val=3,text="3s"},{val=5,text="5s"},
    {val=7,text="7s (default)"},{val=10,text="10s"},{val=15,text="15s"}
},"AstralOrbitBurstSeconds")
compactButton(Scroll,"ASTRAL ORBIT STATUS",function()
    local st=Runtime.OrbitState or {}
    StatusLbl.Text=string.format("ASTRAL %s | mobs %d | in 19-stud group %d | E:%s Q:%s R:%s G:%s",
        tostring(Runtime.OrbitPhase),tonumber(st.Total) or 0,tonumber(st.Near) or 0,
        tostring(Runtime.OrbitUsedSlots.Skill2==true),
        tostring(Runtime.OrbitUsedSlots.Skill1==true),
        tostring(Runtime.OrbitUsedSlots.SkillU==true),
        tostring(Runtime.OrbitUsedSlots.SkillAW==true))
end,Color3.fromRGB(55,82,130))
addToggle("HALLOWEEN MODE: hover +20 / né ngang RedShow", "HalloweenMode")
addDropdown("Scepter G request interval",{
    {val=.01,text="0.01s (100 req/s theoretical)"},
    {val=.02,text="0.02s"},{val=.03,text="0.03s"},
    {val=.05,text="0.05s"},{val=.08,text="0.08s"},
    {val=.10,text="0.10s (default)"},
    {val=.15,text="0.15s"},{val=.20,text="0.20s"}
},"ScepterGInterval")
addToggle("RAPID G: BYPASS CLIENT CD GATE (TEST)","ScepterGBypassClientCooldown")
addDropdown("SCEPTER S5 packet interval (server may reject)",{
    {val=.04,text="0.04s"},{val=.06,text="0.06s"},
    {val=.08,text="0.08s (default)"},{val=.10,text="0.10s"},
    {val=.12,text="0.12s"},{val=.16,text="0.16s"},
    {val=.20,text="0.20s"},{val=.30,text="0.30s"},
    {val=.50,text="0.50s"},{val=1,text="1.00s"}
},"ScepterS5Interval")
addToggle("AIM: VERTICAL 90 DOWN (body/camera)","Aim3DDown")
addToggle("DYNAMIC: HOLD MULTI-HIT BY METADATA (TEST)","DynamicHoldMultiHit")
compactButton(Scroll,"SHOW EQUIPPED SKILL IDs / STAGES",function()
    local names={BaseAttack="M1",Skill1="Q",Skill2="E",SkillU="R",SkillAW="G"}
    local lines={}
    for _,slot in ipairs({"BaseAttack","Skill1","Skill2","SkillU","SkillAW"}) do
        local p=Runtime.ResolveSkillProfile(slot,true)
        local label=names[slot]
        if p then
            local phases={}
            for _,stage in ipairs(p.Phases) do phases[#phases+1]=tostring(stage) end
            local line=label.."="..p.Id.." ["..table.concat(phases,",").."]"
            lines[#lines+1]=line
            Runtime.Log("EQUIPPED_SKILL "..line)
        else
            lines[#lines+1]=label.."=NOT RESOLVED"
            Runtime.Log("EQUIPPED_SKILL "..label.." NOT RESOLVED")
        end
    end
    StatusLbl.Text=table.concat(lines," | ")
end,Color3.fromRGB(50,86,116))

Runtime.MeleeM1InfoLabel=compactLabel(Scroll,
    "M1 client: stages=0 | S5=0 | End=0 | err=0",28)
compactButton(Scroll,"SHOW MELEE M1 STATS",function()
    local secondsSince=(Runtime.MeleeM1LastSentAt or 0)>0
        and string.format("%.2fs",os.clock()-Runtime.MeleeM1LastSentAt) or "never"
    StatusLbl.Text=string.format("M1 stages=%d | S5=%d | End=%d | errors=%d | last=%s | policy=%s. Sent != damage.",
        Runtime.MeleeM1Sent or 0,Runtime.ScepterS5Sent or 0,Runtime.MeleeM1EndSent or 0,
        Runtime.MeleeM1Errors or 0,secondsSince,
        Config.ScepterCombat and "SCEPTER S5 CONCURRENT" or "M1 + SKILL CONCURRENT")
end,Color3.fromRGB(43,108,100))
compactButton(Scroll,"SHOW LASER STATUS (no HP scan)",function()
    local active=Runtime.LaserActive
    local remaining=math.max(0,(Runtime.LaserHoldUntil or 0)-os.clock())
    StatusLbl.Text=string.format("Laser active=%s | Stage2 hold remaining=%.2fs | completed=%d | server hits unverified",
        tostring(active),remaining,Runtime.LaserCompleted or 0)
end,Color3.fromRGB(62,90,130))
compactButton(Scroll,"SHOW RAPID G STATS",function()
    local elapsed=math.max(.1,os.clock()-(Runtime.ScepterGStartedAt or os.clock()))
    local avg=(Runtime.ScepterGCount or 0)>1 and ((Runtime.ScepterGCount-1)/elapsed) or 0
    StatusLbl.Text=string.format("G req %.3fs | clientCD=%s | stage1=%d | finished=%d | avg %.2f/s | last100 %.2f/s | errors=%d. Hits NOT verified.",
        Config.ScepterGInterval,Config.ScepterGBypassClientCooldown and "BYPASS" or "RESPECT",
        Runtime.ScepterGStage1Attempts or 0,Runtime.ScepterGCount or 0,avg,
        Runtime.ScepterGRecentRate or 0,Runtime.ScepterGErrorCount or 0)
end,Color3.fromRGB(44,90,123))
compactButton(Scroll,"SHOW Q/E/R PRIORITY STATS",function()
    local start=Runtime.QERDispatchCount or {}
    local done=Runtime.QERFinishedCount or {}
    StatusLbl.Text=string.format("Q %d/%d | E %d/%d | R %d/%d | horiz deferred=%d | G=%d (stage1/stage2-end, not server damage)",
        start.Skill1 or 0,done.Skill1 or 0,start.Skill2 or 0,done.Skill2 or 0,
        start.SkillU or 0,done.SkillU or 0,Runtime.QERHorizontalDeferred or 0,
        Runtime.ScepterGCount or 0)
end,Color3.fromRGB(44,90,123))

addDropdown("Hover above tallest mob", {
    {val=8,text="8 studs"},{val=10,text="10 studs"},
    {val=12,text="12 studs"},{val=15,text="15 studs"},
    {val=18,text="18 studs"},{val=22,text="22 studs"}
},"HoverHeight")
addToggle("DYNAMIC FLY SKILLS (Q/E/R/G)","FlyDynamicSkills")
addToggle("Q / Skill1: fire HORIZONTAL", "FlyHorizontalQ")
addToggle("E / Skill2: fire HORIZONTAL", "FlyHorizontalE")
addToggle("R / Ultimate: fire HORIZONTAL", "FlyHorizontalR")
addToggle("G / Scroll: fire HORIZONTAL", "FlyHorizontalG")
addToggle("HOTKEY Q/E/R/G override when horizontal", "FlyHotkeys")
compactLabel(Scroll,"STAFF: Q ngang 1-2-3 (cách quái 10-14) | E cao 1 | R cao 1-2 | G cao 1. Cần test hit.",38)
addDropdown("Horizontal cast distance", {
    {val=28,text="28 studs"},{val=32,text="32 studs"},
    {val=38,text="38 studs"},{val=45,text="45 studs"},
    {val=52,text="52 studs"}
},"FlyCastDistance")
addDropdown("Horizontal cast hold", {
    {val=0.05,text="0.05s"},{val=0.10,text="0.10s"},
    {val=0.15,text="0.15s"},{val=0.20,text="0.20s"},
    {val=0.35,text="0.35s"},{val=0.85,text="0.85s"}
},"FlyCastHold")


-- RECORD: one-line status, RoomList with TP+SAVE only, auto capture, five lobby pads.
Scroll=Runtime.Tabs.Record
addSectionHeader("Record")
local simpleLive=compactLabel(Scroll,"World -, Room -, Cleared -",33)
addToggle("Auto Record / Spawn Anchor","AutoRecord")
local compactWorldItems={
    {text="World1",val="World1"},{text="World2",val="World2"},
    {text="World3",val="World3"},{text="World4",val="World4"},
    {text="World5",val="World5"},{text="Endless1",val="Endless1"}
}
do
    local liveW=Runtime.CurrentRouteInfo()
    -- At Lobby the game may report World1 by default even when the user is
    -- organizing saved World2/3 coordinates. Preserve the selected world there.
    if not GamePlaceUtil:IsMain() and Runtime.RecordedCoordinates[liveW] then
        Config.SelectedRecordWorld=liveW
    end
end
addDropdown("RoomList World",compactWorldItems,"SelectedRecordWorld")
local compactRoomList=Instance.new("ScrollingFrame",Scroll)
orderWidget(compactRoomList)
compactRoomList.Size=UDim2.new(.94,0,0,192)
compactRoomList.BackgroundColor3=Color3.fromRGB(28,28,42)
compactRoomList.ScrollBarThickness=4
compactRoomList.AutomaticCanvasSize=Enum.AutomaticSize.Y
compactRoomList.CanvasSize=UDim2.new()
local compactRoomLayout=Instance.new("UIListLayout",compactRoomList)
compactRoomLayout.Padding=UDim.new(0,3)
compactRoomLayout.SortOrder=Enum.SortOrder.LayoutOrder
local compactRefreshRoomList
local compactRecordTP
local function recordSaveAt(world, room)
    assert(world~="World1" or Runtime.CurrentWorld1Diff()==5,
        "World1 Diff1/2 layout riêng: chưa cho SAVE đè tọa độ Diff5")
    local saved=Runtime.RecordSaveCurrent(world,room)
    if saved then StatusLbl.Text="Saved "..world.." Room "..room;compactRefreshRoomList() end
end
compactRecordTP=function(world,room)
    assert(world~="World1" or Runtime.CurrentWorld1Diff()==5,
        "World1 Diff1/2 layout riêng: không TP bằng tọa độ Diff5")
    Runtime.RecordManualTest(world,room)
    task.spawn(function()
        -- The original Recorder deliberately pauses Hybrid after manual test; compact UI resumes it.
        while Runtime.Alive and state.Active do task.wait(.2) end
        if Runtime.Alive then
            state.ManualPause=false
            Runtime.Log("COMPACT_RECORD_AUTO_RESUME "..world.." R"..room)
        end
    end)
end
compactRefreshRoomList=function()
    for _,node in ipairs(compactRoomList:GetChildren()) do
        if node~=compactRoomLayout then node:Destroy() end
    end
    local world=tostring(Config.SelectedRecordWorld)
    local maxRoom=1
    for roomKey in pairs(Runtime.RecordedCoordinates[world] or {}) do
        local r = tonumber(roomKey)
        if r and r%1==0 and r>=1 and r<=20 and r>maxRoom then maxRoom=r end
    end
    local liveW,liveR=Runtime.CurrentRouteInfo()
    if liveW==world and type(liveR)=="number" then maxRoom=math.min(20,math.max(maxRoom,liveR)) end
    for room=1,maxRoom do
        local row=Instance.new("Frame",compactRoomList)
        row.Size=UDim2.new(1,-7,0,34)
        row.BackgroundColor3=Color3.fromRGB(36,36,51)
        row.LayoutOrder=room
        local name=Instance.new("TextLabel",row)
        name.Size=UDim2.new(.47,0,1,0)
        name.BackgroundTransparency=1
        name.TextColor3=Color3.new(1,1,1)
        name.Font=Enum.Font.GothamSemibold
        name.TextSize=12
        name.Text="Room "..room
        local hasPos=Runtime.GetRecordedCoordinate(world,room)~=nil
        for i,buttonName in ipairs({"TP","SAVE"}) do
            local btn=Instance.new("TextButton",row)
            btn.Position=UDim2.new(i==1 and .48 or .74,0,0,3)
            btn.Size=UDim2.new(.24,0,1,-6)
            btn.Text=buttonName
            btn.TextSize=12
            btn.Font=Enum.Font.GothamBold
            btn.TextColor3=Color3.new(1,1,1)
            btn.BackgroundColor3=(buttonName=="TP" and not hasPos) and Color3.fromRGB(55,55,66) or Color3.fromRGB(46,84,126)
            btn.MouseButton1Click:Connect(function()
                local ok,err=pcall(function()
                    if buttonName=="TP" then
                        assert(Runtime.GetRecordedCoordinate(world,room),"Room này chưa có tọa độ")
                        compactRecordTP(world,room)
                    else recordSaveAt(world,room) end
                end)
                if not ok then reportError("Record "..buttonName,err) end
            end)
        end
    end
end
Runtime.RefreshRecordUI=function()
    if not Runtime.Alive then return end
    compactRefreshRoomList()
end
compactButton(Scroll,"SAVE CURRENT LOCATION",function()
    local world,room=Runtime.CurrentRouteInfo()
    assert(type(world)=="string" and type(room)=="number" and room>=1 and room<=20,"Chưa có World/Room")
    assert(world~="World1" or Runtime.CurrentWorld1Diff()==5,
        "World1 Diff1/2 cần Route riêng; chưa cho SAVE đè tọa độ Diff5")
    local wasSaved=Runtime.GetRecordedCoordinate(world,room)~=nil
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    assert(root and hum and hum.Health>0 and not isTransitioning(),"Nhân vật chưa sẵn sàng")
    Runtime.SetRecordedCoordinate(world,room,{root.CFrame:GetComponents()},"USER-MANUAL",true)
    if not wasSaved then Runtime.SetAutoRouteEnabled(world,room,true,true) end
    Config.SelectedRecordWorld=world
    Config.SelectedRecordRoom=room
    saveConfig()
    compactRefreshRoomList()
    StatusLbl.Text="SAVE CURRENT LOCATION: "..world.." Room "..room
end,Color3.fromRGB(43,132,78))
compactLabel(Scroll,"ScreenMatch (F1-F5): TP only, never Create",30)
local lobbyPadButtons={
    {"World 1/2","World1_2",Enum.KeyCode.F1},
    {"World 3/4/5","World3_4",Enum.KeyCode.F2},
    {"Tower","Endless",Enum.KeyCode.F3},
    {"Valhalla","Valhalla",Enum.KeyCode.F4},
    {"Cave","Cave",Enum.KeyCode.F5}
}
local function teleportToPad(padKey)
    assert(GamePlaceUtil:IsMain() and lobbyCharacterReady() and not isTransitioning(),"Chỉ TP cổng khi ở Lobby")
    assert(not Runtime.EntryBusy and not Runtime.ForgeBusy and not Runtime.BatchActive and not Runtime.Owner,"Đang có tác vụ")
    local coords=assert(DefaultPortalEntrances[padKey],"Thiếu cổng mặc định")
    local char=LocalPlayer.Character
    local root=assert(char:FindFirstChild("HumanoidRootPart"),"Thiếu RootPart")
    Runtime.SuppressAutoCreate=true
    root.AssemblyLinearVelocity,root.AssemblyAngularVelocity=Vector3.zero,Vector3.zero
    char:PivotTo(CFrame.new(coords[1],coords[2],coords[3]))
    StatusLbl.Text="ScreenMatch: "..padKey.." (TP only)"
end
Runtime.ScreenMatchTP=teleportToPad
for _,p in ipairs(lobbyPadButtons) do
    local label,key=p[1],p[2]
    compactButton(Scroll,label.."  ["..p[3].Name.."]",function() teleportToPad(key) end)
end
-- F6 one-shot rewards (Hydroxide traces supplied by the user). A sent request
-- is NOT proof the server granted the reward. Halloween remains manual.
Runtime.ClaimBusy=false
Runtime.ClaimAllRewards=function()
    if Runtime.ClaimBusy or not Runtime.Alive then return end
    Runtime.ClaimBusy=true
    task.spawn(function()
        local sent,failed=0,0
        local function child(root,...)
            local node=root
            for _,name in ipairs({...}) do node=node and node:FindFirstChild(name) end
            return node
        end
        local frameworkRoot=ReplicatedStorage:FindFirstChild("Framework")
        local eventRE=child(frameworkRoot,"Gameplay","EventHallSystem","EventHallRE")
        local seasonRE=child(frameworkRoot,"Features","SeasonSystem","SeasonUtil","RemoteEvent")
        local dailyRE=child(frameworkRoot,"Features","DailyQuestSystem","RE")
        local updateRE=child(frameworkRoot,"Features","UpdateLogSystem","RemoteEvent")
        local function send(remote,...)
            if not Runtime.Alive then return end
            if remote and remote:IsA("RemoteEvent") then
                local args=table.pack(...)
                local ok=pcall(function() remote:FireServer(table.unpack(args,1,args.n)) end)
                if ok then sent=sent+1 else failed=failed+1 end
            else failed=failed+1 end
            task.wait(0.15)
        end
        send(dailyRE,"ClickGetReward")
        -- Update Log versions supplied by the user, always one F6-triggered pass.
        for _,version in ipairs({"V14.0","V13.3","V13.2","V13.1","V13.0"}) do
            if not Runtime.Alive then break end
            send(updateRE,"ClaimReward",version)
        end
        send(eventRE,"ClaimGrowthPath","Growth")
        for level=1,50 do
            if not Runtime.Alive then break end
            send(seasonRE,"Claim",level)
        end
        for day=1,28 do
            if not Runtime.Alive then break end
            send(eventRE,"ClaimDailyLogin","ArcaneLogin","DR_"..day)
        end
        if Runtime.Alive then
            StatusLbl.Text=string.format("F6: đã gửi %d yêu cầu, lỗi gửi %d; xem thưởng trong game",sent,failed)
            Runtime.Log(string.format("CLAIM_REWARDS sent=%d failed=%d server outcomes not verified",sent,failed))
        end
        Runtime.ClaimBusy=false
    end)
end
compactButton(Scroll,"F6 — CLAIM REWARDS (một lượt)",function() Runtime.ClaimAllRewards() end)
-- Manual B hotkey: disarm automated entry/combat before requesting Lobby.
Runtime.LastBReturnAt=0
function Runtime.BReturnLobby()
    if not Runtime.Alive then return false end
    local now=os.clock()
    if now-(Runtime.LastBReturnAt or 0)<3 then return false end
    if GamePlaceUtil:IsMain() then
        StatusLbl.Text="B: da o Lobby, khong can Teleport."
        return false
    end
    Runtime.LastBReturnAt=now
    Config.AutoFarm=false
    Config.AutoAttackTeleport=false
    Config.AutoStartDungeon=false
    Runtime.ManualEntry=false
    Runtime.SuppressAutoCreate=true
    for _,key in ipairs({"AutoFarm","AutoAttackTeleport","AutoStartDungeon"}) do
        if Runtime.ToggleRefresh[key] then pcall(Runtime.ToggleRefresh[key]) end
    end
    pcall(function() if Runtime.CancelRoute then Runtime.CancelRoute("manual B to lobby") end end)
    pcall(function() if Runtime.CancelFlySkill then Runtime.CancelFlySkill("manual B to lobby") end end)
    pcall(function() if Runtime.NightReleaseDodge then Runtime.NightReleaseDodge("manual B") end end)
    pcall(function() Runtime.BowToken=(Runtime.BowToken or 0)+1 end)
    if Runtime.CloseScepterS5 then pcall(Runtime.CloseScepterS5) end
    if Runtime.CancelLaser then pcall(Runtime.CancelLaser,"manual B Lobby") end
    saveConfig()
    local ok,err=pcall(function()
        local fw=ReplicatedStorage:FindFirstChild("Framework")
        local gp=fw and fw:FindFirstChild("Gameplay")
        local wp=gp and gp:FindFirstChild("WorldPlace")
        local wu=wp and wp:FindFirstChild("WorldUtil")
        local remote=wu and wu:FindFirstChild("RemoteEvent")
        remote=remote or WorldRE
        assert(remote and remote:IsA("RemoteEvent"),"WorldUtil RemoteEvent not found")
        remote:FireServer("TeleportWorld","Lobby")
    end)
    if not ok then
        StatusLbl.Text="B: da tat AutoFarm nhung loi Teleport Lobby: "..tostring(err)
        Runtime.Log("B_LOBBY_ERROR "..tostring(err))
        return false
    end
    StatusLbl.Text="B: AutoFarm OFF, da gui TeleportWorld Lobby."
    Runtime.Log("B_LOBBY_SENT disabled AutoFarm+AutoAttackTeleport; server teleport unverified")
    return true
end

table.insert(Runtime.Connections,UserInputService.InputBegan:Connect(function(input,processed)
    if not Runtime.Alive or processed or UserInputService:GetFocusedTextBox() then return end
    for _,p in ipairs(lobbyPadButtons) do
        if input.KeyCode==p[3] then
            local ok,err=pcall(teleportToPad,p[2])
            if not ok then reportError("Shortcut "..p[3].Name,err) end
            return
        end
    end
    if input.KeyCode==Enum.KeyCode.F6 then Runtime.ClaimAllRewards() end
end))
do
    local CAS=game:GetService("ContextActionService")
    local actionName="IronSoulManualLobbyB_"..tostring(LocalPlayer.UserId)
    local function onB(_,state)
        if state~=Enum.UserInputState.Begin or not Runtime.Alive
            or UserInputService:GetFocusedTextBox() then
            return Enum.ContextActionResult.Pass
        end
        Runtime.BReturnLobby()
        return Enum.ContextActionResult.Sink
    end
    pcall(function()
        CAS:UnbindAction(actionName)
        CAS:BindActionAtPriority(actionName,onB,false,
            Enum.ContextActionPriority.High.Value+300,Enum.KeyCode.B)
    end)
    table.insert(Runtime.Connections,{Disconnect=function()
        pcall(function() CAS:UnbindAction(actionName) end)
    end})
end

-- Optional manual Q/E/R/G hotkeys for horizontal skills. ContextActionService
-- intercepts context-bound game handlers, but cannot suppress native direct
-- UserInputService handlers; watch for duplicate casts on first run.
do
    local CAS=game:GetService("ContextActionService")
    local bindName="IronSoulFlyHorizontal_"..tostring(LocalPlayer.UserId)
    local function intercept(_name,state,input)
        if state~=Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
        if not Runtime.Alive or not Config.FlyHotkeys or not Config.FlyDynamicSkills
            or UserInputService:GetFocusedTextBox() or not combatFarmEnabled()
            or Runtime.Owner or Runtime.RouteBusy or isTransitioning()
            or GamePlaceUtil:IsMain() then return Enum.ContextActionResult.Pass end
        local slot=(input.KeyCode==Enum.KeyCode.Q and "Skill1")
            or (input.KeyCode==Enum.KeyCode.E and "Skill2")
            or (input.KeyCode==Enum.KeyCode.R and "SkillU")
            or (input.KeyCode==Enum.KeyCode.G and "SkillAW")
        if not slot or not Runtime.IsHorizontalSkill(slot) then return Enum.ContextActionResult.Pass end
        local target=Runtime.HoverTarget
        if target and target.Parent then Runtime.RequestFlySkill(slot,target,true) end
        -- Sink even if unsafe: avoid spending the native cooldown while exposed.
        return Enum.ContextActionResult.Sink
    end
    pcall(function()
        CAS:BindActionAtPriority(bindName,intercept,false,Enum.ContextActionPriority.High.Value+100,
            Enum.KeyCode.Q,Enum.KeyCode.E,Enum.KeyCode.R,Enum.KeyCode.G)
    end)
    table.insert(Runtime.Connections,{Disconnect=function() pcall(function() CAS:UnbindAction(bindName) end) end})
end

-- FORGE: two independent workflows, no mandatory mixed-recipe test, preserve receipt/UUID checks.
do
    local function setupCompactForge()
Scroll=Runtime.Tabs.Forge
addSectionHeader("Forge — 1–4 loại ores (KEEP), Auto Sell riêng")
local forgeMode="SELL"
local forgeFilter="Rarity"
local rarityLabels={"Common","Uncommon","Rare","Epic","Legendary"}
local rarityThreshold=5
local keepSelected={} -- oreId -> {Button,Qty,Available}; max 4 ore kinds per KEEP recipe
local keepOreRows={}
local keepMixSummary=nil
local simpleForge={Running=false,Stop=false,Done=0,Total=0}
Runtime.SimpleForge=simpleForge
-- Manual Forge E-interact safety. This pauses automation; it never fabricates a
-- game ProximityPrompt nor sends uncertain server remotes to unlock Forge.
-- v4.9.38: manual E pause / diagnose controls removed; game relog restores E.
-- Forge outcomes are PROBABILISTIC. Ore count changes output probabilities,
-- not a guaranteed subtype. User verified 3 ores has mostly Light Weapon;
-- 4 ores increases Staff chance, while Light/Heavy/Bow/Scepter rates also shift.
-- Only Staff=4 is user-corrected. Other counts remain legacy QUICK-SELECT
-- starting points (UNVERIFIED). Never claim 80% or 100% probabilities.
-- ForgeRF still accepts only the Weapon/Armor category, not a subtype ID.
local ForgeTargets = {
    {Id="Light", Equipment="Weapon", Name="Light", Ores=3},
    {Id="Staff", Equipment="Weapon", Name="Scepter", Ores=4},
    {Id="Heavy", Equipment="Weapon", Name="Heavy", Ores=16},
    {Id="LightHelmet", Equipment="Armor", Name="Light Helmet", Ores=3},
    {Id="LightBreastplate", Equipment="Armor", Name="Light Breastplate", Ores=10},
    {Id="HeavyHelmet", Equipment="Armor", Name="Heavy Helmet", Ores=15},
    {Id="HeavyBreastplate", Equipment="Armor", Name="Heavy Breastplate", Ores=22},
}
-- Saved custom targets are local recipe shortcuts, not guaranteed gear outcomes.
if type(Config.CustomForgeTargets)~="table" then Config.CustomForgeTargets={} end
Config.CustomForgeNextId=math.max(1,math.floor(tonumber(Config.CustomForgeNextId) or 1))
do
    local valid={}
    for _,entry in ipairs(Config.CustomForgeTargets) do
        if #valid>=40 then break end
        if type(entry)=="table" and type(entry.Id)=="string" and entry.Id:match("^USER_%d+$")
            and (entry.Equipment=="Weapon" or entry.Equipment=="Armor")
            and type(entry.Name)=="string" and #entry.Name>0 and #entry.Name<=45
            and type(entry.Ores)=="number" and entry.Ores>=3 and entry.Ores<=99 and entry.Ores%1==0 then
            local safe={Id=entry.Id,Equipment=entry.Equipment,Name=entry.Name,Ores=entry.Ores,Custom=true}
            table.insert(valid,safe)
            table.insert(ForgeTargets,safe)
            local idNum=tonumber(entry.Id:match("^USER_(%d+)$"))
            if idNum then Config.CustomForgeNextId=math.max(Config.CustomForgeNextId,idNum+1) end
        end
    end
    Config.CustomForgeTargets=valid
end
local function forgeTargetText(target)
    return string.format("%d-%s",target.Ores,target.Name)
end
local selectedForgeType=(Config.ForgeTargetType=="Weapon") and "Weapon" or "Armor"
local selectedForgeTarget
for _, t in ipairs(ForgeTargets) do
    if t.Id == Config.ForgeSubtype and t.Equipment == selectedForgeType then selectedForgeTarget=t; break end
end
if not selectedForgeTarget then
    selectedForgeTarget = selectedForgeType == "Weapon" and ForgeTargets[1] or ForgeTargets[4]
end
Config.ForgeTargetType=selectedForgeType
Config.BatchTargetType=selectedForgeType
Config.ForgeSubtype=selectedForgeTarget.Id
local keepQty -- input appears in the Keep panel below
local sellInfo -- short explanation in the Sell panel below
local forgeTypeButton=compactButton(Scroll,"Equipment: "..selectedForgeType:upper().." (bấm để đổi)",function() end)
local forgeTargetButton=compactButton(Scroll,"Target: "..selectedForgeTarget.Name,function() end)
local forgeTargetPopup=Instance.new("ScrollingFrame", ScreenGui)
forgeTargetPopup.BackgroundColor3=Color3.fromRGB(22,22,34)
forgeTargetPopup.BorderColor3=Color3.fromRGB(97,80,139)
forgeTargetPopup.BorderSizePixel=2
forgeTargetPopup.ScrollBarThickness=3
forgeTargetPopup.ZIndex=100
forgeTargetPopup.Visible=false
forgeTargetPopup.Size=UDim2.fromOffset(350,185)
table.insert(activePopups,forgeTargetPopup)
local forgeTargetLayout=Instance.new("UIListLayout",forgeTargetPopup)
forgeTargetLayout.Padding=UDim.new(0,3)
local targetButtons={}
local function refreshTargetUI(populateQty)
    forgeTypeButton.Text="Equipment: "..selectedForgeType:upper().." (bấm để đổi)"
    forgeTargetButton.Text="Target: "..forgeTargetText(selectedForgeTarget)
    Config.ForgeTargetType=selectedForgeType
    Config.BatchTargetType=selectedForgeType
    Config.ForgeSubtype=selectedForgeTarget.Id
    if populateQty and keepQty then keepQty.Text=tostring(selectedForgeTarget.Ores) end
    if sellInfo then
        sellInfo.Text=forgeTargetText(selectedForgeTarget).." | Sell: chỉ UUID vừa rèn"
    end
end
local function updateTargetPopup()
    local count=0
    for _, entry in ipairs(targetButtons) do
        local visible=entry.Target.Equipment==selectedForgeType
        entry.Button.Visible=visible
        if visible then count=count+1 end
    end
    forgeTargetPopup.CanvasSize=UDim2.fromOffset(0,count*35)
    forgeTargetPopup.Size=UDim2.fromOffset(350,math.min(190,count*35+6))
end
local function addForgeTargetOption(target)
    local option=Instance.new("TextButton",forgeTargetPopup)
    option.Size=UDim2.new(1,-8,0,31)
    option.BackgroundColor3=Color3.fromRGB(41,41,61)
    option.TextColor3=Color3.new(1,1,1)
    option.Font=Enum.Font.GothamSemibold
    option.TextSize=11
    option.Text=forgeTargetText(target)
    option.ZIndex=101
    option.LayoutOrder=#targetButtons+1
    table.insert(targetButtons,{Target=target,Button=option})
    option.MouseButton1Click:Connect(function()
        if simpleForge.Running or Runtime.ForgeBusy or Runtime.BatchActive then return end
        selectedForgeTarget=target
        selectedForgeType=target.Equipment
        forgeTargetPopup.Visible=false
        refreshTargetUI(true)
        saveConfig()
        StatusLbl.Text="Forge target: "..target.Name.." / "..target.Ores.." ores"
    end)
end
forgeTargetLayout.SortOrder=Enum.SortOrder.LayoutOrder
for _,target in ipairs(ForgeTargets) do addForgeTargetOption(target) end
forgeTypeButton.MouseButton1Click:Connect(function()
    if simpleForge.Running or Runtime.ForgeBusy or Runtime.BatchActive then
        StatusLbl.Text="Đang Forge; không thể đổi loại trang bị giữa lượt rèn."
        return
    end
    selectedForgeType=(selectedForgeType=="Armor") and "Weapon" or "Armor"
    selectedForgeTarget=selectedForgeType=="Weapon" and ForgeTargets[1] or ForgeTargets[4]
    forgeTargetPopup.Visible=false
    refreshTargetUI(true)
    saveConfig()
end)
forgeTargetButton.MouseButton1Click:Connect(function()
    if simpleForge.Running or Runtime.ForgeBusy or Runtime.BatchActive then return end
    updateTargetPopup()
    local size=ScreenGui.AbsoluteSize
    local pos=forgeTargetButton.AbsolutePosition
    local width=math.min(350,math.max(240,size.X-12))
    forgeTargetPopup.Size=UDim2.fromOffset(width,forgeTargetPopup.Size.Y.Offset)
    forgeTargetPopup.Position=UDim2.fromOffset(
        math.clamp(pos.X,5,math.max(5,size.X-width-5)),
        math.clamp(pos.Y+33,5,math.max(5,size.Y-forgeTargetPopup.Size.Y.Offset-5)))
    forgeTargetPopup.Visible=not forgeTargetPopup.Visible
end)
refreshTargetUI(false)

local customForgeName=compactTextBox(Scroll,"Tên loại đồ","Staff")
local customForgeCount=compactTextBox(Scroll,"Số ores / món",4)
compactButton(Scroll,"+ ADD RECIPE TO TARGET DROPDOWN",function()
    assert(not simpleForge.Running and not Runtime.ForgeBusy and not Runtime.BatchActive,
        "Đang rèn; không thể sửa công thức")
    local name=tostring(customForgeName.Text or ""):gsub("[%c]",""):match("^%s*(.-)%s*$")
    local qty=tonumber(customForgeCount.Text)
    assert(#name>=1 and #name<=40,"Tên công thức phải có 1..40 ký tự")
    assert(qty and qty%1==0 and qty>=3 and qty<=99,"Số ores phải nguyên 3..99; server có thể từ chối số không hỗ trợ")
    assert(#Config.CustomForgeTargets<40,"Giới hạn 40 công thức tự tạo")
    local id="USER_"..tostring(Config.CustomForgeNextId)
    Config.CustomForgeNextId=Config.CustomForgeNextId+1
    local entry={Id=id,Name=name,Ores=qty,Equipment=selectedForgeType,Custom=true}
    table.insert(Config.CustomForgeTargets,entry)
    table.insert(ForgeTargets,entry)
    addForgeTargetOption(entry)
    selectedForgeTarget=entry
    forgeTargetPopup.Visible=false
    refreshTargetUI(true)
    updateTargetPopup()
    saveConfig()
    Runtime.Log("FORGE_CUSTOM_ADD "..selectedForgeType.." "..name.." ores="..qty)
    StatusLbl.Text="Đã thêm Recipe "..forgeTargetText(entry)
end,Color3.fromRGB(55,112,82))
compactButton(Scroll,"DELETE SELECTED CUSTOM RECIPE",function()
    assert(not simpleForge.Running and not Runtime.ForgeBusy and not Runtime.BatchActive,
        "Đang rèn; không thể xóa công thức")
    assert(selectedForgeTarget and selectedForgeTarget.Custom,"Chỉ xóa preset tự tạo; preset gốc được giữ")
    local deleting=selectedForgeTarget
    for i=#Config.CustomForgeTargets,1,-1 do
        if Config.CustomForgeTargets[i].Id==deleting.Id then
            table.remove(Config.CustomForgeTargets,i)
        end
    end
    for i=#ForgeTargets,1,-1 do
        if ForgeTargets[i].Id==deleting.Id then table.remove(ForgeTargets,i) end
    end
    for i=#targetButtons,1,-1 do
        if targetButtons[i].Target.Id==deleting.Id then
            targetButtons[i].Button:Destroy()
            table.remove(targetButtons,i)
        end
    end
    selectedForgeTarget=selectedForgeType=="Weapon" and ForgeTargets[1] or ForgeTargets[4]
    forgeTargetPopup.Visible=false
    refreshTargetUI(true)
    updateTargetPopup()
    saveConfig()
    Runtime.Log("FORGE_CUSTOM_DELETE "..deleting.Id)
    StatusLbl.Text="Đã xóa Recipe "..forgeTargetText(deleting)
end,Color3.fromRGB(120,65,66))
local modeButton=compactButton(Scroll,"Mode: AUTO FORGE & SELL",function() end)
local sellPanel=Instance.new("Frame",Scroll)
orderWidget(sellPanel)
sellPanel.Size=UDim2.new(.94,0,0,154)
sellPanel.BackgroundColor3=Color3.fromRGB(28,28,42)
local modeFilter=Instance.new("TextButton",sellPanel)
modeFilter.Size=UDim2.new(.96,0,0,31)
modeFilter.Position=UDim2.new(.02,0,0,4)
modeFilter.BackgroundColor3=Color3.fromRGB(49,83,125)
modeFilter.TextColor3=Color3.new(1,1,1)
modeFilter.TextSize=12
local rarityButton=Instance.new("TextButton",sellPanel)
rarityButton.Size=UDim2.new(.96,0,0,33)
rarityButton.Position=UDim2.new(.02,0,0,40)
rarityButton.BackgroundColor3=Color3.fromRGB(49,83,125)
rarityButton.TextColor3=Color3.new(1,1,1)
rarityButton.TextSize=12
local levelEntry=Instance.new("TextBox",sellPanel)
levelEntry.Position=UDim2.new(.02,0,0,40)
levelEntry.Size=UDim2.new(.96,0,0,33)
levelEntry.BackgroundColor3=Color3.fromRGB(49,49,70)
levelEntry.TextColor3=Color3.new(1,1,1)
levelEntry.TextSize=13
levelEntry.PlaceholderText="Forge Level <= ..."
levelEntry.ClearTextOnFocus=false
levelEntry.Text="90"
sellInfo=Instance.new("TextLabel",sellPanel)
sellInfo.Size=UDim2.new(.96,0,0,65)
sellInfo.Position=UDim2.new(.02,0,0,80)
sellInfo.BackgroundTransparency=1
sellInfo.TextColor3=Color3.fromRGB(213,218,233)
sellInfo.TextSize=11
sellInfo.TextWrapped=true
refreshTargetUI(false)
local function refreshForgeFilter()
    modeFilter.Text="Filter: "..forgeFilter.." (bấm để đổi)"
    rarityButton.Visible=forgeFilter=="Rarity"
    levelEntry.Visible=forgeFilter=="Level"
    rarityButton.Text="Rarity <= "..rarityLabels[rarityThreshold]
end
modeFilter.MouseButton1Click:Connect(function()
    if simpleForge.Running then return end
    forgeFilter=(forgeFilter=="Rarity") and "Level" or "Rarity"
    if rarityPopup then rarityPopup.Visible=false end
    refreshForgeFilter()
end)
local rarityPopup=Instance.new("ScrollingFrame",ScreenGui)
rarityPopup.Size=UDim2.fromOffset(250,173)
rarityPopup.BackgroundColor3=Color3.fromRGB(22,22,34)
rarityPopup.BorderColor3=Color3.fromRGB(97,80,139)
rarityPopup.BorderSizePixel=2
rarityPopup.ScrollBarThickness=3
rarityPopup.CanvasSize=UDim2.fromOffset(0,#rarityLabels*33)
rarityPopup.ZIndex=100
rarityPopup.Visible=false
table.insert(activePopups,rarityPopup)
local rarityLayout=Instance.new("UIListLayout",rarityPopup)
rarityLayout.Padding=UDim.new(0,2)
for i,label in ipairs(rarityLabels) do
    local option=Instance.new("TextButton",rarityPopup)
    option.Size=UDim2.new(1,-8,0,29)
    option.Text=label.." trở xuống"
    option.TextSize=12
    option.TextColor3=Color3.new(1,1,1)
    option.BackgroundColor3=Color3.fromRGB(41,41,61)
    option.ZIndex=101
    option.MouseButton1Click:Connect(function()
        rarityThreshold=i
        rarityPopup.Visible=false
        refreshForgeFilter()
    end)
end
rarityButton.MouseButton1Click:Connect(function()
    if simpleForge.Running then return end
    local size=ScreenGui.AbsoluteSize
    local pos=rarityButton.AbsolutePosition
    rarityPopup.Position=UDim2.fromOffset(math.clamp(pos.X,5,math.max(5,size.X-255)),math.clamp(pos.Y+31,5,math.max(5,size.Y-176)))
    rarityPopup.Visible=not rarityPopup.Visible
end)
refreshForgeFilter()

local keepPanel=Instance.new("Frame",Scroll)
orderWidget(keepPanel)
keepPanel.Size=UDim2.new(.94,0,0,312)
keepPanel.BackgroundColor3=Color3.fromRGB(28,28,42)
local scanButton=Instance.new("TextButton",keepPanel)
scanButton.Size=UDim2.new(.96,0,0,31)
scanButton.Position=UDim2.new(.02,0,0,3)
scanButton.BackgroundColor3=Color3.fromRGB(49,83,125)
scanButton.TextColor3=Color3.new(1,1,1)
scanButton.Text="QUÉT TÚI ĐỒ (làm mới)"
scanButton.TextSize=12
local keepList=Instance.new("ScrollingFrame",keepPanel)
keepList.Position=UDim2.new(.02,0,0,39)
keepList.Size=UDim2.new(.96,0,0,151)
keepList.BackgroundColor3=Color3.fromRGB(37,37,52)
keepList.CanvasSize=UDim2.new()
keepList.AutomaticCanvasSize=Enum.AutomaticSize.Y
keepList.ScrollBarThickness=4
local keepListLayout=Instance.new("UIListLayout",keepList)
keepListLayout.Padding=UDim.new(0,2)
local keepQtyLabel=Instance.new("TextLabel",keepPanel)
keepMixSummary=Instance.new("TextLabel",keepPanel)
keepMixSummary.Position=UDim2.new(.02,0,0,193)
keepMixSummary.Size=UDim2.new(.96,0,0,43)
keepMixSummary.BackgroundTransparency=1
keepMixSummary.TextColor3=Color3.fromRGB(210,234,255)
keepMixSummary.TextWrapped=true
keepMixSummary.TextXAlignment=Enum.TextXAlignment.Left
keepMixSummary.TextSize=11
keepMixSummary.Text="SCAN BAG -> bấm chọn tối đa 4 loại ore -> nhập số viên ở ô bên phải."
keepQtyLabel.Position=UDim2.new(.02,0,0,241)
keepQtyLabel.Size=UDim2.new(.42,0,0,24)
keepQtyLabel.Text="Tổng ores/món (Target)"
keepQtyLabel.TextColor3=Color3.new(1,1,1)
keepQtyLabel.BackgroundTransparency=1
keepQtyLabel.TextSize=11
keepQty=Instance.new("TextBox",keepPanel)
keepQty.Position=UDim2.new(.48,0,0,241)
keepQty.Size=UDim2.new(.5,0,0,24)
keepQty.Text=tostring(selectedForgeTarget.Ores)
keepQty.PlaceholderText="Theo Target: "..selectedForgeTarget.Ores
keepQty.ClearTextOnFocus=false
keepQty.BackgroundColor3=Color3.fromRGB(47,46,65)
keepQty.TextColor3=Color3.new(1,1,1)
local keepCountLabel=Instance.new("TextLabel",keepPanel)
keepCountLabel.Position=UDim2.new(.02,0,0,277)
keepCountLabel.Size=UDim2.new(.42,0,0,24)
keepCountLabel.Text="Số món cần rèn"
keepCountLabel.TextColor3=Color3.new(1,1,1)
keepCountLabel.BackgroundTransparency=1
keepCountLabel.TextSize=11
local keepCount=Instance.new("TextBox",keepPanel)
keepCount.Position=UDim2.new(.48,0,0,277)
keepCount.Size=UDim2.new(.5,0,0,24)
keepCount.Text=""
keepCount.PlaceholderText="Ví dụ: 5"
keepCount.ClearTextOnFocus=false
keepCount.BackgroundColor3=Color3.fromRGB(47,46,65)
keepCount.TextColor3=Color3.new(1,1,1)
local function refreshKeepMixSummary()
    local count,sum,detail=0,0,{}
    for id,rec in pairs(keepSelected) do
        count=count+1
        local q=tonumber(rec.Qty.Text) or 0
        if q>0 then sum=sum+q end
        detail[#detail+1]=tostring(id).." x"..tostring(q)
        rec.Button.BackgroundColor3=Color3.fromRGB(42,120,76)
        rec.Button.Text="[CHỌN] "..rec.Name.." | Có "..tostring(rec.Available)
    end
    table.sort(detail)
    local target=tonumber(keepQty.Text) or selectedForgeTarget.Ores
    if keepMixSummary then
        keepMixSummary.Text=string.format("Đã chọn %d/4 loại | Tổng %g / %g ores/món\n%s",
            count,sum,target,#detail>0 and table.concat(detail," + ") or "Chưa chọn ores: bấm các dòng trong danh sách")
        keepMixSummary.TextColor3=(count>=1 and count<=4 and sum==target)
            and Color3.fromRGB(135,239,174) or Color3.fromRGB(247,204,122)
    end
end
local function scanKeepOres()
    assert(not simpleForge.Running and not Runtime.ForgeBusy,"Đang Forge")
    local ores=DataUtil:GetValue(LocalPlayer,{"Ores"})
    assert(type(ores)=="table","Không đọc được túi nguyên liệu")
    for _,child in ipairs(keepList:GetChildren()) do if child~=keepListLayout then child:Destroy() end end
    keepOreRows={}
    keepSelected={}
    keepQty.Text=tostring(selectedForgeTarget.Ores)
    keepCount.Text=""
    local ids={}
    for id,count in pairs(ores) do if type(count)=="number" and count>0 then ids[#ids+1]=id end end
    table.sort(ids,function(a,b) return tostring(a)<tostring(b) end)
    for i,id in ipairs(ids) do
        local count=ores[id]
        local row=Instance.new("Frame",keepList)
        row.LayoutOrder=i
        row.Size=UDim2.new(1,-8,0,34)
        row.BackgroundTransparency=1
        local btn=Instance.new("TextButton",row)
        btn.Position=UDim2.new(0,0,0,0)
        btn.Size=UDim2.new(.77,-4,1,0)
        btn.BackgroundColor3=Color3.fromRGB(47,47,68)
        btn.TextColor3=Color3.new(1,1,1)
        btn.TextSize=11
        btn.TextXAlignment=Enum.TextXAlignment.Left
        local name=tostring(id)
        pcall(function()
            local translated=Framework.Modules.TranslationUtil:TranslateByKey("K_"..tostring(id):upper())
            if translated and translated~="" then name=tostring(translated) end
        end)
        btn.Text="[    ] "..name.." | Có "..tostring(count)
        local qty=Instance.new("TextBox",row)
        qty.Position=UDim2.new(.78,0,0,0)
        qty.Size=UDim2.new(.22,0,1,0)
        qty.Text="0"
        qty.PlaceholderText="Số viên"
        qty.ClearTextOnFocus=false
        qty.TextColor3=Color3.new(1,1,1)
        qty.TextSize=12
        qty.BackgroundColor3=Color3.fromRGB(58,58,78)
        keepOreRows[id]={Button=btn,Qty=qty,Available=count,Name=name}
        btn.MouseButton1Click:Connect(function()
            local selected=keepSelected[id]
            if selected then
                keepSelected[id]=nil
                qty.Text="0"
                btn.Text="[    ] "..name.." | Có "..tostring(count)
                btn.BackgroundColor3=Color3.fromRGB(47,47,68)
            else
                local n=0
                for _ in pairs(keepSelected) do n=n+1 end
                if n>=4 then
                    StatusLbl.Text="Forge & Keep: tối đa 4 LOẠI ores/món. Bỏ chọn 1 loại trước."
                    return
                end
                keepSelected[id]=keepOreRows[id]
                -- One ore defaults to full target; additional ores get 1 each.
                -- Borrow one from any existing ore with >1 to keep the sum useful.
                local amount=(n==0) and selectedForgeTarget.Ores or 1
                if n>0 then
                    for _,old in pairs(keepSelected) do
                        if old~=keepOreRows[id] and (tonumber(old.Qty.Text) or 0)>1 then
                            old.Qty.Text=tostring(tonumber(old.Qty.Text)-1)
                            break
                        end
                    end
                end
                qty.Text=tostring(amount)
            end
            refreshKeepMixSummary()
        end)
        qty.FocusLost:Connect(function()
            local value=tonumber(qty.Text)
            if value and value>=1 and value%1==0 and not keepSelected[id] then
                local n=0
                for _ in pairs(keepSelected) do n=n+1 end
                if n<4 then
                    keepSelected[id]=keepOreRows[id]
                else
                    qty.Text="0"
                    StatusLbl.Text="Forge & Keep: tối đa 4 loại ores"
                end
            elseif keepSelected[id] and (not value or value<=0) then
                keepSelected[id]=nil
                qty.Text="0"
                btn.BackgroundColor3=Color3.fromRGB(47,47,68)
                btn.Text="[    ] "..name.." | Có "..tostring(count)
            end
            refreshKeepMixSummary()
        end)
    end
    refreshKeepMixSummary()
    StatusLbl.Text="Đã quét "..#ids.." loại ores. Chọn 1–4 loại; điền số viên từng loại, tổng đúng Target."
end
scanButton.MouseButton1Click:Connect(function()
    local ok,err=pcall(scanKeepOres)
    if not ok then reportError("Scan ores",err) end
end)
local forgeProgress=compactLabel(Scroll,"Ready",30)
local forgeStart=compactButton(Scroll,"START FORGE & SELL",function() end,Color3.fromRGB(42,134,80))
local forgeStop=compactButton(Scroll,"STOP AFTER CURRENT ITEM",function() simpleForge.Stop=true end,Color3.fromRGB(151,57,64))
forgeStop.Visible=false
local function refreshForgePanel()
    modeButton.Text="Mode: AUTO FORGE & "..forgeMode.." (bấm đổi)"
    sellPanel.Visible=forgeMode=="SELL"
    keepPanel.Visible=forgeMode=="KEEP"
    forgeStart.Visible=not simpleForge.Running
    forgeStop.Visible=simpleForge.Running
    forgeStart.Text="START FORGE & "..forgeMode
end
modeButton.MouseButton1Click:Connect(function()
    if simpleForge.Running then return end
    forgeMode=(forgeMode=="SELL") and "KEEP" or "SELL"
    refreshForgePanel()
end)
local function getSimpleSellRecipe()
    local ores=DataUtil:GetValue(LocalPlayer,{"Ores"})
    assert(type(ores)=="table","Không đọc được túi nguyên liệu")
    local choices={}
    local limit=tonumber(levelEntry.Text)
    if forgeFilter=="Level" then
        assert(limit and limit>=0 and limit%1==0,"Level tối đa phải là số nguyên >= 0")
    end
    for id,count in pairs(ores) do
        if type(count)=="number" and count>=1 then
            local def=ForgeUtil:GetDef(id)
            if def then
                local r=tonumber(def.Rarity)
                local lv=(forgeFilter=="Level") and getOreLevel(id,def) or nil
                local allowed=(forgeFilter=="Rarity" and r~=nil and r<=rarityThreshold)
                    or (forgeFilter=="Level" and lv~=nil and lv<=limit)
                if allowed then choices[#choices+1]={Id=id,Count=count,Rarity=r or 999,Level=lv or 999} end
            end
        end
    end
    table.sort(choices,function(a,b)
        if forgeFilter=="Rarity" and a.Rarity~=b.Rarity then return a.Rarity<b.Rarity end
        if forgeFilter=="Level" and a.Level~=b.Level then return a.Level<b.Level end
        return tostring(a.Id)<tostring(b.Id)
    end)
    local recipe,need={},selectedForgeTarget.Ores
    for _,ore in ipairs(choices) do
        local take=math.min(need,math.floor(ore.Count))
        if take>0 then recipe[ore.Id]=take;need=need-take end
        if need==0 then break end
    end
    return need==0 and recipe or nil
end
local function runSimpleForge(mode,recipe,requested)
    simpleForge.Running,simpleForge.Stop,simpleForge.Done,simpleForge.Total=true,false,0,requested or 0
    Runtime.Log(string.format("FORGE_TARGET mode=%s type=%s label=%s ores=%d chance=%s (server decides subtype)",
        mode,selectedForgeType,selectedForgeTarget.Id,selectedForgeTarget.Ores,
        selectedForgeTarget.Chance and tostring(selectedForgeTarget.Chance).."%" or "UNKNOWN"))
    Runtime.BatchActive=true
    refreshForgePanel()
    task.spawn(function()
        local ok,err=pcall(function()
            while Runtime.Alive and not simpleForge.Stop do
                assert(GamePlaceUtil:IsMain() and not isTransitioning() and lobbyCharacterReady(),"Phải ở Lobby")
                if mode=="KEEP" and simpleForge.Done>=requested then break end
                local currentRecipe=mode=="SELL" and getSimpleSellRecipe() or recipe
                if not currentRecipe then break end
                if mode=="KEEP" then
                    local ores=DataUtil:GetValue(LocalPlayer,{"Ores"}) or {}
                    local enough=true
                    for oreId,qty in pairs(recipe) do if (ores[oreId] or 0)<qty then enough=false;break end end
                    if not enough then break end
                end
                Runtime.ForgeBusy=true
                local uuid=forgeRecipe(currentRecipe,selectedForgeType,true,mode)
                if mode=="SELL" then Runtime.SellForgeOutput(uuid) end
                Runtime.ForgeBusy=false
                simpleForge.Done=simpleForge.Done+1
                forgeProgress.Text=(mode=="KEEP") and (simpleForge.Done.."/"..requested) or ("Rèn & bán: "..simpleForge.Done.." món")
                task.wait(.3)
            end
        end)
        Runtime.ForgeBusy=false
        Runtime.BatchActive=false
        simpleForge.Running=false
        if not ok then
            if Runtime.ProtectPendingForge then Runtime.ProtectPendingForge() end
            forgeProgress.Text="Forge lỗi: "..tostring(err):sub(1,100)
            reportError("Compact Forge",err)
        else
            forgeProgress.Text=(mode=="KEEP" and simpleForge.Done==requested) and ("DONE "..simpleForge.Done.."/"..requested)
                or (mode=="KEEP" and "STOP " or "DONE | Đã bán ")..tostring(simpleForge.Done).." món"
        end
        refreshForgePanel()
    end)
end
local function startCompactForge()
    assert(not simpleForge.Running and not Runtime.ForgeBusy and not Runtime.EntryBusy and not isLobbyBusy and not Runtime.Owner,
        "Đang có tác vụ khác")
    assert(GamePlaceUtil:IsMain() and lobbyCharacterReady() and not isTransitioning(),"Chỉ Forge ở Lobby")
    assert(not Config.AutoFarm,"Tắt Auto Farm trước khi Forge để tránh tự tạo Dungeon")
    assert(not Runtime.ForgeUncertain,"Forge trước chưa rõ kết quả; kiểm tra túi trước khi chạy")
    if forgeMode=="SELL" then
        local recipe=getSimpleSellRecipe()
        assert(recipe,"Không có đủ "..selectedForgeTarget.Ores.." nguyên liệu thỏa bộ lọc để rèn "..selectedForgeTarget.Name)
        runSimpleForge("SELL",nil,nil)
    else
        local target=tonumber(keepQty.Text)
        local count=tonumber(keepCount.Text)
        assert(target and target%1==0 and target==selectedForgeTarget.Ores,
            "Target "..selectedForgeTarget.Name.." cần tổng đúng "..selectedForgeTarget.Ores.." ores/món")
        assert(count and count>=1 and count<=1000 and count%1==0,"Số món phải là số nguyên 1..1000")
        local owned=DataUtil:GetValue(LocalPlayer,{"Ores"}) or {}
        local recipe,types,total={},{},0
        local kinds=0
        for id,rec in pairs(keepSelected) do
            kinds=kinds+1
            local n=tonumber(rec.Qty.Text)
            assert(n and n>=1 and n%1==0,"Số ores của "..tostring(id).." phải là số nguyên >0")
            recipe[id]=n
            total=total+n
            local available=tonumber(owned[id]) or 0
            assert(available>=n*count,string.format("Không đủ %s: cần %d viên cho %d món, túi có %d",
                tostring(id),n*count,count,available))
        end
        assert(kinds>=1 and kinds<=4,"Hãy quét túi và chọn từ 1 đến 4 loại ores")
        assert(total==target,"Công thức chưa đủ: tổng "..total.." ores/món, Target cần "..target)
        runSimpleForge("KEEP",recipe,count)
    end
end
-- Replace the placeholder callback with a single actual action; no double-press preview.
forgeStart.MouseButton1Click:Connect(function()
    local ok,err=pcall(startCompactForge)
    if not ok then reportError("Start Forge",err) end
end)
refreshForgePanel()

-- === v4.9.25 OWNED-GEAR DPS SCANNER: manual Pet/Scroll/Total ===
-- READ ONLY. This module never invokes ForgeRF, Equip, Sell, or any other mutation.
-- The rest of AIO retains its independent forge/cleanup toggles if enabled.
-- Attribute totals from AttrEntryUtil already include equipped source bonuses;
-- Scroll and Pet are scanned for provenance, NOT blindly added a second time.
do
    local dpsWidgetsStart=uiOrder
    Scroll=Runtime.Tabs.Forge
    addSectionHeader("DPS OWNED-GEAR SCANNER — PET + SCROLL + W/H/A")
    local dpsStatus=compactLabel(Scroll,"DPS: SCAN 3 món đang sở hữu. Không rèn, bán hay tự đổi đồ.",70)
    local dpsDetail=compactLabel(Scroll,"Chưa quét. Best 3-piece build sẽ hiện tại đây.",92)
    compactLabel(Scroll,"Nhập tay (nếu scan sai): ATK%, Skill%, CritRate%, CritDmg%, FlatATK. Ví dụ: 20,15,40,80,0. Để TRỐNG = auto.",67)
    local manualPetInput=compactTextBox(Scroll,"PET FOLLOW: A,S,P,C,Flat",tostring(Config.DPSManualPet or ""))
    local manualScrollInput=compactTextBox(Scroll,"ACTIVE SCROLL: A,S,P,C,Flat",tostring(Config.DPSManualScroll or ""))
    local manualTotalsInput=compactTextBox(Scroll,"TOTAL STATS: A,S,P,C",tostring(Config.DPSManualTotals or ""))
    local manualBaseInput=compactTextBox(Scroll,"BASE ATK (0=auto)","0")
    addToggle("DPS ALL WEAPON CLASSES (FORMULA-ONLY)","DPSCompareAllClasses")
    local dpsJob={Running=false,Stop=false,Count=0}
    Runtime.DPSForge=dpsJob
    local RateKeys={
        AttackBonus={"AttackBonus","ATKBonus","AtkBonus","AttackBuff","ATKBuff","AttackRate","ATKRate","AttackPercent","ATKAdd","AtkAdd","AtkAddRate","AttackAddRate","AtkUp","AttackIncrease"},
        SkillDamage={"SkillDamage","SkillDMG","SkillDamageBonus","SkillDamageUp","SkillDMGUp","SkillDmgRate","SkillDmgAdd","SkillDamageAdd","SkillDamageRate"},
        CritRate={"CritRate","CriticalRate","CritChance","CriticalChance","CriticalRateBonus","CritRateAdd","CritChanceAdd"},
        CritDamage={"CritDamage","CriticalDamage","CritDMG","CritDmgBonus","CriticalDamageBonus","CritDamageAdd","CritDmgAdd"},
    }
    local BaseKeys={"BaseATK","BaseAtk","BaseAttack","AttackValue","AttackPower","ATKValue","ATK","Atk"}
    local function norm(s) return tostring(s):lower():gsub("[^%w]","") end
    local function mapStat(s)
        local k=norm(s)
        for stat,aliases in pairs(RateKeys) do
            for _,alias in ipairs(aliases) do if norm(alias)==k then return stat end end
        end
        if (k:find("critdamage",1,true) or k:find("critdmg",1,true)
            or k:find("criticaldamage",1,true)) and not k:find("resist",1,true) then
            return "CritDamage"
        end
        if (k:find("critrate",1,true) or k:find("critchance",1,true)
            or k:find("criticalrate",1,true) or k:find("criticalchance",1,true))
            and not k:find("resist",1,true) then return "CritRate" end
        if k:find("skilldamage",1,true) or k:find("skilldmg",1,true) then
            if not k:find("taken",1,true) and not k:find("resist",1,true) then return "SkillDamage" end
        end
        if ((k:find("attack",1,true) or k:find("atk",1,true))
            and (k:find("bonus",1,true) or k:find("buff",1,true)
                or k:find("percent",1,true) or k:find("rate",1,true)
                or k:find("increase",1,true))) and not k:find("speed",1,true)
                and not k:find("cooldown",1,true) then return "AttackBonus" end
        if k=="attack" or k=="atkflat" or k=="flatatk" or k=="attributeatk"
            or k=="attackflat" or k=="attributepointattack" then return "FlatATK" end
        return nil
    end
    local function asRate(n)
        n=tonumber(n)
        if not n or n~=n or math.abs(n)>100000 then return nil end
        -- ScrollUtil:GetScrollAttrs explicitly divides its raw Attrs by 100.
        -- AttrEntryUtil, unlike owned Attrs, is expected to be in ratio units.
        return n
    end
    -- EquipmentData:GetOwned may contain flattened dict Attrs or lists of
    -- {Type/Attr/Key, Value} objects, sometimes wrapped in another table.
    -- Decode only recognizable scalar attributes; never treat missing fields
    -- as confirmed zero or transform Rune effects into ATTACK.
    local function readNumber(raw)
        if type(raw)=="number" then return raw end
        if type(raw)=="string" then return tonumber(raw:gsub("%%", "")) end
        if type(raw)=="table" then
            for _,field in ipairs({"Value","Val","Amount","Num","V","Percent","Rate","AddValue"}) do
                local n=readNumber(raw[field]); if n~=nil then return n end
            end
            if type(raw[1])=="string" then return readNumber(raw[2]) end
        end
        return nil
    end
    local function decodeAttrs(raw)
        local result={AttackBonus=0,SkillDamage=0,CritRate=0,CritDamage=0,FlatATK=0}
        local detected={}
        local hits,shape=0,false
        local visited={}
        local function save(stat,value)
            local n=readNumber(value)
            if not n or n~=n or math.abs(n)>100000 then return end
            result[stat]=result[stat]+(stat=="FlatATK" and n or n/100)
            hits=hits+1; detected[stat]=true
        end
        local function walk(node,depth)
            if type(node)~="table" or visited[node] or depth>4 then return end
            visited[node]=true
            local statType
            for _,key in ipairs({"AttrType","AttributeType","AttrName","Attr","Stat","StatType","Key","Type","Name","ID","Id","EntryType"}) do
                if type(node[key])=="string" then
                    local st=mapStat(node[key]); if st then statType=st;break end
                end
            end
            if statType then
                for _,key in ipairs({"Value","Val","Amount","Num","V","Percent","Rate","AddValue"}) do
                    if node[key]~=nil then
                        save(statType,node[key]);return
                    end
                end
                if type(node[1])=="string" and node[2]~=nil then save(statType,node[2]);return end
            end
            if type(node[1])=="string" and type(node[2])~="nil" then
                local st=mapStat(node[1])
                if st then save(st,node[2]);return end
            end
            for key,value in pairs(node) do
                local stat=type(key)=="string" and mapStat(key) or nil
                if stat then
                    save(stat,value)
                elseif type(value)=="table" then
                    walk(value,depth+1)
                elseif type(value)=="number" and type(key)=="number" then
                    -- Unknown numeric enum. Mark as not decoded, never invent.
                end
            end
            if hits>0 then shape=true end
        end
        walk(raw,0)
        return result,hits>0,detected,shape
    end
    -- Search common sources in order, choosing ONE best decoding instead of
    -- summing duplicated owned/info values.
    local function rawItemAttrs(item,info)
        local sources={}
        local function add(label,tab)
            if type(tab)=="table" then sources[#sources+1]={label,tab} end
        end
        for _,pair in ipairs({{"owned",item},{"info",info},{"def",type(info)=="table" and info.Def}}) do
            local label,node=pair[1],pair[2]
            if type(node)=="table" then
                for _,key in ipairs({"Attrs","Attributes","Stats","Stat","BonusAttrs","RandomAttrs","ExtraAttrs","AttributeList","AttrList","Props","Properties","AddAttrs","AttrEntries","Entries","Affixes","Attr","Bonuses"}) do
                    add(label.."."..key,node[key])
                end
            end
        end
        -- Last-resort direct field lookup (an item can expose AttackBonus at top level).
        add("owned",item);add("info",info)
        local best,bestHits,bestLabel,bestSeen=nil,-1,nil,nil
        for _,source in ipairs(sources) do
            local vals,valid,seen=decodeAttrs(source[2])
            local count=0;for _ in pairs(seen) do count=count+1 end
            if valid and (count>bestHits) then
                best,bestHits,bestLabel,bestSeen=vals,count,source[1],seen
            end
            -- Top-level source preference wins ties; owned Attrs precedes info.
        end
        if best then return best,true,bestLabel,bestSeen end
        return {AttackBonus=0,SkillDamage=0,CritRate=0,CritDamage=0,FlatATK=0},false,"NO_RECOGNIZED_ATTRS",{}
    end
    local function authoritativeAttr(stat)
        local mod=Framework.Modules.AttrEntryUtil
        if not mod or type(mod.GetAttrEntry)~="function" then return nil,nil end
        local candidates={}
        local aliases=RateKeys[stat] or BaseKeys
        local enum=GameEnum and GameEnum.AttrEntry
        if type(enum)=="table" then
            for key,val in pairs(enum) do
                if type(key)=="string" and type(val)=="string" then
                    for _,alias in ipairs(aliases) do
                        if norm(alias)==norm(key) or norm(alias)==norm(val) then
                            candidates[#candidates+1]=val
                            break
                        end
                    end
                end
            end
        end
        for _,alias in ipairs(aliases) do candidates[#candidates+1]=alias end
        local selected={}
        for _,key in ipairs(candidates) do
            if not selected[key] then
                selected[key]=true
                local ok,n=pcall(function() return mod:GetAttrEntry(LocalPlayer,key) end)
                if ok and type(n)=="number" and n==n and math.abs(n)<10000000 then
                    -- Prefer a nonzero result. Zero is a valid bonus but may also
                    -- mean the requested key did not exist in this game build.
                    if n~=0 then return n,key end
                end
            end
        end
        -- Zero is useful only after all known aliases were exhausted.
        for _,key in ipairs(candidates) do
            local ok,n=pcall(function() return mod:GetAttrEntry(LocalPlayer,key) end)
            if ok and type(n)=="number" and n==0 then return 0,key end
        end
        return nil,nil
    end
    -- Manual percentages are entered in HUMAN units: 25 means +25%, not +2500%.
    -- Leave boxes completely empty for AUTO. Explicit 0,0,0,0 is a valid override.
    local function parseManual(box,name,withFlat)
        local str=tostring(box.Text or ""):gsub("^%s+",""):gsub("%s+$","")
        if str=="" then return nil end
        local vals={}
        str=str:gsub("[;|]",",")
        for part in (str..","):gmatch("([^,]*),") do
            local clean=part:gsub("%%",""):gsub("%s","")
            if clean=="" then error(name..": nhập đủ ATK,Skill,CritRate,CritDmg (và FlatATK tùy chọn)") end
            local n=tonumber(clean)
            assert(n and n==n and math.abs(n)<=100000,name..": số không hợp lệ "..tostring(part))
            vals[#vals+1]=n
        end
        assert(#vals==4 or (withFlat and #vals==5),name..": cần 4 hoặc 5 số cách nhau bởi dấu phẩy")
        return {AttackBonus=vals[1]/100,SkillDamage=vals[2]/100,
            CritRate=vals[3]/100,CritDamage=vals[4]/100,FlatATK=vals[5] or 0,
            Input=str,Source="MANUAL"}
    end
    local function manualInputs()
        local pet=parseManual(manualPetInput,"PET",true)
        local scroll=parseManual(manualScrollInput,"SCROLL",true)
        local totals=parseManual(manualTotalsInput,"TOTAL",false)
        Config.DPSManualPet=pet and pet.Input or ""
        Config.DPSManualScroll=scroll and scroll.Input or ""
        Config.DPSManualTotals=totals and totals.Input or ""
        saveConfig()
        return pet,scroll,totals
    end
    local function readTotalRates(manualTotal)
        local totals,found,missing={}, {}, {}
        for _,kind in ipairs({"AttackBonus","SkillDamage","CritRate","CritDamage"}) do
            local v,key=authoritativeAttr(kind)
            if v==nil then missing[#missing+1]=kind; totals[kind]=0
            else
                -- AttrEntryUtil returns calculated entry units; do not blindly
                -- divide high legitimate buffs (e.g. +600%) by 100.
                totals[kind]=v
                found[kind]={Key=key,Raw=v}
            end
        end
        if manualTotal then
            totals={AttackBonus=manualTotal.AttackBonus,SkillDamage=manualTotal.SkillDamage,
                CritRate=manualTotal.CritRate,CritDamage=manualTotal.CritDamage}
            missing={}
            for _,key in ipairs({"AttackBonus","SkillDamage","CritRate","CritDamage"}) do
                found[key]={Key="MANUAL TOTAL %",Raw=totals[key]}
            end
        end
        local base,baseKey=authoritativeAttr("BaseATK")
        if not base or base<=0 then
            for _,holder in ipairs({LocalPlayer,LocalPlayer.Character}) do
                if holder then
                    for _,k in ipairs(BaseKeys) do
                        local v=holder:GetAttribute(k)
                        if type(v)=="number" and v>5 then base,baseKey=v,"Attribute:"..k;break end
                    end
                end
                if base and base>0 then break end
            end
        end
        local manual=tonumber(manualBaseInput.Text)
        if manual and manual>0 then base,baseKey=manual,"MANUAL" end
        if base and base<=5 and baseKey~="MANUAL" then base=nil;baseKey=nil end
        return totals,found,missing,base,baseKey
    end
    local function getCurrentScroll(class)
        local su=Framework.Modules.ScrollUtil
        if not su or not class then return nil end
        local ok,data=pcall(function() return su:GetEquippedScroll(LocalPlayer,class) end)
        if not ok or type(data)~="table" then return nil end
        local def
        pcall(function() def=su:GetDef(data.Id) end)
        local attrs={AttackBonus=0,SkillDamage=0,CritRate=0,CritDamage=0,FlatATK=0}
        for key,val in pairs(data.Attrs or {}) do
            local stat=mapStat(key)
            local n=tonumber(val)
            if stat and n then attrs[stat]=attrs[stat]+(stat=="FlatATK" and n or n/100) end
        end
        return {Id=data.Id,UUID=data.UUID,SkillId=def and def.SkillId,
            Class=class,Attrs=attrs,RawAttrs=data.Attrs or {}}
    end
    local function followedPets()
        local result={}
        local folder=LocalPlayer:FindFirstChild("EquippedPets")
        local petKeys=type(KeyString.PetUtil)=="table" and KeyString.PetUtil or {}
        local ownedPath={petKeys.Pets or "Pets",petKeys.Owned or "Owned"}
        if folder then
            for _,pet in ipairs(folder:GetChildren()) do
                local uid=pet:GetAttribute("UID") or pet:GetAttribute("Uid")
                if uid then
                    local attributes={}
                    for k,v in pairs(pet:GetAttributes()) do
                        local t=typeof(v)
                        if t=="string" or t=="number" or t=="boolean" then
                            attributes[k]=v
                        else attributes[k]=tostring(v) end
                    end
                    local record={Name=pet.Name,UID=tostring(uid),Attributes=attributes}
                    local paths={{ownedPath[1],ownedPath[2],uid},{"Pets","Owned",uid}}
                    for _,path in ipairs(paths) do
                        local ok,data=pcall(function()return DataUtil:GetValue(LocalPlayer,path)end)
                        if ok and type(data)=="table" then
                            record.PetData={Id=data.Id or data.ID,Level=data.Level or data.Lv,
                                Rarity=data.Rarity,Attrs=type(data.Attrs)=="table" and data.Attrs or nil,
                                Passive=data.Passive or data.SkillId}
                            break
                        end
                    end
                    result[#result+1]=record
                end
            end
        end
        table.sort(result,function(a,b)return a.UID<b.UID end)
        return result
    end
    local function getInfo(uuid)
        local ok,info=pcall(function() return EquipmentUtil:GetEquipmentInfo(LocalPlayer,uuid) end)
        return ok and type(info)=="table" and info or {}
    end
    local function detectSlot(item,info)
        local def=type(info.Def)=="table" and info.Def or {}
        local candidates={}
        local function add(v)
            if v~=nil then candidates[#candidates+1]=v end
        end
        for _,node in ipairs({item,info,def}) do
            if type(node)=="table" then
                for _,key in ipairs({"EquipSlot","EquipmentSlot","Slot","Part","EquipPart","Position","EquipPosition","WearPos","WearSlot","SubType","EquipmentType","EquipType","Type","Category"}) do add(node[key]) end
            end
        end
        -- Resolve enums where their names are available, never guess numeric IDs.
        for _,v in ipairs(candidates) do
            if type(v)=="number" then
                for _,enumName in ipairs({"EquipmentSlot","EquipSlot","EquipmentType","EquipType","EquipmentPart"}) do
                    local enum=GameEnum and GameEnum[enumName]
                    if type(enum)=="table" then
                        for k,code in pairs(enum) do
                            if code==v and type(k)=="string" then candidates[#candidates+1]=k end
                        end
                    end
                end
            end
        end
        local function detectName(x)
            x=norm(x)
            if x:find("helmet",1,true) or x:find("head",1,true)
                or x:find("hood",1,true) or x:find("hat",1,true) then return "Helmet" end
            if x:find("breast",1,true) or x:find("body",1,true)
                or x:find("chest",1,true) or x:find("cuirass",1,true)
                or x:find("robe",1,true) or x:find("coat",1,true)
                or (x~="armor" and x:find("armor",1,true))
                or (x~="armour" and x:find("armour",1,true)) then return "Breastplate" end
            if x:find("staff",1,true) or x:find("scepter",1,true)
                or x:find("sceptre",1,true) or x:find("bow",1,true)
                or x:find("sword",1,true) or x:find("fist",1,true)
                or x:find("gun",1,true) or x:find("dagger",1,true)
                or x:find("axe",1,true) or x:find("wand",1,true)
                or x:find("blade",1,true) or x:find("katana",1,true) then return "Weapon" end
            if x=="weapon" or x=="weapons" then return "Weapon" end
            return nil
        end
        for _,v in ipairs(candidates) do
            local t=detectName(v)
            if t then return t end
        end
        for _,node in ipairs({item,info,def}) do
            for _,key in ipairs({"ID","Id","Name","DisplayName"}) do
                local name=node[key]
                if type(name)=="string" then
                    local t=detectName(name);if t then return t end
                end
            end
        end
        for _,node in ipairs({item,info,def}) do
            if type(node)=="table" then
                for _,field in ipairs({"Class","WeaponClass"}) do
                    local c=node[field]
                    if type(c)=="string" and c~="" and c~="None" then return "Weapon" end
                end
            end
        end
        return nil
    end
    local function levelOf(item,info)
        local def=type(info.Def)=="table" and info.Def or {}
        for _,node in ipairs({item,info,def}) do
            if type(node)=="table" then
                for _,key in ipairs({"Level","Lv","ItemLevel","EquipmentLevel","EquipLevel","ReqLevel","RequiredLevel","MinLevel","LevelReq"}) do
                    local value=tonumber(node[key])
                    if value and value>=1 and value<=500 and value%1==0 then return value,key end
                end
            end
        end
        for _,s in ipairs({tostring(item.Name or ""),tostring(info.Name or "")}) do
            local n=tonumber(s:match("[Ll][Vv]%.?%s*(%d+)"))
            if n and n>=1 and n<=500 then return n,"name" end
        end
        return nil,"UNKNOWN_LEVEL"
    end
    local function displayName(item,info,uuid)
        local def=type(info.Def)=="table" and info.Def or {}
        local id=tostring(item.ID or item.Id or def.ID or info.ID or uuid)
        for _,node in ipairs({info,item,def}) do
            for _,key in ipairs({"DisplayName","Name","ItemName","Title"}) do
                local name=node[key]
                if type(name)=="string" and name~="" and name~=id then return name end
            end
        end
        local trans=Framework.Modules.TranslationUtil
        if trans and type(trans.TranslateByKey)=="function" then
            local ok,value=pcall(function()return trans:TranslateByKey("K_"..id:upper())end)
            if ok and type(value)=="string" and value~="" and value~=("K_"..id:upper()) then return value end
        end
        return id
    end
    local function attackOf(item,info)
        -- Only fields from equipment itself (not 'Power', which is NOT ATK).
        -- An item's enhancement may change these; report a missing value rather
        -- than inventing it from rarity, Rune, or generic equipment power.
        for _,source in ipairs({info,item}) do
            if type(source)=="table" then
                for _,key in ipairs({"WeaponATK","WeaponAtk","Attack","ATK","Atk","AttackValue","BaseATK","BaseAtk"}) do
                    local value=tonumber(source[key])
                    if value and value>0 then return value,key end
                end
            end
        end
        return nil,nil
    end
    local function weaponClassOf(item,info,def,slot)
        if slot~="Weapon" then return "" end
        for _,node in ipairs({item,info,def}) do
            for _,field in ipairs({"Class","WeaponClass","WeaponType","WeaponCategory"}) do
                local c=node[field]
                if type(c)=="string" and c~="" then return c end
            end
        end
        local id=norm(item.ID or item.Id or info.ID or info.Id or def.ID or "")
        for _,cl in ipairs({"Staff","Bow","Gun","Fist","Sword","Scepter","Light","Heavy"}) do
            if id:find(cl:lower(),1,true) then
                return cl=="Scepter" and "Staff" or cl
            end
        end
        return ""
    end
    local function itemList()
        local owned=EquipmentData:GetOwned(LocalPlayer)
        assert(type(owned)=="table","Không đọc được túi EquipmentData")
        local groups={Weapon={},Helmet={},Breastplate={},Unknown={}}
        local equipped={}
        local activeWeaponUUID
        pcall(function()
            local cur=EquipmentUtil:GetCurWeaponData(LocalPlayer)
            activeWeaponUUID=cur and tostring(cur.UUID)
        end)
        local unknown=0
        for uuid,item in pairs(owned) do
            if type(item)=="table" then
                local info=getInfo(uuid)
                local slot=detectSlot(item,info)
                local attrs,known,attrSource,attrFields=rawItemAttrs(item,info)
                local level,levelSource=levelOf(item,info)
                local atk,atkSource=attackOf(item,info)
                local isEquipped=false
                pcall(function() isEquipped=EquipmentUtil:IsEquipByUUID(LocalPlayer,uuid)==true end)
                local def=type(info.Def)=="table" and info.Def or {}
                local entry={UUID=tostring(uuid),RawUUID=uuid,Slot=slot,
                    Id=tostring(item.ID or item.Id or def.ID or info.ID or "?"),
                    Name=displayName(item,info,uuid),Level=level,LevelSource=levelSource,
                    Class=weaponClassOf(item,info,def,slot),
                    Attack=atk,AttackSource=atkSource,Attrs=attrs,AttrsKnown=known,
                    AttrSource=attrSource,AttrFields=attrFields,
                    Equipped=isEquipped,Rarity=tonumber(info.Rarity or item.Rarity or def.Rarity) or 0}
                if slot then
                    groups[slot][#groups[slot]+1]=entry
                    if isEquipped then
                        if slot~="Weapon" or activeWeaponUUID==nil or tostring(uuid)==activeWeaponUUID then
                            equipped[slot]=entry
                        end
                    end
                else
                    unknown=unknown+1
                    groups.Unknown[#groups.Unknown+1]=entry
                end
            end
        end
        return groups,equipped,unknown
    end
    local function calculateScore(base,r)
        local p=math.clamp(r.CritRate or 0,0,1)
        local c=math.max(0,r.CritDamage or 0)
        return base*math.max(0,1+(r.AttackBonus or 0))*math.max(0,1+(r.SkillDamage or 0))*(1+p*c)
    end
    local function combineScore(snap,weapon,helmet,armor)
        local rates={}
        for _,key in ipairs({"AttackBonus","SkillDamage","CritRate","CritDamage"}) do
            rates[key]=snap.Totals[key] or 0
        end
        local hasBase=snap.BaseATK~=nil
        local base=hasBase and snap.BaseATK or 1
        local weaponChanged=false
        for _,pair in ipairs({{"Weapon",weapon},{"Helmet",helmet},{"Breastplate",armor}}) do
            local slot,new=pair[1],pair[2]
            local old=snap.Equipped[slot]
            if new~=old then
                for _,key in ipairs({"AttackBonus","SkillDamage","CritRate","CritDamage"}) do
                    rates[key]=rates[key]+(new and new.Attrs[key] or 0)-(old and old.Attrs[key] or 0)
                end
                if hasBase then
                    base=base+(new and new.Attrs.FlatATK or 0)-(old and old.Attrs.FlatATK or 0)
                end
                if slot=="Weapon" then
                    weaponChanged=true
                    if hasBase and new and old and new.Attack and old.Attack then
                        base=base+new.Attack-old.Attack
                    end
                end
            end
        end
        -- Active Scroll is keyed by *weapon class*, so changing class can
        -- change both the G skill and passive scroll attributes.
        local nextClass=weapon and weapon.Class or snap.WeaponClass
        if nextClass~=snap.WeaponClass then
            -- Cache once per weapon class: do not query ScrollUtil 10k times
            -- during cross-class exhaustive search.
            snap.ClassScrollCache=snap.ClassScrollCache or {}
            if snap.ClassScrollCache[nextClass]==nil then
                snap.ClassScrollCache[nextClass]=getCurrentScroll(nextClass) or false
            end
            local nextScroll=snap.ClassScrollCache[nextClass] or nil
            for _,key in ipairs({"AttackBonus","SkillDamage","CritRate","CritDamage"}) do
                rates[key]=rates[key]+(nextScroll and nextScroll.Attrs[key] or 0)
                    -(snap.Scroll and snap.Scroll.Attrs[key] or 0)
            end
        end
        return calculateScore(math.max(1,base),rates),rates,base,weaponChanged
    end
    local function scanDPS()
        local manualPet,manualScroll,manualTotal=manualInputs()
        local totals,found,missing,base,baseKey=readTotalRates(manualTotal)
        local groups,equipped,unknown=itemList()
        local pet=followedPets()
        local wc=equipped.Weapon and equipped.Weapon.Class or ""
        if wc=="" then
            local wu=Framework.Modules.WeaponUtil
            if wu and type(wu.GetEquippedWeaponClass)=="function" then
                local ok,v=pcall(function()return wu:GetEquippedWeaponClass(LocalPlayer)end)
                if ok and type(v)=="string" then wc=v end
            end
        end
        local scroll=getCurrentScroll(wc)
        if manualScroll then
            scroll=scroll or {Id="MANUAL_SCROLL",Class=wc,UUID="MANUAL"}
            scroll.AutoAttrs=scroll.Attrs
            scroll.Attrs=manualScroll
            scroll.Manual=true
        end
        local originalMissing={}
        for _,key in ipairs(missing) do originalMissing[#originalMissing+1]=key end
        -- Game total is authoritative if it exists. Never double add Pet/Scroll.
        -- For a MISSING stat only, reconstruct the known pieces of the build.
        -- Such a reconstruction is PARTIAL because untracked buffs may exist.
        for _,key in ipairs(originalMissing) do
            local approx=(manualPet and manualPet[key] or 0)+(scroll and scroll.Attrs[key] or 0)
            for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
                local eq=equipped[slot]
                if eq then approx=approx+(eq.Attrs[key] or 0) end
            end
            totals[key]=approx
            found[key]={Key="PARTIAL equipped gear + PET/SCROLL",Raw=approx}
        end
        local snapshot={Totals=totals,TotalSources=found,Missing=originalMissing,
            BaseATK=base,BaseSource=baseKey,Groups=groups,Equipped=equipped,
            WeaponClass=wc,Scroll=scroll,Pet=pet,ManualPet=manualPet,
            ManualScroll=manualScroll,ManualTotals=manualTotal,Unclassified=unknown,
            ItemsCount=#groups.Weapon+#groups.Helmet+#groups.Breastplate+#groups.Unknown}
        -- Restrict comparisons to current weapon class by default: different
        -- classes have different skill DamageRate, hit windows and AoE, which
        -- cannot be compared solely with the Discord per-hit formula.
        -- V4.9.30: rank only gear whose real affix schema could be decoded.
        -- Still DISPLAY all unknown gear, but do not silently assign 0% to it
        -- and then claim the best-known candidate is the absolute optimum.
        local candidates={}
        local unseenAttrsBySlot={Weapon=0,Helmet=0,Breastplate=0}
        local noComparableBySlot={}
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            local comparable,known={},{}
            for _,entry in ipairs(groups[slot]) do
                if slot~="Weapon" or Config.DPSCompareAllClasses or wc=="" or entry.Class==wc then
                    comparable[#comparable+1]=entry
                    if entry.AttrsKnown then
                        known[#known+1]=entry
                    else
                        unseenAttrsBySlot[slot]=unseenAttrsBySlot[slot]+1
                    end
                end
            end
            if #known>0 then
                candidates[slot]=known
            else
                -- No confirmed alternatives -> keep current gear as an
                -- explicitly UNCERTAIN placeholder. Never fabricate scores.
                candidates[slot]={equipped[slot] or false}
                noComparableBySlot[slot]=true
            end
        end
        -- No silent top-30 truncation. Pareto-prune only candidates where an
        -- existing item is >= in EVERY relevant stat (same weapon class).
        -- Formula is monotonic in all nonnegative buffs; this is exact if
        -- every compared attribute was successfully decoded.
        local statKeys={"AttackBonus","SkillDamage","CritRate","CritDamage","FlatATK"}
        local function dominates(a,b,slot)
            if not a or not b or not a.AttrsKnown or not b.AttrsKnown then return false end
            if slot=="Weapon" then
                if a.Class~=b.Class or not a.Attack or not b.Attack or a.Attack<b.Attack then return false end
            end
            for _,key in ipairs(statKeys) do
                if (a.Attrs[key] or 0)<(b.Attrs[key] or 0) then return false end
            end
            return true
        end
        local pruned={}
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            local original=candidates[slot]
            local filtered={}
            for i,item in ipairs(original) do
                local skip=false
                if item then
                    for j,other in ipairs(original) do
                        if i~=j and other and dominates(other,item,slot)
                            and (j<i or not dominates(item,other,slot)) then skip=true;break end
                    end
                end
                if not skip then filtered[#filtered+1]=item end
            end
            candidates[slot]=filtered
            pruned[slot]=#original-#filtered
        end
        local possible=#candidates.Weapon*#candidates.Helmet*#candidates.Breastplate
        assert(possible<=2000000,
            "Quá nhiều tổ hợp ("..tostring(possible).."). Chưa có kết quả chính xác; cần lọc bớt đồ cũ hoặc xác minh Attrs.")
        local best={Score=-math.huge}
        local tested=0
        for _,w in ipairs(candidates.Weapon) do
            for _,h in ipairs(candidates.Helmet) do
                for _,a in ipairs(candidates.Breastplate) do
                    local score=combineScore(snapshot,w or nil,h or nil,a or nil)
                    if score>best.Score then best={Score=score,Weapon=w or nil,Helmet=h or nil,Breastplate=a or nil} end
                    tested=tested+1
                    if tested%3000==0 then task.wait() end
                end
            end
        end
        snapshot.TestedCombos=tested
        snapshot.Pruned=pruned
        snapshot.UnscoredBySlot=unseenAttrsBySlot
        snapshot.NoComparableBySlot=noComparableBySlot
        snapshot.CurrentScore=combineScore(snapshot,equipped.Weapon,equipped.Helmet,equipped.Breastplate)
        snapshot.Best=best
        snapshot.Partial=(#originalMissing>0 or base==nil or equipped.Weapon==nil)
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            if unseenAttrsBySlot[slot]>0 or noComparableBySlot[slot] then
                snapshot.Partial=true
            end
        end
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            if #groups[slot]==0 then snapshot.Partial=true end
        end
        snapshot.Reasons={}
        if manualTotal then snapshot.Reasons[#snapshot.Reasons+1]="TOTAL STATS nhập tay; phải trùng Total Stats của game" end
        if manualPet then snapshot.Reasons[#snapshot.Reasons+1]="PET nhập tay; đã nằm trong TOTAL, không cộng hai lần" end
        if manualScroll then snapshot.Reasons[#snapshot.Reasons+1]="Scroll nhập tay; đã nằm trong TOTAL, không cộng hai lần" end
        if #originalMissing>0 then
            snapshot.Reasons[#snapshot.Reasons+1]="Total stat thiếu: "..table.concat(originalMissing,",").." (dùng ước lượng thiếu buff khác)"
        end
        if Config.DPSCompareAllClasses then
            snapshot.Partial=true
            snapshot.Reasons[#snapshot.Reasons+1]="ALL CLASSES: chỉ xếp hạng damage công thức; KHÔNG so được AoE/hit/CD skill"
        end
        local sumRates=0
        for _,key in ipairs({"AttackBonus","SkillDamage","CritRate","CritDamage"}) do
            sumRates=sumRates+math.abs(totals[key])
        end
        if (wc=="" or wc==nil) and #groups.Weapon>0 then
            snapshot.Partial=true
            snapshot.Reasons[#snapshot.Reasons+1]="Chưa xác nhận class đang chơi; so sánh vũ khí khác skill chỉ mang tính hệ số"
        end
        if sumRates==0 and snapshot.ItemsCount>0 and not manualTotal then
            snapshot.Partial=true
            snapshot.Reasons[#snapshot.Reasons+1]="all AttrEntry rates = 0; verify enum aliases / displayed stats"
        end
        if base==nil then snapshot.Reasons[#snapshot.Reasons+1]="BaseATK unknown; scores are multipliers" end
        if equipped.Weapon==nil then snapshot.Reasons[#snapshot.Reasons+1]="equipped weapon not classified" end
        if equipped.Weapon and not equipped.Weapon.Attack then
            snapshot.Partial=true
            snapshot.Reasons[#snapshot.Reasons+1]="WeaponATK field missing; weapon comparison excludes base ATK differences"
        end
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            local item=equipped[slot]
            if item and not item.AttrsKnown then
                snapshot.Partial=true
                snapshot.Reasons[#snapshot.Reasons+1]=slot.." equipped has no recognized Attrs; check raw item schema"
            end
        end
        if scroll then
            for _,kind in ipairs({"AttackBonus","SkillDamage","CritRate","CritDamage"}) do
                if (scroll.Attrs[kind] or 0)>0 and (totals[kind] or 0)==0 then
                    snapshot.Partial=true
                    snapshot.Reasons[#snapshot.Reasons+1]=kind.." from Scroll nonzero but total entry = 0"
                end
            end
        end
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            local item=best[slot]
            if item and not item.AttrsKnown then
                snapshot.Partial=true
                snapshot.Reasons[#snapshot.Reasons+1]=slot.." đề xuất thiếu Attrs: chưa thể chứng nhận tối ưu"
            end
        end
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            if #groups[slot]==0 then
                snapshot.Reasons[#snapshot.Reasons+1]="Không nhận diện được loại "..slot.." trong kho; cần debug schema"
            end
        end
        if not equipped.Helmet or not equipped.Breastplate then
            snapshot.Partial=true
            snapshot.Reasons[#snapshot.Reasons+1]="Không nhận diện đủ Helmet/Armor đang mặc"
        end
        if unknown>0 then
            snapshot.Partial=true
            snapshot.Reasons[#snapshot.Reasons+1]=tostring(unknown).." món không xác định Slot, chưa đưa vào ranking"
        end
        for _,slot in ipairs({"Weapon","Helmet","Breastplate"}) do
            if unseenAttrsBySlot[slot]>0 then
                snapshot.Reasons[#snapshot.Reasons+1]=slot..": "..tostring(unseenAttrsBySlot[slot])
                    .." món chưa nhận diện Attrs; vẫn hiện trong bảng, không tính vào top"
            end
            if noComparableBySlot[slot] then
                snapshot.Reasons[#snapshot.Reasons+1]=slot..": không có món đủ dữ liệu để chấm điểm"
            end
        end
        for _,weapon in ipairs(groups.Weapon) do
            if not weapon.Attack then
                snapshot.Partial=true
                snapshot.Reasons[#snapshot.Reasons+1]="Có Weapon thiếu ATK thực; thứ hạng Weapon cần xác nhận"
                break
            end
        end
        Runtime.DPSLastSnapshot=snapshot
        return snapshot
    end
    local function itemShort(item)
        if not item then return "Chưa xác định" end
        return tostring(item.Name).." (Lv."..tostring(item.Level or "?")..")"
    end
    local function pct(v) return string.format("%+.1f%%",(tonumber(v) or 0)*100) end
    local function pctItem(item,stat)
        if not item or not item.AttrsKnown then return "?" end
        return pct(item.Attrs[stat] or 0)
    end
    -- Full-screen readable table instead of concatenating technical warnings
    -- into one low-height text label on the Forge tab.
    local cover=Instance.new("Frame",ScreenGui)
    cover.Name="GearDpsTableOverlay"
    cover.Size=UDim2.new(1,-14,1,-14)
    cover.Position=UDim2.fromOffset(7,7)
    cover.BackgroundColor3=Color3.fromRGB(19,21,31)
    cover.BorderSizePixel=2
    cover.BorderColor3=Color3.fromRGB(105,112,170)
    cover.ZIndex=350
    cover.Visible=false
    local title=Instance.new("TextLabel",cover)
    title.Position=UDim2.new(0,12,0,9)
    title.Size=UDim2.new(1,-105,0,39)
    title.BackgroundTransparency=1
    title.Font=Enum.Font.GothamBold
    title.TextColor3=Color3.fromRGB(244,222,150)
    title.TextSize=19
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.Text="BẢNG XẾP HẠNG DPS — WEAPON / ARMOR / HELMET"
    title.ZIndex=352
    local close=Instance.new("TextButton",cover)
    close.Position=UDim2.new(1,-90,0,9)
    close.Size=UDim2.fromOffset(78,35)
    close.Text="ĐÓNG X"
    close.Font=Enum.Font.GothamBold
    close.TextColor3=Color3.new(1,1,1)
    close.BackgroundColor3=Color3.fromRGB(148,57,66)
    close.ZIndex=352
    close.MouseButton1Click:Connect(function()cover.Visible=false end)
    local summary=Instance.new("TextLabel",cover)
    summary.Position=UDim2.new(0,12,0,52)
    summary.Size=UDim2.new(1,-24,0,58)
    summary.BackgroundColor3=Color3.fromRGB(34,38,55)
    summary.Font=Enum.Font.GothamSemibold
    summary.TextColor3=Color3.fromRGB(225,232,246)
    summary.TextSize=12
    summary.TextWrapped=true
    summary.ZIndex=352
    summary.Text="Chưa quét"
    local tableScroll=Instance.new("ScrollingFrame",cover)
    tableScroll.Position=UDim2.new(0,12,0,116)
    tableScroll.Size=UDim2.new(1,-24,1,-128)
    tableScroll.BackgroundColor3=Color3.fromRGB(24,27,38)
    tableScroll.ScrollBarThickness=9
    tableScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    tableScroll.CanvasSize=UDim2.new()
    tableScroll.ZIndex=351
    local layout=Instance.new("UIListLayout",tableScroll)
    layout.Padding=UDim.new(0,3)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    local widths={.36,.08,.14,.14,.14,.14}
    local columns={"TÊN MÓN","LEVEL","ATTACK BONUS","CRIT CHANCE","CRIT DMG","SKILL DMG"}
    local rowN=0
    local function clearTable()
        for _,child in ipairs(tableScroll:GetChildren()) do
            if child~=layout then child:Destroy() end
        end
        rowN=0
    end
    local function addTextLine(textValue,category)
        rowN=rowN+1
        local obj=Instance.new("TextLabel",tableScroll)
        obj.LayoutOrder=rowN
        obj.Size=UDim2.new(1,-10,0,category and 29 or 35)
        obj.BackgroundColor3=category and Color3.fromRGB(60,51,85) or Color3.fromRGB(34,38,55)
        obj.TextColor3=category and Color3.fromRGB(255,219,136) or Color3.fromRGB(225,230,246)
        obj.TextSize=category and 14 or 12
        obj.Font=Enum.Font.GothamBold
        obj.TextXAlignment=Enum.TextXAlignment.Left
        obj.TextWrapped=true
        obj.Text="   "..textValue
        obj.ZIndex=352
    end
    local function addRow(cells,selected,equipped)
        rowN=rowN+1
        local row=Instance.new("Frame",tableScroll)
        row.LayoutOrder=rowN
        row.Size=UDim2.new(1,-10,0,32)
        row.BackgroundColor3=selected and Color3.fromRGB(45,98,74)
            or equipped and Color3.fromRGB(46,72,105)
            or (rowN%2==0 and Color3.fromRGB(34,37,51) or Color3.fromRGB(29,32,46))
        row.BorderSizePixel=0
        row.ZIndex=352
        local offset=0
        for i,weight in ipairs(widths) do
            local lbl=Instance.new("TextLabel",row)
            lbl.Position=UDim2.fromScale(offset,0)
            lbl.Size=UDim2.new(weight,0,1,0)
            lbl.BackgroundTransparency=1
            lbl.Font=selected and Enum.Font.GothamBold or Enum.Font.Gotham
            lbl.TextColor3=Color3.fromRGB(243,246,249)
            lbl.TextXAlignment=i==1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
            lbl.TextTruncate=Enum.TextTruncate.AtEnd
            lbl.TextSize=i==1 and 12 or 11
            lbl.Text="  "..tostring(cells[i] or "")
            lbl.ZIndex=353
            offset=offset+weight
        end
    end
    local function drawTable(snap)
        clearTable()
        local best=snap.Best
        local lack=(snap.Partial or snap.Unclassified>0)
        local status=lack and "CHƯA ĐỦ DỮ LIỆU ĐỂ CHỨNG NHẬN TỐI ƯU" or "ƯỚC TÍNH TỪ 4 CHỈ SỐ"
        summary.Text=string.format("%s | Quét %d món (không nhận dạng %d) | %d tổ hợp | Màu xanh lá: đề xuất; xanh dương: đang mặc. Dấu ? = chưa đọc được.",
            status,snap.ItemsCount,snap.Unclassified,snap.TestedCombos)
        addTextLine(lack and "BỘ 3 THAM KHẢO — CHƯA XÁC MINH ĐỦ STATS"
            or "BỘ 3 TỐI ƯU HỆ SỐ SÁT THƯƠNG (CÙNG CLASS)",true)
        addRow(columns)
        for _,slot in ipairs({"Weapon","Breastplate","Helmet"}) do
            local item=best[slot]
            local label=slot=="Weapon" and "VŨ KHÍ" or slot=="Helmet" and "MŨ" or "GIÁP"
            local verified=item and item.AttrsKnown and not snap.NoComparableBySlot[slot]
            addRow({label..": "..(verified and itemShort(item) or "CHƯA ĐỦ DỮ LIỆU"),
                verified and (item.Level or "?") or "?",
                verified and pctItem(item,"AttackBonus") or "?",
                verified and pctItem(item,"CritRate") or "?",
                verified and pctItem(item,"CritDamage") or "?",
                verified and pctItem(item,"SkillDamage") or "?"},verified,false)
        end
        addTextLine(string.format("Hệ số %s / đang dùng %s | Chỉ là hệ số sát thương kỳ vọng, chưa gồm AoE / cooldown.",
            string.format("%.3f",best.Score),string.format("%.3f",snap.CurrentScore)),false)
        for _,slot in ipairs({"Weapon","Breastplate","Helmet"}) do
            local label=slot=="Weapon" and "TẤT CẢ VŨ KHÍ" or slot=="Helmet" and "TẤT CẢ MŨ" or "TẤT CẢ GIÁP"
            local items=table.clone(snap.Groups[slot] or {})
            local current=snap.Equipped[slot]
            local pick=best[slot]
            table.sort(items,function(a,b)
                if (a==pick)~=(b==pick) then return a==pick end
                if (a==current)~=(b==current) then return a==current end
                if a.AttrsKnown~=b.AttrsKnown then return a.AttrsKnown end
                local as,bs
                if slot=="Weapon" then
                    as=combineScore(snap,a,best.Helmet,best.Breastplate)
                    bs=combineScore(snap,b,best.Helmet,best.Breastplate)
                elseif slot=="Helmet" then
                    as=combineScore(snap,best.Weapon,a,best.Breastplate)
                    bs=combineScore(snap,best.Weapon,b,best.Breastplate)
                else
                    as=combineScore(snap,best.Weapon,best.Helmet,a)
                    bs=combineScore(snap,best.Weapon,best.Helmet,b)
                end
                if as~=bs then return as>bs end
                return (a.Level or 0)>(b.Level or 0)
            end)
            addTextLine(label.." ("..tostring(#items).." món)",true)
            addRow(columns)
            for _,item in ipairs(items) do
                local flags=(item==pick and "[TOP] " or "")..(item==current and "[MẶC] " or "")
                addRow({flags..tostring(item.Name),item.Level or "?",
                    pctItem(item,"AttackBonus"),pctItem(item,"CritRate"),
                    pctItem(item,"CritDamage"),pctItem(item,"SkillDamage")},item==pick,item==current)
            end
        end
        if #(snap.Groups.Unknown or {})>0 then
            addTextLine("CHƯA PHÂN LOẠI (KHÔNG ĐƯA VÀO XẾP HẠNG): "..#snap.Groups.Unknown.." món",true)
            addRow(columns)
            for _,item in ipairs(snap.Groups.Unknown) do
                addRow({tostring(item.Name),item.Level or "?",
                    pctItem(item,"AttackBonus"),pctItem(item,"CritRate"),
                    pctItem(item,"CritDamage"),pctItem(item,"SkillDamage")},false,item.Equipped)
            end
        end
        addTextLine("ĐỌC BẢNG: [TOP] là món đang được chọn trong tổ hợp; [MẶC] là đang trang bị. "
            .."Dấu ? = game chưa trả được chỉ số (KHÔNG phải 0%).",false)
        if lack then
            addTextLine("CÒN THIẾU DỮ LIỆU — bấm XUẤT DEBUG SCHEMA ở tab Forge nếu bảng hiện dấu ?. "
                .."Không dùng bộ 3 tạm tính để tự bán hoặc thay đồ.",false)
        end
        tableScroll.CanvasPosition=Vector2.new(0,0)
    end
    local function saveReport(snap)
        local report={At=os.time(),Formula="(WeaponATK+AttributeATK)*(1+A)*(1+S)*(1+min(P,1)*C)",
            Totals=snap.Totals,TotalSources=snap.TotalSources,Missing=snap.Missing,
            BaseATK=snap.BaseATK,BaseSource=snap.BaseSource,
            CurrentScore=snap.CurrentScore,Best=snap.Best,
            Partial=snap.Partial,Reasons=snap.Reasons,PetFollow=snap.Pet,
            ActiveScroll=snap.Scroll,WeaponClass=snap.WeaponClass,
            Unclassified=snap.Unclassified,OwnedCount=snap.ItemsCount,AllGear=snap.Groups,
            ManualPet=snap.ManualPet,ManualScroll=snap.ManualScroll,ManualTotals=snap.ManualTotals,
            TestedCombos=snap.TestedCombos,Pruned=snap.Pruned,
            UnscoredBySlot=snap.UnscoredBySlot,NoComparableBySlot=snap.NoComparableBySlot,
            CompareAllClasses=Config.DPSCompareAllClasses}
        if type(writefile)=="function" then
            pcall(function()
                if type(isfolder)=="function" and type(makefolder)=="function"
                    and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
                writefile(ConfigFolder.."/DPS_Gear_Report_U"..tostring(LocalPlayer.UserId)..".json",
                    HttpService:JSONEncode(report))
            end)
        end
    end
    local lastSnapshot
    local function refreshDPS()
        local snap=scanDPS()
        saveReport(snap)
        lastSnapshot=snap
        local ratio=snap.CurrentScore>0 and (snap.Best.Score/snap.CurrentScore-1)*100 or 0
        local verified=not snap.Partial
        dpsStatus.Text=string.format("QUÉT %d món: %d Vũ khí | %d Giáp | %d Mũ | %d chưa phân loại. %s",
            snap.ItemsCount,#snap.Groups.Weapon,#snap.Groups.Breastplate,#snap.Groups.Helmet,
            snap.Unclassified,verified and "4 chỉ số đã đọc" or "CÒN THIẾU DỮ LIỆU")
        dpsDetail.Text="VŨ KHÍ: "..(snap.Best.Weapon and snap.Best.Weapon.AttrsKnown and itemShort(snap.Best.Weapon) or "CHƯA ĐỌC ĐỦ")
            .."\nGIÁP: "..(snap.Best.Breastplate and snap.Best.Breastplate.AttrsKnown and itemShort(snap.Best.Breastplate) or "CHƯA ĐỌC ĐỦ")
            .."\nMŨ: "..(snap.Best.Helmet and snap.Best.Helmet.AttrsKnown and itemShort(snap.Best.Helmet) or "CHƯA ĐỌC ĐỦ")
            .."\nHỆ SỐ: "..string.format("%.3f",snap.Best.Score)
            .." | HIỆN TẠI "..string.format("%.3f",snap.CurrentScore)
            ..(verified and (" | Kỳ vọng thay đổi: "..string.format("%+.1f%%",ratio))
                or " | XẾP HẠNG CHƯA CHẮC CHẮN")
            .."\nBấm [XEM BẢNG] để xem đủ tên, level, 4 chỉ số TỪNG MÓN."
        dpsDetail.Size=UDim2.new(.94,0,0,124)
        drawTable(snap)
        Runtime.Log("DPS_SCAN_V428 items="..snap.ItemsCount.." missing="..tostring(snap.Unclassified)
            .." W="..itemShort(snap.Best.Weapon).." H="..itemShort(snap.Best.Helmet)
            .." A="..itemShort(snap.Best.Breastplate))
        StatusLbl.Text="Đã quét "..tostring(snap.ItemsCount).." món. Bấm XEM BẢNG DPS để xem đầy đủ."
        return snap
    end
    compactButton(Scroll,"1. QUÉT TOÀN BỘ TRANG BỊ → XEM BẢNG DPS",function()
        local ok,err=pcall(refreshDPS)
        if not ok then
            StatusLbl.Text="QUÉT DPS THẤT BẠI: "..tostring(err):sub(1,120)
            Runtime.Log("DPS_SCAN_ERROR "..tostring(err))
            return
        end
        cover.Visible=true -- show requested table without a second click
    end,Color3.fromRGB(42,100,139))
    compactButton(Scroll,"2. XEM BẢNG DPS: VŨ KHÍ / GIÁP / MŨ",function()
        if not lastSnapshot then refreshDPS() end
        cover.Visible=true
    end,Color3.fromRGB(44,117,95))
    compactButton(Scroll,"XUẤT DEBUG SCHEMA ĐỒ (KHI CHỈ SỐ = ?)",function()
        local snap=lastSnapshot or refreshDPS()
        local diagnostic={At=os.time(),Unclassified=snap.Unclassified,Counts={
            Weapon=#snap.Groups.Weapon,Helmet=#snap.Groups.Helmet,Armor=#snap.Groups.Breastplate},
            Entries={},Unknown={}}
        for _,slot in ipairs({"Weapon","Helmet","Breastplate","Unknown"}) do
            for _,item in ipairs(snap.Groups[slot]) do
                diagnostic.Entries[#diagnostic.Entries+1]={Name=item.Name,Id=item.Id,UUID=item.UUID,
                    Slot=slot,Level=item.Level,AttrSource=item.AttrSource,
                    AttrFields=item.AttrFields,AttrsKnown=item.AttrsKnown,
                    Attrs=item.Attrs,Attack=item.Attack}
            end
        end
        local owned=EquipmentData:GetOwned(LocalPlayer) or {}
        local samples={Weapon=0,Helmet=0,Breastplate=0,Unknown=0}
        local function shallow(node)
            local result={}
            if type(node)~="table" then return result end
            local n=0
            for k,v in pairs(node) do
                if n>=65 then break end
                local t=type(v)
                local id=tostring(k)
                if t=="string" or t=="number" or t=="boolean" then
                    result[id]=v
                elseif t=="table" then
                    local nested={}
                    local c=0
                    for ik,iv in pairs(v) do
                        if c>=35 then break end
                        if type(iv)=="string" or type(iv)=="number" or type(iv)=="boolean" then
                            nested[tostring(ik)]=iv; c=c+1
                        end
                    end
                    result[id]=nested
                else
                    result[id]="<"..t..">"
                end
                n=n+1
            end
            return result
        end
        for uuid,item in pairs(owned) do
            if type(item)=="table" then
                local info=getInfo(uuid)
                local slot=detectSlot(item,info) or "Unknown"
                if samples[slot] and samples[slot]<3 then
                    samples[slot]=samples[slot]+1
                    diagnostic.Unknown[#diagnostic.Unknown+1]={
                        Id=item.ID or item.Id,Slot=slot,
                        Owned=shallow(item),Info=shallow(info),
                        InfoDef=shallow(type(info.Def)=="table" and info.Def or {})}
                end
            end
        end
        local path=ConfigFolder.."/DPS_Gear_Schema_U"..tostring(LocalPlayer.UserId)..".json"
        if type(writefile)=="function" then
            local ok,err=pcall(function()
                if type(isfolder)=="function" and type(makefolder)=="function" and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
                writefile(path,HttpService:JSONEncode(diagnostic))
            end)
            StatusLbl.Text=ok and ("Đã lưu debug: "..path) or ("Lỗi debug: "..tostring(err))
        else StatusLbl.Text="Executor không hỗ trợ writefile: không thể xuất JSON." end
    end,Color3.fromRGB(93,82,110))
    compactLabel(Scroll,
        "READ-ONLY: không rèn, không tiêu Ores, không bán, không tự Equip. Tổng stats game đã chứa buff Pet/Scroll. Manual nhập % chỉ dùng sửa dữ liệu thiếu/sai, không cộng trùng. Cùng class là mặc định để tránh so sánh AoE khác hệ vũ khí.",95)
    -- Retain the full code, Config and callbacks, but remove its UI from layout.
    local stash=Instance.new("Folder")
    stash.Name="HiddenDPSGearUI"
    stash.Parent=Runtime.Tabs.Forge
    local n=0
    for _,w in ipairs(Runtime.Tabs.Forge:GetChildren()) do
        if w:IsA("GuiObject") and w.LayoutOrder>dpsWidgetsStart and w.LayoutOrder<=uiOrder then
            w.Visible=false
            w.Parent=stash
            n=n+1
        end
    end
    Runtime.DPSGearUIHiddenCount=n
end
-- === END v4.9.25 OWNED-GEAR DPS SCANNER ===

-- === v4.9.26: USER-CONTROLLED 3-CRAFT CYCLE, ALL OUTPUTS KEPT ===
do
    Scroll=Runtime.Tabs.Forge
    addSectionHeader("FORGE 3 MÓN / VÒNG — TỰ NHẬP ORES")
    compactLabel(Scroll,"Mỗi vòng: 1 lần Weapon (mục tiêu Scepter), 2 lần Armor (mục tiêu Armor & Helmet). Server quyết định subtype theo RNG; không cam kết ra Scepter/Helmet.",74)
    local p=Config.DPS3Forge
    if type(p)~="table" then p={} end
    Config.DPS3Forge=p
    local defaults={
        {Key="Scepter",Type="Weapon",N=4},
        {Key="Armor",Type="Armor",N=""},
        {Key="Helmet",Type="Armor",N=""}
    }
    local edits={}
    for _,d in ipairs(defaults) do
        if type(p[d.Key])~="table" then p[d.Key]={Ore="",N=d.N} end
        local item=p[d.Key]
        edits[d.Key]={
            Ore=compactTextBox(Scroll,d.Key.." - Ore ID(s)",tostring(item.Ore or "")),
            Qty=compactTextBox(Scroll,d.Key.." - Tổng ores",tostring(item.N or d.N)),
            Type=d.Type
        }
    end
    local roundsBox=compactTextBox(Scroll,"Số vòng (1 vòng = 3 món)",tostring(p.Rounds or 1))
    local forge3Info=compactLabel(Scroll,"Nhập Ore ID từ SCAN BAG. Một loại: OreId. Nhiều loại: OreId:2,OreId2:2. Tất cả thành phẩm KEEP, không bán.",82)
    local forge3={Running=false,Stop=false,Done=0}
    Runtime.DPS3Forge=forge3
    local function collectConfig()
        local out={}
        for _,d in ipairs(defaults) do
            local ed=edits[d.Key]
            local n=tonumber(ed.Qty.Text)
            local ore=tostring(ed.Ore.Text or ""):match("^%s*(.-)%s*$")
            assert(n and n%1==0 and n>=3 and n<=99,d.Key..": số ores nguyên 3..99")
            assert(#ore>=2 and #ore<=200,d.Key..": phải nhập Ore ID(s)")
            out[d.Key]={N=n,Ore=ore}
        end
        local rounds=tonumber(roundsBox.Text)
        assert(rounds and rounds%1==0 and rounds>=1 and rounds<=500,"Số vòng nguyên 1..500")
        out.Rounds=rounds
        return out
    end
    local function parseRecipe(text,n)
        local result,total={},0
        if not text:find(":",1,true) and not text:find(",",1,true) then
            result[text]=n
        else
            for token in text:gmatch("[^,]+") do
                local id,qty=token:match("^%s*([^:%s,]+)%s*:%s*(%d+)%s*$")
                assert(id and qty,"Ore hỗn hợp cần dạng OreId:2,OreId2:2")
                qty=tonumber(qty)
                assert(qty>0 and not result[id],"Ore ID trùng hoặc số lượng không hợp lệ")
                result[id]=qty
                total=total+qty
            end
            assert(total==n,"Tổng ores trong công thức hỗn hợp phải = ô Tổng ores")
        end
        local bag=DataUtil:GetValue(LocalPlayer,{"Ores"})
        assert(type(bag)=="table","Không đọc được túi Ores")
        for id,count in pairs(result) do
            assert(tonumber(bag[id]) and tonumber(bag[id])>=count,
                "Không đủ "..id..": cần "..count..", có "..tostring(bag[id] or 0))
            assert(ForgeUtil:GetDef(id),"Không tìm thấy Ore ID trong ForgeUtil: "..id)
        end
        return result
    end
    compactButton(Scroll,"SCAN ORE IDS + COUNTS (NO SPEND)",function()
        local bag=assert(DataUtil:GetValue(LocalPlayer,{"Ores"}),"Chưa đọc được túi ores")
        local entries={}
        for id,n in pairs(bag) do
            if tonumber(n) and tonumber(n)>0 then entries[#entries+1]={id=tostring(id),n=n} end
        end
        table.sort(entries,function(a,b) return a.id<b.id end)
        local preview={}
        for i,item in ipairs(entries) do
            Runtime.Log("DPS3_ORE "..item.id.."="..tostring(item.n))
            if i<=12 then preview[#preview+1]=item.id.." x"..tostring(item.n) end
        end
        forge3Info.Text="ORE BAG "..#entries.." types: "..table.concat(preview,", "):sub(1,420)
    end,Color3.fromRGB(60,89,123))
    compactButton(Scroll,"SAVE + PREVIEW 3 RECIPES (NO SPEND)",function()
        local cfg=collectConfig()
        for _,d in ipairs(defaults) do
            local setting=cfg[d.Key]
            -- A preview checks bag amounts for the FIRST cycle only.
            local rec=parseRecipe(setting.Ore,setting.N)
            Runtime.Log("DPS3_PREVIEW "..d.Key.." craftType="..d.Type.." recipe="..HttpService:JSONEncode(rec))
        end
        p=cfg
        Config.DPS3Forge=cfg
        saveConfig()
        forge3Info.Text="READY "..cfg.Rounds.." vòng x 3 lần; mỗi món chỉ là TARGET RNG. Đã lưu cấu hình; CHƯA tiêu ores."
    end,Color3.fromRGB(56,108,129))
    compactButton(Scroll,"STOP FORGE3 AFTER CURRENT ITEM",function()
        forge3.Stop=true
        forge3Info.Text="Đã yêu cầu dừng sau món hiện tại."
    end,Color3.fromRGB(150,69,70))
    compactButton(Scroll,"START 3-ITEM FORGE CYCLES (KEEP)",function()
        assert(not forge3.Running and not Runtime.ForgeBusy and not Runtime.BatchActive
            and not Runtime.Owner and not Runtime.EntryBusy and not isLobbyBusy
            and not Runtime.ShopBusy and not Runtime.ForgeUncertain,
            "Có Auto Forge/Entry/Shop đang chạy hoặc kết quả chưa rõ")
        assert(GamePlaceUtil:IsMain() and not isTransitioning() and lobbyCharacterReady(),"Phải ở Lobby")
        assert(not Config.AutoFarm and not Config.AutoForge and not Config.AutoClearTrash
            and not Config.AutoTrashFEBS and not Config.AutoTrashSell,
            "Tắt Auto Farm, Auto Forge, Auto Clear Trash, FEBS, Auto Sell trước khi rèn KEEP")
        local cfg=collectConfig()
        for _,d in ipairs(defaults) do parseRecipe(cfg[d.Key].Ore,cfg[d.Key].N) end
        p=cfg; Config.DPS3Forge=cfg; saveConfig()
        forge3.Running,forge3.Stop,forge3.Done=true,false,0
        Runtime.BatchActive=true
        forge3Info.Text="Đang rèn 3 món / vòng — KEEP."
        task.spawn(function()
            local ok,err=pcall(function()
                for cycle=1,cfg.Rounds do
                    if forge3.Stop or not Runtime.Alive then break end
                    for _,d in ipairs(defaults) do
                        if forge3.Stop or not Runtime.Alive then break end
                        assert(GamePlaceUtil:IsMain() and not isTransitioning() and lobbyCharacterReady(),"Không còn ở Lobby")
                        local q=cfg[d.Key]
                        local recipe=parseRecipe(q.Ore,q.N)
                        Runtime.ForgeBusy=true
                        local uuid=forgeRecipe(recipe,d.Type,true,"KEEP")
                        Runtime.ForgeBusy=false
                        forge3.Done=forge3.Done+1
                        Runtime.Log("DPS3_KEEP cycle="..cycle.." target="..d.Key.." uuid="..tostring(uuid).." (actual subtype random)")
                        forge3Info.Text="KEEP "..forge3.Done.."/"..(cfg.Rounds*3).." | Vòng "..cycle.." | Target "..d.Key
                        task.wait(.35)
                    end
                end
            end)
            Runtime.ForgeBusy=false
            Runtime.BatchActive=false
            forge3.Running=false
            if not ok then
                if Runtime.ProtectPendingForge then Runtime.ProtectPendingForge() end
                forge3Info.Text="FORGE3 STOP ERROR: "..tostring(err):sub(1,190)
                Runtime.Log("DPS3_ERROR "..tostring(err))
            else
                forge3Info.Text="FORGE3 DONE/STOP: "..forge3.Done.." món KEEP. Kiểm tra túi trước khi Auto Sell."
            end
        end)
    end,Color3.fromRGB(46,126,81))
end
-- === END v4.9.26 3-CRAFT CYCLE ===

-- v4.9.4 UI only: move background cleanup and Grocery controls out of
-- the crowded Forge panel. The existing workers/state remain unchanged.
Scroll=Runtime.Tabs.Utilities
-- Ore Capacity Guard GUI removed: VIP 1400, farm does not return solely for ores.
addSectionHeader("AUTO CLEAR TRASH (LƯU CẤU HÌNH / CHẠY NỀN)")
Runtime.ToggleGuards.AutoClearTrash=function(enabling)
    -- Allow turning OFF after an uncertain Sell; only enabling could restart forging.
    assert(not Runtime.ForgeBusy and (not enabling or not Runtime.ForgeUncertain),
        "Đang/không rõ kết quả Forge; không được bắt đầu dọn rác")
    -- Disabling the cleanup worker also disables clone F.E.B.S so the GUI stays consistent.
    if not enabling and Config.AutoTrashFEBS then
        Config.AutoTrashFEBS=false
        if Runtime.ToggleRefresh.AutoTrashFEBS then Runtime.ToggleRefresh.AutoTrashFEBS() end
    end
    -- Capacity-only lock can clear; a Forge/receipt error must remain blocked.
    if not Runtime.AutoClearTrashErrorBlocked then Runtime.AutoClearTrashBlocked=false end
    Runtime.AutoClearTrashRecoverCheckAt=0
    Runtime.AutoClearTrashNextScanAt=0
    Runtime.AutoClearTrashSold=0
    -- On enable, scan immediately even when bag is far below ReturnAt.
    Config.OreCleanupActive=false
    Config.AutoClearTrashPending=(enabling == true)
    return true
end
addToggle("AUTO TRASH — luôn quét rác khi về Lobby","AutoClearTrash")
addDropdown("Rarity rác tối đa",{
    {text="Common trở xuống",val=1},
    {text="Uncommon trở xuống",val=2},
    {text="Rare trở xuống",val=3},
    {text="Epic trở xuống",val=4},
    {text="Legendary trở xuống",val=5},
},"AutoClearTrashMaxRarity")
-- v4.9.11: F.EB.S and Mythic Trash are conditional modes of Auto Clear Trash.
-- No second worker, no duplicated ForgeRF state machine.
addSectionHeader("F.E.B.S — CLONE: WEAPON ALL ELIGIBLE ORES")
Runtime.ToggleGuards.AutoTrashFEBS=function(enabling)
    -- Turning OFF an uncertain batch is safe; the ForgeUncertain lock is retained.
    assert(not Runtime.ForgeBusy and (not enabling or not Runtime.ForgeUncertain),
        "Không bật F.E.B.S khi Forge đang chạy hoặc chưa rõ kết quả")
    if enabling then
        Config.AutoClearTrash=true -- F.E.B.S implies Auto Trash; no second ON click needed.
        if Runtime.ToggleRefresh.AutoClearTrash then Runtime.ToggleRefresh.AutoClearTrash() end
    else
        -- Turning clone F.E.B.S OFF disarms cleanup, avoiding accidental MAIN Forge/Sell.
        Config.AutoClearTrash=false
        if Runtime.ToggleRefresh.AutoClearTrash then Runtime.ToggleRefresh.AutoClearTrash() end
    end
    Runtime.AutoClearTrashNextScanAt=0
    Runtime.AutoClearTrashRecoverCheckAt=0
    Config.AutoClearTrashPending=enabling==true
    return true
end
addToggle("CLONE F.E.B.S — Forge -> Sell Bow -> EquipBest -> Sell","AutoTrashFEBS")
compactLabel(Scroll,"F.E.B.S: Weapon cho mọi Ore ĐỦ LỌC; Mythic cần bật Mythic Trash riêng.",28)

addSectionHeader("MYTHIC TRASH — THEO LỌC LEVEL / RÈN")
Runtime.ToggleGuards.MythicTrashEnabled=function()
    if not Runtime.AutoClearTrashErrorBlocked then Runtime.AutoClearTrashBlocked=false end
    Runtime.AutoClearTrashNextScanAt=0
    Runtime.AutoClearTrashRecoverCheckAt=0
    return true
end
addToggle("MYTHIC TRASH (tách khỏi rác thường)","MythicTrashEnabled")
do
    local qtyInput=compactTextBox(Scroll,"Mythic ores / lượt (ví dụ 22)",tostring(Config.MythicTrashOreCount))
    local lvInput=compactTextBox(Scroll,"Chỉ dùng Mythic Lv <=",tostring(Config.MythicTrashLevelBelow))
    local mythicInfo=compactLabel(Scroll,"MYTHIC: Chọn Lv tối đa + ores/recipe, nhấn Apply hoặc Preview",36)
    compactButton(Scroll,"APPLY MYTHIC TRASH RECIPE",function()
        local qty=tonumber(qtyInput.Text)
        local below=tonumber(lvInput.Text)
        assert(qty and qty==qty and qty%1==0 and qty>=3 and qty<=100,
            "Mythic ores / lượt phải là số nguyên 3..100")
        assert(below and below==below and below%1==0 and below>=1 and below<=999,
            "Mythic Lv tối đa phải là số nguyên 1..999")
        Config.MythicTrashOreCount=qty
        Config.MythicTrashLevelBelow=below
        if not Runtime.AutoClearTrashErrorBlocked then Runtime.AutoClearTrashBlocked=false end
        Runtime.AutoClearTrashNextScanAt=0
        Runtime.AutoClearTrashRecoverCheckAt=0
        Config.AutoClearTrashPending=Config.AutoClearTrash==true
        saveConfig()
        local cloneWeapon=Config.AutoTrashFEBS
        mythicInfo.Text="Đã lưu: "..qty.." Mythic Lv <="..below
            .." / "..(cloneWeapon and "Weapon" or "Armor").." forge | Mythic Trash "..(Config.MythicTrashEnabled and "ON" or "OFF")
        StatusLbl.Text=mythicInfo.Text
        Runtime.Log("MYTHIC_TRASH_CONFIG ores="..qty.." level_below="..below
            .." enabled="..tostring(Config.MythicTrashEnabled))
    end,Color3.fromRGB(55,91,135))
    compactButton(Scroll,"PREVIEW MYTHIC TRASH (KHÔNG RÈN)",function()
        local ores=DataUtil:GetValue(LocalPlayer,{"Ores"})
        assert(type(ores)=="table","Không đọc được túi Ores")
        local total,types=0,0
        local below=Config.MythicTrashLevelBelow
        for id,amount in pairs(ores) do
            if type(amount)=="number" and amount>0 and amount%1==0
                and not (Config.ProtectedOres and Config.ProtectedOres[id]) then
                local def=ForgeUtil:GetDef(id)
                if def and tonumber(def.Rarity)==6 then
                    local lv=getOreLevel(id,def)
                    if lv and lv<=below then total=total+amount;types=types+1 end
                end
            end
        end
        local batches=math.floor(total/Config.MythicTrashOreCount)
        local cloneWeapon=Config.AutoTrashFEBS
        mythicInfo.Text=string.format("MYTHIC Lv <=%d: %d ores / %d loại | đủ %d lượt rèn %d ores/%s. KHÔNG rèn khi Preview.",
            below,total,types,batches,Config.MythicTrashOreCount,cloneWeapon and "Weapon" or "Armor")
        StatusLbl.Text=mythicInfo.Text
    end,Color3.fromRGB(44,87,106))
end
Runtime.AutoClearTrashLabel=compactLabel(Scroll,Runtime.AutoClearTrashStatus or
    "Auto Trash: Sẵn sàng (chỉ chạy ở Lobby)",42)
addSectionHeader("Grocery — 5 món | mỗi món 1 yêu cầu/60 giây")
addToggle("AUTO BUY GROCERY 60s", "GroceryAutoBuy")
addToggle("Fate Potion | GoldShop_24", "GroceryFate")
addToggle("Harvest Potion | GoldShop_25", "GroceryHarvest")
addToggle("Attack Potion | GoldShop_26", "GroceryAttack")
addToggle("Berserker Potion | GoldShop_28", "GroceryBerserker")
addToggle("Silver Potion (SeasonPotion_1) | GoldShop_30", "GrocerySilver")

    end
    setupCompactForge()
end
-- === v4.9.49 Utilities: isolate all UI bootstrap locals in a separate function. ===
-- A do block shares the *same* function register budget as the outer AIO.
-- An immediately invoked closure is an independent function (200-local budget).
-- Keep the original body and original initialization order unchanged.
;(function()
    local utilityTab=Runtime.Tabs.Utilities
    -- AddToggle/addSectionHeader use Scroll; bind it to the actual Utilities page.
    Scroll=utilityTab
    Runtime.LegacyAnalyticsUIStart=uiOrder+1
    addSectionHeader("AUTO FARM ANALYTICS / LOG")
    addToggle("AUTO SAVE PERFORMANCE LOG (30s)","AnalyticsEnabled")
    local reportLabel=compactLabel(utilityTab,"BUILD TEST 30 PHÚT: WORLD / DIFF / SỐ RUN CLEAR / THỜI GIAN CLEAR. Thống kê phụ: chết, HP mất, né, Cores.",110)
    local buildNameInput=compactTextBox(utilityTab,"Tên build (ghi vào report)",Config.AnalyticsBuildName)
    local coresPathInput=compactTextBox(utilityTab,"Cores data path (để trống = auto)",Config.AnalyticsCorePath)
    compactButton(utilityTab,"APPLY CORES PATH (READ ONLY)",function()
        Config.AnalyticsCorePath=tostring(coresPathInput.Text or ""):sub(1,100)
        saveConfig()
        StatusLbl.Text="Đã lưu đường dẫn Cores. Mốc chính vẫn là World/Diff và thời gian clear Dungeon."
    end)
    compactButton(utilityTab,"START / SWITCH BUILD TEST (30 MIN)",function()
        local name=tostring(buildNameInput.Text or "Build A"):sub(1,55)
        Runtime.Analytics.SwitchBuild(name)
        Config.AnalyticsBuildName=name
        saveConfig()
        StatusLbl.Text="Đã bắt đầu đo build "..name.." (mỗi 30 phút); mỗi lượt clear lưu World/Diff và số giây."
    end,Color3.fromRGB(46,119,132))
    compactButton(utilityTab,"EXPORT LOG + SUMMARY JSON",function()
        local a=assert(Runtime.Analytics,"Analytics chưa sẵn sàng")
        local ok,err=a.Flush(true,"MANUAL_EXPORT")
        if not ok then
            local summary=HttpService:JSONEncode(a.Summary("CLIPBOARD_FALLBACK"))
            if typeof(setclipboard)=="function" then
                pcall(setclipboard,summary)
                StatusLbl.Text="Không ghi được file ("..tostring(err):sub(1,55).."); đã thử COPY summary vào clipboard."
            else
                StatusLbl.Text="Không xuất được file: "..tostring(err):sub(1,110)
            end
            return
        end
        reportLabel.Text="Đã xuất LOG + JSON. DungeonClearTimes.csv lưu THỜI GIAN TỪNG RUN, BuildComparison_30min.csv lưu bảng 30 phút."
        StatusLbl.Text="LOG EXPORTED. Upload DungeonClearTimes.csv + BuildComparison_30min.csv để so sánh build."
        if typeof(setclipboard)=="function" then pcall(setclipboard,a.EventFile.."\n"..a.ReportFile.."\n"..a.DungeonCSV.."\n"..a.WindowCSV) end
    end,Color3.fromRGB(48,109,89))
    local function showBuildStats()
        local a=Runtime.Analytics
        a.Sample()
        local x=a.WindowSnapshot("DISPLAY")
        if not x then return end
        local c=x.Counters
        local live=x.DungeonLive
        local core=x.Balance and x.Balance.Cores
        local coreText=core and core.GainedObserved~=nil
            and tostring(math.floor(core.GainedObserved+0.5)) or "N/A"
        local avg=x.AvgClearSeconds and string.format("%.1fs",x.AvgClearSeconds) or "N/A"
        local best=x.FastestClearSeconds and string.format("%.1fs",x.FastestClearSeconds) or "N/A"
        local running=live and string.format("Đang chạy %s Diff%s, Room%s, %.1fs (%s)",
            tostring(live.World),tostring(live.Diff),tostring(live.Room),live.ElapsedSeconds,
            live.FullRunTiming and "tính từ Room1" or "vào giữa run") or "Hiện không ở Dungeon"
        local worldDiff=live and (tostring(live.World).."/Diff"..tostring(live.Diff))
            or tostring(x.DungeonWorldDiff)
        reportLabel.Text=string.format(
            "BUILD: %s | %.1f/30 phút | %s\nRUN CLEAR ĐỦ THỜI GIAN: %d | TB %s | Nhanh nhất %s | Thành công ghi nhận %d\n%s\nChết %d | HP mất %.0f | Né %d | Room cleared %d | Cores +%s | Fly skip %d",
            x.Build,x.ElapsedSeconds/60,worldDiff,
            x.DungeonFullClears,avg,best,x.DungeonSuccessObserved,
            running,c.CharacterDeaths,x.HPDecreaseObserved,c.DodgeStarts,c.RoomClears,
            coreText,c.FlyUnsafeSkips)
    end
    compactButton(utilityTab,"SHOW 30-MIN WORLD/DIFF CLEAR TIMES",showBuildStats)
    compactButton(utilityTab,"SHOW LAST FINISHED BUILD TEST",function()
        local a=Runtime.Analytics
        local finished=a.CompletedWindows[#a.CompletedWindows]
        if not finished then
            reportLabel.Text="Chưa có block 30 phút hoàn thành. Số lần clear và thời gian vẫn đang ghi vào DungeonClearTimes.csv."
            return
        end
        local c=finished.Counters
        reportLabel.Text=string.format(
            "%s | %s | %s | %.1f phút\nDungeon clear %d | TB %s | Nhanh nhất %s | Chết %d | HP mất %.0f | Dodge %d",
            finished.Build,finished.Status,tostring(finished.DungeonWorldDiff),
            finished.ElapsedSeconds/60,finished.DungeonFullClears or 0,
            finished.AvgClearSeconds and string.format("%.1fs",finished.AvgClearSeconds) or "N/A",
            finished.FastestClearSeconds and string.format("%.1fs",finished.FastestClearSeconds) or "N/A",
            c.CharacterDeaths,finished.HPDecreaseObserved,c.DodgeStarts)
    end)
    -- Explicit per-difficulty stats: mixed build windows are broken down by World/Diff.
    compactButton(utilityTab,"SHOW WORLD/DIFF BREAKDOWN",function()
        local s=Runtime.Analytics.RunSummaryForCurrentWindow()
        local lines={}
        for key,g in pairs(s.ByWorldDiff or {}) do
            lines[#lines+1]=string.format("%s: %d clear (đủ giờ %d), TB %s, best %s",
                key,g.Success,g.FullTimed,
                g.AverageClearSeconds and (g.AverageClearSeconds.."s") or "N/A",
                g.FastestClearSeconds and (g.FastestClearSeconds.."s") or "N/A")
        end
        table.sort(lines)
        reportLabel.Text=#lines>0 and table.concat(lines,"\n")
            or "Chưa có clear xác nhận. Đang đo theo WorldId/DiffLevel thật từ server."
    end)
    showBuildStats()
    Runtime.LegacyAnalyticsUIEnd=uiOrder
    -- v4.9.21 Ultra Low: client cosmetics only; never destroy game objects.
    do
        local G={enabled=false,changed=setmetatable({},{__mode="k"}),queue={},busy=false}
        local function protected(obj)
            local n=obj
            local char=LocalPlayer.Character
            while n do
                if n==char or n.Name=="RedShow" or n.Name=="Hitbox" or n.Name=="GameRoundCfg" then
                    return true
                end
                if n:IsA("Model") and CollectionService:HasTag(n,"EnemyNpc") then
                    -- Keep enemy meshes and visible target markers; suppress only their FX.
                    return obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture")
                end
                if n==Workspace or n==Lighting or n==SoundService then break end
                n=n.Parent
            end
            return false
        end
        local function modify(obj,prop,value)
            local ok,old=pcall(function() return obj[prop] end)
            if not ok or old==value then return end
            local saved=G.changed[obj]
            if not saved then saved={};G.changed[obj]=saved end
            if saved[prop]==nil then saved[prop]=old end
            pcall(function() obj[prop]=value end)
        end
        local function process(obj)
            if not (G.enabled and obj and obj.Parent) then return end
            if protected(obj) then return end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                modify(obj,"Enabled",false)
            elseif obj:IsA("PostEffect") then
                modify(obj,"Enabled",false)
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                modify(obj,"Enabled",false)
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                modify(obj,"Transparency",1)
            elseif obj:IsA("Sound") then
                modify(obj,"Volume",0)
            elseif obj:IsA("MeshPart") then
                -- TextureID is visual only. DO NOT change Material, which could
                -- also change physics friction/elasticity when custom props absent.
                modify(obj,"TextureID","")
            elseif obj:IsA("SpecialMesh") then
                modify(obj,"TextureId","")
            end
        end
        local function sweepContainer(root)
            for _,obj in ipairs(root:GetDescendants()) do
                if not (Runtime.Alive and G.enabled) then return end
                process(obj)
                G.busy=G.busy+1
                if G.busy%140==0 then task.wait() end
            end
        end
        local function restore()
            G.enabled=false
            G.queue={}
            for obj,properties in pairs(G.changed) do
                if obj and obj.Parent then
                    for prop,old in pairs(properties) do
                        pcall(function() obj[prop]=old end)
                    end
                end
                G.changed[obj]=nil
            end
        end
        Runtime.RestoreUltraLowGraphics=restore
        function Runtime.ApplyUltraLowGraphics(on)
            if not Runtime.Alive then return end
            on=(on==true)
            if not on then restore(); return end
            if G.enabled then return end
            G.enabled=true
            modify(Lighting,"GlobalShadows",false)
            task.spawn(function()
                sweepContainer(Lighting)
                sweepContainer(SoundService)
                sweepContainer(Workspace)
                Runtime.Log("ULTRA_LOW applied cosmetics only; account="..tostring(LocalPlayer.UserId))
            end)
        end
        local function onAdded(obj)
            if G.enabled and #G.queue<25000 then G.queue[#G.queue+1]=obj end
        end
        table.insert(Runtime.Connections,Workspace.DescendantAdded:Connect(onAdded))
        table.insert(Runtime.Connections,Lighting.DescendantAdded:Connect(onAdded))
        table.insert(Runtime.Connections,SoundService.DescendantAdded:Connect(onAdded))
        task.spawn(function()
            while Runtime.Alive do
                if G.enabled and #G.queue>0 then
                    local queue=G.queue
                    G.queue={}
                    for i,obj in ipairs(queue) do
                        if not (Runtime.Alive and G.enabled) then break end
                        process(obj)
                        if i%140==0 then task.wait() end
                    end
                end
                task.wait(.15)
            end
        end)
        Runtime.ToggleGuards.UltraLowGraphics=function(enabled)
            Runtime.ApplyUltraLowGraphics(enabled)
            local ok,err=pcall(function()
                if typeof(isfolder)=="function" and not isfolder(ConfigFolder) then
                    makefolder(ConfigFolder)
                end
                if typeof(writefile)=="function" then
                    writefile(Config.UltraLowAccountFile,HttpService:JSONEncode({Enabled=enabled==true}))
                end
            end)
            if not ok then Runtime.Log("ULTRA_LOW_ACCOUNT_SAVE_ERROR "..tostring(err)) end
            return true
        end
        addToggle("ULTRA LOW GRAPHICS (CLONE ONLY, default OFF)","UltraLowGraphics")
        if Config.UltraLowGraphics then Runtime.ApplyUltraLowGraphics(true) end
    end
    compactButton(utilityTab,"B -- TAT AUTO FARM + RETURN LOBBY",function()
        Runtime.BReturnLobby()
    end,Color3.fromRGB(110,65,76))
    -- Race Roll belongs in the new Spin tab; all Utilities sale buttons below remain in Utilities.
    local spinTab=Runtime.Tabs.Spin
    Scroll=spinTab
    addSectionHeader("SPIN: RACE + HONOR")
    local utilLabel=compactLabel(spinTab,"Race Roll / Honor Spin",30)
    local raceBusy=false
    local raceLastAt=0
    local function rollRace(slot,arg)
        if not Runtime.Alive or raceBusy then return end
        if os.clock()-raceLastAt<1.0 then
            utilLabel.Text="Race Roll: doi 1s giua hai lan bam."
            return
        end
        raceBusy=true
        local ok,err=pcall(function()
            local raceRoot=ReplicatedStorage:FindFirstChild("Framework")
            local gameplay=raceRoot and raceRoot:FindFirstChild("Gameplay")
            local system=gameplay and gameplay:FindFirstChild("RaceSystem")
            local raceRE=system and system:FindFirstChild("RaceRE")
            assert(raceRE and raceRE:IsA("RemoteEvent"),"Khong tim thay RaceRE")
            raceRE:FireServer("Rolling",arg)
            raceLastAt=os.clock()
            Runtime.Log("UTIL_RACE_ROLL_SENT slot="..slot.." args=Rolling,"..arg.."; result unverified")
            StatusLbl.Text="Race Roll slot "..slot..": da gui mot yeu cau; kiem tra game."
            utilLabel.Text="Race "..slot.." | Rolling, "..arg.." | server result unverified"
        end)
        raceBusy=false
        if not ok then error(err,0) end
    end
    local race1Button=compactButton(spinTab,"RACE ROLL — SLOT 1",function()
        rollRace("1","Free_1")
    end,Color3.fromRGB(51,115,117))
    local race2Button=compactButton(spinTab,"RACE ROLL — SLOT 2",function()
        rollRace("2","1")
    end,Color3.fromRGB(59,98,146))
    -- Config is historically a shared file. Hotkeys have a DIFFERENT per-user file.
    local hotkeyPath=ConfigFolder.."/spin_hotkeys_U"..tostring(LocalPlayer.UserId)..".json"
    local hotkeys={Slot1="",Slot2=""}
    if typeof(readfile)=="function" then
        local ok,data=pcall(function()
            if typeof(isfile)=="function" and not isfile(hotkeyPath) then return nil end
            return HttpService:JSONDecode(readfile(hotkeyPath))
        end)
        if ok and type(data)=="table" and data.UserId==LocalPlayer.UserId then
            for _,key in ipairs({"Slot1","Slot2"}) do
                if type(data[key])=="string" then hotkeys[key]=data[key] end
            end
        end
    end
    local function normalizeHotkey(raw)
        local key=tostring(raw or ""):upper():gsub("%s+","")
        if key=="" then return "" end
        -- 0 is the existing Honor Spin hotkey, not the letter O.
        if key=="0" or key=="ZERO" or key=="KEYPADZERO" then return nil end
        if key:match("^[A-Z]$") or key:match("^[1-9]$") then return key end
        return nil
    end
    for _,slot in ipairs({"Slot1","Slot2"}) do
        hotkeys[slot]=normalizeHotkey(hotkeys[slot]) or ""
    end
    if hotkeys.Slot1~="" and hotkeys.Slot1==hotkeys.Slot2 then hotkeys.Slot2="" end
    local hotkeyInputs={}
    local function persistHotkeys()
        if typeof(writefile)~="function" then
            utilLabel.Text="HOTKEY: không có writefile, chỉ lưu trong phiên"
            return false
        end
        local ok,err=pcall(function()
            if typeof(makefolder)=="function" and (typeof(isfolder)~="function" or not isfolder(ConfigFolder)) then
                makefolder(ConfigFolder)
            end
            writefile(hotkeyPath,HttpService:JSONEncode({UserId=LocalPlayer.UserId,
                Slot1=hotkeys.Slot1,Slot2=hotkeys.Slot2,Version=1}))
        end)
        if not ok then Runtime.Log("SPIN_HOTKEY_SAVE_ERROR "..tostring(err)) end
        return ok
    end
    local function attachHotkeyEditor(btn,slot)
        local container=Instance.new("Frame",spinTab)
        container.Name="RaceHotkey"..slot
        container.LayoutOrder=btn.LayoutOrder
        container.Size=UDim2.new(.94,0,0,40)
        container.BackgroundTransparency=1
        btn.Parent=container
        btn.LayoutOrder=1
        btn.Position=UDim2.new(0,0,0,0)
        btn.Size=UDim2.new(.70,0,1,0)
        local input=Instance.new("TextBox",container)
        input.Name="HotkeyInput"..slot
        input.Position=UDim2.new(.72,0,0,0)
        input.Size=UDim2.new(.19,0,1,0)
        input.BackgroundColor3=Color3.fromRGB(39,61,92)
        input.TextColor3=Color3.fromRGB(255,255,255)
        input.Font=Enum.Font.GothamBold
        input.TextSize=16
        input.ClearTextOnFocus=false
        input.PlaceholderText="PHÍM"
        input.Text=hotkeys[slot]
        hotkeyInputs[slot]=input
        local clear=Instance.new("TextButton",container)
        clear.Name="ClearHotkey"..slot
        clear.Position=UDim2.new(.92,0,0,0)
        clear.Size=UDim2.new(.08,0,1,0)
        clear.Text="×"
        clear.TextSize=18
        clear.Font=Enum.Font.GothamBold
        clear.TextColor3=Color3.new(1,1,1)
        clear.BackgroundColor3=Color3.fromRGB(100,65,73)
        local function setKey(raw)
            local key=normalizeHotkey(raw)
            if key==nil then
                utilLabel.Text="HOTKEY: dùng A-Z hoặc 1-9; 0 dành cho Honor"
                input.Text=hotkeys[slot]
                return
            end
            local other=slot=="Slot1" and "Slot2" or "Slot1"
            if key~="" and key==hotkeys[other] then
                utilLabel.Text="HOTKEY "..key.." đã dùng ở "..other
                input.Text=hotkeys[slot]
                return
            end
            hotkeys[slot]=key
            input.Text=key
            persistHotkeys()
            utilLabel.Text=key=="" and (slot..": đã bỏ gán") or (slot..": hotkey "..key)
        end
        input.FocusLost:Connect(function() if Runtime.Alive then setKey(input.Text) end end)
        clear.MouseButton1Click:Connect(function() if Runtime.Alive then setKey("") end end)
    end
    attachHotkeyEditor(race1Button,"Slot1")
    attachHotkeyEditor(race2Button,"Slot2")
    -- One input handler, two original callbacks; never execute on text editing.
    local pressed={}
    table.insert(Runtime.Connections,UserInputService.InputBegan:Connect(function(input,processed)
        if processed or not Runtime.Alive or UserInputService:GetFocusedTextBox() then return end
        if input.UserInputType~=Enum.UserInputType.Keyboard then return end
        local code=input.KeyCode.Name:upper()
        if pressed[code] then return end
        local slot=nil
        if code~="" and code==hotkeys.Slot1 then slot="Slot1"
        elseif code~="" and code==hotkeys.Slot2 then slot="Slot2" end
        if not slot then return end
        pressed[code]=true
        local ok,err=pcall(function()
            if slot=="Slot1" then rollRace("1","Free_1")
            else rollRace("2","1") end
        end)
        if not ok then Runtime.Log("SPIN_HOTKEY_ROLL_ERROR "..tostring(err)) end
    end))
    table.insert(Runtime.Connections,UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Keyboard then pressed[input.KeyCode.Name:upper()]=nil end
    end))

    -- HONOR SPIN: one user action -> exactly one observed request.
    local honorLastAt=-1000
    local function honorSpin10()
        assert(Runtime.Alive,"Script đã dừng")
        assert(os.clock()-honorLastAt>=1,"Honor Spin: đợi ít nhất 1 giây")
        local fw=ReplicatedStorage:FindFirstChild("Framework")
        local feat=fw and fw:FindFirstChild("Features")
        local system=feat and feat:FindFirstChild("HonorSystem")
        local remote=system and system:FindFirstChild("RemoteEvent")
        assert(remote and remote:IsA("RemoteEvent"),"Không tìm thấy HonorSystem.RemoteEvent")
        honorLastAt=os.clock()
        remote:FireServer("HonorSpin",10)
        Runtime.Log("HONOR_SPIN_SENT HonorSpin,10 (server result not verified)")
        utilLabel.Text="Honor Spin: đã gửi 10; kết quả do server quyết định"
    end
    compactButton(spinTab,"HONOR SPIN x10 [0]",honorSpin10,Color3.fromRGB(104,73,128))
    table.insert(Runtime.Connections,UserInputService.InputBegan:Connect(function(input,processed)
        if processed or not Runtime.Alive or UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode==Enum.KeyCode.Zero or input.KeyCode==Enum.KeyCode.KeypadZero then
            local ok,err=pcall(honorSpin10)
            if not ok then Runtime.Log("HONOR_SPIN_ERROR "..tostring(err)) end
        end
    end))

    -- Wheel of Luck: independent single worker. Server may accept only in Lobby.
    -- A proven return from a Dungeon while AutoFarm ON gets ONE immediate attempt
    -- even if fewer than 1215 seconds since last request; no spin spam in Lobby.
    ;(function()
        local wheelPath=ConfigFolder.."/wheel_of_luck_U"..tostring(LocalPlayer.UserId)..".json"
        local lastSent=0
        local pendingReturn=false
        local lastDungeonAt=0
        if typeof(readfile)=="function" then
            pcall(function()
                if typeof(isfile)~="function" or isfile(wheelPath) then
                    local raw=HttpService:JSONDecode(readfile(wheelPath))
                    if type(raw)=="table" and raw.UserId==LocalPlayer.UserId then
                        lastSent=math.max(0,tonumber(raw.LastSent) or 0)
                        lastDungeonAt=math.max(0,tonumber(raw.LastDungeonAt) or 0)
                        -- Persistent marker survives map/server teleport and reinject.
                        pendingReturn=(raw.PendingLobbyReturn==true)
                            and (os.time()-lastDungeonAt<7200)
                    end
                end
            end)
        end
        local function persist()
            if typeof(writefile)~="function" then return false end
            return pcall(function()
                if typeof(makefolder)=="function" and
                    (typeof(isfolder)~="function" or not isfolder(ConfigFolder)) then makefolder(ConfigFolder) end
                writefile(wheelPath,HttpService:JSONEncode({
                    UserId=LocalPlayer.UserId,LastSent=lastSent,
                    PendingLobbyReturn=pendingReturn,LastDungeonAt=lastDungeonAt}))
            end)
        end
        local wheelLabel=compactLabel(spinTab,"Wheel of Luck: OFF",34)
        local wheelButton
        local busy=false
        local lastAttemptClock=-9999
        local function refresh()
            if not Config.WheelOfLuck then
                wheelButton.Text="WHEEL OF LUCK: OFF"
                wheelLabel.Text="Auto free spin OFF | Lobby return = no attempt"
                return
            end
            wheelButton.Text="WHEEL OF LUCK: ON"
            local remaining=math.max(0,1215-(os.time()-lastSent))
            local mins=math.floor(remaining/60)
            local sec=remaining%60
            wheelLabel.Text=string.format("Wheel %02d:%02d | +1 try on AutoFarm Lobby return",mins,sec)
        end
        local function trySpin(reason,ignoreTimer)
            if not Runtime.Alive or not Config.WheelOfLuck or busy then return false end
            -- Lobby UI/character must be fully ready; remember return event meanwhile.
            if not GamePlaceUtil:IsMain() or isTransitioning() or not lobbyCharacterReady() then return false end
            if os.clock()-lastAttemptClock<3 then return false end -- prevent two paths racing
            if not ignoreTimer and os.time()-lastSent<1215 then return false end
            local feature=fwFolder:FindFirstChild("Features")
            local season=feature and feature:FindFirstChild("SeasonSystem")
            local util=season and season:FindFirstChild("SeasonUtil")
            local remote=util and util:FindFirstChild("RemoteEvent")
            if not (remote and remote:IsA("RemoteEvent")) then
                if os.clock()-(Runtime.WheelMissingLogAt or -1000)>30 then
                    Runtime.WheelMissingLogAt=os.clock()
                    Runtime.Log("WHEEL_MISSING_REMOTE "..tostring(reason))
                end
                return false
            end
            busy=true
            lastAttemptClock=os.clock()
            local ok,err=pcall(function() remote:FireServer("TrySeasonLottery",1) end)
            -- Record ATTEMPT even on client-side error; never blindly retry/spam.
            lastSent=os.time()
            persist()
            if ok then
                Runtime.Log("WHEEL_SENT_UNVERIFIED reason="..reason.." LastAttempt="..lastSent)
            else
                Runtime.Log("WHEEL_SEND_FAILED_NO_AUTO_RETRY "..tostring(err))
            end
            busy=false
            refresh()
            return true -- exactly one attempted request on a Lobby return
        end
        wheelButton=compactButton(spinTab,"WHEEL OF LUCK: OFF",function()
            Config.WheelOfLuck=not Config.WheelOfLuck
            saveConfig()
            refresh()
            if Config.WheelOfLuck and GamePlaceUtil:IsMain() then
                -- First enable can send when 20m15s elapsed; never bypass server interval here.
                trySpin("EnabledTimer",false)
            end
        end,Color3.fromRGB(56,119,79))
        Runtime.WheelOfLuckTry=trySpin
        refresh()
        task.spawn(function()
            -- Only a VERIFIED transition from non-lobby to Lobby qualifies.
            local sawActiveDungeon=false
            local wasLobby=GamePlaceUtil:IsMain()==true
            local pendingLobbyTry=false
            while Runtime.Alive do
                task.wait(.75)
                if not Runtime.Alive then break end
                local lobby=GamePlaceUtil:IsMain()
                if not lobby and not isTransitioning() then
                    pendingLobbyTry=false
                    local gameCfg=ReplicatedStorage:FindFirstChild("GameRoundCfg")
                    if gameCfg and gameCfg:GetAttribute("WorldId") then
                        if not sawActiveDungeon and Config.AutoFarm and Config.WheelOfLuck then
                            pendingReturn=true
                            lastDungeonAt=os.time()
                            persist()
                        end
                        sawActiveDungeon=true
                    end
                elseif lobby and not isTransitioning() then
                    if (sawActiveDungeon and not wasLobby) or pendingReturn then
                        pendingLobbyTry=Config.AutoFarm and Config.WheelOfLuck
                        sawActiveDungeon=false
                        if not pendingLobbyTry then
                            pendingReturn=false
                            persist()
                        end
                    end
                    if pendingLobbyTry then
                        if not Config.AutoFarm or not Config.WheelOfLuck then
                            pendingLobbyTry=false
                            pendingReturn=false
                            persist()
                        elseif trySpin("AutoFarmLobbyReturn",true) then
                            pendingLobbyTry=false -- exactly ONE request on this return
                            pendingReturn=false -- no duplication after reinject
                            persist()
                        end
                    end
                    if Config.WheelOfLuck and not pendingLobbyTry then
                        trySpin("PeriodicLobby",false)
                    end
                end
                wasLobby=lobby
                refresh()
            end
        end)
    end)()
    Runtime.InitHatchUI=function() -- isolated UI scope keeps local budget below Luau limits
    addSectionHeader("HATCH EGGS — TỰ NHẬN PET VÀ ẤP BÙ 3 Ô")
    local hatchInfo=compactLabel(spinTab,"QUÉT TRỨNG: xem ô trống / đang ấp / chờ nhận Pet.",76)
    local hatchDetail=compactLabel(spinTab,"Auto Hatch: CLAIM Pet đã ấp xong → xác nhận ô trống → START Egg mới.",100)
    local hatchBusy=false
    local hatchLoop=false -- intentionally OFF at every reinjection
    local hatchLastRequestAt=-1000
    local hatchUncertainSlot=nil
    local hatchUncertainAction=nil
    local function getHatchData()
        local ok,v=pcall(function() return DataUtil:GetValue(LocalPlayer,{"PetHatch"}) end)
        if not ok or type(v)~="table" then return nil,"Không đọc được PetHatch" end
        if type(v.Egg)~="table" or type(v.Slots)~="table" then
            return nil,"Thiếu PetHatch.Egg hoặc PetHatch.Slots"
        end
        local n=tonumber(v.SlotCount)
        if not n or n<1 or n>3 or n%1~=0 then return nil,"SlotCount không hợp lệ (1–3)" end
        return v
    end
    local function validEggUid(v)
        return type(v)=="string" and #v>=18 and #v<=128 and v:match("^[%w_%-]+$")~=nil
    end
    local function eggUid(rec,key)
        if type(rec)=="table" then
            for _,f in ipairs({"UID","UUID","Uid","Uuid","EggUID","EggUid","EggUUID","UniqueId","UniqueID"}) do
                if validEggUid(rec[f]) then return rec[f] end
            end
            if validEggUid(key) then return key end
        elseif validEggUid(rec) then return rec end
        return nil
    end
    local function collectEggs(raw)
        local found,seen={},{}
        local function visit(t,depth)
            if depth>3 or type(t)~="table" or seen[t] then return end
            seen[t]=true
            for key,rec in pairs(t) do
                local id=eggUid(rec,key)
                if id and not found[id] then
                    local inUse=type(rec)=="table" and
                        (rec.IsHatching==true or rec.Hatching==true or rec.Incubating==true
                        or rec.IsIncubating==true or (tonumber(rec.StartTime) or 0)>0)
                    if not inUse then found[id]=true end
                elseif type(rec)=="table" then visit(rec,depth+1) end
            end
        end
        visit(raw,1)
        local ids={}
        for uid in pairs(found) do ids[#ids+1]=uid end
        table.sort(ids)
        return ids
    end
    local function slotRecord(slots,i)
        local v=slots[i]
        if v==nil then v=slots[tostring(i)] end
        if v==nil then v=slots["Slot"..i] end
        return v
    end
    local function nowUnix()
        local ok,n=pcall(function() return Workspace:GetServerTimeNow() end)
        if ok and type(n)=="number" and n>1500000000 then return n end
        return os.time()
    end
    -- Only absolute Unix timestamps are compared with wall-clock time.
    -- A field such as 3600 (duration/remaining seconds) is NEVER treated as completed.
    local function normalizeUnix(v)
        local n=tonumber(v)
        if not n then return nil end
        if n>1500000000000 and n<5000000000000 then n=n/1000 end
        if n>1500000000 and n<5000000000 then return n end
        return nil
    end
    local function claimable(rec)
        if type(rec)=="string" then
            local t=rec:lower()
            return t=="ready" or t=="claim" or t=="claimable" or
                t=="completed" or t=="finished" or t=="done"
        end
        if type(rec)=="number" then
            local t=normalizeUnix(rec)
            return t~=nil and t<=nowUnix()
        end
        if type(rec)~="table" then return false end
        for _,field in ipairs({"CanClaim","IsClaimable","Claimable","ClaimReady","IsReady",
            "IsFinished","Finished","IsCompleted","Completed","IsComplete","Complete",
            "HatchCompleted","HatchFinished","ReadyToClaim"}) do
            if rec[field]==true then return true end
        end
        for _,field in ipairs({"State","Status","SlotState","HatchState"}) do
            local st=rec[field]
            if type(st)=="string" then
                st=st:lower()
                if st=="ready" or st=="claim" or st=="claimable"
                    or st=="completed" or st=="finished" or st=="done"
                    or st=="waitingclaim" or st=="canclaim" then return true end
            end
        end
        local occupied=false
        for _,field in ipairs({"EggUID","EggUid","EggUUID","UID","UUID","Uid","Uuid",
            "EggID","EggId","Egg","PetEgg","StartTime","StartTs","StartedAt"}) do
            local v=rec[field]
            if v~=nil and v~=false and v~=0 and v~="" then occupied=true;break end
        end
        if not occupied then return false end
        local finishAt=nil
        for _,field in ipairs({"EndTime","FinishTime","EndTs","FinishTs","CompleteTime",
            "CompleteAt","FinishAt","EndAt","ExpireAt","ReadyAt","ClaimAt",
            "HatchFinishTime","HatchEndTime","HatchEndAt","HatchFinishAt"}) do
            finishAt=normalizeUnix(rec[field])
            if finishAt then break end
        end
        if not finishAt then
            local started=normalizeUnix(rec.StartTime or rec.StartTs or rec.StartedAt)
            local duration=tonumber(rec.Duration or rec.HatchDuration or rec.HatchTime or rec.TotalTime)
            if started and duration and duration>0 and duration<=86400*30 then
                finishAt=started+duration
            end
        end
        return finishAt~=nil and finishAt<=nowUnix()
    end
    local function slotStatus(rec)
        if rec==nil or rec==false or rec==0 or rec=="" then return "FREE" end
        if claimable(rec) then return "READY" end
        local t=type(rec)
        if t=="table" then
            if next(rec)==nil then return "FREE" end
            -- Occupied evidence overrides a stale IsEmpty/Available flag.
            for _,f in ipairs({"EggUID","EggUid","UID","UUID","Uid","Uuid","EggID","EggId",
                "Egg","PetEgg","StartTime","StartTs","EndTime","FinishTime","EndTs","FinishTs",
                "ReadyAt","ExpireAt"}) do
                local v=rec[f]
                if v~=nil and v~=false and v~=0 and v~="" then return "BUSY" end
            end
            if rec.IsHatching==true or rec.Hatching==true or rec.IsBusy==true or rec.Busy==true then return "BUSY" end
            for _,f in ipairs({"State","Status","SlotState","HatchState"}) do
                local st=rec[f]
                if type(st)=="string" then
                    st=st:lower()
                    if st=="free" or st=="empty" or st=="idle" or st=="available" then return "FREE" end
                    if st=="busy" or st=="hatching" or st=="started" or st=="incubating" then return "BUSY" end
                end
            end
            if rec.IsEmpty==true or rec.Empty==true or rec.Available==true then return "FREE" end
            return "UNKNOWN"
        elseif t=="string" then
            local st=rec:lower()
            if st=="free" or st=="empty" or st=="idle" or st=="available" or st=="0" then return "FREE" end
            return "BUSY"
        elseif t=="number" then return rec>0 and "BUSY" or "UNKNOWN"
        elseif t=="boolean" then return rec and "BUSY" or "FREE" end
        return "UNKNOWN"
    end
    local function activeUid(rec)
        return eggUid(rec,nil)
    end
    local function snapshot()
        local raw,reason=getHatchData()
        if not raw then return nil,reason end
        local active,free,ready,unknown,states={}, {}, {}, {}, {}
        for i=1,raw.SlotCount do
            local rec=slotRecord(raw.Slots,i)
            local st=slotStatus(rec)
            states[i]=st
            if st=="FREE" then free[#free+1]=i
            elseif st=="READY" then ready[#ready+1]=i
            elseif st=="UNKNOWN" then unknown[#unknown+1]=i end
            local uid=activeUid(rec)
            if uid then active[uid]=true end
        end
        local ids={}
        for _,uid in ipairs(collectEggs(raw.Egg)) do
            if not active[uid] then ids[#ids+1]=uid end
        end
        local total=0
        for _ in pairs(raw.Egg) do total=total+1 end
        return {Eggs=ids,Free=free,Ready=ready,Unknown=unknown,States=states,
            SlotCount=raw.SlotCount,RawCount=total,RawSlots=raw.Slots}
    end
    local function scan(showLog)
        local s,reason=snapshot()
        if not s then
            hatchInfo.Text="CHƯA ĐỌC ĐƯỢC: "..tostring(reason)
            hatchDetail.Text="Không gửi Remote. Kiểm tra đang ở Lobby."
            return nil
        end
        if hatchUncertainSlot then
            local current=s.States[hatchUncertainSlot]
            local expected=hatchUncertainAction=="CLAIM" and "FREE" or "BUSY"
            if current==expected or (hatchUncertainAction=="START" and current=="READY") then
                hatchUncertainSlot,hatchUncertainAction=nil,nil
            end
        end
        local parts={}
        for i=1,s.SlotCount do
            local st=s.States[i]
            local word=st=="FREE" and "TRỐNG" or st=="READY" and "CHỜ NHẬN PET"
                or st=="BUSY" and "ĐANG ẤP" or "KHÔNG RÕ"
            parts[#parts+1]="Ô "..i..": "..word
        end
        hatchInfo.Text=string.format("%d Egg chưa ấp | %d ô chờ Claim | %d ô trống | %d ô chưa rõ",
            #s.Eggs,#s.Ready,#s.Free,#s.Unknown)
        local note=#s.Unknown>0 and "Có trạng thái chưa rõ: bỏ qua ô đó, không đoán thời gian."
            or (hatchUncertainSlot and "Có lượt trước chưa xác nhận; tạm ngừng gửi tiếp."
            or "Bật AUTO LOOP để nhận Pet khi chín và tự đưa trứng mới vào.")
        hatchDetail.Text=table.concat(parts,"  |  ").."\n"..note
        if showLog then
            Runtime.Log(string.format("HATCH_SCAN eggs=%d ready=%d empty=%d unknown=%d",
                #s.Eggs,#s.Ready,#s.Free,#s.Unknown))
            local raw=DataUtil:GetValue(LocalPlayer,{"PetHatch"}) or {}
            for i=1,s.SlotCount do
                local rec=slotRecord(raw.Slots or {},i)
                local fields={}
                if type(rec)=="table" then
                    for k,v in pairs(rec) do
                        if #fields<24 then
                            local val=type(v)=="number" and ("="..tostring(v))
                                or type(v)=="boolean" and ("="..tostring(v)) or ""
                            fields[#fields+1]=tostring(k)..":"..type(v)..val
                        end
                    end
                end
                Runtime.Log("HATCH_SLOT_SCHEMA "..i.." state="..s.States[i].." "..table.concat(fields,","))
            end
        end
        return s
    end
    local function hatchRemote()
        local fw=ReplicatedStorage:FindFirstChild("Framework")
        local gp=fw and fw:FindFirstChild("Gameplay")
        local ps=gp and gp:FindFirstChild("PetsSystem")
        local util=ps and ps:FindFirstChild("PetsHatchUtil")
        local remote=util and util:FindFirstChild("RemoteEvent")
        assert(remote and remote:IsA("RemoteEvent"),"Không thấy PetsHatchUtil.RemoteEvent")
        return remote
    end
    local function validLobby()
        return Runtime.Alive and GamePlaceUtil:IsMain() and not isTransitioning()
            and not Runtime.ForgeBusy and not Runtime.BatchActive
            and not Runtime.EntryBusy and not Runtime.ShopBusy and not Runtime.RouteBusy
    end
    local function verifySlot(slot,wanted)
        for _=1,20 do
            if not Runtime.Alive or isTransitioning() then return false end
            task.wait(.20)
            local state=snapshot()
            if state and state.States[slot]==wanted then return true end
        end
        return false
    end
    local function sendRequest(remote,action,slot,uid)
        -- Server owns both completion and inventory; local send != success.
        if os.clock()-hatchLastRequestAt<.5 then task.wait(.6) end
        assert(validLobby(),"Đã rời Lobby hoặc Forge/Entry đang hoạt động")
        hatchLastRequestAt=os.clock()
        if action=="Claim" then remote:FireServer("Claim",slot)
        else remote:FireServer("StartHatch",slot,uid) end
        hatchUncertainSlot,hatchUncertainAction=slot,action=="Claim" and "CLAIM" or "START"
        local expected=action=="Claim" and "FREE" or "BUSY"
        if verifySlot(slot,expected) then
            hatchUncertainSlot,hatchUncertainAction=nil,nil
            return true
        end
        -- If StartHatch has already finished extraordinarily fast, READY also confirms it.
        if action=="StartHatch" then
            local s=snapshot()
            if s and s.States[slot]=="READY" then
                hatchUncertainSlot,hatchUncertainAction=nil,nil
                return true
            end
        end
        return false
    end
    -- A single pass: Claim verified-finished slots FIRST, then refill verified-empty slots.
    local function runOneCycle()
        assert(validLobby(),"Đang ở Dungeon hoặc có tác vụ Lobby khác; chờ về Lobby")
        assert(not hatchUncertainSlot,"Lệnh Hatch/Claim trước chưa được xác nhận; bấm QUÉT kiểm tra")
        local s=assert(scan(false),"Không đọc được Egg/Slots")
        local remote=hatchRemote()
        local claims,starts=0,0
        for _,slot in ipairs(s.Ready) do
            if not validLobby() then break end
            local before=assert(snapshot(),"Mất dữ liệu ô ấp")
            if before.States[slot]=="READY" then
                hatchInfo.Text="Đã ấp xong ô "..slot..": gửi Claim nhận Pet..."
                Runtime.Log("HATCH_CLAIM_SENT slot="..slot)
                if not sendRequest(remote,"Claim",slot) then
                    error("Claim ô "..slot.." chưa được xác nhận TRỐNG; dừng để không gửi trùng")
                end
                claims=claims+1
                Runtime.Log("HATCH_CLAIM_CONFIRMED slot="..slot)
            end
        end
        s=assert(snapshot(),"Mất dữ liệu sau Claim")
        if #s.Eggs>0 then
            for _,slot in ipairs(s.Free) do
                if not validLobby() then break end
                local fresh=assert(snapshot(),"Mất dữ liệu trước StartHatch")
                if fresh.States[slot]=="FREE" and #fresh.Eggs>0 then
                    local uid=fresh.Eggs[1]
                    hatchInfo.Text="Ô "..slot.." đã trống: gửi StartHatch..."
                    Runtime.Log("HATCH_START_SENT slot="..slot.." uid="..uid)
                    if not sendRequest(remote,"StartHatch",slot,uid) then
                        error("StartHatch ô "..slot.." chưa xác nhận ĐANG ẤP; dừng để tránh lặp")
                    end
                    starts=starts+1
                    Runtime.Log("HATCH_START_CONFIRMED slot="..slot)
                end
            end
        end
        scan(false)
        if claims+starts>0 then
            hatchInfo.Text="HOÀN TẤT: nhận "..claims.." Pet, bắt đầu ấp "..starts.." Egg mới."
        end
        return claims,starts
    end
    local function performCycle()
        if hatchBusy then return false end
        if not validLobby() or Runtime.Owner then return false end
        hatchBusy=true
        local token=Runtime.Acquire("PET_HATCH")
        if not token then hatchBusy=false;return false end
        local ok,err=pcall(runOneCycle)
        Runtime.Release(token)
        hatchBusy=false
        if not ok then
            local msg=tostring(err):gsub("^.-:%d+:%s*","")
            hatchInfo.Text="AUTO HATCH TẠM DỪNG: "..msg:sub(1,160)
            Runtime.Log("HATCH_CYCLE_STOP "..tostring(err))
            -- Persist stop when completion/response is ambiguous. Avoid repeated sends.
            if hatchUncertainSlot then hatchLoop=false end
        end
        return ok
    end
    compactButton(spinTab,"1. QUÉT TRỨNG / XEM 3 Ô ẤP (KHÔNG GỬI)",function()
        local ok,err=pcall(function() scan(true) end)
        if not ok then hatchInfo.Text="Không thể quét trứng: xem log."; Runtime.Log(tostring(err)) end
    end,Color3.fromRGB(51,90,119))
    compactButton(spinTab,"2. NHẬN PET ĐÃ XONG + ẤP BÙ (CHẠY 1 LẦN)",function()
        if hatchBusy or Runtime.Owner then hatchInfo.Text="Đang có tác vụ khác; thử lại.";return end
        task.spawn(performCycle)
    end,Color3.fromRGB(65,124,77))
    local loopButton
    loopButton=compactButton(spinTab,"3. AUTO HATCH LOOP: OFF",function()
        hatchLoop=not hatchLoop
        loopButton.Text=hatchLoop and "3. AUTO HATCH LOOP: ON (BẤM ĐỂ DỪNG)" or "3. AUTO HATCH LOOP: OFF"
        if not hatchLoop then
            hatchInfo.Text="Đã tắt Auto Hatch Loop; lượt đang xác nhận sẽ kết thúc an toàn."
            return
        end
        hatchInfo.Text="Đã bật Auto Hatch Loop: theo dõi ô mỗi 10 giây khi ở Lobby."
        task.spawn(function()
            while hatchLoop and Runtime.Alive do
                if validLobby() and not Runtime.Owner and not hatchBusy then
                    performCycle()
                end
                for _=1,20 do
                    if not hatchLoop or not Runtime.Alive then break end
                    task.wait(.5)
                end
            end
            hatchLoop=false
            if loopButton and loopButton.Parent then loopButton.Text="3. AUTO HATCH LOOP: OFF" end
        end)
    end,Color3.fromRGB(53,102,128))
    local manualBtn=compactButton(spinTab,"NÂNG CAO: HIỆN GỬI UID / CLAIM THỦ CÔNG",function() end,
        Color3.fromRGB(75,69,90))
    local hatchNum=compactTextBox(spinTab,"Ô ấp (1-3)","1")
    local hatchUid=compactTextBox(spinTab,"UID Egg (chỉ StartHatch)","")
    local sendManual=compactButton(spinTab,"GỬI START HATCH THEO UID",function()
        if hatchBusy or hatchLoop or Runtime.Owner then hatchInfo.Text="Tắt Auto Loop và tác vụ khác trước.";return end
        local slot=tonumber(hatchNum.Text)
        local uid=tostring(hatchUid.Text or ""):match("^%s*(.-)%s*$")
        if not(slot and slot%1==0 and slot>=1 and slot<=3) then hatchInfo.Text="Ô phải là 1, 2 hoặc 3.";return end
        if not validEggUid(uid) then hatchInfo.Text="UID Egg chưa hợp lệ.";return end
        local ok,err=pcall(function()
            assert(validLobby(),"Chỉ gửi ở Lobby khi không có Forge/Entry")
            assert(not hatchUncertainSlot,"Lượt trước chưa xác nhận")
            local s=assert(snapshot(),"Không đọc được Slots")
            assert(s.States[slot]=="FREE","Ô không trống hoặc chưa rõ trạng thái")
            assert(sendRequest(hatchRemote(),"StartHatch",slot,uid),"Chưa xác nhận ô đã bắt đầu ấp")
            hatchInfo.Text="Đã xác nhận ô "..slot.." bắt đầu ấp."
        end)
        if not ok then hatchInfo.Text="Không thể StartHatch: "..tostring(err):gsub("^.-:%d+:%s*",""):sub(1,110) end
    end,Color3.fromRGB(95,90,65))
    local claimManual=compactButton(spinTab,"CLAIM Ô NÀY (CHỈ KHI ĐÃ XONG)",function()
        if hatchBusy or hatchLoop or Runtime.Owner then hatchInfo.Text="Tắt Auto Loop và tác vụ khác trước.";return end
        local slot=tonumber(hatchNum.Text)
        if not(slot and slot%1==0 and slot>=1 and slot<=3) then hatchInfo.Text="Ô phải là 1, 2 hoặc 3.";return end
        local ok,err=pcall(function()
            assert(validLobby(),"Chỉ dùng ở Lobby")
            assert(not hatchUncertainSlot,"Lượt trước chưa xác nhận")
            local s=assert(snapshot(),"Không đọc được Slots")
            assert(s.States[slot]=="READY","Ô này chưa xác nhận ấp xong; không Claim")
            assert(sendRequest(hatchRemote(),"Claim",slot),"Claim chưa xác nhận ô trống")
            hatchInfo.Text="Nhận Pet ô "..slot.." thành công; có thể ấp trứng tiếp."
        end)
        if not ok then hatchInfo.Text="Chưa thể Claim: "..tostring(err):gsub("^.-:%d+:%s*",""):sub(1,120) end
    end,Color3.fromRGB(95,90,65))
    hatchNum.Parent.Visible=false
    hatchUid.Parent.Visible=false
    sendManual.Visible=false
    claimManual.Visible=false
    manualBtn.MouseButton1Click:Connect(function()
        local expanded=not sendManual.Visible
        hatchNum.Parent.Visible=expanded
        hatchUid.Parent.Visible=expanded
        sendManual.Visible=expanded
        claimManual.Visible=expanded
        manualBtn.Text=expanded and "NÂNG CAO: ẨN THỦ CÔNG" or "NÂNG CAO: HIỆN GỬI UID / CLAIM THỦ CÔNG"
    end)
    end -- Hatch UI setup
    -- v4.9.48: Auto Hatch experimental UI/worker parked, source remains for recovery.
    -- Do NOT call Runtime.InitHatchUI(): its hidden loop has no reason to run.
    Scroll=Runtime.Tabs.Utilities -- Restore legacy utilities page after Spin controls.
    -- v4.9.38 Clone Forge: strict sequential 3/6/10 recipe rotation.
    -- Armor server subtype is probabilistic; not guaranteed Helmet/Breastplate.
    do
        local clone={Running=false,Stop=false,Completed=0,Turns=0}
        Runtime.CloneForge=clone
        local cloneLabel=compactLabel(utilityTab,
            "CLONE FORGE: READY | 1 TURN = WEAPON 3 / HELMET-TARGET 6 / ARMOR-TARGET 10 (RNG).",47)
        cloneLabel.LayoutOrder=-90 -- visible near top of Utilities
        local startButton,stopButton
        local plan={{Name="Weapon",Count=3,Type="Weapon"},
            {Name="Helmet-target",Count=6,Type="Armor"},
            {Name="Armor-target",Count=10,Type="Armor"}}
        local function recipeFor(n)
            local bag=DataUtil:GetValue(LocalPlayer,{"Ores"})
            assert(type(bag)=="table","Không thể đọc Ore Bag; không bắt đầu Forge")
            local available,entries=0,{}
            for id,qty in pairs(bag) do
                local count=tonumber(qty)
                if type(id)=="string" and count and count>=1 and count%1==0 then
                    available=available+count
                    local def=ForgeUtil:GetDef(id)
                    local level=def and getOreLevel(id,def)
                    if def and level then
                        entries[#entries+1]={ID=id,Count=count,Level=level,
                            Rarity=tonumber(def.Rarity) or 0}
                    end
                end
            end
            if available<n then return nil,available end
            table.sort(entries,function(a,b)
                if a.Level~=b.Level then return a.Level>b.Level end
                if a.Rarity~=b.Rarity then return a.Rarity>b.Rarity end
                return a.ID<b.ID
            end)
            local recipe,needed,types={},n,0
            for _,item in ipairs(entries) do
                if needed<=0 or types>=4 then break end
                local take=math.min(needed,item.Count)
                if take>0 then recipe[item.ID]=take;needed=needed-take;types=types+1 end
            end
            if needed>0 then return nil,available end -- max 4 Ore types per craft
            return recipe,available
        end
        local function setStatus(msg)
            cloneLabel.Text=msg
            Runtime.Log("CLONE_FORGE "..msg)
        end
        stopButton=compactButton(utilityTab,"CLONE FORGE — STOP AFTER ITEM",function()
            clone.Stop=true
            setStatus("Đã yêu cầu STOP sau món hiện tại; vẫn sẽ Equip Best trước khi Sell nếu có Forge thành công.")
        end,Color3.fromRGB(96,73,79))
        stopButton.LayoutOrder=-88
        startButton=compactButton(utilityTab,"CLONE FORGE — START (3/6/10 → SELL BOW → EQUIP → SELL)",function()
            assert(not clone.Running and not Runtime.BatchActive and not Runtime.ForgeBusy
                and not Runtime.Owner and not Runtime.EntryBusy and not Runtime.ShopBusy
                and not isLobbyBusy and not Runtime.ForgeUncertain,"Đang có tác vụ khác / Forge chưa xác định")
            assert(GamePlaceUtil:IsMain() and not isTransitioning() and lobbyCharacterReady(),
                "Clone Forge chỉ chạy trong Lobby; server chưa xác nhận Forge trong Dungeon")
            -- Do not require AutoFarm/AutoAttackTeleport OFF. We already verified
            -- a live, stable Lobby and no competing Entry/Forge/Shop workers.
            local recipe,available=recipeFor(3)
            assert(recipe,"Ore Bag có "..tostring(available)..
                " ore nhưng không đủ công thức 3 viên từ tối đa 4 loại có Level xác định")
            clone.Running,clone.Stop,clone.Completed,clone.Turns=true,false,0,0
            Runtime.BatchActive=true -- block AutoCreate and any concurrent Forge/Sell
            -- Manual Clone Forge owns this batch. Disable the BACKGROUND cleanup
            -- permanently for this session; do not change combat or farm toggles.
            Config.AutoClearTrash=false
            Config.AutoTrashFEBS=false
            Config.AutoTrashSell=false
            Config.AutoClearTrashPending=false
            Config.OreCleanupActive=false
            Runtime.AutoClearTrashNextScanAt=0
            Runtime.AutoClearTrashRecoverCheckAt=0
            for _,key in ipairs({"AutoClearTrash","AutoTrashFEBS","AutoTrashSell"}) do
                if Runtime.ToggleRefresh[key] then pcall(Runtime.ToggleRefresh[key]) end
            end
            saveConfig()
            Runtime.Log("CLONE_FORGE_START_LOBBY autoTrashDisarmed=true combatUnchanged="
                ..tostring(Config.AutoAttackTeleport).." autoFarm="..tostring(Config.AutoFarm))
            task.spawn(function()
                local uuids={}
                local ok,err=pcall(function()
                    for turn=1,250 do
                        if clone.Stop or not Runtime.Alive then break end
                        local craftedThisTurn=0
                        for _,step in ipairs(plan) do
                            if clone.Stop or not Runtime.Alive then break end
                            assert(GamePlaceUtil:IsMain() and not isTransitioning()
                                and lobbyCharacterReady(),"Rời Lobby/nhân vật đổi; dừng Forge")
                            local rec,left=recipeFor(step.Count)
                            if not rec then
                                setStatus("Thiếu ore đủ cấp/loại cho "..step.Name..
                                    " (cần "..step.Count..", túi có "..tostring(left).."); kết thúc lượt.")
                                break
                            end
                            -- Capture ore counts before the irreversible request.
                            local previous=DataUtil:GetValue(LocalPlayer,{"Ores"})
                            assert(type(previous)=="table","Không đọc được túi trước Forge")
                            local before={}
                            for id,count in pairs(rec) do
                                before[id]=tonumber(previous[id]) or 0
                                assert(before[id]>=count,"Không đủ Ore "..id.." trước Forge")
                            end
                            Runtime.ForgeBusy=true
                            setStatus("TURN "..turn.." | "..step.Name.." "..step.Count..
                                " ore | đợi Forge & xác nhận UUID")
                            local uuid=forgeRecipe(rec,step.Type,true,"FEBS")
                            Runtime.ForgeBusy=false
                            assert(type(uuid)=="string" and uuid~="","Không xác nhận UUID sau Forge")
                            uuids[#uuids+1]=uuid
                            clone.Completed=clone.Completed+1
                            craftedThisTurn=craftedThisTurn+1
                            assert(waitUntil(function()
                                local current=DataUtil:GetValue(LocalPlayer,{"Ores"})
                                if type(current)~="table" then return false end
                                for id,count in pairs(rec) do
                                    local after=tonumber(current[id])
                                    if after==nil or after>before[id]-count then return false end
                                end
                                return true
                            end,5),"Ore Bag chưa giảm đúng công thức; DỪNG, không gửi Forge tiếp")
                            task.wait(.2)
                        end
                        if craftedThisTurn==0 then break end
                        clone.Turns=turn
                    end
                    if #uuids>0 then
                        Runtime.ForgeBusy=false
                        setStatus("FORGED "..#uuids.." món | Sell Bow → Equip Best → Sell unlocked")
                        assert(Runtime.CloneEquipBestSell,"Không tìm thấy bộ xác minh Equip Best / Sell")
                        local sold=Runtime.CloneEquipBestSell(uuids)
                        setStatus("DONE | Forge "..#uuids.." món / "..clone.Turns..
                            " turn | Sold "..tostring(sold).." gear. Gear khóa/đang đeo giữ nguyên.")
                    else
                        setStatus("STOP | Không có Forge đủ điều kiện; không Equip/Sell")
                    end
                end)
                Runtime.ForgeBusy=false
                Runtime.BatchActive=false
                clone.Running=false
                if not ok then
                    if Runtime.ProtectPendingForge then pcall(Runtime.ProtectPendingForge) end
                    setStatus("STOP ON ERROR; KHÔNG SELL NỮA: "..tostring(err):sub(1,175))
                    Runtime.Log("CLONE_FORGE_STOP_ERROR "..tostring(err))
                end
            end)
        end,Color3.fromRGB(38,123,84))
        startButton.LayoutOrder=-89
        Runtime.CloneForgeUI={Status=cloneLabel,Start=startButton,Stop=stopButton}
    end

    local confirmUntil=0
    local confirmCount=-1
    local selling=false
    local sellButton
    sellButton=compactButton(utilityTab,"SELL ALL UNLOCKED GEARS",function()
        assert(Runtime.Alive,"Script đã dừng")
        if selling then StatusLbl.Text="Đang bán trang bị; không nhấn thêm."; return end
        -- Do not interleave a destructive bulk sale with an active forge / dungeon entry.
        assert(not Runtime.Owner and not Runtime.ForgeBusy and not Runtime.BatchActive
            and not Runtime.EntryBusy and not Runtime.ForgeUncertain and not Runtime.ShopBusy
            and not isLobbyBusy,"Hệ thống đang bận Forge/Entry; thử lại khi rảnh")
        assert(GamePlaceUtil:IsMain() and not isTransitioning(),"Chỉ bán ở Lobby")
        assert(not Config.AutoFarm,"Tắt Auto Farm trước khi bán hàng loạt để tránh tự tạo Dungeon")
        local eligible=sellAllUnlockedEquipment(true,true)
        if eligible<=0 then
            confirmUntil,confirmCount=0,-1
            sellButton.Text="SELL ALL UNLOCKED GEARS"
            StatusLbl.Text="Không có gear bán được: chỉ giữ đồ ĐANG MẶC hoặc ĐÃ KHÓA."
            return
        end
        local now=os.clock()
        if now>confirmUntil or confirmCount~=eligible then
            confirmUntil,confirmCount=now+6,eligible
            sellButton.Text="XÁC NHẬN BÁN "..eligible.." GEARS"
            utilLabel.Text="BẤM LẠI TRONG 6s để bán "..eligible.." gear. Giữ đồ ĐÃ KHÓA và ĐANG MẶC. Không đụng ores/nguyên liệu."
            StatusLbl.Text="Xác nhận: "..eligible.." gear CHƯA KHÓA sẽ được bán (không giới hạn chỉ đồ vừa rèn)."
            return
        end
        confirmUntil,confirmCount=0,-1
        sellButton.Text="SELL ALL UNLOCKED GEARS"
        selling=true
        local ok,result=pcall(function() return sellAllUnlockedEquipment(true,false) end)
        selling=false
        if not ok then error(result,0) end
        Runtime.Log("UTIL_SELL_ALL_UNLOCKED sold="..tostring(result))
        StatusLbl.Text="Utilities: đã xác nhận bán "..tostring(result).." gear (không khóa/không mặc)."
        utilLabel.Text="Đã bán "..tostring(result).." gear. Đồ khóa và trang bị đang sử dụng được giữ lại."
    end,Color3.fromRGB(138,65,75))

end)() -- v4.9.49: separate Luau function scope; do not merge into outer AIO.
Runtime.ToggleRefresh.HybridRoute=nil

-- Fullscreen dual-column editor. Reparent existing interactive widgets only,
-- preserving their callbacks and original LayoutOrder; no duplicated UI.
local function arrangeTabTwoColumns(page)
    local widgets={}
    for _,child in ipairs(page:GetChildren()) do
        if child:IsA("GuiObject") then
            table.insert(widgets,child)
        elseif child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    if #widgets==0 then return end
    table.sort(widgets,function(a,b)
        if a.LayoutOrder~=b.LayoutOrder then return a.LayoutOrder<b.LayoutOrder end
        return a.Name<b.Name
    end)
    local estimatedTotal=0
    for _,w in ipairs(widgets) do estimatedTotal=estimatedTotal+math.max(26,w.Size.Y.Offset)+6 end
    local cut=math.max(1,math.floor(#widgets/2))
    local running=0
    for i,w in ipairs(widgets) do
        running=running+math.max(26,w.Size.Y.Offset)+6
        if running>=estimatedTotal*.5 then cut=math.min(#widgets-1,i); break end
    end
    -- Do not leave a section header orphaned at the end of a column.
    if cut>1 and widgets[cut]:IsA("TextLabel")
        and widgets[cut].Text:match("^%s*[A-Z][A-Z%s/]+$") then cut=cut-1 end
    local canvas=Instance.new("Frame",page)
    canvas.Name="DualColumnCanvas"
    canvas.BackgroundTransparency=1
    canvas.Position=UDim2.fromOffset(4,4)
    canvas.Size=UDim2.new(1,-8,0,32)
    local columns={}
    local layouts={}
    for i=1,2 do
        local column=Instance.new("Frame",canvas)
        column.Name=i==1 and "LeftColumn" or "RightColumn"
        column.BackgroundTransparency=1
        column.Size=UDim2.new(.49,0,0,30)
        local list=Instance.new("UIListLayout",column)
        list.Padding=UDim.new(0,6)
        list.HorizontalAlignment=Enum.HorizontalAlignment.Center
        list.SortOrder=Enum.SortOrder.LayoutOrder
        columns[i]=column
        layouts[i]=list
    end
    for i,w in ipairs(widgets) do
        w.Parent=columns[i<=cut and 1 or 2]
    end
    local function resize()
        if not Runtime.Alive or not canvas.Parent then return end
        local wide=MainFrame.AbsoluteSize.X>=860
        local leftH=layouts[1].AbsoluteContentSize.Y
        local rightH=layouts[2].AbsoluteContentSize.Y
        columns[1].Position=UDim2.fromScale(.005,0)
        columns[1].Size=UDim2.new(wide and .49 or .99,0,0,math.max(leftH,1))
        columns[2].Position=wide and UDim2.fromScale(.505,0)
            or UDim2.new(.005,0,0,leftH+9)
        columns[2].Size=UDim2.new(wide and .49 or .99,0,0,math.max(rightH,1))
        canvas.Size=UDim2.new(1,-8,0,(wide and math.max(leftH,rightH) or (leftH+rightH+9))+16)
    end
    for _,layout in ipairs(layouts) do
        table.insert(Runtime.Connections,layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize))
    end
    table.insert(Runtime.Connections,MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize))
    task.defer(resize)
end
for _,name in ipairs({"Dungeon","Record","Combat","Forge","Utilities"}) do
    arrangeTabTwoColumns(Runtime.Tabs[name])
end

-- === v4.9.35 UNIVERSAL HOVER+30 / INDEPENDENT PER-SKILL AIM + DESCENT ===
function Runtime.InitAutoCombatUI()
    -- Keep legacy controls/callbacks in memory for compatibility, but remove
    -- their entire visual panel. Recorder is NOT a navigable AIO tab.
    local combatPage=Runtime.Tabs.Combat
    local oldCombat=combatPage:FindFirstChild("DualColumnCanvas")
    if oldCombat then oldCombat.Visible=false;oldCombat.Size=UDim2.new(1,0,0,0) end
    -- Reuse the UIListLayout already present on the Combat ScrollingFrame.
    -- Two competing layouts would scramble the new Recent Runs table.
    local list=combatPage:FindFirstChildWhichIsA("UIListLayout")
    if not list then list=Instance.new("UIListLayout",combatPage) end
    list.SortOrder=Enum.SortOrder.LayoutOrder
    list.Padding=UDim.new(0,8)
    list.HorizontalAlignment=Enum.HorizontalAlignment.Center

    local columns=Instance.new("Frame",combatPage)
    columns.Name="TwoColumnCombat"
    columns.BackgroundTransparency=1
    columns.Size=UDim2.new(1,-8,0,240)
    columns.LayoutOrder=1
    local left,right,layouts={}, {}, {}
    for i=1,2 do
        local col=Instance.new("Frame",columns)
        col.Name=i==1 and "Modes" or "SkillDescent"
        col.BackgroundTransparency=1
        local lay=Instance.new("UIListLayout",col)
        lay.Padding=UDim.new(0,7)
        lay.SortOrder=Enum.SortOrder.LayoutOrder
        lay.HorizontalAlignment=Enum.HorizontalAlignment.Center
        layouts[i]=lay
        if i==1 then left=col else right=col end
    end
    -- New controls are created directly in the VISIBLE combat column.
    -- Legacy widgets were destroyed by page:ClearAllChildren() earlier.
    Runtime.CreateUndergroundCombatControls(left)
    local function resizeCombatColumns()
        if not Runtime.Alive or not columns.Parent then return end
        local wide=MainFrame.AbsoluteSize.X>=800
        local a=layouts[1].AbsoluteContentSize.Y
        local b=layouts[2].AbsoluteContentSize.Y
        left.Size=UDim2.new(wide and .49 or 1,0,0,math.max(a,1))
        right.Size=UDim2.new(wide and .49 or 1,0,0,math.max(b,1))
        left.Position=UDim2.new(0,0,0,0)
        right.Position=wide and UDim2.new(.50,0,0,0) or UDim2.new(0,0,0,a+9)
        columns.Size=UDim2.new(1,-8,0,(wide and math.max(a,b) or a+b+9)+12)
    end
    for _,lay in ipairs(layouts) do
        table.insert(Runtime.Connections,lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeCombatColumns))
    end
    table.insert(Runtime.Connections,MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeCombatColumns))
    task.defer(resizeCombatColumns)
    -- v4.9.44: isolate the test-history UI in its own function scope.
    -- Prevents expanding the enormous AIO function's Luau local-register budget.
    local function initDungeonTestHistoryUI()
        local history=Instance.new("Frame",combatPage)
        history.Name="RecentDungeonHistory"
        history.BackgroundColor3=Color3.fromRGB(26,28,41)
        history.BorderSizePixel=0
        history.Size=UDim2.new(1,-8,0,381)
        history.LayoutOrder=2
        local title=Instance.new("TextLabel",history)
        title.Name="HistoryTitle"
        title.BackgroundTransparency=1
        title.Position=UDim2.new(0,10,0,3)
        title.Size=UDim2.new(1,-20,0,31)
        title.Text="5 DUNGEON HOÀN THÀNH GẦN NHẤT  |  BUILD TEST"
        title.TextColor3=Color3.fromRGB(228,232,244)
        title.Font=Enum.Font.GothamBold
        title.TextSize=15
        -- Queue editor. Plus is intentionally the leftmost action in this table.
        local editor=Instance.new("Frame",history)
        editor.Name="TestDescriptionEditor"
        editor.Position=UDim2.new(0,9,0,38)
        editor.Size=UDim2.new(1,-18,0,43)
        editor.BorderSizePixel=0
        editor.BackgroundColor3=Color3.fromRGB(32,42,65)
        local add=Instance.new("TextButton",editor)
        add.Name="AddNextRun"
        add.Position=UDim2.new(0,5,0,4)
        add.Size=UDim2.new(0,41,1,-8)
        add.Text="+"
        add.TextSize=26
        add.Font=Enum.Font.GothamBold
        add.TextColor3=Color3.fromRGB(255,255,255)
        add.BackgroundColor3=Color3.fromRGB(34,108,204)
        add.BorderSizePixel=0
        local addCorner=Instance.new("UICorner",add)
        addCorner.CornerRadius=UDim.new(0,6)
        local input=Instance.new("TextBox",editor)
        input.Name="NextRunDescription"
        input.Position=UDim2.new(0,54,0,4)
        input.Size=UDim2.new(1,-61,1,-8)
        input.BackgroundColor3=Color3.fromRGB(22,29,45)
        input.BorderSizePixel=0
        input.ClearTextOnFocus=false
        input.Text=""
        input.PlaceholderText="Description cho lượt tới, VD: Test Mũ CDR 108%"
        input.TextColor3=Color3.fromRGB(242,245,255)
        input.PlaceholderColor3=Color3.fromRGB(151,161,184)
        input.Font=Enum.Font.Gotham
        input.TextSize=14
        input.TextXAlignment=Enum.TextXAlignment.Left
        local inputCorner=Instance.new("UICorner",input)
        inputCorner.CornerRadius=UDim.new(0,6)
        local inputPad=Instance.new("UIPadding",input)
        inputPad.PaddingLeft=UDim.new(0,10)
        inputPad.PaddingRight=UDim.new(0,8)
        local status=Instance.new("TextLabel",history)
        status.Name="QueuedTestsStatus"
        status.BackgroundTransparency=1
        status.Position=UDim2.new(0,16,0,83)
        status.Size=UDim2.new(1,-32,0,28)
        status.Text="Chưa có test đang chờ. Nhập Description rồi bấm +."
        status.TextColor3=Color3.fromRGB(169,186,213)
        status.Font=Enum.Font.Gotham
        status.TextSize=12
        status.TextXAlignment=Enum.TextXAlignment.Left
        status.TextTruncate=Enum.TextTruncate.AtEnd
        local recentCols={
            {Key="Add",Title="",X=0,W=.05},
            {Key="No",Title="STT",X=.05,W=.08},
            {Key="Time",Title="THỜI GIAN FINISH",X=.13,W=.21},
            {Key="Deaths",Title="SỐ LẦN CHẾT",X=.34,W=.18},
            {Key="Description",Title="DESCRIPTION",X=.52,W=.48},
        }
        local cellRefs={}
        local function makeCell(parent,c,txt,isHeader)
            local lb=Instance.new("TextLabel",parent)
            lb.Name=c.Key
            lb.BackgroundTransparency=1
            lb.Position=UDim2.new(c.X,c.Key=="Description" and 8 or 0,0,0)
            lb.Size=UDim2.new(c.W,c.Key=="Description" and -12 or 0,1,0)
            lb.Font=isHeader and Enum.Font.GothamBold or Enum.Font.Gotham
            lb.TextSize=isHeader and 12 or 14
            lb.TextColor3=isHeader and Color3.fromRGB(184,198,226)
                or Color3.fromRGB(239,241,248)
            lb.Text=txt
            lb.TextXAlignment=c.Key=="Description" and Enum.TextXAlignment.Left
                or Enum.TextXAlignment.Center
            lb.TextTruncate=Enum.TextTruncate.AtEnd
            return lb
        end
        for idx=0,5 do
            local tr=Instance.new("Frame",history)
            tr.Name=idx==0 and "Header" or ("Run"..idx)
            tr.BackgroundColor3=idx==0 and Color3.fromRGB(43,57,80)
                or (idx%2==0 and Color3.fromRGB(32,37,54) or Color3.fromRGB(36,42,61))
            tr.BorderSizePixel=0
            tr.Position=UDim2.new(0,9,0,115+idx*39)
            tr.Size=UDim2.new(1,-18,0,37)
            cellRefs[idx]={}
            for _,c in ipairs(recentCols) do
                cellRefs[idx][c.Key]=makeCell(tr,c,idx==0 and c.Title or "—",idx==0)
            end
            if idx>0 then
                cellRefs[idx].No.Text=tostring(idx)
                cellRefs[idx].Add.Text=""
            end
        end
        local foot=Instance.new("TextLabel",history)
        foot.Name="HistoryHint"
        foot.Position=UDim2.new(0,16,0,351)
        foot.Size=UDim2.new(1,-32,0,24)
        foot.BackgroundTransparency=1
        foot.Text="+ = xếp lịch cho lượt sau  •  Chỉ hiện Dungeon hoàn thành  •  Test bị gián đoạn sẽ thử lại"
        foot.TextColor3=Color3.fromRGB(144,158,183)
        foot.Font=Enum.Font.Gotham
        foot.TextSize=11
        foot.TextXAlignment=Enum.TextXAlignment.Left
        foot.TextTruncate=Enum.TextTruncate.AtEnd
        local flashUntil=0
        local flashText=""
        local function refreshHistory()
            if not Runtime.Alive or not history.Parent then return end
            local a=Runtime.Analytics
            local rows=a and a.LastFiveRuns or {}
            for i=1,5 do
                local display=cellRefs[i]
                local r=rows[#rows-i+1]
                if r and type(r.Seconds)=="number" then
                    local seconds=math.floor(r.Seconds+.5)
                    display.Time.Text=string.format("%02d:%02d",math.floor(seconds/60),seconds%60)
                    display.Deaths.Text=tostring(math.floor(r.Deaths or 0))
                    display.Description.Text=(type(r.Description)=="string" and r.Description~="")
                        and r.Description or "—"
                    display.Description.TextColor3=r.Description and r.Description~=""
                        and Color3.fromRGB(145,206,249) or Color3.fromRGB(166,178,198)
                else
                    display.Time.Text="—"
                    display.Deaths.Text="—"
                    display.Description.Text="—"
                end
            end
            if os.clock()<flashUntil then
                status.Text=flashText
                return
            end
            local queue=a and a.PendingTestQueue or {}
            if #queue>0 then
                status.Text="ĐANG CHỜ ("..tostring(#queue)..") • Lượt tới: "..tostring(queue[1])
                status.TextColor3=Color3.fromRGB(246,203,113)
            else
                status.Text="Chưa có test đang chờ. Nhập Description rồi bấm +."
                status.TextColor3=Color3.fromRGB(169,186,213)
            end
        end
        add.MouseButton1Click:Connect(function()
            local a=Runtime.Analytics
            if not a or not a.QueueNextDungeonTest then return end
            local ok,msg=a.QueueNextDungeonTest(input.Text)
            if ok then input.Text="" end
            flashText=tostring(msg)
            flashUntil=os.clock()+3
            status.TextColor3=ok and Color3.fromRGB(130,220,177) or Color3.fromRGB(251,154,143)
            refreshHistory()
        end)
        refreshHistory()
        task.spawn(function()
            while Runtime.Alive and history.Parent do
                task.wait(2)
                if Runtime.Alive then pcall(refreshHistory) end
            end
        end)
    end
    initDungeonTestHistoryUI()
    -- v4.9.42: section headings & button outlines local to Combat Tab.
    local function combatSection(parent,title,tint)
        local label=compactLabel(parent,title,31)
        label.BackgroundColor3=tint
        label.TextColor3=Color3.fromRGB(226,237,250)
        label.Font=Enum.Font.GothamBold
        label.TextSize=13
        local round=Instance.new("UICorner",label)
        round.CornerRadius=UDim.new(0,7)
        return label
    end
    local function combatTile(button,outline)
        button.TextWrapped=true
        button.Font=Enum.Font.GothamBold
        button.TextSize=13
        local round=Instance.new("UICorner",button)
        round.CornerRadius=UDim.new(0,7)
        local stroke=Instance.new("UIStroke",button)
        stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        stroke.Thickness=1
        stroke.Transparency=.42
        stroke.Color=outline or Color3.fromRGB(110,129,153)
        return button
    end
    local modeStatus=compactLabel(left,"Đang quét vũ khí...",56)
    modeStatus.BackgroundColor3=Color3.fromRGB(32,43,63)
    modeStatus.TextColor3=Color3.fromRGB(218,231,251)
    combatSection(left,"01  |  CHỌN CHẾ ĐỘ CHIẾN ĐẤU",Color3.fromRGB(48,59,81))
    local mainBtn,halloweenBtn,smartDodgeBtn
    local combatModeButtons={}
    local lastWeaponSignature=nil
    local activeClass=nil
    local classLabels={ASTRAL="ASTRAL RASTAR",STAFF_S5="STAFF S5 + LASER",
        BOW="BOW",GUN="GUN",STAFF="STAFF KHÁC",GENERIC="MELEE / VŨ KHÍ THƯỜNG"}
    local function scan()
        local slots={}
        local ids={}
        -- WeaponUtil is local client metadata, not a server Remote request.
        for _,slot in ipairs({"BaseAttack","Skill1","Skill2","SkillU","SkillAW"}) do
            local ok,p=pcall(Runtime.ResolveSkillProfile,slot,true)
            if ok and type(p)=="table" then
                slots[slot]=p
                ids[#ids+1]=slot.."="..tostring(p.Id)
            else
                ids[#ids+1]=slot.."=?"
            end
        end
        local base=slots.BaseAttack
        local q=slots.Skill1
        if not base and not q then return nil,"Chờ WeaponUtil nhận diện vũ khí",slots,nil end
        local baseId=base and base.Id or ""
        local wid=base and base.WeaponId or (q and q.WeaponId) or ""
        local cls="GENERIC"
        if baseId=="Staff_Rastar_Atk" or (q and q.Id=="Staff_Rastar_Skill_Backflip") then
            cls="ASTRAL"
        elseif baseId=="Staff_Atk2" and base.Count>=5 then
            cls="STAFF_S5"
        elseif string.lower(tostring(baseId)):find("bow",1,true)
            or string.lower(tostring(wid)):find("bow",1,true) then
            cls="BOW"
        elseif string.lower(tostring(baseId)):find("gun",1,true)
            or string.lower(tostring(wid)):find("gun",1,true)
            or string.lower(tostring(wid)):find("pistol",1,true) then
            cls="GUN"
        elseif string.lower(tostring(baseId)):find("staff",1,true)
            or string.lower(tostring(wid)):find("staff",1,true) then
            cls="STAFF"
        end
        return cls,table.concat(ids,"|"),slots,wid
    end
    local function labels(cls,slots)
        local function n(slot) return slots[slot] and tostring(slots[slot].Count) or "?" end
        return "VŨ KHÍ: "..(classLabels[cls] or "CHƯA RÕ")..
            " | Q:"..n("Skill1").." E:"..n("Skill2")..
            " R:"..n("SkillU").." G:"..n("SkillAW")..
            " | M1:"..n("BaseAttack")
    end
    local function apply(cls,why)
        if not Config.AutoCombatPresetEnabled then return end
        -- ASTRAL_UG is an exclusive UI mode. It maps to the proven ASTRAL
        -- skill scheduler; only the position owner changes to Underground.
        -- Weapon swaps fail safely to RANGE without overwriting the selection.
        local selectedMode=Config.CombatMode
        local wantsUnderground=selectedMode=="ASTRAL_UG"
        local mode=(selectedMode=="ASTRAL" or wantsUnderground)
            and (cls=="ASTRAL" and "ASTRAL" or "RANGE") or selectedMode
        local wasUnderground=Config.UndergroundHover==true
        Config.UndergroundHover=wantsUnderground and cls=="ASTRAL"
        if wasUnderground and not Config.UndergroundHover and Runtime.ExitUnderground then
            Runtime.ExitUnderground("switched combat mode",false)
        end
        if Config.UndergroundHover and Runtime.DodgeActive then
            Runtime.DodgeActive=false
            Runtime.HalloweenDodgePosition=nil
        end
        local special=Config.HalloweenMode==true
        -- Cancel only the previous special workers when changing profile;
        -- never interrupt ongoing Forge, dungeon entry or route ownership.
        if Runtime.CancelLaser then pcall(Runtime.CancelLaser,"AUTO PRESET "..tostring(cls)) end
        if Runtime.CloseScepterS5 then pcall(Runtime.CloseScepterS5) end
        if Runtime.CancelFlySkill then pcall(Runtime.CancelFlySkill,"AUTO PRESET") end
        if Runtime.OrbitReset then pcall(Runtime.OrbitReset,"AUTO PRESET") end
        Config.ScepterCombat=(cls=="STAFF_S5" and mode=="RANGE")
        Config.ScepterCombatMode="FULL"
        Config.BowCombat=(cls=="BOW")
        Config.AstralSkillPriority=(cls=="ASTRAL" and mode=="ASTRAL")
        -- Independent AstralRushQ/E/R/G settings are persistent.
        -- NEVER overwrite them on profile refresh or Mode selection.
        Config.AstralRastarM1Projectiles=(cls=="ASTRAL" and mode=="ASTRAL")
        Config.AstralOrbitCombat=false -- Q already has its own horizontal descent
        Config.ScepterGBypassClientCooldown=false -- Don't confuse requests with hits
        Config.AutoSkills=true
        Config.AutoM1=true
        Config.AutoAttackTeleport=true -- team & dungeon combat; does not create Solo room
        Config.HoverCombat=(mode~="CLONE")
        -- Preserve explicit SmartDodge ON/OFF; CLONE defaults OFF on selection.
        Config.SmartTargetLock=true
        Config.DynamicHoldMultiHit=true
        Config.FlyDynamicSkills=(mode~="CLONE")
        Config.FlyHotkeys=false -- Important: never steal E from native Forge UI
        -- Do not overwrite player directions on profile switch. Q/E/R/G use
        -- GetSkillCastDirection() keyed by actual equipped ID instead.
        Config.FlyCastDistance=28
        Config.FlyCastHold=.10
        Config.Aim3DDown=false
        Config.HalloweenMode=special
        Config.HoverHeight=(mode=="MELEE" or mode=="CLONE") and 12 or 30 -- ground clone bypasses hover
        if not special then Runtime.HalloweenDodgePosition=nil end
        activeClass=cls
        Runtime.ActiveCombatMode=mode
        Runtime.AutoCombatClass=cls
        for _,key in ipairs({"ScepterCombat","BowCombat","AstralSkillPriority","AutoSkills","AutoM1",
            "AutoAttackTeleport","HalloweenMode","SmartDodge","UndergroundHover"}) do
            if Runtime.ToggleRefresh[key] then pcall(Runtime.ToggleRefresh[key]) end
        end
        Runtime.Log("AUTO_COMBAT_PROFILE "..cls.." MODE="..mode
            ..(wantsUnderground and (Config.UndergroundHover and " UG_ACTIVE" or " UG_WAIT_RASTAR") or "")
            ..(special and " HALLOWEEN_SAFE_LATERAL" or " NORMAL")..
            " cause="..tostring(why))
    end
    local directionButtons={}
    local descentButtons={}
    local rushButtons={}
    local directionPanelExpanded=false
    local directionPanelToggle
    local directionNote
    local directionSlots={
        {slot="Skill1",key="Q",rush="AstralRushQ",rushHold="0.12s"},
        {slot="Skill2",key="E",rush="AstralRushE",rushHold="0.10s"},
        {slot="SkillU",key="R",rush="AstralRushR",rushHold="0.15s"},
        {slot="SkillAW",key="G",rush="AstralRushG",rushHold="0.08s"},
    }
    local knownNames={
        Staff_Rastar_Skill_Backflip="Astral Orbit",
        Staff_Rastar_Skill_StarFall="Stellar Singularity",
        Staff_Rastar_Skill_Ult_FinalAct="Cosmic Convergence",
        Staff_Skill_Ult_Beam="Radiant Nova / Beam",
    }
    local function friendlySkillName(id)
        if knownNames[id] then return knownNames[id] end
        if type(id)~="string" then return "CHƯA XÁC ĐỊNH" end
        -- Unknown skills remain distinguishable by their actual server ID.
        return (#id>44) and (id:sub(1,41).."...") or id
    end
    local function directionLabel(dir)
        return dir=="HORIZONTAL" and "NGANG" or "TỪ HOVER"
    end
    local function refreshDirectionButtons(slots)
        slots=slots or {}
        for _,row in ipairs(directionSlots) do
            local btn=descentButtons[row.slot]
            if btn then
                local p=slots[row.slot]
                if p and p.Id then
                    local mode=Runtime.GetSkillCastElevation(row.slot,p)
                    local descend=mode=="DESCEND"
                    btn.Text=(descend and "[ON] " or "[OFF] ")..row.key..
                        " — HẠ ĐỂ CAST"
                    btn.BackgroundColor3=descend and Color3.fromRGB(42,120,77)
                        or Color3.fromRGB(56,69,89)
                else
                    btn.Text=row.key.." — CHƯA CÓ SKILL"
                    btn.BackgroundColor3=Color3.fromRGB(49,51,62)
                end
            end
        end
    end
    local function refreshRushButtons(slots)
        for _,row in ipairs(directionSlots) do
            local btn=rushButtons[row.slot]
            if btn then
                local on=Config[row.rush]==true
                local p=slots and slots[row.slot]
                local stages=p and tonumber(p.Count) or 0
                local count=stages>0 and (tostring(stages).." PHASE") or "CHƯA NHẬN SKILL"
                btn.Text=(on and "[ON]  " or "[OFF]  ").."RUSH "..row.key..
                    "  |  "..count.."  |  "..(on and (row.rushHold.." / HOLD") or "NHỊP THƯỜNG")
                btn.BackgroundColor3=on and Color3.fromRGB(30,103,193)
                    or Color3.fromRGB(47,62,88)
            end
        end
    end
    local function directionSummary(slots)
        local pieces={}
        for _,row in ipairs(directionSlots) do
            local p=slots and slots[row.slot]
            if p and p.Id then
                local v=Runtime.GetSkillCastElevation(row.slot,p)
                pieces[#pieces+1]=row.key..":"..(v=="DESCEND" and "HẠ" or "GIỮ")
            end
        end
        return #pieces>0 and table.concat(pieces," | ") or "Chưa có dữ liệu Q/E/R/G"
    end
    local function refreshButtons(cls,slots)
        local on=Config.AutoCombatPresetEnabled
        for mode,btn in pairs(combatModeButtons) do
            local selected=on and Config.CombatMode==mode
            local paused=selected and mode=="ASTRAL_UG" and cls~="ASTRAL"
            btn.Text=(paused and "[WAIT RASTAR] " or (selected and "[ON] " or "[OFF] "))..(mode=="RANGE" and "RANGE MODE  |  +30  |  Q/E/R > M1"
                or mode=="MELEE" and "MELEE MODE  |  +12  |  M1 0.10s + SKILLS"
                or mode=="CLONE" and "CLONE MODE  |  TP SÁT QUÁI  |  M1 0.10s + SKILLS"
                or mode=="ASTRAL_UG" and "ASTRAL + UNDERGROUND  |  -"..tostring(Config.UndergroundDepth).."  |  Q/E/R/G"
                or "ASTRAL MODE  |  +30  |  Q/E/R/G + RASTAR M1")
            btn.BackgroundColor3=selected and Color3.fromRGB(34,135,78) or Color3.fromRGB(54,64,83)
        end
        if smartDodgeBtn then
            smartDodgeBtn.Text=(Config.SmartDodge and "[ON] " or "[OFF] ").."SMART DODGE (+30 / HALLOWEEN NÉ NGANG)"
            smartDodgeBtn.BackgroundColor3=Config.SmartDodge and Color3.fromRGB(45,120,80)
                or Color3.fromRGB(75,68,85)
        end
        mainBtn.Text=(on and "[ON] " or "[OFF] ").."AUTO COMBAT — TỰ NHẬN DIỆN VŨ KHÍ"
        mainBtn.BackgroundColor3=on and Color3.fromRGB(34,135,78) or Color3.fromRGB(112,52,60)
        local enabled=on and Config.HalloweenMode
        halloweenBtn.Text=(enabled and "[ON] " or "[OFF] ").."HALLOWEEN DODGE (NÉ NGANG, KIỂM TRA SÀN/BIÊN)"
        halloweenBtn.BackgroundColor3=enabled and Color3.fromRGB(35,125,105) or Color3.fromRGB(57,69,93)
        if cls then
            modeStatus.Text=labels(cls,slots).."\n"..directionSummary(slots)
        else
            modeStatus.Text="CHƯA XÁC ĐỊNH SKILL — chờ nhân vật tải xong"
        end
        refreshDirectionButtons(slots)
        refreshRushButtons(slots)
    end
    local function sync(force)
        if not Runtime.Alive then return end
        local cls,sig,slots=scan()
        if Config.AutoCombatPresetEnabled and cls then
            if force or cls~=activeClass then
                apply(cls,force and "USER_BUTTON" or "WEAPON_CHANGED")
            end
        end
        if cls~=nil and sig~=lastWeaponSignature then
            lastWeaponSignature=sig
            Runtime.Log("AUTO_COMBAT_SKILLS "..tostring(sig))
        end
        refreshButtons(cls,slots)
    end
    mainBtn=compactButton(left,"AUTO COMBAT",function()
        Config.AutoCombatPresetEnabled=not Config.AutoCombatPresetEnabled
        if Config.AutoCombatPresetEnabled then
            Config.AutoCombatHalloweenAstral=false
            activeClass=nil
            sync(true)
        else
            Config.AutoCombatHalloweenAstral=false
            Runtime.AutoCombatClass=nil
            Config.HalloweenMode=false
            Config.AutoSkills=false
            Config.AutoM1=false
            Config.AutoAttackTeleport=false
            if Runtime.CancelLaser then pcall(Runtime.CancelLaser,"Auto combat disabled") end
            if Runtime.CloseScepterS5 then pcall(Runtime.CloseScepterS5) end
            if Runtime.CancelFlySkill then pcall(Runtime.CancelFlySkill,"Auto combat disabled") end
            sync(false)
        end
        saveConfig()
    end,Color3.fromRGB(34,135,78))
    mainBtn.Size=UDim2.new(.94,0,0,49)
    mainBtn.Visible=false -- replaced by exclusive Combat Mode buttons
    for _,mode in ipairs({"RANGE","MELEE","ASTRAL","ASTRAL_UG","CLONE"}) do
        local modeKey=mode
        local btn=compactButton(left,modeKey.." MODE",function()
            local cls=scan()
            if (modeKey=="ASTRAL" or modeKey=="ASTRAL_UG") and cls~="ASTRAL" then
                StatusLbl.Text="ASTRAL MODE cần trang bị đúng Astral Rastar (Skill ID đã xác nhận)."
                return
            end
            local switching=Config.CombatMode~=modeKey
            Config.CombatMode=modeKey
            Config.AutoCombatPresetEnabled=true
            if (modeKey=="MELEE" or modeKey=="CLONE") and switching then Config.SmartDodge=false end
            -- Per-skill Rush settings survive switching modes unchanged.
            activeClass=nil
            sync(true)
            saveConfig()
        end,Color3.fromRGB(54,64,83))
        btn.Size=UDim2.new(.94,0,0,48)
        combatTile(btn,Color3.fromRGB(117,143,169))
        combatModeButtons[modeKey]=btn
    end
    combatSection(left,"02  |  AN TOÀN / NÉ ĐÒN",Color3.fromRGB(55,62,76))
    halloweenBtn=compactButton(left,"HALLOWEEN: NÉ NGANG (GIỮ TRONG ARENA)",function()
        Config.HalloweenMode=not Config.HalloweenMode
        Config.AutoCombatHalloweenAstral=Config.HalloweenMode -- legacy compatibility
        Config.AutoCombatPresetEnabled=true
        activeClass=nil
        sync(true)
        saveConfig()
    end,Color3.fromRGB(57,69,93))
    halloweenBtn.Size=UDim2.new(.94,0,0,44)
    combatTile(halloweenBtn,Color3.fromRGB(100,145,137))
    smartDodgeBtn=compactButton(left,"SMART DODGE",function()
        Config.SmartDodge=not Config.SmartDodge
        if not Config.SmartDodge then
            Runtime.DodgeActive=false
            Runtime.HalloweenDodgePosition=nil
        end
        saveConfig()
        local _,_,slots=scan()
        refreshButtons(Runtime.AutoCombatClass,slots)
    end,Color3.fromRGB(75,68,85))
    smartDodgeBtn.Size=UDim2.new(.94,0,0,44)
    combatTile(smartDodgeBtn,Color3.fromRGB(125,116,138))
    local skillHeader=combatSection(right,
        "03  |  VỊ TRÍ CAST  ·  XANH LÁ = HẠ / XÁM = GIỮ",Color3.fromRGB(35,79,64))
    skillHeader.LayoutOrder=1
    for _,row in ipairs(directionSlots) do
        local slot,key=row.slot,row.key
        local altitudeBtn
        altitudeBtn=compactButton(right,key.." — CHƯA CÓ SKILL",function()
            local p=Runtime.ResolveSkillProfile(slot,true)
            if not p or type(p.Id)~="string" then
                StatusLbl.Text="Chưa xác định skill "..key.."; không lưu thay đổi"
                return
            end
            local was=Runtime.GetSkillCastElevation(slot,p)
            local nextMode=was=="DESCEND" and "HOVER" or "DESCEND"
            Config.SkillDescentOverrides[p.Id]=nextMode
            Runtime.FlySkillLastAttempt[slot]=0
            saveConfig()
            Runtime.Log("DESCENT_TOGGLE "..key.." "..p.Id.." "..nextMode)
            local _,_,slots=scan()
            refreshDirectionButtons(slots)
        end,Color3.fromRGB(56,69,89))
        altitudeBtn.Size=UDim2.new(.94,0,0,52)
        combatTile(altitudeBtn,Color3.fromRGB(107,147,129))
        descentButtons[slot]=altitudeBtn
    end
    combatSection(right,"04  |  ASTRAL RUSH  ·  XANH DƯƠNG = NHANH",
        Color3.fromRGB(29,68,117))
    local rushTip=compactLabel(right,
        "RUSH ON: rút ngắn nhịp giữ mỗi phase; VẪN GỬI ĐỦ phase theo Skill ID. "..
        "OFF: nhịp bình thường. Hoạt động với ASTRAL và ASTRAL + UNDERGROUND.",48)
    rushTip.BackgroundColor3=Color3.fromRGB(28,42,65)
    rushTip.TextColor3=Color3.fromRGB(183,212,251)
    rushTip.TextSize=11
    for _,row in ipairs(directionSlots) do
        local slot,key,rushKey=row.slot,row.key,row.rush
        local rushBtn=compactButton(right,"RUSH "..key,function()
            Config[rushKey]=not Config[rushKey]
            saveConfig()
            Runtime.Log("ASTRAL_RUSH_"..key.." "..tostring(Config[rushKey])..
                " phases=ALL_DEFINED (server hits not guaranteed)")
            local _,_,slots=scan()
            refreshRushButtons(slots)
        end,Color3.fromRGB(47,62,88))
        rushBtn.Size=UDim2.new(.94,0,0,49)
        combatTile(rushBtn,Color3.fromRGB(77,153,245))
        rushButtons[slot]=rushBtn
    end
    local colorLegend=compactLabel(right,
        "XANH LÁ: HẠ CAST     |     XANH DƯƠNG: RUSH     |     XÁM: OFF",36)
    colorLegend.BackgroundColor3=Color3.fromRGB(30,37,52)
    colorLegend.TextColor3=Color3.fromRGB(187,204,230)
    colorLegend.TextSize=11
    local tip=compactLabel(left,
        "Chỉ 1 Mode ON. ASTRAL + UNDERGROUND dùng rotation ASTRAL nhưng độc quyền giữ dưới nền; "..
        "đổi Mode sẽ tự tắt Underground. Route/Lobby được quyền tiếp quản.",57)
    tip.TextSize=11
    tip.BackgroundColor3=Color3.fromRGB(31,40,55)
    tip.TextColor3=Color3.fromRGB(202,216,236)
    Runtime.AutoCombatSync=sync
    pcall(sync,true) -- never fail boot because equip metadata is not loaded yet
    task.spawn(function()
        while Runtime.Alive do
            task.wait(1.8) -- not every frame; re-resolve current loadout
            if Runtime.Alive then
                local ok,err=pcall(sync,false)
                if not ok then Runtime.Log("AUTO_COMBAT_SCAN_ERROR "..tostring(err)) end
            end
        end
    end)

end

do
    -- Hide ALL old analytics controls, leave only rolling clear time per round.
    local utility=Runtime.Tabs.Utilities
    local oldUtilCanvas=utility:FindFirstChild("DualColumnCanvas")
    if oldUtilCanvas then
        for _,child in ipairs(oldUtilCanvas:GetDescendants()) do
            if child:IsA("GuiObject") and
                child.LayoutOrder>= (Runtime.LegacyAnalyticsUIStart or math.huge) and
                child.LayoutOrder<= (Runtime.LegacyAnalyticsUIEnd or -1) then
                child.Visible=false
            end
        end
        local left=oldUtilCanvas:FindFirstChild("LeftColumn")
        if left then
            local avgLbl=compactLabel(left,"30 phút: Chưa đủ lượt | 60 phút: Chưa đủ lượt",63)
            avgLbl.TextSize=14
            avgLbl.LayoutOrder=-100 -- rolling 30/60 summary is the first Utilities item
            avgLbl.Font=Enum.Font.GothamBold
            local function formatAvg(n)
                if not n then return "--:--" end
                local sec=math.floor(n+.5)
                return string.format("%d phút %02d giây",math.floor(sec/60),sec%60)
            end
            local function refreshAvg()
                local a=Runtime.Analytics
                if not a or not a.FarmAverage then return end
                local avg30,n30,world,diff=a.FarmAverage(30)
                local avg60,n60,w60,d60=a.FarmAverage(60)
                local worldName=world or w60 or "Chưa có full run"
                local diffName=diff or d60
                avgLbl.Text=string.format("%s%s | 30 PHÚT: %s (%d round) | 60 PHÚT: %s (%d round)",
                    tostring(worldName),diffName and (" Diff"..tostring(diffName)) or "",
                    formatAvg(avg30),n30,formatAvg(avg60),n60)
            end
            refreshAvg()
            task.spawn(function()
                while Runtime.Alive do task.wait(10);if Runtime.Alive then pcall(refreshAvg) end end
            end)
        end
    end
end
Runtime.InitAutoCombatUI()
-- v4.9.50c: Removed the ineffective reparenting attempt from deleted legacy GUI.
Runtime.Log("W1_BEGINNER_ROUTES Diff1=6 Diff2=6 Diff3=7; Diff4=OFF Diff5=ORIGINAL")

-- v4.9.45 CODE TAB + CLONE DAILY ROUTINE
-- Isolated function scope avoids increasing the large AIO boot function local register count.
function Runtime.InitCodeDailyUI()
    local page=Runtime.Tabs.Code
    if not page then Runtime.Log("CODE_TAB_MISSING"); return end
    -- CODE tab: two separate functional columns; on narrow windows stack them.
    -- One root UIListLayout already exists on this tab; keep it and insert a
    -- single canvas to avoid competing layouts / unpredictable scroll heights.
    local codeCanvas=Instance.new("Frame",page)
    codeCanvas.Name="TwoColumnCode"
    codeCanvas.BackgroundTransparency=1
    codeCanvas.Size=UDim2.new(1,-10,0,80)
    codeCanvas.LayoutOrder=1
    local columns={}
    local columnLayouts={}
    for i=1,2 do
        local col=Instance.new("Frame",codeCanvas)
        col.Name=i==1 and "CodeAndExchange" or "DailyRoutine"
        col.BackgroundTransparency=1
        col.Size=UDim2.new(.49,0,0,60)
        local list=Instance.new("UIListLayout",col)
        list.Padding=UDim.new(0,8)
        list.SortOrder=Enum.SortOrder.LayoutOrder
        list.HorizontalAlignment=Enum.HorizontalAlignment.Center
        columns[i]=col
        columnLayouts[i]=list
    end
    local function resizeCode()
        if not Runtime.Alive or not codeCanvas.Parent then return end
        local wide=MainFrame.AbsoluteSize.X>=800
        local a=columnLayouts[1].AbsoluteContentSize.Y
        local b=columnLayouts[2].AbsoluteContentSize.Y
        columns[1].Position=UDim2.fromOffset(0,0)
        columns[1].Size=UDim2.new(wide and .49 or 1,0,0,math.max(a,1))
        columns[2].Position=wide and UDim2.new(.505,0,0,0) or UDim2.new(0,0,0,a+12)
        columns[2].Size=UDim2.new(wide and .49 or 1,0,0,math.max(b,1))
        codeCanvas.Size=UDim2.new(1,-10,0,(wide and math.max(a,b) or a+b+12)+18)
    end
    for _,list in ipairs(columnLayouts) do
        table.insert(Runtime.Connections,list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeCode))
    end
    table.insert(Runtime.Connections,MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeCode))
    task.defer(resizeCode)
    local sectionParent=columns[1]
    local codeItemOrder=0
    local function placeCodeWidget(widget)
        codeItemOrder=codeItemOrder+1
        widget.LayoutOrder=codeItemOrder
        widget.Parent=sectionParent
        return widget
    end
    local codeRemoteRoot=ReplicatedStorage:FindFirstChild("Framework")
    local codesSystem=codeRemoteRoot and codeRemoteRoot:FindFirstChild("Systems")
    codesSystem=codesSystem and codesSystem:FindFirstChild("CodesSystem")
    local codeRemote=codesSystem and codesSystem:FindFirstChild("CodeRE")
    local codePath=ConfigFolder.."/gcodes_U"..tostring(LocalPlayer.UserId)..".json"
    local dailyPath=ConfigFolder.."/daily_U"..tostring(LocalPlayer.UserId)..".json"
    local function ensureFolder()
        if typeof(writefile)~="function" or typeof(readfile)~="function" then
            return false,"Delta cần readfile + writefile để lưu tiến độ qua reinject"
        end
        if typeof(makefolder)=="function" then
            local ok,err=pcall(function()
                if typeof(isfolder)~="function" or not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
            end)
            if not ok then return false,tostring(err) end
        end
        return true
    end
    local function loadJson(path)
        if typeof(readfile)~="function" then return nil end
        local ok,data=pcall(function()
            if typeof(isfile)=="function" and not isfile(path) then return nil end
            return HttpService:JSONDecode(readfile(path))
        end)
        return ok and type(data)=="table" and data or nil
    end
    local function saveJson(path,data)
        local ready,msg=ensureFolder()
        if not ready then return false,msg end
        local ok,err=pcall(function() writefile(path,HttpService:JSONEncode(data)) end)
        return ok,ok and nil or tostring(err)
    end
    local function label(text,color,h)
        local o=Instance.new("TextLabel")
        o.BackgroundColor3=color or Color3.fromRGB(34,39,57)
        o.BorderSizePixel=0
        o.TextColor3=Color3.fromRGB(225,234,249)
        o.Font=Enum.Font.GothamSemibold
        o.TextSize=14
        o.TextWrapped=true
        o.Size=UDim2.new(.95,0,0,h or 35)
        o.Text=text
        placeCodeWidget(o)
        return o
    end
    local function button(text,color,h,fn)
        local o=Instance.new("TextButton")
        o.BackgroundColor3=color or Color3.fromRGB(50,83,135)
        o.BorderSizePixel=0
        o.TextColor3=Color3.fromRGB(255,255,255)
        o.Font=Enum.Font.GothamBold
        o.TextSize=14
        o.TextWrapped=true
        o.Size=UDim2.new(.95,0,0,h or 43)
        o.Text=text
        placeCodeWidget(o)
        o.MouseButton1Click:Connect(function()
            if not Runtime.Alive then return end
            local ok,err=pcall(fn)
            if not ok then Runtime.Log("CODE_DAILY_UI_ERROR "..tostring(err)) end
        end)
        return o
    end
    local function textbox(placeholder,h)
        local o=Instance.new("TextBox")
        o.Size=UDim2.new(.95,0,0,h or 45)
        o.BackgroundColor3=Color3.fromRGB(47,55,79)
        o.TextColor3=Color3.fromRGB(245,245,251)
        o.PlaceholderColor3=Color3.fromRGB(170,177,198)
        o.BorderSizePixel=0
        o.Font=Enum.Font.Gotham
        o.TextSize=14
        o.TextWrapped=true
        o.ClearTextOnFocus=false
        o.MultiLine=(h or 45)>48
        o.Text=""
        o.PlaceholderText=placeholder
        placeCodeWidget(o)
        return o
    end
    label("01  |  CODE REDEEMER  ·  20 GIÂY / MÃ",Color3.fromRGB(37,69,111),37)
    local codeStatus=label("Đang nạp mã đã lưu...",nil,61)
    local codeBtn
    local defaults=[=[
runekify
Dray28
RIKUSOULS
Ahjughh
T3nsei
Ghifa
ALLWAONIRONSOUL
Sukunay
MERGIXS
SIGURIH
CA2
Lulzsec
druscxlla
MAHAFEY
LALAGANG
Luthador2121
AAM
ToadPlaysGamesTTV
Uzi
TT_Mentally_ill_K.N
luknojo
Zeny
Maple
Fujiesane
VeeruChan
HELOS
LezoCr
ARES
Laplace
Deco
dasher
Nyxaria
ProfGab
SUB2BLAZESTARS
Nothing
Dism
FannTzy
Darkfeniks
Sneptuno
SUPER MBUD
Marcell
Markbhatra
DrekathSenpai
Maníaco_666
smiley
Sine
GT_HANNI
Erijero
DanoNano
WettySNK
obe
Dekday
Qyuu
Gwynne
PapiJoy
Taalonely
Darren
MADUNN
Clipz7112
omjiwa
PaPaX
Ryu
DEI_Yumeko
Chrisss
Gryffin
ARKANGHEL
tony_vt
Ryokenn
ReyPomuchi
Freca
Shan
TT_oratttt
Bebek
Les
SEYUnever
Izumi_Senpai
Staysmoovey
NisardHelpOnlyWoman
Kiota2
LZZ_019BEST
PepCalcot
Astral
Lifauzi
Shirooo0312_IRONSOUL
Ewaa
FRanime_OFFICIEL
WerNate
Ascart
Sweetiee24
Monarch
Aetherix
SUB2MULTIST789
RENZEI100
Skywinter86
Heso
Ghelayyy
Heartguard
ZARGAKSTONE
RaykorBR
xxxDELLJHOYxxx
Aimyoungs
GRAYWOLF
SUB_TO_ITS_HUNTER
Rujika
Alex._.SINN
IronReaper
ERIKSM
reiley
BERLINHERE23
TRADEISLANDUPDATE
IRONSOULWEEKEND27
S4ENDLESSTOWER
Zhien
LacilBlueBerry
BaraWell
qzq
Giovanni_GG
NEXCU
North
Horrortoki
SamudraSelatan
Joy_Blox
minamee
Vinxies
DEYMMM
ChakGIM
fantasmo
Airkub
Leyy
Haruu4you
EvLCrys
AbuelaCalcot
SUB2MARKX4G
SIEGEENDS
HAPPYHALLOWEEN
HALLOWEENBIGEVENT
IRONSOULWEEKEND30
IRONSOULWEEKEND29
X2DROP
IRONSOULWEEKEND28
BOWANDSKILLTREE
IRONNEWUPDATE
LALAGANG
Ahjughh
SEASON2OPEN
]=]
    local codes=loadJson(codePath) or {Codes={},Attempted={},LastSend=0,Enabled=false,Pending={}}
    if type(codes.Codes)~="table" then codes.Codes={} end
    if type(codes.Attempted)~="table" then codes.Attempted={} end
    if type(codes.Pending)~="table" then codes.Pending={} end
    if type(codes.LastSend)~="number" then codes.LastSend=0 end
    codes.Enabled=(codes.Enabled==true)
    local present={}
    local normalized={}
    for _,s in ipairs(codes.Codes) do
        if type(s)=="string" and s~="" then
            local key=s:lower()
            if not present[key] then present[key]=true; normalized[#normalized+1]=s end
        end
    end
    codes.Codes=normalized
    for s in defaults:gmatch("[^\r\n]+") do
        s=s:match("^%s*(.-)%s*$")
        if #s>0 and not present[s:lower()] then
            present[s:lower()]=true;codes.Codes[#codes.Codes+1]=s
        end
    end
    -- Attempt means "request sent", not "server redeemed successfully".
    saveJson(codePath,codes)
    local function codeStats()
        local tried=0
        local nextCode=nil
        for _,c in ipairs(codes.Codes) do
            local key=c:lower()
            if codes.Attempted[key] or codes.Pending[key] then tried=tried+1
            elseif not nextCode then nextCode=c end
        end
        return tried,nextCode
    end
    local function redrawCodes(extra)
        local tried,nextCode=codeStats()
        codeStatus.Text=string.format("Đã gửi hoặc đang chờ xác minh: %d/%d | Còn: %d\nMã kế: %s%s",
            tried,#codes.Codes,#codes.Codes-tried,tostring(nextCode or "HẾT"),extra and ("\n"..extra) or "")
        codeBtn.Text=codes.Enabled and "[ON] ĐANG NHẬP GCODE  ·  BẤM ĐỂ DỪNG" or "[OFF] BẮT ĐẦU / TIẾP TỤC NHẬP"
        codeBtn.BackgroundColor3=codes.Enabled and Color3.fromRGB(27,132,92) or Color3.fromRGB(52,85,145)
    end
    codeBtn=button("BẮT ĐẦU / TIẾP TỤC",nil,45,function()
        if not codes.Enabled then
            local ok,err=ensureFolder()
            if not ok then redrawCodes(err);return end
        end
        codes.Enabled=not codes.Enabled
        local ok,err=saveJson(codePath,codes)
        redrawCodes(ok and nil or err)
    end)
    local addInput=textbox("Nhập GCODE mới (một mã/dòng, hoặc ngăn cách bằng dấu phẩy)",76)
    button("+  THÊM MÃ MỚI VÀO DANH SÁCH",Color3.fromRGB(45,97,157),42,function()
        local n=0
        for s in (addInput.Text.."\n"):gmatch("([^,;\r\n]+)[,;\r\n]") do
            s=s:match("^%s*(.-)%s*$")
            if #s>0 and #s<=90 and not present[s:lower()] then
                present[s:lower()]=true
                codes.Codes[#codes.Codes+1]=s
                n=n+1
            end
        end
        local ok,err=saveJson(codePath,codes)
        redrawCodes("Thêm "..n.." mã"..(not ok and (" | LƯU LỖI "..tostring(err)) or ""))
        if ok then addInput.Text="" end
    end)
    label("Ghi nhớ theo UserId. Mã đã gửi KHÔNG tự gửi lại sau reinject. Gửi remote thành công chưa phải xác nhận code hợp lệ / đã nhận quà.",nil,56)

    -- Event Hall GS_11 redeem is INDEPENDENT of 20s GCodes and Daily Routine.
    -- Remote: Framework.Gameplay.EventHallSystem.EventHallRE
    -- Args: GachaCollectionExchangeBuy, DarkCollectionShop, GS_11.
    label("02  |  EVENT HALL  ·  ĐỔI GS_11  ·  1 GIÂY / LƯỢT",Color3.fromRGB(38,73,117),39)
    local giftPath=ConfigFolder.."/event_gs11_U"..tostring(LocalPlayer.UserId)..".json"
    local gift=loadJson(giftPath) or {Target=0,Sent=0,Enabled=false,LastAttempt=0}
    gift.Target=math.clamp(math.floor(tonumber(gift.Target) or 0),0,1000)
    gift.Sent=math.clamp(math.floor(tonumber(gift.Sent) or 0),0,gift.Target)
    gift.Enabled=false -- REQUIRE manual re-arming after reinject, never silently spend currency.
    gift.LastAttempt=tonumber(gift.LastAttempt) or 0
    if gift.PendingIndex~=nil then
        -- Crash may have happened before or after the RemoteEvent was accepted.
        -- Fail closed against duplicate purchases; report uncertainty clearly.
        gift.Sent=math.max(gift.Sent,tonumber(gift.PendingIndex) or 0)
        gift.PendingIndex=nil
        gift.Uncertain=true
    end
    saveJson(giftPath,gift)
    local giftCount=textbox("Số lần đổi (nhập 1 - 1000)",43)
    giftCount.Text="100"
    local giftStatus=label("Chưa yêu cầu đổi quà.",nil,68)
    local giftBtn
    local function redrawGift(extra)
        local flag=gift.Enabled and "ON" or "OFF"
        giftStatus.Text=string.format("[%s] GS_11: đã gửi %d/%d lần | Cách nhau ≥1 giây\n%s%s",
            flag,gift.Sent,gift.Target,
            gift.Uncertain and "Có lượt không rõ kết quả do ngắt tải. Không tự gửi trùng." or "Chỉ đếm yêu cầu gửi, KHÔNG phải số quà nhận.",
            extra and ("\n"..tostring(extra)) or "")
        giftBtn.Text=gift.Enabled and "[ON] DỪNG ĐỔI QUÀ GS_11" or "[OFF] BẮT ĐẦU / TIẾP TỤC ĐỔI GS_11"
        giftBtn.BackgroundColor3=gift.Enabled and Color3.fromRGB(28,139,91)
            or Color3.fromRGB(46,105,175)
    end
    giftBtn=button("[OFF] BẮT ĐẦU ĐỔI GS_11",Color3.fromRGB(46,105,175),45,function()
        if gift.Enabled then
            gift.Enabled=false
            saveJson(giftPath,gift)
            redrawGift("Đã tạm dừng")
            return
        end
        local requested=tonumber(giftCount.Text)
        if not requested or requested<1 or requested>1000 or requested%1~=0 then
            redrawGift("Hãy nhập số nguyên từ 1 tới 1000")
            return
        end
        local framework=ReplicatedStorage:FindFirstChild("Framework")
        local gameplay=framework and framework:FindFirstChild("Gameplay")
        local eventHall=gameplay and gameplay:FindFirstChild("EventHallSystem")
        local remote=eventHall and eventHall:FindFirstChild("EventHallRE")
        if not (remote and remote:IsA("RemoteEvent")) then
            redrawGift("Không thấy EventHallRE, chưa gửi request nào")
            return
        end
        local okFolder,why=ensureFolder()
        if not okFolder then redrawGift(why);return end
        -- With the same target, OFF/ON resumes the current set of attempts.
        -- A completed set starts a NEW manually requested set.
        if gift.Target~=requested or gift.Sent>=gift.Target then
            gift.Target=requested
            gift.Sent=0
            gift.Uncertain=false
        end
        gift.Enabled=true
        local okSave,errSave=saveJson(giftPath,gift)
        if not okSave then gift.Enabled=false;redrawGift(errSave);return end
        redrawGift("Đã bật: mỗi giây gửi tối đa 1 yêu cầu")
    end)
    label("Cẩn thận: GS_11 có thể tiêu tiền sự kiện. ON là thao tác xác nhận số lượt. OFF dừng sau request hiện tại; kiểm tra quà/tài nguyên trong game.",nil,64)
    local giftNextAt=os.clock()
    task.spawn(function()
        while Runtime.Alive do
            task.wait(.12)
            if Runtime.Alive and gift.Enabled and os.clock()>=giftNextAt then
                if gift.Sent>=gift.Target then
                    gift.Enabled=false
                    saveJson(giftPath,gift)
                    Runtime.Log("EVENT_GS11_COMPLETE attempts="..gift.Sent)
                else
                    local fw=ReplicatedStorage:FindFirstChild("Framework")
                    local gp=fw and fw:FindFirstChild("Gameplay")
                    local ev=gp and gp:FindFirstChild("EventHallSystem")
                    local re=ev and ev:FindFirstChild("EventHallRE")
                    if not (re and re:IsA("RemoteEvent")) then
                        gift.Enabled=false
                        Runtime.Log("EVENT_GS11_MISSING_REMOTE; stopped")
                    else
                        -- Mark pending before send to avoid duplicate purchase after crash.
                        local idx=gift.Sent+1
                        gift.PendingIndex=idx
                        gift.LastAttempt=os.time()
                        local stored=saveJson(giftPath,gift)
                        if not stored then
                            gift.Enabled=false
                            Runtime.Log("EVENT_GS11_PERSIST_FAILED; stopped without send")
                        else
                            giftNextAt=os.clock()+1.05 -- >= 1 second; avoid rate-limit jitter
                            local ok,err=pcall(function()
                                re:FireServer("GachaCollectionExchangeBuy","DarkCollectionShop","GS_11")
                            end)
                            if ok then
                                gift.Sent=idx
                                gift.PendingIndex=nil
                                Runtime.Log("EVENT_GS11_SENT_UNVERIFIED "..idx.."/"..gift.Target)
                            else
                                gift.Enabled=false
                                gift.Uncertain=true
                                Runtime.Log("EVENT_GS11_SEND_ERROR "..tostring(err))
                                gift.Sent=idx -- potentially accepted; do NOT replay blindly
                                gift.PendingIndex=nil
                            end
                            if gift.Sent>=gift.Target then gift.Enabled=false end
                        end
                    end
                    local persisted=saveJson(giftPath,gift)
                    if not persisted then
                        gift.Enabled=false
                        Runtime.Log("EVENT_GS11_POST_SEND_SAVE_FAILED; STOP to avoid untracked repeats")
                    end
                end
                pcall(redrawGift)
            end
        end
    end)
    redrawGift()

    -- Daily Routine lives in the right column, independent of GCodes and GS_11.
    sectionParent=columns[2]
    -- Dedicated persisted daily state. No shared counters with the Dungeon history UI.
    label("03  |  CLONE DAILY ROUTINE  ·  SIEGE 5 → W1 D1 3 → TOWER [DUNGEON TAB]",Color3.fromRGB(79,53,117),42)
    local today=os.date("!%Y-%m-%d")
    local daily=loadJson(dailyPath) or {UserId=LocalPlayer.UserId,Day=today,Siege=0,World1=0,Endless=0,Stage="Siege",Running=false}
    if daily.UserId~=LocalPlayer.UserId then daily={UserId=LocalPlayer.UserId,Day=today,Siege=0,World1=0,Endless=0,Stage="Siege",Running=false} end
    for _,k in ipairs({"Siege","World1","Endless"}) do daily[k]=math.clamp(tonumber(daily[k]) or 0,0,k=="Siege" and 5 or k=="World1" and 3 or 99) end
    if Runtime.TowerGetUsed and daily.Day==today then
        daily.Endless=Runtime.TowerGetUsed()
    end
    if type(daily.Stage)~="string" then daily.Stage="Siege" end
    daily.Running=(daily.Running==true)
    local dailyStatus=label("Đang đọc tiến độ...",nil,100)
    local dailyBtn
    local padInput=textbox("Tọa độ Halloween: X,Y,Z (hoặc đứng trên pad rồi bấm LƯU)",46)
    local function validPad(p)
        if type(p)~="table" or #p~=3 then return false end
        for _,v in ipairs(p) do
            if type(v)~="number" or v~=v or math.abs(v)>1000000 then return false end
        end
        return true
    end
    local function padText(p)
        if not validPad(p) then return "CHƯA LƯU" end
        return string.format("%.2f, %.2f, %.2f",p[1],p[2],p[3])
    end
    if not validPad(daily.SiegePad) then
        -- User-confirmed Halloween lobby entry coordinate, do not raycast/adjust Y.
        daily.SiegePad={-1687.61,-449.25,-1943.59}
    end
    local function saveDaily()
        daily.UserId=LocalPlayer.UserId
        return saveJson(dailyPath,daily)
    end
    local function applyStage()
        if not daily.Running then return end
        if daily.Stage=="Done" then return end
        Runtime.CloneDailyActive=true
        Runtime.CloneDailyTowerActive=(daily.Stage=="Endless")
        Config.AutoCombatPresetEnabled=true
        Config.AutoCreateRole="Solo"
        Config.RunEndAction="AlwaysBackLobby"
        Config.AutoEndlessDeathLobby=true
        Config.AnalyticsEnabled=true -- required for full World1 run-success proof
        Config.AutoEquipBest=false
        Config.AutoSellEquip=false
        Config.AutoForge=false
        Config.AutoClearTrash=false
        Config.AutoTrashSell=false
        Config.AutoFuseRune=false
        if daily.Stage=="Siege" then
            Config.AutoFarm=false -- prevent generic World1 auto-create while in Siege lobby
            Config.AutoAttackTeleport=true -- CLONE combat works without Solo AutoFarm
            Config.CombatMode="CLONE"
            Config.SmartDodge=false
            Runtime.SuppressAutoCreate=true
        elseif daily.Stage=="World1" then
            Config.AutoFarm=true
            Config.AutoAttackTeleport=true
            Config.SelectedWorld="World1"
            Config.SelectedDiff=1
            Config.CombatMode="CLONE"
            Config.SmartDodge=false
            Runtime.SuppressAutoCreate=(daily.Pending~=nil)
        elseif daily.Stage=="Endless" then
            Config.AutoFarm=true
            Config.AutoAttackTeleport=true
            Config.SelectedWorld="Endless1"
            Config.SelectedDiff=1
            Config.CombatMode="MELEE"
            Config.SmartDodge=true
            Runtime.SuppressAutoCreate=(daily.Pending~=nil)
            Config.EndlessEntryEnabled=true
            -- Only enable automated Endless room-2 teleport when recorded coords exist.
            Config.EndlessEntryVerified=Runtime.GetRecordedCoordinate("Endless1",2)~=nil
        end
        if Runtime.AutoCombatSync then pcall(Runtime.AutoCombatSync,true) end
    end
    local function restoreSettings()
        local snap=daily.Snapshot
        if type(snap)=="table" then
            for k,v in pairs(snap) do Config[k]=v end
        end
        daily.Snapshot=nil
        Runtime.CloneDailyActive=false
        Runtime.CloneDailyTowerActive=false
        Runtime.SuppressAutoCreate=false
        if Runtime.AutoCombatSync then pcall(Runtime.AutoCombatSync,true) end
        pcall(saveConfig)
    end
    local function startDaily()
        if not GamePlaceUtil:IsMain() then return false,"Hãy bật routine ở Lobby" end
        if Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled() then
            return false,"Tắt AUTO TOWER độc lập trước khi bật Clone Daily"
        end
        local ready,msg=ensureFolder()
        if not ready then return false,msg end
        if daily.Day~=os.date("!%Y-%m-%d") then
            daily.Day=os.date("!%Y-%m-%d")
            daily.Siege,daily.World1,daily.Endless=0,0,0
            daily.Stage="Siege"
            daily.Pending=nil
        end
        if Runtime.TowerGetUsed then daily.Endless=Runtime.TowerGetUsed() end
        if daily.Stage=="Done" then return false,"Clone Daily đã đủ tiến độ; RESET khi cần." end
        daily.Snapshot={}
        for _,key in ipairs({"AutoFarm","AutoAttackTeleport","AutoCombatPresetEnabled","AutoCreateRole","RunEndAction","AutoEndlessDeathLobby","AnalyticsEnabled","SelectedWorld","SelectedDiff","CombatMode","SmartDodge","AutoEquipBest","AutoSellEquip","AutoForge","AutoClearTrash","AutoTrashSell","AutoFuseRune","EndlessEntryEnabled","EndlessEntryVerified"}) do
            daily.Snapshot[key]=Config[key]
        end
        daily.Running=true
        daily.Error=nil
        daily.Retries=0
        daily.LastIssuedAt=nil
        daily.SiegeLastTryClock=nil
        daily.Paused=false
        local ok,err=saveDaily()
        if not ok then daily.Running=false;return false,err end
        applyStage()
        Runtime.Log("DAILY_START Siege="..daily.Siege.." W1="..daily.World1.." Tower="..daily.Endless)
        return true,"Đã bật; Stage "..daily.Stage
    end
    local function stopDaily(reason)
        daily.Running=false
        daily.Pending=nil
        daily.Entered=false
        daily.Retries=0
        daily.Error=reason or "Manual STOP"
        restoreSettings()
        saveDaily()
        Runtime.Log("DAILY_STOP "..tostring(daily.Error))
    end
    local function commitPending()
        if not daily.Running or not GamePlaceUtil:IsMain() or type(daily.Pending)~="table" then return end
        local p=daily.Pending
        if p.Stage==daily.Stage and type(daily[daily.Stage])=="number" then
            local cap=daily.Stage=="Siege" and 5 or daily.Stage=="World1" and 3 or (Runtime.TowerGetTarget and Runtime.TowerGetTarget() or 3)
            if daily.Stage=="Endless" and Runtime.TowerCloneReturn then
                daily.Endless=Runtime.TowerCloneReturn(daily.Endless)
            else
                daily[daily.Stage]=math.min(cap,daily[daily.Stage]+1)
            end
            Runtime.Log("DAILY_CONFIRMED_IN_LOBBY "..daily.Stage.."="..daily[daily.Stage]
                .." proof="..tostring(p.Proof))
        end
        daily.Pending=nil
        daily.Entered=false
        daily.SiegeStuckSent=nil
        daily.Retries=0
        daily.LastIssuedAt=nil
        daily.SiegeLastTryClock=nil
        daily.HpZeroSince=nil
        daily.NoEnemySince=nil
        if daily.Stage=="Siege" and daily.Siege>=5 then daily.Stage="World1"
        elseif daily.Stage=="World1" and daily.World1>=3 then
            daily.Stage="Endless"
            daily.Endless=Runtime.TowerGetUsed and Runtime.TowerGetUsed() or daily.Endless
        end
        if daily.Stage=="Endless" then
            daily.Endless=Runtime.TowerGetUsed and Runtime.TowerGetUsed() or daily.Endless
            if daily.Endless>=(Runtime.TowerGetTarget and Runtime.TowerGetTarget() or 3) then daily.Stage="Done" end
        end
        if daily.Stage=="Done" then
            daily.Running=false
            restoreSettings()
            daily.Error="HOÀN THÀNH 5 Siege / 3 W1 / "..tostring(daily.Endless).." Tower"
        else applyStage() end
        saveDaily()
    end
    -- The event can show a literal DEAD panel while RemainLife is stale.
    -- Only trust that explicit visible UI when the routine is running in its expected stage.
    function Runtime.DailyExactDead(world)
        if not daily.Running or not daily.Entered then return false end
        if not ((daily.Stage=="Siege" and world=="Siege3")
            or (daily.Stage=="Endless" and world=="Endless1")) then return false end
        for _,node in ipairs(PlayerGui:GetDescendants()) do
            if (node:IsA("TextLabel") or node:IsA("TextButton"))
                and type(node.Text)=="string" and node.Text:upper():match("^%s*DEAD%s*$") then
                local cursor=node
                local shown=true
                while cursor and cursor~=PlayerGui do
                    if cursor:IsA("GuiObject") and not cursor.Visible then shown=false;break end
                    if cursor:IsA("ScreenGui") and not cursor.Enabled then shown=false;break end
                    cursor=cursor.Parent
                end
                if shown then return true end
            end
        end
        return false
    end
    function Runtime.DailyRunSuccess(report)
        if not daily.Running or daily.Pending or daily.Stage~="World1" then return end
        if report and report.Status=="SUCCESS" and report.FullRunTiming==true
            and report.World=="World1" and tonumber(report.Diff)==1 then
            daily.Pending={Stage="World1",Proof="SETTLEMENT",RunId=report.RunId,At=os.time()}
            Runtime.SuppressAutoCreate=true
            saveDaily()
            Runtime.Log("DAILY_W1_CLEAR_PENDING_LOBBY run="..tostring(report.RunId))
        end
    end
    function Runtime.DailyTerminal(world,lives)
        if not daily.Running or daily.Pending or not daily.Entered then return end
        local match=(daily.Stage=="Siege" and world=="Siege3")
            or (daily.Stage=="Endless" and world=="Endless1")
        if not match then return end
        daily.Pending={Stage=daily.Stage,Proof="TERMINAL_DEATH",At=os.time(),Lives=lives}
        Runtime.SuppressAutoCreate=true
        saveDaily()
        Runtime.Log("DAILY_"..daily.Stage.."_TERMINAL_PENDING_LOBBY")
    end
    function Runtime.DailySettlement(world)
        if not daily.Running or daily.Pending or not daily.Entered or daily.Stage~="Endless"
            or world~="Endless1" then return end
        daily.Pending={Stage="Endless",Proof="SETTLEMENT",At=os.time()}
        Runtime.SuppressAutoCreate=true
        saveDaily()
    end
    local function dailyText()
        local status=daily.Running and "ON" or "OFF"
        local pad=padText(daily.SiegePad)
        local notice=daily.Error and ("\n"..tostring(daily.Error):sub(1,125)) or ""
        local used=Runtime.TowerGetUsed and Runtime.TowerGetUsed() or daily.Endless
        local target=Runtime.TowerGetTarget and Runtime.TowerGetTarget() or 3
        local floor=Runtime.TowerGetFloor and Runtime.TowerGetFloor() or 1
        return string.format("[%s] Giai đoạn: %s | Siege %d/5 | W1 D1 %d/3 | Tower %d/%d (Lv %d)\nHalloween pad: %s\nTower tính khi xác nhận vào map; không đếm khi chỉ gửi Create.%s",
            status,tostring(daily.Stage),daily.Siege,daily.World1,used,target,floor,pad,notice)
    end
    local function refreshDaily()
        dailyStatus.Text=dailyText()
        dailyBtn.Text=daily.Running and "[ON] CLONE DAILY ROUTINE  ·  BẤM ĐỂ DỪNG" or "[OFF] BẮT ĐẦU CLONE DAILY ROUTINE"
        dailyBtn.BackgroundColor3=daily.Running and Color3.fromRGB(26,128,89) or Color3.fromRGB(91,61,140)
    end
    dailyBtn=button("[OFF] BẮT ĐẦU CLONE DAILY ROUTINE",Color3.fromRGB(91,61,140),47,function()
        if daily.Running then stopDaily("Manual STOP")
        else
            local ok,msg=startDaily()
            daily.Error=ok and nil or msg
            if not ok then Runtime.Log("DAILY_START_BLOCKED "..tostring(msg)) end
        end
        refreshDaily()
    end)
    button("LƯU HALLOWEEN PAD  ·  LẤY VỊ TRÍ NHÂN VẬT",Color3.fromRGB(54,94,146),43,function()
        if not GamePlaceUtil:IsMain() then daily.Error="Chỉ lưu pad khi ở Lobby";refreshDaily();return end
        local c=LocalPlayer.Character
        local root=c and c:FindFirstChild("HumanoidRootPart")
        if not root then daily.Error="Chưa có HumanoidRootPart";refreshDaily();return end
        local p=root.Position
        daily.SiegePad={p.X,p.Y,p.Z}
        local ok,err=saveDaily()
        daily.Error=ok and "Đã lưu pad: đứng trong vùng kích hoạt Create" or err
        refreshDaily()
    end)
    button("ÁP DỤNG TỌA ĐỘ HALLOWEEN NHẬP TAY",Color3.fromRGB(54,94,146),42,function()
        local nums={}
        for part in padInput.Text:gmatch("[-+]?%d*%.?%d+") do nums[#nums+1]=tonumber(part) end
        if #nums~=3 or not validPad(nums) then
            daily.Error="Nhập chính xác X,Y,Z";refreshDaily();return
        end
        daily.SiegePad=nums
        local ok,err=saveDaily()
        daily.Error=ok and "Đã lưu tọa độ Halloween" or err
        if ok then padInput.Text="" end
        refreshDaily()
    end)
    button("RESET CLONE SIEGE/W1 (TOWER RESET Ở TAB DUNGEON)",Color3.fromRGB(112,72,72),43,function()
        if daily.Running then daily.Error="Tắt Routine trước khi reset";refreshDaily();return end
        daily.Day=os.date("!%Y-%m-%d")
        daily.Siege,daily.World1,daily.Endless=0,0,0
        daily.Stage="Siege";daily.Pending=nil;daily.Entered=false
        daily.Error="Đã reset theo yêu cầu"
        saveDaily();refreshDaily()
    end)
    label("Siege 5 lượt → World1 Diff1 3 lượt → Tower theo Level/Mục tiêu trong TAB Dungeon. Tower trừ lượt khi đã vào map Endless1; vẫn tiếp tục đánh lượt cuối rồi về Lobby.",nil,94)
    -- Keep only one owner of the code worker; each reinjection stops previous Runtime.Alive.
    task.spawn(function()
        while Runtime.Alive do
            task.wait(.6)
            if not Runtime.Alive then break end
            if codes.Enabled then
                local now=os.time()
                if now-(codes.LastSend or 0)>=20 then
                    local _,nextCode=codeStats()
                    if not nextCode then
                        codes.Enabled=false;saveJson(codePath,codes)
                    else
                        local key=nextCode:lower()
                        local remote=codeRemote
                        if not remote or not remote:IsA("RemoteEvent") then
                            local c=ReplicatedStorage:FindFirstChild("Framework")
                            c=c and c:FindFirstChild("Systems")
                            c=c and c:FindFirstChild("CodesSystem")
                            remote=c and c:FindFirstChild("CodeRE")
                            codeRemote=remote
                        end
                        if remote and remote:IsA("RemoteEvent") then
                            -- Write pending BEFORE sending; a client crash must not resend an uncertain code.
                            codes.Pending[key]=now
                            codes.LastSend=now
                            local saved=saveJson(codePath,codes)
                            if saved then
                                local ok,err=pcall(function() remote:FireServer({event="usecode",code=nextCode}) end)
                                if ok then
                                    codes.Attempted[key]=os.time()
                                    codes.Pending[key]=nil
                                    Runtime.Log("CODE_SENT_UNVERIFIED "..nextCode)
                                else
                                    codes.Pending[key]=nil
                                    Runtime.Log("CODE_REMOTE_ERROR "..nextCode.." "..tostring(err))
                                end
                                saveJson(codePath,codes)
                            else
                                codes.Enabled=false
                                Runtime.Log("CODE_PERSIST_FAILED stopped, no remote sent")
                            end
                        end
                    end
                end
            end
        end
    end)
    local lastModeKey=nil
    local function siegeEntry()
        if not validPad(daily.SiegePad) then
            daily.Error="CHỜ TỌA ĐỘ HALLOWEEN: nhập pad trong TAB CODE"
            return
        end
        if not Runtime.Alive or not daily.Running or daily.Stage~="Siege"
            or not GamePlaceUtil:IsMain() or not lobbyCharacterReady() or isTransitioning()
            or Runtime.EntryBusy or Runtime.BatchActive or Runtime.ForgeBusy
            or Runtime.ShopBusy or Runtime.Owner or roomWaitingTeleport() then return end
        local now=os.clock()
        if now-(daily.SiegeLastTryClock or -100000)<7 then return end
        if (daily.Retries or 0)>=3 then
            daily.Error="Siege Create chưa được xác nhận sau 3 request; tạm dừng, không gửi trùng."
            daily.Paused=true
            saveDaily()
            return
        end
        daily.SiegeLastTryClock=now
        Runtime.EntryBusy=true -- same entry/forge mutex as the World worker
        Runtime.EntryDeadline=now+64
        local ok,err=pcall(function()
            local character=LocalPlayer.Character
            local root=assert(character and character:FindFirstChild("HumanoidRootPart"),"Thiếu root")
            local hum=assert(character:FindFirstChildOfClass("Humanoid"),"Thiếu Humanoid")
            local padCF=CFrame.new(table.unpack(daily.SiegePad))
            local pad=padCF.Position
            local gui=PlayerGui:WaitForChild("MainGui",10)
            local native=gui and gui:WaitForChild("ScreenMatch",10)
            assert(gui and native,"Không có MainGui.ScreenMatch để xác nhận Halloween pad")
            local expectedMode=nil
            pcall(function() expectedMode=WorldUtil:GetWorldMode("Siege3") end)
            local function validState()
                assert(Runtime.Alive and daily.Running and daily.Stage=="Siege"
                    and not daily.Pending and GamePlaceUtil:IsMain() and not isTransitioning()
                    and lobbyCharacterReady() and LocalPlayer.Character==character
                    and os.clock()<Runtime.EntryDeadline,"Halloween entry đã hủy/đổi nhân vật")
            end
            local function nativeReady()
                local roomId=LocalPlayer:GetAttribute("EnterRoomId")
                local open=WindowUtil:GetOpenData("ScreenMatch")
                local modeOK=(expectedMode==nil or type(open)~="table"
                    or open.Mode==nil or open.Mode==expectedMode)
                return gui.Enabled and native.Visible and modeOK and roomId~=nil
                    and roomId~=false and tostring(roomId)~=""
            end
            -- If an old draft room is present under the wrong native screen,
            -- do not send CreatRoom. We cannot assume a RoomId alone is enough.
            if not nativeReady() and LocalPlayer:GetAttribute("EnterRoomId") then
                WindowUtil:Close("ScreenMatch")
                waitUntil(function()
                    return not LocalPlayer:GetAttribute("EnterRoomId") or isTransitioning()
                end,5)
            end
            if not nativeReady() then
                local directions={Vector3.new(0,0,-5),Vector3.new(5,0,0),
                    Vector3.new(0,0,5),Vector3.new(-5,0,0)}
                for i,direction in ipairs(directions) do
                    validState()
                    character:PivotTo(padCF) -- user-verified coordinates, no raycast/Y adjustment
                    root.AssemblyLinearVelocity=Vector3.zero
                    root.AssemblyAngularVelocity=Vector3.zero
                    task.wait(.3)
                    validState()
                    hum:MoveTo(pad+direction) -- walk 5 studs to trigger native room selector
                    Runtime.Log("DAILY_SIEGE_PAD_ATTEMPT direction="..i)
                    local ready=waitUntil(function()
                        validState()
                        return nativeReady()
                    end,4)
                    hum:MoveTo(root.Position)
                    if ready then break end
                end
            end
            validState()
            assert(nativeReady(),"Halloween pad chưa mở ScreenMatch + EnterRoomId sau 4 hướng")
            assert((root.Position-pad).Magnitude<16,"Đã rời khỏi Halloween pad trước Create")
            Runtime.Log("DAILY_SIEGE_PAD_READY EnterRoomId="
                ..tostring(LocalPlayer:GetAttribute("EnterRoomId")))
            daily.Retries=(daily.Retries or 0)+1
            daily.LastIssuedAt=os.time()
            daily.Error="Chuẩn bị gửi Siege3 Torment; chờ server nhận phòng"
            local tracked,trackErr=saveDaily()
            assert(tracked,"Không lưu được lượt Siege; không gửi Create: "..tostring(trackErr))
            GameMatchRE:FireServer("CreatRoom","Siege3",4,1) -- exact RemoteSpy args
            Runtime.Log("DAILY_SIEGE_CREATE_SENT attempt="..daily.Retries)
            local accepted=waitUntil(function()
                return roomWaitingTeleport() or isTransitioning() or not GamePlaceUtil:IsMain()
            end,12)
            if accepted then
                Runtime.Log("DAILY_SIEGE_CREATE_ACK WaitTeleport/transition")
                daily.Error=nil
            else
                daily.Error="Siege CreatRoom gửi rồi nhưng chưa có WaitTeleport; không tính lượt"
                Runtime.Log("DAILY_SIEGE_CREATE_UNCONFIRMED attempt="..daily.Retries)
            end
        end)
        Runtime.EntryBusy=false
        daily.SiegeLastTryClock=os.clock()
        if not ok then
            daily.Error="HALLOWEEN PAD/CREATE: "..tostring(err):sub(1,150)
            Runtime.Log("DAILY_SIEGE_ENTRY_ERROR "..tostring(err))
        end
        saveDaily()
    end
    local function dailyTick()
        if not daily.Running then return end
        if daily.Day~=os.date("!%Y-%m-%d") then
            daily.Error="Qua ngày UTC trong khi đang chạy. Tắt rồi reset sau khi kết thúc lượt."
            return
        end
        if GamePlaceUtil:IsMain() then
            if daily.Pending then commitPending() end
            if daily.Running and daily.Stage=="Endless" and not daily.Pending then
                -- Tower attempts are consumed on entry, including early exit.
                local used=Runtime.TowerGetUsed and Runtime.TowerGetUsed() or daily.Endless
                if used~=daily.Endless then daily.Endless=used;daily.Entered=false;saveDaily() end
                if used>=(Runtime.TowerGetTarget and Runtime.TowerGetTarget() or 3) then
                    daily.Stage="Done";daily.Running=false
                    restoreSettings();daily.Error="HOÀN THÀNH CLONE DAILY — TOWER ĐỦ LƯỢT"
                    saveDaily()
                end
            end
            if not daily.Running then return end
            if daily.Paused then return end
            if daily.Stage=="Siege" then
                if not isTransitioning() then siegeEntry() end
            else
                -- Ordinary existing entry worker handles World1 and Endless.
                if lastModeKey~=daily.Stage then
                    applyStage();lastModeKey=daily.Stage
                end
            end
            return
        end
        if isTransitioning() then return end
        local rc=ReplicatedStorage:FindFirstChild("GameRoundCfg")
        local world=rc and rc:GetAttribute("WorldId")
        local expected=daily.Stage=="Siege" and "Siege3" or daily.Stage=="World1" and "World1" or "Endless1"
        if world==expected then
            if not daily.Entered then
                daily.Entered=true
                daily.Retries=0
                daily.Error=nil
                saveDaily()
                Runtime.Log("DAILY_ENTERED "..expected)
            end
            -- Tower exit/clear may provide Settlement without a terminal death.
            if daily.Stage=="Endless" and LocalPlayer:GetAttribute("Settlement")==true then
                Runtime.DailySettlement(world)
            end
            if daily.Stage=="Siege" and not daily.Pending then
                local c=LocalPlayer.Character
                local h=c and c:FindFirstChildOfClass("Humanoid")
                local root=c and c:FindFirstChild("HumanoidRootPart")
                local now=os.clock()
                if h and h.Health<=0 then
                    daily.HpZeroSince=daily.HpZeroSince or now
                else
                    daily.HpZeroSince=nil
                end
                if root and h and h.Health>0 then
                    local found=findNearestEnemy(root.Position,false)
                    if found then daily.NoEnemySince=nil
                    else daily.NoEnemySince=daily.NoEnemySince or now end
                else daily.NoEnemySince=nil end
                if (daily.HpZeroSince and now-daily.HpZeroSince>=30)
                    or (daily.NoEnemySince and now-daily.NoEnemySince>=30) then
                    if WorldRE and not daily.SiegeStuckSent then
                        daily.SiegeStuckSent=true
                        daily.Error="Siege stuck >30s: yêu cầu Lobby; KHÔNG tính lượt chưa DEAD"
                        Runtime.Log("DAILY_SIEGE_STUCK_LOBBY_NOT_COUNTED")
                        WorldRE:FireServer("TeleportWorld","Lobby")
                    end
                end
            end
        end
    end
    -- Reinject: resume only if the persisted flag was ON and the same UTC day.
    if daily.Running and daily.Day==today and daily.Stage~="Done" then
        if Runtime.TowerIsAutoEnabled and Runtime.TowerIsAutoEnabled() and Runtime.TowerAutoStop then
            Runtime.TowerAutoStop("Clone Daily resumed; exclusive entry owner")
        end
        applyStage()
    elseif daily.Running then
        daily.Running=false
        daily.Error="Dữ liệu ngày cũ: dừng để tránh tự chạy sai bộ đếm"
        saveDaily()
    end
    redrawCodes()
    refreshDaily()
    task.spawn(function()
        while Runtime.Alive do
            local ok,err=pcall(dailyTick)
            if not ok then
                daily.Error="DAILY ERROR: "..tostring(err):sub(1,110)
                Runtime.Log(daily.Error)
            end
            task.wait(.7)
        end
    end)
    task.spawn(function()
        while Runtime.Alive do
            task.wait(1)
            if not Runtime.Alive then break end
            pcall(redrawCodes)
            pcall(refreshDaily)
        end
    end)
end
Runtime.InitCodeDailyUI()

-- ============================================================================
-- v4.9.48: FINAL AIO UI ORGANIZER (presentation only, no new game workers).
-- All moved buttons retain their ORIGINAL MouseButton callbacks and GUI state.
-- ============================================================================
function Runtime.FinalizeMonolithicUI()
    local function stash(parent,node)
        if not node or not node.Parent then return end
        local folder=parent:FindFirstChild("RetainedHiddenUI")
        if not folder then
            folder=Instance.new("Folder")
            folder.Name="RetainedHiddenUI"
            folder.Parent=parent
        end
        if node:IsA("GuiObject") then node.Visible=false end
        node.Parent=folder
    end
    local code=Runtime.Tabs.Code
    local canvas=code and code:FindFirstChild("TwoColumnCode")
    local cloneColumn=canvas and canvas:FindFirstChild("DailyRoutine")
    if cloneColumn then
        local order=10000
        local function moveClone(item)
            if not (item and item.Parent) then return end
            order=order+1
            item.LayoutOrder=order
            item.Parent=cloneColumn
            if item:IsA("GuiObject") then
                item.Visible=true
                item.Size=UDim2.new(.95,0,0,math.max(28,item.Size.Y.Offset))
            end
        end
        local title=Instance.new("TextLabel",cloneColumn)
        title.Name="CloneToolsSection"
        title.LayoutOrder=order
        title.Size=UDim2.new(.95,0,0,34)
        title.BackgroundColor3=Color3.fromRGB(43,67,105)
        title.Text="04  |  CLONE FORGE / F.E.B.S"
        title.Font=Enum.Font.GothamBold
        title.TextSize=14
        title.TextColor3=Color3.new(1,1,1)
        local manual=Runtime.CloneForgeUI
        if manual then
            moveClone(manual.Status)
            moveClone(manual.Start)
            moveClone(manual.Stop)
        end
        local utilCanvas=Runtime.Tabs.Utilities:FindFirstChild("DualColumnCanvas")
        local utilWidgets=utilCanvas and utilCanvas:GetDescendants() or {}
        for _,w in ipairs(utilWidgets) do
            if (w:IsA("TextLabel") or w:IsA("TextButton")) and type(w.Text)=="string"
                and (w.Text:find("F.E.B.S — CLONE:",1,true)==1
                    or w.Text:find("CLONE F.E.B.S —",1,true)==1) then
                moveClone(w)
            elseif w:IsA("TextLabel") and type(w.Text)=="string"
                and w.Text:find("F.E.B.S: Weapon cho mọi Ore",1,true)==1 then
                stash(Runtime.Tabs.Utilities,w)
            elseif w:IsA("TextButton") and type(w.Text)=="string"
                and w.Text:find("ULTRA LOW GRAPHICS (CLONE ONLY",1,true)==1 then
                moveClone(w)
            end
        end
    end
    -- The generic auto-balancer split Grocery across two columns. Pin the
    -- complete section to the RIGHT, without reconstructing any buttons.
    local util=Runtime.Tabs.Utilities
    local utilCanvas=util:FindFirstChild("DualColumnCanvas")
    if utilCanvas then
        local right=utilCanvas:FindFirstChild("RightColumn")
        if right then
            local grocery={}
            for _,w in ipairs(utilCanvas:GetDescendants()) do
                if (w:IsA("TextLabel") or w:IsA("TextButton")) and type(w.Text)=="string" then
                    local t=w.Text
                    if t:find("Grocery —",1,true)==1
                        or t:find("AUTO BUY GROCERY 60s",1,true)==1
                        or t:find("Fate Potion |",1,true)==1
                        or t:find("Harvest Potion |",1,true)==1
                        or t:find("Attack Potion |",1,true)==1
                        or t:find("Berserker Potion |",1,true)==1
                        or t:find("Silver Potion (",1,true)==1 then
                        grocery[#grocery+1]=w
                    end
                end
            end
            for _,w in ipairs(grocery) do w.Parent=right end
            Runtime.GroceryUIRightCount=#grocery
        end
    end
    -- Short static labels are enough: every action already has a descriptive
    -- button; runtime status labels (with counts/errors) remain visible.
    local hints={
        "Chọn 1 Mode: CLONE TP",
        "RUSH ON: rút ngắn",
        "XANH LÁ: HẠ CAST",
        "Mỗi vòng: 1 lần Weapon",
        "Nhập Ore ID từ SCAN BAG",
        "MYTHIC: Chọn Lv tối đa",
        "Siege: CLONE, chủ động gây damage",
        "Cẩn thận: GS_11 có thể tiêu tiền",
    }
    for _,tab in ipairs({Runtime.Tabs.Forge,Runtime.Tabs.Combat,Runtime.Tabs.Utilities,Runtime.Tabs.Code}) do
        local removable={}
        for _,node in ipairs(tab:GetDescendants()) do
            if node:IsA("TextLabel") and type(node.Text)=="string" then
                for _,prefix in ipairs(hints) do
                    if node.Text:find(prefix,1,true)==1 then
                        removable[#removable+1]=node
                        break
                    end
                end
            end
        end
        for _,node in ipairs(removable) do stash(tab,node) end
    end
    -- SPIN has only Race 1/2 + Honor now; Hatch source remains dormant.
    local spin=Runtime.Tabs.Spin
    local items={}
    for _,node in ipairs(spin:GetChildren()) do
        if node:IsA("GuiObject") then items[#items+1]=node
        elseif node:IsA("UIListLayout") then node:Destroy() end
    end
    table.sort(items,function(a,b) return a.LayoutOrder<b.LayoutOrder end)
    local panel=Instance.new("Frame",spin)
    panel.Name="TwoColumnSpin"
    panel.Size=UDim2.new(1,-8,0,90)
    panel.BackgroundTransparency=1
    local columns,layouts={},{}
    for i=1,2 do
        local col=Instance.new("Frame",panel)
        col.Name=i==1 and "Race" or "Honor"
        col.BackgroundTransparency=1
        local lay=Instance.new("UIListLayout",col)
        lay.Padding=UDim.new(0,8)
        lay.SortOrder=Enum.SortOrder.LayoutOrder
        lay.HorizontalAlignment=Enum.HorizontalAlignment.Center
        columns[i],layouts[i]=col,lay
    end
    for _,item in ipairs(items) do
        local honor=item:IsA("TextButton") and item.Text:find("HONOR SPIN",1,true)==1
        item.Parent=honor and columns[2] or columns[1]
    end
    local honorHeader=Instance.new("TextLabel",columns[2])
    honorHeader.LayoutOrder=-100
    honorHeader.Text="HONOR SPIN"
    honorHeader.Font=Enum.Font.GothamBold
    honorHeader.TextSize=14
    honorHeader.TextColor3=Color3.fromRGB(233,220,250)
    honorHeader.Size=UDim2.new(.94,0,0,35)
    honorHeader.BackgroundColor3=Color3.fromRGB(60,48,90)
    local function resizeSpin()
        if not Runtime.Alive or not panel.Parent then return end
        local wide=MainFrame.AbsoluteSize.X>=800
        local a,b=layouts[1].AbsoluteContentSize.Y,layouts[2].AbsoluteContentSize.Y
        columns[1].Position=UDim2.new(0,0,0,0)
        columns[1].Size=UDim2.new(wide and .49 or 1,0,0,math.max(a,1))
        columns[2].Position=wide and UDim2.new(.505,0,0,0) or UDim2.new(0,0,0,a+12)
        columns[2].Size=UDim2.new(wide and .49 or 1,0,0,math.max(b,1))
        panel.Size=UDim2.new(1,-8,0,(wide and math.max(a,b) or a+b+12)+16)
    end
    local layout=Instance.new("UIListLayout",spin)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    for _,lay in ipairs(layouts) do
        table.insert(Runtime.Connections,lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeSpin))
    end
    table.insert(Runtime.Connections,MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeSpin))
    task.defer(resizeSpin)
    Runtime.Log("FINAL_UI ready: Clone->CODE, Grocery->UtilitiesRight="..tostring(Runtime.GroceryUIRightCount)
        ..", DPS hidden="..tostring(Runtime.DPSGearUIHiddenCount)..", Hatch dormant, Spin 2-col")
end
Runtime.FinalizeMonolithicUI()

Runtime.ShowTab(Config.ActiveTab)
Runtime.Log("BOOT AIO v4.9.50f | ASTRAL RUSH QERG | COMBAT UI REWORK | BOOT LOCAL SCOPE FIX | STUCK 30S AUTO LOBBY | CLONE TELEPORT | BOSS TARGET | LAST 5 RUNS | DEATH REPLAY | W1 ROOM SYNC")
-- Integrated grocery worker, independent of the displayed tab.
do
    local choices={
        {Key="GroceryFate",Id="GoldShop_24"},
        {Key="GroceryHarvest",Id="GoldShop_25"},
        {Key="GroceryAttack",Id="GoldShop_26"},
        {Key="GroceryBerserker",Id="GoldShop_28"},
        {Key="GrocerySilver",Id="GoldShop_30"}, -- SeasonPotion_1, user-supplied product label
    }
    task.spawn(function()
        local nextCycle=0
        while Runtime.Alive do
            if not Config.GroceryAutoBuy then
                nextCycle=0
                task.wait(0.5)
            elseif os.clock()>=nextCycle then
                nextCycle=os.clock()+60
                local fw=ReplicatedStorage:FindFirstChild("Framework")
                local features=fw and fw:FindFirstChild("Features")
                local shop=features and features:FindFirstChild("ConsumableShopSystem")
                local util=shop and shop:FindFirstChild("ConsumableShopUtil")
                local remote=util and util:FindFirstChild("RemoteEvent")
                local attempted=0
                for _,item in ipairs(choices) do
                    if not Runtime.Alive or not Config.GroceryAutoBuy then break end
                    if Config[item.Key] then
                        if remote and remote:IsA("RemoteEvent") then
                            local ok,err=pcall(function() remote:FireServer("BuyShopItem","Gold",item.Id) end)
                            if ok then attempted=attempted+1
                            else Runtime.Log("GROCERY_SEND_ERROR "..item.Id.." "..tostring(err)) end
                        else Runtime.Log("GROCERY_REMOTE_MISSING (no request sent)") end
                        task.wait(.8)
                    end
                end
                if attempted>0 then Runtime.Log("GROCERY_SENT "..attempted.." requests; server decides stock") end
            else
                task.wait(math.min(1,math.max(.2,nextCycle-os.clock())))
            end
        end
    end)
end
task.spawn(function()
    while Runtime.Alive do
        local w,r,c=Runtime.CurrentRouteInfo()
        simpleLive.Text=string.format("%s, Room %s, Cleared %s",tostring(w or "Lobby"),tostring(r or "-"),tostring(c or "-"))
        task.wait(1.2)
    end
end)

BootStatus("Đã khởi tạo thành công. H để ẩn/hiện AIO.")
task.delay(0.45,function()
    if BootGui and BootGui.Parent then BootGui:Destroy() end
end)
end,function(err)
    local detail=tostring(err)
    if debug and type(debug.traceback)=="function" then
        local ok,tr=pcall(debug.traceback,detail,2)
        if ok then detail=tostring(tr) end
    end
    warn("[IronSoul AIO v4.9.48 BOOT ERROR] "..detail)
    if BootPanel and BootPanel.Parent then BootPanel.Size=UDim2.new(.94,0,0,210) end
    if BootGui and BootGui.Parent then BootGui.Enabled=true end
    BootStatus("LỖI KHỞI TẠO (chụp ảnh gửi em):\n"..detail:sub(1,550))
    return detail
end)
if not BootSucceeded then
    -- Leave the diagnostic overlay visible; never pretend the AIO loaded.
    return
end
