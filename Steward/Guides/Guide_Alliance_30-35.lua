-- RXPGuides_ForeverWarrior: Alliance 30-35 (part A of 30-40)
-- Pure QuestieDB build (no free skeleton exists past 30). Chapters:
-- 30-32 Stormwind/Duskwood > 32-34 Desolace > 34-35 Arathi/Alterac
-- Pays banked from 21-30: 74 (Stalvan chain resumes), 57, 221, 181, 101, 156,
-- 228, 293 (Benedictus), 322 (Grimand), 337 (library), 689 (granite -> IF),
-- 563 stays banked for Theramore (part B). 335 optional. VERIFY IN GAME.

-- ==================== 30-32 STORMWIND / DUSKWOOD =====================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 30-32 Stormwind/Duskwood (Alliance)
#next 32-34 Desolace (Alliance)
<< Alliance

step
    .goto 1453/0,852.67,-8529.83
    >>Make your way to Stormwind. In the Cathedral of Light, Archbishop Benedictus takes the Cursed Eye of Paleth you've carried since the Wetlands
    .turnin -293 >> Turn in Cleansing the Eye
    .target Archbishop Benedictus

step
    .isOnQuest 322
    .goto 1453/0,685.11,-8387.12
    >>Grimand Elmore in the Dwarven District receives the crate of Lightforge Ingots
    .turnin -322 >> Turn in Blessed Arm
    .target Grimand Elmore

step << Warrior
    #optional
    .isOnQuest 1702
    .goto 1453/0,600.14,-8427.08
    >>WARRIOR: Furen Longbeard takes the Barleybrew cask -- his Fire-Hardened Mail wants gathered smithing goods (the quest lists them; the AH shortcuts all of it). Bring the goods to him whenever you pass Stormwind -- the 44-45 chapter stops here again
    .turnin -1702 >> Turn in The Shieldsmith
    .target Furen Longbeard

step << Warrior
    #optional
    .goto 1453/0,600.14,-8427.08
    >>Take Fire Hardened Mail at Furen Longbeard
    .accept 1701,2,1702 >> Accept Fire Hardened Mail
    .target Furen Longbeard

step
    .isOnQuest 337
    .goto 1453/0,383.83,-8345.76
    >>The library in the Cathedral district wants its History of Stormwind back
    .turnin 337 >> Turn in An Old History Book

step
    .isOnQuest 74
    .goto Elwynn Forest,84.6,69.3
    >>Ride east to the Eastvale Logging Camp: Marshal Haggard recognizes the torn journal page -- and sends you upstairs for the next
    .turnin 74 >> Turn in The Legend of Stalvan
    .accept 75 >> Accept The Legend of Stalvan
    .complete 75,1 --Faded Journal Page
    .turnin 75 >> Turn in The Legend of Stalvan
    .accept 78 >> Accept The Legend of Stalvan
    .target Marshal Haggard
    .turnin -1666 >> Turn in Marshal Haggard
    .target Marshal Haggard

step
    .goto Duskwood,73.7,44.4
    >>South into Duskwood. Tavernkeep Smitts reads the faded page -- and takes the Rot Blossoms if you've gathered his eight
    .turnin -78 >> Turn in The Legend of Stalvan
    .target Tavernkeep Smitts

step
    .goto Duskwood,73.7,44.4
    >>Take The Legend of Stalvan; hand in Gather Rot Blossoms at Tavernkeep Smitts
    .accept 79,2,78 >> Accept The Legend of Stalvan
    .turnin -156 >> Turn in Gather Rot Blossoms
    .target Tavernkeep Smitts

