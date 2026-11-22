-- =====================================================================
--  Custom WoW: Forever guide -- Orc/Troll start, 1-12 (Warrior-optimized)
--  Chunks: 1-6 Valley of Trials > 6-10 Durotar > 10-12 Durotar/Orgrimmar >
--  10-12 Tirisfal, chaining into our "12-14 Silverpine Forest" (Guide_Undead_1-14.lua).
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Alliance" then return end

-- =================== 1-6 VALLEY OF TRIALS ============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 1-6 Valley of Trials (Orc/Troll)
#next 6-10 Durotar (Orc/Troll)
<< Horde

step
    #completewith next
    +Orc/Troll starter, warrior-optimized. If you didn't start in the Valley of Trials, walk here first

step
    .goto 1411/1,-4251.46,-607.35
    >>Talk to Kaltunk on the rise
    .accept 4641 >> Accept Your Place In The World
    .target Kaltunk

step << Warrior
    .goto 1411/1,-4299.05,-494.90,30,0
    >>Kill Mottled Boars until you have ~10 copper of loot (your starter armor sells too)
    .goto 1411/1,-4214.45,-565.75
    >>Sell to Duokna
    .vendor >> Vendor trash
    .target Duokna
    .mob Mottled Boar

step
    .goto 1411/1,-4186.42,-599.95
    >>Talk to Gornek in the cave
    .turnin 4641 >> Turn in Your Place In The World
    .accept 788 >> Accept Cutting Teeth
    .target Gornek

step << Warrior
    .goto 1411/1,-4230.31,-639.43
    >>Frang, deeper in the cave
    .train 6673 >> Train Battle Shout
    .target Frang

step
    .goto 1411/1,-4283.18,-512.53
    >>Kill 10 Mottled Boars
    .complete 788,1 --Mottled Boar (10)
    .mob Mottled Boar

step
    .goto 1411/1,-4108.70,-397.96
    >>Hana'zua lies wounded to the northeast
    .accept 790 >> Accept Sarkoth
    .target Hana'zua

step
    .goto 1411/1,-4109.22,-546.37
    >>Kill Sarkoth on the plateau above and take his claw
    .complete 790,1 --Sarkoth's Mangled Claw
    .mob Sarkoth

step
    .goto 1411/1,-4108.70,-397.96
    >>Back to Hana'zua
    .turnin 790 >> Turn in Sarkoth
    .accept 804 >> Accept Sarkoth
    .target Hana'zua

step
    .goto 1411/1,-4186.42,-599.95
    >>Gornek
    .turnin 788 >> Turn in Cutting Teeth
    .turnin 804 >> Turn in Sarkoth
    .accept 789 >> Accept Sting of the Scorpid
    .accept 2383 >> Accept Simple Parchment << Orc Warrior
    .accept 3065 >> Accept Simple Tablet << Troll Warrior
    .target Gornek

step << Orc Hunter
    .goto 1411/1,-4198.58,-602.41,12,0
    >>HUNTER: Take Etched Parchment at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3087 >> Accept Etched Parchment
    .target Gornek

step << Orc Mage
    .goto 1411/1,-4198.58,-602.41,12,0
    >>MAGE: Take Glyphic Parchment at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 98576 >> Accept Glyphic Parchment
    .target Gornek

step << Orc Rogue
    .goto 1411/1,-4198.58,-602.41,12,0
    >>ROGUE: Take Encrypted Parchment at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3088 >> Accept Encrypted Parchment
    .target Gornek

step << Orc Shaman
    .goto 1411/1,-4198.58,-602.41,12,0
    >>SHAMAN: Take Rune-Inscribed Parchment at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3089 >> Accept Rune-Inscribed Parchment
    .target Gornek

step << Orc Warlock
    .goto 1411/1,-4198.05,-605.59,12,0
    >>WARLOCK: Take Tainted Parchment at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3090 >> Accept Tainted Parchment
    .target Gornek

step << Troll Hunter
    .goto 1411/1,-4198.58,-602.41,12,0
    >>HUNTER: Take Etched Tablet at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3082 >> Accept Etched Tablet
    .target Gornek

step << Troll Mage
    .goto 1411/1,-4198.58,-602.41,12,0
    >>MAGE: Take Glyphic Tablet at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3086 >> Accept Glyphic Tablet
    .target Gornek

step << Troll Priest
    .goto 1411/1,-4198.58,-602.41,12,0
    >>PRIEST: Take Hallowed Tablet at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3085 >> Accept Hallowed Tablet
    .target Gornek

step << Troll Rogue
    .goto 1411/1,-4198.58,-602.41,12,0
    >>ROGUE: Take Encrypted Tablet at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3083 >> Accept Encrypted Tablet
    .target Gornek

step << Troll Shaman
    .goto 1411/1,-4198.58,-602.41,12,0
    >>SHAMAN: Take Rune-Inscribed Tablet at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 3084 >> Accept Rune-Inscribed Tablet
    .target Gornek

step << Troll Warlock
    .goto 1411/1,-4198.05,-605.59,12,0
    >>WARLOCK: Take Tainted Tablet at Gornek
    .goto 1411/1,-4186.42,-599.95
    .accept 98575 >> Accept Tainted Tablet
    .target Gornek

step << Rogue
    .goto 1411/1,-4144.65,-588.67
    >>ROGUE: Hand in Encrypted Tablet, Encrypted Parchment at Rwag; train at your class trainer
    .turnin 3083 >> Turn in Encrypted Tablet << Troll Rogue
    .turnin 3088 >> Turn in Encrypted Parchment << Orc Rogue
    .train 53
    .target Rwag
    .money <0.04
    .xp <4,1

step << Rogue
    .goto 1411/1,-4144.65,-588.67
    >>ROGUE: Hand in Encrypted Tablet, Encrypted Parchment at Rwag
    .turnin 3083 >> Turn in Encrypted Tablet << Troll Rogue
    .turnin 3088 >> Turn in Encrypted Parchment << Orc Rogue
    .target Rwag

step << Warlock
    .goto 1411/1,-4111.87,-607.00
    >>WARLOCK: Hand in Tainted Parchment, Tainted Tablet at Nartok; train at your class trainer
    .turnin 3090 >> Turn in Tainted Parchment << Orc Warlock
    .turnin 98575 >> Turn in Tainted Tablet << Troll Warlock
    .train 172
    .target Nartok

step << Warrior
    #optional
    .goto 1411/1,-4106.00,-593.40
    >>Doing the sharpening-stone routine? Norzsh trains Mining and sells a Mining Pick
    .train 2575 >> Train Mining
    .collect 2901,1 --Mining Pick
    .disablecheckbox
    .target Norzsh

step
    .goto 1411/1,-4221.85,-561.52
    >>Galgar by the fire
    .accept 4402 >> Accept Galgar's Cactus Apple Surprise
    .target Galgar

step << Shaman
    .goto 1411/1,-4203.87,-623.92
    >>SHAMAN: Hand in Rune-Inscribed Tablet, Rune-Inscribed Parchment at Shikrik
    .turnin 3084 >> Turn in Rune-Inscribed Tablet << Troll
    .turnin 3089 >> Turn in Rune-Inscribed Parchment << Orc
    .target Shikrik

step << Mage
    .goto 1411/1,-4210.22,-625.33
    >>MAGE: Hand in Glyphic Tablet, Glyphic Parchment at Mai'ah; train at your class trainer
    .turnin 3086 >> Turn in Glyphic Tablet << Troll Mage
    .turnin 98576 >> Turn in Glyphic Parchment << Orc Mage
    .train 1459
    .target Mai'ah

step << Warlock
    .goto 1411/1,-4214.40,-624.00
    >>WARLOCK: Ruzan by the cave has your version of the familiar cull
    .accept 1485 >> Accept Vile Familiars
    .turnin 1485 >> Turn in Vile Familiars
    .accept 1499 >> Accept Vile Familiars
    .target Ruzan

