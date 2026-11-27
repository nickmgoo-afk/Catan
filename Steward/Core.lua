local ADDON, S = ...
_G.Steward = S

local GetMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or _G.GetAddOnMetadata
S.version = (GetMeta and GetMeta(ADDON, "Version")) or "?"

S.defaults = {
    gearAuto = true,       -- auto-equip upgrades
    gearBoE = true,        -- include bind-on-equip items
    gearTest = false,      -- test mode: never equip
    gearSpec = "auto",     -- stat priority: "auto" or a spec name
    questAccept = true,    -- take quests when you talk to the quest giver
    questAcceptWhich = "guide", -- "guide": the quests your guide uses; "all": every quest
    questTurnin = true,    -- hand in finished quests
    rewardsAuto = true,    -- pick the best quest reward
    lootRolls = true,      -- group loot: Need on gear upgrades for your spec, Greed on other gear (Rolls.lua)
    vendorSell = true,     -- sell grey items at merchants
    vendorSellGear = true, -- sell white and green gear you won't wear
    vendorRepair = true,   -- repair at merchants that can
    vendorSellFood = true, -- sell food and drink you've outgrown (better carried, or a mage's conjured is as good)
    vendorFood = true,     -- top up food
    vendorDrink = true,    -- top up drink (mana users)
    vendorAmmo = true,     -- top up arrows or bullets for your ranged weapon
    vendorRunes = true,    -- a mage keeps runes for the Teleport and Portal spells they know
    vendorTrain = true,    -- learn every spell you can afford at your class trainer
    trainProfessions = true, -- and every recipe and rank you can afford at a trainer of a profession you have (0.89.8)
    demonBooks = true,     -- a warlock buys the demon books Wowhead's leveling pages list, at the Demon Trainer (0.90.8)
    barsAuto = true,       -- arrange the action bars and keep them up to date
    talentsAuto = true,    -- spend talent points along a leveling build for your spec
    rotationHelper = true, -- in combat, show what to press next and light up its button
    buffReminders = true,  -- out of combat, light up a long buff (blessing, aura, armor) you're missing
    dungeonNotes = true,   -- a short card of tips when you enter a dungeon
    objectiveHints = true, -- what drops quest items, and how far away the guide's spot is
    fillerQuests = true,   -- behind on levels: extra quests nearby instead of grinding
    uiStyle = "blizzard", -- the console look's bag screen and bags-full prompt are parked (Nick 11-21: not ready); kept for later
    buttonPrompts = "auto", -- the button prompts the console look shows: auto, keyboard, xbox, playstation
    levelupPoster = true,  -- the LEVEL UP poster when you level up (Human Paladin, Human Warrior, Orc Warrior, Gnome Priest)
    levelupSound = true,   -- the poster plays the game's own sounds with it
    bagsDeleteJunk = true, -- bags full: delete the cheapest grey, no asking (1.0.5), on your next key press or click, if what you are looting is worth more (or a quest item)
    arrowSize = 100,       -- the guide arrow's size, in percent
    arrowLocked = false,   -- the guide arrow can't be dragged
    rotationStrip = true,  -- the rotation helper's strip of icons above the bars
    rotationGlow = true,   -- the rotation helper lights up the button on your bars
    rotationSize = 100,    -- the strip's size, in percent
    foodKeep = 20,         -- how much food to keep (vendorFood)
    drinkKeep = 20,        -- how much drink to keep (vendorDrink)
    runeKeep = 10,         -- how many of each rune a mage keeps (vendorRunes)
    markQuestMobs = true,  -- a skull over quest creatures you mouse over or target
    reloadButton = false,  -- a Reload button at the top of the screen (off for new players since 0.79.0; on for Nick, who set it)
    guideReplacesQuests = true, -- the guide takes the place of WoW's quest list in the tracker
    rewardsSell = true,    -- no upgrade: take the highest vendor price
    guideShow = true,      -- show the leveling guide in the quest tracker
    guideDungeons = false, -- the guide's dungeon route (Skyborne mage: their chapters 40-92 with dungeons); off = solo route
    guideDynamic = true,   -- smart routing: do the guide's tasks in the order that walks the least
    guideArrow = true,     -- on-screen arrow pointing to the next waypoint
    chatNotes = false,     -- 1.1.2: Steward's notes in chat (off: Nick 11-27 "I don't want steward to be making notes in chat")
    profGuide = true,      -- 1.1.0: your professions' next steps (Wowhead's Forever guides) in the tracker
    profBuy = true,        -- 1.1.0: buy the recipe, rank book and vendor materials for your profession step at merchants
    rxpRoute = false,      -- plan the trip to RestedXP's waypoint (its arrow's spot) when RestedXP Guides is running
    mapStepSpots = true,   -- gold dots on the world map (0.90.0) and minimap (0.90.1) for the step's other spots still to do
    arrowStyle = "navigation", -- which of the game's arrows to use
    guideTravel = true,    -- plan the fastest route when the next spot is far away
    -- what trips may use (the guide's, your map pin's, "Travel to" a group member; Nick 11-22: "I need travel options,
    -- like more, to disable flight paths and hearthstoning")
    travelFly = true,      -- flight paths
    travelHearth = true,   -- your Hearthstone
    travelTeleport = true, -- a mage's or druid's teleport spells
    travelBoats = true,    -- boats, zeppelins and skycutters
    guideAutoFly = true,   -- take the guide's flight as soon as you open the flight map
    guideAutoHome = true,  -- make the inn your home when the guide says to
    guideTraining = true,  -- fit class training in when new abilities are available
    guideReplace = false,  -- hide the quest list while the guide is shown
    guideCollapsed = false,
}

