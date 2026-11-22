-- =====================================================================
--  Custom WoW: Forever guide -- Horde 12-22 (Warrior-optimized)
--  Chunks: 12-17 The Barrens > 17-22 Stonetalon/Barrens/Ashenvale.
--  Serves every Horde race: Tauren arrive from Mulgore, Orc/Troll/
--  Undead/Skyborne from the Silverpine bridge via Far Watch Post.
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Alliance" then return end

-- ==================== 12-17 THE BARRENS ==============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 12-17 The Barrens (Horde)
#next 17-22 Stonetalon/Barrens/Ashenvale (Horde)
<< Horde

step << Orc/Troll
    #optional
    .isOnQuest 809
    .goto 1413/1,-3694.20,256.52
    >>Ak'Zeloth waits at Far Watch Post with your banked errand -- his follow-up needs a Flawed Power Stone (Burning Blade drop from Durotar; skip if you never looted one)
    .turnin 809 >> Turn in Ak'Zeloth
    .accept 924 >> Accept The Demon Seed
    .target Ak'Zeloth

step << Druid
    >>DRUID: Cast Teleport: Moonglade
    .cast 18960
    .zoneskip Moonglade

step << Skyborne Druid
    .goto 1450/1,-2678.76,8019.94--c:Moonglade,56.21,30.64
    >>DRUID: Hand in Moonglade at Dendrite Starblaze
    .turnin 94913 >> Turn in Moonglade
    .target Dendrite Starblaze

step << Tauren Warrior
    .goto 1413/1,-3176.39,-437.35
    >>Up the mountain southwest of the Crossroads: Thun'grim Firegaze, your banked weapon trainer
    .turnin 1502 >> Turn in Thun'grim Firegaze
    .accept 1503 >> Accept Forged Steel
    .target Thun'grim Firegaze

step << Tauren Warrior
    .goto 1413/1,-2955.48,-188.04
    >>The Rusty Iron Chest below holds his Forged Steel Bars
    .complete 1503,1 --Forged Steel Bars

step << Tauren Warrior
    .goto 1413/1,-3176.39,-437.35
    >>Back up to Thun'grim -- weapon skills unlocked
    .turnin 1503 >> Turn in Forged Steel
    .target Thun'grim Firegaze

step << !Tauren
    .goto 1413/1,-2672.76,-544.77
    >>The Crossroads: Tonga Runetotem at the south entrance
    .accept 870 >> Accept The Forgotten Pools
    .target Tonga Runetotem

step << !Tauren
    .goto 1413/1,-2670.74,-482.61
    >>Sergra Darkthorn
    .turnin -842 >> Turn in Crossroads Conscription
    .accept 844 >> Accept Plainstrider Menace
    .target Sergra Darkthorn

step << !Tauren
    .goto 1413/1,-2595.75,-473.15
    >>Thork
    .turnin 98024 >> Turn in Journey to the Crossroads << Skyborne
    .accept 871 >> Accept Disrupt the Attacks
    .accept 5041 >> Accept Supplies for the Crossroads
    .target Thork

step << Undead/Skyborne
    .goto 1413/1,-2595.75,-437.35
    >>Devrak, the wind rider master (don't fly anywhere yet)
    .fp Crossroads >> Get the Crossroads flight path
    .target Devrak

step << Orc/Troll
    .goto 1413/1,-2709.24,-403.57
    >>Zargh at the meat stall
    .accept 6365 >> Accept Meats to Orgrimmar
    .target Zargh

step << Orc/Troll
    .goto 1413/1,-2595.75,-437.35
    >>Devrak takes the order -- do NOT fly to Orgrimmar, his errand banks free XP for later
    .turnin 6365 >> Turn in Meats to Orgrimmar
    .accept 6384 >> Accept Ride to Orgrimmar
    .target Devrak

step << !Tauren
    .goto 1413/1,-2589.67,-424.51
    >>Apothecary Helbrim
    .turnin -1358 >> Turn in Sample for Helbrim
    .accept 1492 >> Accept Wharfmaster Dizzywig
    .accept 848 >> Accept Fungal Spores
    .target Apothecary Helbrim

step << !Tauren
    .goto 1413/1,-2639.32,-436.00
    >>Gazrog
    .accept 869 >> Accept Raptor Thieves
    .target Gazrog

step << !Tauren
    .goto 1413/1,-2645.40,-406.94
    >>Innkeeper Boorand Plainswind
    .home >> Set your Hearthstone to the Crossroads
    .target Innkeeper Boorand Plainswind

step
    #sticky
    #completewith Raptors
    >>Sunscale raptors die on sight all chapter: 12 Raptor Heads
    .complete 869,1 --Raptor Head (12)
    .mob Sunscale Lashtail
    .mob Sunscale Screecher
    .mob Sunscale Scytheclaw

step
    #sticky
    #completewith Beaks
    >>Plainstriders drop 7 beaks
    .complete 844,1 --Plainstrider Beak (7)
    .mob Greater Plainstrider
    .mob Fleeting Plainstrider

step << Orc/Troll
    #optional
    .isOnQuest 924
    .goto 1413/1,-2205.62,314.62,100,0
    >>Northeast up Dreadmist Peak with your Flawed Power Stone: destroy the Demon Seed in the den
    .goto 1413/1,-2238.04,324.08
    .collect 4986,1,924 --Flawed Power Stone
    .complete 924,1 --Destroy the Demon Seed

step
    .goto 1413/1,-3021.35,-231.96
    >>Southwest of the Crossroads: Chen's Empty Keg sits in the grass (grab it later if it's not up)
    .collect 4926,1,819 --Chen's Empty Keg
    .accept 819 >> Accept Chen's Empty Keg
    .use 4926

step << Shaman
    .goto 1413/1,-2879.60,-89.90
    >>Shamans, fire totem time. First: Razormane Water Seekers along the road northeast drop the Fire Tar you'll need
    .collect 5026,1,1525,1 --Fire Tar
    .mob Razormane Water Seeker

