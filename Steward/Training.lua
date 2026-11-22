local _, S = ...

-- Class training: knows when you have new abilities to learn, finds your nearest class
-- trainer, and fits the visit in at a good moment (a small detour, or when you've
-- fallen a few levels behind).

local G = S.G

local function cdb() StewardCharDB.training = StewardCharDB.training or {} return StewardCharDB.training end

---------------------------------------------------------------- is training due?
-- Wowhead's Forever leveling guides, "Mandatory Abilities to Train" per spec (read page by page): at the trainer
-- these are learned first; the rest ("optional", which the guides say can be skipped to save gold) only once every
-- mandatory one on offer has been bought. Specs not listed here learn everything in the trainer's order.
local HUNTER_FIRST = { "Concussive Shot", "Multi-Shot", "Aspect of the Cheetah", "Rapid Fire", "Frost Trap", "Feign Death",
    "Explosive Trap", "Immolation Trap", "Raptor Strike", "Hunter's Mark", "Mongoose Bite", "Volley", "Aimed Shot",
    "Arcane Shot", "Aspect of the Hawk", "Freezing Trap", "Mend Pet", "Serpent Sting", "Wing Clip", "Trueshot Aura" }
S.TRAIN_FIRST = {
    -- Hunter: the same mandatory table on all three leveling pages (read 2026-11-12); optional: tracking, Aspect of the
    -- Monkey, Eagle Eye, Flare
    HUNTER = { ["Beast Mastery"] = HUNTER_FIRST, Marksmanship = HUNTER_FIRST, Survival = HUNTER_FIRST },
    PALADIN = {
        Retribution = { "Seal of Righteousness", "Holy Light", "Blessing of Might", "Judgement", "Holy Strike",
            "Seal of the Crusader", "Hammer of Justice", "Retribution Aura", "Blessing of Freedom", "Consecration",
            "Seal of Command", "Exorcism", "Flash of Light", "Divine Shield", "Cleanse", "Hammer of Wrath" },
        Holy = { "Judgement", "Retribution Aura", "Consecration", "Flash of Light", "Seal of Light" },
        Protection = { "Judgement", "Holy Strike", "Seal of Fury", "Retribution Aura", "Consecration" },
    },
    DRUID = {
        Restoration = { "Abolish Poison", "Entangling Roots", "Healing Touch", "Innervate", "Mark of the Wild",
            "Omen of Clarity", "Regrowth", "Rejuvenation", "Remove Curse", "Rebirth", "Revive", "Thorns" },
        Feral = { "Claw", "Rake", "Omen of Clarity", "Rip", "Primal Bite", "Swipe", "Faerie Fire", "Barkskin" },
        Balance = { "Wrath", "Moonfire", "Insect Swarm", "Thorns", "Hurricane", "Starfire", "Entangling Roots", "Rejuvenation",
            "Regrowth", "Healing Touch", "Faerie Fire", "Mark of the Wild" },
    },
    WARRIOR = {
        Fury = { "Rend", "Overpower", "Battle Shout", "Pummel" },
        Protection = { "Heroic Strike", "Battle Shout", "Charge", "Rend", "Thunder Clap", "Sunder Armor", "Revenge",
            "Demoralizing Shout", "Shield Block", "Cleave", "Victory Rush", "Shield Slam" },
        Arms = { "Heroic Strike", "Battle Shout", "Charge", "Rend", "Sunder Armor", "Overpower", "Cleave", "Victory Rush",
            "Mortal Strike", "Recklessness" },
    },
    MAGE = {
        -- Arcane: its own table (no Fireball or Pyroblast; Arcane Wrath in), plus the city teleports
        Arcane = { "Frost Armor", "Arcane Intellect", "Conjure Water", "Frostbolt", "Conjure Food", "Fire Blast",
            "Arcane Missiles", "Polymorph", "Frost Nova", "Arcane Explosion", "Blink", "Evocation", "Remove Lesser Curse",
            "Blizzard", "Arcane Blast", "Arcane Wrath", "Counterspell", "Frost Blast", "Cone of Cold", "Conjure Mana Agate",
            "Mage Armor", "Ice Armor", "Teleport: Stormwind", "Teleport: Ironforge", "Teleport: Darnassus",
            "Teleport: Orgrimmar", "Teleport: Undercity", "Teleport: Thunder Bluff" },
        -- Fire: the guide's mandatory table, plus the city teleports its text counts in (portals are optional)
        Fire = { "Fireball", "Frost Armor", "Arcane Intellect", "Conjure Water", "Frostbolt", "Conjure Food", "Fire Blast",
            "Arcane Missiles", "Polymorph", "Frost Nova", "Arcane Explosion", "Blink", "Evocation", "Remove Lesser Curse",
            "Blizzard", "Arcane Blast", "Counterspell", "Pyroblast", "Frost Blast", "Cone of Cold", "Conjure Mana Agate",
            "Mage Armor", "Ice Armor", "Teleport: Stormwind", "Teleport: Ironforge", "Teleport: Darnassus",
            "Teleport: Orgrimmar", "Teleport: Undercity", "Teleport: Thunder Bluff" },
    },
    -- Priest (the three leveling pages, read 2026-11-13). Discipline: its table, "every rank" of each (the text adds
    -- that some Holy Fire and Smite ranks can wait while you wand until about 40; the table wins). Holy: its table lists
    -- rank 1 of each; "after the first rank" it says to keep Heal, Flash Heal, Renew and Power Word: Shield current,
    -- and Shadow Word: Pain and Mind Blast while questing, so only those come first at every rank ({ name, rank1 = true }:
    -- only until you know it). Shadow: its table, plus Mind Flay and Devouring Plague, the rest of the "rotational
    -- Shadow spells" its text says to keep at the latest rank.
    PRIEST = {
        Discipline = { "Renew", "Power Word: Shield", "Devouring Plague", "Shadow Word: Pain", "Holy Fire", "Smite" },
        Holy = { "Heal", "Flash Heal", "Renew", "Power Word: Shield", "Shadow Word: Pain", "Mind Blast",
            { "Smite", rank1 = true }, { "Lesser Heal", rank1 = true }, { "Power Word: Fortitude", rank1 = true },
            { "Fade", rank1 = true }, { "Inner Fire", rank1 = true }, { "Cure Disease", rank1 = true },
            { "Dispel Magic", rank1 = true }, { "Holy Fire", rank1 = true }, { "Fear Ward", rank1 = true },
            { "Prayer of Healing", rank1 = true }, { "Divine Spirit", rank1 = true }, { "Abolish Disease", rank1 = true },
            { "Greater Heal", rank1 = true } },
        Shadow = { "Shadow Word: Death", "Shadow Word: Pain", "Mind Blast", "Power Word: Shield", "Power Word: Fortitude",
            "Inner Fire", "Mind Flay", "Devouring Plague" },
    },
    -- Shaman (the three leveling pages, read 2026-11-13). Elemental and Restoration: their tables, every rank (both
    -- add that "depending on your playstyle" Lightning Bolt upgrades past rank 4 may be worth skipping until 60: the
    -- table wins). Enhancement: its table names the rank to train to, the last one for each, except Windfury Totem
    -- (rank 1 only: { name, rank1 = true }). Optional: resistance totems, Windwall Totem, Far Sight and Frostbrand
    -- Weapon (Elemental, Restoration; Restoration also Lesser Healing Wave), the Call spells and Totemic Call
    -- (Enhancement); like every other spell, they're bought once the mandatory ones are.
    SHAMAN = {
        Elemental = { "Lightning Bolt", "Rockbiter Weapon", "Earth Shock", "Strength of Earth Totem", "Earthbind Totem",
            "Lightning Shield", "Flame Shock", "Searing Totem", "Flametongue Weapon", "Fire Nova", "Tremor Totem",
            "Ghost Wolf", "Frost Shock", "Magma Totem", "Windfury Weapon", "Astral Recall", "Chain Lightning",
            "Windfury Totem", "Grace of Air Totem" },
        Enhancement = { "Earth Shock", "Flame Shock", "Windfury Weapon", "Lightning Shield", "Fire Nova",
            "Strength of Earth Totem", "Poison Cleansing Totem", "Disease Cleansing Totem", { "Windfury Totem", rank1 = true } },
        Restoration = { "Healing Wave", "Lightning Bolt", "Rockbiter Weapon", "Earth Shock", "Strength of Earth Totem",
            "Earthbind Totem", "Lightning Shield", "Searing Totem", "Flametongue Weapon", "Fire Nova", "Tremor Totem",
            "Ghost Wolf", "Frost Shock", "Healing Stream Totem", "Magma Totem", "Astral Recall", "Chain Lightning",
            "Windfury Totem", "Chain Heal", "Grace of Air Totem" },
    },
    -- Warlock (the three leveling pages, read 2026-11-13): their "Must-Have" tables. Drain Soul: "Rank 1 is enough";
    -- Immolate (Affliction, Demonology): "10, 20. Later ranks (30 to 60) mainly for single pulls" ({ name, toLevel = n }:
    -- only ranks you can learn by that level come first; later ones are bought with the optional spells); Create
    -- Firestone (Demonology, Destruction): rank 1 at 28, then "Switch to Create Spellstone at 36". The Destruction page's
    -- Incinerate is the Dungeon Build's (Steward uses the Solo Build, which never has it). Demon spells come from
    -- Grimoires the Demon Trainer sells: not bought by Steward.
    WARLOCK = {
        Affliction = { "Corruption", "Life Tap", "Bane of Agony", "Fear", { "Drain Soul", rank1 = true }, "Drain Life",
            "Curse of the Elements", "Howl of Terror", "Death Coil", "Siphon Life", "Demon Skin", "Demon Armor",
            "Create Healthstone", "Create Soulstone", "Create Spellstone", "Summon Felsteed", "Shadow Bolt",
            { "Immolate", toLevel = 20 }, "Hellfire" },
        Demonology = { "Corruption", "Life Tap", "Bane of Agony", "Fear", { "Drain Soul", rank1 = true }, "Drain Life",
            "Curse of the Elements", "Howl of Terror", "Death Coil", "Demon Skin", "Demon Armor", "Create Healthstone",
            "Create Soulstone", { "Create Firestone", rank1 = true }, "Create Spellstone", "Summon Felsteed",
            { "Immolate", toLevel = 20 }, "Searing Pain", "Hellfire" },
        Destruction = { "Corruption", "Life Tap", "Bane of Agony", "Fear", { "Drain Soul", rank1 = true }, "Drain Life",
            "Curse of the Elements", "Howl of Terror", "Death Coil", "Demon Skin", "Demon Armor", "Create Healthstone",
            "Create Soulstone", { "Create Firestone", rank1 = true }, "Create Spellstone", "Summon Felsteed", "Shadow Bolt",
            "Immolate", "Shadowburn", "Conflagrate", "Hellfire" },
    },
    ROGUE = {
        Assassination = { "Stealth", "Sinister Strike", "Eviscerate", "Evasion", "Slice and Dice", "Sprint", "Sap",
            "Kick", "Vanish" },
        Combat = { "Stealth", "Sinister Strike", "Eviscerate", "Evasion", "Slice and Dice", "Sprint", "Sap", "Kick",
            "Vanish" },
        Subtlety = { "Stealth", "Sinister Strike", "Eviscerate", "Evasion", "Slice and Dice", "Sprint", "Sap", "Kick",
            "Ambush", "Vanish" },
    },
}

