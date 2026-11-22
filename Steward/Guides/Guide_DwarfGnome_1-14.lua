-- =====================================================================
--  Custom WoW: Forever guide -- Dwarf/Gnome start, 1-14 (Warrior-optimized)
--  Chunks: 1-5 Coldridge Valley > 5-11 Dun Morogh > 11-12 Elwynn >
--          12-14 Loch Modan, chaining into "13-15 Westfall (Warrior)".
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Horde" then return end

-- ==================== 1-5 COLDRIDGE VALLEY ===========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 1-5 Coldridge Valley (Dwarf/Gnome)
#next 5-11 Dun Morogh (Dwarf/Gnome)
<< Alliance

step
    #completewith next
    +Dwarf/Gnome starter, warrior-optimized. If you didn't start in Coldridge Valley, walk here first

step
    .goto 1426/0,328.18,-6214.85
    >>Talk to Sten Stoutarm
    .accept 179 >> Accept Dwarven Outfitters
    .target Sten Stoutarm

step << Warlock
    .goto 1426/0,391.07,-6048.84--c:Dun Morogh,28.650,66.145
    >>WARLOCK: Train at your class trainer; take Beginnings at Alamar Grimm
    .train 348
    .accept 1599 >> Accept Beginnings
    .target Alamar Grimm

