-- Steward: the route search in the 3D walkable world.
-- Path3DData_<map>.lua holds, for the zones that are finished, every piece of floor you can walk or swim to (ground,
-- bridges, building floors, cave floors, stairs): the world as the game's own collision shapes make it. A square of
-- 8.33 yd can hold several pieces over each other (a bridge and the river bed under it); where two pieces meet on a
-- square's border there is a crossing. A route is searched from crossing to crossing and then pulled tight through
-- the stretch of border each crossing leaves open.
-- Where the data does not cover both ends of a trip, or anything at all goes wrong in here, this file answers "no" and
-- Path.lua's older search draws the line as before.
local _, S = ...
local P3 = {}
S.Path3D = P3
S.defaults.path3D = true     -- the 3D routes are used where they are mapped (Options: Guide)

local floor, sqrt, byte, min, max, abs, huge = math.floor, math.sqrt, string.byte, math.min, math.max, math.abs, math.huge
local ceil = math.ceil

P3.POPS = 150000      -- crossings one search may visit before the trip is left to the older search ...
P3.POPS_BASE = 6000   -- ... and for a short trip fewer: this many ...
P3.POPS_PER = 45      -- ... plus this many for every yard between the two ends (a way that needs more is a long way round)
P3.MAX_YARDS = 4000   -- without the rough map (older data): a longer trip (straight line) is left to the older search
P3.NEAR = 1500        -- a trip shorter than this is tried by the exact search alone first; a longer one is planned
                      -- over the rough map (the doorways between map tiles) and then worked out piece by piece
P3.PIECE = 800        -- yards a piece of a long trip reaches ahead ...
P3.COMMIT = 0.8       -- ... of which this much is kept before the next piece starts (its far end is only a doorway)
P3.WEIGHT_LONG = 1.2  -- the pull in a piece of a long trip (Fastest; 1.05 was tried: same line, a third slower)
P3.WEIGHT_LONG_ROADS = 1.3 -- the same in Stick to roads. 1.6 was tried (0.89.3: 14-20% less work, cost within 2%) and taken back:
                            -- half the trips walked 50-300 yd more off the road, none fewer (Nick: roads are for safety)
P3.PIECE_POPS = 40000 -- crossings one piece may visit
P3.KEEP_LAST = true   -- a piece of a long trip keeps the tiles of the piece before it unpacked too
P3.ATTACH = 30000     -- crossings to find the doorways of an end's own tile
P3.WEIGHT = 1.1       -- how hard the search pulls towards the goal (1 = the cheapest way exactly, slowest). The way is pulled
                      -- tight afterwards, so a little pull costs next to nothing in the line and saves most of the search
P3.WEIGHT_ROADS = 1.3 -- the same in Stick to roads, where a yard of road is cheap and the plain guess is weak
P3.REACH = 10         -- an end may be this far from floor (yards)
P3.KEEP = 80          -- unpacked map tiles kept; more than this and all are dropped after a search
P3.FEL = 12           -- a yard through fel liquid: only when the way round is twelve times as long
P3.FORMAT = 1
P3.CLEAR_GAP = 1.5   -- P3.Clear: a straight piece may cross this many yards with no floor (a corner, a tree trunk)

---------------------------------------------------------------- unpacking a tile
local B64 = {}
do
    local a = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i = 1, 64 do B64[byte(a, i)] = i - 1 end
end
local function bytesOf(s)
    local out, n, len, i = {}, 0, #s, 1
    while i + 3 <= len do
        local a, b, c, d = byte(s, i, i + 3)
        local v = B64[a] * 262144 + B64[b] * 4096 + B64[c] * 64 + B64[d]
        out[n + 1], out[n + 2], out[n + 3] = floor(v / 65536), floor(v / 256) % 256, v % 256
        n, i = n + 3, i + 4
    end
    local rem = len - i + 1
    if rem == 2 then
        local a, b = byte(s, i, i + 1)
        out[n + 1] = floor((B64[a] * 64 + B64[b]) / 16)
        n = n + 1
    elseif rem == 3 then
        local a, b, c = byte(s, i, i + 2)
        local v = B64[a] * 4096 + B64[b] * 64 + B64[c]
        out[n + 1], out[n + 2] = floor(v / 1024), floor(v / 4) % 256
        n = n + 2
    end
    return out, n
end

