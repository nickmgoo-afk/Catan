local _, S = ...

-- LEVEL UP posters, "as if Atlus made WoW's UI" (Nick, 11-20). One poster per race and class, built from the design
-- page's own layers (Media\\LevelUp, made by design/wow/poster/export2.py) and played on the page's own timeline:
-- every CSS animation is copied here as keyframes with the same timing curves, and each picture is drawn through the
-- same transform (translate, scale, rotate, skew about the same origin), so the game shows what the page shows.
-- Shown when you level up (after combat), and from Options > Steward > Look > Level-up poster > Preview.
local L = {}
S.LevelUp = L

local DIR = "Interface\\AddOns\\Steward\\Media\\LevelUp\\"
local ART, EXTRA = S.LevelUpArt or {}, S.LevelUpExtra or {}
local function hex(h) return { tonumber(h:sub(1, 2), 16) / 255, tonumber(h:sub(3, 4), 16) / 255, tonumber(h:sub(5, 6), 16) / 255 } end
local WHITE, INK, NAVY, GOLD2, PINK, RED = hex("fffaf0"), hex("05060f"), hex("0b1440"), hex("ffe39a"), hex("f58cba"), hex("d8283a")

---------------------------------------------------------------------------------------------------------------------
-- CSS timing: cubic-bezier, solved for x like a browser does (the y may overshoot past 1: the bounces)
local function bezier(x1, y1, x2, y2)
    local cx, cy = 3 * x1, 3 * y1
    local bx, by = 3 * (x2 - x1) - cx, 3 * (y2 - y1) - cy
    local ax, ay = 1 - cx - bx, 1 - cy - by
    local function sx(t) return ((ax * t + bx) * t + cx) * t end
    local function sy(t) return ((ay * t + by) * t + cy) * t end
    local function dx(t) return (3 * ax * t + 2 * bx) * t + cx end
    return function(x)
        if x <= 0 then return 0 elseif x >= 1 then return 1 end
        local t = x
        for _ = 1, 8 do
            local e = sx(t) - x
            if math.abs(e) < 1e-6 then return sy(t) end
            local d = dx(t)
            if math.abs(d) < 1e-6 then break end
            t = t - e / d
        end
        local lo, hi = 0, 1
        t = x
        for _ = 1, 40 do
            local v = sx(t)
            if math.abs(v - x) < 1e-6 then break end
            if v < x then lo = t else hi = t end
            t = (lo + hi) / 2
        end
        return sy(t)
    end
end
L.bezier = bezier
local LINEAR = function(x) return x end
local EASE_OUT = bezier(0, 0, 0.58, 1)

---------------------------------------------------------------------------------------------------------------------
-- 2D transforms as { a, b, c, d, e, f }: x' = a x + c y + e, y' = b x + d y + f (y down, angles clockwise, as on the page)
local ID = { 1, 0, 0, 1, 0, 0 }
local function mul(m, n)
    return { m[1] * n[1] + m[3] * n[2], m[2] * n[1] + m[4] * n[2], m[1] * n[3] + m[3] * n[4], m[2] * n[3] + m[4] * n[4],
        m[1] * n[5] + m[3] * n[6] + m[5], m[2] * n[5] + m[4] * n[6] + m[6] }
end
local function translate(x, y) return { 1, 0, 0, 1, x, y } end
local function rotate(deg) local r = math.rad(deg); local c, s = math.cos(r), math.sin(r); return { c, s, -s, c, 0, 0 } end
local function about(m, ox, oy) return mul(translate(ox, oy), mul(m, translate(-ox, -oy))) end
L.mul, L.rotate, L.about = mul, rotate, about

local TF = { tx = 0, ty = 0, s = 1, sx = 1, sy = 1, r = 0, kx = 0 } -- the transform's parts, and what "none" means for each
local FN = {
    t = function(v) return translate(v.tx, v.ty) end,
    s = function(v) return { v.s, 0, 0, v.s, 0, 0 } end,
    sx = function(v) return { v.sx, 0, 0, 1, 0, 0 } end,
    sy = function(v) return { 1, 0, 0, v.sy, 0, 0 } end,
    r = function(v) return rotate(v.r) end,
    kx = function(v) return { 1, 0, math.tan(math.rad(v.kx)), 1, 0, 0 } end,
}

