function SoDA:GetFactions()
    local factions = {}

    local numFactions = GetNumFactions()
    for i=1, numFactions do
        name, _, standingId, bottomValue, topValue, earnedValue, _, _, _, _, _, _, _, factionId, _, _ = GetFactionInfo(i)
        -- Durotar Supply and Logistics
        if factionId == 2587 then
            factions.dsl = {}
            factions.dsl.name = name
            factions.dsl.standingId = standingId
            factions.dsl.bottomValue = bottomValue
            factions.dsl.topValue = topValue
            factions.dsl.earnedValue = earnedValue
        end
        -- Azeroth Commerce Authority
        if factionId == 2586 then
            factions.aca = {}
            factions.aca.name = name
            factions.aca.standingId = standingId
            factions.aca.bottomValue = bottomValue
            factions.aca.topValue = topValue
            factions.aca.earnedValue = earnedValue
        end
    end
    return factions
end

function SoDA:GetFactionsGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    local phaseOne = {
        ["name"] = "ACA/DSL",
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }

    local name = "ACA"
    if character.factions ~= nil then
        if character.factions.aca ~= nil then
            phaseOne = character.factions.aca
        end
        if character.factions.dsl ~= nil then
            phaseOne = character.factions.dsl
            name = "DSL"
        end
    end

    -- Header
    local factionsHeader = self.aceGui:Create("Label")
    factionsHeader:SetText("Factions")
    group:AddChild(factionsHeader)

    -- ACA
    local acaLabel = self.aceGui:Create("Label")
    local standing = getglobal("FACTION_STANDING_LABEL"..phaseOne.standingId)
    acaLabel:SetText(name .. ": " .. standing .. " " .. phaseOne.earnedValue)
    group:AddChild(acaLabel)

    return group
end
