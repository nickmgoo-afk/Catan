-- =====================================================================
--  Custom WoW: Forever guide -- Alliance 11-16 (Warrior-optimized)
--  Chunks: 11-13 Loch Modan > 13-15 Westfall > 14-16 Darkshore
--  Continues from "6-12 Elwynn Forest (Warrior)" at the Loch Modan tunnel.
--  Quest IDs/coords cross-checked against RestedXP's free Forever routes
--  (github.com/RestedXP/RXPGuides) on 2026-11-06. Original text; personal use.
-- =====================================================================

local faction = UnitFactionGroup("player")
if faction == "Horde" then return end

-- ======================= 11-13 LOCH MODAN ============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 11-13 Loch Modan (Alliance)
#next 13-15 Westfall (Alliance)
<< Alliance

step
    #optional
    #completewith next
    .goto 1432/0,-2659.45,-4822.45
    >>Sell and repair with Gothor Brumn at the Algaz checkpoint
    .vendor >> Vendor and repair
    .target Gothor Brumn

step
    .goto 1432/0,-2676.82,-4825.93
    >>Talk to Mountaineer Stormpike
    >>(Don't worry about his follow-up order yet -- it comes after another turn-in)
    .turnin 353 >> Turn in Stormpike's Delivery
    .accept 307 >> Accept Filthy Paws
    .target Mountaineer Stormpike

step
    #sticky
    #label Sausages
    >>As you quest through the Loch: kill Mountain Boars (Boar Intestines), Elder Black Bears (Bear Meat), and Forest Lurkers (Spider Ichor), 3 of each
    >>Skip the farming if you bought these at the Ironforge auction house earlier
    .collect 3172,3,418,1 --Boar Intestines (3)
    .collect 3173,3,418,1 --Bear Meat (3)
    .collect 3174,3,418,1 --Spider Ichor (3)
    .mob Mountain Boar
    .mob Elder Black Bear
    .mob Forest Lurker

step
    .goto 1432/0,-3003.30,-5376.02
    >>In Thelsamar, talk to Grenhild Darktalon
    .accept 86667 >> Accept Snowbound
    .target Grenhild Darktalon

step
    .goto 1432/0,-2954.42,-5394.10
    >>Talk to Vidra Hearthstove in the inn
    .accept 418 >> Accept Thelsamar Blood Sausages
    .target Vidra Hearthstove

step
    #optional
    .isOnQuest 418
    .goto 1432/0,-3019.85,-5120.13
    >>Still short on Boar Intestines, Bear Meat? Elder Black Bear / Mountain Boar -- around here. This step skips itself once you have them
    .collect 3172,3,418,1 --Boar Intestines (3)
    .collect 3173,3,418,1 --Bear Meat (3)
    .mob Elder Black Bear
    .mob Mountain Boar

step
    #optional
    .isOnQuest 418
    .goto 1432/0,-2809.66,-5348.79
    >>Still short on Spider Ichor? Forest Lurker -- around here. This step skips itself once you have them
    .collect 3174,3,418,1 --Spider Ichor (3)
    .mob Forest Lurker

step
    #optional
    .isQuestComplete 418
    .goto 1432/0,-2954.42,-5394.10
    >>Already have the sausage makings? Turn them in right away
    .turnin 418 >> Turn in Thelsamar Blood Sausages
    .target Vidra Hearthstove

step
    #optional
    #completewith next
    .goto 1432/0,-2952.46,-5381.87
    >>Buy a couple of Small Brown Pouches from Yanni Stoutheart if your bags are tight
    .target Yanni Stoutheart

step
    .goto 1432/0,-3007.99,-5337.39
    >>Mountaineer Kadrell patrols the road through Thelsamar -- catch him
    .accept 416 >> Accept Rat Catching
    .accept 1339 >> Accept Mountaineer Stormpike's Task
    .target Mountaineer Kadrell

step
    .goto 1432/0,-2929.87,-5424.84
    >>Grab the flight path from Thorgrum Borrelson
    .fp Thelsamar >> Get the Thelsamar flight path
    .target Thorgrum Borrelson

step
    .goto 1432/0,-2634.59,-5842.81
    >>Head southeast: drop into the bunker and talk to Captain Rugelfuss
    .accept 267 >> Accept The Trogg Threat
    .target Captain Rugelfuss

step
    .goto 1432/0,-2602.54,-5832.73
    >>Talk to Mountaineer Cobbleflint outside
    .accept 224 >> Accept In Defense of the King's Lands
    .target Mountaineer Cobbleflint

step
    .goto 1432/0,-2534.38,-5648.28
    >>Stand on the snowy patch outside the South Gate Pass tunnel and use the Ceramic Jar
    .use 279380
    .complete 86667,1 --Jar of Snow

step
    #sticky
    #label TunnelRats
    >>Kill Tunnel Rats around the Silver Stream Mine for 12 Tunnel Rat Ears
    .complete 416,1 --Tunnel Rat Ear (12)
    .mob Tunnel Rat Scout
    .mob Tunnel Rat Vermin
    .mob Tunnel Rat Forager
    .mob Tunnel Rat Digger

step
    .goto 1432/0,-3146.73,-4837.02
    >>Talk to Norric Lochthane north along the lochside
    .turnin 86667 >> Turn in Snowbound
    .target Norric Lochthane

step
    .goto 1432/0,-2984.82,-4902.33
    >>Inside the Silver Stream Mine: open Miners' League Crates for 4 Miners' Gear
    >>Crates are scattered all through the mine
    .complete 307,1 --Miners' Gear (4)

step << Warrior
    #optional
    .goto 1432/0,-3176.16,-4669.34
    >>Nillen Andemar (limited stock): buy the Heavy Spiked Mace or Ironwood Maul if you can afford one -- it carries you to the mid-teens
    .collect 4778,1,307,1 --Heavy Spiked Mace
    .collect 4777,1,307,1 --Ironwood Maul
    .disablecheckbox
    .target Nillen Andemar
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<11.8

step << Warrior
    #optional
    #completewith StormpikeOrder
    +Equip the mace you bought (train Two-Handed Maces in Ironforge if you haven't)
    .use 4778
    .itemStat 16,ITEM_MOD_DAMAGE_PER_SECOND_SHORT,<12.5

step
    .goto 1432/0,-2972.41,-4796.92
    >>Finish the Tunnel Rat ears outside the mine
    .complete 416,1 --Tunnel Rat Ear (12)
    .mob Tunnel Rat Forager

step
    #label StormpikeOrder
    .goto 1432/0,-2676.99,-4825.98
    >>Return to Mountaineer Stormpike
    .turnin 307 >> Turn in Filthy Paws
    .turnin 1339 >> Turn in Mountaineer Stormpike's Task
    .accept 1338 >> Accept Stormpike's Order
    .target Mountaineer Stormpike

step
    .goto 1432/0,-2782.63,-4903.25
    >>Sausage makings: finish the Boar Intestines on the boars here (bears and spiders get their own arrows before Thelsamar)
    .collect 3172,3,418,1 --Boar Intestines (3)
    .mob Mountain Boar

step
    .goto 1432/0,-2954.42,-5394.10
    >>Back in Thelsamar, hand Vidra the makings
    .turnin 418 >> Turn in Thelsamar Blood Sausages
    .target Vidra Hearthstove

step
    .goto 1432/0,-3007.99,-5337.39
    >>Find Kadrell on the road
    .turnin 416 >> Turn in Rat Catching
    .target Mountaineer Kadrell

step
    .goto 1432/0,-2747.60,-5530.54
    >>Trogg hyperspawn by the excavation edge: kill 10 Stonesplinter Troggs and 10 Stonesplinter Scouts, looting 8 Trogg Stone Teeth
    >>Scouts shoot from range -- pull them to you
    .complete 224,1 --Stonesplinter Trogg (10)
    .complete 224,2 --Stonesplinter Scout (10)
    .complete 267,1 --Trogg Stone Tooth (8)
    .mob Stonesplinter Trogg
    .mob Stonesplinter Scout

step
    .goto 1432/0,-2634.59,-5842.81
    >>Back at the bunker
    .turnin 267 >> Turn in The Trogg Threat
    .target Captain Rugelfuss

step
    .goto 1432/0,-2602.54,-5832.73
    >>And Cobbleflint outside
    .turnin 224 >> Turn in In Defense of the King's Lands
    .target Mountaineer Cobbleflint

step << Warrior
    #optional
    .goto 1432/0,-2929.87,-5424.84
    >>Skipped Thrown or class training in Ironforge earlier? Fly there from Thorgrum now and catch up, then continue
    .fly Ironforge >> Fly to Ironforge (optional)
    .target Thorgrum Borrelson

step << Paladin Dwarf
    .goto Ironforge,27.6,12.2
    >>PALADIN: make for Ironforge (fly from Thorgrum) -- Tiza Battleforge in the Mystic Ward starts your Redemption chain. Have 10 Linen Cloth along
    .accept 1645 >> Accept The Tome of Divinity
    .turnin 1645 >> Turn in The Tome of Divinity
    .collect 2589,10,1648,1 --Linen Cloth (10)
    .target Tiza Battleforge

step << Paladin Dwarf
    .goto Ironforge,27.6,12.2
    >>Read the Tome of Divinity she gives you, then speak with her again
    .accept 1646 >> Accept The Tome of Divinity
    .turnin 1646 >> Turn in The Tome of Divinity
    .accept 1647 >> Accept The Tome of Divinity
    .target Tiza Battleforge

step << Paladin Dwarf
    .goto Ironforge,23.3,61.8
    >>John Turner walks Ironforge's outer ring -- catch him on his rounds
    .turnin 1647 >> Turn in The Tome of Divinity
    .accept 1648 >> Accept The Tome of Divinity
    .turnin 1648 >> Turn in The Tome of Divinity (the 10 Linen Cloth)
    .accept 1778 >> Accept The Tome of Divinity
    .target John Turner

step << Paladin Dwarf
    .goto Ironforge,27.6,12.2
    >>Tiza again -- she sends you to her husband
    .turnin 1778 >> Turn in The Tome of Divinity
    .accept 1779 >> Accept The Tome of Divinity
    .target Tiza Battleforge

step << Paladin Dwarf
    .goto Ironforge,23.5,8.3
    >>Muiredon Battleforge in the Military Ward -- he gives you the Symbol of Life (lost it? Tiza hands out a new one)
    .turnin 1779 >> Turn in The Tome of Divinity
    .accept 1783 >> Accept The Tome of Divinity
    .target Muiredon Battleforge

step << Paladin Dwarf
    .goto Dun Morogh,78.3,58.1
    >>Ride east out of Ironforge to Helm's Bed Lake: Narm Faulk lies dead among the Dark Irons. Use the Symbol of Life to raise him, speak with him, then take a Dark Iron Script from his killers around the camp
    .use 6866
    .complete 1783,1 --Resurrect Narm Faulk
    .turnin 1783 >> Turn in The Tome of Divinity
    .accept 1784 >> Accept The Tome of Divinity
    .complete 1784,1 --Dark Iron Script
    .target Narm Faulk

step << Paladin Dwarf
    .goto Ironforge,23.5,8.3
    >>Back to Muiredon with the script
    .turnin 1784 >> Turn in The Tome of Divinity
    .accept 1785 >> Accept The Tome of Divinity
    .goto Ironforge,27.6,12.2
    >>And Tiza closes the chain -- Redemption is yours
    .turnin 1785 >> Turn in The Tome of Divinity
    .target Muiredon Battleforge
    .target Tiza Battleforge

step << Mage
    #optional
    .goto Ironforge,27.25,8.3
    >>MAGE (while in Ironforge): Bink in the Mystic Ward takes the referral. Her Gizmonitor follow-up runs off this route -- skip it
    .turnin -1879 >> Turn in Speak with Bink
    .target Bink

step << Warrior
    #optional
    .goto Ironforge,70.77,90.27
    >>WARRIOR (dwarves/gnomes, while in Ironforge): Muren Stormpike in the Hall of Arms takes the referral. His Vejrek follow-up sends you back across Dun Morogh -- skip it
    .turnin -1679 >> Turn in Muren Stormpike
    .target Muren Stormpike

step
    .hs >> Hearth to Stormwind

step
    .goto 1453/0,719.67,-8550.30
    >>In Cathedral Square, talk to Baros Alexston (city architect)
    .accept 399 >> Accept Humble Beginnings
    .target Baros Alexston

step << Paladin Human
    .goto 1453/0,845.78,-8545.87
    >>PALADIN: step inside the Cathedral of Light -- Duthorian Rall starts your Redemption chain. Have 10 Linen Cloth on you (bank or AH if you're short)
    .accept 1641 >> Accept The Tome of Divinity
    .turnin 1641 >> Turn in The Tome of Divinity
    .collect 2589,10,1644,1 --Linen Cloth (10)
    .target Duthorian Rall

step << Paladin Human
    .goto 1453/0,845.78,-8545.87
    >>Read the Tome of Divinity he hands you, then speak to Rall again
    .use 6775
    .accept 1642 >> Accept The Tome of Divinity
    .turnin 1642 >> Turn in The Tome of Divinity
    .accept 1643 >> Accept The Tome of Divinity
    .target Duthorian Rall

step << Paladin Human
    .goto 1453/0,613.41,-8831.93
    >>Stephanie Turner sells goods in the Trade District
    .turnin 1643 >> Turn in The Tome of Divinity
    .accept 1644 >> Accept The Tome of Divinity
    .turnin 1644 >> Turn in The Tome of Divinity (the 10 Linen Cloth)
    .accept 1780 >> Accept The Tome of Divinity
    .target Stephanie Turner

step << Paladin Human
    .goto 1453/0,845.78,-8545.87
    >>Back to Rall at the Cathedral
    .turnin 1780 >> Turn in The Tome of Divinity
    .accept 1781 >> Accept The Tome of Divinity
    .target Duthorian Rall

step << Paladin Human
    .goto 1453/0,862.30,-8516.94
    >>Gazin Tenorm stands nearby in the Cathedral district
    .turnin 1781 >> Turn in The Tome of Divinity
    .accept 1786 >> Accept The Tome of Divinity
    .target Gazin Tenorm

step << Warlock
    .goto 1453/0,1041.57,-8982.57
    >>WARLOCK: down in the Slaughtered Lamb's cellar (Mage Quarter), Gakin the Darkbinder has your first true demon in mind
    .accept 1688 >> Accept Surena Caledon
    .target Gakin the Darkbinder

step << Priest
    .goto 1453/0,862.33,-8512.45
    >>PRIEST: High Priestess Laurena at the Cathedral teaches Desperate Prayer now that you're 10 -- whichever trainer's note you carry lands here
    .turnin -5634 >> Turn in Desperate Prayer
    .turnin -5635 >> Turn in Desperate Prayer
    .turnin -5636 >> Turn in Desperate Prayer
    .turnin -5637 >> Turn in Desperate Prayer
    .turnin -5638 >> Turn in Desperate Prayer
    .turnin -5639 >> Turn in Desperate Prayer
    .target High Priestess Laurena

step << Mage
    .goto 1453/0,861.81,-8989.69
    >>MAGE: Jennea Cannon in the Wizard's Sanctum wants a Mirror Lake sample -- the lake sits beside our road west
    .turnin -1860 >> Turn in Speak with Jennea
    .target Jennea Cannon

step << Mage
    .goto 1453/0,861.81,-8989.69
    >>Take Mirror Lake at Jennea Cannon
    .accept 1861,2,1860 >> Accept Mirror Lake
    .target Jennea Cannon

step << Warrior Human
    #optional
    .goto 1453/0,382.86,-8612.69
    >>WARRIOR: Old Town's Pig and Whistle -- Harry Burlguard's brawl. Square up to Bartleby bare-fisted until he yields, return his mug. The follow-up (Marshal Haggard, Eastvale) keeps for an east-Elwynn day
    .turnin -1638 >> Turn in A Warrior's Training
    .accept 1639,2,1639 >> Accept Bartleby the Drunk

step << Warrior Human
    #optional
    .goto 1453/0,382.86,-8612.69
    >>Hand in Bartleby the Drunk at Bartleby
    .turnin -1639 >> Turn in Bartleby the Drunk

step << Warrior Human
    #optional
    .goto 1453/0,382.86,-8612.69
    >>Take Beat Bartleby at Bartleby
    .accept 1640,2,1639 >> Accept Beat Bartleby

step << Warrior Human
    #optional
    .goto 1453/0,382.86,-8612.69
    >>Beat Bartleby
    .complete -1640,1 --Beat Bartleby

step << Warrior Human
    #optional
    .goto 1453/0,389.07,-8604.43
    >>Hand in Beat Bartleby at Bartleby
    .turnin -1640 >> Turn in Beat Bartleby

step << Warrior Human
    #optional
    .goto 1453/0,389.07,-8604.43
    >>Take Bartleby's Mug at Bartleby
    .accept 1665,2,1640 >> Accept Bartleby's Mug

step << Warrior Human
    #optional
    .goto 1453/0,389.07,-8604.43
    >>Hand in Bartleby's Mug at Harry Burlguard
    .turnin -1665 >> Turn in Bartleby's Mug

step << Warrior Human
    #optional
    .goto 1453/0,389.07,-8604.43
    >>Take Marshal Haggard at Harry Burlguard
    .accept 1666,2,1665 >> Accept Marshal Haggard

step << Mage
    #optional
    .isOnQuest 1861
    .goto Elwynn Forest,28.57,61.39
    >>Mirror Lake, just off the Westfall road: fill the sample at the waterfall end (Jennea takes it on your next city stop)
    .complete -1861,1 --Mirror Lake sample

step << Warlock
    .goto Elwynn Forest,71.0,80.8
    >>Surena Caledon hides with the Defias at the Brackwell Pumpkin Patch in eastern Elwynn -- take her choker
    .complete 1688,1 --Surena's Choker
    .unitscan Surena Caledon

step << Warlock
    .goto 1453/0,1041.57,-8982.57
    >>Back to Gakin with the choker
    .turnin 1688 >> Turn in Surena Caledon
    .accept 1689 >> Accept The Binding
    .target Gakin the Darkbinder

step << Warlock
    .goto 1453/0,1041.57,-8982.57
    >>In the summoning circle below the Slaughtered Lamb, use the Bloodstone Choker: subdue the voidwalker it calls, then hand Gakin the choker. Your shield-demon is yours
    .complete 1689,1 --Summon and subdue the voidwalker
    .turnin 1689 >> Turn in The Binding
    .target Gakin the Darkbinder

step
    .goto 1453/0,600.07,-8427.22
    >>In the Dwarven District, deliver the order to Furen Longbeard
    .turnin 1338 >> Turn in Stormpike's Order
    .target Furen Longbeard

step << Warrior
    .goto 1453/0,323.3,-8689.29
    >>Train with Wu Shen or Ilsa Corbin at the Command Center in Old Town
    .trainer >> Train your class abilities
    .target Wu Shen
    .target Ilsa Corbin

step << Paladin Human
    .goto 1429/0,-984.41,-9130.51
    >>PALADIN: ride east across Elwynn to the island in Stone Cairn Lake. Use the Symbol of Life beside Henze Faulk's body to resurrect him, then speak with him
    .use 6866
    .complete 1786,1 --Resurrect Henze Faulk
    .turnin 1786 >> Turn in The Tome of Divinity
    .accept 1787 >> Accept The Tome of Divinity
    .target Henze Faulk

step << Paladin Human
    .goto 1429/0,-998.29,-9097.95
    >>Defias Rogue Wizards camp all around the lake -- kill them until a Defias Script drops
    .complete 1787,1 --Defias Script
    .mob Defias Rogue Wizard

step << Paladin Human
    .goto 1453/0,862.30,-8516.94
    >>Ride back to Stormwind: Gazin in the Cathedral district
    .turnin 1787 >> Turn in The Tome of Divinity
    .accept 1788 >> Accept The Tome of Divinity
    .target Gazin Tenorm

step << Paladin Human
    .goto 1453/0,845.78,-8545.87
    >>Rall closes the chain -- Redemption is yours. Dead party members stay dead no longer
    .turnin 1788 >> Turn in The Tome of Divinity
    .target Duthorian Rall
]])

