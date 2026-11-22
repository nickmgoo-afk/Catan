local _, S = ...

-- On-screen guide arrow: points to the current waypoint, shows distance and the step.
-- Uses the game's own navigation-arrow art. Drag to move.

local G = S.G

local f = CreateFrame("Button", "StewardArrow", UIParent)
f:SetSize(64, 64)
f:SetFrameStrata("MEDIUM")
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetClampedToScreen(true)
f:Hide()

local arrow = f:CreateTexture(nil, "ARTWORK")
arrow:SetPoint("CENTER")

-- The game's own arrows. Only the ones that exist in this client are offered.
-- rot: which way the art points, in degrees counter-clockwise from "up" (so it can be turned to face the way).
S.ARROW_STYLES = {
    { key = "navigation", label = "Quest navigation arrow", atlas = "Navigation-Tracked-Arrow", rot = 0, w = 48, h = 39 },
    { key = "worldmap", label = "World map player arrow", atlas = "UI-WorldMapArrow", rot = 0, w = 48, h = 48 },
    { key = "worldmapclassic", label = "Classic world map arrow", file = "Interface\\WorldMap\\WorldMapArrow", rot = 0, w = 40, h = 48, tc = { 0.0938, 0.9062, 0.0312, 1.0000 } },
    { key = "hudquest", label = "Minimap quest arrow (new)", atlas = "UI-HUD-Minimap-Arrow-QuestTracking", rot = 0, w = 48, h = 48 },
    { key = "hudplayer", label = "Minimap player arrow (new)", atlas = "UI-HUD-Minimap-Arrow-Player", rot = 0, w = 48, h = 48 },
    { key = "hudvignette", label = "Minimap rare arrow (new)", atlas = "UI-HUD-Minimap-Arrow-Vignettes", rot = 0, w = 48, h = 48 },
    { key = "hudcorpse", label = "Minimap corpse arrow (new)", atlas = "UI-HUD-Minimap-Arrow-Corpse", rot = 0, w = 48, h = 48 },
    { key = "hudgroup", label = "Minimap party arrow (new)", atlas = "UI-HUD-Minimap-Arrow-Group", rot = 0, w = 48, h = 39 },
    { key = "hudguard", label = "Minimap guard arrow (new)", atlas = "UI-HUD-Minimap-Arrow-Guard", rot = 0, w = 48, h = 39 },
    { key = "hudpoi", label = "Minimap distant-point arrow (new)", atlas = "UI-HUD-Minimap-Arrow-GenericDistantPOI", rot = 0, w = 48, h = 39 },
    { key = "quest", label = "Minimap quest arrow", file = "Interface\\MINIMAP\\MiniMap-QuestArrow", rot = 0, w = 42, h = 48, tc = { 0.1562, 0.8125, 0.1250, 0.8750 } },
    { key = "supertrack", label = "Minimap tracked-quest arrow", file = "Interface\\MINIMAP\\SuperTrackerArrow", rot = 0, w = 48, h = 38, tc = { 0.1875, 0.8125, 0.1562, 0.6562 } },
    { key = "guide", label = "Minimap guide arrow", file = "Interface\\MINIMAP\\ROTATING-MINIMAPGUIDEARROW", rot = 0, w = 48, h = 43, tc = { 0.2188, 0.8125, 0.1875, 0.7188 } },
    { key = "minimap", label = "Minimap player arrow", file = "Interface\\MINIMAP\\MinimapArrow", rot = 0, w = 41, h = 48, tc = { 0.1875, 0.7812, 0.1562, 0.8438 } },
    { key = "rotating", label = "Minimap edge arrow", file = "Interface\\MINIMAP\\ROTATING-MINIMAPARROW", rot = 0, w = 48, h = 43, tc = { 0.2188, 0.8125, 0.1875, 0.7188 } },
    { key = "poi", label = "Minimap point-of-interest arrow", file = "Interface\\MINIMAP\\TRACKING\\POIArrow", rot = 0, w = 48, h = 44, tc = { 0.0000, 1.0000, 0.0000, 0.9062 } },
    { key = "group", label = "Minimap party arrow", file = "Interface\\MINIMAP\\ROTATING-MINIMAPGROUPARROW", rot = 0, w = 48, h = 43, tc = { 0.2188, 0.8125, 0.1875, 0.7188 } },
    { key = "vignette", label = "Minimap rare arrow", file = "Interface\\MINIMAP\\MiniMap-VignetteArrow", rot = 0, w = 42, h = 48, tc = { 0.1562, 0.8125, 0.1250, 0.8750 } },
    { key = "corpse", label = "Minimap corpse arrow", file = "Interface\\MINIMAP\\ROTATING-MINIMAPCORPSEARROW", rot = 0, w = 48, h = 43, tc = { 0.2188, 0.8125, 0.1875, 0.7188 } },
    { key = "dead", label = "Minimap ghost arrow", file = "Interface\\MINIMAP\\MiniMap-DeadArrow", rot = 0, w = 42, h = 48, tc = { 0.1562, 0.8125, 0.1250, 0.8750 } },
    { key = "minecart", label = "Mine cart arrow", file = "Interface\\MINIMAP\\Vehicle-SilvershardMines-Arrow", rot = 0, w = 35, h = 48, tc = { 0.1250, 0.8125, 0.0000, 0.9375 } },
    { key = "floorup", label = "Minimap floor arrow", atlas = "MiniMap-PositionArrowUp", rot = 0, w = 48, h = 48 },
    { key = "npe", label = "Tutorial arrow", atlas = "NPE_ArrowUp", rot = 0, w = 48, h = 48 },
    { key = "npeglow", label = "Tutorial arrow (glowing)", atlas = "NPE_ArrowUpGlow", rot = 0, w = 48, h = 48 },
    { key = "helptip", label = "Help tip arrow", atlas = "helptip-arrow", rot = 180, w = 48, h = 21 },
    { key = "levelup", label = "Level-up arrow", atlas = "LevelUp-Icon-Arrow", rot = 0, w = 42, h = 48 },
    { key = "garrison", label = "Building upgrade arrow", atlas = "Garr_LevelUpgradeArrow", rot = 0, w = 41, h = 48 },
    { key = "bags", label = "Bag upgrade arrow", atlas = "bags-greenarrow", rot = 0, w = 44, h = 48 },
    { key = "lootblue", label = "Loot upgrade arrow (blue)", atlas = "loottoast-arrow-blue", rot = 0, w = 40, h = 48 },
    { key = "lootgreen", label = "Loot upgrade arrow (green)", atlas = "loottoast-arrow-green", rot = 0, w = 40, h = 48 },
    { key = "lootorange", label = "Loot upgrade arrow (orange)", atlas = "loottoast-arrow-orange", rot = 0, w = 40, h = 48 },
    { key = "lootpurple", label = "Loot upgrade arrow (purple)", atlas = "loottoast-arrow-purple", rot = 0, w = 40, h = 48 },
    { key = "houseup", label = "Housing upgrade arrow", atlas = "house-reward-green-arrow-up", rot = 0, w = 39, h = 48 },
    { key = "reforge", label = "Reforge arrow", file = "Interface\\Tooltips\\ReforgeGreenArrow", rot = -90, w = 48, h = 48, tc = { 0.0000, 1.0000, 0.0000, 1.0000 } },
    { key = "announce", label = "Announcement arrow", atlas = "glueannouncementpopup-arrow", rot = -90, w = 48, h = 35 },
    { key = "jump", label = "Jump-to-top arrow", file = "Interface\\Buttons\\JumpUpArrow", rot = 0, w = 32, h = 48, tc = { 0.1875, 0.8438, 0.0000, 1.0000 } },
    { key = "azerite", label = "Azerite pointer", atlas = "Azerite-PointingArrow", rot = 180, w = 48, h = 34 },
    { key = "workorder", label = "Work order arrow", atlas = "Capacitance-General-WorkOrderArrow", rot = 0, w = 48, h = 30 },
    { key = "renown", label = "Renown arrow", atlas = "CovenantSanctum-Renown-Arrow", rot = 90, w = 34, h = 48 },
    { key = "soulbind", label = "Soulbind arrow", atlas = "Soulbinds_Collection_Scrollbar_Arrow_Up", rot = 0, w = 48, h = 41 },
    { key = "soulbindred", label = "Soulbind chevron", atlas = "Soulbinds_Tree_ActivateArrow", rot = 180, w = 48, h = 29 },
    { key = "pvpnext", label = "PvP chevron", atlas = "pvpqueue-sidebar-nextarrow", rot = -90, w = 31, h = 48 },
    { key = "pvptalent", label = "PvP talent arrow", atlas = "pvptalents-selectedarrow", rot = -90, w = 47, h = 48 },
    { key = "runecarving", label = "Runecarving spear", atlas = "runecarving-icon-arrow-open", rot = -90, w = 48, h = 33 },
    { key = "shopchevron", label = "Shop chevron", atlas = "services-yellowarrow", rot = -90, w = 27, h = 48 },
    { key = "receipt", label = "Receipt arrow", atlas = "vas-receipt-brownarrow", rot = -90, w = 48, h = 24 },
    { key = "orderhall", label = "Order hall arrow", atlas = "orderhalltalents-prerequisite-arrow", rot = 90, w = 48, h = 36 },
    { key = "torghast", label = "Torghast door arrow", atlas = "TorghastDoor-ArrowUp-32x32", rot = 0, w = 48, h = 48 },
    { key = "delve", label = "Delve arrow", atlas = "UI-Journeys-Delve-Arrow-Big-Left", rot = 90, w = 30, h = 48 },
    { key = "modeselect", label = "Mode select arrow", atlas = "Mode-Selection-Arrow-Left", rot = 90, w = 30, h = 48 },
    { key = "legacy", label = "Legacy rewards arrow", atlas = "Legacy-Rewards-Tracker-Arrow-Big-Left", rot = 90, w = 30, h = 48 },
    { key = "editmode", label = "Edit mode arrow", atlas = "editmode-up-arrow", rot = 0, w = 48, h = 33 },
    { key = "scroll", label = "Scroll bar arrow", atlas = "minimal-scrollbar-arrow-top", rot = 0, w = 48, h = 31 },
    { key = "adventures", label = "Adventure map arrow", atlas = "Adventures-Scroll-Arrow-Up", rot = 0, w = 48, h = 43 },
    { key = "charselect", label = "Character select arrow", atlas = "glues-characterSelect-icon-arrowUp", rot = 0, w = 48, h = 48 },
    { key = "actionbar", label = "Action bar page arrow", atlas = "UI-HUD-ActionBar-PageUpArrow-Up", rot = 0, w = 48, h = 40 },
    { key = "mainmenubar", label = "Classic action bar arrow", atlas = "hud-MainMenuBar-arrowup-up", rot = 0, w = 48, h = 43 },
    { key = "stair", label = "Housing stair arrow", atlas = "housing-stair-arrow-up-default", rot = 0, w = 48, h = 48 },
    { key = "floor", label = "Housing floor arrow", atlas = "housing-floor-arrow-up", rot = 0, w = 48, h = 48 },
    { key = "coin", label = "Coin arrow", file = "Interface\\MONEYFRAME\\Arrow-Right-Up", rot = -90, w = 30, h = 48, tc = { 0.0000, 0.6250, 0.0000, 1.0000 } },
    { key = "scrollclassic", label = "Classic scroll arrow", file = "Interface\\Buttons\\Arrow-Up-Up", rot = 0, w = 48, h = 30, tc = { 0.0000, 1.0000, 0.3750, 1.0000 } },
    { key = "chat", label = "Chat arrow", file = "Interface\\CHATFRAME\\ChatFrameExpandArrow", rot = -90, w = 44, h = 48, tc = { 0.1250, 0.8125, 0.1250, 0.8750 } },
    { key = "raid", label = "Raid frame arrow", file = "Interface\\RAIDFRAME\\UI-RAIDFRAME-ARROW", rot = -90, w = 43, h = 48, tc = { 0.2812, 0.8125, 0.1875, 0.7812 } },
    { key = "tooltip", label = "Tooltip arrow", file = "Interface\\Transmogrify\\transmog-tooltip-arrow", rot = -90, w = 36, h = 48, tc = { 0.1250, 0.8750, 0.0000, 1.0000 } },
    { key = "calendar", label = "Calendar arrow", file = "Interface\\Calendar\\MoreArrow", rot = 180, w = 48, h = 36, tc = { 0.0000, 1.0000, 0.0000, 0.7500 } },
    { key = "login", label = "Login screen arrow", file = "Interface\\Glues\\LOGIN\\UI-BackArrow", rot = 90, w = 48, h = 39, tc = { 0.0000, 1.0000, 0.0625, 0.8750 } },
    { key = "iconup", label = "Stone arrow icon", file = "Interface\\ICONS\\misc_arrowlup", rot = 0, w = 44, h = 44, round = true },
    { key = "searing", label = "Searing Arrow icon", file = "Interface\\ICONS\\ABILITY_SEARINGARROW", rot = -45, w = 44, h = 44, round = true },
    { key = "poison", label = "Poison Arrow icon", file = "Interface\\ICONS\\Ability_PoisonArrow", rot = -45, w = 44, h = 44, round = true },
    { key = "blackarrow", label = "Black Arrow icon", file = "Interface\\ICONS\\Ability_TheBlackArrow", rot = -45, w = 44, h = 44, round = true },
    { key = "ammo1", label = "Arrow icon 1", file = "Interface\\ICONS\\INV_Ammo_Arrow_01", rot = -45, w = 44, h = 44, round = true },
    { key = "ammo2", label = "Arrow icon 2", file = "Interface\\ICONS\\INV_Ammo_Arrow_02", rot = -45, w = 44, h = 44, round = true },
    { key = "ammo3", label = "Arrow icon 3", file = "Interface\\ICONS\\INV_Ammo_Arrow_03", rot = -45, w = 44, h = 44, round = true },
    { key = "ammo4", label = "Arrow icon 4", file = "Interface\\ICONS\\INV_Ammo_Arrow_04", rot = -45, w = 44, h = 44, round = true },
    { key = "ammo5", label = "Arrow icon 5", file = "Interface\\ICONS\\INV_Ammo_Arrow_05", rot = -45, w = 44, h = 44, round = true },
    { key = "ammo6", label = "Arrow icon 6", file = "Interface\\ICONS\\INV_Ammo_Arrow_06", rot = -45, w = 44, h = 44, round = true },
    { key = "ammomisc1", label = "Arrow icon 7", file = "Interface\\ICONS\\INV_Misc_Ammo_Arrow_01", rot = -45, w = 44, h = 44, round = true },
    { key = "ammomisc2", label = "Arrow icon 8", file = "Interface\\ICONS\\INV_Misc_Ammo_Arrow_02", rot = -45, w = 44, h = 44, round = true },
    { key = "ammomisc3", label = "Arrow icon 9", file = "Interface\\ICONS\\INV_Misc_Ammo_Arrow_03", rot = -45, w = 44, h = 44, round = true },
    { key = "ammomisc4", label = "Arrow icon 10", file = "Interface\\ICONS\\INV_Misc_Ammo_Arrow_04", rot = -45, w = 44, h = 44, round = true },
    { key = "ammomisc5", label = "Arrow icon 11", file = "Interface\\ICONS\\INV_Misc_Ammo_Arrow_05", rot = -45, w = 44, h = 44, round = true },
}

local MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"

local function fileExists(path)
    if GetFileIDFromPath then return GetFileIDFromPath(path) ~= nil end
    return path:lower() == "interface\\minimap\\minimaparrow" -- the one file every client has
end

local function styleExists(st)
    if st.atlas then
        return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(st.atlas) ~= nil
    end
    if not fileExists(st.file) then return false end
    return not st.round or fileExists(MASK)
end

local available
function S:ArrowStyles(recheck)
    if available and not recheck then return available end
    local list = {}
    for _, st in ipairs(self.ARROW_STYLES) do
        local ok, yes = pcall(styleExists, st)
        if ok and yes then list[#list + 1] = st end
    end
    if #list > 0 then available = list end
    return list
end

function S:ArrowStyle(key)
    local list = self:ArrowStyles()
    for _, st in ipairs(list) do if st.key == key then return st end end
    for _, st in ipairs(list) do if st.key == "navigation" then return st end end
    return list[1] or self.ARROW_STYLES[1]
end

-- Turning arrows. The game's simple texture rotation turns the picture inside a box that
-- doesn't turn, which squashes non-square arrows and clips their tips and sides. Instead we
-- move the picture's four corners (the same way Blizzard draws angled lines), so the whole
-- picture turns: nothing cropped, nothing stretched, nothing from neighbouring art.
local UL, LL, UR, LR = UPPER_LEFT_VERTEX or 1, LOWER_LEFT_VERTEX or 2, UPPER_RIGHT_VERTEX or 3, LOWER_RIGHT_VERTEX or 4

-- put an arrow's art on a texture (owner: the frame that owns the texture, for the round mask)
function S:SetArrowArt(tex, owner, st, scale)
    scale = scale or 1
    if st.atlas then
        -- reset the picture area: otherwise the last arrow's crop is applied to this one
        tex:SetAtlas(st.atlas, false, nil, true)
    else
        tex:SetTexture(st.file)
        local tc = st.tc or (st.round and { 0.07, 0.93, 0.07, 0.93 }) or { 0, 1, 0, 1 }
        tex:SetTexCoord(tc[1], tc[2], tc[3], tc[4])
    end
    local w, h = st.w * scale, st.h * scale
    tex:SetSize(w, h)
    tex.stewardArt = { w = w, h = h, base = math.rad(st.rot or 0) }
    -- round icons: a circle the size of the icon (it doesn't turn, so it stays a circle)
    if st.round and not tex.stewardRound and owner and owner.CreateMaskTexture then
        local m = owner:CreateMaskTexture()
        if m then
            m:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            m:SetPoint("CENTER", tex, "CENTER")
            tex.stewardRound = m
        end
    end
    if tex.stewardRound then
        tex.stewardRound:SetSize(w, h)
        if st.round and not tex.stewardMasked then tex:AddMaskTexture(tex.stewardRound) tex.stewardMasked = true
        elseif not st.round and tex.stewardMasked then tex:RemoveMaskTexture(tex.stewardRound) tex.stewardMasked = false end
    end
    S.PointArrow(tex, 0)
end

-- turn an arrow to point at `angle` (radians, counter-clockwise from straight up)
function S.PointArrow(tex, angle)
    local a = tex.stewardArt
    if not a then return end
    local t = angle - a.base
    if not tex.SetVertexOffset then
        if tex.SetRotation then tex:SetRotation(t) end -- very old clients
        return
    end
    local c, s = math.cos(t), math.sin(t)
    local hw, hh = a.w / 2, a.h / 2
    -- each corner moves from where it is to where it is once turned by t (y is up)
    local function move(index, x, y)
        tex:SetVertexOffset(index, (c * x - s * y) - x, (s * x + c * y) - y)
    end
    move(UL, -hw, hh)
    move(LL, -hw, -hh)
    move(UR, hw, hh)
    move(LR, hw, -hh)
end

function S:ApplyArrowStyle()
    local st = self:ArrowStyle(self:Get("arrowStyle"))
    if st then self:SetArrowArt(arrow, f, st) end
    self.currentArrow = st
    S.PointArrow(arrow, 0)
    f:SetScale(math.max(0.5, math.min(2, (tonumber(self:Get("arrowSize")) or 100) / 100)))
end

-- back to where it starts: a little above the middle of the screen
function S:ResetArrowPosition()
    if StewardDB then StewardDB.arrowPos = nil end
    f:ClearAllPoints()
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
end

local done = f:CreateTexture(nil, "ARTWORK")
done:SetPoint("CENTER")
done:SetSize(36, 36)
done:SetAtlas("ui-questtracker-tracker-check")
done:Hide()

local dist = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
dist:SetPoint("TOP", f, "BOTTOM", 0, 2)

local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
label:SetPoint("TOP", dist, "BOTTOM", 0, -2)
label:SetWordWrap(false)

local function savePos()
    local p, _, rp, x, y = f:GetPoint(1)
    StewardDB.arrowPos = { p, rp, x, y }
end
f:SetScript("OnDragStart", function(self) if not S:Get("arrowLocked") then self:StartMoving() end end)
f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() savePos() end)
f:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("Steward arrow")
    if self.fullText and self.fullText ~= "" then GameTooltip:AddLine(self.fullText, 1, 0.82, 0, true) end
    GameTooltip:AddLine(S:Get("arrowLocked") and "Left-click to open the map. (Locked in place: Options > Steward > Guide.)"
        or "Drag to move. Left-click to open the map.", 1, 1, 1, true)
    if InCombatLockdown() then GameTooltip:AddLine(S.MAP_IN_FIGHT, 1, 0.5, 0.5, true) end
    GameTooltip:Show()
end)
f:SetScript("OnLeave", function() GameTooltip:Hide() end)
f:SetScript("OnClick", function()
    if G.activeGoto and G.activeGoto.go then
        local r = S:ResolveGoto(G.activeGoto.go)
        if r then S.OpenMapAt(r.mapID) end
    end
end)

