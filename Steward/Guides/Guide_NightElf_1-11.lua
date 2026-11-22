-- =====================================================================
--  Custom WoW: Forever guide -- Night Elf start, 1-11 (Warrior-optimized)
--  Chunks: 1-6 Shadowglen > 6-11 Teldrassil, flying to Auberdine and
--  chaining into "14-16 Darkshore (Warrior)" (Darkshore scales from 11).
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Horde" then return end

-- ====================== 1-6 SHADOWGLEN ===============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 1-6 Shadowglen (Night Elf)
#next 6-11 Teldrassil (Night Elf)
<< Alliance

step
    #completewith next
    +Night Elf starter, warrior-optimized. If you didn't start in Shadowglen, walk here first

step
    .goto 1438/1,826.03,10328.97
    >>Talk to Conservator Ilthalaine
    .accept 456 >> Accept The Balance of Nature
    .target Conservator Ilthalaine

step
    #sticky
    #label Balance1
    .goto 1438/1,657.75,10385.51
    >>Kill 7 Young Nightsabers and 4 Young Thistle Boars
    >>Loot everything -- you want ~10 copper of trash for Battle Shout << Warrior
    .complete 456,1 --Young Nightsaber (7)
    .complete 456,2 --Young Thistle Boar (4)
    .mob Young Nightsaber
    .mob Young Thistle Boar

step
    .goto 1438/1,713.81,10407.20
    >>Dirania Silvershine by the pond, then Melithar Staghelm at the camp
    .accept 4495 >> Accept A Good Friend
    .target Dirania Silvershine

step
    .goto 1438/1,763.45,10389.79
    >>Take The Woodland Protector at Melithar Staghelm
    .accept 458 >> Accept The Woodland Protector
    .target Melithar Staghelm

step << Warrior
    .goto 1438/1,794.92,10436.72
    >>Sell your trash to Keina
    .vendor >> Vendor trash
    .target Keina

step << Warrior
    .goto 1438/1,778.07,10526.62
    >>Train with Alyissia at the tree base
    .train 6673 >> Train Battle Shout
    .target Alyissia

step
    .goto 1438/1,1034.89,10711.58
    >>Iverron hides near the cave in the northeast
    .turnin 4495 >> Turn in A Good Friend
    .accept 3519 >> Accept A Friend in Need
    .target Iverron

step
    .goto 1438/1,866.51,10300.67
    >>The dryad Tarindrella, back near the start
    .turnin 458 >> Turn in The Woodland Protector
    .accept 459 >> Accept The Woodland Protector
    .accept 97977 >> Accept Nature's Call
    .target Tarindrella

step
    #optional
    .isOnQuest 456
    .goto 1438/1,679.14,10331.55
    >>Still short on Young Nightsaber? Young Nightsaber -- around here. This step skips itself once you have them
    .complete 456,1 --Young Nightsaber (7)
    .mob Young Nightsaber

step
    #optional
    .isOnQuest 456
    .goto 1438/1,873.13,10391.62
    >>Still short on Young Thistle Boar? Young Thistle Boar -- around here. This step skips itself once you have them
    .complete 456,2 --Young Thistle Boar (4)
    .mob Young Thistle Boar

step
    #requires Balance1
    .goto 1438/1,826.03,10328.97
    >>Ilthalaine
    .turnin 456 >> Turn in The Balance of Nature
    .accept 457 >> Accept The Balance of Nature
    .accept 3116 >> Accept Simple Sigil << Warrior
    .target Conservator Ilthalaine

step << Druid
    .goto 1438/1,826.03,10328.97
    >>DRUID: Take Verdant Sigil at Conservator Ilthalaine
    .accept 3120 >> Accept Verdant Sigil

step << Hunter
    .goto 1438/1,826.03,10328.97
    >>HUNTER: Take Etched Sigil at Conservator Ilthalaine
    .accept 3117 >> Accept Etched Sigil

step << Priest
    .goto 1438/1,826.03,10328.97
    >>PRIEST: Take Hallowed Sigil at Conservator Ilthalaine
    .accept 3119 >> Accept Hallowed Sigil

step
    .goto 1438/1,713.81,10407.20
    >>Dirania
    .turnin 3519 >> Turn in A Friend in Need
    .accept 3521 >> Accept Iverron's Antidote
    .target Dirania Silvershine

step << Warrior
    .goto 1438/1,778.07,10526.62
    >>Deliver the sigil to Alyissia and train (Charge at 4)
    .turnin 3116 >> Turn in Simple Sigil
    .trainer >> Train your class abilities
    .target Alyissia

step
    .goto 1438/1,871.24,10417.65
    >>Gilshalan Windwalker up in Aldrassil
    .accept 916 >> Accept Webwood Venom
    .target Gilshalan Windwalker

step << Druid
    .goto 1438/1,871.6,10440.83,25,0
    >>DRUID: Hand in Verdant Sigil at Mardant Strongoak; train at your class trainer
    .goto 1438/1,829.54,10464.01
    .target Mardant Strongoak
    .turnin 3120 >> Turn in Verdant Sigil
    .train 8921

