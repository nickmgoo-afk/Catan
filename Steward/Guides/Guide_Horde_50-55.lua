--  RXPGuides_ForeverWarrior - Horde 50-55
--  Built from the Forever quest database. VERIFY IN GAME.

-- ================ 50-53 UN'GORO CRATER ==============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 50-53 Un'Goro Crater (Horde)
#next 53-55 Felwood/Winterspring (Horde)
<< Horde
step
    .goto Durotar,45.1,13.7
    >>Level 50. The last decade opens in Un'Goro Crater: fly the long chain to Gadgetzan
    .fly Gadgetzan >> Fly to Gadgetzan

step
    #optional
    .isQuestComplete 3520
    .goto Tanaris,67.0,22.4
    >>Screecher spirits caught in Feralas? Ride east to Steamwheedle Port: Yeh'kinya takes them
    .turnin 3520 >> Turn in Screecher Spirits
    .target Yeh'kinya

step
    .goto Tanaris,30.0,47.0
    >>Ride southwest through the Noxious Lair pass, and drop down the crater wall
    .zone Un'Goro Crater

step
    .goto Un'Goro Crater,44.0,8.0
    >>Marshal's Refuge, the crater's one safe ledge: the expedition's whole board. Williden lost everything, Spark counts bones, Hol'anyee needs hive samples, Shizzle wants wing leather -- and if you found a soggy journal on the way in, it's Williden's
    .turnin -3884 >> Turn in Williden's Journal
    .accept 3881 >> Accept Expedition Salvation
    .accept 3882 >> Accept Roll the Bones
    .accept 3883 >> Accept Alien Ecology
    .target Williden Marshal
    .target Spark Nilminer
    .target Hol'anyee Marshal

step
    .goto Un'Goro Crater,44.5,12.0
    >>Take Shizzle's Flyer at Shizzle
    .accept 4503 >> Accept Shizzle's Flyer
    .target Shizzle

step
    .goto Un'Goro Crater,46.0,13.0
    >>Take Chasing A-Me 01 at Karna Remtravel
    .accept 4243 >> Accept Chasing A-Me 01
    .target Karna Remtravel

step
    .goto Un'Goro Crater,42.0,3.5
    >>J.D. Collie in the crystal cave: her pylon survey runs the whole chapter -- pick up EVERY Power Crystal you see on the crater floor (7 of each color), and the pylon discoveries pay as you pass them
    .accept 4284 >> Accept Crystals of Power
    .accept 4285,2,4284 >> Accept The Northern Pylon
    .accept 4287,2,4284 >> Accept The Eastern Pylon
    .target J.D. Collie

step
    .goto 1449/1,-1798.41,-7658.80
    >>Linken the amnesiac elf lives at Marshal's Refuge, but his story starts at his wrecked raft on the shore far to the southeast: search it, open the pack beside it, then bring him what's inside -- his sword points you to Winterspring, which is exactly where this file goes next
    .accept 3844 >> Accept It's a Secret to Everybody

step
    .goto 1449/1,-1798.41,-7658.80
    >>Search the raft
    .complete -3844,1 --Search the raft

step
    .goto 1449/1,-1801.74,-7670.15
    >>Hand in It's a Secret to Everybody at A Small Pack
    .turnin -3844 >> Turn in It's a Secret to Everybody

step
    .goto 1449/1,-1801.74,-7670.15
    >>Take It's a Secret to Everybody at A Small Pack
    .accept 3845,2,3844 >> Accept It's a Secret to Everybody

step
    .goto Un'Goro Crater,45.0,8.0
    >>Hand in It's a Secret to Everybody; take It's a Secret to Everybody at Linken
    .turnin -3845 >> Turn in It's a Secret to Everybody
    .accept 3908,2,3845 >> Accept It's a Secret to Everybody
    .target Linken

step
    .goto Un'Goro Crater,40.0,25.0
    >>The western marshlands: Webbed Diemetradon and Pterrordax Scales for Shizzle (8 each), dinosaur bones off everything for Spark, crystals underfoot. The devilsaurs stalk silently -- when the ground shakes, RUN first and look after
    .complete 4503,1 --Webbed Diemetradon Scale (8)
    .complete 4503,2 --Webbed Pterrordax Scale (8)
    .complete 3882,1 --Dinosaur Bone (8)
    .mob Diemetradon
    .mob Frenzied Pterrordax

