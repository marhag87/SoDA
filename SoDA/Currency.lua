function SoDA:GetCurrency()
    local currency = {}
    local copper = SoDA:GetCopper()
    currency.copper = copper
    return currency    
end

function SoDA:GetCopper()
    local copper = GetMoney()
    return copper
end

function SoDA:GetCurrencyGui(character)
    local characterCopper = self.aceGui:Create("Label")
    characterCopper:SetText(character.currency.copper)
    return characterCopper
end