-- ======================== 13-15 WESTFALL =============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 13-15 Westfall (Alliance)
#next 14-16 Darkshore (Alliance)
<< Alliance

step
    #optional
    .goto 1453/0,660.28,-8814.55
    >>AH stop (optional but fast): buy the Westfall stew makings -- 3x Stringy Vulture Meat, 3x Murloc Eye, 3x Goretusk Snout, 3x Okra, and 8x Goretusk Liver
    .collect 729,3,38,1 --Stringy Vulture Meat (3)
    .collect 730,3,38,1 --Murloc Eye (3)
    .collect 731,3,38,1 --Goretusk Snout (3)
    .collect 732,3,38,1 --Okra (3)
    .collect 723,8,22,1 --Goretusk Liver (8)

step << Human
    .goto 1453/0,484.20,-8832.50
    >>Talk to Dungar Longdrink at the gryphons
    .turnin 6261 >> Turn in Dungar Longdrink
    .accept 6285 >> Accept Return to Lewis
    .target Dungar Longdrink

step
    .goto 1453/0,484.20,-8832.50
    .fly Westfall >> Fly to Westfall

step
    .goto 1436/0,918.42,-9851.50
    >>At the broken wagon: the Furlbrows (these may already be in your log)
    .accept 64 >> Accept The Forgotten Heirloom
    .target Farmer Furlbrow
    .goto 1436/0,919.47,-9853.13
    .accept 36 >> Accept Westfall Stew
    .accept 151 >> Accept Poor Old Blanchy
    .target Verna Furlbrow

