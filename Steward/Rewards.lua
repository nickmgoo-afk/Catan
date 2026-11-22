local _, S = ...

-- Pick the best reward: biggest upgrade for your spec, otherwise (optionally) the best vendor price.
function S:ChooseReward()
    local n = GetNumQuestChoices and GetNumQuestChoices() or 0
    if n <= 1 then return nil end
    local bestUp, bestGain, bestSell, bestSellPrice = nil, 0, nil, 0
    local missing = false
    for i = 1, n do
        local link = GetQuestItemLink("choice", i)
        local info = link and self:ReadItem(link)
        if not info then
            missing = true
        else
            local _, _, count, _, isUsable = GetQuestItemInfo("choice", i)
            if info.equippable and info.usable and isUsable ~= false then
                local cmp = self:Compare(info)
                -- rank by how much better it makes you (an empty slot is always "+100%")
                if self:IsUpgrade(cmp) and cmp.delta > bestGain then bestUp, bestGain = i, cmp.delta end
            end
            local price = (info.sellPrice or 0) * (count or 1)
            if price > bestSellPrice then bestSell, bestSellPrice = i, price end
        end
    end
    if missing then return nil, true end
    if bestUp then return bestUp, false, "upgrade" end
    if self:Get("rewardsSell") and bestSell then return bestSell, false, "vendor" end
    return nil
end

local tries = 0
local function onQuestComplete()
    if not S:Get("rewardsAuto") or IsShiftKeyDown() then return end
    local choice, missing, why = S:ChooseReward()
    if missing and tries < 10 then
        tries = tries + 1
        C_Timer.After(0.2, onQuestComplete)
        return
    end
    tries = 0
    if choice and QuestFrameRewardPanel and QuestFrameRewardPanel:IsShown() then
        S:Log("rewardLog", {
            when = date("%Y-%m-%d %H:%M"), level = UnitLevel("player"), spec = S:SpecLabel(),
            quest = GetTitleText and GetTitleText(), item = GetQuestItemLink("choice", choice), why = why,
        })
        GetQuestReward(choice)
    end
end

S:On("QUEST_COMPLETE", function()
    tries = 0
    C_Timer.After(0.1, onQuestComplete)
end)
