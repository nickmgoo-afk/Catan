--  RXPGuides_ForeverWarrior - Horde 30-35
--  Built from the Forever quest database (no free-guide skeleton exists past 30).
--  Chunks: 30-32 Shimmering Flats > 32-34 Hillsbrad/Arathi > 34-36 Desolace.
--  All coordinates are zone percents from NPC spawn data; farm areas marked
--  VERIFY are centroids of spawn clusters -- expect to roam.

-- ================== 30-32 SHIMMERING FLATS ===========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 30-32 Shimmering Flats (Horde)
#next 32-34 Hillsbrad/Arathi (Horde)
<< Horde

step
    .goto The Barrens,62.7,36.2
    >>Ratchet, where you left off: Gazlowe upstairs takes the Sponsorship papers and sends you toward Booty Bay -- that leg rides along until the Stranglethorn chapter
    .turnin -1178 >> Turn in Goblin Sponsorship
    .accept 1180,2,1178 >> Accept Goblin Sponsorship
    .target Gazlowe

step << Warrior
    #optional
    .goto The Barrens,68.6,49.2
    >>OPTIONAL warriors: swim back out to Fray Island -- Klannoc starts the Whirlwind weapon chain (its wind sage lives by Tarren Mill, where we're headed next chapter)
    .turnin -1719 >> Turn in The Affray
    .accept 1791 >> Accept The Windwatcher
    .target Klannoc Macleod

step << Warrior
    .goto The Barrens,57.2,30.3
    >>Ride northwest: Thun'grim Firegaze on his mountain ledge -- your banked letter from the starter finally pays out. Train anything he offers (skip his Brutal Armor project -- it wants 15 Smoky Iron Ingots and other smithed goods this route never gathers)
    .turnin -1502 >> Turn in Thun'grim Firegaze
    .turnin -1825 >> Turn in Speak with Thun'grim
    .target Thun'grim Firegaze

step << Warrior
    #optional
    .goto The Barrens,57.2,30.3
    >>If Thun'grim offers his errands now, take the two 'speak with' hops: Velora Nitely in the Undercity and Orm Stonehoof in Thunder Bluff (skip Ula'elek's -- Durotar is off this route)
    .accept 1840,2,1848 >> Accept Orm Stonehoof and the Brutal Helm
    .accept 1841,2,1848 >> Accept Velora Nitely and the Brutal Legguards
    .target Thun'grim Firegaze

step
    .goto The Barrens,51.9,30.2
    >>Down to the Crossroads and fly south
    .fly Freewind Post >> Fly to Freewind Post

step << Shaman
    #optional
    .goto Thousand Needles,53.54,42.65
    >>Shamans: if Call of Air is still open (or you never grabbed it from Xanis in Thunder Bluff), Prate Cloudseer sits in the cave northeast of Whitereach -- AIR TOTEM before the Flats
    .turnin -1531 >> Turn in Call of Air
    .turnin -1532 >> Turn in Call of Air
    .target Prate Cloudseer

step
    .goto Thousand Needles,54.0,41.5
    >>Dorn, one ledge over, has a last test: a question-and-answer trail that pays hand-in XP at every stop. Take it -- the stops line up with our route
    .accept 1152 >> Accept Test of Lore
    .target Dorn Plainstalker

step << Warlock
    #optional
    .isOnQuest 1803
    .goto Thousand Needles,43.4,32.7
    >>Carrying Jorah's tome errand? The Damaged Chest with the Tattered Manuscript sits in the northwest canyons -- grab it now while you're in the Needles
    .collect 6997,1,1803 --Tattered Manuscript

step
    .goto Thousand Needles,77.8,77.3
    >>Down the Great Lift's far cousin: ride southeast into the salt. Kravel Koalbeard at the Mirage Raceway takes his parts, and his follow-ups chain fast
    .turnin 1112 >> Turn in Parts for Kravel
    .accept 1114 >> Accept Delivery to the Gnomes
    .target Kravel Koalbeard

step
    .goto Thousand Needles,78.1,77.1
    >>Fizzle Brassbolts, across the track on the gnome side
    .turnin 1114 >> Turn in Delivery to the Gnomes
    .accept 1106,2,1104 >> Accept Martek the Exiled
    .target Fizzle Brassbolts

step
    .goto Thousand Needles,77.8,77.3
    >>Back to Kravel: his rumor run banks for Booty Bay, two chapters out
    .accept 1115 >> Accept The Rumormonger
    .target Kravel Koalbeard

step
    .goto Thousand Needles,78.1,77.1
    >>Work the racetrack board: Wizzle wants basilisk fins, the goblins want scorpid venom and turtle shells
    .accept 1107,2,1104 >> Accept Encrusted Tail Fins
    .target Wizzle Brassbolts

step
    .goto 1441/1,-3867.97,-6229.15
    >>Salt Flat Venom and Hardened Shells hang on the racetrack boards nearby -- if you didn't bank them at Freewind, the goblins by the track offer them
    .accept 1104,2,1104 >> Accept Salt Flat Venom
    .accept 1105,2,1105 >> Accept Hardened Shells

step
    .goto Thousand Needles,76.6,56.0
    >>North end of the flats: Saltstone Basilisks drop 10 Encrusted Tail Fins -- gnawed ones don't count, keep killing
    .complete -1107,1 --Encrusted Tail Fin (10)
    .mob Saltstone Basilisk
    .mob Saltstone Crystalhide

step
    .goto Thousand Needles,83.0,65.0
    >>East among the dunes: Scorpid Reavers and Terrors for the venom glands
    .complete -1104,1 --Salty Scorpid Venom
    .mob Scorpid Reaver
    .mob Scorpid Terror

step
    .goto Thousand Needles,80.0,70.0
    >>Sparkleshell Tortoises along the dried shoreline carry the shells
    .complete -1105,1 --Hardened Tortoise Shell
    .mob Sparkleshell Tortoise

step
    .goto Thousand Needles,78.1,77.1
    >>Hand the lot back across the raceway
    .turnin -1104 >> Turn in Salt Flat Venom
    .turnin -1105 >> Turn in Hardened Shells
    .turnin -1107 >> Turn in Encrusted Tail Fins
    .target Wizzle Brassbolts
    .target Fizzle Brassbolts

step
    .goto Thousand Needles,45.7,50.7
    >>Ride back up the canyon to Freewind: Cliffwatcher Longhorn has a report bound for Desolace -- exactly where we're going
    .accept 5361 >> Accept Family Tree
    .target Cliffwatcher Longhorn

step
    .goto Thousand Needles,46.0,51.0
    .xp 32 >> Grind the canyon mobs to 32 if the Flats board didn't get you there (harpies and stalkers around Splithoof pay fine)

step
    .goto Thousand Needles,45.9,50.6
    >>Fly out -- the Eastern Kingdoms swing is next
    .fly Orgrimmar >> Fly to Orgrimmar

step << Mage
    #optional
    .isQuestComplete 1944
    .goto Orgrimmar,38.45,86.13
    >>MAGE: Deino in the Valley of Spirits takes the Xavian water while you pass through. Her Laughing Sisters follow-up sends you back to Ashenvale's dryads -- skip it
    .turnin -1944 >> Turn in Waters of Xavian
    .target Deino

step
    .goto Durotar,50.8,13.8
    >>Zeppelin east to Tirisfal
    .zone Tirisfal Glades >> Zeppelin to Tirisfal Glades
]])

