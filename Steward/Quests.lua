local _, S = ...

-- Quests: takes the quests your guide uses and hands in the ones you've finished, as soon as
-- you talk to the quest giver. Hold Shift while talking to someone to do it yourself.
-- Choosing between rewards is Rewards.lua.

---------------------------------------------------------------- which quests
local guideQuests -- [questID] = true for every quest any of your guides accepts

local function buildGuideQuests()
    guideQuests = {}
    for _, g in ipairs(S.guides or {}) do
        if S:GuideOK(g) then
            for _, step in ipairs(g.steps) do
                if S:GateOK(step.gate) then
                    for _, el in ipairs(step.elements) do
                        if el.cmd == "accept" and S:GateOK(el.gate) then
                            local id = tonumber(el.args[1] or "")
                            if id then guideQuests[math.abs(id)] = true end
                        end
                    end
                end
            end
        end
    end
    return guideQuests
end

function S:IsGuideQuest(id)
    return id and (guideQuests or buildGuideQuests())[id] or false
end

local function wantQuest(id, info)
    if not id or id == 0 or not S:Get("questAccept") then return false end
    if S:IsGuideQuest(id) then return true end
    -- catching up on levels: extra quests are welcome, grey ones never
    if S.FillerAccepting and S:FillerAccepting() then
        if info and (info.isTrivial or info.repeatable or info.isIgnored) then return false end
        if info and info.frequency and info.frequency ~= 0 then return false end
        return true
    end
    if S:Get("questAcceptWhich") ~= "all" then return false end
    -- every quest: still skip grey, repeatable and ignored ones
    if info and (info.isTrivial or info.repeatable or info.isIgnored) then return false end
    if info and info.frequency and info.frequency ~= 0 then return false end
    return true
end

-- quests in your log, by title (the old-style quest greeting has no quest IDs)
local function logQuestByTitle(title)
    if not (title and C_QuestLog and C_QuestLog.GetNumQuestLogEntries) then return nil end
    for i = 1, C_QuestLog.GetNumQuestLogEntries() do
        local info = C_QuestLog.GetInfo(i)
        if info and not info.isHeader and info.title == title then return info.questID end
    end
end

---------------------------------------------------------------- loop guard
-- one try per quest per conversation, so a refused quest (log full, too low) never loops
local tried = {}
local function fresh(key)
    local t = tried[key]
    if t and GetTime() - t < 10 then return false end
    tried[key] = GetTime()
    return true
end

local function active()
    return not IsShiftKeyDown() and (S:Get("questAccept") or S:Get("questTurnin"))
end

---------------------------------------------------------------- talking to a quest giver
-- returns true when it picked a quest
local function onGossip()
    local CG = C_GossipInfo
    if not active() or not (CG and CG.GetActiveQuests) then return false end
    if S:Get("questTurnin") then
        for _, q in ipairs(CG.GetActiveQuests() or {}) do
            if q.isComplete and S.onQuest(q.questID) and fresh("in" .. q.questID) then
                CG.SelectActiveQuest(q.questID)
                return true
            end
        end
    end
    for _, q in ipairs(CG.GetAvailableQuests and CG.GetAvailableQuests() or {}) do
        if wantQuest(q.questID, q) and fresh("take" .. q.questID) then
            CG.SelectAvailableQuest(q.questID)
            return true
        end
    end
    return false
end

-- older quest givers show a plain list instead of gossip
local function onGreeting()
    if not active() then return end
    if S:Get("questTurnin") and GetNumActiveQuests then
        for i = 1, GetNumActiveQuests() do
            local title, isComplete = GetActiveTitle(i)
            local id = isComplete and logQuestByTitle(title)
            if id and fresh("in" .. id) then
                SelectActiveQuest(i)
                return
            end
        end
    end
    if GetNumAvailableQuests and GetAvailableQuestInfo then
        for i = 1, GetNumAvailableQuests() do
            local isTrivial, frequency, isRepeatable, _, questID = GetAvailableQuestInfo(i)
            local info = { isTrivial = isTrivial, frequency = frequency, repeatable = isRepeatable }
            if wantQuest(questID, info) and fresh("take" .. questID) then
                SelectAvailableQuest(i)
                return
            end
        end
    end
end

