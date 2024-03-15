function SoDA:GetFactions()
    local factions = {}

    local numFactions = GetNumFactions()
    for i = 1, numFactions do
        local faction = {}
        faction.name, _, faction.standingId, faction.bottomValue, faction.topValue, faction.earnedValue, _, _, _, _, _, _, _, factionId, _, _ =
            GetFactionInfo(i)
        -- Phase one
        if factionId == 2587 then factions.phaseOne = faction end -- Durotar Supply and Logistics
        if factionId == 2586 then factions.phaseOne = faction end -- Azeroth Commerce Authority
        -- Warsong Gulch
        if factionId == 890 then factions.wsg = faction end       -- Silverwing Sentinels
        if factionId == 889 then factions.wsg = faction end       -- Warsong Outriders
        -- Arathi Basin
        if factionId == 509 then factions.ab = faction end        -- The League of Arathor
        if factionId == 510 then factions.ab = faction end        -- The Defilers
        -- Alterac Valley
        if factionId == 730 then factions.av = faction end        -- Stormpike Guard
        if factionId == 729 then factions.av = faction end        -- Frostwolf Clan
    end
    return factions
end

function SoDA:GetFactionsGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    local factions = character.factions or {}
    local phaseOne = factions.phaseOne or {
        ["name"] = self.L["ACA/DSL"],
        ["standingId"] = 4,
        ["earnedValue"] = 0,
        ["bottomValue"] = 0,
        ["topValue"] = 3000,
    }

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- Phase one faction, ACA/DSL
    local phaseOneGroup = SoDA:FactionGui(phaseOne)
    group:AddChild(phaseOneGroup)

    return group
end

function SoDA:FactionGui(faction)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- Faction standing
    local standing = getglobal("FACTION_STANDING_LABEL" .. faction.standingId)
    local factionStanding = self.aceGui:Create("Label")
    factionStanding:SetWidth(self.defaultWidth)
    factionStanding:SetText(standing .. " " .. faction.earnedValue - faction.bottomValue)
    group:AddChild(factionStanding)

    return group
end

function SoDA:GetFactionsLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- Factions
    group:AddChild(SoDA:Header(self.L["Factions"]))

    -- ACA/DSL
    group:AddChild(SoDA:LegendLabel(self.L["ACA/DSL"]))

    return group
end