-- ================== 32-34 HILLSBRAD / ARATHI =========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 32-34 Hillsbrad/Arathi (Horde)
#next 34-36 Desolace (Horde)
<< Horde

step
    .goto Tirisfal Glades,61.0,59.0,30,0
    >>Into the Undercity: the Apothecarium first. Master Apothecary Faranell continues the Elixir of Agony -- his list wants a Strong Troll's Blood Potion (auction house or any alchemist) plus murloc parts we'll farm on the coast
    .goto Undercity,48.8,69.3
    .accept 515 >> Accept Elixir of Agony
    .target Master Apothecary Faranell

step
    #optional
    .isOnQuest 1159
    .goto Undercity,57.8,65.4
    >>Dorn's trail: Parqual Fintallas in the Apothecarium answers for the dead (answer his question honestly; ask again if you miss). Skip his Final Passage follow-up
    .turnin -1159 >> Turn in Test of Lore
    .accept 6628,2,1160 >> Accept Test of Lore
    .target Parqual Fintallas

step
    #optional
    .goto Undercity,57.8,65.4
    >>Hand in Test of Lore at Parqual Fintallas
    .turnin -6628 >> Turn in Test of Lore
    .target Parqual Fintallas

step << Warlock
    #optional
    .isOnQuest 1801
    .goto Undercity,75.92,37.89
    >>Carrying Strahad's errand? Jorah Annison is in the book corner -- hand it over and his tome hunt opens (the manuscript chest is in Thousand Needles, the moldy tome on Purgation Isle -- we pass Hillsbrad's lake this chapter)
    .turnin -1801 >> Turn in Tome of the Cabal
    .target Jorah Annison

step << Warlock
    #optional
    .goto Undercity,75.92,37.89
    >>Take Tome of the Cabal at Jorah Annison
    .accept 1803,2,1801 >> Accept Tome of the Cabal
    .target Jorah Annison

