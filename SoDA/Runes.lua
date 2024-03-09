function SoDA:GetRunes()
    local runes = {}

    -- Known runes
    runes.numRunesKnown = 0
    runes.numRunesAvailable = 0
    runes.known = {}
    runes.unknown = {}
    local filter = {
        -- Druid
        -- Hunter
        48859, -- Aspect of the Viper
        -- Mage
        -- Paladin
        -- Priest
        48274, -- Shadowfiend
        -- Rogue
        48164, -- Shadowstep (Legs)
        -- Shaman
        -- Warlock
        -- Warrior
        48334, -- Commanding Shout
    }

    for _, category in pairs(self.runeCategories) do
        local known = C_Engraving.GetRunesForCategory(category, true)
        local all = C_Engraving.GetRunesForCategory(category, false)
        for _, rune in pairs(known) do
            runes.numRunesKnown = runes.numRunesKnown + 1
            table.insert(runes.known, rune)
        end
        for _, rune in pairs(all) do
            local isFiltered = false
            for _, filteredRune in pairs(filter) do
                if rune.skillLineAbilityID == filteredRune then
                    isFiltered = true
                end
            end
            local isKnown = false
            for _, knownRune in pairs(known) do
                if knownRune.name == rune.name then
                    isKnown = true
                end
            end
            if not isFiltered then
                if not isKnown then
                    table.insert(runes.unknown, rune)
                end
                runes.numRunesAvailable = runes.numRunesAvailable + 1
            end
        end
    end

    -- Grizzby
    local grizzbyQuest = { ["Horde"] = 78304, ["Alliance"] = 78297 }
    local faction, _ = UnitFactionGroup("player")
    runes.grizzby = C_QuestLog.IsQuestFlaggedCompleted(grizzbyQuest[faction])

    -- Dark Riders
    local darkRiderQuests = {
        { ["id"] = "80098", ["zone"] = "Deadwind Pass" },
        { ["id"] = "80147", ["zone"] = "Duskwood" },
        { ["id"] = "80148", ["zone"] = "Arathi Highlands" },
        { ["id"] = "80149", ["zone"] = "Swamp of Sorrows" },
        { ["id"] = "80150", ["zone"] = "The Barrens" },
        { ["id"] = "80151", ["zone"] = "Desolace" },
        { ["id"] = "80152", ["zone"] = "Badlands" },
    }
    local darkRiderMap = {}
    local darkRiderQuestsDone = 0
    for _, quest in pairs(darkRiderQuests) do
        local isDone = C_QuestLog.IsQuestFlaggedCompleted(quest.id)
        if isDone then
            darkRiderQuestsDone = darkRiderQuestsDone + 1
        end
        table.insert(darkRiderMap, { ["id"] = quest.id, ["zone"] = quest.zone, ["isDone"] = isDone })
    end
    runes.darkRiderMap = darkRiderMap
    runes.darkRiderQuestsDone = darkRiderQuestsDone

    return runes
end

function SoDA:GetRunesGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
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
    runesKnown:SetWidth(self.defaultWidth)
    -- Runes tooltip
    runesKnown.frame:SetScript("OnEnter", function(_)
        SoDA:RunesTooltip(runesKnown.frame, runes)
    end)
    runesKnown.frame:SetScript("OnLeave", function(_)
        GameTooltip:Hide()
    end)
    group:AddChild(runesKnown)

    -- Grizzby
    local grizzby = self.aceGui:Create("Label")
    grizzby:SetWidth(self.defaultWidth)
    grizzby:SetText(" ")
    if runes.grizzby then
        grizzby:SetText(self.checkMark)
    end
    group:AddChild(grizzby)

    -- Dark Riders
    local darkRiderQuestsDone = runes.darkRiderQuestsDone or "?"
    local darkRider = self.aceGui:Create("Label")
    darkRider:SetWidth(self.defaultWidth)
    if darkRiderQuestsDone == 7 then
        darkRider:SetColor(0, 1, 0)
    end
    darkRider:SetText(darkRiderQuestsDone .. "/" .. 7)
    -- Dark Riders tooltip
    darkRider.frame:SetScript("OnEnter", function(_)
        SoDA:DarkRidersTooltip(darkRider.frame, runes)
    end)
    darkRider.frame:SetScript("OnLeave", function(_)
        GameTooltip:Hide()
    end)
    group:AddChild(darkRider)

    return group
end

function SoDA:GetRunesLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

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

function SoDA:RunesTooltip(frame, runes)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine("Runes")
    if runes.known == nil then
        GameTooltip:AddLine("No rune data, please log this character and open the character sheet to refresh")
    else
        local known = runes.known or {}
        local unknown = runes.unknown or {}
        for categoryName, category in pairs(self.runeCategories) do
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cffffffff" .. categoryName .. FONT_COLOR_CODE_CLOSE)
            for _, rune in ipairs(known) do
                if rune.equipmentSlot == category then
                    GameTooltip:AddDoubleLine(rune.name, self.checkMark)
                end
            end
            for _, rune in ipairs(unknown) do
                if rune.equipmentSlot == category then
                    GameTooltip:AddDoubleLine(rune.name, " ")
                end
            end
        end
    end
    GameTooltip:Show()
end

function SoDA:DarkRidersTooltip(frame, runes)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine("Dark Riders")
    local darkRiderMap = runes.darkRiderMap or {}
    GameTooltip:AddLine(" ")
    for _, rider in pairs(darkRiderMap) do
        if rider.isDone then
            GameTooltip:AddDoubleLine(rider.zone, self.checkMark)
        else
            GameTooltip:AddDoubleLine(rider.zone, " ")
        end
    end
    GameTooltip:Show()
end
