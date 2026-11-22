local ADDON, S = ...

-- Options live in the game's own panel: Esc > Options > AddOns > Steward,
-- stat priority on the main page, "Guide", "Gear" and "Quests" sub-pages, all Blizzard's standard controls.

local function addCheckbox(category, key, label, tooltip, onChange)
    local variable = "Steward_" .. key
    local setting = Settings.RegisterAddOnSetting(category, variable, key, StewardDB, type(S.defaults[key]), label,
        S.defaults[key])
    local init = Settings.CreateCheckbox(category, setting, tooltip)
    if Settings.SetOnValueChangedCallback then
        Settings.SetOnValueChangedCallback(variable, onChange or function() S:SettingsChanged() end)
    end
    return setting, init
end

-- a slider for a number setting (sizes in percent, amounts to keep); label shows the value with fmt
local function addSlider(category, key, label, tooltip, lo, hi, step, fmt, onChange)
    if not (Settings.CreateSlider and Settings.CreateSliderOptions) then return end
    local variable = "Steward_" .. key
    local setting = Settings.RegisterAddOnSetting(category, variable, key, StewardDB, "number", label, S.defaults[key])
    local opts = Settings.CreateSliderOptions(lo, hi, step)
    if opts and opts.SetLabelFormatter and MinimalSliderWithSteppersMixin and MinimalSliderWithSteppersMixin.Label then
        opts:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(v) return fmt(math.floor(v + 0.5)) end)
    end
    local init = Settings.CreateSlider(category, setting, opts, tooltip)
    if Settings.SetOnValueChangedCallback then
        Settings.SetOnValueChangedCallback(variable, onChange or function() S:SettingsChanged() end)
    end
    return setting, init
end
local function pct(v) return v .. "%" end
local function under(init, parentInit, fn)
    if init and init.SetParentInitializer and parentInit then init:SetParentInitializer(parentInit, fn) end
end

local function specOptions()
    local c = Settings.CreateControlTextContainer()
    c:Add("auto", "Auto-detect (" .. (S:DetectSpec()) .. ")")
    for _, name in ipairs(S:ClassSpecs()) do c:Add(name, name) end
    return c:GetData()
end

-- the leveling builds Wowhead's guide offers for your spec (most specs have one)
local function buildOptions()
    local c = Settings.CreateControlTextContainer()
    local choices = (S.BUILD_CHOICES[S:PlayerClass() or ""] or {})[S:CurrentSpec() or ""]
    if choices then
        for _, b in ipairs(choices) do c:Add(b.id, b.label) end
    else
        c:Add("default", "Wowhead's leveling build (the only one for " .. (S:CurrentSpec() or "your spec") .. ")")
    end
    return c:GetData()
end

