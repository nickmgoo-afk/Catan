local _, S = ...

-- Steward's new look (2026-11-20; Nick picked the black / white / red mockup). First window: the bags-full prompt.
-- 0.70.4 (Nick: "doesn't look very clean"): the slanted parts are smooth pictures (Media\\Bags*.tga, drawn 4x and
-- shrunk by design/wow/bags.py) and the words are Inter, one font family, shipped in Media under its open licence.
local BLACK, WHITE, RED, GREY = { 0.043, 0.043, 0.051 }, { 1, 1, 1 }, { 1, 0.169, 0.239 }, { 0.79, 0.79, 0.81 }

local P = {}
S.Persona = P

local MEDIA = "Interface\\AddOns\\Steward\\Media\\"
-- Steward's fonts: Inter (SIL Open Font License, Media\\Inter-OFL.txt), with the game's own as the fallback
local fontOK = {}
local function setFont(fs, file, size, flags)
    local paths = { MEDIA .. file, STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", "Fonts\\FRIZQT__.TTF" }
    for _, path in ipairs(paths) do
        local ok, done = pcall(fs.SetFont, fs, path, size, flags or "")
        if ok and done ~= false then
            if not fontOK[file] then
                fontOK[file] = path
                if StewardDB then StewardDB.caps = StewardDB.caps or {} StewardDB.caps.font = path end
            end
            return
        end
    end
    if fs.SetFontObject and _G.GameFontNormalHuge then fs:SetFontObject(GameFontNormalHuge) end -- never without a font
end
P.SetFont = setFont
local function heavy(fs, size) setFont(fs, "InterBlackItalic.ttf", size) end
local function boldText(fs, size) setFont(fs, "InterBold.ttf", size) end

-- a picture from Media, cropped to w x h of its cw x ch canvas
local function pic(parent, layer, file, w, h, cw, ch)
    local t = parent:CreateTexture(nil, layer)
    t:SetTexture(MEDIA .. file)
    t:SetTexCoord(0, w / cw, 0, h / ch)
    t:SetSize(w, h)
    return t
end

local function words(parent, size, color)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    heavy(fs, size)
    fs:SetTextColor(color[1], color[2], color[3])
    return fs
end

-- a button: its picture, a lit picture for the mouse, and its words
local function button(parent, kind)
    local w = kind == "red" and 236 or 140
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w + 8, 56)
    b:SetHitRectInsets(0, 8, 0, 8) -- not the shadow
    local file = kind == "red" and "BagsBtnRed" or "BagsBtnWhite"
    b.face = pic(b, "ARTWORK", file, w + 8, 56, 256, 64)
    b.face:SetPoint("TOPLEFT")
    b.lit = pic(b, "ARTWORK", file .. "Lit", w + 8, 56, 256, 64)
    b.lit:SetPoint("TOPLEFT")
    b.lit:Hide()
    b.words = words(b, 21, kind == "red" and WHITE or BLACK)
    b.words:SetPoint("CENTER", b, "TOPLEFT", w / 2, -24)
    b.kind = kind
    b:SetScript("OnEnter", function(self)
        self.face:Hide() self.lit:Show()
        if self.kind == "red" then self.words:SetTextColor(RED[1], RED[2], RED[3]) else self.words:SetTextColor(1, 1, 1) end
    end)
    b:SetScript("OnLeave", function(self)
        self.lit:Hide() self.face:Show()
        local c = self.kind == "red" and WHITE or BLACK
        self.words:SetTextColor(c[1], c[2], c[3])
    end)
    return b
end

