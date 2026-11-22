-- RXPGuides_ForeverWarrior: Horde 22-30
-- Chunks: 22-25 Hillsbrad/South Barrens > 25-26 Stonetalon > 26-30 Ashenvale/Thousand Needles
-- Built from classic-era route data, verified against the Forever quest DB (106 quests;
-- TBC-era 9428/9431/9433/9434 removed). Pays banked quests from the 12-22 chain:
-- 264, 868, 874, 1065, 1092, 1096, 1216->216, 1823, 3301, 6301, 6393, 6462 on route;
-- optional stops for 1068 (Seereth) and 1088 (Braelyn). Still banked past 30:
-- 1058 (Jin'Zil), 2842 (Booty Bay), 1136, 1184, 1112, 1178, 5762, 79007, 97003.
-- VERIFY IN GAME: first live pass may need coordinate/flow touch-ups.

-- ================== 22-25 HILLSBRAD / SOUTH BARRENS ==================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 22-25 Hillsbrad/South Barrens (Horde)
#next 25-26 Stonetalon (Horde)
<< Horde

step << Priest
    #optional
    .goto Orgrimmar,35.59,87.82
    >>PRIEST (trolls, 20+): Ur'kyo in the Valley of Spirits teaches Shadowguard -- the trainer note lands with him
    .turnin -5642 >> Turn in Shadowguard
    .turnin -5643 >> Turn in Shadowguard
    .turnin -5680 >> Turn in Shadowguard
    .target Ur'kyo

step << Rogue
    .goto Orgrimmar,43.05,53.74
    >>Rogues: in the Cleft of Shadow, Shenthul tests you -- target him and /salute (again if the first doesn't register)
    .accept 2460 >> Accept The Shattered Salute
    .complete 2460,1
    .turnin 2460 >> Turn in The Shattered Salute
    .accept 2458 >> Accept Deep Cover
    .target Shenthul

step << Rogue
    #optional
    .goto The Barrens,55.44,5.56
    >>OPTIONAL but it unlocks your Poisons: out the west gate, southwest to the lone windmill north of the Sludge Fen. Stop short, fire the Flare Gun from your bags, THEN talk to Taskmaster Fizzule
    .turnin 2458 >> Turn in Deep Cover
    .accept 2478 >> Accept Mission: Possible But Not Probable
    .target Taskmaster Fizzule

step << Rogue
    #optional
    .isOnQuest 2478
    .goto The Barrens,56.4,8.4
    >>The Venture Co. tower south of the windmill: pickpocket Silixiz's Tower Key off Foreman Silixiz, and kill 2 Mutated Venture Co. Drones, 2 Patrollers, and 2 Lookouts
    .complete 2478,1
    .complete 2478,2
    .complete 2478,3
    .complete 2478,4
    .mob Foreman Silixiz
    .mob Mutated Venture Co. Drone
    .mob Venture Co. Patroller
    .mob Venture Co. Lookout

step << Rogue
    #optional
    .isQuestComplete 2478
    .goto Orgrimmar,43.05,53.74
    >>Back to Shenthul with the key -- he points you at Tarren Mill, where we're going anyway
    .turnin 2478 >> Turn in Mission: Possible But Not Probable
    .accept 2479 >> Accept Hinott's Assistance
    .target Shenthul

step
    .goto Durotar,50.8,13.8
    >>Make your way to Orgrimmar and out to the zeppelin tower in Durotar. Ride the Undercity zeppelin
    .zone Tirisfal Glades >> Zeppelin to Tirisfal Glades

step << Warlock
    #optional
    .goto Undercity,85.06,25.99
    >>OPTIONAL Undead-trained warlocks: below in the Undercity, Carendin starts the succubus chain (Orgrimmar-trained: ask Gan'rul for his version). It's a side project; the quests keep
    .accept 1472 >> Accept Devourer of Souls
    .target Carendin Halgar

step << Warlock
    #optional
    .isOnQuest 1472
    .goto Undercity,84.81,14.83
    >>Godrick Farsan in the War Quarter. His next errand (Hearts of the Pure) sends you deep into Alliance land this route never visits -- skip it
    .turnin 1472 >> Turn in Devourer of Souls
    .target Godrick Farsan

step << Priest
    #optional
    .goto Undercity,49.26,17.12
    >>PRIEST (undead, 20+): Aelthalyste in the War Quarter teaches Devouring Plague while you're below
    .turnin -5644 >> Turn in Devouring Plague
    .turnin -5646 >> Turn in Devouring Plague
    .turnin -5679 >> Turn in Devouring Plague
    .target Aelthalyste

step
    .goto Silverpine Forest,42.8,40.8
    >>Run south into Silverpine: Apothecary Renferrel at the Sepulcher
    .accept 493 >> Accept Journey to Hillsbrad Foothills
    .target Apothecary Renferrel

step
    .isOnQuest 3301
    .goto Silverpine Forest,42.9,41.9
    >>Mura Runetotem waits here with your delivery
    .turnin -3301 >> Turn in Mura Runetotem
    .target Mura Runetotem

step
    .isOnQuest 264
    .goto Silverpine Forest,44.1,42.5
    >>The stone grave on the hillside closes an old promise
    .turnin 264 >> Turn in Until Death Do Us Part

step
    .goto Silverpine Forest,45.6,42.6
    .fp The Sepulcher >> Get the Sepulcher flight path
    .target Karos Razok

step
    .goto Hillsbrad Foothills,20.7,47.4
    >>Southeast into Hillsbrad -- watch the Dalaran wizards by the border, their Frostbolts slow you. Deathstalker Lesh camps by the road
    .accept 494 >> Accept Time To Strike
    .target Deathstalker Lesh

step
    .goto Hillsbrad Foothills,60.1,18.6
    .fp Tarren Mill >> Get the Tarren Mill flight path
    .target Zarise

step
    #optional
    .goto Hillsbrad Foothills,62.5,19.5
    >>Set your hearthstone at the Tarren Mill inn -- this arc loops back here several times
    .home >> Set your hearthstone at Tarren Mill

step
    .goto Hillsbrad Foothills,61.5,19.4
    >>Quest round at Tarren Mill: Lydon in the inn, then the Executor's porch
    .turnin 493 >> Turn in Journey to Hillsbrad Foothills
    .accept 496 >> Accept Elixir of Suffering
    .accept 501 >> Accept Elixir of Pain
    .turnin 1065 >> Turn in Journey to Tarren Mill
    .accept 1066 >> Accept Blood of Innocents
    .target Apothecary Lydon

step
    .goto Hillsbrad Foothills,62.4,20.2
    >>Hand in Time To Strike; take Battle of Hillsbrad at High Executor Darthalia, then take WANTED: Syndicate Personnel at WANTED
    .turnin -494 >> Turn in Time To Strike
    .accept 527 >> Accept Battle of Hillsbrad
    .accept 549 >> Accept WANTED: Syndicate Personnel
    .target High Executor Darthalia

step
    .goto Hillsbrad Foothills,62.6,20.7
    >>Take The Rescue at Krusk
    .accept 498 >> Accept The Rescue
    .target Krusk

step
    #optional
    .goto Hillsbrad Foothills,62.4,20.3
    >>The bounty board by Darthalia: four Hillsbrad citizens with prices on their heads
    .accept 567 >> Accept Dangerous!

step
    .goto Hillsbrad Foothills,62.5,19.5
    >>Stock up on food and water at the inn before heading out
    .vendor >> Buy food and water

step << Warrior/Shaman
    #optional
    .goto Hillsbrad Foothills,60.4,26.1
    >>Ott south of town sometimes stocks the Merciless Axe -- a solid two-hander if yours is lagging
    .vendor >> Check Ott for the Merciless Axe
    .target Ott
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<21.09

step
    #sticky
    #completewith Durnholde1
    >>Gray Bears on the way east carry the tongues Lydon wants
    .complete 496,1 --Gray Bear Tongue (10)
    .mob Vicious Gray Bear
    .mob Gray Bear

step
    #label Durnholde1
    .goto Hillsbrad Foothills,76.7,46.2,60
    >>East to Durnholde Keep
    .isOnQuest 549

step
    #sticky
    #completewith Drull
    >>Syndicate men die throughout the keep: 10 Rogues, 10 Watchmen -- and their Shadow Mages carry Vials of Innocent Blood
    .complete 549,1 --Syndicate Rogue (10)
    .complete 549,2 --Syndicate Watchman (10)
    .complete 1066,1 --Vial of Innocent Blood (5)
    .mob Syndicate Rogue
    .mob Syndicate Watchman
    .mob Syndicate Shadow Mage

step
    .goto Hillsbrad Foothills,79.5,41.8,15,0
    >>Jailor Eston walks the barracks yard -- his Dull Iron Key opens Tog'thar's chains
    .collect 3467,1,498,1 --Dull Iron Key (1)
    .mob Jailor Eston

step
    .goto Hillsbrad Foothills,79.7,39.6
    >>Free Tog'thar -- click his chains
    .complete 498,2 --Rescue Tog'thar

step
    .goto Hillsbrad Foothills,79.4,40.5,15,0
    >>Jailor Marlgen carries the Burnished Gold Key -- he's near the tower
    .collect 3499,1,498,2 --Burnished Gold Key (1)
    .mob Jailor Marlgen

step
    #label Drull
    .goto Hillsbrad Foothills,75.3,41.5
    >>Drull's chains are on the lower terrace
    .complete 498,1 --Rescue Drull

step
    .goto Hillsbrad Foothills,67.0,46.2,40,0
    >>Finish the Syndicate tally at the camps west of the keep
    .complete 549,1 --Syndicate Rogue (10)
    .complete 549,2 --Syndicate Watchman (10)
    .complete 1066,1 --Vial of Innocent Blood (5)
    .mob Syndicate Rogue
    .mob Syndicate Watchman
    .mob Syndicate Shadow Mage

step
    #sticky
    #completewith HFields1
    >>Bears, Moss Creepers and Starving Mountain Lions between here and the fields fill Lydon's list
    .complete 496,1 --Gray Bear Tongue (10)
    .complete 496,2 --Creeper Ichor (1)
    .complete 501,1 --Mountain Lion Blood (10)
    .mob Vicious Gray Bear
    .mob Forest Moss Creeper
    .mob Starving Mountain Lion

step
    #label HFields1
    .goto Hillsbrad Foothills,36.0,39.1,80
    >>Cross the zone west to the Hillsbrad Fields
    .isOnQuest 527

step
    #sticky
    #completewith Getz
    >>Farmers and Farmhands fall throughout the fields
    .complete 527,1 --Hillsbrad Farmer (6)
    .complete 527,2 --Hillsbrad Farmhand (6)
    .mob Hillsbrad Farmer
    .mob Hillsbrad Farmhand

step
    .goto Hillsbrad Foothills,33.7,35.5,20,0
    >>Farmer Ray works the vineyard or the house floors
    .complete 527,3 --Farmer Ray
    .unitscan Farmer Ray

step
    #label Getz
    .goto Hillsbrad Foothills,36.7,39.3,20,0
    >>Farmer Getz: house, field, or barn
    .complete 527,4 --Farmer Getz
    .unitscan Farmer Getz

step
    #loop
    .line Hillsbrad Foothills,35.90,40.63,33.88,41.80,30.19,38.48,30.67,35.21,31.71,36.72,33.67,35.66,35.90,40.63
    .goto Hillsbrad Foothills,35.9,40.6,45,0
    >>Circle the farms for the rest of the Farmers and Farmhands
    .complete 527,1 --Hillsbrad Farmer (6)
    .complete 527,2 --Hillsbrad Farmhand (6)
    .mob Hillsbrad Farmer
    .mob Hillsbrad Farmhand

step
    #sticky
    #completewith TMround1
    >>Citizen Wilkes patrols the town roads -- he's on the bounty
    .complete 567,2 --Citizen Wilkes
    .unitscan Citizen Wilkes

step
    #sticky
    #completewith TMround1
    >>Clerk Horrace Whitesteed also walks these fields -- bounty number two
    .complete 567,1 --Clerk Horrace Whitesteed
    .unitscan Clerk Horrace Whitesteed

step
    #sticky
    #completewith TMround1
    >>Lions along the hills still owe blood
    .complete 501,1 --Mountain Lion Blood (10)
    .mob Starving Mountain Lion

step
    #label BearT
    #loop
    .line Hillsbrad Foothills,40.88,33.87,40.86,37.40,38.50,38.04,38.71,42.66,44.39,41.34,43.87,37.01,49.75,34.33,52.39,29.27,57.38,22.85,59.68,30.90,62.63,37.64,66.52,34.52
    .goto Hillsbrad Foothills,40.8,33.8,45,0
    >>Sweep back east through bear and creeper country until Lydon's elixir lists are full
    .complete 496,1 --Gray Bear Tongue (10)
    .complete 496,2 --Creeper Ichor (1)
    .mob Vicious Gray Bear
    .mob Gray Bear
    .mob Forest Moss Creeper

step
    #optional
    .isOnQuest 501
    .goto 1424/0,-646.93,-450.56
    >>Still short on Mountain Lion Blood? Starving Mountain Lion -- around here. This step skips itself once you have them
    .complete 501,1 --Mountain Lion Blood (10)
    .mob Starving Mountain Lion

step
    #label TMround1
    .goto Hillsbrad Foothills,61.5,19.4
    >>Tarren Mill: Lydon brews, Umpi drinks, Darthalia escalates
    .turnin 496 >> Turn in Elixir of Suffering
    .accept 499 >> Accept Elixir of Suffering
    .turnin 499 >> Turn in Elixir of Suffering
    .turnin 501 >> Turn in Elixir of Pain
    .accept 502 >> Accept Elixir of Pain
    .turnin 1066 >> Turn in Blood of Innocents
    .accept 1067 >> Accept Return to Thunder Bluff
    .goto Hillsbrad Foothills,62.4,20.2
    .turnin 527 >> Turn in Battle of Hillsbrad
    .accept 528 >> Accept Battle of Hillsbrad
    .turnin 549 >> Turn in WANTED: Syndicate Personnel
    .turnin 498 >> Turn in The Rescue
    .target Apothecary Lydon
    .target Umpi
    .target High Executor Darthalia
    .target Krusk

step
    .goto Hillsbrad Foothills,62.1,19.6
    >>Deathguard Samsa collects skulls
    .accept 546 >> Accept Souvenirs of Death
    .target Deathguard Samsa

step
    #sticky
    #completewith TMround2
    >>Every human in the fields counts: 30 skulls
    .complete 546,1 --Hillsbrad Human Skull (30)

step
    .isOnQuest 502
    .goto Hillsbrad Foothills,32.6,35.3
    >>Back west: hand Stanley's owner the Elixir of Pain, sit through the show, then put the poor dog down when he turns
    .turnin 502 >> Turn in Elixir of Pain
    .timer 9,Stanley turns (BE READY)
    .mob Stanley

step
    .goto Hillsbrad Foothills,36.0,46.5
    >>Farmer Kalaba is bounty number three, by the southern fields
    .complete 567,4 --Farmer Kalaba
    .mob Farmer Kalaba

step
    #loop
    .line Hillsbrad Foothills,36.64,45.21,34.36,44.62,33.25,48.54,35.29,47.28,36.64,45.21
    .goto Hillsbrad Foothills,36.6,45.2,35,0
    >>Peasants work the south fields -- Darthalia wants fifteen
    .complete 528,1 --Hillsbrad Peasant (15)
    .mob Hillsbrad Peasant

step
    .goto Hillsbrad Foothills,32.0,45.4
    >>The blacksmith's shed: kill Verringtan and his apprentices, then lift the Shipment of Iron inside
    .complete 529,1 --Blacksmith Verringtan
    .complete 529,2 --Hillsbrad Apprentice Blacksmith (4)
    .complete 529,3 --Shipment of Iron
    .mob Blacksmith Verringtan
    .mob Hillsbrad Apprentice Blacksmith
    .isOnQuest 528

step
    #optional
    .goto Hillsbrad Foothills,26.9,60.5
    >>OPTIONAL bounty detour: Miner Hackett digs in Azurelode Mine on the coast southwest. Skip if the mine's crowded
    .complete 567,3 --Miner Hackett
    .unitscan Miner Hackett

step
    #optional
    .isOnQuest 567
    .goto 1424/0,29.87,-468.27
    >>Still short on Citizen Wilkes? Citizen Wilkes -- around here. This step skips itself once you have them
    .complete 567,2 --Citizen Wilkes
    .mob Citizen Wilkes

step
    #optional
    .isOnQuest 567
    .goto 1424/0,122.35,-504.75
    >>Still short on Clerk Horrace Whitesteed? Clerk Horrace Whitesteed -- around here. This step skips itself once you have them
    .complete 567,1 --Clerk Horrace Whitesteed
    .mob Clerk Horrace Whitesteed

step
    #optional
    .isOnQuest 546
    .goto 1424/0,-17.49,-504.96
    >>Still short on Hillsbrad Human Skull? Arados the Damned / Blacksmith Verringtan / Citizen Wilkes -- around here. This step skips itself once you have them
    .complete 546,1 --Hillsbrad Human Skull (30)
    .mob Arados the Damned
    .mob Blacksmith Verringtan
    .mob Citizen Wilkes
    .mob Clerk Horrace Whitesteed

step
    #label TMround2
    .goto Hillsbrad Foothills,62.4,20.2
    >>Close out Hillsbrad at Tarren Mill
    .turnin 528 >> Turn in Battle of Hillsbrad
    .accept 529 >> Accept Battle of Hillsbrad
    .turnin 529 >> Turn in Battle of Hillsbrad
    .turnin -567 >> Turn in Dangerous!
    .goto Hillsbrad Foothills,62.1,19.6
    .turnin 546 >> Turn in Souvenirs of Death
    .target High Executor Darthalia
    .target Deathguard Samsa

step << Rogue
    .isOnQuest 2479
    .goto Hillsbrad Foothills,61.63,19.19
    >>Serge Hinott in the inn takes Zanzil's sample
    .turnin 2479 >> Turn in Hinott's Assistance
    .accept 2480 >> Accept Hinott's Assistance
    .target Serge Hinott

step << Rogue
    .isOnQuest 2480
    .goto Hillsbrad Foothills,61.63,19.19
    >>Hinott needs a few minutes with the cure -- vendor, repair, restock, then collect it: POISONS unlock at your trainer
    .turnin 2480 >> Turn in Hinott's Assistance
    .target Serge Hinott

step
    .goto Hillsbrad Foothills,60.1,18.6
    .fly Undercity >> Fly to Undercity

step
    .goto Tirisfal Glades,60.6,58.7
    >>Zeppelin back to Orgrimmar
    .zone Durotar >> Zeppelin to Orgrimmar

step
    .goto Durotar,45.1,13.7
    .fly Thunder Bluff >> Fly to Thunder Bluff

step << Warrior
    .goto Thunder Bluff,57.6,85.5
    .trainer >> Train your class abilities

step
    .goto Thunder Bluff,23.1,21.0
    >>Apothecary Zamah in the pools under the Spirit Rise
    .turnin 1067 >> Turn in Return to Thunder Bluff
    .accept 1086 >> Accept The Flying Machine Airport
    .target Apothecary Zamah

step << Shaman
    .goto Thunder Bluff,25.16,20.51
    >>Xanis Flameweaver, two tents over: the water totem chain starts here
    .accept 1529 >> Accept Call of Water
    .target Xanis Flameweaver

step << Druid
    #optional
    .goto Thunder Bluff,76.48,27.22
    >>OPTIONAL druid side-project (Aquatic Form): Turak starts it -- a Moonglade round and two pendant halves from far shores. Take it now, chip at it as you travel
    .accept 27 >> Accept A Lesson to Learn
    .target Turak Runetotem

step << Druid
    #optional
    .isOnQuest 26
    .goto Moonglade,56.2,30.6
    >>Teleport: Moonglade -- Dendrite
    .turnin 27 >> Turn in A Lesson to Learn
    .accept 28 >> Accept Trial of the Lake
    .target Dendrite Starblaze

step << Druid
    #optional
    .isOnQuest 28
    .goto Moonglade,52.0,41.0
    >>Dive Lake Elune'ara for a Shrine Bauble, then carry it to the Shrine of Remulos northwest and use it there -- turn in on the spot
    .complete 28,1

step << Druid
    #optional
    .goto 1450/1,-2224.25,7874.29
    >>Hand in Trial of the Lake; take Trial of the Sea Lion at Tajarri
    .turnin -28 >> Turn in Trial of the Lake
    .accept 30,2,28 >> Accept Trial of the Sea Lion

step << Druid
    #optional
    +Trial of the Sea Lion, for your travels: the Agility half lies sunken off the island in Lordamere Lake, Silverpine (easy on a Sepulcher flight); the Endurance half sits off Westfall's lighthouse reef -- enemy coast, swim quiet. Dendrite in Moonglade takes the halves; Turak grants the form

step << Druid
    #optional
    .isQuestComplete 30
    .goto Moonglade,56.2,30.6
    >>Both halves in hand: Teleport Moonglade -- Dendrite joins the pendant
    .turnin -30 >> Turn in Trial of the Sea Lion
    .accept 31,2,30 >> Accept Aquatic Form
    .target Dendrite Starblaze

step << Druid
    #optional
    .isOnQuest 31
    .goto Thunder Bluff,76.48,27.22
    >>Turak -- AQUATIC FORM (hand in whenever you're next on the bluff)
    .turnin -31 >> Turn in Aquatic Form
    .target Turak Runetotem

step
    .goto Thunder Bluff,55.2,51.5
    >>Zangen Stonehoof on the rise -- his flame quest pays out over the next chapters
    .accept 1195 >> Accept The Sacred Flame
    .target Zangen Stonehoof

step << Shaman
    .goto Thunder Bluff,46.8,50.1
    >>Shamans detour: fly to Ratchet instead
    .fly Ratchet >> Fly to Ratchet

step << Shaman
    .goto The Barrens,65.83,43.78
    >>South along the beach: Islen Waterseer by her hut
    .turnin 1529 >> Turn in Call of Water
    .accept 1530 >> Accept Call of Water
    .target Islen Waterseer

step << Shaman
    .goto The Barrens,62.6,37.1
    >>Back up to Ratchet and wing west -- the guide meets you at Taurajo
    .fly Camp Taurajo >> Fly to Camp Taurajo

step << !Shaman
    .goto Thunder Bluff,46.8,50.1
    .fly Camp Taurajo >> Fly to Camp Taurajo

step << Warrior
    .isOnQuest 1823
    .goto The Barrens,44.7,59.4
    >>Ruga Ragetotem in the Taurajo longhouse
    .turnin 1823 >> Turn in Speak with Ruga
    .accept 1824 >> Accept Trial at the Field of Giants
    .target Ruga Ragetotem

step
    .goto The Barrens,44.6,59.2
    >>Mangletooth snarls in his cage; Tatternack stands nearby
    .accept 879 >> Accept Betrayal from Within
    .target Mangletooth

step
    .goto The Barrens,45.0,57.6
    >>Take Weapons of Choice at Tatternack Steelforge
    .accept 893 >> Accept Weapons of Choice
    .target Tatternack Steelforge

step
    #sticky
    #completewith Baeldun
    .maxlevel 29
    >>Owatanka, a blue thunder lizard, roams east of Taurajo -- his tailspike starts a quest
    .collect 5102,1,884 --Owatanka's Tailspike
    .use 5102
    .accept 884 >> Accept Owatanka
    .unitscan Owatanka

step
    #sticky
    #completewith Baeldun
    >>Washte Pawne, a red wind serpent, circles the Field of Giants -- her feather starts a quest too
    .collect 5103,1,885 --Washte Pawne's Feather
    .use 5103
    .accept 885 >> Accept Washte Pawne
    .unitscan Washte Pawne

step
    .goto The Barrens,48.1,70.3
    >>The Field of Giants: silithids boil out of the mounds
    >>Warriors: Twitching Antennae vanish after 15 minutes, so collect and finish promptly
    .complete 1824,1 << Warrior --Twitching Antenna (5)
    .complete -868,1 --Silithid Egg (12)
    .mob Silithid Harvester
    .mob Silithid Swarmer
    .mob Silithid Creeper

step << Shaman
    .goto The Barrens,43.42,77.41
    >>Southwest corner of the field: Brine's hut on the rise
    .turnin 1530 >> Turn in Call of Water
    .accept 1535 >> Accept Call of Water
    .target Brine

step << Shaman
    .goto The Barrens,43.3,78.3
    >>Fill the Brown Waterskin at the watering hole below her hut, then hand it up
    .complete 1535,1

step << Shaman
    .goto 1413/1,-1776.98,-3617.51
    >>Hand in Call of Water; take Call of Water at Brine
    .turnin -1535 >> Turn in Call of Water
    .accept 1536,2,1535 >> Accept Call of Water
    .target Brine

step << Shaman
    #optional
    .goto The Barrens,43.42,77.41
    >>The Red Waterskin fills at the well in Tarren Mill (by the inn). Fastest now: hearth there, fill it, zeppelin Orgrimmar, fly back to Taurajo (~20 min). Or bank it for your next trip east -- the blue skin after it is in Ashenvale, which the 26-30 chapter visits
    .complete -1536,1 --Filled Red Waterskin

step << Shaman
    #optional
    .isQuestComplete 1536
    .goto The Barrens,43.42,77.41
    >>Brine trades skins again
    .turnin -1536 >> Turn in Call of Water
    .accept 1534,2,1536 >> Accept Call of Water
    .target Brine

step << Warrior
    .goto The Barrens,44.7,59.4
    >>Back to Ruga
    .turnin -1824 >> Turn in Trial at the Field of Giants
    .accept 1825,2,1824 >> Accept Speak with Thun'grim
    .target Ruga Ragetotem

step
    .goto The Barrens,46.0,76.2,50,0
    >>Gann Stonespire walks the road south of the field
    .accept 843 >> Accept Gann's Reclamation
    .unitscan Gann Stonespire

step
    #sticky
    #label Weapons
    .isOnQuest 893
    .goto The Barrens,43.4,78.8,30,0
    >>Razormane camps: the Backstabber from Stalkers and Pathfinders, the Wand from Seers, the Shield from Warfrenzies
    .complete 893,1 --Razormane Backstabber
    .complete 893,2 --Charred Razormane Wand
    .complete 893,3 --Razormane War Shield

step
    .isOnQuest 879
    .goto The Barrens,43.4,78.8
    >>Kuz prowls the ridge -- take her skull
    .complete 879,1 --Kuz's Skull
    .unitscan Kuz

step
    .isOnQuest 879
    .goto The Barrens,40.4,80.8
    >>Lok Orcbane keeps to the building up the ramp
    .complete 879,3 --Lok's Skull
    .unitscan Lok Orcbane

step
    .isOnQuest 879
    .goto The Barrens,43.8,83.5
    >>Nak holds the southern ridge
    .complete 879,2 --Nak's Skull
    .unitscan Nak

step
    #label Baeldun
    .isOnQuest 843
    .goto The Barrens,48.3,86.2,40,0
    >>Bael'dun digsite: 15 Excavators, 5 Foremen, and Prospector Khazgorm's journal in the main tent
    .complete 843,1 --Bael'dun Excavator (15)
    .complete 843,2 --Bael'dun Foreman (5)
    .complete 843,3 --Khazgorm's Journal
    .mob Bael'dun Excavator
    .mob Bael'dun Foreman

step
    .isOnQuest 843
    .goto The Barrens,46.0,81.2,50,0
    >>Find Gann on the road
    .turnin 843 >> Turn in Gann's Reclamation
    .accept 846 >> Accept Revenge of Gann
    .unitscan Gann Stonespire

step
    .goto The Barrens,49.4,84.3
    >>The dig's supplies fuel his revenge: nitroglycerin, wood pulp, sodium nitrate from the dwarves
    .complete 846,1 --Nitroglycerin (6)
    .complete 846,2 --Wood Pulp (6)
    .complete 846,3 --Sodium Nitrate (6)

step
    .isQuestComplete 846
    .goto The Barrens,46.0,81.2,50,0
    >>Gann again
    .turnin 846 >> Turn in Revenge of Gann
    .accept 849 >> Accept Revenge of Gann
    .unitscan Gann Stonespire

step
    .isOnQuest 849
    .goto The Barrens,46.9,85.6
    >>Right-click the Bael Modan Flying Machine -- it works from the ground below the platform
    .complete 849,1 --Flying Machine destroyed

step
    .isOnQuest 849
    .goto The Barrens,46.0,81.2,50,0
    >>Gann, one last time
    .turnin 849 >> Turn in Revenge of Gann
    .unitscan Gann Stonespire

step
    #optional
    .isOnQuest 884
    .goto 1445/1,-1856.02,-2576.38
    >>Still short on Owatanka's Tailspike? Owatanka -- around here. This step skips itself once you have them
    .collect 5102,1,884 --Owatanka's Tailspike
    .mob Owatanka

step
    #optional
    .isOnQuest 885
    .goto 1445/1,-1917.83,-3449.96
    >>Still short on Washte Pawne's Feather? Washte Pawne -- around here. This step skips itself once you have them
    .collect 5103,1,885 --Washte Pawne's Feather
    .mob Washte Pawne

step
    #optional
    .isOnQuest 893
    .goto 1441/1,-1785.08,-3983.03
    >>Still short on Razormane Backstabber? Razormane Pathfinder / Razormane Stalker -- around here. This step skips itself once you have them
    .complete 893,1 --Razormane Backstabber
    .mob Razormane Pathfinder
    .mob Razormane Stalker

step
    #optional
    .isOnQuest 893
    .goto 1445/1,-1585.46,-3849.25
    >>Still short on Charred Razormane Wand? Razormane Seer -- around here. This step skips itself once you have them
    .complete 893,2 --Charred Razormane Wand
    .mob Razormane Seer

step
    #optional
    .isOnQuest 893
    .goto 1445/1,-1640.18,-3823.58
    >>Still short on Razormane War Shield? Razormane Warfrenzy -- around here. This step skips itself once you have them
    .complete 893,3 --Razormane War Shield
    .mob Razormane Warfrenzy

step
    .goto The Barrens,44.6,59.2
    >>Return to Taurajo: the cage, the smith, the skyseer
    .turnin -879 >> Turn in Betrayal from Within
    .accept 906,2,879 >> Accept Betrayal from Within
    .target Mangletooth

step
    .goto The Barrens,45.1,57.6
    >>Hand in Weapons of Choice; take A New Ore Sample at Tatternack Steelforge
    .turnin -893 >> Turn in Weapons of Choice
    .accept 1153,2,893 >> Accept A New Ore Sample
    .target Tatternack Steelforge

step
    .goto The Barrens,44.9,59.1
    >>Hand in Washte Pawne, Owatanka, Lakota'mani at Jorn Skyseer
    .turnin -885 >> Turn in Washte Pawne
    .turnin -884 >> Turn in Owatanka
    .turnin -883 >> Turn in Lakota'mani
    .target Jorn Skyseer

step
    .goto The Barrens,44.4,59.0
    .fly Crossroads >> Fly to Crossroads

step
    .isOnQuest 906
    .goto The Barrens,51.5,30.9
    >>Thork at the Crossroads
    .turnin -906 >> Turn in Betrayal from Within
    .target Thork

step
    .isQuestComplete 868
    .goto The Barrens,51.1,29.6
    >>Korran takes the silithid eggs you've been carrying since the last chapter
    .turnin 868 >> Turn in Egg Hunt
    .target Korran

step << Warrior
    #optional
    .isOnQuest 1825
    .goto The Barrens,57.1,29.8
    >>OPTIONAL: Thun'grim Firegaze on his hill east of Crossroads -- this just banks the level 30 weapon chain intro
    .turnin -1825 >> Turn in Speak with Thun'grim
    .target Thun'grim Firegaze
]])

-- ======================== 25-26 STONETALON ===========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 25-26 Stonetalon (Horde)
#next 26-30 Ashenvale/Thousand Needles (Horde)
<< Horde

step
    #optional
    .isQuestComplete 1068
    .goto The Barrens,35.2,27.8
    >>OPTIONAL: if the XT:4 and XT:9 shredders are already dead in your log, Seereth Stonebreak waits up the Stonetalon road northwest
    .turnin 1068 >> Turn in Shredding Machines
    .target Seereth Stonebreak

step
    .goto The Barrens,51.5,30.3
    .fly Sun Rock >> Fly to Sun Rock Retreat

step
    .goto Stonetalon Mountains,45.9,60.4
    >>Quest round at Sun Rock: Braelyn by the fire, Tsunaman, Tammra, Maggran
    .accept 1087 >> Accept Cenarius' Legacy
    .target Braelyn Firehand

step
    .goto Stonetalon Mountains,47.3,64.3
    >>Take Elemental War at Tsunaman
    .accept 6393 >> Accept Elemental War
    .target Tsunaman

step
    .goto Stonetalon Mountains,47.4,58.4
    >>Take Cycle of Rebirth at Tammra Windfield
    .accept 6301 >> Accept Cycle of Rebirth
    .target Tammra Windfield

step
    .goto Stonetalon Mountains,47.3,61.1
    >>Take Calling in the Reserves, Harpies Threaten at Maggran Earthbinder
    .accept 5881 >> Accept Calling in the Reserves
    .accept 6282 >> Accept Harpies Threaten
    .target Maggran Earthbinder

step
    .goto Stonetalon Mountains,59.0,62.6
    >>Ziz Fizziks at Windshear -- and hand over the Unidentified Ore if you've carried it since the last chunk
    .accept 1096 >> Accept Gerenzo Wrenchwhistle
    .turnin -1092 >> Turn in Gerenzo's Orders
    .target Ziz Fizziks

step
    .isOnQuest 1086
    .goto Stonetalon Mountains,66.4,45.4
    >>Set Zamah's Toxic Fogger among the flying machines
    .complete 1086,1 --Place the Toxic Fogger

step
    .isOnQuest 1096
    .goto Stonetalon Mountains,64.4,40.2
    >>Climb to Gerenzo Wrenchwhistle, clear his guards, and end him
    .complete 1096,1 --Gerenzo Wrenchwhistle
    .unitscan Gerenzo Wrenchwhistle

step
    #optional
    .goto Stonetalon Mountains,62.6,40.2
    >>The vendor at the platform's end sometimes stocks green gear worth a look
    .vendor >> Check the vendor for upgrades

step
    .isOnQuest 1096
    .goto Stonetalon Mountains,58.9,62.5
    >>Back down to Ziz
    .turnin 1096 >> Turn in Gerenzo Wrenchwhistle
    .target Ziz Fizziks

step
    .isOnQuest 6301
    .goto Stonetalon Mountains,50.6,36.6,0,0
    >>Gaea Seeds dot the lakeshore as you head north -- grab them in passing
    .complete 6301,1 --Gaea Seed (10)

step
    .isOnQuest 1087
    .goto Stonetalon Mountains,35.8,13.0
    >>The Dryads and Night Elves of Mirkfallon owe Braelyn answers
    .complete 1087,1
    .complete 1087,2
    .complete 1087,3

step
    .isOnQuest 6282
    .goto Stonetalon Mountains,31.1,61.2
    >>The Charred Vale harpies: Slayers execute below 20% health, Ambushers burst-shock, Roguefeathers thrash. Pull carefully
    .complete 6282,1
    .complete 6282,2
    .complete 6282,3
    .complete 6282,4

step
    .isOnQuest 6393
    .goto Stonetalon Mountains,32.6,67.4
    >>Fire elementals in the vale's south carry Incendrite
    .complete 6393,1 --Incendrite Ore (10)

step
    .goto Stonetalon Mountains,46.0,60.5
    >>Sun Rock, round two
    .turnin -1087 >> Turn in Cenarius' Legacy
    .accept 1088,2,1087 >> Accept Ordanus
    .target Braelyn Firehand

step
    .goto Stonetalon Mountains,47.1,61.1
    >>Hand in Harpies Threaten; take Bloodfury Bloodline at Maggran Earthbinder
    .turnin -6282 >> Turn in Harpies Threaten
    .accept 6283,2,6282 >> Accept Bloodfury Bloodline
    .target Maggran Earthbinder

step
    .goto Stonetalon Mountains,47.4,58.5
    >>Hand in Cycle of Rebirth; take New Life at Tammra Windfield
    .turnin -6301 >> Turn in Cycle of Rebirth
    .accept 6381,2,6301 >> Accept New Life
    .target Tammra Windfield

step
    .isOnQuest 6381
    .goto Stonetalon Mountains,31.1,61.2
    >>Back in the vale: plant saplings in the dirt mounds as you hunt
    .complete -6381,1 --Plant 10 saplings

step
    .isOnQuest 6283
    .goto Stonetalon Mountains,30.7,61.9
    >>The Bloodfury Ripper roosts at the vale's heart
    .complete -6283,1 --Bloodfury Ripper's Remains
    .unitscan Bloodfury Ripper

step
    .goto Stonetalon Mountains,47.3,64.3
    >>Last Sun Rock round
    .turnin -6393 >> Turn in Elemental War
    .target Tsunaman

step
    .goto Stonetalon Mountains,47.1,61.1
    >>Hand in Bloodfury Bloodline at Maggran Earthbinder
    .turnin -6283 >> Turn in Bloodfury Bloodline
    .target Maggran Earthbinder

step
    .goto Stonetalon Mountains,47.4,58.3
    >>Hand in New Life at Tammra Windfield
    .turnin -6381 >> Turn in New Life
    .target Tammra Windfield
]])

