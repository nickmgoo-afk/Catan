local _, S = ...

-- talent tab order per class, and each class's default spec (Nick, 2026-11-12): used before talents unlock at 10,
-- and after that until you pick a spec or spend a talent point
S.SPECS = {
    WARRIOR = { "Arms", "Fury", "Protection", default = 2 },        -- Fury
    PALADIN = { "Holy", "Protection", "Retribution", default = 3 }, -- Retribution
    HUNTER = { "Beast Mastery", "Marksmanship", "Survival", default = 3 }, -- Survival
    ROGUE = { "Assassination", "Combat", "Subtlety", default = 2 }, -- Combat
    PRIEST = { "Discipline", "Holy", "Shadow", default = 3 },       -- Shadow
    SHAMAN = { "Elemental", "Enhancement", "Restoration", default = 2 }, -- Enhancement
    MAGE = { "Arcane", "Fire", "Frost", default = 2 },              -- Fire
    WARLOCK = { "Affliction", "Demonology", "Destruction", default = 2 }, -- Demonology
    DRUID = { "Balance", "Feral", "Restoration", default = 2 },     -- Feral Combat
}
S.TALENTS_AT = 10 -- the level the game opens talents, and with them your choice of spec

-- Stat weights. Classic-style values: crit/hit/dodge/parry/block per 1%,
-- dps = weapon damage per second, rdps = ranged slot (bow, gun, wand) dps.
local function W(base, over)
    local t = {}
    for k, v in pairs(base) do t[k] = v end
    for k, v in pairs(over or {}) do t[k] = v end
    return t
end

local P = {}
P.strMelee = { str = 1, agi = 0.6, sta = 0.4, int = 0.05, spi = 0.05, armor = 0.01, ap = 0.5, crit = 10, hit = 8,
    dps = 5, rdps = 0.3, def = 0.2, dodge = 3, parry = 3, block = 0.5, blockval = 0.1 }
-- leveling hybrids: armor keeps you alive between heals, spirit means less drinking
P.strHybrid = W(P.strMelee, { int = 0.3, mp5 = 0.6, sp = 0.2, armor = 0.04, spi = 0.2 })
P.enhance = W(P.strHybrid, { agi = 0.75 })
-- Retribution, in the order Nick gave (2026-11-12): weapon skill, weapon damage per second and (slow) speed, hit,
-- expertise, spell damage, intellect, strength and attack power, agility and crit, stamina. Everything he did
-- not list sits below stamina. wskill is per skill point for the weapon type in your hands; speed is per second
-- of a two-hander's swing time; "sp:Holy" tops Holy-only spell damage up to full value (it already counts 0.6 as sp).
P.retribution = { wskill = 14, dps = 6, speed = 5, hit = 12, expertise = 11, sp = 1.0, ["sp:Holy"] = 0.67, int = 0.95,
    str = 0.8, ap = 0.4, agi = 0.5, crit = 10, sta = 0.3, mp5 = 0.25, spi = 0.05, armor = 0.01, def = 0.05,
    dodge = 1, parry = 1, block = 0.2, blockval = 0.05 }
P.tank = { sta = 1, armor = 0.03, def = 1.2, str = 0.6, agi = 0.6, dodge = 10, parry = 9, block = 4, blockval = 0.3,
    ap = 0.2, hit = 4, crit = 2, dps = 2, rdps = 0.2, int = 0.05, spi = 0.05 }
P.paladinTank = W(P.tank, { int = 0.4, sp = 0.4, mp5 = 0.6 })
P.rogue = { agi = 1, str = 0.5, sta = 0.4, ap = 0.5, crit = 10, hit = 10, dps = 5, rdps = 0.3, armor = 0.01,
    spi = 0.05, dodge = 2 }
P.hunter = { agi = 1, int = 0.35, sta = 0.4, rap = 0.5, ap = 0.15, crit = 10, hit = 10, rdps = 6, dps = 0.6,
    str = 0.05, spi = 0.1, armor = 0.01, mp5 = 0.5 }
