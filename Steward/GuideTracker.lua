local _, S = ...

-- The guide as a real section of Blizzard's objective tracker (the same way the
-- quest, achievement and profession sections plug in). It gets the tracker's own
-- header, minimize button, check-mark and glow animations, and the tracker lays
-- the quest list out underneath it.

local G = S.G
local module
local hearthBlock -- the block that says to hearth now (set while the tracker lays the guide out)
local hearthSpell -- the trip starts with a teleport: the spell the button casts instead of the hearthstone (0.84.0)
local queueHearth -- defined with the Hearthstone button below

local function available()
    return ObjectiveTrackerManager and ObjectiveTrackerFrame and ObjectiveTrackerModuleMixin
        and ObjectiveTrackerManager.SetModuleContainer and ObjectiveTrackerAnimLineState
        and ObjectiveTrackerManager.containers and ObjectiveTrackerManager.containers[ObjectiveTrackerFrame]
end

local function guideHeader()
    local g = G.guide
    if not g then return "Guide" end
    return "Guide: " .. (g.name:gsub("%s*%(.-%)%s*$", ""))
end

local LineState = function() return ObjectiveTrackerAnimLineState end
local COMPLETE = function() return OBJECTIVE_TRACKER_COLOR and OBJECTIVE_TRACKER_COLOR["Complete"] end

-- add one objective line, running the tracker's own complete animation when it flips to done
local function addLine(block, key, text, done, firstShow)
    local St = LineState()
    local line = block:GetExistingLine(key)
    if done then
        if line and line.state == St.Faded then return end
        line = block:AddObjective(key, text, nil, nil, OBJECTIVE_DASH_STYLE_HIDE, COMPLETE())
        if line.SetState then
            if line.state == nil and firstShow then
                line:SetState(St.Completed)
            elseif not line.state or line.state == St.Present or line.state == St.Adding then
                line:SetState(St.Completing)
            end
        end
    else
        line = block:AddObjective(key, text)
        if line.SetState and line.state == St.Completed then line:SetState(St.Present) end
    end
    return line
end

