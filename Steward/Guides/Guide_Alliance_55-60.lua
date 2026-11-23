--  RXPGuides_ForeverWarrior - Alliance 55-60
--  Built from the Forever quest database. VERIFY IN GAME.

-- ================ 55-57 PLAGUELANDS =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 55-57 Plaguelands (Alliance)
#next 57-60 Silithus (Alliance)
<< Alliance
step
    .goto Ironforge,55.5,47.7
    >>The Eastern Kingdoms swing: fly to Ironforge, then north -- the flight chain reaches Chillwind Camp at the Plaguelands' edge (ride the last stretch from Southshore if the links fall short)

step
    #optional
    .isOnQuest 3368
    .goto 1455/0,-1309.56,-4702.67
    >>Took Suntara Stones earlier? Curator Thorius is right here -- hand it in
    .turnin -3368 >> Turn in Suntara Stones
    .target Curator Thorius

step
    .goto Western Plaguelands,43.0,84.5
    >>Chillwind Camp, the Alliance footing on the plague's edge: the Everlook Report lands with Argent Officer Pureheart, and Commander Ashlam opens the war (his call-to-arms gating varies)
    .fp Chillwind Camp >> Get the Chillwind Camp flight path
    .turnin -6028 >> Turn in The Everlook Report
    .accept 5092,2,5090 >> Accept Clear the Way
    .target Argent Officer Pureheart
    .target Commander Ashlam Valorfist

step
    .goto Western Plaguelands,43.0,84.5
    >>Skeletal Flayer (10), Slavering Ghoul (10), then hand in Clear the Way at Commander Ashlam Valorfist
    .complete -5092,1 --Skeletal Flayer (10)
    .complete -5092,2 --Slavering Ghoul (10)
    .turnin -5092 >> Turn in Clear the Way
    .target Commander Ashlam Valorfist

step
    .goto Western Plaguelands,43.0,84.5
    >>The Scourge Cauldron war: Commander Ashlam Valorfist opens it and High Priestess MacDonnell runs it field by field -- Felstone first, then Dalson's Tears. Each round: ride in, kill the Cauldron Lord, bottle the sample, ride back. The steps below cover those two; the Writhing Haunt and Gahrron's legs after them run off this route -- skip them
    .accept 5215,2,5092 >> Accept The Scourge Cauldrons
    .target Commander Ashlam Valorfist

step
    .goto Western Plaguelands,43.0,84.5
    >>Hand in The Scourge Cauldrons at High Priestess MacDonnell
    .turnin -5215 >> Turn in The Scourge Cauldrons
    .target High Priestess MacDonnell

step
    .goto Western Plaguelands,43.0,84.5
    >>Take Target: Felstone Field at High Priestess MacDonnell
    .accept 5216,2,5215 >> Accept Target: Felstone Field
    .target High Priestess MacDonnell

step
    .goto Western Plaguelands,36.0,56.0
    >>Felstone Cauldron Lord
    .complete -5216,1 --Felstone Cauldron Lord

step
    .goto 1422/0,-1185.08,1738.97
    >>Hand in Target: Felstone Field at Scourge Cauldron
    .turnin -5216 >> Turn in Target: Felstone Field

step
    .goto 1422/0,-1185.08,1738.97
    >>Take Return to Chillwind Camp at Scourge Cauldron
    .accept 5217,2,5216 >> Accept Return to Chillwind Camp

step
    .goto Western Plaguelands,43.0,84.5
    >>Hand in Return to Chillwind Camp at High Priestess MacDonnell
    .turnin -5217 >> Turn in Return to Chillwind Camp
    .target High Priestess MacDonnell

step
    .goto Western Plaguelands,43.0,84.5
    >>Take Target: Dalson's Tears at High Priestess MacDonnell
    .accept 5219,2,5217 >> Accept Target: Dalson's Tears
    .target High Priestess MacDonnell

step
    .goto Western Plaguelands,45.0,52.0
    >>Dalson's Cauldron Lord
    .complete -5219,1 --Dalson's Cauldron Lord

step
    .goto 1422/0,-1569.07,1878.87
    >>Hand in Target: Dalson's Tears at Scourge Cauldron
    .turnin -5219 >> Turn in Target: Dalson's Tears

step
    .goto 1422/0,-1569.07,1878.87
    >>Take Return to Chillwind Camp at Scourge Cauldron
    .accept 5220,2,5219 >> Accept Return to Chillwind Camp

step
    .goto Western Plaguelands,43.0,84.5
    >>Hand in Return to Chillwind Camp at High Priestess MacDonnell
    .turnin -5220 >> Turn in Return to Chillwind Camp
    .target High Priestess MacDonnell

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
    .target Carlin Redpath
    .target Duke Nicholas Zverenhoff
    .target Caretaker Alen

step
    .goto 1423/0,-5337.83,2255.75
    >>Hand in Argent Dawn Commission at Duke Nicholas Zverenhoff
    .turnin -5503 >> Turn in Argent Dawn Commission
    .target Duke Nicholas Zverenhoff

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
    .target Carlin Redpath

step
    .goto 1423/0,-5267.71,2143.67
    >>Hand in Zaeldarr the Outcast at Caretaker Alen
    .turnin -6021 >> Turn in Zaeldarr the Outcast
    .target Caretaker Alen

step
    .goto 1423,46.4,16.0
    >>North to Northpass Tower: Aurora Skycaller takes the four Highborne Relic Fragments from Winterspring (she also stands at 53,22)
    .turnin -5245 >> Turn in Troubled Spirits of Kel'Theril
    .target Aurora Skycaller

step
    .goto 1423/0,-3977.08,1971.67
    .xp 57 >> Plaguewood edges and the scar's packs to 57 -- then the desert of the old god
]])

-- ================ 57-60 SILITHUS ====================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 57-60 Silithus (Alliance)

<< Alliance
step
    .goto Tanaris,51.0,29.3,20,0
    >>Back to Kalimdor for the finale: fly to Gadgetzan, ride into Un'Goro Crater, and take the path out of its northwest corner into Silithus
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
    +LEVEL 60 -- ALLIANCE 1-60 COMPLETE. Every chapter from your first starter step to this line is one unbroken chain. Banked at the end: Umi's yeti finale (977/5163), Donova's Felwood mystery (5084+) and Videre line (3909), Tirion's redemption (5781/5845), the Argent commission grind (5503, scourgestones), Ortell's texts (8323), Kel'Theril/beast-hunt finals, and every dungeon and attunement this guide deliberately leaves to you
    +Fresh from the quest database, never play-tested past the 20s -- report any step with its number.
]])