-- ============== 26-30 ASHENVALE / THOUSAND NEEDLES ===================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 26-30 Ashenvale/Thousand Needles (Horde)
#next 30-32 Shimmering Flats (Horde)
<< Horde

step
    .goto Stonetalon Mountains,45.1,59.8
    .fly Orgrimmar >> Fly to Orgrimmar

step << Warrior
    #optional
    .goto Orgrimmar,79.7,31.4
    .trainer >> Train your class abilities

step << Warrior
    #optional
    .goto Orgrimmar,81.5,19.6
    .train 2567 >> Train Thrown from Hanashi

step << Mage
    #optional
    .goto Orgrimmar,38.45,86.13
    >>MAGE (26+): Deino in the Valley of Spirits -- her water errand fills at the Xavian falls east of Splintertree, on this chapter's route; she also refers 30s mages to Tabetha in Dustwallow (the wand chain -- hold it)
    .turnin -1943 >> Turn in Speak with Deino
    .target Deino

step << Mage
    #optional
    .goto Orgrimmar,38.45,86.13
    >>Take Waters of Xavian, Journey to the Marsh at Deino
    .accept 1944,2,1943 >> Accept Waters of Xavian
    .accept 1947,2,1947 >> Accept Journey to the Marsh
    .target Deino

step << Mage
    #optional
    .isOnQuest 1944
    .goto Ashenvale,76.3,41.5
    >>Xavian, the satyr falls upriver east of Splintertree: fill the vial. Deino takes it on the 30-32 chapter's Orgrimmar stop
    .complete -1944,1 --Xavian Water Sample

