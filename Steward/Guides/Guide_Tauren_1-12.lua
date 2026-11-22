-- =====================================================================
--  Custom WoW: Forever guide -- Tauren start, 1-12 (Warrior-optimized)
--  Chunks: 1-6 Camp Narache > 6-12 Mulgore/Thunder Bluff, ending at the
--  Crossroads and chaining into our "12-17 The Barrens" (Guide_Horde_12-22.lua).
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Alliance" then return end

-- ==================== 1-6 CAMP NARACHE ===============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 1-6 Camp Narache (Tauren)
#next 6-12 Mulgore (Tauren)
<< Horde

step
    #completewith next
    +Tauren starter, warrior-optimized. Part of this zone's main questline is Tauren-only, so run this on a Tauren

step
    .goto 1412/1,-259.85,-2914.28
    >>Talk to Grull Hawkwind on the rise
    .accept 747 >> Accept The Hunt Begins
    .target Grull Hawkwind

step
    .goto 1412/1,-221.83,-2878.31
    >>Chief Hawkwind in the big tent
    .accept 752 >> Accept A Humble Task
    .target Chief Hawkwind

step << Warrior
    .goto 1412/1,-317.90,-2852.63,30,0
    >>Kill Plainstriders until you have ~10 copper of loot
    .goto 1412/1,-279.37,-2893.73
    >>Sell to Kawnie Softbreeze
    .vendor >> Vendor trash
    .target Kawnie Softbreeze
    .mob Plainstrider

step << Warrior
    .goto 1412/1,-213.61,-2880.71
    >>Harutt Thunderhorn by the chief's tent
    .train 6673 >> Train Battle Shout
    .target Harutt Thunderhorn

step
    .goto 1412/1,-522.37,-3052.65
    >>Greatmother Hawkwind at the southern camp
    .turnin 752 >> Turn in A Humble Task
    .accept 753 >> Accept A Humble Task
    .target Greatmother Hawkwind

step
    .goto 1412/1,-532.14,-3059.84
    >>Lift the Water Pitcher from the well behind her
    .complete 753,1 --Water Pitcher

step
    .goto 1412/1,-385.20,-3117.38
    >>Kill Plainstriders for 7 meat and 7 feathers on the way back
    .complete 747,1 --Plainstrider Meat (7)
    .complete 747,2 --Plainstrider Feather (7)
    .mob Plainstrider

step
    .goto 1412/1,-259.85,-2914.28
    >>Grull
    .turnin 747 >> Turn in The Hunt Begins
    .accept 750 >> Accept The Hunt Continues
    .accept 3091 >> Accept Simple Note << Warrior
    .target Grull Hawkwind

step << Druid
    .goto 1412/1,-259.85,-2914.28--c:Mulgore,44.92,77.12
    >>DRUID: Take Verdant Note at Grull Hawkwind
    .accept 3094 >> Accept Verdant Note
    .target Grull Hawkwind

step << Hunter
    .goto 1412/1,-259.85,-2914.28--c:Mulgore,44.92,77.12
    >>HUNTER: Take Etched Note at Grull Hawkwind
    .accept 3092 >> Accept Etched Note
    .target Grull Hawkwind

step << Shaman
    .goto 1412/1,-259.85,-2914.28--c:Mulgore,44.92,77.12
    >>SHAMAN: Take Rune-Inscribed Note at Grull Hawkwind
    .accept 3093 >> Accept Rune-Inscribed Note
    .target Grull Hawkwind

step
    .goto 1412/1,-221.83,-2878.31
    >>Chief Hawkwind
    .turnin 753 >> Turn in A Humble Task
    .accept 755 >> Accept Rites of the Earthmother
    .target Chief Hawkwind

step << Warrior
    .goto 1412/1,-213.61,-2880.71
    >>Harutt takes the note; train Charge and Rend at 4
    .turnin 3091 >> Turn in Simple Note
    .train 100 >> Train Charge
    .train 772 >> Train Rend
    .target Harutt Thunderhorn

step << Hunter
    .goto 1412/1,-225.94,-2865.64--c:Mulgore,44.26,75.70
    >>HUNTER: Hand in Etched Note at Lanka Farshot; train at your class trainer
    .turnin 3092 >> Turn in Etched Note
    .train 1978
    .target Lanka Farshot

step << Druid
    .goto 1412/1,-268.58,-2873.52--c:Mulgore,45.09,75.93
    >>DRUID: Hand in Verdant Note at Gart Mistrunner; train at your class trainer
    .turnin 3094 >> Turn in Verdant Note
    .train 8921
    .target Gart Mistrunner

step
    .goto 1412/1,-139.63,-3430.08
    >>Seer Graytongue in the southern hills -- his follow-up is a 10-MINUTE timed run
    .turnin 755 >> Turn in Rites of the Earthmother
    .accept 757 >> Accept Rite of Strength
    .accept 95805 >> Accept Grace of An'she and Mu'sha
    .target Seer Graytongue

step
    .goto 1412/1,-1005.50,-3372.70
    >>RUN east and click the shrine before the timer dies
    .turnin 95805 >> Turn in Grace of An'she and Mu'sha

