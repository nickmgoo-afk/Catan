local _, S = ...

-- What Steward knows about quests beyond the guide, from QuestData.lua (built from QuestieDB's
-- Forever data): who starts and ends each quest, where they stand, and what a quest needs
-- (level, race, class, earlier quests). Used to find quests near you the guide doesn't do, and
-- where to hand in quests the guide doesn't know.

local RACEBIT = { [1] = 1, [2] = 2, [3] = 4, [4] = 8, [5] = 16, [6] = 32, [7] = 64, [8] = 128, [9] = 256, [10] = 512,
    [11] = 1024, [95] = 4294967296, [96] = 8589934592 }
local function hasBit(mask, bit) return bit and math.floor(mask / bit) % 2 == 1 end

local CQ = C_QuestLog
local function done(id)
    return CQ and CQ.IsQuestFlaggedCompleted and CQ.IsQuestFlaggedCompleted(id) or false
end
local function onQuest(id)
    if CQ and CQ.IsOnQuest then return CQ.IsOnQuest(id) end
    return CQ and CQ.GetLogIndexForQuestID and (CQ.GetLogIndexForQuestID(id) or 0) > 0 or false
end

-- every spot where these NPCs / objects stand, as guide-style gotos
local function spots(npcs, objs, faction)
    local out = {}
    local N, O = S.QDB_NPCS or {}, S.QDB_OBJECTS or {}
    for _, id in ipairs(type(npcs) == "table" and npcs or {}) do
        local n = N[id]
        if n and (n[3] == "" or not faction or n[3]:find(faction)) then
            for _, p in ipairs(n[2]) do
                out[#out + 1] = { go = { mapID = p[1], x = p[2], y = p[3], radius = 6, objective = true }, who = n[1] }
            end
        end
    end
    for _, id in ipairs(type(objs) == "table" and objs or {}) do
        local o = O[id]
        if o then
            for _, p in ipairs(o[2]) do
                out[#out + 1] = { go = { mapID = p[1], x = p[2], y = p[3], radius = 6, objective = true }, who = o[1] }
            end
        end
    end
    return out
end

local function nearest(list)
    local best, bestD
    for _, s in ipairs(list) do
        local d = S:DistanceTo(s.go)
        if d and (not bestD or d < bestD) then best, bestD = s, d end
    end
    return best, bestD
end

local function myFaction()
    local f = UnitFactionGroup and UnitFactionGroup("player")
    return f == "Horde" and "H" or (f == "Alliance" and "A" or nil)
end

-- where to hand in a quest: { go, who, dist } at the nearest spot, or nil
function S:QDBFinisher(id)
    local q = S.QDB_QUESTS and S.QDB_QUESTS[id]
    if not q then return nil end
    local best, d = nearest(spots(q[8], q[9], myFaction()))
    if best then return { go = best.go, who = best.who, dist = d } end
end

-- where a quest starts
function S:QDBStarter(id)
    local q = S.QDB_QUESTS and S.QDB_QUESTS[id]
    if not q then return nil end
    local best, d = nearest(spots(q[6], q[7], myFaction()))
    if best then return { go = best.go, who = best.who, dist = d } end
end

-- the most levels a quest can sit under you before it turns grey
local function greyGap(level)
    if UnitQuestTrivialLevelRange then
        local ok, v = pcall(UnitQuestTrivialLevelRange, "player")
        if ok and type(v) == "number" then return v end
    end
    if level <= 5 then return 5 end
    if level <= 39 then return 5 + math.floor(level / 10) end
    return 1 + math.floor(level / 5)
end

-- quests you could take right now: { id, name, level }; cached a few seconds
local avail, availAt, availLevel
function S:QDBAvailable()
    local Q = S.QDB_QUESTS
    if not Q then return {} end
    local level = UnitLevel("player") or 1
    if avail and availLevel == level and GetTime() - availAt < 10 then return avail end
    local _, _, raceID = UnitRace("player")
    local _, _, classID = UnitClass("player")
    local raceBit = RACEBIT[raceID or 0]
    local classBit = classID and 2 ^ (classID - 1)
    local gap = greyGap(level)
    local out = {}
    for id, q in pairs(Q) do
        local flags = q[14] or 0
        if flags % 2 == 0 and math.floor(flags / 4) % 2 == 0 and math.floor(flags / 8) % 2 == 0
            and math.floor(flags / 16) % 2 == 0
            and q[3] <= level and q[2] >= level - gap and q[2] <= level + 3
            and (q[4] == 0 or hasBit(q[4], raceBit)) and (q[5] == 0 or hasBit(q[5], classBit)) then
            local ok = not done(id) and not onQuest(id)
            if ok and type(q[10]) == "table" then
                for _, p in ipairs(q[10]) do if not done(p) then ok = false break end end
            end
            if ok and type(q[11]) == "table" then
                local any = false
                for _, p in ipairs(q[11]) do if done(p) then any = true break end end
                ok = any
            end
            if ok and type(q[12]) == "table" then
                for _, x in ipairs(q[12]) do if done(x) or onQuest(x) then ok = false break end end
            end
            if ok then out[#out + 1] = { id = id, name = q[1], level = q[2] } end
        end
    end
    avail, availAt, availLevel = out, GetTime(), level
    return out
end

S:On("QUEST_TURNED_IN", function() avail = nil end)
S:On("QUEST_ACCEPTED", function() avail = nil end)

---------------------------------------------------------------- guide check (runs once per version)
-- Walks every guide step that picks up or hands in a quest and compares the guide's spot with
-- where the quest data says the quest giver stands. Anything far off (or a different name) is
-- written to StewardDB.guideCheck for Claude to fix in the guide. Runs quietly in the background.
local function worldOf(go)
    local r = go and S:ResolveGoto(go)
    if r and r.world then return r.world.x, r.world.y, r.instance, r end
end

local function checkGuides()
    if not (S.QDB_QUESTS and S.guides) then return end
    local issues, checked = {}, 0
    local jobs = {}
    for _, g in ipairs(S.guides) do
        if not S.GuideOK or S:GuideOK(g) then
            for _, step in ipairs(g.steps) do jobs[#jobs + 1] = { g = g, step = step } end
        end
    end
    local faction = UnitFactionGroup and UnitFactionGroup("player") == "Horde" and "H" or "A"
    local i = 0
    local function batch()
        for _ = 1, 40 do
            i = i + 1
            local job = jobs[i]
            if not job then
                StewardDB.guideCheck = { version = S.version, when = date("%Y-%m-%d %H:%M"), checked = checked, issues = issues }
                return
            end
            local step = job.step
            -- every NPC the step names and every spot it gives: a step often serves two NPCs standing together
            -- (the Furlbrows' wagon), so a quest is right when one of its givers or enders is among the step's names
            -- and the nearest of its spots is near one of the step's spots
            local targets, gos, firstTarget = {}, {}, nil
            for _, el in ipairs(step.elements) do
                if el.go and not el.go.route then
                    local x, y, inst = worldOf(el.go)
                    if x then gos[#gos + 1] = { x, y, inst } end
                end
                if el.cmd == "target" and el.args and el.args[1] then
                    local t = el.args[1]:gsub("::.*$", ""):gsub("^%+", "")
                    targets[t:lower()] = true
                    firstTarget = firstTarget or t
                end
            end
            for _, el in ipairs(step.elements) do
                if (el.cmd == "accept" or el.cmd == "turnin") and el.args and #gos > 0 then
                    local qid = math.abs(tonumber(el.args[1] or "") or 0)
                    local q = S.QDB_QUESTS[qid]
                    if q then
                        local npcs = el.cmd == "accept" and q[6] or q[8]
                        local objs = el.cmd == "accept" and q[7] or q[9]
                        local best, bestD, bestWho, bestSpot
                        local names, named = {}, false
                        local function try(list, db)
                            for _, id in ipairs(type(list) == "table" and list or {}) do
                                local e = db and db[id]
                                if e and (db ~= S.QDB_NPCS or e[3] == "" or e[3]:find(faction)) then
                                    names[#names + 1] = e[1]
                                    -- an object (a poster, a crate, a grave) can't be targeted: the step's name belongs to its NPC
                                    if db ~= S.QDB_NPCS or targets[e[1]:lower()] then named = true end
                                    for _, p in ipairs(e[2]) do
                                        local x, y, inst = worldOf({ mapID = p[1], x = p[2], y = p[3] })
                                        for _, g in ipairs(gos) do
                                            if x and inst == g[3] then
                                                local d = math.sqrt((x - g[1]) ^ 2 + (y - g[2]) ^ 2)
                                                if not bestD or d < bestD then
                                                    bestD, bestWho, bestSpot = d, e[1], string.format("%d/%d,%.2f,%.2f", p[1], inst, x, y)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        try(npcs, S.QDB_NPCS)
                        try(objs, S.QDB_OBJECTS)
                        checked = checked + 1
                        local nameOff = next(targets) and #names > 0 and not named
                        if bestD and (bestD > 60 or nameOff) then
                            issues[#issues + 1] = string.format("%s | #%d | %s %d | guide: %s | data: %s %s (%.0f yd)",
                                job.g.name, step.index, el.cmd, qid, tostring(firstTarget), table.concat(names, " / "), bestSpot or "?", bestD)
                        end
                    end
                end
            end
        end
        C_Timer.After(0.05, batch)
    end
    batch()
end

S:On("PLAYER_ENTERING_WORLD", function()
    if StewardDB and StewardDB.guideCheck and StewardDB.guideCheck.version == S.version then return end
    C_Timer.After(20, function() pcall(checkGuides) end)
end)
S.CheckGuides = checkGuides
