function SoDA:GetPvP()
    local pvp = {}

    -- Ashenvale daily
    local ashenvaleDailyId = { ["Alliance"] = 79090, ["Horde"] = 79098 }
    local faction, _ = UnitFactionGroup("player")
    local questId = ashenvaleDailyId[faction]
    pvp.ashenvaleDaily = C_QuestLog.IsQuestFlaggedCompleted(questId)
    pvp.ashenvaleDailyResetAt = time() + C_DateAndTime.GetSecondsUntilDailyReset()

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
    local ashenvaleDailyDone = pvp.ashenvaleDaily or false
    local ashenvaleDailyResetAt = pvp.ashenvaleDailyResetAt or 0

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

    -- Ashenvale daily
    local ashenvaleDaily = self.aceGui:Create("Label")
    ashenvaleDaily:SetWidth(self.defaultWidth)
    ashenvaleDaily:SetText(" ")
    if ashenvaleDailyDone == true and time() < ashenvaleDailyResetAt then
        ashenvaleDaily:SetText(self.checkMark)
        -- Ashenvale daily tooltip
        SoDA:Tooltip(ashenvaleDaily.frame, function()
            SoDA:AshenvaleDailyTooltip(ashenvaleDaily.frame, ashenvaleDailyResetAt)
        end)
    end
    if s["Ashenvale daily"] == nil or s["Ashenvale daily"] then
        group:AddChild(ashenvaleDaily)
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

    -- Spacer
    group:AddChild(SoDA:Spacer())

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

    -- Ashenvale daily
    local ashenvaleDailyLabel = SoDA:LegendLabel(self.L["Ashenvale daily"])
    -- Ashenvale daily tooltip
    if time() < self.dailyReset then
        SoDA:Tooltip(ashenvaleDailyLabel.frame, function()
            SoDA:AshenvaleDailyTooltip(ashenvaleDailyLabel.frame, self.dailyReset)
        end)
    end
    if s["Ashenvale daily"] == nil or s["Ashenvale daily"] then
        group:AddChild(ashenvaleDailyLabel)
    end

    -- WSG
    if s["Warsong Gulch"] == nil or s["Warsong Gulch"] then
        group:AddChild(SoDA:LegendLabel(self.L["Warsong Gulch"]))
    end

    -- AB
    if s["Arathi Basin"] == nil or s["Arathi Basin"] then
        group:AddChild(SoDA:LegendLabel(self.L["Arathi Basin"]))
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:AshenvaleDailyTooltip(frame, resetAt)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.L["Ashenvale daily"])
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
    local ashenvaleDaily = s["Ashenvale daily"]
    if ashenvaleDaily == nil then ashenvaleDaily = true end
    local warsongGulch = s["Warsong Gulch"]
    if warsongGulch == nil then warsongGulch = true end
    local arathiBasin = s["Arathi Basin"]
    if arathiBasin == nil then arathiBasin = true end
    return bloodCoins or ashenvaleDaily or warsongGulch or arathiBasin
end
