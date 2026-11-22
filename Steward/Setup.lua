local _, S = ...

-- First-time setup (Nick 11-21: "a first time set up for new players"). A new install opens this once, at the first
-- login: how you want to level, what Steward does for you, what it shows. Until it's answered (or skipped) nothing
-- moves your action bars, spends your talent points or swaps your gear (Core.lua: HELD). Someone already using
-- Steward never sees it; anyone can open it again from Options > Steward ("First-time setup: Run it again").
-- Made from the game's own window parts, like its options.

local W, H = 560, 470
local win, pages, page, mode, groups

-- each line is one choice; it turns several settings on or off together
local DO = {
    { label = "Pick up and hand in quests", note = "Takes the guide's quests when you talk to the quest giver, and hands in finished ones.",
      keys = { "questAccept", "questTurnin" } },
    { label = "Choose quest rewards", note = "The biggest upgrade for your spec; if none is, the one that sells for most.",
      keys = { "rewardsAuto", "rewardsSell" } },
    { label = "Equip upgrades", note = "Puts on better gear from your bags (after a fight, never during one).", keys = { "gearAuto" } },
    { label = "Sell junk, repair, keep food, drink and ammo", note = "At any merchant. Hold Shift when you open one to skip it.",
      keys = { "vendorSell", "vendorSellGear", "vendorRepair", "vendorSellFood", "vendorFood", "vendorDrink", "vendorAmmo", "vendorRunes" } },
    { label = "Learn new spells at your trainer", note = "Learns everything you can afford, and the guide fits a trainer visit in.",
      keys = { "vendorTrain", "guideTraining" } },
    { label = "Spend talent points", note = "Follows a leveling build for your spec. Hold Shift as you level to leave a point.", keys = { "talentsAuto" } },
    { label = "Arrange my action bars", note = "Moves your buttons into a set layout and adds new spells. Options can put your old bars back.",
      keys = { "barsAuto" } },
    { label = "Take the guide's flights and set my hearthstone", note = "When you open the flight map or talk to the innkeeper it's sending you to.",
      keys = { "guideAutoFly", "guideAutoHome" } },
}
local SHOW = {
    { label = "The guide, at the top of the quest tracker", note = "Right-click a step to skip it.", keys = { "guideShow" } },
    { label = "An arrow pointing the way", note = "Drag it where you like.", keys = { "guideArrow" } },
    { label = "The way, drawn on the map and minimap", note = "Round cliffs and water, over bridges and through tunnels.", keys = { "pathShow" } },
    { label = "What to press next in combat", note = "A strip of icons above your bars; the button lights up. It never presses anything.",
      keys = { "rotationHelper" } },
    { label = "Missing buffs", note = "Out of combat, the button for a long buff you're missing lights up gold.", keys = { "buffReminders" } },
    { label = "A skull over quest creatures", note = "When you point at a creature you still need for a quest.", keys = { "markQuestMobs" } },
    { label = "Dungeon notes", note = "A short card of tips when you enter a dungeon.", keys = { "dungeonNotes" } },
    { label = "A LEVEL UP poster when you level up", note = "For some race and class pairs so far; it waits until you're out of combat.",
      keys = { "levelupPoster" } },
}
local MODES = {
    { key = "guide", label = "Guide + my quests  (recommended)",
      note = "Follow the guide. Quests you pick up yourself are worked in, and the order is planned to save walking." },
    { key = "strict", label = "Strict", note = "The guide exactly as written, step by step, in its order." },
    { key = "free", label = "Free", note = "No guide. Pick up the quests you want; Steward plans the shortest way through them." },
}

local function allOn(keys)
    for _, k in ipairs(keys) do if not S:GetStored(k) then return false end end
    return true
end

local function text(parent, font, str, x, y, w)
    local fs = parent:CreateFontString(nil, "OVERLAY", font)
    fs:SetPoint("TOPLEFT", x, y)
    if w then fs:SetWidth(w) end
    fs:SetJustifyH("LEFT")
    fs:SetText(str)
    return fs