step << Warrior
    #optional
    .isOnQuest 1841
    .goto Undercity,62.1,39.1
    >>Brutal Legguards: Velora Nitely takes her introduction (skip her Dragonmaw Shinbones follow-up -- off this route)
    .turnin -1841 >> Turn in Velora Nitely and the Brutal Legguards
    .target Velora Nitely

step
    .goto Undercity,63.3,48.6
    >>Out to the bat roost and south
    .fly Tarren Mill >> Fly to Tarren Mill

step
    .goto Hillsbrad Foothills,63.2,20.7
    >>Tarren Mill's war board, round three. Krusk opens two threads: the Kolkar matter points to the Barrens, the infiltration to the hills here
    .accept 1361 >> Accept Regthar Deathgate
    .accept 533,2,498 >> Accept Infiltration
    .target Krusk

step
    .goto Hillsbrad Foothills,62.3,20.4
    >>Darthalia wants Dun Garok broken; Humbert lost his sword there. The keeper and the magus add their own lists
    .accept 541 >> Accept Battle of Hillsbrad
    .goto Hillsbrad Foothills,62.8,20.2
    .accept 547 >> Accept Humbert's Sword
    .goto Hillsbrad Foothills,61.5,20.9
    .accept 556 >> Accept Stone Tokens
    .goto Hillsbrad Foothills,61.6,20.9
    .accept 544 >> Accept Prison Break In
    .target High Executor Darthalia
    .target Deathguard Humbert
    .target Keeper Bel'varil
    .target Magus Wordeen Voidglare

step
    .goto Hillsbrad Foothills,63.9,19.7
    >>Novice Thaivand by the forge, and Tallow with ogre trouble
    .accept 552 >> Accept Helcular's Revenge
    .target Novice Thaivand

step
    .goto Hillsbrad Foothills,61.9,19.6
    >>Take The Hammer May Fall at Tallow
    .accept 676 >> Accept The Hammer May Fall
    .target Tallow

step << Shaman
    #optional
    .isOnQuest 1536
    .goto Hillsbrad Foothills,61.8,19.5
    >>Still hauling Brine's Red Waterskin? The well is right here by the inn -- fill it
    .complete -1536,1 --Filled Red Waterskin

step << Warrior
    #optional
    .goto 1416/0,-1470.67,250.83
    >>Whirlwind chain: ford the river east -- Bath'rah the Windwatcher keeps his ruin on the Alterac bank. Hand in what you carry; skip his Cyclonian follow-up -- a level 40 errand off this route
    .turnin -1791 >> Turn in The Windwatcher
    .target Bath'rah the Windwatcher

step
    .goto Hillsbrad Foothills,64.0,82.0
    >>The southern coast: Daggerspine murlocs carry the scales, Torn Fin the eyes -- work the surf line both ways
    .complete 515,2 --Daggerspine Scale (5)
    .complete 515,3 --Torn Fin Eye (5)
    .mob Daggerspine Shorestalker
    .mob Daggerspine Siren
    .mob Torn Fin Tidehunter
    .mob Torn Fin Oracle

step
    .goto Hillsbrad Foothills,71.5,79.8
    >>Dun Garok, the dwarf hold on the far point: 8 Mountaineers, 4 Riflemen, 2 Priests, and Captain Ironhill in the bunker -- Humbert's sword hangs inside too. Pull to the ramp, the rooms chain fast
    .complete 541,1 --Mountaineers (8)
    .complete 541,2 --Riflemen (4)
    .complete 541,3 --Priests (2)
    .complete 541,4 --Captain Ironhill
    .complete 547,1 --Humbert's Sword
    .mob Dun Garok Mountaineer
    .mob Dun Garok Rifleman
    .mob Dun Garok Priest
    .unitscan Captain Ironhill

step
    .goto Hillsbrad Foothills,62.3,20.4
    >>Back north with the proof
    .turnin 541 >> Turn in Battle of Hillsbrad
    .accept 550 >> Accept Battle of Hillsbrad
    .goto Hillsbrad Foothills,62.8,20.2
    .turnin 547 >> Turn in Humbert's Sword
    .target High Executor Darthalia
    .target Deathguard Humbert

step
    .goto Hillsbrad Foothills,61.4,19.1
    >>Lydon takes Faranell's list (the Strong Troll's Blood Potion, the scales and the eyes) and wants one thing more: a keg of Shindigger Stout -- the dwarves keep it in Dun Garok, Hillsbrad's southeast corner
    .turnin 515 >> Turn in Elixir of Agony
    .accept 517 >> Accept Elixir of Agony
    .target Apothecary Lydon