step << Hunter
    .goto 1438/1,871.6,10440.83,25,0
    >>HUNTER: Hand in Etched Sigil at Ayanna Everstride; train at your class trainer
    .goto 1438/1,827.86,10458.51
    .turnin 3117 >> Turn in Etched Sigil
    .train 1978
    .target Ayanna Everstride

step
    .goto 1438/1,863.96,10534.84
    >>Pick 4 Moonpetal Lilies around the pond
    .complete 3521,2 --Moonpetal Lily (4)

step
    .goto 1438/1,922.52,10755.43
    >>Webwood Spiders north: 10 Venom Sacs and 1 Webwood Ichor
    .complete 916,1 --Webwood Venom Sac (10)
    .complete 3521,3 --Webwood Ichor (1)
    .mob Webwood Spider

step
    #sticky
    #completewith Boars457
    >>Kill Thistle Boars whenever they're near -- 7 count for Balance of Nature
    .complete 457,2 --Thistle Boar (7)
    .mob Thistle Boar

step
    .goto 1438/1,1014.17,10348.18
    >>Grells and Grellkin at the camps east: 7 Hyacinth Mushrooms, 8 Fel Moss, and 4 Gnarlpine Totems from the camps
    .complete 3521,1 --Hyacinth Mushroom (7)
    .complete 459,1 --Fel Moss (8)
    .complete 97977,1 --Gnarlpine Totem (4)
    .mob Grell
    .mob Grellkin

step
    .goto 1438/1,871.60,10300.67
    >>Tarindrella
    .turnin 459 >> Turn in The Woodland Protector
    .turnin 97977 >> Turn in Nature's Call
    .target Tarindrella

step
    .goto 1438/1,713.81,10407.20
    >>Dirania
    .turnin 3521 >> Turn in Iverron's Antidote
    .accept 3522 >> Accept Iverron's Antidote
    .target Dirania Silvershine

step
    .goto 1438/1,871.24,10417.65
    >>Gilshalan
    .turnin 916 >> Turn in Webwood Venom
    .accept 917 >> Accept Webwood Egg
    .target Gilshalan Windwalker

step
    .goto 1438/1,1034.89,10711.58
    >>Bring Iverron his antidote
    .turnin 3522 >> Turn in Iverron's Antidote
    .target Iverron

step
    .goto 1438/1,912.33,10935.30
    >>Into the Shadowthread Cave: kill Githyiss the Vile for her Fang, and loot a Webwood Egg at the back
    .collect 277190,1 --Fang of Githyiss
    .complete 917,1 --Webwood Egg
    .mob Githyiss the Vile

step
    .goto 1438/1,871.24,10417.65
    >>Back out to Gilshalan: use the Fang from your bags for a bonus quest, then turn everything in
    .use 277190
    .accept 97236 >> Accept Fang of Githyiss
    .turnin 97236 >> Turn in Fang of Githyiss
    .turnin 917 >> Turn in Webwood Egg
    .accept 920 >> Accept Tenaron's Summons
    .target Gilshalan Windwalker

step
    .goto 1438/1,807.34,10492.48
    >>Climb Aldrassil to the top: Tenaron Stormgrip
    .turnin 920 >> Turn in Tenaron's Summons
    .accept 921 >> Accept Crown of the Earth
    .target Tenaron Stormgrip

step
    #label Boars457
    .goto 1438/1,769.77,10673.98
    >>Finish Balance of Nature: 7 Mangy Nightsabers and 7 Thistle Boars south of the pond
    .complete 457,1 --Mangy Nightsaber (7)
    .complete 457,2 --Thistle Boar (7)
    .mob Mangy Nightsaber
    .mob Thistle Boar

step
    .goto 1438/1,764.68,10711.31
    >>Fill the Crystal Phial at the moonwell
    .use 5185
    .complete 921,1 --Filled Crystal Phial

step
    .goto 1438/1,807.34,10492.48
    >>Tenaron atop the tree
    .turnin 921 >> Turn in Crown of the Earth
    .accept 928 >> Accept Crown of the Earth
    .target Tenaron Stormgrip

step
    .goto 1438/1,805.50,10491.80
    >>Click the scroll beside him
    .accept 96630 >> Accept The Adventurer

step << Priest
    .goto 1438/1,801.64,10458.75
    >>PRIEST: Hand in Hallowed Sigil; take The Goddess Provides at Shanda; train at your class trainer
    .target Shanda
    .turnin 3119 >> Turn in Hallowed Sigil
    .accept 97979 >> Accept The Goddess Provides
    .trainer >> Train at your class trainer

step << Priest
    >>PRIEST: Objective: The Goddess Provides (objective 1); The Goddess Provides (objective 2)
    .complete 97979,1
    .complete 97979,2

step << Priest
    .goto 1438/1,800.500,10454.900
    >>PRIEST: Hand in The Goddess Provides at Shanda
    .target Shanda::3595
    .turnin 97979 >> Turn in The Goddess Provides

step
    .goto 1438/1,826.03,10328.97
    >>Ilthalaine
    .turnin 457,2 >> Turn in The Balance of Nature
    .target Conservator Ilthalaine

step
    .goto 1438/1,700.57,10214.33
    >>Porthannius at the Shadowglen exit
    .accept 2159 >> Accept Dolanaar Delivery
    .target Porthannius
]])

