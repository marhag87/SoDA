function SoDA:GetRunes()
    local runes = {}

    -- Known runes
    runes.numRunesKnown = C_Engraving.GetNumRunesKnown()
    local availableRunes = {
        ["DRUID"]   = SoDA:DruidRunes(),
        ["HUNTER"]  = SoDA:HunterRunes(),
        ["MAGE"]    = SoDA:MageRunes(),
        ["PALADIN"] = SoDA:PaladinRunes(),
        ["PRIEST"]  = SoDA:PriestRunes(),
        ["ROGUE"]   = SoDA:RogueRunes(),
        ["SHAMAN"]  = SoDA:ShamanRunes(),
        ["WARLOCK"] = SoDA:WarlockRunes(),
        ["WARRIOR"] = SoDA:WarriorRunes(),
    }
    local numRunesAvailable = 0
    local runeMap = {}
    for class,classRunes in pairs(availableRunes) do
        if class == self.db.global.characters[self.loggedInCharacter].basic.class then
            for _,v in ipairs(classRunes) do
                numRunesAvailable = numRunesAvailable + 1
                local name, _ = GetSpellInfo(v.spell)
                local isKnown = C_Engraving.IsKnownRuneSpell(v.id)
                table.insert(runeMap, {["id"] = v.id, ["spell"] = v.spell, ["known"] = isKnown})
            end
        end
    end
    runes.numRunesAvailable = numRunesAvailable
    runes.runeMap = runeMap

    -- Grizzby
    local grizzbyQuest = {["Horde"] = 78304, ["Alliance"] = 78297}
    local faction, _ = UnitFactionGroup("player")
    runes.grizzby = C_QuestLog.IsQuestFlaggedCompleted(grizzbyQuest[faction])

    -- Dark Riders
    local darkRiderQuests = {
        {["id"] = "80098", ["zone"] = "Deadwind Pass"},
        {["id"] = "80147", ["zone"] = "Duskwood"},
        {["id"] = "80148", ["zone"] = "Arathi Highlands"},
        {["id"] = "80149", ["zone"] = "Swamp of Sorrows"},
        {["id"] = "80150", ["zone"] = "The Barrens"},
        {["id"] = "80151", ["zone"] = "Desolace"},
        {["id"] = "80152", ["zone"] = "Badlands"},
    }
    local darkRiderMap = {}
    local darkRiderQuestsDone = 0
    for _, quest in pairs(darkRiderQuests) do
        local isDone = C_QuestLog.IsQuestFlaggedCompleted(quest.id)
        if isDone then
            darkRiderQuestsDone = darkRiderQuestsDone + 1
        end
        table.insert(darkRiderMap, {["id"] = quest.id, ["zone"] = quest.zone, ["isDone"] = isDone})
    end
    runes.darkRiderMap = darkRiderMap
    runes.darkRiderQuestsDone = darkRiderQuestsDone

    return runes
end

function SoDA:GetRunesGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    local runes = character.runes or {}

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- Runes known
    local numRunesKnown = runes.numRunesKnown or "?"
    local numRunesAvailable = runes.numRunesAvailable or "?"
    local runesKnown = self.aceGui:Create("Label")
    if numRunesKnown == numRunesAvailable and numRunesKnown ~= "?" then
        runesKnown:SetColor(0, 1, 0)
    end
    runesKnown:SetText(numRunesKnown .. "/" .. numRunesAvailable)
    group:AddChild(runesKnown)

    -- Grizzby
    local grizzby = self.aceGui:Create("Label")
    grizzby:SetText(" ")
    if runes.grizzby then
        grizzby:SetText(self.checkMark)
    end
    group:AddChild(grizzby)

    -- Dark Riders
    local darkRiderQuestsDone = runes.darkRiderQuestsDone or "?"
    local darkRider = self.aceGui:Create("Label")
    if darkRiderQuestsDone == 7 then
        darkRider:SetColor(0, 1, 0)
    end
    darkRider:SetText(darkRiderQuestsDone .. "/" .. 7)
    group:AddChild(darkRider)

    return group
end

function SoDA:GetRunesLegend()
    local group = self.aceGui:Create("SimpleGroup")

    -- Runes
    group:AddChild(SoDA:Header("Runes"))

    -- Runes
    group:AddChild(SoDA:LegendLabel("Runes"))

    -- Grizzby
    group:AddChild(SoDA:LegendLabel("Grizzby"))

    -- Dark Riders
    group:AddChild(SoDA:LegendLabel("Dark Riders"))

    return group
end
