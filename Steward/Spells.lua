local _, S = ...

-- What each class ability is for, so the action bar manager knows where it goes
-- (and the rotation helper knows what to suggest). Roles:
--   rot    the spec's damage rotation, in priority order (main bar 1-6)
--   core   other attacks, crowd control, interrupts (main bar 7-12)
--   heal   heals, cleanses and defensive cooldowns (bar 2)
--   buff   blessings, auras, seals, armors, shouts, weapon buffs, totems (bar 3)
--   travel mounts, teleports, recall (bar 5, after the hearthstone)
--   prof   profession windows and tracking (bar 5)
--   long   long cooldowns and rarely used spells (bar 5, last)
--   skip   never placed (stances and forms live on the stance bar)
-- Names are matched exactly; a name ending in "*" matches anything starting with it.
-- A spell the lists don't know is placed by what the game says about it.

local R = {}

R.WARRIOR = {
    rot = {
        Arms = { "Charge", "Mortal Strike", "Overpower", "Rend", "Heroic Strike", "Execute", "Slam" },
        Fury = { "Charge", "Bloodthirst", "Whirlwind", "Heroic Strike", "Execute", "Rend", "Overpower" },
        Protection = { "Shield Slam", "Revenge", "Sunder Armor", "Heroic Strike", "Taunt", "Thunder Clap", "Charge" },
    },
    core = { "Thunder Clap", "Hamstring", "Sunder Armor", "Cleave", "Demoralizing Shout", "Pummel", "Shield Bash",
        "Intercept", "Taunt", "Mocking Blow", "Intimidating Shout", "Piercing Howl", "Bloodrage", "Berserker Rage",
        "Disarm", "Concussion Blow", "Sweeping Strikes", "Whirlwind", "Execute", "Overpower", "Revenge",
        "Throw", "Shoot Bow", "Shoot Gun", "Shoot Crossbow" },
    heal = { "Shield Block", "Shield Wall", "Last Stand", "Retaliation" },
    buff = { "Battle Shout" },
    long = { "Recklessness", "Death Wish", "Challenging Shout" },
    skip = { "Battle Stance", "Defensive Stance", "Berserker Stance" },
}

R.PALADIN = {
    -- one seal leads the rotation: the first of these you know
    rotSeal = { "Seal of Command", "Seal of Righteousness" },
    rot = {
        Retribution = { "@seal", "Judgement", "Crusader Strike", "Holy Strike", "Exorcism", "Consecration", "Hammer of Wrath" },
        Protection = { "@seal", "Judgement", "Holy Shield", "Consecration", "Holy Strike", "Exorcism", "Hammer of Wrath" },
        Holy = { "@seal", "Judgement", "Holy Shock", "Holy Strike", "Exorcism", "Consecration", "Hammer of Wrath" },
    },
    core = { "Hammer of Justice", "Exorcism", "Consecration", "Hammer of Wrath", "Holy Wrath", "Turn Undead",
        "Repentance", "Holy Strike", "Crusader Strike", "Holy Shield" },
    heal = { "Holy Light", "Flash of Light", "Divine Shield", "Divine Protection", "Lay on Hands", "Holy Shock",
        "Blessing of Protection", "Blessing of Freedom", "Blessing of Sacrifice", "Purify", "Cleanse" },
    buff = { "Seal of *", "Blessing of *", "Greater Blessing of *", "* Aura", "Righteous Fury", "Blessings",
        "Utility Blessings", "Auras" },
    long = { "Redemption", "Divine Intervention", "Sense Undead", "Divine Favor" },
    travel = { "Summon Warhorse", "Summon Charger" },
}

