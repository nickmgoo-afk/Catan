-- =====================================================================
--  Custom WoW: Forever guide -- Undead start, 1-14 (Warrior-optimized)
--  Chunks: 1-6 Deathknell > 6-12 Tirisfal Glades > 12-14 Silverpine
--  Forest. The Silverpine chapter is shared: Orc/Troll characters coming
--  out of our Durotar starter chain into it as well.
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Alliance" then return end

-- ==================== 1-6 DEATHKNELL =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 1-6 Deathknell (Undead)
#next 6-12 Tirisfal Glades (Undead)
<< Horde

step
    #completewith next
    +Undead starter, warrior-optimized. Climb out of the crypt
    .goto 1420/0,1667.77,1679.04,10

step
    .goto 1420/0,1667.77,1679.04
    >>Undertaker Mordo by the crypt door
    .accept 363 >> Accept Rude Awakening
    .target Undertaker Mordo

step << Warrior
    .goto 1420/0,1646.08,1750.44,40,0
    >>Kill Young Scavengers and Duskbats on the way down for ~10 copper of vendor loot
    .goto 1420/0,1568.35,1859.49
    >>Sell to Archibald Kava
    .vendor >> Vendor trash
    .target Archibald Kava
    .mob Young Scavenger
    .mob Duskbat

step
    .goto 1420/0,1639.75,1843.22
    >>Shadow Priest Sarvis in the chapel
    .turnin 363 >> Turn in Rude Awakening
    .accept 364 >> Accept The Mindless Ones
    .target Shadow Priest Sarvis

step << Warlock
    >>WARLOCK: Take Piercing the Veil at Venya Marthand
    .accept 1470 >> Accept Piercing the Veil
    .goto 1420/0,1633.42,1836.9
    .target Venya Marthand

step
    .goto 1420/0,1638.85,1847.74
    >>Novice Elreth beside him
    .accept 376 >> Accept The Damned
    .target Novice Elreth

step << Warlock
    #loop
    .goto 1420/0,1595.47,1985.41,0
    >>WARLOCK: Objective: Rattlecage Skull -- Rattlecage Skeleton
    .goto 1420/0,1595.47,1985.41,30,0
    .goto 1420/0,1627.55,2008.61,30,0
    .goto 1420/0,1584.17,2024.88,30,0
    .goto 1420/0,1575.58,2053.8,30,0
    .goto 1420/0,1529.49,2044.16,30,0
    .goto 1420/0,1512.32,2007.1,30,0
    .goto 1420/0,1499.67,1975.47,30,0
    .goto 1420/0,1487.47,1938.12,30,0
    .goto 1420/0,1541.69,1939.32,30,0
    .complete 1470,1 --Rattlecage Skull (3)
    .mob Rattlecage Skeleton

step << Warlock
    .goto 1420/0,1616.71,1842.92,10,0
    >>WARLOCK: Hand in Piercing the Veil at Venya Marthand
    .goto 1420/0,1633.42,1836.90
    .turnin 1470 >> Turn in Piercing the Veil
    .target Venya Marthand

step << Warrior
    .goto 1420/0,1556.61,1862.50
    >>Dannal Stern, the warrior trainer
    .train 6673 >> Train Battle Shout
    .target Dannal Stern

step << !Warrior
    #optional
    .goto 1420/0,1639.75,1843.22,30,0
    >>Visit your class trainer in Deathknell before heading out
    .trainer >> Train your class abilities

step
    .goto 1420/0,1599.99,1910.10,40,0
    >>The graveyard crawls with zombies: 8 Mindless and 8 Wretched
    .complete 364,1 --Mindless Zombie (8)
    .complete 364,2 --Wretched Zombie (8)
    .mob Mindless Zombie
    .mob Wretched Zombie

step
    .goto 1420/0,1639.75,1843.22
    >>Sarvis
    .turnin 364 >> Turn in The Mindless Ones
    .accept 3095 >> Accept Simple Scroll << Warrior
    .accept 3901 >> Accept Rattling the Rattlecages
    .target Shadow Priest Sarvis

step << Mage
    >>MAGE: Take Glyphic Scroll at Shadow Priest Sarvis, then hand in Glyphic Scroll at Isabella
    .accept 3098 >> Accept Glyphic Scroll
    .target Shadow Priest Sarvis
    .goto 1420/0,1616.71,1842.92,10,0
    .goto 1420/0,1639.75,1843.220
    .turnin 3098 >> Turn in Glyphic Scroll
    .goto 1420/0,1635.23,1847.44
    .target Isabella

step << Paladin
    >>PALADIN: Take A Difficult Path at Shadow Priest Sarvis
    .accept 98601 >> Accept A Difficult Path
    .target Shadow Priest Sarvis
    .goto 1420/0,1616.71,1842.92,10,0
    .goto 1420/0,1639.75,1843.220

step << Priest
    >>PRIEST: Take Hallowed Scroll at Shadow Priest Sarvis, then hand in Hallowed Scroll at Dark Cleric Duesten
    .accept 3097 >> Accept Hallowed Scroll
    .target Shadow Priest Sarvis
    .goto 1420/0,1616.71,1842.92,10,0
    .goto 1420/0,1639.75,1843.220
    .turnin 3097 >> Turn in Hallowed Scroll
    .target Dark Cleric Duesten
    .goto 1420/0,1627.55,1848.65

step << Rogue
    >>ROGUE: Take Encrypted Scroll at Shadow Priest Sarvis
    .accept 3096 >> Accept Encrypted Scroll
    .target Shadow Priest Sarvis
    .goto 1420/0,1616.71,1842.92,10,0
    .goto 1420/0,1639.75,1843.220

step << Warlock
    >>WARLOCK: Take Tainted Scroll at Shadow Priest Sarvis, then hand in Tainted Scroll at Maximillion
    .accept 3099 >> Accept Tainted Scroll
    .target Shadow Priest Sarvis
    .goto 1420/0,1616.71,1842.92,10,0
    .goto 1420/0,1639.75,1843.220
    .turnin 3099 >> Turn in Tainted Scroll
    .goto 1420/0,1636.59,1839.01
    .target Maximillion

step << Paladin
    .goto 1420/0,1628.400,1837.400
    >>PALADIN: Hand in A Difficult Path; take Rediscovering the Light at Aramis Hammerhand
    .turnin 98601 >> Turn in A Difficult Path
    .accept 90902 >> Accept Rediscovering the Light
    .target Aramis Hammerhand

step << Paladin
    >>PALADIN: Objective: Injured Deathguard healed
    .complete 90902,1 --|5/5 Injured Deathguard healed
    .target Injured Deathguard

step << Paladin
    .goto 1420/0,1593.500,1876.400
    >>PALADIN: Objective: Injured Deathguard healed
    .complete 90902,1 --|5/5 Injured Deathguard healed
    .target Injured Deathguard

step
    #sticky
    #completewith Rattle
    >>Rattlecage Skeletons roam the whole graveyard: 12 kills
    .complete 3901,1 --Rattlecage Skeleton (12)
    .mob Rattlecage Skeleton

step
    .goto 1420/0,1700.00,1900.00,40,0
    >>East side: Scavengers drop 6 paws, Duskbats 6 wings (skip the tougher Mangy Duskbats when you can)
    .complete 376,1 --Scavenger Paw (6)
    .complete 376,2 --Duskbat Wing (6)
    .mob Young Scavenger
    .mob Ragged Scavenger
    .mob Duskbat
    .mob Mangy Duskbat

step
    #label Rattle
    .goto 1420/0,1540.00,1960.00,40,0
    >>Finish the 12 Rattlecage Skeletons around the graves
    .complete 3901,1 --Rattlecage Skeleton (12)
    .mob Rattlecage Skeleton

step
    .goto 1420/0,1639.75,1843.22
    >>Back at the chapel: Sarvis and Elreth
    .turnin 3901 >> Turn in Rattling the Rattlecages
    .target Shadow Priest Sarvis
    .goto 1420/0,1638.85,1847.74
    .turnin 376 >> Turn in The Damned
    .accept 6395 >> Accept Marla's Last Wish
    .target Novice Elreth

step
    .goto 1420/0,1628.30,1837.30
    >>Aramis Hammerhand outside
    .accept 98389 >> Accept A Light in the Darkness
    .target Aramis Hammerhand

step << Paladin
    .goto 1420/0,1628.300,1837.300
    >>PALADIN: Hand in Rediscovering the Light; take Coming to Terms, Continue Your Training at Aramis Hammerhand
    .turnin 90902 >> Turn in Rediscovering the Light
    .accept 91208 >> Accept Coming to Terms
    .accept 91209 >> Accept Continue Your Training
    .target Aramis Hammerhand

step
    .goto 1420/0,1604.96,1860.70
    >>Deathguard Saltain, then Executor Arren
    .accept 3902 >> Accept Scavenging Deathknell
    .target Deathguard Saltain
    .goto 1420/0,1580.56,1848.95
    .accept 380 >> Accept Night Web's Hollow
    .target Executor Arren

step << Warrior
    .goto 1420/0,1568.35,1859.49
    >>Kava again, then Dannal: scroll in, Charge and Rend out
    .vendor >> Vendor trash
    .target Archibald Kava
    .goto 1420/0,1556.61,1862.50
    .turnin 3095 >> Turn in Simple Scroll
    .train 100 >> Train Charge
    .train 772 >> Train Rend
    .target Dannal Stern

step << Rogue
    #optional
    .goto 1420/0,1563.38,1859.79
    >>ROGUE: Hand in Encrypted Scroll at David Trias
    .turnin 3096 >> Turn in Encrypted Scroll
    .target David Trias

