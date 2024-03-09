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
    group:SetWidth(self.defaultWidth)

    if character.currency == nil then
        return group
    end

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- Gold
    local characterCopper = self.aceGui:Create("Label")
    characterCopper:SetWidth(self.defaultWidth)
    local moneyString = GetMoneyString(character.currency.copper)
    characterCopper:SetText(moneyString)
    group:AddChild(characterCopper)

    return group
end

function SoDA:GetCurrencyLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- Currency
    group:AddChild(SoDA:Header("Currency"))

    -- Gold
    group:AddChild(SoDA:LegendLabel("Gold"))

    return group
end
