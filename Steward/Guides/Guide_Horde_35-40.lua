--  RXPGuides_ForeverWarrior - Horde 35-40
--  Built from the Forever quest database (no free-guide skeleton exists past 30).
--  Chunks: 36-38 Stranglethorn I / Booty Bay / Dustwallow > 38-40
--  Stranglethorn II / Stromgarde / Badlands. Farm areas marked VERIFY are
--  spawn-cluster centroids -- expect to roam.

-- ============ 36-38 STRANGLETHORN / DUSTWALLOW =======================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 36-38 Stranglethorn/Dustwallow (Horde)
#next 38-40 Stranglethorn/Badlands (Horde)
<< Horde

step
    .goto Durotar,50.8,13.8
    >>Zeppelin south to Grom'gol -- the jungle tower is the second platform
    .zone Stranglethorn Vale >> Zeppelin to Grom'gol

step
    .goto Stranglethorn Vale,32.2,28.9
    >>Grom'gol Base Camp: grab the flight, then load the board -- the commander wants raptors dead, Nimboya wants tusks, Kin'weelay bone necklaces, the Far Seer panther parts
    .fp Grom'gol >> Get the Grom'gol flight path
    .accept 568 >> Accept The Defense of Grom'gol
    .target Commander Aggro'gosh

step
    .goto Stranglethorn Vale,32.2,27.7
    >>Take Hunt for Yenniku at Nimboya
    .accept 581 >> Accept Hunt for Yenniku
    .target Nimboya

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Take Bloody Bone Necklaces, The Vile Reef at Kin'weelay
    .accept 596 >> Accept Bloody Bone Necklaces
    .accept 629,2,629 >> Accept The Vile Reef
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.1,29.2
    >>Take Mok'thardin's Enchantment at Far Seer Mok'thardin
    .accept 570 >> Accept Mok'thardin's Enchantment
    .target Far Seer Mok'thardin

step
    .goto Stranglethorn Vale,35.7,10.5
    >>North up the road: Nesingwary's Expedition camps by the river. The hunt masters each open a chain, and the old man's book pages drop off everything -- the page hunt is OPTIONAL (big payout at 40+ if you collect the chapters; auction the gaps)
    .accept 583 >> Accept Welcome to the Jungle
    .turnin 583 >> Turn in Welcome to the Jungle
    .accept 185 >> Accept Tiger Mastery
    .goto Stranglethorn Vale,35.5,10.6
    .accept 190 >> Accept Panther Mastery
    .goto Stranglethorn Vale,35.7,10.8
    .accept 194 >> Accept Raptor Mastery
    .goto Stranglethorn Vale,35.7,10.5
    .target Barnil Stonepot
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,35.7,10.8
    >>Roon's kodo horn from Desolace lands with Hemet himself -- and so does Kravel's crate from the Shimmering Flats
    .turnin 5763 >> Turn in Hunting in Stranglethorn
    .turnin 5762 >> Turn in Hemet Nesingwary Jr.
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,37.0,15.0
    >>Work the river country east of camp: young tigers and panthers for the first masteries, Lashtail Raptors for both the commander and the raptor chain
    .complete 185,1 --Young Stranglethorn Tiger (10)
    .complete 190,1 --Young Panther (10)
    .mob Young Stranglethorn Tiger
    .mob Young Panther
    .mob Lashtail Raptor

step
    .goto Stranglethorn Vale,27.3,15.6
    >>Lashtail Raptor (10)
    .complete -194,1 --Lashtail Raptor (10)
    .mob Young Stranglethorn Tiger
    .mob Young Panther
    .mob Lashtail Raptor

step
    .goto Stranglethorn Vale,37.0,15.0
    >>Lashtail Raptor (15)
    .complete -568,1 --Lashtail Raptor (15)
    .mob Young Stranglethorn Tiger
    .mob Young Panther
    .mob Lashtail Raptor