step << Paladin
    .goto 1420/0,1782.400,1914.700
    >>PALADIN: Objective: Offer aid to the Frightened Paladin -- Frightened Paladin
    .complete 91208,1 --|1/1 Offer aid to the Frightened Paladin
    .skipgossip
    .mob Frightened Paladin

step
    .goto 1420/0,1570.61,1898.35,12,0
    >>Open Scavenged Crates around the graveyard and houses: 6 Scavenged Goods
    .goto 1420/0,1541.69,1867.93,12,0
    .goto 1420/0,1593.66,1985.11,12,0
    .goto 1420/0,1617.16,1956.49,12,0
    .complete 3902,1 --Scavenged Goods (6)

step
    .goto 1420/0,1680.42,2110.43,40,0
    >>Southeast to the hollow: 10 Young Night Web Spiders outside the cave
    .complete 380,1 --Young Night Web Spider (10)
    .mob Young Night Web Spider

step
    #sticky
    #completewith CaveDone
    >>Free 6 Webbed Forsaken from the cocoons as you fight
    .complete 98389,1 --Webbed Forsaken freed (6)
    .mob Webbed Forsaken

step
    .goto 1420/0,1844.45,2042.05,30,0
    >>Into the cave: 8 Night Web Spiders
    .goto 1420/0,1918.11,2043.86,20,0
    .complete 380,2 --Night Web Spider (8)
    .mob Night Web Spider

step
    #label CaveDone
    .goto 1420/0,1921.50,2046.50
    >>Finish freeing the Webbed Forsaken deep in the cave
    .complete 98389,1 --Webbed Forsaken freed (6)
    .mob Webbed Forsaken

step
    .goto 1420/0,1604.96,1860.70
    >>Back to Deathknell: Saltain
    .turnin 3902 >> Turn in Scavenging Deathknell
    .target Deathguard Saltain

step
    .goto 1420/0,1580.56,1848.95
    >>Arren
    .turnin 380 >> Turn in Night Web's Hollow
    .accept 381 >> Accept The Scarlet Crusade
    .target Executor Arren

step
    .goto 1420/0,1628.40,1837.00
    >>Aramis
    .turnin 98389 >> Turn in A Light in the Darkness
    .target Aramis Hammerhand

step << Paladin
    .goto 1420/0,1628.400,1837.000
    >>PALADIN: Hand in Coming to Terms at Aramis Hammerhand
    .turnin 91208 >> Turn in Coming to Terms
    .target Aramis Hammerhand

step
    .goto 1420/0,1400.71,1766.71,40,0
    >>West to the Scarlet camp: Initiates and Converts carry 12 Scarlet Armbands
    >>Leave Meven Korgal alone for now; Initiates cast Frost Armor, so save them for last when you can
    .goto 1420/0,1289.55,1841.72,40,0
    .complete 381,1 --Scarlet Armband (12)
    .mob Scarlet Initiate
    .mob Scarlet Convert

step
    .goto 1420/0,1375.40,1979.69
    >>Samuel Fipps shambles south of the camp -- his remains are Marla's wish
    .collect 16333,1,6395,1 --Samuel's Remains
    .mob Samuel Fipps

step
    .goto 1420/0,1624.84,1876.96
    >>Bury Samuel at his grave in the Deathknell graveyard
    .complete 6395,1 --Samuel's Remains buried

step
    .goto 1420/0,1638.85,1847.74
    >>Elreth
    .turnin 6395 >> Turn in Marla's Last Wish
    .target Novice Elreth

step << Priest
    >>PRIEST: Take In Favor of Darkness at Dark Cleric Duesten
    .accept 5651 >> Accept In Favor of Darkness
    .target Dark Cleric Duesten
    .goto 1420/0,1627.55,1848.65

step
    .goto 1420/0,1580.56,1848.95
    >>Arren
    .turnin 381 >> Turn in The Scarlet Crusade
    .accept 382 >> Accept The Red Messenger
    .target Executor Arren

step
    .goto 1420/0,1383.99,1764.30
    >>Back west: kill Meven Korgal in the Scarlet tent for the documents
    .complete 382,1 --Scarlet Crusade Documents
    .mob Meven Korgal

step
    .goto 1420/0,1580.56,1848.95
    >>Arren sends you to Brill
    .turnin 382 >> Turn in The Red Messenger
    .accept 383 >> Accept Vital Intelligence
    .accept 96656 >> Accept The Adventurer
    .target Executor Arren

step
    .goto 1420/0,1305.36,2127.30
    >>Calvin Montague by the road out
    .accept 8 >> Accept A Rogue's Deal
    .target Calvin Montague
]])

-- ==================== 6-12 TIRISFAL GLADES ===========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 6-12 Tirisfal Glades (Undead)
#next 12-14 Silverpine Forest (Horde)
<< Horde

step
    .goto 1420/0,1184.71,2205.63
    >>Deathguard Simmer on the road east
    .accept 365 >> Accept Fields of Grief
    .target Deathguard Simmer

step
    .goto 1420/0,824.57,2092.36,40,0
    >>Watch for Gordo, the abomination shuffling along the Brill road
    .goto 1420/0,496.96,2256.54,40,0
    .accept 5481 >> Accept Gordo's Task
    .unitscan Gordo

step
    .goto 1420/0,391.40,2289.20
    >>Deathguard Bartholomew patrols the graveyard
    .accept 86784 >> Accept Sticks and Bones
    .target Deathguard Bartholomew

step
    .goto 1420/0,403.42,2287.57
    >>Deathguard Dillinger at the gate
    .accept 404 >> Accept A Putrid Task
    .target Deathguard Dillinger

step
    .goto 1420/0,539.70,2220.40,40,0
    >>Gather 6 Dry Branches under the trees around Brill
    .goto 1420/0,375.60,2246.40,40,0
    .complete 86784,1 --Dry Branch (6)

step
    .goto 1420/0,445.50,2165.90
    >>Eleanor Shackleton camps northeast of Brill
    .turnin 86784 >> Turn in Sticks and Bones
    .turnin 96656 >> Turn in The Adventurer
    .accept 96607 >> Accept The Great Outdoors
    .target Eleanor Shackleton

step
    .goto 1420/0,445.50,2165.90
    >>Type /sit at her campfire and stay seated a minute for the boosted rest buff
    .complete 96607,1 --Sit at the campfire
    .complete 96607,2 --Gain the boosted rest buff

step
    .goto 1420/0,445.40,2166.00
    >>Eleanor
    .turnin 96607 >> Turn in The Great Outdoors
    .accept 96658 >> Accept Camping 101: Cooking
    .target Eleanor Shackleton

step
    .goto 1420/0,346.94,2258.95
    >>Into Brill: Apothecary Johaan
    .accept 367 >> Accept A New Plague
    .target Apothecary Johaan

step
    .goto 1420/0,296.60,2278.20
    >>Executor Zygand
    .turnin 383 >> Turn in Vital Intelligence
    .accept 427 >> Accept At War With The Scarlet Crusade
    .accept 99141 >> Accept Patience
    .accept 99134 >> Accept Discipline
    .target Executor Zygand

step << Paladin
    .goto 1420/0,311.600,2250.800
    >>PALADIN: Hand in Continue Your Training at Shari Stilwell; objective: Report to Shari Stilwell in Brill
    .complete 91209,1 --|1/1 Report to Shari Stilwell in Brill
    .turnin 91209 >> Turn in Continue Your Training
    .target Shari Stilwell

step
    #sticky
    #completewith Motivated
    >>Use the Executor's Motivator on 5 Deathguards as you pass them in and around Brill
    .complete 99134,1 --Deathguards motivated (5)
    .use 286176

step << Warrior
    .goto 1420/0,316.66,2227.32
    >>Oliver Dwor sells the Gladius (~5s 10c) -- a solid sword upgrade; sell your old weapon toward it
    .vendor >> Vendor trash, then buy the Gladius when you can afford it
    .collect 2488,1,404,1 --Gladius
    .target Oliver Dwor
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.7

step
    .goto 1420/0,244.81,2269.19
    >>Innkeeper Renee: Calvin's debt, and a new home
    .turnin 8 >> Turn in A Rogue's Deal
    .home >> Set your Hearthstone to Brill
    .target Innkeeper Renee

step
    .goto 1420/0,243.20,2288.10
    >>William Pickman trains Cooking
    .train 2550 >> Train Cooking
    .turnin 96658 >> Turn in Camping 101: Cooking
    .target William Pickman

step
    .goto 1420/0,236.68,2249.01
    >>Gretchen Dedmar coughs upstairs in the inn
    .accept 375 >> Accept The Chill of Death
    .target Gretchen Dedmar

step << Warrior
    .goto 1420/0,238.49,2255.03
    >>Austil de Mon, the warrior trainer
    .train 3127 >> Train Parry
    .target Austil de Mon

step
    .goto 1420/0,84.90,2023.50
    >>West of Brill: ask Deathguard Kristof for his report
    .complete 99141,2 --Kristof's Report
    .target Deathguard Kristof

step
    .goto 1420/0,77.20,2026.70
    >>Shelene Rhobart at the wagon
    .accept 97558 >> Accept Hides for the Forsaken
    .target Shelene Rhobart

step
    #sticky
    #completewith Darkhounds
    >>Decrepit Darkhounds drop both Darkhound Blood and 6 Darkhound Hides
    .complete 367,1 --Darkhound Blood (5)
    .complete 97558,2 --Darkhound Hide (6)
    .mob Decrepit Darkhound

step
    #sticky
    #completewith GloomDone
    >>Gloom Weed sprouts along the roadsides: pick 3
    .complete 5481,1 --Gloom Weed (3)

