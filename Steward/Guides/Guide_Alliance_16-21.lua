-- =====================================================================
--  Custom WoW: Forever guide -- Alliance 16-21 (Warrior-optimized)
--  Chunks: 16-19 Darkshore > 19-20 Redridge > 20-21 Darkshore/Ashenvale
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Horde" then return end

-- ====================== 16-19 DARKSHORE ==============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 16-19 Darkshore (Alliance)
#next 19-20 Redridge (Alliance)
<< Alliance

step
    #sticky
    #completewith BearFinish
    >>Southern Darkshore is bear country: keep killing Rabid Thistle Bears toward 20
    .complete 2138,1 --Rabid Thistle Bear (20)
    .mob Rabid Thistle Bear

step
    .goto 1439/1,88.81,5001.87
    >>Ride south to the Grove of the Ancients and talk to Onu, the big ancient
    .turnin 948 >> Turn in Onu
    .accept 944 >> Accept The Master's Glaive
    .target Onu

step
    #sticky
    #completewith GlaiveDone
    >>Twilight cultists here can drop the Book: The Powers Below -- if you get it, use it to start a quest (turn-in is Gerrig Bonegrip in Ironforge's Forlorn Cavern -- the guide stops there when the 24-27 chapter takes the tram to Ironforge)
    .collect 5352,1,968,1 --Book: The Powers Below
    .accept 968 >> Accept The Powers Below
    .use 5352

step
    .goto 1439/1,390.70,4542.70
    >>Enter the Master's Glaive -- the huge sword in the hill south of the Grove
    .complete 944,1 --Enter the Master's Glaive

step
    .goto 1439/1,417.30,4575.82
    >>Use the Phial of Scrying standing at the scrying bowl under the blade
    .turnin 944 >> Turn in The Master's Glaive
    .accept 949 >> Accept The Twilight Camp

step
    .goto 1439/1,417.49,4575.82
    >>Click the glowing tome on the northern pedestal
    .turnin 949 >> Turn in The Twilight Camp
    .accept 950 >> Accept Return to Onu
    .accept 98042 >> Accept It's All Fun and Games Until...

step
    .goto 1439/1,409.44,4521.01
    >>Talk to Therylune to start her short escort out of the Glaive (skip if she's not up)
    .accept 945 >> Accept Therylune's Escape
    .target Therylune

step
    .goto 1439/1,288.26,4530.40
    >>Walk her out
    .complete 945,1 --Escort Therylune

step
    #label GlaiveDone
    .goto 1439/1,409.44,4521.01
    >>Kill Twilight Disciples and Thugs around the Glaive until the Peerless Eye drops
    >>Thugs can disarm you; Disciples heal -- interrupt with Pummel when you can
    .complete 98042,1 --Peerless Eye
    .mob Twilight Disciple
    .mob Twilight Thug

step
    #optional
    .goto 1439/1,413.37,4818.17
    >>Grizzled Thistle Bears north of the Glaive drop Grizzled Scalps (4) -- they knock you down, keep your health up
    .complete 1003,1 --Grizzled Scalp (4)
    .mob Grizzled Thistle Bear
    .isOnQuest 1003

step
    #optional
    .isQuestComplete 1003
    .goto 1439/1,230.62,4815.42
    >>Click Buzzbox 525 on the beach
    .turnin 1003 >> Turn in Buzzbox 525

step
    .goto 1439/1,88.81,5001.87
    >>Back to Onu
    .turnin 950 >> Turn in Return to Onu
    .accept 951 >> Accept Mathystra Relics
    .target Onu

step
    .goto 1439/1,865.97,4678.43
    >>South along the coast: click the Beached Sea Turtle (watch the Greymist murlocs -- Oracles cast and heal)
    .accept 4731 >> Accept Beached Sea Turtle

step
    .goto 1439/1,803.48,4808.95
    >>And the Beached Sea Creature just north
    .accept 4730 >> Accept Beached Sea Creature

step
    .goto 1439/1,541.75,4991.52
    >>MURKDEEP: clear the Greymist camp, then stand at the bonfire to trigger waves
    >>Wave 1: three lvl 12-13 runners. Wave 2: two lvl 15-16 warriors. Wave 3: Murkdeep (19) + a hunter -- step away from the fire between waves to catch your breath
    >>Check the water first in case someone left Murkdeep up
    .complete 4740,1 --Murkdeep slain
    .unitscan Murkdeep
    .mob Greymist Warrior
    .mob Greymist Hunter

step
    .goto 1439/1,585.76,5241.43
    >>Beached Sea Creature on the way north
    .accept 4728 >> Accept Beached Sea Creature

step
    #sticky
    #completewith AuberdineRound
    >>Reef Crawlers and Encrusted Tide Crawlers along the shore: 6 Fine Crab Chunks
    .complete 1138,1 --Fine Crab Chunks (6)
    .mob Reef Crawler
    .mob Encrusted Tide Crawler

step
    #label BearFinish
    .goto 1439/1,378.72,5749.31
    >>Finish your 20 Rabid Thistle Bears in the woods before heading back
    .complete 2138,1 --Rabid Thistle Bear (20)
    .mob Rabid Thistle Bear

step
    #label AuberdineRound
    .goto 1439/1,542.99,6342.31
    >>Auberdine: Gwennyth
    .turnin 4728 >> Turn in Beached Sea Creature
    .turnin 4730 >> Turn in Beached Sea Creature
    .turnin 4731 >> Turn in Beached Sea Turtle
    .target Gwennyth Bly'Leggonde

step
    #optional
    .isOnQuest 1138
    .goto 1439/1,-105.39,7414.59
    >>Still short on Fine Crab Chunks? Encrusted Tide Crawler / Reef Crawler -- around here. This step skips itself once you have them
    .complete 1138,1 --Fine Crab Chunks (6)
    .mob Encrusted Tide Crawler
    .mob Reef Crawler

step
    #optional
    .isQuestComplete 1138
    .goto 1439/1,577.38,6371.35
    >>Gubber
    .turnin 1138 >> Turn in Fruit of the Sea
    .target Gubber Blump

step
    .goto 1439/1,531.27,6403.27
    >>Restock food and repair with Laird
    .vendor >> Vendor and restock
    .target Laird

step
    .goto 1439/1,472.12,6438.51
    >>Glynda
    .turnin 4740 >> Turn in WANTED: Murkdeep!
    .target Sentinel Glynda Nal'Shea

step
    .goto 1439/1,397.45,6437.50
    >>Tharnariun -- the twenty bears pay out
    .turnin 2138 >> Turn in Cleansing of the Infected
    .accept 2139 >> Accept Tharnariun's Hope
    .target Tharnariun Treetender

step
    .goto 1439/1,492.30,6581.00
    >>Thundris
    .turnin 98042 >> Turn in It's All Fun and Games Until...
    .target Thundris Windweaver

step
    .goto 1439/1,48.66,6748.71
    >>Asterion at Bashal'Aran on your way north -- the broken seal frees him
    .turnin 957 >> Turn in Bashal'Aran
    .target Asterion

step
    #sticky
    #label Blackwood
    .goto 1439/1,-376.56,6807.62
    >>Blackwood camps north: open the Grain Stores (-376,6807), Nut Stores (-453,6870), and Fruit Stores (-520,6874)
    >>Each opening spawns two furbolgs on you -- be ready
    .collect 12342,1,4763,1 --Grain Sample
    .collect 12343,1,4763,1 --Nut Sample
    .collect 12341,1,4763,1 --Fruit Sample

step
    .goto 1439/1,-430.27,6662.65
    >>Kill the Den Mother in the furbolg den (the cubs stun -- kill her first)
    .complete 2139,1 --Den Mother
    .mob Den Mother

step
    #optional
    .isOnQuest 4763
    .goto 1448/1,-376.56,6807.62
    >>Still short on Blackwood Grain Sample? Blackwood Grain Stores -- around here. This step skips itself once you have them
    .collect 12342,1,4763,1 --Grain Sample

step
    #optional
    .isOnQuest 4763
    .goto 1448/1,-453.20,6870.50
    >>Still short on Blackwood Nut Sample? Blackwood Nut Stores -- around here. This step skips itself once you have them
    .collect 12343,1,4763,1 --Nut Sample

step
    #optional
    .isOnQuest 4763
    .goto 1448/1,-520.66,6873.99
    >>Still short on Blackwood Fruit Sample? Blackwood Fruit Stores -- around here. This step skips itself once you have them
    .collect 12341,1,4763,1 --Fruit Sample

step
    #requires Blackwood
    .goto 1439/1,-489.22,6875.30
    >>Use the Filled Cleansing Bowl at the Blackwood bonfire to summon Xabraxxis, kill him, and loot the Talisman of Corruption from his demon bag
    .use 12347
    .complete 4763,1 --Talisman of Corruption
    .mob Xabraxxis

step
    #label BearsDone
    .goto 1439/1,-503.63,6866.13
    .xp 18 >> Grind nearby mobs to level 18 (finish your 20 Rabid Thistle Bears)

step
    #sticky
    #completewith Buzz323
    .goto 1439/1,-571.03,7195.64
    >>Moonstalkers here if you still need fangs
    .complete 1002,1 --Moonstalker Fang (6)
    .mob Moonstalker Runt
    .mob Moonstalker

step
    #optional
    .isOnQuest 1002
    .goto 1439/1,-369.36,7152.59
    >>Still short on Moonstalker Fang? Moonstalker / Moonstalker Runt -- around here. This step skips itself once you have them
    .complete 1002,1 --Moonstalker Fang (6)
    .mob Moonstalker
    .mob Moonstalker Runt

step
    #label Buzz323
    .isQuestComplete 1002
    .goto 1439/1,-417.70,7261.14
    >>Click Buzzbox 323 up the ramp
    .turnin 1002 >> Turn in Buzzbox 323
    .accept 1003 >> Accept Buzzbox 525

step
    .goto 1439/1,-659.06,7246.69
    >>Balthule Shadowstrike by the Tower of Althalaxx
    .turnin 965 >> Turn in The Tower of Althalaxx
    .accept 966 >> Accept The Tower of Althalaxx
    .target Balthule Shadowstrike

step
    .goto 1439/1,-709.50,7201.71
    >>Kill Dark Strand Fanatics around the tower for 4 Worn Parchments
    .complete 966,1 --Worn Parchment (4)
    .mob Dark Strand Fanatic

step
    .goto 1439/1,-659.06,7246.69
    >>Balthule
    .turnin 966 >> Turn in The Tower of Althalaxx
    .accept 967 >> Accept The Tower of Althalaxx
    .target Balthule Shadowstrike

step
    .goto 1439/1,-1005.36,7383.58
    >>North to the Mathystra ruins: loot 6 Mathystra Relics off the ground
    .complete 951,1 --Mathystra Relics (6)

step
    .goto 1439/1,-769.17,7744.53
    >>Gelkak Gyromast on the coast
    .accept 2098 >> Accept Gyromast's Retrieval
    .target Gelkak Gyromast

step
    .goto 1439/1,-656.25,7801.04
    >>MIDDLE of the key: Greymist Oracles and Tidehunters by the sunken ship (LoS the Oracles' bolts behind the hull)
    .complete 2098,2 --Middle of Gelkak's Key
    .mob Greymist Tidehunter
    .mob Greymist Oracle

step
    .goto 1439/1,-767.60,7805.84
    >>BOTTOM: Raging Reef Crawlers and Encrusted Tide Crawlers (Reef Crawlers thrash hard in melee)
    .complete 2098,3 --Bottom of Gelkak's Key
    .mob Raging Reef Crawler
    .mob Encrusted Tide Crawler

step
    .goto 1439/1,-1080.03,7922.87
    >>TOP: Giant Foreststriders north along the coast
    .complete 2098,1 --Top of Gelkak's Key
    .mob Giant Foreststrider

step
    .goto 1439/1,-1146.84,7998.41
    >>Moonstalker Sires and Matriarchs here: 5 Fine Moonstalker Pelts
    >>Matriarchs bring a runt along; Sires backstab if you turn away
    .complete 986,1 --Fine Moonstalker Pelt (5)
    .mob Moonstalker Sire
    .mob Moonstalker Matriarch

step
    .goto 1439/1,-769.17,7744.53
    >>Gyromast
    .turnin 2098 >> Turn in Gyromast's Retrieval
    .accept 2078 >> Accept Gyromast's Revenge
    .target Gelkak Gyromast

step
    #optional
    .goto 1439/1,-713.36,7534.67
    >>OPTIONAL, tough solo at 18: insert the key into The Threshwackonator 4100 and walk it back to Gelkak -- it turns hostile at the end. A partner trivializes it; the reward includes Draughts of Water Breathing you'll want later. Skip freely
    .complete 2078,1 --Gyromast's Revenge
    .mob The Threshwackonator 4100

step
    #optional
    .isQuestComplete 2078
    .goto 1439/1,-769.17,7744.53
    >>Gelkak
    .turnin 2078 >> Turn in Gyromast's Revenge
    .target Gelkak Gyromast

step
    .goto 1439/1,-537.23,7543.01
    >>Beached Sea Turtle on the way south
    .accept 4727 >> Accept Beached Sea Turtle

step
    .goto 1439/1,492.36,6581.08
    >>Auberdine: Thundris
    .turnin 4763 >> Turn in The Blackwood Corrupted
    .target Thundris Windweaver

step << Druid
    #optional
    >>DRUID, now that you're 16: your sea lion awaits. Boat to Rut'theran, up to Mathrengyl in Darnassus
    .goto 1457/1,2563.98,10179.00
    .accept 26 >> Accept A Lesson to Learn
    .target Mathrengyl Bearwalker

step << Druid
    #optional
    .isOnQuest 27
    >>Teleport to Moonglade: Dendrite sets the Trial of the Lake
    .goto Moonglade,56.2,30.6
    .turnin 26 >> Turn in A Lesson to Learn
    .accept 29 >> Accept Trial of the Lake
    .target Dendrite Starblaze

step << Druid
    #optional
    .isOnQuest 29
    .goto Moonglade,50.0,38.0
    >>Dive Lake Elune'ara for a Shrine Bauble glinting on the lakebed, then carry it to the Shrine of Remulos in the northwest and use it there
    .complete 29,1 --Shrine Bauble offered

step << Druid
    #optional
    .goto Moonglade,36.5,40.1
    >>Tajarri by the shrine sets the Trial of the Sea Lion: TWO pendant halves. One lies in the sunken wreckage off WESTFALL's Longshore (the route swings there at 19), the other off SILVERPINE's southern coast (swim from Menethil at 23). The steps will be waiting
    .turnin 29 >> Turn in Trial of the Lake
    .accept 272 >> Accept Trial of the Sea Lion
    .target Tajarri

step
    .goto 1439/1,397.45,6437.50
    >>Tharnariun -- the Den Mother is avenged
    .turnin 2139 >> Turn in Tharnariun's Hope
    .target Tharnariun Treetender

step
    .goto 1439/1,362.74,6434.58
    >>Terenthis -- pelts in hand
    .turnin 986 >> Turn in A Lost Master
    .accept 993 >> Accept A Lost Master
    .target Terenthis

step << Warrior
    #optional
    #completewith next
    +If the Enchanted Moonstalker Cloak beats your cloak, wear it -- but keep your old one: this cloak is consumed by a later turn-in

step
    .goto 1439/1,542.99,6342.31
    >>Gwennyth
    .turnin 4727 >> Turn in Beached Sea Turtle
    .target Gwennyth Bly'Leggonde

step
    #optional
    .isQuestComplete 1138
    .goto 1439/1,577.38,6371.35
    >>Gubber, if the crabs are done
    .turnin 1138 >> Turn in Fruit of the Sea
    .target Gubber Blump

step
    .goto 1439/1,929.10,6543.60
    >>Take the boat from the far dock to Stormwind City (level First Aid while you wait)
    >>KEEP these in your log: Mathystra Relics, The Absent Minded Prospector, A Lost Master and The Tower of Althalaxx. After Redridge the guide hearths you back to Auberdine at 20 and turns them all in on the sweep south into Ashenvale (their follow-ups are level-20 content)
    .zone Stormwind City >> Boat to Stormwind
]])

