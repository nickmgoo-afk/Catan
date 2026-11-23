local _, S = ...

-- Warlock demon books (0.90.8). Nick 2026-11-23: "having Steward buy warlock pet books".
-- Wowhead's three Forever warlock leveling pages (read 2026-11-23), "Demon Abilities to Train": "Your demons learn new
-- spells from Grimoires, sold by the Demon Trainer next to the Warlock trainer. The Voidwalker and the Sayaad are the
-- two you level with." All three list Torment, Sacrifice, Consume Shadows ("Only if the Voidwalker is your main pet"),
-- Suffering, Lash of Pain and Seduction; Destruction adds the Imp's Firebolt, Blood Pact and Fire Shield ("the Imp is
-- for dungeons"). "Soothing Kiss and Lesser Invisibility are fine to skip while leveling" (not bought), nor are the
-- Felhunter's books (no page levels with it).
--
-- At the Demon Trainer Steward buys the newest rank of each of those you can use and your demon doesn't know yet,
-- quietly, like the class trainer. A demon learns a book only while it's out, so Steward notes what each demon knows
-- whenever you have it out, and buys for a demon only once it has seen it. With a book in your bags and its demon out, a
-- button beside your demon's portrait teaches it in one click.

-- item ID -> the demon, the spell, its rank, the spell the book teaches, the level it needs (Wowhead Forever)
local BOOKS = {
    [16302] = { "Imp", "Firebolt", 2, 7799, 8 }, [16316] = { "Imp", "Firebolt", 3, 7800, 18 },
    [16317] = { "Imp", "Firebolt", 4, 7801, 28 }, [16318] = { "Imp", "Firebolt", 5, 7802, 38 },
    [16319] = { "Imp", "Firebolt", 6, 11762, 48 }, [16320] = { "Imp", "Firebolt", 7, 11763, 58 },
    [16321] = { "Imp", "Blood Pact", 1, 6307, 4 }, [16322] = { "Imp", "Blood Pact", 2, 7804, 14 },
    [16323] = { "Imp", "Blood Pact", 3, 7805, 26 }, [16324] = { "Imp", "Blood Pact", 4, 11766, 38 },
    [16325] = { "Imp", "Blood Pact", 5, 11767, 50 },
    [16326] = { "Imp", "Fire Shield", 1, 2947, 14 }, [16327] = { "Imp", "Fire Shield", 2, 8316, 24 },
    [16328] = { "Imp", "Fire Shield", 3, 8317, 34 }, [16329] = { "Imp", "Fire Shield", 4, 11770, 44 },
    [16330] = { "Imp", "Fire Shield", 5, 11771, 54 },
    [16346] = { "Voidwalker", "Torment", 2, 7809, 20 }, [16347] = { "Voidwalker", "Torment", 3, 7810, 30 },
    [16348] = { "Voidwalker", "Torment", 4, 7811, 40 }, [16349] = { "Voidwalker", "Torment", 5, 11774, 50 },
    [16350] = { "Voidwalker", "Torment", 6, 11775, 60 },
    [16351] = { "Voidwalker", "Sacrifice", 1, 7812, 16 }, [16352] = { "Voidwalker", "Sacrifice", 2, 19438, 24 },
    [16353] = { "Voidwalker", "Sacrifice", 3, 19440, 32 }, [16354] = { "Voidwalker", "Sacrifice", 4, 19441, 40 },
    [16355] = { "Voidwalker", "Sacrifice", 5, 19442, 48 }, [16356] = { "Voidwalker", "Sacrifice", 6, 19443, 56 },
    [16357] = { "Voidwalker", "Consume Shadows", 1, 17767, 18 }, [16358] = { "Voidwalker", "Consume Shadows", 2, 17850, 26 },
    [16359] = { "Voidwalker", "Consume Shadows", 3, 17851, 34 }, [16360] = { "Voidwalker", "Consume Shadows", 4, 17852, 42 },
    [16361] = { "Voidwalker", "Consume Shadows", 5, 17853, 50 }, [16362] = { "Voidwalker", "Consume Shadows", 6, 17854, 58 },
    [16363] = { "Voidwalker", "Suffering", 1, 17735, 24 }, [16364] = { "Voidwalker", "Suffering", 2, 17750, 36 },
    [16365] = { "Voidwalker", "Suffering", 3, 17751, 48 }, [16366] = { "Voidwalker", "Suffering", 4, 17752, 60 },
    [16368] = { "Sayaad", "Lash of Pain", 2, 7815, 28 }, [16371] = { "Sayaad", "Lash of Pain", 3, 7816, 36 },
    [16372] = { "Sayaad", "Lash of Pain", 4, 11778, 44 }, [16373] = { "Sayaad", "Lash of Pain", 5, 11779, 52 },
    [16374] = { "Sayaad", "Lash of Pain", 6, 11780, 60 },
    [16379] = { "Sayaad", "Seduction", 1, 6358, 26 },
}
-- the spells each page wants, in the order they're bought when gold is short
local WANT = { "Torment", "Sacrifice", "Lash of Pain", "Consume Shadows", "Suffering", "Seduction" }
local WANT_DESTRUCTION = { "Torment", "Sacrifice", "Lash of Pain", "Firebolt", "Blood Pact", "Fire Shield",
    "Consume Shadows", "Suffering", "Seduction" }
