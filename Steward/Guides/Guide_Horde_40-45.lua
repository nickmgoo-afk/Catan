--  RXPGuides_ForeverWarrior - Horde 40-45
--  Built from the Forever quest database (no free-guide skeleton exists here).
--  Chunks: 40-42 Dustwallow/Orgrimmar > 42-44 Stranglethorn II/Swamp >
--  44-46 Tanaris. Farm areas marked VERIFY are spawn-cluster centroids.

-- ============ 40-42 DUSTWALLOW / ORGRIMMAR ===========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 40-42 Dustwallow/Orgrimmar (Horde)
#next 42-44 Stranglethorn II/Swamp (Horde)
<< Horde

step
    .isOnQuest 1262
    .goto Orgrimmar,38.9,38.4
    >>Level 40, mount bought. First, old business: the Jeweled Pendant from Dustwallow lands with Zor Lonetree in the Valley of Wisdom -- and he pays twice
    .turnin -1262 >> Turn in Report to Zor
    .target Zor Lonetree

step
    .goto Orgrimmar,38.9,38.4
    >>Take Service to the Horde at Zor Lonetree
    .accept 7541,2,1262 >> Accept Service to the Horde
    .target Zor Lonetree

step
    .goto Orgrimmar,38.9,38.4
    >>Hand in Service to the Horde at Zor Lonetree
    .turnin -7541 >> Turn in Service to the Horde
    .target Zor Lonetree

step
    .goto Orgrimmar,75.2,34.2
    >>Valley of Honor: Belgrom Rockmaul takes the silithid parts you've carried since Thousand Needles
    .turnin -1184 >> Turn in Parts of the Swarm
    .target Belgrom Rockmaul

step
    .goto Orgrimmar,45.1,63.9
    .fly Thunder Bluff >> Fly to Thunder Bluff

step
    .goto Thunder Bluff,61.0,81.0
    >>Hunter Rise: Melor hunts a monster crocolisk -- and if you still carry the Black Shield, Mosarn near the rise closes that file
    .accept 1205 >> Accept Deadmire
    .target Melor Stonehoof

step
    .goto Thunder Bluff,54.0,80.8
    >>Hand in The Black Shield at Mosarn
    .turnin -1276 >> Turn in The Black Shield
    .target Mosarn

step << Warrior
    #optional
    .isOnQuest 1840
    .goto 1456/1,109.71,-1239.53
    >>Took Orm Stonehoof and the Brutal Helm earlier? Orm Stonehoof is right here -- hand it in
    .turnin -1840 >> Turn in Orm Stonehoof and the Brutal Helm
    .target Orm Stonehoof

step
    .goto Thunder Bluff,46.8,50.1
    .fly Brackenwall >> Fly to Brackenwall Village

step
    .goto Dustwallow Marsh,36.4,31.5
    >>Brackenwall's second board: the Overlord lost his luggage fleeing Stonemaul, Tharg wants the Firemane dead, Draz'Zilb wants their innards
    .accept 1166 >> Accept Overlord Mok'Morokk's Concern
    .target Overlord Mok'Morokk

step
    .goto Dustwallow Marsh,37.0,31.0
    >>Take Army of the Black Dragon at Tharg
    .accept 1168 >> Accept Army of the Black Dragon
    .target Tharg

step
    .goto Dustwallow Marsh,37.0,33.0
    >>Take Identifying the Brood at Draz'Zilb
    .accept 1169 >> Accept Identifying the Brood
    .target Draz'Zilb

step
    .goto Dustwallow Marsh,35.2,30.7
    >>And if Marg's Jeweled Pendant ever dropped for you, Nazeer sends it on to Orgrimmar
    .turnin -1261 >> Turn in Marg Speaks
    .target Nazeer Bloodpike

step
    .goto Dustwallow Marsh,35.2,30.7
    >>Take Report to Zor at Nazeer Bloodpike
    .accept 1262,2,1261 >> Accept Report to Zor
    .target Nazeer Bloodpike