-- ====================== 6-11 TELDRASSIL ==============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 6-11 Teldrassil (Night Elf)
#next 14-16 Darkshore (Alliance)
<< Alliance

step
    .goto 1438/1,734.13,9920.57
    >>On the road south: the satyr Zenn Foulhoof
    .accept 488 >> Accept Zenn's Bidding
    .target Zenn Foulhoof

step
    #sticky
    #label ZennKills
    >>All over Teldrassil: Nightsabers (3 Fangs + 6 Soft Pelts), Strigid Owls (3 Feathers -- they dive fast and bring friends), Webwood Lurkers (3 Silk), and keep 7 Small Spider Legs from Lurkers/Venomfangs for a cooking quest
    .complete 488,1 --Nightsaber Fang (3)
    .complete 488,2 --Strigid Owl Feather (3)
    .complete 488,3 --Webwood Spider Silk (3)
    .complete 87288,1 --Soft Nightsaber Pelt (6)
    .collect 5465,7,4161,1 --Small Spider Leg (7)
    .mob Nightsaber
    .mob Strigid Owl
    .mob Webwood Lurker

step
    .goto 1438/1,879.70,9907.60
    >>Lyreena Duskblade at the roadside camp
    .turnin 96630 >> Turn in The Adventurer
    .accept 96606 >> Accept The Great Outdoors
    .target Lyreena Duskblade

step
    .goto 1438/1,882.30,9909.10
    >>Type /sit at her campfire and stay seated a minute for the boosted rest buff
    .complete 96606,1 --Sit at the campfire
    .complete 96606,2 --Gain the boosted rest buff

step
    .goto 1438/1,879.70,9907.60
    >>Lyreena again
    .turnin 96606 >> Turn in The Great Outdoors
    .accept 96634 >> Accept Camping 101: Cooking
    .target Lyreena Duskblade

step
    .goto 1438/1,959.18,9872.38
    >>Dolanaar: Syral Bladeleaf (keep one bag slot free for her quest)
    .accept 997 >> Accept Denalan's Earth
    .target Syral Bladeleaf

step
    .goto 1438/1,965.59,9887.58
    >>Athridas Bearmantle
    .accept 475 >> Accept A Troubling Breeze
    .target Athridas Bearmantle

step
    .goto 1438/1,988.30,9891.89
    >>Aldia, upstairs
    .accept 87288 >> Accept Soft Saber Pelts
    .target Aldia

step
    .goto 1438/1,984.94,9898.58
    >>Tallonkai Swiftroot atop the tree
    .accept 932 >> Accept Twisted Hatred
    .accept 2438 >> Accept The Emerald Dreamcatcher
    .target Tallonkai Swiftroot

step
    .goto 1438/1,963.00,9811.60
    >>Sentinel Kyra Starsong
    .accept 99046 >> Accept The Lost Runner
    .target Sentinel Kyra Starsong

step << Warrior
    #optional
    .goto 1438/1,947.57,9812.38
    >>Shalomon sells the Gladius (~5s 36c) -- big early upgrade
    .collect 2488,1 --Gladius
    .disablecheckbox
    .target Shalomon
    .money <0.0536
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8

step << Warrior
    .goto 1438/1,952.00,9822.22
    >>Train with Kyra Windblade
    .trainer >> Train your class abilities
    .target Kyra Windblade

step
    .goto 1438/1,982.65,9802.19
    >>Innkeeper Keldamyr: deliver the shipment and set your hearth
    .turnin 2159 >> Turn in Dolanaar Delivery
    .home >> Set your Hearthstone to Dolanaar
    .target Innkeeper Keldamyr

step << Priest
    #optional
    .goto 1438/1,801.64,10458.75
    >>PRIEST: missed Shanda in Aldrassil? She starts In Favor of Elune on the tree's lower spiral
    .accept 5622 >> Accept In Favor of Elune

step << Priest
    .goto Teldrassil,55.56,56.75
    >>Laurna Morninglight here in Dolanaar continues it
    .turnin -5622 >> Turn in In Favor of Elune
    .target Laurna Morninglight

step << Priest
    .goto Teldrassil,55.56,56.75
    >>Take Garments of the Moon at Laurna Morninglight
    .accept 5621,2,5622 >> Accept Garments of the Moon
    .target Laurna Morninglight

step << Priest
    .isOnQuest 5621
    .goto Teldrassil,57.24,63.51
    >>Sentinel Shaya south of the village: Lesser Heal (Rank 2), then Power Word: Fortitude on her
    .complete -5621,1
    .target Sentinel Shaya

step << Priest
    .isQuestComplete 5621
    .goto Teldrassil,55.56,56.75
    >>Laurna's vestments -- and file this: Priestess Alathea in Darnassus' Temple of the Moon teaches Stars of Elune at 10 and Elune's Grace at 20, whenever you pass
    .turnin -5621 >> Turn in Garments of the Moon
    .target Laurna Morninglight

step
    .goto 1438/1,956.02,9736.83
    >>Corithras Moonrage by the moonwell
    .turnin 928 >> Turn in Crown of the Earth
    .accept 929 >> Accept Crown of the Earth
    .target Corithras Moonrage