local placed = false
local function place()
    if placed then return end
    placed = true
    S:ApplyArrowStyle()
    f:ClearAllPoints()
    local p = StewardDB and StewardDB.arrowPos
    if p then
        f:SetPoint(p[1], UIParent, p[2], p[3], p[4])
    else
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
    end
end

local elapsed = 0
f:SetScript("OnUpdate", function(_, e)
    elapsed = elapsed + e
    if elapsed < 0.05 then return end
    elapsed = 0
    local el = G.activeGoto
    if not el then return end
    if S.InInstance() then f:Hide() return end
    if el.escort then arrow:Hide() done:Hide() dist:SetText("") return end
    local r = S:ResolveGoto(el.go)
    local px, py, inst = S:PlayerWorld()
    if not (r and r.world and px) or inst ~= r.instance then
        arrow:Show() done:Hide()
        S.PointArrow(arrow, 0)
        dist:SetText("")
        return
    end
    local dx, dy = r.world.x - px, r.world.y - py
    local d = math.sqrt(dx * dx + dy * dy)
    local radius = el.go.radius or 0
    if radius > 0 and d <= radius then
        arrow:Hide() done:Show()
    else
        arrow:Show() done:Hide()
        local facing = GetPlayerFacing and GetPlayerFacing()
        if facing and not S.Secret(facing) then
            -- facing is measured from north toward west; world x = north, y = west
            local north, west = dx, dy
            if S:WorldOrder() == "unitswap" then north, west = dy, dx end
            S.PointArrow(arrow, math.atan2(west, north) - facing)
        end
    end
    dist:SetText(string.format("%d yards", d))
end)

