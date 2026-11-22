local _, S = ...

-- Smarter leveling: no grinding. When the guide would have you grind to a level (or you're
-- below the level its chapter is written for), Steward looks for quests the guide skips on
-- the map you're on: quests you can pick up nearby, extra quests you already have, and ones
-- ready to hand in. The arrow and the guide panel lead you through those instead, and the
-- guide carries on by itself once you've caught up. Grey quests are never added.
-- It depends on the game telling addons where quests are; where it doesn't, the guide's
-- own grind step stays as it was.

local G = S.G
local cache, cacheAt, cacheMap = nil, -100, nil

local function log(text)
    StewardCharDB = StewardCharDB or {}
    StewardCharDB.fillerLog = StewardCharDB.fillerLog or {}
    local l = StewardCharDB.fillerLog
    if l[#l] and l[#l]:sub(10) == text then return end
    table.insert(l, date("%H:%M:%S ") .. text)
    while #l > 30 do table.remove(l, 1) end
end

-- 3+ levels under a chapter counts as behind; the level a chapter is written for: "19-20 Redridge" -> 19
local function chapterLevel(guide)
    local n = guide and guide.name and guide.name:match("^(%d+)%s*%-")
    return tonumber(n or "")
end

local function grinding(step)
    if not step then return nil end
    for _, el in ipairs(step.elements) do
        if el.cmd == "xp" and S:GateOK(el.gate) and S:ElementStatus(step, el) == "active" then
            return tonumber(el.args and el.args[1] or "") or true
        end
    end
    return nil
end

-- how far behind you are (levels), or nil when you're on pace
function S:LevelsBehind()
    local g = G.guide
    local step = G.current
    local lvl = UnitLevel("player") or 1
    local target = grinding(step)
    if type(target) == "number" and target > lvl then return target - lvl, "grind" end
    if target == true then return 1, "grind" end
    local min = chapterLevel(g)
    if min and lvl < min - 2 then return min - lvl, "chapter" end
    return nil
end

local function title(qid)
    local fn = C_QuestLog and C_QuestLog.GetTitleForQuestID
    return fn and fn(qid) or ("quest " .. qid)
end

local function trivial(qid)
    local fn = C_QuestLog and C_QuestLog.IsQuestTrivial
    if not fn then return false end
    local ok, v = pcall(fn, qid)
    return ok and v or false
end

-- quests near you that the guide doesn't use: list of { kind, qid, name, go }
function S:FillerCandidates()
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    if not mapID then return {} end
    if cache and cacheMap == mapID and GetTime() - cacheAt < 3 then return cache end
    local out, seen = {}, {}
    local QL, Q = C_QuestLine, C_QuestLog
    -- quests you have that aren't the guide's: their objectives, or where to hand them in
    if Q and Q.GetQuestsOnMap then
        local ok, list = pcall(Q.GetQuestsOnMap, mapID)
        for _, q in ipairs(ok and list or {}) do
            local qid = q.questID
            if qid and not seen[qid] and not S:IsGuideQuest(qid) and q.x and q.y then
                seen[qid] = true
                local done = Q.IsComplete and Q.IsComplete(qid)
                out[#out + 1] = { kind = done and "turnin" or "do", qid = qid, name = title(qid),
                    go = { mapID = mapID, x = q.x * 100, y = q.y * 100, radius = 15, objective = true } }
            end
        end
    end
    -- quests waiting to be picked up nearby (not grey, not hidden by the game)
    if QL and QL.GetAvailableQuestLines then
        -- ask the server about this map now and then, not every few seconds
        S.fillerAsked = S.fillerAsked or {}
        if QL.RequestQuestLinesForMap and GetTime() - (S.fillerAsked[mapID] or -100) > 30 then
            S.fillerAsked[mapID] = GetTime()
            pcall(QL.RequestQuestLinesForMap, mapID)
        end
        local ok, list = pcall(QL.GetAvailableQuestLines, mapID)
        for _, q in ipairs(ok and list or {}) do
            local qid = q.questID
            if qid and not seen[qid] and not q.isHidden and not q.isDaily and not trivial(qid)
                and not S:IsGuideQuest(qid) and q.x and q.y then
                seen[qid] = true
                out[#out + 1] = { kind = "accept", qid = qid, name = q.questName or title(qid),
                    go = { mapID = mapID, x = q.x * 100, y = q.y * 100, radius = 6, objective = true } }
            end
        end
    end
    -- quests you can take that start near you (from Steward's quest data)
    if S.QDBAvailable then
        for _, q in ipairs(S:QDBAvailable()) do
            if not seen[q.id] and not S:IsGuideQuest(q.id) then
                local st = S:QDBStarter(q.id)
                if st and st.dist and st.dist < 1500 then
                    seen[q.id] = true
                    out[#out + 1] = { kind = "accept", qid = q.id, name = q.name .. " -- " .. st.who, go = st.go }
                end
            end
        end
    end
    -- closest first
    for _, c in ipairs(out) do c.dist = S:DistanceTo(c.go) or 1e9 end
    table.sort(out, function(a, b) return a.dist < b.dist end)
    cache, cacheAt, cacheMap = out, GetTime(), mapID
    return out
end

local LABEL = { accept = "Pick up", ["do"] = "Do", turnin = "Hand in" }

-- while you're behind: the extra quest to head for (replaces the guide's grind spot)
function S:FillerGoto()
    G.filler = nil
    if not (self:Get("guideShow") and self:Get("fillerQuests")) or S.InInstance() then return nil end
    local behind, why = self:LevelsBehind()
    if not behind then return nil end
    local list = self:FillerCandidates()
    if #list == 0 then
        log(string.format("behind %s (%s), nothing nearby", tostring(behind), why))
        return nil
    end
    G.filler = { behind = behind, why = why, list = list }
    local first = list[1]
    log(string.format("behind %s (%s): %s %s", tostring(behind), why, first.kind, first.name))
    return { go = first.go, filler = true, label = LABEL[first.kind] .. ": " .. first.name }
end

-- while catching up, take any quest that isn't grey (the guide alone would skip them)
function S:FillerAccepting()
    return S.G and G.filler ~= nil
end

function S:FillerLines()
    local f = S.G and G.filler
    if not f then return nil end
    local lines = {}
    for i, c in ipairs(f.list) do
        if i > 4 then break end
        lines[#lines + 1] = LABEL[c.kind] .. ": " .. c.name
    end
    return lines, f.behind
end