step
    .goto Dustwallow Marsh,38.0,56.0
    >>The Dragonmurk south: Firemane Scouts, Ash Tails, and Flamecallers die for Tharg (10/10/5) while their Searing Tongues and Hearts stack for Draz'Zilb (15 each) -- one long smash through the drake hollows
    .complete 1168,1 --Firemane Scout (10)
    .complete 1168,2 --Firemane Ash Tail (10)
    .complete 1168,3 --Firemane Flamecaller (5)
    .complete 1169,1 --Searing Tongue (15)
    .complete 1169,2 --Searing Heart (15)
    .mob Firemane Scout
    .mob Firemane Ash Tail
    .mob Firemane Flamecaller

step
    .goto Dustwallow Marsh,40.0,61.0
    >>Mok'Morokk's goods lie where Stonemaul fell: his grog, snuff, and strongbox scattered through the ruined village
    .complete 1166,1 --Mok'Morokk's Grog
    .complete 1166,2 --Mok'Morokk's Snuff
    .complete 1166,3 --Mok'Morokk's Strongbox

step
    .goto Dustwallow Marsh,47.0,55.0
    >>Deadmire wallows in the mire east of the Dragonmurk -- an old, huge crocolisk. Take his tooth for Melor
    .complete 1205,1 --Deadmire's Tooth
    .unitscan Deadmire

step
    .goto Dustwallow Marsh,36.4,31.5
    >>Brackenwall pays -- and the Overlord's cowardice becomes a succession crisis: the brood proof passes between Draz'Zilb and the Overlord until someone has to swing
    .turnin 1166 >> Turn in Overlord Mok'Morokk's Concern
    .target Overlord Mok'Morokk

step
    .goto Dustwallow Marsh,37.0,31.0
    >>Hand in Army of the Black Dragon at Tharg
    .turnin -1168 >> Turn in Army of the Black Dragon
    .target Tharg

step
    .goto Dustwallow Marsh,37.0,33.0
    >>Hand in Identifying the Brood; take The Brood of Onyxia at Draz'Zilb
    .turnin -1169 >> Turn in Identifying the Brood
    .accept 1170,2,1169 >> Accept The Brood of Onyxia
    .target Draz'Zilb

step
    .goto Dustwallow Marsh,36.4,31.5
    >>Hand in The Brood of Onyxia; take The Brood of Onyxia at Overlord Mok'Morokk
    .turnin -1170 >> Turn in The Brood of Onyxia
    .accept 1171,2,1170 >> Accept The Brood of Onyxia
    .target Overlord Mok'Morokk

step
    .goto Dustwallow Marsh,37.0,33.0
    >>Hand in The Brood of Onyxia; take The Brood of Onyxia at Draz'Zilb
    .turnin -1171 >> Turn in The Brood of Onyxia
    .accept 1172,2,1171 >> Accept The Brood of Onyxia
    .target Draz'Zilb

step
    .goto Dustwallow Marsh,48.4,74.8
    >>Back into the Dragonmurk: smash 5 Eggs of Onyxia among the drake nests
    .complete -1172,1 --Eggs of Onyxia (5)

step
    .goto Dustwallow Marsh,37.0,33.0
    >>Draz'Zilb arms you for the coup: challenge Overlord Mok'Morokk in the middle of camp. He hits like an ogre twice his rank -- pop cooldowns, let him chase you around the hut if it gets ugly
    .turnin -1172 >> Turn in The Brood of Onyxia
    .target Draz'Zilb

step
    .goto 1445/1,-2880.22,-3132.68
    >>Take Challenge Overlord Mok'Morokk at Overlord Mok'Morokk
    .accept 1173,2,1172 >> Accept Challenge Overlord Mok'Morokk
    .target Overlord Mok'Morokk

step
    .goto Dustwallow Marsh,36.4,31.5
    >>Defeat Mok'Morokk
    .complete -1173,1 --Defeat Mok'Morokk

step
    .goto Dustwallow Marsh,37.0,33.0
    >>Hand in Challenge Overlord Mok'Morokk at Draz'Zilb
    .turnin -1173 >> Turn in Challenge Overlord Mok'Morokk
    .target Draz'Zilb