step
    #optional
    .isOnQuest 517
    .goto Hillsbrad Foothills,72.0,80.5
    >>Dun Garok, the dwarven hold in Hillsbrad's southeast corner: the Shindigger Stout kegs sit inside -- in and out, the dwarves bite
    .complete 517,1 --Keg of Shindigger Stout

step
    .isQuestComplete 517
    .goto Hillsbrad Foothills,61.4,19.1
    >>Lydon taints the keg; it goes on the rug before the captured farmers -- they're held right here in town. Grim work, strong XP
    .turnin 517 >> Turn in Elixir of Agony
    .accept 524 >> Accept Elixir of Agony
    .target Apothecary Lydon

step
    .goto Hillsbrad Foothills,62.0,19.3
    >>Place the Tainted Keg on the captured farmers' rug, then hand it in at the Dusty Rug
    .complete -524,1 --Place the Tainted Keg
    .turnin -524 >> Turn in Elixir of Agony

step
    .goto Hillsbrad Foothills,44.0,26.5
    >>Northwest hills: the yeti cave. Ferocious Yetis drop Helcular's Rod from their chewed hoard
    .complete 552,1 --Helcular's Rod
    .mob Ferocious Yeti
    .mob Mountain Yeti

step
    .goto Alterac Mountains,20.9,58.7
    >>Just north over the Alterac line: the Dalaran internment camps. Their shield guards, summoners and workers carry Bel'varil's 10 Worn Stone Tokens
    .complete 556,1 --Worn Stone Token (10)
    .mob Dalaran Shield Guard
    .mob Dalaran Summoner
    .mob Dalaran Worker

step
    .goto Hillsbrad Foothills,63.9,19.7
    >>Thaivand charges the rod. Skip the Helcular's Revenge errand after it -- its flames and the Southshore grave run off this route
    .turnin 552 >> Turn in Helcular's Revenge
    .target Novice Thaivand

step
    .goto Hillsbrad Foothills,61.5,20.9
    >>Keeper Bel'varil counts tokens and asks for bracers from the Dalaran camps -- next stop anyway
    .turnin 556 >> Turn in Stone Tokens
    .accept 557 >> Accept Bracers of Binding
    .target Keeper Bel'varil

step
    .goto Alterac Mountains,21.1,58.9
    >>North into Alterac's foothills: the Dalaran internment camps. Elemental Slaves drop Bel'varil's Bracers of Earth Binding
    .complete 557,1 --Bracers of Earth Binding (4)
    .mob Elemental Slave

step
    .goto Alterac Mountains,19.6,85.0
    >>South along Dalaran's wall: the four traitors -- Dermot, Ricter, Alina and Kegan Darkmar -- each carry one Bloodstone piece for Voidglare
    .complete 544,1 --Bloodstone Wedge
    .complete 544,2 --Bloodstone Marble
    .complete 544,3 --Bloodstone Shard
    .complete 544,4 --Bloodstone Oval
    .mob Dermot
    .mob Ricter
    .mob Alina
    .mob Kegan Darkmar

step
    #optional
    .isOnQuest 533
    .goto Alterac Mountains,47.8,81.7
    >>Krusk's intelligence: the Syndicate Footpads and Thieves in the southern Alterac hills carry a Syndicate Missive
    .complete -533,1 --Syndicate Missive
    .mob Syndicate Footpad
    .mob Syndicate Thief

step
    .goto Hillsbrad Foothills,61.6,20.9
    >>Voidglare pays out and doubles down
    .turnin 544 >> Turn in Prison Break In
    .accept 545 >> Accept Dalaran Patrols
    .goto Hillsbrad Foothills,61.5,20.9
    .turnin 557 >> Turn in Bracers of Binding
    .target Magus Wordeen Voidglare
    .target Keeper Bel'varil

step
    .goto Alterac Mountains,20.0,70.0
    >>Back through the camps: 6 Summoners, 12 Slaves for the patrol tally
    .complete 545,1 --Dalaran Summoner (6)
    .complete 545,2 --Elemental Slave (12)
    .mob Dalaran Summoner
    .mob Elemental Slave

step
    .isOnQuest 533
    .goto Hillsbrad Foothills,63.2,20.7
    >>Krusk reads the camp papers and asks you to free the source himself
    .turnin -533 >> Turn in Infiltration
    .accept 503,2,533 >> Accept Gol'dir
    .target Krusk

step
    .isOnQuest 503
    .goto Alterac Mountains,60.0,43.7
    >>East Alterac: Gol'dir is held in the cave behind Strahnbrad -- cut him loose and hear him out (ogres on the slope run 35+; hug the east path)
    .turnin -503 >> Turn in Gol'dir
    .accept 506,2,503 >> Accept Blackmoore's Legacy
    .target Gol'dir