-- Midnight-engine clients hide some values inside dungeons, raids and battlegrounds
-- ("secret values"); doing math or comparisons on them is an error. Check first.
function S.Secret(...)
    local check = _G.issecretvalue
    if not check then return false end
    for i = 1, select("#", ...) do
        if check((select(i, ...))) then return true end
    end
    return false
end

-- the guide, arrow and travel planner only run in the open world
function S.InInstance()
    local inside = IsInInstance and IsInInstance()
    return inside and true or false
end

local frame = CreateFrame("Frame")
S.frame = frame
S.handlers = {}

function S:On(event, fn)
    if not self.handlers[event] then
        local ok = pcall(frame.RegisterEvent, frame, event)
        if not ok then return false end
        self.handlers[event] = {}
    end
    table.insert(self.handlers[event], fn)
    return true
end

frame:SetScript("OnEvent", function(_, event, ...)
    local list = S.handlers[event]
    if not list then return end
    local outer = S.curEvent
    S.curEvent, S.outerEvent = event, outer   -- which of Steward's handlers is running (for the blocked-action note)
    for i = 1, #list do
        local ok, err = pcall(list[i], ...)
        if not ok then S:LogError(event, err) end
    end
    S.curEvent, S.outerEvent = outer, nil
end)

-- keep the last few errors in the saved data so they can be read after a reload
function S:LogError(where, err)
    if StewardCharDB then
        StewardCharDB.errors = StewardCharDB.errors or {}
        -- with the date and the version: the log keeps the last 20, which can span days and updates
        table.insert(StewardCharDB.errors, date("%m-%d %H:%M:%S") .. " " .. tostring(S.version or "?") .. " " .. tostring(where) .. ": " .. tostring(err))
        while #StewardCharDB.errors > 20 do table.remove(StewardCharDB.errors, 1) end
    end
    -- show each problem on screen once per session; the rest only go in the log
    S.shownErrors = S.shownErrors or {}
    local key = tostring(where) .. tostring(err):sub(1, 80)
    if not S.shownErrors[key] then
        S.shownErrors[key] = true
        geterrorhandler()(err)
    end
end

-- 1.1.2 (Nick 2026-11-27: "I don't want steward to be making notes in chat"): Steward's notes stay out of chat
-- (they still go in its saved logs); the answers to your own /steward commands still show. Switch: chatNotes.
function S:Print(msg)
    if not (S.inSlash or S:Get("chatNotes")) then return end
    print("|cffffd100Steward:|r " .. tostring(msg))
end