-- ======================= 19-20 REDRIDGE ==============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 19-20 Redridge (Alliance)
#next 20-21 Darkshore/Ashenvale (Alliance)
<< Alliance

step
    .goto 1453/0,1193.10,-8328.90
    >>Off the boat: Manifest Clerk Philmor on the harbor
    .accept 97220 >> Accept Philmor's Favor
    .target Manifest Clerk Philmor

step << Rogue
    .goto 1453/0,377.61,-8752.30
    >>ROGUE: Train at your class trainer
    .trainer >> Train at your class trainer
    .train 1804
    .target Osborne the Night Man

step << Rogue
    >>ROGUE: Take Redridge Rendezvous at Renzik "The Shiv"
    .accept 2281 >> Accept Redridge Rendezvous
    .goto 1453/0,362.55,-8819.80
    .target Renzik "The Shiv"

step
    #optional
    .goto 1453/0,638.8,-8341.95
    >>Billibub Cogspinner (engineering supplies): buy a Bronze Tube if he has one -- limited stock, and a Duskwood quest needs it later
    .bronzetube
    .target Billibub Cogspinner

step << Warrior
    .goto 1453/0,323.3,-8689.29
    >>Train at the Command Center
    .trainer >> Train your class abilities
    .target Wu Shen
    .target Ilsa Corbin