step
    .goto Stranglethorn Vale,35.6,10.6
    >>Tier two at the camp
    .turnin 185 >> Turn in Tiger Mastery
    .accept 186 >> Accept Tiger Mastery
    .goto Stranglethorn Vale,35.5,10.6
    .turnin 190 >> Turn in Panther Mastery
    .accept 191 >> Accept Panther Mastery
    .goto Stranglethorn Vale,35.7,10.8
    .turnin 194 >> Turn in Raptor Mastery
    .accept 195 >> Accept Raptor Mastery
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,23.0,11.0
    >>Northwest to the Bloodscalp war: tusks for Nimboya and necklaces off the bone-wearers for Kin'weelay -- one long smash through the villages
    .complete 581,1 --Bloodscalp Tusk (9)
    .complete 596,1 --Bloody Bone Necklace (25)
    .mob Bloodscalp Headhunter
    .mob Bloodscalp Warrior
    .mob Bloodscalp Scavenger
    .mob Bloodscalp Witch Doctor

step
    .goto Stranglethorn Vale,32.2,27.7
    >>Grom'gol pays the troll war: Nimboya opens the headhunt (it finishes next chapter), and the raptor count is likely done for the commander
    .turnin 581 >> Turn in Hunt for Yenniku
    .accept 582 >> Accept Headhunting
    .target Nimboya

step
    .goto Stranglethorn Vale,32.3,27.7
    >>Hand in Bloody Bone Necklaces at Kin'weelay
    .turnin -596 >> Turn in Bloody Bone Necklaces
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.2,28.9
    >>Hand in The Defense of Grom'gol; take The Defense of Grom'gol at Commander Aggro'gosh
    .turnin -568 >> Turn in The Defense of Grom'gol
    .accept 569,2,568 >> Accept The Defense of Grom'gol
    .target Commander Aggro'gosh

step
    #optional
    .isOnQuest 629
    .goto Stranglethorn Vale,28.5,24.0
    >>OPTIONAL dive: the Vile Reef lies straight out from camp -- a Tablet Shard waits in the sunken ruin among naga
    .complete -629,1 --Tablet Shard

step
    #optional
    .goto 1434/0,161.60,-12347.58
    >>Hand in The Vile Reef at Kin'weelay
    .turnin -629 >> Turn in The Vile Reef

step
    .goto Stranglethorn Vale,36.9,31.1
    >>The Mosh'Ogg ogres camped east of Grom'gol: the commander's count -- 10 Brutes, 5 Witchdoctors
    .complete -569,1 --Ogre Brute (10)
    .complete -569,2 --Ogre Witchdoctor (5)
    .mob Mosh'Ogg Brute
    .mob Mosh'Ogg Witch Doctor

step
    .goto Stranglethorn Vale,27.5,77.0
    >>Booty Bay, the goblin port in the cliff. Flight first, then the errand round: Krazek hears Kravel's rumors, the Sponsorship papers climb the harbor masters, and Scooty finally takes his banked gadget
    .fp Booty Bay >> Get the Booty Bay flight path

step
    .goto Stranglethorn Vale,26.9,77.2
    >>Hand in The Rumormonger at Krazek
    .turnin -1115 >> Turn in The Rumormonger
    .target Krazek

step
    .goto Stranglethorn Vale,26.4,73.6
    >>Hand in Goblin Sponsorship; take Goblin Sponsorship at Wharfmaster Lozgil
    .turnin -1180 >> Turn in Goblin Sponsorship
    .accept 1181,2,1180 >> Accept Goblin Sponsorship
    .target Wharfmaster Lozgil

step
    .goto Stranglethorn Vale,27.2,76.9
    >>Hand in Goblin Sponsorship at Baron Revilgaz, then hand in Chief Engineer Scooty at Scooty
    .turnin -1181 >> Turn in Goblin Sponsorship
    .turnin -2842 >> Turn in Chief Engineer Scooty
    .target Baron Revilgaz
    .target Scooty