step
    .goto 1412/1,-243.41,-3384.87
    >>Mountain Cougars prowl the hills: 10 pelts
    .complete 750,1 --Mountain Cougar Pelt (10)
    .mob Mountain Cougar

step
    .goto 1412/1,-259.85,-2914.28
    >>Grull
    .turnin 750 >> Turn in The Hunt Continues
    .accept 780 >> Accept The Battleboars
    .target Grull Hawkwind

step
    .goto 1412/1,-247.00,-2899.21
    >>Brave Windfeather patrols the camp
    .accept 3376 >> Accept Break Sharptusk!
    .target Brave Windfeather

step
    .goto 1412/1,-828.57,-3199.92
    >>Battleboars in the quilboar fields east: 8 flanks, 8 snouts
    .complete 780,2 --Battleboar Flank (8)
    .complete 780,1 --Battleboar Snout (8)
    .mob Battleboar

step
    #sticky
    #completewith NaracheDone
    >>Bristleback Quilboars drop 12 Bristleback Belts -- count them while you work the camp
    .complete 757,1 --Bristleback Belt (12)
    .mob Bristleback Quilboar

step
    .goto 1412/1,-1276.56,-2933.11
    >>Through the quilboar tunnel: kill Chief Sharptusk Thornmantle in the big hut
    .complete 3376,1 --Chief Sharptusk Thornmantle's Head
    .mob Chief Sharptusk Thornmantle

step
    .goto 1412/1,-1201.04,-3105.39
    >>In the brambled cave, loot the Dirt-Stained Map and use it
    .collect 4851,1,781 --Dirt-Stained Map
    .accept 781 >> Accept Attack on Camp Narache
    .use 4851

step
    #label NaracheDone
    .goto 1412/1,-1236.49,-2956.06
    >>Finish the 12 Bristleback Belts
    .complete 757,1 --Bristleback Belt (12)
    .mob Bristleback Quilboar

step
    .goto 1412/1,-259.85,-2914.28
    >>Back at camp: Grull
    .turnin 780 >> Turn in The Battleboars
    .target Grull Hawkwind

step
    .goto 1412/1,-247.00,-2899.21
    >>Windfeather on her rounds
    .turnin 3376 >> Turn in Break Sharptusk!
    .target Brave Windfeather

step << Shaman
    .goto 1412/1,-250.70,-2882.70
    >>Shamans: Seer Ravenfeather starts your first totem -- the Ritual Salves drop from the Bristleback Shamans you've been fighting; sweep the dens if you're short
    .accept 1519 >> Accept Call of Earth
    .collect 6634,2,1519 --Ritual Salve (2)
    .turnin 1519 >> Turn in Call of Earth
    .accept 1520 >> Accept Call of Earth
    .target Seer Ravenfeather

step << Shaman
    .goto 1412/1,-264.47,-2874.20--c:Mulgore,45.01,75.95
    >>SHAMAN: Hand in Rune-Inscribed Note at Meela Dawnstrider; train at your class trainer
    .turnin 3093 >> Turn in Rune-Inscribed Note
    .train 8042
    .target Meela Dawnstrider

step << Shaman
    .goto 1412/1,-720.70,-3031.70
    >>Kodo Rock, southeast of camp: drink the Earth Sapta, defeat the Minor Manifestation of Earth, and take the Rough Quartz it yields
    .turnin -1520 >> Turn in Call of Earth

step << Shaman
    .goto 1412/1,-720.70,-3031.70
    >>Take Call of Earth at Minor Manifestation of Earth
    .accept 1521,2,1520 >> Accept Call of Earth
    .mob Minor Manifestation of Earth

step << Shaman
    .goto 1412/1,-250.70,-2882.70
    >>Ravenfeather -- EARTH TOTEM
    .turnin -1521 >> Turn in Call of Earth
    .target Seer Ravenfeather

step
    .goto 1412/1,-221.83,-2878.31
    >>Chief Hawkwind sends you into the wider world
    .turnin 781 >> Turn in Attack on Camp Narache
    .turnin 757 >> Turn in Rite of Strength
    .accept 763 >> Accept Rites of the Earthmother
    .accept 96659 >> Accept The Adventurer
    .target Chief Hawkwind

step << Warrior
    .goto 1412/1,-213.61,-2880.71
    >>Level 6 with Harutt
    .train 3127 >> Train Parry
    .train 6343 >> Train Thunder Clap
    .target Harutt Thunderhorn

step
    .goto 1412/1,69.47,-3065.66
    >>Antur Fallow waits where the trail meets the road
    .accept 1656 >> Accept A Task Unfinished
    .target Antur Fallow
]])

-- ================== 6-12 MULGORE / THUNDER BLUFF =====================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 6-12 Mulgore (Tauren)
#next 12-17 The Barrens (Horde)
<< Horde

step
    .goto 1412/1,-363.00,-2490.70
    >>Kaga Wildhoof camps outside Bloodhoof Village
    .turnin 96659 >> Turn in The Adventurer
    .accept 96605 >> Accept The Great Outdoors
    .target Kaga Wildhoof

step
    .goto 1412/1,-363.00,-2490.70
    >>Type /sit at his campfire and stay seated a minute for the boosted rest buff
    .complete 96605,1 --Sit at the campfire
    .complete 96605,2 --Gain the boosted rest buff