step << !Warlock
    .goto 1411/1,-4228.19,-629.20
    >>Zureetha Fargaze at the cave mouth
    .accept 792 >> Accept Vile Familiars
    .target Zureetha Fargaze

step << Hunter
    .goto 1411/1,-4227.66,-635.20
    >>HUNTER: Hand in Etched Tablet, Etched Parchment at Jen'shan
    .turnin 3082 >> Turn in Etched Tablet << Troll
    .turnin 3087 >> Turn in Etched Parchment << Orc
    .target Jen'shan

step << Warrior
    .goto 1411/1,-4230.31,-639.43
    >>Deliver your letter to Frang
    .turnin 2383 >> Turn in Simple Parchment << Orc
    .turnin 3065 >> Turn in Simple Tablet << Troll
    .target Frang

step
    .goto 1411/1,-4322.31,-611.58
    >>Foreman Thazz'ril
    .accept 5441 >> Accept Lazy Peons
    .target Foreman Thazz'ril

step
    #sticky
    #completewith TurnIn19
    >>Grab the 10 Cactus Apples growing at the cacti as you quest
    .complete 4402,1 --Cactus Apple (10)

step
    .goto 1411/1,-4284.24,-283.05
    >>Kill Scorpid Workers for 10 tails
    .complete 789,1 --Scorpid Worker Tail (10)
    .mob Scorpid Worker

step
    .goto 1411/1,-4281.07,-148.75
    >>Kill 12 Vile Familiars at the northern fires
    .complete 792,1 --Vile Familiar (12) << !Warlock
    .complete 1499,1 --Vile Familiar (12) << Warlock
    .mob Vile Familiar

step
    #label Peons
    .goto 1411/1,-4467.19,-506.53
    >>Whack 5 sleeping Lazy Peons with the Foreman's Blackjack (they nap by the trees)
    .use 16114
    .complete 5441,1 --Peons Awoken (5)
    .target Lazy Peon

step
    #optional
    .isOnQuest 4402
    .goto 1411/1,-4338.17,-360.60
    >>Still short on Cactus Apple? Cactus Apple -- around here. This step skips itself once you have them
    .complete 4402,1 --Cactus Apple (10)

step
    #label TurnIn19
    .goto 1411/1,-4221.85,-561.52
    >>Galgar, apples in hand
    .turnin 4402 >> Turn in Galgar's Cactus Apple Surprise
    .target Galgar

step
    .goto 1411/1,-4186.42,-599.95
    >>Gornek
    .turnin 789 >> Turn in Sting of the Scorpid
    .target Gornek

step
    .goto 1411/1,-4228.19,-629.20
    >>Zureetha
    .turnin 792 >> Turn in Vile Familiars << !Warlock
    .turnin 1499 >> Turn in Vile Familiars << Warlock
    .accept 794 >> Accept Burning Blade Medallion
    .target Zureetha Fargaze

step << Warrior
    .goto 1411/1,-4230.31,-639.43
    >>Level 4 training with Frang
    .train 100 >> Train Charge
    .train 772 >> Train Rend
    .target Frang

step
    .goto 1411/1,-4322.31,-611.58
    >>Thazz'ril again
    .turnin 5441 >> Turn in Lazy Peons
    .accept 6394 >> Accept Thazz'ril's Pick
    .target Foreman Thazz'ril

step
    .goto 1411/1,-4274.19,-87.76
    >>Into the Burning Blade cave (entrance at -4360,-175): the pick leans against the wall near the pool
    .complete 6394,1 --Thazz'ril's Pick

step
    .goto 1411/1,-4220.26,-59.56
    >>Kill Yarrog Baneshadow on the ledge and loot the medallion
    .complete 794,1 --Burning Blade Medallion
    .mob Yarrog Baneshadow

step
    #optional
    .goto 1411/1,-4250.40,-88.82
    .xp 5 >> Short of 5? The cave's cultists are dense XP

step
    .goto 1411/1,-4322.31,-611.58
    >>Walk out to Thazz'ril
    .turnin 6394 >> Turn in Thazz'ril's Pick
    .target Foreman Thazz'ril

step
    .goto 1411/1,-4228.19,-629.20
    >>Zureetha
    .turnin 794 >> Turn in Burning Blade Medallion
    .accept 805 >> Accept Report to Sen'jin Village
    .target Zureetha Fargaze

step
    .goto 1411/1,-4223.80,-631.00
    >>Click the Worn Journal on the barrel beside her
    .accept 96652 >> Accept The Adventurer

step << Warrior
    .goto 1411/1,-4230.31,-639.43
    >>Level 6 with Frang before you leave
    .train 3127 >> Train Parry
    .train 6343 >> Train Thunder Clap
    .target Frang

step << Priest
    .goto Durotar,42.5,68.5
    >>PRIEST (trolls): Ken'jai beside the Den takes your Hallowed note and points you to Tai'jin in Razor Hill -- it banks till then
    .accept 5649 >> Accept In Favor of Spirituality
    .target Ken'jai

step << Shaman
    .goto 1411/1,-4204.30,-629.90
    >>Shamans: Canaga Earthcaller starts your first totem -- Felstalker Hooves drop from the felstalkers by the Burning Blade den; you may have them already
    .accept 1516 >> Accept Call of Earth
    .collect 6640,2,1516 --Felstalker Hoof (2)
    .turnin 1516 >> Turn in Call of Earth
    .accept 1517 >> Accept Call of Earth
    .target Canaga Earthcaller

step << Priest
    .goto 1411/1,-4202.28,-617.22
    >>PRIEST: Train at your class trainer
    .train 1243
    .train 589
    .money <0.011
    .target Ken'jai

step << Priest
    .goto 1411/1,-4202.28,-617.22
    >>PRIEST: Train at your class trainer
    .train 589
    .money <0.01
    .target Ken'jai

step << Priest
    .goto 1411/1,-4202.28,-617.22
    >>PRIEST: Train at your class trainer; hand in Hallowed Tablet at Ken'jai
    .train 589
    .turnin 3085 >> Turn in Hallowed Tablet
    .money <0.021
    .target Ken'jai

step << Priest
    .goto 1411/1,-4202.28,-617.22
    >>PRIEST: Train at your class trainer; hand in Hallowed Tablet at Ken'jai
    .train 1243
    .train 589
    .turnin 3085 >> Turn in Hallowed Tablet
    .money <0.011
    .target Ken'jai

step << Priest
    .goto 1411/1,-4202.28,-617.22
    >>PRIEST: Train at your class trainer; hand in Hallowed Tablet at Ken'jai
    .train 589
    .turnin 3085 >> Turn in Hallowed Tablet
    .money <0.01
    .target Ken'jai

step << Shaman
    .goto 1411/1,-4290.50,-877.70
    >>Spirit Rock, south of camp: drink the Earth Sapta, defeat the Minor Manifestation of Earth, and take its Rough Quartz
    .turnin -1517 >> Turn in Call of Earth

step << Shaman
    .goto 1411/1,-4290.50,-877.70
    >>Take Call of Earth at Minor Manifestation of Earth
    .accept 1518,2,1517 >> Accept Call of Earth
    .mob Minor Manifestation of Earth

step << Shaman
    .goto 1411/1,-4204.30,-629.90
    >>Canaga -- EARTH TOTEM
    .turnin -1518 >> Turn in Call of Earth
    .target Canaga Earthcaller

step
    .goto 1411/1,-4600.96,-603.82,25
    >>Head out of the Valley of Trials
]])

-- ====================== 6-10 DUROTAR =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 6-10 Durotar (Orc/Troll)
#next 10-12 Durotar (Orc/Troll)
<< Horde

