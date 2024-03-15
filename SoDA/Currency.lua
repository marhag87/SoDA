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
    group:AddChild(SoDA:Header(self.L["Currency"]))

    -- Gold
    local goldLabel = SoDA:LegendLabel(self.L["Gold"])
    -- Gold label tooltip
    SoDA:Tooltip(goldLabel.frame, function()
        SoDA:GoldLabelTooltip(goldLabel.frame)
    end)
    group:AddChild(goldLabel)

    return group
end

function SoDA:GoldLabelTooltip(frame)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.L["Gold"])
    GameTooltip:AddLine(" ")
    local total = 0
    local money = {}
    for _, character in pairs(self.db.global.characters) do
        -- Total
        local currency = character.currency or {}
        local copper = currency.copper or 0
        total = total + copper

        -- Realm
        local basic = character.basic or {}
        local realm = basic.realm
        local faction = basic.faction
        if realm ~= nil and faction ~= nil then
            if money[realm] == nil then
                money[realm] = {}
                money[realm].total = 0
                money[realm].Alliance = 0
                money[realm].Horde = 0
            end
            money[realm].total = money[realm].total + copper
            money[realm][faction] = money[realm][faction] + copper
        end
    end

    GameTooltip:AddDoubleLine(self.L["Total"], GetMoneyString(total))
    for realmName, realm in pairs(money) do
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(realmName, GetMoneyString(realm.total))
        if realm.Alliance > 0 then
            GameTooltip:AddDoubleLine("|cffffffff" .. self.L["Alliance"] .. FONT_COLOR_CODE_CLOSE,
                GetMoneyString(realm.Alliance))
        end
        if realm.Horde > 0 then
            GameTooltip:AddDoubleLine("|cffffffff" .. self.L["Horde"] .. FONT_COLOR_CODE_CLOSE,
                GetMoneyString(realm.Horde))
        end
    end
    GameTooltip:Show()
end