step
    .goto Un'Goro Crater,48.7,85.3
    >>The Gorishi hive in the far south: scrape a Hive Wall Sample from the hatchery wall for Hol'anyee
    .complete 3883,1 --Hive Wall Sample

step
    .goto Un'Goro Crater,38.5,66.1
    >>Williden's Research Equipment lies at the wrecked wagon in the west of the crater
    .complete 3881,2 --Research Equipment

step
    .goto Un'Goro Crater,68.5,36.5
    >>And his Crate of Foodstuffs at the wreck by the eastern road
    .complete 3881,1 --Crate of Foodstuffs

step
    .goto Un'Goro Crater,68.0,17.0
    >>Fungal Rock, the gorilla caves northeast: A-Me 01 waits deep in. She needs a Mithril Casing (engineer-made -- AH note) and then a careful walk home past every ape in the dark
    .turnin 4243 >> Turn in Chasing A-Me 01
    .accept 4244 >> Accept Chasing A-Me 01
    .complete 4244,1 --Mithril Casing
    .turnin 4244 >> Turn in Chasing A-Me 01
    .accept 4245 >> Accept Chasing A-Me 01
    .complete 4245,1 --Escort A-Me 01
    .target A-Me 01

step
    .goto Un'Goro Crater,46.0,13.0
    >>Hand in Chasing A-Me 01 at Karna Remtravel
    .turnin -4245 >> Turn in Chasing A-Me 01
    .target Karna Remtravel

step
    .goto Un'Goro Crater,46.0,9.0
    >>Larion by the north path feuds with an alliance botanist: hunt 5 each of the Bloodpetal Lashers, Threshers, Flayers and Trappers for his side (skip his Ratchet follow-up)
    .accept 4145 >> Accept Larion and Muigin
    .complete 4145,1
    .complete 4145,2
    .complete 4145,3
    .complete 4145,4
    .turnin 4145 >> Turn in Larion and Muigin
    .mob Bloodpetal Lasher
    .mob Bloodpetal Thresher
    .mob Bloodpetal Flayer
    .target Larion

step
    .goto Un'Goro Crater,44.0,8.0
    >>The refuge pays out -- and Collie's crystal count closes whenever the colors fill
    .turnin 3881 >> Turn in Expedition Salvation
    .turnin 3882 >> Turn in Roll the Bones
    .turnin 3883 >> Turn in Alien Ecology
    .target Williden Marshal
    .target Spark Nilminer
    .target Hol'anyee Marshal

step
    .goto Un'Goro Crater,44.5,12.0
    >>Hand in Shizzle's Flyer at Shizzle
    .turnin -4503 >> Turn in Shizzle's Flyer
    .target Shizzle

step
    .goto Un'Goro Crater,42.0,3.5
    >>Hand in Crystals of Power, The Northern Pylon, The Eastern Pylon at J.D. Collie
    .turnin -4284 >> Turn in Crystals of Power
    .turnin -4285 >> Turn in The Northern Pylon
    .turnin -4287 >> Turn in The Eastern Pylon
    .target J.D. Collie

step
    .goto Un'Goro Crater,45.0,20.0
    .xp 53 >> Un'Goro's dinos are the best open-world XP of the decade -- grind the marsh and plateau herds to 53 before moving north
]])

-- ============ 53-55 FELWOOD / WINTERSPRING ==========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 53-55 Felwood/Winterspring (Horde)
#next 55-57 Plaguelands (Horde)
<< Horde
step
    .goto Ashenvale,34.0,48.0
    >>North through Ashenvale into Felwood -- the corrupted forest. The Horde holds Bloodvenom Post mid-zone; the neutral Emerald Sanctuary guards the southern gate
    .zone Felwood

step
    .goto Felwood,51.0,82.0
    >>The Emerald Sanctuary: Greta's Jaedenar investigation (Hounds, Guardians, Adepts and Cultists inside the corrupted hold -- pull carefully, it's a den), Taronn's entropic survey rides along
    .accept 5155 >> Accept Forces of Jaedenar
    .goto Felwood,51.1,82.0
    .accept 5156 >> Accept Verifying the Corruption
    .target Greta Mosshoof
    .target Taronn Redfeather