step
    .goto 1411/1,-4715.17,-599.24
    >>Ukor on the road
    .accept 2161 >> Accept A Peon's Burden
    .target Ukor

step
    .goto 1411/1,-4713.00,140.60
    >>Brakk's camp up the road: turn in the journal
    .turnin 96652 >> Turn in The Adventurer
    .accept 96604 >> Accept The Great Outdoors
    .target Brakk

step
    .goto 1411/1,-4715.20,140.10
    >>Type /sit at the campfire and stay seated a minute for the boosted rest buff
    .complete 96604,1 --Sit at the campfire
    .complete 96604,2 --Gain the boosted rest buff

step
    .goto 1411/1,-4713.00,140.60
    >>Brakk
    .turnin 96604 >> Turn in The Great Outdoors
    .accept 96655 >> Accept Camping 101: Cooking
    .target Brakk

step
    .goto 1411/1,-4724.69,287.30
    >>Razor Hill: Orgnil Soulscar in the bunker
    .accept 99048 >> Accept A Missing Hand
    .target Orgnil Soulscar

step
    .goto 1411/1,-4709.36,274.96
    >>Gar'Thok beside him
    .accept 784 >> Accept Vanquish the Betrayers
    .accept 837 >> Accept Encroachment
    .target Gar'Thok

step
    .goto 1411/1,-4663.88,310.56
    >>Cook Torka: train Cooking, grab both her quests
    .train 2550 >> Train Cooking
    .turnin 96655 >> Turn in Camping 101: Cooking
    .accept 815 >> Accept Break a Few Eggs
    .accept 96825 >> Accept This Fruit Could Bite Back
    .target Cook Torka

step
    .goto 1411/1,-4600.43,384.59
    >>Furl Scornbrow atop the watchtower
    .accept 791 >> Accept Carry Your Weight
    .target Furl Scornbrow

step << Warrior
    #optional
    .goto 1411/1,-4714.64,372.60
    >>Smithing corner: Dwukk trains Blacksmithing, Krunn trains Mining (-4701,366), Wuark sells picks -- Rough Sharpening Stones are +2 weapon damage
    .train 2018 >> Train Blacksmithing
    .target Dwukk

step
    .goto 1411/1,-4815.20,306.80
    >>Turroc by the barracks
    .accept 96822 >> Accept For Honor
    .target Turroc

step
    .goto 1411/1,-4686.09,340.52
    >>Innkeeper Grosk: deliver the beer, set your hearth
    .turnin 2161 >> Turn in A Peon's Burden
    .home >> Set your Hearthstone to Razor Hill
    .target Innkeeper Grosk

step << Warrior
    .goto 1411/1,-4827.27,311.62
    >>Train with Tarshaw Jaggedscar in the barracks
    .trainer >> Train your class abilities
    .target Tarshaw Jaggedscar

step << Warrior
    #optional
    .goto 1411/1,-4826.74,330.30
    >>Rawrk trains First Aid next door
    .train 3273 >> Train First Aid
    .target Rawrk

step
    #sticky
    #completewith SenjinHub
    >>Sen'jin-bound kills along the beach: Surf Crawlers (8 Crawler Mucus) and Makrura (4 Intact Makrura Eyes)
    .complete 818,2 --Crawler Mucus (8)
    .complete 818,1 --Intact Makrura Eye (4)
    .mob Pygmy Surf Crawler
    .mob Surf Crawler
    .mob Makrura Shellhide
    .mob Makrura Clacker

step
    .goto 1411/1,-4828.32,-777.61
    >>Lar Prowltusk patrols outside Sen'jin Village
    .accept 786 >> Accept Thwarting Kolkar Aggression
    .target Lar Prowltusk

step
    .goto 1411/1,-4885.20,-852.50
    >>Xar'Ti by the raptors
    .accept 97223 >> Accept Bloodtalon Matriarch
    .target Xar'Ti

step
    #label SenjinHub
    .goto 1411/1,-4920.86,-797.70
    >>Sen'jin Village pickups
    .accept 817 >> Accept Practical Prey
    .accept 96821 >> Accept Legging It
    .target Vel'rin Fang
    .goto 1411/1,-4920.33,-814.27
    .accept 818 >> Accept A Solvent Spirit
    .accept 97225 >> Accept Forgotten Loa Idols
    .target Master Vornal
    .goto 1411/1,-4920.33,-825.55
    .turnin 805 >> Turn in Report to Sen'jin Village
    .accept 808 >> Accept Minshina's Skull
    .accept 826 >> Accept Zalazane
    .accept 823 >> Accept Report to Orgnil
    .target Master Gadrin

step << Mage
    .goto Durotar,56.31,75.11
    >>MAGE (trolls): Un'Thuwa in the village hut -- smash the 4 Ju-Ju Heaps scattered around Sen'jin, then collect your spell
    .turnin -1883 >> Turn in Speak with Un'thuwa
    .target Un'Thuwa

step << Mage
    .goto Durotar,56.31,75.11
    >>Take Ju-Ju Heaps at Un'Thuwa
    .accept 1884,2,1883 >> Accept Ju-Ju Heaps
    .target Un'Thuwa

step << Mage
    .goto Durotar,68.1,83.1
    >>Ju-Ju Heaps (4), then hand in Ju-Ju Heaps at Un'Thuwa
    .complete -1884,1 --Ju-Ju Heaps (4)

step << Mage
    .goto Durotar,56.31,75.11
    >>Hand in Ju-Ju Heaps at Un'Thuwa
    .turnin -1884 >> Turn in Ju-Ju Heaps
    .target Un'Thuwa

step << Warrior
    #optional
    .goto 1411/1,-4948.35,-769.15
    >>Trayexir in the big hut: a Large Axe (Orc, ~4s 60c) or Tomahawk (Troll, ~5s 13c) is your first real weapon -- sell your old one toward it
    .collect 2491,1,786,1 --Large Axe << Orc
    .collect 2490,1,786,1 --Tomahawk << Troll
    .disablecheckbox
    .target Trayexir
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.2

step
    .goto 1411/1,-4653.84,-983.47,25,0
    >>Into the Kolkar camp east: burn all three attack plans
    >>Watch for Warlord Kolkanis, a level 9 rare near the tents
    .goto 1411/1,-4596.20,-1057.14
    .complete 786,1 --Attack Plan: Valley of Trials

step
    .goto 1411/1,-4482.52,-917.90
    >>Attack Plan: Sen'jin Village
    .complete -786,2 --Attack Plan: Sen'jin Village

step
    .goto 1411/1,-4406.91,-974.30
    >>Attack Plan: Orgrimmar
    .complete -786,3 --Attack Plan: Orgrimmar

step
    #optional
    .goto 1411/1,-4410.40,-963.50
    >>Pal'juh hides by the last bonfire -- his short escort out of the crag pays well; skip if he's not up
    .accept 99123,1 >> Accept Lost in the Shadows
    .complete 99123,1 --Escort Pal'juh
    .target Pal'juh

step
    .goto 1411/1,-4828.32,-777.61
    >>Catch Lar on his patrol
    .turnin 786 >> Turn in Thwarting Kolkar Aggression
    .target Lar Prowltusk

step
    #optional
    .isQuestComplete 99123
    .goto 1411/1,-4920.90,-814.00
    >>Master Vornal
    .turnin 99123 >> Turn in Lost in the Shadows
    .target Master Vornal

step
    .goto 1411/1,-4565.70,-192.30
    >>OPTIONAL elite: Ukorsbane stalks the ridges -- group him or skip; his drop starts a quest
    .collect 275722,1,96876 --Ukor's Lost Pack
    .accept 96876 >> Accept Ukor's Lost Pack
    .mob Ukorsbane

