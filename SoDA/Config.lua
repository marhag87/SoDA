function SoDA:OpenConfig()
    InterfaceOptionsFrame_OpenToCategory("Season of Discovery Alts")
end

function SoDA:SetupConfig()
    if self.db.global.settings == nil then self.db.global.settings = {} end
    InterfaceOptions_AddCategory(SoDA:GetMainConfig())
    InterfaceOptions_AddCategory(SoDA:GetSectionConfig())
end

function SoDA:GetMainConfig()
    self.configFrame = CreateFrame("Frame")
    self.configFrame.name = "Season of Discovery Alts"
    self.configFrame:SetScript("OnShow", function()
        if not self.configShown then SoDA:ShowConfig() end
    end)
    return self.configFrame
end

function SoDA:GetSectionConfig()
    self.sectionConfigFrame = CreateFrame("Frame")
    self.sectionConfigFrame.name = "Sections"
    self.sectionConfigFrame.parent = self.configFrame.name;

    -- Title
    local title = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(self.L["Show sections"])

    -- Basic
    local basicLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    basicLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    basicLabel:SetText(self.L["Basic"])
    -- Realm
    local realmFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, basicLabel, "Realm", 0)
    -- Level
    local levelFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, realmFrame, "Level")
    -- Mount
    local mountFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, levelFrame, "Mount")
    -- Sleeping bag
    local sleepingBagFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, mountFrame, "Sleeping bag")
    -- Rested
    local restedFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, sleepingBagFrame, "Rested")
    -- Dual spec
    local dualSpecFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, restedFrame, "Dual spec")

    -- Currency
    local currencyLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    currencyLabel:SetPoint("TOPLEFT", dualSpecFrame, "BOTTOMLEFT", 0, -8)
    currencyLabel:SetText(self.L["Currency"])
    -- Gold
    local goldFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, currencyLabel, "Gold", 0)
    -- Wild Offering
    local wildOfferingFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, goldFrame, "Wild Offering")
    -- Emerald Chip
    local emeraldChipFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, wildOfferingFrame, "Emerald Chip")

    -- Runes
    local runesLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    runesLabel:SetPoint("TOPLEFT", emeraldChipFrame, "BOTTOMLEFT", 0, -8)
    runesLabel:SetText(self.L["Runes"])
    -- Runes
    local runesFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, runesLabel, "Runes", 0)
    -- Grizzby
    local grizzbyFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, runesFrame, "Grizzby")
    -- Dark Riders
    local darkRidersFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, grizzbyFrame, "Dark Riders")

    -- Books
    local booksLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    booksLabel:SetPoint("TOPLEFT", darkRidersFrame, "BOTTOMLEFT", 0, -8)
    booksLabel:SetText(self.L["Books"])
    -- Phase 2
    local phaseTwoFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, booksLabel, "Phase 2", 0)

    -- Raids
    local raidsLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    raidsLabel:SetPoint("TOPLEFT", phaseTwoFrame, "BOTTOMLEFT", 0, -8)
    raidsLabel:SetText(self.L["Raids"])
    -- Blackfathom Deeps
    local bfdFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, raidsLabel, "Blackfathom Deeps", 0)
    -- Gnomeregan
    local gnomereganFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, bfdFrame, "Gnomeregan")
    -- Sunken Temple
    local sunkenTempleFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, gnomereganFrame, "Sunken Temple")

    -- PvP
    local pvpLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    pvpLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 300, -8)
    pvpLabel:SetText(self.L["PvP"])
    -- Rank
    local rankFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, pvpLabel, "Rank", 0)
    -- Blood coins
    local bloodCoinsFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, rankFrame, "Blood coins")
    -- Massacre coins
    local massacreCoinsFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, bloodCoinsFrame, "Massacre coins")
    -- Ashenvale daily
    local ashenvaleDailyFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, massacreCoinsFrame, "Ashenvale daily")
    -- Warsong Gulch
    local warsongGulchFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, ashenvaleDailyFrame, "Warsong Gulch")
    -- Arathi Basin
    local arathiBasinFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, warsongGulchFrame, "Arathi Basin")

    -- Factions
    local factionsLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    factionsLabel:SetPoint("TOPLEFT", arathiBasinFrame, "BOTTOMLEFT", 0, -8)
    factionsLabel:SetText(self.L["Factions"])
    -- ACA/DSL
    local acaDslFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, factionsLabel, "ACA/DSL", 0)
    -- Emerald Wardens
    local emeraldWardensFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, acaDslFrame, "Emerald Wardens")
    -- Emerald Wardens daily
    local incursionDailyFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, emeraldWardensFrame, "Incursion daily")

    -- Professions
    local professionsLabel = self.sectionConfigFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    professionsLabel:SetPoint("TOPLEFT", incursionDailyFrame, "BOTTOMLEFT", 0, -8)
    professionsLabel:SetText(self.L["Professions"])
    -- First primary
    local firstPrimaryFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, professionsLabel, "First primary", 0)
    -- Second primary
    local secondPrimaryFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, firstPrimaryFrame, "Second primary")
    -- Cooking
    local cookingFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, secondPrimaryFrame, "Cooking")
    -- First Aid
    local firstAidFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, cookingFrame, "First Aid")
    -- Fishing
    local fishingFrame = SoDA:SectionCheckbox(self.sectionConfigFrame, firstAidFrame, "Fishing")

    return self.sectionConfigFrame
end

function SoDA:ShowConfig()
    local configFrame = self.configFrame

    -- Title
    local title = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Season of Discovery Alts")

    -- Which characters to show
    local showCharacterLabel = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    showCharacterLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    showCharacterLabel:SetText(self.L["Show characters"] .. ":")

    -- Characters
    local characters = self.db.global.characters
    local characterNumber = 0
    for guid, character in SoDA:spairs(characters, function(t, a, b) return t[b].basic.level < t[a].basic.level end) do
        local text = character.basic.name .. "-" .. character.basic.realm
        local characterToggle = SoDA:Checkbox(configFrame, text,
            function(_, value) self.db.global.characters[guid].disabled = not value end)
        local disabled = self.db.global.characters[guid].disabled
        if disabled == nil then disabled = false end
        characterToggle:SetChecked(not disabled)
        characterToggle:SetPoint("TOPLEFT", showCharacterLabel, "BOTTOMLEFT", 0, (-20 * characterNumber) - 2)
        characterNumber = characterNumber + 1
    end

    self.configShown = true
end

function SoDA:Checkbox(frame, label, onClick)
    local check = CreateFrame("CheckButton", "SoDACheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
    check:SetScript("OnClick", function(self)
        local tick = self:GetChecked()
        onClick(self, tick and true or false)
    end)
    check.label = _G[check:GetName() .. "Text"]
    check.label:SetText(label)
    return check
end

function SoDA:SectionCheckbox(frame, parent, section, offset)
    local sectionToggle = SoDA:Checkbox(frame, self.L[section],
        function(_, value) self.db.global.settings[section] = value end)
    local enabled = self.db.global.settings[section]
    if enabled == nil then enabled = true end
    sectionToggle:SetChecked(enabled)
    sectionToggle:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, offset or 7)
    return sectionToggle
end
