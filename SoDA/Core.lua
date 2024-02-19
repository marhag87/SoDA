SoDA = LibStub("AceAddon-3.0"):NewAddon("SoDA", "AceConsole-3.0", "AceEvent-3.0")

function SoDA:OnInitialize()
    SoDA:Print("Hello, world!")
    self.db = LibStub("AceDB-3.0"):New("SoDADB")
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
    if self.db.global.characters == nil then
        self.db.global.characters = {}
    end
    self.db.global.characters[character.basic.guid] = {character}

    self.loggedInCharacter = character
end