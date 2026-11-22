--  RXPGuides_ForeverWarrior - Alliance 45-50
--  Built from the Forever quest database (no free-guide skeleton exists here).
--  Chunks: 45-47 Feralas > 47-50 Tanaris II / Searing Gorge.
--  Farm areas marked VERIFY are spawn-cluster centroids -- expect to roam.

-- ==================== 45-47 FERALAS ==================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 45-47 Feralas (Alliance)
#next 47-50 Tanaris/Searing Gorge (Alliance)
<< Alliance

step
    .goto Dustwallow Marsh,62.0,41.0,60,0
    >>From Theramore, ride west: through the marsh, across the southern Barrens, down into Thousand Needles, and west through the canyon into Feralas at Thalanaar
    .goto The Barrens,45.0,70.0,60,0
    .goto Thousand Needles,10.0,33.0,60,0
    .goto Feralas,89.5,46.0
    .fp Thalanaar >> Get the Thalanaar flight path

step
    .goto Feralas,66.0,46.0
    >>West along the road: the Moonweaver sisters camp by the Grimtotem grounds. Kindal's cage-break is a timed scrap (free 6 Sprite Darters while she fights)
    .accept 2969 >> Accept Freedom for All Creatures
    .target Kindal Moonweaver

step
    .goto Feralas,64.0,47.0
    >>The Grimtotem compound: run the cage break with Kindal
    .complete 2969,1 --Free the Sprite Darters

step
    .goto Feralas,66.0,46.0
    >>Kindal pays; with the darters free, Jer'kai pays for Grimtotem dead
    .turnin 2969 >> Turn in Freedom for All Creatures
    .accept 2970 >> Accept Doling Justice
    .target Kindal Moonweaver
    .target Jer'kai Moonweaver

step
    .goto Feralas,64.0,47.0
    >>Back into the compound: 12 Naturalists, 10 Raiders, 6 Shamans
    .complete 2970,1 --Grimtotem Naturalist (12)
    .complete 2970,2 --Grimtotem Raider (10)
    .complete 2970,3 --Grimtotem Shaman (6)
    .mob Grimtotem Naturalist
    .mob Grimtotem Raider
    .mob Grimtotem Shaman

step
    .goto Feralas,66.0,46.0
    >>Jer'kai pays out. Her ring follow-up goes to Darnassus, off this route -- skip it
    .turnin 2970 >> Turn in Doling Justice
    .target Jer'kai Moonweaver

step
    .goto Feralas,75.0,45.0
    >>Gordunni ogres hold the eastern woods: Angelas' tally comes later at the stronghold, but their camps line our road -- clear as you ride west (8 Warlocks, 8 Shamans, 5 Maulers count once the quest is in)
    .mob Gordunni Warlock
    .mob Gordunni Shaman
    .mob Gordunni Mauler

step
    .goto Feralas,31.0,43.0
    >>Ferry to Feathermoon Stronghold on the isle: flight path, then Shandris opens the naga war
    .fp Feathermoon >> Get the Feathermoon flight path

step
    .goto Feralas,30.0,46.0
    >>Take The Ruins of Solarsal at Shandris Feathermoon
    .accept 2866 >> Accept The Ruins of Solarsal
    .target Shandris Feathermoon

step
    .goto Feralas,30.4,46.2
    >>Take The Missing Courier at Latronicus Moonspear
    .accept 4124 >> Accept The Missing Courier
    .target Latronicus Moonspear

step
    .goto Feralas,31.9,45.1
    >>Hand in The Missing Courier; take The Missing Courier at Ginro Hearthkindle
    .turnin -4124 >> Turn in The Missing Courier
    .accept 4125,2,4124 >> Accept The Missing Courier
    .target Ginro Hearthkindle

step
    .goto Feralas,32.0,46.0
    >>Take The High Wilderness at Angelas Moonbreeze
    .accept 2982 >> Accept The High Wilderness
    .target Angelas Moonbreeze

step
    .goto 1444/1,3312.88,-4345.56
    >>Take The Mark of Quality at Pratt McGrubben
    .accept 2821 >> Accept The Mark of Quality
    .target Pratt McGrubben

step
    .goto Feralas,26.0,50.0
    >>South end of the isle: walk the Ruins of Solarsal to scout the naga, then report back
    .complete 2866,1 --Explore Solarsal