step
    .goto Stranglethorn Vale,27.8,77.1
    >>"Sea Wolf" MacKinley's errand is quick silver: 5 Mistvale Giblets from the gorillas up the hill, delivered to Shaky on the dock
    .accept 606 >> Accept Scaring Shaky
    .target "Sea Wolf" MacKinley

step
    .goto Stranglethorn Vale,31.0,65.0
    >>Mistvale Gorillas in the valley north of the bay
    .complete 606,1 --Mistvale Giblets (5)
    .mob Mistvale Gorilla

step
    .goto Stranglethorn Vale,26.9,73.6
    >>Shaky takes his scare-off, MacKinley his payment
    .turnin 606 >> Turn in Scaring Shaky
    .accept 607 >> Accept Return to MacKinley
    .target "Shaky" Phillipe

step
    .goto Stranglethorn Vale,27.8,77.1
    >>Hand in Return to MacKinley at "Sea Wolf" MacKinley
    .turnin -607 >> Turn in Return to MacKinley
    .target "Sea Wolf" MacKinley

step
    .goto Stranglethorn Vale,32.2,28.0
    >>Fly back to Grom'gol -- the commander pays for his ogres before you board
    .fly Grom'gol >> Fly to Grom'gol

step
    .goto Stranglethorn Vale,32.2,28.9
    .turnin -569 >> Turn in The Defense of Grom'gol
    .target Commander Aggro'gosh

step
    .goto Stranglethorn Vale,31.9,28.5
    .zone Durotar >> Zeppelin to Orgrimmar

step
    .goto Durotar,45.1,13.7
    .fly Crossroads >> Fly to the Crossroads

step
    .goto The Barrens,61.0,41.0
    >>East through the Barrens' southern pass into the marsh -- the road bends at the Shady Rest ruin. Poke the wreckage as you pass: the burned inn starts three inquiries (a blackened shield on the flagpole, hoofprints by the porch, a badge in the ash)
    .zone Dustwallow Marsh

step
    #optional
    .goto 1445/1,-2530.57,-3735.03
    >>The Shady Rest Inn ruins: grab whatever evidence the site offers
    .accept 1251 >> Accept The Black Shield

step
    #optional
    .goto 1445/1,-2534.25,-3700.73
    >>Take Suspicious Hoofprints at Hoofprints, then take Lieutenant Paval Reethe at Theramore Guard Badge
    .accept 1268,2,1268 >> Accept Suspicious Hoofprints
    .accept 1269,2,1269 >> Accept Lieutenant Paval Reethe

step
    .goto Dustwallow Marsh,35.2,30.7
    >>North to Brackenwall Village, the ogre hold. Flight path, then the board: Nazeer's spy war and Krog's inquiry
    .fp Brackenwall >> Get the Brackenwall flight path
    .accept 1201 >> Accept Theramore Spies
    .target Nazeer Bloodpike

step
    .goto Dustwallow Marsh,36.4,31.9
    >>Hand in The Black Shield, Suspicious Hoofprints, Lieutenant Paval Reethe at Krog
    .turnin -1251 >> Turn in The Black Shield
    .turnin -1268 >> Turn in Suspicious Hoofprints
    .turnin -1269 >> Turn in Lieutenant Paval Reethe
    .target Krog

step
    .goto Dustwallow Marsh,36.4,31.9
    >>Take The Black Shield at Krog
    .accept 1321,2,1251 >> Accept The Black Shield
    .target Krog

step << Mage
    #optional
    .goto Dustwallow Marsh,46.06,57.09
    >>MAGE -- the wand chain (30+): Tabetha's farm sits mid-marsh, south of camp. Deino's referral lands here; Tabetha sends you to Magus Tirth back at the Shimmering Flats raceway
    .turnin -1947 >> Turn in Journey to the Marsh
    .target Tabetha