step
    #completewith SplinterFP
    .goto Orgrimmar,16.2,62.2,30
    >>Out Orgrimmar's west gate, then along the river into Ashenvale
    .goto Ashenvale,94.7,76.8,30
    .goto Ashenvale,88.5,64.9,40
    >>Up the ramps past the lumber camp -- mind the level 28 spiders

step
    #label SplinterFP
    .goto Ashenvale,73.2,61.6
    .fp Splintertree >> Get the Splintertree Post flight path

step
    .goto Ashenvale,73.1,61.5
    >>Splintertree Post: Pixel wants horns; Senani takes the Hunt if you carry it
    .accept 6441 >> Accept Satyr Horns
    .target Pixel

step
    .goto Ashenvale,73.8,61.5
    >>Hand in The Ashenvale Hunt at Senani Thunderheart
    .turnin -6383 >> Turn in The Ashenvale Hunt
    .target Senani Thunderheart

step
    .goto Ashenvale,73.6,60.0
    >>Take Stonetalon Standstill at Mastok Wrilehiss
    .accept 25 >> Accept Stonetalon Standstill
    .target Mastok Wrilehiss

step
    .goto Ashenvale,71.1,68.1
    >>Kuray'bin at the outpost south
    .accept 6503 >> Accept Ashenvale Outrunners
    .target Kuray'bin

