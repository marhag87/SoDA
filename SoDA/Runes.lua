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

    for _, runeCategory in pairs(self.runeCategories) do
        local known = C_Engraving.GetRunesForCategory(runeCategory.category, true)
        local all = C_Engraving.GetRunesForCategory(runeCategory.category, false)
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
    local s = self.db.global.settings

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
    SoDA:Tooltip(runesKnown.frame, function()
        SoDA:RunesTooltip(runesKnown.frame, runes)
    end)
    if s.Runes == nil or s.Runes then
        group:AddChild(runesKnown)
    end

    -- Dark Riders
    local darkRiderQuestsDone = runes.darkRiderQuestsDone or "?"
    local darkRider = self.aceGui:Create("Label")
    darkRider:SetWidth(self.defaultWidth)
    if darkRiderQuestsDone == 7 then
        darkRider:SetColor(0, 1, 0)
    end
    darkRider:SetText(darkRiderQuestsDone .. "/" .. 7)
    -- Dark Riders tooltip
    SoDA:Tooltip(darkRider.frame, function()
        SoDA:DarkRidersTooltip(darkRider.frame, runes)
    end)
    if s["Dark Riders"] == nil or s["Dark Riders"] then
        group:AddChild(darkRider)
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:GetRunesLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings

    -- Runes
    group:AddChild(SoDA:Header(self.L["Runes"]))

    -- Runes
    if s.Runes == nil or s.Runes then
        group:AddChild(SoDA:LegendLabel(self.L["Runes"]))
    end

    -- Dark Riders
    if s["Dark Riders"] == nil or s["Dark Riders"] then
        group:AddChild(SoDA:LegendLabel(self.L["Dark Riders"]))
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:RunesTooltip(frame, runes)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.L["Runes"])
    if runes.known == nil then
        GameTooltip:AddLine(self.L["No rune data"])
    else
        local known = runes.known or {}
        local unknown = runes.unknown or {}
        for _, runeCategory in pairs(self.runeCategories) do
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cffffffff" .. self.L[runeCategory.name] .. FONT_COLOR_CODE_CLOSE)
            for _, rune in ipairs(known) do
                if rune.equipmentSlot == runeCategory.category then
                    GameTooltip:AddDoubleLine(rune.name, self.checkMark)
                end
            end
            for _, rune in ipairs(unknown) do
                if rune.equipmentSlot == runeCategory.category then
                    GameTooltip:AddDoubleLine(rune.name, " ")
                end
            end
        end
    end
    GameTooltip:Show()
end

function SoDA:DarkRidersTooltip(frame, runes)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.L["Dark Riders"])
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

function SoDA:RunesEnabled()
    local s = self.db.global.settings
    local runes = s.Runes
    if runes == nil then runes = true end
    local darkRiders = s["Dark Riders"]
    if darkRiders == nil then darkRiders = true end
    return runes or darkRiders
end