step
    .goto Felwood,36.0,60.0
    >>Jaedenar: work the compound for Greta's counts; Entropic Beasts and Horrors drift the scar for Taronn (2 each)
    .complete 5155,1
    .complete 5155,2
    .complete 5155,3
    .complete 5155,4
    .mob Jaedenar Hound
    .mob Jaedenar Guardian
    .mob Jaedenar Adept
    .mob Jaedenar Cultist
    .mob Entropic Beast

step
    .goto Felwood,40.8,42.4
    >>Entropic Beast (2), Entropic Horror (2)
    .complete -5156,1 --Entropic Beast (2)
    .complete -5156,2 --Entropic Horror (2)
    .mob Jaedenar Hound
    .mob Jaedenar Guardian
    .mob Jaedenar Adept
    .mob Jaedenar Cultist
    .mob Entropic Beast

step
    .goto Felwood,51.0,82.0
    >>Taronn Redfeather takes your corruption report; Greta Mosshoof fills a canteen job: water from Jaedenar's defiled moon well, carried to a tauren seer on the Barrens coast -- Islen, your old totem friend. Fly hop: it's worth it
    .turnin 5155 >> Turn in Forces of Jaedenar
    .turnin 5156 >> Turn in Verifying the Corruption
    .accept 5157 >> Accept Collection of the Corrupt Water
    .target Greta Mosshoof
    .target Taronn Redfeather

step
    .goto Felwood,35.5,58.5
    >>Fill the canteen at Jaedenar's well
    .complete -5157,1 --Fill the canteen at Jaedenar's well

step
    .goto Felwood,51.0,82.0
    >>Hand in Collection of the Corrupt Water; take Seeking Spiritual Aid at Greta Mosshoof
    .turnin -5157 >> Turn in Collection of the Corrupt Water
    .accept 5158,2,5157 >> Accept Seeking Spiritual Aid
    .target Greta Mosshoof

step
    .goto Felwood,34.5,52.5
    >>Bloodvenom Post: Winna's experiment wants corrupted moonwell water from the Jadefire satyrs at Shatter Scar -- and then her kitten walks into legend (release it at the well, see what returns). Dreka'Sur mourns: Overlord Ror, the gnoll? no -- the FEL BEAST who killed her husband, dies at Felpaw
    .accept 4505 >> Accept Well of Corruption
    .target Winna Hazzard

step
    .goto Felwood,32.3,66.6
    >>Corrupted water sample
    .complete -4505,1 --Corrupted water sample

step
    .goto Felwood,34.5,52.5
    >>Hand in Well of Corruption; take Corrupted Sabers at Winna Hazzard, then Winna's kitten at the well, then hand in Corrupted Sabers at Winna Hazzard
    .turnin -4505 >> Turn in Well of Corruption
    .accept 4506,2,4505 >> Accept Corrupted Sabers
    .complete 4506,1 --Winna's kitten at the well
    .turnin 4506 >> Turn in Corrupted Sabers
    .target Winna Hazzard

step
    .goto Felwood,35.0,53.0
    >>Take A Husband's Last Battle at Dreka'Sur
    .accept 6162 >> Accept A Husband's Last Battle
    .target Dreka'Sur

step
    .goto Felwood,48.2,94.3
    >>Overlord Ror's claw
    .complete -6162,1 --Overlord Ror's claw

step
    .goto Felwood,35.0,53.0
    >>Hand in A Husband's Last Battle at Dreka'Sur
    .turnin -6162 >> Turn in A Husband's Last Battle
    .target Dreka'Sur

step
    .goto Felwood,47.0,83.0
    >>Tip: Maybess Riverbreeze here trades salves for Blood Amber, which the corrupted creatures of north Felwood drop -- worth it only if you come back this way with 15
    .target Maybess Riverbreeze

