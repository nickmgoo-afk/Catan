-- =====================================================================
--  Custom WoW: Forever guide -- Alliance 21-30 (Warrior-optimized)
--  Chunks: 21-23 Ashenvale > 23-24 Wetlands > 24-27 Redridge/Duskwood >
--  27-30 Wetlands/Hillsbrad. Continues the chain from Astranaar.
--  FIRST SKELETON-BASED CHUNK: route from RestedXP's classic-era data,
--  every quest verified to exist in Forever via QuestieDB's Forever DB
--  (132 route quests checked, 2 TBC-era leftovers dropped); 16 Forever-
--  new quests woven in from QuestieDB data. Status: verify in game.
--  Cross-checked 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Horde" then return end

-- ==================== 21-23 ASHENVALE ================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 21-23 Ashenvale (Alliance)
#next 23-24 Wetlands (Alliance)
<< Alliance

step
    #completewith next
    +Continuing from Astranaar with the banked Darkshore chains in your log (Tower of Althalaxx, Raene's Cleansing, Culling the Threat, Elune's Tear, Zoram Strand, Therylune)

step
    .goto Ashenvale,26.4,38.6
    >>Northwest to Maestra's Post: Orendil Broadleaf
    .accept 1010 >> Accept Bathran's Hair
    .target Orendil Broadleaf

step
    .goto Ashenvale,31.3,23.2
    >>Bathran's Hair grows at the haunted estate north -- small brown sacks, easy to miss
    .complete 1010,1 --Bathran's Hair (5)

step
    .goto Ashenvale,26.4,38.6
    >>Orendil
    .turnin 1010 >> Turn in Bathran's Hair
    .accept 1020 >> Accept Orendil's Cure
    .target Orendil Broadleaf

step
    .goto Ashenvale,34.40,48.00
    >>Astranaar proper
    .fp Astranaar >> Get the Astranaar flight path

step
    .goto Ashenvale,34.7,48.8
    >>Shindrell Swiftfire
    .accept 1008 >> Accept The Zoram Strand
    .target Shindrell Swiftfire

step
    .goto Ashenvale,36.61,49.58
    >>Raene Wolfrunner
    .accept 1054 >> Accept Culling the Threat
    .accept 991 >> Accept Raene's Cleansing
    .target Raene Wolfrunner

step
    .goto Ashenvale,37.3,51.8
    >>Pelturas Whitemoon -- a short roleplay follows the cure
    .turnin 1020 >> Turn in Orendil's Cure
    .accept 1033 >> Accept Elune's Tear
    .target Pelturas Whitemoon

step
    .goto Ashenvale,46.2,45.9
    >>East of town: the small blue Tear sits on the ground by the ruins
    .complete 1033,1 --Elune's Tear

step
    .goto Ashenvale,37.8,34.7
    >>Dal Bloodclaw patrols the furbolg dens northwest
    .complete 1054,1 --Dal Bloodclaw's Skull
    .unitscan Dal Bloodclaw

step
    .goto Ashenvale,36.61,49.58
    >>Raene
    .turnin 1054 >> Turn in Culling the Threat
    .target Raene Wolfrunner

step
    .goto Ashenvale,37.3,51.8
    >>Pelturas (another short roleplay)
    .turnin 1033 >> Turn in Elune's Tear
    .accept 1034 >> Accept The Ruins of Stardust
    .target Pelturas Whitemoon

step
    .goto Ashenvale,33.3,67.4
    >>The ruins south across the river: 5 Handfuls of Stardust
    .complete 1034,1 --Handful of Stardust (5)

step
    .isOnQuest 973
    .goto Ashenvale,25.3,60.8
    >>Ilkrud Magthrull squats in the tower southwest -- stun his summons and take his tome (pays off the banked Althalaxx chain)
    .complete 973,1 --Ilkrud Magthrull's Tome

step
    .isQuestComplete 945
    .goto Ashenvale,22.7,51.9
    >>Over the hills: Therysil, if Therylune's walk was finished back in Darkshore
    .turnin 945 >> Turn in Therylune's Escape
    .target Therysil

step
    .isOnQuest 973
    .goto Ashenvale,26.19,38.69
    >>Delgren the Purifier at Maestra's Post
    .turnin 973 >> Turn in The Tower of Althalaxx
    .target Delgren the Purifier

step
    .goto Ashenvale,20.3,42.4
    >>Teronis' corpse lies in the lake ruins -- then murlocs there drop the Glowing Gem (rotten drop rate, stay patient)
    .turnin 991 >> Turn in Raene's Cleansing
    .accept 1023 >> Accept Raene's Cleansing
    .complete 1023,1 --Glowing Gem
    .target Teronis' Corpse

step
    .goto Ashenvale,14.7,31.3
    >>The Zoram Strand: Talen in the ruins
    .accept 1007 >> Accept The Ancient Statuette
    .target Talen

step
    #sticky
    #completewith NagaDone
    >>Wrathtail naga die 20 heads deep along the strand
    .complete 1008,1 --Wrathtail Head (20)

step
    .goto Ashenvale,14.2,20.6
    >>The Ancient Statuette lies on the sand north
    .complete 1007,1 --Ancient Statuette

step
    .goto Ashenvale,14.79,31.29
    >>Talen (a roleplay runs)
    .turnin 1007 >> Turn in The Ancient Statuette
    .accept 1009 >> Accept Ruuzel
    .target Talen

step
    .goto Ashenvale,7.0,13.4
    >>Ruuzel holds the far island -- pull her adds off one at a time
    .complete 1009,1 --Ring of Zoram
    .mob Ruuzel

step
    #label NagaDone
    .goto Ashenvale,13.8,29.1,40,0
    >>Finish the 20 Wrathtail Heads on the way back
    .complete 1008,1 --Wrathtail Head (20)

step
    .goto Ashenvale,14.79,31.29
    >>Talen
    .turnin 1009 >> Turn in Ruuzel
    .target Talen

step
    .hs >> Hearth to Astranaar

step
    .goto Ashenvale,36.61,49.58
    >>Raene takes the gem
    .turnin 1023 >> Turn in Raene's Cleansing
    .accept 1025 >> Accept An Aggressive Defense
    .target Raene Wolfrunner

step
    .goto Ashenvale,37.3,51.8
    >>Pelturas
    .turnin 1034 >> Turn in The Ruins of Stardust
    .target Pelturas Whitemoon

step
    .goto Ashenvale,34.7,48.9
    >>Shindrell
    .turnin 1008 >> Turn in The Zoram Strand
    .target Shindrell Swiftfire

step
    .goto Ashenvale,49.9,60.8,40,0
    >>The Foulweald furbolg village south: the Den Watcher, 2 Ursa, 10 Totemics, 12 Warriors
    .goto Ashenvale,56.9,63.7,40,0
    .complete 1025,1 --Foulweald Den Watcher
    .complete 1025,2 --Foulweald Ursa (2)
    .complete 1025,3 --Foulweald Totemic (10)
    .complete 1025,4 --Foulweald Warrior (12)
    .mob Foulweald Den Watcher
    .mob Foulweald Ursa
    .mob Foulweald Totemic
    .mob Foulweald Warrior

step
    .goto Ashenvale,49.79,67.21
    >>Sentinel Velene Starstrike by Mystral Lake
    .accept 1016 >> Accept Elemental Bracers
    .target Sentinel Velene Starstrike

step
    .goto Ashenvale,48.0,69.9
    >>Water elementals on the lake island drop 5 Intact Bracers -- then read the Divining Scroll
    .complete 1016,1 --Divined Scroll
    .mob Lesser Water Elemental

step
    .goto Ashenvale,49.79,67.21
    >>Velene
    .turnin 1016 >> Turn in Elemental Bracers
    .target Sentinel Velene Starstrike

step
    .goto Ashenvale,36.61,49.58
    >>Raene closes the furbolg account
    .turnin 1025 >> Turn in An Aggressive Defense
    .target Raene Wolfrunner

step
    .goto Ashenvale,34.40,48.00
    .fly Auberdine >> Fly to Auberdine

step
    .isOnQuest 731
    .goto Darkshore,37.5,41.9
    >>Archaeologist Hollee by the inn pays the banked prospector favor
    .turnin 731 >> Turn in The Absent Minded Prospector
    .target Archaeologist Hollee

step
    .goto 1439/1,362.74,6434.58
    >>Terenthis: Volcor made it out of the cave
    .turnin 995 >> Turn in Escape Through Stealth
    .target Terenthis
step
    .goto 1439/1,542.99,6342.31
    >>Gwennyth: the beached creatures from Darkshore's southern coast
    .turnin 4732 >> Turn in Beached Sea Turtle
    .turnin 4733 >> Turn in Beached Sea Creature
    .target Gwennyth Bly'Leggonde
step
    #optional
    .isQuestComplete 1138
    .goto 1439/1,577.38,6371.35
    >>Gubber, if you finished the Fine Crab Chunks
    .turnin 1138 >> Turn in Fruit of the Sea
    .target Gubber Blump
step
    .goto Darkshore,32.4,43.9
    >>The southern pier: ride the boat across the sea
    .zone Wetlands >> Take the boat to Menethil Harbor
]])

-- ==================== 23-24 WETLANDS =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 23-24 Wetlands (Alliance)
#next 24-27 Redridge/Duskwood (Alliance)
<< Alliance

