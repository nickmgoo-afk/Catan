--  RXPGuides_ForeverWarrior - Horde 55-60
--  Built from the Forever quest database. VERIFY IN GAME.

-- ================ 55-57 PLAGUELANDS =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 55-57 Plaguelands (Horde)
#next 57-60 Silithus (Horde)
<< Horde
step
    .goto Tirisfal Glades,60.6,58.7
    >>The Eastern Kingdoms swing: zeppelin to the Undercity, then ride east out the sewers -- the Bulwark holds the Plaguelands border

step
    .goto 1420/0,-725.81,1775.44
    >>The Bulwark, the Forsaken line against the plague: the Everlook Report lands with Argent Officer Garush, your warcaller crumbs (if any) with Derrington -- and the Executor opens the war by burning the Scarlet camp with their own supplies
    .turnin -6029 >> Turn in The Everlook Report
    .turnin -5093 >> Turn in A Call to Arms: The Plaguelands
    .turnin -5094 >> Turn in A Call to Arms: The Plaguelands
    .turnin -5095 >> Turn in A Call to Arms: The Plaguelands
    .target Argent Officer Garush
    .target High Executor Derrington

step
    .goto 1420/0,-725.81,1775.44
    >>Take Scarlet Diversions at High Executor Derrington
    .accept 5096,2,5095 >> Accept Scarlet Diversions
    .target High Executor Derrington

step
    .goto Western Plaguelands,36.0,53.0
    >>Burn the Scarlet camp (torch their supplies)
    .complete -5096,1 --Burn the Scarlet camp (torch their supplies -- VERIFY mechanics)

step
    .goto 1420/0,-723.10,1760.68
    >>Hand in Scarlet Diversions at High Executor Derrington
    .turnin -5096 >> Turn in Scarlet Diversions
    .target High Executor Derrington

step
    .goto 1420/0,-723.10,1760.68
    >>The Scourge Cauldron war: High Executor Derrington opens it and Shadow Priestess Vandis runs it field by field -- Felstone first, then Dalson's Tears. Each round: ride in, kill the Cauldron Lord, bottle the sample, ride back. The steps below cover those two; the Writhing Haunt and Gahrron's legs after them run off this route -- skip them
    .accept 5228,2,5096 >> Accept The Scourge Cauldrons
    .target High Executor Derrington

step
    .goto 1420/0,-719.04,1671.21
    >>Hand in The Scourge Cauldrons at Shadow Priestess Vandis
    .turnin -5228 >> Turn in The Scourge Cauldrons
    .target Shadow Priestess Vandis

step
    .goto 1420/0,-719.04,1671.21
    >>Take Target: Felstone Field at Shadow Priestess Vandis
    .accept 5229,2,5228 >> Accept Target: Felstone Field
    .target Shadow Priestess Vandis

step
    .goto Western Plaguelands,36.0,56.0
    >>Felstone Cauldron Lord
    .complete -5229,1 --Felstone Cauldron Lord

step
    .goto 1422/0,-1185.08,1738.97
    >>Hand in Target: Felstone Field at Scourge Cauldron
    .turnin -5229 >> Turn in Target: Felstone Field

step
    .goto 1422/0,-1185.08,1738.97
    >>Take Return to the Bulwark at Scourge Cauldron
    .accept 5230,2,5229 >> Accept Return to the Bulwark

step
    .goto 1420/0,-719.04,1671.21
    >>Hand in Return to the Bulwark at Shadow Priestess Vandis
    .turnin -5230 >> Turn in Return to the Bulwark
    .target Shadow Priestess Vandis

step
    .goto Western Plaguelands,54.0,65.0
    >>The open fields between cauldron rounds: Mulgris at the Writhing Haunt mourns the wildlife -- 8 Diseased Wolves
    .accept 4984 >> Accept The Wildlife Suffers Too
    .complete 4984,1 --Diseased Wolf (8)
    .turnin 4984 >> Turn in The Wildlife Suffers Too
    .target Mulgris Deepriver

step
    .goto Western Plaguelands,52.0,77.0
    .xp 56 >> Sorrow Hill's undead are dense, mindless XP between rounds -- 56 before the east

