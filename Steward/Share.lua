local ADDON, S = ...

-- Send my Steward report (0.80.0, 2026-11-22). Nick: "my friend is going to be using steward, it would be useful to
-- get his usage data the way you get mine" / "I would like a button".
--
-- A player presses "Send my Steward report" (Options > Steward), names someone online who runs Steward, and this
-- character's diagnostics (errors, route and step logs, failed route searches, ride times...) go to them through hidden
-- add-on messages, a little at a time; nothing appears in chat. The one receiving is asked first and keeps the report
-- in StewardDB.reports, as text only: nothing received is ever run.
--
-- The messages (prefix "StewardRpt", whispers, at most 255 bytes each):
--   H:<id>:<pieces>:<bytes>:<version>   "may I send you a report?" (sender -> receiver)
--   A:<id> / N:<id>                     yes / no (receiver -> sender)
--   D:<id>:<n>:<text>                   piece n of the report (sender -> receiver, after the yes)
--   K:<id>                              all pieces arrived and the report is kept (receiver -> sender)

local PREFIX = "StewardRpt"
local PIECE = 220                -- characters of report per message (the rest of the 255 is the header)
local PER_SECOND = 4             -- pieces sent each second: the game slows add-on messages down past a burst
local MAX_BYTES = 60000          -- the biggest report sent or taken
local MAX_PIECES = math.ceil(MAX_BYTES / PIECE)
local KEEP_PER_SENDER = 3        -- reports kept per friend (the oldest goes)
local KEEP_BYTES = 400000        -- all friends' reports together (the oldest go)
local ASK_WAIT = 120             -- seconds to wait for the other side to say yes
local PIECE_WAIT = 120           -- seconds without a new piece before a half-sent report is dropped

local Share = {}
S.Share = Share