step
    .goto Duskwood,73.5,46.8
    >>Commander Althea Ebonlocke runs the Night Watch from the town hall side
    .turnin -79 >> Turn in The Legend of Stalvan
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,73.5,46.8
    >>Take The Legend of Stalvan; hand in The Night Watch; take The Night Watch at Commander Althea Ebonlocke
    .accept 80,2,79 >> Accept The Legend of Stalvan
    .turnin -57 >> Turn in The Night Watch
    .accept 58,2,57 >> Accept The Night Watch
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,72.5,46.8
    >>Clerk Daltry examines the bloodstained page
    .turnin -80 >> Turn in The Legend of Stalvan
    .target Clerk Daltry

step
    .goto Duskwood,72.5,46.8
    >>Take The Legend of Stalvan at Clerk Daltry
    .accept 97,2,80 >> Accept The Legend of Stalvan
    .target Clerk Daltry

step
    .goto Duskwood,73.5,46.8
    >>Althea hears the truth about Stalvan Mistmantle
    .turnin -97 >> Turn in The Legend of Stalvan
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,73.5,46.8
    >>Take The Legend of Stalvan; hand in The Night Watch at Commander Althea Ebonlocke
    .accept 98,2,97 >> Accept The Legend of Stalvan
    .turnin -58 >> Turn in The Night Watch
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,75.7,47.5
    >>More Darkshire rounds: Calor's worgen tally, Viktori's stargazing, the mayor and the historian
    .turnin -221 >> Turn in Worgen in the Woods
    .accept 222,2,221 >> Accept Worgen in the Woods
    .target Calor

step
    .goto Duskwood,79.8,48.0
    >>Hand in Look To The Stars at Viktori Prism'Antras
    .turnin -181 >> Turn in Look To The Stars
    .target Viktori Prism'Antras

step
    .goto Duskwood,75.7,45.3
    >>Madame Eva takes the Totem makings if your Night Watch farming filled them -- ghoul fangs, skeleton fingers, spider venom
    .turnin -101 >> Turn in The Totem of Infliction
    .target Madame Eva

step
    #sticky
    #completewith RoweDone
    .isOnQuest 58
    >>Night Watch round two: Nightbane worgen in the southern woods
    .complete -58,1 --Nightbane Shadow Weaver (10)
    .complete -58,2 --Nightbane Dark Runner (10)
    .mob Nightbane Shadow Weaver
    .mob Nightbane Dark Runner

step
    .isOnQuest 222
    .goto Duskwood,67.0,74.0,60,0
    >>Calor's count continues: Nightbane Vile Fangs and Nightbane Tainted Ones, the worgen south of town
    .complete -222,1 --Nightbane Vile Fang
    .complete -222,2 --Nightbane Tainted One
    .mob Nightbane Vile Fang
    .mob Nightbane Tainted One

step
    .goto Duskwood,75.7,47.5
    >>Calor again -- the final tally
    .turnin -222 >> Turn in Worgen in the Woods
    .target Calor

step
    .isOnQuest 98
    .goto Duskwood,77.4,36.1
    >>Forlorn Rowe, northeast graveyard: Stalvan Mistmantle himself (level 35 ghost -- pull him alone, use everything). Show his ring to Madame Eva after
    .complete -98,1 --Stalvan's ring
    .unitscan Stalvan Mistmantle

step
    .isOnQuest 228
    .goto Duskwood,78.0,33.0,60,0
    >>Mor'Ladim stalks the same graveyard -- level 35 and mean. Clear adds first; skip and return at 33 if he wrecks you
    .complete 228,1 --Mor'Ladim slain
    .unitscan Mor'Ladim

step
    #label RoweDone
    .goto Duskwood,75.7,45.3
    >>Madame Eva closes the Mistmantle story
    .turnin -98 >> Turn in The Legend of Stalvan
    .target Madame Eva

step
    .goto Duskwood,73.5,46.8
    >>Althea pays for the graveyard work
    .turnin -228 >> Turn in Mor'Ladim
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,73.5,46.8
    >>Take The Daughter Who Lived at Commander Althea Ebonlocke
    .accept 229,2,228 >> Accept The Daughter Who Lived
    .target Commander Althea Ebonlocke