-- one map tile: 64 x 64 squares. first[s] / cnt[s]: the parts of square s (s = row * 64 + column, row 0 south,
-- column 0 east), lowest first. Per part: psq, mask (16 bits, the 4 x 4 cells it covers), flag (1 water, 2 road,
-- 4 fel, 8 open sky), land (which land it is on: you cannot walk from one land to another), ls (its first link;
-- its last is ls[p + 1] - 1). Per link (kept by the part it leads north or
-- west from): lown, ldir (1 north, 2 west), lidx (which part of that square it reaches), loff (where along the
-- border, 0..11), ln / lw (the crossing, in world yards).
local function unpackTile(Wd, key)
    local text = Wd.D.tiles[key]
    if not text then return false end
    local b, nb = bytesOf(text)
    local r0, c0 = floor(key / 256) * 64, (key % 256) * 64
    local first, cnt, psq, mask, flag, ls, land = {}, {}, {}, {}, {}, {}, {}
    local cur = 0                                   -- the land the parts being read belong to
    local lown, ldir, lidx, loff, ln, lw = {}, {}, {}, {}, {}, {}
    local x0, y0, cs = Wd.x0, Wd.y0, Wd.cs
    local np, nl, s, i = 0, 0, 0, 1
    -- (each link is written out where it is read, not through a helper: unpacking was a fifth of a long trip's time)
    while i <= nb do
        local v = b[i]
        i = i + 1
        if v >= 224 and v < 240 then
            cur = v - 224
        elseif v < 64 then
            s = s + v + 1
        elseif v < 128 or (v >= 200 and v < 216) then
            local variant, run
            if v < 128 then
                variant, run = floor((v - 64) / 4), (v - 64) % 4 + 1
            else
                variant, run = v - 200, b[i] + 5
                i = i + 1
            end
            local hn, hw, kind = variant % 2, floor(variant / 2) % 2, floor(variant / 4)
            local fl = 8 + (kind == 2 and 1 or 0) + (kind == 1 and 2 or 0)
            for _ = 1, run do
                np = np + 1
                first[s], cnt[s], psq[np], mask[np], flag[np], ls[np], land[np] = np, 1, s, 65535, fl, nl + 1, cur
                if hn == 1 or hw == 1 then
                    local r, c, off = r0 + floor(s / 64), c0 + s % 64, 6
                    if hn == 1 then
                        nl = nl + 1
                        lown[nl], ldir[nl], lidx[nl], loff[nl] = np, 1, 0, off
                        ln[nl], lw[nl] = x0 + (r + 1) * cs, y0 + (c + (off + 0.5) / 12) * cs
                    end
                    if hw == 1 then
                        nl = nl + 1
                        lown[nl], ldir[nl], lidx[nl], loff[nl] = np, 2, 0, off
                        ln[nl], lw[nl] = x0 + (r + (off + 0.5) / 12) * cs, y0 + (c + 1) * cs
                    end
                end
                s = s + 1
            end
        elseif v >= 192 and (v < 200 or v == 216) then
            local k
            if v == 216 then
                k = b[i]
                i = i + 1
            else
                k = v - 191
            end
            first[s], cnt[s] = np + 1, k
            local r, c = r0 + floor(s / 64), c0 + s % 64
            for _ = 1, k do
                local h = b[i]
                if h >= 224 then
                    cur = h - 224
                    i = i + 1
                    h = b[i]
                end
                np = np + 1
                psq[np], mask[np], flag[np], ls[np], land[np] = s, b[i + 1] + b[i + 2] * 256, h % 16, nl + 1, cur
                i = i + 3
                for _ = 1, floor(h / 16) do
                    local x = b[i]
                    i = i + 1
                    local ix = floor(x / 16) % 8
                    if ix == 7 then
                        ix = b[i]
                        i = i + 1
                    end
                    local off = x % 16
                    nl = nl + 1
                    if x >= 128 then
                        lown[nl], ldir[nl], lidx[nl], loff[nl] = np, 2, ix, off
                        ln[nl], lw[nl] = x0 + (r + (off + 0.5) / 12) * cs, y0 + (c + 1) * cs
                    else
                        lown[nl], ldir[nl], lidx[nl], loff[nl] = np, 1, ix, off
                        ln[nl], lw[nl] = x0 + (r + 1) * cs, y0 + (c + (off + 0.5) / 12) * cs
                    end
                end
            end
            s = s + 1
        else
            error("3D tile " .. key .. ": unknown record " .. v)
        end
    end
    if s ~= 4096 then error("3D tile " .. key .. " holds " .. s .. " squares") end
    ls[np + 1] = nl + 1
    return { key = key, r0 = r0, c0 = c0, np = np, nl = nl, first = first, cnt = cnt, psq = psq, mask = mask, flag = flag, land = land,
        ls = ls, lown = lown, ldir = ldir, lidx = lidx, loff = loff, ln = ln, lw = lw, bt = {}, bp = {} }
end

---------------------------------------------------------------- the world of one map
local worlds = {}
local function worldFor(inst)
    local D = S.Path3DData and S.Path3DData[inst]
    if type(D) ~= "table" or D.v ~= P3.FORMAT or type(D.tiles) ~= "table" then return nil end
    local Wd = worlds[inst]
    if not Wd or Wd.D ~= D then
        Wd = { D = D, x0 = D.x0, y0 = D.y0, cs = D.cell, tiles = {}, slots = {}, nslot = 0, loaded = 0, co = {}, entRec = {}, entIdx = {} }
        worlds[inst] = Wd
    end
    return Wd
end
local function tileAt(Wd, key)
    local t = Wd.tiles[key]
    if t == nil then
        t = unpackTile(Wd, key)
        if t then
            Wd.nslot = Wd.nslot + 1
            t.slot = Wd.nslot
            Wd.slots[t.slot] = t
            Wd.loaded = Wd.loaded + 1
        end
        Wd.tiles[key] = t
    end
    return t
end
-- the tile and the square in it for a square of the map (row, column)
local function squareAt(Wd, r, c)
    if r < 0 or c < 0 then return nil end
    local t = tileAt(Wd, floor(r / 64) * 256 + floor(c / 64))
    if not t then return nil end
    return t, (r % 64) * 64 + c % 64
end
function P3.Drop()
    for _, Wd in pairs(worlds) do Wd.tiles, Wd.slots, Wd.nslot, Wd.loaded, Wd.co, Wd.entRec, Wd.entIdx = {}, {}, 0, 0, {}, {}, {} end
end
-- Searches side by side (2026-11-22). In the game the line search (Path.lua, a slice a frame) and the travel planner's
-- walk measuring (Travel.lua's queue, on its own timer) take turns over the same unpacked tiles, and a search paused
-- half-way holds tile and crossing numbers. Dropping or trimming tiles under it gave it a different line, or an error
-- that switched the 3D search off for the session (/home/claude/fast/interleave.py: 4 of 8 trips with the tiles
-- dropped often). So no search drops or trims while another is still under way; a drop waits for the last one. A
-- search left behind (its trip changed) stops counting once the garbage collector takes its coroutine.
P3.live = setmetatable({}, { __mode = "k" })
local function othersLive()
    local me = coroutine.running()
    for co in pairs(P3.live) do
        if co ~= me and coroutine.status(co) ~= "dead" then return true end
    end
    return false
end
P3.OthersLive = othersLive
local function dropIfIdle(Wd)
    if not (P3.dropPending or (Wd and Wd.loaded > P3.KEEP)) then return end
    if othersLive() then P3.dropPending = true return end
    P3.dropPending = nil
    P3.Drop()
end
-- does a trip that ends here belong to the 3D search? (the spot lies on a tile of a finished zone)
function P3.Covers(inst, north, west)
    local Wd = worldFor(inst)
    if not Wd then return false end
    local r, c = floor((north - Wd.x0) / Wd.cs), floor((west - Wd.y0) / Wd.cs)
    if r < 0 or c < 0 then return false end
    local key = floor(r / 64) * 256 + floor(c / 64)
    if Wd.D.core then return Wd.D.core[key] == true end      -- the finished zones; the other tiles are the ring round them
    return Wd.D.tiles[key] ~= nil
end

-- the part a link reaches: its tile and its number there (nil when that tile is not in the data)
local farKey
local function farEnd(Wd, t, li)
    local bt = t.bt[li]
    if bt ~= nil then
        if bt then return bt, t.bp[li] end
        return nil
    end
    local s = t.psq[t.lown[li]]
    local r, c = t.r0 + floor(s / 64), t.c0 + s % 64
    if t.ldir[li] == 1 then r = r + 1 else c = c + 1 end
    local t2, s2 = squareAt(Wd, r, c)
    local f = t2 and t2.first[s2]
    if not f or t.lidx[li] >= t2.cnt[s2] then
        t.bt[li] = false
        return nil
    end
    t.bt[li], t.bp[li] = t2, f + t.lidx[li]
    return t2, f + t.lidx[li]
end

-- the tile a link's far end lies on (its key), without unpacking it
function farKey(t, li)
    local s = t.psq[t.lown[li]]
    local r, c = t.r0 + floor(s / 64), t.c0 + s % 64
    if t.ldir[li] == 1 then r = r + 1 else c = c + 1 end
    return floor(r / 64) * 256 + floor(c / 64)
end

---------------------------------------------------------------- where an end stands
local POW = {}
for k = 0, 16 do POW[k] = 2 ^ k end
local function bit(m, k) return floor(m / POW[k]) % 2 end

-- the parts under a spot: those whose cells hold it (several when floors lie over each other); when none does, the one
-- part within reach whose middle is nearest
local function partsAt(Wd, north, west, indoors)
    local cs = Wd.cs
    local fr, fc = (north - Wd.x0) / cs, (west - Wd.y0) / cs
    local sr, sc = floor(fr), floor(fc)
    local cell = floor((fr - sr) * 4) * 4 + floor((fc - sc) * 4)
    local out = {}
    local t, s = squareAt(Wd, sr, sc)
    local f = t and t.first[s]
    if f then
        for p = f, f + t.cnt[s] - 1 do
            if bit(t.mask[p], cell) == 1 then out[#out + 1] = { t, p } end
        end
    end
    if #out == 0 then
        local best, bd
        for dr = -1, 1 do
            for dc = -1, 1 do
                local t2, s2 = squareAt(Wd, sr + dr, sc + dc)
                local f2 = t2 and t2.first[s2]
                if f2 then
                    for p = f2, f2 + t2.cnt[s2] - 1 do
                        local m, sn, sw, k = t2.mask[p], 0, 0, 0
                        for q = 0, 15 do
                            if bit(m, q) == 1 then sn, sw, k = sn + floor(q / 4) + 0.5, sw + q % 4 + 0.5, k + 1 end
                        end
                        if k > 0 then
                            local pn = Wd.x0 + (sr + dr + sn / k / 4) * cs
                            local pw = Wd.y0 + (sc + dc + sw / k / 4) * cs
                            local d = max(abs(pn - north), abs(pw - west))
                            if d <= cs / 2 + P3.REACH and (not bd or d < bd) then best, bd = { t2, p }, d end
                        end
                    end
                end
            end
        end
        if best then out[1] = best end
    elseif #out > 1 and indoors ~= nil then
        -- floors over each other: indoors, the ones with something overhead; outdoors, the ones under the open sky
        local keep = {}
        for k = 1, #out do
            local sky = floor(out[k][1].flag[out[k][2]] / 8) % 2 == 1
            if sky ~= indoors then keep[#keep + 1] = out[k] end
        end
        if #keep > 0 then out = keep end
    end
    return out
end

---------------------------------------------------------------- the search
-- from the start's parts to the goal's parts, crossing by crossing -> the crossings of the cheapest way, first to last
-- (each { tile, link }), the part it starts on and the part it ends on; nil when there is no way or it is too far
-- allow: only parts on these tiles (keys) are entered. collect: no goal; returns, as its sixth value, the cost of every
-- crossing reached (to find where an end meets its tile's doorways)
local function search(Wd, starts, goals, sn, sw, gn, gw, mult, least, weight, tick, maxPops, allow, collect)
    local slots = Wd.slots
    local g, par, closed, seed = {}, {}, {}, {}
    local hf, hid, hn = {}, {}, 0
    local GOAL = -1
    local function push(f, id)
        hn = hn + 1
        local i = hn
        while i > 1 do
            local p = floor(i / 2)
            if hf[p] <= f then break end
            hf[i], hid[i] = hf[p], hid[p]
            i = p
        end
        hf[i], hid[i] = f, id
    end
    local wl = collect and 0 or weight * least
    local tiles = Wd.tiles
    -- every crossing of a part: the links it keeps (north and west), and the links the squares south and east of it
    -- keep that lead to it. (Written out in full rather than through relax and squareAt: this is where a search
    -- spends most of its time. The sums are the same, in the same order, so the way found is the same.)
    local function around(t, p, fromN, fromW, gl, mu, from)
        local ls, ln, lw = t.ls, t.ln, t.lw
        local base = t.slot * 32768
        for k = ls[p], ls[p + 1] - 1 do
            local id = base + k
            if not closed[id] then
                local dn, dw = ln[k] - fromN, lw[k] - fromW
                local cost = gl + sqrt(dn * dn + dw * dw) * mu
                local old = g[id]
                if not old or cost < old then
                    g[id], par[id] = cost, from
                    local hn_, hw_ = ln[k] - gn, lw[k] - gw
                    push(cost + wl * sqrt(hn_ * hn_ + hw_ * hw_), id)
                end
            end
        end
        local s = t.psq[p]
        local ix = p - t.first[s]
        local sr, sc = floor(s / 64), s % 64
        for side = 1, 2 do
            local t2, s2
            if side == 1 then
                if sr > 0 then
                    t2, s2 = t, s - 64
                else
                    local r = t.r0 - 1
                    if r >= 0 then
                        local key = floor(r / 64) * 256 + floor((t.c0 + sc) / 64)
                        t2 = tiles[key]
                        if t2 == nil then t2 = tileAt(Wd, key) end
                        s2 = 63 * 64 + sc
                    end
                end
            else
                if sc > 0 then
                    t2, s2 = t, s - 1
                else
                    local c = t.c0 - 1
                    if c >= 0 then
                        local key = floor((t.r0 + sr) / 64) * 256 + floor(c / 64)
                        t2 = tiles[key]
                        if t2 == nil then t2 = tileAt(Wd, key) end
                        s2 = sr * 64 + 63
                    end
                end
            end
            local f2 = t2 and t2.first[s2]
            if f2 then
                local ls2, ldir2, lidx2, ln2, lw2 = t2.ls, t2.ldir, t2.lidx, t2.ln, t2.lw
                local base2 = t2.slot * 32768
                for k = ls2[f2], ls2[f2 + t2.cnt[s2]] - 1 do
                    if ldir2[k] == side and lidx2[k] == ix then
                        local id = base2 + k
                        if not closed[id] then
                            local dn, dw = ln2[k] - fromN, lw2[k] - fromW
                            local cost = gl + sqrt(dn * dn + dw * dw) * mu
                            local old = g[id]
                            if not old or cost < old then
                                g[id], par[id] = cost, from
                                local hn_, hw_ = ln2[k] - gn, lw2[k] - gw
                                push(cost + wl * sqrt(hn_ * hn_ + hw_ * hw_), id)
                            end
                        end
                    end
                end
            end
        end
    end
    local goalCost, goalFrom, goalPart
    for i = 1, #starts do
        local t, p = starts[i][1], starts[i][2]
        local gp = t.slot * 16384 + p
        if goals[gp] then return {}, gp, gp end                 -- both ends on one part: a straight line
        seed[i] = gp
        around(t, p, sn, sw, 0, mult[t.flag[p]], -i)
    end
    local pops = 0
    while hn > 0 do
        -- take the cheapest off the heap (written out here: it runs once a crossing)
        local id = hid[1]
        local lf, lid = hf[hn], hid[hn]
        hf[hn], hid[hn] = nil, nil
        hn = hn - 1
        if hn > 0 then
            local i = 1
            while true do
                local c = 2 * i
                if c > hn then break end
                if c < hn and hf[c + 1] < hf[c] then c = c + 1 end
                if hf[c] >= lf then break end
                hf[i], hid[i] = hf[c], hid[c]
                i = c
            end
            hf[i], hid[i] = lf, lid
        end
        if id == GOAL then
            local links, l = {}, goalFrom
            local startPart
            while l and l > 0 do
                links[#links + 1] = l
                local q = par[l]
                if q < 0 then startPart = seed[-q] end
                l = q
            end
            local n = #links
            for k = 1, floor(n / 2) do links[k], links[n + 1 - k] = links[n + 1 - k], links[k] end
            return links, startPart, goalPart, pops, goalCost, g
        end
        if not closed[id] then
            closed[id] = true
            pops = pops + 1
            if pops > maxPops then return nil, nil, nil, pops, nil, g end
            if tick and pops % 4 == 0 then tick(16) end
            local t = slots[floor(id / 32768)]
            local li = id % 32768
            local gl, pn, pw = g[id], t.ln[li], t.lw[li]
            local t2, p2
            local bt = t.bt[li]
            if bt ~= nil then                              -- far end already known (as farEnd would answer)
                if bt and (not allow or allow[bt.key]) then t2, p2 = bt, t.bp[li] end
            elseif not allow or allow[farKey(t, li)] then
                t2, p2 = farEnd(Wd, t, li)
            end
            for side = 1, 2 do
                local tt, p
                if side == 1 then
                    if not allow or allow[t.key] then tt, p = t, t.lown[li] end
                else
                    tt, p = t2, p2
                end
                if tt then
                    local mu = mult[tt.flag[p]]
                    local gp = tt.slot * 16384 + p
                    if goals[gp] then
                        local dn, dw = pn - gn, pw - gw
                        local c = gl + sqrt(dn * dn + dw * dw) * mu
                        if not goalCost or c < goalCost then
                            goalCost, goalFrom, goalPart = c, id, gp
                            push(c, GOAL)
                        end
                    end
                    around(tt, p, pn, pw, gl, mu, id)
                end
            end
        end
    end
    return nil, nil, nil, pops, nil, g
end

---------------------------------------------------------------- pulling the line tight
-- the stretch of a square's border a crossing leaves open, in yards from the square's corner: the cells both parts
-- have along the border round the crossing, pulled in a little from the walls at either end
local function span(Wd, t, li, t2, p2)
    local ma, mb = t.mask[t.lown[li]], t2.mask[p2]
    local north = t.ldir[li] == 1
    local C = {}
    for i = 0, 3 do
        local a, b
        if north then a, b = bit(ma, 12 + i), bit(mb, i) else a, b = bit(ma, i * 4 + 3), bit(mb, i * 4) end
        C[i] = a == 1 and b == 1
    end
    local off = t.loff[li]
    local oc = min(max(floor(off / 3), 0), 3)
    local lo, hi = oc, oc
    if C[oc] then
        for _ = 1, 3 do
            if lo > 0 and C[lo - 1] then lo = lo - 1 end
            if hi < 3 and C[hi + 1] then hi = hi + 1 end
        end
    end
    local q = Wd.cs / 4
    local a, b = lo * q, (hi + 1) * q
    local mg = min(max((b - a - 0.8) / 2, 0), 0.6)
    a, b = a + mg, b - mg
    local pos = (off + 0.5) / 12 * Wd.cs
    return min(a, pos), max(b, pos)
end

local function cross(on, ow, pn, pw, qn, qw) return (pn - on) * (qw - ow) - (pw - ow) * (qn - on) end

-- the funnel: Ln/Lw, Rn/Rw the left and right ends of every gap on the way, numbered first..last (the first and the
-- last are the two ends themselves) -> the corners of the tight line and the number of the gap each one lies in
local function funnel(Ln, Lw, Rn, Rw, first, last)
    local outN, outW, outI = { Ln[first] }, { Lw[first] }, { first }
    local an, aw = Ln[first], Lw[first]
    local ln, lw, rn, rw = an, aw, an, aw
    local ai, li, ri = first, first, first
    local i, guard, n = first + 1, 0, last - first + 1
    while i <= last do
        guard = guard + 1
        if guard > 200 * n then break end
        local restart = false
        local pln, plw, prn, prw = Ln[i], Lw[i], Rn[i], Rw[i]
        if cross(an, aw, rn, rw, prn, prw) >= 0 then
            if (an == rn and aw == rw) or cross(an, aw, ln, lw, prn, prw) < 0 then
                rn, rw, ri = prn, prw, i
            else
                outN[#outN + 1], outW[#outW + 1], outI[#outI + 1] = ln, lw, li
                an, aw, ai = ln, lw, li
                ln, lw, rn, rw, li, ri = an, aw, an, aw, ai, ai
                i = ai + 1
                restart = true
            end
        end
        if not restart then
            if cross(an, aw, ln, lw, pln, plw) <= 0 then
                if (an == ln and aw == lw) or cross(an, aw, rn, rw, pln, plw) > 0 then
                    ln, lw, li = pln, plw, i
                else
                    outN[#outN + 1], outW[#outW + 1], outI[#outI + 1] = rn, rw, ri
                    an, aw, ai = rn, rw, ri
                    ln, lw, rn, rw, li, ri = an, aw, an, aw, ai, ai
                    i = ai + 1
                    restart = true
                end
            end
            if not restart then i = i + 1 end
        end
    end
    outN[#outN + 1], outW[#outW + 1], outI[#outI + 1] = Ln[last], Lw[last], last
    return outN, outW, outI
end

-- the way through one part from a to b when the straight line would leave its cells (a tree in the middle of the
-- square): cell by cell round the gap -> the middles of the cells to pass, in order
local function insidePart(Wd, t, p, an, aw, bn, bw)
    local m, s, cs = t.mask[p], t.psq[p], Wd.cs
    local n0, w0 = Wd.x0 + (t.r0 + floor(s / 64)) * cs, Wd.y0 + (t.c0 + s % 64) * cs
    local function cellOf(n, w)
        local cr, cc = min(max(floor((n - n0) / cs * 4), 0), 3), min(max(floor((w - w0) / cs * 4), 0), 3)
        if bit(m, cr * 4 + cc) == 1 then return cr * 4 + cc end
        local best, bd
        for q = 0, 15 do
            if bit(m, q) == 1 then
                local d = (floor(q / 4) - cr) ^ 2 + (q % 4 - cc) ^ 2
                if not bd or d < bd then best, bd = q, d end
            end
        end
        return best
    end
    local ca, cb = cellOf(an, aw), cellOf(bn, bw)
    if not ca or not cb or ca == cb then return {}, {} end
    local from, queue, head = { [ca] = -1 }, { ca }, 1
    while head <= #queue and from[cb] == nil do
        local q = queue[head]
        head = head + 1
        local cr, cc = floor(q / 4), q % 4
        for k = 1, 4 do
            local r2, c2 = cr + (k == 1 and 1 or k == 2 and -1 or 0), cc + (k == 3 and 1 or k == 4 and -1 or 0)
            if r2 >= 0 and r2 <= 3 and c2 >= 0 and c2 <= 3 then
                local q2 = r2 * 4 + c2
                if from[q2] == nil and bit(m, q2) == 1 then
                    from[q2] = q
                    queue[#queue + 1] = q2
                end
            end
        end
    end
    if from[cb] == nil then return {}, {} end
    local N, W, q = {}, {}, cb
    while q ~= -1 do
        N[#N + 1], W[#W + 1] = n0 + (floor(q / 4) + 0.5) * cs / 4, w0 + (q % 4 + 0.5) * cs / 4
        q = from[q]
    end
    for k = 1, floor(#N / 2) do
        N[k], N[#N + 1 - k] = N[#N + 1 - k], N[k]
        W[k], W[#W + 1 - k] = W[#W + 1 - k], W[k]
    end
    return N, W
end

-- the line of a found way: pulled tight through the gaps, and then made to keep to the floor. A tight line may still
-- cut across a gap INSIDE a square (a trunk in its middle): where it does, the line is taken through that square's own
-- crossings and round the gap, and pulled tight again on either side.
local function smooth(Wd, links, startPart, sn, sw, gn, gw, tick)
    local m = #links
    local x0, y0, cs = Wd.x0, Wd.y0, Wd.cs
    -- part k (0..m): the part between crossing k and crossing k + 1; gap k + 1 lies at crossing k (gap 1 is the start)
    local PT, PP, XN, XW = {}, {}, {}, {}
    local Ln, Lw, Rn, Rw = { sn }, { sw }, { sn }, { sw }
    local slot0 = floor(startPart / 16384)
    PT[0], PP[0] = Wd.slots[slot0], startPart % 16384
    local prev = startPart
    for k = 1, m do
        local id = links[k]
        local t = Wd.slots[floor(id / 32768)]
        local li = id % 32768
        local a = t.lown[li]
        local t2, p2 = farEnd(Wd, t, li)
        local fwd = prev == t.slot * 16384 + a
        local s = t.psq[a]
        local ra, ca = t.r0 + floor(s / 64), t.c0 + s % 64
        local lo, hi = span(Wd, t, li, t2, p2)
        local n = k + 1
        if t.ldir[li] == 1 then
            local nn = x0 + (ra + 1) * cs
            local e0, e1 = y0 + ca * cs + lo, y0 + ca * cs + hi       -- east end, west end
            if fwd then Ln[n], Lw[n], Rn[n], Rw[n] = nn, e1, nn, e0 else Ln[n], Lw[n], Rn[n], Rw[n] = nn, e0, nn, e1 end
        else
            local ww = y0 + (ca + 1) * cs
            local e0, e1 = x0 + ra * cs + lo, x0 + ra * cs + hi       -- south end, north end
            if fwd then Ln[n], Lw[n], Rn[n], Rw[n] = e0, ww, e1, ww else Ln[n], Lw[n], Rn[n], Rw[n] = e1, ww, e0, ww end
        end
        XN[k], XW[k] = t.ln[li], t.lw[li]
        if fwd then PT[k], PP[k] = t2, p2 else PT[k], PP[k] = t, a end
        prev = PT[k].slot * 16384 + PP[k]
    end
    -- which parts of the way lie in each square
    local bySq = {}
    for k = 0, m do
        local t = PT[k]
        local s = t.psq[PP[k]]
        local key = (t.r0 + floor(s / 64)) * 65536 + t.c0 + s % 64
        local l = bySq[key]
        if not l then
            l = {}
            bySq[key] = l
        end
        l[#l + 1] = k
    end
    -- the first part (a..b) where the piece of line from (n1, w1) to (n2, w2) runs off the way's own cells for more
    -- than a yard; nil when it keeps to them
    local function offAt(n1, w1, n2, w2, a, b)
        local d = sqrt((n2 - n1) ^ 2 + (w2 - w1) ^ 2)
        local steps = max(1, floor(d / 0.7))
        local run, bad = 0, nil
        for i = 1, steps do
            local f = (i - 0.5) / steps
            local n, w = n1 + (n2 - n1) * f, w1 + (w2 - w1) * f
            local fr, fc = (n - x0) / cs, (w - y0) / cs
            local sr, sc = floor(fr), floor(fc)
            local cell = floor((fr - sr) * 4) * 4 + floor((fc - sc) * 4)
            local l = bySq[sr * 65536 + sc]
            local ok, cand = false, nil
            if l then
                for q = 1, #l do
                    local k = l[q]
                    if k >= a and k <= b then
                        cand = cand or k
                        if bit(PT[k].mask[PP[k]], cell) == 1 then ok = true break end
                    end
                end
            end
            if ok then
                run, bad = 0, nil
            else
                run = run + d / steps
                bad = bad or cand
                if run > 1.0 and bad then return bad end
            end
        end
        return nil
    end
    local outN, outW = { sn }, { sw }
    local splits = 0
    local function add(n, w)
        local k = #outN
        if abs(outN[k] - n) > 0.01 or abs(outW[k] - w) > 0.01 then outN[k + 1], outW[k + 1] = n, w end
    end
    -- the line from (an, aw) on part a to (bn, bw) on part b, through crossings a + 1 .. b. Where the tight line runs off
    -- the floor inside part j, the stretch before j is done first (as a piece of its own), then the way through j by its
    -- own crossings, and the rest is taken up again from j's far crossing.
    local function piece(a, an, aw, b, bn, bw, depth)
        while true do
            if tick then tick(8 + floor((b - a) / 4)) end
            local N, W, I
            if a == b then
                N, W, I = { an, bn }, { aw, bw }, { a + 1, b + 2 }
            else
                local sLn, sLw, sRn, sRw = Ln[a + 1], Lw[a + 1], Rn[a + 1], Rw[a + 1]
                local eLn, eLw, eRn, eRw = Ln[b + 2], Lw[b + 2], Rn[b + 2], Rw[b + 2]
                Ln[a + 1], Lw[a + 1], Rn[a + 1], Rw[a + 1] = an, aw, an, aw
                Ln[b + 2], Lw[b + 2], Rn[b + 2], Rw[b + 2] = bn, bw, bn, bw
                N, W, I = funnel(Ln, Lw, Rn, Rw, a + 1, b + 2)
                Ln[a + 1], Lw[a + 1], Rn[a + 1], Rw[a + 1] = sLn, sLw, sRn, sRw
                Ln[b + 2], Lw[b + 2], Rn[b + 2], Rw[b + 2] = eLn, eLw, eRn, eRw
            end
            local j
            if depth < 30 and splits < 3000 then
                for k = 2, #N do
                    -- gap numbers I[k - 1] .. I[k]: the parts between them are I[k - 1] - 1 .. I[k] - 2
                    j = offAt(N[k - 1], W[k - 1], N[k], W[k], max(a, I[k - 1] - 1), min(b, I[k] - 2))
                    if j then break end
                end
            end
            if not j then
                for k = 2, #N do add(N[k], W[k]) end
                return
            end
            splits = splits + 1
            -- through part j by its own crossings
            local en, ew, fn, fw = an, aw, bn, bw
            if j > a then
                en, ew = XN[j], XW[j]
                piece(a, an, aw, j - 1, en, ew, depth + 1)
            end
            if j < b then fn, fw = XN[j + 1], XW[j + 1] end
            if offAt(en, ew, fn, fw, j, j) then
                local iN, iW = insidePart(Wd, PT[j], PP[j], en, ew, fn, fw)
                for k = 1, #iN do add(iN[k], iW[k]) end
            end
            add(fn, fw)
            if j >= b then return end
            a, an, aw = j + 1, fn, fw
        end
    end
    piece(0, sn, sw, m, gn, gw, 0)
    return outN, outW, splits
end

---------------------------------------------------------------- the rough map (long trips)
-- Per map tile, its doorways: where the floor of the tile meets the floor of the next tile, one crossing standing for
-- a stretch of border; and what walking from one doorway of the tile to another costs inside it, in both route modes
-- (coarse3d.py). A long trip is planned over the doorways first, then worked out exactly piece by piece along them.
local function coarseAt(Wd, key)
    local rec = Wd.co[key]
    if rec ~= nil then return rec end
    local text = Wd.D.coarse and Wd.D.coarse[key]
    if not text then
        Wd.co[key] = false
        return false
    end
    local b = bytesOf(text)
    local n = b[1] + b[2] * 256
    local r0, c0 = floor(key / 256) * 64, (key % 256) * 64
    local x0, y0, cs, gw = Wd.x0, Wd.y0, Wd.cs, Wd.D.gw
    rec = { n = n, K = {}, N = {}, W = {}, own = {}, far = {}, R = {}, C = {}, dir = {}, idx = {}, off = {}, adj = {} }
    local i = 3
    for e = 1, n do
        local sp, ix, off = b[i], b[i + 1], b[i + 2]
        i = i + 3
        local side, pos = floor(sp / 64), sp % 64
        local R, C, dir
        if side == 0 then R, C, dir = r0 + 63, c0 + pos, 1
        elseif side == 1 then R, C, dir = r0 + pos, c0 + 63, 2
        elseif side == 2 then R, C, dir = r0 - 1, c0 + pos, 1
        else R, C, dir = r0 + pos, c0 - 1, 2 end
        local K = ((R * gw + C) * 2 + dir - 1) * 4096 + ix * 12 + off
        rec.K[e], rec.R[e], rec.C[e], rec.dir[e], rec.idx[e], rec.off[e] = K, R, C, dir, ix, off
        if dir == 1 then
            rec.N[e], rec.W[e] = x0 + (R + 1) * cs, y0 + (C + (off + 0.5) / 12) * cs
            rec.far[e] = floor((R + 1) / 64) * 256 + floor(C / 64)
        else
            rec.N[e], rec.W[e] = x0 + (R + (off + 0.5) / 12) * cs, y0 + (C + 1) * cs
            rec.far[e] = floor(R / 64) * 256 + floor((C + 1) / 64)
        end
        rec.own[e] = floor(R / 64) * 256 + floor(C / 64)
        rec.adj[e] = {}
        Wd.entRec[K], Wd.entIdx[K] = rec, e
    end
    local m = b[i] + b[i + 1] * 256
    i = i + 2
    for _ = 1, m do
        local a, c = b[i] + b[i + 1] * 256 + 1, b[i + 2] + b[i + 3] * 256 + 1
        local cf, cr = (b[i + 4] + b[i + 5] * 256) / 2, (b[i + 6] + b[i + 7] * 256) / 2
        i = i + 8
        local A, C2 = rec.adj[a], rec.adj[c]
        A[#A + 1], A[#A + 2], A[#A + 3] = c, cf, cr
        C2[#C2 + 1], C2[#C2 + 2], C2[#C2 + 3] = a, cf, cr
    end
    rec.loc = {}
    for e = 1, n do rec.loc[rec.K[e]] = e end
    Wd.co[key] = rec
    return rec
end

-- the crossing a doorway stands for, in the fine data: its tile and link (nil when the data does not hold it)
local function doorLink(Wd, rec, e)
    local t = tileAt(Wd, rec.own[e])
    if not t then return nil end
    local s = (rec.R[e] % 64) * 64 + rec.C[e] % 64
    local f = t.first[s]
    if not f or rec.idx[e] >= t.cnt[s] then return nil end
    local p = f + rec.idx[e]
    for li = t.ls[p], t.ls[p + 1] - 1 do
        if t.ldir[li] == rec.dir[e] and t.loff[li] == rec.off[e] then return t, li end
    end
    return nil
end

-- a small heap for the plan over the doorways
local function newHeap()
    local hf, hid, hn = {}, {}, 0
    local function push(f, id)
        hn = hn + 1
        local i = hn
        while i > 1 do
            local p = floor(i / 2)
            if hf[p] <= f then break end
            hf[i], hid[i] = hf[p], hid[p]
            i = p
        end
        hf[i], hid[i] = f, id
    end
    local function pop()
        if hn == 0 then return nil end
        local f, id = hf[1], hid[1]
        local lf, lid = hf[hn], hid[hn]
        hf[hn], hid[hn] = nil, nil
        hn = hn - 1
        if hn > 0 then
            local i = 1
            while true do
                local c = 2 * i
                if c > hn then break end
                if c < hn and hf[c + 1] < hf[c] then c = c + 1 end
                if hf[c] >= lf then break end
                hf[i], hid[i] = hf[c], hid[c]
                i = c
            end
            hf[i], hid[i] = lf, lid
        end
        return f, id
    end
    return push, pop
end

local function tilesOf(list)
    local set = {}
    for k = 1, #list do set[list[k][1].key] = true end
    return set
end

-- the part a walk is on after it goes through crossing `id`, coming from part `prev` (both as slot * 16384 + part)
local function after(Wd, prev, id)
    local t = Wd.slots[floor(id / 32768)]
    local li = id % 32768
    local a = t.lown[li]
    if prev == t.slot * 16384 + a then
        local t2, p2 = farEnd(Wd, t, li)
        return t2, p2
    end
    return t, a
end

-- drop the unpacked tiles not in `keep` (a long trip keeps only the tiles of the piece it works on: an unpacked tile
-- holds about 1.4 MB of Lua tables)
local function trim(Wd, keep)
    if P3.dbg then P3.dbg.peak = math.max(P3.dbg.peak or 0, Wd.loaded) end
    for key, t in pairs(Wd.tiles) do
        if t and not keep[key] then
            Wd.tiles[key] = nil
            Wd.slots[t.slot] = nil
            Wd.loaded = Wd.loaded - 1
        end
    end
    for _, t in pairs(Wd.tiles) do
        if t then t.bt, t.bp = {}, {} end       -- far ends found earlier may point at a dropped tile
    end
end

-- a long trip: the plan over the doorways, then the exact way in pieces along it -> the crossings of the whole way,
-- the part it starts on, the crossings visited, its cost; nil when there is no way
local function longWay(Wd, starts, ends, goals, sn, sw, gn, gw, mult, least, weight, tick, roads)
    local pops = 0
    local function d2(an, aw, bn, bw) return sqrt((an - bn) ^ 2 + (aw - bw) ^ 2) end
    -- 1. what it costs to get from each end to the doorways of its own tile
    local sTiles, gTiles = tilesOf(starts), tilesOf(ends)
    local _, _, _, p1, _, gS = search(Wd, starts, {}, sn, sw, sn, sw, mult, least, 1, tick, P3.ATTACH, sTiles, true)
    local _, _, _, p2, _, gG = search(Wd, ends, {}, gn, gw, gn, gw, mult, least, 1, tick, P3.ATTACH, gTiles, true)
    pops = pops + (p1 or 0) + (p2 or 0)
    P3.dbg = { attach = (p1 or 0) + (p2 or 0), plan = 0, pieces = {} }
    local function doorsReached(tiles, g, into)
        for key in pairs(tiles) do
            local rec = coarseAt(Wd, key)
            if rec then
                for e = 1, rec.n do
                    local t, li = doorLink(Wd, rec, e)
                    local c = t and g[t.slot * 32768 + li]
                    if c and (not into[rec.K[e]] or c < into[rec.K[e]]) then into[rec.K[e]] = c end
                end
            end
        end
    end
    local fromStart, toGoal = {}, {}
    doorsReached(sTiles, gS, fromStart)
    doorsReached(gTiles, gG, toGoal)
    -- 2. the plan over the doorways
    local ci = roads and 2 or 1
    local push, pop = newHeap()
    local gC, parC, done = {}, {}, {}
    local GOAL = -1
    local function h(K)
        local rec, e = Wd.entRec[K], Wd.entIdx[K]
        return least * d2(rec.N[e], rec.W[e], gn, gw)
    end
    for K, c in pairs(fromStart) do
        gC[K], parC[K] = c, false
        push(c + h(K), K)
    end
    local bestC, bestK
    while true do
        local _, K = pop()
        if not K or K == GOAL then break end
        if not done[K] then
            done[K] = true
            if tick then tick(2) end
            P3.dbg.plan = P3.dbg.plan + 1
            local gk = gC[K]
            if toGoal[K] then
                local c = gk + toGoal[K]
                if not bestC or c < bestC then
                    bestC, bestK = c, K
                    push(c, GOAL)
                end
            end
            local rec0, e0 = Wd.entRec[K], Wd.entIdx[K]
            for side = 1, 2 do
                local rec = coarseAt(Wd, side == 1 and rec0.own[e0] or rec0.far[e0])
                local loc = rec and rec.loc[K]
                if loc then
                    local a = rec.adj[loc]
                    for q = 1, #a, 3 do
                        local K2 = rec.K[a[q]]
                        local c = gk + a[q + ci]
                        if not done[K2] and (not gC[K2] or c < gC[K2]) then
                            gC[K2], parC[K2] = c, K
                            push(c + h(K2), K2)
                        end
                    end
                end
            end
        end
    end
    if not bestK then return nil, nil, pops end
    local E = {}
    local K = bestK
    while K do
        E[#E + 1] = K
        K = parC[K]
    end
    for k = 1, floor(#E / 2) do E[k], E[#E + 1 - k] = E[#E + 1 - k], E[k] end
    P3.lastPlan = {}                                   -- the doorways of the plan (north, west, ...): for tools and pictures
    for k = 1, #E do
        local rec, e = Wd.entRec[E[k]], Wd.entIdx[E[k]]
        P3.lastPlan[2 * k - 1], P3.lastPlan[2 * k] = rec.N[e], rec.W[e]
    end
    -- 3. the exact way, piece by piece. Each piece is searched to a doorway some way ahead (or to the goal), on the
    -- tiles of the plan; only its first part is kept, so the line never bends to meet a doorway's middle.
    local function ent(i) return Wd.entRec[E[i]], Wd.entIdx[E[i]] end
    if roads then weight = P3.WEIGHT_LONG_ROADS else weight = P3.WEIGHT_LONG end
    local outN, outW, cost, splits = { sn }, { sw }, 0, 0
    local startPart
    local function addLine(N, W, sp_)
        splits = splits + (sp_ or 0)
        for q = 2, #N do outN[#outN + 1], outW[#outW + 1] = N[q], W[q] end
    end
    local cur, cn, cw = starts, sn, sw
    local j, k = 0, #E
    local lastAllow
    for _ = 1, 1000 do
        -- how far is left is measured along the plan, not as the crow flies: a goal on a cliff 500 yd away may be
        -- 7,000 yd of walking round
        local base = j >= 1 and gC[E[j]] or 0
        local final = j >= k or bestC - base <= P3.PIECE
        local t = j + 1
        if not final then
            while t < k and gC[E[t + 1]] - base <= P3.PIECE do t = t + 1 end
        end
        local allow = tilesOf(cur)
        local last = final and k or t
        for i = j + 1, last do
            local rec, e = ent(i)
            allow[rec.own[e]], allow[rec.far[e]] = true, true
        end
        if final then
            for key in pairs(gTiles) do allow[key] = true end
        end
        -- only this piece's tiles stay unpacked, and the goal's (the goal is known by its tile's number, which a tile
        -- unpacked again would not keep)
        local keep = {}
        for key in pairs(allow) do keep[key] = true end
        for key in pairs(gTiles) do keep[key] = true end
        -- and the last piece's: the next piece mostly runs over the same ground, and unpacking a tile again was a
        -- fifth of a long trip's time
        if P3.KEEP_LAST and lastAllow then
            for key in pairs(lastAllow) do keep[key] = true end
        end
        lastAllow = allow
        if not othersLive() then trim(Wd, keep) end   -- another search under way may be on the others
        local tn, tw, tg
        if final then
            tn, tw, tg = gn, gw, goals
        else
            local rec, e = ent(t)
            local dt, dli = doorLink(Wd, rec, e)
            if not dt then return nil, nil, pops end
            local ft, fp = farEnd(Wd, dt, dli)
            tg = { [dt.slot * 16384 + dt.lown[dli]] = true }
            if ft then tg[ft.slot * 16384 + fp] = true end
            tn, tw = rec.N[e], rec.W[e]
        end
        local links, sp, _, pp, gcost, g
        for try = 1, 3 do
            local lim = allow
            if try == 2 then
                lim = {}
                for key in pairs(allow) do
                    for dr = -1, 1 do
                        for dc = -1, 1 do lim[key + dr * 256 + dc] = true end
                    end
                end
            elseif try == 3 then
                lim = nil
            end
            links, sp, _, pp, gcost, g = search(Wd, cur, tg, cn, cw, tn, tw, mult, least, weight, tick, try == 3 and P3.POPS or P3.PIECE_POPS, lim)
            pops = pops + (pp or 0)
            local dl = P3.dbg.pieces
            dl[#dl + 1] = (pp or 0) * 10 + try
            P3.dbg.at = { cn, cw, tn, tw, t, j, k }
            if links then break end
        end
        if not links then return nil, nil, pops end
        startPart = startPart or sp
        if final then
            if #links == 0 then
                addLine({ cn, gn }, { cw, gw })
            else
                local N, W, sp_ = smooth(Wd, links, sp, cn, cw, gn, gw, tick)
                addLine(N, W, sp_)
            end
            cost = cost + gcost
            return outN, outW, pops, cost, splits
        end
        if #links == 0 then
            j = t                                     -- standing in the doorway already
        else
            -- keep the first part of the piece
            local acc, total, pn, pw = {}, 0, cn, cw
            for q = 1, #links do
                local lt = Wd.slots[floor(links[q] / 32768)]
                local li = links[q] % 32768
                total = total + d2(pn, pw, lt.ln[li], lt.lw[li])
                acc[q] = total
                pn, pw = lt.ln[li], lt.lw[li]
            end
            local keep = 1
            if total <= P3.PIECE * 0.4 then
                keep = #links                         -- the doorway is close: go all the way to it
            else
                for q = 1, #links do
                    if acc[q] <= total * P3.COMMIT then keep = q end
                end
            end
            local prev = sp
            local nt, np_
            local kept = {}
            for q = 1, keep do
                kept[q] = links[q]
                nt, np_ = after(Wd, prev, links[q])
                if not nt then return nil, nil, pops end
                prev = nt.slot * 16384 + np_
            end
            cost = cost + g[links[keep]]
            local lt = Wd.slots[floor(links[keep] / 32768)]
            local en, ew = lt.ln[links[keep] % 32768], lt.lw[links[keep] % 32768]
            -- this stretch's line, pulled tight now while its tiles are unpacked
            local N, W, sp_ = smooth(Wd, kept, sp, cn, cw, en, ew, tick)
            addLine(N, W, sp_)
            cn, cw = en, ew
            cur = { { nt, np_ } }
            -- the doorways now behind
            if keep == #links then
                j = t
            else
                local recT, eT = ent(t)
                local left = d2(cn, cw, recT.N[eT], recT.W[eT])
                for i = j + 1, t do
                    local rec, e = ent(i)
                    if d2(rec.N[e], rec.W[e], recT.N[eT], recT.W[eT]) >= left then j = i end
                end
            end
        end
    end
    return nil, nil, pops
end

---------------------------------------------------------------- walking to the travel points (for the trip planner)
-- What walking from a spot to every travel point (flight master, dock: TravelData.lua) of its continent costs, on the
-- 3D world: the walk to the doorways of the spot's own tile, then one sweep over the rough map, then each point's own
-- walk from the doorways of its tile (worked out in the workshop). Costs as the walking search counts them (about a
-- yard each on open ground, more in water). -> { [point id] = cost } (points that cannot be walked to are left out),
-- or nil when the spot is not on the 3D world. `limit`: stop sweeping at this cost.
function P3.WalkFrom(inst, north, west, roads, limit, tick)
    if P3.off or P3.broken or not S:Get("path3D") then return nil end
    local Wd = worldFor(inst)
    if not (Wd and Wd.D.coarse and Wd.D.points) then return nil end
    if not P3.Covers(inst, north, west) then return nil end
    -- its own coroutine, so that `tick` can hand the frame back (a yield cannot cross pcall); an error ends it
    local co = coroutine.create(function()
        local starts = partsAt(Wd, north, west, nil)
        if #starts == 0 then return nil end
        local P = S.Path
        local water = P and P.WATER or 2.2
        local road = roads and 0.4 or 0.97
        local mult = {}
        for f = 0, 15 do
            mult[f] = (floor(f / 4) % 2 == 1 and P3.FEL) or (f % 2 == 1 and water) or (floor(f / 2) % 2 == 1 and road) or 1
        end
        local tiles = tilesOf(starts)
        local _, _, _, _, _, g = search(Wd, starts, {}, north, west, north, west, mult, min(1, road), 1, tick, P3.ATTACH, tiles, true)
        local push, pop = newHeap()
        local gC, done = {}, {}
        for key in pairs(tiles) do
            local rec = coarseAt(Wd, key)
            if rec then
                for e = 1, rec.n do
                    local t, li = doorLink(Wd, rec, e)
                    local c = t and g[t.slot * 32768 + li]
                    if c and (not gC[rec.K[e]] or c < gC[rec.K[e]]) then
                        gC[rec.K[e]] = c
                        push(c, rec.K[e])
                    end
                end
            end
        end
        local ci = roads and 2 or 1
        limit = limit or huge
        while true do
            local c0, K = pop()
            if not K or c0 > limit then break end
            if not done[K] then
                done[K] = true
                if tick then tick(2) end
                local rec0, e0 = Wd.entRec[K], Wd.entIdx[K]
                for side = 1, 2 do
                    local rec = coarseAt(Wd, side == 1 and rec0.own[e0] or rec0.far[e0])
                    local loc = rec and rec.loc[K]
                    if loc then
                        local a = rec.adj[loc]
                        for q = 1, #a, 3 do
                            local K2 = rec.K[a[q]]
                            local c = c0 + a[q + ci]
                            if not done[K2] and (not gC[K2] or c < gC[K2]) then
                                gC[K2] = c
                                push(c, K2)
                            end
                        end
                    end
                end
            end
        end
        local out = {}
        for pid, e in pairs(Wd.D.points) do
            local rec = coarseAt(Wd, e[1])
            local best
            -- a point on the spot's own tile: straight from the walk worked out on that tile (its own floor's crossings)
            if tiles[e[1]] then
                local t = tileAt(Wd, e[1])
                local f = t and t.first[e[2]]
                if f and e[3] < t.cnt[e[2]] then
                    local p = f + e[3]
                    local mu = mult[t.flag[p]]
                    for li = t.ls[p], t.ls[p + 1] - 1 do
                        local c = g[t.slot * 32768 + li]
                        if c then
                            c = c + sqrt((t.ln[li] - e[4]) ^ 2 + (t.lw[li] - e[5]) ^ 2) * mu
                            if not best or c < best then best = c end
                        end
                    end
                    -- the crossings that the squares south and east of it keep
                    local s = e[2]
                    local r, c0 = t.r0 + floor(s / 64), t.c0 + s % 64
                    for side = 1, 2 do
                        local t2, s2
                        if side == 1 then t2, s2 = squareAt(Wd, r - 1, c0) else t2, s2 = squareAt(Wd, r, c0 - 1) end
                        local f2 = t2 and t2.first[s2]
                        if f2 and tiles[t2.key] then
                            for li = t2.ls[f2], t2.ls[f2 + t2.cnt[s2]] - 1 do
                                if t2.ldir[li] == side and t2.lidx[li] == e[3] then
                                    local c = g[t2.slot * 32768 + li]
                                    if c then
                                        c = c + sqrt((t2.ln[li] - e[4]) ^ 2 + (t2.lw[li] - e[5]) ^ 2) * mu
                                        if not best or c < best then best = c end
                                    end
                                end
                            end
                        end
                    end
                    if starts[1][1].key == e[1] then
                        for k = 1, #starts do
                            if starts[k][1] == t and starts[k][2] == p then best = sqrt((north - e[4]) ^ 2 + (west - e[5]) ^ 2) * mu end
                        end
                    end
                end
            end
            if rec then
                for q = 6, #e, 3 do
                    local K = rec.K[e[q]]
                    local c = K and gC[K]
                    if c then
                        c = c + e[q + ci] / 2
                        if not best or c < best then best = c end
                    end
                end
            end
            if best then out[pid] = best end
        end
        return { pts = out, doors = gC }
    end)
    P3.live[co] = true
    local ok, res
    while true do
        ok, res = coroutine.resume(co)
        if not ok or coroutine.status(co) == "dead" then break end
        if tick and coroutine.running() then coroutine.yield() end    -- the caller's coroutine waits a frame too
    end
    dropIfIdle(Wd)
    if not ok then P3.walkErr = tostring(res) return nil end
    if not res then return nil end
    return res.pts, res.doors
end
P3.Bytes = bytesOf

-- for tests: the floors at a spot, each true when under the open sky
function P3.SkyAt(inst, north, west, indoors)
    local Wd = worldFor(inst)
    if not Wd then return nil end
    local out = {}
    for k, e in ipairs(partsAt(Wd, north, west, indoors)) do out[k] = floor(e[1].flag[e[2]] / 8) % 2 == 1 end
    return out
end

-- Can you walk straight from a to b? The line from where you stand to the route is drawn straight while you are within
-- P.STRAY of it; this says when that straight piece is blocked (a wall, a cliff, water you can't get out of), so a new
-- route is worked out instead (Nick 2026-11-20: the piece cut past a wall in Ironforge). Walks the piece in half-yard
-- steps: it must stay on the floor of the part it is on, and go from one part to the next only through a link between
-- them, where the opening is. Gaps up to P3.CLEAR_GAP are let through (corners and tree trunks). true / false, nil when it
-- can't tell (no data here, or no floor under a).
local function linkedPart(Wd, t, p, r, c, nr, nc, along)
    -- a part in square (nr, nc) joined to part p of square (r, c) through an opening that holds 'along' (yards along the
    -- shared edge); the link is kept by the part to the south or west
    local north = nr ~= r
    local lo_t, lo_p, hi_r, hi_c, low_is_cur
    if (north and nr > r) or (not north and nc > c) then
        lo_t, lo_p, hi_r, hi_c, low_is_cur = t, p, nr, nc, true
    else
        hi_r, hi_c, low_is_cur = r, c, false
    end
    local function scan(lt, lp, want_t, want_p)
        for li = lt.ls[lp], lt.ls[lp + 1] - 1 do
            if (lt.ldir[li] == 1) == north then
                local t2, p2 = farEnd(Wd, lt, li)
                if t2 and (not want_t or (t2 == want_t and p2 == want_p)) then
                    local a, b = span(Wd, lt, li, t2, p2)
                    if along >= a - 0.6 and along <= b + 0.6 then return t2, p2 end
                end
            end
        end
    end
    if low_is_cur then return scan(lo_t, lo_p) end
    -- the other way round: each part of the new square whose link reaches p
    local t2, s2 = squareAt(Wd, nr, nc)
    local f = t2 and t2.first[s2]
    if not f then return nil end
    for q = f, f + t2.cnt[s2] - 1 do
        if scan(t2, q, t, p) then return t2, q end
    end
end
function P3.Clear(inst, an, aw, bn, bw, indoors)
    local Wd = worldFor(inst)
    if not Wd then return nil end
    local starts = partsAt(Wd, an, aw, indoors)
    if #starts == 0 then return nil end
    local cs = Wd.cs
    local d = sqrt((bn - an) ^ 2 + (bw - aw) ^ 2)
    local steps = max(1, ceil(d / 0.5))
    local step = d / steps
    local function sky(t, p) return floor(t.flag[p] / 8) % 2 end
    -- the parts you may be on (several pieces of floor share a square: road beside grass), all in square (r, c)
    local set, r, c = {}, nil, nil
    for _, st in ipairs(starts) do
        local s0 = st[1].psq[st[2]]
        local sr0, sc0 = st[1].r0 + floor(s0 / 64), st[1].c0 + s0 % 64
        if not r then r, c = sr0, sc0 end
        if sr0 == r and sc0 == c then set[#set + 1] = st end
    end
    local skies = {}
    for _, e in ipairs(set) do skies[sky(e[1], e[2])] = true end
    -- every part of square (sr, sc) covering 'cell', and of the same kind (open sky or not) as one in the set
    local function covering(sr, sc, cell)
        local out = {}
        local t, s2 = squareAt(Wd, sr, sc)
        local f = t and t.first[s2]
        if f then
            for q = f, f + t.cnt[s2] - 1 do
                if bit(t.mask[q], cell) == 1 and skies[sky(t, q)] then out[#out + 1] = { t, q } end
            end
        end
        return out
    end
    local function step1(set0, r0, c0, nr, nc, along)
        local out, seen = {}, {}
        for _, e in ipairs(set0) do
            local t2, p2 = linkedPart(Wd, e[1], e[2], r0, c0, nr, nc, along)
            if t2 and not seen[p2] then seen[p2] = true out[#out + 1] = { t2, p2 } end
        end
        return out
    end
    local gap = 0
    for i = 1, steps do
        local f = i / steps
        local n, w = an + (bn - an) * f, aw + (bw - aw) * f
        local fr, fc = (n - Wd.x0) / cs, (w - Wd.y0) / cs
        local sr, sc = floor(fr), floor(fc)
        local cell = floor((fr - sr) * 4) * 4 + floor((fc - sc) * 4)
        local nxt
        if sr == r and sc == c then
            nxt = {}
            for _, e in ipairs(set) do if bit(e[1].mask[e[2]], cell) == 1 then nxt[#nxt + 1] = e end end
            if #nxt == 0 then nxt = covering(sr, sc, cell) end          -- the next piece of floor in the same square
        elseif abs(sr - r) + abs(sc - c) == 1 then
            local along = (sr ~= r) and (w - Wd.y0 - sc * cs) or (n - Wd.x0 - sr * cs)
            nxt = step1(set, r, c, sr, sc, along)
        elseif abs(sr - r) == 1 and abs(sc - c) == 1 then
            nxt = {}
            for _, via in ipairs({ { sr, c }, { r, sc } }) do
                local m1 = (via[1] ~= r) and (w - Wd.y0 - c * cs) or (n - Wd.x0 - r * cs)
                local mid = step1(set, r, c, via[1], via[2], m1)
                if #mid > 0 then
                    local m2 = (sr ~= via[1]) and (w - Wd.y0 - sc * cs) or (n - Wd.x0 - sr * cs)
                    nxt = step1(mid, via[1], via[2], sr, sc, m2)
                    if #nxt > 0 then break end
                end
            end
        else
            nxt = {}
        end
        if #nxt > 0 then
            set, r, c, gap = nxt, sr, sc, 0
        else
            gap = gap + step
            if gap > P3.CLEAR_GAP then
                P3.why_clear = ("stuck in %d,%d going to %d,%d cell %d at step %d of %d"):format(r, c, sr, sc, cell, i, steps)
                return false
            end
        end
    end
    return true
end

---------------------------------------------------------------- one trip
local function run(job, tick, P)
    local Wd = worldFor(job.inst)
    if not Wd then P3.why = "no data for this continent" return false end
    local sn, sw, gn, gw = job.sx, job.sy, job.gx, job.gy
    if job.swap then sn, sw, gn, gw = sw, sn, gw, gn end
    local straight = sqrt((gn - sn) ^ 2 + (gw - sw) ^ 2)
    if straight > P3.MAX_YARDS and not Wd.D.coarse then P3.why = "too far" return false end
    if not (P3.Covers(job.inst, sn, sw) and P3.Covers(job.inst, gn, gw)) then P3.why = "an end is outside the mapped zones" return false end
    local indoors
    if IsIndoors and IsOutdoors then
        if IsIndoors() then indoors = true elseif IsOutdoors() then indoors = false end
    end
    local starts = partsAt(Wd, sn, sw, job.indoorsS ~= nil and job.indoorsS or indoors)
    local ends = partsAt(Wd, gn, gw, job.indoorsG)     -- your body in a cave: the floor under cover
    -- a lift's landing: the floor named by its place among the floors there, lowest first (a spot has no height)
    if job.landS then starts = partsAt(Wd, sn, sw, nil) starts = { starts[job.landS] } end
    if job.landG then ends = partsAt(Wd, gn, gw, nil) ends = { ends[job.landG] } end
    -- starting in the Undercity (the map you're on): the city's floor, not a room of the ruins over it
    if job.bottomS and #starts > 1 then
        for k = 1, #starts do
            if starts[k][1].flag[starts[k][2]] % 2 == 0 then starts = { starts[k] } break end
        end
    end
    if #starts == 0 or #ends == 0 then P3.why = "no floor at an end" return false end
    -- an end on another land (an island, the top of Teldrassil) cannot be walked to: that trip is for the older search,
    -- which knows the boats and portals
    local onLand, goals, any = {}, {}, false
    for k = 1, #starts do onLand[starts[k][1].land[starts[k][2]]] = true end
    for k = 1, #ends do
        if onLand[ends[k][1].land[ends[k][2]]] then
            goals[ends[k][1].slot * 16384 + ends[k][2]] = true
            any = true
        end
    end
    if not any then P3.why = "the ends are on different lands" return false end
    if job.bottomG then                     -- the lowest dry floor there that you can walk to (a square's parts go lowest first)
        for k = 1, #ends do
            local t, p = ends[k][1], ends[k][2]
            local id = t.slot * 16384 + p
            if goals[id] and t.flag[p] % 2 == 0 then goals = { [id] = true } break end
        end
    end
    local prices = P and P.ROUTES and P.ROUTES[job.route]
    local road = prices and prices.road or 0.97
    local water = P and P.WATER or 2.2
    local mult = {}
    for f = 0, 15 do
        mult[f] = (floor(f / 4) % 2 == 1 and P3.FEL) or (f % 2 == 1 and water) or (floor(f / 2) % 2 == 1 and road) or 1
    end
    local weight = P3.WEIGHT
    if P and straight >= (P.WEIGHT_FROM or huge) then weight = max(weight, P.WEIGHT or 1) end
    if road < 0.9 then weight = max(weight, P3.WEIGHT_ROADS) end
    local links, startPart, goalPart, pops, cost
    if straight <= P3.NEAR or not Wd.D.coarse then
        links, startPart, goalPart, pops, cost = search(Wd, starts, goals, sn, sw, gn, gw, mult, min(1, road), weight, tick, min(P3.POPS, P3.POPS_BASE + P3.POPS_PER * straight))
    end
    job.long3d = nil
    if not links and Wd.D.coarse then
        local endList = {}
        for k = 1, #ends do
            if goals[ends[k][1].slot * 16384 + ends[k][2]] then endList[#endList + 1] = ends[k] end
        end
        local p0 = pops or 0
        local LN, LW, lp, lc, lsp = longWay(Wd, starts, endList, goals, sn, sw, gn, gw, mult, min(1, road), weight, tick, road < 0.9)
        pops, cost = p0 + (lp or 0), lc
        job.long3d = true
        if LN then
            links, job.longN, job.longW, job.splits3d = {}, LN, LW, lsp
        end
    end
    job.pops3d, job.cost3d = pops, cost
    if not links then P3.why = "no way found within the limit" return false end
    local N, W
    if job.long3d then
        N, W = job.longN, job.longW
        job.longN, job.longW = nil, nil
    elseif #links == 0 then N, W = { sn, gn }, { sw, gw } else N, W, job.splits3d = smooth(Wd, links, startPart, sn, sw, gn, gw, tick) end
    -- the line, in the job's own order of the two numbers
    local X, Y, U, len, n = {}, {}, {}, 0, 0
    for k = 1, #N do
        local a, b = N[k], W[k]
        if n == 0 or abs(a - N[k - 1]) > 0.01 or abs(b - W[k - 1]) > 0.01 or k == #N then
            n = n + 1
            if job.swap then X[n], Y[n] = b, a else X[n], Y[n] = a, b end
            U[n] = false
            if n > 1 then len = len + sqrt((X[n] - X[n - 1]) ^ 2 + (Y[n] - Y[n - 1]) ^ 2) end
        end
    end
    job.X, job.Y, job.U, job.n, job.Z = X, Y, U, n, nil
    job.len, job.unsure, job.straight, job.mode, job.cell = len, 0, straight, "terrain", Wd.cs
    job.world3d = job.long3d and n or #links
    dropIfIdle(Wd)
    return true
end


---------------------------------------------------------------- entrances below other floors (0.88.2)
-- A map pin has no height. Where an entrance lies under other floors (the Hall of Thanes, 103 yd under Ironforge's
-- streets; Gnomeregan; Blackrock Mountain's two doors), a pin dropped within P3.ENTRANCE_NEAR yards of it means that
-- entrance, not the floor over it (Nick 2026-11-22: "start", on pins over caves and dungeons). Made in the workshop from
-- the game's own entrance table (AreaTrigger.csv, Nick's client) and the Hall of Thanes portal (Forever's own: not in that
-- table; 399 yd high, from Nick's 11-20 trip): kept are those with floor 20 yd or more above them within 30 yd.
-- { north, west, floor (its place among the floors there you can walk to, lowest first), name }
P3.ENTRANCE_NEAR = 30
P3.ENTRANCES = {
    [0] = {
        { -4776.2, -966.7, 1, "Hall of Thanes" },
        { -9077.3, -552.9, 1 },
        { -5660.3, 755.3, 1 },
        { 2019.3, 1904.4, 1 },
        { -5584.2, 759.8, 1 },
        { -5586.5, 679.3, 1 },
        { -4086.4, -2610.9, 1 },
        { -5601.5, -530.7, 1 },
        { -5390.2, -2953.9, 2 },
        { -3752.8, -851.6, 1 },
        { -14468.0, 457.5, 2 },
        { 97.4, -176.3, 1 },
        { 544.8, -1079.9, 1 },
        { 2964.6, -2712.9, 1 },
        { 2980.1, -2720.9, 1 },
        { 18.9, -1448.2, 1 },
        { -7510.9, -1035.9, 1 },
        { -7514.8, -1033.1, 1 },
        { -12432.8, 205.2, 1 },
        { -1189.3, -2532.2, 1 },
        { -811.4, -3505.8, 1 },
        { 2051.4, 272.6, 1 },
        { -3755.1, -775.7, 1 },
        { 1782.2, 151.6, 1 },
    },
    [1] = {
        { 9556.2, 1654.8, 1 },
        { -3463.3, -4123.1, 1 },
        { -4058.8, -2732.5, 1 },
        { -3464.7, -4120.9, 1 },
        { 2.0, 402.7, 1 },
        { -7180.9, 441.1, 1 },
        { 1253.8, -2227.5, 1 },
        { 1332.3, -4607.7, 1 },
    },
}
-- the entrance under other floors within r yards of north, west, or nil
function P3.EntranceNear(inst, north, west, r)
    local list = P3.ENTRANCES[inst]
    if not (list and north and west) then return nil end
    r = r or P3.ENTRANCE_NEAR
    local best, bd
    for _, e in ipairs(list) do
        local d = (e[1] - north) ^ 2 + (e[2] - west) ^ 2
        if d <= r * r and (not bd or d < bd) then best, bd = e, d end
    end
    return best
end

---------------------------------------------------------------- lifts (2026-11-22)
-- The lifts move, so the floors they carry you between aren't joined in the 3D data. Each lift is two landings
-- (where you step on and off: north, west, and which floor there, lowest first) and the seconds a ride costs: half the
-- time between cars plus the ride itself (the game's TransportAnimation table). Where they stand: the Undercity's
-- three shafts are parts of the city's own model (18 x 24 yd, 107 yd tall, round the Trade Quarter; city floor -41.3,
-- the hall above 55.3: 96.6 yd, the table's 96.5); Thunder Bluff's are where Wowhead's city guide puts them (the
-- south-west edge of the central bluff's lower level, 61 yd between the deck at 68.8 and the bluff at 129.7, two empty
-- car shafts beside them; the north-east edge, 71 yd between the ground at 79.6 and the platform at 150.9).
-- z: the floor's height at the landing (the 3D data, 2026-11-22): every lift's first landing is its top one; the tracker
-- says "up" or "down" from these. Not seen in the game yet.
P3.LIFTS = {
    [0] = {
        { name = "Undercity lift (west)", secs = 11.9, { n = 1595.3, w = 197.0, floor = 1, z = 55.3 }, { n = 1595.3, w = 177.0, floor = 2, z = -41.4 } },
        { name = "Undercity lift (east)", secs = 11.9, { n = 1596.2, w = 283.0, floor = 1, z = 55.3 }, { n = 1596.2, w = 303.0, floor = 2, z = -41.3 } },
        { name = "Undercity lift (south)", secs = 11.9, { n = 1553.0, w = 240.8, floor = 1, z = 55.3 }, { n = 1533.0, w = 240.8, floor = 2, z = -41.3 } },
    },
    [1] = {
        { name = "Thunder Bluff lift (south-west)", secs = 16.3, { n = -1291.0, w = 156.0, floor = 1, z = 129.7 }, { n = -1298.0, w = 172.0, floor = 2, z = 68.8 } },
        { name = "Thunder Bluff lift (north-east)", secs = 17.5, { n = -1077.0, w = -100.0, floor = 1, z = 150.9 }, { n = -1081.0, w = -106.0, floor = 1, z = 79.6 } },
        -- The Great Lift (0.85.0): the two towers of thousandneedleselevator.wmo placed on the Thousand Needles floor;
        -- 129.3 yd (TransportAnimation 11898/11899) between each tower's top platform (85.7, 89.3) and its base
        -- (-45.9, -39.9); one car each, 30 s round: half of it waiting plus the 8 s ride
        { name = "The Great Lift (north tower)", secs = 23, { n = -4644.8, w = -1841.5, floor = 1, z = 85.7 }, { n = -4674.0, w = -1842.0, floor = 2, z = -45.9 } },
        { name = "The Great Lift (south tower)", secs = 23, { n = -5409.3, w = -2481.3, floor = 1, z = 89.3 }, { n = -5407.0, w = -2506.0, floor = 1, z = -39.9 } },
    },
}
P3.RUN = 7                                          -- yards a second on foot: a ride's seconds as yards of walking

-- the trip, walking or by a lift: the walk as before, then for the lifts that could beat it (counted as the crow flies),
-- the walk to it, the ride and the walk on; the cheapest wins. One lift a trip.
local function runLifts(job, tick, P)
    local ok = run(job, tick, P)
    local lifts = P3.LIFTS[job.inst]
    if not lifts or job.noLifts then return ok end
    local why = P3.why
    local prices = P and P.ROUTES and P.ROUTES[job.route]
    local least = min(1, prices and prices.road or 0.97)
    local best = ok and (job.cost3d or huge) or huge
    local sn, sw, gn, gw = job.sx, job.sy, job.gx, job.gy
    if job.swap then sn, sw, gn, gw = sw, sn, gw, gn end
    local function leg(an, aw, bn, bw)
        local j = { inst = job.inst, route = job.route, swap = job.swap, noLifts = true }
        if job.swap then j.sx, j.sy, j.gx, j.gy = aw, an, bw, bn else j.sx, j.sy, j.gx, j.gy = an, aw, bn, bw end
        return j
    end
    -- the lifts that could beat the walk by enough to matter (15%), most promising first; at most four are worked out
    -- (with no walk at all, e.g. up to the mesas: only lifts roughly on the way)
    -- In plain yards: going by the lift (as the crow flies to it and from it) must be shorter than the walk found
    local walkLen = ok and job.len or (sqrt((gn - sn) ^ 2 + (gw - sw) ^ 2) * 2 + 800)
    local bar = ok and best * 0.85 or huge
    local opts = {}
    for _, L in ipairs(lifts) do
        for dir = 1, 2 do
            local A, B = L[1], L[2]
            if dir == 2 then A, B = B, A end
            local ride = L.secs * P3.RUN * least
            local geo = sqrt((A.n - sn) ^ 2 + (A.w - sw) ^ 2) + sqrt((gn - B.n) ^ 2 + (gw - B.w) ^ 2)
            local lb = geo * least + ride
            if lb < bar and geo < walkLen * 0.95 then opts[#opts + 1] = { lb, L, A, B, ride } end
        end
    end
    table.sort(opts, function(x, y) return x[1] < y[1] end)
    local pick
    P3.liftTries = (P3.liftTries or 0) + min(#opts, 4)
    for k = 1, min(#opts, 4) do
        local lb, L, A, B, ride = opts[k][1], opts[k][2], opts[k][3], opts[k][4], opts[k][5]
        if lb < best then
            local j1 = leg(sn, sw, A.n, A.w)
            j1.indoorsS, j1.bottomS, j1.landG = job.indoorsS, job.bottomS, A.floor
            if run(j1, tick, P) and (j1.cost3d or huge) + ride < best then
                local j2 = leg(B.n, B.w, gn, gw)
                j2.landS, j2.indoorsG, j2.bottomG, j2.landG = B.floor, job.indoorsG, job.bottomG, job.landG
                if run(j2, tick, P) then
                    local c = j1.cost3d + ride + (j2.cost3d or huge)
                    if c < best then best, pick = c, { j1, j2, L, A, B } end
                end
            end
        end
        if pick then break end              -- the first lift that beats the walk: good enough, and saves the searches
    end
    if not pick then
        P3.why = why
        job.lift = nil
        return ok
    end
    local j1, j2, L, A, B = pick[1], pick[2], pick[3], pick[4], pick[5]
    local X, Y, U = {}, {}, {}
    for k = 1, j1.n do X[k], Y[k], U[k] = j1.X[k], j1.Y[k], false end
    local n1 = j1.n
    for k = 1, j2.n do X[n1 + k], Y[n1 + k], U[n1 + k] = j2.X[k], j2.Y[k], false end
    job.X, job.Y, job.U, job.n, job.Z = X, Y, U, n1 + j2.n, nil
    job.len, job.unsure, job.mode, job.cell = j1.len + j2.len, 0, "terrain", j1.cell
    job.straight = sqrt((gn - sn) ^ 2 + (gw - sw) ^ 2)
    job.world3d = (j1.world3d or 0) + (j2.world3d or 0) + 1
    job.cost3d, job.pops3d = best, (job.pops3d or 0) + (j1.pops3d or 0) + (j2.pops3d or 0)
    job.long3d = j1.long3d or j2.long3d
    job.lift, job.liftAt = L.name, n1            -- the ride is between points n1 and n1 + 1
    job.liftUp = (A.z and B.z and B.z > A.z) and true or false
    P3.why = nil
    return true
end

-- the trip of this job through the 3D world. true: job.X / job.Y hold the line. false: not covered, no way found, or
-- an error (kept in P3.broken; nothing in here runs again this session): the caller goes on with its own search.
-- Runs inside the caller's search coroutine: `tick` hands the frame back when the time slice is used up.
function P3.Solve(job, tick, P)
    -- P3.why: why the last trip was passed on to the older search (kept in the saved diagnostics, so a short session
    -- in the real game tells what happened)
    if P3.off or P3.broken or not S:Get("path3D") then P3.why = P3.broken and "error" or "switched off" return false end
    if not (S.Path3DData and S.Path3DData[job.inst]) then P3.why = "no data for this continent" return false end
    P3.why = nil
    if P3.dropPending then dropIfIdle(nil) end        -- a drop that waited for another search
    local co = coroutine.create(runLifts)
    P3.live[co] = true
    if P and P.Solving and P.Solving[coroutine.running() or 0] then P.Solving[co] = true end   -- may wait a frame too
    while true do
        local ok, res = coroutine.resume(co, job, tick, P)
        if not ok then
            P3.broken = tostring(res)
            P3.why = "error"
            return false
        end
        if coroutine.status(co) == "dead" then return res == true end
        coroutine.yield()
    end
end

-- for tests and tools
P3._unpack, P3._world, P3._partsAt, P3._tileAt, P3._farEnd, P3._coarseAt = unpackTile, worldFor, partsAt, tileAt, farEnd, coarseAt