step
    .goto 1420/0,655.12,2120.98,50,0
    >>East of Brill: Rotting Dead and Ravaged Corpses carry 7 Putrid Claws
    .goto 1420/0,613.54,2082.72,50,0
    .complete 404,1 --Putrid Claw (7)
    .mob Rotting Dead
    .mob Ravaged Corpse

step
    .goto 1420/0,824.57,2092.36,40,0
    >>Find Gordo on the road again for his report
    .goto 1420/0,1063.61,2201.71,40,0
    .complete 99141,3 --Gordo's Report
    .target Gordo

step
    #label GloomDone
    .goto 1420/0,1246.17,2311.97,50,0
    >>Finish the 3 Gloom Weed along the eastern road
    .goto 1420/0,1025.65,2110.43,50,0
    .complete 5481,1 --Gloom Weed (3)

step
    .goto 1420/0,1378.12,2328.54,50,0
    >>Solliden Farmstead: pull 10 Tirisfal Pumpkins from the field
    .goto 1420/0,1438.21,2303.84,50,0
    .complete 365,1 --Tirisfal Pumpkin (10)

step
    #sticky
    #completewith Warriors
    >>Scarlet Warriors parry hard for a few seconds after their defensive animation -- don't waste swings into it
    .complete 427,1 --Scarlet Warrior (10)
    .mob Scarlet Warrior

step
    .goto 1420/0,1587.70,2439.70
    >>Bareth Dawnstone hides at the top of the tower east of the farm -- mind the Scarlet Warriors up there
    .accept 99144 >> Accept Seeking Refuge
    .target Bareth Dawnstone

step
    .goto 1420/0,1268.00,2368.20
    >>Walk Bareth out of Solliden Farmstead
    .complete 99144,1 --Escort Bareth Dawnstone
    .target Bareth Dawnstone

step
    #label Warriors
    .goto 1420/0,1597.27,2290.28,50,0
    >>Finish the 10 Scarlet Warriors around the farm
    .goto 1420/0,1509.16,2473.14,50,0
    .complete 427,1 --Scarlet Warrior (10)
    .mob Scarlet Warrior

step
    #label Darkhounds
    .goto 1420/0,1238.60,2424.90,60,0
    >>Finish the Darkhound blood and hides north of the farm
    .goto 1420/0,1204.80,2543.00,60,0
    .complete 367,1 --Darkhound Blood (5)
    .complete 97558,2 --Darkhound Hide (6)
    .mob Decrepit Darkhound

step
    .goto 1420/0,425.56,2362.58,30,0
    >>Junior Apothecary Holland patrols the Brill graveyard
    .turnin 5481 >> Turn in Gordo's Task
    .accept 5482 >> Accept Doom Weed
    .target Junior Apothecary Holland

step
    .goto 1420/0,403.30,2287.70
    >>Dillinger: claws and his report
    .turnin 404 >> Turn in A Putrid Task
    .accept 426 >> Accept The Mills Overrun
    .complete 99141,1 --Dillinger's Report
    .target Deathguard Dillinger

step
    .goto 1420/0,346.94,2258.95
    >>Johaan
    .turnin 367 >> Turn in A New Plague
    .turnin 365 >> Turn in Fields of Grief
    .accept 368 >> Accept A New Plague
    .accept 407 >> Accept Fields of Grief
    .target Apothecary Johaan

step
    .goto 1420/0,347.60,2265.10
    >>Carolai Anise beside him
    .accept 95314 >> Accept That Shadowvale Green Elixir
    .target Carolai Anise

step
    #label Motivated
    .goto 1420/0,295.87,2277.93
    >>Zygand
    .turnin 427 >> Turn in At War With The Scarlet Crusade
    .accept 370 >> Accept At War With The Scarlet Crusade
    .turnin 99141 >> Turn in Patience
    .turnin 99134 >> Turn in Discipline
    .target Executor Zygand

step
    .goto 1420/0,280.06,2270.70
    >>Pick up the rest of Brill: Burgess, the wanted poster, and Magistrate Sevren
    .accept 374 >> Accept Proof of Demise
    .target Deathguard Burgess
    .goto 1420/0,288.64,2285.46
    .accept 398 >> Accept Wanted: Maggot Eye
    .goto 1420/0,265.15,2305.94
    .accept 358 >> Accept Graverobbers
    .target Magistrate Sevren

step
    .goto 1420/0,311.90,2250.70
    >>Shari Stilwell takes Bareth's news
    .turnin 99144 >> Turn in Seeking Refuge
    .target Shari Stilwell

