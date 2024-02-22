function SoDA:GetRunes()
    local runes = {}
    runes.numRunesKnown = C_Engraving.GetNumRunesKnown()
    local availableRunes = {
        ["DRUID"]   = SoDA:DruidRunes(),
        ["HUNTER"]  = SoDA:HunterRunes(),
        ["MAGE"]    = SoDA:MageRunes(),
        ["PALADIN"] = SoDA:PaladinRunes(),
        ["PRIEST"]  = SoDA:PriestRunes(),
        ["ROGUE"]   = SoDA:RogueRunes(),
        ["WARRIOR"] = SoDA:WarriorRunes(),
    }
    local numRunesAvailable = 0
    local runeMap = {}
    for class,classRunes in pairs(availableRunes) do
        if class == self.db.global.characters[self.loggedInCharacter].basic.class then
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
    local numRunesKnown = "?"
    local numRunesAvailable = "?"

    if character.runes ~= nil then
        numRunesKnown = character.runes.numRunesKnown
        numRunesAvailable = character.runes.numRunesAvailable
    end

    -- Header
    local currencyHeader = self.aceGui:Create("Label")
    currencyHeader:SetText("Runes")
    group:AddChild(currencyHeader)

    -- Runes known
    local runesKnown = self.aceGui:Create("Label")
    if numRunesKnown == numRunesAvailable and numRunesKnown ~= "?" then
        runesKnown:SetColor(0, 1, 0)
    end
    runesKnown:SetText(numRunesKnown .. "/" .. numRunesAvailable)
    group:AddChild(runesKnown)

    return group
end