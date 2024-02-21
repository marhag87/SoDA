SoDA = LibStub("AceAddon-3.0"):NewAddon("SoDA", "AceConsole-3.0", "AceEvent-3.0")

function SoDA:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SoDADB")
    self.aceGui = LibStub("AceGUI-3.0")
    SoDA:RegisterEvent("PLAYER_LOGIN")
    SoDA:RegisterEvent("ENGRAVING_MODE_CHANGED")
end

function SoDA:PLAYER_LOGIN()
    SoDA:SaveData()
    SoDA:Gui()
end

function SoDA:ENGRAVING_MODE_CHANGED()
    self.db.global.characters[self.loggedInCharacter].runes = SoDA:GetRunes()
end

function SoDA:SaveData()
    if self.db.global.characters == nil then
        self.db.global.characters = {}
    end
    local basic = SoDA:GetBasicInformation()
    if self.db.global.characters[basic.guid] == nil then
        self.db.global.characters[basic.guid] = {}
    end
    self.db.global.characters[basic.guid].basic = basic
    self.db.global.characters[basic.guid].currency = SoDA:GetCurrency()
    self.db.global.characters[basic.guid].raids = SoDA:GetRaids() -- TODO: Raids are not loaded at login, when can we fetch?
    self.loggedInCharacter = basic.guid
end