step
    .goto 1411/1,-4710.40,-209.40
    >>Kill 6 Ridgeshade Lurkers and 6 Ridgeshade Creepers among the rocks
    .complete 96821,2 --Ridgeshade Lurker (6)
    .complete 96821,1 --Ridgeshade Creeper (6)
    .mob Ridgeshade Lurker
    .mob Ridgeshade Creeper

step
    .goto 1411/1,-4979.20,-232.80
    >>South to Tiragarde Keep: kill 10 Kul Tiras Sailors and 8 Marines, looting 8 Canvas Scraps
    >>Watch Commander Zalaphil is a level 9 rare here
    .complete 784,1 --Kul Tiras Sailor (10)
    .complete 784,2 --Kul Tiras Marine (8)
    .complete 791,1 --Canvas Scraps (8)
    .mob Kul Tiras Sailor
    .mob Kul Tiras Marine

step
    .goto 1411/1,-4994.90,-182.30
    >>For Honor's trophies lie around the keep: the Raider's Battleaxe here, the Bow by the walls (-5101,-178 or -4992,-234), the Shield north (-4951,-59)
    .complete 96822,2 --Raider's Battleaxe
    .complete 96822,1 --Raider's Bow

step
    .goto 1411/1,-4951.50,-59.60
    >>Raider's Shield
    .complete -96822,3 --Raider's Shield

step
    .goto 1411/1,-5121.78,-245.68
    >>Kill Lieutenant Benedict on the keep's second floor and take his key
    .complete 784,3 --Lieutenant Benedict
    .collect 4882,1,830,1 --Benedict's Key
    .mob Lieutenant Benedict

step
    .goto 1411/1,-5096.40,-223.83
    >>Open the chest upstairs and use the Aged Envelope it holds
    .collect 4881,1,830 --Aged Envelope
    .accept 830 >> Accept The Admiral's Orders
    .use 4881

step
    .goto 1411/1,-4724.69,287.30
    >>Back at Razor Hill: Orgnil first
    .turnin 823 >> Turn in Report to Orgnil
    .accept 806 >> Accept Dark Storms
    .target Orgnil Soulscar

step
    .goto 1411/1,-4709.36,274.96
    >>Then Gar'Thok
    .turnin 784 >> Turn in Vanquish the Betrayers
    .turnin 830 >> Turn in The Admiral's Orders
    .turnin 96821 >> Turn in Legging It
    .accept 825 >> Accept From The Wreckage....
    .accept 831 >> Accept The Admiral's Orders
    .target Gar'Thok

step
    .goto 1411/1,-4600.43,384.59
    >>Furl on the tower
    .turnin 791 >> Turn in Carry Your Weight
    .target Furl Scornbrow

step
    .goto 1411/1,-4815.40,306.50
    >>Turroc
    .turnin 96822 >> Turn in For Honor
    .target Turroc

step << Warrior
    .goto 1411/1,-4827.27,311.62
    >>Level 8 training with Tarshaw
    .trainer >> Train your class abilities
    .target Tarshaw Jaggedscar

step
    #optional
    .goto 1411/1,-4838.37,321.49
    >>Jark sells Small Brown Pouches if your bags pinch
    .collect 4496,1,825,1 --Small Brown Pouch
    .disablecheckbox
    .target Jark

step
    .goto 1411/1,-5061.70,201.70
    >>Heglan Shadeeye at the coast watchpost
    .turnin 99048 >> Turn in A Missing Hand
    .accept 99049 >> Accept Threat from Below
    .target Heglan Shadeeye

step
    .goto 1411/1,-5073.90,244.70
    >>Three washed-up finds along the shore: the Orcish Dagger here...
    .complete 99049,1 --Orcish Dagger

step
    .goto 1411/1,-5140.80,229.10
    >>...the Broken Bone Trident...
    .complete -99049,3 --Broken Bone Trident

step
    .goto 1411/1,-5138.00,314.10
    >>...and the Banner Scrap
    .complete -99049,2 --Banner Scrap

step
    .goto 1411/1,-5253.97,-177.65
    >>Loot 3 Gnomish Toolboxes in and around the wrecked boats south
    .complete 825,1 --Gnomish Tools (3)

step
    .goto 1411/1,-5599.50,-716.70
    >>Swim to the small isle: kill the Bloodtalon Matriarch for her eggs
    .complete 97223,1 --Bloodtalon Matriarch Eggs
    .mob Bloodtalon Matriarch

step
    .goto 1411/1,-5501.95,-1167.12,150
    >>Swim on to the Echo Isles

step
    #sticky
    #completewith TurnIn52
    >>Across the isles: Durotar Tigers (4 furs), Taillasher Eggs on the ground (3, guarded), and Forgotten Loa Idols by the stone walls (8)
    .complete 817,1 --Durotar Tiger Fur (4)
    .complete 815,1 --Taillasher Egg (3)
    .complete 97225,1 --Forgotten Loa Idols (8)
    .mob Durotar Tiger
    .mob Bloodtalon Taillasher

step
    .goto 1411/1,-5517.29,-1293.67
    >>Kill 8 Hexed Trolls and 8 Voodoo Trolls around the ruins
    .complete 826,1 --Hexed Troll (8)
    .complete 826,2 --Voodoo Troll (8)
    .mob Hexed Troll
    .mob Voodoo Troll

step
    .goto 1411/1,-5526.27,-1286.62
    >>Loot a skull from the pile, and kill Zalazane at the hut (he hexes -- burst him)
    .complete 808,1 --Minshina's Skull
    .complete 826,3 --Zalazane's Head
    .mob Zalazane

step
    #label EchoDone
    .goto 1411/1,-5123.90,-1132.93
    >>Finish tigers and taillasher eggs on the way off the isles
    .complete 817,1 --Durotar Tiger Fur (4)
    .complete 815,1 --Taillasher Egg (3)
    .mob Durotar Tiger
    .mob Bloodtalon Taillasher

step
    .goto 1411/1,-4807.17,-1122.35
    >>And the crawler mucus/makrura eyes on the beach north
    .complete 818,2 --Crawler Mucus (8)
    .complete 818,1 --Intact Makrura Eye (4)
    .mob Pygmy Surf Crawler
    .mob Makrura Clacker

step
    #optional
    .isOnQuest 97225
    .goto 1411/1,-5510.41,-1135.04
    >>Still short on Forgotten Loa Idol? Forgotten Loa Idol -- around here. This step skips itself once you have them
    .complete 97225,1 --Forgotten Loa Idols (8)

step
    #label TurnIn45
    .goto 1411/1,-4920.86,-825.90
    >>Sen'jin Village turn-ins: Gadrin, Vornal, Vel'rin
    .turnin 808 >> Turn in Minshina's Skull
    .turnin 826 >> Turn in Zalazane
    .turnin 97225 >> Turn in Forgotten Loa Idols
    .target Master Gadrin
    .goto 1411/1,-4920.86,-813.91
    .turnin 818 >> Turn in A Solvent Spirit
    .target Master Vornal
    .goto 1411/1,-4920.86,-797.70
    .turnin 817 >> Turn in Practical Prey
    .target Vel'rin Fang

step
    .goto 1411/1,-4885.40,-852.40
    >>Xar'Ti
    .turnin 97223 >> Turn in Bloodtalon Matriarch
    .target Xar'Ti

step
    #optional
    .isQuestComplete 96876
    .goto 1411/1,-4715.10,-599.50
    >>Ukor takes his pack back
    .turnin 96876 >> Turn in Ukor's Lost Pack
    .target Ukor

step
    #sticky
    #completewith TurnIn52
    >>Prickly Pear Fruit grows around the quilboar dens -- grab 8
    .complete 96825,1 --Prickly Pear Fruit (8)