end

-- a list of tick boxes, each with a grey line under it saying what it does
local function tickList(parent, list, y0)
    local boxes = {}
    for i, item in ipairs(list) do
        local y = y0 - (i - 1) * 40
        local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 22, y)
        cb:SetSize(26, 26)
        if cb.SetHitRectInsets then cb:SetHitRectInsets(0, -(W - 110), 0, -12) end -- the words click it too
        text(parent, "GameFontHighlight", item.label, 52, y - 4)
        text(parent, "GameFontDisableSmall", item.note, 52, y - 20, W - 90)
        cb.item = item
        boxes[i] = cb
    end
    return boxes
end

local function finish()
    for _, cb in ipairs(groups or {}) do
        for _, k in ipairs(cb.item.keys) do StewardDB[k] = cb:GetChecked() and true or false end
    end
    StewardDB.setupDone = true
    if mode then S:SetGuideMode(mode) end
    win:Hide()
    S:SettingsChanged()
    if S.Path and S.Path.SettingChanged then pcall(S.Path.SettingChanged) end
end

local function skip()
    StewardDB.setupDone = true
    win:Hide()
    S:SettingsChanged()
end

local function showPage(i)
    page = i
    for j, p in ipairs(pages) do p:SetShown(j == i) end
    win.count:SetText(i > 1 and ((i - 1) .. " of 3") or "")
    win.back:SetShown(i > 1)
    win.skip:SetShown(i == 1)
    win.next:SetText(i == #pages and "Finish" or (i == 1 and "Set it up" or "Next"))
end

local function build()
    win = CreateFrame("Frame", "StewardSetup", UIParent, "BasicFrameTemplateWithInset")
    win:SetSize(W, H)
    win:SetPoint("CENTER", 0, 40)
    win:SetFrameStrata("DIALOG")
    win:SetMovable(true)
    win:EnableMouse(true)
    win:RegisterForDrag("LeftButton")
    win:SetScript("OnDragStart", win.StartMoving)
    win:SetScript("OnDragStop", win.StopMovingOrSizing)
    win:SetClampedToScreen(true)
    -- the template's own title, or one of ours if this client's template has none
    local title = type(win.TitleText) == "table" and win.TitleText or nil
    if not title then
        title = win:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOP", 0, -5)
    end
    title:SetText("Steward setup")
    if UISpecialFrames then table.insert(UISpecialFrames, "StewardSetup") end -- Esc closes it; it comes back next login

    pages = {}
    local function newPage()
        local p = CreateFrame("Frame", nil, win)
        p:SetPoint("TOPLEFT", 8, -28)
        p:SetPoint("BOTTOMRIGHT", -8, 44)
        pages[#pages + 1] = p
        return p
    end

    -- 1: welcome
    local p1 = newPage()
    text(p1, "GameFontNormalHuge", "Welcome to Steward", 22, -22)
    text(p1, "GameFontHighlight",
        "Steward levels with you. It shows a guide with an arrow and a planned route, and it can pick up and hand in " ..
        "quests, equip upgrades, sell your junk, learn your spells and more, so you can just play.\n\n" ..
        "Three short questions set it up the way you like. Nothing changes your action bars, talents or gear until " ..
        "you've answered or skipped them.\n\n" ..
        "You can change any of it later: Esc > Options > AddOns > Steward.", 22, -62, W - 70)

    -- 2: how to level
    local p2 = newPage()
    text(p2, "GameFontNormalLarge", "How do you want to level?", 22, -14)
    text(p2, "GameFontDisableSmall", "For this character. Also on the quest log, at the top right of the map.", 22, -36, W - 70)
    p2.radios = {}
    for i, m in ipairs(MODES) do
        local y = -64 - (i - 1) * 64
        local r = CreateFrame("CheckButton", nil, p2, "UIRadioButtonTemplate")
        r:SetPoint("TOPLEFT", 24, y)
        r.key = m.key
        if r.SetHitRectInsets then r:SetHitRectInsets(0, -(W - 100), 0, -22) end
        text(p2, "GameFontHighlight", m.label, 48, y - 1)
        text(p2, "GameFontDisableSmall", m.note, 48, y - 18, W - 90)
        r:SetScript("OnClick", function(self)
            mode = self.key
            for _, o in ipairs(p2.radios) do o:SetChecked(o == self) end
        end)
        p2.radios[i] = r
    end

    -- 3: what it does for you
    local p3 = newPage()
    text(p3, "GameFontNormalLarge", "What should Steward do for you?", 22, -10)
    p3.boxes = tickList(p3, DO, -34)

    -- 4: what it shows
    local p4 = newPage()
    text(p4, "GameFontNormalLarge", "What should it show?", 22, -10)
    p4.boxes = tickList(p4, SHOW, -34)

    groups = {}
    for _, b in ipairs(p3.boxes) do groups[#groups + 1] = b end
    for _, b in ipairs(p4.boxes) do groups[#groups + 1] = b end

    -- the buttons along the bottom
    local function button(label, w)
        local b = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        b:SetSize(w or 110, 24)
        b:SetText(label)
        return b
    end
    win.next = button("Next", 120)
    win.next:SetPoint("BOTTOMRIGHT", -14, 12)
    win.next:SetScript("OnClick", function() if page == #pages then finish() else showPage(page + 1) end end)
    win.back = button("Back", 90)
    win.back:SetPoint("RIGHT", win.next, "LEFT", -8, 0)
    win.back:SetScript("OnClick", function() showPage(page - 1) end)
    win.skip = button("Skip, keep the defaults", 190)
    win.skip:SetPoint("BOTTOMLEFT", 14, 12)
    win.skip:SetScript("OnClick", skip)
    win.count = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    win.count:SetPoint("BOTTOMLEFT", 18, 18)
end

-- open it, showing what's set now
function S:ShowSetup()
    if InCombatLockdown and InCombatLockdown() then return false end
    if not win then build() end
    mode = self:GuideMode()
    for _, r in ipairs(pages[2].radios) do r:SetChecked(r.key == mode) end
    for _, cb in ipairs(groups) do cb:SetChecked(allOn(cb.item.keys)) end
    showPage(1)
    win:Show()
    return true
end

-- Options: put every setting back the way it comes, then reload (progress, positions and bars are kept)
function S:ConfirmReset()
    StaticPopupDialogs.STEWARD_RESET = StaticPopupDialogs.STEWARD_RESET or {
        text = "Put every Steward setting back the way it comes? The game will reload.",
        button1 = YES or "Yes", button2 = NO or "No",
        OnAccept = function() S:ResetSettings() if ReloadUI then ReloadUI() end end,
        timeout = 0, whileDead = true, hideOnEscape = true,
    }
    StaticPopup_Show("STEWARD_RESET")
end
function S:ResetSettings()
    for k, v in pairs(self.defaults) do StewardDB[k] = v end
    if StewardCharDB then StewardCharDB.guideMode = "guide" end
    StewardDB.uiStyle = "blizzard"
end

-- a new install: open it at the first login, once you're in the world and out of combat
local asked = false
S:On("PLAYER_ENTERING_WORLD", function()
    if asked or not (StewardDB and StewardDB.setupDone == false) then return end
    asked = true
    C_Timer.After(2, function()
        if StewardDB.setupDone ~= false then return end
        if not S:ShowSetup() then
            -- in a fight: wait for it to end
            S:On("PLAYER_REGEN_ENABLED", function() if StewardDB.setupDone == false and not (win and win:IsShown()) then S:ShowSetup() end end)
        end
    end)
end)

-- for the simulator's checks
function S.SetupPages() return pages end
