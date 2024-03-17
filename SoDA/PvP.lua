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

    local s = self.db.global.settings
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
    if s["Blood coins"] == nil or s["Blood coins"] then
        group:AddChild(bloodCoinsLabel)
    end

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
    if s["Ashenvale weekly"] == nil or s["Ashenvale weekly"] then
        group:AddChild(ashenvaleWeekly)
    end

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
    if s["Warsong Gulch"] == nil or s["Warsong Gulch"] then
        group:AddChild(wsgGroup)
    end

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
    if s["Arathi Basin"] == nil or s["Arathi Basin"] then
        group:AddChild(abGroup)
    end

    return group
end

function SoDA:GetPvPLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings

    -- PvP
    group:AddChild(SoDA:Header(self.L["PvP"]))

    -- Blood coins
    if s["Blood coins"] == nil or s["Blood coins"] then
        group:AddChild(SoDA:LegendLabel(self.L["Blood coins"]))
    end

    -- Ashenvale weekly
    local ashenvaleWeeklyLabel = SoDA:LegendLabel(self.L["Ashenvale weekly"])
    -- Ashenvale weekly tooltip
    if time() < self.weeklyReset then
        SoDA:Tooltip(ashenvaleWeeklyLabel.frame, function()
            SoDA:AshenvaleWeeklyTooltip(ashenvaleWeeklyLabel.frame, self.weeklyReset)
        end)
    end
    if s["Ashenvale weekly"] == nil or s["Ashenvale weekly"] then
        group:AddChild(ashenvaleWeeklyLabel)
    end

    -- WSG
    if s["Warsong Gulch"] == nil or s["Warsong Gulch"] then
        group:AddChild(SoDA:LegendLabel(self.L["Warsong Gulch"]))
    end

    -- AB
    if s["Arathi Basin"] == nil or s["Arathi Basin"] then
        group:AddChild(SoDA:LegendLabel(self.L["Arathi Basin"]))
    end

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

function SoDA:PvPEnabled()
    local s = self.db.global.settings
    local bloodCoins = s["Blood coins"]
    if bloodCoins == nil then bloodCoins = true end
    local ashenvaleWeekly = s["Ashenvale weekly"]
    if ashenvaleWeekly == nil then ashenvaleWeekly = true end
    local warsongGulch = s["Warsong Gulch"]
    if warsongGulch == nil then warsongGulch = true end
    local arathiBasin = s["Arathi Basin"]
    if arathiBasin == nil then arathiBasin = true end
    return bloodCoins or ashenvaleWeekly or warsongGulch or arathiBasin
end