P.feral = { str = 1, agi = 0.9, sta = 0.6, armor = 0.02, ap = 0.5, crit = 10, hit = 8, def = 0.4, dodge = 4,
    dps = 0.3, int = 0.05, spi = 0.05 }
P.caster = { int = 1, spi = 0.5, sta = 0.5, sp = 1.0, spellcrit = 10, spellhit = 10, mp5 = 1.2, rdps = 2,
    dps = 0.05, armor = 0.02 }
P.shadow = W(P.caster, { spi = 0.8 })
P.warlock = W(P.caster, { sta = 0.8, spi = 0.4, armor = 0.01 })
P.balance = W(P.caster, { rdps = 0, armor = 0.01 })
P.elemental = W(P.caster, { rdps = 0, armor = 0.01 })
P.healer = { int = 1, spi = 0.8, sta = 0.4, heal = 1.0, sp = 0.1, mp5 = 1.5, spellcrit = 8, rdps = 1, dps = 0.05,
    armor = 0.02 }
P.healerNoWand = W(P.healer, { rdps = 0, armor = 0.01 })
-- Forever has one Hit stat and one Critical Strike stat for melee, ranged and spells alike, so on gear they read
-- as plain hit and crit: every caster and healer profile counts those as it counts spell hit and spell crit.
for _, prof in pairs(P) do
    if prof.spellhit and not prof.hit then prof.hit = prof.spellhit end
    if prof.spellcrit and not prof.crit then prof.crit = prof.spellcrit end