step << Warrior
    .goto 1426/0,411.31,-6231.46,50,0
    >>Kill Ragged Young Wolves until their trash is worth ~10 copper (your Recruit's shirt/pants/boots sell too)
    >>Battle Shout at level 1 is worth the detour
    .goto 1426/0,384.08,-6104.40
    >>Sell to Grundel Harkin inside Anvilmar
    .vendor >> Vendor trash
    .target Grundel Harkin
    .goto 1426/0,382.16,-6084.73
    >>Then train with Thran Khorman
    .train 6673 >> Train Battle Shout
    .target Thran Khorman
    .mob Ragged Young Wolf

step
    .goto 1426/0,395.65,-6257.07
    >>Kill Ragged Young Wolves for 8 Tough Wolf Meat
    .complete 179,1 --Tough Wolf Meat (8)
    .mob Ragged Young Wolf

step
    .goto 1426/0,328.18,-6214.85
    >>Back to Sten
    .turnin 179 >> Turn in Dwarven Outfitters
    .accept 233 >> Accept Coldridge Valley Mail Delivery
    .target Sten Stoutarm

step << Dwarf Hunter
    .goto 1426/0,328.18,-6214.85
    >>HUNTER: Take Etched Rune at Sten Stoutarm
    .accept 3108 >> Accept Etched Rune
    .target Sten Stoutarm

step << Dwarf Paladin
    .goto 1426/0,328.18,-6214.85
    >>PALADIN: Take Consecrated Rune at Sten Stoutarm
    .accept 3107 >> Accept Consecrated Rune
    .target Sten Stoutarm

step << Dwarf Priest
    .goto 1426/0,328.18,-6214.85
    >>PRIEST: Take Hallowed Rune at Sten Stoutarm
    .accept 3110 >> Accept Hallowed Rune
    .target Sten Stoutarm

step << Dwarf Rogue
    .goto 1426/0,328.18,-6214.85
    >>ROGUE: Take Encrypted Rune at Sten Stoutarm
    .accept 3109 >> Accept Encrypted Rune
    .target Sten Stoutarm

step << Dwarf Shaman
    .goto 1426/0,328.18,-6214.85
    >>SHAMAN: Take Archaic Rune at Sten Stoutarm
    .accept 98581 >> Accept Archaic Rune
    .target Sten Stoutarm

step << Dwarf Warrior
    .goto 1426/0,328.18,-6214.85
    >>WARRIOR: Take Simple Rune at Sten Stoutarm
    .accept 3106 >> Accept Simple Rune
    .target Sten Stoutarm

step << Gnome Mage
    .goto 1426/0,328.18,-6214.85
    >>MAGE: Take Glyphic Memorandum at Sten Stoutarm
    .accept 3114 >> Accept Glyphic Memorandum
    .target Sten Stoutarm

step << Gnome Priest
    .goto 1426/0,328.18,-6214.85
    >>PRIEST: Take Hallowed Memorandum at Sten Stoutarm
    .accept 98574 >> Accept Hallowed Memorandum
    .target Sten Stoutarm

step << Gnome Rogue
    .goto 1426/0,328.18,-6214.85
    >>ROGUE: Take Encrypted Memorandum at Sten Stoutarm
    .accept 3113 >> Accept Encrypted Memorandum
    .target Sten Stoutarm

step << Gnome Warlock
    .goto 1426/0,328.18,-6214.85
    >>WARLOCK: Take Tainted Memorandum at Sten Stoutarm
    .accept 3115 >> Accept Tainted Memorandum
    .target Sten Stoutarm

step << Gnome Warrior
    .goto 1426/0,328.18,-6214.85
    >>WARRIOR: Take Simple Memorandum at Sten Stoutarm
    .accept 3112 >> Accept Simple Memorandum
    .target Sten Stoutarm

step
    .goto 1426/0,688.98,-6222.47
    >>Talk to Talin Keeneye at the eastern camp
    .turnin 233 >> Turn in Coldridge Valley Mail Delivery
    .accept 183 >> Accept The Boar Hunter
    .accept 234 >> Accept Coldridge Valley Mail Delivery
    .target Talin Keeneye

step
    .goto 1426/0,602.45,-6260.49
    >>Kill 12 Small Crag Boars around the camp
    .complete 183,1 --Small Crag Boar (12)
    .mob Small Crag Boar

step
    .goto 1426/0,688.98,-6222.47
    >>Talin again
    .turnin 183 >> Turn in The Boar Hunter
    .target Talin Keeneye

step
    .goto 1426/0,567.04,-6362.93
    >>Deliver the second letter to Grelin Whitebeard, south across the valley
    .turnin 234 >> Turn in Coldridge Valley Mail Delivery
    .accept 182 >> Accept The Troll Cave
    .target Grelin Whitebeard

step << Warlock
    .goto 1426/0,388.81,-6607.11,0--c:1426,28.696,83.148
    >>WARLOCK: Objective: Feather Charm -- Frostmane Novice
    .goto 1426/0,313.95,-6512.09,0--c:1426,30.216,80.254
    .goto 1426/0,388.81,-6607.11,40,0--c:1426,28.696,83.148
    .goto 1426/0,373.88,-6585.96,40,0--c:1426,28.999,82.504
    .goto 1426/0,359.16,-6555.59,15,0--c:1426,29.298,81.579
    .goto 1426/0,371.81,-6542.10,40,0--c:1426,29.041,81.168
    .goto 1426/0,321.87,-6582.06,40,0--c:1426,30.055,82.385
    .goto 1426/0,305.82,-6528.90,40,0--c:1426,30.381,80.766
    .goto 1426/0,313.95,-6512.09,40,0--c:1426,30.216,80.254
    .complete 1599,1 --Collect Feather Charm (x3)
    .mob Frostmane Novice

step << Warlock
    >>WARLOCK: Hearth
    .hs
    .subzoneskip 77,1

step << Warlock
    .goto 1426/0,391.07,-6048.84--c:Dun Morogh,28.650,66.145
    >>WARLOCK: Hand in Beginnings, Tainted Memorandum at Alamar Grimm
    .turnin 1599 >> Turn in Beginnings
    .turnin -3115 >> Turn in Tainted Memorandum
    .target Alamar Grimm

step
    .goto 1426/0,784.04,-6367.10
    >>Kill 14 Frostmane Troll Whelps east of the camp
    .complete 182,1 --Frostmane Troll Whelp (14)
    .mob Frostmane Troll Whelp

step
    .goto 1426/0,567.09,-6362.99
    >>Grelin
    .turnin 182 >> Turn in The Troll Cave
    .accept 218 >> Accept The Stolen Journal
    .target Grelin Whitebeard

step
    #optional
    .goto 1426/0,571.82,-6371.20
    >>Nori Pridedrift's brew run is a 5-MINUTE TIMER into Anvilmar -- take it only if you're heading straight through the cave without dawdling (you can re-take it if it fails)
    .accept 3364 >> Accept Scalding Mornbrew Delivery
    .target Nori Pridedrift

step
    .goto 1426/0,300.50,-6509.17
    >>Into the Frostmane cave: kill Grik'nir the Cold at the back and loot the journal
    .complete 218,1 --Grelin Whitebeard's Journal
    .mob Grik'nir the Cold

step
    #optional
    .isOnQuest 3364
    .goto 1426/0,385.21,-6056.46
    >>Hustle to Durnan Furcutter in Anvilmar before the brew cools
    .turnin 3364 >> Turn in Scalding Mornbrew Delivery
    .accept 3365 >> Accept Bring Back the Mug
    .target Durnan Furcutter

step << Hunter
    .goto 1426/0,365.21,-6091.86
    >>HUNTER: Hand in Etched Rune at Thorgas Grimson; train at your class trainer
    .target Thorgas Grimson
    .turnin 3108 >> Turn in Etched Rune << Dwarf
    .train 1978

step << Warlock
    .goto 1426/0,391.07,-6048.84--c:Dun Morogh,28.650,66.145
    >>WARLOCK: Hand in Tainted Memorandum at Alamar Grimm; train at your class trainer
    .turnin 3115 >> Turn in Tainted Memorandum
    .train 172
    .target Alamar Grimm

step << Shaman
    .goto 1426/0,384.000,-6050.200
    >>SHAMAN: Hand in Archaic Rune; take Call of Earth at Teo Hammerstorm; train at your class trainer
    .target Teo Hammerstorm::257446
    .turnin 98581 >> Turn in Archaic Rune
    .accept 94373 >> Accept Call of Earth
    .train 8042

step << Mage
    .goto 1426/0,388.17,-6056.10
    >>MAGE: Hand in Glyphic Memorandum at Marryk Nurribit; train at your class trainer
    .turnin 3114 >> Turn in Glyphic Memorandum << Gnome
    .train 1459
    .train 116
    .target Marryk Nurribit

step << Rogue
    .goto 1426/0,404.91,-6093.76
    >>ROGUE: Hand in Encrypted Memorandum, Encrypted Rune at Solm Hargrin; train at your class trainer
    .turnin 3113 >> Turn in Encrypted Memorandum << Gnome
    .turnin 3109 >> Turn in Encrypted Rune << Dwarf
    .train 1784
    .target Solm Hargrin

step << Priest
    .goto 1426/0,393.53,-6056.72--c:Dun Morogh,28.600,66.385
    >>PRIEST: Hand in Hallowed Rune, Hallowed Memorandum at Branstock Khalder; train at your class trainer
    .turnin 3110 >> Turn in Hallowed Rune << Dwarf
    .turnin 98574 >> Turn in Hallowed Memorandum << Gnome
    .trainer >> Train at your class trainer
    .target Branstock Khalder

step << Warrior
    .goto 1426/0,382.11,-6084.86
    >>WARRIOR: Hand in Simple Rune, Simple Memorandum at Thran Khorman; train at your class trainer
    .turnin 3106 >> Turn in Simple Rune << Dwarf
    .turnin 3112 >> Turn in Simple Memorandum << Gnome
    .train 100
    .train 772
    .target Thran Khorman

step << Shaman
    .goto 1426/0,384.000,-6050.200
    >>SHAMAN: Hand in Call of Earth; take Call of Earth at Teo Hammerstorm
    .target Teo Hammerstorm::257446
    .turnin 94373 >> Turn in Call of Earth
    .accept 94374 >> Accept Call of Earth

step << Warrior
    .goto 1426/0,382.11,-6084.86
    >>Level 4 training with Thran Khorman
    .train 100 >> Train Charge
    .train 772 >> Train Rend
    .target Thran Khorman

step
    .goto 1426/0,390.00,-6093.80
    >>Grund Drokda in Anvilmar
    .accept 97277 >> Accept Grund and Gozwin
    .target Grund Drokda

step << Paladin
    .goto 1426/0,382.06,-6120.65
    >>PALADIN: Hand in Consecrated Rune at Bromos Grummner; train at your class trainer
    .turnin 3107 >> Turn in Consecrated Rune << Dwarf
    .train 19740
    .train 20271
    .target Bromos Grummner

step << Shaman
    >>SHAMAN: Use the quest item
    .isOnQuest 94374
    .goto 1426/0,582.100,-5907.800
    .cast 8202
    .use 6635

step << Shaman
    .goto 1426/0,576.500,-5908.100
    >>SHAMAN: Hand in Call of Earth; take Call of Earth at Minor Manifestation of Earth
    .target Minor Manifestation of Earth::5891
    .turnin 94374 >> Turn in Call of Earth
    .accept 94375 >> Accept Call of Earth

step << Shaman
    .goto 1426/0,383.900,-6050.300
    >>SHAMAN: Hand in Call of Earth at Teo Hammerstorm
    .target Teo Hammerstorm::257446
    .turnin 94375 >> Turn in Call of Earth

step
    .goto 1426/0,447.80,-5942.00
    >>Up in the northern hills: kill the Snow Leopard Prowler and grab Gozwin's Mechanic's Log from the ground
    .complete 97277,2 --Snow Leopard Prowler
    .mob Snow Leopard Prowler
    .goto 1426/0,458.70,-5940.60
    .complete 97277,1 --Gozwin's Mechanic's Log

step
    .goto 1426/0,567.14,-6363.06
    >>Back to Grelin with the journal
    .turnin 218 >> Turn in The Stolen Journal
    .accept 282 >> Accept Senir's Observations
    .target Grelin Whitebeard

step
    #optional
    .isOnQuest 3365
    .goto 1426/0,571.82,-6371.20
    >>Return Durnan's mug to Nori
    .turnin 3365 >> Turn in Bring Back the Mug
    .target Nori Pridedrift

step << Shaman
    #loop
    .goto 1426/0,528.43,-6444.55,0--c:1426,25.861,78.197
    >>SHAMAN: Objective: Iceclaw Bear Pendant -- Frostmane Troll Whelp
    .goto 1426/0,634.07,-6512.19,0--c:1426,23.716,80.257
    .goto 1426/0,784.04,-6367.10,0--c:1426,20.671,75.838
    .goto 1426/0,528.43,-6444.55,45,0--c:1426,25.861,78.197
    .goto 1426/0,502.77,-6451.51,45,0--c:1426,26.382,78.409
    .goto 1426/0,520.06,-6498.96,45,0--c:1426,26.031,79.854
    .goto 1426/0,634.07,-6512.19,45,0--c:1426,23.716,80.257
    .goto 1426/0,677.41,-6502.50,45,0--c:1426,22.836,79.962
    .goto 1426/0,684.90,-6467.24,45,0--c:1426,22.684,78.888
    .goto 1426/0,766.41,-6387.49,45,0--c:1426,21.029,76.459
    .goto 1426/0,784.04,-6367.10,45,0--c:1426,20.671,75.838
    .complete 94373,1 --Iceclaw Bear Pendant (2)
    .mob Frostmane Troll Whelp

step
    .goto 1426/0,390.00,-6093.80
    >>Grund Drokda
    .turnin 97277 >> Turn in Grund and Gozwin
    .target Grund Drokda

step
    .goto 1426/0,152.90,-6235.80
    >>Mountaineer Thalos guards the valley exit
    .turnin 282 >> Turn in Senir's Observations
    .accept 420 >> Accept Senir's Observations
    .accept 96628 >> Accept The Adventurer
    .target Mountaineer Thalos

step
    .goto 1426/0,135.10,-6248.90
    >>Hands Springsprocket beside him
    .accept 2160 >> Accept Supplies to Tannok
    .target Hands Springsprocket

step
    .goto 1426/0,46.32,-6037.19,15
    >>Head out through Coldridge Pass toward Kharanos
]])