step
    #optional
    .goto 1453/0,660.28,-8814.55
    >>AH: 5x Tough Condor Meat and 5x Crisp Spider Meat pre-fill the Redridge Goulash quest (snouts drop locally)
    .collect 1080,5,92,1 --Tough Condor Meat (5)
    .collect 1081,5,92,1 --Crisp Spider Meat (5)

step
    .goto 1453/0,566.60,-8845.50
    >>Elaine Trias in the Trade District
    .turnin 97220 >> Turn in Philmor's Favor
    .accept 97222 >> Accept Gatehouse Goods
    .target Elaine Trias

step
    .goto 1453/0,568.30,-8862.20
    >>Place the Gatehouse Shipment at the marked door upstairs
    .use 277198
    .complete 97222,1 --Shipment delivered

step
    .goto 1453/0,566.60,-8845.50
    >>Elaine
    .turnin 97222 >> Turn in Gatehouse Goods
    .target Elaine Trias

step
    .goto 1453/0,484.20,-8832.50
    .fly Redridge >> Fly to Redridge Mountains

step
    #optional
    .goto 1433/0,-1906.40,-9606.80
    >>Skipped Encroaching Gnolls back at 11? Guard Parker still has it -- you hand it to Deputy Feldon in Lakeshire, next step
    .accept 244 >> Accept Encroaching Gnolls
    .target Guard Parker