step
    .goto Duskwood,74.0,47.8
    >>Hand in The Daughter Who Lived at Watcher Ladimore
    .turnin -229 >> Turn in The Daughter Who Lived
    .target Watcher Ladimore

step
    .goto Duskwood,74.0,47.8
    >>Take A Daughter's Love at Watcher Ladimore
    .accept 231,2,229 >> Accept A Daughter's Love
    .target Watcher Ladimore

step
    .isOnQuest 231
    .goto 1431/0,354.62,-10240.11
    >>Blind Mary keeps a house south of town -- bring her Ladimore's love
    .turnin -231 >> Turn in A Daughter's Love
    .target Blind Mary

step
    .goto Duskwood,28.1,31.4
    >>Ride west to the hermit Abercrombie's shack past Raven Hill
    .accept 134 >> Accept Ogre Thieves
    .target Abercrombie

step
    .isOnQuest 134
    .goto Duskwood,32.6,73.7,60,0
    >>Vul'Gol Ogre Mound south: the ogres stole Abercrombie's crate -- search the mound floor for it
    .complete 134,1 --Abercrombie's Crate
    .mob Splinter Fist Ogre
    .mob Splinter Fist Warrior
    .mob Splinter Fist Fire Weaver

step
    .goto Duskwood,28.1,31.4
    >>Back to the hermit
    .turnin 134 >> Turn in Ogre Thieves
    .accept 160 >> Accept Note to the Mayor
    .target Abercrombie

step
    .goto Duskwood,71.9,46.4
    >>Deliver the hermit's note to Lord Ello in Darkshire -- he can't read it and sends it on to the historian
    .turnin 160 >> Turn in Note to the Mayor
    .accept 251 >> Accept Translate Abercrombie's Note
    .target Lord Ello Ebonlocke

step
    .goto Duskwood,72.6,47.6
    >>Sirra Von'Indi translates the note: hand it over, wait for her to finish, take the translation
    .turnin -251 >> Turn in Translate Abercrombie's Note
    .accept 401,2,251 >> Accept Wait for Sirra to Finish
    .turnin -401 >> Turn in Wait for Sirra to Finish
    .accept 252,2,401 >> Accept Translation to Ello
    .target Sirra Von'Indi

step
    .goto Duskwood,71.9,46.4
    >>Back to Lord Ello with the translation; he asks for the Bride of the Embalmer
    .turnin -252 >> Turn in Translation to Ello
    .accept 253,2,252 >> Accept Bride of the Embalmer
    .target Lord Ello Ebonlocke

step
    .isOnQuest 253
    #optional
    .goto Duskwood,35.0,27.0,40,0
    >>OPTIONAL: Eliza rises at the Raven Hill graveyard when you dig the grave (level 36 elite -- group or skip; if you skip, abandon Bride of the Embalmer, the route doesn't come back for it)
    .complete -253,1 --Eliza slain

step
    #optional
    .isQuestComplete 253
    .goto Duskwood,71.9,46.4
    >>Lord Ello Ebonlocke in Darkshire, if Eliza fell
    .turnin -253 >> Turn in Bride of the Embalmer
    .target Lord Ello Ebonlocke

step
    .goto Duskwood,77.5,44.5
    >>Grind Darkshire's surroundings to a solid 32 before the long trip west
    .xp 32 >> Reach level 32
]])

-- ======================== 32-34 DESOLACE =============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 32-34 Desolace (Alliance)
#next 34-35 Arathi/Alterac (Alliance)
<< Alliance

step
    .goto Duskwood,77.6,44.3
    .fly Stormwind >> Fly to Stormwind

step
    .goto 1453/0,1331.98,-8632.92
    >>Stormwind Harbor: take the boat to Auberdine
    .zone Darkshore >> Boat to Auberdine

