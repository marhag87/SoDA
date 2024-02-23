function SoDA:GetBasicInformation()
    local basic = {}
    basic.guid = UnitGUID("player")
    _, basic.class, _, basic.race, _, basic.name, _ = GetPlayerInfoByGUID(basic.guid)
    basic.level = UnitLevel("player")
    basic.faction, basic.factionLocalized = UnitFactionGroup("player")
    basic.realm = GetRealmName()
    basic.sleepingBagQuestDone = C_QuestLog.IsQuestFlaggedCompleted(79976)

    -- TODO: Rested %
    -- TODO: Mount

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

    -- Realm
    local realmName = self.aceGui:Create("Label")
    realmName:SetText(character.basic.realm)
    group:AddChild(realmName)

    -- Level
    local characterLevel = self.aceGui:Create("Label")
    if character.basic.level == self.maxLevel then
        characterLevel:SetColor(0, 1, 0)
    end
    characterLevel:SetText(character.basic.level)
    group:AddChild(characterLevel)

    -- Sleeping Bag
    local sleepingBag = self.aceGui:Create("Label")
    name, _ = GetItemInfo(211527)
    if string.len(name) > 17 then
        name = string.sub(name, 1, 17) .. "..."
    end
    sleepingBag:SetText(name)
    if character.basic.sleepingBagQuestDone then
        sleepingBag:SetColor(0, 1, 0)
    end
    group:AddChild(sleepingBag)

    return group
end
