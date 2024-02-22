function SoDA:Gui()
    local f = self.aceGui:Create("Frame")
    f:SetCallback("OnClose",function(widget) self.aceGui:Release(widget) end)
    f:SetTitle("Season of Discovery Alts")
    f:SetLayout("Flow")

    local numChararcters = 0
    for _ in pairs(self.db.global.characters) do
        numChararcters = numChararcters + 1
    end
    local width = (numChararcters * 120) + 40
    f:SetWidth(width)

    local characters = self.db.global.characters
    for guid,character in SoDA:spairs(characters, function(t, a, b) return t[b].basic.level < t[a].basic.level end) do
        local group = self.aceGui:Create("SimpleGroup")
        group:SetWidth(120)

        -- Basic
        local basic = SoDA:GetBasicGui(character)
        group:AddChild(basic)
        group:AddChild(SoDA:Spacer())

        -- Currency
        local currency = SoDA:GetCurrencyGui(character)
        group:AddChild(currency)
        group:AddChild(SoDA:Spacer())

        -- Runes
        local runes = SoDA:GetRunesGui(character)
        group:AddChild(runes)
        group:AddChild(SoDA:Spacer())

        -- Raids
        local raids = SoDA:GetRaidsGui(character)
        group:AddChild(raids)
        group:AddChild(SoDA:Spacer())

        -- PvP
        local pvp = SoDA:GetPvPGui(character)
        group:AddChild(pvp)
        group:AddChild(SoDA:Spacer())

        -- Factions
        local factions = SoDA:GetFactionsGui(character)
        group:AddChild(factions)
        group:AddChild(SoDA:Spacer())

        f:AddChild(group)
    end
end

function SoDA:Spacer()
    local spacer = self.aceGui:Create("Label")
    spacer:SetText(" ")
    return spacer
end
