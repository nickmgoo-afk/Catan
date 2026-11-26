local _, S = ...

-- Rotation helper. In combat, a short strip of icons above the bars says what to press
-- next (big icon) and what comes after; the button on your bars that holds it lights up
-- with the game's own rotation-helper glow. It only reads your spellbook, auras, power and
-- cooldowns: it never casts anything for you.

-- Rules, best first. Conditions:
--   dot      skip while your debuff of that name is on the target (with more than 2s left)
--   nobuff   skip while you have a buff matching this ("Seal of *")
--   has      only while you have a buff matching this
--   hp       only when the target is below this % health
--   combo    only with at least this many combo points
--   rage     only with at least this much rage (or energy)
--   manaBelow / manaAbove   your mana as a share of max
--   types    only against these creature types; notypes = never against these
--   totem    only when that totem slot is empty (1 fire, 2 earth, 3 water, 4 air); a totem chosen earlier in the
--            list fills its slot, and while the game hides totems, one you've put there this fight counts
--   totemUp  only while a totem stands in that slot (Fire Nova goes out from your fire totem)
--   noimbue  only when your main-hand weapon has no temporary enchant
--   stacks   only while your debuff has fewer stacks than this
--   talent   only once you have this talent
--   twoHand  only with a two-handed weapon
--   debuff / nodebuff   only while / skip while your debuff of that name is on the target
--   thpAbove only while the target is at or above this % health (unknown counts as above)
--   ready    only when that other spell is off cooldown (within 1.5 s)
--   swings   only after about this many of your swings since you put your current seal up (or the fight began)
--   pack     only with at least this many enemies in the fight (counted from enemy nameplates)
--   selfBelow only while your own health is under this % (unknown counts as under)
--   hurt     only while your own health is known to be under this % (unknown: no; for heals like Renew)
--   rageBelow only with less rage than this (unknown counts as less)
--   maxLevel only up to this character level
--   frozen   only on a frozen target (your Frost Nova or Frostbite on it) or with Fingers of Frost; orStacks = { debuff, n }
--            also lets it through at n stacks of that debuff
--   close    only when the target is within about 10 yards (when the game will say)
--   noRepeat skip while it's already repeating (wand Shoot) or queued (Heroic Strike, Maul)
--   every    not again on the same target within this many seconds (your last cast of it on any target, when the
--            game won't say which target is which)
--   petsTarget      only while your demon attacks your target (no demon, or one that isn't attacking: no; the game
--                   won't say: yes)
--   petsTargetIfOut skip while your demon attacks a mob other than your target (a feared one)
--   groupPackBelow  in a group, only with fewer than this many enemies in the fight (dungeon packs)
--   after    only once the fight is at least this many seconds old
local BLEEDPROOF = { Elemental = true, Mechanical = true }
local JOTC = "Judgement of the Crusader"
local ROT = {
    PALADIN = {
        -- Wowhead's Forever Retribution leveling rotation (Nick chose it over his own table on 2026-11-12): judge Seal
        -- of the Crusader on enemies that will live more than a few seconds ("elites or bosses"), then keep Seal of
        -- Command up (Seal of Righteousness before 20); Judgement; Hammer of Wrath under 20%; Holy Strike (refreshes
        -- your Judgements); Unsealed Wrath: at 2-3 stacks "based on enemy health" (Steward: 3 swings on a mob above
        -- half health, 2 below) switch to Seal of Righteousness, and back to Command after the next swing; Exorcism on
        -- Undead and Demons; Consecration only "if AoE damage is desperately needed and mana permits" (Steward: three
        -- or more enemies and over half your mana).
        Retribution = {
            { "Seal of the Crusader", elite = true, nodebuff = JOTC, nobuff = "Seal of the Crusader", ready = "Judgement" },
            { "Seal of Command", has = "Seal of the Crusader", debuff = JOTC },
            { "Seal of Command", nobuff = "Seal of *" }, { "Seal of Righteousness", nobuff = "Seal of *" },
            { "Seal of Command", has = "Seal of Righteousness", notalent = "Unsealed Wrath" },
            { "Judgement", has = "Seal of *" }, { "Hammer of Wrath", hp = 20 }, { "Holy Strike" },
            { "Seal of Righteousness", talent = "Unsealed Wrath", has = "Seal of Command", swings = 3, thpAbove = 50 },
            { "Seal of Righteousness", talent = "Unsealed Wrath", has = "Seal of Command", swings = 2, hp = 50 },
            { "Seal of Command", talent = "Unsealed Wrath", has = "Seal of Righteousness", swings = 1 },
            { "Exorcism", types = { Undead = true, Demon = true } },
            { "Consecration", pack = 3, manaAbove = 0.5 } },
        -- Wowhead's Forever Protection leveling rotation: Seal of the Crusader for the first Judgement on a mob that
        -- will live a while (Steward: above 90% health), then keep Seal of Fury up; Judgement; Consecration "if mana
        -- allows" (Steward: above 40%); Holy Shield; Holy Strike; Exorcism on Undead and Demons; Hammer of Wrath
        -- when tanking 0-1 targets. Holy Wrath "if you're not actively tanking" is left out: Steward can't tell.
        Protection = { { "Seal of the Crusader", nodebuff = JOTC, nobuff = "Seal of *", ready = "Judgement", thpAbove = 90 },
            { "Seal of Fury", has = "Seal of the Crusader", debuff = JOTC }, { "Seal of Fury", nobuff = "Seal of *" },
            { "Seal of Fury", has = "Seal of Righteousness" },
            { "Seal of Righteousness", nobuff = "Seal of *" }, { "Judgement", has = "Seal of *" },
            { "Consecration", manaAbove = 0.4 }, { "Holy Shield", nobuff = "Holy Shield" }, { "Holy Strike" },
            { "Exorcism", types = { Undead = true, Demon = true } }, { "Hammer of Wrath", hp = 20, packBelow = 2 } },
        -- Wowhead's Forever Holy damage rotation (questing): Seal of Righteousness, Judgement, Holy Strike, Exorcism on
        -- Undead and Demons, Holy Shock, Consecration.
        Holy = { { "Seal of Righteousness", nobuff = "Seal of *" }, { "Judgement", has = "Seal of *" }, { "Holy Strike" },
            { "Exorcism", types = { Undead = true, Demon = true } }, { "Holy Shock" }, { "Consecration" } },
    },
    WARRIOR = {
        -- Wowhead's Forever leveling guides (read 2026-11-12). Battle Shout is upkeep and not part of their lists.
        -- Arms: Victory Rush under 90% health, keep Rend up, Overpower, Mortal Strike, Slam once Improved Slam is
        -- taken, Thunder Clap, Sunder Armor, Heroic Strike above 40 rage. No Execute while leveling (save the rage).
        Arms = { { "Battle Shout", nobuff = "Battle Shout" }, { "Victory Rush", selfBelow = 90 },
            { "Rend", dot = true, notypes = BLEEDPROOF }, { "Overpower" }, { "Mortal Strike" },
            { "Slam", talent = "Improved Slam" }, { "Thunder Clap", dot = true }, { "Sunder Armor", stacks = 5 },
            { "Heroic Strike", rage = 40, noRepeat = true } },
        -- Fury: Sunder Armor kept up on bosses, Charge to engage, Bloodthirst, Victory Rush, Overpower, Bloodrage or Berserker Rage when Gore Drinker is not up,
        -- Demoralizing Shout, Whirlwind, Rend on a mob that will live through it, Execute to finish when short of rage.
        Fury = { { "Sunder Armor", stacks = 5, boss = true }, { "Charge" }, { "Battle Shout", nobuff = "Battle Shout" },
            { "Bloodthirst" }, { "Victory Rush" }, { "Overpower" },
            { "Bloodrage", talent = "Gore Drinker", nobuff = "Gore Drinker" },
            { "Berserker Rage", talent = "Gore Drinker", nobuff = "Gore Drinker" },
            { "Demoralizing Shout", dot = true }, { "Whirlwind" },
            { "Rend", dot = true, notypes = BLEEDPROOF, thpAbove = 50 }, { "Execute", hp = 20, rageBelow = 20 } },
        -- Wowhead's Forever Protection leveling rotation (single target). Rend "if you're already high on threat"
        -- is left out: Steward cannot see threat.
        Protection = { { "Shield Block", nobuff = "Shield Block" }, { "Revenge" }, { "Shield Slam" }, { "Bloodthirst" },
            { "Sunder Armor", stacks = 5, group = true }, { "Thunder Clap", dot = true },
            { "Battle Shout", nobuff = "Battle Shout" }, { "Demoralizing Shout", dot = true },
            { "Sunder Armor", filler = true }, { "Heroic Strike", rage = 30, noRepeat = true } },
    },
    -- Wowhead's Forever leveling rotations: open with Ambush (Assassination, Subtlety), spam Sinister Strike
    -- (Subtlety: Hemorrhage once you have it), Eviscerate when the enemy is close to death (Steward: under 30%),
    -- Slice and Dice when another mob is nearby. Assassination's own builder is shown on Wowhead only as
    -- "Spell #1310707", so Steward keeps Sinister Strike for it.
    ROGUE = {
        Assassination = { { "Ambush" }, { "Eviscerate", combo = 1, hp = 30 },
            { "Slice and Dice", combo = 1, nobuff = "Slice and Dice", pack = 2 }, { "Sinister Strike" } },
        -- Combat: Riposte is "the bread and butter for Combat Rogues while leveling" (the guide's talent text): off
        -- the global cooldown, cheap, usable only after you parry, so it goes first whenever the game allows it.
        Combat = { { "Riposte" }, { "Eviscerate", combo = 1, hp = 30 },
            { "Slice and Dice", combo = 1, nobuff = "Slice and Dice", pack = 2 }, { "Sinister Strike" } },
        Subtlety = { { "Ambush" }, { "Eviscerate", combo = 1, hp = 30 },
            { "Slice and Dice", combo = 1, nobuff = "Slice and Dice", pack = 2 }, { "Hemorrhage" },
            { "Sinister Strike", notalent = "Hemorrhage" } },
    },
    -- Wowhead's Forever leveling rotations. Beast Mastery and Marksmanship: Hunter's Mark, Serpent Sting, Summon Hawk
    -- when talented, Arcane Shot (with Summon Hawk "only every third rotation": Steward puts it after Aimed Shot),
    -- Aimed Shot. Survival ("full melee"): Hunter's Mark, Raptor Strike queued, Mongoose Bite, Strider Kick,
    -- Immolation Trap, Summon Hawk.
    HUNTER = {
        -- Beast Mastery and Marksmanship (identical leveling pages, read again 2026-11-12). Single target: Hunter's Mark,
        -- Serpent Sting, Summon Hawk when talented, Arcane Shot (with Summon Hawk only every third time), Aimed Shot.
        -- AoE tab: Multi-Shot ("4 or fewer targets" once you have Volley), Explosive Trap when they're on you ("not if
        -- mana is an issue": Steward, over 40% mana), Volley (Steward: 5 or more enemies).
        ["Beast Mastery"] = { { "Hunter's Mark", dot = true }, { "Volley", pack = 5 }, { "Multi-Shot", pack = 2 },
            { "Explosive Trap", pack = 2, close = true, manaAbove = 0.4 },
            { "Serpent Sting", dot = true, notypes = BLEEDPROOF },
            { "Summon Hawk" }, { "Arcane Shot", notalent = "Summon Hawk" }, { "Aimed Shot" },
            { "Arcane Shot", talent = "Summon Hawk" } },
        Marksmanship = { { "Hunter's Mark", dot = true }, { "Volley", pack = 5 }, { "Multi-Shot", pack = 2 },
            { "Explosive Trap", pack = 2, close = true, manaAbove = 0.4 },
            { "Serpent Sting", dot = true, notypes = BLEEDPROOF },
            { "Summon Hawk" }, { "Arcane Shot", notalent = "Summon Hawk" }, { "Aimed Shot" },
            { "Arcane Shot", talent = "Summon Hawk" } },
        -- Survival ("Full Melee" tab): Hunter's Mark, Raptor Strike queued, Mongoose Bite, Strider Kick, Immolation
        -- Trap, Summon Hawk. Its AoE tab is ranged ("Multi-Shot when at range"), so it isn't added to the melee list.
        Survival = { { "Hunter's Mark", dot = true }, { "Raptor Strike", noRepeat = true }, { "Mongoose Bite" },
            { "Strider Kick" }, { "Immolation Trap" }, { "Summon Hawk" } },
    },
    MAGE = {
        -- Wowhead's Forever Frost leveling guide (read 2026-11-12). 1-19: Frostbolt, Fire Blast to finish, Frost Nova
        -- when it gets close and is not nearly dead, wand when out of mana or to finish. From 20: Ice Lance on a frozen
        -- target or with Fingers of Frost, and no more Fire Blast. From 26: Cone of Cold on a frozen target, with
        -- Fingers of Frost or at 3 Winter's Chill.
        Frost = { { "Shoot", manaBelow = 0.1, noRepeat = true }, { "Ice Lance", frozen = true },
            { "Cone of Cold", frozen = true, orStacks = { "Winter's Chill", 3 } },
            { "Fire Blast", hp = 25, maxLevel = 19 }, { "Fire Blast", close = true, maxLevel = 19 },
            { "Frost Nova", close = true, thpAbove = 25, nodebuff = "Frost Nova" },
            { "Cone of Cold", close = true, nodebuff = "Frost Nova" },
            { "Shoot", hp = 10, noRepeat = true }, { "Frostbolt", filler = true }, { "Fireball", filler = true } },
        -- Wowhead's Forever Fire leveling rotation: Pyroblast at 3 Heating Up, Fire Blast with Heating Up or on the move, Arcane
        -- Missiles on Missile Barrage, Fireball.
        Fire = { { "Shoot", manaBelow = 0.1, noRepeat = true }, { "Pyroblast", selfStacks = { "Heating Up", 3 } },
            { "Fire Blast", has = "Heating Up" }, { "Fire Blast", moving = true }, { "Arcane Missiles", has = "Missile Barrage" },
            { "Fireball", filler = true }, { "Frostbolt", filler = true } },
        -- Wowhead's Forever Arcane leveling rotation: to 21 pull with Frostbolt, Arcane Missiles, Frost Nova to make
        -- distance, wand to finish;
        -- from 21 Arcane Missiles on Missile Barrage, Arcane Wrath (26), Arcane Blast to 2 stacks, then plain Arcane
        -- Missiles; Fire Blast on cooldown "if mana allows" (Steward reads that as above 40% mana), "especially when you
        -- have to move".
        Arcane = { { "Shoot", manaBelow = 0.1, noRepeat = true }, { "Frostbolt", nodebuff = "Frostbolt", maxLevel = 20 },
            { "Frost Nova", close = true, thpAbove = 25, nodebuff = "Frost Nova", maxLevel = 20 },
            { "Arcane Missiles", has = "Missile Barrage" }, { "Arcane Wrath" }, { "Fire Blast", moving = true },
            { "Fire Blast", manaAbove = 0.4 },
            { "Arcane Blast", selfStacksBelow = { "Arcane Blast", 2 } }, { "Shoot", hp = 10, noRepeat = true },
            { "Arcane Missiles", filler = true }, { "Frostbolt", filler = true } },
    },
    -- Wowhead's Forever leveling rotations (pages read again 2026-11-13). Shadow: open with Mind Blast, Shadow Word:
    -- Pain, Devouring Plague (mana-hungry before Devouring Contagion: Steward then wants half your mana), Mind Flay if
    -- mana permits (Steward: above 30%), finish with the wand; on "higher Health enemies, like bosses" Mind Blast on
    -- cooldown (Steward: elites). Holy (solo): open with Mind Blast (Holy Fire from 20), Shadow Word: Pain, Smite if
    -- the mob still has a lot of health, wand; skip the DoT on a nearly dead mob; Renew on yourself "if you are taking
    -- hits" (Steward: under 80% health). Discipline: to 40 open with Penance (from 30) or Shadow Word: Pain, then the
    -- wand, Shadow Word: Pain again only on mobs with "a lot of health" (Steward: elites); from 41 Holy Fire, Penance,
    -- Smite while Penance cools down; Renew "if worried about your health" (Steward: under half). Not shown, because the
    -- helper only shows in combat: Power Word: Shield before the pull (all three pages). Not followed, because Steward
    -- can't see other players: Shadow Word: Pain to open where the area is crowded (Discipline).
    PRIEST = {
        Shadow = { { "Shoot", manaBelow = 0.1, noRepeat = true }, { "Mind Blast", thpAbove = 90 },
            { "Mind Blast", elite = true }, { "Shadow Word: Pain", dot = true, thpAbove = 25 },
            { "Devouring Plague", dot = true, thpAbove = 25, talent = "Devouring Contagion" },
            { "Devouring Plague", dot = true, thpAbove = 25, notalent = "Devouring Contagion", manaAbove = 0.5 },
            { "Shoot", hp = 25, noRepeat = true }, { "Mind Flay", manaAbove = 0.3, filler = true },
            { "Shoot", noRepeat = true } },
        Holy = { { "Shoot", manaBelow = 0.1, noRepeat = true }, { "Renew", hurt = 80, nobuff = "Renew" },
            { "Holy Fire", thpAbove = 90 },
            { "Mind Blast", thpAbove = 90, maxLevel = 19 }, { "Shadow Word: Pain", dot = true, thpAbove = 30 },
            { "Smite", thpAbove = 50 }, { "Mind Blast", thpAbove = 50 }, { "Shoot", noRepeat = true } },
        Discipline = { { "Shoot", manaBelow = 0.1, noRepeat = true }, { "Renew", hurt = 50, nobuff = "Renew" },
            { "Holy Fire", nodebuff = "Holy Fire", thpAbove = 25, minLevel = 41 }, { "Penance", minLevel = 41 },
            { "Penance", thpAbove = 90, maxLevel = 40 }, { "Shadow Word: Pain", dot = true, thpAbove = 90, maxLevel = 40 },
            { "Shadow Word: Pain", dot = true, elite = true, thpAbove = 25, maxLevel = 40 },
            { "Smite", filler = true, minLevel = 41 }, { "Shoot", noRepeat = true } },
    },
    -- Wowhead's Forever leveling rotations (the demon tanks; pages read again 2026-11-13, all tabs). DoTs by how long
    -- the mob lives: Curse of the Elements first from 40, Corruption, Bane of Agony if it lives long enough (Steward:
    -- above 50%), Immolate on mobs with a lot of health (Steward: elites). Filler: wand or Drain Life before 30 (only the
    -- wand for Demonology), Drain Life from 30; finish with the wand (Steward: under 20%); Life Tap when low on mana and
    -- high on health. Affliction: Siphon Life, and Wrack on pulls started near full health and mana; with Nightfall,
    -- Shadow Trance's instant Shadow Bolt (the talent's text). Demonology: Searing Pain on your demon's target to keep
    -- Demonic Brand up ("A brand on the feared mob is wasted"; used up after 6 demon attacks, Steward: every 12 seconds
    -- on that mob). Destruction: Immolate on every mob, but not to open ("give the demon a second to build threat":
    -- Steward, one second into the fight), Conflagrate after Immolate's second-to-last tick or earlier if it kills the
    -- mob (Steward: under 10%, as for Shadowburn), Shadowburn to finish, Corruption only on long-lived mobs, Shadow Bolt
    -- with mana to spare (above 60%); Conflagrate and Shadow Bolt only on the mob your demon tanks (they break Fear).
    -- AoE tabs, "on dungeon trash packs, with a tank holding the mobs" (in a group, three or more enemies): Corruption
    -- (Affliction) or Bane of Agony (the others) on every mob, then Hellfire; Demonology skips the brand there. Not
    -- followed: DoTs on several mobs and the Fear juggle (the helper only sees your target).
    WARLOCK = {
        Affliction = { { "Life Tap", manaBelow = 0.25, hpAbove = 0.6 }, { "Shoot", hp = 20, noRepeat = true },
            { "Corruption", dot = true, group = true, pack = 3 }, { "Hellfire", group = true, pack = 3 },
            { "Shadow Bolt", has = "Shadow Trance", talent = "Nightfall", petsTargetIfOut = true },
            { "Curse of the Elements", dot = true, minLevel = 40, thpAbove = 20 }, { "Corruption", dot = true, thpAbove = 20 },
            { "Bane of Agony", dot = true, thpAbove = 50 }, { "Immolate", dot = true, elite = true, thpAbove = 20 },
            { "Siphon Life", dot = true, thpAbove = 20 }, { "Wrack", manaAbove = 0.8, hpAbove = 0.8 },
            { "Drain Life", minLevel = 30, filler = true }, { "Shoot", noRepeat = true }, { "Drain Life", filler = true } },
        Demonology = { { "Life Tap", manaBelow = 0.25, hpAbove = 0.6 }, { "Shoot", hp = 20, noRepeat = true },
            { "Bane of Agony", dot = true, group = true, pack = 3 }, { "Hellfire", group = true, pack = 3 },
            { "Searing Pain", talent = "Demonic Brand", every = 12, petsTarget = true, groupPackBelow = 3 },
            { "Curse of the Elements", dot = true, minLevel = 40, thpAbove = 20 }, { "Corruption", dot = true, thpAbove = 20 },
            { "Bane of Agony", dot = true, thpAbove = 50 }, { "Immolate", dot = true, elite = true, thpAbove = 20 },
            { "Drain Life", minLevel = 30, filler = true }, { "Shoot", noRepeat = true } },
        Destruction = { { "Life Tap", manaBelow = 0.25, hpAbove = 0.6 }, { "Shadowburn", hp = 10 },
            { "Conflagrate", hp = 10, debuff = "Immolate", petsTargetIfOut = true },
            { "Shoot", hp = 20, noRepeat = true },
            { "Bane of Agony", dot = true, group = true, pack = 3 }, { "Hellfire", group = true, pack = 3 },
            { "Curse of the Elements", dot = true, minLevel = 40, thpAbove = 20 },
            { "Conflagrate", debuffBelow = { "Immolate", 4 }, petsTargetIfOut = true },
            { "Immolate", dot = true, thpAbove = 20, after = 1 },
            { "Bane of Agony", dot = true, thpAbove = 50 }, { "Corruption", dot = true, elite = true, thpAbove = 20 },
            { "Shadow Bolt", manaAbove = 0.6, filler = true, petsTargetIfOut = true },
            { "Drain Life", minLevel = 30, filler = true }, { "Shoot", noRepeat = true }, { "Drain Life", filler = true } },
    },
    -- Wowhead's Forever leveling rotations (pages read again 2026-11-13; both tabs). Elemental: weapon imbue,
    -- Lightning or Water Shield, the buff totems (Strength of Earth, Windfury), Searing Totem, Stormstrike if
    -- talented, Flame Shock, Lightning Mastery, Chain Lightning while Lightning Mastery is not up and with Clearcasting
    -- or mana to spare (Steward: above 60%), Lightning Bolt (True Elemental), Earth Shock / Frost Shock. Its AoE tab:
    -- Magma Totem, Fire Nova, Stormstrike, Lightning Mastery, Chain Lightning, then Flame Shock. Enhancement: Flame
    -- Shock, Stormstrike, Earth Shock, Lightning Shield; shocks only while mana allows (Steward: above 30%); AoE: a fire
    -- totem (Magma once you know it), Fire Nova, Flame Shock. Restoration: imbue, shield, the buff totems "for your
    -- party", Searing Totem; AoE: Magma Totem and Fire Nova "if you can afford the Mana" (Steward: above half). Its
    -- heals (Riptide and Healing Wave on the most damaged ally, Chain Heal) are for the party: the helper follows your
    -- enemy target and leaves them to you; under the totems it keeps the old shocks and bolt, which the page doesn't
    -- rank. AoE here means three or more enemies. Not followed: Flame Shock on several enemies (the helper only sees
    -- your target).
    SHAMAN = {
        Elemental = { { "Flametongue Weapon", noimbue = true }, { "Water Shield", nobuff = "* Shield" },
            { "Lightning Shield", nobuff = "* Shield" }, { "Strength of Earth Totem", totem = 2 },
            { "Windfury Totem", totem = 4 }, { "Magma Totem", totem = 1, pack = 3 }, { "Fire Nova", totemUp = 1, pack = 3 },
            { "Searing Totem", totem = 1 }, { "Stormstrike" }, { "Flame Shock", dot = true, thpAbove = 25, packBelow = 3 },
            { "Lightning Mastery", nobuff = "Lightning Mastery" },
            { "Chain Lightning", nobuff = "Lightning Mastery", manaAbove = 0.6, orHas = "Clearcasting" },
            { "Flame Shock", dot = true, thpAbove = 25, pack = 3 },
            { "Lightning Bolt", filler = true }, { "Earth Shock" }, { "Frost Shock" } },
        Enhancement = { { "Windfury Weapon", noimbue = true }, { "Rockbiter Weapon", noimbue = true },
            { "Lightning Shield", nobuff = "Lightning Shield" }, { "Magma Totem", totem = 1, pack = 3 },
            { "Searing Totem", totem = 1, pack = 3 }, { "Fire Nova", totemUp = 1, pack = 3 },
            { "Flame Shock", dot = true, thpAbove = 25, manaAbove = 0.3 }, { "Stormstrike" },
            { "Earth Shock", manaAbove = 0.3 } },
        Restoration = { { "Flametongue Weapon", noimbue = true }, { "Water Shield", nobuff = "* Shield" },
            { "Lightning Shield", nobuff = "* Shield" }, { "Strength of Earth Totem", totem = 2 },
            { "Windfury Totem", totem = 4 }, { "Magma Totem", totem = 1, pack = 3, manaAbove = 0.5 },
            { "Fire Nova", totemUp = 1, pack = 3, manaAbove = 0.5 }, { "Searing Totem", totem = 1 },
            { "Flame Shock", dot = true }, { "Earth Shock", manaAbove = 0.5 }, { "Lightning Bolt" } },
    },
    -- Wowhead's Forever leveling rotations. Feral (Cat): Rake, 5-point Rip, Shred or Claw with Clearcasting, Ferocious Bite on
    -- a dying mob with more than 3 combo points (Steward: under 10%), Shifting Power "if no Energy will be wasted"
    -- (the AoE tab: below 50 Energy), Shred, Claw; the caster spells
    -- below cover the levels before Cat Form. In Bear Form (Wowhead's Feral tank leveling guide): Demoralizing Roar,
    -- Primal Bite, Swipe on two or more enemies, Maul; its Faerie Fire pull happens before combat, where the helper
    -- doesn't show. Restoration (solo): Thorns on yourself, Moonfire, Insect Swarm if talented, Entangling Roots,
    -- Wrath; Rejuvenation on yourself if enemies reach you.
    DRUID = {
        -- Balance (Wowhead's leveling page, both rotation tabs): Thorns on yourself at all times. Packs ("the best way to
        -- level"): Insect Swarm then Moonfire on each enemy; before 40 in Bear Form Demoralizing Roar and Swipe; from 40
        -- Hurricane, "mana efficient on 4 to 5 enemies". Single target: root with Entangling Roots, Wrath; with Eclipse,
        -- Insect Swarm and Moonfire (only for a full duration: Steward wants the mob above 40%), Starfire on Eclipse.
        Balance = { { "Thorns", nobuff = "Thorns" },
            { "Demoralizing Roar", dot = true, has = "*Bear Form" }, { "Swipe", has = "*Bear Form" },
            { "Entangling Roots", nodebuff = "Entangling Roots", thpAbove = 25, packBelow = 2 },
            { "Insect Swarm", dot = true, pack = 2, thpAbove = 40 }, { "Moonfire", dot = true, pack = 2, thpAbove = 40 },
            { "Hurricane", pack = 4 },
            { "Insect Swarm", dot = true, talent = "Eclipse", thpAbove = 40 }, { "Moonfire", dot = true, talent = "Eclipse", thpAbove = 40 },
            { "Starfire", talent = "Eclipse", has = "Eclipse*" }, { "Wrath", filler = true } },
        Feral = { { "Rake", dot = true, thpAbove = 25 }, { "Rip", dot = true, combo = 5, thpAbove = 25 },
            { "Shred", has = "Clearcasting" }, { "Claw", has = "Clearcasting" }, { "Ferocious Bite", combo = 4, hp = 10 },
            { "Shifting Power", powerBelow = 50 }, { "Shred" }, { "Claw" },
            { "Demoralizing Roar", dot = true, has = "*Bear Form" }, { "Primal Bite", has = "*Bear Form" },
            { "Swipe", pack = 2, has = "*Bear Form" }, { "Maul", noRepeat = true, has = "*Bear Form" },
            { "Moonfire", dot = true }, { "Wrath", filler = true } },
        Restoration = { { "Thorns", nobuff = "Thorns" }, { "Moonfire", dot = true }, { "Insect Swarm", dot = true },
            { "Entangling Roots", nodebuff = "Entangling Roots", thpAbove = 25 },
            { "Rejuvenation", close = true, nobuff = "Rejuvenation" }, { "Wrath", filler = true } },
    },
}
S.ROTATIONS = ROT

---------------------------------------------------------------- what you know
local known, knownAt = nil, -100
local function knownSpells()
    if known and GetTime() - knownAt < 30 then return known end
    known = {}
    local book = S.ReadSpellbook and S.ReadSpellbook() or {}
    for name, e in pairs(book) do
        if e.kind == "spell" then known[name] = e.id end
    end
    knownAt = GetTime()
    return known
end
S:On("SPELLS_CHANGED", function() known = nil end)
S:On("UNIT_AURA", function(unit)
    if unit == "player" and S.RotationRefresh and not UnitAffectingCombat("player") then pcall(S.RotationRefresh) end
end)
S:On("LEARNED_SPELL_IN_SKILL_LINE", function() known = nil end)

local function formKey()
    if S:PlayerClass() ~= "DRUID" or not GetShapeshiftFormID then return nil end
    local id = GetShapeshiftFormID()
    if id == 1 then return "cat" end
    if id == 5 or id == 8 then return "bear" end
    return nil
end

function S:RotationRules()
    local class = self:PlayerClass()
    local data = ROT[class]
    if not data then return {} end
    local form = formKey()
    if form and data[form] then return data[form] end
    local spec = self:CurrentSpec()
    if data[spec] then
        return data[spec]
    end
    for _, rules in pairs(data) do return rules end
    return {}
end

---------------------------------------------------------------- reading the fight
local function secret(...) return S.Secret and S.Secret(...) end

local function patternMatch(name, pattern)
    if S.SpellPatternMatches then return S.SpellPatternMatches(name, pattern) end
    return name == pattern
end

-- buffs assumed up for the rest of the list once the spell that gives them is chosen
local assumed = {}
local assumedSeal    -- the seal chosen earlier in the list: it replaces whichever seal is up
local assumedTotem = {} -- [slot] = true once a totem for that slot is chosen earlier in the list
local totemSlotOf = {}  -- [spell] = the slot it fills, from the rules in use (their "totem")

-- In combat WoW: Forever hides buffs and debuffs from addons (reading them raises an error).
-- So Steward remembers what it last saw out of combat, and what you've cast since, and goes
-- by that while the game won't say.
local seen = {}      -- [buff name] = expiration time (math.huge = doesn't run out), last time it was readable
local seenAt = 0     -- when that was
local casts = {}     -- [spell name] = when you cast it
-- On this game, cooldowns, power and "is it usable" can be hidden from addons during combat.
-- Steward then keeps its own clock: when you last cast each spell, and each spell's cooldown
-- (read out of combat, or the fallback below).
local lastCast = {}  -- [spellID] = when you cast it (kept across fights)
local baseCD = {}    -- [spellID] = cooldown in seconds, read while the game still tells
local lastGCD = 0    -- when your last spell started the global cooldown
local FALLBACK_CD = {
    ["Judgement"] = 10, ["Holy Strike"] = 10, ["Crusader Strike"] = 6, ["Exorcism"] = 15, ["Consecration"] = 8,
    ["Hammer of Wrath"] = 6, ["Hammer of Justice"] = 60, ["Holy Shock"] = 30, ["Holy Shield"] = 10,
    ["Mortal Strike"] = 6, ["Bloodthirst"] = 6, ["Whirlwind"] = 10, ["Overpower"] = 5, ["Shield Slam"] = 6,
    ["Revenge"] = 5, ["Riposte"] = 6, ["Mind Blast"] = 8, ["Fire Blast"] = 8, ["Arcane Shot"] = 6,
    ["Raptor Strike"] = 6, ["Mongoose Bite"] = 5, ["Aimed Shot"] = 6, ["Multi-Shot"] = 10, ["Earth Shock"] = 6,
    ["Flame Shock"] = 6, ["Stormstrike"] = 20, ["Conflagrate"] = 10, ["Chain Lightning"] = 6, ["Holy Fire"] = 0,
}
local hidden = {}    -- which game answers were hidden this session (written to StewardCharDB.rotationProbe)
local manaCost = {}  -- [spellID] = mana it costs, read out of combat
local manaStart, manaMax, manaSpent = nil, nil, 0 -- your mana when the fight began, and what you've cast since
local DURATION = {   -- how long to assume a buff or debuff lasts after you cast it
    ["Seal of *"] = 30, ["Battle Shout"] = 120, ["Slice and Dice"] = 12, ["Holy Shield"] = 10,
    ["Lightning Shield"] = 600, ["Tiger's Fury"] = 6, ["Hunter's Mark"] = 120, ["Curse of Agony"] = 24,
    ["Shadow Word: Pain"] = 18, ["Corruption"] = 15, ["Immolate"] = 15, ["Serpent Sting"] = 15,
    ["Rend"] = 15, ["Moonfire"] = 12, ["Insect Swarm"] = 12, ["Siphon Life"] = 30, ["Flame Shock"] = 12,
    ["Devouring Plague"] = 24, ["Vampiric Embrace"] = 60, ["Rip"] = 12, ["Rake"] = 9,
    ["Demoralizing Shout"] = 30, ["Demoralizing Roar"] = 30, ["Sunder Armor"] = 30,
    ["Frost Nova"] = 8, ["Thunder Clap"] = 10,
    [JOTC] = 40, -- Forever: "judge an enemy for 40 sec ... your melee strikes will refresh the spell's duration" (Wowhead)
}
local function durationOf(name)
    for p, d in pairs(DURATION) do
        if patternMatch(name, p) then return d end
    end
    return 15
end

-- does the game refuse auras right now? On Forever, asking for one the game hides in a fight can raise an error past
-- pcall ("Auras cannot be accessed when secret while tainted by 'Steward'", 16 times in 2 s in Nick's saved data,
-- 2026-11-19), and three errors switched the whole rotation helper off. So: ask as before, but the first such
-- error in a fight stops the asking until the fight ends (then it goes by what it saw and what you cast). Where the
-- game says so up front (C_Secrets), it doesn't ask at all.
local aurasRefused = false
local function aurasHidden()
    if aurasRefused then return true end
    local sec = C_Secrets
    for _, fname in ipairs({ "ShouldAurasBeSecret", "ShouldUnitAurasBeSecret" }) do
        local f = sec and sec[fname]
        if type(f) == "function" then
            local ok, v = pcall(f, "player")
            if ok and v == true then return true end
        end
    end
    return false
end
S:On("PLAYER_REGEN_ENABLED", function() aurasRefused = false end)
S.AurasHidden = aurasHidden

-- your buffs: list of { name, exp }, or nil when the game won't tell right now
local function readPlayerAuras()
    local get = C_UnitAuras and C_UnitAuras.GetAuraDataByIndex
    if not get or aurasHidden() then return nil end
    local ok, list = pcall(function()
        local out = {}
        for i = 1, 40 do
            local a = get("player", i, "HELPFUL")
            if not a then break end
            local n = a.name
            if n == nil or secret(n) then error("secret") end
            local exp = a.expirationTime
            if exp == nil or secret(exp) or exp == 0 then exp = math.huge end
            out[#out + 1] = { name = n, exp = exp }
        end
        return out
    end)
    if not ok then return nil end
    seen = {}
    for _, a in ipairs(list) do seen[a.name] = a.exp end
    seenAt = GetTime()
    return list
end

-- seconds left on a buff matching any of the patterns (math.huge = no end), or nil if you don't have it
local function buffLeftAny(patterns)
    if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then return math.huge end -- can't tell: assume it's up
    local list = readPlayerAuras()
    local now = GetTime()
    if list then
        for _, a in ipairs(list) do
            for _, p in ipairs(patterns) do
                if patternMatch(a.name, p) then return a.exp == math.huge and math.huge or (a.exp - now) end
            end
        end
        return nil
    end
    -- hidden: go by the last look, then by what you've cast since
    local best
    for name, exp in pairs(seen) do
        for _, p in ipairs(patterns) do
            if patternMatch(name, p) and (exp == math.huge or exp > now) then
                local left = exp == math.huge and math.huge or exp - now
                if not best or left > best then best = left end
            end
        end
    end
    for name, at in pairs(casts) do
        for _, p in ipairs(patterns) do
            if patternMatch(name, p) then
                local left = at + durationOf(name) - now
                if left > 0 and (not best or left > best) then best = left end
            end
        end
    end
    return best
end
S.BuffLeft = buffLeftAny

local function playerHas(pattern)
    if assumedSeal and pattern:find("^Seal of ") then return patternMatch(assumedSeal, pattern) end
    if assumed[pattern] then return true end
    return buffLeftAny({ pattern }) ~= nil
end

-- stacks of one of your own auras (Heating Up, Arcane Blast); nil when combat hides them
local chain = { n = 0, at = 0 } -- the same spell cast back to back: a stand-in for hidden stacks
local function selfStacks(name)
    local fn = C_UnitAuras and C_UnitAuras.GetAuraDataBySpellName
    if not fn or aurasHidden() or not readPlayerAuras() then return nil end
    for _, filter in ipairs({ "HELPFUL", "HARMFUL" }) do
        local ok, a = pcall(fn, "player", name, filter)
        if not ok then return nil end
        if a then
            if secret(a.applications) then return nil end
            return math.max(a.applications or 1, 1)
        end
    end
    return 0
end

-- your debuff on the target: seconds left (math.huge if it doesn't run out) and stacks; nil if absent
local targetCasts = {} -- [spell name] = when you cast it on this target
local castOn = {}      -- [target GUID] = { [spell name] = when you cast it with that one targeted }, this fight
local sealAt, combatAt, swing = 0, 0, nil -- when your seal went up, when the fight began, your weapon speed

-- your target's GUID, or nil when the game won't say
local function targetGUID()
    local ok, g = pcall(UnitGUID, "target")
    if not ok or not g or secret(g) then return nil end
    return g
end

-- your target's creature type ("Beast", "Undead"...), or nil when the game won't say; remembered per target
local typeSeen = {}
local function targetType()
    local okT, t = pcall(UnitCreatureType or function() end, "target")
    local g = targetGUID()
    if okT and t ~= nil and not secret(t) then
        if g then
            if not typeSeen[g] then typeSeen.n = (typeSeen.n or 0) + 1 end
            if typeSeen.n > 300 then typeSeen = { n = 1 } end
            typeSeen[g] = t
        end
        return t
    end
    return g and typeSeen[g] or nil
end
S:On("PLAYER_TARGET_CHANGED", function() pcall(targetType) end)

-- what your demon is attacking: "same" (your target), "other", "none" (no demon, or it isn't attacking), or nil
-- when the game won't say
local function petTargetIs()
    local okP, pet = pcall(UnitExists, "pet")
    if not okP or secret(pet) then return nil end
    if not pet then return "none" end
    local okE, has = pcall(UnitExists, "pettarget")
    if not okE or secret(has) then return nil end
    if not has then return "none" end
    local okU, same = pcall(UnitIsUnit, "pettarget", "target")
    if not okU or secret(same) then return nil end
    return same and "same" or "other"
end
local function myDebuff(name)
    local fn = C_UnitAuras and C_UnitAuras.GetAuraDataBySpellName
    if fn and not aurasHidden() then
        local ok, a = pcall(fn, "target", name, "HARMFUL|PLAYER")
        if ok and not a then
            -- debuffs anyone can see (Sunder Armor, Thunder Clap) count no matter who put them there
            ok, a = pcall(fn, "target", name, "HARMFUL")
        end
        if ok then
            if not a then return nil end
            if not secret(a.expirationTime) and not secret(a.applications) then
                local left = (a.expirationTime and a.expirationTime > 0) and (a.expirationTime - GetTime()) or math.huge
                return left, a.applications or 0
            end
        end
    end
    -- hidden: go by when you last cast it on this target
    local at = targetCasts[name]
    if not at then return nil end
    local left = at + durationOf(name) - GetTime()
    if left <= 0 then return nil end
    return left, 1
end

S:On("UNIT_SPELLCAST_SUCCEEDED", function(unit, _, spellID)
    if unit ~= "player" or not spellID or secret(spellID) then return end
    local ok, name = pcall(C_Spell.GetSpellName, spellID)
    if not ok or not name or secret(name) then return end
    if name:find("^Seal of ") then
        -- one seal at a time: a new one replaces the old
        for other in pairs(casts) do if other:find("^Seal of ") then casts[other] = nil end end
        for other in pairs(seen) do if other:find("^Seal of ") then seen[other] = nil end end
        sealAt = GetTime()
    elseif name == "Judgement" and playerHas("Seal of the Crusader") then
        targetCasts[JOTC] = GetTime()
    elseif name == "Holy Strike" and targetCasts[JOTC] and S.TalentRank and S:TalentRank("Sacred Arbiter") > 0 then
        targetCasts[JOTC] = GetTime() -- Sacred Arbiter: Holy Strike refreshes your Judgements on the target
    end
    if chain.name == name and GetTime() - chain.at < 8 then chain.n = chain.n + 1 else chain.name, chain.n = name, 1 end
    chain.at = GetTime()
    casts[name] = GetTime()
    targetCasts[name] = GetTime()
    local g = targetGUID()
    if g then
        castOn[g] = castOn[g] or {}
        castOn[g][name] = GetTime()
    end
    lastCast[spellID] = GetTime()
    if manaCost[spellID] then manaSpent = manaSpent + manaCost[spellID] end
    if spellID ~= 6603 and spellID ~= 75 then lastGCD = GetTime() end -- not Attack / Auto Shot
end)
S:On("PLAYER_TARGET_CHANGED", function() targetCasts = {} end)
S:On("PLAYER_REGEN_ENABLED", function()
    -- out of combat the game tells again: forget the guesses
    casts = {}
    castOn = {}
    pcall(readPlayerAuras)
end)

local function pct(cur, max)
    if secret(cur, max) or not max or max <= 0 then return nil end
    return cur / max
end

-- Your target's health when the game hides it (2026-11-20, an idea from Hekili Forever; our own code). Hekili's notes
-- say Forever hides the target's health even out of combat. Two abilities only work at or below 20% of the target's
-- health (Execute, Hammer of Wrath; Icy Veins' Forever guides): the game still says whether you can use them, so
-- "usable" means the target is at or below 20%, and "not usable, not for lack of rage or mana" means above.
-- Kept per target for the fight. A target nobody is fighting yet is at full health.
local GATES = { ["Execute"] = 0.2, ["Hammer of Wrath"] = 0.2 }
local band = {} -- [target GUID] = { lo = at least, hi = at most } (fractions), this fight
local seenHealth -- what the game answered the first time (written to StewardDB.caps.targetHealth)
local function inDefensiveStance()
    if not (GetShapeshiftForm and GetShapeshiftFormInfo) then return nil end
    local okF, form = pcall(GetShapeshiftForm)
    if not okF or secret(form) or type(form) ~= "number" then return nil end
    if form == 0 then return false end
    local okI, _, active, _, id = pcall(GetShapeshiftFormInfo, form)
    if not okI or secret(id) then return nil end
    return id == 71
end
local function readGates(have)
    local g = targetGUID()
    if not g or not (C_Spell and C_Spell.IsSpellUsable) then return end
    local okA, can = pcall(UnitCanAttack, "player", "target")
    local okD, dead = pcall(UnitIsDead, "target")
    if not (okA and okD) or secret(can, dead) or not can or dead then return end
    local b = band[g]
    for name, gate in pairs(GATES) do
        local id = have[name]
        if id then
            local ok, usable, short = pcall(C_Spell.IsSpellUsable, id)
            if ok and not secret(usable, short) then
                if usable then
                    b = b or {}
                    b.hi = math.min(b.hi or 1, gate)
                    if b.lo and b.lo > b.hi then b.lo = nil end
                elseif not short and not (name == "Execute" and inDefensiveStance() ~= false) then
                    b = b or {}
                    b.lo = math.max(b.lo or 0, gate + 0.001)
                    if b.hi and b.hi < b.lo then b.hi = nil end
                end
            end
        end
    end
    band[g] = b
end
-- your target's health: the fraction when the game tells, else nil and what's known about it (at least, at most)
local function targetHealth()
    local p = pct(UnitHealth("target"), UnitHealthMax("target"))
    if not seenHealth then
        local okH, h = pcall(UnitHealth, "target")
        if okH and h ~= nil and targetGUID() then
            seenHealth = (secret(h) and "hidden" or "shown") .. (UnitAffectingCombat("player") and " in combat" or " out of combat")
            if StewardDB then StewardDB.caps = StewardDB.caps or {} StewardDB.caps.targetHealth = seenHealth end
        end
    end
    if p then return p end
    local g = targetGUID()
    local b = g and band[g]
    local lo, hi = b and b.lo, b and b.hi
    if not hi and g and not (castOn[g] and next(castOn[g])) then
        local okC, fighting = pcall(UnitAffectingCombat, "target")
        if okC and not secret(fighting) and fighting == false then lo = 1 end -- untouched: full
    end
    return nil, lo, hi
end
S.TargetHealth = targetHealth
S.TargetHealthGates = readGates
S:On("PLAYER_REGEN_ENABLED", function() band = {} end) -- out of combat a mob that got away heals up

-- is a totem standing in this slot? While the game hides it: yes if you've put one there this fight (a totem
-- outlasts most leveling fights)
local function totemIn(slot)
    if assumedTotem[slot] then return true end
    if not GetTotemInfo then return false end
    local ok, have = pcall(GetTotemInfo, slot)
    if ok and not secret(have) then return have and true or false end
    for name in pairs(casts) do
        if totemSlotOf[name] == slot then return true end
    end
    return false
end

local function spellName(id)
    local ok, n = pcall(C_Spell.GetSpellName, id)
    if ok and n and not secret(n) then return n end
end

-- your own clock for a spell's cooldown, when the game hides it
local function ownCooldownLeft(id)
    local at = lastCast[id]
    if not at then return 0 end
    local cd = baseCD[id] or FALLBACK_CD[spellName(id) or ""] or 0
    return math.max(0, at + cd - GetTime())
end

local function cooldownLeft(id)
    local fn = C_Spell and C_Spell.GetSpellCooldown
    if not fn then return ownCooldownLeft(id) end
    local ok, info = pcall(fn, id)
    if not ok or not info or secret(info.startTime, info.duration) then
        hidden.cooldown = true
        return ownCooldownLeft(id)
    end
    if (info.duration or 0) <= 0 then return 0 end
    return math.max(0, info.startTime + info.duration - GetTime())
end

local function gcdLeft()
    local fn = C_Spell and C_Spell.GetSpellCooldown
    local ok, info = pcall(fn or function() end, 61304)
    if ok and info and not secret(info.startTime, info.duration) then
        if (info.duration or 0) <= 0 then return 0 end
        return math.max(0, info.startTime + info.duration - GetTime())
    end
    return math.max(0, lastGCD + 1.5 - GetTime())
end

-- read each rotation spell's cooldown while the game still tells (out of combat)
local function learnCooldowns(have)
    local fn = _G.GetSpellBaseCooldown or (C_Spell and C_Spell.GetSpellBaseCooldown)
    if not fn then return end
    for _, id in pairs(have) do
        if baseCD[id] == nil then
            local ok, ms = pcall(fn, id)
            if ok and type(ms) == "number" and not secret(ms) then baseCD[id] = ms / 1000 else baseCD[id] = false end
        end
        if manaCost[id] == nil and C_Spell and C_Spell.GetSpellPowerCost then
            local okC, costs = pcall(C_Spell.GetSpellPowerCost, id)
            manaCost[id] = false
            if okC and type(costs) == "table" then
                for _, c in ipairs(costs) do
                    if c.type == 0 and type(c.cost) == "number" and not secret(c.cost) then manaCost[id] = c.cost end
                end
            end
        end
    end
end
S.LearnRotationCooldowns = learnCooldowns

local function comboPoints()
    if GetComboPoints then
        local ok, n = pcall(GetComboPoints, "player", "target")
        if ok and type(n) == "number" and not secret(n) then return n end
    end
    local ok, n = pcall(UnitPower, "player", Enum and Enum.PowerType and Enum.PowerType.ComboPoints or 4)
    return ok and type(n) == "number" and not secret(n) and n or 0
end

-- about how many of your swings have landed under the seal you have up now
local function swingsOnSeal()
    if assumedSeal then return 0 end
    if UnitAttackSpeed then
        local ok, sp = pcall(UnitAttackSpeed, "player")
        if ok and type(sp) == "number" and not secret(sp) and sp > 0.5 then swing = sp end
    end
    local since = math.max(sealAt, combatAt)
    if since <= 0 then return 0 end
    return math.floor((GetTime() - since) / (swing or 3))
end

-- enemies in the fight, from the enemy nameplates on screen; 0 when the game won't say
local function enemiesInFight()
    local get = C_NamePlate and C_NamePlate.GetNamePlates
    if not get then return 0 end
    local ok, plates = pcall(get)
    if not ok or type(plates) ~= "table" then return 0 end
    local n = 0
    for _, plate in ipairs(plates) do
        local unit = plate.namePlateUnitToken or (plate.UnitFrame and plate.UnitFrame.unit)
        if unit then
            local okU, hit = pcall(function()
                local can, dead, fighting = UnitCanAttack("player", unit), UnitIsDead(unit), UnitAffectingCombat(unit)
                if secret(can, dead, fighting) then return false end
                return can and not dead and fighting and true or false
            end)
            if okU and hit then n = n + 1 end
        end
    end
    return n
end
S.EnemiesInFight = enemiesInFight

-- can this rule be used right now? returns ok, cooldown seconds left
local function check(rule, id)
    local name = rule[1]
    local usable, noPower = true, false
    if C_Spell and C_Spell.IsSpellUsable then
        usable, noPower = C_Spell.IsSpellUsable(id)
        if secret(usable) then hidden.usable = true usable = true end -- hidden: you know it, assume you can
    end
    if secret(noPower) then noPower = false end
    if not usable and not noPower then return false end -- needs a proc, a stance or a target state
    if C_Spell and C_Spell.IsSpellInRange then
        local inRange = C_Spell.IsSpellInRange(id, "target")
        if secret(inRange) then hidden.range = true end
        if not secret(inRange) and inRange == false then return false end
    end
    if rule.noRepeat then
        local rep = (C_Spell and C_Spell.IsAutoRepeatSpell) or _G.IsAutoRepeatSpell
        if rep then
            local okR, on = pcall(rep, id)
            if okR and on and not secret(on) then return false end
        end
        if C_Spell and C_Spell.IsCurrentSpell and C_Spell.IsCurrentSpell(id) then return false end
    end
    if rule.group and not (IsInGroup and IsInGroup()) then return false end
    if rule.dot or rule.stacks then
        local left, stacks = myDebuff(name)
        if rule.stacks then
            if left and stacks >= rule.stacks and left > 3 then return false end
        elseif left and left > 2 then
            return false
        end
    end
    if rule.talent and not (S.TalentRank and S:TalentRank(rule.talent) > 0) then return false end
    if rule.twoHand and S.TwoHanded and not S.TwoHanded() then return false end
    if rule.debuff and not myDebuff(rule.debuff) then return false end
    if rule.nodebuff then
        local left = myDebuff(rule.nodebuff)
        if left and left > 2 then return false end
    end
    if rule.thpAbove then -- the target still has at least this much health
        local p, _, hi = targetHealth()
        if p and p * 100 < rule.thpAbove then return false end
        if not p and hi and hi * 100 <= rule.thpAbove then return false end -- known to be lower
    end
    if rule.ready then
        local other = knownSpells()[rule.ready]
        if not other or (cooldownLeft(other) or 0) > 1.5 then return false end
    end
    if rule.swings and swingsOnSeal() < rule.swings then return false end
    if rule.selfBelow then
        local p = pct(UnitHealth("player"), UnitHealthMax("player"))
        if p and p * 100 >= rule.selfBelow then return false end
    end
    if rule.hurt then -- a heal on yourself: only when the game says you're under this much health
        local p = pct(UnitHealth("player"), UnitHealthMax("player"))
        if not p or p * 100 >= rule.hurt then return false end
    end
    if rule.rageBelow or rule.powerBelow then -- rage, energy: whatever your bar holds now (hidden: allowed)
        local p = UnitPower("player")
        if not secret(p) and (p or 0) >= (rule.rageBelow or rule.powerBelow) then return false end
    end
    if rule.maxLevel and (UnitLevel("player") or 1) > rule.maxLevel then return false end
    if rule.minLevel and (UnitLevel("player") or 1) < rule.minLevel then return false end
    if rule.frozen then
        local ok = playerHas("Fingers of Frost") or myDebuff("Frost Nova") or myDebuff("Frostbite")
        if not ok and rule.orStacks then
            local left, n = myDebuff(rule.orStacks[1])
            ok = left and (n or 0) >= rule.orStacks[2]
        end
        if not ok then return false end
    end
    if rule.close then
        local okC, near = pcall(CheckInteractDistance, "target", 3)
        if not okC or secret(near) or not near then return false end
    end
    if rule.pack and enemiesInFight() < rule.pack then return false end
    if rule.packBelow and enemiesInFight() >= rule.packBelow then return false end
    if rule.nobuff and playerHas(rule.nobuff) then return false end
    if rule.selfStacks then -- at least this many stacks (unknown: no)
        local k = selfStacks(rule.selfStacks[1])
        if not k or k < rule.selfStacks[2] then return false end
    end
    if rule.selfStacksBelow then -- fewer than this many (unknown: count your back-to-back casts of it)
        local name, k = rule.selfStacksBelow[1], selfStacks(rule.selfStacksBelow[1])
        if k == nil then k = (chain.name == name and GetTime() - chain.at < 8) and chain.n or 0 end
        if k >= rule.selfStacksBelow[2] then return false end
    end
    if rule.moving then -- only while you are moving
        local okM, speed = pcall(GetUnitSpeed, "player")
        if not okM or secret(speed) or not speed or speed <= 0 then return false end
    end
    if rule.every then -- on this target (when the game won't say which target is which: on any)
        local g = targetGUID()
        local at = casts[name]
        if g then at = castOn[g] and castOn[g][name] end
        if at and GetTime() - at < rule.every then return false end
    end
    if rule.petsTarget and (petTargetIs() or "same") ~= "same" then return false end
    if rule.petsTargetIfOut and petTargetIs() == "other" then return false end
    if rule.groupPackBelow and IsInGroup and IsInGroup() and enemiesInFight() >= rule.groupPackBelow then return false end
    if rule.after and GetTime() - combatAt < rule.after then return false end
    if rule.boss then -- a boss: the game's "worldboss", or a target whose level shows as ??
        local okB, c = pcall(UnitClassification, "target")
        local okL, lvl = pcall(UnitLevel, "target")
        local isBoss = (okB and not secret(c) and c == "worldboss") or (okL and not secret(lvl) and lvl == -1)
        if not isBoss then return false end
    end
    if rule.elite then
        local okC, c = pcall(UnitClassification, "target")
        if not okC or secret(c) or not (c == "elite" or c == "rareelite" or c == "worldboss") then return false end
    end
    if rule.debuffBelow then -- your debuff is on the target with less than this many seconds left
        local left = myDebuff(rule.debuffBelow[1])
        if not left or left >= rule.debuffBelow[2] then return false end
    end
    if rule.notalent and S.TalentRank and S:TalentRank(rule.notalent) > 0 then return false end
    if rule.has and not playerHas(rule.has) then return false end
    if rule.hp then -- the target is below this much health
        local p, lo, hi = targetHealth()
        if not p then hidden.health = true end
        if p then
            if p * 100 >= rule.hp then return false end
        elseif not (hi and hi * 100 <= rule.hp) then
            return false -- not known to be that low
        end
    end
    if rule.hpAbove then
        local p = pct(UnitHealth("player"), UnitHealthMax("player"))
        if not p or p < rule.hpAbove then return false end
    end
    if rule.combo and comboPoints() < rule.combo then return false end
    if rule.rage then
        local p = UnitPower("player")
        if secret(p) or (p or 0) < rule.rage then return false end
    end
    if rule.manaBelow or (rule.manaAbove and not (rule.orHas and playerHas(rule.orHas))) then
        local mana = Enum and Enum.PowerType and Enum.PowerType.Mana or 0
        local p = pct(UnitPower("player", mana), UnitPowerMax("player", mana))
        if not p then
            -- hidden: your mana when the fight began, less what you've cast since
            hidden.power = true
            if manaStart and manaMax and manaMax > 0 then
                p = math.max(0, manaStart - manaSpent) / manaMax
            else
                if rule.manaBelow then return false end
                p = 1
            end
        end
        if rule.manaBelow and p >= rule.manaBelow then return false end
        if rule.manaAbove and p < rule.manaAbove then return false end
    end
    if rule.types or rule.notypes then
        -- hidden in a fight (a secret value: looking one up in a table is an error, Rotation.lua:826 on 2026-11-19):
        -- then the type seen for this target before, else unknown. Unknown: "only against" rules wait, "never
        -- against" rules let it through
        local t = targetType()
        if rule.types and not (t and rule.types[t]) then return false end
        if rule.notypes and t and rule.notypes[t] then return false end
    end
    if rule.totem and totemIn(rule.totem) then return false end
    if rule.totemUp and not totemIn(rule.totemUp) then return false end
    local enchant = (C_Item and C_Item.GetWeaponEnchantInfo) or _G.GetWeaponEnchantInfo
    if rule.noimbue and enchant then
        local okE, has = pcall(enchant)
        if okE and has then return false end
    end
    if noPower then return true, 99 end -- right spell, waiting on rage, energy or mana
    return true, cooldownLeft(id) or 99
end

-- the next spells to press: up to three { id, name, wait } in order
function S:RotationNext()
    local list, rules, have = {}, self:RotationRules(), knownSpells()
    pcall(readGates, have)
    if not InCombatLockdown() then learnCooldowns(have) end
    local gcd = gcdLeft()
    local soon = {}
    assumed = {}
    assumedSeal = nil
    assumedTotem = {}
    totemSlotOf = {}
    for _, rule in ipairs(rules) do
        if rule.totem then totemSlotOf[rule[1]] = rule.totem end
    end
    local fillerTaken = false
    local listed = {} -- a spell is shown once, by the first rule that wants it
    for _, rule in ipairs(rules) do
        local id = have[rule[1]]
        if id and listed[rule[1]] then id = nil end
        if id and rule.filler and fillerTaken then id = nil end -- one filler is enough: you spam it
        if id then
            local ok, wait = check(rule, id)
            if ok and rule.filler then fillerTaken = true end
            if ok then
                if wait <= gcd + 0.2 then
                    if #list < 3 then
                        listed[rule[1]] = true
                        list[#list + 1] = { id = id, name = rule[1], wait = 0 }
                        -- after casting a seal, the next thing is what needs the seal (Judgement)
                        if rule.nobuff then assumed[rule.nobuff] = true end
                        if rule[1]:find("^Seal of ") then assumedSeal = rule[1] end
                        if rule.totem then assumedTotem[rule.totem] = true end -- that slot is taken now
                    end
                elseif wait < 8 then
                    listed[rule[1]] = true
                    soon[#soon + 1] = { id = id, name = rule[1], wait = wait }
                end
            end
        end
    end
    -- after what's ready now come the things that are nearly ready
    assumed = {}
    assumedSeal = nil
    assumedTotem = {}
    table.sort(soon, function(a, b) return a.wait < b.wait end)
    for _, s in ipairs(soon) do
        if #list >= 3 then break end
        list[#list + 1] = s
    end
    return list
end

---------------------------------------------------------------- the strip
local strip
local function spellIcon(id)
    local fn = C_Spell and C_Spell.GetSpellTexture
    if fn then return fn(id) end
    local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(id)
    return info and info.iconID
end

local function makeIcon(parent, size)
    local b = CreateFrame("Frame", nil, parent)
    b:SetSize(size, size)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    b.border = b:CreateTexture(nil, "OVERLAY")
    b.border:SetPoint("TOPLEFT", -size * 0.06, size * 0.06)
    b.border:SetPoint("BOTTOMRIGHT", size * 0.06, -size * 0.06)
    if b.border.SetAtlas then b.border:SetAtlas("UI-HUD-ActionBar-IconFrame", false, nil, true) end
    local ok, cd = pcall(CreateFrame, "Cooldown", nil, b, "CooldownFrameTemplate")
    if ok and cd then
        cd:SetAllPoints(b.icon)
        if cd.SetDrawEdge then cd:SetDrawEdge(false) end
        if cd.SetHideCountdownNumbers then cd:SetHideCountdownNumbers(true) end
        b.cooldown = cd
    end
    return b
end

local function buildStrip()
    if strip then return strip end
    strip = CreateFrame("Frame", "StewardRotationStrip", UIParent)
    strip:SetSize(130, 44)
    strip:SetFrameStrata("MEDIUM")
    if strip.EnableMouse then strip:EnableMouse(false) end
    strip.icons = { makeIcon(strip, 44), makeIcon(strip, 32), makeIcon(strip, 32) }
    strip.icons[1]:SetPoint("BOTTOMLEFT", strip, "BOTTOMLEFT", 0, 0)
    strip.icons[2]:SetPoint("BOTTOMLEFT", strip.icons[1], "BOTTOMRIGHT", 8, 0)
    strip.icons[3]:SetPoint("BOTTOMLEFT", strip.icons[2], "BOTTOMRIGHT", 6, 0)
    for i = 2, 3 do strip.icons[i]:SetAlpha(0.8) end
    strip.note = strip:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    strip.note:SetPoint("LEFT", strip.icons[1], "RIGHT", 8, 0)
    strip.note:Hide()
    strip:Hide()
    return strip
end

-- above the two bars over the main bar, centred under your character
local function placeStrip()
    local s = buildStrip()
    s:ClearAllPoints()
    local top = 0
    for _, n in ipairs({ "MultiBarBottomLeft", "MultiBarBottomRight", "MainActionBar", "MainMenuBar" }) do
        local f = _G[n]
        if f and f:IsShown() and f.GetTop and f:GetTop() then
            local scale = (f.GetEffectiveScale and f:GetEffectiveScale() or 1) / (UIParent:GetEffectiveScale() or 1)
            top = math.max(top, f:GetTop() * scale)
        end
    end
    local k = math.max(0.5, math.min(2, (tonumber(S:Get("rotationSize")) or 100) / 100))
    s:SetScale(k)
    s:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, (top + 14) / k)
end
-- the strip and the glow can each be turned off (Options > Steward)
local function stripOn() return S:Get("rotationStrip") ~= false end

---------------------------------------------------------------- the glow on your bars
local BUTTONS = { { "ActionButton", 0 }, { "MultiBarBottomLeftButton", 60 }, { "MultiBarBottomRightButton", 48 },
    { "MultiBarRightButton", 24 }, { "MultiBarLeftButton", 36 } }

local glows = { ants = {}, proc = {} }
local ATLAS = { ants = "RotationHelper_Ants_Flipbook", proc = "UI-HUD-ActionBar-Proc-Loop-Flipbook" }
local function glowFor(button, kind)
    kind = kind or "ants"
    if glows[kind][button] then return glows[kind][button] end
    local g = CreateFrame("Frame", nil, button)
    g:SetFrameLevel((button.GetFrameLevel and button:GetFrameLevel() or 1) + 5)
    local w = button.GetWidth and button:GetWidth() or 45
    g:SetSize(w * 1.45, w * 1.45)
    g:SetPoint("CENTER", button, "CENTER", 0, 0)
    local t = g:CreateTexture(nil, "OVERLAY")
    t:SetAllPoints()
    t:SetAtlas(ATLAS[kind], false, nil, true)
    g.tex = t
    -- the game's flipbook: 30 frames, 5 across and 6 down
    local ag = t.CreateAnimationGroup and t:CreateAnimationGroup()
    local ok = ag and pcall(function()
        local a = ag:CreateAnimation("FlipBook")
        a:SetFlipBookRows(6)
        a:SetFlipBookColumns(5)
        a:SetFlipBookFrames(30)
        a:SetDuration(1)
        ag:SetLooping("REPEAT")
    end)
    if ok then g.anim = ag else
        -- no flipbook: show its first frame
        local l, r, top, b = 0, 1, 0, 1
        if C_Texture and C_Texture.GetAtlasInfo then
            local info = C_Texture.GetAtlasInfo(ATLAS[kind])
            if info then l, r, top, b = info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord end
        end
        t:SetTexCoord(l, l + (r - l) / 5, top, top + (b - top) / 6)
    end
    g:Hide()
    glows[kind][button] = g
    return g
end

local lit
local function buttonsWith(name)
    local out = {}
    if not GetActionInfo then return out end
    for _, def in ipairs(BUTTONS) do
        for i = 1, 12 do
            local b = _G[def[1] .. i]
            if b and (not b.IsVisible or b:IsVisible()) then
                local slot = b.action or (def[2] + i)
                local kind, id = GetActionInfo(slot)
                if kind == "macro" and GetActionText and GetActionText(slot) == name then
                    out[#out + 1] = b
                elseif kind == "spell" and id then
                    local n = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(id)
                    if n == name then out[#out + 1] = b end
                elseif kind == "flyout" and id and GetFlyoutInfo and GetFlyoutSlotInfo then
                    -- a group button (Blessings, Auras) lights up for the spells inside it
                    local okF, _, _, count = pcall(GetFlyoutInfo, id)
                    for k = 1, okF and count or 0 do
                        local sid, _, _, sname = GetFlyoutSlotInfo(id, k)
                        sname = sname or (sid and C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(sid))
                        if sname == name then out[#out + 1] = b break end
                    end
                end
            end
        end
    end
    return out
end

local function setGlow(name, kind)
    if name and S:Get("rotationGlow") == false then name = nil end
    kind = kind or "ants"
    if lit and lit.name == name and lit.kind == kind then return end
    if lit then
        for _, g in ipairs(lit.glows) do
            if g.anim then g.anim:Stop() end
            g:Hide()
        end
    end
    lit = nil
    if not name then return end
    lit = { name = name, kind = kind, glows = {} }
    for _, b in ipairs(buttonsWith(name)) do
        -- glows are made ahead of time, out of combat; never build onto your bars mid-fight
        local g = glows[kind][b] or (not InCombatLockdown() and glowFor(b, kind))
        if g then
            g:Show()
            if g.anim then g.anim:Play() end
            lit.glows[#lit.glows + 1] = g
        end
    end
end

local function prepareGlows()
    if InCombatLockdown() then return end
    for _, def in ipairs(BUTTONS) do
        for i = 1, 12 do
            local b = _G[def[1] .. i]
            if b then
                if not glows.ants[b] then glowFor(b, "ants") end
                if not glows.proc[b] then glowFor(b, "proc") end
            end
        end
    end
end

---------------------------------------------------------------- when it shows
---------------------------------------------------------------- buff reminders
-- Out of combat: your long buffs. Any listed buff counts as having it; the first spell you
-- know in "cast" is the one suggested. Under 30 seconds left counts as missing.
local BUFFS = {
    PALADIN = {
        { any = { "* Aura" }, cast = { Retribution = { "Retribution Aura", "Devotion Aura" },
            Protection = { "Retribution Aura", "Devotion Aura" }, Holy = { "Concentration Aura", "Devotion Aura" } } },
        { any = { "Blessing of *", "Greater Blessing of *" }, cast = { Retribution = { "Blessing of Might" },
            Protection = { "Blessing of Kings", "Blessing of Might" }, Holy = { "Blessing of Wisdom", "Blessing of Kings" } } },
        { any = { "Righteous Fury" }, cast = { Protection = { "Righteous Fury" } } },
    },
    MAGE = {
        { any = { "Arcane Intellect", "Arcane Brilliance" }, cast = { "Arcane Intellect" } },
        { any = { "Frost Armor", "Ice Armor", "Mage Armor" }, cast = { "Ice Armor", "Frost Armor", "Mage Armor" } },
    },
    PRIEST = {
        { any = { "Power Word: Fortitude", "Prayer of Fortitude" }, cast = { "Power Word: Fortitude" } },
        { any = { "Inner Fire" }, cast = { "Inner Fire" } },
        { any = { "Divine Spirit", "Prayer of Spirit" }, cast = { "Divine Spirit" } },
        { any = { "Shadowform" }, cast = { Shadow = { "Shadowform" } } },
        -- Wowhead's Shadow leveling page: "Undead players should also maintain Touch of Weakness" (the Undead racial;
        -- only a character who knows it is ever reminded)
        { any = { "Touch of Weakness" }, cast = { Shadow = { "Touch of Weakness" } } },
    },
    DRUID = {
        { any = { "Mark of the Wild", "Gift of the Wild" }, cast = { "Mark of the Wild" } },
        { any = { "Thorns" }, cast = { "Thorns" } },
        { any = { "Omen of Clarity" }, cast = { "Omen of Clarity" } },
    },
    WARLOCK = {
        { any = { "Demon Armor", "Demon Skin" }, cast = { "Demon Armor", "Demon Skin" } },
        -- Wowhead's Demonology page, from 40: "Sacrifice the Imp with Demonic Sacrifice, then summon the Sayaad.
        -- Demonic Pact keeps Burning Shadow up." The Imp first, then the sacrifice (never with another demon out)
        { any = { "Burning Shadow" }, talent = "Demonic Pact", petFamily = "Imp", cast = { Demonology = { "Demonic Sacrifice" } } },
        { any = { "Burning Shadow" }, talent = "Demonic Pact", notPetFamily = "Imp", cast = { Demonology = { "Summon Imp" } } },
        -- no demon out. All three pages: "Use the Voidwalker until 20, then the Sayaad"; Destruction: "Summon the Imp
        -- for dungeons". The first one you know and can summon (the Voidwalker and the Sayaad cost a Soul Shard)
        { noPet = true, instance = true, cast = { Destruction = { "Summon Imp" } } },
        { noPet = true, cast = { "Summon Succubus", "Summon Incubus", "Summon Voidwalker", "Summon Imp" } },
        -- Demonology: "A fresh Sayaad costs a Soul Shard, and you have to cast Soul Link again"
        { any = { "Soul Link" }, pet = true, cast = { Demonology = { "Soul Link" } } },
    },
    -- Wowhead's shaman pages: Elemental and Restoration "Maintain either Lightning Shield or Water Shield" (Water
    -- Shield once you have it); Enhancement keeps Lightning Shield up, refreshed between pulls
    SHAMAN = { { any = { "Lightning Shield", "Water Shield" }, cast = { Elemental = { "Water Shield", "Lightning Shield" },
        Restoration = { "Water Shield", "Lightning Shield" }, Enhancement = { "Lightning Shield" } } } },
    HUNTER = { { any = { "Aspect of *" }, cast = { "Aspect of the Hawk", "Aspect of the Monkey" } } },
}
S.BUFF_REMINDERS = BUFFS

local function buffLeft(patterns)
    return buffLeftAny(patterns)
end

-- the first long buff you're missing: { id, name } or nil
-- a weapon stone in your bags and nothing on your main-hand weapon: sharpen it
local function weaponBuffMissing()
    local stone = S.WeaponStone and S.WeaponStone()
    if not stone then return nil end
    local enchant = (C_Item and C_Item.GetWeaponEnchantInfo) or _G.GetWeaponEnchantInfo
    if not enchant then return nil end
    local ok, has, expires = pcall(enchant)
    if not ok or secret(has) then return nil end
    if has and not secret(expires) and (expires or 0) > 60000 then return nil end
    if has and secret(expires) then return nil end
    local icon = C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(stone)
    return { item = stone, icon = icon, name = S.SHARPEN_MACRO or "Sharpen Weapon" }
end

-- your demon: does one stand beside you, and what kind (nil when the game won't say)
local function petOut()
    local ok, has = pcall(UnitExists, "pet")
    if not ok or secret(has) then return nil end
    if not has then return false end
    local okD, dead = pcall(UnitIsDead, "pet")
    if okD and not secret(dead) and dead then return false end
    return true
end
local function petFamily()
    if petOut() ~= true then return nil end
    local ok, fam = pcall(UnitCreatureFamily, "pet")
    if not ok or not fam or secret(fam) then return nil end
    return fam
end

-- a reminder's own conditions (warlock demons; a talent)
local function reminderApplies(b)
    if b.talent and not (S.TalentRank and (S:TalentRank(b.talent) or 0) > 0) then return false end
    if b.pet and petOut() ~= true then return false end
    if b.noPet and petOut() ~= false then return false end
    if b.instance and not (S.InInstance and S.InInstance()) then return false end
    if b.petFamily or b.notPetFamily then
        local out = petOut()
        if out == nil then return false end -- can't tell what's out: suggest nothing
        local fam = out and petFamily() or false
        if out and not fam then return false end
        if b.petFamily and fam ~= b.petFamily then return false end
        if b.notPetFamily and fam == b.notPetFamily then return false end
    end
    return true
end

-- out of combat the game says whether a spell can be cast now: a missing reagent (a Soul Shard) or demon rules it out,
-- missing mana doesn't (you'll drink)
local function castableNow(id)
    if not (C_Spell and C_Spell.IsSpellUsable) then return true end
    local ok, usable, noMana = pcall(C_Spell.IsSpellUsable, id)
    if not ok or secret(usable, noMana) then return true end
    return (usable or noMana) and true or false
end

function S:MissingBuff()
    local list = BUFFS[self:PlayerClass()]
    if not list then return weaponBuffMissing() end
    local have, spec = knownSpells(), self:CurrentSpec()
    for _, b in ipairs(list) do
        if reminderApplies(b) then
            local cast = b.cast
            if cast and not cast[1] then cast = cast[spec] end
            local pick
            for _, name in ipairs(cast or {}) do
                if have[name] and castableNow(have[name]) then pick = name break end
            end
            if pick then
                local left = b.any and buffLeft(b.any)
                if not left or left < 30 then return { id = have[pick], name = pick } end
            end
        end
    end
    return weaponBuffMissing()
end

local function reminderWanted()
    if not S:Get("buffReminders") or UnitAffectingCombat("player") then return false end
    if UnitIsDeadOrGhost and UnitIsDeadOrGhost("player") then return false end
    if (IsMounted and IsMounted()) or (UnitOnTaxi and UnitOnTaxi("player")) then return false end
    if UnitInVehicle and UnitInVehicle("player") then return false end
    if S:PlayerClass() == "DRUID" and GetShapeshiftFormID and GetShapeshiftFormID() then return false end
    -- not while eating or drinking
    if buffLeft({ "Food", "Drink", "Refreshment", "Food & Drink" }) then return false end
    return true
end

local function wanted()
    if not S:Get("rotationHelper") then return false end
    if not UnitAffectingCombat("player") then return false end
    if not UnitExists("target") or UnitIsDead("target") then return false end
    if UnitCanAttack and not UnitCanAttack("player", "target") then return false end
    if UnitOnTaxi and UnitOnTaxi("player") then return false end
    if C_ActionBar and C_ActionBar.HasOverrideActionBar and C_ActionBar.HasOverrideActionBar() then return false end
    return true
end

S.rotationShown = {}
local function refresh()
    local s = buildStrip()
    if not wanted() then
        S.rotationShown = {}
        if not InCombatLockdown() then
            pcall(learnCooldowns, knownSpells())
            local mana = Enum and Enum.PowerType and Enum.PowerType.Mana or 0
            local okP, cur, max = pcall(function() return UnitPower("player", mana), UnitPowerMax("player", mana) end)
            if okP and type(cur) == "number" and type(max) == "number" and not secret(cur, max) then
                S.manaLast, S.manaLastMax = cur, max
            end
        end
        local miss = reminderWanted() and S:MissingBuff()
        S.buffMissing = miss or nil
        if miss then
            local b = s.icons[1]
            b.icon:SetTexture(miss.icon or spellIcon(miss.id))
            b.icon:SetDesaturated(false)
            if b.cooldown then b.cooldown:Clear() end
            b:Show()
            s.icons[2]:Hide()
            s.icons[3]:Hide()
            s.note:SetText(miss.name)
            s.note:Show()
            -- the strip is the rotation helper's: with the helper off, a missing buff only lights its button
            if not stripOn() or not S:Get("rotationHelper") then s:Hide() elseif not s:IsShown() then placeStrip() s:Show() end
            setGlow(miss.name, "proc")
        else
            if s:IsShown() then s:Hide() end
            setGlow(nil)
        end
        return
    end
    s.note:Hide()
    local ok, list = pcall(S.RotationNext, S)
    if not ok then
        error(list, 0) -- counted by the ticker, which gives up after a few in a row
    end
    S.rotationShown = list
    if next(hidden) and StewardCharDB then
        StewardCharDB.rotationProbe = StewardCharDB.rotationProbe or {}
        for k in pairs(hidden) do StewardCharDB.rotationProbe[k] = true end
    end
    -- a short record of what it suggested, so it can be checked after a /reload
    local first = list[1] and list[1].name or "(nothing)"
    if first ~= S.rotationLast and StewardCharDB then
        S.rotationLast = first
        local names = {}
        for _, e in ipairs(list) do names[#names + 1] = e.name .. (e.wait > 0 and string.format("(%.0fs)", e.wait) or "") end
        StewardCharDB.rotationLog = StewardCharDB.rotationLog or {}
        table.insert(StewardCharDB.rotationLog, date("%H:%M:%S ") .. table.concat(names, ", "))
        while #StewardCharDB.rotationLog > 40 do table.remove(StewardCharDB.rotationLog, 1) end
    end
    if #list == 0 then
        s:Hide()
        setGlow(nil)
        return
    end
    for i, b in ipairs(s.icons) do
        local e = list[i]
        if e then
            b.icon:SetTexture(spellIcon(e.id))
            b.icon:SetDesaturated(e.wait > 0)
            if b.cooldown then
                local info = C_Spell and C_Spell.GetSpellCooldown and C_Spell.GetSpellCooldown(e.id)
                if info and not secret(info.startTime, info.duration) and (info.duration or 0) > 1.5 then
                    b.cooldown:SetCooldown(info.startTime, info.duration)
                else
                    b.cooldown:Clear()
                end
            end
            b:Show()
        else
            b:Hide()
        end
    end
    if not stripOn() then
        s:Hide()
    elseif not s:IsShown() then
        placeStrip()
        s:Show()
    end
    setGlow(list[1].wait == 0 and list[1].name or nil)
end

local ticker, failures = nil, 0
local function start()
    if ticker then return end
    ticker = C_Timer.NewTicker(0.15, function()
        if failures >= 3 then return end -- something's wrong: stop until the next reload, quietly
        local ok, err = pcall(refresh)
        if not ok and tostring(err):find("[Aa]ura") and not aurasRefused then
            aurasRefused = true      -- the game refused an aura: no more asking this fight, and not counted as a failure
            S:LogError("rotation", err)
            return
        end
        if ok then failures = 0 else
            failures = failures + 1
            S:LogError("rotation", err)
            if failures >= 3 and strip then strip:Hide() setGlow(nil) end
        end
    end)
end

S:On("PLAYER_ENTERING_WORLD", function()
    start()
    C_Timer.After(3, function() pcall(prepareGlows) end)
end)
S:On("PLAYER_REGEN_ENABLED", function() pcall(refresh) pcall(prepareGlows) end)
S.RotationRefresh = refresh

S:On("PLAYER_REGEN_DISABLED", function()
    manaSpent = 0
    combatAt = GetTime()
    local mana = Enum and Enum.PowerType and Enum.PowerType.Mana or 0
    local ok, cur, max = pcall(function() return UnitPower("player", mana), UnitPowerMax("player", mana) end)
    if ok and type(cur) == "number" and type(max) == "number" and not secret(cur, max) then
        manaStart, manaMax = cur, max
    else
        manaStart, manaMax = S.manaLast, S.manaLastMax -- the last reading from before the fight
    end
end)
