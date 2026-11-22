local _, S = ...

-- Free mode: no guide. You pick up the quests you want; Steward plans the shortest way through
-- what's in your quest log: each quest's objectives (where the game marks them on the map), then
-- its hand-in (who takes it, from Steward's quest data). The same route solver as smart routing
-- puts the stops in order, an objective always before its hand-in. Quests the game gives no spot
-- for on this map, and hand-ins on another continent, are listed but not routed.

local G = S.G

local function dist(ax, ay, bx, by)
    local dx, dy = ax - bx, ay - by
    return math.sqrt(dx * dx + dy * dy)
end

local function title(qid)
    local fn = C_QuestLog and C_QuestLog.GetTitleForQuestID
    return fn and fn(qid) or ("quest " .. qid)
end

-- quests in your log: { id, complete }
local function logQuests()
    local out, CQ = {}, C_QuestLog
    if not (CQ and CQ.GetNumQuestLogEntries and CQ.GetInfo) then return out end
    for i = 1, CQ.GetNumQuestLogEntries() or 0 do
        local info = CQ.GetInfo(i)
        if info and not info.isHeader and info.questID and info.questID > 0 and not info.isHidden then
            out[#out + 1] = { id = info.questID, complete = CQ.IsComplete and CQ.IsComplete(info.questID) or false }
        end
    end
    return out
end

-- where the game marks each quest's objectives on the map you're on
local function objectiveSpots(mapID)
    local out, CQ = {}, C_QuestLog
    if not (mapID and CQ and CQ.GetQuestsOnMap) then return out end
    local ok, list = pcall(CQ.GetQuestsOnMap, mapID)
    for _, q in ipairs(ok and list or {}) do
        if q.questID and q.x and q.y then
            out[q.questID] = { mapID = mapID, x = q.x * 100, y = q.y * 100, radius = 15, objective = true }
        end
    end
    return out
end

local function world(go)
    local r = go and S:ResolveGoto(go)
    if r and r.world then return r.world.x, r.world.y, r.instance end
end

-- the plan: G.free = { stops = { {kind, qid, label, go}, ... }, unplaced = { names } }
function S:FreePlan()
    G.free = nil
    if self:GuideMode() ~= "free" or (S.InInstance and S.InInstance()) then return nil end
    local px, py, pinst = self:PlayerWorld()
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local spots = objectiveSpots(mapID)
    local nodes, unplaced = {}, {}
    local n = 0
    local function add(kind, qid, label, go, pred)
        local x, y, inst = world(go)
        if not (x and px and inst == pinst) then return nil end
        n = n + 1
        local node = { x = x, y = y, preds = {}, key = kind .. qid, step = { index = n }, kind = kind, qid = qid,
            label = label, go = go }
        if pred then node.preds[pred] = true end
        nodes[#nodes + 1] = node
        return node
    end
    for _, q in ipairs(logQuests()) do
        local name = title(q.id)
        local fin = self.QDBFinisher and self:QDBFinisher(q.id)
        local handLabel = "Hand in: " .. name .. (fin and fin.who and (" -- " .. fin.who) or "")
        if q.complete then
            if not (fin and add("turnin", q.id, handLabel, fin.go)) then unplaced[#unplaced + 1] = name end
        else
            local obj = spots[q.id] and add("do", q.id, "Do: " .. name, spots[q.id])
            if obj then
                if fin then add("turnin", q.id, handLabel, fin.go, obj) end
            else
                unplaced[#unplaced + 1] = name
            end
        end
    end
    local stops = {}
    if px and #nodes > 0 and S.RouteTopo and S.RouteSolve then
        local order, succ = S.RouteTopo(nodes)
        local route = S.RouteSolve(order, succ, px, py, nil)
        for _, node in ipairs(route) do stops[#stops + 1] = node end
    end
    table.sort(unplaced)
    G.free = { stops = stops, unplaced = unplaced }
    return G.free
end

-- where the arrow points in Free mode
function S:FreeGoto()
    local f = G.free
    local first = f and f.stops and f.stops[1]
    if not first then return nil end
    return { go = first.go, free = true, label = first.label }
end

-- the panel's lines: the next few stops, then how many quests have no spot here
function S:FreeLines()
    local f = G.free
    if not f then return nil end
    local lines = {}
    for i, stop in ipairs(f.stops) do
        if i > 5 then break end
        lines[#lines + 1] = stop.label
    end
    if #f.unplaced > 0 then
        lines[#lines + 1] = string.format("No spot on this map: %d quest%s", #f.unplaced, #f.unplaced == 1 and "" or "s")
    end
    return lines
end

-- re-plan as you walk: the solver is cheap for a quest log's worth of stops
C_Timer.NewTicker(2, function()
    if S:GuideMode() == "free" and S.UpdateGuide then S:UpdateGuide() end
end)