step
    .goto 1433/0,-2237.93,-9443.60
    >>Deputy Feldon at the Lakeshire bridge
    .turnin -244 >> Turn in Encroaching Gnolls
    .accept 246 >> Accept Assessing the Threat
    .accept 98407 >> Accept Show of Force
    .target Deputy Feldon

step << Rogue
    .goto 1433/0,-2700.75,-9222.07
    >>ROGUE: Objective: Token of Thievery
    .complete 2282,1 --Token of Thievery
    .skill lockpicking,<80,1

step
    .goto 1433/0,-2298.06,-9284.04
    >>Lakeshire pickups: Marshal Marris on the town hall porch
    .accept 20 >> Accept Blackrock Menace
    .accept 98387 >> Accept Blackrock Blockade
    .target Marshal Marris

step
    .goto 1433/0,-2268.32,-9279.12
    >>Foreman Oslow by the bridge works
    .accept 125 >> Accept The Lost Tools
    .target Foreman Oslow

step
    .goto 1433/0,-2243.14,-9259.43
    >>Verner Osgood at the stable
    .accept 118 >> Accept The Price of Shoes
    .target Verner Osgood

step
    #optional
    .goto 1433/0,-2208.60,-9243.50
    >>Wanted poster: Incinerator Gar'im is a GROUP elite in the Blackrock cave -- take it in case a group forms
    .accept 95999 >> Accept WANTED: Incinerator Gar'im

step
    .goto 1433/0,-2221.65,-9218.60
    >>Magistrate Solomon in the town hall
    .accept 120 >> Accept Messenger to Stormwind
    .target Magistrate Solomon

step
    .goto 1433/0,-2172.15,-9261.31
    >>Dockmaster Baren on the pier
    .accept 127 >> Accept Selling Fish
    .target Dockmaster Baren

step
    .goto 1433/0,-2152.62,-9217.87
    >>Darcy waits tables in the inn
    .accept 129 >> Accept A Free Lunch
    .target Darcy

step
    .goto 1433/0,-2145.67,-9231.49
    >>Wiley the Black, upstairs in the inn
    .turnin -65 >> Turn in The Defias Brotherhood
    .target Wiley the Black

step
    .goto 1433/0,-2062.96,-9209.62
    >>Chef Breanna by the bridge
    .accept 92 >> Accept Redridge Goulash
    .target Chef Breanna

step << Rogue
    .goto 1433/0,-2180.19,-9328.21
    >>ROGUE: Hand in Redridge Rendezvous; take Alther's Mill at Lucius
    .turnin 2281 >> Turn in Redridge Rendezvous
    .accept 2282 >> Accept Alther's Mill
    .target Lucius

step
    .goto 1433/0,-2207.10,-9351.52
    >>Shawn, the kid by the lake
    .accept 3741 >> Accept Hilary's Necklace
    .target Shawn

step
    #sticky
    #label Goulash
    >>As you quest: Great Goretusks (5 Great Goretusk Snouts), Tarantulas (5 Crisp Spider Meat), Dire Condors (5 Tough Condor Meat) -- don't vendor any of it before the goulash is in
    .collect 2296,5,92,1 --Great Goretusk Snout (5)
    .collect 1080,5,92,1 --Tough Condor Meat (5)
    .collect 1081,5,92,1 --Crisp Spider Meat (5)
    .mob Great Goretusk
    .mob Tarantula
    .mob Dire Condor

step
    .goto 1433/0,-2397.70,-9363.97
    >>Swim the lake: open Glinting Mud for Hilary's Necklace (several spawn points)
    .complete 3741,1 --Hilary's Necklace

step
    .goto 1433/0,-2472.16,-9366.72
    >>Dive to the submerged chest for Oslow's Toolbox
    .complete 125,1 --Oslow's Toolbox

step
    .goto 1433/0,-1906.40,-9606.80
    >>Guard Parker at the tower
    .turnin 129 >> Turn in A Free Lunch
    .accept 130 >> Accept Visit the Herbalist
    .target Guard Parker