step
    .goto 1438/1,906.17,9751.02
    >>Zarrin: train Cooking and take his recipe quest (7 Small Spider Legs)
    .train 2550 >> Train Cooking
    .turnin 96634 >> Turn in Camping 101: Cooking
    .accept 4161 >> Accept Recipe of the Kaldorei
    .target Zarrin

step
    #optional
    .goto 1438/1,902.15,9754.27
    >>Nyoma sells Mild Spices -- cook Herb Baked Eggs with any Small Eggs you loot; eating them gives a 15-minute kill-XP buff worth keeping up
    .collect 2678,5 --Mild Spices
    .disablecheckbox
    .target Nyoma

step
    .goto 1438/1,713.76,9506.90
    >>Denalan at Lake Al'Ameth
    .turnin 997 >> Turn in Denalan's Earth
    .accept 918 >> Accept Timberling Seeds
    .accept 919 >> Accept Timberling Sprouts
    .target Denalan

step
    .goto 1438/1,697.97,9581.87
    >>Timberlings around the lake: 8 Seeds from kills, 12 Sprouts off the ground
    .complete 918,1 --Timberling Seed (8)
    .complete 919,1 --Timberling Sprout (12)
    .mob Timberling

step
    .goto 1438/1,713.76,9506.90
    >>Denalan
    .turnin 918 >> Turn in Timberling Seeds
    .turnin 919 >> Turn in Timberling Sprouts
    .accept 922 >> Accept Rellian Greenspyre
    .target Denalan

step
    .goto 1438/1,351.23,9806.54
    >>West to Starbreeze Village: open Fallon's Dresser in the far house for the Emerald Dreamcatcher (furbolgs everywhere -- pull carefully)
    .complete 2438,1 --Emerald Dreamcatcher

step
    .goto 1438/1,440.85,9845.23
    >>Gaerolas Talvethren, upstairs in the village
    .turnin 475 >> Turn in A Troubling Breeze
    .accept 476 >> Accept Gnarlpine Corruption
    .target Gaerolas Talvethren

step
    .goto 1438/1,587.49,9859.48
    >>Fill the Jade Phial at the Starbreeze moonwell
    .complete 929,1 --Filled Jade Phial

step
    #optional
    .isOnQuest 488
    .goto 1438/1,1185.25,9787.19
    >>Still short on Nightsaber Fang, Strigid Owl Feather? Nightsaber / Strigid Owl -- around here. This step skips itself once you have them
    .complete 488,1 --Nightsaber Fang (3)
    .complete 488,2 --Strigid Owl Feather (3)
    .mob Nightsaber
    .mob Strigid Owl

step
    #optional
    .isOnQuest 488
    .goto 1438/1,720.38,9892.40
    >>Still short on Webwood Spider Silk? Webwood Lurker -- around here. This step skips itself once you have them
    .complete 488,3 --Webwood Spider Silk (3)
    .mob Webwood Lurker

step
    #optional
    .isOnQuest 87288
    .goto 1438/1,1185.25,9787.19
    >>Still short on Soft Nightsaber Pelt? Nightsaber -- around here. This step skips itself once you have them
    .complete 87288,1 --Soft Nightsaber Pelt (6)
    .mob Nightsaber

step
    #optional
    .isOnQuest 4161
    .goto 1438/1,720.38,9892.40
    >>Still short on Small Spider Leg? Webwood Lurker -- around here. This step skips itself once you have them
    .collect 5465,7,4161,1 --Small Spider Leg (7)
    .mob Webwood Lurker

step
    #requires ZennKills
    .goto 1438/1,734.13,9920.57
    >>Zenn takes his trophies (the "reward" is the joke)
    .turnin 488 >> Turn in Zenn's Bidding
    .target Zenn Foulhoof

step
    .goto 1438/1,959.28,9872.28
    >>Syral has the payback quest
    .accept 489 >> Accept Seek Redemption!
    .target Syral Bladeleaf

step
    .goto 1438/1,809.80,9926.40
    >>Loot 3 Fel Cones from the ground near the big tree by Zenn (skip if others got them first -- they respawn)
    .complete 489,1 --Fel Cone (3)

step
    .goto 1438/1,739.22,9917.17
    >>Zenn, now a frog
    .turnin 489 >> Turn in Seek Redemption!
    .target Zenn Foulhoof

step
    .goto 1438/1,965.59,9887.58
    >>Dolanaar: Athridas
    .turnin 476 >> Turn in Gnarlpine Corruption
    .target Athridas Bearmantle

step
    #optional
    .isQuestComplete 87288
    .goto 1438/1,988.30,9891.89
    >>Aldia, if the pelts are done
    .turnin 87288 >> Turn in Soft Saber Pelts
    .target Aldia

step
    .goto 1438/1,984.94,9898.58
    >>Tallonkai
    .turnin 2438 >> Turn in The Emerald Dreamcatcher
    .accept 2459 >> Accept Ferocitas the Dream Eater
    .target Tallonkai Swiftroot

step << Warrior
    .goto 1438/1,999.40,9902.92
    >>Byancie next door trains First Aid -- bandages are warrior sustain
    .train 3273 >> Train First Aid
    .target Byancie

step
    .goto 1438/1,1207.65,10114.01
    >>Fel Rock cave north: hunt down Lord Melenas (several spawn spots inside) for his head
    .complete 932,1 --Melenas' Head
    .unitscan Lord Melenas

