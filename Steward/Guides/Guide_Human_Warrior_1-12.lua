-- =====================================================================
--  Custom WoW: Forever leveling guide -- Human (Warrior-optimized), 1-12
--  Route: Northshire > Elwynn Forest > Stormwind > Ironforge >
--         Dun Morogh > Loch Modan tunnel
--
--  Built for the free RestedXP (RXPGuides) addon, WoW: Forever client
--  (interface 16001). Quest IDs, NPC positions, and the Forever-only
--  quests were cross-checked against RestedXP's free Forever starter
--  routes (github.com/RestedXP/RXPGuides) on 2026-11-06, so the
--  .accept / .turnin / .complete automation fires on live Forever data.
--  Guide text and step layout are original; for personal use.
--
--  Quick syntax reminders (full reference: your RXP docs sheet):
--    step                 begins a step;  << Warrior  limits who sees it
--    .goto mapID/0,x,y    waypoint (world coords; 1429 = Elwynn Forest,
--                         1436 Westfall, 1453 Stormwind, 1455 Ironforge,
--                         1426 Dun Morogh, 1433 Redridge Mountains)
--    .accept/.turnin id   quest automation; ".turnin id,n" picks reward n
--    .complete id,obj     tracks a quest objective
--    #sticky #label #requires #completewith #optional   step flow
--  To edit: change this file, save, then /reload in game.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Horde" then return end

-- ============================ GUIDE 1 ================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 1-6 Northshire (Alliance)
#next 6-12 Elwynn Forest (Alliance)
<< Alliance

step
    #completewith next
    +Warrior-optimized Human 1-12 route for WoW: Forever. Quest rewards are auto-picked for Warriors; other classes get a reward choice. If you are not Human, walk to Northshire first.

step
    .goto 1429/0,-136.48,-8933.47
    >>Talk to Deputy Willem at the Abbey entrance
    .accept 783 >> Accept A Threat Within
    .target Deputy Willem

step << Warrior
    .goto 1429/0,-75.05,-8872.36,35,0
    >>Kill Young Wolves east of the Abbey until their vendor trash is worth ~10 copper
    >>You can train Battle Shout at level 1 here -- it noticeably speeds up early levels
    .goto 1429/0,-112.74,-8901.66
    >>Sell the trash to Brother Danil
    .vendor >> Vendor trash
    .target Brother Danil
    .target Llane Beshere

step << Warrior
    .goto 1429/0,-208.40,-8918.35
    >>Then talk to Llane Beshere, downstairs inside the Abbey
    .train 6673 >> Train Battle Shout
    .mob Young Wolf

step
    .goto 1429/0,-162.62,-8902.59
    >>Talk to Marshal McBride inside the Abbey
    .turnin 783 >> Turn in A Threat Within
    .accept 7 >> Accept Kobold Camp Cleanup
    .target Marshal McBride

step
    .goto 1429/0,-136.48,-8933.47
    >>Back outside, talk to Deputy Willem
    .accept 5261 >> Accept Eagan Peltskinner
    .target Deputy Willem

step
    .goto 1429/0,-163.24,-8869.26
    >>Talk to Eagan Peltskinner, left of the Abbey entrance
    .turnin 5261 >> Turn in Eagan Peltskinner
    .accept 33 >> Accept Wolves Across The Border
    .target Eagan Peltskinner

step
    #sticky
    #label WolfMeat
    .goto 1429/0,-129.75,-8852.04
    >>Kill Young Wolves and Timber Wolves around the vineyards for 8 Tough Wolf Meat
    .complete 33,1 --Tough Wolf Meat (8)
    .mob Young Wolf
    .mob Timber Wolf

step
    .goto 1429/0,-116.73,-8789.50
    >>Kill Kobold Vermin in the northern vineyards
    >>One drops a Nibbled-On Book -- use it from your bags to start a quest (Forever-only chain, worth doing)
    .use 247834
    .collect 247834,1,91741,1 -- Nibbled-On Book
    .accept 91741 >> Accept Nibbled-On Book
    .complete 7,1 --Kobold Vermin (10)
    .mob Kobold Vermin

step
    #optional
    .isOnQuest 33
    .goto 1429/0,-84.07,-8851.30
    >>Still short on Tough Wolf Meat? Timber Wolf / Young Wolf -- around here. This step skips itself once you have them
    .complete 33,1 --Tough Wolf Meat (8)
    .mob Timber Wolf
    .mob Young Wolf

step
    #requires WolfMeat
    .goto 1429/0,-163.24,-8869.26
    >>Return to Eagan Peltskinner
    .turnin 33,2 >> Turn in Wolves Across The Border << Warrior
    .turnin 33 >> Turn in Wolves Across The Border << !Warrior
    .target Eagan Peltskinner

step
    .goto 1429/0,-186.12,-8874.91
    >>Talk to Brother Paxton in the Abbey library
    .turnin 91741 >> Turn in Nibbled-On Book
    .accept 92124 >> Accept Book Inventory
    .target Brother Paxton

step
    .goto 1429/0,-182.65,-8881.62
    >>Talk to Daniel nearby
    .turnin 92124 >> Turn in Book Inventory
    .target Daniel

step
    .goto 1429/0,-186.12,-8874.91
    >>Back to Brother Paxton
    .accept 91743 >> Accept Rascally Rodents
    .target Brother Paxton

step
    .goto 1429/0,-116.73,-8789.50
    >>Finish off the Kobold Vermin and loot 8 Stolen Books
    .complete 7,1 --Kobold Vermin (10)
    .complete 91743,1 --Stolen Book (8)
    .mob Kobold Vermin

step
    .goto 1429/0,-119.86,-8898.21
    >>Sell your trash to Godric Rothgar by the Abbey
    .vendor >> Vendor trash
    .target Godric Rothgar

step
    .goto 1429/0,-162.62,-8902.59
    >>Talk to Marshal McBride
    .turnin 7 >> Turn in Kobold Camp Cleanup
    .accept 15 >> Accept Investigate Echo Ridge
    .accept 3100 >> Accept Simple Letter << Human Warrior
    .accept 3101 >> Accept Consecrated Letter << Human Paladin
    .accept 3102 >> Accept Encrypted Letter << Human Rogue
    .accept 3103 >> Accept Hallowed Letter << Human Priest
    .accept 3104 >> Accept Glyphic Letter << Human Mage
    .accept 3105 >> Accept Tainted Letter << Human Warlock
    .accept 92479 >> Accept A Scribbled Letter << Human Hunter
    .target Marshal McBride

step
    .goto 1429/0,-136.48,-8933.47
    >>Talk to Deputy Willem outside
    .accept 18 >> Accept Brotherhood of Thieves
    .target Deputy Willem

step << Warrior
    .goto 1429/0,-208.40,-8918.35
    >>Deliver your letter to Llane Beshere downstairs and train your new abilities
    >>(Charge comes at level 4 -- grab it as soon as you can)
    .turnin 3100 >> Turn in Simple Letter
    .trainer >> Train your class abilities
    .target Llane Beshere

step << !Warrior
    #optional
    >>Deliver your letter to your class trainer inside the Abbey and train your abilities
    .turnin 3101 >> Turn in Consecrated Letter << Paladin
    .turnin 3102 >> Turn in Encrypted Letter << Rogue
    .turnin 3103 >> Turn in Hallowed Letter << Priest
    .turnin 3104 >> Turn in Glyphic Letter << Mage
    .turnin 3105 >> Turn in Tainted Letter << Warlock
    .turnin 92479 >> Turn in A Scribbled Letter << Hunter
    .trainer >> Train your class abilities

step << Warlock
    .goto 1429/0,-195.59,-8926.73
    >>WARLOCK: Take The Stolen Tome at Drusilla La Salle; train at your class trainer
    .accept 1598 >> Accept The Stolen Tome
    .train 348
    .target Drusilla La Salle