-- A few words under the arrow: what to do next ("Turn in The Tome of Valor", "Fly to Stormwind").
-- The full step text stays in the guide; hover the arrow to read it.
local MAXLEN = 36
-- where a long sentence can be cut and still read as a whole thought (punctuation first)
local BREAKS = { " %-%- ", ": ", "; ", "%. ", "%? ", "! ", ", ", " %(",
    " if ", " with ", " through ", " for ", " while ", " until ", " then ", " on the ", " at the ", " and " }
local KEEP = { ["%? "] = "?", ["! "] = "!" }
local function shortText(t)
    if not t or t == "" then return nil end
    t = t:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("^%s*>>%s*", ""):gsub("^%.%.%.%s*", "")
    if #t <= MAXLEN then return t end
    -- the first part of a longer sentence, when it's short enough to stand on its own
    for _, sep in ipairs(BREAKS) do
        local head = t:match("^(.-)" .. sep)
        if head and #head >= 6 and #head <= MAXLEN then return head .. (KEEP[sep] or "") end
    end
    return nil
end

function S:ArrowLabel()
    if G.activeGoto and G.activeGoto.travel and G.travel and G.travel[1] then return G.travel[1].text, G.travel[1].text end
    if G.activeGoto and G.activeGoto.sideLabel then
        return shortText(G.activeGoto.sideLabel) or G.activeGoto.sideLabel, G.activeGoto.sideLabel
    end
    if G.activeGoto and G.activeGoto.filler and G.activeGoto.label then
        return shortText(G.activeGoto.label) or G.activeGoto.label, G.activeGoto.label
    end
    local step = G.current
    if not step then return "", nil end
    local full = self:StepTitle(step)
    -- the next thing to do in this step
    local _, objs = self:StepStatus(step)
    for _, o in ipairs(objs or {}) do
        if not o.done and not o.optional then
            local t = shortText(o.text)
            if t then return t, full end
        end
    end
    local t = shortText(full)
    if t then return t, full end
    for _, el in ipairs(step.elements) do
        if el.cmd == "target" and el.args[1] and self:GateOK(el.gate) then
            return "Talk to " .. el.args[1]:gsub("::.*$", ""), full
        end
    end
    return "", full
