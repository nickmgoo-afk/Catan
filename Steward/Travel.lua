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
local FLY_SPEED = 32      -- yards a second on a flight path (to be learned from real flights)
local SHIP_SPEED = 20     -- yards a second on a boat, zeppelin or skycutter (to be learned from real rides)
-- the tables give (north, west); Steward's world spots are in the order the map API wants (Waypoint.lua)
local function swapped() return S:WorldOrder() == "unitswap" end
local function NW(p) if swapped() then return p.world.y, p.world.x end return p.world.x, p.world.y end
local function netVec(n, w) if swapped() then return Vec(w, n) end return Vec(n, w) end
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
            if not sweepCached(q.p, q.roads) then
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
    if #queue < 8 then queue[#queue + 1] = { p = { world = p.world, instance = p.instance }, roads = roads } end
    runQueue()
    return nil, nil, true    -- being measured: the third value says "not yet" (no 3D data at all says nothing)
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

    local speed = runSpeed()
    local faction = UnitFactionGroup("player")
    local nodes = { start, target }
    local edges = {}
    local function add(p) nodes[#nodes + 1] = p return p end
    local function edge(a, b, cost, kind, text)
        edges[a] = edges[a] or {}
        table.insert(edges[a], { to = b, cost = cost, kind = kind, text = text })
    end

    local fps = flightNodes()
    local net = S.TravelNet
    for _, n in ipairs(fps) do
        add(n)
        n.pid = netFlightMaster(n)
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
    if net then
        for _, sh in ipairs(net.ships) do
            local name, fac, stops, legs = sh[1], sh[2], sh[3], sh[4]
            if not fac or fac == faction then
                local kind = shipKind(name)
                local P = {}
                local loop = 0
                for k = 1, #legs do loop = loop + legs[k] / SHIP_SPEED end
                for k = 1, #stops do loop = loop + stops[k][5] end
                for k, st in ipairs(stops) do
                    local p = add(point(netVec(st[3], st[4]), st[2], ""))
                    p.name = nameOf(p, st[2], st[3], st[4])
                    p.pid = st[1]
                    P[k] = p
                end
                -- every stop to every later stop, staying on board through the ones between; the wait to board is half the loop
                for i = 1, #stops do
                    local secs = loop / 2
                    for d = 1, #stops - 1 do
                        local k = (i + d - 2) % #stops + 1
                        local j = k % #stops + 1
                        secs = secs + legs[k] / SHIP_SPEED
                        edge(P[i], P[j], secs, kind, "Take the " .. kind .. " to " .. P[j].name)
                        secs = secs + stops[j][5]
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
        if (not net or t.kind == "tram" or t.kind == "portal") and (not t.faction or t.faction == faction) then
            local a, b = fromGoto(t.a, t.aName), fromGoto(t.learn and landing(t) or t.b, t.bName)
            if a and b then
                add(a) add(b)
                local secs = t.mins * 60
                edge(a, b, secs, t.kind, "Take the " .. t.kind .. " to " .. t.bName)
                if not t.oneway then edge(b, a, secs, t.kind, "Take the " .. t.kind .. " to " .. t.aName) end
            end
        end
    end
    local wait = useHearth and hearthWait() or nil
    local debug = { when = date("%H:%M"), flightPaths = #fps, bind = GetBindLocation and GetBindLocation(),
        hearthReady = wait == 0, hearthWait = wait and math.floor(wait) }
    if useHearth then StewardCharDB.travelDebug = debug end
    -- the hearthstone: now, or after waiting out its cooldown if that's still quicker (up to 10 min)
    if wait and wait <= 600 then
        local h = bindPoint(fps)
        debug.bindFound = h ~= nil
        if h then
            add(h)
            local text = "Hearth to " .. h.name
            if wait > 5 then text = text .. string.format(" (ready in %d min)", math.ceil(wait / 60)) end
            edge(start, h, 30 + wait, "hearth", text)
        end
    end
    -- your teleports (a mage's runes, a druid's Moonglade): cast where you stand
    for _, t in ipairs(self:TeleportsReady()) do
        local l = StewardDB and StewardDB.teleportLanding and StewardDB.teleportLanding[t.spell]
        local p = add(point(netVec(l and l.n or t.n, l and l.w or t.w), l and l.inst or t.inst, t.name))
        p.spell = t.spell
        edge(start, p, TELEPORT_SECS, "teleport", "Teleport to " .. t.name)
    end
    -- running between any two points on the same continent: on the 3D world where it is mapped (the walk measured from
    -- you and from where you are going, and between every two travel points), else the straight line and a fifth more
    local roads = S:Get("pathRoute") == "roads"
    local fromStart, startDoors, startPending = sweepFrom(start, roads)
    local toTarget, targetDoors, targetPending = sweepFrom(target, roads)
    if waitForWalks and (startPending or targetPending) then
        debug.measuring = true
        return nil, nil, "measuring"
    end
    debug.walk3d = fromStart ~= nil and toTarget ~= nil
    local function walkCost(p, q)
        if p.instance ~= q.instance then return nil end
        if p == start and q == target and startDoors and targetDoors then
            local best
            for K, c in pairs(targetDoors) do
                local a = startDoors[K]
                if a and (not best or a + c < best) then best = a + c end
            end
            if best then return best end
            local d = runDist(p, q)
            if d and d < 400 then return d * 1.2 end     -- both on one small spot of ground between doorways
            return nil
        end
        if p == start and q.pid and fromStart then return fromStart[q.pid] end
        if q == target and p.pid and toTarget then return toTarget[p.pid] end
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
    for i = 1, #fps do
        for j = 1, #fps do
            if i ~= j then
                local d = dist(fps[i], fps[j])
                local y = net and fps[i].pid and fps[j].pid and net.fly[fps[i].pid] and net.fly[fps[i].pid][fps[j].pid]
                if y then
                    edge(fps[i], fps[j], y / FLY_SPEED + 20, "fly", "Fly to " .. fps[j].name)
                elseif d then
                    edge(fps[i], fps[j], d * 1.25 / 32 + 20, "fly", "Fly to " .. fps[j].name)
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
            local c = ud + e.cost
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
    if #path == 1 and path[1].edge.kind == "run" then return {}, best[target] end

    -- turn edges into legs: "go to the flight master", "fly to X", "take the boat"...
    local legs = {}
    for i, step in ipairs(path) do
        local e = step.edge
        if e.kind == "run" and (dist(step.from, step.to) or 0) < 40 then
            -- already standing there
        elseif e.kind == "run" then
            local nextEdge = path[i + 1] and path[i + 1].edge
            local text
            if not nextEdge then
                text = (target.person and ("Head to " .. target.name)) or "Head to the quest area"
            elseif nextEdge.kind == "fly" then
                text = "Go to the " .. step.to.name .. " flight master"
            elseif nextEdge.kind == "hearth" or nextEdge.kind == "teleport" or nextEdge.kind == "run" then
                text = nil          -- a run on to the next stop: the next line says where
            else
                text = "Go to the " .. nextEdge.kind .. " dock for " .. (nextEdge.text:match("to (.+)$") or "")
                if nextEdge.kind == "tram" then text = "Go to the Deeprun Tram" end
                if nextEdge.kind == "portal" then text = "Go to the portal to " .. (nextEdge.text:match("to (.+)$") or "") end
            end
            if text then legs[#legs + 1] = { kind = "run", text = text, target = step.to } end
        else
            legs[#legs + 1] = { kind = e.kind, text = e.text, target = step.to, spell = step.to.spell }
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
    local legs = self:Route(start, target, not self:HearthReserved(target))
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
local lastPlan, lastKey = 0, nil
function S:RefreshTravel(force)
    local stepGoto = G.stepGoto
    if S.InInstance() then G.travel = nil return end
    if not (stepGoto and (self:Get("guideTravel") or self:Get("guideTraining"))) then G.travel = nil return end
    local key = tostring(stepGoto) .. (C_Map.GetBestMapForUnit("player") or 0)
    if not force and key == lastKey and GetTime() - lastPlan < 20 then return end
    lastKey, lastPlan = key, GetTime()
    local ok, legs = true, nil
    if self:Get("guideTravel") then ok, legs = pcall(self.PlanTravel, self, stepGoto.go, stepGoto.friendName) end
    G.travel = ok and legs or nil
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
                 path = 0, jumps = 0, when = date and date("%m-%d %H:%M:%S") or nil, lastCarried = t }
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
