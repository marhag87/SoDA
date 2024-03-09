function SoDA:GetBasicInformation()
    local basic = {}
    basic.guid = UnitGUID("player")
    _, basic.class, _, basic.race, _, basic.name, _ = GetPlayerInfoByGUID(basic.guid)
    basic.level = UnitLevel("player")
    basic.faction, basic.factionLocalized = UnitFactionGroup("player")
    basic.realm = GetRealmName()
    basic.sleepingBagQuestDone = C_QuestLog.IsQuestFlaggedCompleted(79976)

    -- Rested
    local restXP = GetXPExhaustion()
    local nextlevelXP = UnitXPMax("player")
    basic.percentRest = 0
    if restXP then
        basic.percentRest = math.floor(restXP / nextlevelXP * 100)
    end

    -- TODO: Mount

    return basic
end

function SoDA:GetBasicGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    if character.basic == nil then
        return group
    end

    -- Character name
    local characterName = self.aceGui:Create("Label")
    characterName:SetWidth(self.defaultWidth)
    local r, g, b, _ = GetClassColor(character.basic.class)
    characterName:SetColor(r, g, b)
    characterName:SetText(character.basic.name)
    characterName:SetFontObject(GameFontNormal)
    group:AddChild(characterName)

    -- Realm
    local realmName = self.aceGui:Create("Label")
    realmName:SetWidth(self.defaultWidth)
    realmName:SetText(character.basic.realm)
    group:AddChild(realmName)

    -- Level
    local characterLevel = self.aceGui:Create("Label")
    characterLevel:SetWidth(self.defaultWidth)
    if character.basic.level == self.maxLevel then
        characterLevel:SetColor(0, 1, 0)
    end
    characterLevel:SetText(character.basic.level)
    group:AddChild(characterLevel)

    -- Sleeping Bag
    local sleepingBag = self.aceGui:Create("Label")
    sleepingBag:SetWidth(self.defaultWidth)
    sleepingBag:SetText(" ")
    if character.basic.sleepingBagQuestDone then
        sleepingBag:SetText(self.checkMark)
    end
    group:AddChild(sleepingBag)

    -- Rested %
    local restedXPLabel = self.aceGui:Create("Label")
    restedXPLabel:SetWidth(self.defaultWidth)
    local percentRest = character.basic.percentRest or 0
    if percentRest == 150 then
        restedXPLabel:SetColor(0, 1, 0)
    end
    restedXPLabel:SetText(percentRest .. "%")
    group:AddChild(restedXPLabel)

    return group
end

function SoDA:GetBasicLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- Character name, not shown
    group:AddChild(SoDA:Header(" "))

    -- Realm
    group:AddChild(SoDA:LegendLabel("Realm"))

    -- Level
    group:AddChild(SoDA:LegendLabel("Level"))

    -- Sleeping bag
    group:AddChild(SoDA:LegendLabel("Sleeping bag"))

    -- Rested
    group:AddChild(SoDA:LegendLabel("Rested"))

    return group
end
