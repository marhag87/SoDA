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