-- ====================== 5-11 DUN MOROGH ==============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 5-11 Dun Morogh (Dwarf/Gnome)
#next 11-12 Elwynn (Dwarf/Gnome)
<< Alliance

step
    #sticky
    #label BoarParts
    >>Crag Boars on the way drop Chunks of Boar Meat (keep 4) and Crag Boar Ribs (keep 6) -- two Kharanos quests want them
    .collect 769,4,317,1 --Chunk of Boar Meat (4)
    .collect 2886,6,384,1 --Crag Boar Rib (6)
    .mob Crag Boar

step
    .goto 1426/0,-498.40,-5648.40
    >>At the camp outside Kharanos, talk to Eric Brighthammer
    .turnin 96628 >> Turn in The Adventurer
    .accept 96608 >> Accept The Great Outdoors
    .target Eric Brighthammer

step
    .goto 1426/0,-498.40,-5648.40
    >>Type /sit at his campfire and stay seated a minute for the boosted rest buff
    .complete 96608,1 --Sit at the campfire
    .complete 96608,2 --Gain the boosted rest buff

step
    .goto 1426/0,-498.40,-5648.40
    >>Eric again
    .turnin 96608 >> Turn in The Great Outdoors
    .accept 96629 >> Accept Camping 101: Cooking
    .target Eric Brighthammer

step
    .goto 1426/0,-501.40,-5643.90
    >>Senir Whitebeard in Kharanos
    .turnin 420 >> Turn in Senir's Observations
    .accept 98322 >> Accept Secure the Mountain
    .target Senir Whitebeard

step << Priest
    #optional
    .goto 1426/0,393.53,-6056.72
    >>PRIEST: Branstock back in Anvilmar starts In Favor of the Light -- grab it if you missed him
    .accept 5626 >> Accept In Favor of the Light

step << Priest
    .goto Dun Morogh,47.34,52.19
    >>Maxan Anvol in the Kharanos chapel-house
    .turnin -5626 >> Turn in In Favor of the Light
    .target Maxan Anvol

step << Priest
    .goto Dun Morogh,47.34,52.19
    >>Take Garments of the Light at Maxan Anvol
    .accept 5625,2,5626 >> Accept Garments of the Light
    .target Maxan Anvol

step << Priest
    .isOnQuest 5625
    .goto Dun Morogh,45.81,54.57
    >>Mountaineer Dolf on the road south: Lesser Heal (Rank 2), then Power Word: Fortitude
    .complete -5625,1
    .target Mountaineer Dolf

step << Priest
    .isQuestComplete 5625
    .goto Dun Morogh,47.34,52.19
    >>Maxan's robe -- and for later: High Priest Rohan in Ironforge teaches A Lack of Fear at 20
    .turnin -5625 >> Turn in Garments of the Light
    .target Maxan Anvol

step
    .goto 1426/0,-504.05,-5596.27
    >>Ragnar Thunderbrew outside the distillery
    .accept 384 >> Accept Beer Basted Boar Ribs
    .target Ragnar Thunderbrew

step
    .goto 1426/0,-523.35,-5590.82
    >>Tannok inside the distillery
    .turnin 2160,1 >> Turn in Supplies to Tannok << Warrior
    .turnin 2160 >> Turn in Supplies to Tannok << !Warrior
    .target Tannok Frosthammer

step
    .goto 1426/0,-529.60,-5590.60
    >>Maxan Anvol inside
    .accept 99158 >> Accept Dawn in the Mountains
    .target Maxan Anvol

step
    #optional
    .goto 1426/0,-545.80,-5594.50
    >>Gremlock Pilsnor: train Cooking and turn in Camping 101
    .train 2550 >> Train Cooking
    .turnin 96629 >> Turn in Camping 101: Cooking
    .target Gremlock Pilsnor
    .money <0.0100

step << Warrior
    .goto 1426/0,-530.40,-5605.63
    >>Train with Granis Swiftaxe in the distillery
    .trainer >> Train your class abilities
    .target Granis Swiftaxe

step
    .goto 1426/0,-531.23,-5601.59
    >>Make the distillery home
    .home >> Set your Hearthstone to Kharanos
    .target Innkeeper Belm

step
    .goto 1426/0,-464.45,-5573.78
    >>Tharek Blackstone by the smithy
    .accept 400 >> Accept Tools for Steelgrill
    .target Tharek Blackstone

step << Warrior
    #optional
    .goto 1426/0,-431.11,-5582.32
    >>Tognus Flintfire: train Blacksmithing if you're doing the sharpening-stone routine
    .train 2018 >> Train Blacksmithing
    .target Tognus Flintfire

step
    .goto 1426/0,-431.00,-5582.40
    >>Tognus also has a job for you
    .accept 98321 >> Accept Flintfire's Shipment
    .target Tognus Flintfire

step
    .goto 1426/0,-632.15,-5466.54
    >>At Steelgrill's Depot: the two pilots
    .accept 317 >> Accept Stocking Jetsteam
    .target Pilot Bellowfiz
    .goto 1426/0,-641.80,-5473.18
    .accept 313 >> Accept The Grizzled Den
    .target Pilot Stonegear

step
    .goto 1426/0,-682.23,-5488.94
    >>Beldin Steelgrill and Loslor Rudge
    .turnin 400 >> Turn in Tools for Steelgrill
    .target Beldin Steelgrill
    .goto 1426/0,-664.55,-5499.71
    .accept 5541 >> Accept Ammo for Rumbleshot
    .target Loslor Rudge

step << Warrior
    #optional
    .goto 1426/0,-664.55,-5499.71
    >>Doing Blacksmithing? Buy a Mining Pick from Loslor, and train Mining with Yarr Hammerstone downstairs at -660,-5528
    .collect 2901,1 --Mining Pick
    .disablecheckbox
    .target Loslor Rudge

step
    #sticky
    #label Jetsteam
    >>Around the depot: Young Black Bears (2 Thick Bear Fur) and Crag Boars (4 Chunks of Boar Meat + ribs)
    .complete 317,2 --Thick Bear Fur (2)
    .complete 317,1 --Chunk of Boar Meat (4)
    .collect 2886,6,384,1 --Crag Boar Rib (6)
    .mob Young Black Bear
    .mob Crag Boar
    .mob Large Crag Boar

step
    .goto 1426/0,-371.40,-5746.90
    >>Southwest of Kharanos: open the Ammo Crate, and talk to Mountaineer Gretchen beside it
    .complete 5541,1 --Rumbleshot's Ammo
    .turnin 98322 >> Turn in Secure the Mountain
    .accept 98319 >> Accept Secure the Mountain
    .target Mountaineer Gretchen

step
    .goto 1426/0,-312.50,-5506.30
    >>In the Grizzled Den: find Mountaineer Cornelius's corpse (the deeper wendigos hit harder -- don't overpull)
    .complete 98319,1 --Find Mountaineer Cornelius

step
    .goto 1426/0,-275.00,-5623.20
    >>Kill Wendigos for 8 manes and grab Flintfire's Shipments off the cave floor
    .complete 313,1 --Wendigo Mane (8)
    .complete 98321,1 --Flintfire's Shipment (8)
    .mob Wendigo
    .mob Young Wendigo

step
    #optional
    .isOnQuest 317
    .goto 1426/0,-473.76,-5972.83
    >>Still short on Chunk of Boar Meat? Crag Boar -- around here. This step skips itself once you have them
    .collect 769,4,317,1 --Chunk of Boar Meat (4)
    .mob Crag Boar

step
    #optional
    .isOnQuest 317
    .goto 1426/0,-378.21,-5446.84
    >>Still short on Thick Bear Fur? Young Black Bear -- around here. This step skips itself once you have them
    .complete 317,2 --Thick Bear Fur (2)
    .mob Young Black Bear

