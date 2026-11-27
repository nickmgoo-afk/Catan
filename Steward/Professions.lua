local _, S = ...

-- Profession guide (1.1.0, Nick 2026-11-27: "build the wow forever cooking guide for all professions ... We could use
-- their guide for professions"; "Vendor items, automatically"; gathering: "find the nodes urself ... and map the
-- fastest route smartly").
--
-- Crafting (Alchemy, Blacksmithing, Cooking, Enchanting, Engineering, First Aid, Leatherworking, Tailoring): Wowhead's
-- "Tried & Tested in Forever" steps (ProfessionData.lua). For each profession you have, a tracker block says what to
-- make next and how many, what you still need, and where to learn the recipe or the next rank. A click plans the trip
-- to the nearest vendor or trainer for it; a button beside the block makes the item. At a merchant Steward buys the
-- recipe, the rank book and the vendor materials for your current step.
-- Gathering (Mining, Herbalism): the zone with the most nodes that still raise your skill, and a loop through them
-- (GatherData.lua); Skinning and Fishing: what to skin, where to fish.

local G = S.G
local P = S.ProfData or {}
local GD = S.GatherData or {}
local CRAFT = { [185] = true, [129] = true, [171] = true, [164] = true, [333] = true, [202] = true, [165] = true, [197] = true }

local function GetInfo(item) return ((C_Item and C_Item.GetItemInfo) or GetItemInfo)(item) end
local function itemName(id, fallback)
    local ok, name = pcall(GetInfo, id)
    if ok and name then return name end
    if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, id) end
    return fallback or ("item " .. id)
end
local function bagCount(id)
    local n = (C_Item and C_Item.GetItemCount and C_Item.GetItemCount(id)) or (GetItemCount and GetItemCount(id)) or 0
    return n or 0
end
local function myFaction()
    local f = UnitFactionGroup and UnitFactionGroup("player")
    return f == "Horde" and "H" or "A"
end
local function factionOK(f) return f == "B" or f == "?" or f == myFaction() end
local function money(c)
    c = math.floor(c or 0)
    local g, s, cp = math.floor(c / 10000), math.floor(c / 100) % 100, c % 100
    if g > 0 then return string.format("%dg %ds", g, s) end
    if s > 0 then return string.format("%ds %dc", s, cp) end
    return cp .. "c"
end

---------------------------------------------------------------- your professions
local BYNAME = {}
for line, name in pairs(P.NAMES or {}) do BYNAME[name:lower()] = line end