step
    #completewith NijelArrive
    .goto Darkshore,36.5,45.5,40
    >>The long road south: through Auberdine, down Darkshore's coast road, into Ashenvale
    .goto Ashenvale,34.6,49.5,60
    .goto Ashenvale,26.0,61.0,60
    >>Southwest through Ashenvale toward the Stonetalon border
    .goto Stonetalon Mountains,38.0,67.0,60
    >>Cross the Charred Vale (level 25-28 mobs -- just ride through)
    .goto Stonetalon Mountains,27.5,75.5,40
    >>The pass in the vale's southwest corner drops into Desolace

step
    #label NijelArrive
    .goto Desolace,64.9,10.2
    .fp Nijel's Point >> Get the Nijel's Point flight path

step
    .goto Desolace,66.4,11.8
    >>Nijel's Point quest round
    .accept 1437 >> Accept Vahlarriel's Search
    .target Vahlarriel Demonslayer

step
    .goto Desolace,66.7,10.8
    >>Take Centaur Bounty at Corporal Melkins
    .accept 1387 >> Accept Centaur Bounty
    .target Corporal Melkins

step
    .goto Desolace,66.2,9.6
    >>Take Reagents for Reclaimers Inc. at Kreldig Ungor
    .accept 1458 >> Accept Reagents for Reclaimers Inc.
    .target Kreldig Ungor

step
    #sticky
    #completewith DesoEars
    >>Every centaur in Desolace counts toward Melkins' bounty -- collect ears as you go
    .complete 1387,1 --Centaur Ear (15)

step
    .isOnQuest 1437
    .goto Desolace,45.5,24.5,50,0
    >>The Malem wagon lies wrecked on the road southwest -- search it
    .complete 1437,1 --Search the wagon

step
    .goto 1443/1,1692.29,-82.75
    >>Hand in Vahlarriel's Search at Malem Chest
    .turnin -1437 >> Turn in Vahlarriel's Search

step
    .goto Desolace,66.4,11.8
    >>Vahlarriel sends you after the survivor
    .accept 1438 >> Accept Vahlarriel's Search
    .target Vahlarriel Demonslayer

step
    .isOnQuest 1438
    .goto Desolace,54.8,26.1
    >>Dalinda Malem is held in Thunder Axe Fortress -- fight through the burning blade to her
    .turnin 1438 >> Turn in Vahlarriel's Search
    .accept 1439 >> Accept Search for Tyranis
    .target Dalinda Malem

step
    .isOnQuest 1439
    .goto Desolace,52.0,27.0,40,0
    >>Tyranis is already one of them -- he attacks when found in the fortress. Put him down and return to Dalinda
    .complete 1439,1 --Tyranis Malem

step
    .goto 1443/1,1766.92,-331.27
    >>Hand in Search for Tyranis; take Return to Vahlarriel at Dalinda Malem
    .turnin -1439 >> Turn in Search for Tyranis
    .accept 1440,2,1439 >> Accept Return to Vahlarriel
    .target Dalinda Malem

step
    .isOnQuest 1440
    .goto Desolace,54.8,26.1
    >>Walk Dalinda out of Thunder Axe, then carry word back
    .complete -1440,1 --Escort Dalinda Malem

step
    #optional
    .goto Desolace,38.8,27.1
    >>OPTIONAL: Azore Aldamort's tower at Ethel Rethor, on the coast road west -- two retrievals worth real experience
    .accept 5741 >> Accept Sceptre of Light
    .accept 6027,2,5741 >> Accept Book of the Ancients
    .target Azore Aldamort

step
    .goto Desolace,66.4,11.8
    >>Nijel's Point: Vahlarriel owes you
    .turnin -1440 >> Turn in Return to Vahlarriel
    .target Vahlarriel Demonslayer

step
    .isOnQuest 1458
    .goto Desolace,71.5,25.0,60,0
    >>Sargeron, the demon highlands east: Hatefury satyrs carry Kreldig's claws and horns
    .complete 1458,1 --Hatefury Claw (10)
    .complete 1458,2 --Hatefury Horn (10)
    .mob Hatefury Rogue
    .mob Hatefury Trickster
    .mob Hatefury Shadowstalker

