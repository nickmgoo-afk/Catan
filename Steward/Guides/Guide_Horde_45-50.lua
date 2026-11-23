--  RXPGuides_ForeverWarrior - Horde 45-50
--  Built from the Forever quest database (no free-guide skeleton exists here).
--  Chunks: 46-48 Feralas > 48-50 Hinterlands/Searing Gorge.
--  Farm areas marked VERIFY are spawn-cluster centroids.

-- ===================== 46-48 FERALAS =================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 46-48 Feralas (Horde)
#next 48-50 Hinterlands/Searing Gorge (Horde)
<< Horde

step
    .goto Feralas,75.0,42.0
    >>Camp Mojache, the tauren war-camp: load the whole board. Hadoken runs the gnoll war, Rok the ogre war, Krueg the cloak trade, Jangdor the hides, Orwin the ore, the Witch Doctor his strange trophies
    .accept 2862 >> Accept War on the Woodpaw
    .target Hadoken Swiftstrider

step
    .goto Feralas,76.0,44.0
    >>Take The Ogres of Feralas at Rok Orhan
    .accept 2975 >> Accept The Ogres of Feralas
    .target Rok Orhan

step
    .goto Feralas,76.0,43.0
    >>Take A New Cloak's Sheen, A Grim Discovery at Krueg Skullsplitter
    .accept 2973 >> Accept A New Cloak's Sheen
    .accept 2974,2,2973 >> Accept A Grim Discovery
    .target Krueg Skullsplitter

step
    .goto Feralas,74.0,43.0
    >>Take The Mark of Quality at Jangdor Swiftstrider, then take A Strange Request at Witch Doctor Uzer'i
    .accept 2822 >> Accept The Mark of Quality
    .accept 3121 >> Accept A Strange Request
    .target Jangdor Swiftstrider
    .target Witch Doctor Uzer'i

step
    .goto Feralas,76.0,44.0
    >>Take Gordunni Cobalt at Orwin Gizzmick
    .accept 2987 >> Accept Gordunni Cobalt
    .target Orwin Gizzmick

step
    .goto Feralas,73.0,48.0
    >>The Woodpaw camps south: 10 Gnoll Manes, and their battle plans lie in one of the camps. Grimtotem Horns for Krueg come from the Grimtotem compound just west -- 20 of them
    .complete 2862,1 --Woodpaw Gnoll Mane (10)
    .complete -2974,1 --Grimtotem Horn (20)
    .mob Woodpaw Mystic
    .mob Woodpaw Reaver
    .mob Grimtotem Naturalist
    .mob Grimtotem Raider

step
    .goto Feralas,75.0,42.0
    >>Hadoken pays the manes and starts the clock: 5 Woodpaw Alphas inside ONE HOUR -- they prowl the same camps, so clear fast and come straight back. Then the found plans open the Zukk'ash front
    .turnin 2862 >> Turn in War on the Woodpaw
    .accept 2863 >> Accept Alpha Strike
    .target Hadoken Swiftstrider

step
    .goto Feralas,74.4,55.9
    >>Woodpaw Alpha (5), 1-hour timer
    .complete -2863,1 --Woodpaw Alpha (5), 1-hour timer

step
    .goto Feralas,75.0,42.0
    >>Hand in Alpha Strike; take Woodpaw Investigation at Hadoken Swiftstrider, then Find the battle plans
    .turnin -2863 >> Turn in Alpha Strike
    .accept 2902,2,2863 >> Accept Woodpaw Investigation
    .complete 2902,1 --Find the battle plans
    .target Hadoken Swiftstrider

step
    .goto 1444/1,463.38,-4957.63
    >>Hand in Woodpaw Investigation at Woodpaw Battle Map
    .turnin -2902 >> Turn in Woodpaw Investigation

step
    .goto 1444/1,463.38,-4957.63
    >>Take The Battle Plans at Woodpaw Battle Map
    .accept 2903,2,2902 >> Accept The Battle Plans

step
    .goto Feralas,75.0,42.0
    >>Hand in The Battle Plans; take Zukk'ash Infestation, Stinglasher at Hadoken Swiftstrider
    .turnin -2903 >> Turn in The Battle Plans
    .accept 7730,2,2903 >> Accept Zukk'ash Infestation
    .accept 7731,2,2903 >> Accept Stinglasher
    .target Hadoken Swiftstrider

