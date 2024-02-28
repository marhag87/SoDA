function SoDA:GetRunes()
    local runes = {}

    -- Known runes
    runes.numRunesKnown = C_Engraving.GetNumRunesKnown()
    local availableRunes = {
        ["DRUID"]   = SoDA:DruidRunes(),
        ["HUNTER"]  = SoDA:HunterRunes(),
        ["MAGE"]    = SoDA:MageRunes(),
        ["PALADIN"] = SoDA:PaladinRunes(),
        ["PRIEST"]  = SoDA:PriestRunes(),
        ["ROGUE"]   = SoDA:RogueRunes(),
        ["SHAMAN"]  = SoDA:ShamanRunes(),
        ["WARLOCK"] = SoDA:WarlockRunes(),
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

    -- Grizzby
    local grizzbyQuest = {["Horde"] = 78304, ["Alliance"] = 78297}
    local faction, _ = UnitFactionGroup("player")
    runes.grizzby = C_QuestLog.IsQuestFlaggedCompleted(grizzbyQuest[faction])

    return runes
end

function SoDA:GetRunesGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    local runes = character.runes or {}
    local numRunesKnown = runes.numRunesKnown or "?"
    local numRunesAvailable = runes.numRunesAvailable or "?"

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- Runes known
    local runesKnown = self.aceGui:Create("Label")
    if numRunesKnown == numRunesAvailable and numRunesKnown ~= "?" then
        runesKnown:SetColor(0, 1, 0)
    end
    runesKnown:SetText(numRunesKnown .. "/" .. numRunesAvailable)
    group:AddChild(runesKnown)

    -- Grizzby
    local grizzby = self.aceGui:Create("Label")
    grizzby:SetText(" ")
    if runes.grizzby then
        grizzby:SetText(self.checkMark)
    end
    group:AddChild(grizzby)

    -- TODO: Dark Riders

    return group
end

function SoDA:GetRunesLegend()
    local group = self.aceGui:Create("SimpleGroup")

    -- Runes
    group:AddChild(SoDA:Header("Runes"))

    -- Runes
    group:AddChild(SoDA:LegendLabel("Runes"))

    -- Runes
    group:AddChild(SoDA:LegendLabel("Grizzby"))

    return group
end