step
    .goto 1438/1,282.49,10018.65
    >>Gnarlpine camp west: kill 7 Gnarlpine Mystics, and Ferocitas the Dream Eater -- use the necklace he drops to pry out Tallonkai's Jewel
    .complete 2459,1 --Gnarlpine Mystic (7)
    .use 8049
    .complete 2459,2 --Tallonkai's Jewel
    .mob Ferocitas the Dream Eater
    .mob Gnarlpine Mystic

step
    .goto 1438/1,984.94,9898.58
    >>Dolanaar: Tallonkai
    .turnin 932 >> Turn in Twisted Hatred
    .turnin 2459 >> Turn in Ferocitas the Dream Eater
    .target Tallonkai Swiftroot

step
    .goto 1438/1,956.02,9736.83
    >>Corithras
    .turnin 929 >> Turn in Crown of the Earth
    .accept 933 >> Accept Crown of the Earth
    .target Corithras Moonrage

step
    .goto 1438/1,971.91,9852.35
    >>Moon Priestess Amara patrols the road west of Dolanaar -- catch her (she sometimes stops to fight furbolg ambushes)
    .accept 487 >> Accept The Road to Darnassus
    .target Moon Priestess Amara

step
    .goto 1438/1,1441.87,10032.56
    >>Kill 6 Gnarlpine Ambushers along the western road
    .complete 487,1 --Gnarlpine Ambusher (6)
    .mob Gnarlpine Ambusher

step
    .goto 1438/1,1655.21,9555.06
    >>Fill the Tourmaline Phial at the Pools of Arlithrien moonwell
    .use 5621
    .complete 933,1 --Filled Tourmaline Phial

step
    .goto 1438/1,1529.44,9325.64
    >>Finish your 7 Small Spider Legs on the Lurkers and Venomfangs here
    .collect 5465,7,4161,1 --Small Spider Leg (7)
    .mob Webwood Lurker
    .mob Webwood Venomfang

step
    .goto 1438/1,1645.02,9245.89
    >>Click the Glowing Fruited Plant in the far southwest
    .accept 930 >> Accept The Glowing Fruit

step
    .goto 1438/1,956.02,9736.83
    >>Back to Dolanaar: Corithras
    .turnin 933 >> Turn in Crown of the Earth
    .accept 7383 >> Accept Crown of the Earth
    .target Corithras Moonrage

step
    .goto 1438/1,906.17,9751.02
    >>Zarrin, legs in hand
    .turnin 4161 >> Turn in Recipe of the Kaldorei
    .target Zarrin

step
    .goto 1438/1,971.91,9852.35
    >>Find Amara on the road again
    .turnin 487 >> Turn in The Road to Darnassus
    .target Moon Priestess Amara

step << Warrior
    .goto 1438/1,952.00,9822.22
    >>Kyra Windblade: level 10 training, plus her errand to Darnassus
    .accept 1684 >> Accept Elanaria
    .trainer >> Train your class abilities
    .target Kyra Windblade

step << Rogue
    .goto 1438/1,943.85,9790.28
    >>ROGUE: Take The Apple Falls at Jannok Breezesong
    .target Jannok Breezesong
    .accept 2241 >> Accept The Apple Falls

step << Hunter NightElf
    .goto 1438/1,952.00,9822.22
    >>HUNTER: Dazalar in Dolanaar starts your pet training. Use his Taming Rod on a Webwood Lurker in the spider woods north, then return
    .accept 6063 >> Accept Taming the Beast
    .complete 6063,1 --Tame a Webwood Lurker
    .turnin 6063 >> Turn in Taming the Beast
    .target Dazalar

step << Hunter NightElf
    .goto 1438/1,952.00,9822.22
    >>Second rod: a Nightsaber Stalker from the western woods
    .accept 6101 >> Accept Taming the Beast
    .target Dazalar

step << Hunter NightElf
    .goto Teldrassil,55.5,72.9
    >>Tame a Nightsaber Stalker
    .complete -6101,1 --Tame a Nightsaber Stalker

step << Hunter NightElf
    .goto 1438/1,952.00,9822.22
    >>Hand in Taming the Beast at Dazalar
    .turnin -6101 >> Turn in Taming the Beast
    .target Dazalar

step << Hunter NightElf
    .goto 1438/1,952.00,9822.22
    >>Third rod: a Strigid Screecher -- then Dazalar sends you to Darnassus to make it permanent
    .accept 6102,2,6101 >> Accept Taming the Beast
    .target Dazalar

step << Hunter NightElf
    .goto Teldrassil,65.0,67.5
    >>Tame a Strigid Screecher
    .complete -6102,1 --Tame a Strigid Screecher

step << Hunter NightElf
    .goto 1438/1,952.00,9822.22
    >>Hand in Taming the Beast; take Training the Beast at Dazalar
    .turnin -6102 >> Turn in Taming the Beast
    .accept 6103,2,6102 >> Accept Training the Beast
    .target Dazalar

step << Druid
    .goto 1438/1,965.80,9742.06
    >>DRUID: Kal in Dolanaar has heard the bear spirit's call for you
    .accept 5925 >> Accept Heeding the Call
    .target Kal

