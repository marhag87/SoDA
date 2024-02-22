function SoDA:GetBasicInformation()
    local basic = {}
    basic.guid = UnitGUID("player")
    _, basic.class, _, basic.race, _, basic.name, _ = GetPlayerInfoByGUID(basic.guid)
    basic.level = UnitLevel("player")
    basic.faction, basic.factionLocalized = UnitFactionGroup("player")
    return basic
end

function SoDA:GetBasicGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    if character.basic == nil then
        return group
    end

    -- Character name
    local characterName = self.aceGui:Create("Label")
    local r, g, b, _ = GetClassColor(character.basic.class)
    characterName:SetColor(r, g, b)
    characterName:SetText(character.basic.name)

    group:AddChild(characterName)
    return group
end