step << Druid
    #optional
    .isOnQuest 272
    .goto Wetlands,4.5,38.0
    >>DRUID: the other pendant half -- swim north from Menethil's docks along the coast toward Silverpine's southern shore and dive the sunken wrecks for the Half Pendant of Aquatic Endurance (aquatic creatures prowl the deep)
    .complete 272,2 --Half Pendant of Aquatic Endurance

step << Druid
    #optional
    .isQuestComplete 272
    >>With both halves: Teleport to Moonglade. Tajarri joins the pendant, Dendrite blesses it, and Mathrengyl in Darnassus grants AQUATIC FORM. Hearth back when it's done -- worth every step
    .goto 1450/1,-2678.74,8020.00
    .turnin 272 >> Turn in Trial of the Sea Lion
    .target Tajarri
    .target Dendrite Starblaze

step << Druid
    #optional
    .goto Moonglade,56.2,30.6
    >>Take Aquatic Form at Dendrite Starblaze
    .accept 5061,2,272 >> Accept Aquatic Form
    .target Dendrite Starblaze

step << Druid
    #optional
    .goto 1457/1,2564.03,10179.04
    >>Hand in Aquatic Form at Mathrengyl Bearwalker
    .turnin -5061 >> Turn in Aquatic Form
    .target Mathrengyl Bearwalker

step
    .goto Wetlands,8.31,58.53
    >>Menethil Harbor: Karl Boran by the gate
    .accept 279 >> Accept Claws from the Deep
    .target Karl Boran

step
    .goto Wetlands,8.6,55.8
    >>James Halloran
    .accept 484 >> Accept Young Crocolisk Skins
    .target James Halloran

step
    .goto Wetlands,10.8,59.6
    >>First Mate Fitzsimmons staggers by the inn
    .accept 288 >> Accept The Third Fleet
    .accept 463 >> Accept The Greenwarden
    .target First Mate Fitzsimmons

step
    .goto Wetlands,10.7,60.9
    >>Buy a Flagon of Mead inside the inn, and make this home
    .complete 288,1 --Flagon of Mead
    .home >> Set your Hearthstone to the Deepwater Tavern

step
    .goto Wetlands,10.8,59.7
    >>Fitzsimmons drinks
    .turnin 288 >> Turn in The Third Fleet
    .target First Mate Fitzsimmons

step
    .goto Wetlands,11.7,58.0
    >>Sida
    .accept 470 >> Accept Digging Through the Ooze
    .target Sida

step << !Human
    .goto Wetlands,9.95,57.6
    >>Valstag Ironjaw in Menethil Keep -- his war spoils lie around the harbor town itself: 6 Khaz Modan Timber, 30 Khaz Modan Iron (crates and piles)
    .accept 98197 >> Accept Spoils of War
    .target Valstag Ironjaw

step
    .goto Wetlands,9.9,57.4
    >>Captain Stoutfist upstairs in the keep
    .accept 464 >> Accept War Banners
    .accept 98230 >> Accept This Land Was Their Land
    .target Captain Stoutfist

step << !Human
    .goto 1437/0,-880.87,-3769.14
    >>Caitlin Grassman in town -- her gland hunt points at Thelgen Rock, the cave east (optional detour, flagged for later)
    .accept 98282 >> Accept Alchemical Hazards
    .target Caitlin Grassman

step << !Human
    .goto Wetlands,9.5,59.0,30,0
    >>Sweep the town for Valstag's timber and iron as you walk -- crates by the docks, the smithy and the keep
    .goto Wetlands,11.0,57.0,30,0
    .complete 98197,1 --Khaz Modan Timber (6)
    .complete 98197,2 --Khaz Modan Iron (30)

step << !Human
    .goto Wetlands,9.95,57.6
    >>Valstag
    .turnin 98197 >> Turn in Spoils of War
    .target Valstag Ironjaw

step
    .goto Wetlands,11.50,52.13
    >>Tarrel Rockweaver at the town bridge
    .accept 305 >> Accept In Search of The Excavation Team
    .target Tarrel Rockweaver

step
    #sticky
    #completewith CrocsDone
    >>Young Wetlands Crocolisks between quests: 4 skins
    .complete 484,1 --Young Crocolisk Skin (4)
    .mob Young Wetlands Crocolisk

step
    .goto Wetlands,16.7,39.7,70,0
    >>The southern murloc camps: 12 Bluegills, and Gobbler patrolling among them
    .goto Wetlands,18.8,40.0
    .complete 279,2 --Gobbler's Head
    .complete 279,1 --Bluegill Murloc (12)
    .unitscan Gobbler
    .mob Bluegill Murloc

step
    .goto Wetlands,38.17,50.88
    >>East along the road to the Whelgar dig: Ormer Ironbraid on the overlook
    .accept 294 >> Accept Ormer's Revenge
    .target Ormer Ironbraid

step
    .goto Wetlands,38.8,52.3
    >>Merrin Rockweaver below
    .turnin 305 >> Turn in In Search of The Excavation Team
    .accept 306 >> Accept In Search of The Excavation Team
    .target Merrin Rockweaver

step << !Human
    .goto Wetlands,37.44,52.0
    >>Archaeologist Hollee again, relocated to the dig -- her note goes back to Tarrel
    .accept 98461 >> Accept Unrequited Love
    .target Archaeologist Hollee

step
    .goto Wetlands,44.8,43.9
    >>Dragonmaw orcs at Angerfang: 8 War Banners
    .complete 464,1 --Dragonmaw War Banner (8)
    .mob Dragonmaw Grunt
    .mob Dragonmaw Raider

step
    .goto Wetlands,49.91,39.36
    >>Einar Stonegrip at the toolshop
    .accept 469 >> Accept Daily Delivery
    .target Einar Stonegrip

step
    .goto Wetlands,49.4,42.0
    >>Howin Kindfeather camps off the road south
    .turnin 98230 >> Turn in This Land Was Their Land
    .accept 98245 >> Accept Razormaw Needling
    .target Howin Kindfeather

step << Warrior
    #optional
    .goto Wetlands,50.2,37.8
    >>The herb seller near Einar sometimes stocks Liferoot -- you'll want 8 for the Brutal Armor chain at 30
    .collect 3357,8 --Liferoot (8)

step
    .goto Wetlands,56.37,40.40
    >>Rethiel the Greenwarden in the Green Belt
    .turnin 463 >> Turn in The Greenwarden
    .accept 276 >> Accept Tramping Paws
    .target Rethiel the Greenwarden

step
    .goto Wetlands,63.9,62.7,70,0
    >>Mosshide camps southeast: 15 Gnolls, 10 Mongrels (more gnolls roam outside the camps)
    .goto Wetlands,55.7,75.1,70,0
    .complete 276,1 --Mosshide Gnoll (15)
    .complete 276,2 --Mosshide Mongrel (10)
    .mob Mosshide Gnoll
    .mob Mosshide Mongrel

step
    .goto Wetlands,56.4,40.3
    >>Rethiel
    .turnin 276 >> Turn in Tramping Paws
    .accept 277 >> Accept Fire Taboo
    .target Rethiel the Greenwarden

step
    #label CrocsDone
    .goto Wetlands,14.1,41.5,70,0
    >>Back toward town, finishing the 4 croc skins
    .complete 484,1 --Young Crocolisk Skin (4)
    .mob Young Wetlands Crocolisk

step
    .goto Wetlands,8.4,58.5
    >>Menethil: Karl Boran
    .turnin 279 >> Turn in Claws from the Deep
    .accept 281 >> Accept Reclaiming Goods
    .target Karl Boran

step
    .goto Wetlands,8.6,55.8
    >>Halloran
    .turnin 469 >> Turn in Daily Delivery
    .turnin 484 >> Turn in Young Crocolisk Skins
    .accept 471 >> Accept Apprentice's Duties
    .target James Halloran

step << !Human
    .goto Wetlands,11.50,52.17
    >>Tarrel, with Hollee's note
    .turnin 98461 >> Turn in Unrequited Love
    .target Tarrel Rockweaver

step
    .goto Wetlands,9.5,59.7
    .fly Stormwind >> Fly to Stormwind City
]])

-- ================= 24-27 REDRIDGE / DUSKWOOD =========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 24-27 Redridge/Duskwood (Alliance)
#next 27-30 Wetlands/Hillsbrad (Alliance)
<< Alliance

step << Warrior
    .goto 1453/0,324.37,-8689.38
    >>Stormwind first: train upstairs at the Command Center
    .trainer >> Train your class abilities

step << Rogue
    .goto 1453/0,362.28,-8815.23
    >>ROGUE: Master Mathias Shaw at SI:7 in Old Town has work that ends in poison
    .accept 2360 >> Accept Mathias and the Defias
    .target Master Mathias Shaw

step << Rogue
    .isOnQuest 2360
    .goto 1453/0,484.20,-8832.50
    >>Fly to Sentinel Hill, then ride southeast to the lone tower: Agent Kearnen watches Klaven's lair
    .fly Sentinel Hill >> Fly to Sentinel Hill
    .zoneskip Westfall

