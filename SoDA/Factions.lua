function SoDA:GetFactions()
    local factions = {}

    local numFactions = GetNumFactions()
    for i=1, numFactions do
        local faction = {}
        faction.name, _, faction.standingId, faction.bottomValue, faction.topValue, faction.earnedValue, _, _, _, _, _, _, _, factionId, _, _ = GetFactionInfo(i)
        if factionId == 2587 then factions.phaseOne = faction end -- Durotar Supply and Logistics
        if factionId == 2586 then factions.phaseOne = faction end -- Azeroth Commerce Authority
        if factionId == 890 then factions.wsg = faction end -- Silverwing Sentinels
        if factionId == 889 then factions.wsg = faction end -- Warsong Outriders
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

    -- Phase one faction, ACA/DSL
    local phaseOneGroup = SoDA:FactionGui(phaseOne)
    group:AddChild(phaseOneGroup)

    return group
end

function SoDA:FactionGui(faction)
    local group = self.aceGui:Create("SimpleGroup")

    -- Faction name
    local factionLabel = self.aceGui:Create("Label")
    local standing = getglobal("FACTION_STANDING_LABEL" .. faction.standingId)
    local name = faction.name
    if string.len(faction.name) > 13 then
        name = string.sub(faction.name, 1, 13) .. "..."
    end
    factionLabel:SetText(name)
    group:AddChild(factionLabel)

    -- Faction standing
    local factionStanding = self.aceGui:Create("Label")
    factionStanding:SetText(standing .. " " .. faction.earnedValue - faction.bottomValue)
    group:AddChild(factionStanding)
    return group
end
