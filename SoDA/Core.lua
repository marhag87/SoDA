SoDA = LibStub("AceAddon-3.0"):NewAddon("SoDA", "AceConsole-3.0", "AceEvent-3.0")

function SoDA:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SoDADB")
    self.aceGui = LibStub("AceGUI-3.0")
    SoDA:RegisterEvent("PLAYER_LOGIN")
end

function SoDA:PLAYER_LOGIN()
    SoDA:SaveData()
    SoDA:Gui()
end

function SoDA:SaveData()
    local character = {}
    character.basic = SoDA:GetBasicInformation()
    character.currency = SoDA:GetCurrency()
    self.loggedInCharacter = character -- TODO: Runes has dependencies, how to handle?
    character.runes = SoDA:GetRunes()
    character.raids = SoDA:GetRaids()
    if self.db.global.characters == nil then
        self.db.global.characters = {}
    end
    self.db.global.characters[character.basic.guid] = {character}

    self.loggedInCharacter = character
end
