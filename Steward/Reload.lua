local _, S = ...

-- A temporary Reload button while Steward is being tuned in game. Drag it to move it;
-- /steward reloadbutton turns it off (or back on). /rl reloads too.
local btn

local function place()
    btn:ClearAllPoints()
    local p = StewardDB.reloadPos
    if p then btn:SetPoint(p[1], UIParent, p[2], p[3], p[4]) else btn:SetPoint("TOP", UIParent, "TOP", 0, -6) end
end

function S:UpdateReloadButton()
    if not self:Get("reloadButton") then
        if btn then btn:Hide() end
        return
    end
    if not btn then
        btn = CreateFrame("Button", "StewardReloadButton", UIParent, "UIPanelButtonTemplate")
        btn:SetSize(72, 22)
        btn:SetText(RELOADUI or "Reload")
        btn:SetFrameStrata("HIGH")
        btn:SetMovable(true)
        btn:SetClampedToScreen(true)
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function(self) self:StartMoving() end)
        btn:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local p, _, rp, x, y = self:GetPoint(1)
            StewardDB.reloadPos = { p, rp, x, y }
        end)
        btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        btn:SetScript("OnClick", function(_, mouse)
            if mouse == "RightButton" then
                S:Set("reloadButton", false)
                S:Print("Reload button hidden. Turn it back on in Steward's settings (Esc > Options > AddOns > Steward).")
            else
                ReloadUI()
            end
        end)
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:SetText("Reload UI")
            GameTooltip:AddLine("Left-click to reload. Drag to move. Right-click to hide it.", 1, 1, 1, true)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        place()
    end
    btn:Show()
end

S:On("PLAYER_ENTERING_WORLD", function() S:UpdateReloadButton() end)

SLASH_STEWARDRL1 = "/rl"
SlashCmdList.STEWARDRL = function() ReloadUI() end