step
    .goto Dustwallow Marsh,35.6,32.2
    >>Fly to Thunder Bluff -- Melor takes the tooth
    .fly Thunder Bluff >> Fly to Thunder Bluff

step
    .goto Thunder Bluff,61.0,81.0
    .turnin 1205 >> Turn in Deadmire
    .target Melor Stonehoof

step
    .goto Thunder Bluff,55.0,80.0
    .xp 42 >> Shy of 42? The Dragonmurk drakes respawn fast -- or carry on, the jungle pays better

step
    .goto Thunder Bluff,46.8,50.1
    >>Fly to Orgrimmar and catch the Grom'gol zeppelin -- round two of the jungle
    .fly Orgrimmar >> Fly to Orgrimmar

step
    .goto Durotar,50.8,13.8
    .zone Stranglethorn Vale >> Zeppelin to Grom'gol
]])

-- ========== 42-44 STRANGLETHORN II / SWAMP ===========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 42-44 Stranglethorn II/Swamp (Horde)
#next 44-46 Tanaris (Horde)
<< Horde

step
    .goto Stranglethorn Vale,32.1,29.2
    >>Grom'gol, third visit: Mok'thardin trades the stalker feathers for a gorilla errand; Kin'weelay opens the hunt for Yenniku's soul -- the saga you started with the cauldron
    .turnin -572 >> Turn in Mok'thardin's Enchantment
    .accept 571,2,572 >> Accept Mok'thardin's Enchantment
    .target Far Seer Mok'thardin
    .target Nimboya

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Take Split Bone Necklace at Kin'weelay, then hand in Speaking with Gan'zulah at Bubbling Cauldron, then hand in The Fate of Yenniku at Kin'weelay
    .accept 598,2,596 >> Accept Split Bone Necklace
    .turnin -586 >> Turn in Speaking with Gan'zulah
    .turnin -588 >> Turn in The Fate of Yenniku
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Take The Singing Crystals at Kin'weelay
    .accept 589,2,588 >> Accept The Singing Crystals
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.2,27.7
    >>Nimboya also wants his grim message carried: Witherbark Skulls on a pike at their Hinterlands village -- that's the 48-50 chapter's territory; the pike rides along
    .accept 2932 >> Accept Grim Message
    .target Nimboya

step
    #optional
    .isOnQuest 586
    .goto Stranglethorn Vale,45.6,42.5
    >>If Gan'zulah's spirit set a kill list (8 Hunters, 6 Headhunters, 4 Berserkers), the Skullsplitter trolls hold the ruins in central Stranglethorn -- and the Split Bone Necklaces drop from every troll in the vale
    .complete -586,1
    .complete -586,2
    .complete -586,3
    .mob Skullsplitter Hunter
    .mob Skullsplitter Headhunter
    .mob Skullsplitter Berserker

step
    .goto Stranglethorn Vale,42.9,47.2
    >>The basilisk hills of central Stranglethorn: Ironjaw Basilisks drop the 3 Pulsing Blue Shards for Kin'weelay
    .complete -589,1 --Pulsing Blue Shard (3)

step
    .goto Stranglethorn Vale,31.0,65.0
    >>South through the vale: Mistvale Gorillas drop the Aged Gorilla Sinew; keep smashing trolls for the 25 Split Bone Necklaces as you go
    .complete -571,1 --Aged Gorilla Sinew
    .mob Mistvale Gorilla
    .mob Skullsplitter Hunter

step
    .goto Stranglethorn Vale,45.0,42.9
    >>Split Bone Necklace (25)
    .complete -598,1 --Split Bone Necklace (25)
    .mob Mistvale Gorilla
    .mob Skullsplitter Hunter

