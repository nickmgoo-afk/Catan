local _, S = ...

-- "Ready to hand in": quests in your log that are finished, where the guide knows the turn-in,
-- but the guide won't take you there itself (a step you've passed, an optional side trip, a
-- different chapter). They're listed in the guide panel with who takes them and how far away,
-- so a finished quest never just sits in your log.

local index -- [questID] = { { guide, step, go, target, optional }, ... }

local function build()
    index = {}
    for _, g in ipairs(S.guides or {}) do
        if not S.GuideOK or S:GuideOK(g) then
            for _, step in ipairs(g.steps) do
                if S:GateOK(step.gate) then
                    local go, target
                    for _, el in ipairs(step.elements) do
                        if el.go and not el.go.route and not go then go = el.go end
                        if el.cmd == "target" and el.args[1] and not target then target = el.args[1]:gsub("::.*$", "") end
                    end
                    for _, el in ipairs(step.elements) do
                        if el.cmd == "turnin" and S:GateOK(el.gate) then
                            local id = math.abs(tonumber(el.args[1] or "") or 0)
                            if id > 0 then
                                index[id] = index[id] or {}
                                table.insert(index[id], { guide = g, step = step, go = go, target = target,
                                    optional = step.tags.optional and true or false })
                            end
                        end
                    end
                end
            end
        end
    end
    return index
end

local function questTitle(id)
    local fn = C_QuestLog and C_QuestLog.GetTitleForQuestID
    return fn and fn(id) or ("Quest " .. id)
end

local function finishedQuests()
    local out, CQ = {}, C_QuestLog
    if not (CQ and CQ.GetNumQuestLogEntries and CQ.GetInfo and CQ.IsComplete) then return out end
    for i = 1, CQ.GetNumQuestLogEntries() or 0 do
        local info = CQ.GetInfo(i)
        if info and not info.isHeader and info.questID and info.questID > 0 and CQ.IsComplete(info.questID) then
            out[#out + 1] = info.questID
        end
    end
    return out
end

-- the guide will hand this in itself, soon: a turn-in in this chapter, not optional, not yet passed
local function guideWillDoIt(places)
    local G = S.G
    if not (G and G.guide and G.current) then return false end
    for _, p in ipairs(places) do
        if p.guide == G.guide and not p.optional and p.step.index >= (G.frontier or G.current).index then return true end
    end
    return false
end

local function distanceText(yards)
    if not yards then return nil end
    if yards >= 1000 then return string.format("%.1f miles", yards / 1760) end
    return string.format("%d yards", math.floor(yards / 10 + 0.5) * 10)
end

-- list of { id, name, target, dist, text }, nearest first
function S:ReadyHandins()
    local idx = index or build()
    local list = {}
    for _, id in ipairs(finishedQuests()) do
        local places = idx[id]
        if not places and S.QDBFinisher then
            -- a quest the guide doesn't know: where the quest data says it's handed in
            local f = S:QDBFinisher(id)
            if f then places = { { go = f.go, target = f.who } } end
        end
        if places and not guideWillDoIt(places) then
            local best
            for _, p in ipairs(places) do
                local d = p.go and self:DistanceTo(p.go)
                if not best or (d and (not best.dist or d < best.dist)) then best = { p = p, dist = d } end
            end
            local name = questTitle(id)
            local who = best and best.p.target
            local parts = { name }
            if who then parts[#parts + 1] = "-- " .. who end
            local dt = best and distanceText(best.dist)
            if dt then parts[#parts + 1] = "(" .. dt .. ")" end
            list[#list + 1] = { id = id, name = name, target = who, dist = best and best.dist, text = table.concat(parts, " "),
                go = best and best.p.go }
        end
    end
    table.sort(list, function(a, b) return (a.dist or 1e12) < (b.dist or 1e12) end)
    return list
end

S:On("PLAYER_LEVEL_UP", function() index = nil end)
