local _, S = ...

-- The guide block in the objective tracker area: gold header, gold step title,
-- white objective lines, with the tracker's flash/fade when things complete.

local G = S.G
local WIDTH = 250

local function font(candidates)
    for _, name in ipairs(candidates) do
        if _G[name] then return _G[name] end
    end
    return GameFontNormal
end

local function atlasOK(name)
    return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(name) ~= nil
end
local CHECK
local function check()
    if CHECK == nil then
        CHECK = false
        for _, a in ipairs({ "ui-questtracker-tracker-check", "Tracker-Check", "common-icon-checkmark" }) do
            if atlasOK(a) then CHECK = "|A:" .. a .. ":14:14|a " break end
        end
    end
    return CHECK
end

local function sound(names, fallback)
    for _, n in ipairs(names) do
        if SOUNDKIT and SOUNDKIT[n] then PlaySound(SOUNDKIT[n]) return end
    end
    if fallback then pcall(PlaySound, fallback) end
end

---------------------------------------------------------------- frame
local f = CreateFrame("Frame", "StewardGuideTracker", UIParent)
f:SetSize(WIDTH, 40)
f:SetFrameStrata("LOW")
f:Hide()

local header = f:CreateFontString(nil, "OVERLAY")
header:SetFontObject(font({ "ObjectiveTrackerHeaderFont", "GameFontNormalMed2", "GameFontNormal" }))
header:SetPoint("TOPLEFT", 0, 0)
header:SetJustifyH("LEFT")

local count = f:CreateFontString(nil, "OVERLAY")
count:SetFontObject(GameFontDisableSmall)
count:SetPoint("TOPRIGHT", -22, -1)

local collapse = CreateFrame("Button", nil, f)
collapse:SetSize(16, 16)
collapse:SetPoint("TOPRIGHT", 0, 1)
collapse.text = collapse:CreateFontString(nil, "OVERLAY", "GameFontNormal")
collapse.text:SetPoint("CENTER")
collapse:SetScript("OnClick", function()
    StewardDB.guideCollapsed = not StewardDB.guideCollapsed
    S:RefreshGuideUI()
end)

local rule = f:CreateTexture(nil, "ARTWORK")
rule:SetColorTexture(0.6, 0.5, 0.2, 0.6)
rule:SetHeight(1)
rule:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -3)
rule:SetPoint("RIGHT", f, "RIGHT", 0, 0)

local body = CreateFrame("Frame", nil, f)
body:SetPoint("TOPLEFT", rule, "BOTTOMLEFT", 0, -6)
body:SetWidth(WIDTH)

local fade = body:CreateAnimationGroup()
local fadeIn = fade:CreateAnimation("Alpha")
fadeIn:SetFromAlpha(0) fadeIn:SetToAlpha(1) fadeIn:SetDuration(0.35)

-- pools of font strings
local titles, lines = {}, {}
local function getTitle(i)
    local t = titles[i]
    if not t then
        t = CreateFrame("Button", nil, body)
        t:SetWidth(WIDTH)
        t.text = t:CreateFontString(nil, "OVERLAY")
        t.text:SetFontObject(font({ "ObjectiveTrackerLineFont", "GameFontNormal" }))
        t.text:SetPoint("TOPLEFT")
        t.text:SetWidth(WIDTH)
        t.text:SetJustifyH("LEFT")
        t:RegisterForClicks("RightButtonUp", "LeftButtonUp")
        t:SetScript("OnClick", function(self, button)
            if button == "RightButton" and self.isCurrent then S:SkipCurrentStep() end
        end)
        t:SetScript("OnEnter", function(self)
            if not self.isCurrent then return end
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetText("Steward guide")
            GameTooltip:AddLine("Right-click to skip this step.", 1, 1, 1)
            GameTooltip:Show()
        end)
        t:SetScript("OnLeave", function() GameTooltip:Hide() end)
        titles[i] = t
    end
    return t