step
    .isOnQuest 6503
    .goto Ashenvale,72.5,72.5,40,0
    >>Outrunners skulk stealthed along the road -- nine of them
    .complete 6503,1 --Ashenvale Outrunner (9)
    .unitscan Ashenvale Outrunner

step
    .goto Ashenvale,68.3,75.3
    >>Torek musters south of the road (he respawns slowly if absent)
    .accept 6544 >> Accept Torek's Assault
    .target Torek

step
    .isOnQuest 6544
    .goto Ashenvale,64.6,75.3
    >>Follow Torek's war party to Silverwing Outpost. Waves spawn inside the tower -- let Torek tank, push deep. Abandon if it goes bad
    .complete 6544,1 --Take Silverwing Outpost

step
    .isOnQuest 6441
    .goto Ashenvale,68.2,54.0
    >>North across the river: satyrs of Night Run carry Pixel's horns
    .complete 6441,1 --Satyr Horn (16)

step
    .isOnQuest 1088
    .goto Ashenvale,62.0,51.3
    >>Ordanus keeps a shrine west of Night Run -- burst him down and take his head
    .complete -1088,1 --Ordanus' Head
    .unitscan Keeper Ordanus

step
    .isOnQuest 1195
    .goto Ashenvale,61.3,51.9
    >>Laughing Sisters nearby drop an Etched Phial for Zangen's flame
    .collect 5867,1 --Etched Phial

