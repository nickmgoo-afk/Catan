--  RXPGuides_ForeverWarrior - Alliance 40-45
--  Built from the Forever quest database (no free-guide skeleton exists here).
--  Chunks: 40-42 Stranglethorn wrap > 42-44 Tanaris > 44-45 Hinterlands swing.
--  Farm areas marked VERIFY are spawn-cluster centroids -- expect to roam.

-- ================= 40-42 STRANGLETHORN ===============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 40-42 Stranglethorn (Alliance)
#next 42-44 Tanaris (Alliance)
<< Alliance

step
    .goto Stranglethorn Vale,36.0,11.0
    >>Level 40, mount bought, back to work: Nesingwary's camp opens the mastery finals. Take everything on offer
    .accept 187 >> Accept Tiger Mastery
    .accept 192 >> Accept Panther Mastery
    .accept 196 >> Accept Raptor Mastery
    .accept 208,2,188 >> Accept Big Game Hunter
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,34.8,18.8
    >>The hunts, north first: 10 Elder Stranglethorn Tigers on the ridges around camp
    .complete 187,1 --Elder Stranglethorn Tiger (10)
    .mob Elder Stranglethorn Tiger

step
    #optional
    .isOnQuest 705
    .goto Stranglethorn Vale,24.3,24.1
    >>Carrying Rigglefuzz's Pearl Diving? The Vile Reef lies off the coast west of here: open the Giant Clams on the sea floor for 9 Blue Pearls (Saltscale murlocs guard the reef -- mind your breath)
    .complete -705,1 --Blue Pearl (9)
    .mob Saltscale Warrior
    .mob Saltscale Forager
    .mob Saltscale Hunter

step
    .goto Stranglethorn Vale,35.5,36.0
    >>Then south into the deep green: 10 Shadowmaw Panthers and 10 Jungle Stalkers share the jungle here
    .complete 192,1 --Shadowmaw Panther (10)
    .complete 196,1 --Jungle Stalker (10)
    .mob Shadowmaw Panther
    .mob Jungle Stalker

step
    .goto Stranglethorn Vale,36.0,11.0
    >>The camp advances to the named beasts: Sin'Dall on her hill, Bhag'thera in the southern jungle, Tethis among the raptors -- each prowls a fixed lair. King Bangalash, the white tiger, circles near camp for Hemet himself
    .turnin 187 >> Turn in Tiger Mastery
    .target Ajeck Rouack

step
    .goto Stranglethorn Vale,36.0,11.0
    >>Take Tiger Mastery at Ajeck Rouack, then hand in Panther Mastery at Sir S. J. Erlgadin
    .accept 188,2,187 >> Accept Tiger Mastery
    .turnin -192 >> Turn in Panther Mastery
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin

step
    .goto Stranglethorn Vale,36.0,11.0
    >>Take Panther Mastery at Sir S. J. Erlgadin, then hand in Raptor Mastery at Hemet Nesingwary
    .accept 193,2,192 >> Accept Panther Mastery
    .turnin -196 >> Turn in Raptor Mastery
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,36.0,11.0
    >>Take Raptor Mastery at Hemet Nesingwary
    .accept 197,2,196 >> Accept Raptor Mastery
    .target Hemet Nesingwary

step
    #optional
    .goto Stranglethorn Vale,37.0,15.0
    >>Hunt the named four as you quest -- each is a solo kill at 40-41 with care
    .complete -188,1 --Paw of Sin'Dall
    .unitscan Sin'Dall
    .unitscan Bhag'thera
    .unitscan Tethis
    .unitscan King Bangalash

step
    #optional
    .goto Stranglethorn Vale,48.7,19.9
    >>Fang of Bhag'thera
    .complete -193,1 --Fang of Bhag'thera
    .unitscan Sin'Dall
    .unitscan Bhag'thera
    .unitscan Tethis
    .unitscan King Bangalash

step
    #optional
    .goto Stranglethorn Vale,31.9,42.0
    >>Tethis
    .complete -197,1 --Tethis
    .unitscan Sin'Dall
    .unitscan Bhag'thera
    .unitscan Tethis
    .unitscan King Bangalash

step
    #optional
    .goto Stranglethorn Vale,38.2,35.6
    >>Head of Bangalash
    .complete -208,1 --Head of Bangalash
    .unitscan Sin'Dall
    .unitscan Bhag'thera
    .unitscan Tethis
    .unitscan King Bangalash