-- How the guide is followed (per character): "strict" = the fixed guide, exactly as written, in its
-- order, nothing added; "guide" = the fixed guide plus your own quests, worked in by the router
-- (the only mode where smart routing may change the guide's order); "free" = no guide, the router
-- plans the shortest way through what's in your quest log.
S.GUIDE_MODES = { "strict", "guide", "free" }
S.GUIDE_MODE_LABEL = { strict = "Strict", guide = "Guide + my quests", free = "Free" }
function S:GuideMode()
    local m = _G.StewardCharDB and StewardCharDB.guideMode
    if m == "strict" or m == "free" then return m end
    return "guide"
end
-- the parts of Steward that change the guide's order or add to it: only in "Guide + my quests"
local SMART = { guideDynamic = true, fillerQuests = true, guideTraining = true }

-- what waits for the first-time setup: nothing moves your buttons, spends your points or swaps your gear before you've said
local HELD = { barsAuto = true, talentsAuto = true, gearAuto = true }

-- one service of the open trainer window: name, rank (or ""), category ("available", "unavailable", "used").
-- Forever's client answers GetTrainerServiceInfo as name, category, icon, ... (Nick's trainDiag of 2026-11-22: "Polearms |
-- available | 135129"), where classic gives name, rank, category, icon: the category is taken wherever it is, so neither
-- client makes Steward think nothing is on offer (0.88.3; Nick 2026-11-15: "isn't this supposed to train for me?")
local SERVICE_KIND = { available = true, unavailable = true, used = true }
function S.TrainerService(i)
    if not GetTrainerServiceInfo then return nil end
    local r = { GetTrainerServiceInfo(i) }
    local name, rank, category = r[1], nil, nil
    for k = 2, 4 do
        local v = r[k]
        if type(v) == "string" then
            if SERVICE_KIND[v] then
                category = v
                break
            elseif not rank then
                rank = v
            end
        end
    end
    return name, rank or "", category
end

function S:Get(key)
    if SMART[key] and self:GuideMode() ~= "guide" then return false end
    if HELD[key] and _G.StewardDB and StewardDB.setupDone == false then return false end
    -- Free: you pick your own quests
    if key == "questAccept" and self:GuideMode() == "free" then return false end
    local db = _G.StewardDB
    if db and db[key] ~= nil then return db[key] end
    return self.defaults[key]
end

-- the raw stored value (the options panel shows what you set, whatever the mode)
function S:GetStored(key)
    local db = _G.StewardDB
    if db and db[key] ~= nil then return db[key] end
    return self.defaults[key]
end

function S:SetGuideMode(m)
    if m ~= "strict" and m ~= "guide" and m ~= "free" then return end
    -- through the options panel's setting when there is one, so both places show the same
    if self.modeSetting and self.modeSetting.SetValue then
        if self:GuideMode() ~= m then self.modeSetting:SetValue(m) end
        return
    end
    StewardCharDB = StewardCharDB or {}
    if StewardCharDB.guideMode == m then return end
    StewardCharDB.guideMode = m
    self:ApplyGuideMode()
end

function S:ApplyGuideMode()
    if self.G then self.G.plan, self.G.free, self.G.filler = nil, nil, nil end
    if self.RouteForget then self:RouteForget() end
    self:SettingsChanged()
    if self.RefreshModeControls then self:RefreshModeControls() end
end

function S:Set(key, value)
    _G.StewardDB[key] = value
    self:SettingsChanged()
end

-- called whenever a setting changes (from the panel or a slash command)
function S:SettingsChanged()
    if self.ClearItemCache then self:ClearItemCache() end
    if self.ScheduleGear then self:ScheduleGear(0.2) end
    if self.ApplyArrowStyle then self:ApplyArrowStyle() end
    if self.UpdateReloadButton then self:UpdateReloadButton() end
    if self.QueueBars and self:Get("barsAuto") then self:QueueBars(0.5) end
    if self.G then
        if self:Get("guideShow") and not self.G.guide and self.PickGuide then
            local g, fresh, startStep = self:PickGuide()
            if g then self:LoadGuide(g, fresh, startStep) end
        elseif self.UpdateGuide then
            self:UpdateGuide()
        end
        if self.RefreshGuideUI then self:RefreshGuideUI() end
    end
end

-- Opening the world map from Steward's own click during a fight makes every pin the map lays down a blocked
-- action (Blizzard_MapCanvas AcquirePin -> CheckMouseButtonPassthrough -> SetPassThroughButtons, protected in
-- combat): 20 "blocked: ADDON_ACTION_BLOCKED Button:SetPassThroughButtons()" at 11-22 15:57:16. So in a fight
-- Steward leaves the map alone; the player's own map key still works.
S.MAP_IN_FIGHT = "In a fight the game doesn't let add-ons open the map: use your map key."
function S.OpenMapAt(mapID)
    if InCombatLockdown and InCombatLockdown() then return false end
    if not (C_Map and C_Map.OpenWorldMap) then return false end
    return (pcall(C_Map.OpenWorldMap, mapID))
end

-- when the game blocks something Steward did ("Interface action failed because of an AddOn"), write down what
-- (2026-11-20: Nick saw it on the bags-full prompt's DELETE & LOOT)
for _, ev in ipairs({ "ADDON_ACTION_BLOCKED", "ADDON_ACTION_FORBIDDEN" }) do
    S:On(ev, function(addon, func)
        if addon ~= ADDON then return end
        S:LogError("blocked", ev .. " " .. tostring(func) .. (S.step and (" during " .. S.step) or "")
            .. (S.outerEvent and (" in " .. S.outerEvent) or ""))
        -- 1.0.3: where it came from. The game tells add-ons right away, so the Lua stack still holds the code that
        -- made the call (the SetPassThroughButtons bursts with the map open in a fight: 11-22, 11-23, 11-26).
        -- One per minute, the last 8, in StewardCharDB.blockedStacks.
        local now = GetTime()
        if StewardCharDB and (not S.lastBlockedStack or now - S.lastBlockedStack > 60) and debugstack then
            S.lastBlockedStack = now
            local list = StewardCharDB.blockedStacks or {}
            StewardCharDB.blockedStacks = list
            local wm = _G.WorldMapFrame
            table.insert(list, 1, {
                when = date("%m-%d %H:%M:%S"), what = ev .. " " .. tostring(func), event = S.outerEvent,
                fight = InCombatLockdown and InCombatLockdown() or false, map = wm and wm.IsShown and wm:IsShown() or false,
                stack = tostring(debugstack(2, 14, 0)):sub(1, 2500),
            })
            list[9] = nil
        end
    end)
end
-- the game's own taint log (Logs\taint.log), level 1: what an add-on touched before a blocked action. Turned on
-- once (1.0.3) to find the map's SetPassThroughButtons bursts; StewardDB.taintLogOn notes that Steward did it.
S:On("PLAYER_LOGIN", function()
    if StewardDB and not StewardDB.taintLogOn and GetCVar and SetCVar and GetCVar("taintLog") == "0" then
        if pcall(SetCVar, "taintLog", "1") then StewardDB.taintLogOn = true end
    end
end)

S:On("ADDON_LOADED", function(name)
    if name ~= ADDON then return end
    -- a new install gets the first-time setup (Setup.lua); someone already using Steward keeps their settings
    local fresh = StewardDB == nil or next(StewardDB) == nil
    StewardDB = StewardDB or {}
    if StewardDB.setupDone == nil then StewardDB.setupDone = not fresh end
    -- the console look is parked (Nick 11-21): its bag screen and bags-full prompt aren't ready
    StewardDB.uiStyle = "blizzard"
    if StewardDB.newLook == false and StewardDB.uiStyle == nil then StewardDB.uiStyle = "blizzard" end -- 0.70.2-0.70.4
    StewardDB.newLook = nil
    for k, v in pairs(S.defaults) do
        if StewardDB[k] == nil then StewardDB[k] = v end
    end
    StewardCharDB = StewardCharDB or {}
    if S.InitOptions then
        local ok, err = pcall(S.InitOptions, S)
        if not ok then
            S.optionsError = err
            S:Print("couldn't add the options page (" .. tostring(err) .. ").")
        end
    end
    if S.InitTooltip then pcall(S.InitTooltip, S) end
end)

local function onoff(v) return v and "|cff20ff20on|r" or "|cffff2020off|r" end

local TOGGLES = {
    auto = { "gearAuto", "Auto-equip upgrades" },
    boe = { "gearBoE", "Include bind-on-equip items" },
    test = { "gearTest", "Test mode" },
    rewards = { "rewardsAuto", "Auto-pick quest rewards" },
    sell = { "rewardsSell", "Vendor-price fallback for rewards" },
}

SLASH_STEWARD1 = "/steward"
local slashCommand
SlashCmdList.STEWARD = function(msg)
    S.inSlash = true
    local ok, err = pcall(slashCommand, msg)
    S.inSlash = nil
    if not ok then S:LogError("slash", err) end
end
slashCommand = function(msg)
    local cmd, rest = (msg or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")
    if TOGGLES[cmd] then
        local key, label = TOGGLES[cmd][1], TOGGLES[cmd][2]
        S:Set(key, not S:Get(key))
        S:Print(label .. ": " .. onoff(S:Get(key)))
    elseif cmd == "spec" then
        if rest == "" or rest == "auto" then
            S:Set("gearSpec", "auto")
        else
            local found
            for _, name in ipairs(S:ClassSpecs()) do
                if name:lower() == rest then found = name end
            end
            if not found then S:Print("unknown spec: " .. rest) return end
            S:Set("gearSpec", found)
        end
        S:Print("stat priority: " .. S:SpecLabel())
    elseif cmd == "travel" then
        -- "/steward travel Name": travel to that group member; "/steward travel" alone stops
        local who = (msg or ""):match("^%s*%S+%s+(%S+)")
        if not who then S:FollowMember(nil) return end
        for _, m in ipairs(S.GroupMembers and S:GroupMembers() or {}) do
            if m.name:lower() == who:lower() then S:FollowMember(m.name) return end
        end
        S:Print(who .. " isn't in your group.")
    elseif cmd == "status" then
        S:Print("v" .. S.version .. " | spec: " .. S:SpecLabel())
        for _, k in ipairs({ "auto", "boe", "test", "rewards", "sell" }) do
            print("  " .. TOGGLES[k][2] .. ": " .. onoff(S:Get(TOGGLES[k][1])))
        end
    elseif cmd == "why" then
        S:ExplainGear()
    elseif cmd == "reloadbutton" then
        S:Set("reloadButton", not S:Get("reloadButton"))
        if S.UpdateReloadButton then S:UpdateReloadButton() end
        S:Print("Reload button: " .. onoff(S:Get("reloadButton")))
    elseif cmd == "scan" then
        S:RunScan()
    else
        if not (S.OpenOptions and S:OpenOptions()) then
            S:Print("type /steward status to see your settings")
        end
    end
end