step
    .goto 1423/0,-2471.35,2659.67
    >>East into the true Plaguelands. First soul you meet: Tirion Fordring in his lonely hut by the border -- take all three of his hunts AT ONCE: 30 Plaguebats, the plaguehound packs, the carrion grubs. They overlap across the western scar and pay like a dungeon
    .accept 5542 >> Accept Demon Dogs
    .accept 5543 >> Accept Blood Tinged Skies
    .accept 5544 >> Accept Carrion Grubbage
    .target Tirion Fordring

step
    .goto 1423/0,-2901.56,2401.67
    >>The western scar: all three counts at once -- 20 Plaguehound Runts + 5 Plaguehounds + 5 Frenzied, 30 Plaguebats, and 15? Carrion Grub flesh for the spit
    .complete 5542,1
    .complete 5542,2
    .complete 5542,3
    .complete 5543,1 --Plaguebat (30)
    .complete 5544,1 --Carrion Grub flesh
    .mob Plaguehound Runt
    .mob Plaguebat
    .mob Carrion Grub

step
    .goto 1423/0,-2471.35,2659.67
    >>Tirion pays all three, then tells his story -- hear him out (skip the deeper redemption chain after it, it runs past this route)
    .turnin 5542 >> Turn in Demon Dogs
    .turnin 5543 >> Turn in Blood Tinged Skies
    .turnin 5544 >> Turn in Carrion Grubbage
    .accept 5742 >> Accept Redemption
    .complete 5742,1 --Hear Tirion's story
    .turnin 5742 >> Turn in Redemption
    .target Tirion Fordring

step
    .goto 1423/0,-3589.90,1455.67
    >>Darrowshire, the dead village south: Pamela Redpath's ghost plays alone in the ruins. Jessica's plea finds its mark; the doll she wants lies in pieces in the burned houses (three parts), and her uncle Carlin waits at Light's Hope
    .turnin 5601 >> Turn in Sister Pamela
    .accept 5149 >> Accept Pamela's Doll
    .complete 5149,1 --Pamela's Doll
    .turnin 5149 >> Turn in Pamela's Doll
    .accept 5241 >> Accept Uncle Carlin
    .target Pamela Redpath

step
    .goto 1423/0,-5353.75,2258.33
    >>Light's Hope Chapel, the Argent Dawn's last candle: Carlin takes Pamela's plea and opens Darrowshire's redemption (15 spirits freed on the village field); the Duke takes his book and sells the Dawn's commission -- carry it always, scourgestones drop everywhere here; Caretaker Alen posts Zaeldarr's head
    .turnin 5241 >> Turn in Uncle Carlin
    .accept 5211 >> Accept Defenders of Darrowshire
    .target Carlin Redpath

step
    .goto 1423/0,-5362.35,2258.33
    >>Hand in Duke Nicholas Zverenhoff; take Argent Dawn Commission at Duke Nicholas Zverenhoff
    .turnin -6030 >> Turn in Duke Nicholas Zverenhoff
    .accept 5503,2,5503 >> Accept Argent Dawn Commission
    .target Duke Nicholas Zverenhoff

step
    .goto 1423/0,-5267.71,2143.67
    >>Take Zaeldarr the Outcast at Caretaker Alen
    .accept 6021 >> Accept Zaeldarr the Outcast
    .target Caretaker Alen

step
    .goto 1423/0,-3637.00,2355.16
    >>Back across the scar: free 15 Darrowshire Spirits among the village dead, and Zaeldarr the Outcast haunts the Undercroft crypt at the far southwest -- his head pays
    .complete 5211,1 --Darrowshire Spirit (15)

step
    .goto 1423/0,-3589.90,1455.67
    >>Zaeldarr's Head
    .complete -6021,1 --Zaeldarr's Head

step
    .goto 1423/0,-5353.75,2258.33
    >>Hand in Defenders of Darrowshire at Carlin Redpath
    .turnin -5211 >> Turn in Defenders of Darrowshire

step
    .goto 1423/0,-5267.71,2143.67
    >>Hand in Zaeldarr the Outcast at Caretaker Alen
    .turnin -6021 >> Turn in Zaeldarr the Outcast
    .target Carlin Redpath
    .target Caretaker Alen

step
    .goto 1423/0,-5337.83,2255.75
    >>Hand in Argent Dawn Commission at Duke Nicholas Zverenhoff
    .turnin -5503 >> Turn in Argent Dawn Commission
    .target Duke Nicholas Zverenhoff