step
    .goto Feralas,76.0,43.0
    >>Krueg takes the horns -- the crate rides to Belgrom in Orgrimmar (bank it). His cloak wants 10 Iridescent Sprite Darter Wings: the little dragons flit around the eastern vale (yes, you have to)
    .turnin -2974 >> Turn in A Grim Discovery
    .target Krueg Skullsplitter

step
    .goto Feralas,76.0,43.0
    >>Take A Grim Discovery at Krueg Skullsplitter
    .accept 2976,2,2974 >> Accept A Grim Discovery
    .target Krueg Skullsplitter

step
    .goto Feralas,71.0,51.0
    >>East vale sweep: sprite darters for the wings, and the Writhing Deep's Zukk'ash just south -- 20 Carapaces and Stinglasher itself among the hive mounds
    .complete 2973,1 --Iridescent Sprite Darter Wing (10)
    .mob Sprite Darter
    .mob Zukk'ash Stinger
    .mob Zukk'ash Wasp
    .unitscan Stinglasher

step
    .goto Feralas,75.1,61.3
    >>Zukk'ash Carapace (20), Stinglasher's glands
    .complete -7730,1 --Zukk'ash Carapace (20)
    .complete -7731,1 --Stinglasher's glands
    .mob Sprite Darter
    .mob Zukk'ash Stinger
    .mob Zukk'ash Wasp
    .unitscan Stinglasher

step
    .goto Feralas,62.0,46.0
    >>The Gordunni hold the whole wild heart of Feralas: Rok's two tallies run together (10 Ogres, 10 Ogre-Magi, 5 Brutes; then 10 Shaman, 10 Warlocks, 5 Maulers), Orwin's 12 Gordunni Cobalt chunks come off the same camps, and watch for a Gordunni Scroll drop -- it opens the orb hunt
    .complete 2975,1 --Gordunni Ogre (10)
    .complete 2975,2 --Gordunni Ogre-Mage (10)
    .complete 2975,3 --Gordunni Brute (5)
    .mob Gordunni Ogre
    .mob Gordunni Ogre Mage
    .mob Gordunni Brute

step
    .goto Feralas,76.0,33.4
    >>Gordunni Cobalt (12)
    .complete -2987,1 --Gordunni Cobalt (12)
    .mob Gordunni Ogre
    .mob Gordunni Ogre Mage
    .mob Gordunni Brute

step
    .goto Feralas,76.0,44.0
    >>Rok pays round one, signs round two; the scroll (if it dropped) turns here too
    .turnin 2975 >> Turn in The Ogres of Feralas
    .accept 2980 >> Accept The Ogres of Feralas
    .turnin -2978 >> Turn in The Gordunni Scroll
    .target Rok Orhan

step
    .goto Feralas,76.0,44.0
    >>Take Dark Ceremony at Rok Orhan
    .accept 2979,2,2978 >> Accept Dark Ceremony
    .target Rok Orhan

step
    .goto Feralas,76.0,44.2
    >>Hand in Gordunni Cobalt at Orwin Gizzmick
    .turnin -2987 >> Turn in Gordunni Cobalt
    .target Orwin Gizzmick

step
    .goto Feralas,60.0,50.0
    >>Round two in the ogre camps -- casters this time; and if Dark Ceremony is open, a Gordunni Orb hides with their ritualists
    .complete 2980,1 --Gordunni Shaman (10)
    .complete 2980,2 --Gordunni Warlock (10)
    .complete 2980,3 --Gordunni Mauler (5)
    .mob Gordunni Shaman
    .mob Gordunni Warlock
    .mob Gordunni Mauler

step
    .goto Feralas,60.2,68.4
    >>Gordunni Orb
    .complete -2979,1 --Gordunni Orb
    .mob Gordunni Shaman
    .mob Gordunni Warlock
    .mob Gordunni Mauler

step
    .goto Feralas,54.0,57.5
    >>Feral Scar Vale, the yeti valley in central Feralas: 10 Thick Yeti Hides for Jangdor
    .complete 2822,1 --Thick Yeti Hide (10)
    .mob Feral Scar Yeti
    .mob Enraged Feral Scar
    .mob Hulking Feral Scar

step
    .goto Feralas,43.0,36.5
    >>Vale Screechers for Yeh'kinya: kill them, then use his bramble on the corpses to free 3 Screecher Spirits
    .complete 3520,1 --Screecher Spirits (3)
    .mob Vale Screecher
    .mob Rogue Vale Screecher

