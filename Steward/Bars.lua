local _, S = ...

-- Action bar manager. Fills the bars you have turned on; never moves or resizes them.
--   main bar 1-6   your rotation        main bar 7-12   other attacks, stuns, interrupts
--   left bar above heals and defensives  right bar above  buffs, auras, seals
--   inner right    food, drink, potions, bandages
--   outer right    mount, hearthstone, travel, professions, long cooldowns
-- The first time, it lays everything out once (your old bars are saved and can be put back).
-- After that it only touches the buttons it placed itself: anything you change by hand is yours.
-- New spells and ranks, better food and potions, and a new mount go in by themselves;
-- used-up items come off. Out of combat only.

local MULTI = {
    { frame = "MultiBarBottomLeft", button = "MultiBarBottomLeftButton", base = 60, guess = "heal", flat = true },
    { frame = "MultiBarBottomRight", button = "MultiBarBottomRightButton", base = 48, guess = "buff", flat = true },
    { frame = "MultiBarLeft", button = "MultiBarLeftButton", base = 36, guess = "util", flat = false },
    { frame = "MultiBarRight", button = "MultiBarRightButton", base = 24, guess = "travel", flat = false },
}

-- where each kind of thing goes, then where it spills over to when that bar is full or off
--
-- The layout (bars as the game draws them by default):
--   main bar, keys 1 to =   everything you press in a fight: rotation and stuns packed from 1,
--                           your best heals on 9 0 -, a potion (or bandage) on =
--   bar above, left         left half: the rest of your heals and defensives (Lay on Hands,
--                           Blessing of Protection, cleanses, racials); right half: food, drink,
--                           bandages, potions, weapon stones -- what you click between pulls,
--                           close to where you look
--   bar above, right        buffs: seals you don't use in the rotation, blessings, aura groups
--   right edge, outer       getting around: mount on top, hearthstone, travel spells
--   right edge, inner       the rest: professions, long cooldowns, resurrection, your own macros
local SPILL = {
    rot = { "rot", "core" },
    keyheal = { "keyheal", "heal", "buff", "util" },
    keycons = { "keycons", "cons", "util", "travel" },
    core = { "core", "rot", "heal", "buff", "util" },
    heal = { "heal", "buff", "util" },
    buff = { "buff", "heal", "util" },
    cons = { "cons", "util", "travel" },
    travel = { "travel", "util", "buff" },
    prof = { "util", "travel", "buff" },
    long = { "util", "buff", "travel" },
    spare = { "util", "travel", "buff", "heal", "cons", "core" },
}

-- Steward's own group buttons (the game only has its own few, like Blessings): one button that
-- opens to show the spells inside, the way the game's do. A group with a single spell in it is
-- just that spell's button.
local GROUPS = {
    { key = "group:prof", name = "Professions", members = { "Blacksmithing", "Smelting", "Leatherworking", "Tailoring",
        "Engineering", "Alchemy", "Enchanting", "Disenchant", "Jewelcrafting", "Prospecting", "Inscription", "First Aid",
        "Cooking", "Basic Campfire", "Fishing", "Survey" } },
    { key = "group:track", name = "Tracking", members = { "Sense Undead", "Find Minerals", "Find Herbs", "Find Treasure",
        "Sense Demons" } },
}
S.BAR_GROUPS = GROUPS

local TANK_ONLY = {
    PALADIN = { ["Righteous Fury"] = true, ["Seal of Fury"] = true, ["Holy Shield"] = true },
}

local BANK = function() return Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player or 0 end

local function db()
    StewardCharDB = StewardCharDB or {}
    local b = StewardCharDB.bars
    if type(b) ~= "table" then
        b = {}
        StewardCharDB.bars = b
    end
    b.owned = b.owned or {}
    b.user = b.user or {}
    b.seen = b.seen or {}
    b.pushed = b.pushed or {}
    b.dropped = b.dropped or {}
    return b
end

---------------------------------------------------------------- the bars you have on
local function buttonSlot(btn, i, base)
    local a = btn and (btn.action or (btn.GetAttribute and btn:GetAttribute("action")))
    if type(a) == "number" and a > 0 then return a end
    return base + i
end

local function shownCount(bar)
    local n = bar and (bar.numButtonsShowable or bar.numShowingButtons)
    if type(n) == "number" and n > 0 and n <= 12 then return n end
    return 12
end

local function bonusOffset()
    local fn = (C_ActionBar and C_ActionBar.GetBonusBarOffset) or GetBonusBarOffset
    local ok, v = pcall(fn or function() return 0 end)
    return ok and type(v) == "number" and v or 0
end