R.HUNTER = {
    rot = {
        ["Beast Mastery"] = { "Hunter's Mark", "Serpent Sting", "Arcane Shot", "Multi-Shot", "Auto Shot", "Raptor Strike", "Aimed Shot" },
        Marksmanship = { "Hunter's Mark", "Serpent Sting", "Aimed Shot", "Arcane Shot", "Multi-Shot", "Auto Shot", "Raptor Strike" },
        Survival = { "Hunter's Mark", "Serpent Sting", "Arcane Shot", "Multi-Shot", "Raptor Strike", "Mongoose Bite", "Auto Shot" },
    },
    core = { "Raptor Strike", "Mongoose Bite", "Wing Clip", "Concussive Shot", "Scatter Shot", "Counterattack",
        "Freezing Trap", "Immolation Trap", "Frost Trap", "Explosive Trap", "Distracting Shot", "Scare Beast",
        "Tranquilizing Shot", "Viper Sting", "Scorpid Sting", "Disengage", "Volley", "Wyvern Sting", "Intimidation",
        "Flare", "Auto Shot" },
    heal = { "Mend Pet", "Feign Death", "Deterrence", "Revive Pet" },
    buff = { "Aspect of *", "Trueshot Aura" },
    long = { "Rapid Fire", "Bestial Wrath", "Call Pet", "Dismiss Pet", "Tame Beast", "Feed Pet", "Beast Lore",
        "Track *", "Eagle Eye", "Eyes of the Beast", "Beast Training" },
}

R.ROGUE = {
    rot = {
        Assassination = { "Sinister Strike", "Eviscerate", "Slice and Dice", "Rupture", "Backstab", "Kick", "Cold Blood" },
        Combat = { "Sinister Strike", "Slice and Dice", "Eviscerate", "Riposte", "Kick", "Gouge", "Backstab" },
        Subtlety = { "Hemorrhage", "Sinister Strike", "Slice and Dice", "Eviscerate", "Backstab", "Kick", "Ghostly Strike" },
    },
    core = { "Stealth", "Kick", "Gouge", "Kidney Shot", "Blind", "Sprint", "Expose Armor", "Cheap Shot", "Ambush",
        "Garrote", "Sap", "Distract", "Ghostly Strike", "Throw", "Shoot Bow", "Shoot Gun", "Shoot Crossbow" },
    form = {
        stealth = { "Cheap Shot", "Ambush", "Garrote", "Sap", "Pick Pocket", "Distract", "Premeditation",
            "Sinister Strike", "Backstab", "Stealth" },
    },
    heal = { "Evasion", "Vanish", "Feint", "Preparation" },
    buff = {},
    long = { "Adrenaline Rush", "Blade Flurry", "Cold Blood", "Pick Lock", "Pick Pocket", "Disarm Trap",
        "Detect Traps", "Premeditation" },
}

R.PRIEST = {
    rot = {
        Shadow = { "Shadow Word: Pain", "Mind Blast", "Mind Flay", "Devouring Plague", "Smite", "Shoot", "Vampiric Embrace" },
        Holy = { "Smite", "Shadow Word: Pain", "Holy Fire", "Mind Blast", "Shoot", "Power Word: Shield" },
        Discipline = { "Shadow Word: Pain", "Smite", "Mind Blast", "Holy Fire", "Shoot", "Power Word: Shield" },
    },
    core = { "Psychic Scream", "Shoot", "Holy Fire", "Mana Burn", "Silence", "Mind Control", "Shackle Undead",
        "Mind Soothe", "Holy Nova", "Starshards", "Hex of Weakness", "Mind Flay", "Mind Blast", "Smite" },
    heal = { "Lesser Heal", "Heal", "Greater Heal", "Flash Heal", "Renew", "Power Word: Shield", "Prayer of Healing",
        "Cure Disease", "Abolish Disease", "Dispel Magic", "Desperate Prayer", "Fade" },
    buff = { "Power Word: Fortitude", "Prayer of Fortitude", "Inner Fire", "Divine Spirit", "Prayer of Spirit",
        "Shadow Protection", "Prayer of Shadow Protection", "Fear Ward", "Touch of Weakness", "Elune's Grace",
        "Feedback", "Shadowguard" },
    long = { "Resurrection", "Inner Focus", "Power Infusion", "Levitate", "Mind Vision" },
    skip = { "Shadowform" },
}

