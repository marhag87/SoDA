function SoDA:GetRunes()
    local runes = {}
    runes.numRunesKnown = C_Engraving.GetNumRunesKnown()
    local availableRunes = {
        ["DRUID"] = SoDA:DruidRunes(),
        ["PALADIN"] = SoDA:PaladinRunes(),
        ["ROGUE"] = SoDA:RogueRunes(),
        ["WARRIOR"] = SoDA:WarriorRunes(),
    }
    local numRunesAvailable = 0
    local runeMap = {}
    -- TODO: Runes are not loaded, is there an event we can wait for?
    -- https://warcraft.wiki.gg/wiki/Category:API_namespaces/C_Engraving
    for class,classRunes in pairs(availableRunes) do
        if class == self.loggedInCharacter.basic.class then
            for _,v in ipairs(classRunes) do
                numRunesAvailable = numRunesAvailable + 1
                local name, _ = GetSpellInfo(v.spell)
                local isKnown = C_Engraving.IsKnownRuneSpell(v.id)
                table.insert(runeMap, {["id"] = v.id, ["spell"] = v.spell, ["known"] = isKnown})
            end
        end
    end
    runes.numRunesAvailable = numRunesAvailable
    runes.runeMap = runeMap
    return runes
end

function SoDA:GetRunesGui(character)
    local group = self.aceGui:Create("SimpleGroup")

    if character.runes == nil then
        return group
    end

    -- Header
    local currencyHeader = self.aceGui:Create("Label")
    currencyHeader:SetText("Runes")
    group:AddChild(currencyHeader)

    -- Runes known
    local numRunesKnown = self.aceGui:Create("Label")
    numRunesKnown:SetText(character.runes.numRunesKnown .. "/" .. character.runes.numRunesAvailable)
    group:AddChild(numRunesKnown)

    return group
end