step << Shaman
    .goto 1413/1,-3054.90,269.00
    >>Kranal Fiss camps by the road toward Durotar (if he won't offer the quest, you missed the trainer letter -- Swart in Razor Hill, Searn Firewarder in Orgrimmar, Narm Skychaser in Bloodhoof or Xanis Flameweaver in Thunder Bluff starts it)
    .turnin -1522 >> Turn in Call of Fire
    .turnin -1523 >> Turn in Call of Fire
    .accept 1524,2,1523 >> Accept Call of Fire
    .target Kranal Fiss

step << Shaman
    .goto 1411/1,-4733.10,927.10
    >>Across into Durotar: Burning Blade Cultists in the ravine country carry the Reagent Pouch
    .collect 6652,1,1525,1 --Reagent Pouch
    .mob Burning Blade Cultist
    .mob Burning Blade Fanatic

step << Shaman
    .goto 1411/1,-4000.80,-270.00
    >>South along the river to Telf Joolam's camp
    .turnin -1524 >> Turn in Call of Fire
    .accept 1525,2,1524 >> Accept Call of Fire
    .turnin -1525 >> Turn in Call of Fire
    .accept 1526 >> Accept Call of Fire
    .target Telf Joolam

step << Shaman
    .goto 1411/1,-4022.40,-243.90
    >>Climb the Shrine of the Eternal Flame beside the camp: defeat the Minor Manifestation of Fire, then set the Glowing Ember in the brazier at the top
    .complete 1526,1
    .turnin -1526 >> Turn in Call of Fire
    .mob Minor Manifestation of Fire

step << Shaman
    .goto 1411/1,-4022.40,-243.90
    >>Take Call of Fire at Brazier of the Dormant Flame
    .accept 1527,2,1526 >> Accept Call of Fire

step << Shaman
    .goto 1413/1,-3054.90,269.00
    >>Back over the river to Kranal -- FIRE TOTEM (Searing Totem comes with it; pick up the rest at your next trainer stop)
    .turnin -1527 >> Turn in Call of Fire
    .target Kranal Fiss

step << Shaman
    .goto 1413/1,-2672.80,-544.70,100,0
    >>Head back to the Crossroads (Tauren: your hearth is Thunder Bluff -- just ride, it's five minutes)

step
    .goto 1413/1,-2875.43,-52.24,50,0
    >>Razormane camps north: 8 Water Seekers, 8 Thornweavers, 3 Hunters
    .goto 1413/1,-3001.08,-117.78,50,0
    .goto 1413/1,-2899.75,-209.66,50,0
    .complete 871,1 --Razormane Water Seeker (8)
    .complete 871,2 --Razormane Thornweaver (8)
    .complete 871,3 --Razormane Hunter (3)
    .mob Razormane Water Seeker
    .mob Razormane Thornweaver
    .mob Razormane Hunter

step
    #label Beaks
    .goto 1413/1,-2771.06,-306.95,80,0
    >>Finish the 7 beaks on the plains around the Crossroads
    .goto 1413/1,-2494.42,-485.32,80,0
    .complete 844,1 --Plainstrider Beak (7)
    .mob Greater Plainstrider
    .mob Fleeting Plainstrider

step
    .goto 1413/1,-2670.74,-482.61
    >>The Crossroads: Sergra
    .turnin 844 >> Turn in Plainstrider Menace
    .accept 845 >> Accept The Zhevra
    .target Sergra Darkthorn

step
    .goto 1413/1,-2595.75,-473.15
    >>Thork
    .turnin 871 >> Turn in Disrupt the Attacks
    .accept 872 >> Accept The Disruption Ends
    .target Thork

step
    .goto 1413/1,-2607.91,-475.18
    >>Darsok Swiftdagger atop the tower
    .accept 867 >> Accept Harpy Raiders
    .target Darsok Swiftdagger

step << Warrior
    #optional
    .goto 1413/1,-2697.08,-461.67
    >>Lizzarik the wandering arms dealer sometimes stops at the Crossroads -- his Iron Spiked Mace is a steal if he's in
    .target Lizzarik
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<12.5

step
    .goto 1413/1,-3127.75,-55.62,50,0
    >>Southwest Razormane grounds: 8 Geomancers, 8 Defenders, and a Crossroads' Supply Crate on the ground
    .goto 1413/1,-3382.10,-54.27,50,0
    .complete 872,1 --Razormane Geomancer (8)
    .complete 872,2 --Razormane Defender (8)
    .complete 5041,1 --Crossroads' Supply Crate
    .mob Razormane Geomancer
    .mob Razormane Defender

step
    .goto 1413/1,-3324.34,-217.09
    >>Kreenig Snarlsnout squeals last
    .complete 872,3 --Kreenig Snarlsnout's Tusk
    .mob Kreenig Snarlsnout

step << Orc/Troll
    #optional
    .isOnQuest 924
    .goto 1413/1,-3851.27,-526.53,100,0
    >>Zhevra Runners roam south -- 4 hooves on the way to Ratchet
    .complete 845,1 --Zhevra Hooves (4)
    .mob Zhevra Runner

step << Orc/Troll
    #optional
    .isQuestComplete 924
    .goto 1413/1,-3694.20,256.52
    >>Swing past Far Watch: Ak'Zeloth takes the seed's ashes
    .turnin 924 >> Turn in The Demon Seed
    .target Ak'Zeloth

step
    .goto 1413/1,-3767.80,-842.90
    >>South to Ratchet: Wrenix the Wretched
    .accept 97253 >> Accept Parts and Pieces
    .target Wrenix the Wretched

step
    .goto 1413/1,-3728.66,-835.29
    >>Gazlowe on the hill
    .accept 887 >> Accept Southsea Freebooters
    .target Gazlowe

step
    .goto 1413/1,-3770.20,-898.12
    >>Bragok at the dock
    .fp Ratchet >> Get the Ratchet flight path
    .target Bragok

step
    .goto 1413/1,-3759.06,-902.18
    >>Sputtervalve, and the wanted poster by the pier
    .accept 894 >> Accept Samophlange
    .target Sputtervalve

step
    .goto 1413/1,-3719.54,-919.07
    >>Take WANTED: Baron Longshore at WANTED
    .accept 895 >> Accept WANTED: Baron Longshore

step << Warrior
    .goto 1413/1,-3684.07,-919.74
    >>Ironzar sells your next two-hander -- Espadon for Undead/Skyborne (~64s), Bearded Axe for Orcs (~53s), Gnarled Staff for Trolls (~55s), Rock Hammer for Tauren (~63s); equip it at 16 when your skill allows
    .collect 2024,1 --Espadon << Undead/Skyborne
    .collect 2025,1 --Bearded Axe << Orc
    .collect 2030,1 --Gnarled Staff << Troll
    .collect 2026,1 --Rock Hammer << Tauren
    .target Ironzar
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<12.5

step
    .goto 1413/1,-3687.11,-981.22
    >>Brewmaster Drohn behind the inn
    .turnin 819 >> Turn in Chen's Empty Keg
    .accept 821 >> Accept Chen's Empty Keg
    .target Brewmaster Drohn

step << Orc Rogue
    #optional
    >>ROGUE: Objective: Tazan's Satchel
    .complete 1963,1 --Tazan's Satchel (1)
    .unitscan Tazan

step << Orc Rogue
    #loop
    .goto 1413/1,-3895.600,-1365.000,0
    >>ROGUE: Objective: Tazan's Satchel
    .goto 1413/1,-3677.99,-1392.00,50,0
    .goto 1413/1,-3895.600,-1365.000,50,0
    .goto 1413/1,-3826.300,-1487.300,50,0
    .complete 1963,1 --Tazan's Satchel (1)
    .unitscan Tazan

step
    #sticky
    #completewith TurnIn43
    >>Southsea pirates south of Ratchet: 12 Brigands and 6 Cannoneers
    .complete 887,1 --Southsea Brigand (12)
    .complete 887,2 --Southsea Cannoneer (6)
    .mob Southsea Brigand
    .mob Southsea Cannoneer

step
    .goto 1413/1,-3657.70,-1435.50,40,0
    >>Handfuls of Complicated Parts lie around the pirate camps: 5
    .goto 1413/1,-3680.10,-1593.00,40,0
    .complete 97253,1 --Handful of Complicated Parts (5)

step
    #label Baron
    .goto 1413/1,-3883.70,-1572.40,50,0
    >>Baron Longshore idles in one of the cove camps
    .goto 1413/1,-3818.84,-1707.52,50,0
    .goto 1413/1,-3724.60,-1746.71,50,0
    .complete 895,1 --Baron Longshore's Head
    .unitscan Baron Longshore

step
    #optional
    .isOnQuest 887
    .goto 1411/1,-3852.28,-1420.38
    >>Still short on Southsea Brigand? Southsea Brigand -- around here. This step skips itself once you have them
    .complete 887,1 --Southsea Brigand (12)
    .mob Southsea Brigand

step
    #optional
    .isOnQuest 887
    .goto 1411/1,-3851.27,-1519.02
    >>Still short on Southsea Cannoneer? Southsea Cannoneer -- around here. This step skips itself once you have them
    .complete 887,2 --Southsea Cannoneer (6)
    .mob Southsea Cannoneer

step
    #label TurnIn43
    .goto 1413/1,-3728.66,-835.29
    >>Ratchet: Gazlowe
    .turnin 887 >> Turn in Southsea Freebooters
    .turnin 895 >> Turn in WANTED: Baron Longshore
    .accept 890 >> Accept The Missing Shipment
    .target Gazlowe

step
    .goto 1413/1,-3767.80,-842.90
    >>Wrenix
    .turnin 97253 >> Turn in Parts and Pieces
    .target Wrenix the Wretched

step
    .goto 1413/1,-3796.55,-985.28
    >>Wharfmaster Dizzywig on the pier
    .turnin 1492 >> Turn in Wharfmaster Dizzywig
    .turnin 890 >> Turn in The Missing Shipment
    .accept 892 >> Accept The Missing Shipment
    .accept 896 >> Accept Miner's Fortune
    .target Wharfmaster Dizzywig

step
    .goto 1413/1,-3728.66,-835.29
    >>Gazlowe
    .turnin 892 >> Turn in The Missing Shipment
    .accept 888 >> Accept Stolen Booty
    .target Gazlowe

step << !Tauren
    .goto 1413/1,-3770.20,-898.12
    >>Bragok
    .fly Crossroads >> Fly to the Crossroads
    .target Bragok

step
    .goto 1413/1,-2832.87,-990.01,80,0
    >>Zhevra Runners between Ratchet and the Crossroads: finish the 4 hooves
    .goto 1413/1,-2392.07,-900.83,80,0
    .complete 845,1 --Zhevra Hooves (4)
    .mob Zhevra Runner

step << Tauren
    .hs >> Hearth to Thunder Bluff -- time to cash the banked flight errand

step << Tauren
    .goto 1456/1,40.72,-1238.97
    >>Ahanu by the lift
    .turnin 6362 >> Turn in Ride to Thunder Bluff
    .accept 6363 >> Accept Tal the Wind Rider Master
    .target Ahanu

step << Tauren Warrior
    .goto 1456/1,-81.09,-1457.74
    >>Torm Ragetotem on Hunter Rise trains warriors
    .trainer >> Train your class abilities
    .target Torm Ragetotem

step << Tauren
    .goto 1456/1,26.10,-1196.66
    >>Tal
    .turnin 6363 >> Turn in Tal the Wind Rider Master
    .accept 6364 >> Accept Return to Jahan
    .fly Crossroads >> Fly to the Crossroads
    .target Tal

step << Tauren
    .goto 1413/1,-2566.36,-350.19
    >>Jahan Hawkwing
    .turnin 6364 >> Turn in Return to Jahan
    .target Jahan Hawkwing

step << Tauren
    .goto 1413/1,-2645.40,-406.94
    >>Boorand: move home here
    .home >> Set your Hearthstone to the Crossroads
    .target Innkeeper Boorand Plainswind

step
    .goto 1413/1,-2595.75,-473.15
    >>Thork
    .turnin 5041 >> Turn in Supplies for the Crossroads
    .turnin 872 >> Turn in The Disruption Ends
    .target Thork

step
    .goto 1413/1,-2669.72,-481.94
    >>Sergra
    .turnin 845 >> Turn in The Zhevra
    .accept 903 >> Accept Prowlers of the Barrens
    .target Sergra Darkthorn

step
    #sticky
    #completewith StonetalonBorder
    >>Once Chen's keg is in hand, plainstriders also drop 5 Kidneys and Savannah cats 5 Lion Tusks -- they'll fill as you go
    .complete 821,2 --Plainstrider Kidney (5)
    .complete 821,1 --Savannah Lion Tusk (5)

step
    .goto 1413/1,-1972.55,-306.95
    >>North to Regthar Deathgate's bunker
    .accept 850 >> Accept Kolkar Leaders
    .accept 855 >> Accept Centaur Bracers
    .target Regthar Deathgate

step
    #sticky
    #completewith BracersDone
    >>Every Kolkar centaur can drop Centaur Bracers: 15 (finish whenever -- don't force it)
    .complete 855,1 --Centaur Bracers (15)

step
    .goto 1413/1,-1943.16,89.64
    >>Dive to the glowing fissure under the Forgotten Pools
    .complete 870,1 --Explore the Forgotten Pools

step
    .goto 1413/1,-1716.18,23.43
    >>Barak Kodobane hits like a wagon and keeps a Wrangler with a net -- pull carefully
    .complete 850,1 --Kodobane's Head
    .mob Barak Kodobane

step
    .goto 1413/1,-1972.55,-306.95
    >>Regthar
    .turnin 850 >> Turn in Kolkar Leaders
    .accept 851 >> Accept Verog the Dervish
    .target Regthar Deathgate

step
    .goto 1413/1,-1562.15,-29.94,50,0
    >>North plains: Savannah Prowlers carry 7 claws
    .goto 1413/1,-1483.11,66.67,50,0
    .complete 903,1 --Prowler Claws (7)
    .mob Savannah Prowler

step
    .goto 1413/1,-1583.43,322.73,60,0
    >>The harpy canyons: 8 Witchwing Talons
    .goto 1413/1,-1555.06,545.69,60,0
    .complete 867,1 --Witchwing Talon (8)
    .mob Witchwing Harpy
    .mob Witchwing Roguefeather

step
    .goto 1413/1,-1812.50,790.00
    >>Vrang Wildgore camps east of the canyon
    .accept 95494 >> Accept Bruised Pride and Lion Hides
    .accept 95507 >> Accept Vrang's Game
    .target Vrang Wildgore

step
    .goto 1413/1,-1937.50,480.00,50,0
    >>Savannah Patriarchs in the valley: 6 Lion Hides, and spring the 8 Hunting Traps on the ground
    .goto 1413/1,-1960.60,653.70,50,0
    .goto 1413/1,-1871.60,653.70,50,0
    .complete 95494,1 --Savannah Lion Hide (6)
    .complete 95507,1 --Trapped Game (8)
    .mob Savannah Patriarch

step
    .goto 1413/1,-1812.60,789.80
    >>Vrang
    .turnin 95494 >> Turn in Bruised Pride and Lion Hides
    .turnin 95507 >> Turn in Vrang's Game
    .accept 95495 >> Accept The Hermit Tanner
    .target Vrang Wildgore

step
    .goto 1413/1,-1643.90,786.00,25,0
    >>Up the mountain trail: Walton the tanner
    .goto 1413/1,-1635.40,838.90
    .turnin 95495 >> Turn in The Hermit Tanner
    .accept 95621 >> Accept Trouble in the Valley
    .target Walton

step
    .goto 1413/1,-1611.50,549.00
    >>Corporal Adamore holds the Kul Tiran camp below -- watch the adds
    .complete 95621,1 --Learn why the Kul Tirans are here
    .mob Corporal Adamore

step
    .goto 1413/1,-1635.50,838.90
    >>Walton again -- his follow-up runs a roleplay fight; stand behind the house and let Vrang's muscle do the work
    .turnin 95621 >> Turn in Trouble in the Valley
    .accept 95508 >> Accept Unwelcome Guests
    .complete 95508,1 --Assist Walton
    .turnin 95508 >> Turn in Unwelcome Guests
    .target Walton
    .mob Terry Longdrink

step
    .goto 1413/1,-2686.95,825.40
    >>South to the Samophlange console: the chain is all valves
    .turnin 894 >> Turn in Samophlange
    .accept 900 >> Accept Samophlange
    .goto 1413/1,-2686.95,842.29
    .complete 900,1 --Main Control Valve (two guards spawn)
    .goto 1413/1,-2675.80,842.29
    .complete 900,3 --Regulator Valve (one guard)
    .goto 1413/1,-2679.86,830.80
    .complete 900,2 --Fuel Control Valve

step
    .goto 1413/1,-2686.95,825.40
    >>The console again, then Tinkerer Sniggles for the key
    .turnin 900 >> Turn in Samophlange
    .accept 901 >> Accept Samophlange

step
    .goto 1413/1,-2731.54,909.85
    >>Console Key
    .complete -901,1 --Console Key
    .mob Tinkerer Sniggles

step
    .goto 1413/1,-2686.95,825.40
    >>Once more to the console
    .turnin 901 >> Turn in Samophlange
    .accept 902 >> Accept Samophlange

step
    #label Raptors
    .goto 1413/1,-2879.48,781.48,90,0
    >>Sunscale grounds east: finish the 12 Raptor Heads and 7 Prowler Claws
    .goto 1413/1,-2909.88,484.21,90,0
    .complete 869,1 --Raptor Head (12)
    .complete 903,1 --Prowler Claws (7)
    .mob Sunscale Lashtail
    .mob Sunscale Screecher
    .mob Savannah Prowler

step << Druid
    .goto 1413/1,-2672.80,-544.70,80,0
    >>Druids -- you're 14: the poison-cure chain. Fly to Thunder Bluff first
    .fly Thunder Bluff >> Fly to Thunder Bluff

step << Druid
    .goto 1456/1,-280.30,-1039.30
    >>Turak on Elder Rise
    .accept 6126 >> Accept Lessons Anew
    .target Turak Runetotem

step << Druid
    .goto Moonglade,56.2,30.6
    >>Teleport: Moonglade -- Dendrite Starblaze again
    .turnin 6126 >> Turn in Lessons Anew
    .accept 6127 >> Accept The Principal Source
    .target Dendrite Starblaze

step << Druid
    .goto Moonglade,48.0,67.0
    >>Druid flight back to Thunder Bluff, then wing on to the Crossroads
    .fly Thunder Bluff >> Fly to Thunder Bluff

step << Druid
    .goto 1456/1,28.70,-1198.40
    .fly Crossroads >> Fly to the Crossroads

step << Druid
    .goto 1413/1,-2099.20,491.30
    >>Up Dreadmist Peak: fill the sampler at the pool on the summit
    .complete 6127,1

step << Druid
    .goto 1413/1,-2672.80,-544.70
    >>Tonga Runetotem at the south gate takes the sample. His cure wants 5 Kodo Horns (any Barrens kodo) and 5 Earthroot (herbalists gather it; otherwise trade or auction)
    .turnin 6127 >> Turn in The Principal Source
    .accept 6128 >> Accept Gathering the Cure
    .collect 15852,5,6128 --Kodo Horn (5)
    .collect 2449,5,6128 --Earthroot (5)
    .target Tonga Runetotem

step << Druid
    .goto 1413/1,-2672.80,-544.70
    >>Tonga brews the salve
    .turnin 6128 >> Turn in Gathering the Cure
    .accept 6129 >> Accept Curing the Sick
    .target Tonga Runetotem

step << Druid
    .goto 1413/1,-2443.80,-279.10
    >>Use the Curative Animal Salve on 10 Sickly Gazelles -- they limp among the herds across the northern flats
    .complete 6129,1

step << Druid
    .goto Moonglade,56.2,30.6
    >>Teleport: Moonglade once more (still cooling down? Carry on with the chapter and make this hop when it's up)
    .turnin 6129 >> Turn in Curing the Sick
    .accept 6130 >> Accept Power over Poison
    .target Dendrite Starblaze

step << Druid
    .goto Moonglade,48.0,67.0
    .fly Thunder Bluff >> Fly to Thunder Bluff

step << Druid
    .goto 1456/1,-280.30,-1039.30
    >>Turak -- CURE POISON is yours
    .turnin 6130 >> Turn in Power over Poison
    .target Turak Runetotem

step << Druid
    .goto 1456/1,28.70,-1198.40
    .fly Crossroads >> Fly back to the Crossroads and pick up where you left off

step
    #optional
    .goto 1413/1,-3102.42,1105.78
    >>Worth grinding to 16 here -- the next three quests bite
    .xp 16

step
    .goto 1413/1,-3104.44,1109.16
    >>The Sludge Fen: Wizzlecrank's Shredder idles on the platform (long respawn -- skip if camped)
    .accept 858 >> Accept Ignition
    .target Wizzlecrank's Shredder

step
    .goto 1413/1,-3086.20,1055.78
    >>Supervisor Lugwizzle patrols the platform above -- his key starts the engine
    >>Watch for Foreman Grills and the Sludge Beast, strong rare spawns
    .complete 858,1 --Ignition Key
    .mob Supervisor Lugwizzle

step
    .goto 1413/1,-3104.44,1109.16
    >>Back at the Shredder: full health before you turn the key, it starts an escort
    .turnin 858 >> Turn in Ignition
    .accept 863 >> Accept The Escape
    .target Wizzlecrank's Shredder

step
    .goto 1413/1,-3031.48,1088.21,30,0
    >>Walk the Shredder out -- mercenaries jump you on the high ground, and an overseer caps the roleplay
    .goto 1413/1,-3002.10,1130.78
    .complete 863,1 --Escort Wizzlecrank
    .mob Venture Co. Mercenary
    .mob Venture Co. Drudger
    .mob Overseer Glibby

step
    .goto 1413/1,-3605.03,1308.47,40,0
    >>The Boulder Lode Mine: Venture Co. Enforcers and Overseers drop the Cat's Eye Emerald (rare -- give up after ~25 kills if unlucky)
    .goto 1413/1,-3644.55,1249.69,40,0
    .complete 896,1 --Cat's Eye Emerald
    .mob Venture Co. Enforcer
    .mob Venture Co. Overseer

step
    .goto 1414/1,-3839.37,1644.65,60,0
    >>West into Orgrimmar through the back road

step << Orc/Troll
    .goto 1454/1,-4439.37,1633.99
    >>Innkeeper Gryshka: the meat arrives, the XP banks pay out
    .turnin 6384 >> Turn in Ride to Orgrimmar
    .accept 6385 >> Accept Doras the Wind Rider Master
    .target Innkeeper Gryshka

step << Orc/Troll
    .goto 1454/1,-4313.46,1676.25
    >>Doras
    .turnin 6385 >> Turn in Doras the Wind Rider Master
    .accept 6386 >> Accept Return to the Crossroads
    .target Doras

step << Tauren/Undead
    .goto 1454/1,-4313.60,1676.24
    >>Doras -- grab the flight point, fly nowhere
    .fp Orgrimmar >> Get the Orgrimmar flight path
    .target Doras

step << Warrior
    .goto 1454/1,-4801.42,1980.53
    >>Grezz Ragefist in the Valley of Honor
    .trainer >> Train your class abilities
    .target Grezz Ragefist

step << Warrior !Skyborne
    .goto 1454/1,-4824.00,2090.54
    >>Hanashi broadens your arsenal
    .train 197 >> Train Two-Handed Axes
    .train 227 >> Train Staves
    .target Hanashi

step << Warrior
    .goto 1454/1,-4819.10,2099.05
    >>Zendo'jian sells the Battle Axe (~1g 2s) -- your weapon through 20; buy when gold allows
    .collect 926,1 --Battle Axe
    .target Zendo'jian
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<15.2

step
    .goto 1454/1,-4226.78,1914.77
    >>Zor Lonetree by Grommash Hold -- Stonetalon calls
    .accept 1061 >> Accept The Spirits of Stonetalon
    .target Zor Lonetree

step << Rogue
    .goto 1454/1,-4284.42,1771.28
    >>ROGUE: Train at your class trainer; take Zando'zan at Shenthul
    .train 1804
    .train 921
    .accept 2379 >> Accept Zando'zan
    .target Shenthul

step << Orc Rogue
    .goto 1454/1,-4280.07,1772.96
    >>ROGUE: Hand in The Shattered Hand; take The Shattered Hand at Therzok
    .turnin 1963 >> Turn in The Shattered Hand
    .accept 1858 >> Accept The Shattered Hand
    .target Therzok

step << Rogue
    .goto 1454/1,-4279.79,1778.57
    >>ROGUE: Hand in Zando'zan; take Wrenix of Ratchet at Zando'zan
    .turnin 2379 >> Turn in Zando'zan
    .accept 2382 >> Accept Wrenix of Ratchet
    .target Zando'zan

step << Orc Rogue
    #optional
    #completewith next
    .goto 1454/1,-4271.1,1810.75
    >>ROGUE: Objective: Thieves' Tools
    .collect 5060,1,1858,1 --Collect Thieves' Tools (1)
    .target Rekkul
    .money <0.15

step << Orc Rogue
    .goto 1454/1,-4280.07,1773.24
    >>ROGUE: Objective: Tazan's Logbook
    .complete 1858,1 --Tazan's Logbook (1)
    .money <0.15

step << Orc Rogue
    .goto 1454/1,-4280.07,1772.96
    >>ROGUE: Hand in The Shattered Hand at Therzok
    .turnin 1858 >> Turn in The Shattered Hand
    .target Therzok

step << Orc Rogue
    .goto 1454/1,-4437.87,1637.33
    >>ROGUE: Objective: Tazan's Key; Tazan's Logbook
    .collect 7208,1,1858,1 --Tazan's Key
    .complete 1858,1 --Tazan's Logbook (1)
    .isOnQuest 1858

step
    .hs >> Hearth to the Crossroads

step
    .goto 1413/1,-2639.32,-436.00
    >>Gazrog, heads in hand
    .turnin 869 >> Turn in Raptor Thieves
    .accept 3281 >> Accept Stolen Silver
    .target Gazrog

step
    .goto 1413/1,-2607.91,-475.18
    >>Darsok up the tower
    .turnin 867 >> Turn in Harpy Raiders
    .accept 875 >> Accept Harpy Lieutenants
    .target Darsok Swiftdagger

step
    .goto 1413/1,-2641.35,-521.12
    >>Mankrik by the south gate
    .accept 899 >> Accept Consumed by Hatred
    .accept 4921 >> Accept Lost in Battle
    .target Mankrik

step
    .goto 1413/1,-2672.76,-544.77
    >>Tonga
    .turnin 870 >> Turn in The Forgotten Pools
    .accept 877 >> Accept The Stagnant Oasis
    .target Tonga Runetotem

step
    .goto 1413/1,-2670.74,-482.61
    >>Sergra
    .turnin 903 >> Turn in Prowlers of the Barrens
    .accept 881 >> Accept Echeyakee
    .target Sergra Darkthorn

step << Orc/Troll
    .goto 1413/1,-2709.24,-404.24
    >>Zargh closes the meat run
    .turnin 6386 >> Turn in Return to the Crossroads
    .target Zargh

step
    #optional
    .goto 1413/1,-2711.80,-350.50
    >>OPTIONAL group quest: Gur'ak's bounty on Chol'aruk the Ravener, a 5-man cave elite worth 4100 XP. Take it only if you have a group -- the guide offers the turn-in on later Crossroads visits; abandon it if you never get to it
    .accept 97003 >> Accept Chol'aruk the Ravener
    .target Gur'ak

step
    .goto 1413/1,-3031.48,461.91
    >>Blow the Horn of Echeyakee at the bone pile and take the white mist-saber's hide
    .complete 881,1 --Echeyakee's Hide
    .mob Echeyakee
    .use 10327

step
    .goto 1413/1,-2670.74,-482.61
    >>Sergra
    .turnin 881 >> Turn in Echeyakee
    .accept 905 >> Accept The Angry Scytheclaws
    .target Sergra Darkthorn

step << Rogue
    .goto 1413/1,-3767.800,-842.900
    >>ROGUE: Hand in Wrenix of Ratchet; take Plundering the Plunderers at Wrenix the Wretched
    .turnin 2382 >> Turn in Wrenix of Ratchet
    .accept 2381 >> Accept Plundering the Plunderers
    .target Wrenix the Wretched

step
    .goto 1413/1,-2595.75,-437.35
    >>Devrak
    .fly Ratchet >> Fly to Ratchet
    .target Devrak

step
    .goto 1413/1,-3759.06,-902.18
    >>Sputtervalve
    .turnin 902 >> Turn in Samophlange
    .turnin 863 >> Turn in The Escape
    .accept 1483 >> Accept Ziz Fizziks
    .target Sputtervalve

step << Hunter
    .goto 1413/1,-3759.06,-902.18
    >>HUNTER: Take Wenikee Boltbucket at Sputtervalve
    .accept 3921 >> Accept Wenikee Boltbucket
    .target Sputtervalve
    .isQuestComplete 863

step << Hunter
    #optional
    .goto 1413/1,-3759.06,-902.18
    >>HUNTER: Take Wenikee Boltbucket at Sputtervalve
    .accept 3921 >> Accept Wenikee Boltbucket
    .target Sputtervalve

step
    .goto 1413/1,-3796.55,-985.28
    >>Dizzywig, if the emerald dropped
    .turnin 896 >> Turn in Miner's Fortune
    .target Wharfmaster Dizzywig

step
    .goto 1413/1,-3697.24,-929.20
    >>Mebok Mizzyrix
    .accept 865 >> Accept Raptor Horns
    .accept 1069 >> Accept Deepmoss Spider Eggs
    .target Mebok Mizzyrix

step << Rogue
    .goto 1413/1,-3958.68,-1457.54
    >>ROGUE: Objective: Southsea Treasure -- Polly
    .complete 2381,1 --Southsea Treasure (1)
    .use 7970
    .mob Polly

step
    .goto 1413/1,-3819.86,-1714.95
    >>Back to the pirate coves: the Telescopic Lens at the far camp...
    .complete 888,2 --Telescopic Lens

step
    .goto 1413/1,-3723.59,-1741.30
    >>...and the Shipment of Boots at the near one
    .complete -888,1 --Shipment of Boots

step
    #sticky
    >>Sunscale Scytheclaws drop 5 Intact Raptor Horns and the Sunscale Feathers the nests need -- they Thrash, so keep your health up
    .complete 865,1 --Intact Raptor Horn (5)
    .collect 5165,3,905 --Sunscale Feather (3)
    .mob Sunscale Scytheclaw

step
    .goto 1413/1,-3258.47,-2027.09
    >>The Stolen Silver chest hides in the raptor grounds' southern den
    .complete 3281,1 --Stolen Silver

step
    .goto 1413/1,-3012.23,-1275.80
    >>Dive to the fissure under the Stagnant Oasis and plant the seeds
    .complete 877,1 --Test the Dried Seeds

step
    .goto 1413/1,-3029.46,-1324.44,30,0
    >>Fungal Spores sprout around the oasis: 4
    .goto 1413/1,-3000.07,-1208.23,30,0
    .complete 848,1 --Fungal Spores (4)

step
    .goto 1413/1,-2742.68,-1208.23
    >>Kolkar kills around the oasis can spawn Verog the Dervish -- camp his point if the server's crowded
    .complete 851,1 --Verog's Head
    .unitscan Verog the Dervish
    .mob Kolkar Bloodcharger
    .mob Kolkar Marauder

step
    .goto 1413/1,-2707.22,-1502.13
    >>The three raptor nests east: blue...
    .complete 905,1 --Blue Raptor Nest

step
    .goto 1413/1,-2692.02,-1533.89
    >>...red...
    .complete -905,3 --Red Raptor Nest

step
    #label Nests
    .goto 1413/1,-2648.44,-1527.13
    >>...and yellow
    .complete -905,2 --Yellow Raptor Nest

step
    .goto 1413/1,-2375.86,-1787.24
    >>The Beaten Corpse on the southern road answers Mankrik's dread
    .complete 4921,1 --Find Mankrik's Wife
    .target Beaten Corpse

step
    #sticky
    #completewith TurnIn126
    >>Lakota'mani the great thunder lizard roams here (4 spawn points) -- his hoof starts a quest if you can take him
    .collect 5099,1,883 --Hoof of Lakota'mani
    .accept 883 >> Accept Lakota'mani
    .use 5099
    .unitscan Lakota'mani

step
    #label Taurajo
    .goto 1413/1,-1995.86,-2376.39
    >>Camp Taurajo: Innkeeper Byula
    .home >> Set your Hearthstone to Camp Taurajo
    .target Innkeeper Byula

step
    #optional
    .isOnQuest 883
    .goto 1412/1,-2160.02,-1873.73
    >>Still short on Hoof of Lakota'mani? Lakota'mani -- around here. This step skips itself once you have them
    .collect 5099,1,883 --Hoof of Lakota'mani
    .mob Lakota'mani

step
    #label TurnIn126
    .isOnQuest 883
    .goto 1413/1,-1921.88,-2383.15
    >>Jorn Skyseer, if Lakota'mani fell
    .turnin -883 >> Turn in Lakota'mani
    .target Jorn Skyseer

step
    .goto 1413/1,-1891.48,-2391.93
    >>Mangletooth in the cage
    .accept 878 >> Accept Tribes at War
    .target Mangletooth

step
    .goto 1413/1,-1881.35,-2384.50
    >>Omusa
    .fp Camp Taurajo >> Get the Camp Taurajo flight path << !Tauren
    .fly Crossroads >> Fly to the Crossroads
    .target Omusa Thunderhorn

step
    #optional
    .isQuestComplete 97003
    .goto 1413/1,-2711.80,-350.50
    >>Gur'ak pays the Chol'aruk bounty
    .turnin 97003 >> Turn in Chol'aruk the Ravener
    .target Gur'ak
step
    #optional
    .isOnQuest 905
    .goto 1412/1,-3157.14,-1968.99
    >>Still short on Sunscale Feather? Sunscale Scytheclaw -- around here. This step skips itself once you have them
    .collect 5165,3,905 --Sunscale Feather (3)
    .mob Sunscale Scytheclaw

step
    .goto 1413/1,-2641.35,-521.12
    >>The Crossroads round: Mankrik, Tonga, Sergra, Gazrog
    .turnin 4921 >> Turn in Lost in Battle
    .accept 95774 >> Accept Her Name Is Olgra
    .target Mankrik

step
    .goto 1413/1,-2672.76,-544.77
    >>Hand in The Stagnant Oasis; take Altered Beings at Tonga Runetotem
    .turnin -877 >> Turn in The Stagnant Oasis
    .accept 880,2,877 >> Accept Altered Beings
    .target Tonga Runetotem

step
    .goto 1413/1,-2670.74,-482.61
    >>Hand in The Angry Scytheclaws; take Jorn Skyseer at Sergra Darkthorn
    .turnin -905 >> Turn in The Angry Scytheclaws
    .accept 3261,2,905 >> Accept Jorn Skyseer
    .target Sergra Darkthorn

step
    .goto 1413/1,-2639.32,-436.00
    >>Hand in Stolen Silver at Gazrog
    .turnin -3281 >> Turn in Stolen Silver
    .target Gazrog

step
    #optional
    .isQuestComplete 97003
    .goto 1413/1,-2711.80,-350.50
    >>Gur'ak pays the Chol'aruk bounty
    .turnin 97003 >> Turn in Chol'aruk the Ravener
    .target Gur'ak
step
    .goto 1413/1,-2589.67,-424.51
    >>Helbrim
    .turnin 848 >> Turn in Fungal Spores
    .target Apothecary Helbrim

step
    .goto 1413/1,-1972.55,-306.95
    >>Regthar
    .turnin 851 >> Turn in Verog the Dervish
    .accept 852 >> Accept Hezrul Bloodmark
    .target Regthar Deathgate

step
    .goto 1413/1,-2052.60,-877.18,50,0
    >>Hezrul Bloodmark stalks the Lushwater Oasis ring -- Snapjaws here also carry Tonga's shells
    .goto 1413/1,-2261.35,-1060.95,50,0
    .goto 1413/1,-2124.55,-1228.50,50,0
    .complete 852,1 --Hezrul's Head
    .complete -880,1 --Altered Snapjaw Shell (8)
    .unitscan Hezrul Bloodmark
    .mob Oasis Snapjaw

step
    #optional
    .isOnQuest 855
    .goto 1411/1,-2018.15,-979.20
    >>Still short on Centaur Bracers? Barak Kodobane / Brokespear / Hezrul Bloodmark -- around here. This step skips itself once you have them
    .complete 855,1 --Centaur Bracers (15)
    .mob Barak Kodobane
    .mob Brokespear
    .mob Hezrul Bloodmark
    .mob Kolkar Bloodcharger

step
    #label BracersDone
    .goto 1413/1,-1972.55,-306.95
    >>Regthar -- bracers too if the count's in; his last call is Counterattack!, a lvl-20 elite warlord with guards. Group up or kite him around the bunker, or skip it for now
    .turnin 852 >> Turn in Hezrul Bloodmark
    .turnin 855 >> Turn in Centaur Bracers
    .accept 4021 >> Accept Counterattack!
    .target Regthar Deathgate

step
    #optional
    .isOnQuest 4021
    .goto 1413/1,-1884.39,-289.38
    >>Warlord Krom'zar rides in after a few minutes -- take the banner piece he drops
    .complete 4021,1 --Piece of Krom'zar's Banner
    .unitscan Warlord Krom'zar

step
    #optional
    .isQuestComplete 4021
    .goto 1413/1,-1972.55,-306.95
    >>Regthar
    .turnin 4021 >> Turn in Counterattack!
    .target Regthar Deathgate

step
    .goto 1413/1,-1379.75,620.68,40,0
    >>Deep in the harpy canyon: Witchwing Slayers drop 6 Lieutenant Rings -- they Execute low targets, and stealthed Ambushers patrol
    .goto 1413/1,-1245.99,763.91,40,0
    .goto 1413/1,-1263.22,458.53,40,0
    .complete 875,1 --Harpy Lieutenant Ring (6)
    .mob Witchwing Slayer
    .mob Witchwing Ambusher

step
    #label StonetalonBorder
    .goto 1413/1,-950.10,-271.14
    >>Northwest to the Stonetalon border: Seereth Stonebreak and Makaba Flathoof
    .turnin 1061 >> Turn in The Spirits of Stonetalon
    .accept 1062 >> Accept Goblin Invaders
    .target Seereth Stonebreak
    .goto 1413/1,-943.00,-265.06
    .accept 6548 >> Accept Avenge My Village
    .target Makaba Flathoof
]])

-- ============ 17-22 STONETALON / BARRENS / ASHENVALE ================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 17-22 Stonetalon/Barrens/Ashenvale (Horde)
#next 22-25 Hillsbrad/South Barrens (Horde)
<< Horde

step
    .goto 1442/1,-718.94,65.49,40,0
    >>Into Stonetalon: Grimtotem camps flank the pass -- 8 Ruffians, 6 Mercenaries
    .goto 1442/1,-838.59,148.20,40,0
    .goto 1442/1,-774.61,-5.17,40,0
    .complete 6548,1 --Grimtotem Ruffian (8)
    .complete 6548,2 --Grimtotem Mercenary (6)
    .mob Grimtotem Ruffian
    .mob Grimtotem Mercenary

step
    .goto 1413/1,-943.00,-265.06
    >>Makaba at the border
    .turnin 6548 >> Turn in Avenge My Village
    .accept 6629 >> Accept Kill Grundig Darkcloud
    .target Makaba Flathoof

step
    .goto 1442/1,-460.13,67.77,30,0
    >>Up the path to Camp Aparaje: Grundig Darkcloud and his 6 Brutes -- clear the Brutes before the chief
    .goto 1442/1,-350.74,112.06
    .complete 6629,1 --Grundig Darkcloud
    .complete 6629,2 --Grimtotem Brute (6)
    .mob Grundig Darkcloud
    .mob Grimtotem Brute

step
    .goto 1442/1,-342.44,129.64
    >>Kaya Flathoof, caged at the back
    .accept 6523 >> Accept Protect Kaya
    .target Kaya Flathoof

step
    .goto 1442/1,-261.86,-7.12,40,0
    >>Walk Kaya out -- three Grimtotem ambush at the bonfire
    .goto 1442/1,-501.15,-41.64
    .complete 6523,1 --Kaya escorted
    .target Kaya Flathoof

step
    .goto 1442/1,-233.54,-177.42
    >>Xen'Zilla up the trail
    .accept 6461 >> Accept Blood Feeders
    .target Xen'Zilla



step
    .goto 1442/1,245.51,255.01,80,0
    >>Deepmoss Creepers along the valley road: 10
    .goto 1442/1,560.49,440.94,60,0
    .complete 6461,1 --Deepmoss Creeper (10)
    .mob Deepmoss Creeper

step
    .goto 1442/1,806.12,929.05,50,0
    >>Sun Rock Retreat: Tharm has the flight point
    .goto 1442/1,1041.99,967.80
    .fp Sun Rock Retreat >> Get the Sun Rock Retreat flight path
    .target Tharm

step
    .goto 1442/1,365.16,878.25
    >>Ziz Fizziks on the overlook
    .turnin 1483 >> Turn in Ziz Fizziks
    .accept 1093 >> Accept Super Reaper 6000
    .target Ziz Fizziks

step
    #sticky
    #completewith Eggs
    >>Deepmoss Eggs nest under the trees: 15 (hatchlings can call a level-22 Matriarch)
    .complete 1069,1 --Deepmoss Egg (15)

step
    .goto 1442/1,297.77,959.66,50,0
    >>Deepmoss Venomspitters around the web gulch: 7
    .goto 1442/1,207.91,1010.13,50,0
    .goto 1442/1,225.49,765.26,50,0
    .complete 6461,2 --Deepmoss Venomspitter (7)
    .mob Deepmoss Venomspitter

step << Warrior
    .goto 1442/1,402.76,1231.88
    >>Veenix at Windshear Crag's mouth sells upgrades -- Executioner's Sword or Dacian Falx for Undead/Skyborne (~1g 50s), Long Staff for Orc/Troll/Tauren (~99s)
    .collect 928,1 --Long Staff << Orc/Troll/Tauren
    .target Veenix
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<15.5

step
    .goto 1442/1,232.82,1239.70,100,0
    >>Windshear Crag: Venture Co. Operators drop the Super Reaper 6000 Blueprints, Loggers die 15 deep
    .goto 1442/1,-16.23,1441.59,100,0
    .goto 1442/1,-255.52,1291.80,100,0
    .complete 1093,1 --Super Reaper 6000 Blueprints
    .complete 1062,1 --Venture Co. Logger (15)
    .mob Venture Co. Operator
    .mob Venture Co. Logger

step
    #label Eggs
    .goto 1442/1,163.47,962.27,50,0
    >>Finish the 15 Deepmoss Eggs around the gulch
    .goto 1442/1,268.95,832.99,50,0
    .complete 1069,1 --Deepmoss Egg (15)

step
    .goto 1442/1,365.16,878.25
    >>Ziz
    .turnin 1093 >> Turn in Super Reaper 6000
    .accept 1094 >> Accept Further Instructions
    .target Ziz Fizziks

step
    .goto 1442/1,275.30,577.38,80,0
    >>Sweep the creepers on the way out if any remain
    .goto 1442/1,244.05,262.50,80,0
    .complete 6461,1 --Deepmoss Creeper (10)
    .mob Deepmoss Creeper

step
    .hs >> Hearth to Camp Taurajo

step
    .goto 1413/1,-1921.88,-2383.15
    >>Jorn Skyseer begins the beast hunt
    .turnin -3261 >> Turn in Jorn Skyseer
    .accept 882,2,3261 >> Accept Ishamuhale
    .target Jorn Skyseer

step << Rogue
    .goto 1413/1,-3767.800,-842.900
    >>ROGUE: Hand in Plundering the Plunderers at Wrenix the Wretched
    .turnin 2381 >> Turn in Plundering the Plunderers
    .target Wrenix the Wretched

step << Rogue
    #optional
    .goto 1413/1,-3767.800,-842.900
    >>ROGUE: Hand in Plundering the Plunderers at Wrenix the Wretched
    .turnin 2381 >> Turn in Plundering the Plunderers
    .target Wrenix the Wretched

step
    #sticky
    #completewith Shards
    >>Bristleback quilboars south drop Blood Shards -- save at least 4; Mangletooth trades buffs for them
    .collect 5075,4 --Blood Shard (4)

step
    .goto 1413/1,-2346.20,-1788.60,50,0
    >>Razormane Raiders in the ruins: 4 of Olgra's Adornments
    .goto 1413/1,-2458.30,-1824.40,50,0
    .complete 95774,1 --Olgra's Adornments (4)
    .mob Razormane Raider

step
    .goto 1413/1,-2518.74,-2125.73,60,0
    >>The Bristleback warrens: 6 Water Seekers, 12 Thornweavers, 12 Geomancers -- and Mankrik's 60 tusks fall as you go
    .goto 1413/1,-2755.86,-2082.49,60,0
    .goto 1413/1,-2687.96,-1973.04,60,0
    .complete 878,1 --Bristleback Water Seeker (6)
    .complete 878,2 --Bristleback Thornweaver (12)
    .complete 878,3 --Bristleback Geomancer (12)
    .complete 899,1 --Bristleback Quilboar Tusk (60)
    .mob Bristleback Water Seeker
    .mob Bristleback Thornweaver
    .mob Bristleback Geomancer

step
    .goto 1413/1,-2397.14,-2108.84,50,0
    >>Stormsnouts on the plain: one Thunder Lizard Horn for the keg
    .goto 1413/1,-2345.46,-2187.21,50,0
    .complete 821,3 --Thunder Lizard Horn
    .mob Stormsnout

step
    #sticky
    #completewith TurnIn28
    >>Owatanka the thunder lizard roams here too (4 spawn points) -- her tailspike starts a quest
    .collect 5102,1,884 --Owatanka's Tailspike
    .accept 884 >> Accept Owatanka
    .use 5102
    .unitscan Owatanka

step
    .goto 1413/1,-2075.00,-3380.64
    >>South of Taurajo: a camped-out bedroll with a note worth reading
    .accept 79007 >> Accept ...and that note you found
    >>The Nailed Plank right beside the remains finishes it
    .turnin 79007 >> Turn in ...and that note you found

step
    #label Owatanka
    .goto 1413/1,-1861.08,-2561.51,60,0
    >>Thunderheads and Stormsnouts around Taurajo: 3 Thunder Lizard Blood
    .goto 1413/1,-2133.67,-2590.56,60,0
    .complete -907,1 --Thunder Lizard Blood (3)
    .mob Thunderhead
    .mob Stormsnout
    .isOnQuest 907

step
    #label Shards
    .goto 1413/1,-1891.48,-2391.93
    >>Mangletooth: the tusk war, and shards for buffs (keep feeding him Blood Shards whenever you pass -- the buffs are strong)
    .turnin 878 >> Turn in Tribes at War
    .accept 5052 >> Accept Blood Shards of Agamaggan
    .turnin 5052 >> Turn in Blood Shards of Agamaggan
    .target Mangletooth

step
    .goto 1413/1,-1921.88,-2383.15
    >>Jorn
    .turnin -882 >> Turn in Ishamuhale
    .accept 907,2,882 >> Accept Enraged Thunder Lizards
    .turnin -883 >> Turn in Lakota'mani
    .target Jorn Skyseer

step
    .goto 1413/1,-1868.18,-2498.00,60,0
    >>Finish the 3 Thunder Lizard Blood if Jorn's hunt still wants them
    .goto 1413/1,-2273.51,-2456.79,60,0
    .complete -907,1 --Thunder Lizard Blood (3)
    .mob Thunderhead
    .mob Stormsnout

step
    #optional
    .isOnQuest 884
    .goto 1445/1,-1856.02,-2576.38
    >>Still short on Owatanka's Tailspike? Owatanka -- around here. This step skips itself once you have them
    .collect 5102,1,884 --Owatanka's Tailspike
    .mob Owatanka

step
    #label TurnIn28
    .goto 1413/1,-1921.88,-2383.15
    >>Jorn
    .turnin -884 >> Turn in Owatanka
    .turnin -907 >> Turn in Enraged Thunder Lizards
    .accept 913,2,907 >> Accept Cry of the Thunderhawk
    .target Jorn Skyseer

step << Hunter
    .goto 1413/1,-1921.88,-2383.15
    >>HUNTER: Take The Ashenvale Hunt at Jorn Skyseer
    .accept 6382,2,882 >> Accept The Ashenvale Hunt
    .target Jorn Skyseer
    .isOnQuest 884

step
    .goto 1413/1,-2096.18,-2531.11,60,0
    >>A Thunderhawk Hatchling or Cloudscraper gives up its wings
    .goto 1413/1,-1982.68,-2217.62,60,0
    .complete -913,1 --Thunderhawk Wings
    .mob Thunderhawk Hatchling
    .mob Thunderhawk Cloudscraper

step
    .goto 1413/1,-1921.88,-2383.15
    >>Jorn's hunt ends; Mahren waits by the sea
    .turnin -913 >> Turn in Cry of the Thunderhawk
    .accept 874,2,913 >> Accept Mahren Skyseer
    .target Jorn Skyseer

step << Hunter
    .goto 1413/1,-1921.88,-2383.15
    >>HUNTER: Take The Ashenvale Hunt at Jorn Skyseer
    .accept 6382,2,882 >> Accept The Ashenvale Hunt
    .target Jorn Skyseer

step
    #sticky
    #completewith Ishamuhale
    >>Any Zhevra Charger can drop a Fresh Zhevra Carcass -- keep one, it summons Ishamuhale (30-min timer once looted)
    .collect 10338,1 --Fresh Zhevra Carcass
    .mob Zhevra Charger

step
    #label Ishamuhale
    .goto 1413/1,-3427.70,-436.67
    >>Use the carcass at the dead tree: Ishamuhale the lion answers, and dies
    .complete -882,1 --Ishamuhale's Fang
    .mob Ishamuhale
    .use 10338

step
    .goto 1413/1,-3728.66,-835.29
    >>Ratchet is a short walk from the dead tree: Gazlowe takes his booty
    .turnin 888 >> Turn in Stolen Booty
    .target Gazlowe

step
    .goto 1413/1,-3759.06,-902.18
    >>Sputtervalve
    .turnin 1094 >> Turn in Further Instructions
    .accept 1095 >> Accept Further Instructions
    .target Sputtervalve

step
    .goto 1413/1,-3720.30,-920.00
    >>The wanted poster: Bruuz, a level-20 elite in the sea off Ratchet -- group up, or kite him to the bruisers (deal half his health yourself for credit)
    .accept 92706 >> Accept WANTED: Bruuz
    .goto 1413/1,-3951.60,-1093.50,40,0
    .complete 92706,1 --Bruuz
    .mob Bruuz

step
    .goto 1413/1,-3728.66,-835.29
    >>Gazlowe pays the bounty
    .turnin 92706 >> Turn in WANTED: Bruuz
    .target Gazlowe

step << Hunter
    .goto 1413/1,-2595.75,-473.15
    >>HUNTER: Take Report to Kadrak at Thork
    .accept 6541 >> Accept Report to Kadrak
    .target Thork

step
    .goto 1413/1,-3697.24,-929.20
    >>Mebok
    .turnin 865 >> Turn in Raptor Horns
    .turnin 1069 >> Turn in Deepmoss Spider Eggs
    .target Mebok Mizzyrix

step
    .goto 1413/1,-3687.11,-981.22
    >>Drohn fills the keg at last
    .turnin 821 >> Turn in Chen's Empty Keg
    .target Brewmaster Drohn

step << Warrior
    #optional
    .goto 1413/1,-3680.02,-982.58
    >>Grazlix sometimes stocks Ringed Chain Pants -- a solid leg upgrade (~62s)
    .target Grazlix
    .itemStat 7,ITEM_MOD_ARMOR_SHORT,<155

step
    .goto 1413/1,-3770.20,-898.12
    >>Bragok
    .fly Crossroads >> Fly to the Crossroads
    .target Bragok

step
    #optional
    .isQuestComplete 97003
    .goto 1413/1,-2711.80,-350.50
    >>Gur'ak pays the Chol'aruk bounty
    .turnin 97003 >> Turn in Chol'aruk the Ravener
    .target Gur'ak
step
    .goto 1413/1,-2641.35,-521.12
    >>Mankrik hears of Olgra; Tonga sends word to the druids
    .turnin 899 >> Turn in Consumed by Hatred
    .turnin 95774 >> Turn in Her Name Is Olgra
    .target Mankrik
    .goto 1413/1,-2672.76,-544.77
    .turnin -880 >> Turn in Altered Beings
    .accept 1489,2,880 >> Accept Hamuul Runetotem
    .accept 3301,2,880 >> Accept Mura Runetotem
    .target Tonga Runetotem

step
    .goto 1413/1,-2555.22,-387.35
    >>Korran by the kodo pens
    .accept 868 >> Accept Egg Hunt
    .target Korran

step << Warlock
    #completewith next
    .goto 1413/1,-2595.75,-437.35
    >>WARLOCK: Fly to Orgrimmar
    .fly Orgrimmar
    .zoneskip Orgrimmar
    .target Devrak

step << Warlock
    .goto 1454/1,-4357.36,1850.41
    >>WARLOCK: Train at your class trainer; take Devourer of Souls at Gan'rul Bloodeye
    .trainer >> Train at your class trainer
    .accept 1507 >> Accept Devourer of Souls
    .target Gan'rul Bloodeye

step << Warlock
    .goto 1454/1,-4347.4,1836.57
    >>WARLOCK: Objective: Grimoire of Torment (Rank 2)
    .collect 16346,1,1507,1 --Grimoire of Torment (Rank 2)
    .target Kurgul

step << Warlock
    .goto 1454/1,-4340.53,1839.19
    >>WARLOCK: Hand in Devourer of Souls; take Blind Cazul at Cazul
    .turnin 1507 >> Turn in Devourer of Souls
    .accept 1508 >> Accept Blind Cazul
    .target Cazul

step << Warlock
    .goto 1454/1,-4299.99,1820.67
    >>WARLOCK: Objective: Burning Wand
    .collect 5210,1,1507,1 --Collect Burning Wand (1)
    .money <0.5808
    .itemStat 18,QUALITY,<7
    .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<17.4
    .target Katis

step << Warlock
    .goto 1454/1,-4199.99,1717.49
    >>WARLOCK: Hand in Blind Cazul; take News of Dogran at Zankaja
    .turnin 1508 >> Turn in Blind Cazul
    .accept 1509 >> Accept News of Dogran
    .target Zankaja

step << Warlock
    .goto 1454/1,-4313.60,1676.24
    >>WARLOCK: Fly to Crossroads
    .fly Crossroads
    .zoneskip Orgrimmar,1
    .target Doras

step << Warlock
    .goto 1413/1,-2639.32,-436.00
    >>WARLOCK: Hand in News of Dogran; take News of Dogran at Gazrog
    .turnin 1509 >> Turn in News of Dogran
    .accept 1510 >> Accept News of Dogran
    .target Gazrog

step
    .goto 1413/1,-2589.67,-424.51
    >>Helbrim hands you a 45-MINUTE TIMED delivery -- it turns in at Thunder Bluff; Serena first, then straight there
    .accept 853 >> Accept Apothecary Zamah
    .target Apothecary Helbrim

step
    .goto 1413/1,-2607.91,-474.51
    >>Darsok
    .turnin 875 >> Turn in Harpy Lieutenants
    .accept 876 >> Accept Serena Bloodfeather
    .target Darsok Swiftdagger

step
    .goto 1413/1,-1345.30,790.94
    >>Serena Bloodfeather queens the canyon -- take her head
    .complete 876,1 --Serena's Head
    .mob Serena Bloodfeather

step
    .goto 1413/1,-2607.91,-474.51
    >>Darsok (hearth back if it's up)
    .turnin 876 >> Turn in Serena Bloodfeather
    .accept 1060 >> Accept Letter to Jin'Zil
    .target Darsok Swiftdagger

step
    .goto 1413/1,-2595.75,-437.35,30,0
    >>Fly to Thunder Bluff before Zamah's timer dies: she's in the Pools of Vision on Spirit Rise
    .goto 1456/1,278.48,-995.29
    .turnin 853 >> Turn in Apothecary Zamah
    .target Apothecary Zamah

step << Priest
    .goto 1456/1,252.49,-956.04
    >>PRIEST: Take Dark Sacrifice, Shadowguard at Miles Welsh; train at your class trainer
    .accept 5644 >> Accept Dark Sacrifice << Undead Priest
    .accept 5642 >> Accept Shadowguard << Troll Priest
    .trainer >> Train at your class trainer
    .target Miles Welsh

step << Warrior
    .goto 1456/1,-81.09,-1457.74
    >>Torm Ragetotem on Hunter Rise: training, and the Berserker Stance summons (banked for level 30)
    .trainer >> Train your class abilities
    .accept 1823 >> Accept Speak with Ruga
    .target Torm Ragetotem

step
    .goto 1456/1,218.68,-1028.41
    >>Clarice Foster, also in the Pools of Vision
    .accept 264 >> Accept Until Death Do Us Part
    .target Clarice Foster

step
    .goto 1456/1,-303.83,-1048.66
    >>Elder Rise: Arch Druid Hamuul Runetotem, then Nara beside him
    .turnin -1489 >> Turn in Hamuul Runetotem
    .accept 1490,2,1489 >> Accept Nara Wildmane
    .target Arch Druid Hamuul Runetotem
    .goto 1456/1,-272.93,-1069.67
    .turnin 1490 >> Turn in Nara Wildmane
    .target Nara Wildmane

step << Druid
    .goto 1456/1,-281.59,-1039.61
    >>DRUID: Train at your class trainer; take The Great Cat Spirit at Turak Runetotem
    .trainer >> Train at your class trainer
    .accept 98340 >> Accept The Great Cat Spirit
    .target Turak Runetotem

step << Druid
    #completewith next
    >>DRUID: Cast Teleport: Moonglade
    .cast 18960
    .zoneskip Moonglade

step << Druid
    .goto 1450/1,-2678.76,8019.94
    >>DRUID: Hand in The Great Cat Spirit; take The Great Windborne Cat Spirit, The Great Cat Spirit at Dendrite Starblaze
    .turnin 98340 >> Turn in The Great Cat Spirit
    .accept 98341 >> Accept The Great Windborne Cat Spirit << Skyborne
    .accept 98405 >> Accept The Great Cat Spirit << !Skyborne
    .target Dendrite Starblaze

step << Druid !Skyborne
    .goto 1450/1,-2640.000,7338.900
    >>DRUID: Hand in The Great Cat Spirit; take The Great Cat Spirit at Great Cat Spirit
    .turnin 98405 >> Turn in The Great Cat Spirit
    .accept 98342 >> Accept The Great Cat Spirit
    .target Great Cat Spirit

step << Druid Skyborne
    .goto 1450/1,-2352.700,7375.600,10,0
    >>DRUID: Hand in The Great Windborne Cat Spirit; take The Great Windborne Cat Spirit at Avatar of Saeyleenan
    .goto 1450/1,-2394.300,7361.200
    .target Avatar of Saeyleenan::272054
    .turnin 98341 >> Turn in The Great Windborne Cat Spirit
    .accept 98404 >> Accept The Great Windborne Cat Spirit

step << Druid
    .goto 1450/1,-3117.400,7455.300
    >>DRUID: Objective: Relic of the Claw
    .complete 98404,2 << Skyborne --|1/1 Relic of the Claw
    .complete 98342,2 << !Skyborne --|1/1 Relic of the Claw

step << Druid
    .goto 1450/1,-3099.200,7485.700
    >>DRUID: Objective: Relic of the Silent Shadow
    .complete 98404,3 << Skyborne --|1/1 Relic of the Silent Shadow
    .complete 98342,3 << !Skyborne --|1/1 Relic of the Silent Shadow

step << Druid
    .goto 1450/1,-3054.100,7476.800
    >>DRUID: Objective: Relic of the Fang
    .complete 98404,1 << Skyborne --|1/1 Relic of the Fang
    .complete 98342,1 << !Skyborne --|1/1 Relic of the Fang

step << Druid !Skyborne
    .goto 1450/1,-2640.000,7338.900
    >>DRUID: Hand in The Great Cat Spirit; take Blessings of the Great Cat Spirit at Great Cat Spirit
    .turnin 98342 >> Turn in The Great Cat Spirit
    .accept 98739 >> Accept Blessings of the Great Cat Spirit
    .target Great Cat Spirit

step << Druid Skyborne
    .goto 1450/1,-2395.400,7361.400
    >>DRUID: Hand in The Great Windborne Cat Spirit; take Blessings of the Great Windborne Cat Spirit at Avatar of Saeyleenan
    .target Avatar of Saeyleenan::272054
    .turnin 98404 >> Turn in The Great Windborne Cat Spirit
    .accept 98738 >> Accept Blessings of the Great Windborne Cat Spirit

step << Druid
    .goto 1450/1,-2678.200,8021.500
    >>DRUID: Hand in Blessings of the Great Windborne Cat Spirit, Blessings of the Great Cat Spirit; take To Thunder Bluff at Dendrite Starblaze
    .turnin 98738 >> Turn in Blessings of the Great Windborne Cat Spirit << Skyborne
    .turnin 98739 >> Turn in Blessings of the Great Cat Spirit << !Skyborne
    .accept 98362 >> Accept To Thunder Bluff
    .target Dendrite Starblaze::11802

step << Druid
    >>DRUID: Use the quest item
    .hs
    .use 6948
    .cooldown item,6948,>0
    .bindlocation 1638,1
    .zoneskip Thunder Bluff

step << Druid
    #completewith next
    .goto 1450/1,-2403.61,7785.31
    >>DRUID: Fly to Thunder Bluff
    .fly Thunder Bluff
    .target Bunthen Plainswind
    .zoneskip Thunder Bluff
    .cooldown item,6948,<0

step << Druid
    .goto 1456/1,-281.59,-1039.61
    >>DRUID: Hand in To Thunder Bluff at Turak Runetotem
    .turnin 98362 >> Turn in To Thunder Bluff
    .target Turak Runetotem

step << Hunter
    .goto 1413/1,-2347.48,857.83
    >>HUNTER: Hand in Wenikee Boltbucket at Wenikee Boltbucket
    .turnin 3921 >> Turn in Wenikee Boltbucket
    .target Wenikee Boltbucket
    .isOnQuest 3921

step << Hunter
    .goto 1413/1,-2253.24,1246.31
    >>HUNTER: Hand in Report to Kadrak at Kadrak
    .turnin 6541 >> Turn in Report to Kadrak
    .target Kadrak

step << Hunter
    #optional
    .goto 1413/1,-2253.24,1246.31
    >>HUNTER: Take The Runed Scroll by using the item that starts it, then hand in The Runed Scroll at Kadrak
    .accept 3513 >> Accept The Runed Scroll
    .turnin 3513 >> Turn in The Runed Scroll
    .target Kadrak
    .itemcount 10621,1

step << Hunter
    .goto 1440/1,-2554.65,2310.55
    >>HUNTER: Hand in The Ashenvale Hunt at Senani Thunderheart
    .turnin -6382 >> Turn in The Ashenvale Hunt
    .target Senani Thunderheart

step
    .goto 1456/1,26.10,-1196.66
    >>Tal
    .fly Sun Rock Retreat >> Fly to Sun Rock Retreat
    .target Tal

step
    .goto 1413/1,-950.10,-271.14,60,0
    >>Down the pass to the border camp first: Seereth and Makaba settle accounts
    .turnin 1062 >> Turn in Goblin Invaders
    .accept 1063 >> Accept The Elder Crone
    .accept 1068 >> Accept Shredding Machines
    .target Seereth Stonebreak

step
    .goto 1413/1,-943.00,-265.06
    >>Hand in Kill Grundig Darkcloud, Protect Kaya; take Kaya's Alive at Makaba Flathoof
    .turnin -6629 >> Turn in Kill Grundig Darkcloud
    .turnin -6523 >> Turn in Protect Kaya
    .accept 6401,2,6523 >> Accept Kaya's Alive
    .target Makaba Flathoof

step
    .goto 1442/1,-522.63,-294.32,40,0
    >>Up the left-hand path to Malaka'jin: Witch Doctor Jin'Zil
    .goto 1442/1,-394.20,-272.50
    .turnin 1060 >> Turn in Letter to Jin'Zil
    .target Witch Doctor Jin'Zil

step << Warlock
    .goto 1442/1,-331.21,-181.00
    >>WARLOCK: Hand in News of Dogran; take Ken'zigla's Draught at Ken'zigla
    .turnin 1510 >> Turn in News of Dogran
    .accept 1511 >> Accept Ken'zigla's Draught
    .target Ken'zigla

step
    .goto 1442/1,-233.54,-177.42
    >>Xen'Zilla
    .turnin 6461 >> Turn in Blood Feeders
    .target Xen'Zilla



step
    .goto 1442/1,933.09,824.53
    >>Sun Rock Retreat, up the right-hand path: Tsunaman
    .accept 6562 >> Accept Trouble in the Deeps
    .accept 6393 >> Accept Elemental War
    .target Tsunaman

step
    .goto 1442/1,928.20,1015.99
    >>Tammra Windfield by the pond
    .turnin -6401 >> Turn in Kaya's Alive
    .accept 6301 >> Accept Cycle of Rebirth
    .target Tammra Windfield

step
    #optional
    .isOnQuest 1094
    >>Still holding Ziz's first Further Instructions? That one goes to Sputtervalve in Ratchet -- Ziz's next task waits on his reply
    .turnin 1094 >> Turn in Further Instructions
    .target Sputtervalve

step
    .goto 1442/1,365.16,878.25
    >>Ziz once more
    .turnin 1095 >> Turn in Further Instructions
    .accept 1096 >> Accept Gerenzo Wrenchwhistle
    .target Ziz Fizziks

step
    .goto 1442/1,-202.90,1088.60
    >>XT:9 patrols the river's south bank through Windshear Crag
    .complete 1068,2 --XT:9
    .unitscan XT:9

step
    .goto 1442/1,-263.82,962.92
    >>Piznik in the Windshear Mine: his dig runs 5 minutes with three kobold waves (at 0:15, 2:15 and 3:20) -- a partner helps, or fight smart solo
    .accept 1090 >> Accept Gerenzo's Orders
    .complete 1090,1 --Keep Piznik safe
    .turnin 1090 >> Turn in Gerenzo's Orders
    .accept 1092 >> Accept Gerenzo's Orders
    .target Piznik
    .mob Windshear Vermin

step
    .goto 1442/1,-577.33,1532.43,30,0
    >>Through the Talondeep Path into Ashenvale
    .goto 1440/1,-632.70,2311.50
    >>Va'xug Firefure at the orc camp
    .accept 98251 >> Accept Never Coming Back
    .target Va'xug Firefure

step
    .goto 1440/1,-799.50,2222.00,50,0
    >>Ashenvale Bears and Shadowhorn Stags in the woods: 6 each (a strong level-25 elite patrols -- give it room)
    .goto 1440/1,-712.30,2023.90,50,0
    .complete 98251,2 --Ashenvale Bear (6)
    .complete 98251,1 --Shadowhorn Stag (6)
    .mob Ashenvale Bear
    .mob Shadowhorn Stag

step
    .goto 1440/1,-632.90,2312.00
    >>Va'xug
    .turnin 98251 >> Turn in Never Coming Back
    .accept 98252 >> Accept A Void Path
    .target Va'xug Firefure

step
    .goto 1440/1,-545.20,2446.60
    >>Walk the Eye of Kilrogg to the main road and hear it out
    .complete 98252,1 --Eye of Kilrogg guided
    .turnin 98252 >> Turn in A Void Path
    .target Eye of Kilrogg

step
    .goto 1440/1,-268.74,2612.28,50,0
    >>Northwest to the coast -- keep off Astranaar's roads, the Sentinels shoot on sight
    .goto 1440/1,637.20,3406.79,50,0
    .goto 1440/1,994.16,3373.73
    >>Zoram'gar Outpost: Andruk
    .fp Zoram'gar Outpost >> Get the Zoram'gar Outpost flight path
    .target Andruk

step
    .goto 1440/1,1033.37,3354.89
    >>The outpost round: Je'neu, Karang, Mitsuwa, Marukai
    .turnin 6562 >> Turn in Trouble in the Deeps
    .target Je'neu Sancrea
    .goto 1440/1,1013.77,3345.67
    .accept 216 >> Accept Between a Rock and a Thistlefur
    .target Karang Amakkar
    .goto 1440/1,1028.18,3333.37
    .accept 6462 >> Accept Troll Charm
    .target Mitsuwa
    .goto 1440/1,1025.88,3331.45
    .accept 6442 >> Accept Naga at the Zoram Strand
    .target Marukai

step
    .goto 1440/1,1004.54,3341.83
    >>Muglash starts a HARD escort -- waves of naga, then Vorsha the Lasher herself; rest up first, group if you can
    .accept 6641 >> Accept Vorsha the Lasher
    .target Muglash

step
    .goto 1440/1,1144.67,3610.89
    >>Hold the brazier with Muglash through the waves, then put Vorsha down
    .complete 6641,1 --Defeat Vorsha the Lasher
    .mob Vorsha the Lasher

step
    .goto 1440/1,978.59,3746.96,50,0
    >>The Zoram Strand: Wrathtail naga die 20 heads deep
    .goto 1440/1,885.17,3874.57,50,0
    .goto 1440/1,858.64,3984.89,50,0
    .complete 6442,1 --Wrathtail Head (20)
    .mob Wrathtail Razortail
    .mob Wrathtail Wave Rider
    .mob Wrathtail Sorceress
    .mob Wrathtail Myrmidon

step
    #optional
    .goto 1440/1,928.42,4042.93,50,0
    >>Short of 21? The strand grinds well
    .xp 21

step
    .goto 1440/1,995.31,3357.97
    >>Back at the outpost: the Warsong Runner and Marukai
    .turnin 6641 >> Turn in Vorsha the Lasher
    .target Warsong Runner

step
    .goto 1440/1,1025.88,3331.45
    >>Hand in Naga at the Zoram Strand at Marukai
    .turnin -6442 >> Turn in Naga at the Zoram Strand
    .target Marukai

step
    .goto 1440/1,994.16,3373.73
    >>Andruk
    .fly Thunder Bluff >> Fly to Thunder Bluff
    .target Andruk

step
    .goto 1456/1,-212.71,-1065.01
    >>Elder Rise: Magatha Grimtotem (a roleplay runs after the crone's letter)
    .turnin 1063 >> Turn in The Elder Crone
    .accept 1064 >> Accept Forsaken Aid
    .target Magatha Grimtotem

step
    .goto 1456/1,278.48,-995.29
    >>Zamah in the Pools of Vision
    .turnin 1064 >> Turn in Forsaken Aid
    .accept 1065 >> Accept Journey to Tarren Mill
    .target Apothecary Zamah

step << Warlock
    .goto 1456/1,26.1,-1196.66
    >>WARLOCK: Fly to Camp Taurajo
    .fly Camp Taurajo
    .target Tal
    .zoneskip Thunder Bluff,1

step << Warlock
    #optional
    .goto 1440/1,994.16,3373.730
    >>WARLOCK: Fly to Camp Taurajo
    .fly Camp Taurajo
    .target Andruk
    .zoneskip Ashenvale,1

step << Warlock
    .goto 1413/1,-1898.58,-2391.93
    >>WARLOCK: Hand in Ken'zigla's Draught; take Dogran's Captivity at Grunt Logmar
    .turnin 1511 >> Turn in Ken'zigla's Draught
    .accept 1515 >> Accept Dogran's Captivity
    .target Grunt Logmar

step << Warlock
    .goto 1413/1,-1765.83,-1622.39
    >>WARLOCK: Hand in Dogran's Captivity; take Love's Gift at Grunt Dogran
    .turnin 1515 >> Turn in Dogran's Captivity
    .accept 1512 >> Accept Love's Gift
    .target Grunt Dogran

step << Warlock
    .goto 1413/1,-1881.35,-2384.50
    >>WARLOCK: Fly to Orgrimmar
    .fly Orgrimmar
    .target Omusa Thunderhorn
    .zoneskip The Barrens,1

step << Warlock
    .goto 1454/1,-4357.36,1850.41
    >>WARLOCK: Hand in Love's Gift; take The Binding at Gan'rul Bloodeye
    .turnin 1512 >> Turn in Love's Gift
    .accept 1513 >> Accept The Binding
    .target Gan'rul Bloodeye

step << Warlock
    #completewith next
    >>WARLOCK: Use the quest item
    .cast 9224
    .use 6626

step << Warlock
    .goto 1454/1,-4377.13,1804.77
    >>WARLOCK: Objective: Kill Summoned Succubus -- Summoned Succubus
    .complete 1513,1 --Kill Summoned Succubus (1)
    .mob Summoned Succubus
    .use 6626

step << Warlock
    .goto 1454/1,-4357.36,1850.41
    >>WARLOCK: Hand in The Binding at Gan'rul Bloodeye
    .turnin 1513 >> Turn in The Binding
    .target Gan'rul Bloodeye

step << Priest/Warlock
    .goto 1454/1,-4299.99,1820.67
    >>PRIEST: Objective: Burning Wand
    .collect 5210,1,1507,1 --Collect Burning Wand (1)
    .money <0.5808
    .itemStat 18,QUALITY,<7
    .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<17.4
    .target Katis

step << Troll Priest
    .goto 1454/1,-4179.79,1452.580
    >>PRIEST: Hand in Shadowguard at Ur'kyo; train at your class trainer
    .turnin 5642 >> Turn in Shadowguard
    .trainer >> Train at your class trainer
    .target Ur'kyo

step << Warrior
    .goto 1456/1,26.10,-1196.66,60,0
    >>Fly to Orgrimmar for a last training pass
    .goto 1454/1,-4801.42,1980.53
    .trainer >> Train your class abilities
    .target Grezz Ragefist

step
    .goto 1454/1,-4739.57,2036.84
    >>Sovik in the engineering yard
    .accept 2842 >> Accept Chief Engineer Scooty
    .target Sovik

step
    +Chunk complete -- you're ~22 with the whole Horde 1-22 line custom. Banked for the 22-30 chunk: Journey to Tarren Mill and Until Death Do Us Part (Hillsbrad), Mahren Skyseer (Ratchet pier), Egg Hunt (silithid fields), Shredding Machines (XT:4), Gerenzo's Orders + Gerenzo Wrenchwhistle (upper Stonetalon), Jin'Zils Forest Magic, Cycle of Rebirth, Elemental War, Between a Rock and a Thistlefur, Troll Charm, Mura Runetotem, Chief Engineer Scooty, the bedroll note, Speak with Ruga (warrior, 30), and Chol'aruk if ungrouped
]])