step
    .goto 1412/1,-363.00,-2490.70
    >>Kaga
    .turnin 96605 >> Turn in The Great Outdoors
    .accept 96661 >> Accept Camping 101: Cooking
    .target Kaga Wildhoof

step
    .goto 1412/1,-347.70,-2365.25
    >>Innkeeper Kauth: deliver the satchel, make this home
    .turnin 1656 >> Turn in A Task Unfinished
    .home >> Set your Hearthstone to Bloodhoof Village
    .target Innkeeper Kauth

step
    .goto 1412/1,-392.91,-2333.40
    >>Baine Bloodhoof
    .turnin 763 >> Turn in Rites of the Earthmother
    .accept 745 >> Accept Sharing the Land
    .accept 767 >> Accept Rite of Vision
    .accept 746 >> Accept Dwarven Digging
    .target Baine Bloodhoof

step
    .goto 1412/1,-405.75,-2243.32
    >>Zarlman Two-Moons by the fire
    .turnin 767 >> Turn in Rite of Vision
    .accept 771 >> Accept Rite of Vision
    .target Zarlman Two-Moons

step
    .goto 1412/1,-365.17,-2227.56
    >>Maur Raincaller
    .accept 766 >> Accept Mazzranache
    .target Maur Raincaller

step
    .goto 1412/1,-408.90,-2179.80
    >>Yaw Sharpmane at the hunter camp
    .accept 96130 >> Accept Chakuyak
    .target Yaw Sharpmane

step
    .goto 1412/1,-430.60,-2097.60
    >>Old Ahab Wheathoof
    .accept 99411 >> Accept Kyle's Gone Missing!
    .target Ahab Wheathoof

step
    .goto 1412/1,-385.20,-2396.76
    >>Ruul Eagletalon
    .accept 743 >> Accept Dangers of the Windfury
    .target Ruul Eagletalon

step
    .goto 1412/1,-454.56,-2304.63
    >>Harken Windtotem
    .accept 761 >> Accept Swoop Hunting
    .target Harken Windtotem

step
    .goto 1412/1,-445.31,-2341.62
    >>Mull Thunderhorn begins the well-cleansing rites
    .accept 748 >> Accept Poison Water
    .target Mull Thunderhorn

step
    .goto 1412/1,-426.80,-2373.40
    >>Brave Wildrunner patrols nearby
    .accept 99079 >> Accept Longwalker Malah
    .target Brave Wildrunner

step
    .goto 1412/1,-496.20,-2347.90
    >>Krang Stonehoof, the warrior trainer, wants a show of strength
    .accept 99108 >> Accept Sparring Match
    .target Krang Stonehoof

step
    .goto 1412/1,-521.60,-2345.40
    >>Challenge the Novice Warriors by the ring and win 3 bouts
    .complete 99108,1 --Duels won (3)
    .target Novice Warrior

step
    .goto 1412/1,-496.10,-2348.10
    >>Krang
    .turnin 99108 >> Turn in Sparring Match
    .target Krang Stonehoof

step << Warrior
    #optional
    .goto 1412/1,-297.87,-2279.97
    >>Mahnott Roughwound sells the Wooden Mallet (~7s) -- your first real two-hander; sell your old weapon toward it
    .collect 2493,1 --Wooden Mallet
    .target Mahnott Roughwound
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<4.9

step
    #sticky
    #completewith MazzDone
    >>Mazzranache's trinkets drop as you quest: a Prairie Wolf Heart, Flatland Cougar Femur, Plainstrider Scale, and Swoop Gizzard
    .complete 766,1 --Prairie Wolf Heart
    .complete 766,2 --Flatland Cougar Femur
    .complete 766,3 --Plainstrider Scale
    .complete 766,4 --Swoop Gizzard

step
    #sticky
    #completewith SwoopDone
    >>Swoops all over Mulgore carry 8 Trophy Swoop Quills
    .complete 761,1 --Trophy Swoop Quill (8)
    .mob Wiry Swoop
    .mob Swoop
    .mob Taloned Swoop

step
    .goto 1412/1,-447.88,-2580.34
    >>South of the village: Prairie Wolves (6 paws) and Adult Plainstriders (4 talons)
    >>One plainstrider drops Tender Strider Meat -- keep it for Kyle
    .complete 748,1 --Prairie Wolf Paw (6)
    .complete 748,2 --Plainstrider Talon (4)
    .collect 287505,1,99411,1 --Tender Strider Meat
    .mob Prairie Wolf
    .mob Adult Plainstrider

step
    .goto 1412/1,-539.33,-2550.20
    >>Pick 2 Ambercorns from under the trees
    .complete 771,2 --Ambercorn (2)

step
    .goto 1412/1,-445.31,-2341.62
    >>Mull
    .turnin 748 >> Turn in Poison Water
    .accept 754 >> Accept Winterhoof Cleansing
    .target Mull Thunderhorn

step
    .goto 1412/1,-709.89,-2543.01
    >>Use the Winterhoof Cleansing Totem at the southeastern well
    .complete 754,1 --Cleanse the Winterhoof Well

step
    .goto 1412/1,-729.42,-2547.12
    >>Gather 2 Well Stones around it
    .complete 771,1 --Well Stone (2)