step
    .goto Desolace,66.2,9.6
    >>Kreldig pays and doubles the order
    .turnin 1458 >> Turn in Reagents for Reclaimers Inc.
    .accept 1459 >> Accept Reagents for Reclaimers Inc.
    .target Kreldig Ungor

step
    .isOnQuest 1459
    .goto Desolace,59.0,45.0,70,0
    >>Center Desolace: Scorpashi scorpids for venom, Aged Kodos for hides -- the kodo graveyard region south has both
    .complete 1459,1 --Scorpashi Venom (7)
    .complete 1459,2 --Aged Kodo Hide (3)
    .mob Scorpashi Snapper
    .mob Scorpashi Lasher
    .mob Aged Kodo

step
    .goto Desolace,60.8,61.8
    >>Smeed Scrabblescrew's camp on the southern road -- his kodo job is the best experience-per-minute in the zone
    .accept 5561 >> Accept Kodo Roundup
    .target Smeed Scrabblescrew

step
    .isOnQuest 5561
    .goto Desolace,51.0,60.0,60,0
    >>Use the Kodo Kombobulator on Aged and Dying kodos nearby, then lead each tamed beast back to Smeed. Five total
    .complete 5561,1 --Kodos Tamed (5)

step
    .goto Desolace,60.8,61.8
    .turnin 5561 >> Turn in Kodo Roundup
    .target Smeed Scrabblescrew

step
    #optional
    .isOnQuest 5741
    .goto Desolace,51.0,76.0,60,0
    >>OPTIONAL: Mannoroc Coven, the demon fields south -- the Sceptre of Light is held among the doomwarders. The Book of the Ancients lies with the naga of the western shore
    .complete 5741,1 --Sceptre of Light

step
    #optional
    .isOnQuest 6027
    .goto Desolace,30.0,62.0,60,0
    >>Drysnap and Hatecrest naga along the Sar'theris Strand guard the Book
    .complete -6027,1 --Book of the Ancients

step
    #optional
    .goto Desolace,38.8,27.1
    >>Azore settles both debts
    .turnin -5741 >> Turn in Sceptre of Light
    .turnin -6027 >> Turn in Book of the Ancients
    .target Azore Aldamort

step
    #optional
    .isOnQuest 1387
    .goto 1443/1,984.64,-888.29
    >>Still short on Centaur Ear? Galthogran the Callous / Gelkis Earthcaller / Gelkis Guardian -- around here. This step skips itself once you have them
    .complete 1387,1 --Centaur Ear (15)
    .mob Galthogran the Callous
    .mob Gelkis Earthcaller
    .mob Gelkis Guardian
    .mob Gelkis Marauder

step
    #label DesoEars
    .isQuestComplete 1387
    .goto Desolace,66.7,10.8
    >>Melkins counts the ears
    .turnin 1387 >> Turn in Centaur Bounty
    .target Corporal Melkins

step
    .isOnQuest 1459
    .goto Desolace,66.2,9.6
    .turnin 1459 >> Turn in Reagents for Reclaimers Inc.
    .target Kreldig Ungor

step
    .goto Desolace,62.0,38.0
    .xp 34 >> Grind centaur and kodo country to level 34
]])

-- ===================== 34-35 ARATHI / ALTERAC ========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 34-35 Arathi/Alterac (Alliance)
#next 35-37 Dustwallow Marsh (Alliance)
<< Alliance

step
    .goto Desolace,64.9,10.2
    .fly Auberdine >> Fly to Auberdine

step
    .goto Darkshore,32.4,43.9
    >>Boat from Auberdine's pier to Menethil Harbor
    .zone Wetlands >> Boat to Menethil Harbor

step
    .goto Wetlands,9.5,59.7
    .fly Southshore >> Fly to Southshore