-- a spell every one of these demons has from the start (rank 1): tells the demon apart if its name doesn't
local FIRST_SPELL = { Imp = 3110, Voidwalker = 3716, Sayaad = 7814 }
local FAMILY = { Imp = "Imp", Voidwalker = "Voidwalker", Succubus = "Sayaad", Incubus = "Sayaad", Sayaad = "Sayaad" }
-- which demon is your main one: time out, fading by half every hour you play
local FADE, TICK = 0.5 ^ (10 / 3600), 10

local function db()
    StewardCharDB.demonBooks = StewardCharDB.demonBooks or {}
    local d = StewardCharDB.demonBooks
    d.known = d.known or {}   -- demon -> spell -> highest rank it knows
    d.out = d.out or {}       -- demon -> fading seconds out
    d.bought = d.bought or {} -- item IDs Steward bought: never bought twice (in case the game doesn't say what a demon knows)
    return d
end

local function isWarlock()
    local _, class = UnitClass("player")
    return class == "WARLOCK"
end

local function petKnows(id)
    local SB, bank = C_SpellBook, Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Pet
    if SB and SB.IsSpellKnown and bank then
        local ok, v = pcall(SB.IsSpellKnown, id, bank)
        if ok and not S.Secret(v) then return v and true or false end
    end
    if IsSpellKnown then
        local ok, v = pcall(IsSpellKnown, id, true)
        if ok and not S.Secret(v) then return v and true or false end
    end
    return false
end

-- the demon you have out ("Imp", "Voidwalker", "Sayaad"), or nil
local function demonOut()
    local okE, out = pcall(UnitExists, "pet")
    if not okE or S.Secret(out) or not out then return nil end
    local okD, dead = pcall(UnitIsDead, "pet")
    if okD and not S.Secret(dead) and dead then return nil end
    local ok, fam = pcall(UnitCreatureFamily, "pet")
    if ok and fam and not S.Secret(fam) and FAMILY[fam] then return FAMILY[fam] end
    for demon, id in pairs(FIRST_SPELL) do
        if petKnows(id) then return demon end
    end
end

-- note what the demon that's out knows (every rank of every book of it)
local function noteDemon()
    if not (StewardCharDB and isWarlock()) then return nil end
    local demon = demonOut()
    if not demon then return nil end
    local known = db().known
    local k = known[demon] or {}
    known[demon] = k
    for _, b in pairs(BOOKS) do
        if b[1] == demon and petKnows(b[4]) and (k[b[2]] or 0) < b[3] then k[b[2]] = b[3] end
    end
    return demon
end

local function mainDemon()
    local best, most
    for demon, t in pairs(db().out) do
        if not most or t > most then best, most = demon, t end
    end
    return best
end

local function wanted(spell)
    local spec = S.CurrentSpec and S:CurrentSpec()
    for _, n in ipairs(spec == "Destruction" and WANT_DESTRUCTION or WANT) do
        if n == spell then
            -- "Only if the Voidwalker is your main pet"
            if spell == "Consume Shadows" then return (mainDemon() or demonOut()) == "Voidwalker" end
            return true
        end
    end
    return false
end

local function count(id)
    local fn = (C_Item and C_Item.GetItemCount) or _G.GetItemCount
    local n = fn and fn(id)
    if S.Secret(n) then return 0 end
    return n or 0
end

-- the highest rank of a spell's book in your bags
local function carriedRank(demon, spell)
    local best = 0
    for id, b in pairs(BOOKS) do
        if b[1] == demon and b[2] == spell and b[3] > best and count(id) > 0 then best = b[3] end
    end
    return best
end

-- the highest rank of a spell's book Steward has bought before
local function boughtRank(demon, spell)
    local best = 0
    for id in pairs(db().bought) do
        local b = BOOKS[id]
        if b and b[1] == demon and b[2] == spell and b[3] > best then best = b[3] end
    end
    return best
end

-- At a merchant (Vendor.lua): buy the books wanted. Spends what you have, like the class trainer.
function S.BuyDemonBooks()
    if not (isWarlock() and S:Get("demonBooks")) then return 0 end
    if not (GetMerchantNumItems and GetMerchantItemID and BuyMerchantItem) then return 0 end
    noteDemon()
    local known, level = db().known, UnitLevel("player") or 1
    local best = {} -- spell -> the highest rank on sale you can use
    for i = 1, GetMerchantNumItems() or 0 do
        local id = GetMerchantItemID(i)
        local b = id and BOOKS[id]
        if b and known[b[1]] and b[5] <= level then
            local name, price, _, avail, _, extended = S.MerchantItem(i)
            local have = math.max(known[b[1]][b[2]] or 0, carriedRank(b[1], b[2]), boughtRank(b[1], b[2]))
            if name and not extended and avail ~= 0 and b[3] > have and wanted(b[2])
                and (not best[b[2]] or b[3] > best[b[2]].rank) then
                best[b[2]] = { index = i, rank = b[3], price = price or 0, name = name }
            end
        end
    end
    local spec = S.CurrentSpec and S:CurrentSpec()
    local money, spent, n = GetMoney() or 0, 0, 0
    for _, spell in ipairs(spec == "Destruction" and WANT_DESTRUCTION or WANT) do
        local b = best[spell]
        if b and spent + b.price <= money then
            BuyMerchantItem(b.index, 1)
            db().bought[GetMerchantItemID(b.index)] = true
            spent, n = spent + b.price, n + 1
        end
    end
    if n > 0 and C_Timer then C_Timer.After(1, function() if S.UpdateDemonBookButton then S:UpdateDemonBookButton() end end) end
    return n, spent
end

---------------------------------------------------------------- the teach button
local btn, shownID

-- a book in your bags that the demon out doesn't know yet
local function bookToUse()
    local demon = noteDemon()
    if not demon then return nil end
    local k = db().known[demon] or {}
    local pick
    for id, b in pairs(BOOKS) do
        if b[1] == demon and b[3] > (k[b[2]] or 0) and b[5] <= (UnitLevel("player") or 1) and count(id) > 0 then
            -- the lowest rank first, then the next one, as the bags hold them
            if not pick or b[2] < BOOKS[pick][2] or (b[2] == BOOKS[pick][2] and b[3] < BOOKS[pick][3]) then pick = id end
        end
    end
    return pick, demon
end

local function makeButton()
    local b = CreateFrame("Button", "StewardDemonBookButton", UIParent, "SecureActionButtonTemplate")
    b:SetSize(28, 28)
    b:RegisterForClicks("AnyUp", "AnyDown")
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    b.text:SetPoint("LEFT", b, "RIGHT", 4, 0)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.itemID then
            if GameTooltip.SetItemByID then GameTooltip:SetItemByID(self.itemID) else GameTooltip:SetHyperlink("item:" .. self.itemID) end
        end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end

function S:UpdateDemonBookButton()
    if InCombatLockdown and InCombatLockdown() then return end -- a secure button changes out of combat only
    local id, demon
    if isWarlock() and S:Get("demonBooks") then id, demon = bookToUse() end
    if not id then
        if btn and btn:IsShown() then btn:Hide() end
        shownID = nil
        return
    end
    btn = btn or makeButton()
    if shownID ~= id then
        local b = BOOKS[id]
        btn:SetAttribute("type", "item")
        btn:SetAttribute("item", "item:" .. id)
        btn.itemID = id
        local icon = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)) or (GetItemIcon and GetItemIcon(id)) or 133738
        btn.icon:SetTexture(icon)
        local rank = (b[2] == "Seduction") and "" or (" (Rank " .. b[3] .. ")")
        btn.text:SetText("Teach your " .. demon .. " " .. b[2] .. rank)
        shownID = id
    end
    -- beside your demon's portrait; under your own when that's hidden
    btn:ClearAllPoints()
    local pet, player = _G.PetFrame, _G.PlayerFrame
    if pet and pet.IsVisible and pet:IsVisible() then
        btn:SetPoint("TOPLEFT", pet, "BOTTOMLEFT", 8, -2)
    elseif player and player.IsVisible and player:IsVisible() then
        btn:SetPoint("TOPLEFT", player, "BOTTOMLEFT", 20, -24)
    else
        btn:SetPoint("CENTER", UIParent, "CENTER", 0, -180)
    end
    btn:Show()
