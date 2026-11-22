-- Smart routing. The guide is written in an order, but you don't have to walk it that way.
-- The next stretch of the chapter (up to a flight, a hearth, a zone change, a journey or a
-- "reach level" step) becomes a pool of tasks: quests to pick up, objectives of quests you hold,
-- finished quests to hand in, trainers and vendors. What has to come first comes from the game
-- itself: you need a quest before its objectives, its objectives before the hand-in, and a
-- quest's prerequisites (from the quest database) before you can pick it up. Steps that don't
-- apply yet because their quest is picked up earlier in the same stretch are in the pool too,
-- so the route already knows where that quest will take you. A route solver then puts the pool
-- in the order that walks the least from where you stand. The plan stands while you head for
-- its first stop or work along its search route; it is made again when your quests change or
-- you leave the course. The guide panel and the arrow show the first stop of that route.
local _, S = ...
local G = S.G

local BARRIER = { xp = true, hs = true, fly = true, zone = true, abandon = true, aura = true } -- aura: get the buff (a disguise) before anything else
local FREE = { train = true, trainer = true, vendor = true, home = true, fp = true }
local POOL_STEPS = 30     -- how far ahead the pool reaches (guide steps that need doing)
local KEEP_YARDS = 50     -- don't switch targets to save less walking than this
local HERE_YARDS = 25     -- something you can do this close: do it first
local HOLD_YARDS = 50     -- a stop you've reached stays the stop until it's done or you're this far from it
                          -- (an objective: OBJ_HOLD, from it or anywhere along its search route)
local OBJ_HOLD = 120      -- within this of the objective you're on, the plan stands (you're busy there)
local ON_COURSE = 20      -- yards of detour, against the straight line to the stop, that still count as on course
local TASK_CAP = 40       -- and how many tasks the pool holds at most
local JOURNEY_YARDS = 600 -- a step whose waypoints lead this far (or into another zone) is a journey: walked as written
local LS_WORK = 60000     -- how much improving one plan may cost (moves tried)
local SEARCH_WORK = 6000  -- how much exact search one plan may cost (branches opened x stops)

local function dist(ax, ay, bx, by)
    local dx, dy = ax - bx, ay - by
    return math.sqrt(dx * dx + dy * dy)
end

-- distance from a point to the stretch of road between a and b
local function segDist(px, py, ax, ay, bx, by)
    local dx, dy = bx - ax, by - ay
    local len2 = dx * dx + dy * dy
    local t = len2 > 0 and ((px - ax) * dx + (py - ay) * dy) / len2 or 0
    if t < 0 then t = 0 elseif t > 1 then t = 1 end
    return dist(px, py, ax + t * dx, ay + t * dy)
end

-- where a step is: the waypoint it's heading for, or (once every waypoint of a search route has
-- been walked through and the step still isn't done) its last spot. The fourth value is true
-- when that waypoint is only on the way (the start of a search route, a path to follow): the
-- step's work lies beyond it, so standing there isn't standing at the stop
local function point(step)
    local el = S:ActiveGoto(step)
    local via = false
    if el and el.go and el.go.route then
        local lastGo
        for _, e in ipairs(step.elements) do
            if e.go and S:GateOK(e.gate) then lastGo = e end
        end
        via = lastGo ~= el
    end
    el = el or S:StepSpot(step)
    local r = el and el.go and S:ResolveGoto(el.go)
    if r and r.world then return r.world.x, r.world.y, r.instance, via end
end

