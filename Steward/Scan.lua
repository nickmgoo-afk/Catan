local _, S = ...

-- Automatic scan: records what this client and character actually have, so the
-- rotation and gear rules can be built from Forever's real data. Saved in
-- WTF\Account\<account>\<realm>\<character>\SavedVariables\Steward.lua on logout or /reload.

local function packed(...) return { n = select("#", ...), ... } end

local function safe(fn, ...)
    if type(fn) ~= "function" then return nil end
    local r = packed(pcall(fn, ...))
    if not r[1] then return { error = tostring(r[2]) } end
    local out = {}
    for i = 2, r.n do out[i - 1] = r[i] end
    return out
end

local function apiPresence()
    local names = {
        "C_AssistedCombat", "C_SpellBook", "C_Spell", "C_TooltipInfo", "TooltipDataProcessor", "Settings",
        "C_Item", "C_Container", "C_ClassTalents", "C_Traits", "C_SpecializationInfo", "C_QuestLog",
        "C_ActionBar", "C_UnitAuras", "C_Secrets", "C_CurveUtil", "C_DurationUtil",
        "GetTalentTabInfo", "GetTalentInfo", "GetNumTalentTabs", "GetSpecialization", "CanDualWield",
        "EquipPendingItem", "GetSkillLineInfo", "GetNumSkillLines", "GetSpellBookItemName", "GetSpellInfo",
        "GetNumSpellTabs", "GetSpellTabInfo", "IsSpellKnown", "UnitAura", "GetShapeshiftFormInfo",
        "GetComboPoints", "GetRuneCooldown", "IsUsableSpell", "GetSpellCooldown",
    }
    local t = {}
    for _, n in ipairs(names) do t[n] = type(_G[n]) end
    if C_AssistedCombat then
        local fns = {}
        for k, v in pairs(C_AssistedCombat) do fns[#fns + 1] = k .. ":" .. type(v) end
        table.sort(fns)
        t.C_AssistedCombat_functions = fns
    end
    return t
end

local function spellbook()
    local list = {}
    if C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines then
        local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player or 0
        local lines = C_SpellBook.GetNumSpellBookSkillLines() or 0
        for l = 1, lines do
            local li = C_SpellBook.GetSpellBookSkillLineInfo(l)
            if li then
                for i = li.itemIndexOffset + 1, li.itemIndexOffset + li.numSpellBookItems do
                    local it = C_SpellBook.GetSpellBookItemInfo(i, bank)
                    if it then
                        list[#list + 1] = { tab = li.name, name = it.name, rank = it.subName, id = it.spellID,
                            actionID = it.actionID, type = it.itemType, passive = it.isPassive,
                            offSpec = it.isOffSpec }
                    end
                end
            end
        end
    elseif GetNumSpellTabs then
        for tab = 1, GetNumSpellTabs() do
            local tabName, _, offset, num = GetSpellTabInfo(tab)
            for i = offset + 1, offset + num do
                local name, rank, id = GetSpellBookItemName(i, BOOKTYPE_SPELL or "spell")
                local kind, spellID = GetSpellBookItemInfo(i, BOOKTYPE_SPELL or "spell")
                list[#list + 1] = { tab = tabName, name = name, rank = rank, id = id or spellID, type = kind }
            end
        end
    end
    return list
end

local function talents()
    local out = { tabs = {} }
    local n = 0
    if GetNumTalentTabs then
        local ok, v = pcall(GetNumTalentTabs)
        if ok and type(v) == "number" then n = v end
    end
    for tab = 1, n do
        local t = { info = safe(GetTalentTabInfo, tab), points = S:TabPoints(tab), talents = {} }
        local cnt = safe(GetNumTalents, tab)
        local num = cnt and type(cnt[1]) == "number" and cnt[1] or 0
        for i = 1, num do t.talents[i] = safe(GetTalentInfo, tab, i) end
        out.tabs[tab] = t
    end
    out.specialization = safe(GetSpecialization)
    return out
end

local function skills()
    local out = {}
    if GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            out[#out + 1] = safe(GetSkillLineInfo, i)
        end
    end
    return out
end

local function gear()
    local weights = S:Weights()
    local out = {}
    for slot = 1, 19 do
        local link = GetInventoryItemLink("player", slot)
        if link then
            local info = S:ReadItem(link)
            out[slot] = {
                link = link,
                rawStats = safe((C_Item and C_Item.GetItemStats) or GetItemStats, link),
                parsed = info and info.stats,
                score = info and S:Score(info, slot, weights),
                tooltip = (function()
                    local t = {}
                    for _, l in ipairs(S:TooltipLines(link)) do t[#t + 1] = l.leftText end
                    return t
                end)(),
            }
        end
    end
    return out
end

local function assisted()
    if not C_AssistedCombat then return nil end
    local out = {}
    for _, fn in ipairs({ "IsAvailable", "GetRotationSpells", "GetNextCastSpell" }) do
        if C_AssistedCombat[fn] then out[fn] = safe(C_AssistedCombat[fn]) end
    end
    return out
end


-- what Forever's quest tracker is built from, so the guide can match it exactly
local function trackerProbe()
    local out = { globals = {}, atlases = {}, sounds = {}, fonts = {} }
    for k, v in pairs(_G) do
        if type(k) == "string" and (k:find("ObjectiveTracker") or k:find("QuestWatch") or k:find("WatchFrame")
            or k:find("^QuestObjective") or k:find("TrackerModule") or k:find("ScenarioObjective")) then
            out.globals[#out.globals + 1] = k .. ":" .. type(v)
        end
    end
    table.sort(out.globals)
    local tr = _G.ObjectiveTrackerFrame or _G.WatchFrame or _G.QuestWatchFrame
    if tr then
        out.frame = tr:GetName()
        out.points = {}
        for i = 1, tr:GetNumPoints() do
            local p, rel, rp, x, y = tr:GetPoint(i)
            out.points[i] = { p, rel and rel.GetName and rel:GetName() or tostring(rel), rp, x, y }
        end
        out.protected = { tr:IsProtected() }
        out.size = { tr:GetSize() }
        out.children = {}
        for _, c in ipairs({ tr:GetChildren() }) do
            out.children[#out.children + 1] = (c:GetName() or "?") .. ":" .. c:GetObjectType()
        end
    end
    for _, a in ipairs({ "ui-questtracker-tracker-check", "Tracker-Check", "common-icon-checkmark",
        "UI-QuestTracker-Secondary-Objective-Header", "ui-questtrackerbutton-collapse", "ui-questtrackerbutton-expand",
        "UI-QuestTrackerButton-Secondary-Collapse", "UI-QuestTrackerButton-Secondary-Expand",
        "Objective-Header", "Objective-Nub", "Objective-Complete", "ui-questtracker-objfx-highlight",
        "UI-QuestTracker-Primary-Objective-Header", "QuestObjectiveTracker-FlashLine" }) do
        out.atlases[a] = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(a) ~= nil or false
    end
    if SOUNDKIT then
        for k, v in pairs(SOUNDKIT) do
            if type(k) == "string" and (k:find("QUEST") or k:find("OBJECTIVE")) then out.sounds[#out.sounds + 1] = k .. "=" .. tostring(v) end
        end
        table.sort(out.sounds)
    end
    for _, n in ipairs({ "ObjectiveTrackerHeaderFont", "ObjectiveTrackerLineFont", "ObjectiveFont", "GameFontNormalMed2" }) do
        out.fonts[n] = _G[n] ~= nil
    end
    out.waypointAPI = {
        SetUserWaypoint = C_Map and C_Map.SetUserWaypoint ~= nil, UiMapPoint = UiMapPoint ~= nil,
        SuperTrack = C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint ~= nil,
        GetMapPosFromWorldPos = C_Map and C_Map.GetMapPosFromWorldPos ~= nil,
        GetWorldPosFromMapPos = C_Map and C_Map.GetWorldPosFromMapPos ~= nil,
        UnitPosition = UnitPosition and { UnitPosition("player") } or false,
    }
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local pos = mapID and C_Map.GetPlayerMapPosition(mapID, "player")
    out.mapPos = { mapID = mapID, x = pos and pos.x, y = pos and pos.y }
    return out
end

-- checks the guides against this client's real maps: every zone name and map number
-- the guides use must exist here, or that step's arrow can't find its spot
local function guideDataCheck()
    local names, ids, missing = {}, {}, { names = {}, ids = {} }
    for _, g in ipairs(S.guides or {}) do
        for _, st in ipairs(g.steps) do
            for _, el in ipairs(st.elements) do
                if el.go and el.go.zoneName then names[el.go.zoneName] = true end
                if el.go and el.go.mapID then ids[el.go.mapID] = true end
                if el.cmd == "zone" and el.args[1] then
                    if tonumber(el.args[1]) then ids[tonumber(el.args[1])] = true else names[el.args[1]] = true end
                end
            end
        end
    end
    local nN, nI = 0, 0
    for n in pairs(names) do
        nN = nN + 1
        if not (S.MapByName and S.MapByName(n)) then missing.names[#missing.names + 1] = n end
    end
    for id in pairs(ids) do
        nI = nI + 1
        if not (C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(id)) then missing.ids[#missing.ids + 1] = id end
    end
    missing.checked = nN .. " zone names, " .. nI .. " map ids"
    return missing
end

-- Where each of this client's maps lies in the world: the game's own answer, kept in the saved file. Forever has
-- maps the classic tables do not know (Zephras Isle and others), and without this a spot given as "x, y on map N"
-- cannot be put in the world when the routes are checked. One small table, written once a session.
local framesDone = false
local function mapFrames()
    if framesDone or not (StewardDB and S.Path and S.Path.ZoneInfo) then return end
    framesDone = true
    local ids = {}
    for id in pairs(S.PathData or {}) do
        if type(id) == "number" then ids[id] = true end
    end
    for _, T in ipairs({ S.QDB_NPCS or {}, S.QDB_OBJECTS or {} }) do
        for _, e in pairs(T) do
            if type(e) == "table" and type(e[2]) == "table" then
                for _, sp in ipairs(e[2]) do
                    if type(sp) == "table" and type(sp[1]) == "number" then ids[sp[1]] = true end
                end
            end
        end
    end
    for _, g in ipairs(S.guides or {}) do
        for _, st in ipairs(g.steps or {}) do
            for _, el in ipairs(st.elements or {}) do
                if el.go and type(el.go.mapID) == "number" then ids[el.go.mapID] = true end
            end
        end
    end
    local out = {}
    for id in pairs(ids) do
        local z = S.Path.ZoneInfo(id)
        local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(id)
        local name, parent = info and info.name or "", info and info.parentMapID or 0
        if z then
            out[id] = { z.inst, z.ox, z.oy, z.ax, z.ay, z.bx, z.by, name, parent }
        else
            out[id] = { false, 0, 0, 0, 0, 0, 0, name, parent }
        end
    end
    StewardDB.mapFrames = out
end
S.MapFrames = mapFrames

function S:RunScan()
    local build = packed(GetBuildInfo())
    local _, class = UnitClass("player")
    local _, race = UnitRace("player")
    local level = UnitLevel("player")
    local book = spellbook()
    StewardCharDB.scan = {
        when = date("%Y-%m-%d %H:%M"),
        steward = S.version,
        build = { build[1], build[2], build[3], build[4] },
        locale = GetLocale(),
        name = UnitName("player"), class = class, race = race, level = level,
        faction = UnitFactionGroup("player"),
        spec = S:SpecLabel(),
        api = apiPresence(),
        spellbook = book,
        talents = talents(),
        skills = skills(),
        gear = gear(),
        assisted = assisted(),
        canDualWield = CanDualWield and CanDualWield() or nil,
        guideData = S.trackerProbeDone and (StewardCharDB.scan and StewardCharDB.scan.guideData) or guideDataCheck(),
        tracker = S.trackerProbeDone and (StewardCharDB.scan and StewardCharDB.scan.tracker) or trackerProbe(),
        questLog = (function()
            local ok, n, max = pcall(S.QuestLogCount, S)
            local all = C_QuestLog and C_QuestLog.GetMaxNumQuests and C_QuestLog.GetMaxNumQuests()
            return { count = ok and n or tostring(n), canAccept = ok and max or nil, max = all }
        end)(),
        bars = (function()
            local t = { version = S.version }
            local ok, regions = pcall(S.BarRegions, S)
            t.regions = ok and regions or ("error: " .. tostring(regions))
            t.frames = {}
            for _, n in ipairs({ "MainActionBar", "MainMenuBar", "MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarRight", "MultiBarLeft", "MultiBar5" }) do
                local f = _G[n]
                if f then
                    t.frames[n] = { shown = f:IsShown(), n = f.numButtonsShowable, l = f.GetLeft and f:GetLeft(), r = f.GetRight and f:GetRight(),
                        b = f.GetBottom and f:GetBottom(), top = f.GetTop and f:GetTop() }
                end
            end
            t.buttons = {}
            for _, n in ipairs({ "ActionButton1", "MultiBarBottomLeftButton1", "MultiBarBottomRightButton1", "MultiBarRightButton1", "MultiBarLeftButton1" }) do
                local b = _G[n]
                if b then t.buttons[n] = { action = b.action, attr = b.GetAttribute and b:GetAttribute("action") } end
            end
            t.actions = {}
            if GetActionInfo then
                for slot = 1, 120 do
                    local kind, id = GetActionInfo(slot)
                    if kind then t.actions[#t.actions + 1] = slot .. " " .. kind .. " " .. tostring(id) end
                end
            end
            t.flyouts = {}
            if GetFlyoutInfo and GetFlyoutSlotInfo then
                for _, sp in ipairs(book) do
                    if sp.type == 4 and sp.actionID then
                        local okF, name, _, n = pcall(GetFlyoutInfo, sp.actionID)
                        local members = {}
                        for i = 1, okF and n or 0 do
                            local sid, _, known, sname = GetFlyoutSlotInfo(sp.actionID, i)
                            members[#members + 1] = tostring(sname) .. " " .. tostring(sid) .. (known and "" or " (unknown)")
                        end
                        t.flyouts[sp.name] = members
                    end
                end
            end
            t.bonus = C_ActionBar and C_ActionBar.GetBonusBarOffset and C_ActionBar.GetBonusBarOffset()
            local okP, plan = pcall(S.BarPlan, S)
            if okP then
                t.plan = {}
                for _, e in ipairs(plan) do t.plan[#t.plan + 1] = e.role .. " " .. e.name end
            else
                t.plan = "error: " .. tostring(plan)
            end
            return t
        end)(),
        specAPI = (function()
            local t = {}
            local SI = C_SpecializationInfo
            if SI then
                for k, v in pairs(SI) do t[#t + 1] = k .. ":" .. type(v) end
                table.sort(t)
                if SI.GetSpecialization then t.current = { pcall(SI.GetSpecialization) } end
            end
            if C_ClassTalents and C_ClassTalents.GetActiveConfigID then t.config = { pcall(C_ClassTalents.GetActiveConfigID) } end
            local okP, pts = pcall(S.TraitPoints, S)
            t.traitPoints = okP and pts or ("error: " .. tostring(pts))
            return t
        end)(),
        taxiProbe = (function()
            local out = {}
            if not (C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap) then return "no C_TaxiMap.GetTaxiNodesForMap" end
            for _, mapID in ipairs({ 1415, 1414 }) do
                local ok, list = pcall(C_TaxiMap.GetTaxiNodesForMap, mapID)
                local r = { total = 0, known = 0, undiscovered = 0, names = {},
                    trusted = ok and list and S.WorldMapFlightListTrusted and S.WorldMapFlightListTrusted(list) or false }
                for _, n in ipairs(ok and list or {}) do
                    r.total = r.total + 1
                    if n.isUndiscovered then r.undiscovered = r.undiscovered + 1 end
                    if S.FlightNodeKnown and S.FlightNodeKnown(n) then
                        r.known = r.known + 1
                        if #r.names < 30 then r.names[#r.names + 1] = n.name end
                    end
                end
                out[mapID] = r
            end
            out.saved = {}
            for name in pairs(StewardCharDB.flightPaths or {}) do out.saved[#out.saved + 1] = name end
            return out
        end)(),
        talentProbe = (function()
            local out, CT, T = {}, C_ClassTalents, C_Traits
            local ok, err = pcall(function()
                local configID = CT and CT.GetActiveConfigID and CT.GetActiveConfigID()
                out.configID = configID
                local info = configID and T and T.GetConfigInfo and T.GetConfigInfo(configID)
                if not info then return end
                out.configName, out.treeIDs = info.name, info.treeIDs
                out.nodes, out.ranked, out.xs = 0, {}, {}
                for _, treeID in ipairs(info.treeIDs or {}) do
                    for _, nodeID in ipairs(T.GetTreeNodes(treeID) or {}) do
                        out.nodes = out.nodes + 1
                        local node = T.GetNodeInfo(configID, nodeID)
                        if node and node.posX and #out.xs < 80 then out.xs[#out.xs + 1] = node.posX end
                        if node then
                            out.all = out.all or {}
                            local eid = (node.activeEntry and node.activeEntry.entryID) or (node.entryIDs and node.entryIDs[1])
                            local e = eid and T.GetEntryInfo and T.GetEntryInfo(configID, eid)
                            local d = e and e.definitionID and T.GetDefinitionInfo and T.GetDefinitionInfo(e.definitionID)
                            local sp = d and (d.spellID or d.overriddenSpellID)
                            local nm = sp and C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(sp)
                            out.all[#out.all + 1] = string.format("%s %d/%d @%d,%d%s%s", tostring(nm),
                                node.ranksPurchased or 0, node.maxRanks or 0, node.posX or 0, node.posY or 0,
                                node.canPurchaseRank and " open" or "", node.entryIDs and #node.entryIDs > 1 and " choice" or "")
                        end
                        if node and (node.ranksPurchased or node.currentRank or 0) > 0 and #out.ranked < 40 then
                            local r = { node = nodeID, ranks = node.ranksPurchased or node.currentRank, x = node.posX,
                                y = node.posY, subTree = node.subTreeID }
                            if node.subTreeID and T.GetSubTreeInfo then
                                local st = T.GetSubTreeInfo(configID, node.subTreeID)
                                r.subTreeName = st and st.name
                            end
                            if node.activeEntry and T.GetEntryInfo then
                                local e = T.GetEntryInfo(configID, node.activeEntry.entryID)
                                local d = e and e.definitionID and T.GetDefinitionInfo and T.GetDefinitionInfo(e.definitionID)
                                r.spell = d and (d.spellID or d.overriddenSpellID)
                                r.spellName = r.spell and S.SpellName and S.SpellName(r.spell)
                            end
                            out.ranked[#out.ranked + 1] = r
                        end
                    end
                end
            end)
            if not ok then out.error = tostring(err) end
            return out
        end)(),
        guide = S.G and S.G.guide and { name = S.G.guide.name, step = S.G.current and S.G.current.index } or nil,
    }
    S.trackerProbeDone = true
    -- what the spellbook looked like at each level, for level-aware rotations
    StewardCharDB.spellsByLevel = StewardCharDB.spellsByLevel or {}
    local names = {}
    for _, sp in ipairs(book) do
        if sp.name then names[#names + 1] = sp.name .. (sp.rank and sp.rank ~= "" and (" (" .. sp.rank .. ")") or "") end
    end
    StewardCharDB.spellsByLevel[level] = names
end

-- runs by itself; the game writes it to disk on logout or reload
local pending, lastScan, deferred = false, 0, false
-- does the game tell addons which quests are available nearby? (smarter leveling needs this)
local function questLineProbe()
    local QL = C_QuestLine
    if not (QL and QL.GetAvailableQuestLines and C_Map and C_Map.GetBestMapForUnit) then return end
    local map = C_Map.GetBestMapForUnit("player")
    if not map then return end
    if QL.RequestQuestLinesForMap then pcall(QL.RequestQuestLinesForMap, map) end
    C_Timer.After(3, function()
        local ok, lines = pcall(QL.GetAvailableQuestLines, map)
        local out = { map = map, when = date("%H:%M"), ok = ok }
        if ok and type(lines) == "table" then
            out.count = #lines
            out.list = {}
            for i = 1, math.min(#lines, 20) do
                local q = lines[i]
                out.list[i] = string.format("%s %s %.3f,%.3f%s", tostring(q.questID), tostring(q.questName),
                    q.x or 0, q.y or 0, q.isHidden and " hidden" or "")
            end
        else
            out.err = tostring(lines)
        end
        if C_QuestLog and C_QuestLog.GetQuestsOnMap then
            local ok2, onMap = pcall(C_QuestLog.GetQuestsOnMap, map)
            out.onMap = ok2 and type(onMap) == "table" and #onMap or tostring(onMap)
        end
        if C_Minimap and C_Minimap.GetNumTrackingTypes then
            out.tracking = {}
            for i = 1, C_Minimap.GetNumTrackingTypes() or 0 do
                local info = C_Minimap.GetTrackingInfo(i)
                if info then out.tracking[#out.tracking + 1] = tostring(info.name) .. (info.active and " (on)" or "") end
            end
        end
        if StewardCharDB then
            StewardCharDB.questLines = StewardCharDB.questLines or {}
            StewardCharDB.questLines[map] = out
        end
    end)
end
S.QuestLineProbe = questLineProbe

local function autoScan(delay)
    if pending then return end
    -- at most once a minute (except login and level-up); a change in between is
    -- picked up by one scan as soon as the minute is up, not dropped
    if delay and delay > 4 and GetTime() - lastScan < 60 then
        if not deferred then
            deferred = true
            C_Timer.After(61 - (GetTime() - lastScan), function() deferred = false autoScan(1) end)
        end
        return
    end
    pending = true
    C_Timer.After(delay or 3, function()
        pending = false
        if InCombatLockdown() then C_Timer.After(5, function() autoScan(1) end) return end
        lastScan = GetTime()
        local ok, err = pcall(S.RunScan, S)
        if not ok then StewardCharDB.scanError = tostring(err) end
        pcall(mapFrames)
    end)
end
S:On("PLAYER_ENTERING_WORLD", function() autoScan(3) C_Timer.After(8, function() pcall(questLineProbe) end) end)
S:On("ZONE_CHANGED_NEW_AREA", function() C_Timer.After(5, function() pcall(questLineProbe) end) end)
S:On("PLAYER_LEVEL_UP", function() autoScan(4) end)
S:On("SPELLS_CHANGED", function() autoScan(5) end)
S:On("CHARACTER_POINTS_CHANGED", function() autoScan(3) end)
S:On("PLAYER_EQUIPMENT_CHANGED", function() autoScan(5) end)