step
    #label Quilboar
    .goto 1411/1,-4565.01,82.49
    >>Kill 4 Razormane Quilboars and 4 Scouts at the southern dens
    .complete 837,1 --Razormane Quilboar (4)
    .complete 837,2 --Razormane Scout (4)
    .mob Razormane Quilboar
    .mob Razormane Scout

step
    .goto 1411/1,-4709.36,274.96
    >>Razor Hill: Gar'Thok
    .turnin 825 >> Turn in From The Wreckage....
    .target Gar'Thok

step
    .goto 1411/1,-4725.00,287.20
    >>Orgnil
    .turnin 99049 >> Turn in Threat from Below
    .target Orgnil Soulscar

step
    #optional
    .isOnQuest 96825
    .goto 1411/1,-4437.05,81.08
    >>Still short on Prickly Pear Fruit? Prickly Pear Fruit -- around here. This step skips itself once you have them
    .complete 96825,1 --Prickly Pear Fruit (8)

step
    #label TurnIn52
    .goto 1411/1,-4665.47,311.62
    >>Cook Torka
    .turnin 815 >> Turn in Break a Few Eggs
    .turnin 96825 >> Turn in This Fruit Could Bite Back
    .target Cook Torka

step << Warrior
    .goto 1411/1,-4827.27,311.62
    >>Level 10 training with Tarshaw
    .trainer >> Train your class abilities
    .target Tarshaw Jaggedscar

step << Priest
    .goto Durotar,54.26,42.93
    >>PRIEST (trolls): Tai'jin takes Ken'jai's introduction. Heal Grunt Kor'ja beside her -- Lesser Heal (Rank 2), then Power Word: Fortitude -- for your first vestments
    .turnin -5649 >> Turn in In Favor of Spirituality
    .target Tai'jin

step << Priest
    .goto Durotar,54.26,42.93
    >>Take Garments of Spirituality at Tai'jin
    .accept 5648,2,5649 >> Accept Garments of Spirituality
    .target Tai'jin

step << Priest
    .goto Durotar,54.26,42.93
    >>Heal Grunt Kor'ja, then hand in Garments of Spirituality at Tai'jin
    .complete -5648,1 --Heal Grunt Kor'ja
    .turnin -5648 >> Turn in Garments of Spirituality
    .target Tai'jin

step << Hunter
    .goto 1411/1,-4704.00,275.30
    >>Hunters -- you're 10: Thotar in the barracks starts your pet chain
    .accept 6062 >> Accept Taming the Beast
    .target Thotar

step << Hunter
    .goto 1411/1,-4579.70,133.90
    >>Use the Taming Rod on a Dire Mottled Boar around the village, then bring the rod back
    .complete 6062,1

step << Hunter
    .goto 1411/1,-4704.07,275.31
    >>Hand in Taming the Beast; take Taming the Beast at Thotar
    .turnin -6062 >> Turn in Taming the Beast
    .accept 6083,2,6062 >> Accept Taming the Beast
    .target Thotar

step << Hunter
    .goto Durotar,60.0,26.2
    >>Tame a Surf Crawler on the coast east of Razor Hill, then return
    .complete -6083,1

step << Hunter
    .goto 1411/1,-4704.07,275.31
    >>Hand in Taming the Beast; take Taming the Beast at Thotar
    .turnin -6083 >> Turn in Taming the Beast
    .accept 6082,2,6083 >> Accept Taming the Beast
    .target Thotar

step << Hunter
    .goto 1411/1,-4315.40,398.30
    >>Last: tame an Armored Scorpid on the flats north, then back to Thotar. Keep whichever suits you -- Orgrimmar finishes the training
    .complete -6082,1

step << Hunter
    .goto 1411/1,-4704.07,275.31
    >>Hand in Taming the Beast; take Training the Beast at Thotar
    .turnin -6082 >> Turn in Taming the Beast
    .accept 6081,2,6082 >> Accept Training the Beast
    .target Thotar

step << Hunter/Shaman
    .goto 1411/1,-4241.94,742.37
    >>HUNTER: Take Lost But Not Forgotten at Misha Tor'kren
    .accept 816 >> Accept Lost But Not Forgotten
    .target Misha Tor'kren

step << Priest
    .goto 1411/1,-4831.5,295.05
    >>PRIEST: Take Hex of Weakness at Tai'jin; train at your class trainer
    .accept 5654 >> Accept Hex of Weakness << Troll
    .trainer >> Train at your class trainer
    .target Tai'jin
    .xp <10,1

step << Hunter/Shaman
    .goto 1411/1,-4158.93,1153.04
    >>HUNTER: Take Need for a Cure at Rhinag
    .accept 812 >> Accept Need for a Cure
    .target Rhinag

step << Hunter/Shaman
    .goto 1454/1,-4125.79,1920.10
    >>HUNTER: Take Hidden Enemies at Thrall
    .accept 5726 >> Accept Hidden Enemies
    .target Thrall

step << Hunter/Shaman
    .goto 1454/1,-4343.19,1772.68
    >>HUNTER: Take Finding the Antidote at Kor'ghan
    .accept 813 >> Accept Finding the Antidote
    .target Kor'ghan
    .isOnQuest 812

step << Priest
    .goto 1411/1,-4831.5,295.05
    >>PRIEST: Take Hex of Weakness at Tai'jin; train at your class trainer
    .accept 5654 >> Accept Hex of Weakness << Troll
    .trainer >> Train at your class trainer
    .target Tai'jin

step << Warlock
    .goto 1411/1,-4837.20,352.80
    >>Warlocks: Ophek flags you down -- Gan'rul in Orgrimmar calls, and we're headed there
    .accept 1506 >> Accept Gan'rul's Summons
    .target Ophek
]])

-- =================== 10-12 DUROTAR / ORGRIMMAR =======================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 10-12 Durotar (Orc/Troll)
#next 10-12 Tirisfal (Orc/Troll)
<< Horde

step
    .goto 1411/1,-4251.99,384.23
    >>North of Razor Hill: kill 4 Razormane Dustrunners and 4 Battleguards
    .complete 837,3 --Razormane Dustrunner (4)
    .complete 837,4 --Razormane Battleguard (4)
    .mob Razormane Dustrunner
    .mob Razormane Battleguard

step << Shaman
    #completewith next
    >>SHAMAN: Objective: Kron's Amulet -- Dreadmaw Crocolisk
    .complete 816,1 --Kron's Amulet (1)
    .mob Dreadmaw Crocolisk

step
    .goto 1411/1,-4414.31,999.70
    >>Rezlak the goblin, at the rocks west
    .accept 834 >> Accept Winds in the Desert
    .target Rezlak

step
    .goto 1411/1,-4457.67,720.17
    >>Loot 5 Sacks of Supplies scattered on the flats
    .complete 834,1 --Sack of Supplies (5)

step
    .goto 1411/1,-4414.31,999.70
    >>Rezlak
    .turnin 834 >> Turn in Winds in the Desert
    .accept 835 >> Accept Securing the Lines
    .target Rezlak

step
    .goto 1411/1,-4190.12,868.22
    >>Drop into Thunder Ridge: kill Fizzle Darkstorm at the Burning Blade camp for his claw
    >>Clear the patrolling Fanatic and nearby Lightning Hides first, kill his imp before him, and pull him back into cleared ground
    .complete 806,1 --Fizzle's Claw
    .mob Fizzle Darkstorm
    .mob Burning Blade Fanatic

step
    .goto 1411/1,-4117.50,747.20
    >>OPTIONAL elite: Halikor the thunder lizard roams the ridge (two spawn spots) -- ~800 HP, manageable hits; group or skip
    .collect 275723,1,96877 --Halikor's Hoof
    .accept 96877 >> Accept Halikor's Hoof
    .mob Halikor

step
    .hs >> Hearth to Razor Hill

