local _, S = ...

-- Spends talent points as soon as you have them, along a leveling build for your spec
-- (the spec Steward detects, or the one you picked under stat priority).
-- Talents it knows are taken in order; anything else goes top-down in your spec's tree.
-- A build marked exact is followed point by point and nothing outside it is taken: if none of its
-- steps can be taken, the point stays unspent.
-- A small note by the talent button says what was learned. Turn it off in Options, or hold
-- Shift when the point arrives to leave it for later.

local BUILD = {
    -- WoW: Forever's trees (Sanctity Aura removed; Improved Blessing of Wisdom and Lasting Judgement
    -- now baseline; Sanctified Judgement, Sacred Arbiter, Champion of the Light, Unsealed Wrath new)
    PALADIN = {
        -- Retribution: Wowhead's Forever leveling build (12/8/31; the page updated 2026-11-18, read 2026-11-22), point
        -- by point from level 10 to 60. exact: each step raises that talent to that rank, in this order; nothing else
        -- is ever taken.
        Retribution = { exact = true,
            { "Benediction", 5 }, { "Improved Judgement", 2 }, { "Sanctified Judgement", 3 }, { "Seal of Command", 1 },
            { "Pursuit of Justice", 2 }, { "Conviction", 2 }, { "Sacred Arbiter", 1 },
            { "Two-Handed Weapon Specialization", 3 }, { "Conviction", 3 }, { "Vengeance", 3 }, { "Repentance", 1 },
            { "Unyielding Faith", 1 }, { "Champion of the Light", 5 }, { "Unsealed Wrath", 1 },
            { "Divine Strength", 5 }, { "Improved Seals", 5 }, { "Holy Conduit", 2 }, { "Divine Intellect", 5 },
            { "Precision", 3 } },
        -- Protection and Holy: Wowhead's Forever leveling builds, in their order (both checked point by point against
        -- the leveling pages, 2026-11-12). Holy's order lists 46 points from 15; Steward spends them as they come.
        Protection = { exact = true,
            { "Benediction", 5 }, { "Sanctified Judgement", 3 }, { "Conviction", 2 }, { "Pursuit of Justice", 2 },
            { "Redoubt", 5 }, { "Precision", 3 }, { "Guardian's Favor", 2 }, { "Templar's Bulwark", 1 },
            { "Shield Specialization", 2 }, { "Toughness", 2 }, { "Swift Judgement", 1 }, { "Improved Righteous Fury", 3 },
            { "Toughness", 3 }, { "Holy Shield", 1 }, { "Reckoning", 5 }, { "Iron Creed", 3 }, { "Sacred Duty", 1 },
            { "Shieldsworn", 1 }, { "Improved Judgement", 2 }, { "Vindication", 1 }, { "Sacred Arbiter", 1 },
            { "Vindication", 3 }, { "Conviction", 3 }, { "Sacred Duty", 2 } },
        Holy = { exact = true,
            { "Spiritual Focus", 5 }, { "Reverence", 2 }, { "Benediction", 5 }, { "Improved Judgement", 2 },
            { "Conviction", 3 }, { "Pursuit of Justice", 2 }, { "Healing Light", 3 }, { "Illumination", 5 },
            { "Divine Favor", 1 }, { "Infusion of Light", 2 }, { "Oath of Light", 1 }, { "Divine Precision", 1 },
            { "Holy Shock", 1 }, { "Boundless Light", 2 }, { "Divine Precision", 2 }, { "Consecrated Ground", 1 },
            { "Holy Power", 5 }, { "Light's Vigil", 1 }, { "Consecrated Ground", 2 }, { "Holy Conduit", 2 },
            -- the page's talent trees show Divine Intellect 5/5 too, but its level-by-level order (which starts at 15)
            -- never places it; Steward takes it last (read 2026-11-12)
            { "Divine Intellect", 5 } },
    },
    WARRIOR = {
        -- Wowhead's Forever leveling guides (read 2026-11-12; all three again 2026-11-22), point by point from 10 to 60.
        -- Arms 36/15/0 (the page updated 2026-11-18)
        Arms = { exact = true,
            { "Improved Rend", 3 }, { "Deflection", 2 }, { "Improved Overpower", 2 }, { "Improved Tactical Mastery", 3 },
            { "Deep Wounds", 3 }, { "Anger Management", 1 }, { "Deflection", 3 }, { "Spearing Strike", 1 },
            { "Two-Handed Weapon Specialization", 3 }, { "Impale", 1 }, { "Bloodthrill", 1 }, { "Impale", 2 },
            { "Sweeping Strikes", 1 }, { "Bloodthrill", 2 }, { "Weaponmaster", 5 }, { "Improved Slam", 1 },
            { "Mortal Strike", 1 }, { "Cruelty", 5 }, { "Lingering Rage", 5 }, { "Enrage", 5 }, { "Improved Slam", 2 },
            { "Deflection", 5 }, { "Improved Charge", 2 } },
        -- Fury 11/40/0
        Fury = { exact = true,
            { "Cruelty", 5 }, { "Unbridled Wrath", 5 }, { "Enrage", 2 }, { "Blood Craze", 3 }, { "Reckless Swings", 1 },
            { "Dual Wield Specialization", 4 }, { "Death Wish", 1 }, { "Gore Drinker", 2 },
            { "Dual Wield Specialization", 5 }, { "Enrage", 3 }, { "Flurry", 3 }, { "Improved Whirlwind", 2 },
            { "Bloodthirst", 1 }, { "Enrage", 5 }, { "Furious Precision", 3 }, { "Deflection", 5 },
            { "Improved Execute", 2 }, { "Improved Berserker Rage", 2 }, { "Improved Overpower", 2 },
            { "Improved Tactical Mastery", 3 }, { "Anger Management", 1 } },
        -- Protection: Wowhead's Forever leveling build (the guide's first build), point by point from 10 to 60
        Protection = { exact = true,
            { "Shield Specialization", 5 }, { "Improved Revenge", 3 }, { "Improved Thunder Clap", 2 },
            { "Master of Defense", 2 }, { "Improved Thunder Clap", 3 }, { "Last Stand", 1 }, { "Defiance", 1 },
            { "Vanguard", 1 }, { "Defiance", 3 }, { "Improved Bloodrage", 2 }, { "Concussion Blow", 1 },
            { "Focused Rage", 3 }, { "Improved Shield Wall", 1 }, { "Bastion", 5 }, { "Shield Slam", 1 },
            { "Improved Shield Wall", 2 }, { "Cruelty", 5 }, { "Booming Voice", 5 }, { "Enrage", 5 },
            { "Piercing Howl", 1 }, { "Blood Craze", 3 } },
    },
    HUNTER = {
        -- Wowhead's Forever leveling builds, point by point from 10 to 60
        ["Beast Mastery"] = { exact = true,
            { "Deadly Aspects", 5 }, { "Focused Fire", 2 }, { "Endurance Training", 3 }, { "Bestial Swiftness", 1 },
            { "Unleashed Fury", 4 }, { "Summon Hawk", 1 }, { "Unleashed Fury", 5 }, { "Ferocity", 3 },
            { "Intimidation", 1 }, { "Bestial Discipline", 2 }, { "Ferocity", 5 }, { "Frenzy", 5 }, { "Bestial Wrath", 1 },
            { "Lethal Attacks", 5 }, { "Careful Aim", 5 }, { "Improved Stings", 3 }, { "Rapid Killing", 2 },
            { "Trueshot Aura", 1 }, { "Improved Tracking", 4 } },
        Marksmanship = { exact = true,
            { "Lethal Attacks", 5 }, { "Careful Aim", 5 }, { "Rapid Killing", 2 }, { "Efficiency", 3 },
            { "Trueshot Aura", 1 }, { "Mortal Shots", 4 }, { "Rapid Recuperation", 2 }, { "Mortal Shots", 5 },
            { "Efficiency", 5 }, { "Ranged Weapon Specialization", 5 }, { "Deadly Aspects", 5 }, { "Focused Fire", 2 },
            { "Endurance Training", 3 }, { "Bestial Swiftness", 1 }, { "Scatter Shot", 1 }, { "Unleashed Fury", 4 },
            { "Improved Arcane Shot", 5 } },
        Survival = { exact = true,
            { "Improved Tracking", 5 }, { "Savage Strikes", 2 }, { "Survivalist", 3 }, { "Deterrence", 1 },
            { "Surefooted", 3 }, { "Clever Traps", 1 }, { "Counterattack", 1 }, { "Predator's Edge", 4 },
            { "Strider Kick", 1 }, { "Resourcefulness", 2 }, { "Predator's Edge", 5 }, { "Expose Prey", 2 },
            { "Deadly Aspects", 5 }, { "Focused Fire", 2 }, { "Endurance Training", 3 }, { "Bestial Swiftness", 1 },
            { "Unleashed Fury", 4 }, { "Summon Hawk", 1 }, { "Lethal Attacks", 5 }, { "Careful Aim", 4 } },
    },
    ROGUE = {
        -- Wowhead's Forever leveling builds, point by point from 10 to 60
        Assassination = { exact = true,
            { "Efficient Strikes", 2 }, { "Remorseless Attacks", 2 }, { "Malice", 5 }, { "Improved Slice and Dice", 3 },
            { "Lethality", 2 }, { "Vigor", 2 }, { "Blood Splatter", 1 }, { "Cold Blood", 1 }, { "Improved Poisons", 4 },
            { "Venom", 1 }, { "Coup de Grace", 3 }, { "Deflection", 3 }, { "Precision", 2 }, { "Riposte", 1 },
            { "Composure", 2 }, { "Precision", 3 }, { "Endurance", 1 }, { "Weapon Expertise", 2 }, { "Aggression", 3 },
            { "Blade Flurry", 1 }, { "Dual Wield Specialization", 2 }, { "Flawless Execution", 1 },
            { "Hack and Slash", 1 }, { "Flash of Steel", 5 } },
        Combat = { exact = true,
            { "Efficient Strikes", 2 }, { "Remorseless Attacks", 2 }, { "Coup de Grace", 3 }, { "Precision", 2 },
            { "Deflection", 3 }, { "Riposte", 1 }, { "Composure", 2 }, { "Precision", 3 }, { "Endurance", 1 },
            { "Weapon Expertise", 2 }, { "Aggression", 3 }, { "Blade Flurry", 1 }, { "Dual Wield Specialization", 2 },
            { "Flawless Execution", 1 }, { "Hack and Slash", 1 }, { "Flash of Steel", 5 }, { "Adrenaline Rush", 1 },
            { "Hack and Slash", 5 }, { "Malice", 3 }, { "Improved Slice and Dice", 3 }, { "Malice", 5 }, { "Vigor", 2 },
            { "Lethality", 2 }, { "Ruthlessness", 1 }, { "Cold Blood", 1 } },
        Subtlety = { exact = true,
            { "Efficient Strikes", 2 }, { "Remorseless Attacks", 2 }, { "Opportunity", 5 }, { "Improved Ambush", 3 },
            { "Master of Deception", 1 }, { "Camouflage", 1 }, { "Serrated Blades", 3 }, { "Initiative", 2 },
            { "Ghostly Strike", 1 }, { "Initiative", 3 }, { "Premeditation", 1 }, { "Camouflage", 2 },
            { "Master of Deception", 2 }, { "Hemorrhage", 1 }, { "Preparation", 1 }, { "Coup de Grace", 3 },
            { "Precision", 2 }, { "Deflection", 3 }, { "Riposte", 1 }, { "Composure", 2 }, { "Precision", 3 },
            { "Endurance", 1 }, { "Weapon Expertise", 2 }, { "Flawless Execution", 1 }, { "Endurance", 2 },
            { "Aggression", 1 }, { "Blade Flurry", 1 }, { "Dual Wield Specialization", 2 }, { "Hack and Slash", 2 },
            { "Flash of Steel", 2 } },
    },
    PRIEST = {
        -- Shadow and Discipline: Wowhead's Forever leveling builds, point by point from 10 to 60 (pages read again
        -- 2026-11-13: unchanged).
        Shadow = { exact = true,
            { "Wand Specialization", 2 }, { "Spirit Tap", 5 }, { "Improved Shadow Word: Pain", 2 }, { "Shadow Reach", 2 },
            { "Shadow Focus", 1 }, { "Mind Flay", 1 }, { "Improved Mind Flay", 2 }, { "Shadow Focus", 3 },
            { "Shadow Weaving", 3 }, { "Vampiric Embrace", 1 }, { "Improved Mind Blast", 1 }, { "Devouring Contagion", 2 },
            { "Improved Mind Blast", 4 }, { "Darkness", 5 }, { "Shadowform", 1 }, { "Twin Disciplines", 3 },
            { "Silent Resolve", 3 }, { "Mental Strength", 2 }, { "Meditation", 3 }, { "Twilight Focus", 3 },
            { "Silence", 1 }, { "Mental Strength", 5 } },
        Discipline = { exact = true,
            { "Wand Specialization", 2 }, { "Power in Light", 3 }, { "Holy Precision", 1 }, { "Mental Strength", 4 },
            { "Meditation", 3 }, { "Inner Focus", 1 }, { "Improved Power Word: Shield", 1 }, { "Improved Inner Fire", 3 },
            { "Improved Power Word: Shield", 3 }, { "Penance", 1 }, { "Soul Warding", 1 }, { "Twilight Focus", 3 },
            { "Holy Specialization", 2 }, { "Divine Fury", 5 }, { "Holy Nova", 1 }, { "Spirit Tap", 5 },
            { "Mental Agility", 3 }, { "Power in Light", 5 }, { "Holy Specialization", 5 }, { "Blessed Recovery", 1 },
            { "Searing Light", 2 }, { "Mental Strength", 5 }, { "Holy Reach", 1 } },
        -- Holy: Wowhead's Forever Holy leveling page, its Talent Order point by point (19/32/0; the page updated
        -- 2026-11-21 and read 2026-11-22: before, its list held one entry and Steward's order came from the page's text)
        Holy = { exact = true,
            { "Wand Specialization", 2 }, { "Holy Specialization", 5 }, { "Divine Fury", 5 }, { "Inspiration", 3 },
            { "Holy Nova", 1 }, { "Twilight Focus", 1 }, { "Improved Healing", 3 }, { "Holy Reach", 2 },
            { "Spirit of Redemption", 1 }, { "Spiritual Guidance", 5 }, { "Spiritual Healing", 3 }, { "Litany of Light", 2 },
            { "Prayer of Mending", 1 }, { "Twin Disciplines", 3 }, { "Mental Strength", 5 }, { "Inner Focus", 1 },
            { "Meditation", 3 }, { "Twin Disciplines", 5 }, { "Improved Power Word: Shield", 3 } },
    },
    SHAMAN = {
        -- Wowhead's Forever leveling builds, point by point from 10 to 60. Elemental: the guide's "True Elemental"
        -- build (its other option, "Spellhance", needs a respec at 31).
        Elemental = { exact = true,
            { "Tidal Focus", 5 }, { "Mindfulness", 3 }, { "Totemic Focus", 2 }, { "Water Shield", 1 }, { "Concussion", 5 },
            { "Elemental Alacrity", 3 }, { "Call of Flame", 2 }, { "Elemental Focus", 1 }, { "Call of Flame", 3 },
            { "Convection", 3 }, { "Eye of the Storm", 3 }, { "Earthbound", 1 }, { "Trial by Fire", 1 },
            { "Call of Thunder", 1 }, { "Lightning Overload", 3 }, { "Convection", 4 }, { "Elemental Fury", 5 },
            { "Lightning Mastery", 1 }, { "Trial by Fire", 2 }, { "Convection", 5 }, { "Thundering Strikes", 5 },
            { "Ancestral Knowledge", 2 } },
        -- Enhancement: 17/26/8 (the page updated 2026-11-18, read 2026-11-22)
        Enhancement = { exact = true,
            { "Thundering Strikes", 5 }, { "Mental Dexterity", 3 }, { "Ancestral Knowledge", 2 }, { "Shamanistic Focus", 1 },
            { "Elemental Weapons", 3 }, { "Ancestral Knowledge", 3 }, { "Stormstrike", 1 }, { "Improved Ghost Wolf", 2 },
            { "Flurry", 2 }, { "Improved Stormstrike", 2 }, { "Mental Quickness", 2 }, { "Spirit Weapons", 1 },
            { "Maelstrom Weapon", 1 }, { "Tidal Focus", 5 }, { "Mindfulness", 3 }, { "Concussion", 5 }, { "Call of Flame", 3 },
            { "Elemental Devastation", 3 }, { "Elemental Focus", 1 }, { "Reverberation", 3 }, { "Trial by Fire", 2 } },
        Restoration = { exact = true,
            { "Tidal Focus", 5 }, { "Mindfulness", 3 }, { "Improved Reincarnation", 2 }, { "Water Shield", 1 },
            { "Healing Focus", 3 }, { "Improved Healing Wave", 1 }, { "Mana Tide Totem", 1 }, { "Tidal Mastery", 4 },
            { "Nature's Swiftness", 1 }, { "Healing Way", 3 }, { "Tidal Mastery", 5 }, { "Purification", 5 },
            { "Riptide", 1 }, { "Thundering Strikes", 5 }, { "Mental Dexterity", 3 }, { "Ancestral Knowledge", 2 },
            { "Shamanistic Focus", 1 }, { "Ancestral Knowledge", 5 }, { "Elemental Weapons", 1 }, { "Improved Ghost Wolf", 2 },
            { "Ancestral Healing", 3 } },
    },
    MAGE = {
        -- Wowhead's Forever Frost leveling guide (read 2026-11-12): 7/0/44, point by point from 10 to 60
        Frost = { exact = true,
            { "Wand Specialization", 2 }, { "Improved Frostbolt", 5 }, { "Frostbite", 3 }, { "Precision", 2 },
            { "Ice Lance", 1 }, { "Improved Blizzard", 1 }, { "Ice Shards", 3 }, { "Shatter", 3 }, { "Ice Shards", 5 },
            { "Fingers of Frost", 2 }, { "Cold Snap", 1 }, { "Improved Cone of Cold", 2 }, { "Winter's Chill", 5 },
            { "Ice Barrier", 1 }, { "Ice Block", 1 }, { "Improved Cone of Cold", 3 }, { "Precision", 3 },
            { "Improved Blizzard", 3 }, { "Frost Channeling", 3 }, { "Permafrost", 3 }, { "Arctic Reach", 2 },
            { "Arcane Resilience", 3 }, { "Arcane Subtlety", 2 } },
        -- Fire and Arcane: Wowhead's Forever leveling builds, point by point from 10 to 60
        Fire = { exact = true,
            { "Accelerant", 5 }, { "Precision", 1 }, { "Incineration", 5 }, { "Pyroblast", 1 }, { "Improved Fire Blast", 2 },
            { "Ignite", 2 }, { "Heating Up", 1 }, { "Ignite", 5 }, { "Improved Channeling", 5 }, { "Missile Barrage", 2 },
            { "Arcane Subtlety", 2 }, { "Flame Throwing", 2 }, { "Critical Mass", 3 }, { "Burning Soul", 1 },
            { "Fire Power", 3 }, { "Burning Soul", 3 }, { "Combustion", 1 }, { "Precision", 2 },
            { "Arcane Concentration", 5 }, { "Arcane Blast", 1 }, { "Arcane Meditation", 3 } },
        Arcane = { exact = true,
            { "Wand Specialization", 2 }, { "Precision", 1 }, { "Improved Channeling", 3 }, { "Missile Barrage", 2 },
            { "Arcane Subtlety", 2 }, { "Improved Channeling", 4 }, { "Arcane Blast", 1 }, { "Improved Channeling", 5 },
            { "Arcane Concentration", 3 }, { "Arcane Wrath", 1 }, { "Arcane Concentration", 5 }, { "Arcane Meditation", 3 },
            { "Precision", 2 }, { "Arcane Mind", 5 }, { "Presence of Mind", 1 }, { "Arcane Impact", 3 },
            { "Arcane Instability", 3 }, { "Accelerant", 5 }, { "Incineration", 5 }, { "Arcane Power", 1 },
            { "Precision", 3 }, { "Arcane Geometry", 2 }, { "Improved Fire Blast", 2 } },
    },
    WARLOCK = {
        -- Wowhead's Forever leveling builds, point by point from 10 to 60 (Affliction: "no respec, Wrack at 47";
        -- Destruction: the solo build)
        Affliction = { exact = true,
            { "Improved Corruption", 5 }, { "Suppression", 3 }, { "Unholy Power", 5 }, { "Demonic Energies", 2 },
            { "Improved Drains", 3 }, { "Amplify Curse", 1 }, { "Improved Bane of Agony", 2 }, { "Suppression", 5 },
            { "Pandemic", 3 }, { "Improved Life Tap", 1 }, { "Siphon Life", 1 }, { "Soul Siphon", 3 },
            { "Improved Life Tap", 2 }, { "Shadow Mastery", 5 }, { "Wrack", 1 }, { "Malevolence", 5 },
            { "Fel Concentration", 3 }, { "Nightfall", 2 }, { "Improved Shadow Bolt", 3 } },
        Demonology = { exact = true,
            { "Unholy Power", 5 }, { "Demonic Energies", 2 }, { "Fel Vitality", 3 }, { "Master Summoner", 2 },
            { "Improved Sayaad", 3 }, { "Demonic Brand", 3 }, { "Demonic Sacrifice", 1 }, { "Fel Domination", 1 },
            { "Soul Link", 1 }, { "Demonic Knowledge", 3 }, { "Demonic Embrace", 1 }, { "Master Demonologist", 5 },
            { "Demonic Pact", 1 }, { "Improved Corruption", 5 }, { "Improved Life Tap", 2 }, { "Suppression", 5 },
            { "Improved Drains", 3 }, { "Pandemic", 3 }, { "Amplify Curse", 1 }, { "Malevolence", 1 } },
        Destruction = { exact = true,
            { "Bane", 5 }, { "Aftermath", 5 }, { "Shadowburn", 1 }, { "Cataclysm", 3 }, { "Molten Skin", 1 },
            { "Conflagrate", 1 }, { "Agonizing Flames", 3 }, { "Molten Skin", 2 }, { "Fire and Brimstone", 3 },
            { "Unholy Power", 5 }, { "Suppression", 5 }, { "Improved Life Tap", 2 }, { "Improved Drains", 3 },
            { "Amplify Curse", 1 }, { "Pandemic", 3 }, { "Improved Bane of Agony", 2 }, { "Malevolence", 5 },
            { "Soul Siphon", 2 } },
    },
    DRUID = {
        -- Wowhead's Forever leveling builds, point by point from 10 to 60 (Balance: "mixed single target and cleave";
        -- Feral: the DPS guide's build; Restoration: "HoTs and DoTs")
        Balance = { exact = true,
            { "Improved Wrath", 5 }, { "Moonglow", 3 }, { "Nature's Majesty", 2 }, { "Nature's Reach", 2 },
            { "Improved Moonfire", 2 }, { "Nature's Splendor", 1 }, { "Insect Swarm", 1 }, { "Improved Starfire", 4 },
            { "Eclipse", 3 }, { "Improved Starfire", 5 }, { "Nature's Grace", 1 }, { "Moonfury", 5 }, { "Moonkin Form", 1 },
            { "Nature's Focus", 5 }, { "Reflection", 3 }, { "Naturalist", 5 }, { "Genesis", 2 }, { "Vengeance", 5 } },
        -- Feral: 0/34/17 (the page updated 2026-11-19, read 2026-11-22)
        Feral = { exact = true,
            { "Ferocity", 5 }, { "Feral Swiftness", 2 }, { "Feral Instinct", 3 }, { "Feral Charge", 1 }, { "Savage Fury", 2 },
            { "Sharpened Claws", 2 }, { "Predatory Discipline", 1 }, { "Blood Frenzy", 2 }, { "Lacerate", 1 },
            { "Predatory Strikes", 1 }, { "Leader of the Pack", 1 }, { "Natural Instinct", 2 }, { "Predatory Strikes", 3 },
            { "Rend and Tear", 5 }, { "Shifting Power", 1 }, { "Primal Bite", 1 }, { "Heart of the Wild", 5 },
            { "Natural Shapeshifter", 3 }, { "Reflection", 3 }, { "Naturalist", 5 }, { "Swiftmend", 1 }, { "Brutal Impact", 2 } },
        Restoration = { exact = true,
            { "Improved Wrath", 5 }, { "Nature's Focus", 5 }, { "Reflection", 3 }, { "Naturalist", 2 }, { "Bloom", 1 },
            { "Nature's Majesty", 2 }, { "Genesis", 3 }, { "Nature's Splendor", 1 }, { "Improved Entangling Roots", 3 },
            { "Genesis", 4 }, { "Insect Swarm", 1 }, { "Genesis", 5 }, { "Moonglow", 3 }, { "Nature's Grace", 1 },
            { "Overgrowth", 2 }, { "Gift of Nature", 4 }, { "Swiftmend", 1 }, { "Gift of Nature", 5 }, { "Naturalist", 5 },
            { "Nature's Swiftness", 1 }, { "Improved Rejuvenation", 3 }, { "Living Spirit", 1 }, { "Improved Regrowth", 3 } },
    },
}
S.TALENT_BUILDS = BUILD

