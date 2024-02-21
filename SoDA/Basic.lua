function SoDA:GetBasicInformation()
    local basic = {}
    basic.guid = UnitGUID("player")
    _, basic.class, _, basic.race, _, basic.name, _ = GetPlayerInfoByGUID(basic.guid)
    basic.level = UnitLevel("player")
    return basic
end

function SoDA:GetBasicGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    if character.basic == nil then
        return group
    end

    -- Character name
    local characterName = self.aceGui:Create("Label")
    characterName:SetText(character.basic.name)

    group:AddChild(characterName)
    return group
end