step
    #optional
    .goto Stranglethorn Vale,36.0,11.0
    >>The camp pays for whichever trophies you took
    .turnin -188 >> Turn in Tiger Mastery
    .turnin -193 >> Turn in Panther Mastery
    .turnin -197 >> Turn in Raptor Mastery
    .turnin -208 >> Turn in Big Game Hunter
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,38.0,3.5
    >>The Rebel Camp wants Colonel Kurzen himself: his compound burrows into the hills east -- 6 Kurzen Elite, 4 Subchiefs, and the Colonel's head from the cave (41+ inside; pull with care)
    .accept 202,2,574 >> Accept Colonel Kurzen
    .target Lieutenant Doren
    .target Brother Nimetz

step
    .goto Stranglethorn Vale,43.0,6.0
    >>Kurzen's compound: work the camps into the cave mouth
    .complete -202,1 --Kurzen Elite (6)
    .complete -202,2 --Kurzen Subchief (4)
    .complete -202,3 --Kurzen's Head
    .mob Kurzen Elite
    .mob Kurzen Subchief
    .unitscan Colonel Kurzen

step
    .goto Stranglethorn Vale,38.0,3.5
    >>Doren pays for the head
    .turnin -202 >> Turn in Colonel Kurzen
    .target Lieutenant Doren

step
    .goto Stranglethorn Vale,31.0,34.0
    >>South toward the bay: Skullsplitter village east of the river -- Kebok's 18 tusks (your ear contract from the 30s reopened)
    >>Loot and keep 18 Skullsplitter Tusks -- Kebok pays for them in the bay (the tusks count the moment you accept his contract)
    .mob Skullsplitter Hunter
    .mob Skullsplitter Berserker
    .mob Skullsplitter Witch Doctor

step
    .goto Stranglethorn Vale,27.0,77.0
    >>Booty Bay's full board this pass: Kebok's tusks, the Bloodsail investigation, Catelyn's dagger job, Crank's second crystal order, and MacKinley's debt collection -- which points you to Tanaris, exactly where we're going
    .accept 209,2,189 >> Accept Skullsplitter Tusks
    .turnin 209 >> Turn in Skullsplitter Tusks
    .accept 600,2,605 >> Accept Venture Company Mining
    .target Kebok
    .target Crank Fizzlebub

step
    .goto Stranglethorn Vale,28.1,76.2
    >>Take The Bloodsail Buccaneers at First Mate Crazz
    .accept 595 >> Accept The Bloodsail Buccaneers
    .target First Mate Crazz

step
    .goto Stranglethorn Vale,27.4,78.0
    >>Take "Pretty Boy" Duncan at Catelyn the Blade
    .accept 610,2,603 >> Accept \"Pretty Boy\" Duncan
    .target Catelyn the Blade

step
    .goto Stranglethorn Vale,28.0,77.1
    >>Take Stoley's Debt at "Sea Wolf" MacKinley
    .accept 2872 >> Accept Stoley's Debt
    .target "Sea Wolf" MacKinley

step
    .goto 1434/0,490.24,-14453.39
    >>Take Zanzil's Secret at Crank Fizzlebub
    .accept 621 >> Accept Zanzil's Secret
    .target Crank Fizzlebub

step
    .goto Stranglethorn Vale,30.5,72.5
    >>The cove north of the bay: scout the Bloodsail landing for Crazz, and if Duncan's aboard a wreck with Catelyn's dagger, lift it
    .complete 595,1 --Check the cove
    .complete -610,1 --Catelyn's dagger

step
    .goto 1434/0,480.03,-14126.25
    >>Crazz reads your report; Seahorn turns it into a kill order -- 10 Bloodsail Swashbucklers, and Deeg wants 15 shares of Snuff off the same crews. Dizzy's eye is in their camps too
    .turnin 595 >> Turn in The Bloodsail Buccaneers
    .accept 597 >> Accept The Bloodsail Buccaneers

step
    .goto Stranglethorn Vale,28.1,76.2
    >>Hand in The Bloodsail Buccaneers at First Mate Crazz
    .turnin -597 >> Turn in The Bloodsail Buccaneers
    .target First Mate Crazz

step
    .goto 1434/0,427.70,-14411.28
    >>Take The Bloodsail Buccaneers at First Mate Crazz
    .accept 599,2,597 >> Accept The Bloodsail Buccaneers
    .target First Mate Crazz