-- one item card: its picture (shape and label), the item's icon and name, its worth in big numbers
local function card(parent, file, outlined)
    local c = CreateFrame("Frame", nil, parent)
    c:SetSize(236, 96)
    c.bg = pic(c, "BACKGROUND", file, 236, 96, 256, 128)
    c.bg:SetPoint("TOPLEFT")
    c.icon = c:CreateTexture(nil, "ARTWORK")
    c.icon:SetSize(30, 30)
    c.icon:SetPoint("TOPLEFT", c, "TOPLEFT", 16, -28)
    c.name = c:CreateFontString(nil, "OVERLAY")
    boldText(c.name, 15)
    c.name:SetTextColor(1, 1, 1)
    c.name:SetPoint("LEFT", c.icon, "RIGHT", 8, 0)
    c.name:SetPoint("RIGHT", c, "RIGHT", -12, 0)
    c.name:SetJustifyH("LEFT")
    c.name:SetWordWrap(true)
    c.worth = words(c, 26, outlined and WHITE or GREY)
    c.worth:SetPoint("BOTTOMLEFT", c, "BOTTOMLEFT", 14, 7)
    c:EnableMouse(true)
    c:SetScript("OnEnter", function(self)
        if not (self.link and GameTooltip) then return end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        pcall(GameTooltip.SetHyperlink, GameTooltip, self.link)
        GameTooltip:Show()
    end)
    c:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    return c
end

local function fill(c, it, worth)
    c.link = it and it.link
    -- the item's name in its quality colour, without the brackets
    local link = it and tostring(it.link or "") or ""
    local color, name = link:match("^(|c%x%x%x%x%x%x%x%x)"), link:match("%[(.-)%]") or link
    c.name:SetText((color or "") .. (name ~= "" and name or "?") .. (color and "|r" or "")
        .. ((it and (it.count or 1) > 1) and (" x" .. it.count) or ""))
    local icon = it and it.icon
    if not icon and it and it.link and C_Item and C_Item.GetItemIconByID then
        local id = tonumber(tostring(it.link):match("item:(%d+)"))
        if id then local ok, tex = pcall(C_Item.GetItemIconByID, id) if ok then icon = tex end end
    end
    c.icon:SetTexture(icon or 134400) -- the question mark
    c.worth:SetText(worth or "")
end

-- shared with the other console screens (PersonaItems.lua)
P.MEDIA, P.Pic, P.Words, P.Heavy, P.BoldText = MEDIA, pic, words, heavy, boldText
P.BLACK, P.WHITE, P.RED, P.GREY = BLACK, WHITE, RED, GREY

local win
local function build()
    if win then return win end
    local f = CreateFrame("Frame", "StewardBagsFull", UIParent)
    f:SetSize(580, 300)
    f:SetPoint("TOP", UIParent, "TOP", 0, -150) -- below the game's red "Inventory is full." line
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    f:EnableMouse(true)
    f:Hide()
    -- the sheet, its shadow and the BAGS FULL! banner are one picture (Media\\BagsSheet, made by design/wow/bags.py)
    f.sheet = pic(f, "BACKGROUND", "BagsSheet", 580, 300, 1024, 512)
    f.sheet:SetPoint("TOPLEFT")
    -- the slam: the whole prompt drops in
    local okA, ag = pcall(f.CreateAnimationGroup, f)
    if okA and ag then
        local a = ag:CreateAnimation("Alpha")
        if a.SetFromAlpha then a:SetFromAlpha(0) a:SetToAlpha(1) end
        a:SetDuration(0.12)
        local s = ag:CreateAnimation("Scale")
        if s.SetScaleFrom then s:SetScaleFrom(1.08, 1.08) s:SetScaleTo(1, 1) end
        s:SetDuration(0.18)
        if s.SetSmoothing then s:SetSmoothing("OUT") end
        f.slam = ag
    end
    f.give = card(f, "BagsCardDelete", false)
    f.give:SetPoint("TOPLEFT", f, "TOPLEFT", 40, -112)
    f.get = card(f, "BagsCardLoot", true)
    f.get:SetPoint("TOPLEFT", f, "TOPLEFT", 292, -112)
    f.yes = button(f, "red")
    f.yes:SetPoint("TOPLEFT", f, "TOPLEFT", 40, -222)
    f.no = button(f, "white")
    f.no:SetPoint("TOPLEFT", f, "TOPLEFT", 296, -222)
    f.no.words:SetText("KEEP")
    f.no:SetScript("OnClick", function() f:Hide() end)
    f.yes:SetScript("OnClick", function()
        local yes = f.onYes
        f:Hide()
        if yes then
            local ok, err = pcall(yes)
            if not ok then S:LogError("bagsfull", err) end
        end
    end)
    f:SetScript("OnHide", function(self) self.onYes, self.mode = nil, nil end)
    if UISpecialFrames then table.insert(UISpecialFrames, "StewardBagsFull") end -- Escape closes it
    win = f
    return f