step
    #optional
    .isOnQuest 317
    .goto 1426/0,-531.38,-5887.47
    >>Still short on Chunk of Boar Meat? Crag Boar / Large Crag Boar -- around here. This step skips itself once you have them
    .complete 317,1 --Chunk of Boar Meat (4)
    .mob Crag Boar
    .mob Large Crag Boar

step
    #optional
    .isOnQuest 384
    .goto 1426/0,-531.38,-5887.47
    >>Still short on Crag Boar Rib? Crag Boar / Large Crag Boar -- around here. This step skips itself once you have them
    .collect 2886,6,384,1 --Crag Boar Rib (6)
    .mob Crag Boar
    .mob Large Crag Boar

step
    #requires Jetsteam
    .goto 1426/0,-641.90,-5471.60
    >>Back at the depot
    .turnin 313 >> Turn in The Grizzled Den
    .target Pilot Stonegear
    .goto 1426/0,-632.10,-5466.40
    .turnin 317 >> Turn in Stocking Jetsteam
    .accept 318 >> Accept Evershine
    .target Pilot Bellowfiz

step
    .goto 1426/0,-429.70,-5582.00
    >>Tognus
    .turnin 98321 >> Turn in Flintfire's Shipment
    .target Tognus Flintfire

step
    .goto 1426/0,-501.50,-5643.90
    >>Senir
    .accept 287 >> Accept Frostmane Hold
    .target Senir Whitebeard

step
    .goto 1426/0,-370.00,-5750.70
    >>Gretchen
    .turnin 98319 >> Turn in Secure the Mountain
    .accept 98323 >> Accept Secure the Mountain
    .target Mountaineer Gretchen

step
    .goto 1426/0,-201.51,-6015.52
    >>Hegnar Rumbleshot, south on the rise
    .turnin 5541 >> Turn in Ammo for Rumbleshot
    .target Hegnar Rumbleshot

step
    .goto 1426/0,99.17,-5572.99
    >>Ride east to Tundra MacGrann at the Amberstill area
    .accept 312 >> Accept Tundra MacGrann's Stolen Stash
    .target Tundra MacGrann

step
    .goto 1426/0,315.23,-5378.42
    >>Northeast to Brewnall Village: the Barleybrews
    .turnin 318 >> Turn in Evershine
    .accept 319 >> Accept A Favor for Evershine
    .accept 315 >> Accept The Perfect Stout
    .target Rejold Barleybrew
    .goto 1426/0,315.42,-5372.02
    .accept 310 >> Accept Bitter Rivals
    .target Marleth Barleybrew

step
    .goto 1426/0,241.30,-5414.90
    >>Around Iceflow Lake: 6 Ice Claw Bears, 8 Elder Crag Boars, 8 Snow Leopards (keep collecting ribs)
    .complete 319,1 --Ice Claw Bear (6)
    .complete 319,2 --Elder Crag Boar (8)
    .complete 319,3 --Snow Leopard (8)
    .collect 2886,6,384,1 --Crag Boar Rib (6)
    .mob Ice Claw Bear
    .mob Elder Crag Boar
    .mob Snow Leopard

step
    .goto 1426/0,315.28,-5378.39
    >>Rejold
    .turnin 319 >> Turn in A Favor for Evershine
    .accept 320 >> Accept Return to Bellowfiz
    .target Rejold Barleybrew

step
    .goto 1426/0,586.49,-5546.20
    >>Frostmane Hold, east: run up the side of the entrance and drop in. Kill 5 Frostmane Headhunters and explore the cave, hugging the left wall
    .complete 287,1 --Frostmane Headhunter (5)
    .complete 287,2 --Explore Frostmane Hold
    .mob Frostmane Headhunter

step
    .goto 1426/0,-501.40,-5643.90
    >>Back to Kharanos: Senir
    .turnin 98323 >> Turn in Secure the Mountain
    .turnin 287 >> Turn in Frostmane Hold
    .target Senir Whitebeard

step
    .goto 1426/0,-531.23,-5601.59
    >>Innkeeper Belm sells two quest items: a Rhapsody Malt (for the ribs quest) and a Thunder Ale
    .complete 384,2 --Rhapsody Malt
    .collect 2686,1,311 --Thunder Ale
    .target Innkeeper Belm

step
    .goto 1426/0,-547.93,-5607.27
    >>Click the Jarven's Thunder Ale Barrel downstairs
    .turnin 310 >> Turn in Bitter Rivals
    .accept 311 >> Accept Return to Marleth

step << Warrior
    .goto 1426/0,-530.40,-5605.63
    >>Granis Swiftaxe while you're inside
    .trainer >> Train your class abilities
    .target Granis Swiftaxe

step
    .goto 1426/0,-504.05,-5596.27
    >>Ragnar, with ribs and malt
    .turnin 384 >> Turn in Beer Basted Boar Ribs
    .target Ragnar Thunderbrew

step
    .goto 1426/0,-241.79,-5059.08
    >>Up Shimmer Ridge: kill Frostmane Seers and open Shimmerweed Baskets for 6 Shimmerweed
    .complete 315,1 --Shimmerweed (6)
    .mob Frostmane Seer

step
    .goto 1426/0,-94.88,-5647.69
    >>MacGrann's Dried Meats sit in the cave Old Icebeard guards -- wait for him to patrol OUT, then dart in and loot the locker
    .complete 312,1 --MacGrann's Dried Meats

step
    .goto 1426/0,99.17,-5572.99
    >>Tundra MacGrann
    .turnin 312 >> Turn in Tundra MacGrann's Stolen Stash
    .target Tundra MacGrann

step
    .goto 1426/0,315.28,-5378.39
    >>Brewnall once more
    .turnin 315 >> Turn in The Perfect Stout
    .accept 413 >> Accept Shimmer Stout
    .target Rejold Barleybrew
    .goto 1426/0,315.42,-5372.02
    .turnin 311 >> Turn in Return to Marleth
    .target Marleth Barleybrew

step << Hunter
    #loop
    .goto 1426/0,462.48,-5288.92,60,0
    >>HUNTER: Objective: Gyromechanic Gear; Restabilization Cog -- Leper Gnome
    .goto 1426/0,580.68,-5167.43,60,0
    .goto 1426/0,541.28,-5302.05,60,0
    .goto 1426/0,605.31,-5321.75,60,0
    .goto 1426/0,551.13,-5367.72,60,0
    .goto 1426/0,570.83,-5305.330,60,0
    .complete 412,2 --Collect Gyromechanic Gear (x8)
    .complete 412,1 --Collect Restabilization Cog (x8)
    .mob Leper Gnome

step
    #optional
    .goto 1426/0,241.30,-5414.90
    .xp 9 >> Shy of level 9? The lake wildlife pays well

step
    .goto 1426/0,-501.40,-5643.90
    >>Senir hands you the zone report
    .accept 291 >> Accept The Reports
    .target Senir Whitebeard

step
    .goto 1426/0,-632.15,-5466.54
    >>Pilot Bellowfiz
    .turnin 320 >> Turn in Return to Bellowfiz
    .target Pilot Bellowfiz

step << Hunter
    .goto 1426/0,-463.66,-5474.00,8,0
    >>HUNTER: Hand in Operation Recombobulation at Razzle Sprysprocket
    .goto 1426/0,-455.83,-5497.90
    .target Razzle Sprysprocket
    .turnin -412 >> Turn in Operation Recombobulation

step
    .goto 1426/0,-682.30,-5489.00
    >>Beldin Steelgrill
    .accept 96408 >> Accept A Visitor to Dun Morogh
    .target Beldin Steelgrill

step << Hunter Dwarf
    .goto 1426/0,-454.06,-5618.53
    >>HUNTER: Grif Wildheart in Kharanos starts your pet training. Tame a Large Crag Boar with his rod, then return
    .accept 6064 >> Accept Taming the Beast
    .complete 6064,1 --Tame a Large Crag Boar
    .turnin 6064 >> Turn in Taming the Beast
    .target Grif Wildheart