step
    .goto 1412/1,-469.30,-2256.00
    >>Kyle the Frenzied circles Bloodhoof Village -- feed him the Tender Strider Meat when he passes
    .use 33009
    .complete 99411,1 --Kyle fed
    .unitscan Kyle the Frenzied

step
    .goto 1412/1,-445.31,-2341.62
    >>Mull
    .turnin 754 >> Turn in Winterhoof Cleansing
    .accept 756 >> Accept Thunderhorn Totem
    .target Mull Thunderhorn

step << Warrior
    #optional
    .goto 1412/1,-356.43,-2357.03
    >>Vira Younghoof trains First Aid
    .train 3273 >> Train First Aid
    .target Vira Younghoof

step
    .goto 1412/1,-285.00,-2263.40
    >>Pyall Silentstride trains Cooking
    .train 2550 >> Train Cooking
    .turnin 96661 >> Turn in Camping 101: Cooking
    .target Pyall Silentstride

step
    .goto 1412/1,-405.75,-2243.32
    >>Zarlman (ignore the spirit wolf that appears)
    .turnin 771 >> Turn in Rite of Vision
    .accept 772 >> Accept Rite of Vision
    .target Zarlman Two-Moons

step
    .isQuestComplete 99411
    .goto 1412/1,-430.60,-2097.60
    >>Ahab, if Kyle's been fed
    .turnin 99411 >> Turn in Kyle's Gone Missing!
    .target Ahab Wheathoof

step
    .goto 1412/1,-784.90,-2350.18
    >>Morin Cloudstalker patrols the eastern road
    .accept 749 >> Accept The Ravaged Caravan
    .unitscan Morin Cloudstalker

step
    .goto 1412/1,-1066.40,-2325.20
    >>Malah Longwind rests further east
    .turnin 99079 >> Turn in Longwalker Malah
    .accept 99081 >> Accept Grim Tidings
    .target Malah Longwind

step
    .goto 1412/1,-712.98,-1922.74
    >>Click the Ravaged Caravan's supply crate on the road north
    .turnin 749 >> Turn in The Ravaged Caravan
    .accept 751 >> Accept The Ravaged Caravan

step
    .goto 1412/1,-335.88,-2009.39
    >>Prairie Stalkers and Flatland Cougars north of the village: 6 claws each
    .complete 756,1 --Stalker Claws (6)
    .complete 756,2 --Cougar Claws (6)
    .mob Prairie Stalker
    .mob Flatland Cougar

step
    .goto 1412/1,54.80,-2442.20
    >>Chakuyak, the great white wolf, hunts the western rise
    .complete 96130,1 --Chakuyak's Pelt
    .mob Chakuyak

step
    .goto 1412/1,297.80,-2398.50
    >>In the gnoll-held cave west: Perith Stormhoof needs an escort out
    .accept 98430 >> Accept The Longwalkers
    .target Perith Stormhoof

step
    .goto 1412/1,192.50,-2394.00
    >>Walk him clear of the cave
    .complete 98430,1 --Escort Perith

step
    .goto 1412/1,479.70,-2345.90
    >>Palemane gnolls around the cave: 10 Tanners, 8 Skinners, 5 Poachers
    .complete 745,1 --Palemane Tanner (10)
    .complete 745,2 --Palemane Skinner (8)
    .complete 745,3 --Palemane Poacher (5)
    .mob Palemane Tanner
    .mob Palemane Skinner
    .mob Palemane Poacher

step
    .goto 1412/1,-408.70,-2180.00
    >>Back at the village: Yaw
    .turnin 96130 >> Turn in Chakuyak
    .target Yaw Sharpmane

step
    .goto 1412/1,-392.50,-2318.50
    >>Wildrunner on patrol
    .turnin 99081 >> Turn in Grim Tidings
    .accept 99101 >> Accept Our Ancient Enemy
    .target Brave Wildrunner

step
    .goto 1412/1,-392.90,-2333.60
    >>Baine
    .turnin 745 >> Turn in Sharing the Land
    .turnin 99101 >> Turn in Our Ancient Enemy
    .accept 99080 >> Accept Drive Them Out
    .target Baine Bloodhoof

step
    .goto 1412/1,-445.31,-2341.62
    >>Mull, claws in hand
    .turnin 756 >> Turn in Thunderhorn Totem
    .accept 758 >> Accept Thunderhorn Cleansing
    .target Mull Thunderhorn

step << Warrior
    .goto 1412/1,-496.17,-2347.78
    >>Train with Krang
    .trainer >> Train your class abilities
    .target Krang Stonehoof

step
    .goto 1412/1,-237.76,-1826.50
    >>Use the Thunderhorn Cleansing Totem at the northern well
    .complete 758,1 --Cleanse the Thunderhorn Well

step
    .goto 1412/1,441.42,-1980.96
    >>Bael'dun dwarves at the dig: loot 5 Prospector's Picks and smash them on the forge
    >>Appraisers heal their friends -- kill them first
    .use 4702
    .complete 746,1 --Broken Tools (5)
    .mob Bael'dun Digger
    .mob Bael'dun Appraiser