step
    .goto 1420/0,270.12,2253.23
    >>Mrs. Winters sells the Small Brown Pouch (keep it -- it's for a quest later)
    .collect 4496,1,356,1 --Small Brown Pouch
    .target Mrs. Winters

step
    #sticky
    #completewith MaggotEye
    >>Rot Hide gnolls of every kind drop 8 Embalming Ichor
    .complete 358,3 --Embalming Ichor (8)
    .mob Rot Hide Graverobber
    .mob Rot Hide Mongrel
    .mob Rot Hide Gnoll

step
    .goto 1420/0,537.18,2555.98,40,0
    >>South of Brill: 8 Rot Hide Graverobbers at the dig
    .complete 358,1 --Rot Hide Graverobber (8)
    .mob Rot Hide Graverobber

step
    .goto 1420/0,435.96,2754.51,30,0
    >>Doom Weed grows near the trees in the gnoll camps: 10
    .goto 1420/0,476.62,2572.55,30,0
    .goto 1420/0,396.19,2676.18,30,0
    .complete 5482,1 --Doom Weed (10)

step
    .goto 1420/0,382.63,2910.55
    >>Maggot Eye holes up in the farmhouse
    .complete 398,1 --Maggot Eye's Paw
    .mob Maggot Eye

step
    #label MaggotEye
    .goto 1420/0,332.48,2862.35,50,0
    >>Finish 5 Rot Hide Mongrels and the Embalming Ichor around the farm
    .goto 1420/0,380.38,2768.97,50,0
    .complete 358,2 --Rot Hide Mongrel (5)
    .complete 358,3 --Embalming Ichor (8)
    .mob Rot Hide Mongrel
    .mob Rot Hide Gnoll

step
    .goto 1420/0,342.87,2998.22,50,0
    >>Vile Fin murlocs on the coast: 5 Scales and 3 Murloc Skins (Puddlejumpers don't carry skins)
    .goto 1420/0,65.42,2927.12,50,0
    .complete 368,1 --Vile Fin Scale (5)
    .complete 97558,3 --Vile Fin Murloc Skin (3)
    .mob Vile Fin Puddlejumper
    .mob Vile Fin Minor Oracle
    .mob Vile Fin Muckdweller

step
    .goto 1420/0,138.30,2829.60,50,0
    >>Work north along the coast: Greater and Vampiric Duskbats drop 5 Pelts and 8 Wing Membranes
    .goto 1420/0,127.50,2601.80,50,0
    .goto 1420/0,94.60,2312.10,50,0
    .complete 375,1 --Duskbat Pelt (5)
    .complete 97558,1 --Duskbat Wing Membrane (8)
    .mob Greater Duskbat
    .mob Vampiric Duskbat

step
    .goto 1420/0,244.36,2262.26
    >>Brill: Coleman Farthing
    .accept 354 >> Accept Deaths in the Family
    .accept 362 >> Accept The Haunted Mills
    .target Coleman Farthing

step
    .goto 1420/0,275.54,2260.46
    >>Buy a Coarse Thread from Abigail Shiel's wagon
    .complete 375,2 --Coarse Thread
    .target Abigail Shiel

step
    .goto 1420/0,295.87,2277.93
    >>The turn-in circuit
    .turnin 398 >> Turn in Wanted: Maggot Eye
    .target Executor Zygand

step
    .goto 1420/0,265.15,2305.94
    >>Hand in Graverobbers; take Forsaken Duties at Magistrate Sevren
    .turnin -358 >> Turn in Graverobbers
    .accept 359,2,358 >> Accept Forsaken Duties
    .target Magistrate Sevren

step
    .goto 1420/0,236.68,2249.01
    >>Hand in The Chill of Death at Gretchen Dedmar
    .turnin -375 >> Turn in The Chill of Death
    .target Gretchen Dedmar

step << Mage/Warlock
    .goto 1420/0,265.15,2305.94
    >>MAGE: Take The Prodigal Lich at Magistrate Sevren
    .accept 405,2,358 >> Accept The Prodigal Lich
    .target Magistrate Sevren

step << Warrior
    .goto 1420/0,238.49,2255.03
    >>Austil: level 8 training
    .trainer >> Train your class abilities
    .target Austil de Mon

step
    .goto 1420/0,76.00,2026.90
    >>Shelene takes the hides
    .turnin 97558 >> Turn in Hides for the Forsaken
    .target Shelene Rhobart

step
    .goto 1420/0,74.00,2022.47
    >>Deathguard Linnea beside her
    .turnin -359 >> Turn in Forsaken Duties
    .accept 360,2,359 >> Accept Return to the Magistrate
    .accept 356 >> Accept Rear Guard Patrol
    .target Deathguard Linnea

step
    .goto 1420/0,346.94,2258.95
    >>Johaan
    .turnin 368 >> Turn in A New Plague
    .accept 369 >> Accept A New Plague
    .target Apothecary Johaan

step
    .goto 1420/0,425.56,2362.58,30,0
    >>Holland on his graveyard rounds
    .turnin 5482 >> Turn in Doom Weed
    .accept 99142 >> Accept Tomb Weed
    .target Junior Apothecary Holland

step
    #sticky
    #completewith AgamandDone
    >>A Letter to Yvette can drop from any Agamand undead -- read it if it does
    .collect 2839,1,361 --A Letter to Yvette
    .accept 361 >> Accept A Letter Undelivered
    .use 2839

step
    #sticky
    #completewith AgamandDone
    >>Rattlecage and Cracked Skull Soldiers drop 5 Notched Ribs; Darkeye Bonecasters drop 3 Blackened Skulls
    .complete 426,1 --Notched Rib (5)
    .complete 426,2 --Blackened Skull (3)
    .mob Rattlecage Soldier
    .mob Cracked Skull Soldier
    .mob Darkeye Bonecaster

step
    .goto 1420/0,894.16,2609.00
    >>Northwest to Agamand Mills: Devlin Agamand haunts the first mill
    .complete 362,1 --Devlin's Remains
    .mob Devlin Agamand

step
    .goto 1420/0,803.78,2752.40
    >>Nissa Agamand drifts through the family house (she can be upstairs)
    .complete 354,2 --Nissa's Remains
    .mob Nissa Agamand

step
    .goto 1420/0,996.28,2899.11,60,0
    >>Thurman and Gregor Agamand patrol the northern mills
    .goto 1420/0,1058.19,2775.59,60,0
    .complete 354,3 --Thurman's Remains
    .complete 354,1 --Gregor's Remains
    .unitscan Thurman Agamand
    .unitscan Gregor Agamand

step
    #label AgamandDone
    .goto 1420/0,996.28,2899.11,60,0
    >>Finish the ribs and skulls among the mills
    .complete 426,1 --Notched Rib (5)
    .complete 426,2 --Blackened Skull (3)
    .mob Rattlecage Soldier
    .mob Cracked Skull Soldier
    .mob Darkeye Bonecaster

step
    .goto 1420/0,403.42,2287.87
    >>Back to Brill: Dillinger
    .turnin 426 >> Turn in The Mills Overrun
    .target Deathguard Dillinger

step
    #optional
    .isOnQuest 361
    .goto 1420/0,887.83,2750.59
    >>Still short on A Letter to Yvette? Cracked Skull Soldier / Darkeye Bonecaster / Rattlecage Soldier -- around here. This step skips itself once you have them
    .collect 2839,1,361 --A Letter to Yvette
    .mob Cracked Skull Soldier
    .mob Darkeye Bonecaster
    .mob Rattlecage Soldier
    .mob Shadowvale Mystic

step
    #optional
    .isOnQuest 361
    .goto 1420/0,250.69,2252.92
    >>Yvette Farthing, if the letter dropped
    .turnin 361 >> Turn in A Letter Undelivered
    .target Yvette Farthing

step
    .goto 1420/0,244.36,2262.26
    >>Coleman
    .turnin 354 >> Turn in Deaths in the Family
    .turnin 362 >> Turn in The Haunted Mills
    .accept 355 >> Accept Speak with Sevren
    .target Coleman Farthing

step
    .goto 1420/0,265.15,2305.94
    >>Sevren
    .turnin -360 >> Turn in Return to the Magistrate
    .turnin 355 >> Turn in Speak with Sevren
    .target Magistrate Sevren

step << Warrior
    .goto 1420/0,238.49,2254.43
    >>Austil starts the Defensive Stance chain (level 10)
    .trainer >> Train your class abilities
    .accept 1818 >> Accept Speak with Dillinger
    .target Austil de Mon

step << Warrior
    .goto 1420/0,403.87,2287.87
    >>Dillinger
    .turnin 1818 >> Turn in Speak with Dillinger
    .accept 1819 >> Accept Ulag the Cleaver
    .target Deathguard Dillinger

step << Warrior
    .goto 1420/0,360.04,2376.14
    >>Click the skull in the graveyard to summon Ulag the Cleaver, and put him back down
    .complete 1819,1 --Ulag the Cleaver
    .mob Ulag the Cleaver

step << Warrior
    .goto 1420/0,403.87,2287.87
    >>Dillinger again
    .turnin 1819 >> Turn in Ulag the Cleaver
    .accept 1820 >> Accept Speak with Coleman
    .target Deathguard Dillinger

step << Warrior
    .goto 1420/0,244.36,2262.26
    >>Coleman teaches Defensive Stance
    .turnin 1820 >> Turn in Speak with Coleman
    .target Coleman Farthing

step
    .goto 1420/0,254.60,2225.80
    >>Deathguard Terrence by the north road
    .accept 96895 >> Accept The Argent Emissary
    .target Deathguard Terrence

step << Paladin
    .goto 1420/0,311.600,2251.000
    >>PALADIN: Take A Second Home at Shari Stilwell; train at your class trainer
    .accept 91282 >> Accept A Second Home
    .trainer >> Train at your class trainer
    .target Shari Stilwell

step
    #sticky
    #completewith Rings
    >>Scarlet Zealots, Missionaries and Friars drop 10 Scarlet Insignia Rings
    .complete 374,1 --Scarlet Insignia Ring (10)

step
    .goto 1420/0,727.42,1742.31,40,0
    >>North to the Scarlet camp: Captain Perrine, 3 Zealots, 3 Missionaries
    .goto 1420/0,685.39,1741.70,40,0
    .complete 370,1 --Captain Perrine
    .complete 370,2 --Scarlet Zealot (3)
    .complete 370,3 --Scarlet Missionary (3)
    .mob Captain Perrine
    .mob Scarlet Zealot
    .mob Scarlet Missionary

step
    .goto 1420/0,295.87,2277.93
    >>Swing through Brill: Zygand escalates the Scarlet war
    .turnin 370 >> Turn in At War With The Scarlet Crusade
    .accept 371 >> Accept At War With The Scarlet Crusade
    .target Executor Zygand

step
    .goto 1420/0,54.60,1996.60
    >>Hadric Harlson northwest of Brill
    .turnin 96895 >> Turn in The Argent Emissary
    .accept 96897 >> Accept The Cult of the Damned
    .accept 96898 >> Accept Remnants of War
    .target Hadric Harlson

step
    .goto 1420/0,-130.50,1907.80
    >>The cult camp west: 8 Dark Enforcers, 8 Dark Neophytes, 12 Necrotic Crystal Fragments (ground and loot)
    >>They hit hard -- Enforcers have an instant 50-70 damage strike, so pull carefully
    .complete 96897,2 --Dark Enforcer (8)
    .complete 96897,1 --Dark Neophyte (8)
    .complete 96898,1 --Necrotic Crystal Fragment (12)
    .mob Dark Enforcer
    .mob Dark Neophyte

step
    .goto 1420/0,54.50,1996.40
    >>Hadric
    .turnin 96897 >> Turn in The Cult of the Damned
    .turnin 96898 >> Turn in Remnants of War
    .accept 96899 >> Accept Bandarion Keep
    .target Hadric Harlson

step
    .goto 1420/0,-423.96,1976.68,60,0
    >>Southwest to Balnir Farmstead: 8 Bleeding Horrors and 8 Wandering Spirits
    .goto 1420/0,-516.14,2017.05,50,0
    .complete 356,1 --Bleeding Horror (8)
    .complete 356,2 --Wandering Spirit (8)
    .mob Bleeding Horror
    .mob Wandering Spirit

step
    .goto 1420/0,-354.80,2049.00
    >>Pick 5 Tomb Weed around the farmstead graves
    .complete 99142,1 --Tomb Weed (5)

step
    #sticky
    #completewith Vachon
    >>Scarlet Friars count for both the Friars objective and the Insignia Rings
    .complete 371,2 --Scarlet Friar (5)
    .mob Scarlet Friar

step
    #label Rings
    .goto 1420/0,-573.53,2138.45,40,0
    >>The Scarlet tower camp south: 5 Friars, and finish the 10 Insignia Rings
    .goto 1420/0,-452.43,2183.03,40,0
    .complete 374,1 --Scarlet Insignia Ring (10)
    .mob Scarlet Friar
    .mob Scarlet Zealot

step
    #label Vachon
    .goto 1420/0,-528.35,2146.28
    >>Captain Vachon commands from inside the tower
    .complete 371,1 --Captain Vachon
    .complete 371,2 --Scarlet Friar (5)
    .mob Captain Vachon
    .mob Scarlet Friar

step
    .goto 1420/0,-808.96,2189.06,30,0
    >>Vicious Night Web Spiders in the far west woods: 4 venom
    .goto 1420/0,-945.88,2180.93,30,0
    .complete 369,1 --Vicious Night Web Spider Venom (4)
    .mob Vicious Night Web Spider

step
    .goto 1420/0,346.94,2259.25
    >>Brill: Johaan closes the plague chain and hands you the Silverpine delivery
    .turnin 369 >> Turn in A New Plague
    .accept 492 >> Accept A New Plague
    .accept 445 >> Accept Delivery to Silverpine Forest
    .target Apothecary Johaan

step
    .goto 1420/0,295.87,2277.93
    >>Zygand
    .turnin 371 >> Turn in At War With The Scarlet Crusade
    .target Executor Zygand

step
    .goto 1420/0,280.06,2270.70
    >>Burgess
    .turnin 374 >> Turn in Proof of Demise
    .target Deathguard Burgess

step
    .goto 1420/0,233.06,2292.39
    >>Downstairs in the back of the inn: the captured Scarlet Zealot and Mountaineer
    .turnin 407 >> Turn in Fields of Grief
    .target Captured Scarlet Zealot
    .goto 1420/0,234.42,2289.07
    .turnin 492 >> Turn in A New Plague
    .target Captured Mountaineer

step
    .goto 1420/0,74.00,2022.47
    >>Linnea
    .turnin 356 >> Turn in Rear Guard Patrol
    .target Deathguard Linnea

step << Paladin
    >>PALADIN: Hearth
    .hs
    .cooldown item,6948,>0,1
    .bindlocation 1497,1
    .zoneskip Undercity

step << Paladin
    .goto 1458/0,245.300,1637.900
    >>PALADIN: Hand in A Lesson in Divinity; take and hand in A Lesson in Divinity; take A Lesson in Divinity at Tanis Alderwood
    .turnin 94427 >> Turn in A Lesson in Divinity
    .accept 94434 >> Accept A Lesson in Divinity
    .turnin 94434 >> Turn in A Lesson in Divinity
    .accept 94435 >> Accept A Lesson in Divinity
    .target Tanis Alderwood

step
    .goto 1420/0,2038.00,2490.10
    >>Far northeast to Bandarion Keep: Leonid Barthalomew the Revered, upstairs
    .turnin 96899 >> Turn in Bandarion Keep
    .accept 96896 >> Accept A Righteous Cause
    .turnin 96896 >> Turn in A Righteous Cause
    .accept 98545 >> Accept Leonid's Letter
    .target Leonid Barthalomew the Revered

step
    .goto 1420/0,2041.20,2416.20
    >>Hilda the Breaker and Ephram Barbaro outside
    .accept 99152 >> Accept As Above, So Below
    .target Hilda the Breaker

step
    .goto 1420/0,2122.10,2436.80
    >>Take The One That Got Away at Ephram Barbaro
    .accept 99153 >> Accept The One That Got Away
    .target Ephram Barbaro

step << Paladin
    #loop
    .goto 1420/0,2424.200,2151.900,0
    >>PALADIN: Objective: Vile Fin Seer slain; Vile Fin Attacker slain -- Vile Fin Seer, Vile Fin Attacker
    .goto 1420/0,2212.000,2022.600,0
    .goto 1420/0,2424.200,2151.900,50,0
    .goto 1420/0,2212.000,2022.600,50,0
    .complete 91285,2 --|8/8 Vile Fin Seer slain
    .mob Vile Fin Seer
    .complete 91285,1 --|8/8 Vile Fin Attacker slain
    .mob Vile Fin Attacker

step << Paladin
    .goto 1420/0,2045.800,2475.500
    >>PALADIN: Hand in Murlocs at the Gates; take Touring the Grounds at Breton Samuels
    .turnin 91285 >> Turn in Murlocs at the Gates
    .accept 91294 >> Accept Touring the Grounds
    .target Breton Samuels

step << Paladin
    .goto 1420/0,2038.800,2415.900
    >>PALADIN: Objective: Speak with Hilda the Breaker
    .complete 91294,1 --|1/1 Speak with Hilda the Breaker
    .target Hilda the Breaker

step << Paladin
    .goto 1420/0,1961.100,2334.600
    >>PALADIN: Objective: Speak with Ander Solliden
    .complete 91294,3 --|1/1 Speak with Ander Solliden
    .target Ander Solliden

step << Paladin
    .goto 1420/0,2007.900,2491.200
    >>PALADIN: Objective: Speak with Jorin Croge
    .complete 91294,2 --|1/1 Speak with Jorin Croge
    .target Jorin Croge

step << Paladin
    .goto 1420/0,2035.100,2492.200
    >>PALADIN: Objective: Speak with Danitha Morr
    .complete 91294,4 --|1/1 Speak with Danitha Morr
    .target Danitha Morr

step << Paladin
    .goto 1420/0,2035.100,2492.200
    >>PALADIN: Hand in Touring the Grounds; take The Tarnished at Danitha Morr
    .turnin 91294 >> Turn in Touring the Grounds
    .accept 91317 >> Accept The Tarnished
    .target Danitha Morr

step << Paladin
    .goto 1420/0,2007.800,2491.400
    >>PALADIN: Take Making Repairs at Jorin Croge
    .accept 91316 >> Accept Making Repairs
    .target Jorin Croge

step << Paladin
    #completewith next
    >>PALADIN: Objective: Tarnished Zealot slain; Tarnished Drudge slain -- Tarnished Zealot, Tarnished Drudge
    .complete 91317,3 --|6/6 Tarnished Zealot slain
    .mob Tarnished Zealot
    .complete 91317,2 --|8/8 Tarnished Drudge slain
    .mob Tarnished Drudge

step << Paladin
    .goto 1420/0,2514.600,1903.600
    >>PALADIN: Objective: Rudolph Gelhardt's Head -- Rudolph Gelhardt
    .complete 91317,1 --|1/1 Rudolph Gelhardt's Head
    .mob Rudolph Gelhardt

step << Paladin
    .goto 1420/0,2487.700,1910.000
    >>PALADIN: Objective: Tarnished Zealot slain; Tarnished Drudge slain -- Tarnished Zealot, Tarnished Drudge
    .complete 91317,3 --|6/6 Tarnished Zealot slain
    .mob Tarnished Zealot
    .complete 91317,2 --|8/8 Tarnished Drudge slain
    .mob Tarnished Drudge

step << Paladin
    >>PALADIN: Objective: Sturdy Lumber
    .complete 91316,1 --|12/12 Sturdy Lumber

step
    #sticky
    #completewith CryptDone
    >>In the crypt, Shadowvale Lurchers and Mystics drop 6 Faintly Glowing Bones, and Bottles of Whispering Elixir sit on the ground and walls (8)
    .complete 99152,1 --Faintly Glowing Bone (6)
    .complete 95314,1 --Bottle of Whispering Elixir (8)
    .mob Shadowvale Lurcher
    .mob Shadowvale Mystic

step
    .goto 1420/0,2449.50,1857.60,10
    >>Enter the Shadowvale Crypt northeast of the keep

step
    #optional
    .goto 1420/0,2648.10,2027.20
    >>The Whispering Horror (elite, ~700 hp) lurks in the deep chamber -- group up or skip it; its residue starts a quest
    .collect 268812,1,95328 --Whispering Horror Residue
    .accept 95328 >> Accept Whispering Horror Residue
    .mob Whispering Horror

step << Paladin
    .goto 1420/0,2647.800,1815.500
    >>PALADIN: Objective: Sturdy Lumber
    .complete 91316,1 --|12/12 Sturdy Lumber

step
    .goto 1420/0,2592.40,1748.40
    >>The Glowing Crystal Fragment lies on the crypt floor
    .complete 99153,1 --Glowing Crystal Fragment

step
    #label CryptDone
    .goto 1420/0,2556.10,1868.80
    >>Finish the bones and elixir bottles before leaving
    .complete 99152,1 --Faintly Glowing Bone (6)
    .complete 95314,1 --Bottle of Whispering Elixir (8)
    .mob Shadowvale Lurcher
    .mob Shadowvale Mystic

step
    .goto 1420/0,2037.10,2416.80
    >>Back at the keep
    .turnin 99152 >> Turn in As Above, So Below
    .target Hilda the Breaker

step
    .goto 1420/0,2122.50,2436.80
    >>Hand in The One That Got Away at Ephram Barbaro
    .turnin -99153 >> Turn in The One That Got Away
    .target Ephram Barbaro

step << Paladin
    .goto 1420/0,2008.000,2491.200
    >>PALADIN: Hand in Making Repairs at Jorin Croge
    .turnin 91316 >> Turn in Making Repairs
    .target Jorin Croge

step << Paladin
    .goto 1420/0,2035.100,2492.000
    >>PALADIN: Hand in The Tarnished; take A Token of Good Faith, A Lesson in Divinity at Danitha Morr
    .turnin 91317 >> Turn in The Tarnished
    .accept 95803 >> Accept A Token of Good Faith
    .accept 94427 >> Accept A Lesson in Divinity
    .target Danitha Morr

step
    .hs >> Hearth to Brill

step
    .goto 1420/0,347.60,2265.20
    >>Carolai Anise
    .turnin 95314 >> Turn in That Shadowvale Green Elixir
    .target Carolai Anise

step << Rogue
    >>ROGUE: Objective: Astor's Letter of Introduction
    .complete 1886,1 --Astor's Letter of Introduction (1)
    .unitscan Astor Hadren
    .isOnQuest 1886

step << Paladin
    .goto 1420/0,2035.100,2492.100
    >>PALADIN: Hand in A Lesson in Divinity; take A Lesson in Divinity at Danitha Morr
    .turnin 94435 >> Turn in A Lesson in Divinity
    .accept 94436 >> Accept A Lesson in Divinity
    .target Danitha Morr

step << Paladin
    .goto 1420/0,2043.400,2497.300
    >>PALADIN: Hand in A Lesson in Divinity; take A Lesson in Divinity at Deathguard Billmuth
    .turnin 94436 >> Turn in A Lesson in Divinity
    .accept 94438 >> Accept A Lesson in Divinity
    .target Deathguard Billmuth
    .isOnQuest 94436

step << Paladin
    #optional
    .goto 1420/0,2043.400,2497.300
    >>PALADIN: Take A Lesson in Divinity at Deathguard Billmuth
    .accept 94438 >> Accept A Lesson in Divinity
    .target Deathguard Billmuth
    .isQuestTurnedIn 94436

step << Paladin
    #completewith next
    >>PALADIN: Use the quest item
    .cast 8593
    .use 6866
    .target Deathguard Falgan

step << Paladin
    .goto 1420/0,-885.200,2399.800
    >>PALADIN: Hand in A Lesson in Divinity; take A Lesson in Divinity at Deathguard Falgan
    .turnin 94438 >> Turn in A Lesson in Divinity
    .accept 94440 >> Accept A Lesson in Divinity
    .target Deathguard Falgan
    .isQuestTurnedIn 94436

step << Paladin
    .goto 1420/0,-889.700,2531.400
    >>PALADIN: Objective: Scarlet Crusade Attack Plans -- Scarlet Friar, Scarlet Zealot
    .complete 94440,1 --|1/1 Scarlet Crusade Attack Plans
    .mob Scarlet Friar
    .mob Scarlet Zealot
    .isQuestTurnedIn 94436

step << Paladin
    .goto 1420/0,2043.500,2497.300
    >>PALADIN: Hand in A Lesson in Divinity; take A Lesson in Divinity at Deathguard Billmuth
    .turnin 94440 >> Turn in A Lesson in Divinity
    .accept 94441 >> Accept A Lesson in Divinity
    .target Deathguard Billmuth
    .isQuestTurnedIn 94436

step << Paladin
    .goto 1420/0,2034.900,2492.200
    >>PALADIN: Hand in A Lesson in Divinity at Danitha Morr
    .turnin 94441 >> Turn in A Lesson in Divinity
    .target Danitha Morr
    .isQuestTurnedIn 94436

step
    .goto 1420/0,425.56,2362.58,30,0
    >>Holland
    .turnin 99142 >> Turn in Tomb Weed
    .target Junior Apothecary Holland

step << Paladin
    .goto 1420/0,2045.900,2475.400
    >>PALADIN: Hand in A Second Home; take Murlocs at the Gates at Breton Samuels
    .turnin 91282 >> Turn in A Second Home
    .accept 91285 >> Accept Murlocs at the Gates
    .target Breton Samuels

step << Priest
    #optional
    .goto Tirisfal Glades,61.57,52.19
    >>PRIEST: Dark Cleric Beryl continues Duesten's Deathknell introduction (skipped Duesten? The walk back is only worth it for the robe). Heal Deathguard Kel nearby -- Lesser Heal (Rank 2), then Power Word: Fortitude
    .turnin -5651 >> Turn in In Favor of Darkness
    .target Dark Cleric Beryl

step << Priest
    #optional
    .goto Tirisfal Glades,61.57,52.19
    >>Take Garments of Darkness at Dark Cleric Beryl
    .accept 5650,2,5651 >> Accept Garments of Darkness
    .target Dark Cleric Beryl

step << Priest
    #optional
    .goto Tirisfal Glades,61.57,52.19
    >>Heal Deathguard Kel, then hand in Garments of Darkness at Dark Cleric Beryl
    .complete -5650,1 --Heal Deathguard Kel
    .turnin -5650 >> Turn in Garments of Darkness
    .target Dark Cleric Beryl

step << Warrior
    .goto 1420/0,238.49,2255.03
    >>Austil: level 12 training (Overpower)
    .train 7384 >> Train Overpower
    .target Austil de Mon

step << Warlock
    .goto 1420/0,249.00,2250.50
    >>Warlocks: Ageron Kargal by the road -- Carendin in the Undercity calls, and we're headed there
    .accept 1478 >> Accept Halgar's Summons
    .target Ageron Kargal

step << Rogue
    .goto 1420/0,243.01,2270.70
    >>ROGUE: Train at your class trainer; take Mennet Carkad at Marion Call
    .trainer >> Train at your class trainer
    .accept 1885 >> Accept Mennet Carkad
    .target Marion Call

step << Mage
    .goto 1420/0,233.52,2256.84
    >>MAGE: Take Speak with Anastasia at Cain Firesong
    .accept 1881 >> Accept Speak with Anastasia
    .target Cain Firesong

step
    .goto 1420/0,240.75,1877.57,20,0
    >>Into the Undercity, down to the Trade Quarter
    .goto 1458/0,244.51,1598.73,15,0
    .zone Undercity >> Enter the Undercity

step
    .goto 1458/0,223.31,1634.96
    >>Innkeeper Norman: move home here before Silverpine
    .home >> Set your Hearthstone to the Undercity
    .target Innkeeper Norman

step
    .goto 1458/0,201.40,1575.20
    >>Glix Xizzix takes Leonid's letter
    .turnin 98545 >> Turn in Leonid's Letter
    .target Glix Xizzix

step << Warlock
    .goto 1458/0,57.40,1709.30
    >>The Magic Quarter: Carendin Halgar in the Temple of the Damned
    .turnin 1478 >> Turn in Halgar's Summons
    .accept 1473 >> Accept Creature of the Void
    .target Carendin Halgar

step << Warlock
    .goto 1458/0,66.74,1766.31
    >>WARLOCK: Hand in The Prodigal Lich at Bethor Iceshard
    .turnin -405 >> Turn in The Prodigal Lich
    .target Bethor Iceshard

step << Warlock
    .goto 1420/0,726.10,1801.90
    >>Up top: Egalin's Grimoire sits in Perrine's Chest among the ruins above the city
    .collect 6285,1,1473 --Egalin's Grimoire

step << Warlock
    .goto 1458/0,57.40,1709.30
    >>Carendin takes the grimoire -- summon and subdue the VOIDWALKER with his runes
    .turnin 1473 >> Turn in Creature of the Void
    .accept 1471 >> Accept The Binding
    .complete 1471,1
    .turnin 1471 >> Turn in The Binding
    .target Carendin Halgar

step << Rogue
    .goto 1458/0,71.92,1435.70
    >>ROGUE: Hand in Mennet Carkad; take The Deathstalkers at Mennet Carkad
    .turnin 1885 >> Turn in Mennet Carkad
    .accept 1886 >> Accept The Deathstalkers
    .target Mennet Carkad

step << Priest
    #optional
    .goto Undercity,49.26,17.12
    >>PRIEST: Aelthalyste in the War Quarter teaches Touch of Weakness -- the trainer note lands with her (at 20 she adds Devouring Plague; remember the corner)
    .turnin -5658 >> Turn in Touch of Weakness
    .turnin -5660 >> Turn in Touch of Weakness
    .turnin -5661 >> Turn in Touch of Weakness
    .turnin -5662 >> Turn in Touch of Weakness
    .turnin -5663 >> Turn in Touch of Weakness
    .target Aelthalyste

step << Paladin
    .goto 1458/0,316.200,1290.600
    >>PALADIN: Hand in A Token of Good Faith at Lady Sylvanas Windrunner
    .turnin 95803 >> Turn in A Token of Good Faith
    .target Lady Sylvanas Windrunner

step << Mage
    .goto Undercity,85.14,10.03
    >>MAGE: Anastasia Hartwell in the Magic Quarter -- her snapdragon errand sits at the Balnir farmstead east of Brill
    .turnin -1881 >> Turn in Speak with Anastasia
    .target Anastasia Hartwell

step << Mage
    .goto Undercity,85.14,10.03
    >>Take The Balnir Farmstead at Anastasia Hartwell
    .accept 1882,2,1881 >> Accept The Balnir Farmstead
    .target Anastasia Hartwell

step << Mage
    .goto 1458/0,56.57,1813.49
    >>MAGE: Hand in Speak with Anastasia at Anastasia Hartwell
    .turnin 1881 >> Turn in Speak with Anastasia
    .target Anastasia Hartwell

step << Mage
    .goto 1458/0,66.74,1766.31
    >>MAGE: Hand in The Prodigal Lich at Bethor Iceshard
    .turnin -405 >> Turn in The Prodigal Lich
    .target Bethor Iceshard

step << Undead Rogue
    >>ROGUE: Objective: Astor's Letter of Introduction
    .complete 1886,1 --Astor's Letter of Introduction (1)
    .unitscan Astor Hadren
    .isOnQuest 1886

step << Mage
    #optional
    .isOnQuest 1882
    .goto Tirisfal Glades,77.58,61.76
    >>The farmstead is a ten-minute round trip east past Brill: pick the Balnir Snapdragons and ride back (or bank it for a later pass)
    .complete -1882,1 --Balnir Snapdragons

step << Mage
    #optional
    .isQuestComplete 1882
    .goto Undercity,85.14,10.03
    .turnin -1882 >> Turn in The Balnir Farmstead
    .target Anastasia Hartwell

step << Rogue
    .goto 1458/0,71.92,1435.630
    >>ROGUE: Hand in The Deathstalkers at Mennet Carkad
    .turnin 1886 >> Turn in The Deathstalkers
    .target Mennet Carkad
    .isQuestComplete 1886

step << Rogue
    .goto 1458/0,71.92,1435.630
    >>ROGUE: Take The Deathstalkers at Mennet Carkad
    .accept 1898 >> Accept The Deathstalkers
    .target Mennet Carkad
    .isQuestTurnedIn 1886

step << Rogue
    .goto 1458/0,347.07,1389.48
    >>ROGUE: Hand in The Deathstalkers; take The Deathstalkers at Andron Gant
    .turnin 1898 >> Turn in The Deathstalkers
    .accept 1899 >> Accept The Deathstalkers
    .target Andron Gant
    .isQuestTurnedIn 1886

step << Rogue
    .goto 1458/0,341.41,1385.90
    >>ROGUE: Objective: Andron's Ledger
    .complete 1899,1 --Andron's Ledger (1)
    .isQuestTurnedIn 1886

step << Rogue
    .goto 1458/0,71.83,1435.51
    >>ROGUE: Hand in The Deathstalkers; take The Deathstalkers at Mennet Carkad
    .turnin 1899 >> Turn in The Deathstalkers
    .accept 1978 >> Accept The Deathstalkers
    .target Mennet Carkad
    .isQuestTurnedIn 1886

step << Rogue
    .goto 1420/0,373.60,1464.85,40,0
    >>ROGUE: Hand in The Deathstalkers at Varimathras
    .goto 1420/0,333.38,1287.72
    .turnin 1978 >> Turn in The Deathstalkers
    .target Varimathras
    .isQuestTurnedIn 1886

step << Warrior
    .goto 1458/0,133.71,1561.73
    >>Charles Seaton in the Rogues' Quarter sells the Claymore (~25s 43c) -- your 2H for the next stretch; check the auction house for anything better first
    .collect 1198,1 --Claymore
    .target Charles Seaton
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<9.0

step
    #optional
    .isOnQuest 95328
    .goto 1458/0,399.80,1776.60
    >>Father Lankester in the War Quarter, if you took the Horror's residue
    .turnin 95328 >> Turn in Whispering Horror Residue
    .target Father Lankester

step
    .goto 1458/0,539.33,1665.49,15,0
    >>Leave through the sewers and head southwest
    .goto 1420/0,629.36,1553.42
    .zone Silverpine Forest >> Cross into Silverpine Forest
]])