step
    .goto Stranglethorn Vale,28.0,77.0
    >>Booty Bay: Stoley's bottle finally pays MacKinley -- and MacKinley's debt-collection points you to Stoley himself in Tanaris, which is two chapters of ours from now. Take it
    .turnin -2874 >> Turn in Deliver to MacKinley
    .accept 2872 >> Accept Stoley's Debt
    .target "Sea Wolf" MacKinley

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Back at camp the saga turns: Kin'weelay reads the shards, and the Mind's Eye he needs sits with the Mosh'Ogg ogres in their eastern mound
    .turnin -589 >> Turn in The Singing Crystals
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Take The Mind's Eye; hand in Split Bone Necklace at Kin'weelay
    .accept 591,2,589 >> Accept The Mind's Eye
    .turnin -598 >> Turn in Split Bone Necklace
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.1,29.2
    >>Hand in Mok'thardin's Enchantment at Far Seer Mok'thardin
    .turnin -571 >> Turn in Mok'thardin's Enchantment
    .target Far Seer Mok'thardin

step
    .goto Stranglethorn Vale,52.9,27.6
    >>The Mosh'Ogg mound: carve through the ogres for the Mind's Eye (skip Mok'thardin's next errand -- its Holy Spring Water and naga sit off this route)
    .complete -591,1 --The Mind's Eye
    .mob Mosh'Ogg Warmonger
    .mob Mosh'Ogg Shaman

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Kin'weelay binds the gem -- take it to Yenniku himself among the Nezzliok trolls at Lake Nazferiti: use it when he stands before you, then bring the boy's soul home to Nimboya
    .turnin -591 >> Turn in The Mind's Eye
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Take Saving Yenniku at Kin'weelay
    .accept 592,2,591 >> Accept Saving Yenniku
    .target Kin'weelay

step
    .goto Stranglethorn Vale,39.0,58.0
    >>Take Filling the Soul Gem at Yenniku
    .accept 593 >> Accept Filling the Soul Gem
    .target Yenniku

step
    .goto Stranglethorn Vale,39.0,58.0
    >>Fill the Soul Gem, then hand in Filling the Soul Gem at Yenniku
    .complete -593,1 --Fill the Soul Gem
    .turnin -593 >> Turn in Filling the Soul Gem
    .target Yenniku

step
    .goto Stranglethorn Vale,32.2,27.7
    >>Hand in Saving Yenniku, Grim Message at Nimboya
    .turnin -592 >> Turn in Saving Yenniku
    .turnin -2932,0 >> (Grim Message completes after the Hinterlands pike -- it waits)
    .target Nimboya

step
    .goto Stranglethorn Vale,32.0,20.0,60,0
    >>North out of the vale on foot: through Duskwood along the river road (ride hard, wave at the Night Watch), over the Deadwind pass, and down into the Swamp of Sorrows
    .goto Duskwood,85.0,36.0,60,0
    .goto Deadwind Pass,52.0,35.0
    .zone Swamp of Sorrows

step
    .goto Swamp of Sorrows,47.0,55.0
    >>Stonard, the Horde's swamp fort: flight path, hearth, and the banked report from Kargath finally lands with Helgrum
    .fp Stonard >> Get the Stonard flight path
    .home >> Set your Hearthstone to Stonard
    .goto Swamp of Sorrows,47.7,55.2
    .turnin -1420 >> Turn in Report to Helgrum

step
    .goto Swamp of Sorrows,45.0,57.0
    >>The Stonard board: Dar wants croc flanks delivered east and fresh crawler legs; Fel'zerul wants the sunken temple's trinkets
    .accept 698 >> Accept Lack of Surplus
    .accept 1430 >> Accept Fresh Meat
    .target Dar

step
    .goto Swamp of Sorrows,48.0,55.0
    >>Take Pool of Tears at Fel'zerul
    .accept 1424 >> Accept Pool of Tears
    .target Fel'zerul

step
    .goto Swamp of Sorrows,89.6,87.3
    >>East through the swamp: Monstrous Crawlers on the mud flats (10 legs), Sawtooth crocolisks in the channels -- the flanks you carry count for Tok'Kar on delivery
    .complete 1430,1 --Monstrous Crawler Leg (10)
    .mob Monstrous Crawler
    .mob Sawtooth Crocolisk

step
    .goto Swamp of Sorrows,81.0,81.0
    >>Tok'Kar's fishing camp on the southeastern reeds: the flanks land, his claw order follows, and the murloc war opens next door
    .turnin 698 >> Turn in Lack of Surplus
    .accept 699 >> Accept Lack of Surplus
    .target Tok'Kar

