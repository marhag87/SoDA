function SoDA:GetBasicInformation()
    local basic = {}
    basic.guid = UnitGUID("player")
    _, basic.class, _, basic.race, _, basic.name, _ = GetPlayerInfoByGUID(basic.guid)
    basic.level = UnitLevel("player")
    basic.faction, basic.factionLocalized = UnitFactionGroup("player")
    basic.realm = GetRealmName()
    basic.sleepingBagQuestDone = C_QuestLog.IsQuestFlaggedCompleted(79976)
    local started, duration, _ = C_Container.GetItemCooldown(211527)
    basic.sleepingBagReset = started + duration

    -- Rested
    local restXP = GetXPExhaustion()
    local nextlevelXP = UnitXPMax("player")
    basic.percentRest = 0
    if restXP then
        basic.percentRest = math.floor(restXP / nextlevelXP * 100)
    end

    -- Mount
    basic.highestMount = 0
    for _, mount in ipairs(SoDA:GetMounts()) do
        if GetItemCount(mount.id, true) > 0 then
            if mount.speed > basic.highestMount then
                basic.highestMount = mount.speed
            end
        end
    end
    for _, mount in ipairs(SoDA:GetMountSpells()) do
        if IsSpellKnown(mount.id) then
            if mount.speed > basic.highestMount then
                basic.highestMount = mount.speed
            end
        end
    end

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
    local r, g, b, _ = SoDA:GetClassColor(character.basic.class)
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

    -- Mount
    local mountLabel = self.aceGui:Create("Label")
    mountLabel:SetWidth(self.defaultWidth)
    mountLabel:SetText(" ")
    if character.basic.highestMount and character.basic.highestMount > 0 then
        mountLabel:SetText(character.basic.highestMount .. "%")
        if character.basic.highestMount >= self.maxMountSpeed then
            mountLabel:SetColor(0, 1, 0)
        end
    end
    group:AddChild(mountLabel)

    -- Sleeping Bag
    local sleepingBag = self.aceGui:Create("Label")
    sleepingBag:SetWidth(self.defaultWidth)
    sleepingBag:SetText(" ")
    local sleepingBagQuestDone = character.basic.sleepingBagQuestDone or false
    if sleepingBagQuestDone then
        sleepingBag:SetText(self.checkMark)
    end
    -- Sleeping bag tooltip
    local auras = character.auras or {}
    local reset = character.basic.sleepingBagReset or 0
    if (auras.sleepingBagBuff and auras.sleepingBagBuff.count > 0) or sleepingBagQuestDone then
        SoDA:Tooltip(sleepingBag.frame, function()
            SoDA:SleepingBagTooltip(sleepingBag.frame, sleepingBagQuestDone, auras.sleepingBagBuff, reset)
        end)
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

    -- Mount
    group:AddChild(SoDA:LegendLabel("Mount"))

    -- Sleeping bag
    group:AddChild(SoDA:LegendLabel("Sleeping bag"))

    -- Rested
    group:AddChild(SoDA:LegendLabel("Rested"))

    return group
end

function SoDA:SleepingBagTooltip(frame, sleepingBagQuestDone, sleepingBagBuff, reset)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine("Sleeping bag")
    GameTooltip:AddLine(" ")
    local resetTime = reset - GetTime()
    local resetString = string.format(SecondsToTime(resetTime))
    if sleepingBagQuestDone and resetTime > 0 then
        GameTooltip:AddLine("|cffffffff" .. "Cooldown remaining: " .. resetString .. FONT_COLOR_CODE_CLOSE)
    end
    if sleepingBagBuff ~= nil and sleepingBagBuff.count ~= nil and sleepingBagBuff.count > 0 then
        local stacks = sleepingBagBuff.count or 0
        local duration = sleepingBagBuff.duration or 0
        local durationString = string.format(SecondsToTime(duration))
        GameTooltip:AddLine("|cffffffff" .. "Buff: " .. stacks .. "%, " .. durationString .. FONT_COLOR_CODE_CLOSE)
    end
    GameTooltip:Show()
end
