local _, S = ...

-- Reads guide text (the step format your guide files are written in) into tables.
S.guides = {}
S.guidesByName = {}

local CONDITIONS = {
    isOnQuest = true, isNotOnQuest = true, isQuestComplete = true, isQuestTurnedIn = true, isQuestAvailable = true,
    isQuestNotComplete = true, money = true, itemcount = true, cooldown = true, itemStat = true,
    maxlevel = true, dungeon = true, skill = true, bindlocation = true, zoneskip = true, subzoneskip = true,
}

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

-- "Warrior/Paladin -- comment" -> "Warrior/Paladin"
local function cleanGate(g)
    if not g then return nil end
    g = trim((g:gsub("%-%-.*$", "")))
    if g == "" then return nil end
    return g
end

-- split a trailing "<< gate" off a piece of text, if it looks like a gate
local function splitGate(s)
    local before, gate = s:match("^(.-)%s*<<%s*([%a%s/!]+)$")
    if before and gate:match("%a") then return trim(before), cleanGate(gate) end
    return s, nil
end

local function parseElement(line)
    local cmd, rest = line:match("^%.(%w+)%s*(.*)$")
    if not cmd then return nil end
    local el = { cmd = cmd, raw = line }
    rest = trim(rest)
    local args, text = rest:match("^(.-)%s*>>%s*(.*)$")
    if args then
        text, el.gate = splitGate(text)
        el.text = text ~= "" and text or nil
    else
        args = rest
    end
    local a, comment = args:match("^(.-)%s*%-%-%s*(.*)$")
    if a then args, el.comment = a, comment end
    local g
    args, g = splitGate(args)
    el.gate = el.gate or g
    el.args = {}
    for part in (args .. ","):gmatch("(.-),") do el.args[#el.args + 1] = trim(part) end
    if #el.args == 1 and el.args[1] == "" then el.args = {} end
    return el
end

local function parseGoto(el)
    local a = el.args
    local zone, x, y = a[1], tonumber(a[2]), tonumber(a[3])
    if not (zone and x and y) then return end
    local g = { radius = tonumber(a[4]), flag = tonumber(a[5]) }
    local mapID, inst = zone:match("^(%d+)/(%d+)$")
    if mapID then
        g.mapID, g.instance, g.wa, g.wb = tonumber(mapID), tonumber(inst), x, y -- world coordinates
    elseif tonumber(zone) then
        g.mapID, g.x, g.y = tonumber(zone), x, y
    else
        g.zoneName, g.x, g.y = zone, x, y
    end
    -- radius with a trailing 0 = route waypoint (skipped once reached); radius alone = "go here" objective
    if g.radius and g.radius > 0 then
        if g.flag == 0 then g.route = true else g.objective = true end
    end
    el.go = g
end

function S.RegisterGuide(text)
    local guide = { steps = {}, labels = {} }
    local step
    for raw in (text .. "\n"):gmatch("(.-)\r?\n") do
        local line = trim(raw)
        if line == "" or line:sub(1, 2) == "--" then
            -- skip
        elseif line == "step" or line:match("^step%s") then
            step = { index = #guide.steps + 1, gate = cleanGate(line:match("<<%s*(.*)$")), tags = {}, elements = {},
                texts = {}, conds = {} }
            guide.steps[#guide.steps + 1] = step
        elseif not step then
            local tag, val = line:match("^#(%w+)%s*(.*)$")
            if tag == "next" then
                local name, gate = val:match("^(.-)%s*<<%s*(.+)$")
                guide.nexts = guide.nexts or {}
                table.insert(guide.nexts, { name = trim(name or val), gate = cleanGate(gate) })
            elseif tag then
                guide[tag] = val ~= "" and val or true
            elseif line:match("^<<") then
                guide.gate = cleanGate(line:match("^<<%s*(.*)$"))
            end
        else
            local tag, val = line:match("^#(%w+)%s*(.*)$")
            if tag then
                val = cleanGate(val) or true
                step.tags[tag] = val
                if tag == "label" and type(val) == "string" then guide.labels[val] = step.index end
            elseif line:sub(1, 2) == ">>" then
                local t, g = splitGate(trim(line:sub(3)))
                step.texts[#step.texts + 1] = { text = t, gate = g }
            elseif line:sub(1, 1) == "+" then
                local t, g = splitGate(trim(line:sub(2)))
                step.texts[#step.texts + 1] = { text = t, gate = g }
            elseif line:sub(1, 1) == "." then
                local el = parseElement(line)
                if el then
                    if el.cmd == "goto" then parseGoto(el) end
                    if el.cmd == "aura" then guide.hasAura = true end
                    -- "Hearth back to Auberdine": the inn is where this step takes you, so the
                    -- arrow and the route planner know (boat or wait if the hearth isn't ready)
                    if el.cmd == "hs" and S.InnFromText and S.InnGoto then
                        el.inn = S.InnFromText(el.text)
                        el.go = el.inn and S.InnGoto(el.inn)
                        if el.go then el.go.objective = true end
                    end
                    local a2 = el.args[2]
                    local xpCond = el.cmd == "xp" and (el.args[1] or ""):match("^[<>]") ~= nil
                    if CONDITIONS[el.cmd] or xpCond then
                        step.conds[#step.conds + 1] = el
                    else
                        el.index = #step.elements + 1
                        step.elements[#step.elements + 1] = el
                    end
                end
            end
        end
    end
    guide.name = type(guide.name) == "string" and guide.name or ("Guide " .. (#S.guides + 1))
    guide.next = guide.nexts and guide.nexts[1] and guide.nexts[1].name or nil
    -- "(Night Elf)", "(Dwarf/Gnome)"... in the name = race start chapters
    local tagName = guide.name:match("%(([^%)]+)%)%s*$")
    if tagName and tagName ~= "Alliance" and tagName ~= "Horde" then
        guide.raceGate = (tagName:gsub(" ", ""))
    end
    guide.minLevel, guide.maxLevel = guide.name:match("^(%d+)%-(%d+)")
    guide.minLevel, guide.maxLevel = tonumber(guide.minLevel), tonumber(guide.maxLevel)
    S.guides[#S.guides + 1] = guide
    S.guidesByName[guide.name] = guide
    return guide
end
