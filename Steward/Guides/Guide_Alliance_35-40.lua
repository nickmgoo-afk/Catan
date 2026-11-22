-- RXPGuides_ForeverWarrior: Alliance 35-40 (part B of 30-40)
-- Pure QuestieDB build. Chapters:
-- 35-37 Dustwallow Marsh > 37-38 Badlands > 38-40 Stranglethorn Vale
-- Pays banked: 563 (Samuelson, Stormwind Keep), 669 (Seahorn, Booty Bay).
-- New banked out: 602 (Ansirem, Dalaran crater), 708 (IF Hall of Arms).
-- VERIFY IN GAME: database-built route, first live pass may need touch-ups.

-- ==================== 35-37 DUSTWALLOW MARSH =========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 35-37 Dustwallow Marsh (Alliance)
#next 37-38 Badlands (Alliance)
<< Alliance

step
    .goto Wetlands,9.5,59.7
    >>Make your way to Menethil Harbor (fly from Southshore or Ironforge) and take the southern boat
    .zone Dustwallow Marsh >> Boat to Theramore

step
    .goto Dustwallow Marsh,67.4,51.3
    .fp Theramore >> Get the Theramore flight path

step
    .goto Dustwallow Marsh,66.1,46.0
    >>Guard Byron frets by the inn
    .accept 1282 >> Accept They Call Him Smiling Jim
    .target Guard Byron

step
    .goto Dustwallow Marsh,68.2,48.6
    >>Captain Garran Vimes holds the Foothold Citadel's top floor
    .turnin 1282 >> Turn in They Call Him Smiling Jim
    .target Captain Garran Vimes

step
    .goto Dustwallow Marsh,55.4,26.2
    >>North to Witch Hill: "Swamp Eye" Jarl in the lone shack
    .accept 1203,2,1206 >> Accept Jarl Needs a Blade
    .accept 1206,2,1218 >> Accept Jarl Needs Eyes
    .accept 1218 >> Accept Soothing Spices
    >>He wants Soothing Spices too -- buy them from a trade vendor before or when you next pass a town
    .collect 3713,1,1218 --Soothing Spices
    .target "Swamp Eye" Jarl

step
    .isOnQuest 1206
    .goto Dustwallow Marsh,52.0,20.0,50,0
    >>Darkmist spiders web the hill around Jarl's shack -- take their eyes, and the blade piece he wants from the ruins
    .complete -1206,1 --Darkmist Eyes
    .complete -1203,1 --Knife of the Swamp
    .mob Darkmist Lurker
    .mob Darkmist Recluse

step
    .goto Dustwallow Marsh,46.8,17.5
    >>"Stinky" Ignatz is lost in the bog north -- walk him out while he hunts his herb
    .accept 1222 >> Accept Stinky's Escape
    .complete 1222,1 --Escort Stinky
    .target "Stinky" Ignatz

step
    #optional
    .goto Dustwallow Marsh,35.1,38.2
    >>OPTIONAL: Mudcrush Durtfeet, a lonely ogre west, pays well for Mirefin murloc heads
    .accept 1177 >> Accept Hungry!
    .target Mudcrush Durtfeet

step
    #optional
    .isOnQuest 1177
    .goto Dustwallow Marsh,57.0,21.8
    >>The Mirefin murlocs crowd the marsh's northern coast: 8 Mirefin Heads
    .complete 1177,1 --Mirefin Head (8)
    .mob Mirefin Puddlejumper
    .mob Mirefin Muckdweller

step
    #optional
    .isOnQuest 1177
    .goto Dustwallow Marsh,35.1,38.2
    >>Back to Mudcrush with the heads
    .turnin 1177 >> Turn in Hungry!
    .target Mudcrush Durtfeet

step
    .goto 1445/1,-2534.25,-3700.73
    >>The Shady Rest Inn on the west road burned with its guests. Search the ruins: suspicious hoofprints, a blackened shield, a half-buried badge, and the orc report
    .accept 1284 >> Accept Suspicious Hoofprints

step
    .goto 1445/1,-2530.57,-3735.03
    >>Take The Black Shield at Black Shield, then take Lieutenant Paval Reethe at Theramore Guard Badge
    .accept 1253 >> Accept The Black Shield
    .accept 1252 >> Accept Lieutenant Paval Reethe

step
    .goto 1445/1,-3885.60,-2940.53
    >>Take The Orc Report at Loose Dirt
    .accept 1219 >> Accept The Orc Report

