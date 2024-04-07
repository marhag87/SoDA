function SoDA:GetFactions()
    local factions = {}

    local numFactions = GetNumFactions()
    for i = 1, numFactions do
        local faction = {}
        faction.name, _, faction.standingId, faction.bottomValue, faction.topValue, faction.earnedValue, _, _, _, _, _, _, _, factionId, _, _ =
            GetFactionInfo(i)
        -- Phase one
        if factionId == 2587 then factions.phaseOne = faction end       -- Durotar Supply and Logistics
        if factionId == 2586 then factions.phaseOne = faction end       -- Azeroth Commerce Authority
        -- Phase 3
        if factionId == 2641 then factions.emeraldWardens = faction end -- Emerald Wardens
        -- Warsong Gulch
        if factionId == 890 then factions.wsg = faction end             -- Silverwing Sentinels
        if factionId == 889 then factions.wsg = faction end             -- Warsong Outriders
        -- Arathi Basin
        if factionId == 509 then factions.ab = faction end              -- The League of Arathor
        if factionId == 510 then factions.ab = faction end              -- The Defilers
        -- Alterac Valley
        if factionId == 730 then factions.av = faction end              -- Stormpike Guard
        if factionId == 729 then factions.av = faction end              -- Frostwolf Clan
    end

    -- Emerald Wardens daily
    factions.incursionDaily = C_QuestLog.IsQuestFlaggedCompleted(82068)
    factions.incursionDailyResetAt = time() + C_DateAndTime.GetSecondsUntilDailyReset()

    return factions
end

function SoDA:GetFactionsGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    local s = self.db.global.settings
    local factions = character.factions or {}
    local phaseOne = factions.phaseOne or {
        ["name"] = self.L["ACA/DSL"],
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- Phase one faction, ACA/DSL
    local phaseOneGroup = SoDA:FactionGui(phaseOne)
    if s["ACA/DSL"] == nil or s["ACA/DSL"] then
        group:AddChild(phaseOneGroup)
    end

    -- Phase 3, Emerald Wardens
    local emeraldWardens = factions.emeraldWardens or {
        ["name"] = self.L["Emerald Wardens"],
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }
    local emeraldWardensGroup = SoDA:FactionGui(emeraldWardens)
    if s["Emerald Wardens"] == nil or s["Emerald Wardens"] then
        group:AddChild(emeraldWardensGroup)
    end

    -- Emerald Wardens daily
    local incursionDailyDone = factions.incursionDaily or false
    local incursionDailyResetAt = factions.incursionDailyResetAt or 0
    local incursionDailyLabel = self.aceGui:Create("Label")
    incursionDailyLabel:SetWidth(self.defaultWidth)
    incursionDailyLabel:SetText(" ")
    if incursionDailyDone == true and time() < incursionDailyResetAt then
        incursionDailyLabel:SetText(self.checkMark)
        -- Incursion daily tooltip
        SoDA:Tooltip(incursionDailyLabel.frame, function()
            SoDA:IncursionDailyTooltip(incursionDailyLabel.frame, incursionDailyResetAt)
        end)
    end
    if s["Incursion daily"] == nil or s["Incursion daily"] then
        group:AddChild(incursionDailyLabel)
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:FactionGui(faction)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings

    -- Faction standing
    local standing = getglobal("FACTION_STANDING_LABEL" .. faction.standingId)
    local factionStanding = self.aceGui:Create("Label")
    factionStanding:SetWidth(self.defaultWidth)
    if faction.standingId >= 8 then
        factionStanding:SetText(standing)
        factionStanding:SetColor(0, 1, 0)
    else
        factionStanding:SetText(standing .. " " .. faction.earnedValue - faction.bottomValue)
    end
    group:AddChild(factionStanding)

    return group
end

function SoDA:GetFactionsLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings

    -- Factions
    group:AddChild(SoDA:Header(self.L["Factions"]))

    -- ACA/DSL
    if s["ACA/DSL"] == nil or s["ACA/DSL"] then
        group:AddChild(SoDA:LegendLabel(self.L["ACA/DSL"]))
    end

    -- Emerald Wardens
    if s["Emerald Wardens"] == nil or s["Emerald Wardens"] then
        group:AddChild(SoDA:LegendLabel(self.L["Emerald Wardens"]))
    end

    -- Emerald Wardens daily
    local incursionDailyLabel = SoDA:LegendLabel(self.L["Incursion daily"])
    -- Emerald Wardens daily tooltip
    if time() < self.dailyReset then
        SoDA:Tooltip(incursionDailyLabel.frame, function()
            SoDA:IncursionDailyTooltip(incursionDailyLabel.frame, self.dailyReset)
        end)
    end
    if s["Incursion daily"] == nil or s["Incursion daily"] then
        group:AddChild(incursionDailyLabel)
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:FactionsEnabled()
    local s = self.db.global.settings
    local acaDsl = s["ACA/DSL"]
    if acaDsl == nil then acaDsl = true end
    local emeraldWardens = s["Emerald Wardens"]
    if emeraldWardens == nil then emeraldWardens = true end
    local incursionDaily = s["Incursion daily"]
    if incursionDaily == nil then incursionDaily = true end
    return acaDsl or emeraldWardens or incursionDaily
end

function SoDA:IncursionDailyTooltip(frame, resetAt)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.L["Incursion daily"])
    GameTooltip:AddLine(" ")
    local secondsLeft = resetAt - time()
    local resetTime = string.format(SecondsToTime(secondsLeft))
    GameTooltip:AddLine("|cffffffff" .. self.L["Resets in"] .. " " .. resetTime .. FONT_COLOR_CODE_CLOSE)
    GameTooltip:Show()
end