step
    .goto 1412/1,275.48,-1721.35
    >>Windfury harpies northwest: 8 Windfury Talons
    .complete 743,1 --Windfury Talon (8)
    .mob Windfury Wind Witch
    .mob Windfury Harpy

step
    .goto 1412/1,366.93,-1509.00
    >>Seer Wiserunner sits in the cave north of the harpies
    .turnin 772 >> Turn in Rite of Vision
    .accept 773 >> Accept Rite of Wisdom
    .target Seer Wiserunner

step
    #sticky
    #completewith GhostHowl
    >>Watch for Ghost Howl, the scarred wolf (level 12, roams the plains): his cloak starts a quest
    .collect 4854,1,770 --Demon Scarred Cloak
    .accept 770 >> Accept The Demon Scarred Cloak
    .use 4854
    .unitscan Ghost Howl

step
    .goto 1412/1,-1026.88,-1150.40
    >>Northeast to the burial grounds: Lorekeeper Raintotem
    .accept 833 >> Accept A Sacred Burial
    .target Lorekeeper Raintotem

step
    .goto 1412/1,-1092.12,-1056.56
    >>Kill 8 Bristleback Interlopers defiling the graves
    .complete 833,1 --Bristleback Interloper (8)
    .mob Bristleback Interloper

step
    .goto 1412/1,-1109.08,-992.51
    >>The Ancestral Spirit at the great tomb
    .turnin 773 >> Turn in Rite of Wisdom
    .accept 775 >> Accept Journey into Thunder Bluff
    .target Ancestral Spirit

step
    .goto 1412/1,-1026.88,-1150.40
    >>Raintotem
    .turnin 833 >> Turn in A Sacred Burial
    .target Lorekeeper Raintotem

step
    #label SwoopDone
    .goto 1412/1,-1009.92,-1073.00
    >>Finish the 8 Swoop Quills on the Taloned Swoops here
    .complete 761,1 --Trophy Swoop Quill (8)
    .mob Taloned Swoop
    .mob Swoop

step
    .goto 1412/1,-1188.00,-2216.40
    >>Galak centaurs raid from the southeast: kill 6 Centaurs and 4 Outrunners, and Herak the Pillager at their camp (-1246,-2181)
    .complete 99080,1 --Galak Centaur (6)
    .complete 99080,2 --Galak Outrunner (4)
    .complete 99080,3 --Herak's Head
    .mob Galak Centaur
    .mob Galak Outrunner
    .mob Herak the Pillager

step
    #label MazzDone
    .goto 1412/1,-452.50,-1808.69
    >>Round out the Mazzranache pieces on the plains (wolves, cougars, plainstriders, swoops)
    .complete 766,1 --Prairie Wolf Heart
    .complete 766,2 --Flatland Cougar Femur
    .complete 766,3 --Plainstrider Scale
    .complete 766,4 --Swoop Gizzard
    .mob Prairie Wolf Alpha
    .mob Flatland Cougar
    .mob Elder Plainstrider
    .mob Taloned Swoop

step
    .goto 1412/1,-393.10,-2333.40
    >>Bloodhoof Village: Baine
    .turnin 99080 >> Turn in Drive Them Out
    .accept 99082 >> Accept The High Chieftain
    .target Baine Bloodhoof

step
    .goto 1412/1,-392.91,-2333.40
    >>The turn-in circuit
    .turnin 746 >> Turn in Dwarven Digging
    .target Baine Bloodhoof

step
    .goto 1412/1,-384.69,-2397.10
    >>Hand in Dangers of the Windfury at Ruul Eagletalon
    .turnin -743 >> Turn in Dangers of the Windfury
    .target Ruul Eagletalon

step
    .goto 1412/1,-445.83,-2340.93
    >>Hand in Thunderhorn Cleansing; take Wildmane Totem at Mull Thunderhorn
    .turnin -758 >> Turn in Thunderhorn Cleansing
    .accept 759,2,758 >> Accept Wildmane Totem
    .target Mull Thunderhorn

step
    .goto 1412/1,-454.56,-2304.63
    >>Hand in Swoop Hunting at Harken Windtotem
    .turnin -761 >> Turn in Swoop Hunting
    .target Harken Windtotem

step
    .goto 1412/1,-365.17,-2227.56
    >>Maur
    .turnin 766 >> Turn in Mazzranache
    .target Maur Raincaller

step
    .goto 1412/1,-353.86,-2336.14
    >>Skorn Whitecloud by the fire
    .accept 861 >> Accept The Hunter's Way
    .target Skorn Whitecloud

step << Warrior
    .goto 1412/1,-496.17,-2347.78
    >>Krang: level 10 training, and his summons to Uzzek
    .accept 1505 >> Accept Veteran Uzzek
    .trainer >> Train your class abilities
    .target Krang Stonehoof

step
    .goto 1412/1,-784.90,-2350.18
    >>Morin on the road again
    .turnin 751 >> Turn in The Ravaged Caravan
    .accept 764 >> Accept The Venture Co
    .accept 765 >> Accept Supervisor Fizsprocket
    .unitscan Morin Cloudstalker

step
    #sticky
    #completewith AlphaDone
    >>Prairie Wolf Alphas drop 8 Prairie Alpha Teeth -- they den southeast and north
    .complete -759,1 --Prairie Alpha Tooth (8)
    .mob Prairie Wolf Alpha