-- ============== 12-14 SILVERPINE FOREST (shared Horde) ===============
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 12-14 Silverpine Forest (Horde)
#next 12-17 The Barrens (Horde)
<< Horde

step
    #completewith next
    +Shared Horde bridge: Undead arrive from Tirisfal, Orc/Troll from our Durotar starter (after the Brill stance trip). Watch for Sons of Arugal on the roads -- level 25 elites, give them room

step << Undead Rogue
    >>ROGUE: Objective: Astor's Letter of Introduction
    .complete 1886,1 --Astor's Letter of Introduction (1)
    .unitscan Astor Hadren

step
    .goto 1421/0,1090.44,1409.63
    >>Deathstalker Erland waits in the trees off the road
    .accept 435 >> Accept Escorting Erland
    .target Deathstalker Erland

step
    .goto 1421/0,1087.50,1346.63,30,0
    >>Walk Erland north to Rane Yorick -- worgs ambush in pairs, so keep your health up
    .goto 1421/0,1204.68,1290.07
    .complete 435,1 --Erland reaches Rane Yorick
    .mob Worg

step
    .goto 1421/0,1204.68,1290.07
    >>Rane Yorick
    .turnin 435 >> Turn in Escorting Erland
    .accept 429 >> Accept Wild Hearts
    .accept 449 >> Accept The Deathstalkers' Report
    .target Rane Yorick

