function SoDA:GetRaids()
    local raids = {}
    local numSavedInstances = GetNumSavedInstances()
    if numSavedInstances > 0 then
        for i=1, numSavedInstances do
            local name, lockoutId, reset, difficultyId, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress, extendDisabled, instanceId = GetSavedInstanceInfo(i)
            if instanceId == 90 then -- Gnomeregan
                local gnomeregan = {}
                gnomeregan.resetAt = time() + reset
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

    local gnomeregan = {
        ["encounterProgress"] = "?",
        ["numEncounters"] = 6,
        ["name"] = "Gnomeregan",
        ["resetAt"] = 0,
    }

    if character.raids ~= nil then
        if character.raids.gnomeregan ~= nil then
            gnomeregan = character.raids.gnomeregan
            if time() > gnomeregan.resetAt then
                gnomeregan.encounterProgress = "?"
            end
        end
    end

    -- Header
    local currencyHeader = self.aceGui:Create("Label")
    currencyHeader:SetText("Raids")
    group:AddChild(currencyHeader)

    -- Gnomeregan
    local gnomereganLock = self.aceGui:Create("Label")
    if gnomeregan.encounterProgress == gnomeregan.numEncounters and time() < gnomeregan.resetAt then
        gnomereganLock:SetColor(0, 1, 0)
    end
    if gnomeregan.encounterProgress == "?" then
        gnomereganLock:SetText(gnomeregan.name)
    else
        gnomereganLock:SetText(gnomeregan.name .. " " .. gnomeregan.encounterProgress .. "/" .. gnomeregan.numEncounters)
    end
    group:AddChild(gnomereganLock)

    return group
end
