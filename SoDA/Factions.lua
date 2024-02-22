function SoDA:GetFactions()
    local factions = {}

    local numFactions = GetNumFactions()
    for i=1, numFactions do
        local faction = {}
        faction.name, _, faction.standingId, faction.bottomValue, faction.topValue, faction.earnedValue, _, _, _, _, _, _, _, factionId, _, _ = GetFactionInfo(i)
        if factionId == 2587 then factions.phaseOne = faction end -- Durotar Supply and Logistics
        if factionId == 2586 then factions.phaseOne = faction end -- Azeroth Commerce Authority
    end
    return factions
end

function SoDA:GetFactionsGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    local factions = character.factions or {}
    local phaseOne = factions.phaseOne or {
        ["name"] = "ACA/DSL",
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }

    -- Header
    local factionsHeader = self.aceGui:Create("Label")
    factionsHeader:SetText("Factions")
    group:AddChild(factionsHeader)

    -- ACA/DSL name
    local phaseOneLabel = self.aceGui:Create("Label")
    local standing = getglobal("FACTION_STANDING_LABEL"..phaseOne.standingId)
    local name = phaseOne.name
    if string.len(phaseOne.name) > 13 then
        name = string.sub(phaseOne.name, 1, 13) .. "..."
    end
    phaseOneLabel:SetText(name)
    group:AddChild(phaseOneLabel)

    -- ACA/DSL standing
    local phaseOneStanding = self.aceGui:Create("Label")
    phaseOneStanding:SetText(standing .. " " .. phaseOne.earnedValue)
    group:AddChild(phaseOneStanding)

    return group
end