step << Rogue
    .isOnQuest 2360
    .goto Westfall,68.5,70.1
    >>Agent Kearnen at the lone tower southeast of Sentinel Hill
    .turnin 2360 >> Turn in Mathias and the Defias
    .accept 2359 >> Accept Klaven's Tower
    .target Agent Kearnen

step << Rogue
    .isOnQuest 2359
    .goto Westfall,69.5,70.5
    >>Stealth work: lift the Defias Tower Key from the guards (pickpocket), slip inside and up the tower, and open the Duskwood Chest. The watchers see through poor stealth -- move carefully
    .complete 2359,1 --Contents of the Duskwood Chest

step << Rogue
    .isQuestComplete 2359
    .goto 1453/0,362.28,-8815.23
    >>Fly back and report. Shaw's reward: POISONS -- visit the poison supplier beside SI:7 and learn your craft
    .turnin 2359 >> Turn in Klaven's Tower
    .target Master Mathias Shaw

step << Priest
    #optional
    .goto 1453/0,862.33,-8512.45
    >>PRIEST (20+): Laurena again -- humans learn Arcane Feedback here (dwarves: Rohan in Ironforge, the 37-38 chapter stops there)
    .turnin -5676 >> Turn in Arcane Feedback
    .turnin -5677 >> Turn in Arcane Feedback
    .target High Priestess Laurena

step << Mage
    #optional
    .goto 1453/0,861.81,-8989.69
    >>MAGE: Jennea's commissions -- hand in the Mirror Lake sample if you still carry it, then the Blue Recluse job (15+): clear the manifestations in the tavern next door for the Cantation and coffers. At 26 she refers you up the tower to Andromath
    .turnin -1861 >> Turn in Mirror Lake
    .turnin -1919 >> Turn in Report to Jennea
    .target Jennea Cannon

step << Mage
    #optional
    .goto 1453/0,861.81,-8989.69
    >>Take Investigate the Blue Recluse at Jennea Cannon
    .accept 1920,2,1919 >> Accept Investigate the Blue Recluse
    .target Jennea Cannon

step << Mage
    #optional
    .goto 1453/0,861.81,-8989.69
    >>Finish Investigate the Blue Recluse, then hand in Investigate the Blue Recluse at Jennea Cannon
    .complete -1920,1
    .turnin -1920 >> Turn in Investigate the Blue Recluse
    .target Jennea Cannon

step << Mage
    #optional
    .goto 1453/0,861.81,-8989.69
    >>Take Gathering Materials, High Sorcerer Andromath, Journey to the Marsh at Jennea Cannon
    .accept 1921,2,1920 >> Accept Gathering Materials
    .accept 1939,2,1939 >> Accept High Sorcerer Andromath
    .accept 1947,2,1947 >> Accept Journey to the Marsh
    .target Jennea Cannon

step << Mage
    #optional
    .isOnQuest 1921
    .goto 1453/0,822.20,-8963.16
    >>Wynne Larson tailors the Manaweave set: 10 Linen Cloth plus the Charged Rift Gems from the coffers
    .turnin -1921 >> Turn in Gathering Materials
    .target Wynne Larson

step << Mage
    #optional
    .goto 1453/0,822.20,-8963.16
    >>Take Manaweave Robe at Wynne Larson
    .accept 1941,2,1921 >> Accept Manaweave Robe
    .target Wynne Larson

step << Mage
    #optional
    .goto 1453/0,822.20,-8963.16
    >>Hand in Manaweave Robe at Wynne Larson
    .turnin -1941 >> Turn in Manaweave Robe
    .target Wynne Larson

step << Mage
    #optional
    .isOnQuest 1939
    .goto 1453/0,876.58,-9010.77
    >>High Sorcerer Andromath atop the Sanctum: his treatise errand (follow its pointer), then 8 Pristine Spider Silk -- Duskwood's spinners drop it as this chapter quests there
    .turnin -1939 >> Turn in High Sorcerer Andromath
    .target High Sorcerer Andromath

step << Mage
    #optional
    .goto 1453/0,876.58,-9010.77
    >>Take Ur's Treatise on Shadow Magic at High Sorcerer Andromath
    .accept 1938,2,1939 >> Accept Ur's Treatise on Shadow Magic
    .target High Sorcerer Andromath

step << Mage
    #optional
    .goto 1453/0,876.58,-9010.77
    >>Finish Ur's Treatise on Shadow Magic, then hand in Ur's Treatise on Shadow Magic at High Sorcerer Andromath
    .complete -1938,1
    .turnin -1938 >> Turn in Ur's Treatise on Shadow Magic
    .target High Sorcerer Andromath

step << Mage
    #optional
    .goto 1453/0,876.58,-9010.77
    >>Take Pristine Spider Silk at High Sorcerer Andromath
    .accept 1940,2,1938 >> Accept Pristine Spider Silk
    .target High Sorcerer Andromath

step << Mage
    #optional
    .isOnQuest 1940
    .goto 1453/0,822.20,-8963.16
    >>Wynne again, silk in hand: the Astral Knot set
    .complete -1940,1 --Pristine Spider Silk (8)
    .turnin -1940 >> Turn in Pristine Spider Silk
    .target Wynne Larson

step << Mage
    #optional
    .goto 1453/0,822.20,-8963.16
    >>Take Astral Knot Garment at Wynne Larson
    .accept 1942,2,1940 >> Accept Astral Knot Garment
    .target Wynne Larson

step << Mage
    #optional
    .goto 1453/0,822.20,-8963.16
    >>Hand in Astral Knot Garment at Wynne Larson
    .turnin -1942 >> Turn in Astral Knot Garment
    .target Wynne Larson

step << Warlock
    .goto 1453/0,1041.47,-8983.08
    >>WARLOCK: Gakin names your third demon -- Strahad Farsan of Ratchet holds the rite. Accept and carry it; the route reaches Ratchet by boat at 38
    .accept 1798 >> Accept Seeking Strahad
    .target Gakin the Darkbinder

step
    .goto 1433/0,-1906.40,-9606.80
    >>East through Elwynn into Redridge: Guard Parker at the crossroads
    .accept 244 >> Accept Encroaching Gnolls
    .target Guard Parker

step
    .goto 1433/0,-2232.94,-9435.06
    >>Lakeshire
    .fp Redridge >> Get the Redridge Mountains flight path

step
    .goto 1433/0,-2239.45,-9445.20
    >>Deputy Feldon on the dock -- he has new trouble of his own
    .turnin -244 >> Turn in Encroaching Gnolls
    .accept 98407 >> Accept Show of Force << !Human
    .target Deputy Feldon

step << !Human
    .goto 1433/0,-2156.96,-9487.19,40,0
    >>Redridge Thrashers around the lakeshore carry 5 Spiked Collars
    .complete 98407,1 --Spiked Collar (5)
    .mob Redridge Thrasher

step << !Human
    .goto 1433/0,-2239.45,-9445.20
    >>Feldon
    .turnin 98407 >> Turn in Show of Force
    .target Deputy Feldon

step << !Human
    .goto 1433/0,-2268.46,-9279.27
    >>Foreman Oslow by the bridge works
    .accept 98386 >> Accept Alther's Mill
    .target Foreman Oslow

step
    .goto 1433/0,-2295.89,-9285.93
    >>Marshal Marris
    .accept 20 >> Accept Blackrock Menace
    .accept 98387 >> Accept Blackrock Blockade << !Human
    .target Marshal Marris

step
    .goto 1433/0,-2213.40,-9216.43
    >>Bailiff Conacher in the town hall
    .accept 91 >> Accept Solomon's Law
    .target Bailiff Conacher

step
    .goto 1433/0,-2172.59,-9261.02
    >>Dockmaster Baren
    .accept 127 >> Accept Selling Fish
    .accept 150 >> Accept Murloc Poachers
    .target Dockmaster Baren

step << !Human
    .goto 1433/0,-2569.12,-9536.42
    >>Alther's Mill south of the lake: 12 Greater Tarantulas, 6 Tarantula Eggs among the timbers
    .complete 98386,1 --Greater Tarantula (12)
    .complete 98386,2 --Tarantula Eggs (6)
    .mob Greater Tarantula

step << Warrior
    .isOnQuest 1698
    .goto 1433/0,-2147.76,-9222.51
    >>WARRIOR: Yorus Barleybrew by the Lakeshire dock takes Wu Shen's referral. His gauntlet: run INTO Rethban Caverns northwest, touch the first fork, sprint back before the brew sours -- clear nothing, just run. The cask he hands you goes to Furen Longbeard in Stormwind (the 30-32 chapter opens there)
    .turnin -1698 >> Turn in Yorus Barleybrew
    .target Yorus Barleybrew

step << Warrior
    .goto 1433/0,-2147.76,-9222.51
    >>Take The Rethban Gauntlet at Yorus Barleybrew
    .accept 1699,2,1698 >> Accept The Rethban Gauntlet
    .target Yorus Barleybrew

step << Warrior
    .goto 1433/0,-2147.76,-9222.51
    >>The gauntlet run, then hand in The Rethban Gauntlet at Yorus Barleybrew
    .complete -1699,1 --The gauntlet run
    .turnin -1699 >> Turn in The Rethban Gauntlet
    .target Yorus Barleybrew

step << Warrior
    .goto 1433/0,-2147.76,-9222.51
    >>Take The Shieldsmith at Yorus Barleybrew
    .accept 1702,2,1699 >> Accept The Shieldsmith
    .target Yorus Barleybrew