step << Mage
    #optional
    .goto Dustwallow Marsh,46.06,57.09
    >>Take Hidden Secrets at Tabetha
    .accept 1949,2,1947 >> Accept Hidden Secrets
    .target Tabetha

step << Mage
    #optional
    .isOnQuest 1949
    .goto Thousand Needles,78.29,75.7
    >>Magus Tirth at the raceway (fly Freewind; ~15-minute loop): his strongbox pass-phrase game earns the book
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

step << Mage
    #optional
    .goto Thousand Needles,78.29,75.7
    >>Take Rituals of Power at Magus Tirth
    .accept 1951,2,1950 >> Accept Rituals of Power
    .target Magus Tirth

step << Mage
    #optional
    .isOnQuest 1951
    .goto Dustwallow Marsh,46.06,57.09
    >>Tabetha reads the Rituals -- the MAGE'S WAND follows (her 40s chains continue from here; bank them)
    .turnin -1951 >> Turn in Rituals of Power
    .target Tabetha

step << Mage
    #optional
    .goto Dustwallow Marsh,46.06,57.09
    >>Take Mage's Wand at Tabetha
    .accept 1952,2,1951 >> Accept Mage's Wand
    .target Tabetha

step << Mage
    #optional
    .goto Dustwallow Marsh,46.06,57.09
    >>Hand in Mage's Wand at Tabetha
    .turnin -1952 >> Turn in Mage's Wand
    .target Tabetha

step
    #optional
    .isOnQuest 1321
    .goto Dustwallow Marsh,36.5,30.8
    >>Do'gol reads the shield and wants 5 Acidic Venom Sacs -- the Darkmist spiders west of camp carry them
    .turnin -1321 >> Turn in The Black Shield
    .target Do'gol

step
    #optional
    .goto Dustwallow Marsh,36.5,30.8
    >>Take The Black Shield at Do'gol
    .accept 1322,2,1321 >> Accept The Black Shield
    .target Do'gol

step
    #optional
    .isOnQuest 1269
    .goto Dustwallow Marsh,41.0,36.7
    >>Ogron by the pen walks you to Reethe himself -- an escort into the marsh; it ends badly for someone and well for your XP bar. Clear your bags of aggro first
    .accept 1273,2,1269 >> Accept Questioning Reethe
    .complete 1273,1 --Go with Ogron
    .target Ogron

step
    .goto Dustwallow Marsh,31.0,22.0
    >>Northwest spider hollows: venom sacs for Do'gol
    .complete -1322,1 --Acidic Venom Sac (5)
    .mob Darkmist Spider
    .mob Darkmist Recluse

step
    .goto Dustwallow Marsh,39.5,30.0
    >>East of camp toward the sentry ring: 9 Theramore Infiltrators skulk the treeline
    .complete 1201,1 --Theramore Infiltrator (9)
    .mob Theramore Infiltrator

step
    .goto Dustwallow Marsh,35.2,30.7
    >>Brackenwall pays: Nazeer opens the docks job, Krog and Do'gol close the shield loop -- its last leg (Mosarn in Thunder Bluff) banks for your next TB visit
    .turnin 1201 >> Turn in Theramore Spies
    .accept 1202 >> Accept The Theramore Docks
    .target Nazeer Bloodpike

step
    .goto Dustwallow Marsh,36.5,30.8
    >>Hand in The Black Shield at Do'gol
    .turnin -1322 >> Turn in The Black Shield
    .target Do'gol

step
    .goto Dustwallow Marsh,36.5,30.8
    >>Take The Black Shield at Do'gol
    .accept 1323,2,1322 >> Accept The Black Shield
    .target Do'gol

step
    .goto Dustwallow Marsh,36.4,31.9
    >>Hand in The Black Shield, Questioning Reethe at Krog
    .turnin -1323 >> Turn in The Black Shield
    .turnin -1273 >> Turn in Questioning Reethe
    .target Krog

