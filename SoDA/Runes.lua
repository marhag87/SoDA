function SoDA:GetRunes()
    local runes = {}
    runes.numRunesKnown = C_Engraving.GetNumRunesKnown()
    local availableRunes = {
        ["ROGUE"] = {
            { ["id"] = "400080", ["spell"] = "399965" }, -- Deadly Brew
            { ["id"] = "400081", ["spell"] = "400009" }, -- Between the Eyes
            { ["id"] = "400082", ["spell"] = "400014" }, -- Just a Flesh Wound
            { ["id"] = "400093", ["spell"] = "400016" }, -- Rolling with the Punches
            { ["id"] = "400094", ["spell"] = "399956" }, -- Mutilate
            { ["id"] = "400095", ["spell"] = "398196" }, -- Quick Draw
            { ["id"] = "400096", ["spell"] = "399986" }, -- Shuriken Toss
            { ["id"] = "400099", ["spell"] = "400012" }, -- Blade Dance
            { ["id"] = "400101", ["spell"] = "400029" }, -- Shadowstep
            { ["id"] = "400102", ["spell"] = "399963" }, -- Envenom
            { ["id"] = "400105", ["spell"] = "399985" }, -- Shadowstrike
            { ["id"] = "415926", ["spell"] = "408700" }, -- Waylay
            { ["id"] = "424984", ["spell"] = "424785" }, -- Saber Slash
            { ["id"] = "424988", ["spell"] = "424799" }, -- Shiv
            { ["id"] = "424990", ["spell"] = "424919" }, -- Main Gauche
            { ["id"] = "424992", ["spell"] = "424925" }, -- Slaughter from the Shadows
            { ["id"] = "425102", ["spell"] = "425012" }, -- Poisoned Knife
            { ["id"] = "425103", ["spell"] = "425096" }, -- Master of Subtlety
        },
    }
    local numRunesAvailable = 0
    local runeMap = {}
    C_Engraving.RefreshRunesList() -- Maybe needed to make sure runes are loaded?
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