step
    .goto 1435/0,-4088.19,-10859.00
    >>Take Threat From the Sea at Tok'Kar
    .accept 1422,2,699 >> Accept Threat From the Sea
    .target Tok'Kar

step
    .goto Swamp of Sorrows,84.0,80.0
    >>Hand in Threat From the Sea; take Threat From the Sea at Katar
    .turnin -1422 >> Turn in Threat From the Sea
    .accept 1426,2,1422 >> Accept Threat From the Sea
    .target Katar

step
    .goto Swamp of Sorrows,86.0,75.0
    >>The drowned coast: 10 Marsh Murlocs, 10 Inkspewers, 10 Flesheaters for Katar; 6 Sawtooth Snapper Claws off the big crocs in the surf for Tok'Kar
    .complete -1426,1 --Marsh Murloc (10)
    .complete -1426,2 --Marsh Inkspewer (10)
    .complete -1426,3 --Marsh Flesheater (10)
    .complete 699,1 --Sawtooth Snapper Claw (6)
    .mob Marsh Murloc
    .mob Marsh Inkspewer
    .mob Marsh Flesheater
    .mob Sawtooth Snapper

step
    .goto Swamp of Sorrows,84.0,80.0
    >>Katar doubles the contract -- 10 more Inkspewers, Flesheaters, and now Oracles
    .turnin -1426 >> Turn in Threat From the Sea
    .accept 1427,2,1426 >> Accept Threat From the Sea
    .target Katar

step
    .goto Swamp of Sorrows,81.0,81.0
    >>Hand in Threat From the Sea, Lack of Surplus at Tok'Kar
    .turnin -1427 >> Turn in Threat From the Sea
    .turnin -699 >> Turn in Lack of Surplus
    .target Tok'Kar

step
    .goto Swamp of Sorrows,84.0,80.0
    >>Take Continued Threat at Katar, then Marsh Inkspewer (10), Marsh Flesheater (10), Marsh Oracle (10), then hand in Continued Threat at Katar
    .accept 1428,2,1427 >> Accept Continued Threat
    .complete 1428,1 --Marsh Inkspewer (10)
    .complete 1428,2 --Marsh Flesheater (10)
    .complete 1428,3 --Marsh Oracle (10)
    .turnin -1428 >> Turn in Continued Threat
    .target Katar

step
    .goto Swamp of Sorrows,69.0,47.0
    >>The Pool of Tears, the drowned temple's doorstep: 10 Atal'ai Artifacts lie among the sunken statuary -- murlocs and deep ones contest the shallows. If Noboru's Cudgel dropped from the lost ones, the Harborage draenei to the west pays for it (OPTIONAL, odd folk)
    .complete 1424,1 --Atal'ai Artifact (10)

step
    .goto 1435/0,-2818.83,-10100.99
    >>Hand in Noboru the Cudgel at Magtoor
    .turnin -1392 >> Turn in Noboru the Cudgel

step
    .goto Swamp of Sorrows,48.0,55.0
    >>Fel'zerul reads the idols and exiles them -- to an Atal'ai outcast in the Hinterlands, who waits in the 48-50 chapter. The bundle rides with you
    .turnin 1424 >> Turn in Pool of Tears
    .accept 1429 >> Accept The Atal'ai Exile
    .target Fel'zerul

step
    .goto Swamp of Sorrows,45.0,57.0
    >>Hand in Fresh Meat at Dar
    .turnin -1430 >> Turn in Fresh Meat
    .target Dar

step
    .goto Swamp of Sorrows,46.0,56.0
    .xp 44 >> Round off to 44 on crocs and murlocs -- the desert is next

step
    .goto Swamp of Sorrows,46.1,54.6
    >>Fly out via Grom'gol and zeppelin home; Tanaris follows
    .fly Grom'gol >> Fly to Grom'gol

step
    .goto Stranglethorn Vale,31.9,28.5
    .zone Durotar >> Zeppelin to Orgrimmar
]])