end
-- Wowhead's Forever stat priorities (read 2026-11-12; the guides call them provisional until level 60 gear is seen).
-- Arms: hit (to 8%), expertise (to 6.5%), crit, strength, agility, haste. Caps and haste are not modelled.
P.arms = W(P.strMelee, { hit = 14, expertise = 13, crit = 12, str = 1, ap = 0.5, agi = 0.6, sta = 0.3 })
-- Fury: hit (to 9%), crit, strength, agility, stamina. Wowhead does not list expertise for Fury.
P.fury = W(P.strMelee, { hit = 14, crit = 12, str = 1, ap = 0.5, agi = 0.6, sta = 0.3 })
-- Protection warrior (the guide's first list): stamina, defense, armor, agility, parry, dodge, expertise, block
-- chance, attack power and strength, hit, crit. The 440 defense cap and haste are not modelled.
P.protWarrior = W(P.tank, { sta = 1, def = 0.9, armor = 0.04, agi = 0.7, parry = 10, dodge = 9, expertise = 8,
    block = 6, blockval = 0.1, ap = 0.25, str = 0.5, hit = 5, crit = 4 })
-- Fire and Arcane: hit (to 17%), spell damage (+ own school), crit, spell penetration, haste, intellect, spirit,
-- stamina. Spell penetration and haste are not read from gear yet.
P.fire = W(P.caster, { hit = 14, spellhit = 14, sp = 1.0, ["sp:Fire"] = 0.67, crit = 9, spellcrit = 9, int = 0.8,
    spi = 0.5, sta = 0.4, mp5 = 0.3 })
P.arcane = W(P.fire, { ["sp:Fire"] = 0, ["sp:Arcane"] = 0.67 })
-- Protection paladin (the guide's first list): stamina, defense, armor, agility, block chance, spell power, parry,
-- dodge, strength, hit, expertise, crit; intellect last. Holy paladin: healing power, intellect, crit, spirit.
P.protPaladin = W(P.tank, { sta = 1, def = 0.9, armor = 0.04, agi = 0.7, block = 10, blockval = 0.1, sp = 0.5,
    parry = 9, dodge = 8, str = 0.4, ap = 0.2, hit = 6, expertise = 5, crit = 4, int = 0.05, mp5 = 0.3 })
P.holyPaladin = W(P.healerNoWand, { heal = 1, int = 0.8, crit = 7, spellcrit = 7, spi = 0.3, sta = 0.3, mp5 = 0.5 })
-- Rogue (Assassination, Combat and Subtlety pages, identical): hit (to 8%), expertise (to 6.5%), weapon
-- skill (to 308), agility, crit, haste, strength, attack power, stamina.
P.rogueWH = W(P.rogue, { hit = 14, expertise = 13, wskill = 2.5, agi = 1, crit = 9, str = 0.5, ap = 0.4, sta = 0.3 })
-- Beast Mastery and Marksmanship (identical pages): hit (to 9%), crit, agility, intellect, ranged attack power, spirit,
-- stamina. Survival (fights in melee): hit, crit, agility, strength, attack power, intellect, spirit, stamina.
P.hunterWH = W(P.hunter, { hit = 14, crit = 12, agi = 1, int = 0.6, rap = 0.5, ap = 0.15, spi = 0.3, sta = 0.25 })
P.survival = W(P.hunter, { hit = 14, crit = 12, agi = 1, str = 0.7, ap = 0.5, rap = 0.1, int = 0.3, spi = 0.2,
    sta = 0.15, dps = 6, rdps = 0.6 })
-- Shadow priest: hit (to 17%), crit, spell damage (Shadow), intellect, spirit, stamina. Discipline: healing power, intellect, spirit, crit, spell damage, stamina.
P.shadowWH = W(P.shadow, { hit = 14, spellhit = 14, crit = 12, spellcrit = 12, sp = 1.0, ["sp:Shadow"] = 0.67, int = 0.8,
    spi = 0.5, sta = 0.4, mp5 = 0.3 })
P.discipline = W(P.healer, { heal = 1, int = 0.8, spi = 0.7, crit = 6, spellcrit = 6, sp = 0.5, sta = 0.3, mp5 = 0.6 })
-- Shaman. Enhancement: hit (8%), expertise (6.5%), intellect, spell damage, strength, crit, agility, spirit, stamina.
-- Elemental: hit (17%), spell damage, crit, Nature/Fire damage, intellect, spirit, strength (leveling), stamina.
-- Restoration: healing, crit, intellect, spirit, mp5, then (while leveling) spell damage, hit, strength; stamina.
-- Spell penetration and haste, which the guides also list, are not read from gear yet.
P.enhanceWH = W(P.enhance, { hit = 14, expertise = 13, int = 1.0, sp = 0.9, str = 0.8, ap = 0.4, crit = 7, agi = 0.5,
    spi = 0.3, sta = 0.25, mp5 = 0.3 })
P.elementalWH = W(P.elemental, { hit = 14, spellhit = 14, sp = 1.0, crit = 9, spellcrit = 9, ["sp:Nature"] = 0.3,
    ["sp:Fire"] = 0.3, int = 0.6, spi = 0.4, str = 0.2, sta = 0.15, mp5 = 0.3 })
P.restoShaman = W(P.healerNoWand, { heal = 1, crit = 8, spellcrit = 8, int = 0.7, spi = 0.6, mp5 = 0.5, sp = 0.3,
    hit = 2, spellhit = 2, str = 0.1, sta = 0.08 })
-- Warlock: spell power (+ Shadow for Affliction, + Fire for Destruction), crit, hit (to 12% with Suppression),
-- intellect, spirit. Stamina is not on Wowhead's list; kept low.
P.affliction = W(P.warlock, { sp = 1.0, ["sp:Shadow"] = 0.67, crit = 9, spellcrit = 9, hit = 8, spellhit = 8, int = 0.6,
    spi = 0.4, sta = 0.3, mp5 = 0.3 })
P.destruction = W(P.affliction, { ["sp:Shadow"] = 0, ["sp:Fire"] = 0.67 })
-- Druid. Feral (DPS guide): crit, hit (8%), expertise (6.5%), haste, weapon DPS, agility = strength, attack power,
-- intellect, spirit, stamina. Balance: hit (17%), spell damage, spell penetration, crit, haste, intellect, spirit,
-- stamina.
P.feralWH = W(P.feral, { crit = 14, hit = 13, expertise = 12.5, dps = 1.1, agi = 1, str = 1, ap = 0.5, int = 0.2,
    spi = 0.15, sta = 0.1, def = 0.05, dodge = 1, armor = 0.005 })
P.balanceWH = W(P.balance, { hit = 14, spellhit = 14, sp = 1.0, crit = 9, spellcrit = 9, int = 0.6, spi = 0.4,
    sta = 0.3, mp5 = 0.3 })
-- Read 2026-11-12, second pass. Demonology: spell power (+ Fire or Shadow "matching your build"; Wowhead's Demonology
-- leveling build takes the Shadow drain/Corruption talents, so Shadow counts in full), hit, crit, intellect, spirit.
-- Holy priest: healing, intellect, mp5, spirit, crit, stamina. Restoration druid: healing, crit, (haste), spirit,
-- intellect, mp5, stamina.
P.demonology = W(P.affliction, { hit = 9, spellhit = 9, crit = 8, spellcrit = 8 })
P.holyPriest = W(P.healer, { heal = 1, int = 0.8, mp5 = 0.75, spi = 0.6, crit = 5, spellcrit = 5, sta = 0.3, sp = 0.1 })
P.restoDruid = W(P.healerNoWand, { heal = 1, crit = 8, spellcrit = 8, spi = 0.7, int = 0.6, mp5 = 0.5, sta = 0.2, sp = 0.1 })
-- Frost: hit (to 11-12%), crit, spell damage (Frost and Arcane), intellect, spirit, stamina.
P.frost = W(P.caster, { hit = 14, spellhit = 14, crit = 12, spellcrit = 12, sp = 1.0, ["sp:Frost"] = 0.67,
    ["sp:Arcane"] = 0.67, int = 0.8, spi = 0.5, sta = 0.4, mp5 = 0.3 })

S.PROFILES = P

S.SPEC_PROFILE = {
    WARRIOR = { Arms = P.arms, Fury = P.fury, Protection = P.protWarrior },
    PALADIN = { Holy = P.holyPaladin, Protection = P.protPaladin, Retribution = P.retribution },
    HUNTER = { ["Beast Mastery"] = P.hunterWH, Marksmanship = P.hunterWH, Survival = P.survival },
    ROGUE = { Assassination = P.rogueWH, Combat = P.rogueWH, Subtlety = P.rogueWH },
    PRIEST = { Discipline = P.discipline, Holy = P.holyPriest, Shadow = P.shadowWH },
    SHAMAN = { Elemental = P.elementalWH, Enhancement = P.enhanceWH, Restoration = P.restoShaman },
    MAGE = { Arcane = P.arcane, Fire = P.fire, Frost = P.frost },
    WARLOCK = { Affliction = P.affliction, Demonology = P.demonology, Destruction = P.destruction },
    DRUID = { Balance = P.balanceWH, Feral = P.feralWH, Restoration = P.restoDruid },
}

function S:PlayerClass()
    local _, class = UnitClass("player")
    return class
end

function S:ClassSpecs()
    return self.SPECS[self:PlayerClass()] or {}
end

-- points spent in a talent tab; tolerant of the different classic/modern return layouts
function S:TabPoints(tab)
    local total = 0
    if GetNumTalents and GetTalentInfo then
        local ok, num = pcall(GetNumTalents, tab)
        if ok and type(num) == "number" then
            for i = 1, num do
                local ok2, _, _, _, _, rank = pcall(GetTalentInfo, tab, i)
                if ok2 and type(rank) == "number" then total = total + rank end
            end
        end
    end
    if total == 0 and GetTalentTabInfo then
        local info = { pcall(GetTalentTabInfo, tab) }
        if info[1] then
            -- classic era: name, icon, pointsSpent ; later clients: id, name, desc, icon, pointsSpent
            local a, b = info[4], info[6]
            if type(b) == "number" then total = b elseif type(a) == "number" then total = a end
        end
    end
    return total
end

-- Does this client have real specializations (pick one, the others go "off-spec")?
-- WoW: Forever keeps the classic three talent trees and lists every tree's spells as its
-- own spellbook tab with nothing off-spec; there the game's "specialization" number is
-- just a placeholder (always 1), so it mustn't decide your stat priority.
local function hasRealSpecs()
    local SB = C_SpellBook
    if not (SB and SB.GetNumSpellBookSkillLines and SB.GetSpellBookSkillLineInfo) then return true end
    for l = 1, SB.GetNumSpellBookSkillLines() or 0 do
        local li = SB.GetSpellBookSkillLineInfo(l)
        if li and li.offSpecID and li.offSpecID ~= 0 then return true end
    end
    return false
end

-- spell ID -> spellbook tab name ("Retribution", "Holy", ...)
local function spellTabs()
    local map, SB = {}, C_SpellBook
    if not (SB and SB.GetNumSpellBookSkillLines) then return map end
    local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player or 0
    for l = 1, SB.GetNumSpellBookSkillLines() or 0 do
        local li = SB.GetSpellBookSkillLineInfo(l)
        if li then
            for i = li.itemIndexOffset + 1, li.itemIndexOffset + li.numSpellBookItems do
                local it = SB.GetSpellBookItemInfo(i, bank)
                if it and it.spellID then map[it.spellID] = li.name end
            end
        end
    end
    return map
end

-- WoW: Forever lays the three classic talent trees side by side in one modern talent tree.
-- Split the nodes into three by their left-to-right position (the two widest gaps between
-- columns), in the same order as the spellbook tabs.
local function treeColumns(xs)
    table.sort(xs)
    local uniq = {}
    for _, x in ipairs(xs) do if uniq[#uniq] ~= x then uniq[#uniq + 1] = x end end
    if #uniq < 6 then return nil end
    local gaps = {}
    for i = 2, #uniq do gaps[#gaps + 1] = { size = uniq[i] - uniq[i - 1], at = (uniq[i] + uniq[i - 1]) / 2 } end
    table.sort(gaps, function(a, b) return a.size > b.size end)
    local g1, g2, g3 = gaps[1], gaps[2], gaps[3]
    if not (g1 and g2) then return nil end
    -- the gaps between trees must stand out from the gaps inside a tree
    if g3 and g2.size < g3.size * 1.2 then return nil end
    local b1, b2 = math.min(g1.at, g2.at), math.max(g1.at, g2.at)
    return function(x) return x < b1 and 1 or (x < b2 and 2 or 3) end
end
S.TreeColumns = treeColumns

-- talent points per tree from the modern talent system (C_Traits): by sub-tree name, else by
-- which of the three side-by-side trees the talent sits in, else by its spell's spellbook tab.
-- Returns { [treeName] = points } or nil.
function S:TraitPoints()
    local CT, T = C_ClassTalents, C_Traits
    if not (CT and CT.GetActiveConfigID and T and T.GetConfigInfo and T.GetTreeNodes and T.GetNodeInfo) then return nil end
    local configID = CT.GetActiveConfigID()
    local info = configID and T.GetConfigInfo(configID)
    if not (info and info.treeIDs) then return nil end
    local specs = self:ClassSpecs()
    local nodes, xs = {}, {}
    for _, treeID in ipairs(info.treeIDs) do
        for _, nodeID in ipairs(T.GetTreeNodes(treeID) or {}) do
            local node = T.GetNodeInfo(configID, nodeID)
            if node then
                nodes[#nodes + 1] = node
                if node.posX then xs[#xs + 1] = node.posX end
            end
        end
    end
    local column = treeColumns(xs)
    local tabs
    local pts, any = {}, false
    for _, node in ipairs(nodes) do
        local ranks = node.ranksPurchased or node.currentRank or 0
        if ranks > 0 then
            local group
            if node.subTreeID and T.GetSubTreeInfo then
                local st = T.GetSubTreeInfo(configID, node.subTreeID)
                group = st and st.name
            end
            if not group and column and node.posX and specs[column(node.posX)] then
                group = specs[column(node.posX)]
            end
            if not group and node.activeEntry and T.GetEntryInfo and T.GetDefinitionInfo then
                tabs = tabs or spellTabs()
                local e = T.GetEntryInfo(configID, node.activeEntry.entryID)
                local d = e and e.definitionID and T.GetDefinitionInfo(e.definitionID)
                local spell = d and (d.spellID or d.overriddenSpellID)
                group = spell and tabs[spell]
            end
            if group then pts[group] = (pts[group] or 0) + ranks any = true end
        end
    end
    return any and pts or nil
end

-- remembered for a few seconds (gear checks ask for every item); cleared when talents change
local specCache, specAt = nil, -100
local function forgetSpec() specCache = nil end
for _, e in ipairs({ "PLAYER_TALENT_UPDATE", "TRAIT_CONFIG_UPDATED", "CHARACTER_POINTS_CHANGED", "SPELLS_CHANGED",
    "PLAYER_LEVEL_UP", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_SPECIALIZATION_CHANGED" }) do
    S:On(e, forgetSpec)
end

function S:DetectSpec()
    if specCache and GetTime() - specAt < 10 then return specCache[1], specCache[2] end
    local spec, pts = self:DetectSpecNow()
    specCache, specAt = { spec, pts }, GetTime()
    return spec, pts
end

function S:DetectSpecNow()
    local specs = self:ClassSpecs()
    -- modern clients: the chosen specialization
    local SI = C_SpecializationInfo
    if SI and SI.GetSpecialization and hasRealSpecs() then
        local ok, idx = pcall(SI.GetSpecialization)
        if ok and type(idx) == "number" and idx > 0 then
            local ok2, _, name = pcall(SI.GetSpecializationInfo, idx)
            if ok2 and type(name) == "string" then
                for _, n in ipairs(specs) do if n == name then return n, 1 end end
            end
            if specs[idx] then return specs[idx], 1 end
        end
    end
    -- talent points: the tree with the most
    local ok, pts = pcall(self.TraitPoints, self)
    if ok and pts then
        local best, bestPts = nil, 0
        for _, n in ipairs(specs) do
            if (pts[n] or 0) > bestPts then best, bestPts = n, pts[n] end
        end
        if best then return best, bestPts end
    end
    local best, bestPts = nil, 0
    local n = 3
    if GetNumTalentTabs then
        local ok2, v = pcall(GetNumTalentTabs)
        if ok2 and type(v) == "number" then n = math.min(v, 3) end
    end
    for tab = 1, n do
        local p = self:TabPoints(tab)
        if p > bestPts then best, bestPts = tab, p end
    end
    if best and specs[best] then return specs[best], bestPts end
    -- no talents to go by yet: the usual leveling spec for your class
    return specs[specs.default or 1] or "?", 0
end

-- the spec everything follows: stat weights, rotation, talents and action bars. Before talents open (level 10) it is
-- your class's default; after that the spec you picked (talent window buttons or Options, per character), else the
-- one your talents show, else the default.
function S:DefaultSpec()
    local specs = self:ClassSpecs()
    return specs[specs.default or 1]
end

function S:CurrentSpec()
    local lvl = UnitLevel and UnitLevel("player") or 60
    if type(lvl) == "number" and lvl > 0 and lvl < self.TALENTS_AT then
        local d = self:DefaultSpec()
        if d then return d, true end
    end
    local specs = self:ClassSpecs()
    for _, chosen in ipairs({ StewardCharDB and StewardCharDB.gearSpec, self:Get("gearSpec") }) do
        if chosen and chosen ~= "auto" then
            for _, name in ipairs(specs) do
                if name == chosen then return chosen, false end
            end
        end
    end
    return (self:DetectSpec()), true
end

-- pick a spec for this character (talent window buttons, Options)
function S:PickSpec(name)
    StewardCharDB = StewardCharDB or {}
    StewardCharDB.gearSpec = name or "auto"
    self:SettingsChanged()
    if self.UpdateSpecButtons then self:UpdateSpecButtons() end
end

function S:SpecLabel()
    local spec, auto = self:CurrentSpec()
    if auto then return "Auto-detect (" .. spec .. ")" end
    return spec
end

function S:Weights()
    local spec = self:CurrentSpec()
    local byClass = self.SPEC_PROFILE[self:PlayerClass()]
    return (byClass and byClass[spec]) or P.strMelee
end
