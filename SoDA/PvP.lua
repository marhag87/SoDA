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

    local pvp = character.pvp or {}
    local ashenvaleWeeklyDone = pvp.ashenvaleWeekly or false
    local ashenvaleWeeklyResetAt = pvp.ashenvaleWeeklyResetAt or 0

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

    -- WSG Rep
    local factions = character.factions or {}
    local wsg = factions.wsg or {
        ["name"] = "WSG",
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
        ["name"] = "AB",
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }
    local abGroup = SoDA:FactionGui(ab)
    group:AddChild(abGroup)

    return group
end
