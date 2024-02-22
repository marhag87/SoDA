function SoDA:GetPvP()
    local pvp = {}

    -- Ashenvale weekly
    local ashenvaleWeeklyId = {["Alliance"] = 79090, ["Horde"] = 79098}
    local faction = self.db.global.characters[self.loggedInCharacter].basic.faction
    local questId = ashenvaleWeeklyId[faction]
    pvp.ashenvaleWeekly = C_QuestLog.IsQuestFlaggedCompleted(questId)
    pvp.ashenvaleWeeklyResetAt = time() + C_DateAndTime.GetSecondsUntilWeeklyReset()
    return pvp
end

function SoDA:GetPvPGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    local ashenvaleWeeklyDone = false
    local ashenvaleWeeklyResetAt = 0
    if character.pvp ~= nil then
        ashenvaleWeeklyDone = character.pvp.ashenvaleWeekly
        ashenvaleWeeklyResetAt = character.pvp.ashenvaleWeeklyResetAt
    end

    -- Header
    local pvpHeader = self.aceGui:Create("Label")
    pvpHeader:SetText("PvP")
    group:AddChild(pvpHeader)

    -- Ashenvale weekly
    local ashenvaleWeekly = self.aceGui:Create("Label")
    if ashenvaleWeeklyDone == true and time() < ashenvaleWeeklyResetAt then
        ashenvaleWeekly:SetColor(0, 1, 0)
    end
    ashenvaleWeekly:SetText("Ashenvale weekly")
    group:AddChild(ashenvaleWeekly)

    return group
end