step << Warlock
    .goto 1429/0,-432.55,-8958.00
    >>WARLOCK: Objective: Powers of the Void
    .complete 1598,1 --Collect Powers of the Void (x1)

step << Warlock
    .goto 1429/0,-195.59,-8926.73
    >>WARLOCK: Hand in The Stolen Tome at Drusilla La Salle
    .turnin 1598 >> Turn in The Stolen Tome
    .target Drusilla La Salle

step << Priest/Mage
    #loop
    .goto 1429/0,-288.51,-9068.87,0
    >>PRIEST: Objective: Milly's Harvest
    .goto 1429/0,-388.47,-9001.28,0
    .goto 1429/0,-288.51,-9068.87,30,0
    .goto 1429/0,-335.02,-9108.91,30,0
    .goto 1429/0,-376.67,-9073.73,30,0
    .goto 1429/0,-388.47,-9001.28,30,0
    .goto 1429/0,-333.97,-9028.59,30,0
    .complete 3904,1 --Collect Milly's Harvest (x8)

step << Priest/Mage
    .goto 1429/0,-224.02,-8850.30
    >>PRIEST: Hand in Milly's Harvest; take Grape Manifest at Milly Osworth
    .turnin -3904 >> Turn in Milly's Harvest
    .accept 3905 >> Accept Grape Manifest
    .target Milly Osworth

step
    .goto 1429/0,-252.24,-8820.61
    >>Kill 10 Kobold Workers in the western vineyards
    >>Keep looting Stolen Books if you still need any
    .complete 15,1 --Kobold Worker (10)
    .mob Kobold Worker

step
    .goto 1429/0,-162.62,-8902.59
    >>Return to Marshal McBride
    .turnin 15 >> Turn in Investigate Echo Ridge
    .accept 21 >> Accept Skirmish at Echo Ridge
    .target Marshal McBride

step
    .goto 1429/0,-186.12,-8874.91
    >>Hand the Stolen Books to Brother Paxton
    .turnin 91743 >> Turn in Rascally Rodents
    .accept 91745 >> Accept Mining Consultant
    .target Brother Paxton

step << Priest/Mage
    .goto 1429/0,-181.64,-8902.13
    >>PRIEST: Hand in Grape Manifest at Brother Neals
    .turnin 3905,1
    .target Brother Neals

step
    .goto 1429/0,-102.30,-8684.50
    >>Talk to Kelsey Fargo near the Echo Ridge Mine entrance
    .turnin 91745 >> Turn in Mining Consultant
    .accept 91752 >> Accept The Big Picture
    .target Kelsey Fargo

step
    .goto 1429/0,-199.27,-8532.58
    >>Head into Echo Ridge Mine: kill 12 Kobold Laborers
    >>Kill Shinyfinder Narf inside and loot the Sack of "Picture" Books
    .complete 21,1 --Kobold Laborer (12)
    .complete 91752,1 --Sack of "Picture" Books
    .mob Kobold Laborer
    .mob Shinyfinder Narf

step
    #sticky
    #label Bandanas
    .goto 1429/0,-333.97,-9028.59
    >>Head to the southwest vineyards: kill Defias Thugs for 12 Red Burlap Bandanas
    .complete 18,1 --Red Burlap Bandana (12)
    .mob Defias Thug

step
    #optional
    .isOnQuest 18
    .goto 1429/0,-324.60,-9045.03
    >>Still short on Red Burlap Bandana? Defias Thug -- around here. This step skips itself once you have them
    .complete 18,1 --Red Burlap Bandana (12)
    .mob Defias Thug

step
    #requires Bandanas
    .goto 1429/0,-136.48,-8933.47
    >>Return to Deputy Willem
    .turnin 18,3 >> Turn in Brotherhood of Thieves << Warrior
    .turnin 18 >> Turn in Brotherhood of Thieves << !Warrior
    .accept 3903 >> Accept Milly Osworth
    .accept 6 >> Accept Bounty on Garrick Padfoot
    .target Deputy Willem

step
    .goto 1429/0,-224.02,-8850.30
    >>Talk to Milly Osworth by the vineyard
    .turnin 3903 >> Turn in Milly Osworth
    .target Milly Osworth

step << Priest/Mage
    .goto 1429/0,-224.02,-8850.30
    >>PRIEST: Take Milly's Harvest at Milly Osworth
    .accept 3904 >> Accept Milly's Harvest
    .target Milly Osworth

step
    .goto 1429/0,-460.94,-9056.44
    >>Kill Garrick Padfoot at the shack in the far southwest corner and loot his head
    .complete 6,1 --Garrick's Head
    .mob Garrick Padfoot

step
    .goto 1429/0,-136.48,-8933.47
    >>Back to Deputy Willem
    .turnin 6,2 >> Turn in Bounty on Garrick Padfoot << Warrior
    .turnin 6 >> Turn in Bounty on Garrick Padfoot << !Warrior
    .target Deputy Willem

step
    .goto 1429/0,-162.62,-8902.59
    >>Talk to Marshal McBride
    .turnin 91752 >> Turn in The Big Picture
    .accept 91758 >> Accept Follow That Kobold!
    .turnin 21,2 >> Turn in Skirmish at Echo Ridge << Warrior
    .turnin 21 >> Turn in Skirmish at Echo Ridge << !Warrior
    .accept 54 >> Accept Report to Goldshire
    .accept 96627 >> Accept The Adventurer
    .target Marshal McBride

step
    .goto 1429/0,-242.00,-8884.30
    >>Talk to Tordrin Sternblade outside the Abbey
    .turnin 91758 >> Turn in Follow That Kobold!
    .accept 91772 >> Accept Shhh! We're Hunting Kobolds
    .target Tordrin Sternblade

step
    .goto 1429/0,-46.00,-9044.61
    >>Head out of Northshire toward Goldshire
    >>Use the Kobold Tracking Kit from your bags and click the 6 green Kobold Tracks along the road
    .use 247970
    .complete 91772,1 --Kobold Tracks (6)

step
    .goto 1429/0,-46.00,-9044.61
    >>Talk to Falkhaan Isenstrider at the first house on the road
    .accept 2158 >> Accept Rest and Relaxation
    .target Falkhaan Isenstrider
]])

-- ============================ GUIDE 2 ================================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 6-12 Elwynn Forest (Alliance)
#next 11-13 Loch Modan (Alliance)
<< Alliance

step
    .goto 1429/0,-22.99,-9404.71
    >>Talk to Sam Sarsaparilla at the camp beside the road
    .turnin 96627 >> Turn in The Adventurer
    .accept 95998 >> Accept The Great Outdoors
    .target Sam Sarsaparilla

step
    .goto 1429/0,-22.99,-9402.40
    >>Type /sit at the campfire and stay seated for about a minute to gain the boosted rest buff
    .complete 95998,1 --Sit at the campfire
    .complete 95998,2 --Gain the boosted rest buff