step
    .isOnQuest 1286
    .goto Dustwallow Marsh,36.1,54.3
    >>(Later pass) Balos Jacken and the deserters camp southwest
    .turnin 1286 >> Turn in The Deserters
    .accept 1287 >> Accept The Deserters
    .target Balos Jacken

step
    .goto Dustwallow Marsh,55.4,26.2
    >>Jarl settles his lists
    .turnin -1203 >> Turn in Jarl Needs a Blade
    .turnin -1206 >> Turn in Jarl Needs Eyes
    .turnin -1218 >> Turn in Soothing Spices
    .target "Swamp Eye" Jarl

step
    .goto Dustwallow Marsh,66.3,45.4
    >>Morgan Stern hears how Stinky fared
    .turnin -1222 >> Turn in Stinky's Escape
    .target Morgan Stern

step
    .goto Dustwallow Marsh,68.2,48.6
    >>Vimes takes every scrap of Shady Rest evidence
    .turnin -1284 >> Turn in Suspicious Hoofprints
    .turnin -1253 >> Turn in The Black Shield
    .target Captain Garran Vimes

step
    .goto Dustwallow Marsh,68.2,48.6
    >>Take The Black Shield; hand in Lieutenant Paval Reethe at Captain Garran Vimes
    .accept 1319,2,1253 >> Accept The Black Shield
    .turnin -1252 >> Turn in Lieutenant Paval Reethe
    .target Captain Garran Vimes

step
    .goto Dustwallow Marsh,68.2,48.6
    >>Take Lieutenant Paval Reethe at Captain Garran Vimes
    .accept 1259,2,1252 >> Accept Lieutenant Paval Reethe
    .target Captain Garran Vimes

step
    .isOnQuest 1219
    .goto 1445/1,-4503.00,-3818.33
    >>Hand the Orc Report to any Theramore Lieutenant on the walls, then bring the spy's report upstairs
    .turnin 1219 >> Turn in The Orc Report
    .accept 1220 >> Accept Captain Vimes
    .target Theramore Lieutenant

step
    .goto Dustwallow Marsh,68.2,48.6
    >>Hand in Captain Vimes at Captain Garran Vimes
    .turnin -1220 >> Turn in Captain Vimes
    .target Captain Garran Vimes

step
    .isOnQuest 1319
    .goto Dustwallow Marsh,64.7,50.4
    >>Caz Twosprocket examines the shield
    .turnin -1319 >> Turn in The Black Shield
    .accept 1320,2,1319 >> Accept The Black Shield
    .target Caz Twosprocket

step
    .goto Dustwallow Marsh,68.2,48.6
    >>Hand in The Black Shield at Captain Garran Vimes
    .turnin -1320 >> Turn in The Black Shield
    .target Captain Garran Vimes

step
    .isOnQuest 1259
    .goto Dustwallow Marsh,68.0,48.1
    >>Adjutant Tesoran knew Reethe
    .turnin -1259 >> Turn in Lieutenant Paval Reethe
    .accept 1285,2,1259 >> Accept Daelin's Men
    .goto Dustwallow Marsh,68.2,48.6
    .turnin 1285 >> Turn in Daelin's Men
    .accept 1286 >> Accept The Deserters
    .target Adjutant Tesoran
    .target Captain Garran Vimes

step
    .isOnQuest 1286
    .goto Dustwallow Marsh,36.1,54.3
    >>Ride back out to Balos Jacken's deserter camp -- hear his side
    .turnin 1286 >> Turn in The Deserters
    .accept 1287 >> Accept The Deserters
    .target Balos Jacken

step
    .isOnQuest 1287
    .goto Dustwallow Marsh,68.2,48.6
    >>Vimes closes the Shady Rest file -- for now
    .turnin 1287 >> Turn in The Deserters
    .target Captain Garran Vimes

step << Mage
    #optional
    .goto Dustwallow Marsh,46.06,57.09
    >>MAGE -- the wand chain (30+): Tabetha's farm mid-marsh takes your trainer's referral. Her next leg (Magus Tirth, Shimmering Flats) sits deep in horde-flown country -- bank Hidden Secrets for your 40s Tanaris swing; the wand waits
    .turnin -1947 >> Turn in Journey to the Marsh
    .target Tabetha

step << Mage
    #optional
    .goto Dustwallow Marsh,46.06,57.09
    >>Take Hidden Secrets at Tabetha
    .accept 1949,2,1947 >> Accept Hidden Secrets
    .target Tabetha

step
    .goto Dustwallow Marsh,60.0,40.0
    .xp 37 >> Grind the marsh's raptors and crocolisks to 37
]])

