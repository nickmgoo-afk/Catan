local _, S = ...

-- First-time setup (Nick 11-21: "a first time set up for new players"; then "as long as everything is included in the
-- first time set up"). A new install opens this once, at the first login, and it holds every setting Steward has, page
-- by page: how you level and your spec, quests, gear and talents, merchants and trainers, the guide, the arrow and the
-- map, combat and the rest. Until it's answered (or skipped) nothing moves your action bars, spends your talent points
-- or swaps your gear (Core.lua: HELD). Someone already using Steward never sees it; Options > Steward has "First-time
-- setup: Run it again". Choices are kept on the page and only saved by Finish; Esc or the X leaves everything as it was.
-- Made from the game's own window parts, like its options.

local W, H = 620, 540
local ROW = 36
local win, pages, page, pending, mode, spec, controls

---------------------------------------------------------------- what each page asks
-- check: a tick box for a setting (parent: only when that one is on; when: only if this returns true)
-- amount: a tick box with a number beside it (key2 the number, min/max/step)
-- choice: a setting with two to four answers, side by side
-- cycle: one of many (the arrow's look, your spec), stepped through with < and >
local function smartMode() return mode == "guide" end
local PAGES = {
    { title = "Quests", rows = {
        { "check", "questAccept", "Accept quests automatically", "When you talk to the quest giver. Hold Shift to choose yourself." },
        { "choice", "questAcceptWhich", "Which quests", nil, parent = "questAccept",
          options = { { "guide", "Quests in my guide" }, { "all", "Every quest (not grey or repeatable)" } } },
        { "check", "questTurnin", "Hand in finished quests", "Any finished quest in your log, when you talk to its quest giver." },
        { "check", "rewardsAuto", "Choose quest rewards", "The biggest upgrade for your spec." },
        { "check", "rewardsSell", "If none is an upgrade, take the one that sells for most", nil, parent = "rewardsAuto" },
        { "check", "markQuestMobs", "Mark quest creatures", "A skull over a creature you still need, when you point at it." },
        { "check", "objectiveHints", "Objective hints", "Which creature drops a quest item, and how far each objective is." },
    } },
    { title = "Gear, talents and action bars", rows = {
        { "check", "gearAuto", "Equip upgrades", "Better gear from your bags, after a fight (never during one)." },
        { "check", "gearBoE", "Include bind-on-equip items", "When off, they stay in your bags.", parent = "gearAuto" },
        { "check", "gearTest", "Test mode: work out upgrades but never equip them", nil, parent = "gearAuto" },
        { "check", "lootRolls", "Roll Need or Greed on gear in groups", "Need on upgrades for your spec you can wear; Greed on other gear. Hold Shift to roll yourself." },
        { "check", "talentsAuto", "Spend talent points", "A leveling build for your spec. Hold Shift as you level to leave one." },
        { "check", "barsAuto", "Arrange my action bars", "Moves your buttons into a set layout. Options can put your old bars back." },
    } },
    { title = "Merchants and trainers", rows = {
        { "check", "vendorSell", "Sell grey items", "At any merchant. Hold Shift when you open one to skip everything." },
        { "check", "vendorSellGear", "Sell white and green gear you won't wear", "Never blues, tools, fishing poles, shirts or tabards." },
        { "check", "vendorRepair", "Repair your gear", "At merchants who can, when you have the gold." },
        { "check", "vendorSellFood", "Sell food and drink you've outgrown", "When you carry better of the same kind." },
        { "amount", "vendorFood", "Keep food", "The best you can eat that the merchant sells.", key2 = "foodKeep", min = 5, max = 60, step = 5 },
        { "amount", "vendorDrink", "Keep drinks", "If your class uses mana.", key2 = "drinkKeep", min = 5, max = 60, step = 5 },
        { "check", "vendorAmmo", "Keep arrows or bullets", "For the bow, crossbow or gun you have on." },
        { "amount", "vendorRunes", "Keep runes (mage)", "For the Teleport and Portal spells you know.", key2 = "runeKeep", min = 5, max = 20, step = 5 },
        { "check", "bagsDeleteJunk", "Make room when your bags are full", "Offers to delete your cheapest grey item for something worth more." },
        { "check", "vendorTrain", "Learn new spells at your trainer", "Everything you can afford, as soon as you talk to them." },
    } },
    { title = "The guide", rows = {
        { "check", "guideShow", "Show the guide", "At the top of the quest tracker. Right-click a step to skip it." },
        { "check", "guideReplacesQuests", "The guide takes the quest list's place in the tracker", "Your quest log itself is unchanged.", parent = "guideShow" },
        { "check", "guideReplace", "Hide the quest list while the guide shows", nil, parent = "guideShow" },
        { "check", "guideDynamic", "Smart routing", "Do the guide's steps in the order that walks the least.", when = smartMode },
        { "check", "fillerQuests", "Extra quests instead of grinding", "When you're behind the guide's level.", when = smartMode },
        { "check", "guideTraining", "Fit class training in", "A trainer visit when you have new spells to learn.", when = smartMode },
        { "check", "guideTravel", "Plan the fastest way to far-away steps", "Flight paths, boats, zeppelins, the tram and your hearthstone." },
        { "check", "guideAutoFly", "Take the guide's flights", "When you open the flight map. Hold Shift to pick yourself." },
        { "check", "guideAutoHome", "Set your hearthstone where the guide says", "Talking to that innkeeper does it. Hold Shift to choose." },
    } },
    { title = "The arrow and the map", rows = {
        { "check", "guideArrow", "Show the arrow", "Points to where the guide wants you to go. Drag it to move it." },
        { "cycle", "arrowStyle", "Arrow look", nil, parent = "guideArrow", list = "arrows" },
        { "amount", nil, "Arrow size", nil, parent = "guideArrow", key2 = "arrowSize", min = 50, max = 200, step = 10, pct = true },
        { "check", "arrowLocked", "Lock the arrow in place", nil, parent = "guideArrow" },
        { "check", "pathShow", "Draw the way on the map and minimap", "Round cliffs and water, over bridges and through tunnels.", needs = "Path" },
        { "check", "path3D", "Use the 3D routes where they are mapped", "Over bridges, through buildings and caves.", parent = "pathShow", needs = "Path3D" },
        { "choice", "pathRoute", "Route", nil, parent = "pathShow", needs = "Path",
          options = { { "fastest", "Fastest" }, { "roads", "Stick to roads" } } },
        { "choice", "pathMapSwitch", "Switch on the world map", nil, parent = "pathShow", needs = "Path",
          options = { { "box", "A box with both words" }, { "round", "A round button" } } },
    } },
    { title = "Combat and the rest", rows = {
        { "check", "rotationHelper", "Show what to press next in combat", "It never presses anything for you." },
        { "check", "rotationStrip", "A strip of icons above your bars", nil, parent = "rotationHelper" },
        { "check", "rotationGlow", "Light up the button on your bars", nil, parent = "rotationHelper" },
        { "amount", nil, "Strip size", nil, parent = "rotationHelper", key2 = "rotationSize", min = 50, max = 200, step = 10, pct = true },
        { "check", "buffReminders", "Remind me of missing buffs", "Out of combat, the button for a long buff you're missing lights up." },
        { "check", "dungeonNotes", "Dungeon notes", "A short card of tips when you enter a dungeon." },
        { "check", "levelupPoster", "LEVEL UP poster", "Made for some race and class pairs so far. Waits until you're out of combat." },
        { "check", "levelupSound", "With its sounds", nil, parent = "levelupPoster" },
        { "check", "reloadButton", "A Reload button at the top of the screen", "Handy while trying settings out." },
    } },
}
local MODES = {
    { "guide", "Guide + my quests  (recommended)", "Follow the guide. Quests you pick up are worked in; the order is planned to save walking." },
    { "strict", "Strict", "The guide exactly as written, step by step, in its order." },
    { "free", "Free", "No guide. Pick up the quests you want; Steward plans the shortest way through them." },
}

---------------------------------------------------------------- the parts
local function text(parent, font, str, x, y, w)
    local fs = parent:CreateFontString(nil, "OVERLAY", font)
    fs:SetPoint("TOPLEFT", x, y)
    if w then fs:SetWidth(w) end
    fs:SetJustifyH("LEFT")
    fs:SetText(str or "")
    return fs
end
local function button(parent, label, w, h)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(w or 110, h or 24)
    b:SetText(label)
    return b
end

-- is a row in play: its parent setting on, and its own condition true
local function live(row)
    if row.needs and not S[row.needs] then return false end
    if row.parent and not pending[row.parent] then return false end
    if row.when and not row.when() then return false end
    return true
end

local refresh -- every control shows pending's value, greyed where it doesn't apply

local function rowCheck(p, row, y)
    local x = row.parent and 46 or 22
    local cb = CreateFrame("CheckButton", nil, p, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", x, y)
    cb:SetSize(26, 26)
    if cb.SetHitRectInsets then cb:SetHitRectInsets(0, -(W - 160 - x), 0, row[4] and -12 or 0) end -- the words click it too
    local label = text(p, "GameFontHighlight", row[3], x + 30, y - 5)
    if row[4] then text(p, "GameFontDisableSmall", row[4], x + 30, y - 21, W - 110 - x) end
    cb:SetScript("OnClick", function(self) pending[row[2]] = self:GetChecked() and true or false refresh() end)
    cb.Sync = function()
        local on = live(row)
        cb:SetChecked(pending[row[2]] and true or false)
        cb:SetEnabled(on)
        label:SetFontObject(on and "GameFontHighlight" or "GameFontDisable")
    end
    controls[row[2]] = cb
    return cb
end

-- a number with - and + (an amount to keep, a size in percent)
local function stepper(p, row, y)
    local f = CreateFrame("Frame", nil, p)
    f:SetSize(120, 24)
    f:SetPoint("TOPRIGHT", p, "TOPRIGHT", -18, y - 1)
    local minus = button(f, "-", 26, 22)
    minus:SetPoint("LEFT")
    local plus = button(f, "+", 26, 22)
    plus:SetPoint("RIGHT")
    local val = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    val:SetPoint("CENTER")
    local function step(d)
        local v = (tonumber(pending[row.key2]) or row.min) + d * row.step
        pending[row.key2] = math.max(row.min, math.min(row.max, v))
        refresh()
    end
    minus:SetScript("OnClick", function() step(-1) end)
    plus:SetScript("OnClick", function() step(1) end)
    f.Sync = function()
        local on = live(row) and (not row[2] or pending[row[2]])
        local v = tonumber(pending[row.key2]) or row.min
        val:SetText(row.pct and (v .. "%") or tostring(v))
        val:SetFontObject(on and "GameFontHighlight" or "GameFontDisable")
        minus:SetEnabled(on and v > row.min)
        plus:SetEnabled(on and v < row.max)
    end
    f.step = step
    controls[row.key2] = f
    return f
end

local function rowAmount(p, row, y)
    local parts = {}
    if row[2] then parts[1] = rowCheck(p, row, y)
    else
        local x = row.parent and 52 or 28
        local label = text(p, "GameFontHighlight", row[3], x, y - 5)
        parts[1] = { Sync = function() label:SetFontObject(live(row) and "GameFontHighlight" or "GameFontDisable") end }
    end
    parts[2] = stepper(p, row, y)
    return { Sync = function() for _, c in ipairs(parts) do c.Sync() end end }
end

-- two to four answers side by side, under the setting's name
local function rowChoice(p, row, y)
    local x = row.parent and 52 or 28
    local label = text(p, "GameFontHighlight", row[3], x, y - 3)
    local radios, rx = {}, x + 4
    for i, o in ipairs(row.options) do
        local r = CreateFrame("CheckButton", nil, p, "UIRadioButtonTemplate")
        r:SetPoint("TOPLEFT", rx, y - 19)
        local l = text(p, "GameFontHighlightSmall", o[2], rx + 20, y - 21)
        local w = (l.GetStringWidth and l:GetStringWidth() or 100)
        if r.SetHitRectInsets then r:SetHitRectInsets(0, -(w + 6), 0, 0) end
        rx = rx + 20 + math.max(60, w) + 18
        r:SetScript("OnClick", function() pending[row[2]] = o[1] refresh() end)
        radios[i] = { r = r, l = l, v = o[1] }
    end
    local c = { radios = radios }
    c.Sync = function()
        local on = live(row)
        label:SetFontObject(on and "GameFontHighlight" or "GameFontDisable")
        for _, it in ipairs(radios) do
            it.r:SetChecked(pending[row[2]] == it.v)
            it.r:SetEnabled(on)
            it.l:SetFontObject(on and "GameFontHighlightSmall" or "GameFontDisableSmall")
        end
    end
    controls[row[2]] = c
    return c
end

-- one of many, stepped with < and > (the arrow's look; on the first page, your spec)
local function cycleList(row)
    if row.list == "arrows" then
        local out = {}
        for _, st in ipairs(S:ArrowStyles() or {}) do out[#out + 1] = { st.key, st.label } end
        return out
    end
    return row.list
end
local function rowCycle(p, row, y, get, set)
    local x = row.parent and 52 or 28
    local label = text(p, "GameFontHighlight", row[3], x, y - 5)
    local f = CreateFrame("Frame", nil, p)
    f:SetSize(300, 24)
    f:SetPoint("TOPRIGHT", p, "TOPRIGHT", -18, y - 1)
    local prev = button(f, "<", 26, 22)
    prev:SetPoint("LEFT")
    local nextB = button(f, ">", 26, 22)
    nextB:SetPoint("RIGHT")
    local val = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    val:SetPoint("CENTER")
    get = get or function() return pending[row[2]] end
    set = set or function(v) pending[row[2]] = v end
    local function at()
        local list = cycleList(row)
        for i, o in ipairs(list) do if o[1] == get() then return i, list end end
        return 1, list
    end
    local function step(d)
        local i, list = at()
        if #list == 0 then return end
        set(list[(i - 1 + d) % #list + 1][1])
        refresh()
    end
    prev:SetScript("OnClick", function() step(-1) end)
    nextB:SetScript("OnClick", function() step(1) end)
    local c = { step = step }
    c.Sync = function()
        local on = live(row)
        local i, list = at()
        val:SetText(list[i] and list[i][2] or "")
        val:SetFontObject(on and "GameFontHighlight" or "GameFontDisable")
        label:SetFontObject(on and "GameFontHighlight" or "GameFontDisable")
        prev:SetEnabled(on and #list > 1)
        nextB:SetEnabled(on and #list > 1)
    end
    controls[row[2]] = c
    return c
end

local HEIGHT = { check = ROW, amount = ROW, choice = 44, cycle = 32 }
local function buildRows(p, rows, y0)
    p.controls = {}
    local y = y0
    for _, row in ipairs(rows) do
        if not row.needs or S[row.needs] then
            local kind = row[1]
            local c
            if kind == "check" then c = rowCheck(p, row, y)
            elseif kind == "amount" then c = rowAmount(p, row, y)
            elseif kind == "choice" then c = rowChoice(p, row, y)
            elseif kind == "cycle" then c = rowCycle(p, row, y) end
            p.controls[#p.controls + 1] = c
            y = y - (((kind == "check" or kind == "amount") and not row[4]) and 30 or HEIGHT[kind])
        end
    end
end

refresh = function()
    for _, p in ipairs(pages) do
        for _, c in ipairs(p.controls or {}) do c.Sync() end
    end
end

---------------------------------------------------------------- the window
local function finish()
    for k, v in pairs(pending) do StewardDB[k] = v end
    StewardDB.setupDone = true
    if StewardCharDB and spec then StewardCharDB.gearSpec = spec end
    if mode then S:SetGuideMode(mode) end
    win:Hide()
    S:SettingsChanged()
    if S.UpdateSpecButtons then pcall(S.UpdateSpecButtons, S) end
    if S.Path then
        if S.Path.SettingChanged then pcall(S.Path.SettingChanged) end
        if S.Path.RefreshSwitches then pcall(S.Path.RefreshSwitches) end
    end
end

local function skip()
    StewardDB.setupDone = true
    win:Hide()
    S:SettingsChanged()
end

local function showPage(i)
    page = i
    for j, p in ipairs(pages) do p:SetShown(j == i) end
    win.count:SetText(i > 1 and ((i - 1) .. " of " .. (#pages - 1)) or "")
    win.back:SetShown(i > 1)
    win.skip:SetShown(i == 1)
    win.next:SetText(i == #pages and "Finish" or (i == 1 and "Set it up" or "Next"))
end

local function build()
    win = CreateFrame("Frame", "StewardSetup", UIParent, "BasicFrameTemplateWithInset")
    win:SetSize(W, H)
    win:SetPoint("CENTER", 0, 30)
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

    pages, controls = {}, {}
    local function newPage(heading)
        local p = CreateFrame("Frame", nil, win)
        p:SetPoint("TOPLEFT", 8, -28)
        p:SetPoint("BOTTOMRIGHT", -8, 44)
        if heading then text(p, "GameFontNormalLarge", heading, 22, -12) end
        pages[#pages + 1] = p
        return p
    end

    -- welcome
    local p1 = newPage()
    text(p1, "GameFontNormalHuge", "Welcome to Steward", 22, -22)
    text(p1, "GameFontHighlight",
        "Steward levels with you. It shows a guide with an arrow and a planned route, and it can pick up and hand in " ..
        "quests, equip upgrades, sell your junk, learn your spells and more, so you can just play.\n\n" ..
        "The next pages go through everything it can do, so you can set it up the way you like. " ..
        "Nothing changes your action bars, talents or gear until you've finished or skipped.\n\n" ..
        "You can change any of it later: Esc > Options > AddOns > Steward.", 22, -62, W - 70)

    -- how you level, and your spec
    local p2 = newPage("How do you want to level?")
    text(p2, "GameFontDisableSmall", "For this character. Also on the quest log, at the top right of the map.", 22, -34, W - 70)
    p2.radios = {}
    for i, m in ipairs(MODES) do
        local y = -56 - (i - 1) * 46
        local r = CreateFrame("CheckButton", nil, p2, "UIRadioButtonTemplate")
        r:SetPoint("TOPLEFT", 24, y)
        r.key = m[1]
        if r.SetHitRectInsets then r:SetHitRectInsets(0, -(W - 100), 0, -16) end
        text(p2, "GameFontHighlight", m[2], 48, y - 1)
        text(p2, "GameFontDisableSmall", m[3], 48, y - 18, W - 90)
        r:SetScript("OnClick", function(self)
            mode = self.key
            for _, o in ipairs(p2.radios) do o:SetChecked(o == self) end
            refresh()
        end)
        p2.radios[i] = r
    end
    text(p2, "GameFontNormalLarge", "Your spec", 22, -206)
    text(p2, "GameFontDisableSmall", "Sets your stat priority (gear, rewards), the talent build, your action bars and the combat helper. " ..
        "Auto-detect follows your talents; below level 10 every character uses its class's first spec.", 22, -228, W - 70)
    local specRow = { "cycle", "gearSpec", "Spec", list = {} }
    specRow.list[1] = { "auto", "Auto-detect" }
    for _, name in ipairs(S:ClassSpecs() or {}) do specRow.list[#specRow.list + 1] = { name, name } end
    p2.controls = { rowCycle(p2, specRow, -262, function() return spec end, function(v) spec = v end) }

    -- every setting, page by page
    for _, def in ipairs(PAGES) do
        local p = newPage(def.title)
        buildRows(p, def.rows, -38)
    end

    win.next = button(win, "Next", 120)
    win.next:SetPoint("BOTTOMRIGHT", -14, 12)
    win.next:SetScript("OnClick", function() if page == #pages then finish() else showPage(page + 1) end end)
    win.back = button(win, "Back", 90)
    win.back:SetPoint("RIGHT", win.next, "LEFT", -8, 0)
    win.back:SetScript("OnClick", function() showPage(page - 1) end)
    win.skip = button(win, "Skip, keep the defaults", 190)
    win.skip:SetPoint("BOTTOMLEFT", 14, 12)
    win.skip:SetScript("OnClick", skip)
    win.count = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    win.count:SetPoint("BOTTOMLEFT", 18, 18)
end

-- open it, showing what's set now
function S:ShowSetup()
    if InCombatLockdown and InCombatLockdown() then return false end
    if not win then build() end
    pending = {}
    for _, def in ipairs(PAGES) do
        for _, row in ipairs(def.rows) do
            if row[2] then pending[row[2]] = self:GetStored(row[2]) end
            if row.key2 then pending[row.key2] = self:GetStored(row.key2) end
        end
    end
    mode = self:GuideMode()
    spec = (StewardCharDB and StewardCharDB.gearSpec) or "auto"
    for _, r in ipairs(pages[2].radios) do r:SetChecked(r.key == mode) end
    refresh()
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
    if StewardCharDB then StewardCharDB.guideMode = "guide" StewardCharDB.gearSpec = "auto" end
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

-- for the simulator's checks: the pages, a control by setting name, the page as it stands
function S.SetupPages() return pages end
function S.SetupControl(key) return controls and controls[key] end
function S.SetupPending() return pending end
S.SETUP_PAGES = PAGES