step
    .goto 1433/0,-2895.04,-9199.05,50,0
    >>Blackrock camps east: 10 Battleworn Axes -- and the Stolen Weapons and Blackrock Supplies for Marris lie in the same camps << !Human
    .goto 1433/0,-2918.63,-9154.17,50,0
    .complete 20,1 --Battleworn Axe (10)
    .complete 98387,1 --Stolen Weapons (8) << !Human
    .complete 98387,2 --Blackrock Supplies (10) << !Human
    .mob Blackrock Grunt
    .mob Blackrock Outrunner

step
    .goto 1433/0,-2814.72,-9333.71
    >>Lake murlocs: 10 Spotted Sunfish and 8 Murloc Fins
    .complete 127,1 --Spotted Sunfish (10)
    .collect 1468,8,150 --Murloc Fin (8)
    .mob Murloc Flesheater
    .mob Murloc Minor Tidecaller

step << !Human
    .goto 1433/0,-2268.46,-9279.27
    >>Oslow
    .turnin 98386 >> Turn in Alther's Mill
    .target Foreman Oslow

step
    .goto 1433/0,-2300.23,-9280.14
    >>Marris
    .turnin 20 >> Turn in Blackrock Menace
    .turnin 98387 >> Turn in Blackrock Blockade << !Human
    .target Marshal Marris

step
    .goto 1433/0,-2174.32,-9261.31
    >>Baren
    .turnin 127 >> Turn in Selling Fish
    .turnin 150 >> Turn in Murloc Poachers
    .target Dockmaster Baren

step
    .goto 1433/0,-2150.45,-9248.28
    >>The wanted poster outside the inn
    .accept 180 >> Accept Wanted: Lieutenant Fangore

step
    .goto 1433/0,-2045.16,-9245.67
    >>Martie Jainrose at the flower garden
    .accept 34 >> Accept An Unwelcome Guest
    .target Martie Jainrose

step
    .goto 1433/0,-1911.65,-9290.27
    >>Bellygrub roots west of town
    .complete 34,1 --Bellygrub's Tusk
    .mob Bellygrub

step
    .goto 1433/0,-2044.07,-9246.83
    >>Martie
    .turnin 34 >> Turn in An Unwelcome Guest
    .target Martie Jainrose

step
    .goto Duskwood,75.7,45.3
    >>South into Duskwood, to Darkshire: Madame Eva
    .accept 66 >> Accept The Legend of Stalvan
    .accept 101 >> Accept The Totem of Infliction
    .target Madame Eva

step
    .goto Duskwood,73.6,46.8
    >>Commander Althea Ebonlocke
    .accept 56 >> Accept The Night Watch
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,72.6,46.9
    >>Clerk Daltry
    .turnin 66 >> Turn in The Legend of Stalvan
    .accept 67 >> Accept The Legend of Stalvan
    .target Clerk Daltry

step << !Human
    .goto Duskwood,72.64,47.61
    >>Sirra Von'Indi, the town historian
    .accept 96139 >> Accept The Valor Family
    .target Sirra Von'Indi

step
    .goto Duskwood,75.3,48.6
    >>Elaine Carevin
    .accept 163 >> Accept Raven Hill
    .accept 164 >> Accept Deliveries to Sven
    .accept 165 >> Accept The Hermit
    .target Elaine Carevin

step
    .goto Duskwood,75.4,48.0
    >>Calor
    .accept 173 >> Accept Worgen in the Woods
    .target Calor

step
    .goto Duskwood,79.8,47.9
    >>Viktori Prism'Antras wants a Bronze Tube -- buy one from Herble Baubbletump next door (limited stock), the auction house, or an engineer
    .collect 4371,1,175 --Bronze Tube
    .accept 174 >> Accept Look To The Stars
    .turnin 174 >> Turn in Look To The Stars
    .accept 175 >> Accept Look To The Stars
    .target Viktori Prism'Antras

step
    #sticky
    >>An Old History Book drops from anything in Duskwood -- read it when it does
    .collect 2794,1,337
    .accept 337 >> Accept An Old History Book
    .use 2794

step
    .goto Duskwood,82.0,59.0
    >>Blind Mary at the haunted house
    .turnin 175 >> Turn in Look To The Stars
    .accept 177 >> Accept Look To The Stars
    .target Blind Mary

step
    .goto Duskwood,80.9,71.8
    >>The Insane Ghoul haunts the chapel south (he wanders outside too)
    .complete 177,1 --Mary's Looking Glass
    .unitscan Insane Ghoul

step
    .goto Duskwood,79.3,70.3
    >>Skeletons around the chapel grounds: 8 Warriors, 6 Mages
    .complete 56,1 --Skeletal Warrior (8)
    .complete 56,2 --Skeletal Mage (6)
    .mob Skeletal Warrior
    .mob Skeletal Mage

step
    .goto Duskwood,18.4,56.6
    >>The long road west to Raven Hill: Jitters shakes in the ruined house
    .turnin 163 >> Turn in Raven Hill
    .accept 5 >> Accept Jitters' Growling Gut
    .target Jitters

step << !Human
    .goto Duskwood,17.8,55.6
    >>Search the Raven Hill buildings for traces of the Valor family
    .complete 96139,1 --Search Raven Hill

step
    .goto Duskwood,7.78,34.06
    >>Northwest to Sven's camp
    .turnin 164 >> Turn in Deliveries to Sven
    .accept 95 >> Accept Sven's Revenge
    .target Sven Yorgen

step
    .goto Duskwood,7.7,33.3
    >>Lars beside him
    .accept 226 >> Accept Wolves at Our Heels
    .target Lars

step
    .goto Duskwood,28.0,31.5
    >>Abercrombie the hermit at the shack
    .turnin 165 >> Turn in The Hermit
    .accept 148 >> Accept Supplies from Darkshire
    .target Abercrombie

step
    .goto Duskwood,17.6,24.6
    >>Dire wolves along the north ridge: 12 Starving, 8 Rabid
    .complete 226,1 --Starving Dire Wolf (12)
    .complete 226,2 --Rabid Dire Wolf (8)
    .mob Starving Dire Wolf
    .mob Rabid Dire Wolf

step
    .goto Duskwood,17.7,29.1
    >>The weathered grave on the hill
    .accept 225 >> Accept The Weathered Grave

step
    .goto Duskwood,60.8,29.7
    >>Grind east along the Darkshire treeline: 6 Nightbane Shadow Weavers (skip for now if they chew through you -- a later pass covers them)
    .complete 173,1 --Nightbane Shadow Weaver (6)
    .mob Nightbane Shadow Weaver

step
    .goto Duskwood,73.8,43.3
    >>Darkshire: Chef Grual
    .turnin 5 >> Turn in Jitters' Growling Gut
    .accept 93 >> Accept Dusky Crab Cakes
    .target Chef Grual

step
    #sticky
    #completewith SpiderLegs
    >>Duskwood spiders drop 6 Gooey Spider Legs for the chef
    .complete 93,1 --Gooey Spider Leg (6)

step
    .goto Duskwood,73.6,46.8
    >>Althea
    .turnin 56 >> Turn in The Night Watch
    .accept 57 >> Accept The Night Watch
    .target Commander Althea Ebonlocke

step
    #label DarkshireRound2
    .goto Duskwood,72.64,47.61
    >>Sirra Von'Indi: the grave's story, and the Valor search
    .turnin 225 >> Turn in The Weathered Grave
    .accept 227 >> Accept Morgan Ladimore
    .turnin 96139 >> Turn in The Valor Family << !Human
    .target Sirra Von'Indi

step
    .goto Duskwood,73.5,46.9
    >>Althea reads Morgan's story
    .turnin 227 >> Turn in Morgan Ladimore
    .accept 228 >> Accept Mor'Ladim
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,75.7,45.3
    >>Eva
    .turnin 148 >> Turn in Supplies from Darkshire
    .accept 149 >> Accept Ghost Hair Thread
    .target Madame Eva

step
    .goto Duskwood,75.3,47.9
    >>Calor
    .turnin 173 >> Turn in Worgen in the Woods
    .accept 221 >> Accept Worgen in the Woods
    .target Calor

step
    .goto Duskwood,79.8,47.8
    >>Viktori, glass in hand
    .turnin 177 >> Turn in Look To The Stars
    .accept 181 >> Accept Look To The Stars
    .target Viktori Prism'Antras

step
    .goto Duskwood,81.9,59.1
    >>Mary
    .turnin 149 >> Turn in Ghost Hair Thread
    .accept 154 >> Accept Return the Comb
    .target Blind Mary

step
    .goto Duskwood,75.7,45.3
    >>Eva
    .turnin 154 >> Turn in Return the Comb
    .accept 157 >> Accept Deliver the Thread
    .target Madame Eva

step
    .goto Duskwood,49.9,77.8
    >>The Dawning Wood Catacombs entrance south: Sven's evidence
    .turnin 95 >> Turn in Sven's Revenge
    .accept 230 >> Accept Sven's Camp

step
    .goto Duskwood,28.0,31.5
    >>Abercrombie
    .turnin 157 >> Turn in Deliver the Thread
    .accept 158 >> Accept Zombie Juice
    .target Abercrombie