-- ======================== 37-38 BADLANDS =============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 37-38 Badlands (Alliance)
#next 38-40 Stranglethorn Vale (Alliance)
<< Alliance

step
    .goto Dustwallow Marsh,66.4,51.9
    >>Boat back to Menethil
    .zone Wetlands >> Boat to Menethil Harbor

step
    .goto Wetlands,9.5,59.7
    .fly Ironforge >> Fly to Ironforge

step
    .goto Ironforge,25.2,74.0,60,0
    >>Hit the Auction House: buy a Frost Oil and a Gyrochronatom now -- two Badlands quests want them and buying beats farming
    .collect 3829,1,713 --Frost Oil
    .collect 4389,1,714 --Gyrochronatom

step << Priest
    #optional
    .goto Ironforge,24.73,8.16
    >>PRIEST (dwarves): High Priest Rohan by the Mystic Ward pool -- A Lack of Fear has waited since 20
    .turnin -5641 >> Turn in A Lack of Fear
    .turnin -5645 >> Turn in A Lack of Fear
    .turnin -5647 >> Turn in A Lack of Fear
    .target High Priest Rohan

step
    .goto Ironforge,55.5,47.7
    .fly Thelsamar >> Fly to Thelsamar

step
    .goto Loch Modan,47.0,86.0,60
    >>Ride south through the Loch's mountain pass into the Badlands
    .zone Badlands >> Enter the Badlands

step
    .goto Badlands,53.4,43.4
    >>Hammertoe's camp, mid-zone: Ryedol lost his pick when the dig fell, Sigrun sees mirages
    .accept 719 >> Accept A Dwarf and His Tools
    .goto Badlands,53.8,43.3
    .accept 718 >> Accept Mirages
    .target Prospector Ryedol
    .target Sigrun Ironhew

step
    .isOnQuest 719
    .goto Badlands,48.5,36.5,50,0
    >>Hammertoe's Dig Site crawls with Shadowforge dwarves -- Ryedol's Lucky Pick is among their plunder. Sigrun's supply crate lies out in the flats beyond
    .complete 719,1 --Ryedol's Lucky Pick
    .mob Shadowforge Darkweaver
    .mob Shadowforge Ruffian

step
    .isOnQuest 718
    .goto Badlands,44.0,28.0,60,0
    >>The supply crate for Sigrun -- search the northern flats where the mirage led
    .complete 718,1 --Supply Crate

step
    .goto Badlands,53.4,43.4
    >>Back at camp
    .turnin -719 >> Turn in A Dwarf and His Tools
    .goto Badlands,53.8,43.3
    .turnin -718 >> Turn in Mirages
    .accept 733,2,718 >> Accept Scrounging
    .target Prospector Ryedol
    .target Sigrun Ironhew

step
    .isOnQuest 733
    .goto Badlands,56.0,33.0,60,0
    >>Scrap Metal litters the trogg digs and crashed machines across the north -- seven pieces
    .complete -733,1 --Scrap Metal (7)

step
    .goto Badlands,42.4,52.9
    >>Rigglefuzz trades from his gulch. Pearl Diving's Blue Pearls come from the Giant Clams on the Vile Reef off Stranglethorn's northwest coast -- the 40-42 chapter passes it, and the 47-50 ride through the Badlands hands them in
    .accept 705 >> Accept Pearl Diving
    .accept 703 >> Accept Barbecued Buzzard Wings
    .target Rigglefuzz

step
    .isOnQuest 703
    .goto Badlands,50.0,55.0,70,0
    >>Buzzards wheel over all of the Badlands -- four wings
    .complete 703,1 --Buzzard Wing (4)
    .mob Buzzard

step
    .goto Badlands,25.9,44.8
    >>The gnome camp far west: Lotwil and Lucien study the elementals
    .accept 710 >> Accept Study of the Elements: Rock
    .turnin -713 >> Turn in Coolant Heads Prevail
    .accept 713 >> Accept Coolant Heads Prevail
    .turnin 713 >> Turn in Coolant Heads Prevail
    .accept 714 >> Accept Gyro... What?
    .turnin 714 >> Turn in Gyro... What?
    .target Lotwil Veriatus
    .target Lucien Tosselwrench

step
    .isOnQuest 710
    .goto Badlands,20.0,45.0,50,0
    >>Lesser Rock Elementals crumble in the western hills -- ten Small Stone Shards
    .complete 710,1 --Small Stone Shard (10)
    .mob Lesser Rock Elemental

