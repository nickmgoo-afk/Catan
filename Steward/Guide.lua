local _, S = ...

-- Guide engine: picks your guide, works out the current step from your quest log,
-- level, location and actions, and moves along by itself.

local CQ = C_QuestLog or {}
local function spellName(id)
    if not id then return nil end
    if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(id) end
    return GetSpellInfo and (GetSpellInfo(id))
end
S.SpellName = spellName
-- do you know this spell? (newer clients keep this in C_SpellBook)
function S.KnowsSpell(id)
    local SB = C_SpellBook
    if SB and SB.IsSpellKnown and SB.IsSpellKnown(id) then return true end
    if SB and SB.IsSpellKnownOrInSpellBook and SB.IsSpellKnownOrInSpellBook(id) then return true end
    if IsPlayerSpell and IsPlayerSpell(id) then return true end
    return IsSpellKnown and IsSpellKnown(id) or false
end
local GetItemCount = (C_Item and C_Item.GetItemCount) or _G.GetItemCount

---------------------------------------------------------------- player facts
local function lower(s) return s and s:lower():gsub("%s", "") end

local playerTokens
local function tokens()
    if playerTokens then return playerTokens end
    local t = {}
    local raceName, raceFile = UnitRace("player")
    local _, classFile = UnitClass("player")
    t[lower(raceName) or ""] = true
    t[lower(raceFile) or ""] = true
    if raceFile == "Scourge" then t.undead = true end
    -- Forever's new race: whatever the game calls it exactly, it's "Skyborne" to the guides
    local _, _, raceID = UnitRace("player")
    if raceID == 95 or raceID == 96 or ((raceName or "") .. (raceFile or "")):lower():find("skyborne") then t.skyborne = true end
    if raceFile == "Undead" then t.scourge = true end
    t[lower(classFile) or ""] = true
    t[lower(UnitFactionGroup("player")) or ""] = true
    playerTokens = t
    return t
end

function S:GateOK(gate)
    if not gate then return true end
    local t = tokens()
    for alt in gate:gmatch("[^/]+") do
        local ok, any = true, false
        for word in alt:gmatch("%S+") do
            any = true
            local tok = word
            local neg = tok:sub(1, 1) == "!"
            if neg then tok = tok:sub(2) end
            if (t[lower(tok)] or false) == neg then ok = false break end
        end
        if ok and any then return true end
    end
    return false
end

---------------------------------------------------------------- quest facts
local function turnedIn(id)
    if CQ.IsQuestFlaggedCompleted then return CQ.IsQuestFlaggedCompleted(id) end
    return IsQuestFlaggedCompleted and IsQuestFlaggedCompleted(id)
end
local function onQuest(id)
    if CQ.IsOnQuest then return CQ.IsOnQuest(id) end
    return GetQuestLogIndexByID and GetQuestLogIndexByID(id) > 0
end
-- Right after login the game can report the quest log before it has loaded your quests. So
-- "you don't have this quest" only counts once the log has settled (a few seconds in), and only
-- if Steward never saw you take the quest, or saw you drop it. Steward keeps its own list of
-- the quests you hold, changed only when you accept, hand in or abandon one.
local logReady = false
local function questLogReady() return logReady end
S.QuestLogReady = questLogReady

local function held()
    StewardCharDB = StewardCharDB or {}
    StewardCharDB.questsHeld = StewardCharDB.questsHeld or {}
    return StewardCharDB.questsHeld
end

-- true only when you clearly don't have the quest
local function questGone(id)
    if not logReady or onQuest(id) then return false end
    return not held()[id]
end
S.QuestGone = questGone

local function rememberLog()
    -- adds what the log shows; never removes (a half-loaded log must not erase anything)
    if not (CQ.GetNumQuestLogEntries and CQ.GetInfo) then return end
    local h = held()
    for i = 1, CQ.GetNumQuestLogEntries() or 0 do
        local info = CQ.GetInfo(i)
        if info and not info.isHeader and info.questID and info.questID > 0 then h[info.questID] = true end
    end
end
local function questComplete(id)
    if CQ.IsComplete then return CQ.IsComplete(id) end
    local i = GetQuestLogIndexByID and GetQuestLogIndexByID(id)
    return i and i > 0 and select(6, GetQuestLogTitle(i)) == 1
end
S.TurnedIn, S.OnQuest, S.QuestComplete = turnedIn, onQuest, questComplete
local function objectives(id)
    if CQ.GetQuestObjectives then return CQ.GetQuestObjectives(id) or {} end
    return {}
end
function S:QuestName(id)
    local n = CQ.GetTitleForQuestID and CQ.GetTitleForQuestID(id)
    return n or ("quest " .. id)
end
S.turnedIn, S.onQuest, S.questComplete = turnedIn, onQuest, questComplete

