local _, S = ...

-- Vendor and trainer chores. At a merchant: sell grey items, repair, and top up food, drink
-- and ammo (the best you can use). At your class trainer: learn every spell you can afford.
-- A short receipt shows in the window for a few seconds; nothing goes to chat.
-- Hold Shift when you open the window to do it yourself.

local FOOD_TARGET, DRINK_TARGET = 20, 20
local AMMO_TARGET = { HUNTER = 1000 } -- others who carry a bow or gun keep a stack for pulling
local AMMO_DEFAULT = 200
local SPEND_SHARE = 0.25 -- a single restock never spends more than this share of your gold

-- looked up when used (newer clients keep these under C_Item)
local function GetInfo(item) return ((C_Item and C_Item.GetItemInfo) or GetItemInfo)(item) end
local function GetInstant(item) return ((C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant)(item) end
local function ItemSpell(item)
    local fn = (C_Item and C_Item.GetItemSpell) or GetItemSpell
    if fn then return fn(item) end
end

local function money(c)
    c = math.floor(c or 0)
    local g, s, cp = math.floor(c / 10000), math.floor(c / 100) % 100, c % 100
    if g > 0 then return string.format("%dg %ds", g, s) end
    if s > 0 then return string.format("%ds %dc", s, cp) end
    return cp .. "c"
end

---------------------------------------------------------------- the receipt
local receipt, receiptLines, hideAt
local function showReceipt(anchor, lines, where)
    if #lines == 0 or not anchor then return end
    if not receipt then
        receipt = CreateFrame("Frame", "StewardReceipt", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
        receipt:SetFrameStrata("DIALOG")
        receipt:SetClampedToScreen(true) -- never partly off the edge of the screen
        if receipt.SetBackdrop then
            receipt:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
                insets = { left = 3, right = 3, top = 3, bottom = 3 } })
            receipt:SetBackdropColor(0, 0, 0, 0.85)
            receipt:SetBackdropBorderColor(0.6, 0.5, 0.3)
        end
        receipt.title = receipt:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        receipt.title:SetPoint("TOPLEFT", 10, -8)
        receipt.title:SetText("Steward")
        receiptLines = {}
        receipt:SetScript("OnUpdate", function(self)
            if hideAt and GetTime() > hideAt then self:Hide() end
        end)
    end
    for _, fs in ipairs(receiptLines) do fs:Hide() end
    local width = 120
    for i, text in ipairs(lines) do
        local fs = receiptLines[i]
        if not fs then
            fs = receipt:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            fs:SetPoint("TOPLEFT", 10, -10 - i * 14)
            fs:SetJustifyH("LEFT")
            receiptLines[i] = fs
        end
        fs:SetText(text)
        fs:Show()
        width = math.max(width, (fs:GetStringWidth() or 0) + 20)
    end
    receipt:SetSize(width, 26 + #lines * 14)
    receipt:ClearAllPoints()
    if where then
        receipt:SetPoint(where[1], anchor, where[2], where[3] or 0, where[4] or 0)
    else
        receipt:SetPoint("TOPLEFT", anchor, "TOPRIGHT", 4, -24)
    end
    receipt:Show()
    hideAt = GetTime() + 10
    local shownAt = hideAt
    C_Timer.After(10.5, function() if hideAt == shownAt and receipt:IsShown() then receipt:Hide() end end)
end

---------------------------------------------------------------- what's in your bags
local function eachBagItem(fn)
    if not (C_Container and C_Container.GetContainerNumSlots) then return end
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        for slot = 1, C_Container.GetContainerNumSlots(bag) or 0 do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID then fn(bag, slot, info) end
        end
    end
end

-- "food", "drink" or "both" for things you eat or drink; nil for anything else
local function consumableKind(item)
    local _, _, _, _, _, classID, subclassID = GetInstant(item)
    if classID ~= 0 or subclassID ~= 5 then return nil end -- Consumable > Food & Drink
    local spell = ItemSpell(item)
    spell = spell and spell:lower() or ""
    if spell:find("refreshment", 1, true) then return "both" end
    if spell:find("drink", 1, true) then return "drink" end
    if spell:find("food", 1, true) then return "food" end
    return nil
end

local function minLevel(item)
    local _, _, _, _, req = GetInfo(item)
    return req or 0
end

-- arrows or bullets for the ranged weapon you have on: 2 = arrows, 3 = bullets
local function ammoKind()
    local link = GetInventoryItemLink("player", 18)
    if not link then return nil end
    local _, _, _, _, _, classID, subclassID = GetInstant(link)
    if classID ~= 2 then return nil end
    if subclassID == 2 or subclassID == 18 then return 2 end -- bow, crossbow
    if subclassID == 3 then return 3 end -- gun
    return nil
end

local function usesMana()
    if not UnitPowerType then return false end
    local t = UnitPowerType("player")
    return t == (Enum and Enum.PowerType and Enum.PowerType.Mana or 0)
end

-- how many of this kind you already carry that are at least this good
local function carried(kind, atLeastLevel)
    local n = 0
    eachBagItem(function(_, _, info)
        local match
        if kind == "ammo" then
            local _, _, _, _, _, classID, subclassID = GetInstant(info.itemID)
            match = classID == 6 and subclassID == ammoKind()
        else
            local k = consumableKind(info.itemID)
            match = k == kind or k == "both"
        end
        if match and minLevel(info.itemID) >= atLeastLevel then n = n + (info.stackCount or 1) end
    end)
    return n
end

---------------------------------------------------------------- food and drink you've outgrown
-- Nick 2026-11-15: "If I have better food or water, why doesn't it sell the lesser stuff? if i'm a mage, it should
-- probably sell it all unless the food and water I can make is weaker". Better = a higher level to use (the measure
-- the buying already goes by). Conjured food and water can't be sold; buff food (well fed, extra experience) and
-- anything above white is never sold.
-- A mage's conjuring, by rank (the spell ids of each rank, and the level the item it makes asks for)
local CONJURE = {
    food = { { 587, 1 }, { 597, 5 }, { 990, 15 }, { 6129, 25 }, { 10144, 35 }, { 10145, 45 }, { 28612, 55 } },
    drink = { { 5504, 1 }, { 5505, 5 }, { 5506, 15 }, { 6127, 25 }, { 10138, 35 }, { 10139, 45 }, { 10140, 55 } },
}
local CONJURE_NAME = { food = "Conjure Food", drink = "Conjure Water" }
local function isConjured(name) return name and name:find("^Conjured") ~= nil end
-- the level of the best of this kind you can conjure (nil: none)
local function canConjure(kind)
    local _, class = UnitClass("player")
    if class ~= "MAGE" then return nil end
    local best
    for _, r in ipairs(CONJURE[kind]) do
        if IsPlayerSpell and IsPlayerSpell(r[1]) then best = r[2] end
    end
    -- the spellbook's own ranks, should Forever's spell ids differ ("Conjure Water (Rank 2)" -> rank 2)
    if GetSpellBookItemName then
        for i = 1, 400 do
            local name, sub = GetSpellBookItemName(i, BOOKTYPE_SPELL or "spell")
            if not name then break end
            if name == CONJURE_NAME[kind] then
                local rank = tonumber(sub and sub:match("(%d+)") or "1") or 1
                local lv = CONJURE[kind][math.min(rank, #CONJURE[kind])][2]
                if not best or lv > best then best = lv end
            end
        end
    end
    -- conjured items in your bags tell it best
    eachBagItem(function(_, _, info)
        local name = GetInfo(info.itemID)
        local k = consumableKind(info.itemID)
        if isConjured(name) and (k == kind or k == "both") then
            local lv = minLevel(info.itemID)
            if not best or lv > best then best = lv end
        end
    end)
    return best
end
local function buffFood(bag, slot)
    if not (C_TooltipInfo and C_TooltipInfo.GetBagItem) then return true end -- can't tell: keep it
    local data = C_TooltipInfo.GetBagItem(bag, slot)
    for _, line in ipairs(data and data.lines or {}) do
        local t = (line.leftText or ""):lower()
        if t:find("well fed", 1, true) or t:find("experience", 1, true) or t:find("%", 1, true) then return true end
    end
    return false
end
-- the level of the best of this kind you carry in some number (5 or more at that level or above)
local function bestCarried(kind)
    local byLevel = {}
    eachBagItem(function(_, _, info)
        local k = consumableKind(info.itemID)
        if k == kind or k == "both" then
            local lv = minLevel(info.itemID)
            byLevel[lv] = (byLevel[lv] or 0) + (info.stackCount or 1)
        end
    end)
    local levels = {}
    for lv in pairs(byLevel) do levels[#levels + 1] = lv end
    table.sort(levels, function(a, b) return a > b end)
    local n = 0
    for _, lv in ipairs(levels) do
        n = n + byLevel[lv]
        if n >= 5 then return lv end
    end
    return nil
end
local function sellOutgrown()
    for _, kind in ipairs({ "food", "drink" }) do
        local better = bestCarried(kind)
        local conj = canConjure(kind)
        if conj and (not better or conj >= better) then better = conj + 0.5 end -- what you make beats the same level bought
        if better then
            eachBagItem(function(bag, slot, info)
                local k = consumableKind(info.itemID)
                if k == kind then -- "both" (refreshments) stays: it's food and drink at once
                    local name, _, quality, _, _, _, _, _, _, _, price = GetInfo(info.itemID)
                    if not isConjured(name) and (quality or 1) <= 1 and (price or 0) > 0 and not info.isLocked
                        and minLevel(info.itemID) < better and not buffFood(bag, slot) then
                        C_Container.UseContainerItem(bag, slot)
                    end
                end
            end)
        end
    end
end
S.CanConjure = canConjure

---------------------------------------------------------------- at a merchant
local function merchantItem(i)
    if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
        local info = C_MerchantFrame.GetItemInfo(i)
        if info then return info.name, info.price, info.stackCount, info.numAvailable, info.isUsable, info.hasExtendedCost end
        return nil
    end
    local name, _, price, stack, avail, usable, extended = GetMerchantItemInfo(i)
    return name, price, stack, avail, usable, extended
end

-- the best thing of a kind this merchant sells that you can use now
local function bestOnSale(kind)
    if not (GetMerchantNumItems and BuyMerchantItem) then return nil end
    local best
    local level = UnitLevel("player")
    for i = 1, GetMerchantNumItems() or 0 do
        local name, price, stack, avail, usable, extended = merchantItem(i)
        local id = GetMerchantItemID and GetMerchantItemID(i)
        if name and id and usable ~= false and not extended and avail ~= 0 then
            local ok
            if kind == "ammo" then
                local _, _, _, _, _, classID, subclassID = GetInstant(id)
                ok = classID == 6 and subclassID == ammoKind()
            else
                ok = consumableKind(id) == kind
            end
            local req = minLevel(id)
            if ok and req <= level and (not best or req > best.req or (req == best.req and price > best.price)) then
                best = { index = i, id = id, name = name, price = price, stack = math.max(1, stack or 1), req = req }
            end
        end
    end
    return best
end

local function buy(item, want, budget)
    if want <= 0 or not item then return 0, 0 end
    -- never past the target: whole bundles only, and nothing for a few missing
    if want < math.max(item.stack, 5) then return 0, 0 end
    local lots = math.floor(want / item.stack)
    local perLot = item.price
    if perLot > 0 then lots = math.min(lots, math.floor(budget / perLot)) end
    if lots <= 0 then return 0, 0 end
    local qty = lots * item.stack
    if item.stack > 1 then
        -- sold in bundles (arrows by 200, some food by 5): one bundle per purchase, no doubt about counts
        for _ = 1, lots do BuyMerchantItem(item.index) end
    else
        local maxStack = math.max(1, GetMerchantItemMaxStack and GetMerchantItemMaxStack(item.index) or qty)
        local left = qty
        while left > 0 do
            local n = math.min(left, maxStack)
            BuyMerchantItem(item.index, n)
            left = left - n
        end
    end
    return qty, lots * perLot
end

---------------------------------------------------------------- mage runes
-- Nick 2026-11-17: "from now on, have steward buy runes of teleportation when hitting vendors that have them".
-- Wowhead: Teleport spells use a Rune of Teleportation (17031), Portal spells a Rune of Portals (17032).
local RUNE_TARGET = 10
local RUNES = {
    { id = 17031, spells = { 3561, 3562, 3565, 3563, 3566, 3567, 1297659 } }, -- Teleport: SW, IF, Darn, UC, TB, Org; Forever's Dalaran
    { id = 17032, spells = { 10059, 11416, 11419, 11418, 11420, 11417 } }, -- Portal: the same six
}
local function knowsAny(list)
    for _, id in ipairs(list) do
        if (IsPlayerSpell and IsPlayerSpell(id)) or (IsSpellKnown and IsSpellKnown(id)) then return true end
    end
    return false
end
local function runeOnSale(itemID)
    if not (GetMerchantNumItems and GetMerchantItemID) then return nil end
    for i = 1, GetMerchantNumItems() or 0 do
        if GetMerchantItemID(i) == itemID then
            local name, price, stack, avail, _, extended = merchantItem(i)
            if name and not extended and avail ~= 0 then
                return { index = i, id = itemID, name = name, price = price, stack = math.max(1, stack or 1), req = 0 }
            end
        end
    end
end
local function restockRunes(budget, lines)
    local _, class = UnitClass("player")
    if class ~= "MAGE" or not S:Get("vendorRunes") then return budget end
    for _, r in ipairs(RUNES) do
        if knowsAny(r.spells) then
            local item = runeOnSale(r.id)
            if item then
                local count = (C_Item and C_Item.GetItemCount) or _G.GetItemCount
                local have = (count and count(r.id)) or 0
                local got, spent = buy(item, (tonumber(S:Get("runeKeep")) or RUNE_TARGET) - have, budget)
                if got > 0 then
                    budget = budget - spent
                    lines[#lines + 1] = string.format("Bought %d %s  |cffff8080-%s|r", got, item.name, money(spent))
                end
            end
        end
    end
    return budget
end
S.VendorRunesTest = { knowsAny = knowsAny, runeOnSale = runeOnSale, restockRunes = restockRunes, RUNES = RUNES }

local function atMerchant()
    if IsShiftKeyDown() then return end
    local lines = {}
    -- grey items
    if S:Get("vendorSell") then
        local worth, count = 0, 0
        eachBagItem(function(bag, slot, info)
            if info.quality == 0 and not info.hasNoValue then
                local _, _, _, _, _, _, _, _, _, _, price = GetInfo(info.itemID)
                worth = worth + (price or 0) * (info.stackCount or 1)
                count = count + 1
                if not (C_MerchantFrame and C_MerchantFrame.SellAllJunkItems) then
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end)
        if count > 0 then
            if C_MerchantFrame and C_MerchantFrame.SellAllJunkItems then C_MerchantFrame.SellAllJunkItems() end
            -- sold quietly: no line on the receipt for it
        end
    end
    -- white and green gear you won't wear
    if S:Get("vendorSellGear") then
        eachBagItem(function(bag, slot, info)
            if S.WontWear and S:WontWear(info) then C_Container.UseContainerItem(bag, slot) end
        end)
    end
    -- repairs
    if S:Get("vendorRepair") and CanMerchantRepair and CanMerchantRepair() then
        local cost, needed = GetRepairAllCost()
        if needed and cost and cost > 0 and GetMoney() >= cost then
            RepairAllItems()
            lines[#lines + 1] = "Repaired your gear  |cffff8080-" .. money(cost) .. "|r"
        end
    end
    -- food and drink you've outgrown
    if S:Get("vendorSellFood") then
        local ok, err = pcall(sellOutgrown)
        if not ok then S:LogError("vendor food", err) end
    end
    -- food, drink, ammo
    local budget = math.floor(GetMoney() * SPEND_SHARE)
    local function restock(setting, kind, target, label)
        if not S:Get(setting) or target <= 0 then return end
        local item = bestOnSale(kind)
        if not item then return end
        -- a mage who conjures this kind at least as good doesn't buy it
        local conj = (kind == "food" or kind == "drink") and canConjure(kind)
        if conj and conj >= item.req then return end
        local have = carried(kind, item.req)
        local got, spent = buy(item, target - have, budget)
        if got > 0 then
            budget = budget - spent
            lines[#lines + 1] = string.format("Bought %d %s  |cffff8080-%s|r", got, item.name or label, money(spent))
        end
    end
    restock("vendorFood", "food", tonumber(S:Get("foodKeep")) or FOOD_TARGET, "food")
    if usesMana() then restock("vendorDrink", "drink", tonumber(S:Get("drinkKeep")) or DRINK_TARGET, "drink") end
    if ammoKind() then
        local _, class = UnitClass("player")
        restock("vendorAmmo", "ammo", AMMO_TARGET[class] or AMMO_DEFAULT, "ammo")
    end
    -- runes for a mage's Teleport and Portal spells
    local okR, errR = pcall(function() budget = restockRunes(budget, lines) end)
    if not okR then S:LogError("vendor runes", errR) end
    -- done quietly: nothing pops up
end

-- The merchant's goods may not be loaded yet (then a drink can't be told from anything else):
-- ask for them, and start once they're all in, or after two seconds at most.
local function merchantReady()
    if not GetMerchantNumItems then return true end
    local ready = true
    for i = 1, GetMerchantNumItems() or 0 do
        local id = GetMerchantItemID and GetMerchantItemID(i)
        if id then
            local name = GetInfo(id)
            local _, _, _, _, _, classID = GetInstant(id)
            if not name then
                ready = false
                if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, id) end
            elseif classID == 0 and not ItemSpell(id) then
                ready = false
            end
        end
    end
    return ready
end

S:On("MERCHANT_SHOW", function()
    if IsShiftKeyDown() then return end
    local tries = 0
    local function go()
        tries = tries + 1
        if not (MerchantFrame and MerchantFrame:IsShown()) and tries > 1 then return end
        if not merchantReady() and tries < 10 then C_Timer.After(0.2, go) return end
        local ok, err = pcall(atMerchant)
        if not ok then S:LogError("vendor", err) end
    end
    C_Timer.After(0.3, go)
end)

---------------------------------------------------------------- at your class trainer
local learned, spent, training
-- what the trainer offered and what Steward did, for the last 5 visits (StewardCharDB.trainDiag): Nick 2026-11-15,
-- "isn't this supposed to train for me? It didn't"
local diag
local function diagStart(why)
    StewardCharDB.trainDiag = StewardCharDB.trainDiag or {}
    local list = StewardCharDB.trainDiag
    diag = { when = date and date("%m-%d %H:%M:%S") or "?", level = UnitLevel("player"), money = GetMoney and GetMoney() or -1,
        why = why, vendorTrain = S:Get("vendorTrain") and true or false, shift = IsShiftKeyDown() and true or false,
        npc = UnitName and UnitName("npc") or nil, services = {} }
    if IsTradeskillTrainer then diag.tradeskill = IsTradeskillTrainer() and true or false end
    if GetTrainerServiceSkillLine and GetNumTrainerServices and (GetNumTrainerServices() or 0) > 0 then diag.line = GetTrainerServiceSkillLine(1) end
    if S.IsClassTrainer then diag.classTrainer = S.IsClassTrainer() and true or false end
    if GetNumTrainerServices and GetTrainerServiceInfo then
        diag.n = GetNumTrainerServices() or 0
        for i = 1, math.min(diag.n, 80) do
            local name, rank, category = S.TrainerService(i)
            local cost = GetTrainerServiceCost and GetTrainerServiceCost(i) or nil
            local req = GetTrainerServiceLevelReq and GetTrainerServiceLevelReq(i) or nil
            diag.services[#diag.services + 1] = table.concat({ tostring(name), tostring(rank), tostring(category), tostring(cost), tostring(req) }, " | ")
        end
    end
    if GetTrainerServiceTypeFilter then
        diag.filter = {}
        for _, k in ipairs({ "available", "unavailable", "used" }) do diag.filter[k] = GetTrainerServiceTypeFilter(k) and true or false end
    end
    table.insert(list, 1, diag)
    while #list > 5 do table.remove(list) end
end
local function learnNext()
    if not training then return end
    local reserve = 0
    -- Wowhead's mandatory abilities for your spec first; optional ones only once none of those is left on offer
    local first = S.MandatoryTraining and S:MandatoryTraining()
    local skip = S.SkippedTraining and S:SkippedTraining() or {}
    local pass = { first and "mandatory" or "all" }
    -- mandatory: that spell, or (a page that stops at a level) that rank
    local function isFirst(i, name)
        if not S.MandatoryRank then return first ~= nil and first[name] == true end
        local req = GetTrainerServiceLevelReq and GetTrainerServiceLevelReq(i)
        return S.MandatoryRank(first, name, req)
    end
    if first then
        local waiting = false
        for i = 1, GetNumTrainerServices() or 0 do
            local name, _, category = S.TrainerService(i)
            if category == "available" and isFirst(i, name) and not skip[name]
                and (GetTrainerServiceCost(i) or 0) > GetMoney() then waiting = true end
        end
        if not waiting then pass[2] = "rest" end -- a mandatory one you can't afford yet: keep the gold for it
        if diag then diag.waitingForMandatory = waiting end
    end
    for _, which in ipairs(pass) do
    for i = 1, GetNumTrainerServices() or 0 do
        local name, rank, category = S.TrainerService(i)
        local wanted = which == "all" or (which == "mandatory") == isFirst(i, name)
        if category == "available" and wanted and not skip[name] then
            local cost = GetTrainerServiceCost(i) or 0
            if cost <= GetMoney() - reserve then
                learned[#learned + 1] = name .. (rank and rank ~= "" and (" (" .. rank .. ")") or "")
                spent = spent + cost
                BuyTrainerService(i)
                -- the list changes after each purchase: carry on once it has updated
                C_Timer.After(0.25, learnNext)
                return
            end
        end
    end
    end
    training = false -- done quietly: nothing pops up
    if diag then diag.learned = learned end
end

S:On("TRAINER_SHOW", function()
    if IsShiftKeyDown() or not S:Get("vendorTrain") then
        pcall(diagStart, IsShiftKeyDown() and "shift held" or "setting off")
        return
    end
    C_Timer.After(0.3, function()
        pcall(diagStart, "open")
        if not (S.IsClassTrainer and S.IsClassTrainer()) or not (GetTrainerServiceCost and BuyTrainerService) then
            if diag then diag.why = "not a class trainer (or no trainer API)" end
            return
        end
        learned, spent, training = {}, 0, true
        local ok, err = pcall(learnNext)
        if not ok then training = false S:LogError("trainer", err) end
    end)
end)
S:On("TRAINER_CLOSED", function() training = false end)

S.ShowReceipt = showReceipt

---------------------------------------------------------------- bags full
-- When the game says your bags are full, Steward offers to delete your cheapest grey item, but only
-- when that's worth it:
--   looting: only when something still in the loot window is a quest item, or sells for more than
--            that grey; after the delete it loots that item for you
--   a quest window (a quest that hands you an item, or a reward): always; then it takes the quest again
--   anything else (buying, mail...): no offer
local function cheapestJunk()
    local best
    eachBagItem(function(bag, slot, info)
        if info.quality == 0 and not info.isLocked then
            local _, link, _, _, _, _, _, _, _, _, price = GetInfo(info.itemID)
            local worth = (price or 0) * (info.stackCount or 1)
            if not best or worth < best.worth then
                best = { bag = bag, slot = slot, itemID = info.itemID, worth = worth,
                    link = info.hyperlink or link or ("item " .. info.itemID), count = info.stackCount or 1 }
            end
        end
    end)
    return best
end

local function lootOpen()
    if not GetNumLootItems then return false end
    local ok, n = pcall(GetNumLootItems)
    return ok and type(n) == "number" and n > 0
end

-- the items still in the open loot window: { slot, link, count, quality, quest, worth (nil = not known yet) }
local function lootLeft()
    local out = {}
    if not (lootOpen() and GetLootSlotLink) then return out end
    for i = 1, GetNumLootItems() do
        local isItem = true
        if GetLootSlotType and LOOT_SLOT_ITEM then
            local ok, t = pcall(GetLootSlotType, i)
            isItem = ok and t == LOOT_SLOT_ITEM
        end
        local okL, link = pcall(GetLootSlotLink, i)
        if isItem and okL and type(link) == "string" then
            local count, quality, isQuest, questID
            if GetLootSlotInfo then
                local ok, _, _, c, _, q, _, iq, qid = pcall(GetLootSlotInfo, i)
                if ok then count, quality, isQuest, questID = c, q, iq, qid end
            end
            count = (type(count) == "number" and count > 0) and count or 1
            local _, _, _, _, _, classID = GetInstant(link)
            local _, _, q2, _, _, _, _, _, _, _, price = GetInfo(link)
            out[#out + 1] = { slot = i, link = link, count = count, quality = quality or q2,
                quest = isQuest == true or (type(questID) == "number" and questID > 0) or classID == 12,
                worth = type(price) == "number" and price * count or nil }
        end
    end
    return out
end

-- the loot worth making room for (a quest item first, else the dearest that beats the junk), or nil
local function lootWorthRoom(junk)
    local want, wantWorth
    for _, it in ipairs(lootLeft()) do
        if it.quest then return it end
        local w = it.worth
        if w == nil and (it.quality or 0) >= 2 then w = math.huge end -- price not known yet: a green beats any grey
        if w and w > junk.worth and (not wantWorth or w > wantWorth) then want, wantWorth = it, w end
    end
    return want
end

local function deleteJunk(junk)
    local info = C_Container.GetContainerItemInfo(junk.bag, junk.slot)
    if not (info and info.itemID == junk.itemID and info.quality == 0) then return false end
    S.step = "delete (pick up the junk)"
    ClearCursor()
    C_Container.PickupContainerItem(junk.bag, junk.slot)
    if not (CursorHasItem and CursorHasItem()) then S.step = nil return false end
    S.step = "delete (DeleteCursorItem)"
    DeleteCursorItem()
    S.step = nil
    return true
end

if StaticPopupDialogs then
    StaticPopupDialogs.STEWARD_DELETE_JUNK = {
        text = "%s",
        button1 = DELETE or "Delete",
        button2 = CANCEL or "Cancel",
        OnAccept = function(self, data) S.MakeRoom(data or (self and self.data)) end,
        timeout = 0, whileDead = 1, hideOnEscape = 1, showAlert = 1,
    }
end
-- delete the cheapest grey, then pick up the loot that didn't fit (or take the quest again)
function S.MakeRoom(data)
    local junk = cheapestJunk()
    if not (junk and deleteJunk(junk)) then return false end
    if data and data.lootSlot then
        -- the loot that didn't fit: pick it up in the same click (the game may refuse a loot from a timer, which has
        -- no click behind it; the server takes the delete first, then the loot)
        if lootOpen() and LootSlot then
            S.step = "loot (LootSlot in the click)"
            pcall(LootSlot, data.lootSlot)
            S.step = nil
        end
    elseif QuestFrameDetailPanel and QuestFrameDetailPanel:IsShown() and AcceptQuest then
        -- the quest window that couldn't give you its item: take the quest again
        C_Timer.After(0.3, function()
            if QuestFrameDetailPanel:IsShown() then AcceptQuest() end
        end)
    end
    return true
end

local lastOffer = 0
S:On("UI_ERROR_MESSAGE", function(_, message)
    if message ~= ERR_INV_FULL and message ~= ERR_BAG_FULL then return end
    if not S:Get("bagsDeleteJunk") or InCombatLockdown() then return end
    if GetTime() - lastOffer < 2 then return end
    local looting = lootOpen()
    local questing = not looting and _G.QuestFrame and QuestFrame:IsShown()
    if not (looting or questing) then return end -- buying, mail...: not worth a delete
    local junk = cheapestJunk()
    if not junk then
        if questing and S.ShowReceipt then
            S.ShowReceipt(QuestFrame, { "Your bags are full, and there's no grey junk to delete." })
        end
        return
    end
    -- no asking (Nick 2026-11-22: "it's simply asking for permission to delete junk, it doesn't need permission"):
    -- the cheapest grey goes and the loot that didn't fit is taken (or the quest taken again), when it's worth it
    local data, why
    if looting then
        local it = lootWorthRoom(junk)
        if not it then return end -- nothing left to loot is worth more than your cheapest junk
        data = { lootSlot = it.slot }
        why = it.link .. (it.count > 1 and (" x" .. it.count) or "") .. (it.quest and " (quest item)" or "")
    else
        why = "the quest's item"
    end
    lastOffer = GetTime()
    local gone = junk.link .. (junk.count > 1 and (" x" .. junk.count) or "")
    local ok, done = pcall(S.MakeRoom, data)
    local log = StewardCharDB.junkLog or {}
    StewardCharDB.junkLog = log
    table.insert(log, 1, date("%m-%d %H:%M") .. (ok and done and " deleted " or " could not delete ") .. gone
        .. " (" .. money(junk.worth) .. ") for " .. why .. (ok and "" or (": " .. tostring(done))))
    local err = done
    log[31] = nil
    if not ok then S:LogError("bagsfull", err) end
end)
