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
    local group = self.aceGui:Create("SimpleGroup")

    if character.currency == nil then
        return group
    end

    -- Header
    local currencyHeader = self.aceGui:Create("Label")
    currencyHeader:SetText("Currency")
    group:AddChild(currencyHeader)

    -- Gold
    local characterCopper = self.aceGui:Create("Label")
    characterCopper:SetText(character.currency.copper)
    group:AddChild(characterCopper)

    return group
end