step
    #sticky
    #completewith WorgHearts
    >>Worgs and Mottled Worgs drop Discolored Worg Hearts
    .collect 3164,6,429,1 --Discolored Worg Heart (6)
    .mob Worg
    .mob Mottled Worg

step
    .goto 1421/0,941.30,1210.40,50,0
    >>Vile Fin murlocs on the lakeshore drop 3 Murloc Eyes -- keep them, they're for a quest
    .goto 1421/0,830.00,1309.40,50,0
    .collect 730,3,91920,1 --Murloc Eyes (3)
    .mob Vile Fin Shredder
    .mob Vile Fin Tidehunter

step
    #label WorgHearts
    .goto 1421/0,1025.76,1384.71,50,0
    >>Finish the 6 Worg Hearts in the woods
    .goto 1421/0,998.46,1230.99,50,0
    .collect 3164,6,429,1 --Discolored Worg Heart (6)
    .mob Worg
    .mob Mottled Worg

step
    .goto 1421/0,1538.58,511.39,100,0
    >>South to The Sepulcher
    .goto 1421/0,1593.60,554.23
    >>Dalar Dawnweaver at the graves
    .accept 421 >> Accept Prove Your Worth
    .target Dalar Dawnweaver

step
    .goto 1421/0,1533.96,474.43
    >>Karos Razok, the bat handler
    .fp Sepulcher >> Get the Sepulcher flight path
    .target Karos Razok