R.SHAMAN = {
    rot = {
        Elemental = { "Lightning Bolt", "Flame Shock", "Earth Shock", "Chain Lightning", "Searing Totem", "Frost Shock" },
        Enhancement = { "Stormstrike", "Earth Shock", "Flame Shock", "Searing Totem", "Lightning Bolt", "Frost Shock" },
        Restoration = { "Lightning Bolt", "Flame Shock", "Earth Shock", "Searing Totem", "Chain Lightning" },
    },
    core = { "Earth Shock", "Frost Shock", "Flame Shock", "Purge", "Searing Totem", "Magma Totem", "Fire Nova Totem",
        "Earthbind Totem", "Stoneclaw Totem", "Chain Lightning", "Grounding Totem" },
    heal = { "Healing Wave", "Lesser Healing Wave", "Chain Heal", "Cure Poison", "Cure Disease", "Healing Stream Totem",
        "Mana Spring Totem", "Poison Cleansing Totem", "Disease Cleansing Totem", "Tremor Totem" },
    buff = { "Lightning Shield", "* Weapon", "* Totem", "Water Breathing", "Water Walking" },
    long = { "Ancestral Spirit", "Mana Tide Totem", "Elemental Mastery", "Nature's Swiftness", "Far Sight" },
    travel = { "Ghost Wolf", "Astral Recall" },
}

R.MAGE = {
    rot = {
        Frost = { "Frostbolt", "Fire Blast", "Frost Nova", "Cone of Cold", "Fireball", "Arcane Explosion" },
        Fire = { "Fireball", "Fire Blast", "Scorch", "Pyroblast", "Frost Nova", "Flamestrike", "Blast Wave" },
        Arcane = { "Arcane Missiles", "Frostbolt", "Fire Blast", "Frost Nova", "Arcane Explosion", "Fireball" },
    },
    core = { "Frost Nova", "Counterspell", "Polymorph", "Blizzard", "Arcane Explosion", "Flamestrike", "Cone of Cold",
        "Fire Blast", "Blink", "Scorch", "Blast Wave", "Shoot", "Arcane Missiles", "Fireball", "Frostbolt" },
    heal = { "Ice Barrier", "Mana Shield", "Ice Block", "Frost Ward", "Fire Ward", "Remove Lesser Curse" },
    buff = { "Arcane Intellect", "Arcane Brilliance", "Frost Armor", "Ice Armor", "Mage Armor", "Dampen Magic",
        "Amplify Magic", "Slow Fall", "Detect Magic" },
    long = { "Conjure *", "Evocation", "Presence of Mind", "Arcane Power", "Combustion", "Cold Snap" },
    travel = { "Teleport: *", "Portal: *", "Teleport", "Portal" },
}

R.WARLOCK = {
    rot = {
        Affliction = { "Corruption", "Curse of Agony", "Shadow Bolt", "Siphon Life", "Drain Life", "Life Tap", "Immolate" },
        Demonology = { "Corruption", "Curse of Agony", "Shadow Bolt", "Immolate", "Life Tap", "Drain Life" },
        Destruction = { "Immolate", "Corruption", "Curse of Agony", "Shadow Bolt", "Conflagrate", "Searing Pain", "Life Tap" },
    },
    core = { "Fear", "Howl of Terror", "Death Coil", "Drain Soul", "Drain Mana", "Searing Pain", "Hellfire",
        "Rain of Fire", "Shoot", "Banish", "Curse of *", "Life Tap", "Shadowburn", "Amplify Curse", "Shadow Bolt",
        "Immolate", "Corruption" },
    heal = { "Health Funnel", "Shadow Ward", "Drain Life" },
    buff = { "Demon Skin", "Demon Armor", "Detect *", "Unending Breath", "Soul Link" },
    long = { "Summon Imp", "Summon Voidwalker", "Summon Succubus", "Summon Felhunter", "Inferno", "Ritual of *",
        "Create *", "Enslave Demon", "Eye of Kilrogg", "Fel Domination", "Sense Demons", "Demonic Sacrifice" },
    travel = { "Summon Felsteed", "Summon Dreadsteed" },
}