step
    .goto 1444/1,3613.12,-4791.75
    >>Hand in The Ruins of Solarsal; take Return to Feathermoon Stronghold at Solarsal Gazebo
    .turnin -2866 >> Turn in The Ruins of Solarsal
    .accept 2867,2,2866 >> Accept Return to Feathermoon Stronghold

step
    .goto Feralas,30.0,46.0
    >>Hand in Return to Feathermoon Stronghold; take Against the Hatecrest at Shandris Feathermoon
    .turnin -2867 >> Turn in Return to Feathermoon Stronghold
    .accept 3130,2,2867 >> Accept Against the Hatecrest
    .target Shandris Feathermoon

step
    .goto Feralas,30.0,46.2
    >>Hand in Against the Hatecrest; take Against the Hatecrest at Latronicus Moonspear
    .turnin -3130 >> Turn in Against the Hatecrest
    .accept 2869,2,3130 >> Accept Against the Hatecrest
    .target Latronicus Moonspear

step
    .goto Feralas,28.0,52.0
    >>Hatecrest naga swarm the isle's shores and Sardor's sands: 10 scales, then Lord Shalzaru in his cave for the relic
    .complete -2869,1 --Hatecrest Naga Scale (10)
    .mob Hatecrest Warrior
    .mob Hatecrest Sorceress
    .mob Hatecrest Myrmidon

step
    .goto Feralas,30.0,46.2
    >>Latronicus advances the war to Shalzaru himself
    .turnin -2869 >> Turn in Against the Hatecrest
    .accept 2870,2,2869 >> Accept Against Lord Shalzaru
    .target Latronicus Moonspear

step
    .goto Feralas,28.5,70.5
    >>The Mysterious Relic
    .complete -2870,1 --The Mysterious Relic

step
    .goto Feralas,30.0,46.2
    >>Hand in Against Lord Shalzaru; take Delivering the Relic at Latronicus Moonspear
    .turnin -2870 >> Turn in Against Lord Shalzaru
    .accept 2871,2,2870 >> Accept Delivering the Relic
    .target Latronicus Moonspear

step
    .goto Feralas,30.0,45.0
    >>Hand in Delivering the Relic at Vestia Moonspear
    .turnin -2871 >> Turn in Delivering the Relic
    .target Vestia Moonspear

step
    .goto Feralas,45.4,65.0
    >>Ferry back to the mainland and ride south down the Forgotten Coast: the courier's Wrecked Row Boat lies on the shore -- click it to report, and it hands you the next lead
    .turnin -4125 >> Turn in The Missing Courier

step
    .goto Feralas,45.4,65.0
    >>Take Boat Wreckage at Wrecked Row Boat
    .accept 4127,2,4125 >> Accept Boat Wreckage

step
    #optional
    .goto Feralas,42.4,22.0
    >>OPTIONAL, while on the mainland: Rockbiter the giant has lost his night elf girl up the coast -- walking Shay home is slow, sweet, and pays like a dungeon quest. You find her after the yetis
    .accept 2844 >> Accept The Giant Guardian
    .target Rockbiter

step
    .goto Feralas,54.0,57.5
    >>Feral Scar Vale, the yeti valley in central Feralas: 10 Thick Yeti Hides for Pratt
    .complete 2821,1 --Thick Yeti Hide (10)
    .mob Feral Scar Yeti
    .mob Enraged Feral Scar
    .mob Hulking Feral Scar

step
    .goto Feralas,43.0,36.5
    >>Vale Screechers for Yeh'kinya: kill them, then use his bramble on the corpses to free 3 Screecher Spirits
    .complete 3520,1 --Screecher Spirits (3)
    .mob Rogue Vale Screecher
    .mob Vale Screecher

step
    #optional
    .isOnQuest 2844
    .goto Feralas,38.2,10.3
    >>Shay Leafrunner, north of the yeti caves: report in, take Shay's Bell from the chest beside her, then walk her south to Rockbiter -- ring the bell whenever she wanders off
    .turnin -2844 >> Turn in The Giant Guardian
    .target Shay Leafrunner

step
    #optional
    .goto Feralas,38.2,10.3
    >>Take Wandering Shay at Shay Leafrunner
    .accept 2845,2,2844 >> Accept Wandering Shay
    .target Shay Leafrunner

step
    #optional
    .goto Feralas,38.2,10.3
    >>Shay's Bell
    .complete -2845,1 --Shay's Bell