step
    .goto Ashenvale,62.2,49.6,40,0
    >>Shadumbra the huntress prowls this stretch -- her head starts a quest where it lands
    .collect 16304,1,24 --Shadumbra's Head
    .use 16304
    .accept 24,2,6383 >> Accept Shadumbra's Head
    .unitscan Shadumbra

step
    .isOnQuest 216
    .goto Ashenvale,38.5,36.1,50
    >>Long run west to Thistlefur Village
    .complete 216,1 --Thistlefur Avenger (8)
    .complete 216,2 --Thistlefur Shaman (8)
    .mob Thistlefur Avenger
    .mob Thistlefur Shaman

step
    .isOnQuest 6462
    .goto Ashenvale,38.4,30.6,30
    >>Inside Thistlefur Hold: little chests along the tunnel hold the Troll Charms
    .complete 6462,1 --Troll Charm (8)

step
    .goto Ashenvale,41.5,34.5
    >>Ruul Snowhoof sits caged in the hold -- free him when you're ready to walk him out, and finish furbolgs on the way
    .accept 6482 >> Accept Freedom to Ruul
    .complete 6482,1 --Escort Ruul
    .target Ruul Snowhoof

step
    .goto Ashenvale,41.5,67.4,40,0
    >>Ursangous the great bear patrols clockwise south of the lake -- his paw starts a quest
    .collect 16303,1,23 --Ursangous's Paw
    .use 16303
    .accept 23,2,6383 >> Accept Ursangous's Paw
    .unitscan Ursangous

step
    .goto Ashenvale,48.9,69.6
    >>Mystral Lake: Tideress drifts mid-lake (her globe starts a quest), elementals die for Mastok, and the gazebo wants scouting
    .collect 16408,1,1918 --Befouled Water Globe
    .use 16408
    .accept 1918 >> Accept The Befouled Element
    .complete 25,2 --Scout the gazebo
    .complete 25,1 --Befouled Water Elemental (12)
    .mob Befouled Water Elemental
    .unitscan Tideress

step
    .isOnQuest 1195
    .goto Ashenvale,60.2,72.9
    >>Fill the Etched Phial at the moonwell southeast
    .use 5867
    .complete 1195,1 --Filled Etched Phial

step
    .goto Ashenvale,72.4,72.1,40,0
    >>Sharptalon circles the southern woods -- soften him, kite to the camp if needed, and take the claw
    .collect 16305,1,2 --Sharptalon's Claw
    .use 16305
    .accept 2,2,6383 >> Accept Sharptalon's Claw
    .unitscan Sharptalon

step
    .goto Ashenvale,71.2,68.1
    >>Kuray'bin settles up
    .turnin 6503 >> Turn in Ashenvale Outrunners
    .target Kuray'bin