step
    .goto Hillsbrad Foothills,50.3,59.0
    >>Southshore pickup round -- these pay out across the chapter
    .accept 659 >> Accept Hints of a New Plague?
    .target Phin Odelic

step
    .goto Hillsbrad Foothills,49.4,58.7
    >>Take Crushridge Bounty at Marshal Redpath
    .accept 500 >> Accept Crushridge Bounty
    .target Marshal Redpath

step
    .goto Hillsbrad Foothills,48.1,59.1
    >>Take Syndicate Assassins at Magistrate Henry Maleb
    .accept 505 >> Accept Syndicate Assassins
    .target Magistrate Henry Maleb

step
    .goto Hillsbrad Foothills,51.8,58.6
    .accept 555 >> Accept Soothing Turtle Bisque
    >>Buy Soothing Spices from a trade supplies vendor while in town
    .collect 3713,1,555 --Soothing Spices
    .target Chef Jessen

step
    .goto Hillsbrad Foothills,49.3,52.2
    .fly Wetlands >> Fly back to Menethil Harbor

step
    #sticky
    #completewith ThandolStart
    .isOnQuest 555
    >>Snapping turtles along the Wetlands' marshy coast drop the Turtle Meat for Jessen's bisque -- ten pieces
    .collect 3712,10,555 --Turtle Meat (10)

step
    #label ThandolStart
    .goto Wetlands,49.9,18.2
    >>Ride northeast to Dun Modr: the Garmason brothers hold the ruined town against the Dark Irons
    .accept 631 >> Accept The Thandol Span
    .target Rhag Garmason

step
    .isOnQuest 631
    .goto Wetlands,49.5,12.5,30,0
    >>Ol' Rustlocke lies dead below the span's broken gap -- search the area under the bridge for his corpse and the parchment on it
    .complete 631,1 --Locate Ol' Rustlocke

step
    .goto 1437/0,-2510.22,-2367.04
    >>Take The Thandol Span at Ebenezer Rustlocke's Corpse
    .accept 632 >> Accept The Thandol Span

step
    .goto Wetlands,49.9,18.2
    >>Show Rhag the parchment
    .turnin -632 >> Turn in The Thandol Span
    .accept 633 >> Accept The Thandol Span
    .target Rhag Garmason

step
    .isOnQuest 633
    .goto Wetlands,50.3,8.8
    >>The Dark Iron cache of explosives sits on the span itself -- destroy it
    .complete 633,1 --Cache of Explosives Destroyed

step
    .goto Wetlands,49.9,18.2
    .turnin 633 >> Turn in The Thandol Span
    .accept 634 >> Accept Plea To The Alliance
    .target Rhag Garmason

step
    .goto Arathi Highlands,45.8,47.5
    >>Cross the span into Arathi and ride to Refuge Pointe
    .turnin -634 >> Turn in Plea To The Alliance
    .accept 681 >> Accept Northfold Manor
    .goto Arathi Highlands,46.2,47.7
    .accept 691 >> Accept Worth Its Weight in Gold
    .target Captain Nials
    .target Apprentice Kryten

step
    .goto Arathi Highlands,45.9,46.1
    .fp Refuge Pointe >> Get the Refuge Pointe flight path

step
    .isOnQuest 659
    .goto 1417/0,-3033.15,-1425.73
    >>Quae and Kinelory camp near Go'Shek Farm east -- Phin's plague worry lands with them. Take whatever follow-ups they offer; the chain winds back to Southshore
    .turnin 659 >> Turn in Hints of a New Plague?
    .target Quae
    .target Kinelory

step
    .isOnQuest 681
    .goto Arathi Highlands,31.0,38.5,50,0
    >>Northfold Manor, northwest: Syndicate men took it -- thin them for Nials
    .complete 681,1 --Syndicate Highwayman (5)
    .complete 681,2 --Syndicate Pathstalker (5)
    .mob Syndicate Highwayman
    .mob Syndicate Pathstalker