step
    .goto Dustwallow Marsh,36.4,31.9
    >>Take The Black Shield at Krog
    .accept 1276,2,1323 >> Accept The Black Shield
    .target Krog

step
    .goto Dustwallow Marsh,71.5,51.2
    >>The Theramore docks job: swim the north inlet to the anchorage and lift the Captain's Documents -- guards patrol, hug the pilings. Watch for a washed-up Spy's Report and a Defiant Orc Head on the shoreline wreckage; both start more Nazeer work
    .complete 1202,1 --Captain's Documents

step
    .goto 1445/1,-3885.60,-2940.53
    >>Take The Lost Report, The Severed Head at Loose Dirt
    .accept 1238,2,1238 >> Accept The Lost Report
    .accept 1239,2,1238 >> Accept The Severed Head

step
    .goto Dustwallow Marsh,35.2,30.7
    >>Nazeer again: the head he sends to a troll who'll know it -- Kin'weelay in Grom'gol, which is exactly next chapter's zeppelin stop
    .turnin 1202 >> Turn in The Theramore Docks
    .turnin -1238 >> Turn in The Lost Report
    .turnin -1239 >> Turn in The Severed Head
    .target Nazeer Bloodpike

step
    .goto Dustwallow Marsh,35.2,30.7
    >>Take The Troll Witchdoctor at Nazeer Bloodpike
    .accept 1240,2,1239 >> Accept The Troll Witchdoctor
    .target Nazeer Bloodpike

step
    .goto Dustwallow Marsh,35.3,30.5
    .xp 38 >> Shy of 38? Mudcrush ogres and the marsh raptors around Brackenwall close the gap

step
    .goto Dustwallow Marsh,35.6,32.2
    >>Fly home -- round two of the jungle waits
    .fly Orgrimmar >> Fly to Orgrimmar
]])

-- ============ 38-40 STRANGLETHORN / BADLANDS =========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 38-40 Stranglethorn/Badlands (Horde)
#next 40-42 Dustwallow/Orgrimmar (Horde)
<< Horde

step
    .goto Durotar,50.8,13.8
    >>Zeppelin to Grom'gol one more time
    .zone Stranglethorn Vale >> Zeppelin to Grom'gol

step
    .isOnQuest 1240
    .goto Stranglethorn Vale,32.3,27.7
    >>Kin'weelay reads the orc head from Dustwallow
    .turnin -1240 >> Turn in The Troll Witchdoctor
    .target Kin'weelay

step
    .goto Stranglethorn Vale,32.2,27.7
    >>Nimboya's headhunt pays, and he hands you Trollbane -- bound for Hammerfall, later this chapter. The heads: 20 Shrunken Heads off any Bloodscalp
    .accept 638 >> Accept Trollbane
    .target Nimboya

step
    .goto Stranglethorn Vale,23.0,11.0
    >>Back through the Bloodscalp villages: finish the 20 Shrunken Heads, then push to the chiefs -- Gan'zulah and Nezzliok the Dire die for the cauldron
    .complete 582,1 --Shrunken Head (20)
    .mob Bloodscalp Headhunter
    .mob Bloodscalp Berserker
    .mob Bloodscalp Witch Doctor
    .unitscan Gan'zulah
    .unitscan Nezzliok the Dire

step
    .goto Stranglethorn Vale,32.2,27.7
    >>Nimboya trades the heads onward
    .turnin 582 >> Turn in Headhunting
    .target Nimboya

step
    .goto Stranglethorn Vale,32.2,27.7
    >>Take Bloodscalp Clan Heads at Nimboya
    .accept 584,2,582 >> Accept Bloodscalp Clan Heads
    .target Nimboya

step
    #optional
    .isOnQuest 584
    .goto Stranglethorn Vale,32.4,27.5
    >>Both chiefs' heads go into the bubbling cauldron behind Kin'weelay; its next demand (trophies from the three southern ruins) is 40s work off this route -- skip it
    .turnin -584 >> Turn in Bloodscalp Clan Heads