step
    .goto 1457/1,2534.29,10085.60
    >>Run northwest into Darnassus (through the glowing portal tree): Rellian Greenspyre in the Cenarion enclave
    .turnin 922 >> Turn in Rellian Greenspyre
    .accept 923 >> Accept Tumors
    .target Rellian Greenspyre

step << Rogue
    .goto 1457/1,2608.06,10113.26,8,0
    >>ROGUE: Hand in The Apple Falls; take Destiny Calls at Syurna
    .goto 1457/1,2546.89,10083.69
    .turnin 2241 >> Turn in The Apple Falls
    .target Syurna
    .accept 2242 >> Accept Destiny Calls

step
    .goto 1457/1,2508.68,9605.98
    >>Sentinel Dalia Sunblade near the bank
    .accept 98067 >> Accept Eyes of the Sentinels
    .target Sentinel Dalia Sunblade

step
    .goto 1457/1,2550.48,9631.88
    >>Priestess A'moora upstairs in the Temple of the Moon
    .accept 2518 >> Accept Tears of the Moon
    .target Priestess A'moora

step << Priest
    .goto 1457/1,2515.0296,9673.7323
    >>PRIEST: Take and hand in Stars of Elune at Priestess Alathea
    .accept 5627 >> Accept Stars of Elune
    .turnin 5627 >> Turn in Stars of Elune
    .target Priestess Alathea

step << Warrior
    .goto 1457/1,2331.89,9994.09
    >>Elanaria on the Warrior's Terrace
    .turnin 1684 >> Turn in Elanaria
    .accept 1683 >> Accept Vorlus Vilehoof
    .target Elanaria

step << Warrior
    .goto 1457/1,2190.34,9918.06
    >>Mydrannul at the gates
    .accept 6344 >> Accept Nessa Shadowsong
    .target Mydrannul

step << Hunter NightElf
    .goto 1457/1,2511.04,10178.01
    >>HUNTER: Jocaste in the Cenarion Enclave teaches you to feed, revive, and truly keep your pet
    .turnin -6103 >> Turn in Training the Beast
    .target Jocaste

step << Rogue
    .goto 1457/1,2608.06,10113.26,8,0
    >>ROGUE: Hand in Destiny Calls at Syurna
    .goto 1457/1,2546.89,10083.69
    .target Syurna
    .turnin 2242 >> Turn in Destiny Calls

step << Druid
    .goto 1457/1,2563.92,10179.04
    >>DRUID: Mathrengyl Bearwalker, upstairs in the Cenarion Enclave den
    .turnin 5925 >> Turn in Heeding the Call
    .accept 5921 >> Accept Moonglade
    .target Mathrengyl Bearwalker

step << Druid
    >>Cast your new Teleport: Moonglade spell. You arrive in Nighthaven -- Dendrite Starblaze waits in the village
    .goto Moonglade,56.2,30.6
    .turnin 5921 >> Turn in Moonglade
    .accept 5929 >> Accept Great Bear Spirit
    .target Dendrite Starblaze

step << Druid
    .goto Moonglade,39.5,27.5
    >>Seek the Great Bear Spirit in Moonglade's northwest -- walk up and listen to what it shares, then return to Dendrite
    .complete 5929,1 --Learn from the Great Bear Spirit

step << Druid
    .goto Moonglade,56.2,30.6
    >>Hand in Great Bear Spirit; take Back to Darnassus at Dendrite Starblaze
    .turnin -5929 >> Turn in Great Bear Spirit
    .accept 5931,2,5929 >> Accept Back to Darnassus
    .target Dendrite Starblaze

step << Druid
    .goto Moonglade,48.0,67.0
    >>Take the druid-only flight from Nighthaven down to Rut'theran, then the portal into Darnassus
    .fly Teldrassil >> Fly to Rut'theran Village
    .zoneskip Darnassus
    .zoneskip Teldrassil

step << Druid
    .goto 1457/1,2563.92,10179.04
    >>Mathrengyl Bearwalker in the Cenarion Enclave
    .turnin -5931 >> Turn in Back to Darnassus
    .accept 6001,2,5931 >> Accept Body and Heart
    >>Lunaclaw waits at the Moonkin Stone in Darkshore -- the route reaches Auberdine at 14, and bear form follows. Too eager? The Rut'theran boat runs there now
    .target Mathrengyl Bearwalker

step
    .hs >> Hearth to Dolanaar

step
    .goto 1438/1,1691.36,10412.66
    >>Head northwest: Elder Timberlings, Tramplers, and Mire Beasts drop 5 Mossy Tumors
    .complete 923,1 --Mossy Tumor (5)
    .mob Elder Timberling
    .mob Timberling Trampler
    .mob Timberling Mire Beast

step
    .goto 1438/1,1899.70,10582.90
    >>The Oracle Glade: Sentinel Eralya Leafshadow
    .turnin 99046 >> Turn in The Lost Runner
    .accept 99047 >> Accept Not Dead Yet
    .target Sentinel Eralya Leafshadow

step
    .goto 1438/1,1863.46,10665.16
    >>Sentinel Arynia Cloudsbreak
    .accept 937 >> Accept The Enchanted Glade
    .target Sentinel Arynia Cloudsbreak

