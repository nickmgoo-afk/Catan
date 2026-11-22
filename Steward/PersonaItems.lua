local _, S = ...

-- The console-style Items screen (2026-11-20, Nick: "I want this to FEEL like I'm playing a console game"; mock-up
-- design/wow/bag_mock2.png). It takes the place of the game's bags while Options > Steward > Look is on Console:
-- the game's bag windows still open and close as always (B, the bag buttons, a merchant), but they sit inside a hidden
-- frame and this screen shows instead. Each row IS the game's own bag button (ContainerFrameItemButtonTemplate),
-- restyled, so right-click to use, equip or sell, dragging and shift-click all work as before, in combat too.
local P = S.Persona
local I = {}
S.PersonaItems = I

local BLACK, WHITE, RED, GREY = P.BLACK, P.WHITE, P.RED, P.GREY
local VISIBLE = 7 -- rows in view
local TABS = {
    { key = "all", label = "ALL" }, { key = "gear", label = "GEAR" }, { key = "use", label = "USE" },
    { key = "quest", label = "QUEST" }, { key = "trade", label = "TRADE" }, { key = "junk", label = "JUNK" },
}
local CAT_ORDER = { use = 1, gear = 2, quest = 3, trade = 4, other = 5, junk = 6 }

local function money(c)
    c = math.floor(c or 0)
    local g, s, cp = math.floor(c / 10000), math.floor(c / 100) % 100, c % 100
    if g > 0 then return string.format("%dg %ds %dc", g, s, cp) end
    if s > 0 then return string.format("%ds %dc", s, cp) end
    return cp .. "c"
end

local function itemInfo(x)
    local f = (C_Item and C_Item.GetItemInfo) or _G.GetItemInfo
    if not f then return end
    local ok, name, link, quality, ilvl, req, itype, isub, stack, equipLoc, icon, sell, classID = pcall(f, x)
    if ok then return name, link, quality, ilvl, req, itype, isub, stack, equipLoc, icon, sell, classID end
end

local function category(bag, slot, info, classID)
    if info.quality == 0 then return "junk" end
    local qi = C_Container.GetContainerItemQuestInfo and C_Container.GetContainerItemQuestInfo(bag, slot)
    if classID == 12 or (type(qi) == "table" and (qi.isQuestItem or qi.questID)) then return "quest" end
    if classID == 2 or classID == 4 then return "gear" end
    if classID == 0 then return "use" end
    if classID == 7 or classID == 5 or classID == 3 or classID == 9 then return "trade" end
    return "other"
end

---------------------------------------------------------------- the window
local f, rows, holders, entries, sel, top, tab = nil, {}, {}, {}, 1, 1, 1
local buttonFor = {} -- [bag * 100 + slot] = the game's bag button, restyled

local function keyCap(parent)
    local k = CreateFrame("Frame", nil, parent)
    k:SetSize(40, 24)
    k.bg = P.Pic(k, "BACKGROUND", "ItemsKey", 64, 24, 64, 32)
    k.bg:SetAllPoints()
    k.key = P.Words(k, 11, BLACK)
    k.key:SetPoint("CENTER", k, "CENTER", 1, 0)
    k.label = P.Words(k, 15, WHITE)
    k.label:SetPoint("LEFT", k, "RIGHT", 7, 0)
    return k