end

-- the bags-full prompt. `o` = { junk = { link, count, worth }, loot = { link, count, worth, quest } or nil,
-- money = function, onYes = function }. Returns true when shown.
function P.BagsFull(o)
    local okB, f = pcall(build)
    if not okB or not f then
        if not okB then S:LogError("bagsfull", f) end
        return false
    end
    local m = o.money
    fill(f.give, o.junk, m(o.junk.worth))
    if o.loot then
        local worth = o.loot.quest and "QUEST" or (o.loot.worth and m(o.loot.worth) or "MORE")
        fill(f.get, o.loot, worth)
        f.get:Show()
        f.yes.words:SetText("DELETE & LOOT")
        f.mode = "loot"
    else
        f.get:Hide()
        f.yes.words:SetText("DELETE IT")
        f.mode = "quest"
    end
    f.onYes = o.onYes
    f:Show()
    f:Raise()
    if f.slam then f.slam:Stop() f.slam:Play() end
    if PlaySound and SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON then pcall(PlaySound, SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end
    return true
end
-- the console style is on (Options > Steward > Look)
-- the console look's own screens (the bag screen, the bags-full prompt) are parked until they're ready (Nick 11-21)
function P.On() return false end
-- which prompts to show: "keyboard", "xbox" or "playstation" (auto: a controller when the game has one switched on)
function P.Prompts()
    local p = S:Get("buttonPrompts") or "auto"
    if p ~= "auto" then return p end
    -- a controller only when one is actually connected (the game's controller support alone is on for many players:
    -- 0.70.7 showed Xbox buttons to a keyboard player)
    local gp = _G.C_GamePad
    if gp and gp.IsEnabled and (pcall(gp.IsEnabled)) and select(2, pcall(gp.IsEnabled)) == true then
        if gp.GetActiveDeviceID then
            local ok, id = pcall(gp.GetActiveDeviceID)
            if ok and type(id) == "number" and id >= 0 then return "xbox" end
        end
        if gp.GetAllDeviceIDs then
            local ok, ids = pcall(gp.GetAllDeviceIDs)
            if ok and type(ids) == "table" and #ids > 0 then return "xbox" end
        end
    end
    return "keyboard"
end
-- the label for an action's button, e.g. P.Key("use") -> "R-CLICK" / "A" / "CROSS"
local KEYS = {
    keyboard = { use = "R-CLICK", back = "ESC", left = "Q", right = "E", sort = "R", link = "SHIFT", destroy = "DEL" },
    xbox = { use = "A", back = "B", left = "LB", right = "RB", sort = "Y", link = "X", destroy = "X" },
    playstation = { use = "CROSS", back = "CIRCLE", left = "L1", right = "R1", sort = "TRIANGLE", link = "SQUARE", destroy = "SQUARE" },
}
function P.Key(action) return (KEYS[P.Prompts()] or KEYS.keyboard)[action] or action:upper() end
-- switched to Blizzard: close Steward's windows now
function P.StyleChanged()
    if not P.On() and win then win:Hide() end
    if S.PersonaItems then pcall(S.PersonaItems.StyleChanged) end
end
function P.BagsFullShown() return win and win:IsShown() and win.mode or nil end
S:On("LOOT_CLOSED", function() if win and win.mode == "loot" then win:Hide() end end)

-- load Steward's fonts once at login, so no window is the first to use them (a font still loading can leave words blank)
S:On("PLAYER_LOGIN", function()
    local pre = CreateFrame("Frame", nil, UIParent)
    pre:SetSize(1, 1) pre:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -50, 50) pre:SetAlpha(0.01)
    for _, file in ipairs({ "InterBlackItalic.ttf", "InterBold.ttf" }) do
        for _, size in ipairs({ 13, 15, 18, 22, 26 }) do
            local fs = pre:CreateFontString(nil, "OVERLAY")
            setFont(fs, file, size)
            fs:SetPoint("TOPLEFT")
            fs:SetText("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        end
    end
    C_Timer.After(5, function() pre:Hide() end)
end)
