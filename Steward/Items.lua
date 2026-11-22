local _, S = ...

local GetItemInfo = (C_Item and C_Item.GetItemInfo) or _G.GetItemInfo
local GetItemInfoInstant = (C_Item and C_Item.GetItemInfoInstant) or _G.GetItemInfoInstant
local GetItemStats = (C_Item and C_Item.GetItemStats) or _G.GetItemStats

-- equip location -> inventory slots it can go in
S.LOC_SLOTS = {
    INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 },
    INVTYPE_CHEST = { 5 }, INVTYPE_ROBE = { 5 }, INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 },
    INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 }, INVTYPE_HAND = { 10 },
    INVTYPE_FINGER = { 11, 12 }, INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 },
    INVTYPE_WEAPON = { 16, 17 }, INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 },
    INVTYPE_WEAPONOFFHAND = { 17 }, INVTYPE_SHIELD = { 17 }, INVTYPE_HOLDABLE = { 17 },
    INVTYPE_RANGED = { 18 }, INVTYPE_RANGEDRIGHT = { 18 }, INVTYPE_THROWN = { 18 }, INVTYPE_RELIC = { 18 },
}
local OFFHAND_LOC = { INVTYPE_WEAPONOFFHAND = true, INVTYPE_SHIELD = true, INVTYPE_HOLDABLE = true }
local WEAPON_LOC = { INVTYPE_WEAPON = true, INVTYPE_2HWEAPON = true, INVTYPE_WEAPONMAINHAND = true,
    INVTYPE_WEAPONOFFHAND = true }

-- GetItemStats keys -> our stat names
local STAT_KEYS = {
    ITEM_MOD_STRENGTH_SHORT = "str", ITEM_MOD_AGILITY_SHORT = "agi", ITEM_MOD_STAMINA_SHORT = "sta",
    ITEM_MOD_INTELLECT_SHORT = "int", ITEM_MOD_SPIRIT_SHORT = "spi", RESISTANCE0_NAME = "armor",
    ITEM_MOD_DAMAGE_PER_SECOND_SHORT = "dps", ITEM_MOD_ATTACK_POWER_SHORT = "ap",
    ITEM_MOD_RANGED_ATTACK_POWER_SHORT = "rap",
    ITEM_MOD_HIT_RATING_SHORT = "hit", ITEM_MOD_HIT_MELEE_RATING_SHORT = "hit",
    ITEM_MOD_HIT_RANGED_RATING_SHORT = "hit",
    ITEM_MOD_CRIT_RATING_SHORT = "crit", ITEM_MOD_CRIT_MELEE_RATING_SHORT = "crit",
    ITEM_MOD_CRIT_RANGED_RATING_SHORT = "crit",
    ITEM_MOD_HIT_SPELL_RATING_SHORT = "spellhit", ITEM_MOD_CRIT_SPELL_RATING_SHORT = "spellcrit",
    ITEM_MOD_POWER_REGEN0_SHORT = "mp5", ITEM_MOD_MANA_REGENERATION_SHORT = "mp5",
    ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = "def", ITEM_MOD_DODGE_RATING_SHORT = "dodge",
    ITEM_MOD_PARRY_RATING_SHORT = "parry", ITEM_MOD_BLOCK_RATING_SHORT = "block",
    ITEM_MOD_BLOCK_VALUE_SHORT = "blockval", ITEM_MOD_SPELL_HEALING_DONE_SHORT = "heal",
    ITEM_MOD_SPELL_HEALING_DONE = "heal",
    ITEM_MOD_EXPERTISE_RATING_SHORT = "expertise",
}
local PERCENT_STATS = { hit = true, crit = true, spellhit = true, spellcrit = true, dodge = true, parry = true,
    block = true, expertise = true }
-- "Increased Two-handed Maces +3": weapon skill by weapon type -> the game's weapon subclass number
local WEAPON_SKILL = { axes = 0, ["two-handed axes"] = 1, maces = 4, ["two-handed maces"] = 5, polearms = 6,
    swords = 7, ["two-handed swords"] = 8, staves = 10, ["fist weapons"] = 13, daggers = 15 }