step
    .goto Stranglethorn Vale,35.0,19.0
    >>The mastery hunts, tier three: 10 Elder Stranglethorn Tigers on the north ridges, 10 Shadowmaw Panthers in the deep green south of the river, and Hemet's second raptor count among the lashtails
    .complete 186,1 --Big Stranglethorn Tiger (VERIFY tier)
    .complete 191,1 --Panther (VERIFY tier)
    .complete 195,1 --Jungle Raptor (VERIFY tier)
    .mob Elder Stranglethorn Tiger
    .mob Stranglethorn Tiger
    .mob Shadowmaw Panther
    .mob Jungle Stalker

step
    .goto Stranglethorn Vale,35.6,10.6
    >>The camp advances each hunt: Sin'Dall and Bhag'thera, the named beasts, come next -- both prowl fixed lairs (Sin'Dall the hill at the zone's heart, Bhag'thera the southern jungle). Kill what you can find; the final tiers bank at 41
    .turnin 186 >> Turn in Tiger Mastery
    .accept 187 >> Accept Tiger Mastery
    .goto Stranglethorn Vale,35.5,10.6
    .turnin 191 >> Turn in Panther Mastery
    .accept 192 >> Accept Panther Mastery
    .goto Stranglethorn Vale,35.7,10.8
    .turnin 195 >> Turn in Raptor Mastery
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin
    .target Hemet Nesingwary

step
    .goto Stranglethorn Vale,35.0,20.0
    >>Work the two hunts together where the cats overlap
    .complete 187,1 --Elder Stranglethorn Tiger (10)
    .mob Elder Stranglethorn Tiger
    .mob Shadowmaw Panther

step
    .goto Stranglethorn Vale,37.7,34.0
    >>Shadowmaw Panther (10)
    .complete -192,1 --Shadowmaw Panther (10)
    .mob Elder Stranglethorn Tiger
    .mob Shadowmaw Panther

step
    .goto Stranglethorn Vale,35.6,10.6
    >>Hand in what's done. Sin'Dall and Bhag'thera, the named-beast finales, run off this route -- skip them
    .turnin 187 >> Turn in Tiger Mastery
    .goto Stranglethorn Vale,35.5,10.6
    .turnin 192 >> Turn in Panther Mastery
    .target Ajeck Rouack
    .target Sir S. J. Erlgadin

step
    .isOnQuest 570
    .goto Stranglethorn Vale,32.1,29.2
    >>Far Seer Mok'thardin takes his panther parts (the Pristine Tigress Fang drops off any big cat); his next wants Jungle Stalker Feathers from the deep south, 40s work -- take it and bank it
    .turnin 570 >> Turn in Mok'thardin's Enchantment
    .target Far Seer Mok'thardin

step
    .goto Stranglethorn Vale,32.1,29.2
    >>Take Mok'thardin's Enchantment at Far Seer Mok'thardin
    .accept 572,2,570 >> Accept Mok'thardin's Enchantment
    .target Far Seer Mok'thardin

step << Warrior
    #optional
    .isOnQuest 1838
    .goto Stranglethorn Vale,32.1,29.2
    >>Warriors: if the Brutal Hauberk mats came together, Thun'grim's piece hands in back home -- note it for your next Barrens pass
    .turnin -1848 >> Turn in Brutal Hauberk

step
    .goto Stranglethorn Vale,31.9,28.5
    >>Zeppelin from Grom'gol straight to the Undercity -- the eastern wrap-up begins
    .zone Tirisfal Glades >> Zeppelin to the Undercity

step
    #optional
    .isOnQuest 1159
    .goto Undercity,57.8,65.4
    >>Dorn's trail, if Braug sent you on: Parqual Fintallas in the Apothecarium answers for the dead (answer honestly; ask again if you miss). Skip his Final Passage follow-up
    .turnin -1159 >> Turn in Test of Lore
    .accept 6628,2,1160 >> Accept Test of Lore
    .target Parqual Fintallas

step
    #optional
    .goto Undercity,57.8,65.4
    >>Hand in Test of Lore at Parqual Fintallas
    .turnin -6628 >> Turn in Test of Lore
    .target Parqual Fintallas

step
    .goto Undercity,63.3,48.6
    .fly Hammerfall >> Fly to Hammerfall

step
    .goto Arathi Highlands,73.8,34.0
    >>Zengu takes Trollbane's legend and wants its sigils -- all of them lie in Stromgarde's broken quarters. Drum Fel's last call and Tor'gan's raptor orb point the same direction
    .turnin 638 >> Turn in Trollbane
    .accept 639 >> Accept Sigil of Strom
    .target Zengu
    .target Gor'mul

step
    .goto Arathi Highlands,74.2,33.9
    >>Hand in Call to Arms at Drum Fel
    .turnin -679 >> Turn in Call to Arms
    .target Drum Fel

step
    .goto Arathi Highlands,74.7,36.3
    >>Take Guile of the Raptor, Foul Magics at Tor'gan
    .accept 701,2,675 >> Accept Guile of the Raptor
    .accept 673,2,671 >> Accept Foul Magics
    .target Tor'gan

step
    .goto Arathi Highlands,50.8,65.1
    >>Highland Fleshstalkers across the midlands: 12 Raptor Hearts
    .complete -701,1 --Raptor Heart (12)
    .mob Highland Fleshstalker

step
    .goto Arathi Highlands,74.7,36.3
    >>The orb passes hands again -- more free XP
    .turnin -701 >> Turn in Guile of the Raptor
    .accept 702,2,701 >> Accept Guile of the Raptor
    .target Tor'gan

step
    .goto Arathi Highlands,72.6,33.9
    >>Hand in Guile of the Raptor; take Guile of the Raptor at Gor'mul
    .turnin -702 >> Turn in Guile of the Raptor
    .accept 847,2,702 >> Accept Guile of the Raptor
    .target Gor'mul

step
    .goto Arathi Highlands,74.7,36.3
    >>Hand in Guile of the Raptor at Tor'gan
    .turnin -847 >> Turn in Guile of the Raptor
    .target Tor'gan

step
    .goto Arathi Highlands,25.0,60.0
    >>Stromgarde, the broken human keep in the southwest: fight through the contested quarters. The Sigil of Strom sits deep (639), badges drop from every defender (682), and Marez Cowl -- the ogre-mage holding a tower -- carries Tor'gan's Bloodstone Orb (673). It's a 39-40 push; bring food, pull to the streets
    .complete 639,1 --Sigil of Strom
    .complete -682,1 --Stromgarde Badge (VERIFY count)
    .complete -673,1 --Marez Cowl's Bloodstone Orb
    .mob Stromgarde Defender
    .mob Stromgarde Vindicator
    .unitscan Marez Cowl

step
    .goto Arathi Highlands,73.8,34.0
    >>Zengu stacks the sigils -- skip The Broken Sigil follow-up after it -- it runs off this route
    .turnin 639 >> Turn in Sigil of Strom
    .target Zengu
    .target Gor'mul

step
    .goto Arathi Highlands,74.7,36.3
    >>Hand in Foul Magics at Tor'gan
    .turnin -673 >> Turn in Foul Magics
    .target Tor'gan

step
    .goto Arathi Highlands,74.0,34.0
    .fly Kargath >> Fly to Kargath

step
    .goto Badlands,6.5,47.2
    >>Kargath, the Horde's desert toehold. Neeka's coyote bounty is a counting job -- take it and tally while you work the Reagent Run; Jarkal the gob-lin alchemist wants gizzards, fangs, and elemental shards from the same ground
    .accept 1419 >> Accept Coyote Thieves
    .target Neeka Bloodscar

step
    .goto Badlands,2.4,46.1
    >>Take Badlands Reagent Run at Jarkal Mossmeld
    .accept 2258 >> Accept Badlands Reagent Run
    .target Jarkal Mossmeld

step
    .goto Badlands,15.0,45.0
    >>Sweep east through the scrub: Buzzards overhead (5 Gizzards), Crag Coyotes underfoot (10 Fangs, jawbones for Neeka), and Rock Elementals among the mesas (5 Shards)
    .complete 2258,1 --Buzzard Gizzard (5)
    .complete 2258,2 --Crag Coyote Fang (10)
    .complete 2258,3 --Rock Elemental Shard (5)
    .complete -1419,1 --Coyote Jawbone (30)
    .mob Buzzard
    .mob Crag Coyote
    .mob Rock Elemental

step
    .goto Badlands,25.8,44.9
    >>The gnome camp mid-zone: Lotwil's elemental studies pay well at this level -- 3 Large Stone Slabs from the Shardtooth? no, the stone giants of the ridges; his assistant trades potions
    .accept 710 >> Accept Study of the Elements: Rock
    .target Lotwil Veriatus

step
    .goto Badlands,25.8,44.9
    >>Small stone pieces, then hand in Study of the Elements: Rock at Lotwil Veriatus
    .complete -710,1 --Small stone pieces (VERIFY tier)
    .turnin -710 >> Turn in Study of the Elements: Rock
    .target Lotwil Veriatus

step
    .goto Badlands,25.8,44.9
    >>Take Study of the Elements: Rock at Lotwil Veriatus
    .accept 711,2,710 >> Accept Study of the Elements: Rock
    .target Lotwil Veriatus

step
    .goto Badlands,25.8,44.9
    >>Large Stone Slab (3), then hand in Study of the Elements: Rock at Lotwil Veriatus
    .complete -711,1 --Large Stone Slab (3)
    .turnin -711 >> Turn in Study of the Elements: Rock
    .target Lotwil Veriatus

step
    .goto Badlands,42.2,52.7
    >>Martek the Exiled by his still takes Fizzle's letter from the racetrack -- his indurium hunt and the news run bank for the 40s
    .turnin -1106 >> Turn in Martek the Exiled
    .target Martek the Exiled

step
    .goto 1418/0,-2139.36,-6653.41
    >>Close the counts back at Kargath
    .turnin 2258 >> Turn in Badlands Reagent Run
    .target Jarkal Mossmeld

step
    .goto Badlands,6.5,47.2
    >>Hand in Coyote Thieves; take Report to Helgrum at Neeka Bloodscar
    .turnin -1419 >> Turn in Coyote Thieves
    .accept 1420,2,1418 >> Accept Report to Helgrum
    .target Neeka Bloodscar

step
    .goto Badlands,5.0,46.0
    .xp 40 >> Grind the desert to 40 if the counts fell short -- coyotes and buzzards respawn fast, and Stromgarde's streets pay better if you left sigil work unfinished

step
    +CHAPTER COMPLETE AT 40 -- the 40-42 Dustwallow/Orgrimmar chapter picks up in Orgrimmar. Riding along: Report to Helgrum (1420, Stonard), Khan Shaka (1375) and The Corrupter finale (1488) in Desolace, Speaking with Nezzliok (585) and the mastery finals (188/193/196) in Stranglethorn, The Broken Sigil line (640), Rumors for Kravel (1117) and the racetrack round two, Goblin Sponsorship blueprints (1182), The Black Shield at Thunder Bluff (1276), Stinky's thanks at Ratchet (1270), Final Passage at Dorn's cave (1394), warrior Brutal Armor pieces and the Whirlwind axe (1712), warlock felhunter legs if still open
    +This chunk is fresh from the quest database -- if a step misbehaves, note the step number and report back.
]])
