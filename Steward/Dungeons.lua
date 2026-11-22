local _, S = ...

-- Dungeon notes. When you zone into a dungeon, a small card beside the quest list gives the
-- level range, the quests worth carrying in, and what to watch for on the way through.
-- It closes with the X and comes back the next time you enter. Written for the classic
-- dungeons; WoW: Forever may have changed some details.

local D = {
    [389] = { name = "Ragefire Chasm", lvl = "13-18", notes = {
        "Horde: take the Ragefire quests in Orgrimmar's Cleft of Shadow and Thunder Bluff before you go in.",
        "Jergosh the Invoker puts a curse on you; anyone who can remove curses should.",
        "Taragaman the Hungerer is the last boss; his fire nova hits everyone near him." } },
    [43] = { name = "Wailing Caverns", lvl = "17-24", notes = {
        "Quests come from the Crossroads and from the druids on the hill above the cave mouth.",
        "The Druids of the Fang cast sleep: kill them first in every pack.",
        "Four Fang druid leaders guard the caves; with all four dead, the Disciple of Naralex at the entrance can start the final event.",
        "During that escort, keep him alive until Mutanus the Devourer appears." } },
    [36] = { name = "The Deadmines", lvl = "17-26", notes = {
        "Alliance: bring the Defias quests from Sentinel Hill; the chain ends with Edwin VanCleef.",
        "Sneed's Shredder drops Sneed himself when it dies; kill him too.",
        "Mr. Smite stuns the group and changes weapons at low health.",
        "A cannon past Gilnid blows open the big door to the pirate ship.",
        "VanCleef calls in helpers when he gets low; save cooldowns for that.",
        { class = "PALADIN", text = "Paladins: Goblin Woodcarvers here drop the Whitestone Oak Lumber for The Test of Righteousness (Verigan's Fist)." } } },
    [33] = { name = "Shadowfang Keep", lvl = "22-30", notes = {
        "Horde: the Sepulcher in Silverpine has the quests, including one to end Arugal.",
        "Free the prisoner in the first courtyard; they open the door into the keep.",
        "Commander Springvale and Odo the Blindwatcher hit hard: use cooldowns there.",
        "Arugal teleports around the room and turns people into worgen briefly.",
        { class = "PALADIN", text = "Paladins: Jordan's Smithing Hammer for The Test of Righteousness lies in the stables in the first courtyard, past Rethilgore." } } },
    [48] = { name = "Blackfathom Deeps", lvl = "24-32", notes = {
        "Quests: Auberdine and Darnassus for the Alliance, Zoram'gar Outpost for the Horde.",
        "Much of it is underwater: watch your breath bar and pull to dry ground.",
        "Light all four fires in the last room to open Aku'mai's door; each fire calls a wave.",
        "Twilight Lord Kelris puts people to sleep." } },
    [34] = { name = "The Stockade", lvl = "24-32", notes = {
        "Alliance only: quests come from Lakeshire, Darkshire, Ironforge and Stormwind.",
        "Packs stand close together in the narrow halls: pull slowly.",
        "Bazil Thredd is at the far end; Bruegal Ironknuckle sometimes appears as a rare." } },
    [90] = { name = "Gnomeregan", lvl = "29-38", notes = {
        "Alliance quests are in Tinker Town, Ironforge; Horde quests come from Ratchet.",
        "It's a long run: plan for an hour and a half.",
        "Viscous Fallout and the irradiated mobs leave radiation: don't stand in it.",
        "Mekgineer Thermaplugg calls bombs from the walls; turn the wall panels off." } },
    [47] = { name = "Razorfen Kraul", lvl = "29-38", notes = {
        "Grab Willix the Importer's escort inside and the Blueleaf Tuber quest from Camp Taurajo.",
        "Charlga Razorflank waits at the end: clear her guards before you pull her." } },
    [189] = { name = "Scarlet Monastery", lvl = "30-45", notes = {
        "Four wings, easiest first: Graveyard, Library, Armory, Cathedral.",
        "Arcanist Doan in the Library drops the key that opens the Armory and Cathedral.",
        "Herod in the Armory whirlwinds: melee step back when he spins.",
        "In the Cathedral, Whitemane brings Mograine back to life: kill her fast once she arrives." } },
    [129] = { name = "Razorfen Downs", lvl = "37-46", notes = {
        "Escort Belnistrasz inside; ringing the gong also brings out Tuten'kash.",
        "Many undead: Exorcism and Turn Undead earn their keep here.",
        "Amnennar the Coldbringer at the end casts frost nova." } },
    [70] = { name = "Uldaman", lvl = "41-51", notes = {
        "Quests from Ironband's camp in Loch Modan (Alliance) and Kargath (Horde).",
        "Ironaya is a giant who knocks people back: keep your back to a wall.",
        "Archaedas wakes the statues around the room; kill the small ones as they come." } },
    [209] = { name = "Zul'Farrak", lvl = "44-54", notes = {
        "Quests come from Gadgetzan and Steamwheedle Port.",
        "Freeing the prisoners on the pyramid starts a stairs fight against waves of trolls: hold the top.",
        "Gahz'rilla needs the Mallet of Zul'Farrak to summon.",
        "Antu'sul calls basilisks; kill them as they arrive." } },
    [349] = { name = "Maraudon", lvl = "46-55", notes = {
        "The quests come from Desolace, the centaur villages and the Cenarion camps.",
        "Purple and Orange wings lead to the waterfall; the inner part ends at Princess Theradras.",
        "Several bosses use poison: keep cures ready." } },
    [109] = { name = "Sunken Temple", lvl = "50-56", notes = {
        "Several class quests take you here: check your quest log before you go in.",
        "Lighting the statues on the balcony in the right order summons Atal'alarion.",
        "The Avatar of Hakkar is an event fight tied to a quest: read the quest text before you start it." } },
    [230] = { name = "Blackrock Depths", lvl = "52-60", notes = {
        "Huge: most groups run it in pieces. Many doors need the Shadowforge Key.",
        "The Ring of Law gives a random fight. In the Grim Guzzler, don't take drinks from the kegs or the bar turns on you.",
        "Molten Core needs a shard from inside: take that quest from Lothos Riftwaker on Blackrock Mountain first.",
        "Emperor Dagran Thaurissan is last; the princess heals him, so focus him." } },
    [229] = { name = "Blackrock Spire", lvl = "55-60", notes = {
        "Lower Spire is a 5-player dungeon; Upper Spire needs a raid and the Seal of Ascension.",
        "Spiders and orc packs come in big groups: pull carefully.",
        "Mother Smolderweb's poison: keep cures or antidotes ready." } },
    [429] = { name = "Dire Maul", lvl = "56-60", notes = {
        "Three wings: East is the easiest, North is the Gordok ogres, West is the hardest.",
        "In North, leaving the guards alive and the king to last gives the tribute chest.",
        "In West, destroy the pylons before Immol'thar." } },
    [289] = { name = "Scholomance", lvl = "58-60", notes = {
        "You need the Skeleton Key from the Western Plaguelands quest chain to get in.",
        "Ras Frostwhisper and Darkmaster Gandling hit hard; Gandling teleports people into side rooms." } },
    [329] = { name = "Stratholme", lvl = "58-60", notes = {
        "Two sides: the living side (main gate) ends at Balnazzar, the undead side at Baron Rivendare.",
        "Lots of undead and plague: keep disease cures ready.",
        "Many quests come from Light's Hope Chapel and Western Plaguelands." } },
    -- WoW: Forever's new dungeons (found by name; instance numbers not known yet)
    ["Hall of Thanes"] = { name = "Hall of Thanes", lvl = "13-18", notes = {
        "Beneath Ironforge: the Alliance walk in from the city; Horde groups have to cross Alliance land.",
        "Bosses: Faldrim Anvilmar, Infurnus, Plunder, Durgen Dirgehammer." } },
    ["Ruins of Lordaeron"] = { name = "Ruins of Lordaeron", lvl = "15-20", notes = {
        "The ruined city above the Undercity: the Horde go straight in from the Undercity.",
        "Bosses: Witherfang, The Abandoned, The Butcher, Lordaeron Captain, Viktor the Vile, Bjork, Rath'mael." } },
    ["Excavation Site"] = { name = "Excavation Site", lvl = "24-29", notes = {
        "Above Whelgar's Excavation in the Wetlands.",
        "Bosses: Saltspine, Shadetooth, Highland Horror, Relic Guardian." } },
    ["Dalaran"] = { name = "City of Dalaran", lvl = "28-33", notes = {
        "Needs an attunement chain first. Alliance: \"An Alarming Request\" from Emissary Jacques in Southshore. Horde: \"Key to the City\" and \"Prison Break-In\" from Magus Wordeen Voidglare in Tarren Mill.",
        "You enter through the sewers.",
        "Bosses include Lyn the Ignored, Atrexis the Grave Knight and the Shade of the Archmage at the end." } },
    ["Drowned City"] = { name = "The Drowned City", lvl = "35-40", notes = {
        "Underwater in the Sunken Hollow, west of the Vile Reef off Stranglethorn's coast (about 21.4, 27.8): watch your breath on the way in.",
        "Bosses include Zul'Alai, Captain Dreadrise and Min'loth the Serpent." } },
    ["Krol'dok Stronghold"] = { name = "Krol'dok Stronghold", lvl = "40-45", notes = {
        "In the Riverglades.",
        "Bosses: Slavecrusher Grox, Twilight Commander Zarmok, Handler Ashka, Nar'gurk, Overseer Mugg." } },
    ["Alcaz Prison"] = { name = "Alcaz Prison", lvl = "48-53", notes = {
        "On Alcaz Island off Dustwallow Marsh.",
        "Bosses: Overseer Wrex, Tidemistress Ca'zass, Katerina the Cleaner, The Questioner, Blazeroar." } },
    ["Blackmaw Hold"] = { name = "Blackmaw Hold", lvl = "55-60", notes = {
        "In Azshara, behind a long-sealed gate.",
        "Bosses include Withermaw, Elder Shaman Bloodmane and the Blackmaw Behemoth at the end." } },
    ["Shaper's Terrace"] = { name = "Shaper's Terrace", lvl = "58-60", notes = {
        "In the northern hills of Un'Goro Crater.",
        "Collect power crystals around Un'Goro first: the consoles inside need them. Cinder appears after the Archival Panel." } },
}
S.DUNGEON_NOTES = D