function S:InitOptions()
    if not (Settings and Settings.RegisterVerticalLayoutCategory and Settings.RegisterAddOnSetting) then
        error("this client has no Settings panel API")
    end

    local main, mainLayout = Settings.RegisterVerticalLayoutCategory("Steward")
    if mainLayout and CreateSettingsListSectionHeaderInitializer then
        mainLayout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
            "Your leveling companion (v" .. S.version .. ")"))
    end

    -- shared by every part of Steward: gear, quest rewards (and later the rotation helper)
    -- per character since 0.39.0; an account-wide pick from before moves to this character once
    if StewardCharDB.gearSpec == nil then
        local old = StewardDB.gearSpec
        StewardCharDB.gearSpec = (old and old ~= "auto") and old or "auto"
    end
    StewardDB.gearSpec = "auto"
    local specSetting = Settings.RegisterAddOnSetting(main, "Steward_gearSpec", "gearSpec", StewardCharDB, "string",
        "Spec", S.defaults.gearSpec)
    Settings.CreateDropdown(main, specSetting, specOptions,
        "This character's spec: it sets your stat weights (equipping gear, picking quest rewards), the rotation helper, " ..
        "the talent build and your action bars, all from Wowhead's Forever guides. The game opens talents at level 10; " ..
        "until then every character uses its class's default spec. You can also pick with the three buttons on the " ..
        "talent window. Auto-detect follows your talents.")
    if Settings.SetOnValueChangedCallback then
        Settings.SetOnValueChangedCallback("Steward_gearSpec", function()
            S:SettingsChanged()
            if S.UpdateSpecButtons then S:UpdateSpecButtons() end
        end)
    end

    local rotSet, rotInit = addCheckbox(main, "rotationHelper", "Show what to press next in combat",
        "A small strip of icons above your bars, and the button on your bars lights up. It never presses anything for you.")
    local function rotOn() return rotSet:GetValue() end
    local _, rsInit = addCheckbox(main, "rotationStrip", "The strip of icons above your bars",
        "The next button to press, big, and the two after it.")
    under(rsInit, rotInit, rotOn)
    local _, rgInit = addCheckbox(main, "rotationGlow", "Light up the button on your bars",
        "The button that holds what to press next shimmers, as the game's own helper does.")
    under(rgInit, rotInit, rotOn)
    local _, rzInit = addSlider(main, "rotationSize", "Strip size", "How big the strip of icons is.", 50, 200, 10, pct)
    under(rzInit, rotInit, rotOn)
    addCheckbox(main, "buffReminders", "Remind me of missing buffs",
        "Out of combat, the button for a long buff you're missing (blessing, aura, armor, Fortitude...) lights up gold.")
    addCheckbox(main, "dungeonNotes", "Dungeon notes",
        "When you enter a dungeon, a short card beside the quest list says which quests to bring and what to watch for.")
    addCheckbox(main, "talentsAuto", "Spend talent points for me",
        "Takes a leveling build for the spec above as soon as you get a point. Hold Shift when you level to leave it for later.")
    -- per character: which of the guide's leveling builds to follow (only shown when your class has a spec whose
    -- Wowhead page offers more than one; none does at the moment)
    if StewardCharDB.talentBuild == nil then StewardCharDB.talentBuild = "default" end
    if next(S.BUILD_CHOICES[S:PlayerClass() or ""] or {}) then
    local buildSetting = Settings.RegisterAddOnSetting(main, "Steward_talentBuild", "talentBuild", StewardCharDB, "string",
        "Talent build", "default")
    Settings.CreateDropdown(main, buildSetting, buildOptions,
        "This character's leveling build, from Wowhead's Forever leveling guide for your spec. Most specs have one; " ..
        "where the guide offers more, pick one here.")
    if Settings.SetOnValueChangedCallback then
        Settings.SetOnValueChangedCallback("Steward_talentBuild", function() S:SettingsChanged() end)
    end
    end

    addCheckbox(main, "reloadButton", "Show a Reload button",
        "A small Reload button at the top of the screen, handy while Steward is being tuned. Drag it to move it.")
    if mainLayout and CreateSettingsButtonInitializer then
        mainLayout:AddInitializer(CreateSettingsButtonInitializer("First-time setup", "Run it again",
            function() if S.ShowSetup then S:ShowSetup() end end,
            "The short setup a new player sees: how you want to level, what Steward does for you, and what it shows.", true))
        mainLayout:AddInitializer(CreateSettingsButtonInitializer("All settings", "Reset to defaults",
            function() if S.ConfirmReset then S:ConfirmReset() end end,
            "Puts every Steward setting back the way it comes, then reloads. Your guide progress, the arrow's place and your action bars are kept.", true))
    end

    -- Guide
    local guidePage, guideLayout = Settings.RegisterVerticalLayoutSubcategory(main, "Guide")
    local gShow, gInit = addCheckbox(guidePage, "guideShow", "Show leveling guide",
        "Shows your guide at the top of the quest tracker. Right-click a step to skip it.")
    local aShow, aInit = addCheckbox(guidePage, "guideArrow", "Show waypoint arrow",
        "An arrow on screen pointing to where the guide wants you to go. Drag it to move it.")
    if aInit and aInit.SetParentInitializer then
        aInit:SetParentInitializer(gInit, function() return gShow:GetValue() end)
    end
    local function arrowOn() return gShow:GetValue() and aShow:GetValue() end
    local _, asInit = addSlider(guidePage, "arrowSize", "Arrow size", "How big the arrow is (its words too).", 50, 200, 10, pct)
    under(asInit, aInit, arrowOn)
    local _, alInit = addCheckbox(guidePage, "arrowLocked", "Lock the arrow in place", "Stops the arrow moving when you drag it by mistake.")
    under(alInit, aInit, arrowOn)
    if guideLayout and CreateSettingsButtonInitializer then
        local bInit = CreateSettingsButtonInitializer("Arrow position", "Put it back",
            function() if S.ResetArrowPosition then S:ResetArrowPosition() end end, "Moves the arrow back above the middle of the screen.", true)
        guideLayout:AddInitializer(bInit)
        under(bInit, aInit, arrowOn)
    end
    -- how the guide is followed (per character); also on the quest log
    if StewardCharDB.guideMode ~= "strict" and StewardCharDB.guideMode ~= "free" then StewardCharDB.guideMode = "guide" end
    local modeSetting = Settings.RegisterAddOnSetting(guidePage, "Steward_guideMode", "guideMode", StewardCharDB, "string",
        "Guide mode", "guide")
    local modeInit = Settings.CreateDropdown(guidePage, modeSetting, function()
        local c = Settings.CreateControlTextContainer()
        c:Add("strict", S.GUIDE_MODE_LABEL.strict)
        c:Add("guide", S.GUIDE_MODE_LABEL.guide)
        c:Add("free", S.GUIDE_MODE_LABEL.free)
        return c:GetData()
    end, "Strict: the guide exactly as written, step by step in its order. Nothing is added or moved.\n\n" ..
        "Guide + my quests: the guide, with your own quests worked in by Steward's routing. The order can change " ..
        "to save walking, and the options below apply.\n\n" ..
        "Free: no guide. Pick up the quests you want; Steward plans the shortest way through your quest log " ..
        "(objectives, then hand-ins). Quests are not accepted for you.\n\nAlso on the Map & Quest Log, at the right end of the bar along the top of the map.")
    S.modeSetting = modeSetting
    if Settings.SetOnValueChangedCallback then
        Settings.SetOnValueChangedCallback("Steward_guideMode", function() S:ApplyGuideMode() end)
    end
    local function smartOn() return modeSetting:GetValue() == "guide" end
    local _, dynInit = addCheckbox(guidePage, "guideDynamic", "Smart routing",
        "Plan the order of the guide's pick-ups, objectives and hand-ins for the least walking from where you are, instead of following the written step order.")
    if dynInit and dynInit.SetParentInitializer then dynInit:SetParentInitializer(modeInit, smartOn) end
    addCheckbox(guidePage, "guideReplacesQuests", "Guide replaces the quest list",
        "While the guide shows, WoW's own quest list is hidden from the tracker (your quest log is unchanged). A quest's usable item gets its own button beside the guide.")
    local _, fillInit = addCheckbox(guidePage, "fillerQuests", "Extra quests instead of grinding",
        "When you're behind the guide's level, Steward leads you to nearby quests the guide skips (never grey ones) until you catch up.")
    if fillInit and fillInit.SetParentInitializer then fillInit:SetParentInitializer(modeInit, smartOn) end
    addCheckbox(guidePage, "objectiveHints", "Objective hints",
        "Names the creature that drops a quest item, and hovering a quest in the quest list shows how far away each objective is.")
    local _, tInit = addCheckbox(guidePage, "guideTravel", "Plan the fastest route to far-away steps",
        "Uses your flight paths, boats, zeppelins, the tram and your hearthstone.")
    if tInit and tInit.SetParentInitializer then
        tInit:SetParentInitializer(gInit, function() return gShow:GetValue() end)
    end
    -- the travel path is a drawing only: changing it touches nothing in the guide
    if S.Path then
        local pShow, pInit = addCheckbox(guidePage, "pathShow", "Draw the way on the map and minimap",
            "A line on the world map and a dotted trail on the minimap from you to where the arrow points. Gold: ground the game's own terrain says can be walked, going round cliffs and water, over the bridges and through the tunnels Steward knows (Kalimdor, the Eastern Kingdoms and Zephras Isle). Faint: a guess, where no walkable way is known (a cave, a tunnel Steward doesn't know, a long steep climb). Ground you have walked yourself is remembered and counts as walkable from then on. It only draws: it never changes what the guide tells you to do.",
            function() S.Path.SettingChanged() end)
        if S.Path3D then
            addCheckbox(guidePage, "path3D", "Use the new 3D routes where they are mapped",
                "On Kalimdor, the Eastern Kingdoms and Zephras Isle the way is worked out on the game's own floors: over the bridges, through buildings and caves, round every tree and rock. Where that cannot answer (a lift, a boat, a spot it has no floor for), and whenever this is off, the way is worked out as before.",
                function() S.Path.SettingChanged() end)
        end
        -- fastest or roads: also switched on the world map and beside the guide's header
        local routeSetting = Settings.RegisterAddOnSetting(guidePage, "Steward_pathRoute", "pathRoute", StewardDB, "string",
            "Route", S.defaults.pathRoute)
        local routeInit = Settings.CreateDropdown(guidePage, routeSetting, function()
            local c = Settings.CreateControlTextContainer()
            c:Add("fastest", "Fastest")
            c:Add("roads", "Stick to roads")
            return c:GetData()
        end, "Fastest: the shortest way to where the arrow points. Stick to roads: keeps to roads, bridges and tunnels wherever they lead there, even if that's longer; safer where the monsters are too high to fight. You can also switch in the world map's top right corner and beside the guide's header. It only changes the line.")
        if routeInit and routeInit.SetParentInitializer then
            routeInit:SetParentInitializer(pInit, function() return pShow:GetValue() end)
        end
        if Settings.SetOnValueChangedCallback then
            Settings.SetOnValueChangedCallback("Steward_pathRoute", function() S.Path.SettingChanged() end)
        end
        -- how that switch looks on the world map
        local styleSetting = Settings.RegisterAddOnSetting(guidePage, "Steward_pathMapSwitch", "pathMapSwitch", StewardDB,
            "string", "Switch on the map", S.defaults.pathMapSwitch)
        local styleInit = Settings.CreateDropdown(guidePage, styleSetting, function()
            local c = Settings.CreateControlTextContainer()
            c:Add("box", "A box with both words")
            c:Add("round", "A round button, like the map's pin")
            return c:GetData()
        end, "How the Fastest / Stick to roads switch looks in the world map's top right corner. A box with both words, the one in use lit gold; or a round button like the map's own pin button, a winged boot for Fastest and a compass for Stick to roads (point at it to see which is on).")
        if styleInit and styleInit.SetParentInitializer then
            styleInit:SetParentInitializer(pInit, function() return pShow:GetValue() end)
        end
        if Settings.SetOnValueChangedCallback then
            Settings.SetOnValueChangedCallback("Steward_pathMapSwitch", function() S.Path.RefreshSwitches() end)
        end
    end
    local _, flyInit = addCheckbox(guidePage, "guideAutoFly", "Take the guide's flights automatically",
        "When you open the flight map, Steward flies you where the guide (or the fastest route) is going. Hold Shift to pick yourself.")
    if flyInit and flyInit.SetParentInitializer then
        flyInit:SetParentInitializer(gInit, function() return gShow:GetValue() end)
    end
    local _, homeInit = addCheckbox(guidePage, "guideAutoHome", "Set your hearthstone where the guide says",
        "When the guide says to make an inn your home, talking to the innkeeper does it. Hold Shift to choose yourself.")
    if homeInit and homeInit.SetParentInitializer then
        homeInit:SetParentInitializer(gInit, function() return gShow:GetValue() end)
    end
    local _, trInit = addCheckbox(guidePage, "guideTraining", "Route me to my class trainer when it's a good time",
        "When you have new abilities to learn, Steward fits a trainer visit in: a short detour, or sooner if you've fallen a few levels behind.")
    if trInit and trInit.SetParentInitializer then
        trInit:SetParentInitializer(gInit, function() return gShow:GetValue() and modeSetting:GetValue() == "guide" end)
    end
    local _, rInitG = addCheckbox(guidePage, "guideReplace", "Hide the quest list while the guide is shown",
        "When off, your normal quest list stays below the guide.")
    if rInitG and rInitG.SetParentInitializer then
        rInitG:SetParentInitializer(gInit, function() return gShow:GetValue() end)
    end

    -- Arrow: pick the arrow from pictures of all of them
    if not S:BuildArrowPage(main) then
        -- no picture page on this client: a plain list instead
        local styleSetting = Settings.RegisterAddOnSetting(guidePage, "Steward_arrowStyle", "arrowStyle", StewardDB,
            "string", "Arrow style", S.defaults.arrowStyle)
        Settings.CreateDropdown(guidePage, styleSetting, function()
            local c = Settings.CreateControlTextContainer()
            for _, st in ipairs(S:ArrowStyles()) do c:Add(st.key, st.label) end
            return c:GetData()
        end, "Pick which of the game's own arrows points the way.")
        if Settings.SetOnValueChangedCallback then
            Settings.SetOnValueChangedCallback("Steward_arrowStyle", function() S:SettingsChanged() end)
        end
    end

    -- Gear
    local gear = Settings.RegisterVerticalLayoutSubcategory(main, "Gear")
    local autoSetting, autoInit = addCheckbox(gear, "gearAuto", "Auto-equip upgrades",
        "Equips better gear from your bags automatically. Waits until combat ends.")
    local _, boeInit = addCheckbox(gear, "gearBoE", "Include bind-on-equip items",
        "When off, bind-on-equip upgrades stay in your bags.")
    if boeInit and boeInit.SetParentInitializer then
        boeInit:SetParentInitializer(autoInit, function() return autoSetting:GetValue() end)
    end
    addCheckbox(gear, "gearTest", "Test mode (don't equip anything)",
        "Steward still works out upgrades but never equips them.")


    -- Quests (accept, hand in, rewards)
    local quests = Settings.RegisterVerticalLayoutSubcategory(main, "Quests")
    local qAccept, qInit = addCheckbox(quests, "questAccept", "Accept quests automatically",
        "Takes quests as soon as you talk to the quest giver. Hold Shift while talking to someone to choose yourself.")
    local whichSetting = Settings.RegisterAddOnSetting(quests, "Steward_questAcceptWhich", "questAcceptWhich",
        StewardDB, "string", "Which quests", S.defaults.questAcceptWhich)
    local whichInit = Settings.CreateDropdown(quests, whichSetting, function()
        local c = Settings.CreateControlTextContainer()
        c:Add("guide", "Quests in my guide")
        c:Add("all", "Every quest (not grey or repeatable)")
        return c:GetData()
    end, "\"Quests in my guide\" keeps your quest log to what your leveling route uses.")
    if whichInit and whichInit.SetParentInitializer then
        whichInit:SetParentInitializer(qInit, function() return qAccept:GetValue() end)
    end
    addCheckbox(quests, "questTurnin", "Turn in finished quests automatically",
        "Hands in any finished quest from your quest log when you talk to the quest giver.")
    addCheckbox(quests, "markQuestMobs", "Mark quest creatures",
        "A skull over a creature you still need for a quest when you point at it or target it.")
    local rAuto, rInit = addCheckbox(quests, "rewardsAuto", "Pick the best reward",
        "When a quest offers a choice, takes the biggest upgrade for your stat priority (main Steward page).")
    local _, sellInit = addCheckbox(quests, "rewardsSell", "If nothing is an upgrade, take the highest vendor price",
        "When off, Steward leaves the choice to you if no reward is an upgrade.")
    if sellInit and sellInit.SetParentInitializer then
        sellInit:SetParentInitializer(rInit, function() return rAuto:GetValue() end)
    end

    -- Look: the LEVEL UP poster. (The console style's bag screen and bags-full prompt are parked until they're ready,
    -- Nick 11-21, so their Style and Button prompt choices are gone for now.)
    local look, lookLayout = Settings.RegisterVerticalLayoutSubcategory(main, "Look")
    local pSet, pInit = addCheckbox(look, "levelupPoster", "LEVEL UP poster",
        "When you level up, a full-screen LEVEL UP poster made for your race and class plays for a few seconds, with what you gained. It waits until you're out of combat, never takes your clicks, and Esc closes it. Made so far: Human Paladin, Human Warrior, Orc Warrior and Gnome Priest.")
    local _, sInit = addCheckbox(look, "levelupSound", "Play the poster's sounds", "The game's own spell sounds, in time with the poster.")
    under(sInit, pInit, function() return pSet:GetValue() end)
    if lookLayout and CreateSettingsButtonInitializer then
        lookLayout:AddInitializer(CreateSettingsButtonInitializer("Level-up poster", "Preview",
            function() if S.LevelUp then S.LevelUp.Preview() end end,
            "Plays your race and class's LEVEL UP poster now (the Human Paladin one if yours isn't made yet). Left-click replays it, right-click shows the next poster, Esc closes it.", true))
    end

    -- Vendor and trainer
    local vendor = Settings.RegisterVerticalLayoutSubcategory(main, "Vendor and trainer")
    addCheckbox(vendor, "vendorSell", "Sell grey items", "Sells every grey item when you open a merchant. Hold Shift to skip.")
    addCheckbox(vendor, "vendorSellGear", "Sell gear you won't wear",
        "Sells white and green armor and weapons that are worse than what you have on, or that you can't use. Never blues, profession tools, fishing poles, shirts or tabards.")
    addCheckbox(vendor, "vendorRepair", "Repair your gear", "Repairs everything at merchants who can, when you have the gold.")
    addCheckbox(vendor, "vendorSellFood", "Sell food and drink you've outgrown",
        "Sells white food and drink when you carry better of the same kind. A mage also sells bought food and water that what you can conjure matches or beats, and doesn't buy them. Never buff food, conjured items or anything above white.")
    local fSet, fInit = addCheckbox(vendor, "vendorFood", "Keep food", "Buys the best food you can eat that the merchant sells. A mage who conjures food at least as good doesn't buy it.")
    local _, fkInit = addSlider(vendor, "foodKeep", "How much food", "Buys up to this many.", 5, 60, 5, tostring)
    under(fkInit, fInit, function() return fSet:GetValue() end)
    local dSet, dInit = addCheckbox(vendor, "vendorDrink", "Keep drinks", "Buys the best drink you can use, if your class uses mana. A mage who conjures water at least as good doesn't buy it.")
    local _, dkInit = addSlider(vendor, "drinkKeep", "How many drinks", "Buys up to this many.", 5, 60, 5, tostring)
    under(dkInit, dInit, function() return dSet:GetValue() end)
    addCheckbox(vendor, "vendorAmmo", "Keep arrows or bullets", "For the bow, crossbow or gun you have on.")
    local rSet, rnInit = addCheckbox(vendor, "vendorRunes", "Keep runes (mage)",
        "A mage who knows a Teleport spell keeps Runes of Teleportation, and one who knows a Portal spell keeps Runes of Portals, when the merchant sells them.")
    local _, rkInit = addSlider(vendor, "runeKeep", "How many of each rune", "Buys up to this many.", 5, 20, 5, tostring)
    under(rkInit, rnInit, function() return rSet:GetValue() end)
    addCheckbox(vendor, "bagsDeleteJunk", "Make room when your bags are full",
        "Off to start with. When your bags are full, Steward offers to delete your cheapest grey item, but only if it's worth it: when looting, only for a quest item or something that sells for more than that grey (then it loots it for you); when a quest hands you an item, always (then it takes the quest again).")
    addCheckbox(vendor, "vendorTrain", "Learn new spells at your class trainer",
        "Learns every spell you can afford as soon as you talk to your trainer.")

    -- Action bars
    local bars, barsLayout = Settings.RegisterVerticalLayoutSubcategory(main, "Action bars")
    addCheckbox(bars, "barsAuto", "Arrange my action bars",
        "Main bar (your keys): rotation and stuns from 1, best heals on 9 0 -, a potion on =. Bar above, left: other heals and " ..
        "defensives, then food, drink and bandages. Bar above, right: buffs. Right edge: mount and hearthstone outside, " ..
        "professions and the rest inside. New spells and better items go in by themselves. Buttons you change by hand are left alone.")
    if barsLayout and CreateSettingsButtonInitializer then
        barsLayout:AddInitializer(CreateSettingsButtonInitializer("Lay out again", "Arrange everything",
            function() S:ResetBars() end, "Clears the bars Steward manages and lays them all out again.", true))
        barsLayout:AddInitializer(CreateSettingsButtonInitializer("Before Steward", "Put my old bars back",
            function() S:RestoreBars() end, "Puts back the buttons you had before Steward arranged them, and stops arranging.", true))
    end

    Settings.RegisterAddOnCategory(main)
    S.category = main
end

function S:OpenOptions()
    if not (self.category and Settings and Settings.OpenToCategory) then return false end
    local id = self.category.GetID and self.category:GetID() or self.category.ID
    Settings.OpenToCategory(id)
    return true
end
