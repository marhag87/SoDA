function SoDA:GetRaids()
    local raids = {}
    local numSavedInstances = GetNumSavedInstances()
    if numSavedInstances > 0 then
        for i=1, numSavedInstances do
            local name, lockoutId, reset, difficultyId, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress, extendDisabled, instanceId = GetSavedInstanceInfo(i)
            if instanceId == 90 then -- Gnomeregan
                local gnomeregan = {}
                gnomeregan.secondsLeft = reset -- This will not tick down, should set a time for when it will be reset
                gnomeregan.encounterProgress = encounterProgress
                gnomeregan.numEncounters = numEncounters
                gnomeregan.name = name
                raids.gnomeregan = gnomeregan
            end
        end
    end
    return raids    
end

function SoDA:GetRaidsGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    local gnomereganEncounterProgress = "?"
    local gnomereganNumEncounters = "6"
    local gnomereganName = "Gnomeregan"

    if character.raids ~= nil then
        if character.raids.gnomeregan ~= nil then
            gnomereganEncounterProgress = character.raids.gnomeregan.encounterProgress
            gnomereganNumEncounters = character.raids.gnomeregan.numEncounters
            gnomereganName = character.raids.gnomeregan.name
        end
    end

    -- Header
    local currencyHeader = self.aceGui:Create("Label")
    currencyHeader:SetText("Raids")
    group:AddChild(currencyHeader)

    -- Gnomeregan
    local gnomereganLock = self.aceGui:Create("Label")
    if gnomereganEncounterProgress == gnomereganNumEncounters then
        gnomereganLock:SetColor(0, 1, 0)
    end
    gnomereganLock:SetText(gnomereganName .. " " .. gnomereganEncounterProgress .. "/" .. gnomereganNumEncounters)
    group:AddChild(gnomereganLock)
    -- TODO: Add time until reset

    return group
end