step << Hunter Dwarf
    .goto 1426/0,-454.06,-5618.53
    >>Second rod: a Snow Leopard from the eastern hills
    .accept 6084 >> Accept Taming the Beast
    .complete 6084,1 --Tame a Snow Leopard
    .turnin 6084 >> Turn in Taming the Beast
    .target Grif Wildheart

step << Hunter Dwarf
    .goto 1426/0,-454.06,-5618.53
    >>Third rod: an Ice Claw Bear -- then Grif points you to Ironforge
    .accept 6085 >> Accept Taming the Beast
    .complete 6085,1 --Tame an Ice Claw Bear
    .turnin 6085 >> Turn in Taming the Beast
    .accept 6086 >> Accept Training the Beast
    .target Grif Wildheart

step << Hunter Dwarf
    .goto 1455/0,-1273.83,-5022.08
    >>HUNTER: while in Ironforge, Belia Thundergranite in the Military Ward kennels makes your pet permanent -- feed, revive, the works
    .turnin 6086 >> Turn in Training the Beast
    .target Belia Thundergranite

step << Warrior
    .goto 1455/0,-1205.65,-5042.12
    >>Detour into Ironforge (north road): train Thrown with Bixi Wobblebonk in Timberline Arms -- a ranged pull changes everything
    .train 2567 >> Train Thrown
    .target Bixi Wobblebonk

step << Warrior
    .goto 1455/0,-1206.77,-5037.07
    >>Buy Keen Throwing Knives from Brenwyn Wintersteel downstairs, and equip them
    .collect 3107,1 --Keen Throwing Knives
    .disablecheckbox
    .target Brenwyn Wintersteel
    .itemStat 18,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<6.3

step << Warrior
    .goto 1426/0,-831.31,-5026.91
    .zone Dun Morogh >> Leave Ironforge, back into Dun Morogh

step
    .goto 1426/0,-1041.00,-5350.60
    >>Father Gavin on the hill overlooking the lake
    .turnin 99158 >> Turn in Dawn in the Mountains
    .target Father Gavin

step
    .goto 1426/0,-1304.71,-5513.86
    >>Rudra Amberstill at the ranch
    .accept 314 >> Accept Protecting the Herd
    .target Rudra Amberstill

step
    .goto 1426/0,-1277.91,-5393.82
    >>Vagash is an ELITE on the hill behind the ranch
    >>Solo plan: burn him past half, then kite him to the ranch guard and let the guard finish -- 51%+ of the damage keeps your credit. Loot the fang
    .complete 314,1 --Fang of Vagash
    .mob Vagash

step
    .goto 1426/0,-1304.71,-5513.86
    >>Rudra
    .turnin 314 >> Turn in Protecting the Herd
    .target Rudra Amberstill

step
    .goto 1426/0,-1394.24,-5797.83
    >>Gol'Bolar Quarry: Earthseer Farsen
    .turnin 96408 >> Turn in A Visitor to Dun Morogh
    .accept 96392 >> Accept Farsen's Watch
    .target Earthseer Farsen

step
    .goto 1426/0,-1394.24,-5797.83
    >>View Farsen's Farsight, then press Escape once the objective ticks
    .complete 96392,1 --Use Farsen's Farsight
    .target Earthseer Farsen

step
    .goto 1426/0,-1394.24,-5797.83
    >>Farsen
    .turnin 96392 >> Turn in Farsen's Watch
    .accept 96390 >> Accept Nip 'Em in the Bud
    .target Earthseer Farsen

step
    #optional
    .goto 1426/0,-1565.58,-5666.24
    >>Cook Ghilm trains Cooking if you skipped it; Kazan Mogosh next to him sells cheap bread << Warrior
    .train 2550 >> Train Cooking
    .target Cook Ghilm

step
    .goto 1426/0,-1579.96,-5714.73
    >>Down in the quarry
    .accept 433 >> Accept The Public Servant
    .target Senator Mehr Stonehallow
    .goto 1426/0,-1600.30,-5726.59
    .accept 432 >> Accept Those Blasted Troggs!
    .target Foreman Stonebrow