step
    .goto Hillsbrad Foothills,63.2,20.7
    >>Krusk takes Blackmoore's papers; the magus hears his patrol count. That's Tarren Mill settled
    .turnin -506 >> Turn in Blackmoore's Legacy
    .target Krusk

step
    .goto Hillsbrad Foothills,61.6,20.9
    >>Hand in Dalaran Patrols at Magus Wordeen Voidglare
    .turnin -545 >> Turn in Dalaran Patrols
    .target Magus Wordeen Voidglare

step
    .goto Arathi Highlands,32.5,44.3
    >>Boulderfist Outpost in western Arathi, on the way to Hammerfall: Tallow's count -- 8 Ogres, 10 Enforcers -- then carry the word to Hammerfall yourself
    .complete 676,1 --Boulderfist Ogre (8)
    .complete 676,2 --Boulderfist Enforcer (10)
    .mob Boulderfist Ogre
    .mob Boulderfist Enforcer

step
    .goto Arathi Highlands,73.0,33.0
    >>Through Thoradin's Wall into Arathi, northeast to Hammerfall. Grab the flight first
    .fp Hammerfall >> Get the Hammerfall flight path

step
    .goto Arathi Highlands,74.2,33.9
    >>Drum Fel takes Tallow's warning and turns it into a war
    .turnin 676 >> Turn in The Hammer May Fall
    .accept 677 >> Accept Call to Arms
    .target Drum Fel

step
    .goto Arathi Highlands,72.6,33.9
    >>Gor'mul by the gate, then Tor'gan inside -- the shaman's raptor rites carry this stretch
    .accept 655 >> Accept Hammerfall
    .target Gor'mul

step
    .goto Arathi Highlands,74.7,36.3
    >>Hand in Hammerfall; take Raising Spirits, Foul Magics at Tor'gan
    .turnin -655 >> Turn in Hammerfall
    .accept 672,2,655 >> Accept Raising Spirits
    .accept 671 >> Accept Foul Magics
    .target Tor'gan

step
    .goto Arathi Highlands,35.0,40.0
    >>Sweep west across the highlands: Highland Striders and Thrashers drop 10 Raptor Eyes -- they roam the whole basin, kill as you travel
    .complete -672,1 --Highland Raptor Eye (10)
    .mob Highland Strider
    .mob Highland Thrasher

step
    .goto Arathi Highlands,69.5,78.0
    >>South to the Witherbark villages: Drum Fel's tally (10 Axe Throwers, 10 Headhunters, 8 Witch Doctors) and Tor'gan's 10 Bloodstone Amulets come from the same trolls
    .complete 677,1 --Witherbark Axe Thrower (10)
    .complete 677,2 --Witherbark Headhunter (10)
    .complete 677,3 --Witherbark Witch Doctor (8)
    .mob Witherbark Axe Thrower
    .mob Witherbark Headhunter
    .mob Witherbark Witch Doctor

step
    .goto Arathi Highlands,33.2,30.2
    >>Bloodstone Amulet (10)
    .complete -671,1 --Bloodstone Amulet (10)
    .mob Witherbark Axe Thrower
    .mob Witherbark Headhunter
    .mob Witherbark Witch Doctor

step
    .goto Arathi Highlands,74.7,36.3
    >>Hammerfall pays: Tor'gan's amulet goes to Gor'mul and back -- free hand-in XP
    .turnin 671 >> Turn in Foul Magics
    .turnin -672 >> Turn in Raising Spirits
    .accept 674,2,672 >> Accept Raising Spirits
    .target Tor'gan

step
    .goto Arathi Highlands,72.6,33.9
    >>Hand in Raising Spirits; take Raising Spirits at Gor'mul
    .turnin -674 >> Turn in Raising Spirits
    .accept 675,2,674 >> Accept Raising Spirits
    .target Gor'mul

step
    .goto Arathi Highlands,74.7,36.3
    >>Hand in Raising Spirits at Tor'gan
    .turnin -675 >> Turn in Raising Spirits
    .target Tor'gan

step
    .goto Arathi Highlands,74.2,33.9
    >>Drum Fel again: the ogres are next
    .turnin 677 >> Turn in Call to Arms
    .accept 678 >> Accept Call to Arms
    .target Drum Fel

step
    .goto Arathi Highlands,54.0,79.0
    >>Southwest to the Boulderfist dens: 10 Brutes, 4 Magi (Boulderfist Magus) among the rocks
    .complete 678,1 --Boulderfist Brute (10)
    .complete 678,2 --Boulderfist Magi (4)
    .mob Boulderfist Brute
    .mob Boulderfist Magus

step
    .goto Arathi Highlands,74.2,33.9
    >>Drum Fel holds the next round for 38 -- it banks. So does Stromgarde; we come back for both
    .turnin 678 >> Turn in Call to Arms
    .target Drum Fel