step
    .goto 1433/0,-2246.61,-9764.90
    >>South shore: 10 Redridge Mongrels, 6 Poachers, and 5 Spiked Collars from Thrashers
    .complete 246,1 --Redridge Mongrel (10)
    .complete 246,2 --Redridge Poacher (6)
    .complete 98407,1 --Spiked Collar (5)
    .mob Redridge Mongrel
    .mob Redridge Poacher
    .mob Redridge Thrasher

step
    .goto 1433/0,-2634.54,-9588.54
    >>Murloc hyperspawn at the lake's east end: fish crates for Selling Fish, plus 8 Torn Murloc Fins
    .complete 127,1 --Selling Fish
    .collect 1468,8,150,1 --Torn Murloc Fin (8)
    .mob Murloc Shorestriker
    .mob Murloc Minor Tidecaller

step
    .goto 1433/0,-2903.07,-9691.34
    >>Dire Condors on the ridge east (for the goulash)
    .collect 1080,5,92,1 --Tough Condor Meat (5)
    .mob Dire Condor

step
    #optional
    .isOnQuest 95999
    .goto 1433/0,-3261.40,-9824.70
    >>Got a group? Incinerator Gar'im waits inside the Blackrock cave by Render's Camp -- loot his broken staff. Skip this if you're solo
    .complete 95999,1 --Broken Staff
    .mob Incinerator Gar'im

step
    .goto 1433/0,-3177.25,-9718.85
    >>Render's Camp in the far east: kill Blackrock Grunts and Outrunners for 10 Battleworn Axes, and loot the Stolen Supplies (10) and Stolen Weapons (8) off the ground
    >>Outrunners net you -- fight with your back clear
    .complete 20,1 --Battleworn Axe (10)
    .complete 98387,1 --Stolen Supplies (10)
    .complete 98387,2 --Stolen Weapon (8)
    .mob Blackrock Grunt
    .mob Blackrock Outrunner

step
    .goto 1433/0,-2903.07,-9691.34
    >>Goulash check: short on Tough Condor Meat? The Dire Condors circle this ridge. This step skips itself if you already have 5
    .collect 1080,5,92,1 --Tough Condor Meat (5)
    .mob Dire Condor

step
    .goto 1433/0,-2252.18,-9620.68
    >>Goulash check on the way back west: Great Goretusks roam the lake's south shore here. Skips itself once you have 5 snouts
    .collect 2296,5,92,1 --Great Goretusk Snout (5)
    .mob Great Goretusk

step
    .goto 1433/0,-1994.28,-9613.01
    >>Goulash check: Tarantulas creep along the lake's west end. Skips itself once you have 5 Crisp Spider Meat
    .collect 1081,5,92,1 --Crisp Spider Meat (5)
    .mob Tarantula

step
    #requires Goulash
    .goto 1433/0,-2298.06,-9284.04
    >>Lakeshire turn-ins: Marris
    .turnin 20 >> Turn in Blackrock Menace
    .turnin 98387 >> Turn in Blackrock Blockade
    .target Marshal Marris

step
    .goto 1433/0,-2268.32,-9279.12
    >>Oslow
    .turnin 125 >> Turn in The Lost Tools
    .accept 89 >> Accept The Everstill Bridge
    .target Foreman Oslow

step
    #optional
    .isQuestComplete 95999
    .goto 1433/0,-2221.65,-9218.60
    >>Solomon
    .turnin 95999 >> Turn in WANTED: Incinerator Gar'im
    .target Magistrate Solomon

step
    .goto 1433/0,-2172.59,-9261.02
    >>Baren -- the fins chain instantly
    .turnin 127 >> Turn in Selling Fish
    .accept 150 >> Accept Murloc Poachers
    .turnin 150 >> Turn in Murloc Poachers
    .target Dockmaster Baren

step
    .goto 1433/0,-2062.96,-9209.62
    >>Breanna, with all fifteen ingredients
    .turnin 92 >> Turn in Redridge Goulash
    .target Chef Breanna

step
    .goto 1433/0,-2045.38,-9245.82
    >>Martie Jainrose at the herb garden
    .turnin 130 >> Turn in Visit the Herbalist
    .accept 131 >> Accept Delivering Daffodils
    .target Martie Jainrose

step
    .goto 1433/0,-2152.62,-9216.43
    >>Darcy in the inn
    .turnin 131 >> Turn in Delivering Daffodils
    .target Darcy

step << Rogue
    >>ROGUE: Hand in Alther's Mill at Lucius
    .target Lucius
    .goto 1433/0,-2180.19,-9328.21
    .turnin 2282 >> Turn in Alther's Mill

step
    .goto 1433/0,-2205.58,-9351.52
    >>Hilary by the lake
    .turnin 3741 >> Turn in Hilary's Necklace
    .target Hilary

step
    .goto 1433/0,-2237.93,-9443.60
    >>Feldon
    .turnin 246 >> Turn in Assessing the Threat
    .turnin 98407 >> Turn in Show of Force
    .target Deputy Feldon

step
    .goto 1433/0,-2634.54,-9588.54
    .xp 20 >> Grind the murloc hyperspawn (or anything nearby) to level 20

step
    .goto 1433/0,-2234.89,-9435.35
    .fly Stormwind >> Fly to Stormwind City
    .target Ariena Stormfeather

step << Warrior
    .goto 1453/0,323.3,-8689.29
    >>Level 20 training at the Command Center
    .trainer >> Train your class abilities
    .target Wu Shen
    .target Ilsa Corbin

step << Warrior
    #optional
    .goto 1453/0,607.48,-8790.40
    >>Gunther Weller sells the Dacian Falx (~1.2g) -- a large upgrade you can equip at 21. Check the AH first for anything cheaper
    .collect 922,1 --Dacian Falx
    .disablecheckbox
    .target Gunther Weller
    .money <1.2038
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<16.0