step << Rogue
    .goto 1438/1,1879.75,10976.02
    >>ROGUE: Objective: Destiny Calls (objective 1) -- Sethir the Ancient
    .complete 2242,1
    .mob Sethir the Ancient

step
    .goto 1438/1,1857.86,10676.36
    >>Fill the Amethyst Phial at the Oracle Glade moonwell
    .use 18152
    .complete 7383,1 --Filled Amethyst Phial

step
    .goto 1438/1,2052.36,10854.19
    >>Click the Shimmering Fronded Plant up the hill
    .accept 931 >> Accept The Shimmering Frond

step
    #sticky
    #label Harpies
    .goto 1438/1,2102.82,10819.27
    >>Bloodfeather harpies: 6 Bloodfeather Belts (Matriarchs heal and nuke -- burst them first)
    .complete 937,1 --Bloodfeather Belt (6)
    .mob Bloodfeather Harpy
    .mob Bloodfeather Rogue
    .mob Bloodfeather Sorceress
    .mob Bloodfeather Matriarch

step
    .goto 1438/1,1828.60,10964.80
    >>Kill Lady Sathrah in the webbed grove north for her Silvery Spinnerets
    .complete 2518,1 --Silvery Spinnerets
    .mob Lady Sathrah

step
    #optional
    .goto 1438/1,2208.67,10758.15
    >>Mist the nightsaber waits up the hill -- her escort back to Arynia is a 10-MINUTE timer; skip if she's not there
    .accept 938 >> Accept Mist
    .target Mist

step
    #optional
    .isOnQuest 938
    .goto 1438/1,1864.47,10663.80
    >>Walk Mist home
    .turnin 938 >> Turn in Mist
    .target Sentinel Arynia Cloudsbreak

step
    #optional
    .isOnQuest 937
    .goto 1438/1,2008.57,10576.24
    >>Still short on Bloodfeather Belt? Bloodfeather Harpy / Bloodfeather Matriarch / Bloodfeather Rogue -- around here. This step skips itself once you have them
    .complete 937,1 --Bloodfeather Belt (6)
    .mob Bloodfeather Harpy
    .mob Bloodfeather Matriarch
    .mob Bloodfeather Rogue
    .mob Bloodfeather Sorceress

step
    #requires Harpies
    .goto 1438/1,1864.47,10663.80
    >>Arynia, belts in hand
    .turnin 937 >> Turn in The Enchanted Glade
    .accept 98392 >> Accept Darkness in the Glade
    .target Sentinel Arynia Cloudsbreak

step
    .goto 1438/1,2032.50,10500.90
    >>Three named harpies, in order: Hatescreech here...
    .complete 98392,1 --Hatescreech
    .mob Hatescreech

step
    .goto 1438/1,2103.78,10623.08
    >>...Windmistress Gaedress up the ridge...
    .complete 98392,2 --Windmistress Gaedress
    .mob Windmistress Gaedress

step
    .goto 1438/1,2042.68,10860.64
    >>...and Witchmother Arysa by the nests
    .complete 98392,3 --Witchmother Arysa
    .mob Witchmother Arysa

step
    .goto 1438/1,1864.47,10663.80
    >>Arynia
    .turnin 98392 >> Turn in Darkness in the Glade
    .accept 98398 >> Accept The Oracle Tree
    .target Sentinel Arynia Cloudsbreak

step
    .goto 1438/1,1932.40,10673.50
    >>Touch the glowing Tree Bark on the Oracle Tree
    .turnin 98398 >> Turn in The Oracle Tree
    .accept 940 >> Accept Teldrassil

step << Warrior
    .goto 1438/1,1411.32,9669.43
    >>Southwest to the satyr hollow: kill Vorlus Vilehoof and take his horn (clear his satyr neighbors one at a time)
    .complete 1683,1 --Horn of Vorlus
    .mob Vorlus Vilehoof

step
    .hs >> Hearth to Dolanaar

step
    .goto 1438/1,997.20,9903.60
    >>Byancie
    .turnin 99047 >> Turn in Not Dead Yet
    .accept 99050 >> Accept The Great Tree Provides
    .target Byancie

step
    .goto 1438/1,1000.40,9891.90
    >>Buy an Empty Vial from Narret Shadowgrove downstairs
    .collect 3371,1 --Empty Vial
    .target Narret Shadowgrove

step
    .goto 1438/1,982.65,9802.19
    >>And a Refreshing Spring Water from Keldamyr
    .collect 159,1 --Refreshing Spring Water
    .target Innkeeper Keldamyr

step
    #optional
    .isQuestComplete 87288
    .goto 1438/1,988.30,9891.89
    >>Aldia, if the pelts finished along the way
    .turnin 87288 >> Turn in Soft Saber Pelts
    .target Aldia

step
    .goto 1438/1,697.97,9581.87
    >>Lasher Sproutlings around Lake Al'Ameth: collect their fronds
    .complete 99050,1 --Lasher Fronds
    .mob Lasher Sproutling

step
    .goto 1438/1,713.76,9506.90
    >>Denalan with both plants' finds
    .turnin 930 >> Turn in The Glowing Fruit
    .turnin 931 >> Turn in The Shimmering Frond
    .target Denalan