step << Undead
    .goto 1421/0,1602.84,520.63
    >>Allister and Podrig (Undead errands)
    .accept 477 >> Accept Border Crossings
    .target Shadow Priest Allister
    .goto 1421/0,1625.94,499.91
    .accept 6321 >> Accept Supplying the Sepulcher
    .target Deathguard Podrig

step << !Undead
    .goto 1421/0,1602.84,520.63
    >>Shadow Priest Allister
    .accept 477 >> Accept Border Crossings
    .target Shadow Priest Allister

step
    .goto 1421/0,1625.94,522.31
    >>High Executor Hadrec in the crypt
    .turnin 449 >> Turn in The Deathstalkers' Report
    .accept 3221 >> Accept Speak with Renferrel
    .accept 437 >> Accept The Dead Fields
    .target High Executor Hadrec



step
    .goto 1421/0,1652.82,522.31
    >>Apothecary Renferrel beside him
    .turnin 429 >> Turn in Wild Hearts
    .turnin 445 >> Turn in Delivery to Silverpine Forest
    .turnin 3221 >> Turn in Speak with Renferrel
    .accept 1359 >> Accept Zinge's Delivery
    .accept 447 >> Accept A Recipe For Death
    .accept 430 >> Accept Return to Quinn
    .target Apothecary Renferrel

step
    #sticky
    #completewith Bears
    >>Grizzled Bears drop 6 Grizzled Bear Hearts
    .complete 447,1 --Grizzled Bear Heart (6)
    .mob Ferocious Grizzled Bear
    .mob Giant Grizzled Bear

step
    .goto 1421/0,1336.56,568.51,50,0
    >>Northwest of the Sepulcher: 5 Moonrage Whitescalps
    .goto 1421/0,1281.96,410.87,50,0
    .complete 421,1 --Moonrage Whitescalp (5)
    .mob Moonrage Whitescalp

step
    .goto 1421/0,1593.60,554.23
    >>Dalar
    .turnin 421 >> Turn in Prove Your Worth
    .accept 422 >> Accept Arugal's Folly
    .target Dalar Dawnweaver

step
    .goto 1421/0,1231.14,866.99
    >>Valgan's Field: the Remedy of Arugal sits on the house's second floor
    .complete 422,1 --Remedy of Arugal

step
    .goto 1421/0,1205.94,1314.15
    >>Quinn Yorick, upstairs in the Ivar Patch house
    .turnin 430 >> Turn in Return to Quinn
    .accept 91920 >> Accept Wild Eyes
    .target Quinn Yorick

step
    #optional
    .goto 1421/0,941.30,1210.40,50,0
    >>Short on Murloc Eyes? The lakeshore murlocs drop them
    .collect 730,3,91920,1 --Murloc Eyes (3)
    .mob Vile Fin Shredder
    .mob Vile Fin Tidehunter

step
    .goto 1421/0,1541.52,1078.39
    >>The Dead Fields: cull Rot Hide Gladerunners and Mystics until Nightlash appears, and take her essence
    .complete 437,1 --Enter the Dead Fields
    .complete 437,2 --Essence of Nightlash
    .unitscan Nightlash
    .mob Rot Hide Gladerunner
    .mob Rot Hide Mystic

step
    .goto 1421/0,1924.14,1269.07,50,0
    >>Moss Stalkers in the eastern marsh: 6 Skittering Blood (steer clear of Krethis Shadowspinner)
    .goto 1421/0,2016.12,1239.39,50,0
    .complete 447,2 --Skittering Blood (6)
    .mob Moss Stalker

step
    #label Bears
    .goto 1421/0,1702.80,1060.47,50,0
    >>Finish the 6 bear hearts on the way back west
    .goto 1421/0,1573.86,971.15,50,0
    .complete 447,1 --Grizzled Bear Heart (6)
    .mob Ferocious Grizzled Bear
    .mob Giant Grizzled Bear

step
    .goto 1421/0,1593.60,554.23
    >>The Sepulcher: Dalar
    .turnin 422 >> Turn in Arugal's Folly
    .accept 423 >> Accept Arugal's Folly
    .target Dalar Dawnweaver

step
    .goto 1421/0,1625.94,522.31
    >>Hadrec in the crypt
    .turnin 437 >> Turn in The Dead Fields
    .accept 438 >> Accept The Decrepit Ferry
    .target High Executor Hadrec

step
    .goto 1421/0,1652.60,522.40
    >>Renferrel
    .turnin 91920 >> Turn in Wild Eyes
    .accept 91921 >> Accept Return to Quinn (Again)
    .target Apothecary Renferrel

step
    .goto 1421/0,1609.14,798.67,50,0
    >>East into the worgen hills: Moonrage Gluttons (6 shackles) and Darksouls (3) -- Darksouls flee low, so finish them fast
    .goto 1421/0,1813.68,850.47,50,0
    .goto 1421/0,1707.42,1008.39,50,0
    .complete 423,1 --Glutton Shackle (6)
    .complete 423,2 --Darksoul Shackle (3)
    .mob Moonrage Glutton
    .mob Moonrage Darksoul

step
    .goto 1421/0,1205.94,1314.15
    >>Quinn again
    .turnin 91921 >> Turn in Return to Quinn (Again)
    .target Quinn Yorick

step
    .goto 1421/0,1204.68,1290.07
    >>Rane outside
    .accept 425 >> Accept Ivar the Foul
    .target Rane Yorick

step
    .goto 1421/0,1285.32,1277.19
    >>Ivar the Foul keeps two Ravenclaw Slaves at the barn -- pull the patroller first, then take his head
    .complete 425,1 --Ivar's Head
    .mob Ivar the Foul
    .mob Ravenclaw Slave

step
    .goto 1421/0,1204.68,1290.07
    >>Rane
    .turnin 425 >> Turn in Ivar the Foul
    .target Rane Yorick

