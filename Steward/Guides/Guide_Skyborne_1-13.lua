-- =====================================================================
--  Custom WoW: Forever guide -- Skyborne start, 1-13 (Warrior-optimized)
--  BOTH factions: Zephras Isle 1-9 > 9-13, then Alliance exits to our
--  Westfall chain and Horde exits to our Silverpine bridge.
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
--  NOTE: no faction guard -- Skyborne exists on both sides.
-- =====================================================================

-- ==================== 1-9 ZEPHRAS ISLE ===============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 1-9 Zephras Isle (Skyborne)
#next 9-13 Zephras Isle (Skyborne)
<< Skyborne !Mage !Warrior !Hunter / Skyborne !Alliance

step
    #completewith next
    +Skyborne starter, both factions, warrior-optimized. Zephras flying rules: Tornados grant 40% move speed if you touch them (damage cancels it), and your Walk on Air racial turns cliffs into shortcuts

step
    .goto 2521,42.82,23.41
    >>Ailee Farheart in Thendal Village
    .accept 92460 >> Accept Coming of Age
    .target Ailee Farheart

step
    .goto 2521,42.07,23.49
    >>Rorian the Dayseeker
    .turnin 92460 >> Turn in Coming of Age
    .accept 92461 >> Accept Harmony in Balance
    .target Rorian the Dayseeker

step
    .goto 2521,43.44,24.80
    >>Elatrell Featherlight
    .accept 92462 >> Accept Infestation Investigation
    .target Elatrell Featherlight

step
    .goto 2521,45.24,25.90,40,0
    >>East of the village: 8 Pesky Cirrusflies and 8 Juvenile Vuldren (leave the Cirrusfly Queen alone for now: her quest comes next)
    .goto 2521,44.23,26.00,40,0
    .complete 92462,1 --Pesky Cirrusfly (8)
    .complete 92461,1 --Juvenile Vuldren (8)
    .mob Pesky Cirrusfly
    .mob Juvenile Vuldren

step
    .goto 2521,43.44,24.78
    >>Elatrell -- don't use Walk on Air yet, a quest needs it off cooldown
    .turnin 92462 >> Turn in Infestation Investigation
    .accept 92463 >> Accept The Cirrusfly Queen
    .target Elatrell Featherlight

step << Warrior
    .goto 2521,43.66,24.13
    >>Blademaster Ren, the warrior trainer
    .train 6673 >> Train Battle Shout
    .target Blademaster Ren

step
    .goto 2521,43.80,24.05
    >>Climb the spiral stairs: Halaan Hawk-Eye atop the tower. View the pylon, then hand it back
    .accept 94414 >> Accept The Anchors of Zephras
    .complete 94414,1 --View the Anchor Pylon
    .turnin 94414 >> Turn in The Anchors of Zephras
    .target Halaan Hawk-Eye

step
    .goto 2521,43.65,24.05
    >>Myriaal Mistwake beside him
    .accept 92474 >> Accept Falling With Style
    .target Myriaal Mistwake

step
    .goto 2521,42.06,23.48
    >>Jump from the tower toward Rorian and hit Walk on Air mid-fall (or jump off anything and use it on the way down)
    .complete 92474,1 --Use Walk on Air

step
    .goto 2521,42.06,23.48
    >>Rorian
    .turnin 92461 >> Turn in Harmony in Balance
    .turnin 92474 >> Turn in Falling With Style
    .accept 92464 >> Accept Elemental Unrest
    .accept 92532 >> Accept The Warrior's Path << Warrior
    .target Rorian the Dayseeker

step << Skyborne Druid
    .goto 2521,42.06,23.48
    >>DRUID: Take A Student of Nature at Rorian the Dayseeker
    .accept 92485 >> Accept A Student of Nature

step << Skyborne Hunter
    .goto 2521,42.06,23.48
    >>HUNTER: Take The Way of the Hunter at Rorian the Dayseeker
    .accept 92482 >> Accept The Way of the Hunter

step << Skyborne Mage Alliance
    .goto 2521,42.06,23.48
    >>MAGE: Take A Student of the Arcane at Rorian the Dayseeker
    .accept 92481 >> Accept A Student of the Arcane

step << Skyborne Rogue
    .goto 2521,42.06,23.48
    >>ROGUE: Take At Home in the Shadows at Rorian the Dayseeker
    .accept 92483 >> Accept At Home in the Shadows

step << Skyborne Shaman Horde
    .goto 2521,42.06,23.48
    >>SHAMAN: Take Embracing the Elements at Rorian the Dayseeker
    .accept 92484 >> Accept Embracing the Elements

step << Skyborne Warrior
    .goto 2521,42.06,23.48
    >>WARRIOR: Take The Warrior's Path at Rorian the Dayseeker
    .accept 92532 >> Accept The Warrior's Path

step << Druid
    .goto 2521,41.653,23.337
    >>DRUID: Read the Folded Parchment Rorian gave you (right-click it in your bags), then hand in A Student of Nature at Xyton Silverwind
    .turnin 92485 >> Turn in A Student of Nature
    .target Xyton Silverwind::251373

step << Alliance Mage
    .goto 2521,41.55,23.67
    >>MAGE: Examine the Glowing Recall Crystal Rorian gave you (right-click it in your bags), then hand in A Student of the Arcane at Dorii Brightwhisper
    .turnin 92481 >> Turn in A Student of the Arcane
    .target Dorii Brightwhisper::251379

step << Horde Shaman
    .goto 2521,42.790,23.566
    >>SHAMAN: Examine the Humming Recall Crystal Rorian gave you (right-click it in your bags), then hand in Embracing the Elements and take Call of Earth at Windshaper Boro
    .target Windshaper Boro::251374
    .turnin 92484 >> Turn in Embracing the Elements
    .accept 92466 >> Accept Call of Earth

step << Hunter
    .goto 2521,42.47,23.73
    >>HUNTER: Read the Scribbled Note Rorian gave you (right-click it in your bags), then hand in The Way of the Hunter at Tai'ree Farsight
    .turnin 92482 >> Turn in The Way of the Hunter
    .target Tai'ree Farsight::251376

step << Warrior
    .goto 2521,43.42,23.51
    >>Destin Thriceforged sells a Bastard Sword -- your first real weapon; sell trash toward it (keep Stringy Meat and Linen Cloth)
    .collect 1194,1 --Bastard Sword
    .vendor >> Vendor trash
    .target Destin Thriceforged
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<2.17

step << Horde
    .goto 2521,42.60,24.39
    >>Ventaari Brightwish
    .accept 92598 >> Accept The Gift of Skysight
    .target Ventaari Brightwish

step << Alliance
    .goto 2521,43.33,24.92
    >>Falorne Fallwind
    .accept 92597 >> Accept Reading the Leylines
    .target Falorne Fallwind

step
    .goto 2521,43.37,23.99
    >>Dalia the Collector
    .accept 93552 >> Accept Harvesting Windstones
    .target Dalia the Collector