step
    .goto 1429/0,-22.99,-9404.71
    >>Talk to Sam Sarsaparilla again
    >>(If you've already trained a gathering profession, he also offers a Camping 101 quest for it -- grab it too)
    .turnin 95998 >> Turn in The Great Outdoors
    .accept 96626 >> Accept Camping 101: Cooking
    .target Sam Sarsaparilla

step << Warrior
    .goto 1429/0,87.87,-9456.65
    >>OPTIONAL but recommended: train Blacksmithing with Smith Argus in Goldshire
    >>With Mining (trainable later in Dun Morogh), you can craft Rough Sharpening Stones: +2 weapon damage, 30 min. Keep one on your weapon while leveling
    .train 2018 >> Train Blacksmithing
    .target Smith Argus

step << Warrior
    .goto 1429/0,94.01,-9464.89
    >>Buy a Gladius (two-hand sword) from Corina Steele if you can afford it -- a big damage upgrade
    .collect 2488,1 --Gladius
    .disablecheckbox
    .target Corina Steele
    .money <0.0536
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8

step << Warrior
    #completewith next
    +Equip the Gladius
    .use 2488
    .itemcount 2488,1
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<3.8

step
    .goto 1429/0,74.02,-9465.52
    >>Talk to Marshal Dughan in the middle of Goldshire
    .turnin 54 >> Turn in Report to Goldshire
    .turnin 91772 >> Turn in Shhh! We're Hunting Kobolds
    .accept 62 >> Accept The Fargodeep Mine
    .accept 91775 >> Accept Book Return
    .target Marshal Dughan

step
    .goto 1429/0,31.92,-9460.38
    >>Talk to William Pestle inside the house opposite the inn
    .accept 60 >> Accept Kobold Candles
    .target William Pestle

step
    .goto 1429/0,16.20,-9462.65
    >>Talk to Innkeeper Farley: turn in, then set your Hearthstone here
    .turnin 2158,1 >> Turn in Rest and Relaxation << Warrior
    .turnin 2158 >> Turn in Rest and Relaxation << !Warrior
    .home >> Set your Hearthstone to Goldshire
    .target Innkeeper Farley

step << Priest
    .goto 1429/0,-193.34,-8853.59
    >>PRIEST: Priestess Anetta back at the abbey starts your first vestments -- grab it if she hasn't given you In Favor of the Light already
    .accept 5623 >> Accept In Favor of the Light
    .target Priestess Anetta

step << Priest
    .goto Elwynn Forest,43.28,65.72
    >>Priestess Josetta, upstairs in the Goldshire inn
    .turnin -5623 >> Turn in In Favor of the Light
    .target Priestess Josetta

step << Priest
    .goto Elwynn Forest,43.28,65.72
    >>Take Garments of the Light at Priestess Josetta
    .accept 5624,2,5623 >> Accept Garments of the Light
    .target Priestess Josetta

step << Priest
    .isOnQuest 5624
    .goto Elwynn Forest,48.15,68.05
    >>Guard Roberts holds the road southeast: heal him with Lesser Heal (Rank 2), then Power Word: Fortitude -- train both first
    .complete -5624,1
    .target Guard Roberts

step << Priest
    .isQuestComplete 5624
    .goto Elwynn Forest,43.28,65.72
    >>Josetta's robe is yours -- and note for 10: High Priestess Laurena in Stormwind's Cathedral teaches Desperate Prayer
    .turnin -5624 >> Turn in Garments of the Light
    .target Priestess Josetta

step << Warrior
    #optional
    .goto 1429/0,16.20,-9462.65
    >>Buy a stack of Dalaran Sharp from Farley -- cheap food so you aren't eating gold
    .collect 414,10 --Dalaran Sharp
    .disablecheckbox
    .target Innkeeper Farley

step
    #optional
    .goto 1429/0,-5.63,-9467.21
    >>Talk to Tomas in the inn kitchen: train Cooking, then turn in
    .train 2550 >> Train Cooking
    .turnin 96626 >> Turn in Camping 101: Cooking
    .target Tomas
    .money <0.0100

step << Warrior
    .goto 1429/0,109.36,-9461.84
    >>Train with Lyria Du Lac, east side of Goldshire
    .trainer >> Train your class abilities
    .target Lyria Du Lac

step << Warrior
    #optional
    .goto 1429/0,29.35,-9456.79
    >>Upstairs in the house opposite the inn: train First Aid with Michelle Belle -- warriors live off bandages
    .train 3273 >> Train First Aid
    .target Michelle Belle
    .money <0.01

step
    .goto 1429/0,72.81,-9496.23
    >>Talk to Remy "Two Times" behind the inn
    .accept 47 >> Accept Gold Dust Exchange
    .target Remy "Two Times"

step
    #sticky
    #label BoarMeat
    .goto 1429/0,92.38,-9548.20
    >>As you head south, kill Stonetusk Boars for 4 Chunks of Boar Meat (for a quest you'll pick up shortly)
    .collect 769,4,86,1 --Chunk of Boar Meat (4)
    .mob Stonetusk Boar

step
    .goto 1429/0,338.47,-9889.69
    >>At the Stonefield Farm, talk to "Auntie" Bernice Stonefield and Ma Stonefield
    .accept 85 >> Accept Lost Necklace
    .target "Auntie" Bernice Stonefield
    .goto 1429/0,332.43,-9894.99
    .accept 88 >> Accept Princess Must Die!
    .target Ma Stonefield

step
    #sticky
    #label KoboldFarm
    .goto 1429/0,223.09,-9916.24
    >>Kill Kobold Tunnelers and Miners around the Fargodeep Mine entrance
    >>Loot Kobold Candles, Gold Dust, and Lost Books
    .complete 60,1 --Kobold Candle (8)
    .complete 47,1 --Gold Dust (10)
    .complete 91775,2 --Lost Book (6)
    .mob Kobold Tunneler
    .mob Kobold Miner

step
    .goto 1429/0,38.41,-9923.69
    >>Talk to Billy Maclure at the Maclure Vineyards
    .turnin 85 >> Turn in Lost Necklace
    .accept 86 >> Accept Pie for Billy
    .target Billy Maclure

step
    .goto 1429/0,37.61,-10014.03
    >>Talk to Maybell Maclure
    .accept 106 >> Accept Young Lovers
    .target Maybell Maclure

step
    #optional
    .goto 1429/0,65.28,-10008.20
    >>Vendor trash with Joshua Maclure if your bags are filling
    .vendor >> Vendor trash
    .target Joshua Maclure

step
    .goto 1429/0,499.72,-9930.05
    >>Talk to Tommy Joe Stonefield by the river east of the Stonefield Farm
    .turnin 106 >> Turn in Young Lovers
    .accept 111 >> Accept Speak with Gramma
    .target Tommy Joe Stonefield

step
    #optional
    .isOnQuest 86
    .goto 1431/0,197.06,-9933.83
    >>Still short on Chunk of Boar Meat? Stonetusk Boar -- around here. This step skips itself once you have them
    .collect 769,4,86,1 --Chunk of Boar Meat (4)
    .mob Stonetusk Boar

step
    #requires BoarMeat
    .goto 1429/0,338.47,-9889.69
    >>Bring the boar meat to Bernice
    .turnin 86 >> Turn in Pie for Billy
    .accept 84 >> Accept Back to Billy
    .target "Auntie" Bernice Stonefield

step
    .goto 1429/0,322.53,-9880.48
    >>Talk to Gramma Stonefield inside the farmhouse
    .turnin 111 >> Turn in Speak with Gramma
    .accept 107 >> Accept Note to William
    .target Gramma Stonefield

step
    .goto 1429/0,38.41,-9923.69
    >>Back to Billy Maclure
    .turnin 84 >> Turn in Back to Billy
    .accept 87 >> Accept Goldtooth
    .target Billy Maclure

step
    .goto 1429/0,149.86,-9793.80
    >>Head into Fargodeep Mine and scout through the large open chamber
    .complete 62,1 --Scout the Fargodeep Mine

step
    .goto 1429/0,86.97,-9745.51
    >>Kill Goldtooth inside the mine and loot Bernice's Necklace
    >>Careful: he usually comes with the Kobold Miner next to him
    .complete 87,1 --Bernice's Necklace
    .mob Goldtooth

step
    .goto 1429/0,91.20,-9788.50
    >>Kill Nimsy deeper in the mine for the Picture Book: Fun with Elementals
    >>Nimsy summons an add and respawns around him are fast -- grab a partner, or skip this step if solo feels rough
    .complete 91775,1 --Picture Book: Fun with Elementals
    .mob Nimsy

step << Warrior
    #completewith next
    +Keep one Minor Healing Potion in your bags -- you'll want it for a tough fight at Stone Cairn Lake later

step
    #optional
    .isOnQuest 60
    .goto 1431/0,180.40,-9822.73
    >>Still short on Large Candle? Kobold Miner / Kobold Tunneler -- around here. This step skips itself once you have them
    .complete 60,1 --Kobold Candle (8)
    .mob Kobold Miner
    .mob Kobold Tunneler

step
    #optional
    .isOnQuest 47
    .goto 1431/0,180.40,-9822.73
    >>Still short on Gold Dust? Kobold Miner / Kobold Tunneler -- around here. This step skips itself once you have them
    .complete 47,1 --Gold Dust (10)
    .mob Kobold Miner
    .mob Kobold Tunneler

step
    #optional
    .isOnQuest 91775
    .goto 1431/0,180.40,-9822.73
    >>Still short on Lost Book? Kobold Miner / Kobold Tunneler -- around here. This step skips itself once you have them
    .complete 91775,2 --Lost Book (6)
    .mob Kobold Miner
    .mob Kobold Tunneler

step
    #requires KoboldFarm
    .goto 1429/0,338.47,-9889.69
    >>Finish any kobold drops you're missing, then return the necklace to Bernice
    .turnin 87 >> Turn in Goldtooth
    .target "Auntie" Bernice Stonefield

step
    .goto 1429/0,72.81,-9496.23
    >>Back in Goldshire, talk to Remy "Two Times"
    >>KEEP the Bag of Marbles reward -- its 3-second distract is useful all the way to 60
    .turnin 47 >> Turn in Gold Dust Exchange
    .accept 40 >> Accept A Fishy Peril
    .target Remy "Two Times"

step
    .goto 1429/0,74.02,-9465.52
    >>Talk to Marshal Dughan
    .turnin 62 >> Turn in The Fargodeep Mine
    .accept 76 >> Accept The Jasperlode Mine
    .turnin 40 >> Turn in A Fishy Peril
    .accept 35 >> Accept Further Concerns
    .turnin 91775 >> Turn in Book Return
    .accept 91777 >> Accept Rare Books
    .target Marshal Dughan

step
    .goto 1429/0,31.92,-9460.38
    >>Talk to William Pestle
    .turnin 60 >> Turn in Kobold Candles
    .accept 61 >> Accept Shipment to Stormwind
    .turnin 107 >> Turn in Note to William
    .accept 112 >> Accept Collecting Kelp
    .target William Pestle

step << Warrior
    #optional
    .goto 1429/0,109.36,-9461.84
    >>Train anything new with Lyria Du Lac
    .trainer >> Train your class abilities
    .target Lyria Du Lac

step
    .goto 1429/0,-113.23,-9379.25
    >>North of Crystal Lake, talk to Jason Mathers
    .accept 99127 >> Accept A Net Disaster
    .target Jason Mathers

step
    .goto 1429/0,-116.70,-9381.57
    >>Talk to Lee Brown beside him
    .accept 99143 >> Accept Bottles and Baubles
    .target Lee Brown

step
    .goto 1429/0,-196.53,-9478.78
    >>Loot 7 Half-Eaten Fish from the torn nets in the water (they can be hard to spot)
    .complete 99127,1 --Half-Eaten Fish (7)

step
    .goto 1429/0,-113.23,-9379.25
    >>Back to Jason Mathers
    .turnin 99127 >> Turn in A Net Disaster
    .accept 99128 >> Accept Slimy Menace
    .target Jason Mathers

step
    .goto 1429/0,-347.02,-9487.76
    >>Clear the murlocs along the shore: 7 Murlocs and 4 Murloc Streamrunners
    >>Loot 4 Crystal Kelp Fronds from them and 6 Shiny Junk from the piles on the ground
    >>Murlocs run for help at low health -- fight them one at a time and away from the water
    .complete 99128,2 --Murlocs (7)
    .complete 99128,1 --Murloc Streamrunners (4)
    .complete 112,1 --Crystal Kelp Frond (4)
    .complete 99143,1 --Shiny Junk (6)
    .mob Murloc
    .mob Murloc Streamrunner

step
    .goto 1429/0,-116.70,-9381.57
    >>Turn in to Lee Brown
    .turnin 99143 >> Turn in Bottles and Baubles
    .target Lee Brown

step
    .goto 1429/0,-113.23,-9379.25
    >>And Jason Mathers
    .turnin 99128 >> Turn in Slimy Menace
    .accept 99129 >> Accept A Man About a Murloc
    .target Jason Mathers

step
    .goto 1429/0,-560.62,-9100.58
    >>Enter Jasperlode Mine (northeast of the lake) and follow the middle path to scout it
    .complete 76,1 --Scout the Jasperlode Mine

step
    .goto 1429/0,-595.10,-9072.20
    >>Kill Geosculptor Yip in the mine and loot Geomancy for Curious Young Wizards
    >>He summons three small elementals -- skip if it's too much solo
    .complete 91777,1 --Geomancy for Curious Young Wizards
    .mob Geosculptor Yip

step
    .goto 1429/0,-620.20,-9050.80
    >>Kill Mother Fang and loot the Arcane Explainer
    >>She nets and poisons -- skip if needed
    .complete 91777,2 --Arcane Explainer
    .mob Mother Fang

step
    #optional
    .isQuestComplete 91777
    .goto 1429/0,-186.20,-8874.80
    >>Got both books? Detour to Brother Paxton in Northshire -- the reward is a weapon upgrade
    .turnin 91777 >> Turn in Rare Books
    .target Brother Paxton

step
    .goto 1429/0,-1032.06,-9610.23
    >>Cut east over the hills to the Eastvale road bridge and talk to Guard Thomas
    .turnin 35 >> Turn in Further Concerns
    .accept 37 >> Accept Find the Lost Guards
    .accept 52 >> Accept Protect the Frontier
    .target Guard Thomas

step
    #sticky
    #label Frontier
    >>Kill 8 Prowlers and 5 Young Forest Bears as you quest through eastern Elwynn
    .complete 52,1 --Prowler (8)
    .complete 52,2 --Young Forest Bear (5)
    .mob Prowler
    .mob Young Forest Bear

step
    .goto 1429/0,-986.35,-9336.06
    >>North of the road: click the half-eaten corpse near the pond
    .turnin 37 >> Turn in Find the Lost Guards
    .accept 45 >> Accept Discover Rolf's Fate

step
    .goto 1429/0,-1234.31,-9224.18
    >>Rolf's corpse is at the murloc huts northeast of the pond
    >>Pull the two murlocs in front one at a time; Forager murlocs drink potions to heal << !Warrior
    >>Build full rage first. Pull the two front murlocs, Hamstring one and kill the other while kiting -- your Bag of Marbles helps. Use that healing potion if it goes wrong << Warrior
    .turnin 45 >> Turn in Discover Rolf's Fate
    .accept 71 >> Accept Report to Thomas

step
    .goto 1429/0,-1289.22,-9469.80
    >>At the Eastvale Logging Camp, talk to Supervisor Raelen
    .accept 5545 >> Accept A Bundle of Trouble
    .target Supervisor Raelen

step
    .goto 1429/0,-1362.03,-9309.59
    >>Loot 8 Bundles of Wood at the base of the trees north of camp
    .complete 5545,1 --Bundle of Wood (8)

step
    .goto 1429/0,-1289.22,-9469.80
    >>Back to Supervisor Raelen
    .turnin 5545 >> Turn in A Bundle of Trouble
    .target Supervisor Raelen

step
    .goto 1429/0,-1222.40,-9531.76
    >>Talk to Sara Timberlain at the east side of camp
    .accept 83 >> Accept Red Linen Goods
    .target Sara Timberlain

step
    .goto 1429/0,-1119.77,-9603.77
    >>Talk to Ormin Pelford south of the bridge
    .accept 91733 >> Accept Downstream
    .target Ormin Pelford

step
    .goto 1429/0,-1043.41,-9707.92
    >>Follow the river south: loot the Waterlogged Saw on the bank
    .complete 91733,2 --Waterlogged Saw

step
    .goto 1429/0,-1126.71,-9849.11
    >>Further downstream: the Waterlogged Axe
    .complete 91733,1 --Waterlogged Axe

step
    .goto 1429/0,-1147.54,-9948.64
    >>And the Waterlogged Toolbox near Stone Cairn Lake
    .complete 91733,3 --Waterlogged Toolbox

step
    #optional
    .goto 1429/0,-1119.80,-9931.30
    >>Croaky, the big murloc here, is a level 11 ELITE. If you can find a group, kill him and use the head he drops to start a quest. Solo? Skip this step
    .use 247826
    .collect 247826,1,91740,1 --Croaky's Head
    .accept 91740 >> Accept Croaky's Head
    .mob Croaky

step
    #optional
    .isQuestComplete 91740
    .goto 1429/0,-1406.20,-9775.50
    >>Turn in Croaky's Head to Merell Ross at Ridgepoint Tower
    .turnin 91740 >> Turn in Croaky's Head
    .target Merell Ross

step
    .goto 1429/0,-620.00,-9570.00
    >>Work the Defias Bandit camps around Stone Cairn Lake until all 6 Red Linen Bandanas are yours
    >>If a bandit drops the Westfall Deed, right-click it for a bonus quest (rare -- a treat, not a requirement)
    .complete 83,1 --Red Linen Bandana (6)
    .mob Defias Bandit

step
    #optional
    .use 1972
    .collect 1972,1,184 --Westfall Deed (rare drop)
    .accept 184 >> Accept Furlbrow's Deed

step
    #label Princess
    .goto 1429/0,-869.87,-9768.10
    >>Kill Princess at the farm west of the lake and loot the Brass Collar
    >>She comes with both of her Porcine Entourage adds and charges
    >>Build 100 rage before you pull, Hamstring the pig adds, and pop your potion if needed << Warrior
    .complete 88,1 --Brass Collar
    .mob Princess

step
    #optional
    .isOnQuest 52
    .goto 1431/0,-1215.57,-9784.31
    >>Still short on Prowler? Prowler -- around here. This step skips itself once you have them
    .complete 52,1 --Prowler (8)
    .mob Prowler

step
    #optional
    .isOnQuest 52
    .goto 1431/0,-644.27,-9735.70
    >>Still short on Young Forest Bear? Young Forest Bear -- around here. This step skips itself once you have them
    .complete 52,2 --Young Forest Bear (5)
    .mob Young Forest Bear

step
    #requires Frontier
    .goto 1429/0,-1032.06,-9610.23
    >>Return to Guard Thomas
    .turnin 52 >> Turn in Protect the Frontier
    .turnin 71 >> Turn in Report to Thomas
    .accept 39 >> Accept Deliver Thomas' Report
    .target Guard Thomas

step
    .goto 1429/0,-1119.77,-9603.77
    >>Hand the tools to Ormin Pelford
    .turnin 91733 >> Turn in Downstream
    .target Ormin Pelford

step
    .goto 1429/0,-1222.40,-9531.76
    >>Bring the bandanas to Sara Timberlain
    .turnin 83 >> Turn in Red Linen Goods
    .target Sara Timberlain

step << Warlock
    .goto 1429/0,-1222.40,-9531.76
    >>WARLOCK: Hand in Cloth and Leather Armor at Sara Timberlain
    .turnin 59 >> Turn in Cloth and Leather Armor
    .target Sara Timberlain
    .isOnQuest 83

step << Warlock
    #optional
    .goto 1429/0,-1222.40,-9531.76
    >>WARLOCK: Hand in Cloth and Leather Armor at Sara Timberlain
    .turnin 59 >> Turn in Cloth and Leather Armor
    .target Sara Timberlain

step
    #optional
    .goto 1433/0,-1948.56,-9582.75
    .zone Redridge Mountains >> OPTIONAL detour (worth it): follow the road east into Redridge Mountains

step
    #optional
    .xp <11,1
    .goto 1433/0,-1906.40,-9606.80
    >>Level 11+: Guard Parker at the tower has an easy hand-in pair (under 11 he won't offer it -- skip ahead, the 24-27 chapter picks it up)
    .accept 244 >> Accept Encroaching Gnolls
    .target Guard Parker

step
    #optional
    .xp <11,1
    .goto 1433/0,-2237.93,-9443.60
    >>Stick to the road into Lakeshire and talk to Deputy Feldon
    .turnin -244 >> Turn in Encroaching Gnolls
    .target Deputy Feldon

step
    #optional
    .goto 1433/0,-2234.90,-9435.30
    >>Grab the Redridge flight path from Ariena Stormfeather
    .fp Redridge Mountains >> Get the Redridge flight path
    .target Ariena Stormfeather

step
    .hs >> Hearth back to Goldshire

step << Warrior
    #completewith SWTrip
    +Money tip: from here, bank ~30 silver for your level 10 training and weapon skills in Stormwind and Ironforge. The next few turn-ins pay most of it

step
    .goto 1429/0,31.92,-9460.38
    >>Talk to William Pestle
    .turnin 112 >> Turn in Collecting Kelp
    .accept 114 >> Accept The Escape
    .target William Pestle

step
    .goto 1429/0,74.02,-9465.52
    >>Talk to Marshal Dughan
    .turnin 39 >> Turn in Deliver Thomas' Report
    .turnin 76 >> Turn in The Jasperlode Mine
    .accept 239 >> Accept Westbrook Garrison Needs Help!
    .accept 109 >> Accept Report to Gryan Stoutmantle
    .target Marshal Dughan

step << Warlock
    .goto 1429/0,74.02,-9465.52
    >>WARLOCK: Take Cloth and Leather Armor at Marshal Dughan
    .accept 59 >> Accept Cloth and Leather Armor
    .target Marshal Dughan

step
    .goto 1429/0,87.87,-9456.65
    >>Talk to Smith Argus
    .accept 1097 >> Accept Elmore's Task
    .target Smith Argus

step
    #optional
    .isQuestComplete 91746
    .goto 1429/0,-69.50,-9380.20
    >>If a wolf dropped Elmpaw's Head for you, turn it in to Helene Peltskinner north of Crystal Lake
    .turnin 91746 >> Turn in Elmpaw's Head
    .target Helene Peltskinner

step
    #optional
    .isQuestComplete 97924
    .goto 1429/0,-69.50,-9380.20
    >>Skinners: turn in Camping 101 to Helene Peltskinner
    .turnin 97924 >> Turn in Camping 101: Skinning
    .target Helene Peltskinner

step << Hunter
    .goto 1429/0,107.200,-9472.400
    >>HUNTER: Take Taming the Beast at Josephine Carson; train at your class trainer
    .target Josephine Carson::251507
    .accept 94792 >> Accept Taming the Beast
    .trainer >> Train at your class trainer

step << Hunter
    #loop
    .goto 1429/0,28.100,-9768.101,40,0
    >>HUNTER: Objective: Tame a Rockhide Boar -- Rockhide Boar
    .goto 1429/0,-36.100,-9814.500,40,0
    .use 266158
    .complete 94792,1 -- Tame a Rockhide Boar (1)
    .mob Rockhide Boar

step << Hunter
    .goto 1429/0,107.200,-9472.400
    >>HUNTER: Hand in Taming the Beast; take Taming the Beast at Josephine Carson
    .target Josephine Carson::251507
    .turnin 94792 >> Turn in Taming the Beast
    .accept 94863 >> Accept Taming the Beast

step << Hunter
    #loop
    .goto 1429/0,-556.600,-9524.300,40,0
    >>HUNTER: Objective: Tame a Gray Forest Wolf -- Gray Forest Wolf
    .goto 1429/0,-626.200,-9430.800,40,0
    .use 266253
    .complete 94863,1 -- Tame a Gray Forest Wolf (1)
    .mob Gray Forest Wolf

step << Hunter
    .goto 1429/0,107.200,-9472.400
    >>HUNTER: Hand in Taming the Beast; take Taming the Beast at Josephine Carson
    .target Josephine Carson::251507
    .turnin 94863 >> Turn in Taming the Beast
    .accept 94864 >> Accept Taming the Beast

step << Hunter
    #loop
    .goto 1429/0,-14.600,-9797.800,40,0
    >>HUNTER: Objective: Tame a Young Forest Bear -- Young Forest Bear
    .goto 1429/0,-146.800,-9784.500,40,0
    .goto 1429/0,-325.300,-9844.300,40,0
    .use 266254
    .complete 94864,1 -- Tame a Young Forest Bear (1)
    .mob Young Forest Bear

step << Hunter
    .goto 1429/0,107.200,-9472.400
    >>HUNTER: Hand in Taming the Beast; take Training the Beast at Josephine Carson
    .target Josephine Carson::251507
    .turnin 94864 >> Turn in Taming the Beast
    .accept 94793 >> Accept Training the Beast

step << Hunter
    .goto 1429/0,85.000,-9475.800
    >>HUNTER: Hand in Training the Beast at Isaac Chan; train at your class trainer
    .target Isaac Chan::258930
    .turnin 94793 >> Turn in Training the Beast
    .trainer >> Train at your class trainer

step << Warrior
    .goto 1429/0,109.36,-9461.84
    >>Talk to Lyria Du Lac: grab the level 10 class quest and train what you can afford (keep that Stormwind budget)
    .accept 1638 >> Accept A Warrior's Training
    .trainer >> Train your class abilities
    .target Lyria Du Lac

step << Warlock
    >>WARLOCK: Train at your class trainer; take Gakin's Summons at Remen Marcot
    .trainer >> Train at your class trainer
    .goto 1429/0,-5.36,-9472.760
    .target Maximillian Crowe
    .accept 1685 >> Accept Gakin's Summons
    .goto 1429/0,-8.58,-9473.41
    .target Remen Marcot

step << Priest
    #optional
    .goto 1429/0,33.14,-9460.75
    >>PRIEST: Take Divine Grace at Priestess Josetta; train at your class trainer
    .accept 94774 >> Accept Divine Grace
    .trainer >> Train at your class trainer
    .target Priestess Josetta
    .xp <10,1

step
    .goto 1429/0,72.81,-9496.23
    >>Talk to Remy "Two Times"
    .turnin 99129 >> Turn in A Man About a Murloc
    .target Remy "Two Times"

step
    .goto 1429/0,37.61,-10014.03
    >>Deliver the note to Maybell Maclure
    .turnin 114 >> Turn in The Escape
    .target Maybell Maclure

step
    .goto 1429/0,332.43,-9894.99
    >>Show Ma Stonefield the Brass Collar
    .turnin 88,2 >> Turn in Princess Must Die! << Warrior
    .turnin 88 >> Turn in Princess Must Die! << !Warrior
    .target Ma Stonefield

step
    .goto 1429/0,694.29,-9662.79
    >>Ride/run west to Westbrook Garrison and talk to Deputy Rainer
    >>(Skip Hogger's wanted poster -- he is a slow group kill and not worth the detour)
    .turnin 239 >> Turn in Westbrook Garrison Needs Help!
    .target Deputy Rainer

step << Warlock
    >>WARLOCK: Take Riverpaw Gnoll Bounty at Deputy Rainer, then take WANTED: "Hogger" at Wanted Poster
    .accept 11 >> Accept Riverpaw Gnoll Bounty
    .goto 1429/0,694.29,-9662.790
    .target Deputy Rainer
    .accept 176 >> Accept WANTED: "Hogger"
    .goto 1429/0,683.40,-9667.93

step << Warlock
    >>WARLOCK: Take The Collector by using the item that starts it; objective: Gold Pickup Schedule
    .use 1307
    .collect 1307,1,123 --Collect Gold Pickup Schedule (x1)
    .accept 123 >> Accept The Collector
    .unitscan Gruff Swiftbite

step << Warlock
    #completewith next
    >>WARLOCK: Objective: Painted Gnoll Armband -- Riverpaw Runt, Riverpaw Outrunner
    .complete 11,1 -- Painted Gnoll Armband (8)
    .mob Riverpaw Runt
    .mob Riverpaw Outrunner

step << Warlock
    .goto 1429/0,598.29,-9946.33,70,0
    >>WARLOCK: Objective: Huge Gnoll Claw
    .goto 1429/0,629.53,-10020.39,70,0
    .goto 1429/0,660.77,-10085.20,70,0
    .goto 1429/0,598.29,-10112.98,70,0
    .goto 1429/0,598.29,-9946.33,70,0
    .goto 1429/0,629.53,-10020.39,70,0
    .goto 1429/0,660.77,-10085.20,70,0
    .goto 1429/0,598.29,-10112.98,70,0
    .goto 1429/0,598.29,-9946.33,70,0
    .goto 1429/0,629.53,-10020.39,70,0
    .goto 1429/0,660.77,-10085.20,70,0
    .goto 1429/0,598.29,-10112.98,70,0
    .goto 1429/0,636.47,-10112.98
    .complete 176,1 --Huge Gnoll Claw (1)
    .unitscan Hogger

step << Warlock
    .goto 1429/0,598.29,-9946.33,70,0
    >>WARLOCK: Objective: Painted Gnoll Armband -- Riverpaw Runt, Riverpaw Outrunner
    .goto 1429/0,629.53,-10020.39,70,0
    .goto 1429/0,660.77,-10085.20,70,0
    .goto 1429/0,598.29,-10112.98,70,0
    .goto 1429/0,598.29,-9946.33,70,0
    .goto 1429/0,629.53,-10020.39,70,0
    .goto 1429/0,660.77,-10085.20,70,0
    .goto 1429/0,598.29,-10112.98,70,0
    .goto 1429/0,598.29,-9946.33,70,0
    .goto 1429/0,629.53,-10020.39,70,0
    .goto 1429/0,660.77,-10085.20,70,0
    .goto 1429/0,598.29,-10112.98,70,0
    .goto 1429/0,636.47,-10112.98
    .complete 11,1 -- Painted Gnoll Armband (8)
    .mob Riverpaw Runt
    .mob Riverpaw Outrunner
    .isOnQuest 11

step << Warlock
    .goto 1429/0,694.29,-9662.790
    >>WARLOCK: Hand in Riverpaw Gnoll Bounty at Deputy Rainer
    .turnin 11 >> Turn in Riverpaw Gnoll Bounty
    .target Deputy Rainer

step
    #label SWTrip
    .goto 1436/0,918.42,-9851.50
    .zone Westfall >> Follow the road southwest into Westfall

step
    .goto 1436/0,918.42,-9851.50
    >>Talk to Farmer Furlbrow and Verna at the broken wagon (quests for your level 13+ return trip)
    .accept 64 >> Accept The Forgotten Heirloom
    .turnin -184 >> Turn in Furlbrow's Deed (if the deed dropped for you)
    .target Farmer Furlbrow
    .goto 1436/0,919.47,-9853.13
    .accept 151 >> Accept Poor Old Blanchy
    .accept 36 >> Accept Westfall Stew
    .target Verna Furlbrow

step
    .goto 1436/0,1055.27,-10128.70
    >>At the Saldean farm, talk to Farmer Saldean
    .accept 9 >> Accept The Killing Fields
    .target Farmer Saldean

step
    .goto 1436/0,1042.11,-10112.11
    >>And Salma inside
    .turnin 36 >> Turn in Westfall Stew
    .accept 38 >> Accept Westfall Stew
    .accept 22 >> Accept Goretusk Liver Pie
    .target Salma Saldean

step
    #optional
    .goto 1436/0,1045.22,-10508.80
    .xp 10 >> Below level 10? Kill Harvest Watchers and Defias along the road to Sentinel Hill until it dings

step
    .goto 1436/0,1045.22,-10508.80
    >>At Sentinel Hill, talk to Gryan Stoutmantle (skip Captain Danuvin's Patrolling Westfall -- the route never hunts its gnolls)
    .turnin 109 >> Turn in Report to Gryan Stoutmantle
    .accept 12 >> Accept The People's Militia
    .target Gryan Stoutmantle

step
    .goto 1436/0,1021.60,-10500.61
    >>Talk to Quartermaster Lewis
    .accept 6181 >> Accept A Swift Message
    .target Quartermaster Lewis

step
    .goto 1436/0,1037.42,-10628.27
    >>Talk to Thor the gryphon master
    .turnin 6181 >> Turn in A Swift Message
    .accept 6281 >> Accept Continue To Stormwind
    .target Thor

step
    .goto 1436/0,1037.42,-10628.27
    .fly Stormwind >> Fly to Stormwind

step
    .goto 1453/0,625.48,-8857.76
    >>In the Trade District, talk to Morgan Pestle
    >>Take the Explosive Rockets reward -- great for splitting mob packs
    .turnin 61 >> Turn in Shipment to Stormwind
    .target Morgan Pestle

step << Warlock
    .goto 1453/0,1029.98,-8971.01
    >>WARLOCK: Train at your class trainer
    .train 705
    .target Ursula Deline
    .xp <12,1
    .xp >14,1

step << Warlock
    #optional
    .goto 1453/0,1029.98,-8971.01
    >>WARLOCK: Train at your class trainer
    .train 689
    .target Ursula Deline
    .xp <14,1

step << Warlock
    .goto 1453/0,1041.54,-8983.29
    >>WARLOCK: Hand in Gakin's Summons at Gakin the Darkbinder
    .turnin 1685 >> Turn in Gakin's Summons
    .target Gakin the Darkbinder

step << Warlock
    .goto 1429/0,74.02,-9465.52
    >>WARLOCK: Travel to Elwynn Forest
    .zone Elwynn Forest

step << Warlock
    .goto 1429/0,74.02,-9465.52
    >>WARLOCK: Hand in WANTED: "Hogger", The Collector at Marshal Dughan
    .turnin 176 >> Turn in WANTED: "Hogger"
    .turnin 123 >> Turn in The Collector
    .target Marshal Dughan
    .isOnQuest 123

step << Warlock
    .goto 1429/0,74.02,-9465.52
    >>WARLOCK: Hand in WANTED: "Hogger" at Marshal Dughan
    .turnin 176 >> Turn in WANTED: "Hogger"
    .target Marshal Dughan

step << Warrior
    .goto 1453/0,613.00,-8796.03
    >>Talk to Woo Ping in the Trade District weapon shop
    .trainer >> Train Two-Handed Swords
    .target Woo Ping
    .money <0.3

step
    .goto 1453/0,673.58,-8867.76
    >>Talk to Innkeeper Allison on the way
    .home >> Set your Hearthstone to Stormwind
    .target Innkeeper Allison

step
    .goto 1453/0,382.02,-8702.29
    >>In Old Town, talk to Osric Strang at the armor shop
    .turnin 6281 >> Turn in Continue To Stormwind
    .accept 6261 >> Accept Dungar Longdrink
    .target Osric Strang

step << Warrior
    .goto 1453/0,382.86,-8612.69
    >>Talk to Harry Burlguard in the Pig and Whistle tavern
    .turnin 1638 >> Turn in A Warrior's Training
    .accept 1639 >> Accept Bartleby the Drunk
    .target Harry Burlguard

step << Warrior
    .goto 1453/0,389.07,-8604.43
    >>Talk to Bartleby
    .turnin -1639 >> Turn in Bartleby the Drunk
    .accept 1640 >> Accept Beat Bartleby
    .target Bartleby

step << Warrior
    .goto 1453/0,389.07,-8604.43
    >>Attack Bartleby -- he gives up at 1% health. This chain unlocks Defensive Stance
    .complete -1640,1 --Beat Bartleby
    .mob Bartleby

step << Warrior
    .goto 1453/0,389.07,-8604.43
    >>Talk to Bartleby again
    .turnin -1640 >> Turn in Beat Bartleby
    .accept 1665,2,1640 >> Accept Bartleby's Mug
    .target Bartleby

step << Warrior
    .goto 1453/0,382.86,-8612.69
    >>And back to Harry Burlguard for the shield
    >>Put Sunder Armor on your bars and use it on cooldown -- it beats spamming Heroic Strike
    .turnin -1665 >> Turn in Bartleby's Mug
    .target Harry Burlguard

step << Priest
    .goto 1453/0,862.89,-8519.61
    >>PRIEST: Hand in Divine Grace at High Priestess Laurena; train at your class trainer
    .turnin -94774 >> Turn in Divine Grace
    .trainer >> Train at your class trainer
    .target High Priestess Laurena

step
    .goto 1453/0,685.22,-8387.23
    >>In the Dwarven District, talk to Grimand Elmore
    .turnin 1097 >> Turn in Elmore's Task
    .accept 353 >> Accept Stormpike's Delivery
    .target Grimand Elmore

step << Warrior
    #optional
    .goto 1453/0,624.15,-8431.23
    >>Doing the sharpening-stone routine? Buy a Mining Pick from Kaita Deepforge here
    .collect 2901,1 --Mining Pick
    .disablecheckbox
    .target Kaita Deepforge

step
    .goto 1453/0,522.00,-8352.10
    >>Enter the Deeprun Tram and ride it to Ironforge
    .zone Ironforge >> Take the Tram to Ironforge

step
    #optional
    >>On the Ironforge platform mid-ride area, Monty offers a quick rat-catching quest -- use the flute he gives you on 5 Deeprun Rats while you wait, then turn it in
    .accept 6661 >> Accept Deeprun Rat Roundup
    .complete 6661,1 --Rats captured (5)
    .turnin 6661 >> Turn in Deeprun Rat Roundup
    .target Monty

step << Warrior
    .goto 1455/0,-1234.65,-5035.67
    >>In Ironforge's Military Ward, train with Bilban Tosslespanner (keep ~20s for weapons)
    .trainer >> Train your class abilities
    .target Bilban Tosslespanner

step << Warrior
    .goto 1455/0,-1205.65,-5042.12
    >>In Timberline Arms next door, train Thrown with Bixi Wobblebonk and Two-Handed Maces with Buliwyf Stonehand
    .train 2567 >> Train Thrown
    .target Bixi Wobblebonk
    .goto 1455/0,-1197.27,-5041.49
    .train 199 >> Train Two-Handed Maces
    .target Buliwyf Stonehand

step << Warrior
    #optional
    .goto 1455/0,-1206.74,-5037.12
    >>Downstairs, buy Keen Throwing Knives from Brenwyn Wintersteel -- a ranged pull makes warrior leveling far smoother
    .collect 3107,1 --Keen Throwing Knives
    .disablecheckbox
    .target Brenwyn Wintersteel

step
    .goto 1455/0,-1152.40,-4821.13
    >>Grab the Ironforge flight path from Gryth Thurden in the Great Forge
    .fp Ironforge >> Get the Ironforge flight path
    .target Gryth Thurden

step
    #optional
    .goto 1455/0,-901.76,-4948.06
    >>OPTIONAL auction house stop: buy 3x Boar Intestines, 3x Bear Meat, and 3x Spider Ichor if cheap
    >>They pre-complete a Loch Modan cooking quest (Stocking Jetsteam) you'll hit next
    .collect 3172,3,418,1 --Boar Intestines (3)
    .collect 3173,3,418,1 --Bear Meat (3)
    .collect 3174,3,418,1 --Spider Ichor (3)

step
    .goto 1426/0,-831.31,-5026.91
    .zone Dun Morogh >> Leave Ironforge through the front gate into Dun Morogh

step
    .goto 1426/0,-682.30,-5489.00
    >>At Steelgrill's Depot below the gate, talk to Beldin Steelgrill
    .accept 96408 >> Accept A Visitor to Dun Morogh
    .target Beldin Steelgrill

step
    .goto 1426/0,-1304.71,-5513.86
    >>Head east to the Amberstill Ranch and talk to Rudra Amberstill
    .accept 314 >> Accept Protecting the Herd
    .target Rudra Amberstill

step
    .goto 1426/0,-1277.91,-5393.82
    >>Vagash is an ELITE on the hill behind the ranch
    >>Safest solo plan: damage him to just over half, then kite him down to the ranch guard and let the guard finish -- you keep credit if you did 51%+ of the damage. Loot the fang
    .complete 314,1 --Fang of Vagash
    .mob Vagash

step
    .goto 1426/0,-1304.71,-5513.86
    >>Back to Rudra
    .turnin 314 >> Turn in Protecting the Herd
    .target Rudra Amberstill

step
    .goto 1426/0,-1394.24,-5797.83
    >>South at Gol'Bolar Quarry, talk to Earthseer Farsen
    .turnin 96408 >> Turn in A Visitor to Dun Morogh
    .accept 96392 >> Accept Farsen's Watch
    .target Earthseer Farsen

step
    .goto 1426/0,-1394.24,-5797.83
    >>Talk to Farsen again and view his Farsight; press Escape once the objective completes
    .complete 96392,1 --Use Farsen's Farsight
    .target Earthseer Farsen

step
    .goto 1426/0,-1394.24,-5797.83
    >>And once more
    .turnin 96392 >> Turn in Farsen's Watch
    .accept 96390 >> Accept Nip 'Em in the Bud
    .target Earthseer Farsen

step
    .goto 1426/0,-1579.96,-5714.73
    >>Down in the quarry, talk to Senator Mehr Stonehallow and Foreman Stonebrow
    .accept 433 >> Accept The Public Servant
    .target Senator Mehr Stonehallow
    .goto 1426/0,-1600.30,-5726.59
    .accept 432 >> Accept Those Blasted Troggs!
    .target Foreman Stonebrow

step << Warrior
    #optional
    .goto 1426/0,-1612.12,-5697.89
    >>Train Mining with Dank Drizzlecut here if you took Blacksmithing -- smelt and craft Rough Sharpening Stones as you go
    .train 2575 >> Train Mining
    .target Dank Drizzlecut

step
    #optional
    .goto 1426/0,-1565.58,-5666.24
    >>Haven't trained Cooking yet? Cook Ghilm can fix that
    .train 2550 >> Train Cooking
    .target Cook Ghilm

step
    .goto 1426/0,-1679.89,-5728.88
    >>In the quarry cave, kill 6 Rockjaw Skullthumpers and 10 Rockjaw Bonesnappers
    >>If an Empty Powder Keg drops, use it to start a quest (low drop rate -- don't farm for it)
    .complete 432,1 --Rockjaw Skullthumper (6)
    .complete 433,1 --Rockjaw Bonesnapper (10)
    .use 268548
    .collect 268548,1,95213,1 --Empty Powder Keg
    .accept 95213 >> Accept Stolen Blasting Powder
    .mob Rockjaw Skullthumper
    .mob Rockjaw Bonesnapper

step
    .goto 1426/0,-1600.30,-5726.59
    >>Turn in at the quarry rim
    .turnin 432 >> Turn in Those Blasted Troggs!
    .target Foreman Stonebrow
    .goto 1426/0,-1579.96,-5714.73
    .turnin 433 >> Turn in The Public Servant
    .target Senator Mehr Stonehallow

step
    #optional
    .isOnQuest 95213
    .goto 1426/0,-1606.02,-5676.35
    >>Got the keg? Talk to Quarrymaster Thesten
    .turnin 95213 >> Turn in Stolen Blasting Powder
    .accept 95214 >> Accept Stolen Blasting Powder
    .target Quarrymaster Thesten

step
    #optional
    .isOnQuest 95214
    .goto 1426/0,-1724.22,-5636.95
    >>Kill Rockjaw Ambushers east of the quarry for 16 Stolen Blasting Powder
    .complete 95214,1 --Stolen Blasting Powder (16)
    .mob Rockjaw Ambusher

step
    .goto 1426/0,-2034.49,-5922.60
    >>Southeast of the quarry: kill 10 Dark Iron Spies
    >>One drops a Dark Iron Map -- use it to start a quest
    .complete 96390,1 --Dark Iron Spy (10)
    .use 274268
    .collect 274268,1,96391,1 --Dark Iron Map
    .accept 96391 >> Accept Underground Map
    .mob Dark Iron Spy

step
    #optional
    .isQuestComplete 95214
    .goto 1426/0,-1606.02,-5676.35
    >>Hand the powder to Quarrymaster Thesten
    .turnin 95214 >> Turn in Stolen Blasting Powder
    .target Quarrymaster Thesten

step
    .goto 1426/0,-1394.24,-5797.83
    >>Back to Earthseer Farsen
    .turnin 96390 >> Turn in Nip 'Em in the Bud
    .turnin 96391 >> Turn in Underground Map
    .target Earthseer Farsen

step
    #optional
    .goto 1426/0,-1394.24,-5797.83
    >>OPTIONAL: his follow-up, Old Ironforge Incursion, is the Hall of Thanes DUNGEON (5 players, levels 13-18, beneath Ironforge's High Seat). Take it only if you'll run it with a group -- King Magni pays it, and the guide offers the turn-in when it passes Ironforge
    .accept 96393 >> Accept Old Ironforge Incursion
    .target Earthseer Farsen

step
    .goto 1426/0,-2329.60,-5163.76
    >>Head east along the road: talk to Pilot Hammerfoot at the North Gate Outpost
    .accept 419 >> Accept The Lost Pilot
    .target Pilot Hammerfoot

step
    .goto 1426/0,-2121.76,-5064.70
    >>Find the frozen dwarf corpse on the hill to the north
    .turnin 419 >> Turn in The Lost Pilot
    .accept 417 >> Accept A Pilot's Revenge

step
    .goto 1426/0,-2087.19,-5096.51
    >>Kill Mangeclaw, the big bear nearby, and loot his claw
    .complete 417,1 --Mangy Claw
    .mob Mangeclaw

step
    .goto 1426/0,-2329.60,-5163.76
    >>Back to Pilot Hammerfoot
    .turnin 417 >> Turn in A Pilot's Revenge
    .target Pilot Hammerfoot

step
    .goto 1426/0,-2354.62,-4898.20,25
    .zone Loch Modan >> Go through the North Gate tunnel into Loch Modan

step
    +Chunk complete -- you should be level 11-12. The custom "11-13 Loch Modan (Warrior)" guide picks up from this exact spot and should auto-load next. Good hunting!
]])
