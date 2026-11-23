local _, S = ...

-- Turns guide coordinates into map positions and drives Blizzard's own waypoint
-- (map pin, minimap and on-screen arrow). Also completes "go here" objectives.

local G = S.G
local Vec = CreateVector2D

---------------------------------------------------------------- zone names -> uiMapID
local nameToMap
local function mapByName(name)
    if not nameToMap then
        nameToMap = {}
        if C_Map and C_Map.GetMapInfo then
            for id = 1, 3000 do
                local info = C_Map.GetMapInfo(id)
                if info and info.name then
                    local prev = nameToMap[info.name]
                    -- prefer zones (3) and cities over continents/micro maps
                    if not prev or (info.mapType == 3 and prev.type ~= 3) then
                        nameToMap[info.name] = { id = id, type = info.mapType }
                    end
                end
            end
        end
    end
    local hit = nameToMap[name]
    return hit and hit.id
end

S.MapByName = mapByName

---------------------------------------------------------------- world coordinate order
-- The guide's world coordinates may be (east-west, north-south). Work out once, from the
-- player's own position, which order the map API wants.
local order -- "swap" or "direct"
local function calibrate()
    if order then return order end
    if not (UnitPosition and C_Map.GetMapPosFromWorldPos and C_Map.GetPlayerMapPosition) then return "swap" end
    local p1, p2, _, inst = UnitPosition("player")
    if S.Secret(p1, p2, inst) then return "swap" end
    local mapID = C_Map.GetBestMapForUnit("player")
    local real = mapID and C_Map.GetPlayerMapPosition(mapID, "player")
    if not (p1 and real) then return "swap" end
    local _, pos = C_Map.GetMapPosFromWorldPos(inst, Vec(p1, p2), mapID)
    if pos and math.abs(pos.x - real.x) < 0.01 and math.abs(pos.y - real.y) < 0.01 then
        order = "unitdirect" -- UnitPosition already in API order
    else
        order = "unitswap"
    end
    return order
end

-- guide world coords (a, b) are UnitPosition's (2nd, 1st)
local function guideWorldVec(g)
    local o = calibrate()
    if o == "unitdirect" or o == "swap" then return Vec(g.wb, g.wa) end
    return Vec(g.wa, g.wb)
end

local function playerWorldVec()
    local p1, p2, _, inst = UnitPosition("player")
    if not p1 or S.Secret(p1, p2, inst) then return nil end
    local o = calibrate()
    if o == "unitswap" then return Vec(p2, p1), inst end
    return Vec(p1, p2), inst
end

function S:WorldOrder() return calibrate() end

function S:PlayerWorld()
    local v, inst = playerWorldVec()
    if not v then return nil end
    return v.x, v.y, inst
end

-- resolve a goto to { mapID, x, y (0-1), world = Vector2D, instance }
function S:ResolveGoto(g)
    if not g then return nil end
    if g.resolved then return g.resolved end
    local r
    if g.wa then
        local vec = guideWorldVec(g)
        local mapID, pos = C_Map.GetMapPosFromWorldPos(g.instance, vec, g.mapID)
        if pos then r = { mapID = mapID or g.mapID, x = pos.x, y = pos.y, world = vec, instance = g.instance } end
    else
        local mapID = g.mapID or mapByName(g.zoneName)
        if mapID then
            r = { mapID = mapID, x = g.x / 100, y = g.y / 100 }
            if C_Map.GetWorldPosFromMapPos then
                local inst, world = C_Map.GetWorldPosFromMapPos(mapID, Vec(r.x, r.y))
                r.instance, r.world = inst, world
            end
        end
    end
    if r and order then g.resolved = r end
    return r
end

function S:DistanceTo(g)
    local r = self:ResolveGoto(g)
    if not (r and r.world) then return nil end
    local p, inst = playerWorldVec()
    if not p or inst ~= r.instance then return nil end
    local dx, dy = p.x - r.world.x, p.y - r.world.y
    return math.sqrt(dx * dx + dy * dy)
end

---------------------------------------------------------------- which goto is active
-- Which objective a goto is for. Two ways of writing a step are in use:
--   ".goto A / .complete X / .goto B / .complete Y"  (the step opens with a spot): each spot leads
--      to what follows it, up to the next spot; it's active while any of those is still to do
--   ".complete X / .goto A / .complete Y / .goto B"  (the step opens with an objective): each spot
--      belongs to the objective just before it, active while that one is
-- Route waypoints (radius, 0) drop out once reached either way; a spot with nothing to do after or
-- before it stays active while the step is.
local function leadsWith(self, step)
    if step.leads ~= nil then return step.leads end
    local leads = false
    for _, el in ipairs(step.elements) do
        if el.go and not el.go.route then leads = true break end
        if not el.go and S.IsObjectiveCmd(el.cmd) then break end
    end
    step.leads = leads
    return leads