step
    .goto Duskwood,7.78,34.06
    >>Sven
    .turnin 230 >> Turn in Sven's Camp
    .accept 262 >> Accept The Shadowy Figure
    .target Sven Yorgen

step
    .goto Duskwood,7.7,33.3
    >>Lars
    .turnin 226 >> Turn in Wolves at Our Heels
    .target Lars

step
    .goto Westfall,41.5,66.8
    >>Cut west past Raven Hill into Westfall: Stalvan's trail runs through the Moonbrook schoolhouse
    .turnin 67 >> Turn in The Legend of Stalvan
    .accept 68 >> Accept The Legend of Stalvan

step
    .goto Duskwood,75.7,45.3
    >>Darkshire again: Eva, Daltry, the inn
    .turnin 262 >> Turn in The Shadowy Figure
    .accept 265 >> Accept The Shadowy Search Continues
    .target Madame Eva

step
    .goto Duskwood,72.6,46.9
    >>Hand in The Shadowy Search Continues; take Inquire at the Inn; hand in The Legend of Stalvan; take The Legend of Stalvan at Clerk Daltry
    .turnin -265 >> Turn in The Shadowy Search Continues
    .accept 266,2,265 >> Accept Inquire at the Inn
    .turnin -68 >> Turn in The Legend of Stalvan
    .accept 69,2,68 >> Accept The Legend of Stalvan
    .target Clerk Daltry

step
    .goto Duskwood,73.9,44.4
    >>Tavernkeep Smitts
    .turnin 158 >> Turn in Zombie Juice
    .accept 156 >> Accept Gather Rot Blossoms
    .turnin -266 >> Turn in Inquire at the Inn
    .accept 453,2,266 >> Accept Finding the Shadowy Figure
    .target Tavernkeep Smitts

step
    #optional
    .isOnQuest 93
    .goto 1430/0,-1019.95,-10111.77
    >>Still short on Gooey Spider Leg? Black Widow Hatchling / Carrion Recluse / Cave Stalker -- around here. This step skips itself once you have them
    .complete 93,1 --Gooey Spider Leg (6)
    .mob Black Widow Hatchling
    .mob Carrion Recluse
    .mob Cave Stalker
    .mob Chatter

step
    #label SpiderLegs
    .goto Duskwood,73.9,43.9
    >>Grual fries the legs
    .turnin 93 >> Turn in Dusky Crab Cakes
    .accept 240 >> Accept Return to Jitters
    .target Chef Grual

step
    .goto Duskwood,77.5,44.3
    .fly Redridge >> Fly back to Redridge

step
    .goto 1433/0,-2255.30,-9412.62
    >>Guard Howe by the bridge
    .accept 128 >> Accept Blackrock Bounty
    .target Guard Howe

step
    .goto 1433/0,-2298.06,-9287.37
    >>Marris escalates the war (Humans: if he won't offer these two, skip the pair -- their prerequisite chain differs per race)
    .accept 19 >> Accept Tharil'zun
    .accept 115 >> Accept Shadow Magic
    .target Marshal Marris

step
    .goto 1433/0,-3314.01,-9113.62
    >>Far east: Lieutenant Fangore, ringed by patrolling gnolls -- pull him clear, he social-aggros the camp
    .complete 180,1 --Fangore's Paw
    .mob Lieutenant Fangore

step
    .isOnQuest 94
    .goto 1433/0,-3400.85,-9254.07
    >>The watchtower pays the banked Watchful Eye
    .turnin 94 >> Turn in A Watchful Eye
    .accept 248 >> Accept Looking Further

step
    .goto 1433/0,-3181.59,-9184.57
    >>Shadowhide gnolls on the ridge: 10 Pendants
    .complete 91,1 --Shadowhide Pendant (10)
    .mob Shadowhide Gnoll
    .mob Shadowhide Darkweaver

step
    .goto 1433/0,-3073.05,-9440.85
    >>Tharil'zun commands from the southern camp
    .complete 19,1 --Tharil'zun's Head
    .mob Tharil'zun

step
    .goto 1433/0,-3016.61,-9377.15
    >>Blackrock Shadowcasters: 3 Midnight Orbs
    .complete 115,1 --Midnight Orb (3)
    .mob Blackrock Shadowcaster

step
    .isOnQuest 248
    .goto 1433/0,-2942.80,-9294.61
    >>Climb the ruined tower
    .turnin 248 >> Turn in Looking Further

step
    .isOnQuest 128
    .goto 1433/0,-2282.87,-8673.46
    >>The far northern camps: 15 Blackrock Champions for Howe's bounty
    .complete 128,1 --Blackrock Champion (15)
    .mob Blackrock Champion

step
    .goto 1433/0,-2298.06,-9283.90
    >>Lakeshire turn-ins: Marris, Conacher, Solomon, Howe
    .turnin 19 >> Turn in Tharil'zun
    .turnin 115 >> Turn in Shadow Magic
    .target Marshal Marris

step
    .goto 1433/0,-2213.40,-9216.43
    >>Hand in Solomon's Law at Bailiff Conacher
    .turnin -91 >> Turn in Solomon's Law
    .target Bailiff Conacher

step
    .goto 1433/0,-2217.74,-9219.32
    >>Hand in WANTED: Lieutenant Fangore at Magistrate Solomon
    .turnin -180 >> Turn in Wanted: Lieutenant Fangore
    .target Magistrate Solomon

step
    .goto 1433/0,-2256.82,-9414.79
    >>Hand in Blackrock Bounty at Guard Howe
    .turnin -128 >> Turn in Blackrock Bounty
    .target Guard Howe

step
    .goto 1433/0,-2232.94,-9433.61
    .fly Sentinel >> Fly to Sentinel Hill, then ride east into western Duskwood

step
    .goto Duskwood,21.6,45.1
    >>The Raven Hill cemetery: Skeletal Fiends and Horrors 15 deep each, Rot Blossoms and Skeleton Fingers off the dead
    .complete 57,1 --Skeletal Fiend (15)
    .complete 57,2 --Skeletal Horror (15)
    .complete 156,1 --Rot Blossom (8)
    .complete 101,3 --Skeleton Finger (10)
    .mob Skeletal Fiend
    .mob Skeletal Horror

step
    .goto Duskwood,18.4,56.5
    >>Jitters
    .turnin -453 >> Turn in Finding the Shadowy Figure
    .accept 268,2,453 >> Accept Return to Sven
    .turnin 240 >> Turn in Return to Jitters
    .target Jitters

step
    .goto Duskwood,7.7,34.1
    >>Sven
    .turnin -268 >> Turn in Return to Sven
    .accept 323,2,268 >> Accept Proving Your Worth
    .target Sven Yorgen

step
    .goto Duskwood,16.2,38.8
    >>The crypt hill: 15 Skeletal Raiders outside, 3 Healers and 3 Warders inside the crypt
    .complete -323,1 --Skeletal Raider (15)
    .complete -323,2 --Skeletal Healer (3)
    .complete -323,3 --Skeletal Warder (3)
    .mob Skeletal Raider
    .mob Skeletal Healer
    .mob Skeletal Warder

step
    #optional
    .goto Duskwood,19.7,39.7
    >>Mor'Ladim stalks the cemetery -- a level 30 ELITE. Kite through the big trees when he enrages, group up, or come back at the end of the chunk
    .complete 228,1 --Mor'Ladim's Skull
    .unitscan Mor'Ladim

step
    .goto Duskwood,7.9,34.1
    >>Sven
    .turnin -323 >> Turn in Proving Your Worth
    .accept 269,2,323 >> Accept Seeking Wisdom
    .target Sven Yorgen

step
    .goto Elwynn Forest,43.7,65.9
    >>North to Goldshire: Innkeeper Farley remembers the name
    .turnin -69 >> Turn in The Legend of Stalvan
    .accept 70,2,69 >> Accept The Legend of Stalvan
    .target Innkeeper Farley

step
    .goto Elwynn Forest,44.2,65.9
    >>Upstairs behind the rogue trainer: the chest holds the undelivered letter
    .complete -70,1 --An Undelivered Letter

step << Warrior
    .goto Elwynn Forest,41.08,65.76
    >>Lyria trains warriors by the forge
    .trainer >> Train your class abilities

step
    .goto 1453/0,1026.08,-8981.59
    >>Stormwind: Zardeth of the Black Claw in the Slaughtered Lamb basement
    .accept 335 >> Accept A Noble Brew
    .target Zardeth of the Black Claw

step
    .goto 1453/0,980.38,-8832.80
    >>Caretaker Folsom in the cemetery
    .turnin -70 >> Turn in The Legend of Stalvan
    .accept 72,2,70 >> Accept The Legend of Stalvan
    .turnin 72 >> Turn in The Legend of Stalvan
    .accept 74 >> Accept The Legend of Stalvan
    .target Caretaker Folsom

step
    .goto 1453/0,832.51,-8554.93
    >>Brother Sarno at the cathedral
    .accept 2923 >> Accept Tinkmaster Overspark
    .target Brother Sarno

step
    .goto 1453/0,852.67,-8529.83
    >>Bishop Farthing inside
    .turnin -269 >> Turn in Seeking Wisdom
    .accept 270,2,269 >> Accept The Doomed Fleet
    .target Bishop Farthing

step
    .goto 1453/0,522.12,-8352.80,40,0
    >>The Deeprun Tram to Ironforge
    .zone Ironforge >> Ride the tram to Ironforge

step
    #optional
    .isOnQuest 968
    .goto Ironforge,50.8,5.6
    >>Found the Book: The Powers Below in Darkshore? Gerrig Bonegrip in the Forlorn Cavern (north end of the city) takes it
    .turnin 968 >> Turn in The Powers Below
    .target Gerrig Bonegrip

step
    #optional
    .isQuestComplete 96393
    .goto Ironforge,39.3,55.9
    >>Ran the Hall of Thanes? King Magni in the High Seat takes Durgen Dirgehammer's head
    .turnin 96393 >> Turn in Old Ironforge Incursion
    .target King Magni Bronzebeard

step
    .goto Ironforge,69.8,50.1
    >>Tinkmaster Overspark in Tinker Town
    .turnin 2923 >> Turn in Tinkmaster Overspark
    .target Tinkmaster Overspark

step << Warrior
    .goto Ironforge,61.34,89.25
    >>Bixi and Buliwyf in the Hall of Arms
    .train 197 >> Train Two-Handed Axes
    .train 199 >> Train Two-Handed Maces
    .target Buliwyf Stonehand

step << Paladin
    .goto Dun Morogh,52.5,36.9
    >>PALADIN: Jordan Stilwell works his anvil just outside Ironforge's front gate
    >>His list has four pieces: Bailor's shipment (we grab it now), the Kor Gem (routed at 27), Whitestone Oak Lumber (Goblin Woodcarvers in THE DEADMINES), and Jordan's Smithing Hammer (a chest in SHADOWFANG KEEP) -- line up those two dungeon runs when you can
    .turnin 1653 >> Turn in The Test of Righteousness
    .accept 1654 >> Accept The Test of Righteousness
    .target Jordan Stilwell

step << Paladin
    .goto Ironforge,56.2,46.8
    .fly Thelsamar >> Fly to Thelsamar in Loch Modan

step << Paladin
    .goto Loch Modan,35.9,44.9
    >>Bailor Stonehand in Thelsamar
    .accept 1655 >> Accept Bailor's Ore Shipment
    .target Bailor Stonehand

step << Paladin
    .goto Loch Modan,71.6,21.6
    >>Mo'grosh Stronghold, northeast around the lake: fight through the ogres to the crates and take Jordan's Ore Shipment
    .complete 1655,1 --Jordan's Ore Shipment
    .mob Mo'grosh Ogre

step << Paladin
    .goto Loch Modan,35.9,44.9
    >>Back to Bailor -- he refines it on the spot
    .turnin 1655 >> Turn in Bailor's Ore Shipment
    .target Bailor Stonehand

step << Paladin
    .goto Loch Modan,33.9,51.0
    .fly Wetlands >> Fly to Menethil Harbor

step
    .goto Ironforge,56.2,46.8
    .fly Wetlands >> Fly to Menethil Harbor
]])