step
    .goto Badlands,25.9,44.8
    .turnin 710 >> Turn in Study of the Elements: Rock
    .target Lotwil Veriatus

step
    .goto Badlands,42.4,52.9
    >>Riggle settles up
    .turnin -705 >> Turn in Pearl Diving
    .turnin -703 >> Turn in Barbecued Buzzard Wings
    .target Rigglefuzz

step
    .isOnQuest 733
    .goto Badlands,53.8,43.3
    .turnin -733 >> Turn in Scrounging
    .target Sigrun Ironhew

step
    #optional
    .goto Badlands,60.0,55.0,60,0
    >>OPTIONAL: a Corroded Black Box sometimes turns up on the crashed machines' wreckage -- it starts a quest that pays at Ironforge's Hall of Arms whenever you next visit
    .collect 4613,1,708 --Corroded Black Box
    .use 4613
    .accept 708 >> Accept The Black Box

step
    .goto Badlands,54.0,48.0
    .xp 38 >> Grind buzzards, coyotes and troggs to 38
]])

-- =================== 38-40 STRANGLETHORN VALE ========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 38-40 Stranglethorn Vale (Alliance)
#next 40-42 Stranglethorn (Alliance)
<< Alliance

step
    .goto Badlands,2.5,65.0,80,0
    >>Ride back west through the Loch pass; fly from Thelsamar
    .goto Loch Modan,33.9,51.0
    .fly Stormwind >> Fly to Stormwind

step
    .isOnQuest 563
    .goto 1453/0,405.37,-8421.17
    >>Stormwind Keep: Major Samuelson finally gets Farren's report from Hillsbrad -- you've carried it long enough
    .turnin -563 >> Turn in Reassignment
    .target Major Samuelson

step
    .goto 1453/0,484.20,-8832.50
    .fly Darkshire >> Fly to Darkshire

step
    .goto Duskwood,77.6,44.3,60,0
    >>Ride south out of Duskwood into Stranglethorn, then west off the road to Nesingwary's Expedition
    .goto Stranglethorn Vale,35.6,10.5
    .accept 583 >> Accept Welcome to the Jungle
    .turnin 583 >> Turn in Welcome to the Jungle
    .target Barnil Stonepot
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,35.6,10.6
    >>The camp's hunters each have a mastery to teach
    .accept 185 >> Accept Tiger Mastery
    .goto Stranglethorn Vale,35.5,10.5
    .accept 190 >> Accept Panther Mastery
    .goto Stranglethorn Vale,35.6,10.8
    .accept 194 >> Accept Raptor Mastery
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,38.0,3.0
    >>The Rebel Camp north: Kurzen's deserters fight their old colonel
    .accept 203 >> Accept The Second Rebellion
    .accept 204 >> Accept Bad Medicine
    .goto Stranglethorn Vale,37.8,3.5
    .accept 207,2,204 >> Accept Kurzen's Mystery
    .target Sergeant Yohwa
    .target Brother Nimetz

step
    .isOnQuest 185
    .goto Stranglethorn Vale,38.5,13.0,50,0
    >>Young Stranglethorn Tigers prowl the northern jungle -- Ajeck's first lesson
    .complete 185,1 --Young Stranglethorn Tiger (10)
    .mob Young Stranglethorn Tiger

step
    .isOnQuest 190
    .goto Stranglethorn Vale,40.0,17.0,50,0
    >>Young Panthers slink through the same stretch
    .complete 190,1 --Young Panther (10)
    .mob Young Panther

step
    .isOnQuest 203
    .goto Stranglethorn Vale,42.0,9.0,50,0
    >>Kurzen's Compound east: Jungle Fighters for Yohwa, Jungle Remedies from the medicine men, and the fetish clue Nimetz wants
    .complete 203,1 --Kurzen Jungle Fighter (15)
    .complete 204,1 --Jungle Remedy (7)
    .complete -207,1 --Kurzen's Mystery
    .mob Kurzen Jungle Fighter
    .mob Kurzen Medicine Man
    .mob Kurzen Witch Doctor

step
    .goto Stranglethorn Vale,38.0,3.0
    >>Rebel Camp round two
    .turnin -203 >> Turn in The Second Rebellion
    .turnin -204 >> Turn in Bad Medicine
    .target Sergeant Yohwa

step
    .goto Stranglethorn Vale,37.8,3.5
    >>Hand in Kurzen's Mystery at Brother Nimetz
    .turnin -207 >> Turn in Kurzen's Mystery
    .target Brother Nimetz