step
    .goto Feralas,76.0,44.0
    >>Mojache settles up: Rok pays the casters, the orb (if found) rides to Uthel'nay in Orgrimmar, Jangdor takes the hides and offers the Rage Scar follow-up for your 48s -- bank what points to the city
    .turnin 2980 >> Turn in The Ogres of Feralas
    .turnin -2979 >> Turn in Dark Ceremony
    .target Rok Orhan

step
    .goto Feralas,76.0,44.0
    >>Take The Gordunni Orb at Rok Orhan
    .accept 3002,2,2979 >> Accept The Gordunni Orb
    .target Rok Orhan

step
    .goto Feralas,76.0,43.0
    >>Hand in A New Cloak's Sheen at Krueg Skullsplitter
    .turnin -2973 >> Turn in A New Cloak's Sheen
    .target Krueg Skullsplitter

step
    .goto Feralas,75.0,42.0
    >>Hand in Zukk'ash Infestation, Stinglasher at Hadoken Swiftstrider
    .turnin -7730 >> Turn in Zukk'ash Infestation
    .turnin -7731 >> Turn in Stinglasher
    .target Hadoken Swiftstrider

step
    .goto Feralas,75.0,42.0
    >>Take Zukk'ash Report at Hadoken Swiftstrider
    .accept 7732,2,7731 >> Accept Zukk'ash Report
    .target Hadoken Swiftstrider

step
    .goto Feralas,74.0,43.0
    >>Hand in The Mark of Quality at Jangdor Swiftstrider
    .turnin -2822 >> Turn in The Mark of Quality
    .target Jangdor Swiftstrider

step
    .goto Feralas,74.0,43.0
    >>Take Improved Quality at Jangdor Swiftstrider
    .accept 7734,2,2822 >> Accept Improved Quality
    .target Jangdor Swiftstrider

step
    #optional
    .isOnQuest 7734
    .goto Feralas,52.7,31.1
    >>Rage Scar Yetis in the deeper caves drop the better hides -- ten, plus a Pristine one starts its own thanks if it falls
    .complete -7734,1 --Rage Scar Yeti Hide (10)
    .mob Rage Scar Yeti

step
    #optional
    .goto Feralas,74.0,43.0
    >>Hand in Improved Quality, Perfect Yeti Hide at Jangdor Swiftstrider
    .turnin -7734 >> Turn in Improved Quality
    .turnin -7738 >> Turn in Perfect Yeti Hide
    .target Jangdor Swiftstrider

step
    .goto Feralas,75.5,43.5
    .xp 48 >> Gordunni and yetis to 48 -- Talo's harpy vengeance (50) and the muisek trophies bank for the 50s

step
    .goto Feralas,75.3,44.3
    >>Fly home to Orgrimmar: city payouts, then east one last time
    .fly Orgrimmar >> Fly to Orgrimmar

step
    .goto Orgrimmar,75.0,34.0
    >>Orgrimmar debts: Belgrom takes the horn crate in the Valley of Honor; Uthel'nay reads the orb in the Darkbriar Lodge; Zilzibin hears the Zukk'ash report in the Drag; Neeru trades Uzer'i's shrunken head for a herb pouch -- carry it back someday (it banks)
    .turnin -2976 >> Turn in A Grim Discovery
    .target Belgrom Rockmaul

step
    .goto Orgrimmar,39.0,86.0
    >>Hand in The Gordunni Orb at Uthel'nay
    .turnin -3002 >> Turn in The Gordunni Orb
    .target Uthel'nay

step
    .goto Orgrimmar,56.0,47.0
    >>Hand in Zukk'ash Report, Rise of the Silithid at Zilzibin Drumlore
    .turnin -7732 >> Turn in Zukk'ash Report
    .turnin -32 >> Turn in Rise of the Silithid
    .target Zilzibin Drumlore

step
    .goto Orgrimmar,49.0,51.0
    >>Hand in A Strange Request at Neeru Fireblade
    .turnin -3121 >> Turn in A Strange Request
    .target Neeru Fireblade

step
    .goto Durotar,50.8,13.8
    >>Zeppelin east -- the trolls of the Hinterlands owe the Horde a village's worth of blood
    .zone Tirisfal Glades >> Zeppelin to the Undercity
]])

-- ============ 48-50 HINTERLANDS / SEARING GORGE ======================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 48-50 Hinterlands/Searing Gorge (Horde)
#next 50-53 Un'Goro Crater (Horde)
<< Horde