end
local function getLine(i)
    local l = lines[i]
    if not l then
        l = body:CreateFontString(nil, "OVERLAY")
        l:SetFontObject(font({ "ObjectiveTrackerLineFont", "ObjectiveFont", "GameFontHighlightSmall" }))
        l:SetWidth(WIDTH - 12)
        l:SetJustifyH("LEFT")
        local ag = l:CreateAnimationGroup()
        local a1 = ag:CreateAnimation("Alpha") a1:SetFromAlpha(1) a1:SetToAlpha(0.2) a1:SetDuration(0.15) a1:SetOrder(1)
        local a2 = ag:CreateAnimation("Alpha") a2:SetFromAlpha(0.2) a2:SetToAlpha(1) a2:SetDuration(0.35) a2:SetOrder(2)
        l.flash = ag
        lines[i] = l
    end
    return l
end

---------------------------------------------------------------- placement
-- Sits where the quest tracker starts; the tracker is moved down below it (out of combat).
local trackerAnchor
local function tracker()
    return _G.ObjectiveTrackerFrame or _G.WatchFrame or _G.QuestWatchFrame
end

local function isLeft(point) return point and point:find("LEFT") ~= nil end

local function place()
    local tr = tracker()
    f:ClearAllPoints()
    if tr then
        if trackerAnchor == nil then
            local p, rel, rp, x, y = tr:GetPoint(1)
            trackerAnchor = p and { p, rel, rp, x, y } or false
        end
        local w = tr:GetWidth()
        if w and w > 150 then
            f:SetWidth(w)
        end
        if trackerAnchor then
            local a = trackerAnchor
            f:SetPoint(a[1], a[2], a[3], a[4], a[5])
        else
            f:SetPoint("TOPRIGHT", tr, "TOPRIGHT", 0, 0)
        end
    else
        f:SetPoint("TOPRIGHT", MinimapCluster or UIParent, "BOTTOMRIGHT", -10, -10)
    end
end

local applying = false
local pendingPush = false

local function pushTracker()
    local tr = tracker()
    if not tr or not trackerAnchor then return end
    if InCombatLockdown() then pendingPush = true return end
    pendingPush = false
    local replace = S:Get("guideReplace") and f:IsShown()
    tr:SetAlpha(replace and 0 or 1)
    applying = true
    pcall(function()
        tr:ClearAllPoints()
        if f:IsShown() and not replace then
            if isLeft(trackerAnchor[1]) then
                tr:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -12)
            else
                tr:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -12)
            end
        else
            local a = trackerAnchor
            tr:SetPoint(a[1], a[2], a[3], a[4], a[5])
        end
    end)
    applying = false
end

-- Edit Mode (and the right-side frame manager) put the tracker back in its saved spot
-- whenever the layout updates. When that happens, remember the spot, move the guide
-- there, and slide the tracker back underneath it.
local hooked = false
local function hookTracker()
    local tr = tracker()
    if hooked or not tr then return end
    hooked = true
    if trackerAnchor == nil then
        local p, rel, rp, x, y = tr:GetPoint(1)
        trackerAnchor = p and { p, rel, rp, x, y } or false
    end
    hooksecurefunc(tr, "SetPoint", function(_, p, rel, rp, x, y)
        if applying or rel == f then return end
        trackerAnchor = { p, rel, rp, x, y }
        if f:IsShown() then
            C_Timer.After(0, function()
                place()
                pushTracker()
            end)
        end
    end)
end

S:On("ADDON_LOADED", function(name)
    if name == "Blizzard_ObjectiveTracker" then hookTracker() end
end)
S:On("EDIT_MODE_LAYOUTS_UPDATED", function()
    C_Timer.After(0.5, function() if f:IsShown() then place() pushTracker() end end)
end)
S:On("PLAYER_REGEN_ENABLED", function() if pendingPush then pushTracker() end end)


---------------------------------------------------------------- render
local lastDone = {}
local lastStepIndex

local function guideLabel(guide)
    return "Guide: " .. (guide.name:gsub("%s*%(.-%)%s*$", ""))
end