-- the whole step text, wrapped over as many lines as it needs (the game's own header stops at two)
local function setFullHeader(block, text)
    if block.SetStringText and block.HeaderText then
        block.HeaderText:SetPoint("RIGHT", block.rightEdgeOffset or 0, 0)
        block.height = block:SetStringText(block.HeaderText, text, true,
            OBJECTIVE_TRACKER_COLOR and OBJECTIVE_TRACKER_COLOR["Header"], block.isHighlighted)
    else
        block:SetHeader(text)
    end
end

local function fillBlock(self, block, step, isCurrent)
    local _, objs, manual = S:StepStatus(step)
    setFullHeader(block, S:StepTitle(step) or (isCurrent and "Next step" or "Along the way"))
    block.stewardStep, block.stewardCurrent = step, isCurrent
    self.seen = self.seen or {}
    local seenKey = (G.guide and G.guide.name or "") .. step.index
    local firstShow = not self.seen[seenKey]
    for _, o in ipairs(objs or {}) do
        local text = o.text
        -- item objectives: name the creature that drops it (from the guide)
        if not o.done and text and S.HintSuffix and S:Get("objectiveHints") then
            local a = o.el.args or {}
            local q, n
            if o.el.cmd == "complete" then q, n = a[1], a[2] elseif o.el.cmd == "collect" then q, n = a[3], a[4] end
            local ok, from = pcall(S.HintSuffix, S, tonumber(q or ""), tonumber(n or ""), text)
            if ok and from then text = text .. " |cff99ccff(" .. from .. ")|r" end
        end
        addLine(block, o.el.index, text, o.done, firstShow)
    end
    if isCurrent then
        if G.activeGoto and not G.activeGoto.travel then
            local d = S:DistanceTo(G.activeGoto.go)
            if d then
                local line = block:AddObjective("dist", string.format("%d yards", d), nil, nil, OBJECTIVE_DASH_STYLE_HIDE)
                G.distLine = line
            end
        end
    end
    self.seen[seenKey] = true
    local shown = self:LayoutBlock(block)
    -- "Hearth to ..." is this step's own job (or an along-the-way "hearth when you can"):
    -- the Hearthstone button goes beside it
    if shown and not hearthBlock then
        for _, o in ipairs(objs or {}) do
            if o.el and o.el.cmd == "hs" and not o.done then hearthBlock = block break end
        end
    end
    return shown
end

local Mixin_ = {}

-- going to a group member (picked with "Travel to" on their party frame's menu, Waypoint.lua): who, how far,
-- and a click to stop
local function partyBlock(self)
    local name, lost = S:FollowName()
    if not name then return true end
    local block = self:GetBlock("party")
    block.stewardCurrent = false
    -- the trip there (Travel.lua's planner): flights, the tram, boats, your hearthstone, in order
    local legs = S.FollowTravel and S:FollowTravel()
    local zone = S.FollowZone and S:FollowZone()
    local mins = legs and legs.total and math.max(1, math.floor(legs.total / 60 + 0.5))
    if lost and not legs then
        block:SetHeader("Can't see where " .. name .. " is")
    else
        block:SetHeader("Traveling to " .. name .. (zone and (" in " .. zone) or "") .. (mins and (" (about " .. mins .. " min)") or ""))
    end
    G.followDistLine = nil
    if legs then
        for i, leg in ipairs(legs) do block:AddObjective("pl" .. i, leg.text) end
    elseif S.FollowVia and S:FollowVia() then
        block:AddObjective("pl1", "Go to the Deeprun Tram")      -- they're in the tram, and its entrance is close
    end
    if lost and not legs then
        block:AddObjective("p1", "The line comes back when " .. name .. " shows up again")
    else
        local d = S.FollowStopDistance and S:FollowStopDistance()
        if d then G.followDistLine = block:AddObjective("dist", string.format("%d yards", d), nil, nil, OBJECTIVE_DASH_STYLE_HIDE) end
    end
    block:AddObjective("p2", "Click here to stop", nil, nil, OBJECTIVE_DASH_STYLE_HIDE)
    if not self:LayoutBlock(block) then return false end
    -- the trip starts with your hearthstone or a teleport: its button goes beside this block, the same one the
    -- guide's own trips get (Nick 2026-11-22: "I hit travel to on my friend, nothing is happening": the trip to
    -- Narla started "Hearth to Darkshire", and with no line, no arrow and no button there was nothing to do)
    local first = legs and legs[1]
    if first and (first.kind == "hearth" or first.kind == "teleport") then
        hearthBlock, hearthSpell = block, first.spell
    end
    return true
end

local layout
function Mixin_:LayoutContents()
    local ok, err = pcall(layout, self)
    if not ok then S:LogError("tracker", err) end
end

function layout(self)
    G.distLine = nil
    S.trackerLaidOut = GetTime()
    S.trackerShownIndex = nil
    hearthBlock, hearthSpell = nil, nil
    queueHearth() -- the Hearthstone button follows this layout (next frame, once the blocks are placed)
    local free = S:GuideMode() == "free"
    if not (S:Get("guideShow") and (G.guide or free)) then return end
    local cur = G.current
    S.trackerShownIndex = cur and cur.index or 0
    if not partyBlock(self) then return end
    if G.travel and #G.travel > 0 then
        local block = self:GetBlock("travel")
        local mins = G.travel.total and math.max(1, math.floor(G.travel.total / 60 + 0.5))
        local title = G.travel.training and "Train new abilities" or (G.stepGoto and G.stepGoto.pin and "Travel to your map pin") or "Travel"
        block:SetHeader(title .. (mins and (" (about " .. mins .. " min)") or ""))
        block.stewardCurrent = false
        for i, leg in ipairs(G.travel) do
            block:AddObjective("leg" .. i, leg.text)
        end
        if G.activeGoto and G.activeGoto.travel then
            local d = S:DistanceTo(G.activeGoto.go)
            if d then G.distLine = block:AddObjective("dist", string.format("%d yards", d), nil, nil, OBJECTIVE_DASH_STYLE_HIDE) end
        end
        if not self:LayoutBlock(block) then return end
        -- the way starts with your hearthstone: its button goes beside this block
        if not hearthBlock and G.travel[1] and (G.travel[1].kind == "hearth" or G.travel[1].kind == "teleport") then
            hearthBlock, hearthSpell = block, G.travel[1].spell       -- a teleport: the same button, cast that spell
        end
    end
    -- the arrow is on a detour (a hand-in on the way, a nearer stop, your escort, your body):
    -- say so here too, so the arrow and the panel never disagree
    local ag = G.activeGoto
    if ag and ag.sideLabel and not ag.travel and not ag.friend then
        local block = self:GetBlock("detour")
        block:SetHeader(ag.escort and "Escort" or ag.pin and "Map pin" or "On the way")
        block.stewardCurrent = false
        block:AddObjective("d1", ag.sideLabel)
        if not self:LayoutBlock(block) then return end
    end
    if free then
        -- Free mode: your quest log, in the order the router plans
        local block = self:GetBlock("free")
        block:SetHeader("Free: your quests")
        block.stewardCurrent = false
        local lines = S.FreeLines and S:FreeLines() or {}
        if #lines == 0 then lines = { "Nothing in your quest log to do here" } end
        for i, text in ipairs(lines) do block:AddObjective("q" .. i, text) end
        if G.activeGoto and G.activeGoto.free then
            local d = S:DistanceTo(G.activeGoto.go)
            if d then G.distLine = block:AddObjective("dist", string.format("%d yards", d), nil, nil, OBJECTIVE_DASH_STYLE_HIDE) end
        end
        self:LayoutBlock(block)
        return
    end
    local fillerLines, behind
    if S.FillerLines then fillerLines, behind = S:FillerLines() end
    if fillerLines and #fillerLines > 0 then
        local block = self:GetBlock("filler")
        block:SetHeader(string.format("Instead of grinding (%d level%s to go)", behind or 1, behind == 1 and "" or "s"))
        block.stewardCurrent = false
        for i, text in ipairs(fillerLines) do block:AddObjective("f" .. i, text) end
        if not self:LayoutBlock(block) then return end
    end
    if cur then
        if not fillBlock(self, self:GetBlock(cur.index), cur, true) then return end
        -- smart routing: where the route goes after this stop
        local after = G.plan and S.PlanNext and S:PlanNext(1)
        if after and after[1] then
            local block = self:GetBlock("then")
            block:SetHeader("Then")
            block.stewardCurrent = false
            block:AddObjective("t1", S:StepTitle(after[1]))
            if not self:LayoutBlock(block) then return end
        end
    else
        local block = self:GetBlock("done")
        block:SetHeader("Guide complete")
        if not self:LayoutBlock(block) then return end
    end
    local side = {}
    for idx in pairs((StewardCharDB.guide and StewardCharDB.guide.side) or {}) do side[#side + 1] = idx end
    table.sort(side)
    local shown = 0
    for _, idx in ipairs(side) do
        if shown >= 3 then break end -- keep the tracker tidy: at most 3 "along the way" steps
        shown = shown + 1
        local step = G.guide.steps[idx]
        local _, objs = S:StepStatus(step)
        if S:StepTitle(step) or (objs and #objs > 0) then
            if not fillBlock(self, self:GetBlock(-idx), step, false) then return end
        end
    end
end

function Mixin_:OnBlockHeaderClick(block, mouseButton)
    if block.id == "party" then S:FollowMember(nil) return end
    if mouseButton == "RightButton" and block.id == "travel" and G.travel and G.travel.training then
        S:SnoozeTraining()
    elseif mouseButton == "RightButton" and block.stewardCurrent then
        S:SkipCurrentStep()
    elseif G.activeGoto and C_Map.OpenWorldMap then
        local r = S:ResolveGoto(G.activeGoto.go)
        if r then pcall(C_Map.OpenWorldMap, r.mapID) end
    end
end

function Mixin_:OnBlockHeaderEnter(block)
    if block.id == "party" then
        GameTooltip:SetOwner(block, "ANCHOR_LEFT")
        GameTooltip:SetText("Steward: your group")
        GameTooltip:AddLine("Click to stop traveling to them. The guide carries on as it was.", 1, 1, 1, true)
        GameTooltip:Show()
        return
    end
    if block.id == "travel" and G.travel and G.travel.training then
        GameTooltip:SetOwner(block, "ANCHOR_LEFT")
        GameTooltip:SetText("Steward: training")
        GameTooltip:AddLine("Right-click to skip training until your next level.", 1, 1, 1, true)
        GameTooltip:Show()
        return
    end
    if not block.stewardCurrent then return end
    GameTooltip:SetOwner(block, "ANCHOR_LEFT")
    GameTooltip:SetText("Steward guide")
    GameTooltip:AddLine("Left-click to open the map, right-click to skip this step.", 1, 1, 1, true)
    GameTooltip:Show()
end

function Mixin_:OnBlockHeaderLeave()
    GameTooltip:Hide()
end

local function attach()
    if module or not available() then return module end
    local ok, err = pcall(function()
        local mix = CreateFromMixins(ObjectiveTrackerModuleMixin, {
            headerText = "Guide",
            blockTemplate = "ObjectiveTrackerAnimBlockTemplate",
            lineTemplate = "ObjectiveTrackerAnimLineTemplate",
        }, Mixin_)
        local m = CreateFrame("Frame", "StewardGuideObjectiveTracker", UIParent, "ObjectiveTrackerModuleTemplate")
        Mixin(m, mix)
        m:OnLoad()
        m.uiOrder = 0 -- top of the tracker, above quests
        ObjectiveTrackerManager:SetModuleContainer(m, ObjectiveTrackerFrame)
        module = m
    end)
    if not ok then S.trackerError = tostring(err) end
    return module
end

---------------------------------------------------------------- the guide in place of the quest list
-- While the guide shows, WoW's own quest sections leave the tracker (the quest log itself is
-- untouched) and come back when the guide is turned off. Done out of combat only.
local QUEST_MODULES = { "CampaignQuestObjectiveTracker", "QuestObjectiveTracker" }

local function wantQuestsHidden()
    return S:Get("guideShow") and S:Get("guideReplacesQuests") and G.guide ~= nil and module ~= nil
end

function S:SyncQuestSections()
    if InCombatLockdown() or not ObjectiveTrackerFrame then return end
    local hide = wantQuestsHidden()
    local ok, err = pcall(function()
        for _, name in ipairs(QUEST_MODULES) do
            local m = _G[name]
            if type(m) == "table" and m.Hide and m.IsShown and ObjectiveTrackerFrame.HasModule then
                local present = ObjectiveTrackerFrame:HasModule(m)
                if hide and present then
                    ObjectiveTrackerFrame:RemoveModule(m)
                    m:Hide()
                elseif hide and m:IsShown() then
                    m:Hide()
                elseif not hide and not present and S.questSectionsTaken then
                    ObjectiveTrackerManager:SetModuleContainer(m, ObjectiveTrackerFrame)
                    m:MarkDirty()
                end
            end
        end
    end)
    if not ok then S:LogError("tracker", err) return end
    S.questSectionsTaken = hide or nil
end

-- The quest list carried the buttons for quest items you use ("use the vial on the corpse").
-- With it gone, the item for the quest you're working on gets one button beside the guide.
local itemBtn, itemShown
local function questIDsInStep(step, out, seen)
    if not step then return end
    for _, e in ipairs(step.elements) do
        if (e.cmd == "complete" or e.cmd == "turnin") and e.args then
            local id = math.abs(tonumber(e.args[1] or "") or 0)
            if id > 0 and not seen[id] then seen[id] = true out[#out + 1] = id end
        end
    end
end

-- The guide's own ".use <item>" line names the item to use. It stays the step's item while it is in
-- your bags, even when the quest that handed it to you has been turned in (Zephras' Flutterfly Swatter
-- comes with "What Is My Purpose?", handed in before the Flutterfly Dust it is for).
local function itemCount(id)
    local f = (C_Item and C_Item.GetItemCount) or GetItemCount
    local n = f and f(id)
    if n == nil or S.Secret(n) then return 0 end
    return n
end
local function useItemIn(step)
    if not step then return end
    for _, e in ipairs(step.elements) do
        if e.cmd == "use" and e.args and S:GateOK(e.gate) then
            local id = tonumber(e.args[1] or "")
            if id and id > 0 and itemCount(id) > 0 then
                local link = C_Item and C_Item.GetItemInfo and select(2, C_Item.GetItemInfo(id))
                if not link and GetItemInfo then link = select(2, GetItemInfo(id)) end
                local icon = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)) or (GetItemIcon and GetItemIcon(id))
                return link or ("item:" .. id), icon or 134400
            end
        end
    end
end

local function specialItemFor(questID)
    if not (GetQuestLogSpecialItemInfo and C_QuestLog and C_QuestLog.GetLogIndexForQuestID) then return end
    local idx = C_QuestLog.GetLogIndexForQuestID(questID)
    if not idx or idx == 0 then return end
    local link, icon, _, showWhenComplete = GetQuestLogSpecialItemInfo(idx)
    if not link then return end
    if C_QuestLog.IsComplete and C_QuestLog.IsComplete(questID) and not showWhenComplete then return end
    return link, icon
end

local function pickQuestItem()
    local link, icon = useItemIn(G.current)
    if link then return link, icon end
    local ids, seen = {}, {}
    questIDsInStep(G.current, ids, seen)
    for idx in pairs((StewardCharDB.guide and StewardCharDB.guide.side) or {}) do
        questIDsInStep(G.guide and G.guide.steps[idx], ids, seen)
    end
    for _, id in ipairs(ids) do
        local link, icon = specialItemFor(id)
        if link then return link, icon end
    end
    for idx in pairs((StewardCharDB.guide and StewardCharDB.guide.side) or {}) do
        local link, icon = useItemIn(G.guide and G.guide.steps[idx])
        if link then return link, icon end
    end
end

function S:UpdateQuestItemButton()
    if InCombatLockdown() then return end -- a secure button can't change in combat
    local link, icon
    if S.questSectionsTaken and module and module:IsShown() then link, icon = pickQuestItem() end
    if not link then
        if itemBtn then itemBtn:Hide() end
        itemShown = nil
        return
    end
    if not itemBtn then
        itemBtn = CreateFrame("Button", "StewardQuestItemButton", UIParent, "SecureActionButtonTemplate")
        itemBtn:SetSize(28, 28)
        itemBtn:RegisterForClicks("AnyUp", "AnyDown")
        itemBtn.icon = itemBtn:CreateTexture(nil, "ARTWORK")
        itemBtn.icon:SetAllPoints()
        itemBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        itemBtn.cd = CreateFrame("Cooldown", nil, itemBtn, "CooldownFrameTemplate")
        itemBtn.cd:SetAllPoints()
        itemBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            if self.link then GameTooltip:SetHyperlink(self.link) end
            GameTooltip:Show()
        end)
        itemBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
    if itemShown ~= link then
        itemBtn:SetAttribute("type", "item")
        itemBtn:SetAttribute("item", link)
        itemBtn.link = link
        itemBtn.icon:SetTexture(icon)
        itemShown = link
    end
    local left, top = module:GetLeft(), module:GetTop()
    if left and top then
        itemBtn:ClearAllPoints()
        itemBtn:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", left - 6, top - 22)
        itemBtn.stewardTop = top - 22
    end
    local itemID = tonumber(link:match("item:(%d+)"))
    if itemID and C_Container and C_Container.GetItemCooldown then
        local start, dur, enable = C_Container.GetItemCooldown(itemID)
        -- inside instances the game may hide these values; then the spiral stays as it was
        if not S.Secret(start, dur, enable) then
            if start and dur and dur > 0 and enable ~= 0 then itemBtn.cd:SetCooldown(start, dur) else itemBtn.cd:Clear() end
        end
    end
    itemBtn:Show()
    if queueHearth then queueHearth() end -- the Hearthstone button steps aside if they'd overlap
end

---------------------------------------------------------------- the Hearthstone button
-- When the guide says to hearth now (the Travel block's first line is your hearthstone, or the
-- current step is "Hearth to ..."), a Hearthstone button sits beside that block, left of the
-- tracker, the way the quest item button does: one click hearths. It's a secure button, so it
-- appears, moves and goes away out of combat only; after a fight it catches up.
local HEARTHSTONE = 6948
local hearthBtn, hearthQueued, hearthAt

local function hearthCount()
    local count = ((C_Item and C_Item.GetItemCount) or GetItemCount)(HEARTHSTONE)
    if S.Secret(count) then return 1 end -- can't tell: you nearly always carry one
    return count or 0
end

local function hearthCooldown()
    if not hearthBtn then return end
    if hearthBtn.stewardSpell then hearthBtn.cd:Clear() return end     -- teleports have no cooldown
    local getCD = (C_Container and C_Container.GetItemCooldown) or _G.GetItemCooldown
    if not getCD then return end
    local start, dur, enable = getCD(HEARTHSTONE)
    if S.Secret(start, dur, enable) then return end
    if start and dur and dur > 0 and enable ~= 0 then hearthBtn.cd:SetCooldown(start, dur) else hearthBtn.cd:Clear() end
end

local function makeHearthButton()
    local b = CreateFrame("Button", "StewardHearthButton", UIParent, "SecureActionButtonTemplate")
    b:SetSize(28, 28)
    b:RegisterForClicks("AnyUp", "AnyDown")
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    local icon = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(HEARTHSTONE))
        or (GetItemIcon and GetItemIcon(HEARTHSTONE)) or 134414
    b.icon:SetTexture(icon)
    b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    b.cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
    b.cd:SetAllPoints()
    b:SetAttribute("type", "item")
    b:SetAttribute("item", "item:" .. HEARTHSTONE)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        if self.stewardSpell then
            if GameTooltip.SetSpellByID then GameTooltip:SetSpellByID(self.stewardSpell) end
        elseif GameTooltip.SetItemByID then GameTooltip:SetItemByID(HEARTHSTONE) else GameTooltip:SetHyperlink("item:" .. HEARTHSTONE) end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:RegisterEvent("BAG_UPDATE_COOLDOWN")
    b:SetScript("OnEvent", hearthCooldown)
    return b
