function SoDA:GetPvP()
    local pvp = {}

    -- Rank
    local rank = UnitPVPRank("player")
    if rank > 0 then
        pvp.honor = {}
        pvp.honor.rankName, pvp.honor.rankNumber = GetPVPRankInfo(rank)
        pvp.honor.progress = GetPVPRankProgress()
    end

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

    -- Massacre coins
    local massacreCoins = {}
    massacreCoins.copper = GetItemCount(221364, true)
    massacreCoins.silver = GetItemCount(221365, true)
    massacreCoins.gold = GetItemCount(221366, true)
    pvp.massacreCoins = massacreCoins

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

    -- Rank
    local honor = pvp.honor or {}
    local honorLabel = self.aceGui:Create("Label")
    honorLabel:SetWidth(self.defaultWidth)
    honorLabel:SetText(" ")
    if honor.rankNumber ~= nil and honor.rankNumber > 0 then
        if honor.rankNumber >= self.maxHonorRank then
            honorLabel:SetText("|cff00ff00" .. honor.rankNumber .. FONT_COLOR_CODE_CLOSE)
        else
            honorLabel:SetText(honor.rankNumber .. ", " .. honor.progress .. "%")
        end
    end
    if s.Rank == nil or s.Rank then
        group:AddChild(honorLabel)
    end

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

    -- Massacre coins
    local massacreCoins = pvp.massacreCoins or {}
    local copper = massacreCoins.copper or 0
    local silver = massacreCoins.silver or 0
    local gold = massacreCoins.gold or 0
    local coinsString = GetMoneyString(copper + (silver * 100) + (gold * 100 * 100))
    local massacreCoinsLabel = self.aceGui:Create("Label")
    massacreCoinsLabel:SetWidth(self.defaultWidth)
    massacreCoinsLabel:SetText(coinsString)
    if s["Massacre coins"] == nil or s["Massacre coins"] then
        group:AddChild(massacreCoinsLabel)
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

    -- Rank
    if s.Rank == nil or s.Rank then
        group:AddChild(SoDA:LegendLabel(self.L["Rank"]))
    end

    -- Blood coins
    if s["Blood coins"] == nil or s["Blood coins"] then
        group:AddChild(SoDA:LegendLabel(self.L["Blood coins"]))
    end

    -- Massacre coins
    if s["Massacre coins"] == nil or s["Massacre coins"] then
        group:AddChild(SoDA:LegendLabel(self.L["Massacre coins"]))
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
    local rank = s.Rank
    if rank == nil then rank = true end
    local bloodCoins = s["Blood coins"]
    if bloodCoins == nil then bloodCoins = true end
    local massacreCoins = s["Massacre coins"]
    if massacreCoins == nil then massacreCoins = true end
    local ashenvaleDaily = s["Ashenvale daily"]
    if ashenvaleDaily == nil then ashenvaleDaily = true end
    local warsongGulch = s["Warsong Gulch"]
    if warsongGulch == nil then warsongGulch = true end
    local arathiBasin = s["Arathi Basin"]
    if arathiBasin == nil then arathiBasin = true end
    return rank or bloodCoins or massacreCoins or ashenvaleDaily or warsongGulch or arathiBasin
end
