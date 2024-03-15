SoDA = LibStub("AceAddon-3.0"):NewAddon("SoDA", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("SoDALocale")
local SoDALDB = LibStub("LibDataBroker-1.1"):NewDataObject("SoDA", {
    type = "data source",
    text = "Season of Discovery Alts",
    icon = "Interface\\Icons\\Inv_misc_groupneedmore",
    OnClick = function(self, button)
        if button == "LeftButton" then
            SoDA:ToggleGui()
        elseif button == "RightButton" then
            SoDA:HideGui()
            SoDA:OpenConfig()
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("Season of Discovery Alts")
        tooltip:AddLine("|cFFCFCFCF" .. L["Left click"] .. ":|r " .. L["Open GUI"])
        tooltip:AddLine("|cFFCFCFCF" .. L["Right click"] .. ":|r " .. L["Open options"])
    end,
})
local icon = LibStub("LibDBIcon-1.0")

function SoDA:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SoDADB", {
        profile = {
            minimap = {
                hide = false,
            },
        },
    })
    self.aceGui = LibStub("AceGUI-3.0")
    SoDA:RegisterEvent("PLAYER_ENTERING_WORLD")
    SoDA:RegisterEvent("ENGRAVING_MODE_CHANGED")
    SoDA:RegisterEvent("QUEST_TURNED_IN")
    SoDA:RegisterEvent("UPDATE_INSTANCE_INFO")
    SoDA:RegisterEvent("BAG_UPDATE")
    SoDA:RegisterEvent("PLAYER_LOGOUT")
    SoDA:RegisterEvent("TRADE_SKILL_UPDATE")
    SoDA:RegisterChatCommand("soda", "ToggleGui")
    self.maxLevel = 40
    self.maxMountSpeed = 60
    self.maxProfessionRank = 225
    self.checkMark = "\124A:UI-LFG-ReadyMark:14:14\124a"
    self.runeCategories = {
        ["Chest"] = 5,
        ["Hands"] = 10,
        ["Legs"] = 7,
        ["Feet"] = 8,
        ["Waist"] = 6,
    }
    self.defaultWidth = 120
    self.weeklyReset = time() + C_DateAndTime.GetSecondsUntilWeeklyReset()
    icon:Register("SoDA", SoDALDB, self.db.profile.minimap)
    InterfaceOptions_AddCategory(SoDA:GetConfig())
    self.L = LibStub("AceLocale-3.0"):GetLocale("SoDALocale")
end

function SoDA:PLAYER_ENTERING_WORLD()
    SoDA:SaveData()
    RequestRaidInfo()
end

function SoDA:QUEST_TURNED_IN()
    C_Timer.After(1, function()
        SoDA:SaveData()
    end)
end

function SoDA:ENGRAVING_MODE_CHANGED()
    if self.loggedInCharacter == nil then return end
    self.db.global.characters[self.loggedInCharacter].runes = SoDA:GetRunes()
end

function SoDA:UPDATE_INSTANCE_INFO()
    if self.loggedInCharacter == nil then return end
    self.db.global.characters[self.loggedInCharacter].raids = SoDA:GetRaids()
end

function SoDA:BAG_UPDATE()
    if self.loggedInCharacter == nil then return end
    self.db.global.characters[self.loggedInCharacter].pvp = SoDA:GetPvP()
end

function SoDA:PLAYER_LOGOUT()
    if self.loggedInCharacter == nil then return end
    self.db.global.characters[self.loggedInCharacter].aura = SoDA:GetAuras()
end

function SoDA:TRADE_SKILL_UPDATE()
    if self.loggedInCharacter == nil then return end
    self.db.global.characters[self.loggedInCharacter].professions = SoDA:GetProfessions()
end

function SoDA:HideGui()
    if self.frame ~= nil and self.frame:IsVisible() then
        self.frame:Hide()
    end
end

function SoDA:ToggleGui()
    if self.frame ~= nil and self.frame:IsVisible() then
        self.frame:Hide()
    else
        SoDA:SaveData()
        self.frame = SoDA:Gui()
    end
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
    self.loggedInCharacter = basic.guid
    self.db.global.characters[basic.guid].currency = SoDA:GetCurrency()
    self.db.global.characters[basic.guid].factions = SoDA:GetFactions()
    self.db.global.characters[basic.guid].pvp = SoDA:GetPvP()
    self.db.global.characters[basic.guid].books = SoDA:GetBooks()
    self.db.global.characters[basic.guid].auras = SoDA:GetAuras()
    self.db.global.characters[basic.guid].professions = SoDA:GetProfessions()
end