-- ===================== 44-46 TANARIS =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 44-46 Tanaris (Horde)
#next 46-48 Feralas (Horde)
<< Horde

step
    .goto Durotar,45.1,13.7
    >>Fly the long chain south to Gadgetzan (through Freewind -- the links connect)
    .fly Gadgetzan >> Fly to Gadgetzan

step
    .goto Tanaris,52.0,29.0
    >>Gadgetzan serves the Horde as gladly as anyone with coin. Bilgewhizzle's water war and Luglunket's pouch bounty open the desert
    .accept 1690 >> Accept Wastewander Justice
    .goto Tanaris,52.0,28.5
    .accept 1707 >> Accept Water Pouch Bounty
    .target Chief Engineer Bilgewhizzle
    .target Spigot Operator Luglunket

step
    .goto Tanaris,58.0,30.0
    >>The Wastewander camps east: 10 Bandits and Thieves, pouches off everything. Caliph Scorpidsting walks among them -- his head pays; dropped Ship Schedules and Andre's trail open port business
    .complete 1690,1 --Wastewander Bandit/Thief (10)
    .complete 1707,1 --Wastewander Water Pouch (5)
    .mob Wastewander Bandit
    .mob Wastewander Thief
    .unitscan Caliph Scorpidsting

step
    .goto Tanaris,52.0,29.0
    >>Round one pays, round two signs
    .turnin 1690 >> Turn in Wastewander Justice
    .accept 1691 >> Accept More Wastewander Justice
    .turnin -2781 >> Turn in WANTED: Caliph Scorpidsting
    .goto Tanaris,52.0,28.5
    .turnin 1707 >> Turn in Water Pouch Bounty
    .accept 1878 >> Accept Water Pouch Bounty
    .target Chief Engineer Bilgewhizzle
    .target Spigot Operator Luglunket

step
    .goto Tanaris,60.0,33.0
    >>Round two: 10 Shadow Mages, 8 Rogues, 6 Scofflaws, five more pouches
    .complete 1691,1 --Wastewander Shadow Mage (10)
    .complete 1691,2 --Wastewander Rogue (8)
    .complete 1691,3 --Wastewander Scofflaw (6)
    .complete 1878,1 --Wastewander Water Pouch (5)
    .mob Wastewander Shadow Mage
    .mob Wastewander Rogue
    .mob Wastewander Scofflaw

step
    .goto Tanaris,52.0,29.0
    >>Gadgetzan settles the water war -- and if the Undercity apothecaries ever sent you afield, Bilgewhizzle's testing-kit line runs here on the same pouches (guarded, optional)
    .turnin 1691 >> Turn in More Wastewander Justice
    .target Chief Engineer Bilgewhizzle

step
    .goto Tanaris,52.0,28.5
    >>Hand in Water Pouch Bounty at Spigot Operator Luglunket
    .turnin -1878 >> Turn in Water Pouch Bounty
    .target Spigot Operator Luglunket

step
    .goto Tanaris,52.0,29.0
    >>Hand in Into the Field at Chief Engineer Bilgewhizzle
    .turnin -243 >> Turn in Into the Field
    .target Chief Engineer Bilgewhizzle

step
    .goto Tanaris,52.0,29.0
    >>Take Slake That Thirst at Chief Engineer Bilgewhizzle
    .accept 379,2,243 >> Accept Slake That Thirst
    .target Chief Engineer Bilgewhizzle

step
    .goto Tanaris,52.0,29.0
    >>Finish Slake That Thirst, then hand in Slake That Thirst at Chief Engineer Bilgewhizzle
    .complete -379,1
    .turnin -379 >> Turn in Slake That Thirst
    .target Chief Engineer Bilgewhizzle

step
    .goto Tanaris,52.0,29.0
    >>Take Tanaris Field Sampling
    .accept 654,2,379 >> Accept Tanaris Field Sampling

step
    #optional
    .isOnQuest 654
    .goto Tanaris,45.0,40.0
    >>The field kit wants acceptable samples: 8 basilisks, 8 hyenas, 8 scorpions -- use it on the corpses across the open desert (bad samples happen; keep killing)
    .complete -654,1
    .complete -654,2
    .complete -654,3

