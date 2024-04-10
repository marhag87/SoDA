function SoDA:GetCurrency()
    local currency = {}

    -- Gold
    local copper = GetMoney()
    currency.copper = copper

    -- Wild Offering
    currency.wildOffering = GetItemCount(221262, true)

    -- Emerald Chip
    currency.emeraldChip = GetItemCount(219927, true)

    return currency
end

function SoDA:GetCurrencyGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings

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
    if s.Gold == nil or s.Gold then
        group:AddChild(characterCopper)
    end

    -- Wild Offering
    local wildOffering = character.currency.wildOffering or 0
    local wildOfferingLabel = self.aceGui:Create("Label")
    wildOfferingLabel:SetWidth(self.defaultWidth)
    wildOfferingLabel:SetText(wildOffering)
    if s["Wild Offering"] == nil or s["Wild Offering"] then
        group:AddChild(wildOfferingLabel)
    end

    -- Wild Offering
    local emeraldChip = character.currency.emeraldChip or 0
    local emeraldChipLabel = self.aceGui:Create("Label")
    emeraldChipLabel:SetWidth(self.defaultWidth)
    emeraldChipLabel:SetText(emeraldChip)
    if s["Emerald Chip"] == nil or s["Emerald Chip"] then
        group:AddChild(emeraldChipLabel)
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

    return group
end

function SoDA:GetCurrencyLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local s = self.db.global.settings

    -- Currency
    group:AddChild(SoDA:Header(self.L["Currency"]))

    -- Gold
    if s.Gold == nil or s.Gold then
        local goldLabel = SoDA:LegendLabel(self.L["Gold"])
        -- Gold label tooltip
        SoDA:Tooltip(goldLabel.frame, function()
            SoDA:GoldLabelTooltip(goldLabel.frame)
        end)
        group:AddChild(goldLabel)
    end

    -- Wild Offering
    if s["Wild Offering"] == nil or s["Wild Offering"] then
        group:AddChild(SoDA:LegendLabel(self.L["Wild Offering"]))
    end

    -- Emerald Chip
    if s["Emerald Chip"] == nil or s["Emerald Chip"] then
        group:AddChild(SoDA:LegendLabel(self.L["Emerald Chip"]))
    end

    -- Spacer
    group:AddChild(SoDA:Spacer())

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

function SoDA:CurrencyEnabled()
    local s = self.db.global.settings
    local gold = s.Gold
    if gold == nil then gold = true end
    local wildOffering = s["Wild Offering"]
    if wildOffering == nil then wildOffering = true end
    local emeraldChip = s["Emerald Chip"]
    if emeraldChip == nil then emeraldChip = true end
    return gold or wildOffering or emeraldChip
end
