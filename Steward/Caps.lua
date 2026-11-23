local _, S = ...

-- What this client can draw (for the new look, 2026-11-20). Runs once a login, quietly, out of sight, and writes the
-- answers to StewardDB.caps so they can be read from the saved file. Nothing is shown and nothing is typed.
local MEDIA = "Interface\\AddOns\\Steward\\Media\\"

local function try(fn, ...)
    local ok, a, b = pcall(fn, ...)
    if not ok then return "error: " .. tostring(a):sub(1, 120) end
    if a == nil then return "ok" end
    if b ~= nil then return tostring(a) .. " " .. tostring(b) end
    return tostring(a)
end

local function check()
    local r = {}
    local f = CreateFrame("Frame", nil, UIParent)
    f:SetSize(64, 64)
    f:SetPoint("CENTER")
    f:SetAlpha(0)
    local t = f:CreateTexture(nil, "ARTWORK")
    t:SetAllPoints()

    -- our own picture from the add-on folder
    r.ownImage = try(t.SetTexture, t, MEDIA .. "CapsTest")
    r.ownImageFile = t.GetTextureFilePath and try(t.GetTextureFilePath, t) or "no GetTextureFilePath"
    r.ownImageId = t.GetTextureFileID and try(t.GetTextureFileID, t) or "no GetTextureFileID"
    -- tilting and bending a picture
    r.SetRotation = t.SetRotation and try(t.SetRotation, t, 0.2) or "missing"
    r.SetVertexOffset = t.SetVertexOffset and try(t.SetVertexOffset, t, 1, 8, 0) or "missing"
    r.SetTexCoord8 = try(t.SetTexCoord, t, 0, 0, 0, 1, 1, 0, 1, 1)
    r.SetColorTexture = t.SetColorTexture and try(t.SetColorTexture, t, 1, 0, 0, 1) or "missing"
    -- fading colours
    r.SetGradient = t.SetGradient and "present" or "missing"
    r.SetGradientAlpha = t.SetGradientAlpha and "present" or "missing"
    r.CreateColor = type(CreateColor) == "function" and "present" or "missing"
    if t.SetGradient and type(CreateColor) == "function" then
        r.SetGradientNew = try(t.SetGradient, t, "HORIZONTAL", CreateColor(1, 0, 0, 1), CreateColor(0, 0, 0, 1))
    end
    -- cutting a picture to a shape
    r.CreateMaskTexture = f.CreateMaskTexture and "present" or "missing"
    if f.CreateMaskTexture then
        local okM, m = pcall(f.CreateMaskTexture, f)
        if okM and m then
            r.maskSetTexture = try(m.SetTexture, m, MEDIA .. "CapsTest", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            r.AddMaskTexture = t.AddMaskTexture and try(t.AddMaskTexture, t, m) or "missing"
        else
            r.maskMake = "error"
        end
    end
    r.SetClipsChildren = f.SetClipsChildren and try(f.SetClipsChildren, f, true) or "missing"
    -- lines, and text that can be tilted
    r.CreateLine = f.CreateLine and "present" or "missing"
    local fs = f:CreateFontString(nil, "OVERLAY")
    r.fontGame = try(fs.SetFont, fs, STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
    r.fontMissing = try(fs.SetFont, fs, MEDIA .. "NoSuchFont.ttf", 20, "")
    r.fontRotation = fs.SetRotation and try(fs.SetRotation, fs, 0.2) or "missing"
    r.fontShadow = fs.SetShadowOffset and "present" or "missing"
    -- animations (for a slide-in)
    local okA, ag = pcall(f.CreateAnimationGroup, f)
    r.animations = (okA and ag) and "present" or "missing"
    if okA and ag then
        local a = try(ag.CreateAnimation, ag, "Rotation")
        r.animRotation = a:find("^error") and a or "present"
    end

    f:Hide()
    StewardDB.caps = { when = date("%m-%d %H:%M"), version = tostring(S.version), client = tostring((GetBuildInfo())), r = r }
end

S:On("PLAYER_ENTERING_WORLD", function()
    if S.capsDone then return end
    S.capsDone = true
    C_Timer.After(3, function()
        local ok, err = pcall(check)
        if not ok then S:LogError("caps", err) end
    end)
end)

---------------------------------------------------------------- what this client's game calls really answer (0.88.4)
-- Forever's client answered GetTrainerServiceInfo in another order than classic (0.88.3: "Polearms | available | 135129"),
-- and Steward never trained for a week without anyone seeing why. This notes, once a session each, the raw answers of
-- the other game calls Steward reads by position, the first time they come up in ordinary play (login, a vendor, loot,
-- a quest giver, a roll, a trainer), in StewardDB.apiProbe[call] = { when, version, "1=type:value 2=type:value ..." }.
-- It only reads; nothing changes and nothing is shown (Nick 2026-11-22: "Yes", to looking for more of these).
local probed = {}
local function show(v)
    local t = type(v)
    if t == "string" then return "string:" .. v:sub(1, 40) end
    if t == "number" or t == "boolean" then return t .. ":" .. tostring(v) end
    if t == "table" then
        local keys = {}
        for k in pairs(v) do keys[#keys + 1] = tostring(k) if #keys >= 12 then break end end
        table.sort(keys)
        return "table{" .. table.concat(keys, ",") .. "}"
    end
    return t
end
local function probe(name, fn, ...)
    if probed[name] or type(fn) ~= "function" then return end
    local r = { pcall(fn, ...) }
    if not r[1] then return end
    local n = 0
    for k = 2, 13 do if r[k] ~= nil then n = k - 1 end end
    if n == 0 then return end                      -- nothing to see yet (no quest, empty slot): try again next time
    local parts = {}
    for k = 1, n do parts[#parts + 1] = k .. "=" .. show(r[k + 1]) end
    probed[name] = true
    StewardDB.apiProbe = StewardDB.apiProbe or {}
    StewardDB.apiProbe[name] = { when = date("%m-%d %H:%M"), version = tostring(S.version), table.concat(parts, " ") }
end
local function safely(f) return function(...) if StewardDB then pcall(f, ...) end end end

S:On("PLAYER_ENTERING_WORLD", safely(function()
    C_Timer.After(6, safely(function()
        local nq = GetNumQuestLogEntries and GetNumQuestLogEntries() or 0
        for i = 1, nq do
            if GetQuestLogTitle then
                local _, _, _, header = GetQuestLogTitle(i)
                if header == false or header == nil then probe("GetQuestLogTitle", GetQuestLogTitle, i) end
            end
            probe("GetQuestLogSpecialItemInfo", GetQuestLogSpecialItemInfo, i)
            if GetNumQuestLeaderBoards and (GetNumQuestLeaderBoards(i) or 0) > 0 then probe("GetQuestLogLeaderBoard", GetQuestLogLeaderBoard, 1, i) end
        end
        probe("GetTalentInfo", GetTalentInfo, 1, 1)
        probe("GetTalentTabInfo", GetTalentTabInfo, 1)
        probe("GetSkillLineInfo", GetSkillLineInfo, 1)
        probe("GetSpellTabInfo", GetSpellTabInfo, 1)
        local book = BOOKTYPE_SPELL or "spell"
        probe("GetSpellBookItemName", GetSpellBookItemName, 1, book)
        probe("GetSpellBookItemInfo", GetSpellBookItemInfo, 1, book)
        if GetNumShapeshiftForms and (GetNumShapeshiftForms() or 0) > 0 then probe("GetShapeshiftFormInfo", GetShapeshiftFormInfo, 1) end
        if GetActionInfo then
            for slot = 1, 120 do
                if HasAction and HasAction(slot) then probe("GetActionInfo", GetActionInfo, slot) break end
            end
        end
        probe("GetInstanceInfo", GetInstanceInfo)
        probe("UnitPosition", UnitPosition, "player")
        probe("GetProfessions", GetProfessions)
        probe("GetInventoryItemLink", GetInventoryItemLink, "player", 16)
        if GetInventoryItemID then
            local id = GetInventoryItemID("player", 16)
            if id then probe("GetItemInfo", (C_Item and C_Item.GetItemInfo) or GetItemInfo, id) end
            if id then probe("GetItemInfoInstant", (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant, id) end
        end
        if C_Container and C_Container.GetContainerItemInfo then
            for slot = 1, 16 do
                if C_Container.GetContainerItemInfo(0, slot) then probe("C_Container.GetContainerItemInfo", C_Container.GetContainerItemInfo, 0, slot) break end
            end
        end
        probe("C_Container.GetItemCooldown", C_Container and C_Container.GetItemCooldown, 6948)
        -- 0.89.2: the modern calls Steward reads by field name (Forever's client is built on the modern one and
        -- has dropped GetMerchantItemInfo, GetSpellTabInfo, GetQuestLogTitle and the like)
        if C_QuestLog and C_QuestLog.GetInfo then
            for i = 1, nq do
                local info = C_QuestLog.GetInfo(i)
                if info and not info.isHeader then probe("C_QuestLog.GetInfo", C_QuestLog.GetInfo, i) break end
            end
        end
        local p1 = GetProfessions and GetProfessions()
        if p1 then probe("GetProfessionInfo", GetProfessionInfo, p1) end
        local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player or 0
        probe("C_SpellBook.GetSpellBookItemInfo", C_SpellBook and C_SpellBook.GetSpellBookItemInfo, 1, bank)
        probe("C_SpellBook.GetSpellBookSkillLineInfo", C_SpellBook and C_SpellBook.GetSpellBookSkillLineInfo, 1)
    end))
end))
S:On("MERCHANT_SHOW", safely(function()
    C_Timer.After(0.5, safely(function()
        probe("GetMerchantItemInfo", GetMerchantItemInfo, 1)
        probe("GetRepairAllCost", GetRepairAllCost)
        probe("GetMerchantItemLink", GetMerchantItemLink, 1)
        probe("GetMerchantItemID", GetMerchantItemID, 1)
        if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
            probe("C_MerchantFrame.GetItemInfo", C_MerchantFrame.GetItemInfo, 1)
            -- and the values Vendor.lua reads from it (stock: -1 for no limit, as Blizzard's merchant window reads it)
            probe("C_MerchantFrame.GetItemInfo values", function(i)
                local t = C_MerchantFrame.GetItemInfo(i)
                if t then return t.name, t.price, t.stackCount, t.numAvailable, t.isUsable, t.hasExtendedCost end
            end, 1)
        end
    end))
end))
S:On("LOOT_OPENED", safely(function()
    for i = 1, (GetNumLootItems and GetNumLootItems() or 0) do
        if GetLootSlotType and GetLootSlotType(i) == (LOOT_SLOT_ITEM or 1) then probe("GetLootSlotInfo", GetLootSlotInfo, i) break end
    end
end))
S:On("START_LOOT_ROLL", safely(function(id) probe("GetLootRollItemInfo", GetLootRollItemInfo, id) end))
S:On("QUEST_DETAIL", safely(function()
    if GetNumQuestRewards and GetNumQuestRewards() > 0 then probe("GetQuestItemInfo reward", GetQuestItemInfo, "reward", 1) end
    if GetNumQuestChoices and GetNumQuestChoices() > 0 then probe("GetQuestItemInfo choice", GetQuestItemInfo, "choice", 1) end
end))
S:On("QUEST_COMPLETE", safely(function()
    if GetNumQuestChoices and GetNumQuestChoices() > 0 then probe("GetQuestItemInfo choice", GetQuestItemInfo, "choice", 1) end
    if GetNumQuestRewards and GetNumQuestRewards() > 0 then probe("GetQuestItemInfo reward", GetQuestItemInfo, "reward", 1) end
end))
S:On("QUEST_GREETING", safely(function()
    if GetNumAvailableQuests and GetNumAvailableQuests() > 0 then probe("GetAvailableQuestInfo", GetAvailableQuestInfo, 1) probe("GetAvailableTitle", GetAvailableTitle, 1) end
    if GetNumActiveQuests and GetNumActiveQuests() > 0 then probe("GetActiveTitle", GetActiveTitle, 1) end
end))
S:On("GOSSIP_SHOW", safely(function()
    if C_GossipInfo then
        probe("C_GossipInfo.GetAvailableQuests", C_GossipInfo.GetAvailableQuests)
        probe("C_GossipInfo.GetActiveQuests", C_GossipInfo.GetActiveQuests)
        probe("C_GossipInfo.GetOptions", C_GossipInfo.GetOptions)
    end
end))
S:On("TRAINER_SHOW", safely(function()
    C_Timer.After(0.5, safely(function()
        probe("GetTrainerServiceInfo", GetTrainerServiceInfo, 1)
        probe("GetTrainerServiceCost", GetTrainerServiceCost, 1)
        probe("GetTrainerServiceSkillLine", GetTrainerServiceSkillLine, 1)
    end))
end))