---------------------------------------------------------------- the report
-- one value as Lua-like text, with limits: nested tables cut at a depth, long lists keep their last entries,
-- long strings are cut. It's for reading, never for running.
local function dump(v, depth, out, indent)
    local t = type(v)
    if t == "string" then
        if #v > 300 then v = v:sub(1, 300) .. "..." end
        out[#out + 1] = string.format("%q", v)
    elseif t == "number" or t == "boolean" or t == "nil" then
        out[#out + 1] = tostring(v)
    elseif t == "table" then
        if depth <= 0 then out[#out + 1] = "{...}" return end
        local n = #v
        local keys = {}
        for k in pairs(v) do
            if not (type(k) == "number" and k >= 1 and k <= n and k % 1 == 0) then keys[#keys + 1] = k end
        end
        table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
        out[#out + 1] = "{"
        local pad = indent .. "  "
        local first = math.max(1, n - 39)                 -- a long list keeps its last 40
        if first > 1 then out[#out + 1] = "\n" .. pad .. "-- " .. (first - 1) .. " older left out" end
        for i = first, n do
            out[#out + 1] = "\n" .. pad
            dump(v[i], depth - 1, out, pad)
            out[#out + 1] = ","
        end
        for i = 1, math.min(#keys, 60) do
            local k = keys[i]
            out[#out + 1] = "\n" .. pad .. "[" .. (type(k) == "string" and string.format("%q", k) or tostring(k)) .. "] = "
            dump(v[k], depth - 1, out, pad)
            out[#out + 1] = ","
        end
        if #keys > 60 then out[#out + 1] = "\n" .. pad .. "-- " .. (#keys - 60) .. " more keys left out" end
        out[#out + 1] = "\n" .. indent .. "}"
    else
        out[#out + 1] = "<" .. t .. ">"
    end
end

-- what goes in, most useful first; a report too big drops sections from the end of this list
local SECTIONS = {
    { "errors",            function() return StewardCharDB and StewardCharDB.errors end },
    { "pathDiag",          function() return StewardDB and StewardDB.pathDiag end },
    { "routeLog",          function() return StewardCharDB and StewardCharDB.routeLog end },
    { "stepLog",           function() return StewardCharDB and StewardCharDB.stepLog end },
    { "trainDiag",         function() return StewardCharDB and StewardCharDB.trainDiag end },
    { "travelError",       function() return StewardCharDB and StewardCharDB.travelError end },
    { "followTravelError", function() return StewardCharDB and StewardCharDB.followTravelError end },
    { "trainingError",     function() return StewardCharDB and StewardCharDB.trainingError end },
    { "scanError",         function() return StewardCharDB and StewardCharDB.scanError end },
    { "trackerStuck",      function() return StewardCharDB and StewardCharDB.trackerStuck end },
    { "rideDiag",          function() return StewardDB and StewardDB.rideDiag end },
    { "rides",             function() return StewardDB and StewardDB.rides end },
    { "modeDiag",          function() return StewardDB and StewardDB.modeDiag end },
    { "menuDiag",          function() return StewardDB and StewardDB.menuDiag end },
    { "guideCheck",        function() return StewardDB and StewardDB.guideCheck end },
    { "talentLog",         function() return StewardCharDB and StewardCharDB.talentLog end },
    { "rotationLog",       function() return StewardCharDB and StewardCharDB.rotationLog end },
    { "sellLog",           function() return StewardCharDB and StewardCharDB.sellLog end },
}
Share.SECTIONS = SECTIONS

-- the settings that change what Steward does (only those that differ from how Steward comes)
local function changedSettings()
    local out = {}
    for k, def in pairs(S.defaults or {}) do
        local v = StewardDB and StewardDB[k]
        if v ~= nil and v ~= def and type(v) ~= "table" then out[k] = v end
    end
    return out
end

function Share.Build()
    local head = {}
    local function add(k, v) head[#head + 1] = k .. " = " .. string.format("%q", tostring(v)) end
    add("steward", S.version)
    add("date", date and date("%Y-%m-%d %H:%M:%S") or "?")
    add("character", UnitName and UnitName("player") or "?")
    local race, raceTok, class, classTok
    if UnitRace then race, raceTok = UnitRace("player") end
    if UnitClass then class, classTok = UnitClass("player") end
    race, class = raceTok or race, classTok or class
    add("race", race) add("class", class)
    add("level", UnitLevel and UnitLevel("player"))
    add("faction", UnitFactionGroup and UnitFactionGroup("player"))
    add("zone", GetRealZoneText and GetRealZoneText())
    add("mapID", C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player"))
    add("guideMode", StewardCharDB and StewardCharDB.guideMode)
    add("client", GetBuildInfo and table.concat({ GetBuildInfo() }, " ") or "?")
    local g = StewardCharDB and StewardCharDB.guide
    local parts = { "-- Steward report\n" .. table.concat(head, "\n") }
    if g then
        local gs = {}
        for _, k in ipairs({ "name", "step", "chapter", "current" }) do if g[k] ~= nil then gs[#gs + 1] = k .. "=" .. tostring(g[k]) end end
        parts[#parts + 1] = "guide = " .. string.format("%q", table.concat(gs, " "))
    end
    local o = {} dump(changedSettings(), 2, o, "") parts[#parts + 1] = "settings = " .. table.concat(o)
    local size = #table.concat(parts, "\n\n")
    local left = {}
    for _, sec in ipairs(SECTIONS) do
        local ok, v = pcall(sec[2])
        if ok and v ~= nil and not (type(v) == "table" and next(v) == nil) then
            local out = {}
            dump(v, 5, out, "")
            local text = sec[1] .. " = " .. table.concat(out)
            if size + #text + 2 <= MAX_BYTES then
                parts[#parts + 1] = text
                size = size + #text + 2
            else
                left[#left + 1] = sec[1]
            end
        end
    end
    if #left > 0 then parts[#parts + 1] = "-- left out to keep it small: " .. table.concat(left, ", ") end
    return table.concat(parts, "\n\n")
end

---------------------------------------------------------------- sending
local function base(name) return (tostring(name or ""):match("^([^%-]+)") or ""):lower() end
local function send(msg, to)
    if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then return "nochat" end
    local ok, r = pcall(C_ChatInfo.SendAddonMessage, PREFIX, msg, "WHISPER", to)
    if not ok then return "error" end
    -- old clients answer true/false, new ones a result number (0 = sent; 3, 8, 11 = slowed down or locked; 12 = offline)
    if r == nil or r == true or r == 0 then return "sent" end
    if r == 12 then return "offline" end
    if r == false or r == 3 or r == 8 or r == 11 then return "later" end
    return "error"
end
local function busy()
    if InCombatLockdown and InCombatLockdown() then return true end
    if IsInInstance and IsInInstance() then return true end     -- the game may block add-on messages in instances
    return false
end

local out              -- the report being sent: { id, to, pieces, next, state, asked, tries }
local ticker
local function note(text, quiet)
    Share.lastStatus = text
    if not quiet and S.ShareNotice then S:ShareNotice(text) end
end

local function stopTicker() if ticker then ticker:Cancel() ticker = nil end end
local function tick()
    if not out then stopTicker() return end
    local now = GetTime()
    if out.state == "asking" then
        if now - out.asked > ASK_WAIT then
            note(out.to .. " didn't answer. They need Steward 0.80 or newer, must be online, and must press Yes.")
            out = nil stopTicker()
        end
        return
    end
    if out.state == "sending" then
        if busy() then return end
        for _ = 1, PER_SECOND do
            if out.next > #out.pieces then out.state = "waiting" out.asked = now break end
            local r = send("D:" .. out.id .. ":" .. out.next .. ":" .. out.pieces[out.next], out.to)
            if r == "sent" then
                out.next = out.next + 1 out.tries = 0
            elseif r == "later" then
                out.tries = out.tries + 1
                if out.tries > 60 then note("Sending to " .. out.to .. " stopped: the game kept slowing it down. Try again later.") out = nil stopTicker() end
                break
            elseif r == "offline" then
                note(out.to .. " went offline. Try again when they're on.") out = nil stopTicker() break
            else
                note("Sending to " .. out.to .. " didn't work.") out = nil stopTicker() break
            end
        end
        return
    end
    if out.state == "waiting" and now - out.asked > ASK_WAIT then
        note("The report went out to " .. out.to .. ", but they didn't confirm it arrived.")
        out = nil stopTicker()
    end
end

-- start sending this character's report to `to` (a character name, with -Realm if they're on another realm)
function Share.SendTo(to)
    to = tostring(to or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if to == "" then return false, "no name" end
    if base(to) == base(UnitName and UnitName("player")) then note("That's you.") return false, "self" end
    if out then note("A report is already on its way to " .. out.to .. ".") return false, "busy" end
    local text = Share.Build()
    local pieces = {}
    for i = 1, #text, PIECE do pieces[#pieces + 1] = text:sub(i, i + PIECE - 1) end
    local id = tostring(math.floor((GetTime() or 0) * 1000) % 1000000)
    out = { id = id, to = to, pieces = pieces, next = 1, state = "asking", asked = GetTime(), tries = 0, bytes = #text }
    StewardDB.shareTo = to
    local r = send("H:" .. id .. ":" .. #pieces .. ":" .. #text .. ":" .. tostring(S.version), to)
    if r == "offline" then note(to .. " isn't online.") out = nil return false, "offline" end
    if r ~= "sent" and r ~= "later" then note("Sending didn't work.") out = nil return false, r end
    note("Asked " .. to .. " to take your report (" .. math.ceil(#text / 1024) .. " KB). Waiting for them to press Yes...")
    stopTicker()
    ticker = C_Timer.NewTicker(1, tick)
    return true
end
function Share.Sending() return out end

---------------------------------------------------------------- receiving
local inbox = {}          -- [sender base name .. id] = { from, id, n, bytes, ver, got = {}, count, last, accepted }
local declined = {}       -- senders said no to this session
local asking               -- the inbox entry the Yes/No popup is about

local function keep(entry)
    local text = table.concat(entry.got)
    StewardDB.reports = StewardDB.reports or {}
    local R = StewardDB.reports
    local list = R[entry.from] or {}
    R[entry.from] = list
    local new = { at = date and date("%Y-%m-%d %H:%M:%S") or "?", ver = entry.ver, bytes = #text, text = text }
    list[#list + 1] = new
    while #list > KEEP_PER_SENDER do table.remove(list, 1) end
    -- all friends' reports together stay under the cap: the oldest other report goes first
    while true do
        local total, oldest, oldList, oldIdx = 0, nil, nil, nil
        for _, l in pairs(R) do
            for i, rep in ipairs(l) do
                total = total + (rep.bytes or 0)
                if rep ~= new and (not oldest or tostring(rep.at) < tostring(oldest.at)) then oldest, oldList, oldIdx = rep, l, i end
            end
        end
        if total <= KEEP_BYTES or not oldList then break end
        table.remove(oldList, oldIdx)
    end
    for k, l in pairs(R) do if #l == 0 then R[k] = nil end end
end

function Share.Answer(yes)
    local e = asking
    asking = nil
    if not e then return end
    if yes then
        e.accepted = true e.last = GetTime()
        send("A:" .. e.id, e.from)
    else
        declined[base(e.from)] = true
        inbox[base(e.from) .. e.id] = nil
        send("N:" .. e.id, e.from)
    end
end
function Share.Asking() return asking end

local function onMessage(prefix, msg, channel, sender)
    if prefix ~= PREFIX or type(msg) ~= "string" or channel ~= "WHISPER" then return end
    local kind, id, rest = msg:match("^(%u):(%d+):?(.*)$")
    if not kind then return end
    local who = base(sender)
    -- answers to a report this character is sending
    if out and out.id == id and who == base(out.to) then
        if kind == "A" and out.state == "asking" then
            out.state = "sending" out.to = sender
            note(out.to .. " said yes. Sending your report...", true)
        elseif kind == "N" then
            note(out.to .. " said no.") out = nil stopTicker()
        elseif kind == "K" then
            note("Your report reached " .. out.to .. ".") out = nil stopTicker()
        end
        return
    end
    -- a report someone sends this character
    if kind == "H" then
        if declined[who] or asking then return end
        local n, bytes, ver = rest:match("^(%d+):(%d+):(.*)$")
        n, bytes = tonumber(n), tonumber(bytes)
        if not n or n < 1 or n > MAX_PIECES or bytes > MAX_BYTES then return end
        local e = { from = sender, id = id, n = n, bytes = bytes, ver = ver:sub(1, 20), got = {}, count = 0, last = GetTime() }
        inbox[who .. id] = e
        asking = e
        if S.ShareAsk then S:ShareAsk(e) end
    elseif kind == "D" then
        local e = inbox[who .. id]
        if not (e and e.accepted) then return end
        local seq, text = rest:match("^(%d+):(.*)$")
        seq = tonumber(seq)
        if not seq or seq < 1 or seq > e.n or e.got[seq] then return end
        e.got[seq] = text e.count = e.count + 1 e.last = GetTime()
        if e.count == e.n then
            inbox[who .. id] = nil
            local whole = table.concat(e.got)
            if #whole == e.bytes then
                keep(e)
                send("K:" .. id, e.from)
                if S.ShareNotice then S:ShareNotice("Kept " .. e.from .. "'s Steward report.") end
            end
        end
    end
end

-- half-sent reports that stopped coming are dropped
local function sweep()
    local now = GetTime()
    for k, e in pairs(inbox) do
        if now - (e.last or now) > PIECE_WAIT then
            inbox[k] = nil
            if asking == e then asking = nil end
        end
    end
end

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX) end
if C_Timer and C_Timer.NewTicker then C_Timer.NewTicker(30, sweep) end
S:On("CHAT_MSG_ADDON", function(prefix, msg, channel, sender) onMessage(prefix, msg, channel, sender) end)

function Share.ReportCount()
    local n, people = 0, 0
    for _, l in pairs((StewardDB and StewardDB.reports) or {}) do people = people + 1 n = n + #l end
    return n, people
end
function Share.DeleteAll() if StewardDB then StewardDB.reports = nil end end

---------------------------------------------------------------- the popups (the game's own)
-- the ones carrying a real choice don't close on Escape
local function editBoxOf(dialog) return (dialog.GetEditBox and dialog:GetEditBox()) or dialog.editBox end
function S:ShareStart()
    if not (StaticPopupDialogs and StaticPopup_Show) then return end
    StaticPopupDialogs.STEWARD_SHARE = StaticPopupDialogs.STEWARD_SHARE or {
        text = "Send your Steward report to whom?\n\nIt holds this character's Steward logs: errors, routes, "
            .. "steps, ride times and route searches that failed, so problems can be found and fixed. Nothing goes "
            .. "in chat. They need Steward too, must be online and will be asked first. Same faction; "
            .. "add -Realm if they're on another realm.",
        button1 = "Send", button2 = CANCEL or "Cancel",
        hasEditBox = true, maxLetters = 60,
        OnShow = function(self) local eb = editBoxOf(self) if eb then eb:SetText(StewardDB.shareTo or "") eb:SetFocus() end end,
        OnAccept = function(self) local eb = editBoxOf(self) Share.SendTo(eb and eb:GetText()) end,
        EditBoxOnEnterPressed = function(self)
            local p = self:GetParent() Share.SendTo(self:GetText()) if p and p.Hide then p:Hide() end
        end,
        timeout = 0, whileDead = true, hideOnEscape = false,
    }
    StaticPopup_Show("STEWARD_SHARE")
end
function S:ShareAsk(e)
    if not (StaticPopupDialogs and StaticPopup_Show) then Share.Answer(false) return end
    StaticPopupDialogs.STEWARD_SHARE_ASK = StaticPopupDialogs.STEWARD_SHARE_ASK or {
        text = "%s wants to send you their Steward report (%s KB).\n\nKeep it? It's saved with your Steward settings, as text.",
        button1 = YES or "Yes", button2 = NO or "No",
        OnAccept = function() Share.Answer(true) end,
        OnCancel = function() Share.Answer(false) end,
        timeout = 0, whileDead = true, hideOnEscape = false,
    }
    StaticPopup_Show("STEWARD_SHARE_ASK", tostring(e.from), tostring(math.max(1, math.ceil(e.bytes / 1024))))
end
function S:ShareNotice(text)
    if not (StaticPopupDialogs and StaticPopup_Show) then return end
    StaticPopupDialogs.STEWARD_SHARE_NOTE = StaticPopupDialogs.STEWARD_SHARE_NOTE or {
        text = "%s", button1 = OKAY or "Okay", timeout = 0, whileDead = true, hideOnEscape = true,
    }
    StaticPopup_Show("STEWARD_SHARE_NOTE", text)
end
function S:ShareConfirmDelete()
    local n, people = Share.ReportCount()
    if n == 0 then S:ShareNotice("No friend has sent you a Steward report.") return end
    if not (StaticPopupDialogs and StaticPopup_Show) then return end
    StaticPopupDialogs.STEWARD_SHARE_DEL = StaticPopupDialogs.STEWARD_SHARE_DEL or {
        text = "Delete the %s Steward reports friends sent you? This can't be undone.",
        button1 = YES or "Yes", button2 = NO or "No",
        OnAccept = function() Share.DeleteAll() end,
        timeout = 0, whileDead = true, hideOnEscape = false,
    }
    StaticPopup_Show("STEWARD_SHARE_DEL", tostring(n))
end