end

function S:UpdateArrow()
    local pinTrip = G.stepGoto and G.stepGoto.pin
    local show = (self:Get("guideShow") or pinTrip) and self:Get("guideArrow") and G.activeGoto ~= nil and not UnitOnTaxi("player")
        and not S.InInstance()
    if not show then f:Hide() return end
    place()
    local text, full = self:ArrowLabel()
    label:SetText(text or "")
    f.fullText = full
    f:Show()
end

S:On("PLAYER_CONTROL_LOST", function() C_Timer.After(1, function() S:UpdateArrow() end) end)
S:On("PLAYER_CONTROL_GAINED", function() S:UpdateArrow() end)

---------------------------------------------------------------- the arrow picker (Options > Steward > Arrow)
-- Every arrow as a picture: click one to use it. The big one at the top turns so you can see it in motion.
function S:BuildArrowPage(parentCategory)
    if not (Settings and Settings.RegisterCanvasLayoutSubcategory) then return nil end
    local page = CreateFrame("Frame")
    page:Hide()

    local title = page:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
    title:SetPoint("TOPLEFT", 7, -22)
    title:SetText("Arrow")
    local hint = page:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    hint:SetText("Click an arrow to use it. Turn the arrow on or off on the Guide page.")

    -- live preview
    local preview = CreateFrame("Frame", nil, page)
    preview:SetSize(84, 84)
    preview:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 4, -26)
    local ring = preview:CreateTexture(nil, "BACKGROUND")
    ring:SetAllPoints()
    ring:SetColorTexture(0, 0, 0, 0.35)
    local pTex = preview:CreateTexture(nil, "ARTWORK")
    pTex:SetPoint("CENTER")
    local pName = page:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    pName:SetPoint("LEFT", preview, "RIGHT", 16, 8)
    pName:SetJustifyH("LEFT")
    local pCount = page:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    pCount:SetPoint("TOPLEFT", pName, "BOTTOMLEFT", 0, -6)
    preview:SetScript("OnUpdate", function() S.PointArrow(pTex, -GetTime() * 0.9) end)

    local styles = self:ArrowStyles()
    local buttons = {}
    local function refresh()
        local cur = S:ArrowStyle(S:Get("arrowStyle"))
        if not cur then return end
        S:SetArrowArt(pTex, preview, cur, 1.4)
        pName:SetText(cur.label)
        pCount:SetText(#styles .. " arrows from the game to choose from")
        for _, b in ipairs(buttons) do b.sel:SetShown(b.style.key == cur.key) end
    end

    for i, st in ipairs(styles) do
        local b = CreateFrame("Button", nil, page)
        b.style = st
        local sel = b:CreateTexture(nil, "BACKGROUND", nil, -8)
        sel:SetPoint("TOPLEFT", -2, 2)
        sel:SetPoint("BOTTOMRIGHT", 2, -2)
        sel:SetColorTexture(1, 0.82, 0, 0.9)
        sel:Hide()
        b.sel = sel
        local bg = b:CreateTexture(nil, "BACKGROUND", nil, 0)
        bg:SetAllPoints()
        bg:SetColorTexture(0, 0, 0, 0.45)
        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints()
        hl:SetColorTexture(1, 1, 1, 0.12)
        b.art = b:CreateTexture(nil, "ARTWORK")
        b.art:SetPoint("CENTER")
        b:SetScript("OnClick", function()
            StewardDB.arrowStyle = st.key
            S:SettingsChanged()
            refresh()
        end)
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(st.label)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        buttons[i] = b
    end

    -- fit the grid to the panel: the biggest squares that still show every arrow without scrolling
    local function layout()
        local W = (page:GetWidth() or 0) - 20
        local H = (page:GetHeight() or 0) - 190
        if W < 100 or H < 100 then W, H = 620, 420 end
        local size, cols = 34, 1
        for s = 64, 34, -2 do
            cols = math.max(1, math.floor(W / s))
            if math.ceil(#buttons / cols) * s <= H then size = s break end
        end
        cols = math.max(1, math.floor(W / size))
        for i, b in ipairs(buttons) do
            b:ClearAllPoints()
            b:SetSize(size - 6, size - 6)
            b:SetPoint("TOPLEFT", page, "TOPLEFT", 10 + ((i - 1) % cols) * size, -178 - math.floor((i - 1) / cols) * size)
            S:SetArrowArt(b.art, b, b.style, (size - 14) / 48)
            S.PointArrow(b.art, 0)
        end
    end

    -- the settings panel's "Defaults" button and its refresh when it opens
    function page:OnDefault()
        StewardDB.arrowStyle = S.defaults.arrowStyle
        S:SettingsChanged()
        refresh()
    end
    function page:OnRefresh() refresh() end

    page:SetScript("OnShow", function()
        layout()
        refresh()
        C_Timer.After(0, layout)
    end)
    page:SetScript("OnSizeChanged", layout)

    local category = Settings.RegisterCanvasLayoutSubcategory(parentCategory, page, "Arrow")
    return category
end