step
    .goto Stranglethorn Vale,37.8,3.5
    >>Take Troll Witchery at Brother Nimetz, then take Special Forces at Sergeant Yohwa
    .accept 205,2,207 >> Accept Troll Witchery
    .accept 574,2,204 >> Accept Special Forces
    .target Sergeant Yohwa
    .target Brother Nimetz

step
    .goto Stranglethorn Vale,35.6,10.6
    >>Masteries, lesson two
    .turnin -185 >> Turn in Tiger Mastery
    .accept 186 >> Accept Tiger Mastery
    .turnin -190 >> Turn in Panther Mastery
    .accept 191 >> Accept Panther Mastery
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin

step
    .isOnQuest 186
    .goto Stranglethorn Vale,36.0,16.0,60,0
    >>Grown Stranglethorn Tigers and Shadowmaw Panthers range deeper south
    .complete 186,1 --Stranglethorn Tiger (10)
    .complete 191,1 --Shadowmaw Panther (10)
    .mob Stranglethorn Tiger
    .mob Shadowmaw Panther

step
    .isOnQuest 194
    .goto Stranglethorn Vale,44.0,22.0,60,0
    >>Lashtail Raptors own the eastern slopes -- Hemet's first count
    .complete 194,1 --Lashtail Raptor (10)
    .mob Lashtail Raptor

step
    .isOnQuest 205
    .goto Stranglethorn Vale,31.0,26.0,60,0
    >>Skullsplitter trolls hold the river's far ridge -- their Fetishes prove Nimetz's fears. Kurzen Commandoes and Headshrinkers hide in the jungle between
    .complete -205,1 --Skullsplitter Fetish (4)
    .complete -574,1 --Kurzen Commando (10)
    .complete -574,2 --Kurzen Headshrinker (6)
    .mob Skullsplitter Hunter
    .mob Skullsplitter Witch Doctor
    .mob Kurzen Commando
    .mob Kurzen Headshrinker

step
    .goto Stranglethorn Vale,38.0,3.0
    >>Rebel Camp, last call
    .turnin -574 >> Turn in Special Forces
    .goto Stranglethorn Vale,37.8,3.5
    .turnin -205 >> Turn in Troll Witchery
    .target Lieutenant Doren
    .target Brother Nimetz

step
    .goto Stranglethorn Vale,35.6,10.6
    >>Masteries, lesson three -- and Hemet's second
    .turnin -186 >> Turn in Tiger Mastery
    .turnin -191 >> Turn in Panther Mastery
    .turnin -194 >> Turn in Raptor Mastery
    .accept 195 >> Accept Raptor Mastery
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .isOnQuest 195
    .goto Stranglethorn Vale,41.0,25.0,60,0
    >>Jungle Stalkers stalk the mid-vale
    .complete 195,1 --Jungle Stalker (10)
    .mob Jungle Stalker

step
    .goto Stranglethorn Vale,35.6,10.8
    .turnin -195 >> Turn in Raptor Mastery
    .target Hemet Nesingwary

step
    >>The long ride south to Booty Bay -- stay on the road, the jungle bites
    .goto Stranglethorn Vale,26.9,77.0
    .fp Booty Bay >> Get the Booty Bay flight path

step
    .isOnQuest 669
    .goto Stranglethorn Vale,27.1,77.0
    >>Fleet Master Seahorn takes O'Breen's sunken treasure report -- carried all the way from Faldir's Cove
    .turnin -669 >> Turn in Sunken Treasure
    .target Fleet Master Seahorn

step << Warlock
    #optional
    .isOnQuest 1798
    .goto Stranglethorn Vale,26.7,73.0
    >>WARLOCK: the felhunter. Take the boat from Booty Bay's dock to Ratchet -- Strahad Farsan waits at the tower above town
    .zone The Barrens >> Take the boat to Ratchet

step << Warlock
    #optional
    .isOnQuest 1798
    .goto The Barrens,62.6,35.5
    >>WARLOCK: Strahad Farsan, up the tower above Ratchet
    .turnin 1798 >> Turn in Seeking Strahad
    .accept 1758 >> Accept Tome of the Cabal
    .target Strahad Farsan

