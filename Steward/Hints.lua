local _, S = ...

-- Objective hints: for quests your guide knows, what to kill for an item and where to go.
-- Hover a quest in the quest list to see each unfinished objective with the creature that
-- drops it and how far away (and which way) the guide's spot for it is. The guide's own
-- steps also name the creature next to item objectives.

local index -- [questID][objective] = { mobs = { names }, gotos = { goto, ... } }

local function add(qid, obj, step)
    qid, obj = tonumber(qid), tonumber(obj)
    if not qid or not obj then return end
    index[qid] = index[qid] or {}
    local h = index[qid][obj]
    if not h then
        h = { mobs = {}, gotos = {}, seenMob = {} }
        index[qid][obj] = h
    end
    for _, el in ipairs(step.elements) do
        if el.cmd == "mob" or el.cmd == "unitscan" then
            for part in (el.argText or table.concat(el.args or {}, ",")):gmatch("[^,]+") do
                local name = part:gsub("^%s+", ""):gsub("%s+$", "")
                if name ~= "" and not h.seenMob[name] then
                    h.seenMob[name] = true
                    h.mobs[#h.mobs + 1] = name
                end
            end
        elseif el.go and not el.go.route then
            h.gotos[#h.gotos + 1] = el.go
        end
    end
end

local function build()
    index = {}
    for _, g in ipairs(S.guides or {}) do
        if not S.GuideOK or S:GuideOK(g) then
            for _, step in ipairs(g.steps) do
                for _, el in ipairs(step.elements) do
                    local a = el.args or {}
                    if el.cmd == "complete" then
                        add(a[1], a[2], step)
                    elseif el.cmd == "collect" and a[3] then
                        add(a[3], a[4], step)
                    end
                end
            end
        end
    end
    return index
end

local DIRS = { "north", "north-east", "east", "south-east", "south", "south-west", "west", "north-west" }

-- "340 yards south-east" from where you stand to the closest spot the guide uses
local function whereFrom(gotos)
    local px, py, inst = S:PlayerWorld()
    if not px then return nil end
    local best, bx, by
    for _, g in ipairs(gotos) do
        local r = S:ResolveGoto(g)
        if r and r.world and r.instance == inst then
            local dx, dy = r.world.x - px, r.world.y - py
            local d = math.sqrt(dx * dx + dy * dy)
            if not best or d < best then best, bx, by = d, dx, dy end
        end
    end
    if not best then return nil end
    if best < 40 then return "right here" end
    local north, west = bx, by
    if S:WorldOrder() == "unitswap" then north, west = by, bx end
    local angle = math.deg(math.atan2(-west, north)) % 360 -- 0 = north, 90 = east
    local dir = DIRS[math.floor((angle + 22.5) / 45) % 8 + 1]
    local yards = best >= 1000 and string.format("%.1f miles", best / 1760) or string.format("%d yards", math.floor(best / 10 + 0.5) * 10)
    return yards .. " " .. dir
end

-- { from = "Pygmy Tide Crawler", where = "340 yards south-east" } or nil
function S:ObjectiveHint(qid, obj)
    local h = (index or build())[qid]
    h = h and h[obj]
    if not h then return nil end
    local out = {}
    if #h.mobs > 0 then
        out.from = h.mobs[1]
        if #h.mobs == 2 then out.from = h.mobs[1] .. " or " .. h.mobs[2]
        elseif #h.mobs > 2 then out.from = h.mobs[1] .. " and others" end
    end
    local ok, where = pcall(whereFrom, h.gotos)
    if ok then out.where = where end
    if not out.from and not out.where then return nil end
    return out
end

-- the creature to kill for an item objective, if the objective's text doesn't already say
function S:HintSuffix(qid, obj, text)
    local h = self:ObjectiveHint(qid, obj)
    if not (h and h.from) or not text then return nil end
    for name in h.from:gmatch("[^,]+") do
        local first = name:match("^(%S+)")
        if first and text:find(first, 1, true) then return nil end
    end
    if text:find("slain") or text:find("killed") then return nil end
    return h.from
end

---------------------------------------------------------------- the quest list tooltip
local ours = false

local function onEnter(_, block)
    if not S:Get("objectiveHints") or not block then return end
    local qid = block.id or block.questID
    if type(qid) ~= "number" or not C_QuestLog or not C_QuestLog.GetQuestObjectives then return end
    local objs = C_QuestLog.GetQuestObjectives(qid)
    if not objs then return end
    local lines = {}
    for i, o in ipairs(objs) do
        if not o.finished then
            local h = S:ObjectiveHint(qid, i)
            if h then
                local parts = {}
                if h.from and o.type ~= "monster" then parts[#parts + 1] = "from " .. h.from end
                if h.where then parts[#parts + 1] = h.where end
                if #parts > 0 then lines[#lines + 1] = { o.text or "", table.concat(parts, ", ") } end
            end
        end
    end
    if #lines == 0 then return end
    local tip = GameTooltip
    if not (tip:IsShown() and tip:GetOwner() == block) then
        tip:SetOwner(block, "ANCHOR_LEFT")
        ours = true
    else
        tip:AddLine(" ")
    end
    tip:AddLine("Steward", 1, 0.82, 0)
    for _, l in ipairs(lines) do tip:AddDoubleLine(l[1], l[2], 1, 1, 1, 0.6, 0.8, 1) end
    tip:Show()
end

local function onLeave()
    if ours then
        GameTooltip:Hide()
        ours = false
    end
end

local hooked = {}
local function hookTrackers()
    for _, name in ipairs({ "QuestObjectiveTracker", "CampaignQuestObjectiveTracker" }) do
        local m = _G[name]
        if m and not hooked[name] and m.OnBlockHeaderEnter then
            hooksecurefunc(m, "OnBlockHeaderEnter", function(...) pcall(onEnter, ...) end)
            if m.OnBlockHeaderLeave then hooksecurefunc(m, "OnBlockHeaderLeave", function() pcall(onLeave) end) end
            hooked[name] = true
        end
    end
end

S:On("PLAYER_ENTERING_WORLD", function() pcall(hookTrackers) end)
S:On("PLAYER_LEVEL_UP", function() index = nil end) -- guide gates can change with level
S.RebuildHints = function() index = nil end

---------------------------------------------------------------- marking quest mobs
-- Mouse over or target a creature you still need for a quest and it gets a skull above it, so
-- it stands out in a crowd; the person the guide sends you to talk to gets a star. Only when
-- you're solo or lead the group; a marked unit keeps its mark.
local wanted, wantedAt = {}, -100
local people = {} -- names the guide wants you to talk to now
local function refreshWanted()
    wanted = {}
    local idx = index or build()
    local CQ = C_QuestLog
    if not (CQ and CQ.GetNumQuestLogEntries and CQ.GetInfo) then return end
    for i = 1, CQ.GetNumQuestLogEntries() or 0 do
        local info = CQ.GetInfo(i)
        local qid = info and not info.isHeader and info.questID
        if qid and idx[qid] and not (CQ.IsComplete and CQ.IsComplete(qid)) then
            local objs = CQ.GetQuestObjectives and CQ.GetQuestObjectives(qid) or {}
            for n, h in pairs(idx[qid]) do
                if not (objs[n] and objs[n].finished) then
                    for _, m in ipairs(h.mobs) do wanted[m] = true end
                end
            end
        end
    end
    -- who to talk to: the current step and the steps running alongside it
    people = {}
    local G = S.G
    local steps = {}
    if G and G.current then steps[1] = G.current end
    for i in pairs((StewardCharDB and StewardCharDB.guide and StewardCharDB.guide.side) or {}) do
        if G and G.guide and G.guide.steps[i] then steps[#steps + 1] = G.guide.steps[i] end
    end
    for _, st in ipairs(steps) do
        local talk = false
        for _, el in ipairs(st.elements) do
            if (el.cmd == "accept" or el.cmd == "turnin") and S:GateOK(el.gate) and S:ElementStatus(st, el) == "active" then talk = true end
        end
        if talk then
            for _, el in ipairs(st.elements) do
                if el.cmd == "target" and el.args and el.args[1] then
                    people[(el.args[1]:gsub("::.*$", ""))] = true
                end
            end
        end
    end
    -- pick-ups coming up in the next few steps (you may get there in another order)
    if G and G.guide and G.current then
        local seen = 0
        for i = G.current.index + 1, #G.guide.steps do
            local st = G.guide.steps[i]
            if S:IsBlockingStep(st) and S:GateOK(st.gate) then
                seen = seen + 1
                if seen > 8 then break end
                local talk = false
                for _, el in ipairs(st.elements) do
                    if (el.cmd == "accept" or el.cmd == "turnin") and S:GateOK(el.gate) and S:ElementStatus(st, el) == "active" then talk = true end
                end
                if talk then
                    for _, el in ipairs(st.elements) do
                        if el.cmd == "target" and el.args and el.args[1] then people[(el.args[1]:gsub("::.*$", ""))] = true end
                    end
                end
            end
        end
    end
    -- whoever takes a finished quest in your log (from the quest data)
    local CQ2 = C_QuestLog
    if S.QDB_QUESTS and S.QDB_NPCS and CQ2 and CQ2.GetNumQuestLogEntries and CQ2.GetInfo and CQ2.IsComplete then
        for i = 1, CQ2.GetNumQuestLogEntries() or 0 do
            local info = CQ2.GetInfo(i)
            local qid = info and not info.isHeader and info.questID
            local q = qid and CQ2.IsComplete(qid) and S.QDB_QUESTS[qid]
            if q and type(q[8]) == "table" then
                for _, id in ipairs(q[8]) do
                    local n = S.QDB_NPCS[id]
                    if n then people[n[1]] = true end
                end
            end
        end
    end
    -- and whoever takes a finished quest you're carrying
    if S.ReadyHandins then
        local okR, ready = pcall(S.ReadyHandins, S)
        for _, r in ipairs(okR and ready or {}) do if r.target then people[r.target] = true end end
    end
    wantedAt = GetTime()
end

local function secretValue(v) return S.Secret and S.Secret(v) end

local function note(unit, name, why)
    if not StewardCharDB then return end
    local log = StewardCharDB.markLog or {}
    StewardCharDB.markLog = log
    local key = tostring(name) .. why
    if log.lastKey == key then return end
    log.lastKey = key
    log[#log + 1] = date("%H:%M:%S ") .. unit .. " " .. tostring(name) .. ": " .. why
    while #log > 25 do table.remove(log, 1) end
end

-- Off: on this game, placing a raid marker is reserved for Blizzard's own interface (an addon
-- doing it gets the "blocked from an action" warning), so Steward never calls it.
local MARKING_ALLOWED = false

local function mark(unit)
    if not MARKING_ALLOWED or not S:Get("markQuestMobs") then return end
    if not SetRaidTarget then note(unit, "?", "no SetRaidTarget") return end
    if IsInGroup and IsInGroup() and not (UnitIsGroupLeader("player") or (UnitIsGroupAssistant and UnitIsGroupAssistant("player"))) then
        note(unit, "?", "in a group, not leader") return
    end
    if not UnitExists(unit) or UnitIsDead(unit) or UnitIsPlayer(unit) then return end
    if GetTime() - wantedAt > 5 then refreshWanted() end
    local ok, name = pcall(UnitName, unit)
    if not ok or not name then note(unit, "?", "no name") return end
    if secretValue(name) then note(unit, "<secret>", "name hidden by the game") return end
    local okH, hostile = pcall(UnitCanAttack, "player", unit)
    if not okH or secretValue(hostile) then hostile = nil end
    local icon
    if hostile ~= false and wanted[name] then icon = 8 -- skull: kill this
    elseif not hostile and people[name] then icon = 1 -- star: talk to this one
    end
    if not icon then
        local who = {}
        for n in pairs(people) do who[#who + 1] = n end
        note(unit, name, "not needed (talk to: " .. table.concat(who, ", ") .. ")")
        return
    end
    local okI, cur = pcall(GetRaidTargetIndex, unit)
    if okI and cur and not secretValue(cur) then note(unit, name, "already marked " .. tostring(cur)) return end
    local okS, err = pcall(SetRaidTarget, unit, icon)
    note(unit, name, okS and ("marked " .. icon) or ("refused: " .. tostring(err)))
end

S:On("UPDATE_MOUSEOVER_UNIT", function() mark("mouseover") end)
S:On("PLAYER_TARGET_CHANGED", function() mark("target") end)
S:On("QUEST_LOG_UPDATE", function() wantedAt = -100 end)
S:On("QUEST_ACCEPTED", function() wantedAt = -100 end)
S:On("QUEST_TURNED_IN", function() wantedAt = -100 end)