end

function S:UpdateHearthButton()
    if InCombatLockdown() then return end -- PLAYER_REGEN_ENABLED comes back here
    local block = hearthBlock
    local top = block and block.GetTop and block:GetTop()
    local left = module and module:GetLeft()
    local show = block and top and left and module:IsVisible() and (not block.IsVisible or block:IsVisible())
        and S:Get("guideShow") and (hearthSpell or hearthCount() > 0)
    if not show then
        if hearthBtn and hearthBtn:IsShown() then hearthBtn:Hide() end
        hearthAt = nil
        return
    end
    hearthBtn = hearthBtn or makeHearthButton()
    -- the hearthstone, or the teleport the trip starts with (set out of combat only, like every secure button)
    if hearthBtn.stewardSpell ~= hearthSpell then
        hearthBtn.stewardSpell = hearthSpell
        if hearthSpell then
            hearthBtn:SetAttribute("type", "spell")
            hearthBtn:SetAttribute("spell", hearthSpell)
            hearthBtn:SetAttribute("item", nil)
            local tex = (C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(hearthSpell))
                or (GetSpellTexture and GetSpellTexture(hearthSpell))
            hearthBtn.icon:SetTexture(tex or 135757)
        else
            hearthBtn:SetAttribute("type", "item")
            hearthBtn:SetAttribute("item", "item:" .. HEARTHSTONE)
            hearthBtn:SetAttribute("spell", nil)
            local icon = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(HEARTHSTONE))
                or (GetItemIcon and GetItemIcon(HEARTHSTONE)) or 134414
            hearthBtn.icon:SetTexture(icon)
        end
    end
    -- beside the block's first line, left of the tracker; left of the quest item button when both sit there
    local x = left - 6
    if itemBtn and itemBtn:IsShown() and itemBtn.stewardTop and math.abs(itemBtn.stewardTop - top) < 30 then x = x - 32 end
    local at = x .. ":" .. top
    if hearthAt ~= at then
        hearthBtn:ClearAllPoints()
        hearthBtn:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", x, top)
        hearthAt = at
    end
    hearthCooldown()
    hearthBtn:Show()