step
    .goto 1412/1,-1131.68,-1911.44
    >>The Venture Co. mine: kill 14 Workers and 6 Supervisors
    .complete 764,1 --Venture Co. Worker (14)
    .complete 764,2 --Venture Co. Supervisor (6)
    .mob Venture Co. Worker
    .mob Venture Co. Supervisor

step
    .goto 1412/1,-1288.89,-1756.97
    >>Supervisor Fizsprocket oversees from the back: take his clipboard, and use the Mulgore Expansion Plans he drops
    .complete 765,1 --Fizsprocket's Clipboard
    .collect 281031,1,98424 --Mulgore Expansion Plans
    .accept 98424 >> Accept Fizsprocket's Notes
    .use 281031
    .mob Supervisor Fizsprocket

step
    .goto 1412/1,-1128.70,-1674.60
    >>Three documents lie around the mine's north side: Shredder Instructions here...
    .complete 98424,1 --Shredder Operation Instructions

step
    .goto 1412/1,-1315.80,-1672.10
    >>...Best Practices by the crates...
    .complete -98424,2 --Barrens Operations Best Practices

step
    .goto 1412/1,-1153.90,-1637.80
    >>...and the Gerenzo letter
    .complete -98424,3 --One "Gerenzo", of Stonetalon

step
    #label AlphaDone
    .goto 1412/1,-1426.06,-2295.72
    >>Finish the Alpha Teeth at the southeastern dens
    .complete -759,1 --Prairie Alpha Tooth (8)
    .mob Prairie Wolf Alpha

step
    .goto 1412/1,-784.90,-2350.18
    >>Morin
    .turnin 764 >> Turn in The Venture Co.
    .turnin 765 >> Turn in Supervisor Fizsprocket
    .turnin 98424 >> Turn in Fizsprocket's Notes
    .unitscan Morin Cloudstalker

step
    .goto 1412/1,-445.31,-2341.62
    >>Mull, teeth in hand
    .turnin -759 >> Turn in Wildmane Totem
    .accept 760,2,759 >> Accept Wildmane Cleansing
    .target Mull Thunderhorn

step << Hunter
    .goto 1412/1,-409.40,-2180.10
    >>Hunters -- you're 10: Yaw Sharpmane up the rise starts your pet chain
    .accept 6061 >> Accept Taming the Beast
    .target Yaw Sharpmane

step << Hunter
    .goto 1412/1,-409.40,-2180.10
    >>Use the Taming Rod on an Adult Plainstrider near the village, then bring the rod back
    .complete 6061,1
    .turnin 6061 >> Turn in Taming the Beast
    .accept 6087 >> Accept Taming the Beast
    .target Yaw Sharpmane

step << Hunter
    .goto 1412/1,-409.40,-2180.10
    >>Tame a Prairie Stalker (the wolves out on the flats), then return
    .complete 6087,1
    .turnin 6087 >> Turn in Taming the Beast
    .accept 6088 >> Accept Taming the Beast
    .target Yaw Sharpmane

step << Hunter
    .goto 1412/1,-409.40,-2180.10
    >>Last: tame a Swoop (the carrion birds), then back to Yaw. Keep your favorite -- Thunder Bluff finishes the training
    .complete 6088,1
    .turnin 6088 >> Turn in Taming the Beast
    .accept 6089 >> Accept Training the Beast
    .target Yaw Sharpmane

step << Druid
    .goto 1412/1,-443.30,-2315.50
    >>Druids -- you're 10: Gennia Runetotem sends you to Turak in Thunder Bluff, where we're headed anyway
    .accept 5928 >> Accept Heeding the Call
    .target Gennia Runetotem

step
    .goto 1456/1,147.90,-1290.60,30
    >>Ride north and take the lift up to Thunder Bluff

step
    .goto 1456/1,104.50,-1308.40
    >>Boarton Shadetotem lurks stealthed by the lift
    .accept 76156 >> Accept Stalk With The Earthmother
    .target Boarton Shadetotem

step
    .goto 1456/1,38.32,-1300.48
    >>Innkeeper Pala -- rehome here for the Barrens
    .home >> Set your Hearthstone to Thunder Bluff
    .target Innkeeper Pala

step
    .goto 1456/1,122.13,-1263.32
    >>Eyahn Eagletalon on the rim
    .accept 744 >> Accept Preparation for Ceremony
    .target Eyahn Eagletalon

step
    .goto 1456/1,-109.58,-1209.75
    >>Cairne Bloodhoof on the high rise
    .turnin 775 >> Turn in Journey into Thunder Bluff
    .turnin 99082 >> Turn in The High Chieftain
    .turnin 98430 >> Turn in The Longwalkers
    .accept 776 >> Accept Rites of the Earthmother
    .target Cairne Bloodhoof

step << Tauren Druid
    .goto 1456/1,-298.50,-1049.01--c:Thunder Bluff,78.1,28.6
    >>DRUID: Take The Barrens Oases at Arch Druid Hamuul Runetotem
    .accept 886 >> Accept The Barrens Oases
    .target Arch Druid Hamuul Runetotem