-- a keyframe animation: { at, dur, ease, keys = { { pct, { op =, col =, clip =, tx =, ty =, s =, sx =, r =, kx =, none = true } } },
-- loop, clock = "load" }. As in CSS, a keyframe that sets the transform sets all of it (parts it doesn't name are
-- "none"), a property's missing first or last keyframe is the element's own value, and the curve runs per segment.
local function compile(node)
    for _, an in ipairs(node.anims or {}) do
        an.tracks = {}
        local function track(prop, value, isTF)
            local list = {}
            for _, k in ipairs(an.keys) do
                local v = k[2]
                if isTF then
                    local has = v.none
                    for p in pairs(TF) do if v[p] ~= nil then has = true end end
                    if has then list[#list + 1] = { k[1], v[prop] == nil and TF[prop] or v[prop] } end
                elseif v[prop] ~= nil then
                    list[#list + 1] = { k[1], v[prop] }
                end
            end
            if #list == 0 then return end
            if list[1][1] > 0 then table.insert(list, 1, { 0, value }) end
            if list[#list][1] < 1 then list[#list + 1] = { 1, value } end
            an.tracks[prop] = list
        end
        local base = node.base or {}
        for p, idv in pairs(TF) do track(p, base[p] == nil and idv or base[p], true) end
        track("op", base.op == nil and 1 or base.op)
        track("col", base.col or { 1, 1, 1 })
        track("clip", base.clip == nil and 1 or base.clip)
        track("wx", base.wx or 0)
        track("dr", base.dr or 0)
        track("br", base.br or 1)
    end
end

local function lerp(a, b, u)
    if type(a) == "table" then return { a[1] + (b[1] - a[1]) * u, a[2] + (b[2] - a[2]) * u, a[3] + (b[3] - a[3]) * u } end
    return a + (b - a) * u
end

-- an animation can loop (alternate: back and forth), stop applying when it ends (nofill: CSS without "forwards"),
-- and run on the poster's clock (t, from Play), the load clock (tl: idle spins) or the exit clock (te, while closing)
local function evaluate(node, t, tl, v, te)
    local base = node.base or {}
    for p, idv in pairs(TF) do v[p] = base[p] == nil and idv or base[p] end
    v.op = base.op == nil and 1 or base.op
    v.col = base.col
    v.clip = base.clip
    v.wx = base.wx
    v.dr = base.dr
    v.br = base.br
    for _, an in ipairs(node.anims or {}) do
        local tt = an.clock == "load" and tl or (an.clock == "exit" and (te or -1e9)) or t
        if tt >= an.at and not (an.nofill and tt >= an.at + an.dur) then
            local p = (tt - an.at) / an.dur
            if an.loop then
                p = p % (an.alt and 2 or 1)
                if p > 1 then p = 2 - p end
            elseif p > 1 then p = 1 end
            for prop, list in pairs(an.tracks) do
                local i = 1
                while i < #list - 1 and p > list[i + 1][1] do i = i + 1 end
                local k0, k1 = list[i], list[i + 1]
                local span = k1[1] - k0[1]
                local u = span > 0 and (p - k0[1]) / span or 1
                v[prop] = lerp(k0[2], k1[2], (an.ease or LINEAR)(u))
            end
        end
    end
    return v
end
L.evaluate = function(node, t, tl, te) compile(node); return evaluate(node, t, tl or t, {}, te) end

local function localMatrix(node, v)
    local m = ID
    if node.tf then
        for _, f in ipairs(node.tf) do m = mul(m, FN[f](v)) end
        if node.o then m = about(m, node.o[1], node.o[2]) end
    end
    if node.static then m = mul(node.static, m) end
    return m
end

---------------------------------------------------------------------------------------------------------------------
-- the posters, as the design pages build them (design/wow/poster/paladin2.py and warrior2.py)
local function anim(at, dur, ease, keys, extra)
    local a = { at = at, dur = dur, ease = ease, keys = keys }
    for k, v in pairs(extra or {}) do a[k] = v end
    return a
end
local NONE = { none = true }

local POSTERS = {}

-- the Persona card, the same on both: it slides in, its four rows follow one by one, the power bar fills
local function card(nodes, p, rowY, valY, segBase, segFill, accent)
    nodes[#nodes + 1] = { id = "panel", base = { tx = -560 }, tf = { "t" },
        anims = { anim(1.45, 0.35, bezier(0.2, 0.9, 0.2, 1), { { 1, NONE } }) } }
    nodes[#nodes + 1] = { parent = "panel", art = p .. "_panel" }
    nodes[#nodes + 1] = { parent = "panel", text = "name", x = 50, y = rowY, size = 58, color = WHITE, spacing = 2 }
    nodes[#nodes + 1] = { parent = "panel", art = p .. "_class" }
    for i = 1, 4 do
        nodes[#nodes + 1] = { id = "row" .. i, parent = "panel", base = { op = 0, tx = -40 }, tf = { "t" },
            anims = { anim(1.55 + (i - 1) * 0.07, 0.25, EASE_OUT, { { 1, { op = 1, none = true } } }) } }
        nodes[#nodes + 1] = { parent = "row" .. i, art = p .. "_row" .. i }
        nodes[#nodes + 1] = { parent = "row" .. i, text = "v" .. i, x = 450 + (i - 1) * 6, y = valY + (i - 1) * 38, size = 30,
            color = i == 1 and accent or GOLD2, justify = "RIGHT" }
    end
    for i = 0, 10 do
        nodes[#nodes + 1] = { parent = "panel", art = p .. "_seg", static = translate(i * 34, 0), base = { col = segBase },
            anims = { anim(2.05 + i * 0.05, 0.2, EASE_OUT, { { 1, { col = segFill } } }) } }
    end
    nodes[#nodes + 1] = { parent = "panel", art = p .. (p == "pal" and "_manalabel" or "_ragelabel") }
end

-- the word slam (ARISE / PROMOTED!), the level's crash, the two stamps
local function slam(at, ox, oy)
    return { base = { op = 0 }, tf = { "s", "r" }, o = { ox, oy },
        anims = { anim(at, 0.34, bezier(0.2, 1.4, 0.4, 1), { { 0, { op = 0, s = 2.4, r = -4 } }, { 0.65, { op = 1, s = 0.96 } }, { 1, { op = 1, none = true } } }) } }
end
local function crash(at, ox, oy)
    return { base = { op = 0 }, tf = { "s" }, o = { ox, oy },
        anims = { anim(at, 0.42, bezier(0.2, 1.4, 0.35, 1), { { 0, { op = 0, s = 3 } }, { 0.6, { op = 1, s = 0.94 } }, { 1, { op = 1, none = true } } }) } }
end
-- the LEVEL UP bar: scaleX from the page's left edge, inside the 8-degree tilt
local function bar(nodes, p, at)
    nodes[#nodes + 1] = { id = "barA", static = about(rotate(-8), 300, 330) }
    nodes[#nodes + 1] = { id = "barS", parent = "barA", base = { sx = 0 }, tf = { "sx" }, o = { 0, 360 },
        anims = { anim(at, 0.22, EASE_OUT, { { 1, NONE } }) } }
    nodes[#nodes + 1] = { id = "barB", parent = "barS", static = about(rotate(8), 300, 330) }
    nodes[#nodes + 1] = { parent = "barB", art = p .. "_bar" }
end
local function flash(nodes, at, dur, from)
    nodes[#nodes + 1] = { fill = WHITE, rect = { 0, 0, 1280, 720 }, base = { op = 0 },
        anims = { anim(at, dur, EASE_OUT, { { 0, { op = from } }, { 1, { op = 0 } } }) } }
end

-- the Alliance Human Paladin: the knighting as a ceremony of Light (design/wow/poster/paladin4.py). Dawn lights the rose window
-- pane by pane; he kneels; the vow is inked line by line while the sword dubs him (in front of him, then, lifted clear, behind);
-- the Light answers: a column of light, blessings down it, a ring of runes, wings and a halo, the level glowing in the window.
-- When it closes itself, the panes go dark again in reverse and the dark returns.
local PK_RANKS = { { 60, "CHAMPION OF THE LIGHT" }, { 50, "LORD OF THE SILVER HAND" }, { 40, "KNIGHT-COMMANDER" }, { 30, "KNIGHT-PROTECTOR" },
    { 20, "KNIGHT OF THE SILVER HAND" }, { 10, "SQUIRE OF THE SILVER HAND" }, { 1, "INITIATE OF THE LIGHT" } }
-- the rank's name and its place in the ladder (the rank pictures pk_rank_1.. are made in this order by export_pal4_strokes.py)
L.PaladinRank = function(level)
    for i, r in ipairs(PK_RANKS) do if (level or 1) >= r[1] then return r[2], i end end
    return PK_RANKS[#PK_RANKS][2], #PK_RANKS
end
POSTERS["Human:PALADIN"] = function()
    local E1, E2 = bezier(0.42, 0, 1, 1), bezier(0.42, 0, 0.58, 1)   -- ease-in, ease-in-out
    local RX, RY, KCX, KY, KH = 905, 250, 826.4, 314.8, 400
    local GX, GY, WX, WY, HCX, HCY, FY = 140.9, -90.4, 860, 392, 787.7, 346.4, 690
    local P_INK, P_WHITE, P_GOLD2, P_PINK, P_MANA = hex("05060f"), hex("fffaf0"), hex("ffe39a"), hex("f58cba"), hex("4d86ff")
    local PUSH, SETTLE = bezier(0.4, 0, 0.6, 1), bezier(0.2, 0.8, 0.2, 1)
    local n = {}
    local function add(node) n[#n + 1] = node; return node end
    local function lit(at, dur, to, ease) return anim(at, dur, ease or EASE_OUT, { { 1, { op = to or 1 } } }) end
    local function plane(id, parent, a, b)
        return add({ id = id, parent = parent, tf = { "t" }, anims = {
            anim(0, 2.0, PUSH, { { 0, NONE }, { 1, { tx = a[1], ty = a[2] } } }),
            b and anim(2.0, 0.9, SETTLE, { { 0, { tx = a[1], ty = a[2] } }, { 1, b[1] == 0 and NONE or { tx = b[1], ty = b[2] } } }) or nil } })
    end
    -- a line that draws itself along its path, as the page's stroke-dashoffset does: its pieces, each shown as the line runs past
    local ST = EXTRA.pkStrokes or {}
    local function line(parent, key, at, dur, ease, whole)
        for _, p in ipairs(ST[key] or {}) do
            add({ parent = parent, art = "pk_" .. key .. "_" .. p[1], seg = p, anims = { anim(at, dur, ease, { { 0, { dr = 0 } }, { 1, { dr = 1 } } }) } })
        end
        if whole then add({ parent = parent, art = whole, whole = true, anims = { anim(at, dur, LINEAR, { { 0, { dr = 0 } }, { 1, { dr = 1 } } }) } }) end
    end
    -- the camera: a slow push in while dawn comes and the vow is sworn, easing back as the Light answers
    add({ id = "cam", tf = { "s" }, o = { 820, 420 }, anims = {
        anim(0, 2.0, PUSH, { { 0, NONE }, { 1, { s = 1.035 } } }), anim(2.0, 0.9, SETTLE, { { 0, { s = 1.035 } }, { 1, NONE } }) } })

    -- the background plane: midnight, the great numerals, the Light, the arch
    plane("pbg", "cam", { 14, 4 }, { 5, 1 })
    add({ parent = "pbg", art = "pk_bg" })
    add({ id = "numeral", parent = "pbg", base = { op = 0, tx = 60 }, tf = { "t" }, anims = {
        anim(0.5, 3, bezier(0.2, 0.6, 0.2, 1), { { 1, { op = 1, none = true } } }),
        anim(3.5, 9, E2, { { 0, { tx = 0 } }, { 1, { tx = -36 } } }, { loop = true, alt = true }) } })
    for i = 1, 7 do add({ parent = "numeral", roman = "big", rslot = i }) end
    add({ parent = "pbg", art = "pk_light", base = { clip = 0 }, anims = { anim(0.2, 1.0, bezier(0.3, 0.7, 0.2, 1), { { 1, { clip = 1 } } }) } })
    line("pbg", "tr1", 0.4, 1.2, bezier(0.4, 0, 0.2, 1), "pk_tracery")
    line("pbg", "tr2", 0.4, 1.2, bezier(0.4, 0, 0.2, 1))

    -- the window plane
    plane("pmid", "cam", { 4, 1 }, { 0, 0 })
    add({ parent = "pmid", art = "pk_roseshadow" })
    add({ id = "spin", parent = "pmid", tf = { "r" }, o = { RX, RY },
        anims = { anim(0, 140, LINEAR, { { 0, { r = 0 } }, { 1, { r = 360 } } }, { loop = true, clock = "load" }) } })
    add({ parent = "spin", art = "pk_rosedark" })
    for i, d in ipairs(EXTRA.pkPetalDelay or {}) do
        add({ parent = "spin", art = "pk_p" .. i, base = { op = 0 }, anims = { lit(d, 0.4),
            anim((1.4 - d) * 0.3, 0.2, EASE_OUT, { { 0, { op = 1 } }, { 1, { op = 0 } } }, { clock = "exit" }) } })
    end
    add({ parent = "spin", art = "pk_lead" })
    local function glow(parent, art, ox, oy)
        return add({ parent = parent, art = art, base = { op = 0 }, tf = { "s" }, o = { ox, oy }, anims = {
            anim(2.0, 0.6, EASE_OUT, { { 0, { op = 1, s = 1.25 } }, { 1, { op = 0.6, none = true } } }),
            anim(2.6, 2.4, E2, { { 0, { op = 0.6, none = true } }, { 0.5, { op = 0.85, s = 1.04 } }, { 1, { op = 0.6, none = true } } }, { loop = true }) } })
    end
    glow("spin", "pk_hubglow", RX, RY)
    add({ parent = "spin", art = "pk_sheen", base = { op = 0 }, tf = { "r" }, o = { RX, RY },
        anims = { anim(2.12, 0.8, bezier(0.4, 0, 0.2, 1), { { 0, { op = 0.6, r = -40 } }, { 0.8, { op = 0.6 } }, { 1, { op = 0, r = 320 } } }, { nofill = true }) } })
    add({ parent = "spin", art = "pk_hubink" })
    add({ parent = "pmid", art = "pk_hub" })
    for i = 1, 7 do
        add({ parent = "pmid", art = "pk_proj" .. i, base = { op = 0 }, tf = { "t" }, anims = { lit(0.7 + (i - 1) * 0.09, 0.6, 0.3),
            anim(1.6, 5, E2, { { 0, { op = 0.3, tx = 0 } }, { 1, { op = 0.3, tx = -26 } } }, { loop = true, alt = true }) } })
    end
    for i, o in ipairs({ 0.22, 0.16, 0.2 }) do
        add({ parent = "pmid", art = "pk_shaft" .. i, base = { op = 0 }, tf = { "t" }, anims = { lit(0.35 + (i - 1) * 0.18, 0.9, o),
            anim(1.4, 6, E2, { { 0, { op = o, tx = 0 } }, { 1, { op = o, tx = -38 } } }, { loop = true, alt = true }),
            anim(2.0, 0.8, EASE_OUT, { { 0, { op = 0.55 } }, { 1, { op = o } } }, { nofill = true }) } })
    end
    for _, e in ipairs(EXTRA.pkDust or {}) do
        local r = e[3] * 1.6
        add({ parent = "pmid", art = "orc_ember", rect = { e[1] - r, e[2] - r, 2 * r, 2 * r }, base = { op = 0, col = hex(e[4]) }, tf = { "t" },
            anims = { anim(e[7], e[8], LINEAR, { { 0, { op = 0, tx = 0, ty = 0 } }, { 0.2, { op = 0.9 } }, { 0.8, { op = 0.9 } }, { 1, { op = 0, tx = e[5], ty = e[6] } } }, { loop = true }) } })
    end
    -- the Stormwind banner unfurls, then stirs
    add({ parent = "pmid", art = "pk_banner", base = { sy = 0 }, tf = { "r", "kx", "sy" }, o = { 1214, 0 }, anims = {
        anim(0.45, 0.55, bezier(0.3, 1.2, 0.4, 1), { { 1, NONE } }),
        anim(1.0, 5, E2, { { 0, { r = 0 } }, { 1, { r = -1.4, kx = 1 } } }, { loop = true, alt = true }) } })
    -- the Light answers: the column, the runes, the blessings coming down it
    add({ parent = "pmid", art = "pk_column", base = { op = 0, sy = 0 }, tf = { "sy" }, o = { KCX, -40 }, anims = {
        anim(1.72, 0.3, bezier(0.5, 0, 0.7, 0.4), { { 0, { op = 1, sy = 0 } }, { 1, { op = 1, none = true } } }),
        anim(2.6, 2.4, E2, { { 0, { op = 1 } }, { 0.5, { op = 0.8 } }, { 1, { op = 1 } } }, { loop = true }) } })
    for i, at in ipairs({ 2.0, 2.1 }) do
        add({ id = "ring" .. i, parent = "pmid", base = { op = 0 }, anims = { anim(at, 0.6, SETTLE, { { 0, { op = 1 } }, { 1, { op = 1 } } }) } })
        line("ring" .. i, "rg" .. i, at, 0.6, SETTLE, "pk_ring" .. i)
    end
    for i, d in ipairs(EXTRA.pkRuneDelay or {}) do add({ parent = "pmid", art = "pk_rune" .. i, base = { op = 0 }, anims = { lit(d, 0.2) } }) end
    for j = 0, 2 do
        add({ parent = "pmid", art = "pk_blessing", base = { op = 0 }, tf = { "t", "sx", "sy" }, o = { KCX, 40 },
            anims = { anim(1.78 + j * 0.1, 0.55, PUSH, { { 0, { op = 0, ty = 0, sx = 0.5, sy = 0.5 } }, { 0.2, { op = 1 } }, { 0.85, { op = 1 } },
                { 1, { op = 0, ty = FY - 40, sx = 2.4, sy = 2.1 } } }) } })
    end
    -- wings of Light, feather by feather
    add({ id = "wings", parent = "pmid", base = { op = 0.78, s = 0.6 }, tf = { "s" }, o = { WX, WY },
        anims = { anim(2.0, 0.5, bezier(0.2, 1.1, 0.35, 1), { { 1, NONE } }) } })
    for _, w in ipairs({ { "l", 2.5, EXTRA.pkWingL }, { "r", -2.5, EXTRA.pkWingR } }) do
        local id = "wing" .. w[1]
        add({ id = id, parent = "wings", tf = { "r" }, o = { WX, WY }, anims = { anim(2.6, 3.2, E2, { { 0, { r = 0 } }, { 1, { r = w[2] } } }, { loop = true, alt = true }) } })
        for i, f in ipairs(w[3] or {}) do
            add({ parent = id, art = "pk_w" .. w[1] .. i, base = { op = 0 }, tf = { "r", "s" }, o = { f[3], f[4] },
                anims = { anim(f[1], 0.5, bezier(0.2, 1.15, 0.35, 1), { { 0, { op = 0, r = f[2], s = 0.3 } }, { 1, { op = 1, none = true } } }) } })
        end
        add({ parent = id, art = "pk_w" .. w[1] .. "arm" })
    end
    -- the sword of Light: in front of him for the first touch; lifted clear, it passes behind him for the second, and rests
    local SWX, SWY = -298.4, -201.3
    local function sword(parent)
        local id = parent .. "_in"
        add({ id = id, parent = parent, base = { op = 0, tx = SWX, ty = SWY }, tf = { "t" },
            anims = { anim(0.3, 0.45, bezier(0.2, 0.9, 0.2, 1), { { 1, { op = 1, none = true } } }) } })
        add({ parent = id, art = "pk_sword", base = { r = -5.5 }, tf = { "r" }, o = { GX, GY }, anims = {
            anim(0.62, 0.62, bezier(0.45, 0, 0.3, 1), { { 0, { r = -5.5 } }, { 0.3, { r = 0 } }, { 0.55, { r = 0 } }, { 1, { r = -5.5 } } }),
            anim(1.28, 0.45, bezier(0.45, 0, 0.3, 1), { { 0, { r = -5.5 } }, { 0.6, { r = 0 } }, { 1, { r = 0 } } }) } })
    end
    add({ id = "sback", parent = "pmid", base = { op = 0 }, anims = { lit(1.23, 0.01, 1, LINEAR) } })
    sword("sback")
    -- the stroke of light the blade leaves over his bowed head (drawn right to left), then the halo takes its place
    add({ id = "flourish", parent = "pmid", base = { op = 0 }, anims = {
        anim(0.98, 0.5, LINEAR, { { 0, { op = 1 } }, { 1, { op = 1 } } }), anim(1.95, 0.5, E1, { { 0, { op = 1 } }, { 1, { op = 0 } } }) } })
    line("flourish", "fl", 0.98, 0.5, bezier(0.4, 0, 0.2, 1), "pk_flourish")

    -- the knight's plane
    plane("pfg", "cam", { -12, -3 }, { -4, -1 })
    add({ id = "halo", parent = "pfg", base = { op = 0, s = 1.6 }, tf = { "s" }, o = { HCX, HCY },
        anims = { anim(2.0, 0.5, bezier(0.2, 0.9, 0.3, 1), { { 1, { op = 1, none = true } } }) } })
    add({ parent = "halo", art = "pk_halo", tf = { "r" }, o = { HCX, HCY },
        anims = { anim(0, 40, LINEAR, { { 0, { r = 0 } }, { 1, { r = 360 } } }, { loop = true, clock = "load" }) } })
    glow("pfg", "pk_heroglow", KCX, KY + KH / 2)
    add({ parent = "pfg", art = "pk_hero" })
    add({ parent = "pfg", art = "pk_hero2", base = { op = 0 }, anims = { lit(2.0, 0.5) } })
    add({ parent = "pfg", art = "pk_helm" })
    add({ parent = "pfg", art = "pk_helm2", base = { op = 0 }, anims = { lit(2.05, 0.5) } })
    local function star(parent, x, y, R, at, col, extra)
        return add({ parent = parent, art = "pk_star", rect = { x - R * 4 / 3, y - R * 4 / 3, R * 8 / 3, R * 8 / 3 }, base = { op = 0, s = 0, col = col }, tf = { "s", "r" }, o = { x, y },
            anims = extra or { anim(at, 0.45, EASE_OUT, { { 0, { op = 1, s = 0, r = -30 } }, { 0.4, { op = 1, s = 1.15, r = 0 } }, { 1, { op = 0, s = 0, r = 40 } } }, { nofill = true }) } })
    end
    for _, t in ipairs(EXTRA.pkTwinkles or {}) do
        star("pfg", t[1], t[2], t[3], 0, hex(t[4]), { anim(t[5], t[6], E2, { { 0, { op = 0, s = 0, r = 0 } }, { 0.5, { op = 1, s = 1, r = 45 } }, { 1, { op = 0, s = 0, r = 0 } } }, { loop = true }) })
    end
    -- the sword in front of him rides with the window's plane, so the swap to behind can't jump
    add({ id = "pcomp", parent = "pfg", tf = { "t" }, anims = { anim(0, 2.0, PUSH, { { 0, NONE }, { 1, { tx = 16, ty = 4 } } }) } })
    add({ id = "sfront", parent = "pcomp", anims = { anim(1.23, 0.01, LINEAR, { { 0, { op = 1 } }, { 1, { op = 0 } } }) } })
    sword("sfront")
    -- the level, above both swords, riding with the window's plane: the old one fades into the light, the new one glows in
    add({ id = "pnum", parent = "pfg", tf = { "t" }, anims = {
        anim(0, 2.0, PUSH, { { 0, NONE }, { 1, { tx = 16, ty = 4 } } }), anim(2.0, 0.9, SETTLE, { { 0, { tx = 16, ty = 4 } }, { 1, { tx = 4, ty = 1 } } }) } })
    add({ id = "old", parent = "pnum", base = { op = 0 }, anims = { lit(0.9, 0.5, 0.9), anim(1.7, 0.35, E1, { { 0, { op = 0.9 } }, { 1, { op = 0 } } }) } })
    for i = 1, 2 do add({ parent = "old", digit = "pk_d", dslot = i, dset = "old" }) end
    add({ id = "num", parent = "pnum", base = { op = 0, s = 1.12 }, tf = { "s" }, o = { RX, RY },
        anims = { anim(2.02, 0.6, SETTLE, { { 1, { op = 1, none = true } } }) } })
    for i = 1, 2 do add({ parent = "num", digit = "pk_d", dslot = i }) end
    for i = 1, 2 do
        add({ parent = "num", digit = "pk_dw", dslot = i, base = { op = 0 }, anims = { anim(2.02, 0.7, EASE_OUT, { { 0, { op = 1 } }, { 1, { op = 0 } } }) } })
    end
    add({ id = "roman", parent = "pnum", base = { op = 0 }, anims = { lit(2.3, 0.5) } })
    for i = 1, 7 do add({ parent = "roman", roman = "small", rslot = i }) end

    -- dawn: everything starts in the dark (and the dark returns when it closes)
    add({ parent = "cam", fill = P_INK, rect = { -40, -40, 1360, 800 }, base = { op = 0.94 }, anims = {
        anim(0.1, 1.3, bezier(0.4, 0, 0.4, 1), { { 1, { op = 0 } } }),
        anim(0.2, 0.5, E1, { { 0, { op = 0 } }, { 1, { op = 0.94 } } }, { clock = "exit" }) } })

    -- the header and the vow
    add({ parent = "cam", art = "pk_head", base = { op = 0, tx = -40 }, tf = { "t" }, anims = { anim(0.3, 0.4, EASE_OUT, { { 1, { op = 1, none = true } } }) } })
    -- the leaves: the page gives them no origin of their own, so they turn about the poster's top-left corner
    local leaves = EXTRA.pkLeaves or {}
    for i, at in ipairs({ 0.55, 0.95, 1.35 }) do
        local y = 112 + (i - 1) * 44
        local id = "vow" .. i
        add({ id = id, parent = "cam", anims = { lit(2.0, 0.6, 0.3) } })
        add({ parent = id, art = "pk_cap" .. i, base = { op = 0, s = 1.7 }, tf = { "s" }, o = { 50, y - 14 },
            anims = { anim(at, 0.3, bezier(0.2, 1.3, 0.4, 1), { { 1, { op = 1, none = true } } }) } })
        add({ parent = id, art = "pk_ink" .. i, base = { clip = 0 }, anims = { anim(at + 0.08, 0.45, bezier(0.4, 0, 0.3, 1), { { 1, { clip = 1 } } }) } })
        for k = (i - 1) * 6 + 1, i * 6 do
            local lf = leaves[k]
            if lf then
                add({ parent = id, art = "pk_leafw", rect = { lf[1] - 3.3, lf[2] - 4, 6.7, 8 }, base = { op = 0, col = hex(lf[3]) }, tf = { "t", "r" }, o = { 0, 0 },
                    anims = { anim(lf[4], 0.6, bezier(0.2, 0.7, 0.3, 1), { { 0, { op = 1, none = true } }, { 1, { op = 0, tx = lf[5], ty = lf[6], r = lf[7] } } }, { nofill = true }) } })
            end
        end
    end
    -- ARISE, inscribed in light behind a quill of gold; a light sweep; LEVEL UP
    add({ parent = "cam", art = "pk_arise", base = { clip = 0, s = 1.04 }, tf = { "s" }, o = { 300, 200 }, anims = {
        anim(2.12, 0.55, bezier(0.4, 0, 0.2, 1), { { 1, { clip = 1 } } }), anim(2.12, 0.9, SETTLE, { { 1, NONE } }) } })
    add({ parent = "cam", art = "pk_quill", base = { op = 0 }, tf = { "t" },
        anims = { anim(2.12, 0.55, bezier(0.4, 0, 0.2, 1), { { 0, { op = 1, tx = 0 } }, { 0.85, { op = 1 } }, { 1, { op = 0, tx = 600 } } }, { nofill = true }) } })
    add({ parent = "cam", art = "pk_arisew", ww = 110, strips = { 2, -math.tan(math.rad(22)) }, base = { op = 0, col = P_GOLD2 },
        anims = { anim(2.85, 0.8, bezier(0.4, 0, 0.2, 1), { { 0, { op = 0.8, wx = -260 } }, { 1, { op = 0.8, wx = 760 } } }, { nofill = true }) } })
    add({ parent = "cam", art = "pk_sub", base = { op = 0 }, anims = { lit(2.6, 0.5) } })
    add({ id = "barA", parent = "cam", static = about(rotate(-8), 300, 350) })
    add({ id = "barS", parent = "barA", base = { sx = 0 }, tf = { "sx" }, o = { 0, 360 }, anims = { anim(2.4, 0.35, bezier(0.3, 0.9, 0.2, 1), { { 1, NONE } }) } })
    add({ id = "barB", parent = "barS", static = about(rotate(8), 300, 350) })
    add({ parent = "barB", art = "pk_bar" })

    -- the card: a page of the libram, his rank in the Order on it
    add({ id = "panel", parent = "cam", base = { op = 0, ty = 40 }, tf = { "t" }, anims = { anim(2.45, 0.5, bezier(0.2, 0.9, 0.2, 1), { { 1, { op = 1, none = true } } }) } })
    add({ parent = "panel", art = "pk_panel" })
    add({ parent = "panel", text = "name", x = 50, y = 484, size = 56, color = P_WHITE, spacing = 2 })
    add({ parent = "panel", art = "pk_class" })
    add({ id = "rank", parent = "panel", base = { sx = 0 }, tf = { "sx" }, o = { 300, 0 }, anims = { anim(2.75, 0.45, bezier(0.3, 1.1, 0.4, 1), { { 1, NONE } }) } })
    add({ parent = "rank", art = "pk_rank" })
    add({ parent = "rank", art = "pk_rank_5", ranks = "pk_rank_" })
    for i = 1, 4 do
        local at = 2.6 + (i - 1) * 0.09
        add({ id = "row" .. i, parent = "panel", base = { op = 0 }, anims = { lit(at, 0.35) } })
        add({ parent = "row" .. i, art = "pk_row" .. i })
        add({ parent = "row" .. i, text = "v" .. i, x = 450 + (i - 1) * 6, y = 542 + (i - 1) * 38, size = 30, color = i == 1 and P_PINK or P_GOLD2,
            justify = "RIGHT", base = { op = 0, br = 3 }, anims = { anim(at + 0.12, 0.4, EASE_OUT, { { 0, { op = 0, br = 3 } }, { 1, { op = 1, br = 1 } } }) } })
        add({ parent = "row" .. i, art = "pk_uline", static = translate((i - 1) * 6, (i - 1) * 38), base = { sx = 0 }, tf = { "sx" }, o = { 386, 546 },
            anims = { anim(at + 0.12, 0.3, EASE_OUT, { { 1, NONE } }) } })
    end
    for i = 0, 10 do
        add({ parent = "panel", art = "pk_seg", static = translate(i * 34, 0), base = { col = hex("1a2040") },
            anims = { anim(3.0 + i * 0.05, 0.25, EASE_OUT, { { 0, { col = P_WHITE } }, { 1, { col = P_MANA } } }) } })
    end
    add({ parent = "panel", art = "pk_manalabel" })
    add({ parent = "panel", art = "pk_pagemask", ww = 120, strips = { 3, -math.tan(math.rad(14)) }, base = { op = 0 },
        anims = { anim(2.5, 0.45, bezier(0.4, 0, 0.2, 1), { { 0, { op = 0.9, wx = -160 } }, { 1, { op = 0.9, wx = 620 } } }, { nofill = true }) } })
    -- the talent point: the tag, then the pink wax seal pressed onto it (all hidden without a talent point)
    add({ id = "talent", parent = "cam" })
    add({ parent = "talent", art = "pk_tag", base = { op = 0, ty = -20 }, tf = { "t" }, anims = { anim(3.05, 0.35, bezier(0.2, 0.9, 0.2, 1), { { 1, { op = 1, none = true } } }) } })
    add({ parent = "talent", art = "pk_sealring", base = { op = 0 }, tf = { "s" }, o = { 1164, 568 },
        anims = { anim(3.35, 0.6, EASE_OUT, { { 0, { op = 0.9, s = 0.9 } }, { 1, { op = 0, s = 1.9 } } }) } })
    add({ parent = "talent", art = "pk_seal", base = { op = 0 }, tf = { "s", "r" }, o = { 1164, 568 },
        anims = { anim(3.25, 0.38, bezier(0.2, 1.4, 0.4, 1), { { 0, { op = 0, s = 1.9, r = 18 } }, { 1, { op = 1, none = true } } }) } })
    star("talent", 1206, 528, 34, 3.32, P_WHITE)
    -- glints where the blade touches, on the new level, at the end of ARISE, on the helm
    for _, g in ipairs({ { 868, 400, 46, 0.8 }, { 868, 400, 40, 1.52 }, { RX + 62, RY - 56, 58, 2.2 }, { 600, 128, 40, 2.66 }, { 612.5, 641.7, 30, 2.32 } }) do
        star("cam", g[1], g[2], g[3], g[4], P_WHITE)
    end
    -- the callouts
    for i, at in ipairs({ 3.0, 3.12 }) do
        add({ id = "call" .. i, parent = "cam", base = { op = 0 }, anims = { lit(at, 0.01, 1, LINEAR) } })
        add({ parent = "call" .. i, art = "pk_call" .. i .. "dot" })
        line("call" .. i, "ld" .. i, at, 0.3, EASE_OUT, "pk_ld" .. i .. "full")
        add({ parent = "call" .. i, art = "pk_call" .. i .. "lab", base = { op = 0 }, anims = { lit(at + 0.18, 0.3) } })
    end
    -- the bloom as the Light answers
    add({ parent = "cam", art = "pk_bloom", base = { op = 0 }, anims = { anim(2.0, 1.1, bezier(0.2, 0.6, 0.3, 1), { { 0, { op = 0.85 } }, { 1, { op = 0 } } }) } })
    add({ art = "pk_vig" })
    add({ grain = "pk_grain" })
    return { nodes = n, digits = { prefix = "pk_d", size = 150, cx = RX, angle = 0 },
        romans = { big = { prefix = "pk_rn", size = 300, anchor = "start", angle = -8 }, small = { prefix = "pk_rs", size = 10, spacing = 4, anchor = "middle" } },
        rank = L.PaladinRank,
        quakes = {},
        -- the game's own sounds: Lay on Hands as the blade touches, Holy Light as the column comes down, the choir of Resurrection,
        -- and the Stormwind bell
        sounds = { { 0.8, 569343, 0.7 }, { 1.52, 569343, 0.7 }, { 1.74, 569383 }, { 1.95, 568667, 3 }, { 2.02, 566564, 5 } },
        hold = 7.5, exit = 0.8,
        rows = { "str", "sta", "hp", "power" }, sample = { 2, 3, 18, 24 } }
end

POSTERS["Human:WARRIOR"] = function()
    local n = {}
    n[#n + 1] = { art = "war_bg" }
    n[#n + 1] = { art = "war_slab", base = { tx = 700 }, tf = { "t" }, anims = { anim(0.05, 0.3, bezier(0.3, 0.9, 0.2, 1), { { 1, NONE } }) } }
    -- the burst and the three chevrons, the third white-hot (the promotion) cooling to gold
    n[#n + 1] = { art = "war_rays", mask = true, base = { op = 0 }, tf = { "s", "r" }, o = { 960, 349 },
        anims = { anim(1.12, 0.8, EASE_OUT, { { 0, { op = 0.9, s = 0.2, r = 0 } }, { 1, { op = 0, s = 1.1, r = 14 } } }) } }
    local function stamp(art, at, s, ty, dur)
        return { art = art, base = { op = 0 }, tf = { "s", "t" }, o = { 960, 300 },
            anims = { anim(at, dur, bezier(0.3, 1.6, 0.5, 1), { { 0, { op = 0, s = s, ty = ty } }, { 1, { op = 1, none = true } } }) } }
    end
    n[#n + 1] = stamp("war_c0", 0.6, 1.8, -30, 0.18)
    n[#n + 1] = stamp("war_c1", 0.78, 1.8, -30, 0.18)
    local c2 = stamp(nil, 1.02, 2.6, -60, 0.26); c2.id = "c2"; n[#n + 1] = c2
    n[#n + 1] = { parent = "c2", art = "war_c2" }
    n[#n + 1] = { parent = "c2", art = "war_c2g", base = { op = 0 }, anims = { anim(1.3, 0.9, EASE_OUT, { { 1, { op = 1 } } }) } }
    -- the army marches beneath him, on a crimson road
    n[#n + 1] = { id = "army", base = { op = 0 }, anims = { anim(0.1, 0.4, EASE_OUT, { { 1, { op = 1 } } }) } }
    n[#n + 1] = { id = "march", parent = "army", tf = { "t" },
        anims = { anim(0, 1.44, LINEAR, { { 0, { tx = 0 } }, { 1, { tx = -64 } } }, { loop = true, clock = "load" }) } }
    for x = 440, 1399, 64 do n[#n + 1] = { parent = "march", sprite = "marchnavy", rect = { x, 504, 60, 96 } } end
    n[#n + 1] = { fill = RED, rect = { 420, 598, 860, 14 } }
    n[#n + 1] = { fill = INK, rect = { 0, 612, 1280, 108 } }
    n[#n + 1] = { art = "war_hero", base = { op = 0, tx = 360, kx = -10 }, tf = { "t", "kx" }, o = { 0, 0 },
        anims = { anim(0.2, 0.32, bezier(0.2, 0.9, 0.2, 1.1), { { 1, { op = 1, none = true } } }) } }
    n[#n + 1] = { art = "war_cry", base = { op = 0, tx = -60 }, tf = { "t" }, anims = { anim(0.38, 0.25, EASE_OUT, { { 1, { op = 1, none = true } } }) } }
    local word = slam(1.2, 300, 200); word.art = "war_word"; n[#n + 1] = word
    bar(n, "war", 1.34)
    local lv = crash(1.4, 590, 340); lv.id = "lv"; n[#n + 1] = lv
    n[#n + 1] = { parent = "lv", art = "war_lvbox" }
    n[#n + 1] = { id = "d1", parent = "lv", digit = "war_d" }
    n[#n + 1] = { id = "d2", parent = "lv", digit = "war_d" }
    card(n, "war", 476, 540, hex("2a1018"), RED, RED)
    n[#n + 1] = { id = "talent", art = "war_medal", base = { ty = -260 }, tf = { "t", "r" }, o = { 1196, -10 },
        anims = { anim(1.85, 1.6, bezier(0.3, 0.7, 0.3, 1), { { 0, { ty = -260, r = 0 } }, { 0.22, { ty = 0, r = -18 } }, { 0.4, { r = 13 } },
            { 0.57, { r = -8 } }, { 0.72, { r = 4 } }, { 0.86, { r = -2 } }, { 1, { r = 0 } } }) } }
    n[#n + 1] = { id = "talent2", art = "war_tag", base = { op = 0 }, tf = { "s", "t" }, o = { 1080, 70 },
        anims = { anim(2.05, 0.24, bezier(0.2, 1.6, 0.4, 1), { { 0, { op = 0, s = 1.8, ty = -30 } }, { 1, { op = 1, none = true } } }) } }
    n[#n + 1] = { art = "war_fta", base = { tx = 420 }, tf = { "t" }, anims = { anim(2.25, 0.28, bezier(0.2, 0.9, 0.2, 1), { { 1, NONE } }) } }
    flash(n, 1.12, 0.45, 0.85)
    n[#n + 1] = { grain = "war_grain" }
    return { nodes = n, digits = { prefix = "war_d", size = 132, cx = 604, angle = -8 },
        quakes = { { 0.62, 0.16, 10, 7, 9, 6, 5, 4, 3, 2 }, { 0.8, 0.16, 10, 7, 9, 6, 5, 4, 3, 2 }, { 1.06, 0.34, 10, 7, 9, 6, 5, 4, 3, 2 } },
        rows = { "str", "agi", "sta", "hp" }, sample = { 3, 2, 2, 27 } }
end

-- the Horde Orc Warrior: the war drum (design/wow/poster/orc10.py). Three beats of the bone mallet, a Persona cut-in on
-- his eyes, then the third strike splits the skin like thunder and the new level is struck into the drum's heart.
local EASE_IN, EASE_IN_OUT = bezier(0.42, 0, 1, 1), bezier(0.42, 0, 0.58, 1)
POSTERS["Orc:WARRIOR"] = function()
    local DX, DY, MPX, MPY = 720, 300, 330, 10
    local PARENT
    local O_INK, O_BONE2, O_RED = hex("0b0605"), hex("fff4dc"), hex("d7261e")
    local n = {}
    local function add(node) n[#n + 1] = node; return node end
    -- the camera: every beat punches in on the drum
    add({ id = "cam", tf = { "s" }, o = { DX, DY }, anims = {
        anim(0.7, 0.22, EASE_OUT, { { 0, { s = 1.035 } }, { 1, NONE } }), anim(0.95, 0.22, EASE_OUT, { { 0, { s = 1.035 } }, { 1, NONE } }),
        anim(2.0, 0.5, bezier(0.2, 1.4, 0.4, 1), { { 0, { s = 1.08 } }, { 1, NONE } }) } })
    add({ parent = "cam", art = "orc_bg" })
    add({ parent = "cam", art = "orc_ghost", base = { op = 0, tx = 120 }, tf = { "t" }, anims = {
        anim(0, 2.6, bezier(0.1, 0.7, 0.2, 1), { { 1, { op = 1, none = true } } }),
        anim(2.6, 7, EASE_IN_OUT, { { 0, { tx = 0 } }, { 1, { tx = -46 } } }, { loop = true, alt = true }) } })
    add({ parent = "cam", art = "orc_slab", base = { tx = 700 }, tf = { "t" }, anims = { anim(0.05, 0.3, bezier(0.3, 0.9, 0.2, 1), { { 1, NONE } }) } })
    -- the ring of words, turning slowly the other way
    add({ id = "ringwrap", parent = "cam", base = { op = 0 }, anims = { anim(0.5, 0.5, EASE_OUT, { { 1, { op = 1 } } }) } })
    add({ parent = "ringwrap", art = "orc_ringtext", tf = { "r" }, o = { DX, DY },
        anims = { anim(0, 120, LINEAR, { { 0, { r = 0 } }, { 1, { r = -360 } } }, { loop = true, clock = "load" }) } })
    add({ parent = "cam", art = "orc_splats", base = { op = 0 }, tf = { "s" }, o = { DX, DY },
        anims = { anim(2.05, 0.3, bezier(0.2, 1.3, 0.4, 1), { { 0, { op = 0, s = 0.3 } }, { 1, { op = 1, none = true } } }) } })
    add({ parent = "cam", art = "orc_rays", base = { op = 0 }, anims = {
        anim(0.7, 0.26, EASE_OUT, { { 0, { op = 0.55 } }, { 1, { op = 0 } } }, { nofill = true }),
        anim(0.95, 0.26, EASE_OUT, { { 0, { op = 0.55 } }, { 1, { op = 0 } } }, { nofill = true }),
        anim(2.0, 0.6, EASE_OUT, { { 0, { op = 0.9 } }, { 1, { op = 0.14 } } }, { nofill = true }) } })
    for _, r in ipairs({ { "orc_ring1", 0.7 }, { "orc_ring1", 0.95 }, { "orc_ring3", 2.0 } }) do
        add({ parent = "cam", art = r[1], base = { op = 0 }, tf = { "s" }, o = { DX, DY },
            anims = { anim(r[2], 0.6, EASE_OUT, { { 0, { op = 0.95, none = true } }, { 1, { op = 0, s = 1.8 } } }) } })
    end
    -- the drum: spins in, beats, turns slowly for ever; cracks and glows on the third strike
    add({ id = "drum", parent = "cam", base = { op = 0, s = 0.4, r = -40 }, tf = { "s", "r" }, o = { DX, DY },
        anims = { anim(0.1, 0.55, bezier(0.2, 1.1, 0.3, 1), { { 1, { op = 1, none = true } } }) } })
    add({ id = "beat", parent = "drum", tf = { "s" }, o = { DX, DY }, anims = {
        anim(0.7, 0.2, EASE_OUT, { { 0, { s = 1.07 } }, { 1, NONE } }), anim(0.95, 0.2, EASE_OUT, { { 0, { s = 1.07 } }, { 1, NONE } }),
        anim(2.0, 0.32, bezier(0.2, 1.4, 0.4, 1), { { 0, { s = 1.16 } }, { 1, NONE } }) } })
    -- while the drum fades in, the page fades it as one picture; here each piece fades on its own, so until it is solid
    -- the pieces underneath are drawn with what covers them cut out (_k), and the whole pieces take over at 0.65 s
    local function swap(art)
        add({ parent = PARENT, art = art .. "_k", anims = { anim(0.65, 0.001, LINEAR, { { 0, { op = 1 } }, { 1, { op = 0 } } }) } })
        add({ parent = PARENT, art = art, base = { op = 0 }, anims = { anim(0.65, 0.001, LINEAR, { { 1, { op = 1 } } }) } })
    end
    PARENT = "beat"; swap("orc_drumshadow")
    add({ id = "spin", parent = "beat", tf = { "r" }, o = { DX, DY },
        anims = { anim(0, 80, LINEAR, { { 0, { r = 0 } }, { 1, { r = 360 } } }, { loop = true, clock = "load" }) } })
    PARENT = "spin"; swap("orc_drum")
    add({ parent = "spin", art = "orc_crack", base = { op = 0 }, anims = { anim(2.0, 0.08, LINEAR, { { 1, { op = 1 } } }) } })
    local function glow(parent, art, ox, oy)
        return add({ parent = parent, art = art, base = { op = 0 }, tf = { "s" }, o = { ox, oy }, anims = {
            anim(2.0, 0.5, EASE_OUT, { { 0, { op = 1, s = 1.3 } }, { 1, { op = 0.55, none = true } } }),
            anim(2.5, 1.4, EASE_IN_OUT, { { 0, { op = 0.55, none = true } }, { 0.5, { op = 0.8, s = 1.05 } }, { 1, { op = 0.55, none = true } } }, { loop = true }) } })
    end
    glow("spin", "orc_glow", DX, DY)
    swap("orc_heart")
    add({ parent = "beat", art = "orc_lvlabel" })
    -- the old level, knocked out by the third strike
    add({ id = "old", parent = "cam", base = { op = 0 }, tf = { "s" }, o = { DX, DY }, anims = {
        anim(0.55, 0.25, EASE_OUT, { { 1, { op = 1 } } }),
        anim(2.0, 0.22, EASE_IN, { { 0, { op = 1, none = true } }, { 1, { op = 0, s = 1.9 } } }) } })
    for i = 1, 2 do add({ parent = "old", digit = "orc_do", dslot = i, dset = "old" }) end   -- its own outlined digits (at .9 in the picture)
    for i, sh in ipairs(EXTRA.orcShards or {}) do
        add({ parent = "cam", art = "orc_sh" .. i, base = { op = 0 }, tf = { "t" },
            anims = { anim(2.0, 0.8, bezier(0.1, 0.7, 0.3, 1), { { 0, { op = 1, none = true } }, { 1, { op = 0, tx = sh[1], ty = sh[2] } } }) } })
    end
    -- the new level, struck into the heart, with red and cyan ghosts
    local num = crash(2.1, DX, DY); num.id = "num"; num.parent = "cam"; add(num)
    for i = 1, 2 do add({ parent = "num", digit = "orc_d", dslot = i }) end
    for _, g in ipairs({ { hex("ff1e1e"), -14, 3 }, { hex("1ee0ff"), 14, -3 } }) do
        for i = 1, 2 do
            add({ parent = "num", digit = "orc_d", dslot = i, blend = "ADD", base = { op = 0, col = g[1] }, tf = { "t" },
                anims = { anim(2.1, 0.3, EASE_OUT, { { 0, { op = 0.9, tx = g[2], ty = g[3] } }, { 1, { op = 0, none = true } } }) } })
        end
    end
    add({ parent = "cam", art = "orc_streak", blend = "ADD", base = { op = 0 }, tf = { "sx" }, o = { DX, DY },
        anims = { anim(2.0, 0.5, bezier(0.1, 0.7, 0.3, 1), { { 0, { op = 1, sx = 0.15 } }, { 0.4, { op = 1 } }, { 1, { op = 0, sx = 1.5 } } }) } })
    -- the bone mallet (and two trails a beat behind): two beats, a wind-up through the cut-in, the third strike holds on the skin
    for _, m in ipairs({ { "orc_mallett1", 0.06 }, { "orc_mallett2", 0.03 }, { "orc_mallet", 0 } }) do
        local o = m[2]
        local hit = { { 0, { r = -28 } }, { 0.45, { r = 0 } }, { 1, { r = -28 } } }
        add({ parent = "cam", art = m[1], base = { op = 0, r = -28 }, tf = { "r" }, o = { MPX, MPY }, anims = {
            anim(0.45 + o, 0.2, EASE_OUT, { { 1, { op = 1 } } }),
            anim(0.58 + o, 0.25, EASE_IN_OUT, hit), anim(0.83 + o, 0.25, EASE_IN_OUT, hit),
            anim(1.12 + o, 0.7, EASE_IN_OUT, { { 0, { r = -28 } }, { 1, { r = -46 } } }, { nofill = true }),
            anim(1.88 + o, 0.3, EASE_IN_OUT, { { 0, { r = -46 } }, { 0.36, { r = 2 } }, { 0.58, { r = 2 } }, { 1, { r = -40 } } }, { nofill = true }) } })
    end
    -- the chant ribbon, its words scrolling under it
    add({ id = "ribbon", parent = "cam", base = { op = 0, sx = 0 }, tf = { "sx" }, o = { 600, 600 },
        anims = { anim(0.3, 0.3, bezier(0.3, 0.9, 0.2, 1), { { 1, { op = 1, none = true } } }) } })
    add({ parent = "ribbon", art = "orc_ribbon" })
    add({ id = "chantrot", parent = "ribbon", static = about(rotate(-6.3), 560, 660) })
    add({ parent = "chantrot", art = "orc_chant", base = { tx = -300 }, tf = { "t" }, win = { 560, 1320 },
        anims = { anim(0.2, 14, LINEAR, { { 0, { tx = -300 } }, { 1, { tx = -1100 } } }) } })
    -- embers, rising for ever
    for _, e in ipairs(EXTRA.orcEmbers or {}) do
        local r = e[3] * 1.6
        add({ parent = "cam", art = "orc_ember", rect = { e[1] - r, e[2] - r, 2 * r, 2 * r }, base = { op = 0, col = hex(e[4]) }, tf = { "t" },
            anims = { anim(e[6], e[7], LINEAR, { { 0, { op = 0, tx = 0, ty = 0 } }, { 0.12, { op = 1 } }, { 1, { op = 0, tx = e[5], ty = -440 } } }, { loop = true }) } })
    end
    -- the orc, and his ember glow after the strike
    add({ id = "hero", parent = "cam", base = { op = 0, ty = 140 }, tf = { "t" },
        anims = { anim(0.25, 0.45, bezier(0.15, 0.9, 0.2, 1), { { 1, { op = 1, none = true } } }) } })
    glow("hero", "orc_heroglow", 0, 0)
    add({ parent = "hero", art = "orc_hero" })
    add({ parent = "cam", art = "orc_cry", base = { op = 0, tx = -60 }, tf = { "t" }, anims = { anim(0.38, 0.25, EASE_OUT, { { 1, { op = 1, none = true } } }) } })
    -- LOK'TAR!, letter by letter, each from its own angle; RGB ghosts; a light sweep
    add({ id = "wordrot", parent = "cam", static = about(rotate(-8), 300, 200) })
    for i, l in ipairs(EXTRA.orcLetters or {}) do
        add({ parent = "wordrot", art = "orc_l" .. i, base = { op = 0 }, tf = { "s", "r", "t" }, o = { l[3], 200 },
            anims = { anim(l[1], 0.3, bezier(0.2, 1.4, 0.4, 1), { { 0, { op = 0, s = 2.3, r = l[2], ty = -40 } }, { 0.7, { op = 1, s = 0.95 } }, { 1, { op = 1, none = true } } }) } })
    end
    for _, g in ipairs({ { hex("ff1e1e"), -14, 3 }, { hex("1ee0ff"), 14, -3 } }) do
        add({ parent = "cam", art = "orc_wordflat", blend = "ADD", base = { op = 0, col = g[1] }, tf = { "t" },
            anims = { anim(2.05, 0.34, EASE_OUT, { { 0, { op = 0.9, tx = g[2], ty = g[3] } }, { 1, { op = 0, none = true } } }, { nofill = true }) } })
    end
    add({ parent = "cam", art = "orc_wordw", base = { op = 0 }, ww = 96, strips = { 2, -math.tan(math.rad(22)) },
        anims = { anim(2.6, 0.55, bezier(0.4, 0, 0.2, 1), { { 0, { op = 0.85, wx = -260 } }, { 1, { op = 0.85, wx = 760 } } }, { nofill = true }) } })
    add({ parent = "cam", art = "orc_sub", base = { op = 0, tx = -30 }, tf = { "t" }, anims = { anim(2.42, 0.3, EASE_OUT, { { 1, { op = 1, none = true } } }) } })
    local bn = #n
    bar(n, "orc", 2.22)
    for i = bn + 1, #n do if not n[i].parent then n[i].parent = "cam" end end
    add({ parent = "cam", art = "orc_smear", base = { op = 0 }, tf = { "t", "sx" }, o = { 0, 0 },
        anims = { anim(2.3, 0.42, EASE_OUT, { { 0, { op = 0.9, tx = -560, sx = 0.4 } }, { 0.6, { op = 0.6 } }, { 1, { op = 0, tx = 80, sx = 1 } } }) } })
    -- the card: slides in, the EXP bar fills and rolls over, the rows follow and their numbers count up
    add({ id = "panel", parent = "cam", base = { tx = -560 }, tf = { "t" }, anims = { anim(2.32, 0.35, bezier(0.2, 0.9, 0.2, 1), { { 1, NONE } }) } })
    add({ parent = "panel", art = "orc_panel" })
    add({ parent = "panel", art = "orc_xp", base = { sx = 0 }, tf = { "sx" }, o = { 30, 418 },
        anims = { anim(2.45, 1.1, LINEAR, { { 0, { sx = 0 } }, { 0.62, { sx = 1 } }, { 0.66, { sx = 0 } }, { 1, { sx = 0.07 } } }) } })
    add({ parent = "panel", art = "orc_xplabel", base = { op = 0 }, anims = { anim(2.5, 0.3, EASE_OUT, { { 1, { op = 1 } } }) } })
    add({ parent = "panel", text = "name", x = 50, y = 476, size = 58, color = O_BONE2, spacing = 2 })
    add({ parent = "panel", art = "orc_class" })
    for i = 1, 4 do
        local at = 2.42 + (i - 1) * 0.07
        add({ id = "row" .. i, parent = "panel", base = { op = 0, tx = -40 }, tf = { "t" }, anims = { anim(at, 0.25, EASE_OUT, { { 1, { op = 1, none = true } } }) } })
        add({ parent = "row" .. i, art = "orc_row" .. i })
        add({ parent = "row" .. i, text = "v" .. i, x = 450 + (i - 1) * 6, y = 540 + (i - 1) * 38, size = 30,
            color = i == 1 and O_RED or O_BONE2, justify = "RIGHT", count = { at, 0.45 } })
    end
    for i = 0, 10 do
        add({ parent = "panel", art = "orc_seg", static = translate(i * 34, 0), base = { col = hex("2a0d0c") },
            anims = { anim(2.92 + i * 0.05, 0.2, EASE_OUT, { { 1, { col = O_RED } } }) } })
    end
    add({ parent = "panel", art = "orc_ragelabel" })
    -- the talent point: a bone tag stamped down, a war mark cut into it
    add({ id = "talent", parent = "cam", art = "orc_tag", base = { op = 0 }, tf = { "s", "t" }, o = { 1134, 668 },
        anims = { anim(2.8, 0.24, bezier(0.2, 1.6, 0.4, 1), { { 0, { op = 0, s = 1.8, ty = -30 } }, { 1, { op = 1, none = true } } }) } })
    add({ id = "talent2", parent = "cam", art = "orc_mark", base = { op = 0 }, tf = { "s", "r" }, o = { 1228, 616 },
        anims = { anim(2.96, 0.3, bezier(0.2, 1.6, 0.4, 1), { { 0, { op = 0, s = 2.6, r = -30 } }, { 1, { op = 1, none = true } } }) } })
    -- the cut-in: the screen dims, a black band with his eyes slashes across and holds, then the strike
    add({ parent = "cam", fill = { 0, 0, 0 }, rect = { 0, 0, 1280, 720 }, base = { op = 0 },
        anims = { anim(1.08, 0.92, LINEAR, { { 0, { op = 0 } }, { 0.09, { op = 0.55 } }, { 0.88, { op = 0.55 } }, { 1, { op = 0 } } }) } })
    add({ id = "cutin", parent = "cam", base = { op = 0, tx = -1500 }, tf = { "t" },
        anims = { anim(1.08, 0.92, LINEAR, { { 0, { op = 1, tx = -1500 } }, { 0.11, { op = 1, tx = 0 } }, { 0.84, { op = 1, tx = 60 } }, { 1, { op = 1, tx = 1500 } } }) } })
    add({ parent = "cutin", art = "orc_cutband" })
    add({ parent = "cutin", art = "orc_cutface", tf = { "s" }, o = { 640, 360 },
        anims = { anim(1.08, 0.92, LINEAR, { { 0, NONE }, { 1, { s = 1.12 } } }, { nofill = true }) } })
    -- his name and the moment, in the band's turned frame, one letter picture each (the name is the player's)
    add({ id = "cutrot", parent = "cutin", static = about(rotate(-8), 640, 360) })
    for i = 1, 48 do add({ parent = "cutrot", art = "orc_g1", run = "cut", ri = i, base = { col = O_RED } }) end
    -- over everything: the vignette, the opening slash (and, when it closes itself, the halves slam shut again), the flash
    add({ art = "orc_vig" })
    for _, h in ipairs({ { "orc_openA", -640, -380 }, { "orc_openB", 640, 380 } }) do
        add({ art = h[1], tf = { "t" }, anims = {
            anim(0.04, 0.42, bezier(0.6, 0, 0.2, 1), { { 1, { tx = h[2], ty = h[3] } } }),
            anim(0, 0.36, bezier(0.6, 0, 0.4, 1), { { 0, { tx = h[2], ty = h[3] } }, { 1, NONE } }, { clock = "exit" }) } })
    end
    add({ art = "orc_openLine", anims = { anim(0.04, 0.3, EASE_OUT, { { 0, { op = 1 } }, { 1, { op = 0 } } }),
        anim(0.3, 0.1, LINEAR, { { 0, { op = 0 } }, { 1, { op = 1 } } }, { clock = "exit" }) } })
    flash(n, 2.0, 0.5, 0.85)
    add({ grain = "orc_grain" })
    return { nodes = n, digits = { prefix = "orc_d", size = 132, cx = DX, angle = 0 },
        quakes = { { 0.7, 0.16, keys = { { 0, 0, 0 }, { 0.2, -11, 8 }, { 0.4, 10, -6 }, { 0.6, -5, 4 }, { 0.8, 3, -2 }, { 1, 0, 0 } } },
            { 0.95, 0.16, keys = { { 0, 0, 0 }, { 0.2, -11, 8 }, { 0.4, 10, -6 }, { 0.6, -5, 4 }, { 0.8, 3, -2 }, { 1, 0, 0 } } },
            { 2.0, 0.42, keys = { { 0, 0, 0 }, { 0.15, -16, 11, -1.4 }, { 0.32, 13, -9, 1.1 }, { 0.5, -8, 6, -0.6 }, { 0.7, 4, -3, 0.3 }, { 0.85, -2, 1 }, { 1, 0, 0 } } } },
        -- the game's own sounds: a war drum on each beat, Thunder Clap and a thunder crack on the strike, an orc's roar for LOK'TAR
        sounds = { { 0.7, 567275, 0.45 }, { 0.95, 567275, 0.45 }, { 2.0, 569222 }, { 2.0, 567275, 0.6 }, { 2.02, 565712 }, { 2.08, 541398 } },
        hold = 7.5, exit = 0.55,
        runs = { cut = { glyphs = EXTRA.orcGlyphs, x = 40, y = 420, spacing = 6,
            text = function(name) return name .. " \194\183 ORC WARRIOR \194\183 THE THIRD BEAT" end } },
        rows = { "str", "agi", "sta", "hp" }, sample = { 3, 2, 2, 31 } }
end
-- the Alliance Gnome Priest: the smallest of us, the brightest Light (design/wow/poster/gnome16.py). Night over Gnomeregan;
-- close on the tiny gnome, tilted, as she winds the Light up through a brass ratchet and calls the spell word by word
-- (POWER / WORD: / SHIELD); on the hit the shield bursts open from her staff, the camera pulls back hard and levels, and
-- her shadow towers over the allies it covers. Then RADIANT!, the flip clock turns the level over, and the card.
POSTERS["Gnome:PRIEST"] = function()
    local G = EXTRA.gn or {}
    local n = {}
    local function add(node) n[#n + 1] = node; return node end
    local IO, EIN = bezier(0.42, 0, 0.58, 1), bezier(0.42, 0, 1, 1)
    local CY, GOLD = hex("33e6d0"), hex("ffe39a")
    local function opkeys(list) local k = {} for i, p in ipairs(list or {}) do k[i] = { p[1], { op = p[2] } } end return k end
    -- the camera: a Dutch tilt that snaps level on the pull, a jolt on each word and on the hit, and four planes zoomed in
    -- on the staff's tip that pull back to the full scene (the near ones further: parallax)
    add({ id = "dutch", base = { r = -5 }, tf = { "r" }, o = { 801, 181 }, anims = { anim(1.69, 0.75, bezier(0.2, 1.35, 0.4, 1), { { 1, NONE } }) } })
    add({ id = "kick", parent = "dutch", tf = { "t" }, anims = { anim(0.6, 1.1, LINEAR, {
        { 0, NONE }, { 0.019, NONE }, { 0.026, { tx = -5, ty = 3 } }, { 0.05, { tx = 3, ty = -2 } }, { 0.07, NONE }, { 0.29, NONE },
        { 0.297, { tx = 5, ty = 3 } }, { 0.32, { tx = -3, ty = -2 } }, { 0.34, NONE }, { 0.563, NONE }, { 0.57, { tx = -7, ty = 4 } },
        { 0.595, { tx = 4, ty = -3 } }, { 0.62, NONE }, { 0.908, NONE }, { 0.916, { tx = 9, ty = -6 } }, { 0.954, { tx = -8, ty = 6 } },
        { 0.992, { tx = 4, ty = -2 } }, { 1, NONE } }) } })
    local PULL = bezier(0.15, 0.85, 0.25, 1.05)
    local function layer(id, s, ox, oy, extra)
        local node = add({ id = id, parent = "kick", base = { s = s }, tf = { "s" }, o = { ox, oy }, anims = {
            anim(0, 1.6, LINEAR, { { 0, { s = s * 1.087 } }, { 1, { s = s } } }, { nofill = true }),
            anim(1.69, 0.6, PULL, { { 0, { s = s } }, { 1, NONE } }) } })
        if extra then node.anims[#node.anims + 1] = extra end
        return node
    end
    -- a sheet of snow, always falling (two copies, one period apart)
    local function snow(parent, art, sh)
        if not (sh and ART[art]) then return end
        local id = art .. "_fall"
        add({ id = id, parent = parent, tf = { "t" }, anims = {
            anim(0, sh.dur, LINEAR, { { 0, { tx = 0, ty = 0 } }, { 1, { tx = sh.to[1], ty = sh.to[2] } } }, { loop = true, clock = "load" }) } })
        add({ parent = id, art = art })
        add({ parent = id, art = art, static = translate(0, sh.copies[2] - sh.copies[1]) })
    end
    -- a ring that bursts out and thins (the page animates its stroke width): pictures at four widths, cross-faded
    local RING = bezier(0.1, 0.8, 0.3, 1)
    local function ring(parent, art, keys, at, dur, cx, cy, s0, s1)
        add({ id = art, parent = parent, base = { op = 0 }, tf = { "s" }, o = { cx, cy }, anims = {
            anim(at, dur, RING, { { 0, { op = 1, s = s0 } }, { 1, { op = 0, s = s1 } } }, { nofill = true }) } })
        for k = 1, 4 do
            add({ parent = art, art = art .. k, base = { op = 0 }, anims = { anim(at, dur, LINEAR, opkeys(keys and keys[k]), { nofill = true }) } })
        end
    end
    -- a figure's rim lights up: for the first 0.1 s the page shows the whole figure at 3x brightness, then the rim
    local function roll(parent, art, d, R)
        add({ parent = parent, art = art .. "hot", base = { op = 0 }, anims = { anim(d, 0.32, LINEAR, opkeys(R.hot), { nofill = true }) } })
        add({ parent = parent, art = art .. "rim", base = { op = 0 }, anims = { anim(d, 0.32, LINEAR, opkeys(R.rimk)) } })
    end
    local function dot(parent, x, y, r, col, anims, extra)
        local node = { parent = parent, art = "gn_disc", rect = { x - r, y - r, 2 * r, 2 * r }, base = { op = 0, col = hex(col) }, tf = { "t" }, anims = anims }
        for k, v in pairs(extra or {}) do node[k] = v end
        return add(node)
    end

    -- the far plane: the night sky, far snow, Gnomeregan's stacks and gears on the skyline
    layer("lbg", 1.45, 1132.2, 1164.9)
    add({ parent = "lbg", art = "gn_sky" })
    snow("lbg", "gn_snowfar", G.snowfar)
    add({ parent = "lbg", art = "gn_skyline" })
    for _, c in ipairs(G.farcogs or {}) do
        add({ parent = "lbg", art = "gn_farcog" .. c[1], tf = { "r" }, o = { c[3], c[4] },
            anims = { anim(0, c[2], LINEAR, { { 0, { r = 0 } }, { 1, { r = 360 } } }, { loop = true }) } })
    end
    for _, m in ipairs(G.smoke or {}) do
        dot("lbg", m[1], m[2], m[3], m[4], { anim(m[5], 4.8, EASE_OUT, { { 0, { op = 0, none = true } }, { 0.2, { op = 0.9 } },
            { 1, { op = 0, tx = 26, ty = -110, s = 2.2 } } }, { loop = true }) }, { tf = { "t", "s" }, o = { 0, 0 } })
    end
    add({ parent = "lbg", art = "gn_skyline2" })

    -- the shield plane: the shield bursts open from the staff's tip and breathes; her shadow rises on it, clipped to it
    layer("lsh", 1.95, 1012.1, 807.6)
    add({ id = "shield", parent = "lsh", base = { op = 0, s = 0 }, tf = { "s" }, o = { 904, 486 }, anims = {
        anim(1.6, 0.5, bezier(0.2, 1.25, 0.4, 1), { { 0, { op = 1, s = 0 } }, { 1, { op = 1, none = true } } }) } })
    add({ id = "breath", parent = "shield", tf = { "s" }, o = { 900, 470 }, anims = { anim(2.4, 3.2, IO, { { 0.5, { s = 1.012 } } }, { loop = true }) } })
    add({ parent = "breath", art = "gn_face" })
    add({ parent = "breath", art = "gn_giant", base = { op = 0 }, tf = { "s" }, o = { 842, 692 }, cclip = { 900, 470, 404, 4 }, anims = {
        anim(1.62, 0.7, bezier(0.2, 1.25, 0.4, 1), { { 0, { op = 0, s = 1 } }, { 0.12, { op = 1 } }, { 1, { op = 1, s = 3.35 } } }, { nofill = true }) } })
    -- once grown: one picture, clipped inside the rim band (her swell with the Light stays under the band)
    add({ parent = "breath", art = "gn_giantc", base = { op = 0 }, tf = { "s" }, o = { 842, 692 }, anims = {
        anim(2.32, 0.001, LINEAR, { { 1, { op = 1 } } }),
        anim(2.6, 3.2, IO, { { 0, { op = 1, s = 1 } }, { 0.5, { op = 0.85, s = 3.39 / 3.35 } }, { 1, { op = 1, s = 1 } } }, { loop = true }) } })
    add({ parent = "breath", art = "gn_shim", base = { tx = -700, kx = -25 }, tf = { "t", "kx" }, o = { 0, 0 }, cclip = { 900, 470, 404, 10 }, anims = {
        anim(2.4, 3.6, IO, { { 0, { tx = -700, kx = -25 } }, { 0.4, { tx = 700, kx = -25 } }, { 1, { tx = 700, kx = -25 } } }, { loop = true }) } })
    add({ parent = "breath", art = "gn_rim" })
    add({ parent = "breath", art = "gn_shafts", base = { op = 0 }, tf = { "r" }, o = { 900, 470 }, anims = {
        anim(1.9, 0.8, EASE_OUT, { { 1, { op = 1 } } }), anim(1.9, 70, LINEAR, { { 0, { r = 0 } }, { 1, { r = 360 } } }, { loop = true }) } })
    -- she seals it: a white line runs round the rim from the top, then fades
    add({ id = "seal", parent = "breath", anims = { anim(2.32, 0.5, EASE_OUT, { { 0, { op = 1 } }, { 1, { op = 0 } } }) } })
    for _, p in ipairs(G.seal or {}) do
        add({ parent = "seal", art = "gn_seal_" .. p[1], seg = p, anims = { anim(1.74, 0.56, LINEAR, { { 0, { dr = 0 } }, { 1, { dr = 1 } } }) } })
    end
    add({ parent = "seal", art = "gn_seal", whole = true, anims = { anim(1.74, 0.56, LINEAR, { { 0, { dr = 0 } }, { 1, { dr = 1 } } }) } })
    -- the prayer ring turning, its cogs dropping in one by one with a spark
    add({ id = "pring", parent = "breath", tf = { "r" }, o = { 900, 470 }, anims = { anim(1.6, 60, LINEAR, { { 0, { r = 0 } }, { 1, { r = 360 } } }, { loop = true }) } })
    add({ parent = "pring", art = "gn_pring" })
    for i, l in ipairs(G.lock or {}) do
        local id = "lock" .. i
        add({ id = id, parent = "pring", static = about(rotate(l[3]), 900, 470) })
        add({ parent = id, art = "gn_lockcog", base = { op = 0, ty = -46, r = -120, s = 1.3 }, tf = { "t", "r", "s" }, o = { 900, 84 }, anims = {
            anim(l[1], 0.13, bezier(0.5, 0, 0.9, 0.5), { { 0, { op = 0, ty = -46, r = -120, s = 1.3 } }, { 0.3, { op = 1 } }, { 1, { op = 1, none = true } } }) } })
        add({ parent = id, art = "gn_lockspark", base = { op = 0, s = 0 }, tf = { "s", "r" }, o = { 900, 84 }, anims = {
            anim(l[2], 0.3, bezier(0.2, 0.8, 0.3, 1), { { 0, { op = 1, s = 0.3, r = 0 } }, { 0.4, { op = 1, s = 1.15, r = 30 } }, { 1, { op = 0, s = 0.6, r = 45 } } },
                { nofill = true }) } })
    end
    add({ parent = "lsh", art = "gn_crack", base = { op = 0 }, tf = { "s" }, o = { 900, 470 }, anims = {
        anim(1.68, 0.5, EASE_OUT, { { 0, { op = 1, s = 0.98 } }, { 1, { op = 0, s = 1.12 } } }, { nofill = true }) } })
    add({ parent = "lsh", art = "gn_rays", base = { op = 0 }, tf = { "r", "s" }, o = { 904, 486 }, anims = {
        anim(1.66, 0.9, EASE_OUT, { { 0, { op = 0.95, r = -6, s = 0.3 } }, { 1, { op = 0, r = 8, s = 1.1 } } }, { nofill = true }) } })
    ring("lsh", "gn_wave", G.wave, 1.6, 0.55, 904, 486, 0.05, 1.5)
    -- shards of the shell the shield breaks out of (they turn about the poster's corner, as on the page)
    for i, sh in ipairs(G.shards or {}) do
        add({ parent = "lsh", art = "gn_sh" .. i, base = { op = 0 }, tf = { "t", "r" }, o = { 0, 0 }, anims = {
            anim(1.72, 0.7, bezier(0.1, 0.7, 0.3, 1), { { 0, { op = 1, none = true } }, { 1, { op = 0, tx = sh[1], ty = sh[2], r = sh[3] } } }, { nofill = true }) } })
    end

    -- the hero plane: the ground, the allies in the dark, the gnome winding up the Light
    layer("lhero", 2.3, 983, 721)
    add({ parent = "lhero", art = "gn_ground" })
    add({ parent = "lhero", art = "gn_pool", base = { op = 0, sx = 0.2 }, tf = { "sx" }, o = { 900, 692 }, anims = {
        anim(1.62, 0.6, bezier(0.2, 0.9, 0.3, 1), { { 1, { op = 1, none = true } } }) } })
    for i, d in ipairs(G.shadows or {}) do
        add({ parent = "lhero", art = "gn_shadow" .. i, base = { op = 0 }, anims = { anim(d, 0.4, EASE_OUT, { { 1, { op = 0.85 } } }) } })
    end
    for k, A in ipairs(G.allies or {}) do
        local a = "gn_a" .. k
        add({ parent = "lhero", art = a .. "bloom", base = { op = 0 }, anims = {
            anim(A.d, 0.5, EASE_OUT, { { 0, { op = 0 } }, { 0.3, { op = 1 } }, { 1, { op = A.bloom } } }) } })
        add({ parent = "lhero", art = a })
        roll("lhero", a, A.d, A)
    end
    snow("lhero", "gn_snowmid", G.snowmid)
    for _, m in ipairs(G.motes or {}) do
        dot("lhero", m[1], m[2], m[3], m[4], { anim(1.8 + m[5], m[6], LINEAR, { { 0, { op = 0, none = true } }, { 0.15, { op = 0.9 } }, { 1, { op = 0, ty = -120 } } }, { loop = true }) })
    end
    add({ parent = "lhero", art = "gn_tipglow", base = { op = 0, s = 0.2 }, tf = { "s" }, o = { 904, 486 }, anims = {
        anim(0.45, 1.1, EIN, { { 0, { op = 0.6, s = 0.2 } }, { 0.3, { op = 0.8, s = 0.45 } }, { 0.6, { op = 0.9, s = 0.7 } }, { 1, { op = 1, s = 1 } } }) } })
    -- the brass ratchet: it spins open, clicks round a notch on each word, and lets go on the hit
    add({ id = "wind", parent = "lhero", base = { op = 0, s = 0.3 }, tf = { "s" }, o = { 904, 486 }, anims = {
        anim(0.45, 0.3, bezier(0.2, 1.4, 0.4, 1), { { 1, { op = 1, none = true } } }),
        anim(1.75, 0.25, EIN, { { 0, { op = 1 } }, { 1, { op = 0 } } }) } })
    add({ id = "ratchet", parent = "wind", tf = { "r" }, o = { 904, 486 }, anims = { anim(0.6, 1, LINEAR, {
        { 0, { r = 0 } }, { 0.02, { r = 0 } }, { 0.06, { r = -38 } }, { 0.09, { r = -32.7 } }, { 0.32, { r = -32.7 } }, { 0.36, { r = -72 } },
        { 0.39, { r = -65.4 } }, { 0.62, { r = -65.4 } }, { 0.66, { r = -106 } }, { 0.69, { r = -98.2 } }, { 1, { r = -98.2 } } }) } })
    add({ parent = "ratchet", art = "gn_windcog", tf = { "r", "s" }, o = { 904, 486 }, anims = {
        anim(1.6, 0.45, bezier(0.1, 0.7, 0.3, 1), { { 0, NONE }, { 1, { r = 900, s = 1.6 } } }) } })
    add({ parent = "wind", art = "gn_windstar" })
    add({ parent = "wind", art = "gn_windptr" })
    -- the Light streaming into the tip; the spell's words circling in and shrinking into it
    for _, f in ipairs(G.inflow or {}) do
        dot("lhero", 904, 486, f[1], f[2], { anim(f[3], 0.34, bezier(0.6, 0, 0.9, 0.6), { { 0, { op = 0, tx = f[4], ty = f[5] } }, { 0.25, { op = 1 } },
            { 1, { op = 1, none = true } } }, { nofill = true }) })
    end
    for i, d in ipairs(G.gath or {}) do
        add({ parent = "lhero", art = "gn_gath" .. i, base = { op = 0 }, tf = { "s" }, o = { 904, 486 }, anims = {
            anim(d, 0.3, bezier(0.5, 0, 0.9, 0.5), { { 0, { op = 0, s = 1 } }, { 0.3, { op = 1 } }, { 1, { op = 1, s = 0 } } }, { nofill = true }) } })
    end
    -- the gnome: lit only by her staff, then in gold
    add({ parent = "lhero", art = "gn_gbloom", base = { op = 0 }, anims = { anim(1.66, 0.5, EASE_OUT, { { 0, { op = 0 } }, { 0.3, { op = 1 } }, { 1, { op = 1 } } }) } })
    add({ parent = "lhero", art = "gn_gnome" })
    add({ parent = "lhero", art = "gn_gthin", anims = { anim(1.66, 0.25, EASE_OUT, { { 0, { op = 1 } }, { 1, { op = 0 } } }) } })
    add({ parent = "lhero", art = "gn_gfat", base = { op = 0 }, anims = { anim(1.66, 0.25, EASE_OUT, { { 1, { op = 1 } } }) } })
    if G.gnome then roll("lhero", "gn_g", 1.66, G.gnome) end
    add({ parent = "lhero", art = "gn_tipdot" })
    add({ parent = "lhero", art = "gn_glint", base = { s = 0 }, tf = { "s", "r" }, o = { 904, 486 }, anims = {
        anim(2.7, 4, IO, { { 0, { s = 0, r = 0 } }, { 0.05, { s = 1, r = 45 } }, { 0.11, { s = 0, r = 90 } }, { 1, { s = 0, r = 90 } } }, { loop = true }) } })

    -- the near plane: dust before the lens, gone after the pull; the near snow
    layer("lfg", 3.4, 946.8, 613.3, anim(1.9, 0.35, EASE_OUT, { { 0, { op = 1 } }, { 1, { op = 0 } } }))
    add({ parent = "lfg", art = "gn_bokeh" })
    snow("kick", "gn_snownear", G.snownear)
    -- the edges close in while the Light gathers
    add({ art = "gn_vig", base = { op = 0 }, anims = { anim(0, 1.6, bezier(0.5, 0, 0.9, 0.5), { { 0, { op = 0 } }, { 1, { op = 0.85 } } }),
        anim(1.6, 0.05, LINEAR, { { 0, { op = 0.85 } }, { 1, { op = 0 } } }) } })

    -- the spell's name, called word by word
    add({ art = "gn_callbox", base = { sx = 0 }, tf = { "sx" }, o = { 36, 30 }, anims = { anim(0.56, 0.2, EASE_OUT, { { 1, NONE } }) } })
    for i, c in ipairs(G.call or {}) do
        add({ art = "gn_call" .. i, bright = "gn_call" .. i .. "hot", brightK = 3, base = { op = 0, kx = -12, s = 1.9 }, tf = { "kx", "s" }, o = { c[2], c[3] }, anims = {
            anim(c[1], 0.16, bezier(0.2, 1.4, 0.4, 1), { { 0, { op = 0, kx = -12, s = 1.9, br = 3 } }, { 0.6, { op = 1 } }, { 1, { op = 1, kx = -12, br = 1 } } }) } })
    end
    -- the type: the black slab, RADIANT! letter by letter, its shine, the line under it, LEVEL UP
    add({ art = "gn_slab", base = { tx = -760 }, tf = { "t" }, anims = { anim(1.7, 0.28, bezier(0.3, 0.9, 0.2, 1), { { 1, NONE } }) } })
    add({ id = "wordrot", static = about(rotate(-6), 280, 200) })
    for i, l in ipairs(G.letters or {}) do
        add({ parent = "wordrot", art = "gn_l" .. i, base = { op = 0, ty = -34, s = 1.7, r = l[2] }, tf = { "t", "s", "r" }, o = { l[3], 200 }, anims = {
            anim(l[1], 0.2, bezier(0.2, 1.5, 0.4, 1), { { 0, { op = 0, ty = -34, s = 1.7, r = l[2] } }, { 0.4, { op = 1 } }, { 1, { op = 1, none = true } } }) } })
    end
    add({ art = "gn_wordw", base = { op = 0.85, wx = -200 }, ww = 90, strips = { 3, -math.tan(math.rad(25)) }, anims = {
        anim(2.25, 5, IO, { { 0, { wx = -200 } }, { 0.12, { wx = 760 } }, { 1, { wx = 760 } } }, { loop = true }) } })
    add({ art = "gn_sub", base = { op = 0 }, anims = { anim(2.1, 0.3, EASE_OUT, { { 1, { op = 1 } } }) } })
    add({ id = "barA", static = about(rotate(-6), 280, 330) })
    add({ id = "barS", parent = "barA", base = { sx = 0 }, tf = { "sx" }, o = { 0, 360 }, anims = { anim(2.0, 0.24, EASE_OUT, { { 1, NONE } }) } })
    add({ id = "barB", parent = "barS", static = about(rotate(6), 280, 330) })
    add({ parent = "barB", art = "gn_bar" })
    -- the flip clock: the old level's card falls forward on the hinge and the new one lands; the box kicks, sparks fly
    add({ id = "odo", base = { op = 0, tx = -30 }, tf = { "t" }, anims = { anim(2.0, 0.25, EASE_OUT, { { 1, { op = 1, none = true } } }) } })
    ring("odo", "gn_oring", G.oring, 2.5, 0.45, 504, 344, 0.6, 2.1)
    for i, sp in ipairs(G.osparks or {}) do
        add({ parent = "odo", art = "gn_osp" .. i, base = { op = 0 }, tf = { "t" }, anims = {
            anim(2.5, 0.4, bezier(0.1, 0.8, 0.3, 1), { { 0, { op = 1, none = true } }, { 1, { op = 0, tx = sp[1], ty = sp[2] } } }, { nofill = true }) } })
    end
    add({ id = "odokick", parent = "odo", tf = { "s", "r" }, o = { 504, 344 }, anims = {
        anim(2.5, 0.3, bezier(0.2, 1.6, 0.4, 1), { { 0, { s = 1.14, r = -2 } }, { 1, NONE } }, { nofill = true }) } })
    add({ parent = "odokick", art = "gn_odobox" })
    for slot = 1, 2 do
        local st = translate(slot == 1 and -66 or 0, 0)
        add({ parent = "odokick", flip = { slot, "static" }, static = st })
        add({ parent = "odokick", flip = { slot, "utop" }, static = st })
        add({ parent = "odokick", flip = { slot, "ubot" }, static = st })
        add({ id = "fa" .. slot, parent = "odokick", flip = { slot, "fa" }, static = st, tf = { "sy" }, o = { 544, 344 }, anims = {
            anim(2.2, 0.14, bezier(0.5, 0, 1, 0.6), { { 0, { sy = 1 } }, { 1, { sy = 0 } } }) } })
        add({ parent = "fa" .. slot, fill = { 0, 0, 0 }, rect = { 514, 296, 60, 47 }, base = { op = 0 }, anims = { anim(2.2, 0.14, LINEAR, { { 1, { op = 0.6 } } }) } })
        add({ id = "fb" .. slot, parent = "odokick", flip = { slot, "fb" }, static = st, base = { sy = 0 }, tf = { "sy" }, o = { 544, 344 }, anims = {
            anim(2.34, 0.2, bezier(0, 0.4, 0.5, 1.25), { { 1, NONE } }) } })
        add({ parent = "fb" .. slot, fill = { 0, 0, 0 }, rect = { 514, 345, 60, 47 }, base = { op = 0.6 }, anims = { anim(2.34, 0.2, LINEAR, { { 1, { op = 0 } } }) } })
    end
    add({ parent = "odokick", art = "gn_odohinge" })

    -- the card: slides in; each row lands with a flash and a sweep of light, its number counting up
    add({ id = "panel", base = { tx = -580 }, tf = { "t" }, anims = { anim(2.15, 0.36, bezier(0.2, 0.9, 0.2, 1), { { 1, NONE } }) } })
    add({ parent = "panel", art = "gn_panel" })
    add({ parent = "panel", text = "name", x = 55, y = 491, size = 58, color = CY, spacing = 2 })
    add({ parent = "panel", text = "name", x = 50, y = 486, size = 58, color = WHITE, spacing = 2, flags = "OUTLINE" })
    for i, d in ipairs(G.rows or {}) do
        local id = "row" .. i
        add({ id = id, parent = "panel", base = { op = 0, tx = -36 }, tf = { "t" }, anims = { anim(d, 0.25, EASE_OUT, { { 1, { op = 1, none = true } } }) } })
        add({ parent = id, art = "gn_row" .. i })
        add({ parent = id, art = "gn_rowsh" .. i, base = { op = 0 }, anims = { anim(d, 0.18, EASE_OUT, { { 0, { op = 0.9 } }, { 1, { op = 0 } } }, { nofill = true }) } })
        add({ parent = id, art = "gn_rowsh" .. i, base = { op = 0, wx = -60 }, ww = 46, strips = { 2, -math.tan(math.rad(25)) }, anims = {
            anim(d + 0.08, 0.38, bezier(0.3, 0.6, 0.4, 1), { { 0, { op = 1 } }, { 0.9, { op = 1 } }, { 1, { op = 0, wx = 640 } } }) } })
        add({ parent = id, art = "gn_rowlab" .. i })
        add({ parent = id, text = "v" .. i, x = 450 + (i - 1) * 6, y = 545 + (i - 1) * 38, size = 30, color = i == 1 and CY or GOLD, justify = "RIGHT",
            count = { d + 0.1, step = 0.07, pop = 0.2, dy = -4, br = 2.5, ease = bezier(0.2, 1.6, 0.4, 1) } })
    end
    for i, d in ipairs(G.segs or {}) do
        add({ parent = "panel", art = "gn_seg", static = translate((i - 1) * 34, 0), base = { col = hex("0e2a33") }, anims = {
            anim(d, 0.2, EASE_OUT, { { 0, { col = { 1, 1, 1 } } }, { 1, { col = CY } } }) } })
    end
    add({ parent = "panel", art = "gn_manahead", base = { op = 0 }, tf = { "t" }, anims = {
        anim(2.75, 0.55, LINEAR, { { 0, { op = 1, tx = 0 } }, { 0.95, { op = 1 } }, { 1, { op = 0, tx = 374 } } }, { nofill = true }) } })
    add({ parent = "panel", art = "gn_manaflash", base = { op = 0 }, anims = { anim(3.32, 0.3, EASE_OUT, { { 0, { op = 0.9 } }, { 1, { op = 0 } } }, { nofill = true }) } })

    -- +1 talent point: a holy sigil set in a cog (only when a talent point came)
    add({ id = "talent" })
    ring("talent", "gn_sring", G.sring, 2.86, 0.5, 1180, 92, 0.6, 2.1)
    add({ parent = "talent", art = "gn_srays", base = { op = 0 }, tf = { "s" }, o = { 1180, 92 }, anims = {
        anim(2.86, 0.4, EASE_OUT, { { 0, { op = 1, s = 0.7 } }, { 1, { op = 0, s = 1.4 } } }, { nofill = true }) } })
    add({ id = "sigil", parent = "talent", base = { op = 0, s = 2, r = -90 }, tf = { "s", "r" }, o = { 1180, 92 }, anims = {
        anim(2.7, 0.32, bezier(0.2, 1.4, 0.4, 1), { { 1, { op = 1, none = true } } }) } })
    add({ parent = "sigil", art = "gn_sigcog", tf = { "r" }, o = { 1180, 92 }, anims = { anim(3.1, 14, LINEAR, { { 0, { r = 0 } }, { 1, { r = 360 } } }, { loop = true }) } })
    add({ parent = "sigil", art = "gn_sigcore" })
    add({ parent = "talent", art = "gn_tlabel", base = { op = 0 }, anims = { anim(2.9, 0.2, EASE_OUT, { { 1, { op = 1 } } }) } })

    -- the hit's flash: the page's screen blend, as a multiply then an add (d + o*s*(1 - d))
    local FL = hex("a9fff2")
    add({ fill = { 1, 1, 1 }, rect = { -40, -40, 1360, 800 }, blend = "MOD", base = { op = 0 }, anims = {
        anim(1.6, 0.2, EASE_OUT, { { 0, { op = 1, col = { 1 - 0.85 * FL[1], 1 - 0.85 * FL[2], 1 - 0.85 * FL[3] } } }, { 1, { op = 1, col = { 1, 1, 1 } } } }, { nofill = true }) } })
    add({ fill = FL, rect = { -40, -40, 1360, 800 }, blend = "ADD", base = { op = 0 }, anims = {
        anim(1.6, 0.2, EASE_OUT, { { 0, { op = 0.85 } }, { 1, { op = 0 } } }, { nofill = true }) } })
    -- out of the dark
    add({ fill = { 0, 0, 0 }, rect = { -40, -40, 1360, 800 }, anims = { anim(0.1, 0.5, EASE_OUT, { { 1, { op = 0 } } }) } })
    add({ grain = "gn_grain" })
    -- the game's own sounds (picked by name, not heard yet): the holy precast as the Light winds up, a clank of Gnomeregan's
    -- machinery on each word and on the flip, a big holy impact on the hit, Divine Shield as the seal runs round
    local CLANK = 565464
    return { nodes = n, quakes = {}, hold = 7.5,
        sounds = { { 0.45, 568440, 1.15 }, { 0.62, CLANK, 0.35 }, { 0.92, CLANK, 0.35 }, { 1.22, CLANK, 0.35 }, { 1.6, 567966 }, { 1.7, 569738, 3 },
            { 2.2, CLANK, 0.35 } },
        flips = { static = "gn_dw", utop = "gn_dct", ubot = "gn_dwb", fa = "gn_fa", fb = "gn_fb" },
        rows = { "int", "spi", "sta", "power" }, sample = { 2, 3, 1, 31 } }
end
L.POSTERS = POSTERS
local ORDER = { "Human:PALADIN", "Human:WARRIOR", "Orc:WARRIOR", "Gnome:PRIEST" }

---------------------------------------------------------------------------------------------------------------------
-- building and drawing
local win, caption, built, current, t0, tl0, mode, closeAt = nil, nil, {}, nil, 0, 0, "preview", nil
local exitT0, cueNext = nil, 1

local function setTex(tx, file, wrap)
    if not pcall(tx.SetTexture, tx, DIR .. file, wrap or "CLAMP", wrap or "CLAMP") then tx:SetTexture(DIR .. file) end
end

local function build(key)
    local def = POSTERS[key]()
    local P = { key = key, def = def, nodes = def.nodes, byId = {} }
    P.root = CreateFrame("Frame", nil, win.stage)
    P.root:SetAllPoints(win.stage)
    local base = win.stage:GetFrameLevel() + 1
    local frame, used, level = nil, 99, base
    local function slot(fresh)
        if fresh or used >= 16 then
            frame = CreateFrame("Frame", nil, P.root)
            frame:SetAllPoints(P.root)
            frame:SetFrameLevel(level); level = level + 1
            used = 0
        end
        used = used + 1
        return frame, used - 9
    end
    local after = false
    for _, node in ipairs(P.nodes) do
        compile(node)
        if node.id then P.byId[node.id] = node end
        node.parentNode = node.parent and P.byId[node.parent]
        node.v = {}
        if node.art or node.digit or node.roman or node.sprite or node.fill or node.grain or node.flip then
            local f, sub = slot(after); after = false
            node.tx = f:CreateTexture(nil, "ARTWORK", nil, sub)
            if SIMPATCH then SIMPATCH(node.tx) end
            if node.blend and node.digit then pcall(node.tx.SetBlendMode, node.tx, node.blend) end
            if node.art then
                node.a = ART[node.art]
                setTex(node.tx, node.a and node.a[9] or node.art)
                if node.rect and node.a then
                    node.a = { node.rect[1], node.rect[2], node.rect[3], node.rect[4], node.a[5], node.a[6], node.a[7], node.a[8] }
                end
                if node.blend then pcall(node.tx.SetBlendMode, node.tx, node.blend) end
                local rowH = node.strips and node.strips[1] or (node.cclip and node.cclip[4])
                if rowH and node.a then
                    -- a slanted light sweep, or a picture clipped to a circle: the picture in rows, each row with its own window
                    node.stx = { node.tx }
                    pcall(node.tx.SetSnapToPixelGrid, node.tx, false); pcall(node.tx.SetTexelSnappingBias, node.tx, 0)
                    for i = 2, math.ceil(node.a[4] / rowH) do
                        local f2, sub2 = slot(false)
                        local t2 = f2:CreateTexture(nil, "ARTWORK", nil, sub2)
                        if SIMPATCH then SIMPATCH(t2) end
                        -- rows meet exactly where the game doesn't round them to whole pixels
                        pcall(t2.SetSnapToPixelGrid, t2, false); pcall(t2.SetTexelSnappingBias, t2, 0)
                        setTex(t2, node.a[9] or node.art)
                        node.stx[i] = t2
                    end
                end
                if node.bright and ART[node.bright] then
                    -- the same picture at CSS brightness(K), cross-faded in as the page's brightness filter rises
                    local f2, sub2 = slot(false)
                    node.btx = f2:CreateTexture(nil, "ARTWORK", nil, sub2)
                    if SIMPATCH then SIMPATCH(node.btx) end
                    node.ba = ART[node.bright]
                    setTex(node.btx, node.ba[9] or node.bright)
                end
                if node.mask and f.CreateMaskTexture then
                    -- the page clips the rays to the chevrons' slab; a mask does the same where the game has masks
                    local ok, m = pcall(f.CreateMaskTexture, f)
                    if ok and m then
                        pcall(m.SetTexture, m, DIR .. "war_raysmask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                        m:SetAllPoints(win.stage)
                        pcall(node.tx.AddMaskTexture, node.tx, m)
                    end
                end
            elseif node.sprite then
                setTex(node.tx, node.sprite)
                node.a = { node.rect[1], node.rect[2], node.rect[3], node.rect[4], 0, 0, 125 / 1024, 200 / 256 }
            elseif node.grain then
                setTex(node.tx, node.grain, "REPEAT")
                node.tx:SetAllPoints(win.stage)
                local g = ART[node.grain] or { 0, 0, 170.67, 170.67 }
                node.tx:SetTexCoord(0, 1280 / g[3], 0, 720 / g[4])
                pcall(node.tx.SetBlendMode, node.tx, "MOD")
            elseif node.fill then
                -- a plain colour, from a white picture with a clear rim, so it can turn with the shake like everything else
                setTex(node.tx, "lu_white")
                node.tx:SetVertexColor(node.fill[1], node.fill[2], node.fill[3])
                if node.blend then pcall(node.tx.SetBlendMode, node.tx, node.blend) end
                node.a = { node.rect[1], node.rect[2], node.rect[3], node.rect[4], 1.5 / 256, 1.5 / 256, 254.5 / 256, 254.5 / 256 }
            end
        elseif node.text then
            local f = slot(false)
            node.f = f
            node.fs = f:CreateFontString(nil, "OVERLAY")
            S.Persona.SetFont(node.fs, node.font or "Anton.ttf", node.size, node.flags)
            node.fs:SetTextColor(node.color[1], node.color[2], node.color[3])
            node.fs:SetJustifyH(node.justify or "LEFT")
            after = true -- whatever comes next draws above the words
        end
    end
    P.root:Hide()
    return P
end

-- tx, r0/r1 (a band of the picture's rows) and c0/c1 (a window) are given for one row of a slanted sweep
local function drawTex(node, M, op, tx, r0, r1, c0, c1)
    tx = tx or node.tx
    local a = node.a
    if not a or op <= 0.002 or node.hidden then tx:Hide(); return end
    local x, y, w, h, u0, v0, u1, v1 = a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]
    if node.frame then u0, u1 = node.frame * 125 / 1024, (node.frame + 1) * 125 / 1024 end
    if r0 then
        local n0, n1 = math.max(y, r0), math.min(y + h, r1)
        if n1 <= n0 then tx:Hide(); return end
        local dv = (v1 - v0) / h
        v0, v1 = v0 + (n0 - y) * dv, v0 + (n1 - y) * dv
        y, h = n0, n1 - n0
    end
    -- a window across the picture, in its own coordinates: fixed in its parent's (win, the picture slides under it) or
    -- sweeping (ww wide, at wx)
    if c0 then
    elseif node.win then c0, c1 = node.win[1] - (node.v.tx or 0), node.win[2] - (node.v.tx or 0)
    elseif node.ww then c0, c1 = node.v.wx or 0, (node.v.wx or 0) + node.ww end
    if c0 then
        local n0, n1 = math.max(x, c0), math.min(x + w, c1)
        if n1 <= n0 then tx:Hide(); return end
        local du = (u1 - u0) / w
        u0, u1 = u0 + (n0 - x) * du, u0 + (n1 - x) * du
        x, w = n0, n1 - n0
    end
    local clip = node.v.clip
    if clip then
        if clip <= 0.002 then tx:Hide(); return end
        w = w * math.min(1, clip); u1 = u0 + (u1 - u0) * math.min(1, clip)
    end
    -- one piece of a line that draws itself: shown once the line has run past its start, cropped at the moving end
    -- (seg = { index, from, to, axis 1 = x / 2 = y, near edge, far edge })
    -- a line's whole picture takes over from its pieces once it has drawn
    if node.whole and (node.v.dr or 0) < 1 then tx:Hide(); return end
    local seg = node.seg
    if seg and (node.v.dr or 0) >= 1 then tx:Hide(); return end
    if seg then
        local q = ((node.v.dr or 0) - seg[2]) / (seg[3] - seg[2])
        if q <= 0 then tx:Hide(); return end
        if q < 1 then
            local cut = seg[5] + (seg[6] - seg[5]) * q
            local fwd = seg[6] >= seg[5]
            if seg[4] == 1 then
                local du = (u1 - u0) / w
                if fwd then
                    local n1 = math.min(x + w, cut)
                    if n1 <= x then tx:Hide(); return end
                    u1 = u0 + (n1 - x) * du; w = n1 - x
                else
                    local n0 = math.max(x, cut)
                    if n0 >= x + w then tx:Hide(); return end
                    u0 = u0 + (n0 - x) * du; w = x + w - n0; x = n0
                end
            else
                local dv = (v1 - v0) / h
                if fwd then
                    local n1 = math.min(y + h, cut)
                    if n1 <= y then tx:Hide(); return end
                    v1 = v0 + (n1 - y) * dv; h = n1 - y
                else
                    local n0 = math.max(y, cut)
                    if n0 >= y + h then tx:Hide(); return end
                    v0 = v0 + (n0 - y) * dv; h = y + h - n0; y = n0
                end
            end
        end
    end
    tx:Show()
    tx:SetAlpha(math.min(1, op))
    local col = node.v.col
    if col then tx:SetVertexColor(col[1], col[2], col[3]) end
    tx:ClearAllPoints()
    local ma, mb, mc, md, me, mf = M[1], M[2], M[3], M[4], M[5], M[6]
    if math.abs(mb) < 1e-6 and math.abs(mc) < 1e-6 and ma > 0 and md > 0 then
        -- only moved or scaled: a plain rectangle
        local rw, rh = w * ma, h * md
        if rw < 0.05 or rh < 0.05 then tx:Hide(); return end
        tx:SetPoint("TOPLEFT", win.stage, "TOPLEFT", ma * x + me, -(md * y + mf))
        tx:SetSize(rw, rh)
        tx:SetTexCoord(u0, u1, v0, v1)
        return
    end
    -- turned or skewed: draw the box around the turned picture and map each of its corners back into the picture
    local det = ma * md - mb * mc
    if math.abs(det) < 1e-9 then tx:Hide(); return end
    local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
    for _, c in ipairs({ { x, y }, { x + w, y }, { x, y + h }, { x + w, y + h } }) do
        local qx, qy = ma * c[1] + mc * c[2] + me, mb * c[1] + md * c[2] + mf
        if qx < minx then minx = qx end
        if qx > maxx then maxx = qx end
        if qy < miny then miny = qy end
        if qy > maxy then maxy = qy end
    end
    local function uv(qx, qy)
        local dx, dy = qx - me, qy - mf
        local px, py = (md * dx - mc * dy) / det, (-mb * dx + ma * dy) / det
        return u0 + (px - x) / w * (u1 - u0), v0 + (py - y) / h * (v1 - v0)
    end
    local ulx, uly = uv(minx, miny)
    local llx, lly = uv(minx, maxy)
    local urx, ury = uv(maxx, miny)
    local lrx, lry = uv(maxx, maxy)
    tx:SetPoint("TOPLEFT", win.stage, "TOPLEFT", minx, -miny)
    tx:SetSize(maxx - minx, maxy - miny)
    tx:SetTexCoord(ulx, uly, llx, lly, urx, ury, lrx, lry)
end

-- a slanted sweep (strips = { row height, slant }): each band of rows gets the window shifted by the slant at its middle,
-- as the page's skewX about the poster's top edge does
local function drawNode(node, M, op)
    if node.btx then
        -- CSS brightness(b): b above 1 cross-fades to the picture made at brightness(K) (drawn on top, so the two add up
        -- to the page's opacity); below 1 (an overshoot) it darkens
        local b, K = node.v.br or 1, node.brightK or 3
        local w = math.max(0, math.min(1, (b - 1) / (K - 1)))
        local dim = math.min(1, b)
        node.tx:SetVertexColor(dim, dim, dim)
        if w <= 0.001 then node.btx:Hide(); return drawTex(node, M, op) end
        local ob = op * w
        drawTex(node, M, ob >= 0.999 and 0 or op * (1 - w) / (1 - ob))
        local a = node.a
        node.a = node.ba
        drawTex(node, M, ob, node.btx)
        node.a = a
        return
    end
    if not node.stx then return drawTex(node, M, op) end
    if node.cclip then
        -- clipped to a circle in the parent's frame (the page's clip-path on the shield): each row of the picture cropped
        -- to the circle's chord at the row's far edge (the narrower one), so nothing shows outside it
        local a, cc, lm = node.a, node.cclip, node.lm
        if not a or op <= 0.002 or node.hidden then for _, t in ipairs(node.stx) do t:Hide() end return end
        local x, y, w, h = a[1], a[2], a[3], a[4]
        local R2 = cc[3] * cc[3]
        local inside = true
        for _, c in ipairs({ { x, y }, { x + w, y }, { x, y + h }, { x + w, y + h } }) do
            local px, py = lm[1] * c[1] + lm[3] * c[2] + lm[5] - cc[1], lm[2] * c[1] + lm[4] * c[2] + lm[6] - cc[2]
            if px * px + py * py > R2 then inside = false break end
        end
        if inside then
            for i = 2, #node.stx do node.stx[i]:Hide() end
            return drawTex(node, M, op, node.stx[1])
        end
        for i, t in ipairs(node.stx) do
            local r0 = y + (i - 1) * cc[4]
            local r1 = math.min(y + h, r0 + cc[4])
            local d0, d1 = lm[4] * r0 + lm[6] - cc[2], lm[4] * r1 + lm[6] - cc[2]
            local hh = R2 - math.max(d0 * d0, d1 * d1)
            if r1 <= r0 or hh <= 0 then t:Hide()
            else
                hh = math.sqrt(hh)
                local ym = (r0 + r1) / 2
                local c0 = (cc[1] - hh - lm[3] * ym - lm[5]) / lm[1]
                local c1 = (cc[1] + hh - lm[3] * ym - lm[5]) / lm[1]
                drawTex(node, M, op, t, r0, r1, c0, c1)
            end
        end
        return
    end
    local a, st, wx = node.a, node.strips, node.v.wx or 0
    for i, t in ipairs(node.stx) do
        local r0 = a[2] + (i - 1) * st[1]
        local c0 = wx + st[2] * (r0 + st[1] / 2)
        drawTex(node, M, op, t, r0, r0 + st[1], c0, c0 + node.ww)
    end
end

-- the words are placed by their baseline, as on the page; measured in game (Nick's screenshot, 0.73.0): the game puts
-- Anton's baseline 0.778 of the size below the string's top (the font's own ascent says 1.176)
local ASCENT = 0.778

local POP = bezier(0, 0, 0.58, 1)
local function frameAt(P, t, tl, te)
    -- the hits shake the poster: the page's quake keyframes, moving and turning everything inside the poster's frame
    -- (as the page's .quake inside its clipped stage): given as { at, dur, x1, y1, ... } (four even steps) or
    -- { at, dur, keys = { { pct, x, y[, turn] }, ... } }
    local qx, qy, qr = 0, 0, 0
    for _, q in ipairs(P.def.quakes) do
        local p = (t - q[1]) / q[2]
        if p >= 0 and p < 1 then
            local keys = q.keys
            if not keys then
                keys = { { 0, 0, 0 }, { 0.2, -q[3], q[4] }, { 0.4, q[5], -q[6] }, { 0.6, -q[7], q[8] }, { 0.8, q[9], -q[10] }, { 1, 0, 0 } }
                q.keys = keys
            end
            local i = 1
            while i < #keys - 1 and p > keys[i + 1][1] do i = i + 1 end
            local k0, k1 = keys[i], keys[i + 1]
            local u = (p - k0[1]) / (k1[1] - k0[1])
            qx = k0[2] + (k1[2] - k0[2]) * u
            qy = k0[3] + (k1[3] - k0[3]) * u
            qr = (k0[4] or 0) + ((k1[4] or 0) - (k0[4] or 0)) * u
        end
    end
    local Q = (qx ~= 0 or qy ~= 0 or qr ~= 0) and mul(translate(qx, qy), about(rotate(qr), 640, 360)) or nil
    for _, node in ipairs(P.nodes) do
        local v = evaluate(node, t, tl, node.v, te)
        local m = localMatrix(node, v)
        node.lm = m
        local par = node.parentNode
        node.M = par and mul(par.M, m) or (Q and mul(Q, m) or m)
        node.op = (par and par.op or 1) * (v.op or 1)
        if node.hidden then node.op = 0 end
        if node.sprite then node.frame = math.floor((tl % 0.72) / 0.09) % 8 end
        if node.tx and not node.grain then
            drawNode(node, node.M, node.op)
        elseif node.fs then
            local M = node.M
            local top = node.y - ASCENT * node.size
            local ax, ay = M[1] * node.x + M[3] * top + M[5], M[2] * node.x + M[4] * top + M[6]
            local alpha = math.max(0, math.min(1, node.op))
            if node.chars then
                -- letter-spaced, as on the page: one string per letter
                local run = 0
                for _, c in ipairs(node.chars) do
                    if c:IsShown() then
                        c:ClearAllPoints()
                        c:SetPoint("TOPLEFT", win.stage, "TOPLEFT", ax + run * M[1], -ay)
                        c:SetAlpha(alpha)
                        run = run + (c.space or c:GetStringWidth() or 0) + node.spacing
                    end
                end
            else
                local dy, br = 0, v.br or 1
                if node.count and node.count.step and node.steps then
                    -- the page's count: each step shown for one beat, the last pops (up, bright) as it lands
                    local c, st = node.count, node.steps
                    local k = math.floor((t - c[1]) / c.step)
                    local txt = ""
                    if k >= #st - 1 then
                        txt = st[#st]
                        local u = (t - c[1] - (#st - 1) * c.step) / c.pop
                        if u < 1 then
                            local e = c.ease(math.max(0, u))
                            dy, br = c.dy * (1 - e), c.br + (1 - c.br) * e
                        end
                    elseif k >= 0 then txt = st[k + 1] end
                    txt = txt == "" and "" or ((txt >= 0 and "+" or "") .. txt)
                    if txt ~= node.shown then node.shown = txt; node.fs:SetText(txt) end
                elseif node.count and node.target then
                    -- the stat counts up from +0 in twelve steps, then pops as it lands (the page's count-up)
                    local c = node.count
                    local k = math.max(0, math.min(12, math.floor((t - c[1]) / (c[2] / 12))))
                    local val = math.floor(node.target * k / 12 + 0.5)
                    if val ~= node.shown then node.shown = val; node.fs:SetText((val >= 0 and "+" or "") .. val) end
                    local u = (t - c[1] - c[2]) / 0.22
                    local sc = (u >= 0 and u < 1) and (1.45 - 0.45 * POP(u)) or 1
                    if sc ~= node.scale and node.fs.SetTextScale then node.scale = sc; pcall(node.fs.SetTextScale, node.fs, sc) end
                end
                node.fs:ClearAllPoints()
                node.fs:SetPoint(node.justify == "RIGHT" and "TOPRIGHT" or "TOPLEFT", win.stage, "TOPLEFT", ax + M[3] * dy, -(ay + M[4] * dy))
                node.fs:SetAlpha(alpha)
                if br ~= node.br then
                    node.br = br
                    local c = node.color
                    node.fs:SetTextColor(math.min(1, c[1] * br), math.min(1, c[2] * br), math.min(1, c[3] * br))
                end
            end
        end
    end
    return 0, 0, qx, qy, qr
end
L.frameAt = frameAt

-- the level, in the poster's own digit pictures, spaced by Anton's advances along the poster's tilt
local function toRoman(n)
    local out = ""
    for _, p in ipairs({ { 50, "L" }, { 40, "XL" }, { 10, "X" }, { 9, "IX" }, { 5, "V" }, { 4, "IV" }, { 1, "I" } }) do
        while n >= p[1] do out = out .. p[2]; n = n - p[1] end
    end
    return out
end
L.toRoman = toRoman

-- the level in Roman numerals from one picture per letter: "start" sets run from where the first letter starts,
-- "middle" centres the word (as the page's text-anchor does); along the poster's tilt
local function setRoman(P, level)
    local cfgs = P.def.romans
    if not cfgs then return end
    local s = toRoman(math.max(1, level))
    local adv = EXTRA.pkRomanAdvance or {}
    for _, node in ipairs(P.nodes) do
        local cfg = node.roman and cfgs[node.roman]
        if cfg then
            local i = node.rslot
            if i <= #s then
                local total, run = 0, 0
                for j = 1, #s do
                    local a = (adv[s:sub(j, j)] or 0.6) * cfg.size + (cfg.spacing or 0)
                    if j < i then run = run + a end
                    total = total + a
                end
                local ch = s:sub(i, i)
                local a = (adv[ch] or 0.6) * cfg.size + (cfg.spacing or 0)
                local shift = cfg.anchor == "middle" and (run + a / 2 - total / 2) or run
                local c, sn = math.cos(math.rad(cfg.angle or 0)), math.sin(math.rad(cfg.angle or 0))
                setTex(node.tx, cfg.prefix .. ch)
                node.a = ART[cfg.prefix .. ch]
                node.static = translate(shift * c, shift * sn)
                node.hidden = nil
            else
                node.hidden = true
            end
        end
    end
end

-- the flip clock (the gnome's odometer): two slots, tens and ones, each showing the old level's digit flipping over to the
-- new one only where it changes; a missing tens digit is a blank card
local function setFlips(P, level)
    local F = P.def.flips
    if not F then return end
    local function slots(lv)
        local s = tostring(math.max(0, lv))
        return #s >= 2 and s:sub(-2, -2) or "", s:sub(-1)
    end
    local o1, o2 = slots(level - 1)
    local n1, n2 = slots(level)
    for _, node in ipairs(P.nodes) do
        if node.flip then
            local od, nd = node.flip[1] == 1 and o1 or o2, node.flip[1] == 1 and n1 or n2
            local changed, part, art = od ~= nd, node.flip[2], nil
            if part == "static" then art = (not changed and nd ~= "") and (F.static .. nd) or nil
            elseif part == "utop" then art = (changed and nd ~= "") and (F.utop .. nd) or nil
            elseif part == "ubot" then art = (changed and od ~= "") and (F.ubot .. od) or nil
            elseif part == "fa" then art = changed and (F.fa .. (od ~= "" and od or "_")) or nil
            elseif part == "fb" then art = changed and (F.fb .. (nd ~= "" and nd or "_")) or nil end
            if art and ART[art] then
                node.a = ART[art]
                setTex(node.tx, node.a[9] or art)
                node.hidden = nil
            else
                node.hidden = true
            end
        end
    end
end

local function setLevel(P, level)
    setRoman(P, level)
    setFlips(P, level)
    local d = P.def.digits
    if not d then return end
    local c, sn = math.cos(math.rad(d.angle)), math.sin(math.rad(d.angle))
    local layout = {}
    local function place(lv)
        if layout[lv] then return layout[lv] end
        local s = tostring(math.max(0, lv))
        local adv, total, out, run = {}, 0, {}, 0
        for i = 1, #s do
            adv[i] = (EXTRA.digitAdvance and EXTRA.digitAdvance[tonumber(s:sub(i, i)) + 1] or 0.49) * d.size
            total = total + adv[i]
        end
        for i = 1, #s do
            out[i] = { ch = s:sub(i, i), shift = run + adv[i] / 2 - total / 2 }
            run = run + adv[i]
        end
        layout[lv] = out
        return out
    end
    for _, node in ipairs(P.nodes) do
        if node.digit then
            local slot = node.dslot or (node.id == "d2" and 2 or 1)
            local spot = place(node.dset == "old" and level - 1 or level)[slot]
            if spot then
                local art = node.digit .. spot.ch
                setTex(node.tx, art)
                local a = ART[art]
                node.a = a
                node.static = translate(spot.shift * c, spot.shift * sn)
                if node.dx then node.static = mul(translate(node.dx, node.dy or 0), node.static) end
                node.hidden = nil
            else
                node.hidden = true
            end
        end
    end
end

local function makeWindow()
    win = CreateFrame("Frame", "StewardLevelUp", UIParent)
    win:SetAllPoints(UIParent)
    win:SetFrameStrata("FULLSCREEN_DIALOG")
    win:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "StewardLevelUp") end -- Esc closes it
    local dim = win:CreateTexture(nil, "BACKGROUND")
    dim:SetAllPoints()
    dim:SetColorTexture(0, 0, 0, 0.88)
    win.stage = CreateFrame("Frame", nil, win)
    win.stage:SetSize(1280, 720)
    win.stage:SetPoint("CENTER")
    if win.stage.SetClipsChildren then win.stage:SetClipsChildren(true) end
    local black = win.stage:CreateTexture(nil, "BACKGROUND")
    black:SetAllPoints()
    black:SetColorTexture(0, 0, 0, 1)
    caption = win:CreateFontString(nil, "OVERLAY")
    S.Persona.SetFont(caption, "InterBold.ttf", 12)
    caption:SetTextColor(0.6, 0.64, 0.77)
    caption:SetPoint("BOTTOM", win, "BOTTOM", 0, 14)
    win:SetScript("OnShow", function()
        win.stage:SetScale(math.min(UIParent:GetWidth() / 1280, UIParent:GetHeight() / 720) * 0.96)
    end)
    win:SetScript("OnUpdate", function()
        if not current then return end
        local now = GetTime()
        local t = now - t0
        local ex = current.def.exit
        if closeAt and ex and not exitT0 and now >= closeAt - ex then exitT0 = now end
        local qx, qy = frameAt(current, t, now - tl0, exitT0 and now - exitT0 or nil)
        win.stage:ClearAllPoints()
        win.stage:SetPoint("CENTER", win, "CENTER", qx, -qy)
        -- the poster's sound cues: { at, file id, stop after (seconds) }
        local cues = current.def.sounds
        while cues and cues[cueNext] and t >= cues[cueNext][1] do
            local c = cues[cueNext]
            cueNext = cueNext + 1
            if t - c[1] < 0.25 and PlaySoundFile and S:Get("levelupSound") ~= false then
                local ok, will, handle = pcall(PlaySoundFile, c[2], "SFX")
                if ok and will and handle and c[3] and StopSound and C_Timer then C_Timer.After(c[3], function() pcall(StopSound, handle, 250) end) end
            end
        end
        if closeAt then
            local left = closeAt - now
            if left <= 0 then win:Hide(); closeAt = nil
            elseif not ex and left < 0.5 then win:SetAlpha(left / 0.5)
            elseif ex and left < 0.15 then win:SetAlpha(left / 0.15) end
        end
    end)
    win:SetScript("OnMouseUp", function(_, button)
        if mode ~= "preview" then return end
        if button == "RightButton" then
            local i = 1
            for k, v in ipairs(ORDER) do if v == current.key then i = k end end
            local key = ORDER[i % #ORDER + 1]
            local data = {}
            for k, v in pairs(L.lastData or {}) do data[k] = v end
            if L.previewSample then data.values = POSTERS[key]().sample end -- each poster's own sample numbers
            L.Show(key, data)
        else
            L.Play()
        end
    end)
    win:SetScript("OnHide", function() closeAt = nil; exitT0 = nil; win:SetAlpha(1) end)
end

function L.Play()
    t0 = GetTime()
    cueNext, exitT0 = 1, nil
end
function L.Current() return current end

-- letter-spaced words, as the page sets them: one string per letter (a space is the font's own space width)
local SPACE = { ["Anton.ttf"] = 0.234, ["Cinzel.ttf"] = 0.25 }
local function setSpaced(node, str)
    if not node.spacing then node.fs:SetText(str); return end
    node.fs:SetText("")
    node.chars = node.chars or {}
    local i = 0
    for ch in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        i = i + 1
        local c = node.chars[i]
        if not c then
            c = node.f:CreateFontString(nil, "OVERLAY")
            S.Persona.SetFont(c, node.font or "Anton.ttf", node.size, node.flags)
            c:SetTextColor(node.color[1], node.color[2], node.color[3])
            node.chars[i] = c
        end
        c.space = ch == " " and (SPACE[node.font or "Anton.ttf"] or 0.25) * node.size or nil
        c:SetText(c.space and "" or ch); c:Show()
    end
    for j = i + 1, #node.chars do node.chars[j]:SetText(""); node.chars[j]:Hide() end
end

-- a line of type from letter pictures (the page's letter-spaced words), laid along its frame from the pen at (x, y)
local function setRun(P, id, str)
    local run = P.def.runs and P.def.runs[id]
    local G = run and run.glyphs
    if not G then return end
    if not G.map then G.map = {} for _, g in ipairs(G.list) do G.map[g[1]] = g end end
    local slots = {}
    for _, node in ipairs(P.nodes) do if node.run == id then slots[node.ri] = node end end
    local pen, i = 0, 0
    for ch in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        local g = G.map[ch]
        if g and g[7] > 0 then
            i = i + 1
            local node = slots[i]
            if node then
                local art = "orc_g" .. g[7]
                local A = ART[art]
                node.a = { run.x + pen + g[2], run.y + g[3], g[4], g[5], A[5], A[6], A[7], A[8] }
                if node.art ~= art then node.art = art; setTex(node.tx, A[9] or art) end
                node.hidden = nil
            end
        end
        pen = pen + (g and g[6] or G.space) + (run.spacing or 0)
    end
    for j = i + 1, #slots do slots[j].hidden = true end
end

-- data: { name, level, values = { 4 numbers }, talent = true/false }
function L.Show(key, data)
    if not POSTERS[key] then return false end
    if not win then makeWindow() end
    if not built[key] then built[key] = build(key) end
    if current and current ~= built[key] then current.root:Hide() end
    current = built[key]
    current.root:Show()
    L.lastData = data
    for _, node in ipairs(current.nodes) do
        if node.text == "name" then
            setSpaced(node, (data.name or ""):upper())
        elseif node.ranks then
            local i = current.def.rank and select(2, current.def.rank(data.level or 1))
            local art = node.ranks .. (i or 1)
            if ART[art] and art ~= node.art then node.art, node.a = art, ART[art]; setTex(node.tx, node.a[9] or art) end
        elseif node.text and node.text:sub(1, 1) == "v" then
            local v = data.values and data.values[tonumber(node.text:sub(2))]
            node.fs:SetText(v and ((v >= 0 and "+" or "") .. v) or "")
            node.target, node.shown, node.scale = v, nil, nil
            if node.count and node.count.step and v then
                -- the page counts +0, +1, ... for small gains; a big one in quarters
                local st = {}
                if v <= 4 then for i = 0, math.max(0, v) do st[#st + 1] = i end
                else st = { 0, math.floor(v / 4 + 0.5), math.floor(v / 2), math.floor(3 * v / 4 + 0.5), v } end
                node.steps = st
                node.fs:SetText("")
            end
        end
    end
    for id, run in pairs(current.def.runs or {}) do setRun(current, id, run.text((data.name or ""):upper())) end
    setLevel(current, data.level or 1)
    for _, id in ipairs({ "talent", "talent2" }) do
        local node = current.byId[id]
        if node then node.hidden = not data.talent or nil end
    end
    if tl0 == 0 then tl0 = GetTime() end
    win:SetAlpha(1)
    win:Show()
    L.Play()
    return true
end

local function myKey()
    local _, race = UnitRace("player")
    local _, class = UnitClass("player")
    return (race or "") .. ":" .. (class or "")
end
L.MyKey = myKey

-- the four numbers a poster's rows show, from the level-up's gains
local function values(P, g)
    local out = {}
    for i, k in ipairs(P.rows) do out[i] = g[k] end
    return out
end

function L.Preview()
    local key = POSTERS[myKey()] and myKey() or ORDER[1]
    local def = POSTERS[key]()
    local last = StewardDB and StewardDB.lastLevelUp
    local g = (last and last.key == key) and last.gains or nil
    mode = "preview"
    closeAt = nil
    L.previewSample = not g
    local ok = L.Show(key, { name = UnitName("player"), level = (last and last.key == key and last.level) or UnitLevel("player") or 1,
        values = g and values(def, g) or def.sample, talent = (UnitLevel("player") or 1) >= 10 })
    if ok and win then
        win:EnableMouse(true)
        caption:SetText("Preview" .. (g and " (your last level-up)" or " (sample numbers)") ..
            "      Left-click: replay      Right-click: next poster      Esc: close")
    end
end

-- the real thing: when you level up, after any fight is over
local pending
local function showReal()
    local p = pending; pending = nil
    if not p then return end
    mode = "real"
    if L.Show(p.key, p.data) then
        win:EnableMouse(false) -- never in the way: the game goes on under it, and it closes itself
        caption:SetText("")
        closeAt = GetTime() + (current.def.hold or 6.5)
    end
end

S:On("PLAYER_LEVEL_UP", function(level, hp, power, talents, _, str, agi, sta, int, spi)
    local key = myKey()
    local gains = { hp = hp, power = power, str = str, agi = agi, sta = sta, int = int, spi = spi }
    if StewardDB then StewardDB.lastLevelUp = { key = key, level = level, gains = gains } end
    if not POSTERS[key] or (S.Get and S:Get("levelupPoster") == false) then return end
    local def = POSTERS[key]()
    pending = { key = key, data = { name = UnitName("player"), level = level, values = values(def, gains), talent = (talents or 0) > 0 } }
    if InCombatLockdown() or (UnitAffectingCombat and UnitAffectingCombat("player")) then return end
    C_Timer.After(0.3, showReal)
end)
S:On("PLAYER_REGEN_ENABLED", function() if pending then C_Timer.After(0.5, showReal) end end)
