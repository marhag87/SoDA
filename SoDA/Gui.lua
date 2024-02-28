function SoDA:Gui()
    local f = self.aceGui:Create("Frame")
    f:SetCallback("OnClose",function(widget) self.aceGui:Release(widget) end)
    f:SetTitle("Season of Discovery Alts")
    f:SetLayout("Flow")

    local numChararcters = 0
    for _ in pairs(self.db.global.characters) do
        numChararcters = numChararcters + 1
    end
    local width = (numChararcters * 120) + 160
    if width < 250 then
        width = 250
    end
    f:SetWidth(width)

    f:AddChild(SoDA:Legend())

    local characters = self.db.global.characters
    for guid,character in SoDA:spairs(characters, function(t, a, b) return t[b].basic.level < t[a].basic.level end) do
        local group = self.aceGui:Create("SimpleGroup")
        group:SetWidth(120)

        -- Basic
        group:AddChild(SoDA:GetBasicGui(character))
        group:AddChild(SoDA:Spacer())

        -- Currency
        group:AddChild(SoDA:GetCurrencyGui(character))
        group:AddChild(SoDA:Spacer())

        -- Runes
        group:AddChild(SoDA:GetRunesGui(character))
        group:AddChild(SoDA:Spacer())

        -- Books
        group:AddChild(SoDA:GetBooksGui(character))
        group:AddChild(SoDA:Spacer())

        -- Raids
        group:AddChild(SoDA:GetRaidsGui(character))
        group:AddChild(SoDA:Spacer())

        -- PvP
        group:AddChild(SoDA:GetPvPGui(character))
        group:AddChild(SoDA:Spacer())

        -- Factions
        group:AddChild(SoDA:GetFactionsGui(character))
        group:AddChild(SoDA:Spacer())

        -- Professions
        -- group:AddChild(SoDA:GetProfessionsGui(character))
        -- group:AddChild(SoDA:Spacer())

        f:AddChild(group)
    end

    -- Make frame closable with ESC
    _G["SoDAGui"] = f.frame
    tinsert(UISpecialFrames, "SoDAGui")

    return f
end

function SoDA:Spacer()
    local spacer = self.aceGui:Create("Label")
    spacer:SetText(" ")
    return spacer
end

function SoDA:Header(text)
    local header = self.aceGui:Create("Label")
    header:SetText(text)
    header:SetFontObject(GameFontNormal)
    return header
end

function SoDA:LegendLabel(text)
    local label = self.aceGui:Create("Label")
    label:SetText(text)
    return label
end

function SoDA:Legend()
    local legend = self.aceGui:Create("SimpleGroup")
    legend:SetWidth(120)

    -- Basic
    legend:AddChild(SoDA:GetBasicLegend())
    legend:AddChild(SoDA:Spacer())

    -- Currency
    legend:AddChild(SoDA:GetCurrencyLegend())
    legend:AddChild(SoDA:Spacer())

    -- Runes
    legend:AddChild(SoDA:GetRunesLegend())
    legend:AddChild(SoDA:Spacer())

    -- Books
    legend:AddChild(SoDA:GetBooksLegend())
    legend:AddChild(SoDA:Spacer())

    -- Raids
    legend:AddChild(SoDA:GetRaidsLegend())
    legend:AddChild(SoDA:Spacer())

    -- PvP
    legend:AddChild(SoDA:GetPvPLegend())
    legend:AddChild(SoDA:Spacer())

    -- Factions
    legend:AddChild(SoDA:GetFactionsLegend())
    legend:AddChild(SoDA:Spacer())

    -- Professions
    -- legend:AddChild(SoDA:GetProfessionsLegend())
    -- legend:AddChild(SoDA:Spacer())

    return legend
end
