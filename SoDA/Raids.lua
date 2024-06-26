function SoDA:GetRaids()
    local raids = {}
    local numSavedInstances = GetNumSavedInstances()
    if numSavedInstances > 0 then
        for i = 1, numSavedInstances do
            local name, _, reset, _, _, _, _, _, _, _, numEncounters, encounterProgress, _, instanceId =
                GetSavedInstanceInfo(i)
            local raid = {}
            raid.resetAt = time() + reset
            raid.encounterProgress = encounterProgress
            raid.numEncounters = numEncounters
            raid.name = name
            if instanceId == 48 then -- Blackfathom Deeps
                raids.bfd = raid
            end
            if instanceId == 90 then -- Gnomeregan
                raids.gnomeregan = raid
            end
            if instanceId == 109 then -- Sunken Temple
                raids.sunkenTemple = raid
            end
        end
    end
    return raids
end

function SoDA:GetRaidsGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings
    local raids = character.raids or {}

    -- Header
    group:AddChild(SoDA:Header(" "))
    group:SetWidth(self.defaultWidth)

    -- Blackfathom Deeps
    local bfd = raids.bfd or {
        ["encounterProgress"] = nil,
        ["numEncounters"] = 7,
        ["name"] = "Blackfathom Deeps",
        ["resetAt"] = 0,
    }
    local bfdLock = SoDA:RaidLock(bfd)
    bfdLock:SetWidth(self.defaultWidth)
    if bfd.resetAt > 0 then
        -- Blackfathom Deeps tooltip
        SoDA:Tooltip(bfdLock.frame, function()
            SoDA:RaidsTooltip(bfdLock.frame, bfd)
        end)
    end
    if s["Blackfathom Deeps"] == nil or s["Blackfathom Deeps"] then
        group:AddChild(bfdLock)
    end

    -- Gnomeregan
    local gnomeregan = raids.gnomeregan or {
        ["encounterProgress"] = nil,
        ["numEncounters"] = 6,
        ["name"] = "Gnomeregan",
        ["resetAt"] = 0,
    }
    local gnomereganLock = SoDA:RaidLock(gnomeregan)
    gnomereganLock:SetWidth(self.defaultWidth)
    if gnomeregan.resetAt > 0 then
        -- Gnomeregan tooltip
        SoDA:Tooltip(gnomereganLock.frame, function()
            SoDA:RaidsTooltip(gnomereganLock.frame, gnomeregan)
        end)
    end
    if s.Gnomeregan == nil or s.Gnomeregan then
        group:AddChild(gnomereganLock)
    end

    -- Sunken Temple
    local sunkenTemple = raids.sunkenTemple or {
        ["encounterProgress"] = nil,
        ["numEncounters"] = 8,
        ["name"] = "Sunken Temple",
        ["resetAt"] = 0,
    }
    local sunkenTempleLock = SoDA:RaidLock(sunkenTemple)
    sunkenTempleLock:SetWidth(self.defaultWidth)
    if sunkenTemple.resetAt > 0 then
        -- Sunken Temple tooltip
        SoDA:Tooltip(sunkenTempleLock.frame, function()
            SoDA:RaidsTooltip(sunkenTempleLock.frame, sunkenTemple)
        end)
    end
    if s["Sunken Temple"] == nil or s["Sunken Temple"] then
        group:AddChild(sunkenTempleLock)
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:RaidLock(raid)
    local raidLock = self.aceGui:Create("Label")
    if time() > raid.resetAt then
        raid.encounterProgress = nil
    end
    if raid.encounterProgress ~= nil and raid.encounterProgress > 0 then
        raidLock:SetColor(1, 1, 0.3)
    end
    if raid.encounterProgress == raid.numEncounters and time() < raid.resetAt then
        raidLock:SetColor(0, 1, 0)
    end
    raidLock:SetText(" ")
    if raid.encounterProgress ~= nil then
        raidLock:SetText(raid.encounterProgress .. "/" .. raid.numEncounters)
    end
    return raidLock
end

function SoDA:GetRaidsLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings

    -- Raids
    group:AddChild(SoDA:Header(self.L["Raids"]))

    -- BFD
    if s["Blackfathom Deeps"] == nil or s["Blackfathom Deeps"] then
        group:AddChild(SoDA:LegendLabel("Blackfathom Deeps"))
    end

    -- Gnomeregan
    if s.Gnomeregan == nil or s.Gnomeregan then
        group:AddChild(SoDA:LegendLabel("Gnomeregan"))
    end

    -- Sunken Temple
    if s["Sunken Temple"] == nil or s["Sunken Temple"] then
        group:AddChild(SoDA:LegendLabel("Sunken Temple"))
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:RaidsTooltip(frame, raid)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(raid.name)
    GameTooltip:AddLine(" ")
    local secondsLeft = raid.resetAt - time()
    local resetTime = string.format(SecondsToTime(secondsLeft))
    GameTooltip:AddLine("|cffffffff" .. self.L["Resets in"] .. " " .. resetTime .. FONT_COLOR_CODE_CLOSE)
    GameTooltip:Show()
end

function SoDA:RaidsEnabled()
    local s = self.db.global.settings
    local bfd = s["Blackfathom Deeps"]
    if bfd == nil then bfd = true end
    local gnomeregan = s.Gnomeregan
    if gnomeregan == nil then gnomeregan = true end
    local sunkenTemple = s["Sunken Temple"]
    if sunkenTemple == nil then sunkenTemple = true end
    return bfd or gnomeregan or sunkenTemple
end