step
    #optional
    .isOnQuest 2845
    .goto Feralas,42.4,22.0
    >>Rockbiter, with Shay in tow
    .turnin -2845 >> Turn in Wandering Shay
    .target Rockbiter

step
    #optional
    .isOnQuest 4127
    .goto Feralas,31.9,45.1
    >>Back on the isle with the wreckage: Ginro reads it, Quintis reads the knife, and the trail points to the Woodpaw gnolls in the east
    .turnin -4127 >> Turn in Boat Wreckage
    .target Ginro Hearthkindle

step
    #optional
    .goto Feralas,31.9,45.1
    >>Take The Knife Revealed at Ginro Hearthkindle
    .accept 4129,2,4127 >> Accept The Knife Revealed
    .target Ginro Hearthkindle

step
    #optional
    .goto Feralas,32.5,43.8
    >>Hand in The Knife Revealed at Quintis Jonespyre
    .turnin -4129 >> Turn in The Knife Revealed
    .target Quintis Jonespyre

step
    #optional
    .goto Feralas,32.5,43.8
    >>Take Psychometric Reading at Quintis Jonespyre
    .accept 4130,2,4129 >> Accept Psychometric Reading
    .target Quintis Jonespyre

step
    #optional
    .goto Feralas,31.9,45.1
    >>Hand in Psychometric Reading at Ginro Hearthkindle
    .turnin -4130 >> Turn in Psychometric Reading
    .target Ginro Hearthkindle

step
    #optional
    .goto Feralas,31.9,45.1
    >>Take The Woodpaw Gnolls at Ginro Hearthkindle
    .accept 4131,2,4130 >> Accept The Woodpaw Gnolls
    .target Ginro Hearthkindle

step
    #optional
    .isOnQuest 4131
    .goto Feralas,73.3,56.3
    >>Far east past the Woodpaw camps: the courier's Large Leather Backpacks lie at a gnoll camp -- search them, then follow the trail into the Writhing Deep hive and open Raschal's Zukk'ash Pod (46: a tight fight, bring cooldowns)
    .turnin -4131 >> Turn in The Woodpaw Gnolls

step
    #optional
    .goto Feralas,73.3,56.3
    >>Take The Writhing Deep at Large Leather Backpacks
    .accept 4135,2,4131 >> Accept The Writhing Deep

step
    #optional
    .goto Feralas,72.1,63.7
    >>Hand in The Writhing Deep at Zukk'ash Pod
    .turnin -4135 >> Turn in The Writhing Deep

step
    #optional
    .goto Feralas,72.1,63.7
    >>Take Freed from the Hive at Zukk'ash Pod
    .accept 4265,2,4135 >> Accept Freed from the Hive

step
    #optional
    .isOnQuest 4265
    .goto Feralas,31.9,45.1
    >>Feathermoon: Ginro hears Raschal is alive, and Shandris thanks you
    .turnin -4265 >> Turn in Freed from the Hive
    .target Ginro Hearthkindle

step
    #optional
    .goto Feralas,31.9,45.1
    >>Take A Hero's Welcome at Ginro Hearthkindle
    .accept 4266,2,4265 >> Accept A Hero's Welcome
    .target Ginro Hearthkindle

step
    #optional
    .goto Feralas,30.3,46.2
    >>Hand in A Hero's Welcome at Shandris Feathermoon
    .turnin -4266 >> Turn in A Hero's Welcome
    .target Shandris Feathermoon

step
    .goto Feralas,32.0,46.0
    >>Angelas counts the Gordunni you've dropped -- finish her tally in the eastern woods if short (skip her Sunken Temple referral -- a dungeon errand off this route)
    .turnin 2982 >> Turn in The High Wilderness
    .target Angelas Moonbreeze

step
    .goto 1444/1,3312.88,-4345.56
    >>Pratt pays for the hides (skip his Rage Scar follow-up -- off this route)
    .turnin 2821 >> Turn in The Mark of Quality
    .target Pratt McGrubben

step
    .goto Feralas,31.0,44.0
    .xp 47 >> Yetis, naga, and Gordunni to 47 -- then back to the sands

step
    .goto Feralas,30.3,43.2
    .fly Thalanaar >> Fly to Thalanaar, then ride east through the Needles to Tanaris
]])

-- ============ 47-50 TANARIS / SEARING GORGE ==========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 47-50 Tanaris/Searing Gorge (Alliance)
#next 50-53 Un'Goro Crater (Alliance)
<< Alliance