step << Paladin
    .goto 1453/0,845.78,-8545.87
    >>PALADIN: Duthorian Rall at the Cathedral has the Tome of Valor now that you're 20
    .accept 1793 >> Accept The Tome of Valor
    .turnin 1793 >> Turn in The Tome of Valor
    .target Duthorian Rall

step << Warrior
    .goto 1453/0,323.36,-8689.33
    >>WARRIOR: Wu Shen at the Command Center refers you to the Barleybrew gauntlet in Redridge -- the 24-27 chapter runs right past it
    .accept 1698 >> Accept Yorus Barleybrew
    .target Wu Shen

step << Paladin
    .goto 1453/0,845.78,-8545.87
    >>Read the Tome of Valor, then speak to Rall again -- he sends you to a farm in Westfall
    .use 6776
    .accept 1649 >> Accept The Tome of Valor
    .turnin 1649 >> Turn in The Tome of Valor
    .accept 1650 >> Accept The Tome of Valor
    .target Duthorian Rall

step << Paladin
    .goto 1453/0,484.20,-8832.50
    .fly Westfall >> Fly to Sentinel Hill

step << Paladin
    .goto 1436/0,1556.58,-11482.95
    >>Ride southwest to Daphne Stilwell's seaside farm
    .turnin 1650 >> Turn in The Tome of Valor
    .target Daphne Stilwell

step << Paladin
    .goto 1436/0,1556.58,-11482.95
    >>EVENT: accepting starts three waves of Defias -- both you and Daphne must survive. Eat to full first, pull waves toward her shotgun, save Lay on Hands. If it fails, talk to her to try again
    .accept 1651 >> Accept The Tome of Valor
    .turnin 1651 >> Turn in The Tome of Valor
    .accept 1652 >> Accept The Tome of Valor
    .target Daphne Stilwell

step << Paladin
    .goto 1436/0,1037.39,-10627.53
    .fly Stormwind >> Fly back to Stormwind

step << Paladin
    .goto 1453/0,845.78,-8545.87
    >>Rall rewards your valor and names your next test: Jordan Stilwell at Ironforge's gate. Accept it and park it -- the route reaches him at level 26
    .turnin 1652 >> Turn in The Tome of Valor
    .accept 1653 >> Accept The Test of Righteousness
    .target Duthorian Rall

step << Druid
    #optional
    .isOnQuest 272
    .goto 1436/0,2024.00,-10646.00
    >>DRUID: on the Westfall pendant half -- fly to Sentinel Hill, ride northwest to Longshore, and dive the sunken wreckage along the coast for the Half Pendant of Aquatic Agility (search the wrecks; murlocs guard the shallows). Fly back after
    .complete 272,1 --Half Pendant of Aquatic Agility

step
    .goto 1453/0,1093.3,-8779.02
    >>Argos Nightwhisper at the harbor-side
    .accept 3765 >> Accept The Corruption Abroad
    .target Argos Nightwhisper

step
    .goto 1453/0,520.88,-8954.15
    >>General Marcus Jonathan at the city gate
    .turnin 120 >> Turn in Messenger to Stormwind
    .accept 121 >> Accept Messenger to Stormwind
    .target General Marcus Jonathan

step
    .goto 1429/0,87.73,-9456.79
    >>Run to Goldshire: Smith Argus
    .turnin 118 >> Turn in The Price of Shoes
    .accept 119 >> Accept Return to Verner
    .target Smith Argus

step
    .goto 1429/0,-728.26,-9553.08
    >>Climb the Tower of Azora on the way east: Theocritus at the top
    >>(His quest pays off later -- park it in your log)
    .accept 94 >> Accept A Watchful Eye
    .target Theocritus

step
    .goto 1433/0,-2243.14,-9259.43
    >>Continue east into Redridge: Osgood
    .turnin 119 >> Turn in Return to Verner
    .accept 124 >> Accept A Baying of Gnolls
    .accept 122 >> Accept Underbelly Scales
    .target Verner Osgood

step
    .goto 1433/0,-2221.65,-9218.60
    >>Solomon
    .turnin 121 >> Turn in Messenger to Stormwind
    .target Magistrate Solomon

step
    #sticky
    #completewith GnollCamp
    >>Black Dragon Whelps roam south of the lake: 6 Underbelly Whelp Scales
    .complete 122,1 --Underbelly Whelp Scale (6)
    .mob Black Dragon Whelp

step
    #label GnollCamp
    .goto 1433/0,-2059.27,-9091.91
    >>Gnoll camps north of town: 10 Redridge Brutes and 8 Mystics, looting 5 Iron Pikes and 5 Iron Rivets
    .complete 124,1 --Redridge Brute (10)
    .complete 124,2 --Redridge Mystic (8)
    .complete 89,1 --Iron Pike (5)
    .complete 89,2 --Iron Rivet (5)
    .mob Redridge Brute
    .mob Redridge Mystic

step
    .goto 1433/0,-2364.92,-9645.44
    >>Finish the whelp scales across the lake
    .complete 122,1 --Underbelly Whelp Scale (6)
    .mob Black Dragon Whelp

step
    .goto 1433/0,-2243.79,-9259.86
    >>Osgood
    .turnin 124 >> Turn in A Baying of Gnolls
    .turnin 122 >> Turn in Underbelly Scales
    .target Verner Osgood

step
    .goto 1433/0,-2267.67,-9280.14
    >>Oslow
    .turnin 89 >> Turn in The Everstill Bridge
    .target Foreman Oslow
]])

