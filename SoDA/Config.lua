function SoDA:OpenConfig()
    InterfaceOptionsFrame_OpenToCategory("Season of Discovery Alts")
end

function SoDA:GetConfig()
    self.configFrame = CreateFrame("Frame")
    self.configFrame.name = "Season of Discovery Alts"
    self.configFrame:SetScript("OnShow", function()
        if not self.configShown then SoDA:ShowConfig() end
    end)
    return self.configFrame
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