step
    .isOnQuest 691
    .goto Arathi Highlands,36.0,46.0,60,0
    >>Kor'gresh and his Boulderfist kin south of Stromgarde hold the gold Kryten wants -- ogres drop it throughout the Boulderfist camps
    .complete 691,1 --O'Reily's Lost Gold

step
    .goto Arathi Highlands,45.8,47.5
    >>Refuge Pointe pays
    .turnin -681 >> Turn in Northfold Manor
    .target Captain Nials

step
    .goto Arathi Highlands,45.8,47.5
    >>Take Stromgarde Badges at Captain Nials
    .accept 682,2,681 >> Accept Stromgarde Badges
    .target Captain Nials

step
    .goto Arathi Highlands,46.2,47.7
    >>Hand in Worth Its Weight in Gold at Apprentice Kryten
    .turnin -691 >> Turn in Worth Its Weight in Gold
    .target Apprentice Kryten

step
    #optional
    .isOnQuest 682
    .goto Arathi Highlands,25.0,60.0,50,0
    >>OPTIONAL (hard at 34 -- the keep crawls with 37-39s): Stromgarde's Syndicate quarter drops the badges Nials wants. Group it or come back at 37
    .complete -682,1 --Stromgarde Badge (10)
    .mob Syndicate Magus
    .mob Syndicate Prowler

step
    #optional
    .isQuestComplete 682
    .goto Arathi Highlands,45.8,47.5
    .turnin -682 >> Turn in Stromgarde Badges
    .target Captain Nials

step
    .goto Arathi Highlands,31.7,82.6
    >>Faldir's Cove, the hidden bay southwest: shipwrecked sailors with work to spare
    .accept 663 >> Accept Land Ho!
    .target Lolo the Lookout

step
    .goto Arathi Highlands,34.0,80.8
    >>Take Drowned Sorrows at Captain Steelgut
    .accept 664,2,663 >> Accept Drowned Sorrows
    .target Captain Steelgut

step
    .goto Arathi Highlands,33.8,80.5
    >>Take Sunken Treasure at Professor Phizzlethorpe
    .accept 665,2,663 >> Accept Sunken Treasure
    .target Professor Phizzlethorpe

step
    .goto Arathi Highlands,32.8,81.4
    >>Take Deep Sea Salvage at First Mate Nilzlix
    .accept 662,2,663 >> Accept Deep Sea Salvage
    .target First Mate Nilzlix

step
    .isOnQuest 664
    .goto Arathi Highlands,29.0,85.0,50,0
    >>Daggerspine naga infest the cove's waters -- Steelgut wants them drowned for good
    .complete -664,1 --Daggerspine Shorehunter (6)
    .complete -664,2 --Daggerspine Siren (6)
    .mob Daggerspine Shorehunter
    .mob Daggerspine Siren

step
    .isOnQuest 662
    .goto Arathi Highlands,27.0,87.0,50,0
    >>The fleet's crates sank just offshore -- dive for the salvage among the wrecks
    .complete -662,1 --Deep Sea Salvage

step
    .isOnQuest 665
    .goto Arathi Highlands,33.8,80.5
    >>Phizzlethorpe's escort walks the shore to the dig -- guard him, then settle with Draxlegauge
    .complete -665,1 --Escort Phizzlethorpe
    .turnin -665 >> Turn in Sunken Treasure
    .accept 666,2,665 >> Accept Sunken Treasure
    .turnin 666 >> Turn in Sunken Treasure
    .accept 668 >> Accept Sunken Treasure
    .target Professor Phizzlethorpe
    .target Doctor Draxlegauge

step
    .goto Arathi Highlands,32.2,81.3
    >>Shakes O'Breen closes the cove's accounts -- and offers Booty Bay work for later
    .turnin -663 >> Turn in Land Ho!
    .turnin -668 >> Turn in Sunken Treasure
    .accept 667,2,670 >> Accept Sunken Treasure
    .target Shakes O'Breen