step
    .goto Stranglethorn Vale,27.2,77.0
    >>Hand in The Bloodsail Buccaneers; take The Bloodsail Buccaneers, Sunken Treasure at Fleet Master Seahorn
    .turnin -599 >> Turn in The Bloodsail Buccaneers
    .accept 604,2,599 >> Accept The Bloodsail Buccaneers
    .accept 670,2,669 >> Accept Sunken Treasure
    .target Fleet Master Seahorn

step
    .goto Stranglethorn Vale,26.9,77.3
    >>Take Up to Snuff at Deeg
    .accept 587,2,597 >> Accept Up to Snuff
    .target Deeg

step
    .goto Stranglethorn Vale,29.0,76.0
    >>Take Keep An Eye Out at Dizzy One-Eye
    .accept 576,2,597 >> Accept Keep An Eye Out
    .target Dizzy One-Eye

step
    .goto Stranglethorn Vale,32.0,80.0
    >>The Bloodsail camps along the southern shore: swashbucklers for Seahorn, Snuff for Deeg, Dizzy's eye in their lockboxes, and Zanzil's Mixture off the Zanzil trolls just inland for Crank
    .complete -604,1 --Bloodsail Swashbuckler (10)
    .complete -587,1 --Snuff (15)
    .complete -576,1 --Dizzy's Eye
    .mob Bloodsail Swashbuckler
    .mob Bloodsail Raider
    .mob Bloodsail Sea Dog
    .mob Zanzil Hunter
    .mob Zanzil Witch Doctor

step
    .goto Stranglethorn Vale,39.4,58.5
    >>Zanzil's Mixture (12)
    .complete -621,1 --Zanzil's Mixture (12)
    .mob Bloodsail Swashbuckler
    .mob Bloodsail Raider
    .mob Bloodsail Sea Dog
    .mob Zanzil Hunter
    .mob Zanzil Witch Doctor

step
    .goto 1434/0,513.21,-14418.08
    >>Privateer Bloads wants ten Bundles of Akiris Reed -- the Naga Explorers on the coast north of the bay carry them
    .accept 617 >> Accept Akiris by the Bundle

step
    .goto Stranglethorn Vale,27.2,61.9
    >>Naga Explorers along the west coast north of Booty Bay: ten Bundles of Akiris Reed
    .complete -617,1 --Bundle of Akiris Reed (10)
    .mob Naga Explorer

step
    .goto Stranglethorn Vale,27.0,77.0
    >>Pay the bay out. Skip Seahorn's three-captains follow-up and Groy's second reed order -- both run off this route
    .turnin -604 >> Turn in The Bloodsail Buccaneers
    .turnin -587 >> Turn in Up to Snuff
    .target Fleet Master Seahorn
    .target Deeg

step
    .goto 1434/0,396.43,-14397.66
    >>Hand in Keep An Eye Out at Dizzy One-Eye
    .turnin -576 >> Turn in Keep An Eye Out
    .target Dizzy One-Eye

step
    .goto Stranglethorn Vale,27.0,77.0
    >>Hand in Zanzil's Secret, Venture Company Mining at Crank Fizzlebub
    .turnin -621 >> Turn in Zanzil's Secret
    .turnin -600 >> Turn in Venture Company Mining
    .target Crank Fizzlebub

step
    .goto Stranglethorn Vale,27.4,78.0
    >>Hand in "Pretty Boy" Duncan at Catelyn the Blade
    .turnin -610 >> Turn in \"Pretty Boy\" Duncan
    .target Catelyn the Blade

step
    .goto Stranglethorn Vale,27.4,78.0
    >>Take The Curse of the Tides at Catelyn the Blade
    .accept 611,2,610 >> Accept The Curse of the Tides
    .target Catelyn the Blade

step
    .goto 1434/0,513.21,-14418.08
    >>Hand in Akiris by the Bundle at Privateer Bloads
    .turnin -617 >> Turn in Akiris by the Bundle
    .target Privateer Bloads

step
    #optional
    .isOnQuest 611
    .goto Stranglethorn Vale,20.9,23.0
    >>Catelyn's curse job: the Altar of the Tides on the western isle -- break it with her blade, drop Gazban, bring Revilgaz the proof
    .complete -611,1

step
    #optional
    .goto Stranglethorn Vale,27.2,76.9
    >>Hand in The Curse of the Tides at Baron Revilgaz
    .turnin -611 >> Turn in The Curse of the Tides
    .target Baron Revilgaz