-- ================= 20-21 DARKSHORE / ASHENVALE =======================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 20-21 Darkshore/Ashenvale (Alliance)
#next 21-23 Ashenvale (Alliance)
<< Alliance

step
    .hs >> Hearth back to Auberdine

step << Druid
    >>DRUID: Cast Teleport: Moonglade
    .cast 18960

step << Druid
    #completewith next
    .goto 1450/1,-2400.33,7795.33--c:Moonglade,44.148,45.229
    >>DRUID: Fly to Teldrassil
    .fly Teldrassil
    .skipgossip
    .timer 153,Darnassus
    .target Silva Fil'naveth
    .zoneskip Darnassus
    .zoneskip Teldrassil

step << Druid
    .goto 1457/1,2564.600,10179.800
    >>DRUID: Take The Great Cat Spirit at Mathrengyl Bearwalker
    .target Mathrengyl Bearwalker::4217
    .accept 98393 >> Accept The Great Cat Spirit

step << Druid
    #completewith next
    >>DRUID: Cast Teleport: Moonglade
    .cast 18960
    .zoneskip Moonglade

step << Druid
    .goto 1450/1,-2678.900,8020.000
    >>DRUID: Hand in The Great Cat Spirit; take The Great Windborne Cat Spirit, The Great Cat Spirit at Dendrite Starblaze
    .target Dendrite Starblaze::11802
    .turnin 98393 >> Turn in The Great Cat Spirit
    .accept 98341 >> Accept The Great Windborne Cat Spirit << Skyborne
    .accept 98394 >> Accept The Great Cat Spirit << !Skyborne

step << Druid !Skyborne
    .goto 1450/1,-2640.000,7338.900
    >>DRUID: Hand in The Great Cat Spirit; take The Great Cat Spirit at Great Cat Spirit
    .turnin 98394 >> Turn in The Great Cat Spirit
    .accept 98396 >> Accept The Great Cat Spirit
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
    .complete 98396,2 << !Skyborne --|1/1 Relic of the Claw

step << Druid
    .goto 1450/1,-3099.200,7485.700
    >>DRUID: Objective: Relic of the Silent Shadow
    .complete 98404,3 << Skyborne --|1/1 Relic of the Silent Shadow
    .complete 98396,3 << !Skyborne --|1/1 Relic of the Silent Shadow

step << Druid
    .goto 1450/1,-3054.100,7476.800
    >>DRUID: Objective: Relic of the Fang
    .complete 98404,1 << Skyborne --|1/1 Relic of the Fang
    .complete 98396,1 << !Skyborne --|1/1 Relic of the Fang

step << Druid !Skyborne
    .goto 1450/1,-2640.000,7338.900
    >>DRUID: Hand in The Great Cat Spirit; take Blessings of the Great Cat Spirit at Great Cat Spirit
    .turnin 98396 >> Turn in The Great Cat Spirit
    .accept 98731 >> Accept Blessings of the Great Cat Spirit
    .target Great Cat Spirit

step << Druid Skyborne
    .goto 1450/1,-2395.400,7361.400
    >>DRUID: Hand in The Great Windborne Cat Spirit; take Blessings of the Great Windborne Cat Spirit at Avatar of Saeyleenan
    .target Avatar of Saeyleenan::272054
    .turnin 98404 >> Turn in The Great Windborne Cat Spirit
    .accept 98738 >> Accept Blessings of the Great Windborne Cat Spirit

step << Druid
    .goto 1450/1,-2678.200,8021.500
    >>DRUID: Hand in Blessings of the Great Windborne Cat Spirit, Blessings of the Great Cat Spirit; take To Darnassus at Dendrite Starblaze
    .target Dendrite Starblaze::11802
    .usespell 18960
    .turnin 98738 >> Turn in Blessings of the Great Windborne Cat Spirit << Skyborne
    .turnin 98731 >> Turn in Blessings of the Great Cat Spirit << !Skyborne
    .accept 98397 >> Accept To Darnassus << Alliance

step << Druid
    .goto 1450/1,-2400.33,7795.33--c:Moonglade,44.148,45.229
    >>DRUID: Fly to Teldrassil
    .fly Teldrassil
    .skipgossip
    .timer 153,Darnassus
    .target Silva Fil'naveth
    .zoneskip Darnassus
    .zoneskip Teldrassil

step << Druid
    .goto 1457/1,2564.400,10179.900
    >>DRUID: Hand in To Darnassus at Mathrengyl Bearwalker
    .target Mathrengyl Bearwalker::4217
    .turnin 98397 >> Turn in To Darnassus

step
    .goto 1439/1,431.30,6454.00
    >>Gershala Nightwhisper on the walkway
    .turnin 3765 >> Turn in The Corruption Abroad
    .target Gershala Nightwhisper

step
    #optional
    .goto 1439/1,504.41,6402.39
    >>If Murkdeep somehow isn't done, the poster is still up -- otherwise carry on
    .accept 4740 >> Accept WANTED: Murkdeep!

step
    #sticky
    #completewith Grove2
    .goto 1439/1,306.60,4784.11
    >>Grizzled Thistle Bears on the way south: finish 4 Grizzled Scalps if Buzzbox 525 is open
    .complete 1003,1 --Grizzled Scalp (4)
    .mob Grizzled Thistle Bear

step
    #label Grove2
    .goto 1439/1,88.81,5001.87
    >>Grove of the Ancients: Onu takes the relics
    .turnin 951 >> Turn in Mathystra Relics
    .target Onu

step
    #sticky
    #completewith Kerlonian
    >>Still on Fruit of the Sea? Reef Crawlers and Encrusted Tide Crawlers on these southern beaches drop the 6 Fine Crab Chunks. Gubber takes them when the guide flies you back through Auberdine at the end of the Ashenvale chapter
    .complete 1138,1 --Fine Crab Chunks (6)
    .mob Reef Crawler
    .mob Encrusted Tide Crawler