local function ids(s)
    local t = {}
    for n in (s or ""):gmatch("%-?%d+") do t[#t + 1] = math.abs(tonumber(n)) end
    return t
end

---------------------------------------------------------------- state
local G = { events = {} } -- runtime
S.G = G

local function state()
    StewardCharDB.guide = StewardCharDB.guide or {}
    return StewardCharDB.guide
end

local function key(stepIdx, elIdx) return stepIdx .. ":" .. elIdx end

function S:MarkEvent(stepIdx, elIdx)
    local st = state()
    st.events = st.events or {}
    st.events[key(stepIdx, elIdx)] = true
end
local function eventDone(stepIdx, elIdx)
    local st = state()
    return st.events and st.events[key(stepIdx, elIdx)]
end

---------------------------------------------------------------- conditions (decide if a step applies)
local function compare(value, spec)
    local op, num = spec:match("^([<>]=?)%s*([%-%d%.]+)$")
    num = tonumber(num)
    if not op then return value >= (tonumber(spec) or 0) end
    if op == "<" then return value < num elseif op == "<=" then return value <= num
    elseif op == ">" then return value > num else return value >= num end
end

local function zoneMatches(name)
    if not name then return false end
    local n = tonumber(name)
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    for _ = 1, 8 do -- walk up zone -> continent -> world (bounded, in case a map is its own parent)
        if not mapID or mapID == 0 then break end
        if n and mapID == n then return true end
        local info = C_Map.GetMapInfo(mapID)
        if not info then break end
        if not n and info.name == name then return true end
        if info.parentMapID == mapID then break end
        mapID = info.parentMapID
    end
    return (GetZoneText and GetZoneText() == name) or (GetRealZoneText and GetRealZoneText() == name)
end

-- already standing where a flight goes (flew on your own, hearthed, took a boat)
local function arrivedAt(dest)
    local want = dest:lower()
    for _, fn in ipairs({ GetSubZoneText, GetZoneText, GetMinimapZoneText }) do
        local t = fn and fn()
        if t and not S.Secret(t) and t ~= "" and t:lower():find(want, 1, true) then return true end
    end
    return false
end

-- your rank in a skill, or nil when the client can't say
local PROFESSION_NAMES = { alchemy = true, blacksmithing = true, enchanting = true, engineering = true,
    herbalism = true, leatherworking = true, mining = true, skinning = true, tailoring = true,
    jewelcrafting = true, inscription = true, cooking = true, firstaid = true, fishing = true }
local PROFESSION_SPELL = { firstaid = 3273 }
local function skillRank(name)
    if GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            local n, _, _, r = GetSkillLineInfo(i)
            if n and n:lower():gsub("%s", "") == name:gsub("%s", "") then return r or 0 end
        end
        return 0
    end
    if GetProfessions and GetProfessionInfo then
        local list = { GetProfessions() }
        for i = 1, 6 do
            local n, _, r
            if list[i] then n, _, r = GetProfessionInfo(list[i]) end
            if n and n:lower():gsub("%s", "") == name:gsub("%s", "") then return r or 0 end
        end
        -- a profession the list doesn't hold isn't trained (First Aid may live only in the spellbook)
        local key = name:gsub("%s", "")
        if PROFESSION_NAMES[key] then
            local spell = PROFESSION_SPELL[key]
            local known = spell and ((IsPlayerSpell and IsPlayerSpell(spell)) or (IsSpellKnown and IsSpellKnown(spell)))
            return known and 1 or 0
        end
    end
    return nil
end

local function condOK(c)
    local a = c.args
    local cmd = c.cmd
    if cmd == "isOnQuest" then
        for _, id in ipairs(ids(a[1] and table.concat(a, ","))) do if onQuest(id) then return true end end
        return false
    elseif cmd == "isNotOnQuest" then
        -- applies while none of the quests is in your log
        for _, id in ipairs(ids(table.concat(a, ","))) do if onQuest(id) then return false end end
        return true
    elseif cmd == "isQuestComplete" then
        for _, id in ipairs(ids(table.concat(a, ","))) do if onQuest(id) and questComplete(id) then return true end end
        return false
    elseif cmd == "isQuestNotComplete" then
        for _, id in ipairs(ids(table.concat(a, ","))) do if onQuest(id) and not questComplete(id) then return true end end
        return false
    elseif cmd == "isQuestTurnedIn" then
        for _, id in ipairs(ids(table.concat(a, ","))) do if turnedIn(id) then return true end end
        return false
    elseif cmd == "isQuestAvailable" then
        -- applies while any of the quests is still not turned in
        for _, id in ipairs(ids(table.concat(a, ","))) do if not turnedIn(id) then return true end end
        return false
    elseif cmd == "xp" then
        -- ".xp <N,1": skip until you reach N.  ".xp >N,1" / ".xp N,1": skip once you reach N.
        local lvl = UnitLevel("player")
        local frac = (UnitXPMax("player") or 0) > 0 and UnitXP("player") / UnitXPMax("player") or 0
        local spec = a[1] or "0"
        local n = tonumber(spec:match("[%d%.]+")) or 0
        local reached = lvl + frac >= n
        if spec:sub(1, 1) == "<" then return reached end
        return not reached
    elseif cmd == "maxlevel" then
        return UnitLevel("player") <= (tonumber(a[1]) or 999)
    elseif cmd == "money" then
        -- ".money <X": skip while you have less than X gold. ".money >X": skip once you have X.
        local spec = a[1] or ">0"
        local n = tonumber(spec:match("[%d%.]+")) or 0
        local has = GetMoney() / 10000 >= n
        if spec:sub(1, 1) == "<" then return has end
        return not has
    elseif cmd == "itemcount" then
        local id, spec = tonumber(a[1]), a[2] or "1"
        return id and compare(GetItemCount(id) or 0, spec) or false
    elseif cmd == "cooldown" then
        if a[1] == "item" then
            local getCD = (C_Container and C_Container.GetItemCooldown) or _G.GetItemCooldown
            local start, dur = getCD(tonumber(a[2]))
            if S.Secret(start, dur) then return true end
            local left = (start and start > 0) and (start + dur - GetTime()) or 0
            -- ">X": skip while more than X seconds remain (i.e. wait until ready)
            -- "<X": skip once less than X seconds remain
            local spec = a[3] or ">0"
            local n = math.max(tonumber(spec:match("[%d%.]+")) or 0, 2)
            if spec:sub(1, 1) == "<" then return left >= n end
            return left <= n
        end
        return true
    elseif cmd == "itemStat" then
        local slot, stat, spec = tonumber(a[1]), a[2], a[3] or ">0"
        local link = slot and GetInventoryItemLink("player", slot)
        local stats = link and ((C_Item and C_Item.GetItemStats) or GetItemStats)(link) or {}
        return compare(stats[stat] or 0, spec)
    elseif cmd == "dungeon" then
        -- ".dungeon X": a dungeon-route step, shown when the Dungeons option is on;
        -- ".dungeon !X": its solo counterpart, shown when it is off (off by default)
        local on = S:Get("guideDungeons") == true
        if (a[1] or ""):sub(1, 1) == "!" then return not on end
        return on
    elseif cmd == "skill" then
        -- ".skill name,n,1": skip the step once the check holds ("<80" = while the skill is under 80)
        local name, spec = (a[1] or ""):lower(), a[2] or ">0"
        local rank = skillRank(name)
        if rank == nil then return true end -- this client can't tell: leave the step in
        if a[3] == "1" then return not compare(rank, spec) end
        return true
    elseif cmd == "missingskill" then
        -- ".missingskill daggers,swords,staves": the step applies while any of these skills isn't learned yet
        -- (Nick 2026-11-17: a second weapon-master visit for players who couldn't afford it the first time)
        for _, nm in ipairs(a) do
            local rank = skillRank((nm or ""):lower())
            if rank == nil or rank == 0 then return true end
        end
        return false
    elseif cmd == "bindlocation" then
        local area = tonumber(a[1])
        local bound = area and C_Map.GetAreaInfo and GetBindLocation and GetBindLocation() == C_Map.GetAreaInfo(area)
        -- no flag: skip if your hearth is already set there; flag 1: skip unless it is
        if a[2] == "1" then return bound and true or false end
        return not bound
    elseif cmd == "zoneskip" then
        local inZone = zoneMatches(a[1])
        if a[2] == "1" then return inZone end
        return not inZone
    elseif cmd == "subzoneskip" then
        local area = tonumber(a[1])
        local name = area and C_Map.GetAreaInfo and C_Map.GetAreaInfo(area)
        local inSub = name and (GetSubZoneText() == name or GetZoneText() == name) or false
        if a[2] == "1" then return inSub end
        return not inSub
    end
    return true
end

S.CondOK = condOK

---------------------------------------------------------------- elements
local OBJECTIVE = { accept = true, turnin = true, complete = true, collect = true, xp = true, fly = true, fp = true,
    hs = true, home = true, train = true, trainer = true, vendor = true, zone = true, cast = true, abandon = true, aura = true }

-- do you have this buff? true / false, or nil when the game won't say (combat can hide auras)
local function hasAura(id, name)
    local bySpell = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
    if bySpell and id then
        local ok, a = pcall(bySpell, id)
        if ok and a ~= nil and not S.Secret(a) then return true end
    end
    if name and name ~= "" and S.BuffLeft and C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
        return S.BuffLeft({ name }) ~= nil
    end
    if bySpell and id then return false end
    return nil
end
S.HasAura = hasAura

function S.IsObjectiveCmd(cmd) return OBJECTIVE[cmd] or false end

-- returns status ("done", "skip", "active", "info"), display text
function S:ElementStatus(step, el)
    if not self:GateOK(el.gate) then return "gated" end -- not for your race/class: as if it weren't there
    local cmd, a = el.cmd, el.args
    if cmd == "goto" then
        local g = el.go
        if g and g.objective then
            if eventDone(step.index, el.index) then return "done" end
            return "active", el.text or "Go to the marked spot"
        end
        return "info"
    end
    if not OBJECTIVE[cmd] then return "info", el.text end
    if eventDone(step.index, el.index) then return "done", el.text end

    if cmd == "accept" then
        local id = math.abs(tonumber(a[1]) or 0)
        local name = el.text or ("Accept " .. self:QuestName(id))
        if onQuest(id) or turnedIn(id) then return "done", name end
        if a[2] == "2" then
            -- ",2,P": only once quest P is turned in; ",2,<same id>": take it if offered, don't wait
            local p = math.abs(tonumber(a[3]) or 0)
            if p == id then return "optional", name end
            if p > 0 and not turnedIn(p) then return "skip", name end
        end
        return "active", name
    elseif cmd == "turnin" then
        local raw = tonumber(a[1]) or 0
        local id = math.abs(raw)
        local name = el.text or ("Turn in " .. self:QuestName(id))
        if turnedIn(id) then return "done", name end
        if raw < 0 and not onQuest(id) then return "skip", name end
        -- a hand-in of a quest you don't have drops out too: one you abandoned, or (on the step
        -- you're at, not ones further on) one you skipped. A later step's quest you simply
        -- haven't picked up yet is still to come.
        if raw > 0 and not step.tags.sticky and not step.tags.completewith then
            local ab = StewardCharDB and StewardCharDB.abandoned
            if ab and ab[id] and not onQuest(id) then return "skip", name end
            local front = G.frontier or G.current
            local cur = front and G.guide and G.guide.steps[step.index] == step and front.index
            if cur and step.index <= cur and questGone(id) then return "skip", name end
        end
        return "active", name
    elseif cmd == "complete" then
        local raw, n = tonumber(a[1]) or 0, tonumber(a[2]) or 1
        local id = math.abs(raw)
        local obj = objectives(id)[n]
        local name = (obj and obj.text and obj.text ~= "") and obj.text or el.text or el.comment or self:QuestName(id)
        if turnedIn(id) or (onQuest(id) and questComplete(id)) or (obj and obj.finished) then return "done", name end
        -- a step that would have you work on a quest you don't have (you skipped it, or came in
        -- partway through the chapter) drops out instead of sending you to kill things for nothing
        if raw > 0 and not step.tags.sticky and not step.tags.completewith and questGone(id) then
            return "skip", name
        end
        if raw < 0 and not onQuest(id) then return "skip", name end
        return "active", name
    elseif cmd == "collect" then
        local item, count, quest = tonumber(a[1]), tonumber(a[2]) or 1, tonumber(a[3])
        local have = item and GetItemCount(item) or 0
        local label = el.text or el.comment or ("item " .. tostring(item))
        label = label:gsub("%s*%(%d+%)$", "")
        local name = string.format("%s: %d/%d", label, math.min(have, count), count)
        if have >= count then return "done", name end
        if quest and (turnedIn(quest) or (onQuest(quest) and questComplete(quest))) then return "done", name end
        return "active", name
    elseif cmd == "xp" then
        local target = tonumber(a[1]) or 0
        local lvl = UnitLevel("player")
        local frac = (UnitXPMax("player") or 0) > 0 and UnitXP("player") / UnitXPMax("player") or 0
        local name = el.text or ("Reach level " .. target)
        if lvl + frac >= target then return "done", name end
        return "active", name
    elseif cmd == "train" then
        local id = tonumber(a[1])
        local name = el.text or ("Train " .. (spellName(id) or "new abilities"))
        local known = id and S.KnowsSpell(id)
        if known then return "done", name end
        -- seen at the trainer and you can't afford it yet: move on instead of waiting there
        local sname = id and spellName(id)
        local cost = sname and S.trainCost and S.trainCost[sname]
        if cost and GetMoney and GetMoney() < cost then return "skip", name end
        return "active", name
    elseif cmd == "zone" then
        local name = el.text or ("Travel to " .. (a[1] or "?"))
        if zoneMatches(a[1]) then return "done", name end
        return "active", name
    elseif cmd == "abandon" then
        local id = tonumber(a[1]) or 0
        local name = el.text or ("Abandon " .. self:QuestName(id))
        if not onQuest(id) then return "done", name end
        return "active", name
    elseif cmd == "fly" then
        local name = el.text or ("Fly to " .. (a[1] or "?"))
        if a[1] and not UnitOnTaxi("player") and arrivedAt(a[1]) then return "done", name end
        -- you don't have that flight path: skip the flight, the travel plan walks you there
        if a[1] and self.CantFlyTo and self:CantFlyTo(a[1]) then return "skip", name .. " (flight path not learned yet)" end
        return "active", name
    elseif cmd == "fp" then
        local name = el.text or ("Get the " .. (a[1] or "") .. " flight path")
        if self.KnowsFlightPath and self:KnowsFlightPath(a[1]) then return "done", name end
        return "active", name
    elseif cmd == "hs" then
        local name = el.text or "Use your Hearthstone"
        -- already there (hearthed, or came another way)
        if el.inn and not UnitOnTaxi("player") and arrivedAt(el.inn) then return "done", name end
        return "active", name
    elseif cmd == "home" then
        local name = el.text or "Set your Hearthstone here"
        if el.inn == nil then
            el.inn = (S.InnFromText and S.InnFromText(el.text)) or false
            if not el.inn and S.InnNear then
                local spot = self:StepSpot(step)
                el.inn = spot and S.InnNear(spot.go) or false
            end
        end
        -- already your home
        local bound = GetBindLocation and GetBindLocation()
        if bound and not S.Secret(bound) and bound ~= "" then
            if el.inn and bound == el.inn then return "done", name end
            -- an inn Steward has no table entry for (Zephras Isle's Valanaar, Shen'dar Village):
            -- the guide's line names the place the game says you're bound to
            if not el.inn and el.text and el.text:lower():find(bound:lower(), 1, true) then return "done", name end
        end
        return "active", name
    elseif cmd == "aura" then
        -- ".aura <spell id>,<quest>,<buff name>": a buff you need while you work on that quest (a disguise).
        -- Done while you wear it, and for good once the quest's objectives are done; if you lose it
        -- before then, the step asks for it again.
        local id, quest, bname = tonumber(a[1]), tonumber(a[2]), a[3]
        local name = el.text or ("Get " .. (bname or spellName(id) or "the buff"))
        if quest and (turnedIn(quest) or (onQuest(quest) and questComplete(quest))) then return "done", name end
        if quest and not onQuest(quest) then return "skip", name end
        if hasAura(id, bname) == false then return "active", name end
        return "done", name
    elseif cmd == "trainer" then
        return "active", el.text or "Visit your class trainer"
    elseif cmd == "vendor" then
        return "active", el.text or "Visit the vendor"
    elseif cmd == "cast" then
        local id = tonumber(a[1])
        return "active", el.text or ("Cast " .. (spellName(id) or "the spell"))
    end
    return "info", el.text
end

-- a short record of why the guide moved past a step (StewardCharDB.stepLog, last 40), for when it
-- moves on and you can't see why
function S:NoteStep(step, why)
    if not (StewardCharDB and step) then return end
    local log = StewardCharDB.stepLog or {}
    StewardCharDB.stepLog = log
    local key = step.index .. why
    if log.last == key then return end
    log.last = key
    local parts, seenQ = {}, {}
    for _, el in ipairs(step.elements) do
        if OBJECTIVE[el.cmd] then
            local ok, es = pcall(self.ElementStatus, self, step, el)
            parts[#parts + 1] = el.cmd .. " " .. table.concat(el.args, ",") .. "=" .. tostring(ok and es or "error")
            local id = math.abs(tonumber(el.args[1] or "") or 0)
            if id > 0 and (el.cmd == "complete" or el.cmd == "turnin" or el.cmd == "accept") and not seenQ[id] then
                seenQ[id] = true
                local o = {}
                for k, ob in ipairs(objectives(id)) do
                    o[#o + 1] = k .. ":" .. tostring(ob.text) .. (ob.finished and "(x)" or "")
                end
                parts[#parts + 1] = string.format("[q%d on=%s held=%s complete=%s turnedin=%s %s]", id, tostring(onQuest(id)),
                    tostring(held()[id] or false), tostring(onQuest(id) and questComplete(id) or false), tostring(turnedIn(id) or false),
                    table.concat(o, " "))
            end
        end
    end
    log[#log + 1] = string.format("%s %s step %d: %s", date("%H:%M:%S"), why, step.index, table.concat(parts, "; "))
    while #log > 40 do table.remove(log, 1) end
end

-- step status: "skip", "done", "active"; plus a list of {text, done} objective lines
function S:StepStatus(step)
    local st = state()
    if st.done and st.done[step.index] then return "done" end
    if not self:GateOK(step.gate) then return "skip" end
    for _, c in ipairs(step.conds) do
        if self:GateOK(c.gate) and not condOK(c) then return "skip" end
    end
    step.waitingOn = nil
    if step.tags.requires and type(step.tags.requires) == "string" then
        local li = G.guide and G.guide.labels[step.tags.requires]
        if li and not (st.done and st.done[li]) then
            -- "#requires X": come back here once X is finished. While X is still under way, wait
            -- here showing what's left of X (the arrow goes there too); only if X can't happen
            -- (its quest isn't yours) does this step drop out.
            local req = G.guide.steps[li]
            local rs, rlines, rman
            if req and req ~= step and not req.tags.requires then rs, rlines, rman = self:StepStatus(req) end
            if rs == "active" then
                step.waitingOn = li
                return "active", rlines, rman
            elseif rs ~= "done" then
                return "skip"
            end
        end
    end
    local lines, anyObjective, allDone, sawSkipped = {}, false, true, false
    for _, el in ipairs(step.elements) do
        local status, text = self:ElementStatus(step, el)
        if status == "skip" then sawSkipped = true end
        if status == "done" or status == "active" then
            anyObjective = true
            if status == "active" then allDone = false end
            lines[#lines + 1] = { text = text or el.cmd, done = status == "done", el = el }
        elseif status == "optional" then
            -- shown, but the step doesn't wait for it
            lines[#lines + 1] = { text = text or el.cmd, done = false, el = el, optional = true }
        end
    end
    if anyObjective and allDone then return "done", lines end
    -- everything this step would have you do doesn't apply (quest not taken/not offered): skip it
    -- (the fourth value tells the route planner why: it may apply once a quest is picked up)
    if not anyObjective and sawSkipped and #lines == 0 then return "skip", lines, nil, "notyet" end
    if not anyObjective then
        local spot = self:StepSpot(step)
        if spot then
            if eventDone(step.index, "reach") then return "done", lines end
            return "active", lines, "reach"
        end
        return "active", lines, "tip"
    end
    return "active", lines
end

-- a step the guide waits on (not a tip, optional, sticky or skipped step)
function S:IsBlockingStep(step)
    local t = step.tags
    if t.sticky or t.completewith or t.optional then return false end
    local status, _, manual = self:StepStatus(step)
    if status == "skip" then return false end
    return manual ~= "tip"
end

-- the last place a step sends you (used for steps with nothing else to complete)
function S:StepSpot(step)
    local spot
    for _, el in ipairs(step.elements) do
        if el.go and self:GateOK(el.gate) then spot = el end
    end
    return spot
end

function S:StepTitle(step)
    -- waiting on a "do this first" step: say that, then what this step is for
    if step.waitingOn and G.guide and G.guide.steps[step.waitingOn] and G.guide.steps[step.waitingOn] ~= step then
        local req = G.guide.steps[step.waitingOn]
        local reqTitle = req.waitingOn == nil and self:StepTitle(req)
        if reqTitle then
            step.waitingOn, req = nil, step.waitingOn
            local mine = self:StepTitle(step)
            step.waitingOn = req
            return "First: " .. reqTitle .. (mine and (" -- then: " .. mine) or "")
        end
    end
    local parts = {}
    for _, t in ipairs(step.texts) do
        if self:GateOK(t.gate) and t.text ~= "" then parts[#parts + 1] = t.text end
    end
    if #parts > 0 then return (table.concat(parts, " "):gsub("%s*<<.*$", "")) end
    for _, el in ipairs(step.elements) do
        if el.text and self:GateOK(el.gate) then return el.text end
    end
    return nil
end

---------------------------------------------------------------- choosing a guide
function S:GuideFor(name)
    if not name then return nil end
    local g = self.guidesByName[name]
    if g then return g end
    for _, guide in ipairs(self.guides) do
        if name:find(guide.name, 1, true) then return guide end
    end
end

function S:GuideOK(g)
    return g and self:GateOK(g.gate) and self:GateOK(g.raceGate)
end

function S:NextGuide(g)
    for _, n in ipairs(g.nexts or {}) do
        if self:GateOK(n.gate) then
            local ng = self:GuideFor(n.name)
            if self:GuideOK(ng) then return ng end
        end
    end
end

-- One continuous route, 1 to 60, built by following each chapter's #next.
function S:BuildRoute()
    if G.route then return G.route end
    local start
    for _, g in ipairs(self.guides) do
        if self:GuideOK(g) and g.minLevel == 1 then
            if not start or (g.raceGate and not start.raceGate) then start = g end
        end
    end
    local route, seen = {}, {}
    local g = start
    while g and not seen[g] do
        seen[g] = true
        route[#route + 1] = g
        g = self:NextGuide(g)
    end
    -- anything not reachable from the start chapter (e.g. a later chain) by level
    local extra = {}
    for _, gg in ipairs(self.guides) do
        if self:GuideOK(gg) and not seen[gg] then extra[#extra + 1] = gg end
    end
    table.sort(extra, function(x, y) return (x.minLevel or 0) < (y.minLevel or 0) end)
    if #route == 0 then route = extra end
    local total = 0
    for i, gg in ipairs(route) do
        gg.routeIndex, gg.routeOffset = i, total
        total = total + #gg.steps
    end
    route.totalSteps = total
    G.route = route
    return route
end

-- Where you are in the whole route: the furthest chapter with proof of progress
-- (quests you've turned in), never a chapter far above your level.
local fastForward
function S:DropIn()
    local route = self:BuildRoute()
    local lvl = UnitLevel("player")
    local here = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local dbg = { level = lvl, map = here, route = {}, proofs = {} }
    StewardCharDB.dropDebug = dbg
    for i, g in ipairs(route) do if i <= 40 then dbg.route[i] = g.name end end

    -- 1) your quest history along the route: every required turn-in, in route order, done
    --    or not. You are at the point that best splits "mostly done" from "mostly not
    --    done", so a quest turned in early (or one you skipped) can't throw it off.
    local points = {}
    for _, g in ipairs(route) do
        if g.minLevel and g.minLevel > lvl + 2 then break end
        for i, step in ipairs(g.steps) do
            if not step.tags.optional and self:GateOK(step.gate) then
                for _, el in ipairs(step.elements) do
                    local raw = tonumber(el.args[1] or "") or 0
                    if el.cmd == "turnin" and raw > 0 and self:GateOK(el.gate) then
                        points[#points + 1] = { g = g, i = i, done = turnedIn(raw) and true or false }
                    end
                end
            end
        end
    end
    local score, bestScore, bestK, anyDone = 0, 0, 0, false
    for k, pt in ipairs(points) do
        score = score + (pt.done and 1 or -1)
        if pt.done then anyDone = true end
        if score >= bestScore and pt.done then bestScore, bestK = score, k end
    end
    dbg.points, dbg.split = #points, bestK
    if anyDone and bestK > 0 then
        local pt = points[bestK]
        dbg.pick = "history"
        dbg.at = pt.g.name .. " @" .. pt.i
        if pt.i >= #pt.g.steps then
            local nxt = self:NextGuide(pt.g)
            if nxt then return nxt, 1 end
        end
        return pt.g, pt.i + 1
    end

    -- 2) a chapter for your level that has steps in the zone you're standing in
    local function inZone(g)
        if not here then return nil end
        for i, step in ipairs(g.steps) do
            if self:GateOK(step.gate) then
                for _, el in ipairs(step.elements) do
                    if el.go and self:GateOK(el.gate) then
                        local r = self:ResolveGoto(el.go)
                        if r and r.mapID == here then return i end
                    end
                end
            end
        end
    end
    for _, g in ipairs(route) do
        if g.minLevel and g.maxLevel and lvl >= g.minLevel - 1 and lvl <= g.maxLevel then
            local i = inZone(g)
            if i then dbg.pick = "zone" return g, i end
        end
    end

    -- 3) by level
    for _, g in ipairs(route) do
        if g.minLevel and g.maxLevel and lvl >= g.minLevel and lvl < g.maxLevel then dbg.pick = "level" return g, 1 end
    end
    dbg.pick = "first"
    return route[1], 1
end

-- the first step from `from` on that works on a quest you hold (hand it in or do its
-- objectives), or nil
function S:HeldWorkFrom(guide, from)
    if not guide then return nil end
    local h = (StewardCharDB and StewardCharDB.questsHeld) or {}
    for i = from or 1, #guide.steps do
        local step = guide.steps[i]
        if self:GateOK(step.gate) and not step.tags.optional then
            for _, el in ipairs(step.elements) do
                if (el.cmd == "turnin" or el.cmd == "complete") and self:GateOK(el.gate) then
                    local id = math.abs(tonumber(el.args[1] or "") or 0)
                    if id > 0 and (h[id] or onQuest(id)) and not turnedIn(id) then return i end
                end
            end
        end
    end
    return nil
end

function S:PickGuide()
    local st = state()
    local route = self:BuildRoute()
    local dropG, dropStep = self:DropIn()
    local saved = self:GuideFor(st.name)
    -- once: a login in 0.18.x could move you a chapter ahead while you still held quests from
    -- the one before; if so, go back to where those quests are
    StewardCharDB.repairs = StewardCharDB.repairs or {}
    if not StewardCharDB.repairs.backOne and saved and saved.routeIndex and saved.routeIndex > 1 then
        StewardCharDB.repairs.backOne = true
        local prev = route[saved.routeIndex - 1]
        local at = prev and self:GuideOK(prev) and self:HeldWorkFrom(prev, 1)
        if at then return prev, "back", at end
    end
    if st.routeVersion == 4 and self:GuideOK(saved) and saved.routeIndex then
        if not dropG or not dropG.routeIndex or dropG.routeIndex <= saved.routeIndex then return saved end
        -- a later chapter looks right, but you still hold quests this one finishes: stay
        if self:HeldWorkFrom(saved, st.current or 1) then return saved end
    end
    st.routeVersion = 4
    local d = StewardCharDB.dropDebug
    if d then d.tokens = {} for k in pairs(tokens()) do d.tokens[#d.tokens + 1] = k end end
    return dropG, true, dropStep
end


-- jump past steps you've clearly already done (used when starting a guide mid-way)
function fastForward(guide)
    local last = 0
    for i, step in ipairs(guide.steps) do
        if S:GateOK(step.gate) then
            local questEls, allDone = 0, true
            for _, el in ipairs(step.elements) do
                if (el.cmd == "accept" or el.cmd == "turnin" or el.cmd == "complete") and S:GateOK(el.gate) then
                    questEls = questEls + 1
                    local s = S:ElementStatus(step, el)
                    if s == "active" then allDone = false end
                end
            end
            if questEls > 0 and allDone then
                -- only count turn-ins and completions as proof of progress (accepts can be done early)
                -- optional ("-id") turn-ins and #optional steps can be done early, so they don't count
                for _, el in ipairs(step.elements) do
                    local raw = tonumber(el.args[1] or "") or 0
                    if el.cmd == "turnin" and raw > 0 and not step.tags.optional and S:GateOK(el.gate)
                        and turnedIn(raw) then
                        last = i
                    end
                end
            end
        end
    end
    return last
end

-- A step's fingerprint: what it does (not where), so progress survives guide edits.
local function stepKey(step)
    local parts = {}
    for _, el in ipairs(step.elements) do
        if el.cmd ~= "goto" and el.cmd ~= "target" and el.cmd ~= "mob" then
            parts[#parts + 1] = el.cmd .. " " .. table.concat(el.args or {}, ",")
        end
    end
    return table.concat(parts, ";")
end

-- When the guide's steps changed since your progress was saved (a step added or reworded),
-- carry your progress over by matching steps, not by their numbers.
-- steps of guides as they were before progress fingerprints existed, for guides edited since
local LEGACY_STEPKEYS = {
    ["1-9 Zephras Isle (Skyborne)"] = {
    "",
    "accept 92460",
    "turnin 92460;accept 92461",
    "accept 92462",
    "complete 92462,1;complete 92461,1",
    "turnin 92462;accept 92463",
    "train 6673",
    "accept 94414;complete 94414,1;turnin 94414",
    "accept 92474",
    "complete 92474,1",
    "turnin 92461;turnin 92474;accept 92464;accept 92532",
    "accept 92485",
    "accept 92482",
    "accept 92481",
    "accept 92483",
    "accept 92484",
    "accept 92532",
    "turnin 92485",
    "turnin 92481",
    "turnin 92484;accept 92466",
    "turnin 92482",
    "collect 1194,1;vendor ",
    "accept 92598",
    "accept 92597",
    "accept 93552",
    "complete 93552,1",
    "complete 92463,1",
    "turnin 92464;accept 92465",
    "complete 92466,1",
    "complete 92597,1",
    "complete 92598,1",
    "complete 92465,1;complete 92465,2",
    "complete 93552,1",
    "turnin 92465;accept 92469",
    "hs ",
    "turnin 92466;accept 92467",
    "turnin 92467;accept 92468;use 6635",
    "turnin 93552",
    "turnin 92483",
    "train 6546,1;train 6178,1;train 100;train 772;skipgossipid 136813,1",
    "turnin 92532",
    "train 100;train 772;turnin 92532",
    "turnin 92463,3;turnin 92463",
    "turnin 92597",
    "turnin 92532",
    "turnin 92469;accept 92471",
    "turnin 92471;accept 92470",
    "turnin 92468",
    "turnin 92598",
    "accept 92473",
    "complete 92473,1",
    "complete 92470,1",
    "complete 92470,2",
    "complete 92470,1",
    "turnin 92470,1;turnin 92470;accept 92472;accept 96638",
    "turnin 92473,1;turnin 92473",
    "accept 92544",
    "complete 92544,1;complete 92544,2",
    "complete 92544,3",
    "complete 92544,1;complete 92544,2",
    "turnin 92544",
    "collect 5469,8;collect 6889,3",
    "turnin 92472;accept 93461;accept 92514",
    "complete 93461,1;accept 92596;complete 92596,1;turnin 92596;accept 94413",
    "complete 92514,1;accept 92595;complete 92595,1;turnin 92595;accept 94411",
    "complete 93461,2;complete 92514,2;home ",
    "train 3127",
    "turnin 93461;turnin 92514;accept 92517",
    "accept 93319;accept 92516;accept 92515;accept 93951;accept 92553",
    "collect 2493,1",
    "train 2550;collect 2678,5",
    "accept 93318",
    "train 3273",
    "turnin 96638;accept 96101",
    "complete 96101,1;complete 96101,2",
    "turnin 96101",
    "complete 92515,1",
    "complete 94411,1",
    "complete 92517,1;complete 93319,1",
    "complete 92517,2",
    "complete 94413,1",
    "complete 92516,1;complete 92516,2;complete 92516,3;complete 93951,1",
    "complete 93318,1",
    "complete 92515,1;complete 92553,2;complete 92553,1",
    "turnin 92553",
    "turnin 92515;turnin 93951;turnin 92516;turnin 93319",
    "turnin 94411",
    "turnin 94413",
    "train 284;train 1715;train 6343",
    "turnin 93318,1;turnin 93318",
    "turnin 92517,3;turnin 92517;accept 93036",
    "turnin 93036;accept 92529",
    "turnin 92529;accept 92528",
    "complete 92528,1",
    "turnin 92528,2;turnin 92528;accept 92550;accept 93926",
    "accept 92551",
    "complete 93926,1;turnin 93926;accept 93927",
    "complete 93927,1;complete 93927,4;complete 93927,3",
    "complete 93927,2",
    "complete 92550,1;complete 92551,1",
    "complete 92550,2",
    "complete 92550,3",
    "turnin 92551",
    "turnin 92550,3;turnin 92550;turnin 93927;accept 92701;accept 92579;accept 93948",
    },
}

local function remapProgress(st, guide)
    local keys = {}
    for i, step in ipairs(guide.steps) do keys[i] = stepKey(step) end
    local old = st.stepKeys or LEGACY_STEPKEYS[guide.name]
    st.stepKeys = keys
    if not old then return end
    local same = #old == #keys
    if same then for i = 1, #keys do if old[i] ~= keys[i] then same = false break end end end
    if same then return end
    local where = {}
    for i, k in ipairs(keys) do where[k] = where[k] or {} table.insert(where[k], i) end
    local map, used = {}, {}
    for oi, k in ipairs(old) do
        for _, ni in ipairs(where[k] or {}) do
            if not used[ni] then map[oi], used[ni] = ni, true break end
        end
    end
    local function remapSet(t)
        local out = {}
        for oi, v in pairs(t or {}) do if map[oi] then out[map[oi]] = v end end
        return out
    end
    st.done, st.side, st.carry = remapSet(st.done), remapSet(st.side), remapSet(st.carry)
    local ev = {}
    for k, v in pairs(st.events or {}) do
        local si, ei = tostring(k):match("^(%d+):(%d+)$")
        local ni = si and map[tonumber(si)]
        if ni then ev[ni .. ":" .. ei] = v end
    end
    st.events = ev
    if st.current then
        local c = tonumber(st.current)
        local nc = c and map[c]
        if not nc and c then
            for oi = c - 1, 1, -1 do if map[oi] then nc = map[oi] + 1 break end end
        end
        st.current = nc or 1
    end
    StewardCharDB.loadTrace = StewardCharDB.loadTrace or {}
    table.insert(StewardCharDB.loadTrace, "guide changed: progress carried over (" .. guide.name .. ")")
end
S.RemapProgress = remapProgress

function S:LoadGuide(guide, fresh, startStep, exact)
    local st = state()
    if st.name == guide.name then remapProgress(st, guide) end
    if st.name ~= guide.name then
        st.name, st.current, st.done, st.events, st.side = guide.name, 1, {}, {}, {}
        st.stepKeys = nil
        fresh = true
    end
    G.guide = guide
    if not st.stepKeys then remapProgress(st, guide) end
    if fresh then
        -- (Strict: no jumping ahead past steps that still have something to do; the walk below
        -- passes the ones that are done)
        local ff = (exact or self:GuideMode() == "strict") and ((startStep or 1) - 1) or math.max(fastForward(guide), (startStep or 1) - 1)
        -- quests this chapter still needs, whose pick-up is in the part being skipped: keep those
        -- pick-ups running alongside (so passing the quest giver still gets you the quest)
        local later = {}
        for i = ff + 1, #guide.steps do
            for _, el in ipairs(guide.steps[i].elements) do
                if (el.cmd == "turnin" or el.cmd == "complete") and self:GateOK(el.gate) then
                    local id = tonumber(el.args[1] or "")
                    if id and id > 0 then later[id] = true end
                end
            end
        end
        st.carry = {}
        for i = 1, ff do
            local step, keep = guide.steps[i], false
            if self:GateOK(step.gate) and not step.tags.optional then
                for _, el in ipairs(step.elements) do
                    local id = el.cmd == "accept" and math.abs(tonumber(el.args[1] or "") or 0)
                    if id and id > 0 and later[id] and self:GateOK(el.gate) and self:ElementStatus(step, el) == "active" then
                        keep = true
                    end
                end
            end
            if keep then st.side[i], st.carry[i] = true, true else st.done[i] = true end
        end
        st.current = math.max(st.current or 1, ff + 1)
    end
    G.reached = {}
    self:UpdateGuide()
end

---------------------------------------------------------------- advancing
-- Walks forward from the current step. Returns the current step, plus side steps
-- (#sticky / #completewith) that are still running alongside it.
function S:UpdateGuide()
    -- Free mode: no guide steps; the router plans your quest log
    if self:GuideMode() == "free" then
        G.plan, G.current, G.frontier = nil, nil, nil
        if self.FreePlan then
            local ok, err = pcall(self.FreePlan, self)
            if not ok then self:LogError("free mode", err) G.free = nil end
        end
        if self.UpdateWaypoint then
            local ok, err = pcall(self.UpdateWaypoint, self)
            if not ok then self:LogError("waypoint", err) end
        end
        if self.RefreshGuideUI then self:RefreshGuideUI() end
        return
    end
    G.free = nil
    local guide = G.guide
    if not guide then
        -- no guide (switched off at login): your map pin's trip and the tracker still update
        if self.UpdateWaypoint then
            local ok, err = pcall(self.UpdateWaypoint, self)
            if not ok then self:LogError("waypoint", err) end
        end
        if self.RefreshGuideUI then self:RefreshGuideUI() end
        return
    end
    local st = state()
    st.done = st.done or {}
    st.side = st.side or {}
    local i = st.current or 1
    local cur
    while i <= #guide.steps do
        local step = guide.steps[i]
        -- every step before this one is out of the way, so it's judged as the step you're at
        -- (a hand-in for a quest you don't have drops out there; further on it's still to come)
        G.frontier = step
        local status, lines, manual = self:StepStatus(step)
        if status == "done" then
            if not st.done[i] then self:NoteStep(step, "done") end
            st.done[i] = true
            i = i + 1
        elseif status == "skip" then
            self:NoteStep(step, "skip")
            i = i + 1
        elseif step.tags.sticky or step.tags.completewith or step.tags.optional or manual == "tip" then
            -- runs alongside instead of blocking: tips, optional steps, "while you're here" steps
            st.side[i] = true
            i = i + 1
        else
            cur = step
            break
        end
    end
    st.current = i

    -- "#watch" steps you walked past while they didn't apply yet (a profession quest you can
    -- only pick up once you've trained it, a hand-in for a quest you didn't have): they join
    -- in alongside the current step as soon as they apply, for the rest of the chapter
    if guide.watchList == nil then
        guide.watchList = {}
        for idx, step in ipairs(guide.steps) do
            if step.tags.watch then table.insert(guide.watchList, idx) end
        end
    end
    for _, idx in ipairs(guide.watchList) do
        if idx >= i then break end
        if not st.done[idx] and not st.side[idx] then
            local status = self:StepStatus(guide.steps[idx])
            if status == "done" then st.done[idx] = true
            elseif status == "active" then st.side[idx] = true end
        end
    end

    -- side steps end when they're done, or when the step they ride along with is done
    for idx in pairs(st.side) do
        local step = guide.steps[idx]
        local cw = step and step.tags.completewith
        if step and not cw and not step.tags.sticky and not step.tags.watch and not (st.carry and st.carry[idx]) then cw = "next" end -- optional steps and tips
        local finished = not step or st.done[idx]
        if not finished then
            local status = self:StepStatus(step)
            if status == "done" then st.done[idx] = true finished = true
            elseif status == "skip" then finished = true end
        end
        if not finished and cw == "next" then
            -- rides along with the next blocking step after it
            local j = idx + 1
            while j < i and not self:IsBlockingStep(guide.steps[j]) do j = j + 1 end
            if j < i then finished = true end
        elseif not finished and type(cw) == "string" then
            local li = guide.labels[cw]
            if li and (st.done[li] or li < i) then finished = true end
        end
        if finished then st.side[idx] = nil end
    end

    if not cur and i > #guide.steps then
        -- guide finished: continue with the next one
        local nextGuide = self:NextGuide(guide)
        if nextGuide and nextGuide ~= guide then
            self:LoadGuide(nextGuide, true)
            return
        end
    end
    -- smart routing: show the stop the route planner picks, not just the next written step
    G.frontier = cur
    if cur and self.PlanRoute then
        local ok, planned = pcall(self.PlanRoute, self, i)
        if ok and planned then cur = planned elseif not ok then self:LogError("route planner", planned) G.plan = nil end
    else
        G.plan = nil
    end
    G.current = cur
    -- the waypoint can never stop the guide display from updating
    if self.UpdateWaypoint then
        local ok, err = pcall(self.UpdateWaypoint, self)
        if not ok then self:LogError("waypoint", err) end
    end
    if self.RefreshGuideUI then self:RefreshGuideUI() end
end

function S:SkipCurrentStep()
    local st = state()
    if G.current then
        st.done[G.current.index] = true
        -- skipping a stop the router picked further on doesn't skip the steps before it
        if not (G.frontier and G.current.index > G.frontier.index) then st.current = G.current.index + 1 end
        self:UpdateGuide()
    end
end

-- event-completed elements (flight, hearth, trainer...) for the current and side steps
local function activeSteps()
    local list, seen = {}, {}
    local function add(step)
        if step and not seen[step] then seen[step] = true list[#list + 1] = step end
    end
    add(G.current)
    local guide = G.guide
    if guide then -- (an event can arrive before the guide is loaded, with last session's side steps still saved)
        local st = state()
        for idx in pairs(st.side or {}) do add(guide.steps[idx]) end
        -- stops on the plan you're standing at: the router may be holding a stop a few yards
        -- away first while you talk to this one's innkeeper or flight master
        if S.PlanStopsHere then
            local ok, here = pcall(S.PlanStopsHere, S)
            if ok then for _, step in ipairs(here) do add(step) end end
        end
    end
    return list
end
S.ActiveSteps = activeSteps

local function completeCmd(cmd, test)
    for _, step in ipairs(activeSteps()) do
        for _, el in ipairs(step.elements) do
            if el.cmd == cmd and S:GateOK(el.gate) and (not test or test(el)) then
                S:MarkEvent(step.index, el.index)
            end
        end
    end
end
S.CompleteCmd = completeCmd

---------------------------------------------------------------- events
local pending = false
function S:QueueGuideUpdate(delay)
    if pending or not G.guide then return end
    pending = true
    C_Timer.After(delay or 0.2, function()
        pending = false
        S:UpdateGuide()
    end)
end
local function q() S:QueueGuideUpdate() end

for _, e in ipairs({ "QUEST_ACCEPTED", "QUEST_TURNED_IN", "QUEST_REMOVED", "QUEST_LOG_UPDATE", "UNIT_QUEST_LOG_CHANGED",
    "PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE", "BAG_UPDATE_DELAYED", "ZONE_CHANGED", "ZONE_CHANGED_NEW_AREA",
    "ZONE_CHANGED_INDOORS", "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB", "PLAYER_MONEY", "SKILL_LINES_CHANGED" }) do
    S:On(e, q)
end

S:On("PLAYER_CONTROL_LOST", function()
    C_Timer.After(1, function()
        if UnitOnTaxi("player") then completeCmd("fly") q() end -- done at takeoff, like RestedXP
    end)
end)
S:On("UNIT_SPELLCAST_SUCCEEDED", function(unit, _, spellID)
    if S.Secret(unit, spellID) or unit ~= "player" then return end
    if spellID == 8690 then completeCmd("hs") end
    completeCmd("cast", function(el) return tonumber(el.args[1]) == spellID end)
    q()
end)
S:On("HEARTHSTONE_BOUND", function() completeCmd("home") q() end)
S:On("TRAINER_SHOW", function() completeCmd("trainer") q() end)
S:On("MERCHANT_SHOW", function() completeCmd("vendor") q() end)
S:On("TAXIMAP_OPENED", function() completeCmd("fp") q() end)
S:On("UI_INFO_MESSAGE", function(_, msg)
    if S.Secret(msg) then return end
    if msg == ERR_NEWTAXIPATH then completeCmd("fp") q() end
end)

S:On("QUEST_ACCEPTED", function(a, b)
    local qid = tonumber(b) or tonumber(a)
    if qid and StewardCharDB and StewardCharDB.abandoned then StewardCharDB.abandoned[qid] = nil end
    local id = tonumber(b) or tonumber(a) -- (logIndex, questID) on older clients, (questID) on newer
    if id and id > 0 then held()[id] = true end
    -- steps passed over a moment ago because this quest wasn't in the log yet: go back to them
    if logReady then
        C_Timer.After(1, function()
            local ok, moved = pcall(S.RewindSkipped, S)
            if ok and moved and S.UpdateGuide then S:UpdateGuide() end
        end)
    end
end)
S:On("QUEST_TURNED_IN", function(id) if tonumber(id) then held()[tonumber(id)] = nil end end)
S:On("QUEST_REMOVED", function(id)
    id = tonumber(id)
    if not id then return end
    held()[id] = nil
    -- removed without being turned in: abandoned
    C_Timer.After(0.5, function()
        local done = CQ.IsQuestFlaggedCompleted and CQ.IsQuestFlaggedCompleted(id)
        if not done and not onQuest(id) then
            StewardCharDB.abandoned = StewardCharDB.abandoned or {}
            StewardCharDB.abandoned[id] = true
        end
    end)
end)
S:On("QUEST_LOG_UPDATE", function() if logReady then pcall(rememberLog) end end)
-- a step that needs a buff (a disguise) looks again when your buffs change
S:On("UNIT_AURA", function(unit)
    if unit == "player" and G.guide and G.guide.hasAura then S:QueueGuideUpdate(0.5) end
end)

-- Steps that were passed while the log was still loading (the bug in 0.16-0.18): if a recent
-- step you never finished needs doing after all, go back to it.
function S:RewindSkipped()
    local guide = G.guide
    if not guide then return false end
    local st = state()
    st.done = st.done or {}
    st.side = st.side or {}
    local cur = st.current or 1
    local back
    for i = math.max(1, cur - 15), math.min(cur - 1, #guide.steps) do
        local step = guide.steps[i]
        if not st.done[i] and not step.tags.optional and not step.tags.sticky and not step.tags.completewith
            and self:IsBlockingStep(step) and self:StepStatus(step) == "active" then
            back = i
            break
        end
    end
    if not back then return false end
    st.current = back
    -- bring back the "along the way" steps that ride with it
    for j = math.max(1, back - 10), back - 1 do
        local step = guide.steps[j]
        if not st.done[j] and (step.tags.sticky or step.tags.completewith) and self:StepStatus(step) == "active" then
            st.side[j] = true
        end
    end
    return true
end

-- the log has settled when it reports the same number of entries twice, 2 seconds apart
local lastCount, tries = nil, 0
local function settle()
    if logReady then return end
    local n = CQ.GetNumQuestLogEntries and CQ.GetNumQuestLogEntries() or 0
    tries = tries + 1
    if (n == 0 or n ~= lastCount) and tries < 15 then
        lastCount = n
        C_Timer.After(2, settle)
        return
    end
    logReady = true
    pcall(rememberLog)
    local ok, moved = pcall(S.RewindSkipped, S)
    if ok and moved and S.UpdateGuide then S:UpdateGuide() end
end

S:On("PLAYER_ENTERING_WORLD", function()
    playerTokens = nil
    if not logReady then C_Timer.After(5, settle) end
    C_Timer.After(2, function()
        local ok, err = pcall(function()
            StewardCharDB.loadTrace = { "start", G.guide and G.guide.name or "no guide yet" }
            if not S:Get("guideShow") then return end
            if G.guide then S:UpdateGuide() return end
            local g, fresh, startStep = S:PickGuide()
            table.insert(StewardCharDB.loadTrace, "picked " .. tostring(g and g.name) .. " @" .. tostring(startStep) .. " " .. tostring(fresh))
            if g and fresh == "back" then
                -- start exactly at the first step with your quests (no jumping ahead)
                S:LoadGuide(g, true, startStep, true)
                S:UpdateGuide()
            elseif g then
                S:LoadGuide(g, fresh, startStep)
            end
        end)
        if not ok then S:LogError("guide load", err) end
    end)
end)

-- tracker header: the zone you're working in plus overall progress
function S:GuideHeader()
    if not self:Get("guideShow") then return "Steward" end      -- the guide is off: only a trip shows (GuideTracker)
    if self:GuideMode() == "free" then return "Guide: Free" end
    local g = G.guide
    if not g then return "Guide" end
    local zone
    local cur = G.current
    if cur then
        for _, el in ipairs(cur.elements) do
            if el.go and self:GateOK(el.gate) then
                local r = self:ResolveGoto(el.go)
                local info = r and r.mapID and C_Map.GetMapInfo(r.mapID)
                if info then zone = info.name end
                break
            end
        end
    end
    zone = zone or (g.name:gsub("^[%d%-]+%s*", ""):gsub("%s*%(.-%)%s*$", ""))
    local route = G.route
    -- the tracker's heading is one line: keep it short enough to show whole
    local MAX = 26
    local pct
    if route and route.totalSteps and route.totalSteps > 0 and g.routeOffset and cur then
        local idx = cur.standInFor and G.frontier and G.frontier.index or cur.index -- (a step of an earlier chapter: where you are)
        pct = math.floor((g.routeOffset + idx) / route.totalSteps * 100)
    end
    local suffix = pct and string.format(" %d%%", pct) or ""
    for _, text in ipairs({ "Guide: " .. zone .. suffix, zone .. suffix, "Guide" .. suffix }) do
        if #text <= MAX then return text end
    end
    return "Guide" .. suffix
end

-- what each trainer service costs, noted whenever a trainer window is open
local function noteTrainerCosts()
    if not (GetNumTrainerServices and GetTrainerServiceInfo and GetTrainerServiceCost) then return end
    S.trainCost = S.trainCost or {}
    for i = 1, GetNumTrainerServices() or 0 do
        local name, _, category = S.TrainerService(i)
        if name and category == "available" then
            local ok, cost = pcall(GetTrainerServiceCost, i)
            if ok and type(cost) == "number" then S.trainCost[name] = cost end
        end
    end
    if S.UpdateGuide then pcall(S.UpdateGuide, S) end
end
S:On("TRAINER_SHOW", function() C_Timer.After(0.2, noteTrainerCosts) end)
S:On("TRAINER_UPDATE", function() C_Timer.After(0.2, noteTrainerCosts) end)