step
    #sticky
    #completewith Windstones
    >>Gather Raw Windstones wherever you see them for 15 Windstone Clusters (they sit all around Thendal Grove, mostly along the ridges and the village's stone walls)
    .complete 93552,1 --Windstone Cluster (15)

step
    .goto 2521,47.70,28.20
    >>The Cirrusfly Queen nests east
    .complete 92463,1 --Cirrusfly Queen
    .mob Cirrusfly Queen

step
    .goto 2521,47.29,21.90
    >>Yala Windwatcher at the standing stones northeast of the village: ask her about the agitated winds, then hand in
    .complete 92464,1 --Learn more about the agitated winds
    .turnin 92464 >> Turn in Elemental Unrest
    .accept 92465 >> Accept Agitators
    .target Yala Windwatcher

step << Horde Shaman
    #loop
    .goto 2521,47.20,19.40,30,0
    >>SHAMAN: Al'Aketh Converts in the north fields drop the Signet of Akir (the Brutes and Neophytes at the southwest temple drop it too)
    .goto 2521,46.70,20.40,30,0
    .goto 2521,47.60,18.80,30,0
    .complete 92466,1 --Signet of Akir
    .mob Al'Aketh Convert

step << Alliance
    .goto 2521,46.41,18.21
    >>Use your Read Leyline ability at the leyline by the standing stones northeast of the village (the glowing rift on the ground) -- near a leyline it gives 15 minutes of double regen instead of 15 seconds
    .complete 92597,1 --Use Read Leyline near the Thendal Grove Leyline

step << Horde
    .goto 2521,48.40,20.40
    >>Use your Skysight ability at the Elemental Convergence by the standing stones northeast of the village -- near one it gives 15 minutes of +10% move speed instead of 15 seconds
    .complete 92598,1 --Use Skysight at the Convergence

step
    .goto 2521,47.20,20.10,35,0
    >>Al'Aketh Converts and Roiling Winds haunt the north fields: 7 and 6
    .goto 2521,47.20,19.40,35,0
    .complete 92465,1 --Al'Aketh Convert (7)
    .complete 92465,2 --Roiling Winds (6)
    .mob Al'Aketh Convert
    .mob Roiling Winds

step
    #label Windstones
    .goto 2521,47.19,23.55,30,0
    >>Finish the 15 Windstone Clusters
    .goto 2521,46.60,24.62,30,0
    .complete 93552,1 --Windstone Cluster (15)

step
    .goto 2521,47.29,21.90
    >>Yala
    .turnin 92465 >> Turn in Agitators
    .accept 92469 >> Accept Return to Rorian
    .target Yala Windwatcher

step << Horde Shaman
    #completewith next
    >>SHAMAN: Hearth
    .subzoneskip 16622,1 -- Thendal Grove
    .hs
    .cooldown item,6948,>0 --Hearthstone

step << Horde Shaman
    .goto 2521,42.788,23.566
    >>SHAMAN: Hand in Call of Earth; take Call of Earth at Windshaper Boro
    .turnin 92466 >> Turn in Call of Earth
    .accept 92467 >> Accept Call of Earth
    .target Windshaper Boro::251374

step << Horde Shaman
    .goto 2521,47.241,25.244,25,0
    >>SHAMAN: Up the pass east of the village (the path starts just up the hill from the cirrusfly fields) to the Rise of Spirits: drink the Earth Sapta there, then hand in Call of Earth to the Minor Manifestation of Earth that appears and take the next part
    .goto 2521,48.802,25.869,30,0
    .goto 2521,49.677,23.806
    .turnin 92467 >> Turn in Call of Earth
    .accept 92468 >> Accept Call of Earth
    .target Minor Manifestation of Earth::251166
    .use 6635 -- Earth Sapta

step
    .goto 2521,43.37,23.98
    >>Back in the village: Dalia (pick whichever gathering reward suits you)
    .turnin 93552 >> Turn in Harvesting Windstones
    .target Dalia the Collector

step << Rogue
    .goto 2521,43.74,24.34
    >>ROGUE: Read the Simple Note Rorian gave you (right-click it in your bags), then hand in At Home in the Shadows at Akeri Duskblade
    .turnin 92483 >> Turn in At Home in the Shadows
    .target Akeri Duskblade::251389

step << Warrior
    >>WARRIOR: Train at your class trainer
    .money <0.02
    .train 6546,1 -- Rend (Rank 2) Not Trained
    .train 6178,1 -- Charge (Rank 2) Not Trained
    .xp <4,1
    .isOnQuest 92469 -- Return to Rorian
    .goto 2521,43.66,24.14
    .train 100
    .train 772
    .skipgossipid 136813,1
    .target Blademaster Ren::251964

step << Warrior
    >>WARRIOR: Read the Crumpled Note Rorian gave you (right-click it in your bags), then hand in The Warrior's Path at Blademaster Ren
    .xp <4,1
    .goto 2521,43.66,24.14
    .turnin 92532 >> Turn in The Warrior's Path
    .target Blademaster Ren::251964

step << Warrior
    .goto 2521,43.66,24.14
    >>Ren: level 4 training, and your class quest (read the Crumpled Note in your bags first)
    .train 100 >> Train Charge
    .train 772 >> Train Rend
    .turnin 92532 >> Turn in The Warrior's Path
    .target Blademaster Ren

step
    .goto 2521,43.44,24.80
    >>Elatrell
    .turnin 92463,3 >> Turn in The Cirrusfly Queen << Warrior
    .turnin 92463 >> Turn in The Cirrusfly Queen << !Warrior
    .target Elatrell Featherlight

step << Alliance
    .goto 2521,43.33,24.92
    >>Falorne
    .turnin 92597 >> Turn in Reading the Leylines
    .target Falorne Fallwind

step << Warrior
    .goto 2521,43.66,24.14
    >>WARRIOR: Read the Crumpled Note Rorian gave you (right-click it in your bags), then hand in The Warrior's Path at Blademaster Ren
    .turnin 92532 >> Turn in The Warrior's Path
    .target Blademaster Ren::251964

step
    .goto 2521,42.07,23.49
    >>Rorian
    .turnin 92469 >> Turn in Return to Rorian
    .accept 92471 >> Accept Aetheen of the Gales
    .target Rorian the Dayseeker

step
    .goto 2521,42.76,23.65
    >>Aetheen of the Gales
    .turnin 92471 >> Turn in Aetheen of the Gales
    .accept 92470 >> Accept Foul Matriarch
    .target Aetheen of the Gales

step << Shaman Horde
    .goto 2521,42.787,23.564
    >>SHAMAN: Hand in Call of Earth at Windshaper Boro
    .turnin 92468 >> Turn in Call of Earth
    .target Windshaper Boro::251374

step << Horde
    .goto 2521,42.60,24.39
    >>Ventaari
    .turnin 92598 >> Turn in The Gift of Skysight
    .target Ventaari Brightwish

step
    .goto 2521,42.41,25.15
    >>Valreaa Valewind at the south edge
    .accept 92473 >> Accept Aggressive Encroachment
    .target Valreaa Valewind

step
    .goto 2521,40.40,26.90,30,0
    >>Southwest to the ursera dens: 6 Scrawny Ursera Claws
    .goto 2521,37.67,26.31,30,0
    .complete 92473,1 --Scrawny Ursera Claw (6)
    .mob Scrawny Ursera

step
    #sticky
    #completewith Urshub
    >>Ursera Scavengers count too: 8 kills
    .complete 92470,1 --Ursera Scavenger (8)
    .mob Ursera Scavenger

step
    .goto 2521,35.50,25.10
    >>Urs'anah, the foul matriarch, dens in the cave at the back
    .complete 92470,2 --Head of Urs'anah
    .mob Urs'anah

step
    #label Urshub
    .goto 2521,36.90,24.54,30,0
    >>Finish the 8 Scavengers around the dens
    .goto 2521,38.12,27.71,30,0
    .complete 92470,1 --Ursera Scavenger (8)
    .mob Ursera Scavenger

step
    .goto 2521,42.76,23.65
    >>Back to Thendal: Aetheen
    .turnin 92470,1 >> Turn in Foul Matriarch << Warrior
    .turnin 92470 >> Turn in Foul Matriarch << !Warrior
    .accept 92472 >> Accept The Next Step
    .accept 96638 >> Accept The Adventurer
    .target Aetheen of the Gales

step
    .goto 2521,42.41,25.15
    >>Valreaa (sell trash next door, but keep Stringy Meat, Small Eggs and Linen Cloth for later quests)
    .turnin 92473,1 >> Turn in Aggressive Encroachment << Warrior
    .turnin 92473 >> Turn in Aggressive Encroachment << !Warrior
    .target Valreaa Valewind

step
    .goto 2521,38.31,30.17
    >>South along the trail: Hanaa Nightwind
    .accept 92544 >> Accept Al'Aketh Thugs
    .target Hanaa Nightwind

step
    #sticky
    #completewith Malduko
    >>Al'Aketh Brutes (6) and Neophytes (4) hold the temple grounds
    .complete 92544,1 --Al'Aketh Brute (6)
    .complete 92544,2 --Al'Aketh Neophyte (4)
    .mob Al'Aketh Brute
    .mob Al'Aketh Neophyte

step
    .goto 2521,36.03,33.55
    >>Climb to the temple's upper level: Malduko Cloudcrush (he respawns fast, so pull him away from his spot)
    .complete 92544,3 --Malduko Cloudcrush
    .mob Malduko Cloudcrush

step
    #label Malduko
    .goto 2521,36.34,31.56,40,0
    >>Finish the Brutes and Neophytes around the temple
    .goto 2521,37.30,32.89,40,0
    .complete 92544,1 --Al'Aketh Brute (6)
    .complete 92544,2 --Al'Aketh Neophyte (4)
    .mob Al'Aketh Brute
    .mob Al'Aketh Neophyte

step
    .goto 2521,38.32,30.18
    >>Hanaa
    .turnin 92544 >> Turn in Al'Aketh Thugs
    .target Hanaa Nightwind

step
    #sticky
    #completewith ShendarArrive
    >>Galestriders on the road (and later the hippogryphs, the Youths especially) drop Strider Meat and Small Eggs -- keep 8 meat and 3 eggs for a cooking quest
    .collect 5469,8 --Strider Meat (8)
    .collect 6889,3 --Small Egg (3)
    .mob Galestrider

step
    #label ShendarArrive
    .goto 2521,45.67,45.51
    >>Southeast to Shen'dar Village: Constable Aonda
    .turnin 92472 >> Turn in The Next Step
    .accept 93461 >> Accept Welcome to Shen'dar Village << Alliance
    .accept 92514 >> Accept Welcome to Shen'dar Village << Horde
    .target Constable Aonda

step << Alliance
    .goto 2521,45.04,46.49
    >>Rathiril Sunlance: hear the High Order out (click through his story)
    .complete 93461,1 --Speak with Rathiril Sunlance
    .accept 92596 >> Accept The High Order
    .complete 92596,1 --Listen to Rathiril Sunlance
    .turnin 92596 >> Turn in The High Order
    .accept 94413 >> Accept A Magical Affront
    .target Rathiril Sunlance

step << Horde
    .goto 2521,43.52,44.78
    >>Illaya Amberwind: hear the Windshapers out (click through her story)
    .complete 92514,1 --Speak with Illaya Amberwind
    .accept 92595 >> Accept The Windshapers
    .complete 92595,1 --Listen to Illaya
    .turnin 92595 >> Turn in The Windshapers
    .accept 94411 >> Accept Meddlesome Mages
    .target Illaya Amberwind

step
    .goto 2521,43.02,43.24
    >>Innkeeper Coriella Calmbreeze
    .complete 93461,2 --Speak with the Innkeeper << Alliance
    .complete 92514,2 --Speak with the Innkeeper << Horde
    .home >> Set your Hearthstone to Shen'dar Village
    .target Coriella Calmbreeze

step << Warrior
    .goto 2521,44.95,45.10
    >>Corsan Earthrazer, the warrior trainer here
    .train 3127 >> Train Parry
    .target Corsan Earthrazer

step
    .goto 2521,45.67,45.50
    >>Aonda
    .turnin 93461 >> Turn in Welcome to Shen'dar Village << Alliance
    .turnin 92514 >> Turn in Welcome to Shen'dar Village << Horde
    .accept 92517 >> Accept The Criminal Element
    .target Constable Aonda

step
    .goto 2521,44.47,44.98
    >>The village round: Teeri, Indari, Taleen, Zerril
    .accept 93319 >> Accept Pilfered Windstones
    .accept 92516 >> Accept Hippogryph Harassment
    .target Teeri Wellwind
    .goto 2521,44.68,44.53
    .accept 92515 >> Accept The Problem With Prideclaws
    .target Indari Sunseam
    .goto 2521,44.88,44.19
    .accept 93951 >> Accept A Little Beauty
    .target Taleen Shimmerthread
    .goto 2521,43.85,43.84
    .accept 92553 >> Accept Restocking the Larders
    .target Zerril Softbreeze

step << Warrior
    #optional
    .goto 2521,44.80,44.18
    >>Tephri Thriceforged sells the Wooden Mallet (~7s) -- an upgrade if the Bastard Sword hasn't been replaced
    .collect 2493,1 --Wooden Mallet
    .target Tephri Thriceforged
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<5.00

step
    .goto 2521,43.85,43.84
    >>Zerril trains Cooking -- buy Mild Spices from her; Herb Baked Eggs give +5% kill XP for 15 min, so keep the buff up while you level
    .train 2550 >> Train Cooking
    .collect 2678,5 --Mild Spices (5)
    .target Zerril Softbreeze

step
    .goto 2521,43.37,45.86
    >>The bounty board: Vulgara
    .accept 93318 >> Accept WANTED: Vulgara the Insatiable
    .target Bounty Available: Vulgara the Insatiable!

step
    .goto 2521,43.07,46.31
    >>Naleeia Tattermend trains First Aid (bandages from your saved Linen Cloth). Camping 101: First Aid only hands in to her, at 20 skill, so get there before you leave the village for good
    .train 3273 >> Train First Aid
    .target Naleeia Tattermend

step
    .goto 2521,41.67,44.79
    >>Raan Wildwind camps west of the village
    .turnin 96638 >> Turn in The Adventurer
    .accept 96101 >> Accept The Great Outdoors
    .target Raan Wildwind

step
    .goto 2521,41.67,44.79
    >>Sit down at his campfire (the sit key, X by default) and stay seated until you get the Boosted Rest buff (craft bandages and Herb Baked Eggs while you wait). If sitting doesn't count, sit again while you're already seated: typing /sit then works
    .complete 96101,1 --Sit at the campfire
    .complete 96101,2 --Gain the boosted rest buff

step
    .goto 2521,41.67,44.79
    >>Raan -- he also hands out Camping 101 for Cooking and First Aid, and for any profession you've trained: free hand-ins back in the village
    .turnin 96101 >> Turn in The Great Outdoors
    .accept 96646,2,96646 >> Accept Camping 101: Cooking
    .accept 97965,2,97965 >> Accept Camping 101: First Aid
    .accept 97963,2,97963 >> Accept Camping 101: Alchemy
    .accept 97964,2,97964 >> Accept Camping 101: Blacksmithing
    .accept 97967,2,97967 >> Accept Camping 101: Fishing
    .accept 97968,2,97968 >> Accept Camping 101: Herbalism
    .accept 97969,2,97969 >> Accept Camping 101: Leatherworking
    .accept 97970,2,97970 >> Accept Camping 101: Mining
    .accept 97971,2,97971 >> Accept Camping 101: Skinning
    .accept 97973,2,97973 >> Accept Camping 101: Tailoring << Alliance Mage/Alliance Druid
    .accept 97972,2,97972 >> Accept Camping 101: Tailoring << Horde
    .accept 98286,2,98286 >> Accept Camping 101: Enchanting << Alliance Rogue/Alliance Mage/Alliance Druid
    .accept 98284,2,98284 >> Accept Camping 101: Enchanting << Horde
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>Raan has Camping 101: Cooking for you -- a free hand-in at the cook
    .accept 96646 >> Accept Camping 101: Cooking
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained First Aid: Raan has Camping 101: First Aid for you
    .accept 97965 >> Accept Camping 101: First Aid
    .skill First Aid,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Alchemy: Raan has Camping 101: Alchemy for you
    .accept 97963 >> Accept Camping 101: Alchemy
    .skill Alchemy,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Blacksmithing: Raan has Camping 101: Blacksmithing for you
    .accept 97964 >> Accept Camping 101: Blacksmithing
    .skill Blacksmithing,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Fishing: Raan has Camping 101: Fishing for you
    .accept 97967 >> Accept Camping 101: Fishing
    .skill Fishing,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Herbalism: Raan has Camping 101: Herbalism for you
    .accept 97968 >> Accept Camping 101: Herbalism
    .skill Herbalism,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Leatherworking: Raan has Camping 101: Leatherworking for you
    .accept 97969 >> Accept Camping 101: Leatherworking
    .skill Leatherworking,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Mining: Raan has Camping 101: Mining for you
    .accept 97970 >> Accept Camping 101: Mining
    .skill Mining,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Skinning: Raan has Camping 101: Skinning for you
    .accept 97971 >> Accept Camping 101: Skinning
    .skill Skinning,<1,1
    .target Raan Wildwind

step << Alliance Mage/Alliance Druid
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Tailoring: Raan has Camping 101: Tailoring for you
    .accept 97973 >> Accept Camping 101: Tailoring
    .skill Tailoring,<1,1
    .target Raan Wildwind

step << Horde
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Tailoring: Raan has Camping 101: Tailoring for you
    .accept 97972 >> Accept Camping 101: Tailoring
    .skill Tailoring,<1,1
    .target Raan Wildwind

step << Alliance Rogue/Alliance Mage/Alliance Druid
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Enchanting: Raan has Camping 101: Enchanting for you
    .accept 98286 >> Accept Camping 101: Enchanting
    .skill Enchanting,<1,1
    .target Raan Wildwind

step << Horde
    #watch
    .goto 2521,41.67,44.79
    >>You've trained Enchanting: Raan has Camping 101: Enchanting for you
    .accept 98284 >> Accept Camping 101: Enchanting
    .skill Enchanting,<1,1
    .target Raan Wildwind

step
    #watch
    .goto 2521,43.00,46.20
    >>Camping 101: First Aid is done -- hand it to Naleeia Tattermend
    .turnin -97965 >> Turn in Camping 101: First Aid
    .isQuestComplete 97965
    .target Naleeia Tattermend

step
    #watch
    .goto 2521,43.20,43.40
    >>Camping 101: Skinning is done -- hand it to Mendalass Tattermend
    .turnin -97971 >> Turn in Camping 101: Skinning
    .isQuestComplete 97971
    .target Mendalass Tattermend

step << Alliance Rogue/Alliance Mage/Alliance Druid
    #watch
    .goto 2521,43.20,43.20
    >>Camping 101: Enchanting is done -- hand it to Nasalanna Windsinger
    .turnin -98286 >> Turn in Camping 101: Enchanting
    .isQuestComplete 98286
    .target Nasalanna Windsinger

step << Horde
    #watch
    .goto 2521,43.20,43.20
    >>Camping 101: Enchanting is done -- hand it to Nasalanna Windsinger
    .turnin -98284 >> Turn in Camping 101: Enchanting
    .isQuestComplete 98284
    .target Nasalanna Windsinger

step
    #watch
    .goto 2521,43.60,43.50
    >>Camping 101: Alchemy is done -- hand it to Nyassa Swiftdraught
    .turnin -97963 >> Turn in Camping 101: Alchemy
    .isQuestComplete 97963
    .target Nyassa Swiftdraught

step
    #watch
    .goto 2521,43.85,43.84
    >>Camping 101: Cooking is done -- hand it to Zerril Softbreeze
    .turnin -96646 >> Turn in Camping 101: Cooking
    .isQuestComplete 96646
    .target Zerril Softbreeze

step
    #watch
    .goto 2521,44.70,44.50
    >>Camping 101: Mining is done -- hand it to Messana Crestwind
    .turnin -97970 >> Turn in Camping 101: Mining
    .isQuestComplete 97970
    .target Messana Crestwind

step
    #watch
    .goto 2521,44.68,44.52
    >>Camping 101: Leatherworking is done -- hand it to Indari Sunseam
    .turnin -97969 >> Turn in Camping 101: Leatherworking
    .isQuestComplete 97969
    .target Indari Sunseam

step
    #watch
    .goto 2521,44.80,44.40
    >>Camping 101: Blacksmithing is done -- hand it to Aedi Thriceforged
    .turnin -97964 >> Turn in Camping 101: Blacksmithing
    .isQuestComplete 97964
    .target Aedi Thriceforged

step << Alliance Mage/Alliance Druid
    #watch
    .goto 2521,44.80,44.20
    >>Camping 101: Tailoring is done -- hand it to Taleen Shimmerthread
    .turnin -97973 >> Turn in Camping 101: Tailoring
    .isQuestComplete 97973
    .target Taleen Shimmerthread

step << Horde
    #watch
    .goto 2521,44.80,44.20
    >>Camping 101: Tailoring is done -- hand it to Taleen Shimmerthread
    .turnin -97972 >> Turn in Camping 101: Tailoring
    .isQuestComplete 97972
    .target Taleen Shimmerthread

step
    #watch
    .goto 2521,45.00,48.40
    >>Camping 101: Fishing is done -- hand it to Fenn Fairweather
    .turnin -97967 >> Turn in Camping 101: Fishing
    .isQuestComplete 97967
    .target Fenn Fairweather

step
    #sticky
    #completewith Bennic
    >>Prideclaws roam the whole highlands: 10 pelts as you travel
    .complete 92515,1 --Prideclaw Pelt (10)
    .mob Prideclaw

step << Horde
    .goto 2521,46.20,39.00,25,0
    >>The standing stones north of the village: defeat 6 High Order Apprentices
    .complete 94411,1 --High Order Apprentice (6)
    .mob High Order Apprentice

step
    .goto 2521,48.93,36.38,40,0
    >>Highlands Bandits camp before the cave: 10 kills, and their 10 Pilfered Windstones
    .goto 2521,47.75,36.19,40,0
    .complete 92517,1 --Highlands Bandit (10)
    .complete 93319,1 --Pilfered Windstone (10)
    .mob Highlands Bandit

step
    #label Bennic
    .goto 2521,49.54,34.33,30,0
    >>Into the bandit cave behind the waterfall: "Badwind" Bennic at the back (don't die in there, the run back is long)
    .goto 2521,50.68,34.21
    .complete 92517,2 --"Badwind" Bennic
    .mob "Badwind" Bennic

step << Alliance
    .goto 2521,38.99,47.24,40,0
    >>Southwest meadow: defeat 6 Windshaper Novice Seers
    .goto 2521,38.75,48.72,40,0
    .complete 94413,1 --Windshaper Novice Seer (6)
    .mob Windshaper Novice Seer

step
    .goto 2521,36.44,50.93,30,0
    >>Southwest into the hippogryph nesting grounds (jump down with Walk on Air): 8 Youths and 6 Protectors, pick up 8 Hippogryph Down (the fallen feathers around the nests; one spawns at the quiet south edge), and the Matriarch at the northwest end
    .goto 2521,35.63,57.34,30,0
    .goto 2521,37.13,56.60,40,0
    .complete 92516,1 --Hippogryph Youth (8)
    .complete 92516,2 --Hippogryph Protector (6)
    .complete 93951,1 --Hippogryph Down (8)
    .goto 2521,36.60,59.00
    .complete 92516,3 --Hippogryph Matriarch
    .goto 2521,34.04,51.27
    .mob Hippogryph Youth
    .mob Hippogryph Protector
    .mob Hippogryph Matriarch

step
    #optional
    .goto 2521,42.40,50.10
    >>Vulgara the Insatiable (ELITE, a winged vuldren) roams the hilltop rise southwest of the village -- group up or skip; respawn is slow
    .complete 93318,1 --Vulgara's Head
    .mob Vulgara

step
    .goto 2521,40.04,41.38,40,0
    >>Sweep back north: finish Prideclaw Pelts, Strider Meat and Small Eggs
    .goto 2521,37.56,43.24,40,0
    .complete 92515,1 --Prideclaw Pelt (10)
    .complete 92553,2 --Strider Meat (8)
    .complete 92553,1 --Small Egg (3)
    .mob Prideclaw
    .mob Galestrider

step
    .goto 2521,43.85,43.85
    >>Shen'dar Village: Zerril
    .turnin 92553 >> Turn in Restocking the Larders
    .target Zerril Softbreeze

step
    .goto 2521,44.69,44.52
    >>The turn-in round: Indari, Taleen, Teeri
    .turnin 92515 >> Turn in The Problem With Prideclaws
    .target Indari Sunseam
    .goto 2521,44.87,44.19
    .turnin 93951 >> Turn in A Little Beauty
    .target Taleen Shimmerthread
    .goto 2521,44.47,44.97
    .turnin 92516 >> Turn in Hippogryph Harassment
    .turnin 93319 >> Turn in Pilfered Windstones
    .target Teeri Wellwind

step << Horde
    .goto 2521,43.52,44.78
    >>Illaya
    .turnin 94411 >> Turn in Meddlesome Mages
    .target Illaya Amberwind

step << Alliance
    .goto 2521,44.98,46.37
    >>Rathiril
    .turnin 94413 >> Turn in A Magical Affront
    .target Rathiril Sunlance

step << Warrior
    .goto 2521,44.95,45.10
    >>Corsan: level 8 training
    .train 284 >> Train Heroic Strike (Rank 2)
    .train 1715 >> Train Hamstring
    .train 6343 >> Train Thunder Clap
    .target Corsan Earthrazer

step
    .isQuestComplete 93318
    .goto 2521,45.23,45.19
    >>Danarii Bellowveil pays the bounty
    .turnin 93318,1 >> Turn in WANTED: Vulgara the Insatiable << Warrior
    .turnin 93318 >> Turn in WANTED: Vulgara the Insatiable << !Warrior
    .target Danarii Bellowveil

step
    .goto 2521,45.67,45.50
    >>Aonda
    .turnin 92517,3 >> Turn in The Criminal Element << Warrior
    .turnin 92517 >> Turn in The Criminal Element << !Warrior
    .accept 93036 >> Accept Infiltrating the Cult
    .target Constable Aonda

step
    .goto 2521,44.83,45.52
    >>Sania Silverstream disguises you
    .turnin 93036 >> Turn in Infiltrating the Cult
    .accept 92529 >> Accept Falaath Village
    .target Sania Silverstream

step
    .goto 2521,45.37,53.51,25,0
    >>Jump south off the mountain with Walk on Air, down to Falaath Village: Missionary Jasaan at the village entrance (talk to him, then hand in)
    .goto 2521,46.88,56.24
    .complete 92529,1 --Speak with Missionary Jasaan
    .turnin 92529 >> Turn in Falaath Village
    .accept 92528 >> Accept Among the Faithful
    .target Missionary Jasaan

step
    >>Keep the Mark of Akir (the green swirl buff) or the cultists attack you. It can drop when you log out, and only Sania Silverstream, back in Shen'dar Village, puts it on again. Then the inn on the north side of Falaath: upstairs, click the Wardrobe to hide behind it and wait for Skypriest Aanders and his guest to finish talking
    .aura 1254832,92528,Mark of Akir >> Get the Mark of Akir back from Sania Silverstream in Shen'dar Village
    .goto 2521,44.82,45.45
    .complete 92528,1 --Learn the cultists' plans
    .goto 2521,48.85,53.91

step
    .goto 2521,45.67,45.50
    >>Back up to Shen'dar on foot: Aonda
    >>Take the Curved Scimitar and equip it << Warrior
    .turnin 92528,2 >> Turn in Among the Faithful << Warrior
    .turnin 92528 >> Turn in Among the Faithful << !Warrior
    .accept 92550 >> Accept Havoc in the Highlands
    .accept 93926 >> Accept The Western Watch
    .target Constable Aonda

step
    .goto 2521,45.25,45.18
    >>Danarii Bellowveil
    .accept 92551 >> Accept Stolen Supplies
    .target Danarii Bellowveil

step
    .goto 2521,44.05,49.98,30,0
    >>The Western Watch is a fall away: jump off southwest and glide (dying works too -- the graveyard is next to it)
    .goto 2521,42.32,62.03
    >>Peacekeeper Vaaniel lies dead by a rock at the side of the road below the watchtower: click his body
    .complete 93926,1 --Check on the Western Watchtower
    .turnin 93926 >> Turn in The Western Watch
    .accept 93927 >> Accept A Last Request
    .target Peacekeeper Vaaniel

step
    .goto 2521,42.38,62.07
    >>Pick up the Bloody Note on the ground beside Vaaniel, then right-click it in your bags to read it: it only counts once it's read
    .complete 93927,1 --Collect and read the note

step
    >>Into the West Pylon Watchtower: loot the two bodies on the ground floor for the Shadowsong Family Signet and Raani's Lucky Feather (if it says you can't loot that right now, log out and back in). Then up the spiral stairs: Skypriest Aanders is at the top
    .goto 2521,40.99,64.09
    .complete 93927,4 --Shadowsong Family Signet
    .goto 2521,41.12,64.09
    .complete 93927,3 --Raani's Lucky Feather
    .goto 2521,41.08,64.39
    .complete 93927,2 --Skypriest Aanders
    .mob Skypriest Aanders

step
    >>Falaath Village (from the watchtower, jump east and use Walk on Air): clear it in one go: 6 Al'Aketh Stormcallers (step out of their Lightning Clouds), 10 Stolen Shen'dar Supplies (the Stormcallers drop them and the small cache bags on the ground hold them too), 4 Living Lightning (they hit like a truck -- watch the Thunder Clap)
    .goto 2521,48.60,55.60
    .complete 92550,1 --Al'Aketh Stormcaller (6)
    .complete 92551,1 --Stolen Shen'dar Supplies (10)
    .complete 92550,2 --Living Lightning (4)
    .mob Al'Aketh Stormcaller
    .mob Living Lightning

step
    #label Cyclas
    .goto 2521,50.38,56.93
    >>Commander Cyclas is in the building on the southwest side of the village, by the water
    .complete 92550,3 --Commander Cyclas's Head
    .mob Commander Cyclas

step
    #label TurnIn83
    .goto 2521,45.24,45.19
    >>Shen'dar: Danarii
    .turnin 92551 >> Turn in Stolen Supplies
    .target Danarii Bellowveil

step
    #label TurnIn84
    .goto 2521,45.67,45.50
    >>Aonda sends you on to Valanaar
    .turnin 92550,3 >> Turn in Havoc in the Highlands << Warrior
    .turnin 92550 >> Turn in Havoc in the Highlands << !Warrior
    .turnin 93927 >> Turn in A Last Request
    .accept 92701 >> Accept To Valanaar << Alliance
    .accept 92579 >> Accept To Valanaar << Horde
    .accept 93948 >> Accept Deliver the Signet
    .target Constable Aonda
]])