step
    #sticky
    #completewith Pocketwatch
    >>Open Sacks of Oats near farm fences and buildings as you pass: 8 Handfuls of Oats
    .complete 151,1 --Handful of Oats (8)

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
    #sticky
    #label WestfallKills
    >>Throughout Westfall: kill Fleshrippers (Stringy Vulture Meat x3), Goretusks (Snouts x3, Livers x8), Defias Trappers and Smugglers (15 each + 15 Red Leather Bandanas), and Harvest Watchers (20 + Okra x3)
    >>Loot Flasks of Oil too -- a lighthouse quest wants 5 later
    .complete 12,1 --Defias Trapper (15)
    .complete 12,2 --Defias Smuggler (15)
    .complete 153,1 --Red Leather Bandana (15)
    .complete 9,1 --Harvest Watcher (20)
    .collect 729,3,38,1 --Stringy Vulture Meat (3)
    .collect 731,3,38,1 --Goretusk Snout (3)
    .collect 732,3,38,1 --Okra (3)
    .collect 723,8,22,1 --Goretusk Liver (8)
    .collect 814,5,103,1 --Flask of Oil (5, for later)
    .mob Defias Trapper
    .mob Defias Smuggler
    .mob Harvest Watcher
    .mob Young Goretusk
    .mob Young Fleshripper