-- ================= 27-30 WETLANDS / HILLSBRAD ========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 27-30 Wetlands/Hillsbrad (Alliance)
#next 30-32 Stormwind/Duskwood (Alliance)
<< Alliance

step
    .goto Wetlands,10.8,59.6
    >>Menethil: Fitzsimmons has a darker errand now
    .accept 289 >> Accept The Cursed Crew
    .target First Mate Fitzsimmons

step
    .goto Wetlands,10.6,60.5
    >>Glorin Steelbrow in the inn
    .turnin -270 >> Turn in The Doomed Fleet
    .accept 321,2,270 >> Accept Lightforge Iron
    .target Glorin Steelbrow

step
    .goto Wetlands,10.9,55.9
    >>Harlo Barnaby by the keep
    .accept 472 >> Accept Fall of Dun Modr
    .target Harlo Barnaby

step
    .goto Wetlands,9.9,57.4
    >>Captain Stoutfist
    .turnin 464 >> Turn in War Banners
    .accept 465 >> Accept Nek'rosh's Gambit
    .target Captain Stoutfist

step
    .goto Wetlands,11.50,52.17
    >>Tarrel at the bridge
    .turnin 306 >> Turn in In Search of The Excavation Team
    .target Tarrel Rockweaver

step << Paladin
    #optional
    .goto Wetlands,4.9,56.7
    >>PALADIN side trip for the Kor Gem (~25 min, skippable -- fold it into your dungeon-piece errands later if you prefer): take the boat from the long dock to Auberdine
    .zone Darkshore >> Boat to Auberdine

step << Paladin
    #optional
    .goto Darkshore,37.4,40.1
    >>Thundris Windweaver in Auberdine
    .accept 1442 >> Accept Seeking the Kor Gem
    .target Thundris Windweaver

step << Paladin
    #optional
    .goto Darkshore,31.5,91.8
    >>Ride to Darkshore's far southern shore: the Blackfathom naga there carry Corrupted Kor Gems
    .complete 1442,1 --Corrupted Kor Gem
    .mob Blackfathom Tide Priestess
    .mob Blackfathom Oracle

step << Paladin
    #optional
    .goto Darkshore,37.4,40.1
    >>Thundris purifies the gem
    .turnin 1442 >> Turn in Seeking the Kor Gem
    .target Thundris Windweaver

step << Paladin
    #optional
    .goto Darkshore,32.4,43.9
    .zone Wetlands >> Boat back to Menethil Harbor

step << Paladin
    #optional
    .goto Dun Morogh,52.5,36.9
    >>FINALE, once all four pieces are in your bags: Jordan Stilwell outside Ironforge, any time you pass. Hand everything over
    .turnin 1654 >> Turn in The Test of Righteousness
    .accept 1806 >> Accept The Test of Righteousness
    .target Jordan Stilwell

step << Paladin
    #optional
    .goto Dun Morogh,52.5,36.9
    >>A few minutes at the anvil and Verigan's Fist is yours -- few weapons touch it at this level
    .turnin 1806 >> Turn in The Test of Righteousness
    .target Jordan Stilwell

step
    .goto Wetlands,13.5,41.5
    >>The flotsam south of the murloc camps: Boran's crate...
    .turnin 281 >> Turn in Reclaiming Goods
    .accept 284 >> Accept The Search Continues

step
    .goto Wetlands,13.5,38.4
    >>...the second hovel...
    .turnin -284 >> Turn in The Search Continues
    .accept 285,2,284 >> Accept Search More Hovels

step
    .goto Wetlands,13.9,34.8
    >>...and the third
    .turnin -285 >> Turn in Search More Hovels
    .accept 286,2,285 >> Accept Return the Statuette

step
    .goto Wetlands,13.9,30.4
    >>The sunken fleet: enter the hull through the hole by the shore -- 13 Cursed Sailors, 5 Marines, and Snellig's snuffbox below deck (the northern wreck has more Marines)
    .complete 289,3 --Snellig's Snuffbox
    .complete 289,1 --Cursed Sailor (13)
    .complete 289,2 --Cursed Marine (5)
    .mob Cursed Sailor
    .mob Cursed Marine

step
    .goto Wetlands,17.6,59.9
    >>Giant Crocolisks up the coast: 6 skins
    .complete 471,1 --Giant Crocolisk Skin (6)
    .mob Giant Wetlands Crocolisk

step
    #sticky
    #completewith Incisors2
    >>Razormaw raptors at the dig drop Howin's 10 incisors if any are still missing
    .complete 98245,1 --Razormaw Incisor (10)

step
    .goto Wetlands,24.7,48.6
    >>The raptor highlands: 10 Mottled Raptors, 10 Screechers
    .complete 294,1 --Mottled Raptor (10)
    .complete 294,2 --Mottled Screecher (10)
    .mob Mottled Raptor
    .mob Mottled Screecher

step
    .goto Wetlands,38.17,50.88
    >>Ormer at the dig
    .turnin 294 >> Turn in Ormer's Revenge
    .accept 295 >> Accept Ormer's Revenge
    .target Ormer Ironbraid

step
    .goto Wetlands,38.81,52.39
    >>Prospector Whelgar below
    .accept 299 >> Accept Uncovering the Past
    .accept 98216 >> Accept Understanding Our Present << !Human
    .target Prospector Whelgar

step
    #sticky
    #label Relics
    .goto Wetlands,34.3,49.5,60,0
    >>Four relics lie around the dig pit -- gather them as you fight
    .complete 299,1 --Ancient Relic
    .complete 299,2 --Ancient Relic
    .complete 299,3 --Ancient Relic
    .complete 299,4 --Ancient Relic

step << !Human
    #optional
    .goto Wetlands,35.0,50.5
    >>Use Whelgar's Goaz Stone near the Goaz Warder in the excavation and take its Titanic Keystone
    .complete 98216,1 --Titanic Keystone
    .target Goaz Warder

step
    .goto Wetlands,34.6,48.0
    >>Deeper in: 10 Mottled Scytheclaws, 10 Razormaws
    .complete 295,1 --Mottled Scytheclaw (10)
    .complete 295,2 --Mottled Razormaw (10)
    .mob Mottled Scytheclaw
    .mob Mottled Razormaw

step
    .goto Wetlands,38.17,50.88
    >>Ormer
    .turnin 295 >> Turn in Ormer's Revenge
    .accept 296 >> Accept Ormer's Revenge
    .target Ormer Ironbraid