step
    .goto Stranglethorn Vale,30.0,50.0
    .xp 42 >> Round off to 42 on the vale's cats and trolls -- then the desert

step
    .goto Stranglethorn Vale,26.8,73.0
    >>Boat to Ratchet from the far dock
    .zone The Barrens >> Boat to Ratchet
]])

-- ==================== 42-44 TANARIS ==================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 42-44 Tanaris (Alliance)
#next 44-45 Hinterlands (Alliance)
<< Alliance

step
    .goto The Barrens,62.6,38.0,60,0
    >>From Ratchet, ride south: through the Barrens' southern gate, down the Great Lift into Thousand Needles, east across the Shimmering Flats, and through the canyon into Tanaris. A long ride -- it ends at a flight path
    .goto Thousand Needles,32.0,24.0,60,0
    .goto Thousand Needles,78.0,76.0,60

step << Mage
    #optional
    .isOnQuest 1949
    .goto Thousand Needles,78.29,75.7
    >>MAGE: Magus Tirth at the raceway, right on our road -- Tabetha's referral finally lands. His strongbox pass-phrase game earns her book. Tabetha's Rituals of Power leg after it lives at her Dustwallow farm, off this route -- skip it
    .turnin -1949 >> Turn in Hidden Secrets
    .target Magus Tirth

step << Mage
    #optional
    .goto Thousand Needles,78.29,75.7
    >>Take Get the Scoop at Magus Tirth
    .accept 1950,2,1949 >> Accept Get the Scoop
    .target Magus Tirth

step << Mage
    #optional
    .goto Thousand Needles,78.29,75.7
    >>Tirth's strongbox phrase, then hand in Get the Scoop at Magus Tirth
    .complete -1950,1 --Tirth's strongbox phrase
    .turnin -1950 >> Turn in Get the Scoop
    .target Magus Tirth

step
    .goto Tanaris,52.0,28.0
    >>Gadgetzan: flight path first, then the water war -- Bilgewhizzle's bandit purge and Luglunket's pouch bounty come off the same corpses
    .fp Gadgetzan >> Get the Gadgetzan flight path

step
    .goto Tanaris,52.0,29.0
    >>Take Wastewander Justice at Chief Engineer Bilgewhizzle
    .accept 1690 >> Accept Wastewander Justice
    .target Chief Engineer Bilgewhizzle

step
    .goto Tanaris,52.0,28.5
    >>Take Water Pouch Bounty at Spigot Operator Luglunket
    .accept 1707 >> Accept Water Pouch Bounty
    .target Spigot Operator Luglunket

step
    .goto Tanaris,58.0,30.0
    >>The Wastewander camps east: 10 Bandits and Thieves, water pouches off everything. Watch for Caliph Scorpidsting among them -- his head pays, and dropped Ship Schedules and Andre's trail start port business
    .complete 1690,1 --Wastewander Bandit/Thief (10)
    .complete 1707,1 --Wastewander Water Pouch (5)
    .mob Wastewander Bandit
    .mob Wastewander Thief
    .unitscan Caliph Scorpidsting

step
    .goto Tanaris,52.0,29.0
    >>Gadgetzan pays round one and doubles the contract
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
    >>Round two in the camps: 10 Shadow Mages, 8 Rogues, 6 Scofflaws, five more pouches
    .complete 1691,1 --Wastewander Shadow Mage (10)
    .complete 1691,2 --Wastewander Rogue (8)
    .complete 1691,3 --Wastewander Scofflaw (6)
    .complete 1878,1 --Wastewander Water Pouch (5)
    .mob Wastewander Shadow Mage
    .mob Wastewander Rogue
    .mob Wastewander Scofflaw

step
    .goto Tanaris,52.0,29.0
    >>Gadgetzan settles the water war
    .turnin 1691 >> Turn in More Wastewander Justice
    .goto Tanaris,52.0,28.5
    .turnin 1878 >> Turn in Water Pouch Bounty
    .target Chief Engineer Bilgewhizzle
    .target Spigot Operator Luglunket

