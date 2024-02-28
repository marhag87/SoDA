function SoDA:GetProfessions()
    local professionSkills = {
        ["Alchemy"] = {2259, 3101, 3464, 11611},
        ["Blacksmithing"] = {2018, 3100, 3538, 9785},

        ["Herbalism"] = {2383},
    }
    local professions = {}
    local firstFound = false
    for prof, spells in pairs(professionSkills) do
        for _, id in pairs(spells) do
            if IsSpellKnown(id) then
                if firstFound then
                    professions.second = {["name"] = prof}
                else
                    professions.first = {["name"] = prof}
                    firstFound = true
                end
            end
        end
    end

    return professions    
end

function SoDA:GetProfessionsGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    local professions = character.professions or {}

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- First
    local first = professions.first or {}
    group:AddChild(SoDA:LegendLabel(first.name or " "))

    -- Second
    local second = professions.second or {}
    group:AddChild(SoDA:LegendLabel(second.name or " "))

    group:AddChild(SoDA:LegendLabel(" "))
    group:AddChild(SoDA:LegendLabel(" "))
    group:AddChild(SoDA:LegendLabel(" "))

    return group
end

function SoDA:GetProfessionsLegend()
    local group = self.aceGui:Create("SimpleGroup")

    -- Raids
    group:AddChild(SoDA:Header("Professions"))

    -- First
    group:AddChild(SoDA:LegendLabel("First"))

    -- Second
    group:AddChild(SoDA:LegendLabel("Second"))

    -- First aid
    group:AddChild(SoDA:LegendLabel("First aid"))

    -- Cooking
    group:AddChild(SoDA:LegendLabel("Cooking"))

    -- Fishing
    group:AddChild(SoDA:LegendLabel("Fishing"))

    return group
end