step
    .goto Tirisfal Glades,61.0,59.0,30,0
    .goto Undercity,63.3,48.6
    .fly Tarren Mill >> Fly to Tarren Mill

step
    .goto Hillsbrad Foothills,65.0,18.0,60,0
    >>Ride east through the pass into the Hinterlands, then cut southeast across the basin -- Revantusk Village sits on the far coast. The whole zone is 45-51 and dense; this is the richest grind of the decade
    .goto The Hinterlands,32.0,58.0,60,0
    .goto The Hinterlands,81.7,81.8
    .fp Revantusk Village >> Get the Revantusk Village flight path

step
    .goto The Hinterlands,79.0,79.0
    >>The Revantusk board -- take everything: Markhor's hunts, Otho's war on the Wildhammer elves, Yayo'jin's cannibal purge, Slagtree's tools, Lard's lunch, Katoom's turtles, and Primal Torntusk's grief
    .accept 7828 >> Accept Stalking the Stalkers
    .accept 7829 >> Accept Hunt the Savages
    .accept 7830 >> Accept Avenging the Fallen
    .target Huntsman Markhor

step
    .goto The Hinterlands,79.0,79.2
    >>Take Message to the Wildhammer at Otho Moji'ko
    .accept 7841 >> Accept Message to the Wildhammer
    .target Otho Moji'ko

step
    .goto The Hinterlands,79.0,78.0
    >>Take Cannibalistic Cousins at Mystic Yayo'jin
    .accept 7844 >> Accept Cannibalistic Cousins
    .target Mystic Yayo'jin

step
    .goto The Hinterlands,77.0,80.0
    >>Take Vilebranch Hooligans at Smith Slagtree
    .accept 7839 >> Accept Vilebranch Hooligans
    .target Smith Slagtree

step
    .goto The Hinterlands,78.0,81.0
    >>Take Lard Lost His Lunch at Lard, then take Dark Vessels, Kidnapped Elder Torntusk! at Primal Torntusk
    .accept 7840 >> Accept Lard Lost His Lunch
    .accept 7850 >> Accept Dark Vessels
    .accept 7845 >> Accept Kidnapped Elder Torntusk!
    .target Lard
    .target Primal Torntusk

step
    .goto The Hinterlands,80.0,82.0
    >>Take Snapjaws, Mon! at Katoom the Angler
    .accept 7815 >> Accept Snapjaws, Mon!
    .target Katoom the Angler

step
    .goto The Hinterlands,81.0,77.0
    >>The coast first: 15 Saltwater Snapjaws along the surf, and Gammerita the great turtle plods the shore with Katoom's gear in her gut
    .complete 7815,1 --Saltwater Snapjaw (15)
    .mob Saltwater Snapjaw
    .unitscan Gammerita

step
    .goto The Hinterlands,80.0,82.0
    >>Hand in Snapjaws, Mon!; take Gammerita, Mon! at Katoom the Angler, then Gammerita, then hand in Gammerita, Mon! at Katoom the Angler
    .turnin -7815 >> Turn in Snapjaws, Mon!
    .accept 7816 >> Accept Gammerita, Mon!
    .target Katoom the Angler

step
    .goto The Hinterlands,75.7,65.8
    >>Gammerita
    .complete -7816,1 --Gammerita
    .mob Saltwater Snapjaw
    .unitscan Gammerita

step
    .goto The Hinterlands,80.0,82.0
    >>Hand in Gammerita, Mon! at Katoom the Angler
    .turnin -7816 >> Turn in Gammerita, Mon!
    .target Katoom the Angler

step
    .goto The Hinterlands,65.0,65.0
    >>The basin sweep: Silvermane Stalkers and Howlers (10 each), 20 Savage Owlbeasts, and the Razorbeak Skylord circling the high ridge -- Markhor's whole slate in one wide loop. Keep an Undamaged Venom Sac if a serpent drops one (Tarren Mill pays on the way home)
    .complete 7828,1 --Silvermane Stalker (10)
    .complete 7828,2 --Silvermane Howler (10)
    .complete 7829,1 --Savage Owlbeast (20)
    .complete 7830,1 --Razorbeak Skylord
    .mob Silvermane Stalker
    .mob Silvermane Howler
    .mob Savage Owlbeast
    .unitscan Razorbeak Skylord

