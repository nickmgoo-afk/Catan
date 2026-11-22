local _, S = ...

local function isSoulboundTooltip(tt)
    local name = tt:GetName()
    if not name then return false end
    for i = 2, math.min(tt:NumLines(), 6) do
        local fs = _G[name .. "TextLeft" .. i]
        if fs and fs:GetText() == ITEM_SOULBOUND then return true end
    end
    return false
end

local function addLine(tt)
    do return end -- no upgrade line on tooltips (Nick turned it down)
    if tt ~= GameTooltip and tt ~= ItemRefTooltip then return end
    local _, link = tt:GetItem()
    local info = S:ReadItem(link)
    if not info or not info.equippable or not info.usable then return end
    local cmp = S:Compare(info)
    if not S:IsUpgrade(cmp) then return end

    local note
    if S:Get("gearTest") then
        note = "test mode"
    elseif not S:Get("gearAuto") then
        note = "auto-equip off"
    elseif info.bindType == 2 and not S:Get("gearBoE") and not isSoulboundTooltip(tt) then
        note = "bind on equip, left in bags"
    end
    local text = string.format("Steward: upgrade +%d%%", math.floor(cmp.pct + 0.5))
    if note then
        tt:AddLine(text .. " (" .. note .. ")", 1, 0.82, 0)
    else
        tt:AddLine(text, 0.25, 1, 0.25)
    end
end

function S:InitTooltip()
    if TooltipDataProcessor and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tt) addLine(tt) end)
    else
        GameTooltip:HookScript("OnTooltipSetItem", addLine)
        if ItemRefTooltip then ItemRefTooltip:HookScript("OnTooltipSetItem", addLine) end
    end
end