-- "Equip:" lines (English client). Each pattern adds to one or more stats.
-- Forever writes percentages with a decimal ("chance to hit by 1.5%", "critical strike by 2.0%"), so every
-- percent pattern takes digits and a point.
local EQUIP_PATTERNS = {
    { "damage and healing done by magical spells and effects by up to (%d+)", { "sp", "heal" } },
    { "healing done by spells and effects by up to (%d+)", { "heal" } },
    { "damage done by %a+ spells and effects by up to (%d+)", { "sp" }, 0.6 },
    -- Forever writes expertise as "Reduces chance to be Dodged or Parried by 1.0%." (Wowhead, Edgemaster's Handguards)
    { "[Dd]odged or [Pp]arried by ([%d%.]+)%%", { "expertise" } },
    { "[Ee]xpertise by (%d+)", { "expertise" } },
    { "chance to hit with spells by ([%d%.]+)%%", { "spellhit" } },
    { "critical strike with spells by ([%d%.]+)%%", { "spellcrit" } },
    { "chance to hit by ([%d%.]+)%%", { "hit" } },
    { "chance to get a critical strike by ([%d%.]+)%%", { "crit" } },
    { "%+(%d+) ranged [Aa]ttack [Pp]ower", { "rap" } },
    { "%+(%d+) [Aa]ttack [Pp]ower", { "ap" } },
    { "[Rr]estores (%d+) mana per 5 sec", { "mp5" } },
    { "[Dd]efense %+(%d+)", { "def" } },
    { "chance to dodge an attack by ([%d%.]+)%%", { "dodge" } },
    { "chance to parry an attack by ([%d%.]+)%%", { "parry" } },
    { "chance to block attacks with a shield by ([%d%.]+)%%", { "block" } },
    { "block value of your shield by (%d+)", { "blockval" } },
}
-- base stat lines, used only when GetItemStats returns nothing
local BASE_PATTERNS = {
    { "^%+(%d+) Strength", "str" }, { "^%+(%d+) Agility", "agi" }, { "^%+(%d+) Stamina", "sta" },
    { "^%+(%d+) Intellect", "int" }, { "^%+(%d+) Spirit", "spi" }, { "^(%d+) Armor", "armor" },
    { "%(([%d%.]+) damage per second%)", "dps" }, { "^(%d+) Block", "blockval" },
}

local function isRed(c)
    return c and c.r and c.r > 0.9 and c.g < 0.2 and c.b < 0.2
end

-- hidden tooltip for clients without C_TooltipInfo
local scanTip
local function legacyLines(link)
    if not scanTip then
        scanTip = CreateFrame("GameTooltip", "StewardScanTooltip", nil, "GameTooltipTemplate")
        scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    scanTip:ClearLines()
    scanTip:SetHyperlink(link)
    local lines = {}
    for i = 1, scanTip:NumLines() do
        local l, r = _G["StewardScanTooltipTextLeft" .. i], _G["StewardScanTooltipTextRight" .. i]
        local line = {}
        if l and l:GetText() then
            local cr, cg, cb = l:GetTextColor()
            line.leftText, line.leftColor = l:GetText(), { r = cr, g = cg, b = cb }
        end
        if r and r:IsShown() and r:GetText() then
            local cr, cg, cb = r:GetTextColor()
            line.rightText, line.rightColor = r:GetText(), { r = cr, g = cg, b = cb }
        end
        lines[#lines + 1] = line
    end
    return lines
end

function S:TooltipLines(link)
    if C_TooltipInfo and C_TooltipInfo.GetHyperlink then
        local data = C_TooltipInfo.GetHyperlink(link)
        return data and data.lines or {}
    end
    return legacyLines(link)
end

local cache = {}
function S:ClearItemCache() wipe(cache) end

-- Returns a table describing the item, or nil if the game hasn't loaded its data yet.
function S:ReadItem(link)
    if not link then return nil end
    local key = link .. "#" .. UnitLevel("player")
    if cache[key] then return cache[key] end

    local name, _, quality, _, reqLevel, _, _, _, equipLoc, _, sellPrice, classID, subClassID, bindType =
        GetItemInfo(link)
    if not name then return nil end
    if not self.LOC_SLOTS[equipLoc] then
        local info = { link = link, equippable = false }
        cache[key] = info
        return info
    end

    local info = {
        link = link, id = GetItemInfoInstant(link), name = name, quality = quality, reqLevel = reqLevel,
        equipLoc = equipLoc, sellPrice = sellPrice or 0, classID = classID, subClassID = subClassID,
        bindType = bindType, equippable = true, usable = true, stats = {},
        isTwoHand = equipLoc == "INVTYPE_2HWEAPON", isOffhand = OFFHAND_LOC[equipLoc] or false,
        isWeapon = WEAPON_LOC[equipLoc] or false,
    }

    local stats = info.stats
    local raw = GetItemStats and GetItemStats(link)
    local fromApi = false
    if raw then
        for k, v in pairs(raw) do
            local stat = STAT_KEYS[k]
            if stat then
                if PERCENT_STATS[stat] and v > 5 then v = v / 14 end -- rating, not percent
                stats[stat] = (stats[stat] or 0) + v
                fromApi = true
            end
        end
    end

    local apiHas = {}
    for stat in pairs(stats) do apiHas[stat] = true end

    local lines = self:TooltipLines(link)
    for _, line in ipairs(lines) do
        if isRed(line.leftColor) or isRed(line.rightColor) then info.usable = false end
        local text = line.leftText
        if info.isWeapon and line.rightText then
            local sp = line.rightText:match("^Speed ([%d%.]+)")
            if sp then stats.speed = tonumber(sp) end
        end
        if text then
            if text:find("^Equip:") then
                -- damage for one school of magic: counted 0.6 as spell damage for everyone (the pattern below), and
                -- kept by school so a spec that only casts that school can count it in full
                local school, schoolBy = text:match("damage done by (%a+) spells and effects by up to (%d+)")
                if school then stats["sp:" .. school] = (stats["sp:" .. school] or 0) + tonumber(schoolBy) * 0.6 end
                local skillName, skillBy = text:match("Increased ([%a%- ]+) %+(%d+)")
                local sub = skillName and WEAPON_SKILL[skillName:lower()]
                if sub then stats["wskill:" .. sub] = (stats["wskill:" .. sub] or 0) + tonumber(skillBy) end
                for _, p in ipairs(EQUIP_PATTERNS) do
                    local v = text:match(p[1])
                    if v then
                        v = tonumber(v) * (p[3] or 1)
                        for _, stat in ipairs(p[2]) do
                            if not apiHas[stat] then stats[stat] = (stats[stat] or 0) + v end
                        end
                        break
                    end
                end
            elseif not fromApi then
                for _, p in ipairs(BASE_PATTERNS) do
                    local v = text:match(p[1])
                    if v then stats[p[2]] = (stats[p[2]] or 0) + tonumber(v) end
                end
            end
        end
    end

    cache[key] = info
    return info
end

-- score of an item when worn in a given slot
function S:Score(info, slot, weights)
    if not info or not info.equippable then return 0 end
    weights = weights or self:Weights()
    local total = 0
    for stat, v in pairs(info.stats) do
        local w
        if stat == "dps" then
            w = (slot == 18) and (weights.rdps or 0) or (weights.dps or 0)
            if slot == 17 and info.isWeapon then w = w * 0.5 end
        elseif stat == "speed" then
            -- a slower swing only counts for a two-hander in your hands
            w = (info.isTwoHand and slot == 16) and (weights.speed or 0) or 0
        elseif type(stat) == "string" and stat:find("^wskill:") then
            -- weapon skill counts for the kind of weapon you hold (or for the weapon itself)
            w = 0
            if weights.wskill then
                local sub
                if info.isWeapon and slot == 16 then sub = info.subClassID
                else
                    local link = GetInventoryItemLink and GetInventoryItemLink("player", 16)
                    local get = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
                    if link and get then sub = select(7, get(link)) end
                end
                if sub and stat == "wskill:" .. sub then w = weights.wskill end
            end
        else
            w = weights[stat] or 0
        end
        total = total + v * w
    end
    return total
end

function S:EquippedInfo(slot)
    local link = GetInventoryItemLink("player", slot)
    if not link then return nil, true end
    local info = self:ReadItem(link)
    return info, info ~= nil
end

local function canDualWield()
    return CanDualWield and CanDualWield() or false
end

-- best off-hand candidate in bags (used when weighing a 1H against an equipped 2H)
function S:BestBagOffhand(excludeBag, excludeSlot, weights)
    local best, bestBag, bestSlot = 0, nil, nil
    self:ForEachBagItem(function(bag, slot, info)
        if bag == excludeBag and slot == excludeSlot then return end
        if not info.usable then return end
        if info.isOffhand or (info.equipLoc == "INVTYPE_WEAPON" and canDualWield()) then
            local sc = self:Score(info, 17, weights)
            if sc > best then best, bestBag, bestSlot = sc, bag, slot end
        end
    end)
    return best, bestBag, bestSlot
end

-- Compare an item against what's equipped.
-- Returns { slot, new, old, delta, pct } for the best slot, or nil (not comparable / not loaded).
function S:Compare(info, bag, bagSlot)
    if not info or not info.equippable then return nil end
    local weights = self:Weights()
    local loc = info.equipLoc
    local candidates = {}

    local function add(slot, new, old)
        candidates[#candidates + 1] = { slot = slot, new = new, old = old }
    end

    local mh = self:EquippedInfo(16)
    local mhIs2H = mh and mh.isTwoHand

    if loc == "INVTYPE_FINGER" or loc == "INVTYPE_TRINKET" then
        local a, b = self.LOC_SLOTS[loc][1], self.LOC_SLOTS[loc][2]
        local ia, la = self:EquippedInfo(a)
        local ib, lb = self:EquippedInfo(b)
        if not (la and lb) then return nil end
        if (ia and ia.id == info.id) or (ib and ib.id == info.id) then return nil end
        local sa, sb = self:Score(ia, a, weights), self:Score(ib, b, weights)
        if sa <= sb then add(a, self:Score(info, a, weights), sa) else add(b, self:Score(info, b, weights), sb) end
    elseif loc == "INVTYPE_2HWEAPON" then
        local oh, lo = self:EquippedInfo(17)
        if not lo then return nil end
        add(16, self:Score(info, 16, weights), self:Score(mh, 16, weights) + self:Score(oh, 17, weights))
    elseif loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONMAINHAND" then
        if mhIs2H then
            local ohBest = self:BestBagOffhand(bag, bagSlot, weights)
            add(16, self:Score(info, 16, weights) + ohBest, self:Score(mh, 16, weights))
        else
            add(16, self:Score(info, 16, weights), self:Score(mh, 16, weights))
            if canDualWield() then
                local oh, lo = self:EquippedInfo(17)
                local ohIsWeaponSlot = lo and not (oh and oh.isOffhand and not oh.isWeapon)
                if ohIsWeaponSlot and loc == "INVTYPE_WEAPON" then
                    add(17, self:Score(info, 17, weights), self:Score(oh, 17, weights))
                end
                -- new weapon to the main hand, current main hand moves to the off-hand on the next pass
                if ohIsWeaponSlot and mh and mh.equipLoc == "INVTYPE_WEAPON" then
                    add(16, self:Score(info, 16, weights) + self:Score(mh, 17, weights),
                        self:Score(mh, 16, weights) + self:Score(oh, 17, weights))
                end
            end
        end
    elseif info.isOffhand then
        if mhIs2H then return nil end
        local oh, lo = self:EquippedInfo(17)
        if not lo then return nil end
        add(17, self:Score(info, 17, weights), self:Score(oh, 17, weights))
    else
        local slot = self.LOC_SLOTS[loc][1]
        local cur, lc = self:EquippedInfo(slot)
        if not lc then return nil end
        if cur and cur.id == info.id then return nil end
        add(slot, self:Score(info, slot, weights), self:Score(cur, slot, weights))
    end

    local best
    for _, c in ipairs(candidates) do
        c.delta = c.new - c.old
        c.pct = (c.old > 0) and (c.delta / c.old * 100) or (c.new > 0 and 100 or 0)
        if not best or c.delta > best.delta then best = c end
    end
    return best
end

function S:IsUpgrade(cmp)
    -- a clear gain, or (early on, when every item is tiny) a big step up in relative terms
    return cmp and cmp.pct >= 1 and (cmp.delta > 0.5 or (cmp.delta > 0 and cmp.pct >= 10)) or false
end

-- White or green gear in your bags that you won't wear: not usable by you, or no better than
-- what you have on (by your spec's score). Never: blues and up, profession tools, fishing poles,
-- shirts, tabards, bags, ammo, gear for a level you haven't reached, or items with no sell price.
local TOOLS = { [2901] = true, [5956] = true, [7005] = true, [6219] = true, [6256] = true, [6365] = true,
    [6366] = true, [6367] = true, [12225] = true, [19022] = true, [19970] = true, [6218] = true, [6339] = true,
    [11130] = true, [11145] = true, [16207] = true, [9149] = true, [12709] = true, [20815] = true, [20824] = true,
    [778] = true, [756] = true, [1959] = true, [12224] = true }
local KEEP_LOC = { INVTYPE_BODY = true, INVTYPE_TABARD = true, INVTYPE_BAG = true, INVTYPE_QUIVER = true,
    INVTYPE_AMMO = true, INVTYPE_RELIC = true, INVTYPE_THROWN = false }
-- weapon and armor types each class can use (Classic rules); nil = no limit known
local WEAPONS = {
    WARRIOR = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 13, 15, 16, 18 },
    PALADIN = { 0, 1, 4, 5, 6, 7, 8 },
    HUNTER = { 0, 1, 2, 3, 6, 7, 8, 10, 13, 15, 16, 18 },
    ROGUE = { 2, 3, 4, 7, 13, 15, 16, 18 },
    PRIEST = { 4, 10, 15, 19 },
    SHAMAN = { 0, 1, 4, 5, 10, 13, 15 },
    MAGE = { 7, 10, 15, 19 },
    WARLOCK = { 7, 10, 15, 19 },
    DRUID = { 4, 5, 10, 13, 15 },
}
local ARMOR = { -- 1 cloth, 2 leather, 3 mail, 4 plate, 6 shield
    WARRIOR = { 1, 2, 3, 4, 6 }, PALADIN = { 1, 2, 3, 4, 6 }, HUNTER = { 1, 2, 3 }, ROGUE = { 1, 2 },
    PRIEST = { 1 }, SHAMAN = { 1, 2, 3, 6 }, MAGE = { 1 }, WARLOCK = { 1 }, DRUID = { 1, 2 },
}
local function canUse(classID, subClassID)
    local _, class = UnitClass("player")
    local list = (classID == 2 and WEAPONS or ARMOR)[class or ""]
    if not list then return true end
    if classID == 4 and (subClassID == 0 or subClassID == 7 or subClassID == 8 or subClassID == 9 or subClassID == 10) then
        return true -- rings, necks, cloaks, librams, idols, totems
    end
    for _, v in ipairs(list) do if v == subClassID then return true end end
    return false
end

S.CanUseType = canUse      -- for the loot rolls (Rolls.lua)

local function why(id, reason)
    StewardCharDB.sellLog = StewardCharDB.sellLog or {}
    local log = StewardCharDB.sellLog
    log[#log + 1] = date("%H:%M ") .. tostring(id) .. ": " .. reason
    while #log > 30 do table.remove(log, 1) end
end

function S:WontWear(bagInfo)
    local id = bagInfo and bagInfo.itemID
    if not id or TOOLS[id] or bagInfo.hasNoValue then return false end
    local q = bagInfo.quality
    if q ~= 1 and q ~= 2 then return false end
    local getInfo = (C_Item and C_Item.GetItemInfo) or _G.GetItemInfo
    local link = bagInfo.hyperlink or select(2, getInfo(id))
    local name, _, _, _, reqLevel, _, _, _, equipLoc, _, sellPrice, classID, subClassID = getInfo(link or id)
    if not name or (sellPrice or 0) <= 0 then return false end
    if classID ~= 2 and classID ~= 4 then return false end
    if classID == 2 and (subClassID == 14 or subClassID == 20) then return false end -- tools, fishing poles
    if not equipLoc or equipLoc == "" or KEEP_LOC[equipLoc] then return false end
    if (reqLevel or 0) > (UnitLevel("player") or 1) then return false end
    if not canUse(classID, subClassID) then why(id, "can't use: sell") return true end
    local info = self:ReadItem(link)
    if not info or not info.equippable then return false end
    if info.usable == false then why(id, "red in tooltip: sell") return true end
    -- an off-hand while you wield a two-hander: only worth keeping if a one-hander in your
    -- bags with it would beat the two-hander
    local mh = self:EquippedInfo(16)
    if info.isOffhand and mh and mh.isTwoHand then
        local weights = self:Weights()
        local best1h = 0
        self:ForEachBagItem(function(_, _, bi)
            if bi and (bi.equipLoc == "INVTYPE_WEAPON" or bi.equipLoc == "INVTYPE_WEAPONMAINHAND") then
                best1h = math.max(best1h, self:Score(bi, 16, weights))
            end
        end)
        local keep = best1h + self:Score(info, 17, weights) > self:Score(mh, 16, weights)
        why(id, keep and "off-hand, a bag one-hander with it beats your two-hander: keep" or "off-hand, you use a two-hander: sell")
        return not keep
    end
    local cmp = self:Compare(info)
    if not cmp then why(id, "no comparison: keep") return false end
    if self:IsUpgrade(cmp) then why(id, "upgrade: keep") return false end
    local sell = (cmp.pct or 0) < 0 or (cmp.delta or 0) <= 0
    why(id, string.format("%.1f vs worn: %s", cmp.delta or 0, sell and "sell" or "keep"))
    return sell
end