step
    #optional
    .goto 1446/1,-3838.49,-7186.46
    >>Hand in Tanaris Field Sampling; take Another Power Source? at Chief Engineer Bilgewhizzle
    .turnin -654 >> Turn in Tanaris Field Sampling
    .accept 841,2,379 >> Accept Another Power Source?

step
    #optional
    .goto Tanaris,58.8,38.6
    >>Wastewander Water Pouch (10)
    .complete -841,1 --Wastewander Water Pouch (10)

step
    #optional
    .goto 1446/1,-3838.49,-7186.46
    >>Hand in Another Power Source? at Chief Engineer Bilgewhizzle
    .turnin -841 >> Turn in Another Power Source?

step
    .goto Tanaris,67.0,23.5
    >>Steamwheedle Port: Stoley settles the Booty Bay debt and sends you after his shipment; the port bounties the Southsea crews; and Yeh'kinya's screecher hunt points at Feralas -- next chapter exactly
    .turnin 2872 >> Turn in Stoley's Debt
    .accept 2873 >> Accept Stoley's Shipment
    .turnin -2876 >> Turn in Ship Schedules
    .target Stoley
    .target Security Chief Bilgewhizzle

step
    .goto Tanaris,67.0,24.0
    >>Take Southsea Shakedown; hand in WANTED: Andre Firebeard at Security Chief Bilgewhizzle
    .accept 8366 >> Accept Southsea Shakedown
    .turnin -2875 >> Turn in WANTED: Andre Firebeard
    .target Security Chief Bilgewhizzle

step
    .goto Tanaris,67.0,22.0
    >>Take Pirate Hats Ahoy! at Haughty Modiste, then take Screecher Spirits at Yeh'kinya
    .accept 8365 >> Accept Pirate Hats Ahoy!
    .accept 3520 >> Accept Screecher Spirits
    .target Haughty Modiste
    .target Yeh'kinya

step
    .goto Tanaris,72.2,46.8
    >>Lost Rigger Cove: Stoley's crate on the docks, 20 pirate hats, the Shakedown tally, Andre Firebeard somewhere among the rigging
    .complete 2873,1 --Stoley's Shipment
    .complete 8365,1 --Southsea Pirate Hat (20)
    .complete 8366,1 --Southsea kills
    .mob Southsea Pirate
    .mob Southsea Freebooter
    .mob Southsea Dock Worker
    .unitscan Andre Firebeard

step
    .goto Tanaris,67.0,23.5
    >>The port pays; Stoley's bottle keeps for a Booty Bay day
    .turnin 2873 >> Turn in Stoley's Shipment
    .target Stoley

step
    .goto Tanaris,67.0,23.5
    >>Take Deliver to MacKinley at Stoley, then hand in WANTED: Andre Firebeard at Security Chief Bilgewhizzle
    .accept 2874,2,2873 >> Accept Deliver to MacKinley
    .turnin -2875 >> Turn in WANTED: Andre Firebeard
    .target Stoley
    .target Security Chief Bilgewhizzle

step
    .goto Tanaris,67.0,24.0
    >>Hand in Southsea Shakedown at Security Chief Bilgewhizzle
    .turnin -8366 >> Turn in Southsea Shakedown
    .target Security Chief Bilgewhizzle

step
    .goto Tanaris,67.0,22.0
    >>Hand in Pirate Hats Ahoy! at Haughty Modiste
    .turnin -8365 >> Turn in Pirate Hats Ahoy!
    .target Haughty Modiste

step
    .goto Tanaris,50.0,27.0
    >>The surveyor's dowsing errand before you go: the widget at Sandsorrow's pool, then his insect chain opens -- its lair legs ripen 47+; the steps wait here, guarded, for any Gadgetzan return (the final report goes to Zilzibin in Orgrimmar)
    .accept 992 >> Accept Gadgetzan Water Survey
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,39.0,29.0
    >>Dowse the pool
    .complete -992,1 --Dowse the pool