step
    .goto 1438/1,719.40,9503.90
    >>Watch Denalan's planter sprout, kill the Overgrown Lasher, and loot the frond
    >>The Sprouted Fronds reward is an instant-heal that doesn't share the potion cooldown -- save them
    .accept 2399 >> Accept The Sprouted Fronds
    .turnin 2399 >> Turn in The Sprouted Fronds

step
    .goto 1438/1,997.20,9903.60
    >>Byancie
    .turnin 99050 >> Turn in The Great Tree Provides
    .accept 99073 >> Accept Easing Suffering
    .target Byancie

step
    .goto 1438/1,956.02,9736.83
    >>Corithras, final phial
    .turnin 7383 >> Turn in Crown of the Earth
    .accept 935 >> Accept Crown of the Earth
    .target Corithras Moonrage

step
    .goto 1438/1,1899.70,10582.90
    >>Ride back toward the Oracle Glade: Eralya takes the remedy
    .turnin 99073 >> Turn in Easing Suffering
    .target Sentinel Eralya Leafshadow

step
    .goto 1457/1,2569.91,10173.00
    >>Into Darnassus: Arch Druid Fandral Staghelm in the Cenarion enclave
    .turnin 940 >> Turn in Teldrassil
    .turnin 935 >> Turn in Crown of the Earth
    .target Arch Druid Fandral Staghelm



step
    .goto 1457/1,2534.25,10085.60
    >>Rellian
    .turnin 923 >> Turn in Tumors
    .target Rellian Greenspyre

step << Warrior
    .goto 1457/1,2331.89,9994.09
    >>Elanaria with the horn
    .turnin 1683 >> Turn in Vorlus Vilehoof
    .target Elanaria

step
    >>Use the Sentinel's Pendant at the four marked spots for Eyes of the Sentinels: Cenarion enclave entrance (2579,10129), the bank (2499,9932), the inn (2240,10121), and the gates (2009,9986)
    .use 279378
    .goto 1457/1,2579.30,10129.00
    .complete 98067,1

step
    .goto 1457/1,2499.90,9932.60
    >>Finish Eyes of the Sentinels
    .complete -98067,2

step
    .goto 1457/1,2240.10,10121.00
    >>Finish Eyes of the Sentinels
    .complete -98067,3

step
    .goto 1457/1,2009.10,9986.60
    >>Finish Eyes of the Sentinels
    .complete -98067,4

step
    .goto 1457/1,2508.68,9605.98
    >>Dalia by the bank
    .turnin 98067 >> Turn in Eyes of the Sentinels
    .target Sentinel Dalia Sunblade

step
    .goto 1457/1,2550.48,9631.88
    >>A'moora in the temple
    .turnin 2518 >> Turn in Tears of the Moon
    .accept 2520 >> Accept Sathrah's Sacrifice
    .target Priestess A'moora

step
    .goto 1457/1,2518.20,9632.80
    >>Offer the sacrifice at the temple fountain
    .use 8155
    .complete 2520,1 --Offer the sacrifice

step
    .goto 1457/1,2550.48,9631.88
    >>A'moora
    .turnin 2520 >> Turn in Sathrah's Sacrifice
    .target Priestess A'moora

step
    #optional
    .goto 1457/1,2341.74,9872.61
    >>Darnassus AH: buy 6x Darkshore Grouper and 5x Strider Meat -- they turn into instant XP in Auberdine
    .collect 12238,6,1141,1 --Darkshore Grouper (6)
    .collect 5469,5,2178,1 --Strider Meat (5)

step << Warrior
    #optional
    .goto 1457/1,2329.19,9908.53
    >>Ilyenia Moonfire on the Warrior's Terrace trains Staves
    .train 227 >> Train Staves
    .target Ilyenia Moonfire

step << Warrior
    #optional
    .goto 1457/1,2316.49,9924.41
    >>Ariyell Skyshadow beside her: the Gnarled Staff (~50s, equip at 15) is the best money can buy here; the Quarter Staff (~30s, equip at 11) is the budget pick
    .collect 2030,1 --Gnarled Staff
    .disablecheckbox
    .target Ariyell Skyshadow
    .money <0.3022

step
    .goto 1457/1,2636.53,9956.80
    >>Take the purple portal down to Rut'theran Village
    .zone Teldrassil >> Portal to Rut'theran

step
    .goto 1438/1,950.52,8694.07
    >>Nessa Shadowsong on the dock
    .turnin -6344 >> Turn in Nessa Shadowsong
    .accept 6341 >> Accept The Bounty of Teldrassil
    .target Nessa Shadowsong

step
    .goto 1438/1,841.10,8640.58
    >>Vesprystus the hippogryph master
    .turnin 6341 >> Turn in The Bounty of Teldrassil
    .accept 6342 >> Accept Flight to Auberdine
    .target Vesprystus

step
    .goto 1438/1,841.10,8640.58
    .fly Darkshore >> Fly to Auberdine
    .target Vesprystus

step
    +Starter complete -- you're ~11, landing in Auberdine with groupers in your bags. "14-16 Darkshore (Warrior)" picks up right on this dock (auto-loads); Darkshore mobs run 11-16, so take the early quests first and skip anything that feels hot. Turn in Flight to Auberdine at the hippogryph master as you start it
]])