step
    .goto Arathi Highlands,74.2,33.9
    >>Take Call to Arms at Drum Fel
    .accept 679,2,678 >> Accept Call to Arms
    .target Drum Fel

step
    .goto Arathi Highlands,73.0,33.5
    .xp 34 >> Shy of 34? Highland raptors and the ogre dens pay well -- round off before flying out

step
    .goto Arathi Highlands,74.0,34.0
    >>Fly back west the long way: Hammerfall to the Undercity, zeppelin home
    .fly Undercity >> Fly to Undercity

step
    .isOnQuest 550
    .goto Undercity,56.2,92.2
    >>Deliver Darthalia's commendation to Varimathras at the Royal Quarter before you leave -- the Dark Lady's court pays well for Dun Garok
    .turnin 550 >> Turn in Battle of Hillsbrad
    .target Varimathras

step
    .goto Tirisfal Glades,60.6,58.7
    >>Zeppelin back to Orgrimmar -- Desolace is next
    .zone Durotar >> Zeppelin to Orgrimmar
]])

-- ====================== 34-36 DESOLACE ===============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 34-36 Desolace (Horde)
#next 36-38 Stranglethorn/Dustwallow (Horde)
<< Horde

step
    .goto Durotar,45.1,13.7
    .fly Crossroads >> Fly to the Crossroads

step
    .goto The Barrens,45.3,28.4
    >>West along the Stonetalon road: Regthar Deathgate holds the bunker by the Kolkar fields -- Krusk's letter finds its mark
    .turnin 1361 >> Turn in Regthar Deathgate
    .accept 1362 >> Accept The Kolkar of Desolace
    .target Regthar Deathgate

step
    #optional
    .isOnQuest 1152
    .goto Stonetalon Mountains,78.8,45.7
    >>OPTIONAL, on the climb through Stonetalon: Braug Dimspirit waits at the Talondeep Path mouth for Dorn's test. Answer, fetch the Legacy of the Aspects nearby, answer again -- three hand-ins before Desolace
    .turnin -1152 >> Turn in Test of Lore
    .target Braug Dimspirit

step
    #optional
    .goto Stonetalon Mountains,78.8,45.7
    >>Take Test of Lore at Braug Dimspirit
    .accept 1154,2,1152 >> Accept Test of Lore
    .target Braug Dimspirit

step
    #optional
    .goto Stonetalon Mountains,78.8,45.7
    >>Legacy of the Aspects, then hand in Test of Lore at Braug Dimspirit
    .complete -1154,1 --Legacy of the Aspects
    .turnin -1154 >> Turn in Test of Lore
    .target Braug Dimspirit

step
    #optional
    .goto Stonetalon Mountains,78.8,45.7
    >>Take Test of Lore at Braug Dimspirit
    .accept 6627,2,1154 >> Accept Test of Lore
    .target Braug Dimspirit

step
    #optional
    .goto Stonetalon Mountains,78.8,45.7
    >>Hand in Test of Lore at Braug Dimspirit
    .turnin -6627 >> Turn in Test of Lore
    .target Braug Dimspirit

step
    #optional
    .goto Stonetalon Mountains,78.8,45.7
    >>Take Test of Lore at Braug Dimspirit
    .accept 1159,2,6627 >> Accept Test of Lore
    .target Braug Dimspirit

step
    .goto Desolace,66.0,8.0
    >>Through the Charred Vale pass into Desolace -- follow the road south
    .zone Desolace