-- { { line, name, rank, max }, ... } for the professions in the data
function S:MyProfessions()
    local out, seen = {}, {}
    if GetProfessions and GetProfessionInfo then
        local list = { GetProfessions() }
        for i = 1, 6 do
            if list[i] then
                local ok, name, _, rank, maxRank, _, _, line = pcall(GetProfessionInfo, list[i])
                if ok and name then
                    line = (P.NAMES and P.NAMES[line]) and line or BYNAME[name:lower()]
                    if line and not seen[line] then
                        seen[line] = true
                        out[#out + 1] = { line = line, name = P.NAMES[line], rank = rank or 0, max = maxRank or 75 }
                    end
                end
            end
        end
    end
    if #out == 0 and GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            local ok, name, header, _, rank, _, _, maxRank = pcall(GetSkillLineInfo, i)
            local line = ok and name and not header and BYNAME[name:lower()]
            if line and not seen[line] then
                seen[line] = true
                out[#out + 1] = { line = line, name = P.NAMES[line], rank = rank or 0, max = maxRank or 75 }
            end
        end
    end
    table.sort(out, function(a, b) return (CRAFT[a.line] and 0 or 1) < (CRAFT[b.line] and 0 or 1) or
        ((CRAFT[a.line] and 0 or 1) == (CRAFT[b.line] and 0 or 1) and a.line < b.line) end)
    return out
end

---------------------------------------------------------------- recipes you know
-- read when your profession window opens (both the classic and the newer calls), and IsPlayerSpell
local function recipeDB()
    StewardCharDB.profRecipes = StewardCharDB.profRecipes or {}
    return StewardCharDB.profRecipes
end
local function openSkill()
    -- which profession window is open: its name, and a function name -> index, crafter
    if C_TradeSkillUI and C_TradeSkillUI.IsTradeSkillReady and C_TradeSkillUI.GetAllRecipeIDs then
        local okR, ready = pcall(C_TradeSkillUI.IsTradeSkillReady)
        if okR and ready then
            local info = C_TradeSkillUI.GetBaseProfessionInfo and C_TradeSkillUI.GetBaseProfessionInfo()
                or (C_TradeSkillUI.GetTradeSkillLine and { professionName = (C_TradeSkillUI.GetTradeSkillLine()) })
            local pname = info and (info.professionName or info.parentProfessionName)
            local list = {}
            for _, id in ipairs(C_TradeSkillUI.GetAllRecipeIDs() or {}) do
                local r = C_TradeSkillUI.GetRecipeInfo(id)
                if r and r.name and r.learned then list[r.name] = { recipeID = id, num = r.numAvailable } end
            end
            return pname, list, "new"
        end
    end
    if GetTradeSkillLine and GetNumTradeSkills then
        local ok, pname = pcall(GetTradeSkillLine)
        if ok and pname and pname ~= "UNKNOWN" and GetNumTradeSkills() > 0 then
            local list = {}
            for i = 1, GetNumTradeSkills() do
                local name, kind, num = GetTradeSkillInfo(i)
                if name and kind ~= "header" then list[name] = { index = i, num = num } end
            end
            return pname, list, "trade"
        end
    end
    if GetCraftDisplaySkillLine and GetNumCrafts then
        local ok, pname = pcall(GetCraftDisplaySkillLine)
        if ok and pname and GetNumCrafts() > 0 then
            local list = {}
            for i = 1, GetNumCrafts() do
                local name, _, kind, num = GetCraftInfo(i)
                if name and kind ~= "header" then list[name] = { index = i, num = num } end
            end
            return pname, list, "craft"
        end
    end
end
local function scanRecipes()
    local pname, list = openSkill()
    local line = pname and BYNAME[pname:lower()]
    if not line then return end
    local known = {}
    for name in pairs(list) do known[name] = true end
    recipeDB()[line] = known
end

local function spellName(id)
    if not id then return nil end
    if C_Spell and C_Spell.GetSpellName then local ok, n = pcall(C_Spell.GetSpellName, id) if ok and n then return n end end
    if GetSpellInfo then local ok, n = pcall(GetSpellInfo, id) if ok and n then return n end end
end
-- true, false, or nil (not known yet: the profession window hasn't been opened)
function S:KnowsRecipe(line, step)
    if step.learn == "known" then return true end
    if step.spell and IsPlayerSpell then
        local ok, yes = pcall(IsPlayerSpell, step.spell)
        if ok and yes then return true end
    end
    local list = recipeDB()[line]
    if not list then return nil end
    return list[step.name] == true or list[spellName(step.spell) or ""] == true
end

---------------------------------------------------------------- the current step
local function stepFor(line, rank)
    local steps = P.STEPS and P.STEPS[line]
    if not steps then return nil end
    for i, st in ipairs(steps) do
        if st.to > rank then return st, i end
    end
end
local function nextRank(line, max)
    for _, r in ipairs((P.RANKS and P.RANKS[line]) or {}) do
        if r.cap > max then return r end
    end
end
-- crafts still to make in this step, and the materials for them: { id, need, have, name }
local function stepNeeds(st, rank)
    if not st or (st.crafts or 0) == 0 then return 0, {} end
    local span = math.max(1, st.to - st.from)
    local left = rank <= st.from and st.crafts or math.ceil(st.crafts * (st.to - rank) / span)
    local mats = {}
    for _, m in ipairs(st.mats or {}) do
        local per = m[2] / st.crafts
        local need = math.ceil(per * left - 0.001)
        mats[#mats + 1] = { id = m[1], need = need, have = bagCount(m[1]), name = itemName(m[1], m[3]) }
    end
    return left, mats
end
S.ProfStepFor, S.ProfStepNeeds, S.ProfNextRank = stepFor, stepNeeds, nextRank

---------------------------------------------------------------- NPCs and trips
local function npcPoint(m, x, y, name)
    local go = { mapID = m, x = x, y = y }
    return S.FromGoto and S.FromGoto(go, name), go
end
-- nearest of a list of { m, x, y, name, faction }: the entry, its goto
local function nearest(list)
    local me = S.PlayerPoint and S:PlayerPoint()
    local best, bestD, bestGo
    for _, e in ipairs(list) do
        if factionOK(e.f) then
            local p, go = npcPoint(e.m, e.x, e.y, e.name)
            local d = 1e9
            if me and p and S.TravelDist then
                local ok, dd = pcall(S.TravelDist, me, p)
                if ok and dd then d = dd end
                if p.instance and me.instance and p.instance ~= me.instance then d = d + 1e6 end
            end
            if not best or d < bestD then best, bestD, bestGo = e, d, go end
        end
    end
    return best, bestGo
end
local function npcList(ids)
    local out = {}
    for _, id in ipairs(ids or {}) do
        local n = P.NPCS and P.NPCS[id]
        if n then out[#out + 1] = { id = id, f = n[1], m = n[2], x = n[3], y = n[4], name = n[5] } end
    end
    return out
end
local function trainerList(line, upto)
    local out = {}
    for _, t in ipairs((P.TRAINERS and P.TRAINERS[line]) or {}) do
        if t[2] >= (upto or 0) then out[#out + 1] = { id = t[1], f = t[3], m = t[4], x = t[5], y = t[6], name = t[7] } end
    end
    return out
end
S.ProfTrainers, S.ProfNpcList, S.ProfNearest = trainerList, npcList, nearest

-- the trip in hand: { go, label, npc, line } or a gathering loop { loop = { {m,x,y}, ... }, at = i, line }
local trip
local tripEl
local function setTrip(t)
    trip, tripEl = t, nil
    StewardCharDB.profTrip = t and not t.loop and { go = t.go, label = t.label, npc = t.npc, line = t.line } or nil
    if S.UpdateWaypoint then pcall(S.UpdateWaypoint, S) end
    if S.RefreshGuideUI then pcall(S.RefreshGuideUI, S) end
end
function S:ProfTripStop() setTrip(nil) end
function S:ProfTripLine() return trip and trip.line end

local GATHER_NEAR = 22      -- yards: at the node (it shows within ~40 yd on the minimap; you'll be gathering it)
local NPC_NEAR = 10
function S:ProfTarget()
    if not trip then return nil end
    if trip.loop then
        local spot = trip.loop[trip.at]
        if not spot then return nil end
        local go = { mapID = spot[1], x = spot[2], y = spot[3] }
        local d = self:DistanceTo(go)
        if d and d < GATHER_NEAR then
            trip.at = trip.at % #trip.loop + 1
            spot = trip.loop[trip.at]
            go = { mapID = spot[1], x = spot[2], y = spot[3] }
            tripEl = nil
        end
        if not tripEl then
            tripEl = { go = go, pin = true, prof = true, friendName = trip.label, sideLabel = trip.label .. " (" .. trip.at .. " of " .. #trip.loop .. ")",
                       pinMap = go.mapID, pinX = go.x, pinY = go.y }
        end
        return tripEl
    end
    local d = self:DistanceTo(trip.go)
    if d and d < NPC_NEAR then trip, tripEl = nil, nil StewardCharDB.profTrip = nil return nil end
    if not tripEl then
        tripEl = { go = trip.go, pin = true, prof = true, friendName = trip.label, sideLabel = "Go to " .. trip.label,
                   pinMap = trip.go.mapID, pinX = trip.go.x, pinY = trip.go.y }
    end
    return tripEl
end

---------------------------------------------------------------- gathering
local function gatherWeight(skill, rank)
    if rank < skill then return 0 end
    local over = rank - skill
    if over < 25 then return 3 elseif over < 50 then return 2 elseif over < 100 then return 0.5 end
    return 0
end
local function parse(str)
    local out = {}
    local a
    for n in str:gmatch("%d+") do
        if a then out[#out + 1] = { a / 10, tonumber(n) / 10 } a = nil else a = tonumber(n) end
    end
    return out
end
local mapName = function(m)
    local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(m)
    return info and info.name or ("map " .. m)
end
-- the best zone to gather in at this rank: { map, score, count, names = {..}, nodes = { {name, weight, pts} } }
local zoneCache = {}
function S:GatherPlan(line, rank)
    local key = line .. ":" .. rank .. ":" .. (UnitLevel and UnitLevel("player") or 0)
    if zoneCache[key] then return zoneCache[key] end
    local per = {}
    for _, node in ipairs(GD[line] or {}) do
        local w = gatherWeight(node.skill, rank)
        if w > 0 then
            for m, str in pairs(node.maps) do
                local z = per[m] or { map = m, score = 0, count = 0, nodes = {} }
                per[m] = z
                local n = select(2, str:gsub(",", ",")) / 2 + 0.5
                n = math.floor(n)
                z.score = z.score + w * n
                if w >= 2 then z.count = z.count + n end
                z.nodes[#z.nodes + 1] = { name = node.name, weight = w, str = str }
            end
        end
    end
    local me = self.PlayerPoint and self:PlayerPoint()
    local here = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local best, bestV
    -- not a zone well above you (its quests' low end more than 3 levels over yours); if none is left, any
    local lvl = UnitLevel and UnitLevel("player") or 60
    local zl = P.ZONELEVELS or {}
    local safe = {}
    for m, z in pairs(per) do
        if z.count >= 12 and not (zl[m] and zl[m][1] > lvl + 3) then safe[m] = z end
    end
    if not next(safe) then safe = per end
    for m, z in pairs(safe) do
        if z.count >= 12 then
            local v = z.score
            local p = self.FromGoto and self.FromGoto({ mapID = m, x = 50, y = 50 }, "zone")
            if me and p then
                if p.instance and me.instance and p.instance ~= me.instance then v = v / 4
                elseif self.TravelDist then
                    local ok, d = pcall(self.TravelDist, me, p)
                    if ok and d then v = v / (1 + d / 3000) end
                end
            end
            if m == here then v = v * 1.5 end
            if not best or v > bestV then best, bestV = z, v end
        end
    end
    if best then
        table.sort(best.nodes, function(a, b) return a.weight > b.weight end)
        best.names = {}
        for _, n in ipairs(best.nodes) do if n.weight >= 2 then best.names[#best.names + 1] = n.name end end
        if #best.names == 0 then for _, n in ipairs(best.nodes) do best.names[#best.names + 1] = n.name end end
    end
    zoneCache[key] = best or false
    return best
end
-- a loop through the zone's useful nodes: nearest-neighbour from you, then 2-opt
local function buildLoop(z)
    local pts = {}
    for _, n in ipairs(z.nodes) do
        if n.weight >= (z.count >= 12 and 2 or 0.5) then
            for _, p in ipairs(parse(n.str)) do pts[#pts + 1] = p end
        end
    end
    if #pts > 160 then
        -- the densest part of the zone: the 160 nearest the middle of the useful nodes
        local cx, cy = 0, 0
        for _, p in ipairs(pts) do cx, cy = cx + p[1], cy + p[2] end
        cx, cy = cx / #pts, cy / #pts
        table.sort(pts, function(a, b) return (a[1] - cx) ^ 2 + (a[2] - cy) ^ 2 < (b[1] - cx) ^ 2 + (b[2] - cy) ^ 2 end)
        for i = #pts, 161, -1 do pts[i] = nil end
    end
    local function d(a, b) local dx, dy = (a[1] - b[1]) * 1.5, a[2] - b[2] return math.sqrt(dx * dx + dy * dy) end
    -- start at the node nearest you (when you're in that zone)
    local start = 1
    local here = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local pos = here == z.map and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(here, "player")
    if pos and pos.x then
        local me, bd = { pos.x * 100, pos.y * 100 }, nil
        for i, p in ipairs(pts) do local dd = d(me, p) if not bd or dd < bd then start, bd = i, dd end end
    end
    local order, used = { pts[start] }, { [start] = true }
    for _ = 2, #pts do
        local last, bi, bd = order[#order], nil, nil
        for i, p in ipairs(pts) do
            if not used[i] then local dd = d(last, p) if not bd or dd < bd then bi, bd = i, dd end end
        end
        used[bi] = true
        order[#order + 1] = pts[bi]
    end
    -- 2-opt, a few passes
    local n = #order
    for _ = 1, 4 do
        local better = false
        for i = 1, n - 2 do
            for j = i + 2, n do
                local a, b, c, e = order[i], order[i + 1], order[j], order[j % n + 1]
                if d(a, c) + d(b, e) < d(a, b) + d(c, e) - 0.01 then
                    local lo, hi = i + 1, j
                    while lo < hi do order[lo], order[hi] = order[hi], order[lo] lo, hi = lo + 1, hi - 1 end
                    better = true
                end
            end
        end
        if not better then break end
    end
    local loop = {}
    for _, p in ipairs(order) do loop[#loop + 1] = { z.map, p[1], p[2] } end
    return loop
end
S.ProfBuildLoop = buildLoop

local FISH = {
    { upto = 75, maps = { 1429, 1426, 1438, 1411, 1412, 1420 } },
    { upto = 150, maps = { 1436, 1432, 1439, 1413, 1421, 1433 } },
    { upto = 225, maps = { 1440, 1437, 1424, 1431, 1442, 1441 } },
    { upto = 300, maps = { 1443, 1445, 1417, 1434, 1435, 1444, 1446, 1447 } },
}

---------------------------------------------------------------- the tracker
-- what a profession block says: { header, lines = { {key, text, done} }, click = function, craft = { spell, name, n } }
function S:ProfessionView(p)
    local line, rank, max = p.line, p.rank, p.max
    local v = { line = line, lines = {} }
    local function add(key, text, done) v.lines[#v.lines + 1] = { key, text, done } end
    local nr = nextRank(line, max)
    local lvl = UnitLevel("player") or 1
    local rankDue = nr and rank >= math.max(nr.skill, max - 25)
    if rankDue then
        local rn = ({ [150] = "Journeyman", [225] = "Expert", [300] = "Artisan" })[nr.cap] or "the next rank"
        if lvl < nr.level then
            add("rank", string.format("%s at level %d (to go past %d)", rn, nr.level, max))
        elseif nr.how == "book" then
            local have = bagCount(nr.item) > 0
            local who = nearest(npcList(nr.npcs))
            add("rank", have and ("Learn " .. rn .. ": use " .. itemName(nr.item) .. " in your bags")
                or (rn .. ": buy " .. itemName(nr.item) .. (who and (" from " .. who.name) or "")))
            if not have and who and not v.click then v.click = { npc = who, label = who.name } end
        elseif nr.how == "quest" then
            local who = nearest(npcList(nr.npcs))
            add("rank", rn .. ": the quest" .. (who and (" from " .. who.name) or ""))
            if who and not v.click then v.click = { npc = who, label = who.name } end
        else
            local who = nearest(trainerList(line, nr.cap))
            add("rank", "Train " .. rn .. (who and (" with " .. who.name) or " at a trainer"))
            if who and not v.click then v.click = { npc = who, label = who.name .. " (" .. P.NAMES[line] .. " trainer)" } end
        end
    end
    if CRAFT[line] then
        local st = stepFor(line, rank)
        if not st then v.header = P.NAMES[line] .. " " .. rank .. ": all done" return v end
        if st.crafts == 0 then
            v.header = string.format("%s %d/%d: %s", P.NAMES[line], rank, max, st.name)
            add("note", st.note or "")
            return v
        end
        local left, mats = stepNeeds(st, rank)
        v.header = string.format("%s %d/%d: %s", P.NAMES[line], rank, max, st.name)
        local stopAt = math.min(st.to, max)
        local known = self:KnowsRecipe(line, st)
        if known == false or (known == nil and st.learn ~= "trainer" and type(st.learn) == "table") then
            if type(st.learn) == "table" and st.learn.item then
                local have = bagCount(st.learn.item) > 0
                local who = nearest(npcList(st.learn.npcs))
                add("learn", have and ("Learn it: use " .. itemName(st.learn.item) .. " in your bags")
                    or ("Buy " .. itemName(st.learn.item) .. (who and (" from " .. who.name) or "")))
                if not have and who and not v.click then v.click = { npc = who, label = who.name } end
            elseif type(st.learn) == "table" and st.learn.special then
                local who = nearest(npcList(st.learn.special))
                add("learn", "Learn it from " .. (who and who.name or "the trainer in the note"))
                if who and not v.click then v.click = { npc = who, label = who.name } end
            elseif st.learn == "special" then
                add("learn", "Learn it: " .. (st.note or "a special trainer"))
            else
                local who = nearest(trainerList(line, st.to))
                add("learn", "Learn it at a trainer" .. (who and (": " .. who.name) or ""))
                if who and not v.click then v.click = { npc = who, label = who.name .. " (" .. P.NAMES[line] .. " trainer)" } end
            end
        elseif known == nil and st.learn == "trainer" then
            add("learn", "Learn it at your trainer if you haven't (Steward learns new recipes there for you)")
        end
        -- as far as your rank lets you now (the rest after training)
        local toCap = left
        if max < st.to then toCap = math.max(0, math.ceil(st.crafts * (max - math.max(rank, st.from)) / math.max(1, st.to - st.from))) end
        add("make", string.format("Make %d (to %d)", toCap, stopAt) .. (max < st.to and ", then train" or ""))
        local canMake = toCap
        for _, m in ipairs(mats) do
            add("m" .. m.id, string.format("%s: %d/%d", m.name, math.min(m.have, m.need), m.need), m.have >= m.need)
            local per = 0
            for _, mm in ipairs(st.mats) do if mm[1] == m.id then per = mm[2] / st.crafts end end
            if per > 0 then canMake = math.min(canMake, math.floor(m.have / per + 0.001)) end
        end
        if st.note then add("note", st.note) end
        if line == 185 then add("fire", "Needs a cooking fire (Basic Campfire)") end
        if known ~= false and canMake > 0 then v.craft = { line = line, name = st.name, spell = st.spell, n = canMake } end
        return v
    end
    if line == 186 or line == 182 then
        local z = self:GatherPlan(line, rank)
        v.header = string.format("%s %d/%d", P.NAMES[line], rank, max)
        if not z then add("none", "No zone with enough nodes for your skill") return v end
        local names = table.concat(z.names, ", ", 1, math.min(#z.names, 3))
        v.header = v.header .. ": " .. names
        local running = trip and trip.loop and trip.line == line
        add("zone", string.format("%s: %d nodes that raise your skill", mapName(z.map), z.count))
        add("go", running and "Following the loop (right-click to stop)" or "Click to start a loop through them")
        v.gather = z
        return v
    end
    if line == 393 then
        local top = rank < 100 and math.floor(rank / 10) + 10 or math.floor(rank / 5)
        v.header = string.format("Skinning %d/%d", rank, max)
        add("skin", string.format("Skin beasts up to level %d (higher ones need more skill)", top))
        return v
    end
    if line == 356 then
        v.header = string.format("Fishing %d/%d", rank, max)
        local tier = FISH[#FISH]
        for _, t in ipairs(FISH) do if rank < t.upto then tier = t break end end
        local names = {}
        for i = 1, math.min(3, #tier.maps) do names[#names + 1] = mapName(tier.maps[i]) end
        add("fish", "Fish in " .. table.concat(names, ", ") .. " or zones like them")
        return v
    end
end

-- the tracker's profession blocks (called from GuideTracker.lua's layout)
S.profCraftBlock, S.profCraft = nil, nil
function S:ProfessionBlocks(module, addLine)
    S.profCraftBlock, S.profCraft = nil, nil
    if not self:Get("profGuide") then return true end
    for _, p in ipairs(self:MyProfessions()) do
        local ok, v = pcall(self.ProfessionView, self, p)
        if not ok then self:LogError("professions", v) elseif v and v.header then
            local block = module:GetBlock("prof" .. p.line)
            block.stewardCurrent = false
            block.stewardProf = v
            block:SetHeader(v.header)
            for _, l in ipairs(v.lines) do
                if l[2] and l[2] ~= "" then addLine(block, l[1], l[2], l[3], true) end
            end
            if not module:LayoutBlock(block) then return false end
            if v.craft and not S.profCraftBlock then S.profCraftBlock, S.profCraft = block, v.craft end
        end
    end
    return true
end

function S:ProfessionClick(v, button)
    if not v then return end
    if button == "RightButton" then
        if trip and (not trip.line or trip.line == v.line) then setTrip(nil) end
        return
    end
    if v.gather then
        if trip and trip.loop and trip.line == v.line then return end
        local loop = buildLoop(v.gather)
        if #loop == 0 then return end
        setTrip({ loop = loop, at = 1, line = v.line, label = (v.gather.names[1] or "node") .. " loop" })
        self:Print(string.format("%s loop: %d spots in %s. Right-click the block to stop.", P.NAMES[v.line], #loop, mapName(v.gather.map)))
        return
    end
    if v.click and v.click.npc then
        local e = v.click.npc
        setTrip({ go = { mapID = e.m, x = e.x, y = e.y }, label = v.click.label or e.name, npc = e.id, line = v.line })
    end
end

function S:ProfessionTooltip(block, v)
    GameTooltip:SetOwner(block, "ANCHOR_LEFT")
    GameTooltip:SetText("Steward: " .. (P.NAMES[v.line] or "profession"))
    if v.gather then
        GameTooltip:AddLine("Left-click: a loop through the nodes (the arrow goes from one to the next). Right-click: stop.", 1, 1, 1, true)
    elseif v.click then
        GameTooltip:AddLine("Left-click: go to " .. (v.click.label or "it") .. ". Right-click: stop the trip.", 1, 1, 1, true)
    else
        GameTooltip:AddLine("Wowhead's WoW Forever leveling guide for this profession.", 1, 1, 1, true)
    end
    if v.craft then GameTooltip:AddLine("The button beside it opens your " .. P.NAMES[v.line] .. " window, then makes them.", 0.8, 0.8, 0.8, true) end
    GameTooltip:Show()
end

---------------------------------------------------------------- the make button
local craftBtn
local function craftNow(c)
    local pname, list, kind = openSkill()
    if not (pname and BYNAME[pname:lower()] == c.line) then return false end
    local r = list[c.name] or list[spellName(c.spell) or ""]
    if not r then return false end
    local n = math.max(1, math.min(c.n, r.num or c.n))
    if kind == "new" and C_TradeSkillUI.CraftRecipe then
        C_TradeSkillUI.CraftRecipe(r.recipeID, n)
    elseif kind == "trade" and DoTradeSkill then
        DoTradeSkill(r.index, n)
    elseif kind == "craft" and DoCraft then
        DoCraft(r.index)
    else
        return false
    end
    return true
end
local function makeCraftButton()
    local b = CreateFrame("Button", "StewardCraftButton", UIParent, "SecureActionButtonTemplate")
    b:SetSize(28, 28)
    b:RegisterForClicks("AnyUp", "AnyDown")
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    b.icon:SetTexture(136243)
    b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    b.count:SetPoint("BOTTOMRIGHT", -2, 2)
    b:SetAttribute("type", "spell")
    -- the window is open on this profession: make them (this click), and don't cast the profession (it would close it)
    b:SetScript("PreClick", function(self)
        if InCombatLockdown() or not self.craft then return end
        local ok, done = pcall(craftNow, self.craft)
        if ok and done then self:SetAttribute("type", nil) end
    end)
    b:SetScript("PostClick", function(self)
        if not InCombatLockdown() then self:SetAttribute("type", "spell") end
    end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        local c = self.craft
        GameTooltip:SetText(c and ("Make " .. c.n .. " " .. c.name) or "Make")
        GameTooltip:AddLine("First click opens your " .. (c and P.NAMES[c.line] or "profession") .. " window, the next makes them.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end
function S:UpdateCraftButton()
    if InCombatLockdown() then return end
    local block, c = S.profCraftBlock, S.profCraft
    local top = block and block.GetTop and block:GetTop()
    local left = block and block.GetLeft and block:GetLeft()
    if not (c and top and left and block:IsVisible()) then
        if craftBtn and craftBtn:IsShown() then craftBtn:Hide() end
        return
    end
    craftBtn = craftBtn or makeCraftButton()
    craftBtn.craft = c
    craftBtn:SetAttribute("type", "spell")
    craftBtn:SetAttribute("spell", P.NAMES[c.line])
    local tex = c.spell and ((C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(c.spell)) or (GetSpellTexture and GetSpellTexture(c.spell)))
    craftBtn.icon:SetTexture(tex or 136243)
    craftBtn.count:SetText(c.n)
    craftBtn:ClearAllPoints()
    craftBtn:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", left - 6 - ((S.HearthButtonBeside and S.HearthButtonBeside(top)) and 32 or 0), top)
    craftBtn:Show()
end
C_Timer.NewTicker(1, function()
    if not InCombatLockdown() then pcall(S.UpdateCraftButton, S) end
end)

---------------------------------------------------------------- learning a recipe or a book in your bags
local function findInBags(id)
    for bag = 0, 4 do
        for slot = 1, (C_Container.GetContainerNumSlots(bag) or 0) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID == id then return bag, slot end
        end
    end
end
local function learnables()
    local out = {}
    for _, p in ipairs(S:MyProfessions()) do
        if CRAFT[p.line] then
            local st = stepFor(p.line, p.rank)
            if st and type(st.learn) == "table" and st.learn.item and bagCount(st.learn.item) > 0 and S:KnowsRecipe(p.line, st) ~= true then
                out[#out + 1] = st.learn.item
            end
        end
        local nr = nextRank(p.line, p.max)
        if nr and nr.how == "book" and bagCount(nr.item) > 0 and p.rank >= nr.skill and (UnitLevel("player") or 1) >= nr.level then
            out[#out + 1] = nr.item
        end
    end
    return out
end
local function queueLearning()
    if InCombatLockdown() or not S:Get("profGuide") then return end
    local items = learnables()
    if #items == 0 then if S.CancelNextPress then S:CancelNextPress("learnRecipe") end return end
    if not S.OnNextPress then return end
    S:OnNextPress("learnRecipe", function()
        if InCombatLockdown() then return end
        for _, id in ipairs(learnables()) do
            local bag, slot = findInBags(id)
            if bag then
                local use = (C_Container and C_Container.UseContainerItem) or UseContainerItem
                local ok = pcall(use, bag, slot)
                if ok then S:Print("learning " .. itemName(id) .. ".") end
                return -- one at a time; the next press does the next
            end
        end
    end)
end

---------------------------------------------------------------- buying at a merchant
local function merchantIndex(id)
    if not (GetMerchantNumItems and GetMerchantItemID) then return nil end
    for i = 1, GetMerchantNumItems() or 0 do
        if GetMerchantItemID(i) == id then
            local name, price, stack, avail, usable, extended = S.MerchantItem(i)
            if name and not extended and avail ~= 0 then return { index = i, price = price or 0, stack = math.max(1, stack or 1), name = name } end
        end
    end
end
local function buyCount(it, want, budget)
    if want <= 0 then return 0, 0 end
    local lots = math.ceil(want / it.stack)
    if it.price > 0 then lots = math.min(lots, math.floor(budget / it.price)) end
    if lots <= 0 then return 0, 0 end
    if it.stack > 1 then
        for _ = 1, lots do BuyMerchantItem(it.index) end
    else
        local maxStack = math.max(1, GetMerchantItemMaxStack and GetMerchantItemMaxStack(it.index) or lots)
        local left = lots
        while left > 0 do
            local n = math.min(left, maxStack)
            BuyMerchantItem(it.index, n)
            left = left - n
        end
    end
    return lots * it.stack, lots * it.price
end
function S:ProfessionShopping()
    if not (self:Get("profGuide") and self:Get("profBuy")) or not BuyMerchantItem then return end
    local cash = GetMoney and GetMoney() or 0
    local budget = math.floor(cash * 0.6)     -- never more than 60% of your money in one visit
    local bought, spent = {}, 0
    local function take(id, want, label)
        if want <= 0 then return end
        local it = merchantIndex(id)
        if not it then return end
        local n, cost = buyCount(it, want, budget - spent)
        if n > 0 then
            spent = spent + cost
            bought[#bought + 1] = (label or it.name) .. (n > 1 and (" x" .. n) or "")
        end
    end
    for _, p in ipairs(self:MyProfessions()) do
        local nr = nextRank(p.line, p.max)
        if nr and nr.how == "book" and bagCount(nr.item) == 0 and p.rank >= nr.skill - 25 then take(nr.item, 1) end
        if CRAFT[p.line] then
            local st = stepFor(p.line, p.rank)
            if st then
                -- this step's recipe, and the next step's when you're nearly there
                local steps = { st }
                local nxt = P.STEPS[p.line][(select(2, stepFor(p.line, p.rank)) or 0) + 1]
                if nxt and p.rank >= nxt.from - 10 then steps[2] = nxt end
                for _, s2 in ipairs(steps) do
                    if type(s2.learn) == "table" and s2.learn.item and bagCount(s2.learn.item) == 0 and self:KnowsRecipe(p.line, s2) ~= true then
                        take(s2.learn.item, 1)
                    end
                end
                local _, mats = stepNeeds(st, p.rank)
                for _, m in ipairs(mats) do take(m.id, m.need - m.have) end
            end
        end
    end
    if #bought > 0 then
        self:Print("for your professions: bought " .. table.concat(bought, ", ") .. " (" .. money(spent) .. ").")
        local log = StewardCharDB.profBuyLog or {}
        StewardCharDB.profBuyLog = log
        table.insert(log, 1, date("%m-%d %H:%M") .. " " .. table.concat(bought, ", ") .. " (" .. money(spent) .. ")")
        log[21] = nil
        C_Timer.After(1, queueLearning)
    end
end

---------------------------------------------------------------- events
local refreshQueued
local function refresh()
    if refreshQueued then return end
    refreshQueued = true
    C_Timer.After(0.5, function()
        refreshQueued = nil
        if S.RefreshGuideUI then pcall(S.RefreshGuideUI, S) end
        queueLearning()
    end)
end
S:On("PLAYER_LOGIN", function()
    local t = StewardCharDB and StewardCharDB.profTrip
    if t and t.go then trip = { go = t.go, label = t.label, npc = t.npc, line = t.line } end
    refresh()
end)
S:On("SKILL_LINES_CHANGED", function() zoneCache = {} refresh() end)
S:On("CHAT_MSG_SKILL", refresh)
S:On("BAG_UPDATE_DELAYED", refresh)
S:On("LEARNED_SPELL_IN_TAB", refresh)
S:On("NEW_RECIPE_LEARNED", refresh)
S:On("TRADE_SKILL_SHOW", function() C_Timer.After(0.3, function() pcall(scanRecipes) refresh() end) end)
S:On("TRADE_SKILL_UPDATE", function() pcall(scanRecipes) end)
S:On("TRADE_SKILL_LIST_UPDATE", function() pcall(scanRecipes) end)
S:On("CRAFT_SHOW", function() C_Timer.After(0.3, function() pcall(scanRecipes) refresh() end) end)
S:On("CRAFT_UPDATE", function() pcall(scanRecipes) end)
S:On("MERCHANT_SHOW", function()
    -- after Steward's own selling and buying (Vendor.lua runs at once)
    C_Timer.After(0.8, function()
        local ok, err = pcall(S.ProfessionShopping, S)
        if not ok then S:LogError("profshop", err) end
    end)
    if trip and not trip.loop then setTrip(nil) end
end)
S:On("TRAINER_SHOW", function() if trip and not trip.loop then setTrip(nil) end end)
S:On("GOSSIP_SHOW", function() if trip and not trip.loop and trip.npc and UnitGUID then
    local guid = UnitGUID("npc")
    local id = guid and tonumber((select(6, strsplit("-", guid))))
    if id == trip.npc then setTrip(nil) end
end end)
S:On("QUEST_DETAIL", function() if trip and not trip.loop then setTrip(nil) end end)
-- gathered a node: on to the next
S:On("UNIT_SPELLCAST_SUCCEEDED", function(unit, _, spellID)
    if unit ~= "player" or not (trip and trip.loop) then return end
    local n = spellName(spellID) or ""
    if n == "Mining" or n == "Herb Gathering" or n == "Herbalism" then
        tripEl = nil
        local spot = trip.loop[trip.at]
        local d = spot and S:DistanceTo({ mapID = spot[1], x = spot[2], y = spot[3] })
        if d and d < 45 then trip.at = trip.at % #trip.loop + 1 end
        if S.UpdateWaypoint then pcall(S.UpdateWaypoint, S) end
    end
end)
-- following a loop: move on when you reach a spot
C_Timer.NewTicker(1, function()
    if not (trip and trip.loop) or (UnitOnTaxi and UnitOnTaxi("player")) then return end
    local before = trip.at
    S:ProfTarget()
    if trip.at ~= before and S.UpdateWaypoint then pcall(S.UpdateWaypoint, S) if S.RefreshGuideUI then pcall(S.RefreshGuideUI, S) end end
end)