step
    .goto 1411/1,-4724.69,287.30
    >>Orgnil
    .turnin 806 >> Turn in Dark Storms
    .accept 828 >> Accept Margoz
    .target Orgnil Soulscar
    .goto 1411/1,-4709.36,274.96
    .turnin 837 >> Turn in Encroachment
    .target Gar'Thok

step << Warrior
    #optional
    .goto 1411/1,-4686.09,340.52
    >>Stock Haunches of Meat from Grosk -- warrior food is cheap here
    .target Innkeeper Grosk

step
    .goto 1411/1,-4945.18,1101.92
    >>Margoz camps northeast, by Skull Rock
    .turnin 828 >> Turn in Margoz
    .accept 827 >> Accept Skull Rock
    .target Margoz

step << Shaman/Hunter
    >>SHAMAN: Objective: Venomtail Poison Sac -- Venomtail Scorpid
    .complete 813,1 --Venomtail Poison Sac (4)
    .mob Venomtail Scorpid
    .itemcount 4904,<1 --Venomtail Antidote

step << Shaman/Hunter
    .goto 1411/1,-4855.82,1498.84,15,0
    >>SHAMAN: Objective: Lieutenant's Insignia -- Burning Blade Fanatic, Burning Blade Apprentice
    .goto 1411/1,-4833.08,1494.96,15,0
    .goto 1411/1,-4805.59,1495.67,15,0
    .goto 1411/1,-4784.44,1535.85,15,0
    .goto 1411/1,-4750.60,1531.62,15,0
    .goto 1411/1,-4734.21,1505.54,15,0
    .goto 1411/1,-4693.49,1519.64,15,0
    .goto 1411/1,-4679.75,1501.31,15,0
    .goto 1411/1,-4684.50,1466.06,15,0
    .complete 5726,1 --Lieutenant's Insignia (1)
    .mob Burning Blade Fanatic
    .mob Burning Blade Apprentice

step << Shaman/Hunter
    .goto 1411/1,-4701.42,1455.83
    >>SHAMAN: Take Burning Shadows by using the item that starts it; objective: Eye of Burning Shadow
    .collect 4903,1,832,1 --Collect Eye of Burning Shadow
    .accept 832 >> Accept Burning Shadows
    .use 4903
    .unitscan Gazz'uz

step << Shaman/Hunter
    #loop
    .goto 1411/1,-4805.59,1495.67,0
    >>SHAMAN: Objective: Lieutenant's Insignia -- Burning Blade Fanatic, Burning Blade Apprentice
    .goto 1411/1,-4855.82,1498.84,15,0
    .goto 1411/1,-4833.08,1494.96,15,0
    .goto 1411/1,-4805.59,1495.67,15,0
    .goto 1411/1,-4784.44,1535.85,15,0
    .goto 1411/1,-4750.60,1531.62,15,0
    .goto 1411/1,-4734.21,1505.54,15,0
    .goto 1411/1,-4693.49,1519.64,15,0
    .goto 1411/1,-4679.75,1501.31,15,0
    .goto 1411/1,-4684.50,1466.06,15,0
    .goto 1411/1,-4805.59,1495.67,15,0
    .complete 5726,1 --Lieutenant's Insignia (1)
    .mob Burning Blade Fanatic
    .mob Burning Blade Apprentice

step
    .goto 1411/1,-4749.01,822.39
    >>Inside Skull Rock: kill Burning Blade orcs for 6 Searing Collars
    .complete 827,1 --Searing Collar (6)
    .mob Burning Blade Thug
    .mob Burning Blade Neophyte
    .mob Burning Blade Cultist

step
    .goto 1411/1,-4816.69,972.91
    >>Drygulch Ravine: kill 12 Dustwind Savages and 8 Storm Witches
    >>A witch drops a Dull Storm Orb -- use it to start a quest
    .complete 835,1 --Dustwind Savage (12)
    .complete 835,2 --Dustwind Storm Witch (8)
    .use 277661
    .collect 277661,1,97281 --Dull Storm Orb
    .accept 97281 >> Accept A Simmering Storm
    .mob Dustwind Savage
    .mob Dustwind Storm Witch

step
    .goto 1411/1,-4414.31,999.70
    >>Rezlak
    .turnin 835 >> Turn in Securing the Lines
    .turnin 97281 >> Turn in A Simmering Storm
    .accept 97282 >> Accept Stormy Potential
    .target Rezlak

step << Shaman/Hunter
    #loop
    .goto 1411/1,-4010.35,1031.42,0
    >>SHAMAN: Objective: Venomtail Poison Sac -- Venomtail Scorpid
    .goto 1411/1,-4217.09,1087.47,60,0
    .goto 1411/1,-4100.24,1113.2,60,0
    .goto 1411/1,-4108.7,1229.88,60,0
    .goto 1411/1,-4013.52,1209.08,60,0
    .goto 1411/1,-4010.35,1031.42,60,0
    .complete 813,1 --Venomtail Poison Sac (4)
    .mob Venomtail Scorpid
    .itemcount 4904,<1 --Venomtail Antidote

step
    .goto 1411/1,-4047.30,918.40
    >>Thunder Ridge again: Lightning Hides drop 5 Charged Thunder Lizard Organs
    .complete 97282,1 --Charged Thunder Lizard Organ (5)
    .mob Lightning Hide

step
    .goto 1411/1,-4414.50,999.80
    >>Rezlak
    .turnin 97282 >> Turn in Stormy Potential
    .target Rezlak

step
    .goto 1411/1,-4945.18,1101.92
    >>Margoz, collars in hand
    .turnin 827 >> Turn in Skull Rock
    .accept 829 >> Accept Neeru Fireblade
    .target Margoz

step
    .goto 1454/1,-4367.46,1405.44,50,0
    .zone Orgrimmar >> North into Orgrimmar

step
    .goto 1454/1,-4355.53,1520.68
    >>Trak'gen in the Valley of Strength
    .vendor >> Vendor trash
    .target Trak'gen