step
    .goto Wetlands,33.3,51.5
    >>Sarltooth crowns the hill -- he Thrashes, keep your health up
    .complete 296,1 --Sarltooth's Talon
    .mob Sarltooth

step
    #optional
    .isOnQuest 299
    .goto 1437/0,-1836.98,-3468.16
    >>Still short on Ados Fragment, Modr Fragment, Golm Fragment, Neru Fragment? Ancient Relic / Loose Soil -- around here. This step skips itself once you have them
    .complete 299,1 --Ancient Relic
    .complete 299,2 --Ancient Relic
    .complete 299,3 --Ancient Relic
    .complete 299,4 --Ancient Relic

step
    #requires Relics
    .goto Wetlands,38.17,50.88
    >>Ormer and Whelgar close the dig's accounts
    .turnin 296 >> Turn in Ormer's Revenge
    .target Ormer Ironbraid

step
    .goto Wetlands,38.81,52.39
    >>Hand in Uncovering the Past, Understanding Our Present at Prospector Whelgar
    .turnin -299 >> Turn in Uncovering the Past
    .turnin -98216 >> Turn in Understanding Our Present << !Human
    .target Prospector Whelgar

step
    #optional
    .isOnQuest 98245
    .goto 1437/0,-3229.79,-3010.35
    >>Still short on Razormaw Incisor? Elder Razormaw / Highland Razormaw -- around here. This step skips itself once you have them
    .complete 98245,1 --Razormaw Incisor (10)
    .mob Elder Razormaw
    .mob Highland Razormaw

step
    #label Incisors2
    .goto Wetlands,49.4,42.0
    >>Howin takes the incisors
    .turnin 98245 >> Turn in Razormaw Needling
    .target Howin Kindfeather

step
    .goto Wetlands,44.2,25.8
    >>Slimes around the lost crypt north: Sida's Bag is in their ooze
    .complete 470,1 --Sida's Bag
    .mob Monstrous Ooze

step << !Human
    #optional
    .goto Wetlands,49.7,60.9
    >>Thelgen Rock, the cave south: an Unruptured Stalker Gland for Caitlin
    .complete 98282,1 --Unruptured Stalker Gland
    .mob Cave Stalker

step
    .goto Wetlands,44.2,33.9
    >>Mosshide gnolls by Angerfang: 9 Crude Flints
    .complete 277,1 --Crude Flint (9)
    .mob Mosshide Fenrunner
    .mob Mosshide Trapper

step
    .goto Wetlands,56.3,40.5
    >>Rethiel
    .turnin 277 >> Turn in Fire Taboo
    .accept 275 >> Accept Blisters on The Land
    .target Rethiel the Greenwarden

step
    #sticky
    #completewith FenDone
    >>Fen Creepers lurk half-seen along the river: 8
    .complete 275,1 --Fen Creeper (8)
    .mob Fen Creeper

step
    .goto Wetlands,47.3,46.9
    >>The Dragonmaw siegeworks: Stoutfist's man waits at the edge
    .turnin 465 >> Turn in Nek'rosh's Gambit
    .accept 474 >> Accept Defeat Nek'rosh

step
    .goto Wetlands,53.5,54.6
    >>Chieftain Nek'rosh preaches from the catapult platform -- take his head
    .complete 474,1 --Nek'rosh's Head
    .mob Chieftain Nek'rosh

step
    .goto Wetlands,64.8,75.3
    >>The waterfall far southeast: the Musquash Root grows at its base
    .complete 335,2 --Musquash Root

step
    #optional
    .isOnQuest 275
    .goto 1437/0,-2663.24,-3172.14
    >>Still short on Fen Creeper? Fen Creeper -- around here. This step skips itself once you have them
    .complete 275,1 --Fen Creeper (8)
    .mob Fen Creeper

step
    #label FenDone
    .goto Wetlands,56.4,40.5
    >>Finish the Fen Creepers along the streams, then Rethiel
    .complete 275,1 --Fen Creeper (8)
    .turnin 275 >> Turn in Blisters on The Land
    .mob Fen Creeper
    .target Rethiel the Greenwarden

step
    .goto Wetlands,49.9,18.3
    >>North to the Dun Modr front: the Garmason camp
    .turnin -472 >> Turn in Fall of Dun Modr
    .accept 631 >> Accept The Thandol Span
    .target Rhag Garmason
    .accept 304 >> Accept A Grim Task
    .target Longbraid the Grim
    .accept 303 >> Accept The Dark Iron War
    .target Motley Garmason

step
    .goto Wetlands,50.05,18.17
    >>Ashlan Stonesmirk beside them
    .accept 88756 >> Accept Bring Back a Bang
    .target Ashlan Stonesmirk

step
    #sticky
    #completewith DarkIronDone
    >>Balgaras the Foul spawns in Dun Modr's houses or the camp far east -- his ear is the Grim Task
    .complete 304,1 --Ear of Balgaras
    .unitscan Balgaras the Foul

step
    .goto Wetlands,47.3,16.6
    >>Dun Modr: Dark Irons die by the dozen -- 10 Dwarves, 5 Tunnelers, 5 Saboteurs, 5 Demolitionists -- and 3 Stolen Explosives sit in their camps
    .complete 303,1 --Dark Iron Dwarf (10)
    .complete 303,2 --Dark Iron Tunneler (5)
    .complete 303,3 --Dark Iron Saboteur (5)
    .complete 303,4 --Dark Iron Demolitionist (5)
    .complete 88756,1 --Stolen Explosives (3)
    .mob Dark Iron Dwarf
    .mob Dark Iron Tunneler
    .mob Dark Iron Saboteur
    .mob Dark Iron Demolitionist

step
    .goto 1437/0,-2275.33,-2605.45
    >>A Captive Fire Elemental smolders in a Dun Modr cage -- walk it out to freedom (it ends at Roggo by the camp)
    .accept 87491 >> Accept Spark of Freedom
    .target Captive Fire Elemental

step
    .goto Wetlands,47.5,17.0
    >>Escort the captive elemental
    .complete -87491,1 --Escort the captive elemental

step
    #optional
    .isOnQuest 304
    .goto 1437/0,-2415.94,-2561.35
    >>Still short on Ear of Balgaras? Balgaras the Foul -- around here. This step skips itself once you have them
    .complete 304,1 --Ear of Balgaras
    .mob Balgaras the Foul

step
    #label DarkIronDone
    .goto Wetlands,49.7,18.3
    >>The camp: Motley, Longbraid, Ashlan, Roggo
    .turnin 303 >> Turn in The Dark Iron War
    .target Motley Garmason
    .turnin 304 >> Turn in A Grim Task
    .target Longbraid the Grim
    .goto Wetlands,50.05,18.17
    .turnin 88756 >> Turn in Bring Back a Bang
    .target Ashlan Stonesmirk
    .goto Wetlands,49.85,18.09
    .turnin 87491 >> Turn in Spark of Freedom
    .target Roggo Harlbarrow

step
    .goto Wetlands,49.93,12.55
    >>Comar Villard waits on the bridge road, sick with worry
    .accept 87318 >> Accept Hearts of the Lost
    .target Comar Villard

step
    .goto Wetlands,51.2,8.0
    >>The Thandol Span: climb down to the dead prospector under the bridge (ignore the mobs)
    .turnin 631 >> Turn in The Thandol Span
    .accept 632 >> Accept The Thandol Span

step
    .goto Wetlands,51.4,9.0
    >>Essene Villard hides among the bridge ruins -- alive, barely
    .complete 87318,1 --Find Essene
    .turnin 87318 >> Turn in Hearts of the Lost
    .accept 88757 >> Accept Accessories of the Lost
    .target Essene Villard

step
    .goto Wetlands,51.6,8.5,30,0
    >>Her scattered things lie around the ruins: necklace, spellbook, waterskin
    .goto Wetlands,51.2,9.5,30,0
    .complete 88757,1 --Essene's Necklace
    .complete 88757,2 --Essene's Spellbook
    .complete 88757,3 --Essene's Waterskin

step
    .goto Wetlands,51.4,9.0
    >>Essene
    .turnin 88757 >> Turn in Accessories of the Lost
    .accept 88758 >> Accept Sentiments of the Lost
    .target Essene Villard

step
    .goto Wetlands,49.9,18.3
    >>Rhag at the camp -- and Comar, who gets his answer
    .turnin 632 >> Turn in The Thandol Span
    .accept 633 >> Accept The Thandol Span
    .target Rhag Garmason

step
    .goto Wetlands,49.93,12.55
    >>Hand in Sentiments of the Lost at Comar Villard
    .turnin -88758 >> Turn in Sentiments of the Lost
    .target Comar Villard

step
    .goto Arathi Highlands,43.3,92.6
    >>Across the span: Foggy MacKreel starts a TIMED moonshine run (it turns in at Southshore -- we're headed there anyway, don't dawdle)
    .accept 647 >> Accept MacKreel's Moonshine
    .target Foggy MacKreel

step
    .goto Arathi Highlands,44.3,93.0
    >>Jump into the water: Sully Balloo's corpse rests on the lakebed with his letter
    .accept 637 >> Accept Sully Balloo's Letter