-- ==================== 9-13 ZEPHRAS ISLE ==============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 9-13 Zephras Isle (Skyborne)
#next 13-15 Westfall (Alliance) << Alliance !Hunter
#next 14-16 Darkshore (Alliance) << Alliance Hunter
#next 12-14 Silverpine Forest (Horde) << Horde !Hunter
#next 12-17 The Barrens (Horde) << Horde Hunter
<< Skyborne !Mage !Warrior !Hunter / Skyborne !Alliance

step
    #completewith next
    +Run "1-9 Zephras Isle (Skyborne)" first -- this chapter needs its quests (To Valanaar, Deliver the Signet)

step
    .goto 2521,54.99,68.14,100,0
    >>Southeast across the Gustberry Lowlands toward Valanaar (jump the cliffs with Walk on Air; Tornados speed the run)
    .goto 2521,60.64,72.66
    >>Nyalah Brightfire in the first house
    .accept 93317 >> Accept Crab Season
    .target Nyalah Brightfire

step
    .goto 2521,62.18,72.62
    >>Donaal Downbreeze: rehome here
    .home >> Set your Hearthstone to Valanaar
    .target Donaal Downbreeze

step
    .goto 2521,62.10,73.34
    >>Alvarion Windfield on the second floor: take his quest, then stay and listen to his whole story (it's part of the quest)
    .accept 92679 >> Accept Blood Tithe
    .complete 92679,2 --Listen to Alvarion Windfield's Story
    .target Alvarion Windfield

step
    .goto 2521,63.97,75.10
    >>Over the hill: Lotheluum Starbreeze
    .accept 94484 >> Accept Unnerving Silence
    .target Lotheluum Starbreeze

step
    .goto 2521,65.96,74.31
    >>Ealaane Nimbuswalker at the refugee camp
    .accept 94896 >> Accept Aid For The Refugees
    .accept 94897 >> Accept The Fate of a Loved One
    .target Ealaane Nimbuswalker

step
    .goto 2521,66.44,76.40,5,0
    >>Climb the tower: Talaanis Shadowsong, then Valennia Stormfist
    .goto 2521,66.17,76.51
    .turnin 93948 >> Turn in Deliver the Signet
    .target Talaanis Shadowsong
    .goto 2521,66.18,76.65
    .turnin 92701 >> Turn in To Valanaar << Alliance
    .turnin 92579,3 >> Turn in To Valanaar << Horde Warrior
    .turnin 92579 >> Turn in To Valanaar << Horde !Warrior
    .accept 92699 >> Accept The Supreme Magister << Alliance
    .accept 92700 >> Accept The Grand Skyseer << Horde
    .accept 93949 >> Accept Bugged
    .target Valennia Stormfist

step << Alliance
    #sticky
    #completewith TurnIn36
    >>Kill the Skyhoppers (little blue grasshoppers) around Valanaar until 8 turn out to be enchanted: the ones inside buildings, in the tower and at the inn (upstairs too) are the likely spies
    .complete 93949,1 --Enchanted Skyhopper (8)
    .mob Skyhopper

step << Horde
    #sticky
    #completewith BuggedHorde
    >>Kill the Skyhoppers (little blue grasshoppers) around Valanaar until 8 turn out to be enchanted: the ones inside buildings, in the tower and at the inn (upstairs too) are the likely spies
    .complete 93949,1 --Enchanted Skyhopper (8)
    .mob Skyhopper

step << Alliance
    .goto 2521,66.63,79.94
    >>Glide off the tower south to the magister's hall: Elaadrin Evengale
    .turnin 92699 >> Turn in The Supreme Magister
    .target Elaadrin Evengale

step << Alliance
    .goto 2521,66.26,79.89
    >>Dondallion Whisperwind
    .accept 92727 >> Accept The Missing Scholar
    .target Dondallion Whisperwind

step << Alliance
    #label Skyhoppers
    .goto 2521,66.35,79.51
    >>Iaadaria Bitterwind
    .accept 92741 >> Accept Unwelcome Visitors
    .target Iaadaria Bitterwind

step << Alliance
    .goto 2521,53.33,72.15
    >>Down in the lowlands west: the Bloodstained Satchel (mind the Ornery Galestrider guarding it)
    .turnin 92727 >> Turn in The Missing Scholar
    .accept 92849 >> Accept The Missing Scholar
    .mob Ornery Galestrider

step << Alliance
    .goto 2521,50.70,65.36
    >>In the Shriekling Den just north: keep left, follow the ramp down and to the right, then along the back wall to Fillion Flamebreeze; click him free out of combat. If the quest doesn't switch to carrying him, drop him (right-click the buff), abandon the quest and take it again from the satchel
    .complete 92849,1 --Find Fillion Flamebreeze

step << Alliance
    .goto 2521,52.08,69.41
    >>Carry Fillion out -- if a bird attacks, drop the carry aura or the cave ejects you
    .complete 92849,2 --Carry Fillion to safety
    .mob Shriekling Fledgling

step << Alliance
    .goto 2521,52.06,69.40
    >>Fillion, safe
    .turnin 92849 >> Turn in The Missing Scholar
    .accept 92850 >> Accept The Missing Scholar
    .target Fillion Flamebreeze

step << Alliance
    .goto 2521,52.02,65.51
    >>Back in the den: the Shriekling Matriarch's head comes off
    .complete 92850,1 --Shriekling Matriarch's Head
    .mob Shriekling Matriarch

step << Horde
    .goto 2521,59.15,79.78
    >>Glide off the tower southwest to Ayessa Dawnsinger. After you take A Grand Adventure, stay and listen until she finishes talking (that's its objective; if you leave early, abandon it and take it again to hear her out)
    .turnin 92700 >> Turn in The Grand Skyseer
    .accept 92708 >> Accept A Grand Adventure
    .complete 92708,1 --Listen to Ayessa
    .accept 93735 >> Accept The Broken Construct
    .target Ayessa Dawnsinger

step << Horde Warrior
    .goto 2521,59.40,75.73
    >>Falfaan Halfwind sells the Zephrali Smasher (~21s 51c) -- the big two-hander for the rest of the isle; sell trash toward it (keep Small Eggs and Strider Meat)
    .collect 277106,1 --Zephrali Smasher
    .vendor >> Vendor trash and repair
    .target Falfaan Halfwind
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<8.28

step << Horde
    .goto 2521,59.06,72.99
    >>Riaani Nightwind explains the construct
    .turnin 93735 >> Turn in The Broken Construct
    .accept 93737 >> Accept The Broken Construct
    .complete 93737,1 --Listen to Riaani
    .target Riaani Nightwind

step << Horde
    .goto 2521,51.40,68.64,15,0
    >>West to the Shriekling cave: the Crystallized Lightning sits along the cave walls as you go through
    .goto 2521,52.00,67.00,15,0
    .goto 2521,52.93,66.08,15,0
    .complete 93737,2 --Crystallized Lightning

step
    .goto 2521,46.71,81.94
    >>Southwest to the orchard: Aamelia Windfield (she wanders during her roleplay -- follow her voice; stealthed bandits hide in the trees)
    .complete 92679,1 --Find Aamelia Windfield
    .turnin 92679 >> Turn in Blood Tithe
    .accept 92682 >> Accept Make Yourself Useful
    .accept 92684 >> Accept Ornery Ornery Galestriders
    .accept 92683 >> Accept Flutterfly Dust
    .target Aamelia Windfield

step
    .goto 2521,46.50,79.50,25,0
    >>The orchard: 10 Ripe Stormapples off the trees (one grove to the north, one to the south), 5 Hungry Bandits out of the shadows between them
    .goto 2521,48.00,83.50,25,0
    .complete 92682,1 --Ripe Stormapple (10)
    .complete 92682,2 --Hungry Bandit (5)
    .mob Hungry Bandit

step
    .goto 2521,48.62,78.39,12,0
    >>The Malfunctioning Cyclone Construct wanders the lowlands
    .accept 92698 >> Accept What Is My Purpose?
    .target Malfunctioning Cyclone Construct

step
    .goto 2521,51.30,80.59,40,0
    >>Lowland loop: 7 Lowlands Galestrider Tenderloins from the Ornery Galestriders (they blind you with Dust Cloud), and 5 Flutterfly Dust: use the Flutterfly Swatter on a Flutterfly before you fight it; the dust usually falls to the ground as a small white disc you pick up, not onto the corpse
    .goto 2521,50.87,83.29,40,0
    .complete 92684,1 --Lowlands Galestrider Tenderloin (7)
    .complete 92683,1 --Flutterfly Dust (5)
    .use 253666 --Flutterfly Swatter
    .mob Ornery Galestrider
    .mob Flutterfly

step
    .goto 2521,46.71,81.94
    >>Aamelia
    .turnin 92682 >> Turn in Make Yourself Useful
    .turnin 92684,3 >> Turn in Ornery Ornery Galestriders << Warrior
    .turnin 92684 >> Turn in Ornery Ornery Galestriders << !Warrior
    .turnin 92698 >> Turn in What Is My Purpose?
    .turnin 92683 >> Turn in Flutterfly Dust
    .accept 92685 >> Accept The Hills Have Eyes
    .target Aamelia Windfield

step << Horde Shaman
    .goto 2521,58.313,78.499
    >>SHAMAN: Take Call of Fire at Sessaria Skystride
    .accept 97243 >> Accept Call of Fire
    .target Sessaria Skystride::252382

step << Horde Shaman
    >>SHAMAN: Train at your class trainer
    .money <0.12
    .isQuestAvailable 97243 -- Call of Fire
    .xp <10,1
    .subzoneskip 16638,1 -- Valanaar
    .goto 2521,58.313,78.499
    .trainer >> Train at your class trainer
    .target Sessaria Skystride::252382

step << Horde Shaman
    .goto 2521,54.402,77.329,30,0
    >>SHAMAN: Olariaan Swiftburn keeps the Shrine of Flames, tucked away on the island's edge west of Valanaar: hand in Call of Fire and take the next part
    .goto 2521,51.240,86.187
    .turnin 97243 >> Turn in Call of Fire
    .accept 97244 >> Accept Call of Fire
    .target Olariaan Swiftburn::268592

step << Horde Shaman
    .goto 2521,64.380,63.586
    >>SHAMAN: Skypriest Faladiel is at the farm northeast of Valanaar, just south of the Shrine of Akir: kill him and take his heart
    .complete 97244,1 --Faladiel's Heart
    .mob Skypriest Faladiel::268602

step << Horde Shaman
    .goto 2521,51.241,86.193
    >>SHAMAN: Back to Olariaan Swiftburn at the Shrine of Flames: hand in Call of Fire and take the next part
    .target Olariaan Swiftburn::268592
    .turnin 97244 >> Turn in Call of Fire
    .accept 97245 >> Accept Call of Fire

step << Horde Shaman
    .goto 2521,42.393,68.887
    >>SHAMAN: Kuramaa lives in a twisted stump on the hilltop near the Shen'dar Highlands Anchor Pylon: knock on the stump and the spirit comes out. Most of your magic barely touches it, only fire does real damage, so train your fire spells at the shaman trainer before you go
    .complete 97245,1 --Kuramaa's Mask
    .mob Kuramaa::268605

step
    .goto 2521,47.80,74.60,35,0
    >>Up into the hills north of the orchard: the Bandit Highwaymen there carry 7 Blood-Stained Bandit Masks (their camp spreads west along the hills)
    .goto 2521,45.62,72.36,35,0
    .complete 92685,1 --Blood-Stained Bandit Mask (7)
    .mob Bandit Highwayman

step << Horde
    >>The Air Construct Core for Riaani lies beside the road above Windfield Orchard (on your left heading toward the Shen'dar Highlands)
    .complete 93737,4 --Air Construct Core
    .goto 2521,45.00,73.00

step
    .goto 2521,47.51,78.49,30,0
    >>Glide back down to Aamelia
    .goto 2521,46.71,81.94,30,0
    .turnin 92685 >> Turn in The Hills Have Eyes
    .accept 92693 >> Accept Standing Our Ground
    .target Aamelia Windfield

step
    .goto 2521,46.71,81.94
    >>Stay with Aamelia: talk to her when you're ready, follow her up the path and make your final stand against Ferauu the Bludgeon. If she runs off without you (someone else started it), wait for her to come back in front of the house and talk to her again
    .complete 92693,1 --Speak with Aamelia
    .complete 92693,2 --Make your final stand
    .turnin 92693 >> Turn in Standing Our Ground
    .accept 92703 >> Accept Deliver the News
    .target Aamelia Windfield

step << Horde Shaman
    .goto 2521,51.240,86.187
    >>SHAMAN: Back to Olariaan Swiftburn: hand in Call of Fire and take the last part. Clear two bag spaces first: it pays a Fire Totem and a Totem of Charged Flames, and the last part runs on a timer
    .target Olariaan Swiftburn::268592
    .turnin 97245 >> Turn in Call of Fire
    .accept 97257 >> Accept Call of Fire

step << Horde Shaman
    .goto 2521,51.265,85.927
    >>SHAMAN: Wait for Olariaan to start the ritual at the Brazier of Offering and do as he says: when the flame spirits light the Eternal Flame, use your Torch of Eternal Flame to catch it
    .complete 97257,1 --Complete the Ritual with Olariaan
    .use 277329 --Torch of Eternal Flame

step << Horde Shaman
    .goto 2521,52.400,81.309,25,0
    >>SHAMAN: Run the lit torch straight back to Valanaar before its timer runs out and light the Brazier of Eternal Flame beside Sessaria Skystride
    .goto 2521,54.907,76.598,15,0
    .goto 2521,58.312,78.827
    .complete 97257,2 --Light the Brazier of Eternal Flame

step << Horde Shaman
    .goto 2521,58.315,78.512
    >>SHAMAN: Hand in Call of Fire to Sessaria Skystride right away (a player who left to sell things first came back to an unlit brazier and no hand-in mark)
    .target Sessaria Skystride::252382
    .turnin 97257 >> Turn in Call of Fire

step
    .goto 2521,62.11,73.33
    >>Valanaar (hearth if it's up): Alvarion on the second floor
    >>Equip the Planting Shovel if he offers it -- it's a weapon << Warrior
    .turnin 92703,1 >> Turn in Deliver the News << Warrior
    .turnin 92703 >> Turn in Deliver the News << !Warrior
    .target Alvarion Windfield

step << Mage Alliance
    .goto 2521,62.887,77.324
    >>MAGE: Take and hand in Speak with Belann; take Boughs in the Wind at Belann Windwood
    .target Belann Windwood::256507
    .accept 93791 >> Accept Speak with Belann
    .turnin 93791 >> Turn in Speak with Belann
    .accept 93797 >> Accept Boughs in the Wind

step << Warrior
    .goto 2521,59.889,72.869
    >>WARRIOR: Take The Skybreaker Bulwark at Seena Skybreaker
    .target Seena Skybreaker::252377
    .accept 94003 >> Accept The Skybreaker Bulwark

step << Hunter
    .goto 2521,59.55,73.3,25,0
    >>HUNTER: Take Taming the Beast at Quel'ana Quickgale
    .goto 2521,59.572,72.639
    .accept 94978 >> Accept Taming the Beast
    .target Quel'ana Quickgale::252389

step << Horde Druid
    .goto 2521,63.983,75.093
    >>DRUID: Take The Great Ursera Spirit at Lotheluum Starbreeze
    .accept 94006 >> Accept The Great Ursera Spirit
    .target Lotheluum Starbreeze::252359

step << Alliance Druid
    >>DRUID: Take The Great Ursera Spirit at Lotheluum Starbreeze
    .xp <10,1
    .goto 2521,63.983,75.093
    .accept 94006 >> Accept The Great Ursera Spirit
    .target Lotheluum Starbreeze::252359

step << Warrior
    .goto 2521,59.89,72.87
    >>Seena Skybreaker, the Valanaar warrior trainer -- her quest pays a shield
    .accept 94003 >> Accept The Skybreaker Bulwark
    .train 6546 >> Train Rend (Rank 2)
    .train 2687 >> Train Bloodrage
    .target Seena Skybreaker

step << Alliance
    .goto 2521,66.21,79.94
    >>Fillion, recovered, in the magister's hall
    .turnin 92850 >> Turn in The Missing Scholar
    .accept 99260 >> Accept Fillion's Mission
    .target Fillion Flamebreeze

step << Alliance
    .goto 2521,66.63,79.94
    >>Elaadrin
    .turnin 99260 >> Turn in Fillion's Mission
    .accept 92840 >> Accept Catching Wind
    .target Elaadrin Evengale

step << Horde Hunter
    #loop
    .goto 2521,54.460,78.811,48,0
    >>HUNTER: Objective: Tame a Windsong Crawler -- Windsong Crawler
    .goto 2521,51.968,73.084,35,0
    .goto 2521,53.126,73.502,20,0
    .goto 2521,51.268,69.758,35,0
    .use 267272
    .complete 94978,1 --Tame a Windsong Crawler
    .mob Windsong Crawler::254588

step << Horde Hunter
    .goto 2521,59.571,72.639
    >>HUNTER: Hand in Taming the Beast; take Taming the Beast at Quel'ana Quickgale
    .turnin 94978 >> Turn in Taming the Beast
    .accept 94979 >> Accept Taming the Beast
    .target Quel'ana Quickgale::252389

step << Horde Hunter
    #loop
    .goto 2521,60.905,69.414,35,0
    >>HUNTER: Objective: Tame an Ornery Galestrider -- Ornery Galestrider
    .goto 2521,58.339,68.476,35,0
    .goto 2521,53.799,72.161,35,0
    .use 267298
    .complete 94979,1 --Tame an Ornery Galestrider
    .mob Ornery Galestrider::251707

step << Horde Hunter
    .goto 2521,59.571,72.639
    >>HUNTER: Hand in Taming the Beast; take Taming the Beast at Quel'ana Quickgale
    .turnin 94979 >> Turn in Taming the Beast
    .accept 94013 >> Accept Taming the Beast
    .target Quel'ana Quickgale::252389

step << Horde Hunter
    #loop
    .goto 2521,54.080,74.719,35,0
    >>HUNTER: Tame a Vuldren Alpha (not a plain Vuldren) with the Taming Rod
    .goto 2521,52.625,77.864,25,0
    .goto 2521,53.021,81.568,25,0
    .goto 2521,51.647,80.140,25,0
    .goto 2521,48.981,82.669,35,0
    .use 264163
    .complete 94013,1 --Tame a Vuldren Alpha
    .mob Vuldren Alpha

step << Horde Hunter
    .goto 2521,59.571,72.639
    >>HUNTER: Hand in Taming the Beast; take Training the Beast at Quel'ana Quickgale
    .turnin 94013 >> Turn in Taming the Beast
    .accept 94050 >> Accept Training the Beast
    .target Quel'ana Quickgale::252389

step << Horde Hunter
    .goto 2521,59.605,72.527
    >>HUNTER: Hand in Training the Beast at Quel'dora Quickgale
    .turnin 94050 >> Turn in Training the Beast
    .target Quel'dora Quickgale::254411

step << Alliance Hunter
    .goto 2521,51.56,71.28,40,0
    >>HUNTER: Objective: Tame a Windsong Crawler -- Windsong Crawler
    .goto 2521,50.94,69.46,40,0
    .use 267272
    .complete 94978,1 --Tame a Windsong Crawler
    .mob Windsong Crawler::254588

step << Mage Alliance
    .goto 2521,48.59,67.77
    >>MAGE: Pick up a Wind-Infused Bough off the ground by the wind shrine south of Falaath Village
    .complete 93797,1 --1/1 Wind-Infused Bough

step << Alliance Hunter
    >>HUNTER: Objective: Tame a Windsong Crawler -- Windsong Crawler
    .isOnQuest 94978 -- Taming the Beast
    .isQuestNotComplete 94978 -- Taming the Beast
    .goto 2521,49.47,65.13,40,0
    .goto 2521,50.07,67.39,40,0
    .goto 2521,50.98,69.45,40,0
    .goto 2521,52.05,71.71,40,0
    .goto 2521,51.82,72.95,40,0
    .goto 2521,52.81,75.82,40,0
    .use 267272
    .complete 94978,1 --Tame a Windsong Crawler
    .mob Windsong Crawler::254588

step << Alliance Hunter
    .goto 2521,59.571,72.639
    >>HUNTER: Hand in Taming the Beast; take Taming the Beast at Quel'ana Quickgale
    .turnin 94978 >> Turn in Taming the Beast
    .accept 94979 >> Accept Taming the Beast
    .target Quel'ana Quickgale::252389

step << Alliance Hunter
    #loop
    .goto 2521,60.905,69.414,35,0
    >>HUNTER: Objective: Tame an Ornery Galestrider -- Ornery Galestrider
    .goto 2521,58.339,68.476,35,0
    .goto 2521,53.799,72.161,35,0
    .use 267298
    .complete 94979,1 --Tame an Ornery Galestrider
    .mob Ornery Galestrider::251707

step << Alliance Hunter
    .goto 2521,59.571,72.639
    >>HUNTER: Hand in Taming the Beast; take Taming the Beast at Quel'ana Quickgale
    .turnin 94979 >> Turn in Taming the Beast
    .accept 94013 >> Accept Taming the Beast
    .target Quel'ana Quickgale::252389

step << Alliance Hunter
    >>HUNTER: Train at your class trainer; hand in Camping 101: Herbalism at Syriel Nightrain
    .train 2366,3 -- Herbalism Trained
    .isQuestComplete 97968 -- Camping 101: Herbalism
    .goto 2521,57.890,75.514
    .target Syriel Nightrain::254345

step
    #watch
    .goto 2521,57.890,75.514
    >>Camping 101: Herbalism is done -- hand it to Syriel Nightrain
    .turnin -97968 >> Turn in Camping 101: Herbalism
    .isQuestComplete 97968
    .target Syriel Nightrain::254345

step << Alliance Hunter
    #loop
    .goto 2521,54.23,75,40,0
    >>HUNTER: Tame a Vuldren Alpha (not a plain Vuldren) with the Taming Rod
    .goto 2521,53.45,80.93,40,0
    .goto 2521,52.56,77.82,40,0
    .goto 2521,61.944,68.828,35,0
    .goto 2521,59.516,64.846,35,0
    .goto 2521,57.041,67.729,35,0
    .goto 2521,54.322,75.080,35,0
    .goto 2521,51.925,80.458,35,0
    .goto 2521,52.920,81.509,35,0
    .use 264163
    .complete 94013,1 --Tame a Vuldren Alpha
    .mob Vuldren Alpha

step << Alliance Hunter
    .goto 2521,59.571,72.639
    >>HUNTER: Hand in Taming the Beast; take Training the Beast at Quel'ana Quickgale
    .turnin 94013 >> Turn in Taming the Beast
    .accept 94050 >> Accept Training the Beast
    .target Quel'ana Quickgale::252389

step << Alliance Hunter
    .goto 2521,59.605,72.527
    >>HUNTER: Hand in Training the Beast at Quel'dora Quickgale
    .turnin 94050 >> Turn in Training the Beast
    .target Quel'dora Quickgale::254411

step << Mage Alliance
    .goto 2521,62.89,77.44
    >>MAGE: Hand in Boughs in the Wind at Belann Windwood
    .turnin 93797 >> Turn in Boughs in the Wind
    .target Belann Windwood::256507

step << Horde Druid
    >>DRUID: Jump off the edge and glide toward the arrow with Walk on Air
    .isOnQuest 94006 -- The Great Ursera Spirit
    .cooldown spell,1259416,>0,1 -- Walk on Air
    .goto 2521,69.01,65.86,20,0
    .goto 2521,69.84,61.73
    .cast 1259416
    .usespell 1259416

step << Horde Druid
    .goto 2521,69.782,61.609
    >>DRUID: Hand in The Great Ursera Spirit; take Strength and Mercy at Urs'endris
    .turnin 94006 >> Turn in The Great Ursera Spirit
    .accept 94638 >> Accept Strength and Mercy
    .target Urs'endris::255853

step << Alliance
    .goto 2521,48.13,70.15,20,0
    >>Jump down west to the Overlook Standing Stones: use the Index Esoteria on the Windstone Formations (the crystals sticking out of the ground) 6 times (no Walk on Air while reading)
    .goto 2521,47.32,68.68,30,0
    .complete 92840,1 --Gather Data on Elemental Currents (6)
    .use 254584 --Index Esoteria
    .mob Windshaper Elementalist
    .mob Windshaper Guardian

step << Alliance
    .goto 2521,66.63,79.93
    >>Glide back to Elaadrin
    .turnin 92840 >> Turn in Catching Wind
    .accept 92834 >> Accept Avenged Tenfold
    .accept 92860 >> Accept In Service of Zephras
    .target Elaadrin Evengale

step << Alliance
    #label TurnIn36
    .goto 2521,66.18,76.66
    >>Up the tower: Valennia
    .turnin 92860 >> Turn in In Service of Zephras
    .turnin 93949 >> Turn in Bugged
    .accept 93320 >> Accept Tower Defense
    .target Valennia Stormfist

step << Alliance
    #sticky
    #completewith TurnIn77
    >>Al'Aketh cultists of every stripe drop 10 Windstone Charms (Pillagers and Preachers drop them most often)
    .complete 92834,1 --Al'Aketh Windstone Charm (10)

step << Alliance
    .goto 2521,69.64,67.07
    >>Glide north off the tower to the siege line: Yorana Windyreed
    .turnin 93320,3 >> Turn in Tower Defense << Warrior
    .turnin 93320 >> Turn in Tower Defense << !Warrior
    .accept 92642 >> Accept Disrupting Logistics
    .accept 92645 >> Accept Breaking the Breaker
    .target Yorana Windyreed

step << Alliance Druid
    >>DRUID: Jump off the edge and glide toward the arrow with Walk on Air
    .isOnQuest 92834 -- Avenged Tenfold
    .subzoneskip 17675,1 -- East Pylon Watchtower
    .cooldown spell,1259416,>0,1 -- Walk on Air
    .goto 2521,69.01,65.86,20,0
    .goto 2521,69.84,61.73
    .cast 1259416
    .usespell 1259416

step << Alliance Druid
    .goto 2521,69.782,61.609
    >>DRUID: Hand in The Great Ursera Spirit; take Strength and Mercy at Urs'endris
    .target Urs'endris::255853
    .turnin 94006 >> Turn in The Great Ursera Spirit
    .accept 94638 >> Accept Strength and Mercy

step << Alliance
    .goto 2521,65.34,65.79,40,0
    >>The occupied hamlet: 4 Al'Aketh Healers (stop their casts) and 8 Brawlers
    .goto 2521,64.71,67.65,40,0
    .complete 92642,1 --Al'Aketh Healer (4)
    .complete 92642,2 --Al'Aketh Brawler (8)
    .mob Al'Aketh Healer
    .mob Al'Aketh Brawler

step << Alliance
    #label Belguilos
    .goto 2521,65.58,65.63
    >>Commander Belguilos commands from the second floor of the house
    .complete 92645,1 --Commander Belguilos
    .mob Commander Belguilos

step << Alliance
    .goto 2521,69.61,67.10
    >>Yorana
    .turnin 92645,3 >> Turn in Breaking the Breaker << Warrior
    .turnin 92645 >> Turn in Breaking the Breaker << !Warrior
    .turnin 92642 >> Turn in Disrupting Logistics
    .accept 92880 >> Accept Return to Valanaar
    .target Yorana Windyreed

step << Alliance
    .goto 2521,66.18,76.65
    >>The tower again: Valennia, then Talaanis
    .turnin 92880,1 >> Turn in Return to Valanaar << Warrior
    .turnin 92880 >> Turn in Return to Valanaar << !Warrior
    .accept 92881 >> Accept The High Elder's Request
    .target Valennia Stormfist
    .goto 2521,66.17,76.50
    .turnin 92881 >> Turn in The High Elder's Request
    .accept 92643 >> Accept The Turncoat
    .target Talaanis Shadowsong

step
    .goto 2521,56.81,61.11
    >>Northwest across the highlands: Fendaal Windstone by the lake
    .accept 98512 >> Accept Al'Aketh Assassins
    .target Fendaal Windstone

step << Alliance
    .goto 2521,56.13,60.26
    >>The secluded house (plenty of cultists around it), then the Dead Cultist inside it
    .complete 92643,1 --Find the secluded house
    .goto 2521,56.05,58.79
    .complete 92643,2 --Find the Al'Aketh Turncoat
    .turnin 92643 >> Turn in The Turncoat
    .accept 92644 >> Accept Unfortunate News
    .target Dead Cultist

step
    .goto 2521,55.27,59.58,35,0
    >>10 Al'Aketh Assassins skulking around the house up the hill (they Slam you flat -- fight them one at a time)
    .goto 2521,55.93,60.30,35,0
    .complete 98512,1 --Al'Aketh Assassin (10)
    .mob Al'Aketh Assassin

step
    .goto 2521,56.80,61.10
    >>Fendaal
    .turnin 98512 >> Turn in Al'Aketh Assassins
    .target Fendaal Windstone

step << Horde Druid
    .goto 2521,57.72,60.92,25,0
    >>DRUID: Ur'endra lairs in an unmarked cave high on the cliff face, not the cave at the bottom: take the path up the mountain and come in from the top, then put her down
    .goto 2521,53.70,65.10
    .complete 94638,1 --Ur'endra slain
    .mob Ur'endra

step << Horde Druid
    >>DRUID: Jump off the edge and glide toward the arrow with Walk on Air
    .isOnQuest 94638 -- Strength and Mercy
    .cooldown spell,1259416,>0,1 -- Walk on Air
    .goto 2521,56.830,63.121,15,0
    .goto 2521,57.299,63.465,15,0
    .goto 2521,60.250,62.742,20,0
    .goto 2521,69.803,61.660
    .cast 1259416
    .usespell 1259416

step << Horde Druid
    .goto 2521,69.803,61.660
    >>DRUID: Hand in Strength and Mercy at Urs'endris
    .target Urs'endris::255853
    .turnin 94638 >> Turn in Strength and Mercy

step << Alliance Druid
    .goto 2521,57.72,60.92,25,0
    >>DRUID: Ur'endra lairs in an unmarked cave high on the cliff face, not the cave at the bottom: take the path up the mountain and come in from the top, then put her down
    .goto 2521,53.70,65.10
    .complete 94638,1 --Ur'endra slain
    .mob Ur'endra

step << Alliance Druid
    >>DRUID: Jump off the edge and glide toward the arrow with Walk on Air
    .isOnQuest 94638 --Strength and Mercy
    .goto 2521,56,64.14,20,0
    .goto 2521,69.803,61.660
    .cast 1259416
    .usespell 1259416 --Walk on Air

step << Alliance Druid
    .goto 2521,69.803,61.660
    >>DRUID: Hand in Strength and Mercy at Urs'endris
    .target Urs'endris::255853
    .turnin 94638 >> Turn in Strength and Mercy

step << Warrior
    .goto 2521,56.56,50.36
    >>WARRIOR: Objective: Skybreaker Bulwark -- Zaal Stormshield
    .complete 94003,1 --|1/1 Skybreaker Bulwark
    .mob Zaal Stormshield::257196

step
    #optional
    .goto 2521,53.56,59.17,35,0
    >>Windsong Crawlers on the lakeshore: 6 Windsong Crawler Meat (it drops rarely; skip it if the shore is crowded, the quest is optional)
    .goto 2521,53.55,55.55,35,0
    .complete 93317,1 --Windsong Crawler Meat (6)
    .mob Windsong Crawler

step << Horde
    >>Windsong Lake: dive to the Construct Parts on the lake bottom for the Enchanted Gyrozephyr (it doesn't come from every pile, keep looting)
    .complete 93737,3 --Enchanted Gyrozephyr
    .goto 2521,52.00,48.00

step << Warrior
    .goto 2521,56.56,50.36
    >>Zaal Stormshield camps past the waterfall -- his bulwark is yours
    .complete 94003,1 --Skybreaker Bulwark
    .mob Zaal Stormshield

step
    .goto 2521,58.61,52.77,30,0
    >>Around the mountain and across the bridge into Shadowgale Forest: the Strange Hermit
    .goto 2521,53.95,38.90
    .accept 93159 >> Accept The Strange Hermit
    .complete 93159,1 --Learn about the Strange Hermit
    .turnin 93159 >> Turn in The Strange Hermit
    .accept 93160 >> Accept The Forest's Bounty
    .accept 93172 >> Accept Free the Hollows
    .target Strange Hermit

step
    #sticky
    #completewith ForestDone
    >>Through the forest: Zephyrseed Cones on the forest floor (8)
    .complete 93160,1 --Zephyrseed (8)

step << Alliance
    #sticky
    #completewith TurnIn76
    >>Shadowgale Shrieklings drop both Shriekling Talons (8, they drop rarely) and Pristine Feathers (20)
    .complete 92741,1 --Shriekling Talons (8)
    .complete 94486,1 --Pristine Shriekling Feathers (20)
    .mob Shadowgale Shriekling

step
    >>North into the ruins of Ban'aethal: the 8 Abandoned Belongings are all here (if a box says it's already being used, try the next one; several sit up the stairs), the 10 Wind Hollows (the singing spirits) haunt the same ruins, and Resaan Nimbuswalker's body lies outside a ruined building at the northwest end
    .complete 94896,1 --Abandoned Belongings (8)
    .goto 2521,58.10,31.80
    .complete 93172,1 --Wind Hollow (10)
    .goto 2521,58.10,32.30
    .complete 94897,1 --Resaan's Heirloom
    .goto 2521,57.04,29.36
    .mob Wind Hollow

step
    .goto 2521,61.76,39.14
    >>Elegael Thornpaw at the den's edge
    .turnin 94484 >> Turn in Unnerving Silence
    .accept 94485 >> Accept Tears of the Lady
    .accept 94486 >> Accept Feathers for Binding
    .accept 94487 >> Accept Unwanted and Unworthy
    .target Elegael Thornpaw

step
    .goto 2521,63.80,36.03
    >>Vayn Moongaze by the cave
    .accept 93165 >> Accept Mercy Falls on Deaf Ears
    .target Vayn Moongaze

step
    .goto 2521,62.47,37.30,40,0
    >>Al'Aketh Footsoldiers and Stormchasers raid the dens: 10 Bloody Heirlooms and 5 Al'Aketh Cultist's Ears (the ears drop rarely; cultists at the Shrine of Akir drop them more often)
    .goto 2521,64.14,39.18,40,0
    .complete 94487,1 --Bloody Heirloom (10)
    .complete 93165,1 --Al'Aketh Cultist's Ear (5)
    .mob Al'Aketh Footsoldier
    .mob Al'Aketh Stormchaser

step
    #sticky
    #completewith ForestDone
    >>Lady's Tear Moss hangs on the sides of the trees (look up, not at the floor): 8
    .complete 94485,1 --Lady's Tear Moss (8)

step
    #label ForestDone
    .goto 2521,59.67,40.26,40,0
    >>Sweep the forest: finish seeds, moss and feathers (and any Wind Hollows or Abandoned Belongings still missing, back in the Ban'aethal ruins)
    .goto 2521,57.49,37.79,40,0
    .goto 2521,55.38,42.17,35,0
    .complete 93160,1 --Zephyrseed (8)
    .complete 94485,1 --Lady's Tear Moss (8)
    .complete 94486,1 --Pristine Shriekling Feathers (20)
    .complete 93172,1 --Wind Hollow (10)
    .goto 2521,58.10,32.30
    .complete 94896,1 --Abandoned Belongings (8)
    .goto 2521,58.10,31.80
    .mob Wind Hollow
    .mob Shadowgale Shriekling

step
    .goto 2521,53.97,38.90
    >>The Hermit
    .turnin 93160 >> Turn in The Forest's Bounty
    .turnin 93172,3 >> Turn in Free the Hollows << Warrior
    .turnin 93172 >> Turn in Free the Hollows << !Warrior
    .target Strange Hermit

step
    #label Thornpaw2
    .goto 2521,61.76,39.13
    >>Thornpaw
    .turnin 94485 >> Turn in Tears of the Lady
    .turnin 94487 >> Turn in Unwanted and Unworthy
    .turnin 94486 >> Turn in Feathers for Binding
    .accept 94489 >> Accept The Wounds of Betrayal
    .accept 94488,2,94488 >> Accept The Ties That Bind
    .target Elegael Thornpaw

step
    .goto 2521,63.80,36.00
    >>Vayn
    .turnin 93165,3 >> Turn in Mercy Falls on Deaf Ears << Warrior
    .turnin 93165 >> Turn in Mercy Falls on Deaf Ears << !Warrior
    .target Vayn Moongaze

step
    #label Haalien
    .goto 2521,65.54,36.30
    >>Commander Haalien dies for the den -- loot his head AND the Ripped Missive, and read the missive
    .complete 94488,1 --Commander Haalien's Head
    .collect 265476,1,94490 --Ripped Missive
    .accept 94490 >> Accept Ripped Missive
    .use 265476
    .mob Commander Haalien
    .accept 94488 >> Accept The Ties That Bind

step
    .goto 2521,63.70,36.20,12,0
    >>Into the Nightfang Den (the cave mouth on the north side of the clearing, not the cliff above it): heal the 7 Injured Druids. Walk right up to each one before you click it, or the quest can stick at 6/7 (if it does, abandon it and take it again). Two are just left of the entrance, more stand round a crystal at the top of the ramp, and the last pairs are beyond it
    .goto 2521,64.60,34.90,10,0
    .goto 2521,65.80,33.10,10,0
    .goto 2521,64.20,31.90,10,0
    .complete 94489,1 --Injured Druids healed (7)

step
    .goto 2521,64.49,34.74
    >>...and find Jorel Windsinger among them
    .complete 94489,2 --Find Jorel Windsinger

step
    .goto 2521,61.77,39.14
    >>Out of the cave: Thornpaw closes the den's story
    .turnin 94489 >> Turn in The Wounds of Betrayal
    .turnin 94490 >> Turn in Ripped Missive
    .turnin 94488 >> Turn in The Ties That Bind
    .accept 94491 >> Accept The Fate of the Den
    .target Elegael Thornpaw

step << Alliance Warrior
    .goto 2521,59.886,72.863
    >>WARRIOR: Hand in The Skybreaker Bulwark at Seena Skybreaker
    .target Seena Skybreaker::252377
    .turnin 94003 >> Turn in The Skybreaker Bulwark

step
    .hs >> Hearth to Valanaar

step << Warrior
    .goto 2521,59.89,72.87
    >>Seena: the bulwark, and level 12 training
    .turnin 94003 >> Turn in The Skybreaker Bulwark
    .train 5242 >> Train Battle Shout (Rank 2)
    .train 7384 >> Train Overpower
    .train 72 >> Train Shield Bash
    .target Seena Skybreaker

step
    .isQuestComplete 93317
    .goto 2521,60.64,72.66
    >>Nyalah, crab meat in hand
    .turnin 93317 >> Turn in Crab Season
    .target Nyalah Brightfire

step << Horde Warrior
    .goto 2521,59.886,72.863
    >>WARRIOR: Hand in The Skybreaker Bulwark at Seena Skybreaker
    .turnin 94003 >> Turn in The Skybreaker Bulwark
    .target Seena Skybreaker::252377

step << Horde
    .goto 2521,59.07,72.99
    >>Riaani rebuilds her construct
    .turnin 93737 >> Turn in The Broken Construct
    .accept 93738 >> Accept The Broken Construct
    .target Riaani Nightwind

step << Horde
    .goto 2521,59.15,79.77
    >>Ayessa watches it fly
    .turnin 93738 >> Turn in The Broken Construct
    .turnin 92708 >> Turn in A Grand Adventure
    .accept 93746 >> Accept A Firm Response
    .target Ayessa Dawnsinger

step
    .goto 2521,63.99,75.09
    >>Starbreeze over the hill
    .turnin 94491 >> Turn in The Fate of the Den
    .target Lotheluum Starbreeze

step
    .goto 2521,65.95,74.31
    >>Ealaane at the refugee camp
    .turnin 94896 >> Turn in Aid For The Refugees
    .turnin 94897 >> Turn in The Fate of a Loved One
    .target Ealaane Nimbuswalker

step << Horde
    #label BuggedHorde
    .goto 2521,66.18,76.66
    >>Up the tower to Valennia: hand in Bugged (still short? the Skyhoppers inside Valanaar's buildings, the tower and the inn are the enchanted ones)
    .complete 93949,1 --Enchanted Skyhopper (8)
    .turnin 93949 >> Turn in Bugged
    .target Valennia Stormfist

step << Horde
    .goto 2521,59.80,57.00
    >>North up the road toward the Shrine of Akir: Belathaan Brightwish waits beside the road just before the bridge. Confront him; Living Storms join the fight (if the kills don't count, a relog has given others the credit)
    .complete 93746,1 --Confront Belathaan Brightwish
    .target Belathaan Brightwish

step << Horde
    .goto 2521,59.15,79.77
    >>Back to Ayessa in Valanaar
    .turnin 93746 >> Turn in A Firm Response
    .accept 92871 >> Accept In Service of Zephras
    .accept 93740 >> Accept Blood for Blood
    .target Ayessa Dawnsinger

step << Horde
    #sticky
    #completewith BloodHorde
    >>Every Al'Aketh cultist from here on can drop an Al'Aketh Windstone Charm: 10 (the Preachers and Pillagers in the occupied hamlet drop them most often)
    .complete 93740,1 --Al'Aketh Windstone Charm (10)

step << Horde
    .goto 2521,66.18,76.66
    >>Up the tower: Valennia
    .turnin 92871 >> Turn in In Service of Zephras
    .accept 93320 >> Accept Tower Defense
    .target Valennia Stormfist

step << Horde
    .goto 2521,69.64,67.07
    >>Glide north off the tower to the siege line: Yorana Windyreed
    .turnin 93320,3 >> Turn in Tower Defense << Warrior
    .turnin 93320 >> Turn in Tower Defense << !Warrior
    .accept 92642 >> Accept Disrupting Logistics
    .accept 92645 >> Accept Breaking the Breaker
    .target Yorana Windyreed

step << Horde
    .goto 2521,65.34,65.79,40,0
    >>The occupied hamlet: 4 Al'Aketh Healers (stop their casts) and 8 Brawlers
    .goto 2521,64.71,67.65,40,0
    .complete 92642,1 --Al'Aketh Healer (4)
    .complete 92642,2 --Al'Aketh Brawler (8)
    .mob Al'Aketh Healer
    .mob Al'Aketh Brawler

step << Horde
    .goto 2521,65.58,65.63
    >>Commander Belguilos commands from the second floor of the house
    .complete 92645,1 --Commander Belguilos
    .mob Commander Belguilos

step << Horde
    .goto 2521,69.61,67.10
    >>Yorana
    .turnin 92645,3 >> Turn in Breaking the Breaker << Warrior
    .turnin 92645 >> Turn in Breaking the Breaker << !Warrior
    .turnin 92642 >> Turn in Disrupting Logistics
    .accept 92880 >> Accept Return to Valanaar
    .target Yorana Windyreed

step << Horde
    .goto 2521,66.18,76.65
    >>The tower again: Valennia, then Talaanis
    .turnin 92880,1 >> Turn in Return to Valanaar << Warrior
    .turnin 92880 >> Turn in Return to Valanaar << !Warrior
    .accept 92881 >> Accept The High Elder's Request
    .target Valennia Stormfist
    .goto 2521,66.17,76.50
    .turnin 92881 >> Turn in The High Elder's Request
    .accept 92643 >> Accept The Turncoat
    .target Talaanis Shadowsong

step << Horde
    .goto 2521,56.13,60.26
    >>Northwest to the secluded house (plenty of cultists around it), then the Dead Cultist inside it
    .complete 92643,1 --Find the secluded house
    .goto 2521,56.05,58.79
    .complete 92643,2 --Find the Al'Aketh Turncoat
    .turnin 92643 >> Turn in The Turncoat
    .accept 92644 >> Accept Unfortunate News
    .target Dead Cultist

step << Horde
    .goto 2521,66.17,76.52
    >>The tower: hand Talaanis the crystal, take her next quest, then talk to her again to learn from the crystal and stay to watch the conversation that follows (a roleplay -- wait it out)
    .turnin 92644,3 >> Turn in Unfortunate News << Warrior
    .turnin 92644 >> Turn in Unfortunate News << !Warrior
    .accept 94568 >> Accept The Cult's True Plans
    .complete 94568,1 --Learn what you can from the crystal
    .complete 94568,2 --Observe the conversation
    .turnin 94568 >> Turn in The Cult's True Plans
    .accept 92640 >> Accept Desperate Times
    .target Talaanis Shadowsong

step << Horde
    .goto 2521,66.18,76.65
    >>Desperate times, three voices: Valennia here...
    .complete 92640,1 --Speak with Valennia Stormfist
    .target Valennia Stormfist

step << Horde
    #label BloodHorde
    .goto 2521,59.15,79.79
    >>...Ayessa for the Windshapers (and hand her the 10 charms)...
    .complete 92640,2 --Recruit the Windshapers
    .turnin 93740 >> Turn in Blood for Blood
    .target Ayessa Dawnsinger

step << Horde
    .goto 2521,66.54,79.89
    >>...and Elaadrin for the High Order
    .complete 92640,3 --Recruit the High Order
    .target Elaadrin Evengale

step << Horde
    .goto 2521,66.18,76.65
    >>The tower one last time: Valennia
    .turnin 92640,2 >> Turn in Desperate Times << Warrior
    .turnin 92640 >> Turn in Desperate Times << !Warrior
    .accept 93065 >> Accept Prepare for Battle
    .target Valennia Stormfist

step << Horde
    .goto 2521,61.15,70.91
    >>Glide down and find Valennia on the road north
    .complete 93065,1 --Find Valennia on the Road
    .turnin 93065 >> Turn in Prepare for Battle
    .accept 92947 >> Accept Making Our Move
    .target Valennia Stormfist

step << Horde
    .goto 2521,62.00,50.10,40,0
    >>North to the Shrine of Akir as soon as the talking ends (the army doesn't come with you): 7 Al'Aketh Guardians, 7 Spiritcallers and 7 Blademasters (the Blademasters hold the outer edge, not the central square)
    .goto 2521,61.70,50.50,40,0
    .complete 92947,1 --Al'Aketh Guardian (7)
    .complete 92947,2 --Al'Aketh Spiritcaller (7)
    .complete 92947,3 --Al'Aketh Blademaster (7)
    .mob Al'Aketh Guardian
    .mob Al'Aketh Spiritcaller
    .mob Al'Aketh Blademaster

step << Horde
    .goto 2521,63.80,50.50
    >>Hyusaa Quickbreeze by the shrine steps
    .complete 92947,4 --Report to Hyusaa Quickbreeze
    .turnin 92947 >> Turn in Making Our Move
    .accept 93958 >> Accept The Inner Sanctum
    .target Hyusaa Quickbreeze

step << Horde
    .goto 2521,65.20,50.50
    >>Into the inner sanctum: Valennia
    .turnin 93958 >> Turn in The Inner Sanctum
    .accept 92646 >> Accept Confront Lorthuna
    .target Valennia Stormfist

step << Horde
    .goto 2521,65.40,50.50
    >>Take the portal beside Valennia up to the Rohashi Spires. Go to the west end of the platform you land on and wait for the wind bridge: it takes a while to appear and pulls you across by itself (no gusts after a while? talk to the guard). On the far side find Ayessa, then fight Lorthuna with Ayessa and Elaadrin. Afterward take the portal back to Valanaar before it closes (port out early and you'll have to come back through this portal)
    .complete 92646,1 --Confront Lorthuna
    .target Ayessa Dawnsinger

step << Horde
    .goto 2521,59.15,79.77
    >>Back in Valanaar: Ayessa
    .turnin 92646,3 >> Turn in Confront Lorthuna << Warrior
    .turnin 92646 >> Turn in Confront Lorthuna << !Warrior
    .accept 93836 >> Accept The Fate of Zephras
    .target Ayessa Dawnsinger

step << Horde
    .goto 2521,66.20,76.50
    >>Up the tower: Talaanis
    .complete 93836,1 --Speak with Talaanis Shadowsong
    .turnin 93836 >> Turn in The Fate of Zephras
    .accept 93090 >> Accept What Comes Next
    .target Talaanis Shadowsong

step << Horde
    .goto 2521,59.15,79.77
    >>Ayessa, once you're ready to leave Zephras
    .turnin 93090 >> Turn in What Comes Next
    .accept 95349 >> Accept The Earthen Ring
    .target Ayessa Dawnsinger

step << Alliance
    .goto 2521,66.17,76.52
    >>The tower: hand Talaanis the crystal, take her next quest, then talk to her again to learn from the crystal and stay to watch the conversation that follows (a roleplay -- wait it out)
    .turnin 92644,3 >> Turn in Unfortunate News << Warrior
    .turnin 92644 >> Turn in Unfortunate News << !Warrior
    .accept 94568 >> Accept The Cult's True Plans
    .complete 94568,1 --Learn what you can from the crystal
    .complete 94568,2 --Observe the conversation
    .turnin 94568 >> Turn in The Cult's True Plans
    .accept 92640 >> Accept Desperate Times
    .target Talaanis Shadowsong

step << Alliance
    .goto 2521,66.18,76.65
    >>Desperate times, three voices: Valennia here...
    .complete 92640,1 --Speak with Valennia Stormfist
    .target Valennia Stormfist

step << Alliance
    .goto 2521,59.15,79.79
    >>...Ayessa for the Windshapers...
    .complete 92640,2 --Recruit the Windshapers
    .target Ayessa Dawnsinger

step << Alliance
    #label TurnIn76
    .goto 2521,66.34,79.51
    >>...and on the way back, Iaadaria takes her talons
    .turnin 92741 >> Turn in Unwelcome Visitors
    .target Iaadaria Bitterwind

step << Alliance
    #label TurnIn77
    .goto 2521,66.54,79.89
    >>Elaadrin for the High Order
    .complete 92640,3 --Recruit the High Order
    .turnin 92834,3 >> Turn in Avenged Tenfold << Warrior
    .turnin 92834 >> Turn in Avenged Tenfold << !Warrior
    .target Elaadrin Evengale

step << Alliance
    .goto 2521,66.18,76.65
    >>The tower one last time: Valennia
    .turnin 92640,2 >> Turn in Desperate Times << Warrior
    .turnin 92640 >> Turn in Desperate Times << !Warrior
    .accept 93065 >> Accept Prepare for Battle
    .target Valennia Stormfist

step << Alliance
    .goto 2521,61.15,70.91
    >>Glide down and find Valennia on the road north
    .complete 93065,1 --Find Valennia on the Road
    .turnin 93065 >> Turn in Prepare for Battle
    .accept 92947 >> Accept Making Our Move
    .target Valennia Stormfist

step << Alliance
    .goto 2521,62.00,50.10,40,0
    >>North to the Shrine of Akir as soon as the talking ends (the army doesn't come with you): 7 Al'Aketh Guardians, 7 Spiritcallers and 7 Blademasters (the Blademasters hold the outer edge, not the central square)
    .goto 2521,61.70,50.50,40,0
    .complete 92947,1 --Al'Aketh Guardian (7)
    .complete 92947,2 --Al'Aketh Spiritcaller (7)
    .complete 92947,3 --Al'Aketh Blademaster (7)
    .mob Al'Aketh Guardian
    .mob Al'Aketh Spiritcaller
    .mob Al'Aketh Blademaster

step << Alliance
    .goto 2521,63.80,50.50
    >>Hyusaa Quickbreeze by the shrine steps
    .complete 92947,4 --Report to Hyusaa Quickbreeze
    .turnin 92947 >> Turn in Making Our Move
    .accept 93958 >> Accept The Inner Sanctum
    .target Hyusaa Quickbreeze

step << Alliance
    .goto 2521,65.20,50.50
    >>Into the inner sanctum: Valennia
    .turnin 93958 >> Turn in The Inner Sanctum
    .accept 93835 >> Accept Confront Lorthuna
    .target Valennia Stormfist

step << Alliance
    .goto 2521,65.40,50.50
    >>Take the portal beside Valennia up to the Rohashi Spires. Go to the west end of the platform you land on and wait for the wind bridge: it takes a while to appear and pulls you across by itself (no gusts after a while? talk to the guard). On the far side talk to Elaadrin Evengale (don't take the portal upstairs, it sends you back to town), then fight Lorthuna with Elaadrin and Ayessa. Afterward a Kirin Tor mage opens a portal back to Valanaar: take it before it closes
    .complete 93835,1 --Confront Lorthuna
    .target Elaadrin Evengale

step << Alliance
    .goto 2521,66.50,79.80
    >>Back in Valanaar: Elaadrin in the High Order lodge
    .turnin 93835,3 >> Turn in Confront Lorthuna << Warrior
    .turnin 93835 >> Turn in Confront Lorthuna << !Warrior
    .accept 94369 >> Accept The Fate of Zephras
    .target Elaadrin Evengale

step << Alliance
    .goto 2521,66.20,76.50
    >>Up the tower: Talaanis
    .complete 94369,1 --Speak with Talaanis Shadowsong
    .turnin 94369 >> Turn in The Fate of Zephras
    .accept 93089 >> Accept What Comes Next
    .target Talaanis Shadowsong

step << Alliance
    .goto 2521,66.50,79.80
    >>Elaadrin, once you're ready to leave Zephras
    .turnin 93089 >> Turn in What Comes Next
    .accept 94946 >> Accept The Magical City of Dalaran
    .target Elaadrin Evengale

step << Alliance
    .goto 2521,65.81,83.44
    >>The skycutter to Dalaran leaves from the small dock southeast of Valanaar, not the big dock. It waits about a minute and is back about 4 minutes after it leaves (repair, cook and spend talents while you wait). Ride it off the isle
    .zone 1416 >> Take the skycutter to Dalaran City

step << Alliance
    .goto 1416/0,438.93,448.88
    >>On the platform: Denaaris Stargale (don't jump off early)
    .turnin 94946 >> Turn in The Magical City of Dalaran
    .accept 94947 >> Accept Welcome to Azeroth
    .target Denaaris Stargale

step << Alliance Druid
    .goto 1416,11.80,56.50
    >>DRUID: Take Child of Nature from Alfina Nightgaze, beside the portal to Stormwind
    .accept 94912 >> Accept Child of Nature
    .target Alfina Nightgaze

step << Alliance
    .goto 1416/0,445.93,450.00
    >>Take the Skyborne portal to Stormwind
    .complete 94947,1 --Take the portal to Stormwind

step << Alliance Druid
    .goto 1453/0,1100.200,-8776.400
    >>DRUID: Sheldras Moontree in Stormwind: hand in Child of Nature and take Moonglade. He teaches you Teleport: Moonglade; the trip to Dendrite Starblaze in Nighthaven can wait until you have a few minutes
    .target Sheldras Moontree::5504
    .turnin 94912 >> Turn in Child of Nature
    .accept 94914 >> Accept Moonglade

step << Alliance
    .goto 1453/0,332.00,-8443.10
    >>Through Stormwind to the Keep: Highlord Bolvar Fordragon (skip his Exploring the Alliance capital tour -- it needs Darnassus and Ironforge trips this route doesn't make)
    .turnin 94947 >> Turn in Welcome to Azeroth
    .accept 98021 >> Accept Journey to Sentinel Hill << !Hunter
    .target Highlord Bolvar Fordragon

step << Alliance
    +Zephras complete -- you're ~13 in Stormwind. Grab the Deeprun Tram or the Sentinel Hill road: our "13-15 Westfall (Warrior)" guide picks up at Sentinel Hill, where Journey to Sentinel Hill pays out at Gryan Stoutmantle. Banked: Exploring the Alliance (long-haul exploration)

step << Horde
    .goto 2521,57.92,80.78
    >>The skycutter to Mulgore docks just outside the Windshaper lodge; it can take several minutes to arrive. Ride it off the isle
    .zone 1412 >> Take the skycutter to Mulgore

step << Horde
    .goto 1412/1,426.10,-658.00
    >>On the Skywatcher Plateau: Alaana Stormwalker
    .turnin 95349 >> Turn in The Earthen Ring
    .accept 95350 >> Accept Welcome to Azeroth
    .target Alaana Stormwalker

step << Horde Druid Skyborne
    .goto 1412/1,423.400,-659.000
    >>DRUID: Take Child of Nature at Muln Earthfury
    .target Muln Earthfury::259118
    .accept 94911 >> Accept Child of Nature

step << Horde Druid Skyborne
    .goto 1456/1,-281.500,-1039.900
    >>DRUID: Turak Runetotem on Elder Rise in Thunder Bluff: hand in Child of Nature and take Moonglade. He teaches you Teleport: Moonglade; the trip to Dendrite Starblaze in Nighthaven can wait until you have a few minutes
    .turnin 94911 >> Turn in Child of Nature
    .accept 94913 >> Accept Moonglade
    .target Turak Runetotem::3033

step << Horde
    .goto 1456/1,26.50,-1196.70
    >>Down into Thunder Bluff: Tal the wind rider master
    .fly Orgrimmar >> Fly to Orgrimmar
    .target Tal

step << Horde
    .goto 1454/1,-4439.41,1633.87
    >>Orgrimmar: Innkeeper Gryshka
    .home >> Set your Hearthstone to Orgrimmar
    .target Innkeeper Gryshka

step << Horde
    .goto 1454/1,-4460.00,1598.60
    >>Thatog, near the inn in the Valley of Strength: he wants his son Migi's lunch delivered
    .accept 97246 >> Accept Meal Appeal
    .target Thatog

step << Horde
    .goto 1454/1,-4482.60,1775.00
    >>Borstan at his firepit: tell him you're there for Migi's lunch
    .turnin 97246 >> Turn in Meal Appeal
    .accept 97249 >> Accept Favorite Food
    .target Borstan

step << Horde
    .goto 1454/1,-4466.80,1954.80
    >>Kor'geld in Yelmak's Alchemy and Potions, in the Drag
    .accept 97242 >> Accept Yelmak's Medley
    .target Kor'geld

step << Horde
    .goto 1454/1,-4653.90,1950.30,20,0
    >>Valley of Honor: cut 2 Cattails and 4 Speargrass from the plants growing along the water
    .goto 1454/1,-4609.80,2013.50,20,0
    .complete 97242,1 --Handful of Cattails (2)
    .complete 97242,2 --Speargrass Cuttings (4)

step << Horde Warrior
    .goto 1454/1,-4801.42,1980.53
    >>Grezz Ragefist trains warriors, if anything's pending
    .trainer >> Train your class abilities
    .target Grezz Ragefist

step << Horde
    .goto 1454/1,-4466.90,1954.50
    >>Kor'geld, then Yelmak, then Whuut -- the medley makes its rounds
    .turnin 97242 >> Turn in Yelmak's Medley
    .target Kor'geld
    .goto 1454/1,-4477.90,1964.80
    .accept 97275 >> Accept Whuut's the Rush
    .target Yelmak
    .goto 1454/1,-4463.00,1966.20
    .turnin 97275 >> Turn in Whuut's the Rush
    .target Whuut

step << Horde
    .goto 1454/1,-4193.40,2001.80
    >>Migi plays with the other kids behind Grommash Hold: walk around to the back of the building
    .turnin 97249 >> Turn in Favorite Food
    .target Migi

step << Horde
    .goto 1454/1,-4205.80,2007.80
    >>Thra, one of the kids beside Migi (the quest only shows up once Meal Appeal, Yelmak's Medley and Favorite Food are done). If lots of players are hunting boulders, it's fine to skip this one
    .accept 97326 >> Accept Rocks to Rests
    .target Thra

step << Horde
    #loop
    .goto 1454/1,-4235.41,2008.75,12,0 --c:1454,39.6,28.6
    >>Smooth Boulders are small light-brown rocks poking out of the ground at a slant: they're scattered around the kids' corner and down through the Valley of Wisdom, and each one comes back a few minutes after it's taken (if others are after them too, wait by a cluster)
    .goto 1454/1,-4262.05,2001.23,12,0 --c:1454,41.5,29.4
    .goto 1454/1,-4308.33,1980.57,12,0 --c:1454,44.8,31.6
    .goto 1454/1,-4337.78,1967.43,12,0 --c:1454,46.9,33.0
    .goto 1454/1,-4294.31,1953.34,12,0 --c:1454,43.8,34.5
    .goto 1454/1,-4260.65,1954.28,12,0 --c:1454,41.4,34.4
    .goto 1454/1,-4299.92,1914.84,12,0 --c:1454,44.2,38.6
    .goto 1454/1,-4350.40,1911.08,12,0 --c:1454,47.8,39.0
    .complete 97326,1 --Smooth Boulder (8)

step << Horde
    .goto 1454/1,-4205.90,2007.80
    >>Back to Thra: pick any of the Friendship Bracelets
    .turnin 97326 >> Turn in Rocks to Rests
    .target Thra

step << Horde
    .goto 1454/1,-4126.30,1920.10
    >>Thrall in Grommash Hold
    .turnin 95350 >> Turn in Welcome to Azeroth
    .accept 98024 >> Accept Journey to the Crossroads
    .target Thrall

step << Horde
    .goto 1454/1,-4226.78,1914.77
    >>Zor Lonetree, just outside Grommash Hold: he offers The Spirits of Stonetalon from level 13 (if you're still 12, walk on: it keeps)
    .accept 1061,2,1061 >> Accept The Spirits of Stonetalon
    .target Zor Lonetree

step << Horde !Hunter
    .goto 1411/1,-4648.55,1321.88,40,0
    >>Out to Durotar's zeppelin towers
    .zone Tirisfal Glades >> Take the Zeppelin to Tirisfal Glades

step << Horde !Hunter
    .goto 1420/0,254.60,2225.80
    >>Brill: Deathguard Terrence
    .accept 96895 >> Accept The Argent Emissary
    .target Deathguard Terrence

step << Horde !Hunter
    .goto 1420/0,346.94,2258.95
    >>Apothecary Johaan, also in Brill: take his findings for the Sepulcher in Silverpine Forest
    .accept 445 >> Accept Delivery to Silverpine Forest
    .target Apothecary Johaan

step << Horde !Hunter
    .goto 1420/0,54.60,1996.60
    >>Southeast of Brill, near the Undercity entrance: Hadric Harlson of the Argent Dawn
    .turnin 96895 >> Turn in The Argent Emissary
    .accept 96897 >> Accept The Cult of the Damned
    .accept 96898 >> Accept Remnants of War
    .target Hadric Harlson

step << Horde !Hunter
    .goto 1420/0,-30.40,1894.40
    >>The cult camp just southeast of Hadric: 8 Dark Neophytes and 8 Dark Enforcers, and 12 Necrotic Crystal Fragments (pick up the crystal shards on the ground; the cultists drop them too, but not often)
    >>They're tough for level 12: the Neophytes' Shadow Bolts take a big bite of your health and they never run out of mana, and the Enforcers hit hard, with an instant strike for 50-75. Pull one at a time
    .complete 96897,2 --Dark Enforcer (8)
    .complete 96897,1 --Dark Neophyte (8)
    .complete 96898,1 --Necrotic Crystal Fragment (12)
    .mob Dark Enforcer
    .mob Dark Neophyte

step << Horde !Hunter
    .goto 1420/0,54.50,1996.40
    >>Back to Hadric Harlson
    .turnin 96897 >> Turn in The Cult of the Damned
    .turnin 96898 >> Turn in Remnants of War
    .target Hadric Harlson

step << Horde !Hunter
    .goto 1420/0,240.75,1877.57,20,0
    >>Into the Undercity, down to the Trade Quarter: Michael Garrett
    .goto 1458/0,266.39,1567.11
    .fp Undercity >> Get the Undercity flight path
    .target Michael Garrett

step << Horde !Hunter
    .goto 1458/0,539.33,1665.49,15,0
    >>Out through the sewers and southwest
    .goto 1420/0,629.36,1553.42
    .zone Silverpine Forest >> Cross into Silverpine Forest

step << Horde !Hunter
    +Zephras complete -- you're ~12-13 entering Silverpine. Our "12-14 Silverpine Forest (Horde)" guide continues from here. Banked: Journey to the Crossroads (Thork), The Spirits of Stonetalon (if you were 13 at Zor Lonetree), and Delivery to Silverpine (turned in at the Sepulcher in the next guide)

step << Horde Hunter
    +Zephras complete -- you're ~12-13 in Orgrimmar. Hunters head to the Barrens next: out of Orgrimmar and down the road to the Crossroads, where our "12-17 The Barrens (Horde)" guide picks up and Journey to the Crossroads pays out at Thork. Banked: The Spirits of Stonetalon (if you were 13 at Zor Lonetree)
]])