step
    .goto Tanaris,50.0,27.0
    >>Hand in Gadgetzan Water Survey at Senior Surveyor Fizzledowser
    .turnin -992 >> Turn in Gadgetzan Water Survey
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,50.0,27.0
    >>Take Noxious Lair Investigation at Senior Surveyor Fizzledowser
    .accept 82,2,992 >> Accept Noxious Lair Investigation
    .target Senior Surveyor Fizzledowser

step
    #optional
    .isOnQuest 82
    .goto Tanaris,33.0,35.0
    >>The Noxious Lair, when you're ready for it: Centipaar parts for Pestlezugg, then the Scrimshank search in the hive tunnels, then the report ping-pong -- all guarded here
    .complete -82,1 --Centipaar Insect Parts (5)

step
    #optional
    .goto Tanaris,51.0,27.0
    >>Hand in Noxious Lair Investigation at Alchemist Pestlezugg
    .turnin -82 >> Turn in Noxious Lair Investigation

step
    #optional
    .goto Tanaris,50.0,27.0
    >>Take The Scrimshank Redemption at Senior Surveyor Fizzledowser
    .accept 10,2,82 >> Accept The Scrimshank Redemption

step
    #optional
    .goto Tanaris,56.0,71.2
    >>Scrimshank's gear
    .complete -10,1 --Scrimshank's gear

step
    #optional
    .goto Tanaris,50.0,27.0
    >>Hand in The Scrimshank Redemption at Senior Surveyor Fizzledowser
    .turnin -10 >> Turn in The Scrimshank Redemption

step
    #optional
    .goto Tanaris,50.0,27.0
    >>Take Insect Part Analysis at Senior Surveyor Fizzledowser
    .accept 110,2,10 >> Accept Insect Part Analysis

step
    #optional
    .goto Tanaris,51.0,27.0
    >>Hand in Insect Part Analysis at Alchemist Pestlezugg
    .turnin -110 >> Turn in Insect Part Analysis

step
    #optional
    .goto Tanaris,51.0,27.0
    >>Take Insect Part Analysis at Alchemist Pestlezugg
    .accept 113,2,110 >> Accept Insect Part Analysis

step
    #optional
    .goto Tanaris,50.0,27.0
    >>Hand in Insect Part Analysis at Senior Surveyor Fizzledowser
    .turnin -113 >> Turn in Insect Part Analysis

step
    #optional
    .goto Tanaris,50.0,27.0
    >>Take Rise of the Silithid at Senior Surveyor Fizzledowser
    .accept 32,2,113 >> Accept Rise of the Silithid

step
    #optional
    .goto Tanaris,52.8,27.4
    >>OPTIONAL smash: Andi Lynn in Gadgetzan pays for the Dunemaul ogre compound southwest -- 10 Ogres, 5 Brutes and Gor'marok the leader
    .accept 5863 >> Accept The Dunemaul Compound
    .target Andi Lynn

step
    #optional
    .goto Tanaris,40.3,51.3
    >>Finish The Dunemaul Compound
    .complete -5863,1
    .complete -5863,2
    .complete -5863,3
    .mob Dunemaul Ogre
    .mob Dunemaul Brute
    .unitscan Gor'marok the Ravager

step
    #optional
    .goto Tanaris,52.8,27.4
    >>Hand in The Dunemaul Compound at Andi Lynn
    .turnin -5863 >> Turn in The Dunemaul Compound

step
    .goto Tanaris,51.5,28.0
    .xp 46 >> Wastewander respawns close the gap to 46

step
    .goto Tanaris,51.0,29.3
    >>Feralas next -- and you don't have Camp Mojache's flight yet. Fly to Shadowprey Village in Desolace; the road south out of Desolace leads into Feralas. (Skip the Thousand Needles way in: it runs straight past Thalanaar's Alliance guards)
    .fly Shadowprey Village >> Fly to Shadowprey Village

step
    .goto Feralas,75.4,44.4
    >>Ride south out of Desolace and follow the Feralas road east to Camp Mojache -- grab the flight path from Shyn on arrival
    .fp Camp Mojache >> Get the Camp Mojache flight path
]])