step << Hunter
    .goto 1456/1,-80.60,-1474.50
    >>Hunter Rise: Holt Thunderhorn completes your craft -- learn Tame Beast, Feed Pet, Revive Pet, all of it
    .turnin 6089 >> Turn in Training the Beast
    .trainer >> Train your hunter and pet skills
    .target Holt Thunderhorn

step << Shaman
    .goto 1456/1,286.90,-980.80
    >>Spirit Rise: Xanis Flameweaver has a fire errand -- it banks until the Barrens
    .accept 1523 >> Accept Call of Fire
    .target Xanis Flameweaver

step << Druid
    .goto 1456/1,-280.30,-1039.30
    >>Elder Rise: Turak Runetotem begins the bear
    .turnin 5928 >> Turn in Heeding the Call
    .accept 5922 >> Accept Moonglade
    .target Turak Runetotem

step << Druid
    .goto Moonglade,56.2,30.6
    >>Cast Teleport: Moonglade (you already know it) and find Dendrite Starblaze in Nighthaven
    .turnin 5922 >> Turn in Moonglade
    .accept 5930 >> Accept Great Bear Spirit
    .target Dendrite Starblaze

step << Druid
    .goto Moonglade,39.5,27.5
    >>Northwest to the Great Bear Spirit -- let it finish talking
    .complete 5930,1

step << Druid
    .goto Moonglade,56.2,30.6
    >>Dendrite confirms the lesson
    .turnin 5930 >> Turn in Great Bear Spirit
    .accept 5932 >> Accept Back to Thunder Bluff
    .target Dendrite Starblaze

step << Druid
    .goto Moonglade,48.0,67.0
    >>Take the druid-only flight home from the wind rider south of Nighthaven
    .fly Thunder Bluff >> Fly to Thunder Bluff

step << Druid
    .goto 1456/1,-280.30,-1039.30
    >>Turak again -- the real test comes at the Barrens border
    .turnin 5932 >> Turn in Back to Thunder Bluff
    .accept 6002 >> Accept Body and Heart
    .target Turak Runetotem

step
    .goto 1456/1,147.90,-1290.60,30,0
    .zone Mulgore >> Lift back down to Mulgore

step
    .goto 1412/1,496.39,-940.79
    >>Northwest harpy mesa: 6 Azure Feathers (Sorceresses) and 6 Bronze Feathers (Matriarchs)
    .complete 744,1 --Azure Feather (6)
    .complete 744,2 --Bronze Feather (6)
    .mob Windfury Sorceress
    .mob Windfury Matriarch

step
    .goto 1412/1,460.00,-1055.70
    >>Gather 8 Windfury Cones under the trees here
    .collect 206170,8,76160,1 --Windfury Cone (8)

step
    .goto 1412/1,-135.52,-745.57
    >>Use the Wildmane Cleansing Totem at the far northern well
    .complete -760,1 --Cleanse the Wildmane Well

step
    #label GhostHowl
    .goto 1412/1,-839.36,-1399.74
    >>Arra'chea, the huge black kodo, circles northern Mulgore clockwise -- take the horn
    .complete 776,1 --Horn of Arra'chea
    .unitscan Arra'chea

step
    .goto 1412/1,-454.05,-987.03
    >>Flatland Prowlers in the north: 4 claws
    .complete 861,1 --Flatland Prowler Claw (4)
    .mob Flatland Prowler

step
    .hs >> Hearth to Thunder Bluff

step
    .goto 1456/1,104.50,-1308.40
    >>Boarton, with the cones
    .turnin 76156 >> Turn in Stalk With The Earthmother
    .accept 76160 >> Accept Stalk With The Earthmother
    .turnin 76160 >> Turn in Stalk With The Earthmother
    .accept 76240 >> Accept Stalk With The Earthmother
    .target Boarton Shadetotem

step
    #optional
    .goto 1456/1,95.10,-1210.23
    >>His last task wants Fish Chunks: buy a Raw Brilliant Smallfish at the AH (or fish one from the pond with a pole from Sewa Mistrunner), then use his Knife Set
    .collect 6291,1,76240,1 --Raw Brilliant Smallfish
    .use 206344
    .complete 76240,1 --Fish Chunks

step
    #optional
    .isQuestComplete 76240
    .goto 1456/1,104.91,-1308.28
    >>Boarton
    .turnin 76240 >> Turn in Stalk With The Earthmother
    .target Boarton Shadetotem

step
    .goto 1456/1,-109.58,-1209.75
    >>Cairne takes the horn
    .turnin 776 >> Turn in Rites of the Earthmother
    .target Cairne Bloodhoof

step
    .goto 1456/1,122.13,-1263.32
    >>Eyahn
    .turnin 744 >> Turn in Preparation for Ceremony
    .target Eyahn Eagletalon

step
    .goto 1456/1,-123.15,-1412.93
    >>Melor Stonehoof on Hunter Rise
    .turnin 861 >> Turn in The Hunter's Way
    .accept 860 >> Accept Sergra Darkthorn
    .target Melor Stonehoof

step
    #optional
    .isOnQuest 770
    .goto 1456/1,353.52,-922.12
    >>Still short on Demon Scarred Cloak? Ghost Howl -- around here. This step skips itself once you have them
    .collect 4854,1,770 --Demon Scarred Cloak
    .mob Ghost Howl