step
    .goto Arathi Highlands,32.2,81.3
    >>Hand in Death From Below; take Sunken Treasure at Shakes O'Breen
    .turnin -667 >> Turn in Sunken Treasure
    .accept 669,2,668 >> Accept Sunken Treasure
    .target Shakes O'Breen

step
    .goto Arathi Highlands,34.0,80.8
    >>Hand in Drowned Sorrows at Captain Steelgut
    .turnin -664 >> Turn in Drowned Sorrows
    .target Captain Steelgut

step
    .goto Arathi Highlands,32.8,81.4
    >>Hand in Deep Sea Salvage at First Mate Nilzlix
    .turnin -662 >> Turn in Deep Sea Salvage
    .target First Mate Nilzlix

step
    .goto Arathi Highlands,27.0,46.5
    >>Ride northwest out of Arathi through the highlands pass into the Alterac foothills
    .zone Alterac Mountains >> Enter the Alterac Mountains

step
    .isOnQuest 505
    .goto Alterac Mountains,55.0,72.0,60,0
    >>Syndicate camps dot Alterac's southern slopes: Footpads and Thieves for Maleb
    .complete 505,1 --Syndicate Footpad (12)
    .complete 505,2 --Syndicate Thief (8)
    .mob Syndicate Footpad
    .mob Syndicate Thief

step
    .isOnQuest 500
    .goto Alterac Mountains,38.0,70.0,50,0
    >>The Ruins of Alterac above: Crushridge ogres carry Dirty Knucklebones -- and chunks of Alterac Granite for the Ironforge mason
    .complete 500,1 --Dirty Knucklebone (9)
    .complete -689,1 --Alterac Granite (5)
    .mob Crushridge Ogre
    .mob Crushridge Brute
    .mob Crushridge Mauler

step
    #optional
    .isOnQuest 555
    .goto 1416/0,-48.27,791.04
    >>Still short on Turtle Meat? Aku'mai Fisher / Aku'mai Snapjaw / Coralshell Lurker -- around here. This step skips itself once you have them
    .collect 3712,10,555 --Turtle Meat (10)
    .mob Aku'mai Fisher
    .mob Aku'mai Snapjaw
    .mob Coralshell Lurker
    .mob Coralshell Tortoise

step
    .goto 1424/0,-516.37,-852.91
    >>Down to Southshore for the payout
    .turnin -500 >> Turn in Crushridge Bounty
    .target Marshal Redpath

step
    .goto Hillsbrad Foothills,48.1,59.1
    >>Hand in Syndicate Assassins at Magistrate Henry Maleb
    .turnin -505 >> Turn in Syndicate Assassins
    .target Magistrate Henry Maleb

step
    .goto Hillsbrad Foothills,51.8,58.6
    >>Hand in Soothing Turtle Bisque at Chef Jessen
    .turnin -555 >> Turn in Soothing Turtle Bisque
    .target Chef Jessen

step
    #optional
    .isQuestComplete 689
    .goto Hillsbrad Foothills,49.3,52.2
    >>OPTIONAL: fly to Ironforge -- Grand Mason Marblesten in the Commons takes the Alterac Granite you've owed him since the twenties
    .fly Ironforge >> Fly to Ironforge

step
    #optional
    .isQuestComplete 689
    .goto 1455/0,-1022.25,-5033.80
    .turnin 689 >> Turn in A King's Tribute
    .target Grand Mason Marblesten

step
    .goto Hillsbrad Foothills,50.0,50.0
    .xp 35 >> Grind Hillsbrad's hills to 35

step
    +Part A of 30-40 complete. Still banked: Reassignment (563 -- pays at Theramore next chunk), Sunken Treasure (669 -- pays at Booty Bay), Noble Deaths (512), A Noble Brew (335), Bride of the Embalmer (253) if skipped, plus 79007/97003/2842
    +Next chunk: 35-40 through Dustwallow, Badlands, and Stranglethorn.
]])
