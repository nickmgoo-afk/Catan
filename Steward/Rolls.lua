local ADDON, S = ...

-- Roll on gear for me (0.82.0, 2026-11-22). Nick: "Can you implement an auto need/greed feature for gear?"
--
-- When a group loot roll starts on a piece of gear, Steward rolls for you:
--   Need   - it's an upgrade for your spec, by the same score that equips your gear (Items.lua S:Compare / S:IsUpgrade),
--            you can wear it now, and for armor it's your class's own armor type (no cloth for a warrior);
--   Greed  - any other gear (not an upgrade, a level you haven't reached, another armor type, can't use it).
-- Anything that isn't gear (recipes, bags, mounts, materials...) is left to you, and so is every roll while you hold
-- Shift when it starts. Nothing is said on screen: the game's roll window closes itself; Steward keeps a short log
-- (StewardCharDB.rollLog, the last 30) of what it rolled and why.

local ARMOR_SLOTS = { INVTYPE_HEAD = true, INVTYPE_SHOULDER = true, INVTYPE_CHEST = true, INVTYPE_ROBE = true,
    INVTYPE_WAIST = true, INVTYPE_LEGS = true, INVTYPE_FEET = true, INVTYPE_WRIST = true, INVTYPE_HAND = true }
local NEED, GREED = 1, 2

-- the armor your class wears at your level (1 cloth, 2 leather, 3 mail, 4 plate): warriors and paladins take plate
-- at 40 and wear mail before, hunters and shamans mail at 40 and leather before
local function ownArmor(class, level)
    if class == "WARRIOR" or class == "PALADIN" then return level >= 40 and 4 or 3 end
    if class == "HUNTER" or class == "SHAMAN" then return level >= 40 and 3 or 2 end
    if class == "ROGUE" or class == "DRUID" then return 2 end
    return 1
end
S.RollOwnArmor = ownArmor

-- what to roll on an item: NEED, GREED or nil (leave it to you), and why; "wait" while the game hasn't the item's data
function S:RollChoice(link, canNeed, canGreed)
    local info = link and self:ReadItem(link)
    if not info then return nil, "wait" end
    if not info.equippable then return nil, "not gear" end
    local function greed(why)
        if canGreed == false then return nil, why .. " (no greed on it)" end
        return GREED, why
    end
    local level = UnitLevel("player") or 1
    if (info.reqLevel or 0) > level then return greed("needs level " .. info.reqLevel) end
    if info.usable == false then return greed("you can't use it") end
    if self.CanUseType and not self.CanUseType(info.classID, info.subClassID) then return greed("not for your class") end
    local _, class = UnitClass("player")
    if info.classID == 4 and ARMOR_SLOTS[info.equipLoc] and info.subClassID ~= ownArmor(class, level) then
        return greed("not your armor type")
    end
    if canNeed == false then return greed("the game won't let you need it") end
    local cmp = self:Compare(info)
    if self:IsUpgrade(cmp) then return NEED, string.format("upgrade for %s (+%.0f%%)", (self.SpecLabel and self:SpecLabel()) or "your spec", cmp.pct or 0) end
    return greed("not an upgrade")
end

local function log(entry)
    StewardCharDB.rollLog = StewardCharDB.rollLog or {}
    local L = StewardCharDB.rollLog
    L[#L + 1] = entry
    while #L > 30 do table.remove(L, 1) end
end

local ours = {}             -- the rolls Steward made: [rollID] = NEED / GREED (to answer the bind-on-pickup question)

local function decide(rollID, tries)
    if not S:Get("lootRolls") then return end
    if not (GetLootRollItemInfo and GetLootRollItemLink and RollOnLoot) then return end
    local _, name, _, quality, bop, canNeed, canGreed = GetLootRollItemInfo(rollID)
    if not name then return end                                   -- the roll is over
    local link = GetLootRollItemLink(rollID)
    local choice, why = S:RollChoice(link, canNeed, canGreed)
    if why == "wait" then
        if tries < 15 then C_Timer.After(0.2, function() decide(rollID, tries + 1) end) end
        return
    end
    if not choice then return end
    ours[rollID] = choice
    local ok, err = pcall(RollOnLoot, rollID, choice)
    log(date("%m-%d %H:%M ") .. (choice == NEED and "Need " or "Greed ") .. tostring(link or name) .. ": " .. why ..
        (ok and "" or " (the game refused: " .. tostring(err) .. ")"))
end

S:On("START_LOOT_ROLL", function(rollID)
    if not rollID then return end
    if IsShiftKeyDown and IsShiftKeyDown() then return end        -- hold Shift: roll yourself
    decide(rollID, 0)
end)

-- a bind-on-pickup item asks first; for a roll Steward made, the answer is yes
S:On("CONFIRM_LOOT_ROLL", function(rollID, rollType)
    if not (rollID and ours[rollID] and ours[rollID] == rollType) then return end
    if ConfirmLootRoll then ConfirmLootRoll(rollID, rollType) end
    if StaticPopup_Hide then StaticPopup_Hide("CONFIRM_LOOT_ROLL", rollID) end
end)
S:On("CANCEL_LOOT_ROLL", function(rollID) if rollID then ours[rollID] = nil end end)
