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