step
    .goto Desolace,56.2,59.6
    >>Ghost Walker Post, the tauren outpost in the grey heart (no flight master here -- Desolace's Horde flight is at Shadowprey Village, later this chapter). Felgur Twocuts opens the centaur war; Gurda beside him offers a choice of khans
    .turnin 1362 >> Turn in The Kolkar of Desolace
    .accept 1365 >> Accept Khan Dez'hepah
    .goto Desolace,56.3,59.7
    .accept 1367 >> Accept Magram Alliance
    .target Felgur Twocuts
    .target Gurda Wildmane

step
    .goto Desolace,55.4,55.8
    >>Nataka Longhorn takes Cliffwatcher's report and adds a fishing errand
    .turnin 5361 >> Turn in Family Tree
    .accept 5386 >> Accept Catch of the Day
    .target Nataka Longhorn

step
    .goto Desolace,73.9,47.0
    >>Northeast to the Kolkar lands: kill through the village to Khan Dez'hepah and take his head -- save every Centaur Ear you loot, the bounty follows
    .complete 1365,1 --Khan Dez'hepah's Head
    .mob Kolkar Centaur
    .mob Kolkar Scout
    .mob Kolkar Mauler
    .unitscan Khan Dez'hepah

step
    .goto Desolace,56.2,59.6
    >>Felgur trades the head for a bounty on ears -- fifteen; your pouch is likely half full already
    .turnin 1365 >> Turn in Khan Dez'hepah
    .accept 1366 >> Accept Centaur Bounty
    .target Felgur Twocuts

step
    .goto Desolace,62.0,48.0
    >>Finish the ear count among the Kolkar
    .complete 1366,1 --Centaur Ear (15)
    .mob Kolkar Centaur
    .mob Kolkar Scout

step
    .goto Desolace,56.2,59.6
    >>Felgur pays out
    .turnin 1366 >> Turn in Centaur Bounty
    .target Felgur Twocuts

step
    .goto Desolace,52.2,53.4
    >>West on the road: Maurin Bonesplitter studies the demons here. His Flayed Demon Skin starts from a drop -- if a demon already gave you one, hand it in; either way take his scalp hunt
    .turnin -1480 >> Turn in The Corrupter
    .target Maurin Bonesplitter

step
    .goto Desolace,52.2,53.4
    >>Take The Corrupter at Maurin Bonesplitter
    .accept 1481,2,1480 >> Accept The Corrupter
    .target Maurin Bonesplitter

step
    .goto Desolace,68.0,72.0
    >>The Magram village southeast: every Gelkis you kill pleases them, every Magram you spare counts. Work the GELKIS lands southwest until Magram calls you Friendly -- their scouts and outrunners die fast (rep per kill is small; mix it with the quests below)
    .complete 1367,1 --Friendly with the Magram
    .mob Gelkis Scout
    .mob Gelkis Outrunner
    .mob Gelkis Windchaser

step
    .goto Desolace,75.0,68.2
    >>Warug in the Magram village once they'll speak to you: his list runs on Gelkis corpses too
    .turnin 1367 >> Turn in Magram Alliance
    .accept 1369 >> Accept Broken Tears
    .target Warug

step
    .goto Desolace,37.0,84.0
    >>Southwest to the Gelkis valley: 3 Broken Tears drop from any of them, and Maurin's Shadowstalker Scalps come from the stalker cats prowling the ridges
    .complete 1369,1 --Broken Tear (3)
    .mob Gelkis Scout
    .mob Gelkis Marauder
    .mob Gelkis Earthcaller

step
    .goto Desolace,76.5,25.6
    >>Shadowstalker Scalp
    .complete -1481,1 --Shadowstalker Scalp
    .mob Gelkis Scout
    .mob Gelkis Marauder
    .mob Gelkis Earthcaller

step
    .goto Desolace,75.0,68.2
    >>Warug pays (skip his follow-ups -- they run off this route)
    .turnin 1369 >> Turn in Broken Tears
    .target Warug

step
    .goto Desolace,75.0,68.2
    >>Take Gizmo for Warug at Warug
    .accept 1371,2,1369 >> Accept Gizmo for Warug
    .target Warug

step
    .goto Desolace,75.0,68.2
    >>Advanced Target Dummy, then hand in Gizmo for Warug at Warug
    .collect 4392,1,1371 --Advanced Target Dummy (VERIFY item id)
    .turnin -1371 >> Turn in Gizmo for Warug
    .target Warug

step
    .goto Desolace,52.2,53.4
    >>Maurin reads the scalps and sends you toward the coast for an Oracle Crystal
    .turnin -1481 >> Turn in The Corrupter
    .target Maurin Bonesplitter

step
    .goto Desolace,52.2,53.4
    >>Take The Corrupter at Maurin Bonesplitter
    .accept 1482,2,1481 >> Accept The Corrupter
    .target Maurin Bonesplitter

step
    .goto Desolace,21.6,74.1
    >>Cross to the west coast: Shadowprey Village, the troll fishery. Grab the flight from Thalon first, then the full board -- and Roon's kodo horn rides to Stranglethorn, next chapter's stop
    .fp Shadowprey Village >> Get the Shadowprey Village flight path

step
    .goto Desolace,25.1,72.3
    >>Take Hunting in Stranglethorn at Roon Wildmane
    .accept 5763 >> Accept Hunting in Stranglethorn
    .target Roon Wildmane

step
    .goto Desolace,22.6,72.0
    >>Take Clam Bait at Mai'Lahii
    .accept 6142 >> Accept Clam Bait
    .target Mai'Lahii

step
    .goto Desolace,23.3,72.9
    >>Take Other Fish to Fry at Drulzegar Skraghook
    .accept 6143 >> Accept Other Fish to Fry
    .target Drulzegar Skraghook

step
    .goto Desolace,30.5,34.0
    >>North up the west coast: Giant Softshell Clams in the shallows hold Mai'Lahii's clam meat (Reef Crawlers pick at them too)
    .complete 6142,1 --Soft-shelled Clam Meat (10)
    .mob Giant Softshell Clam
    .mob Enraged Reef Crawler

step
    .goto Desolace,34.5,20.0
    >>The Slitherblade naga hold the north coast: Drulzegar's tally -- 7 Myrmidons, 7 Naga, 5 Sorceresses
    .complete 6143,1 --Slitherblade Myrmidon (7)
    .complete 6143,2 --Slitherblade Naga (7)
    .complete 6143,3 --Slitherblade Sorceress (5)
    .mob Slitherblade Myrmidon
    .mob Slitherblade Naga
    .mob Slitherblade Sorceress

step
    #optional
    .isOnQuest 1482
    .goto Desolace,28.1,7.3
    >>Maurin's Oracle Crystal: the Slitherblade Oracles on the far northern point carry it
    .complete -1482,1 --Oracle Crystal
    .mob Slitherblade Oracle

step
    .goto Desolace,22.6,72.0
    >>The fishery pays out; Jinar'Zillen by the dock handles Nataka's catch -- speak with him, take the two Bloodbelly fish, and the errand closes back east
    .turnin 6142 >> Turn in Clam Bait
    .target Mai'Lahii

step
    .goto Desolace,23.3,72.9
    >>Hand in Other Fish to Fry at Drulzegar Skraghook, then speak with Jinar'Zillen for Nataka's two Bloodbelly Fish
    .turnin -6143 >> Turn in Other Fish to Fry
    .complete -5386,1 --Bloodbelly Fish
    .target Drulzegar Skraghook

step
    .goto Desolace,52.2,53.4
    >>Back across to Maurin with the crystal: he points you to Takata Steelblade next door. Skip The Corrupter finale after it -- a 40s fight off this route
    .turnin -1482 >> Turn in The Corrupter
    .target Maurin Bonesplitter

step
    .goto Desolace,52.2,53.4
    >>Take The Corrupter at Maurin Bonesplitter
    .accept 1484,2,1482 >> Accept The Corrupter
    .target Maurin Bonesplitter

step
    .goto Desolace,52.6,54.4
    >>Hand in The Corrupter at Takata Steelblade
    .turnin -1484 >> Turn in The Corrupter
    .target Takata Steelblade

step
    .goto Desolace,55.4,55.8
    >>Nataka takes her fish
    .turnin 5386 >> Turn in Catch of the Day
    .target Nataka Longhorn

step
    #optional
    .goto 1443/1,1241.81,-672.44
    >>OPTIONAL, big XP if the timing lands: the Gizelton Caravan rolls between Kormek's Hut and Smeed Scrabblescrew's camp south of the graveyard. Catch it parked: Cork Gizelton (north leg) offers Bodyguard for Hire, Rigger Gizelton (south leg) Gizelton Caravan. Escort it, then Smeed pays both. Skip if the road is empty
    .accept 5821 >> Accept Bodyguard for Hire
    .target Cork Gizelton

step
    #optional
    .goto 1443/1,2192.22,-1805.05
    >>Take Gizelton Caravan at Rigger Gizelton
    .accept 5943 >> Accept Gizelton Caravan
    .target Rigger Gizelton

step
    #optional
    .goto Desolace,60.9,61.9
    >>Hand in Bodyguard for Hire, Gizelton Caravan at Smeed Scrabblescrew
    .turnin -5821 >> Turn in Bodyguard for Hire
    .turnin -5943 >> Turn in Gizelton Caravan
    .target Smeed Scrabblescrew

step
    #optional
    .goto 1443/1,1497.17,-1402.43
    >>The Kodo Graveyard sprawls west of the road -- Smeed's roundup (use the Kodo Kombobulator on tamed-looking old kodos and walk them home) is quick money and XP if he offered it
    .accept 5561 >> Accept Kodo Roundup

step
    #optional
    .goto Desolace,51.0,57.5
    >>Kodos rounded up
    .complete -5561,1 --Kodos rounded up

step
    #optional
    .goto 1443/1,1497.17,-1402.43
    >>Hand in Kodo Roundup at Smeed Scrabblescrew
    .turnin -5561 >> Turn in Kodo Roundup

step
    .goto Desolace,56.2,59.6
    .xp 36 >> Short of 36? Kolkar remnants and the Magram's enemies pay double duty -- round off at Ghost Walker Post

step
    .goto Desolace,21.6,74.1
    >>Ride west to Shadowprey Village and fly home from Thalon -- the jungle is next
    .fly Orgrimmar >> Fly to Orgrimmar
]])