step
    .goto The Hinterlands,34.0,75.0
    >>Southwest ridge: the Atal'ai Exile squats above the valley -- Fel'zerul's bundle lands (skip his reply to Stonard: it only leads into the Sunken Temple, and the route doesn't go back)
    .turnin 1429 >> Turn in The Atal'ai Exile
    .target Atal'ai Exile

step
    .goto The Hinterlands,31.0,58.0
    >>The Witherbark villages in the southwest hold Nimboya's errand: their skulls load the pike, and the laden pike plants at their village heart -- the deed reports back to Grom'gol someday
    .complete 2932,1 --Witherbark Skulls / plant the pike

step
    .goto The Hinterlands,32.5,48.9
    >>Quel'Danil Lodge, the elves Otho wants bled: 15 Outrunners, 15 Scouts, 10 Markers? -- his count, plus 10 Long Elegant Feathers for the follow-up. Rin'ji the captive troll sits in the lodge too: his escort is OPTIONAL and ends at the eastern cliffs
    .complete 7841,1 --Highvale Outrunner (15)
    .complete 7841,2 --Highvale Scout (15)
    .complete 7841,3 --Highvale Marksman (10)
    .mob Highvale Outrunner
    .mob Highvale Scout
    .mob Highvale Marksman

step
    .goto 1425/0,-2758.11,262.90
    >>Take Rin'ji is Trapped! at Rin'ji
    .accept 2742 >> Accept Rin'ji is Trapped!

step
    .goto The Hinterlands,46.0,60.0
    >>Escort Rin'ji
    .complete -2742,1 --Escort Rin'ji
    .mob Highvale Outrunner
    .mob Highvale Scout
    .mob Highvale Marksman

step
    .goto 1425/0,-4897.55,-47.92
    >>Hand in Rin'ji is Trapped! at Rin'ji's Secret
    .turnin -2742 >> Turn in Rin'ji is Trapped!

step
    .goto The Hinterlands,79.0,79.2
    >>Otho pays and sends you back for feathers; Yayo'jin's cannibals and the Jintha'alor hill close the zone
    .turnin 7841 >> Turn in Message to the Wildhammer
    .accept 7842 >> Accept Another Message to the Wildhammer
    .complete 7842,1 --Long Elegant Feather (10)
    .turnin 7842 >> Turn in Another Message to the Wildhammer
    .target Otho Moji'ko

step
    .goto The Hinterlands,79.0,79.2
    >>Take The Final Message to the Wildhammer at Otho Moji'ko
    .accept 7843,2,7842 >> Accept The Final Message to the Wildhammer
    .target Otho Moji'ko

step
    .goto The Hinterlands,48.9,66.1
    >>Jintha'alor, the Vilebranch ziggurat: this is the big one. Working up the terraces: 30 Scalpers and 15 Soul Eaters for Yayo'jin, 10 Vessels of Tainted Blood from the braziers, Slagtree's Lost Tools on a crate, skulls if your pike ran short -- and at the top, Hitah'ya the Keeper holds the Shackle Key for Elder Torntusk, chained mid-hill. Free him and WALK HIM DOWN -- the escort through the terraces is the payout of the zone. 49-50 elites near the summit; bring sustain, take the terraces one pull at a time
    .complete 7844,1 --Vilebranch Scalper (30)
    .complete 7844,2 --Vilebranch Soul Eater (15)
    .mob Vilebranch Scalper
    .mob Vilebranch Soul Eater
    .mob Vilebranch Witch Doctor
    .unitscan Hitah'ya the Keeper

step
    .goto The Hinterlands,59.0,77.0
    >>Vessel of Tainted Blood (10)
    .complete -7850,1 --Vessel of Tainted Blood (10)
    .mob Vilebranch Scalper
    .mob Vilebranch Soul Eater
    .mob Vilebranch Witch Doctor
    .unitscan Hitah'ya the Keeper

step
    .goto The Hinterlands,57.4,42.6
    >>Slagtree's Lost Tools
    .complete -7839,1 --Slagtree's Lost Tools
    .mob Vilebranch Scalper
    .mob Vilebranch Soul Eater
    .mob Vilebranch Witch Doctor
    .unitscan Hitah'ya the Keeper

step
    .goto The Hinterlands,59.0,77.0
    >>Hand in Kidnapped Elder Torntusk! at Elder Torntusk
    .turnin -7845 >> Turn in Kidnapped Elder Torntusk!
    .target Elder Torntusk