step << Human
    .goto 1436/0,1021.67,-10500.63
    >>At Sentinel Hill, talk to Quartermaster Lewis
    .turnin -6285 >> Turn in Return to Lewis
    .target Quartermaster Lewis

step
    .goto 1436/0,1045.12,-10508.80
    >>Gryan Stoutmantle up the tower
    .turnin 98021 >> Turn in Journey to Sentinel Hill << Skyborne
    .accept 12 >> Accept The People's Militia
    .target Gryan Stoutmantle

step
    #optional
    #completewith next
    .abandon 102 >> Abandon Patrolling Westfall if it's still in your log -- gnoll paws aren't worth the detour

step
    .goto 1436/0,1126.67,-10636.67
    >>Scout Galiaan south of the tower
    .accept 153 >> Accept Red Leather Bandanas
    .target Scout Galiaan

step
    .goto 1436/0,1179.80,-10635.60
    >>Alba Fairmoon at the tower
    .accept 92742 >> Accept Testing the Wells
    .accept 92744 >> Accept Murloc Gills
    .target Alba Fairmoon

step
    .isOnQuest 399
    .goto 1436/0,1748.27,-10672.13
    >>Ride west to Alexston's Farmstead: clear to the burnt house and open Alexston's Chest beside the chimney (use the chimney to break casters' line of sight)
    .complete 399,1 --A Simple Compass

step
    .goto 1436/0,1404.20,-10290.90
    >>Use the Well Water Sample Kit at the Molsen Farm well
    .use 254545
    .complete 92742,2 --Molsen Farm sample

step
    #label Pocketwatch
    .goto 1436/0,1289.77,-9849.63
    >>At the Jansen Stead: open Furlbrow's Wardrobe for the Pocket Watch
    >>Watch for Benny Blanco by the wardrobe -- he hits hard
    .complete 64,1 --Furlbrow's Pocket Watch

step
    .goto 1436/0,1035.30,-9835.10
    >>Sample the Jansen Stead well
    .use 254545
    .complete 92742,1 --Jansen Stead sample

step
    .goto 1436/0,1042.67,-9619.33
    >>Murlocs on the shore: loot 3 Murloc Eyes and 7 Longshore Murloc Gills
    .collect 730,3,38,1 --Murloc Eye (3)
    .complete 92744,1 --Longshore Murloc Gills (7)
    .mob Murloc Raider
    .mob Murloc Coastrunner

step
    .goto 1436/0,1013.62,-9861.53
    >>Finish the Handfuls of Oats around the stead
    .complete 151,1 --Handful of Oats (8)

step
    .goto 1436/0,918.42,-9851.50
    >>Back to the Furlbrows
    .turnin 64 >> Turn in The Forgotten Heirloom
    .target Farmer Furlbrow
    .goto 1436/0,919.47,-9853.13
    .turnin 151 >> Turn in Poor Old Blanchy
    .target Verna Furlbrow

step
    .goto 1436/0,1238.67,-9907.73
    >>Finish Harvest Watchers in the fields (keep the Flasks of Oil)
    .complete 9,1 --Harvest Watcher (20)
    .collect 814,5,103,1 --Flask of Oil (5)
    .mob Harvest Watcher

step
    #optional
    .goto 1436/0,1213.40,-10153.80
    >>If golem parts happened to drop (14 Isosprings + 5 Gyrostabilizers), Ozwin Ironsprocket in the barn pays XP for them -- don't farm for these, the drop rate is terrible
    .accept 92909 >> Accept Harvesting the Harvesters
    .turnin 92909 >> Turn in Harvesting the Harvesters
    .itemcount 255007,14 --Golem Isospring (14)
    .itemcount 255010,5 --Harvester Gyrostabilizer (5)
    .target Ozwin Ironsprocket

step
    .goto 1436/0,1055.27,-10128.70
    >>Saldean: vendor trash but KEEP the quest meats, then turn in
    .vendor >> Vendor (keep Murloc Eyes, Snouts, Livers, Vulture Meat)
    .turnin 9 >> Turn in The Killing Fields
    .target Farmer Saldean

step
    #optional
    .isOnQuest 38
    .goto 1429/0,884.12,-10052.63
    >>Still short on Stringy Vulture Meat? Young Fleshripper -- around here. This step skips itself once you have them
    .collect 729,3,38,1 --Stringy Vulture Meat (3)
    .mob Young Fleshripper

step
    #optional
    .isOnQuest 38
    .goto 1436/0,1130.87,-10354.57
    >>Still short on Goretusk Snout? Young Goretusk -- around here. This step skips itself once you have them
    .collect 731,3,38,1 --Goretusk Snout (3)
    .mob Young Goretusk

step
    #optional
    .isOnQuest 38
    .goto 1429/0,1114.42,-10151.10
    >>Still short on Okra? Harvest Watcher -- around here. This step skips itself once you have them
    .collect 732,3,38,1 --Okra (3)
    .mob Harvest Watcher

step
    #optional
    .isOnQuest 22
    .goto 1436/0,1130.87,-10354.57
    >>Still short on Goretusk Liver? Young Goretusk -- around here. This step skips itself once you have them
    .collect 723,8,22,1 --Goretusk Liver (8)
    .mob Young Goretusk

step
    .goto 1436/0,1042.67,-10111.67
    >>Salma inside
    .turnin 38 >> Turn in Westfall Stew
    .turnin 22 >> Turn in Goretusk Liver Pie
    .target Salma Saldean

step
    .goto 1436/0,1324.20,-10490.40
    >>Finish Trappers/Smugglers/bandanas at the dynamic-respawn Defias camp east of Sentinel Hill
    .complete 12,1 --Defias Trapper (15)
    .complete 12,2 --Defias Smuggler (15)
    .complete 153,1 --Red Leather Bandana (15)
    .mob Defias Trapper
    .mob Defias Smuggler

step
    .goto 1436/0,1045.12,-10508.80
    >>Gryan Stoutmantle
    .turnin 12 >> Turn in The People's Militia
    .accept 65 >> Accept The Defias Brotherhood
    .target Gryan Stoutmantle

step
    .goto 1436/0,1126.67,-10636.67
    >>Scout Galiaan
    .turnin 153 >> Turn in Red Leather Bandanas
    .target Scout Galiaan

step
    .goto 1436/0,1179.80,-10635.60
    >>Alba Fairmoon
    .turnin 92742 >> Turn in Testing the Wells
    .turnin 92744 >> Turn in Murloc Gills
    .target Alba Fairmoon

step
    .hs >> Hearth to Stormwind

step
    #optional
    .goto 1453/0,596.40,-8831.70
    >>Thurman Mullby (Trade District): buy a Simple Wood and Flint and Tinder -- campfire cooking on the boat keeps your skill moving toward 50 (a Duskwood quest wants it later)
    .collect 4470,1 --Simple Wood
    .collect 4471,1 --Flint and Tinder
    .target Thurman Mullby

step
    #optional
    .goto 1453/0,660.28,-8814.55
    >>AH: buy 5x Strider Meat and 6x Darkshore Grouper -- they pre-complete two Darkshore turn-ins
    .collect 5469,5,2178,1 --Strider Meat (5)
    .collect 12238,6,1141,1 --Darkshore Grouper (6)

step << Warrior
    .goto 1453/0,323.3,-8689.29
    >>Train at the Command Center
    .trainer >> Train your class abilities
    .target Wu Shen
    .target Ilsa Corbin

step
    .goto 1453/0,719.67,-8550.30
    >>Baros Alexston in Cathedral Square
    .turnin -399 >> Turn in Humble Beginnings
    .target Baros Alexston

step
    .goto 1453/0,765.70,-8804.00
    >>Catherine Leland by the canal: buy 1 Shiny Bauble and 3 Nightcrawlers (fishing supplies for a quick 900 XP)
    .collect 6529,1,95065,1 --Shiny Bauble
    .collect 6530,3,95065,1 --Nightcrawlers (3)
    .target Catherine Leland

step
    .goto 1453/0,1269.10,-8540.60
    >>Gilbert Gray at the harbor
    .accept 95065 >> Accept Fishin' Time
    .turnin 95065 >> Turn in Fishin' Time
    .target Gilbert Gray

step
    #optional
    #completewith next
    +While waiting at the dock: drop a Basic Campfire and cook your saved boar/wolf meat toward Cooking 50

step
    .goto 1453/0,1330.10,-8645.40
    .zone Darkshore >> Take the boat to Darkshore (Auberdine)
]])