step
    #optional
    .isOnQuest 770
    .goto 1412/1,-353.86,-2336.14
    >>Got Ghost Howl's cloak? Skorn in Bloodhoof pays for it on your way out
    .turnin 770 >> Turn in The Demon Scarred Cloak
    .target Skorn Whitecloud

step
    #optional
    .isQuestComplete 760
    .goto 1412/1,-445.31,-2341.62
    >>And Mull closes the rites
    .turnin -760 >> Turn in Wildmane Cleansing
    .target Mull Thunderhorn

step
    .goto 1413/1,-1881.35,-2383.82
    >>East into the Barrens: Omusa Thunderhorn at Camp Taurajo
    .fp Camp Taurajo >> Get the Camp Taurajo flight path
    .target Omusa Thunderhorn

step
    .goto 1413/1,-1926.95,-2346.66
    >>Kirge Sternhorn by the fire
    .accept 854 >> Accept Journey to the Crossroads
    .target Kirge Sternhorn

step << Druid
    .goto 1413/1,-1632.90,-2500.80
    >>Druids: a short hop northeast of Taurajo -- use the Cenarion Lunardust at the Moonkin Stone and defeat Lunaclaw
    .complete 6002,1
    .unitscan Lunaclaw

step << Druid
    .goto 1413/1,-1881.35,-2383.82
    >>Back to Taurajo and fly up to Thunder Bluff
    .fly Thunder Bluff >> Fly to Thunder Bluff

step << Druid
    .goto 1456/1,-280.30,-1039.30
    >>Turak -- BEAR FORM. Train it before you leave the rise
    .turnin 6002 >> Turn in Body and Heart
    .trainer >> Train Bear Form and its abilities
    .target Turak Runetotem

step << Druid
    .goto 1456/1,28.70,-1198.40
    .fly Camp Taurajo >> Fly back to Camp Taurajo and carry on

step
    .goto 1413/1,-2672.76,-544.77
    >>North up the road to the Crossroads: Tonga Runetotem at the south entrance
    .accept 870 >> Accept The Forgotten Pools
    .target Tonga Runetotem

step << Tauren Druid
    .goto 1413/1,-2672.76,-544.77--c:The Barrens,52.26,31.93
    >>DRUID: Hand in The Barrens Oases at Tonga Runetotem
    .turnin 886 >> Turn in The Barrens Oases
    .target Tonga Runetotem

step
    .goto 1413/1,-2669.72,-481.94
    >>Sergra Darkthorn
    .turnin 860 >> Turn in Sergra Darkthorn
    .accept 844 >> Accept Plainstrider Menace
    .target Sergra Darkthorn

step
    .goto 1413/1,-2595.75,-473.15
    >>Thork, the man in charge
    .turnin 854 >> Turn in Journey to the Crossroads
    .accept 871 >> Accept Disrupt the Attacks
    .accept 5041 >> Accept Supplies for the Crossroads
    .target Thork

step
    .goto 1413/1,-2607.91,-475.18
    >>Darsok Swiftdagger atop the tower
    .accept 867 >> Accept Harpy Raiders
    .target Darsok Swiftdagger

step
    .goto 1413/1,-2589.67,-424.51
    >>Apothecary Helbrim
    .accept 848 >> Accept Fungal Spores
    .accept 1492 >> Accept Wharfmaster Dizzywig
    .target Apothecary Helbrim

step
    .goto 1413/1,-2566.36,-350.19
    >>Jahan Hawkwing
    .accept 6361 >> Accept A Bundle of Hides
    .target Jahan Hawkwing

step
    .goto 1413/1,-2595.75,-437.35
    >>Devrak the wind rider master (don't fly yet -- his errand banks free XP)
    .turnin 6361 >> Turn in A Bundle of Hides
    .accept 6362 >> Accept Ride to Thunder Bluff
    .target Devrak

step
    .goto 1413/1,-2639.32,-436.00
    >>Gazrog
    .accept 869 >> Accept Raptor Thieves
    .target Gazrog

step << Warrior
    .goto 1413/1,-3598.95,186.93
    >>South to Far Watch Post: Veteran Uzzek starts your stance chain
    .turnin 1505 >> Turn in Veteran Uzzek
    .accept 1498 >> Accept Path of Defense
    .target Uzzek

step << Warrior
    .goto 1411/1,-4042.60,812.52
    >>Cross into Durotar's Thunder Ridge: Lightning Hides drop 5 Singed Scales
    .complete 1498,1 --Singed Scale (5)
    .mob Lightning Hide

step << Warrior
    .goto 1413/1,-3598.95,186.93
    >>Uzzek -- Defensive Stance is yours; his follow-up waits for the Barrens
    .turnin 1498 >> Turn in Path of Defense
    .accept 1502 >> Accept Thun'grim Firegaze
    .target Uzzek

step
    +Starter complete -- you're ~12 at the Crossroads with its quest board loaded. The Barrens 12-17 chapter loads next automatically. Banked: Ride to Thunder Bluff, the Crossroads quests, and Thun'grim Firegaze for your level-20 weapon trainer
]])