step
    .goto 1426/0,-1594.10,-5825.97
    >>Kill 6 Rockjaw Skullthumpers outside and 10 Bonesnappers inside the quarry mine
    >>If an Empty Powder Keg drops, use it to start a quest (rare -- don't farm for it)
    .complete 432,1 --Rockjaw Skullthumper (6)
    .complete 433,1 --Rockjaw Bonesnapper (10)
    .use 268548
    .collect 268548,1,95213,1 --Empty Powder Keg
    .accept 95213 >> Accept Stolen Blasting Powder
    .mob Rockjaw Skullthumper
    .mob Rockjaw Bonesnapper

step
    .goto 1426/0,-1579.96,-5714.73
    >>Turn in at the rim
    .turnin 433 >> Turn in The Public Servant
    .target Senator Mehr Stonehallow
    .goto 1426/0,-1600.30,-5726.59
    .turnin 432 >> Turn in Those Blasted Troggs!
    .target Foreman Stonebrow

step
    #optional
    .isOnQuest 95213
    .goto 1426/0,-1606.02,-5676.35
    >>Quarrymaster Thesten takes the keg
    .turnin 95213 >> Turn in Stolen Blasting Powder
    .accept 95214 >> Accept Stolen Blasting Powder
    .target Quarrymaster Thesten

step
    #optional
    .isOnQuest 95214
    .goto 1426/0,-1724.22,-5636.95
    >>Rockjaw Ambushers east of the quarry carry 16 Stolen Blasting Powder
    .complete 95214,1 --Stolen Blasting Powder (16)
    .mob Rockjaw Ambusher

step
    .goto 1426/0,-2034.49,-5922.60
    >>Kill 10 Dark Iron Spies in the southeast hills; one drops a Dark Iron Map -- use it
    .complete 96390,1 --Dark Iron Spy (10)
    .use 274268
    .collect 274268,1,96391,1 --Dark Iron Map
    .accept 96391 >> Accept Underground Map
    .mob Dark Iron Spy

step
    #optional
    .isQuestComplete 95214
    .goto 1426/0,-1606.02,-5676.35
    >>Thesten
    .turnin 95214 >> Turn in Stolen Blasting Powder
    .target Quarrymaster Thesten

step
    .goto 1426/0,-1394.24,-5797.83
    >>Farsen
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
    .goto 1426/0,-2447.11,-5479.74
    >>Mountaineer Barleybrew at the South Gate tower
    .turnin 413 >> Turn in Shimmer Stout
    .accept 414 >> Accept Stout to Kadrell
    .target Mountaineer Barleybrew

step
    .goto 1432/0,-2602.54,-5832.73
    >>Through the pass into Loch Modan: Mountaineer Cobbleflint
    .accept 224 >> Accept In Defense of the King's Lands
    .target Mountaineer Cobbleflint

step
    .goto 1432/0,-2634.59,-5842.81
    >>Captain Rugelfuss in the bunker
    .accept 267 >> Accept The Trogg Threat
    .target Captain Rugelfuss

step
    .goto 1432/0,-3007.99,-5337.39
    >>Mountaineer Kadrell patrols Thelsamar's road
    .turnin 414 >> Turn in Stout to Kadrell
    .accept 416 >> Accept Rat Catching
    .accept 1339 >> Accept Mountaineer Stormpike's Task
    .target Mountaineer Kadrell

step
    .goto 1432/0,-2954.42,-5394.10
    >>Vidra Hearthstove in the Stoutlager Inn
    .accept 418 >> Accept Thelsamar Blood Sausages
    .target Vidra Hearthstove

step
    .goto 1432/0,-2973.90,-5377.93
    >>Rehome here -- Thelsamar is base for the next levels
    .home >> Set your Hearthstone to Thelsamar
    .target Innkeeper Hearthstove

step
    .goto 1432/0,-3014.88,-5367.00
    >>Brock Stoneseeker (mining trainer's building)
    .accept 6387 >> Accept Honor Students
    .target Brock Stoneseeker

step
    #sticky
    #label DGSausage
    >>While in the Loch: Mountain Boars (3 Intestines), Elder Black Bears (3 Bear Meat), Forest Lurkers (3 Spider Ichor) -- or buy them at the Ironforge AH shortly
    .collect 3172,3,418,1 --Boar Intestines (3)
    .collect 3173,3,418,1 --Bear Meat (3)
    .collect 3174,3,418,1 --Spider Ichor (3)
    .mob Mountain Boar
    .mob Elder Black Bear
    .mob Forest Lurker

step
    .goto 1432/0,-2676.99,-4825.98
    >>North to Algaz Station: Mountaineer Stormpike in the bunker
    .turnin 1339 >> Turn in Mountaineer Stormpike's Task
    .accept 1338 >> Accept Stormpike's Order
    .accept 307 >> Accept Filthy Paws
    .target Mountaineer Stormpike

step
    .goto 1426/0,-2329.60,-5163.76
    >>Through the North Gate Pass: Pilot Hammerfoot
    .accept 419 >> Accept The Lost Pilot
    .target Pilot Hammerfoot

step
    .goto 1426/0,-2121.76,-5064.70
    >>The frozen corpse on the hill north
    .turnin 419 >> Turn in The Lost Pilot
    .accept 417 >> Accept A Pilot's Revenge

step
    .goto 1426/0,-2087.19,-5096.51
    >>Kill Mangeclaw and take his claw
    .complete 417,1 --Mangy Claw
    .mob Mangeclaw

step
    .goto 1426/0,-2329.60,-5163.76
    >>Hammerfoot
    .turnin 417 >> Turn in A Pilot's Revenge
    .target Pilot Hammerfoot

step << Hunter
    >>HUNTER: Take Operation Recombobulation at Razzle Sprysprocket
    .target Razzle Sprysprocket
    .goto 1426/0,-463.66,-5474.00,10,0
    .goto 1426/0,-455.83,-5497.90
    .accept 412 >> Accept Operation Recombobulation

step
    .hs >> Hearth to Thelsamar

step
    .goto 1432/0,-2929.87,-5424.84
    >>Thorgrum Borrelson: grab the flight path, hand over the letter, and fly to Ironforge
    .fp Thelsamar >> Get the Thelsamar flight path
    .turnin 6387 >> Turn in Honor Students
    .accept 6391 >> Accept Ride to Ironforge
    .fly Ironforge >> Fly to Ironforge
    .target Thorgrum Borrelson

step
    .goto 1455/0,-1120.93,-4708.06
    >>Golnir Bouldertoe in the Deep Mountain Mining building
    .turnin 6391 >> Turn in Ride to Ironforge
    .accept 6388 >> Accept Gryth Thurden
    .target Golnir Bouldertoe

step << Shaman
    .goto 1455/0,-1086.500,-4642.400
    >>SHAMAN: Take Call of Fire at Eldrun Stormbreaker; train at your class trainer
    .target Eldrun Stormbreaker::258098
    .accept 94449 >> Accept Call of Fire
    .trainer >> Train at your class trainer

step
    .goto 1455/0,-1026.28,-4872.56
    >>Senator Barin Redstone outside High Seat
    .turnin 291 >> Turn in The Reports
    .target Senator Barin Redstone

step
    .goto 1455/0,-1152.40,-4821.13
    >>Gryth Thurden at the gryphons (don't fly anywhere)
    .turnin 6388 >> Turn in Gryth Thurden
    .accept 6392 >> Accept Return to Brock
    .target Gryth Thurden

step
    #optional
    .goto 1455/0,-901.76,-4948.06
    >>AH stop: 3x Boar Intestines, 3x Bear Meat, 3x Spider Ichor pre-complete the sausage quest
    .collect 3172,3,418,1 --Boar Intestines (3)
    .collect 3173,3,418,1 --Bear Meat (3)
    .collect 3174,3,418,1 --Spider Ichor (3)

step
    .goto 1455/0,-1330.28,-4840.43
    >>Enter the Deeprun Tram. Monty on the middle platform has a rat problem; catch 5 with his flute during the ride, then take the follow-up to the Stormwind side
    .accept 6661 >> Accept Deeprun Rat Roundup
    .complete 6661,1 --Rats captured (5)
    .use 17117
    .turnin 6661 >> Turn in Deeprun Rat Roundup
    .accept 6662 >> Accept Me Brother, Nipsy
    .target Monty

step
    >>On the Stormwind-side platform
    .turnin 6662 >> Turn in Me Brother, Nipsy
    .target Nipsy

step
    .goto 1453/0,685.22,-8387.23
    >>Grimand Elmore in the Dwarven District
    .accept 353 >> Accept Stormpike's Delivery
    .target Grimand Elmore

step
    .goto 1453/0,600.07,-8427.22
    >>Furen Longbeard
    .turnin 1338 >> Turn in Stormpike's Order
    .target Furen Longbeard

step << Warrior
    .goto 1453/0,325.68,-8688.59
    >>Ilsa Corbin at the Command Center: train, and take the level 10 class quest
    .trainer >> Train your class abilities
    .accept 1638 >> Accept A Warrior's Training
    .target Ilsa Corbin

step << Warrior
    .goto 1453/0,382.86,-8612.69
    >>Harry Burlguard in the Pig and Whistle
    .turnin 1638 >> Turn in A Warrior's Training
    .accept 1639 >> Accept Bartleby the Drunk
    .target Harry Burlguard

step << Warrior
    .goto 1453/0,389.07,-8604.43
    >>Bartleby
    .turnin -1639 >> Turn in Bartleby the Drunk
    .accept 1640 >> Accept Beat Bartleby
    .target Bartleby

step << Warrior
    .goto 1453/0,389.07,-8604.43
    >>Beat him down -- he yields at 1%. This chain unlocks Defensive Stance
    .complete -1640,1 --Beat Bartleby
    .mob Bartleby

step << Warrior
    .goto 1453/0,389.07,-8604.43
    >>Bartleby concedes
    .turnin -1640 >> Turn in Beat Bartleby
    .accept 1665,2,1640 >> Accept Bartleby's Mug
    .target Bartleby

step << Warrior
    .goto 1453/0,382.86,-8612.69
    >>Harry pays out a shield
    .turnin -1665 >> Turn in Bartleby's Mug
    .target Harry Burlguard

step << Warrior
    .goto 1453/0,613.00,-8796.03
    >>Woo Ping in the weapon shop
    .trainer >> Train Two-Handed Swords
    .target Woo Ping
]])

-- ===================== 11-12 ELWYNN (DG) =============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 11-12 Elwynn (Dwarf/Gnome)
#next 12-14 Loch Modan (Dwarf/Gnome)
<< Alliance

step
    .goto 1453/0,484.20,-8832.50
    >>Grab the Stormwind flight path from Dungar Longdrink
    .fp Stormwind >> Get the Stormwind flight path
    .target Dungar Longdrink

step
    .goto 1429/0,72.81,-9496.23
    >>In Goldshire: Remy "Two Times" behind the inn
    .accept 40 >> Accept A Fishy Peril
    .target Remy "Two Times"

step
    .goto 1429/0,73.92,-9465.54
    >>Marshal Dughan
    .turnin 40 >> Turn in A Fishy Peril
    .accept 35 >> Accept Further Concerns
    .target Marshal Dughan

step
    .goto 1429/0,332.43,-9895.01
    >>Ma Stonefield at the farm south
    .accept 88 >> Accept Princess Must Die!
    .target Ma Stonefield

step
    .goto 1429/0,-1032.06,-9610.23
    >>East to the bridge: Guard Thomas
    .turnin 35 >> Turn in Further Concerns
    .accept 37 >> Accept Find the Lost Guards
    .accept 52 >> Accept Protect the Frontier
    .target Guard Thomas