step
    .goto Ashenvale,73.1,62.5
    >>Splintertree pays its debts: Ertog, Senani, Mastok, Pixel, and Ruul's brother in the inn
    .turnin -6544 >> Turn in Torek's Assault
    .target Ertog Ragetusk

step
    .goto Ashenvale,73.8,61.5
    >>Hand in Sharptalon's Claw, Shadumbra's Head, Ursangous's Paw, The Hunt Completed at Senani Thunderheart
    .turnin -2 >> Turn in Sharptalon's Claw
    .turnin -24 >> Turn in Shadumbra's Head
    .turnin -23 >> Turn in Ursangous's Paw
    .turnin -247 >> Turn in The Hunt Completed
    .target Senani Thunderheart

step
    .goto Ashenvale,73.7,60.0
    >>Hand in Stonetalon Standstill, The Befouled Element; take Je'neu of the Earthen Ring at Mastok Wrilehiss
    .turnin -25 >> Turn in Stonetalon Standstill
    .turnin -1918 >> Turn in The Befouled Element
    .accept 824,2,1918 >> Accept Je'neu of the Earthen Ring
    .target Mastok Wrilehiss

step
    .goto Ashenvale,74.1,60.9
    >>Hand in Freedom to Ruul at Yama Snowhoof
    .turnin -6482 >> Turn in Freedom to Ruul
    .target Yama Snowhoof

step
    .goto Ashenvale,73.1,61.5
    >>Hand in Satyr Horns at Pixel
    .turnin -6441 >> Turn in Satyr Horns
    .target Pixel

step
    .goto Ashenvale,73.2,61.5
    .fly Zoram'gar >> Fly to Zoram'gar Outpost

step
    .goto Ashenvale,11.8,34.5
    >>The Zoram Strand closes three accounts
    .turnin -216 >> Turn in Between a Rock and a Thistlefur
    .goto Ashenvale,11.7,34.8
    .turnin -6462 >> Turn in Troll Charm
    .goto Ashenvale,11.6,34.3
    .turnin -824 >> Turn in Je'neu of the Earthen Ring
    .target Karang Amakkar
    .target Mitsuwa
    .target Je'neu Sancrea

step << Shaman
    #optional
    .isOnQuest 1534
    .goto Ashenvale,33.55,67.47
    >>Carrying the Blue Waterskin? The Ruins of Stardust lie south along the coast then inland -- fill it at the fountain among the ruins
    .complete -1534,1

step
    #optional
    .isQuestComplete 1088
    .goto Ashenvale,11.6,34.4
    >>OPTIONAL: carrying Ordanus' head? Hop a gryphon to Sun Rock and give Braelyn her trophy, then fly on to Thunder Bluff
    .fly Sun Rock >> Fly to Sun Rock Retreat

step
    #optional
    .isQuestComplete 1088
    .goto Stonetalon Mountains,45.9,60.4
    .turnin -1088 >> Turn in Ordanus
    .target Braelyn Firehand

step
    .fly Thunder Bluff >> Fly to Thunder Bluff

step
    .goto Thunder Bluff,55.2,51.5
    >>Zangen takes his filled phial
    .turnin 1195 >> Turn in The Sacred Flame
    .accept 1196 >> Accept The Sacred Flame
    .target Zangen Stonehoof

step
    .isOnQuest 1086
    .goto Thunder Bluff,22.8,20.8
    >>Zamah hears of the fogger's work
    .turnin 1086 >> Turn in The Flying Machine Airport
    .target Apothecary Zamah