step
    .goto The Barrens,65.8,43.8
    >>The Islen hop: fly south (Ratchet), walk the beach, and the seer purifies the well water -- carry it straight back
    .turnin -5158 >> Turn in Seeking Spiritual Aid
    .accept 5159,2,5158 >> Accept Cleansed Water Returns to Felwood
    .target Islen Waterseer

step
    .goto Felwood,51.0,82.0
    >>Greta pours the cleansed water home
    .turnin -5159 >> Turn in Cleansed Water Returns to Felwood
    .target Greta Mosshoof

step
    .goto Felwood,65.0,8.5
    >>North through the forest to Timbermaw Hold -- the furbolg tunnel is the only road to Winterspring. Kill Deadwood furbolgs OUTSIDE first if your reputation runs hostile (their camps line the approach; every kill helps), then walk the tunnel east
    .zone Winterspring

step
    .goto Winterspring,60.5,38.5
    >>Everlook, the goblin toehold in the snow: flight path first, then the board -- yeti furs for Umi, Gregor's report rides to the Plaguelands (our next file), the Duke's book to Light's Hope, and Jessica Redpath begs a stranger to find her sister's grave in Darrowshire. Take them all: three of them ARE the road ahead
    .fp Everlook >> Get the Everlook flight path
    .home >> Set your Hearthstone to Everlook

step
    .goto Winterspring,61.0,38.0
    >>Take Are We There, Yeti? at Umi Rumplesnicker
    .accept 3783 >> Accept Are We There, Yeti?
    .target Umi Rumplesnicker

step
    .goto Winterspring,61.0,39.0
    >>Take The Everlook Report, Duke Nicholas Zverenhoff at Gregor Greystone
    .accept 6029 >> Accept The Everlook Report
    .accept 6030 >> Accept Duke Nicholas Zverenhoff
    .target Gregor Greystone

step
    .goto Winterspring,61.2,39.0
    >>Take Sister Pamela at Jessica Redpath
    .accept 5601 >> Accept Sister Pamela
    .target Jessica Redpath

step
    .goto Winterspring,53.0,32.0
    >>Winterfall and yeti country: 10 Thick Yeti Furs from the cave slopes; Meggi's worry sends you to Donova at the hot springs
    .complete 3783,1 --Thick Yeti Fur (10)
    .mob Ice Thistle Yeti
    .mob Ice Thistle Matriarch

step
    .goto Winterspring,61.0,38.2
    >>Take Trouble in Winterspring! at Meggi Peppinrocker
    .accept 6603 >> Accept Trouble in Winterspring!

step
    .goto Winterspring,31.0,45.0
    >>Donova Snowden at the hot springs: Linken's sword finally lands (skip the Videre Elixir leg -- his chain runs off this route), and her Winterfall investigation opens: 8 Pathfinders, 8 Totemics, 8 Den Watchers -- their firewater flask (if one drops) deepens the mystery back toward Felwood
    .turnin -3908 >> Turn in It's a Secret to Everybody
    .turnin 6603 >> Turn in Trouble in Winterspring!
    .accept 5082 >> Accept Threat of the Winterfall
    .complete 5082,1
    .complete 5082,2
    .complete 5082,3
    .turnin 5082 >> Turn in Threat of the Winterfall
    .turnin -5083 >> Turn in Winterfall Firewater
    .mob Winterfall Pathfinder
    .mob Winterfall Totemic
    .mob Winterfall Den Watcher
    .target Donova Snowden

step
    .goto Winterspring,62.0,38.0
    >>Storm Shadowhoof in Everlook hunts the great beasts: Ursius of the Shardtooth prowls the eastern slopes (skip his Brumeran follow-up -- it runs off this route)
    .accept 5054 >> Accept Ursius of the Shardtooth
    .complete 5054,1 --Ursius
    .turnin 5054 >> Turn in Ursius of the Shardtooth
    .unitscan Ursius
    .target Storm Shadowhoof

step
    .goto Winterspring,61.0,38.0
    >>Umi pays the furs (skip her next yeti errand -- it runs off this route)
    .turnin 3783 >> Turn in Are We There, Yeti?
    .target Umi Rumplesnicker

step
    .goto Winterspring,59.0,37.0
    .xp 55 >> Yetis, Winterfall, and chimaera to 55 -- then the plague war east
]])