step
    .goto 1439/1,601.74,4678.61
    >>Prospector Remtravel at the excavation on the coast
    .turnin 729 >> Turn in The Absent Minded Prospector
    .target Prospector Remtravel

step
    #optional
    .goto 1439/1,602.01,4678.87
    >>His escort is HARD solo at 20 -- waves of mobs. Grab a partner or skip without guilt
    .accept 731,1 >> Accept The Absent Minded Prospector
    .complete 731,1 --Escort Remtravel
    .target Prospector Remtravel

step
    .goto 1439/1,894.73,4516.04
    >>Beached Sea Creature far south -- nagas guard it, pull them ONE at a time
    >>(Gwennyth takes these two when the guide flies you back through Auberdine at the end of the Ashenvale chapter)
    .accept 4733 >> Accept Beached Sea Creature

step
    .goto 1439/1,896.17,4597.04
    >>And the Beached Sea Turtle just north
    .accept 4732 >> Accept Beached Sea Turtle

step
    #optional
    .isOnQuest 1003
    .goto 1448/1,367.52,4780.61
    >>Still short on Grizzled Scalp? Grizzled Thistle Bear -- around here. This step skips itself once you have them
    .complete 1003,1 --Grizzled Scalp (4)
    .mob Grizzled Thistle Bear

step
    #optional
    .isQuestComplete 1003
    .goto 1439/1,230.69,4815.33
    >>Buzzbox 525 on the beach
    .turnin 1003 >> Turn in Buzzbox 525

step
    #label Kerlonian
    .goto 1439/1,33.40,4996.11
    >>Kerlonian Evershade sleeps near the Grove: TIMED ESCORT (~20 min to Ashenvale's border)
    >>Loot the Horn of Awakening from the chest beside him first; blow it whenever he nods off. Stay on the road -- ambushes only spawn off it. Skip if he's not up
    .accept 5321 >> Accept The Sleeper Has Awakened
    .complete 5321,1 --Horn of Awakening
    .target Kerlonian Evershade

step
    .isOnQuest 993
    .goto 1439/1,-5.83,4608.57
    >>Volcor hides in the cave east of the road (you can do this mid-escort if Kerlonian is walking the road)
    .turnin 993 >> Turn in A Lost Master
    .accept 995 >> Accept Escape Through Stealth
    .target Volcor

step
    .goto 1439/1,30.85,4635.20
    >>Walk Volcor out of the cave mouth
    .complete 995,1 --Escape Through Stealth

step
    .goto 1440/1,128.01,3305.31
    >>Cross into Ashenvale: Liladris Moonriver at Maestra's Post takes the sleeper
    .turnin 5321 >> Turn in The Sleeper Has Awakened
    .target Liladris Moonriver

step
    .goto 1440/1,189.71,3185.77
    >>Delgren the Purifier at the post
    .turnin 967 >> Turn in The Tower of Althalaxx
    .accept 970 >> Accept The Tower of Althalaxx
    .target Delgren the Purifier

step
    .goto 1440/1,175.87,3189.61
    >>Orendil Broadleaf beside him
    .accept 1010 >> Accept Bathran's Hair
    .target Orendil Broadleaf

step
    .goto 1440/1,-102.08,3492.89
    >>Dark Strand cultists south of the post: loot the Dark Strand Soul Gem
    .complete 970,1 --Soul Gem
    .mob Dark Strand Cultist
    .mob Dark Strand Adept

step
    .goto 1440/1,-138.99,3806.92
    >>Bathran's Ambrosia bundles grow around the ruined furbolg village -- small brown sacks, half-buried, easy to miss
    .complete 1010,1 --Bathran's Hair (5)

step
    .goto 1440/1,175.87,3189.61
    >>Orendil
    .turnin 1010 >> Turn in Bathran's Hair
    .accept 1020 >> Accept Orendil's Cure
    .target Orendil Broadleaf

step
    .goto 1440/1,189.71,3185.77
    >>Delgren -- his follow-up (Ilkrud at the tower top) is a GROUP kill for later; bank it
    .turnin 970 >> Turn in The Tower of Althalaxx
    .accept 973 >> Accept The Tower of Althalaxx
    .target Delgren the Purifier

step
    .goto 1440/1,-138.99,3806.92
    .xp 20 >> Grind Dark Strand mobs until level 20 if you're not there yet

step
    .goto 1440/1,-283.73,2827.92
    >>Ride south to Astranaar
    .fp Astranaar >> Get the Astranaar flight path
    .target Daelyshia

step
    .goto 1440/1,-299.30,2796.01
    >>Astranaar pickups for the 21+ stretch: Shindrell Swiftfire
    .accept 1008 >> Accept The Zoram Strand
    .target Shindrell Swiftfire

step
    .goto 1440/1,-411.18,2767.19
    >>Raene Wolfrunner
    .accept 991 >> Accept Raene's Cleansing
    .accept 1054 >> Accept Culling the Threat
    .target Raene Wolfrunner

step
    .goto 1440/1,-433.09,2781.02
    >>Make Astranaar home
    .home >> Set your Hearthstone to Astranaar
    .target Innkeeper Kimlya

step
    .goto 1440/1,-454.43,2682.24
    >>Pelturas Whitemoon, west side of town
    .turnin 1020 >> Turn in Orendil's Cure
    .accept 1033 >> Accept Elune's Tear
    .target Pelturas Whitemoon

step
    +Segment complete -- you're ~21 with Ashenvale's quests loaded. The 20-30 chunk is next on the tracker; banked for it: The Tower of Althalaxx (group kill), The Powers Below (Ironforge), A Watchful Eye (Azora), Escape Through Stealth's finale (Terenthis), and the two beached quests for your next Auberdine stop
]])
