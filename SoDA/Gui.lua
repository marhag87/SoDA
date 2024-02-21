function SoDA:Gui()
    local f = self.aceGui:Create("Frame")
    f:SetCallback("OnClose",function(widget) self.aceGui:Release(widget) end)
    f:SetTitle("Season of Discovery Alts")
    f:SetLayout("Flow")

    local numChararcters = 0
    for _ in pairs(self.db.global.characters) do
        numChararcters = numChararcters + 1
    end
    local width = (numChararcters * 200) + 50
    f:SetWidth(width)

    for guid,character in pairs(self.db.global.characters) do
        local group = self.aceGui:Create("SimpleGroup")
        group:SetWidth(200)
        local character = character[1]

        -- Basic
        local basic = SoDA:GetBasicGui(character)
        group:AddChild(basic)

        -- Currency
        local currency = SoDA:GetCurrencyGui(character)
        group:AddChild(currency)

        f:AddChild(group)
    end
end