step
    .goto 1454/1,-4460.60,1584.30
    >>Thatog, upstairs in the inn-side building (Forever's Orgrimmar food chain)
    .accept 97246 >> Accept Meal Appeal
    .target Thatog

step
    .goto 1454/1,-4482.60,1775.00
    >>Borstan at the meat stall in the Drag
    .turnin 97246 >> Turn in Meal Appeal
    .accept 97249 >> Accept Favorite Food
    .target Borstan

step
    #optional
    .isOnQuest 96877
    .goto 1454/1,-4568.10,1855.20
    >>Kamari takes Halikor's hoof
    .turnin 96877 >> Turn in Halikor's Hoof
    .target Kamari

step << Hunter
    .goto 1454/1,-4607.30,2100.60
    >>Ormak Grimshot in the Hunter Hall: pet training proper -- learn Tame Beast, Feed Pet, and the rest
    .turnin -6081 >> Turn in Training the Beast
    .trainer >> Train your hunter and pet skills
    .target Ormak Grimshot

step
    .goto 1454/1,-4466.80,1954.80
    >>Kor'geld in the Valley of Honor
    .accept 97242 >> Accept Yelmak's Medley
    .target Kor'geld

step
    .goto 1454/1,-4630.60,1968.10
    >>Fish the pond edge: 2 Handfuls of Cattails and 4 Speargrass Cuttings grow in the water
    .complete 97242,1 --Handful of Cattails (2)
    .complete 97242,2 --Speargrass Cuttings (4)

step
    .goto 1454/1,-4466.90,1954.50
    >>Kor'geld
    .turnin 97242 >> Turn in Yelmak's Medley
    .target Kor'geld

step
    .goto 1454/1,-4477.90,1964.80
    >>Yelmak beside him (give him a few seconds to offer it)
    .accept 97275 >> Accept Whuut's the Rush
    .target Yelmak

step
    .goto 1454/1,-4463.00,1966.20
    >>Whuut, a few steps away
    .turnin 97275 >> Turn in Whuut's the Rush
    .target Whuut

step
    .goto 1454/1,-4193.40,2001.80
    >>Migi up in the Valley of Wisdom
    .turnin 97249 >> Turn in Favorite Food
    .target Migi

step << Shaman
    .goto 1454/1,-4212.90,1920.90
    >>Searn Firewarder by the pools: his fire errand banks until the Barrens
    .accept 1522 >> Accept Call of Fire
    .target Searn Firewarder

step
    .goto 1454/1,-4205.80,2007.80
    >>Thra next to him
    .accept 97326 >> Accept Rocks to Rests
    .target Thra

step
    .goto 1454/1,-4293.60,1949.90
    >>Gather 8 orange Smooth Boulders from the slope
    .complete 97326,1 --Smooth Boulder (8)

step
    .goto 1454/1,-4205.90,2007.80
    >>Thra
    .turnin 97326 >> Turn in Rocks to Rests
    .target Thra

step
    .goto 1454/1,-4133.36,1939.00
    >>Nazgrel in Thrall's hold
    .turnin 831 >> Turn in The Admiral's Orders
    .target Nazgrel

step << Shaman/Hunter
    .goto 1454/1,-4125.79,1920.10
    >>SHAMAN: Hand in Hidden Enemies; take Hidden Enemies at Thrall
    .turnin 5726 >> Turn in Hidden Enemies
    .target Thrall
    .isQuestComplete 5726
    .dungeon RFC

step << Shaman/Hunter
    .goto 1454/1,-4125.79,1920.10
    >>SHAMAN: Hand in Hidden Enemies at Thrall
    .turnin 5726 >> Turn in Hidden Enemies
    .target Thrall
    .isQuestComplete 5726
    .dungeon !RFC

step << Orc Rogue
    .goto 1454/1,-4280.21,1773.15
    >>ROGUE: Take The Shattered Hand at Therzok
    .accept 1963 >> Accept The Shattered Hand
    .target Therzok

step << Shaman/Hunter
    .goto 1454/1,-4343.19,1772.68
    >>SHAMAN: Hand in Finding the Antidote at Kor'ghan
    .turnin 813 >> Turn in Finding the Antidote
    .target Kor'ghan
    .itemcount 4904,<1 --Venomtail Antidote

step
    .goto 1454/1,-4320.70,1750.30
    >>Repair with Kareth in the Drag
    .vendor >> Repair and vendor
    .target Kareth

step
    .goto 1454/1,-4374.75,1800.93
    >>Neeru Fireblade in the Cleft of Shadow -- play along
    >>His follow-up turns in at the Crossroads; it rides along to the Barrens
    .turnin 829 >> Turn in Neeru Fireblade
    .accept 809 >> Accept Ak'Zeloth
    .target Neeru Fireblade

step << Shaman/Hunter
    .goto 1454/1,-4374.75,1800.93
    >>SHAMAN: Hand in Burning Shadows at Neeru Fireblade
    .turnin 832 >> Turn in Burning Shadows
    .target Neeru Fireblade
    .isQuestTurnedIn 827
    .isOnQuest 832

step << Shaman/Hunter
    >>SHAMAN: Travel to Durotar
    .zone Durotar
    .zoneskip Durotar

step << Shaman/Hunter
    .goto 1411/1,-4158.93,1153.04
    >>SHAMAN: Take and hand in Need for a Cure at Rhinag
    .accept 812 >> Accept Need for a Cure
    .turnin 812 >> Turn in Need for a Cure
    .target Rhinag

step << Shaman/Hunter
    .goto 1411/1,-3802.55,650.72,50,0
    >>SHAMAN: Objective: Kron's Amulet -- Dreadmaw Crocolisk
    .goto 1411/1,-3803.08,503.38,50,0
    .goto 1411/1,-3783.51,238.65,50,0
    .goto 1411/1,-3774.53,150.88,50,0
    .goto 1411/1,-3797.79,317.260
    .complete 816,1 --Kron's Amulet (1)
    .mob Dreadmaw Crocolisk

step << Shaman/Hunter
    .goto 1411/1,-4241.94,742.37
    >>SHAMAN: Hand in Lost But Not Forgotten at Misha Tor'kren
    .turnin 816 >> Turn in Lost But Not Forgotten
    .target Misha Tor'kren
    .isQuestComplete 816

step << Priest
    #optional
    .goto Orgrimmar,35.59,87.82
    >>PRIEST (trolls): Ur'kyo in the Valley of Spirits teaches Hex of Weakness now that you're 10 -- your trainer's note lands with him
    .turnin -5652 >> Turn in Hex of Weakness
    .turnin -5654 >> Turn in Hex of Weakness
    .turnin -5655 >> Turn in Hex of Weakness
    .turnin -5656 >> Turn in Hex of Weakness
    .turnin -5657 >> Turn in Hex of Weakness
    .target Ur'kyo

step << Warlock
    .goto 1454/1,-4357.40,1850.30
    >>Deeper in the Cleft: Gan'rul Bloodeye sets your first real test
    .turnin 1506 >> Turn in Gan'rul's Summons
    .accept 1501,2,1501 >> Accept Creature of the Void
    .target Gan'rul Bloodeye

step << Warlock
    .isOnQuest 1501
    .goto 1411/1,-4691.80,1464.30
    >>Out to Skull Rock, northeast of the city: the Burning Blade Stash inside the cave holds the Tablet of Verga (mobs run 9-11, pull with care)
    .collect 6535,1,1501 --Tablet of Verga
    .mob Burning Blade Cultist

step << Warlock
    .goto 1454/1,-4357.40,1850.30
    >>Back to Gan'rul: hand over the tablet, then summon and subdue the VOIDWALKER with his glyphs
    .turnin -1501 >> Turn in Creature of the Void
    .target Gan'rul Bloodeye

step << Warlock
    .goto 1454/1,-4357.40,1850.30
    >>Take The Binding at Gan'rul Bloodeye
    .accept 1504,2,1501 >> Accept The Binding
    .target Gan'rul Bloodeye

step << Warlock
    .goto 1454/1,-4357.40,1850.30
    >>Finish The Binding, then hand in The Binding at Gan'rul Bloodeye
    .complete -1504,1
    .turnin -1504 >> Turn in The Binding
    .target Gan'rul Bloodeye

step
    .goto 1411/1,-4648.55,1321.88,40
    >>Leave Orgrimmar and climb the zeppelin tower
    .zone Tirisfal Glades >> Take the zeppelin to Tirisfal Glades
]])

-- =================== 10-12 TIRISFAL (ORC/TROLL) ======================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 10-12 Tirisfal (Orc/Troll)
#next 12-14 Silverpine Forest (Horde)
<< Horde

step
    .goto 1420/0,254.60,2225.80
    >>Off the zeppelin, into Brill: Deathguard Terrence on the road
    .accept 96895 >> Accept The Argent Emissary
    .target Deathguard Terrence

step << Warrior
    .goto 1420/0,238.49,2254.43
    >>Austil de Mon, the warrior trainer: his chain ends in Defensive Stance
    .accept 1818 >> Accept Speak with Dillinger
    .target Austil de Mon

step << Warlock
    .goto 1420/0,248.88,2251.12
    >>WARLOCK: Take Halgar's Summons at Ageron Kargal
    .accept 1478 >> Accept Halgar's Summons
    .target Ageron Kargal
    .isQuestAvailable 1504

step << Undead Rogue
    .goto 1420/0,243.01,2270.70
    >>ROGUE: Take Mennet Carkad at Marion Call
    .accept 1885 >> Accept Mennet Carkad
    .target Marion Call