end

function queueHearth()
    if hearthQueued then return end
    hearthQueued = true
    C_Timer.After(0, function()
        hearthQueued = nil
        local ok, err = pcall(S.UpdateHearthButton, S)
        if not ok then S:LogError("tracker", err) end
    end)
end

-- the tracker moved, folded away, or the stone came or went: catch up within a second
C_Timer.NewTicker(1, function()
    if (hearthBlock or (hearthBtn and hearthBtn:IsShown())) and not InCombatLockdown() then
        local ok, err = pcall(S.UpdateHearthButton, S)
        if not ok then S:LogError("tracker", err) end
    end
end)

local regen = CreateFrame("Frame")
regen:RegisterEvent("PLAYER_REGEN_ENABLED")
regen:RegisterEvent("QUEST_LOG_UPDATE")
regen:SetScript("OnEvent", function()
    if not module then return end
    S:SyncQuestSections()
    S:UpdateQuestItemButton()
    queueHearth()
end)

local lastIndex
-- returns true when the native tracker section is handling the guide
function S:NativeTrackerRefresh()
    local m = attach()
    if not m then return false end
    S:SyncQuestSections()
    S:UpdateQuestItemButton()
    m:SetHeader(S.GuideHeader and S:GuideHeader() or guideHeader())
    local cur = G.current
    if cur and lastIndex and cur.index ~= lastIndex then
        m:SetNeedsFanfare(cur.index) -- new step glows in like a newly tracked quest
        if SOUNDKIT and SOUNDKIT.UI_QUEST_ROLLING_FORWARD_01 then PlaySound(SOUNDKIT.UI_QUEST_ROLLING_FORWARD_01) end
    end
    lastIndex = cur and cur.index
    m:MarkDirty()
    return true