step
    #sticky
    #label DGFrontier
    >>Kill 8 Prowlers and 5 Young Forest Bears through eastern Elwynn
    .complete 52,1 --Prowler (8)
    .complete 52,2 --Young Forest Bear (5)
    .mob Prowler
    .mob Young Forest Bear

step
    .goto 1429/0,-986.35,-9336.06
    >>Click the half-eaten corpse by the pond
    .turnin 37 >> Turn in Find the Lost Guards
    .accept 45 >> Accept Discover Rolf's Fate

step
    .goto 1429/0,-1289.22,-9469.80
    >>Supervisor Raelen at the Eastvale Logging Camp
    .accept 5545 >> Accept A Bundle of Trouble
    .target Supervisor Raelen

step
    .goto 1429/0,-1362.03,-9309.59
    >>8 Bundles of Wood lie at the tree bases
    .complete 5545,1 --Bundle of Wood (8)

step
    .goto 1429/0,-1234.31,-9224.18
    >>Rolf's corpse at the murloc huts -- pull the two front murlocs one at a time; full rage, Hamstring-kite if both come << Warrior
    .turnin 45 >> Turn in Discover Rolf's Fate
    .accept 71 >> Accept Report to Thomas

step
    .goto 1429/0,-1289.22,-9469.80
    >>Raelen
    .turnin 5545 >> Turn in A Bundle of Trouble
    .target Supervisor Raelen

step
    .goto 1429/0,-1119.77,-9603.77
    >>Ormin Pelford south of the bridge
    .accept 91733 >> Accept Downstream
    .target Ormin Pelford

step
    .goto 1429/0,-1043.41,-9707.92
    >>Downriver: the Waterlogged Saw
    .complete 91733,2 --Waterlogged Saw

step
    .goto 1429/0,-1126.71,-9849.11
    >>The Waterlogged Axe
    .complete 91733,1 --Waterlogged Axe

step
    .goto 1429/0,-1147.54,-9948.64
    >>And the Waterlogged Toolbox by Stone Cairn Lake
    .complete 91733,3 --Waterlogged Toolbox

step
    #optional
    .goto 1429/0,-1119.80,-9931.30
    >>Croaky the elite murloc (11): group him or skip; his head starts a quest
    .use 247826
    .collect 247826,1,91740,1 --Croaky's Head
    .accept 91740 >> Accept Croaky's Head
    .mob Croaky

step
    #optional
    .isQuestComplete 91740
    .goto 1429/0,-1406.20,-9775.50
    >>Merell Ross at Ridgepoint Tower
    .turnin 91740 >> Turn in Croaky's Head
    .target Merell Ross

step
    .goto 1429/0,-869.87,-9768.10
    >>Princess at the farm west of the lake: she brings both pig adds and charges
    >>Full rage before the pull; Hamstring the adds; keep a potion ready << Warrior
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
    #requires DGFrontier
    .goto 1429/0,-1032.06,-9610.23
    >>Guard Thomas
    .turnin 52 >> Turn in Protect the Frontier
    .turnin 71 >> Turn in Report to Thomas
    .accept 39 >> Accept Deliver Thomas' Report
    .accept 109 >> Accept Report to Gryan Stoutmantle
    .target Guard Thomas

step
    .goto 1429/0,-1119.77,-9603.77
    >>Pelford
    .turnin 91733 >> Turn in Downstream
    .target Ormin Pelford

step
    .goto 1433/0,-1906.40,-9606.80
    >>Quick Redridge hop: Guard Parker at the tower
    .accept 244 >> Accept Encroaching Gnolls
    .target Guard Parker

step
    .goto 1433/0,-2238.00,-9443.69
    >>Deputy Feldon at the Lakeshire bridge (mind the higher-level mobs on the road)
    .turnin -244 >> Turn in Encroaching Gnolls
    .target Deputy Feldon

step
    .goto 1433/0,-2234.90,-9435.30
    >>Ariena Stormfeather: flight path, then fly out
    .fp Redridge Mountains >> Get the Redridge flight path
    .fly Stormwind >> Fly to Stormwind
    .target Ariena Stormfeather

step
    #optional
    .goto 1453/0,660.28,-8814.55
    >>AH: the Westfall pre-buys -- 3x Stringy Vulture Meat, 3x Murloc Eye, 3x Goretusk Snout, 3x Okra, 8x Goretusk Liver
    .collect 729,3,38,1 --Stringy Vulture Meat (3)
    .collect 730,3,38,1 --Murloc Eye (3)
    .collect 731,3,38,1 --Goretusk Snout (3)
    .collect 732,3,38,1 --Okra (3)
    .collect 723,8,22,1 --Goretusk Liver (8)

step
    .goto 1429/0,74.02,-9465.52
    >>Run to Goldshire: Marshal Dughan
    .turnin 39 >> Turn in Deliver Thomas' Report
    .target Marshal Dughan

step << Warrior
    .goto 1429/0,109.36,-9461.84
    >>Lyria Du Lac if anything's untrained
    .trainer >> Train your class abilities
    .target Lyria Du Lac

step
    .goto 1429/0,332.43,-9895.01
    >>Ma Stonefield takes the collar
    .turnin 88,2 >> Turn in Princess Must Die! << Warrior
    .turnin 88 >> Turn in Princess Must Die! << !Warrior
    .target Ma Stonefield

step
    .goto 1436/0,918.42,-9851.50
    >>Into Westfall: load up the Furlbrows' quests for later
    .accept 64 >> Accept The Forgotten Heirloom
    .target Farmer Furlbrow
    .goto 1436/0,919.47,-9853.13
    .accept 151 >> Accept Poor Old Blanchy
    .accept 36 >> Accept Westfall Stew
    .target Verna Furlbrow

step
    .goto 1436/0,1055.27,-10128.70
    >>Farmer Saldean
    .accept 9 >> Accept The Killing Fields
    .target Farmer Saldean

step
    .goto 1436/0,1042.67,-10111.67
    >>Salma inside
    .turnin 36 >> Turn in Westfall Stew
    .accept 38 >> Accept Westfall Stew
    .accept 22 >> Accept Goretusk Liver Pie
    .target Salma Saldean

step
    .goto 1436/0,1045.12,-10508.80
    >>Sentinel Hill: Gryan Stoutmantle
    .turnin 109 >> Turn in Report to Gryan Stoutmantle
    .accept 12 >> Accept The People's Militia
    .target Gryan Stoutmantle

step
    .goto 1436/0,1126.67,-10636.67
    >>Scout Galiaan
    .accept 153 >> Accept Red Leather Bandanas
    .target Scout Galiaan

step
    .goto 1436/0,1037.42,-10628.27
    >>Thor the gryphon master
    .fp Sentinel Hill >> Get the Sentinel Hill flight path
    .target Thor

step
    .hs >> Hearth to Thelsamar -- Loch Modan finishes next, then you return here at 14
]])

-- =================== 12-14 LOCH MODAN (DG) ===========================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 12-14 Loch Modan (Dwarf/Gnome)
#next 13-15 Westfall (Alliance)
<< Alliance

step
    .goto 1432/0,-3014.88,-5367.00
    >>Brock Stoneseeker in Thelsamar
    .turnin 6392 >> Turn in Return to Brock
    .target Brock Stoneseeker

step
    #optional
    .isQuestComplete 418
    .goto 1432/0,-2954.42,-5394.10
    >>Sausage makings in hand already? Vidra pays now
    .turnin 418 >> Turn in Thelsamar Blood Sausages
    .target Vidra Hearthstove

step
    .goto 1432/0,-3003.30,-5376.02
    >>Grenhild Darktalon
    .accept 86667 >> Accept Snowbound
    .target Grenhild Darktalon

step << Shaman
    .goto 1426/0,-2510.100,-5310.300
    >>SHAMAN: Hand in Call of Fire; take Call of Fire at Bruegs Kindleborn
    .target Bruegs Kindleborn::257597
    .turnin 94449 >> Turn in Call of Fire
    .accept 94465 >> Accept Call of Fire