-- Spells a guide says not to buy while leveling: never bought automatically (you can still buy them yourself).
-- Frost mage: "talents like Amplify and Dampen Magic are completely useless while leveling".
-- An entry { name, from = level } is skipped only from that level on (and with untilTalent, only until you have it).
S.TRAIN_SKIP = {
    MAGE = { Frost = { "Amplify Magic", "Dampen Magic" } },
    -- Retribution (read 2026-11-12): Seal of Righteousness "All until Level 20, then again once you get Unsealed Wrath";
    -- Seal of Fury "Only if tanking" / "skip ... entirely"; Seal of Justice, Concentration Aura, Turn Undead, Holy Wrath
    -- "Skip"; Blessing of Sacrifice "Skip or first rank only" (skipped); Devotion Aura and Lay on Hands "First rank
    -- only"; Blessing of Protection, Purify and Divine Protection "only need their first initial rank". (Blessing of
    -- Freedom and Cleanse are named there too, but the mandatory table says "All" for them: the table wins.)
    PALADIN = { Retribution = { { "Seal of Righteousness", from = 20, untilTalent = "Unsealed Wrath" }, "Seal of Fury",
        "Seal of Justice", "Concentration Aura", "Turn Undead", "Holy Wrath", "Blessing of Sacrifice",
        { "Devotion Aura", firstRankOnly = true }, { "Lay on Hands", firstRankOnly = true },
        { "Blessing of Protection", firstRankOnly = true }, { "Purify", firstRankOnly = true },
        { "Divine Protection", firstRankOnly = true } } },
    -- Balance: the bear spells are "only worth training if you use Bear Form ... before level 40. Once you have Moonkin
    -- Form, you can stop training them."
    DRUID = { Balance = { { "Swipe", from = 40 }, { "Demoralizing Roar", from = 40 }, { "Enrage", from = 40 },
        { "Bash", from = 40 } },
        -- Feral: "Useful Abilities to Skip Training"; Entangling Roots: "the first rank is really high value, but the rest
        -- are definitely skippable"
        Feral = { "Abolish Poison", "Track Humanoids", "Cower", "Soothe Animal", "Starfire",
            { "Entangling Roots", firstRankOnly = true } } },
    -- Shadow priest: "Damaging spells from the Holy school, like Smite and Holy Fire, generally won't see much use and
    -- can be safely skipped."
    PRIEST = { Shadow = { "Smite", "Holy Fire" } },
    -- Warlock pages, "Abilities to Skip While Leveling" (Affliction also Create Firestone: "Its Fire bonus does little
    -- for Affliction"), plus the ranks they say stop at one: Drain Soul "Rank 1 is enough", Curse of Recklessness and
    -- (Affliction) Searing Pain "Rank 1 only"; Create Firestone (Demonology, Destruction) from 36: "Switch to Create
    -- Spellstone at 36"
    WARLOCK = {
        Affliction = { "Curse of Weakness", "Drain Mana", "Detect Invisibility", "Create Firestone", "Subjugate Demon",
            "Rain of Fire", "Soul Fire", { "Drain Soul", firstRankOnly = true },
            { "Curse of Recklessness", firstRankOnly = true }, { "Searing Pain", firstRankOnly = true } },
        Demonology = { "Curse of Weakness", "Drain Mana", "Detect Invisibility", "Subjugate Demon", "Rain of Fire",
            "Soul Fire", { "Drain Soul", firstRankOnly = true }, { "Curse of Recklessness", firstRankOnly = true },
            { "Create Firestone", from = 36 } },
        Destruction = { "Curse of Weakness", "Drain Mana", "Detect Invisibility", "Subjugate Demon", "Rain of Fire",
            "Soul Fire", { "Drain Soul", firstRankOnly = true }, { "Curse of Recklessness", firstRankOnly = true },
            { "Create Firestone", from = 36 } },
    },
}