function S:RefreshGuideUI()
    if S.NativeTrackerRefresh and S:NativeTrackerRefresh() then
        f:Hide()
        return
    end
    hookTracker()
    if not (S:Get("guideShow") and G.guide) then
        f:Hide()
        pushTracker()
        return
    end
    place()
    f:Show()
    local guide = G.guide
    header:SetText(guideLabel(guide))
    local cur = G.current
    local shownIdx = cur and (cur.standInFor and G.frontier and G.frontier.index or cur.index)
    count:SetText(shownIdx and (shownIdx .. "/" .. #guide.steps) or "")
    collapse.text:SetText(StewardDB.guideCollapsed and "+" or "-")

    for _, t in ipairs(titles) do t:Hide() end
    for _, l in ipairs(lines) do l:Hide() end

    local y, ti, li = 0, 0, 0
    local function addTitle(text, r, g, b, isCurrent)
        ti = ti + 1
        local t = getTitle(ti)
        t.isCurrent = isCurrent
        t.text:SetText(text)
        t.text:SetTextColor(r, g, b)
        t:SetHeight(t.text:GetStringHeight())
        t:ClearAllPoints()
        t:SetPoint("TOPLEFT", body, "TOPLEFT", 0, -y)
        t:Show()
        y = y + t.text:GetStringHeight() + 3
    end
    local function addLine(text, done, flashKey)
        li = li + 1
        local l = getLine(li)
        local mark = done and (check() or "") or "- "
        l:SetText(mark .. text)
        if done then l:SetTextColor(0.6, 0.6, 0.6) else l:SetTextColor(1, 1, 1) end
        l:ClearAllPoints()
        l:SetPoint("TOPLEFT", body, "TOPLEFT", 10, -y)
        l:Show()
        if flashKey and done and lastDone[flashKey] == false then
            l.flash:Play()
            sound({ "UI_QUEST_OBJECTIVE_COMPLETE", "IG_QUEST_LOG_OPEN" })
        end
        if flashKey then lastDone[flashKey] = done end
        y = y + l:GetStringHeight() + 2
        return l
    end

    if not StewardDB.guideCollapsed then
        if cur then
            local status, objs, manual = S:StepStatus(cur)
            addTitle(S:StepTitle(cur) or "Next step", 1, 0.82, 0, true)
            for _, o in ipairs(objs or {}) do
                addLine(o.text, o.done, cur.index .. ":" .. o.el.index)
            end
            if G.activeGoto then
                local d = S:DistanceTo(G.activeGoto.go)
                G.distLine = d and addLine(string.format("%d yards", d), false) or nil
                if G.distLine then G.distLine:SetTextColor(0.6, 0.6, 0.6) end
            else
                G.distLine = nil
            end
            if manual then
                local l = addLine("Right-click the step when done", false)
                l:SetTextColor(0.6, 0.6, 0.6)
            end
        else
            addTitle("Guide complete", 1, 0.82, 0, false)
        end

        -- running alongside: #sticky / #completewith steps
        local side = {}
        for idx in pairs(StewardCharDB.guide.side or {}) do side[#side + 1] = idx end
        table.sort(side)
        for _, idx in ipairs(side) do
            local step = guide.steps[idx]
            local _, objs = S:StepStatus(step)
            local title = S:StepTitle(step)
            if title or (objs and #objs > 0) then
                y = y + 4
                addTitle(title or "Along the way", 0.85, 0.75, 0.45, false)
                for _, o in ipairs(objs or {}) do addLine(o.text, o.done, idx .. ":" .. o.el.index) end
            end
        end
    end

    -- step finished: flash the header, play the tracker's completion sound, fade the next step in
    if lastStepIndex and cur and cur.index ~= lastStepIndex then
        sound({ "UI_QUEST_ROLLING_FORWARD_01", "IG_QUEST_LIST_COMPLETE" })
        fade:Stop()
        fade:Play()
    end
    lastStepIndex = cur and cur.index

    body:SetHeight(math.max(y, 1))
    f:SetHeight(header:GetStringHeight() + 10 + y)
    pushTracker()
end

function S:RefreshDistance()
    if S.NativeTrackerDistance and S:NativeTrackerDistance() then return end
    local line = G.distLine
    if line and G.activeGoto and line:IsShown() then
        local d = S:DistanceTo(G.activeGoto.go)
        if d then line:SetText("- " .. string.format("%d yards", d)) end
    end
end