step
    .goto Thousand Needles,80.0,75.0,60,0
    >>Across the Shimmering Flats one more time, into Tanaris, straight to the port: Yeh'kinya takes his screecher spirits
    .goto Tanaris,67.0,22.0
    .turnin 3520 >> Turn in Screecher Spirits
    .target Yeh'kinya

step
    .goto Tanaris,50.0,27.0
    >>Gadgetzan: the surveyor's insect file is now yours to open -- the Noxious Lair west crawls with Centipaar; five parts for Pestlezugg, then the Scrimshank search inside the hive gauntlet (48: surface tunnels, nasty swarms -- clear with space)
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,33.0,35.0
    >>The Noxious Lair: Centipaar wasps and workers drop the insect parts
    .complete -82,1 --Centipaar Insect Parts (5)
    .mob Centipaar Wasp
    .mob Centipaar Stinger
    .mob Centipaar Worker

step
    .goto Tanaris,51.0,27.0
    >>Pestlezugg reads the parts; Fizzledowser sends you back for Scrimshank himself
    .turnin -82 >> Turn in Noxious Lair Investigation
    .target Alchemist Pestlezugg

step
    .goto Tanaris,50.0,27.0
    >>Take The Scrimshank Redemption at Senior Surveyor Fizzledowser
    .accept 10,2,82 >> Accept The Scrimshank Redemption
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,56.0,71.2
    >>Into the hive tunnels south of the lair: find Scrimshank's surveying gear (he didn't make it)
    .complete -10,1 --Scrimshank's gear

step
    .goto Tanaris,50.0,27.0
    >>The report ping-pongs between the goblins (skip the Darnassus leg after it -- off this route)
    .turnin -10 >> Turn in The Scrimshank Redemption
    .accept 110,2,10 >> Accept Insect Part Analysis
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,51.0,27.0
    >>Hand in Insect Part Analysis; take Insect Part Analysis at Alchemist Pestlezugg
    .turnin -110 >> Turn in Insect Part Analysis
    .accept 113,2,110 >> Accept Insect Part Analysis
    .target Alchemist Pestlezugg

step
    .goto Tanaris,50.0,27.0
    >>Hand in Insect Part Analysis at Senior Surveyor Fizzledowser
    .turnin -113 >> Turn in Insect Part Analysis
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,52.0,27.0
    >>Tran'rek's Thistleshrub purge southwest: 8 Gnarled Thistleshrubs, 8 Thistleshrub Rootshapers -- dense, fast kills at 48
    .accept 3362 >> Accept Thistleshrub Valley
    .target Tran'rek

step
    .goto Tanaris,29.0,63.0
    >>Thistleshrub Valley: the walking brambles
    .complete 3362,1 --Gnarled Thistleshrub (8)
    .complete 3362,2 --Thistleshrub Rootshaper (8)
    .mob Gnarled Thistleshrub
    .mob Thistleshrub Rootshaper

step
    .goto Tanaris,52.0,27.0
    .turnin 3362 >> Turn in Thistleshrub Valley
    .target Tran'rek

step
    #optional
    .goto Tanaris,60.0,65.0
    >>OPTIONAL on the way out: if you looted OOX-17/TN's distress beacon, report in at the crashed robot in the southern dunes. Skip the escort after it -- it finishes in Booty Bay, off this route
    .turnin -351 >> Turn in Find OOX-17/TN!

step
    .goto Tanaris,51.0,29.3
    >>Fly for the Eastern Kingdoms: Searing Gorge closes the decade. Route: fly Theramore, boat Menethil, fly Ironforge, then ride south -- through Loch Modan, down the Badlands' west edge, and in through the Searing Gorge's southern slip by the Kargath side pass
    .fly Theramore >> Fly to Theramore

step
    .goto Wetlands,10.7,60.0,30,0
    .goto Ironforge,55.5,47.7,20,0
    .goto Loch Modan,35.0,50.0
    >>From Menethil through Dun Morogh and Ironforge, then Loch Modan -- the pass south of Thelsamar opens into the Badlands
    .zone Badlands

step
    #optional
    .isQuestComplete 705
    .goto Badlands,42.4,52.9
    >>Carrying Rigglefuzz's 9 Blue Pearls from Stranglethorn? His gulch is a short detour south
    .turnin -705 >> Turn in Pearl Diving
    .target Rigglefuzz