-- When to visit the trainer, where a page says. Warlock (all three pages): "Up to 20, visit the trainer whenever you
-- are in town ... After that, you can keep your core spells current with fewer trips": the levels of its "Trainer
-- Stops" table. Elsewhere a visit is due whenever new ranks open (TrainingDue).
local WARLOCK_STOPS = { 24, 30, 36, 40, 44, 48, 54, 58, 60 }
S.TRAIN_STOPS = {
    WARLOCK = { Affliction = WARLOCK_STOPS, Demonology = WARLOCK_STOPS, Destruction = WARLOCK_STOPS },
}

function S:TrainingStops()
    local byClass = self.TRAIN_STOPS[self:PlayerClass() or ""]
    return byClass and byClass[self:CurrentSpec() or ""] or nil
end

function S:SkippedTraining()
    local byClass = self.TRAIN_SKIP[self:PlayerClass() or ""]
    local list = byClass and byClass[self:CurrentSpec() or ""]
    if not list then return nil end
    local set, lvl = {}, UnitLevel and UnitLevel("player") or 1
    for _, n in ipairs(list) do
        if type(n) == "table" then
            local known = n.firstRankOnly and S.ReadSpellbook and (S.ReadSpellbook() or {})[n[1]]
            if n.firstRankOnly then
                if known then set[n[1]] = true end -- you have rank 1: later ranks are skipped
            elseif lvl >= (n.from or 0) then
                -- untilTalent: skipped only until you take that talent (Seal of Righteousness once Unsealed Wrath is in)
                local has = n.untilTalent and self.TalentRank and (self:TalentRank(n.untilTalent) or 0) > 0
                if not has then set[n[1]] = true end
            end
        else
            set[n] = true
        end
    end
    return set