local function onDetail(questStartItemID)
    if IsShiftKeyDown() or not S:Get("questAccept") then return end
    if questStartItemID and questStartItemID ~= 0 then return end -- the game shows its own pop-up for these
    local id = GetQuestID and GetQuestID()
    if QuestGetAutoAccept and QuestGetAutoAccept() then
        -- already in your log: just close the window, like clicking OK
        if S:IsGuideQuest(id) and AcknowledgeAutoAcceptQuest then AcknowledgeAutoAcceptQuest() end
        return
    end
    if QuestFlagsPVP and QuestFlagsPVP() then return end -- would flag you for PvP: your call
    if wantQuest(id) then
        if S.QuestLogFull and S:QuestLogFull() then
            -- the game would refuse it: say so once, next to the quest window
            if S.ShowReceipt and _G.QuestFrame then
                local lines = { "Your quest log is full." }
                local drop = S.QuestsSafeToDrop and S:QuestsSafeToDrop() or {}
                if #drop > 0 then
                    lines[#lines + 1] = "Safe to drop (the guide doesn't use them):"
                    for i, d in ipairs(drop) do
                        if i > 3 then break end
                        lines[#lines + 1] = "  " .. d
                    end
                else
                    lines[#lines + 1] = "Drop a quest you don't need to take this one."
                end
                S.ShowReceipt(_G.QuestFrame, lines)
            end
            return
        end
        AcceptQuest()
    end
end

-- quests in your log vs the most you can hold (headers don't count)
function S:QuestLogCount()
    local CQ = C_QuestLog
    if not (CQ and CQ.GetNumQuestLogEntries and CQ.GetInfo) then return nil end
    local n = 0
    for i = 1, CQ.GetNumQuestLogEntries() or 0 do
        local info = CQ.GetInfo(i)
        if info and not info.isHeader and not info.isHidden then n = n + 1 end
    end
    local max = CQ.GetMaxNumQuestsCanAccept and CQ.GetMaxNumQuestsCanAccept()
    return n, max
end

-- quests in your log the guide never hands in, grey ones first
function S:QuestsSafeToDrop()
    local CQ, out = C_QuestLog, {}
    if not (CQ and CQ.GetNumQuestLogEntries and CQ.GetInfo) then return out end
    local grey, other = {}, {}
    for i = 1, CQ.GetNumQuestLogEntries() or 0 do
        local info = CQ.GetInfo(i)
        local id = info and not info.isHeader and info.questID
        if id and id > 0 and not S:IsGuideQuest(id) and not (CQ.IsComplete and CQ.IsComplete(id)) then
            local title = info.title or (CQ.GetTitleForQuestID and CQ.GetTitleForQuestID(id)) or ("quest " .. id)
            local trivial = CQ.IsQuestTrivial and CQ.IsQuestTrivial(id)
            table.insert(trivial and grey or other, title .. (trivial and " (grey)" or ""))
        end
    end
    for _, t in ipairs(grey) do out[#out + 1] = t end
    for _, t in ipairs(other) do out[#out + 1] = t end
    return out
end

function S:QuestLogFull()
    local ok, n, max = pcall(self.QuestLogCount, self)
    return ok and n and max and max > 0 and n >= max or false
end

local function onProgress()
    if IsShiftKeyDown() or not S:Get("questTurnin") then return end
    local id = GetQuestID and GetQuestID()
    if id and id ~= 0 and S.onQuest(id) and IsQuestCompletable() then CompleteQuest() end
end

local function onComplete()
    if IsShiftKeyDown() or not S:Get("questTurnin") then return end
    local id = GetQuestID and GetQuestID()
    if not (id and id ~= 0 and S.onQuest(id)) then return end
    local money = GetQuestMoneyToGet and GetQuestMoneyToGet() or 0
    if money > 0 then return end -- costs gold: the game asks you to confirm, so do you
    local n = GetNumQuestChoices and GetNumQuestChoices() or 0
    if n > 1 then return end -- a choice of rewards: Rewards.lua picks (or you do)
    GetQuestReward(n == 1 and 1 or 0)
end

S:On("GOSSIP_SHOW", function()
    C_Timer.After(0.05, function()
        -- quests first; then, at a flight master, "I need to fly" when the guide wants a flight
        if onGossip() then return end
        if S.GossipTaxi and S:GossipTaxi() then return end
        if S.GossipHome then S:GossipHome() end
    end)
end)
S:On("QUEST_GREETING", function() C_Timer.After(0.05, onGreeting) end)
S:On("QUEST_DETAIL", function(itemID) C_Timer.After(0.05, function() onDetail(itemID) end) end)
S:On("QUEST_PROGRESS", function() C_Timer.After(0.05, onProgress) end)
S:On("QUEST_COMPLETE", function() C_Timer.After(0.05, onComplete) end)
S:On("PLAYER_LEVEL_UP", function() wipe(tried) end)