step
    .goto Arathi Highlands,48.7,87.9
    >>Swim east to the ramp and blow the Dark Iron explosives cache
    .complete 633,1 --Cache of Explosives destroyed

step
    .goto Wetlands,49.9,18.3
    >>Rhag
    .turnin 633 >> Turn in The Thandol Span
    .accept 634 >> Accept Plea To The Alliance
    .target Rhag Garmason

step
    .goto Arathi Highlands,45.9,47.5
    >>North to Refuge Pointe: Captain Nials
    .turnin 634 >> Turn in Plea To The Alliance
    .target Captain Nials

step
    .goto Arathi Highlands,45.8,46.1
    .fp Arathi >> Get the Refuge Pointe flight path

step
    .goto Hillsbrad Foothills,52.2,58.6
    >>West into Hillsbrad, down into the Southshore inn cellar -- beat MacKreel's timer (watch for the Forsaken courier on the road)
    .turnin 647 >> Turn in MacKreel's Moonshine
    .accept 98071 >> Accept Brewer's Trade
    .target Brewmeister Bilger

step
    .goto Hillsbrad Foothills,51.4,58.6
    >>Captain McManus in town
    .accept 98059 >> Accept Hillsbrad's Hoard
    .target Captain McManus

step
    .goto Hillsbrad Foothills,51.5,58.9
    >>Slip the Sealed Company Request onto the bookkeeping table in the town hall
    .complete 98059,1 --Place the Sealed Company Request

step
    .goto Hillsbrad Foothills,51.4,58.6
    >>McManus
    .turnin 98059 >> Turn in Hillsbrad's Hoard
    .target Captain McManus

step
    .goto Hillsbrad Foothills,51.4,58.5
    >>Lieutenant Farren Orinelle
    .accept 536 >> Accept Down the Coast
    .target Lieutenant Farren Orinelle

step
    .goto Hillsbrad Foothills,44.0,67.6
    >>Murlocs down the coast: 10 Tidehunters, 10 Oracles
    .complete 536,1 --Torn Fin Tidehunter (10)
    .complete 536,2 --Torn Fin Oracle (10)
    .mob Torn Fin Tidehunter
    .mob Torn Fin Oracle

step
    .goto Hillsbrad Foothills,51.4,58.5
    >>Farren
    .turnin 536 >> Turn in Down the Coast
    .accept 559 >> Accept Farren's Proof
    .target Lieutenant Farren Orinelle

step
    .goto Hillsbrad Foothills,42.3,68.3
    >>Back to the shore: 10 Murloc Heads
    .complete 559,1 --Murloc Head (10)
    .mob Torn Fin Muckdweller
    .mob Torn Fin Coastrunner

step
    .goto Hillsbrad Foothills,51.4,58.5
    >>The Farren circuit: him, Marshal Redpath, him again
    .turnin 559 >> Turn in Farren's Proof
    .accept 560 >> Accept Farren's Proof
    .target Lieutenant Farren Orinelle
    .target Lieutenant Farren Orinelle

step
    .goto Hillsbrad Foothills,49.5,58.8
    >>Hand in Farren's Proof; take Farren's Proof at Marshal Redpath
    .turnin -560 >> Turn in Farren's Proof
    .accept 561,2,560 >> Accept Farren's Proof
    .target Marshal Redpath

step
    .goto Hillsbrad Foothills,51.4,58.4
    >>Hand in Farren's Proof; take Stormwind Ho! at Lieutenant Farren Orinelle
    .turnin -561 >> Turn in Farren's Proof
    .accept 562,2,561 >> Accept Stormwind Ho!
    .target Lieutenant Farren Orinelle

step
    .goto Hillsbrad Foothills,57.1,67.4
    >>Daggerspine naga on the east shore: 10 Shorehunters, 10 Sirens (wade in if spawns run dry)
    .complete -562,1 --Daggerspine Shorehunter (10)
    .complete -562,2 --Daggerspine Siren (10)
    .mob Daggerspine Shorehunter
    .mob Daggerspine Siren

step
    .goto Hillsbrad Foothills,60.5,76.5,40,0
    >>Southeast to Dun Garok with Bilger's bottles -- trade them for Homebrew Hops
    .goto Hillsbrad Foothills,61.5,77.3
    .complete 98071,1 --Deliver the Fallrook Varietal

step
    .goto Hillsbrad Foothills,51.4,58.5
    >>Southshore: Farren, then Bilger in the cellar
    .turnin -562 >> Turn in Stormwind Ho!
    .accept 563,2,562 >> Accept Reassignment
    .target Lieutenant Farren Orinelle
    .goto Hillsbrad Foothills,52.2,58.6
    .turnin 98071 >> Turn in Brewer's Trade
    .target Brewmeister Bilger

step
    .goto Hillsbrad Foothills,49.3,52.3
    .fp Southshore >> Get the Southshore flight path

step
    .goto Western Plaguelands,42.9,85.0
    >>Ride north along the river into the plagued borderlands -- worth it once
    .fp Chillwind >> Get the Chillwind Camp flight path

step
    .fly Wetlands >> Fly to Menethil Harbor

step
    .goto Wetlands,10.8,59.6
    >>Fitzsimmons hears of the cursed crew
    .turnin 289 >> Turn in The Cursed Crew
    .accept 290 >> Accept Lifting the Curse
    .target First Mate Fitzsimmons

step
    .goto Wetlands,15.5,23.5
    >>The northern wreck: Captain Halyndor guards the strongbox key -- enter through the broken mast (his Ward punishes spells, not swings)
    .complete 290,1 --Intrepid Strongbox Key
    .mob Captain Halyndor

step
    .goto Wetlands,14.4,24.0
    >>Dive to the hole in the north hull: the strongbox. KEEP the Cursed Eye of Paleth
    .turnin 290 >> Turn in Lifting the Curse
    .accept 292 >> Accept The Eye of Paleth

step
    .goto Wetlands,10.6,60.5
    >>Menethil: Glorin
    .turnin 292 >> Turn in The Eye of Paleth
    .accept 293 >> Accept Cleansing the Eye
    .target Glorin Steelbrow

step
    .goto Wetlands,12.1,64.1
    >>The dock warehouse
    .turnin -321 >> Turn in Lightforge Iron
    .accept 324,2,321 >> Accept The Lost Ingots

step
    .goto Wetlands,10.1,69.5
    >>Murlocs south of the harbor swallow ingots whole: 5 (ugly drop rate)
    .complete -324,1 --Lightforge Ingot (5)
    .mob Bluegill Puddlejumper
    .mob Bluegill Forager

step
    .goto Wetlands,10.6,60.4
    >>Glorin
    .turnin -324 >> Turn in The Lost Ingots
    .accept 322,2,324 >> Accept Blessed Arm
    .target Glorin Steelbrow

step
    .goto Wetlands,9.9,57.4
    >>Stoutfist hears of Nek'rosh's fall
    .turnin 474 >> Turn in Defeat Nek'rosh
    .target Captain Stoutfist

step
    .goto Wetlands,11.7,58.1
    >>Sida
    .turnin 470 >> Turn in Digging Through the Ooze
    .target Sida

step << !Human
    .isQuestComplete 98282
    .goto 1437/0,-880.87,-3769.14
    >>Caitlin, if Thelgen Rock gave up its gland
    .turnin 98282 >> Turn in Alchemical Hazards
    .target Caitlin Grassman

step
    .goto Wetlands,8.31,58.53
    >>Boran gets his statuette back
    .turnin -286 >> Turn in Return the Statuette
    .target Karl Boran

step
    .goto Wetlands,8.6,55.8
    >>Halloran
    .turnin 471 >> Turn in Apprentice's Duties
    .target James Halloran

step
    .goto Wetlands,9.3,59.4
    .fly Ironforge >> Fly to Ironforge

step
    .goto Ironforge,63.8,67.8
    >>Sara Balloo, widowed
    .turnin 637 >> Turn in Sully Balloo's Letter
    .accept 683 >> Accept Sara Balloo's Plea
    .target Sara Balloo

step
    .goto Ironforge,39.3,55.9
    >>King Magni Bronzebeard in the High Seat
    .turnin 683 >> Turn in Sara Balloo's Plea
    .accept 686 >> Accept A King's Tribute
    .target King Magni Bronzebeard

step
    #optional
    .isQuestComplete 96393
    .goto Ironforge,39.3,55.9
    >>Ran the Hall of Thanes? King Magni in the High Seat takes Durgen Dirgehammer's head
    .turnin 96393 >> Turn in Old Ironforge Incursion
    .target King Magni Bronzebeard

step
    .goto Ironforge,38.7,87.2
    >>Grand Mason Marblesten
    .turnin 686 >> Turn in A King's Tribute
    .accept 689 >> Accept A King's Tribute
    .target Grand Mason Marblesten

step
    +Chunk complete -- you're ~30 in Ironforge. Banked for 30+: A King's Tribute (689), A Noble Brew (335, root in bags), Cleansing the Eye (293), Blessed Arm (322), Reassignment (563, Stormwind), Mor'Ladim (228) if skipped, The Night Watch (57), Worgen in the Woods (221), Look To The Stars (181, 8 bronze tubes), Totem of Infliction (101), Rot Blossoms (156), Stalvan (74), the History Book (337) if it dropped
]])