step
    .goto 1423/0,-3977.08,1971.67
    .xp 57 >> Plaguewood edges and the scar's packs to 57 -- then the desert of the old god
]])

-- ================ 57-60 SILITHUS ====================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 57-60 Silithus (Horde)

<< Horde
step
    .goto Tanaris,51.6,25.4,20,0
    >>Back west for the finale: fly the chain to Gadgetzan, ride into Un'Goro Crater, and take the path out of its northwest corner into Silithus
    .goto Silithus,80.0,18.0
    .zone Silithus

step
    .goto Silithus,52.0,39.0
    >>Cenarion Hold, the druids' war-fort over the hives: the full board -- venom sacs and silk for Beetix, the Dredge war for the Windcaller, Larksbane's tablet mystery (which unlocks the hermit in the south hills)
    .accept 8277 >> Accept Deadly Desert Venom
    .target Beetix Ficklespragg

step
    .goto Silithus,51.0,38.0
    >>Take Securing the Supply Lines at Windcaller Proudhorn
    .accept 8280 >> Accept Securing the Supply Lines
    .target Windcaller Proudhorn

step
    .goto Silithus,50.0,37.0
    >>Take The Twilight Mystery at Geologist Larksbane
    .accept 8284 >> Accept The Twilight Mystery
    .target Geologist Larksbane

step
    .goto Silithus,45.0,45.0
    >>The sands west and south: 8 Stonelash Scorpid venom sacs, 15 Dredge Strikers, and 8 Twilight tablet fragments off the cultist camps -- one wide rotation
    .complete 8277,1 --Stonelash venom (8)
    .complete 8280,1 --Dredge Striker (15)
    .mob Stonelash Scorpid
    .mob Dredge Striker
    .mob Twilight Geolord

step
    .goto Silithus,25.6,13.6
    >>Twilight tablet fragments (8)
    .complete -8284,1 --Twilight tablet fragments (8)
    .mob Stonelash Scorpid
    .mob Dredge Striker
    .mob Twilight Geolord

step
    .goto Silithus,52.0,39.0
    >>The hold pays and doubles everything: silk spinner sacs, 20 Dredge Crushers, and the restored tablet rides to Hermit Ortell in the southern hills -- whose Twilight decoding work (texts, lexicon chapters) is the best repeatable XP of the endgame
    .turnin 8277 >> Turn in Deadly Desert Venom
    .target Beetix Ficklespragg

step
    .goto Silithus,52.0,39.0
    >>Take Noggle's Last Hope at Beetix Ficklespragg
    .accept 8278,2,8277 >> Accept Noggle's Last Hope
    .target Beetix Ficklespragg

step
    .goto Silithus,52.0,39.0
    >>Finish Noggle's Last Hope, then hand in Noggle's Last Hope at Beetix Ficklespragg
    .complete -8278,1
    .turnin -8278 >> Turn in Noggle's Last Hope
    .target Beetix Ficklespragg

step
    .goto Silithus,52.0,39.0
    >>Take Noggle's Lost Satchel at Noggle Ficklespragg
    .accept 8282,2,8278 >> Accept Noggle's Lost Satchel
    .target Noggle Ficklespragg

step
    .goto Silithus,51.0,38.0
    >>Hand in Securing the Supply Lines at Windcaller Proudhorn
    .turnin -8280 >> Turn in Securing the Supply Lines
    .target Windcaller Proudhorn

step
    .goto Silithus,51.0,38.0
    >>Take Stepping Up Security at Windcaller Proudhorn
    .accept 8281,2,8280 >> Accept Stepping Up Security
    .target Windcaller Proudhorn

step
    .goto Silithus,51.0,38.0
    >>Dredge Crusher (20), then hand in Stepping Up Security at Windcaller Proudhorn
    .complete -8281,1 --Dredge Crusher (20)
    .turnin -8281 >> Turn in Stepping Up Security
    .target Windcaller Proudhorn

step
    .goto Silithus,50.0,37.0
    >>Hand in The Twilight Mystery; take The Deserter at Geologist Larksbane
    .turnin -8284 >> Turn in The Twilight Mystery
    .accept 8285,2,8284 >> Accept The Deserter
    .target Geologist Larksbane

step
    .goto Silithus,67.0,70.0
    >>Hermit Ortell's cave in the southern hills: the tablet lands (skip his repeatable Twilight Texts contract); Noggle's satchel lies in the same mountains
    .turnin -8285 >> Turn in The Deserter
    .target Hermit Ortell