step
    .goto The Hinterlands,59.0,77.0
    >>Take Recover the Key! at Elder Torntusk
    .accept 7846,2,7845 >> Accept Recover the Key!
    .target Elder Torntusk

step
    .goto The Hinterlands,59.0,77.0
    >>Shackle Key from Hitah'ya, then hand in Recover the Key! at Elder Torntusk
    .complete -7846,1 --Shackle Key from Hitah'ya
    .turnin -7846 >> Turn in Recover the Key!
    .mob Vilebranch Scalper
    .mob Vilebranch Soul Eater
    .mob Vilebranch Witch Doctor
    .unitscan Hitah'ya the Keeper
    .target Elder Torntusk

step
    .goto The Hinterlands,59.0,77.0
    >>Take Return to Primal Torntusk at Elder Torntusk
    .accept 7847,2,7846 >> Accept Return to Primal Torntusk
    .target Elder Torntusk

step
    #optional
    .goto The Hinterlands,84.5,41.2
    >>Lard's Lunch: his picnic basket lies on the coast north of Revantusk
    .complete 7840,1 --Lard's Lunch

step
    #optional
    .isQuestComplete 7843
    .goto 1425/0,-4631.13,-563.05
    >>Took The Final Message to the Wildhammer earlier? Otho Moji'ko is right here -- hand it in
    .turnin -7843 >> Turn in The Final Message to the Wildhammer
    .target Otho Moji'ko

step
    .goto The Hinterlands,79.0,79.0
    >>Revantusk pays the war out -- the Elder's homecoming is the big one
    .turnin 7828 >> Turn in Stalking the Stalkers
    .turnin 7829 >> Turn in Hunt the Savages
    .turnin 7830 >> Turn in Avenging the Fallen
    .target Huntsman Markhor

step
    .goto The Hinterlands,79.0,78.0
    >>Hand in Cannibalistic Cousins at Mystic Yayo'jin
    .turnin -7844 >> Turn in Cannibalistic Cousins
    .target Mystic Yayo'jin

step
    .goto The Hinterlands,77.0,80.0
    >>Hand in Vilebranch Hooligans at Smith Slagtree
    .turnin -7839 >> Turn in Vilebranch Hooligans
    .target Smith Slagtree

step
    .goto The Hinterlands,78.0,81.0
    >>Hand in Lard Lost His Lunch at Lard, then hand in Dark Vessels, Return to Primal Torntusk at Primal Torntusk
    .turnin -7840 >> Turn in Lard Lost His Lunch
    .turnin -7850 >> Turn in Dark Vessels
    .turnin -7847 >> Turn in Return to Primal Torntusk
    .target Lard
    .target Primal Torntusk

step
    .goto The Hinterlands,81.7,81.8
    >>Fly west out of the basin and home through Tarren Mill: Lydon pays for Vilebranch venom if you kept any (bottle and sac both -- his chain ends with Master Gadrin in Sen'jin, bank it)
    .fly Tarren Mill >> Fly to Tarren Mill

step
    #optional
    .goto Hillsbrad Foothills,61.4,19.1
    .turnin -2933 >> Turn in Venom Bottles
    .target Apothecary Lydon

step
    #optional
    .goto Hillsbrad Foothills,61.4,19.1
    >>Take Undamaged Venom Sac at Apothecary Lydon
    .accept 2934,2,2933 >> Accept Undamaged Venom Sac
    .target Apothecary Lydon

step
    #optional
    .goto Hillsbrad Foothills,61.4,19.1
    >>Hand in Undamaged Venom Sac at Apothecary Lydon
    .turnin -2934 >> Turn in Undamaged Venom Sac
    .target Apothecary Lydon

step
    .goto Hillsbrad Foothills,60.1,18.6
    >>Fly to the Undercity, zeppelin to Orgrimmar, and fly the long chain to Kargath -- the Searing Gorge closes the decade
    .fly Undercity >> Fly to Undercity

step
    .goto Tirisfal Glades,60.6,58.7
    .zone Durotar >> Zeppelin to Orgrimmar

step
    .goto Durotar,45.1,13.7
    .fly Kargath >> Fly to Kargath

step
    .goto Badlands,3.0,46.0
    >>Kargath business first: Gorn's ogre vendetta (Boss Tho'grun camps with the Dustbelchers -- take his Sign of the Earth), and Jarkal's second reagent run if his vessels line up
    .accept 782 >> Accept Broken Alliances
    .target Gorn