end

-- Self-check: the tracker redraws on the next frame after it's flagged. If one of its
-- redraws ever fails it can stay flagged forever and never redraw again, leaving an old step
-- on screen. Every couple of seconds, if the tracker isn't showing the guide's current step,
-- flag it again; if it's stuck, clear the stuck flag (out of combat) and note what happened.
local mismatchSince
C_Timer.NewTicker(2, function()
    if not module or not (S:Get("guideShow") and G.guide) then mismatchSince = nil return end
    local want = G.current and G.current.index or 0
    if S.trackerShownIndex == want or not module:IsShown() and not ObjectiveTrackerFrame:IsShown() then
        mismatchSince = nil
        return
    end
    mismatchSince = mismatchSince or GetTime()
    if GetTime() - mismatchSince < 3 then
        module:MarkDirty()
        return
    end
    local container = module.parentContainer
    local log = StewardCharDB.trackerStuck or {}
    StewardCharDB.trackerStuck = log
    if #log < 10 then
        log[#log + 1] = {
            when = date("%H:%M:%S"), want = want, shown = S.trackerShownIndex,
            lastLayout = S.trackerLaidOut and math.floor(GetTime() - S.trackerLaidOut) or "never",
            containerDirty = container and container.dirty and true or false,
            moduleDirty = module.isDirty and true or false,
            collapsed = module.IsCollapsed and module:IsCollapsed() or false,
            containerCollapsed = container and container.IsCollapsed and container:IsCollapsed() or false,
            state = module.state, height = container and math.floor(container:GetHeight() or 0),
            combat = InCombatLockdown(),
        }
    end
    if container and container.dirty and not InCombatLockdown() then
        container.dirty = nil -- its last redraw never finished: let it redraw again
    end
    module:MarkDirty()
    mismatchSince = GetTime()
end)

-- the yards to the group member you travel to, counted on without laying the tracker out again
function S:FollowDistanceLine()
    local line = G.followDistLine
    if not (line and line.Text) then return end
    local d = S:FollowStopDistance()
    if d then line.Text:SetText(string.format("%d yards", d)) end
end

function S:NativeTrackerDistance()
    local line = G.distLine
    if module and line and G.activeGoto and line.Text then
        local d = S:DistanceTo(G.activeGoto.go)
        if d then line.Text:SetText(string.format("%d yards", d)) end
        return true
    end
    return module ~= nil
end
