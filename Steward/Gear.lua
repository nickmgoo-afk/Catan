local _, S = ...

local C = C_Container or {}
local GetNumSlots = C.GetContainerNumSlots or _G.GetContainerNumSlots
local GetItemLink = C.GetContainerItemLink or _G.GetContainerItemLink
local PickupItem = C.PickupContainerItem or _G.PickupContainerItem
local EquipPending = _G.EquipPendingItem or (C_Item and C_Item.EquipPendingItem)

local function isLocked(bag, slot)
    if C.GetContainerItemInfo then
        local t = C.GetContainerItemInfo(bag, slot)
        return t and t.isLocked
    elseif _G.GetContainerItemInfo then
        return select(3, _G.GetContainerItemInfo(bag, slot))
    end
end

local function isBound(bag, slot)
    if C_Item and C_Item.IsBound and ItemLocation then
        local loc = ItemLocation:CreateFromBagAndSlot(bag, slot)
        if loc and loc:IsValid() then return C_Item.IsBound(loc) end
    end
    if C_TooltipInfo and C_TooltipInfo.GetBagItem then
        local data = C_TooltipInfo.GetBagItem(bag, slot)
        for _, line in ipairs(data and data.lines or {}) do
            if line.leftText == ITEM_SOULBOUND then return true end
        end
        return false
    end
    return nil
end

-- calls fn(bag, slot, info) for every loaded, equippable item in the backpack and bags
function S:ForEachBagItem(fn)
    local missing = false
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        for slot = 1, (GetNumSlots(bag) or 0) do
            local link = GetItemLink(bag, slot)
            if link then
                local info = self:ReadItem(link)
                if not info then
                    missing = true
                elseif info.equippable then
                    fn(bag, slot, info)
                end
            end
        end
    end
    return missing
end

function S:IsBoEInBag(bag, slot, info)
    if info.bindType ~= 2 then return false end
    local bound = isBound(bag, slot)
    return bound == false
end

-- equips the game refused (bags full for the off-hand, unique-equipped, ...): don't retry
-- for a while, so nothing spams "Inventory is full"
local failed, lastTry = {}, nil
local function failKey(e) return e.info.link .. "@" .. e.bag .. ":" .. e.slot end