end

function S:MandatoryTraining()
    local byClass = self.TRAIN_FIRST[self:PlayerClass() or ""]
    local list = byClass and byClass[self:CurrentSpec() or ""]
    if not list then return nil end
    local set, book = {}, nil
    for _, n in ipairs(list) do
        if type(n) == "table" and n.toLevel then
            -- toLevel: only the ranks you can learn by that level are mandatory (S.MandatoryRank checks a rank)
            set[n[1]] = n.toLevel
        elseif type(n) == "table" then
            -- rank1: mandatory only until you know the spell; its later ranks are bought with the optional ones
            book = book or (S.ReadSpellbook and S.ReadSpellbook() or {})
            if not book[n[1]] then set[n[1]] = true end
        else
            set[n] = true
        end
    end
    return set
end

-- is this rank on offer mandatory? (set from MandatoryTraining; req = the level the rank needs)
function S.MandatoryRank(set, name, req)
    local m = set and set[name]
    if m == true then return true end
    if type(m) == "number" then return (req or 0) <= m end
    return false
end

function S:TrainingDue()
    local t = cdb()
    local lvl = UnitLevel("player")
    if lvl < 2 then return false, 0 end
    -- no record yet: assume you're trained up as of now (never guess you're far behind)
    if not t.lastLevel then t.lastLevel = lvl end
    if t.snoozeLevel == lvl then return false, 0 end
    local last = t.lastLevel
    -- a page's own trainer stops (warlocks after 20): due at the first stop since your last visit (a visit missed
    -- at 20 is due at once); what you couldn't buy waits for that stop
    local stops = self.TrainingStops and self:TrainingStops()
    if stops and lvl > 20 then
        local nextStop = last < 20 and 20 or nil
        if not nextStop then
            for _, s in ipairs(stops) do
                if s > last then nextStop = s break end
            end
        end
        if nextStop and lvl >= nextStop then return true, lvl - nextStop end
        return false, 0
    end
    if t.upcoming and t.upcomingFrom == last then
        -- the trainer told us which levels unlock new ranks
        for _, req in ipairs(t.upcoming) do
            if req <= lvl then return true, lvl - req end
        end
        return t.leftover and true or false, 0
    end
    -- haven't seen your trainer's list yet: new ranks come every couple of levels
    if lvl >= last + 2 then return true, lvl - last - 2 end
    return t.leftover and true or false, 0