local T, CT = function() return C_Traits end, function() return C_ClassTalents end

local function spellName(id)
    if not id then return nil end
    local fn = C_Spell and C_Spell.GetSpellName
    if fn then
        local ok, n = pcall(fn, id)
        if ok and n then return n end
    end
end

local function nodeName(configID, node)
    local entryID = (node.activeEntry and node.activeEntry.entryID) or (node.entryIDs and node.entryIDs[1])
    if not entryID or not T().GetEntryInfo then return nil end
    local e = T().GetEntryInfo(configID, entryID)
    local d = e and e.definitionID and T().GetDefinitionInfo and T().GetDefinitionInfo(e.definitionID)
    local spell = d and (d.spellID or d.overriddenSpellID)
    return spellName(spell) or (d and d.overrideName)
end

-- the nodes of your talent tree: list of { id, info, name, column }
local function readTree()
    local C, X = CT(), T()
    if not (C and C.GetActiveConfigID and X and X.GetConfigInfo and X.GetTreeNodes and X.GetNodeInfo) then return nil end
    local configID = C.GetActiveConfigID()
    local info = configID and X.GetConfigInfo(configID)
    if not (info and info.treeIDs) then return nil end
    local nodes, xs = {}, {}
    for _, treeID in ipairs(info.treeIDs) do
        for _, nodeID in ipairs(X.GetTreeNodes(treeID) or {}) do
            local n = X.GetNodeInfo(configID, nodeID)
            if n and n.ID ~= 0 then
                nodes[#nodes + 1] = { id = nodeID, info = n, tree = treeID }
                if n.posX then xs[#xs + 1] = n.posX end
            end
        end
    end
    local column = S.TreeColumns and S.TreeColumns(xs)
    for _, n in ipairs(nodes) do
        n.name = nodeName(configID, n.info)
        n.column = column and n.info.posX and column(n.info.posX) or nil
    end
    return configID, nodes, info.treeIDs
end

local function unspent(configID, treeIDs)
    local C, X = CT(), T()
    if C and C.HasUnspentTalentPoints then
        local ok, has, classPts, specPts = pcall(C.HasUnspentTalentPoints)
        if ok and has == false then return 0 end
        if ok and type(classPts) == "number" then return classPts + (specPts or 0) end
    end
    if X and X.GetTreeCurrencyInfo then
        local total = 0
        for _, treeID in ipairs(treeIDs or {}) do
            local ok, list = pcall(X.GetTreeCurrencyInfo, configID, treeID, false)
            if ok and type(list) == "table" and list[1] then total = total + (list[1].quantity or 0) end
        end
        return total
    end
    return 0
end

local function canTake(info)
    local open = info.canPurchaseRank
    if open == nil then
        open = info.isAvailable and (info.ranksPurchased or 0) < (info.maxRanks or 0) and info.meetsEdgeRequirements ~= false
    end
    local choice = info.type and Enum and Enum.TraitNodeType and info.type == Enum.TraitNodeType.Selection
    return open and not (choice and not info.activeEntry) and info.isVisible ~= false
end

-- Other leveling builds a Wowhead Forever leveling guide shows for a spec (only builds the page displays). The build
-- in BUILD above is the guide's first; these can be picked per character in Options ("Talent build").
S.BUILD_CHOICES = {
    -- None at the moment. Nick (2026-11-12): one build per spec, the Wowhead page's main one (Balance: Mixed Single
    -- Target & Cleave only; Restoration druid: HoTs and DoTs only). Protection warrior's hidden "Arms route" list was
    -- added in 0.36.0 by mistake and taken out in 0.37.1.
}

-- the build this character follows for a spec: the one picked in Options if the guide offers it, else the default
function S:TalentBuildFor(class, spec)
    local choices = (self.BUILD_CHOICES[class] or {})[spec]
    local want = StewardCharDB and StewardCharDB.talentBuild
    if choices and want and want ~= "default" then
        for _, c in ipairs(choices) do
            if c.id == want and c.build then return c.build end
        end
    end
    return (BUILD[class] or {})[spec] or {}
end

-- the next talent to take: the first one in the build you can take, else the top-most in your tree
function S:NextTalent(nodes, class, spec)
    local build = self:TalentBuildFor(class, spec)
    if build.exact then
        local byName = {}
        for _, n in ipairs(nodes) do if n.name then byName[n.name] = n end end
        for _, step in ipairs(build) do
            local n = byName[step[1]]
            if n and (n.info.ranksPurchased or n.info.currentRank or 0) < step[2] and canTake(n.info) then return n end
        end
        return nil
    end
    local specs = self:ClassSpecs()
    local myColumn
    for i, n in ipairs(specs) do if n == spec then myColumn = i end end
    local order = {}
    for i, name in ipairs(build) do order[name] = i end
    local best, bestKey
    for _, n in ipairs(nodes) do
        local info = n.info
        if canTake(info) then
            local listed = n.name and order[n.name]
            local key
            if listed and myColumn and n.column and n.column ~= myColumn then
                key = 2000 + listed -- other trees only once your own has nothing left to take
            elseif listed then
                key = listed
            elseif myColumn and n.column == myColumn then
                key = 1000 + (info.posY or 0) / 10 + (info.posX or 0) / 100000
            end
            if key and (not bestKey or key < bestKey) then best, bestKey = n, key end
        end
    end
    return best
end

-- how many points you have in a talent (by name); read from the tree, kept while the game won't say
local ranks, ranksAt = nil, -100
function S:TalentRank(name)
    if not ranks or GetTime() - ranksAt > 15 then
        local ok, configID, nodes = pcall(readTree)
        if ok and configID and nodes then
            local r = {}
            for _, n in ipairs(nodes) do
                if n.name then r[n.name] = math.max(r[n.name] or 0, n.info.ranksPurchased or n.info.currentRank or 0) end
            end
            ranks = r
        end
        ranksAt = GetTime()
    end
    return ranks and ranks[name] or 0
end

local learned = {}
local spending = false

local function note()
    if #learned == 0 or not S.ShowReceipt then return end
    local lines = {}
    for i, l in ipairs(learned) do
        if i > 6 then lines[#lines + 1] = string.format("...and %d more", #learned - 6) break end
        lines[#lines + 1] = l
    end
    local button = _G.PlayerSpellsMicroButton or _G.TalentMicroButton
    S.ShowReceipt(button or _G.MainActionBar or UIParent, lines, button and { "BOTTOMRIGHT", "TOPLEFT", 0, 4 })
    learned = {}
end

local function log(text)
    StewardCharDB = StewardCharDB or {}
    StewardCharDB.talentLog = StewardCharDB.talentLog or {}
    table.insert(StewardCharDB.talentLog, date("%m-%d %H:%M ") .. text)
    while #StewardCharDB.talentLog > 20 do table.remove(StewardCharDB.talentLog, 1) end
end

local function commit(configID)
    local ok, res
    local C, X = CT(), T()
    if X and X.ConfigHasStagedChanges then
        local okS, staged = pcall(X.ConfigHasStagedChanges, configID)
        if okS and staged == false then return true end
    end
    if C and C.CommitConfig then
        -- no loadout to save into: just apply the active talents
        ok, res = pcall(C.CommitConfig)
        if ok and res then return true end
    end
    if X and X.CommitConfig then
        ok, res = pcall(X.CommitConfig, configID)
        if ok and res then return true end
    end
    log("commit failed: " .. tostring(res))
    if X and X.RollbackConfig then pcall(X.RollbackConfig, configID) end
    return false
end

function S:SpendTalents()
    if spending or not self:Get("talentsAuto") then return 0 end
    -- nothing is spent until you have picked your spec (talent window buttons or Options): at 10 the game opens
    -- talents and the choice is yours; the class default only covers gear, rotation and bars until then
    local _, notPicked = self:CurrentSpec()
    if notPicked then return 0 end
    if InCombatLockdown() or IsShiftKeyDown() then return 0 end
    local frame = _G.PlayerSpellsFrame or _G.ClassTalentFrame or _G.PlayerTalentFrame
    if frame and frame:IsShown() then return 0 end -- you're in the talent window yourself
    local C = CT()
    if C and C.CanChangeTalents then
        local ok, can = pcall(C.CanChangeTalents)
        if ok and can == false then return 0 end
    end
    local configID, nodes, treeIDs = readTree()
    if not configID then return 0 end
    local points = unspent(configID, treeIDs)
    if points <= 0 then return 0 end
    local class = self:PlayerClass()
    local spec = self:CurrentSpec()
    spending = true
    local spent = 0
    for _ = 1, points do
        local pick = self:NextTalent(nodes, class, spec)
        if not pick then break end
        local ok, done = pcall(T().PurchaseRank, configID, pick.id)
        if not (ok and done) then
            log("could not take " .. tostring(pick.name) .. ": " .. tostring(done))
            break
        end
        spent = spent + 1
        local info = T().GetNodeInfo(configID, pick.id)
        local rank = info and (info.ranksPurchased or info.currentRank) or 0
        local max = info and info.maxRanks or 0
        learned[#learned + 1] = string.format("%s %d/%d", pick.name or "Talent", rank, max)
        -- refresh what can be taken next
        for _, n in ipairs(nodes) do n.info = T().GetNodeInfo(configID, n.id) or n.info end
    end
    if spent > 0 then
        ranksAt = -100
        if commit(configID) then
            log("took " .. table.concat(learned, ", "))
            learned = {} -- logged only: spending talents is a routine chore, no receipt on screen
        else
            learned = {}
            spent = 0
        end
    end
    spending = false
    return spent
end

local queued = false
local function queue(delay)
    if queued then return end
    queued = true
    C_Timer.After(delay or 2, function()
        queued = false
        local ok, err = pcall(S.SpendTalents, S)
        spending = false
        if not ok then S:LogError("talents", err) end
    end)
end
S.QueueTalents = queue

-- The in-game way to pick your spec: three buttons on the game's talent window, one per spec (Nick, 2026-11-12).
-- Talents open at level 10; the button of the spec you follow is lit. Until you click one, Steward spends no points;
-- after that, points go into that spec's build once you close the window.
local specButtons
local function talentWindow()
    local f = _G.PlayerSpellsFrame
    return (f and f.TalentsFrame) or _G.ClassTalentFrame or _G.PlayerTalentFrame or f
end
-- The buttons ARE the game's tabs (Nick, 2026-11-12: "stay Blizz-like and use their stuff"). Forever's talent window
-- has its own tab row, TalentsFrame.TabSystem (Primary / Secondary; seen with /fstack in game). Steward makes its
-- three buttons from that tab row's own template, so they look and behave like Primary and Secondary: the spec you
-- picked is the selected tab with a check mark, the others plain tabs with the game's grey text. Until you pick (and
-- before 10, when the class default applies) no tab is selected. Nothing Steward draws itself.
local CHECK = "|A:common-icon-checkmark-yellow:14:14|a" -- the yellow check Primary carries
local function fontFor(b, font)
    local fs = type(b.Text) == "table" and b.Text or (b.GetFontString and b:GetFontString())
    if type(fs) == "table" and fs.SetFontObject and _G[font] then fs:SetFontObject(_G[font]) end
end
local function setLabel(b, text)
    if b.Init and b.tabID then pcall(b.Init, b, b.tabID, text) end -- the tab template's own way (sizes the tab)
    local fs = b.Text
    if type(fs) == "table" and fs.GetText and fs:GetText() == text then return end
    if type(fs) == "table" and fs.SetText then fs:SetText(text) return end -- the tab's own text region
    b:SetText(text)
end
-- fit the row between Primary/Secondary and the search box once the window has real sizes: the tabs keep
-- Primary's size where there's room and shrink evenly where there isn't, bottoms in line with Primary's
local function fitRow()
    local sb, tabs, search = specButtons, specButtons.tabs, specButtons.search
    if not (type(tabs) == "table" and tabs.GetRight and type(search) == "table" and search.GetLeft) then return end
    local okR, right = pcall(tabs.GetRight, tabs)
    local okL, left = pcall(search.GetLeft, search)
    if not (okR and okL and type(right) == "number" and type(left) == "number" and left > right) then return end
    local labelW = 85
    local room = left - 16 - (right + 20 + labelW + 6) - 2 * 4
    local w = math.max(80, math.min(sb.realW or 140, math.floor(room / 3)))
    sb.tabW = w
end
function S:UpdateSpecButtons()
    if not specButtons then return end
    fitRow()
    local cur, notPicked = self:CurrentSpec()
    local open = (UnitLevel("player") or 0) >= self.TALENTS_AT
    local chosen = (open and not notPicked) and cur or nil
    for _, b in ipairs(specButtons) do
        local mine = b.spec == chosen
        b.picked = mine
        b.state = not open and "off" or (mine and "mine") or (chosen and "other") or "open"
        setLabel(b, mine and (b.spec .. " " .. CHECK) or b.spec)
        if specButtons.tabW then b:SetSize(specButtons.tabW, specButtons.tabH) end
        if b.SetTabSelected then pcall(b.SetTabSelected, b, mine) end
        b:SetEnabled(open and not mine)
        if b.state == "mine" then fontFor(b, "GameFontHighlight")
        elseif b.state == "open" then fontFor(b, "GameFontNormal")
        else fontFor(b, "GameFontDisable") end
    end
    local label = specButtons.label
    if label then
        if not open then label:SetText("Spec at " .. self.TALENTS_AT .. ":")
        elseif chosen then label:SetText("Your spec:")
        else label:SetText("Pick a spec:") end
    end
    if specButtons.holder then
        local w = 0
        for i, b in ipairs(specButtons) do w = w + (b:GetWidth() or 0) + (i > 1 and 4 or 0) end
        if w > 0 then specButtons.holder:SetWidth(w) end
    end
end
local function makeTab(holder, tabs)
    -- the tab row's own template first, then Blizzard's shared tab template, then a plain Blizzard button
    for _, tpl in ipairs({ tabs and tabs.tabTemplate, "TabSystemButtonTemplate", "UIPanelButtonTemplate" }) do
        if type(tpl) == "string" then
            local ok, b = pcall(CreateFrame, "Button", nil, holder, tpl)
            if ok and b then return b, tpl end
        end
    end
end
local function makeSpecButtons()
    if specButtons then S:UpdateSpecButtons() return end
    local win = _G.PlayerSpellsFrame or _G.ClassTalentFrame or _G.PlayerTalentFrame
    local page = talentWindow() or win
    win = win or page
    if not page or not CreateFrame then return end
    local tabs = page.TabSystem
    -- the window's border and title art sit far above the talents page (5500 vs 100), so the strip is lifted above
    -- every part of it; it still rides on the talents page and hides with it
    local holder = CreateFrame("Frame", nil, page)
    local top = 0
    for _, part in ipairs({ win, page, win.NineSlice, win.TitleContainer, win.Border, win.TitleBar, page.SearchBox, tabs }) do
        if type(part) == "table" and part.GetFrameLevel then
            local ok, lv = pcall(part.GetFrameLevel, part)
            if ok and type(lv) == "number" and lv > top then top = lv end
        end
    end
    holder:SetFrameLevel(top + 20)
    holder:SetSize(3 * 140, 24)
    local label = holder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specButtons = { holder = holder, label = label }
    local search = page.SearchBox or win.SearchBox
    local anchor
    -- the size of the window's own tabs (Primary), so ours match it; in game 2026-11-12 the template on its own came
    -- out about 28 px wide, three tabs piled on top of each other
    local real
    if type(tabs) == "table" then
        if type(tabs.tabs) == "table" then real = tabs.tabs[1] end
        if not real and tabs.GetChildren then
            for _, c in ipairs({ tabs:GetChildren() }) do
                if type(c) == "table" and c.GetObjectType and c:GetObjectType() == "Button" then real = c break end
            end
        end
    end
    local rw, rh = real and real.GetWidth and real:GetWidth(), real and real.GetHeight and real:GetHeight()
    specButtons.realW = (type(rw) == "number" and rw > 60) and rw or 140
    specButtons.tabW = specButtons.realW
    specButtons.tabs, specButtons.search = tabs, page.SearchBox or win.SearchBox
    specButtons.tabH = (type(rh) == "number" and rh > 12) and rh or 24
    if type(tabs) == "table" and tabs.GetObjectType then
        -- on the tab row, after Primary / Secondary: "Your spec:" then the three tabs, bottoms in line with theirs
        label:SetWidth(85)
        if label.SetJustifyH then label:SetJustifyH("RIGHT") end
        label:SetPoint("LEFT", tabs, "RIGHT", 20, 0)
        holder:SetPoint("BOTTOMLEFT", tabs, "BOTTOMRIGHT", 20 + 85 + 6, 0)
        anchor = "tab row"
    elseif type(search) == "table" and search.GetObjectType then
        holder:SetPoint("RIGHT", search, "LEFT", -24, 0)
        label:SetPoint("RIGHT", holder, "LEFT", -8, 0)
        anchor = "search box"
    else
        local h = win.GetHeight and win:GetHeight() or 0
        holder:SetPoint("TOP", win, "TOP", 0, -math.max(30, (h or 0) * 0.088))
        label:SetPoint("RIGHT", holder, "LEFT", -8, 0)
        anchor = "window top"
    end
    local prev, used
    for i, name in ipairs(S:ClassSpecs()) do
        local b, tpl = makeTab(holder, tabs)
        if not b then return end
        used = tpl
        b.spec, b.tabID = name, i
        setLabel(b, name)
        b:SetSize(specButtons.tabW, specButtons.tabH)
        if i == 1 then b:SetPoint("BOTTOMLEFT", holder, "BOTTOMLEFT", 0, 0) else b:SetPoint("LEFT", prev, "RIGHT", 4, 0) end
        -- our own click and tooltip: the template's would ask a tab system that isn't there
        b:SetScript("OnClick", function(self) S:PickSpec(self.spec) end)
        b:SetScript("OnEnter", function(self)
            if not GameTooltip then return end
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText("Steward: " .. self.spec)
            GameTooltip:AddLine("Follow Wowhead's leveling build, rotation, stat weights and action bars for " .. self.spec .. ".", 1, 1, 1, true)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
        prev = b
        specButtons[#specButtons + 1] = b
    end
    S.SpecButtons, S.SpecButtonStrip = specButtons, holder
    if StewardCharDB then
        StewardCharDB.specButtons = { window = win.GetName and win:GetName() or "?", level = top + 20, anchor = anchor,
            template = used }
    end
    if page.HookScript then page:HookScript("OnShow", function() S:UpdateSpecButtons() end) end
    if win.HookScript then win:HookScript("OnHide", function() queue(0.5) end) end -- spend the points for the spec you picked
    S:UpdateSpecButtons()
end
S.MakeSpecButtons = makeSpecButtons
S:On("ADDON_LOADED", function(name)
    if name == "Blizzard_PlayerSpells" or name == "Blizzard_ClassTalentUI" or name == "Blizzard_TalentUI" then
        C_Timer.After(0, function()
            local ok, err = pcall(makeSpecButtons)
            if not ok then S:LogError("specbuttons", err) end
        end)
    end
end)

S:On("PLAYER_ENTERING_WORLD", function()
    queue(6)
    if talentWindow() then
        C_Timer.After(1, function()
            local ok, err = pcall(makeSpecButtons)
            if not ok then S:LogError("specbuttons", err) end
        end)
    end
end)
S:On("PLAYER_LEVEL_UP", function() queue(2) end)
S:On("CHARACTER_POINTS_CHANGED", function() queue(1) end)
S:On("TRAIT_TREE_CURRENCY_INFO_UPDATED", function() queue(1) end)
S:On("PLAYER_REGEN_ENABLED", function() queue(2) end)