-- the page the main bar shows right now (a stance, form or stealth has its own)
local function mainSlots()
    local slots = {}
    local offset = bonusOffset()
    local base = offset > 0 and (72 + (offset - 1) * 12) or 0
    local bar = _G.MainActionBar or _G.MainMenuBar
    for i = 1, shownCount(bar) do
        slots[#slots + 1] = buttonSlot(_G["ActionButton" .. i], i, base)
    end
    return slots
end

local function center(f)
    local l, r, b, t = f.GetLeft and f:GetLeft(), f.GetRight and f:GetRight(), f.GetBottom and f:GetBottom(), f.GetTop and f:GetTop()
    if not (l and r and b and t) then return nil end
    return (l + r) / 2, (b + t) / 2, r - l, t - b, r
end

-- regions: role -> ordered list of action slots
function S:BarRegions()
    local regions = { rot = {}, core = {}, heal = {}, buff = {}, cons = {}, travel = {}, util = {}, keyheal = {}, keycons = {} }
    local main = mainSlots()
    -- the main bar is the one with keys (1 to =), so everything you press in a fight lives there:
    -- 1-8 your rotation and then your stuns and interrupts, packed with no gaps (a spell you learn
    -- later takes the next free key), 9-11 your heals and panic button, = a potion.
    -- (In a form or stance the bar is that form's own page: rotation and abilities only.)
    local split = #main == 12 and bonusOffset() == 0
    for i, slot in ipairs(main) do
        local role = i <= 6 and "rot" or "core"
        if split then
            role = i <= 8 and "rot" or (i <= 11 and "keyheal" or "keycons")
        end
        table.insert(regions[role], slot)
    end
    local flat, tall = {}, {}
    for _, m in ipairs(MULTI) do
        local f = _G[m.frame]
        if f and f:IsShown() then
            local entry = { m = m, slots = {} }
            for i = 1, shownCount(f) do
                entry.slots[#entry.slots + 1] = buttonSlot(_G[m.button .. i], i, m.base)
            end
            local x, y, w, h, right = center(f)
            entry.x, entry.y, entry.right = x, y, right
            local isFlat = m.flat
            if w and h and w ~= h then isFlat = w > h end
            table.insert(isFlat and flat or tall, entry)
        end
    end
    -- above the main bar: side by side, the left one gets heals and the right one buffs;
    -- stacked, the one nearer the main bar gets heals
    local haveX = true
    for _, e in ipairs(flat) do if not (e.x and e.y) then haveX = false end end
    if haveX then
        table.sort(flat, function(a, b)
            if math.abs(a.x - b.x) > 20 then return a.x < b.x end
            return a.y < b.y
        end)
    end
    for i, e in ipairs(flat) do
        local role = haveX and (i == 1 and "heal" or (i == 2 and "buff" or nil)) or e.m.guess
        if role == "cons" then role = "heal" end
        if role and #regions[role] == 0 then
            if role == "heal" then
                -- left half heals and defensives, right half what you eat, drink and use between pulls
                local half = math.ceil(#e.slots / 2)
                for k, sl in ipairs(e.slots) do table.insert(k <= half and regions.heal or regions.cons, sl) end
            else
                regions[role] = e.slots
            end
        else
            for _, sl in ipairs(e.slots) do table.insert(regions.util, sl) end
        end
    end
    -- the columns on the right: the outer one for getting around, the inner one for the rest
    local haveR = true
    for _, e in ipairs(tall) do if not e.right then haveR = false end end
    if haveR then table.sort(tall, function(a, b) return a.right > b.right end) end
    for i, e in ipairs(tall) do
        local role = haveR and (i == 1 and "travel" or (i == 2 and "util" or nil)) or (e.m.guess == "cons" and "util" or e.m.guess)
        if role and regions[role] and #regions[role] == 0 then regions[role] = e.slots
        else for _, sl in ipairs(e.slots) do table.insert(regions.util, sl) end end
    end
    -- only one right column: getting around at the top, the rest below
    if #regions.travel > 0 and #regions.util == 0 and #tall == 1 then
        local all = regions.travel
        regions.travel, regions.util = {}, {}
        for k, sl in ipairs(all) do table.insert(k <= 4 and regions.travel or regions.util, sl) end
    end
    return regions
end

---------------------------------------------------------------- what is on a button
local function spellName(id)
    if not id then return nil end
    local fn = (C_Spell and C_Spell.GetSpellName)
    if fn then
        local ok, n = pcall(fn, id)
        if ok and n then return n end
    end
    local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(id)
    return info and info.name
end

local function actionAt(slot)
    if not GetActionInfo then return nil end
    local kind, id, sub = GetActionInfo(slot)
    return kind, id, sub
end

-- does the button still hold what Steward put there?
local function holds(slot, rec)
    if rec.kind == "group" then return actionAt(slot) == nil end
    local kind, id = actionAt(slot)
    if not kind then return false end
    if rec.kind == "spell" then
        return kind == "spell" and (id == rec.id or spellName(id) == rec.name)
    elseif rec.kind == "mount" then
        return (kind == "summonmount" and rec.mountID and id == rec.mountID)
            or (kind == "spell" and (id == rec.id or spellName(id) == rec.name))
            or (kind == "item" and id == rec.id)
    elseif rec.kind == "flyout" then
        return kind == "flyout" and id == rec.id
    elseif rec.kind == "item" then
        return kind == "item" and id == rec.id
    elseif rec.kind == "macro" then
        return kind == "macro" and (not rec.name or not GetActionText or GetActionText(slot) == rec.name)
    end
    return false
end

-- does the button hold this thing (whoever put it there)?
local function sameThing(slot, e)
    if e.kind == "group" then return actionAt(slot) == nil end
    local kind, id = actionAt(slot)
    if not kind then return false end
    if e.kind == "spell" then return kind == "spell" and (id == e.id or spellName(id) == e.name) end
    if e.kind == "flyout" then return kind == "flyout" and id == e.id end
    if e.kind == "item" then return kind == "item" and id == e.id end
    if e.kind == "macro" then return kind == "macro" and GetActionText and GetActionText(slot) == e.name end
    if e.kind == "mount" then
        return (kind == "summonmount" and e.mountID == id) or (kind == "spell" and spellName(id) == e.name)
            or (kind == "item" and id == e.id)
    end
    return false
end

---------------------------------------------------------------- picking up and putting down
local busy = false

local function pickup(e)
    if ClearCursor then ClearCursor() end
    if e.kind == "spell" then
        local fn = (C_Spell and C_Spell.PickupSpell) or _G.PickupSpell
        if fn then fn(e.id) end
    elseif e.kind == "mount" then
        if e.item then
            local fn = (C_Item and C_Item.PickupItem) or _G.PickupItem
            if fn then fn(e.id) end
        else
            local fn = (C_Spell and C_Spell.PickupSpell) or _G.PickupSpell
            if fn then fn(e.id) end
        end
    elseif e.kind == "flyout" then
        local fn = (C_SpellBook and C_SpellBook.PickupSpellBookItem) or _G.PickupSpellBookItem
        if fn and e.book then fn(e.book, BANK()) end
    elseif e.kind == "item" then
        local fn = (C_Item and C_Item.PickupItem) or _G.PickupItem
        if fn then fn(e.id) end
    elseif e.kind == "macro" then
        if PickupMacro then PickupMacro(e.id) end
    end
    return GetCursorInfo and GetCursorInfo() ~= nil
end

local function put(slot, e)
    if e.kind == "group" then
        -- the group button sits over an empty action button
        if actionAt(slot) then
            if ClearCursor then ClearCursor() end
            PickupAction(slot)
            if ClearCursor then ClearCursor() end
        end
        return true
    end
    if not pickup(e) then
        if ClearCursor then ClearCursor() end
        return false
    end
    PlaceAction(slot)
    -- whatever was on the button is now on the cursor: drop it
    if ClearCursor then ClearCursor() end
    return true
end

local function clear(slot)
    if not actionAt(slot) then return end
    if ClearCursor then ClearCursor() end
    PickupAction(slot)
    if ClearCursor then ClearCursor() end
end

---------------------------------------------------------------- what you have
local function rankOf(sub)
    return tonumber(type(sub) == "string" and sub:match("(%d+)") or "") or 0
end

-- spells and spell groups (flyouts) from your spellbook: name -> entry, highest rank only
local function spellbook()
    local out = {}
    local SB = C_SpellBook
    if not (SB and SB.GetNumSpellBookSkillLines) then return out end
    local lines = SB.GetNumSpellBookSkillLines() or 0
    for l = 1, lines do
        local li = SB.GetSpellBookSkillLineInfo(l)
        if li and not li.offSpecID then
            for i = li.itemIndexOffset + 1, li.itemIndexOffset + li.numSpellBookItems do
                local it = SB.GetSpellBookItemInfo(i, BANK())
                -- 1 = spell, 4 = flyout (a group of spells under one button)
                if it and it.name and not it.isPassive and not it.isOffSpec and (it.itemType == 1 or it.itemType == 4) then
                    local rank = rankOf(it.subName)
                    local old = out[it.name]
                    if not old or rank >= old.rank then
                        out[it.name] = { name = it.name, id = it.itemType == 4 and it.actionID or it.spellID,
                            kind = it.itemType == 4 and "flyout" or "spell", book = i, rank = rank, tab = li.name }
                    end
                end
            end
        end
    end
    -- profession spells (Smelting, Blacksmithing, First Aid, Cooking, Fishing...) live outside
    -- the class pages of the spellbook
    if GetProfessions and GetProfessionInfo then
        local profs = { GetProfessions() }
        for k = 1, 6 do
            local p = profs[k]
            if p then
                local ok, pname, _, _, _, numSpells, offset = pcall(GetProfessionInfo, p)
                if ok and numSpells and offset then
                    for i = offset + 1, offset + numSpells do
                        local it = SB.GetSpellBookItemInfo(i, BANK())
                        if it and it.name and not it.isPassive and it.itemType == 1 and not out[it.name] then
                            out[it.name] = { name = it.name, id = it.spellID, kind = "spell", book = i, rank = 0,
                                tab = pname or "Professions" }
                        end
                    end
                end
            end
        end
    end
    return out
end

-- names of the spells in a group button; with `knownOnly`, just the ones you have
local function flyoutMembers(id, knownOnly)
    local names = {}
    if not (GetFlyoutInfo and GetFlyoutSlotInfo) then return names end
    local ok, _, _, n = pcall(GetFlyoutInfo, id)
    if not ok then return names end
    local seenName = {}
    for i = 1, n or 0 do
        local sid, _, known, name = GetFlyoutSlotInfo(id, i)
        name = name or spellName(sid)
        if name and not seenName[name] and (known or not knownOnly) then
            seenName[name] = true
            names[#names + 1] = name
        end
    end
    return names
end

-- spells on the game's own stance/aura bar (paladin auras, warrior stances, druid forms)
local function stanceBarSpells()
    local out = {}
    if not (GetNumShapeshiftForms and GetShapeshiftFormInfo) then return out end
    for i = 1, GetNumShapeshiftForms() or 0 do
        local _, _, _, sid = GetShapeshiftFormInfo(i)
        local n = sid and spellName(sid)
        if n then out[n] = true end
    end
    return out
end

local function GetInfo(item) return ((C_Item and C_Item.GetItemInfo) or GetItemInfo)(item) end
local function GetInstant(item) return ((C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant)(item) end
local function ItemSpell(item)
    local fn = (C_Item and C_Item.GetItemSpell) or GetItemSpell
    if fn then return fn(item) end
end

local function bagItems()
    local seen, list = {}, {}
    if not (C_Container and C_Container.GetContainerNumSlots) then return list end
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        for slot = 1, C_Container.GetContainerNumSlots(bag) or 0 do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID then
                local e = seen[info.itemID]
                if not e then
                    e = { id = info.itemID, count = 0 }
                    seen[info.itemID] = e
                    list[#list + 1] = e
                end
                e.count = e.count + (info.stackCount or 1)
            end
        end
    end
    return list
end

local function usesMana()
    if not UnitPowerType then return false end
    return UnitPowerType("player") == (Enum and Enum.PowerType and Enum.PowerType.Mana or 0)
end

-- the consumable roles, best first: food, drink, healing potion, mana potion, bandage, healthstone
local ITEM_ROLES = { "food", "drink", "hp", "mp", "bandage", "stone" }

local function itemRole(id)
    local _, _, _, _, _, classID, subID = GetInstant(id)
    if classID == 15 and subID == 5 then return "mount" end
    if classID ~= 0 then return nil end
    local name = GetInfo(id)
    if name and name:find("Healthstone") then return "stone" end
    local spell, spellID = ItemSpell(id)
    local s = spell and spell:lower() or ""
    if subID == 5 then
        if s:find("refreshment", 1, true) then return "both" end
        if s:find("drink", 1, true) then return "drink" end
        if s:find("food", 1, true) then return "food" end
        return nil
    end
    if subID == 7 or s == "first aid" then return "bandage" end
    if subID == 0 or subID == 1 then
        local text = ""
        local fn = C_Spell and C_Spell.GetSpellDescription
        if fn and spellID then
            local ok, d = pcall(fn, spellID)
            if ok and type(d) == "string" then text = d:lower() end
        end
        if s:find("healing potion", 1, true) or (text:find("restores") and text:find("health")) then return "hp" end
        if s:find("restore mana", 1, true) or (text:find("restores") and text:find("mana")) then return "mp" end
    end
    return nil
end

-- weapon stones and oils, best first; a stone goes on the weapon type it fits
local SHARP = { 23122, 18262, 12404, 7964, 2871, 2863, 2862 }   -- sharpening stones (blades)
local WEIGHT = { 12643, 7965, 3241, 3240, 3239 }               -- weightstones (blunt)
local BLUNT = { [4] = true, [5] = true, [10] = true, [13] = true } -- maces, staves, fist weapons
local function weaponStone()
    local mh = GetInventoryItemID and GetInventoryItemID("player", 16)
    if not mh then return nil end
    local _, _, _, _, _, classID, subID = GetInstant(mh)
    if classID ~= 2 or subID == 2 or subID == 3 or subID == 18 or subID == 19 then return nil end -- not bows, guns, wands
    local list = BLUNT[subID] and WEIGHT or SHARP
    local level = UnitLevel("player") or 1
    for _, id in ipairs(list) do
        local count = (C_Item and C_Item.GetItemCount) or GetItemCount
        if count and (count(id) or 0) > 0 then
            local _, _, _, _, req = GetInfo(id)
            if (req or 0) <= level then return id end
        end
    end
end
S.WeaponStone = weaponStone

-- one button that uses the stone on your main-hand weapon (the stone alone asks you to click the weapon)
local MACRO_NAME = "Sharpen Weapon"
S.SHARPEN_MACRO = MACRO_NAME
local function sharpenMacro(itemID)
    if not (GetMacroIndexByName and CreateMacro) or InCombatLockdown() then return nil end
    local body = string.format("#showtooltip item:%d\n/use item:%d\n/use 16", itemID, itemID)
    local idx = GetMacroIndexByName(MACRO_NAME)
    if not idx or idx == 0 then
        local ok, made = pcall(CreateMacro, MACRO_NAME, "INV_MISC_QUESTIONMARK", body, true)
        idx = ok and made or nil
    elseif GetMacroBody and GetMacroBody(idx) ~= body and EditMacro then
        pcall(EditMacro, idx, nil, nil, body)
    end
    return idx and idx > 0 and idx or nil
end

local function better(a, b)
    if not b then return true end
    if a.req ~= b.req then return a.req > b.req end
    if a.ilvl ~= b.ilvl then return a.ilvl > b.ilvl end
    return a.count > b.count
end

local function bestItems()
    local level = UnitLevel("player") or 1
    local best = {}
    local mana = usesMana()
    for _, it in ipairs(bagItems()) do
        local role = itemRole(it.id)
        if role then
            local name, _, _, ilvl, req = GetInfo(it.id)
            req = req or 0
            local usable = true -- (bandages too: the game can call them unusable while you're at full health)
            if req <= level and usable then
                local c = { id = it.id, name = name, req = req, ilvl = ilvl or 0, count = it.count }
                local targets = { role }
                if role == "both" then targets = mana and { "food", "drink" } or { "food" } end
                if role == "drink" and not mana then targets = {} end
                if role == "mp" and not mana then targets = {} end
                for _, r in ipairs(targets) do
                    if better(c, best[r]) then best[r] = c end
                end
            end
        end
    end
    -- refreshment that is the best of both goes on the food button only
    if best.food and best.drink and best.food.id == best.drink.id then best.drink = nil end
    return best
end

-- the fastest mount you have: from the mount list, a class mount spell, or a mount in your bags
local function speedOf(spellID)
    local fn = C_Spell and C_Spell.GetSpellDescription
    if not (fn and spellID) then return 1 end
    local ok, d = pcall(fn, spellID)
    d = ok and type(d) == "string" and d:lower() or ""
    if d:find("very fast") or d:find("100%%") then return 2 end
    return 1
end

local function bestMount(book, bags)
    local best
    local function offer(e)
        if not best or e.speed > best.speed then best = e end
    end
    local MJ = C_MountJournal
    if MJ and MJ.GetMountIDs and MJ.GetMountInfoByID then
        local ok, ids = pcall(MJ.GetMountIDs)
        for _, mountID in ipairs(ok and ids or {}) do
            local name, sid, _, _, usable, _, _, _, _, hide, collected = MJ.GetMountInfoByID(mountID)
            if collected and not hide and sid and usable ~= false then
                offer({ key = "mount", kind = "mount", id = sid, mountID = mountID, name = name, speed = speedOf(sid) })
            end
        end
    end
    for name, e in pairs(book) do
        if e.kind == "spell" and S:SpellRole(name, e.id) == "travel"
            and (name:find("^Summon .*steed") or name:find("^Summon Warhorse") or name:find("^Summon Charger")) then
            offer({ key = "mount", kind = "mount", id = e.id, name = name, speed = speedOf(e.id) })
        end
    end
    for _, it in ipairs(bags) do
        if itemRole(it.id) == "mount" then
            local _, sid = ItemSpell(it.id)
            offer({ key = "mount", kind = "mount", item = true, id = it.id, name = GetInfo(it.id) or ("item " .. it.id), speed = speedOf(sid) })
        end
    end
    return best
end

---------------------------------------------------------------- the plan
local FORM = { DRUID = { [1] = "cat", [3] = "bear" }, ROGUE = { [1] = "stealth" } }

-- everything that should be on your bars: list of { key, kind, id, name, role, prio }
function S:BarPlan()
    local class = self:PlayerClass()
    -- the spec picked in Options (or detected from your talents), the same one gear, rotation and talents use
    local spec = (self.CurrentSpec and self:CurrentSpec()) or (self.DetectSpec and self:DetectSpec()) or nil
    local book = spellbook()
    local plan, inPlan = {}, {}
    local function add(e)
        if inPlan[e.key] then return end
        inPlan[e.key] = true
        plan[#plan + 1] = e
    end
    local function known(name) return book[name] ~= nil end

    -- spells inside a group button you have don't need their own button (unless they're for fighting or healing)
    local grouped = {}
    for name, e in pairs(book) do
        if e.kind == "flyout" then
            for _, member in ipairs(flyoutMembers(e.id)) do grouped[member] = name end
        end
    end
    local onStance = stanceBarSpells()

    -- would this spell get its own button? (then a group button holding it isn't needed for it)
    local function ownButton(name)
        local e = book[name]
        if not e or onStance[name] then return false end
        local role = self:SpellRole(name, e.kind == "spell" and e.id or nil, class)
        return role == "rot" or role == "core" or role == "heal"
    end
    -- a group button is only worth a slot if it holds a spell you know that isn't already
    -- on your bars or on the game's aura/stance bar
    local function groupNeeded(e)
        for _, member in ipairs(flyoutMembers(e.id, true)) do
            if not onStance[member] and not ownButton(member) then return true end
        end
        return false
    end

    -- the main bar: a form's own set while you're in it, otherwise your rotation
    local form = FORM[class] and FORM[class][bonusOffset()]
    local formList = form and self:FormList(class, form)
    local rotation = self:RotationList(class, spec, known)
    for i, name in ipairs(formList or rotation) do
        local e = book[name]
        if e then add({ key = "spell:" .. name, kind = e.kind, id = e.id, book = e.book, name = name, role = "rot", prio = i }) end
    end
    if formList then
        -- your usual rotation keeps the buttons it has, but isn't added to the form's bar
        for i, name in ipairs(rotation) do
            local e = book[name]
            if e then add({ key = "spell:" .. name, kind = e.kind, id = e.id, book = e.book, name = name, role = "core",
                prio = i, keepOnly = true }) end
        end
    end

    local roleData = self.SPELL_ROLES[class] or {}
    local function listIndex(name, role)
        for i, p in ipairs(roleData[role] or {}) do if self.SpellPatternMatches(name, p) then return i end end
        for i, p in ipairs(self.COMMON_ROLES[role] or {}) do if self.SpellPatternMatches(name, p) then return 50 + i end end
        return 99
    end
    -- Steward's group buttons: two or more spells of a group share one button
    local inGroup = {}
    for _, g in ipairs(GROUPS) do
        local have = {}
        for _, m in ipairs(g.members) do
            local e = book[m]
            if e and e.kind == "spell" then have[#have + 1] = { name = m, id = e.id } end
        end
        if #have >= 2 and not (class == "HUNTER" and g.key == "group:track") then
            for _, h in ipairs(have) do inGroup[h.name] = true end
            add({ key = g.key, kind = "group", id = 0, name = g.name, members = have,
                role = g.key == "group:prof" and "prof" or "long", prio = 0 })
        end
    end

    local names = {}
    for name in pairs(book) do if not inGroup[name] then names[#names + 1] = name end end
    table.sort(names)
    for _, name in ipairs(names) do
        local e = book[name]
        local role = self:SpellRole(name, e.kind == "spell" and e.id or nil, class)
        if e.kind == "flyout" and role == "long" then role = "buff" end
        local isMount = role == "travel" and (name:find("^Summon .*steed") or name:find("^Summon Warhorse") or name:find("^Summon Charger"))
        local keepOnly = formList and role == "core" -- the caster bar keeps those
        if role and role ~= "skip" and not isMount then
            if grouped[name] and (role == "buff" or role == "long" or role == "travel") then role = nil end
            if e.kind == "flyout" and not groupNeeded(e) then role = nil end
            if onStance[name] then role = nil end -- already on the game's stance/aura bar
            -- tanking tools only for a tank (a Retribution paladin never wants Righteous Fury)
            if TANK_ONLY[class] and TANK_ONLY[class][name] and spec and spec ~= "Protection" then role = nil end
        end
        if role and role ~= "skip" and not isMount then
            add({ key = "spell:" .. name, kind = e.kind, id = e.id, book = e.book, name = name, role = role,
                prio = listIndex(name, role), keepOnly = keepOnly or nil })
        end
    end

    -- consumables
    local best = bestItems()
    for i, r in ipairs(ITEM_ROLES) do
        local it = best[r]
        if it then add({ key = "item:" .. r, kind = "item", id = it.id, name = it.name or ("item " .. it.id), role = "cons", prio = i }) end
    end

    -- the weapon stone, as a one-click button
    local stone = weaponStone()
    if stone then
        local idx = sharpenMacro(stone)
        if idx then add({ key = "macro:sharpen", kind = "macro", id = idx, name = MACRO_NAME, role = "cons", prio = 9 }) end
    end

    -- mount and hearthstone lead the travel bar
    local bags = bagItems()
    local mount = bestMount(book, bags)
    if mount then mount.role, mount.prio = "travel", -2 add(mount) end
    for _, it in ipairs(bags) do
        if it.id == 6948 then
            add({ key = "item:hearth", kind = "item", id = 6948, name = "Hearthstone", role = "travel", prio = -1 })
        end
    end

    -- your best heals and your potion (or a bandage) go on keys
    local heals = {}
    for _, e in ipairs(plan) do if e.role == "heal" and not e.keepOnly then heals[#heals + 1] = e end end
    table.sort(heals, function(a, b) if a.prio ~= b.prio then return a.prio < b.prio end return a.name < b.name end)
    for i = 1, math.min(3, #heals) do heals[i].role = "keyheal" end
    local keyItem
    for _, e in ipairs(plan) do if e.key == "item:hp" then keyItem = e end end
    if not keyItem then for _, e in ipairs(plan) do if e.key == "item:bandage" then keyItem = e end end end
    if keyItem then keyItem.role = "keycons" end

    local roleOrder = { rot = 1, core = 2, keyheal = 3, keycons = 4, heal = 5, cons = 6, buff = 7, travel = 8, prof = 9, long = 10 }
    table.sort(plan, function(a, b)
        if a.role ~= b.role then return roleOrder[a.role] < roleOrder[b.role] end
        if a.prio ~= b.prio then return a.prio < b.prio end
        return a.name < b.name
    end)
    return plan
end

---------------------------------------------------------------- arranging
local function regionOf(regions, slot)
    for role, slots in pairs(regions) do
        for _, s in ipairs(slots) do if s == slot then return role end end
    end
end

local function allSlots(regions)
    local list = {}
    for _, role in ipairs({ "rot", "core", "keyheal", "keycons", "heal", "cons", "buff", "travel", "util" }) do
        for _, s in ipairs(regions[role] or {}) do list[#list + 1] = s end
    end
    return list
end

local changes

local function record(b, slot, e)
    b.owned[slot] = { key = e.key, kind = e.kind, id = e.id, name = e.name, mountID = e.mountID, members = e.members }
end

function S:ArrangeBars(full)
    local b = db()
    local regions = self:BarRegions()
    local slots = allSlots(regions)
    if #slots == 0 then return 0 end
    changes = 0
    busy = true

    -- The first time Steward sees a button, what's on it is saved and the button counts as free.
    -- Nothing is cleared up front: the new layout is placed over the old one, checking that the
    -- game accepts it, and only then are the old buttons nobody needs cleared.
    b.backup = b.backup or {}
    local leftovers, fresh, newly = {}, {}, {}
    for _, slot in ipairs(slots) do
        if full or not b.seen[slot] then
            local kind, id = actionAt(slot)
            if kind then
                b.backup[slot] = b.backup[slot] or { kind = kind, id = id }
                if kind == "macro" or kind == "item" then leftovers[#leftovers + 1] = { kind = kind, id = id } end
                fresh[slot] = true
            end
            b.owned[slot], b.user[slot] = nil, nil
            b.seen[slot] = true
            newly[#newly + 1] = slot
        end
    end

    -- layout 2 (keys hold heals and a potion): what Steward placed before is placed again;
    -- buttons you set yourself stay where they are
    if (b.layoutRev or 1) < 4 then
        for _, slot in ipairs(slots) do
            local rec = b.owned[slot]
            if rec and holds(slot, rec) then fresh[slot] = true b.owned[slot] = nil end
        end
        b.layoutRev = 4
    end

    -- a different spec (picked in Options, or found from new talents): the main bar is laid out again for it,
    -- in that spec's rotation order; buttons you set yourself stay where they are
    local spec = (self.CurrentSpec and self:CurrentSpec()) or nil
    if b.spec and spec and b.spec ~= spec then
        for _, r in ipairs({ "rot", "core" }) do
            for _, slot in ipairs(regions[r] or {}) do
                local rec = b.owned[slot]
                if rec and holds(slot, rec) then fresh[slot] = true b.owned[slot] = nil end
            end
        end
    end
    b.spec = spec

    -- buttons you changed by hand are yours from now on
    for _, slot in ipairs(slots) do
        if not fresh[slot] then
            local rec = b.owned[slot]
            if rec and not holds(slot, rec) then
                b.owned[slot] = nil
                if b.pushed[slot] then
                    -- the game dropped a newly learned spell here; Steward will place it properly
                    clear(slot)
                else
                    -- and whatever you took off isn't put back somewhere else
                    b.user[slot] = true
                    b.dropped[rec.key] = true
                end
            elseif not rec and b.pushed[slot] and not b.user[slot] then
                clear(slot)
            end
        end
        b.pushed[slot] = nil
    end

    local plan = self:BarPlan()
    local want = {}
    for _, e in ipairs(plan) do want[e.key] = e end

    local function free(slot)
        return not b.owned[slot] and not b.user[slot] and (fresh[slot] or not actionAt(slot))
    end
    local function firstFreeSlot(role, key)
        for _, r in ipairs(SPILL[role] or { role }) do
            local list = regions[r] or {}
            for i, slot in ipairs(list) do
                local reserved = r == "travel" and i == 1 and key ~= "mount" and #list > 1
                if not reserved and free(slot) then return slot end
            end
        end
    end

    -- place, and check the game took it; the very first refusal stops everything untouched
    local tried, refused = 0, 0
    local function place(slot, e)
        if not put(slot, e) then return false end
        tried = tried + 1
        if not sameThing(slot, e) then
            refused = refused + 1
            return false
        end
        fresh[slot] = nil
        return true
    end
    local function abort(why)
        for _, slot in ipairs(newly) do b.seen[slot] = nil end
        busy = false
        S.barsRefused = why
        S:LogError("bars", "stopped: " .. why)
        return changes
    end

    -- update or remove what Steward placed before
    local placed = {}
    for _, slot in ipairs(slots) do
        local rec = b.owned[slot]
        if rec then
            local e = want[rec.key]
            local mainNow = e and (e.role == "rot" or e.role == "core") and not placed[rec.key]
            local r = regionOf(regions, slot)
            if mainNow and r ~= "rot" and r ~= "core" then
                -- it belongs on the main bar now (a spec change made it part of the rotation): moved there below
                clear(slot)
                b.owned[slot] = nil
                changes = changes + 1
            elseif not e or placed[rec.key] then
                clear(slot)
                b.owned[slot] = nil
                changes = changes + 1
            else
                placed[rec.key] = true
                if e.kind == "group" then rec.members = e.members end
                if e.id ~= rec.id or e.kind ~= rec.kind then
                    if place(slot, e) then record(b, slot, e) changes = changes + 1 end
                end
            end
        end
    end

    -- add what's missing, unless it's already on one of your bars
    for _, e in ipairs(plan) do
        if not placed[e.key] and not e.keepOnly and not b.dropped[e.key] then
            local onBar = false
            if e.kind ~= "group" then
                for _, slot in ipairs(slots) do
                    if not fresh[slot] and sameThing(slot, e) then onBar = true break end
                end
            end
            if not onBar then
                local slot = firstFreeSlot(e.role, e.key)
                if slot then
                    if place(slot, e) then
                        record(b, slot, e)
                        placed[e.key] = true
                        changes = changes + 1
                    elseif tried <= 3 and refused == tried then
                        return abort("the game didn't accept " .. tostring(e.name) .. " on button " .. slot)
                    end
                end
            end
        end
    end

    -- the main bar stays in priority order: when a better spell arrives (Frostbolt for a frost
    -- mage), Steward's own buttons there are re-sorted so it takes key 1. Your own buttons never move.
    do
        local pos = {}
        for i, e in ipairs(plan) do pos[e.key] = i end
        local slotsOwned, entries = {}, {}
        for _, slot in ipairs(regions.rot or {}) do
            local rec = b.owned[slot]
            local e = rec and want[rec.key]
            if e and e.role == "rot" and holds(slot, rec) then
                slotsOwned[#slotsOwned + 1] = slot
                entries[#entries + 1] = e
            end
        end
        local sorted = {}
        for i, e in ipairs(entries) do sorted[i] = e end
        table.sort(sorted, function(a, c) return (pos[a.key] or 999) < (pos[c.key] or 999) end)
        for k, slot in ipairs(slotsOwned) do
            local e = sorted[k]
            if b.owned[slot].key ~= e.key and place(slot, e) then
                record(b, slot, e)
                changes = changes + 1
            end
        end
    end

    -- macros and items you had that Steward doesn't place itself go in the spare buttons
    for _, l in ipairs(leftovers) do
        local onBar = false
        for _, slot in ipairs(slots) do
            if not fresh[slot] then
                local kind, id = actionAt(slot)
                if kind == l.kind and id == l.id then onBar = true break end
            end
        end
        if not onBar then
            local slot = firstFreeSlot("spare")
            if slot and put(slot, l) then
                fresh[slot] = nil
                b.user[slot] = true
            end
        end
    end

    -- last, clear the old buttons the new layout didn't use
    for _, slot in ipairs(slots) do
        if fresh[slot] then
            clear(slot)
            changes = changes + 1
        end
    end

    if refused > 0 then S:LogError("bars", refused .. " of " .. tried .. " buttons weren't accepted") end
    busy = false
    b.version = S.version
    return changes
end

-- put your bars back the way they were before Steward
function S:RestoreBars()
    if InCombatLockdown() or GetCursorInfo and GetCursorInfo() then return false end
    local b = db()
    busy = true
    for slot in pairs(b.owned) do clear(slot) end
    for slot, old in pairs(b.backup or {}) do
        if old.kind == "spell" then
            put(slot, { kind = "spell", id = old.id })
        elseif old.kind == "item" or old.kind == "macro" then
            put(slot, { kind = old.kind, id = old.id })
        elseif old.kind == "summonmount" and C_MountJournal and C_MountJournal.GetMountInfoByID then
            local _, sid = C_MountJournal.GetMountInfoByID(old.id)
            if sid then put(slot, { kind = "spell", id = sid }) end
        elseif old.kind == "flyout" then
            local book = spellbook()
            for _, e in pairs(book) do
                if e.kind == "flyout" and e.id == old.id then put(slot, e) end
            end
        end
    end
    busy = false
    StewardCharDB.bars = { off = true, backup = b.backup }
    return true
end

-- lay everything out again from scratch (keeps the first backup)
function S:ResetBars()
    local b = db()
    b.owned, b.user, b.seen, b.dropped, b.off = {}, {}, {}, {}, nil
    b.version = nil
    if not S:Get("barsAuto") then S:Set("barsAuto", true) end
    S:QueueBars(0.1)
end

---------------------------------------------------------------- when to do it
local pending, timer = false, nil

local function canArrange()
    if not S:Get("barsAuto") or db().off or S.barsRefused then return false end
    if InCombatLockdown() then pending = true return false end
    if GetCursorInfo and GetCursorInfo() then return false end -- you're dragging something
    if _G.EditModeManagerFrame and _G.EditModeManagerFrame:IsShown() then return false end -- you're moving bars
    local AB = C_ActionBar or {}
    for _, fn in ipairs({ "HasOverrideActionBar", "HasVehicleActionBar" }) do
        local f = AB[fn] or _G[fn]
        if f then
            local ok, v = pcall(f)
            if ok and v then return false end
        end
    end
    if UnitOnTaxi and UnitOnTaxi("player") then return false end
    return true
end

local function firstTimeNote()
    local b = db()
    if b.noteShown or not S.ShowReceipt then return end
    b.noteShown = true -- once, ever
    -- above the bars, in the middle, where it can be read
    S.ShowReceipt(_G.MultiBarBottomLeft or _G.MainActionBar or _G.MainMenuBar or UIParent, {
        "Your action bars are arranged.",
        "Buttons you change by hand are yours.",
        "Undo: Options > Steward > Action bars",
    }, { "BOTTOM", "TOP", 0, 40 })
end

function S:QueueBars(delay)
    if timer then return end
    timer = true
    C_Timer.After(delay or 1, function()
        timer = nil
        if not canArrange() then
            if GetCursorInfo and GetCursorInfo() and not InCombatLockdown() then S:QueueBars(2) end
            return
        end
        pending = false
        local first = not db().version
        local ok, n = pcall(S.ArrangeBars, S)
        busy = false
        if ClearCursor then ClearCursor() end
        if not ok then S:LogError("bars", n) return end
        local okG, errG = pcall(S.UpdateGroupButtons, S)
        if not okG then S:LogError("bar groups", errG) end
        -- no notice: arranging bars is a routine chore (Nick: no pop-ups or receipts for those)
    end)
end

S:On("PLAYER_ENTERING_WORLD", function() S:QueueBars(4) end)
S:On("SPELLS_CHANGED", function() S:QueueBars(1) end)
S:On("PLAYER_LEVEL_UP", function() S:QueueBars(2) end)
S:On("BAG_UPDATE_DELAYED", function() S:QueueBars(2) end)
S:On("NEW_MOUNT_ADDED", function() S:QueueBars(1) end)
S:On("UPDATE_BONUS_ACTIONBAR", function() S:QueueBars(0.5) end)
S:On("EDIT_MODE_LAYOUTS_UPDATED", function() S:QueueBars(2) end)
S:On("PLAYER_REGEN_ENABLED", function() if pending then S:QueueBars(0.5) end end)
S:On("SPELL_PUSHED_TO_ACTIONBAR", function(_, slot)
    if type(slot) == "number" then db().pushed[slot] = true end
    S:QueueBars(1)
end)

S.BarsBusy = function() return busy end
S.ReadSpellbook = spellbook

---------------------------------------------------------------- Edit Mode layout (removed)
-- Steward briefly offered its own Edit Mode layout ("Steward"). Nick didn't like it, so it's
-- gone: on the next load the "Steward" layout is deleted and, if it was the one in use, the
-- layout you had before comes back (the game reloads once to apply it).
S:On("PLAYER_ENTERING_WORLD", function()
    if StewardCharDB.layoutRemoved then return end
    C_Timer.After(1, function()
        if StewardCharDB.layoutRemoved or InCombatLockdown() then return end
        if not (C_EditMode and C_EditMode.GetLayouts and C_EditMode.SaveLayouts and EditModePresetLayoutManager
            and Enum and Enum.EditModeLayoutType) then return end
        StewardCharDB.layoutRemoved = true
        local ok, err = pcall(function()
            local CHAR = Enum.EditModeLayoutType.Character
            local presets = EditModePresetLayoutManager:GetCopyOfPresetLayouts()
            local info = C_EditMode.GetLayouts()
            local saved = info.layouts or {}
            local idx
            for i, l in ipairs(saved) do
                if l.layoutName == "Steward" and l.layoutType == CHAR then idx = i end
            end
            if not idx then return end
            local pos = #presets + idx
            local wasActive = info.activeLayout == pos
            table.remove(saved, idx)
            local active = info.activeLayout
            if wasActive then
                active = StewardCharDB.layoutBefore
                if not active then
                    for i, p in ipairs(presets) do
                        if Enum.EditModePresetLayouts and p.layoutIndex == Enum.EditModePresetLayouts.Classic then active = i end
                    end
                end
                active = active or 1
            end
            if active > pos then active = active - 1 end
            local layouts = CopyTable(presets)
            for _, l in ipairs(saved) do layouts[#layouts + 1] = l end
            info.layouts = layouts
            info.activeLayout = active
            C_EditMode.SaveLayouts(info)
            C_EditMode.SetActiveLayout(active)
            if wasActive then
                S:Print("Steward's bar layout is gone; your previous layout is back.")
                ReloadUI()
            end
        end)
        if not ok then S:LogError("layout", err) end
    end)
end)

---------------------------------------------------------------- group buttons on screen
-- A Steward group button sits over an empty action button: click it and the spells inside pop
-- out in a row (to the left on the side bars, upward on the others); click one to cast it.
local groups = {} -- key -> { btn, pop, kids = {} }

local function frameForSlot(slot)
    local defs = { { button = "ActionButton", base = 0 } }
    for _, m in ipairs(MULTI) do defs[#defs + 1] = m end
    for _, d in ipairs(defs) do
        for i = 1, 12 do
            local b = _G[d.button .. i]
            if b and buttonSlot(b, i, d.base) == slot then return b, d end
        end
    end
end

local function spellTex(id)
    return C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(id) or 134400
end

local function dress(b)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetPoint("TOPLEFT", 2, -2)
    b.icon:SetPoint("BOTTOMRIGHT", -2, 2)
    b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    b.frame = b:CreateTexture(nil, "OVERLAY")
    b.frame:SetAllPoints()
    if b.frame.SetAtlas then pcall(b.frame.SetAtlas, b.frame, "UI-HUD-ActionBar-IconFrame") end
    b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    b:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
end

local function makeGroup(key)
    local g = { kids = {} }
    local btn = CreateFrame("Button", "StewardGroup" .. key:gsub("%W", ""), UIParent, "SecureHandlerClickTemplate")
    dress(btn)
    btn.arrow = btn:CreateTexture(nil, "OVERLAY", nil, 2)
    btn.arrow:SetSize(16, 6)
    if btn.arrow.SetAtlas then pcall(btn.arrow.SetAtlas, btn.arrow, "UI-HUD-ActionBar-Flyout") end
    btn:RegisterForClicks("AnyUp")
    local pop = CreateFrame("Frame", nil, btn, "SecureHandlerBaseTemplate")
    pop:Hide()
    btn:SetFrameRef("pop", pop)
    btn:SetAttribute("_onclick", [=[
        local p = self:GetFrameRef("pop")
        if p:IsShown() then p:Hide() else p:Show() end
    ]=])
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(self.title or "Group")
        for _, m in ipairs(self.members or {}) do GameTooltip:AddLine(m.name, 1, 1, 1) end
        GameTooltip:AddLine("Click to open.", 0.6, 0.6, 0.6)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    g.btn, g.pop = btn, pop
    return g
end

local function kid(g, i)
    local k = g.kids[i]
    if k then return k end
    k = CreateFrame("Button", nil, g.pop, "SecureActionButtonTemplate")
    dress(k)
    k:RegisterForClicks("AnyUp", "AnyDown")
    k:SetAttribute("type", "spell")
    g.pop:WrapScript(k, "OnClick", "", [=[ owner:Hide() ]=])
    k:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        if self.spellID and GameTooltip.SetSpellByID then GameTooltip:SetSpellByID(self.spellID) else GameTooltip:SetText(self.spellName or "") end
        GameTooltip:Show()
    end)
    k:SetScript("OnLeave", function() GameTooltip:Hide() end)
    g.kids[i] = k
    return k
end

function S:UpdateGroupButtons()
    if InCombatLockdown() then pending = true return end
    local b = db()
    local used = {}
    for slot, rec in pairs(b.owned or {}) do
        if rec.kind == "group" and rec.members and #rec.members > 0 then
            local target, def = frameForSlot(slot)
            if target and target.IsVisible and target:IsVisible() and not actionAt(slot) then
                used[rec.key] = true
                local g = groups[rec.key] or makeGroup(rec.key)
                groups[rec.key] = g
                local btn = g.btn
                btn.title, btn.members = rec.name, rec.members
                btn:ClearAllPoints()
                btn:SetAllPoints(target)
                btn:SetFrameStrata(target:GetFrameStrata())
                btn:SetFrameLevel((target:GetFrameLevel() or 1) + 5)
                btn.icon:SetTexture(spellTex(rec.members[1].id))
                local side = def and def.flat == false -- the side bars open to the left
                btn.arrow:ClearAllPoints()
                if side then
                    btn.arrow:SetPoint("LEFT", btn, "LEFT", -2, 0)
                    btn.arrow:SetRotation(math.pi / 2)
                else
                    btn.arrow:SetPoint("TOP", btn, "TOP", 0, 2)
                    btn.arrow:SetRotation(0)
                end
                local w, h = target:GetWidth() or 36, target:GetHeight() or 36
                for i, m in ipairs(rec.members) do
                    local k = kid(g, i)
                    k:SetSize(w, h)
                    k:ClearAllPoints()
                    if side then
                        k:SetPoint("RIGHT", btn, "LEFT", -(i - 1) * (w + 2) - 4, 0)
                    else
                        k:SetPoint("BOTTOM", btn, "TOP", 0, (i - 1) * (h + 2) + 4)
                    end
                    k:SetAttribute("spell", m.name)
                    k.spellID, k.spellName = m.id, m.name
                    k.icon:SetTexture(spellTex(m.id))
                    k:Show()
                end
                for i = #rec.members + 1, #g.kids do g.kids[i]:Hide() end
                btn:Show()
            end
        end
    end
    for key, g in pairs(groups) do
        if not used[key] then g.pop:Hide() g.btn:Hide() end
    end
end

S:On("PLAYER_ENTERING_WORLD", function() C_Timer.After(6, function() pcall(S.UpdateGroupButtons, S) end) end)
S:On("PLAYER_REGEN_ENABLED", function() pcall(S.UpdateGroupButtons, S) end)
S:On("EDIT_MODE_LAYOUTS_UPDATED", function() C_Timer.After(3, function() pcall(S.UpdateGroupButtons, S) end) end)