step << Shaman
    .xp <30,1
    .goto Thunder Bluff,25.16,20.51
    >>Hit 30 already? Xanis starts your last totem (under 30 this auto-skips -- she's here whenever you get there)
    .accept 1532 >> Accept Call of Air
    .target Xanis Flameweaver

step
    .goto Thunder Bluff,61.0,81.0
    >>Melor Stonehoof on Hunter Rise
    .accept 1131 >> Accept Steelsnap
    .target Melor Stonehoof

step << Warrior
    #optional
    .goto Thunder Bluff,57.4,87.2
    >>Torm Ragetotem in the Hall of the Brave has an island errand -- grab it for later
    .accept 1718 >> Accept The Islander
    .trainer >> Train your class abilities
    .target Torm Ragetotem

step
    .goto Thunder Bluff,46.8,50.1
    .fly Camp Taurajo >> Fly to Camp Taurajo

step << Shaman
    #optional
    .isQuestComplete 1534
    .goto The Barrens,43.42,77.41
    >>Brine, just west off the road: she blesses the full set
    .turnin -1534 >> Turn in Call of Water
    .accept 220,2,1534 >> Accept Call of Water
    .target Brine

step
    .isOnQuest 5881
    .goto The Barrens,44.0,92.0
    >>South out of Taurajo: Grish Longrunner at the border camp
    .turnin 5881 >> Turn in Calling in the Reserves
    .target Grish Longrunner

step
    .goto Thousand Needles,32.2,22.2
    >>Down into Thousand Needles: Brave Moonhorn at the top camp
    .accept 4542 >> Accept Message to Freewind Post
    .target Brave Moonhorn

step
    #sticky
    #completewith messenger
    >>The Galak Messenger rides the canyon roads -- kill him whenever you cross him; his note starts a quest
    .collect 12564,1,4881 --Assassination Note
    .use 12564
    .accept 4881 >> Accept Assassination Plot
    .unitscan Galak Messenger

step
    .goto Thousand Needles,45.9,50.9
    >>Take the lift down and run the mesa tops to Freewind Post. Quests wait all over the post
    .accept 5147 >> Accept WANTED: Arnak Grimtotem

step
    .goto Thousand Needles,46.1,51.7
    >>Hand in The Sacred Flame; take The Sacred Flame at Rau Cliffrunner
    .turnin -1196 >> Turn in The Sacred Flame
    .accept 1197,2,1196 >> Accept The Sacred Flame
    .target Rau Cliffrunner

step
    .goto Thousand Needles,45.6,50.8
    >>Hand in Message to Freewind Post; take Pacify the Centaur at Cliffwatcher Longhorn
    .turnin -4542 >> Turn in Message to Freewind Post
    .accept 4841,2,4542 >> Accept Pacify the Centaur
    .target Cliffwatcher Longhorn

step
    .goto Thousand Needles,44.8,49.1
    >>Take Wind Rider at Elu
    .accept 4767 >> Accept Wind Rider
    .target Elu

step
    .goto Thousand Needles,44.7,50.2
    >>Take Alien Egg at Hagar Lightninghoof
    .accept 4821 >> Accept Alien Egg
    .target Hagar Lightninghoof

step
    .goto Thousand Needles,45.1,49.2
    .fp Freewind Post >> Get the Freewind Post flight path

step
    .goto Thousand Needles,41.3,37.7,40,0
    >>The Galak camps west: Scouts, Wranglers, Windchasers
    .complete -4841,1 --Galak Scout (12)
    .complete -4841,2 --Galak Wrangler (10)
    .complete -4841,3 --Galak Windchaser (6)
    .mob Galak Scout
    .mob Galak Wrangler
    .mob Galak Windchaser

step
    .isOnQuest 1197
    .goto Thousand Needles,42.0,31.5
    >>Into the Galak cave -- keep left at the fork; the brazier at the end holds the Cloven Hoof
    .complete -1197,1 --Cloven Hoof

step
    .goto Thousand Needles,53.9,41.5
    >>Dorn Plainstalker meditates in the northeastern cave
    .accept 1149 >> Accept Test of Faith
    .target Dorn Plainstalker

step << Shaman
    #optional
    .goto Thousand Needles,53.54,42.65
    >>Prate Cloudseer shares Dorn's cave: bring her Call of Air from Xanis (Thunder Bluff) or Searn (Orgrimmar) once you're 30 -- AIR TOTEM
    .turnin -1531 >> Turn in Call of Air
    .turnin -1532 >> Turn in Call of Air
    .target Prate Cloudseer

step
    .isOnQuest 1149
    .goto 1441/1,-2807.13,-5183.71
    >>His test: walk off the end of the wooden plank on Darkcloud Pinnacle, right beside him. You won't die. Probably
    .turnin 1149 >> Turn in Test of Faith

step
    .goto Thousand Needles,53.9,41.7
    >>(Turn-in is back at Dorn if the fall didn't complete it)
    .turnin -1149 >> Turn in Test of Faith
    .accept 1150 >> Accept Test of Endurance
    .target Dorn Plainstalker

step
    #sticky
    #label Kobolds
    #completewith OreDone
    >>Kobolds throughout the needles carry Tatternack's Ore Sample and an Unrefined Ore Sample -- loot both when they drop
    .complete -1153,1 --Ore Sample
    .collect 5842,1 --Unrefined Ore Sample

step
    .isOnQuest 4821
    .goto Thousand Needles,56.3,50.4,20,0
    >>The Alien Egg sits in one of the kobold camps -- a lootable cluster like spider eggs
    .complete 4821,1 --Alien Egg

step
    .goto Thousand Needles,45.6,50.8
    >>Freewind round
    .turnin -4841 >> Turn in Pacify the Centaur
    .accept 5064,2,4841 >> Accept Grimtotem Spying
    .target Cliffwatcher Longhorn

step
    .goto Thousand Needles,46.1,51.7
    >>Hand in The Sacred Flame at Rau Cliffrunner
    .turnin -1197 >> Turn in The Sacred Flame
    .target Rau Cliffrunner

step
    .goto Thousand Needles,44.7,50.3
    >>Hand in Alien Egg; take Serpent Wild at Hagar Lightninghoof
    .turnin -4821 >> Turn in Alien Egg
    .accept 4865,2,4821 >> Accept Serpent Wild
    .target Hagar Lightninghoof

step
    .isOnQuest 1150
    .goto Thousand Needles,27.3,51.2,20
    >>Down from Freewind, into Grenka's cave west: open the crate at the end and kill Grenka Bloodscreech when she objects
    .complete 1150,1 --Grenka's Claw

step
    .isOnQuest 4767
    .goto Thousand Needles,13.9,31.7,25
    >>Up the Highperch paths: wyvern eggs lie loose on the ground -- gather as you climb
    .complete 4767,1 --Highperch Wyvern Egg (10)

step
    .goto Thousand Needles,17.8,40.6
    >>Pao'ka Swiftmountain hides at the top -- walk him out (three wyverns jump you midway), then finish any eggs on the way down
    .accept 4770 >> Accept Homeward Bound
    .complete 4770,1 --Escort Pao'ka
    .target Pao'ka Swiftmountain

step
    .goto Thousand Needles,21.5,32.3
    >>Whitereach Post: Motega and friends
    .turnin -4865 >> Turn in Serpent Wild
    .accept 5062,2,4865 >> Accept Sacred Fire
    .turnin -4770 >> Turn in Homeward Bound
    .goto Thousand Needles,21.6,32.3
    .accept 5151 >> Accept Hypercapacitor Gizmo
    .target Motega Firemane
    .target Wizlo Bearingshiner

step
    #sticky
    #completewith steelsnap
    >>Steelsnap the hyena patrols the western canyon counterclockwise -- rib him when you see him
    .complete 1131,1 --Steelsnap's Rib
    .unitscan Steelsnap

step
    .isOnQuest 5062
    .goto Thousand Needles,37.5,38.4,30,0
    >>Incendia Agave grows yellow around and under the pool east of Whitereach
    .complete -5062,1 --Incendia Agave (10)

step
    #label steelsnap
    .goto Thousand Needles,10.9,23.2,40,0
    >>Sweep the western canyon until Steelsnap falls
    .complete 1131,1 --Steelsnap's Rib
    .unitscan Steelsnap

step
    #label messenger
    .isOnQuest 4881
    .goto Thousand Needles,18.4,22.2,40,0
    >>Still no Assassination Note? The Messenger runs camp-road-camp in the west
    .collect 12564,1,4881 --Assassination Note
    .unitscan Galak Messenger

step
    .goto Thousand Needles,45.1,49.2
    .fly Thunder Bluff >> Fly to Thunder Bluff

step << Warrior
    #optional
    .goto Thunder Bluff,57.6,85.5
    .trainer >> Train your class abilities

step
    .goto Thunder Bluff,61.4,80.8
    >>Melor takes the rib (skip his Frostmaw follow-up -- an elite yeti in Alterac this route never hunts)
    .turnin 1131 >> Turn in Steelsnap
    .target Melor Stonehoof

step
    .goto Thunder Bluff,69.8,30.9
    >>Hand in Sacred Fire; take Arikara at Magatha Grimtotem
    .turnin -5062 >> Turn in Sacred Fire
    .accept 5088,2,5062 >> Accept Arikara
    .target Magatha Grimtotem

step
    .goto Thunder Bluff,46.8,50.1
    .fly Camp Taurajo >> Fly to Camp Taurajo

step
    #optional
    .isOnQuest 1153
    .goto 1441/1,-979.37,-4377.63
    >>Still short on Unrefined Ore Sample? Gibblesnik / Gravelsnout Digger / Gravelsnout Surveyor -- around here. This step skips itself once you have them
    .complete -1153,1 --Ore Sample
    .mob Gibblesnik
    .mob Gravelsnout Digger
    .mob Gravelsnout Surveyor

step
    .isQuestComplete 1153
    .goto The Barrens,45.1,57.6
    >>Tatternack studies the kobold ore
    .turnin -1153 >> Turn in A New Ore Sample
    .target Tatternack Steelforge

step
    .goto The Barrens,44.4,59.0
    .fly Freewind Post >> Fly to Freewind Post

step
    .isOnQuest 4767
    .goto Thousand Needles,44.8,49.0
    >>Elu takes the eggs
    .turnin 4767 >> Turn in Wind Rider
    .target Elu

step
    .goto Thousand Needles,54.0,41.4
    >>Dorn weighs Grenka's claw
    .turnin 1150 >> Turn in Test of Endurance
    .accept 1151 >> Accept Test of Strength
    .target Dorn Plainstalker

step
    .isOnQuest 1151
    .goto Thousand Needles,29.3,33.6,40,0
    >>Rok'Alim the Pounder, a rock elemental, walks a wide circle through the west -- break him apart
    .complete 1151,1 --Fragments of Rok'Alim
    .unitscan Rok'Alim the Pounder

step
    .isOnQuest 5064
    .goto Thousand Needles,32.0,32.6
    >>Darkcloud Pinnacle: climb and cross the rope bridges for the three Secret Notes
    .complete -5064,1 --Secret Note #1

step
    .goto Thousand Needles,33.9,39.9
    >>Secret Note #2
    .complete -5064,2 --Secret Note #2

step
    .goto Thousand Needles,39.3,41.6
    >>Secret Note #3
    .complete -5064,3 --Secret Note #3

step
    .isOnQuest 5088
    .goto Thousand Needles,37.9,35.3
    >>Clear the mobs by the bonfire, light the Sacred Fire of Life, and kill Arikara when the serpent answers
    .use 12785
    .complete -5088,2 --Light the Sacred Fire
    .complete -5088,1 --Arikara Serpent Skin

step
    .isOnQuest 5147
    .goto Thousand Needles,38.6,27.4
    >>Arnak Grimtotem holds the far platform -- take his hoof
    .complete 5147,1 --Arnak's Hoof
    .unitscan Arnak Grimtotem

step
    .goto Thousand Needles,38.1,26.6
    >>Lakota Windsong is held nearby -- walk her off the Pinnacle; grimtotem ambush the bridges
    .accept 4904 >> Accept Free at Last
    .complete 4904,1 --Escort Lakota
    .target Lakota Windsong

step
    .isOnQuest 5151
    .goto Thousand Needles,23.3,23.3
    >>Wizlo's gizmo sits in a cage guarded by a panther -- have cooldowns ready, open, kill, loot
    .complete 5151,1 --Hypercapacitor Gizmo

step
    .isOnQuest 4881
    .goto Thousand Needles,21.3,32.0
    >>Kanati Greycloud must hear of the plot -- and defending him starts the moment you accept his follow-up: three attackers, let him take the first hits
    .turnin 4881 >> Turn in Assassination Plot
    .accept 4966 >> Accept Protect Kanati Greycloud
    .complete 4966,1 --Protect Kanati
    .turnin 4966 >> Turn in Protect Kanati Greycloud
    .target Kanati Greycloud

step
    #label OreDone
    .goto Thousand Needles,21.5,32.3
    >>Whitereach settles up
    .turnin -5088 >> Turn in Arikara
    .turnin -5151 >> Turn in Hypercapacitor Gizmo
    .target Motega Firemane
    .target Wizlo Bearingshiner

step
    .goto Feralas,75.4,44.4
    .fly Freewind Post >> Fly to Freewind Post

step
    .goto Thousand Needles,45.7,50.8
    >>Freewind, last round
    .turnin -5064 >> Turn in Grimtotem Spying
    .turnin -5147 >> Turn in WANTED: Arnak Grimtotem
    .goto Thousand Needles,46.0,51.5
    .turnin -4904 >> Turn in Free at Last
    .target Cliffwatcher Longhorn
    .target Thalia Amberhide

step
    .isQuestComplete 1151
    .goto Thousand Needles,53.9,41.4
    >>Dorn's final verdict
    .turnin 1151 >> Turn in Test of Strength
    .target Dorn Plainstalker

step
    .goto Thousand Needles,77.8,77.2
    >>East across the Shimmering Flats to the Mirage Raceway. Quests ring the track
    .accept 1110 >> Accept Rocket Car Parts
    .accept 1104 >> Accept Salt Flat Venom
    .target Kravel Koalbeard
    .target Fizzle Brassbolts

step
    .goto Thousand Needles,78.1,77.1
    >>Take Hardened Shells at Wizzle Brassbolts, then take Wharfmaster Dizzywig, Hemet Nesingwary at Kravel Koalbeard
    .accept 1105 >> Accept Hardened Shells
    .accept 1111 >> Accept Wharfmaster Dizzywig
    .accept 5762 >> Accept Hemet Nesingwary Jr.
    .target Kravel Koalbeard
    .target Wizzle Brassbolts

step
    .goto Thousand Needles,80.2,75.8
    >>Take Load Lightening at Pozzik
    .accept 1176 >> Accept Load Lightening
    .target Pozzik

step
    .goto Thousand Needles,81.7,78.0
    >>Take A Bump in the Road at Trackmaster Zherin
    .accept 1175 >> Accept A Bump in the Road
    .target Trackmaster Zherin

step
    #sticky
    #label Carapace
    #completewith TurnIn86
    >>Grinding silithids here can shake loose a Cracked Silithid Carapace -- click it for a quest
    .collect 5877,1,1148 --Cracked Silithid Carapace
    .use 5877
    .accept 1148 >> Accept Parts of the Swarm

step
    .goto Thousand Needles,78.4,89.1
    >>The salt flats feed every list at once: basilisks, crystalhides, gazers, scorpids, vultures, tortoises
    .complete -1175,3 --Saltstone Gazer (6)
    .complete -1175,1 --Saltstone Basilisk (10)
    .complete -1175,2 --Saltstone Crystalhide (10)
    .complete -1110,1 --Rocket Car Parts (30)
    .complete -1104,1 --Salty Scorpid Venom (6)
    .complete -1176,1 --Hollow Vulture Bone (10)
    .complete -1105,1 --Hardened Tortoise Shell (9)
    .mob Saltstone Basilisk
    .mob Saltstone Crystalhide
    .mob Saltstone Gazer
    .mob Scorpid Reaver
    .mob Salt Flats Vulture
    .mob Salt Flats Scavenger
    .mob Sparkleshell Tortoise

step
    .isOnQuest 1148
    .goto Thousand Needles,67.8,85.7
    >>The hive in the flats' southwest corner fills the carapace order
    .complete -1148,1 --Silithid Heart
    .complete -1148,2 --Silithid Talon (5)
    .complete -1148,3 --Intact Silithid Carapace (3)
    .mob Silithid Searcher
    .mob Silithid Invader
    .mob Silithid Hive Drone

step
    .goto Thousand Needles,77.8,77.2
    >>Raceway payday
    .turnin -1110 >> Turn in Rocket Car Parts
    .turnin -1104 >> Turn in Salt Flat Venom
    .target Kravel Koalbeard
    .target Fizzle Brassbolts

step
    .goto Thousand Needles,78.1,77.1
    >>Hand in Hardened Shells at Wizzle Brassbolts
    .turnin -1105 >> Turn in Hardened Shells
    .target Wizzle Brassbolts

step
    .goto Thousand Needles,80.2,75.8
    >>Hand in Load Lightening; take Goblin Sponsorship at Pozzik
    .turnin -1176 >> Turn in Load Lightening
    .accept 1178,2,1176 >> Accept Goblin Sponsorship
    .target Pozzik

step
    #label FlatsDone
    .goto Thousand Needles,81.6,78.0
    >>Hand in A Bump in the Road at Trackmaster Zherin
    .turnin -1175 >> Turn in A Bump in the Road
    .target Trackmaster Zherin

step
    .goto Tanaris,51.6,25.4
    >>A short run south banks Gadgetzan's flight path for the decades ahead
    .fp Gadgetzan >> Get the Gadgetzan flight path

step
    .goto Tanaris,51.6,25.4
    .fly Freewind Post >> Fly to Freewind Post

step
    .goto Thousand Needles,45.1,49.2
    .fly Crossroads >> Fly to Crossroads (connects through Camp Taurajo)

step
    #label TurnIn86
    .isOnQuest 1148
    .goto The Barrens,51.1,29.6
    >>Korran reads the silithid remains
    .turnin 1148 >> Turn in Parts of the Swarm
    .accept 1184 >> Accept Parts of the Swarm
    .target Korran

step
    .goto The Barrens,51.5,30.3
    .fly Ratchet >> Fly to Ratchet

step
    .isOnQuest 1111
    .goto The Barrens,63.3,38.4
    >>Wharfmaster Dizzywig at the docks
    .turnin 1111 >> Turn in Wharfmaster Dizzywig
    .accept 1112 >> Accept Parts for Kravel
    .target Wharfmaster Dizzywig

step
    .isOnQuest 874
    .goto The Barrens,65.8,43.8
    >>Mahren Skyseer waits south along the shore -- her vengeance has a name now
    .turnin -874 >> Turn in Mahren Skyseer
    .accept 873,2,874 >> Accept Isha Awak
    .target Mahren Skyseer

step
    .isOnQuest 873
    .goto The Barrens,65.6,47.1,40,0
    >>Isha Awak, the red threshadon, hunts these waters. Fight it in the shallows and cut out its heart
    .complete -873,1 --Heart of Isha Awak
    .unitscan Isha Awak

step << Warrior
    .isOnQuest 1718
    .goto The Barrens,68.6,49.2
    >>Swim to Fray Island: Klannoc Macleod runs the fights. Step on the grate, survive the Affray, and drop Big Will
    .turnin 1718 >> Turn in The Islander
    .accept 1719 >> Accept The Affray
    .complete 1719,1 --Begin the Affray
    .complete 1719,2 --Big Will
    .turnin 1719 >> Turn in The Affray
    .target Klannoc Macleod

step
    .isQuestComplete 873
    .goto The Barrens,65.8,43.8
    .turnin -873 >> Turn in Isha Awak
    .target Mahren Skyseer

step << Shaman
    .goto The Barrens,65.83,43.78
    >>Islen, a few steps over: the purest water goes home
    .turnin -220 >> Turn in Call of Water
    .accept 63,2,220 >> Accept Call of Water
    .target Islen Waterseer

step << Shaman
    #optional
    .isOnQuest 63
    .goto Silverpine Forest,38.26,44.56
    >>For your next trip east: on the Lordamere lakeshore east of the Sepulcher, defeat the Corrupt Minor Manifestation of Water and set the bracers at the Brazier of Everfount -- WATER TOTEM
    .turnin -63 >> Turn in Call of Water
    .mob Corrupt Minor Manifestation of Water

step << Warlock
    .goto The Barrens,62.63,35.5
    >>Warlocks -- you're 30: Strahad Farsan on Ratchet's bluff starts the felhunter. The tome chain is a project; these steps wait with you
    .accept 1801 >> Accept Tome of the Cabal
    .target Strahad Farsan

step << Warlock
    #optional
    .isOnQuest 1801
    .goto Undercity,75.92,37.89
    >>Next zeppelin east: Jorah Annison in the Undercity's book corner
    .turnin 1801 >> Turn in Tome of the Cabal
    .accept 1803 >> Accept Tome of the Cabal
    .target Jorah Annison

step << Warlock
    #optional
    .isOnQuest 1803
    +The Moldy Tome lies on Purgation Isle in Lordamere Lake, southwest Hillsbrad (Hillsbrad Foothills,27.8,72.8) -- elite guards, bring company. The Tattered Manuscript sits in a Damaged Chest in northwest Thousand Needles (Thousand Needles,43.4,32.7).
    .collect 6931,1,1803 --Moldy Tome
    .collect 6997,1,1803 --Tattered Manuscript

step << Warlock
    #optional
    .isOnQuest 1803
    .goto Undercity,75.92,37.89
    >>Jorah reconstructs the tome
    .turnin -1803 >> Turn in Tome of the Cabal
    .accept 1805,2,1803 >> Accept Tome of the Cabal
    .target Jorah Annison

step << Warlock
    #optional
    .isOnQuest 1805
    +3 Rods of Channeling drop from the Dragonmaw clan at Angerfang Encampment, the Wetlands -- rough at 30, easy by 33
    .collect 6930,3,1805 --Rod of Channeling (3)

step << Warlock
    #optional
    .isOnQuest 1805
    .goto The Barrens,62.63,35.5
    >>Strahad takes the tome -- summon and subdue the FELHUNTER
    .turnin -1805 >> Turn in Tome of the Cabal
    .accept 1795 >> Accept The Binding
    .complete 1795,1
    .turnin 1795 >> Turn in The Binding
    .target Strahad Farsan

step
    .goto The Barrens,62.6,37.5
    .xp 30 >> Grind Ratchet's coast or the flats hive to level 30

step
    +Chapter complete at 30 -- the 30-32 Shimmering Flats chapter picks up right here at Ratchet. Riding along: Frostmaw (1136), Parts of the Swarm (1184), Parts for Kravel (1112), Goblin Sponsorship (1178), Hemet Nesingwary Jr. (5762), Chief Engineer Scooty (2842, Booty Bay), Jin'Zil's Forest Magic (1058, turn in at Malaka'jin if you ever finish his list), plus Forever customs 79007 and 97003
    +This chunk is fresh from the quest database -- if a step misbehaves, note it and report back.
]])