step << Warlock
    #optional
    .isOnQuest 1758
    .goto Ironforge,74.5,11.5
    >>Krom Stoutarm in Ironforge's library wing (fold this into any Ironforge trip): he knows the tome -- and what's needed to rebuild it. Gather the Moldy Tome and Tattered Manuscript his quest names, then bring the rebuilt tome and 3 Rods of Channeling back to Strahad
    .turnin 1758 >> Turn in Tome of the Cabal
    .accept 1802 >> Accept Tome of the Cabal
    .complete 1802,1 --Moldy Tome
    .complete 1802,2 --Tattered Manuscript
    .turnin 1802 >> Turn in Tome of the Cabal
    .accept 1804 >> Accept Tome of the Cabal
    .target Krom Stoutarm

step << Warlock
    #optional
    .isOnQuest 1804
    .goto The Barrens,62.6,35.5
    >>Back at Strahad's tower with tome and rods: the ritual begins. Subdue the felhunter his acolytes call, and it is yours
    .turnin 1804 >> Turn in Tome of the Cabal
    .accept 1795 >> Accept The Binding
    .complete 1795,1 --Subdue the felhunter
    .turnin 1795 >> Turn in The Binding
    .target Strahad Farsan

step
    .goto Stranglethorn Vale,28.2,77.5
    >>Booty Bay work: Drizzlik's crocolisk leather, Crank's singing crystals, Kebok's ears
    .accept 575 >> Accept Supply and Demand
    .target Drizzlik

step
    .goto Stranglethorn Vale,27.1,77.2
    >>Take Singing Blue Shards at Crank Fizzlebub
    .accept 605 >> Accept Singing Blue Shards
    .target Crank Fizzlebub

step
    .goto Stranglethorn Vale,27.0,77.1
    >>Take Bloodscalp Ears at Kebok
    .accept 189 >> Accept Bloodscalp Ears
    .target Kebok

step
    .isOnQuest 575
    .goto Stranglethorn Vale,32.0,66.0,60,0
    >>River Crocolisks wallow where the rivers meet north of the bay -- they drop the Large River Crocolisk Skins
    .complete 575,1 --Large River Crocolisk Skin (2)
    .mob River Crocolisk

step
    .isOnQuest 189
    .goto Stranglethorn Vale,20.0,42.0,70,0
    >>Bloodscalp trolls hold the northwest ridges -- Kebok buys their ears by the pile
    .complete 189,1 --Bloodscalp Ear (15)
    .mob Bloodscalp Headhunter
    .mob Bloodscalp Axe Thrower
    .mob Bloodscalp Hunter

step
    .isOnQuest 605
    .goto Stranglethorn Vale,34.0,40.0,60,0
    >>Crystal Spine Basilisks sun themselves mid-vale -- their singing shards are Crank's prize
    .complete 605,1 --Singing Crystal Shard (10)
    .mob Crystal Spine Basilisk

step
    .goto Stranglethorn Vale,28.2,77.5
    >>Booty Bay pays
    .turnin -575 >> Turn in Supply and Demand
    .target Drizzlik

step
    .goto Stranglethorn Vale,28.2,77.5
    >>Take Some Assembly Required at Drizzlik
    .accept 577,2,575 >> Accept Some Assembly Required
    .target Drizzlik

step
    .goto Stranglethorn Vale,27.1,77.2
    >>Hand in Singing Blue Shards at Crank Fizzlebub
    .turnin -605 >> Turn in Singing Blue Shards
    .target Crank Fizzlebub

step
    .goto Stranglethorn Vale,27.0,77.1
    >>Hand in Bloodscalp Ears at Kebok
    .turnin -189 >> Turn in Bloodscalp Ears
    .target Kebok

step
    .isOnQuest 577
    .goto Stranglethorn Vale,31.5,63.0,50,0
    >>Snapjaw Crocolisks snap along the southern riverbanks -- five skins finish Drizzlik's order
    .complete -577,1 --Snapjaw Crocolisk Skin (5)
    .mob Snapjaw Crocolisk

step
    .isOnQuest 577
    .goto Stranglethorn Vale,28.2,77.5
    .turnin -577 >> Turn in Some Assembly Required
    .target Drizzlik

step
    .goto Stranglethorn Vale,30.0,48.0
    .xp 40 >> Grind the vale's cats, raptors and trolls to level 40

step
    +ALLIANCE 1-40 COMPLETE -- the 40-42 Stranglethorn chapter continues from this very spot. Riding along: The Black Box (708 -- Ironforge Hall of Arms), Noble Deaths (512), A Noble Brew (335), Bride of the Embalmer (253), plus 2842/79007/97003 and any mastery finals you left (187/192/196 open up through the early 40s at Nesingwary's camp)
    +Level 40: your mount awaits. This whole 30-40 stretch is database-built -- report any step that points wrong.
]])
