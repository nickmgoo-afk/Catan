local _, S = ...

-- The travel path: a line on the world map and a dotted trail on the minimap, from where you stand
-- to where the arrow points, going round what cannot be walked.
--
-- This is a drawing and nothing else. It reads where the arrow points (G.activeGoto) and where you
-- are; it never calls the guide, the router or the waypoint code, and never writes to their state.
-- Turning it on or off cannot change what the guide tells you to do.
--
-- Where there is terrain (PathTerrain.lua, made from the game's own terrain tiles) the search runs on
-- its squares: a step from one square to the next is taken only where the ground between them can be
-- walked. On top of that come
--   roads      Steward's own (S.PathRoads, PathRoads.lua: roads, bridges and tunnels for Kalimdor, the Eastern Kingdoms and Zephras Isle). No other add-on is read.
--   footsteps  the ground you have walked yourself, remembered across characters
-- Both count as walkable whatever the terrain says (a bridge, a tunnel, a ramp inside a building),
-- and are cheaper to follow. Where no way can be found on walkable ground the missing piece is drawn
-- faint: a guess, not a route.
--
-- Where there is no terrain for a continent the older search runs instead: it knows only roads,
-- footsteps and the spots where the game puts something to walk up to (PathData.lua), and charges
-- more the further the path strays from all of those.
--
-- Two ways to choose the line (setting "pathRoute", switched on the world map, beside the guide's header
-- or in the options): "fastest", the shortest way there, and "roads", which keeps to roads, bridges and
-- tunnels wherever they lead there, a good deal longer if need be (safer where the monsters are high).

local G = S.G
local P = {}
S.Path = P
S.defaults.pathShow = true
S.defaults.pathRoute = "fastest"
S.defaults.pathMapSwitch = "box"   -- how the switch looks on the world map: "box" (both words) or "round" (a button like the map's pin)

local floor, ceil, sqrt, abs, min, max, huge = math.floor, math.ceil, math.sqrt, math.abs, math.min, math.max, math.huge
local byte, char, rep, concat = string.byte, string.char, string.rep, table.concat

---------------------------------------------------------------- settings of the search
-- what a yard of road and a yard of ground you have walked cost, against 1 for a yard of easy ground
P.ROUTES = {
    -- the shortest way: a road is taken where it is on the way (up to 3% longer, so the line keeps to a road
    -- that runs the same way instead of beside it)
    fastest = { road = 0.97, walked = 0.97 },
    -- roads wherever they lead there: a road up to two and a half times as long as the way across open ground
    roads = { road = 0.4, walked = 1 },
}
P.ROUTE_ORDER = { "fastest", "roads" }
P.WATER = 2.2        -- a yard of swimming (slow on foot, far slower than riding round)
P.MIN_DIST = 40      -- closer than this: no path, the arrow is enough
P.STRAY = 45         -- further than this from the path: plan again
P.CLEAR_FROM = 3     -- further than this from the path, the straight piece to it is checked: a wall or a cliff across it -> plan again
P.SLICE_MS = 2       -- time per frame the search may use
P.SLICE_UNITS = 6000 -- and the most work per frame when there is no clock
-- with terrain
P.NEAR = 1.2         -- a yard of tight or sloping ground (beside or partly on ground too steep to walk)
P.ROUGH = 3          -- a yard of steep climb: it can be walked, but only when the way round is far longer
P.CLIMB_RUN = 5      -- more squares of steep climb in a row than this: that stretch is drawn as a guess
P.LOW = 4            -- a yard across closed ground right around a start or a goal that is walled in
P.MID = 10           -- a yard across closed ground once it is certain there is no open way
P.POPS_BASE = 3000   -- squares the first, direct search for an open way may visit ...
P.POPS_PER = 15      -- ... plus this many for every square of distance ...
P.POPS = 20000       -- ... and never more than this
P.POPS2 = 30000      -- squares the search that may cross closed ground may visit
P.WEIGHT = 1.2       -- how hard the direct search pulls towards the goal on a long trip (1 = shortest way, slowest)
P.WEIGHT_FROM = 800  -- yards from which a trip counts as long; shorter ones get the shortest way exactly
P.WEIGHT_IN = 1.1    -- the same inside a corridor that is known to lead there
P.WEIGHT_GUESS = 3   -- and for the search that may cross closed ground
P.POCKET = 1500      -- an end with fewer squares than this in reach is walled in
P.BREAKOUT = 5000    -- how far to look for the way out of a walled-in end, in squares
P.SLACK = 1.03       -- a straightened piece may cost this much more than the squares it replaces ...
P.SLACK_YD = 10      -- ... plus this many yards
-- without terrain
P.CELL = 16          -- yards per grid square (doubles for long trips)
P.MAX_CELLS = 48000  -- grid squares in one search
P.FREE = 28          -- yards from known ground that cost nothing extra
P.SCALE = 50         -- how fast the cost rises beyond that
P.CAP = 7            -- the most a yard of unknown ground can cost

local clock = debugprofilestop

-- how the line is chosen now: "fastest" or "roads"
function P.Route()
    local r = S:Get("pathRoute")
    if P.ROUTES[r] then return r end
    return "fastest"
end

---------------------------------------------------------------- quiet failure
-- Any error switches the layer off for the session and leaves a note in the saved data. It never
-- reaches the error handler: a drawing aid must not interrupt play.
local broken = false
local function diag()
    if not StewardDB then return {} end
    StewardDB.pathDiag = StewardDB.pathDiag or {}
    return StewardDB.pathDiag
end
local hideAll
local function fail(where, err)
    broken = true
    local d = diag()
    d.err = tostring(where) .. ": " .. tostring(err)
    d.errVersion = S.version
    if hideAll then pcall(hideAll) end
end
local function guard(where, fn, ...)
    if broken then return end
    local ok, err = pcall(fn, ...)
    if not ok then fail(where, err) end
end
function P.Broken() return broken end

---------------------------------------------------------------- maps: zone-map position -> world
local Vec = CreateVector2D
local zoneCache = {}
-- { inst, ox, oy, ax, ay, bx, by, x0, x1, y0, y1 }: world = o + u*a + v*b; false when the map has no world position
local function zoneInfo(mapID)
    local z = zoneCache[mapID]
    if z ~= nil then return z end
    z = false
    if C_Map and C_Map.GetWorldPosFromMapPos then
        local inst, o = C_Map.GetWorldPosFromMapPos(mapID, Vec(0, 0))
        local _, u = C_Map.GetWorldPosFromMapPos(mapID, Vec(1, 0))
        local _, v = C_Map.GetWorldPosFromMapPos(mapID, Vec(0, 1))
        if inst and o and u and v and not S.Secret(inst, o.x, o.y, u.x, u.y, v.x, v.y) then
            local ax, ay, bx, by = u.x - o.x, u.y - o.y, v.x - o.x, v.y - o.y
            if ax * by - bx * ay ~= 0 then
                local cx, cy = o.x + ax + bx, o.y + ay + by
                z = { inst = inst, ox = o.x, oy = o.y, ax = ax, ay = ay, bx = bx, by = by,
                    x0 = min(o.x, u.x, v.x, cx), x1 = max(o.x, u.x, v.x, cx),
                    y0 = min(o.y, u.y, v.y, cy), y1 = max(o.y, u.y, v.y, cy) }
            end
        end
    end
    zoneCache[mapID] = z
    return z
end
P.ZoneInfo = zoneInfo

---------------------------------------------------------------- slices
local units, sliceStart = 0, 0
local solving = setmetatable({}, { __mode = "k" })   -- the coroutines searches run in: only there may work wait a frame
P.Solving = solving   -- the 3D search runs its own coroutine inside a search: it adds it here
local function tick(n)
    -- called from outside a search (cave floors, the trip planner, under pcall in a timer): never pause
    local co = coroutine.running()
    if not (co and solving[co]) then return end
    n = n or 1
    units = units + n
    if clock then
        -- look at the clock every 64 units or so
        if units % 64 < n and clock() - sliceStart > P.SLICE_MS then coroutine.yield() end
    elseif units >= P.SLICE_UNITS then
        coroutine.yield()
    end
end

---------------------------------------------------------------- footsteps
-- The ground you have walked, on the same squares as the terrain (25/3 yards, counted from the world's
-- origin; north and west as the game counts them). Three bits a square: 1 you stood on it, 2 you walked
-- from it on to the square north of it, 4 on to the square west of it. Eight squares (2 rows x 4
-- columns) to a number. Walking from one square to the next is the proof that the border between them
-- can be crossed; standing on both sides of a cliff on different days is not.
local CS, OFFC = 25 / 3, 4096
local function walkedTable(inst, create)
    if not StewardDB then return nil end
    if StewardDB.walked then StewardDB.walked = nil end -- the first version's coarser record: no longer read
    local w = StewardDB.walked2
    if not w then
        if not create then return nil end
        w = { n = 0 }
        StewardDB.walked2 = w
    end
    local t = w[inst]
    if not t and create then t = {} w[inst] = t end
    return t
end

local function setBits(inst, fr, fc, bits)
    if fr < 0 or fc < 0 or fr >= 8192 or fc >= 8192 then return false end
    local t = walkedTable(inst, true)
    if not t then return false end
    local key = floor(fr / 2) * 4096 + floor(fc / 4)
    local shift = 8 ^ ((fr % 2) * 4 + fc % 4)
    local v = t[key] or 0
    local cur = floor(v / shift) % 8
    local add = 0
    if bits % 2 == 1 and cur % 2 == 0 then add = add + 1 end
    if floor(bits / 2) % 2 == 1 and floor(cur / 2) % 2 == 0 then add = add + 2 end
    if bits >= 4 and cur < 4 then add = add + 4 end
    if add == 0 then return false end
    if v == 0 then
        local w = StewardDB.walked2
        if (w.n or 0) >= 60000 then return false end -- plenty for every zone; keeps the saved file small
        w.n = (w.n or 0) + 1
    end
    t[key] = v + add * shift
    return true
end

-- every square a straight piece passes through, in order: visit(r, c) for the first, then
-- step(r1, c1, r2, c2) for each move to a neighbour (never diagonal)
local function trace(fr, fc, er, ec, visit, step)
    local r, c = floor(fr), floor(fc)
    local r2, c2 = floor(er), floor(ec)
    visit(r, c)
    local dr, dc = er - fr, ec - fc
    local stepR, stepC = dr > 0 and 1 or -1, dc > 0 and 1 or -1
    local tDR, tDC = dr ~= 0 and abs(1 / dr) or huge, dc ~= 0 and abs(1 / dc) or huge
    local tMR = dr > 0 and (r + 1 - fr) / dr or (dr < 0 and (r - fr) / dr or huge)
    local tMC = dc > 0 and (c + 1 - fc) / dc or (dc < 0 and (c - fc) / dc or huge)
    local left = abs(r2 - r) + abs(c2 - c)
    while left > 0 do
        left = left - 1
        if (tMR <= tMC and r ~= r2) or c == c2 then
            step(r, c, r + stepR, c)
            r = r + stepR
            tMR = tMR + tDR
        else
            step(r, c, r, c + stepC)
            c = c + stepC
            tMC = tMC + tDC
        end
    end
end

-- you stood here (north, west in yards)
function P.MarkWalked(inst, north, west)
    return setBits(inst, floor(north / CS) + OFFC, floor(west / CS) + OFFC, 1)
end
-- you walked from the first spot to the second
function P.MarkWalkedLine(inst, n1, w1, n2, w2)
    local new = 0
    trace(n1 / CS + OFFC, w1 / CS + OFFC, n2 / CS + OFFC, w2 / CS + OFFC,
        function(r, c) if setBits(inst, r, c, 1) then new = new + 1 end end,
        function(r1, c1, r2, c2)
            local ok
            if r2 > r1 then ok = setBits(inst, r1, c1, 3)
            elseif r2 < r1 then ok = setBits(inst, r2, c2, 3)
            elseif c2 > c1 then ok = setBits(inst, r1, c1, 5)
            else ok = setBits(inst, r2, c2, 5) end
            if setBits(inst, r2, c2, 1) or ok then new = new + 1 end
        end)
    return new
end

-- fn(fr, fc, bits) for every remembered square inside the given rows and columns
local function eachWalked(wt, frMin, frMax, fcMin, fcMax, fn)
    local b0, b1 = floor(frMin / 2), floor(frMax / 2)
    local d0, d1 = floor(fcMin / 4), floor(fcMax / 4)
    local function squares(br, bc, v)
        local ci = 0
        while v > 0 do
            local bits = v % 8
            v = (v - bits) / 8
            if bits > 0 then
                local fr, fc = br * 2 + floor(ci / 4), bc * 4 + ci % 4
                if fr >= frMin and fr <= frMax and fc >= fcMin and fc <= fcMax then fn(fr, fc, bits) end
            end
            ci = ci + 1
        end
    end
    if (b1 - b0 + 1) * (d1 - d0 + 1) <= 20000 then -- a small window: look each block up
        for br = b0, b1 do
            local base = br * 4096
            for bc = d0, d1 do
                local v = wt[base + bc]
                if v then squares(br, bc, v) end
            end
            tick(8)
        end
    else -- a big one: go through what is stored
        local seen = 0
        for key, v in pairs(wt) do
            local br = floor(key / 4096)
            local bc = key - br * 4096
            if br >= b0 and br <= b1 and bc >= d0 and bc <= d1 then squares(br, bc, v) end
            seen = seen + 1
            if seen % 64 == 0 then tick(32) end
        end
    end
end

-- Squares over a floor dug under the ground (S.PathUnder, written with the terrain from the game's own models: a
-- cave, a crypt): footsteps there are not used. The squares hold the ground you walk on outdoors, and a walk through
-- a cave, kept on the squares above it, would make a way through the hill (Nick, 2026-11-13: the Gustberry cave on
-- Zephras Isle). Keys: row * 4096 + column of S.PathTerrain[continent].
local underSets = {}
local function underSet(inst)
    local u = underSets[inst]
    if u == nil then
        u = false
        local all = S.PathUnder
        local list = type(all) == "table" and all[inst]
        if type(list) == "table" then
            u = {}
            for i = 1, #list - 2, 3 do
                local base = list[i] * 4096
                for c = list[i + 1], list[i + 2] do u[base + c] = true end
            end
        end
        underSets[inst] = u
    end
    return u or nil
end
P.UnderSet = underSet

-- Indoors (a cave, a mine, a crypt, a house) nothing is remembered either. A cave's mouth often runs on under the
-- hillside before the game counts you as indoors, so steps are held back HOLD yards before they are remembered:
-- going indoors drops the ones held, and the first HOLD yards after coming out are not remembered.
local HOLD = 30
local held, heldLen, skipLeft = {}, 0, 0
local function release(keep)
    while held[1] and heldLen - held[1][6] >= keep do
        local s = table.remove(held, 1)
        heldLen = heldLen - s[6]
        P.MarkWalkedLine(s[1], s[2], s[3], s[4], s[5])
    end
end

local trackCave -- which cave you went into by its mouth (set with the caves, further down)

local lastN, lastW, lastInst, lastAt
local function recordStep()
    if UnitOnTaxi("player") or S.InInstance() then lastN = nil return end
    local order = S:WorldOrder()
    if order ~= "unitdirect" and order ~= "unitswap" then return end
    if IsIndoors and IsIndoors() then
        lastN, held, heldLen, skipLeft = nil, {}, 0, HOLD
        local d = diag()
        d.indoorTicks = (d.indoorTicks or 0) + 1 -- does the game ever say so? (seen in your saved data)
        return
    end
    -- In the air nothing is remembered, and the steps before and after are not joined: a jump down a
    -- cliff is not a way up it.
    if (IsFlying and IsFlying()) or (IsFalling and IsFalling()) or (IsSwimming and IsSwimming())
        or (UnitIsDeadOrGhost and UnitIsDeadOrGhost("player")) then lastN = nil return end
    local x, y, inst = S:PlayerWorld()
    if not x then lastN = nil return end
    local north, west = x, y
    if order == "unitswap" then north, west = y, x end
    if trackCave then trackCave(inst, north, west) end
    local now = GetTime()
    local pn, pw, pinst, pat = lastN, lastW, lastInst, lastAt
    lastN, lastW, lastInst, lastAt = north, west, inst, now
    if not pn or pinst ~= inst or now - pat > 1.6 then return end
    local d = sqrt((north - pn) ^ 2 + (west - pw) ^ 2)
    if d < 0.5 then return end
    -- only your own movement: on a boat or a lift you travel further than your legs carry you
    local speed = GetUnitSpeed and GetUnitSpeed("player")
    if speed and S.Secret(speed) then return end
    if speed then
        if speed <= 0 or d > speed * (now - pat) * 1.6 + 3 then return end
    elseif d > 12 then return end
    if skipLeft > 0 then skipLeft = skipLeft - d return end
    if held[1] and held[1][1] ~= inst then release(0) end
    held[#held + 1] = { inst, pn, pw, north, west, d }
    heldLen = heldLen + d
    release(HOLD)
end

---------------------------------------------------------------- roads
-- Steward's own roads, when it has any: S.PathRoads[continent] = { e = { { a, b, len, source, north, west, north, west, ... }, ... } }
-- Nothing is read from any other add-on.
local function roadsFor(inst)
    local own = S.PathRoads
    local r = type(own) == "table" and own[inst]
    if type(r) == "table" and type(r.e) == "table" then return r.e end
end
P.RoadsFor = roadsFor
-- the box each road lies in, worked out once (kept beside the road tables, which stay as they were loaded)
local roadBoxes = setmetatable({}, { __mode = "k" })
local function roadBox(e)
    local bb = roadBoxes[e]
    if bb then return bb end
    local n0, n1, w0, w1 = huge, -huge, huge, -huge
    for k = 5, #e - 1, 2 do
        local a, b = e[k], e[k + 1]
        if a < n0 then n0 = a end
        if a > n1 then n1 = a end
        if b < w0 then w0 = b end
        if b > w1 then w1 = b end
    end
    bb = { n0, n1, w0, w1 }
    roadBoxes[e] = bb
    return bb
end

---------------------------------------------------------------- terrain (PathTerrain.lua, when present)
-- S.PathTerrain[continent] = { v = 4, x0, y0, cell, w, h, rows = { "..." } }: squares of `cell` yards; row r
-- starts x0 + r * cell yards north, column c starts y0 + c * cell yards west. A square is
-- kind * 4 + (1 if its north border can be crossed) + (2 if its west border can be crossed), kinds 0 easy
-- ground, 1 tight or sloping ground, 2 water, 3 a steep climb; 16 = nothing to stand on. Each character
-- of a row is a run of equal squares; the symbols, in order: { value, longest run }.
local FORMAT = 4
local SYMBOLS = { { 11, 20 }, { 16, 20 }, { 3, 14 }, { 7, 5 }, { 15, 6 }, { 0, 2 }, { 1, 2 }, { 2, 2 }, { 4, 2 }, { 5, 2 },
    { 6, 2 }, { 8, 2 }, { 9, 2 }, { 10, 2 }, { 12, 2 }, { 13, 2 }, { 14, 2 } }
local DEC = {}
do
    local b = 35
    for _, s in ipairs(SYMBOLS) do
        for run = 1, s[2] do
            if b == 92 then b = 93 end
            DEC[b] = rep(char(s[1]), run)
            b = b + 1
        end
    end
end
local CH = {}
for i = 0, 255 do CH[i] = char(i) end
local EDGE_N, EDGE_W = {}, {}
for v = 0, 15 do EDGE_N[v], EDGE_W[v] = v % 2 == 1, floor(v / 2) % 2 == 1 end
EDGE_N[16], EDGE_W[16] = false, false

local ROWS_KEPT = 1200
local function terrainRow(t, r)
    local row = t.cache[r]
    if row then return row end
    local text = t.rows[r + 1]
    if not text then return nil end
    local parts = {}
    for i = 1, #text do parts[i] = DEC[byte(text, i)] end
    row = concat(parts)
    if #row ~= t.w then error("terrain row " .. r .. " has " .. #row .. " squares") end
    if t.cached >= ROWS_KEPT then t.cache, t.cached = {}, 0 end
    t.cache[r] = row
    t.cached = t.cached + 1
    return row
end
local function terrainFor(inst)
    local all = S.PathTerrain
    local t = all and all[inst]
    if not t then return nil end
    if t.v ~= FORMAT or type(t.rows) ~= "table" then
        diag().terrainFormat = tostring(t.v)
        return nil
    end
    if not t.cache then
        t.cache, t.cached = {}, 0
        t.r0, t.c0 = floor(t.x0 / t.cell + 0.5), floor(t.y0 / t.cell + 0.5) -- square 0 counted from the world's origin
    end
    return t
end
-- the square at a spot: its value (see above), or nil off the grid
function P.TerrainAt(inst, north, west)
    local t = terrainFor(inst)
    if not t then return nil end
    local r, c = floor((north - t.x0) / t.cell), floor((west - t.y0) / t.cell)
    if r < 0 or c < 0 or r >= t.h or c >= t.w then return nil end
    local row = terrainRow(t, r)
    return row and byte(row, c + 1)
end
function P.DropTerrainCache()
    local all = S.PathTerrain
    if all then for _, t in pairs(all) do if type(t) == "table" and t.cache then t.cache, t.cached = {}, 0 end end end
end

---------------------------------------------------------------- the search on terrain
local hn, hf = {}, {}
-- key of a square: row * 4096 + column. Steps: 1 north, 2 west, 3 south, 4 east, 5 north-west,
-- 6 north-east, 7 south-west, 8 south-east; + 8 for a step across closed ground.
local DKEY = { 4096, 1, -4096, -1, 4097, 4095, -4095, -4097 }
local DROW = { 1, 0, -1, 0 }
local DCOL = { 0, 1, 0, -1 }
local failed -- the last search that found no open way: { inst, gk, sr, sc, at }
function P.Forget() failed = nil end

local function solveTerrain(job, t)
    local swap, inst = job.swap, job.inst
    -- (qsx.. : where the search starts and ends when an end is inside a cave: the cave's mouth; see solve)
    local sn, sw, gn, gw = job.qsx or job.sx, job.qsy or job.sy, job.qgx or job.gx, job.qgy or job.gy
    if swap then sn, sw, gn, gw = sw, sn, gw, gn end
    local cs, tx0, ty0, TW, TH = t.cell, t.x0, t.y0, t.w, t.h
    local sr, sc = floor((sn - tx0) / cs), floor((sw - ty0) / cs)
    local gr, gc = floor((gn - tx0) / cs), floor((gw - ty0) / cs)
    if sr < 0 or sc < 0 or sr >= TH or sc >= TW or gr < 0 or gc < 0 or gr >= TH or gc >= TW then return false end
    local D = sqrt((gn - sn) ^ 2 + (gw - sw) ^ 2)
    job.mode, job.straight, job.cell = "terrain", D, cs
    -- what a yard of road and of your own footsteps cost on this way of choosing the line; the search's
    -- estimate of what is left counts every yard at the least any yard can cost, so it never overshoots
    -- and a road that bends away and back is still found
    local route = P.ROUTES[job.route] or P.ROUTES.fastest
    local ROADC, WALKC = route.road, route.walked
    local LEAST = min(1, ROADC, WALKC)
    local margin = job.margin or max(1200, min(3000, D * 1.5))
    -- the window, on whole blocks of 32 x 32 squares (see the corridor search below)
    local TS = 32
    local rMin = max(0, floor((min(sn, gn) - margin - tx0) / cs / TS) * TS)
    local rMax = min(TH - 1, floor((max(sn, gn) + margin - tx0) / cs / TS) * TS + TS - 1)
    local cMin = max(0, floor((min(sw, gw) - margin - ty0) / cs / TS) * TS)
    local cMax = min(TW - 1, floor((max(sw, gw) + margin - ty0) / cs / TS) * TS + TS - 1)
    local sk, gk = sr * 4096 + sc, gr * 4096 + gc

    -- rows of the terrain, read as they are needed; false outside the window
    local R = {}
    local function row(r)
        local s = R[r]
        if s == nil then
            s = r >= rMin and r <= rMax and terrainRow(t, r) or false
            R[r] = s
            tick(30)
        end
        return s
    end

    -- roads and footsteps: squares and borders known to be walkable whatever the terrain says
    local ovN, ovW, ovK = {}, {}, {}
    local function mark(r, c, m)
        if r < rMin or r > rMax or c < cMin or c > cMax then return end
        local k = r * 4096 + c
        local old = ovK[k]
        if not old or m < old then ovK[k] = m end
    end
    local function join(r1, c1, r2, c2, m)
        mark(r1, c1, m)
        mark(r2, c2, m)
        if r2 > r1 then ovN[r1 * 4096 + c1] = true
        elseif r2 < r1 then ovN[r2 * 4096 + c2] = true
        elseif c2 > c1 then ovW[r1 * 4096 + c1] = true
        else ovW[r2 * 4096 + c2] = true end
    end
    local edges, nRoad = roadsFor(inst), 0
    if edges then
        local ROAD = ROADC
        local n0, n1 = tx0 + rMin * cs, tx0 + (rMax + 1) * cs
        local w0, w1 = ty0 + cMin * cs, ty0 + (cMax + 1) * cs
        local function visit(r, c) mark(r, c, ROAD) end
        local function step(r1, c1, r2, c2) join(r1, c1, r2, c2, ROAD) end
        for _, e in ipairs(edges) do
            local bb = roadBox(e)
            if bb[1] <= n1 and bb[2] >= n0 and bb[3] <= w1 and bb[4] >= w0 then
                local pn, pw
                for k = 5, #e - 1, 2 do
                    local en, ew = e[k], e[k + 1]
                    if pn and not ((pn < n0 and en < n0) or (pn > n1 and en > n1) or (pw < w0 and ew < w0) or (pw > w1 and ew > w1)) then
                        trace((pn - tx0) / cs, (pw - ty0) / cs, (en - tx0) / cs, (ew - ty0) / cs, visit, step)
                        nRoad = nRoad + 1
                        tick(6 + (abs(en - pn) + abs(ew - pw)) / cs)
                    end
                    pn, pw = en, ew
                end
            end
            tick(1)
        end
    end
    local wt, nWalked = walkedTable(inst), 0
    if wt and abs(cs - CS) < 0.001 then
        local WALKED = WALKC
        local under = underSet(inst) or {}
        local lr, lc = OFFC + t.r0, OFFC + t.c0
        eachWalked(wt, rMin + lr, rMax + lr, cMin + lc, cMax + lc, function(fr, fc, bits)
            local r, c = fr - lr, fc - lc
            local k = r * 4096 + c
            if under[k] then return end
            mark(r, c, WALKED)
            if bits >= 4 then
                if not under[k + 1] then join(r, c, r, c + 1, WALKED) end
                bits = bits - 4
            end
            if bits >= 2 and not under[k + 4096] then join(r, c, r + 1, c, WALKED) end
            nWalked = nWalked + 1
        end)
    end
    job.roads, job.walked = nRoad, nWalked

    local EN, EW = EDGE_N, EDGE_W
    local mulOf = {}
    for v = 0, 15 do
        local kind = floor(v / 4)
        mulOf[v] = (kind == 0 and 1) or (kind == 1 and P.NEAR) or (kind == 2 and P.WATER) or P.ROUGH
    end
    local function squareAt(r, c)
        if c < cMin or c > cMax then return nil end
        local s = R[r]
        if s == nil then s = row(r) end
        return s and byte(s, c + 1)
    end
    -- can the border on side d of square (r, c) be crossed?
    local function open(r, c, d)
        local b
        if d == 1 then
            b = r < rMax and squareAt(r, c)
            return b and (EN[b] or ovN[r * 4096 + c])
        elseif d == 2 then
            b = c < cMax and squareAt(r, c)
            return b and (EW[b] or ovW[r * 4096 + c])
        elseif d == 3 then
            b = r > rMin and squareAt(r - 1, c)
            return b and (EN[b] or ovN[(r - 1) * 4096 + c])
        end
        b = c > cMin and squareAt(r, c - 1)
        return b and (EW[b] or ovW[r * 4096 + c - 1])
    end

    -- An end that is walled in (a ledge, a cave, a building on a slope, the inside of a mountain): closed
    -- ground right around it may be crossed, cheaply. -> row, column, radius squared (in squares), or nil
    local function pocket(k0, other)
        local seen, q, n, head = { [k0] = true }, { k0 }, 1, 1
        while head <= n do
            local k = q[head]
            head = head + 1
            local r = floor(k / 4096)
            local c = k - r * 4096
            for d = 1, 4 do
                if open(r, c, d) then
                    local j = k + DKEY[d]
                    if not seen[j] then
                        if j == other then return nil end
                        seen[j] = true
                        n = n + 1
                        q[n] = j
                        if n >= P.POCKET then return nil end
                    end
                end
            end
            tick(6)
        end
        -- walled in: rings outwards through anything, to the nearest square outside that can be stood on
        local r0 = floor(k0 / 4096)
        local c0 = k0 - r0 * 4096
        local m, far = n, 0
        head = 1
        while head <= m and m < n + P.BREAKOUT do
            local k = q[head]
            head = head + 1
            local r = floor(k / 4096)
            local c = k - r * 4096
            for d = 1, 4 do
                local rj, cj = r + DROW[d], c + DCOL[d]
                local j = rj * 4096 + cj
                if not seen[j] and rj >= rMin and rj <= rMax and cj >= cMin and cj <= cMax then
                    seen[j] = true
                    local d2 = (rj - r0) ^ 2 + (cj - c0) ^ 2
                    if d2 > far then far = d2 end
                    local b = squareAt(rj, cj)
                    if ovK[j] or (b and b ~= 16) then return r0, c0, (sqrt(d2) + 2) ^ 2 end
                    m = m + 1
                    q[m] = j
                end
            end
            tick(6)
        end
        return r0, c0, (sqrt(far) + 2) ^ 2
    end
    local zr, zc, zq, nz = {}, {}, {}, 0
    local goalZone, startZone
    if sk ~= gk then
        row(sr)
        row(gr)
        local a, b, q2 = pocket(gk, sk)
        if a then nz = nz + 1 zr[nz], zc[nz], zq[nz] = a, b, q2 goalZone = nz end
        a, b, q2 = pocket(sk, gk)
        if a then nz = nz + 1 zr[nz], zc[nz], zq[nz] = a, b, q2 startZone = nz end
    end
    job.pockets = nz

    -- A*: gsc the cost so far, par the step that led to a square, closed the squares done with
    local gsc, par, closed, pops
    -- the corridor, when one is set: for every region in it (block * 256 + number) the middle of the
    -- next region on the way and what is left from there, in squares
    local chainR, chainC, chainG
    local blocks = {}
    local function search(blockCost, cap, hw)
        gsc, par, closed, pops = { [sk] = 0 }, { [sk] = 0 }, {}, 0
        local LOW = P.LOW
        if blockCost and blockCost < LOW then LOW = blockCost end
        local HW = cs * LEAST * (hw or 1.0005)
        local canCross = blockCost ~= nil or nz > 0
        local hsize = 1
        hn[1], hf[1] = sk, 0
        local function push(j, g, pd, rj, cj)
            local old = gsc[j]
            if old and g >= old then return end
            local h
            if chainR then
                -- only squares of the corridor are walked on (and those right around a walled-in end);
                -- the pull is towards the next region of the corridor, not straight at the goal
                local br, bc = floor(rj / TS), floor(cj / TS)
                local bk = br * 512 + bc
                local B = blocks[bk]
                local node = B and bk * 256 + byte(B.str, (rj - br * TS) * TS + cj - bc * TS + 1)
                local tr = node and chainR[node]
                if tr then
                    -- (what is left along the chain is already counted at the road's price where it runs on roads)
                    h = sqrt((rj - tr) ^ 2 + (cj - chainC[node]) ^ 2) + chainG[node] / LEAST
                else
                    local inside = false
                    for z = 1, nz do
                        local dr, dc = rj - zr[z], cj - zc[z]
                        if dr * dr + dc * dc <= zq[z] then inside = true break end
                    end
                    if not inside then return end
                    h = sqrt((rj - gr) ^ 2 + (cj - gc) ^ 2)
                end
            else
                local dr, dc = rj - gr, cj - gc
                if dr < 0 then dr = -dr end
                if dc < 0 then dc = -dc end
                h = dr > dc and dr + 0.41421356 * dc or dc + 0.41421356 * dr
            end
            gsc[j], par[j] = g, pd
            local f = g + h * HW
            hsize = hsize + 1
            local k = hsize
            while k > 1 do
                local p = (k - k % 2) / 2
                if hf[p] <= f then break end
                hn[k], hf[k] = hn[p], hf[p]
                k = p
            end
            hn[k], hf[k] = j, f
        end
        -- what a yard of closed ground costs at this square, or nil where it may not be crossed
        local function crossing(rj, cj)
            for z = 1, nz do
                local dr, dc = rj - zr[z], cj - zc[z]
                if dr * dr + dc * dc <= zq[z] then return LOW end
            end
            return blockCost
        end
        while hsize > 0 do
            local i = hn[1]
            local ln, lf = hn[hsize], hf[hsize]
            hsize = hsize - 1
            if hsize > 0 then
                local k = 1
                while true do
                    local l = k * 2
                    if l > hsize then break end
                    if l < hsize and hf[l + 1] < hf[l] then l = l + 1 end
                    if hf[l] >= lf then break end
                    hn[k], hf[k] = hn[l], hf[l]
                    k = l
                end
                hn[k], hf[k] = ln, lf
            end
            if not closed[i] then
                closed[i] = true
                if i == gk then return true end
                pops = pops + 1
                if pops > cap then return false, true end
                local r = floor(i / 4096)
                local c = i - r * 4096
                local c1 = c + 1
                local rowM, rowN, rowS = R[r], R[r + 1], R[r - 1]
                if rowN == nil then rowN = row(r + 1) end
                if rowS == nil then rowS = row(r - 1) end
                local bM = byte(rowM, c1)
                local gi = gsc[i]
                local mi = ovK[i] or mulOf[bM] or 1
                local half = cs * 0.5
                -- north
                local nOpen = rowN and (EN[bM] or ovN[i])
                if rowN then
                    local j = i + 4096
                    if not closed[j] then
                        if nOpen then
                            push(j, gi + half * (mi + (ovK[j] or mulOf[byte(rowN, c1)])), 1, r + 1, c)
                        elseif canCross then
                            local bc = crossing(r + 1, c)
                            if bc then push(j, gi + cs * bc, 9, r + 1, c) end
                        end
                    end
                end
                -- west
                local wOpen = c < cMax and (EW[bM] or ovW[i])
                if c < cMax then
                    local j = i + 1
                    if not closed[j] then
                        if wOpen then
                            push(j, gi + half * (mi + (ovK[j] or mulOf[byte(rowM, c1 + 1)])), 2, r, c + 1)
                        elseif canCross then
                            local bc = crossing(r, c + 1)
                            if bc then push(j, gi + cs * bc, 10, r, c + 1) end
                        end
                    end
                end
                -- south
                local bS = rowS and byte(rowS, c1)
                local sOpen = bS and (EN[bS] or ovN[i - 4096])
                if rowS then
                    local j = i - 4096
                    if not closed[j] then
                        if sOpen then
                            push(j, gi + half * (mi + (ovK[j] or mulOf[bS])), 3, r - 1, c)
                        elseif canCross then
                            local bc = crossing(r - 1, c)
                            if bc then push(j, gi + cs * bc, 11, r - 1, c) end
                        end
                    end
                end
                -- east
                local bE = c > cMin and byte(rowM, c)
                local eOpen = bE and (EW[bE] or ovW[i - 1])
                if c > cMin then
                    local j = i - 1
                    if not closed[j] then
                        if eOpen then
                            push(j, gi + half * (mi + (ovK[j] or mulOf[bE])), 4, r, c - 1)
                        elseif canCross then
                            local bc = crossing(r, c - 1)
                            if bc then push(j, gi + cs * bc, 12, r, c - 1) end
                        end
                    end
                end
                -- the corners: only where both ways round are open, so a corner is never cut
                local diag = cs * 0.70710678
                if nOpen and wOpen then
                    local j = i + 4097
                    if not closed[j] and (EW[byte(rowN, c1)] or ovW[i + 4096]) and (EN[byte(rowM, c1 + 1)] or ovN[i + 1]) then
                        push(j, gi + diag * (mi + (ovK[j] or mulOf[byte(rowN, c1 + 1)])), 5, r + 1, c + 1)
                    end
                end
                if nOpen and eOpen then
                    local j = i + 4095
                    if not closed[j] then
                        local bNE = byte(rowN, c)
                        if (EW[bNE] or ovW[j]) and (EN[bE] or ovN[i - 1]) then
                            push(j, gi + diag * (mi + (ovK[j] or mulOf[bNE])), 6, r + 1, c - 1)
                        end
                    end
                end
                if sOpen and wOpen then
                    local j = i - 4095
                    if not closed[j] then
                        local bSW = byte(rowS, c1 + 1)
                        if (EW[bS] or ovW[i - 4096]) and (EN[bSW] or ovN[j]) then
                            push(j, gi + diag * (mi + (ovK[j] or mulOf[bSW])), 7, r - 1, c + 1)
                        end
                    end
                end
                if sOpen and eOpen then
                    local j = i - 4097
                    if not closed[j] then
                        local bSE = byte(rowS, c)
                        if (EW[bSE] or ovW[j]) and (EN[bSE] or ovN[j]) then
                            push(j, gi + diag * (mi + (ovK[j] or mulOf[bSE])), 8, r - 1, c - 1)
                        end
                    end
                end
                tick(10)
            end
        end
        return false
    end

    -- The long view, for when the direct search runs out of budget. The window is cut into blocks of
    -- 32 x 32 squares; inside a block the squares that hang together form a region. Regions that touch
    -- across a block's edge are linked. A search over the regions (a few thousand at most) finds the
    -- chain that leads to the goal, or proves there is none; the squares are then searched inside that
    -- chain only.
    local nBlocks = 0
    local function block(bk)
        local B = blocks[bk]
        if B then return B end
        local br = floor(bk / 512)
        local r0, c0 = br * TS, (bk - br * 512) * TS
        local rows = {}
        for lr = -1, TS - 1 do
            local s = R[r0 + lr]
            if s == nil then s = row(r0 + lr) end
            rows[lr] = s
        end
        local id, q = {}, {}
        local n, cr, cc, cnt, rd = 0, {}, {}, {}, {}
        for lr = 0, TS - 1 do
            local rowM = rows[lr]
            for lc = 0, TS - 1 do
                local li = lr * TS + lc
                if id[li] == nil then
                    local b = rowM and byte(rowM, c0 + lc + 1)
                    if b and (b ~= 16 or ovK[(r0 + lr) * 4096 + c0 + lc]) and n < 250 then
                        n = n + 1
                        id[li] = n
                        local head, tail, sumR, sumC, nr = 1, 1, 0, 0, 0
                        q[1] = li
                        while head <= tail do
                            local cur = q[head]
                            head = head + 1
                            local clr = floor(cur / TS)
                            local clc = cur - clr * TS
                            sumR, sumC = sumR + clr, sumC + clc
                            local key = (r0 + clr) * 4096 + c0 + clc
                            local ok_ = ovK[key]
                            if ok_ and ok_ < 1 then nr = nr + 1 end
                            local col = c0 + clc + 1
                            local bb = byte(rows[clr], col)
                            if clr < TS - 1 and id[cur + TS] == nil and (EN[bb] or ovN[key]) then
                                id[cur + TS] = n tail = tail + 1 q[tail] = cur + TS
                            end
                            if clc < TS - 1 and id[cur + 1] == nil and (EW[bb] or ovW[key]) then
                                id[cur + 1] = n tail = tail + 1 q[tail] = cur + 1
                            end
                            if clr > 0 and id[cur - TS] == nil and (EN[byte(rows[clr - 1], col)] or ovN[key - 4096]) then
                                id[cur - TS] = n tail = tail + 1 q[tail] = cur - TS
                            end
                            if clc > 0 and id[cur - 1] == nil and (EW[byte(rows[clr], col - 1)] or ovW[key - 1]) then
                                id[cur - 1] = n tail = tail + 1 q[tail] = cur - 1
                            end
                        end
                        cr[n], cc[n], cnt[n], rd[n] = r0 + sumR / tail, c0 + sumC / tail, tail, nr
                    else
                        id[li] = 0
                    end
                end
            end
        end
        local parts = {}
        for li = 0, TS * TS - 1 do parts[li + 1] = CH[id[li]] end
        B = { str = concat(parts), r = cr, c = cc, cnt = cnt, rd = rd }
        blocks[bk] = B
        nBlocks = nBlocks + 1
        tick(TS * TS)
        return B
    end
    -- a region is written block * 256 + its number inside the block
    local function regionAt(r, c)
        local br, bc = floor(r / TS), floor(c / TS)
        local bk = br * 512 + bc
        local reg = byte(block(bk).str, (r - br * TS) * TS + c - bc * TS + 1)
        if reg == 0 then return nil end
        return bk * 256 + reg
    end
    local linked = {}
    local function links(node)
        local out = linked[node]
        if out then return out end
        out = {}
        local bk = floor(node / 256)
        local reg = node - bk * 256
        local br = floor(bk / 512)
        local bc = bk - br * 512
        local r0, c0 = br * TS, bc * TS
        local str = block(bk).str
        local seen = {}
        for d = 1, 4 do
            local nbr, nbc = br + DROW[d], bc + DCOL[d]
            local nr0, nc0 = nbr * TS, nbc * TS
            if nr0 >= rMin and nr0 <= rMax and nc0 >= cMin and nc0 <= cMax then
                local nbk = nbr * 512 + nbc
                local nstr = block(nbk).str
                for k = 0, TS - 1 do
                    local lr, lc, nlr, nlc
                    if d == 1 then lr, lc, nlr, nlc = TS - 1, k, 0, k
                    elseif d == 2 then lr, lc, nlr, nlc = k, TS - 1, k, 0
                    elseif d == 3 then lr, lc, nlr, nlc = 0, k, TS - 1, k
                    else lr, lc, nlr, nlc = k, 0, k, TS - 1 end
                    if byte(str, lr * TS + lc + 1) == reg and open(r0 + lr, c0 + lc, d) then
                        local nreg = byte(nstr, nlr * TS + nlc + 1)
                        if nreg ~= 0 then
                            local nn = nbk * 256 + nreg
                            if not seen[nn] then seen[nn] = true out[#out + 1] = nn end
                        end
                    end
                end
            end
        end
        linked[node] = out
        tick(150)
        return out
    end
    -- the regions an end belongs to: its own, or for a walled-in end every region its zone reaches
    local function endRegions(r, c, z)
        local set = {}
        if z then
            local rad = ceil(sqrt(zq[z]))
            for rr = max(rMin, zr[z] - rad), min(rMax, zr[z] + rad) do
                for c2 = max(cMin, zc[z] - rad), min(cMax, zc[z] + rad) do
                    if (rr - zr[z]) ^ 2 + (c2 - zc[z]) ^ 2 <= zq[z] then
                        local node = regionAt(rr, c2)
                        if node then set[node] = true end
                    end
                end
                tick(rad)
            end
        end
        local node = regionAt(r, c)
        if node then set[node] = true end
        return set
    end
    -- Finds the chain of regions from the start to the goal and sets the corridor (chainR, chainC,
    -- chainG) -> how many squares it holds; nil when no chain leads there inside the window
    local function corridor()
        local starts, goals = endRegions(sr, sc, startZone), endRegions(gr, gc, goalZone)
        local function spot(node)
            local bk = floor(node / 256)
            local B = blocks[bk]
            local reg = node - bk * 256
            return B.r[reg], B.c[reg]
        end
        local hk, hv, hs = {}, {}, 0
        local function hpush(node, f)
            hs = hs + 1
            local k = hs
            while k > 1 do
                local p = (k - k % 2) / 2
                if hv[p] <= f then break end
                hk[k], hv[k] = hk[p], hv[p]
                k = p
            end
            hk[k], hv[k] = node, f
        end
        local function hpop()
            local top = hk[1]
            local ln, lf = hk[hs], hv[hs]
            hs = hs - 1
            if hs > 0 then
                local k = 1
                while true do
                    local l = k * 2
                    if l > hs then break end
                    if l < hs and hv[l + 1] < hv[l] then l = l + 1 end
                    if hv[l] >= lf then break end
                    hk[k], hv[k] = hk[l], hv[l]
                    k = l
                end
                hk[k], hv[k] = ln, lf
            end
            return top
        end
        -- a step between two regions that both hold road (or your footsteps) costs what a yard of it costs: the
        -- chain then keeps to the roads as the search inside it will
        local function stepMul(a, b)
            local ba, bb = floor(a / 256), floor(b / 256)
            if blocks[ba].rd[a - ba * 256] > 0 and blocks[bb].rd[b - bb * 256] > 0 then return LEAST end
            return 1
        end
        -- from the goal outwards: what is left to the goal from each region, and which region comes next
        local left, nxt, done = {}, {}, {}
        for node in pairs(goals) do
            local r, c = spot(node)
            left[node], nxt[node] = sqrt((r - gr) ^ 2 + (c - gc) ^ 2), 0
            hpush(node, left[node] + LEAST * sqrt((r - sr) ^ 2 + (c - sc) ^ 2))
        end
        -- from the start a plain flood runs alongside: when it runs dry without meeting the goal, the
        -- start's side is closed off and there is nothing to look for
        local bq, bseen, bhead, btail = {}, {}, 1, 0
        for node in pairs(starts) do btail = btail + 1 bq[btail] = node bseen[node] = true end
        if btail == 0 or hs == 0 then return nil end
        local reached
        while hs > 0 do
            local node = hpop()
            if not done[node] then
                done[node] = true
                if starts[node] then reached = node break end
                local pr, pc = spot(node)
                local base = left[node]
                local list = links(node)
                for k = 1, #list do
                    local nb = list[k]
                    if not done[nb] then
                        local nr, nc = spot(nb)
                        local ng = base + sqrt((nr - pr) ^ 2 + (nc - pc) ^ 2) * stepMul(node, nb)
                        local old = left[nb]
                        if not old or ng < old then
                            left[nb], nxt[nb] = ng, node
                            hpush(nb, ng + LEAST * sqrt((nr - sr) ^ 2 + (nc - sc) ^ 2))
                        end
                    end
                end
                if bhead <= btail then
                    local bn = bq[bhead]
                    bhead = bhead + 1
                    local bl = links(bn)
                    for k = 1, #bl do
                        local nb = bl[k]
                        if not bseen[nb] then bseen[nb] = true btail = btail + 1 bq[btail] = nb end
                    end
                    if bhead > btail then
                        local joined = false
                        for node2 in pairs(goals) do if bseen[node2] then joined = true break end end
                        if not joined then return nil end
                    end
                end
            end
        end
        if not reached then return nil end
        chainR, chainC, chainG = {}, {}, {}
        local count = 0
        local node = reached
        while node ~= 0 do
            local bk = floor(node / 256)
            local after = nxt[node]
            if after ~= 0 then
                chainR[node], chainC[node] = spot(after)
                chainG[node] = left[after]
            else
                chainR[node], chainC[node], chainG[node] = gr, gc, 0
            end
            count = count + blocks[bk].cnt[node - bk * 256]
            node = after
        end
        return count
    end

    local found
    if sk == gk then
        gsc, par, pops, found = { [sk] = 0 }, { [sk] = 0 }, 0, true
    else
        local f = failed
        local known = f and f.inst == inst and f.gk == gk and GetTime() - f.at < 20 and abs(f.sr - sr) + abs(f.sc - sc) < 12
        if not known then
            local capped
            -- (keeping to the roads looks at more ground before it is sure: more squares for it)
            found, capped = search(nil, floor(min(P.POPS, P.POPS_BASE + P.POPS_PER * D / cs) / LEAST), job.hw or (D > P.WEIGHT_FROM and P.WEIGHT or nil))
            job.pops = pops
            if not found and capped then
                -- out of budget, not out of ground: take the long view
                job.far = true
                local count = corridor()
                job.blocks, job.corridor = nBlocks, count
                if count then
                    found = search(nil, huge, P.WEIGHT_IN)
                    chainR, chainC, chainG = nil, nil, nil
                    job.pops = job.pops + pops
                end
            end
            if found then
                if f and f.gk == gk then failed = nil end
            else
                failed = { inst = inst, gk = gk, sr = sr, sc = sc, at = GetTime() }
            end
        end
        if not found then
            -- no open way within reach: the way that crosses the least closed ground
            job.phase = 2
            -- (a guess: pulled towards the goal as hard whichever way the line is chosen)
            found = search(P.MID, P.POPS2, (job.hw2 or P.WEIGHT_GUESS) / LEAST)
            job.pops = (job.pops or 0) + pops
        end
    end

    local PN, PW, PG, F, n = {}, {}, {}, {}, 0
    if found then
        local keys, flag = {}, {}
        local k = gk
        while k ~= sk do
            n = n + 1
            keys[n] = k
            local pd = par[k]
            if pd > 8 then flag[n] = true pd = pd - 8 end
            k = k - DKEY[pd]
            if n > 400000 then error("path does not end") end
        end
        n = n + 1
        keys[n] = sk
        for i = 1, n do
            local key = keys[n + 1 - i]
            local r = floor(key / 4096)
            PN[i], PW[i], PG[i] = tx0 + (r + 0.5) * cs, ty0 + (key - r * 4096 + 0.5) * cs, gsc[key]
            F[i] = flag[n - i] or false -- the piece from point i to point i + 1
        end
        if n == 1 then n = 2 PG[2] = D F[1] = false end
        PN[1], PW[1], PN[n], PW[n] = sn, sw, gn, gw
        tick(n)
    else
        -- nothing found at all: a faint straight line
        job.phase = 3
        n = 2
        PN[1], PW[1], PN[2], PW[2], PG[1], PG[2], F[1] = sn, sw, gn, gw, 0, D, true
    end

    -- a straight piece: can every border it crosses be crossed, and what does it cost?
    local function line(an, aw, bn, bw)
        local fr, fc = (an - tx0) / cs, (aw - ty0) / cs
        local er, ec = (bn - tx0) / cs, (bw - ty0) / cs
        local r, c = floor(fr), floor(fc)
        local r2, c2 = floor(er), floor(ec)
        local dr, dc = er - fr, ec - fc
        local len = sqrt(dr * dr + dc * dc) * cs
        local b = squareAt(r, c)
        local m = b and (ovK[r * 4096 + c] or mulOf[b])
        if not m then return false end
        local stepR, stepC = dr > 0 and 1 or -1, dc > 0 and 1 or -1
        local dirR, dirC = dr > 0 and 1 or 3, dc > 0 and 2 or 4
        local tDR, tDC = dr ~= 0 and abs(1 / dr) or huge, dc ~= 0 and abs(1 / dc) or huge
        local tMR = dr > 0 and (r + 1 - fr) / dr or (dr < 0 and (r - fr) / dr or huge)
        local tMC = dc > 0 and (c + 1 - fc) / dc or (dc < 0 and (c - fc) / dc or huge)
        local at, cost = 0, 0
        local left = abs(r2 - r) + abs(c2 - c)
        tick(4 + left * 2)
        while left > 0 do
            local tNext
            if abs(tMR - tMC) < 1e-9 and r ~= r2 and c ~= c2 then
                -- straight through a corner: both ways round must be open
                if not (open(r, c, dirR) and open(r + stepR, c, dirC) and open(r, c, dirC) and open(r, c + stepC, dirR)) then return false end
                tNext = tMR
                r, c = r + stepR, c + stepC
                tMR, tMC = tMR + tDR, tMC + tDC
                left = left - 2
            elseif (tMR < tMC and r ~= r2) or c == c2 then
                if not open(r, c, dirR) then return false end
                tNext = tMR
                r = r + stepR
                tMR = tMR + tDR
                left = left - 1
            else
                if not open(r, c, dirC) then return false end
                tNext = tMC
                c = c + stepC
                tMC = tMC + tDC
                left = left - 1
            end
            if tNext > 1 then tNext = 1 end
            cost = cost + (tNext - at) * len * m
            at = tNext
            b = squareAt(r, c)
            m = b and (ovK[r * 4096 + c] or mulOf[b])
            if not m then return false end
        end
        return true, cost + (1 - at) * len * m
    end

    -- straighten: a run of squares becomes one straight piece wherever that piece crosses only open
    -- borders and costs no more to speak of; a run across closed ground becomes one faint piece
    local SLACK, SLACK_YD = P.SLACK, P.SLACK_YD * LEAST
    local ON, OW, OU, m = { PN[1] }, { PW[1] }, {}, 1
    local a = 1
    while a < n do
        if F[a] then
            local b = a
            while b < n and F[b] do b = b + 1 end
            OU[m] = true
            m = m + 1
            ON[m], OW[m] = PN[b], PW[b]
            a = b
        else
            local e = a
            while e < n and not F[e] do e = e + 1 end
            local function ok(b)
                local good, cost = line(PN[a], PW[a], PN[b], PW[b])
                return good and cost <= (PG[b] - PG[a]) * SLACK + SLACK_YD
            end
            local good, step = a + 1, 2
            while a + step <= e and ok(a + step) do good = a + step step = step * 2 end
            local lo, hi = good, min(e, a + step)
            while hi - lo > 1 do
                local mid = floor((lo + hi) / 2)
                if ok(mid) then lo = mid else hi = mid end
            end
            if hi == e and lo < e and ok(e) then lo = e end
            a = lo
            OU[m] = false
            m = m + 1
            ON[m], OW[m] = PN[a], PW[a]
        end
    end
    -- A long stretch of steep climb is a guess as well: a mountainside that can be walked triangle by
    -- triangle is seldom a way anyone takes. Short ones stay (roads have them); longer ones are cut out
    -- of the solid pieces and drawn faint.
    local CLIMB_RUN = P.CLIMB_RUN
    local cutA, cutB = {}, {}
    do
        local runSeg, runT, runN, endSeg, endT, lastKey = nil, nil, 0, nil, nil, nil
        local climbs = 0
        local function close()
            if runN > CLIMB_RUN then
                climbs = climbs + 1
                for k = runSeg, endSeg do
                    local a, b = k == runSeg and runT or 0, k == endSeg and endT or 1
                    if b > a then
                        local la, lb = cutA[k], cutB[k]
                        if not la then la, lb = {}, {} cutA[k], cutB[k] = la, lb end
                        la[#la + 1], lb[#lb + 1] = a, b
                    end
                end
            end
            runN, runSeg = 0, nil
        end
        for k = 1, m - 1 do
            if OU[k] then
                close()
                lastKey = nil
            else
                -- the squares this piece passes through, in order, with where it enters and leaves each
                local an, aw, bn, bw = ON[k], OW[k], ON[k + 1], OW[k + 1]
                local fr, fc = (an - tx0) / cs, (aw - ty0) / cs
                local er, ec = (bn - tx0) / cs, (bw - ty0) / cs
                local r, c = floor(fr), floor(fc)
                local r2, c2 = floor(er), floor(ec)
                local dr, dc = er - fr, ec - fc
                local stepR, stepC = dr > 0 and 1 or -1, dc > 0 and 1 or -1
                local tDR, tDC = dr ~= 0 and abs(1 / dr) or huge, dc ~= 0 and abs(1 / dc) or huge
                local tMR = dr > 0 and (r + 1 - fr) / dr or (dr < 0 and (r - fr) / dr or huge)
                local tMC = dc > 0 and (c + 1 - fc) / dc or (dc < 0 and (c - fc) / dc or huge)
                local at = 0
                local left = abs(r2 - r) + abs(c2 - c)
                tick(4 + left * 2)
                while true do
                    local tNext, nr, nc, adv, corner = 1, r, c, 1, false
                    if left > 0 then
                        if abs(tMR - tMC) < 1e-9 and r ~= r2 and c ~= c2 then
                            -- straight through a corner: on to the square across it
                            tNext, nr, nc, adv, corner = tMR, r + stepR, c + stepC, 2, true
                            tMR, tMC = tMR + tDR, tMC + tDC
                        elseif (tMR < tMC and r ~= r2) or c == c2 then
                            tNext, nr, tMR = tMR, r + stepR, tMR + tDR
                        else
                            tNext, nc, tMC = tMC, c + stepC, tMC + tDC
                        end
                        if tNext > 1 then tNext = 1 end
                    end
                    local key = r * 4096 + c
                    local b = squareAt(r, c)
                    if b and b >= 12 and b < 16 and not ovK[key] then
                        if key ~= lastKey then
                            if runN == 0 then runSeg, runT = k, at end
                            runN = runN + 1
                        end
                        endSeg, endT = k, tNext
                    else
                        close()
                    end
                    lastKey = key
                    if left <= 0 then break end
                    if corner then
                        -- the two squares the corner is shared with are brushed too: a steep one counts
                        local b1, b2 = squareAt(nr, c), squareAt(r, nc)
                        if (b1 and b1 >= 12 and b1 < 16 and not ovK[nr * 4096 + c]) or (b2 and b2 >= 12 and b2 < 16 and not ovK[r * 4096 + nc]) then
                            if runN == 0 then runSeg, runT = k, tNext end
                            runN = runN + 1
                            endSeg, endT = k, tNext
                            lastKey = nil
                        end
                    end
                    left = left - adv
                    r, c, at = nr, nc, tNext
                end
            end
        end
        close()
        job.climbs = climbs
    end
    local FN, FW, FU, fm = { ON[1] }, { OW[1] }, {}, 1
    for k = 1, m - 1 do
        local la, lb = cutA[k], cutB[k]
        local an, aw, bn, bw = ON[k], OW[k], ON[k + 1], OW[k + 1]
        if la then
            local at = 0
            for i = 1, #la do
                local a, b = la[i], lb[i]
                if a > at + 1e-9 then
                    FU[fm] = false
                    fm = fm + 1
                    FN[fm], FW[fm] = an + (bn - an) * a, aw + (bw - aw) * a
                end
                FU[fm] = true
                fm = fm + 1
                FN[fm], FW[fm] = an + (bn - an) * b, aw + (bw - aw) * b
                at = b
            end
            if at < 1 - 1e-9 then
                FU[fm] = false
                fm = fm + 1
            end
            FN[fm], FW[fm] = bn, bw
        else
            FU[fm] = OU[k] or false
            fm = fm + 1
            FN[fm], FW[fm] = bn, bw
        end
    end
    local len, unsure = 0, 0
    local X, Y, U = {}, {}, {}
    for k = 1, fm do
        if swap then X[k], Y[k] = FW[k], FN[k] else X[k], Y[k] = FN[k], FW[k] end
        if k > 1 then
            local d = sqrt((FN[k] - FN[k - 1]) ^ 2 + (FW[k] - FW[k - 1]) ^ 2)
            len = len + d
            if FU[k - 1] then unsure = unsure + d end
        end
        U[k] = FU[k] or false
    end
    job.X, job.Y, job.U, job.n, job.len, job.unsure = X, Y, U, fm, len, unsure
    if #hn > 20000 then hn, hf = {}, {} end -- a long search: do not keep its working space
    return true
end

---------------------------------------------------------------- the search without terrain (pure Lua)
local kind, dt, mul, gsc, par, closed = {}, {}, {}, {}, {}, {}

-- job: { sx, sy, gx, gy, inst } -> job.X, job.Y (the path), job.len, or job.none
local solveKnown
solveKnown = function(job)
    local sx, sy, gx, gy, inst = job.sx, job.sy, job.gx, job.gy, job.inst
    local route = P.ROUTES[job.route] or P.ROUTES.fastest
    local ROADC, WALKC = route.road, route.walked
    local D = sqrt((gx - sx) ^ 2 + (gy - sy) ^ 2)
    local margin = job.margin or max(300, min(1200, D * 0.6))
    local c = P.CELL
    local x0, y0, W, H
    while true do
        x0 = floor((min(sx, gx) - margin) / 64) * 64
        y0 = floor((min(sy, gy) - margin) / 64) * 64
        W = ceil((max(sx, gx) + margin - x0) / c)
        H = ceil((max(sy, gy) + margin - y0) / c)
        if W * H <= P.MAX_CELLS then break end
        c = c * 2
    end
    local N = W * H
    local x1, y1 = x0 + W * c, y0 + H * c
    job.mode, job.cell, job.cells = "known", c, N
    for i = 1, N do kind[i] = 0 end
    tick(N / 4)
    local function cellOf(x, y)
        local cx, cy = floor((x - x0) / c), floor((y - y0) / c)
        if cx < 0 or cy < 0 or cx >= W or cy >= H then return nil end
        return cy * W + cx + 1
    end

    -- known ground
    local data, nKnown = S.PathData, 0
    if data then
        for mapID, str in pairs(data) do
            local z = zoneInfo(mapID)
            if z and z.inst == inst and z.x1 >= x0 and z.x0 <= x1 and z.y1 >= y0 and z.y0 <= y1 then
                local ox, oy, ax, ay, bx, by = z.ox, z.oy, z.ax, z.ay, z.bx, z.by
                for p = 1, #str - 3, 4 do
                    local a, b, d, e = str:byte(p, p + 3)
                    local u, v = ((a - 35) * 57 + b - 35) / 3248, ((d - 35) * 57 + e - 35) / 3248
                    local i = cellOf(ox + u * ax + v * bx, oy + u * ay + v * by)
                    if i and kind[i] == 0 then kind[i] = 1 nKnown = nKnown + 1 end
                    if p % 256 == 1 then tick(64) end
                end
            end
        end
    end
    -- footsteps (kept as north, west; this search works in the map's own order)
    local swap = job.swap
    local wt, nWalked = walkedTable(inst), 0
    if wt then
        local n0, n1, w0, w1 = x0, x1, y0, y1
        if swap then n0, n1, w0, w1 = y0, y1, x0, x1 end
        eachWalked(wt, floor(n0 / CS) + OFFC, floor(n1 / CS) + OFFC, floor(w0 / CS) + OFFC, floor(w1 / CS) + OFFC, function(fr, fc)
            local north, west = (fr - OFFC + 0.5) * CS, (fc - OFFC + 0.5) * CS
            local i
            if swap then i = cellOf(west, north) else i = cellOf(north, west) end
            if i and kind[i] < 2 then kind[i] = 2 nWalked = nWalked + 1 end
        end)
    end
    -- roads
    local edges, nRoad = roadsFor(inst), 0
    if edges then
        for _, e in ipairs(edges) do
            local n = #e
            local px, py
            for k = 5, n - 1, 2 do
                local ex, ey = e[k], e[k + 1]
                if swap then ex, ey = ey, ex end
                if px and not ((px < x0 and ex < x0) or (px > x1 and ex > x1) or (py < y0 and ey < y0) or (py > y1 and ey > y1)) then
                    local len = sqrt((ex - px) ^ 2 + (ey - py) ^ 2)
                    local steps = max(1, ceil(len / (c * 0.5)))
                    for s = 0, steps do
                        local i = cellOf(px + (ex - px) * s / steps, py + (ey - py) * s / steps)
                        if i and kind[i] ~= 3 then kind[i] = 3 nRoad = nRoad + 1 end
                    end
                    tick(steps)
                end
                px, py = ex, ey
            end
            tick(2)
        end
    end
    job.known, job.walked, job.roads = nKnown, nWalked, nRoad

    local si, gi = cellOf(sx, sy), cellOf(gx, gy)
    if not (si and gi) then job.none = true return end
    if kind[si] == 0 then kind[si] = 1 end
    if kind[gi] == 0 then kind[gi] = 1 end

    -- distance to the nearest known ground (two sweeps)
    local BIG, diag = 1e9, c * 1.4142
    for i = 1, N do dt[i] = kind[i] > 0 and 0 or BIG end
    for cy = 0, H - 1 do
        local row = cy * W
        for cx = 0, W - 1 do
            local i = row + cx + 1
            local d = dt[i]
            if d > 0 then
                if cx > 0 and dt[i - 1] + c < d then d = dt[i - 1] + c end
                if cy > 0 then
                    local up = i - W
                    if dt[up] + c < d then d = dt[up] + c end
                    if cx > 0 and dt[up - 1] + diag < d then d = dt[up - 1] + diag end
                    if cx < W - 1 and dt[up + 1] + diag < d then d = dt[up + 1] + diag end
                end
                dt[i] = d
            end
        end
        tick(W / 2)
    end
    local free, scale, cap = P.FREE + (c - 16), P.SCALE + (c - 16), P.CAP
    local minMul = 1
    for cy = H - 1, 0, -1 do
        local row = cy * W
        for cx = W - 1, 0, -1 do
            local i = row + cx + 1
            local d = dt[i]
            if d > 0 then
                if cx < W - 1 and dt[i + 1] + c < d then d = dt[i + 1] + c end
                if cy < H - 1 then
                    local dn = i + W
                    if dt[dn] + c < d then d = dt[dn] + c end
                    if cx < W - 1 and dt[dn + 1] + diag < d then d = dt[dn + 1] + diag end
                    if cx > 0 and dt[dn - 1] + diag < d then d = dt[dn - 1] + diag end
                end
                dt[i] = d
            end
            local k, m = kind[i], 1
            if k == 3 then m = ROADC
            elseif k == 2 then m = WALKC
            elseif d > free then
                m = 1 + ((d - free) / scale) ^ 2
                if m > cap then m = cap end
            end
            if m < minMul then minMul = m end
            mul[i] = m
            gsc[i] = huge
            closed[i] = false
        end
        tick(W)
    end

    -- A* over the eight neighbours
    local gcx, gcy = (gi - 1) % W, floor((gi - 1) / W)
    local function heur(i)
        local dx, dy = abs((i - 1) % W - gcx), abs(floor((i - 1) / W) - gcy)
        if dx < dy then dx, dy = dy, dx end
        return (dx + 0.4142 * dy) * c * minMul
    end
    local hsize = 1
    hn[1], hf[1] = si, heur(si)
    gsc[si], par[si] = 0, 0
    local found = false
    while hsize > 0 do
        local i = hn[1]
        -- pop
        local ln, lf = hn[hsize], hf[hsize]
        hsize = hsize - 1
        if hsize > 0 then
            local k = 1
            while true do
                local l = k * 2
                if l > hsize then break end
                if l < hsize and hf[l + 1] < hf[l] then l = l + 1 end
                if hf[l] >= lf then break end
                hn[k], hf[k] = hn[l], hf[l]
                k = l
            end
            hn[k], hf[k] = ln, lf
        end
        if not closed[i] then
            closed[i] = true
            if i == gi then found = true break end
            local cx, cy = (i - 1) % W, floor((i - 1) / W)
            local gi0, mi = gsc[i], mul[i]
            for dy = -1, 1 do
                local ny = cy + dy
                if ny >= 0 and ny < H then
                    for dx = -1, 1 do
                        local nx = cx + dx
                        if (dx ~= 0 or dy ~= 0) and nx >= 0 and nx < W then
                            local j = ny * W + nx + 1
                            if not closed[j] then
                                local g = gi0 + ((dx ~= 0 and dy ~= 0) and diag or c) * (mi + mul[j]) * 0.5
                                if g < gsc[j] then
                                    gsc[j], par[j] = g, i
                                    local f = g + heur(j)
                                    hsize = hsize + 1
                                    local k = hsize
                                    while k > 1 do
                                        local p = floor(k / 2)
                                        if hf[p] <= f then break end
                                        hn[k], hf[k] = hn[p], hf[p]
                                        k = p
                                    end
                                    hn[k], hf[k] = j, f
                                end
                            end
                        end
                    end
                end
            end
            tick(9)
        end
    end
    if not found then job.none = true return end

    -- the squares of the path, start to goal
    local rx, ry, n = {}, {}, 0
    local i = gi
    while i ~= 0 do
        n = n + 1
        rx[n], ry[n] = x0 + ((i - 1) % W + 0.5) * c, y0 + (floor((i - 1) / W) + 0.5) * c
        i = par[i]
        if n > N then job.none = true return end
    end
    local X, Y = {}, {}
    for k = 1, n do X[k], Y[k] = rx[n - k + 1], ry[n - k + 1] end
    X[1], Y[1], X[n], Y[n] = sx, sy, gx, gy
    tick(n)

    -- straighten: drop the grid's staircase wherever a straight run costs no more
    local function segCost(ax, ay, bx, by)
        local len = sqrt((bx - ax) ^ 2 + (by - ay) ^ 2)
        if len == 0 then return 0 end
        local steps = max(1, ceil(len / (c * 0.5)))
        local sum = 0
        for s = 1, steps do
            local t = (s - 0.5) / steps
            local ci = cellOf(ax + (bx - ax) * t, ay + (by - ay) * t)
            sum = sum + (ci and mul[ci] or cap)
        end
        tick(steps)
        return sum * len / steps
    end
    local pc = { 0 }
    for k = 2, n do pc[k] = pc[k - 1] + segCost(X[k - 1], Y[k - 1], X[k], Y[k]) end
    local function ok(a, b)
        return segCost(X[a], Y[a], X[b], Y[b]) <= (pc[b] - pc[a]) * 1.03 + 0.01
    end
    local OX, OY, m = { X[1] }, { Y[1] }, 1
    local a = 1
    while a < n do
        local good, step = a + 1, 2
        while a + step <= n and ok(a, a + step) do good = a + step step = step * 2 end
        local lo, hi = good, min(n, a + step)
        while hi - lo > 1 do
            local mid = floor((lo + hi) / 2)
            if ok(a, mid) then lo = mid else hi = mid end
        end
        if hi == n and lo < n and ok(a, n) then lo = n end
        a = lo
        m = m + 1
        OX[m], OY[m] = X[a], Y[a]
    end
    local len = 0
    for k = 2, m do len = len + sqrt((OX[k] - OX[k - 1]) ^ 2 + (OY[k] - OY[k - 1]) ^ 2) end
    job.X, job.Y, job.n, job.len, job.straight = OX, OY, m, len, D
end

-- job: { sx, sy, gx, gy, inst, swap } -> job.X, job.Y, job.U (which pieces are a guess), job.n, job.len; or job.none
---------------------------------------------------------------- caves
-- Caves dug under the hills (S.PathCaves, written with the terrain from the game's own models): the squares hold
-- the ground you walk on outdoors, so a spot over a cave is the hill above it to them. A spot over a cave is taken
-- to be inside it: the line goes to the cave's mouth and on from there as a guess (a faint piece). You over a cave
-- and inside it (the game says you're indoors, or you went in by its mouth, or you're within 25 yd of the mouth):
-- the line starts at the mouth, with a faint piece from you to it. Both ends over the same cave: one faint piece,
-- whatever the game says (a way round from the hill above to the mouth would be the worse guess). (Zephras: the
-- guide's Nightfang Den, "the cave mouth on the north side of the clearing, not the cliff above it".)
local caveSets = {}
local function caveSet(inst)
    local cv = caveSets[inst]
    if cv == nil then
        cv = false
        local all = S.PathCaves
        local list = type(all) == "table" and all[inst]
        if type(list) == "table" then
            cv = { at = {}, caves = {} }
            for i, c in ipairs(list) do
                if type(c) == "table" and type(c.mouths) == "table" and type(c.inside) == "table" and #c.mouths >= 2 then
                    cv.caves[i] = c
                    local ins = c.inside
                    for j = 1, #ins - 2, 3 do
                        local base = ins[j] * 4096
                        for col = ins[j + 1], ins[j + 2] do cv.at[base + col] = i end
                    end
                end
            end
        end
        caveSets[inst] = cv
    end
    return cv or nil
end
P.CaveSet = caveSet
-- which cave you went into by its mouth: set within 25 yd of a cave's mouth, kept while you stay over that cave
trackCave = function(inst, north, west)
    local cv = caveSet(inst)
    local t = cv and terrainFor(inst)
    if not t then P.caveIn = nil return end
    local r, c, at = floor((north - t.x0) / t.cell), floor((west - t.y0) / t.cell), cv.at
    local i = at[r * 4096 + c]
    local cur = P.caveIn
    if cur and cur.inst ~= inst then cur = nil end
    if cur and i ~= cur.cave then
        -- a cave's tunnel bends, and its squares have gaps: kept while you're within 2 squares of it
        local near = false
        for dr = -2, 2 do
            for dc = -2, 2 do
                if at[(r + dr) * 4096 + c + dc] == cur.cave then near = true end
            end
        end
        if not near then cur = nil end
    end
    if i and not cur then
        local m = cv.caves[i].mouths
        for j = 1, #m - 1, 2 do
            if (m[j] - north) ^ 2 + (m[j + 1] - west) ^ 2 <= 25 * 25 then cur = { inst = inst, cave = i } break end
        end
    end
    P.caveIn = cur
end
---------------------------------------------------------------- cave insides
-- S.PathCaveNets (PathCaveNets.lua, from the game's own cave models): per cave, its walkable floor as nodes
-- (cells of about 2 yards, one node per floor level in a cell) and the links between them. With it, the line
-- inside a cave follows the tunnels from the mouth to the spot (and from you back out), solid; without it, the
-- faint straight guess as before.
local netCache = {}
local netByKey = {}
-- v2 nets come packed in strings (tools/cave_pack.py): 64 characters, 6 bits each, fixed widths. d: per node its
-- row (2), column + 2048 * out (2), height in tenths above zb (2), and how many of its links go to higher nodes (1);
-- e: those links, each as the step up (2), or "//" and the node's number (3). -> the v1 fields r, c, z, out, o, e
local VAL = {}
do
    local A = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i = 1, 64 do VAL[A:byte(i)] = i - 1 end
end
local SLASH = ("/"):byte()
local function unpackNet(p)
    local d, s, n, zb = p.d, p.e, p.n, p.zb or 0
    if type(n) ~= "number" or #d ~= 7 * n then return nil end
    local byte = string.byte
    local r, c, z, out, up = {}, {}, {}, {}, {}
    for k = 1, n do
        local i = 7 * (k - 1)
        local a1, a2, b1, b2, z1, z2, u = byte(d, i + 1, i + 7)
        a1, a2, b1, b2, z1, z2, u = VAL[a1], VAL[a2], VAL[b1], VAL[b2], VAL[z1], VAL[z2], VAL[u]
        if not (a1 and a2 and b1 and b2 and z1 and z2 and u) then return nil end
        local cc = b1 * 64 + b2
        r[k], c[k] = a1 * 64 + a2, cc % 2048
        out[k] = cc >= 2048 and 1 or 0
        z[k] = zb + (z1 * 64 + z2) / 10
        up[k] = u
        if k % 2048 == 0 then tick(8) end
    end
    -- links up, then both ways: a node's lower links come in first (from the lower nodes, in order), then its own
    local low, high = {}, {}
    for k = 1, n do low[k] = {} end
    local pos, len = 1, #s
    for k = 1, n do
        local h = {}
        for q = 1, up[k] do
            local j
            local x1, x2 = byte(s, pos, pos + 1)
            if x1 == SLASH and x2 == SLASH then
                local y1, y2, y3 = byte(s, pos + 2, pos + 4)
                y1, y2, y3 = VAL[y1], VAL[y2], VAL[y3]
                if not (y1 and y2 and y3) then return nil end
                j = (y1 * 64 + y2) * 64 + y3
                pos = pos + 5
            else
                x1, x2 = VAL[x1], VAL[x2]
                if not (x1 and x2) then return nil end
                j = k + x1 * 64 + x2
                pos = pos + 2
            end
            if j <= k or j > n then return nil end
            h[q] = j
            local lj = low[j]
            lj[#lj + 1] = k
        end
        high[k] = h
        if k % 2048 == 0 then tick(8) end
    end
    if pos ~= len + 1 then return nil end
    local o, e = {}, {}
    local m = 0
    for k = 1, n do
        o[k] = m + 1
        local lk, hk = low[k], high[k]
        for q = 1, #lk do m = m + 1 e[m] = lk[q] end
        for q = 1, #hk do m = m + 1 e[m] = hk[q] end
        low[k], high[k] = nil, nil
        if k % 2048 == 0 then tick(8) end
    end
    o[n + 1] = m + 1
    return { n0 = p.n0, w0 = p.w0, f = p.f, r = r, c = c, z = z, out = out, o = o, e = e }
end
P.UnpackNet = unpackNet
local function caveNet(inst, cave)
    local all = S.PathCaveNets
    local list = type(all) == "table" and all[inst]
    if type(list) ~= "table" or type(cave.mouths) ~= "table" then return nil end
    local key = string.format("%.1f,%.1f", cave.mouths[1], cave.mouths[2])
    local nt = netCache[inst .. ":" .. key]
    if nt ~= nil then return nt or nil end
    local raw = list[key]
    nt = false
    if type(raw) == "table" and type(raw.d) == "string" and type(raw.e) == "string" then raw = unpackNet(raw) end
    if type(raw) == "table" and type(raw.r) == "table" and type(raw.o) == "table" and #raw.r > 0 then
        local f, n0, w0 = raw.f, raw.n0, raw.w0
        local N, W, at = {}, {}, {}
        for k = 1, #raw.r do
            N[k], W[k] = n0 + (raw.r[k] + 0.5) * f, w0 + (raw.c[k] + 0.5) * f
            local key2 = raw.r[k] * 4096 + raw.c[k]
            local b = at[key2]
            if not b then b = {} at[key2] = b end
            b[#b + 1] = k
        end
        nt = { N = N, W = W, Z = raw.z, out = raw.out, o = raw.o, e = raw.e, at = at, f = f, n0 = n0, w0 = w0, count = #N,
            key = inst .. ":" .. key }
    end
    netCache[inst .. ":" .. key] = nt
    if nt then netByKey[nt.key] = nt end
    return nt or nil
end

-- nodes nearest (n, w) in 2D: those within 2.5 yd of the nearest (several floors can lie over one spot)
local function nearNodes(nt, n, w, outOnly)
    local best
    local d2 = {}
    for k = 1, nt.count do
        if not outOnly or nt.out[k] == 1 then
            local d = (nt.N[k] - n) ^ 2 + (nt.W[k] - w) ^ 2
            d2[k] = d
            if not best or d < best then best = d end
        end
        if k % 512 == 0 then tick(8) end
    end
    if not best then return nil end
    local lim = (sqrt(best) + 2.5) ^ 2
    local set, any = {}, false
    for k, d in pairs(d2) do
        if d <= lim then set[k] = true any = true end
    end
    return any and set or nil, sqrt(best)
end

-- shortest way through the cave's nodes from any node of `from` to any of `to` -> list of nodes
local function netPath(nt, from, to)
    local N, W, Z, o, e = nt.N, nt.W, nt.Z, nt.o, nt.e
    local dist, prev, done = {}, {}, {}
    local heap, hs = {}, 0
    local function push(k, d)
        hs = hs + 1
        local i = hs
        heap[i] = { d, k }
        while i > 1 do
            local pi = floor(i / 2)
            if heap[pi][1] <= heap[i][1] then break end
            heap[pi], heap[i] = heap[i], heap[pi]
            i = pi
        end
    end
    local function pop()
        if hs == 0 then return nil end
        local top = heap[1]
        heap[1] = heap[hs]
        heap[hs] = nil
        hs = hs - 1
        local i = 1
        while true do
            local l, r, m = 2 * i, 2 * i + 1, i
            if l <= hs and heap[l][1] < heap[m][1] then m = l end
            if r <= hs and heap[r][1] < heap[m][1] then m = r end
            if m == i then break end
            heap[m], heap[i] = heap[i], heap[m]
            i = m
        end
        return top[2], top[1]
    end
    for k in pairs(from) do dist[k] = 0 push(k, 0) end
    local goal
    local steps = 0
    while true do
        local k, d = pop()
        if not k then break end
        if not done[k] then
            done[k] = true
            if to[k] then goal = k break end
            for j = o[k], o[k + 1] - 1 do
                local m = e[j]
                if not done[m] then
                    local nd = d + sqrt((N[m] - N[k]) ^ 2 + (W[m] - W[k]) ^ 2 + (Z[m] - Z[k]) ^ 2)
                    if not dist[m] or nd < dist[m] then dist[m], prev[m] = nd, k push(m, nd) end
                end
            end
            steps = steps + 1
            if steps % 64 == 0 then tick(16) end
        end
    end
    if not goal then return nil end
    local path = {}
    local k = goal
    while k do
        table.insert(path, 1, k)
        k = prev[k]
    end
    return path
end

-- a straight piece between two nodes stays on the cave's floor: every cell along it holds a node at about the
-- height between theirs
local function netSees(nt, a, b)
    local N, W, Z = nt.N, nt.W, nt.Z
    local dn, dw = N[b] - N[a], W[b] - W[a]
    local len = sqrt(dn * dn + dw * dw)
    -- one over the other (two floors over a spot), or steeper between them than anyone walks: not a straight piece
    if abs(Z[b] - Z[a]) > 2.5 + len * 1.2 then return false end
    local steps = floor(len / (nt.f * 0.25)) + 1
    for i = 1, steps - 1 do
        local t = i / steps
        local n, w, z = N[a] + dn * t, W[a] + dw * t, Z[a] + (Z[b] - Z[a]) * t
        local cell = nt.at[floor((n - nt.n0) / nt.f) * 4096 + floor((w - nt.w0) / nt.f)]
        local ok = false
        if cell then
            for _, k in ipairs(cell) do
                if abs(Z[k] - z) < 3 then ok = true break end
            end
        end
        if not ok then return false end
    end
    return true
end

-- the nodes of a path, pulled straight where the floor allows -> n, w lists
local function netLine(nt, path)
    local outN, outW, outZ = {}, {}, {}
    local i = 1
    outN[1], outW[1], outZ[1] = nt.N[path[1]], nt.W[path[1]], nt.Z[path[1]]
    while i < #path do
        local j = #path
        while j > i + 1 and not netSees(nt, path[i], path[j]) do j = j - 1 end
        outN[#outN + 1], outW[#outW + 1], outZ[#outZ + 1] = nt.N[path[j]], nt.W[path[j]], nt.Z[path[j]]
        i = j
        tick(4)
    end
    return outN, outW, outZ
end

-- a way through the cave from (an, aw) to (bn, bw); either end may be the mouth (outdoor nodes); aAt / bAt: the
-- floor someone stands on there, when it's been followed (P.FloorOf) -> n, w lists
local function onFloor(nt, at, n, w)
    if not (at and at.key == nt.key and at.node and at.node <= nt.count) then return nil end
    if (at.n - n) ^ 2 + (at.w - w) ^ 2 > 36 then return nil end -- not where that end is
    return { [at.node] = true }
end
local function caveWay(nt, an, aw, aOut, bn, bw, bOut, aAt, bAt)
    local from = onFloor(nt, aAt, an, aw) or nearNodes(nt, an, aw, aOut)
    local to = onFloor(nt, bAt, bn, bw) or nearNodes(nt, bn, bw, bOut)
    if not (from and to) then return nil end
    local path = netPath(nt, from, to)
    if not path then return nil end
    return netLine(nt, path)
end
P.CaveNet, P.CaveWay = caveNet, caveWay

-- Which floor of a cave someone stands on (Nick 2026-11-15: "this is a 3d world ... this is google maps"). The game
-- gives no height (UnitPosition's height is 0, seen in your saved data), so where a cave's floors lie over each other
-- the spot alone can't say which. Followed instead: from where only one floor lies (the entrance), spot by spot along
-- the floor's own links, every quarter second: a step can only reach floor that is joined to the floor you were on,
-- no further along it than you can have walked. A drop (you fell for a while) lands you on the floor below that fits
-- the fall. Lost (a teleport, a Reload inside): found again the first time you stand where only one floor lies.
local floorOf = {} -- who -> { key, node, n, w, inst }
local function floorCave(inst, n, w)
    local cv = caveSet(inst)
    local t = cv and terrainFor(inst)
    if not t then return nil end
    local r, c = floor((n - t.x0) / t.cell), floor((w - t.y0) / t.cell)
    local i = cv.at[r * 4096 + c]
    if not i then
        for dr = -2, 2 do
            for dc = -2, 2 do i = i or cv.at[(r + dr) * 4096 + c + dc] end
        end
    end
    if not i then
        for j, cave in pairs(cv.caves) do
            local m = cave.mouths
            for q = 1, #m - 1, 2 do
                if (m[q] - n) ^ 2 + (m[q + 1] - w) ^ 2 <= 25 * 25 then i = j break end
            end
            if i then break end
        end
    end
    return i and cv.caves[i]
end
-- the floors at (n, w): the nodes within reach of the spot (the cells round it), nearest first per height
local function nodesAt(nt, n, w, reach)
    local r0, c0 = floor((n - nt.n0) / nt.f), floor((w - nt.w0) / nt.f)
    local span = floor(reach / nt.f) + 1
    local out = {}
    for r = r0 - span, r0 + span do
        for c = c0 - span, c0 + span do
            local cell = nt.at[r * 4096 + c]
            if cell then
                for _, k in ipairs(cell) do
                    local d = (nt.N[k] - n) ^ 2 + (nt.W[k] - w) ^ 2
                    if d <= reach * reach then out[#out + 1] = { k, d } end
                end
            end
        end
    end
    table.sort(out, function(a, b) return a[2] < b[2] end)
    return out
end
-- the one floor of the cave at (n, w), or nil when floors lie over each other there (or none is near); the open
-- ground at the mouth is left out (noOut) when you're known to be indoors
local function soleNode(nt, n, w, noOut)
    local near = nodesAt(nt, n, w, 4)
    local first, lim
    for i = 1, #near do
        local k = near[i][1]
        if not (noOut and nt.out[k] == 1) then
            if not first then
                first, lim = k, (sqrt(near[i][2]) + 2.5) ^ 2
            elseif near[i][2] > lim then break
            elseif abs(nt.Z[k] - nt.Z[first]) > 2.5 then return nil end
        end
    end
    return first
end
-- the floor at ground level by the mouth: the open ground there, and the cave's own floor within 12 yd of walking
-- of it and no more than 3 yd higher or lower (the doorway, the first steps in). Where you step in from outside.
local function apron(nt)
    local ap = nt.apron
    if ap then return ap end
    ap = {}
    local N, W, Z, o, e = nt.N, nt.W, nt.Z, nt.o, nt.e
    local dist, zref, queue, head = {}, {}, {}, 1
    for k = 1, nt.count do
        if nt.out[k] == 1 then
            dist[k], zref[k], ap[k] = 0, Z[k], true
            queue[#queue + 1] = k
        end
    end
    while queue[head] do
        local k = queue[head]
        head = head + 1
        for j = o[k], o[k + 1] - 1 do
            local m = e[j]
            local nd = dist[k] + sqrt((N[m] - N[k]) ^ 2 + (W[m] - W[k]) ^ 2 + (Z[m] - Z[k]) ^ 2)
            if nd <= 12 and abs(Z[m] - zref[k]) <= 3 and (not dist[m] or nd < dist[m]) then
                dist[m], zref[m], ap[m] = nd, zref[k], true
                queue[#queue + 1] = m
            end
        end
    end
    nt.apron = ap
    return ap
end
-- you're on the ground outside: the cave's floor at ground level under you, where its floor begins
local function mouthNode(nt, n, w)
    local ap = apron(nt)
    for _, it in ipairs(nodesAt(nt, n, w, 2.5)) do
        if ap[it[1]] then return it[1] end
    end
end
-- from the node you were on, along the links, no further than you can have walked: the node nearest where you are
-- now (of two as near, the one less far along the floor)
local function stepNode(nt, k0, n, w, moved)
    local N, W, Z, o, e = nt.N, nt.W, nt.Z, nt.o, nt.e
    local limit = moved * 1.5 + 3
    local dist, queue, head = { [k0] = 0 }, { k0 }, 1
    local best, bk = sqrt((N[k0] - n) ^ 2 + (W[k0] - w) ^ 2), k0
    while queue[head] do
        local k = queue[head]
        head = head + 1
        local dk = dist[k]
        for j = o[k], o[k + 1] - 1 do
            local m = e[j]
            local nd = dk + sqrt((N[m] - N[k]) ^ 2 + (W[m] - W[k]) ^ 2 + (Z[m] - Z[k]) ^ 2)
            if nd <= limit and (not dist[m] or nd < dist[m]) then
                dist[m] = nd
                queue[#queue + 1] = m
            end
        end
    end
    for m, dm in pairs(dist) do
        local score = sqrt((N[m] - n) ^ 2 + (W[m] - w) ^ 2) + 0.25 * dm
        if score < best then best, bk = score, m end
    end
    return bk, sqrt((N[bk] - n) ^ 2 + (W[bk] - w) ^ 2)
end
-- after a fall of `fell` seconds from node k0: the floor under you that the fall fits
local function landNode(nt, k0, n, w, fell)
    -- the game's own gravity (19.3 yd/s2): how far you drop in that time when you stepped off, and when you jumped
    -- off (0.41 s up to 1.64 yd first)
    local h1 = 0.5 * 19.3 * fell ^ 2
    local h2 = 0.5 * 19.3 * max(0, fell - 0.41) ^ 2 - 1.64
    local z0, bestK, bestErr, bestDown = nt.Z[k0], nil, nil, nil
    for _, it in ipairs(nodesAt(nt, n, w, 3)) do
        local k = it[1]
        local down = z0 - nt.Z[k]
        if down > 2 then
            local err = min(abs(down - h1), abs(down - h2))
            if not bestErr or err < bestErr then bestK, bestErr, bestDown = k, err, down end
        end
    end
    if bestK and bestErr <= max(3, 0.4 * bestDown) then return bestK end
end
local GROUND = { ground = true } -- on the ground outside (over a cave or not)
local function trackFloor(who, inst, n, w, fell, indoors)
    local cur = floorOf[who]
    local cave = n and floorCave(inst, n, w)
    local nt = cave and caveNet(inst, cave)
    if not nt then
        floorOf[who] = n and GROUND or nil -- nowhere near a cave: on the ground
        return
    end
    if cur and cur.node and cur.key == nt.key and cur.inst == inst then
        local moved = sqrt((cur.n - n) ^ 2 + (cur.w - w) ^ 2)
        local k, d = stepNode(nt, cur.node, n, w, moved)
        if fell and fell > 0.9 then
            -- a real drop: the floor below that fits it, when the floor you were on doesn't reach under you
            local land = landNode(nt, cur.node, n, w, fell)
            if land and (d > 2.5 or nt.Z[cur.node] - nt.Z[k] < 2) then k, d = land, 0 end
        end
        if d <= 5 then
            cur.node, cur.n, cur.w = k, n, w
            return
        end
        -- the floor you were on doesn't reach where you are now: off the open ground at the mouth, you're outside
        -- again; anywhere else (a teleport), not known
        cur = apron(nt)[cur.node] and GROUND or nil
    elseif cur and cur.node then
        cur = nil -- another cave
    end
    if cur == GROUND and indoors and soleNode(nt, n, w, true) then cur = nil end -- the game says indoors: in, some other way
    if cur == nil and indoors == false then cur = GROUND end
    if cur == GROUND then
        -- on the ground: onto the cave's open ground at its mouth, where its floor begins?
        local k = mouthNode(nt, n, w)
        floorOf[who] = k and { key = nt.key, node = k, n = n, w = w, inst = inst } or GROUND
        return
    end
    -- not known (a Reload or a teleport inside): the floor here when there is only one
    local k = indoors and soleNode(nt, n, w, true)
    floorOf[who] = k and { key = nt.key, node = k, n = n, w = w, inst = inst } or nil
end
-- who: "player", or "party" (the group member you travel to); x, y in the game's own order; fell: seconds in the air
-- since the last call; indoors: what the game says (the player only; nil: not known)
function P.TrackFloor(who, x, y, inst, fell, indoors)
    if not x then floorOf[who] = nil return end
    local n, w = x, y
    if S:WorldOrder() == "unitswap" then n, w = y, x end
    trackFloor(who, inst, n, w, fell, indoors)
end
-- -> { key, node, n, w, z } when on a cave's floor, or nil; a copy, for a search under way
function P.FloorOf(who)
    local f = floorOf[who]
    if not (f and f.node) then return nil end
    local nt = netByKey[f.key]
    return { key = f.key, node = f.node, n = f.n, w = f.w, inst = f.inst, z = nt and nt.Z[f.node] }
end
-- known to be on the ground outside (over a cave or not)
function P.OnGround(who) return floorOf[who] == GROUND end
function P.ForgetFloors() floorOf.player, floorOf.party = nil, nil end

local function nearestMouth(cave, n, w)
    local m, bn, bw, bd = cave.mouths
    for j = 1, #m - 1, 2 do
        local d = (m[j] - n) ^ 2 + (m[j + 1] - w) ^ 2
        if not bd or d < bd then bn, bw, bd = m[j], m[j + 1], d end
    end
    return bn, bw, sqrt(bd)
end
-- where the line goes in: the mouth, or, when the cave's inside is known, the open ground at the mouth that
-- leads in (the search outdoors ends there and the way through the cave starts there)
local function mouthFor(inst, cave, n, w)
    local mn, mw = nearestMouth(cave, n, w)
    local nt = caveNet(inst, cave)
    if nt then
        local best, bn, bw
        for k = 1, nt.count do
            if nt.out[k] == 1 then
                local d = (nt.N[k] - mn) ^ 2 + (nt.W[k] - mw) ^ 2
                if not best or d < best then best, bn, bw = d, nt.N[k], nt.W[k] end
            end
        end
        if bn then return bn, bw end
    end
    return mn, mw
end
-- -> "same" (both ends in one cave), or whether the start and the goal were moved to a mouth (job.qsx.. set)
local function caveEnds(job, t)
    local cv = caveSet(job.inst)
    if not cv then return end
    local function at(x, y)
        local n, w = x, y
        if job.swap then n, w = y, x end
        return cv.at[floor((n - t.x0) / t.cell) * 4096 + floor((w - t.y0) / t.cell)], n, w
    end
    local gi, gn, gw = at(job.gx, job.gy)
    local si, sn, sw = at(job.sx, job.sy)
    -- followed (P.TrackFloor): on the ground over a cave is not in it
    if job.groundS then si = nil end
    if job.groundG then gi = nil end
    if si and gi == si then return "same", nil, cv.caves[gi] end
    if si and not job.floorS then
        local _, _, d = nearestMouth(cv.caves[si], sn, sw)
        local inside = (IsIndoors and IsIndoors()) or (P.caveIn and P.caveIn.inst == job.inst and P.caveIn.cave == si)
        if not inside and d > 25 then si = nil end
    end
    local function put(n, w)
        if job.swap then return w, n end
        return n, w
    end
    local head, tail
    if gi then
        job.qgx, job.qgy = put(mouthFor(job.inst, cv.caves[gi], gn, gw))
        tail = true
    end
    if si then
        job.qsx, job.qsy = put(mouthFor(job.inst, cv.caves[si], sn, sw))
        head = true
    end
    return head, tail, gi and cv.caves[gi], si and cv.caves[si]
end
-- the faint pieces into and out of a cave, round the path found between its mouths
local function caveFinish(job, head, tail, gcave, scave)
    local head0, tail0 = head, tail
    local X, Y, U, n = job.X, job.Y, job.U, job.n
    local Z = job.Z or {}
    job.Z = Z
    local added, solid = 0, 0
    local function nw(x, y) if job.swap then return y, x end return x, y end
    local function xy(n_, w_) if job.swap then return w_, n_ end return n_, w_ end
    -- through the cave's own floor, when it's known
    if tail and gcave then
        local nt = caveNet(job.inst, gcave)
        local mn, mw = nw(X[n], Y[n])
        local gn, gw = nw(job.gx, job.gy)
        local ln, lw, lz
        if nt then ln, lw, lz = caveWay(nt, mn, mw, true, gn, gw, false, nil, job.floorG) end
        if ln then
            for k = 1, #ln do
                local x, y = xy(ln[k], lw[k])
                local d = sqrt((x - X[n]) ^ 2 + (y - Y[n]) ^ 2)
                if d > 0.5 then
                    U[n] = false
                    n = n + 1
                    X[n], Y[n], U[n], Z[n] = x, y, false, lz[k]
                    solid = solid + d
                end
            end
            job.caveSolid = (job.caveSolid or 0) + 1
            -- the last few yards to the spot itself (it can stand off the floor the cave model gives)
            local d = sqrt((job.gx - X[n]) ^ 2 + (job.gy - Y[n]) ^ 2)
            if d > 0.5 then
                U[n] = d > 6
                n = n + 1
                X[n], Y[n], U[n], Z[n] = job.gx, job.gy, false, lz[#lz]
                if d > 6 then added = added + d else solid = solid + d end
            end
            tail = false
        end
    end
    if head and scave then
        local nt = caveNet(job.inst, scave)
        local mn, mw = nw(X[1], Y[1])
        local sn, sw = nw(job.sx, job.sy)
        local ln, lw, lz
        if nt then ln, lw, lz = caveWay(nt, sn, sw, false, mn, mw, true, job.floorS) end
        if ln then
            local PX, PY, PZ = {}, {}, {}
            PX[1], PY[1], PZ[1] = job.sx, job.sy, lz[1]
            local fx, fy = xy(ln[1], lw[1])
            local off = sqrt((fx - job.sx) ^ 2 + (fy - job.sy) ^ 2) -- how far you stand from the cave's floor
            for k = 1, #ln do
                local x, y = xy(ln[k], lw[k])
                local d = sqrt((x - PX[#PX]) ^ 2 + (y - PY[#PY]) ^ 2)
                if d > 0.5 then PX[#PX + 1], PY[#PY + 1], PZ[#PX + 1] = x, y, lz[k] solid = solid + d end
            end
            solid = solid + sqrt((X[1] - PX[#PX]) ^ 2 + (Y[1] - PY[#PY]) ^ 2)
            local m = #PX
            for k = n, 1, -1 do X[k + m], Y[k + m], U[k + m], Z[k + m] = X[k], Y[k], U[k], Z[k] end
            for k = 1, m do X[k], Y[k], U[k], Z[k] = PX[k], PY[k], false, PZ[k] end
            -- you more than a few yards off the cave's floor (on the hill over it, say): the first piece is a guess
            if m >= 2 and off > 6 then
                U[1] = true
                solid = solid - off
                added = added + off
            end
            n = n + m
            job.caveSolid = (job.caveSolid or 0) + 1
            head = false
        end
    end
    if tail then
        local d = sqrt((job.gx - X[n]) ^ 2 + (job.gy - Y[n]) ^ 2)
        if d > 0.5 then
            U[n] = true
            n = n + 1
            X[n], Y[n], U[n] = job.gx, job.gy, false
            added = added + d
        end
    end
    if head then
        local d = sqrt((job.sx - X[1]) ^ 2 + (job.sy - Y[1]) ^ 2)
        if d > 0.5 then
            for k = n, 1, -1 do X[k + 1], Y[k + 1], U[k + 1], Z[k + 1] = X[k], Y[k], U[k], Z[k] end
            X[1], Y[1], U[1], Z[1] = job.sx, job.sy, true, nil
            n = n + 1
            added = added + d
        end
    end
    job.n, job.len, job.unsure = n, (job.len or 0) + added + solid, (job.unsure or 0) + added
    job.cave = (head0 and 1 or 0) + (tail0 and 2 or 0)
end

local function solve(job)
    local co = coroutine.running()
    if co then solving[co] = true end
    if not P.ROUTES[job.route] then job.route = P.Route() end
    -- the 3D world first: where its data covers both ends of the trip it knows the real floors (bridges, buildings,
    -- caves) and every tree and rock in the way. Anywhere else, or if it finds nothing, the search below runs as before.
    local P3 = S.Path3D
    job.no3d, job.world3d = nil, nil
    if P3 then
        if P3.Solve(job, tick, P) then return end
        job.no3d = P3.why or "?"       -- why the 3D search passed this trip on; saved with the diagnostics
        if P3.broken then diag().path3d = P3.broken end
    else
        job.no3d = "not loaded"
    end
    local t = terrainFor(job.inst)
    if t then
        job.qsx, job.qsy, job.qgx, job.qgy, job.Z = nil, nil, nil, nil, nil
        local head, tail, gcave, scave = caveEnds(job, t)
        if head == "same" then
            -- both ends in one cave: through its floor when it's known
            local nt = gcave and caveNet(job.inst, gcave)
            local an, aw, bn, bw = job.sx, job.sy, job.gx, job.gy
            if job.swap then an, aw, bn, bw = aw, an, bw, bn end
            local ln, lw, lz
            if nt then ln, lw, lz = caveWay(nt, an, aw, false, bn, bw, false, job.floorS, job.floorG) end
            if ln then
                local X, Y, U, Z = { job.sx }, { job.sy }, {}, { lz[1] }
                local len = 0
                for k = 1, #ln do
                    local x, y = ln[k], lw[k]
                    if job.swap then x, y = y, x end
                    local d = sqrt((x - X[#X]) ^ 2 + (y - Y[#Y]) ^ 2)
                    if d > 0.5 then X[#X + 1], Y[#Y + 1] = x, y Z[#X] = lz[k] len = len + d end
                end
                job.Z = Z
                local d = sqrt((job.gx - X[#X]) ^ 2 + (job.gy - Y[#Y]) ^ 2)
                X[#X + 1], Y[#Y + 1] = job.gx, job.gy
                Z[#X] = lz[#lz]
                len = len + d
                for k = 1, #X do U[k] = false end
                -- an end more than a few yards off the cave's floor: that piece is a guess
                local unsure = 0
                local fx, fy = ln[1], lw[1]
                if job.swap then fx, fy = fy, fx end
                local d1 = sqrt((fx - job.sx) ^ 2 + (fy - job.sy) ^ 2) -- how far you stand from the cave's floor
                if d1 > 6 and #X >= 2 then U[1] = true unsure = unsure + d1 end
                if d > 6 then U[#X - 1] = true unsure = unsure + d end
                job.X, job.Y, job.U, job.n = X, Y, U, #X
                job.len, job.unsure, job.straight, job.mode, job.cell, job.cave, job.caveSolid = len, unsure,
                    sqrt((job.gx - job.sx) ^ 2 + (job.gy - job.sy) ^ 2), "terrain", t.cell, 3, 1
                return
            end
            -- not known: a straight guess between them
            local d = sqrt((job.gx - job.sx) ^ 2 + (job.gy - job.sy) ^ 2)
            job.X, job.Y, job.U, job.n = { job.sx, job.gx }, { job.sy, job.gy }, { true, false }, 2
            job.len, job.unsure, job.straight, job.mode, job.cell, job.cave = d, d, d, "terrain", t.cell, 3
            return
        end
        if solveTerrain(job, t) then
            if head or tail then caveFinish(job, head, tail, gcave, scave) end
            return
        end
        job.qsx, job.qsy, job.qgx, job.qgy = nil, nil, nil, nil
    end
    return solveKnown(job)
end
P.Solve = solve

-- run a search to the end at once (tests and tools)
function P.SolveNow(job)
    local co = coroutine.create(solve)
    local guardN = 0
    while coroutine.status(co) ~= "dead" do
        units, sliceStart = 0, clock and clock() or 0
        local ok, err = coroutine.resume(co, job)
        if not ok then error(err, 0) end
        guardN = guardN + 1
        if guardN > 1e6 then error("search runaway") end
    end
    job.slices = guardN
    return job
end

---------------------------------------------------------------- the paths being shown
-- Two lines, each with its own search and its own drawing: the guide's line (gold, to the arrow's target) and,
-- while you travel to someone in your group, a second line to that person in their colour (Nick 2026-11-15: "It
-- should just be a separe line from the quest routing"). The second one never touches the arrow, the travel plan
-- or the guide's line. One search runs at a time (they share the search's tables); the guide's goes first.
local function newLayer(name)
    return {
        name = name,
        path = nil,      -- { X, Y, U, n, inst, gx, gy, cum = {}, len }
        job = nil, jobCo = nil, -- the search under way
        jobAt = -100,
        progress = 0,    -- yards along the path
        shown = {},      -- the part still ahead: { x1, y1, x2, y2, ... } starting at you
        shownU = {},     -- shownU[p]: the piece that ends at point p is a guess
        shownN = 0,
        lines = {}, borders = {}, -- world map
        dots = {},       -- minimap
    }
end
local main = newLayer("main")
local party = newLayer("party")
local LAYERS = { main, party }

-- a pin you put on the world map yourself (the game's own map pin; Nick 2026-11-16 started it as a dev tool): since
-- 0.83.0 Waypoint.lua takes it up as a trip ("Go to anywhere") and the line follows the arrow; until it has, the line
-- goes straight to the pin. The pin Steward itself puts on the guide's step does not count.
local function pinTarget()
    if not (C_Map and C_Map.HasUserWaypoint and C_Map.GetUserWaypoint and C_Map.GetWorldPosFromMapPos) then return nil end
    if not C_Map.HasUserWaypoint() then return nil end
    local pt = C_Map.GetUserWaypoint()
    local pos = pt and pt.position
    if not (pt.uiMapID and pos and pos.x and pos.y) then return nil end
    local function same(m, x, y) return m == pt.uiMapID and abs(x - pos.x) < 0.002 and abs(y - pos.y) < 0.002 end
    local own = S.stewardPin or (StewardCharDB and StewardCharDB.stewardPin)   -- the last pin Steward put on the map itself
    if own and same(own[1], own[2], own[3]) then return nil end
    local el = G.activeGoto
    local r = el and el.go and S:ResolveGoto(el.go)
    if r and same(r.mapID, r.x, r.y) then return nil end
    local inst, world = C_Map.GetWorldPosFromMapPos(pt.uiMapID, pos)
    if not (inst and world) then return nil end
    if S.Secret(world.x, world.y, inst) then return nil end
    return world.x, world.y, inst, pt.uiMapID
end
P.PinTarget = pinTarget

-- where your body lies is given without a height: when you died indoors or in a cave, the floor with something over it
-- is the one meant (Nick 2026-11-16: died in the Grizzled Den, the line went to the ground above it)
local function corpseIndoors(el)
    if not (el and el.corpse) then return nil end
    local d = StewardCharDB and StewardCharDB.death
    if d and d.indoors ~= nil then return d.indoors end
    return nil
end

local goalIndoors          -- the guide target's floor: true under cover, false open sky, nil either (set by guideTarget)
local goalBottom          -- the guide target is on the lowest floor you can walk to at its spot (set by guideTarget)
-- cities whose floors stack: a spot given on the city's own map means the city's floor, and a spot has no height.
-- The Undercity lies under the Tirisfal ruins (a room of the ruins over the Trade Quarter is under cover too), so its
-- spots take the lowest dry floor; Thunder Bluff's spots are mostly in tents and the Pools of Vision, under the open
-- mesa top, so they take the floor under cover (2026-11-22)
local MAP_FLOOR = { [1458] = "bottom", [1456] = "cover" }
P.MAP_FLOOR = MAP_FLOOR
local function mapHint(mapID)
    local h = mapID and MAP_FLOOR[mapID]
    if h == "cover" then goalIndoors = true elseif h == "bottom" then goalBottom = true end
end
local goalLand              -- the goal's floor by its place among the floors there (an entrance under other floors)
local function guideTarget()
    goalIndoors, goalBottom, goalLand = nil, nil, nil
    if not S:Get("pathShow") then return nil end
    if UnitOnTaxi("player") or S.InInstance() then return nil end
    -- your own map pin (Waypoint.lua, "Go to anywhere"): the arrow's spot, the first stop of the trip or the pin
    -- itself, whether the guide is shown or not
    local pinTrip = G.stepGoto and G.stepGoto.pin
    if not pinTrip then
        local px, py, pinst, pmap = pinTarget()           -- a pin Waypoint.lua hasn't taken up yet
        if px then mapHint(pmap) return px, py, pinst end
        if not S:Get("guideShow") then return nil end
    end
    local el = G.activeGoto
    local go = el and el.go
    if not go then return nil end
    local r = S:ResolveGoto(go)
    if not (r and r.world and r.instance) then return nil end
    if S.Secret(r.world.x, r.world.y, r.instance) then return nil end
    goalIndoors = corpseIndoors(el)
    if goalIndoors == nil then mapHint(r.mapID) end
    if el.landG then goalLand = el.landG end            -- your pin by a buried entrance (Waypoint.lua S:UserPin)
    return r.world.x, r.world.y, r.instance
end

-- the group member you travel to (Waypoint.lua): where they stand now
local function partyTarget()
    if not S:Get("pathShow") then return nil end
    if not (S.FollowWorld and S:FollowName()) then return nil end
    if UnitOnTaxi("player") or S.InInstance() then return nil end
    -- a ride on the way (the tram, a flight, a boat; Travel.lua plans it): the line goes to where you get on it, and
    -- none while the next thing is to get on where you stand
    if S.FollowLeg then
        local lx, ly, linst = S:FollowLeg()
        if lx == false then return nil end
        if lx then return lx, ly, linst end
    end
    local x, y, inst = S:FollowWorld()
    if not x or S.Secret(x, y, inst) then return nil end
    return x, y, inst
end

local function setPath(L, j)
    if j.none or not j.X then L.path = nil return end
    local cum = { 0 }
    for k = 2, j.n do cum[k] = cum[k - 1] + sqrt((j.X[k] - j.X[k - 1]) ^ 2 + (j.Y[k] - j.Y[k - 1]) ^ 2) end
    L.path = { X = j.X, Y = j.Y, U = j.U, Z = j.Z, n = j.n, inst = j.inst, gx = j.gx, gy = j.gy, cum = cum, len = j.len, route = j.route,
        lift = j.lift, liftAt = j.liftAt, liftUp = j.liftUp }   -- a lift on the way (Path3D): the ride is points liftAt, liftAt + 1
    L.progress = 0
    local d = diag()
    if L ~= main then
        d.party = { len = floor(j.len), pts = j.n, mode = j.mode, ms = j.ms and floor(j.ms * 10) / 10, jobs = ((d.party or {}).jobs or 0) + 1 }
        return
    end
    d.jobs = (d.jobs or 0) + 1
    d.last = { mode = j.mode, route = j.route, len = floor(j.len), straight = floor(j.straight), pts = j.n, cell = j.cell,
        pops = j.pops, phase = j.phase, unsure = j.unsure and floor(j.unsure), pockets = j.pockets, climbs = j.climbs, far = j.far, cave = j.cave,
        cells = j.cells, known = j.known, walked = j.walked, roads = j.roads, ms = j.ms and floor(j.ms * 10) / 10,
        d3 = j.world3d and not j.no3d or nil, no3d = j.no3d, pops3d = j.pops3d }
    -- how many trips the 3D search answered, and why it passed the others on
    if j.world3d and not j.no3d then
        d.jobs3d = (d.jobs3d or 0) + 1
    elseif j.no3d then
        -- where the last few trips passed on started and ended (world yards), to look at in the workshop
        d.no3dAt = d.no3dAt or {}
        table.insert(d.no3dAt, 1, { j.no3d, floor(j.sx), floor(j.sy), floor(j.gx), floor(j.gy), j.inst })
        d.no3dAt[11] = nil
        d.no3d = d.no3d or {}
        d.no3d[j.no3d] = (d.no3d[j.no3d] or 0) + 1
    end
    if j.mode == "terrain" then
        d.terrainJobs = (d.terrainJobs or 0) + 1
        if (j.unsure or 0) > 0 then d.unsureJobs = (d.unsureJobs or 0) + 1 end
        if j.ms and j.ms > (d.slowest or 0) then d.slowest = floor(j.ms * 10) / 10 end
    end
    d.version = S.version
end

local function startJob(L, px, py, gx, gy, inst)
    L.job = { sx = px, sy = py, gx = gx, gy = gy, inst = inst, swap = S:WorldOrder() == "unitswap", ms = 0, route = P.Route(),
        floorS = P.FloorOf("player"), groundS = P.OnGround("player"),
        floorG = L ~= main and P.FloorOf("party") or nil, groundG = L ~= main and P.OnGround("party") or nil,
        indoorsG = nil }
    if L == main then
        L.job.indoorsG, L.job.bottomG = goalIndoors, goalBottom     -- true, false (open sky) or nil; lowest floor
        if goalLand then L.job.landG = goalLand end
        -- you in the Undercity (by the map you're on): you're on the city's floor, not in the ruins above it
        local m = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
        if m and MAP_FLOOR[m] == "bottom" then L.job.bottomS = true end
    end
    L.jobCo = coroutine.create(solve)
    L.jobAt = GetTime()
end

-- where you are along the path: distance from it, and how far along
local function project(L, px, py)
    local path, progress = L.path, L.progress
    local best, bestAt, bk, bt = huge, progress, nil, nil
    local X, Y, Z, cum = path.X, path.Y, path.Z, path.cum
    -- in a cave, on a floor that's been followed: only the pieces of the line on your floor count. A piece that runs
    -- over or under you (the next turn of a ramp, a room below) is not where you are along the line.
    local at, zt = floorOf.player, nil
    if Z and at and at.node then
        local nt = netByKey[at.key]
        zt = nt and nt.Z[at.node]
    end
    for k = 1, path.n - 1 do
        if cum[k + 1] >= progress - 30 and cum[k] <= progress + 150 then
            local ax, ay, bx, by = X[k], Y[k], X[k + 1], Y[k + 1]
            local dx, dy = bx - ax, by - ay
            local l2 = dx * dx + dy * dy
            local t = l2 > 0 and ((px - ax) * dx + (py - ay) * dy) / l2 or 0
            if t < 0 then t = 0 elseif t > 1 then t = 1 end
            local d = sqrt((px - ax - dx * t) ^ 2 + (py - ay - dy * t) ^ 2)
            local za, zb = zt and Z[k], zt and Z[k + 1]
            local other = za and zb and abs(za + (zb - za) * t - zt) > 5
            if d < best and not other then best, bestAt, bk, bt = d, cum[k] + sqrt(l2) * t, k, t end
        end
    end
    return best, bestAt, bk, bt
end

-- the part of the path still ahead, starting where you stand; tail: where the person you go to stands now, when
-- they've walked on from where the line was aimed
local function buildShown(L, px, py, tx, ty)
    L.shownN = 0
    local path = L.path
    if not path then return end
    local shown, shownU = L.shown, L.shownU
    local X, Y, U, cum = path.X, path.Y, path.U, path.cum
    shown[1], shown[2] = px, py
    local n = 2
    for k = 2, path.n do
        if cum[k] > L.progress + 10 or k == path.n then
            shown[n + 1], shown[n + 2] = X[k], Y[k]
            n = n + 2
            shownU[n / 2] = U and U[k - 1] or false
        end
    end
    if tx and (abs(tx - X[path.n]) > 3 or abs(ty - Y[path.n]) > 3) then
        shown[n + 1], shown[n + 2] = tx, ty
        n = n + 2
        shownU[n / 2] = false
    end
    L.shownN = n >= 4 and n or 0
end

---------------------------------------------------------------- drawing: world map
local COLOR = { 1, 0.82, 0 } -- the guide's line
local FAINT = { 0.78, 0.74, 0.62 } -- a piece that is a guess
-- the colour a layer is drawn in: the guide's gold, or the group member's own colour from the game (S:FollowColor)
local function layerRGB(L)
    if L ~= main then
        local c = S.FollowColor and S:FollowColor()
        if c then return c[1], c[2], c[3] end
        return 0.85, 0.85, 0.85 -- the game hasn't said their class yet
    end
    return COLOR[1], COLOR[2], COLOR[3]
end
local mapFrame
local mapHooked = false
local function hideMapLayer(L)
    for i = 1, #L.lines do L.lines[i]:Hide() L.borders[i]:Hide() end
end
local function hideMap()
    for _, L in ipairs(LAYERS) do hideMapLayer(L) end
end

local function drawMapLayer(L, wm, mapID, z)
    local path, shown, shownU, shownN = L.path, L.shown, L.shownU, L.shownN
    if shownN < 4 or not path then hideMapLayer(L) return end
    if not (z and z.inst == path.inst) then hideMapLayer(L) return end
    local canvas = wm:GetCanvas()
    if not canvas then return end
    if not mapFrame then
        mapFrame = CreateFrame("Frame", nil, canvas)
        mapFrame:SetAllPoints(canvas)
        if not mapFrame.CreateLine then diag().noLines = true hideMap() return end
    end
    mapFrame:SetFrameStrata(canvas:GetFrameStrata())
    mapFrame:SetFrameLevel(2010)
    mapFrame:Show()
    local cw, ch = canvas:GetWidth(), canvas:GetHeight()
    local scale = 1
    if mapFrame.GetEffectiveScale and UIParent.GetEffectiveScale then
        local a, b = mapFrame:GetEffectiveScale(), UIParent:GetEffectiveScale()
        if a and b and a > 0 and b > 0 then scale = a / b end
    end
    local r, g, b = layerRGB(L)
    -- the guide's line on top where the two cross
    local sub = L == main and -5 or -7
    local det = z.ax * z.by - z.bx * z.ay
    local used = 0
    local pu, pv
    local mapLines, mapBorders = L.lines, L.borders
    for k = 1, shownN - 1, 2 do
        local wx, wy = shown[k] - z.ox, shown[k + 1] - z.oy
        local u, v = (wx * z.by - z.bx * wy) / det, (z.ax * wy - wx * z.ay) / det
        if pu and not ((pu < 0 and u < 0) or (pu > 1 and u > 1) or (pv < 0 and v < 0) or (pv > 1 and v > 1)) then
            used = used + 1
            local line, border = mapLines[used], mapBorders[used]
            if not line then
                border = mapFrame:CreateLine(nil, "OVERLAY")
                border:SetDrawLayer("OVERLAY", sub - 1)
                line = mapFrame:CreateLine(nil, "OVERLAY")
                line:SetDrawLayer("OVERLAY", sub)
                mapLines[used], mapBorders[used] = line, border
            end
            local guess = shownU[(k + 1) / 2] or false
            line.guess = guess
            local thick = (guess and 2 or 3) / scale
            if guess then
                line:SetColorTexture(FAINT[1], FAINT[2], FAINT[3], 0.55)
                border:SetColorTexture(0, 0, 0, 0.25)
            else
                line:SetColorTexture(r, g, b, 0.95)
                border:SetColorTexture(0, 0, 0, 0.55)
            end
            line:SetStartPoint("TOPLEFT", pu * cw, -pv * ch)
            line:SetEndPoint("TOPLEFT", u * cw, -v * ch)
            line:SetThickness(thick)
            border:SetStartPoint("TOPLEFT", pu * cw, -pv * ch)
            border:SetEndPoint("TOPLEFT", u * cw, -v * ch)
            border:SetThickness(thick + 2 / scale)
            line:Show()
            border:Show()
        end
        pu, pv = u, v
    end
    for i = used + 1, #mapLines do mapLines[i]:Hide() mapBorders[i]:Hide() end
    diag().mapDraws = (diag().mapDraws or 0) + 1
end

local function drawMap(only)
    local wm = _G.WorldMapFrame
    if not (wm and wm.GetCanvas and wm.IsShown and wm:IsShown()) then return end
    local mapID = wm.GetMapID and wm:GetMapID()
    local z = mapID and zoneInfo(mapID)
    for _, L in ipairs(LAYERS) do
        if not only or only == L then drawMapLayer(L, wm, mapID, z) end
    end
end

local function hookMap()
    if mapHooked then return end
    local wm = _G.WorldMapFrame
    if not (wm and wm.GetCanvas) then return end
    mapHooked = true
    local function redraw() guard("map", drawMap) end
    if wm.HookScript then
        wm:HookScript("OnShow", redraw)
        wm:HookScript("OnShow", function() if P.RefreshSwitches then P.RefreshSwitches() end end)
    end
    if wm.OnMapChanged then hooksecurefunc(wm, "OnMapChanged", redraw) end
    if wm.OnCanvasScaleChanged then hooksecurefunc(wm, "OnCanvasScaleChanged", redraw) end
end

---------------------------------------------------------------- drawing: minimap
local miniFrame
local MAX_DOTS = 36
local ZOOM_IN = { 300, 240, 180, 120, 80, 50 }
local ZOOM_OUT = { 466.67, 400, 333.33, 266.67, 200, 133.33 }
local function hideMiniLayer(L)
    for i = 1, #L.dots do L.dots[i]:Hide() end
end
local function hideMini()
    for _, L in ipairs(LAYERS) do hideMiniLayer(L) end
end

local function viewRadius()
    if C_Minimap and C_Minimap.GetViewRadius then
        local r = C_Minimap.GetViewRadius()
        if r and not S.Secret(r) and r > 0 then return r end
    end
    local zoom = Minimap.GetZoom and Minimap:GetZoom() or 0
    local outdoor = true
    if GetCVar then
        local cv = tonumber(GetCVar("minimapZoom") or "")
        outdoor = cv == nil or cv == zoom
    end
    return ((outdoor and ZOOM_OUT or ZOOM_IN)[zoom + 1] or 466.67) / 2
end

local function drawMiniLayer(L)
    local mm = _G.Minimap
    if not mm then return end
    local path, shown, shownU, shownN, dots = L.path, L.shown, L.shownU, L.shownN, L.dots
    if shownN < 4 or not path then hideMiniLayer(L) return end
    local order = S:WorldOrder()
    if order ~= "unitdirect" and order ~= "unitswap" then hideMiniLayer(L) return end
    local px, py, inst = S:PlayerWorld()
    if not px or inst ~= path.inst then hideMiniLayer(L) return end
    if not miniFrame then
        miniFrame = CreateFrame("Frame", nil, mm)
        miniFrame:SetAllPoints(mm)
        miniFrame:SetFrameLevel((mm:GetFrameLevel() or 0) + 3)
    end
    local radius = viewRadius()
    local half = (mm:GetWidth() or 140) / 2
    if half <= 0 then hideMiniLayer(L) return end
    local pxPerYard = half / radius
    local rotate = GetCVar and GetCVar("rotateMinimap") == "1"
    local cf, sf = 1, 0
    if rotate then
        local facing = GetPlayerFacing and GetPlayerFacing()
        if not facing or S.Secret(facing) then hideMiniLayer(L) return end
        cf, sf = math.cos(facing), math.sin(facing)
    end
    local r, g, b = layerRGB(L)
    local round = not (GetMinimapShape and GetMinimapShape() == "SQUARE")
    local limit = half * 0.88
    local spacing = 9 / pxPerYard -- a dot every 9 pixels
    local used = 0
    local nextAt = 12 / pxPerYard
    local travelled = 0
    local ax, ay = shown[1], shown[2]
    for k = 3, shownN - 1, 2 do
        local bx, by = shown[k], shown[k + 1]
        local guess = shownU[(k + 1) / 2]
        local seg = sqrt((bx - ax) ^ 2 + (by - ay) ^ 2)
        while seg > 0 and nextAt <= travelled + seg and used < MAX_DOTS do
            local t = (nextAt - travelled) / seg
            local dx, dy = ax + (bx - ax) * t - px, ay + (by - ay) * t - py
            local north, west = dx, dy
            if order == "unitswap" then north, west = dy, dx end
            -- screen: east is right, north is up; a turning minimap keeps the way you face up
            local sx = -(west * cf - north * sf) * pxPerYard
            local sy = (north * cf + west * sf) * pxPerYard
            local inside
            if round then inside = sx * sx + sy * sy <= limit * limit
            else inside = abs(sx) <= limit and abs(sy) <= limit end
            if not inside then travelled = huge break end
            used = used + 1
            local dot = dots[used]
            if not dot then
                dot = miniFrame:CreateTexture(nil, "OVERLAY", nil, L == main and 2 or 1)
                dots[used] = dot
            end
            if guess then
                dot:SetSize(3, 3)
                dot:SetColorTexture(FAINT[1], FAINT[2], FAINT[3], 0.6)
            else
                dot:SetSize(4, 4)
                dot:SetColorTexture(r, g, b, 0.95)
            end
            dot.guess = guess or false
            dot:ClearAllPoints()
            dot:SetPoint("CENTER", miniFrame, "CENTER", sx, sy)
            dot:Show()
            nextAt = nextAt + spacing
        end
        if travelled == huge or used >= MAX_DOTS then break end
        travelled = travelled + seg
        ax, ay = bx, by
    end
    for i = used + 1, #dots do dots[i]:Hide() end
    if used > 0 then diag().miniDraws = (diag().miniDraws or 0) + 1 end
end

local function drawMini()
    for _, L in ipairs(LAYERS) do drawMiniLayer(L) end
end

-- a world spot on the minimap, the same way the line's dots are placed: pixels right and up from its centre, whether it
-- lies inside the minimap, and the minimap; nil when that can't be worked out (0.90.1: the step's other spots)
function P.MiniSpot(wx, wy, winst)
    local mm = _G.Minimap
    if not (mm and wx and wy) then return nil end
    local order = S:WorldOrder()
    if order ~= "unitdirect" and order ~= "unitswap" then return nil end
    local px, py, inst = S:PlayerWorld()
    if not px or inst ~= winst then return nil end
    local radius = viewRadius()
    local half = (mm:GetWidth() or 140) / 2
    if half <= 0 or not radius or radius <= 0 then return nil end
    local pxPerYard = half / radius
    local cf, sf = 1, 0
    if GetCVar and GetCVar("rotateMinimap") == "1" then
        local facing = GetPlayerFacing and GetPlayerFacing()
        if not facing or S.Secret(facing) then return nil end
        cf, sf = math.cos(facing), math.sin(facing)
    end
    local north, west = wx - px, wy - py
    if order == "unitswap" then north, west = west, north end
    local sx = -(west * cf - north * sf) * pxPerYard
    local sy = (north * cf + west * sf) * pxPerYard
    local limit = half * 0.88
    local inside
    if not (GetMinimapShape and GetMinimapShape() == "SQUARE") then inside = sx * sx + sy * sy <= limit * limit
    else inside = abs(sx) <= limit and abs(sy) <= limit end
    return sx, sy, inside, mm
end

local function hideLayer(L)
    hideMapLayer(L)
    hideMiniLayer(L)
    L.shownN = 0
end

hideAll = function()
    for _, L in ipairs(LAYERS) do hideLayer(L) end
end

---------------------------------------------------------------- the switch: Fastest / Stick to roads
-- In the world map's top right corner, and beside the guide's header in the quest tracker; the options'
-- Guide page has the same choice. Switching changes how this line is chosen and nothing else. A fault
-- here hides the switch (and leaves a note) but leaves the line itself alone.
local ROUTE_NAME = { fastest = "Fastest", roads = "Stick to roads" }
local ROUTE_SHORT = { fastest = "Fastest", roads = "Roads" }
local switchBroken = false
local mapSwitch, headSwitch, mapRound
-- the round button's pictures: the game's own spell icons (a winged boot; a compass), with a stand-in each in case
-- a client lacks one
local ROUTE_ICON = {
    fastest = { "Interface\\ICONS\\Ability_Rogue_Sprint", "Interface\\ICONS\\Spell_Nature_Swiftness" },
    roads = { "Interface\\ICONS\\Ability_Hunter_Pathfinding", "Interface\\ICONS\\INV_Misc_Map_01" },
}
local function routeIcon(r)
    local list = ROUTE_ICON[r] or ROUTE_ICON.fastest
    if GetFileIDFromPath then
        for _, path in ipairs(list) do if GetFileIDFromPath(path) then return path end end
    end
    return list[1]
end
local function mapStyle()
    return S:Get("pathMapSwitch") == "round" and "round" or "box"
end

-- choose how the line goes: "fastest" or "roads"
function P.SetRoute(r)
    if not P.ROUTES[r] or r == P.Route() or not StewardDB then return end
    StewardDB.pathRoute = r
    if SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON then pcall(PlaySound, SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end
    P.SettingChanged()
end

local function switchWanted()
    return (S:Get("guideShow") or (G.stepGoto and G.stepGoto.pin) or (S.FollowName and S:FollowName())) and S:Get("pathShow") and not broken
end

local function routeTooltip(owner, anchor, hint)
    GameTooltip:SetOwner(owner, anchor)
    GameTooltip:SetText("The way on the map")
    local cur = P.Route()
    local function line(r, text)
        local on = cur == r
        GameTooltip:AddLine((on and "|cffffd100" or "|cff9d9d9d") .. ROUTE_NAME[r] .. (on and " (on)" or "") .. ":|r " .. text, 1, 1, 1, true)
    end
    line("fastest", "the shortest way to where the arrow points.")
    line("roads", "keeps to roads, bridges and tunnels wherever they lead there, even if that's longer. Safer where the monsters are too high to fight.")
    if hint then GameTooltip:AddLine(hint, 0.5, 0.8, 1, true) end
    GameTooltip:Show()
end

-- world map: two buttons side by side, the chosen one lit, below whatever the map keeps in that corner
local function makeMapSwitch(wm)
    local f = CreateFrame("Frame", nil, wm, BackdropTemplateMixin and "BackdropTemplate" or nil)
    f:SetFrameStrata("HIGH")
    f:SetSize(150, 24)
    if f.SetBackdrop then
        f:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 } })
        f:SetBackdropColor(0, 0, 0, 0.75)
        f:SetBackdropBorderColor(0.6, 0.5, 0.3)
    end
    f.buttons = {}
    local x = 4
    for i, r in ipairs(P.ROUTE_ORDER) do
        local b = CreateFrame("Button", nil, f)
        b.route = r
        b.lit = b:CreateTexture(nil, "BORDER")
        b.lit:SetPoint("TOPLEFT", 1, -1)
        b.lit:SetPoint("BOTTOMRIGHT", -1, 1)
        b.lit:SetColorTexture(1, 0.82, 0, 0.2)
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        b.text:SetPoint("CENTER")
        b.text:SetText(ROUTE_NAME[r])
        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints(b.lit)
        hl:SetColorTexture(1, 1, 1, 0.12)
        local w = floor((b.text:GetStringWidth() or 60) + 16)
        b:SetSize(w, 18)
        b:SetPoint("LEFT", f, "LEFT", x, 0)
        x = x + w
        b:SetScript("OnClick", function(self) P.SetRoute(self.route) end)
        b:SetScript("OnEnter", function(self) routeTooltip(self, "ANCHOR_BOTTOMLEFT", "Click one to switch. It only changes this line.") end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        f.buttons[i] = b
    end
    f:SetWidth(x + 4)
    return f
end

-- option B: a round button made like the map's own pin button (the same textures: the minimap button's dark disc,
-- its gold ring and its glow), showing a winged boot for Fastest and a compass for Stick to roads
local function makeMapRound(wm)
    local b = CreateFrame("Button", nil, wm)
    b:SetFrameStrata("HIGH")
    b:SetSize(32, 32)
    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    bg:SetSize(25, 25)
    bg:SetPoint("TOPLEFT", 3, -4)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(20, 20)
    b.icon:SetPoint("TOPLEFT", 7, -6)
    if b.CreateMaskTexture and b.icon.AddMaskTexture then
        local mask = b:CreateMaskTexture()
        mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetAllPoints(b.icon)
        b.icon:AddMaskTexture(mask)
    end
    b.shade = b:CreateTexture(nil, "OVERLAY")
    b.shade:SetAllPoints(b.icon)
    b.shade:SetColorTexture(0, 0, 0, 0.3)
    b.shade:Hide()
    local ring = b:CreateTexture(nil, "OVERLAY", nil, 1)
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    ring:SetSize(54, 54)
    ring:SetPoint("TOPLEFT")
    b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
    -- pressed: the picture sinks a little and darkens, as the map's own buttons do
    b:SetScript("OnMouseDown", function(self) self.icon:SetPoint("TOPLEFT", 8, -8) self.shade:Show() end)
    b:SetScript("OnMouseUp", function(self) self.icon:SetPoint("TOPLEFT", 7, -6) self.shade:Hide() end)
    b:SetScript("OnClick", function() P.SetRoute(P.Route() == "fastest" and "roads" or "fastest") end)
    b:SetScript("OnEnter", function(self)
        routeTooltip(self, "ANCHOR_BOTTOMLEFT", "Click to switch to " .. ROUTE_NAME[P.Route() == "fastest" and "roads" or "fastest"] .. ". It only changes the line.")
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end

-- the top right corner of the map, below the buttons the map itself keeps there (they stack downwards)
local function placeAtCorner(frame, wm, inset)
    local box = (wm.GetCanvasContainer and wm:GetCanvasContainer()) or wm.ScrollContainer or wm:GetCanvas()
    local y = -inset
    for _, f in ipairs(type(wm.overlayFrames) == "table" and wm.overlayFrames or {}) do
        if f ~= mapSwitch and f ~= mapRound and f.IsShown and f:IsShown() and f.GetNumPoints and f:GetNumPoints() == 1 then
            local p, rel, rp, _, oy = f:GetPoint(1)
            if p == "TOPRIGHT" and rel == box and rp == "TOPRIGHT" and type(oy) == "number" then
                local bottom = oy - (f:GetHeight() or 32) - 4
                if bottom < y then y = bottom end
            end
        end
    end
    frame:ClearAllPoints()
    frame:SetPoint("TOPRIGHT", box, "TOPRIGHT", -inset, y)
end

-- the guide's header in the quest tracker: the chosen way in a word, left of the header's minimize button
local function makeHeadSwitch(header)
    local b = CreateFrame("Button", nil, header)
    b:SetHeight(16)
    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    b.text:SetPoint("RIGHT", -2, 0)
    local hl = b:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(1, 1, 1, 0.1)
    if header.MinimizeButton then
        b:SetPoint("RIGHT", header.MinimizeButton, "LEFT", -4, 0)
    else
        b:SetPoint("RIGHT", header, "RIGHT", -22, 0)
    end
    -- the header's own title stops short of it (it shrinks its letters to fit, as it does for a long title)
    if header.Text and header.Text.SetPoint then header.Text:SetPoint("RIGHT", b, "LEFT", -4, 0) end
    b:SetScript("OnClick", function() P.SetRoute(P.Route() == "fastest" and "roads" or "fastest") end)
    b:SetScript("OnEnter", function(self)
        routeTooltip(self, "ANCHOR_LEFT", "Click to switch to " .. ROUTE_NAME[P.Route() == "fastest" and "roads" or "fastest"] .. ". It only changes the line.")
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end

local function refreshSwitches()
    local want, r = switchWanted(), P.Route()
    local style = mapStyle()
    local wm = _G.WorldMapFrame
    -- the box (option A, the default)
    local wantBox = want and style == "box"
    if wm and wm.GetCanvas and (mapSwitch or wantBox) then
        if not mapSwitch then mapSwitch = makeMapSwitch(wm) end
        if wantBox then
            placeAtCorner(mapSwitch, wm, 6)
            for _, b in ipairs(mapSwitch.buttons) do
                local on = b.route == r
                b.lit:SetShown(on)
                if on then b.text:SetTextColor(1, 0.82, 0) else b.text:SetTextColor(0.62, 0.62, 0.62) end
            end
        end
        mapSwitch:SetShown(wantBox)
    end
    -- or the round button (option B), where the map keeps its own round buttons
    local wantRound = want and style == "round"
    if wm and wm.GetCanvas and (mapRound or wantRound) then
        if not mapRound then mapRound = makeMapRound(wm) end
        if wantRound then
            placeAtCorner(mapRound, wm, 4)
            local path = routeIcon(r)
            if mapRound.iconPath ~= path then
                mapRound.icon:SetTexture(path)
                mapRound.iconPath = path
            end
        end
        mapRound:SetShown(wantRound)
    end
    local m = _G.StewardGuideObjectiveTracker
    local header = type(m) == "table" and m.Header
    if header and (headSwitch or want) then
        if not headSwitch then headSwitch = makeHeadSwitch(header) end
        headSwitch.text:SetText(ROUTE_SHORT[r])
        headSwitch:SetWidth(floor((headSwitch.text:GetStringWidth() or 40) + 6))
        headSwitch:SetShown(want)
    end
end

function P.RefreshSwitches()
    if switchBroken then return end
    local ok, err = pcall(refreshSwitches)
    if not ok then
        switchBroken = true
        diag().switchErr = tostring(err)
        if mapSwitch then pcall(mapSwitch.Hide, mapSwitch) end
        if mapRound then pcall(mapRound.Hide, mapRound) end
        if headSwitch then pcall(headSwitch.Hide, headSwitch) end
    end
end
function P.Switches() return mapSwitch, headSwitch, mapRound end

---------------------------------------------------------------- the loop
-- one search at a time across both lines: a layer may start one only when the other has none under way
local function busy(L)
    for _, o in ipairs(LAYERS) do if o ~= L and o.jobCo then return true end end
    return false
end

local function updateLayer(L)
    local walking = L ~= main -- its target walks: a group member
    local gx, gy, inst
    if walking then gx, gy, inst = partyTarget() else gx, gy, inst = guideTarget() end
    local px, py, pinst
    if gx then px, py, pinst = S:PlayerWorld() end
    if not (gx and px) or pinst ~= inst then
        L.path, L.job, L.jobCo, L.wants = nil, nil, nil, nil
        hideLayer(L)
        return
    end
    local dist = sqrt((gx - px) ^ 2 + (gy - py) ^ 2)
    -- near enough for the arrow alone. Not so in a cave: 40 yd away on the map can be a floor up and a long way
    -- round, so there the line stays until the way left along it is short
    local caved = (floorOf.player and floorOf.player.node) or (walking and floorOf.party and floorOf.party.node)
    local near = dist < P.MIN_DIST
    if near and caved then
        local p = L.path
        near = dist < 12 and (not p or not p.len or p.len - L.progress < 15)
    end
    if near then
        L.path, L.job, L.jobCo, L.wants = nil, nil, nil, nil
        hideLayer(L)
        return
    end
    -- a search for another target, or made the other way (fastest / roads), is no use any more; for someone who
    -- walks, a search on its way isn't dropped until they've gone 30 yd from where it was aimed
    local route = P.Route()
    local slack = walking and 30 or 5
    local job = L.job
    if job and (job.inst ~= inst or abs(job.gx - gx) > slack or abs(job.gy - gy) > slack or job.route ~= route) then
        L.job, L.jobCo = nil, nil
    end
    local path = L.path
    local fresh = path and path.inst == inst and abs(path.gx - gx) <= 5 and abs(path.gy - gy) <= 5
    -- someone who walks: the line stays up (and reaches on to where they are now) while a new one is found
    local moving = false
    if not fresh then
        if walking and path and path.inst == inst then moving = true else L.path, path = nil, nil end
    end
    -- a line made the other way stays up until the new one is ready
    local other = path and path.route ~= route
    local off, qx, qy
    if path then
        local k, t
        off, L.progress, k, t = project(L, px, py)
        if k then qx, qy = path.X[k] + (path.X[k + 1] - path.X[k]) * t, path.Y[k] + (path.Y[k + 1] - path.Y[k]) * t end
        -- in a cave: the line there runs on a floor over or under the one you're on -> off it (the map is flat, the
        -- cave isn't)
        local Z, at = path.Z, floorOf.player
        if Z and k and at and at.node then
            local za, zb = Z[k], Z[k + 1]
            local z = za and zb and (za + (zb - za) * t) or za or zb
            local nt = z and netByKey[at.key]
            if nt and abs(nt.Z[at.node] - z) > 5 then off = huge end
        end
    end
    -- the straight piece from you to the line: when a wall or a cliff cuts it, plan again (it is only kept while it's clear)
    local blocked = false
    local P3 = S.Path3D
    if path and qx and off and off > P.CLEAR_FROM and off <= P.STRAY and P3 and P3.Clear then
        local c = L.clearAt
        if c and c[4] == path and abs(c[1] - px) < 1 and abs(c[2] - py) < 1 then
            blocked = c[3]
        else
            local ok, res = pcall(P3.Clear, inst, px, py, qx, qy, IsIndoors and IsIndoors() or nil)
            blocked = ok and res == false
            L.clearAt = { px, py, blocked, path }
        end
    end
    local want = not L.job and (not path or other or moving or off > P.STRAY or blocked)
    local wait = (path and not other) and (moving and 1 or 2) or 0.3
    L.wants = want or nil
    if want and GetTime() - L.jobAt >= wait and not busy(L) and not (L ~= main and main.wants) then
        startJob(L, px, py, gx, gy, inst)
        L.wants = nil
    end
    buildShown(L, px, py, walking and gx, walking and gy)
    if L.shownN == 0 then hideLayer(L) return end
    drawMap(L)
end

local function update()
    hookMap()
    for _, L in ipairs(LAYERS) do updateLayer(L) end
end

local function runJob()
    for _, L in ipairs(LAYERS) do
        if L.jobCo then
            local t0 = clock and clock() or 0
            units, sliceStart = 0, t0
            local ok, err = coroutine.resume(L.jobCo, L.job)
            if clock then L.job.ms = L.job.ms + (clock() - t0) end
            if not ok then error(err, 0) end
            if coroutine.status(L.jobCo) == "dead" then
                local j = L.job
                L.job, L.jobCo = nil, nil
                setPath(L, j)
                update()
            end
            return
        end
    end
end

function P.Update() guard("update", update) end
function P.RunJob() guard("search", runJob) end
function P.DrawMinimap() guard("minimap", drawMini) end
function P.State() return main.path, main.shown, main.shownN, main.job, main.shownU end

-- A lift on the guide's line (or your map pin's; Path3D's job.lift): where you are with it (Nick 11-22: "sure, do
-- number 1", the "Take the lift" line). "ahead": not there yet; "near": within 40 yd of where you get on; "ride":
-- at that landing or on the lift, until you've walked 25 yd off both landings. -> state, the lift's name, up (true)
-- or down (false); nil when there's no lift still to ride
P.LIFT_NEAR, P.LIFT_ON, P.LIFT_OFF = 40, 12, 25
function P.LiftNote()
    local p = main.path
    if not (p and p.lift and p.liftAt and p.liftAt < p.n) or p.liftDone then return nil end
    local px, py, pinst = S:PlayerWorld()
    if not px or pinst ~= p.inst then return nil end
    local k = p.liftAt
    local db = sqrt((px - p.X[k]) ^ 2 + (py - p.Y[k]) ^ 2)
    local de = sqrt((px - p.X[k + 1]) ^ 2 + (py - p.Y[k + 1]) ^ 2)
    local state
    if p.liftOn then
        if db > P.LIFT_OFF and de > P.LIFT_OFF then p.liftDone = true return nil end
        state = "ride"
    elseif db <= P.LIFT_ON then
        p.liftOn, state = true, "ride"
    elseif db <= P.LIFT_NEAR then
        state = "near"
    else
        state = "ahead"
    end
    return state, p.lift, p.liftUp
end
-- the words for it: the tracker's line and the arrow's
function P.LiftText()
    local state, name, up = P.LiftNote()
    if not state then return nil end
    local way = up and "up" or "down"
    if state == "ride" then return "Ride the lift " .. way, "Ride the lift " .. way .. " (" .. name .. ")", state end
    if state == "near" then return "Take the lift " .. way, "Take the lift " .. way .. ": it's just ahead (" .. name .. ")", state end
    return nil, "Take the lift " .. way .. ": " .. name, state
end
-- the tracker and the arrow follow it as you go (looked at twice a second; redrawn only when it changes)
local liftKey
C_Timer.NewTicker(0.5, function()
    local ok, short, full, state = pcall(P.LiftText)
    local key = ok and full and (state .. "|" .. full) or nil
    if key == liftKey then return end
    liftKey = key
    if S.RefreshGuideUI then pcall(S.RefreshGuideUI, S) end
    if S.UpdateArrow then pcall(S.UpdateArrow, S) end
end)
-- the height of the guide's line where you are along it (set inside caves only), for tests and the saved notes
-- -> height or nil, how far you are from the line
function P.LineHeight()
    local path = main.path
    if not path then return nil end
    local px, py = S:PlayerWorld()
    if not px then return nil end
    local off, _, k, t = project(main, px, py)
    if not (k and path.Z) then return nil, off end
    local za, zb = path.Z[k], path.Z[k + 1]
    return za and zb and (za + (zb - za) * t) or za or zb, off
end
function P.Dots() return main.dots end
-- the second line, to the group member you travel to
function P.PartyState() return party.path, party.shown, party.shownN, party.job, party.shownU end
function P.PartyDots() return party.dots end
function P.PartyLines() return party.lines end
function P.Lines() return main.lines end

-- called when a setting of this layer changes (shown or not, fastest or roads): nothing but this layer is touched
function P.SettingChanged()
    for _, L in ipairs(LAYERS) do L.jobAt = -100 end
    failed = nil
    guard("update", update)
    guard("minimap", drawMini)
    P.RefreshSwitches()
end

local driver = CreateFrame("Frame")
local sinceMini = 0
local fallT, fell = 0, nil -- how long you've been in the air; the last fall, for the floor following
driver:SetScript("OnUpdate", function(_, e)
    if broken then return end
    if IsFalling and IsFalling() then fallT = fallT + (e or 0)
    elseif fallT > 0 then fell, fallT = fallT, 0 end
    if main.jobCo or party.jobCo then guard("search", runJob) end
    sinceMini = sinceMini + (e or 0)
    if sinceMini >= 0.05 then
        sinceMini = 0
        guard("minimap", drawMini)
    end
end)

local floorBroken = false
local function followFloors(tickN)
    local x, y, inst
    if not (UnitOnTaxi("player") or S.InInstance()) then x, y, inst = S:PlayerWorld() end
    if fallT == 0 then
        P.TrackFloor("player", x, y, inst, fell, (IsIndoors and IsIndoors()) and true or false)
        fell = nil
    end
    local fx, fy, finst
    if S.FollowWorld and S:FollowName() then fx, fy, finst = S:FollowWorld() end
    P.TrackFloor("party", fx, fy, finst)
    -- for the next look at your saved data: where the following has you
    if tickN % 20 == 0 then
        local f = P.FloorOf("player")
        diag().floor = f and string.format("%s node %d height %.1f", f.key, f.node, f.z or 0) or (P.OnGround("player") and "ground" or "not known")
    end
end
local n, idle = 0, 0
C_Timer.NewTicker(0.25, function()
    if broken then return end
    n = n + 1
    if n % 2 == 0 and S:Get("pathShow") then guard("footsteps", recordStep) end
    -- which floor you (and the group member you travel to) are on. A fault here stops the following only: the
    -- line itself goes on as it did before there was any (noted in the saved data).
    if not floorBroken then
        local ok, err = pcall(followFloors, n)
        if not ok then
            floorBroken = true
            P.ForgetFloors()
            -- with the version and the time: an old one stays in the saved data until the next one
            diag().floorErr = string.format("%s %s: %s", tostring(S.version), date and date("%m-%d %H:%M") or "", tostring(err))
        end
    end
    guard("update", update)
    if n % 4 == 1 then P.RefreshSwitches() end
    -- nothing to draw for a minute: let go of the terrain rows that were read
    if main.path or main.job or party.path or party.job then idle = 0 else
        idle = idle + 1
        if idle == 240 then P.DropTerrainCache() end
    end
end)
