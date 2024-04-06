function SoDA:Gui()
    local f = self.aceGui:Create("Frame")
    f:SetCallback("OnClose", function(widget) self.aceGui:Release(widget) end)
    f:SetTitle("Season of Discovery Alts")
    f:SetLayout("Flow")

    local numChararcters = 0
    for _, character in pairs(self.db.global.characters) do
        if not character.disabled then
            numChararcters = numChararcters + 1
        end
    end
    local width = (numChararcters * self.defaultWidth) + 160
    if width < 250 then
        width = 250
    end
    f:SetWidth(width)
    f:SetHeight(550)

    f:AddChild(SoDA:Legend())

    local s = self.db.global.settings

    local characters = self.db.global.characters
    for guid, character in SoDA:spairs(characters, function(t, a, b) return t[b].basic.level < t[a].basic.level end) do
        if not character.disabled then
            local group = self.aceGui:Create("SimpleGroup")
            group:SetWidth(self.defaultWidth)

            -- Basic
            local basic = SoDA:GetBasicGui(character)
            group:AddChild(basic)
            if SoDA:BasicEnabled() then group:AddChild(SoDA:Spacer()) end

            -- Currency
            local currency = SoDA:GetCurrencyGui(character)
            if SoDA:CurrencyEnabled() then
                group:AddChild(currency)
                group:AddChild(SoDA:Spacer())
            end

            -- Runes
            local runes = SoDA:GetRunesGui(character)
            if SoDA:RunesEnabled() then
                group:AddChild(runes)
                group:AddChild(SoDA:Spacer())
            end

            -- Books
            local books = SoDA:GetBooksGui(character)
            if SoDA:BooksEnabled() then
                group:AddChild(books)
                group:AddChild(SoDA:Spacer())
            end

            -- Raids
            local raids = SoDA:GetRaidsGui(character)
            if SoDA:RaidsEnabled() then
                group:AddChild(raids)
                group:AddChild(SoDA:Spacer())
            end

            -- PvP
            local pvp = SoDA:GetPvPGui(character)
            if SoDA:PvPEnabled() then
                group:AddChild(pvp)
                group:AddChild(SoDA:Spacer())
            end

            -- Factions
            local factions = SoDA:GetFactionsGui(character)
            if SoDA:FactionsEnabled() then
                group:AddChild(factions)
                group:AddChild(SoDA:Spacer())
            end

            -- Professions
            local professions = SoDA:GetProfessionsGui(character)
            if SoDA:ProfessionsEnabled() then
                group:AddChild(professions)
                group:AddChild(SoDA:Spacer())
            end

            f:AddChild(group)
        end
    end

    -- Make frame closable with ESC
    _G["SoDAGui"] = f.frame
    tinsert(UISpecialFrames, "SoDAGui")

    return f
end

function SoDA:Spacer()
    local spacer = self.aceGui:Create("Label")
    spacer:SetWidth(self.defaultWidth)
    spacer:SetText(" ")
    return spacer
end

function SoDA:Header(text)
    local header = self.aceGui:Create("Label")
    header:SetWidth(self.defaultWidth)
    header:SetText(text)
    header:SetFontObject(GameFontNormal)
    return header
end

function SoDA:LegendLabel(text)
    local label = self.aceGui:Create("Label")
    label:SetWidth(self.defaultWidth)
    label:SetText(text)
    return label
end

function SoDA:Legend()
    local legend = self.aceGui:Create("SimpleGroup")
    legend:SetWidth(self.defaultWidth)

    -- Basic
    legend:AddChild(SoDA:GetBasicLegend())
    if SoDA:BasicEnabled() then legend:AddChild(SoDA:Spacer()) end

    -- Currency
    if SoDA:CurrencyEnabled() then
        legend:AddChild(SoDA:GetCurrencyLegend())
        legend:AddChild(SoDA:Spacer())
    end

    -- Runes
    if SoDA:RunesEnabled() then
        legend:AddChild(SoDA:GetRunesLegend())
        legend:AddChild(SoDA:Spacer())
    end

    -- Books
    if SoDA:BooksEnabled() then
        legend:AddChild(SoDA:GetBooksLegend())
        legend:AddChild(SoDA:Spacer())
    end

    -- Raids
    if SoDA:RaidsEnabled() then
        legend:AddChild(SoDA:GetRaidsLegend())
        legend:AddChild(SoDA:Spacer())
    end

    -- PvP
    if SoDA:PvPEnabled() then
        legend:AddChild(SoDA:GetPvPLegend())
        legend:AddChild(SoDA:Spacer())
    end

    -- Factions
    if SoDA:FactionsEnabled() then
        legend:AddChild(SoDA:GetFactionsLegend())
        legend:AddChild(SoDA:Spacer())
    end

    -- Professions
    if SoDA:ProfessionsEnabled() then
        legend:AddChild(SoDA:GetProfessionsLegend())
        legend:AddChild(SoDA:Spacer())
    end

    return legend
end

function SoDA:Tooltip(frame, script)
    frame:SetScript("OnEnter", script)
    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    frame:SetScript("OnHide", function()
        frame:SetScript("OnEnter", nil)
        frame:SetScript("OnLeave", nil)
    end)
end