end

---------------------------------------------------------------- where are trainers?
local function sameClassTrainer(step)
    for _, el in ipairs(step.elements) do
        if el.cmd == "trainer" and S:GateOK(el.gate) then return true end
    end
end

function S:TrainerPoints()
    local list = {}
    local _, class = UnitClass("player")
    -- trainers named in your guides (for your class, race and faction)
    for _, g in ipairs(self.guides) do
        if self:GuideOK(g) then
            for _, step in ipairs(g.steps) do
                if self:GateOK(step.gate) and step.gate and step.gate:upper():find(class, 1, true)
                    and sameClassTrainer(step) then
                    local go, name
                    for _, el in ipairs(step.elements) do
                        if el.go and self:GateOK(el.gate) then go = el.go end
                        if el.cmd == "target" and el.args[1] then name = el.args[1]:gsub("::.*$", "") end
                    end
                    local p = go and self.FromGoto(go, name or "your trainer")
                    if p then list[#list + 1] = p end
                end
            end
        end
    end
    -- trainers you've visited yourself
    local learned = StewardDB.trainers and StewardDB.trainers[class] or {}
    for _, t in ipairs(learned) do
        local vec = CreateVector2D(t.wx, t.wy)
        local mapID, pos = C_Map.GetMapPosFromWorldPos(t.instance, vec)
        list[#list + 1] = { world = vec, instance = t.instance, name = t.name,
            go = { radius = 10, resolved = { world = vec, instance = t.instance, mapID = mapID, x = pos and pos.x or 0, y = pos and pos.y or 0 } } }
    end
    -- drop duplicates (same spot within 40 yards)
    local out = {}
    for _, p in ipairs(list) do
        local dup = false
        for _, q in ipairs(out) do
            local d = self.TravelDist(p, q)
            if d and d < 40 then dup = true break end
        end
        if not dup then out[#out + 1] = p end
    end
    return out
end

---------------------------------------------------------------- fitting it in
-- returns travel legs ending at a trainer when now is a good time, else nil
function S:TrainingDetour(stepGo)
    if not self:Get("guideTraining") then return nil end
    local due, behind = self:TrainingDue()
    if not due then return nil end
    local start = self:PlayerPoint()
    local target = stepGo and self.FromGoto(stepGo, "the quest")
    if not (start and target) then return nil end

    local _, base = self:Route(start, target, true)
    base = base or 0

    -- check the closest few trainers
    local trainers = self:TrainerPoints()
    table.sort(trainers, function(a, b)
        return (self.TravelDist(start, a) or 1e9) < (self.TravelDist(start, b) or 1e9)
    end)
    local best, bestCost, bestLegs, bestA
    for i = 1, math.min(#trainers, 4) do
        local tr = trainers[i]
        local legsA, costA = self:Route(start, tr, true)
        local _, costB = self:Route(tr, target, false)
        if costA and costB then
            local cost = costA + 30 + costB
            if not bestCost or cost < bestCost then best, bestCost, bestLegs, bestA = tr, cost, legsA, costA end
        end
    end
    if not best then return nil end

    local extra = bestCost - base
    local lvl = UnitLevel("player")
    -- good moments: a small detour; a longer one only once you've really fallen behind
    -- (and never a trip to another continent just to train)
    if best.instance ~= start.instance then return nil end
    local visited = cdb().visited
    if extra > 180 and not (visited and behind >= 2) then return nil end
    if extra > 480 then return nil end

    local legs = {}
    for _, l in ipairs(bestLegs or {}) do legs[#legs + 1] = l end
    -- final approach to the trainer replaces a generic "head to the quest area"
    if legs[#legs] and legs[#legs].kind == "run" then table.remove(legs) end
    legs[#legs + 1] = { kind = "train", text = "Train new abilities with " .. (best.name or "your class trainer"), target = best }
    legs.total = bestA
    legs.training = true
    legs.level = lvl
    return legs
end

---------------------------------------------------------------- visiting a trainer
-- is the open trainer your class trainer (not a profession or weapon trainer)?
local function isClassTrainer()
    if IsTradeskillTrainer then return not IsTradeskillTrainer() end
    if GetTrainerServiceSkillLine and GetNumTrainerServices and GetNumTrainerServices() > 0 then
        local line = GetTrainerServiceSkillLine(1)
        if line then
            for _, spec in ipairs(S:ClassSpecs()) do if line == spec then return true end end
            local _, cls = UnitClass("player")
            local className = UnitClass("player")
            return line == className or line == cls
        end
    end
    return true
end
S.IsClassTrainer = isClassTrainer

local atClassTrainer = false
S:On("TRAINER_SHOW", function()
    atClassTrainer = isClassTrainer()
    if not atClassTrainer then return end
    local t = cdb()
    local lvl = UnitLevel("player")
    t.lastLevel, t.visited, t.snoozeLevel = lvl, true, nil
    -- remember where this trainer stands
    local x, y, inst = S:PlayerWorld()
    local _, class = UnitClass("player")
    if x then
        StewardDB.trainers = StewardDB.trainers or {}
        local list = StewardDB.trainers[class] or {}
        StewardDB.trainers[class] = list
        local known = false
        for _, tr in ipairs(list) do
            if tr.instance == inst and math.abs(tr.wx - x) < 30 and math.abs(tr.wy - y) < 30 then known = true end
        end
        if not known then
            list[#list + 1] = { name = UnitName("npc") or "Class trainer", wx = x, wy = y, instance = inst }
        end
    end
    -- read which levels unlock the next ranks
    C_Timer.After(0.5, function()
        if not (GetNumTrainerServices and GetTrainerServiceInfo) then return end
        local levels, seen = {}, {}
        for i = 1, GetNumTrainerServices() do
            local _, _, category = GetTrainerServiceInfo(i)
            local req = GetTrainerServiceLevelReq and GetTrainerServiceLevelReq(i)
            if category == "unavailable" and req and req > lvl and not seen[req] then
                seen[req] = true
                levels[#levels + 1] = req
            end
        end
        table.sort(levels)
        t.upcoming, t.upcomingFrom = levels, lvl
        t.leftover = nil
    end)
    if S.ReplanTravel then C_Timer.After(1, S.ReplanTravel) end
end)

S:On("TRAINER_CLOSED", function()
    -- anything still "available" (e.g. not enough gold) stays due; not what a guide says to skip, which stays on offer
    if not (GetNumTrainerServices and GetTrainerServiceInfo) or not atClassTrainer then return end
    local skip = S.SkippedTraining and S:SkippedTraining() or {}
    local leftover = false
    for i = 1, GetNumTrainerServices() do
        local name, _, category = GetTrainerServiceInfo(i)
        if category == "available" and not skip[name] then leftover = true end
    end
    cdb().leftover = leftover or nil
    if S.ReplanTravel then C_Timer.After(0.5, S.ReplanTravel) end
end)

S:On("PLAYER_LEVEL_UP", function()
    if S.ReplanTravel then C_Timer.After(2, S.ReplanTravel) end
end)

-- right-click the training section to put it off until your next level
function S:SnoozeTraining()
    cdb().snoozeLevel = UnitLevel("player")
    if S.ReplanTravel then S.ReplanTravel() end
end