end

local queued
local function queue()
    if queued or not C_Timer then return end
    queued = true
    C_Timer.After(0.3, function()
        queued = nil
        local ok, err = pcall(S.UpdateDemonBookButton, S)
        if not ok then S:LogError("demon books", err) end
    end)
end
S.QueueDemonBookButton = queue

for _, e in ipairs({ "UNIT_PET", "PET_BAR_UPDATE", "SPELLS_CHANGED", "BAG_UPDATE_DELAYED", "PLAYER_REGEN_ENABLED",
    "PLAYER_ENTERING_WORLD", "PLAYER_LEVEL_UP" }) do
    S:On(e, function(unit)
        if e == "UNIT_PET" and unit ~= "player" then return end
        if not isWarlock() then return end
        queue()
    end)
end

-- which demon you keep out (for "Only if the Voidwalker is your main pet")
if C_Timer and C_Timer.NewTicker then
    C_Timer.NewTicker(TICK, function()
        if not (StewardCharDB and isWarlock()) then return end
        local out = db().out
        for d, t in pairs(out) do out[d] = t * FADE end
        local demon = demonOut()
        if demon then out[demon] = (out[demon] or 0) + TICK end
    end)
end

S.DemonBooksTest = { BOOKS = BOOKS, noteDemon = noteDemon, mainDemon = mainDemon, wanted = wanted, bookToUse = bookToUse }