R.DRUID = {
    rot = {
        Balance = { "Moonfire", "Wrath", "Starfire", "Insect Swarm", "Faerie Fire", "Entangling Roots" },
        Feral = { "Moonfire", "Wrath", "Faerie Fire", "Entangling Roots", "Starfire", "Insect Swarm" },
        Restoration = { "Moonfire", "Wrath", "Insect Swarm", "Faerie Fire", "Starfire", "Entangling Roots" },
    },
    -- the bar each form swaps to gets its own set
    form = {
        cat = { "Rake", "Claw", "Rip", "Ferocious Bite", "Shred", "Tiger's Fury", "Prowl", "Pounce", "Ravage",
            "Cower", "Dash", "Faerie Fire (Feral)" },
        bear = { "Maul", "Swipe", "Growl", "Demoralizing Roar", "Enrage", "Bash", "Feral Charge",
            "Frenzied Regeneration", "Challenging Roar", "Faerie Fire (Feral)" },
    },
    core = { "Entangling Roots", "Hibernate", "Faerie Fire", "Hurricane", "Soothe Animal", "Moonfire", "Starfire",
        "Wrath", "Insect Swarm" },
    heal = { "Healing Touch", "Regrowth", "Rejuvenation", "Tranquility", "Remove Curse", "Abolish Poison",
        "Cure Poison", "Swiftmend", "Barkskin", "Nature's Swiftness" },
    buff = { "Mark of the Wild", "Gift of the Wild", "Thorns", "Omen of Clarity" },
    long = { "Innervate", "Rebirth", "Nature's Grasp", "Track Humanoids" },
    travel = { "Teleport: Moonglade" },
    skip = { "Bear Form", "Dire Bear Form", "Cat Form", "Travel Form", "Aquatic Form", "Moonkin Form",
        "Prowl", "Rake", "Claw", "Rip", "Ferocious Bite", "Shred", "Tiger's Fury", "Pounce", "Ravage", "Cower",
        "Dash", "Maul", "Swipe", "Growl", "Demoralizing Roar", "Enrage", "Bash", "Feral Charge",
        "Frenzied Regeneration", "Challenging Roar", "Faerie Fire (Feral)" },
}

-- every class: racials, professions, and things nobody needs on a bar
local COMMON = {
    heal = { "Stoneform", "Will of the Forsaken", "Will to Survive", "Escape Artist" },
    core = { "War Stomp" },
    long = { "Berserking", "Blood Fury", "Perception", "Shadowmeld", "Cannibalize" },
    prof = { "First Aid", "Cooking", "Basic Campfire", "Smelting", "Alchemy", "Blacksmithing", "Leatherworking", "Tailoring",
        "Engineering", "Enchanting", "Disenchant", "Find Minerals", "Find Herbs", "Find Treasure", "Fishing",
        "Prospecting", "Jewelcrafting", "Inscription", "Mining", "Herbalism", "Skinning", "Survey", "Pick Lock" },
    skip = { "Attack", "Languages" },
}

S.SPELL_ROLES = R
S.COMMON_ROLES = COMMON

local ORDER = { "skip", "travel", "prof", "heal", "buff", "core", "long" }