step
    .goto Badlands,2.4,46.1
    >>Take Badlands Reagent Run II at Jarkal Mossmeld
    .accept 2203,2,2202 >> Accept Badlands Reagent Run II
    .target Jarkal Mossmeld

step
    .goto Badlands,47.0,45.0
    >>Boss Tho'grun among the eastern ogres; scorched guardians for Jarkal's vessels roam the dragon scar
    .complete 782,1 --Boss Tho'grun / Sign of the Earth
    .unitscan Boss Tho'grun

step
    .goto Badlands,79.4,51.5
    >>Filled vessels
    .complete -2203,1 --Filled vessels
    .unitscan Boss Tho'grun

step
    .goto Badlands,3.0,46.0
    >>Gorn pays (skip his pillar ritual follow-up); the vessels land next door
    .turnin 782 >> Turn in Broken Alliances
    .goto Badlands,2.4,46.1
    .turnin -2203 >> Turn in Badlands Reagent Run II
    .target Gorn
    .target Jarkal Mossmeld

step
    .goto Badlands,2.6,61.9,60,0
    >>South from Kargath along the western cliffs, then west through the pass into the Searing Gorge, to Thorium Point -- the Brotherhood pays anyone who hurts the Dark Iron
    .goto Searing Gorge,34.8,30.9
    .fp Thorium Point >> Get the Thorium Point flight path

step
    .goto Searing Gorge,39.0,28.0
    >>The Thorium Point board: Hansel's three twenties, plus whatever WANTED posters and dropped job notices hang around the camp
    .accept 7723 >> Accept Curse These Fat Fingers
    .accept 7724 >> Accept Fiery Menace!
    .accept 7727 >> Accept Incendosaurs? Whateverosaur is More Like It
    .target Hansel Heavyhands

step
    .goto Searing Gorge,45.0,45.0
    >>The Cauldron: 20 Heavy War Golems and 20 Greater Lava Spiders on the rim, 20 Incendosaurs down in the Slag Pit tunnels. Dark Iron crews drop job notices, stolen gear, and secret plans as you work (turn them in at camp as they appear)
    .complete 7723,1 --Heavy War Golem (20)
    .complete 7724,1 --Greater Lava Spider (20)
    .complete 7727,1 --Incendosaur (20)
    .mob Heavy War Golem
    .mob Greater Lava Spider
    .mob Incendosaur
    .mob Dark Iron Taskmaster
    .mob Dark Iron Slaver

step
    .goto Searing Gorge,39.0,28.0
    >>Hansel pays all three; the found papers land around camp
    .turnin 7723 >> Turn in Curse These Fat Fingers
    .turnin 7724 >> Turn in Fiery Menace!
    .turnin 7727 >> Turn in Incendosaurs? Whateverosaur is More Like It
    .turnin -7728 >> Turn in STOLEN: Smithing Tuyere and Lookout's Spyglass
    .turnin -7729 >> Turn in JOB OPPORTUNITY: Culling the Competition
    .turnin -7701 >> Turn in WANTED: Overseer Maltorius
    .turnin -7704 >> Turn in Look at the Size of It!
    .turnin -7722 >> Turn in What the Flux?
    .target Hansel Heavyhands
    .target Taskmaster Scrange
    .target Lookout Captain Lolo Longstriker
    .target Evonice Sootsmoker
    .target Master Smith Burninate

step
    .goto Searing Gorge,42.0,48.0
    .xp 50 >> HORDE HALFWAY-HOME: golems, spiders, and Dark Iron crews grind the last stretch to 50

step
    +CHAPTER COMPLETE AT 50 -- Un'Goro Crater continues the chain. Riding along: Return to Fel'Zerul (1444, hearth to Stonard), Grim Message turn-in (2932, Nimboya at Grom'gol), Consult Master Gadrin (2935, Sen'jin), Return to Uzer'i (3122) and his muisek hunts, Talo's harpy vengeance (3062/3063, Mojache), the Final Message (7843, Aerie Peak), Gorn's pillars (793), the insect report (32 if unfinished), Rage Scar hides (7734), Noggenfogger and the ZF surrounds in Tanaris, plus Blasted Lands and Un'Goro boards opening at 50
    +This chunk is fresh from the quest database -- report any step that misbehaves with its number.
]])
