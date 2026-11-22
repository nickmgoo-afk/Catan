local _, S = ...

-- The guide mode on the Map & Quest Log: a dropdown in the game's own style at the right end of the
-- map's navigation bar. The same setting as Options > Steward > Guide > Guide mode; changing either
-- changes both. If the map isn't laid out the way this expects, no dropdown is added (the options
-- panel still has it) and StewardDB.modeDiag says what was found.

local dd, placed = nil, false
local WIDTH = 132

local function diag()
    StewardDB = StewardDB or {}
    StewardDB.modeDiag = StewardDB.modeDiag or {}
    return StewardDB.modeDiag
end

local function questList()
    local qm = _G.QuestMapFrame
    local qs = (qm and qm.QuestsFrame) or _G.QuestScrollFrame
    return qm, qs
end

local function tooltipText(m)
    if m == "strict" then return "The guide exactly as written, step by step in its order. Nothing is added or moved." end
    if m == "guide" then return "The guide, with your own quests worked in by Steward's routing. The order can change to save walking." end
    return "No guide. Steward plans the shortest way through the quests in your log. Quests are not accepted for you."
end

-- the game's current dropdown (11.0 and later)
local function makeModern(parent)
    local f = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
    f:SetupMenu(function(_, root)
        root:CreateTitle("Steward guide mode")
        for _, m in ipairs(S.GUIDE_MODES) do
            local r = root:CreateRadio(S.GUIDE_MODE_LABEL[m], function() return S:GuideMode() == m end,
                function() S:SetGuideMode(m) end)
            if r and r.SetTooltip then
                r:SetTooltip(function(tip) GameTooltip_SetTitle(tip, S.GUIDE_MODE_LABEL[m]) GameTooltip_AddNormalLine(tip, tooltipText(m)) end)
            end
        end
    end)
    f.refresh = function() if f.GenerateMenu then f:GenerateMenu() end end
    return f
end

-- the older dropdown, for clients without the new menus
local function makeClassic(parent)
    local f = CreateFrame("Frame", "StewardGuideModeDropdown", parent, "UIDropDownMenuTemplate")
    UIDropDownMenu_SetWidth(f, WIDTH - 30)
    UIDropDownMenu_Initialize(f, function()
        for _, m in ipairs(S.GUIDE_MODES) do
            local info = UIDropDownMenu_CreateInfo()
            info.text, info.value = S.GUIDE_MODE_LABEL[m], m
            info.checked = S:GuideMode() == m
            info.tooltipTitle, info.tooltipText, info.tooltipOnButton = S.GUIDE_MODE_LABEL[m], tooltipText(m), true
            info.func = function() S:SetGuideMode(m) CloseDropDownMenus() end
            UIDropDownMenu_AddButton(info)
        end
    end)
    f.refresh = function() UIDropDownMenu_SetText(f, S.GUIDE_MODE_LABEL[S:GuideMode()]) end
    return f
end

-- Forever's "Map & Quest Log" (Midnight style) has no room in the quest list's search row (search box, the
-- "Quests: n/40" counter and the settings button fill it), and its search box isn't where the 11.x one is.
-- The dropdown goes in the map's dark navigation bar instead, at its right end (the breadcrumb starts at
-- the left), the way Blizzard puts its own map controls along that bar.
local function navBar()
    local wm = _G.WorldMapFrame
    return wm and (wm.NavBar or (wm.BorderFrame and wm.BorderFrame.NavBar))
end

local function place()
    if placed then return end
    local qm, qs = questList()
    local d = diag()
    d.questMapFrame, d.questsFrame = qm ~= nil, qs ~= nil
    local nav = navBar()
    d.navBar = nav ~= nil
    if not nav then return end
    placed = true
    d.navWidth, d.navHeight = nav:GetWidth(), nav:GetHeight()
    local ok, f = pcall(makeModern, nav)
    d.kind = ok and "modern" or nil
    if not ok then
        d.modernError = tostring(f)
        ok, f = pcall(makeClassic, nav)
        d.kind = ok and "classic" or nil
        if not ok then d.classicError = tostring(f) return end
    end
    dd = f
    dd:SetSize(WIDTH + 18, math.min(math.max((nav:GetHeight() or 0) - 6, 20), 26))
    dd:ClearAllPoints()
    dd:SetPoint("RIGHT", nav, "RIGHT", -8, 0)
    if dd.SetFrameLevel and nav.GetFrameLevel then dd:SetFrameLevel((nav:GetFrameLevel() or 1) + 10) end
    d.placedOK = true
    dd.refresh()
end

function S:RefreshModeControls()
    if dd and dd.refresh then pcall(dd.refresh) end
end

local hooked = false
local function hook()
    if hooked then return end
    local qm = _G.WorldMapFrame or questList()
    if not (qm and qm.HookScript) then return end
    hooked = true
    qm:HookScript("OnShow", function()
        local ok, err = pcall(place)
        if not ok then diag().error = tostring(err) end
        S:RefreshModeControls()
    end)
end

S:On("PLAYER_LOGIN", function() pcall(hook) end)
S:On("ADDON_LOADED", function() if not hooked then pcall(hook) end end)