local function matches(name, pattern)
    if pattern:sub(-1) == "*" then
        return name:sub(1, #pattern - 1) == pattern:sub(1, -2)
    elseif pattern:sub(1, 1) == "*" then
        return #name >= #pattern - 1 and name:sub(-(#pattern - 1)) == pattern:sub(2)
    end
    return name == pattern
end
S.SpellPatternMatches = matches

local function inList(name, list)
    if not list then return false end
    for _, p in ipairs(list) do
        if matches(name, p) then return true end
    end
    return false
end

-- the rotation for your class and spec, with the seal choice made
-- The spells for the main bar, best first. They come from the same Wowhead rotation the rotation helper follows
-- (Rotation.lua): the spell you spam first, then the rest in Wowhead's priority, your wand last. Buffs (shouts,
-- shields, weapon imbues, other seals) stay on the buff bar; one seal, your rotation's, goes on the main bar.
-- After those come the older list's extras (interrupts, taunts and the like).
function S:RotationList(class, spec, known)
    local data = R[class]
    local out, seen = {}, {}
    local function push(name)
        if name and not seen[name] then seen[name] = true out[#out + 1] = name end
    end
    local sealDone = false
    local rules = self.ROTATIONS and self.ROTATIONS[class] and self.ROTATIONS[class][spec]
    if rules then
        for _, r in ipairs(rules) do
            if r.filler and r[1] ~= "Shoot" and (not known or known(r[1])) then push(r[1]) break end
        end
        for _, r in ipairs(rules) do
            local name = r[1]
            if name:find("^Seal of ") then
                if not sealDone and name ~= "Seal of the Crusader" and (not known or known(name)) then
                    push(name) sealDone = true
                end
            elseif name ~= "Shoot" and self:SpellRole(name, nil, class) ~= "buff" then
                push(name)
            end
        end
        for _, r in ipairs(rules) do if r[1] == "Shoot" then push("Shoot") break end end
    end
    if data and data.rot then
        local list = data.rot[spec]
        if not list then
            for _, l in pairs(data.rot) do list = l break end
        end
        for _, name in ipairs(list or {}) do
            if name == "@seal" then
                if not sealDone then
                    for _, seal in ipairs(self:SealOrder(data.rotSeal or {})) do
                        if not known or known(seal) then push(seal) sealDone = true break end
                    end
                end
            elseif not name:find("^Seal of ") or not sealDone then
                push(name)
            end
        end
    end
    return out
end

-- Seal of Command is for two-handed weapons; with a one-hander, Seal of Righteousness does more
local function twoHanded()
    local link = GetInventoryItemLink and GetInventoryItemLink("player", 16)
    if not link then return true end
    local get = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
    local _, _, _, equipLoc = get(link)
    return equipLoc == nil or equipLoc == "INVTYPE_2HWEAPON"
end
S.TwoHanded = twoHanded

function S:SealOrder(list)
    if twoHanded() then return list end
    local out = {}
    for i = #list, 1, -1 do out[#out + 1] = list[i] end
    return out
end

-- the spells that belong on a form's own bar (druid cat and bear)
function S:FormList(class, form)
    local data = R[class]
    return data and data.form and data.form[form] or nil
end

local function describe(spellID)
    if not spellID then return "" end
    local fn = C_Spell and C_Spell.GetSpellDescription
    local ok, text = pcall(fn or function() end, spellID)
    if ok and type(text) == "string" then return text:lower() end
    return ""
end

local function harmful(spellID)
    local fn = C_Spell and C_Spell.IsSpellHarmful
    if not fn or not spellID then return nil end
    local ok, v = pcall(fn, spellID)
    if ok then return v and true or false end
end

-- where a spell goes: one of the roles above (never "rot": that comes from the rotation list)
function S:SpellRole(name, spellID, class)
    class = class or self:PlayerClass()
    local data = R[class] or {}
    for _, role in ipairs(ORDER) do
        if inList(name, data[role]) or inList(name, COMMON[role]) then return role end
    end
    -- not in the lists (new to this game, or a rank of something renamed): go by the name, then the tooltip
    if name:find("^Seal of") or name:find("^Blessing of") or name:find("^Greater Blessing")
        or name:find(" Aura$") or name:find("^Aspect of") or name:find(" Armor$") or name:find(" Totem$")
        or name:find(" Weapon$") then
        return "buff"
    end
    if name:find("^Teleport") or name:find("^Portal") or name:find("^Summon .*steed") or name:find("^Summon .*horse")
        or name:find("^Summon Charger") then
        return "travel"
    end
    local text = describe(spellID)
    local hurts = harmful(spellID)
    if hurts then return "core" end
    if text:find("heals? ") or text:find("restores %d+ health") or text:find("absorb") or text:find("cures? ")
        or text:find("removes? .*poison") or text:find("removes? .*disease") or text:find("removes? .*curse")
        or text:find("removes? .*magic") then
        return "heal"
    end
    if text:find("damage") and hurts ~= false then return "core" end
    if text:find("%d+ min") or text:find("for %d+ hour") or text:find("increases") then return "buff" end
    return "long"
end