-- the single best move right now, plus a list of everything considered (for /steward why)
function S:PlanGear()
    local best, all = nil, {}
    local missing = self:ForEachBagItem(function(bag, slot, info)
        local entry = { bag = bag, slot = slot, info = info }
        all[#all + 1] = entry
        if not info.usable then entry.reason = "can't use" return end
        -- tools (a Mining Pick, a Blacksmith Hammer) and fishing poles are never "weapons" to Steward: it put the
        -- Mining Pick on whenever the main hand was empty, then took it off again (Nick's log, 11-22 to 11-26)
        if info.classID == 2 and (info.subClassID == 14 or info.subClassID == 20) then entry.reason = "a tool" return end
        local cmp = self:Compare(info, bag, slot)
        entry.cmp = cmp
        if not self:IsUpgrade(cmp) then entry.reason = "not an upgrade" return end
        entry.boe = self:IsBoEInBag(bag, slot, info)
        if entry.boe and not self:Get("gearBoE") then entry.reason = "bind on equip, left in bags" return end
        local f = failed[failKey(entry)]
        if f and GetTime() - f < 120 then entry.reason = "the game refused to equip it" return end
        entry.reason = "upgrade"
        if not best or cmp.pct > best.cmp.pct then best = entry end
    end)
    return best, all, missing
end

local pendingUntil = 0
local scheduled = false
S.queuedForCombat = false

function S:CanEquipNow()
    if InCombatLockdown() or UnitAffectingCombat("player") then return false, "combat" end
    if UnitIsDeadOrGhost("player") then return false, "dead" end
    if UnitCastingInfo("player") or UnitChannelInfo("player") then return false, "casting" end
    if CursorHasItem() then return false, "cursor" end
    return true
end

-- a fishing pole in your hands (1.0.2, Nick 2026-11-25: "I don't want steward unequipping fishing poles when i'm
-- trying to fish"): Steward leaves all your gear alone until you put your weapon back on yourself
local function fishingPoleInHand()
    local link = GetInventoryItemLink("player", 16)
    if not link then return false end
    local get = (C_Item and C_Item.GetItemInfoInstant) or _G.GetItemInfoInstant
    if not get then return false end
    local _, _, _, _, _, classID, subClassID = get(link)
    return classID == 2 and subClassID == 20
end
S.FishingPoleInHand = fishingPoleInHand

function S:RunGear()
    scheduled = false
    if not self:Get("gearAuto") or self:Get("gearTest") then return end
    if fishingPoleInHand() then
        if not self.fishingNoted then
            self.fishingNoted = true
            self:Print("fishing pole in your hands: your gear stays as it is until you put your weapon back on.")
        end
        return
    end
    self.fishingNoted = nil
    local ok, why = self:CanEquipNow()
    if not ok then
        if why == "combat" then self.queuedForCombat = true else self:ScheduleGear(1) end
        return
    end
    -- did the last attempt go through? if the item is still sitting in that bag slot, it didn't
    if lastTry then
        if GetItemLink(lastTry.bag, lastTry.slot) == lastTry.info.link then failed[failKey(lastTry)] = GetTime() end
        lastTry = nil
    end
    local best, _, missing = self:PlanGear()
    if best then
        lastTry = best
        if isLocked(best.bag, best.slot) then self:ScheduleGear(0.5) return end
        pendingUntil = GetTime() + 2
        self:Log("equipLog", {
            when = date("%Y-%m-%d %H:%M"), level = UnitLevel("player"), spec = self:SpecLabel(),
            item = best.info.link, slot = best.cmp.slot, replaced = GetInventoryItemLink("player", best.cmp.slot),
            old = best.cmp.old, new = best.cmp.new, pct = best.cmp.pct, boe = best.boe,
        })
        ClearCursor()
        PickupItem(best.bag, best.slot)
        EquipCursorItem(best.cmp.slot)
        if CursorHasItem() then ClearCursor() end
        -- equipping fires bag/equipment events, which schedule the next pass
        self:ScheduleGear(0.6)
    elseif missing then
        self:ScheduleGear(1) -- some item data still loading
    end
end

function S:ScheduleGear(delay)
    if scheduled then return end
    scheduled = true
    C_Timer.After(delay or 0.3, function() S:RunGear() end)
end

-- confirm the bind-on-equip prompt, but only for equips Steward started
local function confirmBind(slot)
    if GetTime() > pendingUntil or not S:Get("gearBoE") then return end
    if EquipPending and slot then EquipPending(slot) end
    StaticPopup_Hide("EQUIP_BIND")
    StaticPopup_Hide("EQUIP_BIND_TRADEABLE")
    StaticPopup_Hide("AUTOEQUIP_BIND")
end
S:On("EQUIP_BIND_CONFIRM", confirmBind)
S:On("EQUIP_BIND_TRADEABLE_CONFIRM", confirmBind)

-- you changed a piece yourself (1.0.2, Nick 2026-11-25: "it didn't switch, so steward was considering them equal? Or
-- not? I don't understand"): one line says what Steward makes of it, by your spec's score. Steward puts the old
-- piece back only when it's clearly better (Items.lua S:IsUpgrade: at least 1% and 0.5 points, or 10%); otherwise
-- your choice stays on.
local worn = {}
local function snapshot() for slot = 1, 18 do worn[slot] = GetInventoryItemLink("player", slot) end end
local function nameOf(link) return link and (link:match("%[(.-)%]") or link) or "nothing" end
local function explainYourChange(slot, before)
    if not (S:Get("gearAuto") and not S:Get("gearTest")) or fishingPoleInHand() then return end
    local now = GetInventoryItemLink("player", slot)
    if not (now and before) or now == before or slot == 4 or slot == 19 then return end   -- shirt, tabard
    local info = S:ReadItem(before)
    if not (info and info.equippable and info.usable ~= false) then return end
    local cmp = S:Compare(info, nil, nil)
    if not cmp then return end
    local spec = (S:SpecLabel() or "your spec"):gsub("^Auto%-detect %((.*)%)$", "%1")
    local yours, theirs = cmp.old, cmp.new
    if slot >= 11 and slot <= 14 then   -- rings and trinkets: this slot's two, not the weaker of the pair
        local w, nowInfo = S:Weights(), S:ReadItem(now)
        if nowInfo then yours, theirs = S:Score(nowInfo, slot, w), S:Score(info, slot, w) end
    end
    local nums = string.format("%.1f for %s vs %.1f", yours, nameOf(now), theirs)
    local msg
    -- the other way round: is yours clearly better than the old one, by the same margin?
    local back = { old = cmp.new, new = cmp.old, delta = -cmp.delta }
    back.pct = (back.old > 0) and (back.delta / back.old * 100) or (back.new > 0 and 100 or 0)
    if S:IsUpgrade(cmp) then
        msg = string.format("%s scores higher for %s (%s): Steward puts it back on.", nameOf(before), spec, nums)
    elseif S:IsUpgrade(back) then
        msg = string.format("%s scores higher than %s for %s (%s): good pick, it stays on.", nameOf(now), nameOf(before), spec, nums)
    else
        msg = string.format("%s and %s score about the same for %s (%s): too close to swap either way, so yours stays on.",
            nameOf(now), nameOf(before), spec, nums)
    end
    S:Print(msg)
    S:Log("youEquipLog", { when = date("%Y-%m-%d %H:%M"), level = UnitLevel("player"), spec = spec, slot = cmp.slot,
        item = now, replaced = before, yours = yours, theirs = theirs, pct = cmp.pct, said = msg })
end
S:On("PLAYER_EQUIPMENT_CHANGED", function(slot)
    local before = slot and worn[slot]
    if slot then worn[slot] = GetInventoryItemLink("player", slot) end
    if not slot or GetTime() <= pendingUntil then return end   -- Steward's own change
    C_Timer.After(0.2, function()
        local ok, err = pcall(explainYourChange, slot, before)
        if not ok then S:LogError("gear (your change)", err) end
    end)
end)

local function kick() S:ScheduleGear(0.4) end
S:On("BAG_UPDATE_DELAYED", kick)
S:On("PLAYER_LEVEL_UP", function() wipe(failed) end)
S:On("PLAYER_ENTERING_WORLD", function() S:ClearItemCache() S:ScheduleGear(3) pcall(snapshot) end)
S:On("PLAYER_LEVEL_UP", function() S:ClearItemCache() C_Timer.After(1, kick) end)
S:On("SKILL_LINES_CHANGED", function() S:ClearItemCache() kick() end)
S:On("CHARACTER_POINTS_CHANGED", kick)
S:On("PLAYER_TALENT_UPDATE", kick)
S:On("GET_ITEM_INFO_RECEIVED", function() if not scheduled then S:ScheduleGear(0.5) end end)
S:On("PLAYER_REGEN_ENABLED", function()
    if S.queuedForCombat then S.queuedForCombat = false S:ScheduleGear(0.5) end
end)

function S:Log(key, entry)
    local log = StewardCharDB[key] or {}
    StewardCharDB[key] = log
    table.insert(log, entry)
    while #log > 100 do table.remove(log, 1) end
end

local SLOT_NAMES = { "Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands",
    "Finger 1", "Finger 2", "Trinket 1", "Trinket 2", "Back", "Main hand", "Off hand", "Ranged" }

function S:ExplainGear()
    local best, all, missing = self:PlanGear()
    self:Print("spec " .. self:SpecLabel() .. (self:Get("gearTest") and " | test mode" or "") ..
        (self:Get("gearAuto") and "" or " | auto-equip off"))
    if #all == 0 then print("  no equippable items in your bags") end
    for _, e in ipairs(all) do
        local c = e.cmp
        local where = c and SLOT_NAMES[c.slot] or "-"
        local nums = c and string.format(" %s %.1f -> %.1f (%+.0f%%)", where, c.old, c.new, c.pct) or ""
        print("  " .. e.info.link .. nums .. " : " .. e.reason .. (e == best and " |cff20ff20<- next|r" or ""))
    end
    if missing then print("  (some item data is still loading, try again in a moment)") end
end
