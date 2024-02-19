function SoDA:Gui()
    local AceGUI = LibStub("AceGUI-3.0")
    local f = AceGUI:Create("Frame")
    f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    f:SetTitle("Season of Discovery Alts")
    f:SetLayout("Flow")

    local numChararcters = 0
    for _ in pairs(self.db.global.characters) do
        numChararcters = numChararcters + 1
    end
    local width = (numChararcters * 200) + 50
    f:SetWidth(width)

    for guid,character in pairs(self.db.global.characters) do
        local group = AceGUI:Create("InlineGroup")
        
        group:SetWidth(200)
        local character = character[1]

        -- Name label
        local characterName = AceGUI:Create("Label")
        characterName:SetText(character.basic.name)
        group:AddChild(characterName)
        -- Currency
        local characterCopper = AceGUI:Create("Label")
        characterCopper:SetText(character.currency.copper)
        group:AddChild(characterCopper)
        
        f:AddChild(group)
    end
end