-- ======================= 14-16 DARKSHORE =============================
Steward.RegisterGuide([[
#forever
#version 1
#group Custom Forever Guides
#name 14-16 Darkshore (Alliance)
#next 16-19 Darkshore (Alliance)
<< Alliance

step
    .goto 1439/1,600.50,6424.66
    >>On the dock, talk to the ghost Cerellean Whiteclaw
    .accept 963 >> Accept For Love Eternal
    .target Cerellean Whiteclaw

step
    .goto 1439/1,519.74,6406.10
    >>Wizbang Cranktoggle, upstairs in the inn
    .accept 983 >> Accept Buzzbox 827
    .target Wizbang Cranktoggle

step << Druid
    .isOnQuest 6001
    .goto Darkshore,36.6,45.9
    >>DRUID: the Moonkin Stone south of Auberdine. Use the Cenarion Moondust there -- Lunaclaw answers. Defeat the great cat and take its strength
    .complete -6001,1 --Face Lunaclaw
    .unitscan Lunaclaw

step << Druid
    .isQuestComplete 6001
    >>Boat from Auberdine to Rut'theran, portal up to Darnassus: Mathrengyl grants BEAR FORM -- and new lessons
    .goto 1457/1,2563.98,10179.00
    .turnin -6001 >> Turn in Body and Heart
    .accept 6121 >> Accept Lessons Anew
    .target Mathrengyl Bearwalker

step << Druid
    .isOnQuest 6121
    >>Teleport to Moonglade (wait out the cooldown if needed): Dendrite Starblaze again
    .goto Moonglade,56.2,30.6
    .turnin 6121 >> Turn in Lessons Anew
    .accept 6122 >> Accept The Principal Source
    .target Dendrite Starblaze

step << Druid
    .isOnQuest 6122
    .goto Darkshore,54.5,32.0
    >>Back in Darkshore (druid flight to Rut'theran, boat over): draw a water sample at the mouth of the Cliffspring Falls cave with the empty sampler
    .complete 6122,1 --Cliffspring water sample

step << Druid
    .goto 1439/1,492.36,6581.08
    >>Alanndarian Nightsong in Auberdine brews the cure: she needs 5 Earthroot and 12 Lunar Funguses -- fungus grows in the Twilight caves and dens, Earthroot from any herbalist or the auction house
    .turnin -6122 >> Turn in The Principal Source
    .accept 6123,2,6122 >> Accept Gathering the Cure
    .complete 6123,1 --Earthroot (5)
    .complete 6123,2 --Lunar Fungus (12)
    .turnin -6123 >> Turn in Gathering the Cure
    .accept 6124 >> Accept Curing the Sick
    .target Alanndarian Nightsong

step << Druid
    .isOnQuest 6124
    .goto Darkshore,38.5,47.0,60,0
    >>Use the Curative Animal Salve on 10 Sickly Deer wandering near the roads south of Auberdine
    .complete 6124,1 --Cure 10 Sickly Deer

step << Druid
    .isQuestComplete 6124
    >>Teleport to Moonglade: Dendrite confirms the cure, Mathrengyl in Darnassus teaches it -- Cure Poison learned, then make your way back
    .goto Moonglade,56.2,30.6
    .turnin 6124 >> Turn in Curing the Sick
    .accept 6125 >> Accept Power over Poison
    .target Dendrite Starblaze

step << Druid
    .goto 1457/1,2564.03,10179.04
    >>Hand in Power over Poison at Mathrengyl Bearwalker
    .turnin -6125 >> Turn in Power over Poison
    .target Mathrengyl Bearwalker

step
    .goto 1439/1,515.55,6406.32
    >>Set your hearth here -- Auberdine is home for the next several levels
    .home >> Set your Hearthstone to Auberdine
    .target Innkeeper Shaussiy

step
    .goto 1439/1,497.08,6427.72
    >>Barithras Moonshade on the walkway
    .accept 947 >> Accept Cave Mushrooms
    .target Barithras Moonshade

step
    .goto 1439/1,472.12,6438.51
    >>Sentinel Glynda Nal'Shea
    .accept 4811 >> Accept The Red Crystal
    .target Sentinel Glynda Nal'Shea

step
    .goto 1439/1,397.45,6437.50
    >>Tharnariun Treetender
    .accept 2118 >> Accept Plagued Lands
    .target Tharnariun Treetender

step
    .goto 1439/1,362.74,6434.58
    >>Terenthis
    .accept 984 >> Accept How Big a Threat?
    .target Terenthis

step
    .goto 1439/1,503.10,6402.10
    >>Click the wanted poster by the inn
    .accept 98025 >> Accept WANTED: Jai'vhanel

step
    .goto 1439/1,577.38,6371.35
    >>Gubber Blump on the beach: if you bought Groupers at the AH this is an instant 1,000+ XP
    .accept 1141 >> Accept The Family and the Fishing Pole
    .turnin 1141 >> Turn in The Family and the Fishing Pole
    .accept 1138 >> Accept Fruit of the Sea
    .target Gubber Blump

step
    .goto 1439/1,542.99,6342.31
    >>Gwennyth Bly'Leggonde
    .accept 3524 >> Accept Washed Ashore
    .target Gwennyth Bly'Leggonde

step
    .goto 1439/1,561.66,6343.27
    .fp Auberdine >> Get the Auberdine flight path
    .target Caylais Moonfeather
    .goto 1439/1,533.40,6399.60 << NightElf
    .turnin 6342 >> Turn in Flight to Auberdine << NightElf
    .target Laird << NightElf

step
    #sticky
    #label Crawlers
    .goto 1439/1,631.15,5998.74
    >>South along the beach: kill Pygmy Tide Crawlers and Young Reef Crawlers for 6 Crawler Legs (some are in the water)
    .complete 983,1 --Crawler Leg (6)
    .mob Pygmy Tide Crawler
    .mob Young Reef Crawler

step
    .goto 1439/1,559.37,6109.83
    >>Open the Washed Ashore sea creature on the beach
    .complete 3524,1 --Sea Creature Bones

step
    #completewith TurnIn26
    >>When you spot a Rabid Thistle Bear: target it and use Tharnariun's Hope from range
    >>Don't use the trap without a Rabid bear targeted -- a wasted trap means going back for another
    .complete 2118,1 --Rabid Thistle Bear captured
    .use 7586
    .unitscan Rabid Thistle Bear

step
    .goto 1439/1,393.72,5993.24
    >>Walk to the edge of the corrupt furbolg camp
    .complete 984,1 --Find a corrupt furbolg camp

step
    #optional
    .isOnQuest 983
    .goto 1448/1,607.25,6233.84
    >>Still short on Crawler Leg? Pygmy Tide Crawler / Young Reef Crawler -- around here. This step skips itself once you have them
    .complete 983,1 --Crawler Leg (6)
    .mob Pygmy Tide Crawler
    .mob Young Reef Crawler

step
    #requires Crawlers
    #label BuzzOne
    .goto 1439/1,542.14,6313.75
    >>Click Buzzbox 827 near Gwennyth
    .turnin 983 >> Turn in Buzzbox 827
    .accept 1001 >> Accept Buzzbox 411

step
    .goto 1439/1,542.99,6342.31
    >>Gwennyth
    .turnin 3524 >> Turn in Washed Ashore
    .accept 4681 >> Accept Washed Ashore
    .target Gwennyth Bly'Leggonde

step
    .goto 1439/1,856.08,6311.39
    >>Jump off the end of the dock and swim to the Beached Sea Turtle
    .complete 4681,1 --Sea Turtle Remains

step
    .goto 1439/1,542.99,6342.31
    >>Swim back to Gwennyth
    .turnin 4681 >> Turn in Washed Ashore
    .target Gwennyth Bly'Leggonde

step
    #optional
    .isOnQuest 2118
    .goto 1448/1,-230.50,6873.56
    >>Still short on Rabid Thistle Bear? Rabid Thistle Bear -- around here. This step skips itself once you have them
    .complete 2118,1 --Rabid Thistle Bear captured
    .mob Rabid Thistle Bear

step
    #label TurnIn26
    .goto 1439/1,397.45,6437.50
    >>Tharnariun
    .turnin 2118 >> Turn in Plagued Lands
    .accept 2138 >> Accept Cleansing of the Infected
    .target Tharnariun Treetender

step
    .goto 1439/1,362.74,6434.58
    >>Terenthis
    .turnin 984 >> Turn in How Big a Threat?
    .accept 985 >> Accept How Big a Threat?
    .accept 4761 >> Accept Thundris Windweaver
    .target Terenthis

step
    .goto 1439/1,445.66,6535.79
    >>Gorbold Steelhand at the north end of town
    .accept 982 >> Accept Deep Ocean, Vast Sea
    .target Gorbold Steelhand

step
    #optional
    .goto 1439/1,472.32,6556.10
    >>Alanndarian Nightsong: instant turn-in if you have 5 Strider Meat (AH or drops) and Cooking 10+
    .accept 2178 >> Accept Easy Strider Living
    .turnin 2178 >> Turn in Easy Strider Living
    .itemcount 5469,5
    .target Alanndarian Nightsong

step
    .goto 1439/1,492.36,6581.08
    >>Thundris Windweaver in the northern building
    .turnin 4761 >> Turn in Thundris Windweaver
    .accept 4762 >> Accept The Cliffspring River
    .accept 954 >> Accept Bashal'Aran
    .accept 958 >> Accept Tools of the Highborne
    .target Thundris Windweaver

step
    #sticky
    >>Bears count as you travel: kill Rabid Thistle Bears (20) for Cleansing of the Infected -- they roam all over Darkshore, keep at it for the rest of this chapter
    .complete 2138,1 --Rabid Thistle Bear (20)
    .mob Rabid Thistle Bear

step
    .goto 1439/1,438.72,7077.74
    >>Swim north to the sunken boat -- WATCH YOUR BREATH
    >>Loot the Silver Dawning's Lockbox (easiest from outside the hull with an Interact keybind, or swim into the bottom deck)
    .complete 982,1 --Silver Dawning's Lockbox

step
    .goto 1439/1,349.11,7133.07
    >>Second wreck: the Mist Veil Lockbox
    .complete 982,2 --Mist Veil Lockbox

step
    .goto 1439/1,197.15,6964.86
    >>Click the Beached Sea Creature on the shore
    .accept 4723 >> Accept Beached Sea Creature

step
    .goto 1439/1,620.35,6768.76
    >>Kill Darkshore Threshers in the shallows for 3 Thresher Eyes
    .complete 1001,1 --Thresher Eye (3)
    .mob Darkshore Thresher

step
    #label Buzz411
    .goto 1439/1,193.29,7083.77
    >>Click Buzzbox 411 on the shore
    .turnin 1001 >> Turn in Buzzbox 411
    .accept 1002 >> Accept Buzzbox 323

step
    #sticky
    >>Moonstalker Fangs (6) drop from every Moonstalker: Runts and adult Moonstalkers as you cross Darkshore (Sires and Matriarchs drop them too, but hit harder)
    .complete 1002,1 --Moonstalker Fang (6)
    .mob Moonstalker Runt
    .mob Moonstalker
    .mob Moonstalker Sire
    .mob Moonstalker Matriarch

step
    .goto 1439/1,48.66,6748.71
    >>Talk to Asterion in the Bashal'Aran ruins
    .turnin 954 >> Turn in Bashal'Aran
    .accept 955 >> Accept Bashal'Aran
    .target Asterion

step
    .goto 1439/1,-60.00,6725.88
    >>Kill Wild Grells and Vile Sprites for 8 Grell Earrings (leave the satyrs for now)
    .complete 955,1 --Grell Earring (8)
    .mob Wild Grell
    .mob Vile Sprite

step
    .goto 1439/1,48.66,6748.71
    >>Asterion
    .turnin 955 >> Turn in Bashal'Aran
    .accept 956 >> Accept Bashal'Aran
    .target Asterion

step
    .goto 1439/1,-160.94,6727.54
    >>Kill Deth'ryll Satyrs for the Ancient Moonstone Seal (slow respawns -- rotate the ruins)
    .complete 956,1 --Ancient Moonstone Seal
    .mob Deth'ryll Satyr

step
    #label BashalDone
    .goto 1439/1,48.66,6748.71
    >>Asterion once more
    .turnin 956 >> Turn in Bashal'Aran
    .accept 957 >> Accept Bashal'Aran
    .target Asterion

step
    .goto 1439/1,-157.40,6207.81
    >>Climb to the big Red Crystal on the eastern ridge
    >>The moonkin pairs west of it are linked -- pull carefully
    .complete 4811,1 --Locate the red crystal

step
    .hs >> Hearth to Auberdine

step
    .goto 1439/1,472.12,6438.51
    >>Glynda
    .turnin 4811 >> Turn in The Red Crystal
    .accept 4812 >> Accept As Water Cascades
    .target Sentinel Glynda Nal'Shea

step
    .goto 1439/1,467.93,6411.96
    >>Fill the Empty Water Tube at the Auberdine moonwell
    .use 14338
    .complete 4812,1 --Moonwell Water Tube

step
    #sticky
    #completewith AmethDone
    >>Moonkin near the crystal and ruins drop Small Eggs -- keep them, they're the cheapest Cooking skill-ups to 50
    .collect 6889,10,2178,1 --Small Egg

step
    .goto 1439/1,-157.40,6207.81
    >>Return to the Red Crystal
    .turnin 4812 >> Turn in As Water Cascades
    .accept 4813 >> Accept The Fragments Within

step
    .goto 1439/1,301.89,5725.08
    >>Sentinel Tysha Moonblade on the road south
    .accept 953 >> Accept The Fall of Ameth'Aran
    .target Sentinel Tysha Moonblade

step
    #sticky
    #label Anaya
    .goto 1439/1,158.64,5683.77
    >>In Ameth'Aran: kill the ghost Anaya Dawnrunner (patrols the ruins) for her pendant
    .complete 963,1 --Anaya's Pendant
    .unitscan Anaya Dawnrunner

step
    #sticky
    #label Relics
    .goto 1439/1,54.95,5691.19
    >>Kill Highborne ghosts for 7 Highborne Relics
    .complete 958,1 --Highborne Relic (7)
    .mob Cursed Highborne
    .mob Writhing Highborne
    .mob Wailing Highborne

step
    .goto 1439/1,147.96,5576.00
    >>Read the stone tablet: The Fall of Ameth'Aran
    .complete 953,2 --Fall of Ameth'Aran

step
    .goto 1439/1,166.24,5634.08
    >>Click the Ancient Flame to destroy the seal
    .complete 957,1 --Destroy the seal

step
    .goto 1439/1,105.52,5770.10
    >>And the second tablet: The Lay of Ameth'Aran
    .complete 953,1 --Lay of Ameth'Aran

step
    .isOnQuest 98025
    >>Kill Jai'vhanel, the big harpy among the ruins, and loot the feather
    .complete 98025,1 --Feather of Jai'vhanel
    .mob Jai'vhanel

step
    #optional
    .isOnQuest 958
    .goto 1448/1,137.61,5705.47
    >>Still short on Highborne Relic? Cursed Highborne / Wailing Highborne / Writhing Highborne -- around here. This step skips itself once you have them
    .complete 958,1 --Highborne Relic (7)
    .mob Cursed Highborne
    .mob Wailing Highborne
    .mob Writhing Highborne

step
    #requires Relics
    .goto 1439/1,301.89,5725.08
    >>Back to Tysha (finish Anaya and the relics first)
    .turnin 953 >> Turn in The Fall of Ameth'Aran
    .target Sentinel Tysha Moonblade

step
    .goto 1439/1,511.29,5618.71
    >>Click the Beached Sea Turtle on the shore west of the ruins
    .accept 4722 >> Accept Beached Sea Turtle

step
    #optional
    .isOnQuest 963
    .goto 1448/1,201.80,5693.25
    >>Still short on Anaya's Pendant? Anaya Dawnrunner -- around here. This step skips itself once you have them
    .complete 963,1 --Anaya's Pendant
    .mob Anaya Dawnrunner

step
    #requires Anaya
    #label AmethDone
    .goto 1439/1,365.42,5971.88
    >>At the Blackwood furbolg camp: kill 8 Pathfinders and 5 Windtalkers
    .complete 985,1 --Blackwood Pathfinder (8)
    .complete 985,2 --Blackwood Windtalker (5)
    .mob Blackwood Pathfinder
    .mob Blackwood Windtalker

step
    .goto 1439/1,542.99,6342.31
    >>Return to Auberdine: Gwennyth first
    .turnin 4722 >> Turn in Beached Sea Turtle
    .turnin 4723 >> Turn in Beached Sea Creature
    .target Gwennyth Bly'Leggonde

step
    .goto 1439/1,600.50,6424.66
    >>Cerellean Whiteclaw on the dock
    .turnin 963 >> Turn in For Love Eternal
    .target Cerellean Whiteclaw

step
    .isQuestComplete 98025
    .goto 1439/1,472.90,6439.80
    >>Glynda
    .turnin 98025 >> Turn in WANTED: Jai'vhanel
    .target Sentinel Glynda Nal'Shea

step
    .goto 1439/1,362.74,6434.58
    >>Terenthis
    .turnin 985 >> Turn in How Big a Threat?
    .accept 986 >> Accept A Lost Master
    .target Terenthis

step
    .goto 1439/1,384.35,6431.43
    >>Sentinel Elissa Starbreeze, upstairs in the same building
    .accept 965 >> Accept The Tower of Althalaxx
    .target Sentinel Elissa Starbreeze

step
    .goto 1439/1,-386.39,7219.83
    >>Ride north: fill the Empty Sampling Tube at the base of the Cliffspring River falls
    .use 12350
    .complete 4762,1 --Cliffspring River Sample

step
    .goto 1439/1,-719.13,6787.53
    >>In the Cliffspring River cave: loot 5 Scaber Stalks and 1 Death Cap mushroom
    >>Watch the Wave Riders' knockback near ledges; the Death Cap sits at the end of the lower room
    .complete 947,1 --Scaber Stalk (5)
    .complete 947,2 --Death Cap (1)

step
    .goto 1439/1,-571.03,7195.64
    >>Foreststriders here if you still need Strider Meat for Easy Strider Living
    .collect 5469,5,2178,1 --Strider Meat (5)
    .mob Foreststrider

step
    .goto 1439/1,492.36,6581.08
    >>Back in Auberdine: Thundris
    .turnin 4762 >> Turn in The Cliffspring River
    .accept 4763 >> Accept The Blackwood Corrupted
    .turnin 958 >> Turn in Tools of the Highborne
    .target Thundris Windweaver

step
    #optional
    .isOnQuest 2178
    .goto 1448/1,30.19,6216.81
    >>Still short on Small Egg? Child of Jai'vhanel / Cloudrunner / Den'dralass -- around here. This step skips itself once you have them
    .collect 6889,10,2178,1 --Small Egg
    .mob Child of Jai'vhanel
    .mob Cloudrunner
    .mob Den'dralass
    .mob Dire Condor

step
    #optional
    .goto 1439/1,472.32,6556.10
    >>Alanndarian: strider turn-in if you have the meat now
    .accept 2178 >> Accept Easy Strider Living
    .turnin 2178 >> Turn in Easy Strider Living
    .itemcount 5469,5
    .target Alanndarian Nightsong

step
    .goto 1439/1,467.08,6409.38
    >>Fill the Empty Cleansing Bowl at the moonwell
    .use 12346
    .collect 12347,1,4763,1 --Filled Cleansing Bowl

step
    .goto 1439/1,472.32,6438.64
    >>Hand Glynda the crystal fragments
    .turnin 4813 >> Turn in The Fragments Within
    .target Sentinel Glynda Nal'Shea

step
    .goto 1439/1,489.41,6506.36
    >>Archaeologist Hollee by the dock ramp
    .accept 729 >> Accept The Absent Minded Prospector
    .target Archaeologist Hollee

step
    .goto 1439/1,445.66,6535.79
    >>Gorbold
    .turnin 982 >> Turn in Deep Ocean, Vast Sea
    .target Gorbold Steelhand

step
    .goto 1439/1,497.08,6427.72
    >>Moonshade
    .turnin 947 >> Turn in Cave Mushrooms
    .accept 948 >> Accept Onu
    .target Barithras Moonshade

step
    .goto 1439/1,504.41,6402.39
    >>Click the wanted poster
    .accept 4740 >> Accept WANTED: Murkdeep!

step
    #optional
    .isQuestComplete 1138
    .goto 1439/1,577.38,6371.35
    >>Crab chunks done already? Gubber pays out
    .turnin 1138 >> Turn in Fruit of the Sea
    .target Gubber Blump
]])