end
local function setKey(k, key, label)
    k.key:SetText(key)
    k:SetWidth(12 + #key * 8)
    k.label:SetText(label)
    k:Show()
end

local function restyle(b)
    -- the game's bag button, made into a list row: our own row pictures, icon, name and count; theirs hidden
    b:SetSize(462, 40)
    local name = b.GetName and b:GetName()
    for _, key in ipairs({ "icon", "Count", "Stock", "searchOverlay", "ItemContextOverlay", "IconBorder", "IconOverlay",
        "IconOverlay2", "IconQuestTexture", "NewItemTexture", "BattlepayItemTexture", "flash", "JunkIcon", "UpgradeIcon",
        "ExtendedSlot", "ExtendedOverlay", "ExtendedOverlay2" }) do
        local r = b[key] or (name and _G[name .. key])
        if type(r) == "table" and r.SetAlpha then pcall(r.SetAlpha, r, 0) end
    end
    local tex = name and _G[name .. "IconTexture"]
    if type(tex) == "table" and tex.SetAlpha then tex:SetAlpha(0) end
    for _, get in ipairs({ "GetNormalTexture", "GetPushedTexture", "GetHighlightTexture" }) do
        local okT, t = pcall(b[get] or function() end, b)
        if okT and type(t) == "table" and t.SetAlpha then t:SetAlpha(0) end
    end
    b.sBg = P.Pic(b, "BACKGROUND", "ItemsRow", 462, 40, 512, 64)
    b.sBg:SetPoint("TOPLEFT")
    b.sLit = P.Pic(b, "BACKGROUND", "ItemsRowLit", 500, 72, 512, 128)
    b.sLit:SetPoint("TOPLEFT", b, "TOPLEFT", -8, 6)
    b.sLit:Hide()
    b.sIconBg = b:CreateTexture(nil, "BORDER")
    b.sIconBg:SetColorTexture(1, 1, 1, 1)
    b.sIconBg:SetSize(34, 34)
    b.sIcon = b:CreateTexture(nil, "ARTWORK")
    b.sIcon:SetSize(30, 30)
    b.sIcon:SetPoint("LEFT", b, "LEFT", 8, 0)
    b.sIconBg:SetPoint("CENTER", b.sIcon, "CENTER")
    local cd = b.Cooldown or (name and _G[name .. "Cooldown"])
    if type(cd) == "table" and cd.SetAllPoints then cd:ClearAllPoints() cd:SetAllPoints(b.sIcon) end
    b.sName = b:CreateFontString(nil, "OVERLAY")
    P.BoldText(b.sName, 18)
    b.sName:SetPoint("LEFT", b.sIcon, "RIGHT", 14, 0)
    b.sName:SetPoint("RIGHT", b, "RIGHT", -70, 0)
    b.sName:SetJustifyH("LEFT")
    b.sName:SetWordWrap(false)
    b.sCount = P.Words(b, 18, GREY)
    b.sCount:SetPoint("RIGHT", b, "RIGHT", -20, 0)
    b:HookScript("OnEnter", function(self)
        if not (f and f:IsShown()) then return end
        for i, e in ipairs(entries) do
            if e.button == self then if sel ~= i then sel = i I.Layout() end break end
        end
        if GameTooltip and GameTooltip:IsOwned(self) then GameTooltip:Hide() end -- the panel tells it, bigger
    end)
end

local function buttonAt(bag, slot)
    local k = bag * 100 + slot
    if buttonFor[k] then return buttonFor[k] end
    if InCombatLockdown() then return nil end -- made out of combat only
    local h = holders[bag]
    if not h then
        h = CreateFrame("Frame", nil, f.list)
        h:SetID(bag)
        h:SetAllPoints(f.list)
        holders[bag] = h
    end
    local name = "StewardItemsSlot" .. bag .. "_" .. slot
    local b
    for _, kind in ipairs({ "ItemButton", "Button" }) do
        local ok, made = pcall(CreateFrame, kind, name, h, "ContainerFrameItemButtonTemplate")
        if ok and made then b = made break end
    end
    if not b then error("the game's bag button template is missing") end
    b:SetID(slot)
    b.bag, b.slot = bag, slot
    restyle(b)
    buttonFor[k] = b
    return b
end

-- the detail panel
local function scanLines(bag, slot)
    local tip = I.tip
    if not tip then
        local ok, t = pcall(CreateFrame, "GameTooltip", "StewardItemsScan", nil, "GameTooltipTemplate")
        if not ok or not t then return {} end
        tip = t
        I.tip = t
    end
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    pcall(tip.SetBagItem, tip, bag, slot)
    local out = {}
    local n = tip.NumLines and tip:NumLines() or 0
    for i = 2, n do
        local fs = _G["StewardItemsScanTextLeft" .. i]
        local okT, t = pcall(fs and fs.GetText or function() end, fs)
        if okT and type(t) == "string" and t ~= "" and not (S.Secret and S.Secret(t)) and not t:find("^Sell Price") then
            local r, g, b = 0, 0, 0
            local okC, cr, cg, cb = pcall(fs.GetTextColor, fs)
            if okC and type(cr) == "number" then r, g, b = cr, cg, cb end
            -- the tooltip's colours are for a dark box: on white, green stays green (darker), red stays red, the rest black
            local color = { 0.04, 0.04, 0.05 }
            if g > 0.8 and r < 0.3 then color = { 0.05, 0.5, 0.1 }
            elseif r > 0.9 and g < 0.4 then color = { 0.85, 0.1, 0.15 }
            elseif r < 0.7 and g < 0.7 and b < 0.7 then color = { 0.45, 0.45, 0.48 } end
            out[#out + 1] = { t, color }
            if #out >= 8 then break end
        end
    end
    tip:Hide()
    return out
end

local function showDetail(e)
    local d = f.detail
    if not e then d:Hide() return end
    d:Show()
    d.icon:SetTexture(e.icon or 134400)
    local qc = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[e.quality or 1]
    local nm = e.name or "?"
    P.Heavy(d.name, #nm > 30 and 18 or #nm > 18 and 22 or 26) -- long names shrink to fit two lines
    d.name:SetText(nm)
    if qc and (e.quality or 1) >= 2 then d.name:SetTextColor(qc.r * 0.55, qc.g * 0.55, qc.b * 0.55) else d.name:SetTextColor(BLACK[1], BLACK[2], BLACK[3]) end
    local kind = {}
    if e.equipLoc and e.equipLoc ~= "" and _G[e.equipLoc] then kind[#kind + 1] = _G[e.equipLoc] end
    if e.subType and e.subType ~= "" then kind[#kind + 1] = e.subType elseif e.itemType then kind[#kind + 1] = e.itemType end
    d.kind:SetText(table.concat(kind, "  ·  "):upper())
    local lines = scanLines(e.bag, e.slot)
    local text = {}
    for _, l in ipairs(lines) do
        text[#text + 1] = string.format("|cff%02x%02x%02x%s|r", l[2][1] * 255, l[2][2] * 255, l[2][3] * 255, l[1])
    end
    d.body:SetText(table.concat(text, "\n"))
    local count = e.count
    local okC, have = pcall((C_Item and C_Item.GetItemCount) or _G.GetItemCount or function() end, e.itemID)
    if okC and type(have) == "number" and have > 0 then count = have end
    d.have:SetText(tostring(count or 1))
    d.sells:SetText((e.sell or 0) > 0 and (money(e.sell) .. ((count or 1) > 1 and " each" or "")) or "—")
    -- what the buttons do to this item
    local action
    if MerchantFrame and MerchantFrame:IsShown() and (e.sell or 0) > 0 then action = "Sell"
    elseif e.equipLoc and e.equipLoc ~= "" and e.equipLoc ~= "INVTYPE_NON_EQUIP_IGNORE" and e.equipLoc ~= "INVTYPE_BAG" then action = "Equip"
    else
        local spellF = (C_Item and C_Item.GetItemSpell) or _G.GetItemSpell
        local okS, sp = pcall(spellF or function() end, e.itemID)
        if okS and sp then action = "Use" end
    end
    local x = 0
    local function put(k, key, label)
        setKey(k, key, label)
        k:ClearAllPoints()
        k:SetPoint("LEFT", d.prompts, "LEFT", x, 0)
        x = x + k:GetWidth() + 7 + (k.label:GetStringWidth() or 40) + 18
    end
    for _, k in ipairs(d.keys) do k:Hide() end
    if action then put(d.keys[1], P.Key("use"), action) end
    put(d.keys[2], P.Key("link"), "Link")
    if e.quality == 0 and (e.sell or 0) > 0 then put(d.keys[3], P.Key("use"), "Sell at a vendor") end
end

local function free()
    local n = 0
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        local okF, c = pcall(C_Container.GetContainerNumFreeSlots, bag)
        if okF and type(c) == "number" then n = n + c end
    end
    return n
end

function I.Layout()
    if not f then return end
    local n = #entries
    if sel > n then sel = n end
    if sel < 1 then sel = 1 end
    if sel < top then top = sel end
    if sel > top + VISIBLE - 1 then top = sel - VISIBLE + 1 end
    if top < 1 then top = 1 end
    for _, b in pairs(buttonFor) do b:Hide() end
    local y = 0
    for i = top, math.min(n, top + VISIBLE - 1) do
        local e, k = entries[i], i - top
        local b = e.button
        if b then
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", f.list, "TOPLEFT", k * 3, -y)
            local lit = i == sel
            b.sBg:SetShown(not lit)
            b.sLit:SetShown(lit)
            b.sIconBg:SetShown(lit)
            P.BoldText(b.sName, lit and 22 or 18)
            if lit then P.Heavy(b.sName, 24) end
            local color = (e.quality == 0) and { 0.62, 0.62, 0.62 } or WHITE
            if not lit and e.quality and e.quality >= 2 and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[e.quality] then
                local qc = ITEM_QUALITY_COLORS[e.quality] color = { qc.r, qc.g, qc.b }
            end
            b.sName:SetTextColor(color[1], color[2], color[3])
            b.sCount:SetTextColor(lit and 1 or GREY[1], lit and 1 or GREY[2], lit and 1 or GREY[3])
            P.Heavy(b.sCount, lit and 24 or 18)
            b:Show()
            y = y + (lit and 64 or 50)
        end
    end
    f.where:SetText(n > 0 and (sel .. " / " .. n) or "")
    f.empty:SetShown(n == 0)
    showDetail(entries[sel])
end

function I.Refresh()
    if not (f and f:IsShown()) then return end
    local keep = not I.fresh and entries[sel] and (entries[sel].bag * 100 + entries[sel].slot) -- the same item stays lit
    I.fresh = nil
    entries = {}
    local want = TABS[tab].key
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        for slot = 1, (C_Container.GetContainerNumSlots(bag) or 0) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID then
                local name, _, quality, _, _, itype, isub, _, equipLoc, icon, sell, classID = itemInfo(info.hyperlink or info.itemID)
                local cat = category(bag, slot, info, classID)
                if want == "all" or want == cat then
                    local b = buttonAt(bag, slot)
                    local e = { bag = bag, slot = slot, button = b, itemID = info.itemID, link = info.hyperlink,
                        name = name or (info.hyperlink and info.hyperlink:match("%[(.-)%]")) or "?", quality = info.quality or quality,
                        icon = info.iconFileID or icon, count = info.stackCount or 1, sell = sell, cat = cat,
                        itemType = itype, subType = isub, equipLoc = equipLoc, locked = info.isLocked }
                    if b then
                        b.sIcon:SetTexture(e.icon or 134400)
                        if b.sIcon.SetDesaturated then b.sIcon:SetDesaturated(e.locked and true or false) end
                        b.sName:SetText(e.name)
                        b.sCount:SetText(e.count > 1 and ("x" .. e.count) or "")
                        pcall(ContainerFrame_UpdateCooldown or function() end, bag, b)
                        if b.UpdateCooldown then pcall(b.UpdateCooldown, b, e.icon) end
                    end
                    entries[#entries + 1] = e
                end
            end
        end
    end
    table.sort(entries, function(a, b)
        local ca, cb = CAT_ORDER[a.cat] or 9, CAT_ORDER[b.cat] or 9
        if ca ~= cb then return ca < cb end
        if (a.quality or 1) ~= (b.quality or 1) then return (a.quality or 1) > (b.quality or 1) end
        if a.name ~= b.name then return a.name < b.name end
        return a.bag * 100 + a.slot < b.bag * 100 + b.slot
    end)
    if keep then
        for i, e in ipairs(entries) do if e.bag * 100 + e.slot == keep then sel = i break end end
    end
    for i, t in ipairs(f.tabs) do
        local on = i == tab
        t.bg:SetShown(not on) t.lit:SetShown(on)
        P.Heavy(t.text, on and 15 or 13)
        t.text:SetText("") t.text:SetText(TABS[i].label) -- set again: a font still loading can leave words blank
        t.text:SetTextColor(on and 0.04 or GREY[1], on and 0.04 or GREY[2], on and 0.05 or GREY[3])
    end
    f.money:SetText(money(GetMoney and GetMoney() or 0))
    f.free:SetText(free() .. " SLOTS FREE")
    f.qKey:SetText(P.Key("left")) f.eKey:SetText(P.Key("right"))
    f.hint:SetText(P.Key("back") .. "  Close        " .. P.Key("sort") .. "  Sort")
    I.Layout()
end

local function build()
    if f then return f end
    f = CreateFrame("Frame", "StewardItems", UIParent)
    f:SetSize(980, 600)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 10)
    f:SetFrameStrata("HIGH")
    f:SetToplevel(true)
    f:EnableMouse(true)
    f:Hide()
    -- the world dims behind it, like a pause menu (less in a fight)
    f.dim = f:CreateTexture(nil, "BACKGROUND", nil, -8)
    f.dim:SetColorTexture(0, 0, 0, 1)
    f.dim:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
    f.dim:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")
    f.banner = P.Pic(f, "ARTWORK", "ItemsBanner", 295, 91, 512, 128)
    f.banner:SetPoint("TOPLEFT", f, "TOPLEFT", 22, -2)
    -- tabs, flipped with Q / E (or the shoulder buttons)
    f.qKey = P.Words(f, 18, GREY)
    f.qKey:SetPoint("RIGHT", f, "TOPLEFT", 58, -110)
    f.tabs = {}
    local x = 66
    for i, t in ipairs(TABS) do
        local b = CreateFrame("Button", nil, f)
        local w = 18 + #t.label * 10
        b:SetSize(w + 6, 28)
        b:SetPoint("LEFT", f, "TOPLEFT", x, -110)
        b.bg = P.Pic(b, "BACKGROUND", "ItemsTab", 120, 28, 128, 64) b.bg:SetAllPoints()
        b.lit = P.Pic(b, "BACKGROUND", "ItemsTabLit", 128, 36, 128, 64)
        b.lit:SetPoint("TOPLEFT", -4, 4) b.lit:SetPoint("BOTTOMRIGHT", 6, -4)
        b.text = P.Words(b, 13, GREY)
        b.text:SetPoint("CENTER", b, "CENTER", 3, 0)
        b.text:SetText(t.label)
        b:SetScript("OnClick", function() I.SetTab(i) end)
        f.tabs[i] = b
        x = x + w + 13
    end
    f.eKey = P.Words(f, 18, GREY)
    f.eKey:SetPoint("LEFT", f, "TOPLEFT", x + 2, -110)
    -- the list
    f.list = CreateFrame("Frame", nil, f)
    f.list:SetPoint("TOPLEFT", f, "TOPLEFT", 50, -146)
    f.list:SetSize(500, 390)
    f.where = P.Words(f, 16, GREY)
    f.where:SetPoint("TOPRIGHT", f, "TOPLEFT", 520, -540)
    f.empty = P.Words(f, 24, GREY)
    f.empty:SetPoint("TOPLEFT", f.list, "TOPLEFT", 10, -10)
    f.empty:SetText("NOTHING HERE")
    -- the detail panel
    local d = CreateFrame("Frame", nil, f)
    d:SetPoint("TOPLEFT", f, "TOPLEFT", 566, -84)
    d:SetSize(396, 476)
    d.bg = P.Pic(d, "BACKGROUND", "ItemsPanel", 396, 476, 512, 512) d.bg:SetAllPoints()
    d.iconBg = d:CreateTexture(nil, "BORDER")
    d.iconBg:SetColorTexture(0.04, 0.04, 0.05, 1)
    d.iconBg:SetSize(86, 86)
    d.iconBg:SetPoint("TOPLEFT", d, "TOPLEFT", 27, -31)
    d.icon = d:CreateTexture(nil, "ARTWORK")
    d.icon:SetSize(80, 80)
    d.icon:SetPoint("CENTER", d.iconBg, "CENTER")
    d.name = P.Words(d, 26, BLACK)
    d.name:SetPoint("TOPLEFT", d, "TOPLEFT", 128, -38)
    d.name:SetWidth(240)
    d.name:SetJustifyH("LEFT")
    d.name:SetWordWrap(true)
    if d.name.SetMaxLines then d.name:SetMaxLines(2) end
    d.kind = d:CreateFontString(nil, "OVERLAY")
    P.BoldText(d.kind, 12)
    d.kind:SetTextColor(RED[1], RED[2], RED[3])
    d.kind:SetPoint("TOPLEFT", d.name, "BOTTOMLEFT", 2, -4)
    d.body = d:CreateFontString(nil, "OVERLAY")
    P.BoldText(d.body, 16)
    d.body:SetPoint("TOPLEFT", d, "TOPLEFT", 32, -146)
    d.body:SetWidth(334)
    d.body:SetJustifyH("LEFT")
    d.body:SetSpacing(4)
    d.haveLbl = P.Pic(d, "ARTWORK", "ItemsYouHave", 75, 16, 128, 16)
    d.haveLbl:SetPoint("TOPLEFT", d, "TOPLEFT", 32, -306)
    d.have = P.Words(d, 34, BLACK)
    d.have:SetPoint("TOPLEFT", d, "TOPLEFT", 32, -324)
    d.sellLbl = P.Pic(d, "ARTWORK", "ItemsSellsFor", 76, 16, 128, 16)
    d.sellLbl:SetPoint("TOPLEFT", d, "TOPLEFT", 194, -306)
    d.sells = P.Words(d, 30, BLACK)
    d.sells:SetPoint("TOPLEFT", d, "TOPLEFT", 194, -326)
    d.prompts = CreateFrame("Frame", nil, d)
    d.prompts:SetPoint("LEFT", d, "TOPLEFT", 40, -410)
    d.prompts:SetSize(320, 30)
    d.keys = { keyCap(d.prompts), keyCap(d.prompts), keyCap(d.prompts) }
    f.detail = d
    -- footer
    f.moneyBg = P.Pic(f, "ARTWORK", "ItemsMoney", 306, 34, 512, 64)
    f.moneyBg:SetPoint("TOPLEFT", f, "TOPLEFT", 34, -556)
    f.money = P.Words(f, 22, BLACK)
    f.money:SetPoint("LEFT", f.moneyBg, "LEFT", 16, 0)
    f.free = P.Words(f, 16, WHITE)
    f.free:SetPoint("LEFT", f.moneyBg, "RIGHT", 16, 0)
    f.hint = P.Words(f, 15, GREY)
    f.hint:SetPoint("RIGHT", f, "TOPLEFT", 950, -573)
    -- moving through it: the wheel, and keys while it's open and you're not fighting
    f:EnableMouseWheel(true)
    f:SetScript("OnMouseWheel", function(_, delta) sel = sel - delta I.Layout() end)
    f:SetScript("OnKeyDown", function(self, key)
        local act
        if key == "Q" or key == "PADLSHOULDER" then act = function() I.SetTab(tab == 1 and #TABS or tab - 1) end
        elseif key == "E" or key == "PADRSHOULDER" then act = function() I.SetTab(tab % #TABS + 1) end
        elseif key == "UP" or key == "PADDUP" then act = function() sel = sel - 1 I.Layout() end
        elseif key == "DOWN" or key == "PADDDOWN" then act = function() sel = sel + 1 I.Layout() end
        elseif key == "R" or key == "PAD4" then act = I.Sort end
        if not InCombatLockdown() then pcall(self.SetPropagateKeyboardInput, self, act == nil) end
        if act then act() end
    end)
    f:SetScript("OnShow", function(self)
        self.dim:SetAlpha(InCombatLockdown() and 0.15 or 0.55)
        if not InCombatLockdown() then pcall(self.EnableKeyboard, self, true) end
        if PlaySound and SOUNDKIT and SOUNDKIT.IG_BACKPACK_OPEN then pcall(PlaySound, SOUNDKIT.IG_BACKPACK_OPEN) end
        I.Refresh()
    end)
    f:SetScript("OnHide", function()
        if PlaySound and SOUNDKIT and SOUNDKIT.IG_BACKPACK_CLOSE then pcall(PlaySound, SOUNDKIT.IG_BACKPACK_CLOSE) end
        if GameTooltip then GameTooltip:Hide() end
        if not I.syncing and I.BlizzOpen() and CloseAllBags then pcall(CloseAllBags) end -- Esc: the game's bags close too
    end)
    if UISpecialFrames then table.insert(UISpecialFrames, "StewardItems") end
    return f
end

function I.SetTab(i)
    tab = i
    sel, top = 1, 1
    I.fresh = true -- a new tab starts at the top
    I.Refresh()
end

function I.Sort()
    local sort = C_Container and C_Container.SortBags or _G.SortBags
    if sort then pcall(sort) end
end

---------------------------------------------------------------- standing in for the game's bags
local blizz = {} -- the game's bag windows
local hidden
local function gameBags()
    local list = {}
    if _G.ContainerFrameCombinedBags then list[#list + 1] = _G.ContainerFrameCombinedBags end
    for i = 1, (NUM_CONTAINER_FRAMES or 13) do
        local c = _G["ContainerFrame" .. i]
        if c then list[#list + 1] = c end
    end
    return list
end
function I.BlizzOpen()
    for _, c in ipairs(gameBags()) do if c:IsShown() then return true end end
    return false
end
-- the game's bags opened or closed: show or hide this screen to match
local function sync()
    if not P.On() or I.broken then return end
    local want = I.BlizzOpen()
    local ok, err = pcall(build)
    if not ok then
        I.broken = true
        S:LogError("items", err)
        I.Release()
        return
    end
    I.syncing = true
    if want and not f:IsShown() then f:Show()
    elseif not want and f:IsShown() then f:Hide() end
    I.syncing = false
end
-- tuck the game's bag windows away (they keep working; they just can't be seen)
function I.Take()
    if not P.On() or I.broken then return end
    hidden = hidden or CreateFrame("Frame")
    hidden:Hide()
    for _, c in ipairs(gameBags()) do
        if not blizz[c] then
            blizz[c] = c:GetParent() or UIParent
            -- watch the game show and hide it. Not OnShow / OnHide: inside a hidden frame those never fire (a window
            -- that's shown but can't be seen never "appears"; 0.70.6's "nothing happens when I press B")
            for _, m in ipairs({ "Show", "Hide", "SetShown" }) do
                if c[m] then hooksecurefunc(c, m, function() if blizz[c] and P.On() then sync() end end) end
            end
        end
        if c:GetParent() ~= hidden then c:SetParent(hidden) end
    end
end
-- give the game its bags back (the Blizzard style, or something went wrong)
function I.Release()
    for c, parent in pairs(blizz) do
        if c:GetParent() ~= parent then c:SetParent(parent) end
    end
    if f and f:IsShown() then I.syncing = true f:Hide() I.syncing = false end
end
function I.StyleChanged()
    if P.On() then I.Take() sync() else I.Release() end
end

local hooked
local function hookBagFunctions()
    if hooked then return end
    hooked = true
    for _, fn in ipairs({ "ToggleAllBags", "OpenAllBags", "CloseAllBags", "ToggleBackpack", "OpenBackpack",
        "CloseBackpack", "ToggleBag", "OpenBag", "CloseBag" }) do
        if type(_G[fn]) == "function" then hooksecurefunc(fn, function() if P.On() and next(blizz) then sync() end end) end
    end
end
S:On("PLAYER_LOGIN", function() pcall(hookBagFunctions) pcall(I.Take) end)
S:On("PLAYER_ENTERING_WORLD", function() pcall(I.Take) end)
for _, ev in ipairs({ "BAG_UPDATE_DELAYED", "ITEM_LOCK_CHANGED", "PLAYER_MONEY", "BAG_UPDATE_COOLDOWN", "MERCHANT_SHOW", "MERCHANT_CLOSED" }) do
    S:On(ev, function() if f and f:IsShown() then pcall(I.Refresh) end end)
end
S:On("PLAYER_REGEN_DISABLED", function()
    if f then pcall(f.EnableKeyboard, f, false) if f:IsShown() then f.dim:SetAlpha(0.15) end end
end)
S:On("PLAYER_REGEN_ENABLED", function()
    if f and f:IsShown() then pcall(f.EnableKeyboard, f, true) f.dim:SetAlpha(0.55) end
    if P.On() then pcall(I.Take) end
end)