step
    .goto Tanaris,67.0,23.5
    >>Steamwheedle Port on the coast: Stoley settles MacKinley's debt and sends you after his shipment; the dressmaker and the security chief bounty the Southsea crews; Yeh'kinya's screecher hunt points to Feralas -- take it, that's two chapters out
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
    >>Lost Rigger Cove, the pirate harbor southeast: Stoley's shipment crate on the docks, 20 hats and the Shakedown tally off the crews, Andre Firebeard among them
    .complete 2873,1 --Stoley's Shipment
    .complete 8365,1 --Southsea Pirate Hat (20)
    .complete 8366,1 --Southsea kills
    .mob Southsea Pirate
    .mob Southsea Freebooter
    .mob Southsea Dock Worker
    .unitscan Andre Firebeard

step
    .goto Tanaris,67.0,23.5
    >>The port pays out. Skip Stoley's bottle run back to Booty Bay -- it's off this route
    .turnin 2873 >> Turn in Stoley's Shipment
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
    >>Back through Gadgetzan: the surveyor's dowsing errand runs to Sandsorrow Watch -- use the widget at the pool, then report. His chain matures through the 40s; take what he offers
    .accept 992 >> Accept Gadgetzan Water Survey
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,39.0,29.0
    >>Sandsorrow Watch west: the untapped pool, trolls around it
    .complete 992,1 --Dowse the pool

step
    .goto Tanaris,50.0,27.0
    >>Fizzledowser reads the water and opens the insect question -- the Noxious Lair (47) banks for our return pass
    .turnin 992 >> Turn in Gadgetzan Water Survey
    .target Senior Surveyor Fizzledowser

step
    .goto Tanaris,50.0,27.0
    >>Take Noxious Lair Investigation at Senior Surveyor Fizzledowser
    .accept 82,2,992 >> Accept Noxious Lair Investigation
    .target Senior Surveyor Fizzledowser

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
    .xp 44 >> Short of 44? Wastewander respawns and the Dunemaul pay fine -- round off at Gadgetzan

step
    .goto Tanaris,51.0,29.3
    >>Fly north -- the Hinterlands swing crosses the sea
    .fly Theramore >> Fly to Theramore
]])

-- ================= 44-45 HINTERLANDS =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 44-45 Hinterlands (Alliance)
#next 45-47 Feralas (Alliance)
<< Alliance

step
    .goto Dustwallow Marsh,66.4,45.0
    >>Theramore dock: boat to Menethil Harbor
    .zone Wetlands >> Boat to Menethil

step
    .goto Wetlands,10.7,60.0
    .fly Ironforge >> Fly to Ironforge

step
    .goto 1455/0,-1288.61,-5065.24
    >>Ironforge errands while we're here: the Black Box you've hauled since the Badlands lands in the Hall of Arms area; warriors settle armor business
    .turnin -708 >> Turn in The Black Box

step
    .goto Ironforge,55.5,47.7
    >>Deeprun Tram to Stormwind: Brohann Caskbelly in the Dwarven District dreams of a lost temple -- his chain IS the Hinterlands trip
    .zone Stormwind City >> Take the Deeprun Tram to Stormwind

step
    .goto 1453/0,524.04,-8459.17
    >>Brohann Caskbelly in the Dwarven District
    .accept 1448 >> Accept In Search of The Temple
    .turnin 1448 >> Turn in In Search of The Temple
    .accept 1449 >> Accept To The Hinterlands
    .target Brohann Caskbelly

step
    .isOnQuest 335
    .goto 1453/0,1025.49,-8984.01
    >>Old debts while in the city: the Noble Brew you've carried pours out here
    .turnin -335 >> Turn in A Noble Brew

step
    .goto 1453/0,1025.49,-8984.01
    >>Take A Noble Brew at Zardeth of the Black Claw
    .accept 336,2,335 >> Accept A Noble Brew

step
    .goto 1453/0,369.75,-8562.84
    >>Hand in A Noble Brew at Lord Baurles K. Wishock
    .turnin -336 >> Turn in A Noble Brew

step << Warrior
    #optional
    .isQuestComplete 1701
    .goto 1453/0,600.14,-8427.08
    >>WARRIOR: Furen takes the finished Fire Hardened Mail. His race follow-ups (Grimand, Klockmort, Mathiel) are level-28 errands off this route -- skip them
    .turnin -1701 >> Turn in Fire Hardened Mail
    .target Furen Longbeard

step
    .goto 1453/0,506.67,-8829.83,15,0
    >>Fly to Menethil from the Stormwind flight master, then ride east: through Dun Algaz, across the Thandol Span into Arathi
    .goto Wetlands,49.0,57.0,60,0
    .goto Arathi Highlands,45.8,46.1
    .fp Refuge Pointe >> Get the Refuge Pointe flight path