step
    .goto Badlands,8.0,20.0,60,0
    .goto Searing Gorge,36.0,70.0
    >>West out of the Badlands and through the gate into the Searing Gorge
    .zone Searing Gorge

step
    .goto Searing Gorge,39.0,39.0
    >>Kalaran Windblade at the Tower of Flames: hear his whole story (sit through it -- the chain is the zone's spine), then his flame gathering: 4 Hearts of Flame from the fire elementals, 4 Golem Oil from the golems
    .accept 3441 >> Accept Divine Retribution
    .complete 3441,1
    .turnin 3441 >> Turn in Divine Retribution
    .accept 3442 >> Accept The Flawless Flame
    .target Kalaran Windblade

step
    .goto Searing Gorge,45.0,45.0
    >>The Cauldron's rim: Heavy War Golems leak oil, Inferno Elementals carry hearts -- 47-49 mobs, dense XP
    .complete 3442,1 --Heart of Flame (4)
    .complete 3442,2 --Golem Oil (4)
    .mob Heavy War Golem
    .mob Inferno Elemental

step
    .goto Searing Gorge,39.0,39.0
    >>Kalaran forges on: 8 Thorium Plated Daggers (blacksmith work -- the AH stocks them cheap most days)
    .turnin 3442 >> Turn in The Flawless Flame
    .target Kalaran Windblade

step
    .goto Searing Gorge,39.0,39.0
    >>Take Forging the Shaft at Kalaran Windblade
    .accept 3443,2,3442 >> Accept Forging the Shaft
    .target Kalaran Windblade

step
    .goto Searing Gorge,39.0,39.0
    >>Thorium Plated Dagger, then hand in Forging the Shaft at Kalaran Windblade
    .collect 10551,8,3443,1 --Thorium Plated Dagger
    .turnin -3443 >> Turn in Forging the Shaft
    .target Kalaran Windblade

step
    .goto Searing Gorge,64.0,61.0
    >>Dorius Stonetender lies hurt among the Suntara Stones -- helping him home opens an Ironforge thread (escort-style). His singed letter lands with Curator Thorius in the Hall of Explorers
    .accept 3367 >> Accept Suntara Stones
    .target Dorius Stonetender

step
    .goto Searing Gorge,64.0,61.0
    >>Finish Suntara Stones
    .complete -3367,1

step
    .goto 1427/0,-1984.08,-6386.94
    >>Hand in Suntara Stones at Singed Letter
    .turnin -3367 >> Turn in Suntara Stones

step
    .goto 1427/0,-1984.08,-6386.94
    >>Take Suntara Stones at Singed Letter
    .accept 3368,2,3367 >> Accept Suntara Stones

step
    .goto 1427/0,-1786.39,-7024.78
    >>Dark Iron Geologists dot the slag flats -- 8 of them plus 15 Silk Cloth free the trapped prisoner at the dig (the Caught! chain; his ledger copy routes back to Krinkle Goodsteel in Gadgetzan -- bank it). The Grimesilt Outhouse Key he mentions opens exactly what it sounds like, east side
    .accept 4449 >> Accept Caught!

step
    .goto Searing Gorge,40.0,60.0
    >>Dark Iron Geologist (8), Silk Cloth (15)
    .complete -4449,1 --Dark Iron Geologist (8)
    .complete -4449,2 --Silk Cloth (15)
    .mob Dark Iron Geologist

step
    .goto 1427/0,-1786.39,-7024.78
    >>Hand in Caught! at Wooden Outhouse
    .turnin -4449 >> Turn in Caught!

step
    .goto Searing Gorge,42.0,50.0
    .xp 50 >> HALFWAY TO FIFTY DONE: golems, elementals, and Dark Iron crews pay the last stretch -- grind the Cauldron to 50

step
    +CHAPTER COMPLETE AT 50 -- Un'Goro Crater continues the chain. Riding along: Rise of the Silithid x2 (162 Darnassus, 4267 Darnassus), Ledger from Tanaris (4450, Krinkle in Gadgetzan), Suntara's letter (3368, Thorius in Ironforge), Mai'Zoth (206, Rebel Camp), Seahorn's captains (608), Sunken Temple referral (3445, Marvon in Tanaris), Noggenfogger + Fizzledowser follow-ups in Gadgetzan, Un'Goro and Blasted Lands boards open at 50, plus any mastery finals, OOX escorts, and warrior armor branches still riding
    +This chunk is fresh from the quest database -- report any step that misbehaves with its number.
]])