local card

local function build()
    if card then return card end
    card = CreateFrame("Frame", "StewardDungeonCard", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    card:SetSize(270, 60)
    card:SetFrameStrata("MEDIUM")
    if card.SetBackdrop then
        card:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 } })
        card:SetBackdropColor(0, 0, 0, 0.8)
        card:SetBackdropBorderColor(0.6, 0.5, 0.3)
    end
    card.title = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    card.title:SetPoint("TOPLEFT", 10, -9)
    card.title:SetPoint("RIGHT", -26, 0)
    card.title:SetJustifyH("LEFT")
    local ok, close = pcall(CreateFrame, "Button", nil, card, "UIPanelCloseButton")
    if ok and close then
        close:SetSize(22, 22)
        close:SetPoint("TOPRIGHT", -2, -2)
        close:SetScript("OnClick", function() card:Hide() end)
    end
    card.lines = {}
    card:Hide()
    return card
end

function S:ShowDungeonNotes(id, fallbackName)
    local d = D[id]
    if not d and fallbackName then
        -- by name, loosely ("Excavation Site: Wetlands", "The Deadmines")
        local want = fallbackName:lower():gsub("^the ", "")
        for _, e in pairs(D) do
            local n = e.name:lower():gsub("^the ", "")
            if n == want or want:find(n, 1, true) or n:find(want, 1, true) then d = e break end
        end
    end
    local c = build()
    if not d or not self:Get("dungeonNotes") then c:Hide() return false end
    c.title:SetText(string.format("%s  |cffaaaaaa(level %s)|r", d.name, d.lvl))
    for _, fs in ipairs(c.lines) do fs:Hide() end
    -- class-only notes only for that class
    local notes, class = {}, self:PlayerClass()
    for _, n in ipairs(d.notes) do
        if type(n) == "table" then
            if n.class == class then notes[#notes + 1] = n.text end
        else
            notes[#notes + 1] = n
        end
    end
    local y, last = -30, nil
    for i, text in ipairs(notes) do
        local fs = c.lines[i]
        if not fs then
            fs = c:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            fs:SetJustifyH("LEFT")
            fs:SetWidth(246)
            c.lines[i] = fs
        end
        fs:ClearAllPoints()
        if last then fs:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -5) else fs:SetPoint("TOPLEFT", 12, y) end
        fs:SetText("- " .. text)
        fs:Show()
        last = fs
    end
    local h = 36
    for i = 1, #notes do h = h + (c.lines[i]:GetStringHeight() or 12) + 5 end
    c:SetHeight(h)
    c:ClearAllPoints()
    -- beside the quest list, so neither covers the other
    local tracker = _G.ObjectiveTrackerFrame
    if tracker and tracker:IsShown() and tracker.GetTop and tracker:GetTop() then
        c:SetPoint("TOPRIGHT", tracker, "TOPLEFT", -12, 0)
    else
        c:SetPoint("TOPRIGHT", _G.MinimapCluster or UIParent, "BOTTOMRIGHT", -10, -10)
    end
    c:Show()
    return true
end

local function onZone()
    local c = build()
    if not IsInInstance or not GetInstanceInfo then return end
    local inside, kind = IsInInstance()
    if not inside or (kind ~= "party" and kind ~= "raid") then
        c:Hide()
        S.dungeonShownFor = nil
        return
    end
    local name, _, _, _, _, _, _, id = GetInstanceInfo()
    if S.dungeonShownFor == id then return end -- once per visit
    S.dungeonShownFor = id
    S:ShowDungeonNotes(id, name)
end

S:On("PLAYER_ENTERING_WORLD", function() C_Timer.After(2, function()
    local ok, err = pcall(onZone)
    if not ok then S:LogError("dungeon notes", err) end
end) end)