step
    #optional
    .isOnQuest 670
    .goto 1417/0,-2028.75,-2086.45
    >>Carrying Seahorn's letter? Shakes O'Breen runs Faldir's Cove below the western cliffs -- the drop pays and his ship jobs are decent XP
    .turnin -670 >> Turn in Sunken Treasure
    .target Shakes O'Breen

step
    .goto Arathi Highlands,24.4,18.4,60,0
    >>Northwest through the highlands, along the Hillsbrad border into the Hinterlands' western gate, then up to Aerie Peak
    .goto The Hinterlands,11.0,46.0
    .fp Aerie Peak >> Get the Aerie Peak flight path

step
    .goto The Hinterlands,12.0,47.0
    >>The Wildhammer board: Brohann's trail runs through Falstad to the Gryphon Master; Fraggar's troll bounty opens; the aviary adds cages
    .turnin 1449 >> Turn in To The Hinterlands
    .accept 1450 >> Accept Gryphon Master Talonaxe
    .target Falstad Wildhammer

step
    .goto The Hinterlands,10.0,44.0
    >>Hand in Gryphon Master Talonaxe; take Rhapsody Shindigger, Witherbark Cages at Gryphon Master Talonaxe
    .turnin -1450 >> Turn in Gryphon Master Talonaxe
    .accept 1451,2,1450 >> Accept Rhapsody Shindigger
    .accept 2988 >> Accept Witherbark Cages
    .target Gryphon Master Talonaxe

step
    .goto The Hinterlands,15.0,45.0
    >>Take Troll Necklace Bounty at Fraggar Thundermantle
    .accept 2880 >> Accept Troll Necklace Bounty
    .target Fraggar Thundermantle

step
    .goto The Hinterlands,22.0,56.0
    >>Witherbark country south: 5 Troll Tribal Necklaces off anything green, and check the cages at both villages
    .complete 2880,1 --Troll Tribal Necklace (5)
    .complete 2988,1 --Check the cages
    .complete 2988,2 --Check the cages
    .mob Witherbark Troll
    .mob Witherbark Shadowcaster
    .mob Witherbark Axe Thrower

step
    .goto The Hinterlands,27.0,49.0
    >>Rhapsody Shindigger drinks in the hills east: hand him the referral. His Kalimdor Kocktail list is cross-continent shopping -- skip it
    .turnin -1451 >> Turn in Rhapsody Shindigger
    .target Rhapsody Shindigger

step
    .goto The Hinterlands,15.0,45.0
    >>Fraggar doubles the bounty -- five more necklaces; finish on Vilebranch toward the east if the west runs dry
    .turnin 2880 >> Turn in Troll Necklace Bounty
    .accept 2881 >> Accept Troll Necklace Bounty
    .complete 2881,1 --Troll Tribal Necklace (5)
    .target Fraggar Thundermantle

step
    .goto The Hinterlands,15.0,45.0
    >>Hand in Troll Necklace Bounty at Fraggar Thundermantle
    .turnin -2881 >> Turn in Troll Necklace Bounty
    .target Fraggar Thundermantle

step
    .goto The Hinterlands,10.0,44.0
    >>Hand in Witherbark Cages at Gryphon Master Talonaxe
    .turnin -2988 >> Turn in Witherbark Cages
    .target Gryphon Master Talonaxe

step
    .goto The Hinterlands,10.0,44.0
    >>Take The Altar of Zul at Gryphon Master Talonaxe
    .accept 2989,2,2988 >> Accept The Altar of Zul
    .target Gryphon Master Talonaxe

step
    .goto The Hinterlands,14.0,44.0
    .xp 45 >> Trolls and wolves to 45 -- the Altar of Zul (48) banks if you took it

step
    #optional
    .isQuestComplete 2989
    .goto 1416/0,-1950.38,325.27
    >>Took The Altar of Zul earlier? Gryphon Master Talonaxe is right here -- hand it in
    .turnin -2989 >> Turn in The Altar of Zul
    .target Gryphon Master Talonaxe

step
    .goto The Hinterlands,11.0,46.0
    >>Fly south -- Feralas by way of Menethil and Theramore
    .fly Menethil >> Fly to Menethil Harbor

step
    .goto Wetlands,8.5,56.5
    .zone Dustwallow Marsh >> Boat to Theramore
]])