-- every spot a step sends you to, in order, as a flat list x1, y1, x2, y2... (its search route)
local function pathOf(step, inst)
    local path = {}
    for _, el in ipairs(step.elements) do
        if el.go and S:GateOK(el.gate) then
            local r = S:ResolveGoto(el.go)
            if r and r.world and r.instance == inst then
                path[#path + 1] = r.world.x
                path[#path + 1] = r.world.y
            end
        end
    end
    if #path < 4 then return nil end
    if step.tags.loop then path[#path + 1] = path[1] path[#path + 1] = path[2] end
    return path
end

-- A journey: the step's waypoints lead into another zone or a long way from where they start
-- (the ride to a new zone, the road to a flight master). One point on the map can't stand for
-- that, so the route isn't planned around it: it's walked the way the guide wrote it.
local function journey(step)
    local fx, fy, finst, fmap, lx, ly, linst, lmap
    for _, el in ipairs(step.elements) do
        if el.go and S:GateOK(el.gate) then
            local r = S:ResolveGoto(el.go)
            if r and r.world then
                if not fx then fx, fy, finst, fmap = r.world.x, r.world.y, r.instance, r.mapID end
                lx, ly, linst, lmap = r.world.x, r.world.y, r.instance, r.mapID
            end
        end
    end
    if not fx or (lx == fx and ly == fy) then return false end
    return linst ~= finst or lmap ~= fmap or dist(fx, fy, lx, ly) > JOURNEY_YARDS
end

---------------------------------------------------------------- what each step asks of you
-- A step's active elements become tasks. Each task names what it needs first ("acc:Q" quest Q
-- picked up, "obj:Q" its objectives done, "tin:Q" handed in) and what it provides.
local function questOf(el)
    return math.abs(tonumber(el.args[1] or "") or 0)
end

-- returns a list of tasks, or "barrier" when the route can't be planned past this step
local function stepTasks(step)
    if step.tags.requires or step.waitingOn then return "barrier" end
    local status, _, manual = S:StepStatus(step)
    if status ~= "active" then return {} end
    if manual == "reach" then return "barrier" end
    if manual == "tip" then return {} end
    local tasks, questy, loose = {}, false, false
    for _, el in ipairs(step.elements) do
        if S:GateOK(el.gate) then
            local cmd = el.cmd
            local es = S:ElementStatus(step, el)
            if es == "active" and BARRIER[cmd] then return "barrier" end
            if cmd == "accept" or cmd == "turnin" or cmd == "complete" then
                questy = true
                if es == "active" or es == "skip" then tasks[#tasks + 1] = { el = el, cmd = cmd, q = questOf(el), status = es } end
            elseif cmd == "collect" then
                if es == "active" then
                    local q = tonumber(el.args[3])
                    if q then questy = true end
                    tasks[#tasks + 1] = { el = el, cmd = q and "complete" or "free", q = q, status = es }
                end
            elseif es == "active" and FREE[cmd] then
                tasks[#tasks + 1] = { el = el, cmd = "free", status = es }
            elseif es == "active" and (cmd == "cast" or (cmd == "goto" and el.go and el.go.objective)) then
                loose = true
            end
        end
    end
    -- a spell to cast or a spot to reach with no quest behind it: keep the written order there
    if loose and not questy then return "barrier" end
    if #tasks > 0 and journey(step) then return "barrier" end
    return tasks
end

-- A step that doesn't apply yet (its quest isn't picked up, or isn't offered until another is
-- handed in): what it will ask of you once it does. Only what waits on a pick-up or hand-in is
-- listed; buildPool keeps it only when that pick-up or hand-in comes earlier in the stretch.
local function futureTasks(step)
    local t = step.tags
    if t.sticky or t.completewith or t.optional or t.requires or step.waitingOn then return nil end
    local status, _, _, why = S:StepStatus(step)
    if status ~= "skip" or why ~= "notyet" then return nil end
    local tasks
    for _, el in ipairs(step.elements) do
        if S:GateOK(el.gate) then
            local cmd = el.cmd
            if (cmd == "complete" or cmd == "accept") and S:ElementStatus(step, el) == "skip" then
                local raw = tonumber(el.args[1] or "") or 0
                if raw > 0 then
                    tasks = tasks or {}
                    tasks[#tasks + 1] = { el = el, cmd = cmd, q = raw, status = "skip", future = true }
                end
            end
        end
    end
    if tasks and journey(step) then return nil end
    return tasks
end

---------------------------------------------------------------- my quests
-- Guide + my quests (Nick 2026-11-14: "worked in algorithmically"; 2026-11-15: "it's having me take the sky cutter
-- to Dalaran city and I have three quests in this zone in my log that it never handled"): a quest in your log whose
-- remaining work (its objectives, or its hand-in once complete) the guide only has in steps you've already passed is
-- worked into the route, when that step's spot is in the zone you're in. Quests the guide still comes to later keep
-- the guide's order.
local function zoneOf(mapID)
    if not (mapID and C_Map and C_Map.GetMapInfo) then return mapID end
    local seen = 0
    local id = mapID
    while id and seen < 8 do
        local info = C_Map.GetMapInfo(id)
        if not info then return id end
        local zoneType = Enum and Enum.UIMapType and Enum.UIMapType.Zone or 3
        if info.mapType == zoneType or not info.parentMapID or info.parentMapID == 0 then return id end
        local up = C_Map.GetMapInfo(info.parentMapID)
        if not up or (up.mapType or 0) < zoneType then return id end -- the parent is a continent or bigger
        id = info.parentMapID
        seen = seen + 1
    end
    return id
end

local function questIndex(guide)
    if guide.questIdx then return guide.questIdx end
    local idx = {}
    for i, step in ipairs(guide.steps) do
        for _, el in ipairs(step.elements) do
            if el.cmd == "complete" or el.cmd == "turnin" then
                local q = questOf(el)
                if q > 0 then
                    idx[q] = idx[q] or {}
                    table.insert(idx[q], { i = i, el = el })
                end
            end
        end
    end
    guide.questIdx = idx
    return idx
end

local function heldQuests()
    local out, CQ = {}, C_QuestLog
    if CQ and CQ.GetNumQuestLogEntries and CQ.GetInfo then
        for i = 1, CQ.GetNumQuestLogEntries() or 0 do
            local info = CQ.GetInfo(i)
            if info and not info.isHeader and info.questID and info.questID > 0 then out[#out + 1] = info.questID end
        end
    end
    return out
end

-- the chapters that lead into this one (their #next is this chapter), up to two back: all of their steps are behind
-- you. Their steps join the route as stand-ins numbered 100000 and up (200000 two back), so nothing that keys on a
-- step's number in this chapter (done steps, events, the tracker) mixes them up with this chapter's own
local standIns = setmetatable({}, { __mode = "k" })
-- Every chapter that leads in counts, not just the first one found: Westfall follows Loch Modan, the Dwarf/Gnome
-- start and Zephras Isle alike, and a Skyborne's Zephras quests come from the last of them (2026-11-15: three
-- Zephras quests in the log, never worked in, because Loch Modan was taken as the chapter before Westfall)
local function earlierChapters(guide)
    local out, level, seen = {}, { guide }, { [guide] = true }
    for depth = 1, 2 do
        local nextLevel = {}
        for _, cur in ipairs(level) do
            for _, g in ipairs(S.guides or {}) do
                if not seen[g] and S:GuideOK(g) and S:NextGuide(g) == cur then
                    seen[g] = true
                    out[#out + 1] = { g = g, base = (#out + 1) * 100000 }
                    nextLevel[#nextLevel + 1] = g
                end
            end
        end
        level = nextLevel
        if #level == 0 then break end
    end
    return out
end
local function standIn(g, i, base)
    standIns[g] = standIns[g] or {}
    local c = standIns[g][i]
    if not c then
        c = setmetatable({ index = base + i, standInFor = g.name }, { __index = g.steps[i] })
        standIns[g][i] = c
    end
    return c
end

local function myQuestTasks(frontier, covered, pinst)
    if not (S.GuideMode and S:GuideMode() == "guide") then return {} end
    local guide = G.guide
    -- this chapter's steps, then the earlier chapters' (as stand-ins, all behind you)
    local qidx = {}
    for q, list in pairs(questIndex(guide)) do
        qidx[q] = {}
        for _, e in ipairs(list) do table.insert(qidx[q], { i = e.i, el = e.el, step = guide.steps[e.i] }) end
    end
    for _, ch in ipairs(earlierChapters(guide)) do
        for q, list in pairs(questIndex(ch.g)) do
            qidx[q] = qidx[q] or {}
            for _, e in ipairs(list) do table.insert(qidx[q], { i = -1, el = e.el, step = standIn(ch.g, e.i, ch.base) }) end
        end
    end
    local here = C_Map and C_Map.GetBestMapForUnit and zoneOf(C_Map.GetBestMapForUnit("player"))
    local out = {}
    for _, q in ipairs(heldQuests()) do
        local list = qidx[q]
        if list and not covered[q] and S.OnQuest(q) and not S.TurnedIn(q) then
            local later = false
            for _, e in ipairs(list) do if e.i >= frontier then later = true break end end
            if not later then
                local done = S.QuestComplete(q)
                for _, e in ipairs(list) do
                    local step = e.step
                    local want = done and "turnin" or "complete"
                    if e.el.cmd == want and S:GateOK(step.gate) and S:GateOK(e.el.gate)
                        and not (e.el.cmd == "complete" and S:ElementStatus(step, e.el) == "done") then
                        local x, y, inst, via = point(step)
                        local el = S:ActiveGoto(step) or S:StepSpot(step)
                        local r = el and el.go and S:ResolveGoto(el.go)
                        local zone = r and zoneOf(r.mapID)
                        if x and inst == pinst and (not here or not zone or zone == here) then
                            out[#out + 1] = { el = e.el, cmd = e.el.cmd, q = q, status = "active", step = step, x = x, y = y,
                                side = true, mine = true, via = via }
                        end
                    end
                end
            end
        end
    end
    return out
end
S.MyQuestTasks = myQuestTasks

---------------------------------------------------------------- the pool
local function buildPool(frontier)
    local guide = G.guide
    local st = StewardCharDB.guide
    local raw, anchor = {}, nil
    local count = 0
    local px, py, pinst = S:PlayerWorld()
    local accSeen, tinSeen = {}, {} -- quests picked up / handed in by a stop already in the pool
    local function add(step, side, first)
        local tasks = stepTasks(step)
        if tasks == "barrier" then return "barrier" end
        if #tasks == 0 then return end
        local x, y, inst, via = point(step)
        -- no place to go for it: it's done wherever you stand. As the guide's next step that
        -- means now; further on, it waits its turn
        if not x then return first and "barrier" or nil end
        if inst ~= pinst then return "barrier" end
        for _, t in ipairs(tasks) do
            -- side steps: "#watch" ones are real stops; for the rest ("while you're here" kills,
            -- optional extras) only a pick-up or hand-in is worth routing to
            local keep = not side or step.tags.watch or ((t.cmd == "accept" or t.cmd == "turnin") and not step.tags.optional)
            if keep then
                t.step, t.x, t.y, t.side, t.via = step, x, y, side, via
                raw[#raw + 1] = t
                if not side then
                    if t.cmd == "accept" then accSeen[t.q] = true elseif t.cmd == "turnin" then tinSeen[t.q] = true end
                end
            end
        end
    end
    -- a step that will apply once a quest from earlier in the pool is picked up (or handed in)
    local function addFuture(step)
        local tasks = futureTasks(step)
        if not tasks then return false end
        local x, y, inst, via = point(step)
        if not x or inst ~= pinst then return false end
        local added = false
        for _, t in ipairs(tasks) do
            local keep
            if t.cmd == "complete" then
                keep = accSeen[t.q]
            else
                local p = t.el.args[2] == "2" and math.abs(tonumber(t.el.args[3] or "") or 0) or 0
                keep = p > 0 and p ~= t.q and tinSeen[p]
            end
            if keep then
                t.step, t.x, t.y, t.via = step, x, y, via
                raw[#raw + 1] = t
                if t.cmd == "accept" then accSeen[t.q] = true end
                added = true
            end
        end
        return added
    end
    -- A step further on that applies or not depending on where you stand right now (a zone change
    -- or flight that reads "done" because you're in that zone, a step written to be skipped while
    -- you're in some zone) ends the stretch: how far the plan reaches must not depend on which
    -- side of a zone line you are, or the plan would change under you as you cross it
    local function standing(step)
        local t = step.tags
        if t.sticky or t.completewith or t.optional then return false end
        if (st.done and st.done[step.index]) or not S:GateOK(step.gate) then return false end
        local byPlace = false
        for _, c in ipairs(step.conds) do
            if S:GateOK(c.gate) then
                if c.cmd == "zoneskip" or c.cmd == "subzoneskip" then byPlace = true
                elseif S.CondOK and not S.CondOK(c) then return false end -- it doesn't apply for another reason
            end
        end
        if byPlace then return true end
        local ev = st.events
        for _, el in ipairs(step.elements) do
            if (el.cmd == "zone" or el.cmd == "fly") and S:GateOK(el.gate)
                and not (ev and ev[step.index .. ":" .. el.index]) and S:ElementStatus(step, el) == "done" then
                return true
            end
        end
        return false
    end
    for i = frontier, #guide.steps do
        local step = guide.steps[i]
        local res
        if i > frontier and standing(step) then
            res = "barrier"
        elseif S:IsBlockingStep(step) then
            res = add(step, false, i == frontier)
            if res ~= "barrier" then count = count + 1 end
        elseif i > frontier and addFuture(step) then
            count = count + 1
        end
        if res == "barrier" then
            -- the guide's next step has to happen first (a flight, a "come back here once X
            -- is done" step, a spot to reach): nothing to plan around it, but your own quests in this
            -- zone before it leaves the zone
            if i == frontier then
                local leaves = false
                for _, el in ipairs(step.elements) do
                    if (el.cmd == "zone" or el.cmd == "fly" or el.cmd == "hs") and S:GateOK(el.gate)
                        and S:ElementStatus(step, el) == "active" then leaves = true end
                end
                -- or the guide's next step is somewhere else entirely (another continent or island: you hearthed
                -- or flew away from it): your own quests where you are come before the trip there
                local sx, sy, sinst = point(step)
                if sx and sinst ~= pinst then leaves = true end
                local mine = leaves and myQuestTasks(frontier, {}, pinst) or {}
                if #mine == 0 then return {}, nil, px, py end
                local x, y, inst = point(step)
                return mine, (x and inst == pinst) and { x = x, y = y } or nil, px, py
            end
            local x, y, inst = point(step)
            if x and inst == pinst then anchor = { x = x, y = y } end
            break
        end
        if count >= POOL_STEPS or #raw >= TASK_CAP then break end
    end
    local side = {}
    for idx in pairs(st.side or {}) do side[#side + 1] = idx end
    table.sort(side)
    for _, idx in ipairs(side) do
        local step = guide.steps[idx]
        if step and idx < frontier + 200 then add(step, true) end
    end
    local covered = {}
    for _, t in ipairs(raw) do if t.q then covered[t.q] = true end end
    for _, t in ipairs(myQuestTasks(frontier, covered, pinst)) do raw[#raw + 1] = t end
    return raw, anchor, px, py
end

-- turn the raw tasks into route nodes. Every task in the stretch stays in the plan, so the
-- route knows what's still to come; a task that can't happen yet (its quest isn't offered yet,
-- you're too low, its objectives happen some other way) keeps its written place: it waits on
-- everything written before it. Trainers and vendors keep their written place too.
local function buildNodes(raw)
    local level = UnitLevel("player") or 1
    local objOf, acceptOf, turninOf = {}, {}, {}
    for k, t in ipairs(raw) do
        if t.cmd == "accept" then acceptOf[t.q] = acceptOf[t.q] or k
        elseif t.cmd == "turnin" then turninOf[t.q] = turninOf[t.q] or k
        elseif t.cmd == "complete" and t.q then objOf[t.q] = objOf[t.q] or {} table.insert(objOf[t.q], k) end
    end
    local DB = S.QDB_QUESTS or {}
    local turnedIn, onQuest, complete = S.TurnedIn, S.OnQuest, S.QuestComplete
    local ab = StewardCharDB.abandoned or {}

    local needs, drop, fixed, waiting = {}, {}, {}, {}
    local function need(k, token) needs[k] = needs[k] or {} needs[k][token] = true end
    -- "written at or before": a task only waits on something the guide does no later than the
    -- task itself. When the guide's own order says otherwise, the guide wins and the task keeps
    -- its written place (that keeps the waiting-on links free of loops, too)
    local function before(kp, k) return kp and raw[kp].step.index <= raw[k].step.index end
    local function objBefore(q, k)
        local list = objOf[q]
        if not list then return false end
        for _, kp in ipairs(list) do if not before(kp, k) then return false end end
        return true
    end
    local function later(k) fixed[k], waiting[k] = true, true end
    -- unsure (no quest data, or a prerequisite the data says you lack): trust the guide's written
    -- place for it, but don't treat it as impossible
    local function inPlace(k) fixed[k] = true end
    for k, t in ipairs(raw) do
        local q, el = t.q, t.el
        local rawArg = tonumber(el.args[1] or "") or 0
        if t.cmd == "free" then
            fixed[k] = true
        elseif t.cmd == "accept" then
            local p = el.args[2] == "2" and math.abs(tonumber(el.args[3] or "") or 0) or 0
            if p == q then
                drop[k] = true -- "take it if offered": picked up in passing, not a reason to go there
            elseif t.status == "skip" then
                if p > 0 and turninOf[p] then
                    if before(turninOf[p], k) then need(k, "tin:" .. p) else drop[k] = true end
                elseif t.future then
                    drop[k] = true
                else
                    later(k)
                end
            else
                local d = DB[q]
                if d then
                    if (d[3] or 0) > level then later(k) end
                    if type(d[10]) == "table" then
                        for _, pq in ipairs(d[10]) do
                            if not turnedIn(pq) then
                                if before(turninOf[pq], k) then need(k, "tin:" .. pq) else inPlace(k) end
                            end
                        end
                    end
                    if type(d[11]) == "table" then
                        local ok, via = false, nil
                        for _, pq in ipairs(d[11]) do
                            if turnedIn(pq) then ok = true break end
                            if before(turninOf[pq], k) and not via then via = pq end
                        end
                        if not ok then if via then need(k, "tin:" .. via) else inPlace(k) end end
                    end
                else
                    inPlace(k) -- not in the database: keep its written place
                end
            end
        elseif t.cmd == "complete" and q then
            if turnedIn(q) then drop[k] = true
            elseif not onQuest(q) then
                if rawArg < 0 then drop[k] = true
                elseif before(acceptOf[q], k) then need(k, "acc:" .. q)
                elseif t.future then drop[k] = true
                else later(k) end
            end
        elseif t.cmd == "complete" then
            fixed[k] = true
        elseif t.cmd == "turnin" then
            if turnedIn(q) or (ab[q] and not onQuest(q)) then drop[k] = true
            elseif rawArg < 0 and not onQuest(q) then drop[k] = true
            elseif onQuest(q) then
                if not complete(q) then
                    if objBefore(q, k) then need(k, "obj:" .. q) else later(k) end
                end
            elseif before(acceptOf[q], k) and (not objOf[q] or objBefore(q, k)) then
                need(k, "acc:" .. q)
                if objOf[q] then need(k, "obj:" .. q) end
            else
                later(k)
            end
        end
    end

    -- objectives written in one step are done together (often the same mobs count for both):
    -- if one of them waits on a pick-up still to come, the others wait for it too
    local stepObj = {}
    for k, t in ipairs(raw) do
        if not drop[k] and t.cmd == "complete" and t.q and not waiting[k] then
            stepObj[t.step] = stepObj[t.step] or {}
            table.insert(stepObj[t.step], k)
        end
    end
    for step, list in pairs(stepObj) do
        local union = {}
        for _, k in ipairs(list) do
            for tok in pairs(needs[k] or {}) do
                -- (a pick-up in this very step can itself be waiting on one of these objectives)
                local q = tonumber(tok:match("^acc:(%d+)$"))
                local kp = q and acceptOf[q]
                if kp and raw[kp].step.index < step.index then union[tok] = true end
            end
        end
        if next(union) then for _, k in ipairs(list) do for tok in pairs(union) do need(k, tok) end end end
    end

    -- group the tasks of one step that wait on the same things into one stop
    local nodes, nodeOf = {}, {}
    for k, t in ipairs(raw) do
        if not drop[k] then
            local list = {}
            for token in pairs(needs[k] or {}) do list[#list + 1] = token end
            table.sort(list)
            local gkey = t.step.index .. "|" .. table.concat(list, ",") .. (fixed[k] and "|f" or "") .. (waiting[k] and "w" or "")
            local n = nodeOf[gkey]
            if not n then
                n = { step = t.step, x = t.x, y = t.y, key = gkey, tasks = {}, needs = needs[k] or {}, side = t.side,
                    fixed = fixed[k] and not t.side, waiting = waiting[k], via = t.via }
                nodes[#nodes + 1] = n
                nodeOf[gkey] = n
            end
            n.tasks[#n.tasks + 1] = t
        end
    end
    local byToken = {}
    for _, n in ipairs(nodes) do
        for _, t in ipairs(n.tasks) do
            local tok = t.cmd == "accept" and ("acc:" .. t.q) or t.cmd == "turnin" and ("tin:" .. t.q)
                or (t.cmd == "complete" and t.q) and ("obj:" .. t.q) or nil
            if tok then byToken[tok] = byToken[tok] or {} byToken[tok][n] = true end
        end
    end
    for _, n in ipairs(nodes) do
        n.preds = {}
        for token in pairs(n.needs) do
            local providers = byToken[token]
            if providers then
                for p in pairs(providers) do
                    if p ~= n then n.preds[p] = true end
                end
            else
                -- nothing in this plan brings it about (a pick-up that only happens "if offered",
                -- a quest you dropped): it can't be counted on, so the stop waits in its written place
                n.waiting = true
                if not n.side then n.fixed = true end
            end
        end
    end
    -- a stop that needs something that can't happen yet can't happen yet either
    local changed = true
    while changed do
        changed = false
        for _, n in ipairs(nodes) do
            if not n.waiting then
                for p in pairs(n.preds) do if p.waiting and not n.waiting then n.waiting = true changed = true end end
            end
        end
    end
    -- written place: after every stop of the steps written before it (order only)
    for _, n in ipairs(nodes) do
        if n.fixed then
            for _, m in ipairs(nodes) do
                if m ~= n and not m.side and m.step.index < n.step.index then n.preds[m] = true end
            end
        end
    end
    return nodes
end

-- an order in which every stop comes after what it waits on (written order breaks ties);
-- stops caught in a loop of waiting on each other are left out
local function laterStep(a, b) return a.step.index > b.step.index end
local function topo(nodes)
    local indeg, succ = {}, {}
    for _, n in ipairs(nodes) do indeg[n] = 0 succ[n] = {} end
    for _, n in ipairs(nodes) do
        for p in pairs(n.preds) do indeg[n] = indeg[n] + 1 table.insert(succ[p], n) end
    end
    local ready, out = {}, {}
    for _, n in ipairs(nodes) do if indeg[n] == 0 then ready[#ready + 1] = n end end
    while #ready > 0 do
        table.sort(ready, laterStep)
        local n = table.remove(ready)
        out[#out + 1] = n
        for _, s in ipairs(succ[n]) do
            indeg[s] = indeg[s] - 1
            if indeg[s] == 0 then ready[#ready + 1] = s end
        end
    end
    return out, succ
end

---------------------------------------------------------------- the route solver
-- Three starting orders (the written order, nearest-first, cheapest insertion), each improved by
-- moving stops and short runs of stops to better places and by reversing stretches, never
-- breaking "this before that". Then an exact search on top, as far as its budget goes, so small
-- plans come out provably shortest. With `first`, the route has to start at that stop.
-- (The sandbox page runs the same code in JavaScript; the tests check they agree stop for stop.)
local function routeCost(route, px, py, anchor)
    local c, lx, ly = 0, px, py
    for _, n in ipairs(route) do c = c + dist(lx, ly, n.x, n.y) lx, ly = n.x, n.y end
    if anchor then c = c + dist(lx, ly, anchor.x, anchor.y) end
    return c
end

local wipe = wipe or function(t) for k in pairs(t) do t[k] = nil end return t end
local scratchD, scratchPred, scratchMemo = {}, {}, {} -- kept between plans (less garbage)
local function solve(order, succ, px, py, anchor, first)
    local n = #order
    if n < 2 then
        local r = {}
        for i = 1, n do r[i] = order[i] end
        return r
    end
    -- distances in one flat table: D[a * M + b]. Two extra "stops": where you stand (YOU),
    -- where the route ends (END)
    local M, YOU, END = n + 2, 0, n + 1
    local id, D = {}, scratchD -- (every cell that gets read is written below)
    for i = 1, n do id[order[i]] = i end
    for a = 1, n do
        local na = order[a]
        local ax, ay = na.x, na.y
        D[a] = dist(px, py, ax, ay)
        D[a * M + END] = anchor and dist(ax, ay, anchor.x, anchor.y) or 0
        local base = a * M
        for b = 1, n do
            local nb = order[b]
            D[base + b] = dist(ax, ay, nb.x, nb.y)
        end
    end
    D[END] = anchor and dist(px, py, anchor.x, anchor.y) or 0
    local preds, succs, isPred = {}, {}, wipe(scratchPred)
    for b = 1, n do preds[b] = {} succs[b] = {} end
    for b = 1, n do
        local list = preds[b]
        for p in pairs(order[b].preds) do
            local a = id[p]
            if a then list[#list + 1] = a end
        end
        table.sort(list)
    end
    for b = 1, n do
        local list = preds[b]
        for q = 1, #list do
            local a = list[q]
            isPred[a * M + b] = true
            succs[a][#succs[a] + 1] = b
        end
    end
    local f = first and id[first] or 0
    local function cost(r)
        local c = D[r[1]]
        for k = 2, n do c = c + D[r[k - 1] * M + r[k]] end
        return c + D[r[n] * M + END]
    end
    local work = 0 -- what the improving has cost so far (it stops at LS_WORK)

    local function written()
        local r = {}
        if f > 0 then r[1] = f end
        for b = 1, n do if b ~= f then r[#r + 1] = b end end
        return r
    end
    local function nearest()
        local cnt, used, r = {}, {}, {}
        for b = 1, n do cnt[b] = #preds[b] end
        local cur = YOU
        for k = 1, n do
            local best, bd = 0, math.huge
            if k == 1 and f > 0 then
                best = f
            else
                local row = cur * M
                for b = 1, n do
                    if not used[b] and cnt[b] == 0 then
                        local d = D[row + b]
                        if d < bd - 1e-9 then bd, best = d, b end
                    end
                end
            end
            used[best] = true
            r[k] = best
            cur = best
            local list = succs[best]
            for q = 1, #list do cnt[list[q]] = cnt[list[q]] - 1 end
        end
        return r
    end
    local function insertion()
        local r, pos = {}, {}
        local function place(b)
            local lo, hi = 1, #r + 1
            local list = preds[b]
            for q = 1, #list do
                local pa = pos[list[q]]
                if pa and pa + 1 > lo then lo = pa + 1 end
            end
            list = succs[b]
            for q = 1, #list do
                local pt = pos[list[q]]
                if pt and pt < hi then hi = pt end
            end
            if f > 0 and b ~= f and lo < 2 then lo = 2 end
            local best, bk = math.huge, lo
            local len = #r
            for k = lo, math.max(lo, hi) do
                local a = k > 1 and r[k - 1] or YOU
                local c = k <= len and r[k] or END
                local add = D[a * M + b] + D[b * M + c] - D[a * M + c]
                if add < best - 0.01 then best, bk = add, k end
            end
            table.insert(r, bk, b)
            for k = bk, #r do pos[r[k]] = k end
        end
        if f > 0 then place(f) end
        for b = 1, n do if b ~= f then place(b) end end
        return r
    end

    local function improve(r)
        local pos, maxPred = {}, {}
        local function index()
            for k = 1, n do pos[r[k]] = k end
            for b = 1, n do
                local m = 0
                local list = preds[b]
                for q = 1, #list do
                    local pa = pos[list[q]]
                    if pa > m then m = pa end
                end
                maxPred[b] = m
            end
        end
        local lowest = f > 0 and 2 or 1 -- a forced first stop stays where it is
        for _ = 1, 25 do
            local improved = false
            -- move a run of 1-3 stops somewhere else (either way round, when the run allows it)
            for L = 1, math.min(3, n - 1) do
                for i = lowest, n - L + 1 do
                    if work >= LS_WORK then return r end
                    local a = i > 1 and r[i - 1] or YOU
                    local s1, s2 = r[i], r[i + L - 1]
                    local b = i + L <= n and r[i + L] or END
                    local gain = D[a * M + s1] + D[s2 * M + b] - D[a * M + b]
                    if gain >= 1e-6 then
                        local rev = L > 1
                        if rev then
                            for u = i, i + L - 1 do
                                local ru = r[u] * M
                                for w = u + 1, i + L - 1 do
                                    if isPred[ru + r[w]] then rev = false break end
                                end
                                if not rev then break end
                            end
                        end
                        local best, after, brev = -1e-6, nil, false
                        for k = i + L, n do -- later: right after r[k]
                            local c = r[k]
                            local blocked = false
                            for u = i, i + L - 1 do
                                if isPred[r[u] * M + c] then blocked = true break end
                            end
                            if blocked then break end
                            work = work + 1
                            local nx = k + 1 <= n and r[k + 1] or END
                            local cm = c * M
                            local base = D[cm + nx] + gain
                            local dlt = D[cm + s1] + D[s2 * M + nx] - base
                            if dlt < best then best, after, brev = dlt, c, false end
                            if rev then
                                dlt = D[cm + s2] + D[s1 * M + nx] - base
                                if dlt < best then best, after, brev = dlt, c, true end
                            end
                        end
                        for k = i - 1, lowest, -1 do -- earlier: right before r[k]
                            local c = r[k]
                            local blocked = false
                            local cm = c * M
                            for u = i, i + L - 1 do
                                if isPred[cm + r[u]] then blocked = true break end
                            end
                            if blocked then break end
                            work = work + 1
                            local pv = k > 1 and r[k - 1] or YOU
                            local pm = pv * M
                            local base = D[pm + c] + gain
                            local dlt = D[pm + s1] + D[s2 * M + c] - base
                            if dlt < best then best, after, brev = dlt, pv, false end
                            if rev then
                                dlt = D[pm + s2] + D[s1 * M + c] - base
                                if dlt < best then best, after, brev = dlt, pv, true end
                            end
                        end
                        if after then
                            local seg = {}
                            for q = 1, L do seg[q] = table.remove(r, i) end
                            if brev then
                                local u, w = 1, L
                                while u < w do seg[u], seg[w] = seg[w], seg[u] u, w = u + 1, w - 1 end
                            end
                            local at = 1
                            if after ~= YOU then
                                for k = 1, #r do if r[k] == after then at = k + 1 break end end
                            end
                            for q = 1, L do table.insert(r, at + q - 1, seg[q]) end
                            improved = true
                        end
                    end
                end
            end
            -- reverse a stretch
            index()
            for i = lowest, n - 1 do
                if work >= LS_WORK then return r end
                local am = (i > 1 and r[i - 1] or YOU) * M
                for j = i + 1, n do
                    local rj = r[j]
                    if maxPred[rj] >= i then break end -- something in the stretch has to come before r[j]
                    work = work + 1
                    local b = j + 1 <= n and r[j + 1] or END
                    local ri = r[i]
                    local dlt = D[am + rj] + D[ri * M + b] - D[am + ri] - D[rj * M + b]
                    if dlt < -1e-6 then
                        local u, w = i, j
                        while u < w do r[u], r[w] = r[w], r[u] u, w = u + 1, w - 1 end
                        index()
                        improved = true
                        break
                    end
                end
            end
            if not improved then break end
        end
        return r
    end

    local best, bc = nil, math.huge
    local r = improve(written())
    local c = cost(r)
    if c < bc - 1e-6 then bc, best = c, r end
    r = improve(nearest())
    c = cost(r)
    if c < bc - 1e-6 then bc, best = c, r end
    r = improve(insertion())
    c = cost(r)
    if c < bc - 1e-6 then bc, best = c, r end

    -- exact search on top: depth-first over what can come next, nearest first, dropping any
    -- branch that can't beat the best route so far or that reaches a point already reached
    -- with less walking
    local spent = 0
    if n <= 46 then
        local maxSpent = math.floor(SEARCH_WORK / n)
        local nn, left = {}, 0 -- each stop's nearest neighbour: no route gets to it for less
        for v = 1, n do
            local m = D[v]
            for u = 1, n do
                if u ~= v then
                    local d = D[u * M + v]
                    if d < m then m = d end
                end
            end
            nn[v] = m
            left = left + m
        end
        local cnt, used, cur, memo, p2, cands = {}, {}, {}, wipe(scratchMemo), {}, {}
        local pw = 1
        for j = 1, n do
            cnt[j] = #preds[j]
            p2[j] = pw
            pw = pw * 2
            cands[j] = {}
        end
        local function dfs(depth, last, c0, mask, rest)
            if depth == n then
                local total = c0 + D[last * M + END]
                if total < bc - 1e-6 then
                    bc = total
                    best = {}
                    for k = 1, n do best[k] = cur[k] end
                end
                return
            end
            if spent >= maxSpent then return end
            spent = spent + 1
            local cand, m = cands[depth + 1], 0
            if depth == 0 and f > 0 then
                cand[1], m = f, 1
            else
                for j = 1, n do
                    if not used[j] and cnt[j] == 0 then m = m + 1 cand[m] = j end
                end
            end
            local row = last * M
            for a = 2, m do -- nearest first (ties keep the written order)
                local x = cand[a]
                local dx = D[row + x]
                local b = a - 1
                while b >= 1 and D[row + cand[b]] > dx do cand[b + 1] = cand[b] b = b - 1 end
                cand[b + 1] = x
            end
            for a = 1, m do
                local j = cand[a]
                local cj = c0 + D[row + j]
                if cj + rest - nn[j] < bc - 1e-6 then
                    local key = (mask + p2[j]) * 64 + j
                    local seen = memo[key]
                    if not (seen and seen <= cj + 1e-9) then
                        memo[key] = cj
                        used[j] = true
                        cur[depth + 1] = j
                        local list = succs[j]
                        for q = 1, #list do cnt[list[q]] = cnt[list[q]] - 1 end
                        dfs(depth + 1, j, cj, mask + p2[j], rest - nn[j])
                        used[j] = false
                        for q = 1, #list do cnt[list[q]] = cnt[list[q]] + 1 end
                        if spent >= maxSpent then return end
                    end
                end
            end
        end
        dfs(0, YOU, 0, 0, left)
    end
    S.RouteSpent, S.RouteWork = spent, work
    local route = {}
    for k = 1, n do route[k] = order[best[k]] end
    return route
end

---------------------------------------------------------------- planning
local last = {}
S.RouteInfo = {} -- what the last plan did (for the tests)
local function forget()
    last.key, last.sig, last.keys, last.at, last.hold, last.path = nil, nil, nil, nil, nil, nil
    last.reachedStep, last.reachedGuide = nil, nil
end

-- A stop you've reached (been within HERE_YARDS of while it was the stop) stays the stop until it's done or you walk
-- away from it: an objective while you're within OBJ_HOLD of it or of its search route, anything else within
-- HOLD_YARDS. Without this, two stops a few dozen yards apart took turns being "right here" as you moved between
-- them (Ranoric, 2026-11-12: the Living Lightning around Commander Cyclas and Cyclas himself, six swaps in a minute).
local function holdRadius(n)
    for _, t in ipairs(n.tasks) do
        if t.cmd == "complete" then return math.max(OBJ_HOLD, HOLD_YARDS) end
    end
    return HOLD_YARDS
end
local function nearStop(n, px, py)
    local r = holdRadius(n)
    if dist(px, py, n.x, n.y) <= r then return true end
    if r > HOLD_YARDS then
        local path = pathOf(n.step, select(3, S:PlayerWorld()))
        if path then
            for i = 1, #path - 3, 2 do
                if segDist(px, py, path[i], path[i + 1], path[i + 2], path[i + 3]) <= r then return true end
            end
        end
    end
    return false
end
local function reachedIs(n)
    return n and last.reachedStep ~= nil and last.reachedStep == n.step.index and last.reachedGuide == G.guide
end

-- Still on course for the stop the plan starts with: getting here and going on to it is no longer
-- than going straight there. Or busy at it: within reach of the objective you're on, anywhere
-- along its search route.
local function onCourse(px, py)
    if not (last.tx and last.px) then return false end
    local nowD = dist(px, py, last.tx, last.ty)
    local detour = dist(last.px, last.py, px, py) + nowD - dist(last.px, last.py, last.tx, last.ty)
    local hold = last.hold or 0
    if detour <= ON_COURSE or nowD <= hold then return true end
    local path = last.path
    if path and hold > 0 then
        for i = 1, #path - 3, 2 do
            if segDist(px, py, path[i], path[i + 1], path[i + 2], path[i + 3]) <= hold then return true end
        end
    end
    return false
end

-- A short record of the router's choices, saved per character, so that a choice that looks wrong in game can be
-- read back after a Reload (Nick, 2026-11-12: it passed a hand-in 75 yards away). One line each time the stop it
-- heads for changes, or it falls back to the written step.
local function noteRoute(kind, route, px, py)
    if not StewardCharDB then return end
    local first = route and route[1]
    local key = kind .. ":" .. tostring(first and first.key)
    if S.RouteNoted == key then return end
    S.RouteNoted = key
    local info = S.RouteInfo or {}
    local parts = {}
    for i = 1, math.min(#(route or {}), 6) do
        local n = route[i]
        parts[#parts + 1] = tostring(n.step and n.step.index) .. (n.waiting and "~" or "") .. string.format("(%dyd)", dist(px, py, n.x, n.y))
    end
    local where = ""
    if C_Map and C_Map.GetBestMapForUnit and C_Map.GetPlayerMapPosition then
        local okM, m = pcall(C_Map.GetBestMapForUnit, "player")
        local okP, pos = pcall(C_Map.GetPlayerMapPosition, m, "player")
        if okM and okP and pos and pos.GetXY then
            local x, y = pos:GetXY()
            if x then where = string.format(" at %d %.1f,%.1f", m or 0, x * 100, y * 100) end
        end
    end
    local log = StewardCharDB.routeLog or {}
    StewardCharDB.routeLog = log
    log[#log + 1] = string.format("%s %s%s step %s; stops %s; %s%s%s%s", date("%H:%M:%S"), kind, where,
        tostring(first and first.step and first.step.index), table.concat(parts, " "),
        info.reused and "reused " or "", info.kept and "kept-course " or "", info.here and "right-here " or "",
        (info.held and "held " or "") .. tostring(info.stops or 0) .. " in pool")
    while #log > 60 do table.remove(log, 1) end
end

-- the step to show now, or nil to keep the written order (nothing to plan from here)
function S:PlanRoute(frontier)
    if not (self:Get("guideDynamic") and G.guide and StewardCharDB and StewardCharDB.guide) then
        G.plan = nil
        return nil
    end
    if self.InInstance and self.InInstance() then G.plan = nil return nil end
    if UnitOnTaxi and UnitOnTaxi("player") then return G.plan and G.plan[1] and G.plan[1].step end
    -- loot and quest-log events come in bursts: re-use the plan for half a second if the
    -- stretch hasn't moved on and the stop it heads to still needs doing
    local now = GetTime()
    local qx, qy = self:PlayerWorld()
    local at = G.planAt
    if G.plan and G.plan[1] and last.frontier == frontier and last.at and now - last.at < 0.5
        and qx and at and dist(qx, qy, at.x, at.y) < 10 then
        -- (the stop itself must still have something to do, not just its step: a hand-in made a moment
        -- ago, before the quest log caught up, leaves the step's other hand-ins and nothing to do here)
        local first = G.plan[1]
        if self:StepStatus(first.step) == "active" then
            for _, t in ipairs(first.tasks or {}) do
                if t.el and self:ElementStatus(first.step, t.el) == "active" then return first.step end
            end
        end
    end
    last.frontier, last.at = frontier, now
    local raw, anchor, px, py = buildPool(frontier)
    if not px or #raw == 0 then G.plan = nil return nil end
    local nodes = buildNodes(raw)
    if #nodes == 0 then G.plan = nil return nil end
    local order, succ = topo(nodes)
    if #order == 0 then G.plan = nil return nil end
    if #order < #nodes then
        -- stops waiting on each other in a loop (shouldn't happen): don't guess, follow the guide
        S.RouteLoops = (S.RouteLoops or 0) + 1
        G.plan = nil
        forget()
        return nil
    end
    -- the same stops as last time (and the same ones waiting) and you're walking toward the one
    -- the plan picked, or busy at the objective it picked: the plan stands
    local keys = {}
    for i, n in ipairs(order) do keys[i] = n.key .. (n.waiting and "~" or "") .. (n.fixed and "!" or "") end
    table.sort(keys)
    local sig = table.concat(keys, ";") .. (anchor and string.format("@%d,%d", anchor.x, anchor.y) or "")
    local route
    if last.sig == sig and last.keys and #last.keys == #order and onCourse(px, py) then
        local byKey, pos = {}, {}
        for _, n in ipairs(order) do byKey[n.key] = n end
        route = {}
        for i, k in ipairs(last.keys) do
            local n = byKey[k]
            if not n then route = nil break end
            route[i] = n
            pos[n] = i
        end
        -- (it has to hold up against what waits on what today, whatever changed underneath)
        if route then
            for i, n in ipairs(route) do
                for p in pairs(n.preds) do
                    if not pos[p] or pos[p] > i then route = nil break end
                end
                if not route then break end
            end
        end
    end
    local reused = route ~= nil
    local info = S.RouteInfo
    info.reused, info.sigChanged, info.kept, info.here, info.stops = reused, last.sig ~= sig, false, false, #order
    info.held = false
    info.prevSig, info.sig = last.sig, sig
    if not route then route = solve(order, succ, px, py, anchor) end
    -- the first stop has to be something you can do right now
    -- (if the best start can't happen yet, follow the written step instead of inventing a detour)
    if route[1] and route[1].waiting then noteRoute("written(first waits)", route, px, py) G.plan = nil forget() return nil end
    -- the stop you've reached and haven't walked away from stays the stop until it's done
    local held
    for i, n in ipairs(route) do
        if reachedIs(n) and not n.waiting and next(n.preds) == nil and nearStop(n, px, py) then held = i break end
    end
    if held then
        if held > 1 then table.insert(route, 1, table.remove(route, held)) end
        info.held = true
    end
    -- standing right at something you can do: do it now (unless you're already at the stop
    -- the route starts with, or holding on to the one you reached)
    local here, hereD
    local atFirst = held ~= nil or dist(px, py, route[1].x, route[1].y) <= HERE_YARDS
    if not atFirst then
        for i, n in ipairs(route) do
            -- (not a waypoint that only leads on to the stop's real work)
            if not n.waiting and not n.via and next(n.preds) == nil then
                local d = dist(px, py, n.x, n.y)
                if d <= HERE_YARDS and (not hereD or d < hereD) then here, hereD = i, d end
            end
        end
    end
    if here and here > 1 then table.insert(route, 1, table.remove(route, here)) info.here = true end
    -- stay on course: keep heading where you were going unless a different start is clearly shorter
    if not here and not atFirst and not reused and last.key and route[1].key ~= last.key then
        local prev
        for _, n in ipairs(order) do
            if n.key == last.key then prev = n break end
        end
        if prev and next(prev.preds) == nil and not prev.waiting then
            local alt = solve(order, succ, px, py, anchor, prev)
            if routeCost(alt, px, py, anchor) <= routeCost(route, px, py, anchor) + KEEP_YARDS then route = alt info.kept = true end
        end
    end
    G.plan = route
    G.planAt = { x = px, y = py }
    -- where this course starts: here, when the stop is new or its waypoint has moved on
    local first = route[1]
    if dist(px, py, first.x, first.y) <= HERE_YARDS then
        last.reachedStep, last.reachedGuide = first.step.index, G.guide
    elseif not held and not reachedIs(first) then
        last.reachedStep, last.reachedGuide = nil, nil -- heading for a stop you haven't reached yet
    end
    if not reused or first.key ~= last.key or first.x ~= last.tx or first.y ~= last.ty then last.px, last.py = px, py end
    last.key = first.key
    last.sig, last.tx, last.ty = sig, first.x, first.y
    last.hold, last.path = 0, nil
    for _, t in ipairs(first.tasks) do
        if t.cmd == "complete" then
            last.hold = OBJ_HOLD
            last.path = pathOf(first.step, select(3, self:PlayerWorld()))
            break
        end
    end
    last.keys = {}
    for i, n in ipairs(route) do last.keys[i] = n.key end
    noteRoute("plan", route, px, py)
    return route[1] and route[1].step
end

-- the stops after the first one, for the panel ("Then: ...")
-- The planned stops you're standing at (within HERE_YARDS of their spot). While the plan holds
-- another stop first, you may still be talking to one of these stops' people: what you do there
-- (make the inn your home, take the flight) counts for them too.
function S:PlanStopsHere()
    local out, seen = {}, {}
    if not (G.plan and G.plan[1]) then return out end
    local px, py = self:PlayerWorld()
    if not px then return out end
    for _, n in ipairs(G.plan) do
        if n.step and not seen[n.step] and n.x and dist(px, py, n.x, n.y) <= HERE_YARDS then
            seen[n.step] = true
            out[#out + 1] = n.step
        end
    end
    return out
end

function S:PlanNext(n)
    local out, seen = {}, {}
    for i = 2, #(G.plan or {}) do
        local node = G.plan[i]
        if not seen[node.step] and node.step ~= (G.plan[1] and G.plan[1].step) then
            seen[node.step] = true
            out[#out + 1] = node.step
            if #out >= (n or 2) then break end
        end
    end
    return out
end

-- As you walk: nothing to do while you're heading for the stop the plan picked. Re-plan when
-- you come right past another stop you could do, or once you've clearly left the course.
function S:RouteWatch()
    if not (G.guide and G.plan and G.plan[1] and self:Get("guideDynamic")) then return false end
    local px, py = self:PlayerWorld()
    if not px then return false end
    local first = G.plan[1]
    local d1 = dist(px, py, first.x, first.y)
    if d1 <= HERE_YARDS then last.reachedStep, last.reachedGuide = first.step.index, G.guide end
    -- (not while you're holding on to the stop you reached)
    if d1 > HERE_YARDS and not (reachedIs(first) and nearStop(first, px, py)) then
        for i = 2, #G.plan do
            local n = G.plan[i]
            if not n.waiting and not n.via and next(n.preds) == nil and dist(px, py, n.x, n.y) <= HERE_YARDS then return true end
        end
    end
    local at = G.planAt
    if not (at and last.tx and last.px and dist(px, py, at.x, at.y) > 30) then return false end
    return not onCourse(px, py)
end
C_Timer.NewTicker(1, function()
    if S:RouteWatch() then S:QueueGuideUpdate() end
end)

-- for the tests
S.RouteSolve = solve
S.RouteCost = routeCost
S.RoutePool, S.RouteNodes, S.RouteTopo = buildPool, buildNodes, topo
S.RouteForget = forget
S.RouteBudget = function(search, ls) SEARCH_WORK = search or SEARCH_WORK LS_WORK = ls or LS_WORK end
