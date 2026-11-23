local _, S = ...

-- Fastest-route planner: when the guide's next spot is far away (another zone or
-- continent), works out the quickest way there using your known flight paths,
-- boats, zeppelins, the tram, your hearthstone and running, and turns it into steps.

local G = S.G
local Vec = CreateVector2D

---------------------------------------------------------------- transports (dock spots from your guides)
-- a, b: departure points (also used as each other's arrival). mins: average wait + ride.
local TRANSPORTS = {
    { kind = "boat", name = "Auberdine", from = "Stormwind Harbor", faction = "Alliance", mins = 3,
        a = { mapID = 1453, instance = 0, wa = 1330.10, wb = -8645.40 }, b = { mapID = 1439, instance = 1, wa = 929.10, wb = 6543.60 },
        aName = "Stormwind Harbor", bName = "Auberdine" },
    { kind = "boat", faction = "Alliance", mins = 3,
        a = { zoneName = "Darkshore", x = 32.4, y = 43.9 }, b = { zoneName = "Wetlands", x = 4.9, y = 56.7 },
        aName = "Auberdine", bName = "Menethil Harbor" },
    { kind = "boat", faction = "Alliance", mins = 3,
        a = { zoneName = "Darkshore", x = 33.2, y = 40.2 }, b = { zoneName = "Teldrassil", x = 55.0, y = 93.5 },
        aName = "Auberdine", bName = "Rut'theran Village" },
    { kind = "boat", faction = "Alliance", mins = 3,
        a = { zoneName = "Wetlands", x = 9.5, y = 59.7 }, b = { zoneName = "Dustwallow Marsh", x = 66.4, y = 45.0 },
        aName = "Menethil Harbor", bName = "Theramore" },
    { kind = "boat", mins = 3,
        a = { zoneName = "Stranglethorn Vale", x = 26.7, y = 73.0 }, b = { zoneName = "The Barrens", x = 63.7, y = 38.6 },
        aName = "Booty Bay", bName = "Ratchet" },
    -- the tram: a 65 s ride (Nick's ride log, 2026-11-16: 2,516 yd in 65.4 s) plus about 70 s waiting on average
    -- (the game's tram cars go round in about 143 s)
    { kind = "tram", faction = "Alliance", mins = 2.25,
        a = { mapID = 1453, instance = 0, wa = 522.12, wb = -8352.80 }, b = { mapID = 1455, instance = 0, wa = -1330.28, wb = -4840.43 },
        aName = "Stormwind City", bName = "Ironforge" },
    { kind = "zeppelin", faction = "Horde", mins = 3,
        a = { zoneName = "Durotar", x = 50.8, y = 13.8 }, b = { zoneName = "Tirisfal Glades", x = 60.6, y = 58.7 },
        aName = "Orgrimmar", bName = "the Undercity" },
    { kind = "zeppelin", faction = "Horde", mins = 3,
        a = { zoneName = "Durotar", x = 50.8, y = 13.8 }, b = { zoneName = "Stranglethorn Vale", x = 31.9, y = 28.5 },
        aName = "Orgrimmar", bName = "Grom'gol" },
    { kind = "zeppelin", faction = "Horde", mins = 3,
        a = { zoneName = "Stranglethorn Vale", x = 31.9, y = 28.5 }, b = { zoneName = "Tirisfal Glades", x = 60.6, y = 58.7 },
        aName = "Grom'gol", bName = "the Undercity" },
    -- Zephras Isle: the skycutter from the small dock southeast of Valanaar to Dalaran's platform
    -- (spots from the Skyborne guide's own steps), and Dalaran's Skyborne portal to Stormwind's
    -- Mage Quarter. The portal only goes one way: Stormwind has none back (come back by land and
    -- the skycutter). Where the portal lands is learned the first time you take it.
    { kind = "skycutter", faction = "Alliance", mins = 5,
        a = { mapID = 2521, x = 65.81, y = 83.44 }, b = { mapID = 1416, instance = 0, wa = 438.93, wb = 448.88 },
        aName = "Valanaar", bName = "Dalaran" },
    { kind = "portal", faction = "Alliance", mins = 0.5, oneway = true, learn = "dalaran-stormwind",
        a = { mapID = 1416, instance = 0, wa = 445.93, wb = 450.00 }, b = { mapID = 1453, instance = 0, wa = 862.0, wb = -8990.0 },
        aName = "Dalaran", bName = "Stormwind" },
}
S.TRANSPORTS = TRANSPORTS

-- Teleports you can cast (0.84.0): a mage's six city teleports (each takes a Rune of Teleportation) and a druid's
-- Teleport: Moonglade (no reagent). Where each lands (north, west, continent): the game's spell target positions as
-- the classic servers have them; every one of them stands on a floor at that very height in Forever's own 3D data
-- (checked 2026-11-22). Where a teleport really lands is noted the first time you use it (StewardDB.teleportLanding).
-- secs: the 10 s cast and the loading screen.
local RUNE_OF_TELEPORTATION = 17031
local TELEPORTS = {
    { spell = 3561, class = "MAGE", rune = true, name = "Stormwind", inst = 0, n = -9003.46, w = 870.03 },
    { spell = 3562, class = "MAGE", rune = true, name = "Ironforge", inst = 0, n = -4613.62, w = -915.38 },
    { spell = 3563, class = "MAGE", rune = true, name = "the Undercity", inst = 0, n = 1773.47, w = 61.12 },
    { spell = 3565, class = "MAGE", rune = true, name = "Darnassus", inst = 1, n = 9660.81, w = 2513.64 },
    { spell = 3566, class = "MAGE", rune = true, name = "Thunder Bluff", inst = 1, n = -964.98, w = 283.43 },
    { spell = 3567, class = "MAGE", rune = true, name = "Orgrimmar", inst = 1, n = 1469.85, w = -4221.52 },
    { spell = 18960, class = "DRUID", name = "Moonglade", inst = 1, n = 7991.88, w = -2679.84 },
    -- Forever's own (warcraft.wiki.gg, 2026-11-22: spell 1297659, level 50, a Rune of Teleportation, Alliance only).
    -- Where it lands isn't published: first guess Dalaran's skycutter platform, noted for real the first time
    { spell = 1297659, class = "MAGE", faction = "Alliance", rune = true, name = "Dalaran", inst = 0, n = 448.88, w = 438.93, learnR = 700 },
}
S.TELEPORTS = TELEPORTS
local TELEPORT_SECS = 20
local function knowsSpell(id)
    if IsPlayerSpell then
        local ok, v = pcall(IsPlayerSpell, id)
        if ok and v ~= nil and not S.Secret(v) then return v == true end
    end
    if IsSpellKnown then
        local ok, v = pcall(IsSpellKnown, id)
        if ok and not S.Secret(v) then return v == true end
    end
    return false
end
-- the teleports you can cast now: known, and the rune in your bags where one is needed
function S:TeleportsReady()
    local _, class = UnitClass("player")
    local out = {}
    local runes
    for _, t in ipairs(TELEPORTS) do
        if t.class == class and (not t.faction or t.faction == UnitFactionGroup("player")) and knowsSpell(t.spell) then
            if t.rune and runes == nil then
                runes = ((C_Item and C_Item.GetItemCount) or GetItemCount)(RUNE_OF_TELEPORTATION) or 0
                if S.Secret(runes) then runes = 1 end
            end
            if not t.rune or runes > 0 then out[#out + 1] = t end
        end
    end
    return out
end

-- where a one-way portal really lands you: noted the first time you go through it
local portalNear, portalAt
local function landing(t)
    local l = StewardDB and StewardDB.portalLanding and StewardDB.portalLanding[t.learn or ""]
    if l and l.wa and l.wb then return { mapID = t.b.mapID, instance = l.instance or t.b.instance, wa = l.wa, wb = l.wb } end
    return t.b
end

local CONTINENT_MAPS = { 1415, 1414 } -- Eastern Kingdoms, Kalimdor

---------------------------------------------------------------- helpers
local function point(world, instance, name)
    local mapID, pos = C_Map.GetMapPosFromWorldPos(instance, world)
    local g = { radius = 15, resolved = { world = world, instance = instance, mapID = mapID, x = pos and pos.x or 0, y = pos and pos.y or 0 } }
    return { world = world, instance = instance, name = name, go = g }
end

local function fromGoto(g, name)
    local r = S:ResolveGoto(g)
    if not (r and r.world) then return nil end
    return point(r.world, r.instance, name)
end

-- zones you can't run to from the mainland (Teldrassil/Darnassus, Zephras Isle)
local ISLANDS = { [1438] = "teldrassil", [1457] = "teldrassil", [2521] = "zephras" }
-- a map, or the zone it lies in (a town map inside Zephras Isle counts as Zephras Isle)
local function islandOfMap(mapID)
    for _ = 1, 8 do
        if not mapID then break end
        if ISLANDS[mapID] then return ISLANDS[mapID] end
        local info = C_Map.GetMapInfo(mapID)
        mapID = info and info.parentMapID
    end
    return "main"
end
local CONTINENT_IDS = { [1414] = true, [1415] = true }
local function island(p)
    if p.island then return p.island end
    if p.instance == 2991 then return "zephras" end          -- Zephras Isle is a map of its own: all of it
    local r = p.go and p.go.resolved
    local mapID = r and r.mapID
    -- the game named no zone for this spot (or only the continent): ask each island's own map whether the spot is
    -- on it (Nick 2026-11-22: the trip to Narla on Teldrassil came back empty; Rut'theran and the Darnassus portal
    -- counted as the mainland, so nothing could run on to her)
    if (not mapID or CONTINENT_IDS[mapID]) and p.world and C_Map.GetMapPosFromWorldPos then
        for id, name in pairs(ISLANDS) do
            local ok, m, pos = pcall(C_Map.GetMapPosFromWorldPos, p.instance, p.world, id)
            if ok and m == id and pos and pos.x and pos.x > 0 and pos.x < 1 and pos.y > 0 and pos.y < 1 then
                p.island = name
                return name
            end
        end
    end
    p.island = islandOfMap(mapID)
    return p.island
end

local function runDist(p, q)
    if p.instance ~= q.instance or island(p) ~= island(q) then return nil end
    local dx, dy = p.world.x - q.world.x, p.world.y - q.world.y
    return math.sqrt(dx * dx + dy * dy)
end

local function dist(p, q)
    if p.instance ~= q.instance then return nil end
    local dx, dy = p.world.x - q.world.x, p.world.y - q.world.y
    return math.sqrt(dx * dx + dy * dy)
end

local function runSpeed()
    local lvl = UnitLevel("player")
    if lvl >= 60 then return 12 elseif lvl >= 40 then return 10 end
    return 7
end

-- is this flight path one you can use? The flight-map list says so with "state"; the
-- world-map list (GetTaxiNodesForMap) instead says "isUndiscovered" and which faction owns it.
local function nodeKnown(n)
    local E = Enum or {}
    if n.state ~= nil then
        local st = E.FlightPathState
        return not st or n.state == st.Current or n.state == st.Reachable
    end
    if n.isUndiscovered then return false end
    local F, mine = E.FlightPathFaction, UnitFactionGroup("player")
    if F and n.faction == F.Horde and mine ~= "Horde" then return false end
    if F and n.faction == F.Alliance and mine ~= "Alliance" then return false end
    return true
end
S.FlightNodeKnown = nodeKnown

-- The world map's flight list only helps if it can tell which ones you know. WoW: Forever's
-- marks every flight path on the continent as discovered, so there it's ignored and only the
-- flight paths seen on your own flight maps count (those say exactly which you can fly to).
local function worldMapListIsTrustworthy(list)
    local total, undiscovered = 0, 0
    for _, n in ipairs(list) do
        if n.state ~= nil then return true end
        total = total + 1
        if n.isUndiscovered then undiscovered = undiscovered + 1 end
    end
    return total > 0 and undiscovered > 0
end
S.WorldMapFlightListTrusted = worldMapListIsTrustworthy

local function flightNodes()
    local nodes = {}
    if not (C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap) then return nodes end
    local lists, trusted = {}, false
    for _, mapID in ipairs(CONTINENT_MAPS) do
        local ok, list = pcall(C_TaxiMap.GetTaxiNodesForMap, mapID)
        list = ok and list or {}
        lists[mapID] = list
        if worldMapListIsTrustworthy(list) then trusted = true end
    end
    if trusted then
        for mapID, list in pairs(lists) do
            for _, n in ipairs(list) do
                if nodeKnown(n) and n.position then
                    local inst, world = C_Map.GetWorldPosFromMapPos(mapID, n.position)
                    if world then
                        local p = point(world, inst, (n.name or "?"):gsub(",.*$", ""))
                        p.fp, p.full = true, n.name
                        nodes[#nodes + 1] = p
                    end
                end
            end
        end
    end
    -- what the game reports can be empty until you visit a flight master: add the
    -- flight paths Steward has seen on your flight maps
    local saved = StewardCharDB.flightPaths or {}
    for name, f in pairs(saved) do
        local dup = false
        for _, n in ipairs(nodes) do if n.name == name then dup = true break end end
        if not dup then
            local p = point(Vec(f.wx, f.wy), f.instance, name)
            p.fp, p.full = true, f.full
            nodes[#nodes + 1] = p
        end
    end
    return nodes
end

-- remember every flight path you know, each time a flight map opens
S:On("TAXIMAP_OPENED", function()
    if not (C_TaxiMap and C_TaxiMap.GetAllTaxiNodes and GetTaxiMapID) then return end
    local mapID = GetTaxiMapID()
    local ok, list = pcall(C_TaxiMap.GetAllTaxiNodes, mapID)
    if not ok or not list then return end
    StewardCharDB.flightPaths = StewardCharDB.flightPaths or {}
    StewardCharDB.flightPathsSeen = StewardCharDB.flightPathsSeen or {}
    for _, n in ipairs(list) do
        local known = nodeKnown(n)
        if n.name then StewardCharDB.flightPathsSeen[(n.name:gsub(",.*$", ""))] = n.name end
        if known and n.position and n.name then
            local inst, world = C_Map.GetWorldPosFromMapPos(mapID, n.position)
            if world then
                StewardCharDB.flightPaths[(n.name:gsub(",.*$", ""))] = { wx = world.x, wy = world.y, instance = inst, full = n.name }
            end
        end
    end
end)

-- the current step, the steps along the way, and planned stops you're standing at
local function stepsHere()
    if S.ActiveSteps then return S.ActiveSteps() end
    return { S.G.current }
end

-- Take the flight the guide wants as soon as you open the flight map. Hold Shift to pick yourself.
local function wantedFlight()
    local G = S.G
    -- going to a group member: that trip's flight comes first (you asked for it by name)
    for _, leg in ipairs(S.FollowTravel and S:FollowTravel() or {}) do
        if leg.kind == "fly" and leg.target then return leg.target.full or leg.target.name end
    end
    for _, step in ipairs(stepsHere()) do
        for _, el in ipairs(step.elements) do
            if el.cmd == "fly" and el.args[1] and S:GateOK(el.gate) and S:ElementStatus(step, el) == "active" then
                return el.args[1]
            end
        end
    end
    -- the travel planner's flight
    for _, leg in ipairs(G.travel or {}) do
        if leg.kind == "fly" and leg.target then return leg.target.full or leg.target.name end
    end
end

-- the flight-map node for a guide name: a town ("Sentinel Hill"), a zone ("Westfall") or "Town, Zone"
function S.MatchTaxiNode(nodes, want)
    if not want or want == "" then return nil end
    want = want:lower():gsub(",.*$", "")
    local reach = Enum and Enum.FlightPathState and Enum.FlightPathState.Reachable or 1
    local town, zone
    for _, n in ipairs(nodes or {}) do
        if n.name and n.state == reach then
            local full = n.name:lower()
            local t = full:gsub(",.*$", "")
            local z = full:match(",%s*(.-)%s*$")
            if t == want then return n end
            if not town and (t:find(want, 1, true) or want:find(t, 1, true)) then town = n end
            if not zone and z and (z:find(want, 1, true) or want:find(z, 1, true)) then zone = n end
        end
    end
    return town or zone
end

-- does the guide want a new flight path from this flight master?
local function wantsFlightPath()
    for _, step in ipairs(stepsHere()) do
        for _, el in ipairs(step.elements) do
            if el.cmd == "fp" and S:GateOK(el.gate) and S:ElementStatus(step, el) == "active" then return true end
        end
    end
    return false
end

-- Talking to a flight master that opens with a chat window: pick "I need to fly" when the guide
-- wants a flight (or the flight path), so the flight map opens and the flight is taken.
-- Returns true when it picked the option. Called after quests have had their turn.
local TAXI_ICON = 132057 -- Interface\GossipFrame\TaxiGossipIcon
function S:GossipTaxi()
    if not self:Get("guideAutoFly") or IsShiftKeyDown() then return false end
    local CG = C_GossipInfo
    if not (CG and CG.GetOptions and CG.SelectOption) then return false end
    if not (wantedFlight() or wantsFlightPath()) then return false end
    local options = CG.GetOptions() or {}
    local pick
    for _, o in ipairs(options) do
        if o.gossipOptionID and (o.icon == TAXI_ICON or o.overrideIconID == TAXI_ICON) then pick = o break end
    end
    if not pick then
        for _, o in ipairs(options) do
            local n = o.name and o.name:lower() or ""
            if o.gossipOptionID and (n:find("need to fly", 1, true) or n:find("where i can fly", 1, true)
                or n:find("need a ride", 1, true)) then pick = o break end
        end
    end
    if not pick then return false end
    CG.SelectOption(pick.gossipOptionID)
    return true
end

-- the guide's "Set your Hearthstone here" step that's waiting, and its inn: the current step,
-- or a planned stop you're standing at (the router may be holding the stop next door first)
function S:WantedHome()
    for _, step in ipairs(stepsHere()) do
        for _, el in ipairs(step.elements) do
            if el.cmd == "home" and self:GateOK(el.gate) and self:ElementStatus(step, el) == "active" then return el end
        end
    end
end

local BINDER_ICON = 132052 -- Interface\GossipFrame\BinderGossipIcon
function S:GossipHome()
    if not self:Get("guideAutoHome") or IsShiftKeyDown() or not self:WantedHome() then return false end
    local CG = C_GossipInfo
    if not (CG and CG.GetOptions and CG.SelectOption) then return false end
    for _, o in ipairs(CG.GetOptions() or {}) do
        local n = o.name and o.name:lower() or ""
        if o.gossipOptionID and (o.icon == BINDER_ICON or o.overrideIconID == BINDER_ICON or n:find("inn your home", 1, true)) then
            CG.SelectOption(o.gossipOptionID)
            return true
        end
    end
    return false
end

-- "Are you sure you want to bind here?" -- yes, when the guide asked for it
S:On("CONFIRM_BINDER", function()
    if not S:Get("guideAutoHome") or IsShiftKeyDown() or not S:WantedHome() then return end
    local PIM, PT = C_PlayerInteractionManager, Enum and Enum.PlayerInteractionType
    if not (PIM and PIM.ConfirmationInteraction and PT and PT.Binder) then return end
    PIM.ConfirmationInteraction(PT.Binder)
    if PIM.ClearInteraction then PIM.ClearInteraction(PT.Binder) end
    if StaticPopup_Hide then StaticPopup_Hide("CONFIRM_BINDER") end
end)

S:On("TAXIMAP_OPENED", function()
    if not S:Get("guideAutoFly") or IsShiftKeyDown() then return end
    C_Timer.After(0.4, function() -- after the guide has ticked off "get the flight path"
        if IsShiftKeyDown() or not (C_TaxiMap and C_TaxiMap.GetAllTaxiNodes and GetTaxiMapID and TakeTaxiNode) then return end
        local want = wantedFlight()
        if not want then return end
        local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes, GetTaxiMapID())
        local node = ok and S.MatchTaxiNode(nodes, want)
        if not (node and node.slotIndex) then return end
        if IsMounted and IsMounted() and Dismount then Dismount() end
        TakeTaxiNode(node.slotIndex)
    end)
end)

-- do you already have this flight path? (from the game, or from flight maps Steward has seen)
local knownNames, knownZones, knownAt = {}, {}, -100
function S:KnowsFlightPath(name)
    if not name or name == "" then return false end
    if GetTime() - knownAt > 30 then
        knownAt = GetTime()
        wipe(knownNames)
        wipe(knownZones)
        local ok, nodes = pcall(flightNodes)
        for _, n in ipairs(ok and nodes or {}) do
            -- "Lakeshire, Redridge": the guide may name the town or the zone
            for _, s in ipairs({ n.full or "", n.name or "" }) do
                if s ~= "" and s ~= "?" then knownNames[#knownNames + 1] = s:lower() end
            end
            local zone = n.full and n.full:match(",%s*(.-)%s*$")
            if zone and zone ~= "" then knownZones[#knownZones + 1] = zone:lower() end
        end
    end
    local want = name:lower()
    for _, k in ipairs(knownNames) do
        if k:find(want, 1, true) or want:find(k, 1, true) then return true end
    end
    for _, z in ipairs(knownZones) do   -- "Redridge Mountains" names the zone of "Lakeshire, Redridge"
        if want:find(z, 1, true) then return true end
    end
    return false
end
S:On("TAXIMAP_CLOSED", function() knownAt = -100 end)

-- Is this a flight path the game has (on a flight map you opened, or on the world map's list)?
-- Only then can "you don't know it" be told apart from a name Steward doesn't recognise.
local function nameMatches(list, want)
    for _, full in ipairs(list) do
        local s = full:lower()
        local town, zone = s:match("^(.-),%s*(.-)%s*$")
        if s:find(want, 1, true) or want:find(town or s, 1, true) or (zone and zone ~= "" and want:find(zone, 1, true)) then
            return true
        end
    end
end
function S:FlightPathExists(name)
    if not name or name == "" then return false end
    local all = {}
    for _, full in pairs(StewardCharDB.flightPathsSeen or {}) do all[#all + 1] = full end
    if C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap then
        for _, mapID in ipairs(CONTINENT_MAPS) do
            local ok, list = pcall(C_TaxiMap.GetTaxiNodesForMap, mapID)
            for _, n in ipairs(ok and list or {}) do if n.name then all[#all + 1] = n.name end end
        end
    end
    return nameMatches(all, name:lower()) and true or false
end

-- "Fly to Westfall" when you've never been to Westfall's flight master: you can't, so the
-- guide's flight is skipped and the travel plan runs you there instead. Only once Steward has
-- seen one of your flight maps (that list is exact), and only for a flight path it recognises.
function S:CantFlyTo(name)
    if not (name and next(StewardCharDB.flightPaths or {})) then return false end
    if UnitOnTaxi and UnitOnTaxi("player") then return false end
    if self:KnowsFlightPath(name) then return false end
    return self:FlightPathExists(name)
end

-- seconds until your hearthstone is ready: 0 = ready now, nil = no hearthstone (or can't tell)
local function hearthWait()
    local getCD = (C_Container and C_Container.GetItemCooldown) or _G.GetItemCooldown
    local count = ((C_Item and C_Item.GetItemCount) or GetItemCount)(6948)
    if not count or count == 0 then return nil end
    local start, dur = getCD(6948)
    if S.Secret(start, dur, count) then return nil end
    if not start or start == 0 then return 0 end
    return math.max(0, start + dur - GetTime())
end
local function hearthReady() return hearthWait() == 0 end
S.HearthWait = hearthWait

-- inns by hearth location name (approximate; Steward also remembers where you actually land)
local INNS = {
    ["Goldshire"] = { "Elwynn Forest", 43.8, 65.8 }, ["Lakeshire"] = { "Redridge Mountains", 27.0, 44.6 },
    ["Sentinel Hill"] = { "Westfall", 52.9, 53.7 }, ["Darkshire"] = { "Duskwood", 73.8, 44.5 },
    ["Thelsamar"] = { "Loch Modan", 35.5, 48.4 }, ["Menethil Harbor"] = { "Wetlands", 10.7, 60.9 },
    ["Kharanos"] = { "Dun Morogh", 47.4, 52.5 }, ["Ironforge"] = { "Ironforge", 18.1, 51.4 },
    ["Auberdine"] = { "Darkshore", 37.0, 44.1 }, ["Astranaar"] = { "Ashenvale", 37.0, 49.3 },
    ["Dolanaar"] = { "Teldrassil", 55.6, 59.8 }, ["Theramore Isle"] = { "Dustwallow Marsh", 66.6, 45.2 },
    ["Southshore"] = { "Hillsbrad Foothills", 51.2, 58.9 }, ["Nijel's Point"] = { "Desolace", 66.3, 6.6 },
    ["Feathermoon Stronghold"] = { "Feralas", 31.0, 43.4 }, ["Gadgetzan"] = { "Tanaris", 52.5, 27.9 },
    ["Booty Bay"] = { "Stranglethorn Vale", 27.0, 77.3 }, ["Ratchet"] = { "The Barrens", 62.0, 39.4 },
    ["Everlook"] = { "Winterspring", 61.3, 38.9 }, ["Aerie Peak"] = { "The Hinterlands", 14.1, 41.5 },
    ["Cenarion Hold"] = { "Silithus", 51.9, 39.2 }, ["Light's Hope Chapel"] = { "Eastern Plaguelands", 81.6, 58.1 },
    ["Razor Hill"] = { "Durotar", 51.5, 41.6 }, ["The Crossroads"] = { "The Barrens", 51.9, 29.9 },
    ["Camp Taurajo"] = { "The Barrens", 44.9, 59.1 }, ["Bloodhoof Village"] = { "Mulgore", 46.6, 61.0 },
    ["Thunder Bluff"] = { "Thunder Bluff", 45.8, 64.7 }, ["Brill"] = { "Tirisfal Glades", 61.7, 52.0 },
    ["Undercity"] = { "Undercity", 67.7, 37.9 }, ["The Sepulcher"] = { "Silverpine Forest", 43.2, 41.3 },
    ["Tarren Mill"] = { "Hillsbrad Foothills", 62.8, 19.0 }, ["Hammerfall"] = { "Arathi Highlands", 73.8, 32.5 },
    ["Grom'gol Base Camp"] = { "Stranglethorn Vale", 32.1, 29.2 }, ["Splintertree Post"] = { "Ashenvale", 73.9, 60.6 },
    ["Sun Rock Retreat"] = { "Stonetalon Mountains", 47.5, 62.1 }, ["Shadowprey Village"] = { "Desolace", 24.1, 68.2 },
    ["Freewind Post"] = { "Thousand Needles", 46.0, 51.5 }, ["Brackenwall Village"] = { "Dustwallow Marsh", 36.0, 32.4 },
    ["Kargath"] = { "Badlands", 2.8, 47.8 }, ["Stonard"] = { "Swamp of Sorrows", 45.0, 56.6 },
    ["Camp Mojache"] = { "Feralas", 74.8, 45.1 }, ["Revantusk Village"] = { "The Hinterlands", 78.2, 81.3 },
}

-- inns some guides call by the inn's name rather than the town's
local INN_ALIASES = { ["Deepwater Tavern"] = "Menethil Harbor", ["Lion's Pride Inn"] = "Goldshire",
    ["Stoutlager Inn"] = "Thelsamar", ["Thunderbrew Distillery"] = "Kharanos", ["Gilded Rose"] = "Stormwind" }

-- the inn named in a guide line ("Hearth back to Auberdine", "...to the Deepwater Tavern")
function S.InnFromText(text)
    if not text then return nil end
    local low, best = text:lower(), nil
    for name in pairs(INNS) do
        local n = name:lower():gsub("^the ", "")
        if low:find(n, 1, true) and (not best or #name > #best) then best = name end
    end
    for alias, name in pairs(INN_ALIASES) do
        if not best and INNS[name] and low:find(alias:lower(), 1, true) then best = name end
    end
    return best
end

-- a guide waypoint at an inn
function S.InnGoto(name)
    local inn = INNS[name]
    if not inn then return nil end
    return { zoneName = inn[1], x = inn[2], y = inn[3], radius = 30 }
end

-- the inn nearest a guide waypoint (within ~300 yards)
function S.InnNear(go)
    local here = go and fromGoto(go, "")
    if not here then return nil end
    local best, bestD
    for name, inn in pairs(INNS) do
        local p = fromGoto({ zoneName = inn[1], x = inn[2], y = inn[3] }, name)
        local d = p and dist(here, p)
        if d and d < 300 and (not bestD or d < bestD) then best, bestD = name, d end
    end
    return best
end

local function bindPoint(fps)
    local saved = StewardCharDB.bind
    local name = GetBindLocation and GetBindLocation()
    if not name then return nil end
    if saved and saved.name == name and saved.wx then
        return point(Vec(saved.wx, saved.wy), saved.instance, name)
    end
    local inn = INNS[name]
    if inn then
        local p = fromGoto({ zoneName = inn[1], x = inn[2], y = inn[3] }, name)
        if p then return p end
    end
    for _, n in ipairs(fps) do
        if n.name:find(name, 1, true) or name:find(n.name, 1, true) then
            return point(n.world, n.instance, name)
        end
    end
end

-- remember exactly where the hearthstone lands you
local hearthing = false
S:On("UNIT_SPELLCAST_SUCCEEDED", function(unit, _, id)
    if S.Secret(unit, id) then return end
    if unit == "player" and id == 8690 then hearthing = true end
end)
S:On("PLAYER_ENTERING_WORLD", function()
    if not hearthing then return end
    hearthing = false
    C_Timer.After(2, function()
        local x, y, inst = S:PlayerWorld()
        if x then StewardCharDB.bind = { name = GetBindLocation(), wx = x, wy = y, instance = inst } end
    end)
end)

S:On("HEARTHSTONE_BOUND", function()
    local x, y, inst = S:PlayerWorld()
    if x then StewardCharDB.bind = { name = GetBindLocation(), wx = x, wy = y, instance = inst } end
end)

---------------------------------------------------------------- the game's own travel network (TravelData.lua)
-- Flight masters, the yards each flight path really flies, boats/zeppelins/skycutters with their real stops, and the
-- walk between every two of these points measured on the 3D world. Where it has no answer the guesses above stay.
-- yards a second on a flight path: the game's own flight yards / 30 matched Nick's six flights of 11-21/22 within 1 s
-- (Ironforge-Thelsamar 4 s); learned from your flights since 0.87.2 (StewardDB.flySpeed). The old 32 yd/s + 20 s made
-- every flight about 15 s too long.
local FLY_SPEED = 30
local FLY_EXTRA = 8       -- seconds a flight costs beside the flying: talk to the flight master, pick, take off
local function flySpeed()
    local v = StewardDB and StewardDB.flySpeed
    return (v and v >= 20 and v <= 45) and v or FLY_SPEED
end
local SHIP_SPEED = 20     -- yards a second on a boat, zeppelin or skycutter (to be learned from real rides)
-- the tables give (north, west); Steward's world spots are in the order the map API wants (Waypoint.lua)
local function swapped() return S:WorldOrder() == "unitswap" end
local function NW(p) if swapped() then return p.world.y, p.world.x end return p.world.x, p.world.y end
local function netVec(n, w) if swapped() then return Vec(w, n) end return Vec(n, w) end

---------------------------------------------------------------- boat timetables (0.87.0)
-- A boat runs the same loop over and over, so one departure seen on your own ride says when it leaves every dock for
-- hours after (Nick 2026-11-22: "how does the routing algorithm not know what is faster?": it averaged half a loop of
-- waiting and guessed the speed). Speed: the game's own leg yards / 25 yd a second matched all three legs Nick rode on
-- 11-22 within 5 s (Auberdine-Menethil 70 s, Menethil-Southshore 134 s, Southshore-Auberdine 74 s; stops about 70 s).
-- Zeppelins and skycutters keep the old guess (none ridden yet). Learned, per ship name, in StewardDB:
--   shipDeps[name] = { { k = stop, at = server time }, ... } newest first (departures seen on your rides)
--   shipLegs[name][k] = seconds from stop k to the next; shipStops[name][k] = seconds a stop lasts; shipCycle[name]
local BOAT_SPEED = 25
local DEP_FRESH = 3 * 3600   -- a departure older than this says nothing (a server restart sets the boats going anew)
local function epoch() return (GetServerTime and GetServerTime()) or (time and time()) or 0 end
local function shipSpeed(name) return (name:find("zeppelin") or name:find("skycutter")) and SHIP_SPEED or BOAT_SPEED end
local function learned(tbl, name, k)
    local t = StewardDB and StewardDB[tbl] and StewardDB[tbl][name]
    return t and t[k]
end
-- seconds from leaving stop k to reaching the next stop
local function legSecs(sh, k) return learned("shipLegs", sh[1], k) or sh[4][k] / shipSpeed(sh[1]) end
-- seconds the boat stays at stop k
local function stopSecs(sh, k) return learned("shipStops", sh[1], k) or (sh[3][k][5] + 10) end
local function cycleSecs(sh)
    local c = StewardDB and StewardDB.shipCycle and StewardDB.shipCycle[sh[1]]
    if c then return c end
    c = 0
    for k = 1, #sh[3] do c = c + legSecs(sh, k) + stopSecs(sh, k) end
    return c
end
-- seconds from leaving stop j to leaving stop k, going round
local function depOffset(sh, j, k)
    local n, t, i = #sh[3], 0, j
    for _ = 1, n do
        if i == k then break end
        t = t + legSecs(sh, i)
        i = i % n + 1
        t = t + stopSecs(sh, i)
    end
    return t
end
-- seconds until the boat next leaves stop k when you're there at server time T; nil when no departure was seen lately
local function nextLeaves(sh, k, T)
    local deps = StewardDB and StewardDB.shipDeps and StewardDB.shipDeps[sh[1]]
    local a = deps and deps[1]
    if not (a and a.at and T - a.at < DEP_FRESH and T - a.at > -600) then return nil end
    local C = cycleSecs(sh)
    if C <= 0 then return nil end
    return ((a.at + depOffset(sh, a.k, k)) - T) % C
end
S.ShipNextLeaves, S.ShipCycle = nextLeaves, cycleSecs
local walkMats = {}
local function walkMat(inst)
    local net = S.TravelNet
    local W = net and net.walk and net.walk[inst]
    if not (W and S.Path3D and S.Path3D.Bytes) then return nil end
    local M = walkMats[inst]
    if not M then
        local b = S.Path3D.Bytes(W.c)
        local idx = {}
        for i, id in ipairs(W.ids) do idx[id] = i end
        M = { b = b, idx = idx, n = #W.ids }
        walkMats[inst] = M
    end
    return M
end
-- the walk between two travel points (cost, about a yard each on open ground); false = cannot walk there; nil = unknown
local function netWalk(inst, a, b)
    local M = walkMat(inst)
    local i, j = M and M.idx[a], M and M.idx[b]
    if not (i and j) then return nil end
    local k = ((i - 1) * M.n + (j - 1)) * 2 + 1
    local v = M.b[k] + M.b[k + 1] * 256
    if v == 65535 then return false end
    return v / 2
end
-- the flight master the game's tables have at a flight path's spot
local function netFlightMaster(p)
    local net = S.TravelNet
    if not (net and p.world) then return nil end
    local pn, pw = NW(p)
    local best, bd
    for id, f in pairs(net.fm) do
        if f[1] == p.instance then
            local d = (f[2] - pn) ^ 2 + (f[3] - pw) ^ 2
            if d < 80 * 80 and (not bd or d < bd) then best, bd = id, d end
        end
    end
    return best
end
-- the walk from a spot to every travel point, on the 3D world: kept for a while, worked out again when you have moved.
-- Worked out in the background, a few milliseconds a frame: until it is ready the plan uses the straight line, and
-- when it is ready the plan is made again (S.TravelSyncSweeps: at once, for tests and tools).
local sweeps, queue, running = {}, {}, false
-- the walk from each lift landing to every travel point (and doorway): the same all session, so kept all session;
-- keyed by the landing's key and the mode ("lift 1 3 1 roads")
local liftWalks = {}
-- the walk from where your Hearthstone lands you (0.89.7): the same while you stay bound there, so kept all session;
-- keyed by the spot and the mode
local innWalks = {}
-- the walk from the tram stations, Dalaran's portal and where your teleports land (0.90.5): the same all session too
local spotWalks = {}
local SWEEP_MS = 4
local onSweepsDone          -- set below: make the plan again
local function sweepCached(p, roads)
    local now = GetTime()
    for i = #sweeps, 1, -1 do
        local s = sweeps[i]
        if now - s.t > 120 then
            table.remove(sweeps, i)
        elseif s.inst == p.instance and s.roads == roads and (s.x - p.world.x) ^ 2 + (s.y - p.world.y) ^ 2 < 250 * 250 then
            return s
        end
    end
end
local function keep(p, roads, pts, doors)
    table.insert(sweeps, 1, { inst = p.instance, x = p.world.x, y = p.world.y, roads = roads, t = GetTime(), pts = pts, doors = doors })
    sweeps[9] = nil
end
local function runQueue()
    if running then return end
    running = true
    local clock = debugprofilestop
    local units, t0 = 0, 0
    local function tick(n)
        units = units + (n or 1)
        if clock then
            if units % 64 < (n or 1) and clock() - t0 > SWEEP_MS then coroutine.yield() end
        elseif units >= 3000 then units = 0 coroutine.yield() end
    end
    local co = coroutine.create(function()
        while #queue > 0 do
            local q = table.remove(queue, 1)
            if q.lift then
                if q.store[q.lift] == nil then
                    local pts, doors = S.Path3D.WalkFrom(q.p.instance, q.n, q.w, q.roads, nil, tick, q.floor, q.indoors)
                    q.store[q.lift] = pts and { pts = pts, doors = doors } or false
                end
            elseif not sweepCached(q.p, q.roads) then
                local pn, pw = NW(q.p)
                local pts, doors = S.Path3D.WalkFrom(q.p.instance, pn, pw, q.roads, nil, tick)
                keep(q.p, q.roads, pts or false, doors)
            end
        end
    end)
    local function step()
        t0, units = clock and clock() or 0, 0
        local ok, err = coroutine.resume(co)
        if not ok then StewardCharDB.travelError = tostring(err) end
        if ok and coroutine.status(co) ~= "dead" then C_Timer.After(0, step) return end
        running = false
        if onSweepsDone then onSweepsDone() end
    end
    C_Timer.After(0, step)
end
local function sweepFrom(p, roads)
    local P3 = S.Path3D
    if not (P3 and P3.WalkFrom and p.world) then return nil end
    local s = sweepCached(p, roads)
    if s then
        if not s.pts then return nil end
        return s.pts, s.doors
    end
    if S.TravelSyncSweeps then
        local pn, pw = NW(p)
        local pts, doors = P3.WalkFrom(p.instance, pn, pw, roads)
        keep(p, roads, pts or false, doors)
        return pts, doors
    end
    for _, q in ipairs(queue) do
        if q.p.instance == p.instance and q.roads == roads and (q.p.world.x - p.world.x) ^ 2 + (q.p.world.y - p.world.y) ^ 2 < 250 * 250 then return nil, nil, true end
    end
    local n = 0
    for _, q in ipairs(queue) do if not q.lift then n = n + 1 end end
    if n < 8 then queue[#queue + 1] = { p = { world = p.world, instance = p.instance }, roads = roads } end
    runQueue()
    return nil, nil, true    -- being measured: the third value says "not yet" (no 3D data at all says nothing)
end
-- the walk from a lift's landing (its own floor) to every travel point: nil while it is being measured, false when
-- the landing isn't on the 3D world
local function fixedSweep(store, id, inst, n, w, roads, floor, indoors)
    local v = store[id]
    if v ~= nil then return v end
    local P3 = S.Path3D
    if S.TravelSyncSweeps then
        local pts, doors = P3.WalkFrom(inst, n, w, roads, nil, nil, floor, indoors)
        store[id] = pts and { pts = pts, doors = doors } or false
        return store[id]
    end
    for _, q in ipairs(queue) do if q.lift == id then return nil end end
    queue[#queue + 1] = { lift = id, store = store, p = { instance = inst }, n = n, w = w, floor = floor, indoors = indoors, roads = roads }
    runQueue()
    return nil
end
local function liftSweep(inst, key, A, roads)
    return fixedSweep(liftWalks, key .. (roads and " roads" or " fastest"), inst, A.n, A.w, roads, A.floor, nil)
end
-- where the Hearthstone lands you: inside the inn, so where floors lie over each other, the covered one
local function innSweep(h, roads)
    if not (S.Path3D and S.Path3D.WalkFrom and h.world) then return false end
    local n, w = NW(h)
    local id = string.format("%d %.0f %.0f %s", h.instance, n, w, roads and "roads" or "fastest")
    return fixedSweep(innWalks, id, h.instance, n, w, roads, nil, true)
end
-- the tram stations, the portal's two ends, a teleport's landing: inside, so the covered floor where floors lie over
-- each other (the Mage Quarter's tower, the stations under Stormwind and Ironforge, the Undercity's city floor)
local function spotSweep(p, roads)
    if not (S.Path3D and S.Path3D.WalkFrom and p.world) then return false end
    local n, w = NW(p)
    local id = string.format("%d %.0f %.0f %s", p.instance, n, w, roads and "roads" or "fastest")
    return fixedSweep(spotWalks, id, p.instance, n, w, roads, nil, true)
end
S.LiftWalksForTests, S.InnWalksForTests, S.SpotWalksForTests = liftWalks, innWalks, spotWalks
local function spotKey(p)
    local n, w = NW(p)
    return string.format("spot %d %.0f %.0f", p.instance, n, w)
end
-- the tram stations, the portal's ends and every teleport's landing as travel points of the 3D world (0.90.5), so that
-- every measured walk (from you, from where you're going, from a flight master) reaches them as it reaches the lifts.
-- Set again only when one moves (a landing learned the first time you go through): then the walks measured before
-- are dropped, since they don't know the new point
local spotsSig
local function setSpots()
    local P3 = S.Path3D
    if not (P3 and P3.SetSpots) then return end
    local tl = StewardDB and StewardDB.teleportLanding
    local sig = {}
    for _, t in ipairs(TELEPORTS) do
        local l = tl and tl[t.spell]
        sig[#sig + 1] = l and string.format("%s %.0f %.0f", tostring(l.inst), l.n or 0, l.w or 0) or "-"
    end
    for _, t in ipairs(TRANSPORTS) do
        if t.learn then
            local l = landing(t)
            sig[#sig + 1] = string.format("%.0f %.0f", l.wa or 0, l.wb or 0)
        end
    end
    sig = table.concat(sig, ";")
    if sig == spotsSig then return end
    local lists = {}
    local function put(p)
        if not (p and p.world) then return end
        local n, w = NW(p)
        lists[p.instance] = lists[p.instance] or {}
        lists[p.instance][spotKey(p)] = { n = n, w = w, indoors = true }
    end
    for _, t in ipairs(TRANSPORTS) do
        if t.kind == "tram" or t.kind == "portal" then
            put(fromGoto(t.a, t.aName))
            put(fromGoto(t.learn and landing(t) or t.b, t.bName))
        end
    end
    for _, t in ipairs(TELEPORTS) do
        local l = tl and tl[t.spell]
        put(point(netVec(l and l.n or t.n, l and l.w or t.w), l and l.inst or t.inst, t.name))
    end
    local changed = false
    for inst, list in pairs(lists) do
        if P3.SetSpots(inst, list) then changed = true end
    end
    if changed then
        for k in pairs(liftWalks) do liftWalks[k] = nil end
        for k in pairs(innWalks) do innWalks[k] = nil end
        for k in pairs(spotWalks) do spotWalks[k] = nil end
        for i = #sweeps, 1, -1 do sweeps[i] = nil end
    end
    spotsSig = sig
end

-- a name for a dock: the town of the flight master nearest it
local function dockName(inst, n, w)
    local net = S.TravelNet
    local best, bd
    for _, f in pairs(net.fm) do
        if f[1] == inst then
            local d = (f[2] - n) ^ 2 + (f[3] - w) ^ 2
            if not bd or d < bd then best, bd = f[6], d end
        end
    end
    if inst == 2991 then return "Zephras Isle" end
    return best and (best:gsub(",.*$", "")) or "the dock"
end
local function shipKind(name)
    if name:find("zeppelin") then return "zeppelin" end
    if name:find("skycutter") then return "skycutter" end
    return "boat"
end

---------------------------------------------------------------- planner (Dijkstra)
-- Fastest way from start to target. Returns legs { kind, text, target } (empty when
-- just running is best) and the total time in seconds.
-- waitForWalks: when the walk from you or to the target is still being measured on the 3D world, plan nothing yet
-- (returns nil, nil, "measuring") instead of guessing straight lines (Nick 2026-11-22: "it tried to have me run through
-- the map and it guessed a route, even though the portal was there": Rut'theran straight up the tree to Narla)
function S:Route(start, target, useHearth, waitForWalks)
    setSpots()

    local speed = runSpeed()
    local faction = UnitFactionGroup("player")
    local nodes = { start, target }
    local edges = {}
    local function add(p) nodes[#nodes + 1] = p return p end
    local function edge(a, b, cost, kind, text)
        edges[a] = edges[a] or {}
        local e = { to = b, cost = cost, kind = kind, text = text }
        table.insert(edges[a], e)
        return e
    end
    local T0 = epoch()
    -- a boat's cost from the moment you'd be at its dock (seconds after now): the wait, then the ride
    local function costOf(e, at)
        if not e.ship then return e.cost end
        local w = nextLeaves(e.ship, e.stop, T0 + at)
        e.waits = e.waits or {}
        e.waits[at] = w
        return (w or e.loop / 2) + e.ride
    end

    local fps = flightNodes()               -- (also where your inn is: the Hearthstone's landing, below)
    local net = S.TravelNet
    local useFly, useBoats = S:Get("travelFly") ~= false, S:Get("travelBoats") ~= false
    for _, n in ipairs(fps) do
        n.pid = netFlightMaster(n)
        if useFly then add(n) end
    end
    -- a dock's name: the town the hand-made list calls it (Dalaran, Valanaar, Rut'theran...), else the nearest flight master's
    local named = {}
    for _, t in ipairs(TRANSPORTS) do
        local a, b = fromGoto(t.a, t.aName), fromGoto(t.b, t.bName)
        if a then named[#named + 1] = a end
        if b then named[#named + 1] = b end
    end
    local function nameOf(p, inst, n, w)
        local best, bd
        for _, q in ipairs(named) do
            local d = dist(p, q)
            if d and d < 400 and (not bd or d < bd) then best, bd = q.name, d end
        end
        return best or dockName(inst, n, w)
    end
    if net and useBoats then
        for _, sh in ipairs(net.ships) do
            local name, fac, stops, legs = sh[1], sh[2], sh[3], sh[4]
            if not fac or fac == faction then
                local kind = shipKind(name)
                local P = {}
                local loop = cycleSecs(sh)
                for k, st in ipairs(stops) do
                    local p = add(point(netVec(st[3], st[4]), st[2], ""))
                    p.name = nameOf(p, st[2], st[3], st[4])
                    p.pid = st[1]
                    P[k] = p
                end
                -- every stop to every later stop, staying on board through the ones between. The wait to board: until
                -- it next leaves, when a departure was seen lately (worked out for the moment you get to the dock);
                -- else half the loop
                for i = 1, #stops do
                    local secs = 0
                    for d = 1, #stops - 1 do
                        local k = (i + d - 2) % #stops + 1
                        local j = k % #stops + 1
                        secs = secs + legSecs(sh, k)
                        local e = edge(P[i], P[j], loop / 2 + secs, kind, "Take the " .. kind .. " to " .. P[j].name)
                        e.ship, e.stop, e.ride, e.loop = sh, i, secs, loop
                        secs = secs + stopSecs(sh, j)
                    end
                end
            end
        end
    end
    -- portals both ways (Darnassus - Rut'theran Village): where you step in on each side
    if net and net.portals then
        local byPid = {}
        for _, po in ipairs(net.portals) do
            local p = add(point(netVec(po[3], po[4]), po[2], po[6]))
            p.pid = po[1]
            byPid[po[1]] = p
        end
        for _, po in ipairs(net.portals) do
            local a, b = byPid[po[1]], byPid[po[5]]
            if a and b then edge(a, b, 5, "portal", "Take the portal to " .. b.name) end
        end
    end
    for _, t in ipairs(TRANSPORTS) do
        local isShip = t.kind == "boat" or t.kind == "zeppelin" or t.kind == "skycutter"
        if (not net or t.kind == "tram" or t.kind == "portal") and (not t.faction or t.faction == faction)
            and (useBoats or not isShip) then
            local a, b = fromGoto(t.a, t.aName), fromGoto(t.learn and landing(t) or t.b, t.bName)
            if a and b then
                add(a) add(b)
                a.fixed, b.fixed = true, true
                local secs = t.mins * 60
                edge(a, b, secs, t.kind, "Take the " .. t.kind .. " to " .. t.bName)
                if not t.oneway then edge(b, a, secs, t.kind, "Take the " .. t.kind .. " to " .. t.aName) end
            end
        end
    end
    local wait = useHearth and S:Get("travelHearth") ~= false and hearthWait() or nil
    local inn                                    -- where the Hearthstone would land you, when it's a choice
    local debug = { when = date("%H:%M"), flightPaths = #fps, bind = GetBindLocation and GetBindLocation(),
        hearthReady = wait == 0, hearthWait = wait and math.floor(wait) }
    if useHearth then StewardCharDB.travelDebug = debug end
    -- the hearthstone: now, or after waiting out its cooldown if that's still quicker (up to 10 min)
    if wait and wait <= 600 then
        local h = bindPoint(fps)
        debug.bindFound = h ~= nil
        if h then
            inn = h
            add(h)
            local text = "Hearth to " .. h.name
            if wait > 5 then text = text .. string.format(" (ready in %d min)", math.ceil(wait / 60)) end
            edge(start, h, 30 + wait, "hearth", text)
        end
    end
    -- your teleports (a mage's runes, a druid's Moonglade): cast where you stand
    for _, t in ipairs(S:Get("travelTeleport") ~= false and self:TeleportsReady() or {}) do
        local l = StewardDB and StewardDB.teleportLanding and StewardDB.teleportLanding[t.spell]
        local p = add(point(netVec(l and l.n or t.n, l and l.w or t.w), l and l.inst or t.inst, t.name))
        p.spell, p.fixed = t.spell, true
        edge(start, p, TELEPORT_SECS, "teleport", "Teleport to " .. t.name)
    end
    -- running between any two points on the same continent: on the 3D world where it is mapped (the walk measured from
    -- you and from where you are going, and between every two travel points), else the straight line and a fifth more
    local roads = S:Get("pathRoute") == "roads"
    local fromStart, startDoors, startPending = sweepFrom(start, roads)
    local toTarget, targetDoors, targetPending = sweepFrom(target, roads)
    -- the lifts (0.89.6; Nick 11-22 20:21 "do 2"): each landing a point the walks reach, the ride between them. A walk
    -- by a lift stays one "run" leg below: the line to it finds the lift itself and says "Take the lift down"
    local liftPending = false
    local P3 = S.Path3D
    if P3 and P3.LIFTS and P3.LiftKey and start.world and target.world then
        local insts = { start.instance }
        if target.instance ~= start.instance then insts[2] = target.instance end
        for _, inst in ipairs(insts) do
            for i, L in ipairs(P3.LIFTS[inst] or {}) do
                local land = {}
                for side = 1, 2 do
                    local A = L[side]
                    local key = P3.LiftKey(inst, i, side)
                    local w = liftSweep(inst, key, A, roads)
                    if w == nil then liftPending = true end
                    if w then
                        local p = add(point(netVec(A.n, A.w), inst, L.name))
                        p.pid, p.liftWalk = key, w
                        land[side] = p
                    end
                end
                if land[1] and land[2] then
                    edge(land[1], land[2], L.secs, "lift", "Take " .. L.name)
                    edge(land[2], land[1], L.secs, "lift", "Take " .. L.name)
                end
            end
        end
    end
    -- the walk from the inn: measured too (before 0.89.7 a straight line and a fifth more, over cliffs and all)
    local innWalk, innPending
    if inn then
        innWalk = innSweep(inn, roads)
        innPending = innWalk == nil
        if innWalk then inn.walk = innWalk end
    end
    -- the walks from the tram stations, the portal's ends and your teleports' landings (0.90.5): before, a straight
    -- line and a fifth more (a teleport onto Thunder Bluff "50 yd" from a spot at its foot). Only those on the
    -- continents of this trip: the others can't be walked to from here
    local spotPending, spots = false, 0
    for _, p in ipairs(nodes) do
        if p.fixed and not p.pid and (p.instance == start.instance or p.instance == target.instance) then
            local w = spotSweep(p, roads)
            if w == nil then spotPending = true elseif w then p.walk, p.pid, spots = w, spotKey(p), spots + 1 end
        end
    end
    debug.spotWalks = spots
    if waitForWalks and (startPending or targetPending or liftPending or innPending or spotPending) then
        debug.measuring = true
        return nil, nil, "measuring"
    end
    debug.walk3d = fromStart ~= nil and toTarget ~= nil
    -- between two spots measured from: through the doorway where their walks meet
    local function viaDoors(da, db, p, q)
        local best
        for K, c in pairs(db) do
            local a = da[K]
            if a and (not best or a + c < best) then best = a + c end
        end
        if best then return best end
        local d = runDist(p, q)
        if d and d < 400 then return d * 1.2 end     -- both on one small spot of ground between doorways
        return nil
    end
    local function walkCost(p, q)
        if p.instance ~= q.instance then return nil end
        if p == start and q == target and startDoors and targetDoors then return viaDoors(startDoors, targetDoors, p, q) end
        if p == start and q.pid and fromStart then return fromStart[q.pid] end
        if q == target and p.pid and toTarget then return toTarget[p.pid] end
        -- a spot with its own measured walk (the inn; a tram station, a portal's end, a teleport's landing: these are
        -- travel points too, so the walks from you and from the target reach them, above)
        if p.walk or q.walk then
            local W, other = p.walk, q
            if not W then W, other = q.walk, p end
            if other == target and targetDoors then return viaDoors(W.doors, targetDoors, p, q) end
            if other == start and startDoors then return viaDoors(startDoors, W.doors, p, q) end
            if other.pid then return W.pts[other.pid] end
            if other.walk then return viaDoors(W.doors, other.walk.doors, p, q) end
        end
        -- a lift's landing and any other point: the walk measured from the landing, or none (no straight guesses
        -- up or down a cliff)
        if p.liftWalk or q.liftWalk then
            local w, other = p.liftWalk, q
            if not w then w, other = q.liftWalk, p end
            return other.pid and w.pts[other.pid] or nil
        end
        if p.pid and q.pid then
            local c = netWalk(p.instance, p.pid, q.pid)
            if c == false then return nil end
            if c then return c end
        end
        local d = runDist(p, q)
        return d and d * 1.2
    end
    for i = 1, #nodes do
        for j = 1, #nodes do
            if i ~= j and nodes[j] ~= start then
                local c = walkCost(nodes[i], nodes[j])
                if c then edge(nodes[i], nodes[j], c / speed, "run", nil) end
            end
        end
    end
    -- flying between known flight paths on the same continent
    for i = 1, useFly and #fps or 0 do
        for j = 1, #fps do
            if i ~= j then
                local d = dist(fps[i], fps[j])
                local y = net and fps[i].pid and fps[j].pid and net.fly[fps[i].pid] and net.fly[fps[i].pid][fps[j].pid]
                if y then
                    edge(fps[i], fps[j], y / flySpeed() + FLY_EXTRA, "fly", "Fly to " .. fps[j].name)
                elseif d then
                    edge(fps[i], fps[j], d * 1.25 / flySpeed() + FLY_EXTRA, "fly", "Fly to " .. fps[j].name)
                end
            end
        end
    end

    -- Dijkstra
    local best, prev, done = { [start] = 0 }, {}, {}
    while true do
        local u, ud
        for n, c in pairs(best) do
            if not done[n] and (not ud or c < ud) then u, ud = n, c end
        end
        if not u or u == target then break end
        done[u] = true
        for _, e in ipairs(edges[u] or {}) do
            local c = ud + costOf(e, ud)
            if not best[e.to] or c < best[e.to] then best[e.to], prev[e.to] = c, { from = u, edge = e } end
        end
    end
    if not prev[target] then return nil, nil end

    local path = {}
    local n = target
    while prev[n] do
        table.insert(path, 1, { from = prev[n].from, to = n, edge = prev[n].edge })
        n = prev[n].from
    end
    local walking = true                -- on foot all the way (perhaps by a lift): no legs, the line shows the way
    for _, step in ipairs(path) do
        if step.edge.kind ~= "run" and step.edge.kind ~= "lift" then walking = false end
    end
    if walking then return {}, best[target] end

    -- turn edges into legs: "go to the flight master", "fly to X", "take the boat"...
    local legs = {}
    local walkFrom              -- where a walk of several pieces (by a lift, or point to point) began
    for i, step in ipairs(path) do
        local e = step.edge
        local from = walkFrom or step.from
        walkFrom = nil
        if e.kind == "run" or e.kind == "lift" then
            local k = path[i + 1] and path[i + 1].edge.kind
            if k == "run" or k == "lift" then walkFrom = from end
        end
        if e.kind == "lift" then
            -- part of the walk: the leg before it runs on to the next stop, and the line takes the lift
        elseif e.kind == "run" and (dist(from, step.to) or 0) < 40 then
            -- already standing there (from where this walk began: the last piece after a lift can be short)
        elseif e.kind == "run" then
            local nextEdge = path[i + 1] and path[i + 1].edge
            local text
            if not nextEdge then
                text = (target.person and ("Head to " .. target.name)) or "Head to the quest area"
            elseif nextEdge.kind == "fly" then
                text = "Go to the " .. step.to.name .. " flight master"
            elseif nextEdge.kind == "hearth" or nextEdge.kind == "teleport" or nextEdge.kind == "run" or nextEdge.kind == "lift" then
                text = nil          -- a run on to the next stop: the next line says where
            else
                text = "Go to the " .. nextEdge.kind .. " dock for " .. (nextEdge.text:match("to (.+)$") or "")
                if nextEdge.kind == "tram" then text = "Go to the Deeprun Tram" end
                if nextEdge.kind == "portal" then text = "Go to the portal to " .. (nextEdge.text:match("to (.+)$") or "") end
            end
            if text then legs[#legs + 1] = { kind = "run", text = text, target = step.to } end
        else
            local text = e.text
            local w = e.ship and e.waits and e.waits[best[step.from]]
            if w then
                text = text .. (w < 45 and " (it's leaving now)" or string.format(" (leaves in about %d min)", math.floor(w / 60 + 0.5)))
            end
            legs[#legs + 1] = { kind = e.kind, text = text, target = step.to, spell = step.to.spell, waitSecs = w }
        end
    end
    -- merge consecutive flights into one line ("Fly to X") using the last stop
    local merged = {}
    for _, l in ipairs(legs) do
        local last = merged[#merged]
        if last and last.kind == "fly" and l.kind == "fly" then
            last.text, last.target = l.text, l.target
        else
            merged[#merged + 1] = l
        end
    end
    merged.total = best[target]
    debug.route = {}
    for _, l in ipairs(merged) do debug.route[#debug.route + 1] = l.text end
    return merged, best[target]
end

function S:PlayerPoint()
    local px, py, pinst = self:PlayerWorld()
    if not px then return nil end
    -- which island you're on: from Valanaar the only way off is the skycutter (2026-11-15: no travel steps at all
    -- from Valanaar to Westfall, because "you" counted as the mainland and couldn't run to the skycutter's dock)
    return { world = Vec(px, py), instance = pinst, name = "you", island = islandOfMap(C_Map.GetBestMapForUnit("player")) }
end

-- the travel plan to a guide spot, or nil when it's close enough to just follow the arrow
function S:PlanTravel(targetGoto, person)
    local start = self:PlayerPoint()
    local target = targetGoto and fromGoto(targetGoto, person or "the quest")
    if not (start and target) then return nil end
    target.person = person ~= nil
    local direct = dist(start, target)
    if direct and direct < 600 then return nil end
    -- the walks not measured yet: nil, "measuring" (no straight-line guess; 0.87.1, as friend trips since 0.86.3)
    local legs, _, why = self:Route(start, target, not self:HearthReserved(target), true)
    if why then return nil, why end
    if not legs or #legs == 0 then return nil end
    return legs
end
S.FromGoto, S.TravelDist = fromGoto, dist

-- the travel plan to a spot in the world: the group member you travel to (Nick 2026-11-21: "it's not telling me to
-- take the tram to get to my friend, or a flight path when I hit travel to on him"). The same planner as the guide's
-- (flight paths you know, the tram, boats, zeppelins, portals, your hearthstone, running), so the friend's line goes to
-- the tram or the flight master first when that is quicker. mapID: the map they're on (which island). nil = just run.
function S:PlanTravelToWorld(world, instance, name, mapID)
    local start = self:PlayerPoint()
    if not (start and world and instance) then return nil end
    local target = point(world, instance, name)
    target.person = true
    if mapID then target.island = islandOfMap(mapID) end
    local direct = dist(start, target)
    if direct and direct < 600 and island(start) == island(target) then return nil end
    local legs, _, why = self:Route(start, target, not self:HearthReserved(target), true)
    if why then return nil, why end
    if not legs or #legs == 0 then return nil end
    return legs
end

-- Is the guide about to ask for your hearthstone (its next "Hearth to ..." step, to the inn
-- you're bound at)? Then a trip now doesn't spend it, unless that trip ends at the inn anyway.
local function hearthStepInn(step)
    if not (step and S:GateOK(step.gate)) then return nil end
    for _, el in ipairs(step.elements) do
        if el.cmd == "hs" and S:GateOK(el.gate) then return el.inn or S.InnFromText(el.text) or "?" end
    end
end
function S:HearthReserved(target)
    local G = self.G
    if not (G.guide and G.current) then return false end
    local inn
    local steps = G.guide.steps
    for i = G.current.index + 1, math.min(#steps, G.current.index + 40) do
        inn = hearthStepInn(steps[i])
        if inn then break end
    end
    if not inn and self.NextGuide then
        local nxt = self:NextGuide(G.guide)
        for i = 1, math.min(5, nxt and #nxt.steps or 0) do
            inn = hearthStepInn(nxt.steps[i])
            if inn then break end
        end
    end
    if not inn then return false end
    local bound = GetBindLocation and GetBindLocation()
    if inn ~= "?" and bound and inn ~= bound then return false end -- that step won't use this hearth anyway
    local h = bindPoint(flightNodes())
    local d = h and target and dist(h, target)
    if d and d < 800 then return false end -- this trip goes to your inn: hearthing is exactly right
    return true
end

---------------------------------------------------------------- keeping the route current
local lastPlan, lastKey, keptKey = 0, nil, nil
function S:RefreshTravel(force)
    local stepGoto = G.stepGoto
    if S.InInstance() then G.travel, G.travelPending = nil, nil return end
    if not (stepGoto and (self:Get("guideTravel") or self:Get("guideTraining"))) then G.travel, G.travelPending = nil, nil return end
    local key = tostring(stepGoto) .. (C_Map.GetBestMapForUnit("player") or 0)
    if not force and key == lastKey and GetTime() - lastPlan < 20 then return end
    lastKey, lastPlan = key, GetTime()
    local ok, legs, why = true, nil, nil
    if self:Get("guideTravel") then ok, legs, why = pcall(self.PlanTravel, self, stepGoto.go, stepGoto.friendName) end
    if ok and why == "measuring" then
        -- the walks from here or to there are still being measured: keep the trip you had for this same step from
        -- this same zone, else say it's being worked out; planned again the moment they're ready (onSweepsDone), or
        -- in 2 s at the latest (Nick 2026-11-22: "use, do it", after the friend trip's guess up the tree)
        G.travelPending = true
        if key ~= keptKey then G.travel = nil end
        lastPlan = GetTime() - 18
    else
        G.travelPending = nil
        G.travel = ok and legs or nil
        keptKey = key
    end
    if not ok then StewardCharDB.travelError = tostring(legs) end
    if self.TrainingDetour and not stepGoto.friend and not stepGoto.pin then -- going to a group member or your pin: no training detour
        local ok2, detour = pcall(self.TrainingDetour, self, stepGoto.go)
        if ok2 and detour then G.travel = detour end
        if not ok2 then StewardCharDB.trainingError = tostring(detour) end
    end
end

local function replan()
    lastKey = nil
    -- re-check the guide too (it updates the waypoint, travel plan and tracker)
    if S.G.guide and S.UpdateGuide then
        S:UpdateGuide()
    else
        if S.UpdateWaypoint then S:UpdateWaypoint() end
        if S.RefreshGuideUI then S:RefreshGuideUI() end
    end
end
onSweepsDone = replan      -- the walks measured in the background are ready: plan again with them
S:On("ZONE_CHANGED_NEW_AREA", function() C_Timer.After(1, replan) end)
S:On("PLAYER_CONTROL_GAINED", function() C_Timer.After(1, replan) end)
S:On("TAXIMAP_CLOSED", function() C_Timer.After(1, replan) end)
S:On("UNIT_SPELLCAST_SUCCEEDED", function(unit, _, id)
    if S.Secret(unit, id) then return end
    if unit == "player" and id == 8690 then C_Timer.After(2, replan) end
end)
S.ReplanTravel = replan

-- note where a one-way portal lands you (stand by it, go through, look where you are)
local function portalDeparture()
    local px, py, pinst = S:PlayerWorld()
    if not px then return nil end
    for _, t in ipairs(TRANSPORTS) do
        if t.learn then
            local a = fromGoto(t.a, t.aName)
            if a and a.instance == pinst then
                local dx, dy = a.world.x - px, a.world.y - py
                if dx * dx + dy * dy < 25 * 25 then return t end
            end
        end
    end
end
C_Timer.NewTicker(1, function()
    local ok, t = pcall(portalDeparture)
    if ok and t then portalNear, portalAt = t, GetTime() end
end)
local function noteLanding()
    if not (portalNear and GetTime() - portalAt < 15) then return end
    local t = portalNear
    portalNear = nil
    C_Timer.After(2, function()
        local x, y, inst = S:PlayerWorld()
        local b = fromGoto(t.b, t.bName)
        if not (x and b and inst == b.instance) then return end
        local dx, dy = b.world.x - x, b.world.y - y
        if dx * dx + dy * dy > 400 * 400 then return end -- not where that portal goes
        StewardDB.portalLanding = StewardDB.portalLanding or {}
        StewardDB.portalLanding[t.learn] = { wa = y, wb = x, instance = inst }
    end)
end
S:On("ZONE_CHANGED_NEW_AREA", noteLanding)
S:On("PLAYER_ENTERING_WORLD", noteLanding)

---------------------------------------------------------------- boat timetables: learned from your rides (0.87.0)
-- A ride that starts at a boat's stop and ends at its next stop (a crossing to the other continent comes as two pieces
-- with the loading screen between) is a departure and a leg; staying on board through a stop gives how long it lasts;
-- two departures from the same stop give the loop's length.
do
    local NEAR = 80 * 80        -- a ride starting this close to a stop left from it (Auberdine's docks are 100+ yd apart)
    local ARRIVE = 120 * 120
    local pending               -- { at, t, cands = { { sh, k } }, ended }
    local lastArrive            -- { sh, k, at }
    local function stopsNear(x, y, inst, r2)
        local out, net = {}, S.TravelNet
        if not (net and x) then return out end
        for _, sh in ipairs(net.ships) do
            for k, st in ipairs(sh[3]) do
                if st[2] == inst then
                    local v = netVec(st[3], st[4])
                    if (v.x - x) ^ 2 + (v.y - y) ^ 2 < r2 then out[#out + 1] = { sh = sh, k = k } end
                end
            end
        end
        return out
    end
    local function put(tbl, name, k, v, lo, hi)
        if not (v and v >= lo and v <= hi) then return end
        StewardDB[tbl] = StewardDB[tbl] or {}
        local t = StewardDB[tbl][name] or {}
        StewardDB[tbl][name] = t
        t[k] = t[k] and math.floor((t[k] + v) / 2 * 10 + 0.5) / 10 or math.floor(v * 10 + 0.5) / 10
    end
    local function noteDeparture(sh, k, at)
        StewardDB.shipDeps = StewardDB.shipDeps or {}
        local deps = StewardDB.shipDeps[sh[1]] or {}
        StewardDB.shipDeps[sh[1]] = deps
        for _, d in ipairs(deps) do if math.abs(d.at - at) < 30 and d.k == k then return end end
        -- the loop's length: the oldest fresh departure from the same stop, a whole number of loops before
        local C = cycleSecs(sh)
        for i = #deps, 1, -1 do
            local d = deps[i]
            if d.k == k and at - d.at < DEP_FRESH and at - d.at > C * 0.5 then
                local n = math.floor((at - d.at) / C + 0.5)
                local c = n >= 1 and (at - d.at) / n
                if c and math.abs(c - C) < C * 0.15 then
                    StewardDB.shipCycle = StewardDB.shipCycle or {}
                    StewardDB.shipCycle[sh[1]] = math.floor(c * 10 + 0.5) / 10
                end
                break
            end
        end
        table.insert(deps, 1, { k = k, at = math.floor(at + 0.5) })
        deps[9] = nil
    end
    -- one ride piece: x0/y0/i0 where it started, x1/y1/i1 where it ended (nil at a loading screen), at = server time it
    -- started, secs; called in time order
    function S:LearnBoatRide(x0, y0, i0, x1, y1, i1, at, secs)
        if not (StewardDB and S.TravelNet and at and secs) then return end
        local from = stopsNear(x0, y0, i0, NEAR)
        if #from > 0 then
            -- stayed on board through a stop: how long it lasted
            if lastArrive and at - lastArrive.at < 300 then
                for _, c in ipairs(from) do
                    if c.sh == lastArrive.sh and c.k == lastArrive.k then put("shipStops", c.sh[1], c.k, at - lastArrive.at, 20, 300) end
                end
            end
            pending = { at = at, cands = from }
        elseif not (pending and pending.ended and at - pending.ended < 60) then
            pending = nil                                   -- not a boat, and not the rest of one after a loading screen
        end
        lastArrive = nil
        if not pending then return end
        local endAt = at + secs
        pending.ended = endAt
        if not x1 then return end                           -- the loading screen: the rest comes as the next piece
        for _, c in ipairs(pending.cands) do
            local sh, n = c.sh, #c.sh[3]
            local nk = c.k % n + 1
            local st = sh[3][nk]
            if st[2] == i1 then
                local v = netVec(st[3], st[4])
                if (v.x - x1) ^ 2 + (v.y - y1) ^ 2 < ARRIVE then
                    noteDeparture(sh, c.k, pending.at)
                    local est = sh[4][c.k] / shipSpeed(sh[1])
                    put("shipLegs", sh[1], c.k, endAt - pending.at, est * 0.5, est * 2 + 30)
                    lastArrive = { sh = sh, k = nk, at = endAt }
                    break
                end
            end
        end
        pending = nil
    end
    -- a flight from one flight master straight to another: the game's yards for it / the seconds on the taxi is the
    -- speed (0.87.2); the middle of the last 10 is used
    function S:LearnFlight(x0, y0, i0, x1, y1, i1, secs)
        local net = S.TravelNet
        if not (StewardDB and net and net.fm and net.fly and x0 and x1 and i0 == i1 and secs and secs >= 20) then return end
        local function fmNear(x, y)
            for id, f in pairs(net.fm) do
                if f[1] == i0 then
                    local v = netVec(f[2], f[3])
                    if (v.x - x) ^ 2 + (v.y - y) ^ 2 < 80 * 80 then return id end
                end
            end
        end
        local a, b = fmNear(x0, y0), fmNear(x1, y1)
        local yards = a and b and net.fly[a] and net.fly[a][b]
        if not yards then return end
        local v = yards / secs
        if v < 20 or v > 45 then return end
        local list = StewardDB.flySpeeds or {}
        StewardDB.flySpeeds = list
        table.insert(list, 1, math.floor(v * 100 + 0.5) / 100)
        list[11] = nil
        local sorted = {}
        for i, x in ipairs(list) do sorted[i] = x end
        table.sort(sorted)
        StewardDB.flySpeed = sorted[math.floor((#sorted + 1) / 2)]
    end
    S:On("PLAYER_ENTERING_WORLD", function()
        if not (StewardDB and StewardDB.rides) or StewardDB.flightRidesRead then return end
        StewardDB.flightRidesRead = true
        for i = #StewardDB.rides, 1, -1 do
            local r = StewardDB.rides[i]
            if r.kind == "flight" and not r.cut then pcall(S.LearnFlight, S, r.x0, r.y0, r.i0, r.x1, r.y1, r.i1, r.secs) end
        end
    end)
    -- the rides already in your saved data, once (0.87.0): their start times from "when" (this year)
    S:On("PLAYER_ENTERING_WORLD", function()
        if not (StewardDB and StewardDB.rides) or StewardDB.boatRidesRead then return end
        StewardDB.boatRidesRead = true
        local year = tonumber(date and date("%Y") or "") or 2026
        local list = {}
        for _, r in ipairs(StewardDB.rides) do
            if r.kind == "carried" and r.x0 and r.secs then
                local at = r.at
                if not at and r.when and time then
                    local mo, d, h, mi, se = r.when:match("^(%d+)-(%d+) (%d+):(%d+):(%d+)$")
                    if mo then at = time({ year = year, month = tonumber(mo), day = tonumber(d), hour = tonumber(h), min = tonumber(mi), sec = tonumber(se) }) end
                end
                if at then list[#list + 1] = { r = r, at = at } end
            end
        end
        table.sort(list, function(a, b) return a.at < b.at end)
        pending, lastArrive = nil, nil
        for _, e in ipairs(list) do
            local r = e.r
            pcall(S.LearnBoatRide, S, r.x0, r.y0, r.i0, r.x1, r.y1, r.i1, e.at, r.secs)
        end
        pending, lastArrive = nil, nil
    end)
end

---------------------------------------------------------------- ride log
-- How long rides really take (Nick 2026-11-16: "is there a way to record it?"), to learn the speeds of flights,
-- boats, zeppelins and the tram. Each ride: when, how long, where from and to, the way travelled. The last 30 in
-- StewardDB.rides. A flight is the time on the taxi. A ship or the tram is found by being carried: you move more
-- than 3 yards in half a second without moving yourself; it ends at the last moment you were carried, once that has
-- stopped for 3 seconds. Only rides of 15 seconds or more and 100 yards or more are kept (a blink or a knock-back is
-- not a ride).
do
    local ride, dest, lastX, lastY, lastI, lastT, lastZone
    local floor, sqrt = math.floor, math.sqrt
    local function mapNow() return C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player") or nil end
    local function zoneNow() return GetZoneText and GetZoneText() or nil end
    local function selfMoving()
        if IsPlayerMoving then return IsPlayerMoving() and true or false end
        return (GetUnitSpeed and GetUnitSpeed("player") or 0) > 0
    end
    local function r1(v) return v and floor(v * 10 + 0.5) / 10 or nil end
    local function startRide(kind, t, x, y, inst)
        ride = { kind = kind, t0 = t, x0 = r1(x), y0 = r1(y), i0 = inst, m0 = mapNow(), zone0 = zoneNow(), dest = dest,
                 path = 0, jumps = 0, when = date and date("%m-%d %H:%M:%S") or nil, lastCarried = t,
                 at = math.floor(epoch() - (GetTime() - t) + 0.5) }
    end
    local function endRide(t, x, y, inst)
        local r = ride
        ride, dest = nil, nil
        r.secs = r1(t - r.t0)
        r.x1, r.y1, r.i1, r.m1, r.zone1 = r1(x), r1(y), inst, mapNow(), zoneNow()
        if r.x0 and x and r.i0 == inst then r.straight = floor(sqrt((x - r.x0) ^ 2 + (y - r.y0) ^ 2)) end
        r.path, r.t0, r.lastCarried = floor(r.path), nil, nil
        if r.secs < 15 or (r.path < 100 and r.jumps == 0) then return end
        if not StewardDB then return end
        if r.kind == "carried" then pcall(S.LearnBoatRide, S, r.x0, r.y0, r.i0, r.x1, r.y1, r.i1, r.at, r.secs) end
        if r.kind == "flight" and not r.cut then pcall(S.LearnFlight, S, r.x0, r.y0, r.i0, r.x1, r.y1, r.i1, r.secs) end
        StewardDB.rides = StewardDB.rides or {}
        table.insert(StewardDB.rides, 1, r)
        StewardDB.rides[31] = nil
    end
    if hooksecurefunc and TakeTaxiNode then
        hooksecurefunc("TakeTaxiNode", function(i) dest = TaxiNodeName and TaxiNodeName(i) or nil end)
    end
    local function tick()
        local t = GetTime()
        local x, y, inst = S:PlayerWorld()
        local taxi = UnitOnTaxi and UnitOnTaxi("player")
        local d
        if x and lastX and inst == lastI then d = sqrt((x - lastX) ^ 2 + (y - lastY) ^ 2) end
        -- carried: moved without moving yourself, or faster than you can run (walking on a moving deck)
        local carried = d and d < 200 and ((d > 1.5 and not selfMoving()) or d > 5)
        if ride then
            if d and d < 200 then ride.path = ride.path + d
            elseif inst ~= lastI then ride.jumps = ride.jumps + 1 end
            if ride.kind == "flight" then
                if not taxi then endRide(t, x, y, inst) end
            elseif taxi then
                endRide(ride.lastCarried, x, y, inst)
            else
                -- ends 3 s after you were last carried, whether you stand or walk off (0.69.2 waited for you to
                -- stand still, so walking off kept the ride open until the Reload lost it)
                if carried then ride.lastCarried = t end
                if t - ride.lastCarried >= 3 then endRide(ride.lastCarried, x, y, inst) end
            end
        end
        if not ride then
            if taxi then
                startRide("flight", t, x, y, inst)
            elseif carried and d > 3 then
                startRide("carried", lastT, lastX, lastY, lastI)
                ride.path, ride.lastCarried = d, t
            end
        end
        lastX, lastY, lastI, lastT = x, y, inst, t
    end
    -- the Deeprun Tram is a map of its own, where the game may not give your position: time spent there, and how much
    -- of it you stood still (the ride plus the wait), as a ride of kind "tram zone"
    local tram
    local function tramTick()
        local inTram = zoneNow() == "Deeprun Tram"
        if inTram and not tram then
            tram = { kind = "tram zone", t0 = GetTime(), still = 0, when = date and date("%m-%d %H:%M:%S") or nil, from = lastZone }
        elseif tram and not inTram then
            tram.secs, tram.still, tram.to = r1(GetTime() - tram.t0), r1(tram.still), zoneNow()
            tram.t0 = nil
            if StewardDB and tram.secs >= 15 then
                StewardDB.rides = StewardDB.rides or {}
                table.insert(StewardDB.rides, 1, tram)
                StewardDB.rides[31] = nil
            end
            tram = nil
        elseif tram and not selfMoving() then
            tram.still = tram.still + 0.5
        end
        if not inTram then lastZone = zoneNow() end
    end
    -- for the next look at the saved data: each change of zone, map or whether the game gives your position, and the
    -- last error of the log itself (0.69.1 logged nothing for Nick's first tram ride)
    local seen
    local function diagTick()
        if not StewardDB then return end
        local x, _, inst = S:PlayerWorld()
        local key = tostring(zoneNow()) .. "|" .. tostring(GetRealZoneText and GetRealZoneText()) .. "|" .. tostring(mapNow())
            .. "|" .. tostring(inst) .. "|" .. (x and "pos" or "nopos") .. "|" .. ((IsInInstance and IsInInstance()) and "inst" or "open")
        if key == seen then return end
        seen = key
        local d = StewardDB.rideDiag or {}
        StewardDB.rideDiag = d
        d.zones = d.zones or {}
        table.insert(d.zones, 1, (date and date("%H:%M:%S") or "") .. " " .. key)
        d.zones[21] = nil
    end
    local function guarded(f)
        local ok, err = pcall(f)
        if not ok and StewardDB then
            StewardDB.rideDiag = StewardDB.rideDiag or {}
            StewardDB.rideDiag.err = tostring(S.version) .. " " .. (date and date("%H:%M:%S") or "") .. ": " .. tostring(err)
        end
    end
    C_Timer.NewTicker(0.5, function() guarded(tick) guarded(tramTick) guarded(diagTick) end)
    -- a Reload or logout in the middle of a ride: keep what there is, marked cut
    S:On("PLAYER_LOGOUT", function()
        if ride then
            ride.cut = true
            endRide(ride.kind == "flight" and GetTime() or ride.lastCarried, lastX, lastY, lastI)
        end
        if tram and StewardDB then
            tram.secs, tram.still, tram.cut, tram.t0 = r1(GetTime() - tram.t0), r1(tram.still), true, nil
            StewardDB.rides = StewardDB.rides or {}
            table.insert(StewardDB.rides, 1, tram)
            StewardDB.rides[31] = nil
            tram = nil
        end
    end)
end

-- note where a teleport really lands you: the spell goes off, the loading screen, then where you stand
local teleportCast
S:On("UNIT_SPELLCAST_SUCCEEDED", function(unit, _, id)
    if unit ~= "player" or S.Secret(unit, id) then return end
    for _, t in ipairs(TELEPORTS) do
        if t.spell == id then teleportCast = { t = t, at = GetTime() } end
    end
end)
S:On("PLAYER_ENTERING_WORLD", function()
    local c = teleportCast
    if not c or GetTime() - c.at > 60 then return end
    C_Timer.After(1, function()
        local x, y, inst = S:PlayerWorld()
        if not x or inst ~= c.t.inst then return end
        local n, w = x, y
        if swapped() then n, w = y, x end
        local R = c.t.learnR or 300
        if (n - c.t.n) ^ 2 + (w - c.t.w) ^ 2 > R * R then return end           -- not where that teleport goes
        StewardDB.teleportLanding = StewardDB.teleportLanding or {}
        StewardDB.teleportLanding[c.t.spell] = { n = n, w = w, inst = inst, when = date("%Y-%m-%d") }
        teleportCast = nil
        if S.ReplanTravel then S.ReplanTravel() end
    end)
end)
