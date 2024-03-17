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
    local s = self.db.global.settings

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
    if s.Realm == nil or s.Realm then group:AddChild(realmName) end

    -- Level
    local characterLevel = self.aceGui:Create("Label")
    characterLevel:SetWidth(self.defaultWidth)
    if character.basic.level == self.maxLevel then
        characterLevel:SetColor(0, 1, 0)
    end
    characterLevel:SetText(character.basic.level)
    if s.Level == nil or s.Level then group:AddChild(characterLevel) end

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
    if s.Mount == nil or s.Mount then group:AddChild(mountLabel) end

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
    if (auras.sleepingBagBuff and auras.sleepingBagBuff.count > 0) or (sleepingBagQuestDone and reset > GetTime()) then
        SoDA:Tooltip(sleepingBag.frame, function()
            SoDA:SleepingBagTooltip(sleepingBag.frame, sleepingBagQuestDone, auras.sleepingBagBuff, reset)
        end)
    end
    if s["Sleeping bag"] == nil or s["Sleeping bag"] then group:AddChild(sleepingBag) end

    -- Rested %
    local restedXPLabel = self.aceGui:Create("Label")
    restedXPLabel:SetWidth(self.defaultWidth)
    local percentRest = character.basic.percentRest or 0
    if percentRest == 150 then
        restedXPLabel:SetColor(0, 1, 0)
    end
    restedXPLabel:SetText(percentRest .. "%")
    if s.Rested == nil or s.Rested then group:AddChild(restedXPLabel) end

    return group
end

function SoDA:GetBasicLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- Character name, not shown
    group:AddChild(SoDA:Header(" "))

    local s = self.db.global.settings
    -- Realm
    if s.Realm == nil or s.Realm then
        group:AddChild(SoDA:LegendLabel(self.L["Realm"]))
    end

    -- Level
    if s.Level == nil or s.Level then
        group:AddChild(SoDA:LegendLabel(self.L["Level"]))
    end

    -- Mount
    if s.Mount == nil or s.Mount then
        group:AddChild(SoDA:LegendLabel(self.L["Mount"]))
    end

    -- Sleeping bag
    if s["Sleeping bag"] == nil or s["Sleeping bag"] then
        group:AddChild(SoDA:LegendLabel(self.L["Sleeping bag"]))
    end

    -- Rested
    if s.Rested == nil or s.Rested then
        group:AddChild(SoDA:LegendLabel(self.L["Rested"]))
    end

    return group
end

function SoDA:SleepingBagTooltip(frame, sleepingBagQuestDone, sleepingBagBuff, reset)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.L["Sleeping bag"])
    GameTooltip:AddLine(" ")
    local resetTime = reset - GetTime()
    local resetString = string.format(SecondsToTime(resetTime))
    if sleepingBagQuestDone and resetTime > 0 then
        GameTooltip:AddLine("|cffffffff" .. self.L["Cooldown remaining"] .. ": " .. resetString .. FONT_COLOR_CODE_CLOSE)
    end
    if sleepingBagBuff ~= nil and sleepingBagBuff.count ~= nil and sleepingBagBuff.count > 0 then
        local stacks = sleepingBagBuff.count or 0
        local duration = sleepingBagBuff.duration or 0
        local durationString = string.format(SecondsToTime(duration))
        GameTooltip:AddLine("|cffffffff" ..
            self.L["Buff"] .. ": " .. stacks .. "%, " .. durationString .. FONT_COLOR_CODE_CLOSE)
    end
    GameTooltip:Show()
end

function SoDA:BasicEnabled()
    local s = self.db.global.settings
    local realm = s.Realm
    if realm == nil then realm = true end
    local level = s.Level
    if level == nil then level = true end
    local mount = s.Mount
    if mount == nil then mount = true end
    local sleepingBag = s["Sleeping bag"]
    if sleepingBag == nil then sleepingBag = true end
    local rested = s.Rested
    if rested == nil then rested = true end
    return realm or level or mount or sleepingBag or rested
end