step << Warrior
    .goto 1420/0,403.87,2287.87
    >>Deathguard Dillinger east of town
    .turnin 1818 >> Turn in Speak with Dillinger
    .accept 1819 >> Accept Ulag the Cleaver
    .target Deathguard Dillinger

step << Warrior
    .goto 1420/0,360.04,2376.14
    >>Pull the Mausoleum Trigger in the graveyard crypt -- Ulag rises; put him back down
    .complete 1819,1 --Ulag the Cleaver
    .mob Ulag the Cleaver

step << Warrior
    .goto 1420/0,403.87,2287.87
    >>Dillinger
    .turnin 1819 >> Turn in Ulag the Cleaver
    .accept 1820 >> Accept Speak with Coleman
    .target Deathguard Dillinger

step
    .goto 1420/0,346.94,2258.95
    >>Apothecary Johaan in Brill (his delivery rides along to Silverpine)
    .accept 445 >> Accept Delivery to Silverpine Forest
    .target Apothecary Johaan

step << Warrior
    .goto 1420/0,244.36,2262.26
    >>Coleman Farthing upstairs in the inn -- stance unlocked
    .turnin 1820 >> Turn in Speak with Coleman
    .target Coleman Farthing

step
    #optional
    .goto 1420/0,244.81,2269.19
    >>Innkeeper Renee: cheap food, and vendor space
    .vendor >> Vendor trash and restock food
    .target Innkeeper Renee

step
    .goto 1420/0,74.00,2022.47
    >>West along the road: Deathguard Linnea
    .accept 356 >> Accept Rear Guard Patrol
    .target Deathguard Linnea

step
    .goto 1420/0,54.60,1996.60
    >>Hadric Harlson at the Argent camp
    .turnin 96895 >> Turn in The Argent Emissary
    .accept 96897 >> Accept The Cult of the Damned
    .accept 96898 >> Accept Remnants of War
    .target Hadric Harlson

step
    .goto 1420/0,-130.50,1907.80
    >>The cultist dig south: kill 8 Dark Enforcers and 8 Dark Neophytes, gathering 12 Necrotic Crystal Fragments (mobs and ground)
    >>These hit hard for their level -- Enforcers have an instant 50-70 damage strike. Pull singles
    .complete 96897,2 --Dark Enforcer (8)
    .complete 96897,1 --Dark Neophyte (8)
    .complete 96898,1 --Necrotic Crystal Fragment (12)
    .mob Dark Enforcer
    .mob Dark Neophyte

step
    .goto 1420/0,-355.28,1970.35
    >>West to the beach: kill 8 Bleeding Horrors and 8 Wandering Spirits
    .complete 356,1 --Bleeding Horror (8)
    .complete 356,2 --Wandering Spirit (8)
    .mob Bleeding Horror
    .mob Wandering Spirit

step
    .goto 1420/0,54.50,1996.40
    >>Hadric
    .turnin 96897 >> Turn in The Cult of the Damned
    .turnin 96898 >> Turn in Remnants of War
    .target Hadric Harlson

step
    .goto 1420/0,74.00,2022.47
    >>Linnea
    .turnin 356 >> Turn in Rear Guard Patrol
    .target Deathguard Linnea

step << Undead Rogue
    .goto 1458/0,71.92,1435.70
    >>ROGUE: Hand in Mennet Carkad; take The Deathstalkers at Mennet Carkad
    .turnin 1885 >> Turn in Mennet Carkad
    .accept 1886 >> Accept The Deathstalkers
    .target Mennet Carkad
    .isOnQuest 1885

step << Warlock
    .goto 1458/0,57.05,1711.77
    >>WARLOCK: Hand in Halgar's Summons; take Creature of the Void at Carendin Halgar
    .turnin 1478 >> Turn in Halgar's Summons
    .accept 1473 >> Accept Creature of the Void
    .isQuestAvailable 1504

step << Warlock
    .goto 1458/0,419.89,1627.54,50,0
    >>WARLOCK: Travel to Tirisfal Glades
    .goto 1458/0,428.52,1597.20,10,0
    .goto 1458/0,439.17,1626.06,10,0
    .goto 1458/0,476.78,1632.150,10,0
    .goto 1458/0,482.34,1660.63,10,0
    .goto 1458/0,539.33,1665.49,15,0
    .goto 1458/0,610.42,1684.44,35,0
    .goto 1458/0,663.19,1600.46,35,0
    .goto 1420/0,724.25,1682.66,50,0
    .zone Tirisfal Glades
    .zoneskip Tirisfal Glades

step << Warlock
    #optional
    #completewith next
    .goto 1420/0,726.06,1801.95
    >>WARLOCK: Objective: Egalin's Grimoire
    .complete 1473,1 --Egalin's Grimoire (1)
    .isQuestAvailable 1504

step << Warlock
    .goto 1420/0,726.06,1801.95
    >>WARLOCK: Objective: Egalin's Grimoire
    .complete 1473,1 --Egalin's Grimoire (1)
    .isQuestAvailable 1504

step << Warlock
    #completewith next
    .goto 1458/0,714.8,1604.24,35,0
    >>WARLOCK: Travel to Undercity
    .goto 1458/0,652.73,1623.44,35,0
    .goto 1458/0,634.02,1669.66,35,0
    .goto 1458/0,539.52,1665.17,10,0
    .goto 1458/0,481.48,1659.8,10,0
    .goto 1458/0,476.49,1632.15,10,0
    .goto 1458/0,439.08,1627.02,10,0
    .goto 1458/0,435.05,1598.86,10,0
    .zone Undercity

step << Warlock
    .goto 1458/0,57.05,1711.77
    >>WARLOCK: Hand in Creature of the Void; take The Binding at Carendin Halgar
    .turnin 1473 >> Turn in Creature of the Void
    .accept 1471 >> Accept The Binding
    .target Carendin Halgar
    .isQuestAvailable 1504

step << Warlock
    #completewith next
    .goto 1458/0,41.99,1704.480
    >>WARLOCK: Use the quest item
    .cast 9221
    .use 6284

step << Warlock
    .goto 1458/0,41.99,1704.480
    >>WARLOCK: Objective: Kill Summoned Voidwalker -- Summoned Voidwalker
    .complete 1471,1 --Kill Summoned Voidwalker (1)
    .mob Summoned Voidwalker
    .use 6284
    .isQuestAvailable 1504

step << Warlock
    .goto 1458/0,57.34,1711.71
    >>WARLOCK: Hand in The Binding at Carendin Halgar
    .turnin 1471 >> Turn in The Binding
    .target Carendin Halgar
    .isQuestAvailable 1504

step
    .goto 1420/0,240.75,1877.57,20,0
    .zone Undercity >> South into the Undercity

step
    .goto 1458/0,266.39,1567.11
    >>Take the lift down: Michael Garrett in the trade quarter ring
    .fp Undercity >> Get the Undercity flight path
    .target Michael Garrett

step
    #optional
    .goto 1458/0,224.30,1648.20
    >>AH stop: 3x Murloc Eye pre-fills a Silverpine quest
    .collect 730,3,91920,1 --Murloc Eye (3)

step << Warrior
    .goto 1458/0,418.35,1767.02
    >>Baltus Fowler in the war quarter: level 12 means Overpower
    .train 7384 >> Train Overpower
    .target Baltus Fowler

step
    .goto 1420/0,724.25,1682.66,50,0
    .zone Tirisfal Glades >> Out through the sewers

step
    .goto 1420/0,629.36,1553.42
    .zone Silverpine Forest >> South into Silverpine Forest

step
    +Starter complete -- you're ~12 entering Silverpine. The Silverpine Forest 12-14 chapter loads next automatically. Riding in your log for it: Delivery to Silverpine Forest, and Ak'Zeloth for your first Barrens trip
]])
