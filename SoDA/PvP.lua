function SoDA:GetPvP()
    local pvp = {}

    -- Ashenvale weekly
    local ashenvaleWeeklyId = { ["Alliance"] = 79090, ["Horde"] = 79098 }
    local faction, _ = UnitFactionGroup("player")
    local questId = ashenvaleWeeklyId[faction]
    pvp.ashenvaleWeekly = C_QuestLog.IsQuestFlaggedCompleted(questId)
    pvp.ashenvaleWeeklyResetAt = time() + C_DateAndTime.GetSecondsUntilWeeklyReset()

    -- Blood Moon coins
    local bloodCoins = {}
    bloodCoins.copper = GetItemCount(213168, true)
    bloodCoins.silver = GetItemCount(213169, true)
    bloodCoins.gold = GetItemCount(213170, true)
    pvp.bloodCoins = bloodCoins

    return pvp
end

function SoDA:GetPvPGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    local pvp = character.pvp or {}
    local ashenvaleWeeklyDone = pvp.ashenvaleWeekly or false
    local ashenvaleWeeklyResetAt = pvp.ashenvaleWeeklyResetAt or 0

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- Blood coins
    local bloodCoins = pvp.bloodCoins or {}
    local copper = bloodCoins.copper or 0
    local silver = bloodCoins.silver or 0
    local gold = bloodCoins.gold or 0
    local coinsString = GetMoneyString(copper + (silver * 100) + (gold * 100 * 100))
    local bloodCoinsLabel = self.aceGui:Create("Label")
    bloodCoinsLabel:SetWidth(self.defaultWidth)
    bloodCoinsLabel:SetText(coinsString)
    group:AddChild(bloodCoinsLabel)

    -- Ashenvale weekly
    local ashenvaleWeekly = self.aceGui:Create("Label")
    ashenvaleWeekly:SetWidth(self.defaultWidth)
    ashenvaleWeekly:SetText(" ")
    if ashenvaleWeeklyDone == true and time() < ashenvaleWeeklyResetAt then
        ashenvaleWeekly:SetText(self.checkMark)
        -- Ashenvale weekly tooltip
        SoDA:Tooltip(ashenvaleWeekly.frame, function()
            SoDA:AshenvaleWeeklyTooltip(ashenvaleWeekly.frame, ashenvaleWeeklyResetAt)
        end)
    end
    group:AddChild(ashenvaleWeekly)

    -- WSG Rep
    local factions = character.factions or {}
    local wsg = factions.wsg or {
        ["name"] = self.L["Warsong Gulch"],
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }
    local wsgGroup = SoDA:FactionGui(wsg)
    group:AddChild(wsgGroup)

    -- AB Rep
    local factions = character.factions or {}
    local ab = factions.ab or {
        ["name"] = self.L["Arathi Basin"],
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }
    local abGroup = SoDA:FactionGui(ab)
    group:AddChild(abGroup)

    return group
end

function SoDA:GetPvPLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- PvP
    group:AddChild(SoDA:Header(self.L["PvP"]))

    -- Blood coins
    group:AddChild(SoDA:LegendLabel(self.L["Blood coins"]))

    -- Ashenvale weekly
    local ashenvaleWeeklyLabel = SoDA:LegendLabel(self.L["Ashenvale weekly"])
    -- Ashenvale weekly tooltip
    if time() < self.weeklyReset then
        SoDA:Tooltip(ashenvaleWeeklyLabel.frame, function()
            SoDA:AshenvaleWeeklyTooltip(ashenvaleWeeklyLabel.frame, self.weeklyReset)
        end)
    end
    group:AddChild(ashenvaleWeeklyLabel)

    -- WSG
    group:AddChild(SoDA:LegendLabel(self.L["Warsong Gulch"]))

    -- AB
    group:AddChild(SoDA:LegendLabel(self.L["Arathi Basin"]))

    return group
end

function SoDA:AshenvaleWeeklyTooltip(frame, resetAt)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.L["Ashenvale weekly"])
    GameTooltip:AddLine(" ")
    local secondsLeft = resetAt - time()
    local resetTime = string.format(SecondsToTime(secondsLeft))
    GameTooltip:AddLine("|cffffffff" .. self.L["Resets in"] .. " " .. resetTime .. FONT_COLOR_CODE_CLOSE)
    GameTooltip:Show()
end