step << Shaman
    .goto 1432/0,-2880.900,-5701.500
    >>SHAMAN: Hand in Call of Fire; take Call of Fire at Braldir Ashmantle
    .target Braldir Ashmantle::257808
    .turnin 94465 >> Turn in Call of Fire
    .accept 94466 >> Accept Call of Fire

step
    .goto 1432/0,-2534.38,-5648.28
    >>Stand on the snowy patch outside the South Gate tunnel and fill the Ceramic Jar
    >>The jar melts in 10 minutes -- head straight for the turn-in
    .use 279380
    .complete 86667,1 --Jar of Snow

step
    .goto 1432/0,-3146.73,-4837.02
    >>Norric Lochthane on the lochside, before the snow melts
    .turnin 86667 >> Turn in Snowbound
    .target Norric Lochthane

step << Shaman
    #loop
    .goto 1432/0,-3287.400,-4868.000,45,0
    >>SHAMAN: Objective: Reagent Pouch -- Stonesplinter Seer
    .goto 1432/0,-3397.500,-4870.800,45,0
    .goto 1432/0,-3337.300,-4998.400,45,0
    .complete 94466,2 --|1/1 Reagent Pouch
    .mob Stonesplinter Seer

step << Shaman
    >>SHAMAN: Objective: Fire Tar -- Tunnel Rat Geomancer
    .complete 94466,1 -- Fire Tar (1)
    .mob Tunnel Rat Geomancer

step
    #sticky
    #label DGRats
    >>Tunnel Rats around the Silver Stream Mine: 12 ears
    .complete 416,1 --Tunnel Rat Ear (12)
    .mob Tunnel Rat Scout
    .mob Tunnel Rat Vermin
    .mob Tunnel Rat Forager
    .mob Tunnel Rat Digger

step
    .goto 1432/0,-2984.82,-4902.33
    >>Inside the mine: 4 Miners' Gear from the Miners' League Crates
    .complete 307,1 --Miners' Gear (4)

step << Warrior
    #optional
    .goto 1432/0,-3176.16,-4669.34
    >>Nillen Andemar (limited stock): the Heavy Spiked Mace or Ironwood Maul carries you well past 14 -- buy one if you can
    .collect 4778,1,307,1 --Heavy Spiked Mace
    .collect 4777,1,307,1 --Ironwood Maul
    .disablecheckbox
    .target Nillen Andemar
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<11.8

step << Warrior
    #optional
    #completewith DGPaws
    +Equip the mace (Two-Handed Maces trains in Ironforge's Timberline Arms if needed)
    .use 4778
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<12.5

step
    .goto 1432/0,-2972.41,-4796.92
    >>Finish the Tunnel Rat ears
    .complete 416,1 --Tunnel Rat Ear (12)
    .mob Tunnel Rat Forager

step
    #label DGPaws
    .goto 1432/0,-2676.99,-4825.98
    >>Mountaineer Stormpike at Algaz Station
    .turnin 307 >> Turn in Filthy Paws
    .turnin 353 >> Turn in Stormpike's Delivery
    .target Mountaineer Stormpike

step
    .goto 1432/0,-2735.74,-4684.34
    >>Finish the sausage makings: bears here, boars at -3041,-5129, Forest Lurkers at -2873,-4789
    .collect 3172,3,418,1 --Boar Intestines (3)
    .collect 3173,3,418,1 --Bear Meat (3)
    .collect 3174,3,418,1 --Spider Ichor (3)
    .mob Mountain Boar
    .mob Elder Black Bear
    .mob Forest Lurker

step
    .goto 1432/0,-2954.42,-5394.10
    >>Vidra in Thelsamar
    .turnin 418 >> Turn in Thelsamar Blood Sausages
    .target Vidra Hearthstove

step
    .goto 1432/0,-3007.99,-5337.39
    >>Kadrell on the road
    .turnin 416 >> Turn in Rat Catching
    .target Mountaineer Kadrell

step << Shaman
    .goto 1432/0,-2880.900,-5701.500
    >>SHAMAN: Hand in Call of Fire; take Call of Fire at Braldir Ashmantle
    .target Braldir Ashmantle::257808
    .turnin 94466 >> Turn in Call of Fire
    .accept 94467 >> Accept Call of Fire

step << Shaman
    #completewith next
    .goto 1432/0,-2873.800,-5672.500
    >>SHAMAN: Use the quest item
    .cast 8898
    .use 6636

step << Shaman
    .goto 1432/0,-2873.800,-5672.500
    >>SHAMAN: Objective: Glowing Ember
    .complete 94467,1 -- Glowing Ember (1)

step << Shaman
    .goto 1432/0,-2870.700,-5674.600
    >>SHAMAN: Hand in Call of Fire; take Call of Fire at Brazier of the Dormant Flame
    .turnin 94467 >> Turn in Call of Fire
    .accept 94468 >> Accept Call of Fire

step
    .goto 1432/0,-2729.40,-5534.96
    >>Trogg hyperspawn at the excavation edge: 10 Stonesplinter Troggs, 10 Scouts, 8 Stone Teeth
    .complete 224,1 --Stonesplinter Trogg (10)
    .complete 224,2 --Stonesplinter Scout (10)
    .complete 267,1 --Trogg Stone Tooth (8)
    .mob Stonesplinter Trogg
    .mob Stonesplinter Scout

step
    #optional
    .goto 1432/0,-2729.40,-5534.96
    .xp 13 >> The hyperspawn is the best grind spot in the zone -- push to 13 here

step
    .goto 1432/0,-2634.59,-5842.81
    >>Rugelfuss in the bunker
    .turnin 267 >> Turn in The Trogg Threat
    .target Captain Rugelfuss

step
    .goto 1432/0,-2602.54,-5832.73
    >>Cobbleflint outside
    .turnin 224 >> Turn in In Defense of the King's Lands
    .target Mountaineer Cobbleflint

step << Shaman
    .goto 1426/0,-2510.100,-5310.300
    >>SHAMAN: Hand in Call of Fire at Bruegs Kindleborn
    .target Bruegs Kindleborn::257597
    .turnin 94468 >> Turn in Call of Fire

step
    .goto 1432/0,-3386.71,-5462.48
    >>Swim the loch for the Sunken Fishing Toolbox (spawn points vary -- watch the minimap, and steer clear of the big Threshadon)
    .accept 86614 >> Accept Silver of the Waves

step
    .goto 1432/0,-3086.60,-5216.80
    >>Khara Deepwater at the fishing hut
    .turnin 86614 >> Turn in Silver of the Waves
    .target Khara Deepwater



step
    .goto 1432/0,-2929.87,-5424.84
    >>Thorgrum Borrelson
    .fly Ironforge >> Fly to Ironforge
    .target Thorgrum Borrelson

step << Warrior
    .goto 1455/0,-1234.65,-5035.67
    >>Bilban Tosslespanner in the Military Ward
    .trainer >> Train your class abilities
    .target Bilban Tosslespanner

step
    #optional
    .goto 1455/0,-1249.97,-4793.24
    >>Gearcutter Cogspinner in Tinker Town: buy a Bronze Tube if he has one (limited stock; a Duskwood quest wants it later)
    .bronzetube
    .target Gearcutter Cogspinner

step
    .goto 1455/0,-1330.28,-4840.43
    >>Deeprun Tram to Stormwind (level First Aid while you wait)
    .zone Stormwind City >> Take the Tram to Stormwind

step
    .goto 1453/0,719.67,-8550.30
    >>Baros Alexston in Cathedral Square
    .accept 399 >> Accept Humble Beginnings
    .target Baros Alexston

step
    +Chunk complete -- you're ~14. "13-15 Westfall (Warrior)" picks up next (auto-loads): your Westfall quests are already banked, so it flies through. The Human-only Dungar steps in it will skip themselves
]])