step
    .goto 1421/0,997.62,692.55
    >>Click the waterlogged chest beside the Decrepit Ferry docks
    .turnin 438 >> Turn in The Decrepit Ferry
    .accept 439 >> Accept Rot Hide Clues

step
    .goto 1421/0,1079.00,375.00,30,0
    >>North shore: finish any shackles still missing
    .complete 423,1 --Glutton Shackle (6)
    .complete 423,2 --Darksoul Shackle (3)
    .mob Moonrage Glutton
    .mob Moonrage Darksoul

step
    .goto 1421/0,1593.60,554.23
    >>The Sepulcher: Dalar
    .turnin 423 >> Turn in Arugal's Folly
    .accept 424 >> Accept Arugal's Folly
    .target Dalar Dawnweaver

step
    .goto 1421/0,1625.94,522.31
    >>Hadrec
    .turnin 439 >> Turn in Rot Hide Clues
    .accept 440 >> Accept The Engraved Ring
    .target High Executor Hadrec

step
    .goto 1421/0,1077.84,380.35,10,0
    >>Into the mine on the north shore: Grimson the Pale is at the back
    .goto 1421/0,990.48,410.87
    .complete 424,1 --Head of Grimson
    .mob Grimson the Pale

step
    .goto 1421/0,1354.62,-22.57
    >>The Dalaran camp on the western shore: clear the Apprentices (they cast Frostbolt and flee low) and click the supply crate
    .turnin 477 >> Turn in Border Crossings
    .accept 478 >> Accept Maps and Runes
    .mob Dalaran Apprentice

step
    .goto 1421/0,1602.84,520.63
    >>The Sepulcher: Allister and Dalar close out the Dalaran thread
    .turnin 478 >> Turn in Maps and Runes
    .accept 481 >> Accept Dalar's Analysis
    .target Shadow Priest Allister
    .goto 1421/0,1593.60,554.23
    .turnin 424 >> Turn in Arugal's Folly
    .turnin 481 >> Turn in Dalar's Analysis
    .accept 482 >> Accept Dalaran's Intentions
    .target Dalar Dawnweaver

step
    .goto 1421/0,1602.84,520.63
    >>Allister
    .turnin 482 >> Turn in Dalaran's Intentions
    .target Shadow Priest Allister

step << Undead
    .goto 1421/0,1533.96,474.43
    >>Karos Razok
    .turnin 6321 >> Turn in Supplying the Sepulcher
    .accept 6323 >> Accept Ride to the Undercity
    .target Karos Razok

step << Undead
    .hs >> Hearth to the Undercity

step << !Undead
    .goto 1421/0,1533.96,474.43
    >>Karos Razok
    .fly Undercity >> Fly to the Undercity
    .target Karos Razok

step << Undead
    .goto 1458/0,283.37,1610.32
    >>Gordon Wendham in the Trade Quarter
    .turnin 6323 >> Turn in Ride to the Undercity
    .accept 6322 >> Accept Michael Garrett
    .target Gordon Wendham

step << Mage
    #optional
    .goto Undercity,85.14,10.03
    >>MAGE (15+): Anastasia's robe commission before you fly west -- clear the manifestations behind the alchemist shop for the Cantation and coffers, then the tailor cuts the Spellfire set
    .turnin -1959 >> Turn in Report to Anastasia
    .target Anastasia Hartwell

step << Mage
    #optional
    .goto Undercity,85.14,10.03
    >>Take Investigate the Alchemist Shop at Anastasia Hartwell
    .accept 1960,2,1959 >> Accept Investigate the Alchemist Shop
    .target Anastasia Hartwell

step << Mage
    #optional
    .goto Undercity,85.14,10.03
    >>Finish Investigate the Alchemist Shop, then hand in Investigate the Alchemist Shop at Anastasia Hartwell
    .complete -1960,1
    .turnin -1960 >> Turn in Investigate the Alchemist Shop
    .target Anastasia Hartwell

step << Mage
    #optional
    .goto Undercity,85.14,10.03
    >>Take Gathering Materials at Anastasia Hartwell
    .accept 1961,2,1960 >> Accept Gathering Materials
    .target Anastasia Hartwell

step << Mage
    #optional
    .isOnQuest 1961
    .goto Undercity,70.76,30.69
    >>Josef Gregorian on the Magic Quarter ring: 10 Linen Cloth plus the Dalaran Mana Gems from the coffers
    .turnin -1961 >> Turn in Gathering Materials
    .target Josef Gregorian

step << Mage
    #optional
    .goto Undercity,70.76,30.69
    >>Take Spellfire Robes at Josef Gregorian
    .accept 1962,2,1961 >> Accept Spellfire Robes
    .target Josef Gregorian

step << Mage
    #optional
    .goto Undercity,70.76,30.69
    >>Hand in Spellfire Robes at Josef Gregorian
    .turnin -1962 >> Turn in Spellfire Robes
    .target Josef Gregorian

step << Undead
    .goto 1458/0,266.20,1567.17
    >>Michael Garrett, the bat handler above
    .turnin 6322 >> Turn in Michael Garrett
    .target Michael Garrett

step << Undead Rogue
    .goto 1458/0,71.92,1435.630
    >>ROGUE: Hand in The Deathstalkers; take The Deathstalkers at Mennet Carkad
    .turnin 1886 >> Turn in The Deathstalkers
    .accept 1898 >> Accept The Deathstalkers
    .target Mennet Carkad
    .isQuestComplete 1886

step << Undead Rogue
    .goto 1458/0,71.92,1435.630
    >>ROGUE: Take The Deathstalkers at Mennet Carkad
    .accept 1898 >> Accept The Deathstalkers
    .target Mennet Carkad
    .isQuestTurnedIn 1886

step << Undead Rogue
    #optional
    .goto 1458/0,68.66,1416.69
    >>ROGUE: Train at your class trainer
    .train 1758
    .target Carolyn Ward
    .xp <14,1
    .xp >16,1
    .isOnQuest 1898

step << Undead Rogue
    #optional
    .goto 1458/0,68.66,1416.69
    >>ROGUE: Train at your class trainer
    .train 6761
    .target Carolyn Ward
    .xp <16,1
    .isOnQuest 1898

step << Undead Rogue
    .goto 1458/0,347.07,1389.48
    >>ROGUE: Hand in The Deathstalkers; take The Deathstalkers at Andron Gant
    .turnin 1898 >> Turn in The Deathstalkers
    .accept 1899 >> Accept The Deathstalkers
    .target Andron Gant
    .isQuestTurnedIn 1886

step << Undead Rogue
    .goto 1458/0,341.41,1385.90
    >>ROGUE: Objective: Andron's Ledger
    .complete 1899,1 --Andron's Ledger (1)
    .isQuestTurnedIn 1886

step
    .goto 1458/0,310.90,1528.10
    >>Alessandro Luca in the Trade Quarter
    .accept 97891 >> Accept Prompt Potion Runner
    .target Alessandro Luca

step
    .goto 1458/0,426.10,1403.60
    >>Doctor Martin Felben in the Apothecarium
    .complete 97891,1 --Speak to Doctor Martin Felben
    .turnin 97891 >> Turn in Prompt Potion Runner
    .target Doctor Martin Felben

step
    .goto 1458/0,404.63,1434.67
    >>Faranell and Zinge, deeper in
    .turnin 447 >> Turn in A Recipe For Death
    .target Master Apothecary Faranell
    .goto 1458/0,391.97,1442.87
    .turnin 1359 >> Turn in Zinge's Delivery
    .accept 1358 >> Accept Sample for Helbrim
    .target Apothecary Zinge

step << Undead Rogue
    .goto 1458/0,71.83,1435.51
    >>ROGUE: Hand in The Deathstalkers; take The Deathstalkers at Mennet Carkad
    .turnin 1899 >> Turn in The Deathstalkers
    .accept 1978 >> Accept The Deathstalkers
    .target Mennet Carkad
    .isQuestTurnedIn 1886

step << Undead Rogue
    .goto 1420/0,373.60,1464.85,40,0
    >>ROGUE: Hand in The Deathstalkers at Varimathras
    .goto 1420/0,333.38,1287.72
    .turnin 1978 >> Turn in The Deathstalkers
    .target Varimathras
    .isQuestTurnedIn 1886

step
    .goto 1420/0,265.15,2305.94
    >>Brill, a minute north of the zeppelin towers: Magistrate Sevren takes Deliah's ring
    .turnin 440 >> Turn in The Engraved Ring
    .target Magistrate Sevren

step
    .goto 1420/0,235.32,1883.89,50,0
    >>Out of the Undercity to the zeppelin towers
    .goto 1420/0,299.04,2069.46,20,0
    .zone Durotar >> Take the Orgrimmar zeppelin to Durotar

step
    .goto 1411/1,-4648.55,271.43
    >>Razor Hill: Takrin Pathseeker
    .accept 840 >> Accept Conscript of the Horde
    .target Takrin Pathseeker

step << Warrior
    #optional
    .goto 1411/1,-4827.27,311.62
    >>Tarshaw Jaggedscar trains warriors, if anything's pending
    .trainer >> Train your class abilities
    .target Tarshaw Jaggedscar

step
    .goto 1413/1,-3687.11,303.14
    >>West to Far Watch Post: Kargal Battlescar
    .turnin 840 >> Turn in Conscript of the Horde
    .accept 842 >> Accept Crossroads Conscription
    .target Kargal Battlescar

step
    +Bridge complete -- you're ~14 at Far Watch Post with the Barrens ahead. The Barrens 12-17 chapter loads next automatically. Banked: Crossroads Conscription (Thork at the Crossroads), Sample for Helbrim (Apothecary Helbrim there too), and The Engraved Ring (Silverpine, later)
]])
