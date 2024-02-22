function SoDA:GetRaids()
    local raids = {}
    local numSavedInstances = GetNumSavedInstances()
    if numSavedInstances > 0 then
        for i=1, numSavedInstances do
            local name, lockoutId, reset, difficultyId, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress, extendDisabled, instanceId = GetSavedInstanceInfo(i)
            if instanceId == 48 then -- Blackfathom Deeps
                local bfd = {}
                bfd.resetAt = time() + reset
                bfd.encounterProgress = encounterProgress
                bfd.numEncounters = numEncounters
                bfd.name = name
                raids.bfd = bfd
            end
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

    local bfd = {
        ["encounterProgress"] = "?",
        ["numEncounters"] = 7,
        ["name"] = "Blackfathom Deeps",
        ["resetAt"] = 0,
    }
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
        if character.raids.bfd ~= nil then
            bfd = character.raids.bfd
            if time() > bfd.resetAt then
                bfd.encounterProgress = "?"
            end
        end
    end

    -- Header
    local currencyHeader = self.aceGui:Create("Label")
    currencyHeader:SetText("Raids")
    group:AddChild(currencyHeader)

    -- Blackfathom Deeps
    local bfdLock = self.aceGui:Create("Label")
    if bfd.encounterProgress == bfd.numEncounters and time() < bfd.resetAt then
        bfdLock:SetColor(0, 1, 0)
    end
    if bfd.encounterProgress == "?" then
        bfdLock:SetText(bfd.name)
    else
        bfdLock:SetText(bfd.name .. " " .. bfd.encounterProgress .. "/" .. bfd.numEncounters)
    end
    group:AddChild(bfdLock)

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