end
function S:ActiveGoto(step)
    if not step then return nil end
    -- waiting on an earlier "do this first" step: head there
    if step.waitingOn and G.guide then
        local req = G.guide.steps[step.waitingOn]
        if req and req ~= step then return self:ActiveGoto(req) end
    end
    G.reached = G.reached or {}
    local els = step.elements
    local lead = leadsWith(self, step)
    local first, routeCount, routeLeft = nil, 0, 0
    local all = {}                  -- every spot of the step still to do, in order (the map marks the others: 0.90.0)
    local parentActive = nil -- nil = no objective seen yet
    for i, el in ipairs(els) do
        if self:GateOK(el.gate) then
            local g = el.go
            if not g then
                if S.IsObjectiveCmd(el.cmd) then
                    parentActive = self:ElementStatus(step, el) == "active"
                end
            else
                local active
                if lead then
                    -- what this spot leads to: the objectives after it, up to the next spot
                    local any, open = false, false
                    for j = i + 1, #els do
                        local e = els[j]
                        if self:GateOK(e.gate) then
                            if e.go and not e.go.route then
                                if e.go.objective then any = true if self:ElementStatus(step, e) == "active" then open = true end end
                                break
                            end
                            if not e.go and S.IsObjectiveCmd(e.cmd) then
                                any = true
                                if self:ElementStatus(step, e) == "active" then open = true end
                            end
                        end
                    end
                    active = open or not any
                else
                    active = parentActive ~= false
                end
                if g.route then
                    routeCount = routeCount + 1
                    if G.reached[g] then active = false else routeLeft = routeLeft + 1 end
                end
                if g.objective then
                    local done = self:ElementStatus(step, el) == "done"
                    if done then active = false end
                    parentActive = not done
                end
                if active then
                    all[#all + 1] = el
                    if not first then first = el end
                end
            end
        end
    end
-- looping routes start over once every waypoint has been reached
    if not first and step.tags.loop and routeCount > 0 and routeLeft == 0 then
        for _, el in ipairs(els) do
            if el.go then G.reached[el.go] = nil end
        end
        return self:ActiveGoto(step)
    end
    return first, all
end

---------------------------------------------------------------- Blizzard waypoint
local lastTarget, lastSide
local function sideChanged()
    local now = G.activeGoto and G.activeGoto.sideLabel or nil
    if now ~= lastSide then
        lastSide = now
        if S.RefreshGuideUI then C_Timer.After(0, function() pcall(S.RefreshGuideUI, S) end) end
    end
end
local function hasActiveObjective(self, step)
    for _, e in ipairs(step.elements) do
        if (e.cmd == "complete" or e.cmd == "collect") and self:GateOK(e.gate) and self:ElementStatus(step, e) == "active" then
            return true
        end
    end
    return false
end

-- a step you can finish right now wherever it sits in the guide: objectives of quests you hold,
-- or hand-ins of quests that are done. (Pick-ups stay in order: a pick-up can depend on the
-- hand-in before it.)
local function doableNow(self, step)
    local any = false
    for _, e in ipairs(step.elements) do
        if self:GateOK(e.gate) then
            local status = self:ElementStatus(step, e)
            if status == "active" then
                if e.cmd == "complete" or e.cmd == "collect" then
                    any = true
                elseif e.cmd == "turnin" then
                    local id = math.abs(tonumber(e.args[1] or "") or 0)
                    if not (C_QuestLog and C_QuestLog.IsComplete and C_QuestLog.IsComplete(id)) then return false end
                    any = true
                elseif e.cmd == "accept" or e.cmd == "fly" or e.cmd == "hs" or e.cmd == "home" or e.cmd == "train"
                    or e.cmd == "fp" or e.cmd == "zone" or e.cmd == "use" then
                    return false
                end
            end
        end
    end
    return any
end

local function worldOf(self, go)
    local r = go and self:ResolveGoto(go)
    if r and r.world then return r.world.x, r.world.y, r.instance end
end

-- a step that only picks up quests (nothing else to do there)
local function acceptOnly(self, step)
    local any = false
    for _, e in ipairs(step.elements) do
        if self:GateOK(e.gate) and self:ElementStatus(step, e) == "active" then
            if e.cmd == "accept" then any = true
            elseif e.cmd ~= "goto" and e.cmd ~= "target" and e.cmd ~= "mob" then return false end
        end
    end
    return any and not (step.tags and step.tags.requires)
end

local function stepKind(self, step)
    for _, e in ipairs(step.elements) do
        if self:GateOK(e.gate) and self:ElementStatus(step, e) == "active" then
            if e.cmd == "fly" or e.cmd == "hs" or e.cmd == "home" or e.cmd == "train" or e.cmd == "fp"
                or e.cmd == "zone" then return "travel" end
        end
    end
end

local function hasTurnin(self, step)
    for _, e in ipairs(step.elements) do
        if e.cmd == "turnin" and self:GateOK(e.gate) and self:ElementStatus(step, e) == "active" then return true end
    end
end

-- Route order for the next stretch of the guide. The current step and every step in the next
-- few that you can do right now (objectives of quests you hold, hand-ins of finished quests,
-- plain pick-ups) are put in the order that walks the least, ending where the guide goes next.
-- A pick-up never goes before a hand-in written ahead of it (that hand-in may unlock it), and the
-- stretch stops at a hand-in you can't do yet. Returns the step to go to first.
function S:RouteNext(step, el)
    if G.plan then return nil end -- the route planner already picked the order
    if stepKind(self, step) == "travel" then return nil end
    local px, py, pinst = self:PlayerWorld()
    if not px then return nil end
    local function point(st, go)
        go = go or (self:ActiveGoto(st) or {}).go
        local x, y, inst = worldOf(self, go)
        if x and inst == pinst then return x, y end
    end
    local cx, cy = point(step, el.go)
    if not cx then return nil end
    local stops = { { step = step, x = cx, y = cy, order = step.index, current = true } }
    local others, anchor = {}, nil
    local seen = 0
    for i = step.index + 1, #G.guide.steps do
        local ns = G.guide.steps[i]
        if self:IsBlockingStep(ns) and self:GateOK(ns.gate) then
            seen = seen + 1
            if seen > 8 then break end
            local doable, isAccept = doableNow(self, ns), false
            if not doable and acceptOnly(self, ns) then doable, isAccept = true, true end
            if stepKind(self, ns) == "travel" then doable = false end
            local x, y = point(ns)
            if doable and x then
                others[#others + 1] = { step = ns, x = x, y = y, order = i, accept = isAccept, turnin = hasTurnin(self, ns) }
            else
                if not anchor and x then anchor = { x = x, y = y } end
                if hasTurnin(self, ns) or stepKind(self, ns) == "travel" then break end
            end
        end
    end
    if #others == 0 then return nil end
    -- keep the 5 nearest to you
    local function dist(ax, ay, bx, by) return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2) end
    table.sort(others, function(a, b) return dist(px, py, a.x, a.y) < dist(px, py, b.x, b.y) end)
    for i = 1, math.min(5, #others) do stops[#stops + 1] = others[i] end

    local n = #stops
    local used = {}
    local bestCost, firstCost = math.huge, {}
    local function allowed(s)
        if not s.accept then return true end
        for k = 1, n do -- a hand-in written before this pick-up goes first
            local o = stops[k]
            if not used[k] and o.turnin and o.order < s.order then return false end
        end
        return true
    end
    local function walk(depth, lx, ly, cost, first)
        if first and cost >= (firstCost[first] or math.huge) then return end
        if depth > n then
            if anchor then cost = cost + dist(lx, ly, anchor.x, anchor.y) end
            if cost < (firstCost[first] or math.huge) then firstCost[first] = cost end
            if cost < bestCost then bestCost = cost end
            return
        end
        for k = 1, n do
            local s = stops[k]
            if not used[k] and allowed(s) then
                used[k] = true
                walk(depth + 1, s.x, s.y, cost + dist(lx, ly, s.x, s.y), first or s)
                used[k] = nil
            end
        end
    end
    walk(1, px, py, 0, nil)
    -- of the orders that walk (about) the least, start with the stop nearest to you: grab what you pass
    local slack = math.max(40, bestCost * 0.05)
    local bestFirst, bestNear
    for s, c in pairs(firstCost) do
        if c <= bestCost + slack then
            local d = dist(px, py, s.x, s.y)
            if not bestNear or d < bestNear then bestFirst, bestNear = s, d end
        end
    end
    if not bestFirst or bestFirst.current then return nil end
    -- and only change course when it's clearly nearer (no flip-flopping on a few yards)
    if bestNear > dist(px, py, cx, cy) - 20 and (firstCost[stops[1]] or math.huge) <= bestCost + slack then return nil end
    local se = self:ActiveGoto(bestFirst.step)
    if not se then return nil end
    local copy = {}
    for k, v in pairs(se) do copy[k] = v end
    copy.sideLabel = self:StepTitle(bestFirst.step)
    return copy
end

-- The game's own quest area (Guide + my quests and Free; Strict keeps the guide's spot): when the arrow is
-- headed to a spot for a kill/collect objective and the game marks that quest's objective on the map you're
-- on, point at the game's mark instead. Only the arrow (and the line drawn to it) changes; the guide's steps,
-- their order and the router's plan stay as they are. Nothing marked here: the guide's spot, as before.
local areaCache = {} -- quest id -> the go table last handed out (same table while the mark doesn't move)
local function ownerOf(self, step, go)
    local function has(st)
        if not st then return false end
        for _, e in ipairs(st.elements) do if e.go == go then return true end end
        return false
    end
    if has(step) then return step end
    if G.guide then
        for idx in pairs(StewardCharDB.guide.side or {}) do
            local ss = G.guide.steps[idx]
            if has(ss) then return ss end
        end
        for _, ss in ipairs(G.guide.steps) do if has(ss) then return ss end end
    end
end

-- the open kill/collect objective this spot is for: the ones after it up to the next spot, else the one before
local function spotQuest(self, st, go)
    local els, at = st.elements, nil
    for i, e in ipairs(els) do if e.go == go then at = i break end end
    if not at then return nil end
    local function objQuest(e)
        if (e.cmd == "complete" or e.cmd == "collect") and self:GateOK(e.gate) and self:ElementStatus(st, e) == "active" then
            local q = tonumber(e.args and e.args[1])
            return q and math.abs(q) or nil
        end
    end
    for j = at + 1, #els do
        local e = els[j]
        if e.go and not e.go.route then break end
        local q = objQuest(e)
        if q then return q end
    end
    for j = at - 1, 1, -1 do
        local e = els[j]
        if e.go and not e.go.route then break end
        local q = objQuest(e)
        if q then return q end
    end
end

function S:GameAreaGoto(step, el)
    if self:GuideMode() == "strict" then return nil end
    if not (el and el.go) or el.go.route or el.go.objective or el.filler or el.travel then return nil end
    local CQ = C_QuestLog
    if not (CQ and CQ.GetQuestsOnMap and C_Map.GetBestMapForUnit) then return nil end
    local st = ownerOf(self, step, el.go)
    if not st then return nil end
    local q = spotQuest(self, st, el.go)
    if not q or (CQ.IsComplete and CQ.IsComplete(q)) then return nil end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return nil end
    local ok, list = pcall(CQ.GetQuestsOnMap, mapID)
    if not ok or type(list) ~= "table" then return nil end
    for _, info in ipairs(list) do
        if info.questID == q and info.x and info.y and not S.Secret(info.x) then
            local x, y = info.x * 100, info.y * 100
            local g = areaCache[q]
            if not (g and g.mapID == mapID and math.abs(g.x - x) < 0.05 and math.abs(g.y - y) < 0.05) then
                g = { mapID = mapID, x = x, y = y, radius = el.go.radius or 15, gameArea = q }
                areaCache[q] = g
            end
            -- the same table while nothing changes (the travel planner keys on it)
            local c = g.copy
            if not (c and c.guideGo == el.go and c.sideLabel == el.sideLabel) then
                c = {}
                for k, v in pairs(el) do c[k] = v end
                c.go, c.gameArea, c.guideGo = g, q, el.go
                g.copy = c
            end
            return c
        end
    end
end

function S:NearerSideObjective(step, el)
    local routed = self:RouteNext(step, el)
    local base = routed or el
    local curD = base.go and self:DistanceTo(base.go)
    if not curD then return routed end
    if G.plan then return routed end -- side objectives are part of the planned route
    -- objectives running alongside (sticky steps): much closer than where you're headed? do them now
    local best, bestD, bestStep
    for idx in pairs(StewardCharDB.guide.side or {}) do
        local ss = G.guide.steps[idx]
        if ss and ss ~= step and hasActiveObjective(self, ss) then
            local se = self:ActiveGoto(ss)
            local d = se and se.go and self:DistanceTo(se.go)
            if d and d < 900 and d < curD * 0.6 and (not bestD or d < bestD) then best, bestD, bestStep = se, d, ss end
        end
    end
    if not best then return routed end
    local copy = {}
    for k, v in pairs(best) do copy[k] = v end
    copy.sideLabel = self:StepTitle(bestStep)
    return copy
end

-- finished quests whose turn-in is on (or close to) the way to where you're going: hand them in
-- as you pass. Both the "Ready to hand in" quests and turn-ins a few steps ahead in the guide.
function S:HandinOnTheWay(el)
    if not (el and el.go and G.guide) then return nil end
    local px, py, pinst = self:PlayerWorld()
    local tx, ty, tinst = worldOf(self, el.go)
    if not (px and tx) or pinst ~= tinst then return nil end
    local direct = math.sqrt((tx - px) ^ 2 + (ty - py) ^ 2)
    local cands = {}
    if self.ReadyHandins then
        local ok, ready = pcall(self.ReadyHandins, self)
        for _, r in ipairs(ok and ready or {}) do
            if r.go then cands[#cands + 1] = { go = r.go, label = "Hand in: " .. r.name .. (r.target and (" -- " .. r.target) or "") } end
        end
    end
    -- turn-ins coming up in the guide whose quests are already finished
    local CQ = C_QuestLog
    local cur, seen = G.current, 0
    if cur and CQ and CQ.IsComplete and not G.plan then -- (with smart routing these are in the plan already)
        for i = cur.index, #G.guide.steps do
            local st = G.guide.steps[i]
            if self:IsBlockingStep(st) and self:GateOK(st.gate) then
                seen = seen + 1
                if seen > 4 then break end
                local go, target
                for _, e in ipairs(st.elements) do
                    if e.go and not e.go.route and not go then go = e.go end
                    if e.cmd == "target" and e.args[1] and not target then target = e.args[1] end
                end
                for _, e in ipairs(st.elements) do
                    if e.cmd == "turnin" and go and self:GateOK(e.gate) and self:ElementStatus(st, e) == "active" then
                        local id = math.abs(tonumber(e.args[1] or "") or 0)
                        if id > 0 and CQ.IsComplete(id) and st ~= cur then
                            local title = CQ.GetTitleForQuestID and CQ.GetTitleForQuestID(id) or ("quest " .. id)
                            cands[#cands + 1] = { go = go, label = "Hand in: " .. title .. (target and (" -- " .. target) or "") }
                        end
                    end
                end
            end
        end
    end
    local best, bestCost
    for _, c in ipairs(cands) do
        local cx, cy, cinst = worldOf(self, c.go)
        if cx and cinst == pinst then
            local toC = math.sqrt((cx - px) ^ 2 + (cy - py) ^ 2)
            local cToT = math.sqrt((tx - cx) ^ 2 + (ty - cy) ^ 2)
            local detour = toC + cToT - direct
            -- worth it: nearly on the way, or right next to you
            if (detour < 200 or toC < 80) and toC > 8 and (not bestCost or detour < bestCost) then best, bestCost = c, detour end
        end
    end
    if not best then return nil end
    return { go = best.go, sideLabel = best.label }
end

-- An escort under way (you took the quest and the NPC is walking): the step's spot is only
-- where the escort started, so the arrow stops pointing there (or anywhere else) and says
-- who to stay with until the escort is done.
local ESCORT_WORDS = { "escort", "protect", "accompany", "lead ", "follow", "walk .- out", "safely" }
function S:EscortInProgress(step)
    local CQ = C_QuestLog
    if not (step and CQ) then return nil end
    local target
    for _, e in ipairs(step.elements) do
        if e.cmd == "target" and e.args[1] and self:GateOK(e.gate) and not target then
            target = e.args[1]:gsub("::.*$", "")
        end
    end
    for _, e in ipairs(step.elements) do
        if e.cmd == "complete" and self:GateOK(e.gate) and self:ElementStatus(step, e) == "active" then
            local id = math.abs(tonumber(e.args[1] or "") or 0)
            local n = tonumber(e.args[2] or "") or 1
            local held = id > 0 and ((CQ.IsOnQuest and CQ.IsOnQuest(id))
                or (CQ.GetLogIndexForQuestID and (CQ.GetLogIndexForQuestID(id) or 0) > 0))
            if held then
                local text = (e.comment or "") .. " " .. (e.text or "")
                local objs = CQ.GetQuestObjectives and CQ.GetQuestObjectives(id)
                local o = objs and objs[n]
                if not (o and o.finished) then
                    if o and o.text then text = text .. " " .. o.text end
                    if not (o and o.type and o.type ~= "event") then
                        local low = text:lower()
                        for _, w in ipairs(ESCORT_WORDS) do
                            if low:find(w) then return { escort = true, sideLabel = "Stay with " .. (target or "your escort") } end
                        end
                    end
                end
            end
        end
    end
end

-- A ghost running back: the arrow points at your body
-- where you died: indoors (a building or a cave) or under the open sky. Your body's spot has no height, so this says
-- which floor the line goes to when a cave lies under the ground there.
S:On("PLAYER_DEAD", function()
    if not StewardCharDB then return end
    local indoors
    if IsIndoors and IsIndoors() then indoors = true elseif IsOutdoors and IsOutdoors() then indoors = false end
    StewardCharDB.death = { indoors = indoors, t = time and time() or 0 }
end)
function S:CorpseGoto()
    if not (UnitIsGhost and UnitIsGhost("player")) then return nil end
    if not (C_DeathInfo and C_DeathInfo.GetCorpseMapPosition and C_Map.GetBestMapForUnit) then return nil end
    local mapID = C_Map.GetBestMapForUnit("player")
    while mapID do
        local ok, pos = pcall(C_DeathInfo.GetCorpseMapPosition, mapID)
        if ok and pos and pos.x and pos.x > 0 then
            return { go = { mapID = mapID, x = pos.x * 100, y = pos.y * 100, radius = 5 }, sideLabel = "Back to your body", corpse = true }
        end
        local info = C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
        mapID = info and info.parentMapID and info.parentMapID > 0 and info.parentMapID or nil
    end
end

---------------------------------------------------------------- going to someone in your group
-- (Nick 2026-11-15: "route me to my friend in my party"). Picked with "Travel to" on their right-click menu. While
-- set, a second line (Path.lua) goes to where that person is now and follows them as they move, in the colour the
-- game gives them. The guide, its arrow, its travel plan and its own line are left alone (Nick 19:3x: "It should
-- just be a separe line from the quest routing"). Kept over a Reload. Ends when you click it off or they leave.
local follow -- { name = "Name" }
local planFollow -- the trip to them (below)
local function groupUnits()
    local out = {}
    if IsInRaid and IsInRaid() then
        for i = 1, (GetNumGroupMembers and GetNumGroupMembers() or 0) do
            local u = "raid" .. i
            if UnitExists(u) and not UnitIsUnit(u, "player") then out[#out + 1] = u end
        end
    elseif (IsInGroup and IsInGroup()) or (GetNumGroupMembers and (GetNumGroupMembers() or 0) > 0) then
        for i = 1, 4 do
            local u = "party" .. i
            if UnitExists(u) then out[#out + 1] = u end
        end
    end
    return out
end
-- where a group member is, as a world vector the same way round as your own; nil when the game won't say
-- (another instance, a dungeon, offline)
function S:UnitWorld(unit)
    local p1, p2, _, inst = UnitPosition(unit)
    if not p1 or S.Secret(p1, p2, inst) then return nil end
    if calibrate() == "unitswap" then return Vec(p2, p1), inst end
    return Vec(p1, p2), inst
end
-- the members of your group: { { name =, unit =, dist = yards or nil } } in group order
function S:GroupMembers()
    local out = {}
    local me, myInst = playerWorldVec()
    for _, u in ipairs(groupUnits()) do
        local name = UnitName(u)
        if name and not S.Secret(name) and name ~= UNKNOWNOBJECT then
            local v, inst = self:UnitWorld(u)
            local d
            if v and me and inst == myInst then d = math.sqrt((v.x - me.x) ^ 2 + (v.y - me.y) ^ 2) end
            out[#out + 1] = { name = name, unit = u, dist = d, seen = v ~= nil }
        end
    end
    return out
end
local function unitNamed(name)
    for _, u in ipairs(groupUnits()) do
        if UnitName(u) == name then return u end
    end
end
function S:FollowName() return follow and follow.name, follow and follow.lost end
-- the line's colour: the one the game itself gives that person, their class colour (the colour of their name and
-- their dot), read from the game (C_ClassColor / RAID_CLASS_COLORS), never one of ours (Nick 19:39: "can you not
-- read the game's color value and use what it already has?")
local function gameColor(unit)
    local class = unit and select(2, UnitClass(unit))
    if not class or S.Secret(class) then return nil end
    local c
    if C_ClassColor and C_ClassColor.GetClassColor then
        local ok, v = pcall(C_ClassColor.GetClassColor, class)
        if ok then c = v end
    end
    c = c or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class])
    if c and c.r then return { c.r, c.g, c.b }, class end
    if GetClassColor then
        local r, g, b = GetClassColor(class)
        if r then return { r, g, b }, class end
    end
end
function S:FollowColor()
    if not follow then return nil end
    if not follow.color then follow.color, follow.class = gameColor(unitNamed(follow.name)) end
    return follow.color
end

-- "Travel to" on the right-click menu of a party or raid member (their party frame, raid frame or portrait, beside
-- Trade and Duel). The game's newer menus take an added entry through Menu.ModifyMenu; the older drop-down menus
-- through a hook on UnitPopup_ShowMenu that adds one line at the end of the first level.
local function menuName(unit, name)
    if unit and UnitExists(unit) and (UnitInParty(unit) or UnitInRaid(unit)) and not UnitIsUnit(unit, "player") then return UnitName(unit) end
    if name and unitNamed(name) then return name end
end
local function addTravelTo(name)
    local going = follow and follow.name == name
    return going and ("Stop traveling to " .. name) or "Travel to", function()
        if going then S:FollowMember(nil) else S:FollowMember(name) end
    end
end
S.menuDiag = S.menuDiag or {}
if Menu and Menu.ModifyMenu then
    local function modify(_, root, ctx)
        local name = menuName(ctx and ctx.unit, ctx and ctx.name)
        if not name then return end
        local text, fn = addTravelTo(name)
        root:CreateDivider()
        root:CreateButton(text, fn)
    end
    for _, tag in ipairs({ "MENU_UNIT_PARTY", "MENU_UNIT_RAID_PLAYER", "MENU_UNIT_RAID", "MENU_UNIT_PLAYER", "MENU_UNIT_FRIEND" }) do
        local ok = pcall(Menu.ModifyMenu, tag, modify)
        S.menuDiag[tag] = ok
    end
    S.menuDiag.kind = "Menu"
elseif hooksecurefunc and UnitPopup_ShowMenu and UIDropDownMenu_AddButton then
    hooksecurefunc("UnitPopup_ShowMenu", function(_, which, unit, name)
        if (UIDROPDOWNMENU_MENU_LEVEL or 1) ~= 1 then return end
        if which ~= "PARTY" and which ~= "RAID_PLAYER" and which ~= "RAID" and which ~= "PLAYER" and which ~= "FRIEND" then return end
        local who = menuName(unit, name)
        if not who then return end
        local text, fn = addTravelTo(who)
        UIDropDownMenu_AddButton({ text = text, notCheckable = true, func = fn }, 1)
    end)
    S.menuDiag.kind = "UnitPopup"
else
    S.menuDiag.kind = "none"
end
S:On("PLAYER_ENTERING_WORLD", function() if StewardDB then StewardDB.menuDiag = S.menuDiag end end)
function S:FollowMember(name)
    follow = name and { name = name } or nil
    -- kept over a Reload (Nick 19:32: "it's not drawing a trail", after a Reload had dropped it)
    StewardCharDB.followName = name
    if name then self:FollowWorld() pcall(planFollow, true) end
    if self.Path and self.Path.Update then self.Path.Update() end
    if self.RefreshGuideUI then pcall(self.RefreshGuideUI, self) end
end
-- where the member you travel to stands now (world x, y, instance), for the second line; nil when the game won't
-- say. Notes when they've left the group (then it ends).
function S:FollowWorld()
    if not follow then return nil end
    local unit = unitNamed(follow.name)
    if not unit then follow = nil StewardCharDB.followName = nil return nil end -- they left the group
    local v, inst = self:UnitWorld(unit)
    if not v then follow.lost, follow.at = true, nil return nil end
    follow.lost = nil
    follow.at = { x = v.x, y = v.y, inst = inst }
    return v.x, v.y, inst
end
-- yards to them, when they're where you are
function S:FollowDistance()
    local x, y, inst = self:FollowWorld()
    if not x then return nil end
    local px, py, pinst = self:PlayerWorld()
    if not px or pinst ~= inst then return nil end
    return math.floor(math.sqrt((x - px) ^ 2 + (y - py) ^ 2))
end
-- the zone they're in, when the game won't give their exact spot (another continent, too far): its middle, so the
-- trip can still be planned to that zone; planned again the moment their exact spot is known
function S:FollowZoneWorld()
    if not follow then return nil end
    local unit = unitNamed(follow.name)
    local mapID = unit and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit(unit)
    if not mapID or S.Secret(mapID) then return nil end
    local ok, inst, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(0.5, 0.5))
    if not (ok and inst and world) or S.Secret(world.x, world.y, inst) then return nil end
    local info = C_Map.GetMapInfo(mapID)
    return world.x, world.y, inst, mapID, info and info.name  -- the map API's own order, like every world spot here
end

---------------------------------------------------------------- the trip to them: rides on the way
-- The same travel planner as the guide's (Travel.lua): when a flight, the tram, a boat or your hearthstone gets you
-- there sooner than running, the tracker lists the legs and the line goes to where you get on. Planned again every
-- 15 s, when they've moved 150 yd from where it was aimed, and after a zone change, a flight or a ride.
function planFollow(force)
    if not follow or not S.PlanTravelToWorld then return end
    if S.InInstance() or (UnitOnTaxi and UnitOnTaxi("player")) then return end
    local x, y, inst = S:FollowWorld()
    local unit = follow and unitNamed(follow.name)
    if not follow then return end
    local mapID = unit and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit(unit)
    if mapID and S.Secret(mapID) then mapID = nil end
    local zoneName
    if not x then
        local _
        x, y, inst, _, zoneName = S:FollowZoneWorld()
        if not x then follow.travel, follow.zone = nil, nil return end
    end
    -- in the Deeprun Tram (a map of its own, instance 369): the trip goes to the tram's entrance that's quicker to
    -- reach, and the line ends there (Nick 2026-11-21: Xe in the tram, Sterik in Stormwind: no plan, no line)
    local via
    if inst == 369 and S.TRANSPORTS and S.FromGoto then
        local bestT
        for _, tr in ipairs(S.TRANSPORTS) do
            if tr.kind == "tram" then
                for _, side in ipairs({ { tr.a, tr.aName }, { tr.b, tr.bName } }) do
                    local p = S.FromGoto(side[1], side[2])
                    if p then
                        local ok, legs = pcall(S.PlanTravelToWorld, S, p.world, p.instance, follow.name)
                        local px, py, pi = S:PlayerWorld()
                        local direct = px and pi == p.instance and math.sqrt((p.world.x - px) ^ 2 + (p.world.y - py) ^ 2)
                        local secs = ok and legs and legs.total or (direct and direct / 7) or nil
                        if secs and (not bestT or secs < bestT) then
                            bestT, via = secs, { x = p.world.x, y = p.world.y, inst = p.instance, legs = ok and legs or nil, name = side[2] }
                        end
                    end
                end
            end
        end
        zoneName = "the Deeprun Tram"
    end
    local t = follow.planned
    local _, _, pinst = S:PlayerWorld()
    if not force and t and GetTime() - t.at < 15 and t.inst == inst and t.pinst == pinst
        and math.abs(t.x - x) < 150 and math.abs(t.y - y) < 150 then return end
    follow.planned = { at = GetTime(), x = x, y = y, inst = inst, pinst = pinst, map = mapID }
    local ok, legs
    if via then
        ok, legs = true, via.legs
        follow.via = via
    else
        follow.via = nil
        ok, legs = pcall(S.PlanTravelToWorld, S, Vec(x, y), inst, follow.name, mapID)
    end
    if not ok then StewardCharDB.followTravelError = tostring(legs) legs = nil end
    -- nothing planned although they're far away or over the sea: the walks aren't measured yet, most likely. Keep the
    -- trip you had and try again in 2 s, not 15 (Nick 2026-11-22: "nope, still not fuckin routing": the trip to Narla
    -- had been planned, then a fresh try came back empty and the tracker had nothing to show)
    local wasPlanning = follow.planning
    if not legs and not via then
        local px, py, pi = S:PlayerWorld()
        local far = not px or pi ~= inst or (x - px) ^ 2 + (y - py) ^ 2 > 600 * 600
        if far then
            follow.planned.at = GetTime() - 13
            follow.planning = true
            if follow.travel then legs = follow.travel end
        end
    else
        follow.planning = nil
    end
    local before = follow.travel and #follow.travel or 0
    follow.travel, follow.zone = legs, zoneName
    if (legs and #legs or 0) ~= before or legs or wasPlanning ~= follow.planning then
        if S.Path and S.Path.Update then pcall(S.Path.Update) end
        if S.RefreshGuideUI then pcall(S.RefreshGuideUI, S) end
    end
end
-- the legs of the trip (nil: just run to them)
function S:FollowTravel() return follow and follow.travel end
-- far away and no trip worked out yet: still working on it
function S:FollowPlanning() return follow and follow.planning and not follow.travel end
-- they're in the Deeprun Tram: the entrance the trip goes to
function S:FollowVia() return follow and follow.via end
-- the zone they're in when only that is known (the trip is planned to it), or "the Deeprun Tram"
function S:FollowZone() return follow and follow.zone end
-- where the line goes on the way: x, y, instance of the spot to run to first (a flight master, the tram, a dock);
-- false when the next thing is to get on a ride or use your hearthstone where you stand (no line); nil = to them
function S:FollowLeg()
    local legs = follow and follow.travel
    local leg = legs and legs[1]
    if not leg then
        local via = follow and follow.via                 -- they're in the tram: straight to its entrance
        if via then return via.x, via.y, via.inst end
        return nil
    end
    if leg.kind ~= "run" or not leg.target then return false end
    local r = leg.target.go and self:ResolveGoto(leg.target.go)
    if not (r and r.world) then return false end
    return r.world.x, r.world.y, r.instance
end
-- yards to the next place you go: where you get on the first ride, or them
function S:FollowStopDistance()
    local lx, ly, linst = self:FollowLeg()
    if lx == false then return nil end
    if not lx then return self:FollowDistance() end
    local px, py, pinst = self:PlayerWorld()
    if not px or pinst ~= linst then return nil end
    return math.floor(math.sqrt((lx - px) ^ 2 + (ly - py) ^ 2))
end
S:On("ZONE_CHANGED_NEW_AREA", function() C_Timer.After(1, function() planFollow(true) end) end)
S:On("PLAYER_CONTROL_GAINED", function() C_Timer.After(1, function() planFollow(true) end) end)
S:On("TAXIMAP_CLOSED", function() C_Timer.After(1, function() planFollow(true) end) end)

-- after a Reload: back to who you were traveling to, once the group is known
local restoreTries = 0
local function restore()
    local name = StewardCharDB and StewardCharDB.followName
    if follow or not name then return true end
    if unitNamed(name) then
        follow = { name = name }
        if S.Path and S.Path.Update then pcall(S.Path.Update) end
        if S.RefreshGuideUI then pcall(S.RefreshGuideUI, S) end
        return true
    end
    return false
end
S:On("PLAYER_ENTERING_WORLD", function() restoreTries = 20 end)
S:On("GROUP_ROSTER_UPDATE", function() if restoreTries == 0 then restoreTries = 1 end end)
-- what happened, for the next look at your saved data: who, whether the game gives their spot, how far, and what
-- the arrow and the line are doing
local function noteDiag(unit, v)
    local d = StewardCharDB.followDiag or {}
    StewardCharDB.followDiag = d
    d.name, d.seen, d.when = follow.name, v ~= nil, date("%H:%M:%S")
    d.dist = S:FollowDistance()
    local c = S:FollowColor()
    d.class, d.color = follow.class, c and string.format("%.2f %.2f %.2f", c[1], c[2], c[3]) or nil
    local P = S.Path
    if P and P.PartyState then
        local path, _, shown = P.PartyState()
        d.path, d.shown = path ~= nil, shown
    end
    d.arrow = nil
    d.legs = nil
    if follow.travel then
        d.legs = {}
        for i, leg in ipairs(follow.travel) do d.legs[i] = leg.text end
    end
    d.zone = follow.zone
    local pl = follow.planned
    d.at = pl and string.format("them %.0f,%.0f inst %s map %s | you inst %s", pl.x, pl.y, tostring(pl.inst), tostring(pl.map), tostring(pl.pinst)) or nil
    d.via = follow.via and follow.via.name or nil
end

-- follow them as they move (live): the second line aims at them afresh by itself (Path.lua); here, the tracker's
-- "Traveling to" block is kept right
C_Timer.NewTicker(0.5, function()
    if restoreTries > 0 then
        restoreTries = restoreTries - 1
        if restore() then restoreTries = 0 end
    end
    if not follow then return end
    local unit = unitNamed(follow.name)
    local v, inst
    if unit then v, inst = S:UnitWorld(unit) end
    local wasLost = follow.lost == true
    S:FollowWorld()
    if follow then pcall(planFollow) end
    if follow then pcall(noteDiag, unit, v) end
    -- the tracker is laid out again only when what it says changes; the yards count on by themselves
    if not follow or (follow.lost == true) ~= wasLost then
        if S.RefreshGuideUI then pcall(S.RefreshGuideUI, S) end
    elseif S.FollowDistanceLine then
        pcall(S.FollowDistanceLine, S)
    end
end)

-- Go to anywhere (0.83.0, 2026-11-22): a pin you put on the world map yourself (the game's own map pin, not the one
-- Steward puts on the guide's spot) is where you're going: the same trip planner as the guide's (flight paths you know,
-- boats, zeppelins, the tram, portals, your hearthstone, running) plans the way there, the tracker lists the legs, and
-- the arrow and the line go to the first stop. The guide waits; Steward takes the pin off when you get there (or take
-- it off yourself) and goes back to the guide.
local pinEl                 -- the destination of your pin, kept while the pin stays (so the trip isn't planned anew)
function S:UserPin()
    if not (C_Map and C_Map.HasUserWaypoint and C_Map.GetUserWaypoint) or not C_Map.HasUserWaypoint() then pinEl = nil return nil end
    local pt = C_Map.GetUserWaypoint()
    local pos = pt and pt.position
    if not (pt and pt.uiMapID and pos and pos.x and pos.y) or S.Secret(pt.uiMapID, pos.x, pos.y) then pinEl = nil return nil end
    local own = S.stewardPin or (StewardCharDB and StewardCharDB.stewardPin)   -- the last pin Steward put on the map itself
    if own and own[1] == pt.uiMapID and math.abs(own[2] - pos.x) < 0.002 and math.abs(own[3] - pos.y) < 0.002 then
        pinEl = nil
        return nil
    end
    local x, y = pos.x * 100, pos.y * 100
    if not (pinEl and pinEl.pinMap == pt.uiMapID and math.abs(pinEl.pinX - x) < 0.05 and math.abs(pinEl.pinY - y) < 0.05) then
        pinEl = { go = { mapID = pt.uiMapID, x = x, y = y }, pin = true, friendName = "your map pin", sideLabel = "Go to your map pin",
                  pinMap = pt.uiMapID, pinX = x, pinY = y }
        -- a pin by an entrance that lies under other floors (the Hall of Thanes under Ironforge): that entrance and its
        -- floor, not the street over it (0.88.2; Path3D.lua P3.ENTRANCES)
        local P3 = S.Path3D
        if P3 and P3.EntranceNear and C_Map.GetWorldPosFromMapPos and C_Map.GetMapPosFromWorldPos then
            local ok, inst, world = pcall(C_Map.GetWorldPosFromMapPos, pt.uiMapID, pos)
            if ok and inst and world and not S.Secret(inst, world.x, world.y) then
                local swap = S:WorldOrder() == "unitswap"
                local n, w = world.x, world.y
                if swap then n, w = world.y, world.x end
                local e = P3.EntranceNear(inst, n, w)
                if e then
                    local v = swap and CreateVector2D(e[2], e[1]) or CreateVector2D(e[1], e[2])
                    local ok2, m, mp = pcall(C_Map.GetMapPosFromWorldPos, inst, v, pt.uiMapID)
                    if ok2 and mp and mp.x then
                        pinEl.go = { mapID = pt.uiMapID, x = mp.x * 100, y = mp.y * 100 }
                        pinEl.landG = e[3]
                        if e[4] then
                            pinEl.friendName, pinEl.sideLabel = "the " .. e[4] .. " entrance", "Go to the " .. e[4] .. " entrance"
                        end
                    end
                end
            end
        end
    end
    return pinEl
end
S.PIN_ARRIVED = 15            -- yards: you're there, the pin comes off

-- 0.90.2: no changes to the game's map pin in a fight while the world map is open. Blizzard's waypoint and quest pin
-- providers listen for USER_WAYPOINT_UPDATED / SUPER_TRACKING_CHANGED only while the map is shown, and redraw at once
-- from inside Steward's call: AcquirePin -> CheckMouseButtonPassthrough -> SetPassThroughButtons, protected in combat,
-- so the game blocks it once per pin and blames Steward (20 at 18:46:26 on 0.88.8, after 0.88.5 stopped the map
-- opening in a fight). The change waits for the fight's end or the map closing, then UpdateWaypoint puts it right.
local pinWaiting = false
local function mapBusy()
    local wm = _G.WorldMapFrame
    return InCombatLockdown and InCombatLockdown() and wm and wm.IsShown and wm:IsShown() and true or false
end
local function clearPin()
    if mapBusy() then pinWaiting = true return false end
    if C_Map.ClearUserWaypoint then pcall(C_Map.ClearUserWaypoint) end
    return true
end
S.MapPinBusy = mapBusy

function S:UpdateWaypoint()
    local corpse = self:CorpseGoto()
    if corpse then
        G.stepGoto, G.travel, G.travelPending = nil, nil, nil
        G.activeGoto = corpse
        sideChanged()
        if self.UpdateArrow then self:UpdateArrow() end
        if lastTarget and C_Map.ClearUserWaypoint and clearPin() then lastTarget = nil end
        return
    end
    local pin = self:UserPin()
    if pin then
        local d = self:DistanceTo(pin.go)
        if d and d < self.PIN_ARRIVED and clearPin() then   -- you're there: back to the guide (after the fight, map open)
            pinEl, pin = nil, nil
        end
    end
    if pin then
        G.stepGoto = pin
        lastTarget = nil                           -- Steward's own pin goes back on once yours is gone
        if self.RefreshTravel then self:RefreshTravel() end
        local el = pin
        if G.travel and G.travel[1] then
            local leg = G.travel[1]
            el = (leg.kind ~= "hearth" and leg.kind ~= "teleport") and { go = leg.target.go, travel = true } or nil
        end
        G.activeGoto = el
        sideChanged()
        if self.UpdateArrow then self:UpdateArrow() end
        return
    end
    if not self:Get("guideShow") then
        -- the guide is off: no step to go to, no travel planned for one, no pin of Steward's on the map
        G.stepGoto, G.travel, G.travelPending, G.activeGoto = nil, nil, nil, nil
        sideChanged()
        if self.UpdateArrow then self:UpdateArrow() end
        if lastTarget and C_Map.ClearUserWaypoint and clearPin() then lastTarget = nil end
        return
    end
    if self:GuideMode() == "free" then
        local el = self.FreeGoto and self:FreeGoto()
        G.stepGoto = el
        if self.RefreshTravel then self:RefreshTravel() end
        if G.travel and G.travel[1] then
            local leg = G.travel[1]
            el = (leg.kind ~= "hearth" and leg.kind ~= "teleport") and { go = leg.target.go, travel = true } or nil
        end
        G.activeGoto = el
        sideChanged()
        if self.UpdateArrow then self:UpdateArrow() end
        if not (C_Map.SetUserWaypoint and UiMapPoint) then return end
        if not el or not self:Get("guideShow") then
            if lastTarget and clearPin() then lastTarget = nil end
            return
        end
        local r = self:ResolveGoto(el.go)
        if not r then return end
        local tkey = string.format("%d:%.3f:%.3f", r.mapID or 0, r.x or 0, r.y or 0)
        if lastTarget == tkey then return end
        if mapBusy() then pinWaiting = true return end
        if C_Map.CanSetUserWaypointOnMap and not C_Map.CanSetUserWaypointOnMap(r.mapID) then return end
        if pcall(C_Map.SetUserWaypoint, UiMapPoint.CreateFromCoordinates(r.mapID, r.x, r.y)) then lastTarget = tkey S.stewardPin = { r.mapID, r.x, r.y } StewardCharDB.stewardPin = S.stewardPin end
        return
    end
    local step = G.current
    local el = self:ActiveGoto(step)
    local escort = self:EscortInProgress(step)
    if not escort and G.guide then
        for idx in pairs(StewardCharDB.guide.side or {}) do
            escort = self:EscortInProgress(G.guide.steps[idx])
            if escort then break end
        end
    end
    if escort then
        G.stepGoto = nil
        G.travel, G.travelPending = nil, nil
        G.activeGoto = escort
        sideChanged()
        if self.UpdateArrow then self:UpdateArrow() end
        if lastTarget and C_Map.ClearUserWaypoint and clearPin() then lastTarget = nil end
        return
    end
    -- behind on levels: extra quests nearby instead of a grind spot
    if self.FillerGoto then
        local ok, f = pcall(self.FillerGoto, self)
        if ok and f then el = f elseif not ok then self:LogError("filler", f) end
    end
    if not el and G.guide then
        for idx in pairs(StewardCharDB.guide.side or {}) do
            el = self:ActiveGoto(G.guide.steps[idx])
            if el then break end
        end
    end
    -- an objective running alongside that's much closer than this step's spot: do it first
    -- (finish the whelps while you're among them, then go back for the last brutes)
    -- (Strict: the guide's own order, no detours)
    if el and step and G.guide and not el.filler and self:GuideMode() == "guide" then
        local ok, near = pcall(self.NearerSideObjective, self, step, el)
        if ok and near then el = near elseif not ok then self:LogError("route order", near) end
        local ok2, handin = pcall(self.HandinOnTheWay, self, el)
        if ok2 and handin then el = handin elseif not ok2 then self:LogError("handin route", handin) end
    end
    -- the game's own mark for this objective, where it has one (not in Strict)
    if el and step and G.guide then
        local ok, area = pcall(self.GameAreaGoto, self, step, el)
        if ok and area then el = area elseif not ok then self:LogError("quest area", area) end
    end
    G.stepGoto = el
    if self.RefreshTravel then self:RefreshTravel() end
    if G.travel and G.travel[1] then
        local leg = G.travel[1]
        el = (leg.kind ~= "hearth" and leg.kind ~= "teleport") and { go = leg.target.go, travel = true } or nil
    end
    G.activeGoto = el
    sideChanged()
    if self.UpdateArrow then self:UpdateArrow() end
    if not (C_Map.SetUserWaypoint and UiMapPoint) then return end
    if not el or not self:Get("guideShow") then
        if lastTarget and clearPin() then lastTarget = nil end
        return
    end
    local r = self:ResolveGoto(el.go)
    if not r then return end
    local tkey = string.format("%d:%.3f:%.3f", r.mapID or 0, r.x or 0, r.y or 0)
    if lastTarget == tkey then return end
    if mapBusy() then pinWaiting = true return end
    if C_Map.CanSetUserWaypointOnMap and not C_Map.CanSetUserWaypointOnMap(r.mapID) then return end
    local ok = pcall(function()
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(r.mapID, r.x, r.y))
        S.stewardPin = { r.mapID, r.x, r.y }        -- Steward's own pin (never taken for yours)
        StewardCharDB.stewardPin = S.stewardPin        -- remembered over a Reload
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
    end)
    if ok then lastTarget = tkey end
end

-- the pin change that waited (0.90.2): after the fight, or as soon as the map closes
local function pinCatchUp()
    if not pinWaiting or mapBusy() then return end
    pinWaiting = false
    local ok, err = pcall(S.UpdateWaypoint, S)
    if not ok then S:LogError("waypoint after the fight", err) end
end
S:On("PLAYER_REGEN_ENABLED", pinCatchUp)
C_Timer.NewTicker(0.5, function() if pinWaiting then pinCatchUp() end end)
S._pinWaitingForTests = function() return pinWaiting end

---------------------------------------------------------------- the step's other spots on the world map (0.90.0)
-- Nick 2026-11-22 ("show the rest of a multi-waypoint step on the map"): the spot Steward is taking you to has the
-- game's own pin; every other spot of the step that is still to do gets a small gold dot on the world map, so you can
-- see where the step goes next (kill here, then there). Plain textures on a frame over the map's canvas: no map pins
-- (a pin added by an add-on can be blocked in a fight, 0.88.5). Setting `mapStepSpots`. Since 0.90.1 the minimap too.
local spotFrame, spotDots, spotKey = nil, {}, nil
function S:StepSpots()
    local out = {}
    if not (self:Get("guideShow") and self:Get("mapStepSpots") ~= false and G.guide and G.current) then return out end
    if self:GuideMode() == "free" then return out end
    local ok, _, all = pcall(self.ActiveGoto, self, G.current)
    if not ok or not all then return out end
    local here = G.stepGoto and G.stepGoto.go
    local hr = here and self:ResolveGoto(here)
    for _, el in ipairs(all) do
        local g = el.go
        if g and g ~= here then
            local r = self:ResolveGoto(g)
            -- the same spot as the pin (a step that names it twice): no dot under the pin
            local same = r and hr and r.mapID == hr.mapID and math.abs((r.x or 0) - (hr.x or 0)) < 0.002 and math.abs((r.y or 0) - (hr.y or 0)) < 0.002
            if r and not same then out[#out + 1] = r end
        end
    end
    return out
end
local function hideSpots()
    for i = 1, #spotDots do spotDots[i].fill:Hide() spotDots[i].ring:Hide() end
end
local function drawSpots()
    local wm = _G.WorldMapFrame
    if not (wm and wm.GetCanvas and wm.IsShown and wm:IsShown()) then hideSpots() return end
    local mapID = wm.GetMapID and wm:GetMapID()
    local canvas = wm:GetCanvas()
    if not (mapID and type(canvas) == "table" and canvas.GetWidth) then hideSpots() return end
    local list = S:StepSpots()
    if not spotFrame then
        spotFrame = CreateFrame("Frame", nil, canvas)
        spotFrame:SetAllPoints(canvas)
    end
    spotFrame:SetFrameStrata(canvas:GetFrameStrata())
    spotFrame:SetFrameLevel(2020)
    spotFrame:Show()
    local cw, ch = canvas:GetWidth(), canvas:GetHeight()
    local scale = 1
    if spotFrame.GetEffectiveScale and UIParent.GetEffectiveScale then
        local a, b = spotFrame:GetEffectiveScale(), UIParent:GetEffectiveScale()
        if a and b and a > 0 and b > 0 then scale = a / b end
    end
    local used = 0
    for _, r in ipairs(list) do
        local x, y
        if r.mapID == mapID then
            x, y = r.x, r.y
        elseif r.world and r.instance and C_Map.GetMapPosFromWorldPos then
            local ok, m, pos = pcall(C_Map.GetMapPosFromWorldPos, r.instance, r.world, mapID)
            if ok and m == mapID and pos then x, y = pos.x, pos.y end
        end
        if x and y and x >= 0 and x <= 1 and y >= 0 and y <= 1 then
            used = used + 1
            local d = spotDots[used]
            if not d then
                d = { ring = spotFrame:CreateTexture(nil, "OVERLAY", nil, 6), fill = spotFrame:CreateTexture(nil, "OVERLAY", nil, 7) }
                d.ring:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
                d.ring:SetVertexColor(0, 0, 0, 0.8)
                d.fill:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
                d.fill:SetVertexColor(1, 0.82, 0.1, 1)
                spotDots[used] = d
            end
            d.ring:SetSize(13 / scale, 13 / scale)
            d.fill:SetSize(9 / scale, 9 / scale)
            d.ring:ClearAllPoints()
            d.ring:SetPoint("CENTER", spotFrame, "TOPLEFT", x * cw, -y * ch)
            d.fill:ClearAllPoints()
            d.fill:SetPoint("CENTER", spotFrame, "TOPLEFT", x * cw, -y * ch)
            d.ring:Show() d.fill:Show()
        end
    end
    for i = used + 1, #spotDots do spotDots[i].fill:Hide() spotDots[i].ring:Hide() end
    S.stepSpotsShown = used
end
function S._spotDotsForTests() return spotDots end
function S:RefreshStepSpots()
    local ok, err = pcall(drawSpots)
    if not ok then self:LogError("step spots", err) hideSpots() end
end
-- redrawn when the map opens, changes or zooms, and while it is open whenever the step's spots change
local spotsHooked = false
local function hookSpots()
    if spotsHooked then return end
    local wm = _G.WorldMapFrame
    if not (wm and wm.GetCanvas) then return end
    spotsHooked = true
    local function redraw() spotKey = nil S:RefreshStepSpots() end
    if wm.HookScript then wm:HookScript("OnShow", redraw) end
    if wm.OnMapChanged then hooksecurefunc(wm, "OnMapChanged", redraw) end
    if wm.OnCanvasScaleChanged then hooksecurefunc(wm, "OnCanvasScaleChanged", redraw) end
end
-- and on the minimap (0.90.1): the same dots, smaller, for the spots inside it, moved as you move (every 0.1 s; the
-- list itself is worked out again every half second)
local miniSpots, miniDots, miniFrameS = {}, {}, nil
local function hideMiniSpots() for i = 1, #miniDots do miniDots[i].fill:Hide() miniDots[i].ring:Hide() end end
local function drawMiniSpots()
    local P = S.Path
    local used = 0
    if #miniSpots > 0 and P and P.MiniSpot then
        for _, r in ipairs(miniSpots) do
            local w = r.world
            local sx, sy, inside, mm = P.MiniSpot(w and w.x, w and w.y, r.instance)
            if sx and inside then
                if not miniFrameS then
                    miniFrameS = CreateFrame("Frame", nil, mm)
                    miniFrameS:SetAllPoints(mm)
                    miniFrameS:SetFrameLevel((mm:GetFrameLevel() or 0) + 4)
                end
                used = used + 1
                local d = miniDots[used]
                if not d then
                    d = { ring = miniFrameS:CreateTexture(nil, "OVERLAY", nil, 6), fill = miniFrameS:CreateTexture(nil, "OVERLAY", nil, 7) }
                    d.ring:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
                    d.ring:SetVertexColor(0, 0, 0, 0.8)
                    d.ring:SetSize(10, 10)
                    d.fill:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
                    d.fill:SetVertexColor(1, 0.82, 0.1, 1)
                    d.fill:SetSize(7, 7)
                    miniDots[used] = d
                end
                d.ring:ClearAllPoints() d.ring:SetPoint("CENTER", miniFrameS, "CENTER", sx, sy)
                d.fill:ClearAllPoints() d.fill:SetPoint("CENTER", miniFrameS, "CENTER", sx, sy)
                d.ring:Show() d.fill:Show()
            end
        end
    end
    for i = used + 1, #miniDots do miniDots[i].fill:Hide() miniDots[i].ring:Hide() end
    S.stepSpotsMini = used
end
function S:RefreshMiniSpots(again)
    if again then
        local ok, list = pcall(self.StepSpots, self)
        miniSpots = ok and list or {}
    end
    local ok, err = pcall(drawMiniSpots)
    if not ok then self:LogError("step spots (minimap)", err) hideMiniSpots() miniSpots = {} end
end
S._miniDotsForTests = function() return miniDots end
C_Timer.NewTicker(0.1, function() if #miniSpots > 0 or (S.stepSpotsMini or 0) > 0 then S:RefreshMiniSpots(false) end end)
C_Timer.NewTicker(0.5, function() S:RefreshMiniSpots(true) end)
C_Timer.NewTicker(0.5, function()
    local ok = pcall(hookSpots)
    local wm = _G.WorldMapFrame
    if not (ok and wm and wm.IsShown and wm:IsShown()) then return end
    -- what would be drawn: redraw only when it changes
    local key = tostring(G.current) .. "|" .. tostring(G.stepGoto and G.stepGoto.go) .. "|" .. tostring(wm.GetMapID and wm:GetMapID())
    local okS, list = pcall(S.StepSpots, S)
    if okS then for _, r in ipairs(list) do key = key .. "|" .. tostring(r.x) .. "," .. tostring(r.y) end end
    if key ~= spotKey then spotKey = key S:RefreshStepSpots() end
end)

---------------------------------------------------------------- position ticker
C_Timer.NewTicker(0.5, function()
    if UnitOnTaxi("player") or S.InInstance() then return end
    local guideOn = G.guide and S:Get("guideShow")
    local pinTrip = G.stepGoto and G.stepGoto.pin and G.stepGoto
    if not (guideOn or pinTrip) then return end   -- your map pin's trip runs with the guide off too
    local changed = false
    local steps = {}
    if guideOn and G.current then steps[1] = G.current end
    if guideOn then
        for idx in pairs((StewardCharDB.guide and StewardCharDB.guide.side) or {}) do steps[#steps + 1] = G.guide.steps[idx] end
    end
    for _, step in ipairs(steps) do
        for _, el in ipairs(step.elements) do
            local g = el.go
            if g and g.radius and g.radius > 0 and S:GateOK(el.gate) then
                local d = S:DistanceTo(g)
                if d and d <= g.radius then
                    if g.route and not G.reached[g] then G.reached[g] = true changed = true end
                    if g.objective then
                        local key = step.index .. ":" .. el.index
                        local ev = StewardCharDB.guide.events or {}
                        if not ev[key] then S:MarkEvent(step.index, el.index) changed = true end
                    end
                end
            end
        end
    end
    -- steps with nothing to tick off complete when you get to their spot
    local cur = guideOn and G.current
    if cur then
        local _, _, manual = S:StepStatus(cur)
        if manual == "reach" then
            local spot = S:StepSpot(cur)
            local d = spot and S:DistanceTo(spot.go)
            if d and d <= math.max(spot.go.radius or 0, 25) then
                S:MarkEvent(cur.index, "reach")
                changed = true
            end
        end
    end
    -- at your map pin: it comes off (UpdateWaypoint) and the guide, if shown, carries on
    if pinTrip then
        local d = S:DistanceTo(pinTrip.go)
        if d and d < S.PIN_ARRIVED then changed = true end
    end
    local a = G.activeGoto
    if a and a.travel then
        local d = S:DistanceTo(a.go)
        if d and d <= 20 then changed = true S.travelLegReached = true end
    end
    if changed then
        if S.travelLegReached and S.ReplanTravel then S.travelLegReached = nil S:ReplanTravel() else S:UpdateGuide() end
    elseif S.RefreshDistance then S:RefreshDistance() end
end)

for _, e in ipairs({ "PLAYER_DEAD", "PLAYER_ALIVE", "PLAYER_UNGHOST", "CORPSE_POSITION_UPDATE" }) do
    S:On(e, function() C_Timer.After(0.5, function() pcall(S.UpdateWaypoint, S) end) end)
end
-- you put a pin on the map, moved it or took it off: plan again at once
S:On("USER_WAYPOINT_UPDATED", function()
    if S.ReplanTravel then C_Timer.After(0.1, S.ReplanTravel) elseif S.UpdateWaypoint then S:UpdateWaypoint() end
end)