step
    .goto Silithus,44.6,91.4
    >>Noggle's Satchel
    .complete -8282,1 --Noggle's Satchel

step
    .goto Silithus,52.0,38.0
    >>Hand in Noggle's Lost Satchel at Noggle Ficklespragg
    .turnin -8282 >> Turn in Noggle's Lost Satchel
    .target Noggle Ficklespragg

step
    #optional
    .goto Silithus,82.0,19.0
    >>OPTIONAL deep-sands work: Layo Starstrike's Southwind spirits (needs her earlier leg), and the WANTED poster for Deathclasp pays at the tower
    .accept 1125,2,1124 >> Accept The Spirits of Southwind

step
    #optional
    .goto Silithus,63.5,49.6
    >>Finish The Spirits of Southwind, then hand in The Spirits of Southwind at Layo Starstrike
    .complete -1125,1
    .complete -1125,2

step
    #optional
    .goto Silithus,82.0,19.0
    >>Hand in The Spirits of Southwind at Layo Starstrike
    .turnin -1125 >> Turn in The Spirits of Southwind

step
    #optional
    .goto 1451/1,769.71,-6740.00
    >>Hand in Wanted - Deathclasp, Terror of the Sands at Vish Kozus
    .turnin -8283 >> Turn in Wanted - Deathclasp, Terror of the Sands

step
    #optional
    .goto Blasted Lands,51.0,14.0
    >>THE OTHER GRIND, when you want a change of air: the Blasted Lands bloodmages by Nethergarde run five buff-part contracts off one valley of beasts (jowls, lungs, pincers, gizzards, brains) -- quick turn-ins, quick XP, both run from the same two elves
    .accept 2581 >> Accept Snickerfang Jowls

step
    #optional
    .goto Blasted Lands,51.0,14.0
    >>Finish Snickerfang Jowls, then hand in Snickerfang Jowls; take A Boar's Vitality at Bloodmage Drazial
    .complete -2581,1
    .complete -2581,2
    .complete -2581,3
    .turnin -2581 >> Turn in Snickerfang Jowls
    .accept 2583,2,2583 >> Accept A Boar's Vitality

step
    #optional
    .goto Blasted Lands,51.0,14.0
    >>Hand in A Boar's Vitality; take The Decisive Striker at Bloodmage Drazial
    .turnin -2583 >> Turn in A Boar's Vitality
    .accept 2585,2,2585 >> Accept The Decisive Striker

step
    #optional
    .goto Blasted Lands,51.0,14.0
    >>Hand in The Decisive Striker at Bloodmage Drazial, then take The Basilisk's Bite at Bloodmage Lynnore
    .turnin -2585 >> Turn in The Decisive Striker
    .accept 2601,2,2601 >> Accept The Basilisk's Bite

step
    #optional
    .goto Blasted Lands,51.0,14.0
    >>Hand in The Basilisk's Bite; take Vulture's Vigor at Bloodmage Lynnore
    .turnin -2601 >> Turn in The Basilisk's Bite
    .accept 2603,2,2603 >> Accept Vulture's Vigor

step
    #optional
    .goto Blasted Lands,51.0,14.0
    >>Hand in Vulture's Vigor at Bloodmage Lynnore
    .turnin -2603 >> Turn in Vulture's Vigor

step
    .goto Silithus,48.0,42.0
    .xp 60 >> THE LAST GRIND. The honest truth about 58-60: it is a grind everywhere. Your best rotations -- Silithus Twilight camps (texts for Ortell every stack), EPL's Plaguewood and Tyr's Hand (scourgestones for the Duke every 20), Winterspring's Winterfall and chimaera. Dungeon runs beat them all if you group. See you at 60

step
    +LEVEL 60 -- HORDE 1-60 COMPLETE. Every chapter from your first starter step to this line is one unbroken chain. Banked at the end: Umi's yeti finale (977/5163), Donova's Felwood mystery (5084+) and Videre line (3909), Tirion's redemption (5781/5845), the Argent commission grind (5503, scourgestones), Ortell's texts (8323), Kel'Theril/beast-hunt finals, and every dungeon and attunement this guide deliberately leaves to you
    +Fresh from the quest database, never play-tested past the 20s -- report any step with its number.
]])
